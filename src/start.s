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

/* Export the symbol start as a global symbol, and place this code in the ".text.start" section.
 * We created the .text.start section as a special section that gets placed at the very beginning of memory
 * in the linker script. See linker.ld for more! */
.global start
.section .text.start

/* This is the global entrypoint- the very first thing that gets run
 * when our program begins executing on the CPU!
 *
 * See linker.ld (the linker script) to see how we set this to be the beginning */
start:
	/* Load the stack pointer from the stack we create in the linker script (linker.ld) */
	la sp, _stack_init

	/* We don't really need a frame pointer but let's set it up anyways so we can show it being
	 * saved and restored by lab_start */
	mv fp, sp

	/* Call the lab_start method. This will be in levelN_asm.s for a given level */
	/* When this is done, it will continue executing at the next line in this file */
	call lab_start

/* When we finish, simply loop forever */
loop_forever:
	j loop_forever
