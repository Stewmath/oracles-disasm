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

.MACRO 3BytePointer
        .db :\1
        .dw \1
.ENDM
.MACRO Pointer3Byte
        .dw \1
        .db :\1
.ENDM

; ARG 1: actual address
; ARG 2: relative address
.MACRO m_RelativePointer
	.IF NARGS == 2
		.dw (((\1)&$3fff+(:\1)*$4000) - (\2&$3fff+(:\2)*$4000))&$ffff
	.ELSE
		.dw (((\1)&$3fff+(:\1)*$4000) - (\3&$3fff+(:\2)*$4000))&$ffff
	.ENDIF
.ENDM

; Same as above but always use absolute numbers instead of labels
.MACRO m_RelativePointerAbs
	.dw ((\1) - \2)&$ffff
.ENDM

