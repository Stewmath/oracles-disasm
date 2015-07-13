# Helper functions
def read16(buf, index):
	return buf[index] | (buf[index+1]<<8)
def read16BE(buf, index):
	return (buf[index]<<8) | (buf[index+1])
def toGbPointer(val):
	return (val&0x3fff)+0x4000
def bankedAddress(bank, pos):
	return bank*0x4000 + (pos&0x3fff)
def myhex(val, length):
	out = hex(val)[2:]
	while len(out) < length:
		out = '0' + out
	return out
def wlahex(val, length):
	return '$'+myhex(val,length)

def isHex(c):
        return (c >= '0' and c <= '9') or (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F')

# Parses wla-like formatted numbers.
# ex. $10, 16
def parseVal(s):
        s = str.strip(s)
        if s[0] == '$':
                return int(s[1:len(s)],16)
        else:
                return int(s)

def rotateRight(val):
	return (val>>1) | ((val&1)<<7)

def decompressGfxData(rom,address,size,mode,physicalSize=0x10000000):
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
				for i in xrange(0x10):
					retData.append(rom[address])
					address+=1
					physicalSize-=1
			else:
				a = rom[address]
				address+=1
				physicalSize-=1
				ff8b = a
				for b in xrange(8):
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
				for b in xrange(8):
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
					
	return (address,retData)
