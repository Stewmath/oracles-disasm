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
        self.showLabel = True
        self.address = bankedAddress(warpBank, addr)
        self.opcode = rom[addr]
        self.map = rom[addr+1]

        if (self.opcode & 0x40) == 0:
            self.index = rom[addr+2]
            self.group = rom[addr+3]>>4
            self.entrance = rom[addr+3]&0xf
        else:
            self.pointer = read16(rom,addr+2)
#             self.pointer = bankedAddress(warpBank,read16(rom,addr+2))

    def toString(self):
        if self.opcode == 0xff:
            s = "m_WarpDataEnd"
        elif self.opcode & 0x40 == 0:
            s = "m_StandardWarp " + wlahex(self.opcode,2) + " " + wlahex(self.map,2) + " "
            s += wlahex(self.group) + " " + wlahex(self.entrance) + " " + wlahex(self.index,2)
        else:
            s = "m_PointerWarp  " + wlahex(self.opcode,2) + " " + wlahex(self.map,2) + " "
            s += "warpData" + myhex(self.pointer,4)
        return s
    def getLabelName(self):
#         return "warpDataMap" + myhex(self.map,2)
        return "warpData" + myhex(toGbPointer(self.address),4)

outFile = open("data/warpData.s",'w')

# Keeps track of start of each group's data to know when the previous group's
# data must end
groupStartPositions = []

# Print table
outFile.write("warpDataTable: ; " + wlahex(warpTable) + "\n")

for group in range(8):
    groupStartPositions.append(bankedAddress(warpBank,read16(rom,warpTable+group*2)))
    outFile.write("\t.dw group" + str(group) + "WarpData\n")

groupStartPositions.append(0x100000)
outFile.write("\n")

for group in range(8):
#     print "Group " + str(group)

    address = read16(rom,warpTable+group*2)
    address = bankedAddress(warpBank,address)

#     print "Start at " + hex(address)
    warpDataList = []
    pointedWarpDataList = []

    outFile.write("group" + str(group) + "WarpData: ; " + wlahex(address) + "\n")

    b = rom[address]

    while b != 0xff:
        # Next
        warpData = WarpData(address)
        address+=4

        if warpData.opcode != 0 and warpData.opcode != 1 and warpData.opcode != 2 and warpData.opcode != 4 and warpData.opcode != 8 and warpData.opcode != 0x40:
            print "Nonstandard opcode " + hex(warpData.opcode)

#         print "Opcode: " + myhex(warpData.opcode,2)
#         print "Map: " + myhex(warpData.map,2)
#         if (warpData.opcode&0x40) == 0:
#             print "Group: " + myhex(warpData.group,2)
#             print "Entrance: " + myhex(warpData.entrance,2)
#             print "Index: " + myhex(warpData.index,2)
#         else:
#             print "Pointer: " + myhex(warpData.pointer,4)
#         print "Address: " + myhex(address)
#         print

        if warpData.opcode&0x40 != 0:
            warpData2 = WarpData(bankedAddress(warpBank,warpData.pointer))
            pointedWarpDataList.append(warpData2)
            pos = bankedAddress(warpBank,warpData.pointer)+4
            while (warpData2.opcode&0x80) == 0 and pos < groupStartPositions[group+1]:
                warpData2 = WarpData(pos)
                warpData2.showLabel = False
                pointedWarpDataList.append(warpData2)
                pos += 4

        warpDataList.append(warpData)

        # Next
        b = rom[address]

    warpDataList = sorted(warpDataList,key=lambda x:x.address)
    pointedWarpDataList = sorted(pointedWarpDataList,key=lambda x:x.address)

    printedAddresses = []

    for warpData in warpDataList:
        outFile.write("\t" + warpData.toString() + "\n")
    outFile.write("\n\tm_WarpDataEnd\n\n")
    for warpData in pointedWarpDataList:
        if not warpData.address in printedAddresses:
            printedAddresses.append(warpData.address)
            if (warpData.showLabel):
                outFile.write(warpData.getLabelName() + ":\n")
            outFile.write("\t" + warpData.toString() + "\n")
    outFile.write("\n")

#     outFile.write("\n; End at " + wlahex(address+4) + "\n\n")

#     print "End at " + hex(address)

outFile.close()
