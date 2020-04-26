import sys
import StringIO
import copy

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 3:
    print 'Usage: ' + sys.argv[0] + ' roomLayout.bin output.cmp [-o] [-d dictionary.bin]'
    print '\t-o: Compress optimally (instead of trying to match capcom\'s algorithm)'
    print '\t\tThis is implied when using dictionary compression.'
    print '\t-d: Use dictionary compression with the given dictionary file (for large rooms / dungeons)'
    sys.exit()

dictionaryMapping = {}


def compressRoomLayout_dictionary_nomemo(data, i, dictionary):
    if i == 0:
        res = bytearray()
        return [res, 0, 8]

    possibilities = []

    res = copy.deepcopy(compressRoomLayout_dictionary(data, i-1, dictionary))
    if res[2] == 8:
        res[2] = 0
        res[1] = len(res[0])
        res[0].append(0)
    res[2]+=1
    res[0].append(data[i-1])

    possibilities.append(res)

    for j in xrange(i-0x12, i-2):
        if j < 0:
            continue
        matchSize = i-j
        entry = dictionaryMapping.get(bytes(data[j:i]))
        if entry is not None:
            res = copy.deepcopy(
                compressRoomLayout_dictionary(data, j, dictionary))
            if res[2] == 8:
                res[2] = 0
                res[1] = len(res[0])
                res[0].append(0)
            res[0][res[1]] |= (1<<res[2])
            res[2]+=1
            ptr = entry | ((matchSize-3)<<12)
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


def compressRoomLayout_dictionary(data, i, dictionary):
    m = memo.get(bytes(data[0:i]))
    if m is not None:
        return m
    m = compressRoomLayout_dictionary_nomemo(data, i, dictionary)
    memo[bytes(data[0:i])] = m
    return m


optimal = False
compressionMode = 'commonbyte'
game = ''

i = 3
while i < len(sys.argv):
    if sys.argv[i] == '-o':
        optimal = True
    elif sys.argv[i] == '-d':
        if i+1 < len(sys.argv):
            compressionMode = 'dictionary'
            i+=1
            dictionaryFilename = sys.argv[i]
    else:
        print 'Unrecognized commandline argument "' + sys.argv[i] + '".'
        sys.exit(1)
    i+=1

layoutFile = open(sys.argv[1], 'rb')
layoutData = bytearray(layoutFile.read())

if compressionMode == 'commonbyte':
    possibilities = []

    possibilities.append(layoutData)
    possibilities.append(compressData_commonByte(layoutData, 1))
    possibilities.append(compressData_commonByte(layoutData, 2))

    smallestLen = 0x500
    smallestIndex = -1

    for i in range(len(possibilities)):
        candidate = possibilities[i]
        notdir = sys.argv[1]
        if notdir.index('/') != -1:
            notdir = notdir[notdir.rindex('/')+1:]
        if i == 0 or len(candidate) <= smallestLen:
            smallestLen = len(candidate)
            smallestIndex = i

    # If either of the compression methods is larger than the raw data, use the raw data.
    # This very strange condition compromises the compression, but makes it match the
    # original game.
    if not optimal:
        if len(possibilities[1]) >= len(possibilities[0]) \
                or len(possibilities[2]) >= len(possibilities[0]):
            smallestIndex = 0

    outFile = open(sys.argv[2], 'wb')
    outFile.write(chr(smallestIndex))
    outFile.write(possibilities[smallestIndex])
    outFile.close()
elif compressionMode == 'dictionary':
    dictionaryFile = open(dictionaryFilename, 'rb')
    dictionary = bytearray(dictionaryFile.read())

    # Generate dictionaryMapping
    for i in range(0, 0x1000-3):
        for j in range(i+3, i+0x12):
            if j > 0x1000:
                break
            dictionaryMapping[bytes(dictionary[i:j])] = i

    outFile = open(sys.argv[2], 'wb')
    outFile.write(chr(3))
    outFile.write(compressRoomLayout_dictionary(
        layoutData, len(layoutData), dictionary)[0])
    outFile.close()
