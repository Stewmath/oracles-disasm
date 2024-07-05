; ==================================================================================================
; ENEMY_GENERAL_ONOX
; ==================================================================================================
enemyCode02:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@justHit
	; dead
	ld e,$a4
	ld a,(de)
	or a
	jr z,@dying
	ld a,$f0
	call playSound
@dying:
	ld e,$b2
	ld a,(de)
	or a
	jr nz,@dead
	call checkLinkCollisionsEnabled
	jr nc,@dead
	ld a,$ff
	ld ($cbca),a
	ld ($cc02),a
	ld h,d
	ld l,$a4
	ld (hl),$00
	ld l,$b2
	inc (hl)
	ld l,$86
	ld (hl),$78
	ld a,$67
	call playSound
@dead:
	jp enemyBoss_dead
@justHit:
	ld e,$82
	ld a,(de)
	or a
	call z,generalOnox_func_5c75
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
	.dw generalOnox_subid0
	.dw generalOnox_subid1
	.dw generalOnox_subid2

@state0:
	ld a,b
	cp $02
	jr z,+
	ld bc,$0210
	call enemyBoss_spawnShadow
	ret nz
	ld a,$02
	ld b,$89
	call enemyBoss_initializeRoom
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld a,$0a
	jp ecom_setSpeedAndState8
+
	ld a,$89
	call loadPaletteHeader
	ld a,$01
	ld ($cfcf),a
	ld ($cbca),a
	call ecom_setSpeedAndState8
	ld a,$53
	jp playSound
	
@stateStub:
	ret
	
generalOnox_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC

@state8:
	ld b,PART_47
	call ecom_spawnProjectile
	ret nz
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$89
	ld (hl),$10
	ld l,$8b
	ld (hl),$18
	ld l,$8d
	ld (hl),$78
	jp objectSetVisible83

@state9:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	ld a,$05
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $04
	ret nz
	ld h,d
	ld l,$85
	inc (hl)
	ld l,$87
	ld (hl),$1e
	
@@substate1:
	call ecom_decCounter2
	ret nz
	ld a,(wFrameCounter)
	and $1f
	ld a,$70
	call z,playSound
	call objectApplySpeed
	ld e,$8b
	ld a,(de)
	cp $48
	jp nz,enemyAnimate
	ld h,d
	ld l,$85
	inc (hl)
	inc l
	ld (hl),$08
	
@@substate2:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ld bc,TX_501c
	call checkIsLinkedGame
	jr z,+
	ld c,<TX_5020
+
	jp showText
	
@@substate3:
	ld e,$90
	ld a,$0f
	ld (de),a
	ld a,$2e
	ld (wActiveMusic),a
	call playSound
	ld a,$04
	call objectGetRelatedObject2Var
	inc (hl)

@func_594f:
	ld h,d
	ld l,$84
	ld (hl),$0a
	inc l
	ld (hl),$00
	inc l
	ld (hl),$2d
	ld a,$02
	jp enemySetAnimation
	
@stateA:
	call ecom_decCounter1
	ret nz
	ld (hl),$b4
	inc l
	ld (hl),$0a
	ld l,e
	inc (hl)
	jr @stateB@func_59c0
	
@stateB:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call ecom_decCounter1
	jr nz,@@func_598b
	ld a,$24
	call objectGetRelatedObject2Var
	res 7,(hl)
	ld l,$da
	res 7,(hl)
	ld l,$c4
	ld (hl),$08
	jr @func_5a06

@@func_598b:
	call generalOnox_subid2@func_5c3b
	jr nc,+
	call enemyAnimate
	call ecom_decCounter2
	jr nz,@@func_59c0
	ld a,$09
	call objectGetRelatedObject2Var
	ld a,(hl)
	sub $0e
	cp $07
	jr nc,@@func_59c0
	ld l,$c4
	inc (hl)
	ld e,$85
	ld a,$01
	ld (de),a
	ld a,$05
	jp enemySetAnimation
+
	ld l,$87
	ld (hl),$0a
	ld a,(wFrameCounter)
	and $07
	call z,generalOnox_func_59c0
	call ecom_applyVelocityForSideviewEnemyNoHoles

@@func_59c0:
	jp enemyAnimate

@@substate1:
	ld a,$09
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $03
	ret nz
	ld l,$c4
	inc (hl)
	ld l,$e8
	ld (hl),$f8
	ld l,$c9
	ld (hl),$0e
	ld l,$c6
	ld (hl),$00
	ld l,$cb
	ld e,$8b
	ld a,(de)
	sub $10
	ld (hl),a
	ld l,$f0
	add $21
	ld (hl),a
	ld l,$cd
	ld e,$8d
	ld a,(de)
	add $08
	ld (hl),a
	ld l,$f1
	add $f9
	ld (hl),a
	ld e,$85
	ld a,$02
	ld (de),a
	inc a
	jp enemySetAnimation

@@substate2:
	ld a,$24
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret nz
@func_5a06:
	call getRandomNumber_noPreserveVars
	cp $8c
	jp c,@func_594f
	ld h,d
	ld l,$84
	inc (hl)
	inc l
	ld (hl),$00
	ld l,$86
	ld (hl),$10
	ld a,$04
	jp enemySetAnimation
	
@stateC:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ld l,$94
	ld a,$c0
	ldi (hl),a
	ld (hl),$fd
	ld a,$81
	call playSound
	jp objectSetVisible81

@@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,$85
	inc (hl)
	inc l
	ld a,$b4
	ld (hl),a
	call setScreenShakeCounter
	call objectSetVisible83
	call getFreePartSlot
	ret nz
	ld (hl),PART_48
	ret

@@substate2:
	call ecom_decCounter1
	ret nz
	jp @func_594f
	
generalOnox_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw generalOnox_subid0@stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD

@state8:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,$84
	inc (hl)
	inc l
	xor a
	ld (hl),a
	ld ($cd18),a
	ld ($cd19),a
	ld l,$b0
	dec a
	ldi (hl),a
	ld (hl),a
	ld a,$01
	call enemySetAnimation
	jp objectSetVisible83

@state9:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld e,$ab
	ld a,(de)
	or a
	ret nz
	ld a,($cc34)
	or a
	ret nz
	inc a
	ld ($cca4),a
	ld ($cbca),a
	ld e,$85
	ld (de),a
	ld bc,TX_501d
	jp showText

@@substate1:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$64
	ld a,$00
	call objectGetRelatedObject1Var
	ld bc,$18f8
	call objectCopyPositionWithOffset
	ldh a,(<hCameraY)
	ld b,a
	ld l,$cb
	ld a,(hl)
	sub b
	cpl
	inc a
	sub $10
	ld l,$cf
	ld (hl),a
	ld l,$da
	ld (hl),$81
	ld l,$c4
	inc (hl)
	ret

@@substate2:
	call ecom_decCounter1
	ret nz
	ld l,$a4
	set 7,(hl)
	xor a
	ld ($cca4),a
	ld ($cbca),a

@func_5ae5:
	ld h,d
	ld l,$84
	ld (hl),$0a
	inc l
	ld (hl),$00
	ld l,$86
	ld (hl),$2d
	ld l,$b1
	ldd a,(hl)
	ldi (hl),a
	ld (hl),$00
	ld a,$02
	jp enemySetAnimation

@stateB:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw generalOnox_subid0@stateB@substate1
	.dw @@substate2

@@substate0:
	call ecom_decCounter1
	jp nz,generalOnox_subid0@stateB@func_598b
	ld a,$24
	call objectGetRelatedObject2Var
	res 7,(hl)
	ld l,$da
	res 7,(hl)
	ld l,$c4
	ld (hl),$08

@@substate2:
	ld a,$24
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret nz

@func_5b22:
	ld h,d
	ld l,$b0
	ldi a,(hl)
	cp (hl)
	ld l,$85
	ld (hl),$00
	jr z,+
	call getRandomNumber
	rrca
	jr c,@func_5ae5
	ld h,d
	dec l
	ld (hl),$0d
	ld l,$b1
	ldd a,(hl)
	ldi (hl),a
	ld (hl),$02
	call generalOnox_func_5c63
	ld e,$86
	ld a,(de)
	dec a
	ret z
	xor a
	jp enemySetAnimation
+
	dec l
	ld (hl),$0c
	ld l,$86
	ld (hl),$10
	ld l,$b1
	ldd a,(hl)
	ldi (hl),a
	ld (hl),$01
	ld a,$04
	jp enemySetAnimation

@stateC:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw generalOnox_subid0@stateC@substate0
	.dw generalOnox_subid0@stateC@substate1
	.dw @@substate2

@@substate2:
	call ecom_decCounter1
	ret nz
	jp @func_5ae5

@stateD:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @func_5b22

@@substate0:
	call ecom_decCounter1
	jr nz,+
	inc (hl)
	inc l
	ld (hl),$04
	ld l,e
	inc (hl)
	ld a,$03
	jp enemySetAnimation
+
	call ecom_updateAngleTowardTarget
	call objectApplySpeed
	jp enemyAnimate

@@substate1:
	call ecom_decCounter1
	ret nz
	ld (hl),$2d
	inc l
	dec (hl)
	jr z,+
	call getFreePartSlot
	ret nz
	ld (hl),PART_49
	ld bc,$19f9
	jp objectCopyPositionWithOffset
+
	ld l,e
	inc (hl)
	ret
	
generalOnox_subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC

@state8:
	ld a,($cc77)
	or a
	ret nz
	ld ($cfcf),a
	inc a
	ld ($cca4),a
	ld h,d
	ld l,$8b
	ld (hl),$50
	ld l,$8d
	ld (hl),$50
	ldbc INTERAC_0b $02
	call objectCreateInteraction
	ret nz
	ld e,$98
	ld a,$40
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld e,$84
	ld a,$09
	ld (de),a
	jp clearAllParentItems

@state9:
	ld a,$21
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$5a
	call objectSetVisible82

@stateA:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	and $1c
	rrca
	rrca
	ld hl,@table_5c1f
	rst_addAToHl
	ld e,Enemy.yh
	ld a,(hl)
	ld (de),a
	ret
+
	ld (hl),$5a
	ld l,e
	inc (hl)
	ld a,$30
	ld ($cd08),a
	ld a,$08
	ld ($cbae),a
	ld a,$06
	ld ($cbac),a
	ld bc,TX_5022
	jp showText

@table_5c1f:
	.db $50
	.db $51
	.db $52
	.db $53
	.db $52
	.db $51
	.db $50
	.db $4f

@stateB:
	ld e,$84
	ld a,$0c
	ld (de),a
	jp fadeoutToWhite

@stateC:
	ld a,($c4ab)
	or a
	ret nz
	ld hl,$cfc8
	inc (hl)
	jp enemyDelete

@func_5c3b:
	ld h,d
	ld l,$8b
	ldh a,(<hEnemyTargetY)
	sub (hl)
	cp $30
	ret nc
	ld l,$8d
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $10
	cp $21
	ret

generalOnox_func_59c0:
	ldh a,(<hEnemyTargetY)
	sub $18
	cp $98
	jr c,+
	ld a,$10
+
	ld b,a
	ldh a,(<hEnemyTargetX)
	ld c,a
	call objectGetRelativeAngle
	ld e,$89
	ld (de),a
	ret

generalOnox_func_5c63:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@table_5c71
	rst_addAToHl
	ld e,$86
	ld a,(hl)
	ld (de),a
	ret

@table_5c71:
	.db $01
	.db $1e
	.db $3c
	.db $5a
	
generalOnox_func_5c75:
	ld e,$a9
	ld a,(de)
	cp $28
	ret nc
	ld h,d
	ld l,$82
	inc (hl)
	ld l,$84
	ld (hl),$08
	ld l,$a4
	res 7,(hl)
	ld a,$24
	call objectGetRelatedObject2Var
	res 7,(hl)
	ld l,$da
	res 7,(hl)
	ld l,$c4
	ld (hl),$08
	ld a,$67
	jp playSound
