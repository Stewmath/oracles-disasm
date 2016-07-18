
import sys
import StringIO

index = sys.argv[0].rfind('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 3:
    print 'Usage: ' + sys.argv[0] + ' romfile startaddress size'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

startAddress = int(sys.argv[2])
endAddress = startAddress+int(sys.argv[3])

address = startAddress

bytesThisRow = 0
output = StringIO.StringIO()

while address < endAddress:
    output.write(
        '.db ' + wlahex(rom[address], 2) + ' ' + wlahex(rom[address+1], 2) + '\n')

    address+=2

output.seek(0)
print(output.read())
