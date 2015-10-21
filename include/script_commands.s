.MACRO jump2byte
    .db \1>>8
    .db \1&$ff
.ENDM

.MACRO setstate
    .db $80 \1
.ENDM

.MACRO setstate2
    .db $81 \2
.ENDM

; Parameters: BANK, SRC
; Bytes are copied to c300
.MACRO loadscript
    .db $83 \1
    .dw \2
.ENDM

; @param[16] ID The ID of the interaction
; @param Y The interaction's Y position
; @param X The interaction's X psoition
.MACRO spawninteraction
    .db $84
    .db \1>>8 \1&$ff
    .db \2 \3
.ENDM

; @param[16] ID The ID of the enemy
; @param Y The enemy's Y position
; @param X The enemy's X psoition
.MACRO spawnenemy
    .db $85
    .db \1>>8 \1&$ff
    .db \2 \3
.ENDM

; @param unknown Unknown
.MACRO showpasswordscreen
    .db $86
    .db \1
.ENDM

; Set the X and Y coordinates of the interaction. If only 1 parameter is
; passed, it is read as YX (4 bits each) and are equivalent to Y8 X8. if
; 2 parameters are passed, they are read as YY XX (8 bits each).
; @param Y Y-position
; @param X X-position
.MACRO setcoords
    .db $88
    .IF NARGS == 2
        .db \2
        .db \1
    .ELSE
        .db (\1&$f0) | 8
        .db ((\1&$0f)<<4) | 8
    .ENDIF
.ENDM

; @param direction Direction to move in
.MACRO setmovingdirection
    .db $89 \1
.ENDM

; @param speed Speed (format is odd; $14 for standard walking forward speed)
.MACRO setspeed
    .db $8b \1
.ENDM

; @param 66 Value of byte 66
; @param 67 Value of byte 67
.MACRO loadd6667
    .db $8d \1 \2
.ENDM

; @param address Low byte of address to set (should be INTERAC_SOMETHING)
; @param value Byte value to write to the address
.MACRO setinteractionbyte
    .db $8e \1 \2
.ENDM

; @param unknown1 Unknown
; @param[opt] unknown2 Unknown
.MACRO loadsprite
    .db $8f \1
    .IF NARGS == 2
    	.db \2
    .ENDIF
.ENDM

; Compares the interaction's x-position to link's x-position and stores the
; result in the given address (result is $00 if this.x >= link.x, otherwise
; it's $01)
; @param resultAddr Address to store the result
.MACRO checklinkxtoma
    .db $90 \1
.ENDM

; Write a byte to an absolute address.
; @param[16] address Address to write to
; @param value Value to write to the address
.MACRO writememory
    .db $91
    .dw \1
    .db \2
.ENDM

; Bitwise OR a byte with an absolute address.
; @param[16] address Address to OR with and store result into.
; @param Value to OR with.
.MACRO ormemory
    .db $92
    .dw \1
    .db \2
.ENDM

; Get a random number, store it into an interaction address.
; @param laddress Interaction address to store result into
; @param value Value to bitwise AND with the random number before storing it.
.MACRO getrandombits
	.db $93
	.db \1 \2
.ENDM

; Add a byte with an interaction address.
; @param laddress Interaction address to add with.
; @param Value to add.
.MACRO addinteractionbyte
    .db $94
    .db \1 \2
.ENDM

; Sets the interaction's vertical speed.
; @param speed Vertical speed
.MACRO setzspeed
	.db $95
	.dw \1
.ENDM

; @param movingDirection Link's moving direction (bitset)
.MACRO setmovingdirectionandmore
    .db $96
    .db \1
.ENDM

.MACRO settextidjp
    .db $97
    .db \1>>8 \1&$ff
.ENDM

; Sometimes only takes 1 argument ??
.MACRO showtext
    .db $98
    .db \1>>8 \1&$ff
.ENDM


.MACRO checktext
    .db $99
.ENDM

.MACRO settextid
    .db $9c
    .dw \1
.ENDM

.MACRO showloadedtext
    .db $9d
.ENDM

.MACRO checkabutton
    .db $9e
.ENDM

; If the room flag AND arg1 is nonzero, it jumps to the specified relative address.
; I don't think this will work if the address in question is not loaded into the
; $100 bytes at c300 (but if it's in bank C, go nuts).
.MACRO checkroomflag
    .db $b0 \1
    .dw \2
.ENDM

.MACRO setroomflag
    .db $b1 \1
.ENDM

.MACRO setglobalflag
    .db $b6 \1
.ENDM

.MACRO disableinput
    .db $bd
.ENDM

.MACRO enableinput
    .db $be
.ENDM

.MACRO callscript
    .db $c0
    .dw \1
.ENDM

.MACRO checkitemflag
    .db $cd
.ENDM

.MACRO checkspecialflag
    .db $cf
.ENDM

.MACRO checkenemycount
    .db $d2
.ENDM

.MACRO checkmemorybit
    .db $d3
    .db \1
    .dw \2
.ENDM

.MACRO checkmemory
    .db $d5
    .dw \1
    .db \2
.ENDM

.MACRO spawnitem
    .db $dd
    .db \1>>8 \1&$ff
.ENDM

.MACRO giveitem
    .db $de
    .db \1>>8 \1&$ff
.ENDM

.MACRO asm15
    .db $e0
    .dw \1
.ENDM

.MACRO createpuff
    .db $e2
.ENDM

.MACRO playsound
    .db $e3
    .db \1
.ENDM

.MACRO setmusic
    .db $e4
    .db \1
.ENDM

.MACRO setcc8a
    .db $e5
    .db \1
.ENDM

.MACRO spawnenemyhere
    .db $e6
    .db \1>>8 \1&$ff
.ENDM

.MACRO settile
    .db $e7
    .db \1 \2
.ENDM

.MACRO settilehere
    .db $e8
    .db \1
.ENDM

.MACRO shakescreen
    .db $ea
    .db \1
.ENDM

; $eb relates to npc collisions, & allows you to talk to them? Perhaps allows checkabutton to work?
.MACRO fixnpchitbox
    .db $eb
.ENDM

; Moves an npc a set distance.
; Arg determines length of time.
; Dx50 determines speed.
; $21 and $14, respectively, will move an npc one tile.
; Some values:
; 14 - forward
; 15 - right
; 16 - backward
; 17 - left
; 1c - back fast
; 1d - left fast
; 1e - forward fast
; 1f - right fast
; 28 - forward faster
.MACRO movenpcup
    .db $ec \1
.ENDM
.MACRO movenpcright
    .db $ed \1
.ENDM
.MACRO movenpcdown
    .db $ee \1
.ENDM
.MACRO movenpcleft
    .db $ef \1
.ENDM

.MACRO setdelay
    .db $f0 + \1
.ENDM

.MACRO jump3byte
    .db $fd $00
    .db :\1
    .dw \1
.ENDM

.MACRO jumproomflag
    .db $fd $01
    .db \1
    .db :\2
    .dw \2
.ENDM

.MACRO jump3bytemc
    .db $fd $02
    .dw \1
    .db \2
    .db :\3
    .dw \3
.ENDM

.MACRO jumproomflago
    .db $fd $03
    .db \1 \2 \3
    .db :\4
    .dw \4
.ENDM

; Lin's patch had this do "unsetroomflag".
; I replaced it with a general asm call.
; Not enough space in bank c for everything I wanted...
.MACRO asm
    .db $fd $04
    .db :\1
    .dw \1
.ENDM

.MACRO createinteraction
    .db $fd $05
    .dw \1
.ENDM

.MACRO forceend
    .db $00
.ENDM

; arg1 is a byte for the interaction, ex. d3xx
; Uses this byte as an index for a jump table immediately proceeding the opcode.
; Only works in bank $c.
.MACRO jumptable
    .db $c6 \1
    .dw \2 \3
    .IF NARGS >= 4
    .dw \4
    .ENDIF
.ENDM

; This holds while [c4ab] is non-zero, and stops script execution for this frame.
; Could be useful for starting a script only when the transition finishes?
.MACRO unknownd1
    .db $d1
.ENDM


; pseudo-ops

.MACRO checktile
    .if nargs == 3
        .db $ff $02 \1 \2 \3
    .else
        checkmemory $cf00+\1 \2
        .db $d5 \1 $cf \2
    .endif
.ENDM

.MACRO maketorcheslightable
    asm15 $4f4b
.ENDM

.MACRO createpuffnodelay
    asm15 $24c1
.ENDM

.MACRO setinteractionword
    setinteractionbyte \1 \2&$ff
    setinteractionbyte \1+1 \2>>$8
.ENDM
