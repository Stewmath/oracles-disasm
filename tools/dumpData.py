
import sys
import StringIO

index = sys.argv[0].find('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index + 1]
execfile(directory + 'common.py')

if len(sys.argv) < 4:
    print 'Usage: ' + sys.argv[0] + ' romfile startaddress size'
    print 'Output goes to stout'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

startAddress = int(sys.argv[2])
endAddress = startAddress + int(sys.argv[3])

address = startAddress

bytesThisRow = 0
output = StringIO.StringIO()

while address < endAddress:
    if bytesThisRow == 0:
        output.write('.db ')
    if bytesThisRow == 7:
        output.write(wlahex(rom[address], 2) + '\n')
    else:
        output.write(wlahex(rom[address], 2) + ' ')

    address += 1
    bytesThisRow += 1
    if bytesThisRow == 8:
        bytesThisRow = 0

output.seek(0)
print(output.read())
