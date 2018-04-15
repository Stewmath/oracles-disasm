.MACRO scriptend
	.db $00
.ENDM

.MACRO jump2byte
	.db \1>>8
	.db \1&$ff
.ENDM

; Set the value of the Interaction.state variable.
.MACRO setstate
	.db $80 \1
.ENDM

; Set the value of the Interaction.state2 variable.
.MACRO setstate2
	.db $81 \1
.ENDM

; $82: not a real command

; Loads a script to wBigBuffer ($c300, up to 256 bytes) and runs the script there.
; param1:	Script to load and jump to
.MACRO loadscript
	.IF NARGS == 2
		.db $83 \1
		.dw \2
	.ELSE
		.db $83 :\1
		.dw \1
	.ENDIF
.ENDM

; Spawns an interaction.
; param1:	The ID of the interaction
; param2:	The SubID of the interaction
; param3:	The interaction's Y position
; param4:	The interaction's X position
.MACRO spawninteraction
	.db $84
	.if NARGS == 3
		.db \1>>8 \1&$ff
		.db \2 \3
	.else
		.db \1 \2
		.db \3 \4
	.endif
.ENDM

; Spawns an enemy.
; param1:	The ID of the enemy
; param2:	The SubID of the enemy
; param3:	The enemy's Y position
; param4:	The enemy's X position
.MACRO spawnenemy
	.db $85
	.if NARGS == 3
		.db \1>>8 \1&$ff
		.db \2 \3
	.else
		.db \1 \2
		.db \3 \4
	.endif
.ENDM

; Asks for a 5-letter secret.
;
; param1:	The index of the secret to ask for (see wShortSecretIndex).
;		If $ff, it accepts any secret (used with farore).
.MACRO askforsecret
	.if \1 >= $10
	.if \1 < $ff
		.PRINTT "SCRIPT ERROR: argument to 'askforsecret' out of range.\n"
		.FAIL
	.endif
	.endif
	.db $86 \1
.ENDM

; Generates a 5-letter secret, which can later be printed through a textbox. (The text can
; use the "\secret1" command to print it.)
;
; param1:	The index of the secret to generate (see wShortSecretIndex).
.MACRO generatesecret
	.if \1 >= $10
		.PRINTT "SCRIPT ERROR: argument to 'generatesecret' out of range.\n"
		.FAIL
	.endif
	.db $86 (\1|$10)
.ENDM

; Uses the given memory address as an index for a jump table immediately after the
; opcode. After this opcode you can do as many .dw statements and you like,
; each indicating an index's location to jump to.
;
; param1[16]:	Memory address to use as the index for the table
;		(memory address $dyxx, where y corresponds to this object)
.MACRO jumptable_memoryaddress
	.db $87
	.dw \1
.ENDM

; Set the X and Y coordinates of the interaction. If only 1 parameter is
; passed, it is read as $YX (4 bits each) and are equivalent to $Y8 $X8. if
; 2 parameters are passed, they are read as $YY $XX (8 bits each).
;
; param1:	Y-position
; param2:	X-position
.MACRO setcoords
	.db $88
	.IF NARGS == 2
		.db \1
		.db \2
	.ELSE
		.db (\1&$f0) | 8
		.db ((\1&$0f)<<4) | 8
	.ENDIF
.ENDM

; @param angle New angle
.MACRO setangle
	.db $89 \1
.ENDM

; Make an object face link.
.MACRO turntofacelink
	.db $8a
.ENDM

; @param speed Value for Interaction.speed (see constants/objectSpeeds.s)
.MACRO setspeed
	.db $8b \1
.ENDM

; Writes the given value to Interaction.counter2. Then, the script holds execution for
; that many frames while the object's speed is applied.
;
; @param1	The number of frames to wait. (for some reason this parameter is
;		optional? If it's not passed, it just waits for counter2 to reach 0...)
.MACRO applyspeed
	.IF NARGS == 1
		.db $8c \1
	.ELSE
		.db $d8
	.ENDIF
.ENDM

; Set an object's collision box.
; param1:	Y collision radius
; param2:	X collision radius
.MACRO setcollisionradii
	.db $8d \1 \2
.ENDM

; Write a byte to the object's memory. Script execution resumes next frame.
; param1:	Low byte of address to set (should be Interaction.something)
; param2:	Byte value to write to the address
.MACRO writeobjectbyte
	.db $8e \1 \2

	m_verify_object_byte \1 "writeobjectbyte"
.ENDM

; Calls interactionSetAnimation with the specified value.
; param1:	Animation index
.MACRO setanimation
	.db $8f \1

	.if \1 >= $fe
		.PRINTT "SCRIPT ERROR: argument to 'setanimation' too high.\n"
		.FAIL
	.endif
.ENDM

; Calls interactionSetAnimation using one of the interaction's variables.
.MACRO setanimationfromobjectbyte
	.db $8f, $fe, \1

	m_verify_object_byte \1 "setanimationfromobjectbyte"
.ENDM

; Sets the interaction's animation based on its angle.
.MACRO setanimationfromangle
	.db $8f, $ff
.ENDM

; Compares the interaction's x-position to link's x-position and stores the
; result in the given address (result is $00 if this.x >= link.x, otherwise
; it's $01)
; param1:	Low byte of address to store the result
.MACRO cplinkx
	.db $90 \1

	m_verify_object_byte \1 "cplinkx"
.ENDM

; Write a byte to an address in memory.
; param1[16]:	Address to write to
; param2:	Byte to write to the address
.MACRO writememory
	.db $91
	.dw \1
	.db \2
.ENDM

; Bitwise OR a byte with an address in memory.
; param1[16]:	Address to OR with and store result into.
; param2:	Byte to OR with.
.MACRO ormemory
	.db $92
	.dw \1
	.db \2
.ENDM

; Get a random number, store it into an interaction address.
; param1:	Low byte of interaction address to store result into
; param2:	Value to bitwise AND with the random number before storing it.
.MACRO getrandombits
	.db $93
	.db \1 \2

	m_verify_object_byte \1 "getrandombits"
.ENDM

; Add a byte with an interaction address.
; param1:	Low byte of interaction address to add with.
; param2:	Value to add.
.MACRO addobjectbyte
	.db $94
	.db \1 \2

	m_verify_object_byte \1 "addobjectbyte"
.ENDM

; Sets the interaction's vertical speed (z axis).
; param1[16]:	Vertical speed
.MACRO setzspeed
	.db $95
	.dw \1
.ENDM

; Sets the object's moving direction and matching animation.
; param1:	The object's angle ($00-$1f)
.MACRO setangleandanimation
	.db $96
	.db \1
.ENDM

; Set Interaction.textID to the given value and jump to a generic npc script; the object
; will display text when A is pressed. Only use this when Interaction.useTextID is zero
; (default); otherwise use rungenericnpclowindex.
;
; param1[16]:	The text index to show when talked to
.MACRO rungenericnpc
	.db $97
	.db \1>>8 \1&$ff
.ENDM

; Set Interaction.textID to the given value. Only use this when Interaction.useTextID is
; nonzero; otherwise use rungenericnpc.
;
; param1:	The text index to show when talked to 
.MACRO rungenericnpclowindex
	.db $97
	.db \1
.ENDM

; Displays the text index given. Only use this when Interaction.useTextID is zero
; (default); otherwise use showtextlowindex.
;
; param1[16]:	The low byte of the text index to display.
.MACRO showtext
	.db $98
	.db \1>>8 \1&$ff
.ENDM

; Displays the text index with high byte [Interaction.textID] and the low
; byte given. Only use this when Interaction.useTextID is nonzero; otherwise
; use showtext.
;
; param1:	The low byte of the text index to display.
.MACRO showtextlowindex
	.db $98
	.db \1
.ENDM


; Hold script execution until text is no longer being displayed.
.MACRO checktext
	.db $99
.ENDM

; Displays the text index given, being non-exitable by user input. Only use this when
; Interaction.useTextID is zero (default); otherwise use showtextnonexitablelowindex.
;
; param1[16]:	The text index to display.
.MACRO showtextnonexitable
	.db $9a
	.db \1>>8 \1&$ff
.ENDM

; Displays the text index given, being non-exitable by user input. Only use this when
; Interaction.useTextID is zero (default); otherwise use showtextnonexitablelowindex.
;
; param1:	The low byte of the text index to display.
.MACRO showtextnonexitablelowindex
	.db $9a
	.db \1
.ENDM

; Adds the object to wAButtonSensitiveObjectList; this allows the "checkabutton" command
; to work.
.MACRO makeabuttonsensitive
	.db $9b
.ENDM

; Set the Interaction.textID variable. This text ID can later be shown with
; showloadedtext.
;
; param1[16]	Text ID
.MACRO settextid
	.db $9c
	.dw \1
.ENDM

; Show the text id corresponding to the Interaction.textID variable (set by "settextid").
.MACRO showloadedtext
	.db $9d
.ENDM

; Hold script execution until the A button is pressed while link is next to the
; interaction. Use to wait for npc dialog, etc.
; You must use either "initcollisions" or "makeabuttonsensitive" before you can use this.
.MACRO checkabutton
	.db $9e
.ENDM

; Shows a certain text id depending if the game is linked or unlinked
; param1: the text to show for unlinked games.
; param2: the text to show for linked games.
.MACRO showtextdifferentforlinked
	.db $9f
	.db \1>>8 \1&$ff \2&$ff

	.if \1>>8 != \2>>8
		.PRINTT "SCRIPT ERROR: in 'showtextdifferentforlinked' opcode, the text indices were in different groups.\n"
		.FAIL
	.endif
.ENDM

; Holds execution until the given bit of address $cfc0 is set.
; param1:	Bit to check (0-7)
.MACRO checkcfc0bit
	.db $a0 | \1
.ENDM

; Xors the given bit in address $cfc0.
; param1:	Bit to xor (0-7)
.MACRO xorcfc0bit
	.db $a8 | \1
.ENDM

; Jumps to the specified address if the specified flag(s) in the room are set.
; When the script is loaded into wBigBuffer, this will only work if the
; destination to jump to is already loaded into the buffer.
;
; param1:	Value to AND with the room flags for the check
; param2[16]:	Destination address to jump to if the result is nonzero
.MACRO jumpifroomflagset
	.db $b0 \1
	.dw \2
.ENDM

; OR the room flags with the given value. Used to mark if an event has occured,
; and if so, you can skip it with the "jumpifroomflagset" opcode.
.MACRO orroomflag
	.db $b1 \1
.ENDM

; B2: no command

; Jumps to the specified address if a specified address ($c6xx) AND the given
; value is nonzero.
; When the script is loaded into wBigBuffer, this will only work if the
; destination to jump to is already loaded into the buffer.
;
; param1:	The low byte of the address to read (ie. if address is "$75",
;		corresponding to "<wNumSmallKeys", it will read from $c675.)
; param2:	Value to AND with the address for the check
; param3[16]:	Destination address to jump to if the result is nonzero
.MACRO jumpifc6xxset
	.db $b3
	.db \1 \2
	.dw \3
.ENDM

; Write the given value to an address at $c6xx.
; param1:	Low byte of the address to write to
; param2:	Value to write to the address
.MACRO writec6xx
	.db $b4
	.db \1 \2
.ENDM

; Jump to the specified address if the given global flag is set.
; A list of global flags can be found in "constants/globalFlags.s".
;
; param1:	The global flag to check
; param2[16]:	Destination address to jump to if the flag is set
.MACRO jumpifglobalflagset
	.db $b5 \1
	.dw \2
.ENDM

; Sets the specified global flag.
; A list of global flags can be found in "constants/globalFlags.s".
;
; param1:	The global flag to set
.MACRO setglobalflag
	.db $b6 \1
.ENDM

; Unsets the specified global flag.
; A list of global flags can be found in "constants/globalFlags.s".
;
; param1:	The global flag to unset
.MACRO unsetglobalflag
	.db $b6 (\1 | $80)
.ENDM

; $B7: no command

; Set the variable wDisabledObjects to $91. Disables Link, items, and enemies?
.MACRO setdisabledobjectsto91
	.db $b8
.ENDM

; Set the variable wDisabledObjects to $00, re-enabling all objects.
.MACRO setdisabledobjectsto00
	.db $b9
.ENDM

; Set the variable wDisabledObjects to $11. Disables Link and items?
.MACRO setdisabledobjectsto11
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
; param1[16]:	Script to call
.MACRO callscript
	.db $c0
	.dw \1
.ENDM

; Return from a script after a callscript command.
.MACRO retscript
	.db $c1
.ENDM

; $C2: no command

; Jump to the specified address if [wSelectedTextOption] equals the given value.
;
; param1:	The value to compare [wSelectedTextOption] with.
; param2[16]:	Destination address to jump to if the values are equal.
.MACRO jumpiftextoptioneq
	.db $c3
	.db \1
	.dw \2
.ENDM

; Jump to the specified address unconditionally.
; The only advantage of this over jump2byte is it can jump to ram, but that's dubious...
; The actual game doesn't use it.
;
; param1:	Address to jump to.
.MACRO jumpalways
	.db $c4
	.dw \1
.ENDM

; $C5: no command

; Uses a byte in the object's memory as an index for a jump table immediately after the
; opcode.  After this opcode you can do as many .dw statements and you like, each
; indicating an index's location to jump to.
;
; param1:	Low byte of the address to use as the index for the table
.MACRO jumptable_objectbyte
	.db $c6 \1

	m_verify_object_byte \1 "jumptable_objectbyte"
.ENDM

; Jump to somewhere if the given memory address AND the given value is nonzero.
; param1[16]:	Address to AND with
; param2:	Byte to AND the address with
; param3:	Address to jump to if the result is nonzreo
.MACRO jumpifmemoryset
	.db $c7
	.dw \1
	.db \2
	.dw \3
.ENDM

; Jump somewhere if the trade item equals a certain value.
;
; param1:	Value to check for the trade item. (This is subtracted by one before the
;		comparison?)
; param2[16]:	Destination to jump to
.MACRO jumpiftradeitemeq
	.db $c8 \1
	.dw \2
.ENDM

; Jump somewhere if (wNumEnemies) is zero.
; param1[16]:	Destination to jump to
.MACRO jumpifnoenemies
	.db $c9
	.dw \1
.ENDM

; Jump somewhere if one of link's variables (d0xx) does not equal the given
; value.
; param1:	The low byte of the address to compare with (d0xx)
; param2:	Value to compare with
; param3[16]:	Destination to jump to
.MACRO jumpiflinkvariableneq
	.db $ca
	.db \1 \2
	.dw \3
.ENDM

; Jump somewhere if the given memory address equals a certain value.
; param1[16]:	Memory address to check
; param2:	Value to compare with memory address
; param3:	Address to jump to if values are equal
.MACRO jumpifmemoryeq
	.db $cb
	.dw \1
	.db \2
	.dw \3
.ENDM

; Jump somewhere if the given interaction byte equals a certain value.
; param1:	Interaction byte to check
; param2:	Value to compare with memory address
; param3:	Address to jump to
.MACRO jumpifobjectbyteeq
	.db $cc
	.db \1
	.db \2
	.dw \3

	m_verify_object_byte \1 "jumpifobjectbyteeq"
.ENDM

; Stops execution of the script if the room's item flag (aka ROOMFLAG_ITEM aka bit 5) is set.
.MACRO stopifitemflagset
	.db $cd
.ENDM

; Stops execution of the script if ROOMFLAG_40 is set for this room.
.MACRO stopifroomflag40set
	.db $ce
.ENDM

; Stops execution of the script if ROOMFLAG_80 is set for this room.
.MACRO stopifroomflag80set
	.db $cf
.ENDM

; Holds execution until link and the interaction collide, and link is on the ground. It
; may be necessary to do "initcollisions" before this.
.MACRO checkcollidedwithlink_onground
	.db $d0
.ENDM

; Holds execution until the palettes are done fading in or out.
.MACRO checkpalettefadedone
	.db $d1
.ENDM

; Holds execution until [wNumEnemies] equals zero.
.MACRO checknoenemies
	.db $d2
.ENDM

; Holds execution until a "flag" (a bit in memory) is set. Uses the checkFlag
; function.
; param1:	The index of the flag to check (not a bitmask)
; param2:	The starting address of the flags (ie wGlobalFlags)
.MACRO checkflagset
	.db $d3
	.db \1
	.dw \2
.ENDM

; Holds execution until the given byte in the object's memory equals the given value.
;
; param1:	The low byte of the address to check (xx in $dyxx)
; param2:	The value to check for equality with
.MACRO checkobjectbyteeq
	.db $d4
	.db \1 \2

	m_verify_object_byte \1 "checkobjectbyteeq"
.ENDM

; Holds execution until the given memory address equals the given value.
;
; param1:	The address to check
; param2:	The value to check for equality with
.MACRO checkmemoryeq
	.db $d5
	.dw \1
	.db \2
.ENDM

; Holds execution until link and the interaction are not colliding. You may
; need to do "initcollisions" before this.
.MACRO checknotcollidedwithlink_ignorez
	.db $d6
.ENDM

; Sets Interaction.counter1 to the given value. Script execution holds until it reaches
; zero.
; For custom scripts, use the "wait" pseudo-opcode instead of this.
.MACRO setcounter1
	.db $d7 \1
.ENDM

; Command $d8: see applyspeed

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
; respective Z positions. It may be necessary to do "initcollisions" before
; this.
.MACRO checkcollidedwithlink_ignorez
	.db $db
.ENDM

; $DC: no command

; Spawn an item at the interaction's coordinates.
; param1:	High byte of ID (see constants/treasure.s)
; param2:	Low byte of ID
.MACRO spawnitem
	.db $dd
	.if NARGS == 1
		.db \1>>8 \1&$ff
	.else
		.db \1 \2
	.endif
.ENDM

; Spawn an item at link's coordinates. In most cases this will cause link to
; grab it instantly.
;
; (TODO: only allow two parameters here, not one. Reduces confusion.
;
; param1:	High byte of ID (see constants/treasure.s)
; param2:	Low byte of ID
.MACRO giveitem
	.db $de
	.if NARGS == 1
		.db \1>>8 \1&$ff
	.else
		.db \1 \2
	.endif
.ENDM

; Jump if an item is obtained (see constants/treasure.s).
; param1:	The item to check
; param2[16]:	Where to jump to
.MACRO jumpifitemobtained
	.db $df \1
	.dw \2
.ENDM

; Call an assembly function in bank $15 at the specified address.
;
; param1:	Address of the assembly to run (bank $15)
; param2[opt]:	Value to set the 'a' and 'e' registers to before calling the asm
.MACRO asm15
	.IF NARGS == 1
		.db $e0
		.dw \1
	.ELSE
		.db $e1
		.dw \1
		.db \2
	.ENDIF
.ENDM

; Create a puff at this interaction's position. Script execution resumes next frame.
.MACRO createpuff
	.db $e2
.ENDM

; Play the sound effect specified (see constants/music.s)
; param1:	The sound effect to play
.MACRO playsound
	.db $e3
	.db \1
.ENDM

; Set the music (see constants/music.s)
; param1:	The music to play.
.MACRO setmusic
	.db $e4
	.db \1
.ENDM

.MACRO resetmusic
	.db $e4 $ff
.ENDM

; Set wDisabledObjects to the specified value.
; param1:	The value to write to wDisabledObjects.
.MACRO setdisabledobjects
	.db $e5
	.db \1
.ENDM

; Spawn an enemy at this interaction's position.
; param1:	The ID of the enemy to spawn (see constants/enemyTypes.s)
; param2:	The Subid of the enemy to spawn
.MACRO spawnenemyhere
	.db $e6
	.if NARGS == 1
		.db \1>>8 \1&$ff
	.else
		.db \1 \2
	.endif
.ENDM

; Set the tile on the map at the specified position to the specified value.
; param1:	The position to change (YX)
; param2:	The tile index to set it to
.MACRO settileat
	.db $e7
	.db \1 \2
.ENDM

; Set the tile at this interaction's position to the specified value.
; param1:	The tile index to set it to
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
; param1:	The value to set wScreenShakeCounterX to.
.MACRO shakescreen
	.db $ea
	.db \1
.ENDM

; Initialize the collisionRadiusY/X variables to $06 and add this object to
; wAButtonSensitiveObjectList, allowing you to use checkabutton.
;
; Equivalent to these two opcodes:
;   setcollisionradii $06 $06
;   makeabuttonsensitive
.MACRO initcollisions
	.db $eb
.ENDM

; Moves an npc a set distance. Use the "setspeed" command prior to this.
; param1:	Number of frames to move
.MACRO moveup
	.db $ec \1
.ENDM
.MACRO moveright
	.db $ed \1
.ENDM
.MACRO movedown
	.db $ee \1
.ENDM
.MACRO moveleft
	.db $ef \1
.ENDM

; Wait for a set number of frames by setting counter1. The parameter passed is not the
; amount of frames to wait, but an index for a table.
;
; For custom scripts, it's recommended to use "wait" instead of this.
;
; param1: Number of frames to wait. The parameter corresponds to these values:
; 		0:  1 frame
; 		1:  4 frames
; 		2:  8 frames
; 		3:  10 frames
; 		4:  15 frames
; 		5:  20 frames
; 		6:  30 frames
; 		7:  40 frames
; 		8:  60 frames
; 		9:  90 frames
; 		10: 120 frames
; 		11: 180 frames
; 		12: 240 frames
.MACRO delay
	.IF \1 > 12
		.PRINTT "SCRIPT ERROR: delay takes a value from $00-$0c.\n"
		.FAIL
	.ENDIF
	.IF \1 < 0
		.PRINTT "SCRIPT ERROR: delay takes a value from $00-$0c.\n"
		.FAIL
	.ENDIF
	.db $f0 + \1
.ENDM


; pseudo-ops

; Alternative to "delay"; takes a frame value as the parameter instead of the arbitrary
; lengths "delay" works with. Falls back to using "setcounter1" if it would take 2 bytes.
; @param frames Number of frames to wait
.MACRO wait
	.if \1 >= 256
		.redefine M_RESULT (-1)
		.rept 13 INDEX M_COUNT
			m_get_delay_value M_COUNT
			m_get_delay_index \1-M_DELAY_VALUE
			.if M_DELAY_INDEX != -1
				.redefine M_RESULT M_DELAY_VALUE
			.endif
		.endr
		.if M_RESULT == -1
			wait 240
			wait \1-240
		.else
			wait M_RESULT
			wait \1-M_RESULT
		.endif

	.else ; \1 < 256
		m_get_delay_index \1

		.if M_DELAY_INDEX != -1
			delay M_DELAY_INDEX
		.else
			setcounter1 \1
		.endif
	.endif
.ENDM

; Helper macros for the above macro
.MACRO m_get_delay_value
	.redefine M_DELAY_VALUE (-1)
	.if \1 == 12
		.redefine M_DELAY_VALUE 240
	.endif
	.if \1 == 11
		.redefine M_DELAY_VALUE 180
	.endif
	.if \1 == 10
		.redefine M_DELAY_VALUE 120
	.endif
	.if \1 == 9
		.redefine M_DELAY_VALUE 90
	.endif
	.if \1 == 8
		.redefine M_DELAY_VALUE 60
	.endif
	.if \1 == 7
		.redefine M_DELAY_VALUE 40
	.endif
	.if \1 == 6
		.redefine M_DELAY_VALUE 30
	.endif
	.if \1 == 5
		.redefine M_DELAY_VALUE 20
	.endif
	.if \1 == 4
		.redefine M_DELAY_VALUE 15
	.endif
	.if \1 == 3
		.redefine M_DELAY_VALUE 10
	.endif
	.if \1 == 2
		.redefine M_DELAY_VALUE 8
	.endif
	.if \1 == 1
		.redefine M_DELAY_VALUE 4
	.endif
	.if \1 == 0
		.redefine M_DELAY_VALUE 1
	.endif
.ENDM
.MACRO m_get_delay_index
	.redefine M_DELAY_INDEX (-1)
	.if \1 == 240
		.redefine M_DELAY_INDEX 12
	.endif
	.if \1 == 180
		.redefine M_DELAY_INDEX 11
	.endif
	.if \1 == 120
		.redefine M_DELAY_INDEX 10
	.endif
	.if \1 == 90
		.redefine M_DELAY_INDEX 9
	.endif
	.if \1 == 60
		.redefine M_DELAY_INDEX 8
	.endif
	.if \1 == 40
		.redefine M_DELAY_INDEX 7
	.endif
	.if \1 == 30
		.redefine M_DELAY_INDEX 6
	.endif
	.if \1 == 20
		.redefine M_DELAY_INDEX 5
	.endif
	.if \1 == 15
		.redefine M_DELAY_INDEX 4
	.endif
	.if \1 == 10
		.redefine M_DELAY_INDEX 3
	.endif
	.if \1 == 8
		.redefine M_DELAY_INDEX 2
	.endif
	.if \1 == 4
		.redefine M_DELAY_INDEX 1
	.endif
	.if \1 == 1
		.redefine M_DELAY_INDEX 0
	.endif
.ENDM

.MACRO writeobjectword
	writeobjectbyte \1,   \2&$ff
	writeobjectbyte \1+1, \2>>$8
.ENDM

; Pseudo-ops from ZOSE

; param1:	Tile position to check
; param2:	Tile index to check for
.MACRO checktile
	checkmemoryeq wRoomLayout+\1 \2
.ENDM

.MACRO maketorcheslightable
	asm15 scriptHlp.makeTorchesLightable
.ENDM

.MACRO createpuffnodelay
	asm15 objectCreatePuff
.ENDM


; Helper macro for validating arguments that take an interaction byte
.MACRO m_verify_object_byte
	.redefine M_TMP 0

	.if \1 < $40
		.redefine M_TMP 1
	.endif
	.if \1 >= $80
		.redefine M_TMP 1
	.endif

	.if M_TMP == 1
		.PRINTT "SCRIPT ERROR: argument to '"
		.PRINTT \2
		.PRINTT "' ($"
		.PRINTV HEX \1
		.PRINTT ") is out of range. Should be $40-$7f.\n"
		.FAIL
	.endif

	.undefine M_TMP
.ENDM
