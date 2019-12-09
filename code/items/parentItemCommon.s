;;
; Unused function (in both ages and seasons)
; @addr{5358}
_func_5358:
	call _checkNoOtherParentItemsInUse		; $5358
--
	push hl			; $535b
	call nz,_clearParentItemH		; $535c
	pop hl			; $535f
	call _checkNoOtherParentItemsInUse@nextItem		; $5360
	jr nz,--		; $5363
	ret			; $5365

;;
; @param	d	The current parent item
; @param[out]	zflag	Set if there are no other parent item slots in use
; @addr{5366}
_checkNoOtherParentItemsInUse:
	ld hl,w1ParentItem2.enabled		; $5366
--
	ld a,d			; $5369
	cp h			; $536a
	jr z,@nextItem		; $536b
	ld a,(hl)		; $536d
	or a			; $536e
	ret nz			; $536f
@nextItem:
	inc h			; $5370
	ld a,h			; $5371
	cp >w1WeaponItem			; $5372
	jr c,--		; $5374

	xor a			; $5376
	ret			; $5377

;;
; Items which immobilize Link in place tend to call this.
;
; * Disables movement, turning
; * Sets Item.state to $01
; * Loads an animation for Link by reading from _linkItemAnimationTable
; * Sets Item.relatedObj2 to something
; * Sets Item.var3f to something
;
; @addr{5378}
_parentItemLoadAnimationAndIncState:
	call _itemDisableLinkMovement		; $5378
	call _itemDisableLinkTurning		; $537b

	ld e,Item.state		; $537e
	ld a,$01		; $5380
	ld (de),a		; $5382

	ld e,Item.id		; $5383
	ld a,(de)		; $5385
	ld hl,_linkItemAnimationTable		; $5386
	rst_addDoubleIndex			; $5389

	; Read Item.relatedObj2 from the table
	ld e,Item.relatedObj2		; $538a
	lda Item.start			; $538c
	ld (de),a		; $538d
	inc e			; $538e
	ld a,(hl)		; $538f
	and $0f			; $5390
	cp $01			; $5392
	jr z,+			; $5394
	or $d0			; $5396
+
	ld (de),a		; $5398

	; Set Item.var3f
	ldi a,(hl)		; $5399
	ld b,a			; $539a
	swap a			; $539b
	and $07			; $539d
	ld e,Item.var3f		; $539f
	ld (de),a		; $53a1

	ld c,(hl)		; $53a2
	bit 7,b			; $53a3
	call nz,_setLinkUsingItem1		; $53a5

.ifdef ROM_AGES
	ld a,(w1Companion.id)		; $53a8
	cp SPECIALOBJECTID_RAFT			; $53ab
	ld a,c			; $53ad
	jr z,@setAnimation	; $53ae

	ld a,(w1Link.var2f)		; $53b0
	bit 7,a			; $53b3
	jr z,@notUnderwater			; $53b5

; Link is underwater

	ld a,c			; $53b7
	cp LINK_ANIM_MODE_22			; $53b8
	jr nz,@setAnimation	; $53ba

	ld a,LINK_ANIM_MODE_2d		; $53bc
	jr @setAnimation		; $53be
.endif

@notUnderwater:
	; Check if Link is riding something
	ld a,(wLinkObjectIndex)		; $53c0
	rrca			; $53c3
	ld a,c			; $53c4
	jr nc,@setAnimation	; $53c5

	cp LINK_ANIM_MODE_20			; $53c7
	jr c,@setAnimation	; $53c9

	cp LINK_ANIM_MODE_24			; $53cb
	jr nc,@setAnimation	; $53cd
	add $04			; $53cf

@setAnimation:
	jp specialObjectSetAnimationWithLinkData		; $53d1

;;
; Same as below, except it's assumed that only one instance of the child can exist.
;
; @addr{53d4}
itemCreateChildIfDoesntExistAlready:
	ld e,$01		; $53d4

;;
; Creates the child if the given # of instances don't already exist; delete the parent on
; failure.
;
; @param	e	Max # of instances of the child
; @addr{53d6}
itemCreateChildAndDeleteOnFailure:
	call itemCreateChild		; $53d6
	ret nc			; $53d9
	jp _clearParentItem		; $53da

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
; @addr{53dd}
itemCreateChild:
	ld c,$00		; $53dd
	ld h,d			; $53df
	ld l,Item.id		; $53e0
	ld b,(hl)		; $53e2

;;
; @param	b	Item ID to create (see constants/itemTypes.s)
; @param	c	Subid for item
; @param	d	Points to w1ParentItem2, or some parent item?
; @param	e	Max # instances of the object that can exist (0 means 256)
; @param[out]	h	The newly created child item
; @param[out]	cflag	Set on failure
; @addr{53e3}
itemCreateChildWithID:
	ld h,d			; $53e3
	ld l,Item.relatedObj2+1		; $53e4
	ldd a,(hl)		; $53e6
	ld l,(hl)		; $53e7
	ld h,a			; $53e8
	cp $01			; $53e9
	scf			; $53eb
	ret z			; $53ec

	; If relatedObj2 is pointing to something other than Link, this will overwrite that.
	cp >w1Link			; $53ed
	call z,_getFreeItemSlotWithObjectCap		; $53ef
	ret c			; $53f2

	; Set Item.enabled
	inc (hl)		; $53f3

	; Set Item.id and Item.subid
	inc l			; $53f4
	ld a,b			; $53f5
	ldi (hl),a		; $53f6
	ld a,c			; $53f7
	ldi (hl),a		; $53f8

	; Clear Item.var03, Item.state, Item.state2
	xor a			; $53f9
	ldi (hl),a		; $53fa
	ldi (hl),a		; $53fb
	ldi (hl),a		; $53fc

	; Copy link's direction and position variables to the item
	push de			; $53fd
	ld de,w1Link.direction		; $53fe
	ld l,Item.direction		; $5401
	ld b,$08		; $5403
	call copyMemoryReverse		; $5405
	pop de			; $5408

	; Set "parent" object?
	ld l,Item.relatedObj1		; $5409
	lda Item.start			; $540b
	ldi (hl),a		; $540c
	ld (hl),d		; $540d

	; And vice versa; set parent's "child" object?
	ld e,Item.relatedObj2		; $540e
	ld (de),a		; $5410
	inc e			; $5411
	ld a,h			; $5412
	ld (de),a		; $5413

	xor a			; $5414
	ret			; $5415

;;
; @param	bc	ID of item to create.
; @param	e	Maximum number of items with ID "bc" that can exist (0 means 256).
; @param[out]	hl	Free item slot
; @param[out]	cflag	Set on failure.
; @addr{5416}
_getFreeItemSlotWithObjectCap:
	ldhl FIRST_DYNAMIC_ITEM_INDEX, Item.id		; $5416

	; Loop through all existing items, make sure that the maximum number of objects of
	; type "bc" allowed is not exceeded.
@itemLoop:
	; Compare Item.id and Item.subid with bc
	ld a,(hl)		; $5419
	cp b			; $541a
	jr nz,@nextItem		; $541b
	inc l			; $541d
	ldd a,(hl)		; $541e
	cp c			; $541f
	jr nz,@nextItem		; $5420

	dec e			; $5422
	jr z,@failure		; $5423
@nextItem:
	inc h			; $5425
	ld a,h			; $5426
	cp LAST_DYNAMIC_ITEM_INDEX+1			; $5427
	jr c,@itemLoop		; $5429

	; End of loop; maximum number of objects not exceeded.
	call getFreeItemSlot		; $542b
	ret z			; $542e

@failure:
	scf			; $542f
	ret			; $5430

;;
; Unused in Ages.
;
; @param[out]	a	Number of available slots
; @param[out]	zflag
; @addr{5431}
_getNumFreeItemSlots:
	ldhl FIRST_DYNAMIC_ITEM_INDEX, Item.start		; $5431
	ld b,$00		; $5434
--
	ld a,(hl)		; $5436
	or a			; $5437
	jr nz,+			; $5438
	inc b			; $543a
+
	inc h			; $543b
	ld a,h			; $543c
	cp LAST_DYNAMIC_ITEM_INDEX+1			; $543d
	jr c,--			; $543f
	ld a,b			; $5441
	or a			; $5442
	ret			; $5443

;;
; @param d Parent item to add to wLinkUsingItem1
; @addr{5444}
_setLinkUsingItem1:
	call _itemIndexToBit		; $5444
	swap a			; $5447
	or (hl)			; $5449
	ld hl,wLinkUsingItem1		; $544a
	or (hl)			; $544d
	ld (hl),a		; $544e
	ret			; $544f

;;
; @param d Parent item to clear from wLinkUsingItem1
; @addr{5450}
_clearLinkUsingItem1:
	call _itemIndexToBit		; $5450
	swap a			; $5453
	or (hl)			; $5455
	cpl			; $5456
	ld hl,wLinkUsingItem1		; $5457
	and (hl)		; $545a
	ld (hl),a		; $545b
	ret			; $545c

;;
; @param d Parent item to add to wLinkImmobilized
; @addr{545d}
_itemDisableLinkMovement:
	call _itemIndexToBit		; $545d
	ld hl,wLinkImmobilized		; $5460
	or (hl)			; $5463
	ld (hl),a		; $5464
	ret			; $5465

;;
; @param d Parent item to clear from wLinkImmobilized
; @addr{5466}
_itemEnableLinkMovement:
	call _itemIndexToBit		; $5466
	ld hl,wLinkImmobilized		; $5469
	cpl			; $546c
	and (hl)		; $546d
	ld (hl),a		; $546e
	ret			; $546f

;;
; @param d Parent item to add to wLinkTurningDisabled
; @addr{5470}
_itemDisableLinkTurning:
	call _itemIndexToBit		; $5470
	ld hl,wLinkTurningDisabled		; $5473
	or (hl)			; $5476
	ld (hl),a		; $5477
	ret			; $5478

;;
; @param d Parent item to clear from wLinkTurningDisabled
; @addr{5479}
_itemEnableLinkTurning:
	call _itemIndexToBit		; $5479
	ld hl,wLinkTurningDisabled		; $547c
	cpl			; $547f
	and (hl)		; $5480
	ld (hl),a		; $5481
	ret			; $5482

;;
; Unused?
;
; @param d Parent item to add to wcc95
; @addr{5483}
_setCc95Bit:
	call _itemIndexToBit		; $5483
	ld hl,wcc95		; $5486
	or (hl)			; $5489
	ld (hl),a		; $548a
	ret			; $548b

;;
; Turn an item index (starting at $d2) into a bit.
;
; @param	d	Parent item object
; @param[out]	a	Bitmask for the item
; @addr{548c}
_itemIndexToBit:
	ld a,d			; $548c
	sub >w1ParentItem2			; $548d
	ld hl,bitTable		; $548f
	add l			; $5492
	ld l,a			; $5493
	ld a,(hl)		; $5494
	ret			; $5495

;;
; Checks if the button corresponding to the parent item object is pressed (the bitmask is
; stored in var03).
;
; @addr{5496}
_parentItemCheckButtonPressed:
	ld h,d			; $5496
	ld l,Item.var03		; $5497

;;
; @param	hl
; @addr{5499}
_andHlWithGameKeysPressed:
	ld a,(wGameKeysPressed)		; $5499
	and (hl)		; $549c
	ret			; $549d

;;
; @param	d	Parent item object
; @addr{549e}
_clearParentItemIfCantUseSword:
	; Check if in a spinner
	ld a,(wcc95)		; $549e
	rlca			; $54a1
	jr c,@cantUseSword	; $54a2

	ld a,(wLinkClimbingVine)		; $54a4
	inc a			; $54a7
	jr z,@cantUseSword	; $54a8

	ld a,(wccd8)		; $54aa
	ld b,a			; $54ad
	ld a,(wSwordDisabledCounter)		; $54ae
	or b			; $54b1
	ret z			; $54b2

	ld e,Item.state		; $54b3
	ld a,(de)		; $54b5
	or a			; $54b6
	ld a,SND_ERROR		; $54b7
	call z,playSound		; $54b9

@cantUseSword:
	pop af			; $54bc
	xor a			; $54bd
	ld (wcc63),a		; $54be
	jp _clearParentItem		; $54c1

;;
; @param[out]	zflag	Set if link is on the ground (not on companion, not underwater,
;			not swimming, not in the air).
; @addr{54c4}
_checkLinkOnGround:
	ld a,(wLinkObjectIndex)		; $54c4
	and $01			; $54c7
	ret nz			; $54c9

	ld hl,wLinkInAir		; $54ca
	ldi a,(hl)		; $54cd

	; Check wLinkSwimmingState
	or (hl)			; $54ce

.ifdef ROM_AGES
	ret nz			; $54cf
	jr _isLinkUnderwater		; $54d0

.else; ROM_SEASONS
	ret
.endif


.ifdef ROM_AGES
;;
; TODO: rename this to the inverse of what it is now
; @param[out]	zflag	z if Link is not in an underwater map
; @addr{54d2}
_isLinkUnderwater:
	ld a,(w1Link.var2f)		; $54d2
	bit 7,a			; $54d5
	ret			; $54d7
.endif

;;
; @param[out]	cflag	Set if link is currently in a hole.
; @addr{54d8}
_isLinkInHole:
	ld a,(wActiveTileType)		; $54d8
	dec a			; $54db
	cp $02			; $54dc
	ret			; $54de

;;
; Updates the position of a grabbed object (overwrites its x/y/z variables).
;
; @addr{54df}
updateGrabbedObjectPosition:
	ld a,(wLinkGrabState2)		; $54df
	ld b,a			; $54e2
	rlca			; $54e3
	ret c			; $54e4

	; Set active object
	ld de,w1Link		; $54e5
	ld a,e			; $54e8
	ldh (<hActiveObjectType),a	; $54e9
	ld a,d			; $54eb
	ldh (<hActiveObject),a	; $54ec

	; If the lift animation is finished, use the animParameter to help determine which
	; frame data to use
	ld a,(wLinkGrabState)		; $54ee
	cp $83			; $54f1
	jr nz,+			; $54f3
	ld e,<w1Link.animParameter		; $54f5
	ld a,(de)		; $54f7
	and $0f			; $54f8
	add b			; $54fa
	ld b,a			; $54fb
+
	; Get position offsets in 'bc'
	ld e,<w1Link.direction		; $54fc
	ld a,(de)		; $54fe
	add b			; $54ff
	ld hl,@liftedObjectPositions		; $5500
	rst_addDoubleIndex			; $5503
	ldi a,(hl)		; $5504
	ld b,a			; $5505
	ldi a,(hl)		; $5506
	ld c,a			; $5507

	; Link.yh -> Object.yh
	ld a,Object.yh		; $5508
	call objectGetRelatedObject2Var		; $550a
	ld e,<w1Link.yh		; $550d
	ld a,(de)		; $550f
	ldi (hl),a		; $5510

	; Link.xh + 'c' -> Object.xh
	inc l			; $5511
	ld e,<w1Link.xh		; $5512
	ld a,(de)		; $5514
	add c			; $5515
	ldi (hl),a		; $5516

	; Link.zh + 'b' -> Object.zh
	inc l			; $5517
	ld e,<w1Link.zh		; $5518
	ld a,(de)		; $551a
	add b			; $551b
	ldi (hl),a		; $551c
	ret			; $551d


; Each 2 bytes are Z/X offsets relative to Link where an object should be placed.
; Each row has 8 bytes, 2 for each of Link's facing directions.
;
; @addr{551e}
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
