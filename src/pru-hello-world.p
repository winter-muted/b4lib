.origin 0                             // start of program in memory
.entrypoint START                     // program entrypoint

#define INS_PER_US 200                // 200 MHz proc uses 5ns per cycle
#define INS_PER_DELAY_LOOP 2          // our delay loop takes two 1 cycle instr.

#define DELAY 50*1000*(INS_PER_US/INS_PER_DELAY_LOOP)   // this gives 50ms delay
#define PRU0_R31_VEC_VALID 32         // notify program completion
#define PRU_EVTOUT_0 3                // event number sent back

START:
  set   r30.t5        // set bit 5 of output pin high
  mov   r0,DELAY      // set delay counter to full
DELAYON:
  sub   r0,r0,1       // subtract 1 from delay counter
  qbne  DELAYON,r0,0  // loop back if not done with delay
LEDOFF:
  clr   r30.t5        // turn off output pin
  mov   r0,DELAY      // set delay counter
DELAYOFF:
  sub   r0,r0,1
  qbne  DELAYOFF,r0,0 // continue looping until r0 = 0
  qbbc  START,r31.t3  // if button pressed, done
END:
  mov   r31.b0,PRU0_R31_VEC_VALID | PRU_EVTOUT_0  // notify of program completion
  halt
