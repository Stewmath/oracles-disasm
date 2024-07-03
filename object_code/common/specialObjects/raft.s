;;
specialObjectCode_raft:
	ld a,d
	ld (wLinkRidingObject),a
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	callab bank5.specialObjectSetOamVariables
	xor a
	call specialObjectSetAnimation
	call itemIncState

	ld l,SpecialObject.collisionType
	ld a,$80|ITEMCOLLISION_LINK
	ldi (hl),a

	; collisionRadiusY/X
	inc l
	ld a,$06
	ldi (hl),a
	ldi (hl),a

	ld l,SpecialObject.counter1
	ld (hl),$0c

	ld a,d
	ld (wLinkObjectIndex),a
	call setCameraFocusedObjectToLink
	jp @saveRaftPosition


; State 1: riding the raft
@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call retIfTextIsActive
	ld a,(wScrollMode)
	and $0e
	ret nz
	ld a,(wDisabledObjects)
	and $81
	ret nz

	ld a,(wLinkForceState)
	cp LINK_STATE_RESPAWNING
	jr z,@respawning
	ld a,(w1Link.state)
	cp LINK_STATE_RESPAWNING
	jr nz,++

@respawning:
	ld hl,wLinkLocalRespawnY
	ld e,SpecialObject.yh
	ldi a,(hl)
	ld (de),a
	ld e,SpecialObject.xh
	ldi a,(hl)
	ld (de),a
	jp objectSetInvisible

++
	; Update direction; if changed, re-initialize animation
	call updateCompanionDirectionFromAngle
	jr c,+
	call specialObjectAnimate
	jr ++
+
	call specialObjectSetAnimation
++
	call @raftCalculateAdjacentWallsBitset
	call @transferKnockbackToLink
	ld hl,w1Link.knockbackCounter
	ld a,(hl)
	or a
	jr z,@updateMovement

	; Experiencing knockback; decrement counter, apply knockback speed
	dec (hl)
	dec l
	ld c,(hl)
	ld b,SPEED_100
	callab bank5.specialObjectUpdatePositionGivenVelocity

	ld a,$88
	ld (wcc92),a
	jr @notDismounting

@updateMovement:
	ld e,SpecialObject.speed
	ld a,SPEED_e0
	ld (de),a

	ld e,SpecialObject.angle
	ld a,(wLinkAngle)
	ld (de),a
	bit 7,a
	jr nz,@notDismounting
	ld a,(wLinkImmobilized)
	or a
	jr nz,@notDismounting

	callab bank5.specialObjectUpdatePosition
	ld a,c
	or a
	jr z,@positionUnchanged

	ld a,$08
	ld (wcc92),a


	; If not dismounting this frame, reset 'dismounting angle' (var3e) and
	; 'dismounting counter' (var3f).
@notDismounting:
	ld h,d
	ld l,SpecialObject.var3e
	ld a,$ff
	ldi (hl),a

	; [var3f] = $04
	ld (hl),$04
	ret


	; If position is unchanged, check whether to dismount
@positionUnchanged:
	; Return if "dismount angle" changed from before
	ld h,d
	ld e,SpecialObject.angle
	ld a,(de)
	ld l,SpecialObject.var3e
	cp (hl)
	ldi (hl),a
	ret nz

	; [var3f]--
	dec (hl)
	ret nz

	; Get angle from var3e
	dec e
	ld a,(de)
	ld hl,@dismountTileOffsets
	rst_addDoubleIndex

	; Get Y/X offset from this object in 'bc'
	ldi a,(hl)
	ld c,(hl)
	ld h,d
	ld l,SpecialObject.yh
	add (hl)
	ld b,a
	ld l,SpecialObject.xh
	ld a,(hl)
	add c
	ld c,a

	; If Link can walk on the adjacent tile, check whether to dismount
	call getTileAtPosition
	ld h,>wRoomCollisions
	ld a,(hl)
	or a
	jr z,@checkDismount
	cp SPECIALCOLLISION_STAIRS
	jr nz,@notDismounting

@checkDismount:
	callab bank5.calculateAdjacentWallsBitset
	ldh a,(<hFF8B)
	or a
	jr nz,@notDismounting

.ifdef REGION_JP
	ld e,SpecialObject.enabled
	inc a
	ld (de),a
.else
	inc a
	ld (wMenuDisabled),a
.endif
	; Force Link to walk for 14 frames
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,14
	ld (wLinkStateParameter),a

	; Update angle; copy direction + angle to Link
	call itemUpdateAngle
	ld e,l
	ld h,>w1Link
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a

	; Link is no longer riding the raft, set object index to $d0
	ld a,h
	ld (wLinkObjectIndex),a

	call setCameraFocusedObjectToLink
	call itemIncState
	jr @saveRaftPosition


; These are offsets from the raft's position at which to check whether the tile there can
; be dismounted onto. (the only requirement is that it's non-solid.)
@dismountTileOffsets:
	.db $f7 $00 ; DIR_UP
	.db $fd $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $fd $f7 ; DIR_LEFT


; State 2: started dismounting
@state2:
	ld a,$80
	ld (wcc92),a
	call itemDecCounter1
	ret nz

.ifndef REGION_JP
	xor a
	ld (wMenuDisabled),a
	ld e,SpecialObject.enabled
	inc a
	ld (de),a
.endif

	call updateLinkLocalRespawnPosition
	call itemIncState


; State 3: replace self with raft interaction
@state3:
	ldbc INTERAC_RAFT, $02
	call objectCreateInteraction
	ret nz
	ld e,SpecialObject.direction
	ld a,(de)
	ld l,Interaction.direction
	ld (hl),a
	jp itemDelete

;;
@saveRaftPosition:
	ld bc,wLastAnimalMountPointY
	ld h,d
	ld l,SpecialObject.yh
	ldi a,(hl)
	ld (bc),a
	inc c
	inc l
	ld a,(hl)
	ld (bc),a
	jpab bank5.saveLinkLocalRespawnAndCompanionPosition

;;
; Calculates the "adjacent walls bitset" for the raft specifically, treating everything as
; solid except for water tiles.
;
@raftCalculateAdjacentWallsBitset:
	ld a,$01
	ldh (<hFF8B),a
	ld hl,@@wallPositionOffsets
--
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	push hl
	call objectGetRelativeTile
	or a
	jr z,+
	ld e,a
	ld hl,@@validTiles
	call findByteAtHl
	ccf
+
	pop hl
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,--

	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
	ret

; Offsets at which to check for solid walls (8 positions to check)
@@wallPositionOffsets:
	.db $fa $fb
	.db $fa $04
	.db $05 $fb
	.db $05 $04
	.db $fb $fa
	.db $04 $fa
	.db $fb $05
	.db $04 $05


; A list of tiles that the raft may cross.
@@validTiles:
	.db TILEINDEX_DEEP_WATER
	.db TILEINDEX_CURRENT_UP
	.db TILEINDEX_CURRENT_DOWN
	.db TILEINDEX_CURRENT_LEFT
	.db TILEINDEX_CURRENT_RIGHT
	.db TILEINDEX_WATER
	.db TILEINDEX_WHIRLPOOL
	.db $00


;;
@transferKnockbackToLink:
	; Check Link's invincibilityCounter and var2a
	ld hl,w1Link.invincibilityCounter
	ldd a,(hl)
	or (hl)
	jr nz,@@end

	; Ret if raft's var2a is zero
	ld e,l
	ld a,(de)
	or a
	ret z

	; Transfer raft's var2a, invincibilityCounter, knockbackCounter, knockbackAngle,
	; and damageToApply to Link.
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a
	ld e,SpecialObject.damageToApply
	ld a,(de)
	ld l,e
	ld (hl),a

@@end:
	; Clear raft's invincibilityCounter and var2a
	ld e,SpecialObject.var2a
	xor a
	ld (de),a
	inc e
	ld (de),a
	ret
