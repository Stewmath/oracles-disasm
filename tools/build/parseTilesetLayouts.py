#!/usr/bin/python3
# Compresses "tilesetMappings*.bin" files.
# These files are abstracted to make them more straightforward to modify.
# They need to be processed together and broken down into:
#   tileMappingIndexData.bin
#   tileMappingAttributeData.bin
#   tileMappingTable.bin
#   mappingsDictionary.bin
#   tilesetMappingsXXIndices.bin

import sys
import os
import io
import copy
import operator

sys.path.append(os.path.dirname(__file__) + '/..')
from common import *

if len(sys.argv) < 3:
	print('Usage: ' + sys.argv[0] + ' ages|seasons build_directory')
	sys.exit(1)


game = sys.argv[1]
build_dir = sys.argv[2]

tilesetsDirectory = 'tileset_layouts/' + game + '/'

fl = os.listdir(tilesetsDirectory)
fileList = []

for filename in fl:
    if 'Mappings' in filename:
        fileList.append(filename)

# Sort by hex number at end of filename
fileList = sorted(fileList, key=lambda x:int(x[15:17],16))
dictionaryStrings = {}

tileList = []

# Generate tilesetMappingsXXIndices files
for filename in fileList:
    file = open(tilesetsDirectory + filename, 'rb')
    fileData = file.read()

    outFile = open(build_dir + '/tileset_layouts/' + filename[0:len(filename)-4] + 'Indices.bin', 'wb')
    buf = bytearray()

    for i in range(256):
        data = bytes(fileData[i*8:i*8+8])

        if data in tileList:
            index = tileList.index(data)
        else:
            index = len(tileList)
            tileList.append(data)
        buf.append(index&0xff)
        buf.append(index>>8)

    outFile.write(buf)
    outFile.close()

    # Some stats on data compression with various values for SIZE - end addresses of
    # mapping data (in seasons)
    #
    # orig: 676d0
    # 4:    67ca0
    # 8:    66e58
    # 16:   66b8d
    # 32:   67063
    SIZE = 16
    for i in range(0,256,SIZE):
        key = bytes(buf[i*2:i*2+2*SIZE])
        if key not in dictionaryStrings:
            val = 0
        else:
            val = dictionaryStrings[key]
        dictionaryStrings[key] = val+1

indexList = []
attributeList = []

mappingsOutFile = open(build_dir + '/tileset_layouts/tileMappingTable.bin', 'wb')
indexOutFile = open(build_dir + '/tileset_layouts/tileMappingIndexData.bin', 'wb')
attributeOutFile = open(build_dir + '/tileset_layouts/tileMappingAttributeData.bin', 'wb')

for i in range(len(tileList)):
    data = tileList[i]

    indexData = bytes(data[0:4])
    attributeData = bytes(data[4:8])

    # Check if the data exists in the indexList, add it if it doesn't
    if indexData in indexList:
        indexI = indexList.index(indexData)
    else:
        indexI = len(indexList)
        indexOutFile.write(indexData)
        indexList.append(indexData)

    # Same for attributes
    if attributeData in attributeList:
        attributeI = attributeList.index(attributeData)
    else:
        attributeI = len(attributeList)
        attributeOutFile.write(attributeData)
        attributeList.append(attributeData)

    if indexI >= 0x1000 :
        print('WARNING: more than 0x1000 unique tile index arrangements, this is bad')
    if attributeI >= 0x1000:
        print('WARNING: more than 0x1000 unique tile attribute arrangements, this is bad')

    b1 = indexI&0xff
    b2 = ((indexI>>4)&0xf0) | (attributeI>>8)
    b3 = attributeI&0xff

    mappingsOutFile.write(bytes([b1]))
    mappingsOutFile.write(bytes([b2]))
    mappingsOutFile.write(bytes([b3]))

mappingsOutFile.close()
indexOutFile.close()
attributeOutFile.close()


# Generate dictionary file. Every X-byte chunk that's used more than once is put into the
# dictionary.
file = open(build_dir + '/tileset_layouts/mappingsDictionary.bin', 'wb')
for key in list(dictionaryStrings.keys()):
    val = dictionaryStrings[key]
    if val > 1:
        file.write(bytearray(key))
file.close()
