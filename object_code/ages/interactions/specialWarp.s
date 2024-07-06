; ==================================================================================================
; INTERAC_SPECIAL_WARP
; ==================================================================================================
interactionCode1f:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

; Subid 0: Trigger a warp when Link dives touching this object
@subid0:
	call checkInteractionState
	jr z,@@initialize

	; Check that Link has collided with this object, he's not holding anything, and
	; he's diving.
	ld a,(wLinkSwimmingState)
	rlca
	ret nc
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc

	ld e,Interaction.var03
	ld a,(de)
	ld hl,@@warpData
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ld a,(hl)
	ld (wWarpDestPos),a
	ld a,$87
	ld (wWarpDestGroup),a
	ld a,$01
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
	jp interactionDelete

@@warpData:
	.db $09 $01
	.db $05 $03

@@initialize:
	ld a,$01
	ld (de),a
	ld a,$02
	call objectSetCollideRadius

	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var03
	ld (hl),a

	ld l,Interaction.yh
	ld c,(hl)
	jp setShortPosition_paramC


; Subid 1: a warp at the top of a waterfall
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid1State0
	.dw @subid1State1
	.dw @subid1State2

@subid1State0:
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECT_DIMITRI
	jp nz,interactionDelete

	ld bc,$0810
	call objectSetCollideRadii
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	call nc,interactionIncState
	jp interactionIncState

@subid1State1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret c
	jp interactionIncState

@subid1State2:
	ld a,d
	ld (wDisableWarpTiles),a
	ld a,(wLinkObjectIndex)
	cp >w1Companion
	ret nz
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	ld hl,@@warpDestVariables
	jp setWarpDestVariables

@@warpDestVariables:
	m_HardcodedWarpA ROOM_AGES_5b8, $00, $93, $03


; Subid 2: a warp in a cave in a waterfall
@subid2:
	ld a,d
	ld (wDisableScreenTransitions),a
	call checkInteractionState
	jr z,@@initialize

	call checkLinkCollisionsEnabled
	ret nc
	ld a,(wLinkObjectIndex)
	bit 0,a
	ret z

	ld h,a
	ld l,<w1Companion.yh
	ld a,(hl)
	cp $a8
	ret c

	ld a,$ff
	ld (wDisabledObjects),a

	ld hl,@@warpDestVariables
	call setWarpDestVariables
	jp interactionDelete

@@warpDestVariables:
	m_HardcodedWarpB ROOM_AGES_037, $0e, $22, $03

@@initialize:
	call interactionIncState
	jp interactionSetAlwaysUpdateBit
