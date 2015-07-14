; Call Across Bank
.MACRO callab
	ld hl,\1
	ld e,:\1
	call interBankCall
.ENDM

.MACRO rst_jumpTable
	rst $00
.ENDM
.MACRO rst_addAToHl
	rst $10
.ENDM
.MACRO rst_addDoubleIndex
	rst $18
.ENDM

.MACRO m_TextPointer
	.dw (((\1)&$3fff+(:\1)*$4000) - (\3&$3fff+\2*$4000))&$ffff
.ENDM

