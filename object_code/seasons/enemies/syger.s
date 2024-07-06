; ==================================================================================================
; ENEMY_SYGER
; ==================================================================================================
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
	ld b,ENEMY_SYGER
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
