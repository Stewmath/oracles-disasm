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
    print 'Output goes to stdout'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())


if romIsAges(rom):
    dataAddress = bankedAddress(0x3f, 0x6426)
    dataBank = 0x3f
    sizePerEntry = 3
    numObjects = 0xe7

#    extraDataAddress = bankedAddress(0x3f, 0x5fb9)
    
elif romIsSeasons(rom):
    dataAddress = bankedAddress(0x3f, 0x6424)
    dataBank = 0x3f
    sizePerEntry = 3
    numObjects = 0xe8
else:
    print("Unrecognized rom.")
    sys.exit()
    
# This will be calculated
numExtraDataIndices = 0

interactionDataOut = StringIO.StringIO()

# Dictionary of address to list of indices
subidDataAddresses = {}

address = dataAddress

interactionDataOut.write('; @addr{' + wlahex(address) + '}\n')
interactionDataOut.write('interactionData:\n')

for i in xrange(numObjects):
    b0 = rom[address]
    b1 = rom[address+1]
    b2 = rom[address+2]
    
    interactionDataOut.write('\t/* ' + wlahex(i,2) + ' */ m_InteractionData ')
    if b1 & 0x80 == 0:
        interactionDataOut.write(wlahex(b0,2) + ' ' + wlahex(b1,2) +
                ' ' + wlahex(b2,2) + '\n')
    else:
        subidTableAddress = b0 | (b2<<8)
        interactionDataOut.write('interaction' + myhex(i,2) + 'SubidData\n')
        subidTableAddress = bankedAddress(dataBank, subidTableAddress)

        if not subidDataAddresses.has_key(subidTableAddress):
            subidDataAddresses[subidTableAddress] = []
        subidDataAddresses[subidTableAddress].append(i)

    address += sizePerEntry

interactionDataOut.write('\n')

for addr in sorted(subidDataAddresses):
    if address > addr:
        continue
    elif address < addr:
        interactionDataOut.write('; Unused data?\n')
        while address < addr:
            interactionDataOut.write('\t.db ' + wlahex(rom[address],2)
                    + ' ' + wlahex(rom[address+1],2)
                    + ' ' + wlahex(rom[address+2],2)
                    + '\n')
            address+=3
        interactionDataOut.write('\n')
        address = addr

    while True:
        if address in subidDataAddresses:
            indices = subidDataAddresses[address]
            for i in indices:
                interactionDataOut.write('interaction' + myhex(i,2) + 'SubidData:\n')

        b0 = rom[address]
        b1 = rom[address+1]
        b2 = rom[address+2]
        continueBit = b1&0x80
        address+=3

#         numExtraDataIndices = max(numExtraDataIndices, extraDataIndex+1)

        interactionDataOut.write('\t.db ' + wlahex(b0,2)
                + ' ' + wlahex(b1,2)
                + ' ' + wlahex(b2,2)
                + '\n')

        # Opposite from dumpEnemyData.py, interactions stop when bit 7 of the
        # continue bit IS set.
        if continueBit == 0x80:
            break

    interactionDataOut.write('\n')

# if address != extraDataAddress:
#     interactionDataOut.write('; bleh\n')
#     address = extraDataAddress
# 
# interactionDataOut.write('\n; @addr{' + wlahex(address) + '}\n')
# interactionDataOut.write('extraInteractionData:\n')
# for i in xrange(numExtraDataIndices):
#     interactionDataOut.write('\t.db ' + wlahex(rom[address],2) + ' ' + wlahex(rom[address+1],2)
#             + ' ' + wlahex(rom[address+2],2) + ' ' + wlahex(rom[address+3],2) + '\n')
#     address+=4
# 
interactionDataOut.write('; End at ' + wlahex(address) + '\n')

interactionDataOut.seek(0)
print interactionDataOut.read()
