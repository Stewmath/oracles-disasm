; ==================================================================================================
; ENEMY_POE_SISTER_1
; ==================================================================================================
enemyCode7e:
	jr z,@normalStatus
	sub $03
	ret c
	jr nz,+
	ld bc,$0a06
	jp poeSister5f7e
+
	call poeSister5fc2
	ret z
@normalStatus:
	call @func_5d86
	jp func_5fec
@func_5d86:
	call poeSister604b
	call poeSister602e
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw enemyCode76@stateStub
	.dw enemyCode76@stateStub
	.dw enemyCode76@stateStub
	.dw enemyCode76@stateStub
	.dw enemyCode76@state5
	.dw enemyCode76@stateStub
	.dw enemyCode76@stateStub
	.dw enemyCode76@state8
	.dw enemyCode76@state9
	.dw @stateA
	.dw enemyCode76@stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF
	.dw enemyCode76@state10
	.dw enemyCode76@state11
	
@state0:
	ld a,$7e
	ld ($cc1c),a
	ld b,PART_3b
	call ecom_spawnProjectile
	ret nz
	call getRandomNumber_noPreserveVars
	ld e,$b8
	ld (de),a
	ld h,d
	ld l,$88
	ld (hl),$ff
	ld l,$90
	ld (hl),$3c
	ld e,$82
	ld a,(de)
	or a
	jp z,enemyCode76@func5c6d

@func_5dd5:
	ld l,$84
	ld (hl),$08
	ld l,$a9
	ld a,(hl)
	add $06
	ld (hl),a
	ld l,$b6
	ld (hl),a
	ld a,$76
	ld b,$00
	call enemyBoss_initializeRoom
	ld a,$03
	jp enemySetAnimation
	
@stateA:
	call ecom_decCounter1
	jr nz,@animate
	ld (hl),$2d
	ld l,e
	inc (hl)
	ret
	
@stateC:
	call ecom_decCounter1
	ret nz
	ld (hl),$30
	ld l,e
	inc (hl)
	call func_5e7b
	jp objectSetVisible82
	
@stateD:
@stateF:
	call ecom_decCounter1
	jr nz,+
	ld (hl),$30
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$b9
	ld e,$8b
	ldi a,(hl)
	ld (de),a
	ld e,$8d
	ld a,(hl)
	ld (de),a
	ret
+
	ld a,(hl)
	and $3c
	rrca
	rrca
	bit 1,(hl)
	jr z,+
	cpl
	inc a
+
	ld l,$88
	bit 0,(hl)
	ld l,$b9
	ld e,$8b
	jr nz,+
	inc l
	ld e,$8d
+
	add (hl)
	ld (de),a
	ret
	
@stateE:
	call ecom_decCounter1
	jp z,poeSister5f3b
	call objectApplySpeed
@animate:
	jp enemyAnimate

func_5e45:
	ld bc,table_5e6b
	call func_5ea3
	jr z,++
	ldh a,(<hEnemyTargetY)
	cp $58
	ld a,$fe
	ld c,$00
	jr c,+
	ld a,$02
	inc c
+
	ld e,$b1
	ld (de),a
	ld a,b
	add c
	ld hl,table_5e73
	rst_addAToHl
	ld b,(hl)
++
	ld e,$89
	ld a,b
	ld (de),a
	jp ecom_updateAnimationFromAngle

table_5e6b:
	.db $e0 $20 $20 $20
	.db $20 $e0 $e0 $e0

table_5e73:
	.db $18 $10 $00 $18
	.db $08 $00 $10 $08

func_5e7b:
	ld bc,table_5e9b
	call func_5ea3
	jr z,+
	ld a,b
	add a
	add a
	xor $10
	ld b,a
+
	ld e,$89
	ld a,b
	ld (de),a
	ld h,d
	ld l,$b9
	ld e,$8b
	ld a,(de)
	ldi (hl),a
	ld e,$8d
	ld a,(de)
	ld (hl),a
	jp ecom_updateAnimationFromAngle

table_5e9b:
	.db $d8 $00 $00 $28
	.db $28 $00 $00 $d8

func_5ea3:
	push bc
	ld e,$82
	ld a,(de)
	or a
	jr z,func_5f0b
	ld e,$b2
	ld a,(de)
	inc a
	and $0f
	ld (de),a
	ld hl,flags_5f35
	call checkFlag
	jr z,func_5f0b
	call getRandomNumber_noPreserveVars
	and $03
	ld b,a
	ld c,$05
-
	dec c
	jr z,func_5f0b
	ld a,b
	inc a
	and $03
	ld b,a
	ld hl,table_5f37
	rst_addAToHl
	ld l,(hl)
	ld h,$cf
	ld a,(hl)
	cp $09
	jr nz,-

	ld (hl),$08
	ld c,l
	ld e,$b3
	ld a,l
	ld (de),a
	and $06
	pop hl
	rst_addAToHl
	ld e,$b4
	ld a,c
	and $f0
	add $08
	ld (de),a
	ld e,$8b
	add (hl)
	ld (de),a
	ld e,$b5
	inc hl
	ld a,c
	and $0f
	swap a
	add $08
	ld (de),a
	ld e,$8d
	add (hl)
	ld (de),a
	ld h,d
	ld l,$84
	ld (hl),$0f
	ld l,$b4
	call ecom_readPositionVars
	call objectGetRelativeAngleWithTempVars
	ld b,a
	xor a
	ret

func_5f0b:
	call getRandomNumber_noPreserveVars
	and $06
	ld b,a
	pop hl
	push hl
	rst_addAToHl
	ldh a,(<hEnemyTargetY)
	add (hl)
	cp $b0
	jr nc,func_5f0b
	ld e,$8b
	ld (de),a
	inc hl
	ldh a,(<hEnemyTargetX)
	ld c,a
	add (hl)
	cp $f0
	jr nc,func_5f0b
	ld e,$8d
	ld (de),a
	sub c
	jr nc,+
	cpl
	inc a
+
	rlca
	jr c,func_5f0b
	pop hl
	or d
	ret

flags_5f35:
	.db $6a $b5

table_5f37:
	.db $3a $7a $74 $34

poeSister5f3b:
	ld h,d
	ld l,$84
	ld (hl),$0b
	ld l,$a4
	res 7,(hl)
	ld l,$86
	ld (hl),$18
	ret

func_5f49:
	ld e,$86
	ld a,(de)
	and $07
	ret nz
	ld b,PART_POE_SISTER_FLAME
	jp ecom_spawnProjectile

func_5f54:
	call getFreePartSlot
	ret nz
	ld (hl),PART_LIGHTABLE_TORCH
	ld e,$b3
	ld a,(de)
	and $f0
	add $08
	ld l,$cb
	ldi (hl),a
	ld a,(de)
	and $0f
	swap a
	add $08
	inc l
	ld (hl),a
	ld hl,$cca9
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld a,(de)
	ld c,a
	ld a,$08
	call setTile
	xor a
	ret

poeSister5f7e:
	ld e,$82
	ld a,(de)
	or a
	jr z,poeSister5f82
	ld e,$a4
	ld a,(de)
	or a
	jr z,+
	ld a,($cba0)
	or a
	ret nz
	call showText
	call objectSetInvisible
+
	ld a,$00
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,enemyBoss_dead
	jp enemyDie_withoutItemDrop

poeSister5f82:
	ld e,$a4
	ld a,(de)
	or a
	jr z,++
	xor a
	ld (de),a
	ld bc,TX_0a04
	ld e,$81
	ld a,(de)
	cp $76
	jr z,+
	ld c,<TX_0a02
+
	jp showText
++
	call objectCreatePuff
	call decNumEnemies
	jp enemyDelete

poeSister5fc2:
	ld h,d
	ld l,$a9
	ld a,(hl)
	ld l,$b6
	cp (hl)
	ret z
	ld (hl),a
	ld l,$b7
	set 1,(hl)
	ld e,$84
	ld a,(de)
	cp $0f
	ccf
	ret nc
	ld e,$a1
	ld a,(de)
	cp $02
	jr z,+
	ld l,$b3
	ld l,(hl)
	ld h,$cf
	ld (hl),$09
+
	call poeSister5f3b
	ld e,$a9
	ld a,(de)
	or a
	ret

func_5fec:
	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,$88
	ld a,(de)
	cp $04
	jr c,+
	sub $04
	add a
	inc a
+
	add a
	add a
	ld hl,table_601e
	rst_addAToHl
	ld a,b
	call checkFlag
	ld h,d
	ld l,$b7
	ld e,$a4
	jr z,+
	ld a,(de)
	and $80
	or $7e
	ld (de),a
	res 2,(hl)
	ret
+
	ld a,(de)
	and $80
	or $76
	ld (de),a
	set 2,(hl)
	ret

table_601e:
	.db $1f $00 $00 $00
	.db $00 $1f $00 $00
	.db $00 $00 $1f $00
	.db $00 $00 $f0 $01
	
poeSister602e:
	ld h,d
	ld l,$84
	ld a,(hl)
	cp $08
	ret c
	ld l,$b8
	dec (hl)
	ld a,(hl)
	and $18
	swap a
	rlca
	ld hl,table_6047
	rst_addAToHl
	ld e,$8f
	ld a,(hl)
	ld (de),a
	ret

table_6047:
	.db $ff $fe $fd $fe
	
poeSister604b:
	ld e,$82
	ld a,(de)
	or a
	ret z
	ld h,d
	ld l,$b7
	ld a,($cca9)
	or a
	jr z,+
	res 0,(hl)
	ret
+
	bit 0,(hl)
	jr nz,+
	set 0,(hl)
	ld l,$b0
	ld (hl),$18
+
	ld l,$b0
	dec (hl)
	ret nz
	ld a,($cc34)
	or a
	ret nz
	ld a,(wWarpTransition2)
	or a
	ret nz
	ld a,$8d
	call playSound
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_SEASONS_55b, $00, $57, $03
