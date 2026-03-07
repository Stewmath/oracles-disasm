;;
; The chain on the switch hook; cycles between 3 intermediate positions
;
; ITEM_SWITCH_HOOK_CHAIN
itemCode0bPost:
	ld a,(w1WeaponItem.id)
	cp ITEM_SWITCH_HOOK
	jp nz,itemDelete

	ld a,(w1WeaponItem.var2f)
	bit 4,a
	jp nz,itemDelete

	; Copy Z position
	ld h,d
	ld a,(w1WeaponItem.zh)
	ld l,Item.zh
	ld (hl),a

	; Cycle through the 3 positions
	ld l,Item.counter1
	dec (hl)
	jr nz,+
	ld (hl),$03
+
	ld e,(hl)

	; Set Y position
	push de
	ld b,$03
	ld hl,w1WeaponItem.yh
	call @setPositionComponent

	; Set X position
	pop de
	ld b,$00
	ld hl,w1WeaponItem.xh

; @param	b	Offset to add to position
; @param	e	Index, or which position to place this at (1-3)
; @param	hl	X or Y position variable
@setPositionComponent:
	ld a,(hl)
	cp $f8
	jr c,+
	xor a
+
	; Calculate: c = ([Switch hook pos] - [Link pos]) / 4
	ld h,>w1Link
	sub (hl)
	ld c,a
	ld a,$00
	sbc a
	rra
	rr c
	rra
	rr c

	; Calculate: a = c * e
	xor a
-
	add c
	dec e
	jr nz,-

	; Add this to the current position (plus offset 'b')
	add (hl)
	add b
	ld h,d
	ldi (hl),a
	ret

;;
; ITEM_SWITCH_HOOK_CHAIN
itemCode0b:
	ld e,Item.state
	ld a,(de)
	or a
	ret nz

	call itemLoadAttributesAndGraphics
	call itemIncState
	ld l,Item.counter1
	ld (hl),$03
	xor a
	call itemSetAnimation
	jp objectSetVisible83

;;
; ITEM_SWITCH_HOOK
itemCode0aPost:
	call cpRelatedObject1ID
	ret z

	ld a,(wSwitchHookState)
	or a
	jp z,itemDelete

	jp func_5902

;;
; ITEM_SWITCH_HOOK
itemCode0a:
	ld a,$08
	ld (wDisableRingTransformations),a
	ld a,$80
	ld (wcc92),a
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw switchHookState3

@state0:
	ld a,UNCMP_GFXH_AGES_1f
	call loadWeaponGfx

	ld hl,@offsetsTable
	call applyOffsetTableHL

	call objectSetVisible82
	call loadAttributesAndGraphicsAndIncState

	; Depending on the switch hook's level, set speed (b) and # frames to extend (c)
	ldbc SPEED_200,$29
	ld a,(wSwitchHookLevel)
	dec a
	jr z,+
	ldbc SPEED_300,$26
+
	ld h,d
	ld l,Item.speed
	ld (hl),b
	ld l,Item.counter1
	ld (hl),c

	ld l,Item.var2f
	ld (hl),$01
	call itemUpdateAngle

	; Set animation based on Item.direction
	ld a,(hl)
	add $02
	jp itemSetAnimation

; Offsets to make the switch hook centered with link
@offsetsTable:
	.db $01 $00 $00 ; DIR_UP
	.db $03 $01 $00 ; DIR_RIGHT
	.db $01 $00 $00 ; DIR_DOWN
	.db $03 $ff $00 ; DIR_LEFT

; State 1: extending the hook
@state1:
	; When var2a is nonzero, a collision has occured?
	ld e,Item.var2a
	ld a,(de)
	or a
	jr z,+

	; If bit 5 is set, the switch hook can exchange with the object
	bit 5,a
	jr nz,@goToState3

	; Otherwise, it will be pulled back
	jr @startRetracting
+
	; Cancel the switch hook when you take damage
	ld h,d
	ld l,Item.var2f
	bit 5,(hl)
	jp nz,itemDelete

	call itemDecCounter1
	jr z,@startRetracting

	call objectCheckWithinRoomBoundary
	jr nc,@startRetracting

	; Check if collided with a tile
	call objectCheckTileCollision_allowHoles
	jr nc,@noCollisionWithTile

	; There is a collision, but check for exceptions (tiles that items can pass by)
	call itemCheckCanPassSolidTile
	jr nz,@collisionWithTile

@noCollisionWithTile:
	; Bit 3 of var2f remembers whether a "chain" item has been created
	ld e,Item.var2f
	ld a,(de)
	bit 3,a
	jr nz,++

	call getFreeItemSlot
	jr nz,++

	inc a
	ldi (hl),a
	ld (hl),ITEM_SWITCH_HOOK_CHAIN

	; Remember to not create the item again
	ld h,d
	ld l,Item.var2f
	set 3,(hl)
++
	call updateSwitchHookSound
	jp objectApplySpeed

@collisionWithTile:
	call objectCreateClinkInteraction

	; Check if the tile is breakable (oring with $80 makes it perform only a check,
	; not the breakage itself).
	ld a,$80 | BREAKABLETILESOURCE_SWITCH_HOOK
	call itemTryToBreakTile
	; Retract if not breakable by the switch hook
	jr nc,@startRetracting

	; Hooked onto a tile that can be swapped with
	ld e,Item.subid
	ld a,$01
	ld (de),a

@goToState3:
	ld a,$03
	call itemSetState

	; Disable collisions with objects?
	ld l,Item.collisionType
	res 7,(hl)

	ld a,$ff
	ld (wDisableLinkCollisionsAndMenu),a

	ld a,$01
	ld (wSwitchHookState),a

	jp resetLinkInvincibility

@label_07_185:
	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	ld (wSwitchHookState),a

@startRetracting:
	ld h,d

	; Disable collisions with objects?
	ld l,Item.collisionType
	res 7,(hl)

	ld a,$02
	jp itemSetState

; State 2: retracting the hook
@state2:
	ld e,Item.substate
	ld a,(de)
	or a
	jr nz,@fullyRetracted

	; The counter is just for keeping track of the sound?
	call itemDecCounter1
	call updateSwitchHookSound

	; Update angle based on position of link
	call objectGetAngleTowardLink
	ld e,Item.angle
	ld (de),a

	call objectApplySpeed

	; Check if within 8 pixels of link
	ld bc,$1008
	call itemCheckWithinRangeOfLink
	ret nc

	; Item has reached Link

	call itemIncSubstate

	; Set Item.counter1 to $03
	inc l
	ld (hl),$03

	ld l,Item.var2f
	set 4,(hl)
	jp objectSetInvisible

@fullyRetracted:
	ld hl,w1Link.yh
	call objectTakePosition
	call itemDecCounter1
	ret nz
	jp itemDelete

;;
; Swap with an object?
func_5902:
	call checkRelatedObject2States
	jr nc,++
	jr z,++

	ld a,Object.substate
	call objectGetRelatedObject2Var
	ld (hl),$03
++
	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	ld (wSwitchHookState),a
	jp itemDelete

; State 3: grabbed something switchable
; Uses w1ReservedItemE as ITEM_SWITCH_HOOK_HELPER to hold the positions for link and the
; object temporarily.
switchHookState3:
	ld e,Item.substate
	ld a,(de)
	rst_jumpTable
	.dw @s3subState0
	.dw @s3subState1
	.dw @s3subState2
	.dw @s3subState3

; Substate 0: grabbed an object/tile, doing the cling animation for several frames
@s3subState0:
	ld h,d

	; Check if deletion was requested?
	ld l,Item.var2f
	bit 5,(hl)
	jp nz,func_5902

	; Wait until the animation writes bit 7 to animParameter
	ld l,Item.animParameter
	bit 7,(hl)
	jp z,itemAnimate

	; At this point the animation is finished, now link and the hooked object/tile
	; will rise and swap

	call checkRelatedObject2States
	jr nc,itemCode0a@label_07_185
	; Jump if an object collision, not a tile collision
	jr nz,@@objectCollision

	; Tile collision

	; Break the tile underneath whatever was latched on to
	ld a,BREAKABLETILESOURCE_SWITCH_HOOK
	call itemTryToBreakTile
	jp nc,itemCode0a@label_07_185

	ld h,d
	ld l,Item.var03
	ldh a,(<hFF8E)
	ld (hl),a

	ld l,Item.var3c
	ldh a,(<hFF93)
	ldi (hl),a
	ldh a,(<hFF92)
	ld (hl),a

	; Imitate the tile that was grabbed
	call itemMimicBgTile

	ld h,d
	ld l,Item.var3c
	ld c,(hl)
	call objectSetShortPosition
	call objectSetVisiblec2
	jr +++

@@objectCollision:
	ld a,(w1ReservedInteraction1.id)
	cp INTERAC_PUSHBLOCK
	jr z,++

	; Get the object being switched with's yx in bc
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ldi a,(hl)
	inc l
	ld c,(hl)
	ld b,a

	callab bank5.checkPositionSurroundedByWalls
	rl b
	jr c,++

	ld a,Object.yh
	call objectGetRelatedObject2Var
	call objectTakePosition
	call objectSetInvisible
+++
	ld a,$02
	ld (wSwitchHookState),a
	ld a,SND_SWITCH2
	call playSound

	call itemIncSubstate

	ld l,Item.zh
	ld (hl),$00
	ld l,Item.var2f
	set 1,(hl)

	; Use w1ReservedItemE to keep copies of xyz positions
	ld hl,w1ReservedItemE
	ld a,$01
	ldi (hl),a
	ld (hl),ITEM_SWITCH_HOOK_HELPER

	; Zero Item.state and Item.substate
	ld l,Item.state
	xor a
	ldi (hl),a
	ldi (hl),a

	call objectCopyPosition
	jp resetLinkInvincibility
++
	ld a,Object.substate
	call objectGetRelatedObject2Var
	ld (hl),$03
	jp itemCode0a@label_07_185


; Substate 1: Link and the object are rising for several frames
@s3subState1:
	ld h,d
	ld l,Item.zh
	dec (hl)
	ld a,(hl)
	cp $f1
	call c,itemIncSubstate
	jr @updateOtherPositions

; Substate 2: Link and the object swap positions
@s3subState2:
	push de

	; Swap Link and Hook's xyz (at least, the copies in w1ReservedItemE)
	ld hl,w1ReservedItemE.var36
	ld de,w1ReservedItemE.var30
	ld b,$06
--
	ld a,(de)
	ld c,(hl)
	ldi (hl),a
	ld a,c
	ld (de),a
	inc e
	dec b
	jr nz,--

	pop de
	ld e,Item.subid
	ld a,(de)
	or a
	; Jump if hooked an object, and not a tile
	jr z,@doneCentering

	; Everything from here to @doneCentering involves centering the hooked tile at
	; link's position.

	ld a,(w1Link.direction)
	; a *= 3
	ld l,a
	add a
	add l

	ld hl,itemCode0a@offsetsTable
	rst_addAToHl

	push de
	ld de,w1ReservedItemE.var31
	ld a,(de)
	add (hl)
	ld (de),a

	inc hl
	ld e,<w1ReservedItemE.var33
	ld a,(de)
	add (hl)
	ld (de),a

	ld e,<w1ReservedItemE.var31
	call getShortPositionFromDE
	pop de
	ld l,a
	call checkCanPlaceDiamondOnTile
	jr z,++

	ld e,l
	ld a,(w1Link.direction)
	ld bc,@data
	call addAToBc
	ld a,(bc)
	rst_addAToHl
	call checkCanPlaceDiamondOnTile
	jr z,++
	ld l,e
++
	ld c,l
	ld hl,w1ReservedItemE.var31
	call setShortPosition_paramC

@doneCentering:
	ld e,Item.y
	ld hl,w1ReservedItemE.var30
	ld b,$04
	call copyMemory

	; Reverse link's direction
	ld hl,w1Link.direction
	ld a,(hl)
	xor $02
	ld (hl),a

	call itemIncSubstate
	call checkRelatedObject2States
	jr nc,+
	jr z,+
	ld (hl),$02
+
	jr @updateOtherPositions

@data:
	.db $10 $ff $f0 $01

; Update the positions (mainly z positions) for Link and the object being hooked.
@updateOtherPositions:
	; Update other object position if hooked to an enemy
	call checkRelatedObject2States
	call nz,objectCopyPosition

	; Update the Z position that w1ReservedItemE is keeping track of
	push de
	ld e,Item.zh
	ld a,(de)
	ld de,w1ReservedItemE.var3b
	ld (de),a

	; Update link's position
	ld hl,w1Link.y
	ld e,<w1ReservedItemE.var36
	ld b,$06
	call copyMemoryReverse
	pop de
	ret

; Substate 3: Link and the other object are moving back to the ground
@s3subState3:
	ld h,d

	; Lower 1 pixel
	ld l,Item.zh
	inc (hl)
	call @updateOtherPositions

	; Return if link and the item haven't reached the ground yet
	ld e,Item.zh
	ld a,(de)
	or a
	ret nz

	call checkRelatedObject2States
	jr nz,@reenableEnemy

	; For tile collisions, check whether to make the interaction which shows it
	; breaking, or whether to keep the switch hook diamond there

	call objectGetTileCollisions
	call checkCanPlaceDiamondOnTile
	jr nz,+

	; If the current block is the switch diamond, do NOT break it
	ld c,l
	ld e,Item.var3d
	ld a,(de)
	cp TILEINDEX_SWITCH_DIAMOND
	jr nz,+

	call setTile
	jr @delete
+
	; Create the bush/pot/etc breakage animation (based on var03)
	callab bank6.itemMakeInteractionForBreakableTile
	jr @delete

@reenableEnemy:
	ld (hl),$03
@delete:
	xor a
	ld (wSwitchHookState),a
	ld (wDisableLinkCollisionsAndMenu),a
	jp itemDelete

;;
; This function is used for the switch hook.
;
; @param[out]	hl	Related object 2's substate variable
; @param[out]	zflag	Set if latched onto a tile, not an object
; @param[out]	cflag	Unset if the related object is on state 3, substate 3?
checkRelatedObject2States:
	; Jump if latched onto a tile, not an object
	ld e,Item.subid
	ld a,(de)
	dec a
	jr z,++

	; It might be assuming that there aren't any states above $03, so the carry flag
	; will always be set when returning here?
	ld a,Object.state
	call objectGetRelatedObject2Var
	ldi a,(hl)
	cp $03
	ret nz

	ld a,(hl)
	cp $03
	ret nc

	or d
++
	scf
	ret

;;
; Plays the switch hook sound every 4 frames.
updateSwitchHookSound:
	ld e,Item.counter1
	ld a,(de)
	and $03
	ret z

	ld a,SND_SWITCH_HOOK
	jp playSound

;;
; @param l Position to check
; @param[out] zflag Set if the tile at l has a collision value of 0 (or is the somaria
; block?)
checkCanPlaceDiamondOnTile:
	ld h,>wRoomCollisions
	ld a,(hl)
	or a
	ret z
	ld h,>wRoomLayout
	ld a,(hl)
	cp TILEINDEX_SOMARIA_BLOCK
	ret


;;
; ITEM_SWITCH_HOOK_HELPER
; Used with the switch hook in w1ReservedItemE to store position values.
itemCode09:
	ld h,d
	ld l,Item.var2f
	bit 5,(hl)
	jr nz,@state2

	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

; Initialization (initial copying of positions)
@state0:
	call itemIncState
	ld h,d

	; Copy from Item.y to Item.var30
	ld l,Item.y
	ld e,Item.var30
	ld b,$06
	call copyMemory

	; Copy from w1Link.y to Item.var36
	ld hl,w1Link.y
	ld b,$06
	call copyMemory

	; Set the focused object to this
	jp setCameraFocusedObject

; State 1: do nothing until the switch hook is no longer in use, then delete self
@state1:
	ld a,(w1WeaponItem.id)
	cp ITEM_SWITCH_HOOK
	ret z

; State 2: Restore camera to focusing on Link and delete self
@state2:
	call setCameraFocusedObjectToLink
	jp itemDelete

;;
; Unused?
func_5af5:
	ld hl,w1ReservedItemE
	bit 0,(hl)
	ret z
	ld l,Item.var2f
	set 5,(hl)
	ret
