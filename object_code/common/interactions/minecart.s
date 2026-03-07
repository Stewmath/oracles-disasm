; ==================================================================================================
; INTERAC_MINECART
; ==================================================================================================
interactionCode16:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw interactionDelete

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$06
	call objectSetCollideRadius
	ld l,Interaction.counter1
	ld (hl),$04

	; Check for position relative to platform, set direction based on that
	ld a,TILEINDEX_MINECART_PLATFORM
	call objectGetRelativePositionOfTile
	ld h,d
	ld l,Interaction.direction
	xor $02
	ldi (hl),a

	; Set Interaction.angle
	swap a
	rrca
	ldd (hl),a

	; Set animation based on facing direction
	ld a,(hl)
	and $01
	call interactionSetAnimation

	; Save the minecart in a "static object" slot so the game remembers where it is
	call objectDeleteRelatedObj1AsStaticObject
	call findFreeStaticObjectSlot
	ld a,STATICOBJTYPE_INTERACTION
	call z,objectSaveAsStaticObject

@state1:
	call objectSetPriorityRelativeToLink
	ld a,(wLinkInAir)
	add a
	jr c,+

	; Check for collision, also prevent link from walking through
	call objectPreventLinkFromPassing
	ret nc
+
	ld a,(w1Link.zh)
	or a
	jr nz,@resetCounter

	call checkLinkID0AndControlNormal
	jr nc,@resetCounter

	call objectCheckLinkPushingAgainstCenter
	jr nc,@resetCounter

	ld a,$01
	ld (wForceLinkPushAnimation),a
	call interactionDecCounter1
	ret nz

	call interactionIncState

	; Force link to jump, lock his speed
	ld a,$81
	ld (wLinkInAir),a
	ld hl,w1Link.speed
	ld (hl),SPEED_80

	ld l,<w1Link.speedZ
	ld (hl),$40
	inc l
	ld (hl),$fe

	call objectGetAngleTowardLink
	xor $10
	ld (w1Link.angle),a
	ret

@resetCounter:
	ld e,Interaction.counter1
	ld a,$04
	ld (de),a
	ret

@state2:
	; Wait for link to reach a certain z position
	ld hl,w1Link.zh
	ld a,(hl)
	cp $fa
	ret c

	; Wait for link to start falling
	ld l,<w1Link.speedZ+1
	bit 7,(hl)
	ret nz

	; Set minecart state to $03 (state $03 jumps to interactionDelete).
	ld a,$03
	ld (de),a

	; Use the "companion" slot to create a minecart.
	; Presumably this is necessary for it to persist between rooms?
	ld hl,w1Companion.enabled
	ldi (hl),a
	ld (hl),SPECIALOBJECT_MINECART

	; Copy direction, angle
	ld e,Interaction.direction
	ld l,SpecialObject.direction
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a

	call objectCopyPosition

	; Minecart will be moved, so the static object slot will be updated later.
	jp objectDeleteRelatedObj1AsStaticObject
