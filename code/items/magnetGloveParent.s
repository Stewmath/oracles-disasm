; Variables:
;  var37: ?
parentItemCode_magnetGloves:
.ifdef ROM_SEASONS
	ld a,(wLinkClimbingVine)
	inc a
	jr z,@deleteSelf
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,(wLinkSwimmingState)
	or a
	jr nz,@deleteSelf

	call itemIncState
	ld l,Item.var37
	ld (hl),$ff
	ld l,Item.relatedObj2
	xor a
	ldi (hl),a
	ld (hl),>w1WeaponItem
	call itemCreateChild
	call updateLinkDirectionFromAngle
	call setStatusBarNeedsRefreshBit1

@state1:
	ld a,(wLinkSwimmingState)
	or a
	jr nz,@invertPolarityAndStop
	ld a,(wLinkInAir)
	rlca
	jr c,@invertPolarityAndStop
	call parentItemCheckButtonPressed
	jr z,@invertPolarityAndStop

	ld a,SND_MAGNET_GLOVES
	call playSound
	ld a,(wMagnetGlovePolarity)
	scf
	adc a
	ld (wMagnetGloveState),a
	call itemDisableLinkTurning
	call @checkLatchedOntoTile
	ret z

	; Link moves toward something
	call objectGetRelativeAngleWithTempVars
	ld hl,wMagnetGloveState
	set 6,(hl)
	bit 1,(hl)
	jr nz,+
	xor $10
+
	ld e,Item.angle
	ld (de),a
	ld c,a
	ld a,$ff
	ld (w1Link.angle),a
	ld b,SPEED_180
	jp updateLinkPositionGivenVelocity

@invertPolarityAndStop:
	ld hl,wMagnetGlovePolarity
	ld a,(hl)
	xor $01
	ld (hl),a
	ld hl,wStatusBarNeedsRefresh
	set 0,(hl)

@deleteSelf:
	xor a
	ld (wMagnetGloveState),a
	jp clearParentItem

;;
; @param[out]	bc	Position of object locked on to
; @param[out]	zflag	nz if Link should move toward something
@checkLatchedOntoTile:
	ld a,(wLinkObjectIndex)
	xor $01
	and $01
	ret z

	ld a,(wActiveGroup)
	ld hl,magnetTilesTable
	rst_addAToHl
	ld a,(hl)
	or a
	ret z

	push de
	ld d,a
	ld a,(w1Link.direction)
	ld e,a
	add a
	add a
	add e
	ld hl,@offsetsToCheck
	rst_addAToHl
	ldi a,(hl)
	ld e,a
	call @searchForTile
	call z,@searchForTile
	pop de
	ret

;;
; @param	d	Tile index to check for
; @param	e	Offset value (ie. $10 for down)
; @param	hl	Y and X offsets (2 bytes)
@searchForTile:
	ld a,(w1Link.yh)
	ldh (<hFF8F),a
	add (hl)
	ld b,a
	inc hl
	ld a,(w1Link.xh)
	ldh (<hFF8E),a
	add (hl)
	ld c,a

	; Get tile in front of Link
	inc hl
	push hl
	call getTileAtPosition
	ld c,l
	ld b,h
	pop hl

@checkNextTile:
	or a
	jr z,@ret
	cp d
	jr z,@foundTile
	ld a,c
	add e
	ld c,a
	ld a,(bc)
	jr @checkNextTile

@foundTile:
	ld a,c
	and $f0
	or $08
	ld b,a
	ld a,c
	swap a
	and $f0
	or $08
	ld c,a
@ret:
	ret

; First byte is the direction to check for magnet tiles in.
; The next pairs of bytes are position offsets to check (it doesn't just check for a straight line
; from Link, rather it's more like a rectangle.)
@offsetsToCheck:
	.db $f0  $00 $fd  $00 $02 ; DIR_UP
	.db $01  $00 $00  $04 $00 ; DIR_RIGHT
	.db $10  $00 $fd  $00 $02 ; DIR_DOWN
	.db $ff  $00 $00  $04 $00 ; DIR_LEFT


.include {"{GAME_DATA_DIR}/tileProperties/magnetTiles.s"}

.endif ; ROM_SEASONS
