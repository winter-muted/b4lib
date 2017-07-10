#ifndef BUSDEVICE_H
#define BUSDEVICE_H

namespace b4lib {

class BusDevice {
public:
  BusDevice(unsigned int bus, unsigned int addr)
      : bus(bus), device_addr(addr){};

  virtual void begin() = 0;

  virtual int writeRegister(unsigned int addr, unsigned char val) = 0;
  virtual int readRegister(unsigned int addr) = 0;

  /* decide if you want to add plural forms of above functions
     as convenience functions
  */

  virtual void debugDumpRegisters() = 0;

  virtual void end() = 0;

  virtual ~BusDevice(){};

protected:
  int bus, device_addr;
};
}

#endif
