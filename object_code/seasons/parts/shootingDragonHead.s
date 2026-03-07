; ==================================================================================================
; PART_SHOOTING_DRAGON_HEAD
; ==================================================================================================
partCode24:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jp nz,partDelete
@normalStatus:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
@subid1:
	ld a,(de)
	or a
	jr z,@func_656b
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,$c2
	bit 0,(hl)
	ld l,$cd
	ldh a,(<hEnemyTargetX)
	jr nz,@func_654f
	cp (hl)
	ret c
	jr +

@func_654f:
	cp (hl)
	ret nc
+
	call func_65b8
	ret nc
	call getRandomNumber_noPreserveVars
	cp $50
	ret nc
	call func_65a6
	ret nz
	ld l,$c9
	ld (hl),$08
	ld e,$c2
	ld a,(de)
	or a
	ret z
	ld (hl),$18
	ret
@func_656b:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	inc (hl)
	ret
@subid2:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$10
	ld l,$e4
	set 7,(hl)
	jp objectSetVisible81
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
@state2:
	call partCode.partCommon_checkTileCollisionOrOutOfBounds
	jp c,partDelete
+
	call objectApplySpeed
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld e,$dc
	ld a,(de)
	inc a
	and $07
	ld (de),a
	ret

func_65a6:
	call getFreePartSlot
	ret nz
	ld (hl),PART_SHOOTING_DRAGON_HEAD
	inc l
	ld (hl),$02
	call objectCopyPosition
	ld l,$d0
	ld (hl),$3c
	xor a
	ret

func_65b8:
	ld l,$cb
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add $10
	cp $21
	ret nc
	ld e,$c6
	ld a,$1e
	ld (de),a
	ret
