import sys

index = sys.argv[0].rfind('/')
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
if romIsAges(rom):
    warpBank = 4
    warpDestTable = 0x12F5B
    warpSourceTable = 0x1359E # Takes group as an index
    dataDir = 'data/ages/'
else:
    warpBank = 4
    warpDestTable = 0x12d4e
    warpSourceTable = 0x13457
    dataDir = 'data/seasons/'


# Keeps track of whether pointers are uniquely used. Only for printing warning
# output.
usedPointers = {}


class WarpData:
    def __init__(self,addr,pointed):
        self.pointer = None
        self.pointed = pointed
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
            if self.opcode != 0xff and self.pointer in usedPointers:
                print "Pointer " + hex(self.pointer) + " not uniquely used"
            else:
                usedPointers[self.pointer] = True
#             self.pointer = bankedAddress(warpBank,read16(rom,addr+2))

    def toString(self):
        if self.opcode == 0xff:
            s = "m_WarpSourcesEnd"
        elif self.opcode & 0x40 == 0:
            if self.pointed:
                s = "m_PointedWarp "
            else:
                s = "m_StandardWarp "
            s += wlahex(self.opcode,2) + " " + wlahex(self.map,2) + " "
            s += wlahex(self.index,2) + " " + wlahex(self.group) + " " + wlahex(self.entrance)
        else:
            s = "m_PointerWarp  " + wlahex(self.opcode,2) + " " + wlahex(self.map,2) + " "
            s += "warpSource" + myhex(self.pointer,4)
        return s
    def getLabelName(self):
#         return "warpDataMap" + myhex(self.map,2)
        return "warpSource" + myhex(toGbPointer(self.address),4)



outFile = open(dataDir + "warpData.s",'w')

# Warp destinations

warpDestAddresses = []
outFile.write("warpDestTable: ; " + wlahex(warpDestTable) + "\n")
for group in range(8):
    address = bankedAddress(warpBank,read16(rom,warpDestTable+group*2))
    warpDestAddresses.append(address)
    outFile.write("\t.dw group" + str(group) + "WarpDestTable\n")
outFile.write("\n")
warpDestAddresses.append(warpSourceTable)

outFile.write("; Format: map YX unknown\n\n")

for group in range(8):
    outFile.write("group" + str(group) + "WarpDestTable:\n")
    address = bankedAddress(warpBank,read16(rom,warpDestTable+group*2))
    while address < warpDestAddresses[group+1]:
        b1 = rom[address]
        b2 = rom[address+1]
        b3 = rom[address+2]

        outFile.write("\tm_WarpDest " + wlahex(b1,2) + " " + wlahex(b2,2)
                + " " + wlahex(b3,2) + "\n")

        address+=3
    outFile.write("\n")

# Warp sources
#

# Keeps track of start of each group's data to know when the previous group's
# data must end
groupStartPositions = []

# Print table
outFile.write("warpSourcesTable: ; " + wlahex(warpSourceTable) + "\n")

for group in range(8):
    groupStartPositions.append(bankedAddress(warpBank,read16(rom,warpSourceTable+group*2)))
    outFile.write("\t.dw group" + str(group) + "WarpSources\n")

groupStartPositions.append(0x100000)
outFile.write("\n")

warpPointerAddresses = []

for group in range(8):
#     print "Group " + str(group)

    address = read16(rom,warpSourceTable+group*2)
    address = bankedAddress(warpBank,address)

#     print "Start at " + hex(address)
    warpDataList = []
    pointedWarpDataList = []

    if romIsSeasons(rom) and group == 0:
        # Unreferenced data
        pointedWarpDataList.append(WarpData(0x13653, True))

    outFile.write("group" + str(group) + "WarpSources: ; " + wlahex(address) + "\n")

    b = rom[address]

    while b != 0xff and not address in warpPointerAddresses \
            and (not romIsSeasons(rom) or address < 0x13e02):
        warpData = WarpData(address,False)

        if warpData.pointer is not None:
            warpPointerAddresses.append(bankedAddress(warpBank, warpData.pointer))
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
            warpData2 = WarpData(bankedAddress(warpBank,warpData.pointer),True)
            pointedWarpDataList.append(warpData2)
            pos = bankedAddress(warpBank,warpData.pointer)+4
            while (warpData2.opcode&0x80) == 0 and pos < groupStartPositions[group+1]:
                warpData2 = WarpData(pos,True)
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
    outFile.write("\tm_WarpSourcesEnd\n\n")
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
