; ==================================================================================================
; ENEMY_FRYPOLAR
; ==================================================================================================
enemyCode77:
	jr z,@normalStatus
	sub $03
	ret c
	jp z,enemyBoss_dead
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ld e,$b2
	ld a,(de)
	or a
	jr nz,@normalStatus
	ld e,$aa
	ld a,(de)
	cp $9a
	jr z,+
	cp $9b
	jr nz,@normalStatus
	ld e,$82
	ld a,(de)
	or a
	jr z,@normalStatus
	ld a,$63
	call playSound
	ld h,d
	ld l,$ab
	ld (hl),$3c
	ld l,$a9
	dec (hl)
	jr nz,+
	ld l,$a4
	res 7,(hl)
+
	ld e,$b2
	ld a,$1e
	ld (de),a
	ld a,$83
	call playSound
@normalStatus:
	call func_6257
	call func_6273
	call ecom_getSubidAndCpStateTo08
	cp $0a
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
	.dw @state8
	.dw @state9
+
	call func_62b1
	ld a,b
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@state0:
	ld bc,$010c
	call enemyBoss_spawnShadow
	ret nz
	call ecom_setSpeedAndState8
	ld l,$bf
	set 5,(hl)
	ld b,$00
	ld a,$77
	jp enemyBoss_initializeRoom

@stateStub:
	ret

@state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	ld a,(wcc93)
	or a
	ret nz
	inc a
	ld (de),a
	ld ($cca4),a
	ret

@@substate1:
	call ecom_decCounter2
	ret nz
	ld b,$02
	call checkBPartSlotsAvailable
	ret nz
	ld e,$86
	ld a,(de)
	ld hl,@@table_6169
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreePartSlot
	ld (hl),PART_3d
	inc l
	ld (hl),$03
	inc l
	inc (hl)
	ld l,$cb
	ld (hl),b
	ld l,$cd
	ld (hl),c
	call getFreePartSlot
	ld (hl),PART_3e
	ld l,$c3
	inc (hl)
	ld l,$cb
	ld a,$58
	sub b
	add $58
	ldi (hl),a
	inc l
	ld a,$78
	sub c
	add $78
	ld (hl),a
	ld l,$d6
	ld a,$80
	ldi (hl),a
	ld (hl),d
	ld h,d
	ld l,$87
	ld (hl),$0f
	dec l
	inc (hl)
	ldd a,(hl)
	cp $10
	ret c
	inc (hl)
	ret

@@table_6169:
	.db $20 $78
	.db $28 $50
	.db $3c $30
	.db $58 $20
	.db $70 $34
	.db $7c $58
	.db $80 $78
	.db $70 $a0
	.db $58 $b8
	.db $40 $a0
	.db $38 $78
	.db $40 $60
	.db $58 $48
	.db $64 $5c
	.db $68 $70
	.db $5c $84

@@substate2:
	call ecom_decCounter1
	ret nz
	ldbc INTERAC_PUFF $02
	call objectCreateInteraction
	ret nz
	ld a,h
	ld h,d
	ld l,$99
	ldd (hl),a
	ld (hl),$40
	ld l,$85
	inc (hl)
	ret

@@substate3:
	ld a,$21
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$86
	ld (hl),$3c
	ld l,$8b
	ld (hl),$56
	ld l,$8f
	ld (hl),$fe
	call objectSetVisible83
	xor a
	ld ($cca4),a
	ld a,$2d
	ld (wActiveMusic),a
	jp playSound

@state9:
	call ecom_decCounter1
	jp nz,enemyAnimate
	ld l,e
	inc (hl)
	ret

@subid0:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD

@@stateA:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$55
	ld l,$b4
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	jr @@animate

@@stateB:
	ld a,(wFrameCounter)
	and $0f
	ld a,$ae
	call z,playSound
	call func_62cc
	call nc,ecom_moveTowardPosition
@@animate:
	jp enemyAnimate

@@stateC:
	call ecom_decCounter1
	jr z,+
	call func_62f3
	jr @@animate
+
	call func_62a8
	call func_6304
	jr @@animate

@@stateD:
	call ecom_decCounter1
	jr nz,@@animate
	ld l,e
	ld (hl),$0a
	jr @@animate

@subid1:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw @@stateA
	.dw @subid0@stateB
	.dw @@stateC
	.dw @@stateD

@@stateA:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$6e
	jp func_6326
	
@@stateC:
	call ecom_decCounter1
	jr z,+
	call func_62f3
	jr @@animate
+
	call func_62a8
	ld b,PART_3e
	call ecom_spawnProjectile
@@animate:
	jp enemyAnimate
	
@@stateD:
	call ecom_decCounter1
	jr nz,@@animate
	ld l,e
	ld (hl),$0b
	call func_6326
	jr @@animate

func_6257:
	ld e,$b0
	ld a,(de)
	cp $04
	ret c
	call ecom_decCounter1
	jr z,+
	pop hl
	jp enemyAnimate
+
	ld l,$b0
	ld (hl),$00
	ld l,$b2
	ld (hl),$5a
	ld a,$83
	jp playSound

func_6273:
	ld h,d
	ld l,$b2
	ld a,(hl)
	or a
	ret z
	ld e,$ab
	ld a,(de)
	or a

seasonsFunc_0e_627d:
	jr z,+
	pop bc
	ret
+
	dec (hl)
	jr z,++
	pop bc
	ld a,(hl)
	and $03
	jr nz,+
	ld l,$9b
	ld a,(hl)
	and $01
	inc a
	ldi (hl),a
	ld (hl),a
+
	jp enemyAnimate
++
	ld l,$82
	ld a,(hl)
	inc a
	and $01
	ld (hl),a
	ld b,a
	ld a,$02
	sub b
	ld l,$9b
	ldi (hl),a
	ld (hl),a
	ld l,$84
	ld (hl),$0a
	ld l,$a4
	set 7,(hl)
	ld l,$b0
	ld (hl),$00
	ret

func_62b1:
	ld h,d
	ld l,$b1
	dec (hl)
	ld a,(hl)
	and $0f
	ret nz
	ld a,(hl)
	and $30
	swap a
	ld hl,table_62c8
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,$8f
	ld (hl),a
	ret

table_62c8:
	.db $ff
	.db $fe
	.db $fd
	.db $fe

func_62cc:
	.db $62
	ld l,$b4
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	ret nc
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$28
	ret

func_62a8:
	ld (hl),$78
	inc l
	ld (hl),$96
	ld l,e
	inc (hl)
	ld l,$b0
	inc (hl)
	ret

func_62f3:
	ld a,(hl)
	and $03
	ld hl,table_6300
	rst_addAToHl
	ld e,$8d
	ld a,(de)
	add (hl)
	ld (de),a
	ret

table_6300:
	.db $ff
	.db $01
	.db $01
	.db $ff

func_6304:
	call objectGetAngleTowardEnemyTarget
	ld b,a
	call getRandomNumber
	cp $55
	ld a,b
	jr c,func_631a
	sub $02
	and $1f
	call func_631a
	ld a,b
	add $04
func_631a:
	push af
	ld b,PART_3d
	call ecom_spawnProjectile
	pop bc
	ret nz
	ld l,$c9
	ld (hl),b
	ret
	
func_6326:
	call getRandomNumber_noPreserveVars
	and $0e
	ld h,d
	ld l,$b3
	cp (hl)
	jr z,func_6326
	ld (hl),a
	ld hl,table_633e
	rst_addAToHl
	ld e,$b4
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

table_633e:
	.db $20 $78 $40 $38
	.db $78 $58 $58 $78
	.db $78 $98 $40 $b8
	.db $68 $38 $68 $b8
