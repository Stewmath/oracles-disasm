; ==================================================================================================
; ENEMY_BLAINO
; ==================================================================================================
enemyCode54:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDelete
	dec a
	jp nz,ecom_updateKnockback
	ld e,$aa
	ld a,(de)
	res 7,a
	sub $0a
	cp $02
	jr nc,@normalStatus
	call seasonsFunc_0d_73df
	ld h,d
	ld l,$a9
	ld (hl),$40
	ld l,$86
	ld (hl),$0a
	inc l
	inc (hl)
	ld l,$84
	ld a,$0f
	cp (hl)
	jr z,@normalStatus
	ld (hl),a
	ld l,$87
	ld (hl),$00
	ld l,$b0
	ld a,(hl)
	add $05
	call enemySetAnimation
	ld a,$24
	call objectGetRelatedObject2Var
	res 7,(hl)
	ld l,Enemy.state
	ld (hl),$03

@normalStatus:
	call seasonsFunc_0d_7323
	ld a,($cced)
	cp $02
	jr z,+
	ld e,$84
	ld a,(de)
	or a
	jp nz,seasonsFunc_0d_7312
+
	ld e,Enemy.state
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
	.dw @stateD
	.dw @stateE
	.dw @stateF

@state0:
	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMY_BLAINOS_GLOVES
	ld l,Enemy.relatedObj1
	ld a,$80
	ldi (hl),a
	ld (hl),d

	ld e,Enemy.relatedObj2
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	call objectCopyPosition
	call seasonsFunc_0d_736d
	ld e,$b0
	ld a,$01
	ld (de),a
	call enemySetAnimation
	jp objectSetVisiblec2

@state_stub:
	ret

@state8:
	call seasonsFunc_0d_72d4
	inc a
	jr z,+
	ld e,$84
	ld a,$0d
	ld (de),a
	jr @animate
+
	call seasonsFunc_0d_73b1
	ld a,$09
	jr nc,+
	ld a,$0b
+
	ld e,$84
	ld (de),a
	jr @animate

@state9:
	ld a,$0a
	ld (de),a
	jp seasonsFunc_0d_7350

@stateA:
	call seasonsFunc_0d_7312
	call z,seasonsFunc_0d_736d
	call objectApplySpeed

@animate:
	jp enemyAnimate

@stateB:
	ld a,$0c
	ld (de),a
	inc e
	xor a
	ld (de),a
	call seasonsFunc_0d_737f
	ld e,$83
	ld a,b
	ld (de),a
	ld e,$b1
	inc a
	ld (de),a
	ret

@stateC:
	ld e,Enemy.var03
	ld a,(de)
	ld e,Enemy.substate
	rst_jumpTable
	.dw @stateCvar03_0
	.dw @stateCvar03_1
	.dw @stateCvar03_2
	.dw @stateCvar03_3
	.dw @stateCvar03_4

@stateD:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$00
	ld l,$90
	ld (hl),$2d
	call seasonsFunc_0d_7395
	ret nc
	ld e,$b2
	ld a,(de)
	ld hl,seasonsTable_0d_73d7
	rst_addAToHl
	ld e,$89
	ld a,(hl)
	ld (de),a
	ret

@stateE:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @stateEcont
	.dw @stateA

@stateEcont:
	call seasonsFunc_0d_7312
	jr z,+
	call objectApplySpeed
	jr @animate
+
	ld e,$85
	ld a,$01
	ld (de),a
	ld bc,$4050
	call objectGetRelativeAngle
	ld e,$89
	ld (de),a
	ret

@stateF:
	call ecom_decCounter1
	ret nz
	ld a,$24
	call objectGetRelatedObject2Var
	set 7,(hl)
	inc l
	ld (hl),$40
	ld l,$84
	ld (hl),$01
	inc l
	ld (hl),$00
	ld e,$b0
	ld a,(de)
	call enemySetAnimation
	jp seasonsFunc_0d_736d

@stateCvar03_0:
	call seasonsFunc_0d_7312
	jp z,seasonsFunc_0d_736d
	jp enemyAnimate

@stateCvar03_1:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$3c

@@state1:
	call ecom_decCounter1
	ret nz
	jp seasonsFunc_0d_736d

@stateCvar03_2:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$1e
	ld l,$90
	ld (hl),$0a
	call seasonsFunc_0d_73cd
	xor $10
	ld (de),a

@@substate1:
	call ecom_decCounter1
	jp nz,objectApplySpeed
	ld (hl),$04
	ld l,e
	inc (hl)

@@substate2:
	call ecom_decCounter1
	ret nz
	ld (hl),$1e
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$50
	ld l,$89
	ld a,(hl)
	xor $10
	ld (hl),a

@@substate3:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $1a
	jp nc,objectApplySpeed
	ret
+
	ld (hl),$1e
	ld l,e
	inc (hl)

@@substate4:
	call ecom_decCounter1
	ret nz
	jp seasonsFunc_0d_736d

@stateCvar03_3:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$03

@@substate1:
	call seasonsFunc_0d_7312
	ret nz
	call ecom_decCounter1
	ret nz
	ld (hl),$0a
	dec l
	inc (hl)
	ld l,$90
	ld (hl),$28
	call seasonsFunc_0d_73cd

@@substate2:
	call ecom_decCounter1
	jp nz,objectApplySpeed
	ld (hl),$28
	ld l,e
	inc (hl)

@@substate3:
	call ecom_decCounter1
	ret nz
	jp seasonsFunc_0d_736d

@stateCvar03_4:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$28
	ld l,$a4
	res 7,(hl)
	call ecom_updateAngleTowardTarget
	ld a,$04
	jp enemySetAnimation

@@substate1:
	call seasonsFunc_0d_7312
	jr z,+
	call objectApplySpeed
	jr ++
+
	ld h,d
	ld l,$85
	inc (hl)
	ld l,$94
	ld a,$c0
	ldi (hl),a
	ld (hl),$fc
	ld l,$90
	ld (hl),$0f

@@substate2:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	jr nz,+
	ld e,$b0
	ld a,$02
	ld (de),a
	call enemySetAnimation
	jp seasonsFunc_0d_736d
+
	ld e,$95
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,$a4
	set 7,(hl)
+
	rla
	call c,objectApplySpeed
++
	jp enemyAnimate

seasonsFunc_0d_72d4:
	call seasonsFunc_0d_72dc
	ld e,$b2
	ld a,b
	ld (de),a
	ret

seasonsFunc_0d_72dc:
	ld b,$ff
	ld e,$8b
	ld a,(de)
	sub $20
	cp $36
	jr nc,++
	ld e,$8d
	ld a,(de)
	sub $30
	cp $40
	ret c
	ld b,$02
	ld a,(de)
	cp $50
	jr c,+
	inc b
+
	ld e,$8b
	ld a,(de)
	cp $39
	ret c
	ld a,b
	add $02
	ld b,a
	ret
++
	inc b
	ld a,(de)
	cp $39
	jr c,+
	ld b,$06
+
	ld e,$8d
	ld a,(de)
	cp $50
	ret c
	inc b
	ret

seasonsFunc_0d_7312:
	ld c,$0e
	ld e,$8f
	ld a,(de)
	or a
	jp nz,objectUpdateSpeedZ_paramC
	dec a
	ld (de),a
	ld bc,$ff80
	jp objectSetSpeedZ

seasonsFunc_0d_7323:
	call seasonsFunc_0d_7340
	ret z
	ld a,(wFrameCounter)
	and $07
	ret nz
	call objectGetAngleTowardLink
	add $04
	and $18
	swap a
	rlca
	ld h,d
	ld l,$b0
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

seasonsFunc_0d_7340:
	ld e,$84
	ld a,(de)
	cp $0c
	ret nz
	ld e,$b1
	ld a,(de)
	dec a
	jr z,+
	xor a
	ret
+
	or d
	ret

seasonsFunc_0d_7350:
	ld c,$20
	call objectCheckLinkWithinDistance
	jp nc,ecom_updateAngleTowardTarget
	call getRandomNumber_noPreserveVars
	and $01
	ld b,$f8
	jr z,+
	ld b,$08
+
	push bc
	call objectGetAngleTowardLink
	pop bc
	ld e,$89
	add b
	ld (de),a
	ret

seasonsFunc_0d_736d:
	ld h,d
	ld l,$84
	ld (hl),$08
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLAINO_INVULNERABLE
	ld l,$90
	ld (hl),$0f
	ld l,$b1
	ld (hl),$00
	ret

seasonsFunc_0d_737f:
	call getRandomNumber_noPreserveVars
	ld b,$00
	cp $30
	ret c
	inc b
	cp $90
	ret c
	inc b
	cp $e0
	ret c
	inc b
	cp $ff
	ret c
	inc b
	ret

seasonsFunc_0d_7395:
	ld bc,$4050
	call objectGetRelativeAngle
	ld b,a
	push bc
	call objectGetAngleTowardLink
	pop bc
	sub b
	add $02
	cp $05
	ret c
	ld e,$89
	ld a,b
	ld (de),a
	ld e,$85
	ld a,$01
	ld (de),a
	ret

seasonsFunc_0d_73b1:
	ld b,$09
	call objectCheckCenteredWithLink
	ret nc
	ld c,$1c
	call objectCheckLinkWithinDistance
	ret nc
	call objectGetAngleTowardLink
	ld b,a
	ld e,$b0
	ld a,(de)
	rrca
	swap a
	sub b
	add $04
	cp $09
	ret

seasonsFunc_0d_73cd:
	ld e,$b0
	ld a,(de)
	rrca
	swap a
	ld e,$89
	ld (de),a
	ret

seasonsTable_0d_73d7:
	.db $09 $17 $0f $11 $01 $1f $07 $19

seasonsFunc_0d_73df:
	ld a,$2b
	call objectGetRelatedObject2Var
	ld e,$ab
	ld a,(de)
	ld (hl),a
	ret
