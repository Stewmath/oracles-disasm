; ==================================================================================================
; PART_49
; ==================================================================================================
partCode49:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,Part.state
	inc (hl)
	ld l,Part.speed
	ld (hl),SPEED_2c0
	ld l,Part.counter1
	ld (hl),$3c
	jp objectSetVisible81

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld l,e
	inc (hl)
	ld a,SND_WIND
	call playSound
	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

@state2:
	call partCode.partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplySpeed
@animate:
	jp partAnimate
