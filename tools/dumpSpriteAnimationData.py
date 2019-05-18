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
    print 'Output goes to files: data/{game}/{item|interaction|enemy|part}Animations.s, data/{game}{item|interaction|enemy|part}OamData.s'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())


def getAnimName(address, objectType):
    return objectType + 'Animation' + myhex(address)


class AnimationData:
    def __init__(self, address, objectType):
        self.address = address
        self.name = getAnimName(address, objectType)

    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.address == other.address
        else:
            return False
    def __hash__(self):
        return address.__hash__()



def dumpAnimations(objectType):
    outFile = open(dataDir + objectType + 'Animations.s', 'w')

    animationDataList = []

    animationPointerList = []
    animationPointerList2 = []

    oamAddressList = []

    outFile.write(objectType + 'AnimationTable:\n')
    for i in range(numAnimationIndices):
        pointer = read16(rom, animationDataTable+i*2)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer at ' + hex(address)
        pointerAddress = bankedAddress(animationBank, pointer)
        animationPointerList.append(bankedAddress(animationBank, pointer))
        outFile.write('\t.dw ' + objectType + myhex(i, 2) + 'Animations')
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
        outFile.write('\n')
    outFile.write('\n')

    # Print pointers to animationData
    address = animationPointersStart
    while address < animationDataStart:
        for j in range(numAnimationIndices):
            if animationPointerList[j] == address:
                name = objectType + myhex(j,2) + 'Animations'
                outFile.write(name + ':\n')

        pointer = read16(rom, address)
        animationData = AnimationData(bankedAddress(animationBank, pointer), objectType)
        if not animationData in animationDataList:
            animationDataList.append(animationData)
        else:
            animationData = animationDataList[animationDataList.index(animationData)]

    #     animationDataStart = max(animationDataStart, animationData.address)
        outFile.write('\t.dw ' + animationData.name)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer at ' + hex(address)
            outFile.write(' ; INVALID POINTER')
        outFile.write('\n')
        address+=2

    address = animationDataStart
    animationLoopPointers = []
    animationEndPointers = []

    # Find all the addresses that tell it to loop back
    while address < oamDataStart:
        counter = rom[address]
        address+=1
        if counter == 0xff:
            pointer = bankedAddress(animationBank, address + read16BE(rom,address-1))
            animationLoopPointers.append(pointer)
            address+=1
            animationEndPointers.append(address)
            continue

        address+=1
        address+=1

    address = animationDataStart

    loopLabel = 'testaoeu'
    # Same as last loop except actually print stuff instead of finding pointers
    while address < oamDataStart:
        hasLabel = False
        unreferenced = True
        for animationData in animationDataList:
            if address == animationData.address:
                hasLabel = True
                unreferenced = False
                dataLabel = animationData.name

        if address in animationEndPointers and not hasLabel:
            # Unreferenced data
            hasLabel = True
            dataLabel = getAnimName(address, objectType)

        if hasLabel:
            outFile.write(dataLabel + ':')
            if unreferenced:
                outFile.write(' ; Unused')
            outFile.write('\n')

        if address in animationLoopPointers:
            if hasLabel:
                loopLabel = dataLabel
            else:
                # Making the assumption that all loops are local. (There's one special
                # case in seasons where this assumption fails.)
                loopLabel = '@' + dataLabel + 'Loop'
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
        outFile.write('\t.dw ' + objectType + 'OamData' + myhex(oamAddress) + '\n')

    outFile.close()

    # Now dump the OAM data

    outFile = open(dataDir + objectType + "OamData.s", 'w')

    oamAddressList = sorted(oamAddressList)

    address = oamAddressList[0]
    endAddress = oamAddressList[len(oamAddressList)-1]+1

    # There's has a blank entry at the start of the enemy oam data for some reason (ages
    # only)
    if objectType == 'enemy' and romIsAges(rom):
        address-=1

    while address < endAddress:
        outFile.write(objectType + 'OamData' + myhex(address) + ':')
        if not address in oamAddressList:
            outFile.write(' ; Unused')
        outFile.write('\n')
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


if romIsAges(rom):
    dataDir = 'data/ages/'

    # Constants for interactions
    oamDataBaseBank = 0x14
    animationBank = 0x16
    animationDataTable = 0x59855
    oamTableStart = 0x59a23
    numAnimationIndices = (oamTableStart - animationDataTable)/2
    animationPointersStart = oamTableStart + numAnimationIndices*2
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
    animationPointersStart = oamTableStart + numAnimationIndices*2
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
else:
    dataDir = 'data/seasons/'

    # Constants for interactions
    oamDataBaseBank = 0x13
    animationBank = 0x14
    animationDataTable = 0x51325
    oamTableStart = 0x514f5
    numAnimationIndices = (oamTableStart - animationDataTable)/2
    animationPointersStart = oamTableStart + numAnimationIndices*2
    animationDataStart = bankedAddress(animationBank, read16(rom, animationPointersStart))
    oamDataStart = bankedAddress(animationBank, read16(rom, oamTableStart))
    oamDataEnd = 0x52fc9

    dumpAnimations('interaction')

    # Constants for parts
    oamDataBaseBank = 0x13
    animationBank = 0x15
    animationDataTable = 0x5718f
    oamTableStart = 0x57237
    numAnimationIndices = (oamTableStart - animationDataTable)/2
    animationPointersStart = oamTableStart + numAnimationIndices*2
    animationDataStart = bankedAddress(animationBank, read16(rom, animationPointersStart))
    oamDataStart = bankedAddress(animationBank, read16(rom, oamTableStart))
    oamDataEnd = 0x5792d

    dumpAnimations('part')

    # Constants for enemies
    oamDataBaseBank = 0x12
    animationBank = 0x0c
    animationDataTable = 0x32df7
    oamTableStart = 0x32ef7
    numAnimationIndices = (oamTableStart - animationDataTable)/2
    animationPointersStart = oamTableStart + numAnimationIndices*2
    animationDataStart = 0x332a5
    oamDataStart = bankedAddress(animationBank, read16(rom, oamTableStart))
    oamDataEnd = 0x33ea0

    dumpAnimations('enemy')

    # Constants for items
    oamDataBaseBank = 0x12
    animationBank = 0x07
    animationDataTable = 0x1e401
    oamTableStart = 0x1e461
    numAnimationIndices = (oamTableStart - animationDataTable)/2
    animationPointersStart = oamTableStart + numAnimationIndices*2
    animationDataStart = bankedAddress(animationBank, read16(rom, animationPointersStart))
    oamDataStart = bankedAddress(animationBank, read16(rom, oamTableStart))
    oamDataEnd = 0x1e740

    dumpAnimations('item')
