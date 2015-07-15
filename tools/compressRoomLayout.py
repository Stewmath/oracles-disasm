import sys
import StringIO

index = sys.argv[0].find('/') 
if index == -1:
	directory = ''
else:
	directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 3:
	print 'Usage: ' + sys.argv[0] + ' roomLayout.bin output.cmp [-o]'
        print '\t-o: Compress optimally (instead of trying to match capcom\'s algorithm)'
	sys.exit()

layoutFile = open(sys.argv[1],'rb')
layoutData = bytearray(layoutFile.read())

optimal = False
if len(sys.argv) > 3 and sys.argv[3] == '-o':
        optimal = True

# For some reason, capcom didn't compress these ones.
# So unless the -o switch is provided, don't compress them.
blacklist = {}
blacklist['map/room0055.bin'] = True
blacklist['map/room0069.bin'] = True
blacklist['map/room0077.bin'] = True
blacklist['map/room0078.bin'] = True
blacklist['map/room0084.bin'] = True
blacklist['map/room00ac.bin'] = True
blacklist['map/room00bc.bin'] = True
blacklist['map/room00cc.bin'] = True
blacklist['map/room01c1.bin'] = True
blacklist['map/room0256.bin'] = True
blacklist['map/room0270.bin'] = True
blacklist['map/room0272.bin'] = True
blacklist['map/room0277.bin'] = True
blacklist['map/room0278.bin'] = True
blacklist['map/room0280.bin'] = True
blacklist['map/room0281.bin'] = True
blacklist['map/room0287.bin'] = True
blacklist['map/room03c1.bin'] = True

possibilities = []

possibilities.append(layoutData)
possibilities.append(compressData_commonByte(layoutData, 1))
possibilities.append(compressData_commonByte(layoutData, 2))

smallestLen = 0x500
smallestIndex = -1

for i in range(len(possibilities)):
        candidate = possibilities[i]
        if i == 0 or (len(candidate) <= smallestLen and (optimal or not (sys.argv[1] in blacklist))):
                smallestLen = len(candidate)
                smallestIndex = i


outFile = open(sys.argv[2], 'wb')
outFile.write(chr(smallestIndex))
outFile.write(possibilities[smallestIndex])
outFile.close()
