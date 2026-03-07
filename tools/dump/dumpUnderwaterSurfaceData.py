#!/usr/bin/python3
import sys
import os
import io

sys.path.append(os.path.dirname(__file__) + '/..')
from common import *

if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + ' romfile startaddress size')
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

startAddress = int(sys.argv[2])
endAddress = startAddress+int(sys.argv[3])

address = startAddress
output = io.StringIO()

offset = 0

while address < endAddress:
    #	if offset == 0:
    #		output.write('underWaterSurfaceData_' + myhex(toGbPointer(address),4) + ':\n')
    output.write('\t.dw %')

    for i in range(7, -1, -1):
        if rom[address+1] & (1<<i):
            output.write('1')
        else:
            output.write('0')
    for i in range(7, -1, -1):
        if rom[address] & (1<<i):
            output.write('1')
        else:
            output.write('0')
    output.write('\n')
    address+=2
    offset+=2

    if offset == 0x10:
        offset = 0

output.seek(0)
print(output.read())
