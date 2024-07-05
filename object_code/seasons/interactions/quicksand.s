; ==================================================================================================
; INTERAC_QUICKSAND
; ==================================================================================================
interactionCode5e:
	call returnIfScrollMode01Unset
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
@state1:
	ld a,$21
	call objectSetCollideRadius
	call _findItemDropAddress
	call _findPirateSkullAddress
	call _findBombOrScentSeedAddress
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	ld a,(w1Link.zh)
	or a
	ret nz
	ld bc,$2105
	call @checkLinkWithinAPartOfQuicksand
	ret nc
	ld a,QUICKSAND_RING
	call cpActiveRing
	jr z,+
	call objectGetAngleTowardLink
	xor ANGLE_DOWN
	ld c,a
	ld b,$14
	call updateLinkPositionGivenVelocity
+
	call _matchSkullNumberWithSubid
	ld bc,$0300
	call @checkLinkWithinAPartOfQuicksand
	ret nc
; If subid $00, respawn Link
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld a,$01
	jr z,@respawnLink
; Initiate warp
	call dropLinkHeldItem
	call clearAllParentItems
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
; Puts bit 7 (subid matched) into counter2
	ld a,(wPirateSkullRandomNumber)
	and $7f
	ld l,Interaction.counter2
	ldd (hl),a ; Interaction.counter1
	ld (hl),60
	ld a,$03
@respawnLink:
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_RESPAWNING
	ld (wLinkForceState),a
	ld hl,w1Link.yh
	jp objectCopyPosition
@state2:
	xor a
	ld (wPirateSkullRandomNumber),a
	call interactionDecCounter1
	ret nz
; c is destination index
	ld c,$03
; If subid is $05, skip to warp
	ld l,Interaction.subid
	ld a,(hl)
	cp $05
	jr z,+
	dec c
; If subid matched wPirateSkullRandomNumber, choose index $02
	ld e,Interaction.counter2
	ld a,(de)
	cp (hl)
	jr z,+
; Pseudo-randomly choose either $00 or $01
	ld a,(wFrameCounter)
	and $01
	ld c,a
+
	ld a,c
	add a
	add c
	ld hl,@warpDestLocations
	rst_addAToHl
	ldi a,(hl)
	ld (wWarpDestGroup),a
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld (wWarpDestPos),a
	ld a,TRANSITION_DEST_FALL
	ld (wWarpTransition),a
; Fadeout
	ld a,$03
	ld (wWarpTransition2),a
	jp interactionDelete
@warpDestLocations:
	.db $80|(>ROOM_SEASONS_5d0), <ROOM_SEASONS_5d0, $57 ; has like likes
	.db $80|(>ROOM_SEASONS_5d1), <ROOM_SEASONS_5d1, $57 ; business scrub selling shield
	.db $80|(>ROOM_SEASONS_5d2), <ROOM_SEASONS_5d2, $57 ; pirate skull
	.db $80|(>ROOM_SEASONS_4f4), <ROOM_SEASONS_4f4, $27 ; leads to chest

; Param		b	Radius Y collision
; Param		c	Radius X collision
; Param[out]	cflag	Set if Link HAS collided
@checkLinkWithinAPartOfQuicksand:
	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),b
	inc l
	ld (hl),b
	ld a,(w1Link.yh)
	add c
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	jp interactionCheckContainsPoint

; Set bit 7 of wPirateSkullRandomNumber if that value and subid match
_matchSkullNumberWithSubid:
	ld hl,wPirateSkullRandomNumber
	ld a,(hl)
	or a
	ret z
	ld e,Interaction.subid
	ld a,(de)
	cp (hl)
	ret nz
	set 7,(hl)
	ret

; Checks for Pirate Skull, Bomb, Used Scent Seed, or Item Drop to pull into the center
_findPirateSkullAddress:
	ld c,INTERAC_PIRATE_SKULL
	call objectFindSameTypeObjectWithID
	ret nz
	ld l,Interaction.zh
	ld e,Interaction.var3a
	jr _moveObjectIfGrounded
_findItemDropAddress:
	ld h,$d0
-
	ld l,Part.id
	ld a,(hl)
	cp PART_ITEM_DROP
	call z,_objectIsPart
	inc h
	ld a,h
	cp $e0
	jr c,-
	ret

; Object is a part
_objectIsPart:
	ld l,Part.zh
	ld e,Part.var31

; Param     hl      Object.zh
; Param     e       Object's yh variable to tell it to move toward quicksand
_moveObjectIfGrounded:
; Checks if object is in the air
	ldd a,(hl)
	rlca
	ret c
	dec l
	ld c,(hl)		;Object.xh
	dec l
	dec l
	ld b,(hl)		;Object.yh
	ld l,e			;hl = Object.var3a or var31
	push hl
; Ret if object has not collided with quicksand
	call interactionCheckContainsPoint
	pop hl
	ret nc

	call objectGetPosition
	ld (hl),b
	inc l
	ld (hl),c
	ret

_findBombOrScentSeedAddress:
	ld c,ITEM_BOMB
	call findItemWithID
	call z,_objectIsItem
	ld c,ITEM_BOMB
	call findItemWithID_startingAfterH
	call z,_objectIsItem
	ld c,ITEM_SCENT_SEED
	call findItemWithID
	ret nz

; Object is an item
_objectIsItem:
	ld l,Item.zh
	ld e,Item.var31
	jr _moveObjectIfGrounded
