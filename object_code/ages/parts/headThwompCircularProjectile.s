; ==================================================================================================
; PART_HEAD_THWOMP_CIRCULAR_PROJECTILE
; ==================================================================================================
partCode3c:
	jp nz,partDelete
	ld e,Part.state
	ld a,(de)
	or a
	jr z,@state0

	call partCommon_checkOutOfBounds
	jp z,partDelete
	call partCommon_decCounter1IfNonzero
	jr nz,@counter1NonZero

	inc l
	ld e,Part.var30
	ld a,(de)
	inc a
	and $01
	ld (de),a
	add (hl)
	ldd (hl),a
	ld (hl),a

	ld l,Part.angle
	ld e,Part.subid
	ld a,(de)
	add (hl)
	and $1f
	ld (hl),a

@counter1NonZero:
	call objectApplySpeed
	jp partAnimate

@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Part.counter1
	ld a,$02
	ldi (hl),a
	ld (hl),a

	ld l,Part.speed
	ld (hl),SPEED_280
	call objectSetVisible82
	ld a,SND_BEAM
	jp playSound
