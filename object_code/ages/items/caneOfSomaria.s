;;
; ITEM_CANE_OF_SOMARIA
itemCode04:
	call itemTransferKnockbackToLink
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,UNCMP_GFXH_AGES_1c
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState

	ld a,SND_SWORDSLASH
	call playSound

	xor a
	call itemSetAnimation
	jp objectSetVisible82

@state1:
	; Wait for a particular part of the swing animation
	ld a,(w1ParentItem2.animParameter)
	cp $06
	ret nz

	call itemIncState

	ld c,ITEM_18
	call findItemWithID
	jr nz,+

	; Set var2f of any previous instance of ITEM_18 (triggers deletion?)
	ld l,Item.var2f
	set 5,(hl)
+
	; Get in bc the place to try to make a block
	ld a,(w1Link.direction)
	ld hl,@somariaCreationOffsets
	rst_addDoubleIndex
	ld a,(w1Link.yh)
	add (hl)
	ld b,a
	inc hl
	ld a,(w1Link.xh)
	add (hl)
	ld c,a

	call getFreeItemSlot
	ret nz
	inc (hl)
	inc l
	ld (hl),ITEM_18

	; Set Y/X of the new item as calculated earlier, and copy Link's Z position
	ld l,Item.yh
	ld (hl),b
	ld a,(w1Link.zh)
	ld l,Item.zh
	ldd (hl),a
	dec l
	ld (hl),c

@state2:
	ret

; Offsets relative to link's position to try to create a somaria block?
@somariaCreationOffsets:
	.dw $00ec ; DIR_UP
	.dw $1300 ; DIR_RIGHT
	.dw $0013 ; DIR_DOWN
	.dw $ec00 ; DIR_LEFT


;;
; ITEM_18 (somaria block object)
itemCode18:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4


; State 0: initialization
@state0:
	call itemMergeZPositionIfSidescrollingArea
	call @alignOnTile
	call itemLoadAttributesAndGraphics
	xor a
	call itemSetAnimation
	call itemIncState
	ld a,SND_MYSTERY_SEED
	call playSound
	jp objectSetVisible83


; State 1: phasing in
@state1:
	call @checkBlockCanAppear
	call z,@pushLinkAway

	; Wait for phase-in animation to complete
	call itemAnimate
	ld e,Item.animParameter
	ld a,(de)
	or a
	ret z

	; Animation done

	ld h,d
	ld l,Item.oamFlagsBackup
	ld a,$0d
	ldi (hl),a
	ldi (hl),a

	; Item.oamTileIndexBase
	ld (hl),$36

	; Enable collisions with enemies?
	ld l,Item.collisionType
	set 7,(hl)

@checkCreateBlock:
	call @checkBlockCanAppear
	jr nz,@deleteSelfWithPuff
	call @createBlockIfNotOnHazard
	jr nz,@deleteSelfWithPuff

	; Note: a = 0 here

	ld h,d
	ld l,Item.zh
	ld (hl),a

	; Set [state]=3, [substate]=0
	ld l,Item.substate
	ldd (hl),a
	ld (hl),$03

	ld l,Item.collisionRadiusY
	ld a,$04
	ldi (hl),a
	ldi (hl),a

	ld l,Item.var2f
	ld a,(hl)
	and $f0
	ld (hl),a

	ld a,$01
	jp itemSetAnimation


; State 4: block being pushed
@state4:
	ld e,Item.substate
	ld a,(de)
	rst_jumpTable

	.dw @state4Substate0
	.dw @state4Substate1

@state4Substate0:
	call itemIncSubstate
	call itemUpdateAngle

	; Set speed & counter1 based on bracelet level
	ldbc SPEED_80, $20
	ld a,(wBraceletLevel)
	cp $02
	jr nz,+
	ldbc SPEED_c0, $15
+
	ld l,Item.speed
	ld (hl),b
	ld l,Item.counter1
	ld (hl),c

	ld a,SND_MOVEBLOCK
	call playSound
	call @removeBlock

@state4Substate1:
	call itemUpdateDamageToApply
	jr c,@deleteSelfWithPuff
	call @checkDeletionTrigger
	jr nz,@deleteSelfWithPuff

	call objectApplySpeed
	call @pushLinkAway
	call itemDecCounter1

	ld l,Item.collisionRadiusY
	ld a,$04
	ldi (hl),a
	ld (hl),a

	; Return if counter1 is not 0
	ret nz

	jr @checkCreateBlock


@removeBlockAndDeleteSelfWithPuff:
	call @removeBlock
@deleteSelfWithPuff:
	ld h,d
	ld l,Item.var2f
	bit 4,(hl)
	call z,objectCreatePuff
@deleteSelf:
	jp itemDelete


; State 2: being picked up / thrown
@state2:
	ld e,Item.substate
	ld a,(de)
	rst_jumpTable

	.dw @state2Substate0
	.dw @state2Substate1
	.dw @state2Substate2
	.dw @state2Substate3

; Substate 0: just picked up
@state2Substate0:
	call itemIncSubstate
	call @removeBlock
	call objectSetVisiblec1
	ld a,$02
	jp itemSetAnimation

; Substate 1: being lifted
@state2Substate1:
	call itemUpdateDamageToApply
	ret nc
	call dropLinkHeldItem
	jr @deleteSelfWithPuff

; Substate 2/3: being thrown
@state2Substate2:
@state2Substate3:
	call objectCheckWithinRoomBoundary
	jr nc,@deleteSelf

	call bombUpdateThrowingLaterally
	call @checkDeletionTrigger
	jr nz,@deleteSelfWithPuff

	; var39 = gravity
	ld l,Item.var39
	ld c,(hl)
	call itemUpdateThrowingVerticallyAndCheckHazards
	jr c,@deleteSelf

	ret z
	jr @deleteSelfWithPuff


; State 3: block is just sitting around
@state3:
	call @checkBlockInPlace
	jr nz,@deleteSelfWithPuff

	; Check if health went below 0
	call itemUpdateDamageToApply
	jr c,@removeBlockAndDeleteSelfWithPuff

	; Check bit 5 of var2f (set when another somaria block is being created)
	call @checkDeletionTrigger
	jr nz,@removeBlockAndDeleteSelfWithPuff

	; If Link somehow ends up on this tile, delete the block
	ld a,(wActiveTilePos)
	ld l,Item.var32
	cp (hl)
	jr z,@removeBlockAndDeleteSelfWithPuff

	; If in a sidescrolling area, check that the tile below is solid
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr z,++

	ld a,(hl)
	add $10
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)
	cp $0f
	jr nz,@removeBlockAndDeleteSelfWithPuff
++
	ld l,Item.var2f
	bit 0,(hl)
	jp z,objectAddToGrabbableObjectBuffer

	; Link pushed on the block
	ld a,$04
	jp itemSetState

;;
; @param[out]	zflag	Unset if slated for deletion
@checkDeletionTrigger:
	ld h,d
	ld l,Item.var2f
	bit 5,(hl)
	ret

;;
@pushLinkAway:
	ld e,Item.collisionRadiusY
	ld a,$07
	ld (de),a
	ld hl,w1Link
	jp preventObjectHFromPassingObjectD

;;
; @param[out]	zflag	Set if the cane of somaria block is present, and is solid?
@checkBlockInPlace:
	ld e,Item.var32
	ld a,(de)
	ld l,a
	ld h,>wRoomLayout
	ld a,(hl)
	cp TILEINDEX_SOMARIA_BLOCK
	ret nz

	ld h,>wRoomCollisions
	ld a,(hl)
	cp $0f
	ret

;;
@removeBlock:
	call @checkBlockInPlace
	ret nz

	; Restore tile
	ld e,Item.var32
	ld a,(de)
	call getTileIndexFromRoomLayoutBuffer
	jp setTile

;;
; @param[out]	zflag	Set if the block can appear at this position
@checkBlockCanAppear:
	; Disallow cane of somaria usage if in patch's minigame room
	ld a,(wActiveGroup)
	cp >ROOM_AGES_5e8
	jr nz,+
	ld a,(wActiveRoom)
	cp <ROOM_AGES_5e8
	jr z,@@disallow
+
	; Must be close to the ground
	ld e,Item.zh
	ld a,(de)
	dec a
	cp $fc
	jr c,@@disallow

	; Can't be in a wall
	call objectGetTileCollisions
	ret nz

	; If underwater, never allow it
	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_UNDERWATER,a
	ret nz

	; If in a sidescrolling area, check for floor underneath
	and TILESETFLAG_SIDESCROLL
	ret z

	ld a,l
	add $10
	ld l,a
	ld a,(hl)
	cp $0f
	ret

@@disallow:
	or d
	ret

;;
; @param[out]	zflag	Set on success
@createBlockIfNotOnHazard:
	call @alignOnTile
	call objectGetTileAtPosition
	push hl
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	pop hl
	jr c,++

	; Overwrite the tile with the somaria block
	ld b,(hl)
	ld (hl),TILEINDEX_SOMARIA_BLOCK
	ld h,>wRoomCollisions
	ld (hl),$0f

	; Save the old value of the tile to w3RoomLayoutBuffer
	ld e,Item.var32
	ld a,l
	ld (de),a
	ld c,a
	call setTileInRoomLayoutBuffer
	xor a
	ret
++
	or d
	ret

@alignOnTile:
	call objectCenterOnTile
	ld l,Item.yh
	dec (hl)
	dec (hl)
	ret
