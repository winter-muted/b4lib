// Basic UART usage on the PRU
// This has to run on PRU1 as it seems
// there are only GPIO pins for that PRU
#define PRU0_R31_VEC_VALID 32         // notify program completion
#define PRU_EVTOUT_0 3                // event number sent back


#define UART_BASE_ADDR 0x00028000
#define DLL 0x00028020    // MSB of baud rate divisor
#define DLH 0x00028024    // LSB of baud rate divisor
#define LCR 0x0002800C    // LCR register
#define PWR 0x00028030    // power control register
#define MDR 0x00028034    // oversample mode register
#define MCR 0x00028010    // modem control register

#define RBR 0x00028000    // receive buffer
#define THR 0x00028000    // transmit buffer

#define IER 0x00028004    // interrupt register
#define FCR 0x00028008    // fifo register

// these divisor settings configure for 115200 baud at 16x oversampling mode
// the values will change if 13x oversampling is used.
#define BAUD_MSB 0x13
#define BAUD_LSB 0x88
#define OVERSAMPLE 0x0
#define CONTROL_MASK 0x3
#define ENABLE_MASK 0x6001
#define DISABLE_MASk 0x0
#define INTERRUPT_MASK 0x7
#define FIFO_MASK 0b1111
#define DEBUG_MASK 0x10


.origin 0
.entrypoint SETUP

// Setup the System
SETUP:

// we assume the pins are multiplexed properly and skip directly to setting baud

// configure the baud rate and oversampling
  mov r1,DLL
  mov r2,BAUD_MSB
  sbbo r2,r1,0,4

  mov r1,DLH
  mov r2,BAUD_LSB
  sbbo r2,r1,0,4

  mov r1,MDR
  mov r2,OVERSAMPLE
  sbbo r2,r1,0,4

// we would optionally configure the FIFO behavior here
// mov r1,FCR
// mov r2,FIFO_MASK
// sbbo r2,r1,0,1

// configure the LCR for 8 data bits, no parity, 1 stop bits
  mov r1,LCR
  mov r2,CONTROL_MASK
  sbbo r2,r1,0,1

// // configure the loopback
// mov r1,MCR
// mov r2,DEBUG_MASK
// sbbo r2,r1,0,1

// enable receive buffer


// enable the uart receiver and transmitter
  mov r1,PWR
  mov r2,ENABLE_MASK
  sbbo r2,r1,0,4


// Output two characters
WRITE:
  mov r1,THR
  mov r2,0b0100
  sbbo r2,r1,0,1

// DEBUG_READ:
//   mov r1,RBR
//   lbbo r3,r1,0,2
// // Disable and Exit
TEARDOWN:



// // disable the uart receiver and transmitter
//   mov r1,PWR
//   mov r2,DISABLE_MASk
//   sbbo r2,r1,0,4
//
//   // check that the uart has been turned off
//   mov r1, PWR
//   lbbo r2,r1,0,1
//   mov r1,0x00002000
//   sbbo r2,r1,4,4

// Exit
END:
  mov  r31.b0,PRU0_R31_VEC_VALID | PRU_EVTOUT_0  // notify of program completion
  halt
