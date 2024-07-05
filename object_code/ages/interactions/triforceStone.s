; ==================================================================================================
; INTERAC_TRIFORCE_STONE
; ==================================================================================================
interactionCode34:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	; Delete self if the stone was pushed already
	call getThisRoomFlags
	and $c0
	jp nz,interactionDelete

	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),$03
	inc l
	ld (hl),$0a

	call objectMarkSolidPosition
	call interactionInitGraphics
	ld a,PALH_98
	call loadPaletteHeader
	jp objectSetVisible83

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call objectPreventLinkFromPassing
	call @checkPushedStoneLongEnough
	ret nz

; Begin stone-pushing cutscene

	call interactionIncSubstate
	ld l,Interaction.speed
	ld (hl),SPEED_40
	ld l,Interaction.counter1
	ld (hl),$40

	ld a,SPECIALOBJECT_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$06

	ld e,Interaction.angle
	ld l,<w1Link.angle
	ld a,(de)
	ld (hl),a

	ld l,<w1Link.speed
	ld (hl),SPEED_80

	ld hl,$cfd0
	ld (hl),$06
	ld a,SND_MAKUDISAPPEAR
	jp playSound

;;
; @param[out]	zflag	Set if Link has pushed against the stone long enough
@checkPushedStoneLongEnough:
	; Check Link's X is close enough
	ld e,Interaction.xh
	ld a,(de)
	ld hl,w1Link.xh
	sub (hl)
	jr nc,+
	cpl
	inc a
+
	cp $11
	jr nc,@notPushing

	; Check Link's Y is close enough
	ld l,<w1Link.yh
	ld a,(hl)
	cp $2a
	jr nc,@notPushing

	; Check he's facing left or right
	ld l,<w1Link.direction
	ld a,(hl)
	and $01
	jr z,@notPushing

	; Check if he's pushing
	call objectCheckLinkPushingAgainstCenter
	jr nc,@notPushing

	; Make Link do the push animation
	ld a,$01
	ld (wForceLinkPushAnimation),a

	; Wait for him to push for enough frames
	call interactionDecCounter1
	ret nz

	; Get the direction Link is relative to the stone
	ld c,$28
	call objectCheckLinkWithinDistance

	ld e,Interaction.angle
	and $07
	xor $04
	add a
	add a
	ld (de),a
	xor a
	ret

@notPushing:
	xor a
	ld (wForceLinkPushAnimation),a
	ld a,$14
	ld e,Interaction.counter1
	ld (de),a
	or a
	ret


; In the process of pushing the stone
@substate1:
	call objectPreventLinkFromPassing
	call interactionDecCounter1
	jr nz,@applySpeed

; Finished pushing

	; Determine new X-position
	ld b,$48
	ld e,Interaction.angle
	ld a,(de)
	and $10
	jr z,+
	ld b,$28
+
	ld l,Interaction.xh
	ld (hl),b

	call interactionIncSubstate

	; Determine bit to set on room flags (depends which way it was pushed)
	call getThisRoomFlags
	ld a,b
	cp $28
	ld b,$40
	jr z,+
	ld b,$80
+
	ld a,(hl)
	or b
	ld (hl),a

	call @setSolidTile

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_SOLVEPUZZLE_2
	jp playSound

@applySpeed:
	jp objectApplySpeed

@substate2:
	ret

;;
; @param	c	Tile to set collisions to "solid" for
@setSolidTile:
	call objectGetShortPosition
	ld c,a
	ld b,>wRoomLayout
	ld a,$00
	ld (bc),a
	ld b,>wRoomCollisions
	ld a,$0f
	ld (bc),a
	ret
