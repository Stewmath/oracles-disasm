; ==================================================================================================
; INTERAC_DUNGEON_EVENTS
; ==================================================================================================
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
	ld (hl),INTERAC_PUFF
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

	ld (hl),PART_LIGHTABLE_TORCH
	inc l
	ld (hl),$01
	ld l,Part.counter2
	ld (hl),b
	ld l,Part.yh
	call setShortPosition_paramC
	xor a
	ret
