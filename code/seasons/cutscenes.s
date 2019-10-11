;;
cutscene06:
	ld e,$00
	jp seasonsFunc_35b8

;;
cutscene07:
	ld e,$01
	call seasonsFunc_35b8
	call updateInteractionsAndDrawAllSprites
	jp seasonsFunc_3276

;;
cutscene08:
	ld e,$02
	call seasonsFunc_35b8
	jp updateInteractionsAndDrawAllSprites

;;
cutscene09:
	call func_1613		; $5bea
	ld e,$00		; $5bed
	call func_306c		; $5bef
	ld a,(wWarpTransition2)		; $5bf2
	or a			; $5bf5
	ret z			; $5bf6
	jp func_5e0e		; $5bf7

;;
cutscene0f:
	call func_1613		; $5bfa
	ld e,$02		; $5bfd
	jp func_306c		; $5bff

;;
cutscene0a:
	ld e,$01		; $5c02
	jp func_306c		; $5c04

;;
cutscene0b:
	callab $03 $6b89	; $5c07
	jr _func_5d31		; $5c0f

;;
cutscene0c:
	callab $03 $66ff		; $5c11
	jr _func_5d31		; $5c19

;;
cutscene0d:
	call func_1613		; $5c1b
	ld e,$03		; $5c1e
	jp seasonsFunc_35b8		; $5c20

;;
cutscene0e:
	ld a,(wWarpTransition2)		; $5c23
	or a			; $5c26
	jr nz,func_5e0e		; $5c27
	ld e,$04		; $5c29
	call seasonsFunc_35b8		; $5c2b
	jp seasonsFunc_3276		; $5c2e

;;
cutscene10:
	call seasonsFunc_3346		; $5c31
	jp func_5d41		; $5c34

;;
cutscene11:
	call seasonsFunc_335a		; $5c37
	jp _func_5d31		; $5c3a

;;
cutscene12:
	call seasonsFunc_336e		; $5c3d
	jp func_5d41		; $5c40

;;
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
	ld ($cca6),a		; $5c5e
	ld ($ccab),a		; $5c61
	ret			; $5c64
