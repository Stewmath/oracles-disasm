; ==================================================================================================
; ENEMY_MANHANDLA
; ==================================================================================================
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
	ld b,ENEMY_MANHANDLA
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
	ld b,PART_GOPONGA_PROJECTILE
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
