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

soundBaseBank = 0x39
soundPointerTable = 0xe5748
numSoundIndices = 0xdf

class SoundPointer:
    def __init__(self, index, address, bank):
        self.address = address
        self.bank = bank
        self.index = index

class ChannelPointer:
    def __init__(self, index, channel, address):
        self.address = address
        self.bank = bank
        self.index = index
        self.channel = channel

soundPointers = []
channelPointers = []

pointerOutput = StringIO.StringIO()
dataOutput = StringIO.StringIO()
chanOut = StringIO.StringIO()

pointerOutput.write('_soundPointers:\n')
for i in range(numSoundIndices):
# for i in range(0x3f,0x40):
    bank = soundBaseBank + rom[soundPointerTable + i*3]
    pointer = read16(rom, soundPointerTable + i*3 + 1)
    address = bankedAddress(soundBaseBank, pointer)
    ptr = SoundPointer(i, address, bank)
    soundPointers.append(ptr)
    pointerOutput.write('\tm_soundPointer sound' + myhex(i,2))
    pointerOutput.write('; ' + wlahex(address))
    pointerOutput.write('\n')

soundPointers = sorted(soundPointers, key=lambda x:x.address)

lastAddress = -1

for ptr in soundPointers:
    if lastAddress != -1 and lastAddress != ptr.address:
        dataOutput.write('; GAP\n')
    dataOutput.write('; @addr{' + myhex(toGbPointer(ptr.address)) + '}\n')
    dataOutput.write('sound' + myhex(ptr.index,2) + ':\n')
    address = ptr.address
    i = 0
    while True:
        b = rom[address]
        address+=1
        dataOutput.write('\t.db ' + wlahex(b,2) + '\n')
        if b == 0xff:
            break
        channelAddr = read16(rom,address)
        channelPtr = ChannelPointer(ptr.index, i, bankedAddress(ptr.bank, channelAddr))
        channelPointers.append(channelPtr)
        dataOutput.write('\t.dw ' + wlahex(channelAddr,4) + '\n')
        address+=2
        i+=1
    lastAddress = address

channelPointers = sorted(channelPointers, key=lambda x:x.address)

lastAddress = -1

for ptr in channelPointers:
    address = ptr.address
    if lastAddress != -1 and lastAddress != address:
        if lastAddress == address-1:
            chanOut.write('\t.db ' + wlahex(rom[address-1],2) + '\n')
        else:
            chanOut.write('; GAP\n')
    chanOut.write('; @addr{' + myhex(ptr.address,4) + '}\n')
    chanOut.write('sound' + myhex(ptr.index,2) + 'Channel' + str(ptr.channel) + ':\n')
    while True:
        b = rom[address]
        address+=1
        if b == 0xfe:
            addr = read16(rom, address)
            address+=2
            chanOut.write('\tgoto ' + wlahex(addr, 4) + '\n')
            break
	elif b == 0xf6:
            param = rom[address]
            address+=1
            chanOut.write('\tduty ' + wlahex(param,2) + '\n')
	elif b == 0xf9:
            param = rom[address]
            address+=1
            chanOut.write('\tvibrato ' + wlahex(param,2) + '\n')
        elif b == 0xf0 or b == 0xf6 or b == 0xf8 or b == 0xf9 or b == 0xfd:
            param = rom[address]
            address+=1
            chanOut.write('\tcmd' + myhex(b) + ' ' + wlahex(param,2) + '\n')
        elif b >= 0xf0:
            chanOut.write('\tcmd' + myhex(b) + '\n')
        elif b >= 0xe0:
            param = rom[address]
            address+=1
            chanOut.write('\tenv ' + wlahex(b&0x7) + ' ' + wlahex(param,2) + '\n')
        elif b >= 0xd0 and b < 0xe0:
            chanOut.write('\tvol ' + wlahex(b&0xf) + '\n')
	elif b == 0x60:
            param = rom[address]
            address+=1
	    chanOut.write('\twait1 ' + wlahex(param,2) + '\n')
	elif b == 0x61:
            param = rom[address]
            address+=1
	    chanOut.write('\twait2 ' + wlahex(param,2) + '\n')
        elif b >= 0xc and b <= 0x56:
            l = rom[address]
            address+=1
            chanOut.write('\tnote ' + wlahex(b-0xc, 2) + ' ' + wlahex(l,2) + '\n')
        else:
            chanOut.write('\t.db ' + wlahex(b,2) + ' ; ???\n')
    chanOut.write('; ' + wlahex(address) + '\n')
    lastAddress = address

pointerOutput.seek(0)
outFile = open('data/soundPointers.s', 'w')
outFile.write(pointerOutput.read())
outFile.close()

dataOutput.seek(0)
outFile = open('data/soundChannelPointers.s', 'w')
outFile.write(dataOutput.read())
outFile.close()

chanOut.seek(0)
outFile = open('data/soundChannelData.s', 'w')
outFile.write(chanOut.read())
outFile.close()
