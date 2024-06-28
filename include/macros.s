; =======================================================================================
; Code macros
; =======================================================================================

; Call Across Bank
.MACRO callab
	.IF NARGS == 1
		ld hl,\1
		ld e,:\1
		call interBankCall
	.ELSE
		ld hl,\2
		ld e,\1
		call interBankCall
	.ENDIF
.ENDM

; Jump Across Bank
.MACRO jpab
	.IF NARGS == 1
		ld hl,\1
		ld e,:\1
		jp interBankCall
	.ELSE
		ld hl,\2
		ld e,\1
		jp interBankCall
	.ENDIF
.ENDM

; lda: same as ld a, except lda $00 optimizes to xor a
.MACRO lda
	.IF \1 == 0
		xor a
	.ELSE
		ld a,\1
	.ENDIF
.ENDM

; cpa: same as cp immediate, except cpa $00 optimizes to or a
.MACRO cpa
	.IF \1 == 0
		or a
	.ELSE
		cp \1
	.ENDIF
.ENDM

.MACRO ldbc
	ld bc, (((\1)&$ff)<<8) | ((\2)&$ff)
.endm
.MACRO ldde
	ld de, (((\1)&$ff)<<8) | ((\2)&$ff)
.endm
.MACRO ldhl
	ld hl, (((\1)&$ff)<<8) | ((\2)&$ff)
.endm

.MACRO setrombank
	ldh (<hRomBank),a
	ld ($2222),a
.ENDM

; Call from bank 0
.MACRO callfrombank0
	.IF NARGS == 1
		ld a,:\1
		ldh (<hRomBank),a
		ld ($2222),a
		call \1
	.ELSE
		ld a,\1
		ldh (<hRomBank),a
		ld ($2222),a
		call \2
	.ENDIF
.ENDM

; Jump from bank 0
.MACRO jpfrombank0
	.IF NARGS == 1
		ld a,:\1
		ldh (<hRomBank),a
		ld ($2222),a
		jp \1
	.ELSE
		ld a,\1
		ldh (<hRomBank),a
		ld ($2222),a
		jp \2
	.ENDIF
.ENDM

; RSTs
.MACRO rst_jumpTable
	rst $00
.ENDM
.MACRO rst_addAToHl
	rst $10
.ENDM
.MACRO rst_addDoubleIndex
	rst $18
.ENDM

; =======================================================================================
; Directive macros
; =======================================================================================

.ifdef BUILD_VANILLA
	.ifndef FORCE_SECTIONS
	.define FORCE_SECTIONS
	.endif
.endif

; These are sections which need to be in specific places. Currently unused since (in theory) all
; labels are now moveable.
.macro m_section_force
	.if NARGS == 1
		.section \1 FORCE
	.else
		.section \1 \2 \3 FORCE
	.endif
.endm

; Sections which could be free (anywhere in the given bank) if you're not
; building the vanilla rom
.macro m_section_free
	.if NARGS == 1
		.ifdef FORCE_SECTIONS
		.section \1 FORCE
		.else
		.section \1 FREE
		.endif
	.else
		.ifdef FORCE_SECTIONS
		.section \1 \2 \3 FORCE
		.else
		.section \1 \2 \3 FREE
		.endif
	.endif
.endm

; Sections which could be superfree (in any bank) if you're not building the
; vanilla rom
.macro m_section_superfree
	.if NARGS == 1
		.ifdef FORCE_SECTIONS
		.section \1 FORCE
		.else
		.section \1 SUPERFREE
		.endif
	.else
		.ifdef FORCE_SECTIONS
		.section \1 \2 \3 FORCE
		.else
		.section \1 \2 \3 SUPERFREE
		.endif
	.endif
.endm

; Include something from the "rooms" directory based on the game
.macro m_IncRoomData
	.ifdef ROM_AGES
		.incbin "rooms/ages/\1"
	.else
		.incbin "rooms/seasons/\1"
	.endif
.endm

; =======================================================================================
; Data macros
; =======================================================================================

; Pointers
.MACRO 3BytePointer
	.db :\1
	.dw \1
.ENDM
.MACRO Pointer3Byte
	.dw \1
	.db :\1
.ENDM

; dwbe = define word big endian
.MACRO dwbe
	.REPT NARGS
		.db (\1)>>8
		.db (\1)&$ff

		.shift
	.ENDR
.ENDM

; Define a byte and a word
.macro dbw
	.db \1
	.dw \2
.endm

; Define a byte and 2 words
.macro dbww
	.db \1
	.dw \2, \3
.endm

; Define 2 bytes and a word
.macro dbbw
	.db \1, \2
	.dw \3
.endm

; Define 2 bytes and 2 words
.macro dbbww
	.db \1, \2
	.dw \3, \4
.endm

; Define a word and a byte
.macro dwb
	.dw \1
	.db \2
.endm

; Define a word a 2 bytes
.macro dwbb
	.dw \1
	.db \2, \3
.endm

; Define a byte, a word, and a byte.
.macro dbwb
	.db \1
	.dw \2
	.db \3
.endm

.MACRO revb
	.define tmp \1
	.define tmp1
	.define tmp2
	.REPT 4 index tmpi
		.redefine tmp1 tmp&(1<<tmpi)
		.redefine tmp2 tmp&($80>>tmpi)
		.redefine tmp tmp&(($1<<tmpi)~$ff)
		.redefine tmp tmp&(($80>>tmpi)~$ff)
		.redefine tmp tmp | (tmp1<<(7-tmpi*2)) | (tmp2>>(7-tmpi*2))
	.ENDR
	.redefine _out tmp

	.undefine tmp
	.undefine tmp1
	.undefine tmp2
.ENDM

; Define a byte, reversing the bits
.MACRO dbrev
	.REPT NARGS
		; Used to use the ".dbm" command here, but it's sometimes causing segfaults in
		; WLA-DX v9.11. Should be fixed in the next release.
		revb \1
		.db _out
		.shift
	.ENDR
.ENDM

; Args 1-3: color components
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
	.dw \1 | ((\2)<<5) | ((\3)<<10)
.endm

; Parameters:
; 1-2: Unknown
; 3 - Top of stack
; 4 - A function
.MACRO m_ThreadState
	.db \1 \2
	.dw \3
	.dw \4
	.db $00 $00
.ENDM

; ARG 1: actual address
; ARG 2: relative address
.MACRO m_RelativePointer
	.dw ((((\1)&$3fff)+(:\1)*$4000) - ((\2&$3fff)+(:\2)*$4000))&$ffff
.ENDM

; Same as above but always use absolute numbers instead of labels
.MACRO m_RelativePointerAbs
	.dw ((\1) - (\2)&$ffff
.ENDM

; Macro to .incbin data while allowing it to cross over banks. This depends on the use of .BANK and
; .ORG to precisely set the address, therefore this will not work in sections.
;
; Must define DATA_ADDR and DATA_BANK, corresponding to the current address, prior to using this
; (the linker gets no say in its placement).
;
; Arguments:
;   \1: Filename (should be a ".cmp" file)
;   \2: Number of bytes in ".cmp" file header (these bytes are not included)
.macro m_IncbinCrossBankData
	.fopen \1 file
	.fsize file SIZE
	.fclose file

	.redefine SIZE SIZE-\2 ; Skip .cmp file "header"

	.if SIZE >= 1
	.if DATA_ADDR + SIZE >= $8000
		.define DATA_READAMOUNT $8000-DATA_ADDR

		.incbin \1 SKIP \2 READ DATA_READAMOUNT

		.redefine DATA_BANK DATA_BANK+1
		.BANK DATA_BANK SLOT 1
		.ORGA $4000

		.if DATA_READAMOUNT < SIZE
			.incbin \1 SKIP DATA_READAMOUNT+\2
		.endif

		.redefine DATA_ADDR $4000 + SIZE-DATA_READAMOUNT
		.undefine DATA_READAMOUNT
	.else
		.incbin \1 SKIP \2
		.redefine DATA_ADDR DATA_ADDR + SIZE
	.endif
	.endif

	.undefine SIZE
.endm

; Incbin room layout data, can cross over banks.
; ARG 1: name
.macro m_RoomLayoutData
	\1:
	m_IncbinCrossBankData {"{BUILD_DIR}/rooms/\1.cmp"}, 1
.endm

; Pointer to room data defined with m_RoomLayoutData
; ARG 1: name
; ARG 2: relative offset
.macro m_RoomLayoutPointer
	.FOPEN {"{BUILD_DIR}/rooms/\1.cmp"} m_DataFile
	.FREAD m_DataFile mode
	.FCLOSE m_DataFile

	.IF mode == 3
		; Mode 3 is dictionary compression, for large rooms, handled fairly differently
		m_RoomLayoutDictPointer \1, \2
	.ELSE
		.dw (((:\1)*$4000)+((\1)&$3fff) - (((:\2)*$4000)+((\2)&$3fff))) | (mode<<14)
	.ENDIF

	.undefine mode
.endm

; Pointer to room data with dictionary compression
; This macro doesn't require a corresponding file to exist, just a label
; ARG 1: name
; ARG 2: relative offset
.macro m_RoomLayoutDictPointer
	.dw (((:\1)*$4000)+(\1&$3fff) - (((:\2)*$4000)+((\2)&$3fff))) + $200
.ENDM

; Args:
; 1 - Label: name
; 2 - Byte: Compression mode ($00 or $80)
.macro m_TilesetLayoutDictionaryHeader
	.db (:\1) | (\2)
	dwbe \1
.endm

; Args:
; 1 - Byte: dictionary index (for compression)
; 2 - Label: Compressed data to load
; 3 - Word: Destination (multiple of 0x10)
; 4 - Byte: Destination wram/vram bank
; 5 - Word: Data size in bytes
.macro m_TilesetLayoutHeader
	.db \1
	.db :\2
	dwbe \2
	dwbe (\3) | (:\3)
	dwbe (\4) | ((\5)<<8)
.endm


; Args:
; 1 - Byte: Opcode
; 2 - Byte: Src map
; 3 - Byte: Index
; 4 - 4bit: Y or Group src
; 5 - 4bit: X or Entrance mode
.macro m_StandardWarp
	.db \1, \2, \3, ((\4)<<4)|\5
.endm

; Same as StandardWarp, except \2 represents YX.
; This only exists to help LynnaLab distinguish the 2.
.macro m_PointedWarp
	.db \1, \2, \3, ((\4)<<4)|\5
.endm

; Args:
; 1 - Byte: Opcode
; 2 - Byte: Src map
; 3 - Pointer
.macro m_PointerWarp
	.db \1, \2
	.dw \3
.endm

.macro m_WarpSourcesEnd ; Does nothing in seasons
.ifdef ROM_AGES
	.db $ff $00 $00 $00
.endif
.endm

; Args:
; 1 - Byte: map
; 2 - Byte: YX
; 3 - 4bit: parameter
; 4 - 4bit: param
.macro m_WarpDest
	.db \1, \2
	.db ((\3)<<4) | (\4)
.endm


; Used in interactionAnimations.s, partAnimations, etc.
.macro m_AnimationLoop
	.db ((\1)-CADDR)>>8
	.db ((\1)-CADDR)&$ff
.endm


; A pointer to a special object's graphics. Must be located in bank $1a or $1b.
; If only 2 arguments are specified, and the second is $0000, no graphics data will be
; loaded (although the OAM data in the first argument may still apply).
;
; Arg 1: index for specialObjectOamDataTable
; Arg 2: graphics file
; Arg 3: offset within file
; Arg 4: size (divided by 16)
.macro m_SpecialObjectGfxPointer
	.IF NARGS == 2
		.db \1
		.dw \2
	.ELSE
		.db \1
		.dw (\2)+(\3) | (\4) | ((:\2) - :gfxDataBank1a)
	.ENDIF
.endm


; Defines 5 bytes loaded by the "setWarpDestVariables" function. Generally that function will
; initiate a warp somewhere.
;
; TODO: Figure out what bit 7 of the group index does (and hence why we need 2 of these)
;
; Arg 1: Warp destination (see constants/rooms.s)
; Arg 2: wWarpTransition
; Arg 3: wWarpDestPos
; Arg 4: wWarpTransition2
.macro m_HardcodedWarpA
	.db $80|((\1)>>8), \1&$ff
	.db \2, \3, \4
.endm

.macro m_HardcodedWarpB
	.db (\1)>>8, (\1)&$ff
	.db \2, \3, \4
.endm

; See "data/{game}/dungeonData.s"
.macro m_DungeonData
	.db \1, \2
	.db ((\3) - dungeonLayoutDataStart) / $40
	.db \4, \5, \6, \7, \8
.endm
