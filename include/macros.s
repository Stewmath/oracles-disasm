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

.MACRO dwbe
	.IF NARGS > 3
		.PRINTT "dwbe only supports up to 3 arguments.\n"
		.FAIL
	.ENDIF

	.db \1>>8
	.db \1&$ff

	.IF NARGS > 1
		.db \2>>8
		.db \2&$ff
	.ENDIF
	.IF NARGS > 2
		.db \3>>8
		.db \3&$ff
	.ENDIF
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
	.FOPEN "build/maps/\1.cmp" m_DataFile
	.FSIZE m_DataFile SIZE
	.FCLOSE m_DataFile
	.REDEFINE SIZE SIZE-1

	.IF DATA_ADDR + SIZE >= $8000
		.REDEFINE DATA_READAMOUNT $8000-DATA_ADDR
		\1: .incbin "build/maps/\1.cmp" SKIP 1 READ DATA_READAMOUNT
		.REDEFINE DATA_BANK DATA_BANK+1
		.BANK DATA_BANK SLOT 1
		.ORGA $4000
                .IF DATA_READAMOUNT < SIZE
                        .incbin "build/maps/\1.cmp" SKIP DATA_READAMOUNT+1
                .ENDIF
		.REDEFINE DATA_ADDR $4000 + SIZE-DATA_READAMOUNT
	.ELSE
		\1: .incbin "build/maps/\1.cmp" SKIP 1
		.REDEFINE DATA_ADDR DATA_ADDR + SIZE
	.ENDIF

	.UNDEFINE SIZE
.endm

; Pointer to room data defined with m_RoomLayoutData
; ARG 1: name
; ARG 2: relative offset
.macro m_RoomLayoutPointer
	.FOPEN "build/maps/\1.cmp" m_DataFile
	.FREAD m_DataFile mode
	.FCLOSE m_DataFile

        .IF mode == 3
                ; Mode 3 is dictionary compression, for large rooms, handled fairly differently
                m_RoomLayoutDictPointer \1 \2
        .ELSE
                .dw ((:\1*$4000)+(\1&$3fff) - ((:\2*$4000)+(\2&$3fff))) | (mode<<14)
        .ENDIF

	.undefine mode
.endm

; Pointer to room data with dictionary compression
; This macro doesn't require a corresponding file to exist, just a label
; ARG 1: name
; ARG 2: relative offset
.macro m_RoomLayoutDictPointer
        .dw ((:\1*$4000)+(\1&$3fff) - ((:\2*$4000)+(\2&$3fff))) + $200
.ENDM

; Macro to define palette headers for the background
; ARG 1: index of first palette to load the data into
; ARG 2: number of palettes to load
; ARG 3: address of palette data
; ARG 4: $80 to continue reading palette headers, $00 to stop
.macro m_PaletteHeaderBg
	.db (\2-1) | (\1<<3) | \4
	.dw \3
.ENDM

; Macro to define palette headers for sprites
; ARG 1: index of first palette to load the data into
; ARG 2: number of palettes to load
; ARG 3: address of palette data
; ARG 4: $80 to continue reading palette headers
.macro m_PaletteHeaderSpr
	.db (\2-1) | (\1<<3) | \4 | $40
	.dw \3
.ENDM

; Args 1-3: colors
.macro m_RGB16
	.IF \1 > $1f 
		.PRINTT "m_RGB16: Color components must be between $00 and $1f\n"
		.FAIL
	.ENDIF
	.IF \2 > $1f 
		.PRINTT "m_RGB16: Color components must be between $00 and $1f\n"
		.FAIL
	.ENDIF
	.IF \3 > $1f 
		.PRINTT "m_RGB16: Color components must be between $00 and $1f\n"
		.FAIL
	.ENDIF
	.dw \1 | (\2<<5) | (\3<<10)
.endm

; Args:
; 1 - Label: name
; 2 - Byte: Compression mode ($00 or $80)
.macro m_TilesetDictionaryHeader
	.db :\1 | \2
	dwbe \1
.endm

; Args:
; 1 - Byte: dictionary index (for compression)
; 2 - Label: Compressed data to load
; 3 - Word: Destination (multiple of 0x10)
; 4 - Byte: Destination wram/vram bank
; 5 - Word: Data size in bytes
; 6 - $80 means continue reading headers
.macro m_TilesetHeader
	.IF \3&$f != 0
		.PRINTT "m_TilesetHeader: Destination must be a multiple of $10."
		.FAIL
	.ENDIF

	.db \1
	.db :\2
	dwbe \2
	dwbe \3 | \4
	dwbe \5 | (\6<<8)
.endm

.macro m_TilesetData
	\1: .incbin "build/tilesets/\1.cmp"
.endm
