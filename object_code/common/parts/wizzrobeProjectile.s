; ==================================================================================================
; PART_WIZZROBE_PROJECTILE
; ==================================================================================================
partCode1f:
	jr nz,@normalStatus
	ld e,$c4
	ld a,(de)
	or a
	jr z,func_5369
	call objectCheckWithinScreenBoundary
	jr nc,@normalStatus
	call partCommon_checkTileCollisionOrOutOfBounds
	jp nc,objectApplySpeed
@normalStatus:
	jp partDelete

func_5369:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld e,$c9
	ld a,(de)
	swap a
	rlca
	call partSetAnimation
	jp objectSetVisible81
