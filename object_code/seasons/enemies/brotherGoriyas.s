; ==================================================================================================
; ENEMY_BROTHER_GORIYAS
; ==================================================================================================
enemyCode70:
	jr z,@normalStatus
	sub $03
	ret c
	jp z,@dead
	dec a
	jp nz,ecom_updateKnockback
@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state0
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
+
	ld a,b
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@state0:
	ld e,$97
	ld a,(de)
	or a
	jr nz,@func_45f0
	ld b,ENEMY_BROTHER_GORIYAS
	call ecom_spawnEnemyWithSubid01
	ret nz
	ld l,$96
	ld e,l
	ld a,$80
	ldi (hl),a
	ld (de),a
	inc e
	ld (hl),d
	ld a,h
	ld (de),a
	call objectCopyPosition
	ld a,d
	cp h
	jr c,@func_45f0
	ld l,$82
	xor a
	ld (hl),a
	ld e,l
	inc a
	ld (de),a
	ret

@func_45f0:
	ld a,$32
	call ecom_setSpeedAndState8AndVisible
	ld e,$82
	ld a,(de)
	or a
	jr z,@func_4602
	ld e,$8d
	ld a,(de)
	cpl
	inc a
	ld (de),a
	ret

@func_4602:
	ld e,$b0
	inc a
	ld (de),a
	ld b,$00
	dec a
	jp enemyBoss_initializeRoom

@stateStub:
	ret

@subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @@stateA
	.dw @@stateB

@@state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	
@@@substate0:
	ld a,($d00b)
	cp $78
	ret nc
	ld h,d
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	; You cannot pass
	ld bc,TX_2f00
	jp showText
	
@@@substate1:
	ld a,$02
	ld (de),a
	ld a,$2d
	ld (wActiveMusic),a
	call playSound
	
@@@substate2:
	ld a,($d00d)
	sub $28
	ld c,a

@@func_4646:
	ld a,($d00b)
	ld b,a
	ld e,$8b
	ld a,(de)
	ldh (<hFF8F),a
	ld e,$8d
	ld a,(de)
	ldh (<hFF8E),a
	sub $18
	cp $c0
	jr nc,+
	ldh a,(<hFF8F)
	sub b
	add $08
	cp $11
	jr nc,@@func_4682
	ldh a,(<hFF8E)
	sub c
	add $08
	cp $11
	jr nc,@@func_4682
+
	call getRandomNumber_noPreserveVars
	and $30
	add $60
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$b1
	ld (hl),$08
	ld l,$86
	ld (hl),a
	inc l
	ld (hl),$3c
	ret
	
@@func_4682:
	call ecom_moveTowardPosition
	call ecom_updateAnimationFromAngle
@@animate:
	jp enemyAnimate

@@state9:
	call func_4809
	jr z,@@animate
	ld e,$90
	ld a,$23
	ld (de),a
	call func_4797
	jr c,@@func_46af
@@func_469a:
	call ecom_decCounter2
	jr nz,+
	ld (hl),$3c
	call @@func_46a9
+
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,@@animate
	
@@func_46a9:
	call ecom_setRandomCardinalAngle
	jp ecom_updateAnimationFromAngle
	
@@func_46af:
	ld a,$09
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	add $10
	and $1f
	sub (hl)
	and $1f
	ld c,$28
	jr z,+
	ld c,$32
	cp $10
	jr c,+
	ld c,$1e
+
	ld e,$90
	ld a,c
	ld (de),a
	call func_47c0
	call objectGetRelativeAngle
	ld b,a
	ld e,$b1
	ld a,(de)
	add b
	and $1f
	ld e,$89
	ld (de),a
	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call func_47d0
	jr @@animate2

@@stateA:
	ld e,$b0
	ld a,(de)
	or a
	jr nz,+
	ld e,$84
	ld a,$09
	ld (de),a
	jr @@animate2
+
	ld b,PART_38
	call ecom_spawnProjectile
	jr nz,@@animate2
	ld l,$f0
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ld l,$d8
	ld a,$80
	ldi (hl),a
	ld e,$97
	ld a,(de)
	ld (hl),a
	ld h,a
	ld l,$84
	ld a,$0b
	ld (hl),a
	ld e,l
	ld (de),a
	ld e,$b0
	xor a
	ld (de),a
	ld l,e
	inc a
	ld (hl),a
	ld l,$99
	ld (hl),$01
@@animate2:
	jp enemyAnimate

@@stateB:
	ld e,$99
	ld a,(de)
	or a
	jr z,+
	dec a
	call z,func_47a5
	jr @@animate2
+
	ld a,$19
	call objectGetRelatedObject1Var
	dec (hl)
	ld l,$84
	ld a,$09
	ld (hl),a
	ld e,l
	ld (de),a
	jr @@animate2

@subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @subid0@stateA
	.dw @subid0@stateB

@@state8:
	inc e
	ld a,(de)
	or a
	jr z,+
	ld a,($d00d)
	add $28
	ld c,a
	jp @subid0@func_4646
+
	ld a,($d00b)
	cp $78
	ret nc
	ld h,d
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ret

@@state9:
	call func_4809
	jp z,enemyAnimate
	ld e,$90
	ld a,$28
	ld (de),a
	call func_4797
	jp c,@subid0@func_46af
	jp @subid0@func_469a

@dead:
	ld e,$97
	ld a,(de)
	or a
	jr z,+
	call ecom_killRelatedObj1
	ld e,$97
	xor a
	ld (de),a
+
	ld e,$99
	ld a,(de)
	sub $02
	jr c,+
	ld h,a
	ld l,$d7
	xor a
	ld (hl),a
	ld (de),a
+
	jp enemyBoss_dead
	
func_4797:
	ldh a,(<hEnemyTargetY)
	sub $40
	cp $30
	ret nc
	ldh a,(<hEnemyTargetX)
	sub $40
	cp $70
	ret

func_47a5:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,$19
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,$cb
	ld b,(hl)
	ld l,$cd
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,$89
	ld (de),a
	jp ecom_updateAnimationFromAngle
	
func_47c0:
	ld b,$58
	ld c,b
	ldh a,(<hEnemyTargetX)
	cp $60
	ret c
	ld c,$78
	cp $90
	ret c
	ld c,$98
	ret
	
func_47d0:
	call objectGetAngleTowardEnemyTarget
	ld c,a
	ld h,d
	ld l,$8b
	ldh a,(<hEnemyTargetY)
	sub (hl)
	jr nc,+
	cpl
	inc a
+
	ld b,a
	ld l,$8d
	ldh a,(<hEnemyTargetX)
	sub (hl)
	jr nc,+
	cpl
	inc a
+
	add b
	cp $30
	jr c,+
	cp $60
	ret c
	ld l,$90
	ld (hl),$0a
	ld a,c
	ld e,$89
	ld (de),a
	jr ++
+
	ld l,$90
	ld (hl),$14
	ld a,c
	add $10
	and $1f
	ld e,$89
	ld (de),a
++
	jp ecom_applyVelocityForSideviewEnemyNoHoles
	
func_4809:
	ld e,$86
	ld a,(de)
	or a
	jr z,+
	dec a
	ld (de),a
	ret nz
+
	ld bc,$0130
	call ecom_randomBitwiseAndBCE
	ld e,$86
	ld a,$20
	add c
	ld (de),a
	ld c,a
	ld a,b
	or a
	ret nz
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$97
	ld h,(hl)
	ld l,$86
	ld (hl),c
	call ecom_updateAngleTowardTarget
	call ecom_updateAnimationFromAngle
	xor a
	ret
