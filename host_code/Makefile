# Compiler
CC = g++

# Compiler flags
CFLAGS = -Wall -Wextra -g -I. -Ixaxidma

# Environment variables for runtime
# Override these on command line: make XDMA_DRIVER_PATH=/custom/path
XDMA_DRIVER_PATH ?= ../../../dma_ip_drivers-master/XDMA/linux-kernel/tests
BITSTREAM_DIR ?= ../citrap/citrap.runs
VIVADO_PATH ?= /tools/Xilinx/Vivado/2024.2/bin/vivado

# Export environment variables for child processes
export XDMA_DRIVER_PATH
export BITSTREAM_DIR
export VIVADO_PATH

# Directories
SRC_DIR = .
XAXIDMA_DIR = xaxidma
BUILD_DIR = build

# Source files
SRCS = $(wildcard $(XAXIDMA_DIR)/*.cpp) \
       fpga_device_ops.cpp \
       fpga_system.cpp \
       fpga_module_ops.cpp \
       citrap_cli.cpp \
       AxiDmaUtils.cpp \
       ParallelMMDT.cpp \
       SingleLineMMDT.cpp

# Object files (flattened)
OBJS = $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(notdir $(SRCS)))

# Target executable name
TARGET = $(BUILD_DIR)/citrap_cli

# VPATH to find source files
vpath %.cpp $(SRC_DIR) $(XAXIDMA_DIR)

# Default target (combined clean + build)
all: clean $(BUILD_DIR) $(TARGET)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Link object files to create executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compile source files to object files
$(BUILD_DIR)/%.o: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

# Clean up build files
clean:
	rm -rf $(BUILD_DIR)

# Run the executable with environment variables set
run: $(TARGET)
	@echo "Running with environment variables:"
	@echo "  XDMA_DRIVER_PATH=$(XDMA_DRIVER_PATH)"
	@echo "  BITSTREAM_DIR=$(BITSTREAM_DIR)"
	@echo "  VIVADO_PATH=$(VIVADO_PATH)"
	@echo ""
	./$(TARGET) $(ARGS)

# Run with sudo (preserves environment variables)
run-sudo: $(TARGET)
	@echo "Running with sudo and environment variables:"
	@echo "  XDMA_DRIVER_PATH=$(XDMA_DRIVER_PATH)"
	@echo "  BITSTREAM_DIR=$(BITSTREAM_DIR)"
	@echo "  VIVADO_PATH=$(VIVADO_PATH)"
	@echo ""
	sudo -E ./$(TARGET) $(ARGS)

# Phony targets
.PHONY: all clean run run-sudo
