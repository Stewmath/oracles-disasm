; ==================================================================================================
; PART_SLINGSHOT_EYE_STATUE
; ==================================================================================================
partCode0d:
	jr z,@normalStatus
	call objectSetVisible83
	ld h,d
	ld l,$c6
	ld (hl),$2d
	ld l,Part.subid
	ld a,(hl)
	ld b,a
	and $07
	ld hl,$ccba
	call setFlag
	bit 7,b
	jr z,@normalStatus
	ld e,Part.state
	ld a,$02
	ld (de),a
@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw objectSetVisible83
@state0:
	ld a,$01
	ld (de),a
	ret
@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld e,Part.subid
	ld a,(de)
	ld hl,$ccba
	call unsetFlag
	jp objectSetInvisible
