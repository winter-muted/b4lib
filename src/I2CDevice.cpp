#include "I2CDevice.h"

namespace b4lib {

I2CDevice::I2CDevice(unsigned int bus, unsigned int addr)
    : BusDevice(bus, addr) {}

I2CDevice::~I2CDevice() {
  if (this->file != 0)
    this->end();
}

/* Opens the file using the linux i2c library and lsquaredc
   This functions throws! */
void I2CDevice::begin() {

  if (this->file > 0) { // file already open, alert and continue
    b4lib::contention e;
    throw e;
  }

  this->file = i2c_open(this->bus);

  if (this->file < 0) { // could not open bus
    std::bad_alloc e;
    throw e;
  }
}

/* uses lsquaredc to craft and send a write packet to the i2c device
   shift the address left once, with the new empty bit the r/w flag */
int I2CDevice::writeRegister(unsigned int addr, unsigned char val) {

  uint16_t seq[] = {(device_addr << 1), addr, val};

  int result = 0;
  result = i2c_send_sequence(this->file, seq, 3, 0);

  D(std::cout << "Result on write: " << result << "\n";)
  return result;
}

/* uses lsquaredc to read a register with I2C_RESTART. the read value
   is returned as int */
int I2CDevice::readRegister(unsigned int addr) {

  uint16_t seq[] = {(device_addr << 1), addr, I2C_RESTART,
                    (device_addr << 1) | 1, I2C_READ};

  uint8_t ret;
  int result = 0;

  result = i2c_send_sequence(this->file, seq, 5, &ret);

  D(std::cout << "Result on read: " << result << "\n";)

  return (int)ret;
}

void I2CDevice::debugDumpRegisters() {}

void I2CDevice::end() {
  this->file = i2c_close(this->file);
  D(std::cout << "The 'closed' filehandle is " << this->file << "\n";)
}
}
