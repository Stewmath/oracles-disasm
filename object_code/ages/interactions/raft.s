; ==================================================================================================
; INTERAC_RAFT
; ==================================================================================================
interactionCodee6:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw interactionDelete

@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld a,(wDimitriState)
	bit 6,a
	jp z,interactionDelete

; Subid 1: A raft that's put there through the room's object list; it must check that
; there is no already-existing raft on the screen (either from a remembered position, or
; from Link riding it)
@subid1:
	ld a,GLOBALFLAG_RAFTON_CHANGED_ROOMS
	call checkGlobalFlag
	jp z,interactionDelete

	; Check if Link's riding a raft
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RAFT
	jp z,interactionDelete

	; Check if there's another raft interaction
	ld c,INTERAC_RAFT
	call objectFindSameTypeObjectWithID
	ld a,h
	cp d
	jp nz,interactionDelete

; Subid 2: when the raft's position was remembered
@subid2:
	push de
	ld a,UNCMP_GFXH_AGES_3b
	call loadUncompressedGfxHeader
	pop de
	call interactionInitGraphics
	call interactionIncState
	ld e,Interaction.direction
	ld a,(de)
	and $01
	call interactionSetAnimation
	jp objectSetVisible83

@state1:
	call interactionAnimate
	ld a,$09
	call @checkLinkWithinRange
	ret nc

	ld a,(wLinkInAir)
	or a
	jr z,@mountedRaft

	ld hl,w1Link.zh
	ld a,(hl)
	cp $fd
	ret c

	ld l,<w1Link.speedZ+1
	bit 7,(hl)
	ret nz

@mountedRaft:
	; Moving onto raft?
	ld a,d
	ld (wLinkRidingObject),a
	ld a,$05
	ld (wInstrumentsDisabledCounter),a
	call @checkLinkWithinRange
	ret nc

	ld a,(w1Link.id)
	or a
	jr z,++
	xor a ; SPECIALOBJECT_LINK
	call setLinkIDOverride
++
	ld hl,w1Companion.enabled
	ld (hl),$03
	inc l
	ld (hl),SPECIALOBJECT_RAFT
	ld e,Interaction.direction
	ld l,<w1Link.direction
	ld a,(de)
	ldi (hl),a
	call objectCopyPosition
	jp interactionIncState


;;
; @param	a	Collision radius
@checkLinkWithinRange:
	call objectSetCollideRadius
	ld hl,w1Link.yh
	ldi a,(hl)
	add $05
	ld b,a
	inc l
	ld c,(hl) ; [w1Link.xh]
	jp interactionCheckContainsPoint
