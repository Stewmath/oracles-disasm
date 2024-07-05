; ==================================================================================================
; PART_44
; ==================================================================================================
partCode44:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $83
	jr z,++
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $7f
	jr nz,+
	ld l,$b6
	ld (hl),$01
+
	ld a,$13
	ld ($cc6a),a
	jr func_73db
++
	ld e,$c4
	ld a,$02
	ld (de),a
	ld e,$c9
	ld a,(de)
	xor $10
	ld (de),a
	call @func_73ae
	call objectGetAngleTowardEnemyTarget
	ld ($d02c),a
	ld a,$18
	ld ($d02d),a
	ld a,$52
	call playSound
@normalStatus:
	call partCommon_checkOutOfBounds
	jr z,func_73db
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call objectSetVisible82
	ld e,$c2
	ld a,(de)
	ld hl,table_73de
	rst_addAToHl
	ld e,$c9
	ld a,(hl)
	ld (de),a
@func_73ae:
	ld c,a
	ld b,$46
	ld a,$02
	jp objectSetComponentSpeedByScaledVelocity
@state1:
	call objectApplyComponentSpeed
	jp partAnimate
@state2:
	ld a,$00
	call objectGetRelatedObject1Var
	call checkObjectsCollided
	jr nc,@state1
	ld l,$ae
	ld (hl),$78
	dec l
	ld (hl),$18
	push hl
	call objectGetAngleTowardEnemyTarget
	pop hl
	dec l
	xor $10
	ld (hl),a
	ld a,$4e
	call playSound
func_73db:
	jp partDelete
table_73de:
	.db $02 $04 $06 $08
	.db $0a $0c $0e $10
	.db $12 $14 $16 $18
	.db $1a $1c $1e $00
