import sys
import StringIO

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index + 1]
execfile(directory + 'common.py')

if len(sys.argv) < 2:
    print 'Usage: ' + sys.argv[0] + ' romfile'
    print 'Output goes to files: data/{item|interaction|enemy|part}Animations.s, data/{item|interaction|enemy|part}OamData.s'
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



def dumpAnimations(objectType):
    outFile = open('data/' + objectType + 'Animations.s', 'w')

    animationDataList = []

    animationPointerList = []
    animationPointerList2 = []

    oamAddressList = []

    outFile.write(objectType + 'AnimationTable: ; ' + hex(animationDataTable) + '\n')
    for i in range(numAnimationIndices):
        pointer = read16(rom, animationDataTable+i*2)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer at ' + hex(address)
        pointerAddress = bankedAddress(animationBank, pointer)
        animationPointerList.append(bankedAddress(animationBank, pointer))
        outFile.write('\t.dw ' + objectType + myhex(i, 2) + 'Animation')
        outFile.write(' ; ' + hex(pointerAddress))
        outFile.write('\n')
    outFile.write('\n')

    outFile.write(objectType + 'OamDataTable: ; ' + hex(oamTableStart) + '\n')
    for i in range(numAnimationIndices):
        pointer = read16(rom, oamTableStart+i*2)
        pointerAddress = bankedAddress(animationBank, pointer)
        animationPointerList2.append(bankedAddress(animationBank, pointer))
        outFile.write('\t.dw ' + objectType + myhex(i,2) + 'OamDataPointers')
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer at ' + hex(address)
            outFile.write(' ; INVALID POINTER')
        outFile.write(' ; ' + hex(pointerAddress))
        outFile.write('\n')
    outFile.write('\n')

    # Print pointers to animationData
    address = animationPointersStart
    while address < animationDataStart:
        for j in range(numAnimationIndices):
            if animationPointerList[j] == address:
                name = objectType + myhex(j,2) + 'Animation'
                outFile.write(name + ':\n')

        pointer = read16(rom, address)
        animationData = AnimationData(bankedAddress(animationBank, pointer))
        if not animationData in animationDataList:
            animationDataList.append(animationData)
        else:
            animationData = animationDataList[animationDataList.index(animationData)]

    #     animationDataStart = max(animationDataStart, animationData.address)
        outFile.write('\t.dw ' + animationData.name)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer at ' + hex(address)
            outFile.write(' ; INVALID POINTER')
        outFile.write(' ; ' + hex(address))
        outFile.write('\n')
        address+=2

    address = animationDataStart
    animationEndPointers = []

    # Find all the addresses that tell it to loop back
    while address < oamDataStart:
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
    while address < oamDataStart:
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
                loopLabel = 'animationLoop' + myhex(address,4)
                outFile.write(loopLabel + ':\n')
        counter = rom[address]
        if counter == 0xff:
            pointer = bankedAddress(animationBank, address + read16BE(rom,address))
            outFile.write('\tm_AnimationLoop ' + loopLabel + '\n\n')
            address+=2
            continue

        address+=1
        gfxIndex = rom[address]
        address+=1
        b3 = rom[address]
        address+=1

        outFile.write('\t.db ' + wlahex(counter,2) + ' ' + wlahex(gfxIndex,2) + ' ' + wlahex(b3,2) + '\n')

    outFile.write('\n\n')

    address = oamDataStart

    while address < oamDataEnd:
        printedNL = False
        for j in range(len(animationPointerList2)):
            pointer = animationPointerList2[j]
            if address == pointer:
                if not printedNL:
                    outFile.write('\n')
                    printedNL = True
                outFile.write(objectType +  myhex(j,2) + 'OamDataPointers: ; ' + hex(address) + '\n')

        pointer = read16(rom, address)
        address+=2

        oamAddress = bankedAddress(oamDataBaseBank, pointer)
        oamAddressList.append(oamAddress)
        outFile.write('\t.dw oamData' + myhex(oamAddress) + '\n')

    outFile.close()

    # Now dump the OAM data

    outFile = open("data/" + objectType + "OamData.s", 'w')

    oamAddressList = sorted(oamAddressList)

    address = oamAddressList[0]
    endAddress = oamAddressList[len(oamAddressList)-1]+1

    # There's has a blank entry at the start of the enemy oam data for some reason
    if objectType == 'enemy':
        address-=1

    while address < endAddress:
        if not address in oamAddressList:
            outFile.write('; WARNING: unreferenced data\n')
        outFile.write('oamData' + myhex(address) + ':\n')
        count = rom[address]
        outFile.write('\t.db ' + wlahex(count,2) + '\n')
        address+=1
        for i in range(count):
            outFile.write('\t.db')
            outFile.write(' ' + wlahex(rom[address],2))
            outFile.write(' ' + wlahex(rom[address+1],2))
            outFile.write(' ' + wlahex(rom[address+2],2))
            outFile.write(' ' + wlahex(rom[address+3],2))
            outFile.write('\n')
            address+=4
        outFile.write('\n')

    outFile.close()


# Constants for interactions
oamDataBaseBank = 0x14

animationBank = 0x16
animationDataTable = 0x59855
oamTableStart = 0x59a23
numAnimationIndices = (oamTableStart - animationDataTable)/2
animationPointersStart = 0x59bf1
animationDataStart = 0x5a083
oamDataStart = 0x5adfc
oamDataEnd = 0x5b668

dumpAnimations('interaction')

# Constants for parts
oamDataBaseBank = 0x14

animationBank = 0x16
animationDataTable = 0x5b668
oamTableStart = 0x5b71e
numAnimationIndices = (oamTableStart - animationDataTable)/2
animationPointersStart = 0x5b7d4
animationDataStart = 0x5b8c0
oamDataStart = 0x5bc04
oamDataEnd = 0x5be02

dumpAnimations('part')

# Constants for enemies
oamDataBaseBank = 0x13

animationBank = 0x0d
animationDataTable = 0x36d5c
oamTableStart = 0x36e5c
numAnimationIndices = (oamTableStart - animationDataTable)/2
animationPointersStart = oamTableStart + numAnimationIndices*2
animationDataStart = 0x37200
oamDataStart = 0x379ff
oamDataEnd = 0x37ea9

dumpAnimations('enemy')

# Constants for items
oamDataBaseBank = 0x13

animationBank = 0x07
animationDataTable = 0x1e663
oamTableStart = 0x1e6c3
numAnimationIndices = (oamTableStart - animationDataTable)/2
animationPointersStart = oamTableStart + numAnimationIndices*2
animationDataStart = 0x1e777
oamDataStart = 0x1e8bc
oamDataEnd = 0x1e9a2

dumpAnimations('item')
