; ==================================================================================================
; PART_OCTOGON_BUBBLE
; ==================================================================================================
partCode55:
	jr z,@normalStatus

	; Collision occured with something. Check if it was Link.
	ld e,Part.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jp nz,@gotoState2

	call checkLinkVulnerable
	jr nc,@normalStatus

	; Immobilize Link
	ld hl,wLinkForceState
	ld a,LINK_STATE_COLLAPSED
	ldi (hl),a
	ld (hl),$01 ; [wcc50]

	ld h,d
	ld l,Part.state
	ld (hl),$03

	ld l,Part.zh
	ld (hl),$00

	ld l,Part.collisionType
	res 7,(hl)
	call objectSetVisible81

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3


; Uninitialized
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.speed
	ld (hl),SPEED_80

	ld l,Part.counter1
	ld (hl),180
	jp objectSetVisible82


; Moving forward
@state1:
	call partCommon_decCounter1IfNonzero
	jr z,@gotoState2

	ld a,(wFrameCounter)
	and $18
	rlca
	swap a
	ld hl,@zPositions
	rst_addAToHl
	ld e,Part.zh
	ld a,(hl)
	ld (de),a
	call objectApplySpeed
@animate:
	jp partAnimate

@zPositions:
	.db $ff $fe $ff $00


; Stopped in place, waiting for signal from animation to delete self
@state2:
	call partAnimate
	ld e,Part.animParameter
	ld a,(de)
	inc a
	ret nz
	jp partDelete


; Collided with Link
@state3:
	ld hl,w1Link
	call objectTakePosition

	ld a,(wLinkForceState)
	cp LINK_STATE_COLLAPSED
	ret z

	ld l,<w1Link.state
	ldi a,(hl)
	cp LINK_STATE_COLLAPSED
	jr z,@animate

@gotoState2:
	ld h,d
	ld l,Part.state
	ld (hl),$02

	ld l,Part.collisionType
	res 7,(hl)

	ld a,$01
	jp partSetAnimation
