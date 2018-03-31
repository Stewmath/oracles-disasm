# Animation data for link, companions, maple, etc
# (objects at $d000-$d03f, $d100-$d13f)

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
    print 'Output goes to files: data/specialObjectAnimationPointers.s, data/specialObjectAnimationData.s, data/specialObjectOamData.s'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())


graphicsAddresses = [
        (0x68000, 'gfx_link'),
        (0x6a2e0, 'gfx_dungeon_sprites'),
        (0x6a4e0, 'gfx_subrosian'),
        (0x6a6e0, 'gfx_link_retro'),
        (0x6a7e0, 'gfx_octorok_leever_tektite_zora'),
        (0x6a9e0, 'gfx_moblin'),
        (0x6ab40, 'gfx_ballandchain_likelike'),
        (0x6aca0, 'gfx_link_baby'),
        (0x6c000, 'gfx_ricky'),
        (0x6d220, 'gfx_dimitri'),
        (0x6de20, 'gfx_moosh'),
        (0x6ea20, 'gfx_maple'),
        (0x6f620, 'gfx_raft'), # Ages-only
        ]

def dumpAnimations(objectType):
    outFile = open("data/" + objectType + "AnimationPointers.s",'w')

    graphicsPointerList = []
    animationPointerList = []
    oamDataPointerList = []

    oamAddressList = []

    outFile.write(objectType + 'GraphicsTable: ; ' + hex(graphicsTable) + '\n')
    for i in range(numAnimationIndices):
        pointer = read16(rom, graphicsTable+i*2)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer: ' + hex(address)
        pointerAddress = bankedAddress(animationBank, pointer)
        graphicsPointerList.append(pointerAddress)
        outFile.write('\t.dw ' + objectType + myhex(i, 2) + 'GfxPointers')
#         outFile.write(' ; ' + hex(pointerAddress))
        outFile.write('\n')
    outFile.write('\n')

    outFile.write(objectType + 'AnimationTable: ; ' + hex(animPointerTable) + '\n')
    for i in range(numAnimationIndices):
        pointer = read16(rom, animPointerTable+i*2)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer: ' + hex(pointer)
        pointerAddress = bankedAddress(animationBank, pointer)
        animationPointerList.append(pointerAddress)
        outFile.write('\t.dw ' + objectType + myhex(i,2) + 'AnimationDataPointers')
#         outFile.write(' ; ' + hex(pointerAddress))
        outFile.write('\n')
    outFile.write('\n')

    outFile.write(objectType + 'OamDataTable: ; ' + hex(oamDataTable) + '\n')
    for i in range(numAnimationIndices):
        pointer = read16(rom, oamDataTable+i*2)
        if pointer < 0x4000 or pointer >= 0x8000:
            print 'Invalid pointer: ' + hex(pointer)
        pointerAddress = bankedAddress(animationBank, pointer)
        oamDataPointerList.append(pointerAddress)
        outFile.write('\t.dw ' + objectType + myhex(i,2) + 'OamDataPointers')
#         outFile.write(' ; ' + hex(pointerAddress))
        outFile.write('\n')
    outFile.write('\n')

    # Print the data that the above tables point to
    outFile.close()
    outFile = open('data/' + objectType + 'AnimationData.s', 'w')

    animationDataList = []
    animationLoopPointList = []

    address = animationDataStart
    dataType = ''
    currentAnimationDataStart = -1

    while address < animationDataEnd:

        # Check whether a "first pass" over some animation data is ending
        if (currentAnimationDataStart != -1
                and (address in graphicsPointerList
                    or address in animationPointerList
                    or address in oamDataPointerList
                    or address in animationDataList)):
            address = currentAnimationDataStart


        if address in animationPointerList:
            dataType = 'animationPointers'
            outFile.write('\n')
            for i,addr in enumerate(animationPointerList):
                if addr == address:
                    outFile.write(objectType + myhex(i,2) + 'AnimationDataPointers:\n')

        if address in animationDataList:
            if currentAnimationDataStart == -1:
                dataType = 'animationData'
                outFile.write('\n')
                outFile.write('animationData' + myhex(address) + ':\n')
                currentAnimationDataStart = address
            else:
                currentAnimationDataStart = -1

        if address in animationLoopPointList and address not in animationDataList:
            if currentAnimationDataStart == -1:
                outFile.write('animationLoop' + myhex(address) + ':\n')

        if address in oamDataPointerList:
            dataType = 'oamDataPointers'
            outFile.write('\n')
            for i,addr in enumerate(oamDataPointerList):
                if addr == address:
                    outFile.write(objectType + myhex(i,2) + 'OamDataPointers:\n')

        if address in graphicsPointerList:
            dataType = 'graphics'
            outFile.write('\n')
            for i,addr in enumerate(graphicsPointerList):
                if addr == address:
                    outFile.write(objectType + myhex(i,2) + 'GfxPointers:\n')


        if dataType == 'graphics':
            for j in range(numAnimationIndices):
                if animationPointerList[j] == address:
                    name = objectType + myhex(j,2) + 'Animation'
                    outFile.write(name + ':\n')

            pointer = read16(rom, address+1)

            if pointer == 0:
                pointerString = '$0000'
            else:

                pointerString = 'ERRORBLFEKX'

                # Figure out which gfx file is being referenced
                if pointer & 1 == 0:
                    pointerAddress = bankedAddress(0x1a, pointer)
                else:
                    pointerAddress = bankedAddress(0x1b, pointer)

                size = pointerAddress&0x1e
                pointerAddress &= ~0x1f

                for tup in reversed(graphicsAddresses):
                    startAddress = tup[0]
                    name = tup[1]

                    if pointerAddress >= startAddress:
                        pointerString = (name
                                + ' ' + wlahex(pointerAddress-startAddress,4)
                                + ' ' + wlahex(size,2))

                        break

            outFile.write('\tm_SpecialObjectGfxPointer '
                    + wlahex(rom[address],2)
                    + ' ' + pointerString)
#             outFile.write(' ; ' + hex(address))
            outFile.write('\n')

            address+=3

        elif dataType == 'animationPointers':
            pointer = read16(rom, address)
            pointerAddress = bankedAddress(animationBank, pointer)

            animationDataList.append(pointerAddress)

            outFile.write('\t.dw animationData' + myhex(pointerAddress) + '\n')
            address+=2

        elif dataType == 'animationData':
            hasLabel = False

            counter = rom[address]
            if counter == 0xff:
                pointer = bankedAddress(animationBank, address + read16BE(rom,address)+1)

                if currentAnimationDataStart != -1:
                    animationLoopPointList.append(pointer)
                else:
                    if pointer in animationDataList:
                        loopLabel = 'animationData' + myhex(pointer)
                    else:
                        loopLabel = 'animationLoop' + myhex(pointer)
                    outFile.write('\tm_AnimationLoop ' + loopLabel + '\n')
                address+=2

                continue

            address+=1
            gfxIndex = rom[address]
            address+=1
            b3 = rom[address]
            address+=1

            if currentAnimationDataStart == -1:
                outFile.write('\t.db ' + wlahex(counter,2) + ' ' + wlahex(gfxIndex,2) + ' ' + wlahex(b3,2))
#                 outFile.write(' ; ' + wlahex(address-3))
                outFile.write('\n')

        elif dataType == 'oamDataPointers':
            pointer = read16(rom, address)
            pointerAddress = bankedAddress(oamDataBaseBank, pointer)

            oamAddressList.append(pointerAddress)

            outFile.write('\t.dw oamData' + myhex(pointerAddress))
#             outFile.write(' ; ' + wlahex(address))
            outFile.write('\n')
            address+=2

        else:
            break

    outFile.close()

    # Now dump the OAM data

    outFile = open("data/" + objectType + "OamData.s", 'w')

    oamAddressList = sorted(oamAddressList)

    address = oamAddressList[0]
    endAddress = oamAddressList[len(oamAddressList)-1]+1

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


# Constants
if romIsAges(rom):
    oamDataBaseBank = 0x13

    animationBank = 0x06
    graphicsTable = bankedAddress(animationBank, 0x4451)
    animPointerTable = bankedAddress(animationBank, 0x4479)
    oamDataTable = bankedAddress(animationBank, 0x44a1)
    animationDataStart = bankedAddress(animationBank, 0x59b1)
    animationDataEnd = 0x1acec
    numAnimationIndices = 20

elif romIsSeasons(rom):
    oamDataBaseBank = 0x12

    animationBank = 0x06
    graphicsTable = bankedAddress(animationBank, 0x4447)
    animPointerTable = bankedAddress(animationBank, 0x446f)
    oamDataTable = bankedAddress(animationBank, 0x4497)
    animationDataStart = bankedAddress(animationBank, 0x5739)
    animationDataEnd = bankedAddress(animationBank, 0x69c9)
    numAnimationIndices = 20
else:
    print 'Unrecognized rom.'
    sys.exit(1)

dumpAnimations('specialObject')

