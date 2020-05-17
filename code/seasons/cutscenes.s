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
	call func_1613		; $5bea
	ld e,$00		; $5bed
	call endgameCutsceneHandler		; $5bef
	ld a,(wWarpTransition2)		; $5bf2
	or a			; $5bf5
	ret z			; $5bf6
	jp func_5e0e		; $5bf7

;;
; CUTSCENE_S_ROOM_OF_RITES_COLLAPSE
cutscene0f:
	call func_1613		; $5bfa
	ld e,$02		; $5bfd
	jp endgameCutsceneHandler		; $5bff

;;
; CUTSCENE_S_CREDITS
cutscene0a:
	ld e,$01		; $5c02
	jp endgameCutsceneHandler		; $5c04

;;
; CUTSCENE_S_VOLCANO_ERUPTING
cutscene0b:
	callab _cutsceneHandler_0b	; $5c07
	jr _func_5d31		; $5c0f

;;
; CUTSCENE_S_PIRATES_DEPART
cutscene0c:
	callab _cutsceneHandler_0c		; $5c11
	jr _func_5d31		; $5c19

;;
; CUTSCENE_S_PREGAME_INTRO
cutscene0d:
	call func_1613		; $5c1b
	ld e,$03		; $5c1e
	jp multiIntroCutsceneCaller		; $5c20

;;
; CUTSCENE_S_ONOX_TAUNTING
cutscene0e:
	ld a,(wWarpTransition2)		; $5c23
	or a			; $5c26
	jr nz,func_5e0e		; $5c27
	ld e,$04		; $5c29
	call multiIntroCutsceneCaller		; $5c2b
	jp updateAnimationsAfterCutscene		; $5c2e

;;
; CUTSCENE_S_FLAME_OF_DESTRUCTION
cutscene10:
	call flameOfDestructionsCutsceneCaller		; $5c31
	jp func_5d41		; $5c34

;;
; CUTSCENE_S_ZELDA_VILLAGERS
cutscene11:
	call zeldaAndVillagersCutsceneCaller		; $5c37
	jp _func_5d31		; $5c3a

;;
; CUTSCENE_S_ZELDA_KIDNAPPED
cutscene12:
	call zeldaKidnappedCutsceneCaller		; $5c3d
	jp func_5d41		; $5c40

;;
; CUTSCENE_S_16
; TODO: warps Link some place
cutscene16:
	call updateMenus		; $5c43
	ret nz			; $5c46
	ld hl,wWarpTransition2		; $5c47
	ld a,(hl)		; $5c4a
	ld (hl),$00		; $5c4b
	inc a			; $5c4d
	ld a,$03		; $5c4e
	jr nz,+			; $5c50
	call updateAllObjects		; $5c52
	ld a,$01		; $5c55
+
	ld (wCutsceneIndex),a		; $5c57
	xor a			; $5c5a
	ld (wMenuDisabled),a		; $5c5b
	ld (wLinkCanPassNpcs),a		; $5c5e
	ld (wDisableScreenTransitions),a		; $5c61
	ret			; $5c64
