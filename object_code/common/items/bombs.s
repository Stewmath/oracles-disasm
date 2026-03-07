;;
; ITEM_BOMB
itemCode03:
	ld e,Item.var2f
	ld a,(de)
	bit 5,a
	jr nz,@label_07_153

	bit 7,a
	jp nz,bombResetAnimationAndSetVisiblec1

	; Check if exploding
	bit 4,a
	jp nz,bombUpdateExplosion

	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2


; Not sure when this is executed. Causes the bomb to be deleted.
@label_07_153:
	ld h,d
	ld l,Item.state
	ldi a,(hl)
	cp $02
	jr nz,+

	; Check bit 1 of Item.substate (check if it's being held?)
	bit 1,(hl)
	call z,dropLinkHeldItem
+
	jp itemDelete

; State 1: bomb is motionless on the ground
@state1:
	ld c,$20
	call bombUpdateThrowingVerticallyAndCheckDelete
	ret c

	; No idea what function is for
	call bombPullTowardPoint
	jp c,itemDelete

	call itemUpdateConveyorBelt
	jp bombUpdateAnimation

; State 0/2: bomb is being picked up / thrown around
@state0:
@state2:
	ld e,Item.substate
	ld a,(de)
	rst_jumpTable

	.dw @heldState0
	.dw @heldState1
	.dw @heldState2
	.dw @heldState3


; Bomb just picked up
@heldState0:
	call itemIncSubstate

	ld l,Item.var2f
	set 6,(hl)

	ld l,Item.var37
	res 0,(hl)
	call bombInitializeIfNeeded

; Bomb being held
@heldState1:
	; Bombs don't explode while being held if the peace ring is equipped
	ld a,PEACE_RING
	call cpActiveRing
	jp z,bombResetAnimationAndSetVisiblec1

	call bombUpdateAnimation
	ret z

	; If z-flag was unset (bomb started exploding), release the item?
	jp dropLinkHeldItem

; Bomb being thrown
@heldState2:
@heldState3:
	; Set substate to $03
	ld a,$03
	ld (de),a

	; Update movement?
	call bombUpdateThrowingLaterally

	ld e,Item.var39
	ld a,(de)
	ld c,a

	; Update throwing, return if the bomb was deleted from falling into a hazard
	call bombUpdateThrowingVerticallyAndCheckDelete
	ret c

	; Jump if the item is not on the ground
	jr z,+

	; If on the ground...
	call itemBounce
	jr c,@stoppedBouncing

	; No idea what this function is for
	call bombPullTowardPoint
	jp c,itemDelete
+
	jp bombUpdateAnimation

@stoppedBouncing:
	; Bomb goes to state 1 (motionless on the ground)
	ld h,d
	ld l,Item.state
	ld (hl),$01

	ld l,Item.var2f
	res 6,(hl)

	jp bombUpdateAnimation

;;
; @param[out]	cflag	Set if the item was deleted
; @param[out]	zflag	Set if the bomb is not on the ground
bombUpdateThrowingVerticallyAndCheckDelete:
	push bc
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr z,+

	; If in a sidescrolling area, allow Y values between $08-$f7?
	ld e,Item.yh
	ld a,(de)
	sub $08
	cp $f0
	ccf
	jr c,++
+
	call objectCheckWithinRoomBoundary
++
	pop bc
	jr nc,@delete

	; Within the room boundary

	; Return if it hasn't landed in a hazard (hole/water/lava)
	call itemUpdateThrowingVerticallyAndCheckHazards
	ret nc

	; Check whether to trigger a special event when a bomb falls into a hazard (bomb upgrade in
	; ages, or volcano trigger in seasons)
.ifdef ROM_AGES
	ld bc,ROOM_AGES_050
.else
	ld bc,ROOM_SEASONS_4ef
.endif
	ld a,(wActiveGroup)
	cp b
	jr nz,@delete
	ld a,(wActiveRoom)
	cp c
	jr nz,@delete

	; If so, trigger the cutscene
	ld a,$01
	ld (wTmpcfc0.bombUpgradeCutscene.state),a

@delete:
	call itemDelete
	scf
	ret

;;
; Update function for bombs and bombchus while they're exploding
;
itemUpdateExplosion:
	; animParameter specifies:
	;  Bits 0-4: collision radius
	;  Bit 6:    Zero out "collisionType" if set?
	;  Bit 7:    End of animation (delete self)
	ld h,d
	ld l,Item.animParameter
	ld a,(hl)
	bit 7,a
	jp nz,itemDelete

	ld l,Item.collisionType
	bit 6,a
	jr z,+
	ld (hl),$00
+
	ld c,(hl)
	ld l,Item.collisionRadiusY
	and $1f
	ldi (hl),a
	ldi (hl),a

	; If bit 7 of Item.collisionType is set, check for collision with Link
	bit 7,c
	call nz,explosionCheckAndApplyLinkCollision

	ld h,d
	ld l,Item.counter1
	bit 7,(hl)
	call z,explosionTryToBreakNextTile
	jp itemAnimate

;;
; Bombs call each frame if bit 4 of Item.var2f is set.
;
bombUpdateExplosion:
	ld h,d
	ld l,Item.state
	ld a,(hl)
	cp $ff
	jr nz,itemInitializeBombExplosion
	jr itemUpdateExplosion

;;
; @param[out]	zflag	Set if the bomb isn't exploding (not sure if it gets unset on just
;			one frame, or all frames after the explosion starts)
bombUpdateAnimation:
	call itemAnimate
	ld e,Item.animParameter
	ld a,(de)
	or a
	ret z

;;
; Initializes a bomb explosion?
;
; @param[out]	zflag
itemInitializeBombExplosion:
	ld h,d
	ld l,Item.oamFlagsBackup
	ld a,$0a
	ldi (hl),a
	ldi (hl),a

	; Set Item.oamTileIndexBase
	ld (hl),$0c

	; Enable collisions
	ld l,Item.collisionType
	set 7,(hl)

	; Decrease damage if not using blast ring
	ld a,BLAST_RING
	call cpActiveRing
	jr nz,+
	ld l,Item.damage
	dec (hl)
	dec (hl)
+
	; State $ff means exploding
	ld l,Item.state
	ld (hl),$ff
	ld l,Item.counter1
	ld (hl),$08

	ld l,Item.var2f
	ld a,(hl)
	or $50
	ld (hl),a

	ld l,Item.id
	ldd a,(hl)

	; Reset bit 1 of Item.enabled
	res 1,(hl)

	; Check if this is a bomb, as opposed to a bombchu?
	cp ITEM_BOMB
	ld a,$01
	jr z,+
	ld a,$06
+
	call itemSetAnimation
	call objectSetVisible80
	ld a,SND_EXPLOSION
	call playSound
	or d
	ret

;;
bombInitializeIfNeeded:
	ld h,d
	ld l,Item.var37
	bit 7,(hl)
	ret nz

	set 7,(hl)
	call decNumBombs
	call itemLoadAttributesAndGraphics
	call itemMergeZPositionIfSidescrollingArea

;;
bombResetAnimationAndSetVisiblec1:
	xor a
	call itemSetAnimation
	jp objectSetVisiblec1

;;
; Bombs call this to check for collision with Link and apply the damage.
;
explosionCheckAndApplyLinkCollision:
	; Return if the bomb has already hit Link
	ld h,d
	ld l,Item.var37
	bit 6,(hl)
	ret nz

	ld a,(w1Companion.id)
	cp SPECIALOBJECT_MINECART
	ret z

	ld a,BOMBPROOF_RING
	call cpActiveRing
	ret z

	call checkLinkVulnerable
	ret nc

	; Check if close enough on the Z axis
	ld h,d
	ld l,Item.collisionRadiusY
	ld a,(hl)
	ld c,a
	add a
	ld b,a
	ld l,Item.zh
	ld a,(w1Link.zh)
	sub (hl)
	add c
	cp b
	ret nc

	call objectCheckCollidedWithLink_ignoreZ
	ret nc

	; Collision occurred; now give Link knockback, etc.

	call objectGetAngleTowardLink

	; Set bit 6 to prevent double-hits?
	ld h,d
	ld l,Item.var37
	set 6,(hl)

	ld l,Item.damage
	ld c,(hl)
	ld hl,w1Link.damageToApply
	ld (hl),c

	ld l,<w1Link.knockbackCounter
	ld (hl),$0c

	; knockbackAngle
	dec l
	ldd (hl),a

	; invincibilityCounter
	ld (hl),$10

	; var2a
	dec l
	ld (hl),$01

	jp linkApplyDamage

;;
; Checks whether nearby tiles should be blown up from the explosion.
;
; Each call checks one tile for deletion. After 9 calls, all spots will have been checked.
;
; @param	hl	Pointer to a counter (should count down from 8 to 0)
explosionTryToBreakNextTile:
	ld a,(hl)
	dec (hl)
	ld l,a
	add a
	add l
	ld hl,@data
	rst_addAToHl

	; Verify Z position is close enough (for non-sidescrolling areas)
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	ld e,Item.zh
	ld a,(de)
	jr nz,+

	sub $02
	cp (hl)
	ret c

	xor a
+
	ld c,a
	inc hl
	ldi a,(hl)
	add c
	ld b,a

	ld a,(hl)
	ld c,a

	; bc = offset to add to explosion's position

	; Get Y position of tile, return if out of bounds
	ld h,d
	ld e,$00
	bit 7,b
	jr z,+
	dec e
+
	ld l,Item.yh
	ldi a,(hl)
	add b
	ld b,a
	ld a,$00
	adc e
	ret nz

	; Get X position of tile, return if out of bounds
	inc l
	ld e,$00
	bit 7,c
	jr z,+
	dec e
+
	ld a,(hl)
	add c
	ld c,a
	ld a,$00
	adc e
	ret nz

	ld a,BREAKABLETILESOURCE_BOMB
	jp tryToBreakTile

; The following is a list of offsets from the center of the bomb at which to try
; destroying tiles.
;
; b0: necessary Z-axis proximity (lower is closer?)
; b1: offset from y-position
; b2: offset from x-position

@data:
	.db $f8 $f3 $f3
	.db $f8 $0c $f3
	.db $f8 $0c $0c
	.db $f8 $f3 $0c
	.db $f4 $00 $f3
	.db $f4 $0c $00
	.db $f4 $00 $0c
	.db $f4 $f3 $00
	.db $f2 $00 $00
