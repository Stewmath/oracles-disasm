;;
; TODO: param explanation and interaction with minigame
specialObjectCode_subrosiaDanceLink:
	ld e,SpecialObject.state		; $7cda
	ld a,(de)		; $7cdc
	rst_jumpTable			; $7cdd
        .dw _subrosiaDance_state0
        .dw _subrosiaDance_state1
        .dw _subrosiaDance_state2
        .dw _subrosiaDance_state3
        .dw _subrosiaDance_state4
        .dw _subrosiaDance_state5

_subrosiaDance_state0:
	; Initialize, then go to state 1
	call clearAllParentItems		; $7cea
	call specialObjectSetOamVariables		; $7ced
	ld h,d			; $7cf0
	ld l,$00		; $7cf1
	ld a,(hl)		; $7cf3
	or $03			; $7cf4
	ld (hl),a		; $7cf6
	ld l,SpecialObject.state		; $7cf7
	ld (hl),$01		; $7cf9
	ld l,SpecialObject.direction		; $7cfb
	ld (hl),DIR_DOWN		; $7cfd
	ld l,SpecialObject.yh		; $7cff
	ld (hl),$38		; $7d01
	ld l,SpecialObject.xh		; $7d03
	ld (hl),$68		; $7d05
	ld a,$00		; $7d07
	call specialObjectSetAnimation		; $7d09
	jp objectSetVisiblec1		; $7d0c

_subrosiaDance_state1:
	call subrosiaDance_checkSpinOrCollapse		; $7d0f
	ld h,d			; $7d12
	ld a,(wGameKeysJustPressed)		; $7d13
	ld b,$00		; $7d16
	bit BTN_BIT_RIGHT,a			; $7d18
	jr nz,+			; $7d1a
	inc b			; $7d1c
	bit BTN_BIT_LEFT,a			; $7d1d
	jr nz,+			; $7d1f
	inc b			; $7d21
	and $01			; $7d22
	jr nz,subrosiaDance_buttonAPressed		; $7d24
	ret			; $7d26
+
	; right - 0, left - 1
	call subrosiaDance_storeButtonPress		; $7d27
	ld l,SpecialObject.state		; $7d2a
	inc (hl)		; $7d2c
	ld l,SpecialObject.var37		; $7d2d
	ld (hl),$00		; $7d2f
	call objectGetShortPosition		; $7d31
	ld c,a			; $7d34
	ld hl,subrosiaDance_nextTileLookup		; $7d35
-
	ldi a,(hl)		; $7d38
	cp c			; $7d39
	jr z,+			; $7d3a
	inc hl			; $7d3c
	jr -			; $7d3d
+
	ld a,(wGameKeysJustPressed)		; $7d3f
	and $10			; $7d42
	ld a,(hl)		; $7d44
	; BTN_BIT_RIGHT
	jr nz,+			; $7d45
	swap a			; $7d47
+
	and $0f			; $7d49
	ld e,SpecialObject.direction		; $7d4b
	ld (de),a		; $7d4d
	swap a			; $7d4e
	rrca			; $7d50
	inc e			; $7d51
	ld (de),a		; $7d52
	xor a			; $7d53
	jp specialObjectSetAnimation		; $7d54

subrosiaDance_nextTileLookup:
	; curr tile, 'left' tile<<8 | 'right' tile
	.db $11 $21
	.db $21 $20
	.db $31 $20
	.db $41 $20
	.db $51 $20
	.db $61 $10
	.db $62 $13
	.db $63 $13
	.db $64 $13
	.db $65 $13
	.db $66 $03
	.db $56 $02
	.db $46 $02
	.db $36 $02
	.db $26 $02
	.db $16 $32
	.db $15 $31
	.db $14 $31
	.db $13 $31
	.db $12 $31

subrosiaDance_buttonAPressed:
	; BTN_BIT_A
	call subrosiaDance_storeButtonPress		; $7d7f
	ld l,SpecialObject.state		; $7d82
	ld (hl),$03		; $7d84
	ld l,SpecialObject.direction		; $7d86
	ld (hl),DIR_UP		; $7d88
	ld a,$01		; $7d8a
	jp specialObjectSetAnimation		; $7d8c

subrosiaDance_storeButtonPress:
	ld a,($cfd8)		; $7d8f
	inc a			; $7d92
	ret nz			; $7d93
	ld a,b			; $7d94
	ld ($cfd8),a		; $7d95
	ret			; $7d98

_subrosiaDance_state2:
	call subrosiaDance_checkSpinOrCollapse		; $7d99
	call specialObjectAnimate		; $7d9c
	call subrosiaDance_moveLink		; $7d9f
	ret c			; $7da2
	ld e,SpecialObject.state		; $7da3
	ld a,$01		; $7da5
	ld (de),a		; $7da7
	ret			; $7da8

subrosiaDance_moveLink:
	; store yh into var38
	ld h,d			; $7da9
	ld e,SpecialObject.yh		; $7daa
	ld l,SpecialObject.var38		; $7dac
	ld a,(de)		; $7dae
	ldi (hl),a		; $7daf

	; store xh into var39
	ld e,SpecialObject.xh		; $7db0
	ld a,(de)		; $7db2
	ld (hl),a		; $7db3

	ld a,($cfd3)		; $7db4
	ld e,SpecialObject.speed		; $7db7
	ld (de),a		; $7db9
	call objectApplySpeed		; $7dba
	call fixXYWithinDancingGrid		; $7dbd
	jr subrosiaDance_05_7dd7			; $7dc0

fixXYWithinDancingGrid:
	ld h,d			; $7dc2
	ld l,SpecialObject.yh		; $7dc3
	call fixXYWithinDancingGrid_helper		; $7dc5
	ld h,d			; $7dc8
	ld l,SpecialObject.xh		; $7dc9

fixXYWithinDancingGrid_helper:
	; snaps yh/xh to minimum $18 and maximum $68
	ld a,$17		; $7dcb
	cp (hl)			; $7dcd
	inc a			; $7dce
	jr nc,+			; $7dcf
	ld a,$68		; $7dd1
	cp (hl)			; $7dd3
	ret nc			; $7dd4
+
	ld (hl),a		; $7dd5
	ret			; $7dd6

subrosiaDance_05_7dd7:
	ld e,SpecialObject.yh		; $7dd7
	ld a,(de)		; $7dd9
	ld b,a			; $7dda
	ld e,SpecialObject.var38		; $7ddb
	ld a,(de)		; $7ddd
	; var38 (previous yh) - yh
	sub b			; $7dde
	jr nc,+			; $7ddf
	cpl			; $7de1
	inc a			; $7de2
+
	ld c,a			; $7de3
	ld e,SpecialObject.xh		; $7de4
	ld a,(de)		; $7de6
	ld b,a			; $7de7
	ld e,SpecialObject.var39		; $7de8
	ld a,(de)		; $7dea
	; var39 (previous xh) - xh
	sub b			; $7deb
	jr nc,+			; $7dec
	cpl			; $7dee
	inc a			; $7def
+
	add c			; $7df0
	ret z			; $7df1
	ld b,a			; $7df2
	ld e,SpecialObject.var37		; $7df3
	ld a,(de)		; $7df5
	add b			; $7df6
	ld (de),a		; $7df7
	cp $10			; $7df8
	ret c			; $7dfa
	jp objectCenterOnTile		; $7dfb

_subrosiaDance_state3:
	; animate $100 times, then go to state 1
	call subrosiaDance_checkSpinOrCollapse		; $7dfe
	call specialObjectAnimate		; $7e01
	ld e,SpecialObject.animParameter		; $7e04
	ld a,(de)		; $7e06
	inc a			; $7e07
	ret nz			; $7e08
	ld e,SpecialObject.state		; $7e09
	ld a,$01		; $7e0b
	ld (de),a		; $7e0d
	ret			; $7e0e

_subrosiaDance_state4:
	jp specialObjectAnimate		; $7e0f

_subrosiaDance_state5:
	ret			; $7e12

subrosiaDance_checkSpinOrCollapse:
	; $cfd0 == $00, ret
	; $cfd0 == $ff, LINK_ANIM_MODE_COLLAPSED -> next state ret
	; else LINK_ANIM_MODE_SPIN -> next state animate
	ld a,($cfd0)		; $7e13
	or a			; $7e16
	ret z			; $7e17
	pop hl			; $7e18
	inc a			; $7e19
	ld a,$05		; $7e1a
	ld b,LINK_ANIM_MODE_COLLAPSED		; $7e1c
	jr z,+			; $7e1e
	dec a			; $7e20
	ld b,LINK_ANIM_MODE_SPIN		; $7e21
+
	ld e,SpecialObject.state		; $7e23
	ld (de),a		; $7e25
	ld a,b			; $7e26
	call specialObjectSetAnimation		; $7e27
	jp objectSetVisible80		; $7e2a
