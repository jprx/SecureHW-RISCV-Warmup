/*
 * RISC-V Assembly Warmup Recitation
 * Joseph Ravichandran
 * MIT Secure Hardware Design Spring 2023
 *
 * MIT License
 * Copyright (c) 2022-2023 Joseph Ravichandran
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/* Specify the symbol "start" as our global entrypoint */
/* It is defined in src/start.s */
ENTRY(start);

/* Define the available memory in our system */
MEMORY {
	/* There is a RWX (read/ write/ execute all allowed) region we
	 * are naming "virt_dram" located at 0x80000000 with size 128M.
	 * If we go beyond this region the linker will let us know. */
	virt_dram (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

/* Define some memory sections */
SECTIONS {
	/* riscv64 virt machine DRAM begins here */
	/* . = [ADDRESS] means move the current output position to that address */
	/* The next byte we output will be at [ADDRESS] */
	. = 0x80000000;

	/* text is our code section */
	.text : ALIGN(0x1000) {
		/* Put the .text.start section first */
		/* The * means we want the .text.start section from all input object files */
		*(.text.start);

		/* Then put the regular .text section after that */
		*(.text);
	}

	/* rodata is our read only data section */
	/* We specify its address to be some multiple of 0x1000 */
	.rodata : ALIGN(0x1000) {
		*(.rodata);
	}

	/* bss is the non-initialized data section */
	/* bss = "Block Started by Symbol", its a weird historic name */
	.bss : ALIGN(0x1000) {
		*(.bss);
	}

	/* data is our data section. This is also where our stack goes */
	.data : ALIGN(0x1000) {
		*(.data);

		/* Create an initial stack by moving the output address by 1M */
		. = . + 1M;

		/* We assign the current output position (after we made space for the stack)
		 * to the symbol _stack_init. This symbol is global by default so it can be
		 * read from anywhere- assembly or C!
		 *
		 * In src/start.s we set the stack pointer to this address to create a stack. */
		_stack_init = .;
	}
}
