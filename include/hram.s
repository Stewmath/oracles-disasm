.MACRO db_zeropage
	.define \1 \2
.ENDM

	; 8b-91 - temp vars?

	db_zeropage hRng1			$ff94
	db_zeropage hRng2			$ff95

	db_zeropage hActiveBank			$ff97

	db_zeropage hActiveThread               $ff9e

	db_zeropage hLcdInterruptBehaviour	$ff9b

	db_zeropage hVBlankFunctionQueueTail	$ffa5
	db_zeropage hDirtyBgPalettes		$ffa6
	db_zeropage hDirtySprPalettes		$ffa7

	db_zeropage hScreenScrollY		$ffaa
	db_zeropage hScreenScrollX		$ffac

	; Either $00, $40, $80, or $c0
	db_zeropage hActiveObjectType		$ffae

	; Tentative name
	db_zeropage hSerialInterruptBehaviour	$ffba
	; Serial interrupt sets to 1 if a byte has been read
	db_zeropage hSerialRead			$ffbb
	; Value of byte from R_SB
	db_zeropage hSerialByte			$ffbc
