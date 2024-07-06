; ==================================================================================================
; ENEMY_DIGDOGGER
; ==================================================================================================
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
	ld b,ENEMY_DIGDOGGER
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
	ld b,ENEMY_MINI_DIGDOGGER
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
