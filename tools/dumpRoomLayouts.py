import sys
import StringIO

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


if romIsAges(rom):
    roomLayoutGroupTable = 0x10f6c
    numLayoutGroups = 6
    roomDir = 'rooms/ages/'
    dataDir = 'data/ages/'
    precmpDir = 'precompressed/ages/'
else:
    roomLayoutGroupTable = 0x10c4c
    numLayoutGroups = 7
    roomDir = 'rooms/seasons/'
    dataDir = 'data/seasons/'
    precmpDir = 'precompressed/seasons/'


class RoomLayout:

    def __init__(self, i):
        self.index = i
        self.addr = 0
        self.data = bytearray()
        self.rawData = bytearray()
        self.label = ''
        self.ref = None
        self.refBy = []
        # Compression mode: 0-2 are variants of the 'common byte' compression (used for small rooms)
        # 3 is the 'dictionary' compression (used for large rooms)
        self.compressionMode = 0


class RoomLayoutGroup:

    def __init__(self, i):
        self.index = i
        self.roomType = 0
        self.tableAddr = 0
        self.baseAddr = 0
        self.baseLabel = ''
        self.roomLayouts = []
        self.dictionary = bytearray()
        for j in xrange(256):
            self.roomLayouts.append(RoomLayout(j))


def decompressRoomLayout_dictionary(data, offset, dataLen, layoutGroup):
    res = bytearray()
    i = offset

    while len(res) < dataLen:
        key = data[i]
        i+=1
        for x in range(8):
            if len(res) >= dataLen:
                break
            c = key&1
            key >>= 1
            if c == 1:
                ptr = read16(data, i)
                i+=2
                l = (ptr>>12)+3
                ptr &= 0x0fff
                for y in range(l):
                    if len(res) >= dataLen:
                        break
                    res.append(layoutGroup.dictionary[ptr+y])
            else:
                res.append(data[i])
                i+=1

    return (i-offset, res)

usedLayoutAddresses = {}
layoutGroups = []
for i in xrange(0, numLayoutGroups):
    layoutGroup = RoomLayoutGroup(i)

    addr = roomLayoutGroupTable+i*8
    layoutGroup.roomType = rom[addr]
    layoutGroup.tableAddr = bankedAddress(rom[addr+1], read16(rom, addr+2))
    layoutGroup.baseAddr = bankedAddress(rom[addr+4], read16(rom, addr+5))

    if layoutGroup.roomType == 1:  # Common byte compression
        for j in xrange(0, 256):
            roomLayout = layoutGroup.roomLayouts[j]
            pointer = read16(rom, layoutGroup.tableAddr+j*2)
            roomLayout.addr = layoutGroup.baseAddr + (pointer&0x3fff)
            roomLayout.compressionMode = pointer>>14
            roomLayout.label = 'room' + \
                myhex(layoutGroup.index, 2) + myhex(roomLayout.index, 2)

            if roomLayout.addr in usedLayoutAddresses:
                roomLayout.ref = usedLayoutAddresses[roomLayout.addr]
                roomLayout.ref.refBy.append(roomLayout)
                continue
            usedLayoutAddresses[roomLayout.addr] = roomLayout

            if roomLayout.compressionMode == 0:
                roomLayout.data = rom[roomLayout.addr:roomLayout.addr+0x50]
                roomLayout.rawData = bytearray(roomLayout.data)
            else:
                physicalSize = 0
                if roomLayout.compressionMode == 1:
                    ret = decompressData_commonByte(
                        rom[roomLayout.addr:], 1, 0x50)
                    physicalSize = ret[0]
                    roomLayout.data = ret[1]
                else:
                    ret = decompressData_commonByte(
                        rom[roomLayout.addr:], 2, 0x50)
                    physicalSize = ret[0]
                    roomLayout.data = ret[1]
                roomLayout.rawData = rom[
                    roomLayout.addr:roomLayout.addr+physicalSize]
    else:  # Dictionary compression
        layoutGroup.dictionary = rom[
            layoutGroup.tableAddr:layoutGroup.tableAddr+0x1000]
        for j in xrange(256):
            roomLayout = layoutGroup.roomLayouts[j]
            pointer = read16(rom, layoutGroup.tableAddr+0x1000+j*2)
            pointer -= 0x200
            roomLayout.addr = pointer + layoutGroup.baseAddr
            roomLayout.compressionMode = 3
            roomLayout.label = 'room' + \
                myhex(layoutGroup.index, 2) + myhex(roomLayout.index, 2)

            if roomLayout.addr in usedLayoutAddresses:
                roomLayout.ref = usedLayoutAddresses[roomLayout.addr]
                roomLayout.ref.refBy.append(roomLayout)
                continue
            usedLayoutAddresses[roomLayout.addr] = roomLayout

            usedLayoutAddresses[roomLayout.addr] = roomLayout
            # Note: big ares are 0xf x 0xb in size, but every 16
            # bytes are padded with a 0 at the end
            ret = decompressRoomLayout_dictionary(
                rom, roomLayout.addr, 0xb0, layoutGroup)
            roomLayout.data = ret[1]
            roomLayout.rawData = rom[roomLayout.addr:roomLayout.addr+ret[0]]

    layoutGroup.baseLabel = layoutGroup.roomLayouts[0].label

    layoutGroups.append(layoutGroup)

# Output files
for layoutGroup in layoutGroups:
    for roomLayout in layoutGroup.roomLayouts:
        if roomLayout.ref is not None:
            continue
        if layoutGroup.roomType == 1:
            outFile = open(roomDir + 'small/' + roomLayout.label + '.bin', 'wb')
        else:
            outFile = open(roomDir + 'large/' + roomLayout.label + '.bin', 'wb')
        outFile.write(roomLayout.data)
        outFile.close()
        # Precompressed output (only for large rooms)
        if layoutGroup.roomType == 0:
            outFile = open(
                precmpDir + 'rooms/' + roomLayout.label + '.cmp', 'wb')
            outFile.write(chr(roomLayout.compressionMode))
            outFile.write(roomLayout.rawData)
            outFile.close()

# Generate small room tables
outFile = open(dataDir + 'smallRoomLayoutTables.s', 'w')
for layoutGroup in layoutGroups:
    if layoutGroup.roomType == 0:
        continue  # Skip large rooms
    outFile.write('roomLayoutGroup' + str(layoutGroup.index) + 'Table:\n')
    for i in xrange(0, 256):
        roomLayout = layoutGroup.roomLayouts[i]
        outFile.write('\tm_RoomLayoutPointer ' +
                      roomLayout.label + ' ' + layoutGroup.baseLabel + '\n')
outFile.close()

# Generate large room tables
outFile = open(dataDir + 'largeRoomLayoutTables.s', 'w')
for layoutGroup in layoutGroups:
    if layoutGroup.roomType == 1:
        continue  # Skip small rooms
    outFile.write('roomLayoutGroup' + str(layoutGroup.index) + 'Table:\n')
    outFile.write(
        '\t.incbin "' + roomDir + 'dictionary' + str(layoutGroup.index) + '.bin"\n\n')
    for i in xrange(0, 256):
        roomLayout = layoutGroup.roomLayouts[i]
        outFile.write('\tm_RoomLayoutDictPointer ' +
                      roomLayout.label + ' ' + layoutGroup.baseLabel + '\n')
    outFile.write('\n')
outFile.close()

# Dump dictionaries
for layoutGroup in layoutGroups:
    if layoutGroup.roomType != 0:
        continue
    outFile = open(roomDir + 'dictionary' + str(layoutGroup.index) + '.bin', 'w')
    outFile.write(layoutGroup.dictionary)
    outFile.close()

# Generate data file
outFile = open(dataDir + 'roomLayoutData.s', 'w')
for layoutGroup in layoutGroups:
    for roomLayout in sorted(layoutGroup.roomLayouts, key=lambda x: x.addr):
        if roomLayout.ref is not None:
            continue
        for layout in roomLayout.refBy:
            outFile.write(layout.label + ':\n')
        outFile.write('\tm_RoomLayoutData ' + roomLayout.label + '\n')
        lastRoomLayout = roomLayout
    outFile.write('\n')

outFile.write('; Data ends at ' +
              wlahex(lastRoomLayout.addr + len(lastRoomLayout.rawData), 4))
outFile.close()
