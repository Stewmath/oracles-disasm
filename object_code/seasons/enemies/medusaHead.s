; ==================================================================================================
; ENEMY_MEDUSA_HEAD
; ==================================================================================================
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
	ldbc ENEMY_MEDUSA_HEAD $04
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
	ld b,PART_46
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
	ld b,PART_45
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
	ld b,PART_44
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
	ld b,PART_46
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
