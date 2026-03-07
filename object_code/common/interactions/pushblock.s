; ==================================================================================================
; INTERAC_PUSHBLOCK
;
; Variables:
;   var30: Initial position of block being pushed (set by whatever spawn the object)
;   var31: Tile index being pushed (this is also read by INTERAC_PUSHBLOCK_SYNCHRONIZER)
; ==================================================================================================
interactionCode14:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
.ifdef ROM_SEASONS
	.dw @state2
.endif

; State 0: block just pushed.
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	; var30 is the position of the block being pushed.
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)

	; Set var31 to be the tile index to imitate.
	ld e,Interaction.var31
	ld (de),a
	call objectMimicBgTile

.ifdef ROM_AGES
	call @checkRotatingCubePermitsPushing
	jp c,interactionDelete
.endif

	ld a,$06
	call objectSetCollideRadius
	call @loadPushableTileProperties

	; If bit 2 of var34 is set, there's only a half-tile; animation 1 will flip it.
	; (Pots are like this). Otherwise, for tiles that aren't symmetrical, it will use
	; two consecutive tiles
	ld h,d
	ld l,Interaction.var34
.ifdef ROM_SEASONS
	ld a,(hl)
	and $02
	jr z,+
	ld e,Interaction.state
	ld a,$02
	ld (de),a
+
.endif
	bit 2,(hl)
	ld a,$01
	call nz,interactionSetAnimation

	; Determine speed to push with (L-2 bracelet pushes faster)
	ld h,d
	ldbc SPEED_80, $20
.ifdef ROM_AGES
	ld a,(wBraceletLevel)
	cp $02
	jr nz,+
	ld l,Interaction.var34
	bit 5,(hl)
	jr nz,+
	ldbc SPEED_c0, $15
+
.endif
	ld l,Interaction.speed
	ld (hl),b
	ld l,Interaction.counter1
	ld (hl),c

	ld l,Interaction.angle
	ld a,(hl)
	or $80
	ld (wBlockPushAngle),a

	call @replaceTileUnderneathBlock
	call objectSetVisible82

	ld a,SND_MOVEBLOCK
	call playSound

@state1:
	call @updateZPositionForButton
	call objectApplySpeed
	call objectPreventLinkFromPassing

	call interactionDecCounter1
	ret nz

; Finished moving; decide what to do next
@func_449d:

	call objectReplaceWithAnimationIfOnHazard
	jp c,interactionDelete

	; Update var30 with the new position.
	call objectGetShortPosition
	ld e,Interaction.var30
	ld (de),a

	; If the tile to place at the destination position is defined, place it.
	ld e,Interaction.var33
	ld a,(de)
	or a
	jr z,++
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	ld a,b
	call setTile
++
	; Check whether to play the sound
	ld e,Interaction.var34
	ld a,(de)
	rlca
	jr nc,++
	xor a
	ld (wDisabledObjects),a
	ld a,SND_SOLVEPUZZLE
	call playSound
++
	jp interactionDelete

.ifdef ROM_SEASONS
@state2:
	call @updateZPositionForButton
	ld e,Interaction.speed
	ld a,SPEED_1c0
	ld (de),a
	call objectApplySpeed
	call objectPreventLinkFromPassing
	call @@func_438a
	ret z
	ld a,SND_CLINK
	call playSound
	jr @func_449d
@@func_438a:
	ld e,Interaction.angle
	ld a,(de)
	call convertAngleDeToDirection
	ld hl,@@table_43a2
	rst_addDoubleIndex
	ld e,Interaction.yh
	ld a,(de)
	add (hl)
	ld b,a
	inc hl
	ld e,Interaction.xh
	ld a,(de)
	add (hl)
	ld c,a
	jp getTileCollisionsAtPosition
@@table_43a2:
	.db $f8 $00
	.db $00 $08
	.db $08 $00
	.db $00 $f8
.endif

;;
; If this object is on top of an unpressed button, this raises the z position by 2 pixels.
@updateZPositionForButton:
	ld a,(wTilesetFlags)
	and (TILESETFLAG_LARGE_INDOORS | TILESETFLAG_DUNGEON)
	ret z
	call objectGetShortPosition
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	cp TILEINDEX_BUTTON
	ld a,-2
	jr z,+
	xor a
+
	ld e,Interaction.zh
	ld (de),a
	ret

;;
; Replaces the tile underneath the block with whatever ground tile it should be. This
; first checks w3RoomLayoutBuffer for what the tile there should be. If that tile is
; non-solid, it uses that; otherwise, it uses [var32] as the new tile index.
;
; @param	c	Position
@replaceTileUnderneathBlock:
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	call getTileIndexFromRoomLayoutBuffer_paramC
	jp nc,setTile

	ld e,Interaction.var32
	ld a,(de)
	jp setTile

.ifdef ROM_AGES
;;
; This appears to check whether pushing blocks $2c-$2e (colored blocks) is permitted,
; based on whether a rotating cube is present, and whether the correct color flames for
; the cube are lit.
;
; @param[out]	cflag	If set, this interaction will delete itself?
@checkRotatingCubePermitsPushing:
	ld a,(wRotatingCubePos)
	or a
	ret z
	ld a,(wRotatingCubeColor)
	bit 7,a
	jr z,++
	and $7f
	ld b,a
	ld e,Interaction.var31
	ld a,(de)
	sub TILEINDEX_RED_PUSHABLE_BLOCK
	cp b
	ret z
++
	scf
	ret
.endif

;;
; Loads var31-var34 with some variables relating to pushable blocks (see below).
@loadPushableTileProperties:
.ifdef ROM_AGES
	ld a,(wActiveCollisions)
.else
	ld a,(wActiveGroup)
.endif
	ld hl,pushableTilePropertiesTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	ld e,Interaction.var31
	ld a,(de)
	ld b,a
--
	ldi a,(hl)
	or a
	ret z
	cp b
	jr z,@match
	inc hl
	inc hl
	inc hl
	jr --

@match:
	; Write data to var31-var34.
	ld (de),a
	ldi a,(hl)
	inc e
	ld (de),a
	ldi a,(hl)
	inc e
	ld (de),a
	ldi a,(hl)
	inc e
	ld (de),a
	ret

.include {"{GAME_DATA_DIR}/tile_properties/pushableTiles.s"}
