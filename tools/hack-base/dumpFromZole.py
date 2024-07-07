#!/usr/bin/python3
import sys, os

# Import directories for common.py, gfx.py, png.py
sys.path.append(os.path.dirname(__file__) + '/..')
sys.path.append(os.path.dirname(__file__) + '/../gfx')

import gfx, png

from common import *

if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + ' romfile [options]')
    print('Dumps data from a ZOLE rom into the disassembly.')
    print('\nOptions:')
    print('\t-a: All of the below')
#    print('\t-d: Dungeon layouts')
    print('\t-g: Tileset Graphics')
    print('\t-i: Tileset IDs')
    print('\t-m: Music IDs')
    print('\t-r: Room Layouts')
    print('\t-t: Tileset Mappings')
    print('\nExample: "%s rom.gbc -g -t" dumps tileset graphics and mappings from rom.gbc.' % sys.argv[0])
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
            \n\t- Warps\
            \n\t- Objects\
            \n\t- Palettes\
            \n\t- ASM patches')

    sys.exit()

filename = sys.argv[1]

romFile = open(filename, 'rb')
rom = bytearray(romFile.read())


FIX_PAST_CLIFFS = True
seasonNames = ['spring', 'summer', 'autumn', 'winter']

if romIsAges(rom):
    NUM_TILESETS = 0x67
    #NUM_TILEMAPS = 0x2c

    tilesetDataAddr = 0x10f9c
    tilesetIdAddr = 0x112d4
    musicTable = 0x1095c

    gfxHeaderTable = 0x69da
    gfxHeaderBank = 1

    uniqueTilesetHeaderTable = 0x11b28
    uniqueTilesetHeaderBank = 4

    dungeonLayoutAddr = 0x4fce
    game = 'ages'

elif romIsSeasons(rom):
    NUM_TILESETS = 0x63

    tilesetDataAddr = 0x10c84
    tilesetDataBank = 4

    gfxHeaderTable = 0x6926
    gfxHeaderBank = 1

    uniqueTilesetHeaderTable = 0x1195e
    uniqueTilesetHeaderBank = 4

    game = 'seasons'
    print('WARNING: Seasons support is preliminary. -r, -t, -g flags work, others might not.')
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
#    args.append('-d')
    args.append('-g')
    args.append('-i')
    args.append('-m')
    args.append('-r')
    args.append('-t')



def gfxDataToFile(gfxData, filename):
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
    with open(filename + ".png", 'wb') as f:
        w.write(f, px_map)

# Read GFX data while generating expanded output. ZOLE roms already expand Ages,
# so this is only needed for Seasons.
def expandGfx():
    def parseGfxHeader(gfxHeaderAddr, vramData):
        while gfxHeaderAddr != -1:
            if rom[gfxHeaderAddr] == 0:
                # "Unique gfx headers" can reference palettes instead of graphics data.
                palette = rom[gfxHeaderAddr + 1]
                print("WARNING: Palette reference: " + wlahex(palette, 2))
                break
            else:
                # Referencing actual graphics data
                src = read16BE(rom, gfxHeaderAddr+1)
                bank = rom[gfxHeaderAddr] & 0x3f
                dest = read16BE(rom, gfxHeaderAddr+3)
                dest = dest & 0xfff0 # Strip out dest bank number
                size = rom[gfxHeaderAddr+5]&0x7f

                if not (dest >= 0x8800 and dest < 0xa000):
                    print('WARNING: Invalid destination: ' + wlahex(dest))
                elif src >= 0x4000 and src < 0x8000:
                    mode = rom[gfxHeaderAddr]>>6
                    src = bankedAddress(bank, src)

                    decompressed = decompressGfxData(rom, src, size, mode)[1]

                    for i in range(len(decompressed)):
                        d = dest + i - 0x8000
                        assert d < 0x2000, "Invalid destination"
                        vramData[d] = decompressed[i]
                else:
                    print("WARNING: Source from RAM? " + wlahex(src, 4))

            if not (rom[gfxHeaderAddr+5]&0x80 == 0x80): # More data follows?
                break

            gfxHeaderAddr += 6

    def dumpTilesetGraphics(tilesetAddr):
        tilesetData = rom[tilesetAddr : tilesetAddr + 8]
        uniqueIndex = tilesetData[2]
        gfxIndex = tilesetData[3]
        mainAddr = bankedAddress(gfxHeaderBank, read16(rom, gfxHeaderTable + gfxIndex * 2))
        uniqueAddr = bankedAddress(uniqueTilesetHeaderBank,
                                   read16(rom, uniqueTilesetHeaderTable + uniqueIndex * 2))

        vramData = bytearray(0x2000)

        parseGfxHeader(mainAddr, vramData)
        if uniqueIndex != 0:
            parseGfxHeader(uniqueAddr, vramData)

        return vramData

    for tileset in range(0x00, NUM_TILESETS):
        print("Dumping tileset: " + wlahex(tileset, 2))
        tilesetAddr = tilesetDataAddr + tileset*8

        if rom[tilesetAddr] == 0xff: # Seasonal tileset
            assert romIsSeasons(rom), "Seasonal tileset in Ages???"

            for season in range(4):
                print(seasonNames[season])
                seasonTilesetAddr = bankedAddress(tilesetDataBank, read16(rom, tilesetAddr + 1))
                seasonTilesetAddr += season * 8
                vramData = dumpTilesetGraphics(seasonTilesetAddr)
                gfxDataToFile(vramData[0x800:0x1800], 'gfx/' + game + '/gfx_tileset'
                              + myhex(tileset, 2) + '_' + seasonNames[season])

        else:
            vramData = dumpTilesetGraphics(tilesetAddr)
            gfxDataToFile(vramData[0x800:0x1800], 'gfx/' + game + '/gfx_tileset' + myhex(tileset, 2))

    # Placeholder tilesets
    for tileset in range(NUM_TILESETS,0x80):
        gfxData = [0] * 4096
        gfxDataToFile(gfxData, 'gfx/' + game + '/gfx_tileset' + myhex(tileset, 2))


if '-d' in args:
    print('Dumping dungeon layouts.')
    data = rom[dungeonLayoutAddr : dungeonLayoutAddr+0x680]
    f = open('rooms/%s/dungeonLayouts.bin' % game, 'wb')
    f.write(data)
    f.close()

if '-g' in args:
    print('Dumping tileset graphics.')

    # ZOLE Ages roms already have expanded tilesets.
    if romIsAges(rom):
        for tileset in range(0,NUM_TILESETS):
            gfxAddr = 0x181000 + tileset * 0x1000
            gfxData = rom[gfxAddr:gfxAddr+0x1000]
            gfxDataToFile(gfxData, 'gfx/' + game + '/gfx_tileset' + myhex(tileset, 2))

        # Placeholder tilesets
        for tileset in range(NUM_TILESETS,0x80):
            gfxData = [0] * 4096
            gfxDataToFile(gfxData, 'gfx/' + game + '/gfx_tileset' + myhex(tileset, 2))

    # ZOLE Seasons roms don't have expanded tilesets, we must do that ourselves.
    else:
        expandGfx()

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

    targetPath = 'tileset_layouts_expanded/%s/' % game

    # Placeholder mapping files
    # Filled with "00" for tile values and "08" for flag values
    # TODO: Seasons
    def placeholderMapping(tileset):
        targetFile = targetPath + 'tilesetMappings%s.bin' % myhex(tileset, 2)
        os.system(f'truncate --size 0 {targetFile}')
        for i in range(256):
            os.system(f"printf '\\x00\\x00\\x00\\x00\\x08\\x08\\x08\\x08' >> {targetFile}")

    if romIsAges(rom):
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

            targetFile = targetPath + 'tilesetMappings%s.bin' % myhex(tileset, 2)
            outFile = open(targetFile, 'wb')
            outFile.write(tilemapData)
            outFile.close()

        for tileset in range(NUM_TILESETS, 0x80):
            placeholderMapping(tileset)
