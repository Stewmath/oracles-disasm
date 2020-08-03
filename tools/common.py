#!/usr/bin/python3
# Helper functions
def read16(buf, index):
    return buf[index] | (buf[index+1]<<8)


def read16BE(buf, index):
    return (buf[index]<<8) | (buf[index+1])


# Read: bank number, then pointer
def read3BytePointer(buf, index):
    return bankedAddress(buf[index], read16(buf, index+1))


# Read: pointer, then bank number
def readReversed3BytePointer(buf, index):
    return bankedAddress(buf[index+2], read16(buf, index))


def toGbPointer(val):
    return (val&0x3fff)+0x4000


def bankedAddress(bank, pos):
    return bank*0x4000 + (pos&0x3fff)


def myhex(val, length=1):
    if val < 0:
        return "-" + myhex(-val, length)
    out = hex(val)[2:]
    while len(out) < length:
        out = '0' + out
    return out

def romIsSeasons(rom):
    return rom[0x134:0x13d].decode() == "ZELDA DIN"
def romIsAges(rom):
    return rom[0x134:0x13f].decode() == "ZELDA NAYRU"
def getRomRegion(rom):
    c = chr(rom[0x142])
    if c == 'P': return "EU"
    if c == 'E': return "US"
    if c == 'J': return "JP"
    assert False, "Invalid region for ROM"
def getGameType(rom):
    if romIsSeasons(rom):
        return "SEASONS" + getRomRegion(rom)
    elif romIsAges(rom):
        return "AGES" + getRomRegion(rom)
    assert False, "Invalid game type (rom isn't seasons or ages?)"


def wlahex(val, length=1):
    if val < 0:
        return "-" + wlahex(-val, length)
    return '$'+myhex(val, length)

def wlahexSigned(val, length):
    highBit = 1<<(length*4-1)
    if val&highBit != 0:
        return '-$'+myhex((highBit*2)-val, length)
    else:
        return '$'+myhex(val, length)

def wlabin(val, length=8):
    out = bin(val)[2:]
    while len(out) < length:
        out = '0' + out
    return '%' + out

def isHex(c):
    return (c >= '0' and c <= '9') or (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F')

# Parses wla-like formatted numbers.
# ex. $10, 16
def parseVal(s):
    s = str.strip(s)
    if s[0] == '$':
        return int(s[1:], 16)
    elif s[0:2] == '0x':
        return int(s[2:], 16)
    else:
        return int(s)


def rotateRight(val):
    return (val>>1) | ((val&1)<<7)


def getGame(rom):
    return str(rom[0x134:0x143])

def decompressData_commonByte(data, numBytes, dataSize=0x1000000000):
    i = 0
    res = bytearray()
    while i < len(data) and len(res) < dataSize:
        key = 0
        for j in range(numBytes):
            key |= (data[i]<<(j*8))
            i+=1
        if key == 0:
            for j in range(numBytes*8):
                res.append(data[i])
                i+=1
        else:
            reptByte = data[i]
            i+=1
            for j in range(numBytes*8):
                c = key&1
                key >>= 1
                if c == 1:
                    res.append(reptByte)
                else:
                    res.append(data[i])
                    i+=1
    return (i, res)


def compressData_commonByte(data, numBytes):
    res = bytearray()
    multiple = 8*numBytes
    if len(data)%multiple != 0:
        print('compressData_commonByte error: not a multiple of ' + str(multiple))
        exit(1)
    for row in range(0, len(data) // multiple):
        mostCommonByteScore = 0
        mostCommonByte = 0
        byteCounts = []
        for i in range(256):
            byteCounts.append(0)
        for i in range(row*multiple, (row+1)*multiple):
            b = data[i]
            byteCounts[b]+=1
        for i in range(256):
            if byteCounts[i] > mostCommonByteScore:
                mostCommonByteScore = byteCounts[i]
                mostCommonByte = i
        if mostCommonByteScore <= 1:
            for j in range(numBytes):
                res.append(0)
            for j in range(multiple):
                res.append(data[row*multiple+j])
        else:
            key = 0
            for j in range(multiple):
                if data[row*multiple+j] == mostCommonByte:
                    key |= (1<<j)
            for j in range(numBytes):
                res.append((key>>(j*8))&0xff)
            res.append(mostCommonByte)
            for j in range(multiple):
                if data[row*multiple+j] != mostCommonByte:
                    res.append(data[row*multiple+j])
    return res


def decompressGfxData(rom, address, size, mode, physicalSize=0x10000000):
    retData = bytearray()
    size+=1
    if mode == 0:
        size *= 0x10
        while size > 0 and physicalSize > 0:
            retData.append(rom[address])
            address+=1
            size-=1
            physicalSize-=1
    if mode == 2:
        while size > 0 and physicalSize > 0:
            c = rom[address]
            address+=1
            physicalSize-=1
            ff8a = rom[address]
            a = ff8a
            address+=1
            physicalSize-=1
            carry = 0
            if a | c == 0:
                for i in range(0x10):
                    retData.append(rom[address])
                    address+=1
                    physicalSize-=1
            else:
                a = rom[address]
                address+=1
                physicalSize-=1
                ff8b = a
                for b in range(8):
                    carrynew = (c&0x80)>>7
                    c = ((c&0x7f)<<1 | carry)&0xff
                    carry = carrynew
                    if carry == 0:
                        a = rom[address]
                        address+=1
                        physicalSize-=1
                    else:
                        a = ff8b
                    retData.append(a)
                c = ff8a
                for b in range(8):
                    carrynew = (c&0x80)>>7
                    c = ((c&0x7f)<<1 | carry)&0xff
                    carry = carrynew
                    if carry == 0:
                        a = rom[address]
                        address+=1
                        physicalSize-=1
                    else:
                        a = ff8b
                    retData.append(a)
            size-=1
    elif mode == 3:
        ff8e = 0xff
    elif mode == 1:
        ff8e = 0
        ff93 = 0
    if mode == 1 or mode == 3:
        size *= 0x10
        ff8b = 1
        while size > 0 and physicalSize > 0:
            ff8b-=1
            if ff8b == 0:
                ff8b = 8
                ff8a = rom[address]
                address+=1
                physicalSize-=1
            a = ff8a
            ff8a = (ff8a*2)&0xff
            if a < 0x80:
                retData.append(rom[address])
                address+=1
                physicalSize-=1
                size-=1
                # Else continue loop
            else:
                if ff8e == 0:
                    a = ff92 = rom[address]&0x1f
                    a ^= rom[address]
                    # Not incremented here apparently
                    if a == 0:
                        address+=1
                        physicalSize-=1
                        a = rom[address]
                    else:
                        a = ((a<<4) | (a>>4)) & 0xff
                        a = rotateRight(a)
                        a+=1
                else:
                    a = ff92 = rom[address]
                    address+=1
                    physicalSize-=1
                    a = ff93 = rom[address]&0x7
                    a ^= rom[address]
                    if a == 0:
                        address+=1
                        physicalSize-=1
                        a = rom[address]
                    else:
                        a = rotateRight(a)
                        a = rotateRight(a)
                        a = rotateRight(a)
                        a+=2
                ff8f = a
                if ff8f == 0:
                    ff8f = 0x100
                address+=1
                physicalSize-=1
                val16 = (ff92 | (ff93<<8)) ^ 0xffff
                arrayPos = (val16 + len(retData))&0xffff
                while ff8f != 0:
                    if arrayPos < len(retData):
                        retData.append(retData[arrayPos])
                    else:
                        retData.append(0)
                    arrayPos+=1
                    size-=1
                    ff8f-=1
                    ff8f &= 0xff
                # Continue loop

    return (address, retData)
