#!/bin/bash

source config.sh

DEBUG_FLAGS=""
if [[ -n $2 ]];
then
	if [[ -z $DEBUG_PORT ]]; then
		echo "Error: You need to set the debug port in config.sh!"
		exit -1
	fi
	DEBUG_FLAGS="-gdb tcp::$DEBUG_PORT -S"
	echo "Waiting for debugger on port $DEBUG_PORT..."
fi

if [[ ! -z $1 ]];
then
	TARGET_LEVEL="build/$1"
fi

qemu-system-riscv32 -machine virt -m 128M -bios none -kernel $TARGET_LEVEL -serial stdio $DEBUG_FLAGS -nographic -monitor none
