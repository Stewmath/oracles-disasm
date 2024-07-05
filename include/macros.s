; ==================================================================================================
; Code macros
; ==================================================================================================

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

; ==================================================================================================
; Directive macros
; ==================================================================================================

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
		.assert NARGS == 3

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
		.assert NARGS == 3

		.ifdef FORCE_SECTIONS
		.section \1 \2 \3 FORCE
		.else
		.section \1 \2 \3 SUPERFREE
		.endif
	.endif
.endm

; Include something from the "rooms" directory based on the game
.macro m_IncRoomData
	.assert NARGS == 1

	.ifdef ROM_AGES
		.incbin "rooms/ages/\1"
	.else
		.incbin "rooms/seasons/\1"
	.endif
.endm

; ==================================================================================================
; Data macros
; ==================================================================================================

; Pointers
.MACRO 3BytePointer
	.assert NARGS == 1

	.db :\1
	.dw \1
.ENDM
.MACRO Pointer3Byte
	.assert NARGS == 1

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
	.assert NARGS == 2

	.db \1
	.dw \2
.endm

; Define a byte and 2 words
.macro dbww
	.assert NARGS == 3

	.db \1
	.dw \2, \3
.endm

; Define 2 bytes and a word
.macro dbbw
	.assert NARGS == 3

	.db \1, \2
	.dw \3
.endm

; Define 2 bytes and 2 words
.macro dbbww
	.assert NARGS == 4

	.db \1, \2
	.dw \3, \4
.endm

; Define a word and a byte
.macro dwb
	.assert NARGS == 2

	.dw \1
	.db \2
.endm

; Define a word a 2 bytes
.macro dwbb
	.assert NARGS == 3

	.dw \1
	.db \2, \3
.endm

; Define a byte, a word, and a byte.
.macro dbwb
	.assert NARGS == 3

	.db \1
	.dw \2
	.db \3
.endm

.MACRO revb
	.assert NARGS == 1

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

; Define a byte which is a relative offset from the current address
.macro dbrel
	.rept NARGS
		.db (\1) - CADDR ; CADDR = current address
		.shift
	.endr
.endm

; Args 1-3: color components
.macro m_RGB16
	.assert NARGS == 3

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
	.assert NARGS == 4

	.db \1 \2
	.dw \3
	.dw \4
	.db $00 $00
.ENDM

; ARG 1: actual address
; ARG 2: relative address
.MACRO m_RelativePointer
	.assert NARGS == 2

	.dw ((((\1)&$3fff)+(:\1)*$4000) - ((\2&$3fff)+(:\2)*$4000))&$ffff
.ENDM

; Same as above but always use absolute numbers instead of labels
.MACRO m_RelativePointerAbs
	.assert NARGS == 2

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
	.assert NARGS == 2

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
	.assert NARGS == 1

	\1:
	m_IncbinCrossBankData {"{BUILD_DIR}/rooms/\1.cmp"}, 1
.endm

; Pointer to room data defined with m_RoomLayoutData
; ARG 1: name
; ARG 2: relative offset
.macro m_RoomLayoutPointer
	.assert NARGS == 2

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
	.assert NARGS == 2

	.dw (((:\1)*$4000)+(\1&$3fff) - (((:\2)*$4000)+((\2)&$3fff))) + $200
.ENDM

; Args:
; 1 - Label: name
; 2 - Byte: Compression mode ($00 or $80)
.macro m_TilesetLayoutDictionaryHeader
	.assert NARGS == 2

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
	.assert NARGS == 5

	.db \1
	.db :\2
	dwbe \2
	dwbe (\3) | (:\3)
	dwbe (\4) | ((\5)<<8)
.endm


; Used in interactionAnimations.s, partAnimations, etc.
.macro m_AnimationLoop
	.assert NARGS == 1

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
		.assert NARGS == 4

		.db \1
		.dw (\2)+(\3) | (\4) | ((:\2) - :gfxDataBank1a)
	.ENDIF
.endm


; Defines 5 bytes loaded by the "setWarpDestVariables" function. Generally that function will
; initiate a warp somewhere.
;
; TODO: Figure out what bit 7 of the group index does (and hence why we need 2 of these)
;
; Arg 1: Warp destination (see constants/common/rooms.s)
; Arg 2: wWarpTransition
; Arg 3: wWarpDestPos
; Arg 4: wWarpTransition2
.macro m_HardcodedWarpA
	.assert NARGS == 4

	.db $80|((\1)>>8), \1&$ff
	.db \2, \3, \4
.endm

.macro m_HardcodedWarpB
	.assert NARGS == 4

	.db (\1)>>8, (\1)&$ff
	.db \2, \3, \4
.endm

; Convert pointer in "data/{game}/dungeonLayouts.s" to an index, see that file for details
.function f_DungeonLayoutToIndex(label) ((label - dungeonLayoutDataStart) / $40)

; See "data/{game}/dungeonData.s"
.macro m_DungeonData
	.assert NARGS == 8

	.db \1, \2
	.db f_DungeonLayoutToIndex(\3)
	.db \4, \5, \6, \7, \8
.endm

; See data/ages/tile_properties/breakableTiles.s for documentation of parameters to this.
.macro m_BreakableTileData
	.assert NARGS == 6

	.if \3 > $f
	.fail
	.endif
	.if \4 > $f
	.fail
	.endif

	; Parameters 1-3 have their bits reversed, so that they can be read left-to-right.
	dbrev \1, \2
	revb \3
	.db (_out >> 4) | ((\4)<<4) ; "_out" is the output from the revb macro ("\3" with bits flipped).
	.db \5, \6
.endm


; There are a number of data structures that use bit 7 of a particular byte to mean "continue
; reading the next entry if set". Examples include gfx headers and interaction data
; (data/{game}/interactionData.s). It is very ugly to bake that data directly into the data, though,
; as it's basically unreadable.
;
; This macro can be used to define bytes like that more elegantly. The value for the "continue bit"
; is defined later, either when this is invoked again, or when m_ContinueBitHelperSetLast/UnsetLast
; is used. (It is important to use SetLast/UnsetLast at least once after this, otherwise the value
; of the preceding continue bit will never be defined.)
;
; As it's using a define with "\@" in its name, which is the number of times the current macro has
; been called, it's important to not copy/paste this into multiple macros.
;
; Parameters:
;   \1: Byte to define
;   \2: Default "continue bit value" to apply to the last entry if it exists when this is called
.macro m_ContinueBitHelper
	.assert NARGS == 2

	.if !(\1 >= 0 && \1 <= $7f)
		.fail {"m_ContinueBitHelper: Invalid byte ${%.2x{\1}}"}
	.endif

	; Mark "continue" bit on last defined entry
	.ifdef CURRENT_CONTINUE_INDEX
		.define CONTINUE_BIT_{CURRENT_CONTINUE_INDEX}, \2
	.endif

	; Define byte for current entry
	.redefine CURRENT_CONTINUE_INDEX \@
	.db (\1) | CONTINUE_BIT_{CURRENT_CONTINUE_INDEX}
.endm

.macro m_ContinueBitHelperSetLast
	.assert NARGS == 0

	.ifdef CURRENT_CONTINUE_INDEX
		.define CONTINUE_BIT_{CURRENT_CONTINUE_INDEX} $80
		.undefine CURRENT_CONTINUE_INDEX
	.endif
.endm

.macro m_ContinueBitHelperUnsetLast
	.assert NARGS == 0

	.ifdef CURRENT_CONTINUE_INDEX
		.define CONTINUE_BIT_{CURRENT_CONTINUE_INDEX} $00
		.undefine CURRENT_CONTINUE_INDEX
	.endif
.endm


; ==================================================================================================
; Macro for data/{game}/interactionData.s
; ==================================================================================================
.macro m_InteractionData
	.if NARGS == 3
		.db \1, \2, \3
	.elif NARGS == 1
		; Pointer to subid data
		.db \1&$ff, $80, \1>>8
	.else
		.fail "Invalid number of arguments to m_InteractionData."
	.endif
.endm

; Basically the same as above, except it uses a "continue bit" to mark where the data ends
.macro m_InteractionSubidData
	.assert NARGS == 3

	.db \1
	m_ContinueBitHelper \2, $00
	.db \3
.endm

.macro m_InteractionSubidDataEnd
	.assert NARGS == 0
	m_ContinueBitHelperSetLast
.endm


; ==================================================================================================
; Macros for data/{game}/enemyData.s, similar to above
; ==================================================================================================
.macro m_EnemyData
	.if NARGS == 4
		.db \1 \2 \3 \4
	.else
		.assert NARGS == 3
		.db \1 \2
		dwbe \3 | $8000
	.endif
.endm

.macro m_EnemySubidData
	.assert NARGS == 2
	m_ContinueBitHelper \1, $80
	.db \2
.endm

.macro m_EnemySubidDataEnd
	.assert NARGS == 0
	m_ContinueBitHelperUnsetLast
.endm


; ==================================================================================================
; Macros for data/{game}/treasureObjectData.s
; ==================================================================================================
.macro m_BeginTreasureSubids
	.assert NARGS == 1
	.redefine CURRENT_TREASURE_INDEX, (\1)<<8
.endm

.macro m_TreasureSubid
	.assert NARGS == 5

	.db \1, \2, \3, \4

	.IF CURRENT_TREASURE_INDEX >= $10000
		; Within the "treasureObjectData" table, "CURRENT_TREASURE_INDEX" corresponds to
		; values from "constants/common/treasure.s". (We add $10000 just to make it easy to
		; differentiate which mode we're in.)
		.define \5, (CURRENT_TREASURE_INDEX - $10000) << 8
	.ELSE
		; Within a subid table, "CURRENT_TREASURE_INDEX" corresponds to a treasure object
		; index (2-byte number)
		.define \5, CURRENT_TREASURE_INDEX
	.ENDIF

	.export \5
	.redefine CURRENT_TREASURE_INDEX, CURRENT_TREASURE_INDEX+1
.endm

.macro m_TreasurePointer
	.assert NARGS == 1

	.db $80
	.dw \1
	.db $00

	.redefine CURRENT_TREASURE_INDEX, CURRENT_TREASURE_INDEX+1
.endm


; ==================================================================================================
; Macros for warp data
; ==================================================================================================

; Some additional documentation for these macros can be found in data/ages/warpSources.s and
; data/ages/warpDestinations.s.

; Args:
;   \1 - 4bit: Opcode
;   \2 - Byte: Source room index
;   \3 - Byte: Index
;   \4 - 4bit: Y or Group src
;   \5 - 4bit: X or Entrance mode
.macro m_StandardWarp
	.assert NARGS == 5
	.assert \1 >= 0 && \1 <= $f
	.assert \4 >= 0 && \4 <= $f
	.assert \5 >= 0 && \5 <= $f

	m_ContinueBitHelper \1, $00
	.db \2, \3, ((\4)<<4)|\5
.endm

; Args:
;   \1 - Byte: Source room index
;   \2 - Pointer
.macro m_PointerWarp
	.assert NARGS == 2
	m_ContinueBitHelper $40, $00
	.db \1
	.dw \2
.endm

; Basically the same as m_StandardWarp, except \2 represents YX.
; Should only be used in a list pointed to by m_PointerWarp.
.macro m_PositionWarp
	.assert NARGS == 4
	.assert \3 >= 0 && \3 <= $f
	.assert \4 >= 0 && \4 <= $f

	m_ContinueBitHelper $00, $00
	.db \1, \2, ((\3)<<4)|\4
.endm

; End the list of warps, indicating that the last defined value should be used as a warp if nothing
; else was found.
.macro m_WarpListEndWithDefault
	.assert NARGS == 0
	m_ContinueBitHelperSetLast
.endm

; End the list of warps, indicating no warp was found.
; This only works in Ages. This became necessary when they implemented the automatic warps for
; dungeon stairs - they needed to explicitly NOT have default warp values for it to work.
.macro m_WarpListEndNoDefault
	.assert NARGS == 0

	.ifndef AGES_ENGINE
		.fail "m_WarpListEndNoDefault cannot be used in Seasons unless AGES_ENGINE is defined."
	.endif
	.db $ff $00 $00 $00
	m_ContinueBitHelperUnsetLast
.endm

; Sometimes the devs seemingly forgot to end a warp list with their equivalent of m_WarpListEnd.
; This usually doesn't cause problems in the game. But our system needs something there, so use this
; macro in that case.
.macro m_WarpListFallThrough
	.assert NARGS == 0
	m_ContinueBitHelperUnsetLast
.endm

; Args:
;   \1 - Byte: room index
;   \2 - Byte: YX
;   \3 - 4bit: parameter
;   \4 - 4bit: Transition type
.macro m_WarpDest
	.assert NARGS == 4

	.db \1, \2
	.db ((\3)<<4) | (\4)
.endm

; ==================================================================================================
; Macro for data/{game}/chestData.s (see there for documentation)
; ==================================================================================================

.macro m_ChestData
	.assert NARGS == 3

	.if \1 == $ff
		; $ff is the "end of data" marker so we can't have that
		.PRINTT "ERROR: Chest Y/X position can't be $ff!\n"
		.FAIL
	.endif
	.db \1 \2
	dwbe \3
.endm

; ==================================================================================================
; Macro for data/{game}/seedTreeRefillData.s (see there for documentation)
; ==================================================================================================

.macro m_TreeRefillData
	.assert NARGS == 2

	.ifdef ROM_AGES
		.assert \1 >= 0 && \1 <= 0x1ff
	.else
		.assert \1 >= 0 && \1 <= 0xff
	.endif

	.db \1&$ff, \2|(\1>>8)
.endm
