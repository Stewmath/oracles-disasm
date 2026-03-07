;;
; This is the object representation of a tile while being held / thrown?
;
; If it's not a tile (ie. it's dimitri), this is just an invisible item with collisions?
;
; ITEM_BRACELET
itemCode16:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call itemLoadAttributesAndGraphics
	ld h,d
	ld l,Item.enabled
	set 1,(hl)

	; Check subid, which is the index of tile being lifted, or 0 if not lifting a tile
	ld l,Item.subid
	ld a,(hl)
	or a
	jr z,@notTile

	ld l,Item.state
	ld (hl),$02
	call itemMimicBgTile
	jp objectSetVisiblec0


; State 1/2: being held
@state1:
@state2:
	ld h,d
	ld l,Item.substate
	ld a,(hl)
	or a
	ret z

	; Item thrown; enable collisions
	ld l,Item.collisionRadiusX
	ld a,$06
	ldd (hl),a
	ldd (hl),a

	; bit 7 of Item.collisionType
	dec l
	set 7,(hl)

	jr @throwItem


; When a bracelet object is created that doesn't come from a tile on the ground, it is
; created at the time it is thrown, instead of the time it is picked up. Also, it's
; invisible, since its only purpose is to provide collisions?
@notTile:
	call braceletCheckDeleteSelfWhileThrowing

	; Check if relatedObj2 is an item or not?
	ld a,h
	cp >w1Companion
	jr z,@@copyCollisions
	ld a,l
	cp Item.start+$40
	jr c,@throwItem

; This will copy collision attributes of non-item objects. This should allow "non-allied"
; objects to damage enemies?
@@copyCollisions:
	; Copy angle (this -> relatedObj2)
	ld a,Object.angle
	call objectGetRelatedObject2Var
	ld e,Item.angle
	ld a,(de)
	ld (hl),a

	; Copy collisionRadius (relatedObj2 -> this)
	ld a,l
	add Object.collisionRadiusY-Object.angle
	ld l,a
	ld e,Item.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; Enable collisions (on this)
	ld h,d
	ld l,Item.collisionType
	set 7,(hl)

@throwItem:
	call itemBeginThrow
	ld h,d
	ld l,Item.state
	ld (hl),$03
	inc l
	ld (hl),$00


; State 3: being thrown
@state3:
	call braceletCheckDeleteSelfWhileThrowing
	call itemUpdateThrowingLaterally
.ifdef ROM_AGES
	jr z,@@destroyWithAnimation
.else
	jr z,@@preDestroyWithAnimation
.endif

	ld e,Item.var39
	ld a,(de)
	ld c,a
	call itemUpdateThrowingVertically
	jr nc,@@noCollision

	; If it's breakable, destroy it; if not, let it bounce
	call braceletCheckBreakable

.ifdef ROM_AGES
	jr nz,@@destroyWithAnimation
.else
	jr nz,@@preDestroyWithAnimation
	jr nc,+
	call objectReplaceWithAnimationIfOnHazard
	ret c
+
.endif

	call itemBounce
	jr c,@@release

@@noCollision:
	; If this is not a breakable tile, copy this object's position to relatedObj2.
	ld e,Item.subid
	ld a,(de)
	or a
	ret nz
	ld a,Object.yh
	call objectGetRelatedObject2Var
	jp objectCopyPosition

@@release:
.ifdef ROM_SEASONS
	ld e,$02
	ld a,(de)
	cp $d7
	jr z,@@createPuff
.endif

	ld a,Object.substate
	call objectGetRelatedObject2Var
	ld (hl),$03
	jp itemDelete

.ifdef ROM_SEASONS
@@preDestroyWithAnimation:
	ld e,Item.subid
	ld a,(de)
	cp $d7
	jr nz,@@destroyWithAnimation
@@createPuff:
	call objectCreatePuff
	jp itemDelete
.endif

@@destroyWithAnimation:
	call objectReplaceWithAnimationIfOnHazard
	ret c
	callab bank6.itemMakeInteractionForBreakableTile
	jp itemDelete

;;
; @param[out] zflag Set if Item.subid is zero
; @param[out] cflag Inverse of zflag?
braceletCheckBreakable:
	ld e,Item.subid
	ld a,(de)
	or a
	ret z
.ifdef ROM_SEASONS
	cp $d7
.endif
	scf
	ret

;;
; Called each frame an item's being thrown. Returns from caller if it decides to delete
; itself.
;
; @param[out]	hl	relatedObj2.substate or this.substate
braceletCheckDeleteSelfWhileThrowing:
	ld e,Item.subid
	ld a,(de)
	or a
	jr nz,@throwingTile

	lda Item.enabled
	call objectGetRelatedObject2Var
	bit 0,(hl)
	jr z,@deleteSelfAndRetFromCaller

	; Delete self unless related object is on state 2, substate 0/1/2 (being held by
	; Link or just released)
	ld a,l
	add Object.state-Object.enabled
	ld l,a
	ldi a,(hl)
	cp $02
	jr nz,@deleteSelfAndRetFromCaller
	ld a,(hl)
	cp $03
	ret c

@deleteSelfAndRetFromCaller:
	pop af
	jp itemDelete

@throwingTile:
	call objectCheckWithinRoomBoundary
	jr nc,@deleteSelfAndRetFromCaller
	ld h,d
	ld l,Item.substate
	ret
