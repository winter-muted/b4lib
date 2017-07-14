
#include <pruss_intc_mapping.h>
#include <prussdrv.h>
#include <stdio.h>
#define PRU_NUM 0

#ifdef DEBUG
#define D(x) x
#else
#define D(x)
#endif

//using namespace b4lib;

int main() {

  D(printf("beginning program...\n");)
  tpruss_intc_initdata pruss_intc_initdata = PRUSS_INTC_INITDATA;

  D(printf("Init prussdrv\n");)
  prussdrv_init();

  D(printf("Still init...\n");)
  prussdrv_open(PRU_EVTOUT_0);

  D(printf("Map PRU interrupts\n");)
  prussdrv_pruintc_init(&pruss_intc_initdata);

  D(printf("Execute program\n");)
  prussdrv_exec_program(PRU_NUM, "./I2CPRU.bin");

  D(printf("Wait for return\n");)
  int n = prussdrv_pru_wait_event(PRU_EVTOUT_0);

  printf("Hello-world PRU program completed, event number %d.\n", n);

  prussdrv_pru_disable(PRU_NUM);

  prussdrv_exit();
}
