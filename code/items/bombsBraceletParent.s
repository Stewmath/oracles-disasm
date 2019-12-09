;;
; ITEMID_BOMBCHUS ($0d)
; @addr{502e}
_parentItemCode_bombchu:
	ld e,Item.state		; $502e
	ld a,(de)		; $5030
	rst_jumpTable			; $5031
	.dw @state0
	.dw _parentItemGenericState1

@state0:
.ifdef ROM_AGES
	; Must be above water
	call _isLinkUnderwater		; $5036
	jp nz,_clearParentItem		; $5039
	; Can't be on raft
	ld a,(w1Companion.id)		; $503c
	cp SPECIALOBJECTID_RAFT			; $503f
	jp z,_clearParentItem		; $5041
.endif

	; Can't be swimming
	ld a,(wLinkSwimmingState)		; $5044
	or a			; $5047
	jp nz,_clearParentItem		; $5048

	; Must have bombchus
	ld a,(wNumBombchus)		; $504b
	or a			; $504e
	jp z,_clearParentItem		; $504f

	call _parentItemLoadAnimationAndIncState		; $5052

	; Create a bombchu if there isn't one on the screen already
	ld e,$01		; $5055
	jp itemCreateChildAndDeleteOnFailure		; $5057

;;
; ITEMID_BOMB ($03)
; @addr{505a}
_parentItemCode_bomb:
	ld e,Item.state		; $505a
	ld a,(de)		; $505c
	rst_jumpTable			; $505d

	.dw @state0
	.dw _parentItemGenericState1
	.dw _parentItemCode_bracelet@state2
	.dw _parentItemCode_bracelet@state3
	.dw _parentItemCode_bracelet@state4

@state0:
.ifdef ROM_AGES
	call _isLinkUnderwater		; $5068
	jp nz,_clearParentItem		; $506b
	; If Link is riding something other than a raft, don't allow usage of bombs
	ld a,(w1Companion.id)		; $506e
	cp SPECIALOBJECTID_RAFT			; $5071
	jr z,+			; $5073
.endif
	ld a,(wLinkObjectIndex)		; $5075
	rrca			; $5078
	jp c,_clearParentItem		; $5079
+
	ld a,(wLinkSwimmingState)		; $507c
	ld b,a			; $507f
	ld a,(wLinkInAir)		; $5080
	or b			; $5083
	jp nz,_clearParentItem		; $5084

	; Try to pick up a bomb
	call _tryPickupBombs		; $5087
	jp nz,_parentItemCode_bracelet@beginPickupAndSetAnimation		; $508a

	; Try to create a bomb
	ld a,(wNumBombs)		; $508d
	or a			; $5090
	jp z,_clearParentItem		; $5091

	call _parentItemLoadAnimationAndIncState		; $5094
	ld e,$01		; $5097
	ld a,BOMBERS_RING		; $5099
	call cpActiveRing		; $509b
	jr nz,+			; $509e
	inc e			; $50a0
+
	call itemCreateChild		; $50a1
	jp c,_clearParentItem		; $50a4

	call _makeLinkPickupObjectH		; $50a7
	jp _parentItemCode_bracelet@beginPickup		; $50aa

;;
; Makes Link pick up a bomb object if such an object exists and Link's touching it.
;
; @param[out]	zflag	Unset if a bomb was picked up
; @addr{50ad}
_tryPickupBombs:
	; Return if Link's using something?
	ld a,(wLinkUsingItem1)		; $50ad
	or a			; $50b0
	jr nz,@setZFlag	; $50b1

	; Return with zflag set if there is no existing bomb object
	ld c,ITEMID_BOMB		; $50b3
	call findItemWithID		; $50b5
	jr nz,@setZFlag	; $50b8

	call @pickupObjectIfTouchingLink		; $50ba
	ret nz			; $50bd

	; Try to find a second bomb object & pick that up
	ld c,ITEMID_BOMB		; $50be
	call findItemWithID_startingAfterH		; $50c0
	jr nz,@setZFlag	; $50c3


; @param	h	Object to check
; @param[out]	zflag	Set on failure (no collision with Link)
@pickupObjectIfTouchingLink:
	ld l,Item.var2f		; $50c5
	ld a,(hl)		; $50c7
	and $b0			; $50c8
	jr nz,@setZFlag	; $50ca
	call objectHCheckCollisionWithLink		; $50cc
	jr c,_makeLinkPickupObjectH	; $50cf

@setZFlag:
	xor a			; $50d1
	ret			; $50d2

;;
; @param	h	Object to make Link pick up
; @addr{50d3}
_makeLinkPickupObjectH:
	ld l,Item.enabled		; $50d3
	set 1,(hl)		; $50d5

	ld l,Item.state2		; $50d7
	xor a			; $50d9
	ldd (hl),a		; $50da
	ld (hl),$02		; $50db

	ld (w1Link.relatedObj2),a		; $50dd
	ld a,h			; $50e0
	ld (w1Link.relatedObj2+1),a		; $50e1
	or a			; $50e4
	ret			; $50e5


;;
; Bracelet's code is also heavily used by bombs.
;
; ITEMID_BRACELET ($16)
; @addr{50e6}
_parentItemCode_bracelet:
	ld e,Item.state		; $50e6
	ld a,(de)		; $50e8
	rst_jumpTable			; $50e9

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

; State 0: not grabbing anything
@state0:
	call _checkLinkOnGround		; $50f6
	jp nz,_clearParentItem		; $50f9

.ifdef ROM_SEASONS
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	jp z,_clearParentItem
.endif

	ld a,(w1ReservedItemC.enabled)		; $50fc
	or a			; $50ff
	jp nz,_clearParentItem		; $5100

	call _parentItemCheckButtonPressed		; $5103
	jp z,@dropAndDeleteSelf		; $5106

	ld a,(wLinkUsingItem1)		; $5109
	or a			; $510c
	jr nz,++		; $510d

	; Check if there's anything to pick up
	call checkGrabbableObjects		; $510f
	jr c,@beginPickupAndSetAnimation	; $5112
	call _tryPickupBombs		; $5114
	jr nz,@beginPickupAndSetAnimation	; $5117

	; Try to grab a solid tile
	call @checkWallInFrontOfLink		; $5119
	jr nz,++		; $511c
	ld a,$41		; $511e
	ld (wLinkGrabState),a		; $5120
	jp _parentItemLoadAnimationAndIncState		; $5123
++
	ld a,(w1Link.direction)		; $5126
	or $80			; $5129
	ld (wBraceletGrabbingNothing),a		; $512b
	ret			; $512e


; State 1: grabbing a wall
@state1:
	call @deleteAndRetIfSwimmingOrGrabState0		; $512f
	ld a,(w1Link.knockbackCounter)		; $5132
	or a			; $5135
	jp nz,@dropAndDeleteSelf		; $5136

	call _parentItemCheckButtonPressed		; $5139
	jp z,@dropAndDeleteSelf		; $513c

	ld a,(wLinkInAir)		; $513f
	or a			; $5142
	jp nz,@dropAndDeleteSelf		; $5143

	call @checkWallInFrontOfLink		; $5146
	jp nz,@dropAndDeleteSelf		; $5149

	; Check that the correct direction button is pressed
	ld a,(w1Link.direction)		; $514c
	ld hl,@counterDirections		; $514f
	rst_addAToHl			; $5152
	call _andHlWithGameKeysPressed		; $5153
	ld a,LINK_ANIM_MODE_LIFT_3		; $5156
	jp z,specialObjectSetAnimationWithLinkData		; $5158

	; Update animation, wait for animParameter to set bit 7
	call _specialObjectAnimate		; $515b
	ld e,Item.animParameter		; $515e
	ld a,(de)		; $5160
	rlca			; $5161
	ret nc			; $5162

	; Try to lift the tile, return if not possible
	call @checkWallInFrontOfLink		; $5163
	jp nz,@dropAndDeleteSelf		; $5166
	lda BREAKABLETILESOURCE_00			; $5169
	call tryToBreakTile		; $516a
	ret nc			; $516d

	; Create the sprite to replace the broken tile
	ld hl,w1ReservedItemC.enabled		; $516e
	ld a,$03		; $5171
	ldi (hl),a		; $5173
	ld (hl),ITEMID_BRACELET		; $5174

	; Set subid to former tile ID
	inc l			; $5176
	ldh a,(<hFF92)	; $5177
	ldi (hl),a		; $5179
	ld e,Item.var37		; $517a
	ld (de),a		; $517c

	; Set child item's var03 (the interaction ID for the effect on breakage)
	ldh a,(<hFF8E)	; $517d
	ldi (hl),a		; $517f

	lda Item.start			; $5180
	ld (w1Link.relatedObj2),a		; $5181
	ld a,h			; $5184
	ld (w1Link.relatedObj2+1),a		; $5185

@beginPickupAndSetAnimation:
	ld a,LINK_ANIM_MODE_LIFT_4		; $5188
	call specialObjectSetAnimationWithLinkData		; $518a

@beginPickup:
	call _itemDisableLinkMovement		; $518d
	call _itemDisableLinkTurning		; $5190
	ld a,$c2		; $5193
	ld (wLinkGrabState),a		; $5195
	xor a			; $5198
	ld (wLinkGrabState2),a		; $5199
	ld hl,w1Link.collisionType		; $519c
	res 7,(hl)		; $519f

	ld a,$02		; $51a1
	ld e,Item.state		; $51a3
	ld (de),a		; $51a5
	ld e,Item.var3f		; $51a6
	ld a,$0f		; $51a8
	ld (de),a		; $51aa

	ld a,SND_PICKUP		; $51ab
	jp playSound		; $51ad


; Opposite direction to press in order to use bracelet
@counterDirections:
	.db BTN_DOWN	; DIR_UP
	.db BTN_LEFT	; DIR_RIGHT
	.db BTN_UP	; DIR_DOWN
	.db BTN_RIGHT	; DIR_LEFT


; State 2: picking an item up.
; This is also state 2 for bombs.
@state2:
	call @deleteAndRetIfSwimmingOrGrabState0		; $51b4
	call _specialObjectAnimate		; $51b7

	; Check if link's pulling a lever?
	ld a,(wLinkGrabState2)		; $51ba
	rlca			; $51bd
	jr nc,++		; $51be

	; Go to state 5 for lever pulling?
	ld a,$83		; $51c0
	ld (wLinkGrabState),a		; $51c2
	ld e,Item.state		; $51c5
	ld a,$05		; $51c7
	ld (de),a		; $51c9
	ld a,LINK_ANIM_MODE_LIFT_2		; $51ca
	jp specialObjectSetAnimationWithLinkData		; $51cc
++
	ld h,d			; $51cf
	ld l,Item.animParameter		; $51d0
	bit 7,(hl)		; $51d2
	jr nz,++		; $51d4

	; The animParameter determines the object's offset relative to Link?
	ld a,(wLinkGrabState2)		; $51d6
	and $f0			; $51d9
	add (hl)		; $51db
	ld (wLinkGrabState2),a		; $51dc
	ret			; $51df
++
	; Pickup animation finished
	ld a,$83		; $51e0
	ld (wLinkGrabState),a		; $51e2
	ld l,Item.state		; $51e5
	inc (hl)		; $51e7
	ld l,Item.var3f		; $51e8
	ld (hl),$00		; $51ea

	; Re-enable link collisions & movement
	ld hl,w1Link.collisionType		; $51ec
	set 7,(hl)		; $51ef
	call _itemEnableLinkTurning		; $51f1
	jp _itemEnableLinkMovement		; $51f4


; State 3: holding the object
; This is also state 3 for bombs.
@state3:
	call @deleteAndRetIfSwimmingOrGrabState0		; $51f7
	ld a,(wLinkInAir)		; $51fa
	rlca			; $51fd
	ret c			; $51fe
	ld a,(wcc67)		; $51ff
	or a			; $5202
	ret nz			; $5203
	ld a,(w1Link.var2a)		; $5204
	or a			; $5207
	jr nz,++		; $5208

	ld a,(wGameKeysJustPressed)		; $520a
	and BTN_A|BTN_B			; $520d
	ret z			; $520f

	call updateLinkDirectionFromAngle		; $5210
++
	; Item is being thrown

	; Unlink related object from Link, set its "state2" to $02 (meaning just thrown)
	ld hl,w1Link.relatedObj2		; $5213
	xor a			; $5216
	ld c,(hl)		; $5217
	ldi (hl),a		; $5218
	ld b,(hl)		; $5219
	ldi (hl),a		; $521a
	ld a,c			; $521b
	add Object.state2			; $521c
	ld l,a			; $521e
	ld h,b			; $521f
	ld (hl),$02		; $5220

	; If it was a tile that was picked up, don't create any new objects
	ld e,Item.var37		; $5222
	ld a,(de)		; $5224
	or a			; $5225
	jr nz,@@throwItem	; $5226

	; If this is referencing an item object beyond index $d7, don't create object $dc
	ld a,c			; $5228
	cpa Item.start			; $5229
	jr nz,@@createPlaceholder	; $522a
	ld a,b			; $522c
	cp FIRST_DYNAMIC_ITEM_INDEX			; $522d
	jr nc,@@throwItem	; $522f

	; Create an invisible bracelet object to be used for collisions?
	; This is used when throwing dimitri, but not for picked-up tiles.
@@createPlaceholder:
	push de			; $5231
	ld hl,w1ReservedItemC.enabled		; $5232
	inc (hl)		; $5235
	inc l			; $5236
	ld a,ITEMID_BRACELET		; $5237
	ldi (hl),a		; $5239

	; Copy over this parent item's former relatedObj2 & Y/X to the new "physical" item
	ld l,Item.relatedObj2		; $523a
	ld a,c			; $523c
	ldi (hl),a		; $523d
	ld (hl),b		; $523e
	add Item.yh			; $523f
	ld e,a			; $5241
	ld d,b			; $5242
	call objectCopyPosition_rawAddress		; $5243
	pop de			; $5246

@@throwItem:
	ld a,(wLinkAngle)		; $5247
	rlca			; $524a
	jr c,+			; $524b
	ld a,(w1Link.direction)		; $524d
	swap a			; $5250
	rrca			; $5252
+
	ld l,Item.angle		; $5253
	ld (hl),a		; $5255
	ld l,Item.var38		; $5256
	ld a,(wLinkGrabState2)		; $5258
	ld (hl),a		; $525b
	xor a			; $525c
	ld (wLinkGrabState2),a		; $525d
	ld (wLinkGrabState),a		; $5260
	ld h,d			; $5263
	ld l,Item.state		; $5264
	inc (hl)		; $5266
	ld l,Item.var3f		; $5267
	ld (hl),$0f		; $5269

	ld c,LINK_ANIM_MODE_THROW		; $526b

.ifdef ROM_AGES ; TODO: why does only ages check this?
	; Load animation depending on whether Link's riding a minecart
	ld a,(w1Companion.id)		; $526d
	cp SPECIALOBJECTID_MINECART			; $5270
	jr nz,+			; $5272
.endif

	ld a,(wLinkObjectIndex)		; $5274
	rrca			; $5277
	jr nc,+			; $5278
	ld c,LINK_ANIM_MODE_25		; $527a
+
	ld a,c			; $527c
	call specialObjectSetAnimationWithLinkData		; $527d
	call _itemDisableLinkMovement		; $5280
	call _itemDisableLinkTurning		; $5283
	ld a,SND_THROW		; $5286
	jp playSound		; $5288


; State 4: Link in throwing animation.
; This is also state 4 for bombs.
@state4:
	ld e,Item.animParameter		; $528b
	ld a,(de)		; $528d
	rlca			; $528e
	jp nc,_specialObjectAnimate		; $528f
	jr @dropAndDeleteSelf		; $5292

;;
; @addr{5294}
@deleteAndRetIfSwimmingOrGrabState0:
	ld a,(wLinkSwimmingState)		; $5294
	or a			; $5297
	jr nz,+			; $5298
	ld a,(wLinkGrabState)		; $529a
	or a			; $529d
	ret nz			; $529e
+
	pop af			; $529f

@dropAndDeleteSelf:
	call dropLinkHeldItem		; $52a0
	jp _clearParentItem		; $52a3

;;
; @param[out]	bc	Y/X of tile Link is grabbing
; @param[out]	zflag	Set if Link is directly facing a wall
; @addr{52a6}
@checkWallInFrontOfLink:
	ld a,(w1Link.direction)		; $52a6
	ld b,a			; $52a9
	add a			; $52aa
	add b			; $52ab
	ld hl,@@data		; $52ac
	rst_addAToHl			; $52af
	ld a,(w1Link.adjacentWallsBitset)		; $52b0
	and (hl)		; $52b3
	cp (hl)			; $52b4
	ret nz			; $52b5

	inc hl			; $52b6
	ld a,(w1Link.yh)		; $52b7
	add (hl)		; $52ba
	ld b,a			; $52bb
	inc hl			; $52bc
	ld a,(w1Link.xh)		; $52bd
	add (hl)		; $52c0
	ld c,a			; $52c1
	xor a			; $52c2
	ret			; $52c3

; b0: bits in w1Link.adjacentWallsBitset that should be set
; b1/b2: Y/X offsets from Link's position
@@data:
	.db $c0 $fb $00 ; DIR_UP
	.db $03 $00 $07 ; DIR_RIGHT
	.db $30 $07 $00 ; DIR_DOWN
	.db $0c $00 $f8 ; DIR_LEFT


; State 5: pulling a lever?
@state5:
	call _parentItemCheckButtonPressed	; $52d0
	jp z,@dropAndDeleteSelf		; $52d3
	call @deleteAndRetIfSwimmingOrGrabState0		; $52d6
	ld a,(w1Link.knockbackCounter)		; $52d9
	or a			; $52dc
	jp nz,@dropAndDeleteSelf		; $52dd

	ld a,(w1Link.direction)		; $52e0
	ld hl,@counterDirections		; $52e3
	rst_addAToHl			; $52e6
	ld a,(wGameKeysPressed)		; $52e7
	and (hl)		; $52ea
	ld a,LINK_ANIM_MODE_LIFT_2		; $52eb
	jp z,specialObjectSetAnimationWithLinkData		; $52ed
	jp _specialObjectAnimate		; $52f0
