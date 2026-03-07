; ==================================================================================================
; PART_RAMROCK_SEED_FORM_ORB
; ==================================================================================================
partCode4f:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	
@state0:
	ld a,$01
	ld (de),a
	inc a
	call partSetAnimation
	ld e,$c6
	ld a,$28
	ld (de),a
	jp objectSetVisible80
	
@state1:
	call partAnimate
	ld a,$02
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0f
	jr nz,@delete
	call partCommon_decCounter1IfNonzero
	ret nz
	call objectGetAngleTowardLink
	ld e,$c9
	ld (de),a
	ld a,$50
	ld e,$d0
	ld (de),a
	ld e,$c4
	ld a,$02
	ld (de),a
	
@state2:
	call partAnimate
	call partCommon_decCounter1IfNonzero
	jr nz,@func_7aa9
	ld (hl),$0a
	call objectGetAngleTowardLink
	jp objectNudgeAngleTowards

@func_7aa9:
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
@delete:
	jp partDelete
