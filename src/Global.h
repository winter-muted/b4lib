#ifndef GLOBAL_H
#define GLOBAL_H

#include <exception>

// debug marcro
#ifdef DEBUG
#define D(x) x
#else
#define D(x)
#endif

// hex print macro
#define HEX(x) std::setw(2) << std::setfill('0') << std::hex << (int)(x)

// a couple of exception classes
namespace b4lib {

class contention : public std::exception {
public:
  virtual const char *what() const throw() {
    return "Resource Already initialized";
  }
};
}

#endif
