m_section_free Ages_Interactions_Bank8 NAMESPACE agesInteractionsBank08

; ==============================================================================
; INTERACID_TOGGLE_FLOOR: red/yellow/blue floor tiles that change color when jumped over.
; ==============================================================================
interactionCode15:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jp nz,@subid01


; Subid 0: this checks Link's position and spawns new instances of subid 1 when needed.
@subid00:
	call interactionDeleteAndRetIfEnabled02
	call checkInteractionState
	jr nz,@initialized

	call interactionIncState

@updateTilePos:
	ld e,Interaction.var30
	ld a,(wActiveTilePos)
	ld (de),a
	ret

@initialized:
	ld a,(wLinkInAir)
	or a
	jr z,@updateTilePos

	; Check that link's position is within 4 pixels of the tile's center on both axes
	ld a,(w1Link.yh)
	add $05
	and $0f
	sub $04
	cp $09
	ret nc
	ld a,(w1Link.xh)
	and $0f
	sub $04
	cp $09
	ret nc

	; Check that Link's tile position has changed
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	call getLinkTilePosition
	cp c
	ret z

	; Position has changed. Check that the new tile is one of the colored floor tiles.
	ld (de),a
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	sub TILEINDEX_RED_TOGGLE_FLOOR
	cp $03
	ret nc

	; Spawn an instance of this object with subid 1.
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TOGGLE_FLOOR
	inc l
	ld (hl),$01 ; [subid] = $01
	inc l
	ld (hl),c   ; [var03] = position

	ld l,Interaction.var30
	ld a,(wActiveTilePos)
	ld (hl),a
	ret


; Subid 1: toggles tile at position [var03] when Link lands.
@subid01:
	ld a,(wLinkInAir)
	or a
	ret nz

	; Get position of tile in 'c'.
	ld e,Interaction.var03
	ld a,(de)
	ld c,a

	; var30 contains Link's position from before he jumped; if he's landed on the same
	; spot, don't toggle the block.
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	call getLinkTilePosition
	cp b
	jp z,interactionDelete

	ld b,>wRoomLayout
	ld a,(bc)
	inc a
	cp TILEINDEX_RED_TOGGLE_FLOOR+3
	jr c,+
	ld a,TILEINDEX_RED_TOGGLE_FLOOR
+
	ldh (<hFF92),a
	call setTile
	ldh a,(<hFF92)
	ld b,a
	call setTileInRoomLayoutBuffer

	ld a,SND_GETSEED
	call playSound

	jp interactionDelete

;;
; @param[out]	a,l	The position of the tile Link's standing on
getLinkTilePosition:
	push bc
	ld a,(w1Link.yh)
	add $05
	and $f0
	ld b,a
	ld a,(w1Link.xh)
	swap a
	and $0f
	or b
	ld l,a
	pop bc
	ret


; ==============================================================================
; INTERACID_COLORED_CUBE
; ==============================================================================
interactionCode19:
	call objectReplaceWithAnimationIfOnHazard
	ret c
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


; State 0: initialization
@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Interaction.counter1
	ld (hl),$14 ; counter1: frames it takes to push it
	inc l
	ld (hl),$0a ; counter2: frames it takes to fall into a hole

	ld a,$06
	call objectSetCollideRadius
	call interactionInitGraphics

	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.direction
	ld (de),a

	call @setColor

	; Load palettes 6 and 7. Since it uses palette 6, you shouldn't be able to move
	; any blocks or hold anything while one of these blocks is on screen, since this
	; would interfere with the "objectMimicBgTile" function.
	ld a,PALH_89
	call loadPaletteHeader

	call @updatePosition
	jp objectSetVisible82


; State 1: waiting to be pushed
@state1:
	call interactionDecCounter2
	jr nz,+
	call objectGetTileAtPosition
	cp TILEINDEX_CRACKED_FLOOR
	jp z,@fallDownHole
+
	call @checkLinkPushingTowardBlock
	jr nz,@resetCounter1
	call interactionDecCounter1
	ret nz

; Block has been pushed for 20 frames.

	ld a,b
	swap a
	rrca
	ld e,Interaction.angle
	ld (de),a
	call interactionCheckAdjacentTileIsSolid
	jr nz,@resetCounter1

	; Set collisions to 0
	call objectGetShortPosition
	ld h,>wRoomCollisions
	ld l,a
	ld (hl),$00

	call interactionIncState
	ld l,Interaction.direction
	ldi a,(hl)
	add a
	add a
	ld b,a
	ld a,(hl)
	swap a
	rlca
	add b
	ld hl,@animations
	rst_addAToHl
	ld a,(hl)
	call interactionSetAnimation
	jr @checkAnimParameter

@resetCounter1:
	ld e,Interaction.counter1
	ld a,$14
	ld (de),a
	ret


; State 2: being pushed
@state2:
	call interactionAnimate

@checkAnimParameter:
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z
	ld b,a
	rlca
	jr c,@finishMovement

	xor a
	ld (de),a
	ld a,b
	sub $02
	ld hl,@directionOffsets
	rst_addAToHl
	ld e,Interaction.yh
	ld a,(de)
	add (hl)
	ld (de),a
	inc hl
	ld e,Interaction.xh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@finishMovement:
	ld h,d
	ld l,Interaction.state
	dec (hl)
	ld l,Interaction.counter1
	ld (hl),$14
	inc l
	ld (hl),$0a
	ld a,b
	and $7f
	ld e,Interaction.direction
	ld (de),a
	call @setColor
	call objectCenterOnTile

	ld a,SND_MOVE_BLOCK_2
	call playSound

;;
; Updates wRotatingCubePos and wRoomCollisions based on the object's current position.
@updatePosition:
	call objectGetShortPosition
	ld h,>wRoomCollisions
	ld l,a
	ld (hl),$0f
	ld (wRotatingCubePos),a

	; Push Link away? (only called once since solidity is handled by modifying
	; wRoomCollisions)
	jp objectPreventLinkFromPassing


@directionOffsets:
	.db $fc $00
	.db $00 $04
	.db $04 $00
	.db $00 $fc

;;
; @param[out]	b	Direction it's being pushed in
; @param[out]	zflag	Set if Link is pushing toward the block
@checkLinkPushingTowardBlock:
	ld a,(wLinkGrabState)
	or a
	ret nz
	ld a,(wLinkAngle)
	rlca
	ret c
	ld a,(w1Link.zh)
	rlca
	ret c

	ld a,(wGameKeysPressed)
	and (BTN_A | BTN_B)
	ret nz
	ld c,$14
	call objectCheckLinkWithinDistance
	jr nc,++
	srl a
	xor $02
	ld b,a
	ld a,(w1Link.direction)
	cp b
	ret
++
	or d
	ret

; These are the animations values to use when the tile is being pushed.
; Each row corresponds to an orientation of the cube (value of Interaction.direction).
; Each column corresponds to the direction it's being pushed in (Interaction.angle).
@animations:
	.db $12 $07 $13 $06 ; 0: yellow/red
	.db $14 $11 $15 $10 ; 1: red/yellow
	.db $16 $0b $17 $0a ; 2: red/blue
	.db $18 $09 $19 $08 ; 3: blue/red
	.db $1a $0f $1b $0e ; 4: blue/yellow
	.db $1c $0d $1d $0c ; 5: yellow/blue


;;
; Sets wRotatingCubeColor as well as the animation to use.
;
; @param	a	Orientation of cube (value of Interaction.direction)
@setColor:
	ld b,a
	ld hl,@colors
	rst_addAToHl
	ld a,(hl)
	ld (wRotatingCubeColor),a
	ld a,b
	jp interactionSetAnimation

@colors:
	.db $01 $00 $00 $02 $02 $01


@fallDownHole:
	ld c,l
	ld a,TILEINDEX_HOLE
	call setTile
	call objectCreateFallingDownHoleInteraction
	jp interactionDelete


; ==============================================================================
; INTERACID_COLORED_CUBE_FLAME
; ==============================================================================
interactionCode1a:
	call checkInteractionState
	jr nz,@initialized
	ld a,(wRotatingCubePos)
	or a
	ret z

	call @updateColor
	call interactionInitGraphics
	call objectSetVisible82
	call interactionIncState

@initialized:
	ld a,(wRotatingCubeColor)
	rlca
	jp nc,objectSetInvisible
	call objectSetVisible
	call @updateColor
	jp interactionAnimate

@updateColor:
	ld a,(wRotatingCubeColor)
	and $7f
	ld hl,@palettes
	rst_addAToHl
	ld e,Interaction.oamFlags
	ld a,(de)
	and $f8
	or (hl)
	ld (de),a
	ret

@palettes:
	.db $02 $03 $01


; ==============================================================================
; INTERACID_MINECART_GATE
; ==============================================================================
interactionCode1b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a

	; Move bits 4-7 of subid to bits 0-3 (direction of gate)
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	swap a
	and $0f
	ld (de),a

	; Set var03 to a bitmask based on bits 0-2 of subid
	ld a,b
	and $07
	ld hl,bitTable
	add l
	ld l,a
	inc e
	ld a,(hl)
	ld (de),a

	call interactionInitGraphics
	call objectSetVisible82

	call @setAnimationAndUpdateCollisions
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	and $01
	inc a
	ld e,Interaction.state
	ld (de),a
	ld a,b
	xor $01
	jp interactionSetAnimation

;;
; Sets var30 to the animation to be done. Bit 0 set if the gate is open.
; Also modifies tile collisions appropriately.
@setAnimationAndUpdateCollisions:
	ld a,(wSwitchState)
	ld b,a
	ld e,Interaction.var03
	ld a,(de)
	and b
	ld c,$00
	jr nz,+
	ld c,$01
+
	dec e
	ld a,(de) ; a = [subid] (subid is 0 if facing left, 2 if facing right)
	or c
	ld e,Interaction.var30
	ld (de),a

	call interactionSetAnimation

	call objectGetTileAtPosition
	dec h ; h points to wRoomCollisions
	dec l

	; a = [var30]*3
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	add a
	add b

	ld bc,@collisions
	call addAToBc
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ld (hl),a

	inc bc
	ld a,(bc)
	add l
	ld l,a
	inc h
	ld a,(de)
	rrca
	jr c,+
	ld (hl),$5e
	ret
+
	ld (hl),$00
	ret

@collisions:
	.db $00 $0a  $ff ; Gate facing right
	.db $0c $0a  $ff
	.db $05 $00  $00 ; Gate facing left
	.db $05 $0c  $00


; State 1: waiting for switch to be pressed
@state1:
	call objectSetPriorityRelativeToLink
	ld a,(wSwitchState)
	cpl
	jr ++

; State 2: waiting for switch to be released
@state2:
	call objectSetPriorityRelativeToLink
	ld a,(wSwitchState)
++
	ld b,a
	ld e,Interaction.var03
	ld a,(de)
	and b
	ret z

	ld e,Interaction.state
	ld a,$03
	ld (de),a
	ld a,SND_OPEN_GATE
	call playSound
	jp @setAnimationAndUpdateCollisions


; State 3: in the process of opening or closing
@state3:
	call interactionAnimate
	call objectSetPriorityRelativeToLink

	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	ret nz

	ld e,Interaction.var30
	ld a,(de)
	and $01
	inc a
	ld e,Interaction.state
	ld (de),a
	ret


; ==============================================================================
; INTERACID_SPECIAL_WARP
; ==============================================================================
interactionCode1f:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

; Subid 0: Trigger a warp when Link dives touching this object
@subid0:
	call checkInteractionState
	jr z,@@initialize

	; Check that Link has collided with this object, he's not holding anything, and
	; he's diving.
	ld a,(wLinkSwimmingState)
	rlca
	ret nc
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc

	ld e,Interaction.var03
	ld a,(de)
	ld hl,@@warpData
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ld a,(hl)
	ld (wWarpDestPos),a
	ld a,$87
	ld (wWarpDestGroup),a
	ld a,$01
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
	jp interactionDelete

@@warpData:
	.db $09 $01
	.db $05 $03

@@initialize:
	ld a,$01
	ld (de),a
	ld a,$02
	call objectSetCollideRadius

	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var03
	ld (hl),a

	ld l,Interaction.yh
	ld c,(hl)
	jp setShortPosition_paramC


; Subid 1: a warp at the top of a waterfall
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid1State0
	.dw @subid1State1
	.dw @subid1State2

@subid1State0:
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_DIMITRI
	jp nz,interactionDelete

	ld bc,$0810
	call objectSetCollideRadii
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	call nc,interactionIncState
	jp interactionIncState

@subid1State1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret c
	jp interactionIncState

@subid1State2:
	ld a,d
	ld (wDisableWarpTiles),a
	ld a,(wLinkObjectIndex)
	cp >w1Companion
	ret nz
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	ld hl,@@warpDestVariables
	jp setWarpDestVariables

@@warpDestVariables:
	m_HardcodedWarpA ROOM_AGES_5b8, $00, $93, $03


; Subid 2: a warp in a cave in a waterfall
@subid2:
	ld a,d
	ld (wDisableScreenTransitions),a
	call checkInteractionState
	jr z,@@initialize

	call checkLinkCollisionsEnabled
	ret nc
	ld a,(wLinkObjectIndex)
	bit 0,a
	ret z

	ld h,a
	ld l,<w1Companion.yh
	ld a,(hl)
	cp $a8
	ret c

	ld a,$ff
	ld (wDisabledObjects),a

	ld hl,@@warpDestVariables
	call setWarpDestVariables
	jp interactionDelete

@@warpDestVariables:
	m_HardcodedWarpB ROOM_AGES_037, $0e, $22, $03

@@initialize:
	call interactionIncState
	jp interactionSetAlwaysUpdateBit


; ==============================================================================
; INTERACID_DUNGEON_SCRIPT
; ==============================================================================
interactionCode20:
	call interactionDeleteAndRetIfEnabled02
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a

	xor a
	ld ($cfc1),a
	ld ($cfc2),a

	ld a,(wDungeonIndex)
	cp $ff
	jp z,interactionDelete

	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,Interaction.subid
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionRunScript

@state2:
	call objectPreventLinkFromPassing

@state1:
	call interactionRunScript
	ret nc
	jp interactionDelete

@scriptTable:
	.dw @dungeon0
	.dw @dungeon1
	.dw @dungeon2
	.dw @dungeon3
	.dw @dungeon4
	.dw @dungeon5
	.dw @dungeon6
	.dw @dungeon7
	.dw @dungeon8
	.dw @dungeon9
	.dw @dungeona
	.dw @dungeonb
	.dw @dungeonc
	.dw @dungeond

@dungeon0:
@dungeond:
	.dw mainScripts.makuPathScript_spawnChestWhenActiveTriggersEq01
	.dw mainScripts.makuPathScript_spawnDownStairsWhenEnemiesKilled
	.dw mainScripts.makuPathScript_spawn30Rupees
	.dw mainScripts.makuPathScript_keyFallsFromCeilingWhen1TorchLit
	.dw mainScripts.makuPathScript_spawnUpStairsWhen2TorchesLit
@dungeon1:
	.dw mainScripts.dungeonScript_spawnChestOnTriggerBit0
	.dw mainScripts.spiritsGraveScript_spawnBracelet
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.spiritsGraveScript_stairsToBraceletRoom
	.dw mainScripts.spiritsGraveScript_spawnMovingPlatform
@dungeon2:
	.dw mainScripts.wingDungeonScript_spawnFeather
	.dw mainScripts.wingDungeonScript_spawn30Rupees
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.wingDungeonScript_bossDeath
@dungeon3:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.moonlitGrottoScript_spawnChestWhen2TorchesLit
@dungeon4:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.skullDungeonScript_spawnChestWhenOrb0Hit
	.dw mainScripts.skullDungeonScript_spawnChestWhenOrb1Hit
@dungeon5:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.crownDungeonScript_spawnChestWhen3TriggersActive
@dungeon6:
	.dw mainScripts.dungeonScript_minibossDeath
@dungeon7:
	.dw mainScripts.dungeonScript_bossDeath
@dungeon8:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.ancientTombScript_spawnSouthStairsWhenTrigger0Active
	.dw mainScripts.ancientTombScript_spawnNorthStairsWhenTrigger0Active
	.dw mainScripts.ancientTombScript_retractWallWhenTrigger0Active
	.dw mainScripts.ancientTombScript_spawnDownStairsWhenEnemiesKilled
	.dw mainScripts.ancientTombScript_spawnVerticalBridgeWhenTorchLit
@dungeon9:
@dungeona:
@dungeonb:
	.dw mainScripts.dungeonScript_spawnChestOnTriggerBit0
	.dw mainScripts.herosCaveScript_spawnChestWhen4TriggersActive
	.dw mainScripts.herosCaveScript_spawnBridgeWhenTriggerPressed
	.dw mainScripts.herosCaveScript_spawnNorthStairsWhenEnemiesKilled
@dungeonc:
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.mermaidsCaveScript_spawnBridgeWhenOrbHit
	.dw mainScripts.mermaidsCaveScript_updateTrigger2BasedOnTriggers0And1


; ==============================================================================
; INTERACID_DUNGEON_EVENTS
; ==============================================================================
interactionCode21:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interactionDelete
	.dw interaction21_subid01
	.dw interaction21_subid02
	.dw interaction21_subid03
	.dw interaction21_subid04
	.dw interaction21_subid05
	.dw interaction21_subid06
	.dw interaction21_subid07
	.dw interaction21_subid08
	.dw interaction21_subid09
	.dw interaction21_subid0a
	.dw interaction21_subid0b
	.dw interaction21_subid0c
	.dw interaction21_subid0d
	.dw interaction21_subid0e
	.dw interaction21_subid0f
	.dw interaction21_subid10
	.dw interaction21_subid11
	.dw interaction21_subid12
	.dw interaction21_subid13
	.dw interaction21_subid14
	.dw interaction21_subid15
	.dw interaction21_subid16
	.dw interaction21_subid17
	.dw interaction21_subid18
	.dw interaction21_subid19


; D2: Verify a 2x2 floor pattern
interaction21_subid01:
	call interactionDeleteAndRetIfItemFlagSet
	ld hl,subid01_tileData

verifyTilesAndDropSmallKey:
	call verifyTiles
	ret nz
	jp spawnSmallKeyFromCeiling

subid01_tileData:
	.db TILEINDEX_YELLOW_TOGGLE_FLOOR  $67 $77 $ff ; Tiles at $67 and $77 must be red
	.db TILEINDEX_BLUE_TOGGLE_FLOOR    $68 $78 $00 ; Tiles at $68 and $78 must be blue


; D2: Verify a floor tile is red to open a door
interaction21_subid02:
	ld a,(wRoomLayout+$5a)
	cp TILEINDEX_RED_TOGGLE_FLOOR
	ld a,$01
	jr z,+
	dec a
+
	ld (wActiveTriggers),a
	ret


; Light torches when a colored cube rolls into this position.
interaction21_subid03:
	call checkInteractionState
	jr nz,@initialized

	call interactionIncState
	call objectGetTileAtPosition
	ld a,(wRotatingCubePos)
	ld e,Interaction.var03
	ld (de),a
	cp l
	call z,@lightCubeTorches

@initialized:
	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	ld a,(wRotatingCubePos)
	cp b
	ret z

	call objectGetTileAtPosition
	ld a,(wRotatingCubePos)
	cp l
	call z,@lightCubeTorches
	ld a,(wRotatingCubePos)
	ld e,Interaction.var03
	ld (de),a
	ret

@lightCubeTorches:
	ld hl,wRotatingCubeColor
	set 7,(hl)
	ld a,SND_LIGHTTORCH
	jp playSound


; d2: Set torch color based on the color of the tile at this position.
interaction21_subid04:
	call checkInteractionState
	jr nz,@initialized

	call interactionIncState
	call objectGetTileAtPosition
	ld e,Interaction.var03
	ld (de),a
	sub TILEINDEX_RED_TOGGLE_FLOOR
	set 7,a
	ld (wRotatingCubeColor),a
	ld a,$57
	ld (wRotatingCubePos),a

@initialized:
	call objectGetTileAtPosition
	ld b,a
	sub TILEINDEX_RED_TOGGLE_FLOOR
	cp $03
	ret nc

	ld e,Interaction.var03
	ld a,(de)
	cp b
	ret z

	ld a,b
	ld (de),a
	sub TILEINDEX_RED_TOGGLE_FLOOR
	set 7,a
	ld (wRotatingCubeColor),a
	ret


; d2: Drop a small key here when a colored block puzzle has been solved.
interaction21_subid05:
	call interactionDeleteAndRetIfItemFlagSet
	ld hl,@tileData
	jp verifyTilesAndDropSmallKey

@tileData:
	.db TILEINDEX_RED_PUSHABLE_BLOCK     $49 $4b $69 $6b $ff
	.db TILEINDEX_YELLOW_PUSHABLE_BLOCK  $5a $ff
	.db TILEINDEX_BLUE_PUSHABLE_BLOCK    $4a $59 $5b $6a $00


; d2: Set trigger 0 when the colored flames are lit red.
interaction21_subid06:
	ld b,$80
	jr ++

; d1: Set trigger 0 when the colored flames are lit blue.
interaction21_subid19:
	ld b,$82
++
	ld a,(wRotatingCubeColor)
	cp b
	ld a,$01
	jr z,+
	dec a
+
	ld (wActiveTriggers),a
	ret


; Toggle a bit in wSwitchState based on whether a toggleable floor tile at position Y is
; blue. The bitmask to use is X.
interaction21_subid07:
	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	sub TILEINDEX_RED_TOGGLE_FLOOR
	cp $03
	ret nc

	ld a,(bc)
	cp TILEINDEX_RED_TOGGLE_FLOOR
	jr z,unsetSwitch
	cp TILEINDEX_YELLOW_TOGGLE_FLOOR
	jr z,unsetSwitch

setSwitch:
	ld e,Interaction.xh
	ld a,(de)
	ld hl,wSwitchState
	or (hl)
	ld (hl),a
	ret

unsetSwitch:
	ld e,Interaction.xh
	ld a,(de)
	cpl
	ld hl,wSwitchState
	and (hl)
	ld (hl),a
	ret


; Toggle a bit in wSwitchState based on whether blue flames are lit. The bitmask to use is
; X.
interaction21_subid08:
	ld hl,wRotatingCubeColor
	bit 7,(hl)
	ret z
	res 7,(hl)
	ld a,(hl)
	cp $02
	jr z,setSwitch
	jr unsetSwitch


; d3: Drop a small key when 3 blocks have been pushed.
interaction21_subid09:
	call interactionDeleteAndRetIfItemFlagSet
	ld hl,@tileData
	jp verifyTilesAndDropSmallKey

@tileData:
	.db TILEINDEX_PUSHABLE_BLOCK $3b $59 $5d $00


; d3: When an orb is hit, spawn an armos, as well as interaction which will spawn a chest
; when it's killed.
interaction21_subid0a:
	call checkInteractionState
	jr nz,@initialized

	ld hl,wToggleBlocksState
	res 4,(hl)

	ld hl,objectData.moonlitGrotto_orb
	call parseGivenObjectData

	call interactionDeleteAndRetIfItemFlagSet
	call interactionIncState

@initialized:
	ld hl,wToggleBlocksState
	bit 4,(hl)
	ret z

	; Do something with the chest?
	ld a,$01
	ld ($cca2),a

	ld hl,objectData.moonlitGrotto_onOrbActivation
	call parseGivenObjectData

	jp interactionDelete


; Unused? A chest appears when 4 torches in a diamond formation are lit?
interaction21_subid0b:
	call checkInteractionState
	jr nz,@initialized

	call getThisRoomFlags
	and $80
	jp nz,interactionDelete

	ld hl,objectData.objectData77d4
	call parseGivenObjectData

	ldbc $4b,$35
	call makeTorchAtPositionTemporarilyLightable
	jp nz,interactionDelete

	ldbc $4b,$53
	call makeTorchAtPositionTemporarilyLightable
	jp nz,interactionDelete

	ldbc $4b,$57
	call makeTorchAtPositionTemporarilyLightable
	jp nz,interactionDelete

	ldbc $4b,$75
	call makeTorchAtPositionTemporarilyLightable
	jp nz,interactionDelete

	call interactionIncState

@initialized:
	ld a,(wNumTorchesLit)
	cp $04
	ret nz
	ld hl,wDisabledObjects
	set 3,(hl)
	call getThisRoomFlags
	set 7,(hl)
	ld a,$01
	ld (wActiveTriggers),a
	jp interactionDelete


; d3: 4 armos spawn when trigger 0 is activated.
interaction21_subid0c:
	ld a,(wActiveTriggers)
	or a
	ret z
	ld ($cca2),a
	ld hl,objectData.moonlitGrotto_onArmosSwitchPressed
	call parseGivenObjectData
	jp interactionDelete


; d3: Crystal breakage handler
interaction21_subid0d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw interactionRunScript
	.dw @state3

@state0:
	ld a,GLOBALFLAG_D3_CRYSTALS
	call checkGlobalFlag
	jp nz,interactionDelete
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete

	ld a,(wSwitchState)
	ld e,Interaction.counter2
	ld (de),a
	jp interactionIncState

@state1:
	ld a,(wSwitchState)
	ld b,a
	ld e,Interaction.counter2
	ld a,(de)
	cp b
	ret z

	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wDisableScreenTransitions),a
	ld (wDisableWarpTiles),a

	ld hl,mainScripts.moonlitGrottoScript_brokeCrystal
	call interactionSetScript
	call interactionRunScript
	jp interactionIncState

@state3:
	ld a,(wSwitchState)
	and $f0
	cp $f0
	jr nz,@enableControl

	ld a,$02
	ld (wScreenShakeMagnitude),a

	ld hl,mainScripts.moonlitGrottoScript_brokeAllCrystals
	call interactionSetScript

	ld e,Interaction.state
	ld a,$02
	ld (de),a

	xor a
	ld (wSpinnerState),a
	ret

@enableControl:
	jpab scriptHelp.moonlitGrotto_enableControlAfterBreakingCrystal


; d3: Small key falls when a block is pushed into place
interaction21_subid0e:
	call interactionDeleteAndRetIfItemFlagSet
	ld hl,wRoomLayout+$4a
	ld a,(hl)
	cp $2a
	ret nz
	jp spawnSmallKeyFromCeiling


; d4: A door opens when a certain floor pattern is achieved
interaction21_subid0f:
	call interactionDeleteAndRetIfEnabled02
	ld hl,@tileData
	call verifyTiles
	ld a,$01
	jr z,+
	dec a
+
	ld (wActiveTriggers),a
	ret

@tileData:
	.db TILEINDEX_RED_TOGGLE_FLOOR    $43 $45 $64 $ff
	.db TILEINDEX_YELLOW_TOGGLE_FLOOR $54 $63 $65 $ff
	.db TILEINDEX_BLUE_TOGGLE_FLOOR   $44 $53 $55 $00


; d4: A small key falls when a certain froor pattern is achieved
interaction21_subid10:
	call interactionDeleteAndRetIfEnabled02
	call interactionDeleteAndRetIfItemFlagSet
	ld hl,@tileData
	jp verifyTilesAndDropSmallKey

@tileData:
	.db TILEINDEX_RED_TOGGLE_FLOOR  $54 $58 $ff
	.db TILEINDEX_BLUE_TOGGLE_FLOOR $55 $57 $00


; Tile-filling puzzle: when all the blue turns red, a chest will spawn here.
interaction21_subid11:
	call interactionDeleteAndRetIfEnabled02
	call interactionDeleteAndRetIfItemFlagSet

	ld a,TILEINDEX_BLUE_FLOOR
	call findTileInRoom
	ret z

spawnChestAndDeleteSelf:
	ld a,SND_SOLVEPUZZLE
	call playSound
	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_CHEST
	call setTile
	call objectCreatePuff
	jp interactionDelete


; d4: A chest spawns here when the torches light up with the color blue.
interaction21_subid12:
	call interactionDeleteAndRetIfItemFlagSet
	ld a,(wRotatingCubeColor)
	bit 7,a
	ret z
	and $03
	cp $02
	ret nz
	jr spawnChestAndDeleteSelf


; d5: A chest spawns here when all the spaces around the owl statue are filled.
interaction21_subid13:
	call interactionDeleteAndRetIfEnabled02
	call interactionDeleteAndRetIfItemFlagSet
	ld b,>wRoomLayout
	ld hl,@positionsToCheck
@next:
	ldi a,(hl)
	or a
	jr z,spawnChestAndDeleteSelf
	ld c,a
	ld a,(bc)
	sub TILEINDEX_RED_PUSHABLE_BLOCK
	cp $03
	jr c,@next
	ret

@positionsToCheck: ; The positions in a circle around the owl statue
	.db $47 $48 $49 $57 $59 $67 $68 $69 $00


; d5: A chest spawns here when two blocks are pushed to the right places
interaction21_subid14:
	call interactionDeleteAndRetIfEnabled02
	call interactionDeleteAndRetIfItemFlagSet
	ld hl,@tileData
	call verifyTiles
	ret nz
	jp spawnChestAndDeleteSelf

@tileData:
	.db TILEINDEX_PUSHABLE_STATUE  $45 $49 $00


; d5: Cane of Somaria chest spawns here when blocks are pushed into a pattern
interaction21_subid15:
	call interactionDeleteAndRetIfEnabled02
	call interactionDeleteAndRetIfItemFlagSet
	ld hl,@tileData
	call verifyTiles
	ret nz
	jp spawnChestAndDeleteSelf

@tileData:
	.db TILEINDEX_RED_PUSHABLE_BLOCK    $54 $62 $ff
	.db TILEINDEX_YELLOW_PUSHABLE_BLOCK $33 $52 $ff
	.db TILEINDEX_BLUE_PUSHABLE_BLOCK   $44 $73 $00


; d5: Sets floor tiles to show a pattern when a switch is held down.
interaction21_subid16:
	call interactionDeleteAndRetIfEnabled02
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interaction21_subid16_state1

@state0:
	ld a,(wActiveTriggers)
	or a
	ret z

	call interactionIncState

	ld c,$5c
	ld a,TILEINDEX_RED_TOGGLE_FLOOR
	call setTileWithPuff

	ld c,$6a
	ld a,TILEINDEX_RED_TOGGLE_FLOOR
	call setTileWithPuff

	ld c,$3b
	ld a,TILEINDEX_YELLOW_TOGGLE_FLOOR
	call setTileWithPuff

	ld c,$5a
	ld a,TILEINDEX_YELLOW_TOGGLE_FLOOR
	call setTileWithPuff

	ld c,$4c
	ld a,TILEINDEX_BLUE_TOGGLE_FLOOR
	call setTileWithPuff

	ld c,$7b
	ld a,TILEINDEX_BLUE_TOGGLE_FLOOR
	jr setTileWithPuff

setTileToStandardFloor:
	ld a,TILEINDEX_STANDARD_FLOOR

setTileWithPuff:
	call setTile

;;
; @param	c	Position to create puff at
createPuffAt:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	jp setShortPosition_paramC

interaction21_subid16_state1:
	ld a,(wActiveTriggers)
	or a
	ret nz

	ld c,$5c
	call setTileToStandardFloor
	ld c,$6a
	call setTileToStandardFloor
	ld c,$3b
	call setTileToStandardFloor
	ld c,$5a
	call setTileToStandardFloor
	ld c,$4c
	call setTileToStandardFloor
	ld c,$7b
	call setTileToStandardFloor

	ld e,Interaction.state
	xor a
	ld (de),a
	ret


; Create a chest at position Y which appears when [wActiveTriggers] == X, but which also
; disappears when the trigger is released.
interaction21_subid17:
	call interactionDeleteAndRetIfEnabled02
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete

	ld e,Interaction.xh
	ld a,(de)
	ld b,a
	ld a,(wActiveTriggers)
	cp b
	jr nz,@triggerInactive

@triggerActive:
	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	cp TILEINDEX_CHEST
	ret z

	ld a,TILEINDEX_CHEST
	call setTile
	call createPuffAt
	ld a,SND_SOLVEPUZZLE
	jp playSound

@triggerInactive:
	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	cp TILEINDEX_CHEST
	ret nz

	; Retrieve whatever tile was there before the chest
	ld a,:w3RoomLayoutBuffer
	ld ($ff00+R_SVBK),a
	ld b,>w3RoomLayoutBuffer
	ld a,(bc)
	ld l,a
	xor a
	ld ($ff00+R_SVBK),a

	ld a,l
	call setTile
	jp createPuffAt


; d3: Calculate the value for [wSwitchState] based on which crystals are broken.
interaction21_subid18:
	call getThisRoomFlags
	ld b,$00

	ld l,<ROOM_AGES_45d
	bit 6,(hl)
	jr z,+
	set 4,b
+
	ld l,<ROOM_AGES_45f
	bit 6,(hl)
	jr z,+
	set 5,b
+
	ld l,<ROOM_AGES_461
	bit 6,(hl)
	jr z,+
	set 6,b
+
	ld l,<ROOM_AGES_463
	bit 6,(hl)
	jr z,+
	set 7,b
+
	ld a,(wSwitchState)
	or b
	ld (wSwitchState),a
	jp interactionDelete


;;
interactionDeleteAndRetIfItemFlagSet:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ret z
	pop hl
	jp interactionDelete

;;
spawnSmallKeyFromCeiling:
	ldbc TREASURE_SMALL_KEY, $01
	call createTreasure
	ret nz
	call objectCopyPosition
	jp interactionDelete

;;
; Verifies that certain tiles in the room layout equal specified values.
;
; @param	hl	Data structure where the first byte is a tile index, and
;			subsequent bytes are positions where the tile is expected to equal
;			that index. Value $ff starts a new "group", and $00 ends the
;			structure.
; @param[out]	zflag	Set if the tiles all match the expected values.
verifyTiles:
	ld b,>wRoomLayout
@nextTileIndex:
	ldi a,(hl)
	or a
	ret z
	ld e,a
@nextPosition:
	ldi a,(hl)
	ld c,a
	or a
	ret z
	inc a
	jr z,@nextTileIndex
	ld a,(bc)
	cp e
	ret nz
	jr @nextPosition

;;
; @param	b	Number of frames it can stay lit before burning out
; @param	c	Position
; @param[out]	zflag	Set if the part object was created successfully
makeTorchAtPositionTemporarilyLightable:
	call getFreePartSlot
	ret nz

	ld (hl),PARTID_LIGHTABLE_TORCH
	inc l
	ld (hl),$01
	ld l,Part.counter2
	ld (hl),b
	ld l,Part.yh
	call setShortPosition_paramC
	xor a
	ret


; ==============================================================================
; INTERACID_FLOOR_COLOR_CHANGER
; ==============================================================================
interactionCode22:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

; Subid 0: the "controller"; detects when the tile has been changed.
@subid0:
	call checkInteractionState
	jr nz,++

	call objectGetTileAtPosition
	ld e,Interaction.var03
	ld (de),a
	call interactionIncState
++
	; Check if the tile changed color
	call objectGetTileAtPosition
	ld e,Interaction.var03
	ld a,(de)
	cp (hl)
	ret z

	ld a,(hl)
	sub TILEINDEX_RED_TOGGLE_FLOOR
	cp $03
	ret nc

	ld a,(hl)
	ld (de),a
	sub TILEINDEX_RED_TOGGLE_FLOOR
	add TILEINDEX_RED_FLOOR
	ld b,a
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_FLOOR_COLOR_CHANGER
	inc l
	ld (hl),$01 ; [subid] = $01

	; Set var03 to the tile index to convert tiles to
	ld l,Interaction.var03
	ld (hl),b

	jp objectCopyPosition


; Subid 1: performs the updates to all tiles in the room in a random order.
@subid1:
	call checkInteractionState
	jr nz,@@initialized

	call objectGetTileAtPosition
	ld e,Interaction.var30
	ld (de),a
	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),$ff

	; Generate all values from $00-$ff in a random order, and copy those values to
	; wBigBuffer.
	callab roomInitialization.generateRandomBuffer
	ld a,:w4RandomBuffer
	ld ($ff00+R_SVBK),a
	ld hl,w4RandomBuffer
	ld de,wBigBuffer
	ld b,$00
	call copyMemory
	ld a,$01
	ld ($ff00+R_SVBK),a

	ldh a,(<hActiveObject)
	ld d,a

@@initialized:
	call objectGetTileAtPosition
	ld e,Interaction.var30
	ld a,(de)
	cp (hl)
	jp z,++
	ld a,(hl)
	cp TILEINDEX_SOMARIA_BLOCK
	jp nz,interactionDelete
++
	ld a,l
	ldh (<hFF8C),a
	call @convertNextTile
	jr z,@done
	call @convertNextTile
	jr z,@done
	call @convertNextTile
	jr z,@done
	call @convertNextTile
	ret nz
@done:
	call @convertNextTile
	jp interactionDelete

;;
; @param	hFF8C	Position of this object
; @param[out]	zflag	Set if we've converted the last tile
@convertNextTile:
	ld e,Interaction.counter1
	ld a,(de)
	ld hl,wBigBuffer
	rst_addAToHl
	ldh a,(<hFF8C)
	ld c,a
	ld a,(hl) ; Get next position to update in 'a'

	; Check that the position is in-bounds, and is not this object's position
	cp LARGE_ROOM_HEIGHT*16 - 17
	jr nc,@decCounter1
	cp c
	jr z,@decCounter1

	; Position can't be on the screen edge (but it doesn't appear to check the right
	; edge?)
	and $0f
	jr z,@decCounter1
	ld a,(hl)
	and $f0
	jr z,@decCounter1
	cp LARGE_ROOM_HEIGHT*16 - 16
	jr z,@decCounter1

	; Check if this is a tile that should be replaced
	ld a,(hl)
	ld l,a
	ld h,>wRoomLayout
	ld a,(hl)
	sub TILEINDEX_RED_FLOOR
	cp $03
	jr nc,@notColoredFloor

	; Replace the tile
	ld e,Interaction.var03
	ld a,(de)
	ld c,l
	call setTile
@decCounter1:
	jp interactionDecCounter1

@notColoredFloor:
	; If it's not a colored floor, we should at least change the tile "underneath" it
	; in w3RoomLayoutBuffer, in case it's pushable or something.
	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	ld c,l
	call setTileInRoomLayoutBuffer
	jp interactionDecCounter1

; ==============================================================================
; INTERACID_EXTENDABLE_BRIDGE
; ==============================================================================
interactionCode23:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	and $07
	ld hl,bitTable
	add l
	ld l,a
	ld a,(hl)
	inc e
	ld (de),a ; [var03] = bitmask corresponding to [subid]

	; Check whether the tile here is a bridge; go to state 2 if so, state 1 otherwise
	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	sub TILEINDEX_VERTICAL_BRIDGE
	sub $06
	ld a,$02
	jr c,+
	dec a
+
	ld e,Interaction.state
	ld (de),a
	ld e,Interaction.var30
	ld a,(wSwitchState)
	ld (de),a
	ret

; State 1: waiting for switch to toggle to create bridge
@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state1Substate0
	.dw @state1Substate1

@state1Substate0:
	call @checkSwitchStateChanged
	ret z
	ld hl,@bridgeCreationData

@startLoadingBridgeData:
	ld e,Interaction.var30
	ld a,(wSwitchState)
	ld (de),a

	ld e,Interaction.xh
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	ld e,Interaction.var31
	ld (de),a
	ld e,Interaction.relatedObj2
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld a,$0a
	ld e,Interaction.counter1
	ld (de),a
	jp interactionIncSubstate

@state1Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$0a
	call @updateNextTile
	ld a,c
	inc a
	jr z,@gotoNextState
	ld e,Interaction.var31
	ld a,(de)
	call setTile
	ld a,SND_DOORCLOSE
	jp playSound

@gotoNextState:
	call interactionIncState
	inc l
	ld (hl),$00
	ret

; State 2: waiting for switch to toggle to remove bridge
@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state2Substate0
	.dw @state2Substate1

@state2Substate0:
	call @checkSwitchStateChanged
	ret z
	ld hl,@bridgeRemovalData
	jr @startLoadingBridgeData

@state2Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$0a

	call @updateNextTile
	ld a,c
	inc a
	jr z,@gotoState1
	ld e,Interaction.var31
	ld a,(de)
	call setTile
	ld a,SND_DOORCLOSE
	jp playSound

@gotoState1:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	inc l
	ld (hl),$00
	ret

;;
; @param[out]	zflag	nz if the switch has been toggled
@checkSwitchStateChanged:
	ld a,(wSwitchState)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	xor b
	ld b,a
	ld e,Interaction.var03
	ld a,(de)
	and b
	ret

;;
; @param[out]	c	Next byte
@updateNextTile:
	ld h,d
	ld l,Interaction.relatedObj2
	ld e,l
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	ld c,a

	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret


; Which data is read from here depends on the value of "Interaction.xh".
@bridgeCreationData:
	.dw @creation0
	.dw @creation1
	.dw @creation2
	.dw @creation3
	.dw @creation4
	.dw @creation5
	.dw @creation6

; Data format:
;   First byte is the tile index to create for the bridge.
;   Subsequent bytes are positions at which to create that tile until it reaches $ff.

@creation0:
	.db TILEINDEX_VERTICAL_BRIDGE   $43 $53 $63 $ff
@creation1:
	.db TILEINDEX_HORIZONTAL_BRIDGE $76 $77 $78 $79 $ff
@creation2:
	.db TILEINDEX_HORIZONTAL_BRIDGE $39 $38 $37 $36 $ff
@creation3:
	.db TILEINDEX_VERTICAL_BRIDGE   $42 $52 $62 $ff
@creation4:
	.db TILEINDEX_VERTICAL_BRIDGE   $4c $5c $6c $ff
@creation5:
	.db TILEINDEX_HORIZONTAL_BRIDGE $2a $29 $28 $27 $ff
@creation6:
	.db TILEINDEX_VERTICAL_BRIDGE   $3d $4d $5d $6d $ff


@bridgeRemovalData:
	.dw @removal0
	.dw @removal1
	.dw @removal2
	.dw @removal3
	.dw @removal4
	.dw @removal5
	.dw @removal6

; Data format is the same as above.
; TILEINDEX_HOLE+1 is a hole that's completely black (doesn't have "ground" surrounding
; it.)

@removal0:
	.db TILEINDEX_HOLE+1  $63 $53 $43 $ff
@removal1:
	.db TILEINDEX_HOLE+1  $79 $78 $77 $76 $ff
@removal2:
	.db TILEINDEX_HOLE+1  $36 $37 $38 $39 $ff
@removal3:
	.db TILEINDEX_HOLE+1  $62 $52 $42 $ff
@removal4:
	.db TILEINDEX_HOLE+1  $6c $5c $4c $ff
@removal5:
	.db TILEINDEX_HOLE+1  $27 $28 $29 $2a $ff
@removal6:
	.db TILEINDEX_HOLE+1  $6d $5d $4d $3d $ff


; ==============================================================================
; INTERACID_TRIGGER_TRANSLATOR
; ==============================================================================
interactionCode24:
	call interactionDeleteAndRetIfEnabled02
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

; Subid 0: control a bit in wActiveTriggers based on wToggleBlocksState.
@subid0:
	ld a,(wToggleBlocksState)
	ld c,a

@label_08_081:
	ld e,Interaction.subid
	ld a,(de)
	swap a
	and $07
	ld hl,bitTable
	add l
	ld l,a

	ld a,c
	and (hl)
	ld b,a
	ld a,(hl)
	cpl
	ld c,a
	ld a,(wActiveTriggers)
	and c
	or b
	ld (wActiveTriggers),a
	ret

; Subid 0: control a bit in wActiveTriggers based on wSwitchState.
@subid1:
	ld a,(wSwitchState)
	ld c,a
	jr @label_08_081

; Subid 2: check that [wNumLitTorches] == Y.
@subid2:
	ld e,Interaction.yh
	ld a,(de)
	ld b,a
	ld e,Interaction.xh
	ld a,(de)
	ld c,a
	ld a,(wNumTorchesLit)
	cp b
	jr nz,++
	ld a,(wActiveTriggers)
	or c
	ld (wActiveTriggers),a
	ret
++
	ld a,c
	cpl
	ld c,a
	ld a,(wActiveTriggers)
	and c
	ld (wActiveTriggers),a
	ret


; ==============================================================================
; INTERACID_TILE_FILLER
; ==============================================================================
interactionCode25:
	call returnIfScrollMode01Unset
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_YELLOW_FLOOR
	call setTile

	ld a,c
	ld e,Interaction.var30
	ld (de),a

	call getFreeInteractionSlot
	jr nz,@state1
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	call setShortPosition_paramC

@state1:
	; Check if Link's position has changed
	callab getLinkTilePosition
	ld e,Interaction.var30
	ld a,(de)
	cp l
	ret z

	; Check that the position changed by exactly one tile horizontally or vertically
	ld b,a
	ld a,l
	add $f0
	cp b
	jr z,@updateFloor
	ld a,l
	inc a
	cp b
	jr z,@updateFloor
	ld a,l
	add $10
	cp b
	jr z,@updateFloor
	ld a,l
	dec a
	cp b
	ret nz

@updateFloor:
	ld h,>wRoomLayout
	ld a,(hl)
	cp TILEINDEX_BLUE_FLOOR
	ret nz

	ld a,l
	ldh (<hFF8B),a
	ld e,Interaction.var30
	ld (de),a

	; Update the tile at the old position
	ld c,b
	ld a,TILEINDEX_RED_FLOOR
	call setTile

	; Update the tile at the new position
	ldh a,(<hFF8B)
	ld c,a
	ld a,TILEINDEX_YELLOW_FLOOR
	call setTile

	ld a,SND_GETSEED
	jp playSound


; ==============================================================================
; INTERACID_BIPIN
; ==============================================================================
interactionCode28:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics
	call interactionIncState

	; Decide what script to load based on subid
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @bipin0
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin2
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
.ifdef ROM_AGES
	.dw @bipin3
.endif


; Bipin running around, baby just born
@bipin0:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.angle
	ld (hl),$18

	ld l,Interaction.var3a
	ld a,$04
	ld (hl),a
	call interactionSetAnimation

	jp @updateCollisionAndVisibility


; Bipin gives you a random tip
@bipin1:
	ld a,$03
	call interactionSetAnimation
	jp @updateCollisionAndVisibility


; Bipin just moved to Labrynna/Holodrum?
@bipin2:
	ld a,$02
	call interactionSetAnimation
	jp @updateCollisionAndVisibility


.ifdef ROM_AGES
; "Past" version of Bipin who gives you a gasha seed
@bipin3:
	ld a,$09
	call interactionSetAnimation
	jp @updateCollisionAndVisibility
.endif


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @bipinSubid0
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
.ifdef ROM_AGES
	.dw @runScriptAndAnimate
.endif

@bipinSubid0:
	call @updateSpeed

@runScriptAndAnimate:
	call interactionRunScript
	jp @updateAnimation

@updateAnimation:
	call interactionAnimate

@updateCollisionAndVisibility:
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; Bipin runs around like a madman when his baby is first born
@updateSpeed:
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $28
	cp $30
	ret c

	; Reverse direction
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	xor $10
	ld (hl),a

	ld l,Interaction.var3a
	ld a,(hl)
	xor $01
	ld (hl),a
	jp interactionSetAnimation


@scriptTable:
	.dw mainScripts.bipinScript0
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript2
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
.ifdef ROM_AGES
	.dw mainScripts.bipinScript3
.endif


; ==============================================================================
; INTERACID_ADLAR
; ==============================================================================
interactionCode29:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@state0:
	call interactionInitGraphics
	call interactionIncState

	; Decide on a value to write to var38; this will affect the script.

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld a,$04
	jr nz,@setVar38

	ld hl,wGroup4Flags+$fc
	bit 7,(hl)
	ld a,$03
	jr nz,@setVar38

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ld a,$02
	jr nz,@setVar38

	call getThisRoomFlags
	bit 6,(hl)
	ld a,$01
	jr nz,@setVar38
	xor a
@setVar38:
	ld e,Interaction.var38
	ld (de),a
	call objectSetVisiblec2

	ld hl,mainScripts.adlarScript
	jp interactionSetScript


; ==============================================================================
; INTERACID_LIBRARIAN
; ==============================================================================
interactionCode2a:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.textID+1
	ld (hl),>TX_2700

	ld l,Interaction.collisionRadiusY
	ld (hl),$0c
	inc l
	ld (hl),$06

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld a,<TX_2715
	jr z,+
	ld a,<TX_2716
+
	ld e,Interaction.textID
	ld (de),a

	call objectSetVisiblec2

	ld hl,mainScripts.librarianScript
	jp interactionSetScript


; ==============================================================================
; INTERACID_BLOSSOM
; ==============================================================================
interactionCode2b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics
	ld a,>TX_4400
	call interactionSetHighTextIndex
	call interactionIncState

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initAnimation0
	.dw @initAnimation0
	.dw @initAnimation4
	.dw @initAnimation0
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4

@initAnimation0:
	ld a,$00
	call interactionSetAnimation
	jp @updateCollisionAndVisibility

@initAnimation4:
	ld a,$04
	call interactionSetAnimation
	jp @updateCollisionAndVisibility

@state1:
	call interactionRunScript
	jp @updateAnimation

@updateAnimation:
	call interactionAnimate

@updateCollisionAndVisibility:
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects

@scriptTable:
	.dw mainScripts.blossomScript0
	.dw mainScripts.blossomScript1
	.dw mainScripts.blossomScript2
	.dw mainScripts.blossomScript3
	.dw mainScripts.blossomScript4
	.dw mainScripts.blossomScript5
	.dw mainScripts.blossomScript6
	.dw mainScripts.blossomScript7
	.dw mainScripts.blossomScript8
	.dw mainScripts.blossomScript9


; ==============================================================================
; INTERACID_VERAN_CUTSCENE_WALLMASTER
; ==============================================================================
interactionCode2c:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	ld bc,$0140
	call objectSetSpeedZ
	ld l,Interaction.counter1
	ld (hl),$14
	ld l,Interaction.zh
	ld (hl),$a0

	call objectSetVisiblec3

@state1:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate

@substate1:
	ld c,$00
	call objectUpdateSpeedZ_paramC
	ret nz
	ld a,$01
	call interactionSetAnimation
	jp interactionIncSubstate

@substate2:
	ld e,Interaction.animParameter
	ld a,(de)
	bit 7,a
	jp nz,interactionIncSubstate

	or a
	ret z

	xor a
	ld (w1Link.visible),a
	ld a,$1e
	ld e,Interaction.counter1
	ld (de),a
	ld a,SND_BOSS_DEAD
	jp playSound

@substate3:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr z,++
	dec a
	ld (de),a
	ret
++
	ld e,Interaction.zh
	ld a,(de)
	dec a
	ld (de),a
	cp $b0
	ret nz
	ld a,$08
	ld (wTmpcbb5),a
	jp interactionDelete


; ==============================================================================
; INTERACID_VERAN_CUTSCENE_FACE
; ==============================================================================
interactionCode2d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld a,PALH_87
	call loadPaletteHeader
	ld hl,mainScripts.veranFaceCutsceneScript
	call interactionSetScript

@state2:
	ret

@state1:
	call interactionAnimate
	call interactionRunScript
	ret nc
	ld hl,@warpDestVariables
	call setWarpDestVariables
	xor a
	ld (wcc50),a
	jp interactionIncState

@warpDestVariables:
	m_HardcodedWarpA ROOM_AGES_4d4, $0c, $67, $03


; ==============================================================================
; INTERACID_OLD_MAN_WITH_RUPEES
; ==============================================================================
interactionCode2e:
	call checkInteractionState
	jr nz,@state1

@state0:
	inc a
	ld (de),a
	call interactionInitGraphics
	ld a,>TX_3300
	call interactionSetHighTextIndex

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld h,d
	ld l,Interaction.yh
	ld (hl),$38
	ld l,Interaction.xh
	ld (hl),$28

@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@scriptTable:
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_takesRupees


; ==============================================================================
; INTERACID_PLAY_NAYRU_MUSIC
; ==============================================================================
interactionCode2f:
	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	jp nz,interactionDelete
	ld hl,wActiveMusic
	ld a,MUS_NAYRU
	cp (hl)
	jr z,+

	ld (hl),a
	call playSound
+
	ld a,$02
	call setMusicVolume
	jp interactionDelete


; ==============================================================================
; INTERACID_SHOOTING_GALLERY
; ==============================================================================
interactionCode30:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw shootingGalleryNpc
	.dw shootingGalleryNpc
	.dw shootingGalleryNpc
	.dw shootingGalleryGame


;;
; Interaction $8b (goron elder) also calls this.
shootingGalleryNpc:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

; State 0: initializing
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	xor a
	ld (wTmpcfc0.shootingGallery.disableGoronNpcs),a
	call @setScript

; State 1: waiting for player to talk to the npc and start the game
@state1:
	call interactionRunScript
	jr nc,@updateAnimation
	xor a
	ld (wTmpcfc0.shootingGallery.gameStatus),a
	call interactionIncState

; State 2: waiting for the game to finish
@state2:
	ld a,(wTmpcfc0.shootingGallery.gameStatus)
	or a
	jr z,@updateAnimation
	ld a,$01
	call @setScript
	call interactionIncState

; State 3: waiting for "game wrapup" script to finish, then asks you to try again
@state3:
	call interactionRunScript

.ifdef REGION_JP
	jr c,@loadRetryScriptAndGotoState1
.else
	call c,@loadRetryScriptAndGotoState1
.endif

@updateAnimation:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jp nz,interactionAnimateAsNpc
	jp npcFaceLinkAndAnimate

;;
@loadRetryScriptAndGotoState1:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld a,$02

;;
; @param	a	Script index.
@setScript:
	; a *= 3
	ld b,a
	add a
	add b

	ld h,d
	ld l,Interaction.subid
	add (hl)
	ld hl,shootingGalleryScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

;;
; Interaction $30, subid $03 runs the shooting gallery game.
; It cycles through states 1-6 a total of 10 times.
; var3f is the round counter.
shootingGalleryGame:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	ld a,$01
	ld (wTmpcfc0.shootingGallery.disableGoronNpcs),a

	ld b,$0a
	call shootingGallery_initializeGameRounds

	; Initialize score
	xor a
	ld (wTextNumberSubstitution),a
	ld (wTextNumberSubstitution+1),a

	ld e,Interaction.var3f
	ld (de),a
	call interactionIncState

	ld l,Interaction.yh
	ld (hl),$2a
	ld l,Interaction.xh
	ld (hl),$50

	ld l,Interaction.counter1
	ld (hl),$78

	ld a,SND_WHISTLE
	call playSound

@state1:
	call interactionDecCounter1
	ret nz

	; These variables will be set by the "ball" object later?
	xor a
	ld (wShootingGalleryBallStatus),a
	ld (wShootingGalleryccd5),a
	ld (wShootingGalleryHitTargets),a

	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),$28
	ld a,SND_BASEBALL
	call playSound

@state2:
	call interactionDecCounter1
	ret nz

	call shootingGallery_createPuffAtEachTargetPosition
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$0a
	ret

@state3:
	call interactionDecCounter1
	ret nz

	call shootingGallery_setRandomTargetLayout
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$5a
	ret

@state4:
	call interactionDecCounter1
	ret nz

	call interactionIncState

	; Increment the "round" of the game
	ld l,Interaction.var3f
	inc (hl)

	jp shootingGallery_createBallHere

@state5:
	ld a,(wShootingGalleryBallStatus)
	bit 7,a
	ret z

; Ball has gone out-of-bounds

	and $7f
	jr nz,@hitSomething

	ld a,(wTmpcfc0.shootingGallery.isStrike)
	or a
	jr nz,@strike

	; Hit nothing, but not a strike.
	ld a,$14
	jr @setScript

@strike:
	ld a,$14
	call shootingGallery_addValueToScore
	ld a,$15
	jr @setScript

@hitSomething:
	cp $02
	jr z,@hit2Things

	ld a,(wShootingGalleryHitTargets)
	and $0f
	call getHighestSetBit
	jr @addValueToScore

@hit2Things:
	ld a,(wShootingGalleryHitTargets)
	and $0f
	call getHighestSetBit
	inc a
	add a
	add a
	ld b,a
	ld a,(wShootingGalleryHitTargets)
	swap a
	and $0f
	call getHighestSetBit
	add b

@addValueToScore:
	ldh (<hFF93),a
	call shootingGallery_addValueToScore
	ldh a,(<hFF93)

@setScript:
	ld hl,shootingGalleryHitScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),$28
	ld a,$81
	ld (wDisabledObjects),a
	ld a,$80
	ld (wMenuDisabled),a

@state6:
	call interactionRunScript
	ret nc

	; End the game on the tenth round
	ld e,Interaction.var3f
	ld a,(de)
	cp $0a
	jr z,++

	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld l,Interaction.counter1
	ld (hl),$14
	ret
++
	; Game is over
	ld a,$01
	ld (wTmpcfc0.shootingGallery.gameStatus),a
	xor a
	ld (wTmpcfc0.shootingGallery.disableGoronNpcs),a
	jp interactionDelete

;;
; Also used by goron dance minigame.
;
; @param	b	Number of rounds
shootingGallery_initializeGameRounds:
	ld hl,wShootingGalleryTileLayoutsToShow
	xor a
--
	ldi (hl),a
	inc a
	cp b
	jr nz,--

	ld (wTmpcfc0.shootingGallery.remainingRounds),a
	ret

;;
; Randomly choose the next layout to use. This uses a 10-byte buffer; each time a layout
; is picked, that value is removed from the buffer, and the buffer's size decreases by
; one.
;
; @param[out]	wTmpcfc0.shootingGallery.targetLayoutIndex	Index of the layout to use
shootingGallery_getNextTargetLayout:
	ld a,(wTmpcfc0.shootingGallery.remainingRounds)
	ld b,a
	dec a
	ld (wTmpcfc0.shootingGallery.remainingRounds),a

	; Get a random number between 0 and b-1
	call getRandomNumber
--
	sub b
	jr nc,--
	add b

	ld c,a
	ld hl,wShootingGalleryTileLayoutsToShow
	rst_addAToHl
	ld a,(hl)
	ld (wTmpcfc0.shootingGallery.targetLayoutIndex),a

	; Now shift the contents of the buffer down so that its total size decreases by
	; one, and the value we just read gets overwritten.
	push de
	ld d,c
	ld e,b
	dec e
	ld b,h
	ld c,l
--
	ld a,d
	cp e
	jr z,++
	inc bc
	ld a,(bc)
	ldi (hl),a
	inc d
	jr --
++
	pop de
	ret

;;
shootingGallery_removeAllTargets:
	ld a,$01
	ld (wTmpcfc0.shootingGallery.useTileIndexData),a
	ld e,Interaction.subid
	ld a,(de)
	sub $01
	jr z,@subid1
	jr nc,@subid2

@subid0:
	ld bc,shootingGallery_targetPositions_lynna
	jr shootingGallery_setTiles
@subid1:
	ld bc,shootingGallery_targetPositions_goron
	jr shootingGallery_setTiles
@subid2:
	ld bc,shootingGallery_targetPositions_biggoron
	jr shootingGallery_setTiles


;;
; Chooses one of the 10 target layouts to use and loads the tiles. (It never uses the same
; layout more than once, though.)
shootingGallery_setRandomTargetLayout:
	xor a
	ld (wTmpcfc0.shootingGallery.useTileIndexData),a
	call shootingGallery_getNextTargetLayout

	ld a,(wTmpcfc0.shootingGallery.targetLayoutIndex)

	; l = a*5
	ld l,a
	add a
	add a
	add l
	ld l,a

	ld e,Interaction.var03
	ld a,(de)
	sub $01
	ld a,l
	jr z,@goronGallery
	jr nc,@biggoronGallery

@lynnaGallery:
	ld hl,shootingGallery_targetTiles_lynna
	rst_addDoubleIndex
	ld bc,shootingGallery_targetPositions_lynna
	jr shootingGallery_setTiles

@goronGallery:
	ld hl,shootingGallery_targetTiles_goron
	rst_addDoubleIndex
	ld bc,shootingGallery_targetPositions_goron
	jr shootingGallery_setTiles

@biggoronGallery:
	ld hl,shootingGallery_targetTiles_biggoron
	rst_addDoubleIndex
	ld bc,shootingGallery_targetPositions_biggoron

;;
; @param	bc	Pointer to data containing positions of tiles to be replaced.
; @param	hl	Pointer to data containing tile indices for tiles to be replaced.
;			(optional)
; @param	wTmpcfc0.shootingGallery.useTileIndexData
;			If zero, it uses hl to get the tile indices; otherwise, all tiles
;			are replaced with TILEINDEX_STANDARD_FLOOR.
shootingGallery_setTiles:
	ld a,$0a
@nextTile:
	ldh (<hFF92),a
	ld a,(bc)
	inc bc
	push bc
	ld c,a
	ld a,(wTmpcfc0.shootingGallery.useTileIndexData)
	or a
	ld a,TILEINDEX_STANDARD_FLOOR
	jr nz,+
	ldi a,(hl)
+
	push hl
	call setTile
	pop hl
	pop bc
	ldh a,(<hFF92)
	dec a
	jr nz,@nextTile
	ret


; These are the positions of the tiles for the respective shooting gallery games.
shootingGallery_targetPositions_lynna:
	.db $31 $21 $12 $03 $04 $05 $06 $17 $28 $38

shootingGallery_targetPositions_goron:
	.db $21 $32 $12 $23 $04 $05 $26 $37 $17 $28

shootingGallery_targetPositions_biggoron:
	.db $21 $12 $03 $23 $14 $15 $06 $26 $17 $28


; These are the possible layouts of the tiles for the respective shooting gallery games.
; (One layout per line.)
shootingGallery_targetTiles_lynna:
	.db $d9 $dc $d9 $d9 $dc $d8 $d9 $d9 $dc $d9
	.db $dc $d9 $d9 $d8 $d9 $dc $dc $d9 $dc $d9
	.db $d9 $dc $d9 $dc $d7 $d9 $dc $d9 $d9 $d9
	.db $d9 $d9 $dc $d9 $d8 $d9 $dc $d8 $d9 $d9
	.db $dc $d8 $d9 $d9 $dc $d9 $d9 $dc $d9 $dc
	.db $d9 $d7 $d9 $d9 $d9 $d9 $d7 $d9 $d9 $d9
	.db $dc $dc $d9 $d9 $dc $d9 $d9 $d8 $d9 $d9
	.db $d9 $d9 $dc $d7 $d9 $d8 $d9 $d8 $d9 $d9
	.db $d9 $d9 $dc $d9 $d9 $dc $d9 $d9 $dc $dc
	.db $dc $d9 $d9 $d9 $d8 $d9 $dc $d9 $d9 $d9

shootingGallery_targetTiles_goron:
	.db $d9 $dc $d9 $d9 $d9 $d8 $d9 $d9 $dc $d9
	.db $dc $d9 $d9 $d8 $d9 $dc $d7 $d9 $dc $d9
	.db $d9 $dc $d9 $dc $d7 $d9 $d9 $dc $d9 $d9
	.db $d9 $d9 $dc $d9 $d8 $d9 $dc $d7 $d9 $d9
	.db $dc $d9 $d9 $d9 $d8 $d9 $d9 $dc $d9 $dc
	.db $d9 $dc $d9 $d9 $d9 $dc $d9 $d7 $d8 $d9
	.db $dc $d9 $d9 $d9 $dc $d9 $d9 $dc $d9 $d9
	.db $d9 $d9 $dc $d7 $d9 $d8 $d9 $d8 $d9 $d9
	.db $d9 $d9 $dc $d9 $d9 $dc $d8 $d9 $dc $d9
	.db $dc $d9 $d9 $dc $d9 $d9 $dc $d9 $d9 $dc

shootingGallery_targetTiles_biggoron:
	.db $d9 $d9 $dc $d7 $d9 $dc $d9 $d9 $d8 $dc
	.db $d9 $dc $d9 $d9 $d9 $d8 $dc $d9 $d9 $d8
	.db $d9 $d9 $d7 $dc $dc $d9 $dc $d9 $d9 $dc
	.db $d9 $d9 $dc $d9 $d8 $d9 $dc $d7 $d9 $d9
	.db $dc $d9 $d9 $dc $d9 $dc $dc $d9 $d9 $d8
	.db $d9 $dc $d9 $d9 $dc $d7 $dc $d9 $d9 $d9
	.db $d9 $d9 $d8 $d9 $dc $dc $d7 $d9 $d9 $dc
	.db $d9 $dc $d9 $dc $d9 $d8 $d9 $dc $dc $dc
	.db $dc $d9 $dc $d9 $d9 $dc $d9 $d8 $d9 $d7
	.db $d9 $d9 $d7 $d8 $dc $dc $d9 $dc $d9 $d9

;;
shootingGallery_createPuffAtEachTargetPosition:
	ld e,Interaction.var03
	ld a,(de)
	sub $01
	jr z,@subid1
	jr nc,@subid2

@subid0:
	ld bc,shootingGallery_targetPositions_lynna
	jr ++
@subid1:
	ld bc,shootingGallery_targetPositions_goron
	jr ++
@subid2:
	ld bc,shootingGallery_targetPositions_biggoron

++
	ld a,$0a
@nextTile:
	ldh (<hFF92),a
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_PUFF
	ld a,(bc)
	inc bc
	push bc
	ld l,Interaction.yh
	call setShortPosition
	pop bc
	ldh a,(<hFF92)
	dec a
	jr nz,@nextTile
	ret

;;
shootingGallery_createBallHere:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_BALL
	jp objectCopyPosition

;;
; @param	a	Index?
shootingGallery_addValueToScore:
	ld hl,@scores
	rst_addDoubleIndex
	ld c,(hl)
	inc hl
	ld b,(hl)
	ld hl,wTextNumberSubstitution
	bit 0,c
	jr nz,+
	jp addDecimalToHlRef
+
	res 0,c
	jp subDecimalFromHlRef


; If the last digit is "1", the score is subtracted instead of added.
@scores:
	.dw $0030 ; $00
	.dw $0100 ; $01
	.dw $0011 ; $02
	.dw $0051 ; $03
	.dw $0060 ; $04
	.dw $0130 ; $05
	.dw $0020 ; $06
	.dw $0021 ; $07
	.dw $0130 ; $08
	.dw $0200 ; $09
	.dw $0090 ; $0a
	.dw $0050 ; $0b
	.dw $0020 ; $0c
	.dw $0090 ; $0d
	.dw $0021 ; $0e
	.dw $0061 ; $0f
	.dw $0021 ; $10
	.dw $0050 ; $11
	.dw $0061 ; $12
	.dw $00a1 ; $13
	.dw $0051 ; $14 (strike)


; Scripts for INTERACID_SHOOTING_GALLERY.

; NPC scripts
shootingGalleryScriptTable:
	; NPCs waiting to be talked to
	.dw mainScripts.shootingGalleryScript_humanNpc
	.dw mainScripts.shootingGalleryScript_goronNpc
	.dw mainScripts.shootingGalleryScript_goronElderNpc

	; Cleanup after finishing a game
	.dw mainScripts.shootingGalleryScript_humanNpc_gameDone
	.dw mainScripts.shootingGalleryScript_goronNpc_gameDone
	.dw mainScripts.shootingGalleryScript_goronElderNpc_gameDone

	; NPCs ask if you want to play again
	.dw mainScripts.shootingGalleryScript_humanNpc@tryAgain
	.dw mainScripts.shootingGalleryScript_goronNpc@tryAgain
	.dw mainScripts.shootingGalleryScript_goronElderNpc@beginGame


; Scripts to run when tile(s) of the corresponding types are hit.
shootingGalleryHitScriptTable:
	.dw mainScripts.shootingGalleryScript_hit1Blue        ; $00
	.dw mainScripts.shootingGalleryScript_hit1Fairy       ; $01
	.dw mainScripts.shootingGalleryScript_hit1Red         ; $02
	.dw mainScripts.shootingGalleryScript_hit1Imp         ; $03
	.dw mainScripts.shootingGalleryScript_hit2Blue        ; $04
	.dw mainScripts.shootingGalleryScript_hit1Blue1Fairy  ; $05
	.dw mainScripts.shootingGalleryScript_hit1Red1Blue    ; $06
	.dw mainScripts.shootingGalleryScript_hit1Blue1Imp    ; $07
	.dw mainScripts.shootingGalleryScript_hit1Blue1Fairy  ; $08
	.dw mainScripts.shootingGalleryScript_hit2Blue        ; $09
	.dw mainScripts.shootingGalleryScript_hit1Red1Fairy   ; $0a
	.dw mainScripts.shootingGalleryScript_hit1Fairy1Imp   ; $0b
	.dw mainScripts.shootingGalleryScript_hit1Red1Blue    ; $0c
	.dw mainScripts.shootingGalleryScript_hit1Red1Fairy   ; $0d
	.dw mainScripts.shootingGalleryScript_hit2Red         ; $0e
	.dw mainScripts.shootingGalleryScript_hit1Red1Imp     ; $0f
	.dw mainScripts.shootingGalleryScript_hit1Blue1Imp    ; $10
	.dw mainScripts.shootingGalleryScript_hit1Fairy1Imp   ; $11
	.dw mainScripts.shootingGalleryScript_hit1Red1Imp     ; $12
	.dw mainScripts.shootingGalleryScript_hit2Red         ; $13

	.dw mainScripts.shootingGalleryScript_hitNothing      ; $14
	.dw mainScripts.shootingGalleryScript_strike          ; $15


; ==============================================================================
; INTERACID_IMPA_IN_CUTSCENE
;
; Variables:
;   var3b: For subid 1, saves impa's "oamTileIndexBase" so it can be restored after Impa
;          gets up (she references a different sprite sheet for her "collapsed" sprite)
; ==============================================================================
interactionCode31:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw impaState1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid
	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @init0
	.dw @init1
	.dw @init2
	.dw @init3
	.dw @init4
	.dw @init5
	.dw @loadScript
	.dw @init7
	.dw @init8
	.dw @init9
	.dw @initA

@init0:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	; Load a custom palette and use it for possessed impa
	ld a,PALH_97
	call loadPaletteHeader
	ld e,Interaction.oamFlags
	ld a,$07
	ld (de),a

	ld hl,objectData.impaOctoroks
	call parseGivenObjectData

	ld a,LINK_STATE_08
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$01
	jr @loadScript

@init1:
	ld h,d
	ld l,Interaction.oamTileIndexBase
	ld a,(hl)
	ld l,Interaction.var3b
	ld (hl),a

	call impaLoadCollapsedGraphic

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,impaScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@init2:
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$1e
	jp objectSetVisible82

@init7:
	; Delete self if Zelda hasn't been kidnapped by vire yet, or she's been rescued
	; already, or this isn't a linked game
	ld a,(wEssencesObtained)
	bit 2,a
	jp z,interactionDelete
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	call checkGlobalFlag
	ld a,$09
	jr z,@setAnimationAndLoadScript

	ld e,Interaction.xh
	ld a,$38
	ld (de),a

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	ld a,$02
	jr z,@setAnimationAndLoadScript

	ld a,$48
	ld (de),a ; [xh] = $48
	ld e,Interaction.yh
	ld a,$58
	ld (de),a ; [yh] = $58

	ld a,$81
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,$00
	ld (wScrollMode),a
	ld hl,$cfd0
	ld b,$10
	call clearMemory

	ldbc INTERACID_ZELDA, $06
	call objectCreateInteraction
	ld l,Interaction.yh
	ld (hl),$8c
	ld l,Interaction.xh
	ld (hl),$50

	ld a,$02
	jr @setAnimationAndLoadScript

@init3:
	ld a,$03

@setAnimationAndLoadScript:
	call interactionSetAnimation
	call objectSetVisible82
	jr @loadScript

@init4:
	call checkIsLinkedGame
	jp nz,interactionDelete
	xor a
	ld ($cfc0),a

@preBlackTowerCutscene:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete
	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDelete
	jp @loadScript

@init5:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,$03
	call interactionSetAnimation
	jr @preBlackTowerCutscene

@initA:
	ld a,$02
	jp interactionSetAnimation

@init9:
	call checkIsLinkedGame
	jp z,interactionDelete

@init8:
	ld a,$03
	call interactionSetAnimation
	call @loadScript

impaState1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw impaSubid0
	.dw impaSubid1
	.dw impaSubid2
	.dw impaAnimateAndRunScript
	.dw impaSubid4
	.dw impaSubid5
	.dw impaAnimateAndRunScript
	.dw impaSubid7
	.dw impaSubid8
	.dw impaSubid9
	.dw interactionAnimate

;;
; Possessed Impa.
;
; Variables:
;   var37-var3a: Last frame's Y, X, and Direction values. Used for checking whether to
;                update Impa's animation (update if any one has changed).
impaSubid0:
	ld e,Interaction.substate
	ld a,(de)
	cp $0e
	jr nc,+

	ld hl,wActiveMusic
	ld a,MUS_FAIRY_FOUNTAIN
	cp (hl)
	jr z,+

	ld a,(wActiveRoom)
	cp $39
	jr z,+
	cp $49
	jr z,+

	ld a,MUS_FAIRY_FOUNTAIN
	ld (hl),a
	call playSound
	ld a,$03
	call setMusicVolume

	ld e,Interaction.substate
+
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
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB
	.dw @substateC
	.dw @substateD
	.dw @substateE
	.dw @substateF
	.dw impaRet


; Running a script until Impa joins Link
@substate0:
	call impaAnimateAndRunScript
	ret nc

; When the script has finished, make Impa follow Link and go to substate 1

	xor a
	ld (wUseSimulatedInput),a
	call setLinkIDOverride
	ld l,<w1Link.direction
	ld (hl),DIR_UP

@beginFollowingLink:
	call interactionIncSubstate
	call makeActiveObjectFollowLink
	call interactionSetAlwaysUpdateBit
	call objectSetReservedBit1

	ld l,Interaction.var37
	ld e,Interaction.yh
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.xh
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.direction
	ld a,(w1Link.direction)
	ld (de),a
	ld (hl),$00

	call interactionSetAnimation
	call objectSetVisiblec3
	jp objectSetPriorityRelativeToLink_withTerrainEffects

; Impa following Link (before stone is pushed)
@substate1:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	call impaCheckApproachedStone
	jr nc,@updateAnimationWhileFollowingLink

; Link has approached the stone; trigger cutscene.

	ld a,LINK_STATE_08
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$02

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$1e
	ld l,Interaction.enabled
	res 7,(hl)

	ld a,SND_CLINK
	call playSound

	ld bc,-$1c0
	call objectSetSpeedZ
	call clearFollowingLinkObject
	call @setAngleTowardStone
	call convertAngleDeToDirection
	jp interactionSetAnimation

@updateAnimationWhileFollowingLink:
	; Nothing to do here except check whether to update the animation. (It must update
	; if her position or direction has changed.)
	call impaUpdateAnimationIfDirectionChanged
	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	ld b,a
	ld l,Interaction.var37
	cp (hl)
	jr nz,++

	ld l,Interaction.xh
	ld a,(hl)
	ld c,a
	ld l,Interaction.var38
	cp (hl)
	ret z
++
	ld l,Interaction.var37
	ld (hl),b
	inc l
	ld (hl),c
	call interactionAnimate
	jp interactionAnimate

;;
@setAngleTowardStone:
	ldbc $38,$38
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	ret

; Jumping after spotting stone
@substate2:
	call impaAnimateAndDecCounter1
	ret nz

	; Wait until she lands
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$0a
	ret

@substate3:
	call impaAnimateAndDecCounter1
	ret nz

	ld (hl),$14

	ld bc,TX_0104
	call showText
	jp interactionIncSubstate

@substate4:
	call interactionDecCounter1IfTextNotActive
	ret nz

	ld l,Interaction.speed
	ld (hl),SPEED_300
	jp interactionIncSubstate

; Moving toward stone
@substate5:
	call interactionAnimate3Times
	call objectApplySpeed
	call @setAngleTowardStone

	ld a,$02
	ldh (<hFF8B),a
	ldbc $38,$38
	ld h,d
	ld l,Interaction.yh
	call checkObjectIsCloseToPosition
	ret nc

; Reached the stone

	ld h,d
	call interactionIncSubstate
	ld a,$38
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld (hl),a
	ld l,Interaction.counter1
	ld (hl),$1e
	xor a
	jp interactionSetAnimation

@substate6:
	call impaAnimateAndDecCounter1
	ret nz

	; Start a jump
	ld (hl),$1e
	ld bc,-$180
	call objectSetSpeedZ
	jp interactionIncSubstate

; Jumping in front of stone
@substate7:
	call impaAnimateAndDecCounter1
	ret nz

	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$0a
	ret

@substate8:
	call interactionDecCounter1
	ret nz

	ld (hl),$1e
	call interactionIncSubstate
	ld bc,TX_0105
	jp showText

@substate9:
	call interactionDecCounter1IfTextNotActive
	ret nz

	ld hl,$cfd0
	ld (hl),$02
	ld hl,mainScripts.impaScript_moveAwayFromRock
	call interactionSetScript
	jp interactionIncSubstate

; Moving away from rock (the previously loaded script handles this)
@substateA:
	call impaAnimateAndRunScript
	ret nc

; Done moving away; return control to Link

	xor a
	call setLinkIDOverride
	ld l,<w1Link.direction
	ld (hl),DIR_UP
	ld hl,mainScripts.impaScript_waitForRockToBeMoved
	call interactionSetScript
	jp interactionIncSubstate

; Waiting for Link to start pushing the rock
@substateB:
	call interactionAnimateAsNpc
	call interactionRunScript
	call impaPreventLinkFromLeavingStoneScreen
	ld a,($cfd0)
	cp $06
	ret nz

; The rock has started moving.

	ld hl,mainScripts.impaScript_rockJustMoved
	call interactionSetScript
	jp interactionIncSubstate

@substateC:
	call impaAnimateAndRunScript
	ret nc
	xor a
	call setLinkIDOverride
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN
	jp @beginFollowingLink

; Following Link, waiting for signal to begin the part of the cutscene where she reveals
; she's evil
@substateD:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld a,($cfd0)
	cp $09
	jp nz,@updateAnimationWhileFollowingLink

	; Start the next part of the cutscene
	call interactionIncSubstate
	call clearFollowingLinkObject
	ldbc $68,$38
	call interactionSetPosition
	ld hl,mainScripts.impaScript_revealPossession
	jp interactionSetScript

@substateE:
	call impaAnimateAndRunScript
	ret nc

; Impa has just moved into the corner, Veran will now come out.

	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld a,$05
	call interactionSetAnimation

	ld b,INTERACID_GHOST_VERAN
	call objectCreateInteractionWithSubid00

	ld a,SND_BOSS_DEAD
	call playSound
	jp objectSetVisiblec2

@substateF:
	call interactionAnimate
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	ret nz
	call interactionIncSubstate

;;
; Changes impa's "oamTileIndexBase" to reference her "collapsed" graphic, which is not in
; her normal sprite sheet.
impaLoadCollapsedGraphic:
	ld l,Interaction.oamFlags
	ld (hl),$0a
	ld l,Interaction.oamTileIndexBase
	ld (hl),$60

impaRet:
	ret


;;
; Impa talking to you after Nayru is kidnapped
impaSubid1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw impaSubid1Substate2

@substate0:
	ld a,($cfd0)
	cp $20
	jp nz,interactionAnimate

	call interactionIncSubstate
	ld e,Interaction.xh
	ld a,(de)
	ld l,Interaction.var3d
	ld (hl),a
	ld l,Interaction.counter1
	ld (hl),$3c
	ret

@substate1:
	call interactionDecCounter1
	jr nz,interactionOscillateXRandomly
	jp interactionIncSubstate

;;
; Uses var3d as the interaction's "base" position, and randomly shifts this position left
; by one or not at all.
interactionOscillateXRandomly:
	call getRandomNumber
	and $01
	sub $01
	ld h,d
	ld l,Interaction.var3d
	add (hl)
	ld l,Interaction.xh
	ld (hl),a
	ret

impaSubid1Substate2:
	call interactionRunScript
	jp c,interactionDelete
	ld e,Interaction.counter2
	ld a,(de)
	or a
	jp nz,interactionAnimate2Times
	jp interactionAnimate

;;
; Impa in the credits cutscene
impaSubid2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw impaAnimateAndRunScript
	.dw impaSubid2Substate4
	.dw impaSubid2Substate5
	.dw impaSubid2Substate6
	.dw impaSubid2Substate7

@substate0:
	call interactionDecCounter1IfPaletteNotFading
	ret nz
	ld (hl),$3c
	call interactionIncSubstate
	ld a,$50
	ld bc,$6050
	jp createEnergySwirlGoingIn

@substate1:
	call interactionDecCounter1
	ret nz
	ld hl,wTmpcbb3
	xor a
	ld (hl),a
	dec a
	ld (wTmpcbba),a
	jp interactionIncSubstate

@substate2:
	ld hl,wTmpcbb3
	ld b,$02
	call flashScreen
	ret z

	call interactionIncSubstate
	call interactionCode31@loadScript
	ld a,$01
	ld ($cfc0),a
	jp fadeinFromWhite

;;
impaAnimateAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript


impaSubid2Substate4:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$02

impaSetVisibleAndJump:
	call objectSetVisiblec2
	ld bc,-$180
	jp objectSetSpeedZ

impaSubid2Substate5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionDecCounter1
	jr nz,impaSetVisibleAndJump

	call objectSetVisible82
	ld h,d
	ld l,Interaction.var38
	ld (hl),$10
	jp interactionIncSubstate

impaSubid2Substate6:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz

	ld (hl),$10

	ld l,Interaction.counter2
	ld a,(hl)
	inc (hl)
	cp $02
	jr z,@nextState
	or a
	ld a,$03
	jr z,+
	xor $02
+
	ld l,Interaction.substate
	dec (hl)
	dec (hl)
	jp interactionSetAnimation

@nextState:
	ld (hl),$00
	ld a,$02
	ld ($cfc0),a
	jp interactionIncSubstate

impaSubid2Substate7:
	call impaAnimateAndRunScript
	ld a,($cfc0)
	cp $03
	ret c
	jpab scriptHelp.turnToFaceSomething

;;
; Impa tells you about Ralph's heritage (unlinked)
impaSubid4:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	; Wait for Link to move a certain distance down
	ld hl,w1Link.yh
	ldi a,(hl)
	cp $60
	ret c

	ld l,<w1Link.zh
	bit 7,(hl)
	ret nz
	call checkLinkCollisionsEnabled
	ret nc

	call resetLinkInvincibility
	call setLinkForceStateToState08
	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.var38
	ld a,(de)
	rst_jumpTable
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4

@thing0:
	ld a,($cfc0)
	rrca
	ret nc
	ld e,Interaction.var39
	ld a,$10
	ld (de),a
	jr @incVar38

; Move Link horizontally toward Impa
@thing1:
	ld h,d
	ld l,Interaction.var39
	dec (hl)
	ret nz

	ld a,(w1Link.xh)
	sub $50
	ld b,a
	add $02
	cp $05
	jr c,@incVar38

	ld a,b
	bit 7,a
	ld b,$18
	jr z,+

	ld b,$08
	cpl
	inc a
+
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a

	ld hl,w1Link.angle
	ld a,b
	ldd (hl),a
	swap a
	rlca
	ld (hl),a

@incVar38:
	ld h,d
	ld l,Interaction.var38
	inc (hl)
	ret

; Move Link vertically toward Impa
@thing2:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z

	ld a,(w1Link.yh)
	sub $48
	ld (wLinkStateParameter),a
	xor a
	ld hl,w1Link.direction
	ldi (hl),a
	ld (hl),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	jp @incVar38

@thing3:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z
	call setLinkForceStateToState08
	jp @incVar38

@thing4:
	ret

;;
; Like above (explaining ralph's heritage), but for linked game
impaSubid5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
	jr nc,++

	; Script over
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call setGlobalFlag
	jp interactionDelete
++
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cfd0)
	cp $04
	ret nz

	ld a,$29
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$10
	ld (w1Link.angle),a
	jp interactionIncSubstate

@substate1:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z
	call setLinkForceStateToState08
	jp interactionIncSubstate

@substate2:
	ret

;;
; Impa tells you that zelda's been kidnapped by Vire
impaSubid7:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete

	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	call checkGlobalFlag
	jp z,interactionAnimateAsNpc

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp nz,interactionAnimate
	jp npcFaceLinkAndAnimate

;;
impaSubid8:
	call impaAnimateAndRunScript
	jp c,interactionDelete
	ret

;;
; Impa tells you that Zelda's been kidnapped by Twinrova
impaSubid9:
	ld e,Interaction.var38
	ld a,(de)
	or a
	jr z,++
	callab scriptHelp.objectWritePositionTocfd5
++
	jp impaAnimateAndRunScript

;;
; Checks that an object is within [hFF8B] pixels of a position on both axes.
;
; @param	bc	Target position
; @param	hl	Object's Y position
; @param	hFF8B	Range we must be within on each axis
; @param[out]	cflag	c if the object is within [hFF8B] pixels of the position
checkObjectIsCloseToPosition:
	push hl
	call @checkComponent
	pop hl
	ret nc

	inc l
	inc l
	ld b,c

;;
; @param	b	Position
; @param	hl	Object position component
; @param	hFF8B
; @param[out]	cflag	Set if we're within [hFF8B] pixels of 'b'.
@checkComponent:
	ld a,b
	sub (hl)
	ld hl,hFF8B
	ld b,(hl)
	add b
	ldh (<hFF8D),a

	ld a,b
	add a
	ld b,a
	inc b
	ldh a,(<hFF8D)
	cp b
	ret

;;
impaUpdateAnimationIfDirectionChanged:
	ld h,d
	ld l,Interaction.direction
	ld a,(hl)
	ld l,Interaction.var39
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation

;;
; @param[out]	cflag	c if Link has approached the stone to trigger Impa's reaction
impaCheckApproachedStone:
	ld a,(wActiveRoom)
	cp $59
	jr nz,@notClose

	ld a,(wScrollMode)
	and $01
	ret z

	ld hl,w1Link.yh
	ldi a,(hl)
	cp $58
	jr nc,@notClose
	inc l
	ld a,(hl)
	cp $78
	ret
@notClose:
	xor a
	ret

;;
; @param[out]	zflag	z if counter1 has reached 0.
impaAnimateAndDecCounter1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	call interactionAnimate
	or $01
	ret

;;
; Shows text if Link tries to leave the screen with the stone.
impaPreventLinkFromLeavingStoneScreen:
	ld hl,w1Link.yh
	ld a,(hl)
	ld b,$76
	cp b
	jr c,++
	ld a,(wKeysPressed)
	and BTN_DOWN
	jr nz,@showText
++
	ld l,<w1Link.xh
	ld a,(hl)
	ld b,$96
	cp b
	ret c
	ld a,(wKeysPressed)
	and BTN_RIGHT
	ret z
@showText:
	ld (hl),b
	ld bc,TX_010a
	jp showText

impaScriptTable:
	.dw mainScripts.impaScript0
	.dw mainScripts.impaScript1
	.dw mainScripts.impaScript2
	.dw mainScripts.impaScript3
	.dw mainScripts.impaScript4
	.dw mainScripts.impaScript5
	.dw mainScripts.impaScript6
	.dw mainScripts.impaScript7
	.dw mainScripts.impaScript8
	.dw mainScripts.impaScript9


; ==============================================================================
; INTERACID_FAKE_OCTOROK
; ==============================================================================
interactionCode32:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @init0
	.dw @init1
	.dw @init2

@init0:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
	call objectSetVisible82

	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	ld hl,impaOctorokScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,b
	ld hl,@animations
	rst_addAToHl
	ld a,(hl)
	jp interactionSetAnimation

; Each animation faces a different direction.
@animations:
	.db $02 $01 $03

@init2:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	jr z,++
	ld a,ENEMYID_GREAT_FAIRY
	call getFreeEnemySlot
	ld (hl),ENEMYID_GREAT_FAIRY
	call objectCopyPosition
	jp interactionDelete
++
	ld bc,-$80
	call objectSetSpeedZ
	ld a,>TX_4100
	call interactionSetHighTextIndex
	ld hl,mainScripts.greatFairyOctorokScript
	jr @init1

@init1:
	call interactionSetScript
	call objectSetVisiblec0

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw impaOctorokCode
	.dw greatFairyOctorokCode
	.dw greatFairyOctorokCode

impaOctorokCode:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)
	cp $01
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$14
	ret

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,Interaction.speed
	ld (hl),SPEED_300

	ld l,Interaction.var03
	ld a,(hl)
	ld bc,@countersAndAngles
	call addDoubleIndexToBc
	ld a,(bc)
	ld l,Interaction.counter1
	ld (hl),a
	inc bc
	ld a,(bc)
	ld l,Interaction.angle
	ld (hl),a
	swap a
	rlca
	jp interactionSetAnimation

@countersAndAngles:
	.db $50 $00
	.db $3c $18
	.db $5a $00

@substate2:
	call interactionAnimate2Times
	call interactionDecCounter1
	ret nz
	ld a,SND_THROW
	call playSound
	jp interactionIncSubstate

@substate3:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	call interactionAnimate2Times
	jp objectApplySpeed


impaOctorokScriptTable: ; These scripts do nothing
	.dw mainScripts.impaOctorokScript
	.dw mainScripts.impaOctorokScript
	.dw mainScripts.impaOctorokScript


greatFairyOctorokCode:
	call npcFaceLinkAndAnimate
	call interactionRunScript
	ret nc

; Script over; just used fairy powder.

	xor a
	call objectUpdateSpeedZ
	ld e,Interaction.zh
	ld a,(de)
	cp $f0
	ret nz

	ldbc INTERACID_GREAT_FAIRY, $01
	call objectCreateInteraction
	ld a,TREASURE_FAIRY_POWDER
	call loseTreasure
	jp interactionDelete


; ==============================================================================
; INTERACID_SMOG_BOSS
;
; Variables:
;   subid:    The index of the last enemy spawned. Incremented each time "@spawnEnemy" is
;             called. This should start at $ff.
;   var03:    Phase of fight
;   var18/19: Pointer to "tile replacement data" while in the process of replacing the
;             room's tiles
;   var30/31: Destination at which to place Link for the next phase
;   var32-34: For the purpose of removing blocks at the end of a phase, this keeps track
;             of the position we're at in the removal loop, and the number of columns or
;             rows remaining to check.
;   var35:    Remembers the value of "subid" at the start of this phase so it can be
;             restored if Link hits the reset button.
; ==============================================================================
interactionCode33:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
	.dw @state8
	.dw @state9
	.dw @stateA

@state0:
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete

	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,($cc93)
	or a
	ret nz

	inc a
	ld (de),a ; [state] = 1

	call @spawnEnemy
	jp objectCreatePuff

; Waiting for Link to complete this phase
@state1:
	ld a,(wNumEnemies)
	dec a
	ret nz
	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	jp interactionIncState

@state2:
	; Raise Link off the floor
	ld hl,w1Link.zh
	dec (hl)
	ld a,$f9
	cp (hl)
	ret c

	; Get the position to place Link at
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@linkPlacementPositions
	rst_addDoubleIndex
	ld e,Interaction.var30
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	jp interactionIncState

; Moving Link to the target position (var30/var31)
@state3:
	ld hl,w1Link.yh
	ld e,Interaction.var30
	ld a,(de)
	cp (hl)
	jp nz,@incOrDecPosition

	ld l,<w1Link.xh
	inc e
	ld a,(de)
	cp (hl)
	jp nz,@incOrDecPosition
	jp interactionIncState

@incOrDecPosition:
	jr c,+
	inc (hl)
	ret
+
	dec (hl)
	ret

; Moving Link back to the ground
@state4:
	ld hl,w1Link.zh
	inc (hl)
	ret nz
	jp interactionIncState

; Waiting for Link to complete this phase?
@state5:
	ld a,(wNumEnemies)
	dec a
	ret nz

	ld e,Interaction.var03
	ld a,(de)
	ld hl,@tileReplacementTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	ld e,Interaction.var18
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld e,Interaction.counter1
	ld a,$05
	ld (de),a
	jp interactionIncState

; Generate the tiles to be used in this phase
@state6:
	call interactionDecCounter1
	ret nz

	ld (hl),$05

	; Retrieve pointer to tile replacement data
	ld l,Interaction.var18
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,(hl)
	or a
	jp z,interactionIncState

	; First byte read was position; move interaction here for the purpose of creating
	; the "poof".
	call convertShortToLongPosition
	ld e,Interaction.yh
	ld a,b
	ld (de),a
	ld e,Interaction.xh
	ld a,c
	ld (de),a

	; Change the tile index
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	ret z

	; Save pointer
	ld e,Interaction.var18
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	jp objectCreatePuff

; Spawn the enemies
@state7:
	call interactionDecCounter1
	ret nz

	call getThisRoomFlags
	res 6,(hl)

	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.var35
	ld (de),a

	; Spawn the enemies
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@numEnemiesToSpawn
	rst_addAToHl
	ld a,(hl)
--
	call @spawnEnemy
	dec a
	jr nz,--

	ld (wDisableLinkCollisionsAndMenu),a

	; Return position to top-left corner
	ld a,$18
	ld e,Interaction.xh
	ld (de),a
	sub $04
	ld e,Interaction.yh
	ld (de),a

	jp interactionIncState


; Run the phase; constantly checks whether any 2 enemies are close enough to merge.
@state8:
	; If [wNumEnemies] == 1, this phase is over
	ld a,(wNumEnemies)
	dec a
	jp z,interactionIncState

	; If [wNumEnemies] == 2, there's only one, big smog on-screen. Don't allow Link to
	; reset the phase at this point?
	dec a
	jr z,@checkMergeSmogs

	; Check whether the switch tile has changed (Link's stepped on it)
	call objectGetTileAtPosition
	cp TILEINDEX_BUTTON
	jr nz,@buttonPressed

	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	jr nz,@checkMergeSmogs

	ld a,(wLinkInAir)
	or a
	jr nz,@checkMergeSmogs

	ld c,$04
	call objectCheckLinkWithinDistance
	jr nc,@checkMergeSmogs

	; Switch pressed
	ld a,TILEINDEX_PRESSED_BUTTON
	ld c,$11
	call setTile

@buttonPressed:
	; Subtract health as a penalty
	ld hl,wLinkHealth
	ld a,(hl)
	cp $0c
	jr c,+
	sub $04
	ld (hl),a
+
	ld a,SND_SPLASH
	call playSound
	call getThisRoomFlags
	set 6,(hl)
	ld e,Interaction.var35
	ld a,(de)
	ld e,Interaction.subid
	ld (de),a
	call interactionIncState
	jr @nextPhase

; Check up to 3 smog enemies to see whether they should merge
@checkMergeSmogs:
	call @findFirstSmogEnemy
	ret nz
	push hl
	call @findNextSmogEnemy
	pop bc
	ret nz

	call @checkEnemiesCloseEnoughToMerge
	jr c,@mergeSmogs

	call @findNextSmogEnemy
	ret nz
	call @checkEnemiesCloseEnoughToMerge
	jr c,@mergeSmogs

	push hl
	ld h,b
	call @findNextSmogEnemy
	push hl
	pop bc
	pop hl
	call @checkEnemiesCloseEnoughToMerge
	ret nc

; Merge smogs 'b' and 'h'
@mergeSmogs:
	ld l,Enemy.subid
	ld c,l
	ld a,(bc)
	xor (hl)
	and $80
	ld (bc),a

	; Set subid to $06; slate it for deletion, maybe?
	ld (hl),$06

	; This sets hl to a brand new enemy slot
	call getFreeEnemySlot
	ld (hl),ENEMYID_SMOG

	ld a,(bc)
	ld l,c
	or $03
	ldi (hl),a ; [new subid] = [old subid] | 3

	; Slate the other old smog for deletion?
	ld a,$06
	ld (bc),a

	; [New var03] = [Interaction.var03]
	ld e,Interaction.var03
	ld a,(de)
	ldi (hl),a

	ld l,Enemy.counter2
	ld (hl),$05

	; Copy old smog's direction
	inc l
	ld c,l
	ld a,(bc)
	ld (hl),a

	; Copy old smog's position
	ld l,Enemy.yh
	ld c,l
	ld a,(bc)
	ldi (hl),a
	inc l
	ld c,l
	ld a,(bc)
	ld (hl),a
	ret


; Smog destroyed; proceed to the next phase
@state9:
	ld e,Interaction.var03
	ld a,(de)
	inc a
	ld (de),a
	cp $04
	jr nz,@nextPhase

	; Final phase completed
	call decNumEnemies
	jp interactionDelete

@nextPhase:
	ld e,Interaction.counter1
	ld a,$05
	ld (de),a

	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

; Initialize variables for the next phase (they keep track of the position we're at for
; removing block tiles)

	ld e,Interaction.var32
	ld a,$11
	ld (de),a ; var32

	ld a, LARGE_ROOM_HEIGHT-2
	inc e
	ld (de),a ; var33

	inc e
	ld a, LARGE_ROOM_WIDTH-2
	ld (de),a ; var34

	jp interactionIncState


; Clearing out all blocks on-screen in preparation for next phase
@stateA:
	call interactionDecCounter1
	ret nz

	ld a,$05
	ld (hl),a

	ld l,Interaction.var32
	ldi a,(hl)
	ld b,(hl)
	ld l,a
	ld h,>wRoomCollisions
@nextRow:
	ld e,Interaction.var34
	ld a,(de)
	ld c,a
@nextColumn:
	ld a,(hl)
	or a
	jr nz,@foundNextBlockTile

	ld e,Interaction.var32
	inc l
	ld a,l
	ld (de),a
	dec c
	ld e,Interaction.var34
	ld a,c
	ld (de),a
	jr nz,@nextColumn

	; Reset number of columns to check for the next row
	ld a,LARGE_ROOM_WIDTH-2
	ld (de),a

	; Adjust position for the next row
	ld c,a
	ld e,Interaction.var32
	ld a,l
	add ($10 - (LARGE_ROOM_WIDTH-2))
	ld (de),a

	ld l,a
	inc e ; e = var33
	dec b
	ld a,b
	ld (de),a
	jr nz,@nextRow

	; Return to state 1 to begin the next phase
	ld a,$01
	ld e,Interaction.state
	ld (de),a
	ret

@foundNextBlockTile:
	ld a,l
	ld e,Interaction.yh
	and $f0
	or $08
	ld (de),a
	ld e,Interaction.xh
	ld a,l
	swap a
	and $f0
	or $08
	ld (de),a

	ld c,l
	ld a,$a3
	call setTile
	jp objectCreatePuff


;;
@findFirstSmogEnemy:
	ld h,FIRST_ENEMY_INDEX-1

;;
; @param	h	Enemy index after which to start looking
; @param[out]	h	Index of first found smog enemy
; @param[out]	zflag	nz if no such enemy was found
@findNextSmogEnemy:
	inc h
---
	ld l,Enemy.enabled
	ldi a,(hl)
	or a
	jr z,@nextEnemy
	ldi a,(hl)
	cp ENEMYID_SMOG
	jr nz,@nextEnemy
	ldi a,(hl)
	bit 1,a
	jr z,@nextEnemy
	xor a
	ret

@nextEnemy:
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,---
	or d
	ret

;;
@spawnEnemy:
	push af
	call getFreeEnemySlot
	ld (hl),ENEMYID_SMOG

	; Increment this.subid, which acts as the "enemy index" to spawn
	ld b,h
	ld e,Interaction.subid
	ld a,(de)
	inc a
	ld (de),a
	add a
	ld hl,@smogEnemyData
	rst_addDoubleIndex

	ld c,Enemy.subid
	ldi a,(hl)
	ld (bc),a
	inc c
	ld e,Interaction.var03
	ld a,(de)
	ld (bc),a
	ld c,Enemy.yh
	ldi a,(hl)
	ld (bc),a
	ld c,Enemy.xh
	ldi a,(hl)
	ld (bc),a
	ld c,Enemy.direction
	ldi a,(hl)
	ld (bc),a
	pop af
	ret

;;
; @param	b	Enemy 1
; @param	h	Enemy 2
; @param[out]	cflag	Set if they're close enough to merge (within 4 pixels)
@checkEnemiesCloseEnoughToMerge:
	ld l,Enemy.var31
	ld c,l
	ld a,(bc)
	sub (hl)
	add $03
	cp $07
	ret nc

	ld l,Enemy.yh
	ld c,l
	ld a,(bc)
	sub (hl)
	add $04
	cp $09
	ret nc

	ld l,Enemy.xh
	ld c,l
	ld a,(bc)
	sub (hl)
	add $04
	cp $09
	ret

@tileReplacementTable:
	.db @phase0Tiles - CADDR
	.db @phase1Tiles - CADDR
	.db @phase2Tiles - CADDR
	.db @phase3Tiles - CADDR

; Data format:
;   b0: position
;   b1: tile index to place at that position

@phase0Tiles:
	.db $11 $0c
	.db $37 $1d
	.db $46 $1d
	.db $47 $1d
	.db $48 $1d
	.db $76 $1d
	.db $77 $1d
	.db $78 $1d
	.db $87 $1d
	.db $00

@phase1Tiles:
	.db $11 $0c
	.db $3a $1c
	.db $44 $1d
	.db $47 $1d
	.db $4a $1d
	.db $54 $1c
	.db $57 $1d
	.db $64 $1d
	.db $67 $1d
	.db $00

@phase2Tiles:
	.db $11 $0c
	.db $57 $1c
	.db $62 $1d
	.db $63 $1d
	.db $64 $1d
	.db $6a $1d
	.db $6b $1d
	.db $6c $1d
	.db $77 $1c
	.db $00

@phase3Tiles:
	.db $11 $0c
	.db $25 $1d
	.db $26 $1d
	.db $27 $1d
	.db $32 $1d
	.db $37 $1d
	.db $3a $1c
	.db $3c $1d
	.db $42 $1d
	.db $46 $1d
	.db $4c $1d
	.db $52 $1d
	.db $59 $1d
	.db $5c $1d
	.db $62 $1c
	.db $68 $1d
	.db $6c $1d
	.db $72 $1d
	.db $74 $1d
	.db $77 $1c
	.db $7c $1d
	.db $00

@numEnemiesToSpawn: ; Each byte is for a different phase
	.db $02 $03 $02 $03


; Data format:
;   b0: var03
;   b1: Y position
;   b2: X position
;   b3: direction

@smogEnemyData: ; Each row is for a different enemy (across all phases)
	.db $00 $58 $78 $00
	.db $02 $38 $68 $01
	.db $02 $88 $88 $03
	.db $82 $58 $a8 $01
	.db $02 $38 $48 $01
	.db $02 $78 $78 $03
	.db $02 $58 $38 $01
	.db $82 $78 $b8 $01
	.db $02 $28 $28 $01
	.db $82 $58 $88 $03
	.db $82 $88 $c8 $01


@linkPlacementPositions: ; Positions to drop Link at for each phase
	.db $58 $78
	.db $28 $78
	.db $38 $78
	.db $38 $68


; ==============================================================================
; INTERACID_TRIFORCE_STONE
; ==============================================================================
interactionCode34:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	; Delete self if the stone was pushed already
	call getThisRoomFlags
	and $c0
	jp nz,interactionDelete

	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),$03
	inc l
	ld (hl),$0a

	call objectMarkSolidPosition
	call interactionInitGraphics
	ld a,PALH_98
	call loadPaletteHeader
	jp objectSetVisible83

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call objectPreventLinkFromPassing
	call @checkPushedStoneLongEnough
	ret nz

; Begin stone-pushing cutscene

	call interactionIncSubstate
	ld l,Interaction.speed
	ld (hl),SPEED_40
	ld l,Interaction.counter1
	ld (hl),$40

	ld a,SPECIALOBJECTID_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$06

	ld e,Interaction.angle
	ld l,<w1Link.angle
	ld a,(de)
	ld (hl),a

	ld l,<w1Link.speed
	ld (hl),SPEED_80

	ld hl,$cfd0
	ld (hl),$06
	ld a,SND_MAKUDISAPPEAR
	jp playSound

;;
; @param[out]	zflag	Set if Link has pushed against the stone long enough
@checkPushedStoneLongEnough:
	; Check Link's X is close enough
	ld e,Interaction.xh
	ld a,(de)
	ld hl,w1Link.xh
	sub (hl)
	jr nc,+
	cpl
	inc a
+
	cp $11
	jr nc,@notPushing

	; Check Link's Y is close enough
	ld l,<w1Link.yh
	ld a,(hl)
	cp $2a
	jr nc,@notPushing

	; Check he's facing left or right
	ld l,<w1Link.direction
	ld a,(hl)
	and $01
	jr z,@notPushing

	; Check if he's pushing
	call objectCheckLinkPushingAgainstCenter
	jr nc,@notPushing

	; Make Link do the push animation
	ld a,$01
	ld (wForceLinkPushAnimation),a

	; Wait for him to push for enough frames
	call interactionDecCounter1
	ret nz

	; Get the direction Link is relative to the stone
	ld c,$28
	call objectCheckLinkWithinDistance

	ld e,Interaction.angle
	and $07
	xor $04
	add a
	add a
	ld (de),a
	xor a
	ret

@notPushing:
	xor a
	ld (wForceLinkPushAnimation),a
	ld a,$14
	ld e,Interaction.counter1
	ld (de),a
	or a
	ret


; In the process of pushing the stone
@substate1:
	call objectPreventLinkFromPassing
	call interactionDecCounter1
	jr nz,@applySpeed

; Finished pushing

	; Determine new X-position
	ld b,$48
	ld e,Interaction.angle
	ld a,(de)
	and $10
	jr z,+
	ld b,$28
+
	ld l,Interaction.xh
	ld (hl),b

	call interactionIncSubstate

	; Determine bit to set on room flags (depends which way it was pushed)
	call getThisRoomFlags
	ld a,b
	cp $28
	ld b,$40
	jr z,+
	ld b,$80
+
	ld a,(hl)
	or b
	ld (hl),a

	call @setSolidTile

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_SOLVEPUZZLE_2
	jp playSound

@applySpeed:
	jp objectApplySpeed

@substate2:
	ret

;;
; @param	c	Tile to set collisions to "solid" for
@setSolidTile:
	call objectGetShortPosition
	ld c,a
	ld b,>wRoomLayout
	ld a,$00
	ld (bc),a
	ld b,>wRoomCollisions
	ld a,$0f
	ld (bc),a
	ret


; ==============================================================================
; INTERACID_CHILD
;
; Variables:
;   subid: personality type (0-6)
;   var03: index of script and code to run (changes based on personality and growth stage)
;   var37: animation base (depends on subid, or his personality type)
;   var39: $00 is normal; $01 gives "light" solidity (when he moves); $02 gives no solidity.
;   var3a: animation index? (added to base)
;   var3b: scratch variable for scripts
;   var3c: current index in "position list" data
;   var3d: number of entries in "position list" data (minus one)?
;   var3e/3f: pointer to "position list" data for when the child moves around
; ==============================================================================
interactionCode35:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interac65_state1

@state0:
	call childDetermineAnimationBase
	call interactionInitGraphics
	call interactionIncState

	ld e,Interaction.var03
	ld a,(de)
	ld hl,childScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable

	/* $00 */ .dw @initAnimation
	/* $01 */ .dw @hyperactiveStage4Or5
	/* $02 */ .dw @shyStage4Or5
	/* $03 */ .dw @curious
	/* $04 */ .dw @hyperactiveStage4Or5
	/* $05 */ .dw @shyStage4Or5
	/* $06 */ .dw @curious
	/* $07 */ .dw @hyperactiveStage6
	/* $08 */ .dw @shyStage6
	/* $09 */ .dw @curious
	/* $0a */ .dw @slacker
	/* $0b */ .dw @warrior
	/* $0c */ .dw @arborist
	/* $0d */ .dw @singer
	/* $0e */ .dw @slacker
	/* $0f */ .dw @script0f
	/* $10 */ .dw @arborist
	/* $11 */ .dw @singer
	/* $12 */ .dw @slacker
	/* $13 */ .dw @warrior
	/* $14 */ .dw @arborist
	/* $15 */ .dw @singer
	/* $16 */ .dw @val16
	/* $17 */ .dw @initAnimation
	/* $18 */ .dw @curious
	/* $19 */ .dw @slacker
	/* $1a */ .dw @initAnimation
	/* $1b */ .dw @initAnimation
	/* $1c */ .dw @singer

@initAnimation:
	ld e,Interaction.var37
	ld a,(de)
	call interactionSetAnimation
	jp childUpdateSolidityAndVisibility

@hyperactiveStage6:
	ld a,$02
	call childLoadPositionListPointer

@hyperactiveStage4Or5:
	ld h,d
	ld l,Interaction.var39
	ld (hl),$01

	ld l,Interaction.speed
	ld (hl),SPEED_180
	ld l,Interaction.angle
	ld (hl),$18

	ld a,$00

@setAnimation:
	ld h,d
	ld l,Interaction.var3a
	ld (hl),a
	ld l,Interaction.var37
	add (hl)
	call interactionSetAnimation
	jp childUpdateSolidityAndVisibility

@val16:
	call @hyperactiveStage4Or5
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ret

@shyStage4Or5:
	ld a,$00
	call childLoadPositionListPointer
	jr ++

@shyStage6:
	ld a,$01
	call childLoadPositionListPointer
++
	ld h,d
	ld l,Interaction.var39
	ld (hl),$01
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld a,$00
	jr @setAnimation

@curious:
	ld h,d
	ld l,Interaction.var39
	ld (hl),$02
	ld a,$00
	jr @setAnimation

@slacker:
	ld a,$00
	jr @setAnimation

@warrior:
	ld a,$03
	call childLoadPositionListPointer
	jr ++

@script0f:
	ld a,$04
	call childLoadPositionListPointer
++
	ld h,d
	ld l,Interaction.var39
	ld (hl),$01
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld a,$00
	jr @setAnimation

@arborist:
	ld a,$03
	jr @setAnimation

@singer:
	ld a,$00
	jr @setAnimation


interac65_state1:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable

	/* $00 */ .dw @updateAnimationAndSolidity
	/* $01 */ .dw @hyperactiveMovement
	/* $02 */ .dw @shyMovement
	/* $03 */ .dw @curiousMovement
	/* $04 */ .dw @hyperactiveMovement
	/* $05 */ .dw @shyMovement
	/* $06 */ .dw @curiousMovement
	/* $07 */ .dw @usePositionList
	/* $08 */ .dw @shyMovement
	/* $09 */ .dw @curiousMovement
	/* $0a */ .dw @slackerMovement
	/* $0b */ .dw @usePositionList
	/* $0c */ .dw @arboristMovement
	/* $0d */ .dw @singerMovement
	/* $0e */ .dw @slackerMovement
	/* $0f */ .dw @usePositionList
	/* $10 */ .dw @arboristMovement
	/* $11 */ .dw @singerMovement
	/* $12 */ .dw @slackerMovement
	/* $13 */ .dw @usePositionList
	/* $14 */ .dw @arboristMovement
	/* $15 */ .dw @singerMovement
	/* $16 */ .dw @val16
	/* $17 */ .dw @updateAnimationAndSolidity
	/* $18 */ .dw @val1b
	/* $19 */ .dw @slackerMovement
	/* $1a */ .dw @updateAnimationAndSolidity
	/* $1b */ .dw @updateAnimationAndSolidity
	/* $1c */ .dw @singerMovement

@hyperactiveMovement:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr nz,+
	call childUpdateHyperactiveMovement
+

@arboristMovement:
	call interactionRunScript

@updateAnimationAndSolidity:
	jp childUpdateAnimationAndSolidity

@val16:
	call childUpdateUnknownMovement
	jp childUpdateAnimationAndSolidity

@shyMovement:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr nz,+
	call childUpdateShyMovement
+
	jr @runScriptAndUpdateAnimation

@usePositionList:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr nz,++
	call childUpdateAngleAndApplySpeed
	call childCheckAnimationDirectionChanged
	call childCheckReachedDestination
	call c,childIncPositionIndex
++
	jr @runScriptAndUpdateAnimation

@curiousMovement:
	call childUpdateCuriousMovement
	ld e,Interaction.var3d
	ld a,(de)
	or a
	call z,interactionRunScript

@val1b:
	jp childUpdateAnimationAndSolidity

@slackerMovement:
	ld a,(wFrameCounter)
	and $1f
	jr nz,++
	ld e,Interaction.animParameter
	ld a,(de)
	and $01
	ld c,$08
	jr nz,+
	ld c,$fc
+
	ld b,$f4
	call objectCreateFloatingMusicNote
++
	jr @runScriptAndUpdateAnimation

@singerMovement:
	ld a,(wFrameCounter)
	and $1f
	jr nz,@runScriptAndUpdateAnimation
	ld e,Interaction.direction
	ld a,(de)
	or a
	ld c,$fc
	jr z,+
	ld c,$00
+
	ld b,$fc
	call objectCreateFloatingMusicNote

@runScriptAndUpdateAnimation:
	call interactionRunScript
	jp childUpdateAnimationAndSolidity


;;
childUpdateAnimationAndSolidity:
	call interactionAnimate

;;
childUpdateSolidityAndVisibility:
	ld e,Interaction.var39
	ld a,(de)
	cp $01
	jr z,++
	cp $02
	jp z,objectSetPriorityRelativeToLink_withTerrainEffects
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
++
	call objectPushLinkAwayOnCollision
	jp objectSetPriorityRelativeToLink_withTerrainEffects

;;
; Writes the "base" animation index to var37 based on subid (personality type)?
childDetermineAnimationBase:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@animations
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var37
	ld (de),a
	ret

@animations:
	.db $00 $02 $05 $08 $0b $11 $15 $17

;;
childUpdateHyperactiveMovement:
	call objectApplySpeed
	ld h,d
	ld l,Interaction.xh
	ld a,(hl)
	sub $29
	cp $40
	ret c
	bit 7,a
	jr nz,+
	dec (hl)
	dec (hl)
+
	inc (hl)
	ld l,Interaction.var3c
	ld a,(hl)
	inc a
	and $03
	ld (hl),a
	ld bc,childHyperactiveMovementAngles
	call addAToBc
	ld a,(bc)
	ld l,Interaction.angle
	ld (hl),a

childFlipAnimation:
	ld l,Interaction.var3a
	ld a,(hl)
	xor $01
	ld (hl),a
	ld l,Interaction.var37
	add (hl)
	jp interactionSetAnimation

childHyperactiveMovementAngles:
	.db $18 $0a $18 $06

;;
childUpdateUnknownMovement:
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $14
	cp $28
	ret c
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	jr childFlipAnimation

;;
; Updates movement for "shy" personality type (runs away when Link approaches)
childUpdateShyMovement:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld c,$18
	call objectCheckLinkWithinDistance
	ret nc

	call interactionIncSubstate

@substate1:
	call childUpdateAngleAndApplySpeed
	call childCheckReachedDestination
	ret nc

	ld h,d
	ld l,Interaction.substate
	ld (hl),$00
	jp childIncPositionIndex

;;
childUpdateAngleAndApplySpeed:
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	add a
	ld b,a
	ld e,Interaction.var3f
	ld a,(de)
	ld l,a
	ld e,Interaction.var3e
	ld a,(de)
	ld h,a
	ld a,b
	rst_addAToHl
	ld b,(hl)
	inc hl
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	jp objectApplySpeed

;;
; @param[out]	cflag	Set if the child's reached the position he's moving toward (or is
;			within 1 pixel from the destination on both axes)
childCheckReachedDestination:
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	add a
	push af

	ld e,Interaction.var3f
	ld a,(de)
	ld c,a
	ld e,Interaction.var3e
	ld a,(de)
	ld b,a

	pop af
	call addAToBc
	ld l,Interaction.yh
	ld a,(bc)
	sub (hl)
	add $01
	cp $03
	ret nc
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	sub (hl)
	add $01
	cp $03
	ret

;;
; Updates animation if the child's direction has changed?
childCheckAnimationDirectionChanged:
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	swap a
	and $01
	xor $01
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	ld l,Interaction.var3a
	add (hl)
	ld l,Interaction.var37
	add (hl)
	jp interactionSetAnimation

;;
childIncPositionIndex:
	ld h,d
	ld l,Interaction.var3d
	ld a,(hl)
	ld l,Interaction.var3c
	inc (hl)
	cp (hl)
	ret nc
	ld (hl),$00
	ret

;;
; Loads address of position list into var3e/var3f, and the number of positions to loop
; through (minus one) into var3d.
;
; @param	a	Data index
childLoadPositionListPointer:
	add a
	add a
	ld hl,@positionTable
	rst_addAToHl
	ld e,Interaction.var3f
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3e
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3d
	ldi a,(hl)
	ld (de),a
	ret


; Data format:
;  word: pointer to position list
;  byte: number of entries in the list (minus one)
;  byte: unused
@positionTable:
	dwbb @list0 $07 $00
	dwbb @list1 $03 $00
	dwbb @list2 $0b $00
	dwbb @list3 $01 $00
	dwbb @list4 $03 $00

; Each 2 bytes is a position the child will move to.
@list0:
	.db $68 $18
	.db $68 $68
	.db $28 $68
	.db $68 $18
	.db $38 $18
	.db $68 $68
	.db $28 $68
	.db $38 $18

@list1:
	.db $18 $18
	.db $58 $18
	.db $58 $48
	.db $18 $48

@list2:
	.db $28 $48
	.db $18 $44
	.db $18 $28
	.db $20 $18
	.db $2c $0c
	.db $38 $08
	.db $44 $0c
	.db $50 $18
	.db $58 $28
	.db $58 $44
	.db $48 $48
	.db $38 $4c

@list3:
	.db $48 $18
	.db $48 $68
@list4:
	.db $18 $30
	.db $58 $30
	.db $58 $48
	.db $18 $48

;;
childUpdateCuriousMovement:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.angle
	ld (hl),$18

@gotoSubstate1AndJump:
	ld h,d
	ld l,Interaction.substate
	ld (hl),$01
	ld l,Interaction.var3d
	ld (hl),$01

	ld l,Interaction.speedZ
	ld (hl),$00
	inc hl
	ld (hl),$fb
	ld a,SND_JUMP
	jp playSound

@substate1:
	ld c,$50
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	call interactionIncSubstate

	ld l,Interaction.var3d
	ld (hl),$00
	ld l,Interaction.var3c
	ld (hl),$78

	ld l,Interaction.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ret

@substate2:
	ld h,d
	ld l,Interaction.var3c
	dec (hl)
	ret nz
	jr @gotoSubstate1AndJump


childScriptTable:
	.dw mainScripts.childScript00
	.dw mainScripts.childScript_stage4_hyperactive
	.dw mainScripts.childScript_stage4_shy
	.dw mainScripts.childScript_stage4_curious
	.dw mainScripts.childScript_stage5_hyperactive
	.dw mainScripts.childScript_stage5_shy
	.dw mainScripts.childScript_stage5_curious
	.dw mainScripts.childScript_stage6_hyperactive
	.dw mainScripts.childScript_stage6_shy
	.dw mainScripts.childScript_stage6_curious
	.dw mainScripts.childScript_stage7_slacker
	.dw mainScripts.childScript_stage7_warrior
	.dw mainScripts.childScript_stage7_arborist
	.dw mainScripts.childScript_stage7_singer
	.dw mainScripts.childScript_stage8_slacker
	.dw mainScripts.childScript_stage8_warrior
	.dw mainScripts.childScript_stage8_arborist
	.dw mainScripts.childScript_stage8_singer
	.dw mainScripts.childScript_stage9_slacker
	.dw mainScripts.childScript_stage9_warrior
	.dw mainScripts.childScript_stage9_arborist
	.dw mainScripts.childScript_stage9_singer
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00


; ==============================================================================
; INTERACID_NAYRU
; ==============================================================================
interactionCode36:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw nayruState0
	.dw nayruState1

;;
nayruState0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid

	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @init00
	.dw @init01
	.dw @init02
	.dw @init03
	.dw @init04
	.dw @init05
	.dw @init06
	.dw @init07
	.dw @init08
	.dw @init09
	.dw @init0a
	.dw @init0b
	.dw @init0c
	.dw @init0d
	.dw @init0e
	.dw @init0f
	.dw @init10
	.dw @init11
	.dw @init12
	.dw @init13

@init00:
	ld a,$03
	call setMusicVolume
	call @loadEvilPalette

@setSingingAnimation:
	ld a,$04
	call interactionSetAnimation
	jp interactionLoadExtraGraphics

@init01:
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	call objectSetInvisible

	ld hl,mainScripts.nayruScript01
	call interactionSetScript

@init0e: ; This is also called from ambi subids 4 and 5 (to initialize possessed palettes)
	ld a,$06
	ld e,Interaction.oamFlags
	ld (de),a

@loadEvilPalette:
	; Load the possessed version of her palette into palette 6.
	ld a,PALH_97
	jp loadPaletteHeader

@init02:
	ld a,($cfd0)
	cp $03
	jr z,++

	ld a,$05
	call interactionSetAnimation
	ld hl,mainScripts.nayruScript02_part1
	call interactionSetScript
	jp objectSetInvisible
++
	ld a,$02
	call interactionSetAnimation

	ld hl,mainScripts.nayruScript02_part2
	jp interactionSetScript

@init04:
	ld hl,mainScripts.nayruScript04_part1
	ld a,($cfd0)
	cp $0b
	jr nz,++

	ld bc,$4840
	call interactionSetPosition
	call checkIsLinkedGame
	jr nz,@init03

	ld hl,mainScripts.nayruScript04_part2
++
	call interactionSetScript

@init03:
	xor a
	jp interactionSetAnimation

@init05:
	ld a,$05
	call interactionSetAnimation
	ld hl,mainScripts.nayruScript05
	call interactionSetScript
	jp objectSetInvisible

@init06:
	ld a,$07
	jp interactionSetAnimation

@init07:
	ld e,Interaction.counter1
	ld a,$1e
	ld (de),a
	call interactionLoadExtraGraphics
	jp interactionSetAlwaysUpdateBit

@init08:
	ld hl,mainScripts.nayruScript08
	call interactionSetScript
	call objectSetVisible82
	ld a,$03
	jp interactionSetAnimation

@init09:
	ld hl,mainScripts.nayruScript09
	jp interactionSetScript

@init0a:
	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,$01
	call interactionSetAnimation
	ld hl,mainScripts.nayruScript0a
	jp interactionSetScript

@init0b:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp c,interactionDelete

	ld a,<TX_1d14

@runGenericNpc:
	ld e,Interaction.textID
	ld (de),a
	inc e
	ld a,>TX_1d00
	ld (de),a
	ld hl,mainScripts.genericNpcScript
	jp interactionSetScript

@init0c:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,<TX_1d15
	jr @runGenericNpc

@init0d:
	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,<TX_1d17
	jr @runGenericNpc

@init0f:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDelete

	call checkIsLinkedGame
	ld c,$32
	call nz,objectSetShortPosition
	ld a,<TX_1d20
	jr @runGenericNpc

@init10:
	ld a,>TX_1d00
	call interactionSetHighTextIndex
	ld e,Interaction.var3f
	ld a,$ff
	ld (de),a
	ld hl,mainScripts.nayruScript10
	jp interactionSetScript

@init11:
	xor a
	call interactionSetAnimation
	callab scriptHelp.objectWritePositionTocfd5
	ld a,>TX_1d00
	call interactionSetHighTextIndex
	ld hl,mainScripts.nayruScript11
	jp interactionSetScript

@init12:
	call interactionSetAlwaysUpdateBit
	ld bc,$4870
	jp interactionSetPosition

@init13:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld hl,mainScripts.nayruScript13
	call interactionSetScript

	ld a,>TX_1d00
	call interactionSetHighTextIndex

	ld a,MUS_OVERWORLD
	ld (wActiveMusic2),a
	ld a,$ff
	ld (wActiveMusic),a
	jp @setSingingAnimation

;;
nayruState1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw nayruSubid00
	.dw nayruSubid01
	.dw nayruSubid02
	.dw nayruSubid03
	.dw nayruSubid04
	.dw nayruSubid05
	.dw nayruSubid00
	.dw nayruSubid07
	.dw nayruAnimateAndRunScript
	.dw nayruSubid09
	.dw nayruSubid0a
	.dw nayruAsNpc
	.dw nayruAsNpc
	.dw nayruAsNpc
	.dw interactionAnimate
	.dw nayruAsNpc
	.dw nayruSubid10
	.dw nayruAnimateAndRunScript
	.dw interactionAnimate
	.dw nayruSubid13


; Subid $00: cutscene at the beginning of the game (Nayru talks, gets possessed, goes back
; in time).
; Variables:
;   var38:    "Status" of possession flickering
;   var39:    Counter for number of times to flicker palette while being possessed.
;   var3a/3b: Number of frames to stay in her "unpossessed" (var3a) or "possessed" (var3b)
;             palette. These are copied to var39. Her "possessed" counter gets longer while
;             the other gets shorter.
nayruSubid00:
	ld e,Interaction.substate
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
	.dw @substate8

; Waiting for Link to approach (signal in $cfd0)
@substate0:
	call interactionAnimate
	ld a,($cfd0)
	cp $09
	jp nz,@createMusicNotes

	call interactionIncSubstate
	ld a,$0f
	ld l,Interaction.var39
	ldi (hl),a
	ldi (hl),a
	ld (hl),$01
	ld hl,mainScripts.nayruScript00_part1
	jp interactionSetScript

; This is also called from outside subid 0
@createMusicNotes:
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	dec a
	ld c,-6
	jr z,+
	ld c,8
+
	ld b,$fc
	jp objectCreateFloatingMusicNote


; Palette is flickering while being possessed
@substate1:
	call interactionAnimate
	call interactionRunScript
	ld a,($cfd0)
	cp $16
	ret nz

	; Sway horizontally while moving
	ld e,Interaction.counter2
	ld a,(de)
	or a
	call nz,@swayHorizontally

	; Flip the OAM flags when var39 reaches 0
	ld h,d
	ld l,Interaction.var39
	dec (hl)
	ret nz
	ld l,Interaction.oamFlags
	ld a,(hl)
	dec a
	xor $05
	inc a
	ld (hl),a

	call nayruUpdatePossessionPaletteDurations
	jr nz,++

	; Done flickering with possession
	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$06
	ret
++
	ld l,Interaction.var3a
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,Interaction.oamFlags
	ld a,(hl)
	cp $06
	ld a,b
	jr nz,+
	ld a,c
+
	ld l,Interaction.var39
	ld (hl),a
	ret

;;
; Nayru sways horizontally (3 pixels left, 3 pixels right, repeat)
@swayHorizontally:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,@@xOffsets
	rst_addAToHl
	ld e,Interaction.xh
	ld a,(hl)
	ld b,a
	ld a,(de)
	add b
	ld (de),a
	ret

@@xOffsets:
	.db $ff $ff $ff $00 $01 $01 $01 $00


; Waiting for script to end
@substate2:
	call interactionRunScript
	ret nc
	jp interactionIncSubstate


; Waiting for some kind of signal?
@substate3:
	ld a,($cfd0)
	cp $1a
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),60
	ret


; Waiting 60 frames before jumping
@substate4:
	call interactionAnimate
	call interactionDecCounter1
	ret nz

	call interactionIncSubstate
	ld bc,-$400
	call objectSetSpeedZ
	ld a,SND_SWORDSPIN
	call playSound
	ld a,$05
	jp interactionSetAnimation


; Jumping until off-screen
@substate5:
	xor a
	call objectUpdateSpeedZ
	ld e,Interaction.zh
	ld a,(de)
	cp $80
	ret nc

	; Set position to land at
	ld bc,$3828
	call interactionSetPosition
	ld l,Interaction.zh
	ld (hl),$80

	ld l,Interaction.counter1
	ld (hl),$1e

	jp interactionIncSubstate


; Brief delay before falling back down
@substate6:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld bc,$0040
	jp objectSetSpeedZ


; Falling back down
@substate7:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld a,$1b
	ld ($cfd0),a

	; Start next script
	ld hl,mainScripts.nayruScript00_part2
	call interactionSetScript
	ld a,SND_SLASH
	call playSound
	jp interactionIncSubstate


; Next script running; make Nayru transparent when signal is given. Delete self when the
; script finishes.
@substate8:
	call interactionAnimate
	call interactionRunScript
	jr nc,++
	jp interactionDelete
++
	; Wait for signal from script to make her transparent
	ld e,Interaction.var3d
	ld a,(de)
	or a
	ret z
	ld b,$01
	jp objectFlickerVisibility


; Subid $01: Cutscene in Ambi's palace after getting bombs
nayruSubid01:
	call nayruAnimateAndRunScript
	ret nc

; Script finished; load the next room.

	push de
	ld bc,$0146
	call disableLcdAndLoadRoom
	call resetCamera

	; Need to load the guards since the "disableLcdAndLoadRoom" function call doesn't
	; load the room's objects
	ld hl,objectData.ambisPalaceEntranceGuards
	call parseGivenObjectData

	; Need to re-initialize the link object
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$38
	ld l,<w1Link.xh
	ld (hl),$50

	; Need to re-enable the LCD
	ld a,$02
	call loadGfxRegisterStateIndex

	pop de
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	jp clearPaletteFadeVariablesAndRefreshPalettes


; Subid $02: Cutscene on maku tree screen after being saved
nayruSubid02:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw nayruSubid02Substate0
	.dw nayruSubid02Substate1
	.dw nayruSubid02Substate2

;;
nayruSubid02Substate0: ; This is also called by Ralph in the same cutscene
	ld a,($cfd0)
	cp $07
	jr nz,@createNotes

	; When signal is received from $cfd0, choose direction randomly (left/right) and
	; go to substate 1
	call getRandomNumber
	and $02
	or $01
	ld e,Interaction.direction
	ld (de),a

	call nayruSetCounter1Randomly
	jp interactionIncSubstate

@createNotes:
	call nayruSubid00@createMusicNotes

;;
nayruAnimateAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript

;;
nayruSubid02Substate1:
	ld a,($cfd0)
	cp $08
	jr nz,nayruFlipDirectionAtRandomIntervals

	call interactionIncSubstate

	ld hl,mainScripts.nayruScript02_part3
	call interactionSetScript

	ld a,$01
	jp interactionSetAnimation

;;
; This is also called by Ralph in the same cutscene
nayruFlipDirectionAtRandomIntervals:
	call interactionDecCounter1
	ret nz
	ld l,Interaction.direction
	ld a,(hl)
	xor $02
	ld (hl),a
	call interactionSetAnimation

;;
nayruSetCounter1Randomly:
	call getRandomNumber_noPreserveVars
	and $03
	add a
	add a
	add $10
	ld e,Interaction.counter1
	ld (de),a
	ret

nayruSubid02Substate2:
	call nayruAnimateAndRunScript
	ret nc
	jp interactionDelete


; Subid $03: Cutscene with Nayru and Ralph when Link exits the black tower
nayruSubid03:
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cfd0)
	cp $01
	ret nz
	call startJump
	jp interactionIncSubstate

@substate1:
	ld c,$24
	call objectUpdateSpeedZ_paramC
	ret nz
	ld hl,mainScripts.nayruScript03
	call interactionSetScript
	jp interactionIncSubstate

@substate2:
	jp interactionRunScript


;;
; Subid $04: Cutscene at end of game with Ambi and her guards
nayruSubid04:
	call checkIsLinkedGame
	jp z,nayruAnimateAndRunScript

	ld a,($cfd0)
	cp $0b
	jr c,nayruAnimateAndRunScript
	call interactionAnimate
	jpab scriptHelp.turnToFaceSomething

;;
; Subid $05: ?
nayruSubid05:
	call nayruAnimateAndRunScript

	ld a,($cfc0)
	cp $03
	ret c
	cp $05
	ret nc

	jpab scriptHelp.turnToFaceSomething

;;
; For Nayru subid 0 (getting possessed cutscene), this updates var3a, var3b representing
; how long Nayru's palette should be "normal" or "possessed".
;
; @param[out]	zflag	Set when Nayru is fully possessed
nayruUpdatePossessionPaletteDurations:
	ld a,(wFrameCounter)
	and $01
	ret nz
	ld e,Interaction.var38
	ld a,(de)
	rst_jumpTable
	.dw @var38_0
	.dw @var38_1
	.dw @var38_2
	.dw @var38_3
	.dw @var38_4

@var38_0:
	; Decrement var3a (unpossessed palette duration), increment var3b (possessed
	; palette duration) until the two are equal, then increment var38.
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	inc l
	inc (hl)
	ldd a,(hl)
	cp (hl)
	ret nz

@incVar38:
	ld l,Interaction.var38
	inc (hl)
	ret

@var38_1:
	; Decrement both var3a and var3b until they're both 2
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	inc l
	dec (hl)
	ld a,(hl)
	cp $02
	ret nz

	ld l,Interaction.var3c
	ld (hl),$10
	jr @incVar38

@var38_2:
	; Wait 32 frames
	ld h,d
	ld l,Interaction.var3c
	dec (hl)
	ret nz
	jr @incVar38

@var38_3:
	; Increment both var3a and var3b until they're both 8
	ld h,d
	ld l,Interaction.var3a
	inc (hl)
	inc l
	inc (hl)
	ld a,(hl)
	cp $08
	ret nz
	jr @incVar38

@var38_4:
	; Decrement var3a, increment var3b until it's 16
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	inc l
	inc (hl)
	ld a,(hl)
	cp $10
	ret nz
	ret

;;
; Subid $07: Cutscene with the vision of Nayru teaching you Tune of Echoes
nayruSubid07:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	call interactionDecCounter1
	jr z,++

	ld l,Interaction.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ret
++
	xor a
	ld ($cfc0),a
	call interactionIncSubstate
	call objectSetVisible82

	ld a,MUS_NAYRU
	ld (wActiveMusic),a
	call playSound

	ld hl,mainScripts.nayruScript07
	jp interactionSetScript

@substate1:
	call interactionRunScript
	jr c,@scriptDone

	ld a,($cfc0)
	rrca
	ret c
	ld e,Interaction.direction
	ld a,(de)
	cp $07
	call z,nayruSubid00@createMusicNotes
	jp interactionAnimate

@scriptDone:
	ld a,(wTextIsActive)
	or a
	ret nz

	; Re-enable objects, menus
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound

	ld a,$04
	call fadeinFromWhiteWithDelay
	call showStatusBar
	ldh a,(<hActiveObject)
	ld d,a
	jp interactionDelete

;;
nayruAsNpc:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

;;
; Subid $09: Cutscene where Ralph's heritage is revealed (unlinked?)
nayruSubid09:
	call nayruAnimateAndRunScript
	ret nc

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call setGlobalFlag
	jp interactionDelete

;;
; Subid $10: Cutscene in black tower where Nayru/Ralph meet you to try to escape
nayruSubid10:
	ld a,(wScreenShakeCounterY)
	cp $5a
	jr nc,nayruSubid0a
	or a
	jr z,nayruSubid0a
	ld a,(w1Link.direction)
	dec a
	and $03
	ld h,d
	ld l,Interaction.var3f
	cp (hl)
	jr z,nayruSubid0a
	ld (hl),a
	call interactionSetAnimation

;;
; Subid $0a: Cutscene where Ralph's heritage is revealed (linked?)
nayruSubid0a:
	call nayruAnimateAndRunScript
	ret nc
	jp interactionDelete

;;
; Subid $13: NPC after completing game (singing to animals)
nayruSubid13:
	call nayruSubid00@createMusicNotes

;;
; This is called by Ralph as well
nayruRunScriptWithConditionalAnimation:
	call interactionRunScript
	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimate
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; ==============================================================================
; INTERACID_RALPH
;
; Variables:
;   var3f: for some subids, ralph's animations only updates when this is 0.
; ==============================================================================
interactionCode37:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw ralphState0
	.dw ralphRunSubid

ralphState0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call @initSubid
	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08
	.dw @initSubid09
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @initSubid0d
	.dw @initSubid0e
	.dw @initSubid0f
	.dw @initSubid10
	.dw @initSubid11
	.dw @initSubid12


@initSubid06:
	ld hl,mainScripts.ralphSubid06Script_part1
	ld a,($cfd0)
	cp $0b
	jr nz,++
	ld bc,$4850
	call interactionSetPosition
	ld hl,mainScripts.ralphSubid06Script_part2
++
	call interactionSetScript

@initSubid00:
@initSubid05:
	xor a

@setAnimation:
	call interactionSetAnimation
	jp objectSetVisiblec2

@initSubid02:
	ld a,$09
	call interactionSetAnimation

	ld hl,mainScripts.ralphSubid02Script
	call interactionSetScript

	call interactionLoadExtraGraphics
	jp objectSetVisiblec2

@initSubid03:
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON
	call checkGlobalFlag
	jp z,interactionDelete

	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,$03
	call interactionSetAnimation

	ld h,d
	ld l,Interaction.counter1
	ld (hl),$78
	ld l,Interaction.direction
	ld (hl),$01
	jp objectSetVisiblec2

@initSubid04:
	ld a,$01
	call interactionSetAnimation
	ld a,($cfd0)
	cp $03
	jr z,++
	ld hl,mainScripts.ralphSubid04Script_part1
	call interactionSetScript
	jp objectSetInvisible
++
	ld hl,mainScripts.ralphSubid04Script_part2
	call interactionSetScript
	jp objectSetVisiblec2

@initSubid07:
	ld hl,mainScripts.ralphSubid07Script
	call interactionSetScript
	jp objectSetInvisible

@initSubid08:
	callab scriptHelp.ralph_createLinkedSwordAnimation

	ld hl,mainScripts.ralphSubid08Script
	call interactionSetScript
	jp objectSetVisiblec2

@initSubid09:
	ld a,GLOBALFLAG_RALPH_ENTERED_AMBIS_PALACE
	call checkGlobalFlag
	jr nz,@deleteSelf

	; Check that we have the 5th essence
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,@deleteSelf
	bit 5,a
	jr nz,++

@deleteSelf:
	jp interactionDelete

++
	ld e,Interaction.speed
	ld a,SPEED_200
	ld (de),a

	ld a,MUS_RALPH
	ld (wActiveMusic),a
	call playSound

	call setLinkForceStateToState08
	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,(wScreenTransitionDirection)
	ld (w1Link.direction),a

	ld hl,mainScripts.ralphSubid09Script
	call interactionSetScript
	xor a
	call interactionSetAnimation
	jp objectSetVisiblec2

@initSubid0a:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_RALPH_ENTERED_BLACK_TOWER
	call checkGlobalFlag
	jp nz,interactionDelete

	call checkIsLinkedGame
	ld hl,mainScripts.ralphSubid0aScript_unlinked
	jr z,@@setScript

	; Linked game: adjust position, load a different script
	ld h,d
	ld l,Interaction.xh
	ld (hl),$50
	ld l,Interaction.var38
	ld (hl),$1e

	ld hl,mainScripts.ralphSubid0aScript_linked

@@setScript:
	call interactionSetScript
	call setLinkForceStateToState08
	ld ($cfd0),a
	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp objectSetVisiblec2

@initSubid0e:
	ld e,Interaction.var3f
	ld a,$ff
	ld (de),a
	ld hl,mainScripts.ralphSubid0eScript
	jr @setScriptAndRunState1

@initSubid0f:
	ld a,$01
	jp @setAnimation

@initSubid01:
	ld hl,mainScripts.ralphSubid01Script

@setScriptAndRunState1:
	call interactionSetScript
	jp ralphRunSubid

@delete:
	jp interactionDelete

@initSubid0b:
	ld a,TREASURE_TUNE_OF_CURRENTS
	call checkTreasureObtained
	jr c,@delete

	call getThisRoomFlags
	and $40
	jr nz,@delete

	; Check that Link has timewarped in from a specific spot
	ld a,(wScreenTransitionDirection)
	or a
	jr nz,@delete
	ld a,(wWarpDestPos)
	cp $24
	jr nz,@delete

	ld hl,mainScripts.ralphSubid0bScript

@setScriptAndDisableObjects:
	call interactionSetScript

	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	call objectSetVisiblec1
	jp ralphRunSubid

@initSubid10:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete

	ld a,GLOBALFLAG_TALKED_TO_CHEVAL
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,(wWarpDestPos)
	cp $17
	jp nz,interactionDelete

	ld hl,mainScripts.ralphSubid10Script
	jr @setScriptAndDisableObjects

@initSubid11:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,$03
	call interactionSetAnimation
	ld hl,mainScripts.ralphSubid11Script
	call interactionSetScript
	jr ralphRunSubid

@initSubid0c:
	ld hl,wGroup4Flags+$fc
	bit 7,(hl)
	jp nz,interactionDelete

	call interactionLoadExtraGraphics
	callab scriptHelp.ralph_createLinkedSwordAnimation
	ld hl,mainScripts.ralphSubid0cScript
	call interactionSetScript
	xor a
	ld ($cfde),a
	ld ($cfdf),a
	call interactionSetAnimation
	call interactionRunScript
	jr ralphRunSubid

@initSubid12:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld hl,wGroup4Flags + (<ROOM_AGES_4fc)
	bit 7,(hl)
	jp z,interactionDelete
	call objectSetVisiblec2
	ld hl,mainScripts.ralphSubid12Script
	jp interactionSetScript

@initSubid0d:
	ld a,(wScreenTransitionDirection)
	cp $01
	jp nz,interactionDelete

	ld hl,mainScripts.ralphSubid0dScript
	call interactionSetScript
	call objectSetVisiblec0

;;
ralphRunSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw ralphSubid00
	.dw ralphSubid01
	.dw ralphSubid02
	.dw ralphSubid03
	.dw ralphSubid04
	.dw ralphSubid05
	.dw ralphSubid06
	.dw ralphSubid07
	.dw ralphSubid08
	.dw ralphSubid09
	.dw ralphSubid0a
	.dw ralphSubid0b
	.dw ralphRunScriptAndDeleteWhenOver
	.dw ralphRunScriptWithConditionalAnimation
	.dw ralphSubid0e
	.dw interactionAnimate
	.dw ralphSubid10
	.dw nayruRunScriptWithConditionalAnimation
	.dw ralphSubid12

;;
; Cutscene where Nayru gets possessed
ralphSubid00:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call interactionAnimate
	ld a,($cfd0)
	cp $09
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3c

	ld bc,$3088
	call interactionSetPosition
	ld a,$03
	call interactionSetAnimation

	ld hl,mainScripts.ralphSubid00Script
	jp interactionSetScript

@substate1:
	call interactionAnimate
	call interactionRunScript
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret z

	; Animate more quickly if moving fast
	ld e,Interaction.speed
	ld a,(de)
	cp SPEED_100
	jp nc,interactionAnimate
	ret

;;
; Cutscene after Nayru is possessed
ralphSubid02:
	; They probably meant to call "checkInteractionSubstate" instead? It looks like
	; @state0 will never be run...
	call checkInteractionState
	jr nz,@state1

@state0:
	call interactionRunScript
	call interactionAnimate
	ld a,($cfd0)
	cp $1f
	ret nz
	jp interactionIncSubstate

@state1:
	callab scriptHelp.objectWritePositionTocfd5
	ld e,Interaction.counter2
	ld a,(de)
	or a
	call nz,interactionAnimate
	call    interactionAnimate

	call interactionRunScript
	ret nc

	; Script done
	ld a,SNDCTRL_MEDIUM_FADEOUT
	call playSound
	jp interactionDelete

;;
; Cutscene outside Ambi's palace before getting mystery seeds
ralphSubid01:
	call interactionRunScript
	jp c,interactionDelete

	call ralphTurnLinkTowardSelf
	ld e,Interaction.var3f
	ld a,(de)
	or a
	call z,interactionAnimate2Times
	jp interactionPushLinkAwayAndUpdateDrawPriority

;;
; Cutscene after talking to Rafton
ralphSubid03:
	ld e,Interaction.substate
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
	.dw @substate8

@substate0:
	call interactionDecCounter1
	jr nz,++

	ld (hl),$1e
	ld a,$02
	call interactionSetAnimation
	jp interactionIncSubstate
++
	ld a,(wFrameCounter)
	and $0f
	ret nz
	ld e,Interaction.direction
	ld a,(de)
	xor $02
	ld (de),a
	jp interactionSetAnimation

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp startJump

@substate2:
	call interactionAnimate
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$0a
	ret

@substate3:
	call interactionDecCounter1
	ret nz
	ld (hl),$1e
	call interactionIncSubstate
	ld bc,TX_2a0a
	jp showText

@substate4:
	call interactionDecCounter1IfTextNotActive
	ret nz
	ld (hl),$30

	call interactionIncSubstate

	ld l,Interaction.angle
	ld (hl),$10
	ld l,Interaction.speed
	ld (hl),SPEED_100

	ld a,$02
	jp interactionSetAnimation

@substate5:
	call interactionAnimate2Times
	call interactionDecCounter1
	jp nz,objectApplySpeed

	ld (hl),$06
	jp interactionIncSubstate

@substate6:
	call interactionDecCounter1
	ret nz
	ld (hl),$0a

	; Align with Link's x-position
	call interactionIncSubstate
	ld a,(w1Link.xh)
	ld l,Interaction.xh
	sub (hl)
	jr z,@startScript
	jr c,@@moveLeft

@@moveRight:
	ld b,$08
	ld c,DIR_RIGHT
	jr ++

@@moveLeft:
	cpl
	inc a
	ld b,$18
	ld c,DIR_LEFT
++
	ld l,Interaction.counter1
	ld (hl),a
	ld l,Interaction.angle
	ld (hl),b
	ld a,c
	jp interactionSetAnimation

@substate7:
	call interactionAnimate2Times
	call interactionDecCounter1
	jp nz,objectApplySpeed

@startScript:
	call interactionIncSubstate
	ld hl,mainScripts.ralphSubid03Script
	jp interactionSetScript

@substate8:
	call ralphAnimateBasedOnSpeedAndRunScript
	ret nc

	ld a,MUS_OVERWORLD_PAST
	ld (wActiveMusic2),a
	ld (wActiveMusic),a
	call playSound
	jp interactionDelete

;;
; Cutscene on maku tree screen after saving Nayru
ralphSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw nayruSubid02Substate0 ; Borrow some of Nayru's code from the same cutscene
	.dw @substate1
	.dw @substate2

@substate1:
	ld a,($cfd0)
	cp $08
	jp nz,nayruFlipDirectionAtRandomIntervals

	call interactionIncSubstate
	ld hl,mainScripts.ralphSubid04Script_part3
	call interactionSetScript
	jp @substate2

@substate2:
	call ralphAnimateBasedOnSpeedAndRunScript
	ret nc
	jp interactionDelete

;;
; Cutscene in black tower where Nayru/Ralph meet you to try to escape
ralphSubid05:
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw ralphRunScript

@substate0:
	ld a,($cfd0)
	cp $01
	ret nz
	call startJump
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld hl,mainScripts.ralphSubid05Script
	call interactionSetScript
	jp interactionIncSubstate

@substate2:
	ld a,($cfd0)
	cp $02
	jp nz,interactionRunScript
	call startJump
	jp interactionIncSubstate

@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.var3e
	inc (hl)

ralphRunScript:
	jp interactionRunScript

;;
ralphSubid06:
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw ralphRunScript

@substate0:
	callab scriptHelp.objectWritePositionTocfd5
	ld a,($cfd0)
	cp $08
	jp nz,interactionRunScript
	call startJump
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.var3e
	inc (hl)
	jr ralphRunScript

;;
; Cutscene postgame where they warp to the maku tree, Ralph notices the statue
ralphSubid07:
	callab scriptHelp.objectWritePositionTocfd5
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw ralphAnimateBasedOnSpeedAndRunScript
	.dw ralphSubid07Substate1
	.dw ralphSubid07Substate2
	.dw ralphAnimateBasedOnSpeedAndRunScript

ralphAnimateBasedOnSpeedAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript

ralphSubid07Substate1:
	call interactionIncSubstate
	call objectSetVisiblec2
	ld bc,-$1c0
	call objectSetSpeedZ

ralphSubid07Substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.var3e
	inc (hl)
	jp objectSetVisible82

;;
; Cutscene in credits where Ralph is training with his sword
ralphSubid08:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionAnimate
	call interactionRunScript
	ret nc

	; Script done

	call interactionIncSubstate
	ld l,Interaction.speed
	ld (hl),SPEED_c0

@getNextAngle:
	ld b,$02
	callab agesInteractionsBank0a.loadAngleAndCounterPreset
	ld a,b
	or a
	ret

@substate1:
	call interactionAnimate
	call objectApplySpeed
	call interactionDecCounter1
	call z,@getNextAngle
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$5a
	ld a,$08
	jp interactionSetAnimation

@substate2:
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	ld a,$ff
	ld ($cfdf),a
	ret

;;
; Cutscene where Ralph charges in to Ambi's palace
ralphSubid09:
	call interactionRunScript
	jp nc,interactionAnimateBasedOnSpeed

	; Script done
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete

;;
; Cutscene where Ralph's about to charge into the black tower
ralphSubid0a:
	call checkIsLinkedGame
	jp nz,ralphSubid0a_linked

; Unlinked game

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	; Create an exclamation mark above Link
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXCLAMATION_MARK
	ld l,Interaction.counter1
	ld (hl),$1e
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	add $0e
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	sub $0a
	ld (hl),a

	ld a,SND_CLINK
	call playSound

	call interactionIncSubstate

	ld l,Interaction.counter1
	ld (hl),$1e
	ld l,Interaction.speed
	ld (hl),SPEED_180
	ret

@substate1:
	call interactionDecCounter1
	ret nz

	xor a
	call interactionSetAnimation

@moveHorizontallyTowardRalph:
	ld a,(w1Link.xh)
	sub $50
	ld b,a
	add $02
	cp $05
	jr c,@incSubstate

	ld a,b
	bit 7,a
	ld b,$18
	jr z,+
	ld b,$08
	cpl
	inc a
+
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,b
	ld hl,w1Link.angle
	ldd (hl),a
	swap a
	rlca
	ld (hl),a ; [w1Link.direction]

@incSubstate:
	jp interactionIncSubstate

@substate2:
	ld b,$50

@moveVerticallyTowardRalph:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z

	; Make Link move vertically toward Ralph
	ld hl,w1Link.angle
	ld (hl),$10
	dec l
	ld (hl),DIR_DOWN
	ld a,b
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	jp interactionIncSubstate

@substate3:
	ldbc DIR_RIGHT,$03

@setDirectionAndAnimationWhenLinkFinishedMoving:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z

	call setLinkForceStateToState08
	ld a,b
	ld (w1Link.direction),a
	ld a,c
	call interactionSetAnimation
	jp interactionIncSubstate

@substate4:
	call interactionRunScript
	jp nc,interactionAnimateBasedOnSpeed
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete

;;
ralphSubid0a_linked:
	call interactionRunScript
	jp c,interactionDelete

	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz
	jp ralphSubid0a@moveHorizontallyTowardRalph

@substate1:
	ld b,$18
	jp ralphSubid0a@moveVerticallyTowardRalph

@substate2:
	ldbc DIR_DOWN, $00
	jp ralphSubid0a@setDirectionAndAnimationWhenLinkFinishedMoving

@substate3:
	ret


;;
; $0b: Cutscene where Ralph tells you about getting Tune of Currents
; $10: Cutscene after talking to Cheval
ralphSubid0b:
ralphSubid10:
	ld a,($cfc0)
	or a
	call nz,ralphTurnLinkTowardSelf

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw ralphRunScriptWithConditionalAnimation

@substate0:
	call interactionAnimate
	jr ralphRunScriptWithConditionalAnimation

@substate1:
	; Create dust at Ralph's feet every 8 frames
	ld a,(wFrameCounter)
	and $07
	jr nz,ralphRunScriptWithConditionalAnimation

	call getFreeInteractionSlot
	jr nz,ralphRunScriptWithConditionalAnimation

	ld (hl),INTERACID_PUFF
	inc l
	ld (hl),$81
	ld bc,$0804
	call objectCopyPositionWithOffset
	jr ralphRunScriptWithConditionalAnimation

;;
; Runs script, deletes self when finished, and updates animations only if var3f is 0.
ralphRunScriptWithConditionalAnimation:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,interactionAnimate
	ret


;;
; Cutscene with Nayru and Ralph when Link exits the black tower
ralphSubid0e:
	ld a,(wScreenShakeCounterY)
	cp $5a
	jr nc,ralphRunScriptAndDeleteWhenOver
	or a
	jr z,ralphRunScriptAndDeleteWhenOver

	ld a,(w1Link.direction)
	sub $02
	and $03
	ld h,d
	ld l,Interaction.var3f
	cp (hl)
	jr z,ralphRunScriptAndDeleteWhenOver

	ld (hl),a
	call interactionSetAnimation

;;
ralphRunScriptAndDeleteWhenOver:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


;;
; NPC after beating Veran, before beating Twinrova in a linked game
ralphSubid12:
	call npcFaceLinkAndAnimate
	jp interactionRunScript

;;
; Unused?
ralphFunc_738b:
	ld h,d
	ld l,Interaction.var38
	ld a,(hl)
	or a
	jr nz,++

	ld bc,$2068
	ld a,(wFrameCounter)
	rrca
	ret nc

	ld l,Interaction.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a
	cp $0e
	ret nz
	ld l,Interaction.var38
	inc (hl)
	ld l,Interaction.angle
	ld (hl),$1f
++
	ld bc,$6890
	ld a,(wFrameCounter)
	rrca
	ret nc

	ld l,Interaction.angle
	ld a,(hl)
	dec a
	and $1f
	ld (hl),a
	ret

;;
ralphTurnLinkTowardSelf:
	ld a,(w1Link.xh)
	add $10
	ld b,a
	ld e,Interaction.xh
	ld a,(de)
	add $10
	sub b
	ld b,DIR_RIGHT
	jr nc,+
	ld b,DIR_LEFT
	cpl
+
	cp $0c
	jr nc,+
	ld b,DIR_DOWN
+
	ld hl,w1Link.direction
	ld (hl),b
	jp setLinkForceStateToState08

;;
startJump:
	ld bc,-$1c0
	call objectSetSpeedZ
	ld a,SND_JUMP
	jp playSound


; ==============================================================================
; INTERACID_PAST_GIRL
; ==============================================================================
interactionCode38:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2

	ld a,>TX_1a00
	call interactionSetHighTextIndex

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init

@subid0Init:
	callab agesInteractionsBank09.getGameProgress_2

	; NPC doesn't exist between beating d2 and saving Nayru
	ld a,b
	cp $01
	jp z,interactionDelete
	cp $02
	jp z,interactionDelete

	ld a,b
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call objectMarkSolidPosition
	jr @state1

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0

@subid0:
	call interactionRunScript
	jp interactionAnimateAsNpc


@scriptTable:
	.dw mainScripts.pastGirlScript_earlyGame
	.dw mainScripts.pastGirlScript_afterNayruSaved
	.dw mainScripts.pastGirlScript_afterNayruSaved
	.dw mainScripts.pastGirlScript_afterNayruSaved
	.dw mainScripts.pastGirlScript_afterd7
	.dw mainScripts.pastGirlScript_afterGotMakuSeed
	.dw mainScripts.pastGirlScript_twinrovaKidnappedZelda
	.dw mainScripts.pastGirlScript_gameFinished


; ==============================================================================
; INTERACID_MONKEY
; ==============================================================================
interactionCode39:
	jpab bank3f.interactionCode39_body


; ==============================================================================
; INTERACID_VILLAGER
;
; Variables:
;   var03: Nonzero if he's turned to stone
;   var39: For some subids, animations only update when var39 is zero
;   var3d: Saved X position?
; ==============================================================================
interactionCode3a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid

	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08
	.dw @initAnimationAndLoadScript
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @initSubid0d
	.dw @initSubid0e

@initSubid00:
	ld a,$03
	jp interactionSetAnimation

@initSubid02:
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList

	ld e,Interaction.speed
	ld a,SPEED_100
	ld (de),a

@saveXAndLoadScript:
	ld e,Interaction.xh
	ld a,(de)
	ld e,Interaction.var3d
	ld (de),a

@initSubid01:
	jp @loadScript

@initSubid03:
	callab agesInteractionsBank09.getGameProgress_1
	ld a,b
	ld hl,@subid03ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid04:
@initSubid05:
	ld a,$02
	ld e,Interaction.oamFlags
	ld (de),a

	callab agesInteractionsBank09.getGameProgress_1
	ld c,$04
	ld a,$03
	call checkNpcShouldExistAtGameStage
	jp nz,interactionDelete

	ld a,b
	ld hl,@subid4And5ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid06:
@initSubid07:
	callab agesInteractionsBank09.getGameProgress_2
	ld c,$06
	ld a,$04
	call checkNpcShouldExistAtGameStage
	jp nz,interactionDelete

	ld a,b
	ld hl,@subid6And7ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid08:
	ld a,$03
	ld e,Interaction.oamFlags
	ld (de),a

	; Delete if you haven't beaten d7 yet?
	callab agesInteractionsBank09.getGameProgress_2
	ld a,b
	cp $04
	jp c,interactionDelete

	sub $04
	ld hl,@subid08ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid0a:
	ld h,d
	jr @loadStoneAnimation

@initAnimationAndLoadScript:
	ld a,$01
	call interactionSetAnimation
	jp @loadScript

@initSubid0c:
	; Check whether the villager should be stone right now

	; Have we beaten Veran?
	ld hl,wGroup4Flags+$fc
	bit 7,(hl)
	jr nz,@initAnimationAndLoadScript

	ld a,(wEssencesObtained)
	bit 6,a
	jr z,@initAnimationAndLoadScript

	ld h,d
	ld l,Interaction.var03
	inc (hl)

@loadStoneAnimation:
	ld l,Interaction.oamFlags
	ld (hl),$06
	ld a,$06
	call objectSetCollideRadius
	ld a,$0d
	jp interactionSetAnimation

@initSubid0b:
	ld h,d
	call @loadStoneAnimation
	ld e,Interaction.counter1
	ld a,$3c
	ld (de),a
	jr @state1

@initSubid0d:
	call @loadScript
	jr @state1

@initSubid0e:
	call loadStoneNpcPalette
	ld h,d
	ld l,Interaction.oamFlags
	ld (hl),$06
	ld a,$0d
	call interactionSetAnimation

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runSubid09
	.dw @ret
	.dw @runSubid0b
	.dw @runSubid0c
	.dw @runSubid0d
	.dw @runSubid0e


; Cutscene where guy is struck by lightning in intro
@runSubid00:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,($cfd1)
	cp $02
	jp nz,interactionAnimate

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3c
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3d
	ld (hl),a
	ret

@@substate1:
	callab interactionOscillateXRandomly
	ld a,($cfd1)
	cp $03
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$10

	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTNING

	; Write something to subid? This shouldn't matter, this lightning object doesn't
	; seem to use subid anyway.
	inc l
	ld (hl),e

	; [var03] = 1
	inc l
	inc (hl)

	jp objectCopyPosition

@@substate2:
	call interactionDecCounter1
	ret nz
	ld a,$04
	ld ($cfd1),a
	jp interactionDelete


; Past villager?
@runSubid01:
	call interactionRunScript
	jp interactionAnimateAsNpc


; Construction worker blocking path to upper part of black tower.
@runSubid02:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	call npcFaceLinkAndAnimate
	call interactionRunScript
	ld bc,$0503
	call objectSetCollideRadii

	; Temporarily overwrite the worker's X position to check for "collision" at the
	; position he's left open. His position will be reverted before returning.
	ld b,$11
	ld e,Interaction.direction
	ld a,(de)
	or a
	jr z,+
	ld b,$ef
+
	ld e,Interaction.xh
	ld a,(de)
	add b
	ld (de),a
	push bc
	call objectCheckCollidedWithLink_ignoreZ
	pop bc
	jr nc,++

	; Link tried to approach; move over to block his path
	call interactionIncSubstate
	ld hl,mainScripts.villagerSubid02Script_part2
	call interactionSetScript
++
	ld hl,w1Link.yh
	ld e,Interaction.var39
	ld a,(hl)
	ld (de),a
	ld bc,$0606
	call objectSetCollideRadii

	ld e,Interaction.var3d
	ld a,(de)
	ld e,Interaction.xh
	ld (de),a
	ret

@@substate1:
	call interactionAnimateAsNpc
	call interactionRunScript
	jp nc,interactionAnimateBasedOnSpeed

	call @saveXAndLoadScript
	ld h,d
	ld l,Interaction.direction
	ld a,(hl)
	xor $01
	ld (hl),a
	ld l,Interaction.substate
	ld (hl),$00
	jp @loadScript


@runScriptAndFaceLink:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


@runSubid09:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @ret

@@substate0:
	call interactionRunScript
	ld a,($cfd1)
	cp $01
	ret nz
	jp interactionIncSubstate

@@substate1:
	ld a,($cfd1)
	cp $02
	ret nz
	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$06

@ret:
	ret


; Villager being restored from stone, resumes playing catch
@runSubid0b:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionDecCounter1IfPaletteNotFading
	ret nz

	ld a,$01
	ld ($cfd1),a
	ld a,SND_RESTORE
	call playSound
	jpab setCounter1To120AndPlaySoundEffectAndIncSubstate

@@substate1:
	call interactionDecCounter1
	jr nz,++

	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$01
	jp @loadScript
++
	; Flicker palette every 8 frames
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld e,Interaction.oamFlags
	ld a,(de)
	dec a
	xor $05
	inc a
	ld (de),a
	ret

@@substate2:
	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed
	jp interactionRunScript


; Villager playing catch with son
@runSubid0c:
	call interactionPushLinkAwayAndUpdateDrawPriority
	ld e,Interaction.var03
	ld a,(de)
	or a
	ret nz

	call interactionRunScript

	; If you press the A button, show text
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

	xor a
	ld (de),a
	ld bc,TX_1442
	ld hl,wGroup4Flags+$fc
	bit 7,(hl) ; Has Veran been beaten?
	jr z,+
	ld c,<TX_1443
+
	jp showText


; Cutscene when you first enter the past
@runSubid0d:
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimateBasedOnSpeed
	jp interactionPushLinkAwayAndUpdateDrawPriority


; Stone villager? Not much to do.
@runSubid0e:
	ret


@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript


@scriptTable:
	.dw mainScripts.stubScript
	.dw mainScripts.villagerSubid01Script
	.dw mainScripts.villagerSubid02Script_part1
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.villagerSubid09Script
	.dw mainScripts.stubScript
	.dw mainScripts.villagerSubid0bScript
	.dw mainScripts.villagerSubid0cScript
	.dw mainScripts.villagerSubid0dScript


@subid03ScriptTable:
	.dw mainScripts.villagerSubid03Script_befored3
	.dw mainScripts.villagerSubid03Script_afterd3
	.dw mainScripts.villagerSubid03Script_afterNayruSaved
	.dw mainScripts.villagerSubid03Script_afterd7
	.dw mainScripts.villagerSubid03Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid03Script_postGame


@subid4And5ScriptTable:
	.dw mainScripts.villagerSubid4And5Script_befored3
	.dw mainScripts.villagerSubid4And5Script_afterd3
	.dw mainScripts.villagerSubid4And5Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid4And5Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid4And5Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid4And5Script_postGame

@subid6And7ScriptTable:
	.dw mainScripts.villagerSubid6And7Script_befored2
	.dw mainScripts.villagerSubid6And7Script_afterd2
	.dw mainScripts.villagerSubid6And7Script_afterd4
	.dw mainScripts.villagerSubid6And7Script_afterNayruSaved
	.dw mainScripts.villagerSubid6And7Script_afterd7
	.dw mainScripts.villagerSubid6And7Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid6And7Script_twinrovaKidnappedZelda
	.dw mainScripts.villagerSubid6And7Script_postGame

@subid08ScriptTable:
	.dw mainScripts.villagerSubid08Script_afterd7
	.dw mainScripts.villagerSubid08Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid08Script_twinrovaKidnappedZelda
	.dw mainScripts.villagerSubid08Script_postGame


; ==============================================================================
; INTERACID_FEMALE_VILLAGER
; ==============================================================================
interactionCode3b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid

	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08

@initSubid00:
	ld a,$01
	jp interactionSetAnimation

@initSubid01:
@initSubid02:
	callab agesInteractionsBank09.getGameProgress_1
	ld c,$01
	xor a
	call checkNpcShouldExistAtGameStage
	jp nz,interactionDelete

	ld a,b
	ld hl,@subid1And2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp objectSetVisible82

@initSubid03:
@initSubid04:
	callab agesInteractionsBank09.getGameProgress_2
	ld c,$03
	ld a,$01
	call checkNpcShouldExistAtGameStage
	jp nz,interactionDelete

	ld a,b
	ld hl,@subid3And4ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp objectSetVisible82

@initSubid05:
	ld a,$01
	ld e,Interaction.oamFlags
	ld (de),a
	callab agesInteractionsBank09.getGameProgress_2
	ld c,$05
	ld a,$02
	call checkNpcShouldExistAtGameStage
	jp nz,interactionDelete

	ld a,b
	ld hl,@subid5ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp objectSetVisible82

@initSubid07:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld a,<TX_1526
	jr z,+
	ld a,<TX_1527
+
	ld e,Interaction.textID
	ld (de),a

	inc e
	ld a,>TX_1500
	ld (de),a

	xor a
	call interactionSetAnimation

	ld hl,mainScripts.villagerGalSubid07Script
	jp interactionSetScript

@initSubid08:
	ld e,Interaction.textID
	ld a,<TX_0f03
	ld (de),a
	inc e
	ld a,>TX_0f03
	ld (de),a

	ld hl,mainScripts.genericNpcScript
	jp interactionSetScript

@initSubid06:
	ld a,$05
	ld e,Interaction.var3f
	ld (de),a
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runScriptAndAnimateFacingLink
	.dw @runScriptAndAnimateFacingLink
	.dw @runScriptAndAnimateFacingLink
	.dw @runScriptAndAnimateFacingLink
	.dw @runScriptAndAnimateFacingLink
	.dw @runSubid06
	.dw @runSubid07
	.dw @runScriptAndAnimateFacingLink


; Cutscene where guy is struck by lightning in intro
@runSubid00:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4

@@substate0:
	ld a,($cfd1)
	cp $02
	jp nz,interactionAnimate

	call interactionIncSubstate
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3d
	ld (hl),a
	ret

@@substate1:
	callab interactionOscillateXRandomly
	ld a,($cfd1)
	cp $04
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$1e
	ret

@@substate2:
	call interactionDecCounter1
	ret nz

	ld bc,-$1c0
	call objectSetSpeedZ
	ld a,SND_JUMP
	call playSound
	jp interactionIncSubstate

@@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	jp @loadScript

@@substate4:
	call interactionAnimate2Times
	call interactionRunScript
	ret nc
	jp interactionDelete


; Generic NPCs
@runScriptAndAnimateFacingLink:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

; Linked game NPC
@runSubid06:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

; NPC in eyeglasses library (present)
@runSubid07:
	call interactionRunScript
	jp interactionAnimateAsNpc


@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript


@scriptTable:
	.dw mainScripts.villagerGalSubid00Script
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript

@subid1And2ScriptTable:
	.dw mainScripts.villagerGalSubid1And2Script_befored3
	.dw mainScripts.villagerGalSubid1And2Script_afterd3
	.dw mainScripts.villagerGalSubid1And2Script_afterNayruSaved
	.dw mainScripts.villagerGalSubid1And2Script_afterd7
	.dw mainScripts.villagerGalSubid1And2Script_afterGotMakuSeed
	.dw mainScripts.villagerGalSubid1And2Script_postGame

@subid3And4ScriptTable:
	.dw mainScripts.villagerGalSubid3And4Script_befored2
	.dw mainScripts.villagerGalSubid3And4Script_afterd2
	.dw mainScripts.villagerGalSubid3And4Script_afterd4
	.dw mainScripts.villagerGalSubid3And4Script_afterNayruSaved
	.dw mainScripts.villagerGalSubid3And4Script_afterd7
	.dw mainScripts.villagerGalSubid3And4Script_afterGotMakuSeed
	.dw mainScripts.villagerGalSubid3And4Script_twinrovaKidnappedZelda
	.dw mainScripts.villagerGalSubid3And4Script_postGame

@subid5ScriptTable:
	.dw mainScripts.villagerGalSubid05Script_befored2
	.dw mainScripts.villagerGalSubid05Script_afterd2
	.dw mainScripts.villagerGalSubid05Script_afterd4
	.dw mainScripts.villagerGalSubid05Script_afterNayruSaved
	.dw mainScripts.villagerGalSubid05Script_afterd7
	.dw mainScripts.villagerGalSubid05Script_afterd7
	.dw mainScripts.villagerGalSubid05Script_twinrovaKidnappedZelda
	.dw mainScripts.villagerGalSubid05Script_twinrovaKidnappedZelda ; Not used


; ==============================================================================
; INTERACID_BOY
; ==============================================================================
interactionCode3c:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw boyState1

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid

	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @setStoneAnimationAndLoadScript
	.dw @initSubid07
	.dw @initSubid08
	.dw @initSubid09
	.dw @setStoneAnimationAndLoadScript
	.dw @initSubid0b
	.dw @setStoneAnimationAndLoadScript
	.dw @initSubid0d
	.dw @initSubid0e
	.dw @initSubid0f
	.dw @initSubid10


@initSubid03:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	call @saveXToVar3d
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	jr @setRedPaletteAndLoadScript

@initSubid01:
	ld a,$01
	call interactionSetAnimation

@setRedPaletteAndLoadScript:
	ld a,$02
	ld e,Interaction.oamFlags
	ld (de),a
	jp boyLoadScript

@initSubid04:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	ld e,Interaction.counter1
	ld a,$3c
	ld (de),a
	xor a
	call interactionSetAnimation

@saveXToVar3d:
	ld e,Interaction.xh
	ld a,(de)
	ld e,Interaction.var3d
	ld (de),a
	ret

@initSubid05:
	call loadStoneNpcPalette
	ld e,Interaction.oamFlags
	ld a,$06
	ld (de),a
	ld e,Interaction.counter1
	ld a,$3c
	ld (de),a
	ld a,$03
	jp interactionSetAnimation

@setStoneAnimationAndLoadScript:
	ld a,$03
	call interactionSetAnimation
	ld a,$02
	ld e,Interaction.var38
	ld (de),a
	call loadStoneNpcPalette
	jp boyLoadScript

@initSubid0e:
	; Was Veran defeated?
	ld hl,wGroup4Flags+$fc
	bit 7,(hl)
	ld a,<TX_251e
	jr nz,@@notStone

	ld a,(wEssencesObtained)
	bit 6,a
	ld a,<TX_251d
	jr z,@@notStone

	; If Veran's not defeated and d7 is beaten, change position to be in front of his
	; stone dad
	call objectUnmarkSolidPosition
	ld bc,$4848
	call interactionSetPosition
	call objectMarkSolidPosition

	ld h,d
	ld l,Interaction.var03
	inc (hl)

	ld a,$06
	call objectSetCollideRadius
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList

	ld a,<TX_251b
	jr @setTextIDAndLoadScript

@@notStone:
	push af
	xor a
	ld ($cfd3),a

	ldbc INTERACID_BALL,$00
	call objectCreateInteraction
	ld bc,$4a75
	call interactionHSetPosition

	pop af

@setTextIDAndLoadScript:
	ld e,Interaction.textID
	ld (de),a
	jr @setStoneAnimationAndLoadScript

@initSubid00:
	xor a
	call interactionSetAnimation
	jp boyLoadScript

@initSubid02:
	callab agesInteractionsBank09.getGameProgress_1
	ld a,b
	or a
	jr nz,++

	; In the early game, the boy only exists once you've gotten the satchel
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	jp nc,interactionDelete
	xor a
++
	ld hl,boySubid02ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jr boyState1

@initSubid07:
	ld h,d
	ld l,Interaction.var3f
	inc (hl)
	call boyLoadScript
	jr boyState1

@initSubid08:
@initSubid09:
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$78
	jp objectSetVisiblec1

@initSubid0b:
	xor a
	call interactionSetAnimation
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld a,<TX_2519
	jr z,+
	ld a,<TX_251a
+
	ld e,Interaction.textID
	ld (de),a
	inc e
	ld a,>TX_2500
	ld (de),a
	jp boyLoadScript

@initSubid0d:
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jr nz,@@notStone

	call loadStoneNpcPalette
	ld h,d
	ld l,Interaction.oamFlags
	ld (hl),$06
	ld a,$06
	call objectSetCollideRadius
	ld l,Interaction.var03
	inc (hl)
	ld a,$0c
	jp interactionSetAnimation

@@notStone:
	ld bc,$4868
	call interactionSetPosition

	; Load red palette
	ld l,Interaction.oamFlags
	ld (hl),$02

	jp boyLoadScript

@initSubid10:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

@initSubid0f:
	jp boyLoadScript

;;
boyState1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw boyRunSubid00
	.dw boyRunSubid01
	.dw boyRunSubid02
	.dw  boyRunSubid03
	.dw boyRunSubid04
	.dw boyRunSubid05
	.dw boyRunSubid06
	.dw boyRunSubid07
	.dw  boyRunSubid08
	.dw  boyRunSubid09
	.dw boyRunSubid0a
	.dw boyRunSubid0b
	.dw boyRunSubid0c
	.dw boyRunSubid0d
	.dw boyRunSubid0e
	.dw boyRunSubid0f
	.dw boyRunSubid10


; Watching Nayru sing in intro
boyRunSubid00:
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects

	ld e,Interaction.substate
	ld a,(de)
	or a
	call z,objectPreventLinkFromPassing

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)
	cp $0e
	jp nz,interactionRunScript

	call interactionIncSubstate
	ld a,$02
	jp interactionSetAnimation

@substate1:
	call interactionAnimate
	ld a,($cfd0)
	cp $10
	ret nz

	call interactionIncSubstate
	ld bc,-$180
	call objectSetSpeedZ
	ld a,$02
	jp interactionSetAnimation

@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; Run away
	call interactionIncSubstate
	ld l,Interaction.angle
	ld (hl),$02
	ld l,Interaction.speed
	ld (hl),SPEED_180
	xor a
	jp interactionSetAnimation

@substate3:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	jp objectApplySpeed


; Kid turning to stone cutscene
boyRunSubid01:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionRunScript
	ld a,($cfd1)
	cp $01
	jr nz,+
	jp interactionIncSubstate
+
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret z
	jp interactionAnimate2Times

@substate1:
	call interactionRunScript
	ld a,($cfd1)
	cp $02
	jr nz,++

	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$06
	ret
++
	; Flicker palette from red to stone every 8 frames
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld e,Interaction.oamFlags
	ld a,(de)
	xor $04
	ld (de),a
	ret

@substate2:
	call interactionRunScript
	jp nc,interactionAnimate
	ret


; Kid outside shop
boyRunSubid02:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


; Cutscene where kids talk about how they're scared of a ghost (red kid)
; Also called the "other" child interaction?
boyRunSubid03:
	call interactionRunScript

	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed

	call objectCheckWithinScreenBoundary
	ret c

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call getThisRoomFlags
	set 6,(hl)
	jp interactionDelete


; Cutscene where kids talk about how they're scared of a ghost (green kid)
boyRunSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw boyRunSubid03

@substate0:
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp startJump

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	jp boyLoadScript


; Cutscene where kid is restored from stone
boyRunSubid05:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw childSubid05Substate1
	.dw childAnimateIfVar39IsZeroAndRunScript

@substate0:
	call interactionDecCounter1
	ret nz

;;
; Used in cutscenes where people get restored from stone?
setCounter1To120AndPlaySoundEffectAndIncSubstate:
	ld a,120
	ld e,Interaction.counter1
	ld (de),a
	ld a,SND_ENERGYTHING
	call playSound
	jp interactionIncSubstate


childSubid05Substate1:
	call interactionDecCounter1
	jr nz,childFlickerBetweenStone

	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$02
	jp boyLoadScript

;;
; Called from other interactions as well?
childFlickerBetweenStone:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld e,Interaction.oamFlags
	ld a,(de)
	xor $04
	ld (de),a
	ret

childAnimateIfVar39IsZeroAndRunScript:
	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed
	jp interactionRunScript


; Cutscene where kid sees his dad turn to stone
boyRunSubid06:
	call checkInteractionSubstate
	call nz,interactionAnimateBasedOnSpeed
	jp interactionRunScript


; Depressed kid in trade sequence
boyRunSubid07:
	call interactionRunScript
	ld e,Interaction.var3d
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; Kid who runs around in a pattern? Used in a credits cutscene maybe?
; Also called by another interaction?
boyRunSubid08:
boyRunSubid09:
	ld e,Interaction.substate
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
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB

@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$66

	ld l,Interaction.speed
	ld (hl),SPEED_140
	ld l,Interaction.angle
	ld (hl),$18

	call interactionIncSubstate

@setAnimationFromAngle:
	ld e,Interaction.angle
	ld a,(de)
	call convertAngleDeToDirection
	jp interactionSetAnimation


@substate1:
	call @updateAnimationTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz

	call getRandomNumber
	and $0f
	add $1e
	ld (hl),a

	ld l,Interaction.angle
	ld (hl),$08
	call @setAnimationFromAngle
	jp interactionIncSubstate

@updateAnimationTwiceAndApplySpeed:
	call interactionAnimate2Times
	jp objectApplySpeed


@substate2:
	call interactionDecCounter1
	ret nz
	call boyStartHop
	jp interactionIncSubstate

@substate3:
	call boyUpdateGravityAndHopWhenLanded
	ld a,($cfd0)
	cp $01
	ret nz

	ld e,Interaction.zh
	ld a,(de)
	or a
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$1e
	ret

@substate4:
	call interactionDecCounter1
	ret nz

	ld l,Interaction.speed
	ld (hl),SPEED_200
	call @updateAngleAndCounter
	jp interactionIncSubstate

@substate5:
	ld a,($cfd0)
	cp $02
	jr nz,++
	ld e,Interaction.zh
	ld a,(de)
	or a
	jr nz,++

	call interactionIncSubstate

	ld l,Interaction.counter1
	ld (hl),$0a
	ld l,Interaction.angle
	ld (hl),$18
	jp @setAnimationFromAngle
++
	ld e,Interaction.var37
	ld a,(de)
	rst_jumpTable
	.dw @@val0
	.dw @@val1
	.dw @@val2

@@val0:
	call @updateAnimationTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz
	ld (hl),$0a

	ld l,Interaction.var37
	inc (hl)
	cp $68
	ld a,$01
	jr c,+
	ld a,$03
+
	jp interactionSetAnimation

@@val1:
	call interactionDecCounter1
	ret nz
	ld (hl),$1e
	ld l,Interaction.var37
	inc (hl)
	jp boyStartHop

@@val2:
	call boyUpdateGravityAndHopWhenLanded
	call interactionDecCounter1
	ret nz

	xor a
	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a

	ld l,Interaction.var37
	ld (hl),$00

;;
@updateAngleAndCounter:
	ld e,Interaction.id
	ld a,(de)
	cp INTERACID_BOY
	jr z,@boy

	; Which interaction is this for?
	ld a,$02
	jr ++

@boy:
	ld e,Interaction.subid
	ld a,(de)
	sub $08
++
	; a *= 9
	ld b,a
	swap a
	sra a
	add b

	ld hl,@movementData
	rst_addAToHl
	ld e,Interaction.counter2
	ld a,(de)
	rst_addDoubleIndex

	ldi a,(hl)
	ld b,(hl)
	inc l
	ld e,Interaction.counter1
	ld (de),a
	ld e,Interaction.angle
	ld a,b
	ld (de),a

	ld e,Interaction.counter2
	ld a,(de)
	ld b,a
	inc b
	ld a,(hl)
	or a
	jr nz,+
	ld b,$00
+
	ld a,b
	ld (de),a
	jp @setAnimationFromAngle


; Data format:
;   b0: Number of frames to move
;   b1: Angle to move in
@movementData:
	.db $1a $09 ; Subid $08
	.db $16 $1f
	.db $17 $17
	.db $0c $0f
	.db $00

	.db $0c $09 ; Subid $09
	.db $18 $0a
	.db $16 $18
	.db $12 $1f
	.db $00

	.db $1d $08 ; Subid $0a
	.db $19 $16
	.db $18 $0a
	.db $06 $01
	.db $00

@substate6:
	call interactionDecCounter1
	ret nz

	ld e,Interaction.id
	ld a,(de)
	ld b,$34
	cp INTERACID_BOY_2
	jr z,+
	ld b,$20
+
	ld (hl),b
	ld l,Interaction.speed
	ld (hl),SPEED_180
	jp interactionIncSubstate


@substate7:
	call @updateAnimationTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz

	call getRandomNumber
	and $07
	inc a
	ld (hl),a

	ld a,$01
	call interactionSetAnimation
	jp interactionIncSubstate


; Waiting for signal to start hopping again
@substate8:
	ld a,($cfd0)
	cp $03
	ret nz
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp boyStartHop


; Waiting for signal to move off the left side of the screen
@substate9:
	call boyUpdateGravityAndHopWhenLanded

	ld a,($cfd0)
	cp $04
	ret nz
	ld e,Interaction.zh
	ld a,(de)
	or a
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$0c
	ret

@substateA:
	call interactionDecCounter1
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$50
	ld l,Interaction.speed
	ld (hl),SPEED_180
	ld a,$03
	jp interactionSetAnimation

@substateB:
	call @updateAnimationTwiceAndApplySpeed
	call interactionDecCounter1
	jp z,interactionDelete
	ret


; Cutscene?
boyRunSubid0a:
	call interactionAnimate
	jp childAnimateIfVar39IsZeroAndRunScript


; NPC in eyeglasses library present
boyRunSubid0b:
	call interactionRunScript
	jp interactionAnimateAsNpc


; Cutscene where kid's dad gets restored from stone
boyRunSubid0c:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw childAnimateIfVar39IsZeroAndRunScript

@substate0:
	call interactionAnimate2Times
	ld a,($cfd1)
	cp $01
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$78

	ld a,$03
	call interactionSetAnimation

	ld a,$3c
	ld bc,$f408
	jp objectCreateExclamationMark

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld bc,-$1c0
	jp objectSetSpeedZ

@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld a,$02
	ld ($cfd1),a
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),120
	ret

@substate3:
	call interactionDecCounter1
	ret nz
	ld (hl),$3c
	jp interactionIncSubstate

@substate4:
	call interactionAnimate2Times
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate


; Kid with grandma who's either stone or was restored from stone
boyRunSubid0d:
	ld e,Interaction.var03
	ld a,(de)
	or a
	jp nz,interactionPushLinkAwayAndUpdateDrawPriority
	call interactionRunScript
	jp npcFaceLinkAndAnimate


; NPC playing catch with dad, or standing next to his stone dad
boyRunSubid0e:
	; Check if his dad is stone
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr z,+

	call interactionAnimate2Times
	jr ++
+
	call interactionRunScript
++
	call interactionPushLinkAwayAndUpdateDrawPriority
	ld h,d
	ld l,Interaction.pressedAButton
	ld a,(hl)
	or a
	ret z

	ld (hl),$00
	ld b,>TX_2500
	ld l,Interaction.textID
	ld c,(hl)
	jp showText

; Subid $0f: Cutscene where kid runs away?
; Subid $10: Kid listening to Nayru postgame
boyRunSubid0f:
boyRunSubid10:
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimateBasedOnSpeed
	jp interactionPushLinkAwayAndUpdateDrawPriority

;;
; Load palette used for turning npcs to stone?
loadStoneNpcPalette:
	ld a,PALH_a2
	jp loadPaletteHeader

;;
boyUpdateGravityAndHopWhenLanded:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

;;
boyStartHop:
	ld bc,-$e0
	jp objectSetSpeedZ

;;
; Load a script for INTERACID_BOY.
boyLoadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.boySubid00Script
	.dw mainScripts.boySubid01Script
	.dw mainScripts.boyStubScript
	.dw mainScripts.boySubid03Script
	.dw mainScripts.boySubid04Script
	.dw mainScripts.boySubid05Script
	.dw mainScripts.boySubid06Script
	.dw mainScripts.boySubid07Script
	.dw mainScripts.boyStubScript
	.dw mainScripts.boyStubScript
	.dw mainScripts.boySubid0aScript
	.dw mainScripts.boySubid0bScript
	.dw mainScripts.boySubid0cScript
	.dw mainScripts.boySubid0dScript
	.dw mainScripts.boySubid0eScript
	.dw mainScripts.boySubid0fScript
	.dw mainScripts.boySubid00Script

boySubid02ScriptTable:
	.dw mainScripts.boySubid02Script_afterGotSeedSatchel
	.dw mainScripts.boySubid02Script_afterd3
	.dw mainScripts.boySubid02Script_afterNayruSaved
	.dw mainScripts.boySubid02Script_afterd7
	.dw mainScripts.boySubid02Script_afterGotMakuSeed
	.dw mainScripts.boySubid02Script_postGame


; ==============================================================================
; INTERACID_OLD_LADY
; ==============================================================================
interactionCode3d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid

	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid0
	.dw @loadScript
	.dw @initSubid2
	.dw @initSubid3
	.dw @initSubid4
	.dw @initSubid5

@initSubid0:
	ld a,$03
	call interactionSetAnimation

	; Check whether her grandson is stone
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jr z,@loadScript

	; Set var03 to nonzero if her grandson is stone, also change her position
	ld a,$01
	ld e,Interaction.var03
	ld (de),a
	ld bc,$4878
	call interactionSetPosition

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,oldLadyScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid2:
	; This NPC only exists between saving Nayru and beating d7?
	callab agesInteractionsBank09.getGameProgress_1
	ld e,Interaction.subid
	ld a,(de)
	cp b
	jp nz,interactionDelete
	jr @loadScript

@initSubid3:
	ld e,Interaction.counter1
	ld a,220
	ld (de),a

	ld a,$03
	jp interactionSetAnimation

@initSubid4:
	ld a,$00
	jr ++

@initSubid5:
	ld a,$09
++
	ld e,Interaction.var3f
	ld (de),a
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript
	jr @state1

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw @runSubid1
	.dw @runSubid2
	.dw @runSubid3
	.dw @runSubid4
	.dw @runSubid5


; NPC with a grandson that is stone for part of the game
@runSubid0:
	call interactionRunScript

	ld e,Interaction.var03
	ld a,(de)
	or a
	jp z,interactionAnimateAsNpc
	jp npcFaceLinkAndAnimate


; Cutscene where her grandson gets turned to stone
@runSubid1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	call interactionAnimate
	call interactionRunScript
	jr nc,++

	; Script ended
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),60
	ret
++
	ld e,Interaction.counter2
	ld a,(de)
	or a
	jp nz,interactionAnimate2Times
	ret

@@substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),20
	jp interactionIncSubstate

@@substate2:
	call interactionDecCounter1
	jp nz,interactionAnimate3Times
	ld (hl),60
	jp interactionIncSubstate

@@substate3:
	call interactionDecCounter1
	ret nz
	ld a,$ff
	ld ($cfdf),a
	ret


; NPC in present, screen left from bipin&blossom's house
@runSubid2:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


; Cutscene where her grandson is restored from stone
@runSubid3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionDecCounter1
	ret nz
	call startJump
	jp interactionIncSubstate

@@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.var38
	ld (hl),$b4
	jp @loadScript

@@substate2:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	jr nz,++
	ld a,$ff
	ld ($cfdf),a
++
	call interactionRunScript
	jp interactionAnimateBasedOnSpeed


; Linked game NPC
@runSubid4:
@runSubid5:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


oldLadyScriptTable:
	.dw mainScripts.oldLadySubid0Script
	.dw mainScripts.oldLadySubid1Script
	.dw mainScripts.oldLadySubid2Script
	.dw mainScripts.oldLadySubid3Script

.ends
