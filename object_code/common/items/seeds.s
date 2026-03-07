;;
; ITEM_EMBER_SEED
; ITEM_SCENT_SEED
; ITEM_PEGASUS_SEED
; ITEM_GALE_SEED
; ITEM_MYSTERY_SEED
;
itemCode20:
itemCode21:
itemCode22:
itemCode23:
itemCode24:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw seedItemState1
	.dw seedItemState2
	.dw seedItemState3

@state0:
	call itemLoadAttributesAndGraphics
	xor a
	call itemSetAnimation
	call objectSetVisiblec1
	call itemIncState
	ld bc,$ffe0
	call objectSetSpeedZ

.ifdef ROM_AGES
	; Subid is nonzero if being used from seed shooter
	ld l,Item.subid
	ld a,(hl)
	or a
	call z,itemUpdateAngle

	ld l,Item.var34
	ld (hl),$03
.else
	call itemUpdateAngle
.endif

	ld l,Item.subid
	ldd a,(hl)
	or a
.ifdef ROM_AGES
	jr nz,@shooter
.else
	jr nz,@slingshot
.endif

	; Satchel
	ldi a,(hl)
	cp ITEM_GALE_SEED
	jr nz,++

	; Gale seed
	ld l,Item.zh
	ld a,(hl)
	add $f8
	ld (hl),a
	ld l,Item.angle
	ld (hl),$ff
	ret
++

.ifdef ROM_AGES
	ld hl,@satchelPositionOffsets
	call applyOffsetTableHL
.endif

	ld a,SPEED_c0
	jr @setSpeed

.ifdef ROM_AGES
@shooter:
	ld e,Item.angle
	ld a,(de)
	rrca
	ld hl,@shooterPositionOffsets
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	ld h,d
	ld l,Item.zh
	ld a,(hl)
	add $fe
	ld (hl),a

	; Since 'd'='h', this will copy its own position and apply the offset
	call objectCopyPositionWithOffset
.else
@slingshot:
	ld hl,@slingshotAngleTable-1
	rst_addAToHl
	ld e,Item.angle
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
.endif

	ld hl,wIsSeedShooterInUse
	inc (hl)
	ld a,SPEED_300

@setSpeed:
	ld e,Item.speed
	ld (de),a
.ifdef ROM_SEASONS
	ld hl,@satchelPositionOffsets
	call applyOffsetTableHL
.endif

	; If it's a mystery seed, get a random effect
	ld e,Item.id
	ld a,(de)
	cp ITEM_MYSTERY_SEED
	ret nz

	call getRandomNumber_noPreserveVars
	and $03
	ld e,Item.var03
	ld (de),a
	add $80|ITEMCOLLISION_EMBER_SEED
	ld e,Item.collisionType
	ld (de),a
	ret

.ifdef ROM_SEASONS
@slingshotAngleTable:
	.db $00 $02 $fe
.endif

; Y/X/Z position offsets relative to Link to make seeds appear at (for satchel)
@satchelPositionOffsets:
	.db $fc $00 $fe ; DIR_UP
	.db $01 $04 $fe ; DIR_RIGHT
	.db $05 $00 $fe ; DIR_DOWN
	.db $01 $fb $fe ; DIR_LEFT

.ifdef ROM_AGES
; Y/X offsets for shooter
@shooterPositionOffsets:
	.db $f2 $fc ; Up
	.db $fc $0b ; Up-right
	.db $05 $0c ; Right
	.db $09 $0b ; Down-right
	.db $0d $03 ; Down
	.db $0a $f8 ; Down-left
	.db $05 $f3 ; Left
	.db $f8 $f8 ; Up-left
.endif

;;
; State 1: seed moving
seedItemState1:
	call itemUpdateDamageToApply
.ifdef ROM_AGES
	jr z,@noCollision

	; Check bit 4 of Item.var2a
	bit 4,a
	jr z,@seedCollidedWithEnemy

	; [Item.var2a] = 0
	ld (hl),$00

	call func_50f4
	jr z,@updatePosition
	jr @seedCollidedWithWall
.else
	jr nz,@seedCollidedWithEnemy
.endif

@noCollision:
	ld e,Item.subid
	ld a,(de)
	or a
	jr z,@satchelUpdate

@slingshotUpdate:
.ifdef ROM_AGES
	call seedItemUpdateBouncing
.else
	call slingshotCheckCanPassSolidTile
.endif
	jr nz,@seedCollidedWithWall

@updatePosition:
.ifdef ROM_AGES
	call objectCheckWithinRoomBoundary
.else
	call objectCheckWithinScreenBoundary
.endif
	jp c,objectApplySpeed
	jp seedItemDelete

@satchelUpdate:
	; Set speed to 0 if landed in water?
	ld h,d
	ld l,Item.var3b
	bit 0,(hl)
	jr z,+
	ld l,Item.speed
	ld (hl),SPEED_0
+
	call objectCheckWithinRoomBoundary
	jp nc,seedItemDelete

	call objectApplySpeed
	ld c,$1c
	call itemUpdateThrowingVerticallyAndCheckHazards
	jp c,seedItemDelete
	ret z

; Landed on ground

	ld a,SND_BOMB_LAND
	call playSound
	call itemAnimate
	ld e,Item.id
	ld a,(de)
	sub ITEM_EMBER_SEED
	rst_jumpTable
	.dw @emberStandard
	.dw @scentLanded
	.dw seedItemDelete
	.dw @galeLanded
	.dw @mysteryStandard


; This activates the seed on collision with something. The behaviour is slightly different
; than when it lands on the ground (which is covered above).
@seedCollidedWithWall:
	call itemAnimate
	ld e,Item.id
	ld a,(de)
	sub ITEM_EMBER_SEED
	rst_jumpTable
	.dw @emberStandard
	.dw @scentOrPegasusCollided
	.dw @scentOrPegasusCollided
	.dw @galeCollidedWithWall
	.dw @mysteryStandard


; Behaviour on collision with enemy; again slightly different
@seedCollidedWithEnemy:
	call itemAnimate
	ld e,Item.collisionType
	xor a
	ld (de),a
	ld e,Item.id
	ld a,(de)
	sub ITEM_EMBER_SEED
	rst_jumpTable
	.dw @emberStandard
	.dw @scentOrPegasusCollided
	.dw @scentOrPegasusCollided
	.dw @galeCollidedWithEnemy
	.dw @mysteryCollidedWithEnemy


@emberStandard:
@galeCollidedWithEnemy:
	call @initState3
	jp objectSetVisible82


@scentLanded:
	ld a,$27
	call @loadGfxVarsWithIndex
	ld a,$02
	call itemSetState
	ld l,Item.collisionType
	res 7,(hl)
	ld a,$01
	call itemSetAnimation
	jp objectSetVisible83


@scentOrPegasusCollided:
	ld e,Item.collisionType
	xor a
	ld (de),a
	jr @initState3


@galeLanded:
	call @breakTileWithGaleSeed

	ld a,$25
	call @loadGfxVarsWithIndex
	ld a,$02
	call itemSetState

	ld l,Item.collisionType
	xor a
	ldi (hl),a

	; Set collisionRadiusY/X
	inc l
	ld a,$02
	ldi (hl),a
	ld (hl),a

	jp objectSetVisible82


@breakTileWithGaleSeed:
	ld a,BREAKABLETILESOURCE_GALE_SEED
	jp itemTryToBreakTile


@galeCollidedWithWall:
	call @breakTileWithGaleSeed
	ld a,$26
	call @loadGfxVarsWithIndex
	ld a,$03
	call itemSetState
	ld l,Item.collisionType
	res 7,(hl)
	jp objectSetVisible82


@mysteryCollidedWithEnemy:
	ld h,d
	ld l,Item.var2a
	bit 6,(hl)
	jr nz,@mysteryStandard

	; Change id to be the random type selected
	ld l,Item.var03
	ldd a,(hl)
	add ITEM_EMBER_SEED
	dec l
	ld (hl),a

	call itemLoadAttributesAndGraphics
	xor a
	call itemSetAnimation
	ld e,Item.health
	ld a,$ff
	ld (de),a
	jp @seedCollidedWithEnemy


@mysteryStandard:
	ld e,Item.collisionType
	xor a
	ld (de),a
	call objectSetVisible82

;;
; Sets state to 3, loads gfx for the new effect, plays sound, sets counter1.
;
@initState3:
	ld e,Item.state
	ld a,$03
	ld (de),a

	ld e,Item.id
	ld a,(de)

;;
; @param	a	Index to use for below table (plus $20, since
;			ITEM_EMBER_SEED=$20)
@loadGfxVarsWithIndex:
	add a
	ld hl,@data-(ITEM_EMBER_SEED*4)
	rst_addDoubleIndex

	ld e,Item.oamFlagsBackup
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ldi a,(hl)
	ld e,Item.counter1
	ld (de),a
	ld a,(hl)
	jp playSound

; b0: value for Item.oamFlags and oamFlagsBackup
; b1: value for Item.oamTileIndexBase
; b2: value for Item.counter1
; b3: sound effect
@data:
	.db $0a $06 $3a SND_LIGHTTORCH
	.db $0b $10 $3c SND_PIRATE_BELL
	.db $09 $18 $00 SND_LIGHTTORCH
	.db $09 $28 $32 SND_GALE_SEED
	.db $08 $18 $00 SND_MYSTERY_SEED

	.db $09 $28 $b4 SND_GALE_SEED
	.db $09 $28 $1e SND_GALE_SEED
	.db $0b $3c $96 SND_SCENT_SEED

;;
seedItemDelete:
	ld e,Item.subid
	ld a,(de)
	or a
	jr z,@delete

	ld hl,wIsSeedShooterInUse
	ld a,(hl)
	or a
	jr z,@delete
	dec (hl)
@delete:
	jp itemDelete


;;
; State 3: typically occurs when the seed collides with a wall or enemy (instead of the
; ground)
seedItemState3:
	ld e,Item.id
	ld a,(de)
	sub ITEM_EMBER_SEED
	rst_jumpTable
	.dw emberSeedBurn
	.dw seedUpdateAnimation
	.dw seedUpdateAnimation
	.dw galeSeedUpdateAnimationAndCounter
	.dw seedUpdateAnimation

emberSeedBurn:
	ld h,d
	ld l,Item.counter1
	dec (hl)
	jr z,@breakTile

	call itemAnimate
	call itemUpdateDamageToApply
	ld l,Item.animParameter
	ld b,(hl)
	jr z,+

	ld l,Item.collisionType
	ld (hl),$00
	bit 7,b
	jr nz,@deleteSelf
+
	ld l,Item.z
	ldi a,(hl)
	or (hl)
	ld c,$1c
	jp nz,objectUpdateSpeedZ_paramC
	bit 6,b
	ret z

	call objectCheckTileAtPositionIsWater
	jr c,@deleteSelf
	ret

@breakTile:
	ld a,BREAKABLETILESOURCE_EMBER_SEED
	call itemTryToBreakTile
@deleteSelf:
	jp seedItemDelete


;;
; Generic update function for seed states 2/3
;
seedUpdateAnimation:
	ld e,Item.collisionType
	xor a
	ld (de),a
	call itemAnimate
	ld e,Item.animParameter
	ld a,(de)
	rlca
	ret nc
	jp seedItemDelete

;;
; State 2: typically occurs when the seed lands on the ground
seedItemState2:
	ld e,Item.id
	ld a,(de)
	sub ITEM_EMBER_SEED
	rst_jumpTable
	.dw emberSeedBurn
	.dw scentSeedSmell
	.dw seedUpdateAnimation
	.dw galeSeedTryToWarpLink
	.dw seedUpdateAnimation

;;
; Scent seed in the "smelling" state that attracts enemies
;
scentSeedSmell:
	ld h,d
	ld l,Item.counter1
	ld a,(wFrameCounter)
	rrca
	jr c,+
	dec (hl)
	jp z,seedItemDelete
+
	; Toggle visibility when counter is low enough
	ld a,(hl)
	cp $1e
	jr nc,+
	ld l,Item.visible
	ld a,(hl)
	xor $80
	ld (hl),a
+
	ld l,Item.yh
	ldi a,(hl)
	ldh (<hFFB2),a
	inc l
	ldi a,(hl)
	ldh (<hFFB3),a

	ld a,$ff
	ld (wScentSeedActive),a
	call itemAnimate
	call bombPullTowardPoint
	jp c,seedItemDelete
	jp itemUpdateSpeedZAndCheckHazards

;;
galeSeedUpdateAnimationAndCounter:
	call galeSeedUpdateAnimation
	call itemDecCounter1
	jp z,seedItemDelete

	; Toggle visibility when almost disappeared
	ld a,(hl)
	cp $14
	ret nc
	ld l,Item.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ret

;;
; Note: for some reason, this tends to be called twice per frame in the
; "galeSeedTryToWarpLink" function, which causes the animation to go over, and it skips
; over some of the palettes?
;
galeSeedUpdateAnimation:
	call itemAnimate
	ld e,Item.counter1
	ld a,(de)
	and $03
	ret nz

	; Cycle through palettes
	ld e,Item.oamFlagsBackup
	ld a,(de)
	inc a
	and $0b
	ld (de),a
	inc e
	ld (de),a
	ret

;;
; Gale seed in its tornado state, will pull in Link if possible
galeSeedTryToWarpLink:
	call galeSeedUpdateAnimation
	ld e,Item.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Test TILESETFLAG_OUTDOORS
	ld a,(wTilesetFlags)
.ifdef ROM_AGES
	rrca
	jr nc,@setSubstate3
.else
	dec a
	jr nz,@setSubstate3
.endif

	; Check warps enabled, Link not riding companion
	ld a,(wWarpsDisabled)
	or a
	jr nz,galeSeedUpdateAnimationAndCounter
	ld a,(wLinkObjectIndex)
	rrca
	jr c,galeSeedUpdateAnimationAndCounter

	; Don't allow warp to occur if holding a very heavy object?
	ld a,(wLinkGrabState2)
	and $f0
	cp $40
	jr z,galeSeedUpdateAnimationAndCounter

.ifdef ROM_AGES
	call checkLinkVulnerableAndIDZero
.else
	call checkLinkID0AndControlNormal
.endif
	jr nc,galeSeedUpdateAnimationAndCounter
	call objectCheckCollidedWithLink
	jr nc,galeSeedUpdateAnimationAndCounter

	ld hl,w1Link
	call objectTakePosition
	ld e,Item.counter2
	ld a,$3c
	ld (de),a
	ld e,Item.substate
	ld a,$01
	ld (de),a
	ld (wMenuDisabled),a
	ld (wLinkCanPassNpcs),a
	ld (wDisableScreenTransitions),a
	ld a,LINK_STATE_SPINNING_FROM_GALE
	ld (wLinkForceState),a
	jp objectSetVisible80

@setSubstate3:
	ld e,Item.substate
	ld a,$03
	ld (de),a
	ret


; Substate 1: Link caught in the gale, but still on the ground
@substate1:
	ld a,(wLinkDeathTrigger)
	or a
	jr nz,@setSubstate3
	ld h,d
	ld l,Item.counter2
	dec (hl)
	jr z,+

	; Only flicker if in group 0??? This causes it to look slightly different when
	; used in the past, as opposed to the present...
	ld a,(wActiveGroup)
	or a
	jr z,@flickerAndCopyPositionToLink
	ret
+
	ld a,$02
	ld (de),a


; Substate 2: Link and gale moving up
@substate2:
	; Move Z position up until it reaches $7f
	ld h,d
	ld l,Item.zh
	dec (hl)
	dec (hl)
	bit 7,(hl)
	jr nz,@flickerAndCopyPositionToLink

	ld a,$02
	ld (w1Link.substate),a
	ld a,CUTSCENE_IN_GALE_SEED_MENU
	ld (wCutsceneTrigger),a

	; Open warp menu, delete self
	ld a,$05
	call openMenu
	jp seedItemDelete

@flickerAndCopyPositionToLink:
	ld e,Item.visible
	ld a,(de)
	xor $80
	ld (de),a

	xor a
	ld (wLinkSwimmingState),a
	ld hl,w1Link
	jp objectCopyPosition


; Substate 3: doesn't warp Link anywhere, just waiting for it to get deleted
@substate3:
	call itemDecCounter2
	jp z,seedItemDelete
	ld l,Item.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ret

.ifdef ROM_AGES
;;
; Called for seeds used with seed shooter. Checks for tile collisions and triggers
; "bounces" when that happens.
;
; @param[out]	zflag	Unset when the seed's "effect" should be activated
seedItemUpdateBouncing:
	call objectGetTileAtPosition
	ld hl,seedsDontBounceTilesTable
	call findByteInCollisionTable
	jr c,@unsetZFlag

	ld e,Item.angle
	ld a,(de)
	bit 2,a
	jr z,@movingStraight

; Moving diagonal

	call seedItemCheckDiagonalCollision

	; Call this just to update var3c/var3d (tile position / index)?
	push af
	call itemCheckCanPassSolidTile
	pop af

	jr z,@setZFlag
	jr @bounce

@movingStraight:
	ld e,Item.var33
	xor a
	ld (de),a
	call objectCheckTileCollision_allowHoles
	jr nc,@setZFlag

	ld e,Item.var33
	ld a,$03
	ld (de),a
	call itemCheckCanPassSolidTile
	jr z,@setZFlag

@bounce:
	call seedItemClearKnockback

	; Decrement bounce counter
	ld h,d
	ld l,Item.var34
	dec (hl)
	jr z,@unsetZFlag

	ld l,Item.var33
	ld a,(hl)
	cp $03
	jr z,@reverseBothComponents

	; Calculate new angle based on whether it was a vertical or horizontal collision
	ld c,a
	ld e,Item.angle
	ld a,(de)
	rrca
	rrca
	and $06
	add c
	ld hl,@angleCalcTable-1
	rst_addAToHl
	ld a,(hl)
	ld (de),a

@setZFlag:
	xor a
	ret

; Flips both X and Y componets
@reverseBothComponents:
	ld l,Item.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	xor a
	ret

@unsetZFlag:
	or d
	ret


; Used for calculating new angle after bounces
@angleCalcTable:
	.db $1c $0c $14 $04 $0c $1c $04 $14

;;
; Called when a seed is moving in a diagonal direction.
;
; Sets var33 such that bits 0 and 1 are set on horizontal and vertical collisions,
; respectively.
;
; @param	a	Angle
; @param[out]	zflag	Unset if the seed should bounce
seedItemCheckDiagonalCollision:
	rrca
	and $0c
	ld hl,@collisionOffsets
	rst_addAToHl
	xor a
	ldh (<hFF8A),a

	; Loop will iterate twice (first for vertical collision, then horizontal).
	ld e,Item.var33
	ld a,$40
	ld (de),a

@nextComponent:
	ld e,Item.yh
	ld a,(de)
	add (hl)
	ld b,a
	inc hl
	ld e,Item.xh
	ld a,(de)
	add (hl)
	ld c,a

	inc hl
	push hl
	call checkTileCollisionAt_allowHoles
	jr nc,@next

; Collision occurred; check whether it should bounce (set carry flag if so)

	call getTileAtPosition
	ld hl,seedsDontBounceTilesTable
	call findByteInCollisionTable
	ccf
	jr nc,@next

	ld h,d
	ld l,Item.angle
	ld b,(hl)
	call checkTileIsPassableFromDirection
	ccf
	jr c,@next
	jr z,@next

	; Bounce if the new elevation would be negative
	ld h,d
	ld l,Item.var3e
	add (hl)
	rlca

@next:
	; Rotate carry bit into var33
	ld h,d
	ld l,Item.var33
	rl (hl)
	pop hl
	jr nc,@nextComponent

	ld e,Item.var33
	ld a,(de)
	or a
	ret


; Offsets from item position to check for collisions at.
; First 2 bytes are offsets for vertical collisions, next 2 are for horizontal.
@collisionOffsets:
	.db $fc $00 $00 $03 ; Up-right
	.db $03 $00 $00 $03 ; Down-right
	.db $03 $00 $00 $fc ; Down-left
	.db $fc $00 $00 $fc ; Up-left


;;
; @param	h,d	Object
; @param[out]	zflag	Set if there are still bounces left?
func_50f4:
	ld e,Item.angle
	ld l,Item.knockbackAngle
	ld a,(de)
	add (hl)
	ld hl,data_5114
	rst_addAToHl
	ld c,(hl)
	ld a,(de)
	cp c
	jr z,seedItemClearKnockback

	ld h,d
	ld l,Item.var34
	dec (hl)
	jr z,@unsetZFlag

	; Set Item.angle
	ld a,c
	ld (de),a
	xor a
	ret

@unsetZFlag:
	or d
	ret

;;
seedItemClearKnockback:
	ld e,Item.knockbackCounter
	xor a
	ld (de),a
	ret


data_5114:
	.db $00 $08 $10 $18 $1c $04 $0c $14
	.db $18 $00 $08 $10 $14 $1c $04 $0c
	.db $10 $18 $00 $08 $0c $14 $1c $04
	.db $08 $10 $18 $00 $04 $0c $14 $1c

.include {"{GAME_DATA_DIR}/tile_properties/seedsDontBounce.s"}

.else ;ROM_SEASONS
;;
; @param[out]	zflag	z if no collision
slingshotCheckCanPassSolidTile:
	call objectCheckTileCollision_allowHoles
	jr nc,++
	call itemCheckCanPassSolidTile
	ret
++
	xor a
	ret
.endif
