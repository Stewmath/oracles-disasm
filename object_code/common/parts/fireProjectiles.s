; ==================================================================================================
; PART_ZORA_FIRE
; PART_GOPONGA_PROJECTILE
; ==================================================================================================
partCode19:
partCode31:
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
	ld (hl),$08
	ld l,$d0
	ld (hl),$3c
	jp objectSetVisible81

@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld l,$c2
	bit 0,(hl)
	jr z,+
	ldh a,(<hFFB2)
	ld b,a
	ldh a,(<hFFB3)
	ld c,a
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	ret
+
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	ret

@state2:
	ld a,(wFrameCounter)
	and $03
	jr nz,+
	ld e,$dc
	ld a,(de)
	xor $07
	ld (de),a
+
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
	jp partAnimate
