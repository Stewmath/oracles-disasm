import sys
from common import *

if len(sys.argv) < 2:
    print('Usage: ' + sys.argv[0] + ' romfile')
    print('Input file should be a ZOLE expanded rom.')
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())


if romIsAges(rom):
    NUM_AREAS = 0x67
    NUM_TILEMAPS = 0x2c
    areaData = 0x10f9c
    game = 'ages'
elif romIsSeasons(rom):
    NUM_AREAS = 0xcf # TODO: handle seasonal areas properly
    areaData = 0x10c84
    game = 'seasons'
    print('Seasons not supported yet.')
    sys.exit(1)
else:
    print('Unknown ROM.')
    sys.exit(1)


# Dump tileset graphics
for tileset in range(0,NUM_AREAS):
    gfxAddr = 0x181000 + tileset * 0x1000
    gfxData = rom[gfxAddr:gfxAddr+0x1000]
    outFile = open('gfx/' + game + '/gfx_tileset' + myhex(tileset, 2) + '.bin', 'wb')
    outFile.write(gfxData)
    outFile.close()

# Dump tilemaps.
# ZOLE's tilemaps aren't actually fully separated by area ID, for some reason. So we do this
# ourselves.
# ZOLE also has no support for collision mappings. That's a TODO.
tilemapAddr = 0x201000
for area in range(0,NUM_AREAS):
    tileset = rom[areaData + area*8 + 5]
    tilemapAddr = 0x201000 + tileset * 0x800
    tilemapData = rom[tilemapAddr:tilemapAddr+0x800]
    outFile = open('tilesets/' + game + '/tilesetMappings' + myhex(area, 2) + '.bin', 'wb')
    outFile.write(tilemapData)
    outFile.close()

# Dump room layouts. The way these are stored is unchanged in the disassembly, but ZOLE expanded
# them. Useful for porting ZOLE projects to the disassembly.
for group in range(0,6):
    # ZOLE seems to ignore "layout groups"? (which might be for the best...)
    if group == 1:
        layoutGroup = 2
    elif group == 2:
        layoutGroup = 1
    else:
        layoutGroup = group

    if group < 4: # Small room
        layoutAddr = 0x104000 + (group * 2) * 0x4000
        roomSize = 80
        outputBasename = 'rooms/' + game + '/small/room' + myhex(layoutGroup, 2)
    else: # Large room
        layoutAddr = 0x104000 + (group * 3) * 0x4000
        roomSize = 176
        outputBasename = 'rooms/' + game + '/large/room' + myhex(layoutGroup, 2)

    for room in range(0,256):
        layoutData = rom[layoutAddr:layoutAddr+roomSize]
        f = open(outputBasename + myhex(room,2) + '.bin', 'wb')
        f.write(layoutData)
        f.close()
        layoutAddr += roomSize
