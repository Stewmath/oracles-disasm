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

; Macro which allows data to cross over banks, used for map layout data.
; Doesn't support more than 1 bank crossing at a time
; Must have DATA_ADDR and DATA_BANK defined before use.
; ARG 1: name
.macro m_RoomLayoutData
	.FOPEN "build/map/\1.cmp" m_DataFile
	.FSIZE m_DataFile SIZE
	.FCLOSE m_DataFile
	.REDEFINE SIZE SIZE-1

	.IF DATA_ADDR + SIZE >= $8000
		.REDEFINE DATA_READAMOUNT $8000-DATA_ADDR
		\1: .incbin "build/map/\1.cmp" SKIP 1 READ DATA_READAMOUNT
		.REDEFINE DATA_BANK DATA_BANK+1
		.BANK DATA_BANK SLOT 1
		.ORGA $4000
                .IF DATA_READAMOUNT < SIZE
                        .incbin "build/map/\1.cmp" SKIP DATA_READAMOUNT+1
                .ENDIF
		.REDEFINE DATA_ADDR $4000 + SIZE-DATA_READAMOUNT
	.ELSE
		\1: .incbin "build/map/\1.cmp" SKIP 1
		.REDEFINE DATA_ADDR DATA_ADDR + SIZE
	.ENDIF

	.UNDEFINE SIZE
.endm

; Pointer to room data defined with m_RoomLayoutData
; ARG 1: name
; ARG 2: relative offset
.macro m_RoomLayoutPointer
	.FOPEN "build/map/\1.cmp" m_DataFile
	.FREAD m_DataFile mode
	.FCLOSE m_DataFile

        .IF mode == 3
                ; Mode 3 is dictionary compression, for large rooms, handled fairly differently
                .dw ((:\1*$4000)+(\1&$3fff) - ((:\2*$4000)+(\2&$3fff))) + $200
        .ELSE
                .dw ((:\1*$4000)+(\1&$3fff) - ((:\2*$4000)+(\2&$3fff))) | (mode<<14)
        .ENDIF

	.undefine mode
.endm
