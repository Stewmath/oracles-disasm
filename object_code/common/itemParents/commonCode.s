;;
; Unused function (in both ages and seasons)
func_5358:
	call checkNoOtherParentItemsInUse
--
	push hl
	call nz,clearParentItemH
	pop hl
	call checkNoOtherParentItemsInUse@nextItem
	jr nz,--
	ret

;;
; @param	d	The current parent item
; @param[out]	zflag	Set if there are no other parent item slots in use
checkNoOtherParentItemsInUse:
	ld hl,w1ParentItem2.enabled
--
	ld a,d
	cp h
	jr z,@nextItem
	ld a,(hl)
	or a
	ret nz
@nextItem:
	inc h
	ld a,h
	cp >w1WeaponItem
	jr c,--

	xor a
	ret

;;
; Items which immobilize Link in place tend to call this.
;
; * Disables movement, turning
; * Sets Item.state to $01
; * Loads an animation for Link by reading from linkItemAnimationTable
; * Sets Item.relatedObj2 to something
; * Sets Item.var3f to something
;
parentItemLoadAnimationAndIncState:
	call itemDisableLinkMovement
	call itemDisableLinkTurning

	ld e,Item.state
	ld a,$01
	ld (de),a

	ld e,Item.id
	ld a,(de)
	ld hl,linkItemAnimationTable
	rst_addDoubleIndex

	; Read Item.relatedObj2 from the table
	ld e,Item.relatedObj2
	lda Item.start
	ld (de),a
	inc e
	ld a,(hl)
	and $0f
	cp $01
	jr z,+
	or $d0
+
	ld (de),a

	; Set Item.var3f
	ldi a,(hl)
	ld b,a
	swap a
	and $07
	ld e,Item.var3f
	ld (de),a

	ld c,(hl)
	bit 7,b
	call nz,setLinkUsingItem1

.ifdef ROM_AGES
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RAFT
	ld a,c
	jr z,@setAnimation

	ld a,(w1Link.var2f)
	bit 7,a
	jr z,@notUnderwater

; Link is underwater

	ld a,c
	cp LINK_ANIM_MODE_22
	jr nz,@setAnimation

	ld a,LINK_ANIM_MODE_2d
	jr @setAnimation
.endif

@notUnderwater:
	; Check if Link is riding something
	ld a,(wLinkObjectIndex)
	rrca
	ld a,c
	jr nc,@setAnimation

	cp LINK_ANIM_MODE_20
	jr c,@setAnimation

	cp LINK_ANIM_MODE_24
	jr nc,@setAnimation
	add $04

@setAnimation:
	jp specialObjectSetAnimationWithLinkData

;;
; Same as below, except it's assumed that only one instance of the child can exist.
;
itemCreateChildIfDoesntExistAlready:
	ld e,$01

;;
; Creates the child if the given # of instances don't already exist; delete the parent on
; failure.
;
; @param	e	Max # of instances of the child
itemCreateChildAndDeleteOnFailure:
	call itemCreateChild
	ret nc
	jp clearParentItem

;;
; Creates an item object, based on the id of another item object?
;
; "Parent" items call this to create an actual physical object (since parent items don't
; get drawn).
;
; @param	d	Parent item
; @param	e	Max # instances of the object that can exist (0 means 256)
; @param[out]	h	The newly created child item
; @param[out]	cflag	Set on failure
itemCreateChild:
	ld c,$00
	ld h,d
	ld l,Item.id
	ld b,(hl)

;;
; @param	b	Item ID to create (see constants/common/items.s)
; @param	c	Subid for item
; @param	d	Points to w1ParentItem2, or some parent item?
; @param	e	Max # instances of the object that can exist (0 means 256)
; @param[out]	h	The newly created child item
; @param[out]	cflag	Set on failure
itemCreateChildWithID:
	ld h,d
	ld l,Item.relatedObj2+1
	ldd a,(hl)
	ld l,(hl)
	ld h,a
	cp $01
	scf
	ret z

	; If relatedObj2 is pointing to something other than Link, this will overwrite that.
	cp >w1Link
	call z,getFreeItemSlotWithObjectCap
	ret c

	; Set Item.enabled
	inc (hl)

	; Set Item.id and Item.subid
	inc l
	ld a,b
	ldi (hl),a
	ld a,c
	ldi (hl),a

	; Clear Item.var03, Item.state, Item.substate
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a

	; Copy link's direction and position variables to the item
	push de
	ld de,w1Link.direction
	ld l,Item.direction
	ld b,$08
	call copyMemoryReverse
	pop de

	; Set "parent" object?
	ld l,Item.relatedObj1
	lda Item.start
	ldi (hl),a
	ld (hl),d

	; And vice versa; set parent's "child" object?
	ld e,Item.relatedObj2
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	xor a
	ret

;;
; @param	bc	ID of item to create.
; @param	e	Maximum number of items with ID "bc" that can exist (0 means 256).
; @param[out]	hl	Free item slot
; @param[out]	cflag	Set on failure.
getFreeItemSlotWithObjectCap:
	ldhl FIRST_DYNAMIC_ITEM_INDEX, Item.id

	; Loop through all existing items, make sure that the maximum number of objects of
	; type "bc" allowed is not exceeded.
@itemLoop:
	; Compare Item.id and Item.subid with bc
	ld a,(hl)
	cp b
	jr nz,@nextItem
	inc l
	ldd a,(hl)
	cp c
	jr nz,@nextItem

	dec e
	jr z,@failure
@nextItem:
	inc h
	ld a,h
	cp LAST_DYNAMIC_ITEM_INDEX+1
	jr c,@itemLoop

	; End of loop; maximum number of objects not exceeded.
	call getFreeItemSlot
	ret z

@failure:
	scf
	ret

;;
; Unused in Ages.
;
; @param[out]	a	Number of available slots
; @param[out]	zflag
getNumFreeItemSlots:
	ldhl FIRST_DYNAMIC_ITEM_INDEX, Item.start
	ld b,$00
--
	ld a,(hl)
	or a
	jr nz,+
	inc b
+
	inc h
	ld a,h
	cp LAST_DYNAMIC_ITEM_INDEX+1
	jr c,--
	ld a,b
	or a
	ret

;;
; @param d Parent item to add to wLinkUsingItem1
setLinkUsingItem1:
	call itemIndexToBit
	swap a
	or (hl)
	ld hl,wLinkUsingItem1
	or (hl)
	ld (hl),a
	ret

;;
; @param d Parent item to clear from wLinkUsingItem1
clearLinkUsingItem1:
	call itemIndexToBit
	swap a
	or (hl)
	cpl
	ld hl,wLinkUsingItem1
	and (hl)
	ld (hl),a
	ret

;;
; @param d Parent item to add to wLinkImmobilized
itemDisableLinkMovement:
	call itemIndexToBit
	ld hl,wLinkImmobilized
	or (hl)
	ld (hl),a
	ret

;;
; @param d Parent item to clear from wLinkImmobilized
itemEnableLinkMovement:
	call itemIndexToBit
	ld hl,wLinkImmobilized
	cpl
	and (hl)
	ld (hl),a
	ret

;;
; @param d Parent item to add to wLinkTurningDisabled
itemDisableLinkTurning:
	call itemIndexToBit
	ld hl,wLinkTurningDisabled
	or (hl)
	ld (hl),a
	ret

;;
; @param d Parent item to clear from wLinkTurningDisabled
itemEnableLinkTurning:
	call itemIndexToBit
	ld hl,wLinkTurningDisabled
	cpl
	and (hl)
	ld (hl),a
	ret

;;
; Unused?
;
; @param d Parent item to add to wcc95
setCc95Bit:
	call itemIndexToBit
	ld hl,wcc95
	or (hl)
	ld (hl),a
	ret

;;
; Turn an item index (starting at $d2) into a bit.
;
; @param	d	Parent item object
; @param[out]	a	Bitmask for the item
itemIndexToBit:
	ld a,d
	sub >w1ParentItem2
	ld hl,bitTable
	add l
	ld l,a
	ld a,(hl)
	ret

;;
; Checks if the button corresponding to the parent item object is pressed (the bitmask is
; stored in var03).
;
parentItemCheckButtonPressed:
	ld h,d
	ld l,Item.var03

;;
; @param	hl
andHlWithGameKeysPressed:
	ld a,(wGameKeysPressed)
	and (hl)
	ret

;;
; @param	d	Parent item object
clearParentItemIfCantUseSword:
	; Check if in a spinner
	ld a,(wcc95)
	rlca
	jr c,@cantUseSword

	ld a,(wLinkClimbingVine)
	inc a
	jr z,@cantUseSword

	ld a,(wccd8)
	ld b,a
	ld a,(wSwordDisabledCounter)
	or b
	ret z

	ld e,Item.state
	ld a,(de)
	or a
	ld a,SND_ERROR
	call z,playSound

@cantUseSword:
	pop af
	xor a
	ld (wcc63),a
	jp clearParentItem

;;
; @param[out]	zflag	Set if link is on the ground (not on companion, not underwater,
;			not swimming, not in the air).
checkLinkOnGround:
	ld a,(wLinkObjectIndex)
	and $01
	ret nz

	ld hl,wLinkInAir
	ldi a,(hl)

	; Check wLinkSwimmingState
	or (hl)

.ifdef ROM_AGES
	ret nz
	jr isLinkUnderwater

.else; ROM_SEASONS
	ret
.endif


.ifdef ROM_AGES
;;
; TODO: rename this to the inverse of what it is now
; @param[out]	zflag	z if Link is not in an underwater map
isLinkUnderwater:
	ld a,(w1Link.var2f)
	bit 7,a
	ret
.endif

;;
; @param[out]	cflag	Set if link is currently in a hole.
isLinkInHole:
	ld a,(wActiveTileType)
	dec a
	cp $02
	ret

;;
; Updates the position of a grabbed object (overwrites its x/y/z variables).
;
updateGrabbedObjectPosition:
	ld a,(wLinkGrabState2)
	ld b,a
	rlca
	ret c

	; Set active object
	ld de,w1Link
	ld a,e
	ldh (<hActiveObjectType),a
	ld a,d
	ldh (<hActiveObject),a

	; If the lift animation is finished, use the animParameter to help determine which
	; frame data to use
	ld a,(wLinkGrabState)
	cp $83
	jr nz,+
	ld e,<w1Link.animParameter
	ld a,(de)
	and $0f
	add b
	ld b,a
+
	; Get position offsets in 'bc'
	ld e,<w1Link.direction
	ld a,(de)
	add b
	ld hl,@liftedObjectPositions
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a

	; Link.yh -> Object.yh
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ld e,<w1Link.yh
	ld a,(de)
	ldi (hl),a

	; Link.xh + 'c' -> Object.xh
	inc l
	ld e,<w1Link.xh
	ld a,(de)
	add c
	ldi (hl),a

	; Link.zh + 'b' -> Object.zh
	inc l
	ld e,<w1Link.zh
	ld a,(de)
	add b
	ldi (hl),a
	ret


; Each 2 bytes are Z/X offsets relative to Link where an object should be placed.
; Each row has 8 bytes, 2 for each of Link's facing directions.
;
@liftedObjectPositions:
	; Weight 0
	.db $f8 $00 $00 $07 $06 $00 $00 $f8 ; Frame 0 (lifting 1)
	.db $fa $00 $f8 $03 $04 $00 $f8 $fc ; Frame 1 (lifting 2)
	.db $f3 $00 $f2 $00 $f3 $00 $f2 $00 ; Frame 2 (walking 1 / standing still)
	.db $f3 $00 $f3 $00 $f3 $00 $f3 $00 ; Frame 3 (walking 2)

	; Weight 1
	.db $f4 $00 $00 $14 $0c $00 $00 $ec
	.db $f2 $00 $f2 $10 $f2 $00 $f2 $f0
	.db $ef $00 $ef $00 $ef $00 $ef $00
	.db $f0 $00 $f0 $00 $f0 $00 $f0 $00

	; Weight 2 (TODO: what is this, and why does it differ?)
.ifdef ROM_AGES
	.db $f8 $00 $00 $07 $06 $00 $00 $f8
	.db $fa $00 $f8 $03 $04 $00 $f8 $fc
	.db $f3 $00 $f2 $00 $f3 $00 $f2 $00
	.db $f3 $00 $f3 $00 $f3 $00 $f3 $00
.else; ROM_SEASONS
	.db $f4 $00 $00 $14 $0c $00 $00 $ec
	.db $f2 $00 $f2 $10 $f2 $00 $f2 $f0
	.db $ef $00 $ef $00 $ef $00 $ef $00
	.db $f0 $00 $f0 $00 $f0 $00 $f0 $00
.endif

	; Weight 3
	.db $f4 $00 $00 $14 $0c $00 $00 $ec
	.db $f2 $00 $f2 $10 $f2 $00 $f2 $f0
	.db $ef $00 $ef $00 $ef $00 $ef $00
	.db $f0 $00 $f0 $00 $f0 $00 $f0 $00

	; Weight 4
	.db $f6 $00 $00 $0a $0a $00 $00 $f6
	.db $f4 $00 $f4 $0e $f4 $00 $f4 $f2
	.db $f2 $00 $f1 $00 $f2 $00 $f1 $00
	.db $f2 $00 $f2 $00 $f2 $00 $f2 $00
