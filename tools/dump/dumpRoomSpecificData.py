# Dump data which is divided into "groups" with a table of tables at the start.
# The name of this is a bit misleading, but it was originally used for tables of "rooms".

import sys

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 4:
    print 'Usage: ' + sys.argv[0] + ' romfile startaddress prefix [datasize] [entries] [terminator]'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

startAddress = int(sys.argv[2])
prefix = sys.argv[3]

dataSize = 2
entries = 8
terminator = 0

if len(sys.argv) >= 5:
    dataSize = int(sys.argv[4])
if len(sys.argv) >= 6:
    entries = int(sys.argv[5])
if len(sys.argv) >= 7:
    terminator = int(sys.argv[6])

bank = startAddress/0x4000

pos = startAddress

tableAddresses = []

print '; @addr{' + myhex(toGbPointer(startAddress), 4) + '}'
print prefix + 'Table:'

for i in range(entries):
    address = bankedAddress(bank, read16(rom, pos))
    tableAddresses.append(address)
    pos += 2
    
    print '\t.dw ' + prefix + str(i)

print

for i in range(entries):
    address = tableAddresses[i]
    if tableAddresses.index(address) == i:
        if pos != address:
            print '\n.ORGA ' + wlahex(toGbPointer(address)) + '\n'
            pos = address
        for j in range(entries):
            if tableAddresses[j] == address:
#                 print '; @addr{' +  myhex(toGbPointer(address),4) + '}'
                print prefix + str(j) + ':'

        while True:
            if terminator >= 0 and rom[pos] == terminator:
                print '\t.db ' + wlahex(terminator,2)
                pos+=1
                break
            else:
                print '\t.db',
                for i in range(dataSize):
                    print wlahex(rom[pos],2),
                    pos+=1
                print
                if terminator < 0:
                    break
