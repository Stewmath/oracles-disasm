.MACRO db_zeropage
	.define \1 \2
	.define \1_l (\2&$ff)
.ENDM

	; 8c-8f - temp vars?

	db_zeropage hActiveBank		$ff97
	db_zeropage hDmaQueueTail	$ffa5

	db_zeropage hRng1		$ff94
	db_zeropage hRng2		$ff95
