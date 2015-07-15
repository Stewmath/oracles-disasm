import sys
import StringIO

index = sys.argv[0].find('/') 
if index == -1:
	directory = ''
else:
	directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 2:
	print 'Usage: ' + sys.argv[0] + ' romfile'
	sys.exit()

romFile = open(sys.argv[1],'rb')
rom = bytearray(romFile.read())

roomLayoutGroupTable = 0x10f6c

class RoomLayout:
        def __init__(self,i):
                self.index = i
                self.addr = 0
                self.compressionMode = 0
                self.data = bytearray()
                self.rawData = bytearray()
                self.label = ''

class RoomLayoutGroup:
        def __init__(self,i):
                self.index = i
                self.roomType = 0
                self.tableAddr = 0
                self.baseAddr = 0
                self.baseLabel = ''
                self.roomLayouts = []
                for j in xrange(256):
                        self.roomLayouts.append(RoomLayout(j))

layoutGroups = []
for i in xrange(0,4):
        layoutGroup = RoomLayoutGroup(i)

        addr = roomLayoutGroupTable+i*8
        layoutGroup.roomType = rom[addr]
        layoutGroup.tableAddr = bankedAddress(rom[addr+1], read16(rom, addr+2))
        layoutGroup.baseAddr = bankedAddress(rom[addr+4], read16(rom, addr+5))
        
        for j in xrange(0,256):
                roomLayout = layoutGroup.roomLayouts[j]
                pointer = read16(rom, layoutGroup.tableAddr+j*2)
                roomLayout.addr = layoutGroup.baseAddr + (pointer&0x3fff)
                roomLayout.compressionMode = pointer>>14

                if roomLayout.compressionMode == 0:
                        roomLayout.data = rom[roomLayout.addr:roomLayout.addr+0x50]
                        roomLayout.rawData = bytearray(roomLayout.data)
                else:
                        physicalSize = 0
                        if roomLayout.compressionMode == 1:
                                ret = decompressData_commonByte(rom[roomLayout.addr:], 1, 0x50)
                                physicalSize = ret[0]
                                roomLayout.data = ret[1]
                        else:
                                ret = decompressData_commonByte(rom[roomLayout.addr:], 2, 0x50)
                                physicalSize = ret[0]
                                roomLayout.data = ret[1]
                        roomLayout.rawData = rom[roomLayout.addr:roomLayout.addr+physicalSize]

                roomLayout.label = 'room' + myhex(layoutGroup.index,2) + myhex(roomLayout.index,2)
                if j == 0:
                        layoutGroup.baseLabel = roomLayout.label

        layoutGroups.append(layoutGroup)

# Debug output
for layoutGroup in layoutGroups:
        for roomLayout in layoutGroup.roomLayouts:
                outFile = open('map/' + roomLayout.label + '.bin', 'wb')
                outFile.write(roomLayout.data)
                outFile.close()
#                 outFile = open('build/debug/' + roomLayout.label + '.cmp', 'wb')
#                 outFile.write(chr(roomLayout.compressionMode))
#                 outFile.write(roomLayout.rawData)
#                 outFile.close()

# Generate tables
outFile = open('data/roomLayoutTables.s', 'w')
for layoutGroup in layoutGroups:
        outFile.write('roomLayoutGroup' + str(layoutGroup.index) + 'Table:\n')
        for i in xrange(0,256):
                roomLayout = layoutGroup.roomLayouts[i]
                outFile.write('\tm_RoomLayoutPointer ' + roomLayout.label + ' ' + layoutGroup.baseLabel + '\n')
outFile.close()

# Generate data file
outFile = open('data/roomLayoutData.s', 'w')
for layoutGroup in layoutGroups:
        for roomLayout in layoutGroup.roomLayouts:
                outFile.write('\tm_RoomLayoutData ' + roomLayout.label + '\n')
                lastRoomLayout = roomLayout
        outFile.write('\n')

outFile.write('; Data ends at ' + wlahex(lastRoomLayout.addr + len(lastRoomLayout.rawData),4))
outFile.close()
