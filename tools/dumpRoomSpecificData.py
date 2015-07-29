# Dump data which is read by the "findRoomSpeficiData" function.

import sys

index = sys.argv[0].find('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 4:
    print 'Usage: ' + sys.argv[0] + ' romfile startaddress prefix'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

startAddress = int(sys.argv[2])
prefix = sys.argv[3]

bank = startAddress/0x4000

pos = startAddress

tableAddresses = []

print prefix + 'GroupTable: ; ' + wlahex(startAddress, 4)

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
                print prefix + 'Group' + str(j) + 'Data: ; ' + wlahex(address,4)

        while True:
            if rom[pos] == 0:
                print '\t.db $00'
                pos+=1
                break
            else:
                print '\t.db ' + wlahex(rom[pos],2) + ' ' + wlahex(rom[pos+1],2)
                pos += 2
