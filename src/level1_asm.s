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

/* Export lab_start as a global symbol so that it's available everywhere
 * A symbol is just an address somewhere in memory */
.global lab_start

/* Place the following in the ".text" section.
 * The text section just contains the bytes of our executable program.
 * See linker.ld for more info if you are curious! */
.section .text

/* Welcome to level 1!
 *
 * This level introduces us to the C calling convention/ RISC-V assembly.
 *
 * We will start with the familiar Risc V ISA to refresh our knowledge
 * of the stack/ C calling convention, and introduce binary exploitation concepts.
 */

lab_start:
	/* Save the caller saved registers we need to the stack */
	/* For us, this is the return address and old frame pointer */

	/* Risc V requires that the stack remains 16 byte aligned */
	add sp, sp, -16

	/* Store the saved registers (4 bytes each) to the stack */
	sw fp, 0(sp)
	sw ra, 4(sp)

	/* Point the frame pointer at the base of the stack */
	add fp, sp, 16

	/* The stack now looks like the following:
	 *
	 *    To lower addresses
	 *           /|\
	 *            |
	 * +----------------------+
	 * | Saved Frame Pointer  | <- sp
	 * +----------------------+
	 * | Saved Return Address |
	 * +----------------------+
	 * |       Padding        |
	 * +----------------------+
	 * |       Padding        |
	 * +----------------------+
	 * |          ...         | <- fp
	 * +----------------------+
	 */

problem_1:
	/* Load immediate values into the first two arguments */
	/* RISC-V arguments go in a0, a1, a2, ... */
	/* Later on we'll see how x86_64 does this same thing, just with different register names! */
	li a0, 0x1337BEEF
	li a1, 0xDEADC0DE

	/* [MIT SHD TODO] Problem 1: Fill in the blank to make problem1_target return true! */
	/* Hint: Read level1.c to see what problem1_target expects */
	# TODO: Your code here

	/* Call problem1_target in src/level1.c with the arguments we have defined */
	call problem1_target

	/* Check the return value against the value of 1 */
	/* The return value is in a0 on RISC-V */
	li t0, 1

	/* If the return value (stored in a0) was 1, move on to problem 2 */
	beq a0, t0, problem_2

	/* Otherwise, leave this function */
	j leave_lab_start

problem_2:
	/* [MIT SHD TODO] Problem 2: Fill in the blank to call problem2_target with problem2_str (defined at the bottom of the file) */
	/* Hint: We want to use a pseudo-instruction to load something into a0 */
	mv a0, zero # <- Replace this with your code
	# TODO: Your code here

	call problem2_target

	/* Again, check the return value */
	li t0, 1
	beq a0, t0, problem_3
	j leave_lab_start

problem_3:
	/* [MIT SHD TODO] Problem 3: Push the string "/bin/sh" to the stack without using the .string directive */
	/* This may seem like a weird thing to ask, but we will see how this is extremely useful in binary exploitation */
	mv a0, zero # <- Replace this with your code
	# TODO: Your code here

	call problem3_target

	/* Again, check the return value */
	add sp, sp, 16
	li t0, 1
	beq a0, t0, success
	j leave_lab_start

success:
	la a0, success_string
	call puts

/* Restore the saved registers from the stack and quit this method */
leave_lab_start:
	/* Recall the stack:
	*
	 * +----------------------+
	 * | Saved Frame Pointer  | <- sp
	 * +----------------------+
	 * | Saved Return Address |
	 * +----------------------+
	 * |       Padding        |
	 * +----------------------+
	 * |       Padding        |
	 * +----------------------+
	 * |          ...         | <- fp
	 * +----------------------+
	 */
	lw fp, 0(sp)
	lw ra, 4(sp)
	add sp, sp, 16
	ret

/* A null terminated string */
problem2_str:
.string "Hello World from ASM"

success_string:
.string "You did it! Level 1 Complete!!\r\n"
