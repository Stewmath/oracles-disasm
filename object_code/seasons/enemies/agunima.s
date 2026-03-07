; ==================================================================================================
; ENEMY_AGUNIMA
; ==================================================================================================
enemyCode73:
	jr z,@normalStatus
	sub $04
	jr z,@justHit
	inc a
	ret nz
	; dead
	ld e,$b0
	ld a,(de)
	bit 7,a
	jp z,enemyDelete
	ld a,(wFrameCounter)
	and $0f
	jr nz,+
	ld e,$b3
	ld a,(de)
	sub $04
	and $0c
	ld (de),a
	call enemySetAnimation
+
	jp enemyBoss_dead
@justHit:
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_AGUNIMA_INVULNERABLE
	jr z,@normalStatus
	ld a,$29
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	cp (hl)
	jr z,@normalStatus
	ld e,$b0
	ld a,(de)
	bit 7,a
	jr z,@normalStatus
	ld l,$b1
	ld e,$a9
	ld a,(de)
	ld c,a
-
	push hl
	ld h,(hl)
	ld l,$a9
	ld (hl),c
	ld l,$84
	ld (hl),$0e
	ld l,$a4
	res 7,(hl)
	ld l,$86
	ld (hl),$01
	pop hl
	inc l
	ld a,$b4
	cp l
	jr nz,-
	ld l,$a9
	ld (hl),c
	ld e,$99
	ld a,(de)
	or a
	jr z,+
	ld h,a
	ld l,$d7
	ld (hl),$ff
+
	ld a,c
	or a
	ld h,d
	ret z
	ld l,$ab
	ld a,$4b
	ldi (hl),a
	inc l
	ld (hl),a
	ret

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,+
	dec b
	jp z,agunimaSubId01
	jp agunimaSubId00
+
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub

@state0:
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8
	inc a
	ld (de),a
	ld a,$73
	jp enemyBoss_initializeRoom

@state1:
	ld b,$04
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMY_AGUNIMA
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,$b1
	ld c,h
	ld e,$03
-
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),c
	ld a,h
	pop hl
	ldi (hl),a
	dec e
	jr nz,-
	jp enemyDelete

@stateStub:
	ret

agunimaSubId01:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5

@@substate0:
	ld a,(wcc93)
	or a
	ret nz
	ld bc,$010c
	call enemyBoss_spawnShadow
	ret nz
	inc a
	ld (de),a
	ld bc,TX_2f02
	jp showText

@@substate1:
	ld a,$2d
	ld (wActiveMusic),a
	call playSound
	ld h,d
	ld l,$86
	ld (hl),$3c
	ld a,$b1
	ld bc,$3737
	jr @@func_4e86

@@substate2:
	call ecom_decCounter1
	ret nz
	ld l,$b0
	ld (hl),$00
	ld a,$b2
	ld bc,$7437
	jr @@func_4e86

@@substate3:
	ld h,d
	ld l,$b0
	bit 0,(hl)
	ret z
	ld (hl),$00
	ld a,$b3
	ld bc,$7a74

@@func_4e86:
	ld l,e
	inc (hl)
	ld l,a
	ld h,(hl)
	ld l,$b0
	ld (hl),$01
	ld l,$8b
	call setShortPosition_paramC
	ld l,$b1
	ld a,b
	and $f0
	add $08
	ldi (hl),a
	ld a,b
	and $0f
	swap a
	add $08
	ld (hl),a
	ret

@@substate4:
	ld h,d
	ld l,$b0
	bit 0,(hl)
	ret z
	ld (hl),$00
	ld l,e
	inc (hl)
	inc l
	ld (hl),$3c
	jp func_502a

@@substate5:
	call ecom_decCounter1
	ret nz
	ld l,$84
	inc (hl)
	ld e,$b1
	ld l,$b0
	ld b,$03
-
	ld a,(de)
	ld h,a
	set 0,(hl)
	inc e
	dec b
	jr nz,-
	ret

@state9:
	ld e,$b1
	ld l,$b0
	ld b,$03
-
	ld a,(de)
	ld h,a
	ld a,(hl)
	or a
	ret nz
	inc e
	dec b
	jr nz,-
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$3c
	ret

@stateA:
	call ecom_decCounter1
	ret nz
	ld l,e
	dec (hl)
	jp func_5007

agunimaSubId00:
	call func_5104
	call func_5122
	call func_512b
	ld e,$84
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE

@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_AGUNIMA_INVULNERABLE
	ld l,$90
	ld (hl),$14
	ld l,$8f
	ld (hl),$fc
	call getRandomNumber_noPreserveVars
	ld e,$b5
	ld (de),a
	ld e,$87
	ldh a,(<hRng2)
	ld (de),a
	call objectSetVisible81
	jp objectSetInvisible

@state9:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld h,d
	ld l,$b0
	bit 0,(hl)
	ret z
	ld l,e
	inc (hl)
	ld l,$b0
	set 1,(hl)
	call @@func_4f55
	ld a,$08
	jr z,+
	call objectGetRelativeAngleWithTempVars
	add $04
	and $18
	rrca
+
	ld e,$b3
	ld (de),a
	call enemySetAnimation
	jp func_507e

@@func_4f55:
	ld h,d
	ld l,$b1
	call ecom_readPositionVars
	cp c
	ret nz
	ldh a,(<hFF8F)
	cp b
	ret

@@substate1:
	call @@func_4f55
	jp nz,ecom_moveTowardPosition
	ld l,e
	inc (hl)
	ld l,$b0
	res 0,(hl)
	ld l,$97
	ld h,(hl)
	ld l,$b0
	ld (hl),$01

@@substate2:
	call func_5131
	ld h,d
	ld l,$b0
	bit 0,(hl)
	jp z,func_5071
	ld l,$84
	ld (hl),$0c
	ld l,$a4
	set 7,(hl)
	ld l,$b0
	res 1,(hl)
	ld l,$86
	ld (hl),$14
	jp objectSetVisible81

@stateA:
	ld h,d
	ld l,$b0
	bit 0,(hl)
	ret z
	set 1,(hl)
	ld l,e
	inc (hl)
	ld l,$86
	ld (hl),$3c
	jp func_5071

@stateB:
	call ecom_decCounter1
	jp nz,seasonsFunc_0e_506b
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$b0
	res 1,(hl)
	ld l,$86
	ld (hl),$08
	jp objectSetVisible81

@stateC:
	call ecom_decCounter1
	jp nz,seasonsFunc_0e_506b
	inc (hl)
	ld b,PART_39
	call ecom_spawnProjectile
	jp nz,seasonsFunc_0e_506b
	ld h,d
	ld l,$86
	ld (hl),$98
	ld l,$84
	inc (hl)
	ret

@stateD:
	call ecom_decCounter1
	jp nz,seasonsFunc_0e_50cf
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$a4
	res 7,(hl)
	ld l,$b0
	set 1,(hl)
	ld l,$86
	ld (hl),$3c
	ret

@stateE:
	call ecom_decCounter1
	ret nz
	ld l,e
	ld (hl),$0a
	ld l,$b0
	ld (hl),$00
	ld l,Enemy.enemyCollisionMode
	ld a,(hl)
	cp ENEMYCOLLISION_AGUNIMA_VULNERABLE
	jr nz,+
	ld (hl),ENEMYCOLLISION_AGUNIMA_INVULNERABLE
	ld l,$97
	ld h,(hl)
	ld l,$8f
	ld (hl),$00
+
	jp objectSetInvisible

func_5007:
	call getRandomNumber_noPreserveVars
	and $03
	ld b,a
	add a
	add b
	ld hl,table_5053
	rst_addDoubleIndex
	ld e,$b1
-
	ld a,(de)
	ld b,a
	ld c,$8b
	ldi a,(hl)
	ld (bc),a
	ld c,$8d
	ldi a,(hl)
	ld (bc),a
	ld c,$b0
	ld a,$01
	ld (bc),a
	inc e
	ld a,$b4
	cp e
	jr nz,-

func_502a:
	call getRandomNumber_noPreserveVars
	and $03
	cp $03
	jr z,func_502a
	add $b1
	ld e,a
	ld a,(de)
	ld h,a
	ld l,$b0
	set 7,(hl)
	ld l,$89
	ld a,(hl)
	swap a
	rlca
	ld bc,table_50cb
	call addAToBc
	ld l,$8b
	ld e,l
	ldi a,(hl)
	ld (de),a
	inc l
	ld e,l
	ld a,(bc)
	add (hl)
	ld (de),a
	ret

table_5053:
	.db $38 $78 $78 $48 $78 $a8
	.db $38 $48 $38 $a8 $78 $78
	.db $30 $40 $58 $40 $80 $40
	.db $30 $b0 $58 $b0 $80 $b0

seasonsFunc_0e_506b:
	ld a,(wFrameCounter)
	and $07
	ret nz
func_5071:
	call ecom_updateCardinalAngleTowardTarget
	rrca
	ld h,d
	ld l,$b3
	cp (hl)
	ret z
	ld (hl),a
	call enemySetAnimation
func_507e:
	ld e,$89
	ld a,(de)
	bit 3,a
	ld b,$08
	jr z,+
	ld b,$05
+
	ld e,$a7
	ld a,b
	ld (de),a
	call func_50ab
	ld e,$b0
	ld a,(de)
	bit 7,a
	ret z
	ld e,$89
	ld a,(de)
	swap a
	rlca
	ld hl,table_50cb
	rst_addAToHl
	ld c,(hl)
	ld b,$00
	ld a,$0b
	call objectGetRelatedObject1Var
	jp objectCopyPositionWithOffset

func_50ab:
	ld e,$b3
	ld a,(de)
	inc a
	and $03
	ret nz
	ld e,$8d
	ld a,(de)
	add $03
	and $f8
	ld (de),a
	ld h,d
	ld l,$89
	bit 3,(hl)
	ret z
	bit 4,(hl)
	ld b,$03
	jr z,+
	ld b,$fd
+
	add b
	ld (de),a
	ret

table_50cb:
	.db $00
	.db $fd
	.db $00
	.db $03

seasonsFunc_0e_50cf:
	call func_50f2
	ld e,$b4
	ld a,b
	ld (de),a
	ld e,$87
	ld a,(de)
	dec a
	ld (de),a
	and $07
	call z,ecom_updateCardinalAngleTowardTarget
	ld e,$89
	ld a,(de)
	rrca
	ld h,d
	ld l,$b4
	add (hl)
	ld l,$b3
	cp (hl)
	ret z
	ld (hl),a
	call enemySetAnimation
	jr func_507e

func_50f2:
	ld e,$86
	ld a,(de)
	ld b,$00
	cp $8e
	ret nc
	inc b
	cp $84
	ret nc
	inc b
	cp $7a
	ret nc
	inc b
	ret

func_5104:
	ld h,d
	ld l,$b5
	dec (hl)
	ld a,(hl)
	and $0f
	ret nz
	ld a,(hl)
	and $70
	swap a
	ld hl,table_511a
	rst_addAToHl
	ld e,$8f
	ld a,(hl)
	ld (de),a
	ret

table_511a:
	.db $fc $fb $fa $fb
	.db $fc $fd $fe $fd

func_5122:
	ld e,$b0
	ld a,(de)
	bit 1,a
	ret z
	jp ecom_flickerVisibility

func_512b:
	ld e,$84
	ld a,(de)
	cp $0b
	ret c
func_5131:
	ld h,d
	ld l,$b0
	bit 7,(hl)
	ret z
	ld a,($cca9)
	cp $02
	ld a,ENEMYCOLLISION_AGUNIMA_INVULNERABLE
	ld b,$00
	jr nz,+
	ld a,ENEMYCOLLISION_AGUNIMA_VULNERABLE
	ld b,$fc
+
	ld e,Enemy.enemyCollisionMode
	ld (de),a
	ld a,$0f
	call objectGetRelatedObject1Var
	ld (hl),b
	ret
