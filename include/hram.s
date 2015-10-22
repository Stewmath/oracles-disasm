.MACRO db_zeropage
	.define \1 \2
.ENDM

	; 8b-91 - temp vars?

	db_zeropage hRng1			$ff94
	db_zeropage hRng2			$ff95

	; $00 for classic gb, $01 for gbc, $ff for gba
	db_zeropage hGameboyType		$ff96

	db_zeropage hActiveBank			$ff97

	db_zeropage hLcdInterruptBehaviour	$ff9b

	db_zeropage hActiveThread               $ff9e

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

	db_zeropage hScreenScrollY		$ffaa
	db_zeropage hScreenScrollX		$ffac

	; Either $00, $40, $80, or $c0
	db_zeropage hActiveObjectType		$ffae
	; Number from $d0 to $df
	db_zeropage hActiveObject		$ffaf

	; This is 0 until the capcom screen is over
	db_zeropage hIntroInputsEnabled		$ffb9

	; Tentative name
	db_zeropage hSerialInterruptBehaviour	$ffba
	; Serial interrupt sets to 1 if a byte has been read
	db_zeropage hSerialRead			$ffbb
	; Value of byte from R_SB
	db_zeropage hSerialByte			$ffbc
