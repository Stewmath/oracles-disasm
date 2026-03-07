; ==================================================================================================
; INTERAC_SARCOPHAGUS
; ==================================================================================================
interactionCode82:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	bit 7,a
	jp nz,@break

	or a
	jr z,++
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
++
	call interactionIncState

	ld l,Interaction.collisionRadiusY
	ld (hl),$10
	ld l,Interaction.collisionRadiusX
	ld (hl),$08

	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	ld a,l
	sub $10
	ld l,a
	ld (hl),$00
	ld h,>wRoomCollisions
	ld (hl),$0f
	jp objectSetVisible83

; Waiting for Link to grab
@state1:
	ld a,(wBraceletLevel)
	cp $02
	ret c
	jp objectAddToGrabbableObjectBuffer

; Link currently grabbing
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0_justGrabbed
	.dw @substate1_holding
	.dw @substate2_justReleased
	.dw @break

@substate0_justGrabbed:
	call interactionIncSubstate
	ld l,Interaction.subid
	ld a,(hl)
	or a
	jr z,++

	dec a
	ld a,SND_SOLVEPUZZLE
	call z,playSound
	call getThisRoomFlags
	set 6,(hl)
++
	call objectGetShortPosition
	push af
	call getTileIndexFromRoomLayoutBuffer
	call setTile
	pop af
	sub $10
	call getTileIndexFromRoomLayoutBuffer
	call setTile
	xor a
	ld (wLinkGrabState2),a
	jp objectSetVisiblec1

@substate1_holding:
	ret

@substate2_justReleased:
	ld h,d
	ld l,Interaction.enabled
	res 1,(hl)

	; Wait for it to hit the ground
	ld l,Interaction.zh
	bit 7,(hl)
	ret nz

@break:
	ld h,d
	ld l,Interaction.state
	ld (hl),$03
	ld l,Interaction.counter1
	ld (hl),$02

	ld l,Interaction.oamFlagsBackup
	ld a,$0c
	ldi (hl),a
	ldi (hl),a
	ld (hl),$40 ; [oamTileIndexBase] = $40

	call objectSetVisible83
	xor a
	jp interactionSetAnimation

; Being destroyed
@state3:
	call interactionDecCounter1
	ld a,SND_KILLENEMY
	call z,playSound
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	jp nz,interactionAnimate
	jp interactionDelete
