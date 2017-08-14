# Decompresses a single compressed gfx file, where the first byte of the file is NOT the
# compression mode (so not the format of ".cmp" files).

import sys

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 5:
    print 'Usage: ' + sys.argv[0] + ' cmpMode size gfxFile outFile'
    print '\ncmpMode is a number from 0-3.'
    sys.exit()

mode = int(sys.argv[1])
size = int(sys.argv[2])

gfxFile = open(sys.argv[3], 'rb')
gfx = bytearray(gfxFile.read())
gfxFile.close()

outFile = open(sys.argv[4], 'wb')

retData = decompressGfxData(gfx, 0, size, mode)
outFile.write(retData[1])
outFile.close()
