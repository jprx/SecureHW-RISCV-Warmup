#!/usr/bin/env python3
from pwn import *
# context.log_level='debug'

# You may find using GDB useful here
# Use the following to launch level 4 while waiting for a GDB connection:
# io = process(['./run.sh', 'level4', '-debug'])
io = process(['./run.sh', 'level4'])

print(io.recvline())
io.recvuntil("Enter some text: ")

buf = b''
# TODO: Write your exploit here!
io.sendline(buf)

# Normally, io.interactive() would be the best move here,
# however I was having issues with missing the flag being output...
# So begin cursed hacks here:
while True:
    try:
        cur_char=io.recv(1).replace(b'\r',b'')
        print(cur_char.decode(), end='')
    except UnicodeDecodeError:
        pass
