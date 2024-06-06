; TODO: Move this to "cutscenes/" folder (along with seasons equivalent)

;;
; CUTSCENE_NAYRU_SINGING
cutscene06:
	call func_1613
	ld c,$00
	jpab bank3Cutscenes.miscCutsceneHandler

;;
; CUTSCENE_MAKU_TREE_DISAPPEARING
cutscene07:
	ld c,$01
func_5d5d:
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2
	jpab bank3Cutscenes.miscCutsceneHandler

;;
; CUTSCENE_BLACK_TOWER_EXPLANATION
cutscene08:
	ld c,$02
	jr func_5d5d

;;
; CUTSCENE_NAYRU_WARP_TO_MAKU_TREE
cutscene0c:
	call func_1613
	ld c,$03
	jr func_5d5d

;;
; CUTSCENE_BLACK_TOWER_ESCAPE
cutscene09:
	call func_1613
	ld a,(wCutsceneTrigger)
	or a
	jp nz,setCutsceneIndexIfCutsceneTriggerSet

	ld e,$00
---
	call endgameCutsceneHandler
	ld a,(wWarpTransition2)
	or a
	ret z
	jp applyWarpTransition2

;;
; CUTSCENE_ROOM_OF_RITES_COLLAPSE
cutscene0f:
	call func_1613
	ld e,$02
	jp endgameCutsceneHandler

;;
; CUTSCENE_CREDITS
cutscene0a:
	ld e,$01
	jp endgameCutsceneHandler

;;
; CUTSCENE_FLAME_OF_DESPAIR
cutscene20:
	call func_1613
	ld e,$03
	jr ---

;;
; CUTSCENE_PREGAME_INTRO
cutscene0d:
	call func_1613
	ld c,$06
	jpab bank3Cutscenes.miscCutsceneHandler

;;
; CUTSCENE_TWINROVA_REVEAL
cutscene0e:
	call func_1613
	ld a,(wWarpTransition2)
	or a
	jr nz,applyWarpTransition2

.ifdef REGION_JP
	callab animationAndUniqueGfxData.updateAnimations
.endif

	ld c,$05
	jpab bank3Cutscenes.miscCutsceneHandler

;;
; CUTSCENE_BLACK_TOWER_COMPLETE
cutscene21:
	ld a,(wCutsceneTrigger)
	or a
	jp nz,setCutsceneIndexIfCutsceneTriggerSet

	ld c,$07
	jr func_5d5d

;;
; CUTSCENE_TURN_TO_STONE
cutscene10:
	ld c,$04
	jr func_5d5d

;;
; CUTSCENE_FLAME_OF_SORROW
cutscene11:
	call func_3ed0
	jp func_5d41

;;
; CUTSCENE_ZELDA_KIDNAPPED
cutscene12:
	ld a,(wCutsceneTrigger)
	or a
	jp nz,setCutsceneIndexIfCutsceneTriggerSet

	call func_3ee4
	jp func_5d41
