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
    def __init__(self, index, channel, address, label):
        self.address = address
        self.bank = bank
        self.index = index
        self.channel = channel&0xf
	self.channelValue = channel>>4
        self.labels = []
        self.labels.append(label)

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
        channelAddr = bankedAddress(ptr.bank, read16(rom,address))
        label = 'sound' + myhex(ptr.index,2) + 'Channel' + myhex(b)
        channelPtr = None
        for ptr2 in channelPointers:
            if ptr2.address == channelAddr:
                channelPtr = ptr2
                channelPtr.labels.append(label)
                break
        if channelPtr is None:
            channelPtr = ChannelPointer(ptr.index, b, channelAddr, label)
            channelPointers.append(channelPtr)
        dataOutput.write('\t.dw ' + wlahex(channelAddr,4) + '\n')
        address+=2
        i+=1
    lastAddress = address

channelPointers = sorted(channelPointers, key=lambda x:x.address)

lastAddress = -1

labelAddresses = []

def parseChannelData(address, channel, chanOut):
    global labelAddresses
    c039 = 0
    while True:
        if address in labelAddresses:
            chanOut.write('music' + myhex(address) + ':\n')
        b = rom[address]
        address+=1
	if b == 0xff:
	    chanOut.write('\tcmdff\n')
	    break
        elif b == 0xfe:
            addr = read16(rom, address)
            address+=2
            bankedAddr = bankedAddress(address/0x4000,addr)
            chanOut.write('\tgoto music' + myhex(bankedAddr, 4) + '\n')
            labelAddresses.append(bankedAddr)
	elif b == 0xf6:
            param = rom[address]
            address+=1
            chanOut.write('\tduty ' + wlahex(param,2) + '\n')
	elif b == 0xf9:
            param = rom[address]
            address+=1
            chanOut.write('\tvibrato ' + wlahex(param,2) + '\n')
	elif b == 0xf0:
            param = rom[address]
            address+=1
            chanOut.write('\tcmdf0 ' + wlahex(param,2) + '\n')
	    if channel != 7:
		c039 = 1
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

	elif channel >= 6:
	    # Noise channels
	    wait = rom[address]
	    address+=1
	    chanOut.write('\t.db ' + wlahex(b,2) + ' ' + wlahex(wait,2) + '\n')

	elif c039 != 0:
	    b2 = rom[address]
	    address+=1
	    wait = rom[address]
	    address+=1
	    chanOut.write('\t.db ' + wlahex(b,2) + ' ' + wlahex(b2,2) + ' ' + wlahex(wait,2) + '\n')
	elif b == 0x60:
            param = rom[address]
            address+=1
	    chanOut.write('\twait1 ' + wlahex(param,2) + '\n')
	elif b == 0x61:
            param = rom[address]
            address+=1
	    chanOut.write('\twait2 ' + wlahex(param,2) + '\n')
        elif b >= 0 and b <= 0x58: # and b >= 0xc
            l = rom[address]
            address+=1
            chanOut.write('\tnote ' + wlahex(b, 2) + ' ' + wlahex(l,2) + '\n')
        else:
            chanOut.write('\t.db ' + wlahex(b,2) + ' ; ???\n')
    return address

for ptr in channelPointers:
    tmpOut = StringIO.StringIO()
    address = ptr.address
    if lastAddress != -1 and lastAddress != address:
	chanOut.write('; GAP\n')
        if lastAddress >= address:
            continue
	while lastAddress < address:
	    lastAddress = parseChannelData(lastAddress, 0, chanOut)
    if address & 0x3fff == 0:
        chanOut.write('.bank ' + wlahex(address/0x4000,2) + ' slot 1\n')
        chanOut.write('.org 0\n')
    chanOut.write('; @addr{' + myhex(ptr.address,4) + '}\n')
    for l in ptr.labels:
        chanOut.write(l + ':\n')
    parseChannelData(address, ptr.channel, tmpOut)
    address = parseChannelData(address, ptr.channel, chanOut)
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
