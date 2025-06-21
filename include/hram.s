.enum $ff80 export
	hOamFunc			dsb $a	; $ff80

	; General-purpose variables
	hFF8A				db	; $ff8a
	hFF8B				db	; $ff8b
	hFF8C				db	; $ff8c
	hFF8D				db	; $ff8d
	hFF8E				db	; $ff8e
	hFF8F				db	; $ff8f
	hFF90				db	; $ff90
	hFF91				db	; $ff91
	hFF92				db	; $ff92
	hFF93				db	; $ff93

	hRng1				db	; $ff94
	hRng2				db	; $ff95

	; $00 for classic gb, $01 for gbc, $ff for gba
	hGameboyType			db	; $ff96

	hRomBank			db	; $ff97

.ifdef ROM_AGES
	hScriptAddressL			db	; $ff98
	hScriptAddressH			db	; $ff99
.endif


	; When gameboy is initialized, hram is cleared from here to "hramEnd".


	hActiveFileSlot			db	; $ff9a/$ff98

	; 0: set SCX based on values in wBigBuffer at each hblank
	; 1: set SCY based on values in wBigBuffer at each hblank
	; 2: ?
	; 3: ?
	; 4: Subrosia pirate ship cutscene?
	; 5: Ring menu
	; 6: Seasons dragon onox fight?
	hLcdInterruptBehaviour		db	; $ff9b/$ff99

	; This is a counter for how many times the LCD interrupt has been triggered this
	; frame (used when hLcdInterruptBehaviour is 2 or higher).
	hLcdInterruptCounter		db	; $ff9c/$ff9a

	; Copied to hLcdInterruptBehaviour at vblank, to avoid anomolies mid-frame.
	hNextLcdInterruptBehaviour	db	; $ff9d/$ff9b

	hActiveThread			db	; $ff9e/$ff9c

	; Where to put the next OAM object (low byte for wOam)
	hOamTail			db	; $ff9f/$ff9d

	; Keeps track of how many bytes in wTerrainEffectsBuffer are used.
	hTerrainEffectsBufferUsedSize	db	; $ffa0/$ff9e

	; These counters keep track of how many objects of each "priority" are
	; displayed. Each caps at $10. The lower the priority, the more objects
	; it's displayed on top of.
	hObjectPriority0Counter		db	; $ffa1/$ff9f
	hObjectPriority1Counter		db	; $ffa2/$ffa0
	hObjectPriority2Counter		db	; $ffa3/$ffa1
	hObjectPriority3Counter		db	; $ffa4/$ffa2

	hVBlankFunctionQueueTail	db	; $ffa5/$ffa3
	hDirtyBgPalettes		db	; $ffa6/$ffa4
	hDirtySprPalettes		db	; $ffa7/$ffa5

	; If a bit is set here, the corresponding palette is loaded from
	; w2FadingBgPalettes or w2FadingSprPalettes; otherwise, it's loaded from
	; w2TilesetBgPalettes or w2TilesetSprPalettes.
	hBgPaletteSources		db	; $ffa8/$ffa6
	hSprPaletteSources		db	; $ffa9/$ffa7

	; These are each 16 bits? (not subpixel format)
	hCameraY			dw	; $ffaa/$ffa8
	hCameraX			dw	; $ffac/$ffaa

	; Either $00, $40, $80, or $c0
	hActiveObjectType		db	; $ffae/$ffac
	; Number from $d0 to $df
	hActiveObject			db	; $ffaf/$ffad

	; The position enemies try to attack. Unaffected by scent seeds?
	hEnemyTargetY			db	; $ffb0/$ffae
	hEnemyTargetX			db	; $ffb1/$ffaf

	; $ffb2/b3: Y/X values, also relating to enemies. This is either Link's or the
	; scent seed's position.
	hFFB2				db	; $ffb2/$ffb0
	hFFB3				db	; $ffb3/$ffb1

	hMusicQueueHead			db	; $ffb4/$ffb2
	hMusicQueueTail			db	; $ffb5/$ffb3

	; 0-3; when bit 7 is set, volume needs updating.
	hMusicVolume			db	; $ffb6/$ffb4

	; ffb7: if bit 3 is set, playSound doesn't do anything.
	;       if bit 0 is set, the game is currently running sound routines?
	hFFB7				db	; $ffb7/$ffb5

	; Used in timer interrupt
	hFFB8				db	; $ffb8/$ffb6

	; This is 0 until the capcom screen is over
	hIntroInputsEnabled		db	; $ffb9/$ffb7

	; If this is nonzero then this gameboy uses an external clock (is the "slave").
	; In JP region, this is $d0 or $d1; in the US region, it's $e0 or $e1.
	hSerialInterruptBehaviour	db	; $ffba/$ffb8
	; Serial interrupt sets this to 1 if a byte has been read
	hReceivedSerialByte		db	; $ffbb/$ffb9
	; Value of byte from R_SB
	hSerialByte			db	; $ffbc/$ffba

	hFFBD				db	; $ffbd/$ffbb

	; This variable is the link "mode" (what it's doing right now).
	; $01: either ring link or ring fortune
	; $02: either ring link or ring fortune
	; $03: ready to receive a link (titlescreen or "can't run on DMG" screen)
	; $04: "game link"
	hFFBE				db	; $ffbe/$ffbc

	; This keeps track of the "state" corresponding to the above link mode.
	hSerialLinkState		db	; $ffbf/$ffbd

	; Marker for end of "normal" hram (memory gets cleared up to here upon game initialization)
	hramEnd			 	.db	; $ffc0/$ffbe
.ende

.enum $ffd8 export
	; =====================================================================
	; Music stuff
	; =====================================================================

	; Can't tell the distinction between these 2
	hSoundDataBaseBank2			db	; $ffd8
	hSoundDataBaseBank			db	; $ffd9

	; Each of these are buffers taking wSoundChannel as an index.
	; This one is 8 bytes (1 byte for each index)
	hSoundChannelBanks			dsb 8	; $ffda
	; This one is 16 bytes (1 word for each index)
	hSoundChannelAddresses			dsw 8	; $ffe2

	hSoundData3				db	; $fff2
.ende
