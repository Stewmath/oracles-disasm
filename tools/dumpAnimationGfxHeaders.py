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

class AnimationGfx:
    def __init__(self, name, address):
        self.name = name
        self.address = address

# Constants
if romIsAges(rom):
    animationHeadersStart = 0x11be9
    numAnimationHeaders = 0x70
    animationGfxList = [
            AnimationGfx("gfx_animations_1", 0x6b200),
            AnimationGfx("gfx_animations_2", 0x6f6e0),
            AnimationGfx("gfx_animations_3", 0x64600) ]
    dataDir = 'data/ages/'
else:
    animationHeadersStart = 0x11a48
    numAnimationHeaders = 0x62
    animationGfxList = [
            AnimationGfx("gfx_animations_3", 0x62940),
            AnimationGfx("gfx_animations_2", 0x62740),
            AnimationGfx("gfx_animations_1", 0x62400) ]
    dataDir = 'data/seasons/'

outFile = open(dataDir + 'animationGfxHeaders.s', 'wb')
outFile.write('animationGfxHeaders: ; ' + hex(animationHeadersStart) + '\n')

for i in range(numAnimationHeaders):
    address = animationHeadersStart+i*6
    bank = rom[address]
    src = read16BE(rom, address+1)
    dest = read16BE(rom, address+3)
    size = rom[address+5]

#     print hex(bank)
#     print hex(src)
#     print hex(dest)
#     print hex(size)
#     print

    for gfx in animationGfxList:
        if bank == gfx.address/0x4000 and bankedAddress(bank,src) >= gfx.address:
            gfxSource = gfx
            break

    outString = 'm_GfxHeader ' + gfxSource.name + ' ' + wlahex(dest) + ' ' + wlahex(size,2) + ' '
    outString += wlahex((src&0x3fff)-(gfxSource.address&0x3fff), 3)

    outFile.write('\t' + outString + '\n')

outFile.close()

print 'Data ends at ' + hex(animationHeadersStart + numAnimationHeaders*6)
