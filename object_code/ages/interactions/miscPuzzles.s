; ==================================================================================================
; INTERAC_MISC_PUZZLES
; ==================================================================================================
interactionCode90:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw miscPuzzles_subid00
	.dw miscPuzzles_subid01
	.dw miscPuzzles_subid02
	.dw miscPuzzles_subid03
	.dw miscPuzzles_subid04
	.dw miscPuzzles_subid05
	.dw miscPuzzles_subid06
	.dw miscPuzzles_subid07
	.dw miscPuzzles_subid08
	.dw miscPuzzles_subid09
	.dw miscPuzzles_subid0a
	.dw miscPuzzles_subid0b
	.dw miscPuzzles_subid0c
	.dw miscPuzzles_subid0d
	.dw miscPuzzles_subid0e
	.dw miscPuzzles_subid0f
	.dw miscPuzzles_subid10
	.dw miscPuzzles_subid11
	.dw miscPuzzles_subid12
	.dw miscPuzzles_subid13
	.dw miscPuzzles_subid14
	.dw miscPuzzles_subid15
	.dw miscPuzzles_subid16
	.dw miscPuzzles_subid17
	.dw miscPuzzles_subid18
	.dw miscPuzzles_subid19
	.dw miscPuzzles_subid1a
	.dw miscPuzzles_subid1b
	.dw miscPuzzles_subid1c
	.dw miscPuzzles_subid1d
	.dw miscPuzzles_subid1e
	.dw miscPuzzles_subid1f
	.dw miscPuzzles_subid20
	.dw miscPuzzles_subid21


; Boss key puzzle in D6
miscPuzzles_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

; State 0: initialization
@state0:
	call interactionIncState

; State 1: waiting for a lever to be pulled
@state1:
	; Return if a lever has not been pulled?
	ld hl,wLever1PullDistance
	bit 7,(hl)
	jr nz,+
	inc l
	bit 7,(hl)
	ret z
+
	; Check if the chest has already been opened
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jr nz,@alreadyOpened

	; Go to state 2 (or possibly 3, if this gets called again)
	call interactionIncState

	; Check whether this is the first time pulling the lever
	ld l,Interaction.counter2
	ld a,(hl)
	or a
	jr nz,@checkRng

	; This was the first time pulling the lever; always unsuccessful
	ld (hl),$01
	jr @error

@checkRng:
	; Get a number between 0 and 3.
	call getRandomNumber
	and $03

	; If the number is 0, the chest will appear; go to state 3.
	jp z,interactionIncState

	; If the number is 1-3, make the snakes appear.
@error:
	ld a,SND_ERROR
	call playSound

	ld a,(wActiveTilePos)
	ld (wWarpDestPos),a

	ld hl,wTmpcec0
	ld b,$20
	call clearMemory

	callab roomInitialization.generateRandomBuffer

	; Spawn the snakes?
	ld hl,objectData.objectData78db
	jp parseGivenObjectData

; State 2: lever has been pulled unsuccessfully. Wait for snakes to be killed before
; returning to state 1.
@state2:
	ld a,(wNumEnemies)
	or a
	ret nz

	; Go back to state 1
	ld a,$01
	ld e,Interaction.state
	ld (de),a
	ret

; State 3: lever has been pulled successfully. Make the chest and delete self.
@state3:
	ld a,$01
	ld (wActiveTriggers),a
	jpab agesInteractionsBank08.spawnChestAndDeleteSelf

@alreadyOpened:
	ld a,$01
	ld (wActiveTriggers),a
	jp interactionDelete



; Underwater switch hook puzzle in past d6
miscPuzzles_subid01:
	call interactionDeleteAndRetIfEnabled02
	call miscPuzzles_deleteSelfAndRetIfItemFlagSet

	ld hl,@diamondPositions
	call miscPuzzles_verifyTilesAtPositions
	ret nz
	jpab agesInteractionsBank08.spawnChestAndDeleteSelf

@diamondPositions:
	.db TILEINDEX_SWITCH_DIAMOND
	.db $16 $17 $18
	.db $26 $27 $28
	.db $00



; Spot to put a rolling colored block on in present d6
miscPuzzles_subid02:
	call interactionDeleteAndRetIfEnabled02

	; Check that the tile at this position matches the cube color
	call objectGetTileAtPosition
	sub TILEINDEX_RED_TOGGLE_FLOOR
	ld b,a
	ld a,(wRotatingCubePos)
	cp l
	ret nz
	ld a,(wRotatingCubeColor)
	and $03
	cp b
	ret nz

	; They match.
	ld c,l
	ld a,TILEINDEX_STANDARD_FLOOR
	call setTile
	ld b,>wRoomCollisions
	ld a,$0f
	ld (bc),a
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete



; Chest from solving colored cube puzzle in d6 (related to subid $02)
miscPuzzles_subid03:
	call interactionDeleteAndRetIfEnabled02
	call miscPuzzles_deleteSelfAndRetIfItemFlagSet

	ld hl,@wantedFloorTiles
	call miscPuzzles_verifyTilesAtPositions
	ret nz
	jpab agesInteractionsBank08.spawnChestAndDeleteSelf

@wantedFloorTiles:
	.db TILEINDEX_STANDARD_FLOOR
	.db $37 $65 $69
	.db $00

;;
; @param	hl	Pointer to data. First byte is a tile index; then an arbitrary
;			number of positions in the room where that tile should be; $ff to
;			give a new tile index; $00 to stop.
; @param[out]	zflag	z if all tiles matched as expected.
miscPuzzles_verifyTilesAtPositions:
	ld b,>wRoomLayout
@newTileIndex:
	ldi a,(hl)
	or a
	ret z
	ld e,a
@nextTile:
	ldi a,(hl)
	ld c,a
	or a
	ret z
	inc a
	jr z,@newTileIndex
	ld a,(bc)
	cp e
	ret nz
	jr @nextTile



; Floor changer in present D6, triggered by orb
miscPuzzles_subid04:
	call checkInteractionState
	jr z,@state0

@state1:
	; Check for change in state
	ld a,(wToggleBlocksState)
	ld b,a
	ld e,Interaction.counter2
	ld a,(de)
	cp b
	ret z

	ld a,b
	ld (de),a
	ld a,$ff
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld e,Interaction.counter1
	ld a,(de)
	inc a
	and $01
	ld b,a
	ld (de),a

	ld c,$05
	call @spawnSubid
	ld c,$06
	call @spawnSubid
	callab bank16.loadD6ChangingFloorPatternToBigBuffer
	ret

@spawnSubid:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MISC_PUZZLES
	inc l
	ld (hl),c
	inc l
	ld (hl),b
	ret

@state0:
	ld a,(wToggleBlocksState)
	ld e,Interaction.counter2
	ld (de),a
	jp interactionIncState


; Helpers for floor changer (subid $04)
miscPuzzles_subid05:
miscPuzzles_subid06:
	ld e,Interaction.substate
	ld a,(de)
	or a
	jr nz,@substate1

@substate0:
	ld e,Interaction.subid
	ld a,(de)
	sub $05
	add a
	ld hl,@data
	rst_addDoubleIndex
	ld b,$04
	ld e,Interaction.var30
	call copyMemory
	jp interactionIncSubstate

; Values for var30-var33
; var30: Start position
; var31: Value to add to position (Y) (alternates direction each column)
; var32: Value to add to position (X)
; var33: Offset in wBigBuffer to read from
@data:
	.db $91 $f0 $01 $00 ; subid 5
	.db $1d $10 $ff $80 ; subid 6

@substate1:
	ld e,Interaction.var33
	ld a,(de)
	ld l,a
	ld h,>wBigBuffer

@nextTile:
	ldi a,(hl)
	or a
	jr z,@deleteSelf
	cp $ff
	jr nz,@setTile

	ld e,Interaction.var32
	ld a,(de)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	add b
	ld (de),a
	ld e,Interaction.var31
	ld a,(de)
	cpl
	inc a
	ld (de),a
	call @nextRow
	jr @nextTile

@setTile:
	ldh (<hFF8B),a
	ld e,Interaction.var33
	ld a,l
	ld (de),a
	call @nextRow
	ldh a,(<hFF8B)
	jp setTile

; [var30] += [var31]
@nextRow:
	ld e,Interaction.var31
	ld a,(de)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	add b
	ld (de),a
	ret

@deleteSelf:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete



; Wall retraction event after lighting torches in past d6
miscPuzzles_subid07:
	call checkInteractionState
	jr z,@state0

@state1:
	call checkLinkVulnerable
	ret nc

	; Check if the number of lit torches has changed.
	call @checkLitTorches
	ld e,Interaction.counter1
	ld a,(de)
	cp b
	ret z

	; It's changed.
	ld a,b
	ld (de),a

	ld e,Interaction.substate
	ld a,(de)
	ld hl,@torchLightOrder
	rst_addAToHl
	ld a,(hl)
	cp b
	jr nz,@litWrongTorch

	ld a,(de)
	cp $03
	jp c,interactionIncSubstate

	; Lit all torches
	ld a, $ff ~ (DISABLE_ITEMS | DISABLE_ALL_BUT_INTERACTIONS)
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,CUTSCENE_WALL_RETRACTION
	ld (wCutsceneTrigger),a

	; Set bit 6 in the present version of this room
	call getThisRoomFlags
	ld l,<ROOM_AGES_525
	set 6,(hl)
	jp interactionDelete

@litWrongTorch:
	xor a
	ld (de),a
	ld e,Interaction.counter1
	ld (de),a
	ld a,SND_ERROR
	call playSound
	ld a,TILEINDEX_UNLIT_TORCH
	ld c,$31
	call setTile
	ld a,TILEINDEX_UNLIT_TORCH
	ld c,$33
	call setTile
	ld a,TILEINDEX_UNLIT_TORCH
	ld c,$35
	call setTile
	ld a,TILEINDEX_UNLIT_TORCH
	ld c,$53
	call setTile
	jr @makeTorchesLightable

@torchLightOrder:
	.db $01 $03 $07 $0f

@state0:
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete

	call interactionIncState
	call @checkLitTorches
	ld a,b
	ld e,Interaction.counter1
	ld (de),a

@makeTorchesLightable:
	call @makeTorchesUnlightable
	ld hl,objectData.objectData_makeTorchesLightableForD6Room
	jp parseGivenObjectData

;;
@makeTorchesUnlightable:
	ldhl FIRST_PART_INDEX, Part.id
--
	ld a,(hl)
	cp PART_LIGHTABLE_TORCH
	call z,@deletePartObject
	inc h
	ld a,h
	cp LAST_PART_INDEX+1
	jr c,--
	ret

@deletePartObject:
	push hl
	dec l
	ld b,$40
	call clearMemory
	pop hl
	ret

;;
; @param[out]	b	Bitset of lit torches (in bits 0-3)
@checkLitTorches:
	ld a,TILEINDEX_LIT_TORCH
	ld b,$00
	ld hl,wRoomLayout+$31
	cp (hl)
	jr nz,+
	set 0,b
+
	ld l,$33
	cp (hl)
	jr nz,+
	set 1,b
+
	ld l,$53
	cp (hl)
	jr nz,+
	set 2,b
+
	ld l,$35
	cp (hl)
	ret nz
	set 3,b
	ret



; Checks to set the "bombable wall open" bit in d6 (north)
miscPuzzles_subid08:
	call interactionDeleteAndRetIfEnabled02
	call getThisRoomFlags
	bit ROOMFLAG_BIT_KEYDOOR_UP,(hl)
	ret z
	ld l,<ROOM_AGES_519
	set ROOMFLAG_BIT_KEYDOOR_UP,(hl)
	jp interactionDelete



; Checks to set the "bombable wall open" bit in d6 (east)
miscPuzzles_subid09:
	call interactionDeleteAndRetIfEnabled02
	call getThisRoomFlags
	bit ROOMFLAG_BIT_KEYDOOR_RIGHT,(hl)
	ret z
	ld l,<ROOM_AGES_526
	set ROOMFLAG_BIT_KEYDOOR_RIGHT,(hl)
	jp interactionDelete



; Jabu-jabu water level controller script, in the room with the 3 buttons
miscPuzzles_subid0a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,(wActiveTriggers)
	ld e,Interaction.var30
	ld (de),a

	ld a,(wJabuWaterLevel)
	and $f0
	ld (wSwitchState),a
	jp interactionIncState

@state1:
	; Check if a button was pressed
	ld a,(wActiveTriggers)
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	xor b
	ld c,a
	ld a,b
	ld (de),a

	bit 7,c
	jr nz,@drainWater

	; Ret if none pressed
	and c
	ret z
	ld a,(wSwitchState)
	and c
	ret nz

	ld a,c
	ld hl,wSwitchState
	or (hl)
	ld (hl),a
	and $f0
	ld b,a
	ld hl,wJabuWaterLevel
	ld a,(hl)
	and $03
	inc a
	or b
	ld (hl),a
.ifndef REGION_JP
	ld a,<TX_1209
.endif
	jr @beginCutscene

@drainWater:
	ld a,(wJabuWaterLevel)
	and $07
	ret z
	xor a
	ld (wJabuWaterLevel),a
	ld (wSwitchState),a
.ifndef REGION_JP
	ld a,<TX_1208
.endif

@beginCutscene:
.ifndef REGION_JP
	ld e,Interaction.var31
	ld (de),a
.endif

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld e,Interaction.counter1
	ld a,60
	ld (de),a

	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz

	ld a,$f0
	ld (hl),a
	call setScreenShakeCounter
	ld a,SND_FLOODGATES
	call playSound
	jp interactionIncState

@state3:
	call interactionDecCounter1
	ret nz

	ld l,Interaction.state
	ld (hl),$01
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

.ifdef REGION_JP
	ld bc,TX_1209
.else
	ld b,>TX_1200
	ld l,Interaction.var31
	ld c,(hl)
.endif
	call showText

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,(wActiveMusic)
	jp playSound



; Ladder spawner in d7 miniboss room
miscPuzzles_subid0b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set
	.dw @state1
	.dw @state2

@state1:
	ld a,(wNumEnemies)
	or a
	ret nz

	call getThisRoomFlags
	set ROOMFLAG_BIT_80,(hl)
	ld l,<ROOM_AGES_54d
	set ROOMFLAG_BIT_80,(hl)
	ld e,Interaction.counter1
	ld a,$08
	ld (de),a
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz

	; Add the next ladder tile
	ld (hl),$08
	call objectGetTileAtPosition
	ld c,l
	ld a,c
	ldh (<hFF92),a

	ld a,TILEINDEX_SS_LADDER
	call setTile

	ld b,INTERAC_PUFF
	call objectCreateInteractionWithSubid00

	ld e,Interaction.yh
	ld a,(de)
	add $10
	ld (de),a

	ldh a,(<hFF92)
	cp $90
	ret c

	; Restore the entrance on the left side
	ld c,$80
	ld a,TILEINDEX_SS_52
	call setTile
	ld c,$90
	ld a,TILEINDEX_SS_EMPTY
	call setTile

	ld a,SND_SOLVEPUZZLE
	call playSound
	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	jp interactionDelete



; Switch hook puzzle early in d7 for a small key
miscPuzzles_subid0c:
	call interactionDeleteAndRetIfEnabled02
	call miscPuzzles_deleteSelfAndRetIfItemFlagSet

	ld hl,miscPuzzles_subid0c_wantedTiles
	call miscPuzzles_verifyTilesAtPositions
	ret nz

;;
miscPuzzles_dropSmallKeyHere:
	ldbc TREASURE_SMALL_KEY, $01
	call createTreasure
	ret nz
	call objectCopyPosition
	jp interactionDelete

miscPuzzles_subid0c_wantedTiles:
	.db TILEINDEX_SWITCH_DIAMOND
	.db $36 $3a $76 $7a
	.db $00



; Staircase spawner after moving first set of stone panels in d8
miscPuzzles_subid0d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags
	and ROOMFLAG_40
	jp nz,interactionDelete

	ld a,(wNumTorchesLit)
	cp $01
	ret nz
	ld hl,wActiveTriggers
	ld a,(hl)
	cp $07
	ret nz

	ld e,Interaction.counter1
	ld a,30
	ld (de),a
	ld a,$08
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	call playSound
	jp interactionIncState

@state1:
	call interactionDecCounter1
	ret nz

	ld hl,wActiveTriggers
	ld a,(hl)
	cp $07
	jr z,++
	ld e,Interaction.state
	xor a
	ld (de),a
	ret
++
	set 7,(hl)
	jp interactionIncState

@state2:
	; Wait for bit 7 of wActiveTriggers to be unset by another object?
	ld a,(wActiveTriggers)
	bit 7,a
	ret nz

	ld a,SND_SOLVEPUZZLE
	call playSound
	ld b,INTERAC_PUFF
	call objectCreateInteractionWithSubid00

	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_NORTH_STAIRS
	call setTile
	jp interactionDelete



; Staircase spawner after putting in slates in d8
miscPuzzles_subid0e:
	call checkInteractionState
	jp nz,@state1

@state0:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_40,(hl)
	jp nz,interactionDelete

	; Wait for all slates to be put in
	ld a,(hl)
	and ROOMFLAG_01|ROOMFLAG_02|ROOMFLAG_04|ROOMFLAG_08
	cp  ROOMFLAG_01|ROOMFLAG_02|ROOMFLAG_04|ROOMFLAG_08
	ret nz

	ld hl,wActiveTriggers
	set 7,(hl)
	jp interactionIncState

@state1:
	; Wait for another object to unset bit 7 of wActiveTriggers?
	ld a,(wActiveTriggers)
	bit 7,a
	ret nz

	ld a,SND_SOLVEPUZZLE
	call playSound
	ld b,INTERAC_PUFF
	call objectCreateInteractionWithSubid00

	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_NORTH_STAIRS
	call setTile
	jp interactionDelete



; Octogon boss initialization (in the room just before the boss)
miscPuzzles_subid0f:
	ld hl,wTmpcfc0.octogonBoss.loadedExtraGfx
	xor a
	ldi (hl),a
	ldi (hl),a ; [var03] = 0
	dec a
	ldi (hl),a ; [direction] = $ff
	ld (hl),$28 ; [health]
	inc l
	ld (hl),$28 ; [y]
	inc l
	ld (hl),$78 ; [x]
	inc l
	ld (hl),a ; [var30] = $ff
	jp interactionDelete



; Something at the top of Talus Peaks?
miscPuzzles_subid10:
	ld hl,wTmpcfc0.patchMinigame.fixingSword
	ld b,$08
	call clearMemory
	jp interactionDelete



; D5 keyhole opening
miscPuzzles_subid11:
	call checkInteractionState
	jp nz,interactionRunScript

	call returnIfScrollMode01Unset
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete

	push de
	call reloadTileMap
	pop de
	ld hl,mainScripts.miscPuzzles_crownDungeonOpeningScript

;;
miscPuzzles_setScriptAndIncState:
	call interactionSetScript
	call interactionSetAlwaysUpdateBit
	jp interactionIncState



; D6 present/past keyhole opening
miscPuzzles_subid12:
	call checkInteractionState
	jp nz,interactionRunScript

	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete
	ld hl,mainScripts.miscPuzzles_mermaidsCaveDungeonOpeningScript
	jr miscPuzzles_setScriptAndIncState



; Eyeglass library keyhole opening
miscPuzzles_subid13:
	call checkInteractionState
	jp nz,interactionRunScript

	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete
	ld hl,mainScripts.miscPuzzles_eyeglassLibraryOpeningScript
	jr miscPuzzles_setScriptAndIncState



; Spot to put a rolling colored block on in Hero's Cave
miscPuzzles_subid14:
	call checkInteractionState
	jp z,miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set

	; Check that the tile at this position matches the cube color
	call objectGetTileAtPosition
	sub TILEINDEX_RED_TOGGLE_FLOOR
	cp $03
	ret nc
	ld b,a
	ld a,(wRotatingCubePos)
	cp l
	ret nz
	ld a,(wRotatingCubeColor)
	and $03
	cp b
	ret nz

	; They match.
	ld c,l
	ld hl,wActiveTriggers
	ld a,b
	call setFlag

	ld a,$a3
	call setTile

	ld b,>wRoomCollisions
	ld a,$0f
	ld (bc),a
	ld a,SND_CLINK
	jp playSound



; Stairs from solving colored cube puzzle in Hero's Cave (related to subid $14)
miscPuzzles_subid15:
	call checkInteractionState
	jp z,miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set

	ld a,(wActiveTriggers)
	cp $07
	ret nz

	ld a,SND_SOLVEPUZZLE
	call playSound
	ld a,TILEINDEX_INDOOR_DOWNSTAIRCASE
	ld c,$15
	call setTile
	call getThisRoomFlags
	set ROOMFLAG_BIT_80,(hl)
	jp interactionDelete



; Warps Link out of Hero's Cave upon opening the chest
miscPuzzles_subid16:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw miscPuzzles_deleteSelfOrIncStateIfItemFlagSet
	.dw @state1
	.dw @state2

@state1:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ret z
	call interactionIncState

@state2:
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a
	call retIfTextIsActive
	ld hl,@warpDestData
	call setWarpDestVariables
	jp interactionDelete

@warpDestData:
	m_HardcodedWarpA ROOM_AGES_048, $01, $28, $03



; Enables portal in Hero's Cave first room if its other end is active
miscPuzzles_subid17:
	call getThisRoomFlags
	push hl
	ld l,<ROOM_AGES_4c9
	bit ROOMFLAG_BIT_ITEM,(hl)
	pop hl
	jr z,+
	set ROOMFLAG_BIT_ITEM,(hl)
+
	jp interactionDelete



; Drops a key in hero's cave block-pushing puzzle
miscPuzzles_subid18:
	call checkInteractionState
	jp z,miscPuzzles_deleteSelfOrIncStateIfItemFlagSet

	ld hl,wRoomLayout+$95
	ld a,(hl)
	cp TILEINDEX_PUSHABLE_STATUE
	ret nz
	ld l,$5d
	ld a,(hl)
	cp TILEINDEX_PUSHABLE_STATUE
	ret nz
	jp miscPuzzles_dropSmallKeyHere



; Bridge controller in d5 room after the miniboss
miscPuzzles_subid19:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionIncState
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

; Trigger off, waiting for it to be pressed
@state1:
	ld a,(wActiveTriggers)
	rrca
	ret nc
	ld e,Interaction.counter1
	ld a,$08
	ld (de),a
	jp interactionIncState

; Trigger enabled, in the process of extending the bridge
@state2:
	ld a,(wActiveTriggers)
	rrca
	jr nc,@@releasedTrigger
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld hl,wRoomLayout+$55
--
	ld c,l
	ldi a,(hl)
	cp TILEINDEX_BLANK_HOLE
	jr nz,++
	ld a,TILEINDEX_HORIZONTAL_BRIDGE
	call setTileInAllBuffers
	ld a,SND_DOORCLOSE
	jp playSound
++
	ld a,l
	cp $5a
	jr c,--
	jp interactionIncState

@@releasedTrigger:
	call interactionIncState
	inc (hl)
	ret

; Bridge fully extended, waiting for trigger to be released
@state3:
	ld a,(wActiveTriggers)
	rrca
	ret c
	jp interactionIncState

; Trigger released, in the process of retracting the bridge
@state4:
	ld a,(wActiveTriggers)
	rrca
	jr c,@@pressedTrigger
	call interactionDecCounter1
	ret nz

	ld (hl),$08

	ld hl,wRoomLayout+$59
--
	ld c,l
	ldd a,(hl)
	cp TILEINDEX_BLANK_HOLE
	jr z,++

	cp TILEINDEX_SWITCH_DIAMOND
	call z,@createDebris

	ld a,TILEINDEX_BLANK_HOLE
	call setTileInAllBuffers
	ld a,SND_DOORCLOSE
	jp playSound
++
	ld a,l
	cp $55
	jr nc,--

@@pressedTrigger:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret

@createDebris:
	push hl
	push bc
	ld b,INTERAC_ROCKDEBRIS
	call objectCreateInteractionWithSubid00
	pop bc
	pop hl
	ret



; Checks solution to pushblock puzzle in Hero's Cave
miscPuzzles_subid1a:
	call interactionDeleteAndRetIfEnabled02
	call miscPuzzles_deleteSelfAndRetIfItemFlagSet

	ld hl,@wantedTiles
	call miscPuzzles_verifyTilesAtPositions
	ret nz
	jpab agesInteractionsBank08.spawnChestAndDeleteSelf

@wantedTiles:
	.db TILEINDEX_RED_PUSHABLE_BLOCK    $4a $4b $4c $ff
	.db TILEINDEX_YELLOW_PUSHABLE_BLOCK $5a $5c $ff
	.db TILEINDEX_BLUE_PUSHABLE_BLOCK   $6a $6c $00



; Subids $1b-$1d: Spawn gasha seeds at the top of the maku tree at specific times.
; b = essence that must be obtained; c = position to spawn it at.
miscPuzzles_subid1b:
	ldbc $08, $53
	jr ++

miscPuzzles_subid1c:
	ldbc $40, $34
	jr ++

miscPuzzles_subid1d:
	ldbc $20, $34
++
	push bc
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	pop bc
	jr nc,@delete
	and b
	jr z,@delete

	call objectSetShortPosition
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jr nz,@delete

	ld bc,TREASURE_OBJECT_GASHA_SEED_07
	call createTreasure
	call z,objectCopyPosition
@delete:
	jp interactionDelete



; Play "puzzle solved" sound after navigating eyeball puzzle in final dungeon
miscPuzzles_subid1e:
	call returnIfScrollMode01Unset
	ld a,(wScreenTransitionDirection)
	or a
	jp nz,interactionDelete
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete



; Checks if Link gets stuck in the d5 boss key puzzle, resets the room if so
miscPuzzles_subid1f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionIncState
	.dw @state1
	.dw @state2

@state1:
	call interactionDecCounter1
	ret nz

	ld (hl),30

	; Get Link's short position in 'e'
	ld hl,w1Link.yh
	ldi a,(hl)
	and $f0
	ld b,a
	inc l
	ld a,(hl)
	and $f0
	swap a
	or b
	ld e,a

	push de
	ld hl,@offsetsToCheck
	ld d,$08

@checkNextOffset:
	ldi a,(hl)
	add e
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	jr z,@doneCheckingIfTrapped

	; For odd-indexed offsets only (one tile away from Link), check if we're near the
	; screen edge? If so, skip the next check?
	bit 0,d
	jr nz,++

	ld b,>wRoomLayout
	ld a,(bc)
	or a
	jr nz,++
	inc hl
	dec d
++
	dec d
	jr nz,@checkNextOffset

@doneCheckingIfTrapped:
	ld a,d
	pop de
	or a
	ret nz

	; Link is trapped; warp him out
	call checkLinkVulnerable
	ret nc
	ld a,DISABLE_LINK
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,SND_ERROR
	call playSound

	ld e,Interaction.counter1
	ld a,60
	ld (de),a
	jp interactionIncState

; Checks if there are solid walls / holes at all of these positions relative to Link
@offsetsToCheck:
	.db $f0 $e0 $01 $02 $10 $20 $ff $fe

@state2:
	call interactionDecCounter1
	ret nz
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_AGES_49b, $00, $12, $03



; Money in sidescrolling room in Hero's Cave
miscPuzzles_subid20:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jr nz,@delete

	ld bc,TREASURE_OBJECT_RUPEES_16
	call createTreasure
	jp nz,@delete
	call objectCopyPosition
@delete:
	jp interactionDelete



; Creates explosions while screen is fading out; used in some cutscene?
miscPuzzles_subid21:
	call checkInteractionState
	jr z,@state0

	ld a,(wPaletteThread_mode)
	or a
	jp z,interactionDelete

	ld a,(wFrameCounter)
	ld b,a
	and $1f
	ret nz

	ld a,b
	and $70
	swap a
	ld hl,@explosionPositions
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_EXPLOSION
	jp objectCopyPositionWithOffset

@explosionPositions:
	.db $f4 $0c
	.db $04 $fb
	.db $08 $10
	.db $fe $f4
	.db $0c $08
	.db $fc $04
	.db $06 $f8
	.db $f8 $fe

@state0:
	call interactionIncState
	ld a,$04
	jp fadeoutToWhiteWithDelay

;;
miscPuzzles_deleteSelfAndRetIfItemFlagSet:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ret z
	pop hl
	jp interactionDelete

;;
miscPuzzles_deleteSelfOrIncStateIfItemFlagSet:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete
	jp interactionIncState

;;
miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set:
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete
	jp interactionIncState

;;
; Unused
miscPuzzles_deleteSelfOrIncStateIfRoomFlag6Set:
	call getThisRoomFlags
	and ROOMFLAG_40
	jp nz,interactionDelete
	jp interactionIncState
