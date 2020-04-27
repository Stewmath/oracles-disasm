;;
; @addr{4872}
updateItems:
	ld b,$00		; $4872

	ld a,(wScrollMode)		; $4874
	cp $08			; $4877
	jr z,@dontUpdateItems	; $4879

	ld a,(wDisabledObjects)		; $487b
	and $90			; $487e
	jr nz,@dontUpdateItems	; $4880

	ld a,(wPaletteThread_mode)		; $4882
	or a			; $4885
	jr nz,@dontUpdateItems	; $4886

	ld a,(wTextIsActive)		; $4888
	or a			; $488b
	jr z,++			; $488c

	; Set b to $01, indicating items shouldn't be updated after initialization
@dontUpdateItems:
	inc b			; $488e
++
	ld hl,wcc8b		; $488f
	ld a,(hl)		; $4892
	and $fe			; $4893
	or b			; $4895
	ld (hl),a		; $4896

	xor a			; $4897
	ld (wScentSeedActive),a		; $4898

	ld a,Item.start		; $489b
	ldh (<hActiveObjectType),a	; $489d
	ld d,FIRST_ITEM_INDEX		; $489f
	ld a,d			; $48a1

@itemLoop:
	ldh (<hActiveObject),a	; $48a2
	ld e,Item.start		; $48a4
	ld a,(de)		; $48a6
	or a			; $48a7
	jr z,@nextItem		; $48a8

	; Always update items when uninitialized
	ld e,Item.state		; $48aa
	ld a,(de)		; $48ac
	or a			; $48ad
	jr z,+			; $48ae

	; If already initialized, don't update items if this variable is set
	ld a,(wcc8b)		; $48b0
	or a			; $48b3
+
	call z,@updateItem		; $48b4
@nextItem:
	inc d			; $48b7
	ld a,d			; $48b8
	cp LAST_ITEM_INDEX+1			; $48b9
	jr c,@itemLoop		; $48bb
	ret			; $48bd

;;
; @param d Item index
; @addr{48be}
@updateItem:
	ld e,Item.id		; $48be
	ld a,(de)		; $48c0
	rst_jumpTable			; $48c1
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
; @addr{491a}
updateItemsPost:
	lda Item.start			; $491a
	ldh (<hActiveObjectType),a	; $491b
	ld d,FIRST_ITEM_INDEX		; $491d
	ld a,d			; $491f
@itemLoop:
	ldh (<hActiveObject),a	; $4920
	ld e,Item.enabled		; $4922
	ld a,(de)		; $4924
	or a			; $4925
	call nz,_updateItemPost		; $4926
	inc d			; $4929
	ld a,d			; $492a
	cp $e0			; $492b
	jr c,@itemLoop		; $492d

itemCodeNilPost:
	ret			; $492f

;;
; @addr{4930}
_updateItemPost:
	ld e,$01		; $4930
	ld a,(de)		; $4932
	rst_jumpTable			; $4933

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
; @addr{498c}
_loadAttributesAndGraphicsAndIncState:
	call itemIncState		; $498c
	ld l,Item.enabled		; $498f
	ld (hl),$03		; $4991

;;
; Loads values for Item.collisionRadiusY/X, Item.damage, Item.health, and loads graphics.
; @addr{4993}
_itemLoadAttributesAndGraphics:
	ld e,Item.id		; $4993
	ld a,(de)		; $4995
	add a			; $4996
	ld hl,itemAttributes		; $4997
	rst_addDoubleIndex			; $499a

	; b0: Item.collisionType
	ld e,Item.collisionType		; $499b
	ldi a,(hl)		; $499d
	ld (de),a		; $499e

	; b1: Item.collisionRadiusY/X
	ld e,Item.collisionRadiusY		; $499f
	ld a,(hl)		; $49a1
	swap a			; $49a2
	and $0f			; $49a4
	ld (de),a		; $49a6
	inc e			; $49a7
	ldi a,(hl)		; $49a8
	and $0f			; $49a9
	ld (de),a		; $49ab

	; b2: Item.damage
	inc e			; $49ac
	ldi a,(hl)		; $49ad
	ld (de),a		; $49ae
	ld c,a			; $49af

	; b3: Item.health
	inc e			; $49b0
	ldi a,(hl)		; $49b1
	ld (de),a		; $49b2

	; Write Item.damage to Item.var3a as well?
	ld e,Item.var3a		; $49b3
	ld a,c			; $49b5
	ld (de),a		; $49b6

	call _itemSetVar3cToFF		; $49b7
	jpab bank3f.itemLoadGraphics		; $49ba

;;
; @addr{49c2}
_itemSetVar3cToFF:
	ld e,Item.var3c		; $49c2
	ld a,$ff		; $49c4
	ld (de),a		; $49c6
	ret			; $49c7

;;
; Reduces the item's health according to the Item.damageToApply variable.
; Also does something with Item.var2a.
;
; @param[out]	a	[Item.var2a]
; @param[out]	hl	Item.var2a
; @param[out]	zflag	Set if Item.var2a is zero.
; @param[out]	cflag	Set if health went below 0
; @addr{49c8}
_itemUpdateDamageToApply:
	ld h,d			; $49c8
	ld l,Item.damageToApply		; $49c9
	ld a,(hl)		; $49cb
	ld (hl),$00		; $49cc

	ld l,Item.health		; $49ce
	add (hl)		; $49d0
	ld (hl),a		; $49d1
	rlca			; $49d2
	ld l,Item.var2a		; $49d3
	ld a,(hl)		; $49d5
	dec a			; $49d6
	inc a			; $49d7
	ret			; $49d8

;;
; @addr{49d9}
itemAnimate:
	ld h,d			; $49d9
	ld l,Item.animCounter		; $49da
	dec (hl)		; $49dc
	ret nz			; $49dd

	ld l,Item.animPointer		; $49de
	jr _itemNextAnimationFrame		; $49e0

;;
; @param a Animation index
; @addr{49e2}
itemSetAnimation:
	add a			; $49e2
	ld c,a			; $49e3
	ld b,$00		; $49e4
	ld e,Item.id		; $49e6
	ld a,(de)		; $49e8
	ld hl,itemAnimationTable		; $49e9
	rst_addDoubleIndex			; $49ec
	ldi a,(hl)		; $49ed
	ld h,(hl)		; $49ee
	ld l,a			; $49ef
	add hl,bc		; $49f0

;;
; @addr{49f1}
_itemNextAnimationFrame:
	ldi a,(hl)		; $49f1
	ld h,(hl)		; $49f2
	ld l,a			; $49f3

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)		; $49f4
	cp $ff			; $49f5
	jr nz,++		; $49f7

	; If $ff, animation loops
	ld b,a			; $49f9
	ld c,(hl)		; $49fa
	add hl,bc		; $49fb
	ldi a,(hl)		; $49fc
++
	ld e,Item.animCounter		; $49fd
	ld (de),a		; $49ff

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)		; $4a00
	ld c,a			; $4a01
	ld b,$00		; $4a02

	; Item.animParameter
	inc e			; $4a04
	ldi a,(hl)		; $4a05
	ld (de),a		; $4a06

	; Item.animPointer
	inc e			; $4a07
	; Save the current position in the animation
	ld a,l			; $4a08
	ld (de),a		; $4a09
	inc e			; $4a0a
	ld a,h			; $4a0b
	ld (de),a		; $4a0c

	ld e,Item.id		; $4a0d
	ld a,(de)		; $4a0f
	ld hl,itemOamDataTable		; $4a10
	rst_addDoubleIndex			; $4a13
	ldi a,(hl)		; $4a14
	ld h,(hl)		; $4a15
	ld l,a			; $4a16
	add hl,bc		; $4a17

	; Set the address of the oam data
	ld e,Item.oamDataAddress		; $4a18
	ldi a,(hl)		; $4a1a
	ld (de),a		; $4a1b
	inc e			; $4a1c
	ldi a,(hl)		; $4a1d
	and $3f			; $4a1e
	ld (de),a		; $4a20
	ret			; $4a21

;;
; Transfer an item's knockbackCounter and knockbackAngle to Link.
; @addr{4a22}
_itemTransferKnockbackToLink:
	ld h,d			; $4a22
	ld l,Item.knockbackCounter		; $4a23
	ld a,(hl)		; $4a25
	or a			; $4a26
	ret z			; $4a27

	ld (hl),$00		; $4a28

	; b = [Item.knockbackAngle]
	dec l			; $4a2a
	ld b,(hl)		; $4a2b

	ld hl,w1Link.knockbackCounter		; $4a2c
	cp (hl)			; $4a2f
	jr c,+			; $4a30
	ld (hl),a		; $4a32
+
	; Set Item.knockbackAngle
	dec l			; $4a33
	ld (hl),b		; $4a34
	ret			; $4a35

;;
; Applies speed based on Item.direction?
;
; @param	hl	Table of offsets for Y/X/Z positions based on Item.direction
; @addr{4a36}
_applyOffsetTableHL:
	ld e,Item.direction		; $4a36
	ld a,(de)		; $4a38

	; a *= 3
	ld e,a			; $4a39
	add a			; $4a3a
	add e			; $4a3b

	rst_addAToHl			; $4a3c

	; b0: Y offset
	ld e,Item.yh		; $4a3d
	ld a,(de)		; $4a3f
	add (hl)		; $4a40
	ld (de),a		; $4a41

	; b1: X offset
	inc hl			; $4a42
	ld e,Item.xh		; $4a43
	ld a,(de)		; $4a45
	add (hl)		; $4a46
	ld (de),a		; $4a47

	; b2: Z offset
	inc hl			; $4a48
	ld e,Item.zh		; $4a49
	ld a,(de)		; $4a4b
	add (hl)		; $4a4c
	ld (de),a		; $4a4d
	ret			; $4a4e

;;
; In sidescrolling areas, the Z position and Y position can't both exist.
; This function adds the Z position to the Y position, and zeroes the Z position.
;
; @param[out]	zflag	Set if not in a sidescrolling area
; @addr{4a4f}
_itemMergeZPositionIfSidescrollingArea:
	ld h,d			; $4a4f
	ld a,(wTilesetFlags)		; $4a50
	and TILESETFLAG_SIDESCROLL			; $4a53
	ret z			; $4a55

	ld e,Item.yh		; $4a56
	ld l,Item.zh		; $4a58
	ld a,(de)		; $4a5a
	add (hl)		; $4a5b
	ld (de),a		; $4a5c
	xor a			; $4a5d
	ldd (hl),a		; $4a5e
	ld (hl),a		; $4a5f
	or d			; $4a60
	ret			; $4a61

;;
; Updates Z position if in midair (not if on the ground). If the item falls into a hazard
; (water/lava/hole), this creates an animation, deletes the item, and returns from the
; caller.
;
; @param	c	Gravity
; @addr{4a62}
_itemUpdateSpeedZAndCheckHazards:
	ld e,Item.zh		; $4a62
	ld a,e			; $4a64
	ldh (<hFF8B),a	; $4a65
	ld a,(de)		; $4a67
	rlca			; $4a68
	jr nc,++		; $4a69

	; If in midair, update z speed
	rrca			; $4a6b
	ldh (<hFF8B),a	; $4a6c
	call objectUpdateSpeedZ_paramC		; $4a6e
	jr nz,+++		; $4a71

	; Item has hit the ground

	ldh (<hFF8B),a	; $4a73
++
	call objectReplaceWithAnimationIfOnHazard		; $4a75
	jr nc,+++		; $4a78

	; Return from caller if this was replaced with an animation
	pop hl			; $4a7a
	ld a,$ff		; $4a7b
	ret			; $4a7d

	; Above ground?
+++
	ldh a,(<hFF8B)	; $4a7e
	rlca			; $4a80
	or a			; $4a81
	ret			; $4a82

;;
; This function moves a bomb toward a point stored in the item's var31/var32 variables.
; Does nothing when var31/var32 are set to zero.
;
; Not used by bombchus, but IS used by scent seeds...
;
; @param[out]	cflag	Set when the bomb has reached the point (if such a point exists)
; @addr{4a83}
_bombPullTowardPoint:
	ld h,d			; $4a83

	; Return if object is above ground.
	ld l,Item.zh		; $4a84
	and $80			; $4a86
	jr nz,@end		; $4a88

	; The following code pulls a bomb towards a specific point.
	; The point is stored in its var31/var32 variables.

	; Load bc with Item.var31/32, and zero out those values
	ld l,Item.var31		; $4a8a
	ld b,(hl)		; $4a8c
	ldi (hl),a		; $4a8d
	ld c,(hl)		; $4a8e
	ldi (hl),a		; $4a8f
	; Return if they were already zero
	or b			; $4a90
	ret z			; $4a91

	; Return if the object contains the point
	push bc			; $4a92
	call objectCheckContainsPoint		; $4a93
	pop bc			; $4a96
	ret c			; $4a97

	; If it doesn't contain the point (not there yet), move toward it
	call objectGetRelativeAngle		; $4a98
	ld c,a			; $4a9b
	ld b,$0a		; $4a9c
	ld e,Item.angle		; $4a9e
	call objectApplyGivenSpeed		; $4aa0
@end:
	xor a			; $4aa3
	ret			; $4aa4

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
; @addr{4aa5}
_itemUpdateThrowingVertically:
	; Jump if in a sidescrolling area
	call _itemMergeZPositionIfSidescrollingArea		; $4aa5
	jr nz,@sidescrolling	; $4aa8

	; Update vertical speed, return if the object hasn't landed yet
	call objectUpdateSpeedZ_paramC		; $4aaa
	jr nz,@unsetCollision			; $4aad

	; Object has landed / is bouncing; need to check for collision with water, holes,
	; etc.

	call @checkHoleOrWater		; $4aaf
	bit 4,(hl)		; $4ab2
	set 4,(hl)		; $4ab4
	scf			; $4ab6
	ret			; $4ab7

;;
; @param[out]	zflag	Unset.
; @param[out]	cflag	Unset.
; @addr{4ab8}
@unsetCollision:
	ld l,Item.var3b		; $4ab8
	res 4,(hl)		; $4aba
	or d			; $4abc
	ret			; $4abd

;;
; @param[out]	zflag	Former value of bit 4 of Item.var3b.
; @param[out]	cflag	Set.
; @addr{4abe}
@setCollision:
	ld h,d			; $4abe
	ld l,Item.var3b		; $4abf
	bit 4,(hl)		; $4ac1
	set 4,(hl)		; $4ac3
	scf			; $4ac5
	ret			; $4ac6

;;
; Throwing item update code for sidescrolling areas
;
; @addr{4ac7}
@sidescrolling:
	push bc			; $4ac7
	call @checkHoleOrWater		; $4ac8

	; Jump if object is not moving up.
	ld l,Item.speedZ+1		; $4acb
	bit 7,(hl)		; $4acd
	jr z,@notMovingUp		; $4acf

	; Check for collision with the ceiling
	call objectCheckTileCollision_allowHoles		; $4ad1
	ld h,d			; $4ad4
	pop bc			; $4ad5
	jr nc,@noCeilingCollision	; $4ad6

	; Object collided with ceiling, so Y position isn't updated (though gravity is)
	ld b,$03		; $4ad8
	jr @updateGravity		; $4ada

@notMovingUp:
	; Check for a collision 5 pixels below center
	ld l,Item.yh		; $4adc
	ldi a,(hl)		; $4ade
	add $05			; $4adf
	ld b,a			; $4ae1
	inc l			; $4ae2
	ld c,(hl)		; $4ae3
	call checkTileCollisionAt_allowHoles		; $4ae4
	ld h,d			; $4ae7
	pop bc			; $4ae8
	jr c,@setCollision		; $4ae9

@noCeilingCollision:
	; Set maximum gravity = $0300 normally, $0100 when in water
	ld l,Item.var3b		; $4aeb
	bit 0,(hl)		; $4aed
	ld b,$03		; $4aef
	jr z,+			; $4af1

	ld b,$01		; $4af3
	bit 7,(hl)		; $4af5
	jr nz,@unsetCollision	; $4af7
+
	; Update Y position based on speedZ (since this is a sidescrolling area)
	ld e,Item.speedZ		; $4af9
	ld l,Item.y		; $4afb
	ld a,(de)		; $4afd
	add (hl)		; $4afe
	ldi (hl),a		; $4aff
	inc e			; $4b00
	ld a,(de)		; $4b01
	adc (hl)		; $4b02
	ldi (hl),a		; $4b03

@updateGravity:
	; Update speedZ based on gravity
	ld l,Item.speedZ		; $4b04
	ld a,(hl)		; $4b06
	add c			; $4b07
	ldi (hl),a		; $4b08
	ld a,(hl)		; $4b09
	adc $00			; $4b0a
	ld (hl),a		; $4b0c

	; Return if speedZ is beneath the maximum speed ('b').
	bit 7,a			; $4b0d
	jr nz,@unsetCollision	; $4b0f
	cp b			; $4b11
	jr c,@unsetCollision	; $4b12

	; Set speedZ to the maximum speed 'b'.
	ld (hl),b		; $4b14
	dec l			; $4b15
	ld (hl),$00		; $4b16
	jr @unsetCollision		; $4b18

;;
; Updates Item.var3b depending whether it's on a hole, lava, water tile.
; @addr{4b1a}
@checkHoleOrWater:
	call _itemMergeZPositionIfSidescrollingArea		; $4b1a
	jr nz,@@sidescrolling			; $4b1d

	; Note: a=0 here

	; If top-down view and object is in midair, skip the "objectCheckIsOverHazard" check
	ld l,Item.zh		; $4b1f
	bit 7,(hl)		; $4b21
	jr nz,++		; $4b23

@@sidescrolling:
	call objectCheckIsOverHazard		; $4b25
	ld h,d			; $4b28
++
	; Here, 'a' holds the value for what kind of landing collision has occurred.

	; Update Item.var3b: flip bit 7, clear bit 6, update bits 0-2
	ld b,a			; $4b29
	ld l,Item.var3b		; $4b2a
	ld a,(hl)		; $4b2c
	ld c,a			; $4b2d
	and $b8			; $4b2e
	xor $80			; $4b30
	or b			; $4b32
	ld (hl),a		; $4b33

	; Set bit 6 if the item's bit 0 has changed?
	; (in other words, "landed on water" state has changed)
	ld a,b			; $4b34
	xor c			; $4b35
	rrca			; $4b36
	jr nc,+			; $4b37
	set 6,(hl)		; $4b39
+
	ret			; $4b3b

;;
; Calls _itemUpdateThrowingVertically and creates an appropriate animation if this item
; has fallen into something (water, lava, or a hole). Caller still needs to delete the
; object.
;
; @param	c	Gravity
; @param[out]	cflag	Set if the object has landed in water, lava, or a hole.
; @param[out]	zflag	Set if the object is in midair.
; @addr{4b3c}
_itemUpdateThrowingVerticallyAndCheckHazards:
	call _itemUpdateThrowingVertically		; $4b3c
	jr c,@landed			; $4b3f

	; Object isn't on the ground, so only check for collisions in sidescrolling areas.

	ld a,(wTilesetFlags)		; $4b41
	and TILESETFLAG_SIDESCROLL			; $4b44
	jr z,+			; $4b46

	ld b,INTERACID_LAVASPLASH		; $4b48
	bit 2,(hl)		; $4b4a
	jr nz,@createSplash		; $4b4c

	ld b,INTERACID_SPLASH		; $4b4e
	bit 6,(hl)		; $4b50
	call nz,@createSplash		; $4b52
+
	xor a			; $4b55
	ret			; $4b56

@landed:
	; If the item has landed in a sidescrolling area, there's no need to check what it
	; landed on (since if it had touched water, it would have still been considered
	; to be in midair).
	ld a,(wTilesetFlags)		; $4b57
	and TILESETFLAG_SIDESCROLL			; $4b5a
	jr nz,@noCollisions		; $4b5c

	ld h,d			; $4b5e
	ld l,Item.var3b		; $4b5f
	ld b,INTERACID_SPLASH		; $4b61
	bit 0,(hl)		; $4b63
	jr nz,@createSplash		; $4b65

	ld b,$0f		; $4b67
	bit 1,(hl)		; $4b69
	jr nz,@createHoleAnim	; $4b6b

	ld b,INTERACID_LAVASPLASH		; $4b6d
	bit 2,(hl)		; $4b6f
	jr nz,@createSplash		; $4b71

@noCollisions:
	xor a			; $4b73
	bit 4,(hl)		; $4b74
	ret			; $4b76

@createSplash:
	call objectCreateInteractionWithSubid00		; $4b77
	scf			; $4b7a
	ret			; $4b7b

@createHoleAnim:
	call objectCreateFallingDownHoleInteraction		; $4b7c
	scf			; $4b7f
	ret			; $4b80

;;
; Creates an interaction to do the clinking animation.
; @addr{4b81}
_objectCreateClinkInteraction:
	ld b,INTERACID_CLINK		; $4b81
	jp objectCreateInteractionWithSubid00		; $4b83

;;
; @addr{4b86}
_cpRelatedObject1ID:
	ld a,Object.id		; $4b86
	call objectGetRelatedObject1Var		; $4b88
	ld e,Item.id		; $4b8b
	ld a,(de)		; $4b8d
	cp (hl)			; $4b8e
	ret			; $4b8f

;;
; Same as below, but checks the tile at position bc instead of the tile at the object's
; position.
;
; @param	bc	Position of tile to check
; @addr{4b90}
_itemCheckCanPassSolidTileAt:
	call getTileAtPosition		; $4b90
	jr ++			; $4b93

;;
; This function checks for exceptions to solid tiles which items (switch hook, seeds) can
; pass through. It also keeps track of an "elevation level" in var3e which keeps track of
; how many cliff tiles the item has passed through.
;
; Also updates var3c, var3d (tile position and index).
;
; @param[out]	zflag	Set if there is no collision.
; @addr{4b95}
_itemCheckCanPassSolidTile:
	call objectGetTileAtPosition		; $4b95
++
	; Check if position / tile has changed? (var3c = position, var3d = tile index)
	ld e,a			; $4b98
	ld a,l			; $4b99
	ld h,d			; $4b9a
	ld l,Item.var3c		; $4b9b
	cp (hl)			; $4b9d
	ldi (hl),a		; $4b9e
	jr nz,@tileChanged		; $4b9f

	; Return if the tile index has not changed
	ld a,e			; $4ba1
	cp (hl)			; $4ba2
	ret z			; $4ba3

@tileChanged:
	ld (hl),e		; $4ba4
	ld l,Item.angle		; $4ba5
	ld b,(hl)		; $4ba7
	call _checkTileIsPassableFromDirection		; $4ba8
	jr nc,@collision		; $4bab
	ret z			; $4bad

	; If there was no collision, but the zero flag was not set, the item must move up
	; or down an elevation level (depending on the value of a from the function call).
	ld h,d			; $4bae
	ld l,Item.var3e		; $4baf
	add (hl)		; $4bb1
	ld (hl),a		; $4bb2

	; Check if the item has passed to a "negative" elevation, if so, trigger
	; a collision
	and $80			; $4bb3
	ret z			; $4bb5

@collision:
	ld h,d			; $4bb6
	ld l,Item.var3c		; $4bb7
	ld a,$ff		; $4bb9
	ldi (hl),a		; $4bbb
	ld (hl),a		; $4bbc
	or d			; $4bbd
	ret			; $4bbe

;;
; Checks if an item can pass through the given tile with a given angle.
;
; @param	b	angle
; @param	e	Tile index
; @param[out]	a	The elevation level change that will occur if the item can pass
;			this tile
; @param[out]	cflag	Set if the tile is passable
; @param[out]	zflag	Set if there will be no elevation change (ignore the value of a)
; @addr{4bbf}
_checkTileIsPassableFromDirection:
	; Check if the tile can be passed by items
	ld hl,_itemPassableTilesTable		; $4bbf
	call findByteInCollisionTable_paramE		; $4bc2
	jr c,@canPassWithoutElevationChange		; $4bc5

	; Retrieve a value based on the given angle to see which directions
	; should be checked for passability
	ld a,b			; $4bc7
	ld hl,angleTable		; $4bc8
	rst_addAToHl			; $4bcb
	ld a,(hl)		; $4bcc
	push af			; $4bcd

	ld a,(wActiveCollisions)		; $4bce
	ld hl,_itemPassableCliffTilesTable		; $4bd1
	rst_addDoubleIndex			; $4bd4
	ldi a,(hl)		; $4bd5
	ld h,(hl)		; $4bd6
	ld l,a			; $4bd7

	; If the value retrieved from angleTable was odd, allow the item to pass
	; through 2 directions
	pop af			; $4bd8
	srl a			; $4bd9
	jr nc,@checkOneDirectionOnly	; $4bdb

	rst_addAToHl			; $4bdd
	ld a,(hl)		; $4bde
	push hl			; $4bdf
	rst_addAToHl			; $4be0
	call lookupKey		; $4be1
	pop hl			; $4be4
	jr c,@canPassWithElevationChange		; $4be5

	inc hl			; $4be7
	jr ++			; $4be8

@checkOneDirectionOnly:
	rst_addAToHl			; $4bea
++
	ld a,(hl)		; $4beb
	rst_addAToHl			; $4bec
	call lookupKey		; $4bed
	ret nc			; $4bf0

@canPassWithElevationChange:
	or a			; $4bf1
	scf			; $4bf2
	ret			; $4bf3

@canPassWithoutElevationChange:
	xor a			; $4bf4
	scf			; $4bf5
	ret			; $4bf6

;;
; Checks if the item is on a conveyor belt, updates its position if so.
;
; Used by bombs, bombchus. Might not work well with other items due to assumptions about
; their size.
;
; @addr{4bf7}
_itemUpdateConveyorBelt:
	; Return if in midair
	ld e,Item.zh		; $4bf7
	ld a,(de)		; $4bf9
	rlca			; $4bfa
	ret c			; $4bfb

	; Check if on a conveyor belt; get in 'a' the angle to move in if so
	ld bc,$0500		; $4bfc
	call objectGetRelativeTile		; $4bff
	ld hl,_itemConveyorTilesTable		; $4c02
	call lookupCollisionTable		; $4c05
	ret nc			; $4c08

	push af			; $4c09
	rrca			; $4c0a
	rrca			; $4c0b
	ld hl,_bombEdgeOffsets		; $4c0c
	rst_addAToHl			; $4c0f

	; Set 'bc' to the item's position + offset (where to check for a wall)
	ldi a,(hl)		; $4c10
	ld c,(hl)		; $4c11
	ld h,d			; $4c12
	ld l,Item.yh		; $4c13
	add (hl)		; $4c15
	ld b,a			; $4c16
	ld l,Item.xh		; $4c17
	ld a,(hl)		; $4c19
	add c			; $4c1a
	ld c,a			; $4c1b

	call getTileCollisionsAtPosition		; $4c1c
	cp SPECIALCOLLISION_SCREEN_BOUNDARY			; $4c1f
	jr z,@ret		; $4c21

	call checkGivenCollision_allowHoles		; $4c23
	jr c,@ret		; $4c26

	pop af			; $4c28
	ld c,a			; $4c29
	ld b,SPEED_80		; $4c2a
	ld e,Item.angle		; $4c2c
	jp objectApplyGivenSpeed		; $4c2e

@ret:
	pop af			; $4c31
	ret			; $4c32


; These are offsets from a bomb or bombchu's center to check for wall collisions at.
; This might apply to all throwable items?
_bombEdgeOffsets:
	.db $fd $00 ; DIR_UP
	.db $00 $03 ; DIR_RIGHT
	.db $07 $00 ; DIR_DOWN
	.db $00 $fd ; DIR_LEFT
