import sys
import StringIO

index = sys.argv[0].find('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index + 1]
execfile(directory + 'common.py')

if len(sys.argv) < 2:
    print 'Usage: ' + sys.argv[0] + ' romfile'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

class AnimationData:
    def __init__(self, address):
        self.address = address
        self.name = 'animationData' + myhex(address)
    @classmethod
    def withname(self, address, name):
        self.address = address
        self.name = name

    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.address == other.address
        else:
            return False
    def __hash__(self):
        return address.__hash__()

# Constants
animationPointersAddress = 0x11b52
numAnimationIndices = 0x16
animationBank = 0x4

animationPointerList = []

outFile = open("data/animationPointers.s",'wb')
outFile.write('animationPointersTable: ; ' + hex(animationPointersAddress) + '\n')
for i in range(numAnimationIndices):
    pointer = read16(rom, animationPointersAddress+i*2)
    animationPointerList.append(bankedAddress(animationBank, pointer))
    outFile.write('\t.dw animationPointers' + myhex(i, 2) + '\n')
outFile.write('\n')

animationDataList = []

lastAddress = -1
for i in range(numAnimationIndices):
    address = bankedAddress(animationBank, read16(rom, animationPointersAddress+i*2))
    if lastAddress != address:
        lastAddress = address
        for j in range(numAnimationIndices):
            if animationPointerList[j] == address:
                outFile.write('animationPointers' + myhex(j,2) + ': ; ' + hex(address) + '\n')
        outFile.write('\t.db ' + wlahex(rom[address],2) + '\n')
        if rom[address]&0xf >= 0xf:
            numIndices = 4
        elif rom[address]&0xf >= 0x7:
            numIndices = 3
        elif rom[address]&0xf >= 0x3:
            numIndices = 2
        elif rom[address]&0xf >= 0x1:
            numIndices = 1
        address+=1
        for j in range(numIndices):
            pointer = read16(rom, address)
            animationData = AnimationData(bankedAddress(animationBank, pointer))
            if not animationData in animationDataList:
                animationDataList.append(animationData)
            outFile.write('\t.dw ' + animationData.name + '\n')
            address+=2

outFile.close()

outFile = open('data/animationData.s','wb')

animationDataList = sorted(animationDataList, key=lambda x:x.address)

for animationData in animationDataList:
    outFile.write(animationData.name + ': ; ' + hex(animationData.address) + '\n')
    address = animationData.address
    while True:
        counter = rom[address]
        if counter == 0xff:
#             outFile.write('\tdwbe ' + wlahex(read16BE(rom, address)) + '\n\n')
#             outFile.write('\tdwbe ' + animationData.name + '-CADDR-1\n\n')
            outFile.write(animationData.name+'_end:\n')
            outFile.write('\tdwbe ' + animationData.name + '-' +
                    animationData.name+'_end-1\n\n')
#             outFile.write('\tdwbe CADDR\n\n')
            break

        address+=1
        gfxIndex = rom[address]
        address+=1

        outFile.write('\t.db ' + wlahex(counter,2) + ' ' + wlahex(gfxIndex,2) + '\n')
