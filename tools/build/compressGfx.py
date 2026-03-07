#!/usr/bin/python3
import sys
import os
import io
import binascii
import copy

sys.path.append(os.path.dirname(__file__) + '/..')
from common import *

if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + '[--mode 0-3] gfxFile outFile')
    sys.exit(1)


def mode3FindLastBasePos(compressedData):
    pos = 0
    lastCompressionString = 0
    if len(compressedData) == 0:
        return (0, 8)
    while pos < len(compressedData):
        i = 0
        lastBasePos = pos
        b = compressedData[pos]
        pos+=1
        while i < 8 and pos < len(compressedData):
            if (b & 0x80) != 0:
                if pos >= len(compressedData)-1:
                    print(binascii.hexlify(compressedData))
                word = read16(compressedData, pos)
                pos+=2
                if (word&0xf800) == 0:
                    pos+=1
            else:
                pos+=1
            b <<= 1

            i+=1
    return (lastBasePos, i)

compressionCache = {}
charPositionLists = {}

def compressMode1Or3(data, mode):
    global compressionCache
    global charPositionLists
    compressionCache = {}
    charPositionLists = {}

    for dataLen in range(1, len(data)+1):
        if dataLen >= 2:
            b = data[dataLen-2]
            if charPositionLists.get(b) is None:
                charPositionLists[b] = []
            charPositionLists[b].append(dataLen-2)
        compressMode1Or3Hlpr(data, mode, dataLen)

    return compressMode1Or3Hlpr(data, mode, len(data))[0]

def compressMode1Or3Hlpr(data, mode, dataLen=-1):
    if dataLen == -1:
        # When dataLen is not passed, do first initialization
        dataLen = len(data)

    if dataLen in compressionCache:
        return compressionCache[dataLen]

    if dataLen == 0:
        return (bytearray(), 0, 8)
    if dataLen == 1:
        retData = bytearray()
        retData.append(0)
        retData.append(data[0])
        retData = (retData, 0, 1)
        compressionCache[1] = retData
        return retData

    # Try simply appending the byte
    tmp = compressMode1Or3Hlpr(data, mode, dataLen-1)
    prevCompressedData = copy.copy(tmp[0])
    pos = tmp[1]
    i = tmp[2]

    if (i == 8):
        pos = len(prevCompressedData)
        prevCompressedData.append(0)
        i = 0
    prevCompressedData.append(data[dataLen-1])
    i+=1
    candidate = (prevCompressedData, pos, i)

    # Try finding a chain of data to repeat.
    # This is not 100% optimal since it assumes that longer chains are better. This
    # isn't always the case. See "better-gfx-compression" branch for a slower alternative.
    if mode == 3:
        maxDistance = 0x800
    else:
        maxDistance = 0x20
    success = False
    matchedPositions = copy.copy(charPositionLists.get(data[dataLen-1]))
    if matchedPositions is None:
        matchedPositions = []
    matchedLen = 1
    while len(matchedPositions) != 0:
        elementsToRemove = []
        for i in range(len(matchedPositions)):
            addr = matchedPositions[i]
            if matchedLen == 1 and (dataLen-addr) > maxDistance:
                charPositionLists[data[dataLen-1]].remove(addr)
                elementsToRemove.append(addr-1)
            elif addr == 0 or data[addr-1] != data[dataLen-matchedLen-1]:
                elementsToRemove.append(addr-1)
            matchedPositions[i]-=1

        lastAddr = matchedPositions[0]
        for addr in elementsToRemove:
            lastAddr = addr
            matchedPositions.remove(addr)
        if len(matchedPositions) == 0 or matchedLen == 0x100:
            dataPos = dataLen-matchedLen
            matchStart = lastAddr+1
            matchEnd = addr+matchedLen
            if mode == 3 and matchedLen > 2:
                success = True
            elif mode == 1 and matchedLen > 1:
                success = True
            break
        matchedLen+=1

    if success:  # Match found
        tmp = compressMode1Or3Hlpr(data, mode, dataPos)
        prevCompressedData = copy.copy(tmp[0])
        pos = tmp[1]
        i = tmp[2]
        if i == 8:
            pos = len(prevCompressedData)
            i = 0
            prevCompressedData.append(0x80)
        else:
            prevCompressedData[pos] |= 0x80>>i
        i+=1
        copyLen = dataLen - dataPos

        if mode == 3:
            assert copyLen-2 > 0
            assert copyLen <= 0x100

            write16 = dataPos - matchStart - 1
            assert write16 & 0xf800 == 0

            if copyLen <= 0x21:
                write16 |= (copyLen-2)<<11
            prevCompressedData.append(write16&0xff)
            prevCompressedData.append((write16&0xff00)>>8)
            if copyLen > 0x21:
                prevCompressedData.append(copyLen&0xff)
        else:  # mode == 1
            assert copyLen-1 > 0
            assert copyLen <= 0x100

            write8 = dataPos - matchStart - 1
            assert write8 < 0x20

            if copyLen <= 0x8:
                write8 |= (copyLen-1)<<5
            prevCompressedData.append(write8&0xff)
            if copyLen > 0x8:
                prevCompressedData.append(copyLen&0xff)

        if len(prevCompressedData) < len(candidate[0]):
            candidate = (prevCompressedData, pos, i)
        elif len(prevCompressedData) == len(candidate[0]) and i < candidate[2]:
            candidate = (prevCompressedData, pos, i)

    compressionCache[dataLen] = candidate
    return candidate


def compressMode2(data):
    retData = bytearray()

    numRows = int(len(data)//16)
    if len(data)%16 != 0:
        numRows+=1
    for row in range(0, numRows):
        numberRepeats = {}
        highestRepeatCount = 0
        for i in range(0, 16):
            if row*16+i >= len(data):
                break
            num = data[row*16+i]
            if num not in numberRepeats:
                numberRepeats[num] = 1
            else:
                numberRepeats[num] += 1
            if numberRepeats[num] >= highestRepeatCount:
                highestRepeatCount = numberRepeats[num]
                highestRepeatNumber = num

        if highestRepeatCount < 2:
            retData.append(0)
            retData.append(0)
            for i in range(0, 16):
                if row*16+i >= len(data):
                    break
                retData.append(data[row*16+i])
        else:
            startPos = len(retData)
            retData.append(0)
            retData.append(0)
            retData.append(highestRepeatNumber)
            repeatBits = 0
            for i in range(0, 16):
                if row*16+i >= len(data):
                    break
                if data[row*16+i] == highestRepeatNumber:
                    repeatBits |= 0x8000>>i
                else:
                    retData.append(data[row*16+i])
            retData[startPos] = (repeatBits&0xff00)>>8
            retData[startPos+1] = repeatBits&0x00ff
    return retData

argNumber = 1
def nextArg():
    global argNumber
    argNumber = argNumber + 1
    return sys.argv[argNumber - 1]

def compressMode(inBuf, mode):
    if mode == 0:
        return inBuf
    elif mode == 2:
        return compressMode2(inBuf)
    else:  # mode == 1 or mode == 3
        return compressMode1Or3(inBuf, mode)

# Main

forceMode = -1
if sys.argv[1] == '--mode':
    nextArg()
    forceMode = int(nextArg())
    sys.argv

inFile = open(nextArg(), 'rb')
inBuf = bytearray(inFile.read())

if forceMode != -1:
    outBuf = compressMode(inBuf, forceMode)
    mode = forceMode
else:
    # Try all modes, see which one yields best compression
    for i in range(0, 4):
        compressedData = compressMode(inBuf, i)

        if i == 0 or len(compressedData) < smallestBufferSize:
            smallestBufferSize = len(compressedData)
            outBuf = compressedData
            mode = i

length = len(inBuf)
assert(length < 0x10000)

outFile = open(nextArg(), 'wb')
outFile.write(bytes([mode, length & 0xff, (length >> 8) & 0xff]))
outFile.write(outBuf)
outFile.close()
