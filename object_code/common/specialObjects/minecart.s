;;
; Update a minecart object.
; (Called from bank5.specialObjectCode_minecart)
specialObjectCode_minecart:
	call minecartCreateCollisionItem
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1

@state0:
	; Set state to $01
	ld a,$01
	ld (de),a

	; Setup palette, etc
	callab bank5.specialObjectSetOamVariables

	ld h,d
	ld l,SpecialObject.speed
	ld (hl),SPEED_100

	ld l,SpecialObject.direction
	ld a,(hl)
	call specialObjectSetAnimation

	ld a,d
	ld (wLinkObjectIndex),a
	call setCameraFocusedObjectToLink

	; Resets link's animation if he's using an item, maybe?
	call clearVar3fForParentItems

	call clearPegasusSeedCounter

	ld hl,w1Link.z
	xor a
	ldi (hl),a
	ldi (hl),a

	jp objectSetVisiblec2

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call retIfTextIsActive

	ld a,(wScrollMode)
	and $0e
	ret nz

	ld a,(wDisabledObjects)
	and $81
	ret nz

	; Disable link's collisions?
	ld hl,w1Link.collisionType
	res 7,(hl)

	xor a
	ld l,<w1Link.knockbackCounter
	ldi (hl),a

	; Check if on the center of the tile (y)
	ld h,d
	ld l,SpecialObject.yh
	ldi a,(hl)
	ld b,a
	and $0f
	cp $08
	jr nz,++

	; Check if on the center of the tile (x)
	inc l
	ldi a,(hl)
	ld c,a
	and $0f
	cp $08
	jr nz,++

	; Minecart is centered on the tile

	call minecartCheckCollisions
	jr c,@minecartStopped

	; Compare direction to angle, ensure they're synchronized
	ld h,d
	ld l,SpecialObject.direction
	ldi a,(hl)
	swap a
	rrca
	cp (hl)
	jr z,++

	ldd (hl),a
	ld a,(hl)
	call specialObjectSetAnimation

++
	ld h,d
	ld l,SpecialObject.var35
	dec (hl)
	bit 7,(hl)
	jr z,+

	ld (hl),$1a
	ld a,SND_MINECART
	call playSound
+
	call objectApplySpeed
	jp specialObjectAnimate

@minecartStopped:
	; Go to state $02.
	; State $02 doesn't exist, so, good thing this is getting deleted anyway.
	ld e,SpecialObject.state
	ld a,$02
	ld (de),a

	call clearVar3fForParentItems

	; Force link to jump, lock his direction?
	ld a,$81
	ld (wLinkInAir),a

	; Copy / initialize various link variables

	ld hl,w1Link.angle
	ld e,SpecialObject.angle
	ld a,(de)
	ld (hl),a

	ld l,<w1Link.yh
	ld a,(hl)
	add $06
	ld (hl),a

	ld l,<w1Link.zh
	ld (hl),$fa

	ld l,<w1Link.speed
	ld (hl),SPEED_80

	ld l,<w1Link.speedZ
	ld (hl),$40
	inc l
	ld (hl),$fe

	; Re-enable terrain effects (shadow)
	ld l,<w1Link.visible
	set 6,(hl)

	; Change main object back to w1Link ($d000) instead of this object ($d100)
	ld a,>w1Link
	ld (wLinkObjectIndex),a
	call setCameraFocusedObjectToLink

	; Create the "interaction" minecart to replace the "special object" minecart
	ld b,INTERAC_MINECART
	call objectCreateInteractionWithSubid00
	jp objectDelete_useActiveObjectType

;;
; Check for collisions, check the track for changing direction.
; @param[out] cflag Set if the minecart should stop (reached a platform)
minecartCheckCollisions:
	; Get minecart position in c, tile it's on in e
	call getTileAtPosition
	ld e,a
	ld c,l

	; Try to find the relevant data in @trackData based on the tile the minecart is
	; currently on.
	ld h,d
	ld l,SpecialObject.direction
	ld a,(hl)
	swap a
	ld hl,@trackData
	rst_addAToHl
--
	ldi a,(hl)
	or a
	jr z,@noTrackFound

	cp e
	jr z,++

	ld a,$04
	rst_addAToHl
	jr --

	; Found a matching tile in @trackData
++
	; Add value to c to get the position of the next tile the minecart will move to.
	ldi a,(hl)
	add c
	ld c,a
	ldh (<hFF8B),a

	; Check for the edge of the room
	ld b,>wRoomCollisions
	ld a,(bc)
	cp $ff
	ret z

	; Check for a platform to disembark at
	ld b,>wRoomLayout
	ld a,(bc)
	cp TILEINDEX_MINECART_PLATFORM
	jr z,@stopMinecart

	; c will now store the value of the next tile.
	ld c,a

	; Check the next 3 bytes of @trackData to see if the next track tile is acceptable
	ld b,$03
--
	ldi a,(hl)
	cp c
	jr z,@updateDirection
	dec b
	jr nz,--
	jr @noTrackFound

@stopMinecart:
	; Set carry flag to give the signal that the ride is over.
	scf
	ret

@updateDirection:
	ld a,e
	sub TILEINDEX_TRACK_TL
	cp TILEINDEX_MINECART_PLATFORM - TILEINDEX_TRACK_TL
	jr c,++

@noTrackFound:
	; Index $06 will jump to @notTrack.
	ld a,$06
++
	ld e,SpecialObject.direction
	rst_jumpTable
	.dw @trackTL
	.dw @trackBR
	.dw @trackBL
	.dw @trackTR
	.dw @trackHorizontal
	.dw @trackVertical
	.dw @notTrack

@trackTL:
@trackBR:
	ld a,(de)
	xor $01
	ld (de),a
	ret

@trackBL:
@trackTR:
	ld a,(de)
	xor $03
	ld (de),a
	ret

@trackHorizontal:
	ld a,(de)
	and $02
	or $01
	ld (de),a
	ret

@trackVertical:
	ld a,(de)
	and $02
	ld (de),a
	ret

@notTrack:
	call @checkMinecartDoor
	jr nc,+

	; Next tile is a minecart door, keep going
	xor a
	ret
+
	; Reverse direction
	ld a,(de)
	xor $02
	ld (de),a
	ret

; b0: Tile to check for ($00 to end list)
; b1: Value to add to position (where the next tile is)
; b2-b4: Other tiles that are allowed to link to the current tile
@trackData:
	; DIR_UP
	.db TILEINDEX_TRACK_VERTICAL $f0 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_TL TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_TL       $01 TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BR TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_TR       $ff TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BL TILEINDEX_TRACK_TL
	.db $00

	; DIR_RIGHT
	.db TILEINDEX_TRACK_HORIZONTAL $01 TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BR TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_BR         $f0 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_TL TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_TR         $10 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_BL TILEINDEX_TRACK_BR
	.db $00

	; DIR_DOWN
	.db TILEINDEX_TRACK_VERTICAL $10 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_BR TILEINDEX_TRACK_BL
	.db TILEINDEX_TRACK_BR       $ff TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BL TILEINDEX_TRACK_TL
	.db TILEINDEX_TRACK_BL       $01 TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BR TILEINDEX_TRACK_TR
	.db $00

	; DIR_LEFT
	.db TILEINDEX_TRACK_HORIZONTAL $ff TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BL TILEINDEX_TRACK_TL
	.db TILEINDEX_TRACK_BL         $f0 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_TR TILEINDEX_TRACK_TL
	.db TILEINDEX_TRACK_TL         $10 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_BR TILEINDEX_TRACK_BL
	.db $00

;;
; @param	c	Next tile
; @param[out]	cflag	Set if the next tile is a minecart door that will open
@checkMinecartDoor:
	; Check if the next tile is a minecart door
	ld a,c
	sub TILEINDEX_MINECART_DOOR_UP
	cp $04
	ret nc

	; Calculate the angle for the interaction to be created (?)
	add $0c
	add a
	ld b,a

	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERAC_DOOR_CONTROLLER

	ld l,Interaction.angle
	ld (hl),b

	; Set position (this interaction stuffs both X and Y in the yh variable)
	ld l,Interaction.yh
	ldh a,(<hFF8B)
	ld (hl),a

	scf
	ret

;;
; Creates an invisible item object which stays with the minecart to give it collision with enemies
minecartCreateCollisionItem:
	; Check if the "item" has been created already
	ld e,SpecialObject.var36
	ld a,(de)
	or a
	ret nz

	call getFreeItemSlot
	ret nz

	; Mark it as created
	ld e,SpecialObject.var36
	ld a,$01
	ld (de),a

	; Set Item.enabled
	ldi (hl),a

	; Set Item.id
	ld (hl),ITEM_MINECART_COLLISION
	ret
