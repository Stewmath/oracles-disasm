
import sys
import StringIO

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index + 1]
execfile(directory + 'common.py')

if len(sys.argv) < 4:
    print 'Usage: ' + sys.argv[0] + ' romfile startaddress size [-b] [bytesPerLine]'
    print 'Output goes to stout'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

startAddress = int(sys.argv[2])
endAddress = startAddress + int(sys.argv[3])

n = 4

bytesPerLine = 8;
binaryOutput = False

while n < len(sys.argv):
    if sys.argv[n] == '-b':
        binaryOutput = True
    else:
        bytesPerLine = int(sys.argv[n])
    n+=1

address = startAddress

bytesThisRow = 0
output = StringIO.StringIO()

while address < endAddress:
    if bytesThisRow == 0:
        output.write('.db ')
    if binaryOutput:
        outString = wlabin(rom[address],8)
    else:
        outString = wlahex(rom[address],2)
    if bytesThisRow == bytesPerLine-1:
        output.write(outString + '\n')
    else:
        output.write(outString + ' ')

    address += 1
    bytesThisRow += 1
    if bytesThisRow == bytesPerLine:
        bytesThisRow = 0

output.seek(0)
print(output.read())
