#ifndef MMA8451_H
#define MMA8451_H

#include "BusDevice.h"
#include <vector>

namespace b4lib {
class MMA8451 {
public:
  MMA8451(BusDevice &bus_d) : bus_d(bus_d) {}

  void init();

  std::vector<double> getXYZData();
  std::vector<double> getOrientation();

  int setMode();

private:
  const BusDevice &bus_d;
};
}

#endif
