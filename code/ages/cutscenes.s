;;
; CUTSCENE_NAYRU_SINGING
; @addr{5d4e}
cutscene06:
	call func_1613
	ld c,$00
	jpab miscCutsceneHandler

;;
; CUTSCENE_MAKU_TREE_DISAPPEARING
; @addr{5d5b}
cutscene07:
	ld c,$01
_func_5d5d:
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2
	jpab miscCutsceneHandler

;;
; CUTSCENE_BLACK_TOWER_EXPLANATION
; @addr{5d6c}
cutscene08:
	ld c,$02
	jr _func_5d5d

;;
; CUTSCENE_NAYRU_WARP_TO_MAKU_TREE
; @addr{5d70}
cutscene0c:
	call func_1613
	ld c,$03
	jr _func_5d5d

;;
; CUTSCENE_BLACK_TOWER_ESCAPE
; @addr{5d77}
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
; @addr{5d8e}
cutscene0f:
	call func_1613
	ld e,$02
	jp endgameCutsceneHandler

;;
; CUTSCENE_CREDITS
; @addr{5d96}
cutscene0a:
	ld e,$01
	jp endgameCutsceneHandler

;;
; CUTSCENE_FLAME_OF_DESPAIR
; @addr{5d9b}
cutscene20:
	call func_1613
	ld e,$03
	jr ---

;;
; CUTSCENE_PREGAME_INTRO
; @addr{5da2}
cutscene0d:
	call func_1613
	ld c,$06
	jpab miscCutsceneHandler

;;
; CUTSCENE_TWINROVA_REVEAL
; @addr{5daf}
cutscene0e:
	call func_1613
	ld a,(wWarpTransition2)
	or a
	jr nz,applyWarpTransition2

	ld c,$05
	jpab miscCutsceneHandler

;;
; CUTSCENE_BLACK_TOWER_COMPLETE
; @addr{5dc2}
cutscene21:
	ld a,(wCutsceneTrigger)
	or a
	jp nz,setCutsceneIndexIfCutsceneTriggerSet

	ld c,$07
	jr _func_5d5d

;;
; CUTSCENE_TURN_TO_STONE
; @addr{5dcd}
cutscene10:
	ld c,$04
	jr _func_5d5d

;;
; CUTSCENE_FLAME_OF_SORROW
; @addr{5dd1}
cutscene11:
	call func_3ed0
	jp func_5d41

;;
; CUTSCENE_ZELDA_KIDNAPPED
; @addr{5dd7}
cutscene12:
	ld a,(wCutsceneTrigger)
	or a
	jp nz,setCutsceneIndexIfCutsceneTriggerSet

	call func_3ee4
	jp func_5d41
