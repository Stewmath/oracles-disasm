# This program was used initially to dump the game's compressed graphics.
# If used now it might create extraneous or incompatible files.
# This is obsolete now, don't use it.

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
    gfxHeaderTable = 0x69da
    numGfxHeaders = 0xbb
    gfxHeaderBank = 1

    uncmpGfxHeaderTable = 0x6744
    numUncmpGfxHeaders = 0x40
    uncmpGfxHeaderBank = 1

    uniqueTilesetHeaderTable = 0x11b28
    numUniqueTilesetHeaders = 0x15
    uniqueTilesetHeaderBank = 4

    npcGfxTable = 0xfda8a
    numNpcGraphics = 0xe0

    treeGfxTable = 0xfdd2a
    numTreeGraphics = 0xb

    dataDir = 'data/ages/'
    precmpDir = 'precompressed/gfx_compressible/ages/'
    gfxDir = 'gfx_compressible/ages/'
elif romIsSeasons(rom):
    gfxHeaderTable = 0x6926
    numGfxHeaders = 0xbb
    gfxHeaderBank = 1

    uncmpGfxHeaderTable = 0x66d0
    numUncmpGfxHeaders = 0x38
    uncmpGfxHeaderBank = 1

    uniqueTilesetHeaderTable = 0x1195e
    numUniqueTilesetHeaders = 0x29
    uniqueTilesetHeaderBank = 4

    npcGfxTable = 0xfdafb
    numNpcGraphics = 0xd2

    treeGfxTable = 0xfdd50
    numTreeGraphics = 0xb

    dataDir = 'data/seasons/'
    precmpDir = 'precompressed/gfx_compressible/seasons/'
    gfxDir = 'gfx_compressible/seasons/'
else:
    print 'Unrecognized ROM.'
    sys.exit(1)


class GfxData:

    def __init__(self):
        self.walrus = 0

    def printself(self):
        print 'type ' + str(self.mode)
        print 'src ' + hex(self.src)
        print 'size ' + hex(self.size)
        print 'dest ' + hex(self.dest)

gfxHeaderOutput = StringIO.StringIO()
uncmpGfxHeaderOutput = StringIO.StringIO()
uniqueTilesetHeaderOutput = StringIO.StringIO()
uniqueTilesetPointerOutput = StringIO.StringIO()
npcHeaderOutput = StringIO.StringIO()
treeHeaderOutput = StringIO.StringIO()
gfxDataOutput = StringIO.StringIO()

gfxHeaderAddresses = []
uncmpGfxHeaderAddresses = []
uniqueTilesetHeaderAddresses = []

for h in xrange(numGfxHeaders):
    gfxHeaderAddresses.append(
        bankedAddress(gfxHeaderBank, read16(rom, gfxHeaderTable+h*2)))
for h in xrange(numUncmpGfxHeaders):
    uncmpGfxHeaderAddresses.append(
        bankedAddress(uncmpGfxHeaderBank, read16(rom, uncmpGfxHeaderTable+h*2)))
for h in xrange(numUniqueTilesetHeaders):
    address = read16(rom, uniqueTilesetHeaderTable+h*2)
    uniqueTilesetHeaderAddresses.append(
        bankedAddress(uniqueTilesetHeaderBank, address))


def printTable(output, labelPrefix, count):
    output.write(labelPrefix + 'Table:\n')
    for i in range(0,count):
        output.write('\t.dw ' + labelPrefix + myhex(i,2) + '\n')
    output.write('\n')


# Parses the data, then returns the end address (or -1 if no more data remains)
def parseHeader(address, headerOutput, labelPrefix, addressList):
    # Print labels
    index = 0
    for a in addressList:
        if a == address:
            headerOutput.write(labelPrefix + myhex(index, 2) + ':'
                    + ' ; ' + wlahex(address) + '\n')
        index+=1
    index = None

    if rom[address] == 0:
        # "Unique gfx headers" can reference palettes instead of graphics data. Only used
        # in one instance?
        headerOutput.write('\t.db $00\n')
        headerOutput.write('\t.db PALH_' + myhex(rom[address+1],2) + '\n')
        return -1
    else:
        # Referencing actual graphics data
        src = read16BE(rom, address+1)
        bank = rom[address] & 0x3f
        dest = read16BE(rom, address+3)
        size = rom[address+5]&0x7f

        if dest < 0x8000:
            headerOutput.write('\t; Invalid destination: ' + wlahex(dest) + '.\n')
            return -1
        if src >= 0x4000 and src < 0x8000:
            dat = GfxData()
            dat.bank = bank
            dat.mode = rom[address]>>6
            dat.src = bankedAddress(dat.bank, src)
            dat.dest = dest
            dat.size = size

            contained = False
            for e in gfxDataList:
                if e.src == dat.src:
                    if dat.size > e.size:
                        e.size = dat.size
                    contained = True
            if not contained:
                gfxDataList.append(dat)

            if romIsAges(rom) and address == 0x6bb0:
                headerOutput.write('; These seem to use an incorrect mode (mode 0)?\n')

            headerOutput.write('\tm_GfxHeader gfx_' + myhex(dat.src, 6) +
                               ' ' + wlahex(dat.dest, 4) + ' ' + wlahex(dat.size, 2))
        else:
            headerOutput.write('\tm_GfxHeaderRam ' + wlahex(bank, 2) + ' ' + wlahex(src, 4) +
                               ' ' + wlahex(dest, 4) + ' ' + wlahex(size, 2))

        if rom[address+5] & 0x80 == 0x80:
            headerOutput.write('|$80')

        if romIsAges(rom) and address >= 0x6bb0 and address < 0x6bc8:
            # These point to the capcom logo with an incorrect mode?
            headerOutput.write(' ' + wlahex(0, 2))

        headerOutput.write('\n')

        if rom[address+5]&0x80 == 0x80:
            return address+6
        else:
            return -1


def parseNpcHeader(address, headerOutput, index):
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

    headerOutput.write('\t/* ' + wlahex(index,2) + ' */ ')
    headerOutput.write(
        'm_NpcGfxHeader gfx_' + myhex(dat.src, 6) + ' ' + wlahex(dat.unknown, 2))

    headerOutput.write('\n')

gfxDataList = []
# Go through all gfx headers
printTable(gfxHeaderOutput, 'gfxHeader', numGfxHeaders)
lastAddress = 0
for address in sorted(set(gfxHeaderAddresses)):
    if address > lastAddress:
        while address != -1:
            lastAddress = address
            address = parseHeader(address, gfxHeaderOutput, 'gfxHeader', gfxHeaderAddresses)

# Go through all uncompressed gfx headers
printTable(uncmpGfxHeaderOutput, 'uncmpGfxHeader', numUncmpGfxHeaders)
lastAddress = 0
for address in sorted(set(uncmpGfxHeaderAddresses)):
    if address >= lastAddress:
        while address != -1:
            lastAddress = address
            address = parseHeader(address, uncmpGfxHeaderOutput, 'uncmpGfxHeader',
                    uncmpGfxHeaderAddresses)

# Go through all unique tileset headers
printTable(uniqueTilesetPointerOutput, 'uniqueGfxHeader', numUniqueTilesetHeaders)
uniqueTilesetHeaderOutput.write('uniqueGfxHeadersStart:\n\n')
lastAddress = 0
for address in sorted(set(uniqueTilesetHeaderAddresses)):
    if address >= lastAddress:
        while address != -1:
            lastAddress = address
            address = parseHeader(address, uniqueTilesetHeaderOutput, 'uniqueGfxHeader',
                    uniqueTilesetHeaderAddresses)

# Go through all npc gfx data
npcHeaderOutput.write('npcGfxHeaderTable: ; ' + wlahex(npcGfxTable, 4) + '\n')
for i in xrange(numNpcGraphics):
    address = npcGfxTable + i*3
    parseNpcHeader(address, npcHeaderOutput, i)

# Go through treetop data
treeHeaderOutput.write(
    'treeGfxHeaderTable: ; ' + wlahex(treeGfxTable, 4) + '\n')
for i in xrange(numTreeGraphics):
    address = treeGfxTable + i*3
    parseNpcHeader(address, treeHeaderOutput, i)

parsedGfxAddresses = []
lastAddress = 0

gfxDataList = sorted(gfxDataList, key=lambda x: x.src)
# First pass through gfx data: correct data sizes to make sure nothing overlaps
i = 0
for data in gfxDataList:
    retData = decompressGfxData(rom, data.src, data.size, data.mode)
    data.physicalSize = retData[0] - data.src

    # Hard-coded stuff
#     if romIsAges(rom) and data.src == 0xad468 or data.src == 0xad5bb or data.src == 0xc92b7:
        # These ones seem to leave extra data at the end which is unused?
        # So increase the physical size, and it'll be corrected to its maximum
        # value.
        # This code is currently disabled, because I later found out that these are just
        # unreferenced graphics. There's also one of these blank graphics right after
        # gfx_navi_ambi.bin. This was dealt with manually.
#         data.physicalSize+=0x100

    # Certain gfx data should be compressed, certain other should not be
    if romIsSeasons(rom) or (data.src >= 0x67b25 and data.src < 0x68000) or (data.src >= 0xa3f3b):
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
            gfxDir + 'gfx_' + myhex(data.src, 6) + '.bin', 'wb')
    else:
        outFile = open('gfx/gfx_' + myhex(data.src, 6) + '.bin', 'wb')
    retData = decompressGfxData(
        rom, data.src, data.size, data.mode, data.physicalSize)
    outFile.write(retData[1])
    outFile.close()
    if data.compressible:
        # Output compressed
        outFile = open(
            precmpDir + 'gfx_' + myhex(data.src, 6) + '.cmp', 'wb')
        romFile.seek(data.src)
        # First byte of the file indicates compression mode
        outFile.write(chr(data.mode))
        outFile.write(romFile.read(data.physicalSize))
        outFile.close()

    if data.src != lastAddress:
        if lastAddress != 0:
            gfxDataOutput.write('; Data ends at ' + wlahex(lastAddress) +
                                ' (physicalSize ' + wlahex(gfxDataList[i-1].physicalSize) + ')\n\n')

            outFile = open(
                dataDir + 'gfxData' + myhex(fileStartAddress, 6) + '.s', 'w')
            gfxDataOutput.seek(0)
            outFile.write(gfxDataOutput.read())
            outFile.close()
            gfxDataOutput = StringIO.StringIO()

            print 'Gap from ' + wlahex(lastAddress) + ' - ' + wlahex(data.src)

        fileStartAddress = data.src

        gfxDataOutput.write(
            '; .BANK ' + wlahex(data.src/0x4000, 2) + ' SLOT 1\n')
        gfxDataOutput.write('; .ORGA ' + wlahex(toGbPointer(data.src), 4) + '\n\n')
        gfxDataOutput.write(
            '; .REDEFINE DATA_CURBANK ' + wlahex(data.src/0x4000, 2) + '\n')
        gfxDataOutput.write(
            '; .REDEFINE DATA_ADDR ' + wlahex(toGbPointer(data.src), 4) + '\n\n')

    if data.src < lastAddress:
        gfxDataOutput.write("; BACKTRACK \n")
    gfxDataOutput.write('\tm_GfxData gfx_' + myhex(data.src, 6)
            + ' ; ' + wlahex(data.src, 6) + '\n')

    lastAddress = data.src + data.physicalSize
    lastData = data

    i += 1

outFile = open(dataDir + 'gfxData' + myhex(fileStartAddress, 6) + '.s', 'w')
gfxDataOutput.seek(0)
outFile.write(gfxDataOutput.read())
outFile.close()


outFile = open(dataDir + 'gfxHeaders.s', 'w')
gfxHeaderOutput.seek(0)
outFile.write(gfxHeaderOutput.read())
outFile.close()

outFile = open(dataDir + 'uncmpGfxHeaders.s', 'w')
uncmpGfxHeaderOutput.seek(0)
outFile.write(uncmpGfxHeaderOutput.read())
outFile.close()

outFile = open(dataDir + 'uniqueGfxHeaders.s', 'w')
uniqueTilesetHeaderOutput.seek(0)
outFile.write(uniqueTilesetHeaderOutput.read())
outFile.close()

outFile = open(dataDir + 'uniqueGfxHeaderPointers.s', 'w')
uniqueTilesetPointerOutput.seek(0)
outFile.write(uniqueTilesetPointerOutput.read())
outFile.close()

outFile = open(dataDir + 'npcGfxHeaders.s', 'w')
npcHeaderOutput.seek(0)
outFile.write(npcHeaderOutput.read())
outFile.close()

outFile = open(dataDir + 'treeGfxHeaders.s', 'w')
treeHeaderOutput.seek(0)
outFile.write(treeHeaderOutput.read())
outFile.close()
