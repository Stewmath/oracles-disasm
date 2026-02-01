#!/usr/bin/python3
import sys
import os
import io
import binascii
import copy

sys.path.append(os.path.dirname(__file__) + '/..')
from common import *

if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + '[--bit-perfect] [--mode 0-3] gfxFile outFile')
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

# Bit-perfect LZ compression based on greedy algorithm
def compressMode1Or3BitPerfect(data, mode):
    """
    Bit-perfect LZ compression using greedy algorithm that matches the original compressor.
    This searches for the longest match at each position and always takes it.
    """
    commands = []
    pos = 0
    
    while pos < len(data):
        # Find best match at current position
        match_offset, match_len = findBestMatchGreedy(data, pos, mode)
        
        if match_len > 0:
            commands.append({
                'is_backref': True,
                'offset': match_offset,
                'length': match_len
            })
            pos += match_len
        else:
            commands.append({
                'is_backref': False,
                'literal': data[pos]
            })
            pos += 1
    
    # Encode commands into compressed data
    return encodeCommands(commands, mode)

def findBestMatchGreedy(data, pos, mode):
    """
    Find the best back-reference match at the current position.
    Returns (offset, length) where offset is 1-based distance back.
    Returns (0, 0) if no suitable match is found.
    """
    if pos == 0:
        return 0, 0
    
    # Mode 1: 5-bit offset (0-31), distance 1-32
    # Mode 3: 11-bit offset (0-2047), distance 1-2048
    max_offset = 0x800 if mode == 3 else 0x20
    
    min_len = 3 if mode == 3 else 2  # Minimum worthwhile match length
    max_len = 256
    
    best_offset = 0
    best_len = 0
    
    # Search for matches by trying each possible distance from 1 to max_offset
    for dist in range(1, min(pos + 1, max_offset + 1)):
        search_pos = pos - dist
        
        # Try to match starting from search_pos
        match_len = 0
        while pos + match_len < len(data) and match_len < max_len:
            # The decompressor copies byte-by-byte from the output buffer,
            # so it can replicate short patterns (e.g., "AAAA" from a single "A")
            # Use modulo to wrap around for matches shorter than the distance
            src_idx = search_pos + (match_len % dist)
            if data[src_idx] != data[pos + match_len]:
                break
            match_len += 1
        
        if match_len >= min_len and match_len > best_len:
            best_len = match_len
            best_offset = dist
    
    # Check if the match is worthwhile based on encoding cost
    if best_len < min_len:
        return 0, 0
    
    # Encoding cost analysis:
    # Mode 1 backref: 1 byte for length 2-8, 2 bytes for length 1 or 9-256
    # Mode 3 backref: 2 bytes for length 2-33, 3 bytes for length 1 or 34-256
    if mode == 1:
        if best_len <= 8:
            if best_len < 2:
                return 0, 0
        else:
            if best_len < 3:
                return 0, 0
    else:  # mode == 3
        if best_len <= 33:
            if best_len < 3:
                return 0, 0
        else:
            if best_len < 4:
                return 0, 0
    
    return best_offset, best_len

def encodeCommands(commands, mode):
    """
    Encode a list of LZ commands into compressed data.
    """
    result = bytearray()
    cmd_idx = 0
    
    while cmd_idx < len(commands):
        # Determine how many commands this control byte covers
        cmd_count = min(8, len(commands) - cmd_idx)
        
        # Build control byte
        control_byte = 0
        for i in range(cmd_count):
            if commands[cmd_idx + i]['is_backref']:
                control_byte |= (0x80 >> i)
        
        # If this is a partial control byte (less than 8 commands),
        # set the next bit to 1 (backref) to signal end-of-stream
        if cmd_count < 8:
            control_byte |= (0x80 >> cmd_count)
        
        result.append(control_byte)
        
        # Emit the data for each command
        for i in range(cmd_count):
            cmd = commands[cmd_idx + i]
            if cmd['is_backref']:
                offset = cmd['offset'] - 1  # Convert to 0-based
                length = cmd['length']
                
                if mode == 1:
                    # Mode 1: Short back-reference
                    if 2 <= length <= 8:
                        # Length fits in 3 bits: ((len-1) << 5) | offset
                        b = ((length - 1) << 5) | offset
                        result.append(b)
                    else:
                        # Extended format: length = 0 in high bits, next byte is length
                        b = offset  # high 3 bits = 0
                        result.append(b)
                        # Length 256 is encoded as 0 (wraps around in 8-bit value)
                        if length == 256:
                            result.append(0)
                        else:
                            result.append(length)
                else:  # mode == 3
                    # Mode 3: Long back-reference
                    low_offset = offset & 0xFF
                    high_offset_bits = (offset >> 8) & 0x07
                    
                    if 2 <= length <= 33:
                        # Length fits in 5 bits: ((len-2) << 3) | high_offset_bits
                        length_bits = length - 2
                        high_byte = (length_bits << 3) | high_offset_bits
                        result.append(low_offset)
                        result.append(high_byte)
                    else:
                        # Extended format: length = 0 in high bits, next byte is length
                        high_byte = high_offset_bits  # high 5 bits = 0
                        result.append(low_offset)
                        result.append(high_byte)
                        # Length 256 is encoded as 0 (wraps around in 8-bit value)
                        if length == 256:
                            result.append(0)
                        else:
                            result.append(length)
            else:
                # Literal byte
                result.append(cmd['literal'])
        
        cmd_idx += cmd_count
    
    return result

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
        highestRepeatNumber = 0
        firstPosition = {}  # Track first position of each byte for bit-perfect mode
        
        for i in range(0, 16):
            if row*16+i >= len(data):
                break
            num = data[row*16+i]
            if num not in numberRepeats:
                numberRepeats[num] = 1
                firstPosition[num] = i
            else:
                numberRepeats[num] += 1
            
            # Bit-perfect mode: only update if count is strictly greater,
            # or if equal count and this byte appears earlier
            if BIT_PERFECT:
                if numberRepeats[num] > highestRepeatCount:
                    highestRepeatCount = numberRepeats[num]
                    highestRepeatNumber = num
                elif numberRepeats[num] == highestRepeatCount and firstPosition[num] < firstPosition[highestRepeatNumber]:
                    highestRepeatNumber = num
            else:
                # Original behavior: use >= which favors later bytes in ties
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

def compressMode(inBuf, mode):
    if mode == 0:
        return inBuf
    elif mode == 2:
        return compressMode2(inBuf)
    else:  # mode == 1 or mode == 3
        if BIT_PERFECT:
            return compressMode1Or3BitPerfect(inBuf, mode)
        else:
            return compressMode1Or3(inBuf, mode)

# Main

forceMode = -1
BIT_PERFECT = False

# Parse command-line arguments
argNumber = 1
while argNumber < len(sys.argv) - 2:
    arg = sys.argv[argNumber]
    if arg == '--bit-perfect':
        BIT_PERFECT = True
        argNumber += 1
    elif arg == '--mode':
        argNumber += 1
        forceMode = int(sys.argv[argNumber])
        argNumber += 1
    else:
        break

# Get input and output file names
if argNumber >= len(sys.argv) - 1:
    print('Usage: ' + sys.argv[0] + ' [--bit-perfect] [--mode 0-3] gfxFile outFile')
    sys.exit(1)

inFile = open(sys.argv[argNumber], 'rb')
inBuf = bytearray(inFile.read())
outFileName = sys.argv[argNumber + 1]

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

outFile = open(outFileName, 'wb')
outFile.write(bytes([mode, length & 0xff, (length >> 8) & 0xff]))
outFile.write(outBuf)
outFile.close()
