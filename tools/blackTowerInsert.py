#!/usr/bin/python3
#
# Inverts colors 1 and 3 in gfx_link.bin.
#
# If parameters "start" and "end" are passed, this works on any file rather than being
# hardcoded for link's file specifically.

import sys
import os
from common import *


SRC_DUNGEON = 13
SRC_LAYOUT_GROUP = 4
DEST_DUNGEON = 20
DEST_LAYOUT_GROUP = 6

freeRooms = [0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
        0x9f, 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xab,
        0xac, 0xad, 0xae, 0xaf]
freeRoomIndex = 0

def dungeonLookup(layout, index, x, y):
    return layout[index * 64 + y*8 + x]

if len(sys.argv) < 1 or len(sys.argv) > 3 and len(sys.argv) < 7:
    print("Usage: " + sys.argv[0])
    sys.exit(1)
    
f = open('rooms/seasons/dungeonLayouts.bin', 'rb')
seasonsDungeonLayout = bytearray(f.read())
f.close()
f = open('rooms/ages/dungeonLayouts.bin', 'rb')
agesDungeonLayout = bytearray(f.read())
f.close()
f = open('rooms/seasons/group5Areas.bin', 'rb')
destAreas = bytearray(f.read())
f.close()
f = open('audio/seasons/group5IDs.bin', 'rb')
audioData = bytearray(f.read())
f.close()


for y in range(8):
    for x in range(8):
        if x < 3 and y < 2:
            continue
        srcRoomIndex = dungeonLookup(agesDungeonLayout, SRC_DUNGEON, x, y)

        if srcRoomIndex == 0:
            continue

        if srcRoomIndex == 0xf3:
            destRoomIndex = 0x97
        else:
            destRoomIndex = freeRooms[freeRoomIndex]
            freeRoomIndex+=1

        srcRoomFile = 'rooms/ages/large/room0' + str(SRC_LAYOUT_GROUP) + myhex(srcRoomIndex, 2) + '.bin'
        destRoomFile = 'rooms/seasons/large/room0' + str(DEST_LAYOUT_GROUP) + myhex(destRoomIndex, 2) + '.bin'
        os.system('cp ' + srcRoomFile + ' ' + destRoomFile)

        seasonsDungeonLayout[DEST_DUNGEON * 64 + y*8 + x] = destRoomIndex
        destAreas[destRoomIndex] = 0x44
        audioData[destRoomIndex] = 0x24

        print('Mapping room ' + wlahex(srcRoomIndex) + ' to room ' + wlahex(destRoomIndex))


f = open('rooms/seasons/dungeonLayouts.bin', 'wb')
f.write(seasonsDungeonLayout)
f.close()
f = open('rooms/seasons/group5Areas.bin', 'wb')
f.write(destAreas)
f.close()
f = open('audio/seasons/group5IDs.bin', 'wb')
f.write(audioData)
f.close()
