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
    dataAddress = bankedAddress(0x3f, 0x5d4b)
    dataBank = 0x3f
    sizePerEntry = 4
    numObjects = 0x80
    
    extraDataAddress = bankedAddress(0x3f, 0x5fb9)
elif romIsSeasons(rom):
    dataAddress = bankedAddress(0x3f, 0x5d71)
    dataBank = 0x3f
    sizePerEntry = 4
    numObjects = 0x80
    
    extraDataAddress = bankedAddress(0x3f, 0x5ff3)
else:
    print("Unrecognized rom.")
    sys.exit()

# This will be calculated
numExtraDataIndices = 0

enemyDataOut = StringIO.StringIO()

# Dictionary of address to list of indices
subidDataAddresses = {}

address = dataAddress

enemyDataOut.write('; @addr{' + wlahex(address) + '}\n')
enemyDataOut.write('enemyData:\n')
for i in xrange(numObjects):
    npcGfxIndex = rom[address]
    collisionProperties = rom[address+1]
    subidTableAddress = read16BE(rom, address+2)
    
    enemyDataOut.write('\tm_EnemyData ' + wlahex(npcGfxIndex,2) + ' ' + wlahex(collisionProperties,2))
    if subidTableAddress & 0x8000 == 0:
        extraDataIndex = subidTableAddress>>8
        palette = subidTableAddress&0xff
        enemyDataOut.write(' ' + wlahex(extraDataIndex,2) + ' ' + wlahex(palette,2) + '\n')

        numExtraDataIndices = max(numExtraDataIndices, extraDataIndex+1)
    else:
        subidTableAddress &= 0x7fff
        enemyDataOut.write(' enemy' + myhex(i,2) + 'SubidData\n')
        subidTableAddress = bankedAddress(dataBank, subidTableAddress)

        if not subidDataAddresses.has_key(subidTableAddress):
            subidDataAddresses[subidTableAddress] = []
        subidDataAddresses[subidTableAddress].append(i)

    address += sizePerEntry

enemyDataOut.write('\n')

for addr in sorted(subidDataAddresses):
    indices = subidDataAddresses[addr]
    if address != addr:
        enemyDataOut.write('; Unused data?\n')
        while address < addr:
            enemyDataOut.write('\t.db ' + wlahex(rom[address],2) + ' ' + wlahex(rom[address+1],2) + '\n')
            address+=2
        address = addr
    for i in indices:
        enemyDataOut.write('enemy' + myhex(i,2) + 'SubidData:\n')

    while True:
        extraDataIndex = rom[address]&0x7f
        continueBit = rom[address]&0x80
        palette = rom[address+1]
        address+=2

        numExtraDataIndices = max(numExtraDataIndices, extraDataIndex+1)

        enemyDataOut.write('\t.db ' + wlahex(extraDataIndex|continueBit,2) + ' ' + wlahex(palette,2) + '\n')
        if continueBit != 0x80:
            break

if address != extraDataAddress:
    enemyDataOut.write('; bleh\n')
    address = extraDataAddress

enemyDataOut.write('\n; @addr{' + wlahex(address) + '}\n')
enemyDataOut.write('extraEnemyData:\n')
for i in xrange(numExtraDataIndices):
    enemyDataOut.write('\t.db ' + wlahex(rom[address],2) + ' ' + wlahex(rom[address+1],2)
            + ' ' + wlahex(rom[address+2],2) + ' ' + wlahex(rom[address+3],2) + '\n')
    address+=4

enemyDataOut.write('; End at ' + wlahex(address) + '\n')

enemyDataOut.seek(0)
print enemyDataOut.read()
