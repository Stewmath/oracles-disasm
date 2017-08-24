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

# Constants
if romIsAges(rom):
    tileMappingBank = 0x18

    tilesetHeaderTable = bankedAddress(0x01, 0x787e)
    tilesetHeaderBank = 0x01

    tilesetDictionaryTable = bankedAddress(tilesetHeaderBank, 0x7870)
    numDictionaryPointers = 4
    numDictionaries = 2

    numUsedTilesets = 0x33
    numTilesets = 0x40
    numTileMappings = 0x852

    dataDir = 'data/ages/'
    tilesetDir = 'tilesets/ages/'
    precmpDir = 'precompressed/tilesets/ages/'
elif romIsSeasons(rom):
    tileMappingBank = 0x17

    tilesetHeaderTable = bankedAddress(0x01, 0x7964)
    tilesetHeaderBank = 0x01

    tilesetDictionaryTable = bankedAddress(tilesetHeaderBank, 0x794e)
    numDictionaryPointers = 8
    numDictionaries = 2

    numUsedTilesets = 0x36
    numTilesets = 0x40
    numTileMappings = 0x8f2

    dataDir = 'data/seasons/'
    tilesetDir = 'tilesets/seasons/'
    precmpDir = 'precompressed/tilesets/seasons/'
else:
    print('Unrecognized ROM.')
    sys.exit(1)


tileMappingTable = bankedAddress(tileMappingBank, 0x4004)
tileIndexDataPointer = bankedAddress(tileMappingBank, 0x4000)
tileAttributeDataPointer = bankedAddress(tileMappingBank, 0x4002)

tileIndexDataAddr = bankedAddress(
    tileMappingBank, read16(rom, tileIndexDataPointer))
tileAttributeDataAddr = bankedAddress(
    tileMappingBank, read16(rom, tileAttributeDataPointer))

tileIndexData = rom[tileIndexDataAddr:]
tileAttributeData = rom[tileAttributeDataAddr:]

# Vars

tilesetHeaders = []
tilesetHeaderAddressDict = {}

dictionaries = []

tilesetDataList = [[], []]
tilesetDataAddressDict = [{}, {}]

entryLabels = ["Mappings", "Collisions"]

maxTileIndexAddr = 0
maxTileAttributeAddr = 0

class TilesetData:

    def __init__(self, addr):
        self.addr = addr
        self.ref = None
        self.refBy = []


class TilesetHeader:

    def __init__(self, i):
        self.index = i
        self.addr = 0
        self.dest = 0
        self.ref = None
        self.refBy = []
        self.tilesetData = []


class Dictionary:

    def __init__(self, i):
        self.index = i
        self.addr = 0  # Address of 3 byte 'header'
        self.dataAddr = 0  # Address of actual dictionary data
        self.dataEndAddr = 0
        self.data = bytearray()
        self.compressionMode = 0


def decompressTilesetData(addr, dictionary, mode, dataSize):
    res = bytearray()
    while len(res) < dataSize:
        key = rom[addr]
        addr+=1
        for b in range(8):
            if len(res) >= dataSize:
                break
            c = key&1
            key >>= 1
            if c == 1:
                if mode == 0:
                    dictOffset = read16(rom, addr)
                    size = (dictOffset>>12)+3
                    dictOffset &= 0x0fff
                    addr+=2
                else:
                    size = rom[addr]
                    dictOffset = read16(rom, addr+1)
                    addr+=3
                while size > 0 and len(res) < dataSize:
                    res.append(dictionary.data[dictOffset])
                    dictOffset+=1
                    size-=1

                    end = dictOffset+dictionary.dataAddr
                    if end > dictionary.dataEndAddr:
                        dictionary.dataEndAddr = end
                    if len(res) >= dataSize:
                        break
            else:
                res.append(rom[addr])
                addr+=1
                if len(res) >= dataSize:
                    break
    return (res, addr)

def lookupTileMapping(index):
    global maxTileIndexAddr
    global maxTileAttributeAddr

    addr = tileMappingTable + index*3
    indexDataOffset = rom[addr]
    indexDataOffset |= (rom[addr+1]&0xf0)<<4
    indexDataOffset *= 4
    indexDataAddr = tileIndexDataAddr+indexDataOffset

    attributeDataOffset = rom[addr+2]
    attributeDataOffset |= (rom[addr+1]&0xf)<<8
    attributeDataOffset *= 4
    attributeDataAddr = tileAttributeDataAddr+attributeDataOffset

    if indexDataAddr+4 > maxTileIndexAddr:
        maxTileIndexAddr = indexDataAddr+4
    if attributeDataAddr+4 > maxTileAttributeAddr:
        maxTileAttributeAddr = attributeDataAddr+4

    res = bytearray()
    for j in range(4):
        res.append(tileIndexData[indexDataOffset+j])
    for j in range(4):
        res.append(tileAttributeData[attributeDataOffset+j])
    return res


for i in range(numDictionaryPointers):
    dictionary = Dictionary(i)
    dictionaries.append(dictionary)
    pointer = read16(rom, tilesetDictionaryTable + i*2)
    dictionary.addr = bankedAddress(tilesetHeaderBank, pointer)
    dictionary.dataAddr = read16BE(rom, dictionary.addr+1)
    dictionary.dataAddr = bankedAddress(
        rom[dictionary.addr]&0x7f, dictionary.dataAddr)
    dictionary.compressionMode = rom[dictionary.addr]>>7
    dictionary.label = 'tilesetDictionary' + myhex(i, 2)
    dictionary.data = rom[dictionary.dataAddr:]

for i in range(numTilesets):
    tileset = TilesetHeader(i)
    tilesetHeaders.append(tileset)

    tileset.addr = bankedAddress(
        tilesetHeaderBank, read16(rom, tilesetHeaderTable+i*2))
    tileset.label = 'tilesetHeaderGroup' + myhex(tileset.index, 2)

    if tileset.addr in tilesetHeaderAddressDict:
        tileset.ref = tilesetHeaderAddressDict[tileset.addr]
        tileset.ref.refBy.append(tileset)
        continue
    tilesetHeaderAddressDict[tileset.addr] = tileset

    # Numbers 0x33-0x3f reference nothing (ages)
    if i >= numUsedTilesets:
        continue

    addr = tileset.addr
    for j in range(2):
        dataAddr = read16BE(rom, addr+2)
        dataAddr = bankedAddress(rom[addr+1], dataAddr)

        tilesetData = TilesetData(dataAddr)
        tilesetData.dictionaryIndex = rom[addr]
        tilesetData.dataSize = read16BE(rom, addr+6)&0x7fff
        tilesetData.label = 'tileset' + entryLabels[j] + myhex(i, 2)
        tilesetData.dictionary = dictionaries[tilesetData.dictionaryIndex]
        tilesetData.dest = read16BE(rom, addr+4)

        tileset.tilesetData.append(tilesetData)
        tilesetDataList[j].append(tilesetData)

        if dataAddr in tilesetDataAddressDict[j]:
            tilesetData.ref = tilesetDataAddressDict[j][dataAddr]
            tilesetData.ref.refBy.append(tilesetData)
        tilesetDataAddressDict[j][dataAddr] = tilesetData

        addr += 8


# Output header file

outFile = open(dataDir + 'tilesetHeaders.s', 'w')

# Dictionary references
outFile.write(
    'tilesetDictionaryTable: ; ' + wlahex(tilesetDictionaryTable) + '\n')

for dictionary in dictionaries:
    outFile.write('\t.dw ' + dictionary.label + '\n')

for i in range(numDictionaries):
    dictionary = dictionaries[i]
    outFile.write(dictionary.label + ': ; ' + wlahex(dictionary.addr) + '\n')
    outFile.write('\tm_TilesetDictionaryHeader tileset' +
                  entryLabels[i] + 'Dictionary ' +
                  wlahex(dictionary.compressionMode<<7, 2) + '\n')
for i in range(numDictionaries, len(dictionaries)):
    d = dictionaries[i]
    outFile.write(d.label + ':\n')

# Table
outFile.write('\ntilesetHeaderGroupTable:\n')

for tileset in tilesetHeaders:
    outFile.write('\t.dw ' + tileset.label + '\n')

# Dump header data
for tileset in sorted(tilesetHeaders, key=lambda x: x.addr):
    if tileset.index >= numUsedTilesets:  # Check for "blank" tilesets
        outFile.write(
            tileset.label + ': ; ' + myhex(toGbPointer(tileset.addr)) + '\n')
    elif tileset.ref is None:
        outFile.write(
            '\n' + tileset.label + ': ; ' + myhex(toGbPointer(tileset.addr)) + '\n')
        for other in tileset.refBy:
            outFile.write(other.label + ':\n')

        for j in range(len(tileset.tilesetData)):
            td = tileset.tilesetData[j]
            outFile.write(
                '\tm_TilesetHeader ' + wlahex(td.dictionary.index, 2))
            outFile.write(' ' + td.label + ' ')
            if j == 0:
                outFile.write('  ')
            dest = td.dest&0xfff0
            if dest == 0xdb00:
                destString = 'w3TileCollisions    '
            elif dest == 0xdc00:
                destString = 'w3TileMappingIndices'
            else:
                destString = wlahex(dest, 4)
            outFile.write(destString + ' ')
            outFile.write(wlahex(td.dataSize, 4) + ' ')
            if j == len(tileset.tilesetData)-1:
                outFile.write('$00\n')
            else:
                outFile.write('$80\n')
        outFile.write('\n')

outFile.close()

# Dump tileset data
for j in range(2):
    outFile = open(dataDir + 'tileset' + entryLabels[j] + '.s', 'w')
    outFile.write('tileset' + entryLabels[j] + 'Dictionary:\n')
    outFile.write(
        '\t.incbin "build/tilesets/' + entryLabels[j].lower() + 'Dictionary.bin"\n\n')

    lastAddr = -1
    for tilesetData in sorted(tilesetDataList[j], key=lambda x: x.addr):
        if tilesetData.ref is None:
            if lastAddr != -1 and lastAddr != tilesetData.addr:
                print 'Data skip'
                outFile.write('; Data skip ' + hex(lastAddr) + ' -> ' +
                              hex(tilesetData.addr) + ' ' +
                              hex(tilesetData.dataSize) + '\n')
            outFile.write(tilesetData.label + ': ; ')
            outFile.write(hex(tilesetData.addr) + '\n')
            for other in tilesetData.refBy:
                outFile.write(other.label + ':\n')

            if j == 0:
                outFile.write('\t.incbin ' + '"build/tilesets/' + tilesetData.label + 'Indices.cmp"\n')
            else:
                outFile.write('\t.incbin ' + '"build/tilesets/' + tilesetData.label + '.cmp"\n')
            ret = decompressTilesetData(tilesetData.addr, tilesetData.dictionary,
                                        tilesetData.dictionary.compressionMode,
                                        tilesetData.dataSize)
            if j == 0: # Mappings
                # Precompressed output
                dataFile = open(precmpDir +
                                tilesetData.label + 'Indices.cmp', 'wb')
                dataFile.write(rom[tilesetData.addr:ret[1]])
                dataFile.close()
                # (Debug) Decompressed output
                dataFile = open('build/debug/' + tilesetData.label + '.bin', 'wb')
                dataFile.write(ret[0])
                dataFile.close()
                # Fully decompressed output
                dataFile = open(tilesetDir + tilesetData.label + '.bin', 'wb')
                for k in range(0,len(ret[0]),2):
                    index = read16(ret[0], k)
                    dataFile.write(lookupTileMapping(index))
                dataFile.close()
            else: # Collisions
                # Precompressed output
                dataFile = open(precmpDir +
                                tilesetData.label + '.cmp', 'wb')
                dataFile.write(rom[tilesetData.addr:ret[1]])
                dataFile.close()
                # Decompressed output
                dataFile = open(tilesetDir + tilesetData.label + '.bin', 'wb')
                dataFile.write(ret[0])
                dataFile.close()

            lastAddr = ret[1]

    print 'Tileset data ' + str(j) + ' ends at ' + hex(lastAddr)

    outFile.close()

# Dump dictionaries
for i in range(numDictionaries):
    dictionary = dictionaries[i]
    print 'Dictionary ' + str(i) + ' start: ' + hex(dictionary.dataAddr)
    print 'Dictionary ' + str(i) + ' end:   ' + hex(dictionary.dataEndAddr)

    outFile = open(
        precmpDir + entryLabels[i].lower() + 'Dictionary.bin', 'wb')
    outFile.write(rom[dictionary.dataAddr:dictionary.dataEndAddr])
    outFile.close()

# Dump precompressed mapping data
outFile = open(precmpDir + 'tileMappingTable.bin','wb')
outFile.write(rom[tileMappingTable:tileMappingTable+numTileMappings*3])
outFile.close()

print 'Tile mapping data starts at ' + hex(tileMappingTable)
print 'Tile mapping data ends at   ' + hex(tileMappingTable+numTileMappings*3)
print 'Tile index data starts at ' + hex(tileIndexDataAddr)
print 'Tile index data ends at   ' + hex(maxTileIndexAddr)
print 'Tile attribute data starts at ' + hex(tileAttributeDataAddr)
print 'Tile attribute data ends at   ' + hex(maxTileAttributeAddr)

# Dump precompressed tile index data
outFile = open(precmpDir + 'tileMappingIndexData.bin','wb')
outFile.write(rom[tileIndexDataAddr:maxTileIndexAddr])
outFile.close()
# Dump precompressed tile attribute data
outFile = open(precmpDir + 'tileMappingAttributeData.bin','wb')
outFile.write(rom[tileAttributeDataAddr:maxTileAttributeAddr])
outFile.close()
