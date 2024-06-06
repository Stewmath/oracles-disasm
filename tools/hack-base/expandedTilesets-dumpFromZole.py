#!/usr/bin/python3
import sys, os
import gfx, png
from common import *

if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + ' romfile [options]')
    print('Dumps data from a ZOLE rom into the disassembly.')
    print('\nOptions:')
    print('\t-a: All of the below')
    print('\t-d: Dungeon layouts')
    print('\t-g: Tileset Graphics')
    print('\t-i: Tileset IDs')
    print('\t-m: Music IDs')
    print('\t-r: Room Layouts')
    print('\t-t: Tileset Mappings')
    print('\nExample: "%s rom.gbc -g -t" dumps tileset graphics and mappings from rom.gbc.' % sys.argv[0])
    print('\nOther things:\
            \n\tWarps: Use tools/dump/dumpWarps.py.\
            \n\tObjects: Use tools/dump/dumpObjects.py.\
            \n\tPalettes: Use tools/dump/dumpPalettes.py.')
    print('\nStuff from ZOLE that\'s not (yet) dumped by this script:\
            \n\t- Chests\
            \n\t- Miniboss portal warps\
            \n\t- Link\'s start location\
            \n\t- Tileset flags\
            \n\t- Essence warp location\
            \n\t- Enemy edits\
            \n\t- Sign & text changes\
            \n\t- Treetop edits\
            \n\t- Dungeon room flags\
            \n\t- ZOSE scripts\
            \n\t- ASM patches')

    sys.exit()

filename = sys.argv[1]

romFile = open(filename, 'rb')
rom = bytearray(romFile.read())


FIX_PAST_CLIFFS = True

if romIsAges(rom):
    NUM_TILESETS = 0x67
    NUM_TILEMAPS = 0x2c
    tilesetDataAddr = 0x10f9c
    tilesetIdAddr = 0x112d4
    musicTable = 0x1095c
    dungeonLayoutAddr = 0x4fce
    game = 'ages'
elif romIsSeasons(rom):
    NUM_TILESETS = 0xcf # TODO: handle seasonal tilesets properly
    tilesetDataAddr = 0x10c84
    game = 'seasons'
    print('WARNING: Seasons support is preliminary. -r flag works, others might not.')
else:
    print('Unknown ROM.')
    sys.exit(1)


args = []

for arg in sys.argv[2:]:
    if arg[0] == '-':
        for c in arg[1:]:
            args.append('-' + c)
    else:
        print('Unrecognized argument "%s".' % arg)
        sys.exit(1)

if '-a' in args:
    args.append('-d')
    args.append('-g')
    args.append('-i')
    args.append('-m')
    args.append('-r')
    args.append('-t')

if '-d' in args:
    print('Dumping dungeon layouts.')
    data = rom[dungeonLayoutAddr : dungeonLayoutAddr+0x680]
    f = open('rooms/%s/dungeonLayouts.bin' % game, 'wb')
    f.write(data)
    f.close()

if '-g' in args:
    print('Dumping tileset graphics.')
    for tileset in range(0,NUM_TILESETS):
        gfxAddr = 0x181000 + tileset * 0x1000
        gfxData = rom[gfxAddr:gfxAddr+0x1000]

        result = gfx.convert_2bpp_to_png(gfxData)
        width, height, palette, greyscale, bitdepth, px_map, padding = result

        w = png.Writer(
            width,
            height,
            palette=palette,
            compression=9,
            bitdepth=bitdepth,
            #transparent=0
        )
        with open('gfx/' + game + '/gfx_tileset' + myhex(tileset, 2) + ".png", 'wb') as f:
            w.write(f, px_map)

    # Placeholder tilesets
    for tileset in range(NUM_TILESETS,0x80):
        gfxData = [0] * 4096
        result = gfx.convert_2bpp_to_png(gfxData)
        width, height, palette, greyscale, bitdepth, px_map, padding = result

        w = png.Writer(
            width,
            height,
            palette=palette,
            compression=9,
            bitdepth=bitdepth,
        )
        with open('gfx/' + game + '/gfx_tileset' + myhex(tileset, 2) + ".png", 'wb') as f:
            w.write(f, px_map)

if '-i' in args:
    print('Dumping Tileset IDs.')
    for group in range(0,6):
        addr = bankedAddress(4, read16(rom, tilesetIdAddr + 2 * group))
        data = rom[addr : addr+0x100]
        f = open('rooms/%s/group%dTilesets.bin' % (game, group), 'wb')
        f.write(data)
        f.close()

if '-m' in args:
    print('Dumping Music IDs.')
    for group in range(0,6):
        addr = bankedAddress(4, read16(rom, musicTable + group*2))
        data = rom[addr : addr+0x100]
        f = open('audio/%s/group%dIDs.bin' % (game, group), 'wb')
        f.write(data)
        f.close()

if '-r' in args:
    # Dump room layouts. The way these are stored is unchanged in the disassembly, but ZOLE expanded
    # them. Useful for porting ZOLE projects to the disassembly.
    print('Dumping room layouts.')
    if romIsAges(rom):
        numGroups = 6
    else:
        numGroups = 7 # Seasons

    for group in range(0,numGroups):
        if romIsAges(rom):
            isSmall = group < 4
            if isSmall:
                layoutAddr = 0x104000 + group * 2 * 0x4000
            else:
                layoutAddr = 0x104000 + group * 3 * 0x4000

            # ZOLE seems to ignore "layout groups"? (which might be for the best...)
            if group == 1:
                layoutGroup = 2
            elif group == 2:
                layoutGroup = 1
            else:
                layoutGroup = group
        else: # Seasons
            isSmall = group < 5

            if group < 4:
                layoutAddr = 0x150000 + group * 2 * 0x4000
            elif group == 4:
                layoutAddr = 0x10c000
            elif group == 5 or group == 6:
                layoutAddr = 0x134000 + (group - 5) * 3 * 0x4000

            layoutGroup = group

        if isSmall:
            roomSize = 80
            outputBasename = 'rooms/' + game + '/small/room' + myhex(layoutGroup, 2)
        else: # Large room
            roomSize = 176
            outputBasename = 'rooms/' + game + '/large/room' + myhex(layoutGroup, 2)

        for room in range(0,256):
            layoutData = rom[layoutAddr:layoutAddr+roomSize]
            f = open(outputBasename + myhex(room,2) + '.bin', 'wb')
            f.write(layoutData)
            f.close()
            layoutAddr += roomSize

if '-t' in args:
    # ZOLE's tilemaps aren't actually fully separated by tileset ID, for some reason. So we do this
    # ourselves.
    print('Dumping tilemaps.')
    tilemapAddr = 0x201000
    for tileset in range(0,NUM_TILESETS):
        tilesetData = rom[tilesetDataAddr + tileset*8 : tilesetDataAddr + tileset*8 + 8]
        tilemap = tilesetData[5]
        tilemapAddr = 0x201000 + tilemap * 0x800
        tilemapData = rom[tilemapAddr:tilemapAddr+0x800]

        # Cliffs in the past are hardcoded to have their palettes changed from blue to red, so that
        # the tile attributes can be reused in the past and present. Instead, we bake this into the
        # dumped tiles so they can be edited freely.
        if FIX_PAST_CLIFFS and romIsAges(rom):
            if tilesetData[0] >> 4 != 0: # Collisions 0 (overworld)
                continue
            if tilesetData[1] & 0x80 != 0x80: # "In the past" flag
                continue
            if tileset == 0x26: # Maku tree screen is an exception
                continue
            for t in range(0x40, 0x80):
                for i in range(0,4):
                    pos = t * 8 + 4 + i
                    if tilemapData[pos] & 7 == 6:
                        tilemapData[pos] &= 0xf8 # Switch to palette 0

        outFile = open('tileset_layouts_expanded/' + game + '/tilesetMappings' + myhex(tileset, 2) + '.bin', 'wb')
        outFile.write(tilemapData)
        outFile.close()

    # Dump collisions.
    # ZOLE actually has no support for this, so as a shortcut, we just use copies of files we've already
    # dumped from other dumper scripts.
    # This is commented because it only needed to be run once, for the hack-base branch initial
    # setup.
    #for tileset in range(0,NUM_TILESETS):
    #    tilemap = rom[tilesetDataAddr + tileset*8 + 5]
    #    path = 'tilesets/%s/' % game
    #    if game == 'ages': # Hardcoded stuff: some indices don't have their own files
    #        if tilemap == 0x20:
    #            tilemap = 0x1b
    #        elif tilemap == 0x32:
    #            tilemap = 0x2b
    #    origFile = path + 'tilesetCollisions-Orig%s.bin' % myhex(tilemap, 2)
    #    targetFile = path + 'tilesetCollisions%s.bin' % myhex(tileset, 2)
    #    os.system('cp %s %s' % (origFile, targetFile))
