;;
; CUTSCENE_NAYRU_SINGING
; @addr{5d4e}
cutscene06:
	call func_1613		; $5d4e
	ld c,$00		; $5d51
	jpab func_03_6306		; $5d53

;;
; @addr{5d5b}
cutscene07:
	ld c,$01		; $5d5b
_func_5d5d:
	ld a,(wWarpTransition2)		; $5d5d
	or a			; $5d60
	jp nz,func_5e0e		; $5d61
	jpab func_03_6306		; $5d64

;;
; @addr{5d6c}
cutscene08:
	ld c,$02		; $5d6c
	jr _func_5d5d			; $5d6e
;;
; @addr{5d70}
cutscene0c:
	call func_1613		; $5d70
	ld c,$03		; $5d73
	jr _func_5d5d			; $5d75
;;
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
	jp func_5e0e		; $5d8b

;;
; @addr{5d8e}
cutscene0f:
	call func_1613		; $5d8e
	ld e,$02		; $5d91
	jp endgameCutsceneHandler		; $5d93
;;
; @addr{5d96}
cutscene0a:
	ld e,$01		; $5d96
	jp endgameCutsceneHandler		; $5d98
;;
; @addr{5d9b}
cutscene20:
	call func_1613		; $5d9b
	ld e,$03		; $5d9e
	jr ---			; $5da0

;;
; @addr{5da2}
cutscene0d:
	call func_1613		; $5da2
	ld c,$06		; $5da5
	jpab func_03_6306		; $5da7
;;
; @addr{5daf}
cutscene0e:
	call func_1613		; $5daf
	ld a,(wWarpTransition2)		; $5db2
	or a			; $5db5
	jr nz,func_5e0e	; $5db6

	ld c,$05		; $5db8
	jpab func_03_6306		; $5dba

;;
; @addr{5dc2}
cutscene21:
	ld a,(wCutsceneTrigger)		; $5dc2
	or a			; $5dc5
	jp nz,func_5e3d		; $5dc6

	ld c,$07		; $5dc9
	jr _func_5d5d			; $5dcb

;;
; @addr{5dcd}
cutscene10:
	ld c,$04		; $5dcd
	jr _func_5d5d			; $5dcf

;;
; @addr{5dd1}
cutscene11:
	call func_3ed0		; $5dd1
	jp func_5d41		; $5dd4

;;
; @addr{5dd7}
cutscene12:
	ld a,(wCutsceneTrigger)		; $5dd7
	or a			; $5dda
	jp nz,func_5e3d		; $5ddb

	call func_3ee4		; $5dde
	jp func_5d41		; $5de1

;;
; @addr{5de4}
cutscene16:
	call updateMenus		; $5de4
	ret nz			; $5de7

	ld hl,wWarpTransition2		; $5de8
	ld a,(hl)		; $5deb
	ld (hl),$00		; $5dec
	inc a			; $5dee
	ld a,$03		; $5def
	jr nz,+			; $5df1

	call updateAllObjects		; $5df3
	ld a,$01		; $5df6
+
	ld (wCutsceneIndex),a		; $5df8
	xor a			; $5dfb
	ld (wMenuDisabled),a		; $5dfc
	ld ($cc8c),a		; $5dff
	ld ($cc91),a		; $5e02
	ret			; $5e05
