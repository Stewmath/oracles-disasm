; ==================================================================================================
; INTERAC_SMOG_BOSS
;
; Variables:
;   subid:    The index of the last enemy spawned. Incremented each time "@spawnEnemy" is
;             called. This should start at $ff.
;   var03:    Phase of fight
;   var18/19: Pointer to "tile replacement data" while in the process of replacing the
;             room's tiles
;   var30/31: Destination at which to place Link for the next phase
;   var32-34: For the purpose of removing blocks at the end of a phase, this keeps track
;             of the position we're at in the removal loop, and the number of columns or
;             rows remaining to check.
;   var35:    Remembers the value of "subid" at the start of this phase so it can be
;             restored if Link hits the reset button.
; ==================================================================================================
interactionCode33:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
	.dw @state8
	.dw @state9
	.dw @stateA

@state0:
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete

	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,($cc93)
	or a
	ret nz

	inc a
	ld (de),a ; [state] = 1

	call @spawnEnemy
	jp objectCreatePuff

; Waiting for Link to complete this phase
@state1:
	ld a,(wNumEnemies)
	dec a
	ret nz
	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	jp interactionIncState

@state2:
	; Raise Link off the floor
	ld hl,w1Link.zh
	dec (hl)
	ld a,$f9
	cp (hl)
	ret c

	; Get the position to place Link at
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@linkPlacementPositions
	rst_addDoubleIndex
	ld e,Interaction.var30
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	jp interactionIncState

; Moving Link to the target position (var30/var31)
@state3:
	ld hl,w1Link.yh
	ld e,Interaction.var30
	ld a,(de)
	cp (hl)
	jp nz,@incOrDecPosition

	ld l,<w1Link.xh
	inc e
	ld a,(de)
	cp (hl)
	jp nz,@incOrDecPosition
	jp interactionIncState

@incOrDecPosition:
	jr c,+
	inc (hl)
	ret
+
	dec (hl)
	ret

; Moving Link back to the ground
@state4:
	ld hl,w1Link.zh
	inc (hl)
	ret nz
	jp interactionIncState

; Waiting for Link to complete this phase?
@state5:
	ld a,(wNumEnemies)
	dec a
	ret nz

	ld e,Interaction.var03
	ld a,(de)
	ld hl,@tileReplacementTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	ld e,Interaction.var18
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld e,Interaction.counter1
	ld a,$05
	ld (de),a
	jp interactionIncState

; Generate the tiles to be used in this phase
@state6:
	call interactionDecCounter1
	ret nz

	ld (hl),$05

	; Retrieve pointer to tile replacement data
	ld l,Interaction.var18
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,(hl)
	or a
	jp z,interactionIncState

	; First byte read was position; move interaction here for the purpose of creating
	; the "poof".
	call convertShortToLongPosition
	ld e,Interaction.yh
	ld a,b
	ld (de),a
	ld e,Interaction.xh
	ld a,c
	ld (de),a

	; Change the tile index
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	ret z

	; Save pointer
	ld e,Interaction.var18
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	jp objectCreatePuff

; Spawn the enemies
@state7:
	call interactionDecCounter1
	ret nz

	call getThisRoomFlags
	res 6,(hl)

	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.var35
	ld (de),a

	; Spawn the enemies
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@numEnemiesToSpawn
	rst_addAToHl
	ld a,(hl)
--
	call @spawnEnemy
	dec a
	jr nz,--

	ld (wDisableLinkCollisionsAndMenu),a

	; Return position to top-left corner
	ld a,$18
	ld e,Interaction.xh
	ld (de),a
	sub $04
	ld e,Interaction.yh
	ld (de),a

	jp interactionIncState


; Run the phase; constantly checks whether any 2 enemies are close enough to merge.
@state8:
	; If [wNumEnemies] == 1, this phase is over
	ld a,(wNumEnemies)
	dec a
	jp z,interactionIncState

	; If [wNumEnemies] == 2, there's only one, big smog on-screen. Don't allow Link to
	; reset the phase at this point?
	dec a
	jr z,@checkMergeSmogs

	; Check whether the switch tile has changed (Link's stepped on it)
	call objectGetTileAtPosition
	cp TILEINDEX_BUTTON
	jr nz,@buttonPressed

	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	jr nz,@checkMergeSmogs

	ld a,(wLinkInAir)
	or a
	jr nz,@checkMergeSmogs

	ld c,$04
	call objectCheckLinkWithinDistance
	jr nc,@checkMergeSmogs

	; Switch pressed
	ld a,TILEINDEX_PRESSED_BUTTON
	ld c,$11
	call setTile

@buttonPressed:
	; Subtract health as a penalty
	ld hl,wLinkHealth
	ld a,(hl)
	cp $0c
	jr c,+
	sub $04
	ld (hl),a
+
	ld a,SND_SPLASH
	call playSound
	call getThisRoomFlags
	set 6,(hl)
	ld e,Interaction.var35
	ld a,(de)
	ld e,Interaction.subid
	ld (de),a
	call interactionIncState
	jr @nextPhase

; Check up to 3 smog enemies to see whether they should merge
@checkMergeSmogs:
	call @findFirstSmogEnemy
	ret nz
	push hl
	call @findNextSmogEnemy
	pop bc
	ret nz

	call @checkEnemiesCloseEnoughToMerge
	jr c,@mergeSmogs

	call @findNextSmogEnemy
	ret nz
	call @checkEnemiesCloseEnoughToMerge
	jr c,@mergeSmogs

	push hl
	ld h,b
	call @findNextSmogEnemy
	push hl
	pop bc
	pop hl
	call @checkEnemiesCloseEnoughToMerge
	ret nc

; Merge smogs 'b' and 'h'
@mergeSmogs:
	ld l,Enemy.subid
	ld c,l
	ld a,(bc)
	xor (hl)
	and $80
	ld (bc),a

	; Set subid to $06; slate it for deletion, maybe?
	ld (hl),$06

	; This sets hl to a brand new enemy slot
	call getFreeEnemySlot
	ld (hl),ENEMY_SMOG

	ld a,(bc)
	ld l,c
	or $03
	ldi (hl),a ; [new subid] = [old subid] | 3

	; Slate the other old smog for deletion?
	ld a,$06
	ld (bc),a

	; [New var03] = [Interaction.var03]
	ld e,Interaction.var03
	ld a,(de)
	ldi (hl),a

	ld l,Enemy.counter2
	ld (hl),$05

	; Copy old smog's direction
	inc l
	ld c,l
	ld a,(bc)
	ld (hl),a

	; Copy old smog's position
	ld l,Enemy.yh
	ld c,l
	ld a,(bc)
	ldi (hl),a
	inc l
	ld c,l
	ld a,(bc)
	ld (hl),a
	ret


; Smog destroyed; proceed to the next phase
@state9:
	ld e,Interaction.var03
	ld a,(de)
	inc a
	ld (de),a
	cp $04
	jr nz,@nextPhase

	; Final phase completed
	call decNumEnemies
	jp interactionDelete

@nextPhase:
	ld e,Interaction.counter1
	ld a,$05
	ld (de),a

	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

; Initialize variables for the next phase (they keep track of the position we're at for
; removing block tiles)

	ld e,Interaction.var32
	ld a,$11
	ld (de),a ; var32

	ld a, LARGE_ROOM_HEIGHT-2
	inc e
	ld (de),a ; var33

	inc e
	ld a, LARGE_ROOM_WIDTH-2
	ld (de),a ; var34

	jp interactionIncState


; Clearing out all blocks on-screen in preparation for next phase
@stateA:
	call interactionDecCounter1
	ret nz

	ld a,$05
	ld (hl),a

	ld l,Interaction.var32
	ldi a,(hl)
	ld b,(hl)
	ld l,a
	ld h,>wRoomCollisions
@nextRow:
	ld e,Interaction.var34
	ld a,(de)
	ld c,a
@nextColumn:
	ld a,(hl)
	or a
	jr nz,@foundNextBlockTile

	ld e,Interaction.var32
	inc l
	ld a,l
	ld (de),a
	dec c
	ld e,Interaction.var34
	ld a,c
	ld (de),a
	jr nz,@nextColumn

	; Reset number of columns to check for the next row
	ld a,LARGE_ROOM_WIDTH-2
	ld (de),a

	; Adjust position for the next row
	ld c,a
	ld e,Interaction.var32
	ld a,l
	add ($10 - (LARGE_ROOM_WIDTH-2))
	ld (de),a

	ld l,a
	inc e ; e = var33
	dec b
	ld a,b
	ld (de),a
	jr nz,@nextRow

	; Return to state 1 to begin the next phase
	ld a,$01
	ld e,Interaction.state
	ld (de),a
	ret

@foundNextBlockTile:
	ld a,l
	ld e,Interaction.yh
	and $f0
	or $08
	ld (de),a
	ld e,Interaction.xh
	ld a,l
	swap a
	and $f0
	or $08
	ld (de),a

	ld c,l
	ld a,$a3
	call setTile
	jp objectCreatePuff


;;
@findFirstSmogEnemy:
	ld h,FIRST_ENEMY_INDEX-1

;;
; @param	h	Enemy index after which to start looking
; @param[out]	h	Index of first found smog enemy
; @param[out]	zflag	nz if no such enemy was found
@findNextSmogEnemy:
	inc h
---
	ld l,Enemy.enabled
	ldi a,(hl)
	or a
	jr z,@nextEnemy
	ldi a,(hl)
	cp ENEMY_SMOG
	jr nz,@nextEnemy
	ldi a,(hl)
	bit 1,a
	jr z,@nextEnemy
	xor a
	ret

@nextEnemy:
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,---
	or d
	ret

;;
@spawnEnemy:
	push af
	call getFreeEnemySlot
	ld (hl),ENEMY_SMOG

	; Increment this.subid, which acts as the "enemy index" to spawn
	ld b,h
	ld e,Interaction.subid
	ld a,(de)
	inc a
	ld (de),a
	add a
	ld hl,@smogEnemyData
	rst_addDoubleIndex

	ld c,Enemy.subid
	ldi a,(hl)
	ld (bc),a
	inc c
	ld e,Interaction.var03
	ld a,(de)
	ld (bc),a
	ld c,Enemy.yh
	ldi a,(hl)
	ld (bc),a
	ld c,Enemy.xh
	ldi a,(hl)
	ld (bc),a
	ld c,Enemy.direction
	ldi a,(hl)
	ld (bc),a
	pop af
	ret

;;
; @param	b	Enemy 1
; @param	h	Enemy 2
; @param[out]	cflag	Set if they're close enough to merge (within 4 pixels)
@checkEnemiesCloseEnoughToMerge:
	ld l,Enemy.var31
	ld c,l
	ld a,(bc)
	sub (hl)
	add $03
	cp $07
	ret nc

	ld l,Enemy.yh
	ld c,l
	ld a,(bc)
	sub (hl)
	add $04
	cp $09
	ret nc

	ld l,Enemy.xh
	ld c,l
	ld a,(bc)
	sub (hl)
	add $04
	cp $09
	ret

@tileReplacementTable:
	dbrel @phase0Tiles
	dbrel @phase1Tiles
	dbrel @phase2Tiles
	dbrel @phase3Tiles

; Data format:
;   b0: position
;   b1: tile index to place at that position

@phase0Tiles:
	.db $11 $0c
	.db $37 $1d
	.db $46 $1d
	.db $47 $1d
	.db $48 $1d
	.db $76 $1d
	.db $77 $1d
	.db $78 $1d
	.db $87 $1d
	.db $00

@phase1Tiles:
	.db $11 $0c
	.db $3a $1c
	.db $44 $1d
	.db $47 $1d
	.db $4a $1d
	.db $54 $1c
	.db $57 $1d
	.db $64 $1d
	.db $67 $1d
	.db $00

@phase2Tiles:
	.db $11 $0c
	.db $57 $1c
	.db $62 $1d
	.db $63 $1d
	.db $64 $1d
	.db $6a $1d
	.db $6b $1d
	.db $6c $1d
	.db $77 $1c
	.db $00

@phase3Tiles:
	.db $11 $0c
	.db $25 $1d
	.db $26 $1d
	.db $27 $1d
	.db $32 $1d
	.db $37 $1d
	.db $3a $1c
	.db $3c $1d
	.db $42 $1d
	.db $46 $1d
	.db $4c $1d
	.db $52 $1d
	.db $59 $1d
	.db $5c $1d
	.db $62 $1c
	.db $68 $1d
	.db $6c $1d
	.db $72 $1d
	.db $74 $1d
	.db $77 $1c
	.db $7c $1d
	.db $00

@numEnemiesToSpawn: ; Each byte is for a different phase
	.db $02 $03 $02 $03


; Data format:
;   b0: var03
;   b1: Y position
;   b2: X position
;   b3: direction

@smogEnemyData: ; Each row is for a different enemy (across all phases)
	.db $00 $58 $78 $00
	.db $02 $38 $68 $01
	.db $02 $88 $88 $03
	.db $82 $58 $a8 $01
	.db $02 $38 $48 $01
	.db $02 $78 $78 $03
	.db $02 $58 $38 $01
	.db $82 $78 $b8 $01
	.db $02 $28 $28 $01
	.db $82 $58 $88 $03
	.db $82 $88 $c8 $01


@linkPlacementPositions: ; Positions to drop Link at for each phase
	.db $58 $78
	.db $28 $78
	.db $38 $78
	.db $38 $68
