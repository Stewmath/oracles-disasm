.MACRO db_zeropage
	.define \1 \2
	.define \1_l (\2&$ff)
.ENDM

	; 8b-91 - temp vars?

	db_zeropage hRng1			$ff94
	db_zeropage hRng2			$ff95

	db_zeropage hActiveBank			$ff97

	db_zeropage hLcdInterruptBehaviour	$ff9b

	db_zeropage hVBlankFunctionQueueTail	$ffa5
	db_zeropage dirtyBgPalettes		$ffa6
	db_zeropage dirtySprPalettes		$ffa7
