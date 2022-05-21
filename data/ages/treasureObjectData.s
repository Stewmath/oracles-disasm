m_section_free TreasureObjectData NAMESPACE treasureData

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
;       corresponding value for interaction $60 in data/{game}/interactionData.s.)
;
; The macro takes a final parameter, which will be the name to give this new subid of the treasure
; index. This name will resolve to a 4-digit hex number (XXYY, where XX = treasure index and YY
; = subid).
;
; For documentation of spawn modes and grab modes, see "constants/treasureSpawnModes.s".
;
; See also constants/treasure.s for treasure lists.


.macro m_BeginTreasureSubids
	.redefine CURRENT_TREASURE_INDEX, (\1)<<8
.endm

.macro m_TreasureSubid
	.db \1, \2, \3, \4

	.IF CURRENT_TREASURE_INDEX >= $10000
		; Within the "treasureObjectData" table, "CURRENT_TREASURE_INDEX" corresponds to
		; values from "constants/treasure.s". (We add $10000 just to make it easy to
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
	.db $80
	.dw \1
	.db $00

	.redefine CURRENT_TREASURE_INDEX, CURRENT_TREASURE_INDEX+1
.endm


.define CURRENT_TREASURE_INDEX $10000

treasureObjectData:
	/* $00 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_NONE_00
	/* $01 */ m_TreasurePointer treasureObjectData01
	/* $02 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_PUNCH_00
	/* $03 */ m_TreasurePointer treasureObjectData03
	/* $04 */ m_TreasureSubid   $38, $00, $73, $17, TREASURE_OBJECT_CANE_OF_SOMARIA_00
	/* $05 */ m_TreasurePointer treasureObjectData05
	/* $06 */ m_TreasurePointer treasureObjectData06
	/* $07 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_ROD_OF_SEASONS_00
	/* $08 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_MAGNET_GLOVES_00
	/* $09 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_SWITCH_HOOK_HELPER_00
	/* $0a */ m_TreasurePointer treasureObjectData0a
	/* $0b */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_SWITCH_HOOK_CHAIN_00
	/* $0c */ m_TreasurePointer treasureObjectData0c
	/* $0d */ m_TreasurePointer treasureObjectData0d
	/* $0e */ m_TreasurePointer treasureObjectData0e
	/* $0f */ m_TreasureSubid   $38, $01, $2e, $21, TREASURE_OBJECT_SHOOTER_00
	/* $10 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_10_00
	/* $11 */ m_TreasurePointer treasureObjectData11
	/* $12 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_12_00
	/* $13 */ m_TreasurePointer $0000
	/* $14 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_14_00
	/* $15 */ m_TreasurePointer treasureObjectData15
	/* $16 */ m_TreasurePointer treasureObjectData16
	/* $17 */ m_TreasurePointer treasureObjectData17
	/* $18 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_18_00
	/* $19 */ m_TreasurePointer treasureObjectData19
	/* $1a */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_1a_00
	/* $1b */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_1b_00
	/* $1c */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_1c_00
	/* $1d */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_MINECART_COLLISION_00
	/* $1e */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_FOOLS_ORE_00
	/* $1f */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_1f_00
	/* $20 */ m_TreasurePointer treasureObjectData20
	/* $21 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_SCENT_SEEDS_00
	/* $22 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_PEGASUS_SEEDS_00
	/* $23 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_GALE_SEEDS_00
	/* $24 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_MYSTERY_SEEDS_00
	/* $25 */ m_TreasureSubid   $68, $00, $72, $69, TREASURE_OBJECT_TUNE_OF_ECHOES_00
	/* $26 */ m_TreasureSubid   $0a, $00, $0a, $6a, TREASURE_OBJECT_TUNE_OF_CURRENTS_00
	/* $27 */ m_TreasureSubid   $0a, $00, $0b, $6b, TREASURE_OBJECT_TUNE_OF_AGES_00
	/* $28 */ m_TreasurePointer treasureObjectData28
	/* $29 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_HEART_REFILL_00
	/* $2a */ m_TreasurePointer treasureObjectData2a
	/* $2b */ m_TreasurePointer treasureObjectData2b
	/* $2c */ m_TreasurePointer treasureObjectData2c
	/* $2d */ m_TreasurePointer treasureObjectData2d
	/* $2e */ m_TreasurePointer treasureObjectData2e
	/* $2f */ m_TreasureSubid   $02, $00, $ff, $30, TREASURE_OBJECT_POTION_00
	/* $30 */ m_TreasurePointer treasureObjectData30
	/* $31 */ m_TreasurePointer treasureObjectData31
	/* $32 */ m_TreasurePointer treasureObjectData32
	/* $33 */ m_TreasurePointer treasureObjectData33
	/* $34 */ m_TreasurePointer treasureObjectData34
	/* $35 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_35_00
	/* $36 */ m_TreasureSubid   $02, $00, $33, $4f, TREASURE_OBJECT_MAKU_SEED_00
	/* $37 */ m_TreasureSubid   $02, $0b, $6b, $2f, TREASURE_OBJECT_ORE_CHUNKS_00
	/* $38 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_38_00
	/* $39 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_39_00
	/* $3a */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_3a_00
	/* $3b */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_3b_00
	/* $3c */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_3c_00
	/* $3d */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_3d_00
	/* $3e */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_3e_00
	/* $3f */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_3f_00
	/* $40 */ m_TreasurePointer $0000
	/* $41 */ m_TreasurePointer treasureObjectData41
	/* $42 */ m_TreasureSubid   $29, $00, $23, $44, TREASURE_OBJECT_GRAVEYARD_KEY_00
	/* $43 */ m_TreasureSubid   $09, $00, $3d, $45, TREASURE_OBJECT_CROWN_KEY_00
	/* $44 */ m_TreasureSubid   $09, $00, $42, $46, TREASURE_OBJECT_MERMAID_KEY_00
	/* $45 */ m_TreasurePointer treasureObjectData45
	/* $46 */ m_TreasureSubid   $02, $00, $44, $48, TREASURE_OBJECT_LIBRARY_KEY_00
	/* $47 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_47_00
	/* $48 */ m_TreasureSubid   $51, $01, $67, $55, TREASURE_OBJECT_RICKY_GLOVES_00
	/* $49 */ m_TreasurePointer treasureObjectData49
	/* $4a */ m_TreasureSubid   $38, $00, $36, $27, TREASURE_OBJECT_MERMAID_SUIT_00
	/* $4b */ m_TreasureSubid   $38, $00, $48, $50, TREASURE_OBJECT_SLATE_00
	/* $4c */ m_TreasurePointer treasureObjectData4c
	/* $4d */ m_TreasureSubid   $0a, $00, $0d, $3e, TREASURE_OBJECT_SCENT_SEEDLING_00
	/* $4e */ m_TreasureSubid   $0a, $00, $47, $51, TREASURE_OBJECT_ZORA_SCALE_00
	/* $4f */ m_TreasureSubid   $0a, $00, $56, $53, TREASURE_OBJECT_TOKAY_EYEBALL_00
	/* $50 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_EMPTY_BOTTLE_00
	/* $51 */ m_TreasureSubid   $0a, $00, $55, $58, TREASURE_OBJECT_FAIRY_POWDER_00
	/* $52 */ m_TreasureSubid   $0a, $00, $7d, $3c, TREASURE_OBJECT_CHEVAL_ROPE_00
	/* $53 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_MEMBERS_CARD_00
	/* $54 */ m_TreasureSubid   $0a, $00, $7c, $26, TREASURE_OBJECT_ISLAND_CHART_00
	/* $55 */ m_TreasureSubid   $0a, $00, $4e, $52, TREASURE_OBJECT_BOOK_OF_SEALS_00
	/* $56 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_56_00
	/* $57 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_57_00
	/* $58 */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_BOMB_FLOWER_LOWER_HALF_00
	/* $59 */ m_TreasureSubid   $02, $00, $4a, $49, TREASURE_OBJECT_GORON_LETTER_00
	/* $5a */ m_TreasureSubid   $0a, $00, $41, $4a, TREASURE_OBJECT_LAVA_JUICE_00
	/* $5b */ m_TreasureSubid   $0a, $00, $0c, $4b, TREASURE_OBJECT_BROTHER_EMBLEM_00
	/* $5c */ m_TreasureSubid   $0a, $00, $3f, $4c, TREASURE_OBJECT_GORON_VASE_00
	/* $5d */ m_TreasurePointer treasureObjectData5d
	/* $5e */ m_TreasurePointer treasureObjectData5e
	/* $5f */ m_TreasureSubid   $00, $00, $ff, $00, TREASURE_OBJECT_5f_00
	/* $60 */ m_TreasureSubid   $0c, $00, $ff, $57, TREASURE_OBJECT_60_00
	/* $61 */ m_TreasureSubid   $02, $00, $6e, $05, TREASURE_OBJECT_BOMB_UPGRADE_00
	/* $62 */ m_TreasureSubid   $02, $00, $46, $20, TREASURE_OBJECT_SATCHEL_UPGRADE_00


treasureObjectData01:
	m_BeginTreasureSubids TREASURE_SHIELD
	m_TreasureSubid $0a, $01, $1f, $13, TREASURE_OBJECT_SHIELD_00
	m_TreasureSubid $0a, $02, $20, $14, TREASURE_OBJECT_SHIELD_01
	m_TreasureSubid $0a, $03, $21, $15, TREASURE_OBJECT_SHIELD_02
	m_TreasureSubid $0a, $03, $ff, $15, TREASURE_OBJECT_SHIELD_03

treasureObjectData03:
	m_BeginTreasureSubids TREASURE_BOMBS
	m_TreasureSubid $38, $10, $4d, $05, TREASURE_OBJECT_BOMBS_00
	m_TreasureSubid $30, $10, $4d, $05, TREASURE_OBJECT_BOMBS_01
	m_TreasureSubid $02, $10, $4d, $05, TREASURE_OBJECT_BOMBS_02
	m_TreasureSubid $38, $30, $4d, $05, TREASURE_OBJECT_BOMBS_03
	m_TreasureSubid $09, $00, $76, $05, TREASURE_OBJECT_BOMBS_04
	m_TreasureSubid $02, $20, $7e, $05, TREASURE_OBJECT_BOMBS_05

treasureObjectData05:
	m_BeginTreasureSubids TREASURE_SWORD
	m_TreasureSubid $09, $01, $1c, $10, TREASURE_OBJECT_SWORD_00
	m_TreasureSubid $09, $02, $1d, $11, TREASURE_OBJECT_SWORD_01
	m_TreasureSubid $09, $03, $1e, $12, TREASURE_OBJECT_SWORD_02
	m_TreasureSubid $03, $01, $ff, $10, TREASURE_OBJECT_SWORD_03
	m_TreasureSubid $03, $02, $ff, $11, TREASURE_OBJECT_SWORD_04
	m_TreasureSubid $03, $03, $ff, $12, TREASURE_OBJECT_SWORD_05
	m_TreasureSubid $01, $01, $75, $10, TREASURE_OBJECT_SWORD_06

treasureObjectData06:
	m_BeginTreasureSubids TREASURE_BOOMERANG
	m_TreasureSubid $0a, $01, $22, $1c, TREASURE_OBJECT_BOOMERANG_00
	m_TreasureSubid $10, $01, $22, $1c, TREASURE_OBJECT_BOOMERANG_01
	m_TreasureSubid $02, $01, $22, $1c, TREASURE_OBJECT_BOOMERANG_02

treasureObjectData0a:
	m_BeginTreasureSubids TREASURE_SWITCH_HOOK
	m_TreasureSubid $38, $01, $30, $1f, TREASURE_OBJECT_SWITCH_HOOK_00
	m_TreasureSubid $38, $02, $28, $1f, TREASURE_OBJECT_SWITCH_HOOK_01

treasureObjectData0c:
	m_BeginTreasureSubids TREASURE_BIGGORON_SWORD
	m_TreasureSubid $02, $00, $6f, $25, TREASURE_OBJECT_BIGGORON_SWORD_00
	m_TreasureSubid $30, $00, $6f, $25, TREASURE_OBJECT_BIGGORON_SWORD_01

treasureObjectData0d:
	m_BeginTreasureSubids TREASURE_BOMBCHUS
	m_TreasureSubid $0a, $10, $32, $24, TREASURE_OBJECT_BOMBCHUS_00
	m_TreasureSubid $30, $10, $32, $24, TREASURE_OBJECT_BOMBCHUS_01
	m_TreasureSubid $02, $10, $32, $24, TREASURE_OBJECT_BOMBCHUS_02

treasureObjectData0e:
	m_BeginTreasureSubids TREASURE_FLUTE
	m_TreasureSubid $0a, $0b, $3b, $23, TREASURE_OBJECT_FLUTE_00
	m_TreasureSubid $0a, $0c, $3b, $23, TREASURE_OBJECT_FLUTE_01
	m_TreasureSubid $0a, $0d, $3b, $23, TREASURE_OBJECT_FLUTE_02

treasureObjectData11:
	m_BeginTreasureSubids TREASURE_HARP
	m_TreasureSubid $0a, $00, $71, $68, TREASURE_OBJECT_HARP_00
	m_TreasureSubid $0a, $01, $78, $68, TREASURE_OBJECT_HARP_01

treasureObjectData15:
	m_BeginTreasureSubids TREASURE_SHOVEL
	m_TreasureSubid $0a, $00, $25, $1b, TREASURE_OBJECT_SHOVEL_00
	m_TreasureSubid $0a, $00, $74, $1b, TREASURE_OBJECT_SHOVEL_01
	m_TreasureSubid $0a, $00, $25, $1b, TREASURE_OBJECT_SHOVEL_02

treasureObjectData16:
	m_BeginTreasureSubids TREASURE_BRACELET
	m_TreasureSubid $0a, $01, $26, $19, TREASURE_OBJECT_BRACELET_00
	m_TreasureSubid $0a, $01, $77, $19, TREASURE_OBJECT_BRACELET_01
	m_TreasureSubid $38, $02, $2f, $1a, TREASURE_OBJECT_BRACELET_02
	m_TreasureSubid $0a, $01, $26, $19, TREASURE_OBJECT_BRACELET_03

treasureObjectData17:
	m_BeginTreasureSubids TREASURE_FEATHER
	m_TreasureSubid $0a, $01, $27, $16, TREASURE_OBJECT_FEATHER_00
	m_TreasureSubid $0a, $01, $79, $16, TREASURE_OBJECT_FEATHER_01
	m_TreasureSubid $0a, $01, $27, $16, TREASURE_OBJECT_FEATHER_02

treasureObjectData19:
	m_BeginTreasureSubids TREASURE_SEED_SATCHEL
	m_TreasureSubid $0a, $01, $2d, $20, TREASURE_OBJECT_SEED_SATCHEL_00
	m_TreasureSubid $0a, $00, $7b, $20, TREASURE_OBJECT_SEED_SATCHEL_01
	m_TreasureSubid $29, $00, $2d, $20, TREASURE_OBJECT_SEED_SATCHEL_02
	m_TreasureSubid $09, $00, $2d, $20, TREASURE_OBJECT_SEED_SATCHEL_03
	m_TreasureSubid $01, $00, $80, $20, TREASURE_OBJECT_SEED_SATCHEL_UPGRADE

treasureObjectData20:
	m_BeginTreasureSubids TREASURE_EMBER_SEEDS
	m_TreasureSubid $30, $04, $4f, $06, TREASURE_OBJECT_EMBER_SEEDS_00

treasureObjectData34:
	m_BeginTreasureSubids TREASURE_GASHA_SEED
	m_TreasureSubid $02, $01, $4b, $0d, TREASURE_OBJECT_GASHA_SEED_00
	m_TreasureSubid $38, $01, $4b, $0d, TREASURE_OBJECT_GASHA_SEED_01
	m_TreasureSubid $52, $01, $4b, $0d, TREASURE_OBJECT_GASHA_SEED_02
	m_TreasureSubid $02, $01, $4b, $0d, TREASURE_OBJECT_GASHA_SEED_03
	m_TreasureSubid $0a, $01, $4b, $0d, TREASURE_OBJECT_GASHA_SEED_04
	m_TreasureSubid $4a, $01, $4b, $0d, TREASURE_OBJECT_GASHA_SEED_05
	m_TreasureSubid $10, $01, $4b, $0d, TREASURE_OBJECT_GASHA_SEED_06
	m_TreasureSubid $0a, $01, $4b, $0d, TREASURE_OBJECT_GASHA_SEED_07
	m_TreasureSubid $0a, $01, $4b, $0d, TREASURE_OBJECT_GASHA_SEED_08

treasureObjectData28:
	m_BeginTreasureSubids TREASURE_RUPEES
	m_TreasureSubid $38, $01, $01, $28, TREASURE_OBJECT_RUPEES_00
	m_TreasureSubid $38, $03, $02, $29, TREASURE_OBJECT_RUPEES_01
	m_TreasureSubid $38, $04, $03, $2a, TREASURE_OBJECT_RUPEES_02
	m_TreasureSubid $38, $05, $04, $2b, TREASURE_OBJECT_RUPEES_03
	m_TreasureSubid $38, $07, $05, $2b, TREASURE_OBJECT_RUPEES_04
	m_TreasureSubid $38, $0b, $06, $2c, TREASURE_OBJECT_RUPEES_05
	m_TreasureSubid $38, $0c, $07, $2d, TREASURE_OBJECT_RUPEES_06
	m_TreasureSubid $38, $0f, $08, $2d, TREASURE_OBJECT_RUPEES_07
	m_TreasureSubid $38, $0d, $09, $2e, TREASURE_OBJECT_RUPEES_08
	m_TreasureSubid $30, $01, $01, $28, TREASURE_OBJECT_RUPEES_09
	m_TreasureSubid $18, $01, $ff, $2e, TREASURE_OBJECT_RUPEES_0a
	m_TreasureSubid $08, $05, $ff, $2b, TREASURE_OBJECT_RUPEES_0b
	m_TreasureSubid $08, $07, $05, $2b, TREASURE_OBJECT_RUPEES_0c
	m_TreasureSubid $30, $04, $03, $2a, TREASURE_OBJECT_RUPEES_0d
	m_TreasureSubid $01, $05, $04, $2b, TREASURE_OBJECT_RUPEES_0e
	m_TreasureSubid $01, $0b, $06, $2c, TREASURE_OBJECT_RUPEES_0f
	m_TreasureSubid $01, $0c, $07, $2d, TREASURE_OBJECT_RUPEES_10
	m_TreasureSubid $10, $0b, $06, $2c, TREASURE_OBJECT_RUPEES_11
	m_TreasureSubid $10, $0c, $07, $2d, TREASURE_OBJECT_RUPEES_12
	m_TreasureSubid $10, $07, $05, $2b, TREASURE_OBJECT_RUPEES_13
	m_TreasureSubid $00, $04, $ff, $2a, TREASURE_OBJECT_RUPEES_14
	m_TreasureSubid $00, $01, $ff, $28, TREASURE_OBJECT_RUPEES_15
	m_TreasureSubid $0a, $0d, $09, $2e, TREASURE_OBJECT_RUPEES_16

treasureObjectData2b:
	m_BeginTreasureSubids TREASURE_HEART_PIECE
	m_TreasureSubid $0a, $01, $17, $3a, TREASURE_OBJECT_HEART_PIECE_00
	m_TreasureSubid $38, $01, $17, $3a, TREASURE_OBJECT_HEART_PIECE_01
	m_TreasureSubid $02, $01, $17, $3a, TREASURE_OBJECT_HEART_PIECE_02

treasureObjectData2a:
	m_BeginTreasureSubids TREASURE_HEART_CONTAINER
	m_TreasureSubid $1a, $04, $16, $3b, TREASURE_OBJECT_HEART_CONTAINER_00
	m_TreasureSubid $30, $04, $16, $3b, TREASURE_OBJECT_HEART_CONTAINER_01
	m_TreasureSubid $02, $04, $16, $3b, TREASURE_OBJECT_HEART_CONTAINER_02

treasureObjectData2c:
	m_BeginTreasureSubids TREASURE_RING_BOX
	m_TreasureSubid $02, $01, $57, $33, TREASURE_OBJECT_RING_BOX_00
	m_TreasureSubid $02, $02, $34, $34, TREASURE_OBJECT_RING_BOX_01
	m_TreasureSubid $02, $03, $34, $35, TREASURE_OBJECT_RING_BOX_02
	m_TreasureSubid $02, $02, $58, $34, TREASURE_OBJECT_RING_BOX_03
.ifndef ENABLE_US_BUGFIXES
	; BUG: Ring box from some source (farore?) gives L-2 ring box instead of L-3
	m_TreasureSubid $02, $02, $59, $35, TREASURE_OBJECT_RING_BOX_04
.else
	m_TreasureSubid $02, $03, $59, $35, TREASURE_OBJECT_RING_BOX_04
.endif

treasureObjectData2d:
	m_BeginTreasureSubids TREASURE_RING
	m_TreasureSubid $09, $ff, $54, $0e, TREASURE_OBJECT_RING_00
	m_TreasureSubid $29, $ff, $54, $0e, TREASURE_OBJECT_RING_01
	m_TreasureSubid $49, $ff, $54, $0e, TREASURE_OBJECT_RING_02
	m_TreasureSubid $59, $ff, $54, $0e, TREASURE_OBJECT_RING_03
	m_TreasureSubid $38, $28, $54, $0e, TREASURE_OBJECT_RING_04
	m_TreasureSubid $38, $2b, $54, $0e, TREASURE_OBJECT_RING_05
	m_TreasureSubid $38, $10, $54, $0e, TREASURE_OBJECT_RING_06
	m_TreasureSubid $38, $0c, $54, $0e, TREASURE_OBJECT_RING_07
	m_TreasureSubid $38, $0d, $54, $0e, TREASURE_OBJECT_RING_08
	m_TreasureSubid $38, $2a, $54, $0e, TREASURE_OBJECT_RING_09
	m_TreasureSubid $38, $23, $54, $0e, TREASURE_OBJECT_RING_0a
	m_TreasureSubid $38, $05, $54, $0e, TREASURE_OBJECT_RING_0b
	m_TreasureSubid $30, $15, $54, $0e, TREASURE_OBJECT_RING_0c
	m_TreasureSubid $30, $13, $54, $0e, TREASURE_OBJECT_RING_0d
	m_TreasureSubid $38, $01, $54, $0e, TREASURE_OBJECT_RING_0e
	m_TreasureSubid $38, $03, $54, $0e, TREASURE_OBJECT_RING_0f
	m_TreasureSubid $38, $2d, $54, $0e, TREASURE_OBJECT_RING_10
	m_TreasureSubid $38, $1d, $54, $0e, TREASURE_OBJECT_RING_11
	m_TreasureSubid $10, $12, $ff, $0e, TREASURE_OBJECT_RING_12
	m_TreasureSubid $10, $23, $ff, $0e, TREASURE_OBJECT_RING_13
	m_TreasureSubid $01, $12, $54, $0e, TREASURE_OBJECT_RING_14
	m_TreasureSubid $01, $23, $54, $0e, TREASURE_OBJECT_RING_15
	m_TreasureSubid $38, $26, $54, $0e, TREASURE_OBJECT_RING_16
	m_TreasureSubid $38, $04, $54, $0e, TREASURE_OBJECT_RING_17
	m_TreasureSubid $38, $32, $54, $0e, TREASURE_OBJECT_RING_18
	m_TreasureSubid $38, $17, $54, $0e, TREASURE_OBJECT_RING_19
	m_TreasureSubid $38, $1b, $54, $0e, TREASURE_OBJECT_RING_1a
	m_TreasureSubid $38, $02, $54, $0e, TREASURE_OBJECT_RING_1b
	m_TreasureSubid $38, $1c, $54, $0e, TREASURE_OBJECT_RING_1c
	m_TreasureSubid $38, $22, $54, $0e, TREASURE_OBJECT_RING_1d
	m_TreasureSubid $38, $11, $54, $0e, TREASURE_OBJECT_RING_1e
	m_TreasureSubid $38, $06, $54, $0e, TREASURE_OBJECT_RING_1f
	m_TreasureSubid $38, $1a, $54, $0e, TREASURE_OBJECT_RING_20
	m_TreasureSubid $38, $1e, $54, $0e, TREASURE_OBJECT_RING_21
	m_TreasureSubid $38, $20, $54, $0e, TREASURE_OBJECT_RING_22
	m_TreasureSubid $38, $39, $54, $0e, TREASURE_OBJECT_RING_23
	m_TreasureSubid $38, $0f, $54, $0e, TREASURE_OBJECT_RING_24
	m_TreasureSubid $38, $3e, $54, $0e, TREASURE_OBJECT_RING_25
	m_TreasureSubid $38, $12, $54, $0e, TREASURE_OBJECT_RING_26
	m_TreasureSubid $38, $08, $54, $0e, TREASURE_OBJECT_RING_27
	m_TreasureSubid $38, $2c, $54, $0e, TREASURE_OBJECT_RING_28

treasureObjectData2e:
	m_BeginTreasureSubids TREASURE_FLIPPERS
	m_TreasureSubid $0a, $00, $31, $31, TREASURE_OBJECT_FLIPPERS_00
	m_TreasureSubid $0a, $00, $7a, $31, TREASURE_OBJECT_FLIPPERS_01

treasureObjectData30:
	m_BeginTreasureSubids TREASURE_SMALL_KEY
	m_TreasureSubid $18, $01, $ff, $42, TREASURE_OBJECT_SMALL_KEY_00
	m_TreasureSubid $28, $01, $ff, $42, TREASURE_OBJECT_SMALL_KEY_01
	m_TreasureSubid $49, $01, $1a, $42, TREASURE_OBJECT_SMALL_KEY_02
	m_TreasureSubid $38, $01, $1a, $42, TREASURE_OBJECT_SMALL_KEY_03

treasureObjectData31:
	m_BeginTreasureSubids TREASURE_BOSS_KEY
	m_TreasureSubid $19, $00, $1b, $43, TREASURE_OBJECT_BOSS_KEY_00
	m_TreasureSubid $29, $00, $1b, $43, TREASURE_OBJECT_BOSS_KEY_01
	m_TreasureSubid $49, $00, $1b, $43, TREASURE_OBJECT_BOSS_KEY_02
	m_TreasureSubid $38, $00, $1b, $43, TREASURE_OBJECT_BOSS_KEY_03

treasureObjectData32:
	m_BeginTreasureSubids TREASURE_COMPASS
	m_TreasureSubid $1a, $00, $19, $41, TREASURE_OBJECT_COMPASS_00
	m_TreasureSubid $2a, $00, $19, $41, TREASURE_OBJECT_COMPASS_01
	m_TreasureSubid $68, $00, $19, $41, TREASURE_OBJECT_COMPASS_02

treasureObjectData33:
	m_BeginTreasureSubids TREASURE_MAP
	m_TreasureSubid $1a, $00, $18, $40, TREASURE_OBJECT_MAP_00
	m_TreasureSubid $2a, $00, $18, $40, TREASURE_OBJECT_MAP_01
	m_TreasureSubid $68, $00, $18, $40, TREASURE_OBJECT_MAP_02

treasureObjectData41:
	m_BeginTreasureSubids TREASURE_TRADEITEM
	m_TreasureSubid $0a, $00, $5a, $70, TREASURE_OBJECT_TRADEITEM_00
	m_TreasureSubid $0a, $01, $5b, $71, TREASURE_OBJECT_TRADEITEM_01
	m_TreasureSubid $0a, $02, $5c, $72, TREASURE_OBJECT_TRADEITEM_02
	m_TreasureSubid $0a, $03, $5d, $73, TREASURE_OBJECT_TRADEITEM_03
	m_TreasureSubid $0a, $04, $5e, $74, TREASURE_OBJECT_TRADEITEM_04
	m_TreasureSubid $0a, $05, $5f, $75, TREASURE_OBJECT_TRADEITEM_05
	m_TreasureSubid $0a, $06, $60, $76, TREASURE_OBJECT_TRADEITEM_06
	m_TreasureSubid $0a, $07, $61, $77, TREASURE_OBJECT_TRADEITEM_07
	m_TreasureSubid $0a, $08, $62, $78, TREASURE_OBJECT_TRADEITEM_08
	m_TreasureSubid $0a, $09, $63, $79, TREASURE_OBJECT_TRADEITEM_09
	m_TreasureSubid $0a, $0a, $64, $7a, TREASURE_OBJECT_TRADEITEM_0a
	m_TreasureSubid $0a, $0b, $65, $7b, TREASURE_OBJECT_TRADEITEM_0b

treasureObjectData45:
	m_BeginTreasureSubids TREASURE_OLD_MERMAID_KEY
	m_TreasureSubid $09, $00, $43, $47, TREASURE_OBJECT_OLD_MERMAID_KEY_00
	m_TreasureSubid $19, $00, $43, $47, TREASURE_OBJECT_OLD_MERMAID_KEY_01

treasureObjectData49:
	m_BeginTreasureSubids TREASURE_BOMB_FLOWER
	m_TreasureSubid $0a, $00, $3c, $56, TREASURE_OBJECT_BOMB_FLOWER_00
	m_TreasureSubid $00, $00, $ff, $56, TREASURE_OBJECT_BOMB_FLOWER_01

treasureObjectData4c:
	m_BeginTreasureSubids TREASURE_TUNI_NUT
	m_TreasureSubid $0a, $00, $37, $5b, TREASURE_OBJECT_TUNI_NUT_00
	m_TreasureSubid $0a, $02, $37, $5c, TREASURE_OBJECT_TUNI_NUT_01

treasureObjectData5d:
	m_BeginTreasureSubids TREASURE_GORONADE
	m_TreasureSubid $0a, $00, $40, $4d, TREASURE_OBJECT_GORONADE_00
	m_TreasureSubid $10, $00, $ff, $4d, TREASURE_OBJECT_GORONADE_01

treasureObjectData5e:
	m_BeginTreasureSubids TREASURE_ROCK_BRISKET
	m_TreasureSubid $0a, $00, $3e, $4e, TREASURE_OBJECT_ROCK_BRISKET_00
	m_TreasureSubid $10, $00, $3e, $4e, TREASURE_OBJECT_ROCK_BRISKET_01

.ends
