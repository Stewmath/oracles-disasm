# Dump sound effects from a specific location for use with oracles-randomizer.
# (Used for custom compass chimes).

from common import *
import sys

f = open('seasons.gbc', 'rb')
rom = bytearray(f.read())
f.close()

addr = 0x3d*0x4000+0x3fca
count=0
stop=False

while not stop:
    if rom[addr] == 0xff:
        stop = True
    if count == 16:
        count = 0
        sys.stdout.write('\n')
    if count == 0:
        sys.stdout.write('db ')
    else:
        sys.stdout.write(',')
    sys.stdout.write(myhex(rom[addr],2))
    count+=1
    addr+=1

print('\n')
