#ifndef I2CDEVICE_H
#define I2CDEVICE_H

#include "BusDevice.h"
#include "Global.h"
#include "lsquaredc.h"
#include <exception>
#include <iostream>
#include <linux/i2c-dev.h>
#include <linux/i2c.h>
#include <string>

namespace b4lib {

class I2CDevice : protected BusDevice {
public:
  I2CDevice(unsigned int bus, unsigned int addr);

  virtual void begin();

  virtual int writeRegister(unsigned int addr, unsigned char val);
  virtual int readRegister(unsigned int addr);

  /* decide if you want to add plural forms of above functions
     as convenience functions
  */

  virtual void debugDumpRegisters();

  virtual void end();

  ~I2CDevice();

private:
  int file;
};
}

#endif
