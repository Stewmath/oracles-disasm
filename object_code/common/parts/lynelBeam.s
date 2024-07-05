; ==================================================================================================
; PART_LYNEL_BEAM
; ==================================================================================================
partCode1b:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	res 7,a
	cp $04
	jp c,partDelete
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	jr z,+
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
	call objectApplySpeed
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld e,$dc
	ld a,(de)
	xor $07
	ld (de),a
	ret
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$78
	ld l,$cb
	ld b,(hl)
	ld l,$cd
	ld c,(hl)
	call partCommon_setPositionOffsetAndRadiusFromAngle
	ld e,$c9
	ld a,(de)
	swap a
	rlca
	call partSetAnimation
	jp objectSetVisible81
