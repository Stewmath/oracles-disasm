; ==============================================================================
; ENEMYID_MAGUNESU
; ==============================================================================
enemyCode3c:
	jr z,+
	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback
	ret
+
	call magunesuFunc_0d_6ccd
	call magunesuFunc_0d_6ce6
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

@state0:
	call magunesuFunc_0d_6d06
	ld a,$14
	call ecom_setSpeedAndState8AndVisible
	jr @magunesuFunc_0d_6c54

@state_stub:
	ret

@state8:
	call magunesuFunc_0d_6d18
	call ecom_decCounter1
	jp nz,ecom_applyVelocityForTopDownEnemy
	ld l,Enemy.state
	inc (hl)
	ld a,$01
	jp enemySetAnimation

@state9:
	call enemyAnimate
	ld e,$a1
	ld a,(de)
	or a
	ret z
	dec a
	ld a,$05
	jp nz,magunesuFunc_0d_6ca9
	ld h,d
	ld l,$83
	ld (hl),$02
	ld l,$9b
	ld a,$02
	ldi (hl),a
	ld (hl),a
	ret

@stateA:
	call magunesuFunc_0d_6cb7
	ret nz
	ld l,e
	inc (hl)
	call magunesuFunc_0d_6d06
	ld a,$03
	jp enemySetAnimation

@stateB:
	call magunesuFunc_0d_6d18
	call ecom_decCounter1
	jp nz,ecom_applyVelocityForTopDownEnemy
	ld l,$84
	inc (hl)
	ld a,$04
	jp enemySetAnimation

@stateC:
	call enemyAnimate
	ld e,$a1
	ld a,(de)
	or a
	ret z
	dec a
	ld a,$02
	jr nz,magunesuFunc_0d_6ca9

@magunesuFunc_0d_6c54:
	ld h,d
	ld l,$83
	ld (hl),$00
	ld l,$9b
	ld a,$01
	ldi (hl),a
	ld (hl),a
	ret

@stateD:
	call magunesuFunc_0d_6cb7
	ret nz
	ld l,e
	ld (hl),$08
	call magunesuFunc_0d_6d06
	xor a
	jp enemySetAnimation

@stateE:
	call ecom_decCounter2
	jr nz,+
	ld l,$90
	ld (hl),$14
	ld l,e
	ld e,$83
	ld a,(de)
	or a
	ld (hl),$08
	ret z
	ld (hl),$0b
	ret
+
	call ecom_applyVelocityForTopDownEnemy
	ret nz
	call objectGetAngleTowardEnemyTarget
	xor $10
	ld h,d
	ld l,$89
	sub (hl)
	and $1f
	bit 4,a
	ld a,$08
	jr z,+
	ld a,$f8
+
	add (hl)
	and $18
	ld (hl),a
	xor a
	call ecom_getTopDownAdjacentWallsBitset
	ret z
	ld e,$89
	ld a,(de)
	xor $10
	ld (de),a
	ret

magunesuFunc_0d_6ca9:
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$1e
	call enemySetAnimation
	jp ecom_setRandomCardinalAngle

magunesuFunc_0d_6cb7:
	call ecom_decCounter1
	ret z
	ld a,(hl)
	cp $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_GOPONGA_PROJECTILE
	ld bc,$0400
	call objectCopyPositionWithOffset
	or d
	ret

magunesuFunc_0d_6ccd:
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,magunesuTable_0d_6cde
	rst_addAToHl
	ld e,$8f
	ld a,(hl)
	ld (de),a
	ret

magunesuTable_0d_6cde:
	.db $fe $fd
	.db $fc $fb
	.db $fa $fb
	.db $fc $fd

magunesuFunc_0d_6ce6:
	ld a,(wMagnetGloveState)
	or a
	ret z
	call magunesuFunc_0d_6cf3
	ld b,$46
	jp ecom_applyGivenVelocity

magunesuFunc_0d_6cf3:
	call objectGetAngleTowardEnemyTarget
	ld c,a
	ld h,d
	ld l,$83
	ld a,(wMagnetGloveState)
	add (hl)
	bit 1,a
	ret nz
	ld a,c
	xor $10
	ld c,a
	ret

magunesuFunc_0d_6d06:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,magunesuTable_0d_6d14
	rst_addAToHl
	ld e,$86
	ld a,(hl)
	ld (de),a
	ret

magunesuTable_0d_6d14:
	.db $3c $78
	.db $78 $b4

magunesuFunc_0d_6d18:
	ld c,$30
	call objectCheckLinkWithinDistance
	ret nc
	pop hl
	ld h,d
	ld l,Enemy.state
	ld (hl),$0e
	ld l,$87
	ld (hl),$2d
	ld l,$90
	ld (hl),$3c
	call objectGetAngleTowardEnemyTarget
	sub $0c
	and $18
	ld e,$89
	ld (de),a
	ret


; ==============================================================================
; Leftover garbage template code?
; ==============================================================================
	ret
	jr z,+
	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret
+

enemyCodeTemplate0:
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
	.dw @state2

@state0:
	jp ecom_setSpeedAndState8AndVisible

@state_stub:
	ret

@state2:
	jp enemyAnimate
	call ecom_checkHazards
	jr z,+
	sub $03
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret
+

enemyCodeTemplate1:
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

@state0:
	jp enemyDelete

@state_stub:
	ret

; ==============================================================================
; ENEMYID_GOHMA_GEL
; ==============================================================================
enemyCode46:
	jr z,++
	sub $03
	ret c
	jr nz,+
	ld a,$32
	call objectGetRelatedObject1Var
	dec (hl)
	ld e,$82
	ld a,(de)
	dec a
	jp nz,enemyDie_uncounted
	jp enemyDie_uncounted_withoutItemDrop
+
	ld e,$82
	ld a,(de)
	cp $02
	jr nz,++
	ld e,$aa
	ld a,(de)
	cp $80
	jr nz,++
	ld e,Enemy.state
	ld a,$0d
	ld (de),a
++
	call ecom_getSubidAndCpStateTo08
	cp $0a
	jr nc,+
	rst_jumpTable
	.dw gohma_gel_state0
	.dw gohma_gel_state_stub
	.dw gohma_gel_state_stub
	.dw gohma_gel_state_stub
	.dw gohma_gel_state_stub
	.dw gohma_gel_state5
	.dw gohma_gel_state_stub
	.dw gohma_gel_state_stub
	.dw gohma_gel_state8
	.dw gohma_gel_state9
+
	ld a,b
	rst_jumpTable
	.dw gohma_gel_subid0
	.dw gohma_gel_subid1
	.dw gohma_gel_subid2
	.dw gohma_gel_subid3

gohma_gel_state0:
	call ecom_setSpeedAndState8
	ld l,$82
	ld a,(hl)
	cp $02
	jr nz,+
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GEL
+
	jp objectSetVisiblec1

gohma_gel_state5:
	call ecom_galeSeedEffect
	ret c
	ld a,$32
	call objectGetRelatedObject1Var
	dec (hl)
	jp enemyDelete

gohma_gel_state_stub:
	ret

gohma_gel_state8:
	ld bc,$ff00
	call objectSetSpeedZ
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$1e
	call ecom_setRandomAngle

gohma_gel_state9:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jp nz,ecom_applyVelocityForSideviewEnemyNoHoles
	ld l,$84
	inc (hl)
	ret

gohma_gel_subid0:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw @stateA
	.dw @stateB
	.dw @stateC

@stateA:
	ld h,d
	ld l,$90
	ld (hl),$28
	jr ++

@stateB:
	call enemyAnimate
	ld c,$0c
	call objectUpdateSpeedZ_paramC
	jr z,+
	call ecom_bounceOffWallsAndHoles
	jp objectApplySpeed
+
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@gohma_gel_seasonsTable_0d_6e4a
	rst_addAToHl
	ld e,$86
	ld a,(hl)
	ld (de),a
	ld e,$84
	ld a,$0c
	ld (de),a
	jp objectSetVisible82

@gohma_gel_seasonsTable_0d_6e4a:
	.db $01 $01
	.db $01 $30
	.db $30 $30
	.db $30 $30

@stateC:
	call enemyAnimate
	call ecom_decCounter1
	ret nz
	call objectSetVisiblec1
++
	ld l,$84
	ld (hl),$0b
	ld l,$94
	ld a,$80
	ldi (hl),a
	ld (hl),$fe
	jp ecom_updateAngleTowardTarget

gohma_gel_subid1:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD

@stateA:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$1e
	call getRandomNumber_noPreserveVars
	and $1f
	ld e,$89
	ld (de),a
	ld e,$86
	ld a,$3c
	ld (de),a
	jr +++

@stateB:
	call ecom_decCounter1
	jr z,++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr +++

@stateC:
	ld h,d
	ld l,$b0
	call ecom_readPositionVars
	cp c
	jr nz,+
	ldh a,(<hFF8F)
	cp b
	jr nz,+
	ld l,e
	inc (hl)
	call seasonsFunc_0d_6f87
	jr +++
+
	call objectGetRelativeAngleWithTempVars
	ld e,$89
	ld (de),a
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr z,+
	jr +++
+
	call ecom_decCounter1
	jr nz,+++
	jr ++

@stateD:
	call ecom_decCounter1
	jr nz,+++
++
	ld l,$84
	ld (hl),$0c
	ld l,$86
	ld (hl),$08
	ld l,$b0
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
+++
	jp enemyAnimate

gohma_gel_subid2:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw gohma_gel_subid0@stateA
	.dw gohma_gel_subid0@stateB
	.dw gohma_gel_subid0@stateC
	.dw @stateD
	.dw @seasonsFunc_0d_6f33

@stateD:
	ld a,($d00b)
	ld e,$8b
	ld (de),a
	ld a,($d00d)
	ld e,$8d
	ld (de),a
	call ecom_decCounter1
	jr z,++
	ld a,($cc46)
	or a
	jr z,+
	dec (hl)
	jr z,++
	dec (hl)
	jr z,++
+
	ld a,(wFrameCounter)
	rrca
	jr nc,+++
	ld hl,wLinkImmobilized
	set 5,(hl)
	jr +++
++
	call @seasonsFunc_0d_6f25
	ld bc,$ff20
	call objectSetSpeedZ
	ld l,$84
	inc (hl)
	ld a,$8f
	call playSound
	call objectSetVisiblec1
	jr +++

@seasonsFunc_0d_6f25:
	ld a,($d009)
	bit 7,a
	jp nz,ecom_setRandomAngle
	xor $10
	ld e,$89
	ld (de),a
	ret

@seasonsFunc_0d_6f33:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jp nz,ecom_applyVelocityForSideviewEnemyNoHoles
	ld l,$84
	ld (hl),$0b
	ld l,$a4
	set 7,(hl)
+++
	jp enemyAnimate

gohma_gel_subid3:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw @stateA
	.dw @stateB
	.dw @stateC

@stateA:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$1e

@stateB:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$86
	ld (hl),$5a
	call ecom_updateAngleTowardTarget
	call getRandomNumber_noPreserveVars
	and $01
	ld hl,@seasonsTable_0d_6f73
	rst_addAToHl
	ld e,$89
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
	jr ++

@seasonsTable_0d_6f73:
	.db $04 $fc

@stateC:
	call ecom_decCounter1
	jr nz,+
	ld l,e
	dec (hl)
	jr ++
+
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed
++
	jp enemyAnimate

seasonsFunc_0d_6f87:
	call getRandomNumber_noPreserveVars
	and $0f
	ld hl,seasonsTable_0d_6f95
	rst_addAToHl
	ld e,$86
	ld a,(hl)
	ld (de),a
	ret

seasonsTable_0d_6f95:
	.db $01 $01 $14 $14
	.db $14 $14 $14 $3c
	.db $3c $3c $3c $3c
	.db $3c $5a $5a $5a


; ==============================================================================
; ENEMYID_MOTHULA_CHILD
; ==============================================================================
enemyCode47:
	jr z,+
	sub $03
	ret c
	jp z,enemyDie_uncounted
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret
+
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state5
	.dw @state_stub
	.dw @state_stub
+
	ld a,b
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@state0:
	bit 7,b
	ld a,$46
	jp z,ecom_setSpeedAndState8AndVisible
	ld a,$01
	ld (de),a

@state1:
	bit 0,b
	ld bc,$0400
	jr z,+
	ld bc,$0604
+
	push bc
	call checkBEnemySlotsAvailable
	pop bc
	ret nz
	ld a,b
	ldh (<hFF8B),a
	ld a,c
	ld bc,@seasonsTable_0d_7017
	call addAToBc
-
	push bc
	ld b,ENEMYID_MOTHULA_CHILD
	call ecom_spawnUncountedEnemyWithSubid01
	dec (hl)
	call objectCopyPosition
	dec l
	ld a,(hl)
	ld (hl),$00
	ld l,$8b
	add (hl)
	ld (hl),a
	pop bc
	ld l,$89
	ld a,(bc)
	ld (hl),a
	inc bc
	ld hl,$ff8b
	dec (hl)
	jr nz,-
	jp enemyDelete

@seasonsTable_0d_7017:
	.db $04 $0c $14 $1c $00
	.db $05 $0b $10 $15 $1b

@state5:
	call ecom_galeSeedEffect
	ret c
	jp enemyDelete

@state_stub:
	ret

@subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9

@@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$86
	ld (hl),$04
	inc l
	ld (hl),$3c
	call seasonsFunc_0d_7089
	jp objectSetVisible82

@@state9:
	call ecom_decCounter2
	jr z,+
	call ecom_decCounter1
	jr nz,+
	ld (hl),$04
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call seasonsFunc_0d_7089
+
	call objectApplySpeed
	call seasonsFunc_0d_7078
	jp enemyAnimate

@subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @ret1
@ret1:
	ret

@subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @ret2
@ret2:
	ret

@subid3:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @ret3
@ret3:
	ret

seasonsFunc_0d_7078:
	ld e,$8b
	ld a,(de)
	cp $b8
	jr nc,+
	ld e,$8d
	ld a,(de)
	cp $f8
	ret c
+
	pop hl
	jp enemyDelete

seasonsFunc_0d_7089:
	ld h,d
	ld l,$89
	ldd a,(hl)
	add $02
	and $1c
	rrca
	rrca
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation


; ==============================================================================
; ENEMYID_BLAINO
; ==============================================================================
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
	ld (hl),ENEMYID_BLAINOS_GLOVES
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

; ==============================================================================
; ENEMYID_MINI_DIGDOGGER
; ==============================================================================
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


; ==============================================================================
; ENEMYID_MAKU_TREE_BUBBLE
;
; Variables:
;   $cfc0: bit 7 set when popped
; ==============================================================================
enemyCode56:
	jr z,@normalStatus
	ld e,Enemy.state
	ld a,$02
	ld (de),a
@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a
	call objectSetVisible80
	jr @snore

@state1:
	ld e,Enemy.subid
	ld a,(de)
	jr z,+
	ld hl,$cfc0
	bit 7,(hl)
	jr z,+
	ld e,Enemy.state
	ld a,$02
	ld (de),a
+
	call enemyAnimate

@snore:
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	ld e,Enemy.state
	ld a,(de)
	cp $01
	jr nz,+
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	jr nz,++
	ld e,Enemy.animCounter
	ld a,(de)
	cp $01
	jr nz,+
	ld a,SND_MAKU_TREE_SNORE
	call playSound
+
	ld e,Enemy.animParameter
	ld a,(de)
++
	add a
	ld hl,@bubbleOffsetAndCollisionRadius
	rst_addDoubleIndex
	ld e,Enemy.yh
	ldi a,(hl)
	add b
	ld (de),a
	ld e,Enemy.xh
	ldi a,(hl)
	add c
	ld (de),a
	ld e,Enemy.zh
	ld a,$f8
	ld (de),a
	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ret

@bubbleOffsetAndCollisionRadius:
	.db $d8 $e0 $00 $00
	.db $06 $f6 $00 $00
	.db $08 $f0 $06 $00
	.db $04 $ec $08 $00
	.db $07 $f0 $06 $00
	.db $05 $f6 $00 $00

@state2:
	ld h,d
	ld l,Enemy.substate
	ld a,(hl)
	or a
	jr nz,+
	inc (hl)
	ld l,Enemy.collisionType
	ld b,Enemy.var2f-Enemy.collisionType
	; all counters, collision, damage and health
	call clearMemory
	ld l,Enemy.health
	inc (hl)
	ld l,Enemy.oamFlagsBackup
	ld a,$01
	ldi (hl),a
	; oamFlags
	ld (hl),a
	ld a,$01
	call enemySetAnimation
	ld hl,$cfc0
	set 7,(hl)
	jr @snore
+
	ld l,Enemy.animParameter
	bit 7,(hl)
	jp z,enemyAnimate
	xor a
	ld (hl),a
	ld l,Enemy.substate
	ldd (hl),a
	inc (hl)
	jp @snore

@state3:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z
	rlca
	jp c,enemyDelete
	ld h,d
	ld l,Enemy.yh
	inc (hl)
	ret


; ==============================================================================
; ENEMYID_SAND_PUFF
; ==============================================================================
enemyCode5b:
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw enemyAnimate

@state0:
	ld a,$01
	ld (de),a
	call getRandomNumber
	and $07
	inc a
	ld e,$86
	ld (de),a
	ld a,$b0
	jp loadPaletteHeader

@state1:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	jp objectSetVisible83


; ==============================================================================
; ENEMYID_WALL_FLAME_SHOOTER
; ==============================================================================
enemyCode5c:
	dec a
	ret z
	dec a
	ret z
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$8f
	ld (hl),$fe
	ld l,$82
	bit 0,(hl)
	ret z
	ld l,$87
	ld (hl),$08
	ret

@state1:
	call ecom_decCounter2
	ret nz
	ld (hl),$10
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_WALL_FLAME_SHOOTERS_FLAMES
	ld bc,$0600
	jp objectCopyPositionWithOffset

; ==============================================================================
; ENEMYID_BLAINOS_GLOVES
; ==============================================================================
enemyCode5f:
	jr z,++
	call seasonsFunc_0d_7986
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_BLAINO_GLOVE
	jr nz,++
	ld e,$aa
	ld a,(de)
	res 7,a
	sub $0a
	cp $02
	jr nc,++
	ld h,d
	ld l,$84
	ld (hl),$02
	ld l,$a4
	res 7,(hl)
	ld l,$87
	ld (hl),$1e
	ld l,$8e
	xor a
	ldi (hl),a
	ld (hl),a
	ld a,$2b
	call objectGetRelatedObject1Var
	ld (hl),$f8
	ld l,Enemy.z
	xor a
	ldi (hl),a
	ld (hl),a
++
	call seasonsFunc_0d_785c
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a

@state1:
	call seasonsFunc_0d_786d
	ld b,h
	ld e,Enemy.substate
	ld a,(hl)
	rst_jumpTable
	.dw @seasonsFunc_0d_76fa
	.dw @seasonsFunc_0d_76fa
	.dw @state1zh2
	.dw @state1zh3
	.dw @state1zh4
	.dw @state1zh5

@state2:
	call ecom_decCounter2
	jr z,+
	ld a,$2e
	call objectGetRelatedObject1Var
	ld (hl),$02
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLAINO_VULNERABLE
	jr ++
+
	ld l,e
	dec (hl)
	ld l,$a4
	set 7,(hl)
	ld a,$25
	call objectGetRelatedObject1Var
	ld (hl),$56
++
	jp seasonsFunc_0d_796d

@state3:
	ld a,$2b
	call objectGetRelatedObject1Var
	ld e,$ab
	ld a,(hl)
	ld (de),a
	jp seasonsFunc_0d_796d

@seasonsFunc_0d_76fa:
	ld h,b
	jp seasonsFunc_0d_7883

@state1zh2:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLAINO_GLOVE_SOFT_PUNCH

@@substate1:
	call @seasonsFunc_0d_76fa
	ld l,$b0
	ld a,(hl)
	add a
	add a
	ld b,a
	ld a,(wFrameCounter)
	and $04
	rrca
	add b
	ld hl,@seasonsTable_0d_772b
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

@seasonsTable_0d_772b:
	.db $f8 $00 $fb $00
	.db $00 $08 $00 $05
	.db $08 $00 $05 $00
	.db $00 $f8 $00 $fb

@state1zh3:
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
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	ld l,$90
	ld (hl),$0a
	ld l,$87
	ld (hl),$1e
	call @seasonsFunc_0d_76fa
	ld l,$b0
	ld a,(hl)
	rrca
	swap a
	xor $10
	ld e,$89
	ld (de),a
	call seasonsFunc_0d_78ce

@@substate1:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78bc
	ld (hl),$04
	ld l,e
	inc (hl)

@@substate2:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78ab
	ld (hl),$0a
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$78
	ld l,$89
	ld a,(hl)
	xor $10
	ld (hl),a

@@substate3:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78bc
	ld (hl),$14
	ld l,e
	inc (hl)

@@substate4:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78ab
	ld (hl),$14
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$28
	ld l,$89
	ld a,(hl)
	xor $10
	ld (hl),a

@@substate5:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78bc
	jp @seasonsFunc_0d_76fa

@state1zh4:
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
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLAINO_GLOVE_SOFT_PUNCH

@@substate1:
	call @seasonsFunc_0d_76fa
	ld a,$05
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $02
	ret c
	ld l,$89
	ld e,$89
	ld a,(hl)
	ld (de),a
	call seasonsFunc_0d_78ce
	ld bc,$ff80
	call objectSetSpeedZ
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLAINO_GLOVE_HARD_PUNCH
	ld l,$85
	inc (hl)
	ld l,$87
	ld (hl),$0a
	ld l,$90
	ld (hl),$50

@@substate2:
	call ecom_decCounter2
	jr nz,+
	ld (hl),$08
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$64
	ld l,$89
	ld a,(hl)
	xor $10
	ld (hl),a
+
	call seasonsFunc_0d_78bc
	jp seasonsFunc_0d_78e1

@@substate3:
	call ecom_decCounter2
	jp z,@seasonsFunc_0d_76fa
	ld l,$8f
	inc (hl)
	inc (hl)
	jp seasonsFunc_0d_78bc

@state1zh5:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld h,d
	ld l,$85
	inc (hl)
	ld l,$a4
	res 7,(hl)
	inc l
	ld (hl),$58

@@substate1:
	ld a,$05
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $02
	jp c,seasonsFunc_0d_78f8
	ld h,d
	ld l,$87
	ld (hl),$1e
	ld l,$a6
	ld a,$08
	ldi (hl),a
	ld (hl),a
	ld l,$a4
	set 7,(hl)
	ld l,$85
	inc (hl)
	ld l,$94
	ld a,$c0
	ldi (hl),a
	ld (hl),$fb

@@substate2:
	call ecom_decCounter2
	jr z,+
	ld l,$a6
	ld a,$06
	ldi (hl),a
	ld (hl),a
+
	call seasonsFunc_0d_7915
	call seasonsFunc_0d_78f8
	ld c,$34
	jp objectUpdateSpeedZ_paramC

seasonsFunc_0d_785c:
	ld e,$84
	ld a,(de)
	or a
	ret z
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $54
	ret z
	jp enemyDelete

seasonsFunc_0d_786d:
	ld a,$31
	call objectGetRelatedObject1Var
	ld e,Enemy.var31
	ld a,(de)
	cp (hl)
	ret z
	ld a,(hl)
	ld (de),a
	ld e,Enemy.enemyCollisionMode
	ld a,ENEMYCOLLISION_BLAINO_GLOVE
	ld (de),a
	ld e,$85
	xor a
	ld (de),a
	ret

seasonsFunc_0d_7883:
	ld l,$b0
	ld a,(hl)
	push hl
	ld hl,seasonsTable_0d_78a3
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	pop hl
	ld l,$8f
	ld e,$8f
	ld a,(hl)
	ld (de),a

seasonsFunc_0d_7895:
	call objectTakePositionWithOffset

seasonsFunc_0d_7898:
	ld l,$b0
	ld a,(hl)
	cp $02
	jp c,objectSetVisible82
	jp objectSetVisible81

seasonsTable_0d_78a3:
	.db $fb $fc $01 $06
	.db $04 $04 $01 $fc

seasonsFunc_0d_78ab:
	ld l,$b2
	ld b,(hl)
	inc l
	ld c,(hl)
	ld a,$0b
	call objectGetRelatedObject1Var
	push hl
	call seasonsFunc_0d_7895
	pop hl
	jr seasonsFunc_0d_78ce

seasonsFunc_0d_78bc:
	ld l,$b2
	ld b,(hl)
	inc l
	ld c,(hl)
	ld a,$0b
	call objectGetRelatedObject1Var
	push hl
	call seasonsFunc_0d_7895
	call objectApplySpeed
	pop hl

seasonsFunc_0d_78ce:
	ld l,$8b
	ld e,$8b
	ld a,(de)
	sub (hl)
	ld e,$b2
	ld (de),a
	ld l,$8d
	ld e,$8d
	ld a,(de)
	sub (hl)
	ld e,$b3
	ld (de),a
	ret

seasonsFunc_0d_78e1:
	ld h,d
	ld l,$94
	ld e,$8e
	ld a,(de)
	sub (hl)
	ld (de),a
	inc l
	inc e
	ld a,(de)
	sbc (hl)
	ld (de),a
	dec l
	ld a,(hl)
	add $80
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a
	ret

seasonsFunc_0d_78f8:
	ld a,$21
	call objectGetRelatedObject1Var
	push hl
	ld a,(hl)
	ld hl,seasonsTable_0d_78a3
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	pop hl
	call objectTakePositionWithOffset
	ld l,$a1
	ld a,(hl)
	cp $02
	jp c,objectSetVisible82
	jp objectSetVisible81

seasonsFunc_0d_7915:
	call seasonsFunc_0d_795c
	ld l,$aa
	ld a,(hl)
	cp $80
	ret nz
	ld l,$b4
	ld (hl),$08
	ld hl,$d00f
	ld a,(hl)
	sub $08
	ld (hl),a
	ld l,$2b
	ld (hl),$00
	ld l,$2d
	ld (hl),$00
	ld a,$09
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld ($d02c),a
	add $04
	and $18
	rrca
	rrca
	ld hl,seasonsTable_0d_7954
	rst_addAToHl
	ld e,$8b
	ld a,(de)
	add (hl)
	ld ($d00b),a
	inc hl
	ld e,$8d
	ld a,(de)
	add (hl)
	ld ($d00d),a
	ret

seasonsTable_0d_7954:
	.db $fc $00 $00 $04
	.db $04 $00 $00 $fc

seasonsFunc_0d_795c:
	ld h,d
	ld l,$b4
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret nz
	ld a,$14
	ld ($d02b),a
	ld ($d02d),a
	ret

seasonsFunc_0d_796d:
	ld a,$30
	call objectGetRelatedObject1Var
	ld a,(hl)
	push hl
	ld hl,seasonsTable_0d_7982
	rst_addAToHl
	ld c,(hl)
	ld b,$f8
	pop hl
	call objectTakePositionWithOffset
	jp seasonsFunc_0d_7898

seasonsTable_0d_7982:
	.db $fb $fc $05 $04

seasonsFunc_0d_7986:
	ld e,$ab
	ld a,(de)
	bit 7,a
	ret z
	xor a
	ld (de),a
	ret
