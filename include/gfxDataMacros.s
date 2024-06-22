; Macro which allows graphics data to cross over banks
.macro m_GfxData
	.FOPEN {"{BUILD_DIR}/gfx/\1.cmp"} m_GfxDataFile
	.FSIZE m_GfxDataFile SIZE
	.FCLOSE m_GfxDataFile
	.REDEFINE SIZE SIZE-1

	.IF DATA_ADDR + SIZE >= $8000
		.REDEFINE DATA_READAMOUNT $8000-DATA_ADDR
		\1: .incbin {"{BUILD_DIR}/gfx/\1.cmp"} SKIP 1 READ DATA_READAMOUNT
		.REDEFINE DATA_BANK DATA_BANK+1
		.BANK DATA_BANK SLOT 1
		.ORGA $4000
		.IF DATA_READAMOUNT < SIZE
			.incbin {"{BUILD_DIR}/gfx/\1.cmp"} SKIP DATA_READAMOUNT+1
		.ENDIF
		.REDEFINE DATA_ADDR $4000 + SIZE-DATA_READAMOUNT
	.ELSE
		\1: .incbin {"{BUILD_DIR}/gfx//\1.cmp"} SKIP 1
		.REDEFINE DATA_ADDR DATA_ADDR + SIZE
	.ENDIF

	.UNDEFINE SIZE
.endm

; Same as last, but doesn't support inter-bank stuff, so DATA_ADDR and DATA_BANK
; don't need to be defined beforehand.
.macro m_GfxDataSimple
	.IF NARGS == 2
		\1: .incbin {"{BUILD_DIR}/gfx/\1.cmp"} SKIP 1+(\2)
	.ELSE
		\1: .incbin {"{BUILD_DIR}/gfx/\1.cmp"} SKIP 1
	.ENDIF
.endm

; Start of a gfx header. Creates a label at the current position (ie. gfxHeader00:) and an exported
; definition.
; Arguments:
;   \1: Index of gfx header
;   \2: Name of gfx header, resolves to the index when used in code
.macro m_GfxHeaderStart
	.define \2 (\1) EXPORT
	gfxHeader{%.2x{\1}}:
.endm

; Use this at the end of a gfx header definition.
;
; Its actual effect is to ensure the "continue" bit of the previous gfx header entry remains unset,
; so it does not attempt to read any data after this.
;
; Optionally, a gfx header can end with a palette header (see constants/paletteHeaders.s). So this
; macro takes one optional parameter for that. (Unique GFX headers only?)
.macro m_GfxHeaderEnd
	.ifdef CURRENT_GFX_HEADER_INDEX
		.if NARGS >= 1 ; Set last entry's continue bit
			.define GFX_HEADER_{CURRENT_GFX_HEADER_INDEX}_CONT, $80
		.else ; Unset last entry's continue bit
			.define GFX_HEADER_{CURRENT_GFX_HEADER_INDEX}_CONT, $00
		.endif
		.undefine CURRENT_GFX_HEADER_INDEX
	.endif
	.if NARGS >= 1
		.db $00
		.db \1 ; Palette header index
	.endif
.endm

.enum 0
	GFX_HEADER_MODE_NORMAL:	 db
	GFX_HEADER_MODE_ANIM:	db
	GFX_HEADER_MODE_FORCE:	db
.ende

; Helper macro used for defining other macros with slightly different parameters. See the other
; macros (ie. m_GfxHeader) for descriptions.
.macro m_GfxHeaderHelper
	.define m_GfxHeaderMode \1
	.shift

	.if m_GfxHeaderMode == GFX_HEADER_MODE_FORCE
		.db (:\1) | ((\4)<<6)
	.else
		.fopen {"{BUILD_DIR}/gfx/\1.cmp"} m_GfxHeaderFile
		.fread m_GfxHeaderFile mode ; First byte of .cmp file is compression mode
		.fclose m_GfxHeaderFile
		.db (:\1) | (mode<<6)
		.undefine mode
	.endif

	.if m_GfxHeaderMode != GFX_HEADER_MODE_FORCE && NARGS >= 4
		dwbe (\1)+(\4)
	.else
		dwbe \1
	.endif

	.if \?2 == ARG_LABEL || \?2 == ARG_PENDING_CALCULATION
		dwbe (\2)|(:\2)
	.else
		dwbe \2
	.endif

	.if m_GfxHeaderMode == GFX_HEADER_MODE_NORMAL
		; Mark "continue" bit on last defined gfx header entry
		.ifdef CURRENT_GFX_HEADER_INDEX
			.define GFX_HEADER_{CURRENT_GFX_HEADER_INDEX}_CONT $80
		.endif

		.redefine CURRENT_GFX_HEADER_INDEX \@

		.db (\3) | GFX_HEADER_{CURRENT_GFX_HEADER_INDEX}_CONT
	.else
		.db \3
	.endif

	.undefine m_GfxHeaderMode
.endm

; Define gfx header entry with optional 4th argument to skip into part of the graphics.
;
; Whenever this is used, you MUST also use m_GfxHeaderEnd at some point after it!
;
; Arg 1: gfx file (without extension)
; Arg 2: destination (usually vram)
; Arg 3: Size (byte; divided by 16, minus 1)
;        If bit 7 is set, there's another gfx header after this to be read.
; Arg 4: Skip first X bytes of graphics file (optional).
;        Will only work with uncompressed graphics.
.macro m_GfxHeader
	.if NARGS == 4
		m_GfxHeaderHelper GFX_HEADER_MODE_NORMAL,\1,\2,\3,\4
	.else
		m_GfxHeaderHelper GFX_HEADER_MODE_NORMAL,\1,\2,\3
	.endif
.endm

; Identical to above except continue bit is never set. Bypasses the weird system for that which
; makes it simpler in general (and m_GfxHeaderEnd is not required when using it).
.macro m_GfxHeaderAnim
	.if NARGS == 4
		m_GfxHeaderHelper GFX_HEADER_MODE_ANIM,\1,\2,\3,\4
	.else
		m_GfxHeaderHelper GFX_HEADER_MODE_ANIM,\1,\2,\3
	.endif
.endm

; Same as m_GfxHeaderAnim but has a compression mode override as the 4th argument. This really isn't
; important, there's just an unusable gfx header in ages that needs the mode override to be able to
; define it. Obviously, it doesn't do anything useful.
.macro m_GfxHeaderForceMode
	m_GfxHeaderHelper GFX_HEADER_MODE_FORCE,\1,\2,\3,\4
.endm

; Define graphics header with the source being from RAM
; Arg 1: RAM bank
; Arg 2: Source (can combine args 1/2 as a label)
; Arg 3: Destination
; Arg 4: Size
.macro m_GfxHeaderRam
	.if NARGS == 4
		.db \1
		dwbe \2
		dwbe \3
		.db \4
	.else
		.db :\1
		dwbe \1
		dwbe \2
		.db \3
	.endif
.endm

; Define object gfx header entry
; 1st argument name
; 2nd argument is 7th bit of address indicating "continuation" (when object specifically
;   request for extra data)
; Optional 3rd argument skips into part of the graphics
.macro m_ObjectGfxHeader
	.FOPEN {"{BUILD_DIR}/gfx/\1.cmp"} m_GfxHeaderFile
	.FREAD m_GfxHeaderFile mode

	.db (:\1) | (mode<<6)
	.IF NARGS >= 3
		dwbe ((\1)+(\3)) | ((\2)<<8)
	.ELSE
		dwbe (\1) | ((\2)<<8)
	.ENDIF

	.undefine mode
	.FCLOSE m_GfxHeaderFile
.endm
