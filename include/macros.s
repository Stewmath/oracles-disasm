.MACRO callab
	ld hl,\1
	ld e,:\1
	call interBankCall
.ENDM
