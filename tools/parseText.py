import sys
import StringIO

index = sys.argv[0].find('/') 
if index == -1:
	directory = ''
else:
	directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 2:
	print 'Usage: ' + sys.argv[0] + ' textfile'
        print 'Outputs to build/textData.s'
	sys.exit()

textFile = open(sys.argv[1],'r')

class TextStruct:
        def __init__(self, i):
                self.index = i
                self.data = bytearray()
class DictEntry:
        def __init__(self, i, s):
                self.index = i
                self.string = s

# Maps string to DictEntry
textDictionary = {}

memo = {}
# Compress first i characters of text
def compressText(text, i):
        m = memo.get(i)
        if m is not None:
                return m
        if i == 0:
                return bytearray()
        elif i == 1:
                b = bytearray()
                b.append(text[0])
                return b
        
        possibilities = []

        res = bytearray(compressText(text,i-1))
        res.append(text[i-1])
        possibilities.append(res)

        for j in xrange(0,i-1):
                dictEntry = textDictionary.get(bytes(text[j:i]))
                if dictEntry is not None:
#                        print 'dictentry'
                        res = bytearray(compressText(text, j))
                        res.append(((dictEntry.index)>>8)+2)
                        res.append(dictEntry.index&0xff)
                        possibilities.append(res)

        res = possibilities[0]
        for i in xrange(1,len(possibilities)):
                res2 = possibilities[i]
                if len(res2) < len(res):
                        res = res2

        memo[i] = res
        return res

textList = []

textSubList = []
index = 0x0000
eof = False
lineIndex = 0
# Parse text file
while not eof:
        textStruct = TextStruct(index)
        started = False
        while True:
                line = textFile.readline()
                lineIndex+=1
                if len(line) == 0:
                        eof = True
                        break
                try:
                        x = str.find(line, '(')
                        if x == -1:
                                token = str.strip(line)
                                param = -1
                        else:
                                token = str.strip(line[0:x])
                                param = line[x+1:str.find(line, ')')]
                        if token == '\\start':
                                started = True
                        elif token == '\\end':
                                started = False
                                c = textStruct.data.pop()
                                if c != 1:
                                        print 'Expected newline at line ' + str(lineIndex)
                                        print 'This is probably a bug'
                                textStruct.data.append(0)
                        elif token == '\\endwithoutnull':
                                textStruct.data.pop()
                                started = False
                        elif started:
                                # After the 'start' directive, text is actually read.
                                i = 0
                                while i < len(line):
                                        c = line[i]
                                        if c == '\n':
                                                textStruct.data.append(chr(1))
                                        elif c == '\\':
                                                i+=1
                                                x = str.find(line,'(',i)
                                                token = line
                                                param = -1
                                                validToken = False
                                                if x != -1:
                                                        y = str.find(line,')',i)
                                                        if y != -1:
                                                                token = line[i:x]
                                                                param = line[x+1:y]
                                                if line[i] == '\\': # 2 backslashes
                                                        textStruct.data.append('\\')
                                                # Check values which don't use brackets
                                                elif line[i:i+4] == 'Link':
                                                        textStruct.data.append(0x0a)
                                                        textStruct.data.append(0x00)
                                                        i += 3
                                                elif line[i:i+7] == 'kidname':
                                                        textStruct.data.append(0x0a)
                                                        textStruct.data.append(0x01)
                                                        i += 6
                                                # Check values which use brackets (tokens)
                                                elif token == 'jump':
                                                        textStruct.data.append(0x07)
                                                        textStruct.data.append(parseVal(param))
                                                        validToken = True
                                                elif token == 'col':
                                                        textStruct.data.append(0x09)
                                                        textStruct.data.append(parseVal(param))
                                                        validToken = True
                                                elif token == 'sfx':
                                                        textStruct.data.append(0x0e)
                                                        textStruct.data.append(parseVal(param))
                                                        validToken = True
                                                elif len(token) == 4 and\
                                                        token[0:3] == 'cmd' and\
                                                        isHex(token[3]):
                                                                textStruct.data.append(int(token[3],16))
                                                                textStruct.data.append(parseVal(param))
                                                                validToken = True
                                                else:
                                                        textStruct.data.append(int(line[i:i+2],16))
                                                        i+=1
                                                if validToken and param != -1:
                                                        x = str.find(line,')',i)
                                                        if x == -1:
                                                                print 'ERROR: Missing closing bracket'
                                                                sys.exit(1)
                                                        i = x
                                        else:
                                                textStruct.data.append(line[i])
                                        i+=1
                        elif token == '\\name':
                                textStruct.name = param
                        elif token == '\\next':
                                textSubList.append(textStruct)
                                lastIndex = index
                                if param == -1:
                                        index+=1
                                else:
                                        index = parseVal(param)
                                        if index>>8 != lastIndex>>8:
                                                textList.append(textSubList)
                                                textSubList = []
                                textStruct = TextStruct(index)
                                break
                        elif token == '\\nextgroup':
                                textSubList.append(textStruct)
                                textList.append(textSubList)
                                textSubList = []
                                index = (index&0xff00)+0x100
                                textStruct = TextStruct(index)
                except:
                        print 'Error on line: \"' + line + '\"'
                        e = sys.exc_info()
                        for l in e:
                                print l
                        exit(1)

if len(textStruct.data) != 0:
        textSubList.append(textStruct)
if len(textSubList) != 0:
        textList.append(textSubList)
# Done parsing text file

# Compile dictionary
for i in xrange(4):
        subList = textList[i]
        for textStruct in subList:
                textDictionary[bytes(textStruct.data)] = DictEntry(textStruct.index, textStruct.data)

outFile = open('text/test2.bin', 'w')

#for subList in textList:
for i in xrange(4,len(textList)):
        subList = textList[i]
        for textStruct in subList:
                outFile.write(compressText(textStruct.data, len(textStruct.data)))
                memo = {}
outFile.close()
