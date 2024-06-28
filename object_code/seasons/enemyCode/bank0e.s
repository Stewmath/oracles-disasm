; ==============================================================================
; ENEMYID_BROTHER_GORIYAS
; ==============================================================================
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
	ld b,ENEMYID_BROTHER_GORIYAS
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
	ld b,PARTID_38
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


; ==============================================================================
; ENEMYID_FACADE
; ==============================================================================
enemyCode71:
	jr z,@normalStatus
	sub $03
	ret c
	ret nz
	; dead
	ld e,$a4
	ld a,(de)
	or a
	call nz,@dead
	ld e,$82
	ld a,(de)
	or a
	jp nz,enemyDie
	jp enemyBoss_dead

@normalStatus:
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC

@state0:
	call ecom_setSpeedAndState8
	ld l,$8b
	ld (hl),$58
	ld l,$8d
	ld (hl),$78
	ld e,$82
	ld a,(de)
	or a
	ld a,$ff
	ld b,$00
	jp z,enemyBoss_initializeRoom
	ld l,$86
	ld (hl),$3c
	ld l,$84
	inc (hl)
	ret

@stateStub:
	ret

@state8:
	ldh a,(<hEnemyTargetY)
	cp $58
	ret c
	ld h,d
	ld l,e
	inc (hl)
	ld l,$86
	inc (hl)
	ld a,$2d
	ld (wActiveMusic),a
	jp playSound

@state9:
	call ecom_decCounter1
	ret nz
	ld a,$78
	ld (hl),a
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	call setScreenShakeCounter
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@table_48c4
	rst_addAToHl
	ld e,$83
	ld a,(hl)
	ld (de),a
	ld a,$b8
	call playSound
	xor a
	call enemySetAnimation
	jp objectSetVisible83

@table_48c4:
	.db $00
	.db $01
	.db $02
	.db $02

@stateA:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	and $1f
	ld a,$b8
	call z,playSound
	jr ++
+
	ld l,e
	inc (hl)
	inc l
	ld (hl),$00
++
	jp enemyAnimate

@stateB:
	call enemyAnimate
	ld e,$83
	ld a,(de)
	rst_jumpTable
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02

@var03_00:
	ld e,$85
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$14
	ret

@@substate1:
	call ecom_decCounter1
	ret nz
	ld (hl),$46
	ld l,e
	inc (hl)
	ret

@@substate2:
	call ecom_decCounter1
	jp z,@func_49e3
	ld a,(hl)
	and $0f
	ret nz
	ld l,$b0
	ld a,(hl)
	cp $05
	ret nc
	jp @func_498c

@var03_01:
	ld e,$85
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,$01
	ld (de),a
	inc a
	jp enemySetAnimation

@@substate1:
	ld h,d
	ld l,$a1
	bit 7,(hl)
	jp z,enemyAnimate
	ld l,e
	inc (hl)
	ld l,$86
	ld (hl),$b4
	ld l,$a4
	res 7,(hl)
	jp objectSetInvisible

@@substate2:
	call ecom_decCounter1
	jp z,@func_49e3
	ld a,(hl)
	and $1f
	ret nz
	jp @func_49b2

@var03_02:
	ld e,$85
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$f0
	ld a,$01
	jp enemySetAnimation

@@substate1:
	call ecom_decCounter1
	jp z,@func_49e3
	ld a,(hl)
	and $0f
	ret nz
	ld e,$a1
	ld a,(de)
	dec a
	ret nz
	ld a,$51
	call playSound
	jp @func_49d9

@stateC:
	ld h,d
	ld l,$a1
	bit 7,(hl)
	jp z,enemyAnimate
	ld l,e
	ld (hl),$09
	ld l,$86
	ld (hl),$78
	ld l,$a4
	res 7,(hl)
	jp objectSetInvisible

@func_498c:
	ld b,ENEMYID_BEETLE
	call ecom_spawnEnemyWithSubid01
	ret nz
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),d
	ld e,$b0
	ld a,(de)
	inc a
	ld (de),a
	call getRandomNumber
	ld c,a
	and $70
	add $20
	ld l,$8b
	ldi (hl),a
	inc l
	ld a,c
	and $07
	swap a
	add $40
	ld (hl),a
	ret

@func_49b2:
	ld b,PARTID_2e
	call ecom_spawnProjectile
	ret nz
	push hl
	ld bc,$1f1f
	call ecom_randomBitwiseAndBCE
	pop hl
	ldh a,(<hEnemyTargetY)
	add b
	sub $10
	and $f0
	add $08
	ld l,$cb
	ld (hl),a
	ldh a,(<hEnemyTargetX)
	add c
	sub $10
	and $f0
	add $08
	ld l,$cd
	ld (hl),a
	ret

@func_49d9:
	ld b,PARTID_VOLCANO_ROCK
	call ecom_spawnProjectile
	ret nz
	ld l,$c2
	inc (hl)
	ret

@func_49e3:
	ld l,$84
	inc (hl)
	ld a,$02
	jp enemySetAnimation

@dead:
	ld hl,$d080
-
	ld l,$81
	ld a,(hl)
	cp $51
	call z,ecom_killObjectH
	inc h
	ld a,h
	cp $e0
	jr c,-
	ret


; ==============================================================================
; ENEMYID_OMUAI
; ==============================================================================
enemyCode72:
	jr z,@normalStatus
	sub $03
	ret c
	jr nz,@justHitOrKnockback
	ld e,$a4
	ld a,(de)
	or a
	jr z,@dead
	ld hl,$d081
-
	ld a,(hl)
	cp $72
	jr nz,+
	ld a,h
	cp d
	jp nz,enemyDie_withoutItemDrop
+
	inc h
	ld a,h
	cp $e0
	jr c,-
@dead:
	jp enemyBoss_dead

@justHitOrKnockback:
	ld e,$aa
	ld a,(de)
	res 7,a
	cp $04
	jr c,@normalStatus
	ld e,$b5
	ld a,$01
	ld (de),a
@normalStatus:
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @stateStub
	.dw @state2
	.dw @stateStub
	.dw @state4
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF
	.dw @stateG
	.dw @stateH

@state0:
	ld b,$00
	ld a,$72
	call enemyBoss_initializeRoom
	jp ecom_setSpeedAndState8

@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	
@@substate0:
	ld a,$30
	ld (wLinkGrabState2),a
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$78
	ld l,$a4
	res 7,(hl)
	call func_4c7f
	ld a,$03
	call enemySetAnimation
	jp objectSetVisiblec1
	
@@substate1:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $2d
	call c,enemyAnimate
	jp enemyAnimate
+
	ld l,e
	ld (hl),$03
	jp dropLinkHeldItem
	
@@substate2:
	call func_4c3c
	jp enemyAnimate
	
@@substate3:
	ld h,d
	ld l,$84
	ld (hl),$0c
	ld l,$86
	ld (hl),$8c
	ld l,$a4
	set 7,(hl)
	inc l
	ld (hl),ENEMYCOLLISION_OMUAI_VULNERABLE ; enemyCollisionMode
	
@func_4aaf:
	call getRandomNumber_noPreserveVars
	and $1f
	ld e,$89
	ld (de),a
	ld h,d
	ld l,$90
	ld (hl),$1e
	ld l,$94
	ld a,$00
	ldi (hl),a
	ld (hl),$fe
	ret
	
@state4:
	ld a,($ccf0)
	or a
	jp z,func_4c65
	ld e,$a1
	ld a,(de)
	or a
	call nz,func_4d54
	ld hl,$d000
	call preventObjectHFromPassingObjectD
	call objectAddToGrabbableObjectBuffer
	jp enemyAnimate

@stateStub:
	ret
	
@state8:
	ld a,(wcc93)
	or a
	ret nz
	ld h,d
	ld l,e
	inc (hl)
	ld l,$86
	ld (hl),$5a
	ld a,$2d
	ld (wActiveMusic),a
	jp playSound
	
@state9:
	call ecom_decCounter1
	ret nz
	inc (hl)
	call getRandomNumber_noPreserveVars
	and $7f
	add $10
	ld c,a
	ld b,$cf
	ld a,(bc)
	cp $fa
	ret nz
	call objectSetShortPosition
	ld a,$fe
	ld (bc),a
	ld l,$b0
	ld (hl),c
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$5a
	xor a
	call enemySetAnimation
	jp objectSetVisible82
	
@stateA:
	ld hl,$d000
	call preventObjectHFromPassingObjectD
	call ecom_decCounter1
	jr nz,@animate
	ld l,$84
	inc (hl)
	ld l,$a4
	set 7,(hl)
	inc l
	ld (hl),ENEMYCOLLISION_OMUAI_GRABBABLE ; enemyCollisionMode
	ld a,$01
	jp enemySetAnimation
	
@stateB:
	ld a,($ccf0)
	or a
	jr z,+
	ld e,$84
	ld a,$04
	ld (de),a
	ld a,$06
	jp enemySetAnimation
+
	ld hl,$d000
	call preventObjectHFromPassingObjectD
	call objectAddToGrabbableObjectBuffer
	ld e,$a1
	ld a,(de)
	inc a
	jp z,func_4c65
	dec a
	call nz,func_4d54
@animate:
	jp enemyAnimate
	
@stateC:
	call ecom_decCounter1
	jr z,+
	ld c,$12
	call objectUpdateSpeedZ_paramC
	call z,@func_4aaf
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr @animate
+
	ld l,e
	inc (hl)

@func_4b72:
	ld l,$94
	ld a,$80
	ldi (hl),a
	ld (hl),$fe
	ret
	
@stateD:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jr z,+
	ldd a,(hl)
	or a
	ret nz
	ld a,(hl)
	or a
	ret nz
	ld a,$04
	jp enemySetAnimation
+
	call func_4cb6
	ld l,$84
	inc (hl)
	ld l,$90
	ld (hl),$28
	call objectSetVisible82
	jr @animate
	
@stateE:
	call enemyAnimate
	ld h,d
	ld l,$b2
	call ecom_readPositionVars
	cp c
	jr nz,@moveTowardPosition
	ldh a,(<hFF8F)
	cp b
	jr nz,@moveTowardPosition
	ld l,$84
	inc (hl)
	ld e,$b5
	ld a,(de)
	or a
	jr z,+
	inc (hl)
+
	ld l,$94
	ld a,$60
	ldi (hl),a
	ld (hl),$fe
	ld l,$90
	ld (hl),$19
	call objectSetVisiblec1
	ld a,$05
	call enemySetAnimation
	jr @func_4bf9
@moveTowardPosition:
	jp ecom_moveTowardPosition
	
@stateF:
	ld e,$a1
	ld a,(de)
	inc a
	jr nz,@animate2
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jr z,+
	call func_4d36
	jr nc,@moveTowardPosition
	ret
+
	call @func_4b72
	ld l,$b5
	bit 0,(hl)
	jr nz,+
	ld l,$86
	ld a,(hl)
	cp $03
	jr c,++
+
	ld l,$84
++
	inc (hl)
	ld a,$05
	call enemySetAnimation
	
@func_4bf9:
	ld e,$b4
	ld a,(de)
	inc a
	and $03
	ld (de),a
	ld hl,@table_4c09
	rst_addDoubleIndex
	ld e,$b2
	jp add16BitRefs

@table_4c09:
	.db $f0 $10
	.db $10 $10
	.db $10 $f0
	.db $f0 $f0

@stateG:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$a4
	res 7,(hl)
	ld l,$90
	ld (hl),$14
	ld l,$b4
	ld a,(hl)
	inc a
	and $03
	swap a
	rrca
	ld l,$89
	ld (hl),a
@animate2:
	jp enemyAnimate
	
@stateH:
	ld e,$a1
	ld a,(de)
	inc a
	jr nz,@animate2
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	jp func_4c65
	
func_4c3c:
	ld e,$8f
	ld a,(de)
	or a
	ret nz
	ld hl,$d081
-
	ld a,(hl)
	cp $72
	jr nz,+
	ld a,h
	cp d
	jr z,+
	push hl
	call func_4c88
	pop hl
	jr z,++
+
	inc h
	ld a,h
	cp $e0
	jr c,-
	call objectGetTileAtPosition
	cp $fb
	jr z,++
	cp $fa
	ret nz
++
	pop hl
	
func_4c65:
	ld b,INTERACID_SPLASH
	call objectCreateInteractionWithSubid00
	ld h,d
func_4c6b:
	ld l,$84
	ld (hl),$09
	ld l,$a4
	res 7,(hl)
	ld l,$b5
	ld (hl),$00
	ld l,$86
	ld (hl),$78
	ld l,$9a
	res 7,(hl)
	
func_4c7f:
	ld l,$b0
	ld c,(hl)
	ld b,$cf
	ld a,$fa
	ld (bc),a
	ret

func_4c88:
	push de
	ld d,h
	ld e,$8b
	call getShortPositionFromDE
	ld c,a
	pop de
	call objectGetShortPosition
	cp c
	ret nz
	push hl
	call objectGetTileAtPosition
	pop hl
	cp $fe
	ret nz
	call func_4c6b
	ld l,$8b
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_SPLASH
	ld l,$4b
	ld (hl),b
	ld l,$4d
	ld (hl),c
+
	xor a
	ret
	
func_4cb6:
	call objectGetTileAtPosition
	ld c,l
	ld hl,$cf00
	ld e,$b1
	ld b,$ff
-
	ld a,(hl)
	cp $fa
	call z,func_4d10
	inc l
	ld a,l
	cp $b0
	jr c,-
	ld a,(de)
	ld l,a
	ld (hl),$fb
	ld e,$b0
	ld (de),a
	call func_4cf8
	ldh (<hFF8E),a
	ld a,(hl)
	ldh (<hFF8F),a
	ld l,$8b
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	call objectGetRelativeAngleWithTempVars
	add $04
	and $18
	swap a
	rlca
	ld e,$b4
	ld (de),a
	ld hl,table_4d0c
	rst_addAToHl
	ld e,$b1
	ld a,(de)
	add (hl)
	ld (de),a

func_4cf8:
	ld h,d
	ld l,$b2
	ld e,$b1
	ld a,(de)
	and $f0
	add $08
	ldi (hl),a
	ld a,(de)
	and $0f
	swap a
	add $08
	ldd (hl),a
	ret

table_4d0c:
	.db $f0
	.db $01
	.db $10
	.db $ff

func_4d10:
	push de
	ld a,c
	and $f0
	swap a
	ld d,a
	ld a,l
	and $f0
	swap a
	sub d
	jr nc,+
	cpl
	inc a
+
	ld d,a
	ld a,c
	and $0f
	ld e,a
	ld a,l
	and $0f
	sub e
	jr nc,+
	cpl
	inc a
+
	add d
	pop de
	cp b
	ret nc
	ld b,a
	ld a,l
	ld (de),a
	ret

func_4d36:
	ld h,d
	ld e,$8b
	ld a,(de)
	ldh (<hFF8F),a
	ld l,$b2
	ldi a,(hl)
	sub $02
	ld b,a
	ld e,$8d
	ld a,(de)
	ldh (<hFF8E),a
	ld c,(hl)
	sub c
	inc a
	cp $02
	ret nc
	ldh a,(<hFF8F)
	sub b
	inc a
	cp $02
	ret
	
func_4d54:
	xor a
	ld (de),a
	ld b,PARTID_GOPONGA_PROJECTILE
	call ecom_spawnProjectile
	ret nz
	ld l,$c2
	inc (hl)
	ld l,$cb
	ld a,(hl)
	sub $04
	ld (hl),a
	ret


; ==============================================================================
; ENEMYID_AGUNIMA
; ==============================================================================
enemyCode73:
	jr z,@normalStatus
	sub $04
	jr z,@justHit
	inc a
	ret nz
	; dead
	ld e,$b0
	ld a,(de)
	bit 7,a
	jp z,enemyDelete
	ld a,(wFrameCounter)
	and $0f
	jr nz,+
	ld e,$b3
	ld a,(de)
	sub $04
	and $0c
	ld (de),a
	call enemySetAnimation
+
	jp enemyBoss_dead
@justHit:
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_AGUNIMA_INVULNERABLE
	jr z,@normalStatus
	ld a,$29
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	cp (hl)
	jr z,@normalStatus
	ld e,$b0
	ld a,(de)
	bit 7,a
	jr z,@normalStatus
	ld l,$b1
	ld e,$a9
	ld a,(de)
	ld c,a
-
	push hl
	ld h,(hl)
	ld l,$a9
	ld (hl),c
	ld l,$84
	ld (hl),$0e
	ld l,$a4
	res 7,(hl)
	ld l,$86
	ld (hl),$01
	pop hl
	inc l
	ld a,$b4
	cp l
	jr nz,-
	ld l,$a9
	ld (hl),c
	ld e,$99
	ld a,(de)
	or a
	jr z,+
	ld h,a
	ld l,$d7
	ld (hl),$ff
+
	ld a,c
	or a
	ld h,d
	ret z
	ld l,$ab
	ld a,$4b
	ldi (hl),a
	inc l
	ld (hl),a
	ret

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,+
	dec b
	jp z,agunimaSubId01
	jp agunimaSubId00
+
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub

@state0:
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8
	inc a
	ld (de),a
	ld a,$73
	jp enemyBoss_initializeRoom

@state1:
	ld b,$04
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMYID_AGUNIMA
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,$b1
	ld c,h
	ld e,$03
-
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),c
	ld a,h
	pop hl
	ldi (hl),a
	dec e
	jr nz,-
	jp enemyDelete

@stateStub:
	ret

agunimaSubId01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5

@@substate0:
	ld a,(wcc93)
	or a
	ret nz
	ld bc,$010c
	call enemyBoss_spawnShadow
	ret nz
	inc a
	ld (de),a
	ld bc,TX_2f02
	jp showText

@@substate1:
	ld a,$2d
	ld (wActiveMusic),a
	call playSound
	ld h,d
	ld l,$86
	ld (hl),$3c
	ld a,$b1
	ld bc,$3737
	jr @@func_4e86

@@substate2:
	call ecom_decCounter1
	ret nz
	ld l,$b0
	ld (hl),$00
	ld a,$b2
	ld bc,$7437
	jr @@func_4e86

@@substate3:
	ld h,d
	ld l,$b0
	bit 0,(hl)
	ret z
	ld (hl),$00
	ld a,$b3
	ld bc,$7a74

@@func_4e86:
	ld l,e
	inc (hl)
	ld l,a
	ld h,(hl)
	ld l,$b0
	ld (hl),$01
	ld l,$8b
	call setShortPosition_paramC
	ld l,$b1
	ld a,b
	and $f0
	add $08
	ldi (hl),a
	ld a,b
	and $0f
	swap a
	add $08
	ld (hl),a
	ret

@@substate4:
	ld h,d
	ld l,$b0
	bit 0,(hl)
	ret z
	ld (hl),$00
	ld l,e
	inc (hl)
	inc l
	ld (hl),$3c
	jp func_502a

@@substate5:
	call ecom_decCounter1
	ret nz
	ld l,$84
	inc (hl)
	ld e,$b1
	ld l,$b0
	ld b,$03
-
	ld a,(de)
	ld h,a
	set 0,(hl)
	inc e
	dec b
	jr nz,-
	ret

@state9:
	ld e,$b1
	ld l,$b0
	ld b,$03
-
	ld a,(de)
	ld h,a
	ld a,(hl)
	or a
	ret nz
	inc e
	dec b
	jr nz,-
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$3c
	ret

@stateA:
	call ecom_decCounter1
	ret nz
	ld l,e
	dec (hl)
	jp func_5007

agunimaSubId00:
	call func_5104
	call func_5122
	call func_512b
	ld e,$84
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE

@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_AGUNIMA_INVULNERABLE
	ld l,$90
	ld (hl),$14
	ld l,$8f
	ld (hl),$fc
	call getRandomNumber_noPreserveVars
	ld e,$b5
	ld (de),a
	ld e,$87
	ldh a,(<hRng2)
	ld (de),a
	call objectSetVisible81
	jp objectSetInvisible

@state9:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld h,d
	ld l,$b0
	bit 0,(hl)
	ret z
	ld l,e
	inc (hl)
	ld l,$b0
	set 1,(hl)
	call @@func_4f55
	ld a,$08
	jr z,+
	call objectGetRelativeAngleWithTempVars
	add $04
	and $18
	rrca
+
	ld e,$b3
	ld (de),a
	call enemySetAnimation
	jp func_507e

@@func_4f55:
	ld h,d
	ld l,$b1
	call ecom_readPositionVars
	cp c
	ret nz
	ldh a,(<hFF8F)
	cp b
	ret

@@substate1:
	call @@func_4f55
	jp nz,ecom_moveTowardPosition
	ld l,e
	inc (hl)
	ld l,$b0
	res 0,(hl)
	ld l,$97
	ld h,(hl)
	ld l,$b0
	ld (hl),$01

@@substate2:
	call func_5131
	ld h,d
	ld l,$b0
	bit 0,(hl)
	jp z,func_5071
	ld l,$84
	ld (hl),$0c
	ld l,$a4
	set 7,(hl)
	ld l,$b0
	res 1,(hl)
	ld l,$86
	ld (hl),$14
	jp objectSetVisible81

@stateA:
	ld h,d
	ld l,$b0
	bit 0,(hl)
	ret z
	set 1,(hl)
	ld l,e
	inc (hl)
	ld l,$86
	ld (hl),$3c
	jp func_5071

@stateB:
	call ecom_decCounter1
	jp nz,seasonsFunc_0e_506b
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$b0
	res 1,(hl)
	ld l,$86
	ld (hl),$08
	jp objectSetVisible81

@stateC:
	call ecom_decCounter1
	jp nz,seasonsFunc_0e_506b
	inc (hl)
	ld b,PARTID_39
	call ecom_spawnProjectile
	jp nz,seasonsFunc_0e_506b
	ld h,d
	ld l,$86
	ld (hl),$98
	ld l,$84
	inc (hl)
	ret

@stateD:
	call ecom_decCounter1
	jp nz,seasonsFunc_0e_50cf
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$a4
	res 7,(hl)
	ld l,$b0
	set 1,(hl)
	ld l,$86
	ld (hl),$3c
	ret

@stateE:
	call ecom_decCounter1
	ret nz
	ld l,e
	ld (hl),$0a
	ld l,$b0
	ld (hl),$00
	ld l,Enemy.enemyCollisionMode
	ld a,(hl)
	cp ENEMYCOLLISION_AGUNIMA_VULNERABLE
	jr nz,+
	ld (hl),ENEMYCOLLISION_AGUNIMA_INVULNERABLE
	ld l,$97
	ld h,(hl)
	ld l,$8f
	ld (hl),$00
+
	jp objectSetInvisible

func_5007:
	call getRandomNumber_noPreserveVars
	and $03
	ld b,a
	add a
	add b
	ld hl,table_5053
	rst_addDoubleIndex
	ld e,$b1
-
	ld a,(de)
	ld b,a
	ld c,$8b
	ldi a,(hl)
	ld (bc),a
	ld c,$8d
	ldi a,(hl)
	ld (bc),a
	ld c,$b0
	ld a,$01
	ld (bc),a
	inc e
	ld a,$b4
	cp e
	jr nz,-

func_502a:
	call getRandomNumber_noPreserveVars
	and $03
	cp $03
	jr z,func_502a
	add $b1
	ld e,a
	ld a,(de)
	ld h,a
	ld l,$b0
	set 7,(hl)
	ld l,$89
	ld a,(hl)
	swap a
	rlca
	ld bc,table_50cb
	call addAToBc
	ld l,$8b
	ld e,l
	ldi a,(hl)
	ld (de),a
	inc l
	ld e,l
	ld a,(bc)
	add (hl)
	ld (de),a
	ret

table_5053:
	.db $38 $78 $78 $48 $78 $a8
	.db $38 $48 $38 $a8 $78 $78
	.db $30 $40 $58 $40 $80 $40
	.db $30 $b0 $58 $b0 $80 $b0

seasonsFunc_0e_506b:
	ld a,(wFrameCounter)
	and $07
	ret nz
func_5071:
	call ecom_updateCardinalAngleTowardTarget
	rrca
	ld h,d
	ld l,$b3
	cp (hl)
	ret z
	ld (hl),a
	call enemySetAnimation
func_507e:
	ld e,$89
	ld a,(de)
	bit 3,a
	ld b,$08
	jr z,+
	ld b,$05
+
	ld e,$a7
	ld a,b
	ld (de),a
	call func_50ab
	ld e,$b0
	ld a,(de)
	bit 7,a
	ret z
	ld e,$89
	ld a,(de)
	swap a
	rlca
	ld hl,table_50cb
	rst_addAToHl
	ld c,(hl)
	ld b,$00
	ld a,$0b
	call objectGetRelatedObject1Var
	jp objectCopyPositionWithOffset

func_50ab:
	ld e,$b3
	ld a,(de)
	inc a
	and $03
	ret nz
	ld e,$8d
	ld a,(de)
	add $03
	and $f8
	ld (de),a
	ld h,d
	ld l,$89
	bit 3,(hl)
	ret z
	bit 4,(hl)
	ld b,$03
	jr z,+
	ld b,$fd
+
	add b
	ld (de),a
	ret

table_50cb:
	.db $00
	.db $fd
	.db $00
	.db $03

seasonsFunc_0e_50cf:
	call func_50f2
	ld e,$b4
	ld a,b
	ld (de),a
	ld e,$87
	ld a,(de)
	dec a
	ld (de),a
	and $07
	call z,ecom_updateCardinalAngleTowardTarget
	ld e,$89
	ld a,(de)
	rrca
	ld h,d
	ld l,$b4
	add (hl)
	ld l,$b3
	cp (hl)
	ret z
	ld (hl),a
	call enemySetAnimation
	jr func_507e

func_50f2:
	ld e,$86
	ld a,(de)
	ld b,$00
	cp $8e
	ret nc
	inc b
	cp $84
	ret nc
	inc b
	cp $7a
	ret nc
	inc b
	ret

func_5104:
	ld h,d
	ld l,$b5
	dec (hl)
	ld a,(hl)
	and $0f
	ret nz
	ld a,(hl)
	and $70
	swap a
	ld hl,table_511a
	rst_addAToHl
	ld e,$8f
	ld a,(hl)
	ld (de),a
	ret

table_511a:
	.db $fc $fb $fa $fb
	.db $fc $fd $fe $fd

func_5122:
	ld e,$b0
	ld a,(de)
	bit 1,a
	ret z
	jp ecom_flickerVisibility

func_512b:
	ld e,$84
	ld a,(de)
	cp $0b
	ret c
func_5131:
	ld h,d
	ld l,$b0
	bit 7,(hl)
	ret z
	ld a,($cca9)
	cp $02
	ld a,ENEMYCOLLISION_AGUNIMA_INVULNERABLE
	ld b,$00
	jr nz,+
	ld a,ENEMYCOLLISION_AGUNIMA_VULNERABLE
	ld b,$fc
+
	ld e,Enemy.enemyCollisionMode
	ld (de),a
	ld a,$0f
	call objectGetRelatedObject1Var
	ld (hl),b
	ret


; ==============================================================================
; ENEMYID_SYGER
; ==============================================================================
enemyCode74:
	jr z,@normalStatus
	sub $03
	ret c
	sub $01
	jr z,@justHit
	jr nc,@normalStatus
	ld e,$82
	ld a,(de)
	dec a
	jr nz,@normalStatus
	ld a,$04
	call objectGetRelatedObject2Var
	ld a,$0a
	cp (hl)
	jr c,+
	ld (hl),a
	ld a,$d1
	call playSound
+
	jp enemyBoss_dead
@justHit:
	ld e,$82
	ld a,(de)
	dec a
	jr z,@normalStatus
	ld a,$2b
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	ld (hl),a
	ld l,$84
	ld a,(hl)
	cp $09
	jr nz,+
	ld l,$86
	ld (hl),$1c
+
	ld l,$a9
	ld e,l
	ld a,(de)
	ld (hl),a
	or a
	jr nz,@normalStatus
	ld l,$a4
	res 7,(hl)
@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,+
	dec b
	jp z,sygerSubId01
	jp sygerSubId00
+
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	
@state0:
	ld a,$01
	ld (de),a
	ld e,$82
	ld a,(de)
	or a
	jp nz,ecom_setSpeedAndState8
	ld a,$74
	jp enemyBoss_initializeRoom
	
@state1:
	ld b,$02
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMYID_SYGER
	call ecom_spawnUncountedEnemyWithSubid01
	ld c,h
	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),c
	ld b,h
	ld h,c
	ld l,$98
	ldi (hl),a
	ld (hl),b
	call objectCopyPosition
	jp enemyDelete
	
@stateStub:
	ret
	
sygerSubId01:
	ld e,$84
	ld a,(de)
	sub $08
	cp $03
	jr c,@state8toA
	call func_54b5
	ld e,Enemy.var35
	ld a,(de)
	ld e,$84
	rst_jumpTable
	.dw @var35_00
	.dw @var35_01
	.dw @var35_02
@state8toA:
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	
@state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	
@@substate0:
	ld bc,$0108
	call enemyBoss_spawnShadow
	ret nz
	call ecom_setZAboveScreen
	ld l,$85
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_SYGER_BODY
	ld a,$02
	call func_5512
	jp objectSetVisible81
	
@@substate1:
	ld c,$18
	call objectUpdateSpeedZAndBounce
	jr nz,@animate
	jr nc,+
	ld h,d
	ld l,$85
	inc (hl)
	inc l
	ld (hl),$5a
	xor a
	call func_5512
	ld a,$2d
	ld (wActiveMusic),a
	call playSound
+
	ld a,$8f
	call playSound
	jr @animate
	
@@substate2:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $46
	ld a,$d1
	call z,playSound
	jr @animate
+
	ld l,e
	ld (hl),$00
	dec l
	ld (hl),$0b
	call func_556f
	jr @animate
	
@state9:
	call ecom_decCounter1
	jr nz,+
	inc l
	ldd a,(hl)
	ld (hl),a
	ld l,e
	inc (hl)
	dec a
	jr z,@animate
	ld l,$90
	ld (hl),$78
	ld a,$02
	ld l,$87
	ld (hl),a
	jp func_5512
+
	ld l,$86
	ld a,(hl)
	cp $96
	jr nc,@animate
	call func_554a
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed
@animate:
	jp enemyAnimate
	
@stateA:
	call ecom_decCounter1
	jr z,+
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jp nz,seasonsFunc_0e_5523
	ld a,$8f
	call playSound
	ld h,d
	ld l,$87
	dec (hl)
	jr z,+
	dec l
	ld (hl),$f0
	ld l,$94
	ld a,$40
	ldi (hl),a
	ld (hl),$fe
	jr @animate
+
	ld l,$84
	inc (hl)
	jp func_556f
	
@var35_00:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$1e
	ld l,$a6
	ld a,$09
	ldi (hl),a
	ld (hl),a
	ld a,$03
	call func_5512

@@substate1:
	call ecom_decCounter1
	jp nz,seasonsFunc_0e_557b
	ld (hl),$78
	inc l
	ld (hl),$02
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$46
	call ecom_updateAngleTowardTarget
	jr @animate

@@substate2:
	call ecom_decCounter1
	jr nz,@func_5365
	ld (hl),$2d
	inc l
	dec (hl)
	jp z,func_54c6
	call ecom_updateAngleTowardTarget
	jr @animate
	
@var35_01:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$0f
	ld l,$a6
	ld a,$09
	ldi (hl),a
	ld (hl),a
	ld l,$90
	ld (hl),$78
	ld a,$03
	call func_5512

@@substate1:
	call seasonsFunc_0e_557b
	call ecom_decCounter1
	ret nz
	ld l,$85
	inc (hl)
	call getRandomNumber_noPreserveVars
	and $01
	ld hl,table_55ab
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$89
	ldi a,(hl)
	ld (de),a
	ld e,$b8
	ldi a,(hl)
	ld (de),a
@@func_5339:
	ld e,$86
	ldi a,(hl)
	ld (de),a
	ld e,$b1
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@@substate2:
	call ecom_decCounter1
	jp nz,@func_5365
	ld e,$b1
	ld a,(de)
	ld l,a
	inc e
	ld a,(de)
	ld h,a
	ld a,(hl)
	inc a
	jp z,func_54c6
	ld e,$b8
	ld a,(de)
	ld b,a
	ld e,$89
	ld a,(de)
	add b
	and $1f
	ld (de),a
	call @@func_5339
@func_5365:
	call func_5563
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed
	call func_556f
	jp seasonsFunc_0e_557b
	
@var35_02:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	
@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$3c
	inc l
	ld (hl),$04
	ld l,$a6
	ld a,$09
	ldi (hl),a
	ld (hl),a
	ret
	
@@substate1:
	call ecom_decCounter2
	ld l,$94
	ld a,$80
	ldi (hl),a
	ld (hl),$fe
	ld l,e
	jr nz,+
	ld (hl),$05
	ret
+
	inc (hl)
	ld l,$90
	ld (hl),$64
	ld l,$87
	ld a,(hl)
	dec a
	ld bc,table_55a8
	call addAToBc
	ld l,$b6
	ld a,(bc)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld b,$18
	cp b
	jr c,+
	ld b,$d8
	cp b
	jr nc,+
	ld b,a
+
	ld (hl),b
	ld e,$87
	ld a,(de)
	and $01
	inc a
	jp func_5512
	
@@substate2:
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jp nz,seasonsFunc_0e_5518
	ld l,$85
	inc (hl)
	inc l
	ld (hl),$1e
	ld l,$87
	ld a,(hl)
	and $01
	swap a
	ld l,$89
	ld (hl),a
	ld a,$8f
	call playSound
@@animate:
	jp enemyAnimate
	
@@substate3:
	call ecom_decCounter1
	jr z,++
	ld a,(hl)
	cp $14
	jr nc,+
	call enemyAnimate
	ld a,(wFrameCounter)
	and $07
	ld a,$6b
	call z,playSound
+
	jr @@animate
++
	ld l,e
	inc (hl)
	ld a,$bb
	call playSound
	jr @@animate
	
@@substate4:
	call enemyAnimate
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call nz,ecom_applyVelocityForSideviewEnemyNoHoles
	ret nz
	ld e,$85
	ld a,$01
	ld (de),a
	ret
	
@@substate5:
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jr nz,@@animate
	ld a,$8f
	call playSound
	jp func_54c9
	
sygerSubId00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB

@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$a6
	ld (hl),$03
	inc l
	ld (hl),$08
	ld a,$04
	jp enemySetAnimation

@state9:
	call enemyAnimate
	ld a,$30
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ld e,$b0
	jr z,+
	ld a,$01
	ld (de),a
	ld h,d
	ld l,$a4
	res 7,(hl)
	jp objectSetInvisible
+
	ld a,(de)
	dec a
	jr nz,+
	ld (de),a
	call getRandomNumber
	and $01
	inc a
	xor $01
	ld bc,table_559c
	call addAToBc
	ld e,$b1
	ld a,(bc)
	ld (de),a
	inc e
	inc bc
	ld a,(bc)
	ld (de),a
	inc bc
	ld a,(bc)
	push hl
	call enemySetAnimation
	pop hl
+
	ld e,$b1
	ld a,(de)
	ld b,a
	inc e
	ld a,(de)
	ld c,a
	call objectTakePositionWithOffset
	ld h,d
	ld l,$a4
	set 7,(hl)
	jp objectSetVisible82

@stateA:
	ld h,d
	ld l,$9a
	bit 7,(hl)
	jp z,enemyDelete
	ld l,$a4
	res 7,(hl)
	ld l,e
	inc (hl)

@stateB:
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $74
	jp nz,enemyDelete
	ld l,$9a
	ld e,l
	ld a,(hl)
	ld (de),a
	ret
	
func_54b5:
	ld e,$b5
	ld a,(de)
	cp $02
	ret z
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,$6d
	jp playSound

func_54c6:
	call func_5563
func_54c9:
	ld bc,$1f01
	call ecom_randomBitwiseAndBCE
	ld h,d
	ld l,$90
	ld (hl),$14
	ld l,$89
	ld (hl),b
	ld e,$b5
	ld a,(de)
	add a
	add c
	ld hl,table_55a2
	rst_addAToHl
	ld e,$b5
	ld a,(hl)
	ld (de),a
	dec a
	jr z,+
	call func_556f
	ld l,$84
	ld (hl),$09
	inc l
	ld (hl),$00
	ld l,$86
	ld (hl),$b4
	inc l
	ld (hl),$01
	jr ++
	call func_5563
+
	ld bc,$fe20
	call objectSetSpeedZ
	ld l,$84
	ld (hl),$09
	inc l
	ld (hl),$00
	ld l,$86
	ld (hl),$78
	inc l
	ld (hl),$f0
++
	xor a
	
func_5512:
	ld e,$b0
	ld (de),a
	jp enemySetAnimation

seasonsFunc_0e_5518:
	call enemyAnimate
	ld h,d
	ld l,$b6
	call ecom_readPositionVars
	jr +

seasonsFunc_0e_5523:
	call enemyAnimate
	ld bc,$3878
	ld h,d
	ld l,$8b
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
+
	sub c
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition
	ld (hl),c
	ld l,$8b
	ld (hl),b
	ret

func_554a:
	ld a,($ccf0)
	or a
	jr nz,+
	ld a,(wFrameCounter)
	and $3f
	ret nz
	call getRandomNumber_noPreserveVars
	and $1f
	ld e,$89
	ld (de),a
	ret
+
	inc (hl)
	jp ecom_updateAngleToScentSeed

func_5563:
	ld h,d
	ld l,$b3
	ld e,$8b
	ldi a,(hl)
	ld (de),a
	ld e,$8d
	ld a,(hl)
	ld (de),a
	ret

func_556f:
	ld h,d
	ld l,$b3
	ld e,$8b
	ld a,(de)
	ldi (hl),a
	ld e,$8d
	ld a,(de)
	ld (hl),a
	ret

seasonsFunc_0e_557b:
	call enemyAnimate
	call func_5563
	ld e,$a1
	ld a,(de)
	ld hl,table_5594
	rst_addAToHl
	ld e,$8b
	ld a,(de)
	add (hl)
	ld (de),a
	inc hl
	ld e,$8d
	ld a,(de)
	add (hl)
	ld (de),a
	ret

table_5594:
	.db $04 $04 $04 $fc
	.db $fc $fc $fc $04

table_559c:
	.db $f6 $10 $04
	.db $f6 $f0 $05

table_55a2:
	.db $01 $02 $00
	.db $02 $00 $01

table_55a8:
	.db $1c $94 $1c

table_55ab:
	.dw table_55af
	.dw table_55bf

table_55af:
	.db $10 $f8 $0a $07
	.db $05 $0e $0a $1b
	.db $14 $28 $1e $32
	.db $21 $3b $25 $ff

table_55bf:
	.db $0c $02 $40 $07
	.db $07 $07 $26 $0b
	.db $0c $0c $2d $05
	.db $05 $05 $2d $0a
	.db $0a $0a $46 $ff


; ==============================================================================
; ENEMYID_VIRE
;
; Variables (for main form, subid 0):
;   relatedObj2: INTERACID_PUFF?
;   var30: Rotation angle?
;   var32: Used for animations?
;   var33: Health?
;   var34: Number of "bat children" alive. Will die when this reaches 0.
;   var37: Marks whether text has been shown as health goes down
;   var38: If nonzero, he won't spawn a fairy when defeated?
;
; Variables (for bat form, subid 1):
;   relatedObj1: Reference to main form (subid 0)
;   var30: Rotation angle?
;   var35/var36: Target position?
; ==============================================================================
enemyCode75:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

	; ENEMYSTATUS_JUST_HIT
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld e,Enemy.health
	ld a,(de)
	jr z,++
	or a
	ret z
	jr @normalStatus
++
	ld h,d
	ld l,Enemy.var33
	cp (hl)
	jr z,@normalStatus

	ld (hl),a
	or a
	ret z

	ld l,Enemy.state
	ld (hl),$0e
	inc l
	ld (hl),$00
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,@subid0Dead

	; Subid 1 (bat child) death
	call objectCreatePuff
	ld a,Object.var34
	call objectGetRelatedObject1Var
	dec (hl)
	call z,objectCopyPosition
	jp enemyDelete

@subid0Dead:
	ld h,d
	ld l,Enemy.state
	ld a,(hl)
	cp $0f
	jp z,enemyBoss_dead

	ld (hl),$0f ; [state]
	inc l
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),20 ; [counter1]

	ld l,Enemy.health
	ld (hl),$01

	ld l,Enemy.direction
	xor a
	ld (hl),a
	call enemySetAnimation

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,@commonState

	ld a,b
	or a
	jp z,vire_mainForm
	jp vire_batForm

@commonState:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw vire_state_uninitialized
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub
	.dw vire_state_stub


vire_state_uninitialized:
	ld a,SPEED_c0
	call ecom_setSpeedAndState8

	ld a,b
	or a
	ret nz

	; "Main" vire only (not bat form)
	ld l,Enemy.zh
	ld (hl),$fc

	dec a ; a = $ff
	ld b,$00
	jp enemyBoss_initializeRoom


vire_state_stub:
	ret


vire_mainForm:
	ld e,Enemy.direction
	ld a,(de)
	or a
	jr z,@runState

	ld h,d
	ld l,Enemy.var32
	inc (hl)
	ld a,(hl)
	cp $18
	jr c,@runState

	xor a
	ld (hl),a ; [var32] = 0

	ld l,e
	ld (hl),a ; [direction] = 0
	call enemySetAnimation

@runState:
	ld e,Enemy.state
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw vire_mainForm_state8
	.dw vire_mainForm_state9
	.dw vire_mainForm_stateA
	.dw vire_mainForm_stateB
	.dw vire_mainForm_stateC
	.dw vire_mainForm_stateD
	.dw vire_mainForm_stateE
	.dw vire_mainForm_stateF


; Mini-cutscene before starting fight
vire_mainForm_state8:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Wait for Link to approach
	ldh a,(<hEnemyTargetY)
	sub $38
	cp $41
	ret nc
	ldh a,(<hEnemyTargetX)
	sub $50
	cp $51
	ret nc

	; Can't be dead...
	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	ldbc INTERACID_PUFF, $02
	call objectCreateInteraction
	ret nz

	; [relatedObj2] = INTERACID_PUFF
	ld e,Enemy.relatedObj2+1
	ld a,h
	ld (de),a
	dec e
	ld a,Interaction.start
	ld (de),a

	ld e,Enemy.substate
	ld a,$01
	ld (de),a
	ld (wDisabledObjects),a ; DISABLE_LINK
	ld (wDisableLinkCollisionsAndMenu),a
	ret

@substate1:
	; Wait for puff to disappear
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	ld h,d
	ld l,Enemy.substate
	inc (hl)
	inc l
	ld (hl),$08 ; [counter1]
	jp objectSetVisiblec1

@substate2:
	; Show text in 8 frames
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [substate]
	ld bc,TX_2f12
	call checkIsLinkedGame
	jr z,+
	inc c ; TX_2f13
+
	jp showText

@substate3:
	; Disappear
	call objectCreatePuff
	ret nz

	; a == 0
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a

.ifdef ROM_AGES
	call ecom_incState
.else
	ld h,d
	ld l,Enemy.state
	inc (hl)
.endif

	inc l
	ldi (hl),a ; [substate] = 0
	ld (hl),90 ; [counter1]

	ld l,Enemy.health
	ld a,(hl)
	ld l,Enemy.var33
	ld (hl),a

	call objectSetInvisible
	ld a,MUS_MINIBOSS
	ld (wActiveMusic),a
	jp playSound


; Off-screen for [counter1] frames
vire_mainForm_state9:
	call ecom_decCounter1
	ret nz

	; Decide what to do next (health affects probability)
	ld e,Enemy.health
	ld a,(de)
	ld c,$08
	cp $0a
	jr c,++
	ld c,$04
	cp $10
	jr c,++
	ld c,$00
++
	call getRandomNumber
	and $07
	add c
	ld hl,@behaviourTable
	rst_addAToHl

	ld a,(hl)
	ld e,Enemy.state
	ld (de),a
	ret

; Vire chooses from 8 of these values, starting from index 0, 4, or 8 depending on health
; (starts from 0 when health is high).
@behaviourTable:
	.db $0a $0a $0b $0d $0a $0a $0a $0a
	.db $0b $0b $0c $0d $0a $0b $0c $0d


; Charges across screen
vire_mainForm_stateA:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call vire_spawnOutsideCamera
	inc l
	ld (hl),20 ; [counter1]
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ret

; Moving slowly before charging
@substate1:
	call ecom_decCounter1
	jp nz,vire_mainForm_applySpeedAndAnimate

	; Begin charging
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.speed
	ld (hl),SPEED_200
	call ecom_updateAngleTowardTarget
	call getRandomNumber_noPreserveVars
	and $03
	sub $02
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	add b
	and $1f
	ld (de),a

; Charging across screen
@substate2:
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	call ecom_decCounter1
	ld a,(hl)
	and $1f
	call z,vire_mainForm_fireProjectile
	jp vire_mainForm_applySpeedAndAnimate


; Circling Link, runs away if Link gets too close (similar to state D)
vire_mainForm_stateB:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0: ; Also subid 0 for state D
	call vire_spawnOutsideCamera
	inc l
	ld (hl),120 ; [counter1]
	call getRandomNumber_noPreserveVars
	and $08
	jr nz,+
	ld a,$f8
+
	ld e,Enemy.var30
	ld (de),a
	ret

@substate1:
	ld a,(wFrameCounter)
	and $03
	jr nz,++

	call ecom_decCounter1
	jr z,@beginCharge

	ld a,(hl)
	and $1f
	ld b,$01
	call z,vire_mainForm_fireProjectileWithSubid
++
	call vire_mainForm_checkLinkTooClose
	jp nc,vire_mainForm_circleAroundScreen

; Begin charging; initially toward Link, but will run away if he gets too close or Link
; attacks
@beginCharge:
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_200
	call ecom_updateAngleTowardTarget
	jr @animate

; Charging toward Link
@substate2:
	call vire_mainForm_checkLinkTooClose
	jr c,@updateAngleAway
	ld a,(wLinkUsingItem1)
	or a
	jr nz,@updateAngleAway
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	jp vire_mainForm_applySpeedAndAnimate

; Charging away from Link
@updateAngleAway:
	ld l,e
	inc (hl) ; [substate]
	call ecom_updateCardinalAngleAwayFromTarget
@animate:
	jp enemyAnimate

@substate3:
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen

	call ecom_decCounter1
	ld a,(hl)
	and $1f
	ld b,$01
	call z,vire_mainForm_fireProjectileWithSubid
	jp vire_mainForm_applySpeedAndAnimate


; Vire creeps in from the screen edge to fire one projectile, then runs away
vire_mainForm_stateC:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call vire_spawnOutsideCamera
	inc l
	ld (hl),28 ; [counter1]
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ret

@substate1:
	call ecom_decCounter1
	jp nz,vire_mainForm_applySpeedAndAnimate

	ld (hl),12 ; [counter1]
	ld l,e
	inc (hl) ; [substate]

	ld b,$03
	call vire_mainForm_fireProjectileWithSubid
	jr @animate

@substate2:
	call ecom_decCounter1
	jr nz,@animate

	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ld l,Enemy.speed
	ld (hl),SPEED_200

@animate:
	jp enemyAnimate

@substate3:
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	jp vire_mainForm_applySpeedAndAnimate


; Circling Link, runs away if Link attempts to attack (similar to state B)
vire_mainForm_stateD:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw vire_mainForm_stateB@substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw vire_state_moveOffScreen

@substate1:
	ld a,(wFrameCounter)
	and $03
	jr nz,++

	call ecom_decCounter1
	jr z,@beginCharge

	ld a,(hl)
	and $1f
	ld b,$01
	call z,vire_mainForm_fireProjectileWithSubid
++
	call vire_mainForm_checkLinkTooClose
	jp nc,vire_mainForm_circleAroundScreen

; Begin charging; initially toward Link, but will run away if he gets too close or Link
; attacks
@beginCharge:
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_200
	call ecom_updateAngleTowardTarget
@animate:
	jp enemyAnimate

; Charging toward Link
@substate2:
	ld a,(wLinkUsingItem1)
	or a
	jr z,@moveOffScreen

	ld h,d
	ld l,e
	inc (hl) ; [substate]
	inc l
	ld (hl),12 ; [counter1]
	ld l,Enemy.speed
	ld (hl),SPEED_300
	call ecom_updateCardinalAngleAwayFromTarget
	jr @animate

@moveOffScreen:
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	jp vire_mainForm_applySpeedAndAnimate

@substate3:
	call ecom_decCounter1
	jp nz,vire_mainForm_applySpeedAndAnimate

	ld (hl),12 ; [counter1]
	ld l,e
	inc (hl) ; [substate]

	ld b,PARTID_VIRE_PROJECTILE
	call ecom_spawnProjectile

	ld a,SND_SPLASH
	call playSound
	jr @animate

@substate4:
	call ecom_decCounter1
	jr nz,@animate

	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.speed
	ld (hl),SPEED_1c0

	call ecom_updateCardinalAngleAwayFromTarget
	jr @animate


vire_state_moveOffScreen: ; Used by states D and E
	call vire_checkOffScreen
	jp nc,vire_mainForm_leftScreen
	jp vire_mainForm_applySpeedAndAnimate


; Just took damage
vire_mainForm_stateE:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw vire_state_moveOffScreen

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	inc l
	ld (hl),20 ; [counter1]

	ld l,Enemy.speed
	ld (hl),SPEED_300
	call ecom_updateCardinalAngleAwayFromTarget

	ld e,Enemy.direction
	xor a
	ld (de),a

	ld e,Enemy.var32
	ld (de),a
	jp enemySetAnimation

@substate1:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [substate]

	; Check whether to show text based on current health
	ld l,Enemy.health
	ld a,(hl)
	cp $10
	ret nc

	ld b,$01
	cp $0a
	jr nc,+
	inc b
+
	ld a,b
	ld l,Enemy.var37
	cp (hl)
	ret z

	ld (hl),a
	add <TX_2f13
	ld c,a
	ld b,>TX_2f00
	jp showText


; "Main form" died, about to split into bats
vire_mainForm_stateF:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [counter1]
	ld bc,TX_2f16
	jp showText

@substate1:
	ld b,$02
	call checkBEnemySlotsAvailable
	jp nz,enemyAnimate

	ld h,d
	ld l,Enemy.substate
	inc (hl)

	ld l,Enemy.var34
	ld (hl),$02

	call objectSetInvisible
	call objectCreatePuff

	; Spawn bats
	ld b,ENEMYID_VIRE
	call ecom_spawnUncountedEnemyWithSubid01
	call @initBat

	call ecom_spawnUncountedEnemyWithSubid01
	inc a

@initBat:
	inc l
	ld (hl),a ; [var03] = a (0 or 1)
	rrca
	swap a
	jr nz,+
	ld a,$f8
+
	ld l,Enemy.var30 ; Bat's x-offset relative to vire
	ld (hl),a

	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	jp objectCopyPosition

@substate2:
	; Wait for "bat children" to be killed
	ld e,Enemy.var34
	ld a,(de)
	or a
	jp nz,ecom_decCounter2

	; Vire defeated
	ld h,d
	ld l,Enemy.substate
	inc (hl)
	inc l
	ld (hl),60 ; [counter1]
	ld a,SNDCTRL_STOPMUSIC
	jp playSound

@substate3:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld (hl),$10 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	jp objectSetVisiblec1

@substate4:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.angle
	ld (hl),$06
	ld l,Enemy.speed
	ld (hl),SPEED_300

	ld bc,TX_2f17
	call checkIsLinkedGame
	jr z,+
	inc c ; TX_2f18
+
	jp showText

@substate5:
	call checkIsLinkedGame
	jr z,@unlinked

@linked:
	ld e,Enemy.health
	xor a
	ld (de),a
	ret

@unlinked:
	; Spawn fairy if var38 is 0.
	ld e,Enemy.var38
	ld a,(de)
	or a
	jr nz,++
	inc a
	ld (de),a
	ld b,PARTID_ITEM_DROP
	call ecom_spawnProjectile
++
	call enemyAnimate

	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub <($0080)
	ldi (hl),a
	ld a,(hl)
	sbc >($0080)
	ld (hl),a

	call vire_checkOffScreen
	jp c,objectApplySpeed

	; Vire is gone; cleanup
	call markEnemyAsKilledInRoom
	call decNumEnemies
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	jp enemyDelete


vire_batForm:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw vire_batForm_state8
	.dw vire_batForm_state9
	.dw vire_batForm_stateA
	.dw vire_batForm_stateB
	.dw vire_batForm_stateC
	.dw vire_batForm_stateD


vire_batForm_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.var30
	ld a,(hl)
	and $1f
	ld l,Enemy.angle
	ld (hl),a

	ld l,Enemy.counter1
	ld (hl),$10

	ld l,Enemy.health
	ld (hl),$01

	ld a,$02
	call enemySetAnimation
	jp objectSetVisiblec1


; Moving upward after charging (or after spawning)
vire_batForm_state9:
	call ecom_decCounter1
	jr z,vire_batForm_gotoStateA

	; Move up while zh > -$10
	ld l,Enemy.zh
	ldd a,(hl)
	cp $f0
	jr c,++
	ld a,(hl)
	sub <($00c0)
	ldi (hl),a
	ld a,(hl)
	sbc >($00c0)
	ld (hl),a
++
	call objectApplySpeed
	jr vire_batForm_animate

vire_batForm_gotoStateA:
	ld l,e
	ld (hl),$0a ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.collisionType
	set 7,(hl)

	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	ld (de),a

	; [mainForm.counter2] = 180
	ld a,Object.counter2
	call objectGetRelatedObject1Var
	ld (hl),180
	jr vire_batForm_animate


vire_batForm_stateA:
	call vire_batForm_updateZPos

	ld a,Object.counter2
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,++

.ifdef ROM_AGES
	call ecom_incState
.else
	ld h,d
	ld l,Enemy.state
	inc (hl)
.endif

	ld l,Enemy.counter1
	ld (hl),$08
	ret
++
	call vire_batForm_moveAwayFromLinkIfTooClose

	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,Enemy.var30
	ld a,(de)
	add b
	and $1f
	ld e,Enemy.angle
	ld (de),a

	ld a,$02
	call ecom_getSideviewAdjacentWallsBitset
	call z,objectApplySpeed

vire_batForm_animate:
	jp enemyAnimate


; About to charge toward Link in [counter1] frames
vire_batForm_stateB:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld l,Enemy.var35
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ret


; Charging toward target position in var35/var36
vire_batForm_stateC:
	ld h,d
	ld l,Enemy.var35
	call ecom_readPositionVars
	sub c
	add $08
	cp $11
	jr nc,@notReachedPosition

	ldh a,(<hFF8F)
	sub b
	add $08
	cp $11
	jr nc,@notReachedPosition

	ld l,Enemy.zh
	ld a,(hl)
	cp $fa
	jr c,@notReachedPosition

	; Reached target position

	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.counter1
	ld (hl),20
	jr vire_batForm_animate

@notReachedPosition:
	ld l,Enemy.zh
	ld a,(hl)
	cp $fe
	jr nc,+
	inc (hl)
+
	call ecom_moveTowardPosition
	jr vire_batForm_animate


; Moving back up after charging
vire_batForm_stateD:
	call ecom_decCounter1
	jp z,vire_batForm_gotoStateA

	ld l,Enemy.zh
	ldd a,(hl)
	cp $f0
	jr c,++

	ld a,(hl)
	sub <($00c0)
	ldi (hl),a
	ld a,(hl)
	sbc >($00c0)
	ld (hl),a
++
	ld a,$02
	call ecom_getSideviewAdjacentWallsBitset
	call z,objectApplySpeed
	jr vire_batForm_animate


;;
; Sets Vire's position to just outside the camera (along with corresponding angle), and
; increments substate.
;
; @param[out]	hl	Enemy.substate
vire_spawnOutsideCamera:
	call getRandomNumber_noPreserveVars
	and $07
	ld b,a
	add a
	add b
	ld hl,@spawnPositions
	rst_addAToHl

	ld e,Enemy.yh
	ldh a,(<hCameraY)
	add (hl)
	ld (de),a
	inc hl
	ld e,Enemy.xh
	ldh a,(<hCameraX)
	add (hl)
	ld (de),a

	inc hl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a

	ld h,d
	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.substate
	inc (hl)
	jp objectSetVisiblec1

; Data format:
;   b0: y (relative to hCameraY)
;   b1: x (relative to hCameraX)
;   b2: angle
@spawnPositions:
	.db $f8 $10 $10
	.db $f8 $90 $10
	.db $10 $f8 $08
	.db $10 $a8 $18
	.db $70 $f8 $08
	.db $70 $a8 $18
	.db $88 $10 $00
	.db $88 $90 $00

;;
; Vire has left the screen; set state to 9, where he'll wait for 90 frames before
; attacking again.
vire_mainForm_leftScreen:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09
	inc l
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),90 ; [counter1]

	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible

;;
; @param[out]	cflag	c if left screen
vire_checkOffScreen:
	ld e,Enemy.yh
	ld a,(de)
	cp (LARGE_ROOM_HEIGHT<<4)+8
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	cp (LARGE_ROOM_WIDTH<<4)
	ret


;;
vire_mainForm_circleAroundScreen:
	ldh a,(<hCameraY)
	add (SCREEN_HEIGHT<<3)+4
	ld b,a
	ldh a,(<hCameraX)
	add SCREEN_WIDTH<<3
	ld c,a
	push bc
	call objectGetRelativeAngle
	pop bc

	ld h,a
	ld e,Enemy.yh
	ld a,(de)
	sub b
	jr nc,+
	cpl
	inc a
+
	ld b,a
	cp $3e
	ld a,h
	jr nc,@setAngleAndSpeed

	ld e,Enemy.xh
	ld a,(de)
	sub c
	jr nc,+
	cpl
	inc a
+
	ld c,a
	cp $3e
	ld a,h
	jr nc,@setAngleAndSpeed

	ld a,b
	add c
	sub $42
	cp $08
	jr c,@offsetAngle

	rlca
	ld a,h
	jr nc,@setAngleAndSpeed

	xor $10

@setAngleAndSpeed:
	push hl
	ld e,Enemy.angle
	ld (de),a
	ld e,Enemy.speed
	ld a,SPEED_40
	ld (de),a
	call objectApplySpeed
	pop hl

@offsetAngle:
	ld e,Enemy.var30
	ld a,(de)
	add h
	and $1f
	ld e,Enemy.angle
	ld (de),a

	ld e,Enemy.speed
	ld a,SPEED_e0
	ld (de),a


;;
vire_mainForm_applySpeedAndAnimate:
	call objectApplySpeed
	jp enemyAnimate

;;
; @param[out]	cflag	c if Link is too close (Vire will flee)
vire_mainForm_checkLinkTooClose:
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add 30
	cp 61
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add 30
	cp 61
	ret


;;
vire_mainForm_fireProjectile:
	call getRandomNumber_noPreserveVars
	and $01
	inc a
	ld b,a

;;
; @param	b	Subid
vire_mainForm_fireProjectileWithSubid:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_VIRE_PROJECTILE
	inc l
	ld (hl),b ; [subid]

	ld l,Part.relatedObj1+1
	ld (hl),d
	dec l
	ld (hl),Enemy.start

	call objectCopyPosition
	ld a,SND_SPLASH
	call playSound

	ld e,Enemy.direction
	ld a,$01
	ld (de),a
	jp enemySetAnimation

;;
vire_batForm_moveAwayFromLinkIfTooClose:
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add 12
	cp 25
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add 12
	cp 25
	ret nc

	call objectGetAngleTowardEnemyTarget
	xor $10
	ld c,a
	ld b,SPEED_200
	jp ecom_applyGivenVelocity


;;
vire_batForm_updateZPos:
	call ecom_decCounter1
	ld a,(hl)
	and $1c
	rrca
	rrca
	ld hl,@zVals
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(hl)
	ld (de),a
	ret

@zVals:
	.db $f0 $f1 $f0 $ef $ee $ed $ee $ef


; ==============================================================================
; ENEMYID_POE_SISTER_2
; ==============================================================================
enemyCode76:
	jr z,@normalStatus
	sub $03
	ret c
	jr nz,+
	ld bc,$0a07
	jp poeSister5f7e
+
	call poeSister5fc2
	ret z
@normalStatus:
	call poeSister604b
	call poeSister602e
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @state5
	.dw @stateStub
	.dw @stateStub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF
	.dw @state10
	.dw @state11

@state0:
	ld a,$76
	ld ($cc1c),a
	call getRandomNumber_noPreserveVars
	ld e,$b8
	ld (de),a
	ld h,d
	ld l,$88
	ld (hl),$ff
	ld l,$90
	ld (hl),$46
	ld l,$82
	ld a,(hl)
	or a
	jr z,@func5c6d
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_DARK_ROOM_HANDLER
	ld l,$c6
	ld a,$04
	ldi (hl),a
	ld (hl),a
	ld ($cca9),a
	ld hl,$d081
-
	ld a,(hl)
	cp $7e
	jr z,+
	inc h
	jr -
+
	ld e,$96
	ld l,e
	ld a,$80
	ld (de),a
	ldi (hl),a
	inc e
	ld a,h
	ld (de),a
	ld (hl),d
	ld h,d
	jp enemyCode7e@func_5dd5

; Also used by ENEMYID_POE_SISTER_1
@func5c6d:
	ld l,$84
	ld (hl),$0b
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_POE_SISTER_FIRSTFIGHT
	ld l,$86
	ld (hl),$3c
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	call objectSetVisible82
	ld a,$02
	jp enemySetAnimation
	
@state5:
	call ecom_galeSeedEffect
	jp nc,enemyDelete
	ld e,$87
	ld a,(de)
	dec a
	ret nz
	ld bc,TX_0a08
	jp showText
	
@stateStub:
	ret
	
@state8:
	ld a,(wcc93)
	or a
	ret nz
	inc a
	ld ($cca4),a
	ld h,d
	ld l,e
	inc (hl)
	ld l,$86
	ld (hl),$2d
	ret
	
@state9:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$1f
	ld l,e
	inc (hl)
	jp objectSetVisible82
	
@stateA:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	dec a
	jr nz,@animate
	xor a
	ld ($cca4),a
	ld bc,TX_0a05
	jp showText
+
	ld (hl),$2d
	ld l,e
	inc (hl)
	ld a,$2d
	ld (wActiveMusic),a
	jp playSound
	
@stateB:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$10
	ld l,e
	inc (hl)
	ld l,$b7
	bit 1,(hl)
	jr z,+
	res 1,(hl)
	ld l,$86
	ld a,(hl)
	add $2c
	ld (hl),a
+
	jp objectSetInvisible
	
@stateC:
	call ecom_decCounter1
	ret nz
	ld (hl),$18
	ld l,e
	inc (hl)
	jp func_5e45
	
@stateD:
@stateF:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$30
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	jp objectSetVisible82
	
@stateE:
	call ecom_decCounter1
	jp z,poeSister5f3b
	ld a,(hl)
	and $07
	jr nz,+
	ld l,$89
	ld e,$b1
	ld a,(de)
	add (hl)
	and $1f
	ld (hl),a
	call ecom_updateAnimationFromAngle
+
	call func_5f49
	call objectApplySpeed
@animate:
	jp enemyAnimate
	
@state10:
	ld h,d
	ld l,$b4
	call ecom_readPositionVars
	sub c
	add $0c
	cp $19
	jr nc,+
	ldh a,(<hFF8F)
	sub b
	add $07
	cp $0f
	jr nc,+
	ld l,e
	inc (hl)
	ld l,$89
	ld a,(hl)
	and $10
	swap a
	add $04
	ld l,$88
	ld (hl),a
	jp enemySetAnimation
+
	call ecom_moveTowardPosition
	jr @animate
	
@state11:
	call enemyAnimate
	ld e,$a1
	ld a,(de)
	inc a
	jp z,poeSister5f3b
	sub $02
	ret nz
	call func_5f54
	ret nz
	ld e,$a1
	ld a,$02
	ld (de),a
	ret

; ==============================================================================
; ENEMYID_POE_SISTER_1
; ==============================================================================
enemyCode7e:
	jr z,@normalStatus
	sub $03
	ret c
	jr nz,+
	ld bc,$0a06
	jp poeSister5f7e
+
	call poeSister5fc2
	ret z
@normalStatus:
	call @func_5d86
	jp func_5fec
@func_5d86:
	call poeSister604b
	call poeSister602e
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw enemyCode76@stateStub
	.dw enemyCode76@stateStub
	.dw enemyCode76@stateStub
	.dw enemyCode76@stateStub
	.dw enemyCode76@state5
	.dw enemyCode76@stateStub
	.dw enemyCode76@stateStub
	.dw enemyCode76@state8
	.dw enemyCode76@state9
	.dw @stateA
	.dw enemyCode76@stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF
	.dw enemyCode76@state10
	.dw enemyCode76@state11
	
@state0:
	ld a,$7e
	ld ($cc1c),a
	ld b,PARTID_3b
	call ecom_spawnProjectile
	ret nz
	call getRandomNumber_noPreserveVars
	ld e,$b8
	ld (de),a
	ld h,d
	ld l,$88
	ld (hl),$ff
	ld l,$90
	ld (hl),$3c
	ld e,$82
	ld a,(de)
	or a
	jp z,enemyCode76@func5c6d

@func_5dd5:
	ld l,$84
	ld (hl),$08
	ld l,$a9
	ld a,(hl)
	add $06
	ld (hl),a
	ld l,$b6
	ld (hl),a
	ld a,$76
	ld b,$00
	call enemyBoss_initializeRoom
	ld a,$03
	jp enemySetAnimation
	
@stateA:
	call ecom_decCounter1
	jr nz,@animate
	ld (hl),$2d
	ld l,e
	inc (hl)
	ret
	
@stateC:
	call ecom_decCounter1
	ret nz
	ld (hl),$30
	ld l,e
	inc (hl)
	call func_5e7b
	jp objectSetVisible82
	
@stateD:
@stateF:
	call ecom_decCounter1
	jr nz,+
	ld (hl),$30
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$b9
	ld e,$8b
	ldi a,(hl)
	ld (de),a
	ld e,$8d
	ld a,(hl)
	ld (de),a
	ret
+
	ld a,(hl)
	and $3c
	rrca
	rrca
	bit 1,(hl)
	jr z,+
	cpl
	inc a
+
	ld l,$88
	bit 0,(hl)
	ld l,$b9
	ld e,$8b
	jr nz,+
	inc l
	ld e,$8d
+
	add (hl)
	ld (de),a
	ret
	
@stateE:
	call ecom_decCounter1
	jp z,poeSister5f3b
	call objectApplySpeed
@animate:
	jp enemyAnimate

func_5e45:
	ld bc,table_5e6b
	call func_5ea3
	jr z,++
	ldh a,(<hEnemyTargetY)
	cp $58
	ld a,$fe
	ld c,$00
	jr c,+
	ld a,$02
	inc c
+
	ld e,$b1
	ld (de),a
	ld a,b
	add c
	ld hl,table_5e73
	rst_addAToHl
	ld b,(hl)
++
	ld e,$89
	ld a,b
	ld (de),a
	jp ecom_updateAnimationFromAngle

table_5e6b:
	.db $e0 $20 $20 $20
	.db $20 $e0 $e0 $e0

table_5e73:
	.db $18 $10 $00 $18
	.db $08 $00 $10 $08

func_5e7b:
	ld bc,table_5e9b
	call func_5ea3
	jr z,+
	ld a,b
	add a
	add a
	xor $10
	ld b,a
+
	ld e,$89
	ld a,b
	ld (de),a
	ld h,d
	ld l,$b9
	ld e,$8b
	ld a,(de)
	ldi (hl),a
	ld e,$8d
	ld a,(de)
	ld (hl),a
	jp ecom_updateAnimationFromAngle

table_5e9b:
	.db $d8 $00 $00 $28
	.db $28 $00 $00 $d8

func_5ea3:
	push bc
	ld e,$82
	ld a,(de)
	or a
	jr z,func_5f0b
	ld e,$b2
	ld a,(de)
	inc a
	and $0f
	ld (de),a
	ld hl,flags_5f35
	call checkFlag
	jr z,func_5f0b
	call getRandomNumber_noPreserveVars
	and $03
	ld b,a
	ld c,$05
-
	dec c
	jr z,func_5f0b
	ld a,b
	inc a
	and $03
	ld b,a
	ld hl,table_5f37
	rst_addAToHl
	ld l,(hl)
	ld h,$cf
	ld a,(hl)
	cp $09
	jr nz,-

	ld (hl),$08
	ld c,l
	ld e,$b3
	ld a,l
	ld (de),a
	and $06
	pop hl
	rst_addAToHl
	ld e,$b4
	ld a,c
	and $f0
	add $08
	ld (de),a
	ld e,$8b
	add (hl)
	ld (de),a
	ld e,$b5
	inc hl
	ld a,c
	and $0f
	swap a
	add $08
	ld (de),a
	ld e,$8d
	add (hl)
	ld (de),a
	ld h,d
	ld l,$84
	ld (hl),$0f
	ld l,$b4
	call ecom_readPositionVars
	call objectGetRelativeAngleWithTempVars
	ld b,a
	xor a
	ret

func_5f0b:
	call getRandomNumber_noPreserveVars
	and $06
	ld b,a
	pop hl
	push hl
	rst_addAToHl
	ldh a,(<hEnemyTargetY)
	add (hl)
	cp $b0
	jr nc,func_5f0b
	ld e,$8b
	ld (de),a
	inc hl
	ldh a,(<hEnemyTargetX)
	ld c,a
	add (hl)
	cp $f0
	jr nc,func_5f0b
	ld e,$8d
	ld (de),a
	sub c
	jr nc,+
	cpl
	inc a
+
	rlca
	jr c,func_5f0b
	pop hl
	or d
	ret

flags_5f35:
	.db $6a $b5

table_5f37:
	.db $3a $7a $74 $34

poeSister5f3b:
	ld h,d
	ld l,$84
	ld (hl),$0b
	ld l,$a4
	res 7,(hl)
	ld l,$86
	ld (hl),$18
	ret

func_5f49:
	ld e,$86
	ld a,(de)
	and $07
	ret nz
	ld b,PARTID_POE_SISTER_FLAME
	jp ecom_spawnProjectile

func_5f54:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTABLE_TORCH
	ld e,$b3
	ld a,(de)
	and $f0
	add $08
	ld l,$cb
	ldi (hl),a
	ld a,(de)
	and $0f
	swap a
	add $08
	inc l
	ld (hl),a
	ld hl,$cca9
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld a,(de)
	ld c,a
	ld a,$08
	call setTile
	xor a
	ret

poeSister5f7e:
	ld e,$82
	ld a,(de)
	or a
	jr z,poeSister5f82
	ld e,$a4
	ld a,(de)
	or a
	jr z,+
	ld a,($cba0)
	or a
	ret nz
	call showText
	call objectSetInvisible
+
	ld a,$00
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,enemyBoss_dead
	jp enemyDie_withoutItemDrop

poeSister5f82:
	ld e,$a4
	ld a,(de)
	or a
	jr z,++
	xor a
	ld (de),a
	ld bc,TX_0a04
	ld e,$81
	ld a,(de)
	cp $76
	jr z,+
	ld c,<TX_0a02
+
	jp showText
++
	call objectCreatePuff
	call decNumEnemies
	jp enemyDelete

poeSister5fc2:
	ld h,d
	ld l,$a9
	ld a,(hl)
	ld l,$b6
	cp (hl)
	ret z
	ld (hl),a
	ld l,$b7
	set 1,(hl)
	ld e,$84
	ld a,(de)
	cp $0f
	ccf
	ret nc
	ld e,$a1
	ld a,(de)
	cp $02
	jr z,+
	ld l,$b3
	ld l,(hl)
	ld h,$cf
	ld (hl),$09
+
	call poeSister5f3b
	ld e,$a9
	ld a,(de)
	or a
	ret

func_5fec:
	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,$88
	ld a,(de)
	cp $04
	jr c,+
	sub $04
	add a
	inc a
+
	add a
	add a
	ld hl,table_601e
	rst_addAToHl
	ld a,b
	call checkFlag
	ld h,d
	ld l,$b7
	ld e,$a4
	jr z,+
	ld a,(de)
	and $80
	or $7e
	ld (de),a
	res 2,(hl)
	ret
+
	ld a,(de)
	and $80
	or $76
	ld (de),a
	set 2,(hl)
	ret

table_601e:
	.db $1f $00 $00 $00
	.db $00 $1f $00 $00
	.db $00 $00 $1f $00
	.db $00 $00 $f0 $01
	
poeSister602e:
	ld h,d
	ld l,$84
	ld a,(hl)
	cp $08
	ret c
	ld l,$b8
	dec (hl)
	ld a,(hl)
	and $18
	swap a
	rlca
	ld hl,table_6047
	rst_addAToHl
	ld e,$8f
	ld a,(hl)
	ld (de),a
	ret

table_6047:
	.db $ff $fe $fd $fe
	
poeSister604b:
	ld e,$82
	ld a,(de)
	or a
	ret z
	ld h,d
	ld l,$b7
	ld a,($cca9)
	or a
	jr z,+
	res 0,(hl)
	ret
+
	bit 0,(hl)
	jr nz,+
	set 0,(hl)
	ld l,$b0
	ld (hl),$18
+
	ld l,$b0
	dec (hl)
	ret nz
	ld a,($cc34)
	or a
	ret nz
	ld a,(wWarpTransition2)
	or a
	ret nz
	ld a,$8d
	call playSound
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_SEASONS_55b, $00, $57, $03

; ==============================================================================
; ENEMYID_FRYPOLAR
; ==============================================================================
enemyCode77:
	jr z,@normalStatus
	sub $03
	ret c
	jp z,enemyBoss_dead
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ld e,$b2
	ld a,(de)
	or a
	jr nz,@normalStatus
	ld e,$aa
	ld a,(de)
	cp $9a
	jr z,+
	cp $9b
	jr nz,@normalStatus
	ld e,$82
	ld a,(de)
	or a
	jr z,@normalStatus
	ld a,$63
	call playSound
	ld h,d
	ld l,$ab
	ld (hl),$3c
	ld l,$a9
	dec (hl)
	jr nz,+
	ld l,$a4
	res 7,(hl)
+
	ld e,$b2
	ld a,$1e
	ld (de),a
	ld a,$83
	call playSound
@normalStatus:
	call func_6257
	call func_6273
	call ecom_getSubidAndCpStateTo08
	cp $0a
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
	.dw @state8
	.dw @state9
+
	call func_62b1
	ld a,b
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@state0:
	ld bc,$010c
	call enemyBoss_spawnShadow
	ret nz
	call ecom_setSpeedAndState8
	ld l,$bf
	set 5,(hl)
	ld b,$00
	ld a,$77
	jp enemyBoss_initializeRoom

@stateStub:
	ret

@state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	ld a,(wcc93)
	or a
	ret nz
	inc a
	ld (de),a
	ld ($cca4),a
	ret

@@substate1:
	call ecom_decCounter2
	ret nz
	ld b,$02
	call checkBPartSlotsAvailable
	ret nz
	ld e,$86
	ld a,(de)
	ld hl,@@table_6169
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreePartSlot
	ld (hl),PARTID_3d
	inc l
	ld (hl),$03
	inc l
	inc (hl)
	ld l,$cb
	ld (hl),b
	ld l,$cd
	ld (hl),c
	call getFreePartSlot
	ld (hl),PARTID_3e
	ld l,$c3
	inc (hl)
	ld l,$cb
	ld a,$58
	sub b
	add $58
	ldi (hl),a
	inc l
	ld a,$78
	sub c
	add $78
	ld (hl),a
	ld l,$d6
	ld a,$80
	ldi (hl),a
	ld (hl),d
	ld h,d
	ld l,$87
	ld (hl),$0f
	dec l
	inc (hl)
	ldd a,(hl)
	cp $10
	ret c
	inc (hl)
	ret

@@table_6169:
	.db $20 $78
	.db $28 $50
	.db $3c $30
	.db $58 $20
	.db $70 $34
	.db $7c $58
	.db $80 $78
	.db $70 $a0
	.db $58 $b8
	.db $40 $a0
	.db $38 $78
	.db $40 $60
	.db $58 $48
	.db $64 $5c
	.db $68 $70
	.db $5c $84

@@substate2:
	call ecom_decCounter1
	ret nz
	ldbc INTERACID_PUFF $02
	call objectCreateInteraction
	ret nz
	ld a,h
	ld h,d
	ld l,$99
	ldd (hl),a
	ld (hl),$40
	ld l,$85
	inc (hl)
	ret

@@substate3:
	ld a,$21
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$86
	ld (hl),$3c
	ld l,$8b
	ld (hl),$56
	ld l,$8f
	ld (hl),$fe
	call objectSetVisible83
	xor a
	ld ($cca4),a
	ld a,$2d
	ld (wActiveMusic),a
	jp playSound

@state9:
	call ecom_decCounter1
	jp nz,enemyAnimate
	ld l,e
	inc (hl)
	ret

@subid0:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD

@@stateA:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$55
	ld l,$b4
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	jr @@animate

@@stateB:
	ld a,(wFrameCounter)
	and $0f
	ld a,$ae
	call z,playSound
	call func_62cc
	call nc,ecom_moveTowardPosition
@@animate:
	jp enemyAnimate

@@stateC:
	call ecom_decCounter1
	jr z,+
	call func_62f3
	jr @@animate
+
	call func_62a8
	call func_6304
	jr @@animate

@@stateD:
	call ecom_decCounter1
	jr nz,@@animate
	ld l,e
	ld (hl),$0a
	jr @@animate

@subid1:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw @@stateA
	.dw @subid0@stateB
	.dw @@stateC
	.dw @@stateD

@@stateA:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$6e
	jp func_6326
	
@@stateC:
	call ecom_decCounter1
	jr z,+
	call func_62f3
	jr @@animate
+
	call func_62a8
	ld b,PARTID_3e
	call ecom_spawnProjectile
@@animate:
	jp enemyAnimate
	
@@stateD:
	call ecom_decCounter1
	jr nz,@@animate
	ld l,e
	ld (hl),$0b
	call func_6326
	jr @@animate

func_6257:
	ld e,$b0
	ld a,(de)
	cp $04
	ret c
	call ecom_decCounter1
	jr z,+
	pop hl
	jp enemyAnimate
+
	ld l,$b0
	ld (hl),$00
	ld l,$b2
	ld (hl),$5a
	ld a,$83
	jp playSound

func_6273:
	ld h,d
	ld l,$b2
	ld a,(hl)
	or a
	ret z
	ld e,$ab
	ld a,(de)
	or a

seasonsFunc_0e_627d:
	jr z,+
	pop bc
	ret
+
	dec (hl)
	jr z,++
	pop bc
	ld a,(hl)
	and $03
	jr nz,+
	ld l,$9b
	ld a,(hl)
	and $01
	inc a
	ldi (hl),a
	ld (hl),a
+
	jp enemyAnimate
++
	ld l,$82
	ld a,(hl)
	inc a
	and $01
	ld (hl),a
	ld b,a
	ld a,$02
	sub b
	ld l,$9b
	ldi (hl),a
	ld (hl),a
	ld l,$84
	ld (hl),$0a
	ld l,$a4
	set 7,(hl)
	ld l,$b0
	ld (hl),$00
	ret

func_62b1:
	ld h,d
	ld l,$b1
	dec (hl)
	ld a,(hl)
	and $0f
	ret nz
	ld a,(hl)
	and $30
	swap a
	ld hl,table_62c8
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,$8f
	ld (hl),a
	ret

table_62c8:
	.db $ff
	.db $fe
	.db $fd
	.db $fe

func_62cc:
	.db $62
	ld l,$b4
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	ret nc
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$28
	ret

func_62a8:
	ld (hl),$78
	inc l
	ld (hl),$96
	ld l,e
	inc (hl)
	ld l,$b0
	inc (hl)
	ret

func_62f3:
	ld a,(hl)
	and $03
	ld hl,table_6300
	rst_addAToHl
	ld e,$8d
	ld a,(de)
	add (hl)
	ld (de),a
	ret

table_6300:
	.db $ff
	.db $01
	.db $01
	.db $ff

func_6304:
	call objectGetAngleTowardEnemyTarget
	ld b,a
	call getRandomNumber
	cp $55
	ld a,b
	jr c,func_631a
	sub $02
	and $1f
	call func_631a
	ld a,b
	add $04
func_631a:
	push af
	ld b,PARTID_3d
	call ecom_spawnProjectile
	pop bc
	ret nz
	ld l,$c9
	ld (hl),b
	ret
	
func_6326:
	call getRandomNumber_noPreserveVars
	and $0e
	ld h,d
	ld l,$b3
	cp (hl)
	jr z,func_6326
	ld (hl),a
	ld hl,table_633e
	rst_addAToHl
	ld e,$b4
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

table_633e:
	.db $20 $78 $40 $38
	.db $78 $58 $58 $78
	.db $78 $98 $40 $b8
	.db $68 $38 $68 $b8


; ==============================================================================
; ENEMYID_AQUAMENTUS
;
; Variables (subid 1, main body):
;   var31: Affects collision box?
;   var32/var33: Target position?
;   var34: Reference to subid 2 (sprites only)
;   var35: Reference to subid 3 (the horn)
;   var36: Counter for playing footstep sound
;   var37: ?
;
; Variables (subid 2, sprites only):
;   relatedObj1: Reference to subid 1 (main body)
;   relatedObj2: Reference to subid 3 (horn)
;   var30: Current animation
;
; Variables (subid 3, horn):
;   relatedObj2: Reference to subid 2 (sprites)
;   var30: Current animation
; ==============================================================================
enemyCode78:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	dec a
	jr z,@justHit
	dec a
	jr z,@normalStatus

	; Dead
	ld e,Enemy.subid
	ld a,(de)
	sub $02
	jp z,enemyBoss_dead
	dec a
	jp nz,enemyDelete
	call ecom_killRelatedObj1
	call ecom_killRelatedObj2
	jp enemyDie_uncounted_withoutItemDrop

@justHit:
	ld e,Enemy.subid
	ld a,(de)
	sub $03
	jr nz,@normalStatus

	ld a,Object.invincibilityCounter
	call objectGetRelatedObject2Var
	ld e,l
	ld a,(de)
	ld (hl),a

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@state8OrHigher
	rst_jumpTable
	.dw aquamentus_state_uninitialized
	.dw aquamentus_state_spawner
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub
	.dw aquamentus_state_stub

@state8OrHigher
	dec b
	ld a,b
	rst_jumpTable
	.dw aquamentus_subid1
	.dw aquamentus_subid2
	.dw aquamentus_subid3


aquamentus_state_uninitialized:
	ld c,$20
	call ecom_setZAboveScreen

	; Check subid
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8

	; Subid is 0; go to state 1
	ld l,e
	inc (hl) ; [state] = 1
	ld a,ENEMYID_AQUAMENTUS
	ld b,PALH_SPR_AQUAMENTUS
	jp enemyBoss_initializeRoom


aquamentus_state_spawner:
	ld a,(wcc93)
	or a
	ret nz

	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	ld b,ENEMYID_AQUAMENTUS
	call ecom_spawnUncountedEnemyWithSubid01
	ld c,h

	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl) ; [child.subid] = 2
	call aquamentus_initializeChildObject

	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$03 ; [child.subid] = 3
	call aquamentus_initializeChildObject

	ld e,h
	pop hl
	ld a,h
	ld h,c
	ld l,Enemy.var34
	ldi (hl),a ; [body.var34] = subid2
	ld (hl),e  ; [body.var35] = horn
	call objectCopyPosition
	jp enemyDelete


aquamentus_state_stub:
	ret


; Body hitbox + general logic
aquamentus_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw aquamentus_body_state8
	.dw aquamentus_body_state9
	.dw aquamentus_body_stateA
	.dw aquamentus_body_stateB
	.dw aquamentus_body_stateC
	.dw aquamentus_body_stateD
	.dw aquamentus_body_stateE
	.dw aquamentus_body_stateF

; Initialization
aquamentus_body_state8:
	ld bc,$020c
	call enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_AQUAMENTUS_BODY

	ld l,Enemy.var32
	ld a,$50
	ldi (hl),a  ; [var32]
	ld (hl),$c0 ; [var33]

	ld l,Enemy.var31
	ld (hl),$01
	ld l,Enemy.counter1
	ld (hl),90
	ret


; Lowering down
aquamentus_body_state9:
	ld e,Enemy.zh
	ld a,(de)
	cp $f4
	jr nc,@doneLowering

	; Lower aquamentus based on his current height
	and $f0
	swap a
	ld hl,aquamentus_fallingSpeeds
	rst_addAToHl
	dec e
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	ld a,(de)
	adc $00
	ld (de),a
	jp aquamentus_playHoverSoundEvery32Frames

@doneLowering:
	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0a

	ld l,Enemy.var31
	ld (hl),$02
	ret


; Hovering in place before landing
aquamentus_body_stateA:
	call ecom_decCounter1
	jp nz,aquamentus_playHoverSoundEvery32Frames

	; Time to land on the ground

	ld (hl),60
	ld l,Enemy.zh
	ld (hl),$00

	ld l,e
	inc (hl) ; [state] = $0b

	ld l,Enemy.var31
	ld (hl),$04

	; Check whether to play boss music?
	ld l,Enemy.var37
	bit 0,(hl)
	jr nz,++
	inc (hl)
	ld a,MUS_BOSS
	ld (wActiveMusic),a
	call playSound
++
	ld a,$20

;;
aquamentus_body_pound:
	call setScreenShakeCounter
	ld a,SND_STRONG_POUND
	jp playSound


; Standing in place
aquamentus_body_stateB:
	call ecom_decCounter1
	ret nz
	ld (hl),150
	inc l
	ld (hl),$04 ; [counter2]

	ld l,Enemy.var36
	ld (hl),$18
	jp aquamentus_decideNextAttack


; Moving forward
aquamentus_body_stateC:
	call aquamentus_body_playFootstepSoundEvery24Frames
	call aquamentus_body_6694
	call ecom_decCounter1
	jr nz,@applySpeed

	inc l
	ldd a,(hl) ; [counter2]
	ld bc,aquamentus_projectileFireDelayCounters
	call addAToBc
	ld a,(bc)
	ldi (hl),a ; [counter1]
	dec (hl)   ; [counter2]--
	jr nz,@fireProjectiles

	ld l,Enemy.state
	inc (hl) ; [state] = $0d

	ld l,Enemy.var31
	ld (hl),$08
	ld l,Enemy.speed
	ld (hl),SPEED_80
	ret

@fireProjectiles:
	call aquamentus_body_chooseRandomLeftwardAngle
	call aquamentus_fireProjectiles
@applySpeed:
	jp objectApplySpeed


; Walking back to original position
aquamentus_body_stateD:
	call aquamentus_body_playFootstepSoundEvery18Frames
	call aquamentus_body_6694
	call aquamentus_body_checkReachedTargetPosition
	jr c,@gotoStateB

	call ecom_decCounter1
	call z,aquamentus_fireProjectiles
	jp ecom_moveTowardPosition

@gotoStateB:
	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.var31
	ld (hl),$04
	ret


; Charge attack
aquamentus_body_stateE:
	call ecom_decCounter2
	ret nz

	ld e,Enemy.xh
	ld a,(de)
	cp $1c
	jr c,@onLeftSide

	; Begin charge

	ld a,(wFrameCounter)
	and $1f
	ld a,SND_SWORDSPIN
	call z,playSound
	ld a,(wFrameCounter)
	and $07
	jr nz,@applySpeed

	call getFreeInteractionSlot
	jr nz,@applySpeed

	; Create dust
	ld (hl),INTERACID_FALLDOWNHOLE
	inc l
	inc (hl) ; [subid] = 1
	ld bc,$1010
	call objectCopyPositionWithOffset

@applySpeed:
	jp objectApplySpeed

@onLeftSide:
	call ecom_decCounter1
	dec (hl)
	jr z,@gotoStateF

	; Play "pound" sound effect when he reaches the wall
	ld a,(hl)
	cp 148
	ret nz
	ld a,70
	jp aquamentus_body_pound

@gotoStateF:
	ld (hl),240 ; [counter1]
	inc l
	ld (hl),60 ; [counter2]

	ld l,Enemy.state
	inc (hl) ; [state] = $0f

	ld l,Enemy.zh
	ld (hl),$f8

	ld l,Enemy.var31
	ld (hl),$01

	ld l,Enemy.angle
	ld (hl),$08
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ret


aquamentus_body_stateF:
	call aquamentus_playHoverSoundEvery32Frames
	call ecom_decCounter2
	jr z,@moveBack

	; Rising up
	ld l,Enemy.zh
	ld a,(hl)
	cp $e8
	ret c
	ld b,$80
	jp aquamentus_body_subZ

@moveBack:
	call ecom_decCounter1
	jr z,@lowerDown

	; Moving back to original position (and maybe still rising up)
	ld a,(hl) ; [counter1]
	cp 210
	ld b,$c0
	call nc,aquamentus_body_subZ
	call aquamentus_body_checkReachedTargetPosition
	ret c
	jp ecom_moveTowardPosition

@lowerDown:
	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.counter1
	ld (hl),30
	ret


; All sprites except horn
aquamentus_subid2:
	ld a,(de) ; [state]
	sub $08
	jr z,@state8

@state9:
	ld a,Object.var31
	call objectGetRelatedObject1Var
	ld b,(hl)

	; Copy main body's position
	ld a,d
	ld d,h
	ld h,a
	call objectCopyPosition
	ld d,h

	ld a,b
	call getHighestSetBit
	jr nc,aquamentus_animate

	ld hl,aquamentus_animations
	rst_addAToHl
	ld e,Enemy.var30
	ld a,(de)
	cp (hl)
	jr z,aquamentus_animate

	ld a,(hl)
	ld (de),a
	jp enemySetAnimation

@state8:
	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionType
	res 7,(hl)

	; Copy parent's horn reference to relatedObj2
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var35
	ld e,Enemy.relatedObj2+1
	ld a,(hl)
	ld (de),a
	jp objectSetVisible81


; Horn & horn hitbox
aquamentus_subid3:
	ld a,(de)
	sub $08
	jr z,aquamentus_subid3_state8


aquamentus_subid3_state9:
	; Only draw the horn if the main sprite is also visible
	ld a,Object.visible
	call objectGetRelatedObject2Var
	ld e,l
	ld a,(hl)
	and $80
	ld b,a
	ld a,(de)
	and $7f
	or b
	ld (de),a

	call aquamentus_horn_updateAnimation

	; Get parent's position
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	; [horn.zh] = [body.zh] - 7
	ld l,Enemy.zh
	ld e,l
	ld a,(hl)
	sub $07
	ld (de),a

	; Y/X offsets for horn vary based on subid 2's animParameter
	ld l,Enemy.var34
	ld h,(hl)
	ld l,Enemy.animParameter
	ld a,(hl)
	cp $09
	jr c,+
	ld a,$05
+
	ld hl,aquamentus_hornXYOffsets
	rst_addDoubleIndex
	ld e,Enemy.yh
	ldi a,(hl)
	add b
	ld (de),a

	ld e,Enemy.xh
	ld a,(hl)
	add c
	ld (de),a

aquamentus_animate:
	jp enemyAnimate


aquamentus_subid3_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionRadiusY
	ld (hl),$06
	inc l
	ld (hl),$03

	; Copy parent's subid2 reference to relatedObj2
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var34
	ld e,Enemy.relatedObj2+1
	ld a,(hl)
	ld (de),a
	jp objectSetVisible81


;;
; @param	h	Child object
aquamentus_initializeChildObject:
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c
	inc l
	ld (hl),a
	jp objectCopyPosition

;;
; Chooses whether to charge (state $0e) or move forward (state $0c)
aquamentus_decideNextAttack:
	ld e,Enemy.xh
	ld a,(de)
	ld b,a
	ldh a,(<hEnemyTargetX)
	cp b
	ld a,$0c
	jr nc,@setState

	call getRandomNumber_noPreserveVars
	and $07
	ld c,a
	ldh a,(<hEnemyTargetX)
	rlca
	rlca
	and $03
	ld hl,aquamentus_chargeProbabilities
	rst_addAToHl
	ld a,c
	call checkFlag
	ld a,$0c
	jr z,@setState
	ld a,$0e

@setState:
	ld e,Enemy.state
	ld (de),a
	cp $0c
	jr z,@initializeMovement

	; Initialize charge attack
	call aquamentus_body_calculateAngleForCharge
	ld e,Enemy.counter2
	ld a,30
	ld (de),a

	ld a,$20
	ld e,SPEED_1c0

@setVar31AndSpeed:
	ld h,d
	ld l,Enemy.var31
	ld (hl),a
	ld l,Enemy.speed
	ld (hl),e

	ld e,Enemy.var31
	ld a,(de)
	call getHighestSetBit
	ret nc

	ld hl,aquamentus_collisionBoxSizes
	rst_addDoubleIndex
	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

@initializeMovement:
	call aquamentus_body_chooseRandomLeftwardAngle
	ld a,$04
	ld e,SPEED_40
	jr @setVar31AndSpeed


;;
aquamentus_body_chooseRandomLeftwardAngle:
	call getRandomNumber_noPreserveVars
	and $07
	cp $07
	jr nz,+
	ld a,$03
+
	add $15
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; Sets angle to move left, slightly up or down, depending on Link's position
aquamentus_body_calculateAngleForCharge:
	ld b,$02
	ldh a,(<hEnemyTargetY)
	cp $48
	jr c,@setAngle
	dec b
	cp $68
	jr c,@setAngle
	dec b

@setAngle:
	ld a,$17
	add b
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; @param[out]	cflag	c if within 2 pixels of target position
aquamentus_body_checkReachedTargetPosition:
	ld h,d
	ld l,Enemy.var32
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	ret

;;
; @param	b	Amount to subtract z value by (subpixels)
aquamentus_body_subZ:
	ld e,Enemy.z
	ld a,(de)
	sub b
	ld (de),a
	inc e
	ld a,(de)
	sbc $00
	ld (de),a
	ret

;;
aquamentus_fireProjectiles:
	ld e,Enemy.var31
	ld a,$10
	ld (de),a
	ld a,SND_DODONGO_OPEN_MOUTH
	call playSound
	ld b,PARTID_AQUAMENTUS_PROJECTILE
	jp ecom_spawnProjectile

;;
aquamentus_body_6694:
	ld e,Enemy.var34
	ld a,(de)
	ld h,a
	ld l,Enemy.animParameter
	ld a,(hl)
	inc a
	ret nz

	ld e,Enemy.state
	ld a,(de)
	cp $0c
	ld a,$04
	jr z,+
	add a
+
	ld e,Enemy.var31
	ld (de),a
	ret


;;
aquamentus_playHoverSoundEvery32Frames:
	ld a,(wFrameCounter)
	and $1f
	ret nz

	ld a,SND_AQUAMENTUS_HOVER
	jr aquamentus_playSound

;;
aquamentus_body_playFootstepSoundEvery18Frames:
	ld a,$12
	jr ++

;;
aquamentus_body_playFootstepSoundEvery24Frames:
	ld a,$18
++
	ld h,d
	ld l,Enemy.var36
	dec (hl)
	ret nz

	ld (hl),a
	ld a,SND_ROLLER

aquamentus_playSound:
	jp playSound

;;
aquamentus_horn_updateAnimation:
	ld a,Object.var34
	call objectGetRelatedObject1Var
	ld h,(hl)

	ld l,Enemy.animParameter
	ld a,(hl)
	inc a
	ld hl,@animations
	rst_addAToHl

	ld a,(hl)
	ld h,d
	ld l,Enemy.var30
	cp (hl)
	ret z

	ld (hl),a
	jp enemySetAnimation

@animations:
	.db $06 $05 $05 $05 $05 $06 $06 $06
	.db $07 $08

aquamentus_projectileFireDelayCounters:
	.db 0, 100, 60, 180, 180


; Each byte corresponds to one horizontal quarter of the screen. Aquamentus will charge if
; a randomly chosen bit from that byte is set. (Doesn't apply if Link is behind
; aquamentus.)
aquamentus_chargeProbabilities:
	.db $03 $31 $13 $33


aquamentus_collisionBoxSizes:
	.db $16 $08
	.db $16 $08
	.db $0a $0d
	.db $0a $0d
	.db $0a $0d
	.db $0c $14

aquamentus_animations:
	.db $00 $00 $01 $02 $03 $04


; Each byte is a z value to add depending on aquamentus's current height.
aquamentus_fallingSpeeds:
	.db $00 $f0 $f0 $f0 $f0 $f0 $f0 $e0
	.db $e0 $e0 $e0 $c0 $c0 $a0 $60 $30

aquamentus_hornXYOffsets:
	.db $d8 $f4
	.db $d7 $f4
	.db $e8 $f2
	.db $e7 $f2
	.db $e8 $f2
	.db $e8 $f8
	.db $e5 $f4
	.db $e8 $f2
	.db $0f $e8


; ==============================================================================
; ENEMYID_DODONGO
;
; Variables:
;   var30: Animation base?
;   var31: Corresponds to direction Link was facing when he picked Dodongo up
;   var32: Index in the "attack pattern" ($00-$0f).
;   var33: Animation index?
; ==============================================================================
enemyCode79:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw dodongo_state_uninitialized
	.dw dodongo_state_stub
	.dw dodongo_state_grabbed
	.dw dodongo_state_stub
	.dw dodongo_state_stub
	.dw dodongo_state_stub
	.dw dodongo_state_stub
	.dw dodongo_state_stub
	.dw dodongo_state8
	.dw dodongo_state9
	.dw dodongo_stateA
	.dw dodongo_stateB
	.dw dodongo_stateC
	.dw dodongo_stateD

dodongo_state_uninitialized:
	ld bc,$0208
	call enemyBoss_spawnShadow
	ret nz

	ld a,ENEMYID_DODONGO
	ld b,PALH_SEASONS_81
	call enemyBoss_initializeRoom

	ld e,Enemy.var33
	ld a,$04
	ld (de),a
	call enemySetAnimation

	call ecom_setSpeedAndState8
	jp objectSetVisible82


dodongo_state_grabbed:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @landed

@justGrabbed:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	ld a,$20
	ld (wLinkGrabState2),a

	ld l,Enemy.var31
	ld a,(w1Link.direction)
	add a
	add a
	ld (hl),a

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.counter2
	ld (hl),$01

	ld l,Enemy.var30
	ld (hl),$ff

	jp objectSetVisible81

@beingHeld:
	call dodongo_updateAnimationWhileHeld
	jr z,@dropDodongo

	; Slow down Link's movement
	ld a,(wFrameCounter)
	and $03
	ret z
	ld hl,wLinkImmobilized
	set 5,(hl)
	ret

@dropDodongo:
	call dropLinkHeldItem
	ld h,d
	ld l,Enemy.substate
	ld (hl),$03
	inc l
	ld (hl),60 ; [counter1]

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.direction
	ld a,(hl)
	jp enemySetAnimation

@released:
	ld h,d
	ld l,Enemy.collisionType
	bit 7,(hl)
	jr nz,++

	; Re-enable collisions, change animation?
	set 7,(hl)
	ld e,Enemy.direction
	ld a,(de)
	add $02
	call enemySetAnimation
++
	call dodongo_setInvincibilityAndPlaySoundIfInSpikes
	ret nz
	jr @inSpikes

@landed:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call dodongo_setInvincibilityAndPlaySoundIfInSpikes
	jp nz,dodongo_resetMovement

@inSpikes:
	ld h,d
	ld l,Enemy.var33
	dec (hl)
	call z,ecom_killObjectH

	ld l,Enemy.state
	ld (hl),$0c

	ld l,Enemy.counter2
	ld (hl),$04
	dec l
	ld (hl),30 ; [counter1]

	; If angle value not set, calculate angle based on direction?
	ld l,Enemy.angle
	bit 7,(hl)
	jr z,++
	dec l
	ldi a,(hl) ; [direction]
	add a
	xor $10
	ld (hl),a
++
	jp objectSetVisible82


dodongo_state_stub:
	ret


; Waiting for Link to enter room
dodongo_state8:
	ld a,(wcc93)
	or a
	ret nz

	ld a,$09
	ld (de),a ; [state]

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	call playSound


; Deciding what direction to walk in
dodongo_state9:
	call dodongo_turnTowardLinkIfPossible
	ret nc

	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0a

	ld l,Enemy.speed
	ld (hl),SPEED_40

	; Decide how long to walk for
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	; Set animation
	ld e,Enemy.angle
	ld a,(de)
	rrca
	dec e
	ld (de),a ; [direction]
	call enemySetAnimation

	; Set collision box based on facing direction
	ld e,Enemy.angle
	ld a,(de)
	and $08
	rrca
	rrca
	ld hl,@collisionRadii
	rst_addAToHl
	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

@collisionRadii:
	.db $0c $08 ; Up/down
	.db $08 $10 ; Left/right

@counter1Vals: ; Potential lengths of time to walk for before attacking
	.db 160, 160, 120, 160, 120, 120, 120, 120


; Walking
dodongo_stateA:
	call dodongo_playStompSoundAtInterval
	call ecom_decCounter1
	jr nz,@walking

	call dodongo_updateAngleTowardLink
	jp c,dodongo_initiateNextAttack

	; Reset movement if Link is no longer lined up well
	jp dodongo_resetMovement

@walking:
	; If counter2 is nonzero, he's charging up, not moving
	call ecom_decCounter2
	jr nz,dodongo_doubleAnimate

	call dodongo_checkTileInFront
	jp nc,dodongo_resetMovement

	call objectApplySpeed
	ld e,Enemy.speed
	ld a,(de)
	cp SPEED_40
	jr z,dodongo_animate

dodongo_doubleAnimate:
	call enemyAnimate
dodongo_animate:
	jp enemyAnimate


; Opening mouth, preparing to fire
dodongo_stateB:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jp z,dodongo_checkEatBomb

	dec a
	jr nz,@animate

	ld (de),a ; [animParameter] = 0

	; Fire projectile
	ld b,PARTID_DODONGO_FIREBALL
	call ecom_spawnProjectile

	ld a,SND_BEAM2
	call playSound

	jr dodongo_animate

@animate:
	add $03
	jr nz,dodongo_animate
	jr dodongo_resetMovement


; In spikes?
dodongo_stateC:
	ld h,d
	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	ret nz

	; Delay before moving back
	call ecom_decCounter2
	ret nz

	ld l,Enemy.counter1
	ld a,(hl)
	cp 30
	jr nz,@moveBack

	ld l,Enemy.speed
	ld (hl),SPEED_140

	; Reverse angle
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ldd (hl),a

	rrca
	ld (hl),a ; [direction]
	call enemySetAnimation

@moveBack:
	call dodongo_playStompSoundAtInterval
	call ecom_decCounter1
	jr nz,++

	call dodongo_checkInSpikes
	jr nz,dodongo_resetMovement

	ld e,Enemy.counter1
	ld a,$0a
	ld (de),a
++
	call objectApplySpeed
	jr dodongo_doubleAnimate


; Just ate a bomb
dodongo_stateD:
	call objectAddToGrabbableObjectBuffer
	call objectPushLinkAwayOnCollision

	; When counter2 reaches 0, dodongo begins getting up
	call ecom_decCounter2
	ret nz

	call dodongo_updateAnimationWhileSlimmingDown
	jr z,dodongo_resetMovement

	ld l,Enemy.direction


;;
; @param	hl	Pointer to Enemy.direction
dodongo_updateAnimation:
	ld e,Enemy.var30
	ld a,(de)
	and $01
	add $02
	add (hl)
	jp enemySetAnimation

;;
dodongo_resetMovement:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.counter1
	xor a
	ldi (hl),a
	ld (hl),a ; [counter2]

	ld l,Enemy.direction
	ld a,(hl)
	jp enemySetAnimation


;;
; Either turns toward Link or, if facing a wall, turns in some other random direction.
;
; @param[out]	c	c if wasn't able to turn in any valid direction
dodongo_turnTowardLinkIfPossible:
	call ecom_updateCardinalAngleTowardTarget
	call dodongo_checkTileInFront
	ret c
	call ecom_setRandomCardinalAngle

	; Fall through

;;
; @param[out]	cflag	c if tile in front of dodongo is not a spike
dodongo_checkTileInFront:
	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld hl,@positionOffsets
	rst_addAToHl

	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a
	call getTileAtPosition
	cp $a4
	scf
	ret z

	sub TILEINDEX_RESPAWNING_BUSH_CUT
	cp TILEINDEX_RESPAWNING_BUSH_READY - TILEINDEX_RESPAWNING_BUSH_CUT + 1
	ret

@positionOffsets:
	.db -13,  0
	.db   4, 17
	.db  13,  0
	.db   4,-17

;;
dodongo_playStompSoundAtInterval:
	ld e,Enemy.speed
	ld a,(de)
	cp SPEED_40
	ld b,$1f
	jr z,+
	ld b,$0f
+
	ld a,(wFrameCounter)
	and b
	ret nz
	ld a,SND_SCENT_SEED
	jp playSound

;;
; @param[out]	c	c if Link is at a good angle to charge him
dodongo_updateAngleTowardLink:
	ld c,$0c
	call objectCheckCenteredWithLink
	ret nc

	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	sub b
	add $04
	cp $09
	ret


;;
; @param[out]	zflag	z if dodongo is ready to continue moving
dodongo_updateAnimationWhileSlimmingDown:
	ld e,Enemy.var30
	ld a,(de)
	inc a
	ld (de),a
	cp $11
	ret z

	ld l,Enemy.counter2
	cp $07
	jr c,++
	ld (hl),$08
	or d
	ret
++
	ld bc,@counter2Vals
	call addAToBc
	ld a,(bc)
	ld (hl),a ; [counter2]
	or d
	ret

@counter2Vals:
	.db 180, 20, 20, 16, 16, 10, 10

;;
dodongo_checkEatBomb:
	; Check bomb 1
	ld c,ITEMID_BOMB
	call findItemWithID
	jr nz,@animate
	call @checkBombInRangeToEat
	jr z,@eatBomb

	; Check bomb 2
	ld c,ITEMID_BOMB
	call findItemWithID_startingAfterH
	jr nz,@animate
	call @checkBombInRangeToEat
	jr z,@eatBomb
@animate:
	jp enemyAnimate

@eatBomb:
	; Signal bomb's deletion
	ld l,Item.var2f
	set 5,(hl)

	ld h,d
	ld l,Enemy.var30
	ld (hl),$00

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.state
	ld (hl),$0d

	ld l,Enemy.direction
	ldd a,(hl)
	ld (hl),120

	add $02
	call enemySetAnimation

	ld a,SND_DODONGO_EAT
	jp playSound

;;
; @param	h	Bomb object
; @param[out]	zflag	z if bomb shall be eaten
@checkBombInRangeToEat:
	; Is bomb being held?
	ld l,Item.var2f
	ld a,(hl)
	bit 6,a
	jr z,@notEaten

	; Don't eat if it's exploding or slated for delation?
	and $b0
	jr nz,@notEaten

	; Don't eat if it's being held
	ld l,Item.substate
	ld a,(hl)
	cp $02
	jr c,@notEaten

	; Get position at dodongo's mouth (based on direction it's moving in)
	push hl
	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld hl,@positionOffsets
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)
	ld h,d
	ld l,Enemy.yh
	add (hl)
	ld b,a
	ld l,Enemy.xh
	ld a,(hl)
	add c
	ld c,a

	; Check for collision with bomb
	pop hl
	ld l,Item.yh
	ld a,(hl)
	sub b
	add $0c
	cp $19
	jr nc,@notEaten

	ld l,Item.xh
	ld a,(hl)
	sub c
	add $08
	cp $11
	jr nc,@notEaten

	xor a
	ret

@notEaten:
	or d
	ret

@positionOffsets:
	.db -6,  0
	.db  0, 12
	.db 12,  0
	.db  0,-12

;;
; Determines next attack.
dodongo_initiateNextAttack:
	ld e,Enemy.var32
	ld a,(de)
	inc a
	and $0f
	ld (de),a
	ld hl,@attackPattern
	call checkFlag
	ld h,d
	jr z,@chargeAttack

	; Fireball attack (opening mouth)
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.direction
	ld a,(hl)
	inc a
	call enemySetAnimation
	ld a,SND_DODONGO_OPEN_MOUTH
	jp playSound

@chargeAttack:
	ld l,Enemy.speed
	ld (hl),SPEED_140
	ld l,Enemy.counter2
	ld (hl),45
	dec l
	ld (hl),128 ; [counter1]
	ret

@attackPattern:
	dbrev %01101011, %00010110


;;
; @param[out]	zflag	z if in spikes
dodongo_setInvincibilityAndPlaySoundIfInSpikes:
	call dodongo_checkInSpikes
	ret nz

	ld e,Enemy.invincibilityCounter
	ld a,$30
	ld (de),a
	ld a,SND_BOSS_DAMAGE
	call playSound
	xor a
	ret

;;
; @param[out]	zflag	z if in spikes
dodongo_checkInSpikes:
	ld h,d
	ld l,Enemy.zh
	bit 7,(hl)
	ret nz
	ld l,Enemy.yh
	ldi a,(hl)
	add $05
	ld b,a
	inc l
	ld c,(hl)
	call getTileAtPosition
	cp TILEINDEX_SPIKES
	ret

;;
; @param[out]	zflag	z if king dodongo has regained normal weight and is ready to move
dodongo_updateAnimationWhileHeld:
	ld h,d
	ld l,Enemy.counter2
	dec (hl)
	jr nz,++
	call dodongo_updateAnimationWhileSlimmingDown
	ret z
++
	; Update animation based on Link's direction
	ld l,Enemy.var31
	ld a,(w1Link.direction)
	add a
	add a
	ld b,a
	sub (hl)
	ld (hl),b

	ld l,Enemy.direction
	add (hl)
	and $0c
	ld (hl),a

	call dodongo_updateAnimation
	or d
	ret


; ==============================================================================
; ENEMYID_MOTHULA
;
; Variables:
;   var30: Angular speed (amount to add to angle; clockwise / counterclockwise)
;   var31: Index used to decide turning speed while circling around room
;   var32/var33: Target position
;   var34: Counter until mothula stops circling around room
;   var35: Counter to delay updating angle toward target position
;   var36: If nonzero, spawns baby moths instead of ring of fire
;   var37: Counter until mothula will shoot a fireball (while circling around room)
; ==============================================================================
enemyCode7a:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw mothula_state_uninitialized
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state_stub
	.dw mothula_state8
	.dw mothula_state9
	.dw mothula_stateA
	.dw mothula_stateB
	.dw mothula_stateC
	.dw mothula_stateD
	.dw mothula_stateE
	.dw mothula_stateF

@dead:
	call getThisRoomFlags
	set 7,(hl)

	; Set bit 7 of room flag in room 1 floor below
	ld a,(wDungeonFlagsAddressH)
	ld h,a
	ld l,$43
	set 7,(hl)
	jp enemyBoss_dead


mothula_state_uninitialized:
	ld a,ENEMYID_MOTHULA
	ld b,PALH_SEASONS_82
	call enemyBoss_initializeRoom

	ld bc,$0108
	call enemyBoss_spawnShadow
	ret nz

	call ecom_setSpeedAndState8
	ld c,$10
	jp ecom_setZAboveScreen


mothula_state_stub:
	ret


mothula_state8:
	call objectSetVisible81

	ld a,(wFrameCounter)
	and $1f
	ld a,SND_AQUAMENTUS_HOVER
	call z,playSound

	; Move down
	ld c,$04
	call objectUpdateSpeedZ_paramC
	ld l,Enemy.zh
	ld a,(hl)
	cp $fe
	jr c,mothula_animate

	; Reached ground
	ld l,Enemy.state
	inc (hl) ; [state] = 9

	ld l,Enemy.counter1
	ld (hl),60
	call mothula_setTargetPositionToLeftOrRightSide

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	jp playSound


; Delay before moving
mothula_state9:
	call ecom_decCounter1
	jr nz,mothula_animate

	inc l
	ld (hl),10 ; [counter2]
	ld l,e
	inc (hl) ; [state] = $0a
	call mothula_spawnChild


; Just beginning to move
mothula_stateA:
	call mothula_checkReachedTargetPosition
	jr nc,mothula_moveTowardTargetPosition

	ld l,Enemy.state
	inc (hl) ; [state] = $0b

	ld l,Enemy.counter1
	ld (hl),14
	ld l,Enemy.var37
	ld (hl),$50

	call mothula_initializeStateB
	jr mothula_stateB


; Circling around normally
mothula_stateB:
	call mothula_decVar34Every4Frames
	jr nz,@circlingAround

	; Time to return to center of room (state $0c)
	ld l,e
	inc (hl) ; [state] = $0c
	ld l,Enemy.counter1
	ld (hl),$00

	call mothula_chooseTargetPositionWithinHoles
	jr mothula_animate

@circlingAround:
	ld h,d
	ld l,Enemy.var37
	dec (hl)
	call z,mothula_spawnFireball

	; Increase speed every 10 frames
	call ecom_decCounter2
	jr nz,+++

	ld (hl),10 ; [counter2]
	ld l,Enemy.speed
	ld a,(hl)
	add SPEED_40
	cp SPEED_300 + 1
	jr nc,+++
	ld (hl),a
+++
	call ecom_decCounter1
	jr nz,mothula_applySpeedAndAnimate

	; Turn clockwise or counterclockwise
	ld l,Enemy.var30
	ld e,Enemy.angle
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
	call mothula_updateAnimation
	call mothula_updateCounter1ForCirclingRoom
	jr nz,mothula_applySpeedAndAnimate

	ld e,Enemy.var31
	ld a,$0e
	ld (de),a
	call mothula_updateCounter1ForCirclingRoom

mothula_applySpeedAndAnimate:
	call objectApplySpeed
mothula_animate:
	jp enemyAnimate


; Returning to one of the two center spots
mothula_stateC:
	call mothula_checkReachedTargetPosition
	jr nc,mothula_moveTowardTargetPosition

	ld l,Enemy.state
	inc (hl) ; [state] = $0d
	xor a
	jp enemySetAnimation


mothula_moveTowardTargetPosition:
	call mothula_updateAngleTowardTargetPosition
	jr mothula_applySpeedAndAnimate


; Deciding how long to stand in place?
mothula_stateD:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0e

	ld bc,$0840
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.var36
	ld a,b
	ld (de),a

	ld e,Enemy.counter1
	ld a,120
	add c
	ld (de),a
	jr mothula_animate


; Standing in place
mothula_stateE:
	call ecom_decCounter1
	jr z,++
	call mothula_updateZPosAndOamFlagsForStateE
	jr mothula_animate
++
	inc l
	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [state] = $0f

	ld l,Enemy.zh
	ld (hl),$fe

	ld l,Enemy.oamFlags
	ld a,$06
	ldd (hl),a
	ld (hl),a

	call mothula_spawnSomethingAfterStandingStill
	ld a,$08
	jp enemySetAnimation


; Delay before circling around room again
mothula_stateF:
	call ecom_decCounter2
	jr nz,mothula_animate

	ld l,e
	ld (hl),$0a ; [state] = $0a

	ld l,Enemy.counter2
	ld (hl),10
	dec l
	ld (hl),$00 ; [counter1]

	jp mothula_setTargetPositionToLeftOrRightSide


;;
; @param	hl	var37 (counter to spawn projectile)
mothula_spawnFireball:
	ld (hl),$50
	ld b,PARTID_MOTHULA_PROJECTILE_1
	jp ecom_spawnProjectile

;;
; Decides what to spawn after state $0e (small moth or ring of fireballs).
mothula_spawnSomethingAfterStandingStill:
	ld e,Enemy.var36
	ld a,(de)
	or a
	jr nz,mothula_spawnChild

	ld b,PARTID_MOTHULA_PROJECTILE_2
	call ecom_spawnProjectile
	ret nz

	ld l,Part.subid

;;
; Sets child object's subid to $80 normally, or $81 if mothula's health is $10 or less
;
; @param	hl	Pointer to child object's subid
mothula_initChild:
	ld b,$80
	ld e,Enemy.health
	ld a,(de)
	cp $10
	jr nc,+
	inc b
+
	ld (hl),b
	ret

;;
mothula_spawnChild:
	ld b,ENEMYID_MOTHULA_CHILD
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz
	call mothula_initChild
	jp objectCopyPosition

;;
; Update mothula "bouncing" in place for state $0e
;
; @param	hl	counter1
mothula_updateZPosAndOamFlagsForStateE:
	ld a,(hl)
	cp 90
	ret nc

	and $0e
	rrca
	ld bc,@zPositions
	call addAToBc

	ld l,Enemy.zh
	ld a,(bc)
	ld (hl),a

	ld l,Enemy.var36
	ld b,(hl)
	srl b
	srl b
	ld l,Enemy.counter1
	ld a,(hl)
	and $01
	add b
	ld bc,@oamFlags
	call addAToBc
	ld l,Enemy.oamFlags
	ld a,(bc)
	ldd (hl),a
	ld (hl),a
	ret

@zPositions:
	.db $ff $fe $fd $fc $fb $fc $fd $fe

@oamFlags:
	.db $06 $04 ; Spawning baby moths
	.db $06 $05 ; Spawning ring of fire


;;
; @param[out]	cflag	c if reached target position
mothula_checkReachedTargetPosition:
	ld h,d
	ld l,Enemy.var32
	call ecom_readPositionVars
	sub c
	add $04
	cp $09
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	ret


;;
mothula_setTargetPositionToLeftOrRightSide:
	call getRandomNumber_noPreserveVars
	and $01
	jr nz,+
	dec a
+
	ld h,d
	ld l,Enemy.var30
	ld (hl),a

	ld a,$32
	ld b,$ba
	bit 7,(hl)
	jr z,+
	ld b,$36
+
	ld l,Enemy.var32
	ldi (hl),a
	ld (hl),b

	ld l,Enemy.angle
	ld (hl),$00
	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld l,Enemy.var31
	ld (hl),$00
	ld l,Enemy.var35
	ld (hl),$06
	jr mothula_updateAnimation

;;
; Chooses a position in one of the two center areas
mothula_chooseTargetPositionWithinHoles:
	call getRandomNumber_noPreserveVars
	rrca
	ld a,$50
	ld b,$68
	jr c,+
	ld b,$88
+
	ld h,d
	ld l,Enemy.var32
	ldi (hl),a
	ld (hl),b
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ret

;;
mothula_updateAngleTowardTargetPosition:
	ld h,d
	ld l,Enemy.var35
	dec (hl)
	ret nz

	ld (hl),$06

	call objectGetRelativeAngleWithTempVars
	ld c,a
	call objectNudgeAngleTowards

;;
mothula_updateAnimation:
	ld h,d
	ld l,Enemy.angle
	ldd a,(hl)
	add $02
	and $1c
	rrca
	rrca
	cp (hl) ; [direction]
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Updates counter1 to decide how long until the angle will next be updated. This allows
; mothula to move in an oval pattern.
;
; @param[out]	zflag	z if completed a full circle (var31 should be reset)
mothula_updateCounter1ForCirclingRoom:
	ld h,d
	ld l,Enemy.var31
	ld a,(hl)
	inc (hl)
	ld b,a
	srl a
	ld hl,@counterVals
	rst_addAToHl
	ld a,(hl)
	rrc b
	jr c,+
	swap a
+
	and $0f
	ret z
	ld e,Enemy.counter1
	ld (de),a
	ret

; Each half-byte is a value for counter1, determining how fast mothula turns at various
; points during her movement.
@counterVals:
	.db $33 $48 $55 $66 $77 $7f $55 $54
	.db $32 $36 $32 $34 $55 $8f $76 $00


;;
; @param[out]	zflag	z if var34 reached 0
mothula_decVar34Every4Frames:
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld h,d
	ld l,Enemy.var34
	dec (hl)
	ret


;;
; Calculates appropriate angle, and decides how long to remain in state $0b (circling
; around room).
mothula_initializeStateB:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@var34Vals
	rst_addAToHl
	ld e,Enemy.var34
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	dec a
	ld a,$0c
	jr z,+
	ld a,$14
+
	ld e,Enemy.angle
	ld (de),a
	jr mothula_updateAnimation

; Potential lengths of time for Mothula to circle around the room
@var34Vals:
	.db $35 $5b $5b $82


; ==============================================================================
; ENEMYID_GOHMA
;
; Variables for subid 1 (main body):
;   relatedObj2: Reference to subid 3 (claw)
;   var30: ?
;   var31: Affects animation?
;   var32: Number of "children" spawned (ENEMYID_GOHMA_GEL)
;
; Variables for subid 2 (body hitbox):
;   relatedObj1: Reference to subid 1
;
; Variables for subid 3 (claw):
;   relatedObj1: Reference to subid 1
;   var30: Nonzero if Link was caught?
; ==============================================================================
enemyCode7b:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@collisionOccurred

	; Health is 0 (might just be moving to next phase)
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp z,gohma_subid1_dead

	ld e,Enemy.animParameter
	ld a,(de)
	cp $80
	jp nz,gohma_subid3_dead

	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,++
	ld (hl),10
	ld l,Enemy.state
	inc (hl)
	inc l
	ld (hl),$00
++
	jp enemyDie_uncounted

@collisionOccurred:
	ld e,Enemy.subid
	ld a,(de)
	cp $01
	jr nz,++

	ld a,Object.id
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp ENEMYID_GOHMA
	jr nz,@normalStatus

	ld l,Enemy.invincibilityCounter
	ld e,l
	ld a,(de)
	ld (hl),a
	jr @normalStatus
++
	cp $03
	jr nz,@normalStatus

	ld e,Enemy.var2a
	ld a,(de)
	res 7,a
	cp ITEMCOLLISION_L1_SWORD
	jr nc,@normalStatus

	; Link or shield collision
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_GOHMA_CLAW_LUNGING
	jr nz,@normalStatus

	ld e,Enemy.var30
	ld a,$01
	ld (de),a

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@state8OrHigher
	rst_jumpTable
	.dw gohma_state_uninitialized
	.dw gohma_state_spawner
	.dw gohma_state_stub
	.dw gohma_state_stub
	.dw gohma_state_stub
	.dw gohma_state_stub
	.dw gohma_state_stub
	.dw gohma_state_stub

@state8OrHigher:
	dec b
	ld a,b
	rst_jumpTable
	.dw gohma_subid1
	.dw gohma_subid2
	.dw gohma_subid3


gohma_state_uninitialized:
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8

	; Subid 0
	inc a
	ld (de),a ; [state] = 1
	ld a,ENEMYID_GOHMA
	call enemyBoss_initializeRoom


gohma_state_spawner:
	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	ld b,ENEMYID_GOHMA
	call ecom_spawnUncountedEnemyWithSubid01
	call objectCopyPosition

	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	ld c,h
	ld e,$02
	call @spawnChild

	ld e,$03
	call @spawnChild

	ld a,h
	ld h,c
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),$80
	jp enemyDelete

@spawnChild:
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),e ; [subid] = e
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c
	ret


gohma_state_stub:
	ret


; Main body
gohma_subid1:
	ld a,(de) ; [state]
	sub $08
	rst_jumpTable
	.dw gohma_subid1_state8
	.dw gohma_subid1_state9
	.dw gohma_subid1_stateA
	.dw gohma_subid1_stateB
	.dw gohma_subid1_stateC
	.dw gohma_subid1_stateD


; Initialization
gohma_subid1_state8:
	ld bc,$0208
	call enemyBoss_spawnShadow
	ret nz

	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = 9

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GOHMA_BODY

	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.var31
	ld (hl),$02

	ld c,$08
	jp ecom_setZAboveScreen


; Following Link from the ceiling
gohma_subid1_state9:
	call ecom_decCounter1
	jr nz,@updatePosition

	ld (hl),30 ; [counter1]
	ld c,$28
	call objectCheckLinkWithinDistance
	jr nc,@updatePosition

	; Time to fall down
	ld l,Enemy.state
	inc (hl) ; [state] = $0a

	ld a,Object.visible
	call objectGetRelatedObject2Var
	set 7,(hl)

	call objectSetVisible81
	ld c,$08
	call ecom_setZAboveScreen

@updatePosition:
	call ecom_updateCardinalAngleTowardTarget
	call gohma_updateSpeedWhileFalling
	call objectApplySpeed

	; Check that x-position is contained in the room
	ld e,Enemy.xh
	ld a,(de)
	cp $20
	jr nc,++
	ld a,$20
	ld (de),a
	ret
++
	cp $d0
	ret c
	ld a,$d0
	ld (de),a
	ret


; Falling down
gohma_subid1_stateA:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jr z,@hitGround

	ld a,(de)
	cp $f9
	ret c
	ld a,$02
	jp gohma_setAnimation

@hitGround:
	ld l,Enemy.state
	inc (hl) ; [state] = $0b
	ld l,Enemy.counter1
	ld (hl),60

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	call playSound
	ld a,SND_STRONG_POUND
	call playSound

	ld a,$28
	call setScreenShakeCounter
	jp objectSetVisible83


; Standing in place
gohma_subid1_stateB:
	call ecom_decCounter1
	ret nz

	inc (hl) ; [counter1] = 1
	ld l,e
	inc (hl) ; [state] = $0c

	ld l,Enemy.var30
	ld (hl),45
	ret


; Phase 1 of fight: claw still intact
gohma_subid1_stateC:
	call gohma_subid1_updateAnimationsAndCollisions
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw gohma_stateC_substate2
	.dw gohma_stateC_substate3
	.dw gohma_stateC_substate4

; Standing in place before deciding which way to move
@substate0:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate] = 1
	call gohma_phase1_decideAngle
	call gohma_decideMovementDuration
	call gohma_decideAnimation
	jp gohma_updateSpeedWhileFalling

; Walking in some direction
@substate1:
	call enemyAnimate
	call ecom_decCounter2

	; Jump if Link is in front of gohma within $28 pixels?
	ld h,d
	ld l,Enemy.yh
	ld a,(w1Link.yh)
	sub (hl)
	cp $28
	jr nc,gohma_movingNormally

	; Jump if Link isn't close to gohma horizontally
	ld l,Enemy.xh
	ld a,(w1Link.xh)
	sub (hl)
	add $18
	cp $25
	jr nc,gohma_movingNormally

	; Charge at Link if counter2 is zero?
	ld l,Enemy.counter2
	ld a,(hl)
	or a
	jr z,gohma_beginLungeTowardLink

gohma_movingNormally:
	call gohma_checkWallsAndPlayWalkingSound
	call ecom_decCounter1
	ret nz

	; [substate] = 0 (stop moving for a moment)
	ld l,Enemy.substate
	dec (hl)
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,gohma_counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

gohma_beginLungeTowardLink:
	ld l,Enemy.substate
	inc (hl) ; [substate] = 2
	inc l
	ld (hl),31 ; [counter1]

	ld l,Enemy.speed
	ld (hl),SPEED_300

	; Check if claw was destroyed?
	ld a,Object.health
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	jr z,++

	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.collisionType
	set 7,(hl)
++
	ld a,$09

gohma_setAnimation:
	ld e,Enemy.direction
	ld (de),a
	jp enemySetAnimation


; Lunging toward Link (or moving back) with claw
gohma_stateC_substate2:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,@doneLunge

	res 7,a
	dec a
	ret z
	jp gohma_updateLunge

@doneLunge:
	; Check if grabbed Link
	ld a,(w1Link.state)
	cp LINK_STATE_GRABBED
	jr z,gohma_stateC_setSubstate4

	ld h,d
	ld l,Enemy.substate
	inc (hl) ; [substate] = 3
	inc l
	ld (hl),20 ; [counter1]
	ret

; Grabbed Link
gohma_stateC_setSubstate4:
	ld e,Enemy.substate
	ld a,$04
	ld (de),a
	ld a,$0a
	jr gohma_setAnimation


; Standing in place after lunge
gohma_stateC_substate3:
	ld a,(w1Link.state)
	cp LINK_STATE_GRABBED
	jr z,gohma_stateC_setSubstate4

	call ecom_decCounter1
	ret nz

	inc (hl) ; [counter1] = 1
	inc l
	ld (hl),40 ; [counter2]

	ld l,e
	ld (hl),$00 ; [substate]

	ld l,Enemy.var31
	ld (hl),$02
	ret


; Holding Link
gohma_stateC_substate4:
	call enemyAnimate
	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	ret z

	ld l,Enemy.substate
	ld (hl),$00
	inc l
	ld (hl),60 ; [counter1]

	ld l,Enemy.var31
	ld (hl),$02
	ret


; Phase 2 of fight: claw destroyed
gohma_subid1_stateD:
	call gohma_subid1_updateAnimationsAndCollisions
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call getRandomNumber_noPreserveVars
	and $03
	jr nz,@chooseNextMovement

	ld h,d
	ld l,Enemy.var32
	ld a,(hl)
	cp $05
	jr nc,@chooseNextMovement

	ld l,Enemy.substate
	ld (hl),$02
	inc l
	ld (hl),$01 ; [counter1]

	ld a,$0b
	jp gohma_setAnimation

@chooseNextMovement:
	call ecom_setRandomCardinalAngle
	ld e,Enemy.substate
	ld a,$01
	ld (de),a
	call gohma_decideMovementDuration
	call gohma_decideAnimation
	jp gohma_updateSpeedWhileFalling


@substate1:
	call enemyAnimate
	jp gohma_movingNormally

@substate2:
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,@chooseNextMovement

	res 7,a
	dec a
	jr z,@animate
	call ecom_decCounter1
	call z,gohma_phase2_spawnGelChild
@animate:
	jp enemyAnimate


; Collision box for legs
gohma_subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9

@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	; Save id in var30 (never actually used though?)
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

@state9:
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,enemyDelete

	; Copy position of parent
	ld bc,$ff00
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset


; Claw
gohma_subid3:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF

; Uninitialized
@state8:
	ld a,$09
	ld (de),a ; [state]

	call objectSetVisible81
	call objectSetInvisible
	ld a,$0c
	jp enemySetAnimation


; Falling from ceiling along with main body
@state9:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0a
	jr z,@falling
	ret c

	; Landed
	ld h,d
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GOHMA_CLAW
	ld l,Enemy.zh
	ld (hl),$00
	jp objectSetVisible82

@falling:
	ld l,Enemy.zh
	ld a,(hl)
	cp $f9
	jr nc,@closeToGround

	ld bc,$f806
	jp objectTakePositionWithOffset

@closeToGround:
	ld a,$0d
	call enemySetAnimation
	jr @updateNormalPosition


; Standing in place
@stateA:
	call gohma_checkShouldBlock
	call gohma_updateCollisionsEnabled
	call @updateNormalPosition
	jp enemyAnimate


; Blocking eye with claw
@stateB:
	call ecom_decCounter1
	jp nz,gohma_claw_updateBlockingPosition

@gotoStateA:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GOHMA_CLAW
	ld a,$0d
	call enemySetAnimation

@updateNormalPosition:
	ld bc,$08fa
	ld a,Object.start
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset


; Beginning attack with claw (being held behind gohma)
@stateC:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0c

	ld l,Enemy.var30
	ld (hl),$00

	ld a,$0f
	call enemySetAnimation

	ld a,SND_SWORDSLASH
	call playSound

	jp gohma_claw_updatePositionInLunge


; Claw in the process of attacking
@stateD:
	call enemyAnimate

	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	jr nz,@label_0e_308

	bit 0,(hl)
	jr z,++

	res 0,(hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GOHMA_CLAW_LUNGING
++
	call gohma_claw_updatePositionInLunge
	ld e,Enemy.var30
	ld a,(de)
	or a
	ret z
	jr @linkCaught

@label_0e_308:
	ld e,Enemy.var30
	ld a,(de)
	or a
	jp z,@gotoStateA

	xor a
	call gohma_claw_setPositionInLunge

@linkCaught:
	ld a,$10
	call enemySetAnimation

	; Mess with Link's animation?
	ld hl,w1Link.var31
	ld (hl),$0d
	ld l,<w1Link.animMode
	ld (hl),$00

	ld l,SpecialObject.collisionType
	res 7,(hl)

	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0e

	ld l,Enemy.animParameter
	ld (hl),$08
	jr @updateLinkPosition


; Claw grabbed Link and is pulling him back
@stateE:
	; Wait for main body to move back into position
	ld a,Object.substate
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $04
	jr z,@donePullingBack

	call gohma_claw_updatePositionInLunge
	jr @updateLinkPosition

@donePullingBack:
	ld h,d
	dec l
	inc (hl) ; [state] = $0f
	ld l,Enemy.animParameter
	ld (hl),$00
	ret


; Claw is slamming Link into the ground
@stateF:
	call enemyAnimate

	; Check slam is done
	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	jp nz,@gotoStateA

	bit 2,(hl)
	jr z,@label_0e_311

	bit 4,(hl)
	jp z,gohma_updateClawPositionDuringSlamAttack

	res 4,(hl)
	ld hl,w1Link.substate
	ld (hl),$02
	ld l,<w1Link.collisionType
	set 7,(hl)
	jp gohma_updateClawPositionDuringSlamAttack

@label_0e_311:
	bit 4,(hl)
	jr z,++

	; A slam occurs now; play sound, apply damage, etc.
	res 4,(hl)
	ld a,SND_EXPLOSION
	call playSound
	ld a,$14
	call setScreenShakeCounter
	ld a,$0a
	ld (w1Link.invincibilityCounter),a
	ld a,-6
	ld (w1Link.damageToApply),a
	ld h,d
	ld l,Enemy.animParameter
++
	call gohma_updateLinkAnimAndClawPositionDuringSlamAttack

@updateLinkPosition:
	ld bc,$0002
	ld hl,w1Link
	jp objectCopyPositionWithOffset


;;
; Updates speed while falling to be fast vertically, slow horizontally.
gohma_updateSpeedWhileFalling:
	ld h,d
	ld l,Enemy.angle
	bit 3,(hl)
	ld l,Enemy.speed
	ld (hl),SPEED_80
	ret z
	ld (hl),SPEED_180
	ret

;;
; Reverses direction if gohma hits a wall, and plays walking sound.
gohma_checkWallsAndPlayWalkingSound:
	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	; Add offset to position based on direction we're moving in
	ld e,Enemy.angle
	ld a,(de)
	rrca
	rrca
	ld hl,gohma_positionOffsets
	rst_addAToHl
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a

	; Check for wall in front of gohma
	call getTileCollisionsAtPosition
	jr z,gohma_updateMovement

	; Reverse direction
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a

;;
gohma_updateMovement:
	; If moving down, don't allow gohma to pass a certain point?
	ld e,Enemy.angle
	ld a,(de)
	sub $09
	cp $0f
	jr nc,++
	ld e,Enemy.yh
	ld a,(de)
	cp $98
	jr nc,@updateWalkingSound
++
	call objectApplySpeed

@updateWalkingSound:
	ld e,Enemy.angle
	ld a,(de)
	bit 3,a
	ld b,$07
	jr nz,+
	ld b,$0f
+
	ld a,(wFrameCounter)
	and b
	ret nz

	ld a,SND_LAND
	jp playSound

gohma_positionOffsets:
	.db $f7 $00
	.db $00 $18
	.db $08 $00
	.db $00 $e7


;;
; Used by subid 1 (body) and 3 (claw)?
gohma_updateCollisionsEnabled:
	ld e,Enemy.health
	ld a,(de)
	or a
	ret z

	call objectGetAngleTowardEnemyTarget
	add $06
	and $1f
	cp $0d
	ld h,d
	ld l,Enemy.collisionType
	jr c,++
	set 7,(hl)
	ret
++
	res 7,(hl)
	ret

;;
; Main body has died (health is 0).
gohma_subid1_dead:
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	jr z,@dead

	; Kill all gels that gohma may have spawned
	ld h,FIRST_ENEMY_INDEX
@nextEnemy:
	ld l,Enemy.id
	ld a,(hl)
	cp ENEMYID_GOHMA_GEL
	call z,ecom_killObjectH
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	; Kill claw
	ld a,Object.id
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp ENEMYID_GOHMA
	jr nz,@dead

	call ecom_killObjectH
	ld l,Enemy.animParameter
	ld (hl),$80
@dead:
	jp enemyBoss_dead


;;
; Claw is dead
gohma_subid3_dead:
	ld h,d
	ld l,Enemy.collisionType
	ld a,(hl)
	or a
	jr z,+++

	ld (hl),$00
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld l,Enemy.angle
	ld (hl),$18
	ld bc,-$e0
	call objectSetSpeedZ
	ld a,$11
	call enemySetAnimation
+++
	ld c,$0a
	call objectUpdateSpeedZ_paramC
	call objectApplySpeed
	jp enemyAnimate


;;
gohma_subid1_updateAnimationsAndCollisions:
	ld e,Enemy.substate
	ld a,(de)
	dec a
	jr nz,@updateCollision

	; [substate] == 1

	ld h,d
	ld l,Enemy.var30
	dec (hl)
	jr nz,@updateCollision

	call getRandomNumber_noPreserveVars
	and $30
	add $a0
	ld b,a
	ld e,Enemy.var31
	ld a,(de)
	sub $02
	swap a
	cpl
	inc a
	rrca
	add b
	ld e,Enemy.var30
	ld (de),a

	ld h,d
	ld l,Enemy.counter1
	ld a,(hl)
	add $18
	ld (hl),a

	ld l,Enemy.var31
	ld a,(hl)
	xor $04
	ld (hl),a

	ld e,Enemy.angle
	ld a,(de)
	swap a
	rlca
	and $02
	add (hl) ; [var31]
	dec e
	ld (de),a ; [direction]
	dec a
	call enemySetAnimation

@updateCollision:
	ld e,Enemy.animParameter
	ld a,(de)
	rlca
	jp c,gohma_updateCollisionsEnabled

	ld e,Enemy.collisionType
	ld a,(de)
	res 7,a
	ld (de),a
	ret


;;
gohma_phase1_decideAngle:
	ld b,$00
	ld h,d
	ld l,Enemy.yh
	ld a,(hl)
	cp $60
	jr nc,@setAngle

	call getRandomNumber
	and $07
	jp z,ecom_setRandomCardinalAngle

	ld a,(w1Link.yh)
	sub (hl)
	cp $20
	jr c,@checkHorizontal

	ld b,$10
	cp $80
	jr c,@setAngle

	ld b,$00
	cp $e0
	jr c,@setAngle

@checkHorizontal:
	ld l,Enemy.xh
	ld a,(w1Link.xh)
	cp (hl)
	ld b,$18
	jr c,@setAngle

	ld b,$08
@setAngle:
	ld l,Enemy.angle
	ld (hl),b
	ret

;;
; Sets counter1 to something.
gohma_decideMovementDuration:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl

	; Horizontal movement has less duration
	ld e,Enemy.angle
	ld a,(de)
	and $08
	add a
	add a
	cpl
	inc a
	add (hl)
	ld e,Enemy.counter1
	ld (de),a
	ret

@counter1Vals:
	.db $60 $70 $80 $50

;;
gohma_decideAnimation:
	ld h,d
	ld l,Enemy.var31
	ld e,Enemy.angle
	ld a,(de)
	swap a
	rlca
	and $02
	add (hl)
	ld l,Enemy.direction
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
; Updates movement for "lunge" at Link with claw
gohma_updateLunge:
	call ecom_decCounter1
	ret z

	ld a,(hl)
	cp 30
	push af
	call z,gohma_initAngleForLungeAtLink

	pop af
	cp 15
	jp nz,gohma_updateMovement

	; Begin moving back
	ld e,Enemy.angle
	ld a,(de)
	xor $10
	ld (de),a
	jp gohma_updateMovement

;;
; Decides angle to use while charging toward Link, and plays sound effect.
gohma_initAngleForLungeAtLink:
	ld b,$00
	ld a,Object.xh
	call objectGetRelatedObject2Var
	ld a,(w1Link.xh)
	sub (hl)
	add $06
	cp $0d
	jr c,@setAngle

	ld b,$fe
	cp $86
	jr c,@setAngle

	ld b,$02

@setAngle:
	ld e,Enemy.angle
	ld a,$10
	add b
	ld (de),a

	ld a,SND_BEAM2
	jp playSound

;;
; @param	hl	Pointer to counter1
gohma_phase2_spawnGelChild:
	ld (hl),$07
	ld l,Enemy.var32
	ld a,(hl)
	cp $05
	ret nc

	call getRandomNumber_noPreserveVars
	and $03
	ld c,a
	ld b,ENEMYID_GOHMA_GEL
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	ld (hl),c ; [subid] = c (random number from 0 to 3)
	call objectCopyPosition
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld h,d
	ld l,Enemy.var32
	inc (hl)
	ld a,SND_GOHMA_SPAWN_GEL
	jp playSound

gohma_counter1Vals:
	.db $05 $0f $0f $19 $19 $19 $23 $23

;;
; If Link is using something and a certain item type is active, block eye with claw
gohma_checkShouldBlock:
	ld a,(wLinkUsingItem1)
	and $f0
	ret z

	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld a,(w1Link.yh)
	sub (hl)
	cp $2c
	ret c

	; Check if any item with ID above ITEMID_DUST is active?
	ld h,FIRST_ITEM_INDEX
@nextItem:
	ld l,Item.id
	ld a,(hl)
	cp ITEMID_DUST
	jr nc,@beginBlock
	inc h
	ld a,h
	cp $e0
	jr c,@nextItem
	ret

@beginBlock:
	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0b

	ld l,Enemy.counter1
	ld (hl),60

	ld a,$0e
	call enemySetAnimation

gohma_claw_updateBlockingPosition:
	ld bc,$07ff
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset

;;
gohma_claw_updatePositionInLunge:
	ld e,Enemy.animParameter
	ld a,(de)

;;
; @param	a	Position index
gohma_claw_setPositionInLunge:
	ld hl,@positions
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset

@positions:
	.db $08 $fa
	.db $05 $f3
	.db $fd $f3
	.db $ef $f8
	.db $09 $fb

;;
; @param	hl	Pointer to w1Link.animParameter?
gohma_updateLinkAnimAndClawPositionDuringSlamAttack:
	; Update Link's animation?
	ld a,(hl)
	ld hl,gohma_linkVar31Stuff
	rst_addAToHl
	ld a,(hl)
	ld (w1Link.var31),a

gohma_updateClawPositionDuringSlamAttack:
	ld e,Enemy.animParameter
	ld a,(de)
	and $03
	ld hl,gohma_clawSlamPositionOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectTakePositionWithOffset


gohma_linkVar31Stuff:
	.db $0d $0e $0f $0e

gohma_clawSlamPositionOffsets:
	.db $08 $fa
	.db $fd $f3
	.db $ef $f8
	.db $05 $f3


; ==============================================================================
; ENEMYID_DIGDOGGER
; ==============================================================================
enemyCode7c:
	jr z,@normalStatus
	sub $03
	ret c
	jr z,@dead
	dec a
	jr z,@normalStatus
	call enemyAnimate
	jp ecom_updateKnockback
@dead:
	ld e,$82
	ld a,(de)
	dec a
	jr z,++
	ld e,$a4
	ld a,(de)
	or a
	ld a,$09
	jr z,+
	call enemySetAnimation
	call ecom_killRelatedObj1
+
	jp enemyBoss_dead
++
	ld e,$84
	ld a,(de)
	cp $0a
	jr nz,@normalStatus
	call objectCreatePuff
	jp enemyDelete

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
+
	dec b
	ld a,b
	rst_jumpTable
	.dw @subid1
	.dw @subid2
	
@state0:
	ld a,b
	or a
	jr nz,+
	inc a
	ld (de),a
	ld a,$7c
	ld b,$84
	call enemyBoss_initializeRoom
	jr ++
+
	dec a
	jr nz,+
	ld e,$be
	ld a,$08
	ld (de),a
	ld a,$08
	call enemySetAnimation
+
	call ecom_setSpeedAndState8
++
	jp objectSetVisible82
	
@state1:
	ld e,$86
	ld a,(de)
	or a
	jp nz,enemyDelete
	ld b,$02
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMYID_DIGDOGGER
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,$8b
	ld (hl),$28
	ld l,$8d
	ld (hl),$d8
	ld l,$8f
	ld (hl),$e8
	ld c,h
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	ld l,$8b
	call objectCopyPosition
	ld l,$80
	ld e,l
	ld a,(de)
	ld (hl),a
	ld l,$96
	ld (hl),e
	inc l
	ld (hl),c
	ld l,$b0
	ld (hl),$04
	ld c,h
	pop hl
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),c
	ld e,$86
	ld a,$01
	ld (de),a
	ret
	
@stateStub:
	ret
	
@subid1:
	call func_779b
	ld e,$84
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	
@@state8:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $09
	ret c
	ld a,($cc79)
	or a
	ret z
	bit 1,a
	ret z
	ld bc,$0008
	call enemyBoss_spawnShadow
	ret nz
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$90
	ld (hl),$28
	jp ecom_updateAngleTowardTarget
	
@@state9:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	ld l,$84
	inc (hl)
	ld l,$8f
	ld (hl),$ff
	ret
	
@@stateA:
	call func_7757
	ret c
@@func_742f:
	ld a,($cc79)
	or a
	ret z
	ld e,$a9
	ld a,(de)
	or a
	ret z
	call ecom_updateAngleTowardTarget
	ld a,($cc79)
	bit 1,a
	jr nz,+
	ld e,$89
	ld a,(de)
	xor $10
	ld (de),a
+
	ld h,d
	ld l,$84
	ld (hl),$0b
	ld l,$90
	ld (hl),$50
	ld l,$86
	ld (hl),$00
	scf
	ret
	
@@stateB:
	call func_7757
	jr c,+
	ld e,$a9
	ld a,(de)
	or a
	jr z,+
	ld a,($cc79)
	or a
	jr nz,++
+
	ld h,d
	ld l,$84
	inc (hl)
	jr @toFunc7763
++
	call func_7737
	call func_770e
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr @toFunc7763
	
@@stateC:
	ld h,d
	ld l,$86
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	jr nz,++
+
	ld l,e
	ld (hl),$0a
	ld l,$90
	ld (hl),$00
	ret
++
	call @@func_742f
	ret c
	call func_7740
	call ecom_applyVelocityForSideviewEnemyNoHoles
@toFunc7763:
	jp func_7763
	
@subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD
	.dw @@stateE
	.dw @@stateF
	.dw @@state10
	.dw @@state11
	.dw @@state12
	.dw @@state13
	
@@state8:
	ld a,(wcc93)
	or a
	ret nz
	ld bc,$0208
	call enemyBoss_spawnShadow
	ret nz
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$86
	inc (hl)
	ld l,$b1
	ld (hl),$06
	ld a,$2e
	ld (wActiveMusic),a
	jp playSound
	
@@state9:
	call ecom_decCounter1
	jp nz,enemyAnimate
	inc (hl)
	inc l
	ld (hl),$06
	ld l,e
	inc (hl)
	ld e,$b1
	ld a,(de)
	dec a
	ld hl,@@table_74ed
	rst_addAToHl
	ld e,$90
	ld a,(hl)
	ld (de),a
	ret

@@table_74ed:
	.db $46
	.db $3c
	.db $32
	.db $28
	.db $1e
	.db $1e

@@stateA:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ld l,$94
	ld a,$80
	ldi (hl),a
	ld (hl),$fe
	call ecom_updateAngleTowardTarget
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@@table_7524
	rst_addAToHl
	ld e,$89
	ld a,(de)
	add $02
	and $1c
	add (hl)
	and $1f
	ld (de),a
	ld a,$98
	call playSound
	ld a,$04
	call enemySetAnimation
	jp objectSetVisible81

@@table_7524:
	.db $fc
	.db $00
	.db $04
	.db $10

@@stateB:
	ld c,$0c
	call objectUpdateSpeedZ_paramC
	jp nz,func_76de
	ld a,$85
	call playSound
	call objectSetVisible82
	ld h,d
	ld l,$86
	ld (hl),$10
	inc l
	dec (hl)
	jr z,+
	ld l,$84
	dec (hl)
	ld a,$01
	jp enemySetAnimation
+
	dec l
	ld (hl),$0c
	ld l,$84
	inc (hl)
	ld a,$02
	jp enemySetAnimation
	
@@stateC:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $04
	ret nz
	xor a
	jp enemySetAnimation
+
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$32
	ld bc,$fc00
	call objectSetSpeedZ
	ld a,$98
	call playSound
	call ecom_updateAngleTowardTarget
	call objectSetVisible81
	ld a,$03
	jp enemySetAnimation
	
@@stateD:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ldh a,(<hCameraY)
	ld b,a
	ld l,$8f
	ld e,$8b
	ld a,(de)
	add (hl)
	sub b
	cp $b0
	jp c,func_76bc
	ld l,$84
	inc (hl)
	ld l,$a4
	res 7,(hl)
	ld l,$86
	ld (hl),$3c
	ld l,$8f
	ld (hl),$00
	call objectSetInvisible
	ld e,$b1
	ld a,(de)
	dec a
	ld hl,@@table_75b7
	rst_addDoubleIndex
	ld e,$94
	xor a
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ld e,$87
	ld a,(hl)
	ld (de),a
	ret

@@table_75b7:
	.db $02 $0a
	.db $02 $12
	.db $02 $14
	.db $01 $1c
	.db $01 $1e
	.db $01 $26

@@stateE:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	inc l
	cp (hl)
	ld c,$10
	call c,ecom_setZAboveScreen
	ret nz
	ld l,$8b
	ld a,($d00b)
	and $f0
	add $08
	ldi (hl),a
	inc l
	ld a,($d00d)
	and $f0
	add $08
	ld (hl),a
	ret
+
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$a8
	ld (hl),$f8
	jp objectSetVisible81
	
@@stateF:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,$84
	ld (hl),$09
	ld l,$86
	ld (hl),$77
	ld l,$a8
	ld (hl),$fc
	ld a,$85
	call playSound
	call objectSetVisible82
	xor a
	jp enemySetAnimation
	
@@state10:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$86
	ld (hl),$1e
	ld l,$a4
	res 7,(hl)
	ld l,$8e
	xor a
	ldi (hl),a
	ld (hl),a
	ld l,$ab
	ld (hl),$2d
	ld l,$ad
	ld (hl),$12
	ld a,$05
	jp enemySetAnimation
	
@@state11:
	call ecom_decCounter1
	jp nz,enemyAnimate
	ld e,$b0
	ld a,(de)
	or a
	jr nz,func_76ac
	inc (hl)
	ld l,$b1
	ld b,(hl)
	call checkBEnemySlotsAvailable
	ret nz
	ld e,$97
	ld a,(de)
	ldh (<hFF8B),a
	ld e,$b1
	ld a,(de)
	ld c,a
-
	ld b,ENEMYID_MINI_DIGDOGGER
	call ecom_spawnUncountedEnemyWithSubid01
	call objectCopyPosition
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),d
	ld l,$b1
	ldh a,(<hFF8B)
	ld (hl),a
	ld a,c
	add $b2
	ld e,a
	ld a,h
	ld (de),a
	dec c
	jr nz,-
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$a0
	ld l,$b1
	ldi a,(hl)
	ld (hl),a
	jp objectSetInvisible
	
@@state12:
	ld a,(wFrameCounter)
	and $03
	ret nz
	call ecom_decCounter1
	ret nz
	ld (hl),$19
	ld l,e
	inc (hl)
	call func_76e4
	ld a,$06
	call enemySetAnimation
	jp objectSetVisible82
	
@@state13:
	ld e,$86
	ld a,(de)
	or a
	jr z,+
	dec a
	ld (de),a
	jr nz,+
	ld a,$07
	call enemySetAnimation
+
	ld e,$b2
	ld a,(de)
	or a
	ret nz
	ld a,$c0
	call playSound
	ld h,d
	ld l,$b0
	ld (hl),$04
	
func_76ac:
	ld l,$a4
	set 7,(hl)
	ld l,$84
	ld (hl),$09
	ld l,$86
	ld (hl),$69
	xor a
	jp enemySetAnimation
	
func_76bc:
	ld l,$94
	ldi a,(hl)
	or a
	jr nz,+
	ld a,(hl)
	or a
	jr nz,+
	ld (hl),$02
	ld l,$90
	ld (hl),$14
	ld a,$04
	call enemySetAnimation
+
	ld a,(wFrameCounter)
	and $03
	jr nz,func_76de
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	
func_76de:
	call ecom_bounceOffWallsAndHoles
	jp objectApplySpeed
	
func_76e4:
	ld e,$b2
-
	inc e
	ld a,(de)
	ld h,a
	ld l,$80
	ld a,(hl)
	or a
	jr z,-
	ld e,$b3
	ld b,h
	ld c,$06
-
	ld a,(de)
	ld h,a
	ld l,$80
	ld a,(hl)
	or a
	jr z,+
	ld l,$98
	ld a,$80
	ldi (hl),a
	ld (hl),b
+
	inc e
	dec c
	jr nz,-
	ld h,b
	ld l,$84
	ld (hl),$0c
	jp objectTakePosition
	
func_770e:
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld a,($cc79)
	bit 1,a
	jr z,+
	call objectGetAngleTowardEnemyTarget
	ld b,a
	jr ++
+
	call objectGetAngleTowardEnemyTarget
	xor $10
	ld b,a
++
	ld e,$89
	ld a,(de)
	sub b
	add $02
	cp $05
	ld a,b
	jp nc,objectNudgeAngleTowards
	ld e,$89
	ld (de),a
	ret
	
func_7737:
	ld e,$86
	ld a,(de)
	cp $28
	jr nc,func_7740
	inc a
	ld (de),a

func_7740:
	ld e,$86
	ld a,(de)
	and $38
	rlca
	swap a
	ld hl,table_7751
	rst_addAToHl
	ld e,$90
	ld a,(hl)
	ld (de),a
	ret

table_7751:
	.db $0a $14 $28
	.db $3c $46 $50
	
func_7757:
	xor a
	ld a,($cc79)
	bit 1,a
	ret z
	ld c,$0c
	jp objectCheckLinkWithinDistance
	
func_7763:
	ld e,$90
	ld a,(de)
	cp $3c
	ret c
	ld a,$2b
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret nz
	ld l,$a4
	bit 7,(hl)
	ret z
	ld l,$8f
	ld a,(hl)
	dec a
	cp $f5
	ret c
	call checkObjectsCollided
	ret nc
	ld l,$b0
	dec (hl)
	ld l,$84
	ld (hl),$10
	ld l,$8b
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	push hl
	call objectGetRelativeAngle
	pop hl
	ld l,$ac
	ld (hl),a
	ld a,$63
	jp playSound
	
func_779b:
	ld a,$0b
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	cp (hl)
	jp c,objectSetVisible83
	jp objectSetVisible82


; ==============================================================================
; ENEMYID_MANHANDLA
; ==============================================================================
enemyCode7d:
	jr z,@normalStatus
	sub $03
	ret c
	dec a
	jr z,+
	dec a
	jr z,@normalStatus
	ld e,$82
	ld a,(de)
	dec a
	jp z,enemyBoss_dead
	dec a
	call z,ecom_killRelatedObj1
	jp enemyDie_uncounted
+
	call func_7a44
@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
+
	dec b
	ld a,b
	rst_jumpTable
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6

@state0:
	ld a,b
	or a
	jr nz,+
	ld a,$7d
	ld b,$85
	call enemyBoss_initializeRoom
	jr @state1
+
	dec a
	ld hl,@table_7828
	rst_addAToHl
	ld e,$b0
	ld a,(hl)
	ld (de),a
	call enemySetAnimation
	call ecom_setSpeedAndState8
	ld e,$82
	ld a,(de)
	cp $03
	jr nc,+
	dec a
	jr z,++
	jp objectSetInvisible
+
	call func_7a14
	ld e,$b1
	ld a,$03
	ld (de),a
	ld e,$82
	ld a,(de)
	sub $04
	cp $02
	jp c,objectSetVisible82
++
	jp objectSetVisible83

@table_7828:
	.db $00 $05 $09
	.db $0d $0b $07

@state1:
	ld b,$06
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMYID_MANHANDLA
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,$80
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
	push hl
	ld c,h
	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	call objectCopyPosition
	call func_7a3d
	ld a,h
	ld hl,$ff8a
	ldi (hl),a
	ld a,$04
-
	ldh (<hFF8F),a
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	call func_7a1f
	ld a,h
	pop hl
	ldi (hl),a
	ldh a,(<hFF8F)
	dec a
	jr nz,-
	pop hl
	ld bc,$ff8a
	ld l,$b1
	ld e,$05
-
	ld a,(bc)
	ldi (hl),a
	inc c
	dec e
	jr nz,-
	jp enemyDelete

@stateStub:
	ret

@subid1:
	call func_7ac8
	ld e,$84
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD
	.dw @@stateE
	
@@state8:
	ld a,(wcc93)
	or a
	ret nz
	ld h,d
	ld l,$90
	ld (hl),$0a
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_MANHANDLA_BODY_INVULNERABLE
	ld l,$b6
	ld (hl),$04
	inc l
	ld (hl),$58
	inc l
	ld (hl),$78
	inc l
	ld (hl),$ff
	call @@func_78ce
	ld a,$2e
	ld (wActiveMusic),a
	jp playSound
	
@@state9:
	call ecom_decCounter1
	jr nz,@@bounceAndApplySpeed
	ld (hl),$78
	ld l,e
	inc (hl)
	xor a
	call enemySetAnimation
@@bounceAndApplySpeed:
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed
@@animate:
	jp enemyAnimate
	
@@stateA:
	call ecom_decCounter1
	ret nz
	
@@func_78ce:
	ld l,e
	ld (hl),$09
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@@table_78f6
	rst_addAToHl
	ld e,$86
	ld a,(hl)
	ld (de),a
	ld bc,$5078
	call objectGetRelativeAngle
	push af
	call getRandomNumber_noPreserveVars
	and $01
	pop af
	jr z,+
	sub $02
	and $1f
+
	ld e,$89
	ld (de),a
	jr @@animate

@@table_78f6:
	.db $a0 $b0 $c0 $d0
	.db $d0 $e0 $f0 $00
	
@@stateB:
	call func_7ab4
	jr nc,+
	ld l,e
	inc (hl)
	ld l,$89
	ld (hl),$00
	ld l,$86
	ld (hl),$04
	ld l,$90
	ld (hl),$55
	jr @@animate
+
	call objectGetRelativeAngleWithTempVars
	ld e,$89
	ld (de),a
	jr @@bounceAndApplySpeed
	
@@stateC:
	call ecom_decCounter1
	jr nz,@@bounceAndApplySpeed
	ld (hl),$04
	ld l,$b9
	ld e,$89
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
	or a
	jr nz,@@bounceAndApplySpeed
	ld a,(hl)
	cpl
	inc a
	ld (hl),a
	jr @@bounceAndApplySpeed
	
@@stateD:
	call ecom_decCounter1
	jr nz,@@animateAndUpdateMovingPlatform
	ld (hl),$3c
	ld l,$b0
	ld a,(hl)
	dec a
	ld (hl),a
	jr nz,+
	ld l,$84
	ld (hl),$0b
+
	jp enemySetAnimation
	
@@stateE:
	call ecom_decCounter1
	jr nz,+
	inc (hl)
	ld l,$84
	dec (hl)
	ld l,$a4
	ld (hl),$fd
	ld l,$b0
	dec (hl)
	ld a,(hl)
	call enemySetAnimation
	jp objectSetVisible82
+
	ld a,(hl)
	cp $78
	jr nz,@@animateAndUpdateMovingPlatform
	ld l,$b0
	inc (hl)
	ld a,(hl)
	jp enemySetAnimation
@@animateAndUpdateMovingPlatform:
	call enemyAnimate
	jp ecom_updateMovingPlatform

@subid2:
	call func_7ad6
	ld e,$84
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @@stateA

@@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$a4
	res 7,(hl)
	inc l
	ld (hl),$63
	ret

@@state9:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	ret nz
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$8f
	ld (hl),$f9
	ld l,$94
	xor a
	ldi (hl),a
	ld (hl),a
	call objectSetVisible81
	ld a,$05
	jp enemySetAnimation

@@stateA:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0d
	jr nz,+
	ld h,d
	ld l,$84
	dec (hl)
	ld l,$a4
	res 7,(hl)
	jp objectSetInvisible
+
	ld l,$86
	ld a,(hl)
	cp $78
	ret nc
	add $03
	and $0c
	rrca
	rrca
	ld hl,@@table_79d9
	rst_addAToHl
	ld e,$8d
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@@table_79d9:
	.db $00 $02 $00 $fe

@subid3:
@subid4:
@subid5:
@subid6:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	
@@state8:
	call ecom_decCounter1
	jr nz,@@toFunc7ad6
	call func_7b1c
	jr c,@@toFunc7ad6
--
	call getRandomNumber_noPreserveVars
	and $50
	add $5a
	ld e,$86
	ld (de),a
@@toFunc7ad6:
	jp func_7ad6
	
@@state9:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $5a
	jr nz,@@toFunc7ad6
	ld b,PARTID_GOPONGA_PROJECTILE
	call ecom_spawnProjectile
	jr @@toFunc7ad6
+
	ld l,$b0
	dec (hl)
	ld a,(hl)
	call enemySetAnimation

func_7a14:
	ld h,d
	ld l,$84
	ld (hl),$08
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_TWINROVA
	jr --

func_7a1f:
	push bc
	push hl
	ldh a,(<hFF8F)
	ld b,a
	ld a,$07
	sub b
	ld (hl),a
	call func_7af2
	ld e,$8b
	ld a,(de)
	add (hl)
	ld b,a
	inc hl
	ld e,$8d
	ld a,(de)
	add (hl)
	ld c,a
	pop hl
	ld l,e
	ld (hl),c
	ld l,$8b
	ld (hl),b
	pop bc

func_7a3d:
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),c
	ret

func_7a44:
	ld h,d
	ld l,$aa
	ld e,$82
	ld a,(de)
	dec a
	jr z,func_7a70
	dec a
	ret z
	ld l,$a9
	ld a,(hl)
	or a
	ret nz
	ld a,$36
	call objectGetRelatedObject1Var
	dec (hl)
	jr z,func_7a63
	ld l,$90
	ld a,(hl)
	add $14
	ld (hl),a
	ret
	
func_7a63:
	ld l,$84
	ld (hl),$0b
	ld l,$90
	ld (hl),$50
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_MANHANDLA_BODY_VULNERABLE
	ret
	
func_7a70:
	ld l,$aa
	ld a,(hl)
	cp $a0
	jr nz,+
	ld l,$ba
	ld (hl),$3c
+
	ld l,$a9
	ld (hl),$40
	ld l,$b6
	ld a,(hl)
	or a
	ret nz
	ld l,$aa
	ld a,(hl)
	cp $96
	ret nz
	ld l,$b0
	ld a,(hl)
	inc a
	cp $03
	ld (hl),a
	jr nc,func_7aa1
	ld l,$86
	ld (hl),$3c
	ld l,$84
	ld (hl),$0d
	call enemySetAnimation
	jp objectSetVisible81
	
func_7aa1:
	ld (hl),$03
	ld l,$84
	ld (hl),$0e
	ld l,$86
	ld (hl),$b4
	ld l,$a4
	ld (hl),$a9
	ld a,$03
	jp enemySetAnimation
	
func_7ab4:
	ld h,d
	ld l,$b7
	call ecom_readPositionVars
	sub c
	add $04
	cp $09
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	ret

func_7ac8:
	ld h,d
	ld l,$ba
	ld a,(hl)
	or a
	ret z
	pop bc
	dec (hl)
	ret nz
	ld l,$a4
	set 7,(hl)
	ret

func_7ad6:
	ld a,$0b
	call objectGetRelatedObject1Var
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	ld l,$a1
	ld e,$82
	ld a,(de)
	call func_7af2
	ld e,$8b
	ldi a,(hl)
	add b
	ld (de),a
	ld e,$8d
	ld a,(hl)
	add c
	ld (de),a
	ret
	
func_7af2:
	sub $02
	ld e,a
	add a
	add e
	add a
	add (hl)
	ld hl,table_7afe
	rst_addAToHl
	ret

table_7afe:
	.db $0a $00 $0a $00 $0a $00 ; subid2
	.db $f0 $0a $f2 $0a $f1 $0a ; subid3
	.db $00 $0b $02 $0b $01 $0b ; subid4
	.db $00 $f5 $01 $f5 $02 $f5 ; subid5
	.db $f0 $f6 $f1 $f6 $f2 $f6 ; subid6

func_7b1c:
	call objectGetAngleTowardEnemyTarget ; $7b1c
	ld b,a
	ld e,$82
	ld a,(de)
	sub $03
	swap a
	rrca
	sub b
	cp $f8
	ret nc
	ld h,d
	ld l,$84
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_MANHANDLA_HEAD_VULNERABLE
	ld l,$86
	ld (hl),$78
	ld l,$b0
	inc (hl)
	ld a,(hl)
	call enemySetAnimation
	scf
	ret

; ==============================================================================
; ENEMYID_MEDUSA_HEAD
; ==============================================================================
enemyCode7f:
	jr z,@normalStatus
	sub $03
	jr c,+
	jp z,enemyBoss_dead
	dec a
	jr z,@justHit
+
	ld h,d
	ld l,$ad
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ld l,$a1
	bit 0,(hl)
	jr z,+
	ld l,$a0
	ld (hl),$01
	call enemyAnimate
+
	jp ecom_updateKnockback
@justHit:
	ld h,d
	ld l,$aa
	ld a,(hl)
	res 7,a
	sub $04
	jr c,@normalStatus
	sub $06
	jr nc,+
	ld l,$b0
	ld (hl),$01
	ld l,$ae
	ld (hl),$00
	ret
+
	sub $13
	jr nz,+
	ld l,$ad
	ld (hl),$0d
	inc l
	ld (hl),$2d
	call objectGetAngleTowardEnemyTarget
	xor $10
	ld e,$ac
	ld (de),a
	ld a,$4e
	jp playSound
+
	ld l,$ae
	ld a,(hl)
	or a
	ret nz

@normalStatus:
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC

@state0:
	ld e,$82
	ld a,(de)
	or a
	ld a,$3c
	jp nz,ecom_setSpeedAndState8
	ld a,$7f
	ld b,$88
	call enemyBoss_initializeRoom
	ld e,$84
	ld a,$01
	ld (de),a
	ret

@state1:
	ld a,(wcc93)
	or a
	ret nz
	ld b,$04
	call checkBEnemySlotsAvailable
	ret nz
	ldbc ENEMYID_MEDUSA_HEAD $04
-
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),c
	ld a,c
	dec a
	ld e,a
	add a
	add e
	ld de,@table_7c04
	call addAToDe
	ld l,$8b
	ld a,(de)
	ldi (hl),a
	inc de
	inc l
	ld a,(de)
	ld (hl),a
	inc de
	ld l,$89
	ld a,(de)
	ld (hl),a
	dec c
	jr nz,-
	ldh a,(<hActiveObject)
	ld d,a
	ld l,$80
	ld e,l
	ld a,(de)
	ld (hl),a
	jp enemyDelete

@table_7c04:
	.db $08 $78 $00
	.db $58 $d8 $08
	.db $a8 $78 $10
	.db $58 $18 $18

@stateStub:
	ret

@state8:
	inc e
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$70
	ld l,$8f
	ld (hl),$fe
	ld l,$82
	ld a,(hl)
	dec a
	ld a,$8d
	call z,playSound
+
	call ecom_flickerVisibility
	ld a,(wFrameCounter)
	rrca
	ret c
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	ld e,$89
	ld bc,$5878
	call objectSetPositionInCircleArc
	ld e,$89
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	ret
+
	ld e,$82
	ld a,(de)
	dec a
	jp nz,enemyDelete
	ld (hl),$1e
	ld l,$84
	inc (hl)
	call objectSetVisible83
	ld a,$73
	call playSound
	ld a,$2e
	ld (wActiveMusic),a
	jp playSound

@state9:
	call ecom_decCounter1
	ret nz
	inc (hl)
	ld bc,$020b
	call enemyBoss_spawnShadow
	ret nz
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$00
	ld l,$a4
	set 7,(hl)
	ret

@stateA:
	inc e
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
	ld (hl),$b4
	inc l
	ld (hl),$5a
	ld l,$90
	ld (hl),$46
	ld l,$b4
	ld (hl),$08
	ld l,$b0
	ld (hl),$00
	ld l,$b6
	ld a,(hl)
	ld (hl),$00
	or a
	jr z,@@animate
	ld b,PARTID_S_46
	call ecom_spawnProjectile
	ld a,$01
	jp enemySetAnimation
	
@@substate1:
	ld c,$40
	call objectCheckLinkWithinDistance
	jr c,+
	call ecom_updateAngleTowardTarget
	call objectApplySpeed
	jr @@animate
+
	ld e,$85
	ld a,$02
	ld (de),a
@@animate:
	jp enemyAnimate
	
@@substate2:
	call func_7e84
	jr nz,+
	ld l,e
	inc (hl)
	jr @@animate
+
	call func_7ece
	jr nz,@@animate
	call ecom_decCounter1
	call z,func_7eb5
	call objectGetAngleTowardEnemyTarget
	ld c,a
	ld e,$b4
	ld a,(de)
	add c
	and $1f
	ld e,$89
	ld (de),a
	call func_7e8d
	call ecom_applyVelocityForTopDownEnemyNoHoles
	jr nz,@@animate
	ld e,$b4
	ld a,(de)
	cpl
	inc a
	ld (de),a
	ld a,$c9
	call playSound
	jr @@animate
	
@@substate3:
	ld h,d
	ld l,e
	ld (hl),$00
	dec l
	inc (hl)
	call getRandomNumber
	cp $60
	ret nc
	inc (hl)
	ret

@stateB:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	
@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$1e
	ld l,$a4
	res 7,(hl)
	
@@substate1:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$14
	ld l,e
	inc (hl)
	ld l,$8f
	ld (hl),$00
	ld l,$8d
	ld a,(hl)
	cp $78
	ld c,$20
	ld a,$d4
	jr c,+
	ld c,a
	ld a,$1c
+
	ld (hl),c
	ld l,$b2
	ldd (hl),a
	ld (hl),$20
	ld l,$8b
	ld (hl),$20
	jp objectSetInvisible
	
@@substate2:
	call ecom_decCounter1
	ret nz
	ld (hl),$1e
	ld l,e
	inc (hl)
	ld l,$8f
	ld (hl),$fe
	ret
	
@@substate3:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$0f
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	jp objectSetVisible83
	
@@substate4:
	call ecom_decCounter1
	jr nz,@@animate
	ld (hl),$05
	ld l,e
	inc (hl)
	ld b,PARTID_S_45
	call ecom_spawnProjectile
	ld a,$02
	jp enemySetAnimation
	
@@substate5:
	call ecom_decCounter1
	jr nz,@@playSoundAndAnimate
	ld l,e
	inc (hl)
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,table_7edf
	rst_addAToHl
	ld e,$90
	ld a,(hl)
	ld (de),a
	
@@substate6:
	ld h,d
	ld l,$b1
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	jr nc,+
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jr nc,+
	ld l,$85
	inc (hl)
	inc l
	ld (hl),$08
	xor a
	jp enemySetAnimation
+
	call ecom_moveTowardPosition
@@playSoundAndAnimate:
	ld a,(wFrameCounter)
	and $07
	ld a,$a8
	call z,playSound
@@animate:
	jp enemyAnimate
	
@@substate7:
	call ecom_decCounter1
	jr nz,@@playSoundAndAnimate
	ld l,e
	xor a
	ldd (hl),a
	inc (hl)
	call ecom_killRelatedObj2
	jr @@animate

@stateC:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	.dw @@substate8
	
@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$1e
	ld l,$a4
	res 7,(hl)
	jr @@animate
	
@@substate1:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$14
	ld l,e
	inc (hl)
	ld l,$8f
	ld (hl),$00
	jp objectSetInvisible
	
@@substate2:
	call ecom_decCounter1
	ret nz
	ld (hl),$1e
	ld l,e
	inc (hl)
	ld l,$8b
	ld (hl),$58
	ld l,$8d
	ld (hl),$78
	ld l,$8f
	ld (hl),$fe
	
@@substate3:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$14
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	call objectSetVisible83
@@animate:
	jp enemyAnimate
	
@@substate4:
	call ecom_decCounter1
	jr nz,@@animate
	ld (hl),$14
	ld l,e
	inc (hl)
	ld a,$04
	jp enemySetAnimation
	
@@substate5:
	call ecom_decCounter1
	jr nz,@@animate
	ld (hl),$20
	ld l,e
	inc (hl)
	ld a,$d2
	call playSound
	jr @@animate
	
@@substate6:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	rrca
	jr nc,@@animate
	ld b,PARTID_44
	call ecom_spawnProjectile
	jr nz,@@animate
	ld e,$86
	ld a,(de)
	dec a
	rrca
	ld l,$c2
	ld (hl),a
	jr @@animate
+
	ld (hl),$0c
	ld l,e
	inc (hl)
	jr @@animate
	
@@substate7:
	call ecom_decCounter1
	jr nz,@@animate
	ld (hl),$0f
	ld l,e
	inc (hl)
	ld a,$03
	jp enemySetAnimation
	
@@substate8:
	call ecom_decCounter1
	jp nz,@@animate
	ld l,e
	xor a
	ldd (hl),a
	ld (hl),$0a
	jp enemySetAnimation
	
func_7e84:
	ld a,(wFrameCounter)
	and $07
	ret nz
	jp ecom_decCounter2
	
func_7e8d:
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
	and $f0
	cp $50
	ret z
	cp $40
	ret z
	jr nc,+
	ld a,c
	xor $10
	ld c,a
+
	ld b,$1e
	jp ecom_applyGivenVelocity
	
func_7eb5:
	ld (hl),$3c
	inc l
	ldd a,(hl)
	cp $0f
	ret c
	call getRandomNumber
	cp $60
	ret nc
	ld (hl),$5a
	ld b,PARTID_S_46
	call ecom_spawnProjectile
	ld a,$01
	jp enemySetAnimation
	
func_7ece:
	ld h,d
	ld l,$a1
	ld a,(hl)
	dec a
	ret z
	ld l,$b0
	bit 0,(hl)
	ret z
	ld (hl),$00
	ld l,$85
	inc (hl)
	ret

table_7edf:
	.db $5a
	.db $64
	.db $6e
	.db $78
