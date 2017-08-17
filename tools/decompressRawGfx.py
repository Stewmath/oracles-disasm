# Decompresses a single compressed gfx file, where the first byte of the file is NOT the
# compression mode (so not the format of ".cmp" files).

import sys

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 4:
    print 'Usage: ' + sys.argv[0] + ' gfxFile outFile size cmpMode'
    print '\ncmpMode is a number from 0-3. If omitted, it uses the first byte of the input file.'
    sys.exit()

gfxFile = open(sys.argv[1], 'rb')
gfx = bytearray(gfxFile.read())
gfxFile.close()

outFile = open(sys.argv[2], 'wb')

size = int(sys.argv[3])

if len(sys.argv) >= 5:
    mode = int(sys.argv[4])
else:
    mode = gfx[0]
    gfx = gfx[1:]

retData = decompressGfxData(gfx, 0, size, mode)
outFile.write(retData[1])
outFile.close()
