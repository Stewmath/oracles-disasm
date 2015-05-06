; Macro which allows graphics data to cross over banks
.macro m_GfxData
	.FOPEN "gfx_precompressed/\1.bin" m_GfxDataFile
	.FSIZE m_GfxDataFile SIZE
	.FCLOSE m_GfxDataFile
	.REDEFINE SIZE SIZE-1

	.IF GFX_ADDR + SIZE > $8000
		.REDEFINE GFX_READAMOUNT $8000-GFX_ADDR
		\1: .incbin "gfx_precompressed/\1.bin" SKIP 1 READ GFX_READAMOUNT
		.REDEFINE GFX_CURBANK GFX_CURBANK+1
		.BANK GFX_CURBANK SLOT 1
		.ORGA $4000
		.incbin "gfx_precompressed/\1.bin" SKIP GFX_READAMOUNT+1
		.REDEFINE GFX_ADDR $4000 + SIZE-GFX_READAMOUNT
	.ELSE
		\1: .incbin "gfx_precompressed/\1.bin" SKIP 1
		.REDEFINE GFX_ADDR GFX_ADDR + SIZE
	.ENDIF

	.UNDEFINE SIZE
.endm

; Define graphics header, arguments: name, dest, size (and continue bit)
.macro m_GfxHeader
	.FOPEN "gfx_precompressed/\1.bin" m_GfxHeaderFile
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

; Define npc header, takes only one argument
.macro m_NpcGfxHeader
	.FOPEN "gfx_precompressed/\1.bin" m_GfxHeaderFile
	.FREAD m_GfxHeaderFile mode

	.db :\1 | (mode<<6)
	.dw \1

	.undefine mode
	.FCLOSE m_GfxHeaderFile
.endm
