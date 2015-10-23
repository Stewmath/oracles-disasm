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
.MACRO writeinteractionbyte
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
.MACRO cplinkx
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

; Displays the text index given. Only use this when INTERAC_HIGHTEXTINDEX is
; zero (default); otherwise use showtextlowindex.
; @param[16] textIndex The text index to display.
.MACRO showtext
	.db $98
	.db \1>>8 \1&$ff
.ENDM

; Displays the text index with high byte [INTERAC_HIGHTEXTINDEX] and the low
; byte given. Only use this when INTERAC_HIGHTEXTINDEX is nonzero; otherwise
; use showtext.
; @param textIndex The low byte of the text index to display.
.MACRO showtextlowindex
	.db $98
	.db \1
.ENDM


; Hold script execution until text is no longer being displayed.
.MACRO checktext
	.db $99
.ENDM

; Displays the text index given, being non-exitable by user input. Only use
; this when INTERAC_HIGHTEXTINDEX is zero (default); otherwise use
; showtextnonexitablelowindex.
; @param[16] textIndex The text index to display.
.MACRO showtextnonexitable
	.db $9a
	.db \1>>8 \1&$ff
.ENDM

; Displays the text index given, being non-exitable by user input. Only use
; this when INTERAC_HIGHTEXTINDEX is zero (default); otherwise use
; showtextnonexitablelowindex.
; @param textIndex The low byte of the text index to display.
.MACRO showtextnonexitablelowindex
	.db $9a
	.db \1
.ENDM

; Holds execution until something
.MACRO checksomething
	.db $9b
.ENDM

; Set the INTERAC_TEXTID variable. This text ID can later be shown with
; showloadedtext.
; @param[16] Text ID
.MACRO settextid
	.db $9c
	.dw \1
.ENDM

; Show the text id corresponding to the INTERAC_TEXTID variable (set by
; settextid).
.MACRO showloadedtext
	.db $9d
.ENDM

; Hold script execution until the a button is pressed while link is next to the
; interaction. Use to wait for npc dialog, etc.
; \nYou must use the initnpchitbox command before you can use this.
.MACRO checkabutton
	.db $9e
.ENDM

; Shows a certain text id depending if the game is linked or unlinked
; @param highID The high byte of the ID
; @param unlinkedID The low byte of the ID for an unlinked game
; @param linkedID The low byte of the ID for a linked game
.MACRO showtextdifferentforlinked
	.db $9f
	.db \1 \2
.ENDM

; Holds execution until the given bit of wCFC0 is set.
; @param bit Bit to check (0-7)
.MACRO checkcfc0bit:
	.db $a0 | \1
.ENDM

; Xors the given bit in wCFC0.
; @param bit Bit to xor (0-7)
.MACRO xorcfc0bit:
	.db $a8 | \1
.ENDM

; Jumps to the specified address if the specified flag(s) in the room are set.
; When the script is loaded into wBigBuffer, this will only work if the
; destination to jump to is already loaded into the buffer.
; @param andVal Value to AND with the room flags for the check
; @param[16] destination Destination address to jump to if the result is nonzero
.MACRO jumpifroomflagset
	.db $b0 \1
	.dw \2
.ENDM

; OR the room flags with the given value. Use to mark if an event has occured,
; and if so, you can skip it with the jumpifroomflagset opcode.
.MACRO orroomflags
	.db $b1 \1
.ENDM

; B2: no command

; Jumps to the specified address if a specified address ($c6xx) AND the given
; value is nonzero.
; When the script is loaded into wBigBuffer, this will only work if the
; destination to jump to is already loaded into the buffer.
; @param laddress The low byte of the address to jump to (ie. if address is
; "$75", corresponding to "<wNumSmallKeys", it will read from $c675.)
; @param andVal Value to AND with the adress for the check
; @param[16] destination Destination address to jump to if the result is nonzero
.MACRO jumpifc6xxset
	.db $b3
	.db \1 \2
	.dw \3
.ENDM

; Write the given value to an address at $c6xx.
; @param laddress Low byte of the address to write to
; @param value Value to write to the address
.MACRO writec6xx
	.db $b4
	.db \1 \2
.ENDM

; Jump to the specified address if the given global flag is set.
; A list of global flags can be found in "constants/globalFlags.s".
; @param globalFlag The flag to check
; @param[16] destination Destination address to jump to if the flag is set
.MACRO jumpifglobalflagset
	.db $b5 \1
	.dw \2
.ENDM

; Sets the specified global flag.
; A list of global flags can be found in "constants/globalFlags.s".
; @param globalFlag The global flag to set
.MACRO setglobalflag
	.db $b6 \1
.ENDM

; Unsets the specified global flag.
; A list of global flags can be found in "constants/globalFlags.s".
; @param globalFlag The global flag to unset
.MACRO setglobalflag
	.db $b6 (\1 | $80)
.ENDM

; $B7: no command

; Set the variable wLinkCantMove to $91. Causes him to stop moving, further
; details unknown.
.MACRO setlinkcantmoveto91
	.db $b8
.ENDM

; Set the variable wLinkCantMove to $00, allowing him to move normally.
.MACRO setlinkcantmoveto00
	.db $b9
.ENDM

; Set the variable wLinkCantMove to $11. Causes him to stop moving, further
; details unknown.
.MACRO setlinkcantmoveto11
	.db $ba
.ENDM

.MACRO disablemenu
	.db $bb
.ENDM

.MACRO enablemenu
	.db $bc
.ENDM

; Disables link movement and the menu.
.MACRO disableinput
	.db $bd
.ENDM

; Enables link movement and the menu.
.MACRO enableinput
	.db $be
.ENDM

; $BF: no command

; Call another script. Only works 1 level deep?
; @param[16] script Script to call
.MACRO callscript
	.db $c0
	.dw \1
.ENDM

; Return from a script after a callscript command.
.MACRO retscript
	.db $c1
.ENDM

; $C2: no command

; Jump to the specified address if ($cba5) equals the given value
; @param value The value to compare ($cba5) with.
; @param[16] destination Destination address to jump to if the flag is set
.MACRO jumpifcba5eq
	.db $c3
	.db \1
	.dw \2
.ENDM

; Jump to the specified address unconditionally.
.MACRO jump
	.db $c4
	.dw \1
.ENDM

; $C5: no command

; Uses this byte as an index for a jump table immediately after the opcode.
; After this opcode you can do as many .dw statements and you like, each
; indicating an index's location to jump to.
; Only works in bank $c.
; @param indexAddr Address of an interaction variable which will be the index
; for the table.
.MACRO jumptable
	.db $c6 \1
.ENDM

; Jump to somewhere if the given memory address AND the given value is nonzero.
; @param[16] address Address to AND with
; @param byte Byte to AND the address with
.MACRO jumpifmemoryset
	.db $c7
	.dw \1
	.db \2
.ENDM

; @param unknown Unknown
; @param[16] destination
.MACRO jumpifsomething
	.db $c8 \1
	.dw \2
.ENDM

; Jump somewhere if (wNumEnemies) is zero.
; @param[16] destination Destination to jump to
.MACRO jumpifnoenemies
	.db $c9
	.dw \1
.ENDM

; Jump somewhere if one of link's variables (d0xx) does not equal the given
; value.
; @param variable The low byte of the address to compare with (d0xx)
; @param cpValue Value to compare with
; @param[16] destination Destination to jump to
.MACRO jumpiflinkvariablene
	.db $ca
	.db \1 \2
	.dw \3
.ENDM

; Jump somewhere if the given memory address equals a certain value.
; @param[16] address Memory address to check
; @param value Value to compare with memory address
.MACRO jumpifmemoryeq
	.db $cb
	.dw \1
	.db \2
.ENDM

; Jump somewhere if the given interaction byte equals a certain value.
; @param laddress Low byte of the address to check (dyxx, where y corresponds
; to the current interaction)
; @param value Value to compare with memory address
.MACRO jumpifinteractionbyteeq
	.db $cc
	.db \1
	.db \2
.ENDM

; Stops execution of the script if the room's item flag (aka ROOMFLAG_ITEM)
; is set.
.MACRO stopifitemflagset
	.db $cd
.ENDM

; Stops execution of the script if ROOMFLAG_40 is set for this room.
.MACRO stopifflag40set
	.db $ce
.ENDM

; Stops execution of the script if ROOMFLAG_40 is set for this room.
.MACRO stopifflag80set
	.db $cf
.ENDM

; Holds execution until link and the interaction collide, and link is on the
; ground. It may be necessary to do "fixnpchitbox" before this.
.MACRO checkcollidedwithlink_onground
	.db $d0
.ENDM

; Holds execution until the palettes are done fading in or out.
.MACRO checkpalettefadedone
	.db $d1
.ENDM

; Holds execution until wNumEnemies equals zero.
.MACRO checknoenemies
	.db $d2
.ENDM

; Holds execution until a "flag" (a bit in memory) is set. Uses the checkFlag
; function.
; @param byte The index of the flag to check (not a bitmask)
; @param address The starting address of the flags (ie wGlobalFlags)
.MACRO checkflagset
	.db $d3
	.db \1
	.dw \2
.ENDM

; Holds execution until the given interaction byte ($dyxx) equals the given
; value.
; @param laddress The low byte of the address to check (xx in $dyxx)
; @param value The value to check for equality with
.MACRO checkinteractionbyteeq
	.db $d4
	.db \1 \2
.ENDM

; Holds execution until the given memory address equals the given value.
; @param address The address to check
; @param value The value to check for equality with
.MACRO checkmemoryeq
	.db $d5
	.dw \1
	.db \2
.ENDM

; Holds execution until link and the interaction are not colliding. You may
; need to do "fixnpchitbox" before this.
.MACRO checknotcollidedwithlink_ignorez
	.db $d6
.ENDM

; Sets INTERAC_CHECKABUTTONCOUNTER1 to the given value. When set on an npc,
; they don't seem to respond until the counter counts down to zero.
.MACRO setcheckabuttoncounter1:
	.db $d7 \1
.ENDM

; Holds execution until INTERAC_ACTIONCOUNTER2 is zero.
.MACRO checkactioncounter2iszero:
	.db $d8 \1
.ENDM

; Holds execution until the heart display on the HUD is fully updated after
; gaining or losing hearts.
.MACRO checkheartdisplayupdated
	.db $d9
.ENDM

; Holds execution until the rupee display on the HUD is fully updated after
; gaining or losing rupees.
.MACRO checkrupeedisplayupdated
	.db $da
.ENDM

; Holds execution until link and the interaction collide, ignoring their
; respective Z positions.  It may be necessary to do "fixnpchitbox" before
; this.
.MACRO checkcollidedwithlink_ignorez
	.db $db
.ENDM

; $DC: no command

; Spawn an item at the interaction's coordinates.
.MACRO spawnitem
	.db $dd
	.db \1>>8 \1&$ff
.ENDM

; Spawn an item at link's coordinates. In most cases this will cause link to
; grab it instantly.
.MACRO giveitem
	.db $de
	.db \1>>8 \1&$ff
.ENDM

; TODO: verify this
.MACRO getitemlevelorcount
	.db $df
.ENDM

; Call an assembly function in bank $15 at the specified address.
; @param address Address of the assembly to run (bank $15)
.MACRO asm15
	.db $e0
	.dw \1
.ENDM

; Call an assembly function in bank $15 at the specified address, and set e to
; the specified value.
; @param address Address of the assembly to run (bank $15)
; @param parameter Value to set e register to before calling
.MACRO asm15withparam
	.db $e1
	.dw \1
	.db \2
.ENDM

; Create a puff at this interaction's position.
.MACRO createpuff
	.db $e2
.ENDM

; Play the sound effect specified (see constants/music.s)
; @param sound The sound effect to play
.MACRO playsound
	.db $e3
	.db \1
.ENDM

; Set the music (see constants/music.s)
; @param music The music to play
.MACRO setmusic
	.db $e4
	.db \1
.ENDM

; Set wLinkCantMove to the specified value.
; @param value The value to write to wLinkCantMove.
.MACRO setlinkcantmove
	.db $e5
	.db \1
.ENDM

; Spawn an enemy at this interaction's position.
; @param[16] id The ID of the enemy to spawn
.MACRO spawnenemyhere
	.db $e6
	.db \1>>8 \1&$ff
.ENDM

; Set the tile on the map at the specified position to the specified value.
; @param YX The position to change
; @param tile The tile index to set it to
.MACRO settile
	.db $e7
	.db \1 \2
.ENDM

; Set the tile at this interaction's position position to the specified value.
; @param tile The tile index to set it to
.MACRO settilehere
	.db $e8
	.db \1
.ENDM

; Save link's current position as the place to respawn after falling in a hole
; or things like that.
.MACRO updatelinkrespawnposition
	.db $e9
.ENDM

; Shake the screen horizontally by setting wScreenShakeCounterX.
; @param value The value to set wScreenShakeCounterX to.
.MACRO shakescreen
	.db $ea
	.db \1
.ENDM

; Initialize the COLLIDERADIUS variables to $06 and add this objuct to
; wAButtonSensitiveObjectList, allowing you to use checkabutton.
.MACRO initnpchitbox
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

; Wait a number of frames.
; @param frames Number of frames to wait
.MACRO delay
	.IF \1 > $c
		.PRINTT "SCRIPT ERROR: delay takes a value from $00-$0c.\n"
		.FAIL
	.ENDIF
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
