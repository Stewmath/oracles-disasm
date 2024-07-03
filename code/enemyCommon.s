; This code is included at the start of every enemy code bank (banks $0d-$10, inclusive). 
;
; Although the function names are the same in each bank, they won't cause conflicts
; because each bank is in its own namespace.
;
; Function names are prefixed with "ecom" to show they come from here.

;;
ecom_incState:
	ld h,d
	ld l,Enemy.state
	inc (hl)
	ret

;;
ecom_incSubstate:
	ld h,d
	ld l,Enemy.substate
	inc (hl)
	ret

;;
; Update knockback where solid tiles are defined "normally".
ecom_updateKnockback:
	xor a
	ld e,Enemy.knockbackAngle
	call ecom_getSideviewAdjacentWallsBitsetGivenAngle

ecom_updateKnockback_common:
	ld a,(de)
	ld c,a
	ld e,Enemy.knockbackCounter
	ld a,(de)
	rlca

	; Speed is 200 or 300 based on knockback duration
	ld b,SPEED_200
	jr nc,++

	ld b,SPEED_300
	and $06
	jr nz,++

	; Create "dust" if bit 7 of Enemy.knockbackCounter is set
	push bc
	ldbc INTERACID_FALLDOWNHOLE, $01
	call objectCreateInteraction
	pop bc
++
	call ecom_applyGivenVelocityGivenAdjacentWalls
	ret nz

	; Enemy stopped moving; stop knockback early.
	ld e,Enemy.knockbackCounter
	ld a,(de)
	and $80
	ld (de),a
	ret

;;
; Update knockback where the enemy can pass through anything except the screen boundary.
ecom_updateKnockbackNoSolidity:
	ld a,$02
	ld e,Enemy.knockbackAngle
	call ecom_getSideviewAdjacentWallsBitsetGivenAngle
	jr ecom_updateKnockback_common

;;
ecom_updateKnockbackAndCheckHazardsNoAnimationsForHoles:
	call ecom_updateKnockback
	call ecom_checkHazardsNoAnimationForHoles
	ret

;;
; Like "ecom_checkHazards", but the enemy doesn't animate when they fall into a hole.
; That is, they just get stuck on the last frame of their animation as they get sucked in.
ecom_checkHazardsNoAnimationForHoles:
	ldh (<hFF8F),a
	xor a
	ldh (<hFF8D),a
	jr ecom_checkHazardsCommon

;;
; Standard implementation of "enemy experiencing knockback" state?
; Also, doesn't "return from caller" if it fell in a hazard since it calls the
; "ecom_checkHazards" function instead of jumping to it.
ecom_updateKnockbackAndCheckHazards:
	call ecom_updateKnockback
	call ecom_checkHazards
	ret

;;
; Checks whether the enemy falls into any hazards, and does the appropriate reaction if
; so.
;
; If the enemy falls in a hazard, this function will discard its return address to skip
; whatever remains in the caller.
;
; @param	a	Returned 'c' value from enemyStandardUpdate
; @param[out]	zflag	z if returned 'a' is 0
; @param[out]	a	Same as passed in
ecom_checkHazards:
	ldh (<hFF8F),a
	ld a,$01
	ldh (<hFF8D),a

ecom_checkHazardsCommon:
	; If already touched a hazard, skip the checks below
	ld e,Enemy.var3f
	ld a,(de)
	and $07
	jr nz,@applyHazardEffect

	; Return if enemy is in midair
	ld e,Enemy.zh
	ld a,(de)
	rlca
	jr c,@ret

	; Check if it touched a hazard
	ld bc,$05ff
	call objectGetRelativeTile
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	ld b,$ff
	jr c,@touchedHazard

	ld bc,$0501
	call objectGetRelativeTile
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	ld b,$01
	jr c,@touchedHazard

	call ecom_updateMovingPlatform

@ret:
	ldh a,(<hFF8F)
	or a
	ret

@touchedHazard:
	ld h,d
	ld l,Enemy.var3f
	ld e,l
	or (hl)
	ld (hl),a
	ld l,Enemy.invincibilityCounter
	ld (hl),$00
	ld l,Enemy.knockbackCounter
	ld (hl),$00

	; Disable collisions
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.counter1
	ld (hl),60
	inc l
	ldh a,(<hFF8D)
	ld (hl),a ; [Enemy.counter2] = [hFF8D]

	ld l,Enemy.xh
	ld a,(hl)
	add b
	ld (hl),a

@applyHazardEffect:
	pop hl ; Discard return address (this enemy is about to be be deleted)
	ld a,(de)
	rrca
	jr c,ecom_makeSplashAndDelete
	rrca
	jr c,ecom_fallingInHole
	jr ecom_makeLavaSplashAndDelete

.include {"{GAME_DATA_DIR}/tileProperties/conveyorEnemyTiles.s"}


ecom_makeSplashAndDelete:
	ld b,INTERACID_SPLASH
	jr ++

ecom_makeLavaSplashAndDelete:
	ld b,INTERACID_LAVASPLASH
++
	call objectCreateInteractionWithSubid00

ecom_decNumEnemiesAndDelete:
	call decNumEnemies
	jp enemyDelete

ecom_fallDownHoleAndDelete:
	call objectCreateFallingDownHoleInteraction
	jr ecom_decNumEnemiesAndDelete


;;
; Enemy is currently falling down a hole.
ecom_fallingInHole:
	call ecom_decCounter1
	jr z,ecom_fallDownHoleAndDelete

	ld a,(hl) ; a = [Enemy.counter1]
	and $07
	jr nz,++

	; Every 8 frames, move a half pixel closer to the hole.
	call @checkInCenterOfHole
	jr z,ecom_fallDownHoleAndDelete

	call objectGetRelativeAngleWithTempVars
	ld c,a
	ld b,SPEED_80
	call ecom_applyGivenVelocity
++
	; If bit 0 of counter2 is set, animate the enemy as it's being sucked toward the
	; hole.
	ld h,d
	ld l,Enemy.counter2
	bit 0,(hl)
	ret z
	ld l,Enemy.animCounter
	ld a,(hl)
	sub $03
	jr nc,+
	xor a
+
	inc a
	ld (hl),a
	jp enemyAnimate

;;
; @param[out]	zflag	z if enemy is in the center of the hole
@checkInCenterOfHole:
	ld l,Enemy.yh
	ldi a,(hl)
	ldh (<hFF8F),a
	add $05
	and $f0
	add $08
	ld b,a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	and $f0
	add $08
	ld c,a
	cp (hl)
	ret nz
	ldh a,(<hFF8F)
	cp b
	ret


;;
; Updates enemy's position if he's on a moving platform.
ecom_updateMovingPlatform:
	ld e,Enemy.zh
	ld a,(de)
	rlca
	ret c

	; Check if on a moving platform
	ld bc,$0500
	call objectGetRelativeTile
	ld hl,enemyConveyorTilesTable
	call lookupCollisionTable
	ret nc

	ld c,a
	ld b,SPEED_80

;;
; Move an object with normal collisions.
;
; TODO: Figure out what the difference between the two "adjacentWallOffset" tables is
;
; @param	b	Speed
; @param	c	Angle
; @param[out]	zflag	z if stopped
ecom_applyGivenVelocity:
	ld hl,ecom_sideviewAdjacentWallOffsetTable
	xor a
	ldh (<hFF8A),a
	push bc
	ld a,c
	call ecom_getAdjacentWallsBitset
	pop bc
	jr ecom_applyGivenVelocityGivenAdjacentWalls

;;
; Apply an enemies velocity, accounting for walls. Enemy should be the "top-down" type
; (see below).
;
; Note: ALL of these functions assume a 16x16 size enemy.
ecom_applyVelocityForTopDownEnemy:
	xor a
	call ecom_getTopDownAdjacentWallsBitset
	jr ecom_applyVelocityGivenAdjacentWalls

;;
; Same as above, but holes count as walls.
ecom_applyVelocityForTopDownEnemyNoHoles:
	ld a,$01
	call ecom_getTopDownAdjacentWallsBitset
	jr ecom_applyVelocityGivenAdjacentWalls

;;
; Like the above functions, but the enemy's collision box is slightly reduced for enemies
; which are drawn in "side-view".
;
; Example: Octoroks are viewed top-down, while moblins are drawn in side-view. Moblins
; would use this function, while octoroks would use the one above.
;
; In this context, side-view DOES NOT refer to the rooms that are done in side-view, only
; to how the enemies are drawn.
;
; None of this has any effect on their collision boxes with other sprites, though - it's
; only for the terrain?
ecom_applyVelocityForSideviewEnemy:
	xor a
	jr ++

;;
ecom_applyVelocityForSideviewEnemyNoHoles:
	ld a,$01
++
	call ecom_getSideviewAdjacentWallsBitset

;;
; @param	de	Enemy's angle value
; @param	hFF8B	Collision bitset
ecom_applyVelocityGivenAdjacentWalls:
	ld a,(de)
	ld c,a
	ld e,Enemy.speed
	ld a,(de)
	ld b,a

;;
; Applies the given speed and angle, while checking for collisions; this also accounts for
; "sliding" if, say, only the bottom half of the enemy touches the wall. Then the enemy
; will slide up so it can clear the tile.
;
; @param	hFF8B	Collision bitset
; @param	b	Speed
; @param	c	Angle
; @param[out]	zflag	nz if the enemy moved at least the equivalent of 1 pixel
ecom_applyGivenVelocityGivenAdjacentWalls:
	ld a,c
	ldh (<hFF8C),a
	call getPositionOffsetForVelocity

	xor a
	ldh (<hFF8D),a

@updateY:
	ld e,Enemy.y
	ldh a,(<hFF8B)
	and $0c
	jr nz,@checkSlideY

	call @applySpeedComponent
	jr @updateX

@checkSlideY:
	cp $0c
	jr z,@updateX
	bit 3,a
	ldh a,(<hFF8C)
	ld bc,$0060
	jr nz,++
	xor $10
	ld bc,-$60
++
	cp $11
	jr nc,@updateX

	ld e,Enemy.x
	ld a,(de)
	add c
	ld (de),a
	inc e
	ld a,(de)
	adc b
	ld (de),a
	ld e,Enemy.speed
	ld a,(de)
	cp SPEED_140
	jr nc,@updateX

	ld a,$01
	ldh (<hFF8D),a

@updateX:
	ld e,Enemy.x
	ld l,<wTmpcfc0+2
	ldh a,(<hFF8B)
	and $03
	jr nz,@checkSlideX
	call @applySpeedComponent
	jr @ret

@checkSlideX:
	cp $03
	jr z,@ret
	rrca
	ldh a,(<hFF8C)
	ld bc,$0060
	jr nc,++
	sub $10
	ld bc,-$60
++
	add $08
	and $1f
	cp $11
	jr nc,@ret

	ld e,Enemy.y
	ld a,(de)
	add c
	ld (de),a
	inc e
	ld a,(de)
	adc b
	ld (de),a

	ld e,Enemy.speed
	ld a,(de)
	cp SPEED_140
	jr nc,@ret

	ld a,$01
	ldh (<hFF8D),a

@ret:
	ldh a,(<hFF8D)
	or a
	ret

;;
; Writes something to hFF8D (nonzero if moved at least one pixel?)
;
; @param	de	Enemy.x or Enemy.y
; @param	hl	Speed component (from "getPositionOffsetForVelocity" call)
@applySpeedComponent:
	ld a,(de)
	add (hl)
	ld (de),a

	ld b,(hl)
	inc l
	inc e
	ld a,(de)
	ld c,a
	adc (hl)
	ld (de),a

	sub c
	jr nz,++

	ld c,$20
	ld e,Enemy.speed
	ld a,(de)
	cp SPEED_140
	jr c,+
	ld c,$60
+
	ld a,b
	cp c
	ret c
++
	ldh (<hFF8D),a
	ret


;;
; Unused?
; @param	a	Value for hFF8A (see below)
; @param	de	Pointer to Enemy.angle?
ecom_getTopDownAdjacentWallsBitsetGivenAngle:
	ld hl,ecom_topDownAdjacentWallOffsetTable
	jr ecom_getAdjacentWallsBitset

;;
; @param	a	Value for hFF8A (see below)
ecom_getTopDownAdjacentWallsBitset:
	ld e,Enemy.angle
	ld hl,ecom_topDownAdjacentWallOffsetTable
	jr label_025

;;
; @param	a	Value for hFF8A (see below)
ecom_getSideviewAdjacentWallsBitset:
	ld e,Enemy.angle

;;
; @param	a	Value for hFF8A (see below)
; @param	de	Pointer to Enemy.angle?
ecom_getSideviewAdjacentWallsBitsetGivenAngle:
	ld hl,ecom_sideviewAdjacentWallOffsetTable
label_025:
	ldh (<hFF8A),a
	ld a,(de)

;;
; Calculates a bitset of adjacent walls, just like SpecialObject's "adjacentWallsBitset".
; Each of the 8 bits corresponds to a wall in some direction relative to the enemy.
;
; @param	a
; @param	hl	Table to use?
; @param	hFF8A	0: Do a normal collision check (solid tiles & screen boundaries).
;			1: Same as 0, but holes also count as walls.
;			2+: Only screen boundaries count as walls.
; @param[out]	a,hFF8B	Bitset of adjacent walls
; @param[out]	zflag	nz if it's touching at least one wall (in the direction it's
;			moving toward?)
ecom_getAdjacentWallsBitset:
	push de
	call ecom_getAdjacentWallTableOffset
	ld b,d
	rst_addAToHl
	ld d,h
	ld e,l
	ld h,b
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	ld a,$10
	ldh (<hFF8B),a
--
	call @checkCollisionAt
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,--

	pop de
	or a
	ret

;;
; @param	bc	Position offset to check
; @param	de	Pointer to Enemy.y
; @param	hFF8A	Type of collision check to do (values explained above)
; @param[out]	cflag	c if there's a collision
@checkCollisionAt:
	ld a,(de)
	inc de
	add b
	ld b,a
	ld a,(de)
	inc de
	add c
	ld c,a

	ldh a,(<hFF8A)
	dec a

	; hFF8A == 1 (holes count as walls)
	jp z,checkTileCollisionAt_disallowHoles
	inc a
	jr z,++

	; hFF8A == 2 or higher (only screen boundaries count as walls; checking for
	; SPECIALCOLLISION_SCREEN_BOUNDARY ($ff).)
	call getTileCollisionsAtPosition
	add $01
	ret
++
	; hFF8A == 0 (normal collision check)
	call getTileCollisionsAtPosition
	add $01
	jp nc,checkTileCollisionAt_allowHoles
	ret

;;
; Given an angle this returns an offset within the position offset table to use.
;
; This seems to be just (angle/4)*8, with some particular kind of rounding...
;
; @param	a	Angle
; @param[out]	a	Offset into table to use
ecom_getAdjacentWallTableOffset:
	rlca
	ld b,a
	and $0f
	ld a,b
	ret z
	and $f0
	add $08
	ret


; For enemies drawn in "side" view (ie. moblins). Smaller bounding box.
;
; NOTE: The game isn't even consistent about this. Octoroks use the "topdown" table when
; moving, but the "sideview" table for knockback, as an example.
;
ecom_sideviewAdjacentWallOffsetTable:
	; Up
	.db $fc $fb
	.db $00 $09
	.db $04 $fc
	.db $00 $00

	; Up/right
	.db $fc $fb
	.db $00 $09
	.db $03 $02
	.db $06 $00

	; Right
	.db $00 $00
	.db $00 $00
	.db $ff $06
	.db $06 $00

	; Right/down
	.db $07 $fb
	.db $00 $09
	.db $f8 $02
	.db $06 $00

	; Down
	.db $07 $fb
	.db $00 $09
	.db $f9 $fc
	.db $00 $00

	; Down/left
	.db $07 $fb
	.db $00 $09
	.db $f8 $f5
	.db $06 $00

	; Left
	.db $00 $00
	.db $00 $00
	.db $ff $f9
	.db $06 $00

	; Up/left
	.db $fc $fb
	.db $00 $09
	.db $03 $f5
	.db $06 $00

; For enemies drawn in "top-down" view (ie. octoroks). Larger, more strict bounding box.
ecom_topDownAdjacentWallOffsetTable:
	; Up
	.db $f7 $fa
	.db $00 $0b
	.db $09 $fb
	.db $00 $00

	; Up/right
	.db $f7 $fc
	.db $00 $0a
	.db $02 $02
	.db $0a $00

	; Right
	.db $00 $00
	.db $00 $00
	.db $fa $08
	.db $0b $00

	; Right/down
	.db $08 $fc
	.db $00 $0a
	.db $f4 $02
	.db $0a $00

	; Down
	.db $08 $fa
	.db $00 $0b
	.db $f8 $fb
	.db $00 $00

	; Down/left
	.db $08 $f9
	.db $00 $0a
	.db $f4 $f4
	.db $0a $00

	; Left
	.db $00 $00
	.db $00 $00
	.db $fa $f7
	.db $0b $00

	; Up/left
	.db $f7 $f9
	.db $00 $0a
	.db $02 $f4
	.db $0a $00

;;
; Like below, but including walls and holes.
ecom_bounceOffWallsAndHoles:
	ld a,$01
	jr ++

;;
; Like below, but including walls.
ecom_bounceOffWalls:
	xor a
	jr ++

;;
; When an enemy hits a screen boundary, its angle is updated to "bounce" off it.
ecom_bounceOffScreenBoundary:
	ld a,$02
++
	call ecom_getSideviewAdjacentWallsBitset
	call @getDirectionsHit
	ld a,c
	or a
	ret z
	cp $05
	jr z,@reverseDirection

	ld hl,@angleTable+$10
	bit 0,a
	jr nz,+
	ld hl,@angleTable
+
	ld e,Enemy.angle
	ld a,(de)
	rst_addAToHl
	ld a,(hl)
	ld (de),a
	or d
	ret

@reverseDirection:
	; Hit both horizontal and vertical wall at the same time
	ld e,Enemy.angle
	ld a,(de)
	add $10
	and $1f
	ld (de),a
	or d
	ret

;;
; @param	a	Adjacent walls bitset
; @param[out]	c	Bits 0,2 set if horizontal, vertical wall bits are set.
@getDirectionsHit:
	ld c,$00
	ld b,a
	and $03
	jr z,+
	inc c
+
	ld a,b
	and $0c
	ret z
	set 2,c
	ret

@angleTable:
	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01

	.db $00 $1f $1e $1d $1c $1b $1a $19
	.db $18 $17 $16 $15 $14 $13 $12 $11

	.db $10 $0f $0e $0d $0c $0b $09 $08
	.db $08 $07 $06 $05 $04 $03 $02 $01

;;
; ANDs 'b', 'c', and 'e' with random values.
; @param[out]	a	Zero
ecom_randomBitwiseAndBCE:
	push bc
	call getRandomNumber_noPreserveVars
	pop bc
	and e
	ld e,a
	ld a,h
	and b
	ld b,a
	ld a,l
	and c
	ld c,a
	xor a
	ret

;;
; Sets the enemy's speed to given value, sets state to 8, and makes the enemy visible.
;
; @param	a	Speed
; @param[out]	hl	Enemy.state
ecom_setSpeedAndState8AndVisible:
	call ecom_setSpeedAndState8
	jp objectSetVisiblec2

;;
; @param	a	Speed
; @param[out]	hl	Enemy.state
ecom_setSpeedAndState8:
	ld h,d
	ld l,Enemy.speed
	ld (hl),a
	ld l,Enemy.state
	ld (hl),$08
	ret

;;
; @param	b	Enemy type
; @param[out]	hl	Enemy.subid
; @param[out]	zflag	z if successfully spawned
ecom_spawnUncountedEnemyWithSubid01:
	call getFreeEnemySlot_uncounted
	ret nz
	jr ++

;;
; @param	b	Enemy type
; @param[out]	a	$00 on success (but could be anything if not successful)
; @param[out]	hl	Enemy.subid
; @param[out]	zflag	z if successfully spawned
ecom_spawnEnemyWithSubid01:
	call getFreeEnemySlot
	ret nz
++
	ld (hl),b
	inc l
	inc (hl)
	xor a
	ret

;;
; Spawns a "part" which is probably a projectile for the enemy. It inherits the enemy's
; position and angle, the part's "relatedObj1" variable is set to point to the enemy, and
; the enemy's "relatedObj2" variable is set to point to the part.
;
; @param	b	Part ID
; @param[out]	zflag	z if spawned successfully
ecom_spawnProjectile:
	call getFreePartSlot
	ret nz

	ld (hl),b
	call objectCopyPosition

	ld l,Part.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld e,Enemy.relatedObj2
	ld a,Part.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Enemy.angle
	ld l,Part.angle
	ld a,(de)
	ldi (hl),a
	xor a
	ret

;;
; @param[out]	zflag	z if counter1 reached 0
ecom_decCounter1:
	ld h,d
	ld l,Enemy.counter1
	dec (hl)
	ret

;;
; Treats counter1 and counter2 as one 16-bit counter. (Unused?)
; @param[out]	zflag	z if counter reached 0
ecom_dec16BitCounter:
	call ecom_decCounter1
	ret nz

;;
; @param[out]	zflag
ecom_decCounter2:
	ld h,d
	ld l,Enemy.counter2
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

;;
; @param[out]	a	New angle
ecom_updateCardinalAngleAwayFromTarget:
	call objectGetAngleTowardEnemyTarget
	xor $10
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; Similar to below, but angle must be in a cardinal direction.
; @param[out]	a	New angle
ecom_updateCardinalAngleTowardTarget:
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; Sets the enemy's angle to face its target (usually Link).
; @param[out]	a	New angle
ecom_updateAngleTowardTarget:
	call objectGetAngleTowardEnemyTarget
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; @param[out]	a	New angle
ecom_setRandomCardinalAngle:
	call getRandomNumber_noPreserveVars
	and $18
	ld e,Enemy.angle
	ld (de),a
	ret

;;
ecom_setRandomAngle:
	call getRandomNumber_noPreserveVars
	and $1f
	ld e,Enemy.angle
	ld (de),a
	ret

;;
; Updates the enemy's animation based on its angle. Cardinal directions are animations 0-3,
; diagonals are 4-7?
;
; The current animation index is stored in "Enemy.direction".
;
ecom_updateAnimationFromAngle:
	ld h,d
	ld l,Enemy.angle
	ldd a,(hl)
	ld e,a
	ld bc,@angleToAnimIndex
	call addAToBc
	ld a,(bc)
	cp $04
	jr c,@setAnimation

	sub (hl)
	cp $07
	ret z
	sub $03
	cp $02
	ret c
	ld a,e
	add $04
	and $18
	swap a
	rlca

@setAnimation:
	cp (hl) ; hl == direction (actually stores animation index)
	ret z
	ld (hl),a
	jp enemySetAnimation

@angleToAnimIndex:
	.db $00 $00 $00 $04 $04 $04 $01 $01
	.db $01 $01 $01 $05 $05 $05 $02 $02
	.db $02 $02 $02 $06 $06 $06 $03 $03
	.db $03 $03 $03 $07 $07 $07 $00 $00

;;
ecom_flickerVisibility:
	ld e,Enemy.visible
	ld a,(de)
	xor $80
	ld (de),a
	ret

;;
; @param[out]	a	State
; @param[out]	b	Subid
; @param[out]	cflag	c if state < 8
ecom_getSubidAndCpStateTo08:
	ld e,Enemy.subid
	ld a,(de)
	ld b,a
	ld e,Enemy.state
	ld a,(de)
	cp $08
	ret

;;
; @param	bc	YX position to get the direction toward
; @param	hFF8E	X position of object
; @param	hFF8F	Y position of object
ecom_moveTowardPosition:
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
	jp objectApplySpeed

;;
; Call this just before calling "ecom_moveTowardPosition" above.
;
; @param	hl	Position to read into bc (angle to move toward)
; @param[out]	a	[Enemy.x]
; @param[out]	bc	Position read from hl
; @param[out]	hFF8F	[Enemy.y]
; @param[out]	hFF8E	[Enemy.x]
ecom_readPositionVars:
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,Enemy.yh
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	ret

.ifdef ROM_SEASONS

;;
; Moves toward Link?
; @param	a
; @param[out]	zflag
ecom_seasonsFunc_4446:
	ld b,a
	ld a,(wMagnetGloveState) ; TODO: figure out what this corresponds to in ages (if anything)
	or a
	ld a,b
	jp z,ecom_checkHazards

	ld h,d
	ld l,Enemy.var3f
	res 1,(hl)

	ld l,Enemy.collisionType
	set 7,(hl)

	push af
	call objectGetAngleTowardLink
	ld c,a
	ld b,SPEED_80
	call ecom_applyGivenVelocity

	pop af
	or a
	ret

.endif

;;
; Set the enemy's Z position such that it's just above the screen.
;
; @param	c	Extra offset to subtract from Z position (make it further beyond
;			the screen)
ecom_setZAboveScreen:
	ld h,d
	ld l,Enemy.yh
	ld a,(hl)
	add c
	cpl
	inc a
	ld c,a
	ldh a,(<hCameraY)
	add c
	jr nc,+
	ld a,c
+
	bit 7,a
	jr nz,+
	ld a,$80
+
	ld l,Enemy.zh
	ld (hl),a
	ret

;;
; @param	h	Object index
; @param	l	Object type
ecom_killObjectH:
	ld a,l
	and $c0
	or Object.health
	ld l,a

;;
; Sets an object's health to zero, disables their collisions.
;
; @param	hl	Pointer to object's health value
ecom_killRelatedObj:
	ld (hl),$00
	ld a,l
	add Object.collisionType - Object.health
	ld l,a
	res 7,(hl)
	ret

;;
ecom_killRelatedObj1:
	ld a,Object.health
	call objectGetRelatedObject1Var
	jr ecom_killRelatedObj

;;
ecom_killRelatedObj2:
	ld a,Object.health
	call objectGetRelatedObject2Var
	jr ecom_killRelatedObj

;;
; Enemy shakes horizontally until counter2 reaches 0, then flies up above the screen.
;
; @param[out]	cflag	c if gale seed effect still persists, nc otherwise
ecom_galeSeedEffect:
	call ecom_decCounter2
	jr z,@zero

	ld a,(hl)
	and $03
	ld hl,@oscillationX
	rst_addAToHl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld (de),a
	scf
	ret

@zero:
	call objectApplySpeed
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ldh a,(<hCameraY)
	ld b,a
	ld l,Enemy.zh
	ld a,(hl)
	cp $80
	ccf
	ret nc
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	sub b
	cp LARGE_ROOM_HEIGHT<<4
	ret

@oscillationX:
	.db $fe $02 $02 $fe

;;
; Common implementation of "blown away by gale seed" state; enemy gets caught in the
; tornado and flies away, then gets deleted.
ecom_blownByGaleSeedState:
	call ecom_galeSeedEffect
	ret c
	call decNumEnemies
	jp enemyDelete

;;
; If a scent seed is active, and this enemy should respond to it, this sets its state to
; 4.
ecom_checkScentSeedActive:
	ld a,(wScentSeedActive)
	or a
	ret z
	ld e,Enemy.var3f
	ld a,(de)
	bit 4,a
	ret z

	ld e,Enemy.state
	ld a,(de)
	and $f8
	ret z
	ld a,$04
	ld (de),a
	ret

;;
; Every 16 frames, this function updates the enemy's angle relative to a scent seed
; (position in hFFB2/hFFB3). Uses Enemy.var3d as a counter for this.
ecom_updateAngleToScentSeed:
	ld h,d
	ld l,Enemy.var3d
	dec (hl)
	ld a,(hl)
	and $0f
	ret nz

	ldh a,(<hFFB2)
	ld b,a
	ldh a,(<hFFB3)
	ld c,a
	call objectGetRelativeAngle
	ld e,Enemy.angle
	ld (de),a
	ret

;;
ecom_fallToGroundAndSetState8:
	ld b,$08

;;
; Updates gravity for an enemy, and changes its state when it lands.
;
; @param	b	State to change to upon landing
; @param[out]	zflag	z if the enemy is on the ground
ecom_fallToGroundAndSetState:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.state
	ld (hl),b
	ret
