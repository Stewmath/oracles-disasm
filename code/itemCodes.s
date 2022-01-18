;;
; ITEMID_EMBER_SEED
; ITEMID_SCENT_SEED
; ITEMID_PEGASUS_SEED
; ITEMID_GALE_SEED
; ITEMID_MYSTERY_SEED
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
	cp ITEMID_GALE_SEED
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
	cp ITEMID_MYSTERY_SEED
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
	sub ITEMID_EMBER_SEED
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
	sub ITEMID_EMBER_SEED
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
	sub ITEMID_EMBER_SEED
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
	ld a,BREAKABLETILESOURCE_0d
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
	add ITEMID_EMBER_SEED
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
;			ITEMID_EMBER_SEED=$20)
@loadGfxVarsWithIndex:
	add a
	ld hl,@data-(ITEMID_EMBER_SEED*4)
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
	sub ITEMID_EMBER_SEED
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
	ld a,BREAKABLETILESOURCE_0c
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
	sub ITEMID_EMBER_SEED
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
	ld hl,seedDontBounceTilesTable
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
	ld hl,seedDontBounceTilesTable
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


; List of tiles which seeds don't bounce off of. (Burnable stuff.)
seedDontBounceTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
	.db $ce $cf $c5 $c5 $c6 $c7 $c8 $c9 $ca
@collisions1:
@collisions3:
@collisions4:
	.db $00

@collisions2:
@collisions5:
	.db TILEINDEX_UNLIT_TORCH
	.db TILEINDEX_LIT_TORCH
	.db $00
.else
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

;;
; This is an object which serves as a collision for enemies when Dimitri does his eating
; attack. Also checks for eatable tiles.
;
; ITEMID_DIMITRI_MOUTH
itemCode2b:
	ld e,Item.state
	ld a,(de)
	or a
	jr nz,+

	; Initialization
	call itemLoadAttributesAndGraphics
	call itemIncState
	ld l,Item.counter1
	ld (hl),$0c
+
	call @calcPosition

	; Check for enemy collision?
	ld h,d
	ld l,Item.var2a
	bit 1,(hl)
	jr nz,@swallow

	ld a,BREAKABLETILESOURCE_DIMITRI_EAT
	call itemTryToBreakTile
	jr c,@swallow

	; Delete self after 12 frames
	call itemDecCounter1
	jr z,@delete
	ret

@swallow:
	; Set var35 to $01 to tell Dimitri to do his swallow animation?
	ld a,$01
	ld (w1Companion.var35),a

@delete:
	jp itemDelete

;;
; Sets the position for this object around Dimitri's mouth.
;
@calcPosition:
	ld a,(w1Companion.direction)
	ld hl,@offsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	ld hl,w1Companion.yh
	jp objectTakePositionWithOffset

@offsets:
	.db $f6 $00 ; DIR_UP
	.db $fe $0a ; DIR_RIGHT
	.db $04 $00 ; DIR_DOWN
	.db $fe $f6 ; DIR_LEFT


;;
; ITEMID_BOMBCHUS
itemCode0d:
	call bombchuCountdownToExplosion

	; If state is $ff, it's exploding
	ld e,Item.state
	ld a,(de)
	cp $ff
	jp nc,itemUpdateExplosion

	call objectCheckWithinRoomBoundary
	jp nc,itemDelete

	call objectSetPriorityRelativeToLink_withTerrainEffects

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr nz,@sidescroll

	; This call will return if the bombchu falls into a hole/water/lava.
	ld c,$20
	call itemUpdateSpeedZAndCheckHazards

	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @tdState0
	.dw @tdState1
	.dw @tdState2
	.dw @tdState3
	.dw @tdState4

@sidescroll:
	ld e,Item.var32
	ld a,(de)
	or a
	jr nz,+

	ld c,$18
	call itemUpdateThrowingVerticallyAndCheckHazards
	jp c,itemDelete
+
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @ssState0
	.dw @ssState1
	.dw @ssState2
	.dw @ssState3


@tdState0:
	call itemLoadAttributesAndGraphics
	call decNumBombchus

	ld h,d
	ld l,Item.state
	inc (hl)

	; var30 used to cycle through possible targets
	ld l,Item.var30
	ld (hl),FIRST_ENEMY_INDEX

	ld l,Item.speedTmp
	ld (hl),SPEED_80

	ld l,Item.counter1
	ld (hl),$10

	; Explosion countdown
	inc l
	ld (hl),$b4

	; Collision radius is used as vision radius before a target is found
	ld l,Item.collisionRadiusY
	ld a,$18
	ldi (hl),a
	ld (hl),a

	; Default "direction to turn" on encountering a hole
	ld l,Item.var31
	ld (hl),$08

	; Initialize angle based on link's facing direction
	ld l,Item.angle
	ld a,(w1Link.direction)
	swap a
	rrca
	ld (hl),a
	ld l,Item.direction
	ld (hl),$ff

	call bombchuSetAnimationFromAngle
	jp bombchuSetPositionInFrontOfLink


; State 1: waiting to reach the ground (if dropped from midair)
@tdState1:
	ld h,d
	ld l,Item.zh
	bit 7,(hl)
	jr nz,++

	; Increment state if on the ground
	ld l,e
	inc (hl)

; State 2: searching for target
@tdState2:
	call bombchuCheckForEnemyTarget
	ret z
++
	call bombchuUpdateSpeed
	call itemUpdateConveyorBelt

@animate:
	jp itemAnimate


; State 3: target found
@tdState3:
	ld h,d
	ld l,Item.counter1
	dec (hl)
	jp nz,itemUpdateConveyorBelt

	; Set counter
	ld (hl),$0a

	; Increment state
	ld l,e
	inc (hl)


; State 4: Dashing toward target
@tdState4:
	call bombchuCheckCollidedWithTarget
	jp c,bombchuClearCounter2AndInitializeExplosion

	call bombchuUpdateVelocity
	call itemUpdateConveyorBelt
	jr @animate


; Sidescrolling states

@ssState0:
	; Do the same initialization as top-down areas
	call @tdState0

	; Force the bombchu to face left or right
	ld e,Item.angle
	ld a,(de)
	bit 3,a
	ret nz

	add $08
	ld (de),a
	jp bombchuSetAnimationFromAngle

; State 1: searching for target
@ssState1:
	ld e,Item.speed
	ld a,SPEED_80
	ld (de),a
	call bombchuCheckForEnemyTarget
	ret z

	; Target not found yet

	call bombchuCheckWallsAndApplySpeed

@ssAnimate:
	jp itemAnimate


; State 2: Target found, wait for a few frames
@ssState2:
	call itemDecCounter1
	ret nz

	ld (hl),$0a

	; Increment state
	ld l,e
	inc (hl)

; State 3: Chase after target
@ssState3:
	call bombchuCheckCollidedWithTarget
	jp c,bombchuClearCounter2AndInitializeExplosion
	call bombchuUpdateVelocityAndClimbing_sidescroll
	jr @ssAnimate


;;
; Updates bombchu's position & speed every frame, and the angle every 8 frames.
;
bombchuUpdateVelocity:
	ld a,(wFrameCounter)
	and $07
	call z,bombchuUpdateAngle_topDown

;;
bombchuUpdateSpeed:
	call @updateSpeed

	; Note: this will actually update the Z position for a second time in the frame?
	; (due to earlier call to itemUpdateSpeedZAndCheckHazards)
	ld c,$18
	call objectUpdateSpeedZ_paramC

	jp objectApplySpeed


; Update the speed based on what kind of tile it's on
@updateSpeed:
	ld e,Item.angle
	call bombchuGetTileCollisions

	cp SPECIALCOLLISION_HOLE
	jr z,@impassableTile

	cp SPECIALCOLLISION_15
	jr z,@impassableTile

	; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	inc a
	jr z,@impassableTile

	; Set the bombchu's speed (halve it if it's on a solid tile)
	dec a
	ld e,Item.speedTmp
	ld a,(de)
	jr z,+

	ld e,a
	ld hl,bounceSpeedReductionMapping
	call lookupKey
+
	; If new speed < old speed, trigger a jump. (Happens when a bombchu starts
	; climbing a wall)
	ld h,d
	ld l,Item.speed
	cp (hl)
	ld (hl),a
	ret nc

	ld l,Item.speedZ
	ld a,$80
	ldi (hl),a
	ld (hl),$ff
	ret

; Bombchus can pass most tiles, even walls, but not holes (perhaps a few other things).
@impassableTile:
	; Item.var31 holds the direction the bombchu should turn to continue moving closer
	; to the target.
	ld h,d
	ld l,Item.var31
	ld a,(hl)
	ld l,Item.angle
	add (hl)
	and $18
	ld (hl),a
	jp bombchuSetAnimationFromAngle

;;
; Get tile collisions at the front end of the bombchu.
;
; @param	e	Angle address (object variable)
; @param[out]	a	Collision value
; @param[out]	hl	Address of collision data
; @param[out]	zflag	Set if there is no collision.
bombchuGetTileCollisions:
	ld h,d
	ld l,Item.yh
	ld b,(hl)
	ld l,Item.xh
	ld c,(hl)

	ld a,(de)
	rrca
	rrca
	ld hl,@offsets
	rst_addAToHl
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a
	jp getTileCollisionsAtPosition

@offsets:
	.db $fc $00 ; DIR_UP
	.db $02 $03 ; DIR_RIGHT
	.db $06 $00 ; DIR_DOWN
	.db $02 $fc ; DIR_LEFT

;;
bombchuUpdateVelocityAndClimbing_sidescroll:
	ld a,(wFrameCounter)
	and $07
	call z,bombchuUpdateAngle_sidescrolling

;;
; In sidescrolling areas, this updates the bombchu's "climbing wall" state.
;
bombchuCheckWallsAndApplySpeed:
	call @updateWallClimbing
	jp objectApplySpeed

;;
@updateWallClimbing:
	ld e,Item.var32
	ld a,(de)
	or a
	jr nz,@climbingWall

	; Return if it hasn't collided with a wall
	ld e,Item.angle
	call bombchuGetTileCollisions
	ret z

	; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	inc a
	jr nz,+

	; Reverse direction if it runs into such a tile
	ld e,Item.angle
	ld a,(de)
	xor $10
	ld (de),a
	jp bombchuSetAnimationFromAngle
+
	; Tell it to start climbing the wall
	ld h,d
	ld l,Item.angle
	ld a,(hl)
	ld (hl),$00
	ld l,Item.var33
	ld (hl),a
	ld l,Item.var32
	ld (hl),$01
	jp bombchuSetAnimationFromAngle

@climbingWall:
	; Check if the bombchu is still touching the wall it's supposed to be climbing
	ld e,Item.var33
	call bombchuGetTileCollisions
	jr nz,@@touchingWall

	; Bombchu is no longer touching the wall it's climbing. It will now "uncling"; the
	; following code figures out which direction to make it face.
	; The direction will be the "former angle" (var33) unless it's on the ceiling, in
	; which case, it will just continue in its current direction.

	ld h,d
	ld l,Item.angle
	ld e,Item.var33
	ld a,(de)
	or a
	jr nz,+

	ld a,(hl)
	ld e,Item.var33
	ld (de),a
+
	; Revert to former angle and uncling
	ld a,(de)
	ld (hl),a
	ld l,Item.var32
	xor a
	ldi (hl),a
	inc l
	ld (hl),a

	; Clear vertical speed
	ld l,Item.speedZ
	ldi (hl),a
	ldi (hl),a

	ld l,Item.direction
	ld (hl),$ff
	jp bombchuSetAnimationFromAngle

@@touchingWall:
	; Check if it hits a wall
	ld e,Item.angle
	call bombchuGetTileCollisions
	ret z

	; If so, try to cling to it
	ld h,d
	ld l,Item.angle
	ld b,(hl)
	ld e,Item.var33
	ld a,(de)
	xor $10
	ld (hl),a

	; If both the new and old angles are horizontal, stop clinging to the wall?
	bit 3,a
	jr z,+
	bit 3,b
	jr z,+

	ld l,Item.var32
	ld (hl),$00
+
	; Set var33
	ld a,b
	ld (de),a

	; If a==0 (old angle was "up"), the bombchu will cling to the ceiling (var34 will
	; be nonzero).
	or a
	ld l,Item.var34
	ld (hl),$00
	jr nz,bombchuSetAnimationFromAngle
	inc (hl)
	jr bombchuSetAnimationFromAngle

;;
; Sets the bombchu's angle relative to its target.
;
bombchuUpdateAngle_topDown:
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	call objectGetRelativeAngle

	; Turn the angle into a cardinal direction, set that to the bombchu's angle
	ld b,a
	add $04
	and $18
	ld e,Item.angle
	ld (de),a

	; Write $08 or $f8 to Item.var31, depending on which "side" the bombchu will need
	; to turn towards later?
	sub b
	and $1f
	cp $10
	ld a,$08
	jr nc,+
	ld a,$f8
+
	ld e,Item.var31
	ld (de),a

;;
; If [Item.angle] != [Item.direction], this updates the item's animation. The animation
; index is 0-3 depending on the item's angle (or sometimes it's 4-5 if var34 is set).
;
; Note: this sets the direction to equal the angle value, which is non-standard (usually
; the direction is a value from 0-3, not from $00-$1f).
;
; Also, this assumes that the item's angle is a cardinal direction?
;
bombchuSetAnimationFromAngle:
	ld h,d
	ld l,Item.direction
	ld e,Item.angle
	ld a,(de)
	cp (hl)
	ret z

	; Update Item.direction
	ld (hl),a

	; Convert angle to a value from 0-3. (Assumes that the angle is a cardinal
	; direction?)
	swap a
	rlca

	ld l,Item.var34
	bit 0,(hl)
	jr z,+
	dec a
	ld a,$04
	jr z,+
	inc a
+
	jp itemSetAnimation

;;
; Sets up a bombchu's angle toward its target such that it will only move along its
; current axis; so if it's moving along the X axis, it will chase on the X axis, and
; vice-versa.
;
bombchuUpdateAngle_sidescrolling:
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	call objectGetRelativeAngle

	ld b,a
	ld e,Item.angle
	ld a,(de)
	bit 3,a
	ld a,b
	jr nz,@leftOrRight

; Bombchu facing up or down

	sub $08
	and $1f
	cp $10
	ld a,$00
	jr c,@setAngle
	ld a,$10
	jr @setAngle

; Bombchu facing left or right
@leftOrRight:
	cp $10
	ld a,$08
	jr c,@setAngle
	ld a,$18

@setAngle:
	ld e,Item.angle
	ld (de),a
	jr bombchuSetAnimationFromAngle

;;
; Set a bombchu's position to be slightly in front of Link, based on his direction. If it
; would put the item in a wall, it will default to Link's exact position instead.
;
; @param[out]	zflag	Set if the item defaulted to Link's exact position due to a wall
bombchuSetPositionInFrontOfLink:
	ld hl,w1Link.yh
	ld b,(hl)
	ld l,<w1Link.xh
	ld c,(hl)

	ld a,(wActiveGroup)
	cp FIRST_SIDESCROLL_GROUP
	ld l,<w1Link.direction
	ld a,(hl)

	ld hl,@normalOffsets
	jr c,+
	ld hl,@sidescrollOffsets
+
	; Set the item's position to [Link's position] + [Offset from table]
	rst_addDoubleIndex
	ld e,Item.yh
	ldi a,(hl)
	add b
	ld (de),a
	ld e,Item.xh
	ld a,(hl)
	add c
	ld (de),a

	; Check if it's in a wall
	push bc
	call objectGetTileCollisions
	pop bc
	cp $0f
	ret nz

	; If the item would end up on a solid tile, put it directly on Link instead
	; (ignore the offset from the table)
	ld a,c
	ld (de),a
	ld e,Item.yh
	ld a,b
	ld (de),a
	ret

; Offsets relative to Link where items will appear

@normalOffsets:
	.db $f4 $00 ; DIR_UP
	.db $02 $0c ; DIR_RIGHT
	.db $0c $00 ; DIR_DOWN
	.db $02 $f4 ; DIR_LEFT

@sidescrollOffsets:
	.db $00 $00 ; DIR_UP
	.db $02 $0c ; DIR_RIGHT
	.db $00 $00 ; DIR_DOWN
	.db $02 $f4 ; DIR_LEFT


;;
; Bombchus call this every frame.
;
bombchuCountdownToExplosion:
	call itemDecCounter2
	ret nz

;;
bombchuClearCounter2AndInitializeExplosion:
	ld e,Item.counter2
	xor a
	ld (de),a
	jp itemInitializeBombExplosion

;;
; @param[out]	cflag	Set on collision or if the enemy has died
bombchuCheckCollidedWithTarget:
	ld a,Object.health
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	scf
	ret z
	jp checkObjectsCollided

;;
; Each time this is called, it checks one enemy and sets it as the target if it meets all
; the conditions (close enough, valid target, etc).
;
; Each time it loops through all enemies, the bombchu's vision radius increases.
;
; @param[out]	zflag	Set if a valid target is found
bombchuCheckForEnemyTarget:
	; Check if the target enemy is enabled
	ld e,Item.var30
	ld a,(de)
	ld h,a
	ld l,Enemy.enabled
	ld a,(hl)
	or a
	jr z,@nextTarget

	; Check it's visible
	ld l,Enemy.visible
	bit 7,(hl)
	jr z,@nextTarget

	; Check it's a valid target (see data/bombchuTargets.s)
	ld l,Enemy.id
	ld a,(hl)
	push hl
	ld hl,bombchuTargets
	call checkFlag
	pop hl
	jr z,@nextTarget

	; Check if it's within the bombchu's "collision radius" (actually used as vision
	; radius)
	call checkObjectsCollided
	jr nc,@nextTarget

	; Valid target established; set relatedObj2 to the target
	ld a,h
	ld h,d
	ld l,Item.relatedObj2+1
	ldd (hl),a
	ld (hl),Enemy.enabled

	; Stop using collision radius as vision radius
	ld l,Item.collisionRadiusY
	ld a,$06
	ldi (hl),a
	ld (hl),a

	; Set counter1, speedTmp
	ld l,Item.counter1
	ld (hl),$0c
	ld l,Item.speedTmp
	ld (hl),SPEED_1c0

	; Increment state
	ld l,Item.state
	inc (hl)

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr nz,+

	call bombchuUpdateAngle_topDown
	xor a
	ret
+
	call bombchuUpdateAngle_sidescrolling
	xor a
	ret

@nextTarget:
	; Increment target enemy index by one
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,+

	; Looped through all enemies
	call @incVisionRadius
	ld a,FIRST_ENEMY_INDEX
+
	ld e,Item.var30
	ld (de),a
	or d
	ret

@incVisionRadius:
	; Increase collisionRadiusY/X by increments of $10, but keep it below $70. (these
	; act as the bombchu's vision radius)
	ld e,Item.collisionRadiusY
	ld a,(de)
	add $10
	cp $60
	jr c,+
	ld a,$18
+
	ld (de),a
	inc e
	ld (de),a
	ret

.include "build/data/bombchuTargets.s"

;;
; ITEMID_BOMB
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

.ifdef ROM_AGES
	; Check if room $0050 (Present overworld, bomb upgrade screen)
	ld bc,$0050
.else
	ld bc,$04ef
.endif
	ld a,(wActiveGroup)
	cp b
	jr nz,@delete
	ld a,(wActiveRoom)
	cp c
	jr nz,@delete

	; If so, trigger a cutscene?
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
	cp ITEMID_BOMB
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
	cp SPECIALOBJECTID_MINECART
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

	ld a,BREAKABLETILESOURCE_04
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

;;
; ITEMID_BOOMERANG
itemCode06:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call itemLoadAttributesAndGraphics
.ifdef ROM_AGES
	ld a,UNCMP_GFXH_18
.else
	ld e,Item.subid
	ld a,(de)
	add UNCMP_GFXH_18 ; Either this or UNCMP_GFXH_19
.endif
	call loadWeaponGfx

	call itemIncState

.ifdef ROM_AGES
	ld l,Item.speed
	ld (hl),SPEED_1a0

	ld l,Item.counter1
	ld (hl),$28
.else
	ld bc,(SPEED_1a0<<8)|$28
	ld l,Item.subid
	bit 0,(hl)
	jr z,+

	; level-2
	ld l,Item.collisionType
	ld (hl),$80|ITEMCOLLISION_L2_BOOMERANG
	ld l,Item.oamFlagsBackup
	ld a,$0c
	ldi (hl),a
	ldi (hl),a
	ld bc,(SPEED_260<<8)|$78
+
	ld l,Item.speed
	ld (hl),b
	ld l,Item.counter1
	ld (hl),c
.endif

	ld c,-1
	ld a,RANG_RING_L1
	call cpActiveRing
	jr z,+

	ld a,RANG_RING_L2
	call cpActiveRing
	jr nz,++
	ld c,-2
+
	; One of the rang rings are equipped; damage output increased (value of 'c')
	ld l,Item.damage
	ld a,(hl)
	add c
	ld (hl),a
++
	call objectSetVisible82
	xor a
	jp itemSetAnimation


; State 1: boomerang moving outward
@state1:
.ifdef ROM_SEASONS
	call magicBoomerangTryToBreakTile
.endif

	ld e,Item.var2a
	ld a,(de)
	or a
	jr nz,@returnToLink

	call objectCheckTileCollision_allowHoles
	jr nc,@noCollision
	call itemCheckCanPassSolidTile
	jr nz,@hitWall

@noCollision:
	call objectCheckWithinRoomBoundary
	jr nc,@returnToLink

	; Nudge angle toward a certain value. (Is this for the magical boomerang?)
	ld e,Item.var34
	ld a,(de)
	call objectNudgeAngleTowards

	; Decrement counter until boomerang must return
	call itemDecCounter1
	jr nz,@updateSpeedAndAnimation

; Decide on the angle to change to, then go to the next state
@returnToLink:
	call objectGetAngleTowardLink
	ld c,a

	; If the boomerang's Y or X has gone below 0 (above $f0), go directly to link?
	ld h,d
	ld l,Item.yh
	ld a,$f0
	cp (hl)
	jr c,@@setAngle
	ld l,Item.xh
	cp (hl)
	jr c,@@setAngle

	; If the boomerang is already moving in Link's general direction, don't bother
	; changing the angle?
	ld l,Item.angle
	ld a,c
	sub (hl)
	add $08
	cp $11
	jr c,@nextState

@@setAngle:
	ld l,Item.angle
	ld (hl),c
	jr @nextState

@hitWall:
	call objectCreateClinkInteraction

	; Reverse direction
	ld h,d
	ld l,Item.angle
	ld a,(hl)
	xor $10
	ld (hl),a

@nextState:
	ld l,Item.state
	inc (hl)

	; Clear link to parent item
	ld l,Item.relatedObj1
	xor a
	ldi (hl),a
	ld (hl),a

	jr @updateSpeedAndAnimation


; State 2: boomerang returning to Link
@state2:
	call objectGetAngleTowardLink
	call objectNudgeAngleTowards

	; Increment state if within 10 pixels of Link
	ld bc,$140a
	call itemCheckWithinRangeOfLink
	call c,itemIncState

	jr @breakTileAndUpdateSpeedAndAnimation


; State 3: boomerang within 10 pixels of link; move directly toward him instead of nudging
; the angle.
@state3:
	call objectGetAngleTowardLink
	ld e,Item.angle
	ld (de),a

	; Check if within 2 pixels of Link
	ld bc,$0402
	call itemCheckWithinRangeOfLink
	jr nc,@breakTileAndUpdateSpeedAndAnimation

	; Go to state 4, make invisible, disable collisions
	call itemIncState
	ld l,Item.counter1
	ld (hl),$04
	ld l,Item.collisionType
	ld (hl),$00
	jp objectSetInvisible


; Stays in this state for 4 frames before deleting itself. I guess this creates a delay
; before the boomerang can be used again?
@state4:
	call itemDecCounter1
	jp z,itemDelete

	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.yh
	jp objectTakePosition

@breakTileAndUpdateSpeedAndAnimation:
.ifdef ROM_SEASONS
	call magicBoomerangTryToBreakTile
.endif

@updateSpeedAndAnimation:
	call objectApplySpeed
	ld h,d
	ld l,Item.animParameter
	ld a,(hl)
	or a
	ld (hl),$00

	; Play sound when animParameter is nonzero
	ld a,SND_BOOMERANG
	call nz,playSound

	jp itemAnimate

.ifdef ROM_SEASONS
magicBoomerangTryToBreakTile:
	ld e,Item.subid
	ld a,(de)
	or a
	ret z

	; level-2
	ld a,BREAKABLETILESOURCE_07
	jp itemTryToBreakTile
.endif

;;
; Assumes that both objects are of the same size (checks top-left positions)
;
; @param	b	Should be double the value of c
; @param	c	Range to be within
; @param[out]	cflag	Set if within specified range of link
itemCheckWithinRangeOfLink:
	ld hl,w1Link.yh
	ld e,Item.yh
	ld a,(de)
	sub (hl)
	add c
	cp b
	ret nc

	ld l,<w1Link.xh
	ld e,Item.xh
	ld a,(de)
	sub (hl)
	add c
	cp b
	ret

.ifdef ROM_AGES
;;
; The chain on the switch hook; cycles between 3 intermediate positions
;
; ITEMID_SWITCH_HOOK_CHAIN
itemCode0bPost:
	ld a,(w1WeaponItem.id)
	cp ITEMID_SWITCH_HOOK
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
; ITEMID_SWITCH_HOOK_CHAIN
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
; ITEMID_SWITCH_HOOK
itemCode0aPost:
	call cpRelatedObject1ID
	ret z

	ld a,(wSwitchHookState)
	or a
	jp z,itemDelete

	jp func_5902

;;
; ITEMID_SWITCH_HOOK
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
	ld (hl),ITEMID_SWITCH_HOOK_CHAIN

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
; Uses w1ReservedItemE as ITEMID_SWITCH_HOOK_HELPER to hold the positions for link and the
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
	cp INTERACID_PUSHBLOCK
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
	ld (hl),ITEMID_SWITCH_HOOK_HELPER

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
; ITEMID_SWITCH_HOOK_HELPER
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
	cp ITEMID_SWITCH_HOOK
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
.endif

;;
; ITEMID_RICKY_TORNADO
itemCode2a:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1


; State 0: initialization
@state0:
	call itemIncState
	ld l,Item.speed
	ld (hl),SPEED_300

	ld a,(w1Companion.direction)
	ld c,a
	swap a
	rrca
	ld l,Item.angle
	ld (hl),a

	; Get offset from companion position to spawn at in 'bc'
	ld a,c
	ld hl,@offsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	; Copy companion's position
	ld hl,w1Companion.yh
	call objectTakePositionWithOffset

	; Make Z position 2 higher than companion
	sub $02
	ld (de),a

	call itemLoadAttributesAndGraphics
	xor a
	call itemSetAnimation
	jp objectSetVisiblec1

@offsets:
	.db $f0 $00 ; DIR_UP
	.db $00 $0c ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f4 ; DIR_LEFT


; State 1: flying away until it hits something
@state1:
	call objectApplySpeed

	ld a,BREAKABLETILESOURCE_SWORD_L1
	call itemTryToBreakTile

	call objectGetTileCollisions
	and $0f
	cp $0f
	jp z,itemDelete

	jp itemAnimate

;;
; ITEMID_MAGNET_BALL
; Variables:
;   var03: Disables collisions and uses custom code to prevent enemies passing 
;		   through it (for wall flame shooters)
;   var30/var31: Set to initial yh,xh to reset ball's position in wStaticObjects
;                if ball fell in hole
;   var32: boolean that restricts friction from its max of SPEED_300 to SPEED_100
;   var33: vertical friction - the higher, the faster
;   var34: horizontal friction
itemCode29:
.ifdef ROM_SEASONS
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @unitialized
	.dw @mainState
	.dw @fallingDownCliff

@unitialized:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,Item.speed
	ld (hl),SPEED_40
	ld l,Item.yh
	ld a,(hl)
	ld b,a
	ld l,Item.xh
	ld a,(hl)
	ld l,Item.var31
	ldd (hl),a
	ld (hl),b
	call itemLoadAttributesAndGraphics
	xor a
	call itemSetAnimation
	call objectSetVisiblec3

    ; Room with the wall flame shooters
	ld a,(wActiveGroup)
	cp >ROOM_SEASONS_494
	jr nz,@mainState
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_494
	jr nz,@mainState
	ld e,Item.var03
	ld a,$01
	ld (de),a

@mainState:
	call @mainStateBody
	call @applySpeedIfNoCollision
	ld e,Item.collisionType
	ld a,(de)
	bit 7,a
	ret nz
	jp @blockAllWallFlameShooters

; Saves ball's position, deals with collision with Link, cliffs and holes,
; slows down if not hooked on to, checks if hooked on to, move the ball if hooked,
; begin attracting or repelling the ball
@mainStateBody:
	ld h,d
	ld l,Item.var03
	ld a,(hl)
	or a
	jr nz,+
	ld l,Item.collisionType
	res 7,(hl)
+
	call @savePositionInStaticObjects
	call @preventLinkFromPassing
	ld a,(wMagnetGloveState)
	or a
	jp z,@slowDownCheckCliffHolesAndRoomBoundary
	ld b,$0c
	call objectCheckCenteredWithLink
	jp nc,@slowDownCheckCliffHolesAndRoomBoundary
	
	; store in b 0-3 based on opposite angle towards Link
	call objectGetAngleTowardLink
	add $04
	add a
	swap a
	and $03
	xor $02
	ld b,a
	
	ld a,(w1Link.direction)
	cp b
	jp nz,@slowDownCheckCliffHolesAndRoomBoundary
	
	; Link facing ball, using magnet gloves, and near enough to ball
	ld e,Item.speed
	ld a,SPEED_100
	ld (de),a
	ld e,Item.var32
	ld a,(de)
	or a
	jr z,+
	; Item.var33
	inc e
	ld a,(de)
	cp $10
	jp nc,@slowDownCheckCliffHolesAndRoomBoundary
	; Item.var34
	inc e
	ld a,(de)
	cp $10
	jp nc,@slowDownCheckCliffHolesAndRoomBoundary
	ld e,Item.var32
	xor a
	ld (de),a
+
	ld a,(wMagnetGloveState)
	bit 1,a
	jr nz,@repelBall
	
	; attract ball
	ld a,(w1Link.direction)
	ld hl,@linksRelativePositionForFF8D_FF8CbasedOnLinkDirection
	rst_addDoubleIndex
	ld a,(w1Link.yh)
	add (hl)
	ldh (<hFF8D),a
	inc hl
	ld a,(w1Link.xh)
	add (hl)
	ldh (<hFF8C),a
	push bc
	call @checkLinkInBallsPosition
	pop bc
	jp c,@moveBallCheckCliffsAndRoomBoundary

	bit 0,b
	jr nz,+
	call @horizontalAttractBall
	ld e,Item.state
	ld a,(de)
	cp $01
	ret nz
	call @incVar33IfNotff
	call @applySpeedBasedOnVar33
	jp @verticalAttractBall
+
	call @verticalAttractBall
	ld e,Item.state
	ld a,(de)
	cp $01
	ret nz
	call @incVar34IfNotff
	call @applySpeedBasedOnVar34
	jp @horizontalAttractBall

@repelBall:
	ld a,(w1Link.yh)
	ldh (<hFF8D),a
	ld a,(w1Link.xh)
	ldh (<hFF8C),a
	bit 0,b
	jr nz,+
	call @horizontalAttractBall
	ld e,Item.state
	ld a,(de)
	cp $01
	ret nz
	call @incVar33IfNotff
	call @applySpeedBasedOnVar33
	jp @verticalRepelBall
+
	call @verticalAttractBall
	ld e,Item.state
	ld a,(de)
	cp $01
	ret nz
	call @incVar34IfNotff
	call @applySpeedBasedOnVar34
	jp @horizontalRepelBall

@slowDownCheckCliffHolesAndRoomBoundary:
	ld e,Item.var33
	ld a,(de)
	or a
	jr z,+
	ld e,Item.var32
	ld a,$01
	ld (de),a
	call @keepVar33LessThan40_decVar33IfNot0
	call @keepVar33LessThan40_decVar33IfNot0
	call @applySpeedBasedOnVar33
	ld e,Item.angle
	ld a,(de)
	call @checkBallShouldBeDroppedOffCliffOrLeavingRoom
+
	ld e,Item.var34
	ld a,(de)
	or a
	jr z,+
	ld e,Item.var32
	ld a,$01
	ld (de),a
	call @keepVar34LessThan40_decVar34IfNot0
	call @keepVar34LessThan40_decVar34IfNot0
	call @applySpeedBasedOnVar34
	ld e,Item.angle
	ld a,(de)
	call @checkBallShouldBeDroppedOffCliffOrLeavingRoom
+
	call objectCheckIsOnHazard
	jp c,@ballDropped_positionResetOnRoomReentry
	ret

@ballDropped_positionResetOnRoomReentry:
	ldh (<hFF8B),a
	call @saveInitialPositionInStaticObjects
	ldh a,(<hFF8B)
	dec a
	jp z,objectReplaceWithSplash
	jp objectReplaceWithFallingDownHoleInteraction

@moveBallCheckCliffsAndRoomBoundary:
	xor a
	ld e,Item.var33
	ld (de),a
	ld e,Item.var34
	ld (de),a
	
	ld a,(wLinkAngle)
	cp $ff
	ret z
	
	ld a,(wGameKeysPressed)
	ld b,a
	bit BTN_BIT_UP,b
	jr z,+
	ld a,ANGLE_UP
	call @setAngleAndCheckBallShouldBeDroppedOffCliffOrLeavingRoom
	jr ++

+
	bit BTN_BIT_DOWN,b
	jr z,++
	ld a,ANGLE_DOWN
	call @setAngleAndCheckBallShouldBeDroppedOffCliffOrLeavingRoom
++
	ld a,(wGameKeysPressed)
	ld b,a
	bit BTN_BIT_RIGHT,b
	jr z,+
	ld a,ANGLE_RIGHT
	jr @setAngleAndCheckBallShouldBeDroppedOffCliffOrLeavingRoom
+
	bit BTN_BIT_LEFT,b
	ld a,ANGLE_LEFT
	ret z

@setAngleAndCheckBallShouldBeDroppedOffCliffOrLeavingRoom:
	ld e,Item.angle
	ld (de),a
	jp @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@checkLinkInBallsPosition:
	ldh a,(<hFF8D)
	ld b,a
	ldh a,(<hFF8C)
	ld c,a
	jp objectCheckContainsPoint

@fallingDownCliff:
	ld h,d
	ld l,Item.collisionType
	set 7,(hl)
	ld l,Item.direction
	ldi a,(hl)
	; Item.angle
	ld (hl),a
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld a,SND_DROPESSENCE
	call playSound
	ld h,d
	ld l,Item.counter1
	dec (hl)
	jr z,+
	ld bc,$ff20
	ld l,Item.speedZ
	ld (hl),c
	inc l
	ld (hl),b
	ld l,Item.speed
	ld (hl),$14
	ret
+
	ld a,$01
	ld e,Item.state
	ld (de),a
	ret

@linksRelativePositionForFF8D_FF8CbasedOnLinkDirection:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

@verticalAttractBall:
	ld b,ANGLE_UP
	ld c,ANGLE_DOWN
	call @loadBIntoAngleIfLinkAboveBallElseLoadC
	ret z
	jr @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@horizontalAttractBall:
	ld b,ANGLE_LEFT
	ld c,ANGLE_RIGHT
	call @loadBIntoAngleIfLinkLeftOfBallElseLoadC
	ret z
	jr @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@verticalRepelBall:
	ld b,ANGLE_DOWN
	ld c,ANGLE_UP
	call @loadBIntoAngleIfLinkAboveBallElseLoadC
	ret z
	jr @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@horizontalRepelBall:
	ld b,ANGLE_RIGHT
	ld c,ANGLE_LEFT
	call @loadBIntoAngleIfLinkLeftOfBallElseLoadC
	ret z
	jr @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@loadBIntoAngleIfLinkAboveBallElseLoadC:
	ldh a,(<hFF8D)
	ld l,Item.yh
	ld e,Item.var33
-
	ld h,d
	cp (hl)
	ld a,b
	jr c,+
	ld a,c
+
	ld l,Item.angle
	ld (hl),a
	ret

@loadBIntoAngleIfLinkLeftOfBallElseLoadC:
	ldh a,(<hFF8C)
	ld l,Item.xh
	ld e,Item.var34
	jr -

@checkBallShouldBeDroppedOffCliffOrLeavingRoom:
	srl a
	ld hl,@positionOf2TilesJustAheadOfBall
	rst_addAToHl
	call @checkRelativeHLTileCollision_allowHoles
	jr c,+
	call @checkRelativeHLTileCollision_allowHoles
	jr c,+
	ld h,d
	ld l,Item.collisionType
	set 7,(hl)
	call objectApplySpeed
	jr @preventFromLeavingRoom
+
	call @checkBallShouldBeDroppedOffCliff
	; var33 is set to 0 if angle is N/S
	; var34 is set to 0 if angle is E/W
	ld e,Item.angle
	ld a,(de)
	bit 3,a
	ld e,Item.var33
	jr z,+
	; Item.var34
	inc e
+
	xor a
	ld (de),a
	ret

@checkRelativeHLTileCollision_allowHoles:
	ld e,Item.yh
	ld a,(de)
	add (hl)
	inc hl
	ld b,a
	ld e,Item.xh
	ld a,(de)
	add (hl)
	inc hl
	ld c,a
	push hl
	call checkTileCollisionAt_allowHoles
	pop hl
	ret

@positionOf2TilesJustAheadOfBall:
	.db $f8 $fc $f8 $04
	.db $fc $08 $04 $08
	.db $08 $fc $08 $04
	.db $fc $f8 $04 $f8

@applySpeedIfNoCollision:
	call objectGetTileAtPosition
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	ret nc
	call objectGetPosition
	ld a,$05
	add b
	ld b,a
	call checkTileCollisionAt_allowHoles
	ret nc
	ld b,SPEED_80
	call @loadBIntoItemSpeed
	ld e,Item.angle
	xor a
	ld (de),a
	jp objectApplySpeed

@preventFromLeavingRoom:
	; max yh, xh
	ldbc $a8 $e8
	ld e,$08
	ld h,d
	ld l,Item.yh
	ld a,e
	cp (hl)
	jr c,+
	ld (hl),a
+
	ld a,b
	cp (hl)
	jr nc,+
	ld (hl),a
+
	ld l,Item.xh
	ld a,e
	cp (hl)
	jr c,+
	ld (hl),a
+
	ld a,c
	cp (hl)
	ret nc
	ld (hl),a
	ret

@applySpeedBasedOnVar33:
	ld e,Item.var33
--
	ld a,(de)
	cp $40
	ld b,SPEED_300
	jr nc,@loadBIntoItemSpeed
	and $38
	swap a
	rlca
	ld hl,@magnetBallSpeeds
	rst_addAToHl
	ld b,(hl)

@loadBIntoItemSpeed:
	ld a,b
	ld e,Item.speed
	ld (de),a
	ret

@applySpeedBasedOnVar34:
	ld e,Item.var34
	jr --

; moves faster the longer you've interacted with it
@magnetBallSpeeds:
	.db SPEED_040
	.db SPEED_080
	.db SPEED_100
	.db SPEED_140
	.db SPEED_180
	.db SPEED_1c0
	.db SPEED_200
	.db SPEED_200

@incVar33IfNotff:
	ld h,d
	ld l,Item.var33
	inc (hl)
	ret nz
	dec (hl)
	ret

@incVar34IfNotff:
	ld h,d
	ld l,Item.var34
	inc (hl)
	ret nz
	dec (hl)
	ret

@keepVar33LessThan40_decVar33IfNot0:
	ld l,Item.var33
--
	ld h,d
	ld a,(hl)
	cp $40
	jr c,+
	ld a,$40
+
	or a
	ret z
	dec a
	ld (hl),a
	ret

@keepVar34LessThan40_decVar34IfNot0:
	ld l,Item.var34
	jr --

@retCIfTileAtRelativePositionHLIsTopOfCliff:
	ld e,Item.yh
	ld a,(de)
	add (hl)
	inc hl
	ld b,a
	ld e,Item.xh
	ld a,(de)
	add (hl)
	inc hl
	ld c,a
	push hl
	call getTileAtPosition
	pop hl
	sub $b0
	cp $04
	ret

@checkBallShouldBeDroppedOffCliff:
	call @convertAngleTo0To3
	add a
	ld hl,@positionOf2TilesJustAheadOfBall
	rst_addDoubleIndex
	call @retCIfTileAtRelativePositionHLIsTopOfCliff
	ret nc
	call @retCIfTileAtRelativePositionHLIsTopOfCliff
	ret nc
	; a is the type of wall from 0 to 3
	add $02
	and $03
	swap a
	rrca
	ld b,a
	ld e,Item.angle
	ld a,(de)
	cp b
	ret nz
	sra a
	
	ld hl,@cliffDropData
	rst_addAToHl
	ldi a,(hl)
	ld e,Item.direction
	ld (de),a
	ldi a,(hl)
	ld e,Item.speed
	ld (de),a
	ldi a,(hl)
	ld e,Item.speedZ
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	
	; reset var32 - var34
	xor a
	ld h,d
	ld l,Item.var32
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	
	ld l,Item.counter1
	ld (hl),$02
	ld l,Item.state
	ld (hl),$02
	ret

@cliffDropData:
	dbbw ANGLE_UP    SPEED_100 $fe40
	dbbw ANGLE_RIGHT SPEED_100 $fe40
	dbbw ANGLE_DOWN  SPEED_100 $fe40
	dbbw ANGLE_LEFT  SPEED_100 $fe40

@convertAngleTo0To3:
	ld e,Item.angle
	ld a,(de)
	add $04
	add a
	swap a
	and $03
	ret

@blockAllWallFlameShooters:
	ldhl FIRST_ENEMY_INDEX, Enemy.start
-
	ld a,(hl)
	or a
	call nz,@blockWallFlameShooter
	inc h
	ld a,h
	cp $e0
	jr c,-
	ret

@blockWallFlameShooter:
	push hl
	ld l,Enemy.zh
	bit 7,(hl)
	call z,preventObjectHFromPassingObjectD
	pop hl
	ret

@saveInitialPositionInStaticObjects:
	ld e,Item.var30 ; yh
	ld a,(de)
	ld b,a
	; Item.var31 ; xh
	inc e
	ld a,(de)
	ld c,a
	jr +

@savePositionInStaticObjects:
	call objectCheckIsOnHazard
	ret c
	ld e,Item.yh
	ld a,(de)
	ld b,a
	ld e,Item.xh
	ld a,(de)
	ld c,a
+
	ld e,Item.relatedObj1
	ld a,(de)
	ld l,a
	inc e
	ld a,(de)
	ld h,a
	push bc
	ld bc,$0004
	add hl,bc
	pop bc
	; Make sure magnet ball is not too close to room edges so Link can walk in
	ld a,b
	cp $18
	jr nc,+
	ld a,$18
+
	cp $99
	jr c,+
	ld a,$98
+
	ldi (hl),a
	ld a,c
	cp $18
	jr nc,+
	ld a,$18
+
	cp $d9
	jr c,+
	ld a,$d8
+
	ld (hl),a
	ret

@preventLinkFromPassing:
	ld a,(wLinkInAir)
	rlca
	ret c
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	call objectCheckCollidedWithLink_ignoreZ
	ret nc
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	call objectCheckContainsPoint
	jr c,+
	call objectGetAngleTowardLink
	ld c,a
	ld b,SPEED_300
	jp updateLinkPositionGivenVelocity
+
	call objectGetAngleTowardLink
	ld c,a
	ld b,SPEED_080
	jp updateLinkPositionGivenVelocity

.else; ROM_AGES

;;
; ITEMID_SHOOTER
itemCode0f:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,UNCMP_GFXH_AGES_1d
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	ld e,Item.var30
	ld a,$ff
	ld (de),a
	jp objectSetVisible81

@state1:
	ret


;;
; ITEMID_SHOOTER
itemCode0fPost:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld hl,@data
	call itemInitializeFromLinkPosition

	; Copy link Z position
	ld h,d
	ld a,(w1Link.zh)
	ld l,Item.zh
	ld (hl),a

	; Check if angle has changed
	ld l,Item.var30
	ld a,(w1ParentItem2.angle)
	cp (hl)
	ld (hl),a
	ret z
	jp itemSetAnimation


; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets relative to Link
@data:
	.db $00 $00 $00 $00

.endif ; ROM_AGES



;;
; ITEMID_28 (ricky/moosh attack?)
;
itemCode28:
	ld e,Item.state
	ld a,(de)
	or a
	jr nz,+

	; Initialization
	call itemIncState
	ld l,Item.counter1
	ld (hl),$14
	call itemLoadAttributesAndGraphics
	jr @calculatePosition
+
	call @calculatePosition
	call @tryToBreakTiles
	call itemDecCounter1
	ret nz
	jp itemDelete

@calculatePosition:
	ld a,(w1Companion.id)
	cp SPECIALOBJECTID_RICKY
	ld hl,@mooshData
	jr nz,+

	ld a,(w1Companion.direction)
	add a
	ld hl,@rickyData
	rst_addDoubleIndex
+
	jp itemInitializeFromLinkPosition


; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets from Link's position

@rickyData:
	.db $10 $0c $f4 $00 ; DIR_UP
	.db $0c $12 $fe $08 ; DIR_RIGHT
	.db $10 $0c $08 $00 ; DIR_DOWN
	.db $0c $12 $fe $f8 ; DIR_LEFT

@mooshData:
	.db $18 $18 $10 $00


@tryToBreakTiles:
	ld hl,@rickyBreakableTileOffsets
	ld a,(w1Companion.id)
	cp SPECIALOBJECTID_RICKY
	jr z,@nextTile
	ld hl,@mooshBreakableTileOffsets

@nextTile:
	; Get item Y/X + offset in bc
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
	ld a,(w1Companion.id)
	cp SPECIALOBJECTID_RICKY
	ld a,BREAKABLETILESOURCE_0f
	jr z,+
	ld a,BREAKABLETILESOURCE_11
+
	call tryToBreakTile
	pop hl
	ld a,(hl)
	cp $ff
	jr nz,@nextTile
	ret


; List of offsets from this object's position to try breaking tiles at

@rickyBreakableTileOffsets:
	.db $f8 $08
	.db $f8 $f8
	.db $08 $08
	.db $08 $f8
	.db $ff

@mooshBreakableTileOffsets:
	.db $00 $00
	.db $f0 $f0
	.db $f0 $00
	.db $f0 $10
	.db $00 $f0
	.db $00 $10
	.db $10 $f0
	.db $10 $00
	.db $10 $10
	.db $ff


;;
; ITEMID_SHOVEL
itemCode15:
	ld e,Item.state
	ld a,(de)
	or a
	jr nz,@state1

	; Initialization (state 0)

	call itemLoadAttributesAndGraphics
	call itemIncState
	ld l,Item.counter1
	ld (hl),$04

	ld a,BREAKABLETILESOURCE_06
	call itemTryToBreakTile
	ld a,SND_CLINK
	jr nc,+

	; Dig succeeded
	ld a,$01
	call addToGashaMaturity
	ld a,SND_DIG
+
	jp playSound

; State 1: does nothing for 4 frames?
@state1:
	call itemDecCounter1
	ret nz
	jp itemDelete

.ifdef ROM_AGES
;;
; ITEMID_CANE_OF_SOMARIA
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

	ld c,ITEMID_18
	call findItemWithID
	jr nz,+

	; Set var2f of any previous instance of ITEMID_18 (triggers deletion?)
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
	ld (hl),ITEMID_18

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
; ITEMID_18 (somaria block object)
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
	cp $05
	jr nz,+
	ld a,(wActiveRoom)
	cp $e8
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

.else; ROM_SEASONS

; ITEMID_ROD_OF_SEASONS
itemCode07:
	call itemTransferKnockbackToLink
	ld e,Object.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld h,d
	ld l,Item.enabled
	ld (hl),$03
	ld l,Item.counter1
	ld (hl),$10
	ld a,SND_SWORDSLASH
	call playSound
	ld a,UNCMP_GFXH_SEASONS_1c
	call loadWeaponGfx
	call itemLoadAttributesAndGraphics
	jp objectSetVisible82

@state1:
	ld h,d
	ld l,Item.counter1
	dec (hl)
	ret nz
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	ret nz
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_USED_ROD_OF_SEASONS
	ld e,Item.angle
	ld l,Interaction.angle
	ld a,(de)
	ldi (hl),a
	jp objectCopyPosition

.endif

;;
; ITEMID_MINECART_COLLISION
itemCode1d:
	ld e,Item.state
	ld a,(de)
	or a
	ret nz

	call itemLoadAttributesAndGraphics
	call itemIncState
	ld l,Item.enabled
	set 1,(hl)

@ret:
	ret

;;
; ITEMID_MINECART_COLLISION
itemCode1dPost:
	ld hl,w1Companion.id
	ld a,(hl)
	cp SPECIALOBJECTID_MINECART
	jp z,objectTakePosition
	jp itemDelete

.ifdef ROM_AGES

;;
; ITEMID_SLINGSHOT
itemCode13:
	ret

.else

;;
; ITEMID_SLINGSHOT
itemCode13:
	ld e,Item.state
	ld a,(de)
	or a
	ret nz
	ld a,UNCMP_GFXH_SEASONS_1d
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	ld h,d
	ld a,(wSlingshotLevel)
	or $08
	ld l,Item.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	jp objectSetVisible81

foolsOreRet:
	ret

; ITEMID_MAGNET_GLOVES
itemCode08:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,UNCMP_GFXH_SEASONS_1e
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	call objectSetVisible81

@state1:
	ld a,(wMagnetGloveState)
	bit 1,a
	ld a,$0c
	jr z,+
	inc a
+
	ld h,d
	ld l,Item.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	ret
.endif

; ITEMID_FOOLS_ORE
itemCode1e:
.ifdef ROM_SEASONS
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw foolsOreRet

@state0:
	ld a,UNCMP_GFXH_SEASONS_1f
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	xor a
	call itemSetAnimation
	jp objectSetVisible82
.endif

;;
; ITEMID_BIGGORON_SWORD
itemCode0c:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw itemCode1d@ret

@state0:
	ld a,UNCMP_GFXH_1b
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	ld a,SND_BIGSWORD
	call playSound
	jp objectSetVisible82


;;
; ITEMID_SWORD
itemCode05:
	call itemTransferKnockbackToLink
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@swordSounds:
	.db SND_SWORDSLASH
	.db SND_UNKNOWN5
	.db SND_BOOMERANG
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH
	.db SND_UNKNOWN5
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH


@state0:
	ld a,UNCMP_GFXH_1a
	call loadWeaponGfx

	; Play a random sound
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@swordSounds
	rst_addAToHl
	ld a,(hl)
	call playSound

	ld e,Item.var31
	xor a
	ld (de),a


; State 6: partial re-initialization?
@state6:
	call loadAttributesAndGraphicsAndIncState

	; Load collisiontype and damage
	ld a,(wSwordLevel)
	ld hl,@swordLevelData-2
	rst_addDoubleIndex

	ld e,Item.collisionType
	ldi a,(hl)
	ld (de),a
	ld c,(hl)

	; If var31 was nonzero, skip whimsical ring check?
	ld e,Item.var31
	ld a,(de)
	or a
	ld a,c
	ld (de),a
	jr nz,@@setDamage

	; Whimsical ring: usually 1 damage, with a 1/256 chance of doing 12 damage
	ld a,WHIMSICAL_RING
	call cpActiveRing
	jr nz,@@setDamage
	call getRandomNumber
	or a
	ld c,-1
	jr nz,@@setDamage
	ld a,SND_LIGHTNING
	call playSound
	ld c,-12

@@setDamage:
	ld e,Item.var3a
	ld a,c
	ld (de),a

	ld e,Item.state
	ld a,$01
	ld (de),a

	jp objectSetVisible82

; b0: collisionType
; b1: base damage
@swordLevelData:
	; L-1
	.db ($80|ITEMCOLLISION_L1_SWORD)
	.db (-2)

	; L-2
	.db ($80|ITEMCOLLISION_L2_SWORD)
	.db (-3)

	; L-3
	.db ($80|ITEMCOLLISION_L3_SWORD)
	.db (-5)


; State 4: swordspinning
@state4:
	ld e,Item.collisionType
	ld a, $80 | ITEMCOLLISION_SWORDSPIN
	ld (de),a


; State 1: being swung
@state1:
	ld h,d
	ld l,Item.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a
	ret


; State 2: charging
@state2:
	ld e,Item.var31
	ld a,(de)
	ld e,Item.var3a
	ld (de),a
	ret


; State 3: sword fully charged, flashing
@state3:
	ld h,d
	ld l,Item.counter1
	inc (hl)
	bit 2,(hl)
	ld l,Item.oamFlagsBackup
	ldi a,(hl)
	jr nz,+
	ld a,$0d
+
	ld (hl),a
	ret


; State 5: end of swordspin
@state5:
	; Try to break tile at Link's feet, then delete self
	ld a,$08
	call tryBreakTileWithSword_calculateLevel
	jp itemDelete


;;
; ITEMID_PUNCH
; ITEMID_NONE also points here, but this doesn't get called from there normally
itemCode00:
itemCode02:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1

@state0:
	call itemLoadAttributesAndGraphics
	ld c,SND_STRIKE
	call itemIncState
	ld l,Item.counter1
	ld (hl),$04
	ld l,Item.subid
	bit 0,(hl)
	jr z,++

	; Expert's ring (bit 0 of Item.subid set)

	ld l,Item.collisionRadiusY
	ld a,$06
	ldi (hl),a
	ldi (hl),a

	; Increase Item.damage
	ld a,(hl)
	add $fd
	ld (hl),a

	; Use ITEMCOLLISION_EXPERT_PUNCH for expert's ring
	ld l,Item.collisionType
	inc (hl)

	; Check for clinks against bombable walls?
	call tryBreakTileWithExpertsRing

	ld c,SND_EXPLOSION
++
	ld a,c
	jp playSound

@state1:
	call itemDecCounter1
	jp z,itemDelete
	ret


;;
; ITEMID_SWORD_BEAM
itemCode27:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1

@state0:
	ld hl,@initialOffsetsTable
	call applyOffsetTableHL
	call itemLoadAttributesAndGraphics
	call itemIncState

	ld l,Item.speed
	ld (hl),SPEED_300

	; Calculate angle
	ld l,Item.direction
	ldi a,(hl)
	ld c,a
	swap a
	rrca
	ld (hl),a

	ld a,c
	call itemSetAnimation
	call objectSetVisible81

	ld a,SND_SWORDBEAM
	jp playSound

@initialOffsetsTable:
	.db $f5 $fc $00 ; DIR_UP
	.db $00 $0c $00 ; DIR_RIGHT
	.db $0a $03 $00 ; DIR_DOWN
	.db $00 $f3 $00 ; DIR_LEFT

@state1:
	call itemUpdateDamageToApply
	jr nz,@collision

	; No collision with an object?

	call objectApplySpeed
	call objectCheckTileCollision_allowHoles
	jr nc,@noCollision

	call itemCheckCanPassSolidTile
	jr nz,@collision

@noCollision:
	; Flip palette every 4 frames
	ld a,(wFrameCounter)
	and $03
	jr nz,+
	ld h,d
	ld l,Item.oamFlagsBackup
	ld a,(hl)
	xor $01
	ldi (hl),a
	ldi (hl),a
+
	call objectCheckWithinScreenBoundary
	ret c
	jp itemDelete

@collision:
	ldbc INTERACID_CLINK, $81
	call objectCreateInteraction
	jp itemDelete

;;
; Used for sword, cane of somaria, rod of seasons. Updates animation, deals with
; destroying tiles?
;
updateSwingableItemAnimation:
	ld l,Item.animParameter
.ifdef ROM_AGES
	cp ITEMID_CANE_OF_SOMARIA
.else
	cp ITEMID_ROD_OF_SEASONS
.endif
	jr z,label_07_227
	bit 6,(hl)
	jr z,label_07_227

	res 6,(hl)
	ld a,(hl)
	and $1f
	cp $10
	jr nc,+
	ld a,(w1Link.direction)
	add a
+
	and $07
	push hl
	call tryBreakTileWithSword_calculateLevel
	pop hl

label_07_227:
	ld c,$10
	ld a,(hl)
	and $1f
	cp c
	jr nc,+

	srl a
	ld c,a
	ld a,(w1Link.direction)
	add a
	add a
	add c
	ld c,$00
+
	ld hl,@data
	rst_addAToHl
	ld a,(hl)
	and $f0
	swap a
	add c
	ld e,Item.var30
	ld (de),a

	ld a,(hl)
	and $07
	jp itemSetAnimation


; For each byte:
;  Bits 4-7: value for Item.var30?
;  Bits 0-2: Animation index?
@data:
	.db $02 $41 $80 $c0 $10 $51 $92 $d2
	.db $26 $65 $a4 $e4 $30 $77 $b6 $f6

	.db $00 $11 $22 $33 $44 $55 $66 $77

;;
; Analagous to updateSwingableItemAnimation, but specifically for biggoron's sword
;
updateBiggoronSwordAnimation:
	ld b,$00
	ld l,Item.animParameter
	bit 6,(hl)
	jr z,+
	res 6,(hl)
	inc b
+
	ld a,(hl)
	and $0e
	rrca
	ld c,a
	ld a,(w1Link.direction)
	cp $01
	jr nz,+
	ld a,c
	jr ++
+
	inc a
	add a
	sub c
++
	and $07
	bit 0,b
	jr z,++

	push af
	ld c,a
	ld a,BREAKABLETILESOURCE_SWORD_L2
	call tryBreakTileWithSword
	pop af
++
	ld e,Item.var30
	ld (de),a
	jp itemSetAnimation

;;
; ITEMID_MAGNET_GLOVES
;
itemCode08Post:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld hl,w1Link.yh
	call objectTakePosition
	ld a,(wFrameCounter)
	rrca
	rrca
	ld a,(w1Link.direction)
	adc a
	ld e,Item.var30
	ld (de),a
	jp itemSetAnimation

;;
; ITEMID_SLINGSHOT
;
itemCode13Post:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld hl,w1Link.yh
	call objectTakePosition
	ld a,(w1Link.direction)
	ld e,Item.var30
	ld (de),a
	jp itemSetAnimation

;;
; ITEMID_FOOLS_ORE
;
itemCode1ePost:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld l,Item.animParameter
	ld a,(hl)
	and $06
	add a
	ld b,a
	ld a,(w1Link.direction)
	add b
	ld e,Item.var30
	ld (de),a
	ld hl,swordArcData
	jr itemSetPositionInSwordArc

;;
; ITEMID_PUNCH
;
itemCode00Post:
itemCode02Post:
	ld a,(w1Link.direction)
	add $18
	ld hl,swordArcData
	jr itemSetPositionInSwordArc

;;
; ITEMID_BIGGORON_SWORD
;
itemCode0cPost:
	call cpRelatedObject1ID
	jp nz,itemDelete

	call updateBiggoronSwordAnimation
	ld e,Item.var30
	ld a,(de)
	ld hl,biggoronSwordArcData
	call itemSetPositionInSwordArc
	jp itemCalculateSwordDamage

;;
; ITEMID_CANE_OF_SOMARIA
; ITEMID_SWORD
; ITEMID_ROD_OF_SEASONS
;
itemCode04Post:
itemCode05Post:
itemCode07Post:
	call cpRelatedObject1ID
	jp nz,itemDelete

	call updateSwingableItemAnimation

	ld e,Item.var30
	ld a,(de)
	ld hl,swordArcData
	call itemSetPositionInSwordArc

	jp itemCalculateSwordDamage

;;
; @param	a	Index for table 'hl'
; @param	hl	Usually points to swordArcData
itemSetPositionInSwordArc:
	add a
	rst_addDoubleIndex

;;
; Copy Link's position (accounting for raised floors, with Z position 2 higher than Link)
;
; @param	hl	Pointer to data for collision radii and position offsets
itemInitializeFromLinkPosition:
	ld e,Item.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; Y
.ifdef ROM_AGES
	ld a,(wLinkRaisedFloorOffset)
	ld b,a
	ld a,(w1Link.yh)
	add b
.else
	ld a,(w1Link.yh)
.endif
	add (hl)
	ld e,Item.yh
	ld (de),a

	; X
	inc hl
	ld e,Item.xh
	ld a,(w1Link.xh)
	add (hl)
	ld (de),a

	; Z
	ld a,(w1Link.zh)
	ld e,Item.zh
	sub $02
	ld (de),a
	ret


; Each row probably corresponds to part of a sword's arc? (Also used by punches.)
; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets relative to Link
swordArcData:
	.db $09 $06 $fe $10
	.db $06 $09 $f2 $00
	.db $09 $06 $00 $f1
	.db $06 $09 $f2 $00
	.db $07 $07 $f5 $0d
	.db $07 $07 $f5 $0d
	.db $07 $07 $11 $f3
	.db $07 $07 $f5 $f3
	.db $09 $06 $ef $fc
	.db $06 $09 $02 $13
	.db $09 $06 $15 $03
	.db $06 $09 $02 $ed
	.db $09 $06 $f6 $fc
	.db $04 $09 $02 $0c
	.db $09 $06 $10 $03
	.db $06 $09 $02 $f4
	.db $09 $09 $ef $fc
	.db $09 $09 $f2 $10
	.db $09 $09 $02 $13
	.db $09 $09 $12 $10
	.db $09 $09 $15 $03
	.db $09 $09 $11 $f3
	.db $09 $09 $02 $ed
	.db $09 $09 $f5 $f3
	.db $05 $05 $f4 $fd
	.db $05 $05 $00 $0c
	.db $05 $05 $0c $03
	.db $05 $05 $00 $f4

biggoronSwordArcData:
	.db $0b $0b $ef $fe
	.db $09 $0c $f2 $10
	.db $0b $0b $02 $13
	.db $0c $09 $12 $10
	.db $0b $0b $15 $01
	.db $09 $0c $11 $f3
	.db $0b $0b $02 $ed
	.db $0c $09 $f5 $f3


;;
tryBreakTileWithExpertsRing:
	ld a,(w1Link.direction)
	add a
	ld c,a
	ld a,BREAKABLETILESOURCE_03
	jr tryBreakTileWithSword

;;
; Same as below function, except this checks the sword's level to decide on the
; "breakableTileSource".
;
; @param	a	Direction (see below function)
tryBreakTileWithSword_calculateLevel:
	; Use BREAKABLETILESOURCE_SWORD_L1 or L2 depending on sword's level
	ld c,a
	ld a,(wSwordLevel)
	cp $01
	jr z,tryBreakTileWithSword
	ld a,BREAKABLETILESOURCE_SWORD_L2

;;
; Deals with sword slashing / spinning / poking against tiles, breaking them
;
; @param	a	See constants/breakableTileSources.s
; @param	c	Direction (0-7 are 45-degree increments, 8 is link's center)
tryBreakTileWithSword:
	; Check link is close enough to the ground
	ld e,a
	ld a,(w1Link.zh)
	dec a
	cp $f6
	ret c

	; Get Y/X relative to Link in bc
	ld a,c
	ld hl,@linkOffsets
	rst_addDoubleIndex
	ld a,(w1Link.yh)
	add (hl)
	ld b,a
	inc hl
	ld a,(w1Link.xh)
	add (hl)
	ld c,a

	; Try to break the tile
	push bc
	ld a,e
	call tryToBreakTile

	; Copy tile position, then tile index
	ldh a,(<hFF93)
	ld (wccb0),a
	ldh a,(<hFF92)
	ld (wccaf),a
	pop bc

	; Return if the tile was broken
	ret c

	; Check for bombable wall clink sound
	ld hl,@clinkSoundTable
	call findByteInCollisionTable
	jr c,@bombableWallClink

	; Only continue if the sword is in a "poking" state
	ld a,(w1ParentItem2.subid)
	or a
	ret z

	; Check the second list of tiles to see if it produces no clink at all
	call findByteAtHl
	ret c

	; Produce a clink only if the tile is solid
	ldh a,(<hFF93)
	ld l,a
	ld h,>wRoomCollisions
	ld a,(hl)
	cp $0f
	ret nz
	ld e,$01
	jr @createClink

	; Play a different sound effect on bombable walls
@bombableWallClink:
	ld a,SND_CLINK2
	call playSound

	; Set bit 7 of subid to prevent 'clink' interaction from also playing a sound
	ld e,$80

@createClink:
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_CLINK
	inc l
	ld (hl),e
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ret


@linkOffsets:
	.db $f2 $00 ; Up
	.db $f2 $0d ; Up-right
	.db $00 $0d ; Right
	.db $0d $0d ; Down-right
	.db $0d $00 ; Down
	.db $0d $f2 ; Down-left
	.db $00 $f2 ; Left
	.db $f2 $f2 ; Up-left
	.db $00 $00 ; Center


; 2 lists per entry:
; * The first is a list of tiles which produce an alternate "clinking" sound indicating
; they're bombable.
; * The second is a list of tiles which don't produce clinks at all.
;
@clinkSoundTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES
@collisions0:
@collisions4:
	.db $c1 $c2 $c4 $d1 $cf
	.db $00

	.db $fd $fe $ff
	.db $00
	.db $00

@collisions1:
@collisions2:
@collisions5:
	.db $1f $30 $31 $32 $33 $38 $39 $3a $3b $68 $69
	.db $00

	.db $0a $0b
	.db $00

@collisions3:
	.db $12
	.db $00

	.db $00
.else
@collisions0:
	.db $c1 $c2 $e2 $cb
	.db $00

	.db $fd $fe $ff $d9 $da $20 $d7

@collisions1:
	.db $00

	.db $fd

@collisions2:
	.db $00
	.db $00

@collisions3:
@collisions4:
	.db $1f $30 $31 $32 $33 $38 $39 $3a $3b
	.db $00

	.db $0a $0b
	.db $00


@collisions5:
	.db $12
	.db $00

	.db $00
.endif

;;
; Calculates the value for Item.damage, accounting for ring modifiers.
;
itemCalculateSwordDamage:
	ld e,Item.var3a
	ld a,(de)
	ld b,a
	ld a,(w1ParentItem2.var3a)
	or a
	jr nz,@applyDamageModifier

	ld hl,@swordDamageModifiers
	ld a,(wActiveRing)
	ld e,a
@nextRing:
	ldi a,(hl)
	or a
	jr z,@noRingModifier
	cp e
	jr z,@foundRingModifier
	inc hl
	jr @nextRing

@noRingModifier:
	ld a,e
	cp RED_RING
	jr z,@redRing
	cp GREEN_RING
	jr z,@greenRing
	cp CURSED_RING
	jr z,@cursedRing

	ld a,b
	jr @setDamage

@redRing:
	ld a,b
	jr @applyDamageModifier

@greenRing:
	ld a,b
	cpl
	inc a
	sra a
	cpl
	inc a
	jr @applyDamageModifier

@cursedRing:
	ld a,b
	cpl
	inc a
	sra a
	cpl
	inc a
	jr @setDamage

@foundRingModifier:
	ld a,(hl)

@applyDamageModifier:
	add b

@setDamage:
	; Make sure it's not positive (don't want to heal enemies)
	bit 7,a
	jr nz,+
	ld a,$ff
+
	ld e,Item.damage
	ld (de),a
	ret


; Negative values give the sword more damage for that ring.
@swordDamageModifiers:
	.db POWER_RING_L1	$ff
	.db POWER_RING_L2	$fe
	.db POWER_RING_L3	$fd
	.db ARMOR_RING_L1	$01
	.db ARMOR_RING_L2	$01
	.db ARMOR_RING_L3	$01
	.db $00


;;
; Makes the given item mimic a tile. Used for switch hooking bushes and pots and stuff,
; possibly for other things too?
itemMimicBgTile:
	call getTileMappingData
	push bc
	ld h,d

	; Set Item.oamFlagsBackup, Item.oamFlags
	ld l,Item.oamFlagsBackup
	ld a,$0f
	ldi (hl),a
	ldi (hl),a

	; Set Item.oamTileIndexBase
	ld (hl),c

	; Compare the top-right tile to the top-left tile, and select the appropriate
	; animation depending on whether they reuse the same tile or not.
	; If they don't, it assumes that the graphics are adjacent to each other, due to
	; sprite limitations?
	ld a,($cec1)
	sub c
	jr z,+
	ld a,$01
+
	call itemSetAnimation

	; Copy the BG palette which the tile uses to OBJ palette 7
	pop af
	and $07
	swap a
	rrca
	ld hl,w2TilesetBgPalettes
	rst_addAToHl
	push de
	ld a,:w2TilesetSprPalettes
	ld ($ff00+R_SVBK),a
	ld de,w2TilesetSprPalettes+7*8
	ld b,$08
	call copyMemory

	; Mark OBJ 7 as modified
	ld hl,hDirtySprPalettes
	set 7,(hl)

	xor a
	ld ($ff00+R_SVBK),a
	pop de
	ret

;;
; This is the object representation of a tile while being held / thrown?
;
; If it's not a tile (ie. it's dimitri), this is just an invisible item with collisions?
;
; ITEMID_BRACELET
itemCode16:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call itemLoadAttributesAndGraphics
	ld h,d
	ld l,Item.enabled
	set 1,(hl)

	; Check subid, which is the index of tile being lifted, or 0 if not lifting a tile
	ld l,Item.subid
	ld a,(hl)
	or a
	jr z,@notTile

	ld l,Item.state
	ld (hl),$02
	call itemMimicBgTile
	jp objectSetVisiblec0


; State 1/2: being held
@state1:
@state2:
	ld h,d
	ld l,Item.substate
	ld a,(hl)
	or a
	ret z

	; Item thrown; enable collisions
	ld l,Item.collisionRadiusX
	ld a,$06
	ldd (hl),a
	ldd (hl),a

	; bit 7 of Item.collisionType
	dec l
	set 7,(hl)

	jr @throwItem


; When a bracelet object is created that doesn't come from a tile on the ground, it is
; created at the time it is thrown, instead of the time it is picked up. Also, it's
; invisible, since its only purpose is to provide collisions?
@notTile:
	call braceletCheckDeleteSelfWhileThrowing

	; Check if relatedObj2 is an item or not?
	ld a,h
	cp >w1Companion
	jr z,@@copyCollisions
	ld a,l
	cp Item.start+$40
	jr c,@throwItem

; This will copy collision attributes of non-item objects. This should allow "non-allied"
; objects to damage enemies?
@@copyCollisions:
	; Copy angle (this -> relatedObj2)
	ld a,Object.angle
	call objectGetRelatedObject2Var
	ld e,Item.angle
	ld a,(de)
	ld (hl),a

	; Copy collisionRadius (relatedObj2 -> this)
	ld a,l
	add Object.collisionRadiusY-Object.angle
	ld l,a
	ld e,Item.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; Enable collisions (on this)
	ld h,d
	ld l,Item.collisionType
	set 7,(hl)

@throwItem:
	call itemBeginThrow
	ld h,d
	ld l,Item.state
	ld (hl),$03
	inc l
	ld (hl),$00


; State 3: being thrown
@state3:
	call braceletCheckDeleteSelfWhileThrowing
	call itemUpdateThrowingLaterally
.ifdef ROM_AGES
	jr z,@@destroyWithAnimation
.else
	jr z,@@preDestroyWithAnimation
.endif

	ld e,Item.var39
	ld a,(de)
	ld c,a
	call itemUpdateThrowingVertically
	jr nc,@@noCollision

	; If it's breakable, destroy it; if not, let it bounce
	call braceletCheckBreakable

.ifdef ROM_AGES
	jr nz,@@destroyWithAnimation
.else
	jr nz,@@preDestroyWithAnimation
	jr nc,+
	call objectReplaceWithAnimationIfOnHazard
	ret c
+
.endif

	call itemBounce
	jr c,@@release

@@noCollision:
	; If this is not a breakable tile, copy this object's position to relatedObj2.
	ld e,Item.subid
	ld a,(de)
	or a
	ret nz
	ld a,Object.yh
	call objectGetRelatedObject2Var
	jp objectCopyPosition

@@release:
.ifdef ROM_SEASONS
	ld e,$02
	ld a,(de)
	cp $d7
	jr z,@@createPuff
.endif

	ld a,Object.substate
	call objectGetRelatedObject2Var
	ld (hl),$03
	jp itemDelete

.ifdef ROM_SEASONS
@@preDestroyWithAnimation:
	ld e,Item.subid
	ld a,(de)
	cp $d7
	jr nz,@@destroyWithAnimation
@@createPuff:
	call objectCreatePuff
	jp itemDelete
.endif

@@destroyWithAnimation:
	call objectReplaceWithAnimationIfOnHazard
	ret c
	callab bank6.itemMakeInteractionForBreakableTile
	jp itemDelete

;;
; @param[out] zflag Set if Item.subid is zero
; @param[out] cflag Inverse of zflag?
braceletCheckBreakable:
	ld e,Item.subid
	ld a,(de)
	or a
	ret z
.ifdef ROM_SEASONS
	cp $d7
.endif
	scf
	ret

;;
; Called each frame an item's being thrown. Returns from caller if it decides to delete
; itself.
;
; @param[out]	hl	relatedObj2.substate or this.substate
braceletCheckDeleteSelfWhileThrowing:
	ld e,Item.subid
	ld a,(de)
	or a
	jr nz,@throwingTile

	lda Item.enabled
	call objectGetRelatedObject2Var
	bit 0,(hl)
	jr z,@deleteSelfAndRetFromCaller

	; Delete self unless related object is on state 2, substate 0/1/2 (being held by
	; Link or just released)
	ld a,l
	add Object.state-Object.enabled
	ld l,a
	ldi a,(hl)
	cp $02
	jr nz,@deleteSelfAndRetFromCaller
	ld a,(hl)
	cp $03
	ret c

@deleteSelfAndRetFromCaller:
	pop af
	jp itemDelete

@throwingTile:
	call objectCheckWithinRoomBoundary
	jr nc,@deleteSelfAndRetFromCaller
	ld h,d
	ld l,Item.substate
	ret

;;
; Called every frame a bomb is being thrown. Also used by somaria block?
;
bombUpdateThrowingLaterally:
	; If it's landed in water, set speed to 0 (for sidescrolling areas)
	ld h,d
	ld l,Item.var3b
	bit 0,(hl)
	jr z,+
	ld l,Item.speed
	ld (hl),$00
+
	; If this is the start of the throw, initialize speed variables
	ld l,Item.var37
	bit 0,(hl)
	call z,itemBeginThrow

	; Check for collisions with walls, update position.
	jp itemUpdateThrowingLaterally

;;
; Items call this once on the frame they're thrown
;
itemBeginThrow:
	call itemSetVar3cToFF

	; Move the item one pixel in Link's facing direction
	ld a,(w1Link.direction)
	ld hl,@throwOffsets
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)

	ld h,d
	ld l,Item.yh
	add (hl)
	ldi (hl),a
	inc l
	ld a,(hl)
	add c
	ld (hl),a

	ld l,Item.enabled
	res 1,(hl)

	; Mark as thrown?
	ld l,Item.var37
	set 0,(hl)

	; Item.var38 contains "weight" information (how the object will be thrown)
	inc l
	ld a,(hl)
	and $f0
	swap a
	add a
	ld hl,itemWeights
	rst_addDoubleIndex

	; Byte 0 from hl: value for Item.var39 (gravity)
	ldi a,(hl)
	ld e,Item.var39
	ld (de),a

	; If angle is $ff (motionless), skip the rest.
	ld e,Item.angle
	ld a,(de)
	rlca
	jr c,@clearItemSpeed

	; Byte 1: Value for Item.speedZ (8-bit, high byte is $ff)
	ld e,Item.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,$ff
	ld (de),a

	; Bytes 2,3: Throw speed with and without toss ring, respectively
	ld a,TOSS_RING
	call cpActiveRing
	jr nz,+
	inc hl
+
	ld e,Item.speed
	ldi a,(hl)
	ld (de),a
	ret

@clearItemSpeed:
	ld h,d
	ld l,Item.speed
	xor a
	ld (hl),a
	ld l,Item.speedZ
	ldi (hl),a
	ldi (hl),a
	ret

; Offsets to move the item when it's thrown.
; Each direction value reads 2 of these, one for Y and one for X.
@throwOffsets:
	.db $ff
	.db $00
	.db $01
	.db $00
	.db $ff

;;
; Checks whether a throwable item has collided with a wall; if not, this updates its
; position.
;
; Called by throwable items each frame. See also "itemUpdateThrowingVertically".
;
; @param[out]	zflag	Set if the item should break.
itemUpdateThrowingLaterally:
	ld e,Item.var38
	ld a,(de)

	; Check whether the "weight" value for the item equals 3?
	cp $40
	jr nc,+
.ifdef ROM_AGES
	cp $30
.else
	cp $20
.endif
	jr nc,@weight3
+
	; Return if not moving
	ld e,Item.angle
	ld a,(de)
	cp $ff
	jr z,@unsetZFlag

	and $18
	rrca
	rrca
	ld hl,bombEdgeOffsets
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)

	; Load y position into b, jump if beyond room boundary.
	ld h,d
	ld l,Item.yh
	add (hl)
	cp (LARGE_ROOM_HEIGHT*$10)
	jr nc,@noCollision

	ld b,a
	ld l,Item.xh
	ld a,c
	add (hl)
	ld c,a

	call checkTileCollisionAt_allowHoles
	jr nc,@noCollision
	call itemCheckCanPassSolidTileAt
	jr z,@noCollision
	jr @collision

; This is probably a specific item with different dimensions than other throwable stuff
@weight3:
	ld h,d
	ld l,Item.yh
	ld b,(hl)
	ld l,Item.xh
	ld c,(hl)

	ld e,Item.angle
	ld a,(de)
	and $18
	ld hl,data_649a
	rst_addAToHl

	; Loop 4 times, once for each corner of the object?
	ld e,$04
--
	push bc
	ldi a,(hl)
	add b
	ld b,a
	ldi a,(hl)
	add c
	ld c,a
	push hl
	call checkTileCollisionAt_allowHoles
	pop hl
	pop bc
	jr c,@collision
	dec e
	jr nz,--
	jr @noCollision

@collision:
	; Check if this is a breakable object (based on a tile that was picked up)?
	call braceletCheckBreakable
	jr nz,@setZFlag

	; Clear angle, which will also set speed to 0
	ld e,Item.angle
	ld a,$ff
	ld (de),a

@noCollision:
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr z,+

	; If in a sidescrolling area, don't apply speed if moving directly vertically?
	ld e,Item.angle
	ld a,(de)
	and $0f
	jr z,@unsetZFlag
+
	call objectApplySpeed

@unsetZFlag:
	or d
	ret

@setZFlag:
	xor a
	ret

;;
; Called each time a particular item (ie a bomb) lands on a ground. This will cause it to
; bounce a few times before settling, reducing in speed with each bounce.
; @param[out] zflag Set if the item has reached a ground speed of zero.
; @param[out] cflag Set if the item has stopped bouncing.
itemBounce:
	ld a,SND_BOMB_LAND
	call playSound

	; Invert and reduce vertical speed
	call objectNegateAndHalveSpeedZ
	ret c

	; Reduce regular speed
	ld e,Item.speed
	ld a,(de)
	ld e,a
	ld hl,bounceSpeedReductionMapping
	call lookupKey
	ld e,Item.speed
	ld (de),a
	or a
	ret

; This seems to list the offsets of the 4 corners of a particular object, to be used for
; collision calculations.
; Somewhat similar to "bombEdgeOffsets", except that is only used to check for collisions
; in the direction it's moving in, whereas this seems to cover the entire object.
data_649a:
	.db $00 $00 $fa $fa $fa $00 $fa $05 ; DIR_UP
	.db $00 $00 $fa $05 $00 $05 $05 $05 ; DIR_RIGHT
	.db $00 $00 $05 $fb $05 $00 $05 $05 ; DIR_DOWN
	.db $00 $00 $fa $fa $00 $fa $06 $fa ; DIR_LEFT

; b0: Value to write to Item.var39 (gravity).
; b1: Low byte of Z speed to give the object (high byte will be $ff)
; b2: Throw speed without toss ring
; b3: Throw speed with toss ring
itemWeights:
	.db $1c $10 SPEED_180 SPEED_280
	.db $20 $00 SPEED_080 SPEED_100
.ifdef ROM_AGES
	.db $28 $20 SPEED_1a0 SPEED_280
	.db $20 $00 SPEED_080 SPEED_100
.else
	.db $20 $00 SPEED_100 SPEED_180
	.db $20 $00 SPEED_0c0 SPEED_100
.endif
	.db $20 $e0 SPEED_140 SPEED_180
	.db $20 $00 SPEED_080 SPEED_100

; A series of key-value pairs where the key is a bouncing object's current speed, and the
; value is the object's new speed after one bounce.
; This returns roughly half the value of the key.
bounceSpeedReductionMapping:
	.db SPEED_020 SPEED_000
	.db SPEED_040 SPEED_020
	.db SPEED_060 SPEED_020
	.db SPEED_080 SPEED_040
	.db SPEED_0a0 SPEED_040
	.db SPEED_0c0 SPEED_060
	.db SPEED_0e0 SPEED_060
	.db SPEED_100 SPEED_080
	.db SPEED_120 SPEED_080
	.db SPEED_140 SPEED_0a0
	.db SPEED_160 SPEED_0a0
	.db SPEED_180 SPEED_0c0
	.db SPEED_1a0 SPEED_0c0
	.db SPEED_1c0 SPEED_0e0
	.db SPEED_1e0 SPEED_0e0
	.db SPEED_200 SPEED_100
	.db SPEED_220 SPEED_100
	.db SPEED_240 SPEED_120
	.db SPEED_260 SPEED_120
	.db SPEED_280 SPEED_140
	.db SPEED_2a0 SPEED_140
	.db SPEED_2c0 SPEED_160
	.db SPEED_2e0 SPEED_160
	.db SPEED_300 SPEED_180
	.db $00 $00

;;
; ITEMID_DUST
itemCode1a:
	ld e,Item.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemLoadAttributesAndGraphics
	call itemIncSubstate
	ld hl,w1Link.yh
	call objectTakePosition
	xor a
	call itemSetAnimation
	jp objectSetVisible80


; Substate 1: initial dust cloud above Link (lasts less than a second)
@substate1:
	call itemAnimate
	call @setOamTileIndexBaseFromAnimParameter

	; Mess with Item.oamFlags and Item.oamFlagsBackup
	ld a,(hl)
	inc a
	and $fb
	xor $60
	ldd (hl),a
	ld (hl),a

	; If bit 7 of animParameter was set, go to state 2
	bit 7,b
	ret z

	; [Item.oamFlags] = [Item.oamFlagsBackup] = $0b
	ld a,$0b
	ldi (hl),a
	ld (hl),a

	ld l,Item.z
	xor a
	ldi (hl),a
	ld (hl),a

	call objectSetInvisible
	jp itemIncSubstate


; Substate 2: dust by Link's feet (spends the majority of time in this state)
@substate2:
	call checkPegasusSeedCounter
	jp z,itemDelete

	call @initializeNextDustCloud

	; Each frame, alternate between two dust cloud positions, with corresponding
	; variables stored at var30-var33 and var34-var37.
	call itemDecCounter1
	bit 0,(hl)
	ld l,Item.var30
	jr z,+
	ld l,Item.var34
+
	bit 7,(hl)
	jp z,objectSetInvisible

	; Inc var30/var34 (acts as a counter)
	inc (hl)
	ld a,(hl)
	cp $82
	jr c,++

	; Reset the counter, increment var31/var35 (which controls the animation)
	ld (hl),$80
	inc l
	inc (hl)
	ld a,(hl)
	dec l
	cp $03
	jr nc,@clearDustCloudVariables
++
	; c = [var31/var35]+1
	inc l
	ldi a,(hl)
	inc a
	ld c,a

	; [Item.yh] = [var32/var36], [Item.xh] = [var33/var37]
	ldi a,(hl)
	ld e,Item.yh
	ld (de),a
	ldi a,(hl)
	ld e,Item.xh
	ld (de),a

	; Load the animation (corresponding to [var31/var35])
	ld a,c
	call itemSetAnimation
	call objectSetVisible80

;;
; @param[out]	b	[Item.animParameter]
; @param[out]	hl	Item.oamFlags
@setOamTileIndexBaseFromAnimParameter:
	ld h,d
	ld l,Item.animParameter
	ld a,(hl)
	ld b,a
	and $7f
	ld l,Item.oamTileIndexBase
	ldd (hl),a
	ret

;;
; Clears one of the "slots" for the dust cloud objects.
@clearDustCloudVariables:
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	jp objectSetInvisible

;;
; Initializes a dust cloud if one of the two slots are blank
;
@initializeNextDustCloud:
	ld h,d
	ld l,Item.subid
	bit 0,(hl)
	ret z

	ld (hl),$00

	ld l,Item.var30
	bit 7,(hl)
	jr z,+
	ld l,Item.var34
	bit 7,(hl)
	ret nz
+
	ld a,$80
	ldi (hl),a
	xor a
	ldi (hl),a
	ld a,(w1Link.yh)
	add $05
	ldi (hl),a
	ld a,(w1Link.xh)
	ld (hl),a
	ret
