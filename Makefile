# Makefile for ADC128S102_Driver
SRC_DIR = src
BUILD_DIR = build
TARGET = $(BUILD_DIR)/sim.out
VCD = wave.vcd
SRC = $(SRC_DIR)/ADC128S102_Driver_tb.v $(SRC_DIR)/ADC128S102_Driver.v

all: $(VCD)
	gtkwave $(VCD)

$(TARGET): $(SRC)
	mkdir -p $(BUILD_DIR)
	iverilog -o $(TARGET) $(SRC)

$(VCD): $(TARGET)
	vvp $(TARGET)

clean:
	rm -rf $(BUILD_DIR) $(VCD)
