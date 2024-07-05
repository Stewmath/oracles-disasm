; ==================================================================================================
; INTERAC_WOODEN_TUNNEL
; ==================================================================================================
interactionCode98:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$07
	call objectSetCollideRadius

	; Set animation (direction of tunnel) based on subid
	ld e,Interaction.subid
	ld a,(de)
	jr +
+
	call interactionSetAnimation
	jp objectSetVisible81

@state1:
	; Make solid if Link's grabbing something or is on the companion
	ld a,(wLinkGrabState)
	or a
	jr nz,@makeSolid
	ld a,(wLinkObjectIndex)
	bit 0,a
	jr nz,@makeSolid
	ld a,(w1ReservedItemC.enabled)
	or a
	jr nz,@makeSolid

	; Allow Link to pass, but set solidity so he can only pass through the center
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	ld c,SPECIALCOLLISION_VERTICAL_BRIDGE
	jr c,@setSolidity
	ld c,SPECIALCOLLISION_HORIZONTAL_BRIDGE
	jr @setSolidity

@makeSolid:
	ld c,$0f
@setSolidity:
	call objectGetShortPosition
	ld h,>wRoomCollisions
	ld l,a
	ld (hl),c
	ret
