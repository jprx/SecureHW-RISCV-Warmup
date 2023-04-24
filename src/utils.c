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

#include "qemu_virt.h"
#include "types.h"
#include "utils.h"

/*
 * putc
 * Put a single character to UART0
 */
void putc(char c) {
	volatile char *UART_TX = (char *)QEMU_VIRT_UART;
	*UART_TX = c;
}

/*
 * getc
 * Retrieve a single character from UART0
 */
char getc() {
	volatile char *UART_RX = (char *)QEMU_VIRT_UART;
	volatile char *UART_LSR = (char *)QEMU_VIRT_UART_LSR;

	// Wait until data is present for us to read
	while ((*UART_LSR & UART_LSR_DATA_READY_MASK) == 0);

	return *UART_RX;
}

/*
 * puts
 * Print an entire string to UART0
 */
void puts (char *str) {
	char *cursor = str;
	while (*cursor) {
		putc(*cursor);
		cursor++;
	}
}

/*
 * gets
 * Retrieve a string from UART and store it in the provided buffer null terminated
 * This method is super duper unsafe :)
 * In general, gets is a HORRIBLE function to use and should never be used!!!
 */
void gets (char *str) {
	char *cursor = str;

	while (true) {
		*cursor = getc();

		// Let the user see the character they just printed
		putc(*cursor);

		if (*cursor == SERIAL_NEWLINE || *cursor == NEWLINE) {
			cursor++;
			*cursor = '\x00';
			return;
		}

		cursor++;
	}
}

/*
 * put_int
 * Print a 32 bit integer to UART0
 */
void put_int (int32_t val) {
	putc('0');
	putc('x');
	for (int64_t i = 7LL; i >= 0LL; i--) {
		char cur_val = (val >> (4ULL * i)) & 0x0FULL;
		if (cur_val < 10) {
			putc(cur_val + 0x30);
		}
		else {
			putc(cur_val + 0x37);
		}
	}
}

/*
 * put_int
 * Print a 64 bit integer to UART0
 */
void put_int64 (int64_t val) {
	putc('0');
	putc('x');
	for (int64_t i = 15LL; i >= 0LL; i--) {
		char cur_val = (val >> (4ULL * i)) & 0x0FULL;
		if (cur_val < 10) {
			putc(cur_val + 0x30);
		}
		else {
			putc(cur_val + 0x37);
		}
	}
}

/*
 * strlen
 * Returns the length of a null terminated string
 */
size_t strlen (char* str) {
	char *cursor = str;
	size_t num_bytes = 0;
	while (*cursor) {
		cursor++;
		num_bytes++;
	}
	return num_bytes;
}

/*
 * strcmp
 * Returns 0 if the strings are equal, 1 otherwise.
 */
bool strcmp (char *str1, char *str2) {
	size_t idx = 0;
	while (str1[idx] != '\x00') {
		if (str1[idx] != str2[idx]) return 1;
		idx++;
	}
	return str1[idx] != str2[idx];
}
