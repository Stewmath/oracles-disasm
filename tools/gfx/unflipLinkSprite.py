#!/usr/bin/python3
# Python script for the oracles-randomizer: Dumps a Link sprite from an oracles ROM and "unflips" it
# into the format accepted by oracles-randomizer, so that sprites can be modified in a more flexible
# way. Use this to port sprite modifications made on vanilla Ages/Seasons or earlier versions of the
# randomizer onto the newest version which "unflips" the sprites.
#
# Somewhat intelligently detects whether it's a randomizer expanded ROM or not; if it is, then it
# knows not to do the actual unflipping and it will just dump the raw sprite data. This assumes that
# link's sprite data is always at the beginning of bank $1a.

import sys
from PIL import Image

# 8x16 sprites to be "unflipped" (key = src tile x/y, value = dest tile x/y, where x/y are positions
# in the sprite sheet measured in 8x16 tiles)
unflips = {
        (13,1): (0,19),
        (14,1): (14,1),
        (15,1): (0,4),
        (0,4): (2,19),
        (1,4): (4,19),
        (8,4): (8,4),
        (15,4): (6,5),
        (4,5): (4,5),
        (5,5): (0,6),
        (6,5): (2,6),
        (7,5): (4,6),
        (0,6): (0,18),
        (1,6): (2,18),
        (2,6): (4,18),
        (15,6): (2,4),
        (4,7): (4,7),
        (5,7): (6,7),
        (10,7): (6,12),
        (11,7): (8,12),
        (6,12): (10,18),
        (7,12): (12,18),
        }

# 16x16 sprites to be shifted somewhere else
translations = {
        (2,4): (6,19),
        (9,4): (10,4),
        (11,4): (12,4),
        (13,4): (14,4),
        (3,6): (6,18),
        (5,6): (8,18),
        (6,7): (8,7),
        (8,7): (10,7),
        (8,12): (14,18),
        }


# Width/height of spritesheets in 8x16 tiles
WIDTH = 16
INPUT_HEIGHT = 18
OUTPUT_HEIGHT = 20

linkSpriteAddr = 0x1a * 0x4000

inFilename = sys.argv[1]
outFilename = 'gfx/common/spr_link.png'

f = open(inFilename, 'rb')
rom = f.read()
f.close()

isExpandedRom = len(rom) >= 2097152

if isExpandedRom:
    INPUT_HEIGHT = OUTPUT_HEIGHT

lastRowEnd = 8 if isExpandedRom else 7


PALETTES = [0x00, 0x00, 0x00, 0x55, 0x55, 0x55, 0xaa, 0xaa, 0xaa, 0xff, 0xff, 0xff]


def drawTile(img, x, y, address, flipX=False):
    for j in range(0,16):
        b1 = rom[address + j*2]
        b2 = rom[address + j*2 + 1]
        for i in range(0,8):
            c = (b1&1) | ((b2&1)<<1)
            b1 >>= 1
            b2 >>= 1

            if flipX:
                img.putpixel((x + i, y + j), c)
            else:
                img.putpixel((x + (7-i), y + j), c)

img = Image.new('P', (WIDTH * 8, OUTPUT_HEIGHT * 16), 0)
img.putpalette(PALETTES, 'RGB')

y = 0
while y < INPUT_HEIGHT:
    x = 0
    while x < WIDTH:
        if y == INPUT_HEIGHT-1 and x >= lastRowEnd: # Last couple tiles bleed into non-link stuff
            break
        srcAddr = linkSpriteAddr + ((y * 16) + x) * 0x20
        destX = x
        destY = y
        if not isExpandedRom and (x,y) in unflips:
            destX, destY = unflips[x,y]
            drawTile(img, destX * 8, destY * 16, srcAddr)
            drawTile(img, destX * 8 + 8, destY * 16, srcAddr, True)
        elif not isExpandedRom and (x,y) in translations:
            destX, destY = translations[x,y]
            drawTile(img, destX * 8, destY * 16, srcAddr)
            drawTile(img, destX * 8 + 8, destY * 16, srcAddr + 0x20)
            x = x+1
        else:
            drawTile(img, destX * 8, destY * 16, srcAddr)

        x = x+1
    y = y+1

outFile = open(outFilename, 'wb')
img.save(outFile)
outFile.close()
