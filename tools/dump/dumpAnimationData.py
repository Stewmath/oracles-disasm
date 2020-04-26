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

# Constants
if romIsAges(rom):
    animationGroupAddress = 0x11b52
    numAnimationIndices = 0x16
    animationBank = 0x4
    animationDataList = []
    animationDataList.append(AnimationData(0x11e89, 'animationDataDungeon'))
    animationDataList.append(AnimationData(0x11ee1, 'animationDataWaterfall'))
    animationDataList.append(AnimationData(0x11e93, 'animationDataJabu'))
    animationDataList.append(AnimationData(0x11ead, 'animationDataSpike'))
    animationDataList.append(AnimationData(0x11ebb, 'animationDataWaterfallFast'))
    animationDataList.append(AnimationData(0x11ecd, 'animationDataOverworldWaterFlower'))
    animationDataList.append(AnimationData(0x11ed7, 'animationDataPollution'))
    animationDataList.append(AnimationData(0x11efb, 'animationDataWhirlpool'))
    animationDataList.append(AnimationData(0x11f0d, 'animationDataWhirlpool2'))
    animationDataList.append(AnimationData(0x11f17, 'animationDataWaterfall3'))
    animationDataList.append(AnimationData(0x11f29, 'animationDataWaterfalls4'))
    animationDataList.append(AnimationData(0x11f3b, 'animationDataLava'))
    animationDataList.append(AnimationData(0x11f45, 'animationDataCurrents'))
    animationDataList.append(AnimationData(0x11f4f, 'animationDataPollution2'))
    animationDataList.append(AnimationData(0x11f59, 'animationDataSeaweed'))
    animationDataList.append(AnimationData(0x11f63, 'animationDataWaterfallAndCurrent'))
    animationDataList.append(AnimationData(0x11f75, 'animationDataWaterfall5'))
    animationDataList.append(AnimationData(0x11f87, 'animationDataCurrents2'))
    animationDataList.append(AnimationData(0x11f91, 'animationDataSidescroll'))
    animationDataList.append(AnimationData(0x11f9b, 'animationDataDungeonWithLava'))
    animationDataList.append(AnimationData(0x11fa5, 'animationDataWaterfall6'))
    animationDataList.append(AnimationData(0x11faf, 'animationDataSpikeAndThingy'))
    animationDataList.append(AnimationData(0x11fbd, 'animationDataWaterThing'))
    animationDataList.append(AnimationData(0x11fc7, 'animationDataWaterThing2'))
    animationDataList.append(AnimationData(0x11fd1, 'animationDataDungeonMinimal'))
    animationDataList.append(AnimationData(0x11fdb, 'animationDataUnderwaterCurrents'))
    animationDataList.append(AnimationData(0x11fe5, 'animationDataWTF'))

    dataDir = 'data/ages/'
else:
    animationGroupAddress = 0x119b0
    numAnimationIndices = 0x1b
    animationBank = 0x4
    animationDataList = []

    dataDir = 'data/seasons/'

animationPointerList = []

outFile = open(dataDir+"animationGroups.s",'wb')
outFile.write('animationGroupTable: ; ' + hex(animationGroupAddress) + '\n')
for i in range(numAnimationIndices):
    pointer = read16(rom, animationGroupAddress+i*2)
    animationPointerList.append(bankedAddress(animationBank, pointer))
    outFile.write('\t.dw animationGroup' + myhex(i, 2) + '\n')
outFile.write('\n')

lastAddress = -1
for i in range(numAnimationIndices):
    address = bankedAddress(animationBank, read16(rom, animationGroupAddress+i*2))
    if lastAddress != address:
        if address < lastAddress:
            continue
        lastAddress = address
        for j in range(numAnimationIndices):
            if animationPointerList[j] == address:
                outFile.write('animationGroup' + myhex(j,2) + ': ; ' + hex(address) + '\n')
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
            else:
                animationData = animationDataList[animationDataList.index(animationData)]
            outFile.write('\t.dw ' + animationData.name + '\n')
            address+=2

outFile.close()

outFile = open(dataDir+'animationData.s','wb')

animationDataList = sorted(animationDataList, key=lambda x:x.address)

for animationData in animationDataList:
    outFile.write(animationData.name + ': ; ' + hex(animationData.address) + '\n')
    address = animationData.address
    while True:
        counter = rom[address]
        if counter == 0xff:
            outFile.write('\tm_AnimationLoop ' + animationData.name + '\n\n')
            break

        address+=1
        gfxIndex = rom[address]
        address+=1

        outFile.write('\t.db ' + wlahex(counter,2) + ' ' + wlahex(gfxIndex,2) + '\n')
