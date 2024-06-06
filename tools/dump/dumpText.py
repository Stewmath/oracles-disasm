#!/usr/bin/python3
# Note about dumping European text: There's something odd about Ages's
# French/Spanish text, and Season's French text.
#
# There are 4 dictionary groups, but they only use group 0. Groups 1-3 reference
# pieces of "actual" text data for no reason. It's even worse in French Seasons,
# where it references the MIDDLE of pieces of text, which seriously screws up
# the text dump!
#
# Anyway, these versions are barely compressed at all, using only a few entries
# in dictionary group 0. In order to fix the above mentioned issues, dictionary
# groups 1-3 are completely ignored. This shouldn't cause any problems unless
# one is trying to get a perfect 1:1 data match.

import sys
import os
import io
import yaml
from collections import OrderedDict

sys.path.append(os.path.dirname(__file__) + '/..')
from common import *


# There is partial support for dumping Japanese text, but currently it can't be
# parsed by parseText.py.
jpKanaTable = """
あいうえお
かきくけこ
さしすせそ
たちつてと
なにぬねの
はひふへほ
まみむめも
やゆよ
らりるれろ
わをん
ぁぃぅぇぉっゃゅょ
がぎぐげご
ざじずぜぞ
だぢづでど
ばびぶべぼ
ぱぴぷぺぽ

アイウエオ
カキクケコ
サシスセソ
タチツテト
ナニヌネノ
ハヒフヘホ
マミムメモ
ヤユヨ
ラリルレロ
ワヲン
ァィゥェォッャュョ
ガギグゲゴ
ザジズゼゾ
ダヂヅデド
バビブベボ
パピプペポ
""".replace('\n', '')


# Kanji characters. Values with "?" are represented with the "\sym(XX)" opcode instead of
# a character when being dumped.
#   0x1b: Unused, can't decipher
#   0x1c: Musical note
#   0x4f: I think this is a "keyhole" drawing and not an actual kanji.
#   0x57: Triforce symbol
jpKanjiTable = """
姫村下木東西南北地図出入口水氷池
見門手力知恵勇気火金銀？？実上四
季春夏秋冬右左大小本王国男女少年
山人世中々剣花闇将軍真支配者鉄目
詩死心節甲邪悪魔聖川結界生時炎？
天空暗黒塔海仙？
""".replace('\n', '')


# Special characters table
#   some ? values are references to graphics display
#   0xb8 and 0xb9 are the abtn
#   0xba and 0xbb are the bbtn
#   0xbd is a small heart icon
specCharTable = """
ÀÂÄÆÇÈÉÊËÎÏÑÖŒÙÛ
Üß??????¡¿??????
àâäæçèéêëîïñöœùû
ü´??????????????
Ô°ÁÍÓÚÌÒÅ???????
ôªáíóúìòå???????
""".replace('\n', '')


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


if len(sys.argv) < 2:
    print('Usage: ' + sys.argv[0] + ' romfile [language]')
    print('\n"language" is a number from 0-4, for dumping from European ROMS.')
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

if len(sys.argv) > 2:
    language = int(sys.argv[2])
else:
    language = 0


# Constants
region = getRomRegion(rom)

textBase1 = None
textBase2 = None
textBase3 = None
textTable = None

if romIsAges(rom):
    numHighTextIndices = 0x64
    lastGroupSize = 0x16
    precmpDir = 'precompressed/text/ages/'
    textDir = 'text/ages/'

    if region == "US":
        textBase1IndexStart = 0x00
        textBase1Table = 0xfcfb3

        textBase2IndexStart = 0x2c
        textBase2Table = 0xfcfcb

        # US version only splits text offsets once
        textBase3IndexStart = 0x100
        textBase3Table = 0

        languageTable = 0xfcfe3

    elif region == "EU":
        textBase1IndexStart = 0x00
        textBase1Table = 0xfcfd9

        textBase2IndexStart = 0x1a
        textBase2Table = 0xfcfed

        textBase3IndexStart = 0x34
        textBase3Table = 0xfd001

        languageTable = 0xfd015

    elif region == "JP":
        textBase1IndexStart = 0x00
        textBase1Table = bankedAddress(0x3f, 0x4f63)

        textBase2IndexStart = 0x34
        textBase2Table = -1 # JAPANESE VERSION ONLY: Use hardcoded value (below) instead of table lookup
        textBase2 = bankedAddress(0x22, 0x09f5)

        textBase3IndexStart = 0x100
        textBase3Table = 0

        # JAPANESE VERSION ONLY: "languageTable" does not exist, define
        # "textTable" directly.
        textTable = bankedAddress(0x1e, 0x4000)
    else:
        assert False, "Unsupported region."

elif romIsSeasons(rom):
    numHighTextIndices = 0x64
    lastGroupSize = 0x1d
    precmpDir = 'precompressed/text/seasons/'
    textDir = 'text/seasons/'

    if region == "US":
        textBase1IndexStart = 0x00
        textBase1Table = 0xfcfe2

        textBase2IndexStart = 0x2c
        textBase2Table = 0xfcffa

        textBase3IndexStart = 0x100
        textBase3Table = 0

        languageTable = 0xfd012

    elif region == "EU":
        textBase1IndexStart = 0x00
        textBase1Table = 0xfd008

        textBase2IndexStart = 0x1a
        textBase2Table = 0xfd01c

        textBase3IndexStart = 0x34
        textBase3Table = 0xfd030

        languageTable = 0xfd044
    elif region == "JP":
        textBase1IndexStart = 0x00
        textBase1Table = bankedAddress(0x3f, 0x4f92)

        textBase2IndexStart = 0x34
        textBase2Table = -1 # JAPANESE VERSION ONLY: Use hardcoded value (below) instead of table lookup
        textBase2 = bankedAddress(0x1f, 0x21df)

        textBase3IndexStart = 0x100
        textBase3Table = 0

        # JAPANESE VERSION ONLY: "languageTable" does not exist, define
        # "textTable" directly.
        textTable = bankedAddress(0x1d, 0x4000)
    else:
        assert False, "Unsupported region."
else:
    assert False, "Unsupported rom."


if textBase1 == None:
    textBase1 = read3BytePointer(rom, textBase1Table+language*4)
if textBase2 == None:
    textBase2 = read3BytePointer(rom, textBase2Table+language*4)
if textBase3 == None:
    textBase3 = read3BytePointer(rom, textBase3Table+language*4)
if textTable == None:
    textTable = readReversed3BytePointer(rom, languageTable+language*3)


# See note at top of file
def ignoreDictionaries123():
    if region != "EU":
        return False
    if language == 1: # French
        return True
    if romIsAges(rom) and language == 4: # Spanish
        return True
    return False


def getTextBase(index):
    if index < textBase2IndexStart:
        return textBase1
    if index < textBase3IndexStart:
        return textBase2
    return textBase3


# Converts a byte to a character.
def lookupNormalCharacter(b):
    assert(isNormalCharacter(b))
    if region == "JP":
        if b < 0x20:
            if b == 0x1a: # LEFT quotation mark
                return '“'
            elif b == 0x1b:
                return '「'
            elif b == 0x1c:
                return '」'
            elif b == 0x1e:
                return '、'
            else:
                assert(False) # Anything else below 0x20 is unused
        elif b < 0x60:
            if b == 0x20: # Fullwidth space
                return '　'
            elif b == 0x22: # RIGHT quotation mark (Override "normal" quotation mark)
                return '”'
            elif b == 0x5c:
                return '〜'
            elif b == 0x5f:
                return '。'
            else:
                return chr(0xff00 + b - 0x20) # Fullwidth form
        else:
            return jpKanaTable[b-0x60]
    if region == "EU":
        if b == 0x1a: # For some reason french, german, italian use the left quotation mark
            return '“'
        if b == 0x5c:
            return '~'
        return chr(b)
    else:
        if b == 0x5c:
            return '~'
        return chr(b)

def lookupSpecialCharacter(b):
    assert(isSpecialCharacter(b))
    return specCharTable[b-0x80]

def lookupSymbol(b):
    if b >= 0x60:
        return None
    c = jpKanjiTable[b]
    if c == '？':
        return None
    return c

def isNormalCharacter(b):
    if region == "JP":
        return b >= 0x20 or b == 0x1a or b == 0x1b or b == 0x1c or b == 0x1e
    if region == "EU":
        return (b >= 0x20 and b < 0x80) or b == 0x1a
    else:
        return b >= 0x20 and b < 0x80

def isSpecialCharacter(b):
    if region == "JP":
        return False # No special characters in japanese rom
    if (region == "EU") and (b == 0x91 or b == 0x98 or b == 0x99 or b == 0xb1 \
            or (b >= 0xc0 and b < 0xc9) or (b >= 0xd0 and b < 0xd9)):
        return True
    # Special characters that exist in both US/EU versions
    return (b >= 0x80 and b < 0x91) or (b >= 0xa0 and b < 0xb1)

highIndexList = []

textTableOutput = io.StringIO()
textTableOutput.write('textTableENG:\n')
for i in range(0, numHighTextIndices):
    textTableOutput.write(
        '\t.dw textTableENG_' + myhex(i, 2) + ' - textTableENG\n')

    if ignoreDictionaries123() and i >= 1 and i <= 3:
        continue

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
            if textAddress in textAddressDictionary:
                print('WARNING: Address ' + hex(textAddress) + ' referenced multiple times')
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


def getTextDecompressed(out, address, end=-1, dictLookup=False):
    if end == -1:
        end = 0x100000000
    i = address
    while i < end:
        b = rom[i]
        if b >= 2 and b < 6 and end-i >= 2:
            dictAddress = textIndexDictionary[((b-2)<<8) | rom[i+1]].address
            getTextDecompressed(out, dictAddress, dictLookup=True)
            i+=1
        elif b >= 0x6 and b < 0x10:
            out.append(b)
            out.append(rom[i+1])
            i+=1
        else:
            if b == 0:
                if not dictLookup:
                    out.append(b)
                break
            out.append(b)
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


def parseTextData(data):
    i = 0
    textData = ''
    def fixTrailingSpace():
        nonlocal textData
        # Replace any space that occurs before a newline or at the end of
        # a string with "\x20" because YAML ignores trailing space.
        j = len(textData)-1
        while j >= 0 and textData[j] == ' ':
            textData = textData[::-1].replace(' ', '02x\\', 1)[::-1]
            j-=1

    while i < len(data):
        b = data[i]
        if b == 0x27: # Single quote
            textData += "'"
        elif isNormalCharacter(b):
            textData += lookupNormalCharacter(b)
        elif isSpecialCharacter(b):
            textData += lookupSpecialCharacter(b)
        elif b == 0x1:
            fixTrailingSpace()
            textData += '\n'
        elif b == 0x6 and len(data)>i+1:
            p = data[i+1]
            if p&0x80 == 0x80:
                textData += '\\item(0x' + myhex(p&0x7f,2) + ')'
            else:
                c = lookupSymbol(p&0x7f)
                if c != None:
                    textData += c
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
        elif b == 0x19:
            textData += '\\times'
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
                textData += '\\x' + myhex(b, 2)
            if b == 0 and i != len(data)-1:
                print('WARNING: Null terminator before text end')
        i+=1

    fixTrailingSpace()

    # Replace any trailing newlines with '\n' so that it doesn't need to be
    # accomodated with weird YAML formatting to prevent it from being trimmed.
    if len(textData) > 0 and textData[-1] == '\n':
        textData = textData[:-1] + '\\n'

    return textData


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
        print('WARNING: text_' + myhex(address, 2) + ' is never referenced.')
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

        if groupYaml is None or (index >> 8) != lastGroup:
            lastGroup = index >> 8
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

    textData = parseTextData(data)

    if textStruct != None:
        textStruct.data = data
        textStruct.textData = textData
        textStruct.hasNullTerminator = data[len(data)-1] == 0
    else:
        print('Unreferenced text:')
        print('  ' + textData.replace('\n', '\n  ') + '\n')

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


# Setup yaml to use OrderedDict instead of dict, and also represent 'TextStruct'
# in a specific way.
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
        if not data.hasNullTerminator:
            dataList.append((stringNode('null_terminator'), boolNode(data.hasNullTerminator)))

        return yaml.MappingNode('tag:yaml.org,2002:map', dataList)

    yaml.add_representer(TextStruct, representTextStruct)

    # Default int representation: 2-digit hex number
    yaml.add_representer(int, lambda dumper, i: intNode('0x' + myhex(i, 2)))

setup_yaml()


def dumpYaml(l, outStream):
    s = yaml.dump({'groups': l}, allow_unicode=True)

    # Add some spacing to make it nicer.
    # Must be careful with this. It could break block text which doesn't trim
    # newlines. For this reason, any text which ends with a newline has the last
    # newline replaced with the literal "\n" sequence, which should avoid this
    # issue.
    s = s.replace("\n- group:", "\n\n- group:")
    s = s.replace("groups:\n\n", "groups:\n")
    s = s.replace("\n  - name:", "\n\n  - name:")
    s = s.replace("\n  data:\n\n", "\n  data:\n")

    outStream.write(s)


outFile = open(textDir + 'dict.yaml', 'w')
dumpYaml(dictGroupList, outFile)
outFile.close()

outFile = open(textDir + 'text.yaml', 'w')
outFile.write('# See "text/info.txt" for documentation about this file.\n\n')
dumpYaml(textGroupList, outFile)
outFile.close()

# Debug output: write a decompressed blob of all the text.

outFile = open(textDir + 'text_blob_decompressed.bin','wb')
lastAddress = -1
for address in sorted(textAddressList):
    if address < lastAddress:
        print('BAD')
    lastAddress = address
    textStruct = textAddressDictionary[address]
    if textStruct.data is None:
        print('Index ' + hex(textStruct.index) + ' uninitialized')
    else:
        outFile.write(textStruct.data)
outFile.close()
