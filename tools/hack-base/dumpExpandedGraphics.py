#!/usr/bin/env python3
import sys, os

# Import directories for common.py, gfx.py, png.py
sys.path.append(os.path.dirname(__file__) + '/..')
sys.path.append(os.path.dirname(__file__) + '/../gfx')

import gfx, png

from common import *

filename = sys.argv[1]

romFile = open(filename, 'rb')
rom = bytearray(romFile.read())

seasonNames = ['spring', 'summer', 'autumn', 'winter']


if romIsAges(rom):
    NUM_TILESETS = 0x67

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
else:
    print('Unknown ROM.')
    sys.exit(1)

targetPath = 'tileset_layouts_expanded/%s/' % game

# Hardcoded stuff: some indices don't have their own files
# See data/{game}/tilesetHeaders.s in master branch
def fixHardcodedTilemap(tilemap):
    if game == 'ages':
        if tilemap == 0x20:
            return 0x1b
        elif tilemap == 0x32:
            return 0x2b
    else: # Seasons
        if tilemap == 0x05:
            return 0x04
        if tilemap == 0x2e:
            return 0x2d
        elif tilemap == 0x31:
            return 0x30
    return tilemap

# Placeholder mapping files
# Filled with "00" for tile values and "08" for flag values
# TODO: Seasons
def placeholderMapping(tileset):
    targetFile = targetPath + 'tilesetMappings%s.bin' % myhex(tileset, 2)
    os.system(f'truncate --size 0 {targetFile}')
    for i in range(256):
        os.system(f"printf '\\x00\\x00\\x00\\x00\\x08\\x08\\x08\\x08' >> {targetFile}")

def dumpTilemaps():
    # Dump tilemapping & collision data.
    # ZOLE actually has no support for collision data, so as a shortcut, we just
    # copy over data from the original disassembly. (The source files for this
    # are only available on the master branch.)
    # Tilemapping data also needs to be dumped in this manner for Seasons, but
    # not Ages, as ZOLE expanded the data in Ages only.
    # This only needed to be run once, for the hack-base branch initial setup,
    # so it's wrapped in an "if False" statement now.
    def dumpMapping(tilesetStart, suffix):
        tilemap = rom[tilesetStart + 5]
        tilemap = fixHardcodedTilemap(tilemap)

        # Mapping
        origFile = 'tileset_layouts/' + game + '/tilesetMappings%s.bin' % myhex(tilemap, 2)
        targetFile = targetPath + 'tilesetMappings' + suffix + '.bin'
        os.system('cp %s %s' % (origFile, targetFile))

        # Collision
        origFile = 'tileset_layouts/' + game + '/tilesetCollisions%s.bin' % myhex(tilemap, 2)
        targetFile = targetPath + 'tilesetCollisions' + suffix + '.bin'
        os.system('cp %s %s' % (origFile, targetFile))

    # Mapping data
    for tileset in range(0,NUM_TILESETS):
        tilesetAddr = tilesetDataAddr + tileset * 8
        if rom[tilesetAddr] == 0xff: # Seasonal tileset
            for season in range(4):
                seasonData = bankedAddress(tilesetDataBank,
                                            read16(rom, tilesetAddr + 1))
                seasonData += season * 8
                suffix = f'{myhex(tileset, 2)}_{seasonNames[season]}'
                dumpMapping(seasonData, suffix)
        else: # Non-seasonal tileset
            suffix = myhex(tileset, 2)
            dumpMapping(tilesetAddr, suffix)

    # Placeholder data for new blank tilesets
    # TODO: Seasons
    for tileset in range(NUM_TILESETS, 0x80):
        placeholderMapping(tileset)

        targetFile = targetPath + 'tilesetCollisions%s.bin' % myhex(tileset, 2)
        os.system(f'dd if=/dev/zero of={targetFile} bs=1 count=256 2>/dev/null')



dumpTilemaps()
