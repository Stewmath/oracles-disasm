; Treasure objects are a kind of Interaction (INTERACID_TREASURE). Each "Treasure Object" contains
; the information necessary to display a specific treasure (see "constants/treasure.s") and give it
; to Link. Many treasures need a "parameter" to go with them (ie. level, amount). All of this "extra
; data" is defined here.
;
; The "m_TreasureSubid" macro takes 4 bytes as parameters:
;   b0: bit 7    = next 2 bytes are a pointer
;       bits 4-6 = spawn mode
;       bit 3    = ?
;       bits 0-2 = grab mode
;   b1: Parameter (value of 'c' to pass to "giveTreasure")
;   b2: Low text ID on pickup ($ff for no text; high byte of ID is always $00)
;   b3: Graphics to use. (Gets copied to object's subid, so graphics are determined by the
;       corresponding value for interaction $60 in data/interactionData.s.)
;
; Then, the macro takes two more parameters:
;   Param 4: The treasure index (TREASURE_...)
;   Param 5: The name to give this new subid of the treasure index. This name will resolve to
;            a 4-digit hex number (XXYY, where XX = treasure index and YY = subid).
;
; If multiple subids are being specified for a single treasure, then parameter 4 is omitted and the
; "m_BeginTreasureSubids" macro must be used.
;
; For documentation of spawn modes and grab modes, see "constants/treasureSpawnModes.s".
;
; See also constants/treasure.s for treasure lists.


.macro m_BeginTreasureSubids
	.IF \1 == 0
		.PRINTT "m_BeginTreasureSubids with param 0 not handled properly\n"
		.FAIL
	.ENDIF
	.redefine CURRENT_TREASURE_INDEX, (\1)<<8
.endm

.macro m_TreasureSubid
	.db \1, \2, \3, \4

	.IF CURRENT_TREASURE_INDEX < $100
		; Within the "treasureObjectData" table, "CURRENT_TREASURE_INDEX" corresponds to
		; values from "constants/treasure.s"
		.define \5, (CURRENT_TREASURE_INDEX << 8)
	.ELSE
		; Within a subid table, "CURRENT_TREASURE_INDEX" corresponds to a treasure object
		; index (2-byte number)
		.define \5, CURRENT_TREASURE_INDEX
	.ENDIF

	.export \5
	.redefine CURRENT_TREASURE_INDEX, CURRENT_TREASURE_INDEX+1
.endm

.macro m_UndefinedTreasure
	.db $00 $00 $ff $00

	.redefine CURRENT_TREASURE_INDEX, CURRENT_TREASURE_INDEX+1
.endm

.macro m_TreasurePointer
	.db $80
	.dw \1
	.db $00

	.redefine CURRENT_TREASURE_INDEX, CURRENT_TREASURE_INDEX+1
.endm


.define CURRENT_TREASURE_INDEX $00

treasureObjectData:
	; 0x00
	m_UndefinedTreasure

	; 0x01
	m_TreasurePointer treasureObjectData01

	; 0x02
	m_UndefinedTreasure

	; 0x03
	m_TreasurePointer treasureObjectData03

	; 0x04
	m_TreasureSubid $38, $00, $73, $17, TREASURE_CANE_OF_SOMARIA_SUBID_00

	; 0x05
	m_TreasurePointer treasureObjectData05

	; 0x06
	m_TreasurePointer treasureObjectData06

	; 0x07
	m_UndefinedTreasure

	; 0x08
	m_UndefinedTreasure

	; 0x09
	m_UndefinedTreasure

	; 0x0a
	m_TreasurePointer treasureObjectData0a

	; 0x0b
	m_UndefinedTreasure

	; 0x0c
	m_TreasurePointer treasureObjectData0c

	; 0x0d
	m_TreasurePointer treasureObjectData0d

	; 0x0e
	m_TreasurePointer treasureObjectData0e

	; 0x0f
	m_TreasureSubid $38, $01, $2e, $21, TREASURE_SHOOTER_SUBID_00

	; 0x10
	m_UndefinedTreasure

	; 0x11
	m_TreasurePointer treasureObjectData11

	; 0x12
	m_UndefinedTreasure

	; 0x13
	m_TreasurePointer $0000

	; 0x14
	m_UndefinedTreasure

	; 0x15
	m_TreasurePointer treasureObjectData15

	; 0x16
	m_TreasurePointer treasureObjectData16

	; 0x17
	m_TreasurePointer treasureObjectData17

	; 0x18
	m_UndefinedTreasure

	; 0x19
	m_TreasurePointer treasureObjectData19

	; 0x1a
	m_UndefinedTreasure

	; 0x1b
	m_UndefinedTreasure

	; 0x1c
	m_UndefinedTreasure

	; 0x1d
	m_UndefinedTreasure

	; 0x1e
	m_UndefinedTreasure

	; 0x1f
	m_UndefinedTreasure

	; 0x20
	m_TreasurePointer treasureObjectData20

	; 0x21
	m_UndefinedTreasure

	; 0x22
	m_UndefinedTreasure

	; 0x23
	m_UndefinedTreasure

	; 0x24
	m_UndefinedTreasure

	; 0x25
	m_TreasureSubid $68, $00, $72, $69, TREASURE_TUNE_OF_ECHOES_SUBID_00

	; 0x26
	m_TreasureSubid $0a, $00, $0a, $6a, TREASURE_TUNE_OF_CURRENTS_SUBID_00

	; 0x27
	m_TreasureSubid $0a, $00, $0b, $6b, TREASURE_TUNE_OF_AGES_SUBID_00

	; 0x28
	m_TreasurePointer treasureObjectData28

	; 0x29
	m_UndefinedTreasure

	; 0x2a
	m_TreasurePointer treasureObjectData2a

	; 0x2b
	m_TreasurePointer treasureObjectData2b

	; 0x2c
	m_TreasurePointer treasureObjectData2c

	; 0x2d
	m_TreasurePointer treasureObjectData2d

	; 0x2e
	m_TreasurePointer treasureObjectData2e

	; 0x2f
	m_TreasureSubid $02, $00, $ff, $30, TREASURE_POTION_SUBID_00

	; 0x30
	m_TreasurePointer treasureObjectData30

	; 0x31
	m_TreasurePointer treasureObjectData31

	; 0x32
	m_TreasurePointer treasureObjectData32

	; 0x33
	m_TreasurePointer treasureObjectData33

	; 0x34
	m_TreasurePointer treasureObjectData34

	; 0x35
	m_UndefinedTreasure

	; 0x36
	m_TreasureSubid $02, $00, $33, $4f, TREASURE_MAKU_SEED_SUBID_00

	; 0x37
	m_TreasureSubid $02, $0b, $6b, $2f, TREASURE_ORE_CHUNKS_SUBID_00

	; 0x38
	m_UndefinedTreasure

	; 0x39
	m_UndefinedTreasure

	; 0x3a
	m_UndefinedTreasure

	; 0x3b
	m_UndefinedTreasure

	; 0x3c
	m_UndefinedTreasure

	; 0x3d
	m_UndefinedTreasure

	; 0x3e
	m_UndefinedTreasure

	; 0x3f
	m_UndefinedTreasure

	; 0x40
	m_TreasurePointer $0000

	; 0x41
	m_TreasurePointer treasureObjectData41

	; 0x42
	m_TreasureSubid $29, $00, $23, $44, TREASURE_GRAVEYARD_KEY_SUBID_00

	; 0x43
	m_TreasureSubid $09, $00, $3d, $45, TREASURE_CROWN_KEY_SUBID_00

	; 0x44
	m_TreasureSubid $09, $00, $42, $46, TREASURE_OLD_MERMAID_KEY_SUBID_00

	; 0x45
	m_TreasurePointer treasureObjectData45

	; 0x46
	m_TreasureSubid $02, $00, $44, $48, TREASURE_LIBRARY_KEY_SUBID_00

	; 0x47
	m_UndefinedTreasure

	; 0x48
	m_TreasureSubid $51, $01, $67, $55, TREASURE_RICKY_GLOVES_SUBID_00

	; 0x49
	m_TreasurePointer treasureObjectData49

	; 0x4a
	m_TreasureSubid $38, $00, $36, $27, TREASURE_MERMAID_SUIT_SUBID_00

	; 0x4b
	m_TreasureSubid $38, $00, $48, $50, TREASURE_SLATE_SUBID_00

	; 0x4c
	m_TreasurePointer treasureObjectData4c

	; 0x4d
	m_TreasureSubid $0a, $00, $0d, $3e, TREASURE_SCENT_SEEDLING_SUBID_00

	; 0x4e
	m_TreasureSubid $0a, $00, $47, $51, TREASURE_ZORA_SCALE_SUBID_00

	; 0x4f
	m_TreasureSubid $0a, $00, $56, $53, TREASURE_TOKAY_EYEBALL_SUBID_00

	; 0x50
	m_TreasureSubid $00, $00, $ff, $00, TREASURE_EMPTY_BOTTLE_SUBID_00

	; 0x51
	m_TreasureSubid $0a, $00, $55, $58, TREASURE_FAIRY_POWDER_SUBID_00

	; 0x52
	m_TreasureSubid $0a, $00, $7d, $3c, TREASURE_CHEVAL_ROPE_SUBID_00

	; 0x53
	m_UndefinedTreasure

	; 0x54
	m_TreasureSubid $0a, $00, $7c, $26, TREASURE_ISLAND_CHART_SUBID_00

	; 0x55
	m_TreasureSubid $0a, $00, $4e, $52, TREASURE_BOOK_OF_SEALS_SUBID_00

	; 0x56
	m_UndefinedTreasure

	; 0x57
	m_UndefinedTreasure

	; 0x58
	m_UndefinedTreasure

	; 0x59
	m_TreasureSubid $02, $00, $4a, $49, TREASURE_GORON_LETTER_SUBID_00

	; 0x5a
	m_TreasureSubid $0a, $00, $41, $4a, TREASURE_LAVA_JUICE_SUBID_00

	; 0x5b
	m_TreasureSubid $0a, $00, $0c, $4b, TREASURE_BROTHER_EMBLEM_SUBID_00

	; 0x5c
	m_TreasureSubid $0a, $00, $3f, $4c, TREASURE_GORON_VASE_SUBID_00

	; 0x5d
	m_TreasurePointer treasureObjectData5d

	; 0x5e
	m_TreasurePointer treasureObjectData5e

	; 0x5f
	m_UndefinedTreasure

	; 0x60
	m_TreasureSubid $0c, $00, $ff, $57, TREASURE_60_SUBID_00

	; 0x61
	m_TreasureSubid $02, $00, $6e, $05, TREASURE_BOMB_UPGRADE_SUBID_00

	; 0x62
	m_TreasureSubid $02, $00, $46, $20, TREASURE_SATCHEL_UPGRADE_SUBID_00

treasureObjectData01:
	m_BeginTreasureSubids TREASURE_SHIELD
	m_TreasureSubid $0a, $01, $1f, $13, TREASURE_SHIELD_SUBID_00
	m_TreasureSubid $0a, $02, $20, $14, TREASURE_SHIELD_SUBID_01
	m_TreasureSubid $0a, $03, $21, $15, TREASURE_SHIELD_SUBID_02
	m_TreasureSubid $0a, $03, $ff, $15, TREASURE_SHIELD_SUBID_03

treasureObjectData03:
	m_BeginTreasureSubids TREASURE_BOMBS
	m_TreasureSubid $38, $10, $4d, $05, TREASURE_BOMBS_SUBID_00
	m_TreasureSubid $30, $10, $4d, $05, TREASURE_BOMBS_SUBID_01
	m_TreasureSubid $02, $10, $4d, $05, TREASURE_BOMBS_SUBID_02
	m_TreasureSubid $38, $30, $4d, $05, TREASURE_BOMBS_SUBID_03
	m_TreasureSubid $09, $00, $76, $05, TREASURE_BOMBS_SUBID_04
	m_TreasureSubid $02, $20, $7e, $05, TREASURE_BOMBS_SUBID_05

treasureObjectData05:
	m_BeginTreasureSubids TREASURE_SWORD
	m_TreasureSubid $09, $01, $1c, $10, TREASURE_SWORD_SUBID_00
	m_TreasureSubid $09, $02, $1d, $11, TREASURE_SWORD_SUBID_01
	m_TreasureSubid $09, $03, $1e, $12, TREASURE_SWORD_SUBID_02
	m_TreasureSubid $03, $01, $ff, $10, TREASURE_SWORD_SUBID_03
	m_TreasureSubid $03, $02, $ff, $11, TREASURE_SWORD_SUBID_04
	m_TreasureSubid $03, $03, $ff, $12, TREASURE_SWORD_SUBID_05
	m_TreasureSubid $01, $01, $75, $10, TREASURE_SWORD_SUBID_06

treasureObjectData06:
	m_BeginTreasureSubids TREASURE_BOOMERANG
	m_TreasureSubid $0a, $01, $22, $1c, TREASURE_BOOMERANG_SUBID_00
	m_TreasureSubid $10, $01, $22, $1c, TREASURE_BOOMERANG_SUBID_01
	m_TreasureSubid $02, $01, $22, $1c, TREASURE_BOOMERANG_SUBID_02

treasureObjectData0a:
	m_BeginTreasureSubids TREASURE_SWITCH_HOOK
	m_TreasureSubid $38, $01, $30, $1f, TREASURE_SWITCH_HOOK_SUBID_00
	m_TreasureSubid $38, $02, $28, $1f, TREASURE_SWITCH_HOOK_SUBID_01

treasureObjectData0c:
	m_BeginTreasureSubids TREASURE_BIGGORON_SWORD
	m_TreasureSubid $02, $00, $6f, $25, TREASURE_BIGGORON_SWORD_SUBID_00
	m_TreasureSubid $30, $00, $6f, $25, TREASURE_BIGGORON_SWORD_SUBID_01

treasureObjectData0d:
	m_BeginTreasureSubids TREASURE_BOMBCHUS
	m_TreasureSubid $0a, $10, $32, $24, TREASURE_BOMBCHUS_SUBID_00
	m_TreasureSubid $30, $10, $32, $24, TREASURE_BOMBCHUS_SUBID_01
	m_TreasureSubid $02, $10, $32, $24, TREASURE_BOMBCHUS_SUBID_02

treasureObjectData0e:
	m_BeginTreasureSubids TREASURE_FLUTE
	m_TreasureSubid $0a, $0b, $3b, $23, TREASURE_FLUTE_SUBID_00
	m_TreasureSubid $0a, $0c, $3b, $23, TREASURE_FLUTE_SUBID_01
	m_TreasureSubid $0a, $0d, $3b, $23, TREASURE_FLUTE_SUBID_02

treasureObjectData11:
	m_BeginTreasureSubids TREASURE_HARP
	m_TreasureSubid $0a, $00, $71, $68, TREASURE_HARP_SUBID_00
	m_TreasureSubid $0a, $01, $78, $68, TREASURE_HARP_SUBID_01

treasureObjectData15:
	m_BeginTreasureSubids TREASURE_SHOVEL
	m_TreasureSubid $0a, $00, $25, $1b, TREASURE_SHOVEL_SUBID_00
	m_TreasureSubid $0a, $00, $74, $1b, TREASURE_SHOVEL_SUBID_01
	m_TreasureSubid $0a, $00, $25, $1b, TREASURE_SHOVEL_SUBID_02

treasureObjectData16:
	m_BeginTreasureSubids TREASURE_BRACELET
	m_TreasureSubid $0a, $01, $26, $19, TREASURE_BRACELET_SUBID_00
	m_TreasureSubid $0a, $01, $77, $19, TREASURE_BRACELET_SUBID_01
	m_TreasureSubid $38, $02, $2f, $1a, TREASURE_BRACELET_SUBID_02
	m_TreasureSubid $0a, $01, $26, $19, TREASURE_BRACELET_SUBID_03

treasureObjectData17:
	m_BeginTreasureSubids TREASURE_FEATHER
	m_TreasureSubid $0a, $01, $27, $16, TREASURE_FEATHER_SUBID_00
	m_TreasureSubid $0a, $01, $79, $16, TREASURE_FEATHER_SUBID_01
	m_TreasureSubid $0a, $01, $27, $16, TREASURE_FEATHER_SUBID_02

treasureObjectData19:
	m_BeginTreasureSubids TREASURE_SEED_SATCHEL
	m_TreasureSubid $0a, $01, $2d, $20, TREASURE_SEED_SATCHEL_SUBID_00
	m_TreasureSubid $0a, $00, $7b, $20, TREASURE_SEED_SATCHEL_SUBID_01
	m_TreasureSubid $29, $00, $2d, $20, TREASURE_SEED_SATCHEL_SUBID_02
	m_TreasureSubid $09, $00, $2d, $20, TREASURE_SEED_SATCHEL_SUBID_03
	m_TreasureSubid $01, $00, $80, $20, TREASURE_SEED_SATCHEL_SUBID_UPGRADE

treasureObjectData20:
	m_BeginTreasureSubids TREASURE_EMBER_SEEDS
	m_TreasureSubid $30, $04, $4f, $06, TREASURE_EMBER_SEEDS_SUBID_00

treasureObjectData34:
	m_BeginTreasureSubids TREASURE_GASHA_SEED
	m_TreasureSubid $02, $01, $4b, $0d, TREASURE_GASHA_SEED_SUBID_00
	m_TreasureSubid $38, $01, $4b, $0d, TREASURE_GASHA_SEED_SUBID_01
	m_TreasureSubid $52, $01, $4b, $0d, TREASURE_GASHA_SEED_SUBID_02
	m_TreasureSubid $02, $01, $4b, $0d, TREASURE_GASHA_SEED_SUBID_03
	m_TreasureSubid $0a, $01, $4b, $0d, TREASURE_GASHA_SEED_SUBID_04
	m_TreasureSubid $4a, $01, $4b, $0d, TREASURE_GASHA_SEED_SUBID_05
	m_TreasureSubid $10, $01, $4b, $0d, TREASURE_GASHA_SEED_SUBID_06
	m_TreasureSubid $0a, $01, $4b, $0d, TREASURE_GASHA_SEED_SUBID_07
	m_TreasureSubid $0a, $01, $4b, $0d, TREASURE_GASHA_SEED_SUBID_08

treasureObjectData28:
	m_BeginTreasureSubids TREASURE_RUPEES
	m_TreasureSubid $38, $01, $01, $28, TREASURE_RUPEES_SUBID_00
	m_TreasureSubid $38, $03, $02, $29, TREASURE_RUPEES_SUBID_01
	m_TreasureSubid $38, $04, $03, $2a, TREASURE_RUPEES_SUBID_02
	m_TreasureSubid $38, $05, $04, $2b, TREASURE_RUPEES_SUBID_03
	m_TreasureSubid $38, $07, $05, $2b, TREASURE_RUPEES_SUBID_04
	m_TreasureSubid $38, $0b, $06, $2c, TREASURE_RUPEES_SUBID_05
	m_TreasureSubid $38, $0c, $07, $2d, TREASURE_RUPEES_SUBID_06
	m_TreasureSubid $38, $0f, $08, $2d, TREASURE_RUPEES_SUBID_07
	m_TreasureSubid $38, $0d, $09, $2e, TREASURE_RUPEES_SUBID_08
	m_TreasureSubid $30, $01, $01, $28, TREASURE_RUPEES_SUBID_09
	m_TreasureSubid $18, $01, $ff, $2e, TREASURE_RUPEES_SUBID_0a
	m_TreasureSubid $08, $05, $ff, $2b, TREASURE_RUPEES_SUBID_0b
	m_TreasureSubid $08, $07, $05, $2b, TREASURE_RUPEES_SUBID_0c
	m_TreasureSubid $30, $04, $03, $2a, TREASURE_RUPEES_SUBID_0d
	m_TreasureSubid $01, $05, $04, $2b, TREASURE_RUPEES_SUBID_0e
	m_TreasureSubid $01, $0b, $06, $2c, TREASURE_RUPEES_SUBID_0f
	m_TreasureSubid $01, $0c, $07, $2d, TREASURE_RUPEES_SUBID_10
	m_TreasureSubid $10, $0b, $06, $2c, TREASURE_RUPEES_SUBID_11
	m_TreasureSubid $10, $0c, $07, $2d, TREASURE_RUPEES_SUBID_12
	m_TreasureSubid $10, $07, $05, $2b, TREASURE_RUPEES_SUBID_13
	m_TreasureSubid $00, $04, $ff, $2a, TREASURE_RUPEES_SUBID_14
	m_TreasureSubid $00, $01, $ff, $28, TREASURE_RUPEES_SUBID_15
	m_TreasureSubid $0a, $0d, $09, $2e, TREASURE_RUPEES_SUBID_16

treasureObjectData2b:
	m_BeginTreasureSubids TREASURE_HEART_PIECE
	m_TreasureSubid $0a, $01, $17, $3a, TREASURE_HEART_PIECE_SUBID_00
	m_TreasureSubid $38, $01, $17, $3a, TREASURE_HEART_PIECE_SUBID_01
	m_TreasureSubid $02, $01, $17, $3a, TREASURE_HEART_PIECE_SUBID_02

treasureObjectData2a:
	m_BeginTreasureSubids TREASURE_HEART_CONTAINER
	m_TreasureSubid $1a, $04, $16, $3b, TREASURE_HEART_CONTAINER_SUBID_00
	m_TreasureSubid $30, $04, $16, $3b, TREASURE_HEART_CONTAINER_SUBID_01
	m_TreasureSubid $02, $04, $16, $3b, TREASURE_HEART_CONTAINER_SUBID_02

treasureObjectData2c:
	m_BeginTreasureSubids TREASURE_RING_BOX
	m_TreasureSubid $02, $01, $57, $33, TREASURE_RING_BOX_SUBID_00
	m_TreasureSubid $02, $02, $34, $34, TREASURE_RING_BOX_SUBID_01
	m_TreasureSubid $02, $03, $34, $35, TREASURE_RING_BOX_SUBID_02
	m_TreasureSubid $02, $02, $58, $34, TREASURE_RING_BOX_SUBID_03
	m_TreasureSubid $02, $03, $59, $35, TREASURE_RING_BOX_SUBID_04

treasureObjectData2d:
	m_BeginTreasureSubids TREASURE_RING
	m_TreasureSubid $09, $ff, $54, $0e, TREASURE_RING_SUBID_00 ; 0x00
	m_TreasureSubid $29, $ff, $54, $0e, TREASURE_RING_SUBID_01 ; 0x01
	m_TreasureSubid $49, $ff, $54, $0e, TREASURE_RING_SUBID_02 ; 0x02
	m_TreasureSubid $59, $ff, $54, $0e, TREASURE_RING_SUBID_03 ; 0x03
	m_TreasureSubid $38, $28, $54, $0e, TREASURE_RING_SUBID_04 ; 0x04
	m_TreasureSubid $38, $2b, $54, $0e, TREASURE_RING_SUBID_05 ; 0x05
	m_TreasureSubid $38, $10, $54, $0e, TREASURE_RING_SUBID_06 ; 0x06
	m_TreasureSubid $38, $0c, $54, $0e, TREASURE_RING_SUBID_07 ; 0x07
	m_TreasureSubid $38, $0d, $54, $0e, TREASURE_RING_SUBID_08 ; 0x08
	m_TreasureSubid $38, $2a, $54, $0e, TREASURE_RING_SUBID_09 ; 0x09
	m_TreasureSubid $38, $23, $54, $0e, TREASURE_RING_SUBID_0a ; 0x0a
	m_TreasureSubid $38, $05, $54, $0e, TREASURE_RING_SUBID_0b ; 0x0b
	m_TreasureSubid $30, $15, $54, $0e, TREASURE_RING_SUBID_0c ; 0x0c
	m_TreasureSubid $30, $13, $54, $0e, TREASURE_RING_SUBID_0d ; 0x0d
	m_TreasureSubid $38, $01, $54, $0e, TREASURE_RING_SUBID_0e ; 0x0e
	m_TreasureSubid $38, $03, $54, $0e, TREASURE_RING_SUBID_0f ; 0x0f
	m_TreasureSubid $38, $2d, $54, $0e, TREASURE_RING_SUBID_10 ; 0x10
	m_TreasureSubid $38, $1d, $54, $0e, TREASURE_RING_SUBID_11 ; 0x11
	m_TreasureSubid $10, $12, $ff, $0e, TREASURE_RING_SUBID_12 ; 0x12
	m_TreasureSubid $10, $23, $ff, $0e, TREASURE_RING_SUBID_13 ; 0x13
	m_TreasureSubid $01, $12, $54, $0e, TREASURE_RING_SUBID_14 ; 0x14
	m_TreasureSubid $01, $23, $54, $0e, TREASURE_RING_SUBID_15 ; 0x15
	m_TreasureSubid $38, $26, $54, $0e, TREASURE_RING_SUBID_16 ; 0x16
	m_TreasureSubid $38, $04, $54, $0e, TREASURE_RING_SUBID_17 ; 0x17
	m_TreasureSubid $38, $32, $54, $0e, TREASURE_RING_SUBID_18 ; 0x18
	m_TreasureSubid $38, $17, $54, $0e, TREASURE_RING_SUBID_19 ; 0x19
	m_TreasureSubid $38, $1b, $54, $0e, TREASURE_RING_SUBID_1a ; 0x1a
	m_TreasureSubid $38, $02, $54, $0e, TREASURE_RING_SUBID_1b ; 0x1b
	m_TreasureSubid $38, $1c, $54, $0e, TREASURE_RING_SUBID_1c ; 0x1c
	m_TreasureSubid $38, $22, $54, $0e, TREASURE_RING_SUBID_1d ; 0x1d
	m_TreasureSubid $38, $11, $54, $0e, TREASURE_RING_SUBID_1e ; 0x1e
	m_TreasureSubid $38, $06, $54, $0e, TREASURE_RING_SUBID_1f ; 0x1f
	m_TreasureSubid $38, $1a, $54, $0e, TREASURE_RING_SUBID_20 ; 0x20
	m_TreasureSubid $38, $1e, $54, $0e, TREASURE_RING_SUBID_21 ; 0x21
	m_TreasureSubid $38, $20, $54, $0e, TREASURE_RING_SUBID_22 ; 0x22
	m_TreasureSubid $38, $39, $54, $0e, TREASURE_RING_SUBID_23 ; 0x23
	m_TreasureSubid $38, $0f, $54, $0e, TREASURE_RING_SUBID_24 ; 0x24
	m_TreasureSubid $38, $3e, $54, $0e, TREASURE_RING_SUBID_25 ; 0x25
	m_TreasureSubid $38, $12, $54, $0e, TREASURE_RING_SUBID_26 ; 0x26
	m_TreasureSubid $38, $08, $54, $0e, TREASURE_RING_SUBID_27 ; 0x27
	m_TreasureSubid $38, $2c, $54, $0e, TREASURE_RING_SUBID_28 ; 0x28

treasureObjectData2e:
	m_BeginTreasureSubids TREASURE_FLIPPERS
	m_TreasureSubid $0a, $00, $31, $31, TREASURE_FLIPPERS_SUBID_00
	m_TreasureSubid $0a, $00, $7a, $31, TREASURE_FLIPPERS_SUBID_01

treasureObjectData30:
	m_BeginTreasureSubids TREASURE_SMALL_KEY
	m_TreasureSubid $18, $01, $ff, $42, TREASURE_SMALL_KEY_SUBID_00
	m_TreasureSubid $28, $01, $ff, $42, TREASURE_SMALL_KEY_SUBID_01
	m_TreasureSubid $49, $01, $1a, $42, TREASURE_SMALL_KEY_SUBID_02
	m_TreasureSubid $38, $01, $1a, $42, TREASURE_SMALL_KEY_SUBID_03

treasureObjectData31:
	m_BeginTreasureSubids TREASURE_BOSS_KEY
	m_TreasureSubid $19, $00, $1b, $43, TREASURE_BOSS_KEY_SUBID_00
	m_TreasureSubid $29, $00, $1b, $43, TREASURE_BOSS_KEY_SUBID_01
	m_TreasureSubid $49, $00, $1b, $43, TREASURE_BOSS_KEY_SUBID_02
	m_TreasureSubid $38, $00, $1b, $43, TREASURE_BOSS_KEY_SUBID_03

treasureObjectData32:
	m_BeginTreasureSubids TREASURE_COMPASS
	m_TreasureSubid $1a, $00, $19, $41, TREASURE_COMPASS_SUBID_00
	m_TreasureSubid $2a, $00, $19, $41, TREASURE_COMPASS_SUBID_01
	m_TreasureSubid $68, $00, $19, $41, TREASURE_COMPASS_SUBID_02

treasureObjectData33:
	m_BeginTreasureSubids TREASURE_MAP
	m_TreasureSubid $1a, $00, $18, $40, TREASURE_MAP_SUBID_00
	m_TreasureSubid $2a, $00, $18, $40, TREASURE_MAP_SUBID_01
	m_TreasureSubid $68, $00, $18, $40, TREASURE_MAP_SUBID_02

treasureObjectData41:
	m_BeginTreasureSubids TREASURE_TRADEITEM
	m_TreasureSubid $0a, $00, $5a, $70, TREASURE_TRADEITEM_SUBID_00
	m_TreasureSubid $0a, $01, $5b, $71, TREASURE_TRADEITEM_SUBID_01
	m_TreasureSubid $0a, $02, $5c, $72, TREASURE_TRADEITEM_SUBID_02
	m_TreasureSubid $0a, $03, $5d, $73, TREASURE_TRADEITEM_SUBID_03
	m_TreasureSubid $0a, $04, $5e, $74, TREASURE_TRADEITEM_SUBID_04
	m_TreasureSubid $0a, $05, $5f, $75, TREASURE_TRADEITEM_SUBID_05
	m_TreasureSubid $0a, $06, $60, $76, TREASURE_TRADEITEM_SUBID_06
	m_TreasureSubid $0a, $07, $61, $77, TREASURE_TRADEITEM_SUBID_07
	m_TreasureSubid $0a, $08, $62, $78, TREASURE_TRADEITEM_SUBID_08
	m_TreasureSubid $0a, $09, $63, $79, TREASURE_TRADEITEM_SUBID_09
	m_TreasureSubid $0a, $0a, $64, $7a, TREASURE_TRADEITEM_SUBID_0a
	m_TreasureSubid $0a, $0b, $65, $7b, TREASURE_TRADEITEM_SUBID_0b

treasureObjectData45:
	m_BeginTreasureSubids TREASURE_MERMAID_KEY
	m_TreasureSubid $09, $00, $43, $47, TREASURE_MERMAID_KEY_SUBID_00
	m_TreasureSubid $19, $00, $43, $47, TREASURE_MERMAID_KEY_SUBID_01

treasureObjectData49:
	m_BeginTreasureSubids TREASURE_BOMB_FLOWER
	m_TreasureSubid $0a, $00, $3c, $56, TREASURE_BOMB_FLOWER_SUBID_00
	m_TreasureSubid $00, $00, $ff, $56, TREASURE_BOMB_FLOWER_SUBID_01

treasureObjectData4c:
	m_BeginTreasureSubids TREASURE_TUNI_NUT
	m_TreasureSubid $0a, $00, $37, $5b, TREASURE_TUNI_NUT_SUBID_00
	m_TreasureSubid $0a, $02, $37, $5c, TREASURE_TUNI_NUT_SUBID_01

treasureObjectData5d:
	m_BeginTreasureSubids TREASURE_GORONADE
	m_TreasureSubid $0a, $00, $40, $4d, TREASURE_GORONADE_SUBID_00
	m_TreasureSubid $10, $00, $ff, $4d, TREASURE_GORONADE_SUBID_01

treasureObjectData5e:
	m_BeginTreasureSubids TREASURE_ROCK_BRISKET
	m_TreasureSubid $0a, $00, $3e, $4e, TREASURE_ROCK_BRISKET_SUBID_00
	m_TreasureSubid $10, $00, $3e, $4e, TREASURE_ROCK_BRISKET_SUBID_01

