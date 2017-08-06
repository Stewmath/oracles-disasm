; These values get written to wCutsceneTrigger or wCutsceneIndex to start a cutscene.
;
; Values 0 and 1 aren't really cutscenes, the game is set to those values during normal
; gameplay.
;
; Cutscenes 0-5 are the same for both games?

; Ages
.enum 0
	CUTSCENE_LOADING_ROOM		db ; 0x00
	CUTSCENE_INGAME			db ; 0x01
	CUTSCENE_02			db ; 0x02
	CUTSCENE_03			db ; 0x03
	CUTSCENE_04			db ; 0x04
	CUTSCENE_05			db ; 0x05
	CUTSCENE_NAYRU_SINGING		db ; 0x06
	CUTSCENE_MAKU_TREE_DISAPPEARING	db ; 0x07
	CUTSCENE_BLACK_TOWER_EXPLANATION	db ; 0x08
	CUTSCENE_BLACK_TOWER_ESCAPE	db ; 0x09: Plays after beating Veran
	CUTSCENE_CREDITS		db ; 0x0a
	CUTSCENE_ANCIENT_TOMB_WALL	db ; 0x0b:  wall retracts
	CUTSCENE_NAYRU_WARP_TO_MAKU_TREE db ; 0x0c: link, ralph, nayru warp to maku tree
	CUTSCENE_PREGAME_INTRO		db ; 0x0d: "Accept our quest, hero!"
	CUTSCENE_TWINROVA_REVEAL	db ; 0x0e: Twinrova taunts Link at maku tree
	CUTSCENE_ROOM_OF_RITES_COLLAPSE	db ; 0x0f: Plays after talking to Zelda
	CUTSCENE_TURN_TO_STONE		db ; 0x10: Posessed Ambi turns people to stone
	CUTSCENE_FLAME_OF_SORROW	db ; 0x11: Flame is lit after beating Veran
	CUTSCENE_ZELDA_KIDNAPPED	db ; 0x12: Zelda kidnapped by Twinrova
	CUTSCENE_FAIRIES_HIDE		db ; 0x13: Hide & seek minigame
	CUTSCENE_BOOTED_FROM_PALACE	db ; 0x14: "You can't come in without permission!"
	CUTSCENE_15			db ; 0x15
	CUTSCENE_16			db ; 0x16: Triggers on using gale seeds?
	CUTSCENE_WARP_TO_TWINROVA_FIGHT	db ; 0x17: Triggers after approaching Zelda
	CUTSCENE_FLAMES_FLICKERING	db ; 0x18: Flames turn blue before Twinrova fight
	CUTSCENE_TWINROVA_SACRIFICE	db ; 0x19
	CUTSCENE_D2_COLLAPSE		db ; 0x1a: Wing dungeon collapse in present
	CUTSCENE_TIMEWARP		db ; 0x1b
	CUTSCENE_AMBI_PASSAGE_OPEN	db ; 0x1c
	CUTSCENE_JABU_OPEN		db ; 0x1d
	CUTSCENE_CLEAN_SEAS		db ; 0x1e
	CUTSCENE_BLACK_TOWER_ESCAPE_ATTEMPT	db ; 0x1f: Triggers after Veran phase 2
	CUTSCENE_FLAME_OF_DESPAIR	db ; 0x20: The final flame is lit
	CUTSCENE_BLACK_TOWER_COMPLETE	db ; 0x21
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
