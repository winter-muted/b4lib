TARGET_EXEC ?= b4lib

BUILD_DIR ?= ./build
SRC_DIRS ?= ./src ./lib

CC = gcc
CXX = g++
AS = pasm

SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.p)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))


CPPFLAGS ?= $(INC_FLAGS) -fpermissive -O2 -lprussdrv
ASFLAGS = -b

all : $(BUILD_DIR)/$(TARGET_EXEC)

debug : CPPFLAGS += -DDEBUG -g
debug : all

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

# assembly
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@
	#

# Convenience options

OVERLAY ?= B4-PRU-Example

build-overlay :
	dtc -O dtb -o overlay/$(OVERLAY)-00A0.dtbo -b 0 -@ overlay/$(OVERLAY).dts

unbuild-overlay :
	dtc -O dts -o overlay/$(OVERLAY).dts -b 0 -@ overlay/$(OVERLAY)-00A0.dtbo

copy-overlay :
	cp overlay/$(OVERLAY)-00A0.dtbo /lib/firmware

load-overlay :
	sudo sh -c "echo $(OVERLAY) > $(SLOTS)"
	sudo modprobe uio_pruss

DEST ?= bbbw
push :
	scp -r * $(DEST):~/Projects/b4lib/

.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)
	$(RM) -r overlay/$(OVERLAY)-00A0.dtbo

-include $(DEPS)

MKDIR_P ?= mkdir -p
