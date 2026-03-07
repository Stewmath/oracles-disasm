; ==================================================================================================
; ENEMY_MOTHULA_CHILD
; ==================================================================================================
enemyCode47:
	jr z,+
	sub $03
	ret c
	jp z,enemyDie_uncounted
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret
+
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state5
	.dw @state_stub
	.dw @state_stub
+
	ld a,b
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@state0:
	bit 7,b
	ld a,$46
	jp z,ecom_setSpeedAndState8AndVisible
	ld a,$01
	ld (de),a

@state1:
	bit 0,b
	ld bc,$0400
	jr z,+
	ld bc,$0604
+
	push bc
	call checkBEnemySlotsAvailable
	pop bc
	ret nz
	ld a,b
	ldh (<hFF8B),a
	ld a,c
	ld bc,@seasonsTable_0d_7017
	call addAToBc
-
	push bc
	ld b,ENEMY_MOTHULA_CHILD
	call ecom_spawnUncountedEnemyWithSubid01
	dec (hl)
	call objectCopyPosition
	dec l
	ld a,(hl)
	ld (hl),$00
	ld l,$8b
	add (hl)
	ld (hl),a
	pop bc
	ld l,$89
	ld a,(bc)
	ld (hl),a
	inc bc
	ld hl,$ff8b
	dec (hl)
	jr nz,-
	jp enemyDelete

@seasonsTable_0d_7017:
	.db $04 $0c $14 $1c $00
	.db $05 $0b $10 $15 $1b

@state5:
	call ecom_galeSeedEffect
	ret c
	jp enemyDelete

@state_stub:
	ret

@subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9

@@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$86
	ld (hl),$04
	inc l
	ld (hl),$3c
	call seasonsFunc_0d_7089
	jp objectSetVisible82

@@state9:
	call ecom_decCounter2
	jr z,+
	call ecom_decCounter1
	jr nz,+
	ld (hl),$04
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	call seasonsFunc_0d_7089
+
	call objectApplySpeed
	call seasonsFunc_0d_7078
	jp enemyAnimate

@subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @ret1
@ret1:
	ret

@subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @ret2
@ret2:
	ret

@subid3:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @ret3
@ret3:
	ret

seasonsFunc_0d_7078:
	ld e,$8b
	ld a,(de)
	cp $b8
	jr nc,+
	ld e,$8d
	ld a,(de)
	cp $f8
	ret c
+
	pop hl
	jp enemyDelete

seasonsFunc_0d_7089:
	ld h,d
	ld l,$89
	ldd a,(hl)
	add $02
	and $1c
	rrca
	rrca
	cp (hl)
	ret z
	ld (hl),a
	jp enemySetAnimation
