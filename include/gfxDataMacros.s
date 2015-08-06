; Macro which allows graphics data to cross over banks
.macro m_GfxData
	.FOPEN "build/gfx/\1.cmp" m_GfxDataFile
	.FSIZE m_GfxDataFile SIZE
	.FCLOSE m_GfxDataFile
	.REDEFINE SIZE SIZE-1

	.IF DATA_ADDR + SIZE >= $8000
		.REDEFINE DATA_READAMOUNT $8000-DATA_ADDR
		\1: .incbin "build/gfx//\1.cmp" SKIP 1 READ DATA_READAMOUNT
		.REDEFINE DATA_BANK DATA_BANK+1
		.BANK DATA_BANK SLOT 1
		.ORGA $4000
                .IF DATA_READAMOUNT < SIZE
                        .incbin "build/gfx//\1.cmp" SKIP DATA_READAMOUNT+1
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
	\1: .incbin "build/gfx//\1.cmp" SKIP 1
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
	.db (\1&$ff00)>>8 \1&$ff
	.db (\2&$ff00)>>8 \2&$ff
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
		.db ((\1+\4)&$ff00)>>8
		.db (\1+\4)&$ff
	.ELSE
		.db (\1&$ff00)>>8 \1&$ff
	.ENDIF
	.db (\2&$ff00)>>8 \2&$ff
	.db \3

	.undefine mode
	.FCLOSE m_GfxHeaderFile
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
		.db ((\1+\3)&$ff00)>>8 | \2
		.db (\1+\3)&$ff
	.ELSE
		.db (\1&$ff00)>>8 | \2
		.db \1&$ff
	.ENDIF

	.undefine mode
	.FCLOSE m_GfxHeaderFile
.endm
