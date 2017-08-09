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


class HeaderEntry:

    def __init__(self):
        self.pointer = 0        # GB style pointer
        self.startIndex = 0
        self.spriteBit = 0
        self.numPalettes = 0


class PaletteHeader:

    def __init__(self, i):
        self.addr = 0
        self.index = i
        self.entries = []
        self.ref = None
        self.refBy = []


# Constants
if romIsAges(rom):
    paletteHeaderTable = 0x632c
    numPaletteHeaders = 0xcb
    paletteHeaderBank = 0x01
    paletteDataBank = 0x17
    dataDir = 'data/ages/'
elif romIsSeasons(rom):
    paletteHeaderTable = 0x6290
    numPaletteHeaders = 0xbe
    paletteHeaderBank = 0x01
    paletteDataBank = 0x16
    dataDir = 'data/seasons/'
else:
    print('Unrecognized ROM.')
    exit(1)


# Vars
paletteHeaders = []
paletteDataList = []

paletteDataStart = 0x8000
paletteDataEnd = 0x4000

headerStartAddressDict = {}
headerAddressDict = {}
paletteAddressDict = {}

for i in range(numPaletteHeaders):
    header = PaletteHeader(i)
    paletteHeaders.append(header)

    pointer = bankedAddress(
        paletteHeaderBank, read16(rom, paletteHeaderTable+i*2))
    header.addr = pointer
    header.label = 'paletteHeader' + myhex(i, 2)

    if pointer in headerStartAddressDict:
        header.ref = headerStartAddressDict[pointer]
        header.ref.refBy.append(header)
        continue
    headerStartAddressDict[pointer] = header

    repeat = True
    while repeat:
        if pointer in headerAddressDict:
            print 'Header overlap is a thing apparently: ' + hex(pointer)
        headerAddressDict[pointer] = True

        flags = rom[pointer]
        numPalettes = (flags&7)+1
        startIndex = (flags>>3)&7
        spriteBit = (flags>>6)&1
        repeat = flags&0x80 == 0x80
        dataPointer = read16(rom, pointer+1)

        headerEntry = HeaderEntry()
        headerEntry.pointer = dataPointer
        headerEntry.startIndex = startIndex
        headerEntry.spriteBit = spriteBit
        headerEntry.numPalettes = numPalettes
        # There's 1 entry which points to ram instead of rom
        if headerEntry.pointer < 0x8000:
            headerEntry.label = 'paletteData' + myhex(headerEntry.pointer, 4)

            if headerEntry.pointer < paletteDataStart:
                paletteDataStart = headerEntry.pointer
            end = headerEntry.pointer + headerEntry.numPalettes*8
            if end > paletteDataEnd:
                paletteDataEnd = end

        header.entries.append(headerEntry)

        paletteAddressDict[dataPointer] = headerEntry

        pointer+=3

# Print header file

outFile = open(dataDir + 'paletteHeaders.s', 'w')
outFile.write('paletteHeaderTable:\n')

for header in sorted(paletteHeaders, key=lambda x: x.index):
    outFile.write('\t.dw ' + header.label + '\n')
outFile.write('\n')

for header in sorted(paletteHeaders, key=lambda x: x.addr):
    if header.ref is None:
        outFile.write(
            header.label + ': ; ' + wlahex(toGbPointer(header.addr), 4) + '\n')
        for h in header.refBy:
            outFile.write(h.label + ':\n')
        for j in range(len(header.entries)):
            headerEntry = header.entries[j]
            repeat = 0x80
            if j == len(header.entries)-1:
                repeat = 0
            if headerEntry.spriteBit == 1:
                macroString = 'm_PaletteHeaderSpr '
            else:
                macroString = 'm_PaletteHeaderBg  '
            outFile.write(
                '\t' + macroString + str(headerEntry.startIndex) + ' ')
            outFile.write(str(headerEntry.numPalettes) + ' ')
            if headerEntry.pointer < 0x8000:
                outFile.write(headerEntry.label)
            else:
                # There's 1 entry which appears to point to ram
                outFile.write(wlahex(headerEntry.pointer, 4))
            outFile.write(' ' + wlahex(repeat, 2) + '\n')

outFile.close()

# Print palette data
outFile = open(dataDir + 'paletteData.s', 'w')

paletteDataStart = bankedAddress(paletteDataBank, paletteDataStart)
paletteDataEnd = bankedAddress(paletteDataBank, paletteDataEnd)

outFile.write('paletteDataStart:\n\n')

addr = paletteDataStart
while addr < paletteDataEnd:
    if toGbPointer(addr) in paletteAddressDict:
        outFile.write('paletteData' + myhex(toGbPointer(addr), 4) + ':\n')
    for i in range(4):
        word = read16(rom, addr+i*2)
        red = word&0x1f
        green = (word>>5)&0x1f
        blue = (word>>10)&0x1f
        outFile.write('\tm_RGB16 ' + wlahex(red, 2) + ' ' +
                      wlahex(green, 2) + ' ' + wlahex(blue, 2) + '\n')
    outFile.write('\n')
    addr += 8


outFile.close()

# Debug stuff

print 'Palette data starts at ' + hex(paletteDataStart)
print 'Palette data ends at ' + hex(paletteDataEnd)

lastHeader = sorted(paletteHeaders, key=lambda x: x.addr)[
    len(paletteHeaders)-1]
headerEndAddr = lastHeader.addr + len(lastHeader.entries)*3

print 'Header data ends at ' + hex(headerEndAddr)
