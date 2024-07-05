; ==================================================================================================
; ENEMY_MINI_DIGDOGGER
; ==================================================================================================
enemyCode55:
	jr z,+++
	sub $03
	ret c
	jr nz,+++
	ld h,d
	ld l,$b2
	bit 0,(hl)
	jr nz,+
	inc (hl)
	ld l,$86
	ld (hl),$1e
	ld a,$69
	call playSound
	ld a,$32
	call objectGetRelatedObject1Var
	dec (hl)
	dec l
	dec (hl)
	jr z,++
	ld a,$04
	call enemySetAnimation
+
	call ecom_decCounter1
	ret nz
	jp enemyDie_uncounted
++
	ld l,$a9
	ld (hl),$00
	call objectCopyPosition
	jp enemyDelete
+++
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC

@state0:
	ld bc,$011f
	call ecom_randomBitwiseAndBCE
	ld e,$89
	ld a,c
	ld (de),a
	ld a,b
	ld hl,@seasonsTable_0d_7462
	rst_addAToHl
	ld e,$87
	ld a,(hl)
	ld (de),a
	call seasonsFunc_0d_74ce
	ld h,d
	ld l,$94
	ld a,$80
	ldi (hl),a
	ld (hl),$fe
	ld a,$32
	jp ecom_setSpeedAndState8AndVisible

@seasonsTable_0d_7462:
	.db $3c $50

@state_stub:
	ret

@state8:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jr nz,@bounceOffWallsAndHoles
	ld l,$84
	inc (hl)
	ld l,$94
	ld a,$00
	ldi (hl),a
	ld (hl),$ff
	ret

@state9:
	call seasonsFunc_0d_7523
	ld c,$0f
	call objectUpdateSpeedZ_paramC
	jr nz,@bounceOffWallsAndHoles
	ld l,$84
	inc (hl)
	ld l,$87
	ld a,(hl)
	ld l,$90
	ld (hl),a
	ret

@stateA:
	call seasonsFunc_0d_7547
	call seasonsFunc_0d_7523
	call seasonsFunc_0d_74e1
	call @bounceOffWallsAndHoles
	jp enemyAnimate

@stateB:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ld l,$95
	ldd a,(hl)
	or a
	jr nz,+
	ldi a,(hl)
	or a
	jr nz,+
	ld (hl),$02
	ld l,$90
	ld (hl),$6e
+
	ld l,$97
	ld h,(hl)
	call seasonsFunc_0d_74fe
	jr nc,@animateAndApplySpeed
	ld e,$8f
	ld a,(de)
	or a
	ret nz

@stateC:
	ld a,$32
	call objectGetRelatedObject1Var
	dec (hl)
	jp enemyDelete

@bounceOffWallsAndHoles:
	call ecom_bounceOffWallsAndHoles

@animateAndApplySpeed:
	call seasonsFunc_0d_74ce
	jp objectApplySpeed

seasonsFunc_0d_74ce:
	ld h,d
	ld l,$b0
	ld e,$89
	ld a,(de)
	add $04
	and $18
	swap a
	rlca
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

seasonsFunc_0d_74e1:
	ld e,$99
	ld a,(de)
	or a
	ret z
	ld h,d
	ld l,$84
	inc (hl)
	cp h
	jr nz,+
	inc (hl)
+
	ld l,$90
	ld (hl),$28
	ld l,$94
	ld a,$c0
	ldi (hl),a
	ld (hl),$fc
	ld a,$59
	jp playSound

seasonsFunc_0d_74fe:
	ld l,$8b
	ld e,l
	ld b,(hl)
	ld a,(de)
	ldh (<hFF8F),a
	ld l,$8d
	ld e,l
	ld c,(hl)
	ld a,(de)
	ldh (<hFF8E),a
	sub c
	add $02
	cp $05
	jr nc,+
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	ret c
+
	call objectGetRelativeAngleWithTempVars
	ld e,$89
	ld (de),a
	or d
	ret

seasonsFunc_0d_7523:
	ld e,$b1
	ld a,(de)
	ld h,a
	ld l,$8b
	ld e,l
	ld a,(de)
	sub (hl)
	add $0a
	cp $15
	ret nc
	ld l,$8d
	ld e,l
	ld a,(de)
	sub (hl)
	add $0a
	cp $15
	ret nc
	ld l,$90
	ld a,(hl)
	cp $14
	ret c
	pop hl
	ld e,$a9
	xor a
	ld (de),a
	ret

seasonsFunc_0d_7547:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,$a3
	jp playSound
