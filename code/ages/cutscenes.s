;;
; CUTSCENE_NAYRU_SINGING
; @addr{5d4e}
cutscene06:
	call func_1613		; $5d4e
	ld c,$00		; $5d51
	jpab miscCutsceneHandler		; $5d53

;;
; CUTSCENE_MAKU_TREE_DISAPPEARING
; @addr{5d5b}
cutscene07:
	ld c,$01		; $5d5b
_func_5d5d:
	ld a,(wWarpTransition2)		; $5d5d
	or a			; $5d60
	jp nz,applyWarpTransition2		; $5d61
	jpab miscCutsceneHandler		; $5d64

;;
; CUTSCENE_BLACK_TOWER_EXPLANATION
; @addr{5d6c}
cutscene08:
	ld c,$02		; $5d6c
	jr _func_5d5d			; $5d6e

;;
; CUTSCENE_NAYRU_WARP_TO_MAKU_TREE
; @addr{5d70}
cutscene0c:
	call func_1613		; $5d70
	ld c,$03		; $5d73
	jr _func_5d5d			; $5d75

;;
; CUTSCENE_BLACK_TOWER_ESCAPE
; @addr{5d77}
cutscene09:
	call func_1613		; $5d77
	ld a,(wCutsceneTrigger)		; $5d7a
	or a			; $5d7d
	jp nz,func_5e3d		; $5d7e

	ld e,$00		; $5d81
---
	call endgameCutsceneHandler		; $5d83
	ld a,(wWarpTransition2)		; $5d86
	or a			; $5d89
	ret z			; $5d8a
	jp applyWarpTransition2		; $5d8b

;;
; CUTSCENE_ROOM_OF_RITES_COLLAPSE
; @addr{5d8e}
cutscene0f:
	call func_1613		; $5d8e
	ld e,$02		; $5d91
	jp endgameCutsceneHandler		; $5d93

;;
; CUTSCENE_CREDITS
; @addr{5d96}
cutscene0a:
	ld e,$01		; $5d96
	jp endgameCutsceneHandler		; $5d98

;;
; CUTSCENE_FLAME_OF_DESPAIR
; @addr{5d9b}
cutscene20:
	call func_1613		; $5d9b
	ld e,$03		; $5d9e
	jr ---			; $5da0

;;
; CUTSCENE_PREGAME_INTRO
; @addr{5da2}
cutscene0d:
	call func_1613		; $5da2
	ld c,$06		; $5da5
	jpab miscCutsceneHandler		; $5da7

;;
; CUTSCENE_TWINROVA_REVEAL
; @addr{5daf}
cutscene0e:
	call func_1613		; $5daf
	ld a,(wWarpTransition2)		; $5db2
	or a			; $5db5
	jr nz,applyWarpTransition2	; $5db6

	ld c,$05		; $5db8
	jpab miscCutsceneHandler		; $5dba

;;
; CUTSCENE_BLACK_TOWER_COMPLETE
; @addr{5dc2}
cutscene21:
	ld a,(wCutsceneTrigger)		; $5dc2
	or a			; $5dc5
	jp nz,func_5e3d		; $5dc6

	ld c,$07		; $5dc9
	jr _func_5d5d			; $5dcb

;;
; CUTSCENE_TURN_TO_STONE
; @addr{5dcd}
cutscene10:
	ld c,$04		; $5dcd
	jr _func_5d5d			; $5dcf

;;
; CUTSCENE_FLAME_OF_SORROW
; @addr{5dd1}
cutscene11:
	call func_3ed0		; $5dd1
	jp func_5d41		; $5dd4

;;
; CUTSCENE_ZELDA_KIDNAPPED
; @addr{5dd7}
cutscene12:
	ld a,(wCutsceneTrigger)		; $5dd7
	or a			; $5dda
	jp nz,func_5e3d		; $5ddb

	call func_3ee4		; $5dde
	jp func_5d41		; $5de1
