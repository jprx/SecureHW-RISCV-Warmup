# RISC-V Assembly Warmup Recitation
# Joseph Ravichandran
# MIT Secure Hardware Design Spring 2023
#
# MIT License
# Copyright (c) 2022-2023 Joseph Ravichandran
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

TOOLCHAIN_PREFIX ?= riscv64-unknown-elf-

CC := $(TOOLCHAIN_PREFIX)gcc
AS := $(TOOLCHAIN_PREFIX)as
LD := $(TOOLCHAIN_PREFIX)gcc

OBJECTS_LEVEL1 := start.o utils.o level1_asm.o level1.o
TARGET_LEVEL1 := build/level1

OBJECTS_LEVEL2 := start.o utils.o level2_asm.o
TARGET_LEVEL2 := build/level2

OBJECTS_LEVEL3 := start.o utils.o level3_asm.o
TARGET_LEVEL3 := build/level3

OBJECTS_LEVEL4 := start.o utils.o level4_asm.o level4.o
TARGET_LEVEL4 := build/level4

BUILD_OBJECTS_LEVEL1 := $(patsubst %,build/%,$(OBJECTS_LEVEL1))
BUILD_OBJECTS_LEVEL2 := $(patsubst %,build/%,$(OBJECTS_LEVEL2))
BUILD_OBJECTS_LEVEL3 := $(patsubst %,build/%,$(OBJECTS_LEVEL3))
BUILD_OBJECTS_LEVEL4 := $(patsubst %,build/%,$(OBJECTS_LEVEL4))

ASFLAGS := -g -march=rv32i -mabi=ilp32
CFLAGS := -g -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -fno-plt -fno-pic -O0 -c -Iinc
LDFLAGS1 := -g -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -fno-plt -fno-pic
LDFLAGS2 := -T linker.ld -O0 -static-libgcc -lgcc

.PHONY: all clean

all: $(TARGET_LEVEL1) $(TARGET_LEVEL2) $(TARGET_LEVEL3) $(TARGET_LEVEL4)

clean:
	rm -rf build

build/%.o: src/%.s
	@echo " AS    $<"
	@mkdir -p build
	@$(AS) -c $(ASFLAGS) $< -o $@

build/%.o: src/%.c
	@echo " CC    $<"
	@mkdir -p build
	@$(CC) -c $(CFLAGS) $< -o $@

$(TARGET_LEVEL1): $(BUILD_OBJECTS_LEVEL1) linker.ld Makefile
	@echo " LD    $@"
	@mkdir -p build
	@$(LD) $(LDFLAGS1) $(BUILD_OBJECTS_LEVEL1) -o $@ $(LDFLAGS2)

$(TARGET_LEVEL2): $(BUILD_OBJECTS_LEVEL2) linker.ld Makefile
	@echo " LD    $@"
	@mkdir -p build
	@$(LD) $(LDFLAGS1) $(BUILD_OBJECTS_LEVEL2) -o $@ $(LDFLAGS2)

$(TARGET_LEVEL3): $(BUILD_OBJECTS_LEVEL3) linker.ld Makefile
	@echo " LD    $@"
	@mkdir -p build
	@$(LD) $(LDFLAGS1) $(BUILD_OBJECTS_LEVEL3) -o $@ $(LDFLAGS2)

$(TARGET_LEVEL4): $(BUILD_OBJECTS_LEVEL4) linker.ld Makefile
	@echo " LD    $@"
	@mkdir -p build
	@$(LD) $(LDFLAGS1) $(BUILD_OBJECTS_LEVEL4) -o $@ $(LDFLAGS2)
