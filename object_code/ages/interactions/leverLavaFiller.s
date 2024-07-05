; ==================================================================================================
; INTERAC_LEVER_LAVA_FILLER
;
; Variables:
;   counter2: Number of frames between two lava tiles being filled. Effectively this sets the
;             "speed" of the lava filler (lower is faster).
; ==================================================================================================
interactionCoded8:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@counter2Vals
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.counter2
	ld (de),a
	jp interactionIncState

@counter2Vals:
	.db $04 $06 $06 $06 $06 $06 $06 $06


; Waiting for lever to be pulled
@state1:
	ld a,(wLever1PullDistance)
	bit 7,a
	ret z

	; Lever has been pulled all the way.

	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30

	ld a,SND_SOLVEPUZZLE
	call playSound

	call @loadScriptForSubid

@toggleLavaSource:
	ld b,$06
	ld a,TILEINDEX_LAVA_SOURCE_UP_LEFT
	call findTileInRoom
	jr z,@setOrUnsetLavaSource

	ld a,TILEINDEX_LAVA_SOURCE_DOWN_LEFT
	call findTileInRoom
	jr z,@setOrUnsetLavaSource

	ld b,$fa
	ld a,TILEINDEX_LAVA_SOURCE_UP_LEFT_EMPTY
	call findTileInRoom
	jr z,@setOrUnsetLavaSource

	ld a,TILEINDEX_LAVA_SOURCE_DOWN_LEFT_EMPTY
	call findTileInRoom

; Turns the lava source "on" or "off", visually (by adding or subtracting 6 from the tile index).
@setOrUnsetLavaSource:
	ld a,b
	ldh (<hFF8D),a
	call @updateTile
--
	inc l
	ld a,(hl)
	sub TILEINDEX_LAVA_SOURCE_UP_LEFT
	cp $0c
	ret nc
	call @updateTile
	jr --

@updateTile:
	ldh a,(<hFF8D)
	ld b,(hl)
	add b
	ld c,l
	push hl
	call setTile
	pop hl
	ret

@loadScriptForSubid:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetMiniScript


; Floor is being filled
@state2:
	call interactionDecCounter1
	ret nz

	; Fill next group of tiles
	inc l
	ldd a,(hl)
	ld (hl),a  ; [counter1] = [counter2]
	call interactionGetMiniScript
	ldi a,(hl)
	or a
	jp z,interactionIncState

--
	ld c,a
	ld a,TILEINDEX_DRIED_LAVA
	push hl
	call setTileInAllBuffers
	pop hl
	ldi a,(hl)
	or a
	jr nz,--

	call interactionSetMiniScript
	jp @playRumbleSound


; Tiles have been filled. Waiting for lever to revert to starting position.
@state3:
	ld a,(wLever1PullDistance)
	or a
	ret nz

	call interactionIncState
	call @loadScriptForSubid
	call @toggleLavaSource
	ld a,SND_DOORCLOSE
	jp playSound


; Tiles are being filled with lava again.
@state4:
	call interactionDecCounter1
	ret nz
	inc l
	ldd a,(hl)
	ld (hl),a  ; [counter1] = [counter2]
	call interactionGetMiniScript
	ldi a,(hl)
	or a
	jr nz,@fillNextGroupWithLava

	; Done filling the lava back.
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret

@fillNextGroupWithLava:
	ld c,a

	; Random lava tile
	call getRandomNumber
	and $03
	add TILEINDEX_DUNGEON_LAVA_1

	push hl
	call setTileInAllBuffers
	pop hl
	ldi a,(hl)
	or a
	jr nz,@fillNextGroupWithLava

	call interactionSetMiniScript
	jp @playRumbleSound

@playRumbleSound:
	ld a,SND_RUMBLE2
	jp playSound


; "Script" format:
;   A string of bytes, ending with "$00", is a list of tile positions to fill with lava on a frame.
;   The data following the "$00" bytes will be read on a later frame. The gap between frames depends
;   on the value of [counter2].
;   If data starts with "$00", the list is done being read.
@scriptTable:
	.dw @subid0Script
	.dw @subid1Script
	.dw @subid2Script
	.dw @subid3Script
	.dw @subid4Script
	.dw @subid5Script

; D4, 1st lava-filler room
@subid0Script:
	.db $2a $00
	.db $2b $00
	.db $29 $00
	.db $3b $00
	.db $39 $00
	.db $4b $00
	.db $4a $00
	.db $49 $00
	.db $5b $00
	.db $5a $00
	.db $59 $00
	.db $6b $00
	.db $6a $00
	.db $7b $00
	.db $8b $00
	.db $7a $00
	.db $8a $00
	.db $9a $00
	.db $69 $00
	.db $99 $00
	.db $89 $00
	.db $79 $00
	.db $98 $00
	.db $88 $00
	.db $97 $00
	.db $78 $00
	.db $96 $00
	.db $88 $00
	.db $87 $00
	.db $95 $00
	.db $86 $00
	.db $85 $00
	.db $77 $00
	.db $76 $00
	.db $75 $00
	.db $66 $00
	.db $65 $00
	.db $56 $00
	.db $55 $00
	.db $45 $00
	.db $35 $00
	.db $00

; D4, 2 rooms before boss key
@subid1Script:
	.db $77 $78 $79 $00
	.db $7a $69 $68 $67 $66 $76 $00
	.db $6a $65 $75 $00
	.db $64 $74 $00
	.db $84 $85 $00
	.db $94 $95 $00
	.db $83 $93 $00
	.db $82 $92 $00
	.db $81 $91 $00
	.db $71 $72 $00
	.db $61 $62 $00
	.db $51 $52 $00
	.db $41 $42 $00
	.db $31 $32 $00
	.db $21 $22 $00
	.db $11 $12 $00
	.db $13 $23 $00
	.db $14 $24 $00
	.db $34 $00
	.db $44 $00
	.db $35 $45 $00
	.db $36 $00
	.db $46 $00
	.db $47 $26 $00
	.db $16 $27 $48 $00
	.db $28 $38 $49 $00
	.db $29 $39 $00
	.db $00

; D4, 1 room before boss key
@subid2Script:
	.db $37 $38 $39 $00
	.db $47 $48 $49 $00
	.db $58 $59 $00
	.db $68 $00
	.db $67 $00
	.db $77 $00
	.db $87 $00
	.db $96 $00
	.db $85 $00
	.db $75 $00
	.db $55 $64 $00
	.db $56 $00
	.db $73 $45 $00
	.db $83 $35 $00
	.db $25 $00
	.db $92 $15 $00
	.db $81 $00
	.db $71 $00
	.db $61 $00
	.db $51 $00
	.db $42 $00
	.db $33 $00
	.db $13 $22 $00
	.db $21 $00
	.db $00

; D8, lava room with keyblock
@subid3Script:
	.db $24 $25 $26 $00
	.db $34 $35 $36 $00
	.db $44 $45 $46 $00
	.db $54 $55 $00
	.db $64 $65 $00
	.db $73 $74 $75 $00
	.db $83 $00
	.db $81 $82 $00
	.db $91 $92 $00
	.db $93 $00
	.db $94 $00
	.db $95 $00
	.db $96 $00
	.db $86 $00
	.db $77 $87 $97 $00
	.db $78 $88 $00
	.db $79 $89 $99 $00
	.db $7a $8a $9a $00
	.db $6a $00
	.db $5a $00
	.db $59 $00
	.db $58 $00
	.db $48 $00
	.db $00

; D8, other lava room
@subid4Script:
	.db $24 $25 $26 $00
	.db $34 $35 $17 $27 $00
	.db $36 $37 $00
	.db $44 $45 $46 $47 $00
	.db $18 $28 $38 $48 $00
	.db $57 $58 $39 $49 $00
	.db $55 $56 $19 $29 $00
	.db $54 $59 $00
	.db $68 $69 $4a $5a $00
	.db $67 $3a $6a $00
	.db $65 $66 $1a $2a $00
	.db $64 $6b $7a $7b $00
	.db $78 $79 $4b $5b $00
	.db $76 $77 $2b $3b $00
	.db $74 $75 $1b $00
	.db $8a $8b $5c $6c $00
	.db $88 $89 $3c $4c $00
	.db $86 $87 $1c $2c $00
	.db $84 $85 $5d $6d $00
	.db $73 $83 $4d $00
	.db $1d $2d $3d $00
	.db $71 $72 $82 $00
	.db $81 $97 $99 $9b $00
	.db $91 $92 $93 $95 $00
	.db $94 $96 $98 $9a $00
	.db $00

; Hero's Cave lava room
@subid5Script:
	.db $26 $28 $27 $00
	.db $25 $00
	.db $35 $00
	.db $34 $00
	.db $44 $54 $43 $00
	.db $42 $64 $00
	.db $52 $74 $00
	.db $84 $00
	.db $93 $94 $95 $00
	.db $92 $96 $00
	.db $82 $91 $97 $00
	.db $81 $87 $00
	.db $77 $88 $00
	.db $78 $89 $00
	.db $8a $00
	.db $7a $8b $00
	.db $6a $7b $8c $00
	.db $5a $8d $9c $00
	.db $5b $9d $00
	.db $5c $00
	.db $4c $5d $6c $00
	.db $6d $00
	.db $3c $00
	.db $3d $00
	.db $2b $2d $00
	.db $1b $1d $00
	.db $00
