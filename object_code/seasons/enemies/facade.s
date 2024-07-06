; ==================================================================================================
; ENEMY_FACADE
; ==================================================================================================
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
	ld b,ENEMY_BEETLE
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
	ld b,PART_2e
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
	ld b,PART_VOLCANO_ROCK
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
