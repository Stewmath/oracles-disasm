; ==================================================================================================
; INTERAC_STATUE_EYEBALL
; ==================================================================================================
interactionCodee2:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	call checkInteractionState
	jr z,@state0Common

	; State 1
	ld a,(wScrollMode)
	and $01
	ret z
	call @getDirectionToFace
	jp interactionSetAnimation

; Used by subid 0, 2, and 4
@state0Common:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible83

@subid2:
	call checkInteractionState
	jr z,@state0Common

	; State 1
	ld a,(wScrollMode)
	and $01
	ret z

	call @centerOnTileAndGetDirectionToFace

@offsetPositionTowardLookingDirection:
	ld hl,@lowPositionValues
	rst_addDoubleIndex
	ld e,Interaction.yh
	ld a,(de)
	and $f0
	or (hl)
	ld (de),a
	inc hl
	ld e,Interaction.xh
	ld a,(de)
	and $f0
	or (hl)
	ld (de),a
	ret

; Values for the lower 4 bits of the Y/X position, based on the direction it's facing. For subid
; 2 and 4 only (they are offset further in the direction they're looking).
@lowPositionValues:
	.db $05 $08
	.db $05 $09
	.db $06 $09
	.db $07 $09
	.db $07 $08
	.db $07 $07
	.db $06 $07
	.db $05 $07

;;
@centerOnTileAndGetDirectionToFace:
	call objectCenterOnTile

;;
; Gets the direction the angle should face, as a number from 0-7. (This isn't a standard direction
; or angle value.)
;
; @param[out]	a	Direction (0-7)
@getDirectionToFace:
	call objectGetAngleTowardLink
	ld b,a
	and $07
	jr z,@@returnValue
	cp $01
	jr z,@@returnValue
	cp $07
	jr z,@@returnValue
	ld a,b
	and $fc
	or $04
	ld b,a

@@returnValue:
	ld a,b
	rrca
	rrca
	and $07
	ret


; Spawner for subid 2
@subid1:
	ld e,$02 ; subid

@spawnChildren:
	ld bc,wRoomLayout + LARGE_ROOM_WIDTH-1 + (LARGE_ROOM_HEIGHT-1)*16
--
	ld a,(bc)
	cp TILEINDEX_EYE_STATUE
	call z,@spawnChild
	dec c
	jr nz,--
	jp interactionDelete

;;
; @param	c	position
; @param	e	subid
@spawnChild:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_STATUE_EYEBALL
	inc l
	ld (hl),e ; [subid]
	push bc
	call convertShortToLongPosition_paramC
	ld l,Interaction.yh
	dec b
	dec b
	ld (hl),b
	inc l
	inc l
	ld (hl),c
	pop bc
	ret


; Spawner for subid 4
@subid3:
	call returnIfScrollMode01Unset
	ld a,(wEyePuzzleTransitionCounter)
	cp $06
	ld a,$00
	jr nc,++

	; Choose random direction to go
--
	call getRandomNumber
	and $03
	cp $02
	jr z,--
++
	ld (wEyePuzzleCorrectDirection),a
	ld e,$04
	jr @spawnChildren


@subid4:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0Common
	.dw @@state1
	.dw objectSetVisible83

@@state1:
	call checkInteractionSubstate
	jr z,@substate0

	call interactionDecCounter1
	jr nz,@eyeSpinning

	; Eye is done spinning.
	call interactionIncState
	ld a,(wEyePuzzleCorrectDirection)
	ld b,a

	; Abuse the frame counter to get a random direction to face? (I guess this is so that all of
	; the eyes are guaranteed to point in various different directions? But this screws up the
	; frame counter value. I don't like it.)
--
	ld hl,wFrameCounter
	inc (hl)
	ld a,(hl)
	and $03
	cp b
	jr z,--

	add a
	jp @offsetPositionTowardLookingDirection

@eyeSpinning:
	ld a,(wFrameCounter)
	and $03
	ret nz
	call getRandomNumber
	and $07
	jp @offsetPositionTowardLookingDirection

@substate0:
	ld a,60
	ld (de),a ; [substate] = nonzero
	ld e,Interaction.counter1
	ld (de),a
	ret
