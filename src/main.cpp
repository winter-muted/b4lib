
#include "BusDevice.h"
#include "Global.h"
#include "I2CDevice.h"
// #include "MMA8451.h"
#include "lsquaredc.h"

#include <exception>
#include <fcntl.h>
#include <iomanip>
#include <iostream>

// #include <pruss_intc_mapping.h>
// #include <prussdrv.h>
// #include <stdio.h>
// #define PRU_NUM 0

using namespace b4lib;

int main() {

  // D(std::cout << "Running in Debug Mode...\n";)
  // I2CDevice i2c(1, 0x1D);
  //
  // try {
  //   i2c.begin();
  // } catch (std::exception &e) {
  //   if (e.what() == "std::bad_alloc") // bus didnt open
  //     return (1);
  //   D(std::cout << "Exception caught: " e.what() << "\n";)
  // }
  //
  // i2c.readRegister(0x0D);
  // i2c.writeRegister(0x2A, 5);
  // //
  // // i2c.writeRegister(0x00, 1);
  // // i2c.readRegister(0x40);
  //
  // // std::cout << HEX(i2c.readRegister(0x00)) << "\n";
  // i2c.writeRegister(0x2B, 0x40);
  // // std::cout << i2c.readRegister(0x00) << "\n";
  // // i2c.end();

  // tpruss_intc_initdata pruss_intc_initdata = PRUSS_INTC_INITDATA;
  //
  // prussdrv_init();
  //
  // prussdrv_open(PRU_EVTOUT_0);
  //
  // prussdrv_pruintc_init(&pruss_intc_initdata);
  //
  // prussdrv_exec_program(PRU_NUM, "./pru-hello-world.bin");
  //
  // int n = prussdrv_pru_wait_event(PRU_EVTOUT_0);
  //
  // printf("Hello-world PRU program completed, event number %d.\n", n);
  //
  // prussdrv_pru_disable(PRU_NUM);
  //
  // prussdrv_exit();
}
