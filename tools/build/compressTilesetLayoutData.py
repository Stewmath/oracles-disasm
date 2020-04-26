# Compresses "tilesetCollisions" or "tilesetMappingsIndices" files.
#
import sys
import StringIO
import copy

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 5:
    print 'Usage: ' + sys.argv[0] + ' tilesetData.bin output.cmp mode dictionary.bin'
    print '\tmode: 0 or 1 to select one of the variations to the compression algorithm'
    print '\tdictionary.bin: Use this dictionary file for compression'
    sys.exit()

# The second should be 0x100 but it doesn't improve compression.
# Plus this speeds it up a lot.
# (Why is the dictionary file for mappings so big anyway?)
maxModeLens = [0x12, 0x20]

dictionaryMapping = {}


def compressTilesetData_nomemo(data, i, mode):
    if i == 0:
        res = bytearray()
        return [res, 0, 8]

    possibilities = []

    res = copy.deepcopy(compressTilesetData(data, i-1, mode))
    if res[2] == 8:
        res[2] = 0
        res[1] = len(res[0])
        res[0].append(0)
    res[2]+=1
    res[0].append(data[i-1])

    possibilities.append(res)

    minMatchLen = 3
    maxMatchLen = maxModeLens[mode]
    for j in xrange(i-maxMatchLen, i-minMatchLen):
        if j < 0:
            continue
        matchSize = i-j
        entry = dictionaryMapping.get(bytes(data[j:i]))
        if entry is not None:
            res = copy.deepcopy(compressTilesetData(data, j, mode))
            if res[2] == 8:
                res[2] = 0
                res[1] = len(res[0])
                res[0].append(0)
            res[0][res[1]] |= (1<<res[2])
            res[2]+=1
            if mode == 0:
                assert(matchSize-3 < 0x10 and matchSize-3 >= 0)
                assert(i&0xf000 == 0)
                ptr = entry | (matchSize-3)<<12
                res[0].append(ptr&0xff)
                res[0].append(ptr>>8)
            else:
                assert(matchSize <= 0x100)
                ptr = entry
                res[0].append(matchSize&0xff)
                res[0].append(ptr&0xff)
                res[0].append(ptr>>8)

            possibilities.append(res)

    res = possibilities[0]
    for j in xrange(1, len(possibilities)):
        res2 = possibilities[j]
        if len(res2[0]) <= len(res[0]):
            res = res2
    return res

memo = {}


def compressTilesetData(data, i, mode):
    m = memo.get(bytes(data[0:i]))
    if m is not None:
        return m
    m = compressTilesetData_nomemo(data, i, mode)
    memo[bytes(data[0:i])] = m
    return m

inFile = open(sys.argv[1], 'rb')
inBuf = bytearray(inFile.read())

mode = int(sys.argv[3])

dictionaryFile = open(sys.argv[4], 'rb')
dictionary = bytearray(dictionaryFile.read())

maxLen = maxModeLens[mode]
# Generate dictionaryMapping
for i in range(0, len(dictionary)-3):
    for j in range(i+3, i+maxLen):
        if j > len(dictionary):
            break
        dictionaryMapping[bytes(dictionary[i:j])] = i

# Reduce recursion by parsing this now
for i in range(0, len(inBuf)):
    compressTilesetData(inBuf, i, mode)

outFile = open(sys.argv[2], 'wb')
outFile.write(compressTilesetData(inBuf, len(inBuf), mode)[0])
outFile.close()
