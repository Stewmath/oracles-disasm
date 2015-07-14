import sys
import StringIO

index = sys.argv[0].find('/') 
if index == -1:
	directory = ''
else:
	directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 3:
	print 'Usage: ' + sys.argv[0] + ' romfile outfile'
	sys.exit()

romFile = open(sys.argv[1],'rb')
rom = bytearray(romFile.read())


class HighIndexStruct:
        def __init__(self):
                self.address = -1
                self.indices = []
                self.size = -1
class TextStruct:
        def __init__(self):
                self.data = None
                self.index = -1 # "Main" index
                self.indices = [] # List of all actual indices
                self.address = -1

textTableOutput = StringIO.StringIO()
textDataOutput = StringIO.StringIO()

# Constants
textTable = 0x74000
textTableBank = 0x1d
numHighTextIndices = 0x64

# Indices under 2c
textBase1 = 0x75ed8
# Indices 2c and above
textBase2 = 0x8458e

highIndexList = []

textTableOutput.write('textTableENG:\n')
for i in xrange(0,numHighTextIndices):
        textTableOutput.write('\t.dw textTableENG_' + myhex(i,2) + ' - textTableENG\n')

	address = textTable+read16(rom,textTable+i*2)
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

highIndexList = sorted(highIndexList, key=lambda d : d.address)

# First pass through address-sorted tables: calculate table sizes
for i in xrange(len(highIndexList)):
        data = highIndexList[i]
        if i != 0:
                highIndexList[i-1].size = (data.address - highIndexList[i-1].address)/2

# Size of last one must be hard-coded
highIndexList[len(highIndexList)-1].size = 0x16

textAddressList = set()
textAddressDictionary = {}
textIndexDictionary = {}
textList = set()

lastAddress = 0
# Second pass, print stuff out and get list of text addresses
for i in xrange(len(highIndexList)):
        data = highIndexList[i]
        
        if lastAddress != data.address and i != 0:
                        textTableOutput.write('; Address mismatch\n')
        for index in data.indices:
                textTableOutput.write('textTableENG_' + myhex(index,2) + ': ; ' + wlahex(data.address,4) + '\n')
        for index in xrange(data.size):
                addr = data.address + index*2
		textAddress = read16(rom,addr)

		if data.indices[0] < 0x2c:
			textAddress += textBase1
		else:
			textAddress += textBase2
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

                textTableOutput.write('\tm_TextPointer text_' + myhex(textAddress,4))
		if data.indices[0] < 0x2c:
			textBase = textBase1
		else:
			textBase = textBase2
		textTableOutput.write(' ' + wlahex(textBase/0x4000,2) + ' ' + wlahex(textBase&0x3fff,4) + '\n')

        lastAddress = data.address + data.size*2

def getTextDecompressed(out,address,end=-1):
        if end == -1:
                end = 0x100000000
        i = address
        while i < end:
                b = rom[i]
                if b >= 2 and b < 6 and end-i >= 2:
                        dictAddress = textIndexDictionary[((b-2)<<8) | rom[i+1]].address
                        getTextDecompressed(out,dictAddress)
                        i+=1
                elif b >= 0x6 and b < 0x10:
                        data.append(b)
                        data.append(rom[i+1])
                        i+=1
                else:
                        if b == 0:
                                if end != 0x100000000: # Not parsing a dictionary
                                        data.append(b)
                                break
                        data.append(b)
                i += 1

# Now pass through the text addresses themselves, start dumping
address = 0x75ed8
while address < 0x8e7e3:
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
                print 'text_' + myhex(address,2) + ' is never referenced'
                print 'Output may be malformed'
        else:
                index = textStruct.index
                if index < 0x400:
                        textDataOutput.write('\\name(DICT' + myhex(index>>8,1) + '_'
                                        + myhex(index&0xff,2) + ')\n')
                else:
                        textDataOutput.write('\\name(TX_' + myhex(index-0x400,4) + ')\n')

        textDataOutput.write('\\start\n')

        data = bytearray()
        getTextDecompressed(data,address,pos)
        i = 0
        while i < len(data):
                b = data[i]
                if (b >= 0x20 and b < 0x80):
                        textDataOutput.write(chr(b))
                elif b == 0x1:
                        textDataOutput.write('\n')
                elif b == 0x7 and len(data)>i+1:
                        textDataOutput.write('\\jump(' + wlahex(data[i+1],2) + ')')
                        i+=1
                elif b == 0x9 and len(data)>i+1:
                        textDataOutput.write('\\col(' + wlahex(data[i+1],2) + ')')
                        i+=1
                elif b == 0xa and len(data)>i+1:
                        if data[i+1] == 0:
                                textDataOutput.write('\\Link')
                                i+=1
                        elif data[i+1] == 0x1:
                                textDataOutput.write('\\kidname')
                                i+=1
                        else:
                                textDataOutput.write('\\' + myhex(b,2))
                elif b == 0xe and len(data)>i+1:
                        textDataOutput.write('\\sfx(' + wlahex(data[i+1],2) + ')')
                        i+=1
                elif b >= 0x6 and b < 0x10:
                        textDataOutput.write('\\cmd' + myhex(b,1) + '(' +
                                        wlahex(data[i+1],2) + ')')
                        i+=1
                elif b == '\\':
                        textDataOutput.write('\\\\')
                else:
                        if not (b == 0 and i == len(data)-1):
                                textDataOutput.write('\\' + myhex(b,2))
                i+=1
        if data[len(data)-1] != 0:
                textDataOutput.write('\n\\endwithoutnull\n')
        else:
                textDataOutput.write('\n\\end\n')

        textStruct.data = data

        for i in sorted(textStruct.indices): # Handle extra indices with 'stubs'
                if i != index:
                        if index+1 == i:
                                textDataOutput.write('\\next\n\n')
                        else:
                                textDataOutput.write('\\next(' + wlahex(i,4) + ')\n')
                        index = i
        
	address = pos

        nextTextStruct = textAddressDictionary.get(address)
        if nextTextStruct is not None:
                nextIndex = nextTextStruct.index
                if (index>>8)+1 == (nextIndex>>8) and (nextIndex&0xff) == 0:
                        textDataOutput.write('\\nextgroup\n')
                elif index+1 == nextIndex:
                        textDataOutput.write('\\next\n')
                else:
                        textDataOutput.write('\\next(' + wlahex(nextIndex,4) + ')\n')
        textDataOutput.write('\n')
        #print '\rpos ' + hex(pos),

outFile = open(sys.argv[2],'w')
textDataOutput.seek(0)
outFile.write(textDataOutput.read())
outFile.close()

# Debug output

#outFile = open('text/text_blob_decompressed.bin','w')
#lastAddress = -1
#for address in sorted(textAddressList):
#        if address < lastAddress:
#            print 'BAD'
#        lastAddress = address
#        textStruct = textAddressDictionary[address]
#        if textStruct.data is None:
#                print 'Index ' + hex(textStruct.index) + ' uninitialized'
#        else:
#                outFile.write(textStruct.data)
#outFile.close()
