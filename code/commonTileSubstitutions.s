; This is included at the end of the "code/<game>/tileSubstitutions.s" file.

;;
; Replaces a shutter link is about to walk on to with empty floor.
replaceShutterForLinkEntering:
.ifndef AGES_ENGINE
	ld a,(wDungeonIndex)
	inc a
	ret z
.endif
	ldbc >wRoomLayout, ((LARGE_ROOM_HEIGHT-1)<<4) + (LARGE_ROOM_WIDTH-1)
--
	ld a,(bc)
	push bc
	sub $78
	cp $08
	call c,@temporarilyOpenDoor
	pop bc
	dec c
	jr nz,--
	ret

; Replaces a door at position bc with empty floor, and adds an interaction to
; re-close it when link moves away (for minecart doors only)
@temporarilyOpenDoor:
	ld de,@shutterData
	call addDoubleIndexToDe
	ld a,(de)
	ldh (<hFF8B),a
	inc de
	ld a,(de)
	ld e,a
	ld a,(wScrollMode)
	and $08
	jr z,@doneReplacement

	ld a,(wLinkObjectIndex)
	ld h,a
	ld a,(wScreenTransitionDirection)
	xor $02
	ld d,a
	ld a,e
	and $03
	cp d
	ret nz

	ld a,(wScreenTransitionDirection)
	bit 0,a
	jr nz,@horizontal
; vertical
	and $02
	ld l,<w1Link.xh
	ld a,(hl)
	jr nz,@down
@up:
	and $f0
	swap a
	or $a0
	jr @doReplacement
@down:
	and $f0
	swap a
	jr @doReplacement

@horizontal:
	and $02
	ld l,<w1Link.yh
	ld a,(hl)
	jr nz,@left
@right:
	and $f0
	jr @doReplacement
@left:
	and $f0
	or $0e

@doReplacement:
	; Only replace if link is standing on the tile.
	cp c
	jr nz,@doneReplacement

	push bc
	ld c,a
	ld a,(bc)
	sub $78
	cp $08
	jr nc,+

	ldh a,(<hFF8B)
	ld (bc),a
+
	pop bc

@doneReplacement:
	; If bit 7 is set, don't add an auto-shutter interaction.
	ld a,e
	bit 7,a
	ret nz

	and $7f
	ld e,a

.ifdef AGES_ENGINE
	; If not in a dungeon, don't add an auto-shutter.
	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_DUNGEON,a
	ret z
.endif

	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_DOOR_CONTROLLER
	inc l
	ld (hl),e
	ld l,Interaction.yh
	ld (hl),c
	ret

; Data format:
; Byte 1 - tile to replace shutter with
; Byte 2 - bit 7: don't auto-close, bits 0-6: low byte of interaction id
@shutterData:
	.db $a0 $80 ; Normal shutters
	.db $a0 $81
	.db $a0 $82
	.db $a0 $83
	.db $5e $0c ; Minecart shutters
	.db $5d $0d
	.db $5e $0e
	.db $5d $0f

;;
replaceOpenedChest:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,a
	ret z

	call getChestData
	ld d,>wRoomLayout
	ld a,TILEINDEX_CHEST_OPENED
	ld (de),a
	ret

;;
; Replaces switch tiles and whatever they control if the switch is set.
; Groups 4 and 5 only.
replaceSwitchTiles:
	ld hl,@group4SwitchData
	ld a,(wActiveGroup)
	sub NUM_SMALL_GROUPS
	jr z,+

	dec a
	ret nz

	ld hl,@group5SwitchData
+
	ld a,(wActiveRoom)
	ld b,a
	ld a,(wSwitchState)
	ld c,a
	ld d,>wRoomLayout
@next:
	ldi a,(hl)
	or a
	ret z

	; Check room
	cp b
	jr nz,@skip3Bytes

	; Check if corresponding bit of wSwitchState is set
	ldi a,(hl)
	and c
	jr z,@skip2Bytes

	ldi a,(hl)
	ld e,(hl)
	inc hl
	ld (de),a
	jr @next

@skip3Bytes:
	inc hl
@skip2Bytes:
	inc hl
	inc hl
	jr @next


.ifdef ROM_AGES
	; Data format:
	;   b0: Room
	;   b1: Switch bit
	;   b2: New tile index
	;   b3: Position of tile to replace

	@group4SwitchData:
		.db $2f $02 $0b $79
		.db $2f $02 $5a $6c
		.db $3b $20 $af $79
		.db $4c $01 $0b $38
		.db $4e $02 $0b $68
		.db $53 $04 $0b $6a
		.db $72 $01 $af $8d
		.db $89 $04 $0b $62
		.db $89 $04 $5d $67
		.db $8f $08 $0b $81
		.db $8f $08 $5e $52
		.db $c7 $01 $0b $68
		.db $00

	@group5SwitchData:
		.db $00

.else; ROM_SEASONS

	@group4SwitchData:
		.db $0f $01 $0b $33
		.db $0f $01 $5a $74
		.db $6f $01 $0b $8c
		.db $6f $01 $5c $29
		.db $70 $02 $0b $28
		.db $70 $02 $5b $52
		.db $70 $04 $0b $59
		.db $70 $04 $5b $84
		.db $76 $08 $0b $17
		.db $76 $08 $5d $25
		.db $7e $10 $0b $56
		.db $7e $10 $5c $66
		.db $a0 $01 $5e $44
		.db $a0 $02 $5e $37
		.db $a0 $01 $0b $83
		.db $a0 $02 $0b $78
		.db $00

	@group5SwitchData:
		.db $7e $01 $5c $2b
		.db $7e $01 $0b $78
		.db $00

.endif

;;
applySingleTileChanges:
	ld a,(wActiveRoom)
	ld b,a
	call getThisRoomFlags
	ld c,a
	ld d,>wRoomLayout
	ld a,(wActiveGroup)
	ld hl,singleTileChangeGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
@next:
	; Check room
	ldi a,(hl)
	cp b
	jr nz,@notMatch

.ifdef AGES_ENGINE
	ld a,(hl)
	cp $f0
	jr z,@unlinkedOnly

	cp $f1
	jr z,@linkedOnly

	cp $f2
	jr z,@finishedGameOnly
.endif

	ld a,(hl)
	and c
	jr z,@notMatch

@match:
	inc hl
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld (de),a
	jr @next

@notMatch:
	ld a,(hl)
	or a
	ret z

	inc hl
	inc hl
	inc hl
	jr @next

.ifdef AGES_ENGINE

@unlinkedOnly:
	call checkIsLinkedGame
	jr nz,@notMatch
	jr @match

@linkedOnly:
	call checkIsLinkedGame
	jr z,@notMatch
	jr @match

@finishedGameOnly:
	ld a,GLOBALFLAG_FINISHEDGAME
	push hl
	call checkGlobalFlag
	pop hl
	ret z
	jr @match

.endif
