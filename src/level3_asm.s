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

	/* Welcome to level 3!
	 *
	 * This level introduces us to using buffer overflows to gain code execution.
	 * For this lab, you'll need to make use of sending non-printable characters to the terminal.
	 * This is best done using Python from the outside world.
	 *
	 * Our goal is to manipulate code execution by overwriting the saved return address so that
	 * when we try to leave this method (lab_start), we actually call win instead!
	 *
	 * Recall the stack:
	 * +----------------------+
	 * | Saved Frame Pointer  | <- sp
	 * +----------------------+
	 * | Saved Return Address |
	 * +----------------------+
	 * |        Padding       |
	 * +----------------------+
	 * |        Padding       |
	 * +----------------------+
	 * |          ...         | <- fp
	 * +----------------------+
	 *
	 * We have the ability to write as many bytes into the stack as we'd like. So, if we
	 * did the following:
	 *
	 * +----------------------+
	 * |   4 Garbage Byte s   | (Saved fp) <- sp
	 * +----------------------+
	 * |   Address of win()   | (Saved ra)
	 * +----------------------+
	 * |        Padding       |
	 * +----------------------+
	 * |        Padding       |
	 * +----------------------+
	 * |          ...         | <- fp
	 * +----------------------+
	 *
	 * When this method returns, the following happens:
	 *  fp <- 4 garbage bytes (this is ok! We don't really need to care about fp)
	 *  pc <- win's address
	 *
	 * By changing the saved return address, we have successfully redirected code flow into the win
	 * method without changing anything about the program itself.
	 *
	 * Notably, since gets reads from the terminal, you can do this by just sending bytes
	 * to the program. Isn't that neat?
	 *
	 * As win's address will include non-ASCII (non-printable) characters, we will need to use
	 * a script to help automate sending these bytes. Our provided script "solve_3.py" uses
	 * a python library called "pwntools" (commonly used by "Capture the Flag" players) to
	 * automate receiving and sending bytes to the program. You could also just use
	 * a sequence of pipes / shell scripts if you want. Don't forget to pay attention to
	 * endianness- RISC-V and x86_64 are both little endian! (Not an issue if using pwntools)
	 *
	 * Give it a try! The code will print the value of the return address before exiting
	 * so you can see if you got it right or not.
	 *
	 * HINT: Try just typing in a bunch of junk into the terminal.
	 * Do you see "Returning to: 0x[Some ASCII values]"?
	 */

	/*
	 * Recall the state of the stack:
	 * +----------------------+
	 * | Saved Frame Pointer  | <- sp
	 * +----------------------+
	 * | Saved Return Address |
	 * +----------------------+
	 * |        Padding       |
	 * +----------------------+
	 * |        Padding       |
	 * +----------------------+
	 * |          ...         | <- fp
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

	/* Read into stack from serial */
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

/* Call me to win the level! */
win:
	la a0, win_str
	call puts
	j .

win_is_str:
.string "win() is at: "

prompt_str:
.string "Enter some text: "

ra_is_str:
.string "Returning to: "

newline_str:
.string "\r\n"

win_str:
.string "\n\r\nYou successfully hacked the program and called win()!!!\r\n"
