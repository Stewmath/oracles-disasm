#!/usr/bin/python3
#
# Tool specifically for the "link expansion" gfx hack. Copies a portion of gfx_link over
# to gfx_link_fileselect. The game has trouble reading from banks $40 and higher, so this
# is needed for a few things.

import sys

if len(sys.argv) < 1:
    print("Usage: " + sys.argv[0])
    sys.exit(1)
    
gfxFile = open('gfx/gfx_link.bin', 'rb')
gfx = bytearray(gfxFile.read())
gfxFile.close()

gfxOut = bytearray([0] * 0x22e0)

preserveRanges = [(0x200, 0x3a0), (0x1a00, 0x1e00)]

for i in range(len(preserveRanges)):
    start = preserveRanges[i][0]
    end = preserveRanges[i][1]
    
    for j in range(start, end):
        gfxOut[j] = gfx[j]

outFile = open('gfx/gfx_link_oldspot.bin', 'wb')
outFile.write(gfxOut)
outFile.close()
