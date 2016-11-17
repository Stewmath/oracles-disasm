; Macro which allows graphics data to cross over banks
.macro m_GfxData
	.FOPEN "build/gfx/\1.cmp" m_GfxDataFile
	.FSIZE m_GfxDataFile SIZE
	.FCLOSE m_GfxDataFile
	.REDEFINE SIZE SIZE-1

	.IF DATA_ADDR + SIZE >= $8000
		.REDEFINE DATA_READAMOUNT $8000-DATA_ADDR
		\1: .incbin "build/gfx/\1.cmp" SKIP 1 READ DATA_READAMOUNT
		.REDEFINE DATA_BANK DATA_BANK+1
		.BANK DATA_BANK SLOT 1
		.ORGA $4000
		.IF DATA_READAMOUNT < SIZE
			.incbin "build/gfx/\1.cmp" SKIP DATA_READAMOUNT+1
		.ENDIF
		.REDEFINE DATA_ADDR $4000 + SIZE-DATA_READAMOUNT
	.ELSE
		\1: .incbin "build/gfx//\1.cmp" SKIP 1
		.REDEFINE DATA_ADDR DATA_ADDR + SIZE
	.ENDIF

	.UNDEFINE SIZE
.endm

; Same as last, but doesn't support inter-bank stuff, so DATA_ADDR and DATA_BANK
; don't need to be defined beforehand.
.macro m_GfxDataSimple
        .IF NARGS == 2
                \1: .incbin "build/gfx//\1.cmp" SKIP 1+\2
        .ELSE
                \1: .incbin "build/gfx//\1.cmp" SKIP 1
        .ENDIF
.endm

; Define graphics header, arguments: name, dest, size (and continue bit)
; Optional 4th argument overrides the compression mode
.macro m_GfxHeaderForceMode
	.FOPEN "build/gfx/\1.cmp" m_GfxHeaderFile
	.FREAD m_GfxHeaderFile mode

	.IF NARGS == 4
		; Mode override
		.db :\1 | (\4<<6)
	.ELSE
		.db :\1 | (mode<<6)
	.ENDIF

	dwbe \1

	; If given bank number 0 for an address in d000-dfff, assume that
	; a label was passed (since bank 0 in that area is basically invalid)
	.if (\2&$f00f) == $d000
		dwbe \2|:\2
	.else
		dwbe \2
	.endif

	.db \3

	.undefine mode
	.FCLOSE m_GfxHeaderFile
.endm

; Define graphics header with optional 4th argument to skip into part of the graphics
.macro m_GfxHeader
	.FOPEN "build/gfx/\1.cmp" m_GfxHeaderFile
	.FREAD m_GfxHeaderFile mode

	.db :\1 | (mode<<6)
	.IF NARGS >= 4
		dwbe \1+\4
	.ELSE
		dwbe \1
	.ENDIF

	; If given bank number 0 for an address in d000-dfff, assume that
	; a label was passed (since bank 0 in that area is basically invalid)
	.if (\2&$f00f) == $d000
		dwbe \2|:\2
	.else
		dwbe \2
	.endif

	.db \3

	.undefine mode
	.FCLOSE m_GfxHeaderFile
.endm

; Define graphics header with the source being from RAM
.macro m_GfxHeaderRam
	.db \1
	dwbe \2
	dwbe \3
	.db \4
.endm

; Define npc header
; 1st argument name
; 2nd argument is 7th bit of address for an unknown purpose
; Optional 3rd argument skips into part of the graphics
.macro m_NpcGfxHeader
	.FOPEN "build/gfx/\1.cmp" m_GfxHeaderFile
	.FREAD m_GfxHeaderFile mode

	.db :\1 | (mode<<6)
	.IF NARGS >= 3
		dwbe \1+\3 | (\2<<8)
	.ELSE
		dwbe \1 | (\2<<8)
	.ENDIF

	.undefine mode
	.FCLOSE m_GfxHeaderFile
.endm
