; ==================================================================================================
; PART_RESPAWNABLE_BUSH
; ==================================================================================================
partCode0f:
	jr z,@normalStatus

	; Just hit
	ld h,d
	ld l,Part.state
	inc (hl) ; [state] = 2

	ld l,Part.counter1
	ld (hl),$f0
	ld l,Part.collisionType
	res 7,(hl)

	ld a,TILEINDEX_RESPAWNING_BUSH_CUT
	call @setTileHere

	; 50/50 drop chance
	call getRandomNumber_noPreserveVars
	rrca
	jr nc,@doneItemDropSpawn

	call getFreePartSlot
	jr nz,@doneItemDropSpawn
	ld (hl),PART_ITEM_DROP
	inc l
	ld e,l
	ld a,(de)
	ld (hl),a ; [itemDrop.subid] = [this.subid]
	call objectCopyPosition

@doneItemDropSpawn:
	ld b,INTERAC_GRASSDEBRIS
	call objectCreateInteractionWithSubid00

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a
	ret

@state1:
	ret

; Delay before respawning
@state2:
	ld a,(wFrameCounter)
	rrca
	ret nc
	call partCommon_decCounter1IfNonzero
	ret nz

	; Time to respawn
	ld (hl),$0c ; [counter1]
	ld l,e
	inc (hl) ; [state] = 3
	ld a,TILEINDEX_RESPAWNING_BUSH_REGEN
	jr @setTileHere

@state3:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$08 ; [counter1]
	ld l,e
	inc (hl) ; [state] = 4
	ld a,TILEINDEX_RESPAWNING_BUSH_READY

;;
; @param	a	Tile index to set
@setTileHere:
	push af
	call objectGetShortPosition
	ld c,a
	pop af
	jp setTile


@state4:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	ld (hl),$01 ; [state] = 1

	ld l,Part.collisionType
	set 7,(hl)
	ret
