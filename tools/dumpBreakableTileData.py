import sys
from common import *

if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + ' romfile startaddress entries')
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

startAddress = int(sys.argv[2])
endAddress = startAddress + int(sys.argv[3]) * 5

address = startAddress

while address < endAddress:
    b0 = rom[address+0]
    b1 = rom[address+1]
    b2 = rom[address+2]
    b3 = rom[address+3]
    b4 = rom[address+4]
    sys.stdout.write('\tm_BreakableTileData')
    sys.stdout.write(' ' + wlabin(b0, 8) + ' ' + wlabin(b1, 8))
    sys.stdout.write(' ' + wlabin(b2&0xf, 4) + ' ' + wlahex(b2>>4, 1))
    sys.stdout.write(' ' + wlahex(b3, 2))
    sys.stdout.write(' ' + wlahex(b4, 2) + '\n')
    address += 5
