#!/usr/bin/python3
# Extract object data to files

import sys
import os
import io

sys.path.append(os.path.dirname(__file__) + '/..')
from common import *

if len(sys.argv) < 2:
    print('Usage: ' + sys.argv[0] + ' rom.gbc')
    print('Output goes to various files in the "objects/" directory')
    sys.exit()


# Opcode types
opcodeTypeStrings = ["obj_Condition", "obj_Interaction", "obj_Interaction", "obj_Pointer",
                     "obj_BeforeEvent", "obj_AfterEvent", "obj_RandomEnemy",
                     "obj_SpecificEnemyA", "obj_Part", "obj_WithParam", "obj_ItemDrop"]


class ObjectData:

    def __init__(self):
        self.group = -1

# Variables

romFile = open(sys.argv[1], 'rb')
data = bytearray(romFile.read())
rom = data

extraInteractionBankPatch = False

if romIsAges(rom):
    gameString = 'ages'
    dataBank = 0x12
    pointerBank = 0x15

    groupPointerTable = 0x15*0x4000 + 0x32b

    mainDataStart = bankedAddress(0x12, 0x5977)
    mainDataEnd = bankedAddress(0x12, 0x76d9)

    enemyDataStart = bankedAddress(0x12, 0x406e) # Data in this range is named differently
    enemyDataEnd = bankedAddress(0x12, 0x540c)

    extraInteractionBank = 0xfa
    if rom[0x54328] == 0xc3: # ZOLE patch
        extraInteractionBankPatch = True

    garbageOffsets = []

    pointerAliases = {
            bankedAddress(0x12, 0x4000): 'faroreSparkleObjectData',
            bankedAddress(0x12, 0x4068): 'objectData_makeAllTorchesLightable',
            bankedAddress(0x12, 0x540c): 'blackTowerEscape_nayruAndRalph',
            bankedAddress(0x12, 0x5416): 'blackTowerEscape_ambiAndGuards',
            bankedAddress(0x12, 0x77c3): 'moonlitGrotto_orb',
            bankedAddress(0x12, 0x77c8): 'moonlitGrotto_onOrbActivation',
            bankedAddress(0x12, 0x77da): 'moonlitGrotto_onArmosSwitchPressed',
            bankedAddress(0x12, 0x77e6): 'impaOctoroks',
            bankedAddress(0x12, 0x77fa): 'ambisPalaceEntranceGuards',
            bankedAddress(0x12, 0x7804): 'animalsWaitingForNayru',
            bankedAddress(0x12, 0x7818): 'goronDancers',
            bankedAddress(0x12, 0x7844): 'subrosianDancers',
            bankedAddress(0x12, 0x7870): 'targetCartCrystals',
            bankedAddress(0x12, 0x7874): '@crystals',
            bankedAddress(0x12, 0x788b): 'nayruAndAnimalsInIntro',
            bankedAddress(0x12, 0x78a9): 'moblinsAttackingMakuSprout',
            bankedAddress(0x12, 0x78b3): 'ambiAndNayruInPostD3Cutscene',
            bankedAddress(0x12, 0x78c5): '@tokayFromLeft',
            bankedAddress(0x12, 0x78cb): '@tokayFromRight',
            bankedAddress(0x12, 0x78d1): '@tokayOnBothSides',
            bankedAddress(0x12, 0x78e0): 'objectData_makeTorchesLightableForD6Room',
        }
elif romIsSeasons(rom):
    gameString = 'seasons'
    dataBank = 0x11
    pointerBank = 0x11

    groupPointerTable = 0x11*0x4000 + 0x1b3b

    extraInteractionBank = 0x7f
    if rom[0x458dc] == 0xcd: # ZOLE patch
        extraInteractionBankPatch = True

    garbageOffsets = [bankedAddress(0x11, 0x4550), bankedAddress(0x11, 0x4c33)]

    mainDataStart = bankedAddress(0x11, 0x634b)
    mainDataEnd = bankedAddress(0x11, 0x7dd9)

    enemyDataStart = bankedAddress(0x11, 0x4060)
    enemyDataEnd = bankedAddress(0x11, 0x5744)

    pointerAliases = {
        }
else:
    print('Unsupported ROM.')
    sys.exit(1)


if extraInteractionBankPatch:
    print('INFO: "Extra Interaction Bank" patch from ZOLE detected. This is supported.')


pointerFile  = open("objects/" + gameString + "/pointers.s", 'w')
enemyFile    = open("objects/" + gameString + "/enemyData.s", 'w')
helperFile1  = open("objects/" + gameString + "/extraData1.s", 'w')
helperFile2  = open("objects/" + gameString + "/extraData2.s", 'w')
helperFile3  = open("objects/" + gameString + "/extraData3.s", 'w')
if not romIsSeasons(rom):
    helperFile4   = open("objects/" + gameString + "/extraData4.s", 'w')
mainDataFile = open("objects/" + gameString + "/mainData.s", 'w')

enemyFile.write('; The labels in this file MUST be named as "groupXMapYYEnemyObjectData" for LynnaLab to\n')
enemyFile.write('; treat them properly (not counting the unused labels).\n\n')


objectDataList = list()
mainObjectDataStr = io.StringIO()

mainDataPositions = {}

def getRoomString(group, room):
    return 'group' + str(group) + 'Map' + myhex(room, 2)


# Check this to decide if we can definitively say something is unused or not.
def inHardcodedRange(pos):
    if pos >= enemyDataStart and pos < enemyDataEnd:
        return False
    if pos >= mainDataStart and pos < mainDataEnd:
        return False
    return True


def parseObjectData(buf, pos, outFile):
    output = str()
    start = pos

    # Lists of rooms this data is directly referenced by; tuples of form (group, room).
    roomList = []

    lastOpcode = -1
    while True:
        if pos == start or pos in mainDataPositions: # Add labels
            if pos in mainDataPositions:
                value = mainDataPositions[pos]
            else:
                value = -1
            if value == -1:
                if pos in pointerAliases:
                    output += pointerAliases[pos] + ':'
                else:
                    output += 'objectData' + myhex((pos&0x3fff)+0x4000, 4) + ':'
                if not inHardcodedRange(pos):
                    output += ' ; UNUSED?'
                output += '\n'
            elif pos >= enemyDataStart and pos < enemyDataEnd:
                for intData in value:
                    output += intData.name + ':\n'
            else:
                for intData in value:
                    output += intData.name + ':\n'
                    intData.address = 0
                    roomList.append((intData.group, intData.map))

        if data[pos] >= 0xfe:
            break

        # Common code for ops 3, 4, 5
        def handlePointer(op, pos):
            output = ''
            pointer = bankedAddress(dataBank, read16(buf, pos))
            objectDataList = []
            if pointer in pointerAliases:
                name = pointerAliases[pointer]

                objectData = ObjectData()
                objectData.group = -1
                objectData.map = -1
                objectData.address = pointer
                objectData.name = name
                objectDataList.append(objectData)
            elif len(roomList) == 0 or not (pointer >= enemyDataStart and pointer < enemyDataEnd):
                name = 'objectData' + myhex(read16(buf, pos), 4)

                objectData = ObjectData()
                objectData.group = -1
                objectData.map = -1
                objectData.address = pointer
                objectData.name = name
                objectDataList.append(objectData)
            else:
                if pointer >= enemyDataStart and pointer < enemyDataEnd:
                    if op == 3:
                        prefixString = 'enemyObjectData'
                    elif op == 4:
                        prefixString = 'beforeEventObjectData'
                    elif op == 5:
                        prefixString = 'afterEventObjectData'
                    else:
                        assert(False)
                else:
                    prefixString = 'objectData'

                prefixString = prefixString[0].upper() + prefixString[1:]

                for (group, room) in roomList:
                    name = getRoomString(group, room) + prefixString

                    objectData = ObjectData()
                    objectData.group = group
                    objectData.map = room
                    objectData.address = pointer
                    objectData.name = name
                    objectDataList.append(objectData)

                # There's only one case (in seasons) when this happens.
                if len(roomList) > 1:
                    print('WARNING: ' + name + ' used by multiple rooms.')

            output += name + '\n' # There could be multiple names but we need to choose one.
            for objectData in objectDataList:
                if pointer not in mainDataPositions:
                    mainDataPositions[pointer] = []
                if not any(o.name == objectData.name for o in mainDataPositions[pointer]):
                    mainDataPositions[pointer].append(objectData)
            return output
        # End def handlePointer(...)

        op = data[pos]

        if pos in garbageOffsets:
            output += '\tobj_Garbage '
        else:
            if op < 0xf0 and lastOpcode != -1:
                op = lastOpcode
                fresh = 0
            else:
                op &= 0xf
                pos+=1
                fresh = 1

            if op != 9: # This type has a few different opcode names
                output += '\t' + opcodeTypeStrings[op] + ' '


        if pos in garbageOffsets:
            output += wlahex(buf[pos], 2) + ' ' + wlahex(buf[pos+1], 2) + ' ; Garbage opcode (ignored)\n'
            pos += 2
        elif op == 0x0:  # Condition
            output += wlahex(buf[pos], 2) + '\n'
            pos+=1
        elif op == 0x01:  # No-value
            output += wlahex(buf[pos+0], 2) + ' '
            output += wlahex(buf[pos+1], 2) + '\n'
            pos+=2
        elif op == 0x02:  # Double-value
            output += wlahex(buf[pos+0], 2) + ' '
            output += wlahex(buf[pos+1], 2) + ' '
            output += wlahex(buf[pos+2], 2) + ' '
            output += wlahex(buf[pos+3], 2) + '\n'
            pos+=4
        elif op == 0x03:  # Pointer
            output += handlePointer(op, pos)
            pos += 2
        elif op == 0x04:  # Pointer (Bit 7 of room flags unset)
            output += handlePointer(op, pos)
            pos += 2
        elif op == 0x05:  # Pointer (Bit 7 of room flags set)
            output += handlePointer(op, pos)
            pos += 2
        elif op == 0x06:  # Random spawn
            output += wlahex(buf[pos], 2) + ' '
            output += wlahex(buf[pos+1], 2) + ' '
            output += wlahex(buf[pos+2], 2) + '\n'
            pos+=3
        elif op == 0x07:  # Specific spawn
            if fresh == 1:
                output += wlahex(buf[pos], 2) + ' '
                pos+=1
            else:
                output += '    '
            output += wlahex(buf[pos+0], 2) + ' '
            output += wlahex(buf[pos+1], 2) + ' '
            output += wlahex(buf[pos+2], 2) + ' '
            output += wlahex(buf[pos+3], 2) + '\n'
            pos+=4
        elif op == 0x08:  # Part
            output += wlahex(buf[pos+0], 2) + ' '
            output += wlahex(buf[pos+1], 2) + ' '
            output += wlahex(buf[pos+2], 2) + '\n'
            pos+=3
        elif op == 0x09:  # Quadruple
            t = buf[pos]
            if t == 0:
                output += '\tobj_Interaction '
            elif t == 1:
                output += '\tobj_SpecificEnemyB '
            elif t == 2:
                output += '\tobj_Part '
            else:
                assert(False)
            output += wlahex(buf[pos+1], 2) + ' '
            output += wlahex(buf[pos+2], 2) + ' '
            output += wlahex(buf[pos+4], 2) + ' '
            output += wlahex(buf[pos+5], 2) + ' '
            output += wlahex(buf[pos+3], 2) + '\n'
            pos+=6
        elif op == 0x0a:  # Item Drop
            if fresh == 1:
                output += wlahex(buf[pos], 2) + ' '
                pos+=1
            else:
                output += '    '
            output += wlahex(buf[pos], 2) + ' '
            output += wlahex(buf[pos+1], 2) + '\n'
            pos+=2
        else:
            print("UNKNOWN OP " + hex(op) + " at " + hex(pos))
            pos+=1

        lastOpcode = op

    if data[pos] == 0xfe:
        output += '\tobj_EndPointer\n'
    else:
        assert(data[pos] == 0xff)
        output += '\tobj_End\n'
    pos+=1

    if outFile is not None:
        outFile.write(output + '\n')

    return pos

# Main code

# Start on pointer file
pointerFile.write('objectDataGroupTable:\n')
for i in range(8):
    write = i
    if i > 5:
        write -= 2
    elif romIsSeasons(rom) and i >= 1 and i < 4:
        write = 1
    pointerFile.write('\t.dw group' + str(write) + 'ObjectDataTable\n')

pointerFile.write('\n')

# Go through each group's object data, store into data structures for
# later
for group in range(6):
    if romIsSeasons(rom) and group >= 2 and group <= 3:
        continue # Groups 2 and 3 don't really exist

    pointerTable = bankedAddress(pointerBank, read16(data, groupPointerTable + group*2))

    pointerFile.write('group' + str(group) + 'ObjectDataTable:\n')
    for map in range(0x100):
        rawPointer = read16(data, pointerTable+map*2)
        if rawPointer & 0xc000 == 0xc000:
            if not extraInteractionBankPatch:
                print('WARNING: "extraInteractionBank" seems to be used, but the rom isn\'t patched for it?')
            pointer = bankedAddress(extraInteractionBank, rawPointer)
        else:
            pointer = bankedAddress(dataBank, rawPointer)

        objectData = ObjectData()
        objectData.group = group
        objectData.map = map
        objectData.address = pointer
        objectData.name = getRoomString(group, map) + 'ObjectData'

        objectDataList.append(objectData)
        if pointer not in mainDataPositions:
            mainDataPositions[pointer] = []
        mainDataPositions[pointer].append(objectData)

        pointerFile.write('\t.dw group' + str(group) + 'Map' +
                          myhex(map, 2) + 'ObjectData\n')

    pointerFile.write('\n')


# Piece of data not accounted for
if romIsAges(rom):
    extraData = ObjectData()
    extraData.address = 0x49f9d
    extraData.group = -1
    objectDataList.append(extraData)
elif romIsSeasons(rom):
    extraData = ObjectData()
    extraData.address = 0x46500
    extraData.group = -1
    objectDataList.append(extraData)

    extraData = ObjectData()
    extraData.address = 0x46bea
    extraData.group = -1
    objectDataList.append(extraData)

# Main data for groups
objectDataList = sorted(
    objectDataList, key=lambda obj: obj.address)

for objectData in objectDataList:
    address = objectData.address
    if address != 0:
        for data2 in objectDataList:
            if data2.address == address:
                if data2.group == -1:
                    pass
                else:
                    if extraInteractionBankPatch:
                        addrString = myhex(address//0x4000,2) + ':' + myhex((address&0x3fff)+0x4000, 4)
                    else:
                        addrString = myhex((address&0x3fff)+0x4000, 4)
                data2.address = 0
        parseObjectData(data, address, mainObjectDataStr)


# This function isn't widely used, it's only for the object tables. Doesn't handle all cases.
def getObjectDataLabel(pos):
    addr = read16(data, pos)
    fullAddr = bankedAddress(dataBank, addr)
    if fullAddr in pointerAliases:
        return pointerAliases[fullAddr]
    return 'objectData' + myhex(addr, 4)


# Search for all data blocks earlier on

if romIsAges(rom):
    pos = 0x48000

    while pos < enemyDataStart:
        pos = parseObjectData(data, pos, helperFile1)

    while pos < enemyDataEnd:
        pos = parseObjectData(data, pos, enemyFile)

    while pos < 0x49482:
        pos = parseObjectData(data, pos, helperFile2)

    helperFile2.write('objectTable1:\n')
    while pos < 0x49492:
        helperFile2.write('\t.dw ' + getObjectDataLabel(pos) + '\n')
        pos+=2
    helperFile2.write('\n')
    while pos < 0x495b6:
        pos = parseObjectData(data, pos, helperFile2)
    # Code is after this

    # After main data is more object data, purpose unknown
    pos = 0x4b6dd
    # First a table of sorts
    helperFile3.write('objectTable2:\n')
    while pos < 0x4b705:
        helperFile3.write('\t.dw ' + getObjectDataLabel(pos) + '\n')
        pos += 2
    helperFile3.write('\n')
    # Now more object data
    while pos < 0x4b8bd:
        pos = parseObjectData(data, pos, helperFile3)
    # Another table
    helperFile3.write('wildTokayObjectTable:\n')
    while pos < 0x4b8c5:
        helperFile3.write('\t.dw ' + getObjectDataLabel(pos) + '\n')
        pos += 2
    helperFile3.write('\n')
    # Now more object data
    while pos < 0x4b8e4:
        pos = parseObjectData(data, pos, helperFile3)

    # One last round of object data
    pos = 0x4be69
    while pos < 0x4be8f:
        pos = parseObjectData(data, pos, helperFile4)

else: # Seasons
    pos = 0x44000

    while pos < enemyDataStart:
        pos = parseObjectData(data, pos, helperFile1)

    while pos < enemyDataEnd:
        pos = parseObjectData(data, pos, enemyFile)

    helperFile2.write('objectTable1:\n')
    while pos < 0x4575e:
        helperFile2.write('\t.dw ' + getObjectDataLabel(pos) + '\n')
        pos+=2
    helperFile2.write('\n')
    while pos < 0x458b5:
        pos = parseObjectData(data, pos, helperFile2)

    # After main data is more object data
    pos = 0x47dd9
    # First a table of sorts
    while pos < 0x47eb0:
        pos = parseObjectData(data, pos, helperFile3)

# Write output to files (for those which don't write directly to the files)

mainObjectDataStr.seek(0)
mainDataFile.write(mainObjectDataStr.read())


romFile.close()
helperFile1.close()
helperFile2.close()
helperFile3.close()
if not romIsSeasons(rom):
    helperFile4.close()
mainDataFile.close()
enemyFile.close()
