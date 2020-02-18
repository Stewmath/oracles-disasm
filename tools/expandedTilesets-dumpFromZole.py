import sys, os
from common import *

if len(sys.argv) < 2:
    print('Usage: ' + sys.argv[0] + ' romfile [-agrt]')
    print('Dumps data from a ZOLE rom into the disassembly.')
    print('')
    print('\t-a: All of the below')
    print('\t-g: Tileset Graphics')
    print('\t-i: Area IDs (TODO)')
    print('\t-m: Music IDs (TODO)')
    print('\t-r: Room Layouts')
    print('\t-t: Tileset Mappings')
    sys.exit()

filename = sys.argv[-1]

romFile = open(filename, 'rb')
rom = bytearray(romFile.read())


if romIsAges(rom):
    NUM_AREAS = 0x67
    NUM_TILEMAPS = 0x2c
    areaData = 0x10f9c
    areaIdAddr = 0x112d4
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


args = sys.argv[1:]

if '-a' in args:
    args.append('-g')
    args.append('-i')
    args.append('-m')
    args.append('-r')
    args.append('-t')

if '-g' in args:
    # Dump tileset graphics
    for tileset in range(0,NUM_AREAS):
        gfxAddr = 0x181000 + tileset * 0x1000
        gfxData = rom[gfxAddr:gfxAddr+0x1000]
        outFile = open('gfx/' + game + '/gfx_tileset' + myhex(tileset, 2) + '.bin', 'wb')
        outFile.write(gfxData)
        outFile.close()

if '-i' in args:
    # Dump area IDs
    for group in range(0,6):
        addr = bankedAddress(4, read16(rom, areaIdAddr + 2 * group))
        data = rom[addr : addr+0x100]
        f = open('rooms/%s/group%dAreas.bin' % (game, group), 'wb')
        f.write(data)
        f.close()

if '-r' in args:
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

if '-t' in args:
    # Dump tilemaps.
    # ZOLE's tilemaps aren't actually fully separated by area ID, for some reason. So we do this
    # ourselves.
    tilemapAddr = 0x201000
    for area in range(0,NUM_AREAS):
        tilemap = rom[areaData + area*8 + 5]
        tilemapAddr = 0x201000 + tilemap * 0x800
        tilemapData = rom[tilemapAddr:tilemapAddr+0x800]
        outFile = open('tilesets/' + game + '/tilesetMappings' + myhex(area, 2) + '.bin', 'wb')
        outFile.write(tilemapData)
        outFile.close()

    # Dump collisions.
    # ZOLE actually has no support for this, so as a shortcut, we just use copies of files we've already
    # dumped from other dumper scripts.
    #for area in range(0,NUM_AREAS):
    #    tilemap = rom[areaData + area*8 + 5]
    #    path = 'tilesets/%s/' % game
    #    if game == 'ages': # Hardcoded stuff: some indices don't have their own files
    #        if tilemap == 0x20:
    #            tilemap = 0x1b
    #        elif tilemap == 0x32:
    #            tilemap = 0x2b
    #    origFile = path + 'tilesetCollisions-Orig%s.bin' % myhex(tilemap, 2)
    #    targetFile = path + 'tilesetCollisions%s.bin' % myhex(area, 2)
    #    os.system('cp %s %s' % (origFile, targetFile))
