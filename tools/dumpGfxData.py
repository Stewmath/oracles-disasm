# This program was used initially to dump the game's compressed graphics.
# If used now it might create extraneous or incompatible files.
# This is obsolete now, don't use it.

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

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())


# Constants
gfxHeaderTable = 0x69da
numGfxHeaders = 0xbb
gfxHeaderBank = 1

uniqueTilesetHeaderTable = 0x11b28
numUniqueTilesetHeaders = 0x14
uniqueTilesetHeaderBank = 4

npcGfxTable = 0xfda8a
numNpcGraphics = 0xe0

treeGfxTable = 0xfdd2a
numTreeGraphics = 0xb


class GfxData:

    def __init__(self):
        self.walrus = 0

    def printself(self):
        print 'type ' + str(self.mode)
        print 'src ' + hex(self.src)
        print 'size ' + hex(self.size)
        print 'dest ' + hex(self.dest)

gfxHeaderOutput = StringIO.StringIO()
uniqueTilesetHeaderOutput = StringIO.StringIO()
npcHeaderOutput = StringIO.StringIO()
treeHeaderOutput = StringIO.StringIO()
gfxDataOutput = StringIO.StringIO()

gfxHeaderAddresses = []
uniqueTilesetHeaderAddresses = []

for h in xrange(numGfxHeaders):
    gfxHeaderAddresses.append(
        bankedAddress(gfxHeaderBank, read16(rom, gfxHeaderTable+h*2)))
for h in xrange(numUniqueTilesetHeaders):
    address = read16(rom, uniqueTilesetHeaderTable+h*2)
    uniqueTilesetHeaderAddresses.append(
        bankedAddress(uniqueTilesetHeaderBank, address))


def parseHeader(address, headerOutput):
    dat = GfxData()
    dat.bank = rom[address] & 0x3f
    dat.mode = rom[address]>>6
    dat.src = bankedAddress(dat.bank, read16BE(rom, address+1))
    dat.dest = read16BE(rom, address+3)
    dat.size = rom[address+5]&0x7f

    contained = False
    for e in gfxDataList:
        if e.src == dat.src:
            if dat.size > e.size:
                e.size = dat.size
            contained = True
    if not contained:
        gfxDataList.append(dat)

    if address == 0x6bb0:
        headerOutput.write('; These seem to use an incorrect mode (mode 0)?\n')

    headerOutput.write('\tm_GfxHeader gfx_' + myhex(dat.src, 6) +
                       ' ' + wlahex(dat.dest, 4) + ' ' + wlahex(dat.size, 2))

    if rom[address+5] & 0x80 == 0x80:
        headerOutput.write('|$80')

    if address >= 0x6bb0 and address < 0x6bc8:
        # These point to the capcom logo with an incorrect mode?
        headerOutput.write(' ' + wlahex(0, 2))

    headerOutput.write('\n')


def parseNpcHeader(address, headerOutput):
    dat = GfxData()
    dat.bank = rom[address] & 0x3f
    dat.mode = rom[address]>>6
    dat.src = bankedAddress(dat.bank, read16BE(rom, address+1))
    dat.size = 0x1f
    dat.unknown = rom[address+1] & 0x80

    contained = False
    for e in gfxDataList:
        if e.src == dat.src:
            if dat.size > e.size:
                e.size = dat.size
            contained = True
    if not contained:
        gfxDataList.append(dat)

    headerOutput.write(
        '\tm_NpcGfxHeader gfx_' + myhex(dat.src, 6) + ' ' + wlahex(dat.unknown, 2))

    headerOutput.write('\n')

gfxDataList = []
# Go through all gfx headers
lastAddress = 0
for address in sorted(gfxHeaderAddresses):
    if address >= lastAddress:
        cnt = 0x80
        while cnt == 0x80:
            if address in gfxHeaderAddresses:
                gfxHeaderOutput.write(
                    'gfxHeader' + myhex(toGbPointer(address), 4) + ':\n')

            parseHeader(address, gfxHeaderOutput)
            cnt = rom[address+5]&0x80
            address += 6

        lastAddress = address
# Go through all unique tileset headers
lastAddress = 0
for address in sorted(uniqueTilesetHeaderAddresses):
    if address >= lastAddress:
        cnt = 0x80
        while cnt == 0x80:
            if address in uniqueTilesetHeaderAddresses:
                uniqueTilesetHeaderOutput.write(
                    'uniqueTilesetHeader' + myhex(toGbPointer(address), 4) + ':\n')

            parseHeader(address, uniqueTilesetHeaderOutput)
            cnt = rom[address+5]&0x80
            address += 6

        lastAddress = address

# Go through all npc gfx data
npcHeaderOutput.write('npcGfxHeaderTable: ; ' + wlahex(npcGfxTable, 4) + '\n')
for i in xrange(numNpcGraphics):
    address = npcGfxTable + i*3
    parseNpcHeader(address, npcHeaderOutput)

# Go through treetop data
npcHeaderOutput.write(
    '\ntreeGfxHeaderTable: ;' + wlahex(treeGfxTable, 4) + '\n')
for i in xrange(numTreeGraphics):
    address = treeGfxTable + i*3
    parseNpcHeader(address, npcHeaderOutput)

parsedGfxAddresses = []
lastAddress = 0

gfxDataList = sorted(gfxDataList, key=lambda x: x.src)
# First pass through gfx data: correct data sizes to make sure nothing overlaps
i = 0
for data in gfxDataList:
    retData = decompressGfxData(rom, data.src, data.size, data.mode)
    data.physicalSize = retData[0] - data.src

    # Hard-coded stuff
    if data.src == 0xad468 or data.src == 0xad5bb or data.src == 0xc92b7:
        # These ones seem to leave extra data at the end which is unused?
        # So increase the physical size, and it'll be corrected to its maximum
        # value
        data.physicalSize+=0x100
    # Certain gfx data should be compressed, certain other should not be
    if (data.src >= 0x67b25 and data.src < 0x68000) or (data.src >= 0xa3f3b):
        data.compressible = True
    else:
        data.compressible = False

    if i != 0:
        lastData = gfxDataList[i-1]
        physicalSize2 = data.src - lastData.src
        if physicalSize2 < lastData.physicalSize:
            lastData.physicalSize = physicalSize2

    i += 1


i = 0
# Second pass: generate the files and .incbins
for data in gfxDataList:
    parsedGfxAddresses.append(data.src)
#	data.printself()
    # Output decompressed
    if data.compressible:
        outFile = open(
            'gfx_compressible/gfx_' + myhex(data.src, 6) + '.bin', 'wb')
    else:
        outFile = open('gfx/gfx_' + myhex(data.src, 6) + '.bin', 'wb')
    retData = decompressGfxData(
        rom, data.src, data.size, data.mode, data.physicalSize)
    outFile.write(retData[1])
    outFile.close()
    if data.compressible:
        # Output compressed
        outFile = open(
            'gfx_precompressed/gfx_' + myhex(data.src, 6) + '.cmp', 'wb')
        romFile.seek(data.src)
        # First byte of the file indicates compression mode
        outFile.write(chr(data.mode))
        outFile.write(romFile.read(data.physicalSize))
        outFile.close()

    if data.src != lastAddress:
        if lastAddress != 0:
            gfxDataOutput.write('; Data ends at ' + hex(lastAddress) +
                                ' (physicalSize ' + hex(gfxDataList[i-1].physicalSize) + ')\n\n')

            outFile = open(
                'data/gfxData' + myhex(fileStartAddress, 6) + '.s', 'w')
            gfxDataOutput.seek(0)
            outFile.write(gfxDataOutput.read())
            outFile.close()
            gfxDataOutput = StringIO.StringIO()

        fileStartAddress = data.src

        gfxDataOutput.write(
            '.BANK ' + wlahex(data.src/0x4000, 2) + ' SLOT 1\n')
        gfxDataOutput.write(
            '.REDEFINE GFX_CURBANK ' + wlahex(data.src/0x4000, 2) + '\n')
        gfxDataOutput.write(
            '.REDEFINE GFX_ADDR ' + wlahex(toGbPointer(data.src), 4) + '\n')
        gfxDataOutput.write('.ORGA ' + wlahex(toGbPointer(data.src), 4) + '\n')

    if data.src < lastAddress:
        gfxDataOutput.write("; BACKTRACK \n")
    gfxDataOutput.write('\tm_GfxData gfx_' + myhex(data.src, 6) + '\n')

    lastAddress = data.src + data.physicalSize
    lastData = data

    i += 1

outFile = open('data/gfxData' + myhex(fileStartAddress, 6) + '.s', 'w')
gfxDataOutput.seek(0)
outFile.write(gfxDataOutput.read())
outFile.close()


outFile = open('data/gfxHeaders.s', 'w')
gfxHeaderOutput.seek(0)
outFile.write(gfxHeaderOutput.read())
outFile.close()

outFile = open('data/uniqueTilesetHeaders.s', 'w')
uniqueTilesetHeaderOutput.seek(0)
outFile.write(uniqueTilesetHeaderOutput.read())
outFile.close()

outFile = open('data/npcGfxHeaders.s', 'w')
npcHeaderOutput.seek(0)
outFile.write(npcHeaderOutput.read())
outFile.close()
