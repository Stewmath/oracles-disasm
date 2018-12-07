# Dumps "movement scripts". A basic type of script for movement that any object can use
# (ie. ambi guards and moving platforms in sidescrolling areas).

import sys
from common import *
from io import StringIO

if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + ' romfile tableAddress')
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

address = int(sys.argv[2])
bank = address // 0x4000


# Counts the number of pointers in the table (number of valid subids)
def countPointers(address):
    count = 0
    while rom[address+1] >= 0x40 and rom[address+1] < 0x80:
        count += 1
        address += 2
    return count


# First 2 bytes are not script commands, but are "speed" and "direction" values.
def printHeader(address, output):
    dirStrings = ['DIR_UP', 'DIR_RIGHT', 'DIR_DOWN', 'DIR_LEFT']

    speed = rom[address]
    address+=1
    direction = rom[address]
    address+=1

    assert(speed%5 == 0)

    print('\t.db SPEED_' + myhex(speed//5*32), file=output)
    if direction >= 0 and direction < 4:
        print('\t.db ' + dirStrings[direction], file=output)
    else:
        print('\t.db ' + wlahex(direction, 2), file=output)
    return address


def labelName(addr):
    return '@@loop'
    #return '@loop_' + myhex(toGbPointer(addr),4)

def parseScript(address, output, labels):
    if output is None:
        output = StringIO()

    count = 0
    while True:
        if address in labels:
            print(labelName(address) + ':', file=output)

        cmd = rom[address]
        address+=1

        if cmd == 0:
            ptr = read16(rom, address)
            labels.append(bankedAddress(bank, ptr))
            address+=2
            print('\tms_loop  ' + labelName(ptr), file=output)
            return address
        elif cmd == 1:
            val = rom[address]
            address+=1
            print('\tms_up    ' + wlahex(val,2), file=output)
        elif cmd == 2:
            val = rom[address]
            address+=1
            print('\tms_right ' + wlahex(val,2), file=output)
        elif cmd == 3:
            val = rom[address]
            address+=1
            print('\tms_down  ' + wlahex(val,2), file=output)
        elif cmd == 4:
            val = rom[address]
            address+=1
            print('\tms_left  ' + wlahex(val,2), file=output)
        elif cmd == 5:
            val = rom[address]
            address+=1
            print('\tms_wait  ' + str(val), file=output)
        elif cmd == 6:
            counter1 = rom[address]
            address+=1
            state = rom[address]
            address+=1
            print('\tms_state ' + str(counter1) + ", " + wlahex(state,2), file=output)
        else:
            raise Exception('Unknown opcode ' + wlahex(cmd,2))
        count += 1

    return address



output = StringIO()

numPointers = countPointers(address)
scriptAddresses = []
labelAddresses = []
for i in range(numPointers):
    ptr = read16(rom, address)
    print(".dw @subid" + myhex(i,2), file=output)
    scriptAddresses.append(bankedAddress(bank, ptr))
    address+=2

for index in range(numPointers):
    if address != scriptAddresses[index]:
        address = scriptAddresses[index]
        print('; JUMP to ' + wlahex(address), file=output)
    print('\n@subid' + myhex(index,2) + ':', file=output)
    address = printHeader(address, output)
    labels = []
    parseScript(address, None, labels)
    address = parseScript(address, output, labels)


print('\n; END ADDRESS: ' + wlahex(address), file=output)

output.seek(0)
print(output.read())
