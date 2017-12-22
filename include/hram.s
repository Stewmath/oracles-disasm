
.enum $ff80
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

	hScriptAddressL			db	; $ff98
	hScriptAddressH			db	; $ff99


	; When gameboy is initialized, hram is cleared from here to "hramEnd".


	hActiveFileSlot			db	; $ff9a

	; 0: set SCX based on values in wBigBuffer at each hblank
	; 1: set SCY based on values in wBigBuffer at each hblank
	; 2+: ?
	; 5: used for ring menu
	hLcdInterruptBehaviour		db	; $ff9b

	; This is a counter for how many times the LCD interrupt has been triggered this
	; frame (used when hLcdInterruptBehaviour is 2 or higher).
	hLcdInterruptCounter				db	; $ff9c

	; Copied to hLcdInterruptBehaviour at vblank, to avoid anomolies mid-frame.
	hNextLcdInterruptBehaviour	db	; $ff9d

	hActiveThread			db	; $ff9e

	; Where to put the next OAM object (low byte for wOam)
	hOamTail			db	; $ff9f/$ff9d

	; Keeps track of how many bytes in wTerrainEffectsBuffer are used.
	hTerrainEffectsBufferUsedSize	db	; $ffa0

	; These counters keep track of how many objects of each "priority" are
	; displayed. Each caps at $10. The lower the priority, the more objects
	; it's displayed on top of.
	hObjectPriority0Counter		db	; $ffa1
	hObjectPriority1Counter		db	; $ffa2
	hObjectPriority2Counter		db	; $ffa3
	hObjectPriority3Counter		db	; $ffa4

	hVBlankFunctionQueueTail	db	; $ffa5
	hDirtyBgPalettes		db	; $ffa6
	hDirtySprPalettes		db	; $ffa7

	; If a bit is set here, the corresponding palette is loaded from
	; w2FadingBgPalettes or w2FadingSprPalettes; otherwise, it's loaded from
	; w2AreaBgPalettes or w2AreaSprPalettes.
	hBgPaletteSources			db	; $ffa8
	hSprPaletteSources			db	; $ffa9

	; These are each 16 bits? (not subpixel format)
	hCameraY			dw	; $ffaa
	hCameraX			dw	; $ffac

	; Either $00, $40, $80, or $c0
	hActiveObjectType		db	; $ffae
	; Number from $d0 to $df
	hActiveObject			db	; $ffaf

	; The position enemies try to attack
	hEnemyTargetY			db	; $ffb0
	hEnemyTargetX			db	; $ffb1

	; $ffb2/b3: Y/X values, also relating to enemies; scent seed's position?
	hFFB2				db	; $ffb2
	hFFB3				db	; $ffb3

	hMusicQueueHead			db	; $ffb4
	hMusicQueueTail			db	; $ffb5

	; 0-3; when bit 7 is set, volume needs updating.
	hMusicVolume			db	; $ffb6

	; ffb7: if bit 3 is set, playSound doesn't do anything.
	;       if bit 0 is set, the game is currently running sound routines?
	hFFB7				db	; $ffb7

	; Used in timer interrupt
	hFFB8				db	; $ffb8

	; This is 0 until the capcom screen is over
	hIntroInputsEnabled		db	; $ffb9

	; Tentative name
	hSerialInterruptBehaviour	db	; $ffba
	; Serial interrupt sets to 1 if a byte has been read
	hSerialRead			db	; $ffbb
	; Value of byte from R_SB
	hSerialByte			db	; $ffbc

	hFFBD				db	; $ffbd

	hFFBE				db	; $ffbe
	hFFBF				db	; $ffbf

	; Everything after this point might be just for music?
	hramEnd			 	.db	; $ffc0

	; =====================================================================
	; Music stuff
	; =====================================================================

	hFiller2				dsb $18

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
