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
    def __init__(self, address, name=None):
        self.address = address
        if name is None:
            self.name = 'animationData' + myhex(address)
        else:
            self.name = name

    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.address == other.address
        else:
            return False
    def __hash__(self):
        return address.__hash__()


def dumpAnimations(outFile, objectType):
    animationDataList = []

    animationPointerList = []
    animationPointerList2 = []

    outFile.write(objectType + 'AnimationTable: ; ' + hex(animationGroupAddress) + '\n')
    for i in range(numAnimationIndices):
        pointer = read16(rom, animationGroupAddress+i*2)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer at ' + hex(address)
        pointerAddress = bankedAddress(animationBank, pointer)
        animationPointerList.append(bankedAddress(animationBank, pointer))
        outFile.write('\t.dw ' + objectType + myhex(i, 2) + 'Animation')
        outFile.write(' ; ' + hex(pointerAddress))
        outFile.write('\n')
    outFile.write('\n')

    outFile.write(objectType + 'AnimationTable2: ; ' + hex(animationTable2Start) + '\n')
    for i in range(numAnimationIndices2):
        pointer = read16(rom, animationTable2Start+i*2)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer at ' + hex(address)
        pointerAddress = bankedAddress(animationBank, pointer)
        animationPointerList2.append(bankedAddress(animationBank, pointer))
        outFile.write('\t.dw ' + objectType + myhex(i,2) + 'AnimationData2')
        outFile.write(' ; ' + hex(pointerAddress))
        outFile.write('\n')
    outFile.write('\n')

    address = animationPointersStart
    while address < animationDataStart:
        for j in range(numAnimationIndices):
            if animationPointerList[j] == address:
                name = objectType + myhex(j,2) + 'Animation'
                outFile.write(name + ':\n')

        pointer = read16(rom, address)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer at ' + hex(address)
        animationData = AnimationData(bankedAddress(animationBank, pointer))
        if not animationData in animationDataList:
            animationDataList.append(animationData)
        else:
            animationData = animationDataList[animationDataList.index(animationData)]

    #     animationDataStart = max(animationDataStart, animationData.address)
        outFile.write('\t.dw ' + animationData.name + ' ; ' + hex(address) + '\n')
        address+=2

    address = animationDataStart
    animationEndPointers = []

    while address < animationData2Start:
        counter = rom[address]
        address+=1
        if counter == 0xff:
            pointer = bankedAddress(animationBank, address + read16BE(rom,address-1))
            animationEndPointers.append(pointer)
            address+=1
            continue

        address+=1
        address+=1

    address = animationDataStart

    loopLabel = 'testaoeu'
    # Same as last loop except actually print stuff instead of finding pointers
    while address < animationData2Start:
        hasLabel = False
        for animationData in animationDataList:
            if address == animationData.address:
                outFile.write(animationData.name + ': ; ' + hex(address) + '\n')
                hasLabel = True
                dataLabel = animationData.name

        if address in animationEndPointers:
            if hasLabel:
                loopLabel = dataLabel
            else:
                loopLabel = 'animationLoop' + myhex(toGbPointer(address-1),4)
                outFile.write(loopLabel + ':\n')
        counter = rom[address]
        if counter == 0xff:
            pointer = bankedAddress(animationBank, address + read16BE(rom,address))
            outFile.write('animationLoopEnd' + myhex(address,4) + ':\n')
            outFile.write('\tdwbe ' + loopLabel + '-' 'animationLoopEnd' + myhex(address,4) + '-1\n\n')
            address+=2
            continue

        address+=1
        gfxIndex = rom[address]
        address+=1
        b3 = rom[address]
        address+=1

        outFile.write('\t.db ' + wlahex(counter,2) + ' ' + wlahex(gfxIndex,2) + ' ' + wlahex(b3,2) + '\n')

    outFile.write('\n\n')

    address = animationData2Start

    while address < animationData2End:
        for j in range(len(animationPointerList2)):
            pointer = animationPointerList2[j]
            if address == pointer:
                outFile.write(objectType +  myhex(j,2) + 'AnimationData2: ; ' + hex(address) + '\n')

        pointer = read16(rom, address)
        address+=2

        outFile.write('\t.dw ' + wlahex(pointer) + '\n')


# Constants for interactions
animationBank = 0x16
animationGroupAddress = 0x59855
animationTable2Start = 0x59a23
numAnimationIndices = (animationTable2Start - animationGroupAddress)/2
animationPointersStart = 0x59bf1
numAnimationIndices2 = (animationPointersStart - animationTable2Start)/2
animationDataStart = 0x5a083
animationData2Start = 0x5adfc
animationData2End = 0x5b668

outFile = open("data/interactionAnimations.s",'wb')
dumpAnimations(outFile, 'interaction')

# Constants for parts
animationBank = 0x16
animationGroupAddress = 0x5b668
animationTable2Start = 0x5b71e
numAnimationIndices = (animationTable2Start - animationGroupAddress)/2
animationPointersStart = 0x5b7d4
numAnimationIndices2 = (animationPointersStart - animationTable2Start)/2
animationDataStart = 0x5b8c0
animationData2Start = 0x5bc04
animationData2End = 0x5be02

outFile = open("data/partAnimations.s",'wb')
dumpAnimations(outFile, 'part')
