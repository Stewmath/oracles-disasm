; These values get written to wCutsceneTrigger or wCutsceneIndex to start a cutscene.
;
; Values 0 and 1 aren't really cutscenes, the game is set to those values during normal
; gameplay.
;
; Cutscenes 0-5 are the same for both games?

; Ages
.enum 0
	CUTSCENE_00			db ; 0x00
	CUTSCENE_01			db ; 0x01
	CUTSCENE_02			db ; 0x02
	CUTSCENE_03			db ; 0x03
	CUTSCENE_04			db ; 0x04
	CUTSCENE_05			db ; 0x05
	CUTSCENE_NAYRU_SINGING		db ; 0x06
	CUTSCENE_07			db ; 0x07
	CUTSCENE_08			db ; 0x08
	CUTSCENE_09			db ; 0x09
	CUTSCENE_0a			db ; 0x0a
	CUTSCENE_0b			db ; 0x0b
	CUTSCENE_0c			db ; 0x0c
	CUTSCENE_0d			db ; 0x0d
	CUTSCENE_0e			db ; 0x0e
	CUTSCENE_0f			db ; 0x0f
	CUTSCENE_10			db ; 0x10
	CUTSCENE_11			db ; 0x11
	CUTSCENE_12			db ; 0x12
	CUTSCENE_13			db ; 0x13
	CUTSCENE_14			db ; 0x14
	CUTSCENE_15			db ; 0x15
	CUTSCENE_16			db ; 0x16: Triggered on using gale seeds?
	CUTSCENE_17			db ; 0x17
	CUTSCENE_18			db ; 0x18
	CUTSCENE_19			db ; 0x19
	CUTSCENE_D2_COLLAPSE		db ; 0x1a: Wing dungeon collapse in present
	CUTSCENE_TIMEWARP		db ; 0x1b
	CUTSCENE_AMBI_PASSAGE_OPEN	db ; 0x1c
	CUTSCENE_JABU_OPEN		db ; 0x1d
	CUTSCENE_1e			db ; 0x1e
	CUTSCENE_1f			db ; 0x1f
	CUTSCENE_20			db ; 0x20
	CUTSCENE_21			db ; 0x21
.ende

; Seasons
.enum 0
	CUTSCENE_S_00			db ; 0x00
	CUTSCENE_S_01			db ; 0x01
	CUTSCENE_S_02			db ; 0x02
	CUTSCENE_S_03			db ; 0x03
	CUTSCENE_S_04			db ; 0x04
	CUTSCENE_S_05			db ; 0x05
	CUTSCENE_S_06			db ; 0x06
	CUTSCENE_S_07			db ; 0x07
	CUTSCENE_S_08			db ; 0x08
	CUTSCENE_S_09			db ; 0x09
	CUTSCENE_S_0a			db ; 0x0a
	CUTSCENE_S_0b			db ; 0x0b
	CUTSCENE_S_0c			db ; 0x0c
	CUTSCENE_S_0d			db ; 0x0d
	CUTSCENE_S_0e			db ; 0x0e
	CUTSCENE_S_0f			db ; 0x0f
	CUTSCENE_S_10			db ; 0x10
	CUTSCENE_S_11			db ; 0x11
	CUTSCENE_S_12			db ; 0x12
	CUTSCENE_S_ONOX_FINAL_FORM	db ; 0x13
	CUTSCENE_S_14			db ; 0x14
	CUTSCENE_S_15			db ; 0x15
	CUTSCENE_S_16			db ; 0x16
	CUTSCENE_S_17			db ; 0x17
	CUTSCENE_S_18			db ; 0x18
	CUTSCENE_S_19			db ; 0x19
.ende
