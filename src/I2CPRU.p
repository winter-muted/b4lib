# Implements I2C via bitbanging on the PRU.
# for now, can only do single byte read/write with repeated start
# condition set as the master.

# read the address of the I2C slave device from global memory
# determine whether to read or write
# if reading, determine the register address of the device to read
# if writing, determine the address and value to write

# we expect the slave to take some (unknown) number of clock cycles
# to respond.  We'll read a value as our upper limit to wait
# before giving up and reporting the error

# the pru runs at 200MHz.  standard I2C operates at 100kHz and thus we must
# toggle the clock every 200e6 / 100e3 = 2000 cycles.
# from this, it is clear that I2C-superfast mode could also be supported
# (400 cycles between clock pules)
# but, we have to track clock cycles with no (or low) overhead.
# for now, the best way to do this seems to be dedicating a register counter
# that counts instructions executed since the last clock toggle,
# and defining a few constant labels for each code section.
# in the future, using the address of each code label would likely prove
# to be more portable



.origin 0
.entrypoint START



START:
  # read slave address
  # store read/write flag
  # branch to read/write section

READ_SETUP:
  # store register address to read


WRITE_SETUP:


# this label toggles the clock state. it is important that
# the runtime be equal for each toggle direction
TOGGLE_CLOCK:
