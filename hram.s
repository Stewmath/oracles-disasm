.MACRO db_zeropage
	.define \1 \2
	.define \1_l (\2&$ff)
.ENDM


	db_zeropage hActiveBank		$ff97
	db_zeropage hDmaQueueTail	$ffa5
