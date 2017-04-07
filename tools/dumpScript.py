# There are some problems when dumping scripts not in bank C:
# - "jump" commands will either jump locally, or to somewhere in bank C. It's local if the
# jump would land in the $c300 buffer, otherwise it jumps to bank C. For now it's assumed
# that all jumps are local.

import sys
import StringIO

index = sys.argv[0].rfind('/')
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

# Table of frame values for each "delay" command
delayFrameTable = [ 1, 4, 8, 10, 15, 20, 30, 40, 60, 90, 120, 180, 240 ]

scriptBaseBank = 0xC
scriptSecondBank = 0x15

scriptsToParse = set()
newScriptsToParse = []
parsedScripts = {}

extraScriptAddresses = { 0x307bd, 0x307c0, 0x309bb, 0x309bc, 0x309c8, 0x30b44, 0x30c9e, 0x30d2b, 0x31c84, 0x33279,
        0x33ad7, 0x33ddd}

workingBank = -1

sys.setrecursionlimit(0x1000)

def scriptStr(address):
    val = myhex(toGbPointer(address))
    if address/0x4000 == scriptBaseBank:
        base = 'script'
    else:
        base = 'script' + myhex(address/0x4000,2) + '_'
    return base + val

# Values for "recurse" parameter:
# 0: don't recurse
# 1: recurse for jumps and calls
# 2: recurse to the address after "jump" and "end" opcodes (will only work properly when
#    address bounds are hardcoded)
def parseScript(address, output, recurse=0):
    global newScriptsToParse
    global parsedScripts

    if recurse > 0 and (address in parsedScripts and parsedScripts[address] >= recurse):
        return
    if workingBank != -1:
        if not (address >= workingBank*0x4000 and address < (workingBank+1)*0x4000):
            return
    elif not ((address >= 0x30000 and address < 0x33f93) or (address/0x4000) == scriptSecondBank):
#             or (address >= 0x15*0x4000 and address < 0x16*0x4000)):
        if address != 0x33f93:
            print >> sys.stderr, 'Address ' + wlahex(address)
        return;
#     if not (address >= 0 and address < 0x4000):
#         return
    if address == 0x33653:
        return

    if recurse > 0:
        newScriptsToParse.append(address)
    parsedScripts[address] = recurse

    while True:

        # hardcoded: address of a "simple script".
        if address >= 0x3323f and address < 0x33279:
            if address == 0x3323f:
                output.write('simpleScript' + myhex(toGbPointer(address),4) + ':\n')

            b = rom[address]
            address+=1
            output.write('\t')

            if b == 0:
                output.write('ss_end\n')
            elif b == 1:
                output.write('ss_setcounter1 ' + wlahex(rom[address]) + '\n')
                address+=1
            elif b == 2:
                output.write('ss_playsound ' + wlahex(rom[address]) + '\n')
                address+=1
            elif b == 3:
                output.write('ss_settile ' + wlahex(rom[address])+' '+wlahex(rom[address+1]) + '\n')
                address+=2
            elif b == 4:
                p0 = rom[address]
                p1 = rom[address+1]
                p2 = rom[address+2]
                p3 = rom[address+3]
                output.write('ss_setinterleavedtile ' + wlahex(p0)+' '+wlahex(p1)
                        +' '+wlahex(p2)+' '+wlahex(p3)+'\n')
                address+=4
            else:
                output.write('\t.db ' + wlahex(rom[address],2) + '\n')

            continue

        if address in parsedScripts or address in extraScriptAddresses:
            output.write(scriptStr(address) + ':\n')
        b = rom[address]
        address+=1
        output.write('\t')

        if b == 0:
            output.write('scriptend\n')
            if recurse == 2:
                parseScript(address, output, recurse)
            return address
        elif b < 0x80:
            mem = read16BE(rom,address-1)
            newAddress = bankedAddress((address-1)/0x4000, mem)
            output.write('jump2byte ' + scriptStr(newAddress) + '\n')
            address+=1
            if recurse > 0:
                parseScript(newAddress, output, recurse)
            if recurse == 2:
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
            destination = bankedAddress(bank,mem)
#             output.write('loadscript ' + wlahex(bank,2) + ' ' + wlahex(mem,4) + '\n')
            output.write('loadscript ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination, output, 1 if recurse > 0 else 0)
            if recurse == 2:
                parseScript(address,output,recurse)
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
            while mem >= 0x4000 and mem < 0x8000 and not address in parsedScripts:
                destination = bankedAddress((address-1)/0x4000,mem)
                output.write('\t.dw ' + scriptStr(destination) + '\n')
                if recurse > 0:
                    parseScript(destination,output,recurse)
                address+=2
                mem = read16(rom,address)
            if recurse == 2:
                parseScript(address,output,recurse)
            return address
        elif b == 0x88:
            y = rom[address]
            address+=1
            x = rom[address]
            address+=1
            output.write('setcoords ' + wlahex(y,2) + ' ' + wlahex(x,2) + '\n')
        elif b == 0x89:
            output.write('setangle ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x8a:
            output.write('turntofacelink\n')
        elif b == 0x8b:
            speed = rom[address]
            if speed%5 == 0:
                output.write('setspeed SPEED_' + myhex(rom[address]/5*0x20,3) + '\n')
            else:
                output.write('setspeed ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x8c:
            output.write('checkcounter2iszero ' + wlahex(rom[address],2) + '\n')
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
            output.write('setanimation ' + wlahex(anim,2))
            if anim == 0xfe:
                output.write(' ' + wlahex(rom[address],2))
                address+=1
            output.write('\n')
        elif b == 0x90:
            output.write('cplinkx ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x91:
            mem = read16(rom,address)
            address+=2
            val = rom[address]
            address+=1
            output.write('writememory ' + wlahex(mem,4) + ' ' + wlahex(val,2) + '\n')
        elif b == 0x92:
            mem = read16(rom,address)
            address+=2
            val = rom[address]
            address+=1
            output.write('ormemory ' + wlahex(mem,4) + ' ' + wlahex(val,2) + '\n')
        elif b == 0x93:
            output.write('getrandombits ' + wlahex(rom[address],2) + ' ' + wlahex(rom[address+1],2) + '\n')
            address+=2
        elif b == 0x94:
            output.write('addinteractionbyte ' + wlahex(rom[address],2) + ' ' + wlahex(rom[address+1],2) + '\n')
            address+=2
        elif b == 0x95:
            output.write('setzspeed ' + wlahexSigned(read16(rom,address),4) + '\n')
            address+=2
        elif b == 0x96:
            output.write('setangleandanimation ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0x97:
            if (address >= 0x31b68 and address < 0x31ddd) \
                    or rom[address+1] < 0x40:
                textIndex = read16BE(rom,address)
                address+=2
                output.write('rungenericnpc ' + wlahex(textIndex,4) + '\n')
            else:
                textIndex = rom[address]
                address+=1
                output.write('rungenericnpclowindex ' + wlahex(textIndex,2) + '\n')
            if recurse == 2:
                parseScript(address,output,recurse)
            return address
        elif b == 0x98:
            # Addresses for the opcode variant are hard-coded.
            # Ones I'm not sure about:
            # - 3 showtext opcodes around 47ba
            # - 49b5
            # - 4af6-4b03 (probably lowindex)
            # - 4b10 (probably lowindex)
            if (address > 0x3069d and address < 0x307f1) \
                    or (address > 0x30b11 and address < 0x30b31) \
                    or (address > 0x30c8e and address < 0x30d29) \
                    or (address > 0x30f5b and address < 0x31308) \
                    or (address > 0x31327 and address < 0x31b0f) \
                    or (address > 0x31e9a and address < 0x320a8) \
                    or (address >= 0x3230f and address < 0x3252d) \
                    or (address >= 0x3276f and address < 0x330de) \
                    or (address >= 0x33470 and address < 0x33628) \
                    or (address >= 0x33b59 and address < 0x33b9d) \
                    or (address >= 0x54000 and address < 0x55575) \
                    or (address >= 0x56152 and address < 0x5618c) \
                    or (address >= 0x561fb and address < 0x562a0) \
                    or (address >= 0x56be7 and address < 0x570d4) \
                    or (address >= 0x57355 and address < 0x573ac) \
                    or (address >= 0x577b3 and address < 0x577de) \
                    or (address >= 0x57adb and address < 0x57b0e) \
                    or (rom[address+1] < 0x40 and rom[address+1] > 0):
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
            if (address >= 0x57501 and address < 0x575b3) \
                    or (rom[address+1] < 0x40 and rom[address+1] > 0):
                textIndex = read16BE(rom,address)
                address+=2
                output.write('showtextnonexitable ' + wlahex(textIndex,4) + '\n')
            else:
                textIndex = rom[address]
                address+=1
                output.write('showtextnonexitablelowindex ' + wlahex(textIndex,2) + '\n')
        elif b == 0x9b:
            output.write('makeabuttonsensitive\n')
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
            destination = bankedAddress((address-1)/0x4000,mem)
            output.write('jumpifroomflagset ' + wlahex(flag,2) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xb1:
            output.write('orroomflag ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xb3:
            addr = rom[address]
            address+=1
            flag = rom[address]
            address+=1
            mem = read16(rom,address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,mem)
            output.write('jumpifc6xxset ' + wlahex(addr,2) + ' ' + wlahex(flag,2) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
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
            destination = bankedAddress((address-1)/0x4000,mem)
            output.write('jumpifglobalflagset ' + wlahex(flag,2) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xb6:
            output.write('setglobalflag ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xb8:
            output.write('setdisabledobjectsto91\n')
        elif b == 0xb9:
            output.write('setdisabledobjectsto00\n')
        elif b == 0xba:
            output.write('setdisabledobjectsto11\n')
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
            destination = bankedAddress(scriptBaseBank,mem) # Always calls to bank $C
            output.write('callscript ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xc1:
            output.write('retscript\n')
            if recurse == 2:
                parseScript(address,output,recurse)
            return address
        elif b == 0xc3:
            byte = rom[address]
            address+=1
            mem = read16(rom, address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,mem)
            output.write('jumpiftextoptioneq ' + wlahex(byte,2) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xc4:
            mem = read16(rom, address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,mem)
            output.write('jumpalways ' + scriptStr(destination) + '\n')
            if recurse == 2:
                parseScript(destination,output,recurse)
        elif b == 0xc6:
            byte = rom[address]
            address+=1
            output.write('jumptable_interactionbyte ' + wlahex(byte) + '\n')
            mem = read16(rom,address)
            while mem >= 0x4000 and mem < 0x8000 and not address in parsedScripts:
                destination = bankedAddress((address-1)/0x4000,mem)
                output.write('\t.dw ' + scriptStr(destination) + '\n')
                if recurse > 0:
                    parseScript(destination,output,recurse)
                address+=2
                mem = read16(rom,address)
            if recurse == 2:
                parseScript(address,output,recurse)
            return address
        elif b == 0xc7:
            mem = read16(rom,address)
            address+=2
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,jmp)
            output.write('jumpifmemoryset ' + wlahex(mem,4) + ' ' + wlahex(val,2) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xc8:
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,jmp)
            output.write('jumpiftradeitemeq ' + wlahex(val,2) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xc9:
            mem = read16(rom,address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,mem)
            output.write('jumpifnoenemies ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xca:
            mem = rom[address]
            address+=1
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,jmp)
            output.write('jumpiflinkvariableneq ' + wlahex(mem,2) + ' ' + wlahex(val,2) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xcb:
            mem = read16(rom,address)
            address+=2
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,jmp)
            output.write('jumpifmemoryeq ' + wlahex(mem,4) + ' ' + wlahex(val,2) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xcc:
            mem = rom[address]
            address+=1
            val = rom[address]
            address+=1
            jmp = read16(rom,address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,jmp)
            output.write('jumpifinteractionbyteeq ' + wlahex(mem,2) + ' ' + wlahex(val,2) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xcd:
            output.write('checkitemflag\n')
        elif b == 0xce:
            output.write('checkroomflag40\n')
        elif b == 0xcf:
            output.write('checkroomflag80\n')
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
            output.write('setcounter1 ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xd8:
            output.write('checkcounter2iszero\n')
        elif b == 0xd9:
            output.write('checkheartdisplayupdated\n')
        elif b == 0xda:
            output.write('checkrupeedisplayupdated\n')
        elif b == 0xdb:
            output.write('checkcollidedwithlink_ignorez\n')
        elif b == 0xdd:
            output.write('spawnitem ' + wlahex(read16BE(rom,address),4) + '\n')
            address+=2
        elif b == 0xde:
            output.write('giveitem ' + wlahex(read16BE(rom,address),4) + '\n')
            address+=2
        elif b == 0xdf:
            byte = rom[address]
            address+=1
            mem = read16(rom,address)
            address+=2
            destination = bankedAddress((address-1)/0x4000,mem)
            output.write('jumpifitemobtained ' + wlahex(byte) + ' ' + scriptStr(destination) + '\n')
            if recurse > 0:
                parseScript(destination,output,recurse)
        elif b == 0xe0:
            output.write('asm15 ' + wlahex(read16(rom,address),4) + '\n')
            address+=2
        elif b == 0xe1:
            output.write('asm15 ' + wlahex(read16(rom,address),4) + ' ' + wlahex(rom[address+2],2) + '\n')
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
            output.write('setdisabledobjects ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xe6:
            output.write('spawnenemyhere ' + wlahex(read16BE(rom,address),4) + '\n')
            address+=2
        elif b == 0xe7:
            p = rom[address]
            address+=1
            val = rom[address]
            address+=1
            output.write('settileat ' + wlahex(p,2) + ' ' + wlahex(val,2) + '\n')
        elif b == 0xe8:
            output.write('settilehere ' + wlahex(rom[address],2) + '\n')
            address+=1
        elif b == 0xe9:
            output.write('updatelinkrespawnposition\n')
        elif b == 0xea:
            output.write('shakescreen ' + str(rom[address]) + '\n')
            address+=1
        elif b == 0xeb:
            output.write('initcollisions\n')
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
        elif b >= 0xf0 and b <= 0xfc:
            output.write('wait ' + str(delayFrameTable[b&0xf]) + '\n')
        else:
            output.write('.db ' + wlahex(b) + '\n')
            return address
    return address

output = StringIO.StringIO()
output2 = StringIO.StringIO()

if len(sys.argv) >= 3:
    addr = int(sys.argv[2])
    workingBank = addr/0x4000
    parseScript(addr, output, 1)
else:
    parseScript(0x305ef,output,2)

output = StringIO.StringIO()
newScriptsToParse = sorted(newScriptsToParse)

lastAddress = 0
endAddress = 0
for address in newScriptsToParse:
    if address < endAddress:
        parseScript(address,output2)
        continue
    if endAddress != 0 and endAddress != address:
        output.write('; Gap from ' + wlahex(endAddress) + ' to ' + wlahex(address) + '\n')
    lastAddress = address
    endAddress = parseScript(address,output)

output.seek(0)
print output.read()
# output2.seek(0)
# f = file('out2','w')
# f.write(output2.read())
