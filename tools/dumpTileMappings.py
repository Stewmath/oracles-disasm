# This is obsolute / only for debugging, use dumpTilesets instead?

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

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

# Constants
tileMappingBank = 0x18
tileMappingTable = bankedAddress(tileMappingBank, 0x4004)
tileIndexDataPointer = bankedAddress(tileMappingBank, 0x4000)
tileAttributeDataPointer = bankedAddress(tileMappingBank, 0x4002)
numTileMappings = 0x852

tileIndexDataAddr = bankedAddress(tileMappingBank, read16(rom, tileIndexDataPointer))
tileAttributeDataAddr = bankedAddress(tileMappingBank, read16(rom, tileAttributeDataPointer))

tileIndexData = rom[tileIndexDataAddr:]
tileAttributeData = rom[tileAttributeDataAddr:]


outFile = open('tileMappings.bin','wb')

highestIndexData = 0
highestAttributeData = 0

for i in range(numTileMappings):
    addr = tileMappingTable + i*3
    indexDataOffset = rom[addr]
    indexDataOffset |= (rom[addr+1]&0xf0)<<4
    indexDataOffset *= 4
    indexDataAddr = tileIndexDataAddr+indexDataOffset

    attributeDataOffset = rom[addr+2]
    attributeDataOffset |= (rom[addr+1]&0xf)<<8
    attributeDataOffset *= 4
    attributeDataAddr = tileAttributeDataAddr+attributeDataOffset

    if highestIndexData < indexDataAddr+4:
        highestIndexData = indexDataAddr+4
    if highestAttributeData < attributeDataAddr+4:
        highestAttributeData = attributeDataAddr+4

    data = bytearray()
    for i in range(4):
        data.append(rom[indexDataAddr+i])
    for i in range(4):
        data.append(rom[attributeDataAddr+i])
    outFile.write(data)

outFile.close()

# Debug stuff
print 'Pointer   data starts at ' + hex(tileMappingTable) + ', ends at ' + hex(tileMappingTable+numTileMappings*3)
print 'Index     data starts at ' + hex(tileIndexDataAddr) + ', ends at ' + hex(highestIndexData)
print 'Attribute data starts at ' + hex(tileAttributeDataAddr) + ', ends at ' + hex(highestAttributeData)

