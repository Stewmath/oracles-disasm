; ==================================================================================================
; ENEMY_BLAINOS_GLOVES
; ==================================================================================================
enemyCode5f:
	jr z,++
	call seasonsFunc_0d_7986
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_BLAINO_GLOVE
	jr nz,++
	ld e,$aa
	ld a,(de)
	res 7,a
	sub $0a
	cp $02
	jr nc,++
	ld h,d
	ld l,$84
	ld (hl),$02
	ld l,$a4
	res 7,(hl)
	ld l,$87
	ld (hl),$1e
	ld l,$8e
	xor a
	ldi (hl),a
	ld (hl),a
	ld a,$2b
	call objectGetRelatedObject1Var
	ld (hl),$f8
	ld l,Enemy.z
	xor a
	ldi (hl),a
	ld (hl),a
++
	call seasonsFunc_0d_785c
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a

@state1:
	call seasonsFunc_0d_786d
	ld b,h
	ld e,Enemy.substate
	ld a,(hl)
	rst_jumpTable
	.dw @seasonsFunc_0d_76fa
	.dw @seasonsFunc_0d_76fa
	.dw @state1zh2
	.dw @state1zh3
	.dw @state1zh4
	.dw @state1zh5

@state2:
	call ecom_decCounter2
	jr z,+
	ld a,$2e
	call objectGetRelatedObject1Var
	ld (hl),$02
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLAINO_VULNERABLE
	jr ++
+
	ld l,e
	dec (hl)
	ld l,$a4
	set 7,(hl)
	ld a,$25
	call objectGetRelatedObject1Var
	ld (hl),$56
++
	jp seasonsFunc_0d_796d

@state3:
	ld a,$2b
	call objectGetRelatedObject1Var
	ld e,$ab
	ld a,(hl)
	ld (de),a
	jp seasonsFunc_0d_796d

@seasonsFunc_0d_76fa:
	ld h,b
	jp seasonsFunc_0d_7883

@state1zh2:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLAINO_GLOVE_SOFT_PUNCH

@@substate1:
	call @seasonsFunc_0d_76fa
	ld l,$b0
	ld a,(hl)
	add a
	add a
	ld b,a
	ld a,(wFrameCounter)
	and $04
	rrca
	add b
	ld hl,@seasonsTable_0d_772b
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

@seasonsTable_0d_772b:
	.db $f8 $00 $fb $00
	.db $00 $08 $00 $05
	.db $08 $00 $05 $00
	.db $00 $f8 $00 $fb

@state1zh3:
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
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	ld l,$90
	ld (hl),$0a
	ld l,$87
	ld (hl),$1e
	call @seasonsFunc_0d_76fa
	ld l,$b0
	ld a,(hl)
	rrca
	swap a
	xor $10
	ld e,$89
	ld (de),a
	call seasonsFunc_0d_78ce

@@substate1:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78bc
	ld (hl),$04
	ld l,e
	inc (hl)

@@substate2:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78ab
	ld (hl),$0a
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$78
	ld l,$89
	ld a,(hl)
	xor $10
	ld (hl),a

@@substate3:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78bc
	ld (hl),$14
	ld l,e
	inc (hl)

@@substate4:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78ab
	ld (hl),$14
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$28
	ld l,$89
	ld a,(hl)
	xor $10
	ld (hl),a

@@substate5:
	call ecom_decCounter2
	jp nz,seasonsFunc_0d_78bc
	jp @seasonsFunc_0d_76fa

@state1zh4:
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
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLAINO_GLOVE_SOFT_PUNCH

@@substate1:
	call @seasonsFunc_0d_76fa
	ld a,$05
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $02
	ret c
	ld l,$89
	ld e,$89
	ld a,(hl)
	ld (de),a
	call seasonsFunc_0d_78ce
	ld bc,$ff80
	call objectSetSpeedZ
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLAINO_GLOVE_HARD_PUNCH
	ld l,$85
	inc (hl)
	ld l,$87
	ld (hl),$0a
	ld l,$90
	ld (hl),$50

@@substate2:
	call ecom_decCounter2
	jr nz,+
	ld (hl),$08
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$64
	ld l,$89
	ld a,(hl)
	xor $10
	ld (hl),a
+
	call seasonsFunc_0d_78bc
	jp seasonsFunc_0d_78e1

@@substate3:
	call ecom_decCounter2
	jp z,@seasonsFunc_0d_76fa
	ld l,$8f
	inc (hl)
	inc (hl)
	jp seasonsFunc_0d_78bc

@state1zh5:
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld h,d
	ld l,$85
	inc (hl)
	ld l,$a4
	res 7,(hl)
	inc l
	ld (hl),$58

@@substate1:
	ld a,$05
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $02
	jp c,seasonsFunc_0d_78f8
	ld h,d
	ld l,$87
	ld (hl),$1e
	ld l,$a6
	ld a,$08
	ldi (hl),a
	ld (hl),a
	ld l,$a4
	set 7,(hl)
	ld l,$85
	inc (hl)
	ld l,$94
	ld a,$c0
	ldi (hl),a
	ld (hl),$fb

@@substate2:
	call ecom_decCounter2
	jr z,+
	ld l,$a6
	ld a,$06
	ldi (hl),a
	ld (hl),a
+
	call seasonsFunc_0d_7915
	call seasonsFunc_0d_78f8
	ld c,$34
	jp objectUpdateSpeedZ_paramC

seasonsFunc_0d_785c:
	ld e,$84
	ld a,(de)
	or a
	ret z
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $54
	ret z
	jp enemyDelete

seasonsFunc_0d_786d:
	ld a,$31
	call objectGetRelatedObject1Var
	ld e,Enemy.var31
	ld a,(de)
	cp (hl)
	ret z
	ld a,(hl)
	ld (de),a
	ld e,Enemy.enemyCollisionMode
	ld a,ENEMYCOLLISION_BLAINO_GLOVE
	ld (de),a
	ld e,$85
	xor a
	ld (de),a
	ret

seasonsFunc_0d_7883:
	ld l,$b0
	ld a,(hl)
	push hl
	ld hl,seasonsTable_0d_78a3
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	pop hl
	ld l,$8f
	ld e,$8f
	ld a,(hl)
	ld (de),a

seasonsFunc_0d_7895:
	call objectTakePositionWithOffset

seasonsFunc_0d_7898:
	ld l,$b0
	ld a,(hl)
	cp $02
	jp c,objectSetVisible82
	jp objectSetVisible81

seasonsTable_0d_78a3:
	.db $fb $fc $01 $06
	.db $04 $04 $01 $fc

seasonsFunc_0d_78ab:
	ld l,$b2
	ld b,(hl)
	inc l
	ld c,(hl)
	ld a,$0b
	call objectGetRelatedObject1Var
	push hl
	call seasonsFunc_0d_7895
	pop hl
	jr seasonsFunc_0d_78ce

seasonsFunc_0d_78bc:
	ld l,$b2
	ld b,(hl)
	inc l
	ld c,(hl)
	ld a,$0b
	call objectGetRelatedObject1Var
	push hl
	call seasonsFunc_0d_7895
	call objectApplySpeed
	pop hl

seasonsFunc_0d_78ce:
	ld l,$8b
	ld e,$8b
	ld a,(de)
	sub (hl)
	ld e,$b2
	ld (de),a
	ld l,$8d
	ld e,$8d
	ld a,(de)
	sub (hl)
	ld e,$b3
	ld (de),a
	ret

seasonsFunc_0d_78e1:
	ld h,d
	ld l,$94
	ld e,$8e
	ld a,(de)
	sub (hl)
	ld (de),a
	inc l
	inc e
	ld a,(de)
	sbc (hl)
	ld (de),a
	dec l
	ld a,(hl)
	add $80
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a
	ret

seasonsFunc_0d_78f8:
	ld a,$21
	call objectGetRelatedObject1Var
	push hl
	ld a,(hl)
	ld hl,seasonsTable_0d_78a3
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	pop hl
	call objectTakePositionWithOffset
	ld l,$a1
	ld a,(hl)
	cp $02
	jp c,objectSetVisible82
	jp objectSetVisible81

seasonsFunc_0d_7915:
	call seasonsFunc_0d_795c
	ld l,$aa
	ld a,(hl)
	cp $80
	ret nz
	ld l,$b4
	ld (hl),$08
	ld hl,$d00f
	ld a,(hl)
	sub $08
	ld (hl),a
	ld l,$2b
	ld (hl),$00
	ld l,$2d
	ld (hl),$00
	ld a,$09
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld ($d02c),a
	add $04
	and $18
	rrca
	rrca
	ld hl,seasonsTable_0d_7954
	rst_addAToHl
	ld e,$8b
	ld a,(de)
	add (hl)
	ld ($d00b),a
	inc hl
	ld e,$8d
	ld a,(de)
	add (hl)
	ld ($d00d),a
	ret

seasonsTable_0d_7954:
	.db $fc $00 $00 $04
	.db $04 $00 $00 $fc

seasonsFunc_0d_795c:
	ld h,d
	ld l,$b4
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret nz
	ld a,$14
	ld ($d02b),a
	ld ($d02d),a
	ret

seasonsFunc_0d_796d:
	ld a,$30
	call objectGetRelatedObject1Var
	ld a,(hl)
	push hl
	ld hl,seasonsTable_0d_7982
	rst_addAToHl
	ld c,(hl)
	ld b,$f8
	pop hl
	call objectTakePositionWithOffset
	jp seasonsFunc_0d_7898

seasonsTable_0d_7982:
	.db $fb $fc $05 $04

seasonsFunc_0d_7986:
	ld e,$ab
	ld a,(de)
	bit 7,a
	ret z
	xor a
	ld (de),a
	ret
