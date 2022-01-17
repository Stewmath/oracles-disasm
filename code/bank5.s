;;
updateSpecialObjects:
	ld hl,wLinkIDOverride
	ld a,(hl)
	ld (hl),$00
	or a
	jr z,+
	and $7f
	ld (w1Link.id),a
+
.ifdef ROM_AGES
	ld hl,w1Link.var2f
	ld a,(hl)
	and $3f
	ld (hl),a

	ld a,TREASURE_MERMAID_SUIT
	call checkTreasureObtained
	jr nc,+
	set 6,(hl)
+
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	jr z,+
	set 7,(hl)
+
.endif

	xor a
	ld (wBraceletGrabbingNothing),a
	ld (wcc92),a
	ld (wForceLinkPushAnimation),a

	ld hl,wcc95
	ld a,(hl)
	or $7f
	ld (hl),a

	ld hl,wLinkTurningDisabled
	res 7,(hl)

	call updateGameKeysPressed

	ld hl,w1Companion
	call @updateSpecialObject

	xor a
	ld (wLinkClimbingVine),a
.ifdef ROM_AGES
	ld (wDisallowMountingCompanion),a
.endif

	ld hl,w1Link
	call @updateSpecialObject

	call updateLinkInvincibilityCounter

	ld a,(wLinkPlayingInstrument)
	ld (wLinkRidingObject),a

	ld hl,wLinkImmobilized
	ld a,(hl)
	and $0f
	ld (hl),a

	xor a
	ld (wcc67),a
	ld (w1Link.var2a),a
	ld (wccd8),a

	ld hl,wInstrumentsDisabledCounter
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld hl,wGrabbableObjectBuffer
	ld b,$10
	jp clearMemory

;;
; @param hl Object to update (w1Link or w1Companion)
@updateSpecialObject:
	ld a,(hl)
	or a
	ret z

	ld a,l
	ldh (<hActiveObjectType),a
	ld a,h
	ldh (<hActiveObject),a
	ld d,h

	ld l,Object.id
	ld a,(hl)
	rst_jumpTable
	.dw specialObjectCode_link
.ifdef ROM_AGES
	.dw specialObjectCode_transformedLink
.else
	.dw specialObjectCode_subrosiaDanceLink
.endif
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_linkInCutscene
	.dw specialObjectCode_linkRidingAnimal
	.dw specialObjectCode_minecart
	.dw specialObjectCode_ricky
	.dw specialObjectCode_dimitri
	.dw specialObjectCode_moosh
	.dw specialObjectCode_maple
	.dw specialObjectCode_companionCutscene
	.dw specialObjectCode_companionCutscene
	.dw specialObjectCode_companionCutscene
	.dw specialObjectCode_companionCutscene
	.dw specialObjectCode_raft

;;
; Updates wGameKeysPressed based on wKeysPressed, and updates wLinkAngle based on
; direction buttons pressed.
updateGameKeysPressed:
	ld a,(wKeysPressed)
	ld c,a

	ld a,(wUseSimulatedInput)
	or a
	jr z,@updateKeysPressed_c

	cp $02
	jr z,@reverseMovement

	call getSimulatedInput
	jr @updateKeysPressed_a

	; This code is used in the Ganon fight where he reverses Link's movement?
@reverseMovement:
	xor a
	ld (wUseSimulatedInput),a
	ld a,BTN_DOWN | BTN_LEFT
	and c
	rrca
	ld b,a

	ld a,BTN_UP | BTN_RIGHT
	and c
	rlca
	or b
	ld b,a

	ld a,$0f
	and c
	or b

@updateKeysPressed_a:
	ld c,a
@updateKeysPressed_c:
	ld a,(wLinkDeathTrigger)
	or a
	ld hl,wGameKeysPressed
	jr nz,@dying

	; Update wGameKeysPressed, wGameKeysJustPressed based on the value of 'c'.
	ld a,(hl)
	cpl
	ld b,a
	ld a,c
	ldi (hl),a
	and b
	ldi (hl),a

	; Update Link's angle based on the direction buttons pressed.
	ld a,c
	and $f0
	swap a
	ld hl,@directionButtonToAngle
	rst_addAToHl
	ld a,(hl)
	ld (wLinkAngle),a
	ret

@dying:
	; Clear wGameKeysPressed, wGameKeysJustPressed
	xor a
	ldi (hl),a
	ldi (hl),a

	; Set wLinkAngle to $ff
	dec a
	ldi (hl),a
	ret

; Index is direction buttons pressed, value is the corresponding angle.
@directionButtonToAngle:
	.db $ff $08 $18 $ff $00 $04 $1c $ff
	.db $10 $0c $14 $ff $ff $ff $ff

;;
; This is called when Link is riding something (wLinkObjectIndex == $d1).
;
func_410d:
	xor a
	ldh (<hActiveObjectType),a
	ld de,w1Companion.id
	ld a,d
	ldh (<hActiveObject),a
	ld a,(de)
	sub SPECIALOBJECTID_MINECART
	rst_jumpTable

	.dw @ridingMinecart
	.dw @ridingRicky
	.dw @ridingDimitri
	.dw @ridingMoosh
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @ridingRaft

@invalid:
	ret

@ridingRicky:
	ld bc,$0000
	jr @companion

@ridingDimitri:
	ld e,<w1Companion.direction
	ld a,(de)
	rrca
	ld bc,$f600
	jr nc,@companion

	ld c,$fb
	rrca
	jr nc,@companion

	ld c,$05
	jr @companion

@ridingMoosh:
	ld e,SpecialObject.direction
	ld a,(de)
	rrca
	ld bc,$f200
	jr nc,@companion
	ld b,$f0

;;
; @param	bc	Position offset relative to companion to place Link at
@companion:
	ld hl,w1Link.yh
	call objectCopyPositionWithOffset

	ld e,<w1Companion.direction
	ld l,<w1Link.direction
	ld a,(de)
	ld (hl),a
	ld a,$01
	ld (wDisableWarpTiles),a

	ld l,<w1Link.var2a
	ldi a,(hl)
	or (hl)
	ld l,<w1Link.knockbackCounter
	or (hl)
	jr nz,@noDamage
	ld l,<w1Link.damageToApply
	ld e,l
	ld a,(de)
	or a
	jr z,@noDamage

	ldi (hl),a ; [w1Link.damageToApply] = [w1Companion.damageToApply]

	; Copy health, var2a, invincibilityCounter, knockbackAngle, knockbackCounter,
	; stunCounter from companion to Link.
	ld l,<w1Link.health
	ld e,l
	ld b,$06
	call copyMemoryReverse
	jr @label_05_010

@noDamage:
	ld l,<w1Link.damageToApply
	ld e,l
	ld a,(hl)
	ld (de),a

	; Copy health, var2a, invincibilityCounter, knockbackAngle, knockbackCounter,
	; stunCounter from Link to companion.
	ld d,>w1Link
	ld h,>w1Companion
	ld l,SpecialObject.health
	ld e,l
	ld b,$06
	call copyMemoryReverse

@label_05_010:
	ld h,>w1Link
	ld d,>w1Companion
	ld l,<w1Link.oamFlags
	ld a,(hl)
	ld l,<w1Link.oamFlagsBackup
	cp (hl)
	jr nz,+
	ld e,<w1Companion.oamFlagsBackup
	ld a,(de)
+
	ld e,<w1Companion.oamFlags
	ld (de),a
	ld l,<w1Link.visible
	ld e,l
	ld a,(de)
	and $83
	ld (hl),a
	ret

@ridingMinecart:
	ld h,d
	ld l,<w1Companion.direction
	ld a,(hl)
	ld l,<w1Companion.animParameter
	add (hl)
	ld hl,@linkOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	ld hl,w1Link.yh
	call objectCopyPositionWithOffset

	; Disable terrain effects on Link
	ld l,<w1Link.visible
	res 6,(hl)

	ret


; Data structure:
;   Each row corresponds to a frame of the minecart animation.
;   Each column corresponds to a direction.
;   Each 2 bytes are a position offset for Link relative to the minecart.
@linkOffsets:
;           --Up--   --Right-- --Down-- --Left--
	.db $f7 $00  $f7 $00   $f7 $00  $f7 $00
	.db $f7 $ff  $f8 $00   $f7 $ff  $f8 $00

;;
@ridingRaft:
.ifdef ROM_AGES
	ld a,(wLinkForceState)
	cp LINK_STATE_RESPAWNING
	ret z

	ld hl,w1Link.state
	ldi a,(hl)
	cp LINK_STATE_RESPAWNING
	jr nz,++
	ldi a,(hl) ; Check w1Link.substate
	cp $03
	ret c
++
	; Disable terrain effects on Link
	ld l,<w1Link.visible
	res 6,(hl)

	; Set Link's position to be 5 or 6 pixels above the raft, depending on the frame
	; of animation
	ld bc,$fb00
	ld e,<w1Companion.animParameter
	ld a,(de)
	or a
	jr z,+
	dec b
+
	call objectCopyPositionWithOffset
	jp objectSetVisiblec3
.endif

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
; constants/tileTypes.s).
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
; Gets the tile type of the tile link is standing on (see constants/tileTypes.s).
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

	ld a,BREAKABLETILESOURCE_13
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
	cp SPECIALOBJECTID_RICKY
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
	cp SPECIALOBJECTID_DIMITRI
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
	cp SPECIALOBJECTID_DIMITRI
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

	cp SPECIALOBJECTID_RICKY
	jr z,@ricky
	cp SPECIALOBJECTID_DIMITRI
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
	lda SPECIALOBJECTID_LINK
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
	ld a,SPECIALOBJECTID_LINK_RIDING_ANIMAL
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
	lda SPECIALOBJECTID_LINK
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
	ld a,BREAKABLETILESOURCE_05
	jp tryToBreakTile

;;
; Update the link object.
; @param d Link object
specialObjectCode_link:
	ld e,<w1Link.state
	ld a,(de)
	rst_jumpTable
	.dw linkState00
	.dw linkState01
	.dw linkState02
	.dw linkState03
	.dw linkState04
	.dw linkState05
	.dw linkState06
	.dw linkState07
	.dw linkState08
	.dw linkState09
	.dw linkState0a
	.dw linkState0b
	.dw linkState0c
	.dw linkState0d
	.dw linkState0e
	.dw linkState0f
	.dw linkState10
	.dw linkState11
	.dw linkState12
	.dw linkState13
	.dw linkState14

;;
; LINK_STATE_00
linkState00:
	call clearAllParentItems
	call specialObjectSetOamVariables
	ld a,LINK_ANIM_MODE_WALK
	call specialObjectSetAnimation

	; Enable collisions?
	ld h,d
	ld l,SpecialObject.collisionType
	ld a,$80
	ldi (hl),a

	; Set collisionRadiusY,X
	inc l
	ld a,$06
	ldi (hl),a
	ldi (hl),a

	; A non-dead default health?
	ld l,SpecialObject.health
	ld (hl),$01

	; Do a series of checks to see whether Link spawned in an invalid position.

	ld a,(wLinkForceState)
	cp LINK_STATE_WARPING
	jr z,+

	ld a,(wDisableRingTransformations)
	or a
	jr nz,+

	; Check if he's in a solid wall
	call objectGetTileCollisions
	cp $0f
	jr nz,+

	; If he's in a wall, move Link to wLastAnimalMountPointY/X?
	ld hl,wLastAnimalMountPointY
	ldi a,(hl)
	ld e,<w1Link.yh
	ld (de),a
	ld a,(hl)
	ld e,<w1Link.xh
	ld (de),a
+
	call objectSetVisiblec1
	call checkLinkForceState
	jp initLinkStateAndAnimateStanding

;;
; LINK_STATE_WARPING
linkState0a:
	ld a,(wWarpTransition)
	and $0f
	rst_jumpTable
	.dw warpTransition0
	.dw warpTransition1
	.dw warpTransition2
	.dw warpTransition3
	.dw warpTransition4
	.dw warpTransition5
	.dw warpTransition6
.ifdef ROM_AGES
	.dw warpTransitionA
.else
	.dw warpTransition7
.endif
	.dw warpTransition8
	.dw warpTransition9
	.dw warpTransitionA
	.dw warpTransitionB
	.dw warpTransitionC
	.dw warpTransitionA
	.dw warpTransitionE
	.dw warpTransitionF

;;
; TRANSITION_DEST_BASIC
warpTransition0:
	call warpTransition_setLinkFacingDir
;;
; TRANSITION_DEST_UNKNOWN_A
warpTransitionA:
	jp initLinkStateAndAnimateStanding

;;
; TRANSITION_DEST_X_SHIFTED
; Shifts Link's X position left 8, but otherwise behaves like Transition 1
warpTransitionE:
	call objectCenterOnTile
	ld a,(hl)
	and $f0
	ld (hl),a

;;
; TRANSITION_DEST_SET_RESPAWN
; Behaves like transition 0, but saves link's deathwarp point
warpTransition1:
	call warpTransition_setLinkFacingDir

;;
warpUpdateRespawnPoint:
	ld a,(wActiveGroup)
	cp NUM_UNIQUE_GROUPS ; Don't update respawn point in sidescrolling rooms?
	jr nc,warpTransition0
	call setDeathRespawnPoint
	call updateLinkLocalRespawnPosition
	jp initLinkStateAndAnimateStanding

;;
; TRANSITION_DEST_UNKNOWN_C
; Behaves like transition 0, but sets link's facing direction in a way I don't understand
warpTransitionC:
	ld a,(wcc50)
	and $03
	ld e,<w1Link.direction
	ld (de),a
	jp initLinkStateAndAnimateStanding

;;
warpTransition_setLinkFacingDir:
	call objectGetTileAtPosition
	ld hl,facingDirAfterWarpTable
	call lookupCollisionTable
	jr c,+
	ld a,DIR_DOWN
+
	ld e,<w1Link.direction
	ld (de),a
	ret

facingDirAfterWarpTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES

@collisions1:
	.db $36 DIR_UP ; Cave opening?

@collisions2:
@collisions3:
	.db $44 DIR_LEFT  ; Up stairs
	.db $45 DIR_RIGHT ; Down stairs

@collisions0:
@collisions4:
@collisions5:
	.db $00

.else ; ROM_SEASONS

@collisions3:
	.db $36 DIR_UP
@collisions4:
@collisions5:
	.db $44 DIR_LEFT
	.db $45 DIR_RIGHT
@collisions0:
@collisions1:
@collisions2:
	.db $00

.endif

;;
; TRANSITION_SRC_FADEOUT
; Screen fades out.
warpTransition2:
	ld a,$03
	ld (wWarpTransition2),a
	ld a,SND_ENTERCAVE
	jp playSound

;;
; TRANSITION_DEST_ENTERSCREEN
; TRANSITION_SRC_LEAVESCREEN
; Used by both sources and destinations for transitions where link walks off the screen (or comes in
; from off the screen). It saves link's deathwarp point.
warpTransition3:
	ld e,<w1Link.warpVar1
	ld a,(de)
	or a
	jr nz,@eachFrame

	; Initialization stuff
	ld h,d
	ld l,e
	inc (hl)
	ld l,<w1Link.warpVar2
	ld (hl),$10

	; Set link speed, up or down
	ld a,(wWarpTransition)
	and $40
	swap a
	rrca
	ld bc,@directionTable
	call addAToBc
	ld l,<w1Link.direction
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ld (hl),a

	call updateLinkSpeed_standard
	call animateLinkStanding
	ld a,(wWarpTransition)
	rlca
	jr c,@destInit

	ld a,SND_ENTERCAVE
	jp playSound

@directionTable:
	.db $00 $00
	.db $02 $10

@eachFrame:
	ld a,(wScrollMode)
	and $0a
	ret nz

	ld a,$00
	ld (wScrollMode),a
	call specialObjectAnimate
	call itemDecCounter1
	jp nz,specialObjectUpdatePosition

	; Counter has reached zero
	ld a,$01
	ld (wScrollMode),a
	xor a
	ld (wMenuDisabled),a

	; Update respawn point if this is a destination
	ld a,(wWarpTransition)
	bit 7,a
	jp nz,warpUpdateRespawnPoint

	swap a
	and $03
	ld (wWarpTransition2),a
	ret

@destInit:
	ld h,d
	ld a,(wWarpDestPos)
	cp $ff
	jr z,@enterFromMiddleBottom

	cp $f0
	jr nc,@enterFromBottom

	ld l,<w1Link.yh
	call setShortPosition
	ld l,<w1Link.warpVar2
	ld (hl),$1c
	jp initLinkStateAndAnimateStanding

@enterFromMiddleBottom:
	ld a,$01
	ld (wMenuDisabled),a
	ld l,<w1Link.warpVar2
	ld (hl),$1c
	ld a,(wWarpTransition)
	and $40
	swap a
	ld b,a
	ld a,(wActiveGroup)
	and NUM_SMALL_GROUPS
	rrca
	or b
	ld bc,@linkPosTable
	call addAToBc
	ld l,<w1Link.yh
	ld a,(bc)
	ldi (hl),a
	inc bc
	inc l
	ld a,(bc)
	ld (hl),a
	ret

@enterFromBottom:
	call @enterFromMiddleBottom
	ld a,(wWarpDestPos)
	swap a
	and $f0
	ld b,a

	; Add +8 to link's X position if in a large room
	ld a,(wActiveGroup)
	and NUM_SMALL_GROUPS
	jr z,+
	rlca
+
	or b
	ld l,<w1Link.xh
	ld (hl),a
	ret

@linkPosTable:
	.db $80 $50 ; small room, enter from bottom
	.db $b0 $78 ; large room, enter from bottom
	.db $f0 $50 ; small room, enter from top
	.db $f0 $78 ; large room, enter from top

;;
; TRANSITION_DEST_DONT_SET_RESPAWN
; TRANSITION_SRC_INSTANT
warpTransition4:
	ld a,(wWarpTransition)
	rlca
	jp c,warpTransition0

	ld a,$01
	ld (wWarpTransition2),a
	ld a,SND_ENTERCAVE
	jp playSound

;;
; TRANSITION_DEST_FALL
; Link falls into the screen
warpTransition5:
	ld e,<w1Link.warpVar1
	ld a,(de)
	rst_jumpTable
	.dw warpTransition5_00
	.dw warpTransition5_01
	.dw warpTransition5_02

warpTransition5_00:
	ld a,$01
	ld (de),a
	ld bc,$0020
	call objectSetSpeedZ
	call objectGetZAboveScreen
	ld l,<w1Link.zh
	ld (hl),a
	ld l,<w1Link.yh
	ld a,(hl)
	sub $04
	ld (hl),a
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	ld a,LINK_ANIM_MODE_FALL
	jp specialObjectSetAnimation

warpTransition5_01:
	call specialObjectAnimate
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; BUG(?): the "objectGetTileAtPosition" function call was removed in Ages, but this seems to
	; have been a mistake, since the value of the "a" register from that call is needed for the
	; "lookupCollisionTable" function call below.
	; Despite this, there don't seem to be any particular problems when using this transition
	; type in Ages, but it may look a bit weird if used on top of a water tile.

.ifdef ROM_SEASONS
	call objectGetTileAtPosition
	cp TILEINDEX_TRAMPOLINE
	jr z,@trampoline
.else; ROM_AGES
.ifdef ENABLE_BUGFIXES
	call objectGetTileAtPosition
.endif
.endif

	; If he didn't fall into a hazard, make link "collapse" when he lands.
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	jp nc,warpTransition7@linkCollapsed
	jp initLinkStateAndAnimateStanding

.ifdef ROM_SEASONS
@trampoline:
	ld a,(wActiveGroup)
	and $06
	cp $04
	jp nz,warpTransition7@linkCollapsed
	; group 4/5
	jp bounceLinkOffTrampolineAfterFalling
.endif


.ifdef ROM_SEASONS

; TRANSITION_DEST_FROM_TRAMPOLINE
; Jumped in from a trampoline.
warpTransition6:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw warpTransition6_00
	.dw warpTransition6_01

warpTransition6_00:
	ld a,$01
	ld (de),a

	ld a,(wcc50)
	bit 7,a
	jr z,+
	rrca
	and $0f
	ld (wcc50),a
	ld a,LINK_STATE_BOUNCING_ON_TRAMPOLINE
	jp linkSetState
+
	ld bc,-$300
	call objectSetSpeedZ
	ld l,SpecialObject.counter1
	ld (hl),120
	ld l,SpecialObject.yh
	ld a,(hl)
	sub $04
	ld (hl),a
	ld a,LINK_ANIM_MODE_FALL
	call specialObjectSetAnimation

warpTransition6_01:
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jr z,@hitGround
	call specialObjectAnimate
	call specialObjectUpdateAdjacentWallsBitset
	ld e,SpecialObject.speed
	ld a,SPEED_80
	ld (de),a
	ld a,(wLinkAngle)
	ld e,SpecialObject.angle
	ld (de),a
	call updateLinkDirectionFromAngle
	jp specialObjectUpdatePosition

@hitGround:
	call objectGetTileAtPosition
	cp TILEINDEX_TRAMPOLINE
	jp z,bounceLinkOffTrampolineAfterFalling
	jp initLinkStateAndAnimateStanding
.endif


;;
; TRANSITION_DEST_FALL_INTO_HOLLYS_HOUSE
; Only used in Seasons.
warpTransition7:
	ld e,<w1Link.warpVar1
	ld a,(de)
	rst_jumpTable
	.dw @warpVar0
	.dw @warpVar1
	.dw @warpVar2
	.dw @warpVar3

@warpVar0:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	inc l
	ld (hl),$10
	ld l,<w1Link.speed
	ld (hl),SPEED_100

	ld l,<w1Link.visible
	res 7,(hl)

	ld l,<w1Link.warpVar2
	ld (hl),120

	ld a,LINK_ANIM_MODE_FALL
	call specialObjectSetAnimation

	ld a,SND_LINK_FALL
	jp playSound

@warpVar1:
	call itemDecCounter1
	ret nz

	ld l,<w1Link.warpVar1
	inc (hl)
	ld l,<w1Link.visible
	set 7,(hl)
	ld l,<w1Link.warpVar2
	ld (hl),$30
	ld a,$10
	call setScreenShakeCounter
	ld a,SND_SCENT_SEED
	jp playSound

;;
@warpVar2:
	call specialObjectAnimate
	call itemDecCounter1
	jp nz,specialObjectUpdatePosition
;;
@linkCollapsed:
	call itemIncSubstate
	ld l,<w1Link.warpVar2
	ld (hl),$1e
	ld a,LINK_ANIM_MODE_COLLAPSED
	call specialObjectSetAnimation
	ld a,SND_SPLASH
	jp playSound

;;
@warpVar3:
	call setDeathRespawnPoint

warpTransition5_02:
	call itemDecCounter1
	ret nz
	jp initLinkStateAndAnimateStanding

;;
linkIncrementDirectionOnOddFrames:
	ld a,(wFrameCounter)
	rrca
	ret nc

;;
linkIncrementDirection:
	ld e,<w1Link.direction
	ld a,(de)
	inc a
	and $03
	ld (de),a
	ret

;;
; TRANSITION_SRC_SUBROSIA
; A subrosian warp portal.
warpTransition8:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

@substate0:
	ld a,$01
	ld (de),a
	ld a,$ff
	ld (wDisabledObjects),a
	ld a,$80
	ld (wMenuDisabled),a
	ld a,CUTSCENE_S_15
	ld (wCutsceneTrigger),a

	ld bc,$ff60
	call objectSetSpeedZ

	ld l,SpecialObject.counter1
	ld (hl),$30

	call linkCancelAllItemUsage
	call restartSound

	ld a,SND_FADEOUT
	call playSound
	jp objectCenterOnTile

@substate1:
	ld c,$02
	call objectUpdateSpeedZ_paramC
	ld a,(wFrameCounter)
	and $03
	jr nz,+
	ld hl,wTmpcbbc
	inc (hl)
+
	ld a,(wFrameCounter)
	and $03
	call z,linkIncrementDirection
	call itemDecCounter1
	ret nz
	jp itemIncSubstate

@substate2:
	ld c,$02
	call objectUpdateSpeedZ_paramC
	call linkIncrementDirectionOnOddFrames

	ld h,d
	ld l,SpecialObject.speedZ+1
	bit 7,(hl)
	ret nz

	ld l,SpecialObject.counter1
	ld (hl),$28

	ld a,$02
	call fadeoutToWhiteWithDelay

	jp itemIncSubstate

@substate3:
	call linkIncrementDirectionOnOddFrames
	call itemDecCounter1
	ret nz
	ld hl,wTmpcbb3
	inc (hl)
	jp itemIncSubstate

@substate4:
	call linkIncrementDirectionOnOddFrames
	ld a,(wCutsceneState)
	cp $02
	ret nz
	call itemIncSubstate
	ld l,SpecialObject.counter1
	ld (hl),$28
	ret

@substate5:
	ld c,$02
	call objectUpdateSpeedZ_paramC
	call linkIncrementDirectionOnOddFrames
	call itemDecCounter1
	ret nz
	jp itemIncSubstate

@substate6:
	ld c,$02
	call objectUpdateSpeedZ_paramC
	ld a,(wFrameCounter)
	and $03
	ret nz

	call linkIncrementDirection
	ld hl,wTmpcbbc
	dec (hl)
	ret nz

	ld hl,wTmpcbb3
	inc (hl)
	jp itemIncSubstate

@substate7:
	ld a,(wDisabledObjects)
	and $81
	jr z,+

	ld a,(wFrameCounter)
	and $07
	ret nz
	jp linkIncrementDirection
+
	ld e,SpecialObject.direction
	ld a,(de)
	cp $02
	jp nz,linkIncrementDirection
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	call setDeathRespawnPoint
	call updateLinkLocalRespawnPosition
	call resetLinkInvincibility
	jp initLinkStateAndAnimateStanding

;;
; TRANSITION_SRC_FALL
; Fall out of the screen (like into a hole).
warpTransition9:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call itemIncSubstate

	ld l,SpecialObject.yh
	ld a,$08
	add (hl)
	ld (hl),a

	call objectCenterOnTile
	call clearAllParentItems

	ld a,LINK_ANIM_MODE_FALLINHOLE
	call specialObjectSetAnimation

	ld a,SND_LINK_FALL
	jp playSound

@substate1:
	ld e,SpecialObject.animParameter
	ld a,(de)
	inc a
	jp nz,specialObjectAnimate

	ld a,$03
	ld (wWarpTransition2),a
	ret

;;
; TRANSITION_DEST_SLOWFALL
; Transition used in the beginning of the game. Updates respawn point.
warpTransitionB:
	ld e,<w1Link.warpVar1
	ld a,(de)
	rst_jumpTable
	.dw @warpVar0
	.dw @warpVar1
	.dw @warpVar2

@warpVar0:
	call itemIncSubstate

	call objectGetZAboveScreen
	ld l,<w1Link.zh
	ld (hl),a

	ld l,<w1Link.direction
	ld (hl),DIR_DOWN

	ld a,LINK_ANIM_MODE_FALL
	jp specialObjectSetAnimation

@warpVar1:
	call specialObjectAnimate
	ld c,$0c
	call objectUpdateSpeedZ_paramC
	ret nz

	; Done falling. Set Link's initial state depending on the game.

.ifdef ROM_AGES
	call itemIncSubstate
	call animateLinkStanding
	ld a,SND_SPLASH
	jp playSound
.else
	xor a
	ld (wDisabledObjects),a
	ld a,SPECIALOBJECTID_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,SpecialObject.subid
	ld (hl),$02
	ret
.endif

@warpVar2:
	ld a,(wDisabledObjects)
	and $81
	ret nz

	call objectSetVisiblec2
	jp initLinkStateAndAnimateStanding


;;
; TRANSITION_DEST_INVISIBLE
; Link does not appear.
warpTransitionF:
	call checkLinkForceState
	jp objectSetInvisible


.ifdef ROM_AGES

;;
; TRANSITION_DEST_TIMEWARP
; Warp in and create a portal. Doesn't update respawn. Ages only.
warpTransition6:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

;;
@flickerVisibilityAndDecCounter1:
	ld b,$03
	call objectFlickerVisibility
	jp itemDecCounter1

;;
@createDestinationTimewarpAnimation:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TIMEWARP
	inc l
	inc (hl)

	; [Interaction.var03] = [wcc50]
	ld a,(wcc50)
	inc l
	ld (hl),a
	ret

;;
; This function should center Link if it detects that he's warped into a 2-tile-wide
; doorway.
; Except, it doesn't work. There's a typo.
@centerLinkOnDoorway:
	call objectGetTileAtPosition
	push hl

	; BUG: This should be "ld e,a" instead of "ld a,e".
	ld a,e

	ld hl,@doorTiles
	call findByteAtHl
	pop hl
	ret nc

	push hl
	dec l
	ld e,(hl)
	ld hl,@doorTiles
	call findByteAtHl
	pop hl
	jr nc,+

	ld e,SpecialObject.xh
	ld a,(de)
	and $f0
	ld (de),a
	ret
+
	inc l
	ld e,(hl)
	ld hl,@doorTiles
	call findByteAtHl
	ret nc

	ld e,SpecialObject.xh
	ld a,(de)
	add $08
	ld (de),a
	ld hl,wEnteredWarpPosition
	inc (hl)
	ret

; List of tile indices that are "door tiles" which initiate warps.
@doorTiles:
	.db $dc $dd $de $df $ed $ee $ef
	.db $00


; Initialization
@substate0:
	call itemIncSubstate

	ld l,SpecialObject.counter1
	ld (hl),$1e
	ld l,SpecialObject.direction
	ld (hl),DIR_DOWN

	ld a,d
	ld (wLinkCanPassNpcs),a
	ld (wMenuDisabled),a

	call @centerLinkOnDoorway
	jp objectSetInvisible


; Waiting for palette to fade in and counter1 to reach 0
@substate1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call itemDecCounter1
	ret nz

; Create the timewarp animation, and go to substate 4 if Link is obstructed from warping
; in, otherwise go to substate 2.

	ld (hl),$10
	call @createDestinationTimewarpAnimation

	ld a,(wSentBackByStrangeForce)
	dec a
	jr z,@warpFailed

	callab bank1.checkLinkCanStandOnTile
	srl c
	jr c,@warpFailed

	callab bank1.checkSolidObjectAtWarpDestPos
	srl c
	jr c,@warpFailed

	jp itemIncSubstate

	; Link will be returned to the time he came from.
@warpFailed:
	ld e,SpecialObject.substate
	ld a,$04
	ld (de),a
	ret


; Waiting several frames before making Link visible and playing the sound effect
@substate2:
	call itemDecCounter1
	ret nz

	ld (hl),$1e

@makeLinkVisibleAndPlaySound:
	ld a,SND_TIMEWARP_COMPLETED
	call playSound
	call objectSetVisiblec0
	jp itemIncSubstate


@substate3:
	call @flickerVisibilityAndDecCounter1
	ret nz

; Warp is completed; create a time portal if necessary, restore control to Link

	; Check if a time portal should be created
	ld a,(wLinkTimeWarpTile)
	or a
	jr nz,++

	; Create a time portal
	ld hl,wPortalGroup
	ld a,(wActiveGroup)
	ldi (hl),a
	ld a,(wActiveRoom)
	ldi (hl),a
	ld a,(wWarpDestPos)
	ld (hl),a
	ld c,a
	call getFreeInteractionSlot
	jr nz,++

	ld (hl),INTERACID_TIMEPORTAL
	ld l,Interaction.yh
	call setShortPosition_paramC
++
	; Check whether to show the "Sent back by strange force" text.
	ld a,(wSentBackByStrangeForce)
	or a
	jr z,+
	ld bc,TX_5112
	call showText
+
	; Restore everything to normal, give control back to Link.
	xor a
	ld (wLinkTimeWarpTile),a
	ld (wWarpTransition),a
	ld (wLinkCanPassNpcs),a
	ld (wMenuDisabled),a
	ld (wSentBackByStrangeForce),a
	ld (wcddf),a
	ld (wcde0),a

	ld e,SpecialObject.invincibilityCounter
	ld a,$88
	ld (de),a

	call updateLinkLocalRespawnPosition
	call objectSetVisiblec2
	jp initLinkStateAndAnimateStanding


; Substates 4-7: Warp failed, Link will be sent back to the time he came from

@substate4:
	call itemDecCounter1
	ret nz

	ld (hl),$78
	jr @makeLinkVisibleAndPlaySound

@substate5:
	call @flickerVisibilityAndDecCounter1
	ret nz

	ld (hl),$10
	call @createDestinationTimewarpAnimation
	jp itemIncSubstate

@substate6:
	call @flickerVisibilityAndDecCounter1
	ret nz

	ld (hl),$14
	call objectSetInvisible
	jp itemIncSubstate

@substate7:
	call itemDecCounter1
	ret nz

; Initiate another warp sending Link back to the time he came from

	call objectGetTileAtPosition
	ld c,l

	ld hl,wWarpDestGroup
	ld a,(wActiveGroup)
	xor $01
	or $80
	ldi (hl),a

	; wWarpDestRoom
	ld a,(wActiveRoom)
	ldi (hl),a

	; wWarpTransition
	ld a,TRANSITION_DEST_TIMEWARP
	ldi (hl),a

	; wWarpDestPos
	ld a,c
	ldi (hl),a

	inc a
	ld (wLinkTimeWarpTile),a
	ld (wcddf),a

	; wWarpTransition2
	ld a,$03
	ld (hl),a

	xor a
	ld (wScrollMode),a

	ld hl,wSentBackByStrangeForce
	ld a,(hl)
	or a
	jr z,+
	inc (hl)
+
	ld a,(wLinkStateParameter)
	bit 4,a
	jr nz,+
	call getThisRoomFlags
	res 4,(hl)
+
	ld a,SND_TIMEWARP_COMPLETED
	call playSound

	ld de,w1Link
	jp objectDelete_de
.endif

;;
; LINK_STATE_08
linkState08:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	; Go to substate 1
	ld a,$01
	ld (de),a

	ld hl,wcc50
	ld a,(hl)
	ld (hl),$00
	or a
	ret nz

	call linkCancelAllItemUsageAndClearAdjacentWallsBitset
	ld a,LINK_ANIM_MODE_WALK
	jp specialObjectSetAnimation

@substate1:
	call checkLinkForceState

	ld hl,wcc50
	ld a,(hl)
	or a
	jr z,+
	ld (hl),$00
	call specialObjectSetAnimation
+
	ld a,(wcc63)
	or a
	call nz,checkUseItems

	ld a,(wDisabledObjects)
	or a
	ret nz

	jp initLinkStateAndAnimateStanding

;;
linkCancelAllItemUsageAndClearAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset
	xor a
	ld (de),a
;;
; Drop any held items, cancels usage of sword, etc?
linkCancelAllItemUsage:
	call dropLinkHeldItem
	jp clearAllParentItems

;;
; LINK_STATE_0e
linkState0e:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemIncSubstate
	ld e,SpecialObject.var37
	ld a,(wActiveRoom)
	ld (de),a

@substate1:
	call objectCheckWithinScreenBoundary
	ret c
	call itemIncSubstate
	call objectSetInvisible

@substate2:
	ld h,d
	ld l,SpecialObject.var37
	ld a,(wActiveRoom)
	cp (hl)
	ret nz

	call objectCheckWithinScreenBoundary
	ret nc

	ld e,SpecialObject.substate
	ld a,$01
	ld (de),a
	jp objectSetVisiblec2

.ifdef ROM_AGES
;;
; LINK_STATE_TOSSED_BY_GUARDS
linkState0f:
	ld a,(wTextIsActive)
	or a
	ret nz

	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemIncSubstate

	; [SpecialObject.counter1] = $14
	inc l
	ld (hl),$14

	ld l,SpecialObject.angle
	ld (hl),$10
	ld l,SpecialObject.yh
	ld (hl),$38
	ld l,SpecialObject.xh
	ld (hl),$50
	ld l,SpecialObject.speed
	ld (hl),SPEED_100

	ld l,SpecialObject.speedZ
	ld a,$80
	ldi (hl),a
	ld (hl),$fe

	ld a,LINK_ANIM_MODE_COLLAPSED
	call specialObjectSetAnimation

	jp objectSetVisiblec2

@substate1:
	call objectApplySpeed

	ld c,$20
	call objectUpdateSpeedZAndBounce
	ret nc ; Return if Link can still bounce

	jp itemIncSubstate

@substate2:
	call itemDecCounter1
	ret nz
	jp initLinkStateAndAnimateStanding
.endif

;;
; LINK_STATE_FORCE_MOVEMENT
linkState0b:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,$01
	ld (de),a

	ld e,SpecialObject.counter1
	ld a,(wLinkStateParameter)
	ld (de),a

	call clearPegasusSeedCounter
	call linkCancelAllItemUsageAndClearAdjacentWallsBitset
	call updateLinkSpeed_standard

	ld a,LINK_ANIM_MODE_WALK
	call specialObjectSetAnimation

@substate1:
	call specialObjectAnimate
	call itemDecCounter1
	ld l,SpecialObject.adjacentWallsBitset
	ld (hl),$00
	jp nz,specialObjectUpdatePosition

	; When counter1 reaches 0, go back to LINK_STATE_NORMAL.
	jp initLinkStateAndAnimateStanding


;;
; LINK_STATE_04
linkState04:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	; Go to substate 1
	ld a,$01
	ld (de),a

	call linkCancelAllItemUsage

	ld e,SpecialObject.animMode
	ld a,(de)
	ld (wcc52),a

	ld a,(wcc50)
	and $0f
	add $0e
	jp specialObjectSetAnimation

@substate1:
	call retIfTextIsActive
	ld a,(wcc50)
	rlca
	jr c,+

	ld a,(wDisabledObjects)
	and $81
	ret nz
+
	ld e,SpecialObject.state
	ld a,LINK_STATE_NORMAL
	ld (de),a
	ld a,(wcc52)
	jp specialObjectSetAnimation

;;
setLinkStateToDead:
	ld a,LINK_STATE_DYING
	call linkSetState
;;
; LINK_STATE_DYING
linkState03:
	xor a
	ld (wLinkHealth),a
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

; Link just started dying (initialization)
@substate0:
	call specialObjectUpdateAdjacentWallsBitset

	ld e,SpecialObject.knockbackCounter
	ld a,(de)
	or a
	jp nz,linkUpdateKnockback

	ld h,d
	ld l,SpecialObject.substate
	inc (hl)

	ld l,SpecialObject.counter1
	ld (hl),$04

	call linkCancelAllItemUsage

	ld a,LINK_ANIM_MODE_SPIN
	call specialObjectSetAnimation
	ld a,SND_LINK_DEAD
	jp playSound

; Link is in the process of dying (spinning around)
@substate1:
	call resetLinkInvincibility
	call specialObjectAnimate

	ld h,d
	ld l,SpecialObject.animParameter
	ld a,(hl)
	add a
	jr nz,@triggerGameOver
	ret nc

; When animParameter is $80 or above, change link's animation to "unconscious"
	ld l,SpecialObject.counter1
	dec (hl)
	ret nz
	ld a,LINK_ANIM_MODE_COLLAPSED
	jp specialObjectSetAnimation

@triggerGameOver:
	ld a,$ff
	ld (wGameOverScreenTrigger),a
	ret

;;
; LINK_STATE_RESPAWNING
;
; This state behaves differently depending on wLinkStateParameter:
;  0: Fall down a hole
;  1: Fall down a hole without centering Link on the tile
;  2: Respawn instantly
;  3: Fall down a hole, different behaviour?
;  4: Drown
linkState02:
	ld a,$ff
	ld (wGameKeysPressed),a

	; Disable the push animation
	ld a,$80
	ld (wForceLinkPushAnimation),a

	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

; Initialization
@substate0:
	call linkCancelAllItemUsage

	ld a,(wLinkStateParameter)
	rst_jumpTable
	.dw @parameter_fallDownHole
	.dw @parameter_fallDownHoleWithoutCentering
	.dw @respawn
	.dw @parameter_3
	.dw @parameter_drown

@parameter_drown:
	ld e,SpecialObject.substate
	ld a,$05
	ld (de),a
	ld a,LINK_ANIM_MODE_DROWN
	jp specialObjectSetAnimation

@parameter_fallDownHole:
	call objectCenterOnTile

@parameter_fallDownHoleWithoutCentering:
	call itemIncSubstate
	jr ++

@parameter_3:
	ld e,SpecialObject.substate
	ld a,$04
	ld (de),a
++
	; Disable collisions
	ld h,d
	ld l,SpecialObject.collisionType
	res 7,(hl)

	; Do the "fall in hole" animation
	ld a,LINK_ANIM_MODE_FALLINHOLE
	call specialObjectSetAnimation
	ld a,SND_LINK_FALL
	jp playSound


; Doing a "falling down hole" animation, waiting for it to finish
@substate1:
	; Wait for the animation to finish
	ld h,d
	ld l,SpecialObject.animParameter
	bit 7,(hl)
	jp z,specialObjectAnimate

	ld a,(wActiveTileType)
	cp TILETYPE_WARPHOLE
	jr nz,@respawn

.ifdef ROM_AGES
	; Check if the current room is the moblin keep with the crumbling floors
	ld a,(wActiveGroup)
	cp $02
	jr nz,+
	ld a,(wActiveRoom)
	cp $9f
	jr nz,+

	jpab bank1.warpToMoblinKeepUnderground
+
.else
	; start CUTSCENE_S_ONOX_FINAL_FORM
	ld a,(wDungeonIndex)
	cp $09
	jr nz,+
	ld a,CUTSCENE_S_ONOX_FINAL_FORM
	ld (wCutsceneTrigger),a
	ret
+
.endif
	; This function call will only work in dungeons.
	jpab bank1.initiateFallDownHoleWarp

@respawn:
	call specialObjectSetCoordinatesToRespawnYX
	ld l,SpecialObject.substate
	ld a,$02
	ldi (hl),a

	; [SpecialObject.counter1] = $02
	ld (hl),a

	call specialObjectTryToBreakTile_source05

	; Set wEnteredWarpPosition, which prevents Link from instantly activating a warp
	; tile if he respawns on one.
	call objectGetTileAtPosition
	ld a,l
	ld (wEnteredWarpPosition),a

	jp objectSetInvisible


; Waiting for counter1 to reach 0 before having Link reappear.
@substate2:
	ld h,d
	ld l,SpecialObject.counter1

	; Check if the screen is scrolling?
	ld a,(wScrollMode)
	and $80
	jr z,+
	ld (hl),$04
	ret
+
	dec (hl)
	ret nz

	; Counter has reached 0; make Link reappear, apply damage

	xor a
	ld (wLinkInAir),a
	ld (wLinkSwimmingState),a

	ld a,GOLD_LUCK_RING
	call cpActiveRing
	ld a,$fc
	jr nz,+
	sra a
+
	call itemIncSubstate

	ld l,SpecialObject.damageToApply
	ld (hl),a
	ld l,SpecialObject.invincibilityCounter
	ld (hl),$3c

	ld l,SpecialObject.counter1
	ld (hl),$10

	call linkApplyDamage
	call objectSetVisiblec1
	call specialObjectUpdateAdjacentWallsBitset
	jp animateLinkStanding


; Waiting for counter1 to reach 0 before switching back to LINK_STATE_NORMAL.
@substate3:
	call itemDecCounter1
	ret nz

	; Enable collisions
	ld l,SpecialObject.collisionType
	set 7,(hl)

	jp initLinkStateAndAnimateStanding


@substate4:
	ld h,d
	ld l,SpecialObject.animParameter
	bit 7,(hl)
	jp z,specialObjectAnimate
	call objectSetInvisible
	jp checkLinkForceState


; Drowning instead of falling into a hole
@substate5:
	ld e,SpecialObject.animParameter
	ld a,(de)
	rlca
	jp nc,specialObjectAnimate
	jr @respawn

.ifdef ROM_AGES
;;
; Makes Link surface from an underwater area if he's pressed B.
checkForUnderwaterTransition:
	ld a,(wDisableScreenTransitions)
	or a
	ret nz
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	ret z
	ld a,(wGameKeysJustPressed)
	and BTN_B
	ret z

	ld a,(wActiveTilePos)
	ld l,a
	ld h,>wRoomLayout
	ld a,(hl)
	ld hl,tileTypesTable
	call lookupCollisionTable

	; Don't allow surfacing on whirlpools
	cp TILETYPE_WHIRLPOOL
	ret z

	; Move down instead of up when over a "warp hole" (only used in jabu-jabu?)
	cp TILETYPE_WARPHOLE
	jr z,@levelDown

	; Return if Link can't surface here
	call checkLinkCanSurface
	ret nc

	; Return from the caller (linkState01)
	pop af

	ld a,(wTilesetFlags)
	and TILESETFLAG_DUNGEON
	jr nz,@dungeon

	; Not in a dungeon

	; Set 'c' to the value to add to wActiveGroup.
	; Set 'a' to the room index to end up in.
	ld c,$fe
	ld a,(wActiveRoom)
	jr @initializeWarp

@dungeon:
	; Increment the floor you're on, get the new room index
	ld a,(wDungeonFloor)
	inc a
	ld (wDungeonFloor),a
	call getActiveRoomFromDungeonMapPosition
	ld c,$00
	jr @initializeWarp

	; Go down a level instead of up one
@levelDown:
	; Return from caller
	pop af

	ld a,(wTilesetFlags)
	and TILESETFLAG_DUNGEON
	jr nz,+

	; Not in a dungeon: add 2 to wActiveGroup.
	ld c,$02
	ld a,(wActiveRoom)
	jr @initializeWarp
+
	; In a dungeon: decrement the floor you're on, get the new room index
	ld a,(wDungeonFloor)
	dec a
	ld (wDungeonFloor),a
	call getActiveRoomFromDungeonMapPosition
	ld c,$00
	jr @initializeWarp

@initializeWarp:
	ld (wWarpDestRoom),a

	ld a,(wActiveGroup)
	add c
	or $80
	ld (wWarpDestGroup),a

	ld a,(wActiveTilePos)
	ld (wWarpDestPos),a

	ld a,$00
	ld (wWarpTransition),a

	ld a,$03
	ld (wWarpTransition2),a
	ret
.endif

.ifdef ROM_SEASONS
; Bouncing from trampoline, hitting the ceiling,
; or setting warp to floor above
linkState09:
	call retIfTextIsActive
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	call clearAllParentItems
	xor a
	ld (wScrollMode),a
	ld (wUsingShield),a
	ld bc,-$400
	call objectSetSpeedZ
	ld l,SpecialObject.counter1
	ld (hl),$0a
	ld a,(wcc50)
	rrca
	ld a,$01
	jr nc,+
	inc a
+
	ld l,SpecialObject.substate
	ld (hl),a
	ld a,$81
	ld (wLinkInAir),a
	ret

@substate1:
	call @seasonsFunc_05_5043
	ret c
	ld a,(wDungeonFloor)
	inc a
	ld (wDungeonFloor),a
	call getActiveRoomFromDungeonMapPosition
	ld (wWarpDestRoom),a
	call objectGetShortPosition
	ld (wWarpDestPos),a
	ld a,(wActiveGroup)
	or $80
	ld (wWarpDestGroup),a
	ld a,$06
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
	ret
@substate2:
	call @seasonsFunc_05_5043
	ret c
	ld a,$01
	ld (wScrollMode),a
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$1e
	ld a,$08
	call setScreenShakeCounter
	ld a,LINK_ANIM_MODE_COLLAPSED
	jp specialObjectSetAnimation

@seasonsFunc_05_5043:
	ld c,$0c
	call objectUpdateSpeedZ_paramC
	call specialObjectAnimate
	ld h,d
	ld l,SpecialObject.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	jr nz,+
	ld a,LINK_ANIM_MODE_FALL
	call specialObjectSetAnimation
+
	call objectGetZAboveScreen
	ld h,d
	ld l,SpecialObject.zh
	cp (hl)
	ret

@substate3:
	call itemDecCounter1
	ret nz
	dec l
	inc (hl)
	ld bc,-$100
	jp objectSetSpeedZ

@substate4:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call objectGetTileAtPosition
	cp $07
	jr z,bounceLinkOffTrampolineAfterFalling
	ld h,d
	ld l,SpecialObject.substate
	inc (hl)
	; SpecialObject.counter1
	inc l
	ld (hl),$1e
	ld a,LINK_ANIM_MODE_COLLAPSED
	call specialObjectSetAnimation

@substate5:
	call itemDecCounter1
	ret nz
-
	xor a
	ld (wLinkInAir),a
	jp initLinkStateAndAnimateStanding

@substate6:
	call specialObjectAnimate
	call specialObjectUpdateAdjacentWallsBitset
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,specialObjectUpdatePosition
	call updateLinkLocalRespawnPosition
	jr -

bounceLinkOffTrampolineAfterFalling:
	call objectGetShortPosition
	ld c,a
	ld b,$02
-
	ld a,b
	ld hl,@offsets
	rst_addAToHl
	ld a,c
	add (hl)
	ld h,>wRoomCollisions
	ld l,a
	ld a,(hl)
	or a
	jr z,+
	ld a,b
	inc a
	and $03
	ld b,a
	jr -
+
	ld h,d
	ld l,SpecialObject.direction
	ld (hl),b
	ld a,b
	swap a
	rrca
	inc l
	ld (hl),a
	ld l,SpecialObject.zh
	ld (hl),$ff
	ld bc,-$300
	call objectSetSpeedZ
	ld l,SpecialObject.speed
	ld (hl),$14
	ld l,SpecialObject.state
	ld (hl),$09
	inc l
	ld (hl),$06
	ld a,LINK_ANIM_MODE_FALL
	jp specialObjectSetAnimation

@offsets:
	.db $f0 $01 $10 $ff
.endif

;;
; LINK_STATE_GRABBED_BY_WALLMASTER
linkState0c:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	; Go to substate 1
	ld a,$01
	ld (de),a

	ld (wWarpsDisabled),a

	xor a
	ld e,SpecialObject.collisionType
	ld (de),a

	ld a,$00
	ld (wScrollMode),a

	call linkCancelAllItemUsage

	ld a,SND_BOSS_DEAD
	jp playSound


; The wallmaster writes [w1Link.substate] = 2 when Link is fully dragged off-screen.
@substate2:
	xor a
	ld (wWarpsDisabled),a

	ld hl,wWarpDestGroup
	ld a,(wActiveGroup)
	or $80
	ldi (hl),a

	; wWarpDestRoom
	ld a,(wDungeonWallmasterDestRoom)
	ldi (hl),a

	; wWarpDestTransition
	ld a,TRANSITION_DEST_FALL
	ldi (hl),a

	; wWarpDestPos
	ld a,$87
	ldi (hl),a

	; wWarpDestTransition2
	ld (hl),$03

; Substate 1: waiting for the wallmaster to increment w1Link.substate.
@substate1:
	ret

;;
; LINK_STATE_STONE
; Only used in Seasons for the Medusa boss
linkState13:
	ld a,$80
	ld (wForceLinkPushAnimation),a

	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call itemIncSubstate

	; [SpecialObject.counter1] = $b4
	inc l
	ld (hl),$b4

	ld l,SpecialObject.oamFlagsBackup
	ld a,$0f
	ldi (hl),a
	ld (hl),a

.ifdef ROM_AGES
	ld a,PALH_7f
.else
	ld a,SEASONS_PALH_7f
.endif
	call loadPaletteHeader

	xor a
	ld (wcc50),a
	ret


; This is used by both linkState13 and linkState14.
; Waits for counter1 to reach 0, then restores Link to normal.
@substate1:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ld a,(wcc50)
	or a
	jr z,+

	call updateLinkDirectionFromAngle

	ld l,SpecialObject.var2a
	ld a,(hl)
	or a
	jr nz,@restoreToNormal
+
	; Restore Link to normal more quickly when pressing any button.
	ld c,$01
	ld a,(wGameKeysJustPressed)
	or a
	jr z,+
	ld c,$04
+
	ld l,SpecialObject.counter1
	ld a,(hl)
	sub c
	ld (hl),a
	ret nc

@restoreToNormal:
	ld l,SpecialObject.oamFlagsBackup
	ld a,$08
	ldi (hl),a
	ld (hl),a

	ld l,SpecialObject.knockbackCounter
	ld (hl),$00

	xor a
	ld (wLinkForceState),a
	jp initLinkStateAndAnimateStanding

;;
; LINK_STATE_COLLAPSED
linkState14:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw linkState13@substate1

@substate0:
	call itemIncSubstate

	ld l,SpecialObject.counter1
	ld (hl),$f0
	call linkCancelAllItemUsage

	ld a,(wcc50)
	or a
	ld a,LINK_ANIM_MODE_COLLAPSED
	jr z,+
	ld a,LINK_ANIM_MODE_WALK
+
	jp specialObjectSetAnimation

;;
; LINK_STATE_GRABBED
; Grabbed by Like-like, Gohma, Veran spider form?
linkState0d:
	ld a,$80
	ld (wcc92),a
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw updateLinkDamageTaken
	.dw @substate2
	.dw @substate3
	.dw @substate4

; Initialization
@substate0:
	ld a,$01
	ld (de),a
	ld (wWarpsDisabled),a

	ld e,SpecialObject.animMode
	xor a
	ld (de),a

	jp linkCancelAllItemUsage

; Link has been released, now he's about to fly downwards
@substate2:
	ld a,$03
	ld (de),a

	ld h,d
	ld l,SpecialObject.counter1
	ld (hl),$1e

.ifdef ROM_AGES
	ld l,SpecialObject.speedZ
	ld a,$20
	ldi (hl),a
	ld (hl),$fe

	; Face up
	ld l,SpecialObject.direction
	xor a
	ldi (hl),a

	; [SpecialObject.angle] = $10 (move down)
	ld (hl),$10
.else
	ld a,$e8
	ld l,SpecialObject.zh
	ld (hl),a
	ld l,SpecialObject.yh
	cpl
	inc a
	add (hl)
	ld (hl),a
	xor a
	ld l,SpecialObject.speedZ
	ldi (hl),a
	ldi (hl),a
	ld l,SpecialObject.direction
	ldi (hl),a
	; angle
	ld (hl),$0c
.endif

	ld l,SpecialObject.speed
	ld (hl),SPEED_180
	ld a,LINK_ANIM_MODE_GALE
	jp specialObjectSetAnimation

; Continue moving downwards until counter1 reaches 0
@substate3:
	call itemDecCounter1
	jr z,++

	ld c,$20
	call objectUpdateSpeedZ_paramC
	call specialObjectUpdateAdjacentWallsBitset
	call specialObjectUpdatePosition
	jp specialObjectAnimate


; Link is released without anything special.
; ENEMYID_LIKE_LIKE sends Link to this state directly upon release.
@substate4:
	ld h,d
	ld l,SpecialObject.invincibilityCounter
	ld (hl),$94
++
	xor a
	ld (wWarpsDisabled),a
	jp initLinkStateAndAnimateStanding

;;
; LINK_STATE_SLEEPING
linkState05:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Just touched the bed
@substate0:
	call itemIncSubstate

	ld l,SpecialObject.speed
	ld (hl),SPEED_80

	; Set destination position (var37 / var38)
.ifdef ROM_AGES
	ld l,$18
.else
	ld l,$13
.endif
	ld a,$02
	call specialObjectSetVar37AndVar38

	ld bc,-$180
	call objectSetSpeedZ

	ld a,$81
	ld (wLinkInAir),a

	ld a,LINK_ANIM_MODE_SLEEPING
	jp specialObjectSetAnimation

; Jumping into the bed
@substate1:
	call specialObjectAnimate
	call specialObjectSetAngleRelativeToVar38
	call objectApplySpeed

	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call itemIncSubstate
	jp specialObjectSetPositionToVar38IfSet

; Sleeping; do various things depending on "animParameter".
@substate2:
	call specialObjectAnimate
	ld h,d
	ld l,SpecialObject.animParameter
	ld a,(hl)
	ld (hl),$00
	rst_jumpTable
	.dw @animParameter0
	.dw @animParameter1
	.dw @animParameter2
	.dw @animParameter3
	.dw @animParameter4

@animParameter1:
	call darkenRoomLightly
	ld a,$06
	ld (wPaletteThread_updateRate),a
	ret

@animParameter2:
	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ld (hl),a

@animParameter0:
	ret

@animParameter3:
	jp brightenRoom

@animParameter4:
	ld bc,-$180
	call objectSetSpeedZ

	ld l,SpecialObject.direction
.ifdef ROM_AGES
	ld (hl),DIR_LEFT
.else
	ld (hl),DIR_RIGHT
.endif

	; [SpecialObject.angle] = $18
	inc l
.ifdef ROM_AGES
	ld (hl),$18
.else
	ld (hl),$08
.endif

	ld l,SpecialObject.speed
	ld (hl),SPEED_80

	ld a,$81
	ld (wLinkInAir),a
	jp initLinkStateAndAnimateStanding

;;
; LINK_STATE_06
; Moves Link up until he's no longer in a solid wall?
linkState06:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Go to substate 1
	ld a,$01
	ld (de),a

	ld h,d
	ld l,SpecialObject.counter1
	ld (hl),$08
	ld l,SpecialObject.speed
	ld (hl),SPEED_200

	; Set angle to "up"
	ld l,SpecialObject.angle
	ld (hl),$00

	ld a,$81
	ld (wLinkInAir),a
	ld a,SND_JUMP
	call playSound

@substate1:
	call specialObjectUpdatePositionWithoutTileEdgeAdjust
	call itemDecCounter1
	ret nz

	; Go to substate 2
	ld l,SpecialObject.substate
	inc (hl)

	ld l,SpecialObject.direction
	ld (hl),$00
	ld a,LINK_ANIM_MODE_FALL
	call specialObjectSetAnimation

@substate2:
	call specialObjectAnimate
	ld a,(wScrollMode)
	and $01
	ret z

	call objectCheckTileCollision_allowHoles
	jp c,specialObjectUpdatePositionWithoutTileEdgeAdjust

	ld bc,-$200
	call objectSetSpeedZ

	; Go to substate 3
	ld l,SpecialObject.substate
	inc (hl)

	ld l,SpecialObject.speed
	ld (hl),SPEED_40
	ld a,LINK_ANIM_MODE_JUMP
	call specialObjectSetAnimation

@substate3:
	call specialObjectAnimate
	call specialObjectUpdateAdjacentWallsBitset
	call specialObjectUpdatePosition
	ld c,$18
	call objectUpdateSpeedZ_paramC
	ret nz

	xor a
	ld (wLinkInAir),a
	ld (wWarpsDisabled),a
	jp initLinkStateAndAnimateStanding

.ifdef ROM_AGES
;;
; LINK_STATE_AMBI_POSSESSED_CUTSCENE
; This state is used during the cutscene in the black tower where Ambi gets un-possessed.
linkState09:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5


; Initialization
@substate0:
	call itemIncSubstate

; Backing up to the right

	ld l,SpecialObject.speed
	ld (hl),SPEED_100
	ld l,SpecialObject.direction
	ld (hl),DIR_LEFT

	; [SpecialObject.angle] = $08
	inc l
	ld (hl),$08

	ld l,SpecialObject.counter1
	ld (hl),$0c

@substate1:
	call itemDecCounter1
	jr nz,@animate

; Moving back left

	ld (hl),$0c

	; Go to substate 2
	ld l,e
	inc (hl)

	ld l,SpecialObject.angle
	ld (hl),$18

@substate2:
	call itemDecCounter1
	jr nz,@animate

; Looking down

	ld (hl),$32

	; Go to substate 3
	ld l,e
	inc (hl)

	ld l,SpecialObject.direction
	ld (hl),DIR_DOWN

@substate3:
	call itemDecCounter1
	ret nz

; Looking up with an exclamation mark

	; Go to substate 4
	ld l,e
	inc (hl)

	ld l,SpecialObject.direction
	ld (hl),DIR_UP

	; [SpecialObject.angle] = $10
	inc l
	ld (hl),$10

	ld l,SpecialObject.counter1
	ld a,$1e
	ld (hl),a

	ld bc,$f4f8
	jp objectCreateExclamationMark

@substate4:
	call itemDecCounter1
	ret nz

; Jumping away

	; Go to substate 5
	ld l,e
	inc (hl)

	ld bc,-$180
	call objectSetSpeedZ

	ld a,LINK_ANIM_MODE_JUMP
	call specialObjectSetAnimation
	ld a,SND_JUMP
	jp playSound

@substate5:
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jr nz,@animate

	; a is 0 at this point
	ld l,SpecialObject.substate
	ldd (hl),a
	ld (hl),SpecialObject.direction
	ret

@animate:
	call specialObjectAnimate
	jp specialObjectUpdatePositionWithoutTileEdgeAdjust

.else

linkState0f:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$10
	xor a
	ld l,SpecialObject.direction
	ldi (hl),a
	; SpecialObject.angle
	ld (hl),a
	call linkCancelAllItemUsageAndClearAdjacentWallsBitset
	ld a,$01
	ld (wDisableLinkCollisionsAndMenu),a
	ld a,LINK_ANIM_MODE_WALK
	call specialObjectSetAnimation

@substate1:
	call itemDecCounter1
	jr nz,@updateObject
	ld (hl),$5a
	; SpecialObject.substate
	dec l
	inc (hl)
	ld l,SpecialObject.speed
	ld (hl),$14
@updateObject:
	call specialObjectAnimate
	jp specialObjectUpdatePositionWithoutTileEdgeAdjust

@substate2:
	ld h,d
	ld l,SpecialObject.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld h,d
	ld l,SpecialObject.yh
	ld a,(hl)
	cp $74
	jr nc,@updateObject
	ld l,SpecialObject.substate
	inc (hl)
	inc l
	; SpecialObject.direction
	ld (hl),$60
	ld l,SpecialObject.speed
	ld (hl),$28

@substate3:
	call itemDecCounter1
	jr z,++
	ld a,(hl)
	sub $19
	jr c,+
	cp $32
	ret nc
	and $0f
	ret nz
	ld a,(hl)
	swap a
	and $01
	add a
	inc a
	ld l,SpecialObject.direction
	ld (hl),a
	ret
+
	inc a
	ret nz
	ld l,SpecialObject.direction
	ld (hl),$00
	; SpecialObject.angle
	inc l
	ld (hl),$10
	ld a,$18
	ld bc,$f4f8
	call objectCreateExclamationMark
	ld a,SND_CLINK
	jp playSound
++
	ld l,e
	inc (hl)
	ld bc,-$180
	call objectSetSpeedZ
	ld a,LINK_ANIM_MODE_JUMP
	call specialObjectSetAnimation
	ld a,SND_JUMP
	call playSound
@substate4:
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jr nz,@updateObject
	ld l,SpecialObject.substate
	inc (hl)
	; SpecialObject.counter1
	inc l
	ld (hl),$f0
	ld a,LINK_ANIM_MODE_WALK
	call specialObjectSetAnimation
@substate5:
	ld a,(wFrameCounter)
	rrca
	ret nc
	call itemDecCounter1
	ret nz
	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	jp initLinkStateAndAnimateStanding

linkState10:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01
	ld (de),a
	call linkCancelAllItemUsage
	call resetLinkInvincibility
	ld l,SpecialObject.speed
	ld (hl),$14
	ld l,SpecialObject.direction
	ld (hl),$00
	; SpecialObject.angle
	inc l
	ld (hl),DIR_UP
	jp animateLinkStanding

@substate1:
	call specialObjectAnimate
	ld h,d
	ld a,(wFrameCounter)
	and $07
	jr nz,+
	ld l,SpecialObject.speed
	ld a,(hl)
	sub $05
	jr z,+
	ld (hl),a
+
	ld a,($cbb3)
	cp $02
	jp nz,specialObjectUpdatePosition
	ld a,(wCutsceneState)
	dec a
	jp nz,initLinkStateAndAnimateStanding
	ld l,SpecialObject.substate
	inc (hl)
	; SpecialObject.counter1
	inc l
	ld (hl),$20
	ld l,SpecialObject.angle
	ld (hl),$10
	ld l,SpecialObject.speed
	ld (hl),$50

@substate2:
	call specialObjectAnimate
	call itemDecCounter1
	jp nz,specialObjectUpdatePosition
	ld hl,$cbb3
	inc (hl)
	ld a,$02
	call fadeoutToWhiteWithDelay
	jp initLinkStateAndAnimateStanding
.endif

;;
; LINK_STATE_SQUISHED
linkState11:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01
	ld (de),a

	call linkCancelAllItemUsage

	xor a
	ld e,SpecialObject.collisionType
	ld (de),a

	ld a,SND_DAMAGE_ENEMY
	call playSound

	; Check whether to do the horizontal or vertical squish animation
	ld a,(wcc50)
	and $7f
	ld a,LINK_ANIM_MODE_SQUISHX
	jr z,+
	inc a
+
	call specialObjectSetAnimation

@substate1:
	call specialObjectAnimate

	; Wait for the animation to finish
	ld e,SpecialObject.animParameter
	ld a,(de)
	inc a
	ret nz

	call itemIncSubstate
	ld l,SpecialObject.counter1
	ld (hl),$14

@substate2:
	call specialObjectAnimate

	; Invisible every other frame
	ld a,(wFrameCounter)
	rrca
	jp c,objectSetInvisible

	call objectSetVisible
	call itemDecCounter1
	ret nz

	ld a,(wcc50)
	bit 7,a
	jr nz,+

	call respawnLink
	jr checkLinkForceState
+
	ld a,LINK_STATE_DYING
	ld (wLinkForceState),a
	jr checkLinkForceState

;;
; Checks wLinkForceState, and sets Link's state to that value if it's nonzero.
; This also returns from the function that called it if his state changed.
checkLinkForceState:
	ld hl,wLinkForceState
	ld a,(hl)
	or a
	ret z

	ld (hl),$00
	pop hl

;;
; Sets w1Link.state to the given value, and w1Link.substate to $00.
; For some reason, this also runs the code for the state immediately if it's
; LINK_STATE_WARPING, LINK_STATE_GRABBED_BY_WALLMASTER, or LINK_STATE_GRABBED.
;
; @param	a	New value for w1Link.state
; @param	d	Link object
linkSetState:
	ld h,d
	ld l,SpecialObject.state
	ldi (hl),a
	ld (hl),$00
	cp LINK_STATE_WARPING
	jr z,+

	cp LINK_STATE_GRABBED_BY_WALLMASTER
	jr z,+

	cp LINK_STATE_GRABBED
	ret nz
+
	jp specialObjectCode_link

;;
; LINK_STATE_NORMAL
; LINK_STATE_10
linkState01:
.ifdef ROM_AGES
linkState10:
.endif
	; This should prevent Link from ever doing his pushing animation.
	; Under normal circumstances, this should be overwritten with $00 later, allowing
	; him to do his pushing animation when necessary.
	ld a,$80
	ld (wForceLinkPushAnimation),a

	; For some reason, Link can't do anything while the palette is changing
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wScrollMode)
	and $0e
	ret nz

	call updateLinkDamageTaken
	ld a,(wLinkDeathTrigger)
	or a
	jp nz,setLinkStateToDead

	; This will return if [wLinkForceState] != 0
	call checkLinkForceState

	call retIfTextIsActive

	ld a,(wDisabledObjects)
	and $81
	ret nz

	call decPegasusSeedCounter

	ld a,(w1Companion.id)
	cp SPECIALOBJECTID_MINECART
	jr z,++
.ifdef ROM_AGES
	cp SPECIALOBJECTID_RAFT
	jr z,++
.endif

	; Return if Link is riding an animal?
	ld a,(wLinkObjectIndex)
	rrca
	ret c

	ld a,(wLinkPlayingInstrument)
	ld b,a
	ld a,(wLinkInAir)
	or b
	jr nz,++

	ld e,SpecialObject.knockbackCounter
	ld a,(de)
	or a
	jr nz,++

	; Return if Link interacts with an object
	call linkInteractWithAButtonSensitiveObjects
	ret c

	; Deal with push blocks, chests, signs, etc. and return if he opened a chest, read
	; a sign, or opened an overworld keyhole?
	call interactWithTileBeforeLink
	ret c
++
	xor a
	ld (wForceLinkPushAnimation),a
	ld (wLinkPlayingInstrument),a

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jp nz,linkState01_sidescroll

	; The rest of this code is only run in non-sidescrolling areas.

	; Apply stuff like breakable floors, holes, conveyors, etc.
	call linkApplyTileTypes

	; Let Link move around if a chest spawned on top of him
	call checkAndUpdateLinkOnChest

	; Check whether Link pressed A or B to use an item
	call checkUseItems

	ld a,(wLinkPlayingInstrument)
	or a
	ret nz

	call specialObjectUpdateAdjacentWallsBitset
	call linkUpdateKnockback

	; Jump if drowning
	ld a,(wLinkSwimmingState)
	and $40
	jr nz,++

	ld a,(wMagnetGloveState)
	bit 6,a
	jr nz,++

	ld a,(wLinkInAir)
	or a
	jr nz,++

	ld a,(wLinkGrabState)
	ld c,a
	ld a,(wLinkImmobilized)
	or c
	jr nz,++

	call checkLinkPushingAgainstBed
.ifdef ROM_SEASONS
	call checkLinkPushingAgainstTreeStump
.endif
	call checkLinkJumpingOffCliff
++
	call linkUpdateInAir
	ld a,(wLinkInAir)
	or a
	jr z,@notInAir

	; Link is in the air, either jumping or going down a ledge.

	bit 7,a
	jr nz,+

	ld e,SpecialObject.speedZ+1
	ld a,(de)
	bit 7,a
	call z,linkUpdateVelocity
+
	ld hl,wcc95
	res 4,(hl)
	call specialObjectSetAngleRelativeToVar38
	call specialObjectUpdatePosition
	jp specialObjectAnimate

@notInAir:
	ld a,(wMagnetGloveState)
	bit 6,a
	jp nz,animateLinkStanding

	ld e,SpecialObject.knockbackCounter
	ld a,(de)
	or a
	jp nz,func_5631

	ld h,d
	ld l,SpecialObject.collisionType
	set 7,(hl)

	ld a,(wLinkSwimmingState)
	or a
	jp nz,linkUpdateSwimming

	call objectSetVisiblec1
	ld a,(wLinkObjectIndex)
	rrca
.ifdef  ROM_AGES
	jr nc,+


	; This is odd. The "jr z" line below will never jump since 'a' will never be 0.
	; A "cp" opcode instead of "or" would make a lot more sense. Is this a typo?
	; The only difference this makes is that, when on a raft, Link can change
	; directions while swinging his sword / using other items.

	ld a,(w1Companion.id)
	or SPECIALOBJECTID_RAFT
	jr z,@updateDirectionIfNotUsingItem
	jr @updateDirection
+
	; This will return if a transition occurs (pressed B in an underwater area).
	call checkForUnderwaterTransition
.else
	jr c,@updateDirection
.endif
	; Check whether Link is wearing a transformation ring or is a baby
	callab bank6.getTransformedLinkID
	ld a,b
	or a
	jp nz,setLinkIDOverride

.ifdef ROM_AGES
	; Handle movement

	; Check if Link is underwater?
	ld h,d
	ld l,SpecialObject.var2f
	bit 7,(hl)
	jr z,+

	; Do mermaid-suit-based movement
	call linkUpdateVelocity@mermaidSuit
	jr ++
+
.endif
	; Check if bits 0-3 of wLinkGrabState == 1 or 2.
	; (Link is grabbing or lifting something. This cancels ice physics.)
	ld a,(wLinkGrabState)
	and $0f
	dec a
	cp $02
	jr c,@normalMovement

	ld hl,wIsTileSlippery
	bit 6,(hl)
	jr z,@normalMovement

	; Slippery tile movement?
	ld c,$88
	call updateLinkSpeed_withParam
	call linkUpdateVelocity
++
	ld a,(wLinkAngle)
	rlca
	ld c,$02
	jr c,@updateMovement
	jr @walking

@normalMovement:
	ld a,(wcc95)
	ld b,a

	ld e,SpecialObject.angle
	ld a,(wLinkAngle)
	ld (de),a

	; Set cflag if in a spinner or wLinkAngle is set. (The latter case just means he
	; isn't moving.)
	or b
	rlca

	ld c,$00
	jr c,@updateMovement

	ld c,$01
	ld a,(wLinkImmobilized)
	or a
	jr nz,@updateMovement

	call updateLinkSpeed_standard

@walking:
	ld c,$07

@updateMovement:
	; The value of 'c' here determines whether Link should move, what his animation
	; should be, and whether the heart ring should apply. See the linkUpdateMovement
	; function for details.
	call linkUpdateMovement

@updateDirectionIfNotUsingItem:
	ld a,(wLinkTurningDisabled)
	or a
	ret nz

@updateDirection:
	jp updateLinkDirectionFromAngle

;;
linkResetSpeed:
	ld e,SpecialObject.speed
	xor a
	ld (de),a
	ret

;;
; Does something with Link's knockback when on a slippery tile?
func_5631:
	ld hl,wIsTileSlippery
	bit 6,(hl)
	ret z
	ld e,SpecialObject.knockbackAngle
	ld a,(de)
	ld e,SpecialObject.angle
	ld (de),a
	ret

;;
; Called once per frame that Link is moving.
;
; @param	a		Bits 0,1 set if Link's y,x offsets should be added to the
;				counter, respectively.
; @param	wTmpcec0	Offsets of Link's movement, to be added to wHeartRingCounter.
updateHeartRingCounter:
	ld e,a
	ld a,(wActiveRing)

	; b = number of steps (divided by $100, in pixels) until you get a heart refill.
	; c = number of quarter hearts to refill (times 4).

	ldbc $02,$08
	cp HEART_RING_L1
	jr z,@heartRingEquipped

	cp HEART_RING_L2
	jr nz,@clearCounter
	ldbc $03,$10

@heartRingEquipped:
	ld a,e
	or c
	ld c,a
	push de

	; Add Link's y position offset
	ld de,wTmpcec0+1
	ld hl,wHeartRingCounter
	srl c
	call c,@addOffsetsToCounter

	; Add Link's x position offset
	ld e,<wTmpcec0+3
	ld l,<wHeartRingCounter
	srl c
	call c,@addOffsetsToCounter

	; Check if the counter is high enough for a refill
	pop de
	ld a,(wHeartRingCounter+2)
	cp b
	ret c

	; Give hearts if health isn't full already
	ld hl,wLinkHealth
	ldi a,(hl)
	cp (hl)
	ld a,TREASURE_HEART_REFILL
	call c,giveTreasure

@clearCounter:
	ld hl,wHeartRingCounter
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ret

;;
; Adds the position offsets at 'de' to the counter at 'hl'.
@addOffsetsToCounter:
	ld a,(de)
	dec e
	rlca
	jr nc,+

	; If moving in a negative direction, negate the offsets so they're positive again
	ld a,(de)
	cpl
	adc (hl)
	ldi (hl),a
	inc e
	ld a,(de)
	cpl
	jr ++
+
	ld a,(de)
	add (hl)
	ldi (hl),a
	inc e
	ld a,(de)
++
	adc (hl)
	ldi (hl),a
	ret nc
	inc (hl)
	ret

;;
; This is called from linkState01 if [wLinkSwimmingState] != 0.
; Only for non-sidescrolling areas. (See also linkUpdateSwimming_sidescroll.)
linkUpdateSwimming:
	ld a,(wLinkSwimmingState)
	and $0f

	ld hl,wcc95
	res 4,(hl)

	rst_jumpTable
	.dw initLinkState
	.dw overworldSwimmingState1
	.dw overworldSwimmingState2
	.dw overworldSwimmingState3
	.dw linkUpdateDrowning

;;
; Just entered the water
overworldSwimmingState1:
	call linkCancelAllItemUsage
	call linkSetSwimmingSpeed

.ifdef ROM_AGES
	; Set counter1 to the number of frames to stay in swimmingState2.
	; This is just a period of time during which Link's speed is locked immediately
	; after entering the water.
	ld l,SpecialObject.var2f
	bit 6,(hl)
.endif

	ld l,SpecialObject.counter1
	ld (hl),$0a

.ifdef ROM_AGES
	jr z,+
	ld (hl),$02
+
.endif

	ld a,(wLinkSwimmingState)
	bit 6,a
	jr nz,@drownWithLessInvincibility

.ifdef ROM_AGES
	call checkSwimmingOverSeawater
	jr z,@drown
.endif

	ld a,TREASURE_FLIPPERS
	call checkTreasureObtained
	ld b,LINK_ANIM_MODE_SWIM
	jr c,@splashAndSetAnimation

@drown:
	ld c,$88
	jr +

@drownWithLessInvincibility:
	ld c,$78
+
	ld a,LINK_STATE_RESPAWNING
	ld (wLinkForceState),a
	ld a,$04
	ld (wLinkStateParameter),a
	ld a,$80
	ld (wcc92),a

	ld h,d
	ld l,SpecialObject.invincibilityCounter
	ld (hl),c
	ld l,SpecialObject.collisionType
	res 7,(hl)

	ld a,SND_DAMAGE_LINK
	call playSound

	ld b,LINK_ANIM_MODE_DROWN

@splashAndSetAnimation:
	ld hl,wLinkSwimmingState
	ld a,(hl)
	and $f0
	or $02
	ld (hl),a
	ld a,b
	call specialObjectSetAnimation
	jp linkCreateSplash

;;
; This is called from linkUpdateSwimming_sidescroll.
forceDrownLink:
	ld hl,wLinkSwimmingState
	set 6,(hl)
	jr overworldSwimmingState1@drownWithLessInvincibility

.ifdef ROM_AGES
;;
; @param[out]	zflag	Set if swimming over seawater (and you have the mermaid suit)
checkSwimmingOverSeawater:
	ld a,(w1Link.var2f)
	bit 6,a
	ret nz
	ld a,(wActiveTileType)
	sub TILETYPE_SEAWATER
	ret
.endif

;;
; State 2: speed is locked for a few frames after entering the water
overworldSwimmingState2:
	call itemDecCounter1
	jp nz,specialObjectUpdatePosition

	ld hl,wLinkSwimmingState
	inc (hl)

;;
; State 3: the normal state when swimming
overworldSwimmingState3:
.ifdef ROM_AGES
	call checkSwimmingOverSeawater
	jr z,overworldSwimmingState1@drown
.endif

	call linkUpdateDiving

	; Set Link's visibility layer to normal
	call objectSetVisiblec1

	; Enable Link's collisions
	ld h,d
	ld l,SpecialObject.collisionType
	set 7,(hl)

	; Check if Link is diving
	ld a,(wLinkSwimmingState)
	rlca
	jr nc,+

	; If he's diving, disable Link's collisions
	res 7,(hl)
	; Draw him behind other sprites
	call objectSetVisiblec3
+
	call updateLinkDirectionFromAngle

.ifdef ROM_AGES
	; Check whether the flippers or the mermaid suit are in use
	ld h,d
	ld l,SpecialObject.var2f
	bit 6,(hl)
	jr z,+

	; Mermaid suit movement
	call linkUpdateVelocity@mermaidSuit
	jp specialObjectUpdatePosition
+
.endif
	; Flippers movement
	call linkUpdateFlippersSpeed
	call func_5933
	jp specialObjectUpdatePosition


;;
; Deals with Link drowning
linkUpdateDrowning:
	ld a,$80
	ld (wcc92),a

	call specialObjectAnimate

	ld h,d
	xor a
	ld l,SpecialObject.collisionType
	ld (hl),a

	ld l,SpecialObject.animParameter
	bit 7,(hl)
	ret z

	ld (wLinkSwimmingState),a

	; Set link's state to LINK_STATE_RESPAWNING; but, set
	; wLinkStateParameter to $02 to trigger only the respawning code, and not
	; anything else.
	ld a,$02
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_RESPAWNING
	jp linkSetState

;;
; Sets Link's speed, speedTmp, var12, and var35 variables.
linkSetSwimmingSpeed:
	ld a,SWIMMERS_RING
	call cpActiveRing
	ld a,SPEED_e0
	jr z,+
	ld a,SPEED_80
+
	; Set speed, speedTmp to specified value
	ld h,d
	ld l,SpecialObject.speed
	ldi (hl),a
	ldi (hl),a

	; [SpecialObject.var12] = $03
	inc l
	ld a,$03
	ld (hl),a

	ld l,SpecialObject.var35
	ld (hl),$00
	ret

;;
; Sets the speedTmp variable in the same way as the above function, but doesn't touch any
; other variables.
linkSetSwimmingSpeedTmp:
	ld a,SWIMMERS_RING
	call cpActiveRing
	ld a,SPEED_e0
	jr z,+
	ld a,SPEED_80
+
	ld e,SpecialObject.speedTmp
	ld (de),a
	ret

;;
; @param[out]	a	The angle Link should move in?
linkUpdateFlippersSpeed:
	ld e,SpecialObject.var35
	ld a,(de)
	rst_jumpTable
	.dw @flippersState0
	.dw @flippersState1
	.dw @flippersState2

; Swimming with flippers; waiting for Link to press A, if he will at all
@flippersState0:
	ld a,(wGameKeysJustPressed)
	and BTN_A
	jr nz,@pressedA

	call linkSetSwimmingSpeedTmp
	ld a,(wLinkAngle)
	ret

@pressedA:
	; Go to next state
	ld a,$01
	ld (de),a

	ld a,$08
--
	push af
	ld e,SpecialObject.direction
	ld a,(de)
	add a
	add a
	add a
	call func_5933
	pop af
	dec a
	jr nz,--

	ld e,SpecialObject.counter1
	ld a,$0d
	ld (de),a
	ld a,SND_LINK_SWIM
	call playSound


; Accerelating
@flippersState1:
	ldbc $01,$05
	jr ++


; Decelerating
@flippersState2:
	; b: Next state to go to (minus 1)
	; c: Value to add to speedTmp
	ldbc $ff,-5
++
	call itemDecCounter1
	jr z,@nextState

	ld a,(hl)
	and $03
	jr z,@accelerate
	jr @returnDirection

@nextState:
	ld l,SpecialObject.var35
	inc b
	ld (hl),b
	jr nz,+

	call linkSetSwimmingSpeed
	jr @returnDirection
+
	ld l,SpecialObject.counter1
	ld a,$0c
	ld (hl),a

	; Accelerate, or decelerate depending on 'c'.
@accelerate:
	ld l,SpecialObject.speedTmp
	ld a,(hl)
	add c
	bit 7,a
	jr z,+
	xor a
+
	ld (hl),a

	; Return an angle value based on Link's direction?
@returnDirection:
	ld a,(wLinkAngle)
	bit 7,a
	ret z

	ld e,SpecialObject.direction
	ld a,(de)
	swap a
	rrca
	ret

;;
linkUpdateDiving:
	call specialObjectAnimate
	ld hl,wLinkSwimmingState
.ifdef ROM_AGES
	bit 7,(hl)
	jr z,@checkInput

	ld a,(wDisableScreenTransitions)
	or a
	jr nz,@checkInput

	ld a,(wActiveTilePos)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	cp TILEINDEX_DEEP_WATER
	jp z,checkForUnderwaterTransition@levelDown
.endif

@checkInput:
	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_B,a
	jr nz,@pressedB

	ld a,ZORA_RING
	call cpActiveRing
	ret z

	ld e,SpecialObject.counter2
	ld a,(de)
	dec a
	ld (de),a
	jr z,@surface
	ret

@pressedB:
	bit 7,(hl)
	jr z,@dive

@surface:
	res 7,(hl)
	ld a,LINK_ANIM_MODE_SWIM
	jp specialObjectSetAnimation

@dive:
	set 7,(hl)

	ld e,SpecialObject.counter2
	ld a,$78
	ld (de),a

	call linkCreateSplash
	ld a,LINK_ANIM_MODE_DIVE
	jp specialObjectSetAnimation

;;
linkUpdateSwimming_sidescroll:
	ld a,(wLinkSwimmingState)
	and $0f
	jr z,@swimmingState0

	ld hl,wcc95
	res 4,(hl)

	rst_jumpTable
	.dw @swimmingState0
	.dw @swimmingState1
	.dw @swimmingState2
	.dw linkUpdateDrowning

; Not swimming
@swimmingState0:
	jp initLinkState


; Just entered the water
@swimmingState1:
	call linkCancelAllItemUsage

	ld hl,wLinkSwimmingState
	inc (hl)

	call linkSetSwimmingSpeed
	call objectSetVisiblec1

	ld a,TREASURE_FLIPPERS
	call checkTreasureObtained
	jr nc,@drown

.ifdef ROM_AGES
	ld hl,w1Link.var2f
	bit 6,(hl)
	ld a,LINK_ANIM_MODE_SWIM_2D
	jr z,++

	set 7,(hl)
	ld a,LINK_ANIM_MODE_MERMAID
	jr ++
.else
	ld a,LINK_ANIM_MODE_SWIM_2D
	jr ++
.endif


@drown:
	ld a,$03
	ld (wLinkSwimmingState),a
	ld a,LINK_ANIM_MODE_DROWN
++
	jp specialObjectSetAnimation


; Link remains in this state until he exits the water
@swimmingState2:
	xor a
	ld (wLinkInAir),a

	ld h,d
	ld l,SpecialObject.collisionType
	set 7,(hl)
	ld a,(wLinkImmobilized)
	or a
	jr nz,+++

	; Jump if Link isn't moving ([w1LinkAngle] == $ff)
	ld l,SpecialObject.direction
	ld a,(wLinkAngle)
	add a
	jr c,+

	; Jump if Link's angle is going directly up or directly down (so, don't modify his
	; current facing direction)
	ld c,a
	and $18
	jr z,+

	; Set Link's facing direction based on his angle
	ld a,c
	swap a
	and $03
	ld (hl),a
+
	; Ensure that he's facing either left or right (not up or down)
	set 0,(hl)

.ifdef ROM_AGES
	; Jump if Link does not have the mermaid suit (only flippers)
	ld l,SpecialObject.var2f
	bit 6,(hl)
	jr z,+

	; Mermaid suit movement
	call linkUpdateVelocity@mermaidSuit
	jr ++
+
.endif
	; Flippers movement
	call linkUpdateFlippersSpeed
	call func_5933
++
	call specialObjectUpdatePosition
+++
	; When counter2 goes below 0, create a bubble
	ld h,d
	ld l,SpecialObject.counter2
	dec (hl)
	bit 7,(hl)
	jr z,+

	; Wait between 50-81 frames before creating the next bubble
	call getRandomNumber
	and $1f
	add 50
	ld (hl),a

	ld b,INTERACID_BUBBLE
	call objectCreateInteractionWithSubid00
+
	jp specialObjectAnimate

;;
; Updates speed and angle for things like ice, jumping, underwater? (Things where he
; accelerates and decelerates)
linkUpdateVelocity:
.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	jr z,@label_05_159

@mermaidSuit:
	ld c,$98
	call updateLinkSpeed_withParam
	ld a,(wActiveRing)
	cp SWIMMERS_RING
	jr nz,+

	ld e,SpecialObject.speedTmp
	ld a,SPEED_160
	ld (de),a
+
	ld h,d
	ld a,(wLinkImmobilized)
	or a
	jr nz,+

	ld a,(wGameKeysJustPressed)
	and (BTN_UP | BTN_RIGHT | BTN_DOWN | BTN_LEFT)
	jr nz,@directionButtonPressed
+
	ld l,SpecialObject.var3e
	dec (hl)
	bit 7,(hl)
	jr z,++

	ld a,$ff
	ld (hl),a
	jr func_5933

@directionButtonPressed:
	ld a,SND_SPLASH
	call playSound
	ld h,d
	ld l,SpecialObject.var3e
	ld (hl),$04
++
	ld l,SpecialObject.var12
	ld (hl),$14
.endif

@label_05_159:
	ld a,(wLinkAngle)

;;
; @param a
func_5933:
	ld e,a
	ld h,d
	ld l,SpecialObject.angle
	bit 7,(hl)
	jr z,+

	ld (hl),e
	ret
+
	bit 7,a
	jr nz,@label_05_162
	sub (hl)
	add $04
	and $1f
	cp $09
	jr c,@label_05_164
	sub $10
	cp $09
	jr c,@label_05_163
	ld bc,$0100
	bit 7,a
	jr nz,@label_05_165
	ld b,$ff
	jr @label_05_165
@label_05_162:
	ld bc,$00fb
	ld a,(wLinkInAir)
	or a
	jr z,@label_05_165
	ld c,b
	jr @label_05_165
@label_05_163:
	ld bc,$01fb
	cp $03
	jr c,@label_05_165
	ld b,$ff
	cp $06
	jr nc,@label_05_165
	ld a,e
	xor $10
	ld (hl),a
	ld b,$00
	jr @label_05_165
@label_05_164:
	ld bc,$ff05
	cp $03
	jr c,@label_05_165
	ld b,$01
	cp $06
	jr nc,@label_05_165
	ld a,e
	ld (hl),a
	ld b,$00
@label_05_165:
	ld l,SpecialObject.var12
	inc (hl)
	ldi a,(hl)
	cp (hl)
	ret c

	; Set SpecialObject.speedTmp to $00
	dec l
	ld (hl),$00

	ld l,SpecialObject.angle
	ld a,(hl)
	add b
	and $1f
	ld (hl),a
	ld l,SpecialObject.speedTmp
	ldd a,(hl)
	ld b,a
	ld a,(hl)
	add c
	jr z,++
	bit 7,a
	jr nz,++

	cp b
	jr c,+
	ld a,b
+
	ld (hl),a
	ret
++
	ld l,SpecialObject.speed
	xor a
	ldi (hl),a
	inc l
	ld (hl),l
	dec a
	ld l,SpecialObject.angle
	ld (hl),a
	ret

;;
; linkState01 code, only for sidescrolling areas.
linkState01_sidescroll:
	call sidescrollUpdateActiveTile
	ld a,(wActiveTileType)
	bit TILETYPE_SS_BIT_WATER,a
	jr z,@notInWater

.ifdef ROM_AGES
	; In water

	ld h,d
	ld l,SpecialObject.var2f
	bit 6,(hl)
	jr z,+
	set 7,(hl)
+
.endif
	; If link was in water last frame, don't create a splash
	ld a,(wLinkSwimmingState)
	or a
	jr nz,++

	; Otherwise, he's just entering the water; create a splash
	inc a
	ld (wLinkSwimmingState),a
	call linkCreateSplash
	jr ++

@notInWater:
	; Set WLinkSwimmingState to $00, and jump if he wasn't in water last frame
	ld hl,wLinkSwimmingState
	ld a,(hl)
	ld (hl),$00
	or a
	jr z,++

	; He was in water last frame.

	; Skip the below code if he surfaced from an underwater ladder tile.
	ld a,(wLastActiveTileType)
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_WATER)
	jr z,++

	; Make him "hop out" of the water.

	ld a,$02
	ld (wLinkInAir),a
	call linkCreateSplash

	ld bc,-$1a0
	call objectSetSpeedZ

	ld a,(wLinkAngle)
	ld l,SpecialObject.angle
	ld (hl),a

++
	call checkUseItems

	ld a,(wLinkPlayingInstrument)
	or a
	ret nz

	call specialObjectUpdateAdjacentWallsBitset
	call linkUpdateKnockback

	ld a,(wLinkSwimmingState)
	or a
	jp nz,linkUpdateSwimming_sidescroll

	ld a,(wMagnetGloveState)
	bit 6,a
	jp z,+

	xor a
	ld (wLinkInAir),a
	jp animateLinkStanding
+
	call linkUpdateInAir_sidescroll
	ret z

	ld e,SpecialObject.knockbackCounter
	ld a,(de)
	or a
	ret nz

	ld a,(wActiveTileIndex)
	cp TILEINDEX_SS_SPIKE
	call z,dealSpikeDamageToLink

	ld a,(wForceIcePhysics)
	or a
	jr z,+

	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	jr nz,@onIce
+
	ld a,(wLastActiveTileType)
	cp TILETYPE_SS_ICE
	jr nz,@notOnIce

@onIce:
	ld a,SNOWSHOE_RING
	call cpActiveRing
	jr z,@notOnIce

	ld c,$88
	call updateLinkSpeed_withParam

	ld a,$06
	ld (wForceIcePhysics),a

	call linkUpdateVelocity

	ld c,$02
	ld a,(wLinkAngle)
	rlca
	jr c,++
	jr +

@notOnIce:
	xor a
	ld (wForceIcePhysics),a
	ld c,a
	ld a,(wLinkAngle)
	ld e,SpecialObject.angle
	ld (de),a
	rlca
	jr c,++

	call updateLinkSpeed_standard

	; Parameter for linkUpdateMovement (update his animation only; don't update his
	; position)
	ld c,$01

	ld a,(wLinkImmobilized)
	or a
	jr nz,++
+
	; Parameter for linkUpdateMovement (update everything, including his position)
	ld c,$07
++
	; When not in the water or in other tiles with particular effects, adjust Link's
	; angle so that he moves purely horizontally.
	ld hl,wActiveTileType
	ldi a,(hl)
	or (hl)
	and $ff~TILETYPE_SS_ICE
	call z,linkAdjustAngleInSidescrollingArea

	call linkUpdateMovement

	; The following checks are for whether to cap Link's y position so he doesn't go
	; above a certain point.

	ld e,SpecialObject.angle
	ld a,(de)
	add $04
	and $1f
	cp $09
	jr nc,++

	; Allow him to move up if the tile he's in has any special properties?
	ld hl,wActiveTileType
	ldi a,(hl)
	or a
	jr nz,++

	; Allow him to move up if the tile he's standing on is NOT the top of a ladder?
	ld a,(hl)
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_LADDER_TOP)
	jr nz,++

	; Check if Link's y position within the tile is lower than 9
	ld e,SpecialObject.yh
	ld a,(de)
	and $0f
	cp $09
	jr nc,++

	; If it's lower than 9, set it back to 9
	ld a,(de)
	and $f0
	add $09
	ld (de),a

++
	; Don't climb a ladder if Link is touching the ground
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	jr nz,+

	ld a,(wActiveTileType)
	bit TILETYPE_SS_BIT_LADDER,a
	jr z,+

	; Climbing a ladder
	ld a,$01
	ld (wLinkClimbingVine),a
+
	ld a,(wLinkTurningDisabled)
	or a
	ret nz
	jp updateLinkDirectionFromAngle

;;
; Updates Link's animation and position based on his current speed and angle variables,
; among other things.
; @param c Bit 0: Set if Link's animation should be "walking" instead of "standing".
;          Bit 1: Set if Link's position should be updated based on his speed and angle.
;          Bit 2: Set if the heart ring's regeneration should be applied (if he moves).
linkUpdateMovement:
	ld a,c

	; Check whether to animate him "standing" or "walking"
	rrca
	push af
	jr c,+
	call animateLinkStanding
	jr ++
+
	call animateLinkWalking
++
	pop af

	; Check whether to update his position
	rrca
	jr nc,++

	push af
	call specialObjectUpdatePosition
	jr z,+

	ld c,a
	pop af

	; Check whether to update the heart ring counter
	rrca
	ret nc

	ld a,c
	jp updateHeartRingCounter
+
	pop af
++
	jp linkResetSpeed

;;
; Only for top-down sections. (See also linkUpdateInAir_sidescroll.)
linkUpdateInAir:
	ld a,(wLinkInAir)
	and $0f
	rst_jumpTable
	.dw @notInAir
	.dw @startedJump
	.dw @inAir

@notInAir:
	; Ensure that bit 1 of wLinkInAir is set if Link's z position is < 0.
	ld h,d
	ld l,SpecialObject.zh
	bit 7,(hl)
	ret z

	ld a,$02
	ld (wLinkInAir),a
	jr ++

@startedJump:
	ld hl,wLinkInAir
	inc (hl)
	bit 7,(hl)
	jr nz,+

	ld hl,wIsTileSlippery
	bit 6,(hl)
	jr nz,+

	ld l,<wActiveTileType
	ld (hl),TILETYPE_NORMAL
	call updateLinkSpeed_standard

	ld a,(wLinkAngle)
	ld e,SpecialObject.angle
	ld (de),a
+
	ld a,SND_JUMP
	call playSound
++
	; Set jumping animation if he's not holding anything or using an item
	ld a,(wLinkGrabState)
	ld c,a
	ld a,(wLinkTurningDisabled)
	or c
	ld a,LINK_ANIM_MODE_JUMP
	call z,specialObjectSetAnimation

@inAir:
	xor a
	ld e,SpecialObject.var12
	ld (de),a
	inc e
	ld (de),a

	; If bit 7 of wLinkInAir is set, allow him to pass through walls (needed for
	; moving through cliff tiles?)
	ld hl,wLinkInAir
	bit 7,(hl)
	jr z,+
	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
+
	; Set 'c' to the gravity value. Reduce if bit 5 of wLinkInAir is set?
	bit 5,(hl)
	ld c,$20
	jr z,+
	ld c,$0a
+
	call objectUpdateSpeedZ_paramC

	ld l,SpecialObject.speedZ+1
	jr z,@landed

	; Still in the air

	; Return if speedZ is negative
	ld a,(hl)
	bit 7,a
	ret nz

	; Return if speedZ < $0300
	cp $03
	ret c

	; Cap speedZ to $0300
	ld (hl),$03
	dec l
	ld (hl),$00
	ret

@landed:
	; Set speedZ and wLinkInAir to 0
	xor a
	ldd (hl),a
	ld (hl),a
	ld (wLinkInAir),a

	ld e,SpecialObject.var36
	ld (de),a

	call animateLinkStanding
	call specialObjectSetPositionToVar38IfSet
	call linkApplyTileTypes

	; Check if wActiveTileType is TILETYPE_HOLE or TILETYPE_WARPHOLE
	ld a,(wActiveTileType)
	dec a
	cp TILETYPE_WARPHOLE
	jr nc,+

	; If it's a hole tile, initialize this
	ld a,$04
	ld (wStandingOnTileCounter),a
+
	ld a,SND_LAND
	call playSound
	call specialObjectUpdateAdjacentWallsBitset
	jp initLinkState

;;
; @param[out]	zflag	If set, linkState01_sidescroll will return prematurely.
linkUpdateInAir_sidescroll:
	ld a,(wLinkInAir)
	and $0f
	rst_jumpTable
	.dw @notInAir
	.dw @jumping
	.dw @inAir

@notInAir:
	ld a,(wLinkRidingObject)
	or a
	ret nz

	; Return if Link is on solid ground
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	ret nz

	; Return if Link's current tile, or the one he's standing on, is a ladder.
	ld hl,wActiveTileType
	ldi a,(hl)
	or (hl)
	bit TILETYPE_SS_BIT_LADDER,a
	ret nz

	; Link is in the air.
	ld h,d
	ld l,SpecialObject.speedZ
	xor a
	ldi (hl),a
	ldi (hl),a
	jr +

@jumping:
	ld a,SND_JUMP
	call playSound
+
	ld a,(wLinkGrabState)
	ld c,a
	ld a,(wLinkTurningDisabled)
	or c
	ld a,LINK_ANIM_MODE_JUMP
	call z,specialObjectSetAnimation

	ld a,$02
	ld (wLinkInAir),a
	call updateLinkSpeed_standard

@inAir:
	ld h,d
	ld l,SpecialObject.speedZ+1
	bit 7,(hl)
	jr z,@positiveSpeedZ

	; If speedZ is negative, check if he hits the ceiling
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $c0
	jr nz,@applyGravity
	jr @applySpeedZ

@positiveSpeedZ:
	ld a,(wLinkRidingObject)
	or a
	jp nz,@playingInstrument

	; Check if Link is on solid ground
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	jp nz,@landedOnGround

	; Check if Link presses up on a ladder; this will put him back into a ground state
	ld a,(wActiveTileType)
	bit TILETYPE_SS_BIT_LADDER,a
	jr z,+

	ld a,(wGameKeysPressed)
	and BTN_UP
	jp nz,@landed
+
	ld e,SpecialObject.yh
	ld a,(de)
	bit 3,a
	jr z,+

	ld a,(wLastActiveTileType)
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_LADDER_TOP)
	jr z,@landedOnGround
+
	ld hl,wActiveTileType
	ldi a,(hl)
	cp TILETYPE_SS_LAVA
	jp z,forceDrownLink

	; Check if he's ended up in a hole
	cp TILETYPE_SS_HOLE
	jr nz,++

	; Check the tile below link? (In this case, since wLastActiveTileType is the tile
	; 8 pixels below him, this will probably be the same as wActiveTile, UNTIL he
	; reaches the center of the tile. At which time, if the tile beneath has
	; a tileType of $00, Link will respawn.
	ld a,(hl)
	or a
	jr nz,++

	; Damage Link and respawn him.
	ld a,SND_DAMAGE_LINK
	call playSound
	jp respawnLink

++
	call linkUpdateVelocity

@applySpeedZ:
	; Apply speedZ to Y position
	ld l,SpecialObject.y
	ld e,SpecialObject.speedZ
	ld a,(de)
	add (hl)
	ldi (hl),a
	inc e
	ld a,(de)
	adc (hl)
	ldi (hl),a

@applyGravity:
	; Set 'c' to the gravity value (value to add to speedZ).
	ld c,$24
	ld a,(wLinkInAir)
	bit 5,a
	jr z,+
	ld c,$0e
+
	ld l,SpecialObject.speedZ
	ld a,(hl)
	add c
	ldi (hl),a
	ld a,(hl)
	adc $00
	ldd (hl),a

	; Cap Link's speedZ to $0300
	bit 7,a
	jr nz,+
	cp $03
	jr c,+
	xor a
	ldi (hl),a
	ld (hl),$03
+
	call specialObjectUpdateAdjacentWallsBitset

	; Check (again) whether Link has reached the ground.
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $30
	jr nz,@landedOnGround

	; Adjusts Link's angle so he doesn't move (on his own) on the y axis.
	; This is confusing since he has a Z speed, which gets applied to the Y axis. All
	; this does is prevent Link's movement from affecting the Y axis; it still allows
	; his Z speed to be applied.
	; Disabling this would give him some control over the height of his jumps.
	call linkAdjustAngleInSidescrollingArea

	call specialObjectUpdatePosition
	call specialObjectAnimate

	; Check if Link's reached the bottom boundary of the room?
	ld e,SpecialObject.yh
	ld a,(de)
	cp $a9
	jr c,@notLanded
.ifdef ROM_AGES
	jr @landedOnGround
.else
	ld a,(wActiveTileType)
	cp TILETYPE_SS_LADDER
	jr nz,@notLanded
	ld a,$80 | DIR_DOWN
	ld (wScreenTransitionDirection),a
.endif

@notLanded:
	xor a
	ret

@landedOnGround:
	; Lock his y position to the 9th pixel on that tile.
	ld e,SpecialObject.yh
	ld a,(de)
	and $f8
	add $01
	ld (de),a

@landed:
	xor a
	ld e,SpecialObject.speedZ
	ld (de),a
	inc e
	ld (de),a

	ld (wLinkInAir),a

	; Check if he landed on a spike
	ld a,(wActiveTileIndex)
	cp TILEINDEX_SS_SPIKE
	call z,dealSpikeDamageToLink

	ld a,SND_LAND
	call playSound
	call animateLinkStanding
	xor a
	ret

@playingInstrument:
	ld e,SpecialObject.var12
	xor a
	ld (de),a

	; Write $ff to the variable that you just wrote $00 to? OK, game.
	ld a,$ff
	ld (de),a

	ld e,SpecialObject.angle
	ld (de),a
	jr @landed

;;
; Sets link's state to LINK_STATE_NORMAL, sets var35 to $00
initLinkState:
	ld h,d
	ld l,<w1Link.state
	ld (hl),LINK_STATE_NORMAL
	inc l
	ld (hl),$00
	ld l,<w1Link.var35
	ld (hl),$00
	ret

;;
; Called after most types of warps
initLinkStateAndAnimateStanding:
	call initLinkState
	ld l,<w1Link.visible
	set 7,(hl)
;;
animateLinkStanding:
	ld e,<w1Link.animMode
	ld a,(de)
	cp LINK_ANIM_MODE_WALK
	jr nz,+

	call checkPegasusSeedCounter
	jr nz,animateLinkWalking
+
	; If not using pegasus seeds, set animMode to 0. At the end of the function, this
	; will be changed back to LINK_ANIM_MODE_WALK; this will simply cause the
	; animation to be reset, resulting in him staying on the animation's first frame.
	xor a
	ld (de),a

;;
animateLinkWalking:
	call checkPegasusSeedCounter
	jr z,++

	rlca
	jr nc,++

	; This has to do with the little puffs appearing at link's feet
	ld hl,w1ReservedItemF
	ld a,$03
	ldi (hl),a
	ld (hl),ITEMID_DUST
	inc l
	inc (hl)

	ld a,SND_LAND
	call playSound
++
	ld h,d
	ld a,$10
	ld l,<w1Link.animMode
	cp (hl)
	jp nz,specialObjectSetAnimation
	jp specialObjectAnimate

;;
updateLinkSpeed_standard:
	ld c,$00

;;
; @param	c	Bit 7 set if speed shouldn't be modified?
updateLinkSpeed_withParam:
	ld e,<w1Link.var36
	ld a,(de)
	cp c
	jr z,++

	ld a,c
	ld (de),a
	and $7f
	ld hl,@data
	rst_addAToHl

	ld e,<w1Link.speed
	ldi a,(hl)
	or a
	jr z,+

	ld (de),a
+
	xor a
	ld e,<w1Link.var12
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
++
	; 'b' will be added to the index for the below table, depending on whether Link is
	; slowed down by grass, stairs, etc.
	ld b,$02
	; 'e' will be added to the index in the same way as 'b'. It will be $04 if Link is
	; using pegasus seeds.
	ld e,$00

	; Don't apply pegasus seed modifier when on a hole?
	ld a,(wActiveTileType)
	cp TILETYPE_HOLE
	jr z,++
	cp TILETYPE_WARPHOLE
	jr z,++

	; Grass: b = $02
	cp TILETYPE_GRASS
	jr z,+
	inc b

	; Stairs / vines: b = $03
	cp TILETYPE_STAIRS
	jr z,+
	cp TILETYPE_VINES
	jr z,+

	; Standard movement: b = $04
	inc b
+
	call checkPegasusSeedCounter
	jr z,++

	ld e,$03
++
	ld a,e
	add b
	add c
	and $7f
	ld hl,@data
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,<w1Link.speedTmp
	ldd (hl),a
	bit 7,c
	ret nz
	ld (hl),a
	ret

@data:
	.db $28 $00 $1e $14 $28 $2d $1e $3c
	.db $00 $06 $28 $28 $28 $3c $3c $3c
	.db $14 $03 $1e $14 $28 $2d $1e $3c
.ifdef ROM_AGES
	.db $00 $05 $2d $2d $2d $2d $2d $2d
.endif

;;
; Updates Link's speed and updates his position if he's experiencing knockback.
linkUpdateKnockback:
	ld e,SpecialObject.state
	ld a,(de)
	cp LINK_STATE_RESPAWNING
	jr z,@cancelKnockback

	ld a,(wLinkInAir)
	rlca
	jr c,@cancelKnockback

	; Set c to the amount to decrement knockback by.
	; $01 normally, $02 if in the air?
	ld c,$01
	or a
	jr z,+
	inc c
+
	ld h,d
	ld l,SpecialObject.knockbackCounter
	ld a,(hl)
	or a
	ret z

	; Decrement knockback
	sub c
	jr c,@cancelKnockback
	ld (hl),a

	; Adjust link's knockback angle if necessary when sidescrolling
	ld l,SpecialObject.knockbackAngle
	call linkAdjustGivenAngleInSidescrollingArea

	; Get speed and knockback angle (de = w1Link.knockbackAngle)
	ld a,(de)
	ld c,a
	ld b,SPEED_140

	ld hl,wcc95
	res 5,(hl)

	jp specialObjectUpdatePositionGivenVelocity

@cancelKnockback:
	ld e,SpecialObject.knockbackCounter
	xor a
	ld (de),a
	ret

;;
; Updates a special object's position without allowing it to "slide off" tiles when they
; are approached from the side.
specialObjectUpdatePositionWithoutTileEdgeAdjust:
	ld e,SpecialObject.speed
	ld a,(de)
	ld b,a
	ld e,SpecialObject.angle
	ld a,(de)
	jr +

;;
specialObjectUpdatePosition:
	ld e,SpecialObject.speed
	ld a,(de)
	ld b,a
	ld e,SpecialObject.angle
	ld a,(de)
	ld c,a

;;
; Updates position, accounting for solid walls.
;
; @param	b	Speed
; @param	c	Angle
; @param[out]	a	Bits 0, 1 set if his y, x positions changed, respectively.
; @param[out]	c	Same as a.
; @param[out]	zflag	Set if the object did not move at all.
specialObjectUpdatePositionGivenVelocity:
	bit 7,c
	jr nz,++++

	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	ld e,a
	call @tileEdgeAdjust
	jr nz,++
+
	ld c,a
	ld e,$00
++
	; Depending on the angle, change 'e' to hold the bits that should be checked for
	; collision in adjacentWallsBitset. If the angle is facing up, then only the 'up'
	; bits will be set.
	ld a,c
	ld hl,@bitsToCheck
	rst_addAToHl
	ld a,e
	and (hl)
	ld e,a

	; Get 4 bytes at hl determining the offsets Link should move for speed 'b' and
	; angle 'c'.
	call getPositionOffsetForVelocity

	ld c,$00

	; Don't apply vertical speed if there is a wall.
	ld b,e
	ld a,b
	and $f0
	jr nz,++

	; Don't run the below code if the vertical offset is zero.
	ldi a,(hl)
	or (hl)
	jr z,++

	; Add values at hl to y position
	dec l
	ld e,SpecialObject.y
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	inc l
	ld a,(de)
	adc (hl)
	ld (de),a

	; Set bit 0 of c
	inc c
++
	; Don't apply horizontal speed if there is a wall.
	ld a,b
	and $0f
	jr nz,++

	; Don't run the below code if the horizontal offset is zero.
	ld l,<(wTmpcec0+3)
	ldd a,(hl)
	or (hl)
	jr z,++

	; Add values at hl to x position
	ld e,SpecialObject.x
	ld a,(de)
	add (hl)
	ld (de),a
	inc l
	inc e
	ld a,(de)
	adc (hl)
	ld (de),a

	set 1,c
++
	ld a,c
	or a
	ret
++++
	xor a
	ld c,a
	ret

; Takes an angle as an index.
; Each value tells which bits in adjacentWallsBitset to check for collision for that
; angle. Ie. when moving up, only check collisions above Link, not below.
@bitsToCheck:
	.db $cf $c3 $c3 $c3 $c3 $c3 $c3 $c3
	.db $f3 $33 $33 $33 $33 $33 $33 $33
	.db $3f $3c $3c $3c $3c $3c $3c $3c
	.db $fc $cc $cc $cc $cc $cc $cc $cc

;;
; Converts Link's angle such that he "slides off" a tile when walking towards the edge.
; @param c Angle
; @param e adjacentWallsBitset
; @param[out] a New angle value
; @param[out] zflag Set if a value has been returned in 'a'.
@tileEdgeAdjust:
	ld a,c
	ld hl,slideAngleTable
	rst_addAToHl
	ld a,(hl)
	and $03
	ret nz

	ld a,(hl)
	rlca
	jr c,@bit7
	rlca
	jr c,@bit6
	rlca
	jr c,@bit5

	ld a,e
	and $cc
	cp $04
	ld a,$00
	ret z

	ld a,e
	and $3c
	cp $08
	ld a,$10
	ret
@bit5:
	ld a,e
	and $c3
	cp $01
	ld a,$00
	ret z
	ld a,e
	and $33
	cp $02
	ld a,$10
	ret
@bit7:
	ld a,e
	and $c3
	cp $80
	ld a,$08
	ret z
	ld a,e
	and $cc
	cp $40
	ld a,$18
	ret
@bit6:
	ld a,e
	and $33
	cp $20
	ld a,$08
	ret z
	ld a,e
	and $3c
	cp $10
	ld a,$18
	ret

;;
; Updates SpecialObject.adjacentWallsBitset (always for link?) which determines which ways
; he can move.
specialObjectUpdateAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset
	xor a
	ld (de),a

	; Return if Link is riding a companion, minecart
	ld a,(wLinkObjectIndex)
	rrca
	ret c

.ifdef ROM_SEASONS
	ld a,(wActiveTileType)
	sub TILETYPE_STUMP
	jr nz,+
	dec a
	jr +++
+
.endif

	ld h,d
	ld l,SpecialObject.yh
	ld b,(hl)
	ld l,SpecialObject.xh
	ld c,(hl)
	call calculateAdjacentWallsBitset

.ifdef ROM_AGES
	ld b,a
	ld hl,@data-1
--
	inc hl
	ldi a,(hl)
	or a
	jr z,++
	cp b
	jr nz,--

	ld a,(hl)
	ldh (<hFF8B),a
	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
	ret
++
	ld a,b
	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
	ret

@data:
	.db $db $c3
	.db $ee $cc
	.db $00
.else
+++
	ld e,SpecialObject.adjacentWallsBitset
	ld (de),a
	ret
.endif

;;
; This function only really works with Link.
;
; @param	bc	Position to check
; @param[out]	b	Bit 7 set if the position is surrounded by a wall on all sides?
checkPositionSurroundedByWalls:
	call calculateAdjacentWallsBitset
--
	ld b,$80
	cp $ff
	ret z

	rra
	rl b
	rra
	rl b
	jr nz,--
	ret

;;
; This function is likely meant for Link only, due to its use of "wLinkRaisedFloorOffset".
;
; @param	bc	YX position.
; @param[out]	a	Bitset of adjacent walls.
; @param[out]	hFF8B	Same as 'a'.
calculateAdjacentWallsBitset:
	ld a,$01
	ldh (<hFF8B),a

	ld hl,@overworldOffsets
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr z,@loop
	ld hl,@sidescrollOffsets

; Loop 8 times
@loop:
	ldi a,(hl)
	add b
	ld b,a
	ldi a,(hl)
	add c
	ld c,a
	push hl

.ifdef ROM_AGES
	ld a,(wLinkRaisedFloorOffset)
	or a
	jr z,+

	call @checkTileCollisionAt_allowRaisedFl
	jr ++
+
.endif
	call checkTileCollisionAt_allowHoles
++
	pop hl
	ldh a,(<hFF8B)
	rla
	ldh (<hFF8B),a
	jr nc,@loop
	ret

; List of YX offsets from Link's position to check for collision at.
; For each offset where there is a collision, the corresponding bit of 'a' will be set.
@overworldOffsets:
	.db -3, -3
	.db  0,  5
	.db 10, -5
	.db  0,  5
	.db -7, -7
	.db  5,  0
	.db -5,  9
	.db  5,  0

@sidescrollOffsets:
	.db -3, -3
	.db  0,  5
	.db 10, -5
	.db  0,  5
	.db -7, -7
	.db  5,  0
	.db -5,  9
	.db  5,  0

.ifdef ROM_AGES
;;
; This may be identical to "checkTileCollisionAt_allowHoles", except that unlike that,
; this does not consider raised floors to have collision?
; @param bc YX position to check for collision
; @param[out] cflag Set on collision
@checkTileCollisionAt_allowRaisedFl:
	ld a,b
	and $f0
	ld l,a
	ld a,c
	swap a
	and $0f
	or l
	ld l,a
	ld h,>wRoomCollisions
	ld a,(hl)
	cp $10
	jr c,@simpleCollision

; Complex collision

	and $0f
	ld hl,@specialCollisions
	rst_addAToHl
	ld e,(hl)
	cp $08
	ld a,b
	jr nc,+
	ld a,c
+
	rrca
	and $07
	ld hl,bitTable
	add l
	ld l,a
	ld a,(hl)
	and e
	ret z
	scf
	ret

@specialCollisions:
	.db %00000000 %11000011 %00000011 %11000000 %00000000 %11000011 %11000011 %00000000
	.db %00000000 %11000011 %00000011 %11000000 %11000000 %11000001 %00000000 %00000000


@simpleCollision:
	bit 3,b
	jr nz,+
	rrca
	rrca
+
	bit 3,c
	jr nz,+
	rrca
+
	rrca
	ret
.endif

;;
; Unused?
clearLinkImmobilizedBit4:
	push hl
	ld hl,wLinkImmobilized
	res 4,(hl)
	pop hl
	ret

;;
setLinkImmobilizedBit4:
	push hl
	ld hl,wLinkImmobilized
	set 4,(hl)
	pop hl
	ret

;;
; Adjusts Link's position to suck him into the center of a tile, and sets his state to
; LINK_STATE_FALLING when he reaches the center.
linkPullIntoHole:
	xor a
	ld e,SpecialObject.knockbackCounter
	ld (de),a

	ld h,d
	ld l,SpecialObject.state
	ld a,(hl)
	cp LINK_STATE_RESPAWNING
	ret z

	; Allow partial control of Link's position for the first 16 frames he's over the
	; hole.
	ld a,(wStandingOnTileCounter)
	cp $10
	call nc,setLinkImmobilizedBit4

	; Depending on the frame counter, move horizontally, vertically, or not at all.
	and $03
	jr z,@moveVertical
	dec a
	jr z,@moveHorizontal
	ret

@moveVertical:
	ld l,SpecialObject.yh
	ld a,(hl)
	add $05
	and $f0
	add $08
	sub (hl)
	jr c,@decPosition
	jr @incPosition

@moveHorizontal:
	ld l,SpecialObject.xh
	ld a,(hl)
	and $f0
	add $08
	sub (hl)
	jr c,@decPosition

@incPosition:
	ld a,(hl)
	inc a
	jr +

@decPosition:
	ld a,(hl)
	dec a
+
	ld (hl),a

	; Check that Link is within 3 pixels of the vertical center
	ld l,SpecialObject.yh
	ldi a,(hl)
	and $0f
	sub $07
	cp $03
	ret nc

	; Check that Link is within 3 pixels of the horizontal center
	inc l
	ldi a,(hl)
	and $0f
	sub $07
	cp $03
	ret nc

	; Link has reached the center of the tile, now he'll start falling

	call clearAllParentItems

	ld e,SpecialObject.knockbackCounter
	xor a
	ld (de),a
	ld (wLinkStateParameter),a

	; Change Link's state to the falling state
	ld e,SpecialObject.id
	ld a,(de)
	or a
	ld a,LINK_STATE_RESPAWNING
	jp z,linkSetState

	; If link's ID isn't zero, set his state indirectly...?
	ld (wLinkForceState),a
	ret

;;
; Checks if Link is pushing against the bed in Nayru's house. If so, set Link's state to
; LINK_STATE_SLEEPING.
; The only bed that this works for is the one in Nayru's house.
checkLinkPushingAgainstBed:
	ld hl,wInformativeTextsShown
	bit 1,(hl)
	ret nz

	ld a,(wActiveGroup)
	cp $03
	ret nz

	; Check link is in room $9e, position $17, facing right
.ifdef ROM_AGES
	ldbc $9e, $17
	ld l,DIR_RIGHT
.else
	ldbc $82, $14
	ld l,DIR_LEFT
.endif
	ld a,(wActiveRoom)
	cp b
	ret nz

	ld a,(wActiveTilePos)
	cp c
	ret nz

	ld e,SpecialObject.direction
	ld a,(de)
	cp l
	ret nz

	call checkLinkPushingAgainstWall
	ret z

	; Increment counter, wait until it's been 90 frames
	ld hl,wLinkPushingAgainstBedCounter
	inc (hl)
	ld a,(hl)
	cp 90
	ret c

	pop hl
	ld hl,wInformativeTextsShown
	set 1,(hl)
	ld a,LINK_STATE_SLEEPING
	jp linkSetState

.ifdef ROM_SEASONS
;;
; Pushing against tree stump
checkLinkPushingAgainstTreeStump:
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	jp z,seasonsFunc_05_5ed3

	ld a,(wActiveGroup)
	or a
	ret nz

	ld a,(wLinkAngle)
	and $e7
	ret nz
	call checkLinkPushingAgainstWall
	ret nc
	ld e,SpecialObject.direction
	ld a,(de)
	ld hl,@relativeTile
	rst_addDoubleIndex

	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call objectGetRelativeTile
	cp $20
	ret nz
	ld a,$01
	call specialObjectSetVar37AndVar38

	ld e,SpecialObject.direction
	ld a,(de)
	ld l,a
	add a
	add l
	ld hl,@speedValues
	rst_addAToHl

	ld e,SpecialObject.speed
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ld e,SpecialObject.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	ld a,$81
	ld (wLinkInAir),a
	jp linkCancelAllItemUsage

@relativeTile:
	.db $f4 $00 ; DIR_UP
	.db $00 $07 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT

@speedValues:
	dbw $23 $fe40
	dbw $14 $fe60
	dbw $0f $fe40
	dbw $14 $fe60


seasonsFunc_05_5ed3:
	ld a,(wLinkAngle)
	ld c,a
	and $e7
	jr nz,++

	ld a,c
	add a
	swap a
	ld hl,@relativeTile

	rst_addDoubleIndex
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
	call checkTileCollisionAt_allowHoles
	jr c,++

	ld a,(wLinkAngle)
	ld e,SpecialObject.angle
	ld (de),a
	add a
	swap a
	ld c,a
	add a
	add c
	ld hl,@speedValues
	rst_addAToHl
	ld a,(wLinkTurningDisabled)
	or a
	jr nz,+
	ld e,SpecialObject.direction
	ld a,c
	ld (de),a
+
	ld e,SpecialObject.speed
	ldi a,(hl)
	ld (de),a
	; SpecialObject.speedTmp
	inc e
	ld (de),a
	ld e,SpecialObject.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	call clearVar37AndVar38
	ld a,$81
	ld (wLinkInAir),a
	xor a
	ret
++
	or d
	ret

@relativeTile:
	.db $fb $00
	.db $00 $09
	.db $1b $00
	.db $00 $f6

@speedValues:
	dbw $0f $fe60
	dbw $14 $fe60
	dbw $1e $fe40
	dbw $14 $fe60
.endif

clearVar37AndVar38:
	xor a
	ld e,SpecialObject.var37
	ld (de),a
	inc e
	ld (de),a
	ret

;;
; @param	a	Value for var37
; @param	l	Value for var38 (a position value)
specialObjectSetVar37AndVar38:
	ld e,SpecialObject.var37
	ld (de),a
	inc e
	ld a,l
	ld (de),a

;;
; Sets an object's angle to face the position in var37/var38?
specialObjectSetAngleRelativeToVar38:
	ld e,SpecialObject.var37
	ld a,(de)
	or a
	ret z

	ld hl,data_6012-2
	rst_addDoubleIndex

	inc e
	ld a,(de)
	ld c,a
	and $f0
	add (hl)
	ld b,a
	inc hl
	ld a,c
	and $0f
	swap a
	add (hl)
	ld c,a

	call objectGetRelativeAngle
	ld e,SpecialObject.angle
	ld (de),a
	ret

data_6012:
	.db $02 $08
	.db $0c $08

;;
; Warps link somewhere based on var37 and var38?
specialObjectSetPositionToVar38IfSet:
	ld e,SpecialObject.var37
	ld a,(de)
	or a
	ret z

	ld hl,data_6012-2
	rst_addDoubleIndex

	; de = SpecialObject.var38
	inc e
	ld a,(de)
	ld c,a
	and $f0
	add (hl)
	ld e,SpecialObject.yh
	ld (de),a

	inc hl
	ld a,c
	and $0f
	swap a
	add (hl)
	ld e,SpecialObject.xh
	ld (de),a
	jr clearVar37AndVar38

;;
; Checks if Link touches a cliff tile, and starts the jumping-off-cliff code if so.
checkLinkJumpingOffCliff:
.ifdef ROM_SEASONS
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	ret z
.endif

	; Return if Link is not moving in a cardinal direction?
	ld a,(wLinkAngle)
	ld c,a
	and $e7
	ret nz

	ld h,d
	ld l,SpecialObject.angle
	xor c
	cp (hl)
	ret nz

	; Check that Link is facing towards a solid wall
	add a
	swap a
	ld c,a
	add a
	add a
	add c
	ld hl,@wallDirections
	rst_addAToHl
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and (hl)
	cp (hl)
	ret nz

	; Check 2 offsets from Link's position to ensure that both of them are cliff
	; tiles.
	call @checkCliffTile
	ret nc
	call @checkCliffTile
	ret nc

	; If the above checks passed, start making Link jump off the cliff.

	ld a,$81
	ld (wLinkInAir),a
	ld bc,-$1c0
	call objectSetSpeedZ
	ld l,SpecialObject.knockbackCounter
	ld (hl),$00

.ifdef ROM_SEASONS
	ldh a,(<hFF8B)
	cp $05
	jr z,@setSpeed140
	cp $06
	jr z,@setSpeed140
.endif

	; Return from caller (don't execute any more "linkState01" code)
	pop hl

	ld a,LINK_STATE_JUMPING_DOWN_LEDGE
	call linkSetState
	jr linkState12

;;
; Unused?
@setSpeed140:
	ld l,SpecialObject.speed
	ld (hl),SPEED_140
	ret

;;
; @param[out] cflag
@checkCliffTile:
	inc hl
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	push hl
	call objectGetRelativeTile
	ldh (<hFF8B),a
	ld hl,cliffTilesTable
	call lookupCollisionTable
	pop hl
	ret nc

	ld c,a
	ld e,SpecialObject.angle
	ld a,(de)
	cp c
	scf
	ret z

	xor a
	ret

; Data format:
; b0: bits that must be set in w1Link.adjacentWallsBitset for that direction
; b1-b2, b3-b4: Each of these pairs of bytes is a relative offset from Link's position to
; check whether the tile there is a cliff tile. Both resulting positions must be valid.
@wallDirections:
	.db $c0 $fc $fd $fc $02 ; DIR_UP
	.db $03 $00 $04 $05 $04 ; DIR_RIGHT
	.db $30 $08 $fd $08 $02 ; DIR_DOWN
	.db $0c $00 $fb $05 $fb ; DIR_LEFT

;;
; LINK_STATE_JUMPING_DOWN_LEDGE
linkState12:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemIncSubstate

.ifdef ROM_AGES
	; Set jumping animation if not underwater
	ld l,SpecialObject.var2f
	bit 7,(hl)
	jr nz,++
.endif

	ld a,(wLinkGrabState)
	ld c,a
	ld a,(wLinkTurningDisabled)
	or c
	ld a,LINK_ANIM_MODE_JUMP
	call z,specialObjectSetAnimation
++
	ld a,SND_JUMP
	call playSound

	call @getLengthOfCliff
	jr z,@willTransition

	ld hl,@cliffSpeedTable - 1
	rst_addAToHl
	ld a,(hl)
	ld e,SpecialObject.speed
	ld (de),a
	ret

; A screen transition will occur by jumping off this cliff. Only works properly for cliffs
; facing down.
@willTransition:
	ld a,(wScreenTransitionBoundaryY)
	ld b,a
	ld h,d
	ld l,SpecialObject.yh
	ld a,(hl)
	sub b
	ld (hl),b

	ld l,SpecialObject.zh
	ld (hl),a

	; Disable terrain effects (shadow)
	ld l,SpecialObject.visible
	res 6,(hl)

	ld l,SpecialObject.substate
	ld (hl),$02

	xor a
	ld l,SpecialObject.speed
	ld (hl),a
	ld l,SpecialObject.speedZ
	ldi (hl),a
	ld (hl),$ff

	; [wDisableScreenTransitions] = $01
	inc a
	ld (wDisableScreenTransitions),a

	ld l,SpecialObject.var2f
	set 0,(hl)
	ret


; The index to this table is the length of a cliff in tiles; the value is the speed
; required to pass through the cliff.
@cliffSpeedTable:
	.db           SPEED_080 SPEED_0a0 SPEED_0e0
	.db SPEED_120 SPEED_160 SPEED_1a0 SPEED_200
	.db SPEED_240 SPEED_280 SPEED_2c0 SPEED_300


; In the process of falling down the cliff (will land in-bounds).
@substate1:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,specialObjectAnimate

; Link has landed on the ground

	; If a screen transition happened, update respawn position
	ld h,d
	ld l,SpecialObject.var2f
	bit 0,(hl)
	res 0,(hl)
	call nz,updateLinkLocalRespawnPosition

	call specialObjectTryToBreakTile_source05

.ifdef ROM_SEASONS
	ld a,(wActiveGroup)
	or a
	jr nz,+
	ld bc,$0500
	call objectGetRelativeTile
	cp $20
	jr nz,+
	call objectCenterOnTile
	ld l,SpecialObject.yh
	ld a,(hl)
	sub $06
	ld (hl),a
+
.endif

	xor a
	ld (wLinkInAir),a
	ld (wLinkSwimmingState),a

	ld a,SND_LAND
	call playSound

	call specialObjectUpdateAdjacentWallsBitset
	jp initLinkStateAndAnimateStanding


; In the process of falling down the cliff (a screen transition will occur).
@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,specialObjectAnimate

	; Initiate screen transition
	ld a,$82
	ld (wScreenTransitionDirection),a
	ld e,SpecialObject.substate
	ld a,$03
	ld (de),a
	ret

; In the process of falling down the cliff, after a screen transition happened.
@substate3:
	; Wait for transition to finish
	ld a,(wScrollMode)
	cp $01
	ret nz

	call @getLengthOfCliff

	; Set his y position to the position he'll land at, and set his z position to the
	; equivalent height needed to appear to not have moved.
	ld h,d
	ld l,SpecialObject.yh
	ld a,(hl)
	sub b
	ld (hl),b
	ld l,SpecialObject.zh
	ld (hl),a

	; Re-enable terrain effects (shadow)
	ld l,SpecialObject.visible
	set 6,(hl)

	; Go to substate 1 to complete the fall.
	ld l,SpecialObject.substate
	ld (hl),$01
	ret

;;
; Calculates the number of cliff tiles Link will need to pass through.
;
; @param[out]	a	Number of cliff tiles that Link must pass through
; @param[out]	bc	Position of the tile that will be landed on
; @param[out]	zflag	Set if there will be a screen transition before hitting the ground
@getLengthOfCliff:
	; Get Link's position in bc
	ld h,d
	ld l,SpecialObject.yh
	ldi a,(hl)
	add $05
	ld b,a
	inc l
	ld c,(hl)

	; Determine direction he's moving in based on angle
	ld l,SpecialObject.angle
	ld a,(hl)
	add a
	swap a
	and $03
	ld hl,@offsets
	rst_addDoubleIndex

	ldi a,(hl)
	ldh (<hFF8D),a ; [hFF8D] = y-offset to add to get the next tile's position
	ld a,(hl)
	ldh (<hFF8C),a ; [hFF8C] = x-offset to add to get the next tile's position
	ld a,$01
	ldh (<hFF8B),a ; [hFF8B] = how many tiles away the one we're checking is

@nextTile:
	; Get next tile's position
	ldh a,(<hFF8D)
	add b
	ld b,a
	ldh a,(<hFF8C)
	add c
	ld c,a

	call checkTileCollisionAt_allowHoles
	jr nc,@noCollision

	; If this tile is breakable, we can land here
	ld a, $80 | BREAKABLETILESOURCE_05
	call tryToBreakTile
	jr c,@landHere

	; Even if it's solid and unbreakable, check if it's an exception (raisable floor)
	ldh a,(<hFF92)
	ld hl,landableTileFromCliffExceptions
	call findByteInCollisionTable
	jr c,@landHere

	; Try the next tile
	ldh a,(<hFF8B)
	inc a
	ldh (<hFF8B),a
	jr @nextTile

@noCollision:
	; Check if we've gone out of bounds (tile index $00)
	call getTileAtPosition
	or a
	ret z

@landHere:
	ldh a,(<hFF8B)
	cp $0b
	jr c,+
	ld a,$0b
+
	or a
	ret

@offsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT


; This is a list of tiles that can be landed on when jumping down a cliff, despite being
; solid.
landableTileFromCliffExceptions:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES
@collisions1:
@collisions2:
@collisions5:
	.db TILEINDEX_RAISABLE_FLOOR_1 TILEINDEX_RAISABLE_FLOOR_2
@collisions0:
@collisions3:
@collisions4:
	.db $00
.else
@collisions0:
	.db $eb $20
@collisions1:
@collisions2:
@collisions3:
@collisions4:
@collisions5:
	.db $00
.endif

;;
specialObjectCode_transformedLink:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

;;
; State 0: initialization (just transformed)
@state0:
	call dropLinkHeldItem
	call clearAllParentItems
	ld a,(wLinkForceState)
	or a
	jr nz,@resetIDToNormal

	call specialObjectSetOamVariables
	xor a
	call specialObjectSetAnimation
	call objectSetVisiblec1
	call itemIncState

	ld l,SpecialObject.collisionType
	ld a, $80 | ITEMCOLLISION_LINK
	ldi (hl),a

	inc l
	ld a,$06
	ldi (hl),a ; [collisionRadiusY] = $06
	ldi (hl),a ; [collisionRadiusX] = $06

	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECTID_LINK_AS_BABY
	ret nz

	ld l,SpecialObject.counter1
	ld (hl),$e0
	inc l
	ld (hl),$01 ; [counter2] = $01

	ld a,SND_BECOME_BABY
	call playSound
	jr @createGreenPoof

@disableTransformationForBaby:
	ld a,SND_MAGIC_POWDER
	call playSound

@disableTransformation:
	lda SPECIALOBJECTID_LINK
	call setLinkIDOverride
	ld a,$01
	ld (wDisableRingTransformations),a

	ld e,SpecialObject.id
	ld a,(de)
	cp SPECIALOBJECTID_LINK_AS_BABY
	ret nz

@createGreenPoof:
	ld b,INTERACID_GREENPOOF
	jp objectCreateInteractionWithSubid00

@resetIDToNormal:
	; If a specific state is requested, go back to normal Link code and run it.
	lda SPECIALOBJECTID_LINK
	call setLinkID
	ld a,$01
	ld (wDisableRingTransformations),a
	jp specialObjectCode_link

;;
; State 1: normal movement, etc in transformed state
@state1:
	ld a,(wLinkForceState)
	or a
	jr nz,@resetIDToNormal

	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wScrollMode)
	and $0e
	ret nz

	call updateLinkDamageTaken
	ld a,(wLinkDeathTrigger)
	or a
	jr nz,@disableTransformation

	call retIfTextIsActive

	ld a,(wDisabledObjects)
	and $81
	ret nz

	call decPegasusSeedCounter

	ld h,d
	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECTID_LINK_AS_BABY
	jr nz,+
	ld l,SpecialObject.counter1
	call decHlRef16WithCap
	jr z,@disableTransformationForBaby
	jr ++
+
	call linkApplyTileTypes
	ld a,(wLinkSwimmingState)
	or a
	jr nz,@resetIDToNormal

	callab bank6.getTransformedLinkID
	ld e,SpecialObject.id
	ld a,(de)
	cp b
	ld a,b
	jr nz,@resetIDToNormal
++
	call specialObjectUpdateAdjacentWallsBitset
	call linkUpdateKnockback
	call updateLinkSpeed_standard

	; Halve speed if he's in baby form
	ld h,d
	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECTID_LINK_AS_BABY
	jr nz,+
	ld l,SpecialObject.speed
	srl (hl)
+
	ld l,SpecialObject.knockbackCounter
	ld a,(hl)
	or a
	jr nz,@animateIfPegasusSeedsActive

	ld l,SpecialObject.collisionType
	set 7,(hl)

	; Update gravity
	ld l,SpecialObject.zh
	bit 7,(hl)
	jr z,++
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,++
	xor a
	ld (wLinkInAir),a
++
	ld a,(wcc95)
	ld b,a
	ld l,SpecialObject.angle
	ld a,(wLinkAngle)
	ld (hl),a

	; Set carry flag if [wLinkAngle] == $ff or Link is in a spinner
	or b
	rlca
	jr c,@animateIfPegasusSeedsActive

	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECTID_LINK_AS_BABY
	jr nz,++
	ld l,SpecialObject.animParameter
	bit 7,(hl)
	res 7,(hl)
	ld a,SND_SPLASH
	call nz,playSound
++
	ld a,(wLinkTurningDisabled)
	or a
	call z,updateLinkDirectionFromAngle
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	jr z,@animate
	ld a,(wLinkImmobilized)
	or a
	jr nz,@animate
	call specialObjectUpdatePosition

@animate:
	; Check whether to create the pegasus seed effect
	call checkPegasusSeedCounter
	jr z,++
	rlca
	jr nc,++
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_FALLDOWNHOLE
	inc l
	inc (hl)
	ld bc,$0500
	call objectCopyPositionWithOffset
++
	ld e,SpecialObject.animMode
	ld a,(de)
	or a
	jp z,specialObjectAnimate
	xor a
	jp specialObjectSetAnimation

@animateIfPegasusSeedsActive:
	call checkPegasusSeedCounter
	jr nz,@animate
	xor a
	jp specialObjectSetAnimation


;;
specialObjectCode_linkRidingAnimal:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call dropLinkHeldItem
	call clearAllParentItems
	call specialObjectSetOamVariables

	ld h,d
	ld l,SpecialObject.state
	inc (hl)
	ld l,SpecialObject.collisionType
	ld a, $80 | ITEMCOLLISION_LINK
	ldi (hl),a

	inc l
	ld a,$06
	ldi (hl),a ; [collisionRadiusY] = $06
	ldi (hl),a ; [collisionRadiusX] = $06
	call @readCompanionAnimParameter
	jp objectSetVisiblec1

	; Unused code? (Revert back to ordinary Link code)
	lda SPECIALOBJECTID_LINK
	call setLinkIDOverride
	ld b,INTERACID_GREENPOOF
	jp objectCreateInteractionWithSubid00

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call updateLinkDamageTaken

	call retIfTextIsActive
	ld a,(wScrollMode)
	and $0e
	ret nz

	ld a,(wDisabledObjects)
	rlca
	ret c
	call linkUpdateKnockback

;;
; Copies companion's animParameter & $3f to var31.
@readCompanionAnimParameter:
	ld hl,w1Companion.animParameter
	ld a,(hl)
	and $3f
	ld e,SpecialObject.var31
	ld (de),a
	ret


;;
; Update a minecart object.
specialObjectCode_minecart:
	; Jump to code in bank 6 to handle it
	jpab bank6.specialObjectCode_minecart




; Maple variables:
;
;  var03:  gets set to 0 (rarer item drops) or 1 (standard item drops) when spawning.
;
;  relatedObj1: pointer to a bomb object (maple can suck one up when on her vacuum).
;  relatedObj2: At first, this is a pointer to data in the rom determining Maple's path?
;               When collecting items, this is a pointer to the item she's collecting.
;
;  damage: maple's vehicle (0=broom, 1=vacuum, 2=ufo)
;  health: the value of the loot that Maple's gotten
;  var2a:  the value of the loot that Link's gotten
;
;  invincibilityCounter: nonzero if maple's dropped a heart piece
;  knockbackAngle: actually stores bitmask for item indices 1-4; a bit is set if the item
;                  has been spawned. These items can't spawn more than once.
;  stunCounter: the index of the item that Maple is picking up
;
;  var3a: When recoiling, this gets copied to speedZ?
;         During item collection, this is the delay for maple turning?
;  var3b: Counter until Maple can update her angle by a unit. (Length determined by var3a)
;  var3c: Counter until Maple's Z speed reverses (when floating up and down)
;  var3d: Angle that she's turning toward
;  var3f: Value from 0-2 which determines how much variation there is in maple's movement
;         path? (The variation in her movement increases as she's encountered more often.)
;
;
;;
specialObjectCode_maple:
	call companionRetIfInactiveWithoutStateCheck
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw mapleState0
	.dw mapleState1
	.dw mapleState2
	.dw mapleState3
	.dw mapleState4
	.dw mapleState5
	.dw mapleState6
	.dw mapleState7
	.dw mapleState8
	.dw mapleState9
	.dw mapleStateA
	.dw mapleStateB
	.dw mapleStateC

;;
; State 0: Initialization
mapleState0:
	xor a
	ld (wcc85),a
	call specialObjectSetOamVariables

	; Set 'c' to be the amount of variation in maple's path (higher the more she's
	; been encountered)
	ld c,$02
	ld a,(wMapleState)
	and $0f
	cp $0f
	jr z,+
	dec c
	cp $08
	jr nc,+
	dec c
+
	ld a,c
	ld e,SpecialObject.var3f
	ld (de),a

	; Determine maple's vehicle (written to "damage" variable); broom/vacuum in normal
	; game, or broom/ufo in linked game.
	or a
	jr z,+
	ld a,$01
+
	ld e,SpecialObject.damage
	ld (de),a
	or a
	jr z,++
	call checkIsLinkedGame
	jr z,++
	ld a,$02
	ld (de),a
++
	call itemIncState

	ld l,SpecialObject.yh
	ld a,$10
	ldi (hl),a  ; [yh] = $10
	inc l
	ld (hl),$b8 ; [xh] = $b8

	ld l,SpecialObject.zh
	ld a,$88
	ldi (hl),a

	ld (hl),SPEED_140 ; [speed] = SPEED_140

	ld l,SpecialObject.collisionRadiusY
	ld a,$08
	ldi (hl),a
	ld (hl),a

	ld l,SpecialObject.knockbackCounter
	ld (hl),$03

	; Decide on Maple's drop pattern.
	; If [var03] = 0, it's a rare item pattern (1/8 times).
	; If [var03] = 1, it's a standard pattern  (7/8 times).
	call getRandomNumber
	and $07
	jr z,+
	ld a,$01
+
	ld e,SpecialObject.var03
	ld (de),a

	ld hl,mapleShadowPathsTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,SpecialObject.var3a
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ld e,SpecialObject.relatedObj2
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld a,(hl)
	ld e,SpecialObject.angle
	ld (de),a
	call mapleDecideNextAngle
	call objectSetVisiblec0
	ld a,$19
	jp specialObjectSetAnimation

;;
mapleState1:
	call mapleState4
	ret nz
	ld a,(wMenuDisabled)
	or a
	jp nz,mapleDeleteSelf

	ld a,MUS_MAPLE_THEME
	ld (wActiveMusic),a
	jp playSound

;;
; State 4: lying on ground after being hit
mapleState4:
	ld hl,w1Companion.knockbackCounter
	dec (hl)
	ret nz
	call itemIncState
	xor a
	ret

;;
; State 2: flying around (above screen or otherwise) before being hit
mapleState2:
	ld a,(wTextIsActive)
	or a
	jr nz,@animate
	ld hl,w1Companion.counter2
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld l,SpecialObject.var3d
	ld a,(hl)
	ld l,SpecialObject.angle
	cp (hl)
	jr z,+
	call mapleUpdateAngle
	jr ++
+
	ld l,SpecialObject.counter1
	dec (hl)
	call z,mapleDecideNextAngle
	jr z,@label_05_262
++
	call objectApplySpeed
	ld e,SpecialObject.var3e
	ld a,(de)
	or a
	ret z

.ifdef ROM_AGES
	call checkLinkVulnerableAndIDZero
.else
	call checkLinkID0AndControlNormal
.endif
	jr nc,@animate
	call objectCheckCollidedWithLink_ignoreZ
	jr c,mapleCollideWithLink
@animate:
	call mapleUpdateOscillation
	jp specialObjectAnimate

@label_05_262:
	ld hl,w1Companion.var3e
	ld a,(hl)
	or a
	jp nz,mapleDeleteSelf

	inc (hl)
	call mapleInitZPositionAndSpeed

	ld l,SpecialObject.speed
	ld (hl),SPEED_200
	ld l,SpecialObject.counter2
	ld (hl),$3c

	ld e,SpecialObject.var3f
	ld a,(de)

	ld e,$03
	or a
	jr z,++
	set 2,e
	cp $01
	jr z,++
	set 3,e
++
	call getRandomNumber
	and e
	ld hl,mapleMovementPatternIndices
	rst_addAToHl
	ld a,(hl)
	ld hl,mapleMovementPatternTable
	rst_addDoubleIndex

	ld e,SpecialObject.yh
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	ld (de),a
	ld e,SpecialObject.xh
	ldi a,(hl)
	ld (de),a

	ldi a,(hl)
	ld e,SpecialObject.var3a
	ld (de),a
	inc e
	ld (de),a

	ld a,(hl)
	ld e,SpecialObject.angle
	ld (de),a

	ld e,SpecialObject.relatedObj2
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

;;
; Updates var3d with the angle Maple should be turning toward next, and counter1 with the
; length of time she should stay in that angle.
;
; @param[out]	zflag	z if we've reached the end of the "angle data".
mapleDecideNextAngle:
	ld hl,w1Companion.relatedObj2
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,SpecialObject.var3d
	ldi a,(hl)
	ld (de),a
	ld c,a
	ld e,SpecialObject.counter1
	ldi a,(hl)
	ld (de),a

	ld e,SpecialObject.relatedObj2
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld a,c
	cp $ff
	ret z
	jp mapleDecideAnimation

;;
; Handles stuff when Maple collides with Link. (Sets knockback for both, sets Maple's
; animation, drops items, and goes to state 3.)
;
mapleCollideWithLink:
	call dropLinkHeldItem
	call mapleSpawnItemDrops

	ld a,$01
	ld (wDisableScreenTransitions),a
	ld (wMenuDisabled),a
	ld a,$3c
	ld (wInstrumentsDisabledCounter),a
	ld e,SpecialObject.counter1
	xor a
	ld (de),a

	; Set knockback direction and angle for Link and Maple
	call mapleGetCardinalAngleTowardLink
	ld b,a
	ld hl,w1Link.knockbackCounter
	ld (hl),$18

	ld e,SpecialObject.angle
	ld l,<w1Link.knockbackAngle
	ld (hl),a
	xor $10
	ld (de),a

	; Determine maple's knockback speed
	ld e,SpecialObject.damage
	ld a,(de)
	ld hl,@speeds
	rst_addAToHl
	ld a,(hl)
	ld e,SpecialObject.speed
	ld (de),a

	ld e,SpecialObject.var3a
	ld a,$fc
	ld (de),a
	ld a,$0f
	ld (wScreenShakeCounterX),a

	ld e,SpecialObject.state
	ld a,$03
	ld (de),a

	; Determine animation? ('b' currently holds the angle toward link.)
	ld a,b
	add $04
	add a
	add a
	swap a
	and $01
	xor $01
	add $10
	ld b,a
	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add b
	call specialObjectSetAnimation

	ld a,SND_SCENT_SEED
	jp playSound

@speeds:
	.db SPEED_100
	.db SPEED_140
	.db SPEED_180

;;
; State 3: recoiling after being hit
mapleState3:
	ld a,(w1Link.knockbackCounter)
	or a
	jr nz,+
	ld a,$01
	ld (wDisabledObjects),a
+
	ld h,d
	ld e,SpecialObject.var3a
	ld a,(de)
	or a
	jr z,@animate

	ld e,SpecialObject.zh
	ld a,(de)
	or a
	jr nz,@applyKnockback

	; Update speedZ
	ld e,SpecialObject.var3a
	ld l,SpecialObject.speedZ+1
	ld a,(de)
	inc a
	ld (de),a
	ld (hl),a

@applyKnockback:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	call objectApplySpeed
	call mapleKeepInBounds
	call objectGetTileCollisions
	ret z
	jr @counteractWallSpeed

@animate:
	ld a,(wDisabledObjects)
	or a
	ret z

	; Wait until the animation gives the signal to go to state 4
	ld e,SpecialObject.animParameter
	ld a,(de)
	cp $ff
	jp nz,specialObjectAnimate
	ld e,SpecialObject.knockbackCounter
	ld a,$78
	ld (de),a
	ld e,SpecialObject.state
	ld a,$04
	ld (de),a
	ret

; If maple's hitting a wall, counteract the speed being applied.
@counteractWallSpeed:
	ld e,SpecialObject.angle
	call convertAngleDeToDirection
	ld hl,@offsets
	rst_addDoubleIndex
	ld e,SpecialObject.yh
	ld a,(de)
	add (hl)
	ld b,a
	inc hl
	ld e,SpecialObject.xh
	ld a,(de)
	add (hl)
	ld c,a

	ld h,d
	ld l,SpecialObject.yh
	ld (hl),b
	ld l,SpecialObject.xh
	ld (hl),c
	ret

@offsets:
	.db $04 $00 ; DIR_UP
	.db $00 $fc ; DIR_RIGHT
	.db $fc $00 ; DIR_DOWN
	.db $00 $04 ; DIR_LEFT

;;
; State 5: floating back up after being hit
mapleState5:
	ld hl,w1Companion.counter1
	ld a,(hl)
	or a
	jr nz,@floatUp

; counter1 has reached 0

	inc (hl)
	call mapleInitZPositionAndSpeed
	ld l,SpecialObject.zh
	ld (hl),$ff
	ld a,$01
	ld l,SpecialObject.var3a
	ldi (hl),a
	ld (hl),a  ; [var3b] = $01

	; Reverse direction (to face Link)
	ld e,SpecialObject.angle
	ld a,(de)
	xor $10
	ld (de),a
	call mapleDecideAnimation

@floatUp:
	ld e,SpecialObject.damage
	ld a,(de)
	ld c,a

	; Rise one pixel per frame
	ld e,SpecialObject.zh
	ld a,(de)
	dec a
	ld (de),a
	cp $f9
	ret nc

	; If on the ufo or vacuum cleaner, rise 16 pixels higher
	ld a,c
	or a
	jr z,@finishedFloatingUp
	ld a,(de)
	cp $e9
	ret nc

@finishedFloatingUp:
	ld a,(wMapleState)
	bit 4,a
	jr nz,@exchangeTouchingBook

	ld l,SpecialObject.state
	ld (hl),$06

	; Set collision radius variables
	ld e,SpecialObject.damage
	ld a,(de)
	ld hl,@collisionRadii
	rst_addDoubleIndex
	ld e,SpecialObject.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

.ifdef ROM_AGES
	; Check if this is the past. She says something about coming through a "weird
	; tunnel", which is probably their justification for her being in the past? She
	; only says this the first time she's encountered in the past.
	ld a,(wActiveGroup)
	dec a
	jr nz,@normalEncounter

	ld a,(wMapleState)
	and $0f
	ld bc,TX_0712
	jr z,++

	ld a,GLOBALFLAG_44
	call checkGlobalFlag
	ld bc,TX_0713
	jr nz,@normalEncounter
++
	ld a,GLOBALFLAG_44
	call setGlobalFlag
	jr @showText
.endif

@normalEncounter:
	; If this is the first encounter, show TX_0700
	ld a,(wMapleState)
	and $0f
	ld bc,TX_0700
	jr z,@showText

	; If we've encountered maple 5 times or more, show TX_0705
	ld c,<TX_0705
	cp $05
	jr nc,@showText

	; Otherwise, pick a random text index from TX_0701-TX_0704
	call getRandomNumber
	and $03
	ld hl,@normalEncounterText
	rst_addAToHl
	ld c,(hl)
@showText:
	call showText
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp mapleDecideItemToCollectAndUpdateTargetAngle

@exchangeTouchingBook:
	ld a,$0b
	ld l,SpecialObject.state
	ld (hl),a

	ld l,SpecialObject.direction
	ldi (hl),a  ; [direction] = $0b (?)
	ld (hl),$ff ; [angle] = $ff

	ld l,SpecialObject.speed
	ld (hl),SPEED_100

.ifdef ROM_AGES
	ld bc,TX_070d
.else
	ld bc,TX_0709
.endif
	jp showText


; One of these pieces of text is chosen at random when bumping into maple between the 2nd
; and 4th encounters (inclusive).
@normalEncounterText:
	.db <TX_0701 <TX_0702 <TX_0703 <TX_0704


; Values for collisionRadiusY/X for maple's various forms.
@collisionRadii:
	.db $02 $02 ; broom
	.db $02 $02 ; vacuum cleaner
	.db $04 $04 ; ufo


;;
; Updates maple's Z position and speedZ for oscillation (but not if she's in a ufo?)
mapleUpdateOscillation:
	ld h,d
	ld e,SpecialObject.damage
	ld a,(de)
	cp $02
	ret z

	ld c,$00
	call objectUpdateSpeedZ_paramC

	; Wait a certain number of frames before inverting speedZ
	ld l,SpecialObject.var3c
	ld a,(hl)
	dec a
	ld (hl),a
	ret nz

	ld a,$16
	ld (hl),a

	; Invert speedZ
	ld l,SpecialObject.speedZ
	ld a,(hl)
	cpl
	inc a
	ldi (hl),a
	ld a,(hl)
	cpl
	ld (hl),a
	ret

;;
mapleUpdateAngle:
	ld hl,w1Companion.var3b
	dec (hl)
	ret nz

	ld e,SpecialObject.var3a
	ld a,(de)
	ld (hl),a
	ld l,SpecialObject.angle
	ld e,SpecialObject.var3d
	ld l,(hl)
	ldh (<hFF8B),a
	ld a,(de)
	call objectNudgeAngleTowards

;;
; @param[out]	zflag
mapleDecideAnimation:
	ld e,SpecialObject.var3e
	ld a,(de)
	or a
	jr z,@ret

	ld h,d
	ld l,SpecialObject.angle
	ld a,(hl)
	call convertAngleToDirection
	add $04
	ld b,a
	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add b
	ld l,SpecialObject.animMode
	cp (hl)
	call nz,specialObjectSetAnimation
@ret:
	or d
	ret


;;
; State 6: talking to Link / moving toward an item
mapleState6:
	call mapleUpdateOscillation
	call specialObjectAnimate
	call retIfTextIsActive

	ld a,(wActiveMusic)
	cp MUS_MAPLE_GAME
	jr z,++
	ld a,MUS_MAPLE_GAME
	ld (wActiveMusic),a
	call playSound
++
	; Check whether to update Maple's angle toward an item
	ld l,SpecialObject.var3d
	ld a,(hl)
	ld l,SpecialObject.angle
	cp (hl)
	call nz,mapleUpdateAngle

	call mapleDecideItemToCollectAndUpdateTargetAngle
	call objectApplySpeed

	; Check if Maple's touching the target object
	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	ld l,a
	call checkObjectsCollided
	jp nc,mapleKeepInBounds

	; Set the item being collected to state 4
	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	or Object.state
	ld l,a
	ld (hl),$04 ; [Part.state] = $04
	inc l
	ld (hl),$00 ; [Part.substate] = $00

	; Read the item's var03 to determine how long it takes to collect.
	ld a,(de)
	or Object.var03
	ld l,a
	ld a,(hl)
	ld e,SpecialObject.stunCounter
	ld (de),a

	; Go to state 7
	ld e,SpecialObject.state
	ld a,$07
	ld (de),a

	; If maple's on her broom, she'll only do her sweeping animation if she's not in
	; a wall - otherwise, she'll just sort of sit there?
	ld e,SpecialObject.damage
	ld a,(de)
	or a
	call z,mapleFunc_6c27
	ret z

	add $16
	jp specialObjectSetAnimation


;;
; State 7: picking up an item
mapleState7:
	call specialObjectAnimate

	ld e,SpecialObject.damage
	ld a,(de)
	cp $01
	jp nz,@anyVehicle

; Maple is on the vacuum.
;
; The next bit of code deals with pulling a bomb object (an actual explosive one) toward
; maple. When it touches her, she will be momentarily stunned.

	; Adjust collisionRadiusY/X for the purpose of checking if a bomb object is close
	; enough to be sucked toward the vacuum.
	ld e,SpecialObject.collisionRadiusY
	ld a,$08
	ld (de),a
	inc e
	ld a,$0a
	ld (de),a

	; Check if there's an actual bomb (one that can explode) on-screen.
	call mapleFindUnexplodedBomb
	jr nz,+
	call checkObjectsCollided
	jr c,@explosiveBombNearMaple
+
	call mapleFindNextUnexplodedBomb
	jr nz,@updateItemBeingCollected
	call checkObjectsCollided
	jr c,@explosiveBombNearMaple

	ld e,SpecialObject.relatedObj1
	xor a
	ld (de),a
	inc e
	ld (de),a
	jr @updateItemBeingCollected

@explosiveBombNearMaple:
	; Constantly signal the bomb to reset its animation so it doesn't explode
	ld l,SpecialObject.var2f
	set 7,(hl)

	; Update the bomb's X and Y positions toward maple, and check if they've reached
	; her.
	ld b,$00
	ld l,Item.yh
	ld e,l
	ld a,(de)
	cp (hl)
	jr z,@updateBombX
	inc b
	jr c,+
	inc (hl)
	jr @updateBombX
+
	dec (hl)

@updateBombX:
	ld l,Item.xh
	ld e,l
	ld a,(de)
	cp (hl)
	jr z,++
	inc b
	jr c,+
	inc (hl)
	jr ++
+
	dec (hl)
++
	ld a,b
	or a
	jr nz,@updateItemBeingCollected

; The bomb has reached maple's Y/X position. Start pulling it up.

	; [Item.z] -= $0040
	ld l,Item.z
	ld a,(hl)
	sub $40
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	cp $f8
	jr nz,@updateItemBeingCollected

; The bomb has risen high enough. Maple will now be stunned.

	; Signal the bomb to delete itself
	ld l,SpecialObject.var2f
	set 5,(hl)

	ld a,$1a
	call specialObjectSetAnimation

	; Go to state 8
	ld h,d
	ld l,SpecialObject.state
	ld (hl),$08
	inc l
	ld (hl),$00 ; [substate] = 0

	ld l,SpecialObject.counter2
	ld (hl),$20

	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	ld l,a
	ld a,(hl)
	or a
	jr z,@updateItemBeingCollected

	; Release the other item Maple was pulling up
	ld a,(de)
	add Object.state
	ld l,a
	ld (hl),$01

	add Object.angle-Object.state
	ld l,a
	ld (hl),$80

	xor a
	ld e,SpecialObject.relatedObj2
	ld (de),a

; Done with bomb-pulling code. Below is standard vacuum cleaner code.

@updateItemBeingCollected:
	; Fix collision radius after the above code changed it for bomb detection
	ld e,SpecialObject.collisionRadiusY
	ld a,$02
	ld (de),a
	inc e
	ld a,$02
	ld (de),a

; Vacuum-exclusive code is done.

@anyVehicle:
	ld e,SpecialObject.relatedObj2
	ld a,(de)
	or a
	ret z
	ld h,a
	inc e
	ld a,(de)
	ld l,a

	ldi a,(hl)
	or a
	jr z,@itemCollected

	; Check bit 7 of item's subid?
	inc l
	bit 7,(hl)
	jr nz,@itemCollected

	; Check if they've collided (the part object writes to maple's "damageToApply"?)
	ld e,SpecialObject.damageToApply
	ld a,(de)
	or a
	ret z

	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	ld l,Part.var03
	ld a,$80
	ld (hl),a

	xor a
	ld l,Part.invincibilityCounter
	ld (hl),a
	ld l,Part.collisionType
	ld (hl),a

	ld e,SpecialObject.stunCounter
	ld a,(de)
	ld hl,mapleItemValues
	rst_addAToHl
	ld a,$0e
	ld (de),a

	ld e,SpecialObject.health
	ld a,(de)
	ld b,a
	ld a,(hl)
	add b
	ld (de),a

	; If maple's on a broom, go to state $0a (dusting animation); otherwise go back to
	; state $06 (start heading toward the next item)
	ld e,SpecialObject.damage
	ld a,(de)
	or a
	jr nz,@itemCollected

	ld a,$0a
	jr @setState

@itemCollected:
	; Return if Maple's still pulling up a real bomb
	ld h,d
	ld l,SpecialObject.relatedObj1
	ldi a,(hl)
	or (hl)
	ret nz

	ld a,$06
@setState:
	ld e,SpecialObject.state
	ld (de),a

	; Update direction with target direction. (I don't think this has been updated? So
	; she'll still be moving in the direction she was headed to reach this item.)
	ld e,SpecialObject.var3d
	ld a,(de)
	ld e,SpecialObject.angle
	ld (de),a
	ret

;;
; State A: Maple doing her dusting animation after getting an item (broom only)
mapleStateA:
	call specialObjectAnimate
	call itemDecCounter2
	ret nz

	ld l,SpecialObject.state
	ld (hl),$06

	; [zh] = [direction]. ???
	ld l,SpecialObject.direction
	ld a,(hl)
	ld l,SpecialObject.zh
	ld (hl),a

	ld a,$04
	jp specialObjectSetAnimation

;;
; State 8: stunned from a bomb
mapleState8:
	call specialObjectAnimate
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemDecCounter2
	ret nz

	ld l,SpecialObject.substate
	ld (hl),$01

	ld l,SpecialObject.speedZ
	xor a
	ldi (hl),a
	ld (hl),a

	ld a,$13
	jp specialObjectSetAnimation

@substate1:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,SpecialObject.substate
	ld (hl),$02
	ld l,SpecialObject.counter2
	ld (hl),$40
	ret

@substate2:
	call itemDecCounter2
	ret nz

	ld l,SpecialObject.substate
	ld (hl),$03
	ld a,$08
	jp specialObjectSetAnimation

@substate3:
	ld h,d
	ld l,SpecialObject.zh
	dec (hl)
	ld a,(hl)
	cp $e9
	ret nc

	; Go back to state 6 (moving toward next item)
	ld l,SpecialObject.state
	ld (hl),$06

	ld l,SpecialObject.health
	inc (hl)

	ld l,SpecialObject.speedZ
	ld a,$40
	ldi (hl),a
	ld (hl),$00

	jp mapleDecideItemToCollectAndUpdateTargetAngle

;;
; State 9: flying away after item collection is over
mapleState9:
	call specialObjectAnimate
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Substate 0: display text
@substate0:
	call retIfTextIsActive

	ld a,$3c
	ld (wInstrumentsDisabledCounter),a

	ld a,$01
	ld (de),a ; [substate] = $01

	; "health" is maple's obtained value, and "var2a" is Link's obtained value.

	; Check if either of them got anything
	ld h,d
	ld l,SpecialObject.health
	ldi a,(hl)
	ld b,a
	or (hl) ; hl = SpecialObject.var2a
	jr z,@showText

	; Check for draw, or maple got more, or link got more
	ld a,(hl)
	cp b
	ld a,$01
	jr z,@showText
	inc a
	jr c,@showText
	inc a

@showText:
	ld hl,@textIndices
	rst_addDoubleIndex
	ld c,(hl)
	inc hl
	ld b,(hl)
	call showText

	call mapleGetCardinalAngleTowardLink
	call convertAngleToDirection
	add $04
	ld b,a
	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add b
	jp specialObjectSetAnimation

@textIndices:
	.dw TX_070c ; 0: nothing obtained by maple or link
	.dw TX_0708 ; 1: draw
	.dw TX_0706 ; 2: maple got more
	.dw TX_0707 ; 3: link got more


; Substate 1: wait until textbox is closed
@substate1:
	call mapleUpdateOscillation
	call retIfTextIsActive

	ld a,$80
	ld (wTextIsActive),a
	ld a,$1f
	ld (wDisabledObjects),a

	ld l,SpecialObject.angle
	ld (hl),$18
	ld l,SpecialObject.speed
	ld (hl),SPEED_300

	ld l,SpecialObject.substate
	ld (hl),$02

	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add $07
	jp specialObjectSetAnimation


; Substate 2: moving until off screen
@substate2:
	call mapleUpdateOscillation
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c

;;
; Increments meeting counter, deletes maple, etc.
mapleEndEncounter:
	xor a
	ld (wTextIsActive),a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wDisableScreenTransitions),a
	call mapleIncrementMeetingCounter

	; Fall through

;;
mapleDeleteSelf:
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	pop af
	xor a
	ld (wIsMaplePresent),a
	jp itemDelete


;;
; State B: exchanging touching book
mapleStateB:
	inc e
	ld a,(de) ; a = [substate]
	or a
	jr nz,@substate1

@substate0:
	call mapleUpdateOscillation
.ifdef ROM_AGES
	ld e,SpecialObject.direction
	ld a,(de)
	bit 7,a
	jr z,+
	and $03
	jr @determineAnimation
+
.endif

	call objectGetAngleTowardLink
	call convertAngleToDirection
	ld h,d
	ld l,SpecialObject.direction
	cp (hl)
	ld (hl),a
	jr z,@waitForText

@determineAnimation:
	add $04
	ld b,a
	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add b
	call specialObjectSetAnimation

@waitForText:
	call retIfTextIsActive

	ld hl,wMapleState
	set 5,(hl)
	ld e,SpecialObject.angle
	ld a,(de)
	rlca
	jp nc,objectApplySpeed
	ret

@substate1:
	dec a
	ld (de),a ; [substate] -= 1
	ret nz

.ifdef ROM_AGES
	ld bc,TX_0711
.else
	ld bc,TX_070b
.endif
	call showText
	ld e,SpecialObject.angle
	ld a,$18
	ld (de),a

	; Go to state $0c
	call itemIncState

	ld l,SpecialObject.speed
	ld (hl),SPEED_300

	; Fall through

;;
; State C: leaving after reading touching book
mapleStateC:
	call mapleUpdateOscillation
	call retIfTextIsActive

	call objectApplySpeed

	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add $07
	ld hl,wMapleState
	bit 4,(hl)
	res 4,(hl)
	call nz,specialObjectSetAnimation

	call objectCheckWithinScreenBoundary
	ret c
	jp mapleEndEncounter


;;
; Adjusts Maple's X and Y position to keep them in-bounds.
mapleKeepInBounds:
	ld e,SpecialObject.yh
	ld a,(de)
	cp $f0
	jr c,+
	xor a
+
	cp $20
	jr nc,++
	ld a,$20
	ld (de),a
	jr @checkX
++
	cp SCREEN_HEIGHT*16 - 8
	jr c,@checkX
	ld a,SCREEN_HEIGHT*16 - 8
	ld (de),a

@checkX:
	ld e,SpecialObject.xh
	ld a,(de)
	cp $f0
	jr c,+
	xor a
+
	cp $08
	jr nc,++
	ld a,$08
	ld (de),a
	jr @ret
++
	cp SCREEN_WIDTH*16 - 8
	jr c,@ret
	ld a,SCREEN_WIDTH*16 - 8
	ld (de),a
@ret:
	ret


;;
mapleSpawnItemDrops:
	; Check if Link has the touching book
	ld a,TREASURE_TRADEITEM
	call checkTreasureObtained
	jr nc,@noTradeItem
.ifdef ROM_AGES
	cp $08
.else
	cp $01
.endif
	jr nz,@noTradeItem

.ifdef ROM_AGES
	ld b,INTERACID_TOUCHING_BOOK
.else
	ld b,INTERACID_GHASTLY_DOLL
.endif
	call objectCreateInteractionWithSubid00
	ret nz
	ld hl,wMapleState
	set 4,(hl)
	ret

@noTradeItem:
	; Clear health and var2a (the total value of the items Maple and Link have
	; collected, respectively)
	ld e,SpecialObject.var2a
	xor a
	ld (de),a
	ld e,SpecialObject.health
	ld (de),a

; Spawn 5 items from Maple

	ld e,SpecialObject.counter1
	ld a,$05
	ld (de),a

@nextMapleItem:
	ld e,SpecialObject.var03 ; If var03 is 0, rarer items will be dropped
	ld a,(de)
	ld hl,maple_itemDropDistributionTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call getRandomIndexFromProbabilityDistribution

	ld a,b
	call @checkSpawnItem
	jr c,+
	jr nz,@nextMapleItem
+
	ld e,SpecialObject.counter1
	ld a,(de)
	dec a
	ld (de),a
	jr nz,@nextMapleItem

; Spawn 5 items from Link

	; hFF8C acts as a "drop attempt" counter. It's possible that Link will run out of
	; things to drop, so it'll stop trying eventually.
	ld a,$20
	ldh (<hFF8C),a

	ld e,SpecialObject.counter1
	ld a,$05
	ld (de),a

@nextLinkItem:
	ldh a,(<hFF8C)
	dec a
	ldh (<hFF8C),a
	jr z,@ret

	ld hl,maple_linkItemDropDistribution
	call getRandomIndexFromProbabilityDistribution

	call mapleCheckLinkCanDropItem
	jr z,@nextLinkItem

	ld d,>w1Link
	call mapleSpawnItemDrop

	ld d,>w1Companion
	ld e,SpecialObject.counter1
	ld a,(de)
	dec a
	ld (de),a
	jr nz,@nextLinkItem
@ret:
	ret

;;
; @param	a	Index of item to drop
; @param[out]	cflag	Set if it's ok to drop this item
; @param[out]	zflag
@checkSpawnItem:
	; Check that Link has obtained the item (if applicable)
	push af
	ld hl,mapleItemDropTreasureIndices
	rst_addAToHl
	ld a,(hl)
	call checkTreasureObtained
	pop hl
	jr c,@obtained
	or d
	ret

@obtained:
	ld a,h
	ldh (<hFF8B),a

	; Skip the below conditions for all items of index 5 or above (items that can be
	; dropped multiple times)
	cp $05
	jp nc,mapleSpawnItemDrop

	; If this is the heart piece, only drop it if it hasn't been obtained yet
	or a
	jr nz,@notHeartPiece
	ld a,(wMapleState)
	bit 7,a
	ret nz
	ld e,SpecialObject.invincibilityCounter
	ld a,(de)
	or a
	ret nz

	inc a
	ld (de),a
	jr @spawnItem

@notHeartPiece:
	dec a
	ld hl,@itemBitmasks
	rst_addAToHl
	ld b,(hl)
	ld e,SpecialObject.knockbackAngle
	ld a,(de)
	and b
	ret nz
	ld a,(de)
	or b
	ld (de),a

@spawnItem:
	jr mapleSpawnItemDrop_variant


; Bitmasks for items 1-5 for remembering if one's spawned already
@itemBitmasks:
	.db $04 $02 $02 $01


; The following are probability distributions for maple's dropped items. The sum of the
; numbers in each distribution should be exactly $100. An item with a higher number has
; a higher chance of dropping.

maple_itemDropDistributionTable: ; Probabilities that Maple will drop something
	.dw @rareItems
	.dw @standardItems

@rareItems:
	.db $14 $0e $0e $1e $20 $00 $00 $00
	.db $00 $00 $28 $2e $28 $14

@standardItems:
	.db $00 $02 $04 $08 $0a $00 $00 $00
	.db $00 $00 $32 $34 $3c $46


maple_linkItemDropDistribution: ; Probabilities that Link will drop something
	.db $00 $00 $00 $00 $00 $20 $20 $20
	.db $20 $20 $20 $20 $00 $20


; Each byte is the "value" of an item. The values of the items Link and Maple pick up are
; added up and totalled to see who "won" the encounter.
mapleItemValues:
	.db $3c $0f $0a $08 $06 $05 $05 $05
	.db $05 $05 $04 $03 $02 $01 $00


; Given an index of an item drop, the corresponding value in the table below is a treasure
; to check if Link's obtained in order to allow Maple to drop it. "TREASURE_PUNCH" is
; always considered obtained, so it's used as a value to mean "always drop this".
;
; Item indices:
;  $00: heart piece
;  $01: gasha seed
;  $02: ring
;  $03: ring (different class?)
;  $04: potion
;  $05: ember seeds
;  $06: scent seeds
;  $07: pegasus seeds
;  $08: gale seeds
;  $09: mystery seeds
;  $0a: bombs
;  $0b: heart
;  $0c: 5 rupees
;  $0d: 1 rupee

mapleItemDropTreasureIndices:
	.db TREASURE_PUNCH      TREASURE_PUNCH         TREASURE_PUNCH       TREASURE_PUNCH
	.db TREASURE_PUNCH      TREASURE_EMBER_SEEDS   TREASURE_SCENT_SEEDS TREASURE_PEGASUS_SEEDS
	.db TREASURE_GALE_SEEDS TREASURE_MYSTERY_SEEDS TREASURE_BOMBS       TREASURE_PUNCH
	.db TREASURE_PUNCH      TREASURE_PUNCH

;;
; @param	d	Object it comes from (Link or Maple)
; @param	hFF8B	Value for part's subid and var03 (item type?)
mapleSpawnItemDrop:
	call getFreePartSlot
	scf
	ret nz
	ld (hl),PARTID_ITEM_FROM_MAPLE
	ld e,SpecialObject.yh
	call objectCopyPosition_rawAddress
	ldh a,(<hFF8B)
	ld l,Part.var03
	ldd (hl),a ; [var03] = [hFF8B]
	ld (hl),a  ; [subid] = [hFF8B]
	xor a
	ret

;;
; @param	d	Object it comes from (Link or Maple)
; @param	hFF8B	Value for part's subid and var03 (item type?)
mapleSpawnItemDrop_variant:
	call getFreePartSlot
	scf
	ret nz
	ld (hl),PARTID_ITEM_FROM_MAPLE_2
	ld l,Part.subid
	ldh a,(<hFF8B)
	ldi (hl),a
	ld (hl),a
	call objectCopyPosition
	or a
	ret

;;
; Decides what Maple's next item target should be.
;
; @param[out]	hl	The part object to go for
; @param[out]	zflag	nz if there are no items left
mapleDecideItemToCollect:

; Search for item IDs 0-4 first

	ld b,$00

@idLoop1
	ldhl FIRST_PART_INDEX, Part.enabled

@partLoop1:
	ld l,Part.enabled
	ldi a,(hl)
	or a
	jr z,@nextPart1

	ldi a,(hl)
	cp PARTID_ITEM_FROM_MAPLE_2
	jr nz,@nextPart1

	ldd a,(hl)
	cp b
	jr nz,@nextPart1

	; Found an item to go for
	dec l
	xor a
	ret

@nextPart1:
	inc h
	ld a,h
	cp LAST_PART_INDEX+1
	jr c,@partLoop1

	inc b
	ld a,b
	cp $05
	jr c,@idLoop1

; Now search for item IDs $05-$0d

	xor a
	ld c,$00
	ld hl,@itemIDs
	rst_addAToHl
	ld a,(hl)
	ld b,a
	xor a
	ldh (<hFF91),a

@idLoop2:
	ldhl FIRST_PART_INDEX, Part.enabled

@partLoop2:
	ld l,Part.enabled
	ldi a,(hl)
	or a
	jr z,@nextPart2

	ldi a,(hl)
	cp PARTID_ITEM_FROM_MAPLE
	jr nz,@nextPart2

	ldd a,(hl)
	cp b
	jr nz,@nextPart2

; We've found an item to go for. However, we'll only pick this one if it's closest of its
; type. Start by calculating maple's distance from it.

	ld l,Part.yh
	ld l,(hl)
	ld e,SpecialObject.yh
	ld a,(de)
	sub l
	jr nc,+
	cpl
	inc a
+
	ldh (<hFF8C),a
	ld l,Part.xh
	ld l,(hl)
	ld e,SpecialObject.xh
	ld a,(de)
	sub l
	jr nc,+
	cpl
	inc a
+
	ld l,a
	ldh a,(<hFF8C)
	add l
	ld l,a

; l now contains the distance to the item. Check if it's less than the closest item's
; distance (stored in hFF8D), or if this is the first such item (index stored in hFF91).

	ldh a,(<hFF91)
	or a
	jr z,++
	ldh a,(<hFF8D)
	cp l
	jr c,@nextPart2
++
	ld a,l
	ldh (<hFF8D),a
	ld a,h
	ldh (<hFF91),a

@nextPart2:
	inc h
	ld a,h
	cp $e0
	jr c,@partLoop2

	; If we found an item of this type, return.
	ldh a,(<hFF91)
	or a
	jr nz,@foundItem

	; Otherwise, try the next item type.
	inc c
	ld a,c
	cp $09
	jr nc,@noItemsLeft

	ld hl,@itemIDs
	rst_addAToHl
	ld a,(hl)
	ld b,a
	jr @idLoop2

@noItemsLeft:
	; This will unset the zflag, since a=$09 and d=$d1... but they probably meant to
	; write "or d" to produce that effect. (That's what they normally do.)
	and d
	ret

@foundItem:
	ld h,a
	ld l,Part.enabled
	xor a
	ret

@itemIDs:
	.db $05 $06 $07 $08 $09 $0a $0b $0c
	.db $0d


;;
; Searches for a bomb item (an actual bomb that will explode). If one exists, and isn't
; currently exploding, it gets set as Maple's relatedObj1.
;
; @param[out]	zflag	z if the first bomb object found was suitable
mapleFindUnexplodedBomb:
	ld e,SpecialObject.relatedObj1
	xor a
	ld (de),a
	inc e
	ld (de),a
	ld c,ITEMID_BOMB
	call findItemWithID
	ret nz
	jr ++

;;
; This is similar to above, except it's a "continuation" in case the first bomb that was
; found was unsuitable (in the process of exploding).
;
mapleFindNextUnexplodedBomb:
	ld c,ITEMID_BOMB
	call findItemWithID_startingAfterH
	ret nz
++
	ld l,Item.var2f
	ld a,(hl)
	bit 7,a
	jr nz,++
	and $60
	ret nz
	ld l,Item.zh
	bit 7,(hl)
	ret nz
++
	ld e,SpecialObject.relatedObj1
	ld a,h
	ld (de),a
	inc e
	xor a
	ld (de),a
	ret

;;
mapleInitZPositionAndSpeed:
	ld h,d
	ld l,SpecialObject.zh
	ld a,$f8
	ldi (hl),a

	ld l,SpecialObject.speedZ
	ld (hl),$40
	inc l
	ld (hl),$00

	ld l,SpecialObject.var3c
	ld a,$16
	ldi (hl),a
	ret

;;
; @param[out]	a	Angle toward link (rounded to cardinal direction)
mapleGetCardinalAngleTowardLink:
	call objectGetAngleTowardLink
	and $18
	ret

;;
; Decides what item Maple should go for, and updates var3d appropriately (the angle she's
; turning toward).
;
; If there are no more items, this sets Maple's state to $09.
;
mapleDecideItemToCollectAndUpdateTargetAngle:
	call mapleDecideItemToCollect
	jr nz,@noMoreItems

	ld e,SpecialObject.relatedObj2
	ld a,h
	ld (de),a
	inc e
	ld a,l
	ld (de),a
	ld e,SpecialObject.damageToApply
	xor a
	ld (de),a
	jr mapleSetTargetDirectionToRelatedObj2

@noMoreItems:
	ld e,SpecialObject.state
	ld a,$09
	ld (de),a
	inc e
	xor a
	ld (de),a ; [substate] = 0
	ret

;;
mapleSetTargetDirectionToRelatedObj2:
	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	or Object.yh
	ld l,a

	ldi a,(hl)
	ld b,a
	inc l
	ld a,(hl)
	ld c,a
	call objectGetRelativeAngle
	ld e,SpecialObject.var3d
	ld (de),a
	ret

;;
; Checks if Link can drop an item in Maple's minigame, and removes the item amount from
; his inventory if he can.
;
; This function is bugged. The programmers mixed up the "treasure indices" with maple's
; item indices. As a result, the incorrect treasures are checked to be obtained; for
; example, pegasus seeds check that Link has obtained the rod of seasons. This means
; pegasus seeds will never drop in Ages. Similarly, gale seeds check the magnet gloves.
;
; @param	b	The item to drop
; @param[out]	hFF8B	The "maple item index" of the item to be dropped
; @param[out]	zflag	nz if Link can drop it
mapleCheckLinkCanDropItem:
	ld a,b
	sub $05
	ld b,a
	rst_jumpTable
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @bombs
	.dw @heart
	.dw @heart ; This should be 5 rupees, but Link never drops that.
	.dw @oneRupee

@oneRupee:
	ld hl,wNumRupees
	ldi a,(hl)
	or (hl)
	ret z
	ld a,$01
	call removeRupeeValue
	ld a,$0c
	jr @setMapleItemIndex

@bombs:
	; $0a corresponds to bombs in maple's treasure indices, but for the purpose of the
	; "checkTreasureObtained" call, it actually corresponds to "TREASURE_SWITCH_HOOK"!
	ld a,$0a
	ldh (<hFF8B),a
	call checkTreasureObtained
	jr nc,@cannotDrop

	ld hl,wNumBombs
	ld a,(hl)
	sub $04
	jr c,@cannotDrop
	daa
	ld (hl),a
	call setStatusBarNeedsRefreshBit1
	or d
	ret

@seed:
	; BUG: For the purpose of "checkTreasureObtained", the treasure index will be very
	; wrong.
	;   Ember seed:   TREASURE_SWORD
	;   Scent seed:   TREASURE_BOOMERANG
	;   Pegasus seed: TREASURE_ROD_OF_SEASONS
	;   Gale seed:    TREASURE_MAGNET_GLOVES
	;   Mystery seed: TREASURE_SWITCH_HOOK_HELPER
	ld a,b
	add $05
	ldh (<hFF8B),a
	call checkTreasureObtained
	jr nc,@cannotDrop

	; See if we can remove 5 of the seed type from the inventory
	ld a,b
	ld hl,wNumEmberSeeds
	rst_addAToHl
	ld a,(hl)
	sub $05
	jr c,@cannotDrop
	daa
	ld (hl),a

	call setStatusBarNeedsRefreshBit1
	or d
	ret

@cannotDrop:
	xor a
	ret

@heart:
	ld hl,wLinkHealth
	ld a,(hl)
	cp 12 ; Check for at least 3 hearts
	jr nc,+
	xor a
	ret
+
	sub $04
	ld (hl),a

	ld hl,wStatusBarNeedsRefresh
	set 2,(hl)

	ld a,$0b

@setMapleItemIndex:
	ldh (<hFF8B),a
	or d
	ret

;;
; @param[out]	a	Maple.damage variable (actually vehicle type)
; @param[out]	zflag	z if Maple's in a wall? (she won't do her sweeping animation)
mapleFunc_6c27:
	ld e,SpecialObject.counter2
	ld a,$30
	ld (de),a

	; [direction] = [zh]. ???
	ld e,SpecialObject.zh
	ld a,(de)
	ld e,SpecialObject.direction
	ld (de),a

	call objectGetTileCollisions
	jr nz,@collision
	ld e,SpecialObject.zh
	xor a
	ld (de),a
	or d
	ld e,SpecialObject.damage
	ld a,(de)
	ret
@collision:
	xor a
	ret

;;
; Increments lower 4 bits of wMapleState (the number of times Maple has been met)
mapleIncrementMeetingCounter:
	ld hl,wMapleState
	ld a,(hl)
	and $0f
	ld b,a
	cp $0f
	jr nc,+
	inc b
+
	xor (hl)
	or b
	ld (hl),a
	ret


; These are the possible paths Maple can take when you just see her shadow.
mapleShadowPathsTable:
	.dw @rareItemDrops
	.dw @standardItemDrops

; Data format:
;   First byte is the delay it takes to change angles. (Higher values make larger arcs.)
;   Each subsequent row is:
;     b0: target angle
;     b1: number of frames to move in that direction (not counting time it takes to turn)
@rareItemDrops:
	.db $02
	.db $18 $64
	.db $10 $02
	.db $08 $1e
	.db $10 $02
	.db $18 $7a
	.db $ff $ff

@standardItemDrops:
	.db $04
	.db $18 $64
	.db $10 $04
	.db $08 $64
	.db $ff $ff


; Maps a number to an index for the table below. At first, only the first 4 bytes are read
; at random from this table, but as maple is encountered more, the subsequent bytes are
; read, giving maple more variety in the way she moves.
mapleMovementPatternIndices:
	.db $00 $01 $02 $00 $03 $04 $05 $03
	.db $06 $07 $01 $02 $04 $05 $06 $07

mapleMovementPatternTable:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3
	.dw @pattern4
	.dw @pattern5
	.dw @pattern6
	.dw @pattern7

; Data format:
;   First row is the Y/X position for Maple to start at.
;   Second row is one byte for the delay it takes to change angles.
;   Each subsequent row is:
;     b0: target angle
;     b1: number of frames to move in that direction (not counting time it takes to turn)
@pattern0:
	.db $18 $b8
	.db $02
	.db $18 $4b
	.db $10 $01
	.db $08 $32
	.db $10 $01
	.db $18 $46
	.db $ff $ff

@pattern1:
	.db $70 $b8
	.db $02
	.db $18 $4b
	.db $00 $01
	.db $08 $32
	.db $00 $01
	.db $18 $46
	.db $ff $ff

@pattern2:
	.db $18 $f0
	.db $02
	.db $08 $46
	.db $10 $19
	.db $18 $28
	.db $00 $14
	.db $08 $19
	.db $10 $0f
	.db $18 $14
	.db $00 $0a
	.db $08 $0f
	.db $10 $32
	.db $ff $ff

@pattern3:
	.db $a0 $90
	.db $02
	.db $00 $37
	.db $18 $01
	.db $10 $19
	.db $18 $01
	.db $00 $19
	.db $18 $01
	.db $10 $3c
	.db $ff $ff

@pattern4:
	.db $a0 $10
	.db $02
	.db $00 $37
	.db $08 $01
	.db $10 $19
	.db $08 $01
	.db $00 $19
	.db $08 $01
	.db $10 $3c
	.db $ff $ff

@pattern5:
	.db $18 $f0
	.db $01
	.db $08 $28
	.db $16 $0f
	.db $08 $2d
	.db $16 $0a
	.db $08 $37
	.db $ff $ff

@pattern6:
	.db $f0 $30
	.db $02
	.db $14 $19
	.db $05 $11
	.db $14 $0a
	.db $17 $05
	.db $10 $01
	.db $05 $1e
	.db $14 $1e
	.db $ff $ff

@pattern7:
	.db $f0 $70
	.db $02
	.db $0c $19
	.db $1b $11
	.db $0c $08
	.db $0a $02
	.db $10 $01
	.db $1b $0f
	.db $0c $1e
	.db $ff $ff



;;
specialObjectCode_ricky:
	call companionRetIfInactive
	call companionFunc_47d8
	call @runState
	jp companionCheckEnableTerrainEffects

@runState:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw rickyState0
	.dw rickyState1
	.dw rickyState2
	.dw rickyState3
	.dw rickyState4
	.dw rickyState5
	.dw rickyState6
	.dw rickyState7
	.dw rickyState8
	.dw rickyState9
	.dw rickyStateA
	.dw rickyStateB
	.dw rickyStateC

;;
; State 0: initialization
rickyState0:
rickyStateB:
	call companionCheckCanSpawn ; This may return

	ld a,$06
	call objectSetCollideRadius

	ld a,DIR_DOWN
	ld l,SpecialObject.direction
	ldi (hl),a
	ld (hl),a ; [angle] = $02

	ld l,SpecialObject.var39
	ld (hl),$10
	ld a,(wRickyState)

.ifdef ROM_AGES
	bit 7,a
	jr nz,@setAnimation17

	ld c,$17
	bit 6,a
	jr nz,@canTalkToRicky

	and $20
	jr nz,@setAnimation17

	ld c,$00
.else
	and $80
	jr nz,@setAnimation17
.endif

@canTalkToRicky:
	; Ricky not ridable yet, can press A to talk to him
	ld l,SpecialObject.state
	ld (hl),$0a
	ld e,SpecialObject.var3d
	call objectAddToAButtonSensitiveObjectList
.ifdef ROM_AGES
	ld a,c
.else
	ld a,$00
.endif
	jr @setAnimation

@setAnimation17:
	ld a,$17

@setAnimation:
	call specialObjectSetAnimation
	jp objectSetVisiblec1

;;
; State 1: waiting for Link to mount
rickyState1:
	call specialObjectAnimate
	call companionSetPriorityRelativeToLink

	ld c,$09
	call objectCheckLinkWithinDistance
	jr nc,@didntMount

	call companionTryToMount
	ret z

@didntMount:
	; Make Ricky hop every once in a while
	ld e,SpecialObject.animParameter
	ld a,(de)
	and $c0
	jr z,rickyCheckHazards
	rlca
	ld c,$40
	jp nc,objectUpdateSpeedZ_paramC
	ld bc,$ff00
	call objectSetSpeedZ

;;
rickyCheckHazards:
	call companionCheckHazards
	jp c,rickyFunc_70cc

;;
rickyState9:
	ret

;;
; State 2: Jumping up a cliff
rickyState2:
	call companionDecCounter1
	jr z,++
	dec (hl)
	ret nz
	ld a,SND_RICKY
	call playSound
++
	ld c,$40
	call objectUpdateSpeedZ_paramC
	call specialObjectAnimate
	call objectApplySpeed

	call companionCalculateAdjacentWallsBitset

	; Check whether Ricky's passed through any walls?
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $0f
	ld e,SpecialObject.counter2
	jr z,+
	ld (de),a
	ret
+
	ld a,(de)
	or a
	ret z
	jp rickyStopUntilLandedOnGround

;;
; State 3: Link is currently jumping up to mount Ricky
rickyState3:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	call companionCheckMountingComplete
	ret nz

	call companionFinalizeMounting
	ld a,SND_RICKY
	call playSound
	ld c,$20
	jp companionSetAnimation

;;
; State 4: Ricky falling into a hazard (hole/water)
rickyState4:
	ld e,SpecialObject.var37
	ld a,(de)
	cp $0e ; Is this water?
	jr z,++

	; For any other value of var37, assume it's a hole ($0d).
	ld a,$0d
	ld (de),a
	call companionDragToCenterOfHole
	ret nz
++
	call companionDecCounter1
	jr nz,@animate

	inc (hl)
	ld e,SpecialObject.var37
	ld a,(de)
	call specialObjectSetAnimation

	ld e,SpecialObject.var37
	ld a,(de)
	cp $0e ; Is this water?
	jr z,@animate
	ld a,SND_LINK_FALL
	jp playSound

@animate:
	call companionAnimateDrowningOrFallingThenRespawn
	ret nc

	; Decide animation depending whether Link is riding Ricky
	ld c,$01
	ld a,(wLinkObjectIndex)
	rrca
	jr nc,+
	ld c,$05
+
	jp companionUpdateDirectionAndSetAnimation

;;
; State 5: Link riding Ricky.
;
; (Note: this may be called from state C?)
;
rickyState5:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw rickyState5Substate0
	.dw rickyState5Substate1
	.dw rickyState5Substate2
	.dw rickyState5Substate3

;;
; Substate 0: moving (not hopping)
rickyState5Substate0:
	ld a,(wForceCompanionDismount)
	or a
	jr nz,++

	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jp nz,rickyStartPunch

	bit BTN_BIT_B,a
++
	jp nz,companionGotoDismountState

	; Copy Link's angle (calculated from input buttons) to companion's angle
	ld h,d
	ld a,(wLinkAngle)
	ld l,SpecialObject.angle
	ld (hl),a

	; If not moving, set var39 to $10 (counter until Ricky hops)
	rlca
	ld l,SpecialObject.var39
	jr nc,@moving
	ld a,$10
	ld (hl),a

	ld c,$20
	call companionSetAnimation
	jp rickyCheckHazards

@moving:
	; Check if the "jump countdown" has reached zero
	ld l,SpecialObject.var39
	ld a,(hl)
	or a
	jr z,@tryToJump

	dec (hl) ; [var39]-=1

	ld l,SpecialObject.speed
	ld (hl),SPEED_c0

	ld c,$20
	call companionUpdateDirectionAndAnimate
	call rickyCheckForHoleInFront
	jp z,rickyBeginJumpOverHole

	call companionCheckHopDownCliff
	jr nz,+
	jp rickySetJumpSpeed
+
	call rickyCheckHopUpCliff
	jr nz,+
	jp rickySetJumpSpeed_andcc91
+
	call companionUpdateMovement
	jp rickyCheckHazards

; "Jump timer" has reached zero; make him jump (either from movement, over a hole, or up
; or down a cliff).
@tryToJump:
	ld h,d
	ld l,SpecialObject.angle
	ldd a,(hl)
	add a
	swap a
	and $03
	ldi (hl),a
	call rickySetJumpSpeed_andcc91

	; If he's moving left or right, skip the up/down cliff checks
	ld l,SpecialObject.angle
	ld a,(hl)
	bit 2,a
	jr nz,@jump

	call companionCheckHopDownCliff
	jr nz,++
	ld (wDisableScreenTransitions),a
	ld c,$0f
	jp companionSetAnimation
++
	call rickyCheckHopUpCliff
	ld c,$0f
	jp z,companionSetAnimation

@jump:
	; If there's a hole in front, try to jump over it
	ld e,SpecialObject.substate
	ld a,$02
	ld (de),a
	call rickyCheckForHoleInFront
	jp z,rickyBeginJumpOverHole

	; Otherwise, just do a normal hop
	ld bc,-$180
	call objectSetSpeedZ
	ld l,SpecialObject.substate
	ld (hl),$01
	ld l,SpecialObject.counter1
	ld (hl),$08
	ld l,SpecialObject.speed
	ld (hl),SPEED_200
	ld c,$19
	call companionSetAnimation

	call getRandomNumber
	and $0f
	ld a,SND_JUMP
	jr nz,+
	ld a,SND_RICKY
+
	jp playSound

;;
; Checks for holes for Ricky to jump over. Stores the tile 2 spaces away in var36.
;
; @param[out]	a	The tile directly in front of Ricky
; @param[out]	var36	The tile 2 spaces in front of Ricky
; @param[out]	zflag	Set if the tile in front of Ricky is a hole
rickyCheckForHoleInFront:
	; Make sure we're not moving diagonally
	ld a,(wLinkAngle)
	and $04
	ret nz

	ld e,SpecialObject.direction
	ld a,(de)
	ld hl,rickyHoleCheckOffsets
	rst_addDoubleIndex

	; Set b = y-position 2 tiles away, [hFF90] = y-position one tile away
	ld e,SpecialObject.yh
	ld a,(de)
	add (hl)
	ldh (<hFF90),a
	add (hl)
	ld b,a

	; Set c = x-position 2 tiles away, [hFF91] = x-position one tile away
	inc hl
	ld e,SpecialObject.xh
	ld a,(de)
	add (hl)
	ldh (<hFF91),a
	add (hl)
	ld c,a

	; Store in var36 the index of the tile 2 spaces away
	call getTileAtPosition
	ld a,l
	ld e,SpecialObject.var36
	ld (de),a

	ldh a,(<hFF90)
	ld b,a
	ldh a,(<hFF91)
	ld c,a
	call getTileAtPosition
	ld h,>wRoomLayout
	ld a,(hl)
	cp TILEINDEX_HOLE
	ret z
	cp TILEINDEX_FD
	ret

;;
; Substate 1: hopping during normal movement
rickyState5Substate1:
	dec e
	ld a,(de) ; Check [state]
	cp $05
	jr nz,@doneInputParsing

	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jp nz,rickyStartPunch

	; Check if we're attempting to move
	ld a,(wLinkAngle)
	bit 7,a
	jr nz,@doneInputParsing

	; Update direction based on wLinkAngle
	ld hl,w1Companion.direction
	ld b,a
	add a
	swap a
	and $03
	ldi (hl),a

	; Check if angle changed (and if animation needs updating)
	ld a,b
	cp (hl)
	ld (hl),a
	ld c,$19
	call nz,companionSetAnimation

@doneInputParsing:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@landed

	ld a,(wLinkObjectIndex)
	rra
	jr nc,++		; Check if Link's riding?
	ld a,(wLinkAngle)
	and $04
	jr nz,@updateMovement
++
	; If Ricky's facing a hole, don't move into it
	ld hl,rickyHoleCheckOffsets
	call specialObjectGetRelativeTileWithDirectionTable
	ld a,b
	cp TILEINDEX_HOLE
	ret z
	cp TILEINDEX_FD
	ret z

@updateMovement:
	jp companionUpdateMovement

@landed:
	call specialObjectAnimate
	call companionDecCounter1IfNonzero
	ret nz
	jp rickyStopUntilLandedOnGround

;;
; Substate 2: jumping over a hole
rickyState5Substate2:
	call companionDecCounter1
	jr z,++
	dec (hl)
	ret nz
	ld a,SND_RICKY
	call playSound
++
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jp z,rickyStopUntilLandedOnGround

	call specialObjectAnimate
	call companionUpdateMovement
	call specialObjectCheckMovingTowardWall
	jp nz,rickyStopUntilLandedOnGround
	ret

;;
; Substate 3: just landed on the ground (or waiting to land on the ground?)
rickyState5Substate3:
	; If he hasn't landed yet, do nothing until he does
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	call rickyBreakTilesOnLanding

	; Return to state 5, substate 0 (normal movement)
	xor a
	ld e,SpecialObject.substate
	ld (de),a

	jp rickyCheckHazards2

;;
; State 8: punching (substate 0) or charging tornado (substate 1)
rickyState8:
	ld e,$05
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

; Substate 0: punching
@substate0:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@onGround

	call companionUpdateMovement
	jr ++

@onGround:
	call companionTryToBreakTileFromMoving
	call rickyCheckHazards
++
	; Wait for the animation to signal something (play sound effect or start tornado
	; charging)
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	and $c0
	ret z

	rlca
	jr c,@startTornadoCharge

	ld a,SND_UNKNOWN5
	jp playSound

@startTornadoCharge:
	; Return if in midair
	ld e,SpecialObject.zh
	ld a,(de)
	or a
	ret nz

	; Check if let go of the button
	ld a,(wGameKeysPressed)
	and BTN_A
	jp z,rickyStopUntilLandedOnGround

	; Start tornado charging
	call itemIncSubstate
	ld c,$13
	call companionSetAnimation
	call companionCheckHazards
	ret nc
	jp rickyFunc_70cc

; Substate 1: charging tornado
@substate1:
	; Update facing direction
	ld a,(wLinkAngle)
	bit 7,a
	jr nz,++
	ld hl,w1Companion.angle
	cp (hl)
	ld (hl),a
	ld c,$13
	call nz,companionUpdateDirectionAndAnimate
++
	call specialObjectAnimate
	ld a,(wGameKeysPressed)
	and BTN_A
	jr z,@releasedAButton

	; Check if fully charged
	ld e,SpecialObject.var35
	ld a,(de)
	cp $1e
	jr nz,@continueCharging

	call companionTryToBreakTileFromMoving
	call rickyCheckHazards
	ld c,$04
	jp companionFlashFromChargingAnimation

@continueCharging:
	inc a
	ld (de),a ; [var35]++
	cp $1e
	ret nz
	ld a,SND_CHARGE_SWORD
	jp playSound

@releasedAButton:
	; Reset palette to normal
	ld hl,w1Link.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a

	ld e,SpecialObject.var35
	ld a,(de)
	cp $1e
	jr nz,@notCharged

	ldbc ITEMID_RICKY_TORNADO, $00
	call companionCreateItem

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_SWORDSPIN
	call playSound

	jr rickyStartPunch

@notCharged:
	ld c,$05
	jp companionSetAnimationAndGotoState5

;;
rickyStartPunch:
	ldbc ITEMID_28, $00
	call companionCreateWeaponItem
	ret nz
	ld h,d
	ld l,SpecialObject.state
	ld a,$08
	ldi (hl),a
	xor a
	ld (hl),a ; [substate] = 0

	inc a
	ld l,SpecialObject.var35
	ld (hl),a
	ld c,$09
	call companionSetAnimation
	ld a,SND_SWORDSLASH
	jp playSound

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
rickyState6:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	call companionDismountAndSavePosition
	ld a,$17
	jp specialObjectSetAnimation

@substate1:
	ld a,(wLinkInAir)
	or a
	ret nz
	jp itemIncSubstate

; Waiting for Link to get a certain distance away before allowing him to mount again
@substate2:
	call companionSetPriorityRelativeToLink

	ld c,$09
	call objectCheckLinkWithinDistance
	jp c,rickyCheckHazards

	; Link is far enough away; allow him to remount when he approaches again.
	ld e,SpecialObject.substate
	xor a
	ld (de),a ; [substate] = 0
	dec e
	inc a
	ld (de),a ; [state] = 1
	ret

;;
; State 7: Jumping down a cliff
rickyState7:
	call companionDecCounter1ToJumpDownCliff
	ret c

	call companionCalculateAdjacentWallsBitset
	call specialObjectCheckMovingAwayFromWall
	ld e,$07
	jr z,+
	ld (de),a
	ret
+
	ld a,(de)
	or a
	ret z

;;
; Sets ricky to state 5, substate 3 (do nothing until he lands, then continue normal
; movement)
rickyStopUntilLandedOnGround:
	ld a,(wLinkObjectIndex)
	rrca
	jr nc,+
	xor a
	ld (wLinkInAir),a
	ld (wDisableScreenTransitions),a
+
	ld a,$05
	ld e,SpecialObject.state
	ld (de),a
	ld a,$03
	ld e,SpecialObject.substate
	ld (de),a

	; If Ricky's close to the screen edge, set the "jump delay counter" back to $10 so
	; that he'll stay on the ground long enough for a screen transition to happen
	call rickyCheckAtScreenEdge
	jr z,rickyCheckHazards2
	ld e,SpecialObject.var39
	ld a,$10
	ld (de),a

;;
rickyCheckHazards2:
	call companionCheckHazards
	ld c,$20
	jp nc,companionSetAnimation

;;
; @param	a	Hazard type landed on
rickyFunc_70cc:
	ld c,$0e
	cp $01 ; Landed on water?
	jr z,+
	ld c,$0d
+
	ld h,d
	ld l,SpecialObject.var37
	ld (hl),c
	ld l,SpecialObject.counter1
	ld (hl),$00
	ret

;;
; State A: various cutscene-related things? Behaviour is controlled by "var03" instead of
; "substate".
rickyStateA:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw rickyStateASubstate0
	.dw rickyStateASubstate1
	.dw rickyStateASubstate2
	.dw rickyStateASubstate3
	.dw rickyStateASubstate4
	.dw rickyStateASubstate5
	.dw rickyStateASubstate6
	.dw rickyStateASubstate7
.ifdef ROM_SEASONS
	.dw rickyStateASubstate8
	.dw rickyStateASubstate9
	.dw rickyStateASubstateA
	.dw rickyStateASubstateB
	.dw rickyStateASubstateC
.endif

;;
; Standing around doing nothing?
rickyStateASubstate0:
	call companionPreventLinkFromPassing_noExtraChecks
	call companionSetPriorityRelativeToLink
	call specialObjectAnimate
	ld e,$21
	ld a,(de)
	rlca
	ld c,$40
	jp nc,objectUpdateSpeedZ_paramC
	ld bc,-$100
	jp objectSetSpeedZ

;;
; Force Link to mount
rickyStateASubstate1:
	ld e,SpecialObject.var3d
	call objectRemoveFromAButtonSensitiveObjectList
	jp companionForceMount

.ifdef ROM_AGES
;;
; Ricky leaving upon meeting Tingle (part 1: print text)
rickyStateASubstate2:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	ld bc,TX_2006
	call showText

	ld hl,w1Link.yh
	ld e,SpecialObject.yh
	ld a,(de)
	cp (hl)
	ld a,$02
	jr c,+
	ld a,$00
+
	ld e,SpecialObject.direction
	ld (de),a
	ld a,$03
	ld e,SpecialObject.var3f
	ld (de),a
	call specialObjectSetAnimation
	call rickyIncVar03
	jr rickySetJumpSpeedForCutscene
.else
rickyStateASubstate2:
	ld a,$01
	ld (wDisabledObjects),a
	ld a,DIR_UP
	ld e,SpecialObject.direction
	ld (de),a
	ld a,$05
	ld e,SpecialObject.var3f
	ld (de),a
	call rickyIncVar03
.endif

;;
rickySetJumpSpeedForCutsceneAndSetAngle:
	ld b,$30
	ld c,$58
	call objectGetRelativeAngle
	and $1c
	ld e,SpecialObject.angle
	ld (de),a

;;
rickySetJumpSpeedForCutscene:
	ld bc,-$180
	call objectSetSpeedZ
	ld l,SpecialObject.substate
	ld (hl),$01
	ld l,SpecialObject.speed
	ld (hl),SPEED_200
	ld l,SpecialObject.counter1
	ld (hl),$08
	ret

.ifdef ROM_AGES
;;
; Ricky leaving upon meeting Tingle (part 5: punching the air)
rickyStateASubstate6:
	; Wait for animation to give signals to play sound, start moving away.
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	or a
	ld a,SND_RICKY
	jp z,playSound

	ld a,(de)
	rlca
	ret nc

	; Start moving away
	call rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.angle
	ld a,$10
	ld (de),a

	ld c,$05
	call companionSetAnimation
	jp rickyIncVar03

;;
; Ricky leaving upon meeting Tingle (part 2: start moving toward cliff)
rickyStateASubstate3:
	call retIfTextIsActive

	; Move down-left
	ld a,$14
	ld e,SpecialObject.angle
	ld (de),a

	; Face down
	dec e
	ld a,$02
	ld (de),a

	ld c,$05
	call companionSetAnimation
	jp rickyIncVar03

;;
; Ricky leaving upon meeting Tingle (part 4: jumping down cliff)
rickyStateASubstate5:
	call specialObjectAnimate
	call objectApplySpeed
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	; Reached bottom of cliff
	ld a,$18
	call specialObjectSetAnimation
	jp rickyIncVar03

;;
; Ricky leaving upon meeting Tingle (part 3: moving toward cliff, or...
;                                    part 6: moving toward screen edge)
rickyStateASubstate4:
rickyStateASubstate7:
	call companionSetAnimationToVar3f
	call rickyWaitUntilJumpDone
	ret nz

	; Ricky has just touched the ground, and is ready to do another hop.

	; Check if moving toward a wall on the left
	ld a,$18
	ld e,SpecialObject.angle
	ld (de),a
	call specialObjectCheckMovingTowardWall
	jr z,@hop

	; Check if moving toward a wall below
	ld a,$10
	ld e,SpecialObject.angle
	ld (de),a
	call specialObjectCheckMovingTowardWall
	jr z,@hop

	; He's against the cliff; proceed to next state (jumping down cliff).
	call rickySetJumpSpeed
	ld a,SND_JUMP
	call playSound
	jp rickyIncVar03

@hop:
	call objectCheckWithinScreenBoundary
	jr nc,@leftScreen

	; Moving toward cliff, or screen edge? Set angle accordingly.
	ld e,SpecialObject.var03
	ld a,(de)
	cp $07
	ld a,$10
	jr z,+
	ld a,$14
+
	ld e,SpecialObject.angle
	ld (de),a
	jp rickySetJumpSpeedForCutscene

@leftScreen:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wDeathRespawnBuffer.rememberedCompanionId),a
	call itemDelete
	ld hl,wRickyState
	set 6,(hl)
	jp saveLinkLocalRespawnAndCompanionPosition
.else

rickyStateASubstate7:
	call companionSetAnimationToVar3f
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	or a
	ld a,SND_RICKY
	jp z,playSound
	ld a,(de)
	rlca
	ret nc
	call rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.angle
	ld a,$10
	ld (de),a
	ret
rickyStateASubstate3:
	call companionSetAnimationToVar3f
	ld e,SpecialObject.var3e
	ld a,(de)
	and $01
	ret nz
	call rickyWaitUntilJumpDone
	ret nz
	ld e,SpecialObject.yh
	ld a,(de)
	cp $38
	jr nc,rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.var3e
	ld a,(de)
	or $01
	ld (de),a
	ret
rickyStateASubstate4:
	call companionSetAnimationToVar3f
	ld e,SpecialObject.var3e
	ld a,(de)
	bit 1,a
	ret nz
	or $02
	ld (de),a
	jp companionDismount
rickyStateASubstate5:
	call rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.angle
	ld a,$10
	ld (de),a
	ret
rickyStateASubstate6:
rickyStateASubstate8:
	call companionSetAnimationToVar3f
	call rickyWaitUntilJumpDone
	ret nz
	call objectCheckWithinScreenBoundary
	jr nc,++
	ld e,SpecialObject.yh
	ld a,(de)
	cp $60
	jr c,+
	ld e,SpecialObject.var3e
	ld a,(de)
	or SpecialObject.state
	ld (de),a
+
	call rickySetJumpSpeedForCutsceneAndSetAngle
	ld e,SpecialObject.angle
	ld a,$10
	ld (de),a
	ret
++
	ld a,$01
	ld (wLinkForceState),a
	xor a
	ld (wDisabledObjects),a
	call itemDelete
	jp saveLinkLocalRespawnAndCompanionPosition
rickyStateASubstate9:
	ld a,$80
	ld (wMenuDisabled),a
	ld a,$01
	ld e,SpecialObject.direction
	ld (de),a
	call rickyIncVar03
	ld c,$20
	call companionSetAnimation
-
	ld bc,$4070
	call objectGetRelativeAngle
	and $1c
	ld e,SpecialObject.angle
	ld (de),a
	ret
rickyStateASubstateA:
	call specialObjectAnimate
	call companionUpdateMovement
	ld e,SpecialObject.xh
	ld a,(de)
	cp $38
	jr c,-
	ld bc,TX_2004
	call showText
.endif

;;
rickyIncVar03:
	ld e,SpecialObject.var03
	ld a,(de)
	inc a
	ld (de),a
	ret

;;
; Seasons-only
rickyStateASubstateB:
	call retIfTextIsActive
	call companionDismount

	ld a,$18
	ld (w1Link.angle),a
	ld (wLinkAngle),a

	ld a,SPEED_140
	ld (w1Link.speed),a

	ld h,d
	ld l,SpecialObject.angle
	ld a,$18
	ldd (hl),a

	ld a,DIR_LEFT
	ldd (hl),a ; [direction] = DIR_LEFT
	ld a,$1e
	ld (hl),a ; [counter2] = $1e

	ld a,$24
	call specialObjectSetAnimation
	jr rickyIncVar03

;;
; Seasons-only
rickyStateASubstateC:
	ld a,(wLinkInAir)
	or a
	ret nz

	call setLinkForceStateToState08
	ld hl,w1Link.xh
	ld e,SpecialObject.xh
	ld a,(de)
	bit 7,a
	jr nz,+

	cp (hl)
	ld a,DIR_RIGHT
	jr nc,++
+
	ld a,DIR_LEFT
++
	ld l,SpecialObject.direction
	ld (hl),a
	ld e,SpecialObject.counter2
	ld a,(de)
	or a
	jr z,@moveCompanion
	dec a
	ld (de),a
	ret

@moveCompanion:
	call specialObjectAnimate
	call companionUpdateMovement
	call objectCheckWithinScreenBoundary
	ret c
	xor a
	ld (wRememberedCompanionId),a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp itemDelete

;;
; @param[out]	zflag	Set if Ricky's on the ground and counter1 has reached 0.
rickyWaitUntilJumpDone:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@onGround

	call companionUpdateMovement
	or d
	ret

@onGround:
	ld c,$05
	call companionSetAnimation
	jp companionDecCounter1IfNonzero

;;
; State $0c: Ricky entering screen from flute call
rickyStateC:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw @parameter0
	.dw @parameter1

@parameter0:
	call companionInitializeOnEnteringScreen
	ld (hl),$02
	call rickySetJumpSpeedForCutscene
	ld a,SND_RICKY
	call playSound
	ld c,$01
	jp companionSetAnimation

@parameter1:
	call rickyState5

	; Return if falling into a hazard
	ld e,SpecialObject.state
	ld a,(de)
	cp $04
	ret z

	ld a,$0c
	ld (de),a ; [state] = $0c
	inc e
	ld a,(de) ; a = [substate]
	cp $03
	ret nz

	call rickyBreakTilesOnLanding
	ld hl,rickyHoleCheckOffsets
	call specialObjectGetRelativeTileWithDirectionTable
	or a
	jr nz,@initializeRicky
	call itemDecCounter2
	jr z,@initializeRicky
	call rickySetJumpSpeedForCutscene
	ld c,$01
	jp companionSetAnimation

; Make Ricky stop moving in, start waiting in place
@initializeRicky:
	ld e,SpecialObject.var03
	xor a
	ld (de),a
	jp rickyState0


;;
; @param[out]	zflag	Set if Ricky should hop up a cliff
rickyCheckHopUpCliff:
	; Check that Ricky's facing a wall above him
	ld e,SpecialObject.adjacentWallsBitset
	ld a,(de)
	and $c0
	cp $c0
	ret nz

	; Check that we're trying to move up
	ld a,(wLinkAngle)
	cp $00
	ret nz

	; Ricky can jump up to two tiles above him where the collision value equals $03
	; (only the bottom half of the tile is solid).

; Check that the tiles on ricky's left and right sides one tile up are clear
@tryOneTileUp:
	ld hl,@cliffOffset_oneUp_right
	call specialObjectGetRelativeTileFromHl
	cp $03
	jr z,+
	ld a,b
	cp TILEINDEX_VINE_TOP
	jr nz,@tryTwoTilesUp
+
	ld hl,@cliffOffset_oneUp_left
	call specialObjectGetRelativeTileFromHl
	cp $03
	jr z,@canJumpUpCliff
	ld a,b
	cp TILEINDEX_VINE_TOP
	jr z,@canJumpUpCliff

; Check that the tiles on ricky's left and right sides two tiles up are clear
@tryTwoTilesUp:
	ld hl,@cliffOffset_twoUp_right
	call specialObjectGetRelativeTileFromHl
	cp $03
	jr z,+
	ld a,b
	cp TILEINDEX_VINE_TOP
	ret nz
+
	ld hl,@cliffOffset_twoUp_left
	call specialObjectGetRelativeTileFromHl
	cp $03
	jr z,@canJumpUpCliff
	ld a,b
	cp TILEINDEX_VINE_TOP
	ret nz

@canJumpUpCliff:
	; State 2 handles jumping up a cliff
	ld e,SpecialObject.state
	ld a,$02
	ld (de),a
	inc e
	xor a
	ld (de),a ; [substate] = 0

	ld e,SpecialObject.counter2
	ld (de),a
	ret

; Offsets for the cliff tile that Ricky will be hopping up to

@cliffOffset_oneUp_right:
	.db $f8 $06
@cliffOffset_oneUp_left:
	.db $f8 $fa
@cliffOffset_twoUp_right:
	.db $e8 $06
@cliffOffset_twoUp_left:
	.db $e8 $fa


;;
rickyBreakTilesOnLanding:
	ld hl,@offsets
@next:
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	or b
	ret z
	push hl
	ld a,(w1Companion.yh)
	add b
	ld b,a
	ld a,(w1Companion.xh)
	add c
	ld c,a
	ld a,BREAKABLETILESOURCE_10
	call tryToBreakTile
	pop hl
	jr @next

; Each row is a Y/X offset at which to attempt to break a tile when Ricky lands.
@offsets:
	.db $04 $00
	.db $04 $06
	.db $fe $00
	.db $04 $fa
	.db $00 $00


;;
; Seems to set variables for ricky's jump speed, etc, but the jump may still be cancelled
; after this?
rickyBeginJumpOverHole:
	ld a,$01
	ld (wLinkInAir),a

;;
rickySetJumpSpeed_andcc91:
	ld a,$01
	ld (wDisableScreenTransitions),a

;;
; Sets up Ricky's speed for long jumps across holes and cliffs.
rickySetJumpSpeed:
	ld bc,-$300
	call objectSetSpeedZ
	ld l,SpecialObject.counter1
	ld (hl),$08
	ld l,SpecialObject.speed
	ld (hl),SPEED_140
	ld c,$0f
	call companionSetAnimation
	ld h,d
	ret

;;
; @param[out]	zflag	Set if Ricky's close to the screen edge
rickyCheckAtScreenEdge:
	ld h,d
	ld l,SpecialObject.yh
	ld a,$06
	cp (hl)
	jr nc,@outsideScreen

	ld a,(wScreenTransitionBoundaryY)
	dec a
	cp (hl)
	jr c,@outsideScreen

	ld l,SpecialObject.xh
	ld a,$06
	cp (hl)
	jr nc,@outsideScreen

	ld a,(wScreenTransitionBoundaryX)
	dec a
	cp (hl)
	jr c,@outsideScreen

	xor a
	ret

@outsideScreen:
	or d
	ret

; Offsets relative to Ricky's position to check for holes to jump over
rickyHoleCheckOffsets:
	.db $f8 $00
	.db $05 $08
	.db $08 $00
	.db $05 $f8


;;
; var38: nonzero if Dimitri is in water?
specialObjectCode_dimitri:
	call companionRetIfInactive
	call companionFunc_47d8
	call @runState
	xor a
	ld (wDimitriHitNpc),a
	jp companionCheckEnableTerrainEffects

; Note: expects that h=d (call to companionFunc_47d8 does this)
@runState:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw dimitriState0
	.dw dimitriState1
	.dw dimitriState2
	.dw dimitriState3
	.dw dimitriState4
	.dw dimitriState5
	.dw dimitriState6
	.dw dimitriState7
	.dw dimitriState8
	.dw dimitriState9
	.dw dimitriStateA
	.dw dimitriStateB
	.dw dimitriStateC
	.dw dimitriStateD

;;
; State 0: initialization, deciding which state to go to
dimitriState0:
	call companionCheckCanSpawn

	ld a,DIR_DOWN
	ld l,SpecialObject.direction
	ldi (hl),a
	ld (hl),a ; [counter2] = $02

	ld a,(wDimitriState)
.ifdef ROM_AGES
	bit 7,a
	jr nz,@setAnimation
	bit 6,a
	jr nz,+
	and $20
	jr nz,@setAnimation
+
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST
	call checkGlobalFlag
	ld h,d
	ld c,$24
	jr z,+
	ld c,$1e
+
	ld l,SpecialObject.state
	ld (hl),$0a

	ld e,SpecialObject.var3d
	call objectAddToAButtonSensitiveObjectList

	ld a,c
.else
	and $80
	jr nz,@setAnimation
	ld l,SpecialObject.state
	ld (hl),$0a
	ld e,SpecialObject.var3d
	call objectAddToAButtonSensitiveObjectList
	ld a,$24
.endif

	ld e,SpecialObject.var3f
	ld (de),a
	call specialObjectSetAnimation

	ld bc,$0408
	call objectSetCollideRadii
	jr @setVisible

@setAnimation:
	ld c,$1c
	call companionSetAnimation
@setVisible:
	jp objectSetVisible81

;;
; State 1: waiting for Link to mount
dimitriState1:
	call companionSetPriorityRelativeToLink
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	; Is dimitri in a hole?
	call companionCheckHazards
	jr nc,@onLand
	cp $02
	ret z

	; No, he must be in water
	call dimitriAddWaterfallResistance
	ld a,$04
	call dimitriFunc_756d
	jr ++

@onLand:
	ld e,SpecialObject.var38
	ld a,(de)
	or a
	jr z,++
	xor a
	ld (de),a
	ld c,$1c
	call companionSetAnimation
++
	ld a,$06
	call objectSetCollideRadius

	ld e,SpecialObject.var3b
	ld a,(de)
	or a
	jp nz,dimitriGotoState1IfLinkFarAway

	ld c,$09
	call objectCheckLinkWithinDistance
	jp nc,dimitriCheckAddToGrabbableObjectBuffer
	jp companionTryToMount

;;
; State 2: curled into a ball (being held or thrown).
;
; The substates are generally controlled by power bracelet code (see "itemCode16").
;
dimitriState2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw dimitriState2Substate0
	.dw dimitriState2Substate1
	.dw dimitriState2Substate2
	.dw dimitriState2Substate3

;;
; Substate 0: just grabbed
dimitriState2Substate0:
	ld a,$40
	ld (wLinkGrabState2),a
	call itemIncSubstate
	xor a
	ld (wDisableWarpTiles),a

	ld l,SpecialObject.var38
	ld (hl),a
	ld l,SpecialObject.var3f
	ld (hl),$ff

	call objectSetVisiblec0

	ld a,$02
	ld hl,wCompanionTutorialTextShown
	call setFlag

	ld c,$18
	jp companionSetAnimation

;;
; Substate 1: being lifted, carried
dimitriState2Substate1:
	xor a
	ld (w1Link.knockbackCounter),a
	ld a,(wActiveTileType)
	cp TILETYPE_CRACKED_ICE
	jr nz,+
	ld a,$20
	ld (wStandingOnTileCounter),a
+
	ld a,(wLinkClimbingVine)
	or a
	jr nz,@releaseDimitri

	ld a,(w1Link.angle)
	bit 7,a
	jr nz,@update

	ld e,SpecialObject.angle
	ld (de),a

	ld a,(w1Link.direction)
	dec e
	ld (de),a ; [direction] = [w1Link.direction]

	call dimitriCheckCanBeHeldInDirection
	jr nz,@update

@releaseDimitri:
	ld h,d
	ld l,SpecialObject.enabled
	res 1,(hl)
	ld l,SpecialObject.var3b
	ld (hl),$01
	jp dropLinkHeldItem

@update:
	; Check whether to prevent Link from throwing dimitri (write nonzero to wcc67)
	call companionCalculateAdjacentWallsBitset
	call specialObjectCheckMovingTowardWall
	ret z
	ld (wcc67),a
	ret

;;
; Substate 2: dimitri released, falling to ground
dimitriState2Substate2:
	ld h,d
	ld l,SpecialObject.enabled
	res 1,(hl)

	call companionCheckHazards
	jr nc,@noHazard

	; Return if he's on a hole
	cp $02
	ret z
	jr @onHazard

@noHazard:
	ld h,d
	ld l,SpecialObject.var3f
	ld a,(hl)
	cp $ff
	jr nz,++

	; Set Link's current position as the spot to return to if Dimitri lands in water
	xor a
	ld (hl),a
	ld l,SpecialObject.var39
	ld a,(w1Link.yh)
	ldi (hl),a
	ld a,(w1Link.xh)
	ld (hl),a
++

; Check whether Dimitri should stop moving when thrown. Involves screen boundary checks.

	ld a,(wDimitriHitNpc)
	or a
	jr nz,@stopMovement

	call companionCalculateAdjacentWallsBitset
	call specialObjectCheckMovingTowardWall
	jr nz,@stopMovement

	ld c,$00
	ld h,d
	ld l,SpecialObject.yh
	ld a,(hl)
	cp $08
	jr nc,++
	ld (hl),$10
	inc c
	jr @checkX
++
	ld a,(wActiveGroup)
	or a
	ld a,(hl)
	jr nz,@largeRoomYCheck
@smallRoomYCheck:
	cp SMALL_ROOM_HEIGHT*16-6
	jr c,@checkX
	ld (hl), SMALL_ROOM_HEIGHT*16-6
	inc c
	jr @checkX
@largeRoomYCheck:
	cp LARGE_ROOM_HEIGHT*16-8
	jr c,@checkX
	ld (hl), LARGE_ROOM_HEIGHT*16-8
	inc c
	jr @checkX

@checkX:
	ld l,SpecialObject.xh
	ld a,(hl)
	cp $04
	jr nc,++
	ld (hl),$04
	inc c
	jr @doneBoundsCheck
++
	ld a,(wActiveGroup)
	or a
	ld a,(hl)
	jr nz,@largeRoomXCheck
@smallRoomXCheck:
	cp SMALL_ROOM_WIDTH*16-5
	jr c,@doneBoundsCheck
	ld (hl), SMALL_ROOM_WIDTH*16-5
	inc c
	jr @doneBoundsCheck
@largeRoomXCheck:
	cp LARGE_ROOM_WIDTH*16-17
	jr c,@doneBoundsCheck
	ld (hl), LARGE_ROOM_WIDTH*16-17
	inc c

@doneBoundsCheck:
	ld a,c
	or a
	jr z,@checkOnHazard

@stopMovement:
	ld a,SPEED_0
	ld (w1ReservedItemC.speed),a

@checkOnHazard:
	call objectCheckIsOnHazard
	cp $01
	ret nz

@onHazard:
	ld h,d
	ld l,SpecialObject.state
	ld (hl),$0b
	ld l,SpecialObject.var38
	ld (hl),$04

	; Calculate angle toward Link?
	ld l,SpecialObject.var39
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call objectGetRelativeAngle
	and $18
	ld e,SpecialObject.angle
	ld (de),a

	; Calculate direction based on angle
	add a
	swap a
	and $03
	dec e
	ld (de),a ; [direction] = a

	ld c,$00
	jp companionSetAnimation

;;
; Substate 3: landed on ground for good
dimitriState2Substate3:
	ld h,d
	ld l,SpecialObject.enabled
	res 1,(hl)

	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz
	call companionTryToBreakTileFromMoving
	call companionCheckHazards
	jr nc,@gotoState1

	; If on a hole, return (stay in this state?)
	cp $02
	ret z

	; If in water, go to state 1, but with alternate value for var38?
	ld a,$04
	jp dimitriFunc_756d

@gotoState1:
	xor a

;;
; @param	a	Value for var38
dimitriFunc_756d:
	ld h,d
	ld l,SpecialObject.var38
	ld (hl),a

	ld l,SpecialObject.state
	ld a,$01
	ldi (hl),a
	ld (hl),$00 ; [substate] = 0

	ld c,$1c
	jp companionSetAnimation

;;
; State 3: Link is jumping up to mount Dimitri
dimitriState3:
	call companionCheckMountingComplete
	ret nz
	call companionFinalizeMounting
	ld c,$00
	jp companionSetAnimation

;;
; State 4: Dimitri's falling into a hazard (hole/water)
dimitriState4:
	call companionDragToCenterOfHole
	ret nz
	call companionDecCounter1
	jr nz,@animate

	inc (hl)
	ld a,SND_LINK_FALL
	call playSound
	ld a,$25
	jp specialObjectSetAnimation

@animate:
	call companionAnimateDrowningOrFallingThenRespawn
	ret nc
	ld c,$00
	jp companionUpdateDirectionAndSetAnimation

;;
; State 5: Link riding dimitri.
dimitriState5:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	ld a,(wForceCompanionDismount)
	or a
	jr nz,++
	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jr nz,dimitriGotoEatingState
	bit BTN_BIT_B,a
++
	jp nz,companionGotoDismountState

	ld a,(wLinkAngle)
	bit 7,a
	jr nz,dimitriUpdateMovement@checkHazards

	; Check if angle changed, update direction if so
	ld hl,w1Companion.angle
	cp (hl)
	ld (hl),a
	ld c,$00
	jp nz,companionUpdateDirectionAndAnimate

	; Return if he should hop down a cliff (state changed in function call)
	call companionCheckHopDownCliff
	ret z

;;
dimitriUpdateMovement:
	; Play sound effect when animation indicates to do so
	ld h,d
	ld l,SpecialObject.animParameter
	ld a,(hl)
	rlca
	ld a,SND_LINK_SWIM
	call c,playSound

	; Determine speed
	ld l,SpecialObject.var38
	ld a,(hl)
	or a
	ld a,SPEED_c0
	jr z,+
	ld a,SPEED_100
+
	ld l,SpecialObject.speed
	ld (hl),a
	call companionUpdateMovement
	call specialObjectAnimate

@checkHazards:
	call companionCheckHazards
	ld h,d
	jr nc,@setNotInWater

	; Return if the hazard is a hole
	cp $02
	ret z

	; If it's water, stay in state 5 (he can swim).
	ld l,SpecialObject.state
	ld (hl),$05

.ifdef ROM_AGES
	ld a,(wLinkForceState)
	cp LINK_STATE_RESPAWNING
	jr nz,++
	xor a
	ld (wLinkForceState),a
	jp companionGotoHazardHandlingState
++
.endif

	call dimitriAddWaterfallResistance
	ld b,$04
	jr @setWaterStatus

@setNotInWater:
	ld b,$00

@setWaterStatus:
	; Set var38 to value of "b", update animation if it changed
	ld l,SpecialObject.var38
	ld a,(hl)
	cp b
	ld (hl),b
	ld c,$00
	jp nz,companionUpdateDirectionAndSetAnimation

;;
dimitriState9:
	ret

;;
dimitriGotoEatingState:
	ld h,d
	ld l,SpecialObject.state
	ld a,$08
	ldi (hl),a
	xor a
	ldi (hl),a ; [substate] = 0
	ld (hl),a  ; [counter1] = 0

	ld l,SpecialObject.var35
	ld (hl),a

	; Calculate angle based on direction
	ld l,SpecialObject.direction
	ldi a,(hl)
	swap a
	rrca
	ld (hl),a

	ld a,$01
	ld (wLinkInAir),a
	ld l,SpecialObject.speed
	ld (hl),SPEED_c0
	ld c,$08
	call companionSetAnimation
	ldbc ITEMID_DIMITRI_MOUTH, $00
	call companionCreateWeaponItem

	ld a,SND_DIMITRI
	jp playSound

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
dimitriState6:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01
	ld (de),a
	call companionDismountAndSavePosition
	ld c,$1c
	jp companionSetAnimation

@substate1:
	ld a,(wLinkInAir)
	or a
	ret nz
	jp itemIncSubstate

@substate2:
	call dimitriCheckAddToGrabbableObjectBuffer

;;
dimitriGotoState1IfLinkFarAway:
	; Return if Link is too close
	ld c,$09
	call objectCheckLinkWithinDistance
	ret c

;;
; @param[out]	a	0
; @param[out]	de	var3b
dimitriGotoState1:
	ld e,SpecialObject.state
	ld a,$01
	ld (de),a
	inc e
	xor a
	ld (de),a ; [substate] = 0
	ld e,SpecialObject.var3b
	ld (de),a
	ret

;;
; State 7: jumping down a cliff
dimitriState7:
	call companionDecCounter1ToJumpDownCliff
	ret c
	call companionCalculateAdjacentWallsBitset
	call specialObjectCheckMovingAwayFromWall

	ld l,SpecialObject.counter2
	jr z,+
	ld (hl),a
	ret
+
	ld a,(hl)
	or a
	ret z
	jp dimitriLandOnGroundAndGotoState5

;;
; State 8: Attempting to eat something
dimitriState8:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Substate 0: Moving forward for the bite
@substate0:
	call specialObjectAnimate
	call objectApplySpeed
	ld e,SpecialObject.animParameter
	ld a,(de)
	rlca
	ret nc

	; Initialize stuff for substate 1 (moving back)

	call itemIncSubstate

	; Calculate angle based on the reverse of the current direction
	ld l,SpecialObject.direction
	ldi a,(hl)
	xor $02
	swap a
	rrca
	ld (hl),a

	ld l,SpecialObject.counter1
	ld (hl),$0c
	ld c,$00
	jp companionSetAnimation

; Substate 1: moving back
@substate1:
	call specialObjectAnimate
	call objectApplySpeed
	call companionDecCounter1IfNonzero
	ret nz

	; Done moving back

	ld (hl),$14

	; Fix angle to be consistent with direction
	ld l,SpecialObject.direction
	ldi a,(hl)
	swap a
	rrca
	ld (hl),a

	; Check if he swallowed something; if so, go to substate 2, otherwise resume
	; normal movement.
	ld l,SpecialObject.var35
	ld a,(hl)
	or a
	jp z,dimitriLandOnGroundAndGotoState5
	call itemIncSubstate
	ld c,$10
	jp companionSetAnimation

; Substate 2: swallowing something
@substate2:
	call specialObjectAnimate
	call companionDecCounter1IfNonzero
	ret nz
	jr dimitriLandOnGroundAndGotoState5

;;
; State B: swimming back to land after being thrown into water
dimitriStateB:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	call dimitriUpdateMovement

	; Set state to $01 if he's out of the water; stay in $0b otherwise
	ld h,d
	ld l,SpecialObject.var38
	ld a,(hl)
	or a
	ld l,SpecialObject.state
	ld (hl),$0b
	ret nz
	ld (hl),$01
	ret

;;
; State C: Dimitri entering screen from flute call
dimitriStateC:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw @parameter0
	.dw @parameter1

; substate 0: dimitri just spawned?
@parameter0:
	call companionInitializeOnEnteringScreen
	ld (hl),$3c ; [counter2] = $3c

	ld a,SND_DIMITRI
	call playSound
	ld c,$00
	jp companionSetAnimation

; substate 1: walking in
@parameter1:
	call dimitriUpdateMovement
	ld e,SpecialObject.state
	ld a,$0c
	ld (de),a

	ld hl,dimitriTileOffsets
	call companionRetIfNotFinishedWalkingIn

	; Done walking into screen; jump to state 0
	ld e,SpecialObject.var03
	xor a
	ld (de),a
	jp dimitriState0

;;
; State D: ? (set to this by INTERACID_CARPENTER subid $ff?)
dimitriStateD:
	ld e,SpecialObject.var3c
	ld a,(de)
	or a
	jr nz,++

	call dimitriGotoState1
	inc a
	ld (de),a ; [var3b] = 1

	ld hl,w1Companion.enabled
	res 1,(hl)
	ld c,$1c
	jp companionSetAnimation
++
	ld e,SpecialObject.state
	ld a,$05
	ld (de),a

;;
dimitriLandOnGroundAndGotoState5:
	xor a
	ld (wLinkInAir),a
	ld c,$00
	jp companionSetAnimationAndGotoState5

.ifdef ROM_AGES
;;
; State A: cutscene-related stuff
dimitriStateA:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw dimitriStateASubstate0
	.dw dimitriStateASubstate1
	.dw dimitriStateASubstate2
	.dw dimitriStateASubstate3
	.dw dimitriStateASubstate4

;;
; Force mounting Dimitri?
dimitriStateASubstate0:
	ld e,SpecialObject.var3d
	ld a,(de)
	or a
	jr z,+
	ld a,$81
	ld (wDisabledObjects),a
+
	call companionSetAnimationToVar3f
	call companionPreventLinkFromPassing_noExtraChecks
	call specialObjectAnimate

	ld e,SpecialObject.visible
	ld a,$c7
	ld (de),a

	ld a,(wDimitriState)
	and $80
	ret z

	ld e,SpecialObject.visible
	ld a,$c1
	ld (de),a

	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ld c,$1c
	call companionSetAnimation
	jp companionForceMount

;;
; Force mounting dimitri?
dimitriStateASubstate1:
	ld e,SpecialObject.var3d
	call objectRemoveFromAButtonSensitiveObjectList
	ld c,$1c
	call companionSetAnimation
	jp companionForceMount

;;
; Dimitri begins parting upon reaching mainland?
dimitriStateASubstate3:
	ld e,SpecialObject.direction
	ld a,DIR_RIGHT
	ld (de),a
	inc e
	ld a,$08
	ld (de),a ; [angle] = $08

	ld c,$00
	call companionSetAnimation
	ld e,SpecialObject.var03
	ld a,$04
	ld (de),a

	ld a,SND_DIMITRI
	jp playSound

;;
; Dimitri moving until he goes off-screen
dimitriStateASubstate4:
	call dimitriUpdateMovement

	ld e,SpecialObject.state
	ld a,$0a
	ld (de),a

	call objectCheckWithinScreenBoundary
	ret c

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wUseSimulatedInput),a
	jp itemDelete

;;
; Force dismount Dimitri
dimitriStateASubstate2:
	ld a,(wLinkObjectIndex)
	cp >w1Companion
	ret nz
	call companionDismountAndSavePosition
	xor a
	ld (wRememberedCompanionId),a
	ret
.else
dimitriStateA:
	call companionSetAnimationToVar3f
	call companionPreventLinkFromPassing_noExtraChecks
	call specialObjectAnimate
	ld e,SpecialObject.visible
	ld a,$c7
	ld (de),a
	ld a,(wDimitriState)
	and $80
	ret z

	ld e,SpecialObject.visible
	ld a,$c1
	ld (de),a
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ld c,$1c
	call companionSetAnimation
	jp companionForceMount
.endif

;;
dimitriCheckAddToGrabbableObjectBuffer:
	ld a,(wLinkClimbingVine)
	or a
	ret nz
	ld a,(w1Link.direction)
	call dimitriCheckCanBeHeldInDirection
	ret z

	; Check the collisions at Link's position
	ld hl,w1Link.yh
	ld b,(hl)
	ld l,<w1Link.xh
	ld c,(hl)
	call getTileCollisionsAtPosition

	; Disallow cave entrances (top half solid)?
	cp $0c
	jr z,@ret

	; Disallow if Link's on a fully solid tile?
	cp $0f
	jr z,@ret

	cp SPECIALCOLLISION_VERTICAL_BRIDGE
	jr z,@ret
	cp SPECIALCOLLISION_HORIZONTAL_BRIDGE
	call nz,objectAddToGrabbableObjectBuffer
@ret:
	ret

;;
; Checks the tiles in front of Dimitri to see if he can be held?
; (if moving diagonally, it checks both directions, and fails if one is impassable).
;
; This seems to disallow holding him on small bridges and cave entrances.
;
; @param	a	Direction that Link/Dimitri's moving toward
; @param[out]	zflag	Set if one of the tiles in front are not passable.
dimitriCheckCanBeHeldInDirection:
	call @checkTile
	ret z

	ld hl,w1Link.angle
	ldd a,(hl)
	bit 7,a
	ret nz
	bit 2,a
	jr nz,@diagonalMovement

	or d
	ret

@diagonalMovement:
	; Calculate the other direction being moved in
	add a
	ld b,a
	ldi a,(hl) ; a = [direction]
	swap a
	srl a
	xor b
	add a
	swap a
	and $03

;;
; @param	a	Direction
; @param[out]	zflag	Set if the tile in that direction is not ok for holding dimitri?
@checkTile:
	ld hl,dimitriTileOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call objectGetRelativeTile

	cp TILEINDEX_VINE_BOTTOM
	ret z
	cp TILEINDEX_VINE_MIDDLE
	ret z
	cp TILEINDEX_VINE_TOP
	ret z

	; Only disallow tiles where the top half is solid? (cave entrances?
	ld h,>wRoomCollisions
	ld a,(hl)
	cp $0c
	ret z

	cp SPECIALCOLLISION_VERTICAL_BRIDGE
	ret z
	cp SPECIALCOLLISION_HORIZONTAL_BRIDGE
	ret

;;
; Moves Dimitri down if he's on a waterfall
dimitriAddWaterfallResistance:
	call objectGetTileAtPosition
	ld h,d
	cp TILEINDEX_WATERFALL
	jr z,+
	cp TILEINDEX_WATERFALL_BOTTOM
	ret nz
+
	; Move y-position down the waterfall (acts as resistance)
	ld l,SpecialObject.y
	ld a,(hl)
	add $c0
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a

	; Check if we should start a screen transition based on downward waterfall
	; movement
	ld a,(wScreenTransitionBoundaryY)
	cp (hl)
	ret nc
	ld a,$82
	ld (wScreenTransitionDirection),a
	ret

dimitriTileOffsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT

;;
specialObjectCode_moosh:
	call companionRetIfInactive
	call companionFunc_47d8
	call @runState
	jp companionCheckEnableTerrainEffects

@runState:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw mooshState0
	.dw mooshState1
	.dw mooshState2
	.dw mooshState3
	.dw mooshState4
	.dw mooshState5
	.dw mooshState6
	.dw mooshState7
	.dw mooshState8
	.dw mooshState9
	.dw mooshStateA
	.dw mooshStateB
	.dw mooshStateC

;;
; State 0: initialization
mooshState0:
	call companionCheckCanSpawn
	ld a,$06
	call objectSetCollideRadius

	ld a,DIR_DOWN
	ld l,SpecialObject.direction
	ldi (hl),a
	ldi (hl),a ; [angle] = $02

	ld hl,wMooshState
	ld a,$80
	and (hl)
	jr nz,@setAnimation

.ifdef ROM_AGES
	; Check for the screen with the bridge near the forest?
	ld a,(wActiveRoom)
	cp $54
	jr z,@gotoCutsceneStateA

	ld a,$20
	and (hl)
	jr z,@gotoCutsceneStateA
	ld a,$40
	and (hl)
	jr nz,@gotoCutsceneStateA

	; Check for the room where Moosh leaves after obtaining cheval's rope
	ld a,TREASURE_CHEVAL_ROPE
	call checkTreasureObtained
	jr nc,@setAnimation
	ld a,(wActiveRoom)
	cp $6b
	jr nz,@setAnimation
.else
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_MOOSH
	jr nz,@gotoCutsceneStateA

	ld a,$20
	and (hl)
	jr z,+

	ld a,(wActiveRoom)
	; mt cucco
	cp $2f
	jr z,@gotoCutsceneStateA
	jr @setAnimation
+
	ld a,(wActiveRoom)
	; spool swamp
	cp $90
	jr nz,@setAnimation
.endif

@gotoCutsceneStateA:
	ld e,SpecialObject.state
	ld a,$0a
	ld (de),a
	jp mooshStateA

@setAnimation:
	ld c,$01
	call companionSetAnimation
	jp objectSetVisiblec1

;;
; State 1: waiting for Link to mount
mooshState1:
	call companionSetPriorityRelativeToLink
	call specialObjectAnimate

	ld c,$09
	call objectCheckLinkWithinDistance
	jp c,companionTryToMount

;;
mooshCheckHazards:
	call companionCheckHazards
	ret nc
	jr mooshSetVar37ForHazard

;;
; State 3: Link is currently jumping up to mount Moosh
mooshState3:
	call companionCheckMountingComplete
	ret nz
	call companionFinalizeMounting
	ld c,$13
	jp companionSetAnimation

;;
; State 4: Moosh falling into a hazard (hole/water)
mooshState4:
	ld h,d
	ld l,SpecialObject.collisionType
	set 7,(hl)

	; Check if the hazard is water
	ld l,SpecialObject.var37
	ld a,(hl)
	cp $0d
	jr z,++

	; No, it's a hole
	ld a,$0e
	ld (hl),a
	call companionDragToCenterOfHole
	ret nz
++
	call companionDecCounter1
	jr nz,@animate

	; Set falling/drowning animation, play falling sound if appropriate
	dec (hl)
	ld l,SpecialObject.var37
	ld a,(hl)
	call specialObjectSetAnimation

	ld e,SpecialObject.var37
	ld a,(de)
	cp $0d ; Is this water?
	jr z,@animate

	ld a,SND_LINK_FALL
	jp playSound

@animate:
	call companionAnimateDrowningOrFallingThenRespawn
	ret nc
	ld c,$13
	ld a,(wLinkObjectIndex)
	rrca
	jr c,+
	ld c,$01
+
	jp companionUpdateDirectionAndSetAnimation

;;
mooshTryToBreakTileFromMovingAndCheckHazards:
	call companionTryToBreakTileFromMoving
	call companionCheckHazards
	ld c,$13
	jp nc,companionUpdateDirectionAndAnimate

;;
mooshSetVar37ForHazard:
	dec a
	ld c,$0d
	jr z,+
	ld c,$0e
+
	ld e,SpecialObject.var37
	ld a,c
	ld (de),a
	ld e,SpecialObject.counter1
	xor a
	ld (de),a
	ret

;;
; State 5: Link riding Moosh.
mooshState5:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	call companionCheckHazards
	jr c,mooshSetVar37ForHazard

	ld a,(wForceCompanionDismount)
	or a
	jr nz,++
	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jr nz,mooshPressedAButton
	bit BTN_BIT_B,a
++
	jp nz,companionGotoDismountState

	; Return if not attempting to move
	ld a,(wLinkAngle)
	bit 7,a
	ret nz

	; Update angle, and animation if the angle changed
	ld hl,w1Companion.angle
	cp (hl)
	ld (hl),a
	ld c,$13
	jp nz,companionUpdateDirectionAndAnimate

	call companionCheckHopDownCliff
	ret z

	ld e,SpecialObject.speed
	ld a,SPEED_100
	ld (de),a
	call companionUpdateMovement

	jr mooshTryToBreakTileFromMovingAndCheckHazards

;;
mooshLandOnGroundAndGotoState5:
	xor a
	ld (wLinkInAir),a
	ld c,$13
	jp companionSetAnimationAndGotoState5

;;
mooshPressedAButton:
	ld a,$08
	ld e,SpecialObject.state
	ld (de),a
	inc e
	xor a
	ld (de),a
	ld a,SND_JUMP
	call playSound

;;
mooshState2:
mooshState9:
mooshStateB:
	ret

;;
; State 8: floating in air, possibly performing buttstomp
mooshState8:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw mooshState8Substate0
	.dw mooshState8Substate1
	.dw mooshState8Substate2
	.dw mooshState8Substate3
	.dw mooshState8Substate4
	.dw mooshState8Substate5

;;
; Substate 0: just pressed A button
mooshState8Substate0:
	ld a,$01
	ld (de),a ; [substate] = 1

	ld bc,-$140
	call objectSetSpeedZ
	ld l,SpecialObject.speed
	ld (hl),SPEED_100

	ld l,SpecialObject.var39
	ld a,$04
	ldi (hl),a
	xor a
	ldi (hl),a ; [var3a] = 0
	ldi (hl),a ; [var3b] = 0

	ld c,$09
	jp companionSetAnimation

;;
; Substate 1: floating in air
mooshState8Substate1:
	; Check if over water
	call objectCheckIsOverHazard
	cp $01
	jr nz,@notOverWater

; He's over water; go to substate 5.

	ld bc,$0000
	call objectSetSpeedZ

	ld l,SpecialObject.substate
	ld (hl),$05

	ld b,INTERACID_EXCLAMATION_MARK
	call objectCreateInteractionWithSubid00

	; Subtract new interaction's zh by $20 (should be above moosh)
	dec l
	ld a,(hl)
	sub $20
	ld (hl),a

	ld l,Interaction.counter1
	ld e,SpecialObject.counter1
	ld a,$3c
	ld (hl),a ; [Interaction.counter1] = $3c
	ld (de),a ; [Moosh.counter1] = $3c
	ret

@notOverWater:
	ld a,(wLinkAngle)
	bit 7,a
	jr nz,+
	ld hl,w1Companion.angle
	cp (hl)
	ld (hl),a
	call companionUpdateMovement
+
	ld e,SpecialObject.speedZ+1
	ld a,(de)
	rlca
	jr c,@movingUp

; Moosh is moving down (speedZ is positive or 0).

	; Increment var3b once for every frame A is held (or set to 0 if A is released).
	ld e,SpecialObject.var3b
	ld a,(wGameKeysPressed)
	and BTN_A
	jr z,+
	ld a,(de)
	inc a
+
	ld (de),a

	; Start charging stomp after A is held for 10 frames
	cp $0a
	jr nc,@gotoSubstate2

	; If pressed A, flutter in the air.
	ld a,(wGameKeysJustPressed)
	bit BTN_BIT_A,a
	jr z,@label_05_444

	; Don't allow him to flutter more than 16 times.
	ld e,SpecialObject.var3a
	ld a,(de)
	cp $10
	jr z,@label_05_444

	; [var3a] += 1 (counter for number of times he's fluttered)
	inc a
	ld (de),a

	; [var39] += 8 (ignore gravity for 8 more frames)
	dec e
	ld a,(de)
	add $08
	ld (de),a

	ld e,SpecialObject.animCounter
	ld a,$01
	ld (de),a
	call specialObjectAnimate
	ld a,SND_JUMP
	call playSound

@label_05_444:
	ld e,SpecialObject.var39
	ld a,(de)
	or a
	jr z,@updateMovement

	; [var39] -= 1
	dec a
	ld (de),a

	ld e,SpecialObject.animCounter
	ld a,$0f
	ld (de),a
	ld c,$09
	jp companionUpdateDirectionAndAnimate

@movingUp:
	ld c,$09
	call companionUpdateDirectionAndAnimate

@updateMovement:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	call companionTryToBreakTileFromMoving
	call mooshLandOnGroundAndGotoState5
	jp mooshTryToBreakTileFromMovingAndCheckHazards

@gotoSubstate2:
	jp itemIncSubstate

;;
; Substate 2: charging buttstomp
mooshState8Substate2:
	call specialObjectAnimate

	ld a,(wGameKeysPressed)
	bit BTN_BIT_A,a
	jr z,@gotoNextSubstate

	ld e,SpecialObject.var3b
	ld a,(de)
	cp 40
	jr c,+
	ld c,$02
	call companionFlashFromChargingAnimation
+
	ld e,SpecialObject.var3b
	ld a,(de)
	inc a
	ld (de),a

	; Check if it's finished charging
	cp 40
	ret c
	ld a,SND_CHARGE_SWORD
	jp z,playSound

	; Reset bit 7 on w1Link.collisionType and w1Companion.collisionType (disable
	; collisions?)
	ld hl,w1Link.collisionType
	res 7,(hl)
	inc h
	res 7,(hl)

	; Force the buttstomp to release after 120 frames of charging
	ld e,SpecialObject.var3b
	ld a,(de)
	cp 120
	ret nz

@gotoNextSubstate:
	ld hl,w1Link.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a ; [w1Link.oamFlags] = [w1Link.oamFlagsBackup]

	call itemIncSubstate
	ld c,$17

	; Set buttstomp animation if he's charged up enough
	ld e,SpecialObject.var3b
	ld a,(de)
	cp 40
	ret c
	jp companionSetAnimation

;;
; Substate 3: falling to ground with buttstomp attack (or cancelling buttstomp)
mooshState8Substate3:
	ld c,$80
	call objectUpdateSpeedZ_paramC
	ret nz

; Reached the ground

	ld e,SpecialObject.var3b
	ld a,(de)
	cp 40
	jr nc,+

	; Buttstomp not charged; just land on the ground
	call mooshLandOnGroundAndGotoState5
	jp mooshTryToBreakTileFromMovingAndCheckHazards
+
	; Buttstomp charged; unleash the attack
	call companionCheckHazards
	jp c,mooshSetVar37ForHazard

	call itemIncSubstate

	ld a,$0f
	ld (wScreenShakeCounterY),a

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_SCENT_SEED
	call playSound

	ld a,$05
	ld hl,wCompanionTutorialTextShown
	call setFlag

	ldbc ITEMID_28, $00
	jp companionCreateWeaponItem

;;
; Substate 4: sitting on the ground briefly after buttstomp attack
mooshState8Substate4:
	call specialObjectAnimate
	ld e,SpecialObject.animParameter
	ld a,(de)
	rlca
	ret nc

	; Set bit 7 on w1Link.collisionType and w1Companion.collisionType (enable
	; collisions?)
	ld hl,w1Link.collisionType
	set 7,(hl)
	inc h
	set 7,(hl)

	jp mooshLandOnGroundAndGotoState5

;;
; Substate 5: Moosh is over water, in the process of falling down.
mooshState8Substate5:
	call companionDecCounter1IfNonzero
	jr z,+
	jp specialObjectAnimate
+
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	call mooshLandOnGroundAndGotoState5
	jp mooshTryToBreakTileFromMovingAndCheckHazards

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
mooshState6:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01
	ld (de),a
	call companionDismountAndSavePosition
	ld c,$01
	jp companionSetAnimation

@substate1:
	ld a,(wLinkInAir)
	or a
	ret nz
	jp itemIncSubstate

@substate2:
	ld c,$09
	call objectCheckLinkWithinDistance
	jp c,mooshCheckHazards

	ld e,SpecialObject.substate
	xor a
	ld (de),a
	dec e
	ld a,$01
	ld (de),a ; [state] = $01 (waiting for Link to mount)
	ret

;;
; State 7: jumping down a cliff
mooshState7:
	call companionDecCounter1ToJumpDownCliff
	jr nc,+
	ret nz
	ld c,$09
	jp companionSetAnimation
+
	call companionCalculateAdjacentWallsBitset
	call specialObjectCheckMovingAwayFromWall
	ld e,$07
	jr z,+
	ld (de),a
	ret
+
	ld a,(de)
	or a
	ret z
	jp mooshLandOnGroundAndGotoState5

;;
; State C: Moosh entering from a flute call
mooshStateC:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call companionInitializeOnEnteringScreen
	ld (hl),$3c ; [counter2] = $3c
	ld a,SND_MOOSH
	call playSound
	ld c,$0f
	jp companionSetAnimation

@substate1:
	call specialObjectAnimate

	ld e,SpecialObject.speed
	ld a,SPEED_c0
	ld (de),a

	call companionUpdateMovement
	ld hl,@mooshDirectionOffsets
	call companionRetIfNotFinishedWalkingIn
	ld e,SpecialObject.var03
	xor a
	ld (de),a
	jp mooshState0

@mooshDirectionOffsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT


.ifdef ROM_AGES
;;
; State A: cutscene stuff
mooshStateA:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw @mooshStateASubstate0
	.dw mooshStateASubstate1
	.dw @mooshStateASubstate2
	.dw mooshStateASubstate3
	.dw mooshStateASubstate4
	.dw mooshStateASubstate5
	.dw mooshStateASubstate6

;;
@mooshStateASubstate0:
	ld a,$01 ; [var03] = $01
	ld (de),a

	ld hl,wMooshState
	ld a,$20
	and (hl)
	jr z,@label_05_454

	ld a,$40
	and (hl)
	jr z,@label_05_456

;;
@mooshStateASubstate2:
	ld a,$01
	ld (de),a ; [var03] = $01

	ld e,SpecialObject.var3d
	call objectAddToAButtonSensitiveObjectList

@label_05_454:
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST
	call checkGlobalFlag
	ld a,$00
	jr z,+
	ld a,$03
+
	ld e,SpecialObject.var3f
	ld (de),a
	call specialObjectSetAnimation
	jp objectSetVisiblec3

@label_05_456:
	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	ld a,$04
	ld (de),a ; [var03] = $04

	ld a,$01
	call specialObjectSetAnimation
	jp objectSetVisiblec3

;;
mooshStateASubstate1:
	ld e,SpecialObject.var3d
	ld a,(de)
	or a
	jr z,+
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
+
	call companionSetAnimationToVar3f
	call mooshUpdateAsNpc
	ld a,(wMooshState)
	and $80
	ret z
	jr +

;;
mooshStateASubstate3:
	call companionSetAnimationToVar3f
	call mooshUpdateAsNpc
	ld a,(wMooshState)
	and $20
	ret z
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a

+
	ld e,SpecialObject.var3d
	xor a
	ld (de),a
	call objectRemoveFromAButtonSensitiveObjectList

	ld c,$01
	call companionSetAnimation
	jp companionForceMount

;;
mooshStateASubstate4:
	call mooshIncVar03
	ld bc,TX_2208
	jp showText

;;
mooshStateASubstate5:
	call retIfTextIsActive

	ld bc,-$140
	call objectSetSpeedZ
	ld l,SpecialObject.angle
	ld (hl),$10
	ld l,SpecialObject.speed
	ld (hl),SPEED_100

	ld a,$0b
	call specialObjectSetAnimation

	jp mooshIncVar03

;;
mooshStateASubstate6:
	call specialObjectAnimate

	ld e,SpecialObject.speedZ+1
	ld a,(de)
	or a
	ld c,$10
	jp nz,objectUpdateSpeedZ_paramC

	call objectApplySpeed
	ld e,SpecialObject.yh
	ld a,(de)
	cp $f0
	ret c

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wRememberedCompanionId),a

	ld hl,wMooshState
	set 6,(hl)
	jp itemDelete
.else
mooshStateA:
	ld e,SpecialObject.var03
	ld a,(de)
	rst_jumpTable
	.dw mooshStateASubstate0
	.dw mooshStateASubstate1
	.dw mooshStateASubstate2
	.dw mooshStateASubstate3
	.dw mooshStateASubstate4
	.dw mooshStateASubstate5
	.dw mooshStateASubstate6
	.dw mooshStateASubstate7
	.dw mooshStateASubstate8
	.dw mooshStateASubstate9
	.dw mooshStateASubstateA
	.dw mooshStateASubstateB
	.dw mooshStateASubstateC

mooshStateASubstate0:
	ld a,$01
	ld (de),a

	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_MOOSH
	jr nz,+
	ld a,(wMooshState)
	and $20
	jr nz,+
	ld a,$02
	ld (de),a
	ld c,$01
	call companionSetAnimation
	jr ++
+
	ld a,$00
	ld e,SpecialObject.var3f
	ld (de),a
	call specialObjectSetAnimation
++
	call objectSetVisiblec3
	ld e,SpecialObject.var3d
	jp objectAddToAButtonSensitiveObjectList

mooshStateASubstate1:
mooshStateASubstate7:
	call companionSetAnimationToVar3f
	call mooshUpdateAsNpc
	ld a,(wMooshState)
	and $80
	jr z,+
	jr ++
+
	ld e,SpecialObject.var3d
	ld a,(de)
	or a
	ret z
	ld a,$81
	ld (wDisabledObjects),a
	ret

mooshStateASubstate2:
	ld e,SpecialObject.invincibilityCounter
	ld a,(de)
	or a
	ret z
	dec a
	ld (de),a
	ld h,d
	jp updateLinkInvincibilityCounter@func_4244

mooshStateASubstate3:
	call companionSetAnimationToVar3f
	call specialObjectAnimate
	call companionDecCounter1IfNonzero
	ret nz
	ld c,$10
	jp objectUpdateSpeedZ_paramC

mooshStateASubstate4:
	call companionSetAnimationToVar3f
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld e,SpecialObject.var3e
	ld a,(de)
	or $40
	ld (de),a
	jp specialObjectAnimate

mooshStateASubstate5:
mooshStateASubstate6:
	call companionSetAnimationToVar3f
	call mooshUpdateAsNpc
	ld a,(wMooshState)
	and $20
	ret z
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
++
	ld e,SpecialObject.var3d
	xor a
	ld (de),a
	call objectRemoveFromAButtonSensitiveObjectList
	ld c,$01
	call companionSetAnimation
	jp companionForceMount

mooshStateASubstate8:
	call companionSetAnimationToVar3f
	ld e,SpecialObject.var3e
	xor a
	ld (de),a
	ld c,$10
	jp objectUpdateSpeedZ_paramC

mooshFunc_05_7aff:
	ld b,$40
	ld c,$70
	call objectGetRelativeAngle
	and $1c
	ld e,SpecialObject.angle
	ld (de),a
	ret

mooshStateASubstate9:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	call specialObjectAnimate
	call companionUpdateMovement
	ld e,SpecialObject.xh
	ld a,(de)
	cp $38
	jr c,mooshFunc_05_7aff
	ld a,$01
	ld e,SpecialObject.var3e
	ld (de),a
	jp mooshIncVar03

mooshStateASubstateA:
	call companionSetAnimationToVar3f
	ld e,SpecialObject.var3e
	ld a,(de)
	and $02
	ret z
	ld bc,TX_220f
	call showText
	jp mooshIncVar03

mooshStateASubstateB:
	call retIfTextIsActive
	call companionDismount
	ld a,$18
	ld (w1Link.angle),a
	ld (wLinkAngle),a
	ld a,$32
	ld (w1Link.speed),a
	ld bc,-$140
	call objectSetSpeedZ
	ld l,SpecialObject.angle
	ld (hl),$18
	ld l,SpecialObject.counter1
	ld (hl),$1e
	ld c,$0c
	call companionSetAnimation
	jp mooshIncVar03

mooshStateASubstateC:
	call specialObjectAnimate
	ld e,$15
	ld a,(de)
	or a
	ld c,$10
	call nz,objectUpdateSpeedZ_paramC
	ld a,(wLinkInAir)
	or a
	ret nz
	call setLinkForceStateToState08
	ld hl,w1Link.xh
	ld e,SpecialObject.xh
	ld a,(de)
	bit 7,a
	jr nz,+
	cp (hl)
	ld a,$01
	jr nc,++
+
	ld a,DIR_LEFT
++
	ld l,SpecialObject.direction
	ld (hl),a
	call companionDecCounter1IfNonzero
	ret nz
	call companionUpdateMovement
	call objectCheckWithinScreenBoundary
	ret c
	xor a
	ld (wRememberedCompanionId),a
	ld (wMenuDisabled),a
	jp itemDelete
.endif

;;
; Prevents Link from passing Moosh, calls animate.
mooshUpdateAsNpc:
	call companionPreventLinkFromPassing_noExtraChecks
	call specialObjectAnimate
	jp companionSetPriorityRelativeToLink

;;
mooshIncVar03:
	ld e,SpecialObject.var03
	ld a,(de)
	inc a
	ld (de),a
	ret


;;
specialObjectCode_raft:
.ifdef ROM_AGES
	jpab bank6.specialObjectCode_raft
.endif
