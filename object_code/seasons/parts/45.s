; ==================================================================================================
; PART_45
; ==================================================================================================
partCode45:
	jr z,@normalStatus
	dec a
	jr nz,@delete
	ld e,$ea
	ld a,(de)
	cp $80
	jr nz,@delete
@normalStatus:
	ld e,$c2
	ld a,(de)
	or a
	ld e,$c4
	ld a,(de)
	jr z,@func_742e
	or a
	jr z,+
	call objectCheckSimpleCollision
	jp z,objectApplyComponentSpeed
@delete:
	jp partDelete
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld a,$0b
	call objectGetRelatedObject1Var
	ld bc,$0f00
	call objectTakePositionWithOffset
	xor a
	ld (de),a
	ld bc,$5010
	ld a,$08
	call objectSetComponentSpeedByScaledVelocity
	jp objectSetVisible82
@func_742e:
	or a
	jr nz,+
	inc a
	ld (de),a
+
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,@delete
	ld l,$ae
	ld a,(hl)
	or a
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PART_45
	inc l
	inc (hl)
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	ld e,l
	ld a,(de)
	ld (hl),a
	ret
