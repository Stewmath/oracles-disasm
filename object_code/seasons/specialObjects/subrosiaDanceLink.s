;;
; TODO: param explanation and interaction with minigame
specialObjectCode_subrosiaDanceLink:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw subrosiaDance_state0
	.dw subrosiaDance_state1
	.dw subrosiaDance_state2
	.dw subrosiaDance_state3
	.dw subrosiaDance_state4
	.dw subrosiaDance_state5

subrosiaDance_state0:
	; Initialize, then go to state 1
	call clearAllParentItems
	call specialObjectSetOamVariables
	ld h,d
	ld l,SpecialObject.enabled
	ld a,(hl)
	or $03
	ld (hl),a
	ld l,SpecialObject.state
	ld (hl),$01
	ld l,SpecialObject.direction
	ld (hl),DIR_DOWN
	ld l,SpecialObject.yh
	ld (hl),$38
	ld l,SpecialObject.xh
	ld (hl),$68
	ld a,$00
	call specialObjectSetAnimation
	jp objectSetVisiblec1

subrosiaDance_state1:
	call subrosiaDance_checkSpinOrCollapse
	ld h,d
	ld a,(wGameKeysJustPressed)
	ld b,$00
	bit BTN_BIT_RIGHT,a
	jr nz,+
	inc b
	bit BTN_BIT_LEFT,a
	jr nz,+
	inc b
	and $01
	jr nz,subrosiaDance_buttonAPressed
	ret
+
	; right - 0, left - 1
	call subrosiaDance_storeButtonPress
	ld l,SpecialObject.state
	inc (hl)
	ld l,SpecialObject.var37
	ld (hl),$00
	call objectGetShortPosition
	ld c,a
	ld hl,subrosiaDance_nextTileLookup
-
	ldi a,(hl)
	cp c
	jr z,+
	inc hl
	jr -
+
	ld a,(wGameKeysJustPressed)
	and $10
	ld a,(hl)
	; BTN_BIT_RIGHT
	jr nz,+
	swap a
+
	and $0f
	ld e,SpecialObject.direction
	ld (de),a
	swap a
	rrca
	inc e
	ld (de),a
	xor a
	jp specialObjectSetAnimation

subrosiaDance_nextTileLookup:
	; curr tile, 'left' btn direction <<8 | 'right' btn direction
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
	call subrosiaDance_storeButtonPress
	ld l,SpecialObject.state
	ld (hl),$03
	ld l,SpecialObject.direction
	ld (hl),DIR_UP
	ld a,$01
	jp specialObjectSetAnimation

subrosiaDance_storeButtonPress:
	ld a,($cfd8)
	inc a
	ret nz
	ld a,b
	ld ($cfd8),a
	ret

subrosiaDance_state2:
	call subrosiaDance_checkSpinOrCollapse
	call specialObjectAnimate
	call subrosiaDance_moveLink
	ret c
	ld e,SpecialObject.state
	ld a,$01
	ld (de),a
	ret

subrosiaDance_moveLink:
	; store yh into var38
	ld h,d
	ld e,SpecialObject.yh
	ld l,SpecialObject.var38
	ld a,(de)
	ldi (hl),a

	; store xh into var39
	ld e,SpecialObject.xh
	ld a,(de)
	ld (hl),a

	ld a,($cfd3)
	ld e,SpecialObject.speed
	ld (de),a
	call objectApplySpeed
	call fixXYWithinDancingGrid
	jr subrosiaDance_05_7dd7

fixXYWithinDancingGrid:
	ld h,d
	ld l,SpecialObject.yh
	call fixXYWithinDancingGrid_helper
	ld h,d
	ld l,SpecialObject.xh

fixXYWithinDancingGrid_helper:
	; snaps yh/xh to minimum $18 and maximum $68
	ld a,$17
	cp (hl)
	inc a
	jr nc,+
	ld a,$68
	cp (hl)
	ret nc
+
	ld (hl),a
	ret

subrosiaDance_05_7dd7:
	ld e,SpecialObject.yh
	ld a,(de)
	ld b,a
	ld e,SpecialObject.var38
	ld a,(de)
	; var38 (previous yh) - yh
	sub b
	jr nc,+
	cpl
	inc a
+
	ld c,a
	ld e,SpecialObject.xh
	ld a,(de)
	ld b,a
	ld e,SpecialObject.var39
	ld a,(de)
	; var39 (previous xh) - xh
	sub b
	jr nc,+
	cpl
	inc a
+
	add c
	ret z
	ld b,a
	ld e,SpecialObject.var37
	ld a,(de)
	add b
	ld (de),a
	cp $10
	ret c
	jp objectCenterOnTile

subrosiaDance_state3:
	; animate $100 times, then go to state 1
	call subrosiaDance_checkSpinOrCollapse
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	inc a
	ret nz
	ld e,SpecialObject.state
	ld a,$01
	ld (de),a
	ret

subrosiaDance_state4:
	jp specialObjectAnimate

subrosiaDance_state5:
	ret

subrosiaDance_checkSpinOrCollapse:
	; $cfd0 == $00, ret
	; $cfd0 == $ff, LINK_ANIM_MODE_COLLAPSED -> next state ret
	; else LINK_ANIM_MODE_SPIN -> next state animate
	ld a,($cfd0)
	or a
	ret z
	pop hl
	inc a
	ld a,$05
	ld b,LINK_ANIM_MODE_COLLAPSED
	jr z,+
	dec a
	ld b,LINK_ANIM_MODE_SPIN
+
	ld e,SpecialObject.state
	ld (de),a
	ld a,b
	call specialObjectSetAnimation
	jp objectSetVisible80
