; ==================================================================================================
; INTERAC_PIRATE_SHIP
; ==================================================================================================
interactionCodec2:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid0State0
	.dw @subid0State1
	.dw interactionAnimate

@subid0State0:
	call interactionInitGraphics
	call objectSetVisible82
	ld a,(wPirateShipAngle)
	and $03
	ld e,Interaction.direction
	ld (de),a
	call interactionSetAnimation
	ld a,$06
	call objectSetCollideRadius
	jp interactionIncState

@subid0State1:
	; Update position based on "wPirateShipRoom" and other variables
	ld hl,wPirateShipRoom
	ld a,(wActiveRoom)
	cp (hl)
	jp nz,interactionDelete
	inc l
	ldi a,(hl) ; [wPirateShipY]
	ld e,Interaction.yh
	ld (de),a
	ldi a,(hl) ; [wPirateShipX]
	ld e,Interaction.xh
	ld (de),a

	ld e,Interaction.direction
	ld a,(de)
	cp (hl) ; [wPirateShipAngle]
	ld a,(hl)
	ld (de),a
	call nz,interactionSetAnimation

	; Check if Link touched the ship
	call objectCheckCollidedWithLink_notDead
	jr nc,@animate
	call checkLinkVulnerable
	jr nc,@animate

	ld hl,@warpDest
	call setWarpDestVariables
	jp interactionIncState

@animate:
	jp interactionAnimate

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5f8, $01, $56, $03


; Unlinked cutscene of ship leaving
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid1State0
	.dw @subid1And2State1
	.dw @subid1State2

@subid1State0:
	call checkIsLinkedGame
	jp nz,interactionDelete

	ld a,GLOBALFLAG_PIRATES_GONE
	call checkGlobalFlag
	jp z,interactionDelete

	call getThisRoomFlags
	and ROOMFLAG_40
	jp nz,interactionDelete

	call interactionInitGraphics
	ld a,$03
	call interactionSetAnimation
	xor a ; DIR_UP
	ld (w1Link.direction),a

@subid1And2State0Common:
	call objectSetVisible82
	ld e,Interaction.counter1
	ld a,60
	ld (de),a
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionIncState

@subid1And2State1:
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	ld (hl),$80
	ld bc,TX_360c
	call showText
	jp interactionIncState

@subid1State2:
	ld c,ANGLE_LEFT

@moveOffScreen:
	ld b,SPEED_100
	ld e,Interaction.angle
	call objectApplyGivenSpeed
	call interactionAnimate
	call interactionDecCounter1
	ret nz

	call getThisRoomFlags
	set ROOMFLAG_BIT_40,(hl)
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete


; Linked cutscene of ship leaving
@subid2:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid2State0
	.dw @subid1And2State1
	.dw @subid2State2

@subid2State0:
	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,GLOBALFLAG_PIRATES_GONE
	call checkGlobalFlag
	jp z,interactionDelete

	call getThisRoomFlags
	and ROOMFLAG_40
	jp nz,interactionDelete

	call interactionInitGraphics
	xor a
	call interactionSetAnimation
	ld a,$01
	ld (w1Link.direction),a
	jp @subid1And2State0Common

@subid2State2:
	ld c,ANGLE_UP
	jr @moveOffScreen
