import sys
import StringIO

index = sys.argv[0].find('/')
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
dungeonMapTable = 0x4d2a
numDungeonMaps = 16
dungeonLayoutTable = 0x4fce

# Variables


# Print dungeon map data
outFile = open('data/dungeonMaps.s','w')

outFile.write('dungeonMapTable: ; ' + wlahex(dungeonMapTable) + '\n')

for i in range(numDungeonMaps):
    address = dungeonMapTable+i*2
    pointer = read16(rom, address)
    outFile.write('\t.dw dungeonMap' + myhex(i,2) + '\n')
outFile.write('\n')

for i in range(numDungeonMaps):
    pointer = read16(rom, dungeonMapTable+i*2)
    outFile.write('dungeonMap' + myhex(i,2) + ': ; ' + wlahex(pointer) + '\n')
    outFile.write('\t.db')
    for j in range(8):
        outFile.write(' ' + wlahex(rom[pointer+j],2))
    outFile.write('\n')

print 'Dungeon map data ends at ' + wlahex(dungeonMapTable+numDungeonMaps*2+numDungeonMaps*8)

outFile.close()

# Print dungeon layout data
# outFile = 
