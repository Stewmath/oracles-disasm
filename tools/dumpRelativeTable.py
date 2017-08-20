# Dumps a table where each entry is a byte instead of a pointer; the byte is an offset
# from the current address to start reading data from.

import sys
import StringIO

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index + 1]
execfile(directory + 'common.py')

if len(sys.argv) < 3:
    print 'Usage: ' + sys.argv[0] + ' romfile startaddress'
    print 'Output goes to stout'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

output = StringIO.StringIO()

output.write('table:\n')

startAddress = int(sys.argv[2])
firstEntryAddress = 0xfffffff

address = startAddress
numIndices = 0
entryList = []
while address < firstEntryAddress:
    b = rom[address]
    entryAddress = address + b
    firstEntryAddress = min(firstEntryAddress, entryAddress)

    output.write('\t.db @entry' + myhex(numIndices).upper() + ' - CADDR')
#     output.write(' ; ' + wlahex(b,2))
    output.write('\n')

    entryList.append(entryAddress)

    address+=1
    numIndices+=1


for address in sorted(set(entryList)):
    for i in range(numIndices):
        if entryList[i] == address:
            output.write('@entry' + myhex(i).upper() + ':\n')

    # Interpret it as OAM data. TODO: make the interpretation more flexible?
    n = rom[address]
    output.write('\t.db ' + wlahex(n,2) + '\n')
    address+=1
    for i in range(n):
        output.write('\t.db')
        for j in range(4):
            output.write(' ' + wlahex(rom[address], 2))
            address+=1
        output.write('\n')

output.write('\n; Data end at ' + wlahex(address))

output.seek(0)
print(output.read())
