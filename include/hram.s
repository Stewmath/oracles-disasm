.MACRO db_zeropage
	.define \1 \2
.ENDM

	db_zeropage hOamFunc			$ff80
	db_zeropage hFF8A			$ff8a
	db_zeropage hFF8B			$ff8b
	db_zeropage hFF8C			$ff8c
	db_zeropage hFF8D			$ff8d
	db_zeropage hFF8E			$ff8e
	db_zeropage hFF8F			$ff8f
	db_zeropage hFF90			$ff90
	db_zeropage hFF91			$ff91
	db_zeropage hFF92			$ff92
	db_zeropage hFF93			$ff93

	db_zeropage hRng1			$ff94
	db_zeropage hRng2			$ff95

	; $00 for classic gb, $01 for gbc, $ff for gba
	db_zeropage hGameboyType		$ff96
	db_zeropage hRomBank			$ff97
	; 2 bytes
	db_zeropage hScriptAddressL		$ff98
	db_zeropage hScriptAddressH		$ff99

	db_zeropage hActiveFileSlot		$ff9a
	db_zeropage hLcdInterruptBehaviour	$ff9b

	; $ff9d: copied to hLcdInterruptBehaviour

	db_zeropage hActiveThread		$ff9e

	; Where to put the next OAM object
	db_zeropage hOamTail			$ff9f

	; Keeps track of how many bytes in wTerrainEffectsBuffer are used.
	db_zeropage hTerrainEffectsBufferUsedSize	$ffa0

	; These counters keep track of how many objects of each "priority" are
	; displayed. Each caps at $10. The lower the priority, the more objects
	; it's displayed on top of.
	db_zeropage hObjectPriority0Counter	$ffa1
	db_zeropage hObjectPriority1Counter	$ffa2
	db_zeropage hObjectPriority2Counter	$ffa3
	db_zeropage hObjectPriority3Counter	$ffa4

	db_zeropage hVBlankFunctionQueueTail	$ffa5
	db_zeropage hDirtyBgPalettes		$ffa6
	db_zeropage hDirtySprPalettes		$ffa7

	; These are each 16 bits? (not subpixel format)
	db_zeropage hCameraY			$ffaa
	db_zeropage hCameraX			$ffac

	; Either $00, $40, $80, or $c0
	db_zeropage hActiveObjectType		$ffae
	; Number from $d0 to $df
	db_zeropage hActiveObject		$ffaf

	; The position enemies try to attack
	db_zeropage hEnemyTargetY		$ffb0
	db_zeropage hEnemyTargetX		$ffb1

	; $ffb2/b3: Y/X values, also relating to enemies?

	db_zeropage hMusicQueueHead		$ffb4
	db_zeropage hMusicQueueTail		$ffb5

	; 0-3; when bit 7 is set, volume needs updating.
	db_zeropage hMusicVolume		$ffb6

	; ffb7: if bit 3 is set, playSound doesn't do anything
	db_zeropage hFFB7			$ffb7

	; Used in timer interrupt
	db_zeropage hFFB8			$ffb8

	; This is 0 until the capcom screen is over
	db_zeropage hIntroInputsEnabled		$ffb9

	; Tentative name
	db_zeropage hSerialInterruptBehaviour	$ffba
	; Serial interrupt sets to 1 if a byte has been read
	db_zeropage hSerialRead			$ffbb
	; Value of byte from R_SB
	db_zeropage hSerialByte			$ffbc

	; Everything after this point might be just for music?
	.define hramEnd			 $ffc0

	; Can't tell the distinction between these 2
	db_zeropage hSoundDataBaseBank2		$ffd8
	db_zeropage hSoundDataBaseBank		$ffd9

	; Each of these are buffers taking wSoundChannel as an index.
	; This one is 8 bytes (1 byte for each index)
	db_zeropage hSoundChannelBanks		$ffda
	; This one is 16 bytes (1 word for each index)
	db_zeropage hSoundChannelAddresses	$ffe2

	db_zeropage hSoundData3			$fff2
