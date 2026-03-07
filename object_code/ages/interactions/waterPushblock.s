; ==================================================================================================
; INTERAC_WATER_PUSHBLOCK
; ==================================================================================================
interactionCode9e:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid0State0
	.dw @state1
	.dw @state2
	.dw @subid0State3
	.dw objectPreventLinkFromPassing

@subid0State0:
	call getThisRoomFlags
	and $01
	jp nz,interactionDelete

@initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,$06
	call objectSetCollideRadius

	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.counter1
	ld (hl),30

	call objectSetVisible82
	jp interactionIncState


; Check if Link is pushing against the block
@state1:
	call objectPreventLinkFromPassing
	jr nc,@@notPushing
	call objectCheckLinkPushingAgainstCenter
	jr nc,@@notPushing

	; Link is pushing against in
	ld a,$01
	ld (wForceLinkPushAnimation),a
	call interactionDecCounter1
	ret nz
	jr @@pushedLongEnough

@@notPushing:
	ld e,Interaction.counter1
	ld a,30
	ld (de),a
	ret

@@pushedLongEnough:
	ld c,$28
	call objectCheckLinkWithinDistance
	ld b,a
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld c,$02
	jr z,+
	ld c,$06
+
	ld a,b
	cp c
	ret nz
	ld e,Interaction.direction
	xor $04
	ld (de),a

	ld h,d
	ld l,Interaction.direction
	ld a,(hl)
	add a
	add a
	ld l,Interaction.angle
	ld (hl),a

	ld l,Interaction.counter1
	ld (hl),$40

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,SND_MOVEBLOCK
	call playSound
	jp interactionIncState


; Link has pushed the block; waiting for it to move to the other side
@state2:
	call objectApplySpeed
	call objectPreventLinkFromPassing
	call interactionDecCounter1
	ret nz
	ld (hl),70
	jp interactionIncState


; Pushed block from right to left
@subid0State3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid0Substate0
	.dw @subid0Substate1
	.dw @subid0Substate2
	.dw @subid0Substate3
	.dw @subid0Substate4
	.dw @subid0Substate5
	.dw @subid0Substate6
	.dw @subid0Substate7
	.dw @subid0Substate8
	.dw @subid0Substate9
	.dw @substateA
	.dw @substateB

@subid0Substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,SND_FLOODGATES
	call playSound
	ld a,$63
	call @setInterleavedHoleGroundTile
	ld a,$65
	call @setInterleavedHoleGroundTile
	jp interactionIncSubstate

@subid0Substate1:
	ldbc $63,$65
@setGroundTilesWhenCounterIsZero:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,b
	call @setGroundTile
	ld a,c
	call @setPuddleTile
	jp interactionIncSubstate

@subid0Substate2:
	ldbc $62,$66
@setHoleTilesWhenCounterIsZero:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,b
	call @setInterleavedHoleGroundTile
	ld a,c
	call @setInterleavedHoleGroundTile
	jp interactionIncSubstate

@subid0Substate3:
	ldbc $62,$66
	jr @setGroundTilesWhenCounterIsZero

@subid0Substate4:
	ldbc $61,$67
	jr @setHoleTilesWhenCounterIsZero

@subid0Substate5:
	ldbc $61,$67
	jr @setGroundTilesWhenCounterIsZero

@subid0Substate6:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$60
	call @setInterleavedPuddleHoleTile
	ld a,$68
	call @setInterleavedHoleGroundTile
	jp interactionIncSubstate

@subid0Substate7:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$60
	call @setHoleTile
	ld a,$68
	call @setPuddleTile
	jp interactionIncSubstate

@subid0Substate8:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$69
	call @setInterleavedPuddleHoleTile
	jp interactionIncSubstate

@subid0Substate9:
	call interactionDecCounter1
	ret nz
	ld (hl),90
	ld c,$69

@setWaterTileAndIncSubstate:
	ld a,TILEINDEX_WATER
	call setTile
	jp interactionIncSubstate

@substateA:
	call interactionDecCounter1
	ret nz
	ld (hl),$48
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionIncSubstate

@substateB:
	call interactionDecCounter1
	ret nz
	ld a,(wActiveMusic)
	call playSound
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call @swapRoomLayouts
	jp interactionIncState

;;
; @param	a	Position
@setHoleTile:
	ld c,a
	ld a,TILEINDEX_HOLE
	jp setTile

;;
; @param	a	Position
@setInterleavedPuddleHoleTile:
	ld hl,@@data
	jr @setInterleavedTile

@@data:
	.db $f3 $f9 $03

;;
; @param	a	Position
@setInterleavedHolePuddleTile:
	ld hl,@@data
	jr @setInterleavedTile

@@data:
	.db $f3 $f9 $01

;;
; @param	a	Position
@setGroundTile:
	push bc
	ld c,a
	ld a,$1b
	call setTile
	pop bc
	ret

;;
; @param	a	Position
@setPuddleTile:
	push bc
	ld c,a
	ld a,TILEINDEX_PUDDLE
	call setTile
	pop bc
	ret

;;
; @param	a	Position
@setInterleavedHoleGroundTile:
	ld hl,@@data
	jr @setInterleavedTile

@@data:
	.db $1b $f9 $03

@setInterleavedGroundHoleTile:
	ld hl,@@data
	jr @setInterleavedTile

@@data:
	.db $1b $f9 $01

;;
; @param	a	Position
; @param	hl	Interleaved tile data
@setInterleavedTile:
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	jp setInterleavedTile

@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid1State0
	.dw @state1
	.dw @state2
	.dw @subid1State3
	.dw objectPreventLinkFromPassing

@subid1State0:
	call getThisRoomFlags
	and $01
	jp z,interactionDelete
	jp @initialize

; Pushed block from left to right
@subid1State3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid1Substate0
	.dw @subid1Substate1
	.dw @subid1Substate2
	.dw @subid1Substate3
	.dw @subid1Substate4
	.dw @subid1Substate5
	.dw @subid1Substate6
	.dw @subid1Substate7
	.dw @subid1Substate8
	.dw @subid1Substate9
	.dw @substateA
	.dw @substateB

@subid1Substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,SND_FLOODGATES
	call playSound
	ld a,$63
	call @setInterleavedGroundHoleTile
	ld a,$65
	call @setInterleavedGroundHoleTile
	jp interactionIncSubstate

@subid1Substate1:
	ldbc $65,$63
	jp @setGroundTilesWhenCounterIsZero

@subid1Substate2:
	ldbc $66,$62
@setHoleTilesWhenCounterZero_2:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,b
	call @setInterleavedGroundHoleTile
	ld a,c
	call @setInterleavedGroundHoleTile
	jp interactionIncSubstate

@subid1Substate3:
	ldbc $66,$62
	jp @setGroundTilesWhenCounterIsZero

@subid1Substate4:
	ldbc $61,$67
	jp @setHoleTilesWhenCounterZero_2

@subid1Substate5:
	ldbc $67,$61
	jp @setGroundTilesWhenCounterIsZero

@subid1Substate6:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$60
	call @setInterleavedHolePuddleTile
	ld a,$68
	call @setInterleavedGroundHoleTile
	jp interactionIncSubstate

@subid1Substate7:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$68
	call @setGroundTile
	ld c,$60
	jp @setWaterTileAndIncSubstate

@subid1Substate8:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$69
	call @setInterleavedHolePuddleTile
	jp interactionIncSubstate

@subid1Substate9:
	call interactionDecCounter1
	ret nz
	ld (hl),$5a
	ld a,$69
	call @setHoleTile
	jp interactionIncSubstate

;;
; Swap the room layouts in all rooms affected by the flooding.
@swapRoomLayouts:
	call getThisRoomFlags
	ld l,<ROOM_AGES_140
	call @@xor
	call @@xor
	call @@xor
	ld l,<ROOM_AGES_150
	call @@xor
	call @@xor
	call @@xor
	dec h
	ld l,<ROOM_AGES_040
	call @@xor
	call @@xor
	call @@xor
	ld l,<ROOM_AGES_050
	call @@xor
	call @@xor

@@xor:
	ld a,(hl)
	xor $01
	ldi (hl),a
	ret
