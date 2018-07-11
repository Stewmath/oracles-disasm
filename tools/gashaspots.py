import sys
from common import *

if len(sys.argv) < 2:
    print('Usage: ' + sys.argv[0] + ' romfile')
    print('Output goes to stout')
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

dataStart = bankedAddress(0xb, 0x4724)

treasures = [
        "Heart piece",
        "Tier 0 (class 4) ring",
        "Tier 1 (class 3) ring",
        "Tier 2 (class 2) ring",
        "Tier 3 (class 1) ring",
        "Tier 4 (class 5) ring",
        "Potion",
        "200 rupees",
        "Fairy",
        "5 hearts",
        ]


def getRankDataStart(c):
    return dataStart + c*10*5

for i in range(10):
    print("|-")
    print('!scope=row|'+treasures[i])
    #dist = rom[dataStart : dataStart + 10]

    #assert(sum(dist) == 256)

    for r in range(5):
        rankStart = getRankDataStart(r)
        p = rom[rankStart + i] / 256
        print("|{:.2f}%".format(p*100))
