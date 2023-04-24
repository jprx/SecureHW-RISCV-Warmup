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

.global lab_start
.section .text

lab_start:
	/* Do our usual stack setup, adding some more space on the stack for 2 additional 32-bit variables */
	add sp, sp, -16
	sw fp, 8(sp)
	sw ra, 12(sp)
	add fp, sp, 16

	/* The stack looks like this now:
	 *
	 * +----------------------+
	 * |     tmp: int32_t     | <- sp
	 * +----------------------+
	 * |  changeme: int32_t   |
	 * +----------------------+
	 * | Saved Frame Pointer  |
	 * +----------------------+
	 * | Saved Return Address |
	 * +----------------------+
	 * |          ...         | <- fp
	 * +----------------------+
	 */
	la a0, level2_welcome
	call puts

	/* Welcome to level 2!
	 * In this level, we will learn about buffer overflows in assembly.
	 * You won't need to make any changes to this file for this level, all you need to do
	 * is type stuff into the console!
	 */

overflow_retry:
	/* Let's see how a buffer overflow works in assembly. */
	/* First, we set the variable "changeme" on the stack to a value */
	li t0, 0xDEADC0DE
	sw t0, 4(sp)

	/* Prompt the user for some bytes (text) */
	la a0, prompt_str
	call puts

	/* We use the unsafe function "gets" that will read from the command line into the stack */
	/* This will read bytes from the terminal into the stack starting at the top (variable "tmp"), and continue downwards
	 * until the input from the terminal stops!
	 *
	 * Go over to the terminal running the console and type some text in, and see what happens! */
	mv a0, sp
	call gets

	/* Just print a new line for easier formatting */
	la a0, newline_str
	call puts

	/* Now let's check on the variable "changeme" again and see if it changed. */
	lw t0, 4(sp)
	li t1, 0xDEADC0DE
	bne t0, t1, overflow_success

overflow_fail:
	/* Looks like we didn't overflow enough! */
	la a0, overflow_fail_msg
	call puts

	/* Print out the value of "changeme" to the console to show what it is */
	lw a0, 4(sp)
	call put_int
	la a0, newline_str
	call puts
	j overflow_retry

overflow_success:
	/* Great job! */
	/* You successfully changed "changeme" by overflowing the tmp variable by writing lots of bytes
	 * to the stack. Now, I wonder what would happen if we kept going and overwrite, say, the return address... */
	la a0, overflow_success_msg
	call puts

	/* Print out the value of "changeme" to the console to show what it is */
	lw a0, 4(sp)
	call put_int
	la a0, newline_str
	call puts

	la a0, exit_msg
	call puts

leave_lab_start:
	/* Perform the usual stack tear-down */
	lw fp, 8(sp)
	lw ra, 12(sp)
	add sp, sp, 16
	ret

level2_welcome:
.string "Welcome to level 2!\r\n"

prompt_str:
.string "Type some bytes: "

overflow_fail_msg:
.string "Overflow didn't work. Try sending more bytes. changeme is: 0x"

overflow_success_msg:
.string "Overflow worked! You changed the value of changeme to: 0x"

exit_msg:
.string "You successfully changed 'changeme' by overflowing the tmp variable by writing lots of bytes to the stack. Now, I wonder what would happen if we kept going and overwrite, say, the return address...\r\n"

newline_str:
.string "\r\n"
