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

sys.setrecursionlimit(0x1000)

def scriptStr(address):
    val = myhex(toGbPointer(address))
    if address < 0x4000 or address >= 0x8000:
        return val + " (BAD JUMP)"
    return 'script' + val

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

    while True:
        if address in parsedScripts:
            output.write('script' + myhex(toGbPointer(address),4) + ':\n')
        b = rom[address]
        address+=1
        output.write('\t')

        if b == 0:
            output.write('scriptend\n')
            if recurse:
                parseScript(address, output, recurse)
            return address
        elif b < 0x80:
            mem = read16BE(rom,address-1)
            newAddress = bankedAddress((address-1)/0x4000, mem)
            output.write('jump2byte ' + scriptStr(mem) + '\n')
            address+=1
            if recurse:
                parseScript(newAddress, output, recurse)
                parseScript(address, output, recurse)
            return address
        elif b == 0x80:
            output.write('setstate ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x81:
            output.write('setstate2 ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x83:
            bank = rom[address]
            address+=1
            mem = read16(rom,address)
            address+=2
            output.write('loadscript ' + wlahex(bank,2) + ' ' + wlahex(mem,4) + '\n')
            if recurse:
                parseScript(bankedAddress(bank,mem),output,recurse)
            return address
        elif b == 0x84:
            interaction = read16BE(rom,address)
            address+=2
            y = rom[address]
            address+=1
            x = rom[address]
            address+=1
            output.write('spawninteraction ' + wlahex(interaction,4) + ' ' + wlahex(y,2) + ' ' + wlahex(x,2) + '\n')
        elif b == 0x85:
            enemy = read16BE(rom,address)
            address+=2
            y = rom[address]
            address+=1
            x = rom[address]
            address+=1
            output.write('spawnenemy ' + wlahex(enemy,4) + ' ' + wlahex(y,2) + ' ' + wlahex(x,2) + '\n')
        elif b == 0x86:
            output.write('showpasswordscreen ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x87:
            mem = read16(rom,address)
            address+=2
            output.write('jumptable_memoryaddress ' + wlahex(mem) + '\n')
            mem = read16(rom,address)
            while mem >= 0x4000 and mem < 0x8000 and not address in scriptsToParse:
                output.write('.dw ' + scriptStr(mem) + '\n')
                if recurse:
                    parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
                address+=2
                mem = read16(rom,address)
            if recurse:
                parseScript(address,output,recurse)
            return address
        elif b == 0x88:
            y = rom[address]
            address+=1
            x = rom[address]
            address+=1
            output.write('setcoords ' + wlahex(y,2) + ' ' + wlahex(x,2) + '\n')
        elif b == 0x89:
            output.write('setmovingdirection ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x8a:
            output.write('command8a\n')
        elif b == 0x8b:
            output.write('setspeed ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x8c:
            output.write('checkcounter2iszero ' + wlahex(rom[address],2))
            address+=1
        elif b == 0x8d:
            x = rom[address]
            y = rom[address+1]
            address+=2
            output.write('setcollisionradii ' + wlahex(x,2) + ' ' + wlahex(y,2) + '\n')
        elif b == 0x8e:
            pos = rom[address]
            val = rom[address+1]
            address+=2
            output.write('writeinteractionbyte ' + wlahex(pos,2) + ' ' + wlahex(val,2) + '\n')
        elif b == 0x8f:
            anim = rom[address]
            address+=1
            output.write('loadsprite ' + wlahex(anim,2))
            if anim == 0xfe:
                output.write(' ' + wlahex(rom[address],2))
                address+=1
            output.write('\n')
        elif b == 0x90:
            output.write('cplinkx ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x91:
            mem = read16(rom,address)
            val = rom[address]
            address+=3
            output.write('writememory ' + wlahex(mem,4) + ' ' + wlahex(val,2) + '\n')
        elif b == 0x92:
            mem = read16(rom,address)
            val = rom[address]
            address+=3
            output.write('ormemory ' + wlahex(mem,4) + ' ' + wlahex(val,2) + '\n')
        elif b == 0x93:
            output.write('getrandombits ' + wlahex(rom[address],2) + ' ' + wlahex(rom[address+1],2) + '\n')
            address+=2
        elif b == 0x94:
            output.write('addinteractionbyte ' + wlahex(rom[address],2) + ' ' + wlahex(rom[address+1],2) + '\n')
            address+=2
        elif b == 0x95:
            output.write('setzspeed ' + wlahex(read16(rom,address),4) + '\n')
            address+=2
        elif b == 0x96:
            output.write('setmovingdirectionandmore ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x97:
            # TODO: differentiate between setTextIdJp and setTextIdJpLowIndex
            if False:
                textIndex = read16BE(rom,address)
                address+=2
                output.write('settextidjp ' + wlahex(textIndex,4) + '\n')
            else:
                textIndex = rom[address]
                address+=1
                output.write('settextidjplowindex ' + wlahex(textIndex,2) + '\n')
        elif b == 0x98:
            # Addresses for the opcode variant are hard-coded.
            # Ones I'm not sure about:
            # - 3 showtext opcodes around 47ba
            # - 49b5
            # - 4af6-4b03 (probably lowindex)
            # - 4b10 (probably lowindex)
            if (address > 0x3069d and address < 0x307f1) \
                    or (address > 0x30b11 and address < 0x30b31) \
                    or (address > 0x30c8e):
                textIndex = read16BE(rom,address)
                address+=2
                output.write('showtext ' + wlahex(textIndex,4) + '\n')
            else:
                textIndex = rom[address]
                address+=1
                output.write('showtextlowindex ' + wlahex(textIndex,2) + '\n')
        elif b == 0x99:
            output.write('checktext\n')
        elif b == 0x9a:
            # Addresses for the opcode variant are hard-coded.
            if False:
                textIndex = read16BE(rom,address)
                address+=2
                output.write('showtextnonexitable ' + wlahex(textIndex,4) + '\n')
            else:
                textIndex = rom[address]
                address+=1
                output.write('showtextnonexitablelowindex ' + wlahex(textIndex,2) + '\n')
        elif b == 0x9b:
            output.write('checksomething\n')
        elif b == 0x9c:
            output.write('settextid ' + wlahex(read16(rom,address),4) + '\n')
            address+=2
        elif b == 0x9d:
            output.write('showloadedtext\n')
        elif b == 0x9e:
            output.write('checkabutton\n')
        elif b == 0x9f:
            h = rom[address]
            address+=1
            a = rom[address]
            address+=1
            b = rom[address]
            address+=1
            output.write('showtextdifferentforlinked ' + wlahex(h,2) + ' ' + wlahex(a,2) + ' ' + wlahex(b,2) + '\n')
        elif b >= 0xa0 and b < 0xa8:
            output.write('checkcfc0bit ' + str(b&7) + '\n')
        elif b >= 0xa8 and b < 0xb0:
            output.write('xorcfc0bit ' + str(b&7) + '\n')
        elif b == 0xb0:
            flag = rom[address]
            address+=1
            mem = read16(rom,address)
            address+=2
            output.write('jumpifroomflagset ' + wlahex(flag,2) + ' ' + scriptStr(mem) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
        elif b == 0xb1:
            output.write('orroomflags ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xb3:
            addr = rom[address]
            address+=1
            flag = rom[address]
            address+=1
            mem = read16(rom,address)
            address+=2
            output.write('jumpifc6xxset ' + wlahex(addr,2) + ' ' + wlahex(flag,2) + ' ' + scriptStr(mem) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
        elif b == 0xb4:
            addr = rom[address]
            address+=1
            val = rom[address]
            address+=1
            output.write('writec6xx ' + wlahex(addr,2) + ' ' + wlahex(val,2) + '\n')
        elif b == 0xb5:
            flag = rom[address]
            address+=1
            mem = read16(rom,address)
            address+=2
            output.write('jumpifglobalflagset ' + wlahex(flag,2) + ' ' + scriptStr(mem) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
        elif b == 0xb6:
            output.write('setglobalflag ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xb8:
            output.write('setlinkcantmoveto91\n')
        elif b == 0xb9:
            output.write('setlinkcantmoveto00\n')
        elif b == 0xba:
            output.write('setlinkcantmoveto11\n')
        elif b == 0xbb:
            output.write('disablemenu\n')
        elif b == 0xbc:
            output.write('enablemenu\n')
        elif b == 0xbd:
            output.write('disableinput\n')
        elif b == 0xbe:
            output.write('enableinput\n')
        elif b == 0xc0:
            mem = read16(rom,address)
            address+=2
            output.write('callscript ' + scriptStr(mem) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
        elif b == 0xc1:
            output.write('retscript\n')
            if recurse:
                parseScript(address,output,recurse)
            return address
        elif b == 0xc3:
            byte = rom[address]
            address+=1
            mem = read16(rom, address)
            address+=2
            output.write('jumpifcba5eq ' + wlahex(byte,2) + ' ' + scriptStr(mem) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
        elif b == 0xc4:
            mem = read16(rom, address)
            address+=2
            output.write('jump ' + scriptStr(mem) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
        elif b == 0xc6:
            byte = rom[address]
            address+=1
            output.write('jumptable_interactionbyte ' + wlahex(byte) + '\n')
            mem = read16(rom,address)
            while mem >= 0x4000 and mem < 0x8000:
                output.write('.dw ' + scriptStr(mem) + '\n')
                if recurse:
                    parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
                address+=2
                mem = read16(rom,address)
            if recurse:
                parseScript(address,output,recurse)
            return address
        elif b == 0xc7:
            mem = read16(rom,address)
            address+=2
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            output.write('jumpifmemoryset ' + wlahex(mem,4) + ' ' + wlahex(val,2) + ' ' + scriptStr(jmp) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,jmp),output,recurse)
        elif b == 0xc8:
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            output.write('jumpifsomething2 ' + wlahex(val,2) + ' ' + scriptStr(jmp) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,jmp),output,recurse)
        elif b == 0xc9:
            mem = read16(rom,address)
            address+=2
            output.write('jumpifnoenemies ' + scriptStr(mem) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
        elif b == 0xca:
            mem = rom[address]
            address+=1
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            output.write('jumpiflinkvariablene ' + wlahex(mem,2) + ' ' + wlahex(val,2) + ' ' + scriptStr(jmp) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,jmp),output,recurse)
        elif b == 0xcb:
            mem = read16(rom,address)
            address+=2
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            output.write('jumpifmemoryeq ' + wlahex(mem,4) + ' ' + wlahex(val,2) + ' ' + scriptStr(jmp) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,jmp),output,recurse)
        elif b == 0xcc:
            mem = rom[address]
            address+=1
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            output.write('jumpifinteractionbyteeq ' + wlahex(mem,2) + ' ' + wlahex(val,2) + ' ' + scriptStr(jmp) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,jmp),output,recurse)
        elif b == 0xcd:
            output.write('stopifitemflagset\n')
        elif b == 0xce:
            output.write('stopifroomflag40set\n')
        elif b == 0xcf:
            output.write('stopifroomflag80set\n')
        elif b == 0xd0:
            output.write('checkcollidedwithlink_onground\n')
        elif b == 0xd1:
            output.write('checkpalettefadedone\n')
        elif b == 0xd2:
            output.write('checknoenemies\n')
        elif b == 0xd3:
            index = rom[address]
            address+=1
            start = read16(rom,address)
            address+=2
            output.write('checkflagset ' + wlahex(index,2) + ' ' + wlahex(start,4) + '\n')
        elif b == 0xd4:
            addr = rom[address]
            address+=1
            val = rom[address]
            address+=1
            output.write('checkinteractionbyteeq ' + wlahex(addr,2) + ' ' + wlahex(val,2) + '\n')
        elif b == 0xd5:
            addr = read16(rom,address)
            address+=2
            val = rom[address]
            address+=1
            output.write('checkmemoryeq ' + wlahex(addr,4) + ' ' + wlahex(val,2) + '\n')
        elif b == 0xd6:
            output.write('checknotcollidedwithlink_ignorez\n')
        elif b == 0xd7:
            output.write('setcheckabuttoncounter ' + wlahex(rom[address],2))
            address+=1
        elif b == 0xd8:
            output.write('checkcounter2iszero')
        elif b == 0xd9:
            output.write('checkheartdisplayupdated')
        elif b == 0xda:
            output.write('checkrupeedisplayupdated')
        elif b == 0xdb:
            output.write('checkcollidedwithlink_ignorez')
        elif b == 0xdd:
            output.write('spawnitem ' + wlahex(read16BE(rom,address),4) + '\n')
            address+=2
        elif b == 0xdd:
            output.write('giveitem ' + wlahex(read16BE(rom,address),4) + '\n')
            address+=2
        elif b == 0xdf:
            byte = rom[address]
            address+=1
            mem = read16(rom,address)
            address+=2
            output.write('jumpifsomething ' + wlahex(byte) + ' ' + scriptStr(mem) + '\n')
            if recurse:
                parseScript(bankedAddress((address-1)/0x4000,mem),output,recurse)
        elif b == 0xe0:
            output.write('asm15 ' + wlahex(read16(rom,address)) + '\n')
            address+=2
        elif b == 0xe1:
            output.write('asm15withparam ' + wlahex(read16(rom,address)) + ' ' + wlahex(rom[address+2],2) + '\n')
            address+=3
        elif b == 0xe2:
            output.write('createpuff\n')
        elif b == 0xe3:
            output.write('playsound ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xe4:
            output.write('setmusic ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xe5:
            output.write('setlinkcantmove ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xe6:
            output.write('spawnenemyhere ' + wlahex(read16(rom,address),4) + '\n')
            address+=1
        elif b == 0xe7:
            p = rom[address]
            address+=1
            val = rom[address]
            address+=1
            output.write('settile ' + wlahex(p,2) + ' ' + wlahex(val,2) + '\n')
        elif b == 0xe8:
            output.write('settilehere ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xe9:
            output.write('updatelinkrespawnposition\n')
        elif b == 0xea:
            output.write('shakescreen ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xeb:
            output.write('initnpchitbox\n')
        elif b == 0xec:
            output.write('movenpcup ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xed:
            output.write('movenpcright ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xee:
            output.write('movenpcdown ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xef:
            output.write('movenpcleft ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b >= 0xf0 and b < 0xfc:
            output.write('delay ' + wlahex(b&0xf) + '\n')
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
        if address < endAddress:
            continue
        if endAddress != 0 and endAddress != address:
            output.write('; Gap from ' + wlahex(endAddress) + ' to ' + wlahex(address) + '\n')
        lastAddress = address
        if address < (0xc+1)*0x4000:
            endAddress = parseScript(address,output)

output.seek(0)
print output.read()
