;;
updateItems:
	ld b,$00

	ld a,(wScrollMode)
	cp $08
	jr z,@dontUpdateItems

	ld a,(wDisabledObjects)
	and $90
	jr nz,@dontUpdateItems

	ld a,(wPaletteThread_mode)
	or a
	jr nz,@dontUpdateItems

	ld a,(wTextIsActive)
	or a
	jr z,++

	; Set b to $01, indicating items shouldn't be updated after initialization
@dontUpdateItems:
	inc b
++
	ld hl,wcc8b
	ld a,(hl)
	and $fe
	or b
	ld (hl),a

	xor a
	ld (wScentSeedActive),a

	ld a,Item.start
	ldh (<hActiveObjectType),a
	ld d,FIRST_ITEM_INDEX
	ld a,d

@itemLoop:
	ldh (<hActiveObject),a
	ld e,Item.start
	ld a,(de)
	or a
	jr z,@nextItem

	; Always update items when uninitialized
	ld e,Item.state
	ld a,(de)
	or a
	jr z,+

	; If already initialized, don't update items if this variable is set
	ld a,(wcc8b)
	or a
+
	call z,@updateItem
@nextItem:
	inc d
	ld a,d
	cp LAST_ITEM_INDEX+1
	jr c,@itemLoop
	ret

;;
; @param d Item index
@updateItem:
	ld e,Item.id
	ld a,(de)
	rst_jumpTable
.ifdef ROM_AGES
	.dw itemCode00 ; 0x00
	.dw itemDelete ; 0x01
	.dw itemCode02 ; 0x02
	.dw itemCode03 ; 0x03
	.dw itemCode04 ; 0x04
	.dw itemCode05 ; 0x05
	.dw itemCode06 ; 0x06
	.dw itemDelete ; 0x07
	.dw itemDelete ; 0x08
	.dw itemCode09 ; 0x09
	.dw itemCode0a ; 0x0a
	.dw itemCode0b ; 0x0b
	.dw itemCode0c ; 0x0c
	.dw itemCode0d ; 0x0d
	.dw itemDelete ; 0x0e
	.dw itemCode0f ; 0x0f
	.dw itemDelete ; 0x10
	.dw itemDelete ; 0x11
	.dw itemDelete ; 0x12
	.dw itemCode13 ; 0x13
	.dw itemDelete ; 0x14
	.dw itemCode15 ; 0x15
	.dw itemCode16 ; 0x16
	.dw itemDelete ; 0x17
	.dw itemCode18 ; 0x18
	.dw itemDelete ; 0x19
	.dw itemCode1a ; 0x1a
	.dw itemDelete ; 0x1b
	.dw itemDelete ; 0x1c
	.dw itemCode1d ; 0x1d
	.dw itemCode1e ; 0x1e
	.dw itemDelete ; 0x1f
	.dw itemCode20 ; 0x20
	.dw itemCode21 ; 0x21
	.dw itemCode22 ; 0x22
	.dw itemCode23 ; 0x23
	.dw itemCode24 ; 0x24
	.dw itemDelete ; 0x25
	.dw itemDelete ; 0x26
	.dw itemCode27 ; 0x27
	.dw itemCode28 ; 0x28
	.dw itemCode29 ; 0x29
	.dw itemCode2a ; 0x2a
	.dw itemCode2b ; 0x2b
.else
	.dw itemCode00 ; 0x00
	.dw itemDelete ; 0x01
	.dw itemCode02 ; 0x02
	.dw itemCode03 ; 0x03
	.dw itemDelete ; 0x04
	.dw itemCode05 ; 0x05
	.dw itemCode06 ; 0x06
	.dw itemCode07 ; 0x07
	.dw itemCode08 ; 0x08
	.dw itemDelete ; 0x09
	.dw itemDelete ; 0x0a
	.dw itemDelete ; 0x0b
	.dw itemCode0c ; 0x0c
	.dw itemCode0d ; 0x0d
	.dw itemDelete ; 0x0e
	.dw itemDelete ; 0x0f
	.dw itemDelete ; 0x10
	.dw itemDelete ; 0x11
	.dw itemDelete ; 0x12
	.dw itemCode13 ; 0x13
	.dw itemDelete ; 0x14
	.dw itemCode15 ; 0x15
	.dw itemCode16 ; 0x16
	.dw itemDelete ; 0x17
	.dw itemDelete ; 0x18
	.dw itemDelete ; 0x19
	.dw itemCode1a ; 0x1a
	.dw itemDelete ; 0x1b
	.dw itemDelete ; 0x1c
	.dw itemCode1d ; 0x1d
	.dw itemCode1e ; 0x1e
	.dw itemDelete ; 0x1f
	.dw itemCode20 ; 0x20
	.dw itemCode21 ; 0x21
	.dw itemCode22 ; 0x22
	.dw itemCode23 ; 0x23
	.dw itemCode24 ; 0x24
	.dw itemDelete ; 0x25
	.dw itemDelete ; 0x26
	.dw itemCode27 ; 0x27
	.dw itemCode28 ; 0x28
	.dw itemCode29 ; 0x29
	.dw itemCode2a ; 0x2a
	.dw itemCode2b ; 0x2b
.endif

;;
; The main difference between this and the above "updateItems" is that this is called
; after all of the other objects have been updated. This also doesn't have any conditions
; before it starts calling the update code.
;
updateItemsPost:
	lda Item.start
	ldh (<hActiveObjectType),a
	ld d,FIRST_ITEM_INDEX
	ld a,d
@itemLoop:
	ldh (<hActiveObject),a
	ld e,Item.enabled
	ld a,(de)
	or a
	call nz,updateItemPost
	inc d
	ld a,d
	cp $e0
	jr c,@itemLoop

itemCodeNilPost:
	ret

;;
updateItemPost:
	ld e,$01
	ld a,(de)
	rst_jumpTable

	.dw itemCode00Post	; 0x00
	.dw itemCodeNilPost	; 0x01
	.dw itemCode02Post	; 0x02
	.dw itemCodeNilPost	; 0x03
	.dw itemCode04Post	; 0x04
	.dw itemCode05Post	; 0x05
	.dw itemCodeNilPost	; 0x06
	.dw itemCode07Post	; 0x07
	.dw itemCode08Post	; 0x08
	.dw itemCodeNilPost	; 0x09
.ifdef ROM_AGES
	.dw itemCode0aPost	; 0x0a
	.dw itemCode0bPost	; 0x0b
	.dw itemCode0cPost	; 0x0c
	.dw itemCodeNilPost	; 0x0d
	.dw itemCodeNilPost	; 0x0e
	.dw itemCode0fPost	; 0x0f
.else
	.dw itemDelete		; 0x0a
	.dw itemDelete		; 0x0b
	.dw itemCode0cPost	; 0x0c
	.dw itemCodeNilPost	; 0x0d
	.dw itemCodeNilPost	; 0x0e
	.dw itemDelete		; 0x0f
.endif
	.dw itemCodeNilPost	; 0x10
	.dw itemCodeNilPost	; 0x11
	.dw itemCodeNilPost	; 0x12
	.dw itemCode13Post	; 0x13
	.dw itemCodeNilPost	; 0x14
	.dw itemCodeNilPost	; 0x15
	.dw itemCodeNilPost	; 0x16
	.dw itemCodeNilPost	; 0x17
	.dw itemCodeNilPost	; 0x18
	.dw itemCodeNilPost	; 0x19
	.dw itemCodeNilPost	; 0x1a
	.dw itemCodeNilPost	; 0x1b
	.dw itemCodeNilPost	; 0x1c
	.dw itemCode1dPost	; 0x1d
	.dw itemCode1ePost	; 0x1e
	.dw itemCodeNilPost	; 0x1f
	.dw itemCodeNilPost	; 0x20
	.dw itemCodeNilPost	; 0x21
	.dw itemCodeNilPost	; 0x22
	.dw itemCodeNilPost	; 0x23
	.dw itemCodeNilPost	; 0x24
	.dw itemCodeNilPost	; 0x25
	.dw itemCodeNilPost	; 0x26
	.dw itemCodeNilPost	; 0x27
	.dw itemCodeNilPost	; 0x28
	.dw itemCodeNilPost	; 0x29
	.dw itemCodeNilPost	; 0x2a
	.dw itemCodeNilPost	; 0x2b

;;
loadAttributesAndGraphicsAndIncState:
	call itemIncState
	ld l,Item.enabled
	ld (hl),$03

;;
; Loads values for Item.collisionRadiusY/X, Item.damage, Item.health, and loads graphics.
itemLoadAttributesAndGraphics:
	ld e,Item.id
	ld a,(de)
	add a
	ld hl,itemAttributes
	rst_addDoubleIndex

	; b0: Item.collisionType
	ld e,Item.collisionType
	ldi a,(hl)
	ld (de),a

	; b1: Item.collisionRadiusY/X
	ld e,Item.collisionRadiusY
	ld a,(hl)
	swap a
	and $0f
	ld (de),a
	inc e
	ldi a,(hl)
	and $0f
	ld (de),a

	; b2: Item.damage
	inc e
	ldi a,(hl)
	ld (de),a
	ld c,a

	; b3: Item.health
	inc e
	ldi a,(hl)
	ld (de),a

	; Write Item.damage to Item.var3a as well?
	ld e,Item.var3a
	ld a,c
	ld (de),a

	call itemSetVar3cToFF
	jpab bank3f.itemLoadGraphics

;;
itemSetVar3cToFF:
	ld e,Item.var3c
	ld a,$ff
	ld (de),a
	ret

;;
; Reduces the item's health according to the Item.damageToApply variable.
; Also does something with Item.var2a.
;
; @param[out]	a	[Item.var2a]
; @param[out]	hl	Item.var2a
; @param[out]	zflag	Set if Item.var2a is zero.
; @param[out]	cflag	Set if health went below 0
itemUpdateDamageToApply:
	ld h,d
	ld l,Item.damageToApply
	ld a,(hl)
	ld (hl),$00

	ld l,Item.health
	add (hl)
	ld (hl),a
	rlca
	ld l,Item.var2a
	ld a,(hl)
	dec a
	inc a
	ret

;;
itemAnimate:
	ld h,d
	ld l,Item.animCounter
	dec (hl)
	ret nz

	ld l,Item.animPointer
	jr itemNextAnimationFrame

;;
; @param a Animation index
itemSetAnimation:
	add a
	ld c,a
	ld b,$00
	ld e,Item.id
	ld a,(de)
	ld hl,itemAnimationTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc

;;
itemNextAnimationFrame:
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)
	cp $ff
	jr nz,++

	; If $ff, animation loops
	ld b,a
	ld c,(hl)
	add hl,bc
	ldi a,(hl)
++
	ld e,Item.animCounter
	ld (de),a

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)
	ld c,a
	ld b,$00

	; Item.animParameter
	inc e
	ldi a,(hl)
	ld (de),a

	; Item.animPointer
	inc e
	; Save the current position in the animation
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Item.id
	ld a,(de)
	ld hl,itemOamDataTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc

	; Set the address of the oam data
	ld e,Item.oamDataAddress
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	and $3f
	ld (de),a
	ret

;;
; Transfer an item's knockbackCounter and knockbackAngle to Link.
itemTransferKnockbackToLink:
	ld h,d
	ld l,Item.knockbackCounter
	ld a,(hl)
	or a
	ret z

	ld (hl),$00

	; b = [Item.knockbackAngle]
	dec l
	ld b,(hl)

	ld hl,w1Link.knockbackCounter
	cp (hl)
	jr c,+
	ld (hl),a
+
	; Set Item.knockbackAngle
	dec l
	ld (hl),b
	ret

;;
; Applies speed based on Item.direction?
;
; @param	hl	Table of offsets for Y/X/Z positions based on Item.direction
applyOffsetTableHL:
	ld e,Item.direction
	ld a,(de)

	; a *= 3
	ld e,a
	add a
	add e

	rst_addAToHl

	; b0: Y offset
	ld e,Item.yh
	ld a,(de)
	add (hl)
	ld (de),a

	; b1: X offset
	inc hl
	ld e,Item.xh
	ld a,(de)
	add (hl)
	ld (de),a

	; b2: Z offset
	inc hl
	ld e,Item.zh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

;;
; In sidescrolling areas, the Z position and Y position can't both exist.
; This function adds the Z position to the Y position, and zeroes the Z position.
;
; @param[out]	zflag	Set if not in a sidescrolling area
itemMergeZPositionIfSidescrollingArea:
	ld h,d
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	ret z

	ld e,Item.yh
	ld l,Item.zh
	ld a,(de)
	add (hl)
	ld (de),a
	xor a
	ldd (hl),a
	ld (hl),a
	or d
	ret

;;
; Updates Z position if in midair (not if on the ground). If the item falls into a hazard
; (water/lava/hole), this creates an animation, deletes the item, and returns from the
; caller.
;
; @param	c	Gravity
itemUpdateSpeedZAndCheckHazards:
	ld e,Item.zh
	ld a,e
	ldh (<hFF8B),a
	ld a,(de)
	rlca
	jr nc,++

	; If in midair, update z speed
	rrca
	ldh (<hFF8B),a
	call objectUpdateSpeedZ_paramC
	jr nz,+++

	; Item has hit the ground

	ldh (<hFF8B),a
++
	call objectReplaceWithAnimationIfOnHazard
	jr nc,+++

	; Return from caller if this was replaced with an animation
	pop hl
	ld a,$ff
	ret

	; Above ground?
+++
	ldh a,(<hFF8B)
	rlca
	or a
	ret

;;
; This function moves a bomb toward a point stored in the item's var31/var32 variables.
; Does nothing when var31/var32 are set to zero.
;
; Not used by bombchus, but IS used by scent seeds...
;
; @param[out]	cflag	Set when the bomb has reached the point (if such a point exists)
bombPullTowardPoint:
	ld h,d

	; Return if object is above ground.
	ld l,Item.zh
	and $80
	jr nz,@end

	; The following code pulls a bomb towards a specific point.
	; The point is stored in its var31/var32 variables.

	; Load bc with Item.var31/32, and zero out those values
	ld l,Item.var31
	ld b,(hl)
	ldi (hl),a
	ld c,(hl)
	ldi (hl),a
	; Return if they were already zero
	or b
	ret z

	; Return if the object contains the point
	push bc
	call objectCheckContainsPoint
	pop bc
	ret c

	; If it doesn't contain the point (not there yet), move toward it
	call objectGetRelativeAngle
	ld c,a
	ld b,$0a
	ld e,Item.angle
	call objectApplyGivenSpeed
@end:
	xor a
	ret

;;
; Deals with checking whether a thrown item has landed on a hole/water/lava, updating its
; vertical speed, etc.
;
; Sets Item.var3b depending on what it landed on (see structs.s for more info).
;
; This does not check for collision with walls; it only updates "vertical" motion and
; checks for collision on that front.
;
; @param	c	Gravity
; @param[out]	cflag	Set if the item has landed.
itemUpdateThrowingVertically:
	; Jump if in a sidescrolling area
	call itemMergeZPositionIfSidescrollingArea
	jr nz,@sidescrolling

	; Update vertical speed, return if the object hasn't landed yet
	call objectUpdateSpeedZ_paramC
	jr nz,@unsetCollision

	; Object has landed / is bouncing; need to check for collision with water, holes,
	; etc.

	call @checkHoleOrWater
	bit 4,(hl)
	set 4,(hl)
	scf
	ret

;;
; @param[out]	zflag	Unset.
; @param[out]	cflag	Unset.
@unsetCollision:
	ld l,Item.var3b
	res 4,(hl)
	or d
	ret

;;
; @param[out]	zflag	Former value of bit 4 of Item.var3b.
; @param[out]	cflag	Set.
@setCollision:
	ld h,d
	ld l,Item.var3b
	bit 4,(hl)
	set 4,(hl)
	scf
	ret

;;
; Throwing item update code for sidescrolling areas
;
@sidescrolling:
	push bc
	call @checkHoleOrWater

	; Jump if object is not moving up.
	ld l,Item.speedZ+1
	bit 7,(hl)
	jr z,@notMovingUp

	; Check for collision with the ceiling
	call objectCheckTileCollision_allowHoles
	ld h,d
	pop bc
	jr nc,@noCeilingCollision

	; Object collided with ceiling, so Y position isn't updated (though gravity is)
	ld b,$03
	jr @updateGravity

@notMovingUp:
	; Check for a collision 5 pixels below center
	ld l,Item.yh
	ldi a,(hl)
	add $05
	ld b,a
	inc l
	ld c,(hl)
	call checkTileCollisionAt_allowHoles
	ld h,d
	pop bc
	jr c,@setCollision

@noCeilingCollision:
	; Set maximum gravity = $0300 normally, $0100 when in water
	ld l,Item.var3b
	bit 0,(hl)
	ld b,$03
	jr z,+

	ld b,$01
	bit 7,(hl)
	jr nz,@unsetCollision
+
	; Update Y position based on speedZ (since this is a sidescrolling area)
	ld e,Item.speedZ
	ld l,Item.y
	ld a,(de)
	add (hl)
	ldi (hl),a
	inc e
	ld a,(de)
	adc (hl)
	ldi (hl),a

@updateGravity:
	; Update speedZ based on gravity
	ld l,Item.speedZ
	ld a,(hl)
	add c
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a

	; Return if speedZ is beneath the maximum speed ('b').
	bit 7,a
	jr nz,@unsetCollision
	cp b
	jr c,@unsetCollision

	; Set speedZ to the maximum speed 'b'.
	ld (hl),b
	dec l
	ld (hl),$00
	jr @unsetCollision

;;
; Updates Item.var3b depending whether it's on a hole, lava, water tile.
@checkHoleOrWater:
	call itemMergeZPositionIfSidescrollingArea
	jr nz,@@sidescrolling

	; Note: a=0 here

	; If top-down view and object is in midair, skip the "objectCheckIsOverHazard" check
	ld l,Item.zh
	bit 7,(hl)
	jr nz,++

@@sidescrolling:
	call objectCheckIsOverHazard
	ld h,d
++
	; Here, 'a' holds the value for what kind of landing collision has occurred.

	; Update Item.var3b: flip bit 7, clear bit 6, update bits 0-2
	ld b,a
	ld l,Item.var3b
	ld a,(hl)
	ld c,a
	and $b8
	xor $80
	or b
	ld (hl),a

	; Set bit 6 if the item's bit 0 has changed?
	; (in other words, "landed on water" state has changed)
	ld a,b
	xor c
	rrca
	jr nc,+
	set 6,(hl)
+
	ret

;;
; Calls itemUpdateThrowingVertically and creates an appropriate animation if this item
; has fallen into something (water, lava, or a hole). Caller still needs to delete the
; object.
;
; @param	c	Gravity
; @param[out]	cflag	Set if the object has landed in water, lava, or a hole.
; @param[out]	zflag	Set if the object is in midair.
itemUpdateThrowingVerticallyAndCheckHazards:
	call itemUpdateThrowingVertically
	jr c,@landed

	; Object isn't on the ground, so only check for collisions in sidescrolling areas.

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr z,+

	ld b,INTERACID_LAVASPLASH
	bit 2,(hl)
	jr nz,@createSplash

	ld b,INTERACID_SPLASH
	bit 6,(hl)
	call nz,@createSplash
+
	xor a
	ret

@landed:
	; If the item has landed in a sidescrolling area, there's no need to check what it
	; landed on (since if it had touched water, it would have still been considered
	; to be in midair).
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr nz,@noCollisions

	ld h,d
	ld l,Item.var3b
	ld b,INTERACID_SPLASH
	bit 0,(hl)
	jr nz,@createSplash

	ld b,$0f
	bit 1,(hl)
	jr nz,@createHoleAnim

	ld b,INTERACID_LAVASPLASH
	bit 2,(hl)
	jr nz,@createSplash

@noCollisions:
	xor a
	bit 4,(hl)
	ret

@createSplash:
	call objectCreateInteractionWithSubid00
	scf
	ret

@createHoleAnim:
	call objectCreateFallingDownHoleInteraction
	scf
	ret

;;
; Creates an interaction to do the clinking animation.
objectCreateClinkInteraction:
	ld b,INTERACID_CLINK
	jp objectCreateInteractionWithSubid00

;;
cpRelatedObject1ID:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Item.id
	ld a,(de)
	cp (hl)
	ret

;;
; Same as below, but checks the tile at position bc instead of the tile at the object's
; position.
;
; @param	bc	Position of tile to check
itemCheckCanPassSolidTileAt:
	call getTileAtPosition
	jr ++

;;
; This function checks for exceptions to solid tiles which items (switch hook, seeds) can
; pass through. It also keeps track of an "elevation level" in var3e which keeps track of
; how many cliff tiles the item has passed through.
;
; Also updates var3c, var3d (tile position and index).
;
; @param[out]	zflag	Set if there is no collision.
itemCheckCanPassSolidTile:
	call objectGetTileAtPosition
++
	; Check if position / tile has changed? (var3c = position, var3d = tile index)
	ld e,a
	ld a,l
	ld h,d
	ld l,Item.var3c
	cp (hl)
	ldi (hl),a
	jr nz,@tileChanged

	; Return if the tile index has not changed
	ld a,e
	cp (hl)
	ret z

@tileChanged:
	ld (hl),e
	ld l,Item.angle
	ld b,(hl)
	call checkTileIsPassableFromDirection
	jr nc,@collision
	ret z

	; If there was no collision, but the zero flag was not set, the item must move up
	; or down an elevation level (depending on the value of a from the function call).
	ld h,d
	ld l,Item.var3e
	add (hl)
	ld (hl),a

	; Check if the item has passed to a "negative" elevation, if so, trigger
	; a collision
	and $80
	ret z

@collision:
	ld h,d
	ld l,Item.var3c
	ld a,$ff
	ldi (hl),a
	ld (hl),a
	or d
	ret

;;
; Checks if an item can pass through the given tile with a given angle.
;
; @param	b	angle
; @param	e	Tile index
; @param[out]	a	The elevation level change that will occur if the item can pass
;			this tile
; @param[out]	cflag	Set if the tile is passable
; @param[out]	zflag	Set if there will be no elevation change (ignore the value of a)
checkTileIsPassableFromDirection:
	; Check if the tile can be passed by items
	ld hl,itemPassableTilesTable
	call findByteInCollisionTable_paramE
	jr c,@canPassWithoutElevationChange

	; Retrieve a value based on the given angle to see which directions
	; should be checked for passability
	ld a,b
	ld hl,angleTable
	rst_addAToHl
	ld a,(hl)
	push af

	ld a,(wActiveCollisions)
	ld hl,itemPassableCliffTilesTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	; If the value retrieved from angleTable was odd, allow the item to pass
	; through 2 directions
	pop af
	srl a
	jr nc,@checkOneDirectionOnly

	rst_addAToHl
	ld a,(hl)
	push hl
	rst_addAToHl
	call lookupKey
	pop hl
	jr c,@canPassWithElevationChange

	inc hl
	jr ++

@checkOneDirectionOnly:
	rst_addAToHl
++
	ld a,(hl)
	rst_addAToHl
	call lookupKey
	ret nc

@canPassWithElevationChange:
	or a
	scf
	ret

@canPassWithoutElevationChange:
	xor a
	scf
	ret

;;
; Checks if the item is on a conveyor belt, updates its position if so.
;
; Used by bombs, bombchus. Might not work well with other items due to assumptions about
; their size.
itemUpdateConveyorBelt:
	; Return if in midair
	ld e,Item.zh
	ld a,(de)
	rlca
	ret c

	; Check if on a conveyor belt; get in 'a' the angle to move in if so
	ld bc,$0500
	call objectGetRelativeTile
	ld hl,itemConveyorTilesTable
	call lookupCollisionTable
	ret nc

	push af
	rrca
	rrca
	ld hl,bombEdgeOffsets
	rst_addAToHl

	; Set 'bc' to the item's position + offset (where to check for a wall)
	ldi a,(hl)
	ld c,(hl)
	ld h,d
	ld l,Item.yh
	add (hl)
	ld b,a
	ld l,Item.xh
	ld a,(hl)
	add c
	ld c,a

	call getTileCollisionsAtPosition
	cp SPECIALCOLLISION_SCREEN_BOUNDARY
	jr z,@ret

	call checkGivenCollision_allowHoles
	jr c,@ret

	pop af
	ld c,a
	ld b,SPEED_80
	ld e,Item.angle
	jp objectApplyGivenSpeed

@ret:
	pop af
	ret


; These are offsets from a bomb or bombchu's center to check for wall collisions at.
; This might apply to all throwable items?
bombEdgeOffsets:
	.db $fd $00 ; DIR_UP
	.db $00 $03 ; DIR_RIGHT
	.db $07 $00 ; DIR_DOWN
	.db $00 $fd ; DIR_LEFT
