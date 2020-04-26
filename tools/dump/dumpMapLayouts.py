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
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

# constants
dungeonDataTable = 0x4d2a
numdungeonLayouts = 16

dungeonLayoutTable = 0x4fce
numDungeonLayouts = 0x1a

# Variables


# Print dungeon map data
outFile = open('data/dungeonData.s','w')

outFile.write('dungeonDataTable: ; ' + wlahex(dungeonDataTable) + '\n')

for i in range(numdungeonLayouts):
    address = dungeonDataTable+i*2
    pointer = read16(rom, address)
    outFile.write('\t.dw dungeonData' + myhex(i,2) + '\n')
outFile.write('\n')

for i in range(numdungeonLayouts):
    pointer = read16(rom, dungeonDataTable+i*2)
    outFile.write('dungeonData' + myhex(i,2) + ': ; ' + wlahex(pointer) + '\n')
    outFile.write('\t.db')
    for j in range(8):
        outFile.write(' ' + wlahex(rom[pointer+j],2))
    outFile.write('\n')
outFile.close()

# Print dungeon layouts
outFile = open('data/dungeonLayouts.s','w')

outFile.write('dungeonLayoutData: ; ' + wlahex(dungeonLayoutTable) + '\n')

for i in range(numDungeonLayouts):
    outFile.write('\t.incbin "dungeonLayouts/layout' + myhex(i,2) + '.bin"\n')

print 'Dungeon map data ends at ' + wlahex(dungeonDataTable+numdungeonLayouts*2+numdungeonLayouts*8)

outFile.close()

# Dump dungeon layout data

for i in range(numDungeonLayouts):
    outFile = open('dungeonLayouts/layout' + myhex(i,2) + '.bin', 'wb')
    outFile.write(rom[dungeonLayoutTable+i*0x40:dungeonLayoutTable+i*0x40+0x40])
    outFile.close()

print 'Dungeon layout data ends at ' + wlahex(dungeonLayoutTable+numDungeonLayouts*0x40)
