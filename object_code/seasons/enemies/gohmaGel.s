; ==================================================================================================
; ENEMY_GOHMA_GEL
; ==================================================================================================
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
