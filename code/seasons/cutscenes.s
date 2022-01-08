;;
; CUTSCENE_S_DIN_DANCING
cutscene06:
	ld e,$00
	jp multiIntroCutsceneCaller

;;
; CUTSCENE_S_DIN_IMPRISONED
cutscene07:
	ld e,$01
	call multiIntroCutsceneCaller
	call updateInteractionsAndDrawAllSprites
	jp updateAnimationsAfterCutscene

;;
; CUTSCENE_S_TEMPLE_SINKING
cutscene08:
	ld e,$02
	call multiIntroCutsceneCaller
	jp updateInteractionsAndDrawAllSprites

;;
; CUTSCENE_S_DIN_CRYSTAL_DESCENDING
cutscene09:
	call func_1613
	ld e,$00
	call endgameCutsceneHandler
	ld a,(wWarpTransition2)
	or a
	ret z
	jp applyWarpTransition2

;;
; CUTSCENE_S_ROOM_OF_RITES_COLLAPSE
cutscene0f:
	call func_1613
	ld e,$02
	jp endgameCutsceneHandler

;;
; CUTSCENE_S_CREDITS
cutscene0a:
	ld e,$01
	jp endgameCutsceneHandler

;;
; CUTSCENE_S_VOLCANO_ERUPTING
cutscene0b:
	callab bank3Cutscenes.cutsceneHandler_0b
	jr func_5d31

;;
; CUTSCENE_S_PIRATES_DEPART
cutscene0c:
	callab bank3Cutscenes.cutsceneHandler_0c
	jr func_5d31

;;
; CUTSCENE_S_PREGAME_INTRO
cutscene0d:
	call func_1613
	ld e,$03
	jp multiIntroCutsceneCaller

;;
; CUTSCENE_S_ONOX_TAUNTING
cutscene0e:
	ld a,(wWarpTransition2)
	or a
	jr nz,applyWarpTransition2
	ld e,$04
	call multiIntroCutsceneCaller
	jp updateAnimationsAfterCutscene

;;
; CUTSCENE_S_FLAME_OF_DESTRUCTION
cutscene10:
	call flameOfDestructionsCutsceneCaller
	jp func_5d41

;;
; CUTSCENE_S_ZELDA_VILLAGERS
cutscene11:
	call zeldaAndVillagersCutsceneCaller
	jp func_5d31

;;
; CUTSCENE_S_ZELDA_KIDNAPPED
cutscene12:
	call zeldaKidnappedCutsceneCaller
	jp func_5d41
