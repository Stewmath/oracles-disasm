import sys
import io
import yaml
from collections import OrderedDict
from common import *

if len(sys.argv) < 2:
    print('Usage: ' + sys.argv[0] + ' romfile')
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())


class HighIndexStruct:

    def __init__(self):
        self.address = -1
        self.indices = []
        self.size = -1


class TextStruct:

    def __init__(self):
        self.data = None
        self.textData = None
        self.name = None
        self.index = -1  # "Main" index
        self.indices = []  # List of all actual indices
        self.address = -1


# Text printed at the start of the yaml file

commentText = '''
# ==============================================================================
# YAML NOTES
# ==============================================================================
#
# This text is formatted with YAML. One particular thing to note is how
# multiline strings are handled.
#
# In most cases, the block style ("|-") is used, like this:
#
#   text: |-
#     You! Kids aren't
#     allowed in...
#     Sir \Link!
#     Excuse me!
#   null_terminator: True
#
# With this style, newlines are preserved wherever they are. Also, if a line is
# too long, the text parser will automatically insert a newline. But, when
# creating new text, you may prefer to use the flow style (">-"):
#
#   text: >-
#     This is some new text using the flow style.
#     There is no explicit newline here.
#
#     But there is one here.
#   null_terminator: True
#
# The advantage of this style is that you can write long text across multiple
# lines, without worrying about where the line-breaks will actually be in-game.
# With this style, line breaks are ignored unless you have two line-breaks in
# a row. But you still have flexibility to insert explicit linebreaks by leaving
# an empty line.
#
# Most text uses chomping ("-" sign after "|" or ">"), which ignores any
# newlines at the end of the text. But this not the case when the game actually
# does wants to leave a newline at the end of the text, particularly when
# null_terminator is False.
#
# For more information: https://yaml-multiline.info/
#
#
# ==============================================================================
# DESCRIPTION OF KEYS
# ==============================================================================
#
# groups:
#   group: The index for a group. This is the high byte for all text in the
#          group.
#
#   data: List of text data, described below...
#
#   - name: Name assigned to text. When used in the disassembly, this resolves
#           to the full 4-digit (2-byte) text index. The upper 2 digits
#           correspond to the group index; the lower 2 digits correspond to the
#           value of the "index" key below. Can be a single value or a list (see
#           below).
#
#     index: The lower 2 digits (1 byte) of the text index. Combined with the
#           group index (upper 2 digits) to get the full index. This can be
#           a list instead of a single value. In this case, all indices refer to
#           the same data. Also, if this is a list, then the "name" key must
#           also be a list, and must have the same number of entries as this.
#           Each "name" will refer to the corresponding index in this list.
#
#     text: The text string. See text formatting notes.
#
#     null_terminator: True or False. If False, the text does not end here, and
#           the game will continue to show the text that comes after this. In
#           this case, you will usually want to ensure a newline is inserted at
#           the end of the text. (See notes about YAML above.)
#     
#
# TEXT FORMATTING:
# 
# TODO
'''.strip()



# Constants
region = getRomRegion(rom)
language = 0

if romIsAges(rom):
    lastGroupSize = 0x16
    precmpDir = 'precompressed/text/ages/'
    textDir = 'text/ages/'

    if region == "US":
        numHighTextIndices = 0x64

        textBase1IndexStart = 0x00
        textBase1Table = 0xfcfb3

        textBase2IndexStart = 0x2c
        textBase2Table = 0xfcfcb

        # US version only splits text offsets once
        textBase3IndexStart = 0x100
        textBase3Table = 0

        languageTable = 0xfcfe3

    elif region == "EU":
        numHighTextIndices = 0x64

        textBase1IndexStart = 0x00
        textBase1Table = 0xfcfd9

        textBase2IndexStart = 0x1a
        textBase2Table = 0xfcfed

        textBase3IndexStart = 0x34
        textBase3Table = 0xfd001

        languageTable = 0xfd015

    else:
        assert False, "Unsupported region."

elif romIsSeasons(rom):
    lastGroupSize = 0x1d
    precmpDir = 'precompressed/text/seasons/'
    textDir = 'text/seasons/'

    if region == "US":
        numHighTextIndices = 0x64

        textBase1IndexStart = 0x00
        textBase1Table = 0xfcfe2

        textBase2IndexStart = 0x2c
        textBase2Table = 0xfcffa

        textBase3IndexStart = 0x100
        textBase3Table = 0;

        languageTable = 0xfd012
    else:
        assert False, "Unsupported region."
else:
    assert False, "Unsupported rom."


textBase1 = read3BytePointer(rom, textBase1Table+language*4)
textBase2 = read3BytePointer(rom, textBase2Table+language*4)
textBase3 = read3BytePointer(rom, textBase3Table+language*4)
textTable = readReversed3BytePointer(rom, languageTable+language*3)


def getTextBase(index):
    if index < textBase2IndexStart:
        return textBase1
    if index < textBase3IndexStart:
        return textBase2
    return textBase3

highIndexList = []

textTableOutput = io.StringIO()
textTableOutput.write('textTableENG:\n')
for i in range(0, numHighTextIndices):
    textTableOutput.write(
        '\t.dw textTableENG_' + myhex(i, 2) + ' - textTableENG\n')

    address = textTable+read16(rom, textTable+i*2)
    data = None
    for d in highIndexList:
        if d.address == address:
            data = d
            break
    if data is None:
        data = HighIndexStruct()
        data.address = address
        data.indices = [i]
        highIndexList.append(data)
    else:
        data.indices.append(i)
    lastAddress = address

highIndexList = sorted(highIndexList, key=lambda d: d.address)

# First pass through address-sorted tables: calculate table sizes
for i in range(len(highIndexList)):
    data = highIndexList[i]
    if i != 0:
        highIndexList[i-1].size = (data.address - highIndexList[i-1].address)//2

# Size of last one must be hard-coded
highIndexList[len(highIndexList)-1].size = lastGroupSize

textAddressList = set()
textAddressDictionary = {}
textIndexDictionary = {}
textList = set()

lastAddress = 0

# Second pass, print stuff out and get list of text addresses
for i in range(len(highIndexList)):
    data = highIndexList[i]

    if lastAddress != data.address and i != 0:
        textTableOutput.write('; Address mismatch\n')
    for index in data.indices:
        textTableOutput.write(
            'textTableENG_' + myhex(index, 2) + ': ; ' + wlahex(data.address, 4) + '\n')
    for index in range(data.size):
        addr = data.address + index*2
        textAddress = read16(rom, addr)

        textAddress += getTextBase(data.indices[0])
        textAddressList.add(textAddress)

        textStruct = textAddressDictionary.get(textAddress)
        if textStruct is None:
            textStruct = TextStruct()
            textStruct.address = textAddress
            textStruct.index = ((data.indices[0]<<8)|index)
            textAddressDictionary[textAddress] = textStruct
            textIndexDictionary[textStruct.index] = textStruct
            textList.add(textStruct)
        textStruct.indices.append((data.indices[0]<<8)|index)

        textTableOutput.write('\tm_TextPointer text_' + myhex(textAddress, 4))
        textBase = getTextBase(data.indices[0])
        textTableOutput.write(
            ' ' + wlahex(textBase//0x4000, 2) + ' ' + wlahex(textBase&0x3fff, 4) + '\n')

    lastAddress = data.address + data.size*2

# Calculate start & end addresses of the text.
# End address is not precise at this point, but close enough to make everything work.
textStartAddress = min(textAddressList)
textEndAddress = max(textAddressList)+1


# Text table output is obsolete (but still useful for debugging purposes)
# outFile = open('textTable.s', 'w')
# textTableOutput.seek(0)
# outFile.write(textTableOutput.read())
# outFile.close()


def getTextDecompressed(out, address, end=-1):
    if end == -1:
        end = 0x100000000
    i = address
    while i < end:
        b = rom[i]
        if b >= 2 and b < 6 and end-i >= 2:
            dictAddress = textIndexDictionary[((b-2)<<8) | rom[i+1]].address
            getTextDecompressed(out, dictAddress)
            i+=1
        elif b >= 0x6 and b < 0x10:
            data.append(b)
            data.append(rom[i+1])
            i+=1
        else:
            if b == 0:
                if end != 0x100000000:  # Not parsing a dictionary
                    data.append(b)
                break
            data.append(b)
        i += 1

def getTextName(index):
    if index < 0x400:
        return 'DICT' + myhex(index>>8, 1) + '_' + myhex(index&0xff, 2)
    else:
        return 'TX_' + myhex(index-0x400, 4)


definesFile = open(precmpDir + 'textDefines.s','w')
definesFile.write('.define TEXT_OFFSET_SPLIT_INDEX ' + wlahex(textBase2IndexStart) + '\n\n')


# Now pass through the text addresses themselves, start dumping
address = textStartAddress
lastGroup = -1

groupList = []
groupYaml = None
parsedGroups = set()

textGroupList = []
dictGroupList = []

while address < textEndAddress:
    pos = address
    while rom[pos] != 0:
        c = rom[pos]
        pos+=1

        # Special cases (don't have preceding null terminators)
        if textAddressDictionary.get(pos+1) is not None:
            break

        if c >= 0x2 and c < 0x10:
            pos+=1

        # Special cases (don't have preceding null terminators)
        if textAddressDictionary.get(pos+1) is not None:
            break
    pos+=1
    textStruct = textAddressDictionary.get(address)
    if textStruct is None:
        print('text_' + myhex(address, 2) + ' is never referenced')
        print('Output may be malformed')
        out = textDataOutput
    else:
        index = textStruct.index

        if index < 0x400:
            groupList = dictGroupList
            isDict = True
        else:
            groupList = textGroupList
            isDict = False

        if isDict:
            writtenGroupIndex = (index >> 8)
        else:
            writtenGroupIndex = (index >> 8) - 4

        if groupYaml is None or groupYaml['group'] != writtenGroupIndex:
            groupYaml = OrderedDict({'group': writtenGroupIndex})
            groupYaml['data'] = []
            groupList.append(groupYaml)
            if (index >> 8) in parsedGroups:
                print('WARNING: Parsing group 0x%s twice' % myhex(index >> 8, 2))
            parsedGroups.add(index >> 8)

        name = getTextName(index)
        textStruct.name = name
        groupYaml['data'].append(textStruct)

        for ind in textStruct.indices:
            if ind >= 0x400:
                definesFile.write('.define TX_' + myhex(ind-0x400,4) + ' ' + wlahex(ind-0x400,4) + '\n')

    data = bytearray()
    getTextDecompressed(data, address, pos)
    i = 0
    textData = ''

    def fixTrailingSpace():
        global textData
        # Replace any space that occurs before a newline or at the end of
        # a string with "\x20" because YAML doesn't it very well.
        j = len(textData)-1
        while j >= 0 and textData[j] == ' ':
            textData = textData[::-1].replace(' ', '02x\\', 1)[::-1]
            j-=1

    while i < len(data):
        b = data[i]
        if b == 0x27: # Single quote
            textData += "'"
        elif (b >= 0x20 and b < 0x80):
            textData += chr(b)
        elif b == 0x1:
            fixTrailingSpace()
            textData += '\n'
        elif b == 0x6 and len(data)>i+1:
            p = data[i+1]
            if p&0x80 == 0x80:
                textData += '\\item(0x' + myhex(p&0x7f,2) + ')'
            else:
                textData += '\\sym(0x' + myhex(p&0x7f,2) + ')'
            i+=1
        elif b == 0x7 and len(data)>i+1:
            textData += '\\jump(' + getTextName((index & 0xff00) | data[i+1]) + ')'
            i+=1
        elif b == 0x9 and len(data)>i+1:
            if data[i+1] < 0x80:
                textData += '\\col(' + str(data[i+1]) + ')'
            else:
                textData += '\\col(0x' + myhex(data[i+1], 2) + ')'
            i+=1
        elif b == 0xa and len(data)>i+1:
            if data[i+1] == 0:
                textData += '\\Link'
                i+=1
            elif data[i+1] == 0x1:
                textData += '\\Child'
                i+=1
            elif data[i+1] == 0x2:
                textData += '\\secret1'
                i+=1
            elif data[i+1] == 0x3:
                textData += '\\secret2'
                i+=1
            else:
                textData += '\\' + myhex(b, 2)
        elif b == 0xb and len(data)>i+1:
            textData += '\\charsfx(0x' + myhex(data[i+1], 2) + ')'
            i+=1
        elif b == 0xc and len(data)>i+1:
            p = data[i+1]>>3
            c = data[i+1]&3
            if p == 0:
                textData += '\\speed(' + str(c) + ')'
            elif p == 1:
                textData += '\\num1'
            elif p == 2:
                textData += '\\opt()'
            elif p == 3:
                textData += '\\stop'
            elif p == 4:
                textData += '\\pos(' + str(c) + ')'
            elif p == 5:
                textData += '\\heartpiece'
            elif p == 6:
                textData += '\\num2' # This doesn't show up in ages... maybe in seasons
            elif p == 7:
                textData += '\\slow()'
            else:
                print('Bad opcode')
            i+=1
        elif b == 0xd and len(data)>i+1:
            textData += '\\wait(' + str(data[i+1]) + ')'
            i+=1
        elif b == 0xe and len(data)>i+1:
            textData += '\\sfx(0x' + myhex(data[i+1], 2) + ')'
            i+=1
        elif b == 0xf and len(data)>i+1:
            p=data[i+1]
            if p < 0xfc:
                textData += '\\call(' + getTextName((index & 0xff00) | p) + ')'
            else:
                textData += '\\call(0x' + myhex(p,2) + ')'
            i+=1
        elif b >= 0x6 and b < 0x10:
            textData += '\\cmd' + myhex(b, 1) + '(0x' + myhex(data[i+1], 2) + ')'
            i+=1
        elif b == '\\':
            textData += '\\\\'
        elif b == 0x10:
            textData += '\\circle'
        elif b == 0x11:
            textData += '\\club'
        elif b == 0x12:
            textData += '\\diamond'
        elif b == 0x13:
            textData += '\\spade'
        elif b == 0x14:
            textData += '\\heart'
        elif b == 0x15:
            textData += '\\up'
        elif b == 0x16:
            textData += '\\down'
        elif b == 0x17:
            textData += '\\left'
        elif b == 0x18:
            textData += '\\right'
        elif b == 0xb8 and len(data)>i+1 and data[i+1] == 0xb9:
            textData += '\\abtn'
            i+=1
        elif b == 0xba and len(data)>i+1 and data[i+1] == 0xbb:
            textData += '\\bbtn'
            i+=1
        elif b == 0x7e:
            textData += '\\triangle'
        elif b == 0x7f:
            textData += '\\rectangle'
        else:
            if not (b == 0 and i == len(data)-1):
                textData += '\\' + myhex(b, 2)
        i+=1

    fixTrailingSpace()

    textStruct.data = data
    textStruct.textData = textData

    textStruct.hasNullTerminator = data[len(data)-1] == 0

    address = pos

    if address > textEndAddress:
        textEndAddress = address

definesFile.close()

# Output precompressed text blob
outFile = open(precmpDir + 'textData.s', 'w')
outFile.write('; Precompressed blob of text data since my compression algorithms aren\'t 1:1.\n')
outFile.write('; Unset USE_VANILLA in the makefile if you want to edit text.txt instead of using this.\n\n')
outFile.write('.DEFINE TEXT_END_ADDR ' + wlahex(toGbPointer(textEndAddress),4) + '\n')
outFile.write('.DEFINE TEXT_END_BANK ' + wlahex(textEndAddress//0x4000,2) + '\n\n')
outFile.write('.BANK ' + wlahex(textTable//0x4000) + '\n')
outFile.write('.ORGA ' + wlahex(toGbPointer(textTable)) + '\n\n')

outFile.write('textTableENG:')
i = 8
address = textTable
while address < textEndAddress:
    if address == textBase1:
        i = 8
        outFile.write('\nTEXT_OFFSET_1:')
    elif address == textBase2:
        i = 8
        outFile.write('\nTEXT_OFFSET_2:')
    if i == 8:
        outFile.write('\n\t.db')
        i = 0
    outFile.write(' ' + wlahex(rom[address],2))
    i+=1
    address+=1
    if (address&0x3fff) == 0:
        i = 8
        outFile.write('\n\n.BANK ' + wlahex(address//0x4000,2) + '\n')
        outFile.write('.ORGA $4000\n')
outFile.write('\n')
outFile.close()


# Setup yaml to use OrderedDict instead of dict
def setup_yaml():
    """ https://stackoverflow.com/a/8661021 """
    represent_dict_order = lambda self, data: self.represent_mapping('tag:yaml.org,2002:map', data.items())
    yaml.add_representer(OrderedDict, represent_dict_order)

    stringTag = 'tag:yaml.org,2002:str'

    def stringNode(s):
        return yaml.ScalarNode(stringTag, s)

    def intNode(i):
        return yaml.ScalarNode('tag:yaml.org,2002:int', i)

    def boolNode(b):
        return yaml.ScalarNode('tag:yaml.org,2002:bool', str(b))

    def stringMap(s1, s2):
        return (stringNode(s1), stringNode(s2))

    def representTextStruct(dumper, data):
        dataList = [
            #(stringNode('index'), stringNode('0x' + myhex(data.index, 4))),
        ]

        if len(data.indices) != 1:
            extraIndexList = data.indices
            assert(extraIndexList == sorted(extraIndexList))

            nameList = [stringNode(getTextName(x)) for x in extraIndexList]
            dataList.append((stringNode('name'), yaml.SequenceNode('tag:yaml.org,2002:seq', nameList)))

            extraIndexList = [intNode('0x' + myhex(x&0xff, 2)) for x in extraIndexList]
            dataList.append((stringNode('index'), yaml.SequenceNode('tag:yaml.org,2002:seq', extraIndexList)))
        else:
            assert(data.indices[0] == data.index)
            dataList.append(stringMap('name', data.name))
            dataList.append((stringNode('index'), intNode('0x' + myhex(data.index&0xff, 2))))

        dataList.append((stringNode('text'), dumper.represent_scalar(stringTag, data.textData, '|')))
        dataList.append((stringNode('null_terminator'), boolNode(data.hasNullTerminator)))

        return yaml.MappingNode('tag:yaml.org,2002:map', dataList)

    yaml.add_representer(TextStruct, representTextStruct)

    # Default int representation: 2-digit hex number
    yaml.add_representer(int, lambda dumper, i: intNode('0x' + myhex(i, 2)))

setup_yaml()


def dumpYaml(l, outStream):
    s = yaml.dump({'groups': l})

    # Add some spacing to make it nicer.
    # Must be careful with this. It could break block text which doesn't trim
    # newlines. For this reason the "null_terminator" key is always present after
    # the "text" key to make sure that doesn't happen.
    s = s.replace("\n- group:", "\n\n- group:")
    s = s.replace("groups:\n\n", "groups:\n")
    s = s.replace("\n  - name:", "\n\n  - name:")
    s = s.replace("\n  data:\n\n", "\n  data:\n")

    outStream.write(s)


outFile = open(textDir + 'dict.yaml', 'w')
dumpYaml(dictGroupList, outFile)
outFile.close()

outFile = open(textDir + 'text.yaml', 'w')
outFile.write(commentText + '\n')
dumpYaml(textGroupList, outFile)
outFile.close()

# Debug output: write a decompressed blob of all the text.

#outFile = open(textDir + 'text_blob_decompressed.bin','wb')
#lastAddress = -1
#for address in sorted(textAddressList):
#    if address < lastAddress:
#        print('BAD')
#    lastAddress = address
#    textStruct = textAddressDictionary[address]
#    if textStruct.data is None:
#        print('Index ' + hex(textStruct.index) + ' uninitialized')
#    else:
#        outFile.write(textStruct.data)
#outFile.close()
