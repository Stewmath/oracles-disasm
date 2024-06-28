; Incbin gfx data, can cross over banks. Pass filename without extension as parameter.
.macro m_GfxData
	\1:
	m_IncbinCrossBankData {"{BUILD_DIR}/gfx/\1.cmp"}, 3
.endm

; Same as last, but doesn't support inter-bank stuff, so DATA_ADDR and DATA_BANK
; don't need to be defined beforehand.
.macro m_GfxDataSimple
	.if NARGS == 2
		\1: .incbin {"{BUILD_DIR}/gfx/\1.cmp"} SKIP 3+(\2)
	.else
		\1: .incbin {"{BUILD_DIR}/gfx/\1.cmp"} SKIP 3
	.endif
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

; Same as above but for a unique gfx header.
.macro m_UniqueGfxHeaderStart
	.define \2 (\1) EXPORT
	uniqueGfxHeader{%.2x{\1}}:
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

; Helper macro, defines the size/continue byte for gfx headers. The value for the "continue bit" is
; defined later, either when this is invoked again or when m_GfxHeaderEnd is invoked.
;
; As it's using a define with "\@" in its name, which is the number of times the current macro has
; been called, it's important to not copy/paste this into multiple macros.
.macro m_GfxHeaderContinueHelper
	.assert \1 >= 0 && \1 <= $7f

	; Mark "continue" bit on last defined gfx header entry
	.ifdef CURRENT_GFX_HEADER_INDEX
		.define GFX_HEADER_{CURRENT_GFX_HEADER_INDEX}_CONT $80
	.endif

	; Define size/continue byte for current gfx header entry
	.redefine CURRENT_GFX_HEADER_INDEX \@
	.db (\1) | GFX_HEADER_{CURRENT_GFX_HEADER_INDEX}_CONT
.endm

; Helper macro used for defining other macros with slightly varying parameters. See the other macros
; (ie. m_GfxHeader) for descriptions.
.macro m_GfxHeaderHelper
	.define m_GfxHeaderMode \1
	.shift

	; Read metadata from .cmp file
	.fopen {"{BUILD_DIR}/gfx/\1.cmp"} m_GfxHeaderFile
	.fread m_GfxHeaderFile cmp_mode ; First byte of .cmp file is compression mode
	.fread m_GfxHeaderFile decompressed_size_l ; Bytes 2-3 are the decompressed size
	.fread m_GfxHeaderFile decompressed_size_h
	.fclose m_GfxHeaderFile
	.define decompressed_size (decompressed_size_l | (decompressed_size_h<<8))

	; Byte 1: Source bank number & compression mode
	.if m_GfxHeaderMode == GFX_HEADER_MODE_FORCE
		.db (:\1) | ((\4)<<6)
	.else
		.db (:\1) | (cmp_mode<<6)
	.endif

	; Bytes 2-3: Source address
	.if m_GfxHeaderMode != GFX_HEADER_MODE_FORCE && NARGS >= 4
		dwbe (\1)+(\4)
	.else
		dwbe \1
	.endif

	; Bytes 4-5: Destination address & destination bank
	; If arg 2 (destination) isn't a label, we'll just assume that the bank number is already
	; baked into the parameter being passed.
	.if \?2 == ARG_LABEL || \?2 == ARG_PENDING_CALCULATION
		dwbe (\2)|(:\2)
	.else
		dwbe \2
	.endif

	; If size parameter is not passed, infer it from the file
	.if NARGS < 3
		.define size_byte (decompressed_size / 16) - 1
		.if size_byte < 0 || size_byte >= 0x80
			.fail "GFX file \1 is too large?"
		.endif
	.elif m_GfxHeaderMode == GFX_HEADER_MODE_FORCE
		; Just set the continue bit on these. They're malformed, they're only used once, we
		; don't need to implement this properly.
		.define size_byte ((\3) - 1) | $80
	.else
		.if !((\3) >= 1 && (\3) <= $80)
			.fail "\1: GFX Header size byte must be between $01 and $80, inclusive."
		.endif
		.define size_byte (\3) - 1
	.endif

	; Byte 6: Size / continue bit
	.if m_GfxHeaderMode == GFX_HEADER_MODE_NORMAL
		m_GfxHeaderContinueHelper size_byte
	.else
		.db size_byte
	.endif

	.undefine m_GfxHeaderMode
	.undefine cmp_mode
	.undefine decompressed_size_l
	.undefine decompressed_size_h
	.undefine decompressed_size
	.undefine size_byte
.endm

; Define a gfx header entry (a reference to graphics paired with a destination to load it to).
;
; Whenever this is used, you MUST also use m_GfxHeaderEnd at some point after it!
;
; Arg 1: gfx file (without extension)
; Arg 2: destination (usually vram).
;        Address MUST be a multiple of 16. The lower 4 bits, if present, are the bank number.
; Arg 3 (optional): Size byte. This many bytes times 16 are loaded. Valid values: $01-$80.
;                   If omitted, include the entire file.
; Arg 4 (optional): Skip first X bytes of graphics file.
;                   Will only work with uncompressed graphics.
.macro m_GfxHeader
	.if NARGS == 4
		m_GfxHeaderHelper GFX_HEADER_MODE_NORMAL,\1,\2,\3,\4
	.elif NARGS == 3
		m_GfxHeaderHelper GFX_HEADER_MODE_NORMAL,\1,\2,\3
	.else
		m_GfxHeaderHelper GFX_HEADER_MODE_NORMAL,\1,\2
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
		.shift
	.else
		.db :\1
		dwbe \1
	.endif

	dwbe \2
	m_GfxHeaderContinueHelper (\3) - 1
.endm

; Define object gfx header entry.
;
; Arguments:
;   \1: filename
;   \2 (optional): Set to "1" if this is the end of a "chain" of ObjectGfxHeaders to be loaded.
;                  Defaults to 0.
;   \3 (optional): Skips into part of the graphics (only works if uncompressed)
.macro m_ObjectGfxHeader
	.fopen {"{BUILD_DIR}/gfx/\1.cmp"} m_GfxHeaderFile
	.fread m_GfxHeaderFile mode ; First byte of .cmp file is compression mode
	.fclose m_GfxHeaderFile

	.db (:\1) | (mode<<6)

	.if NARGS == 1
		.define m_ObjectGfxHeader_Cont 0
	.else
		.define m_ObjectGfxHeader_Cont (\2) & 1
	.endif

	.if NARGS >= 3
		dwbe ((\1)+(\3)) | ((m_ObjectGfxHeader_Cont)<<15)
	.else
		dwbe (\1) | ((m_ObjectGfxHeader_Cont)<<15)
	.endif

	.undefine mode
	.undefine m_ObjectGfxHeader_Cont
.endm

; ================================================================================
; Palette macros. Continue bit handled similarly to gfx header macros above.
; ================================================================================

.macro m_PaletteHeaderStart
	.define \2 (\1) EXPORT
	paletteHeader{%.2x{\1}}:
.endm

.macro m_PaletteHeaderHelper
	; Mark "continue" bit on last defined gfx header entry
	.ifdef CURRENT_PALETTE_HEADER_INDEX
		.define PALETTE_HEADER_{CURRENT_PALETTE_HEADER_INDEX}_CONT $80
	.endif

	; Define size/continue byte for current gfx header entry
	.redefine CURRENT_PALETTE_HEADER_INDEX \@
	.db (\1) | PALETTE_HEADER_{CURRENT_PALETTE_HEADER_INDEX}_CONT
.endm

; Macro to define palette headers for the background
; ARG 1: index of first palette to load the data into
; ARG 2: number of palettes to load
; ARG 3: address of palette data
.macro m_PaletteHeaderBg
	m_PaletteHeaderHelper ((\2)-1) | ((\1)<<3)
	.dw \3
.endm

; Macro to define palette headers for sprites
; ARG 1: index of first palette to load the data into
; ARG 2: number of palettes to load
; ARG 3: address of palette data
.macro m_PaletteHeaderSpr
	m_PaletteHeaderHelper ((\2)-1) | ((\1)<<3) | $40
	.dw \3
.endm

.macro m_PaletteHeaderEnd
	.ifdef CURRENT_PALETTE_HEADER_INDEX
		.if NARGS >= 1 ; Set last entry's continue bit
			.define PALETTE_HEADER_{CURRENT_PALETTE_HEADER_INDEX}_CONT, $80
		.else ; Unset last entry's continue bit
			.define PALETTE_HEADER_{CURRENT_PALETTE_HEADER_INDEX}_CONT, $00
		.endif
		.undefine CURRENT_PALETTE_HEADER_INDEX
	.endif
.endm
