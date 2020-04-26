# This isn't related to the disassembly; this is just for my studying of the veran warp
# glitch. (See my findings here: http://wiki.zeldahacking.net/oracle/Veran_Warp)

import sys
import StringIO

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index + 1]
execfile(directory + 'common.py')

if len(sys.argv) < 2:
    print 'Usage: ' + sys.argv[0] + ' romfile'
    print 'Output goes to stout'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

# This is actually 2 bytes prior to the start of the table, but index 0 is never used
itemPositionsTable = 0x9b80

output = StringIO.StringIO()

output.write('{| class="wikitable"\n')
output.write('!FF8D value\n')
output.write('!"Inventory slot"\n')
output.write('!Writes to addresses\n')

for i in range(1,0x100):
    invAddress = 0xc689 + i
    writeAddress = read16(rom, itemPositionsTable+i*2)

    output.write('|-\n')
    output.write('|<code>' + wlahex(i,2) + '</code>\n')
    output.write('|<code>' + wlahex(invAddress,4) + '</code>\n')

    writeList = [writeAddress]
    writeAddress |= 0x0400
    if not writeAddress in writeList:
        writeList.append(writeAddress)
    writeAddress += 0x20
    writeList.append(writeAddress)
    writeAddress &= (~0x0400)
    if not writeAddress in writeList:
        writeList.append(writeAddress)

    output.write('|<code>')
    first = True
    for a in sorted(writeList):
        if not first:
            output.write(',')
        first = False
        output.write(wlahex(a,4))
    output.write('</code>\n')

output.write('|}\n')

output.seek(0)
print(output.read())
