#!/bin/bash
source config.sh

if [[ ! -z $1 ]];
then
	TARGET_LEVEL="build/$1"
else
	echo "No level defined (eg. with ./gdb.sh levelX), defaulting to config.sh"
	echo "Using binary in $TARGET_LEVEL"
fi

riscv64-unknown-elf-gdb $TARGET_LEVEL -ex "set confirm off" -ex "target remote $DEBUG_HOST:$DEBUG_PORT" -ex "set disassemble-next-line on"
