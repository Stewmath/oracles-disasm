; Common code usable by special objects (so long as their code is in bank 5)

;;
; Initializes SpecialObject.oamFlags and SpecialObject.oamTileIndexBase, according to the
; id of the object.
;
; @param	d	Object
specialObjectSetOamVariables:
	ld e,SpecialObject.var32
	ld a,$ff
	ld (de),a

	ld e,SpecialObject.id
	ld a,(de)
	ld hl,@data
	rst_addDoubleIndex

	ld e,SpecialObject.oamTileIndexBase
	ldi a,(hl)
	ld (de),a

	; Write to SpecialObject.oamFlags
	dec e
	ldi a,(hl)
	ld (de),a

	; Write flags to SpecialObject.oamFlagsBackup as well
	dec e
	ld (de),a
	ret

; 2 bytes for each SpecialObject id: oamTileIndexBase, oamFlags (palette).
@data:
	.db $70 $08 ; 0x00 (Link)
	.db $70 $08 ; 0x01
	.db $70 $08 ; 0x02
	.db $70 $08 ; 0x03
	.db $70 $08 ; 0x04
	.db $70 $08 ; 0x05
	.db $70 $08 ; 0x06
	.db $70 $08 ; 0x07
	.db $70 $08 ; 0x08
	.db $70 $08 ; 0x09
	.db $60 $0c ; 0x0a (Minecart)
	.db $60 $0b ; 0x0b
	.db $60 $0a ; 0x0c
	.db $60 $09 ; 0x0d
	.db $60 $08 ; 0x0e
	.db $60 $0b ; 0x0f
	.db $60 $0a ; 0x10
	.db $60 $09 ; 0x11
	.db $60 $08 ; 0x12
	.db $60 $0b ; 0x13

;;
; Deals 4 points of damage (1/2 heart?) to link, and applies knockback in the opposite
; direction he is moving.
dealSpikeDamageToLink:
	ld a,(wLinkRidingObject)
	ld b,a
	ld h,d
	ld l,SpecialObject.invincibilityCounter
	or (hl)
	ret nz

	ld (hl),40 ; 40 frames invincibility

	; Get damage value (4 normally, 2 with red luck ring)
	ld a,RED_LUCK_RING
	call cpActiveRing
	ld a,-4
	jr nz,+
	sra a
+
	ld l,SpecialObject.damageToApply
	add (hl)
	ld (hl),a

	ld l,SpecialObject.var2a
	ld (hl),$80

	; 10 frames knockback
	ld l,SpecialObject.knockbackCounter
	ld a,10
	add (hl)
	ld (hl),a

	; Calculate knockback angle
	ld e,SpecialObject.angle
	ld a,(de)
	xor $10
	ld l,SpecialObject.knockbackAngle
	ld (hl),a

	ld a,SND_DAMAGE_LINK
	call playSound
	jr linkApplyDamage_b5

;;
updateLinkDamageTaken:
	callab bank6.linkUpdateDamageToApplyForRings

linkApplyDamage_b5:
	callab bank6.linkApplyDamage
	ret

;;
updateLinkInvincibilityCounter:
	ld hl,w1Link.invincibilityCounter
	ld a,(hl)
	or a
	ret z

	; If $80 or higher, invincibilityCounter goes up and Link doesn't flash red
	bit 7,a
	jr nz,@incCounter

	; Otherwise it goes down, and Link flashes red
	dec (hl)
	jr z,@normalFlags

@func_4244:

	ld a,(wFrameCounter)
	bit 2,a
	jr nz,@normalFlags

	; Set Link's palette to red
	ld l,SpecialObject.oamFlags
	ld (hl),$0d
	ret

@incCounter:
	inc (hl)

@normalFlags:
	ld l,SpecialObject.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a
	ret

;;
; Updates wActiveTileIndex, wActiveTileType, and wLastActiveTileType.
;
; NOTE: wLastActiveTileType actually keeps track of the tile BELOW Link when in
; a sidescrolling section.
;
sidescrollUpdateActiveTile:
	call objectGetTileAtPosition
	ld (wActiveTileIndex),a

	ld hl,tileTypesTable
	call lookupCollisionTable
	ld (wActiveTileType),a

	ld bc,$0800
	call objectGetRelativeTile
	ld hl,tileTypesTable
	call lookupCollisionTable
	ld (wLastActiveTileType),a
	ret

;;
; Does various things based on the tile type of the tile Link is standing on (see
; constants/common/tileTypes.s).
;
; @param	d	Link object
linkApplyTileTypes:
	xor a
	ld (wIsTileSlippery),a
	ld a,(wLinkInAir)
	or a
	jp nz,@tileType_normal

.ifdef ROM_AGES
	ld (wLinkRaisedFloorOffset),a
.endif
	call @linkGetActiveTileType

	ld (wActiveTileType),a
	rst_jumpTable
	.dw @tileType_normal ; TILETYPE_NORMAL
	.dw @tileType_hole ; TILETYPE_HOLE
	.dw @tileType_warpHole ; TILETYPE_WARPHOLE
	.dw @tileType_crackedFloor ; TILETYPE_CRACKEDFLOOR
	.dw @tileType_vines ; TILETYPE_VINES
	.dw @notSwimming ; TILETYPE_GRASS
	.dw @notSwimming ; TILETYPE_STAIRS
	.dw @swimming ; TILETYPE_WATER
	.dw @tileType_stump ; TILETYPE_STUMP
	.dw @tileType_conveyor ; TILETYPE_UPCONVEYOR
	.dw @tileType_conveyor ; TILETYPE_RIGHTCONVEYOR
	.dw @tileType_conveyor ; TILETYPE_DOWNCONVEYOR
	.dw @tileType_conveyor ; TILETYPE_LEFTCONVEYOR
	.dw dealSpikeDamageToLink ; TILETYPE_SPIKE
	.dw @tileType_cracked_ice ; TILETYPE_CRACKED_ICE
	.dw @tileType_ice ; TILETYPE_ICE
	.dw @tileType_lava ; TILETYPE_LAVA
	.dw @tileType_puddle ; TILETYPE_PUDDLE
	.dw @tileType_current ; TILETYPE_UPCURRENT
	.dw @tileType_current ; TILETYPE_RIGHTCURRENT
	.dw @tileType_current ; TILETYPE_DOWNCURRENT
	.dw @tileType_current ; TILETYPE_LEFTCURRENT
.ifdef ROM_AGES
	.dw @tiletype_raisableFloor ; TILETYPE_RAISABLE_FLOOR
	.dw @swimming ; TILETYPE_SEAWATER
	.dw @swimming ; TILETYPE_WHIRLPOOL

@tiletype_raisableFloor:
	ld a,-3
	ld (wLinkRaisedFloorOffset),a
.endif

@tileType_normal:
	xor a
	ld (wActiveTileType),a
	ld (wStandingOnTileCounter),a
	ld (wLinkSwimmingState),a
	ret

@tileType_puddle:
	ld h,d
	ld l,SpecialObject.animParameter
	bit 5,(hl)
	jr z,@tileType_normal

	res 5,(hl)
	ld a,(wLinkImmobilized)
	or a
	ld a,SND_SPLASH
	call z,playSound
	jr @tileType_normal

@tileType_stump:
	ld h,d
	ld l,SpecialObject.adjacentWallsBitset
	ld (hl),$ff
	ld l,SpecialObject.collisionType
	res 7,(hl)
	jr @notSwimming

@tileType_vines:
	call dropLinkHeldItem
	ld a,$ff
	ld (wLinkClimbingVine),a

@notSwimming:
	xor a
	ld (wLinkSwimmingState),a
	ret

@tileType_crackedFloor:
	ld a,ROCS_RING
	call cpActiveRing
	jr z,@tileType_normal

	; Don't break the floor until Link has stood there for 32 frames
	ld a,(wStandingOnTileCounter)
	cp 32
	jr c,@notSwimming

	ld a,(wActiveTilePos)
	ld c,a
	ld a,TILEINDEX_HOLE
	call breakCrackedFloor
	xor a
	ld (wStandingOnTileCounter),a

@tileType_hole:
@tileType_warpHole:
.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	jr nz,@tileType_normal
.endif

	xor a
	ld (wLinkSwimmingState),a

	ld a,(wLinkRidingObject)
	or a
	jr nz,@tileType_normal

	ld a,(wMagnetGloveState)
	bit 6,a
	jr nz,@tileType_normal

	; Jump if tile type has changed
	ld hl,wLastActiveTileType
	ldd a,(hl)
	cp (hl)
	jr nz,++

	; Jump if Link's position has not changed
	ld l,<wActiveTilePos
	ldi a,(hl)
	cp b
	jr z,++

	; [wStandingOnTileCounter] = $0e
	inc l
	ld a,$0e
	ld (hl),a
++
	ld a,$80
	ld (wcc92),a
	jp linkPullIntoHole

@tileType_ice:
	ld a,SNOWSHOE_RING
	call cpActiveRing
	jr z,@notSwimming

	ld hl,wIsTileSlippery
	set 6,(hl)
	jr @notSwimming

@tileType_cracked_ice:
.ifdef ROM_AGES
	ret
.else
	ld a,(wStandingOnTileCounter)
	cp $20
	jr c,@tileType_ice
	ld a,(wActiveTilePos)
	ld c,a
	ld a,$fd
	call setTile
.endif

@swimming:
	ld a,(wLinkRidingObject)
	or a
	jp nz,@tileType_normal

	; Run the below code only the moment he gets into the water
	ld a,(wLinkSwimmingState)
	or a
	ret nz

.ifdef ROM_AGES
	ld a,(w1Link.var2f)
	bit 7,a
	ret nz
.endif

	xor a
	ld e,SpecialObject.var35
	ld (de),a
	ld e,SpecialObject.knockbackCounter
	ld (de),a

	inc a
	ld (wLinkSwimmingState),a

	ld a,$80
	ld (wcc92),a
	ret

@tileType_lava:
.ifdef ROM_AGES
	ld a,(wLinkRidingObject)
	or a
.else
	ld a,(wMagnetGloveState)
	bit 6,a
.endif
	jp nz,@tileType_normal

	ld a,$80
	ld (wcc92),a

	ld e,SpecialObject.knockbackCounter
	xor a
	ld (de),a

	ld a,(wLinkSwimmingState)
	or a
	ret nz

	xor a
	ld e,SpecialObject.var35
	ld (de),a

	ld a,$41
	ld (wLinkSwimmingState),a
	ret

@tileType_conveyor:
	ld a,(wLinkRidingObject)
	or a
	jp nz,@tileType_normal

	ld a,QUICKSAND_RING
	call cpActiveRing
	jp z,@tileType_normal

	ldbc SPEED_80, TILETYPE_UPCONVEYOR

@adjustLinkOnConveyor:
	ld a,$01
	ld (wcc92),a

	; Get angle to move link in c
	ld a,(wActiveTileType)
	sub c
	ld hl,@conveyorAngles
	rst_addAToHl
	ld c,(hl)

	jp specialObjectUpdatePositionGivenVelocity

@conveyorAngles:
	.db $00 $08 $10 $18

@tileType_current:
	ldbc SPEED_c0, TILETYPE_UPCURRENT
	call @adjustLinkOnConveyor
	jr @swimming

;;
; Gets the tile type of the tile link is standing on (see constants/common/tileTypes.s).
; Also updates wActiveTilePos, wActiveTileIndex and wLastActiveTileType, but not
; wActiveTileType.
;
; @param	d	Link object
; @param[out]	a	Tile type
; @param[out]	b	Former value of wActiveTilePos
@linkGetActiveTileType:
	ld bc,$0500
	call objectGetRelativeTile
	ld c,a
	ld b,l
	ld hl,wActiveTilePos
	ldi a,(hl)
	cp b
	jr nz,+

	ld a,(hl)
	cp c
	jr z,++
+
	; Update wActiveTilePos
	ld l,<wActiveTilePos
	ld a,(hl)
	ld (hl),b
	ld b,a

	; Update wActiveTileIndex
	inc l
	ld (hl),c

	; Write $00 to wStandingOnTileCounter
	inc l
	ld (hl),$00
++
	ld l,<wStandingOnTileCounter
	inc (hl)

	; Copy wActiveTileType to wLastActiveTileType
	inc l
	ldi a,(hl)
	ld (hl),a

	ld a,c
	ld hl,tileTypesTable
	jp lookupCollisionTable

;;
; Same as below, but operates on SpecialObject.angle, not a given variable.
linkAdjustAngleInSidescrollingArea:
	ld l,SpecialObject.angle

;;
; Adjusts Link's angle in sidescrolling areas when not on a staircase.
; This results in Link only moving in horizontal directions.
;
; @param	l	Angle variable to use
linkAdjustGivenAngleInSidescrollingArea:
	ld h,d
	ld e,l

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	ret z

	; Return if angle value >= $80
	bit 7,(hl)
	ret nz

	ld a,(hl)
	ld hl,@horizontalAngleTable
	rst_addAToHl
	ld a,(hl)
	ld (de),a
	ret

; This table converts an angle value such that it becomes purely horizontal.
@horizontalAngleTable:
	.db $ff $08 $08 $08 $08 $08 $08 $08
	.db $08 $08 $08 $08 $08 $08 $08 $08
	.db $ff $18 $18 $18 $18 $18 $18 $18
	.db $18 $18 $18 $18 $18 $18 $18 $18

;;
; Prevents link from passing object d.
;
; @param	d	The object that Link shall not pass.
companionPreventLinkFromPassing_noExtraChecks:
	ld hl,w1Link
	jp preventObjectHFromPassingObjectD

;;
companionUpdateMovement:
	call companionCalculateAdjacentWallsBitset
	call specialObjectUpdatePosition

	; Don't attempt to break tile on ground if in midair
	ld h,d
	ld l,SpecialObject.zh
	ld a,(hl)
	or a
	ret nz

;;
; Calculate position of the tile beneath the companion's feet, to see if it can be broken
; (just by walking on it)
companionTryToBreakTileFromMoving:
	ld h,d
	ld l,SpecialObject.yh
	ld a,(hl)
	add $05
	ld b,a
	ld l,SpecialObject.xh
	ld c,(hl)

	ld a,BREAKABLETILESOURCE_COMPANION_MOVEMENT
	jp tryToBreakTile

;;
; @param	d	Special object
companionCalculateAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset
	xor a
	ld (de),a
	ld h,d
	ld l,SpecialObject.yh
	ld b,(hl)
	ld l,SpecialObject.xh
	ld c,(hl)

	ld a,$01
	ldh (<hFF8B),a
	ld hl,@offsets
--
	ldi a,(hl)
	add b
	ld b,a
	ldi a,(hl)
	add c
	ld c,a
	push hl
	call checkCollisionForCompanion
	pop hl
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,--

	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
	ret

@offsets:
	.db $fb $fd
	.db $00 $07
	.db $0d $f9
	.db $00 $07
	.db $f5 $f7
	.db $09 $00
	.db $f7 $0b
	.db $09 $00

;;
; @param	bc	Position to check
; @param	d	A special object (should be a companion?)
; @param[out]	cflag	Set if a collision happened
checkCollisionForCompanion:
	; Animals can't pass through climbable vines
	call getTileAtPosition
	ld a,(hl)
	cp TILEINDEX_VINE_BOTTOM
	jr z,@setCollision
	cp TILEINDEX_VINE_MIDDLE
	jr z,@setCollision

	; Check for collision on bottom half of this tile only
	cp TILEINDEX_VINE_TOP
	ld a,$03
	jp z,checkGivenCollision_allowHoles

	ld e,SpecialObject.id
	ld a,(de)
	cp SPECIALOBJECT_RICKY
	jr nz,@notRicky

	; This condition appears to have no effect either way?
	ld e,SpecialObject.zh
	ld a,(de)
	bit 7,a
	jr z,@checkCollision
	ld a,(hl)
.ifdef ROM_SEASONS
	; tiles that are half-floor/half-cliff?
	cp $d9
	ret z
	cp $da
	ret z
.endif
	jr @checkCollision

@notRicky:
	cp SPECIALOBJECT_DIMITRI
	jr nz,@checkCollision
	ld a,(hl)
	cp SPECIALCOLLISION_fe
	ret nc
	jr @checkCollision

@setCollision:
	scf
	ret

@checkCollision:
	jp checkCollisionPosition_disallowSmallBridges

;;
; @param	d	Special object
; @param	hl	Table which takes object's direction as an index
; @param[out]	a	Collision value of tile at object's position + offset
; @param[out]	b	Tile index at object's position + offset
; @param[out]	hl	Address of collision value
specialObjectGetRelativeTileWithDirectionTable:
	ld e,SpecialObject.direction
	ld a,(de)
	rst_addDoubleIndex

;;
; @param	d	Special object
; @param	hl	Address of Y/X offsets to use relative to object
; @param[out]	a	Collision value of tile at object's position + offset
; @param[out]	b	Tile index at object's position + offset
; @param[out]	hl	Address of collision value
specialObjectGetRelativeTileFromHl:
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call objectGetRelativeTile
	ld b,a
	ld h,>wRoomCollisions
	ld a,(hl)
	ret

;;
; @param[out]	zflag	nz if an object is moving away from a wall
specialObjectCheckMovingAwayFromWall:
	; Check that the object is trying to move
	ld h,d
	ld l,SpecialObject.angle
	ld a,(hl)
	cp $ff
	ret z

	; Invert angle
	add $10
	and $1f
	ld (hl),a

	call specialObjectCheckFacingWall
	ld c,a

	; Uninvert angle
	ld l,SpecialObject.angle
	ld a,(hl)
	add $10
	and $1f
	ld (hl),a

	ld a,c
	or a
	ret

;;
; Checks if an object is directly against a wall and trying to move toward it
;
; @param	d	Special object
; @param[out]	a	The bits from adjacentWallsBitset corresponding to the direction
;			it's moving in
; @param[out]	zflag	nz if an object is moving toward a wall
specialObjectCheckMovingTowardWall:
	; Check that the object is trying to move
	ld h,d
	ld l,SpecialObject.angle
	ld a,(hl)
	cp $ff
	ret z

;;
; @param	a	Should equal object's angle value
; @param	h	Special object
; @param[out]	a	The bits from adjacentWallsBitset corresponding to the direction
;			it's moving in
specialObjectCheckFacingWall:
	ld bc,$0000

	; Check if straight left or right
	cp $08
	jr z,@checkVertical
	cp $18
	jr z,@checkVertical

	ld l,SpecialObject.adjacentWallsBitset
	ld b,(hl)
	add a
	swap a
	and $03
	ld a,$30
	jr nz,+
	ld a,$c0
+
	and b
	ld b,a

@checkVertical:
	; Check if straight up or down
	ld l,SpecialObject.angle
	ld a,(hl)
	and $0f
	jr z,@ret

	ld a,(hl)
	ld l,SpecialObject.adjacentWallsBitset
	ld c,(hl)
	bit 4,a ; Check if angle is to the left
	ld a,$03
	jr z,+
	ld a,$0c
+
	and c
	ld c,a

@ret:
	ld a,b
	or c
	ret

;;
; Create an item which deals damage 7.
;
; @param	bc	Item ID
companionCreateItem:
	call getFreeItemSlot
	ret nz
	jr ++

;;
; Create the weapon item which deals damage 7.
;
; @param	bc	Item ID
companionCreateWeaponItem:
	ld hl,w1WeaponItem.enabled
	ld a,(hl)
	or a
	ret nz
++
	inc (hl)
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	ld l,Item.damage
	ld (hl),-7
	xor a
	ret

;;
; Animates a companion, also checks whether the animation needs to change based on
; direction.
;
; @param	c	Base animation index?
companionUpdateDirectionAndAnimate:
	ld e,SpecialObject.direction
	ld a,(de)
	ld (w1Link.direction),a
	ld e,SpecialObject.state
	ld a,(de)
	cp $0c
	jp z,specialObjectAnimate

	call updateLinkDirectionFromAngle
	ld hl,w1Companion.direction
	cp (hl)
	jp z,specialObjectAnimate

;;
; Same as below, but updates the companion's direction based on its angle first?
;
; @param	c	Base animation index?
companionUpdateDirectionAndSetAnimation:
	ld e,SpecialObject.angle
	ld a,(de)
	add a
	swap a
	and $03
	dec e
	ld (de),a

;;
; @param	c	Base animation index? (Added with direction, var38)
companionSetAnimation:
	ld h,d
	ld a,c
	ld l,SpecialObject.direction
	add (hl)
	ld l,SpecialObject.var38
	add (hl)
	jp specialObjectSetAnimation

;;
; Relates to mounting a companion?
;
; @param[out]	zflag	Set if mounted successfully?
companionTryToMount:
	ld a,(wActiveTileType)
	cp TILETYPE_HOLE
	jr z,@cantMount
.ifdef ROM_AGES
	ld a,(wDisallowMountingCompanion)
	or a
	jr nz,@cantMount

	call checkLinkVulnerableAndIDZero
.else
	call checkLinkID0AndControlNormal
.endif
	jr c,@tryMounting

@cantMount:
	or d
	ret

@tryMounting:
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	ld a,(wLinkSwimmingState)
	or a
	ret nz
	ld a,(wLinkGrabState)
	or a
	ret nz
	ld a,(wLinkInAir)
	or a
	ret nz

	; Link can mount the companion. Set up all variables accordingly.

	inc a
	ld (wDisableWarpTiles),a
	ld (wWarpsDisabled),a
	ld e,SpecialObject.state
	ld a,$03
	ld (de),a

	ld a,$ff

;;
; Sets Link's speed and speedZ to be the values needed for mounting or dismounting
; a companion.
;
; @param	a	Link's angle
setLinkMountingSpeed:
	ld (wLinkAngle),a
	ld a,$81
	ld (wLinkInAir),a
	ld (wDisableScreenTransitions),a
	ld hl,w1Link.angle
	ld (hl),a

	ld l,<w1Link.speed
	ld (hl),SPEED_80

	ld l,<w1Link.speedZ
	ld (hl),$40
	inc l
	ld (hl),$fe
	xor a
	ret

;;
; @param[out]	a	Hazard type (see "objectCheckIsOnHazard")
; @param[out]	cflag	Set if the companion is on a hazard
companionCheckHazards:
	call objectCheckIsOnHazard
	ld h,d
	ret nc

;;
; Sets a companion's state to 4, which handles falling in a hazard.
companionGotoHazardHandlingState:
	push af
	ld l,SpecialObject.state
	ld a,$04
	ldi (hl),a
	xor a
	ldi (hl),a ; [substate] = 0
	ldi (hl),a ; [counter1] = 0

	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECT_DIMITRI
	jr z,@ret
	ld (wDisableScreenTransitions),a
	ld a,SND_SPLASH
	call playSound
@ret:
	pop af
	scf
	ret

;;
companionDismountAndSavePosition:
	call companionDismount

	; The below code checks your animal companion, but ultimately appears to do the
	; same thing in all cases.

	ld e,SpecialObject.id
	ld a,(de)
	ld hl,wAnimalCompanion
	cp (hl)
	jr z,@normalDismount

	cp SPECIALOBJECT_RICKY
	jr z,@ricky
	cp SPECIALOBJECT_DIMITRI
	jr z,@dimitri
.ifdef ROM_AGES
@moosh:
	jr @normalDismount
@ricky:
	jr @normalDismount
@dimitri:
	jr @normalDismount
.else
@moosh:
	ld a,(wEssencesObtained)
	bit 4,a
	jr z,@normalDismount
	jr +
@ricky:
	ld a,(wFluteIcon)
	or a
	jr z,@normalDismount
	jr +
@dimitri:
	ld a,TREASURE_FLIPPERS
	call checkTreasureObtained
	jr nc,@normalDismount
+
.endif
	; Seasons-only (dismount and don't save companion's position)
	call saveLinkLocalRespawnAndCompanionPosition
	xor a
	ld (wRememberedCompanionId),a
	ret

@normalDismount:
	jr saveLinkLocalRespawnAndCompanionPosition

;;
; Called when dismounting an animal companion
;
companionDismount:
	lda SPECIALOBJECT_LINK
	call setLinkID
	ld hl,w1Link.oamFlagsBackup
	ldi a,(hl)
	ldd (hl),a

	ld h,d
	ldi a,(hl)
	ld (hl),a

	xor a
	ld l,SpecialObject.damageToApply
	ld (hl),a

	; Clear invincibilityCounter, knockbackAngle, knockbackCounter
	ld l,SpecialObject.invincibilityCounter
	ldi (hl),a
	ldi (hl),a
	ld (hl),a

	ld l,SpecialObject.var3c
	ld (hl),a

	ld (wLinkForceState),a
	ld (wcc50),a

	ld l,SpecialObject.enabled
	ld (hl),$01

	; Calculate angle based on direction
	ld l,SpecialObject.direction
	ldi a,(hl)
	swap a
	srl a
	ld (hl),a

	call setLinkMountingSpeed

	ld hl,w1Link.angle
	ld (hl),$ff

	call objectCopyPosition

	; Set w1Link.zh to $f8
	dec l
	ld (hl),$f8

	; Set wLinkObjectIndex to $d0 (no longer riding an animal)
	ld a,h
	ld (wLinkObjectIndex),a

	xor a
	ld (wDisableWarpTiles),a
	ld (wWarpsDisabled),a
	ld (wForceCompanionDismount),a
	ld (wDisableScreenTransitions),a
	jp setCameraFocusedObjectToLink

;;
saveLinkLocalRespawnAndCompanionPosition:
	ld hl,wRememberedCompanionId
	ld a,(w1Companion.id)
	ldi (hl),a

	ld a,(wActiveGroup)
	ldi (hl),a
	ld a,(wActiveRoom)
	ldi (hl),a

	ld a,(w1Companion.direction)
	ld (wLinkLocalRespawnDir),a

	ld a,(w1Companion.yh)
	ldi (hl),a
	ld (wLinkLocalRespawnY),a

	ld a,(w1Companion.xh)
	ldi (hl),a
	ld (wLinkLocalRespawnX),a
	ret

;;
; @param[out]	zflag	Set if the companion has reached the center of the hole
companionDragToCenterOfHole:
	ld e,SpecialObject.var3d
	ld a,(de)
	or a
	jr z,+
	xor a
	ret
+
	; Get the center of the hole tile in bc
	ld bc,$0500
	call objectGetRelativeTile
	ld c,l
	call convertShortToLongPosition_paramC

	; Now drag the companion's X and Y values toward the hole by $40 subpixels per
	; frame (for X and Y).
@adjustX:
	ld e,SpecialObject.xh
	ld a,(de)
	cp c
	ld c,$00
	jr z,@adjustY

	ld hl, $40
	jr c,+
	ld hl,-$40
+
	; [SpecialObject.x] += hl
	dec e
	ld a,(de)
	add l
	ld (de),a
	inc e
	ld a,(de)
	adc h
	ld (de),a

	dec c

@adjustY:
	ld e,SpecialObject.yh
	ld a,(de)
	cp b
	jr z,@return

	ld hl, $40
	jr c,+
	ld hl,-$40
+
	; [SpecialObject.y] += hl
	dec e
	ld a,(de)
	add l
	ld (de),a
	inc e
	ld a,(de)
	adc h
	ld (de),a

	dec c

@return:
	ld h,d
	ld a,c
	or a
	ret

;;
companionRespawn:
	xor a
	ld (wDisableScreenTransitions),a
	ld (wLinkForceState),a
	ld (wcc50),a

	; Set animal's position to respawn point, then check if the position is valid
	call specialObjectSetCoordinatesToRespawnYX
.ifdef ROM_SEASONS
	ld bc,$0500
	call objectGetRelativeTile
	cp $20
	jr nz,+
	ld h,d
	ld l,SpecialObject.yh
	ld a,(wRememberedCompanionY)
	ldi (hl),a
	inc l
	ld a,(wRememberedCompanionX)
	ldi (hl),a
+
.endif
	call objectCheckSimpleCollision
	jr nz,@invalidPosition

	call objectGetPosition
	call checkCollisionForCompanion
	jr c,@invalidPosition

	call objectCheckIsOnHazard
	jr nc,@applyDamageAndSetState

@invalidPosition:
	; Current position is invalid, so change respawn to the last animal mount point
	ld h,d
	ld l,SpecialObject.yh
	ld a,(wLastAnimalMountPointY)
	ld (wLinkLocalRespawnY),a
	ldi (hl),a
	inc l
	ld a,(wLastAnimalMountPointX)
	ld (wLinkLocalRespawnX),a
	ldi (hl),a

@applyDamageAndSetState:
	; Apply damage to Link only if he's on the companion
	ld a,(wLinkObjectIndex)
	rrca
	ld a,$01
	jr nc,@setState

	ld a,-2
	ld (w1Link.damageToApply),a
	ld a,$40
	ld (w1Link.invincibilityCounter),a

	ld a,$05
@setState:
	ld h,d
	ld l,SpecialObject.state
	ldi (hl),a
	xor a
	ld (hl),a ; [substate] = 0

	ld l,SpecialObject.var3d
	ld (hl),a
	ld (wDisableScreenTransitions),a

	ld l,SpecialObject.collisionType
	res 7,(hl)
	ret

;;
; Checks if a companion's moving toward a cliff from the top, to hop down if so.
;
; @param[out]	zflag	Set if the companion should hop down a cliff
companionCheckHopDownCliff:
	; Make sure we're not moving at an angle
	ld a,(wLinkAngle)
	ld c,a
	and $e7
	ret nz

	; Check that the companion's angle equals Link's angle?
	ld e,SpecialObject.angle
	ld a,(de)
	cp c
	ret nz

	call specialObjectCheckMovingTowardWall
	cp $03  ; Wall to the right?
	jr z,++
	cp $0c  ; Wall to the left?
	jr z,++
	cp $30  ; Wall below?
	ret nz
++
	; Get offset from companion's position for tile to check
	ld e,SpecialObject.direction
	ld a,(de)
	ld hl,@directionOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)

	call objectGetRelativeTile
	cp TILEINDEX_VINE_TOP
	jr z,@vineTop

	ld hl,cliffTilesTable
	call lookupCollisionTable
	jr c,@cliffTile

	or d
	ret

@vineTop:
	ld a,$10

@cliffTile:
	; 'a' should contain the desired angle to be moving in
	ld h,d
	ld l,SpecialObject.angle
	cp (hl)
	ret nz

	; Initiate hopping down

	ld a,$80
	ld (wLinkInAir),a
	ld bc,-$2c0
	call objectSetSpeedZ

	ld l,SpecialObject.speed
	ld (hl),SPEED_200
	ld l,SpecialObject.counter1
	ld a,$14
	ldi (hl),a
	xor a
	ld (hl),a ; [counter2] = 0

	ld l,SpecialObject.state
	ld a,$07
	ldi (hl),a
	xor a
	ld (hl),a ; [substate] = 0
	ret


@directionOffsets:
	.db $fa $00 ; DIR_UP
	.db $00 $04 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $fb ; DIR_LEFT

;;
; Sets a bunch of variables the moment Link completes the mounting animation.
companionFinalizeMounting:
	ld h,d
	ld l,SpecialObject.enabled
	set 1,(hl)

	ld l,SpecialObject.state
	ld (hl),$05

	ld l,SpecialObject.angle
	ld a,$ff
	ld (hl),a
	ld l,SpecialObject.var3c
	ld (hl),a

	; Give companion draw priority 1
	ld l,SpecialObject.visible
	ld a,(hl)
	and $c0
	or $01
	ld (hl),a

	xor a
	ld l,SpecialObject.var3d
	ld (hl),a
	ld (wLinkInAir),a
	ld (wDisableScreenTransitions),a

	ld bc,wLastAnimalMountPointY
	ld l,SpecialObject.yh
	ldi a,(hl)
	ld (bc),a
	inc c
	inc l
	ld a,(hl)
	ld (bc),a

	ld a,d
	ld (wLinkObjectIndex),a
	call setCameraFocusedObjectToLink
	ld a,SPECIALOBJECT_LINK_RIDING_ANIMAL
	jp setLinkID

;;
; Something to do with dismounting companions?
;
; @param[out]	zflag
companionFunc_47d8:
	ld h,d
	ld l,SpecialObject.var3c
	ld a,(hl)
	or a
	ret z
	ld a,(wLinkDeathTrigger)
	or a
	ret z

	xor a
	ld (hl),a ; [var3c] = 0
	ld e,SpecialObject.z
	ldi (hl),a
	ldi (hl),a

	ld l,SpecialObject.state
	ld (hl),$09
	ld e,SpecialObject.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a
	ld e,SpecialObject.visible
	xor a
	ld (de),a

	; Copy Link's position to companion
	ld h,>w1Link
	call objectCopyPosition
	ld a,h
	ld (wLinkObjectIndex),a
	call setCameraFocusedObjectToLink
	lda SPECIALOBJECT_LINK
	call setLinkID
	or d
	ret

;;
companionGotoDismountState:
	ld e,SpecialObject.var38
	ld a,(de)
	or a
	jr z,+
	xor a
	ld (wForceCompanionDismount),a
	ret
+
	; Go to state 6
	ld a,$06
	jr ++

;;
; Sets a companion's animation and returns to state 5, substate 0 (normal movement with
; Link)
;
; @param	c	Animation
companionSetAnimationAndGotoState5:
	call companionSetAnimation
	ld a,$05
++
	ld e,SpecialObject.state
	ld (de),a
	inc e
	xor a
	ld (de),a
	ret

;;
; Called on initialization of companion. Checks if its current position is ok to spawn at?
; If so, this sets the companion's state to [var03]+1.
;
; May return from caller.
;
companionCheckCanSpawn:
	ld e,SpecialObject.state
	ld a,(de)
	or a
	jr nz,@canSpawn

.ifdef ROM_AGES
	; Jump if [substate] != 0
	inc e
	ld a,(de)
	or a
	jr nz,++

	; Set [substate]=1, return from caller
	inc a
	ld (de),a
	pop af
	ret
++
	xor a
	ld (de),a ; [substate] = 0

	; Delete self if there's already a solid object in its position
	call objectGetShortPosition
	ld b,a
	ld a,:w2SolidObjectPositions
	ld ($ff00+R_SVBK),a
	ld a,b
	ld hl,w2SolidObjectPositions
	call checkFlag
	ld a,$00
	ld ($ff00+R_SVBK),a
	jr z,+
	pop af
	jp itemDelete
+
.endif

	; If the tile at the animal's feet is not completely solid or a hole, it can
	; spawn here.
	ld e,SpecialObject.yh
	ld a,(de)
	add $05
	ld b,a
	ld e,SpecialObject.xh
	ld a,(de)
	ld c,a
	call getTileCollisionsAtPosition
	cp SPECIALCOLLISION_HOLE
	jr z,+
	cp $0f
	jr nz,@canSpawn
+
	; It can't spawn where it is, so try to spawn it somewhere else.
	ld hl,wLastAnimalMountPointY
	ldi a,(hl)
	ld e,SpecialObject.yh
	ld (de),a
	ld a,(hl)
	ld e,SpecialObject.xh
	ld (de),a
	call objectGetTileCollisions
	jr z,@canSpawn
	pop af
	jp itemDelete

@canSpawn:
	call specialObjectSetOamVariables

	ld hl,w1Companion.var03
	ldi a,(hl)
	inc a
	ld (hl),a ; [state] = [var03]+1

	ld l,SpecialObject.collisionType
	ld (hl),$80|ITEMCOLLISION_LINK
	ret

;;
; Returns from caller if the companion should not be updated right now.
;
companionRetIfInactive:
	; Always update when in state 0 (uninitialized)
	ld e,SpecialObject.state
	ld a,(de)
	or a
	ret z

	; Don't update when text is on-screen
	ld a,(wTextIsActive)
	or a
	jr nz,companionRetIfInactiveWithoutStateCheck@ret

;;
companionRetIfInactiveWithoutStateCheck:
	; Don't update when screen is scrolling, palette is fading, or wDisabledObjects is
	; set to something.
	ld a,(wScrollMode)
	and $0e
	jr nz,@ret
	ld a,(wPaletteThread_mode)
	or a
	jr nz,@ret
	ld a,(wDisabledObjects)
	and (DISABLE_ALL_BUT_INTERACTIONS | DISABLE_COMPANION)
	ret z
@ret:
	pop af
	ret

;;
companionSetAnimationToVar3f:
	ld h,d
	ld l,SpecialObject.var3f
	ld a,(hl)
	ld l,SpecialObject.animMode
	cp (hl)
	jp nz,specialObjectSetAnimation
	ret

;;
; Manipulates a companion's oam flags to make it flash when charging an attack.
companionFlashFromChargingAnimation:
	ld hl,w1Link.oamFlagsBackup
	ld a,(wFrameCounter)
	bit 2,a
	jr nz,++
	ldi a,(hl)
	and $f8
	or c
	ld (hl),a
	ret
++
	ldi a,(hl)
	ld (hl),a
	ret

;;
; @param[out]	zflag	Set if complete
companionCheckMountingComplete:
	; Check if something interrupted the mounting?
.ifdef ROM_AGES
	ld a,(wDisallowMountingCompanion)
	or a
	jr nz,@stopMounting
.endif
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	jr nz,@stopMounting
	ld a,(wLinkGrabState)
	or a
	jr z,@continue

@stopMounting:
	xor a
	ld (wDisableWarpTiles),a
	ld (wWarpsDisabled),a
	ld (wDisableScreenTransitions),a
	ld a,$01
	ld e,SpecialObject.state
	ld (de),a
	or d
	ret

@continue:
	ld hl,w1Link.yh
	ld e,SpecialObject.yh
	ld a,(de)
	cp (hl)
	call nz,@nudgeLinkTowardCompanion

	ld e,SpecialObject.xh
	ld l,e
	ld a,(de)
	cp (hl)
	call nz,@nudgeLinkTowardCompanion

	; Check if Link has fallen far enough down to complete the mounting animation
	ld l,<w1Link.speedZ+1
	bit 7,(hl)
	ret nz
	ld l,SpecialObject.zh
	ld a,(hl)
	cp $fc
	ret c
	xor a
	ret

@nudgeLinkTowardCompanion:
	jr c,+
	inc (hl)
	ret
+
	dec (hl)
	ret

;;
companionCheckEnableTerrainEffects:
	ld h,d
	ld l,SpecialObject.enabled
	ld a,(hl)
	or a
	ret z

	ld l,SpecialObject.var3c
	ld a,(hl)
	ld (wWarpsDisabled),a

	; If in midair, enable terrain effects for shadows
	ld l,SpecialObject.zh
	ldi a,(hl)
	bit 7,a
	jr nz,@enableTerrainEffects

	; If on puddle, enable terrain effects for that
	ld bc,$0500
	call objectGetRelativeTile
	ld h,d
.ifdef ROM_AGES
	cp TILEINDEX_PUDDLE
	jr nz,@label_05_067
.else
	cp TILEINDEX_PUDDLE
	jr z,+
	cp TILEINDEX_PUDDLE+1
	jr z,+
	cp TILEINDEX_PUDDLE+2
	jr nz,@label_05_067
+
.endif

	; Disable terrain effects
	ld l,SpecialObject.visible
	res 6,(hl)
	ret

@label_05_067:
	ld l,SpecialObject.zh
	ld (hl),$00

@enableTerrainEffects:
	ld l,SpecialObject.visible
	set 6,(hl)
	ret

;;
; Set the animal's draw priority relative to Link's position.
companionSetPriorityRelativeToLink:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	dec b
	and $c0
	or b
	ld (de),a
	ret

;;
; Decrements counter1, and once it reaches 0, it plays the "jump" sound effect.
;
; @param[out]	cflag	nc if counter1 has reached 0 (should jump down the cliff).
; @param[out]	zflag	Same as carry
companionDecCounter1ToJumpDownCliff:
	ld e,SpecialObject.counter1
	ld a,(de)
	or a
	jr z,@animate

	dec a
	ld (de),a
	ld a,SND_JUMP
	scf
	ret nz
	call playSound
	xor a
	scf
	ret

@animate:
	call specialObjectAnimate
	call objectApplySpeed
	ld c,$40
	call objectUpdateSpeedZ_paramC
	or d
	ret

;;
companionDecCounter1IfNonzero:
	ld h,d
	ld l,SpecialObject.counter1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

;;
; Updates animation, and respawns the companion when the animation is over (bit 7 of
; animParameter is set).
;
; @param[out]	cflag	Set if the animation finished and the companion has respawned.
companionAnimateDrowningOrFallingThenRespawn:
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	rlca
	ret nc

	call companionRespawn
	scf
	ret

;;
; @param[out]	hl	Companion's counter2 variable
companionInitializeOnEnteringScreen:
	call companionCheckCanSpawn
	ld l,SpecialObject.state
	ld (hl),$0c
	ld l,SpecialObject.var03
	inc (hl)
	ld l,SpecialObject.counter2
	jp objectSetVisiblec1

;;
; Used with dimitri and moosh when they're walking into the screen.
;
; @param	hl	Table of direction offsets
companionRetIfNotFinishedWalkingIn:
	; Check that the tile in front has collision value 0
	call specialObjectGetRelativeTileWithDirectionTable
	or a
	ret nz

	; Decrement counter2
	ld e,SpecialObject.counter2
	ld a,(de)
	dec a
	ld (de),a
	ret z

	; Return from caller if counter2 is nonzero
	pop af
	ret

;;
companionForceMount:
	ld a,(wMenuDisabled)
	push af
	xor a
	ld (wMenuDisabled),a
	ld (w1Link.invincibilityCounter),a
	call companionTryToMount
	pop af
	ld (wMenuDisabled),a
	ret

;;
companionDecCounter1:
	ld h,d
	ld l,SpecialObject.counter1
	ld a,(hl)
	or a
	ret

;;
specialObjectTryToBreakTile_source05:
	ld h,d
	ld l,<w1Link.yh
	ldi a,(hl)
	inc l
	ld c,(hl)
	add $05
	ld b,a
	ld a,BREAKABLETILESOURCE_LANDED
	jp tryToBreakTile
