import sys
import StringIO

index = sys.argv[0].find('/')
if index == -1:
    directory = ''
else:
    directory = sys.argv[0][:index+1]
execfile(directory+'common.py')

if len(sys.argv) < 2:
    print 'Usage: ' + sys.argv[0] + ' romfile [scriptAddress]'
    print 'If scriptAddress is not specified this will attempt to dump all scripts.'
    sys.exit()

romFile = open(sys.argv[1], 'rb')
rom = bytearray(romFile.read())

scriptsToParse = set()
newScriptsToParse = []
parsedScripts = {}

def scriptStr(address):
    return "script" + myhex(address)

def parseScript(address, output, recurse=False):
    global newScriptsToParse
    global parsedScripts

    if recurse and address in parsedScripts:
        return
    if not (address >= 0xc*0x4000 and address < 0xd*0x4000):
        return

    if recurse:
        newScriptsToParse.append(address)
    parsedScripts[address] = True

    output.write('script' + myhex(toGbPointer(address),4) + ':\n')

    while True:
        b = rom[address]
        address+=1
        output.write('\t')

        if b == 0:
            output.write('scriptend\n')
            if recurse:
                parseScript(address, output, recurse)
            break
        elif b < 0x80:
            newAddress = bankedAddress((address-1)/0x4000, read16BE(rom,address-1))
            output.write('jump2byte script' + myhex(toGbPointer(newAddress)) + '\n')
            address+=1
            if recurse:
                parseScript(newAddress, output, recurse)
                parseScript(address, output, recurse)
            return address
        elif b == 0x87:
            mem = read16(rom,address)
            address+=2
            output.write('jumptable_memoryaddress ' + wlahex(mem) + '\n')
            mem = read16(rom,address)
            while mem >= 0x4000 and mem < 0x8000:
                output.write('.dw script' + myhex(mem) + '\n')
                address+=2
                mem = read16(rom,address)
            if recurse:
                parseScript(address,output,recurse)
            return address
        elif b == 0x97:
            output.write('settextidjp ' + wlahex(read16BE(rom,address),4) + '\n')
            address+=2
        elif b == 0x98:
            # TODO: differentiate between showText and showTextLowIndex
            textIndex = read16BE(rom,address)
            address+=2
            output.write('showtext ' + wlahex(textIndex,4) + '\n')
        elif b == 0x9d:
            output.write('showloadedtext\n')
        elif b == 0x9e:
            output.write('checkabutton\n')
        elif b == 0xb5:
            flag = rom[address]
            address+=1
            mem = read16(rom,address)
            address+=2
            output.write('jumpifglobalflagset ' + wlahex(flag) + ' ' + scriptStr(mem) + '\n')
            if recurse:
                parseScript(mem,output,recurse)
        elif b == 0xb8:
            output.write('setlinkcantmoveto91\n')
        elif b == 0xbe:
            output.write('enableinput\n')
        elif b == 0xcd:
            output.write('stopifitemflagset\n')
        elif b == 0xeb:
            output.write('initnpchitbox\n')
        elif b == 0xec:
            output.write('movenpcup ' + wlahex(rom[address]) + '\n')
            address+=1
        elif b >= 0xf0 and b < 0xfc:
            output.write('delay ' + wlahex(rom[address]&0xf) + '\n')
            address+=1
        else:
            output.write('.db ' + wlahex(b) + '\n')
            return address
    return address

output = StringIO.StringIO()

if len(sys.argv) >= 3:
    parseScript(int(sys.argv[2]), output)
else:
    scriptsToParse.add(0x305ef)

    for address in scriptsToParse:
        if address < (0xc+1)*0x4000:
            parseScript(address,output,True)

    output = StringIO.StringIO()
    newScriptsToParse = sorted(newScriptsToParse)

    lastAddress = 0
    endAddress = 0
    for address in newScriptsToParse:
        if address == lastAddress:
            continue
        if endAddress != 0 and endAddress != address:
            output.write('; Gap from ' + wlahex(endAddress) + ' to ' + wlahex(address) + '\n')
        lastAddress = address
        if address < (0xc+1)*0x4000:
            endAddress = parseScript(address,output)

output.seek(0)
print output.read()
