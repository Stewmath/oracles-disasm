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


if romIsSeasons(rom):
    dataAddress = bankedAddress(0x15, 0x55129)
    treasureDataEnd = 0x55481
    dataBank = 0x15
    numObjects = 0x63
else:
    print("Unsupported rom.")
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
    
    interactionDataOut.write('\t; 0x' + myhex(i,2) + '\n')
    if b0 & 0x80 == 0:
        interactionDataOut.write('\t.db')
        for j in range(4):
            interactionDataOut.write(' ' + wlahex(rom[address+j], 2))
        interactionDataOut.write('\n')
    elif read16(rom, address+1) == 0:
        interactionDataOut.write('\t.db ' + wlahex(rom[address], 2) + '\n')
        interactionDataOut.write('\t.dw $0000\n')
        interactionDataOut.write('\t.db ' + wlahex(rom[address+3], 2) + '\n')
    else:
        interactionDataOut.write('\t.db ' + wlahex(rom[address], 2) + '\n')
        interactionDataOut.write('\t.dw treasureObjectData' + myhex(i,2) + ' ; ' + wlahex(read16(rom, address+1)) + '\n')
        interactionDataOut.write('\t.db ' + wlahex(rom[address+3], 2) + '\n')

        subidTableAddress = read16(rom, address+1)
        subidTableAddress = bankedAddress(dataBank, subidTableAddress)

        if not subidDataAddresses.has_key(subidTableAddress):
            subidDataAddresses[subidTableAddress] = []
        subidDataAddresses[subidTableAddress].append(i)

    interactionDataOut.write('\n')
    address += 4

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
                    + ' ' + wlahex(rom[address+3],2)
                    + '\n')
            address+=4
        interactionDataOut.write('\n')
        address = addr

    indices = subidDataAddresses[address]
    for i in indices:
        interactionDataOut.write('treasureObjectData' + myhex(i,2) + ':\n')

    while address < treasureDataEnd:
        b0 = rom[address]
        b1 = rom[address+1]
        b2 = rom[address+2]
        b3 = rom[address+3]
        address+=4

#         numExtraDataIndices = max(numExtraDataIndices, extraDataIndex+1)

        interactionDataOut.write('\t.db ' + wlahex(b0,2)
                + ' ' + wlahex(b1,2)
                + ' ' + wlahex(b2,2)
                + ' ' + wlahex(b3,2)
                + '\n')

        if address in subidDataAddresses:
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
