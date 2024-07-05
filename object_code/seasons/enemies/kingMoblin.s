; ==================================================================================================
; ENEMY_KING_MOBLIN
; ==================================================================================================
enemyCode07:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	; just hit
	ret nz
	; knockback
	ld e,$aa
	ld a,(de)
	cp $97
	jr nz,@normalStatus
	ld e,$a9
	ld a,(de)
	or a
	call nz,func_6f20
	ld a,$63
	jp playSound
@dead:
	ld h,d
	ld l,$84
	ld (hl),$0e
	inc l
	ld (hl),$00
	ld l,$a4
	res 7,(hl)
@normalStatus:
	ld e,Enemy.state
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
	.dw @stateD
	.dw @stateE

@state0:
	ld a,$07
	ld ($cc1c),a
	ld a,$8c
	call loadPaletteHeader
	ld a,$14
	call ecom_setSpeedAndState8
	ld e,$88
	ld a,$02
	ld (de),a
	call enemySetAnimation
	jp objectSetVisible83

@stateStub:
	ret

@state8:
	ld hl,$cfc0
	bit 0,(hl)
	jp z,enemyAnimate
	ld (hl),$00
	ld h,d
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$14

@state9:
	call getRandomNumber_noPreserveVars
	and $07
	cp $07
	jr z,@state9
	ld h,d
	ld l,$b0
	cp (hl)
	jr z,@state9
	ld (hl),a
	ld hl,@table_6e03
	rst_addAToHl
	ld e,$8d
	ld a,(de)
	cp (hl)
	jr z,@state9
	ld e,$b1
	ld a,(hl)
	ld (de),a
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$8d
	ld a,(hl)
	ld l,$b1
	cp (hl)
	ld a,$03
	ld b,$18
	jr nc,+
	ld a,$01
	ld b,$08
+
	ld l,$88
	ldi (hl),a
	ld (hl),b
	jp enemySetAnimation

@table_6e03:
	.db $50
	.db $20
	.db $30
	.db $40
	.db $60
	.db $70
	.db $80

@stateA:
	call objectApplySpeed
	ld h,d
	ld l,$8d
	ld a,(hl)
	ld l,$b1
	sub (hl)
	inc a
	cp $03
	jr nc,@animate
	ld l,$84
	inc (hl)
	call func_6f2e
	ld e,$88
	xor a
	ld (de),a
	jp enemySetAnimation

@stateB:
	call ecom_decCounter1
	jr nz,@animate
	inc (hl)
	ld b,PART_KING_MOBLIN_BOMB
	call ecom_spawnProjectile
	ret nz
	ld e,$84
	ld a,$0c
	ld (de),a
	ld e,$88
	ld a,$04
	ld (de),a
	jp enemySetAnimation

@stateC:
	call func_6f40
	ret nc
	inc a
	ret nz
	ld e,$84
	ld a,$0d
	ld (de),a
	call func_6f2e
	ld e,$88
	ld a,$02
	ld (de),a
	jp enemySetAnimation

@stateD:
	call ecom_decCounter1
	jr nz,@animate
	ld l,e
	ld (hl),$09
@animate:
	jp enemyAnimate

@stateE:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substateStub
	
@substate0:
	call checkLinkCollisionsEnabled
	ret nc
	ld h,d
	ld l,$85
	inc (hl)
	ld l,$87
	ld (hl),$3c
	ld l,$a9
	ld (hl),$01
	ld a,$01
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $3f
	jr nz,+
	ld l,$c4
	ld a,(hl)
	dec a
	jr nz,+
	ld (hl),$06
	ld l,$cb
	ld e,$8b
	ld a,(de)
	sub $10
	ld (hl),a
	ld e,$b3
	ld a,$01
	ld (de),a
	ld ($cc02),a
	ld ($cca4),a
+
	ld a,$05
	jp enemySetAnimation
	
@substate1:
	call ecom_decCounter2
	ret nz
	ld l,$b3
	bit 0,(hl)
	jr z,+
	ld l,e
	inc (hl)
	ret
+
	ld l,$a4
	set 7,(hl)
	ld l,$84
	ld (hl),$09
	ld l,$b4
	bit 0,(hl)
	ret nz
	inc (hl)
	; You can't beat me this way
	ld bc,TX_3f06
	jp showText
	
@substate2:
	ld a,$04
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $05
	ret nz
	ld h,d
	ld l,$85
	inc (hl)
	inc l
	ld (hl),$01
	inc l
	ld (hl),$06
	ret
	
@substate3:
	call ecom_decCounter1
	ret nz
	inc (hl)
	inc l
	ld a,(hl)
	dec a
	ld hl,@table_6f13
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_EXPLOSION
	ld l,$4b
	ld (hl),b
	ld l,$4d
	ld (hl),c
	ld a,c
	and $f0
	swap a
	ld c,a
	ld a,$ac
	call setTile
	call ecom_decCounter2
	ld l,$86
	ld (hl),$0f
	ret nz
	ld l,$85
	inc (hl)
	ld a,$01
	ld ($cfc0),a
	ret

@table_6f13:
	.db $08 $78
	.db $0c $38
	.db $0a $60
	.db $08 $48
	.db $04 $24
	.db $06 $5a

@substateStub:
	ret

func_6f20:
	dec a
	ld hl,table_6f20
	rst_addAToHl
	ld e,$90
	ld a,(hl)
	ld (de),a
	ret

table_6f20:
	.db SPEED_200
	.db SPEED_180
	.db SPEED_100
	.db SPEED_0c0
	
func_6f2e:
	ld e,$a9
	ld a,(de)
	dec a
	ld hl,table_6f3b
	rst_addAToHl
	ld e,$86
	ld a,(hl)
	ld (de),a
	ret

table_6f3b:
	.db $14
	.db $1e
	.db $28
	.db $32
	.db $3c
	
func_6f40:
	call enemyAnimate
	ld e,$a1
	ld a,(de)
	rlca
	ret c
	cp $06
	jr nz,+
	ld a,$80
	ld (de),a
	ld a,$04
	call objectGetRelatedObject2Var
	ld (hl),$03
	ld l,$e4
	set 7,(hl)
	ret
+
	ld e,$a1
	ld a,(de)
	ld hl,table_6f6f
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	ld a,$0b
	call objectGetRelatedObject2Var
	call objectCopyPositionWithOffset
	or d
	ret

table_6f6f:
	.db $08 $00
	.db $f6 $00
	.db $ee $00
