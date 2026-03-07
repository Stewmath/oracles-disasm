; ==================================================================================================
; INTERAC_PUSHBLOCK_SYNCHRONIZER
; ==================================================================================================
interactionCodebd:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionIncState
	.dw @state1
	.dw @state2

@state1:
	; Wait for a block to be pushed
	ld a,(w1ReservedInteraction1.enabled)
	or a
	ret z

	ld a,(w1ReservedInteraction1.var31) ; Tile index of block being pushed
	ldh (<hFF8B),a
	call findTileInRoom
	jr nz,@incState

	; Found another tile of the same type; push it, then search for more tiles of that type
	call @pushBlockAt
--
	ldh a,(<hFF8B)
	call backwardsSearch
	jr nz,@incState
	call @pushBlockAt
	jr --

@incState:
	jp interactionIncState

@state2:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret

;;
; @param	hl	Position of block to push in wRoomLayuut
; @param	hFF8B	Index of tile to push
@pushBlockAt:
	push hl
	ldh a,(<hFF8B)
	cp TILEINDEX_SOMARIA_BLOCK
	jr z,@return

	ld a,l
	ldh (<hFF8D),a
	ld h,d
	ld l,Interaction.yh
	call setShortPosition

	ld l,Interaction.angle
	ld a,(wBlockPushAngle)
	and $1f
	ld (hl),a

	call interactionCheckAdjacentTileIsSolid
	jr nz,@return
	call getFreeInteractionSlot
	jr nz,@return

	ld (hl),INTERAC_PUSHBLOCK
	ld l,Interaction.angle
	ld e,l
	ld a,(de)
	ld (hl),a
	ldbc -$02, $00
	call objectCopyPositionWithOffset

	; [pushblock.var30] = tile position
	ld l,Interaction.var30
	ldh a,(<hFF8D)
	ld (hl),a
@return:
	pop hl
	dec l
	ret
