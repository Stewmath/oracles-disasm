; This many global flags aren't used, but there seems to be this much memory reserved.
.define NUM_GLOBALFLAGS $80

; Ages globalflags (TODO: wrap in ifdef)
.ENUM $0
	; First few globalflags are probably the same between games?
	GLOBALFLAG_1000_ENEMIES_KILLED		db ; $00
	GLOBALFLAG_10000_RUPEES_COLLECTED	db ; $01
	GLOBALFLAG_02				db ; $02
	GLOBALFLAG_03				db ; $03
	GLOBALFLAG_04				db ; $04
	GLOBALFLAG_05				db ; $05
	GLOBALFLAG_06				db ; $06
	GLOBALFLAG_07				db ; $07
	GLOBALFLAG_OBTAINED_RING_BOX		db ; $08
	GLOBALFLAG_100TH_RING_OBTAINED		db ; $09
	GLOBALFLAG_INTRO_DONE			db ; $0a
	GLOBALFLAG_0b				db ; $0b: Set when getting bombs from ambi
	GLOBALFLAG_0c				db ; $0c
	GLOBALFLAG_0d				db ; $0d
	GLOBALFLAG_0e				db ; $0e: Relates to getting companion from forest?
	GLOBALFLAG_D3_CRYSTALS			db ; $0f
	GLOBALFLAG_10				db ; $10: Set when ambi's guard escorts you?
	GLOBALFLAG_SAVED_NAYRU			db ; $11
	GLOBALFLAG_MAKU_TREE_SAVED		db ; $12

	; Got the maku seed, saw the twinrova cutscene right after
	GLOBALFLAG_GOT_MAKU_SEED				db ; $13

	GLOBALFLAG_FINISHEDGAME			db ; $14
	GLOBALFLAG_TALKED_TO_RAFTON		db ; $15
	GLOBALFLAG_16				db ; $16
	GLOBALFLAG_17				db ; $17
	GLOBALFLAG_18				db ; $18
	GLOBALFLAG_19				db ; $19
	GLOBALFLAG_1a				db ; $1a: Moblin's keep destroyed?
	GLOBALFLAG_1b				db ; $1b
	GLOBALFLAG_1c				db ; $1c
	GLOBALFLAG_1d				db ; $1d: Allows you to purchase a flute?
	GLOBALFLAG_1e				db ; $1e
	GLOBALFLAG_1f				db ; $1f
	GLOBALFLAG_TALKED_TO_OCTOROK_FAIRY	db ; $20
	GLOBALFLAG_PREGAME_INTRO_DONE		db ; $21
	GLOBALFLAG_22				db ; $22
	GLOBALFLAG_23				db ; $23
	GLOBALFLAG_24				db ; $24: saved dimitri on tokay island?
	GLOBALFLAG_SYMMETRY_BRIDGE_BUILT		db ; $25
	GLOBALFLAG_26				db ; $26: relates to the raft
	GLOBALFLAG_27				db ; $27
	GLOBALFLAG_28				db ; $28
	GLOBALFLAG_TUNI_NUT_PLACED				db ; $29
	GLOBALFLAG_2a				db ; $2a
	GLOBALFLAG_FOREST_UNSCRAMBLED		db ; $2b

	; This is set when a secret has been told to farore, and a chest has appeared, but
	; Link hasn't opened it yet. Farore won't talk to you until this flag is cleared.
	GLOBALFLAG_SECRET_CHEST_WAITING		db ; $2c

	GLOBALFLAG_2d				db ; $2d
	GLOBALFLAG_2e				db ; $2e
	GLOBALFLAG_2f				db ; $2f: Goron elder saved?
	GLOBALFLAG_WATER_POLLUTION_FIXED	db ; $30
	GLOBALFLAG_31				db ; $31
	GLOBALFLAG_RALPH_ENTERED_AMBIS_PALACE	db ; $32

	; The cutscene where Impa explains Ralph's heritage
	GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE	db ; $33

	GLOBALFLAG_PIRATES_GONE			db ; $34
	GLOBALFLAG_NO_FALL_ON_START		db ; $35
	GLOBALFLAG_36				db ; $36
	GLOBALFLAG_37				db ; $37
	GLOBALFLAG_GOT_RING_FROM_ZELDA		db ; $38
	GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED	db ; $39
	GLOBALFLAG_FLAME_OF_DESPAIR_LIT		db ; $3a: Beaten veran in a linked game
	GLOBALFLAG_RETURNED_DOG			db ; $3b
	GLOBALFLAG_ZELDA_SAVED_FROM_VIRE	db ; $3c
	GLOBALFLAG_3d				db ; $3d: "Link summoned" cutscene viewed
	GLOBALFLAG_3e				db ; $3e: Met present maku tree?
	GLOBALFLAG_3f				db ; $3f: Met past maku tree?
	GLOBALFLAG_RALPH_ENTERED_PORTAL		db ; $40
	GLOBALFLAG_ENTER_PAST_CUTSCENE_DONE	db ; $41: Saw cutscene with surprised npc
	GLOBALFLAG_42				db ; $42
	GLOBALFLAG_43				db ; $43
	GLOBALFLAG_44				db ; $44: Maple's been met in the past
	GLOBALFLAG_RALPH_ENTERED_BLACK_TOWER	db ; $45
	GLOBALFLAG_46				db ; $46

	; Unused?
	GLOBALFLAG_47				db ; $47
	GLOBALFLAG_48				db ; $48
	GLOBALFLAG_49				db ; $49
	GLOBALFLAG_4a				db ; $4a
	GLOBALFLAG_4b				db ; $4b
	GLOBALFLAG_4c				db ; $4c
	GLOBALFLAG_4d				db ; $4d
	GLOBALFLAG_4e				db ; $4e
	GLOBALFLAG_4f				db ; $4f

	; ==============================================================================
	; LINKED AGES SECRETS
	; ==============================================================================

	; Set when corresponding NPC is spoken to; allows Farore to accept the return
	; secret.
	GLOBALFLAG_50				db ; $50
	GLOBALFLAG_51				db ; $51
	GLOBALFLAG_52				db ; $52
	GLOBALFLAG_53				db ; $53
	GLOBALFLAG_54				db ; $54
	GLOBALFLAG_55				db ; $55
	GLOBALFLAG_56				db ; $56
	GLOBALFLAG_57				db ; $57
	GLOBALFLAG_58				db ; $58
	GLOBALFLAG_59				db ; $59

	; Set when the return secret has been entered.
	GLOBALFLAG_5a				db ; $5a
	GLOBALFLAG_5b				db ; $5b
	GLOBALFLAG_5c				db ; $5c
	GLOBALFLAG_5d				db ; $5d
	GLOBALFLAG_5e				db ; $5e
	GLOBALFLAG_5f				db ; $5f
	GLOBALFLAG_60				db ; $60
	GLOBALFLAG_61				db ; $61
	GLOBALFLAG_62				db ; $62
	GLOBALFLAG_63				db ; $63

	; ==============================================================================
	; LINKED SEASONS SECRETS
	; ==============================================================================

	; Set when corresponding NPC is told the secret, to begin the sidequest.
	GLOBALFLAG_64				db ; $64
	GLOBALFLAG_65				db ; $65
	GLOBALFLAG_66				db ; $66
	GLOBALFLAG_67				db ; $67
	GLOBALFLAG_68				db ; $68
	GLOBALFLAG_69				db ; $69
	GLOBALFLAG_6a				db ; $6a
	GLOBALFLAG_6b				db ; $6b
	GLOBALFLAG_6c				db ; $6c: told elder secret
	GLOBALFLAG_6d				db ; $6d

	; Set when the sidequest is completed and Link has obtained the item.
	GLOBALFLAG_6e				db ; $6e
	GLOBALFLAG_6f				db ; $6f
	GLOBALFLAG_70				db ; $70
	GLOBALFLAG_71				db ; $71
	GLOBALFLAG_72				db ; $72
	GLOBALFLAG_73				db ; $73
	GLOBALFLAG_74				db ; $74
	GLOBALFLAG_75				db ; $75
	GLOBALFLAG_76				db ; $76: completed elder secret
	GLOBALFLAG_77				db ; $77

	; Unused?
	GLOBALFLAG_78				db ; $78
	GLOBALFLAG_79				db ; $79
	GLOBALFLAG_7a				db ; $7a
	GLOBALFLAG_7b				db ; $7b
	GLOBALFLAG_7c				db ; $7c
	GLOBALFLAG_7d				db ; $7d
	GLOBALFLAG_7e				db ; $7e
	GLOBALFLAG_7f				db ; $7f
.ENDE


; Seasons globalflags
.ENUM $0
	GLOBALFLAG_S_00				db ; $00
	GLOBALFLAG_S_01				db ; $01
	GLOBALFLAG_S_02				db ; $02
	GLOBALFLAG_S_03				db ; $03
	GLOBALFLAG_S_04				db ; $04
	GLOBALFLAG_S_05				db ; $05
	GLOBALFLAG_S_06				db ; $06
	GLOBALFLAG_S_07				db ; $07
	GLOBALFLAG_S_08				db ; $08
	GLOBALFLAG_S_09				db ; $09
	GLOBALFLAG_S_INTRO_DONE			db ; $0a
	GLOBALFLAG_S_0b				db ; $0b: Set if on a date with Rosa?
	GLOBALFLAG_S_0c				db ; $0c
	GLOBALFLAG_S_0d				db ; $0d
	GLOBALFLAG_S_0e				db ; $0e
	GLOBALFLAG_S_0f				db ; $0f
	GLOBALFLAG_S_10				db ; $10
	GLOBALFLAG_S_11				db ; $11
	GLOBALFLAG_S_12				db ; $12
	GLOBALFLAG_S_13				db ; $13
	GLOBALFLAG_S_14				db ; $14
	GLOBALFLAG_S_15				db ; $15
	GLOBALFLAG_S_16				db ; $16: Moblin's keep destroyed?
	GLOBALFLAG_S_17				db ; $17: Pirate ship moved
	GLOBALFLAG_S_18				db ; $18: Met maku tree?
	GLOBALFLAG_S_19				db ; $19
	GLOBALFLAG_S_1a				db ; $1a
	GLOBALFLAG_S_1b				db ; $1b
	GLOBALFLAG_S_1c				db ; $1c
	GLOBALFLAG_S_1d				db ; $1d
	GLOBALFLAG_S_1e				db ; $1e
	GLOBALFLAG_S_1f				db ; $1f
	GLOBALFLAG_S_20				db ; $20
	GLOBALFLAG_S_PREGAME_INTRO_DONE		db ; $21
	GLOBALFLAG_S_22				db ; $22
	GLOBALFLAG_S_23				db ; $23
	GLOBALFLAG_S_24				db ; $24: Relates to outside Onox castle
	GLOBALFLAG_S_25				db ; $25
	GLOBALFLAG_S_26				db ; $26
	GLOBALFLAG_S_27				db ; $27
	GLOBALFLAG_S_28				db ; $28
	GLOBALFLAG_S_29				db ; $29
	GLOBALFLAG_S_2a				db ; $2a: same as GLOBALFLAG_3d?
	GLOBALFLAG_S_2b				db ; $2b
	GLOBALFLAG_S_2c				db ; $2c
	GLOBALFLAG_S_2d				db ; $2d
	GLOBALFLAG_S_2e				db ; $2e
	GLOBALFLAG_S_2f				db ; $2f
	GLOBALFLAG_S_30				db ; $30: game beaten / season always spring?
	GLOBALFLAG_S_31				db ; $31
	GLOBALFLAG_S_32				db ; $32
	GLOBALFLAG_S_33				db ; $33
	GLOBALFLAG_S_34				db ; $34
	GLOBALFLAG_S_35				db ; $35
	GLOBALFLAG_S_36				db ; $36
	GLOBALFLAG_S_37				db ; $37
	GLOBALFLAG_S_38				db ; $38
	GLOBALFLAG_S_39				db ; $39
	GLOBALFLAG_S_3a				db ; $3a
	GLOBALFLAG_S_3b				db ; $3b
	GLOBALFLAG_S_3c				db ; $3c
	GLOBALFLAG_S_3d				db ; $3d
	GLOBALFLAG_S_3e				db ; $3e
	GLOBALFLAG_S_3f				db ; $3f
	GLOBALFLAG_S_40				db ; $40
	GLOBALFLAG_S_41				db ; $41
	GLOBALFLAG_S_42				db ; $42
	GLOBALFLAG_S_43				db ; $43
	GLOBALFLAG_S_44				db ; $44
	GLOBALFLAG_S_45				db ; $45
	GLOBALFLAG_S_46				db ; $46
	GLOBALFLAG_S_47				db ; $47
	GLOBALFLAG_S_48				db ; $48
	GLOBALFLAG_S_49				db ; $49
	GLOBALFLAG_S_4a				db ; $4a
	GLOBALFLAG_S_4b				db ; $4b
	GLOBALFLAG_S_4c				db ; $4c
	GLOBALFLAG_S_4d				db ; $4d
	GLOBALFLAG_S_4e				db ; $4e
	GLOBALFLAG_S_4f				db ; $4f
	GLOBALFLAG_S_50				db ; $50
	GLOBALFLAG_S_51				db ; $51
	GLOBALFLAG_S_52				db ; $52
	GLOBALFLAG_S_53				db ; $53
	GLOBALFLAG_S_54				db ; $54
	GLOBALFLAG_S_55				db ; $55
	GLOBALFLAG_S_56				db ; $56
	GLOBALFLAG_S_57				db ; $57
	GLOBALFLAG_S_58				db ; $58
	GLOBALFLAG_S_59				db ; $59
	GLOBALFLAG_S_5a				db ; $5a
	GLOBALFLAG_S_5b				db ; $5b
	GLOBALFLAG_S_5c				db ; $5c
	GLOBALFLAG_S_5d				db ; $5d
	GLOBALFLAG_S_5e				db ; $5e
	GLOBALFLAG_S_5f				db ; $5f
	GLOBALFLAG_S_60				db ; $60
	GLOBALFLAG_S_61				db ; $61
	GLOBALFLAG_S_62				db ; $62
	GLOBALFLAG_S_63				db ; $63
	GLOBALFLAG_S_64				db ; $64
	GLOBALFLAG_S_65				db ; $65
	GLOBALFLAG_S_66				db ; $66
	GLOBALFLAG_S_67				db ; $67
	GLOBALFLAG_S_68				db ; $68
	GLOBALFLAG_S_69				db ; $69
	GLOBALFLAG_S_6a				db ; $6a
	GLOBALFLAG_S_6b				db ; $6b
	GLOBALFLAG_S_6c				db ; $6c
	GLOBALFLAG_S_6d				db ; $6d
	GLOBALFLAG_S_6e				db ; $6e
	GLOBALFLAG_S_6f				db ; $6f
	GLOBALFLAG_S_70				db ; $70
	GLOBALFLAG_S_71				db ; $71
	GLOBALFLAG_S_72				db ; $72
	GLOBALFLAG_S_73				db ; $73
	GLOBALFLAG_S_74				db ; $74
	GLOBALFLAG_S_75				db ; $75
	GLOBALFLAG_S_76				db ; $76
	GLOBALFLAG_S_77				db ; $77
	GLOBALFLAG_S_78				db ; $78
	GLOBALFLAG_S_79				db ; $79
	GLOBALFLAG_S_7a				db ; $7a
	GLOBALFLAG_S_7b				db ; $7b
	GLOBALFLAG_S_7c				db ; $7c
	GLOBALFLAG_S_7d				db ; $7d
	GLOBALFLAG_S_7e				db ; $7e
	GLOBALFLAG_S_7f				db ; $7f
.ende
