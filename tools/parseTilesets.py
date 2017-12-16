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
import StringIO
import copy
import operator

index = sys.argv[0].rfind('/') 
if index == -1:
	directory = ''
else:
	directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 2:
	print 'Usage: ' + sys.argv[0] + ' ages|seasons'
	sys.exit()


game = sys.argv[1]

tilesetsDirectory = 'tilesets/' + game + '/'

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

    outFile = open('build/tilesets/' + filename[0:len(filename)-4] + 'Indices.bin', 'wb')
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

    for i in range(0,256,16):
        key = bytes(buf[i*2:i*2+2*16])
        if key not in dictionaryStrings:
            val = 0
        else:
            val = dictionaryStrings[key]
        dictionaryStrings[key] = val+1

indexList = []
attributeList = []

mappingsOutFile = open('build/tilesets/tileMappingTable.bin', 'wb')
indexOutFile = open('build/tilesets/tileMappingIndexData.bin', 'wb')
attributeOutFile = open('build/tilesets/tileMappingAttributeData.bin', 'wb')

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
        print 'WARNING: more than 0x1000 unique tile index arrangements, this is bad'
    if attributeI >= 0x1000:
        print 'WARNING: more than 0x1000 unique tile attribute arrangements, this is bad'

    b1 = indexI&0xff
    b2 = ((indexI>>4)&0xf0) | (attributeI>>8)
    b3 = attributeI&0xff

    mappingsOutFile.write(chr(b1))
    mappingsOutFile.write(chr(b2))
    mappingsOutFile.write(chr(b3))

mappingsOutFile.close()
indexOutFile.close()
attributeOutFile.close()


# dictionary file
# My generation of the dictionary file doesn't provide nearly as good
# compression as the stock game, but this at least compresses it enough
file = open('build/tilesets/mappingsDictionary.bin', 'wb')
for key in dictionaryStrings.keys():
    val = dictionaryStrings[key]
    if val > 1:
        file.write(bytearray(key))
file.close()
