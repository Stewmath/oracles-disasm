; ==================================================================================================
; ENEMY_ROLLING_SPIKE_TRAP
; ==================================================================================================
enemyCode0f:
	dec a
	ret z
	dec a
	ret z
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state00
	.dw @state01
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
+
	ld a,b
	sub $08
	rst_jumpTable
	.dw @state08
	.dw @state09

@state00:
	ld e,Enemy.var3e
	ld a,$08
	ld (de),a
	ld a,b
	sub $08
	jp nc,seasonsFunc_0c_68d6
	ld e,Enemy.state
	ld a,$01
	ld (de),a

@state01:
	ld a,b
	ld hl,@seasonsTable_0c_686e
	rst_addAToHl
	ld b,(hl)
	call checkBEnemySlotsAvailable
	ret nz
	call copyVar03ToVar30
	ld b,ENEMY_ROLLING_SPIKE_TRAP
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$08
	call seasonsFunc_0c_68c8
	call seasonsFunc_0c_68fa
	call seasonsFunc_0c_6992
	jp enemyDelete

@seasonsTable_0c_686e:
	.db $03 $03 $03 $04 $04 $04 $05 $05

@state_stub:
	ret

@state08:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	call seasonsFunc_0c_699d
	ld l,$84
	inc (hl)
	call seasonsFunc_0c_69b4
	ld e,Enemy.var31
	ld a,(de)
	ld e,$99
	ld (de),a
	dec e
	ld a,$80
	ld (de),a

@@substate1:
	call seasonsFunc_0c_69c9
	call seasonsFunc_0c_69d2
	ret z
	jp seasonsFunc_0c_69fd

@state09:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.angle
	ld (hl),$08
	ld l,$b0
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	jr ++

@@substate1:
	call ecom_decCounter1
	jr nz,+
	ld e,Enemy.var30
	ld a,(de)
	ld (hl),a
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
+
	call objectApplySpeed
++
	jp enemyAnimate

seasonsFunc_0c_68c8:
	ld e,Enemy.var30
	ld l,e
	ld a,(de)
	ld (hl),a
	ld e,Enemy.subid
	ld l,Enemy.var03
	ld a,(de)
	ld (hl),a
	jp objectCopyPosition

seasonsFunc_0c_68d6:
	jr z,+
	ld e,Enemy.var31
	ld a,(de)
	ld c,a
	ld hl,seasonsTable_0c_68ed
	rst_addAToHl
	ld e,Enemy.collisionRadiusY
	ld a,(hl)
	ld (de),a
	ld a,c
	call enemySetAnimation
	ld a,$1e
+
	jp ecom_setSpeedAndState8

seasonsTable_0c_68ed:
	.db $06 $06 $0e $16 $19

copyVar03ToVar30:
	ld h,d
	ld l,Enemy.var03
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a
	ret

seasonsFunc_0c_68fa:
	push hl
	ld c,h
	ld e,Enemy.subid
	ld a,(de)
	ld hl,seasonsTable_0c_694c
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,Enemy.var30
-
	push hl
	inc e
	push de
	call seasonsFunc_0c_6925
	push bc
	ld b,ENEMY_ROLLING_SPIKE_TRAP
	call ecom_spawnEnemyWithSubid01
	ld (hl),$09
	pop bc
	ld a,e
	pop de
	call seasonsFunc_0c_692f
	pop hl
	inc hl
	inc hl
	ld a,(hl)
	inc a
	jr nz,-
	pop hl
	ret

seasonsFunc_0c_6925:
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld b,a
	ld e,c
	inc hl
	ld c,(hl)
	inc hl
	ret

seasonsFunc_0c_692f:
	push de
	ld l,$97
	ldd (hl),a
	ld (hl),$80
	ld a,h
	ld (de),a
	ld l,Enemy.xh
	ld e,l
	ld a,(de)
	ldd (hl),a
	dec l
	ld (hl),b
	ld d,h
	ld e,l
	ld a,c
	ld e,Enemy.var31
	ld (de),a
	call enemySetAnimation
	call objectSetVisible82
	pop de
	ret

seasonsTable_0c_694c:
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7

@subid0: ; $695c
	.db $f8 $00
	.db $08 $01
	.db $ff
@subid1: ; $6961
	.db $f8 $02
	.db $10 $01
	.db $ff
@subid2: ; $6966
	.db $f8 $03
	.db $18 $01
	.db $ff
@subid3: ; $696b
	.db $e0 $00
	.db $00 $04
	.db $20 $01
	.db $ff ;
@subid4: ; $6972
	.db $e0 $02
	.db $08 $04
	.db $28 $01
	.db $ff
@subid5: ; $6979
	.db $e0 $03
	.db $10 $04
	.db $30 $01
	.db $ff
@subid6: ; $6980
	.db $c8 $00
	.db $e8 $04
	.db $18 $04
	.db $38 $01
	.db $ff
@subid7: ; $6989
	.db $c8 $02
	.db $f0 $04
	.db $20 $04
	.db $40 $01
	.db $ff

seasonsFunc_0c_6992:
	ld b,$04
	ld l,Enemy.var31
-
	ld e,l
	ld a,(de)
	ldi (hl),a
	dec b
	jr nz,-
	ret

seasonsFunc_0c_699d:
	ld h,d
	ld e,Enemy.var30
	ld l,Enemy.var31
-
	ldi a,(hl)
	ld b,a
	ld c,$81
	ld a,(bc)
	cp $0f
	jr nz,+
	ld c,e
	ld a,(de)
	ld (bc),a
+
	ld a,$b5
	cp l
	jr nz,-
	ret

seasonsFunc_0c_69b4:
	ld e,Enemy.var03
	ld a,(de)
	ld hl,seasonsTable_0c_69c1
	rst_addAToHl
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

seasonsTable_0c_69c1:
	.db $f8 $f0 $e8 $e0 $d8 $d0 $c8 $c0

seasonsFunc_0c_69c9:
	ld a,$0d
	call objectGetRelatedObject2Var
	ld e,l
	ld a,(hl)
	ld (de),a
	ret

seasonsFunc_0c_69d2:
	ld a,$09
	call objectGetRelatedObject2Var
	ld c,$f7
	bit 4,(hl)
	jr nz,+
	ld c,$08
+
	ld e,Enemy.xh
	ld a,(de)
	add c
	ld c,a
	ld e,Enemy.yh
	ld a,(de)
	ld b,a
	ld e,Enemy.var03
	ld a,(de)
	add $02
	ld e,a
-
	call getTileCollisionsAtPosition
	dec a
	cp $0f
	ret c
	ld a,b
	add $10
	ld b,a
	dec e
	jr nz,-
	ret

seasonsFunc_0c_69fd:
	ld h,d
	ld l,Enemy.var31
-
	ldi a,(hl)
	ld b,a
	ld c,$81
	ld a,(bc)
	cp $0f
	jr nz,+
	ld c,$86
	ld a,$01
	ld (bc),a
+
	ld a,$b5
	cp l
	jr nz,-
	ret
