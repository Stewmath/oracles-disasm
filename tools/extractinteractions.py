# Extract interaction data to files

import sys
import common
import StringIO

# Get common code
index = sys.argv[0].find('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')


# Opcode types
opcodeTypeStrings = ["Interac0", "NoValue", "DoubleValue", "Pointer",
                     "BossPointer", "Conditional", "RandomEnemy",
                     "SpecificEnemy", "Part", "QuadrupleValue", "InteracA"]


class InteractionData:

    def __init__(self):
        self.group = -1

# Variables

romFile = open(sys.argv[1], 'rb')
data = bytearray(romFile.read())

pointerFile = open("interactions/pointers.s", 'w')
helperFile = open("interactions/helperData.s", 'w')
helperFile2 = open("interactions/helperData2.s", 'w')
helperFile3 = open("interactions/helperData3.s", 'w')
mainDataFile = open("interactions/mainData.s", 'w')
macroFile = open("interactions/macros.s", 'w')

interactionDataList = list()
mainInteractionDataStr = StringIO.StringIO()

groupPointerTable = 0x15*0x4000 + 0x32b

labelPositions = {}


def parseInteractionData(buf, pos, outFile):
    output = str()
    start = pos

    lastOpcode = -1
    while (data[pos] < 0xfe):
        # Some interactions are referenced midway through
        if pos != start and labelPositions.has_key(pos):
            value = labelPositions[pos]
            if value == -1:
                output += 'interactionData' + \
                    myhex((pos&0x3fff)+0x4000, 4) + ':\n'
            else:
                for intData in value:
                    output += 'group' + \
                        str(intData.group) + 'Map' + \
                        myhex(intData.map, 2) + 'InteractionData:\n'
                    intData.address = 0

        op = data[pos]
        if (op < 0xf0):
            op = lastOpcode
            fresh = 0
        else:
            op &= 0xf
            pos+=1
            fresh = 1

        output += '\t' + opcodeTypeStrings[op] + ' '

        if (op == 0x01):  # No-value
            output += wlahex(read16BE(buf, pos), 4) + '\n'
            pos+=2
        elif op == 0x02:  # Double-value
            output += wlahex(read16BE(buf, pos), 4) + ' '
            output += wlahex(buf[pos+2], 2) + ' '
            output += wlahex(buf[pos+3], 2) + '\n'
            pos+=4
        elif op == 0x03:  # Pointer
            output += 'interactionData' + myhex(read16(buf, pos), 4) + '\n'
            pointer = bank(0x12, read16(buf, pos))
            labelPositions[pointer] = -1
            pos+=2
        elif op == 0x04:  # Boss interaction
            output += 'interactionData' + myhex(read16(buf, pos), 4) + '\n'
            pointer = bank(0x12, read16(buf, pos))
            labelPositions[pointer] = -1
            pos+=2
        elif op == 0x05:  # Conditional
            output += wlahex(read16BE(buf, pos), 4) + '\n'
            pos+=2
        elif op == 0x06:  # Random spawn
            output += wlahex(buf[pos], 2) + ' '
            output += wlahex(read16BE(buf, pos+1), 4) + '\n'
            pos+=3
        elif op == 0x07:  # Specific spawn
            if fresh == 1:
                output += wlahex(buf[pos], 2) + ' '
                pos+=1
            else:
                output += '    '
            output += wlahex(read16BE(buf, pos), 4) + ' '
            output += wlahex(buf[pos+2], 2) + ' '
            output += wlahex(buf[pos+3], 2) + '\n'
            pos+=4
        elif op == 0x08:  # Part
            output += wlahex(read16BE(buf, pos), 4) + ' '
            output += wlahex(buf[pos+2], 2) + '\n'
            pos+=3
        elif op == 0x09:  # Quadruple
            output += wlahex(read16BE(buf, pos), 4) + ' '
            output += wlahex(buf[pos+2], 2) + ' '
            output += wlahex(buf[pos+3], 2) + ' '
            output += wlahex(buf[pos+4], 2) + ' '
            output += wlahex(buf[pos+5], 2) + '\n'
            pos+=6
        elif op == 0x0a:  # Unknown
            if fresh == 1:
                output += wlahex(buf[pos], 2) + ' '
                pos+=1
            else:
                output += '    '
            output += wlahex(buf[pos], 2) + ' '
            output += wlahex(buf[pos+1], 2) + '\n'
            pos+=2
        elif op == 0x0:  # Unknown
            output += wlahex(buf[pos], 2) + '\n'
            pos+=1
        else:
            print "UNKNOWN OP " + hex(op) + " at " + hex(pos)
            pos+=1

        lastOpcode = op

    # This is needed for address 45b3
    if pos != start and labelPositions.has_key(pos):
        output += 'interactionData' + myhex((pos&0x3fff)+0x4000, 4) + ':\n'

    if (data[pos] == 0xfe):
        output += '\tInteracEndPointer\n'
    else:
        output += '\tInteracEnd\n'
    pos+=1

    if outFile is not None:
        outFile.write(output + '\n')

    return pos

# Main code

macroFile.write(".DEFINE M_LASTOPCODE 17\n\n")
macroFile.write(".MACRO Interac0\n"
                "\t.IF M_LASTOPCODE != 0\n"
                "\t.db $f0\n"
                "\t.ENDIF\n"
                "\t.db \\1\n"
                "\t.REDEFINE M_LASTOPCODE 0\n"
                ".ENDM\n")
macroFile.write(".MACRO NoValue\n" +
                "\t.IF M_LASTOPCODE != 1\n"
                "\t.db $f1\n" +
                "\t.ENDIF\n"
                "\t.db \\1>>8 \\1&$ff\n" +
                "\t.REDEFINE M_LASTOPCODE 1\n"
                ".ENDM\n")
macroFile.write(".MACRO DoubleValue\n" +
                "\t.IF M_LASTOPCODE != 2\n"
                "\t.db $f2\n" +
                "\t.ENDIF\n"
                "\t.db \\1>>8 \\1&$ff\n" +
                "\t.db \\2 \\3\n"
                "\t.REDEFINE M_LASTOPCODE 2\n"
                ".ENDM\n")
macroFile.write(".MACRO Pointer\n" +
                "\t.db $f3\n" +
                "\t.dw \\1\n" +
                "\t.REDEFINE M_LASTOPCODE 3\n"
                ".ENDM\n")
macroFile.write(".MACRO BossPointer\n" +
                "\t.db $f4\n" +
                "\t.dw \\1\n" +
                "\t.REDEFINE M_LASTOPCODE 4\n"
                ".ENDM\n")
macroFile.write(".MACRO Conditional\n" +
                "\t.IF M_LASTOPCODE != 5\n"
                "\t.db $f5\n" +
                "\t.ENDIF\n"
                "\t.db \\1>>8 \\1&$ff\n" +
                "\t.REDEFINE M_LASTOPCODE 5\n"
                ".ENDM\n")
macroFile.write(".MACRO RandomEnemy\n" +
                "\t.db $f6\n" +
                "\t.db \\1\n" +
                "\t.db \\2>>8 \\2&$ff\n" +
                "\t.REDEFINE M_LASTOPCODE 6\n"
                ".ENDM\n")
macroFile.write(".MACRO SpecificEnemy\n" +
                "\t.IF NARGS == 4\n"
                "\t.db $f7\n" +
                "\t.db \\1\n"
                "\t.db \\2>>8 \\2&$ff\n" +
                "\t.db \\3 \\4\n"
                "\t.ELSE\n"
                "\t.db \\1>>8 \\1&$ff\n" +
                "\t.db \\2 \\3\n" +
                "\t.ENDIF\n"
                "\t.REDEFINE M_LASTOPCODE 7\n"
                ".ENDM\n")
macroFile.write(".MACRO Part\n" +
                "\t.IF M_LASTOPCODE != 8\n"
                "\t.db $f8\n" +
                "\t.ENDIF\n"
                "\t.db \\1>>8 \\1&$ff\n" +
                "\t.db \\2\n"
                "\t.REDEFINE M_LASTOPCODE 8\n"
                ".ENDM\n")
macroFile.write(".MACRO QuadrupleValue\n" +
                "\t.IF M_LASTOPCODE != 9\n"
                "\t.db $f9\n" +
                "\t.ENDIF\n"
                "\t.db \\1>>8 \\1&$ff\n" +
                "\t.db \\2 \\3 \\4 \\5\n" +
                "\t.REDEFINE M_LASTOPCODE 9\n"
                ".ENDM\n")
macroFile.write(".MACRO InteracA\n" +
                "\t.IF NARGS == 3\n"
                "\t.db $fa\n" +
                "\t.db \\1 \\2 \\3\n" +
                "\t.ELSE\n"
                "\t.db \\1 \\2\n"
                "\t.ENDIF\n"
                "\t.REDEFINE M_LASTOPCODE 10\n"
                ".ENDM\n")
macroFile.write(".MACRO InteracEnd\n"
                "\t.db $ff\n"
                "\t.REDEFINE M_LASTOPCODE 17\n"
                ".ENDM\n")
macroFile.write(".MACRO InteracEndPointer\n"
                "\t.db $fe\n"
                "\t.REDEFINE M_LASTOPCODE 17\n"
                ".ENDM\n")
macroFile.write("\n\n")


# Start on pointer file
pointerFile.write('groupInteractionPointerTable:\n')
for i in xrange(8):
    write = i
    if i > 5:
        write -= 2
    pointerFile.write('\t.dw group' + str(write) + 'InteractionPointerTable\n')

pointerFile.write('\n')

# Go through each group's interaction data, store into data structures for
# later
for group in xrange(6):

    pointerTable = bank(0x15, read16(data, groupPointerTable + group*2))

    pointerFile.write('group' + str(group) + 'InteractionPointerTable:\n\n')
    for map in xrange(0x100):
        pointer = bank(0x12, read16(data, pointerTable+map*2))

        interactionData = InteractionData()
        interactionData.group = group
        interactionData.map = map
        interactionData.address = pointer

        interactionDataList.append(interactionData)
        if not labelPositions.has_key(pointer):
            labelPositions[pointer] = []
        labelPositions[pointer].append(interactionData)

        pointerFile.write('\t.dw group' + str(group) + 'Map' +
                          myhex(map, 2) + 'InteractionData\n')


# Piece of data not accounted for
extraData = InteractionData()
extraData.address = 0x49f9d
extraData.group = -1
interactionDataList.append(extraData)

# Main data for groups
interactionDataList = sorted(
    interactionDataList, key=lambda interac: interac.address)

for interactionData in interactionDataList:
    address = interactionData.address
    if address != 0:
        for data2 in interactionDataList:
            if data2.address == address:
                if data2.group == -1:
                    mainInteractionDataStr.write(
                        'interactionData' + myhex((address&0x3fff)+0x4000, 4) + ':\n')
                else:
                    mainInteractionDataStr.write('group' +
                                                 str(data2.group) +
                                                 'Map' + myhex(data2.map, 2) + 'InteractionData: ; ' +
                                                 myhex((address&0x3fff)+0x4000, 4) + '\n')
                data2.address = 0
        parseInteractionData(data, address, mainInteractionDataStr)

helperOut = StringIO.StringIO()

# Search for all data blocks earlier on
pos = 0x48000

while pos < 0x49482:
    helperOut.write('interactionData' + myhex((pos&0x3fff)+0x4000, 4) + ':\n')
    pos = parseInteractionData(data, pos, helperOut)

# Weird table in the middle of everything
helperOut.write('interactionTable1:\n')
while pos < 0x49492:
    helperOut.write(
        '\t.dw interactionData' + myhex(read16(data, pos), 4) + '\n')
    pos+=2
helperOut.write('\n')

while pos < 0x495b6:
    helperOut.write('interactionData' + myhex((pos&0x3fff)+0x4000, 4) + ':\n')
    pos = parseInteractionData(data, pos, helperOut)
# Code is after this

# After main data is more interaction data, purpose unknown
pos = 0x4b6dd
# First a table of sorts
helperFile2.write('interactionTable2:\n')
while pos < 0x4b705:
    helperFile2.write(
        '.dw ' + 'interactionData' + myhex(read16(data, pos), 4) + '\n')
    pos += 2
helperFile2.write('\n')
# Now more interaction data
while pos < 0x4b8bd:
    helperFile2.write(
        'interactionData' + myhex((pos&0x3fff)+0x4000, 4) + ':\n')
    pos = parseInteractionData(data, pos, helperFile2)
# Another table
helperFile2.write('interactionTable3:\n')
while pos < 0x4b8c5:
    helperFile2.write(
        '.dw ' + 'interactionData' + myhex(read16(data, pos), 4) + '\n')
    pos += 2
helperFile2.write('\n')
# Now more interaction data
while pos < 0x4b8e4:
    helperFile2.write(
        'interactionData' + myhex((pos&0x3fff)+0x4000, 4) + ':\n')
    pos = parseInteractionData(data, pos, helperFile2)

# One last round of interaction data
helperFile3.write('; A few interactions stuffed into the very end\n\n')
pos = 0x4be69
while pos < 0x4be8f:
    helperFile3.write('interactionData' + myhex(toGbPointer(pos), 4) + ':\n')
    pos = parseInteractionData(data, pos, helperFile3)

# Write output to files (for those which don't write directly to the files)

helperOut.seek(0)
helperFile.write(helperOut.read())

mainInteractionDataStr.seek(0)
mainDataFile.write(mainInteractionDataStr.read())


romFile.close()
helperFile.close()
helperFile2.close()
helperFile3.close()
mainDataFile.close()
macroFile.close()
