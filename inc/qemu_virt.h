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

#ifndef QEMU_VIRT
#define QEMU_VIRT

// The UART0 base address
#define QEMU_VIRT_UART ((0x10000000))

// The line status register
#define QEMU_VIRT_UART_LSR ((0x10000005))

// See 16550 UART datasheet: http://caro.su/msx/ocm_de1/16550.pdf
#define UART_LSR_DATA_READY_MASK ((0x01))

#define SERIAL_NEWLINE ((0x0D))
#define NEWLINE ((0x0A))

#endif // QEMU_VIRT
