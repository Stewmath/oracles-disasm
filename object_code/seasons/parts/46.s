; ==================================================================================================
; PART_46
; ==================================================================================================
partCode46:
	jr nz,@delete
	ld e,$c2
	ld a,(de)
	or a
	jr z,@subid0
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @subid1@state0
	.dw @subid1@state1
	.dw @subid1@state2
@subid0:
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,@delete
	ld l,$84
	ld a,(hl)
	cp $0a
	jr nz,@delete
	ld l,$ae
	ld a,(hl)
	or a
	ret nz
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$1e
@@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
@@state2:
	ld b,$03
	call func_7517
	ret nz
	ld a,b
	sub $08
	and $1f
	ld b,a
	call func_74fd
	call func_74fd
	call func_74fd
	ld a,$ba
	call playSound
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld (hl),$1e
@@state3:
@@state4:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld b,$02
	call func_7517
	ret nz
	ld a,b
	sub $06
	and $1f
	ld b,a
	call func_74fd
	call func_74fd
	ld a,$ba
	call playSound
@delete:
	jp partDelete

@subid1:
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$d0
	ld (hl),$64
	ld l,$c6
	ld (hl),$08
	call func_7524
	call objectSetVisible82
@@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
@@state2:
	call objectCheckSimpleCollision
	jr nz,@delete
+
	call objectApplySpeed
	jp partAnimate
func_74fd:
	call getFreePartSlot
	ret nz
	ld (hl),PART_46
	inc l
	inc (hl)
	ld l,$c9
	ld a,b
	add $04
	and $1f
	ld (hl),a
	ld b,a
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	ld e,l
	ld a,(de)
	ld (hl),a
	ret
func_7517:
	call checkBPartSlotsAvailable
	ret nz
	call func_7524
	call objectGetAngleTowardEnemyTarget
	ld b,a
	xor a
	ret
func_7524:
	ld a,$0b
	call objectGetRelatedObject1Var
	ld bc,$0a00
	call objectTakePositionWithOffset
	xor a
	ld (de),a
	ret
