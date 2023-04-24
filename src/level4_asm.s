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
	/* Do our usual stack setup */
	add sp, sp, -16
	sw fp, 0(sp)
	sw ra, 4(sp)
	add fp, sp, 16

	/* Welcome to level 4!
	 *
	 * This level introduces us to return oriented programming,
	 * building off the idea of buffer overflows.
	 *
	 * The win method now takes an argument- a pointer to a string.
	 * So, we can't simply point the return address at win(). We will need to chain
	 * a sequence of little code segments, called gadgets, to set a0 to point to the string "/bin/sh".
	 *
	 * We can store the string "/bin/sh" on the stack via the gets() buffer overflow, and then
	 * exploit the program to make a0 point to the stack (where we placed the "/bin/sh" string earlier).
	 *
	 * We do this by forming what's called a "ROP chain"- a sequence of fake return addresses on the stack.
	 * For example, let's say we want to call gadget_a followed by gadget_b:
	 *
	 * # a1 <- 0xDEADC0DE
	 * # ra <- stack.pop()
	 * gadget_a:
	 *    la a0, 0xDEADC0DE
	 *    lw ra, 0(sp)
	 *    add sp, sp, 4
	 *    ret
	 *
	 * # a1 <- 0x12345678
	 * # ra <- stack.pop()
	 * gadget_b:
	 *    la a1, 0x12345678
	 *    lw ra, 0(sp)
	 *    add sp, sp, 4
	 *    ret
	 *
	 * Both gadgets do a very small action (load a0 or a1 with an immediate),
	 * pop the return address off the stack, increment the stack pointer, and then return to whatever the ra is.
	 *
	 * We can chain these gadgets together with a buffer overflow by manipulating the stack as follows:
	 *
	 * Start with the stack as it begins:
	 * +----------------------+
	 * | Saved Frame Pointer  | <- sp
	 * +----------------------+
	 * | Saved Return Address |
	 * +----------------------+
	 * |          ...         |
	 * +----------------------+
	 *
	 * We overflow as usual:
	 * +----------------------+
	 * |       Garbage        | <- sp
	 * +----------------------+
	 * |  gadget_a's address  |
	 * +----------------------+
	 * |          ...         |
	 * +----------------------+
	 *
	 * So that when this stack frame returns, the following happens:
	 *  fp <- garbage (we don't care about fp)
	 *  pc <- gadget_a's address
	 *
	 * We have redirected code execution to gadget_a! Now, take a closer look at gadget_a.
	 * First, it sets a0 to 0xDEADC0DE. When it is done, it will pop the *next* return address
	 * off the stack. So, if we do this:
	 *
	 * +----------------------+
	 * |       Garbage        | <- sp
	 * +----------------------+
	 * |  gadget_a's address  |
	 * +----------------------+
	 * |  gadget_b's address  |
	 * +----------------------+
	 *
	 * When gadget_a completes, it'll jump to gadget_b for us!
	 * We have successfully created a ROP chain using 2 gadgets.
	 *
	 * For this level, we provide the building blocks for you, all you need to do is chain the ones you want together!
	 *
	 * Fill in solve_4.py with your exploit code.
	 */

	/* Recall the stack:
	 *
	 * +----------------------+
	 * | Saved Frame Pointer  | <- sp
	 * +----------------------+
	 * | Saved Return Address |
	 * +----------------------+
	 * |    4 Bytes Padding   |
	 * +----------------------+
	 * |    4 Bytes Padding   |
	 * +----------------------+
	 */

	/* Tell user where win() is located */
	la a0, win_is_str
	call puts
	la a0, win
	call put_int
	la a0, newline_str
	call puts

	/* Print prompt */
	la a0, prompt_str
	call puts

	/* Read into stack */
	mv a0, sp
	call gets

	la a0, newline_str
	call puts

leave_lab_start:
	/* Print out the address we are jumping to */
	la a0, ra_is_str
	call puts
	lw a0, 4(sp)
	call put_int
	la a0, newline_str
	call puts

	/* Perform the usual stack tear-down */
	lw fp, 0(sp)
	lw ra, 4(sp)
	add sp, sp, 16

	/* If the overflow was successful, ra now points to win! */
	ret

/* Here are some gadgets for you to try! */
/* Get their addresses using objdump! */
/* riscv64-unknown-elf-objdump -d [object.o] */

# a2 <- a1 + 4
gadget_a:
	add a2, a1, 4
	lw ra, 0(sp)
	add sp, sp, 4
	ret

# a1 <- stack.pop()
gadget_b:
	lw a1, 0(sp)
	lw ra, 4(sp)
	add sp, sp, 8
	ret

# a0 <- a2
gadget_c:
	mv a0, a2
	lw ra, 0(sp)
	add sp, sp, 4
	ret

# Intention: Use this to skip over "/bin/sh" on the stack if needed
# Or just to make some more space on the stack
# stack.pop(4)
gadget_d:
	add sp, sp, 16
	lw ra, 0(sp)
	add sp, sp, 4
	ret

win_is_str:
.string "win() is at: "

prompt_str:
.string "Enter some text: "

ra_is_str:
.string "Returning to: "

newline_str:
.string "\r\n"

