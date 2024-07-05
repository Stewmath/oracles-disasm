; ==================================================================================================
; INTERAC_EXTENDABLE_BRIDGE
; ==================================================================================================
interactionCode23:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	and $07
	ld hl,bitTable
	add l
	ld l,a
	ld a,(hl)
	inc e
	ld (de),a ; [var03] = bitmask corresponding to [subid]

	; Check whether the tile here is a bridge; go to state 2 if so, state 1 otherwise
	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	sub TILEINDEX_VERTICAL_BRIDGE
	sub $06
	ld a,$02
	jr c,+
	dec a
+
	ld e,Interaction.state
	ld (de),a
	ld e,Interaction.var30
	ld a,(wSwitchState)
	ld (de),a
	ret

; State 1: waiting for switch to toggle to create bridge
@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state1Substate0
	.dw @state1Substate1

@state1Substate0:
	call @checkSwitchStateChanged
	ret z
	ld hl,@bridgeCreationData

@startLoadingBridgeData:
	ld e,Interaction.var30
	ld a,(wSwitchState)
	ld (de),a

	ld e,Interaction.xh
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	ld e,Interaction.var31
	ld (de),a
	ld e,Interaction.relatedObj2
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld a,$0a
	ld e,Interaction.counter1
	ld (de),a
	jp interactionIncSubstate

@state1Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$0a
	call @updateNextTile
	ld a,c
	inc a
	jr z,@gotoNextState
	ld e,Interaction.var31
	ld a,(de)
	call setTile
	ld a,SND_DOORCLOSE
	jp playSound

@gotoNextState:
	call interactionIncState
	inc l
	ld (hl),$00
	ret

; State 2: waiting for switch to toggle to remove bridge
@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state2Substate0
	.dw @state2Substate1

@state2Substate0:
	call @checkSwitchStateChanged
	ret z
	ld hl,@bridgeRemovalData
	jr @startLoadingBridgeData

@state2Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$0a

	call @updateNextTile
	ld a,c
	inc a
	jr z,@gotoState1
	ld e,Interaction.var31
	ld a,(de)
	call setTile
	ld a,SND_DOORCLOSE
	jp playSound

@gotoState1:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	inc l
	ld (hl),$00
	ret

;;
; @param[out]	zflag	nz if the switch has been toggled
@checkSwitchStateChanged:
	ld a,(wSwitchState)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	xor b
	ld b,a
	ld e,Interaction.var03
	ld a,(de)
	and b
	ret

;;
; @param[out]	c	Next byte
@updateNextTile:
	ld h,d
	ld l,Interaction.relatedObj2
	ld e,l
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	ld c,a

	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret


; Which data is read from here depends on the value of "Interaction.xh".
@bridgeCreationData:
	.dw @creation0
	.dw @creation1
	.dw @creation2
	.dw @creation3
	.dw @creation4
	.dw @creation5
	.dw @creation6

; Data format:
;   First byte is the tile index to create for the bridge.
;   Subsequent bytes are positions at which to create that tile until it reaches $ff.

@creation0:
	.db TILEINDEX_VERTICAL_BRIDGE   $43 $53 $63 $ff
@creation1:
	.db TILEINDEX_HORIZONTAL_BRIDGE $76 $77 $78 $79 $ff
@creation2:
	.db TILEINDEX_HORIZONTAL_BRIDGE $39 $38 $37 $36 $ff
@creation3:
	.db TILEINDEX_VERTICAL_BRIDGE   $42 $52 $62 $ff
@creation4:
	.db TILEINDEX_VERTICAL_BRIDGE   $4c $5c $6c $ff
@creation5:
	.db TILEINDEX_HORIZONTAL_BRIDGE $2a $29 $28 $27 $ff
@creation6:
	.db TILEINDEX_VERTICAL_BRIDGE   $3d $4d $5d $6d $ff


@bridgeRemovalData:
	.dw @removal0
	.dw @removal1
	.dw @removal2
	.dw @removal3
	.dw @removal4
	.dw @removal5
	.dw @removal6

; Data format is the same as above.
; TILEINDEX_HOLE+1 is a hole that's completely black (doesn't have "ground" surrounding
; it.)

@removal0:
	.db TILEINDEX_HOLE+1  $63 $53 $43 $ff
@removal1:
	.db TILEINDEX_HOLE+1  $79 $78 $77 $76 $ff
@removal2:
	.db TILEINDEX_HOLE+1  $36 $37 $38 $39 $ff
@removal3:
	.db TILEINDEX_HOLE+1  $62 $52 $42 $ff
@removal4:
	.db TILEINDEX_HOLE+1  $6c $5c $4c $ff
@removal5:
	.db TILEINDEX_HOLE+1  $27 $28 $29 $2a $ff
@removal6:
	.db TILEINDEX_HOLE+1  $6d $5d $4d $3d $ff
