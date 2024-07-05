; ==================================================================================================
; ENEMY_POKEY
; ==================================================================================================
enemyCode11:
	jr z,++
	sub $03
	ret c
	jr nz,+
	ld e,Enemy.var03
	ld a,(de)
	cp $03
	jp nz,pokeyFunc_0c_6ba8
	call ecom_killRelatedObj1
	ld l,$b3
	ld (hl),$00
	ld l,$b1
	push hl
	ld h,(hl)
	call ecom_killObjectH
	pop hl
	inc l
	ld h,(hl)
	call ecom_killObjectH
	jp enemyDie
+
	ld e,Enemy.var2a
	ld a,(de)
	cp $9a
	call z,pokeyFunc_0c_6bfe
	call pokeyFunc_0c_6c3e
	ld e,Enemy.collisionType
	ld a,(de)
	rlca
	ret nc
++
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw pokey_state_0
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
	.dw pokey_state_stub
+
	ld e,Enemy.var03
	ld a,(de)
	or a
	call z,ecom_decCounter1
	ld a,$33
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret z
	dec b
	ld a,b
	rst_jumpTable
	.dw pokey_6b05
	.dw pokey_6b2e
	.dw pokey_6b35
	.dw pokey_6b3c
	.dw pokey_state_stub

pokey_state_0:
	ld a,b
	or a
	jr nz,+
	ld b,$04
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMY_POKEY
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$05
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),h
	call objectCopyPosition
	ld l,$b0
	ld (hl),h
	ld c,h
	ld e,$03
	inc l
-
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	ld a,$04
	sub e
	ld (hl),a
	inc l
	ld (hl),a
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),c
	push de
	call objectCopyPosition
	pop de
	ld a,h
	pop hl
	ldi (hl),a
	dec e
	jr nz,-
	ld h,a
	ld l,$80
	ld e,l
	ld a,(de)
	ld (hl),a
	jp enemyDelete
+
	cp $03
	ld a,$01
	call nz,enemySetAnimation
	ld a,$0f
	call ecom_setSpeedAndState8
	ld l,$bf
	set 5,(hl)
	ld l,$82
	ld a,(hl)
	cp $05
	jr z,+++
	ld b,a
	ld a,$30
	call objectGetRelatedObject1Var
	ld e,l
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	dec b
	jr z,++
	dec b
	ld a,$f3
	jr z,+
	add a
+
	ld e,$8f
	ld (de),a
++
	jp objectSetVisible82
+++
	ld l,$a4
	res 7,(hl)
	call getRandomNumber_noPreserveVars
	ld e,$86
	ld (de),a
	ret

pokey_state_stub:
	ret

pokey_6b05:
	ld e,$8f
	ld a,(de)
	or a
	jr z,+
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jp nz,objectSetVisiblec2
	ld l,$94
	xor a
	ldi (hl),a
	ld (hl),a
+
	ld a,$10
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(hl)
	ld (de),a
	ld l,$86
	ld a,(hl)
	and $3f
	call z,ecom_setRandomAngle
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp objectSetPriorityRelativeToLink

pokey_6b2e:
	ld b,$f3
	call pokeyFunc_0c_6b8e
	jr +

pokey_6b35:
	ld b,$e6
	call pokeyFunc_0c_6b8e
	jr +

pokey_6b3c:
	ld b,$d9
	call pokeyFunc_0c_6b8e

+
	ld a,$06
	call objectGetRelatedObject1Var
	ld a,(hl)
	and $1c
	rrca
	rrca
	ld b,a
	ld e,$82
	ld a,(de)
	sub $02
	swap a
	rrca
	add b
	ld hl,pokeyTable_0c_6b6a
	rst_addAToHl
	ld b,(hl)
	call pokeyFunc_0c_6b82
	ld l,$8b
	ld e,l
	ldi a,(hl)
	ld (de),a
	inc l
	ld e,l
	ld a,(hl)
	add b
	ld (de),a
	jp objectSetPriorityRelativeToLink

pokeyTable_0c_6b6a:
	.db $ff $ff $00 $00 $01 $01 $00 $00
	.db $01 $02 $01 $00 $ff $fe $ff $00
	.db $ff $fe $ff $00 $01 $02 $01 $00

pokeyFunc_0c_6b82:
	ld e,$af
	ld l,$82
-
	inc e
	ld a,(de)
	ld h,a
	ld a,(hl)
	dec a
	jr nz,-
	ret
pokeyFunc_0c_6b8e:
	ld h,d
	ld l,$8f
	ld a,(hl)
	cp b
	ret z
	or a
	jr z,+
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ld l,$8f
	ld a,(hl)
	cp b
	ret c
+
	ld (hl),b
	ld l,$94
	xor a
	ldi (hl),a
	ld (hl),a
	ret

pokeyFunc_0c_6ba8:
	ld a,$33
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,+
	ld e,$82
	ld a,(de)
	cp $05
	jp nz,enemyDie_uncounted_withoutItemDrop
	jp enemyDelete
+
	ld e,$83
	ld a,(de)
	add $b1
	ld l,a
	ld h,d
	ld c,$82
	sub $b3
	jr z,+
	inc a
	call nz,pokeyFunc_0c_6bf5
	call pokeyFunc_0c_6bf5
+
	call pokeyFunc_0c_6bf5
	ld l,$a4
	res 7,(hl)
	ld l,$a9
	ld (hl),$05
	ld l,$82
	ld (hl),$05
	ld b,$02
	call ecom_spawnProjectile
	jr nz,+
	ld l,$c7
	ld (hl),$80
	ld a,$73
	call playSound
+
	call objectSetInvisible
	jp pokeyFunc_0c_6c3e

pokeyFunc_0c_6bf5:
	ld b,(hl)
	inc l
	ld a,(bc)
	cp $05
	ret nc
	dec a
	ld (bc),a
	ret

pokeyFunc_0c_6bfe:
	ld h,d
	ld l,$b3
	ld c,$82
	ld b,(hl)
-
	ld a,(bc)
	ld e,a
	dec l
	ld a,$af
	cp l
	ret nc
	ld b,(hl)
	ld a,(bc)
	cp $05
	jr nz,-
	ld h,e
	push hl
	call pokeyFunc_0c_6b82
	ld l,$8b
	ld c,l
	ldi a,(hl)
	ld (bc),a
	inc l
	ld c,l
	ld a,(hl)
	ld (bc),a
	ld c,$8f
	xor a
	ld (bc),a
	ld c,$a4
	ld a,(bc)
	or $80
	ld (bc),a
	pop hl
	ld c,$82
	ld a,h
	ld (bc),a
	ld h,d
-
	inc l
	ld a,$b3
	cp l
	ret c
	ld b,(hl)
	ld a,(bc)
	cp $05
	jr z,-
	inc a
	ld (bc),a
	jr -

pokeyFunc_0c_6c3e:
	ld bc,$0404
	ld l,$82
	ld e,$b4
-
	dec e
	ld a,(de)
	ld h,a
	ld a,(hl)
	cp $05
	jr z,+
	dec b
+
	dec c
	jr nz,-
	ld a,b
	ld bc,pokeyTable_0c_6c5d
	call addAToBc
	ld l,$90
	ld a,(bc)
	ld (hl),a
	ret

pokeyTable_0c_6c5d:
	.db $0a $0f $1e $3c
