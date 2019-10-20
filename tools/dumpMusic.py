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

if romIsSeasons(rom):
    soundBaseBank = 0x39
    soundPointerTable = 0xe57cf
    numSoundIndices = 0xdf
    outputDir = 'audio/seasons/'
else:
    soundBaseBank = 0x39
    soundPointerTable = 0xe5748
    numSoundIndices = 0xdf
    outputDir = 'audio/ages/'

class SoundPointer:
    def __init__(self, index, address, bank, label):
        self.address = address
        self.bank = bank
        self.indices = []
        if index >= 0:
            self.indices = [index]
        self.labels = [label]

class ChannelPointer:
    def __init__(self, channel, address, labels):
        self.address = address
        self.bank = bank
        self.channel = channel
	self.channelValue = channel>>4
        self.labels = labels


noteTable = [ 'c', 'cs', 'd', 'ds', 'e', 'f', 'fs', 'g', 'gs', 'a', 'as', 'b', ]

def byteToNote(b):
    octave = b // len(noteTable) + 1
    s = noteTable[b % len(noteTable)] + str(octave)
    if len(s) < 3:
        s += ' '
    return s

soundPointers = []
channelPointers = []

pointerOutput = StringIO.StringIO()
dataOutput = StringIO.StringIO()
chanOut = StringIO.StringIO()

# Highest level of pointers (1 pointer for each sound effect)
pointerOutput.write('_soundPointers:\n')
for i in range(numSoundIndices):
    bank = soundBaseBank + rom[soundPointerTable + i*3]
    pointer = read16(rom, soundPointerTable + i*3 + 1)
    address = bankedAddress(soundBaseBank, pointer)
    label = 'sound' + myhex(i,2)
    ptr = None
    for ptr2 in soundPointers:
        if ptr2.address == address:
            ptr2.labels.append(label)
            ptr2.indices.append(i)
            ptr = ptr2
    if ptr is None:
        ptr = SoundPointer(i, address, bank, label)
        soundPointers.append(ptr)
    pointerOutput.write('\tm_soundPointer ' + label)
    pointerOutput.write(' ; ' + wlahex(address))
    pointerOutput.write('\n')

# Hardcoded address for unreferenced sound data
if romIsAges(rom):
    soundPointers.append(SoundPointer(-1, 0xe59f2, 0x3b, 'soundUnref'))
else: # Seasons
    soundPointers.append(SoundPointer(-1, 0xe5a79, 0x3b, 'soundUnref'))

soundPointers = sorted(soundPointers, key=lambda x:x.address)

lastAddress = -1

# Second level of pointers (1 pointer for each channel)
def parseChannelPointers(address, ptr, bank, dataOutput):
    i = 0
    while True:
        b = rom[address]
        address+=1
        dataOutput.write('\t.db ' + wlahex(b,2) + '\n')
        if b == 0xff:
            break

        channel = b&0xf
        priority = b>>4

        channelAddr = bankedAddress(bank, read16(rom,address))

        label = None
        if ptr is not None:
            if len(ptr.indices) > 0:
                label = 'sound' + myhex(ptr.indices[0],2) + 'Channel' + myhex(channel)
            labels = []
            for i in ptr.indices:
                labels.append('sound' + myhex(i,2) + 'Channel' + myhex(channel))
            channelPtr = None
            for ptr2 in channelPointers:
                if ptr2.address == channelAddr:
                    channelPtr = ptr2
                    channelPtr.labels += labels
                    channelPtr.indices += ptr.indices
                    break
            if channelPtr is None:
                channelPtr = ChannelPointer(channel, channelAddr, labels)
                channelPtr.indices = [] + ptr.indices
                channelPointers.append(channelPtr)

        if label is None:
            label = wlahex(toGbPointer(channelAddr),4)

        dataOutput.write('\t.dw ' + label + '\n')
        address+=2
        i+=1
    return address

for ptr in soundPointers:
    if lastAddress != -1 and lastAddress != ptr.address:
        dataOutput.write('; GAP ' + wlahex(lastAddress) + '\n')
        if lastAddress == soundPointerTable:
            dataOutput.write('\n.ifdef BUILD_VANILLA\n')
            dataOutput.write('.ORGA ' + wlahex(toGbPointer(ptr.address)) + '\n')
            dataOutput.write('.endif\n\n')
        else:
            while lastAddress < ptr.address:
                lastAddress = parseChannelPointers(lastAddress, None, soundBaseBank+5, dataOutput)

    dataOutput.write('; @addr{' + myhex(toGbPointer(ptr.address)) + '}\n')
    for l in ptr.labels:
        dataOutput.write(l + ':\n')
    address = ptr.address
    address = parseChannelPointers(address, ptr, ptr.bank, dataOutput)
    lastAddress = address

dataOutput.write('\n.ifdef BUILD_VANILLA\n')
dataOutput.write('.ORGA ' + wlahex(toGbPointer(soundPointerTable)) + '\n')
dataOutput.write('.endif\n')

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
	elif b == 0x60:
            param = rom[address]
            address+=1
	    chanOut.write('\twait1 ' + wlahex(param,2) + '\n')

	elif channel >= 6:
	    # Noise channels
	    wait = rom[address]
	    address+=1
	    chanOut.write('\tnote ' + wlahex(b,2) + ' ' + wlahex(wait,2) + '\n')

	elif c039 != 0:
	    b2 = rom[address]
	    address+=1
	    wait = rom[address]
	    address+=1
	    chanOut.write('\t.db ' + wlahex(b,2) + ' ' + wlahex(b2,2) + ' ' + wlahex(wait,2) + '\n')
	elif b == 0x61:
            param = rom[address]
            address+=1
	    chanOut.write('\twait2 ' + wlahex(param,2) + '\n')
        elif b >= 0 and b <= 0x58: # and b >= 0xc
            l = rom[address]
            address+=1
            chanOut.write('\tnote ' + byteToNote(b) + ' ' + wlahex(l,2) + '\n')
        else:
            chanOut.write('\t.db ' + wlahex(b,2) + ' ; ???\n')
    return address

startLabelsDefined = []
for i in range(numSoundIndices):
    startLabelsDefined.append(False)

for ptr in channelPointers:
    tmpOut = StringIO.StringIO()
    address = ptr.address
    if lastAddress != -1 and lastAddress != address:
        if lastAddress >= address:
            chanOut.write('; BACKWARD GAP\n')
            continue
	chanOut.write('; GAP\n')
	while lastAddress < address:
	    lastAddress = parseChannelData(lastAddress, 0, chanOut)
    if address & 0x3fff == 0:
        chanOut.write('.bank ' + wlahex(address/0x4000,2) + ' slot 1\n')
        chanOut.write('.org 0\n')

    for i in ptr.indices:
        if not startLabelsDefined[i]:
            chanOut.write('sound' + myhex(i,2) + 'Start:\n')
            startLabelsDefined[i] = True

    chanOut.write('; @addr{' + myhex(ptr.address,4) + '}\n')
    for l in ptr.labels:
        chanOut.write(l + ':\n')
    parseChannelData(address, ptr.channel, tmpOut)
    address = parseChannelData(address, ptr.channel, chanOut)
    chanOut.write('; ' + wlahex(address) + '\n')
    lastAddress = address

pointerOutput.seek(0)
outFile = open(outputDir + 'soundPointers.s', 'w')
outFile.write(pointerOutput.read())
outFile.close()

dataOutput.seek(0)
outFile = open(outputDir + 'soundChannelPointers.s', 'w')
outFile.write(dataOutput.read())
outFile.close()

chanOut.seek(0)
outFile = open(outputDir + 'soundChannelData.s', 'w')
outFile.write(chanOut.read())
outFile.close()
