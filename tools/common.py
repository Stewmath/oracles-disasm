# Helper functions
def read16(buf, index):
	return buf[index] | (buf[index+1]<<8)
def read16BE(buf, index):
	return (buf[index]<<8) | (buf[index+1])
def toGbPointer(val):
	return (val&0x3fff)+0x4000
def bank(bank, pos):
	return bank*0x4000 + (pos&0x3fff)
def myhex(val, length):
	out = hex(val)[2:]
	while len(out) < length:
		out = '0' + out
	return out
def wlahex(val, length):
	return '$'+myhex(val,length)
