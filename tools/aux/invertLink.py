#!/usr/bin/python3
#
# Inverts colors 1 and 3 in gfx_link.bin.
#
# If parameters "start" and "end" are passed, this works on any file rather than being
# hardcoded for link's file specifically.

import sys

if len(sys.argv) < 3 or len(sys.argv) > 3 and len(sys.argv) < 7:
    print("Usage: " + sys.argv[0] + " gfx_link.bin output.bin [color1 color2 start end]")
    sys.exit(1)
    
gfxFile = open(sys.argv[1], 'rb')
gfx = bytearray(gfxFile.read())
gfxFile.close()

if len(sys.argv) >= 7:
    color1 = int(sys.argv[3])
    color2 = int(sys.argv[4])
    start = int(sys.argv[5])
    end = int(sys.argv[6])
    rng = range(start,end)
else:
    color1 = 1
    color2 = 3
    rng = range(len(gfx)//16)

for i in rng:
    if start is None and i >= 0x1b8 and i < 0x1dc:
        continue
    for y in range(8):
        b1 = gfx[i*16 + y*2]
        b2 = gfx[i*16 + y*2 + 1]
        newB1 = 0
        newB2 = 0
        for x in range(8):
            c = ((b1>>x) & 1) | (((b2>>x) & 1)<<1)
            if c == color1:
                c = color2
            elif c == color2:
                c = color1
            newB1 |= (c&1)<<x
            newB2 |= ((c>>1)&1)<<x
        gfx[i*16 + y*2] = newB1
        gfx[i*16 + y*2 + 1] = newB2
    

outFile = open(sys.argv[2], 'wb')
outFile.write(gfx)
outFile.close()
