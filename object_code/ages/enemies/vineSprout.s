; ==================================================================================================
; ENEMY_VINE_SPROUT
;
; Variables:
;   var31: Tile index underneath the sprout?
;   var32: Short-form position of vine sprout
;   var33: Nonzero if the "tile properties" underneath this sprout have been modified
; ==================================================================================================
enemyCode62:
	call objectReplaceWithAnimationIfOnHazard
	ret c

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw vineSprout_state0
	.dw vineSprout_state1
	.dw vineSprout_state_grabbed
	.dw vineSprout_state_switchHook
	.dw vineSprout_state4


; Initialization
vineSprout_state0:
	; Delete self if there is any other vine sprout on-screen already?
	ldhl FIRST_ENEMY_INDEX, Enemy.id
@nextEnemy:
	ld a,(hl)
	cp ENEMY_VINE_SPROUT
	jr nz,++
	ld a,d
	cp h
	jp nz,enemyDelete
++
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),20

	ld l,Enemy.speed
	ld (hl),SPEED_c0

.ifdef REGION_JP
	; JP version of "vineSprout_getPosition" function. Instead of checking for certain specific
	; respawning tiles, this checks for solidity at the vine sprout's position. If the tile
	; there is solid, the sprout respawns back at its initial position.
	;
	; The only apparent difference this code makes (along with the other changes to vines in
	; general) is that when a vine is placed on the staircase in talus peaks using the switch
	; hook, in the japanese version, it will be forced to respawn back to its original position.
	; They "fixed" this in the US version.
	;
	; An apparent unintentional side-effect of the change to the US version is that, because
	; it always writes collision value "$00" back to the tile when the vine is pushed off, the
	; staircase values are set to collision "$00" instead of "SPECIALCOLLISION_STAIRS". This
	; doesn't seem to have any practical significance except that you can then use the cane of
	; somaria on the stair tiles, while normally you could not.
	;
	; (AFAIK, the staircases are the only things with a non-zero collision value that vines can
	; be put onto. If there is anything else like that, then those other things may also be
	; affected by these changes.)
	ld e,Enemy.subid
	ld a,(de)
	ld hl,wVinePositions
	rst_addAToHl
	ld c,(hl)

	ld b,>wRoomLayout
	ld a,(bc)
	or a
	jr z,++
	call vineSprout_getDefaultPosition
	ld c,a
++

.else
	call vineSprout_getPosition
.endif

	call objectSetShortPosition
	jp objectSetVisiblec2


vineSprout_state1:
	ld a,(wLinkInAir)
	rlca
	jp c,vineSprout_linkJumpingDownCliff

	call vineSprout_checkLinkInSprout
	ld e,Enemy.var33
	ld a,(de)
	jp c,vineSprout_restoreTileAtPosition

	call objectAddToGrabbableObjectBuffer
	call vineSprout_updateTileAtPosition

	; Check various conditions for whether to push the sprout
	ld hl,w1Link.id
	ld a,(hl)
	cpa SPECIALOBJECT_LINK
	jr nz,@notPushingSprout

	ld l,<w1Link.state
	ld a,(hl)
	cp LINK_STATE_NORMAL
	jr nz,@notPushingSprout

	; Must not be in midair
	ld l,<w1Link.zh
	bit 7,(hl)
	jr nz,@notPushingSprout

	; Can't be swimming
	ld a,(wLinkSwimmingState)
	or a
	jr nz,@notPushingSprout

	; Must be moving
	ld a,(wLinkAngle)
	inc a
	jr z,@notPushingSprout

	; Must not be pressing A or B
	ld a,(wGameKeysPressed)
	and BTN_A|BTN_B
	jr nz,@notPushingSprout

.ifndef REGION_JP
	; Must not be holding anything
	ld a,(wLinkGrabState)
	or a
	jr nz,@notPushingSprout
.endif

	; Must be close enough
	ld c,$12
	call objectCheckLinkWithinDistance
	jr nc,@notPushingSprout

	; Must be aligned properly
	ld b,$04
	call objectCheckCenteredWithLink
	jr nc,@notPushingSprout

	; Link must be moving forwards
	call ecom_updateCardinalAngleAwayFromTarget
	add $04
	and $18
	ld (de),a ; [angle]
	swap a
	rlca
	ld b,a
	ld a,(w1Link.direction)
	cp b
	jr nz,@notPushingSprout

	; All the above must hold for 20 frames
	call ecom_decCounter1
	ret nz

	; Attempt to push the sprout.

	ld a,(de) ; [angle]
	rrca
	rrca
	ld hl,@pushOffsets
	rst_addAToHl

	; Get destination position
	call objectGetPosition
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a

	; Must not be solid there
	call getTileCollisionsAtPosition
	jr nz,@notPushingSprout

	; Push the sprout
	ld h,d
	ld l,Enemy.state
	ld (hl),$04
	ld l,Enemy.counter1
	ld (hl),$16
	ld a,SND_MOVEBLOCK
	call playSound
	jp vineSprout_restoreTileAtPosition

@notPushingSprout:
	ld e,Enemy.counter1
	ld a,20
	ld (de),a
	ret

@pushOffsets:
	.db $f0 $00 ; DIR_UP
	.db $00 $10 ; DIR_RIGHT
	.db $10 $00 ; DIR_DOWN
	.db $00 $f0 ; DIR_LEFT


vineSprout_linkJumpingDownCliff:
	call vineSprout_restoreTileAtPosition
	call vineSprout_checkLinkInSprout
	ret nc

	; Check Link is close to ground
	ld l,SpecialObject.zh
	ld a,(hl)
	add $03
	ret nc

vineSprout_destroy:
	ld b,INTERAC_ROCKDEBRIS
	call objectCreateInteractionWithSubid00

	call vineSprout_getDefaultPosition
	ld b,a
	ld a,(de) ; [subid]
	ld hl,wVinePositions
	rst_addAToHl
	ld (hl),b

	jp enemyDelete


vineSprout_state_grabbed:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @justReleased
	.dw @hitGround

@justGrabbed:
	xor a
	ld (wLinkGrabState2),a
	inc a
	ld (de),a
	call vineSprout_restoreTileAtPosition
	jp objectSetVisiblec1

@beingHeld:
	ret

@justReleased:
	ld h,d
	ld l,Enemy.enabled
	res 1,(hl) ; Don't persist across rooms anymore
	ld l,Enemy.zh
	bit 7,(hl)
	ret nz

@hitGround:
	jr vineSprout_destroy


vineSprout_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justLatched
	.dw @beforeSwitch
	.dw objectCenterOnTile
	.dw @released

@justLatched:
	call vineSprout_restoreTileAtPosition
	jp ecom_incSubstate

@beforeSwitch:
	ret

@released:
	ld b,$01
	call ecom_fallToGroundAndSetState
	ret nz
	call objectCenterOnTile
	jp vineSprout_updateTileAtPosition


; Being pushed
vineSprout_state4:
	ld hl,w1Link
	call preventObjectHFromPassingObjectD

	call ecom_decCounter1
	jp nz,ecom_applyVelocityForTopDownEnemyNoHoles

	; Done pushing
	ld (hl),20 ; [counter1]
	ld l,Enemy.state
	ld (hl),$01

	call objectCenterOnTile

	; fall through


;;
; Updates tile properties at current position, updates wVinePositions, if var33 is
; nonzero.
vineSprout_updateTileAtPosition:
	; Return if we've already done this
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret nz

	call objectGetTileCollisions

.ifdef REGION_JP
	ld e,Enemy.var30
	ld (de),a
	ld (hl),$0f
	inc e
.else
	ld (hl),$0f
	ld e,Enemy.var31
.endif

	ld h,>wRoomLayout
	ld a,(hl)
	ld (de),a ; [var31] = tile index
	inc e
	ld a,l
	ld (de),a ; [var32] = tile position
	ld (hl),TILEINDEX_00

	inc e
	ld a,$01
	ld (de),a ; [var33] = 1

	; Ensure that the position is not on the screen boundary.
	; BUG: This could push the sprout into a wall? (Probably not possible with the
	; room layouts of the vanilla game...)
@fixVerticalBoundary:
	ld a,l
	and $f0
	jr nz,++
	set 4,l
	jr @fixHorizontalBoundary
++
	cp (SMALL_ROOM_HEIGHT-1)<<4
	jr nz,@fixHorizontalBoundary
	res 4,l

@fixHorizontalBoundary:
	ld a,l
	and $0f
	jr nz,++
	inc l
	jr @setPosition
++
	cp SMALL_ROOM_WIDTH-1
	jr nz,@setPosition
	dec l

@setPosition:
	ld e,Enemy.subid
	ld a,(de)
	ld bc,wVinePositions
	call addAToBc
	ld a,l
	ld (bc),a
	ret

;;
; Undoes the changes done previously to the tile at the sprout's current position (the
; sprout is just moving off, or being destroyed, etc).
vineSprout_restoreTileAtPosition:
	; Return if there's nothing to undo
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret z

	xor a
	ld (de),a ; [var33]

	; Restore tile at this position
	dec e
	ld a,(de) ; [var32]
	ld l,a

	dec e
	ld a,(de) ; [var31]
	ld h,>wRoomLayout
	ld (hl),a

.ifdef REGION_JP
	dec e ; [var30]
	ld a,(de)
	ld h,>wRoomCollisions
	ld (hl),a
.else
	ld h,>wRoomCollisions
	ld (hl),$00
.endif
	ret


;;
; @param[out]	cflag	c if Link is in the sprout
vineSprout_checkLinkInSprout:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.yh
	ld e,Enemy.yh
	ld a,(de)
	sub (hl)
	add $06
	cp $0d
	ret nc

	ld l,SpecialObject.xh
	ld e,Enemy.xh
	ld a,(de)
	sub (hl)
	add $06
	cp $0d
	ret

;;
; @param[out]	a	Sprout's default position
; @param[out]	de	Enemy.subid
vineSprout_getDefaultPosition:
	ld e,Enemy.subid
	ld a,(de)
	ld bc,@defaultVinePositions
	call addAToBc
	ld a,(bc)
	ret

@defaultVinePositions:
	.include {"{GAME_DATA_DIR}/defaultVinePositions.s"}


.ifndef REGION_JP

;;
; @param[out]	c	Sprout's position
vineSprout_getPosition:
	ld e,Enemy.subid
	ld a,(de)
	ld hl,wVinePositions
	rst_addAToHl
	ld c,(hl)

	; Check if the sprout is under a "respawnable tile" (ie. a bush). If so, return to
	; default position.
	ld b,>wRoomLayout
	ld a,(bc)
	ld e,a
	ld hl,@respawnableTiles
-
	ldi a,(hl)
	or a
	ret z
	cp e
	jr nz,-

	call vineSprout_getDefaultPosition
	ld c,a
	ret

@respawnableTiles:
	.db $c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7
	.db $c8 $c9 $ca $00

.endif ; !REGION_JP
