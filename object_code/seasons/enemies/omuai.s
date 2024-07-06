; ==================================================================================================
; ENEMY_OMUAI
; ==================================================================================================
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
	ld b,INTERAC_SPLASH
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
	ld (hl),INTERAC_SPLASH
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
	ld b,PART_GOPONGA_PROJECTILE
	call ecom_spawnProjectile
	ret nz
	ld l,$c2
	inc (hl)
	ld l,$cb
	ld a,(hl)
	sub $04
	ld (hl),a
	ret
