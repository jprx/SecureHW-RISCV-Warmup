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

#include "utils.h"
#include "types.h"

/*
 * problem1_target
 * Returns true if a + b = c, false otherwise.
 */
bool problem1_target(int32_t a, int32_t b, int32_t c) {
	puts("Checking Problem 1\r\n");
	puts("a is: ");
	put_int(a);
	puts("\r\n");
	puts("b is: ");
	put_int(b);
	puts("\r\n");
	puts("c is: ");
	put_int(c);
	puts("\r\n");

	if (a + b == c) {
		puts("Passed Problem 1 ✅\r\n");
		return true;
	}
	else {
		puts("Failed Problem 1 ❌\r\n");
		return false;
	}
}

/*
 * problem2_target
 * Returns true if the null terminated string passed in matches the string
 * "Hello World from ASM"
 */
bool problem2_target(char *str) {
	puts("Checking Problem 2\r\n");
	if (NULL == str) {
		puts("Your string was NULL\r\n");
		puts("Failed Problem 2 ❌\r\n");
		return false;
	}

	if (strcmp(str, "Hello World from ASM") == 0) {
		puts("Passed Problem 2 ✅\r\n");
		return true;
	}
	else {
		puts("Failed Problem 2 ❌\r\n");
		return false;
	}
}

/*
 * problem3_target
 * Returns true if the null terminated string passed in matches the string
 * "/bin/sh"
 */
bool problem3_target(char *str) {
	puts("Checking Problem 3\r\n");

	if (NULL == str) {
		puts("Your string was NULL\r\n");
		puts("Failed Problem 3 ❌\r\n");
		return false;
	}

	puts("You passed in: ");
	puts(str);
	puts("\n");
	if (strcmp(str, "/bin/sh") == 0) {
		puts("Passed Problem 3 ✅\r\n");
		return true;
	}
	else {
		puts("Failed Problem 3 ❌\r\n");
		return false;
	}
}
