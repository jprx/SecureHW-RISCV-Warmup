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

#ifndef UTILS_H
#define UTILS_H

#include "types.h"

/*
 * putc
 * Put a single character to UART0
 */
void putc(char c);

/*
 * getc
 * Retrieve a single character from UART0
 */
char getc();

/*
 * puts
 * Print an entire string to UART0
 */
void puts (char *str);

/*
 * gets
 * Retrieve a string from UART and store it in the provided buffer null terminated
 * This method is super duper unsafe :)
 * In general, gets is a HORRIBLE function to use and should never be used!!!
 */
void gets (char *str);

/*
 * put_int
 * Print a 32 bit integer to UART0
 */
void put_int (int32_t val);

/*
 * put_int64
 * Print a 64 bit integer to UART0
 */
void put_int64 (int64_t val);

/*
 * strlen
 * Returns the length of a null terminated string
 */
size_t strlen (char* str);

/*
 * strcmp
 * Returns 0 if the strings are equal, 1 otherwise.
 */
bool strcmp (char *str1, char *str2);

#endif // UTILS_H
