// Implements I2C via bitbanging on the PRU.
// for now, can only do single byte read/write with repeated start
// condition set as the master.

// read the address of the I2C slave device from global memory
// determine whether to read or write
// if reading, determine the register address of the device to read
// if writing, determine the address and value to write

// we expect the slave to take some (unknown) number of clock cycles
// to respond.  We'll read a value as our upper limit to wait
// before giving up and reporting the error

// the pru runs at 200MHz.  standard I2C operates at 100kHz and thus we must
// toggle the clock every 200e6 / 100e3 = 2000 cycles.
// from this, it is clear that I2C-superfast mode could also be supported
// (400 cycles between clock pules)
// but, we have to track clock cycles with no (or low) overhead.
// for now, the best way to do this seems to be dedicating a register counter
// that counts instructions executed since the last clock toggle,
// and defining a few constant labels for each code section.
// in the future, using the address of each code label would likely prove
// to be more portable

// **********************************************
// CONSTANTS
#define I2C_PERIOD 0x3E8

// RESERVED REGISTERS
#define I2C_PERIOD_REGISTER r12
#define SCL r30.t1
#define SDA r31
#define DATA_IN r6.w0         // two 8 bit fields to store the most recently
#define DATA_OUT r7        // read/written byte


// MACROS

// define a "start" and "stop" timer macro
.macro start_time
.mparam reg=r1
  LBCO reg,C28,0xC,4
.endm

.macro stop_time
.mparam reg=r2
  LBCO reg,C28,0xC,4
.endm

// OTHER
#define PRU0_R31_VEC_VALID 32         // notify program completion
#define PRU_EVTOUT_0 3                // event number sent back



// **********************************************
.origin 0
.entrypoint START


START:
  // read slave address
  // store read/write flag
  // branch to read/write section


  // enable timer function
  // Make C28 point to the PRU control registers
  // there's a few things I don't understand about
  // this block, but it seems to work...
  MOV    r0, 0x00022028
  MOV    r1, 0x00000220
  SBBO   r1, r0, 0, 4

  // Enable cycle counter by setting bit 3 (COUNTENABLE) of the
  // control register
  LBCO   r2, C28, 0, 4
  SET    r2.t3
  SBCO   r2, C28, 0, 4

  // store the clock cycle time in a register for easy compare
  mov I2C_PERIOD_REGISTER,I2C_PERIOD

  mov r4, 1000

  // use a whole register to store the clock state :(
  // mov r5, 65535

  // test sending out the stream 0101 in a clocked fashion
  mov DATA_OUT, 0b00011101
  mov r10,8     // this byte counter

  start_time

  //


READ_SETUP:
  // timeout code
  qbeq END,r4,0
  sub r4,r4,1


READ:

  // qbbs TOGGLE_CLOCK,r6.t0

  // qbeq END, r10, 0
  // sub r10,r10,1
  // clock out a bit
  // call PUSH_SDA

// this label toggles the clock state. it is important that
// the runtime be equal for each toggle direction
TOGGLE_CLOCK:
  // get the clock time and wait until it is time to
  // toggle the clcok
  stop_time
  sub r3, r2, r1
  mov r29, r29  // this is intended to be a no-op, since
                // there's a loop init off-by-one
                // on the next line
WAIT:
  add r3,r3,2
  qbge WAIT,r3,I2C_PERIOD_REGISTER

  // flip the clock bit
  qbbc CLOCK_ON,SCL
  clr SCL
  qba FINISH_CLOCK

CLOCK_ON:
  set SCL

FINISH_CLOCK:
  // reset the clock in preparation for the next byte
  start_time



  // NOT the action bit
  NOT r6,r6

  // jump to SDA write code
  qba READ_SETUP

END:
  mov   r31.b0,PRU0_R31_VEC_VALID | PRU_EVTOUT_0  // notify of program completion
  halt

// this block of code handles setting the output pin on SDA
// the only exit point is from DONE_SET, and returns to the calling
// instruction.  Note that it will logically shift a register on each invocation
// and thus has register file side effects.
// -----------------------
PUSH_SDA:
  qbbs GIVE_SET, DATA_OUT.t7
  qbbc GIVE_CLR, DATA_OUT.t7
DONE_SET:
  LSL DATA_OUT,DATA_OUT,1
  ret
GIVE_SET:
  set SDA.t3
  // mov r31.b0
  qba DONE_SET
GIVE_CLR:
  // clr SDA.t3
  qba DONE_SET
// -----------------------


// // This block of code reads a bit on the data line and shifts the storage
// // register
// PULL_SDA:
//   qbbs GET_SET, SDA
//   qbbc GET_CLR, SDA
// DONE_PULL:
//   LSR DATA_IN,DATA_IN,1
//   ret
// GET_SET:
//   set DATA_IN.t7
//   qba DONE_PULL
// GET_CLR:
//   clr DATA_IN.t7
//   qba DONE_PULL
