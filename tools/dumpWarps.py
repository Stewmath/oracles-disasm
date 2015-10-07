import sys

index = sys.argv[0].find('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')


if len(sys.argv) < 2:
    print 'Usage: ' + sys.argv[0] + ' romfile'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

# Constants

warpTable = 0x1359E # Takes group as an index
warpBank = 4


class WarpData:
    def __init__(self,addr):
        self.address = bankedAddress(warpBank, addr)
        self.opcode = rom[addr]
        self.destMap = rom[addr+1]

        if self.opcode & 0x40 == 0:
            self.pointer = read16(
        else:

warpDataList = []

for group in range(1):
    print "Group " + str(group)

    address = read16(rom,warpTable+group*2)
    address = bankedAddress(warpBank,address)

    print "Start at " + hex(address)
    b = rom[address]
    address+=1

    pointerStartAddress = 0x1000000
    while b != 0xff:
        map = rom[address]
        address+=1
        pointer = read16(rom,address)
        address+=2

        print myhex(b,2)
        print myhex(map,2)
        print myhex(pointer,4)
        print "Address: " + myhex(address)
        print

#         print myhex(pointer,4)
        pointer = bankedAddress(warpBank,pointer)

        pointerStartAddress = min([pointerStartAddress,pointer])

        # Next
        b = rom[address]
        address+=1

    print "Pointer starts at " + myhex(pointerStartAddress,4)

    print "End at " + hex(address)
