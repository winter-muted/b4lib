// a simple program that measures the number
// of cycles required for a code block
// this program writes the result to global memory
// and exits
.origin 0
.entrypoint START

#define PRU0_R31_VEC_VALID 32         // notify program completion
#define PRU_EVTOUT_0 3                // event number sent back



START:
//modify the CTPPR_0 register to allow us to
// access the control registers directly
  // mov R1, CTPPR_0
  // mov R2, 0x00000220          // C28
  // SBBO &R2, R1, 0, 4
  //
  // LBCO &R1, C28, 0, 4         // enables the cycle counter
  // set R1,3                    // set bit 3 of register and write back
  // SBCO &R1, C28, 0 ,4


// now we "start" the "timer", storing the start time in R1
  // LBCO &R1, , 0xC,4        // then fall through to measureme
  // mov r1, 0x0002200C
  // qba MEASURE_ME



    // Make C28 point to the PRU control registers
  MOV    r0, 0x00022028
  MOV    r1, 0x00000220
  SBBO   r1, r0, 0, 4

  // Enable cycle counter by setting bit 3 (COUNTENABLE) of the
  // control register
  LBCO   r2, C28, 0, 4
  SET    r2.t3
  SBCO   r2, C28, 0, 4

  LBCO   r2, C28, 0xC, 4

// this should take 5 clock cycles
MEASURE_ME:
  // mov r0, r0
  mov r0, r0
  mov r0, r0
  mov r0, r0
  mov r0, r0
  // qba FINISH


FINISH:
// stop the timer, store state in r2
  // lbco &R2, C28, 0xC, 4
  // mov r2, 0x0002200C

  LBCO   r1, C28, 0xC, 4

// get the difference, store in r3

  sub r3,r1,r2
  // mov r3,0

// write result to data RAM0, offset 4
  mov r0,0x00002000
  sbbo r3,r0,4,4
  mov  r31.b0,PRU0_R31_VEC_VALID | PRU_EVTOUT_0  // notify of program completion
  halt
