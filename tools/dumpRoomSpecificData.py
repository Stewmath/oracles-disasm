# Dump data which is divided into "groups" with a table of tables at the start.

import sys

index = sys.argv[0].find('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 4:
    print 'Usage: ' + sys.argv[0] + ' romfile startaddress prefix [datasize] [terminator]'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

startAddress = int(sys.argv[2])
prefix = sys.argv[3]

dataSize = 2
terminator = 0

if len(sys.argv) >= 5:
    dataSize = int(sys.argv[4])
if len(sys.argv) >= 6:
    terminator = int(sys.argv[5])

bank = startAddress/0x4000

pos = startAddress

tableAddresses = []

print '; @addr{' + wlahex(startAddress, 4) + '}'
print prefix + 'GroupTable:'

for i in range(8):
    address = bankedAddress(bank, read16(rom, pos))
    tableAddresses.append(address)
    pos += 2
    
    print '\t.dw ' + prefix + 'Group' + str(i) + 'Data'

print

for i in range(8):
    address = tableAddresses[i]
    if tableAddresses.index(address) == i:
        if pos != address:
            print '\n.ORGA ' + wlahex(toGbPointer(address)) + '\n'
            pos = address
        for j in range(8):
            if tableAddresses[j] == address:
                print '; @addr{' +  wlahex(address,4) + '}'
                print prefix + 'Group' + str(j) + 'Data:'

        while True:
            if rom[pos] == terminator:
                print '\t.db ' + wlahex(terminator,2)
                pos+=1
                break
            else:
                print '\t.db',
                for i in range(dataSize):
                    print wlahex(rom[pos],2),
                    pos+=1
                print
