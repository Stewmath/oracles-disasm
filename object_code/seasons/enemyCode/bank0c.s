; ==============================================================================
; ENEMYID_ROLLING_SPIKE_TRAP
; ==============================================================================
enemyCode0f:
	dec a
	ret z
	dec a
	ret z
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state00
	.dw @state01
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
+
	ld a,b
	sub $08
	rst_jumpTable
	.dw @state08
	.dw @state09

@state00:
	ld e,Enemy.var3e
	ld a,$08
	ld (de),a
	ld a,b
	sub $08
	jp nc,seasonsFunc_0c_68d6
	ld e,Enemy.state
	ld a,$01
	ld (de),a

@state01:
	ld a,b
	ld hl,@seasonsTable_0c_686e
	rst_addAToHl
	ld b,(hl)
	call checkBEnemySlotsAvailable
	ret nz
	call copyVar03ToVar30
	ld b,ENEMYID_ROLLING_SPIKE_TRAP
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$08
	call seasonsFunc_0c_68c8
	call seasonsFunc_0c_68fa
	call seasonsFunc_0c_6992
	jp enemyDelete

@seasonsTable_0c_686e:
	.db $03 $03 $03 $04 $04 $04 $05 $05

@state_stub:
	ret

@state08:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	call seasonsFunc_0c_699d
	ld l,$84
	inc (hl)
	call seasonsFunc_0c_69b4
	ld e,Enemy.var31
	ld a,(de)
	ld e,$99
	ld (de),a
	dec e
	ld a,$80
	ld (de),a

@@substate1:
	call seasonsFunc_0c_69c9
	call seasonsFunc_0c_69d2
	ret z
	jp seasonsFunc_0c_69fd

@state09:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.angle
	ld (hl),$08
	ld l,$b0
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	jr ++

@@substate1:
	call ecom_decCounter1
	jr nz,+
	ld e,Enemy.var30
	ld a,(de)
	ld (hl),a
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
+
	call objectApplySpeed
++
	jp enemyAnimate

seasonsFunc_0c_68c8:
	ld e,Enemy.var30
	ld l,e
	ld a,(de)
	ld (hl),a
	ld e,Enemy.subid
	ld l,Enemy.var03
	ld a,(de)
	ld (hl),a
	jp objectCopyPosition

seasonsFunc_0c_68d6:
	jr z,+
	ld e,Enemy.var31
	ld a,(de)
	ld c,a
	ld hl,seasonsTable_0c_68ed
	rst_addAToHl
	ld e,Enemy.collisionRadiusY
	ld a,(hl)
	ld (de),a
	ld a,c
	call enemySetAnimation
	ld a,$1e
+
	jp ecom_setSpeedAndState8

seasonsTable_0c_68ed:
	.db $06 $06 $0e $16 $19

copyVar03ToVar30:
	ld h,d
	ld l,Enemy.var03
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a
	ret

seasonsFunc_0c_68fa:
	push hl
	ld c,h
	ld e,Enemy.subid
	ld a,(de)
	ld hl,seasonsTable_0c_694c
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,Enemy.var30
-
	push hl
	inc e
	push de
	call seasonsFunc_0c_6925
	push bc
	ld b,ENEMYID_ROLLING_SPIKE_TRAP
	call ecom_spawnEnemyWithSubid01
	ld (hl),$09
	pop bc
	ld a,e
	pop de
	call seasonsFunc_0c_692f
	pop hl
	inc hl
	inc hl
	ld a,(hl)
	inc a
	jr nz,-
	pop hl
	ret

seasonsFunc_0c_6925:
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld b,a
	ld e,c
	inc hl
	ld c,(hl)
	inc hl
	ret

seasonsFunc_0c_692f:
	push de
	ld l,$97
	ldd (hl),a
	ld (hl),$80
	ld a,h
	ld (de),a
	ld l,Enemy.xh
	ld e,l
	ld a,(de)
	ldd (hl),a
	dec l
	ld (hl),b
	ld d,h
	ld e,l
	ld a,c
	ld e,Enemy.var31
	ld (de),a
	call enemySetAnimation
	call objectSetVisible82
	pop de
	ret

seasonsTable_0c_694c:
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7

@subid0: ; $695c
	.db $f8 $00
	.db $08 $01
	.db $ff
@subid1: ; $6961
	.db $f8 $02
	.db $10 $01
	.db $ff
@subid2: ; $6966
	.db $f8 $03
	.db $18 $01
	.db $ff
@subid3: ; $696b
	.db $e0 $00
	.db $00 $04
	.db $20 $01
	.db $ff ;
@subid4: ; $6972
	.db $e0 $02
	.db $08 $04
	.db $28 $01
	.db $ff
@subid5: ; $6979
	.db $e0 $03
	.db $10 $04
	.db $30 $01
	.db $ff
@subid6: ; $6980
	.db $c8 $00
	.db $e8 $04
	.db $18 $04
	.db $38 $01
	.db $ff
@subid7: ; $6989
	.db $c8 $02
	.db $f0 $04
	.db $20 $04
	.db $40 $01
	.db $ff

seasonsFunc_0c_6992:
	ld b,$04
	ld l,Enemy.var31
-
	ld e,l
	ld a,(de)
	ldi (hl),a
	dec b
	jr nz,-
	ret

seasonsFunc_0c_699d:
	ld h,d
	ld e,Enemy.var30
	ld l,Enemy.var31
-
	ldi a,(hl)
	ld b,a
	ld c,$81
	ld a,(bc)
	cp $0f
	jr nz,+
	ld c,e
	ld a,(de)
	ld (bc),a
+
	ld a,$b5
	cp l
	jr nz,-
	ret

seasonsFunc_0c_69b4:
	ld e,Enemy.var03
	ld a,(de)
	ld hl,seasonsTable_0c_69c1
	rst_addAToHl
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

seasonsTable_0c_69c1:
	.db $f8 $f0 $e8 $e0 $d8 $d0 $c8 $c0

seasonsFunc_0c_69c9:
	ld a,$0d
	call objectGetRelatedObject2Var
	ld e,l
	ld a,(hl)
	ld (de),a
	ret

seasonsFunc_0c_69d2:
	ld a,$09
	call objectGetRelatedObject2Var
	ld c,$f7
	bit 4,(hl)
	jr nz,+
	ld c,$08
+
	ld e,Enemy.xh
	ld a,(de)
	add c
	ld c,a
	ld e,Enemy.yh
	ld a,(de)
	ld b,a
	ld e,Enemy.var03
	ld a,(de)
	add $02
	ld e,a
-
	call getTileCollisionsAtPosition
	dec a
	cp $0f
	ret c
	ld a,b
	add $10
	ld b,a
	dec e
	jr nz,-
	ret

seasonsFunc_0c_69fd:
	ld h,d
	ld l,Enemy.var31
-
	ldi a,(hl)
	ld b,a
	ld c,$81
	ld a,(bc)
	cp $0f
	jr nz,+
	ld c,$86
	ld a,$01
	ld (bc),a
+
	ld a,$b5
	cp l
	jr nz,-
	ret


; ==============================================================================
; ENEMYID_POKEY
; ==============================================================================
enemyCode11:
	jr z,++
	sub $03
	ret c
	jr nz,+
	ld e,Enemy.var03
	ld a,(de)
	cp $03
	jp nz,pokeyFunc_0c_6ba8
	call ecom_killRelatedObj1
	ld l,$b3
	ld (hl),$00
	ld l,$b1
	push hl
	ld h,(hl)
	call ecom_killObjectH
	pop hl
	inc l
	ld h,(hl)
	call ecom_killObjectH
	jp enemyDie
+
	ld e,Enemy.var2a
	ld a,(de)
	cp $9a
	call z,pokeyFunc_0c_6bfe
	call pokeyFunc_0c_6c3e
	ld e,Enemy.collisionType
	ld a,(de)
	rlca
	ret nc
++
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw pokey_state_0
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
+
	ld e,Enemy.var03
	ld a,(de)
	or a
	call z,ecom_decCounter1
	ld a,$33
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret z
	dec b
	ld a,b
	rst_jumpTable
	.dw pokey_6b05
	.dw pokey_6b2e
	.dw pokey_6b35
	.dw pokey_6b3c
	.dw pokey_state_stub

pokey_state_0:
	ld a,b
	or a
	jr nz,+
	ld b,$04
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMYID_POKEY
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$05
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),h
	call objectCopyPosition
	ld l,$b0
	ld (hl),h
	ld c,h
	ld e,$03
	inc l
-
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	ld a,$04
	sub e
	ld (hl),a
	inc l
	ld (hl),a
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),c
	push de
	call objectCopyPosition
	pop de
	ld a,h
	pop hl
	ldi (hl),a
	dec e
	jr nz,-
	ld h,a
	ld l,$80
	ld e,l
	ld a,(de)
	ld (hl),a
	jp enemyDelete
+
	cp $03
	ld a,$01
	call nz,enemySetAnimation
	ld a,$0f
	call ecom_setSpeedAndState8
	ld l,$bf
	set 5,(hl)
	ld l,$82
	ld a,(hl)
	cp $05
	jr z,+++
	ld b,a
	ld a,$30
	call objectGetRelatedObject1Var
	ld e,l
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	dec b
	jr z,++
	dec b
	ld a,$f3
	jr z,+
	add a
+
	ld e,$8f
	ld (de),a
++
	jp objectSetVisible82
+++
	ld l,$a4
	res 7,(hl)
	call getRandomNumber_noPreserveVars
	ld e,$86
	ld (de),a
	ret

pokey_state_stub:
	ret

pokey_6b05:
	ld e,$8f
	ld a,(de)
	or a
	jr z,+
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jp nz,objectSetVisiblec2
	ld l,$94
	xor a
	ldi (hl),a
	ld (hl),a
+
	ld a,$10
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(hl)
	ld (de),a
	ld l,$86
	ld a,(hl)
	and $3f
	call z,ecom_setRandomAngle
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp objectSetPriorityRelativeToLink

pokey_6b2e:
	ld b,$f3
	call pokeyFunc_0c_6b8e
	jr +

pokey_6b35:
	ld b,$e6
	call pokeyFunc_0c_6b8e
	jr +

pokey_6b3c:
	ld b,$d9
	call pokeyFunc_0c_6b8e

+
	ld a,$06
	call objectGetRelatedObject1Var
	ld a,(hl)
	and $1c
	rrca
	rrca
	ld b,a
	ld e,$82
	ld a,(de)
	sub $02
	swap a
	rrca
	add b
	ld hl,pokeyTable_0c_6b6a
	rst_addAToHl
	ld b,(hl)
	call pokeyFunc_0c_6b82
	ld l,$8b
	ld e,l
	ldi a,(hl)
	ld (de),a
	inc l
	ld e,l
	ld a,(hl)
	add b
	ld (de),a
	jp objectSetPriorityRelativeToLink

pokeyTable_0c_6b6a:
	.db $ff $ff $00 $00 $01 $01 $00 $00
	.db $01 $02 $01 $00 $ff $fe $ff $00
	.db $ff $fe $ff $00 $01 $02 $01 $00

pokeyFunc_0c_6b82:
	ld e,$af
	ld l,$82
-
	inc e
	ld a,(de)
	ld h,a
	ld a,(hl)
	dec a
	jr nz,-
	ret
pokeyFunc_0c_6b8e:
	ld h,d
	ld l,$8f
	ld a,(hl)
	cp b
	ret z
	or a
	jr z,+
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ld l,$8f
	ld a,(hl)
	cp b
	ret c
+
	ld (hl),b
	ld l,$94
	xor a
	ldi (hl),a
	ld (hl),a
	ret

pokeyFunc_0c_6ba8:
	ld a,$33
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,+
	ld e,$82
	ld a,(de)
	cp $05
	jp nz,enemyDie_uncounted_withoutItemDrop
	jp enemyDelete
+
	ld e,$83
	ld a,(de)
	add $b1
	ld l,a
	ld h,d
	ld c,$82
	sub $b3
	jr z,+
	inc a
	call nz,pokeyFunc_0c_6bf5
	call pokeyFunc_0c_6bf5
+
	call pokeyFunc_0c_6bf5
	ld l,$a4
	res 7,(hl)
	ld l,$a9
	ld (hl),$05
	ld l,$82
	ld (hl),$05
	ld b,$02
	call ecom_spawnProjectile
	jr nz,+
	ld l,$c7
	ld (hl),$80
	ld a,$73
	call playSound
+
	call objectSetInvisible
	jp pokeyFunc_0c_6c3e

pokeyFunc_0c_6bf5:
	ld b,(hl)
	inc l
	ld a,(bc)
	cp $05
	ret nc
	dec a
	ld (bc),a
	ret

pokeyFunc_0c_6bfe:
	ld h,d
	ld l,$b3
	ld c,$82
	ld b,(hl)
-
	ld a,(bc)
	ld e,a
	dec l
	ld a,$af
	cp l
	ret nc
	ld b,(hl)
	ld a,(bc)
	cp $05
	jr nz,-
	ld h,e
	push hl
	call pokeyFunc_0c_6b82
	ld l,$8b
	ld c,l
	ldi a,(hl)
	ld (bc),a
	inc l
	ld c,l
	ld a,(hl)
	ld (bc),a
	ld c,$8f
	xor a
	ld (bc),a
	ld c,$a4
	ld a,(bc)
	or $80
	ld (bc),a
	pop hl
	ld c,$82
	ld a,h
	ld (bc),a
	ld h,d
-
	inc l
	ld a,$b3
	cp l
	ret c
	ld b,(hl)
	ld a,(bc)
	cp $05
	jr z,-
	inc a
	ld (bc),a
	jr -

pokeyFunc_0c_6c3e:
	ld bc,$0404
	ld l,$82
	ld e,$b4
-
	dec e
	ld a,(de)
	ld h,a
	ld a,(hl)
	cp $05
	jr z,+
	dec b
+
	dec c
	jr nz,-
	ld a,b
	ld bc,pokeyTable_0c_6c5d
	call addAToBc
	ld l,$90
	ld a,(bc)
	ld (hl),a
	ret

pokeyTable_0c_6c5d:
	.db $0a $0f $1e $3c


; ==============================================================================
; ENEMYID_IRON_MASK
; ==============================================================================
enemyCode1c:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards

	ld e,Enemy.subid
	ld a,(de)
	or a
	ret z
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz
	jp enemyDelete

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,+

@commonState:
	rst_jumpTable
	.dw ironMask_state_uninitialized
	.dw ironMask_state_stub
	.dw ironMask_state_stub
	.dw ironMask_state_stub
	.dw ironMask_state_stub
	.dw ecom_blownByGaleSeedState
	.dw ironMask_state_stub
	.dw ironMask_state_stub

+
	ld a,b
	rst_jumpTable
	.dw ironMask_subid00
	.dw ironMask_subid01

ironMask_state_uninitialized:
	bit 0,b
	jp nz,ecom_setSpeedAndState8
	ld a,$14
	call ecom_setSpeedAndState8AndVisible
	ld l,Enemy.counter1
	inc (hl)
	ret


ironMask_state_stub:
	ret


; Iron mask with mask on
ironMask_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA


; Standing in place
@state8:
	call ironMask_magnetGloveCheck
	call ecom_decCounter1
	jp nz,ironMask_updateCollisionsFromLinkRelativeAngle
	ld l,Enemy.state
	inc (hl)
	call ironMask_chooseRandomAngleAndCounter1

; Moving in some direction for [counter1] frames
@state9:
	call ironMask_magnetGloveCheck
	call ecom_decCounter1
	jr nz,+
	ld l,Enemy.state
	dec (hl)
	call ironMask_chooseAmountOfTimeToStand
+
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call ironMask_updateCollisionsFromLinkRelativeAngle
	jp enemyAnimate

; Maskless
@stateA:
	call ecom_decCounter1
	call z,ironMask_chooseRandomAngleAndCounter1
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate


; Detached "mask"
ironMask_subid01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_200
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_IRON_MASK_DETACHED
	ld a,$05
	call enemySetAnimation
	call objectSetVisible82

@state9:
	ld a,(wMagnetGloveState)
	or a
	jr z,+
	call ecom_updateAngleTowardTarget
	jp objectApplySpeed
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),30

@stateA:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	jp enemyDelete


;;
; Modifies this object's enemyCollisionMode based on if Link is directly behind the iron
; mask or not.
ironMask_updateCollisionsFromLinkRelativeAngle:
	call objectGetAngleTowardEnemyTarget
	ld h,d
	ld l,Enemy.angle
	sub (hl)
	and $1f
	sub $0c
	cp $09
	ld l,Enemy.enemyCollisionMode
	jr c,++
	ld (hl),ENEMYCOLLISION_IRON_MASK
	ret
++
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK
	ret


;;
ironMask_chooseRandomAngleAndCounter1:
	ld bc,$0703
	call ecom_randomBitwiseAndBCE
	ld a,b
	ld hl,@counter1Vals
	rst_addAToHl

	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	ld e,Enemy.state
	ld a,(de)
	cp $0a
	jp z,ecom_setRandomCardinalAngle

	; 1 in 4 chance of turning directly toward Link, otherwise just choose a random angle
	call @chooseAngle
	swap a
	rlca
	ld h,d
	ld l,Enemy.var31
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation

@chooseAngle:
	ld a,c
	or a
	jp z,ecom_updateCardinalAngleTowardTarget
	jp ecom_setRandomCardinalAngle

@counter1Vals:
	.db 25, 30, 35, 40, 45, 50, 55, 60


;;
ironMask_chooseAmountOfTimeToStand:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db 15, 30, 45, 60


ironMask_magnetGloveCheck:
	ld a,(wMagnetGloveState)
	or a
	jr z,+
	ld c,$40
	call objectCheckLinkWithinDistance
	jr nc,+
	rrca
	xor $02
	ld b,a
	ld a,(w1Link.direction)
	cp b
	jr z,++
+
	ld e,Enemy.var32
	ld a,$3c
	ld (de),a
	ret
++
	pop hl
	ld h,d
	ld l,Enemy.var32
	dec (hl)
	jr z,++
	ld a,(hl)
	and $03
	sub $01
	jr nc,+
	cpl
	inc a
+
	dec a
	bit 0,b
	jr z,+
	ld l,Enemy.xh
	add (hl)
	ld (hl),a
	ret
+
	ld l,Enemy.yh
	add (hl)
	ld (hl),a
	ret
++
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK
	ld a,$04
	call enemySetAnimation
	ld b,ENEMYID_IRON_MASK
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz
	jp objectCopyPosition
	jr z,+
	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback
	ret
+
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @enemyDelete
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret

@enemyDelete:
	jp enemyDelete

@ret:
	ret

	; left over
	jp enemyDelete
