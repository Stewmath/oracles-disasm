; ==================================================================================================
; PART_STALFOS_BONE
; ==================================================================================================
partCode1c:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr z,@partDelete
	jr @func_11_51dd

@normalStatus:
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
	ld l,$d0
	ld (hl),$3c
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	jp objectSetVisible81

@state1:
	call partCommon_checkTileCollisionOrOutOfBounds
	jr c,+
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp c,partAnimate

@partDelete:
	jp partDelete

@state2:
	call partCommon_decCounter1IfNonzero
	jr z,@partDelete
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	call objectApplySpeed
	ld a,(wFrameCounter)
	rrca
	ret c
	jp partAnimate
+
	jr z,@partDelete
@func_11_51dd:
	ld e,$c4
	ld a,$02
	ld (de),a
	xor a
	jp partCommon_bounceWhenCollisionsEnabled
