; This code is included at the start of every enemy code bank (banks $0d-$10, inclusive). 
;
; Although the function names are the same in each bank, they won't cause conflicts
; because each bank is in its own namespace.
;
; Function names are prefixed with "_ecom" to show they come from here.

;;
; @addr{4000}
_ecom_incState:
	ld h,d			; $4000
	ld l,Enemy.state		; $4001
	inc (hl)		; $4003
	ret			; $4004

;;
; @addr{4005}
_ecom_incState2:
	ld h,d			; $4005
	ld l,Enemy.state2		; $4006
	inc (hl)		; $4008
	ret			; $4009

;;
; Update knockback where solid tiles are defined "normally".
; @addr{400a}
_ecom_updateKnockback:
	xor a			; $400a
	ld e,Enemy.knockbackAngle		; $400b
	call _ecom_getSideviewAdjacentWallsBitsetGivenAngle		; $400d

_ecom_updateKnockback_common:
	ld a,(de)		; $4010
	ld c,a			; $4011
	ld e,Enemy.knockbackCounter		; $4012
	ld a,(de)		; $4014
	rlca			; $4015

	; Speed is 200 or 300 based on knockback duration
	ld b,SPEED_200		; $4016
	jr nc,++		; $4018

	ld b,SPEED_300		; $401a
	and $06			; $401c
	jr nz,++		; $401e

	; Create "dust" if bit 7 of Enemy.knockbackCounter is set
	push bc			; $4020
	ldbc INTERACID_FALLDOWNHOLE, $01		; $4021
	call objectCreateInteraction		; $4024
	pop bc			; $4027
++
	call _ecom_applyGivenVelocityGivenAdjacentWalls		; $4028
	ret nz			; $402b

	; Enemy stopped moving; stop knockback early.
	ld e,Enemy.knockbackCounter		; $402c
	ld a,(de)		; $402e
	and $80			; $402f
	ld (de),a		; $4031
	ret			; $4032

;;
; Update knockback where the enemy can pass through anything except the screen boundary.
; @addr{4033}
_ecom_updateKnockbackNoSolidity:
	ld a,$02		; $4033
	ld e,Enemy.knockbackAngle		; $4035
	call _ecom_getSideviewAdjacentWallsBitsetGivenAngle		; $4037
	jr _ecom_updateKnockback_common		; $403a

;;
; @addr{403c}
_ecom_updateKnockbackAndCheckHazardsNoAnimationsForHoles:
	call _ecom_updateKnockback		; $403c
	call _ecom_checkHazardsNoAnimationForHoles		; $403f
	ret			; $4042

;;
; Like "_ecom_checkHazards", but the enemy doesn't animate when they fall into a hole.
; That is, they just get stuck on the last frame of their animation as they get sucked in.
; @addr{4043}
_ecom_checkHazardsNoAnimationForHoles:
	ldh (<hFF8F),a	; $4043
	xor a			; $4045
	ldh (<hFF8D),a	; $4046
	jr _ecom_checkHazardsCommon		; $4048

;;
; Standard implementation of "enemy experiencing knockback" state?
; Also, doesn't "return from caller" if it fell in a hazard since it calls the
; "_ecom_checkHazards" function instead of jumping to it.
; @addr{404a}
_ecom_updateKnockbackAndCheckHazards:
	call _ecom_updateKnockback		; $404a
	call _ecom_checkHazards		; $404d
	ret			; $4050

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
; @addr{4051}
_ecom_checkHazards:
	ldh (<hFF8F),a	; $4051
	ld a,$01		; $4053
	ldh (<hFF8D),a	; $4055

_ecom_checkHazardsCommon:
	; If already touched a hazard, skip the checks below
	ld e,Enemy.var3f		; $4057
	ld a,(de)		; $4059
	and $07			; $405a
	jr nz,@applyHazardEffect	; $405c

	; Return if enemy is in midair
	ld e,Enemy.zh		; $405e
	ld a,(de)		; $4060
	rlca			; $4061
	jr c,@ret	; $4062

	; Check if it touched a hazard
	ld bc,$05ff		; $4064
	call objectGetRelativeTile		; $4067
	ld hl,hazardCollisionTable		; $406a
	call lookupCollisionTable		; $406d
	ld b,$ff		; $4070
	jr c,@touchedHazard	; $4072

	ld bc,$0501		; $4074
	call objectGetRelativeTile		; $4077
	ld hl,hazardCollisionTable		; $407a
	call lookupCollisionTable		; $407d
	ld b,$01		; $4080
	jr c,@touchedHazard	; $4082

	call _ecom_updateMovingPlatform		; $4084

@ret:
	ldh a,(<hFF8F)	; $4087
	or a			; $4089
	ret			; $408a

@touchedHazard:
	ld h,d			; $408b
	ld l,Enemy.var3f		; $408c
	ld e,l			; $408e
	or (hl)			; $408f
	ld (hl),a		; $4090
	ld l,Enemy.invincibilityCounter		; $4091
	ld (hl),$00		; $4093
	ld l,Enemy.knockbackCounter		; $4095
	ld (hl),$00		; $4097

	; Disable collisions
	ld l,Enemy.collisionType		; $4099
	res 7,(hl)		; $409b

	ld l,Enemy.counter1		; $409d
	ld (hl),60		; $409f
	inc l			; $40a1
	ldh a,(<hFF8D)	; $40a2
	ld (hl),a ; [Enemy.counter2] = [hFF8D]

	ld l,Enemy.xh		; $40a5
	ld a,(hl)		; $40a7
	add b			; $40a8
	ld (hl),a		; $40a9

@applyHazardEffect:
	pop hl ; Discard return address (this enemy is about to be be deleted)
	ld a,(de)		; $40ab
	rrca			; $40ac
	jr c,_ecom_makeSplashAndDelete	; $40ad
	rrca			; $40af
	jr c,_ecom_fallingInHole	; $40b0
	jr _ecom_makeLavaSplashAndDelete		; $40b2

; @addr{40b4}
_enemyConveyorTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5


.ifdef ROM_AGES

@collisions2:
@collisions5:
	.db $54, ANGLE_UP
	.db $55, ANGLE_RIGHT
	.db $56, ANGLE_DOWN
	.db $57, ANGLE_LEFT
@collisions0:
@collisions1:
@collisions3:
@collisions4:
	.db $00

.else; ROM_SEASONS

@collisions4:
	.db $54, ANGLE_UP
	.db $55, ANGLE_RIGHT
	.db $56, ANGLE_DOWN
	.db $57, ANGLE_LEFT
@collisions0:
@collisions1:
@collisions2:
@collisions3:
@collisions5:
	.db $00

.endif


_ecom_makeSplashAndDelete:
	ld b,INTERACID_SPLASH		; $40c9
	jr ++			; $40cb

_ecom_makeLavaSplashAndDelete:
	ld b,INTERACID_LAVASPLASH		; $40cd
++
	call objectCreateInteractionWithSubid00		; $40cf

_ecom_decNumEnemiesAndDelete:
	call decNumEnemies		; $40d2
	jp enemyDelete		; $40d5

_ecom_fallDownHoleAndDelete:
	call objectCreateFallingDownHoleInteraction		; $40d8
	jr _ecom_decNumEnemiesAndDelete		; $40db


;;
; Enemy is currently falling down a hole.
; @addr{40dd}
_ecom_fallingInHole:
	call _ecom_decCounter1		; $40dd
	jr z,_ecom_fallDownHoleAndDelete	; $40e0

	ld a,(hl) ; a = [Enemy.counter1]
	and $07			; $40e3
	jr nz,++		; $40e5

	; Every 8 frames, move a half pixel closer to the hole.
	call @checkInCenterOfHole		; $40e7
	jr z,_ecom_fallDownHoleAndDelete	; $40ea

	call objectGetRelativeAngleWithTempVars		; $40ec
	ld c,a			; $40ef
	ld b,SPEED_80		; $40f0
	call _ecom_applyGivenVelocity		; $40f2
++
	; If bit 0 of counter2 is set, animate the enemy as it's being sucked toward the
	; hole.
	ld h,d			; $40f5
	ld l,Enemy.counter2		; $40f6
	bit 0,(hl)		; $40f8
	ret z			; $40fa
	ld l,Enemy.animCounter		; $40fb
	ld a,(hl)		; $40fd
	sub $03			; $40fe
	jr nc,+			; $4100
	xor a			; $4102
+
	inc a			; $4103
	ld (hl),a		; $4104
	jp enemyAnimate		; $4105

;;
; @param[out]	zflag	z if enemy is in the center of the hole
; @addr{4108}
@checkInCenterOfHole:
	ld l,Enemy.yh		; $4108
	ldi a,(hl)		; $410a
	ldh (<hFF8F),a	; $410b
	add $05			; $410d
	and $f0			; $410f
	add $08			; $4111
	ld b,a			; $4113
	inc l			; $4114
	ld a,(hl)		; $4115
	ldh (<hFF8E),a	; $4116
	and $f0			; $4118
	add $08			; $411a
	ld c,a			; $411c
	cp (hl)			; $411d
	ret nz			; $411e
	ldh a,(<hFF8F)	; $411f
	cp b			; $4121
	ret			; $4122


;;
; Updates enemy's position if he's on a moving platform.
; @addr{4123}
_ecom_updateMovingPlatform:
	ld e,Enemy.zh		; $4123
	ld a,(de)		; $4125
	rlca			; $4126
	ret c			; $4127

	; Check if on a moving platform
	ld bc,$0500		; $4128
	call objectGetRelativeTile		; $412b
	ld hl,_enemyConveyorTilesTable		; $412e
	call lookupCollisionTable		; $4131
	ret nc			; $4134

	ld c,a			; $4135
	ld b,SPEED_80		; $4136

;;
; Move an object with normal collisions.
;
; TODO: Figure out what the difference between the two "adjacentWallOffset" tables is
;
; @param	b	Speed
; @param	c	Angle
; @param[out]	zflag	z if stopped
_ecom_applyGivenVelocity:
	ld hl,_ecom_sideviewAdjacentWallOffsetTable		; $4138
	xor a			; $413b
	ldh (<hFF8A),a	; $413c
	push bc			; $413e
	ld a,c			; $413f
	call _ecom_getAdjacentWallsBitset		; $4140
	pop bc			; $4143
	jr _ecom_applyGivenVelocityGivenAdjacentWalls		; $4144

;;
; Apply an enemies velocity, accounting for walls. Enemy should be the "top-down" type
; (see below).
;
; Note: ALL of these functions assume a 16x16 size enemy.
; @addr{4146}
_ecom_applyVelocityForTopDownEnemy:
	xor a			; $4146
	call _ecom_getTopDownAdjacentWallsBitset		; $4147
	jr _ecom_applyVelocityGivenAdjacentWalls		; $414a

;;
; Same as above, but holes count as walls.
; @addr{414c}
_ecom_applyVelocityForTopDownEnemyNoHoles:
	ld a,$01		; $414c
	call _ecom_getTopDownAdjacentWallsBitset		; $414e
	jr _ecom_applyVelocityGivenAdjacentWalls		; $4151

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
; @addr{4153}
_ecom_applyVelocityForSideviewEnemy:
	xor a			; $4153
	jr ++			; $4154

;;
; @addr{4156}
_ecom_applyVelocityForSideviewEnemyNoHoles:
	ld a,$01		; $4156
++
	call _ecom_getSideviewAdjacentWallsBitset		; $4158

;;
; @param	de	Enemy's angle value
; @param	hFF8B	Collision bitset
; @addr{415b}
_ecom_applyVelocityGivenAdjacentWalls:
	ld a,(de)		; $415b
	ld c,a			; $415c
	ld e,Enemy.speed		; $415d
	ld a,(de)		; $415f
	ld b,a			; $4160

;;
; Applies the given speed and angle, while checking for collisions; this also accounts for
; "sliding" if, say, only the bottom half of the enemy touches the wall. Then the enemy
; will slide up so it can clear the tile.
;
; @param	hFF8B	Collision bitset
; @param	b	Speed
; @param	c	Angle
; @param[out]	zflag	nz if the enemy moved at least the equivalent of 1 pixel
; @addr{4161}
_ecom_applyGivenVelocityGivenAdjacentWalls:
	ld a,c			; $4161
	ldh (<hFF8C),a	; $4162
	call getPositionOffsetForVelocity		; $4164

	xor a			; $4167
	ldh (<hFF8D),a	; $4168

@updateY:
	ld e,Enemy.y		; $416a
	ldh a,(<hFF8B)	; $416c
	and $0c			; $416e
	jr nz,@checkSlideY	; $4170

	call @applySpeedComponent		; $4172
	jr @updateX		; $4175

@checkSlideY:
	cp $0c			; $4177
	jr z,@updateX	; $4179
	bit 3,a			; $417b
	ldh a,(<hFF8C)	; $417d
	ld bc,$0060		; $417f
	jr nz,++		; $4182
	xor $10			; $4184
	ld bc,-$60		; $4186
++
	cp $11			; $4189
	jr nc,@updateX	; $418b

	ld e,Enemy.x		; $418d
	ld a,(de)		; $418f
	add c			; $4190
	ld (de),a		; $4191
	inc e			; $4192
	ld a,(de)		; $4193
	adc b			; $4194
	ld (de),a		; $4195
	ld e,Enemy.speed		; $4196
	ld a,(de)		; $4198
	cp SPEED_140			; $4199
	jr nc,@updateX	; $419b

	ld a,$01		; $419d
	ldh (<hFF8D),a	; $419f

@updateX:
	ld e,Enemy.x		; $41a1
	ld l,<wTmpcfc0+2		; $41a3
	ldh a,(<hFF8B)	; $41a5
	and $03			; $41a7
	jr nz,@checkSlideX	; $41a9
	call @applySpeedComponent		; $41ab
	jr @ret		; $41ae

@checkSlideX:
	cp $03			; $41b0
	jr z,@ret	; $41b2
	rrca			; $41b4
	ldh a,(<hFF8C)	; $41b5
	ld bc,$0060		; $41b7
	jr nc,++		; $41ba
	sub $10			; $41bc
	ld bc,-$60		; $41be
++
	add $08			; $41c1
	and $1f			; $41c3
	cp $11			; $41c5
	jr nc,@ret	; $41c7

	ld e,Enemy.y		; $41c9
	ld a,(de)		; $41cb
	add c			; $41cc
	ld (de),a		; $41cd
	inc e			; $41ce
	ld a,(de)		; $41cf
	adc b			; $41d0
	ld (de),a		; $41d1

	ld e,Enemy.speed		; $41d2
	ld a,(de)		; $41d4
	cp SPEED_140			; $41d5
	jr nc,@ret	; $41d7

	ld a,$01		; $41d9
	ldh (<hFF8D),a	; $41db

@ret:
	ldh a,(<hFF8D)	; $41dd
	or a			; $41df
	ret			; $41e0

;;
; Writes something to hFF8D (nonzero if moved at least one pixel?)
;
; @param	de	Enemy.x or Enemy.y
; @param	hl	Speed component (from "getPositionOffsetForVelocity" call)
; @addr{41e1}
@applySpeedComponent:
	ld a,(de)		; $41e1
	add (hl)		; $41e2
	ld (de),a		; $41e3

	ld b,(hl)		; $41e4
	inc l			; $41e5
	inc e			; $41e6
	ld a,(de)		; $41e7
	ld c,a			; $41e8
	adc (hl)		; $41e9
	ld (de),a		; $41ea

	sub c			; $41eb
	jr nz,++		; $41ec

	ld c,$20		; $41ee
	ld e,Enemy.speed		; $41f0
	ld a,(de)		; $41f2
	cp SPEED_140			; $41f3
	jr c,+			; $41f5
	ld c,$60		; $41f7
+
	ld a,b			; $41f9
	cp c			; $41fa
	ret c			; $41fb
++
	ldh (<hFF8D),a	; $41fc
	ret			; $41fe


;;
; Unused?
; @param	a	Value for hFF8A (see below)
; @param	de	Pointer to Enemy.angle?
; @addr{41ff}
_ecom_getTopDownAdjacentWallsBitsetGivenAngle:
	ld hl,_ecom_topDownAdjacentWallOffsetTable		; $41ff
	jr _ecom_getAdjacentWallsBitset		; $4202

;;
; @param	a	Value for hFF8A (see below)
; @addr{4204}
_ecom_getTopDownAdjacentWallsBitset:
	ld e,Enemy.angle		; $4204
	ld hl,_ecom_topDownAdjacentWallOffsetTable		; $4206
	jr _label_025		; $4209

;;
; @param	a	Value for hFF8A (see below)
; @addr{420b}
_ecom_getSideviewAdjacentWallsBitset:
	ld e,Enemy.angle		; $420b

;;
; @param	a	Value for hFF8A (see below)
; @param	de	Pointer to Enemy.angle?
; @addr{420d}
_ecom_getSideviewAdjacentWallsBitsetGivenAngle:
	ld hl,_ecom_sideviewAdjacentWallOffsetTable		; $420d
_label_025:
	ldh (<hFF8A),a	; $4210
	ld a,(de)		; $4212

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
; @addr{4213}
_ecom_getAdjacentWallsBitset:
	push de			; $4213
	call _ecom_getAdjacentWallTableOffset		; $4214
	ld b,d			; $4217
	rst_addAToHl			; $4218
	ld d,h			; $4219
	ld e,l			; $421a
	ld h,b			; $421b
	ld l,Enemy.yh		; $421c
	ld b,(hl)		; $421e
	ld l,Enemy.xh		; $421f
	ld c,(hl)		; $4221

	ld a,$10		; $4222
	ldh (<hFF8B),a	; $4224
--
	call @checkCollisionAt		; $4226
	ldh a,(<hFF8B)	; $4229
	rla			; $422b
	ldh (<hFF8B),a	; $422c
	jr nc,--		; $422e

	pop de			; $4230
	or a			; $4231
	ret			; $4232

;;
; @param	bc	Position offset to check
; @param	de	Pointer to Enemy.y
; @param	hFF8A	Type of collision check to do (values explained above)
; @param[out]	cflag	c if there's a collision
; @addr{4233}
@checkCollisionAt:
	ld a,(de)		; $4233
	inc de			; $4234
	add b			; $4235
	ld b,a			; $4236
	ld a,(de)		; $4237
	inc de			; $4238
	add c			; $4239
	ld c,a			; $423a

	ldh a,(<hFF8A)	; $423b
	dec a			; $423d

	; hFF8A == 1 (holes count as walls)
	jp z,checkTileCollisionAt_disallowHoles		; $423e
	inc a			; $4241
	jr z,++			; $4242

	; hFF8A == 2 or higher (only screen boundaries count as walls; checking for
	; SPECIALCOLLISION_SCREEN_BOUNDARY ($ff).)
	call getTileCollisionsAtPosition		; $4244
	add $01			; $4247
	ret			; $4249
++
	; hFF8A == 0 (normal collision check)
	call getTileCollisionsAtPosition		; $424a
	add $01			; $424d
	jp nc,checkTileCollisionAt_allowHoles		; $424f
	ret			; $4252

;;
; Given an angle this returns an offset within the position offset table to use.
;
; This seems to be just (angle/4)*8, with some particular kind of rounding...
;
; @param	a	Angle
; @param[out]	a	Offset into table to use
; @addr{4253}
_ecom_getAdjacentWallTableOffset:
	rlca			; $4253
	ld b,a			; $4254
	and $0f			; $4255
	ld a,b			; $4257
	ret z			; $4258
	and $f0			; $4259
	add $08			; $425b
	ret			; $425d


; For enemies drawn in "side" view (ie. moblins). Smaller bounding box.
;
; NOTE: The game isn't even consistent about this. Octoroks use the "topdown" table when
; moving, but the "sideview" table for knockback, as an example.
;
; @addr{425e}
_ecom_sideviewAdjacentWallOffsetTable:
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
; @addr{425e}
_ecom_topDownAdjacentWallOffsetTable:
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
; @addr{42de}
_ecom_bounceOffWallsAndHoles:
	ld a,$01		; $42de
	jr ++			; $42e0

;;
; Like below, but including walls.
; @addr{42e2}
_ecom_bounceOffWalls:
	xor a			; $42e2
	jr ++			; $42e3

;;
; When an enemy hits a screen boundary, its angle is updated to "bounce" off it.
; @addr{42e5}
_ecom_bounceOffScreenBoundary:
	ld a,$02		; $42e5
++
	call _ecom_getSideviewAdjacentWallsBitset		; $42e7
	call @getDirectionsHit		; $42ea
	ld a,c			; $42ed
	or a			; $42ee
	ret z			; $42ef
	cp $05			; $42f0
	jr z,@reverseDirection	; $42f2

	ld hl,@angleTable+$10		; $42f4
	bit 0,a			; $42f7
	jr nz,+			; $42f9
	ld hl,@angleTable		; $42fb
+
	ld e,Enemy.angle		; $42fe
	ld a,(de)		; $4300
	rst_addAToHl			; $4301
	ld a,(hl)		; $4302
	ld (de),a		; $4303
	or d			; $4304
	ret			; $4305

@reverseDirection:
	; Hit both horizontal and vertical wall at the same time
	ld e,Enemy.angle		; $4306
	ld a,(de)		; $4308
	add $10			; $4309
	and $1f			; $430b
	ld (de),a		; $430d
	or d			; $430e
	ret			; $430f

;;
; @param	a	Adjacent walls bitset
; @param[out]	c	Bits 0,2 set if horizontal, vertical wall bits are set.
; @addr{4310}
@getDirectionsHit:
	ld c,$00		; $4310
	ld b,a			; $4312
	and $03			; $4313
	jr z,+			; $4315
	inc c			; $4317
+
	ld a,b			; $4318
	and $0c			; $4319
	ret z			; $431b
	set 2,c			; $431c
	ret			; $431e

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
; @addr{434f}
_ecom_randomBitwiseAndBCE:
	push bc			; $434f
	call getRandomNumber_noPreserveVars		; $4350
	pop bc			; $4353
	and e			; $4354
	ld e,a			; $4355
	ld a,h			; $4356
	and b			; $4357
	ld b,a			; $4358
	ld a,l			; $4359
	and c			; $435a
	ld c,a			; $435b
	xor a			; $435c
	ret			; $435d

;;
; Sets the enemy's speed to given value, sets state to 8, and makes the enemy visible.
;
; @param	a	Speed
; @param[out]	hl	Enemy.state
; @addr{435e}
_ecom_setSpeedAndState8AndVisible:
	call _ecom_setSpeedAndState8		; $435e
	jp objectSetVisiblec2		; $4361

;;
; @param	a	Speed
; @param[out]	hl	Enemy.state
; @addr{4364}
_ecom_setSpeedAndState8:
	ld h,d			; $4364
	ld l,Enemy.speed		; $4365
	ld (hl),a		; $4367
	ld l,Enemy.state		; $4368
	ld (hl),$08		; $436a
	ret			; $436c

;;
; @param	b	Enemy type
; @param[out]	hl	Enemy.subid
; @param[out]	zflag	z if successfully spawned
; @addr{436d}
_ecom_spawnUncountedEnemyWithSubid01:
	call getFreeEnemySlot_uncounted		; $436d
	ret nz			; $4370
	jr ++			; $4371

;;
; @param	b	Enemy type
; @param[out]	hl	Enemy.subid
; @param[out]	zflag	z if successfully spawned
; @addr{4373}
_ecom_spawnEnemyWithSubid01:
	call getFreeEnemySlot		; $4373
	ret nz			; $4376
++
	ld (hl),b		; $4377
	inc l			; $4378
	inc (hl)		; $4379
	xor a			; $437a
	ret			; $437b

;;
; Spawns a "part" which is probably a projectile for the enemy. It inherits the enemy's
; position and angle, the part's "relatedObj1" variable is set to point to the enemy, and
; the enemy's "relatedObj2" variable is set to point to the part.
;
; @param	b	Part ID
; @param[out]	zflag	z if spawned successfully
; @addr{437c}
_ecom_spawnProjectile:
	call getFreePartSlot		; $437c
	ret nz			; $437f

	ld (hl),b		; $4380
	call objectCopyPosition		; $4381

	ld l,Part.relatedObj1		; $4384
	ld a,Enemy.start		; $4386
	ldi (hl),a		; $4388
	ld (hl),d		; $4389

	ld e,Enemy.relatedObj2		; $438a
	ld a,Part.start		; $438c
	ld (de),a		; $438e
	inc e			; $438f
	ld a,h			; $4390
	ld (de),a		; $4391

	ld e,Enemy.angle		; $4392
	ld l,Part.angle		; $4394
	ld a,(de)		; $4396
	ldi (hl),a		; $4397
	xor a			; $4398
	ret			; $4399

;;
; @param[out]	zflag	z if counter1 reached 0
; @addr{439a}
_ecom_decCounter1:
	ld h,d			; $439a
	ld l,Enemy.counter1		; $439b
	dec (hl)		; $439d
	ret			; $439e

;;
; Treats counter1 and counter2 as one 16-bit counter. (Unused?)
; @param[out]	zflag	z if counter reached 0
; @addr{439f}
_ecom_dec16BitCounter:
	call _ecom_decCounter1		; $439f
	ret nz			; $43a2

;;
; @param[out]	zflag
; @addr{43a3}
_ecom_decCounter2:
	ld h,d			; $43a3
	ld l,Enemy.counter2		; $43a4
	ld a,(hl)		; $43a6
	or a			; $43a7
	ret z			; $43a8
	dec (hl)		; $43a9
	ret			; $43aa

;;
; @param[out]	a	New angle
; @addr{43ab}
_ecom_updateCardinalAngleAwayFromTarget:
	call objectGetAngleTowardEnemyTarget		; $43ab
	xor $10			; $43ae
	ld e,Enemy.angle		; $43b0
	ld (de),a		; $43b2
	ret			; $43b3

;;
; Similar to below, but angle must be in a cardinal direction.
; @param[out]	a	New angle
; @addr{43b4}
_ecom_updateCardinalAngleTowardTarget:
	call objectGetAngleTowardEnemyTarget		; $43b4
	add $04			; $43b7
	and $18			; $43b9
	ld e,Enemy.angle		; $43bb
	ld (de),a		; $43bd
	ret			; $43be

;;
; Sets the enemy's angle to face its target (usually Link).
; @param[out]	a	New angle
; @addr{43bf}
_ecom_updateAngleTowardTarget:
	call objectGetAngleTowardEnemyTarget		; $43bf
	ld e,Enemy.angle		; $43c2
	ld (de),a		; $43c4
	ret			; $43c5

;;
; @param[out]	a	New angle
; @addr{43c6}
_ecom_setRandomCardinalAngle:
	call getRandomNumber_noPreserveVars		; $43c6
	and $18			; $43c9
	ld e,Enemy.angle		; $43cb
	ld (de),a		; $43cd
	ret			; $43ce

;;
; @addr{43cf}
_ecom_setRandomAngle:
	call getRandomNumber_noPreserveVars		; $43cf
	and $1f			; $43d2
	ld e,Enemy.angle		; $43d4
	ld (de),a		; $43d6
	ret			; $43d7

;;
; Updates the enemy's animation based on its angle. Cardinal directions are animations 0-3,
; diagonals are 4-7?
;
; The current animation index is stored in "Enemy.direction".
;
; @addr{43d8}
_ecom_updateAnimationFromAngle:
	ld h,d			; $43d8
	ld l,Enemy.angle		; $43d9
	ldd a,(hl)		; $43db
	ld e,a			; $43dc
	ld bc,@angleToAnimIndex		; $43dd
	call addAToBc		; $43e0
	ld a,(bc)		; $43e3
	cp $04			; $43e4
	jr c,@setAnimation	; $43e6

	sub (hl)		; $43e8
	cp $07			; $43e9
	ret z			; $43eb
	sub $03			; $43ec
	cp $02			; $43ee
	ret c			; $43f0
	ld a,e			; $43f1
	add $04			; $43f2
	and $18			; $43f4
	swap a			; $43f6
	rlca			; $43f8

@setAnimation:
	cp (hl) ; hl == direction (actually stores animation index)
	ret z			; $43fa
	ld (hl),a		; $43fb
	jp enemySetAnimation		; $43fc

@angleToAnimIndex:
	.db $00 $00 $00 $04 $04 $04 $01 $01
	.db $01 $01 $01 $05 $05 $05 $02 $02
	.db $02 $02 $02 $06 $06 $06 $03 $03
	.db $03 $03 $03 $07 $07 $07 $00 $00

;;
; @addr{441f}
_ecom_flickerVisibility:
	ld e,Enemy.visible		; $441f
	ld a,(de)		; $4421
	xor $80			; $4422
	ld (de),a		; $4424
	ret			; $4425

;;
; @param[out]	a	State
; @param[out]	b	Subid
; @param[out]	cflag	c if state < 8
; @addr{4426}
_ecom_getSubidAndCpStateTo08:
	ld e,Enemy.subid		; $4426
	ld a,(de)		; $4428
	ld b,a			; $4429
	ld e,Enemy.state		; $442a
	ld a,(de)		; $442c
	cp $08			; $442d
	ret			; $442f

;;
; @param	bc	YX position to get the direction toward
; @param	hFF8E	X position of object
; @param	hFF8F	Y position of object
; @addr{4430}
_ecom_moveTowardPosition:
	call objectGetRelativeAngleWithTempVars		; $4430
	ld e,Enemy.angle		; $4433
	ld (de),a		; $4435
	jp objectApplySpeed		; $4436

;;
; Call this just before calling "_ecom_moveTowardPosition" above.
;
; @param	hl	Position to read into bc (angle to move toward)
; @param[out]	a	[Enemy.x]
; @param[out]	bc	Position read from hl
; @param[out]	hFF8F	[Enemy.y]
; @param[out]	hFF8E	[Enemy.x]
; @addr{4439}
_ecom_readPositionVars:
	ld b,(hl)		; $4439
	inc l			; $443a
	ld c,(hl)		; $443b
	ld l,Enemy.yh		; $443c
	ldi a,(hl)		; $443e
	ldh (<hFF8F),a	; $443f
	inc l			; $4441
	ld a,(hl)		; $4442
	ldh (<hFF8E),a	; $4443
	ret			; $4445

.ifdef ROM_SEASONS

;;
; Moves toward Link?
; @param	a
; @param[out]	zflag
_ecom_seasonsFunc_4446:
	ld b,a			; $4446
	ld a,($cc79) ; TODO: figure out what this corresponds to in ages (if anything)
	or a			; $444a
	ld a,b			; $444b
	jp z,_ecom_checkHazards		; $444c

	ld h,d			; $444f
	ld l,Enemy.var3f		; $4450
	res 1,(hl)		; $4452

	ld l,Enemy.collisionType		; $4454
	set 7,(hl)		; $4456

	push af			; $4458
	call objectGetLinkRelativeAngle		; $4459
	ld c,a			; $445c
	ld b,SPEED_80		; $445d
	call _ecom_applyGivenVelocity		; $445f

	pop af			; $4462
	or a			; $4463
	ret			; $4464

.endif

;;
; Set the enemy's Z position such that it's just above the screen.
;
; @param	c	Extra offset to subtract from Z position (make it further beyond
;			the screen)
; @addr{4446}
_ecom_setZAboveScreen:
	ld h,d			; $4446
	ld l,Enemy.yh		; $4447
	ld a,(hl)		; $4449
	add c			; $444a
	cpl			; $444b
	inc a			; $444c
	ld c,a			; $444d
	ldh a,(<hCameraY)	; $444e
	add c			; $4450
	jr nc,+			; $4451
	ld a,c			; $4453
+
	bit 7,a			; $4454
	jr nz,+			; $4456
	ld a,$80		; $4458
+
	ld l,Enemy.zh		; $445a
	ld (hl),a		; $445c
	ret			; $445d

;;
; @param	h	Object index
; @param	l	Object type
; @addr{445e}
_ecom_killObjectH:
	ld a,l			; $445e
	and $c0			; $445f
	or Object.health			; $4461
	ld l,a			; $4463

;;
; Sets an object's health to zero, disables their collisions.
;
; @param	hl	Pointer to object's health value
; @addr{4464}
_ecom_killRelatedObj:
	ld (hl),$00		; $4464
	ld a,l			; $4466
	add Object.collisionType - Object.health			; $4467
	ld l,a			; $4469
	res 7,(hl)		; $446a
	ret			; $446c

;;
; @addr{446d}
_ecom_killRelatedObj1:
	ld a,Object.health		; $446d
	call objectGetRelatedObject1Var		; $446f
	jr _ecom_killRelatedObj		; $4472

;;
; @addr{4474}
_ecom_killRelatedObj2:
	ld a,Object.health		; $4474
	call objectGetRelatedObject2Var		; $4476
	jr _ecom_killRelatedObj		; $4479

;;
; Enemy shakes horizontally until counter2 reaches 0, then flies up above the screen.
;
; @param[out]	cflag	c if gale seed effect still persists, nc otherwise
; @addr{447b}
_ecom_galeSeedEffect:
	call _ecom_decCounter2		; $447b
	jr z,@zero	; $447e

	ld a,(hl)		; $4480
	and $03			; $4481
	ld hl,@oscillationX		; $4483
	rst_addAToHl			; $4486
	ld e,Enemy.xh		; $4487
	ld a,(de)		; $4489
	add (hl)		; $448a
	ld (de),a		; $448b
	scf			; $448c
	ret			; $448d

@zero:
	call objectApplySpeed		; $448e
	ld c,$10		; $4491
	call objectUpdateSpeedZ_paramC		; $4493
	ldh a,(<hCameraY)	; $4496
	ld b,a			; $4498
	ld l,Enemy.zh		; $4499
	ld a,(hl)		; $449b
	cp $80			; $449c
	ccf			; $449e
	ret nc			; $449f
	ld e,Enemy.yh		; $44a0
	ld a,(de)		; $44a2
	add (hl)		; $44a3
	sub b			; $44a4
	cp LARGE_ROOM_HEIGHT<<4			; $44a5
	ret			; $44a7

@oscillationX:
	.db $fe $02 $02 $fe

;;
; Common implementation of "blown away by gale seed" state; enemy gets caught in the
; tornado and flies away, then gets deleted.
; @addr{44ac}
_ecom_blownByGaleSeedState:
	call _ecom_galeSeedEffect		; $44ac
	ret c			; $44af
	call decNumEnemies		; $44b0
	jp enemyDelete		; $44b3

;;
; If a scent seed is active, and this enemy should respond to it, this sets its state to
; 4.
; @addr{44b6}
_ecom_checkScentSeedActive:
	ld a,(wScentSeedActive)		; $44b6
	or a			; $44b9
	ret z			; $44ba
	ld e,Enemy.var3f		; $44bb
	ld a,(de)		; $44bd
	bit 4,a			; $44be
	ret z			; $44c0

	ld e,Enemy.state		; $44c1
	ld a,(de)		; $44c3
	and $f8			; $44c4
	ret z			; $44c6
	ld a,$04		; $44c7
	ld (de),a		; $44c9
	ret			; $44ca

;;
; Every 16 frames, this function updates the enemy's angle relative to a scent seed
; (position in hFFB2/hFFB3). Uses Enemy.var3d as a counter for this.
; @addr{44cb}
_ecom_updateAngleToScentSeed:
	ld h,d			; $44cb
	ld l,Enemy.var3d		; $44cc
	dec (hl)		; $44ce
	ld a,(hl)		; $44cf
	and $0f			; $44d0
	ret nz			; $44d2

	ldh a,(<hFFB2)	; $44d3
	ld b,a			; $44d5
	ldh a,(<hFFB3)	; $44d6
	ld c,a			; $44d8
	call objectGetRelativeAngle		; $44d9
	ld e,Enemy.angle		; $44dc
	ld (de),a		; $44de
	ret			; $44df

;;
; @addr{44e0}
_ecom_fallToGroundAndSetState8:
	ld b,$08		; $44e0

;;
; Updates gravity for an enemy, and changes its state when it lands.
;
; @param	b	State to change to upon landing
; @param[out]	zflag	z if the enemy is on the ground
; @addr{44e2}
_ecom_fallToGroundAndSetState:
	ld c,$20		; $44e2
	call objectUpdateSpeedZ_paramC		; $44e4
	ret nz			; $44e7
	ld l,Enemy.collisionType		; $44e8
	set 7,(hl)		; $44ea
	ld l,Enemy.state		; $44ec
	ld (hl),b		; $44ee
	ret			; $44ef
