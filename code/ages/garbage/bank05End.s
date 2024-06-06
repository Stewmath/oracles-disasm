.ifdef INCLUDE_GARBAGE

; Garbage data

	.db $52 $06
	.db $53 $06
	.db $48 $02
	.db $49 $02
	.db $4a $02
	.db $4b $02
	.db $4d $03
	.db $54 $09
	.db $55 $0a
	.db $56 $0b
	.db $57 $0c
	.db $60 $0d
	.db $8a $0f
	.db $00

	.db $16 $10
	.db $18 $10
	.db $17 $90
	.db $19 $90
	.db $f4 $01
	.db $0f $01
	.db $0c $01
	.db $1a $30
	.db $1b $20
	.db $1c $20
	.db $1d $20
	.db $1e $20
	.db $1f $20
	.db $20 $40
	.db $22 $40
	.db $02 $00
	.db $00

	.db $7d $7d
	.db $8c $7d
	.db $8c $7d
	.db $9c $7d
	.db $7d $7d
	.db $8c $7d
	.db $05 $10
	.db $06 $10
	.db $07 $10
	.db $0a $18
	.db $0b $08
	.db $64 $10
	.db $ff $10
	.db $00

	.db $b0 $10
	.db $b1 $18
	.db $b2 $00
	.db $b3 $08
	.db $c1 $10
	.db $c2 $18
	.db $c3 $00
	.db $c4 $08
	.db $00

.endif


.ifdef REGION_JP
.ifdef BUILD_VANILLA

	; Leftovers from Seasons - subrosian dance stuff

	ld hl,subrosiaDance_nextTileLookup
-
	ldi a,(hl)
	cp c
	jr z,+
	inc hl
	jr -
+
	ld a,($cc46)
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
	jp $2a50 ; specialObjectSetAnimation

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
	jp $2a50 ; specialObjectSetAnimation

subrosiaDance_storeButtonPress:
	ld a,($cfd8)
	inc a
	ret nz
	ld a,b
	ld ($cfd8),a
	ret

subrosiaDance_state2:
	call subrosiaDance_checkSpinOrCollapse
	call $2a35 ; specialObjectAnimatie
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
	call $1fda ; objectApplySpeed
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
	jp $2098 ; objectCenterOnTile

subrosiaDance_state3:
	; animate $100 times, then go to state 1
	call subrosiaDance_checkSpinOrCollapse
	call $2a35 ; specialObjectAnimatie
	ld e,SpecialObject.animParameter
	ld a,(de)
	inc a
	ret nz
	ld e,SpecialObject.state
	ld a,$01
	ld (de),a
	ret

subrosiaDance_state4:
	jp $2a35 ; specialObjectAnimatie

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
	call $2a50 ; specialObjectSetAnimation
	jp $1e14 ; objectSetVisible80
.endif
.endif

