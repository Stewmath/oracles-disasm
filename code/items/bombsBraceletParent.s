;;
; ITEM_BOMBCHUS ($0d)
parentItemCode_bombchu:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw parentItemGenericState1

@state0:
.ifdef ROM_AGES
	; Must be above water
	call isLinkUnderwater
	jp nz,clearParentItem
	; Can't be on raft
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RAFT
	jp z,clearParentItem
.endif

	; Can't be swimming
	ld a,(wLinkSwimmingState)
	or a
	jp nz,clearParentItem

	; Must have bombchus
	ld a,(wNumBombchus)
	or a
	jp z,clearParentItem

	call parentItemLoadAnimationAndIncState

	; Create a bombchu if there isn't one on the screen already
	ld e,$01
	jp itemCreateChildAndDeleteOnFailure

;;
; ITEM_BOMB ($03)
parentItemCode_bomb:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw parentItemGenericState1
	.dw parentItemCode_bracelet@state2
	.dw parentItemCode_bracelet@state3
	.dw parentItemCode_bracelet@state4

@state0:
.ifdef ROM_AGES
	call isLinkUnderwater
	jp nz,clearParentItem
	; If Link is riding something other than a raft, don't allow usage of bombs
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RAFT
	jr z,+
.endif
	ld a,(wLinkObjectIndex)
	rrca
	jp c,clearParentItem
+
	ld a,(wLinkSwimmingState)
	ld b,a
	ld a,(wLinkInAir)
	or b
	jp nz,clearParentItem

	; Try to pick up a bomb
	call tryPickupBombs
	jp nz,parentItemCode_bracelet@beginPickupAndSetAnimation

	; Try to create a bomb
	ld a,(wNumBombs)
	or a
	jp z,clearParentItem

	call parentItemLoadAnimationAndIncState
	ld e,$01
	ld a,BOMBERS_RING
	call cpActiveRing
	jr nz,+
	inc e
+
	call itemCreateChild
	jp c,clearParentItem

	call makeLinkPickupObjectH
	jp parentItemCode_bracelet@beginPickup

;;
; Makes Link pick up a bomb object if such an object exists and Link's touching it.
;
; @param[out]	zflag	Unset if a bomb was picked up
tryPickupBombs:
	; Return if Link's using something?
	ld a,(wLinkUsingItem1)
	or a
	jr nz,@setZFlag

	; Return with zflag set if there is no existing bomb object
	ld c,ITEM_BOMB
	call findItemWithID
	jr nz,@setZFlag

	call @pickupObjectIfTouchingLink
	ret nz

	; Try to find a second bomb object & pick that up
	ld c,ITEM_BOMB
	call findItemWithID_startingAfterH
	jr nz,@setZFlag


; @param	h	Object to check
; @param[out]	zflag	Set on failure (no collision with Link)
@pickupObjectIfTouchingLink:
	ld l,Item.var2f
	ld a,(hl)
	and $b0
	jr nz,@setZFlag
	call objectHCheckCollisionWithLink
	jr c,makeLinkPickupObjectH

@setZFlag:
	xor a
	ret

;;
; @param	h	Object to make Link pick up
makeLinkPickupObjectH:
	ld l,Item.enabled
	set 1,(hl)

	ld l,Item.substate
	xor a
	ldd (hl),a
	ld (hl),$02

	ld (w1Link.relatedObj2),a
	ld a,h
	ld (w1Link.relatedObj2+1),a
	or a
	ret


;;
; Bracelet's code is also heavily used by bombs.
;
; ITEM_BRACELET ($16)
parentItemCode_bracelet:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

; State 0: not grabbing anything
@state0:
	call checkLinkOnGround
	jp nz,clearParentItem

.ifdef ROM_SEASONS
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	jp z,clearParentItem
.endif

	ld a,(w1ReservedItemC.enabled)
	or a
	jp nz,clearParentItem

	call parentItemCheckButtonPressed
	jp z,@dropAndDeleteSelf

	ld a,(wLinkUsingItem1)
	or a
	jr nz,++

	; Check if there's anything to pick up
	call checkGrabbableObjects
	jr c,@beginPickupAndSetAnimation
	call tryPickupBombs
	jr nz,@beginPickupAndSetAnimation

	; Try to grab a solid tile
	call @checkWallInFrontOfLink
	jr nz,++
	ld a,$41
	ld (wLinkGrabState),a
	jp parentItemLoadAnimationAndIncState
++
	ld a,(w1Link.direction)
	or $80
	ld (wBraceletGrabbingNothing),a
	ret


; State 1: grabbing a wall
@state1:
	call @deleteAndRetIfSwimmingOrGrabState0
	ld a,(w1Link.knockbackCounter)
	or a
	jp nz,@dropAndDeleteSelf

	call parentItemCheckButtonPressed
	jp z,@dropAndDeleteSelf

	ld a,(wLinkInAir)
	or a
	jp nz,@dropAndDeleteSelf

	call @checkWallInFrontOfLink
	jp nz,@dropAndDeleteSelf

	; Check that the correct direction button is pressed
	ld a,(w1Link.direction)
	ld hl,@counterDirections
	rst_addAToHl
	call andHlWithGameKeysPressed
	ld a,LINK_ANIM_MODE_LIFT_3
	jp z,specialObjectSetAnimationWithLinkData

	; Update animation, wait for animParameter to set bit 7
	call specialObjectAnimate_optimized
	ld e,Item.animParameter
	ld a,(de)
	rlca
	ret nc

	; Try to lift the tile, return if not possible
	call @checkWallInFrontOfLink
	jp nz,@dropAndDeleteSelf
	lda BREAKABLETILESOURCE_BRACELET
	call tryToBreakTile
	ret nc

	; Create the sprite to replace the broken tile
	ld hl,w1ReservedItemC.enabled
	ld a,$03
	ldi (hl),a
	ld (hl),ITEM_BRACELET

	; Set subid to former tile ID
	inc l
	ldh a,(<hFF92)
	ldi (hl),a
	ld e,Item.var37
	ld (de),a

	; Set child item's var03 (the interaction ID for the effect on breakage)
	ldh a,(<hFF8E)
	ldi (hl),a

	lda Item.start
	ld (w1Link.relatedObj2),a
	ld a,h
	ld (w1Link.relatedObj2+1),a

@beginPickupAndSetAnimation:
	ld a,LINK_ANIM_MODE_LIFT_4
	call specialObjectSetAnimationWithLinkData

@beginPickup:
	call itemDisableLinkMovement
	call itemDisableLinkTurning
	ld a,$c2
	ld (wLinkGrabState),a
	xor a
	ld (wLinkGrabState2),a
	ld hl,w1Link.collisionType
	res 7,(hl)

	ld a,$02
	ld e,Item.state
	ld (de),a
	ld e,Item.var3f
	ld a,$0f
	ld (de),a

	ld a,SND_PICKUP
	jp playSound


; Opposite direction to press in order to use bracelet
@counterDirections:
	.db BTN_DOWN	; DIR_UP
	.db BTN_LEFT	; DIR_RIGHT
	.db BTN_UP	; DIR_DOWN
	.db BTN_RIGHT	; DIR_LEFT


; State 2: picking an item up.
; This is also state 2 for bombs.
@state2:
	call @deleteAndRetIfSwimmingOrGrabState0
	call specialObjectAnimate_optimized

	; Check if link's pulling a lever?
	ld a,(wLinkGrabState2)
	rlca
	jr nc,++

	; Go to state 5 for lever pulling?
	ld a,$83
	ld (wLinkGrabState),a
	ld e,Item.state
	ld a,$05
	ld (de),a
	ld a,LINK_ANIM_MODE_LIFT_2
	jp specialObjectSetAnimationWithLinkData
++
	ld h,d
	ld l,Item.animParameter
	bit 7,(hl)
	jr nz,++

	; The animParameter determines the object's offset relative to Link?
	ld a,(wLinkGrabState2)
	and $f0
	add (hl)
	ld (wLinkGrabState2),a
	ret
++
	; Pickup animation finished
	ld a,$83
	ld (wLinkGrabState),a
	ld l,Item.state
	inc (hl)
	ld l,Item.var3f
	ld (hl),$00

	; Re-enable link collisions & movement
	ld hl,w1Link.collisionType
	set 7,(hl)
	call itemEnableLinkTurning
	jp itemEnableLinkMovement


; State 3: holding the object
; This is also state 3 for bombs.
@state3:
	call @deleteAndRetIfSwimmingOrGrabState0
	ld a,(wLinkInAir)
	rlca
	ret c
	ld a,(wcc67)
	or a
	ret nz
	ld a,(w1Link.var2a)
	or a
	jr nz,++

	ld a,(wGameKeysJustPressed)
	and BTN_A|BTN_B
	ret z

	call updateLinkDirectionFromAngle
++
	; Item is being thrown

	; Unlink related object from Link, set its "substate" to $02 (meaning just thrown)
	ld hl,w1Link.relatedObj2
	xor a
	ld c,(hl)
	ldi (hl),a
	ld b,(hl)
	ldi (hl),a
	ld a,c
	add Object.substate
	ld l,a
	ld h,b
	ld (hl),$02

	; If it was a tile that was picked up, don't create any new objects
	ld e,Item.var37
	ld a,(de)
	or a
	jr nz,@@throwItem

	; If this is referencing an item object beyond index $d7, don't create object $dc
	ld a,c
	cpa Item.start
	jr nz,@@createPlaceholder
	ld a,b
	cp FIRST_DYNAMIC_ITEM_INDEX
	jr nc,@@throwItem

	; Create an invisible bracelet object to be used for collisions?
	; This is used when throwing dimitri, but not for picked-up tiles.
@@createPlaceholder:
	push de
	ld hl,w1ReservedItemC.enabled
	inc (hl)
	inc l
	ld a,ITEM_BRACELET
	ldi (hl),a

	; Copy over this parent item's former relatedObj2 & Y/X to the new "physical" item
	ld l,Item.relatedObj2
	ld a,c
	ldi (hl),a
	ld (hl),b
	add Item.yh
	ld e,a
	ld d,b
	call objectCopyPosition_rawAddress
	pop de

@@throwItem:
	ld a,(wLinkAngle)
	rlca
	jr c,+
	ld a,(w1Link.direction)
	swap a
	rrca
+
	ld l,Item.angle
	ld (hl),a
	ld l,Item.var38
	ld a,(wLinkGrabState2)
	ld (hl),a
	xor a
	ld (wLinkGrabState2),a
	ld (wLinkGrabState),a
	ld h,d
	ld l,Item.state
	inc (hl)
	ld l,Item.var3f
	ld (hl),$0f

	ld c,LINK_ANIM_MODE_THROW

.ifdef ROM_AGES ; TODO: why does only ages check this?
	; Load animation depending on whether Link's riding a minecart
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_MINECART
	jr nz,+
.endif

	ld a,(wLinkObjectIndex)
	rrca
	jr nc,+
	ld c,LINK_ANIM_MODE_25
+
	ld a,c
	call specialObjectSetAnimationWithLinkData
	call itemDisableLinkMovement
	call itemDisableLinkTurning
	ld a,SND_THROW
	jp playSound


; State 4: Link in throwing animation.
; This is also state 4 for bombs.
@state4:
	ld e,Item.animParameter
	ld a,(de)
	rlca
	jp nc,specialObjectAnimate_optimized
	jr @dropAndDeleteSelf

;;
@deleteAndRetIfSwimmingOrGrabState0:
	ld a,(wLinkSwimmingState)
	or a
	jr nz,+
	ld a,(wLinkGrabState)
	or a
	ret nz
+
	pop af

@dropAndDeleteSelf:
	call dropLinkHeldItem
	jp clearParentItem

;;
; @param[out]	bc	Y/X of tile Link is grabbing
; @param[out]	zflag	Set if Link is directly facing a wall
@checkWallInFrontOfLink:
	ld a,(w1Link.direction)
	ld b,a
	add a
	add b
	ld hl,@@data
	rst_addAToHl
	ld a,(w1Link.adjacentWallsBitset)
	and (hl)
	cp (hl)
	ret nz

	inc hl
	ld a,(w1Link.yh)
	add (hl)
	ld b,a
	inc hl
	ld a,(w1Link.xh)
	add (hl)
	ld c,a
	xor a
	ret

; b0: bits in w1Link.adjacentWallsBitset that should be set
; b1/b2: Y/X offsets from Link's position
@@data:
	.db $c0 $fb $00 ; DIR_UP
	.db $03 $00 $07 ; DIR_RIGHT
	.db $30 $07 $00 ; DIR_DOWN
	.db $0c $00 $f8 ; DIR_LEFT


; State 5: pulling a lever?
@state5:
	call parentItemCheckButtonPressed
	jp z,@dropAndDeleteSelf
	call @deleteAndRetIfSwimmingOrGrabState0
	ld a,(w1Link.knockbackCounter)
	or a
	jp nz,@dropAndDeleteSelf

	ld a,(w1Link.direction)
	ld hl,@counterDirections
	rst_addAToHl
	ld a,(wGameKeysPressed)
	and (hl)
	ld a,LINK_ANIM_MODE_LIFT_2
	jp z,specialObjectSetAnimationWithLinkData
	jp specialObjectAnimate_optimized
