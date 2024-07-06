; ==================================================================================================
; PART_AQUAMENTUS_PROJECTILE
; ==================================================================================================
partCode40:
	jp nz,partDelete
	ld e,$c4
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
	ld (hl),$28
	ld l,$d0
	ld (hl),$50
	ld e,$c2
	ld a,(de)
	or a
	jr z,func_7081
	ret
@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld a,$00
	call objectGetRelatedObject1Var
	ld bc,$f0f0
	call objectTakePositionWithOffset
	jp objectSetVisible80
@state2:
	call objectApplySpeed
	call partCommon_checkOutOfBounds
	jp z,partDelete
	ld a,(wFrameCounter)
	xor d
	rrca
	ret nc
	ld e,$dc
	ld a,(de)
	inc a
	and $03
	ld (de),a
	ret
func_7081:
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	ld c,$03
	call func_708e
	ld c,$fd
func_708e:
	call getFreePartSlot
	ret nz
	ld (hl),PART_AQUAMENTUS_PROJECTILE
	inc l
	inc (hl)
	call objectCopyPosition
	ld l,$c9
	ld e,l
	ld a,(de)
	add c
	and $1f
	ld (hl),a
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	ld e,l
	ld a,(de)
	ld (hl),a
	ret
