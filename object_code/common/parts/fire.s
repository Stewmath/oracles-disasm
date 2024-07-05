; ==================================================================================================
; PART_FIRE
; Created by fire keese
; ==================================================================================================
partCode20:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	jp partAnimate

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$b4
	jp objectSetVisible82
