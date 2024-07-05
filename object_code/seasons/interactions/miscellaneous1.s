; ==================================================================================================
; INTERAC_MISCELLANEOUS_1
; ==================================================================================================
interactionCode6b:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	/* $00 */ .dw floodgateKeeper
	/* $01 */ .dw floodgateKeeperSwitchScript
	/* $02 */ .dw floodgateKeyhole
	/* $03 */ .dw d4KeyHole
	/* $04 */ .dw floodgateKey
	/* $05 */ .dw dragonKey
	/* $06 */ .dw tarmArmosUnlockingStairs
	/* $07 */ .dw tarmArmosWallByStump
	/* $08 */ .dw tarmEscapedLostWoods
	/* $09 */ .dw oreChunkDigSpot
	/* $0a */ .dw staticHeartPiece
	/* $0b */ .dw permanentlyRemovableObjects
	/* $0c */ .dw piratesBellRoomWhenFallingIn
	/* $0d */ .dw greenJoyRing
	/* $0e */ .dw masterDiverPuzzle
	/* $0f */ .dw piratesBell
	/* $10 */ .dw armosBlockingFlowerPathToD6
	/* $11 */ .dw natzuSwitch
	/* $12 */ .dw onoxCastleCutscene
	/* $13 */ .dw savingZeldaNoEnemiesHandler
	/* $14 */ .dw unblockingD3Dam
	/* $15 */ .dw replacePirateShipWithQuicksand
	/* $16 */ .dw stolenFeatherGottenHandler
	/* $17 */ .dw horonVillagePortalBridgeSpawner
	/* $18 */ .dw randomRingDigSpot
	/* $19 */ .dw staticGashaSeed
	/* $1a */ .dw underwaterGashaSeed
	/* $1b */ .dw tickTockSecretEntrance
	/* $1c */ .dw graveSecretEntrance
	/* $1d */ .dw d4MinibossRoom
	/* $1e */ .dw sentBackFromOnoxCastleBarrier
	/* $1f */ .dw sidescrollingStaticGashaSeed
	/* $20 */ .dw sidescrollingStaticSeedSatchel
	/* $21 */ .dw mtCuccoBananaTree
	/* $22 */ .dw hardOre
	.dw interactionCode6bSubid23
	.dw interactionCode6bSubid24
	.dw interactionCode6bSubid25
	.dw interactionCode6bSubid26

floodgateKeeper:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,mainScripts.floodgateKeeperScript
	call interactionSetScript
	call objectSetVisible82
	xor a
	ld ($cfc1),a
@state1:
	call interactionAnimate
	call objectPreventLinkFromPassing
	jp interactionRunScript

floodgateKeeperSwitchScript:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 6,(hl)
	jr z,+
	ld bc,wRoomLayout|$68
	ld a,TILEINDEX_DUNGEON_SWITCH_ON
	ld (bc),a
	jp interactionDelete
+
	call interactionInitGraphics
	call objectSetVisible83
	call objectSetInvisible
	xor a
	ld (wSwitchState),a
	ld hl,mainScripts.floodgateSwitchScript
	jp interactionSetScript
@state1:
	call interactionAnimate
runScriptDeleteWhenDone:
	call interactionRunScript
	ret nc
	jp interactionDelete

floodgateKeyhole:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionRunScript
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	ld hl,mainScripts.floodgateKeyholeScript_keyEntered
	jp interactionSetScript
@state2:
	ld a,$04
	call setScreenShakeCounter
	ld a,($cfc0)
	bit 7,a
	ret z
	ld a,($cc62)
	ld (wActiveMusic),a
	call playSound
	jr ++

resetMusicThenSolvePuzzleSound:
	ld a,$ff
	ld (wActiveMusic),a
++
	xor a
	ld ($cc02),a
	ld ($cca4),a
	ld a,$f1
	call playSound
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete


d4KeyHole:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	call objectSetReservedBit1
	ld a,$01
	ld (wScreenShakeMagnitude),a
	ld hl,mainScripts.d4KeyholeScript_disableThingsAndScreenShake
	jp interactionSetScript
@state1:
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_00d
	jp nz,interactionDelete
	call interactionRunScript
	ret nc
	call interactionIncState
	ld hl,scripts2.simpleScript_waterfallEmptyingAboveD4
	jp interactionSetSimpleScript
@func_621c:
	ld h,d
	ld l,$46
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret
@state2:
	call @func_621c
	ret nz
	call interactionRunSimpleScript
	ret nc
	call interactionIncState
	ld a,$1d
	ld b,$02
	call func_1383
	callab scriptHelp.d4KeyHolw_disableAllSorts
	ret
@state3:
	ld a,($cd00)
	and $01
	ret z
	call getThisRoomFlags
	set 7,(hl)
	call interactionIncState
	ld hl,scripts2.simpleScript_waterfallEmptyingAtD4
	jp interactionSetSimpleScript
@state4:
	ld a,$3c
	call setScreenShakeCounter
	call @func_621c
	ret nz
	call interactionRunSimpleScript
	ret nc
	ld hl,@warpDestVariables
	call setWarpDestVariables
	jp resetMusicThenSolvePuzzleSound
@warpDestVariables:
	.db $c0 $0d $01 $23 $03

floodgateKey:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw interactionRunScript
@state0:
	call getThisRoomFlags
	and $60
	cp $40
	ret nz
	ldbc TREASURE_FLOODGATE_KEY $00
	call misc1_spawnTreasureBC
	jp interactionIncState
@state1:
	ld a,TREASURE_FLOODGATE_KEY
	call checkTreasureObtained
	ret nc
	call interactionIncState
	ld hl,$cca4
	set 7,(hl)
	ld a,$01
	ld ($cc02),a
	ld hl,mainScripts.floodgateKeyScript_keeperNoticesKey
	jp interactionSetScript

dragonKey:
	ldbc TREASURE_DRAGON_KEY $00
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet
	
tarmArmosUnlockingStairs:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw runScriptDeleteWhenDone
@state0:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call interactionIncState
	ld hl,mainScripts.tarmArmosUnlockingStairsScript
	jp interactionSetScript
@state1:
	call objectGetTileAtPosition
	cp $04
	ret nz
	call interactionIncState
	jp runScriptDeleteWhenDone

tarmArmosWallByStump:
	ld a,($cc4c)
	cp $42
	jp nz,interactionDelete
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	jp nz,interactionDelete
	call getThisRoomFlags
	ld e,$4b
	ld a,(de)
	and (hl)
	jp nz,interactionDelete
	jp objectSetReservedBit1
@state1:
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	jp nz,interactionDelete
	ld e,$4d
	ld a,(de)
	ld l,a
	ld h,$cf
	ld a,$9c
	cp (hl)
	ret nz
	jp interactionIncState
@state2:
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	ret z
	ld a,($c4ab)
	or a
	ret z
	call getThisRoomFlags
	ld e,$4b
	ld a,(de)
	or (hl)
	ld (hl),a
	ld e,$4d
	ld a,(de)
	dec a
	ld c,a
	ld a,$09
	call setTile
	inc c
	ld a,$bc
	call setTile
	jr ++

tarmEscapedLostWoods:
	call returnIfScrollMode01Unset
	ld a,($cd02)
	or a
	jp nz,interactionDelete
++
	ld a,$4d
	call playSound
	jp interactionDelete

oreChunkDigSpot:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld e,$43
	ld a,(de)
	or a
	jr nz,+
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
+
	call objectGetShortPosition
	ld ($ccc5),a
@state1:
	ld a,($ccc5)
	inc a
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PART_ITEM_DROP
	inc l
	ld (hl),$0e
	inc l
	ld (hl),$01
	ld a,($d008)
	swap a
	rrca
	ld l,$c9
	ld (hl),a
	call objectCopyPosition
	jp interactionDelete
	
staticHeartPiece:
	ldbc TREASURE_HEART_PIECE $00
misc1_spawnTreasureBCifRoomFlagBit5NotSet:
	call getThisRoomFlags
	and $20
	jr nz,+
	call misc1_spawnTreasureBC
+
	jp interactionDelete

misc1_spawnTreasureBC:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	jp objectCopyPosition

; eg rocks, ember trees that should stay removed
permanentlyRemovableObjects:
	call checkInteractionState
	jr nz,@state1
	call returnIfScrollMode01Unset
	call getThisRoomFlags
	ld e,Interaction.xh
	ld a,(de)
	and (hl)
	jp nz,interactionDelete
	ld b,>wRoomLayout
	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld a,(bc)
	ld e,Interaction.var03
	ld (de),a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
@state1:
	ld a,(wScrollMode)
	and $01
	jp z,interactionDelete
	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	ld e,Interaction.yh
	ld a,(de)
	ld l,a
	ld h,>wRoomLayout
	ld a,b
	cp (hl)
	ret z
	call getThisRoomFlags
	ld e,Interaction.xh
	ld a,(de)
	or (hl)
	ld (hl),a
	jp interactionDelete

piratesBellRoomWhenFallingIn:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw runScriptDeleteWhenDone
@state0:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	call interactionIncState
@state1:
	call getThisRoomFlags
	and $20
	ret z
	ld hl,$cca4
	set 0,(hl)
	ld a,$01
	ld ($cc02),a
	call interactionIncState
	ld hl,mainScripts.piratesBellRoomDroppingInScript
	jp interactionSetScript

greenJoyRing:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ld a,(wActiveTriggers)
	or a
	ret z
	ldbc GREEN_JOY_RING $01
createRingTreasureAtPosition:
	call createRingTreasure
	ret nz
	call objectCopyPosition
	jp interactionDelete

masterDiverPuzzle:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	ld h,d
	ld l,$44
	ld (hl),$01
	ld l,$70
	ld b,$06
	jp clearMemory
@state1:
	call @checkLinkSwordSpin
	ret nz
	ld a,$02
	ld (de),a
@state2:
	call @checkLinkSwordSpin
	jr nz,@state0
	ld a,(wccaf)
	cp $2b
	jr z,+
	cp TILEINDEX_PUSHABLE_STATUE
	ret nz
+
	ld h,d
	ld l,$70
	ld a,(wccb0)
	ld c,a
-
	ldi a,(hl)
	cp c
	ret z
	or a
	jr nz,-
	dec l
	ld (hl),c
	ld a,l
	cp $73
	jr nc,+
	ret
+
	ld l,$44
	ld (hl),$03
	ld hl,mainScripts.masterDiverPuzzleScript_solved
	call interactionSetScript
@state3:
	call interactionRunScript
	jp c,interactionDelete
	ret
@checkLinkSwordSpin:
	ld a,(wcc63)
	and $0f
	cp $02
	ret

piratesBell:
	ldbc TREASURE_PIRATES_BELL $00
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

armosBlockingFlowerPathToD6:
	call returnIfScrollMode01Unset
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	bit 6,(hl)
	jp nz,interactionDelete
	call objectGetTileAtPosition
	cp $d6
	ret z
	ld a,(wBlockPushAngle)
	and $7f
	cp ANGLE_LEFT
	ld b,$80
	jr z,+
	ld b,$40
+
	call getThisRoomFlags
	or b
	ld (hl),a
	jp interactionDelete

natzuSwitch:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECT_DIMITRI
	jp z,interactionDelete
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call getFreePartSlot
	ret nz
	ld (hl),PART_SWITCH
	inc l
	ld (hl),$01
	jp objectCopyPosition
@state1:
	ld a,(wSwitchState)
	or a
	ret z
	ld a,$81
	ld ($cc02),a
	ld ($cca4),a
	ld ($ccab),a
	call getThisRoomFlags
	set 6,(hl)
	call interactionIncState
	ld hl,scripts2.simpleScript_creatingBridgeToNatzu
	jp interactionSetSimpleScript
@state2:
	call d4KeyHole@func_621c
	ret nz
	call interactionRunSimpleScript
	ret nc
	xor a
	ld ($cc02),a
	ld ($cca4),a
	ld ($ccab),a
	jp interactionDelete

onoxCastleCutscene:
	ld a,GLOBALFLAG_WITCHES_2_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,$01
	ld ($cca4),a
	ld ($cc02),a
	call returnIfScrollMode01Unset
	ld a,CUTSCENE_S_ONOX_CASTLE_FORCE
	ld (wCutsceneTrigger),a
	xor a
	ld ($d008),a
	call dropLinkHeldItem
	call clearAllParentItems
	jp interactionDelete

savingZeldaNoEnemiesHandler:
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	ret z
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	ret nz
	ld a,$80
	ld (wcc85),a
	jp interactionDelete

unblockingD3Dam:
	ld h,d
	ld l,$46
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret nz
+
	call checkInteractionState
	jr nz,@state1
	call interactionIncState
	ld hl,scripts2.simpleScript_unblockingD3Dam
	jp interactionSetSimpleScript
@state1:
	call interactionRunSimpleScript
	ret nc
	ld hl,$cfc0
	set 7,(hl)
	jp interactionDelete
	
replacePirateShipWithQuicksand:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	jp z,interactionDelete
	ld b,INTERAC_QUICKSAND
	call objectCreateInteractionWithSubid00
	jp interactionDelete
	
stolenFeatherGottenHandler:
	call checkInteractionState
	jr nz,@state1
	call objectGetTileAtPosition
	ld h,d
	ld l,$49
	ld (hl),a
	ld l,$44
	inc (hl)
@state1:
	ld a,$01
	ld ($ccab),a
	call objectGetTileAtPosition
	ld e,$49
	ld a,(de)
	cp (hl)
	ret z
	xor a
	ld ($ccab),a
	jp interactionDelete
	
horonVillagePortalBridgeSpawner:
	call checkInteractionState
	jr nz,@state1
	xor a
	ld (wSwitchState),a
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call interactionIncState
@state1:
	ld a,(wSwitchState)
	or a
	ret z
	call getThisRoomFlags
	set 6,(hl)
	ld a,$4d
	call playSound
	ld bc,$0047
	ld e,$08
	call @spawnBridge
	ld bc,$0114
	ld e,$06
	call @spawnBridge
	jp interactionDelete
@spawnBridge:
	call getFreePartSlot
	ret nz
	ld (hl),PART_BRIDGE_SPAWNER
	ld l,$c7
	ld (hl),e
	ld l,$c9
	ld (hl),b
	ld l,$cb
	ld (hl),c
	ret

; Under Vasu's sign, and by wilds ore
randomRingDigSpot:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ld c,$02
	call getRandomRingOfGivenTier
	ld b,c
	ld c,$03
	jp createRingTreasureAtPosition

staticGashaSeed:
	ldbc TREASURE_GASHA_SEED $04
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

underwaterGashaSeed:
	ldbc TREASURE_GASHA_SEED $05
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

tickTockSecretEntrance:
	call checkInteractionState
	jr nz,@state1
	call objectGetTileAtPosition
	cp $04
	ret nz
	ld a,l
	ld ($ccc5),a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret
@state1:
	call returnIfScrollMode01Unset
	call objectGetTileAtPosition
	cp $04
	ret z
setEnteredWarpSetStairsPlaySolvedSound:
	ld c,l
	ld a,c
	ld (wEnteredWarpPosition),a
	ld a,$e7
	call setTile
	ld a,$4d
	call playSound
	jp interactionDelete

graveSecretEntrance:
	call returnIfScrollMode01Unset
	call objectGetTileAtPosition
	cp $01
	ret z
	ld a,l
	ld ($ccc5),a
	jr setEnteredWarpSetStairsPlaySolvedSound

d4MinibossRoom:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	ld hl,objectData.objectData7e96
	jp parseGivenObjectData
+
	ld a,(wNumTorchesLit)
	cp $02
	ret nz
	call getThisRoomFlags
	set 7,(hl)
	jp interactionDelete
	
sentBackFromOnoxCastleBarrier:
	call checkInteractionState
	jr nz,@state1
	ld a,GLOBALFLAG_ONOX_CASTLE_BARRIER_GONE
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ONOX_CASTLE_BARRIER_GONE
	call unsetGlobalFlag
	ld h,d
	ld l,$44
	inc (hl)
	ld l,$46
	ld (hl),$3c
@state1:
	ld a,$01
	ld ($cca4),a
	call interactionDecCounter1
	ret nz
	xor a
	ld ($cc02),a
	ld ($cca4),a
	ld bc,TX_501b
	call showText
	jp interactionDelete
	
sidescrollingStaticGashaSeed:
	ldbc TREASURE_GASHA_SEED $04
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

sidescrollingStaticSeedSatchel:
	ldbc TREASURE_SEED_SATCHEL $00
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

mtCuccoBananaTree:
	ld a,($cc4e)
	or a
	jp nz,interactionDelete
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ldbc TREASURE_SPRING_BANANA $00
	call misc1_spawnTreasureBC
	ld b,h
	ld a,$06
	ldi (hl),a
	ld (hl),a
	call getFreePartSlot
	jp nz,interactionDelete
	ld (hl),PART_GASHA_TREE
	ld l,$d6
	ld (hl),$40
	inc l
	ld (hl),b
	jp interactionDelete

hardOre:
	call getThisRoomFlags
	and $40
	jp z,interactionDelete
	ldbc TREASURE_HARD_ORE $00
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

; TODO: has 3 buttons, 2 keese (linked hero's cave?)
interactionCode6bSubid23:
	call checkInteractionState
	jr nz,@state1
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete
	ld hl,wActiveTriggers
	ld a,(hl)
	cp $04
	jr nz,+
	set 7,(hl)
+
	cp $85
	jr nz,+
	set 6,(hl)
+
	and $07
	cp $07
	ret nz
	ld a,$1e
	ld e,$46
	ld (de),a
	jp interactionIncState
@state1:
	call interactionDecCounter1
	ret nz
	ld a,(wActiveTriggers)
	bit 6,a
	ld b,$5a
	jr z,+
	ld c,$5c
	ld a,$05
	call setTile
	call objectCreatePuff
	call getThisRoomFlags
	set 7,(hl)
	ld b,$4d
+
	ld a,b
	call playSound
	jp interactionDelete
	
; TODO: 4 orbs (linked hero's cave?)
interactionCode6bSubid24:
	ld a,(wToggleBlocksState)
	and $0f
	cp $0e
	ld a,$01
	jr z,+
	dec a
+
	ld (wActiveTriggers),a
	ret

; TODO: spawns up stair case when all enemies defeated
interactionCode6bSubid25:
	call checkInteractionState
	jr nz,@state1
	ld a,(wNumEnemies)
	or a
	ret nz
	call interactionIncState
	ld l,$46
	ld (hl),$3c
@state1:
	call interactionDecCounter1
	ret nz
	call objectCreatePuff
	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_INDOOR_UPSTAIRCASE
	call setTile
	xor a
	ld ($cbca),a
	jp interactionDelete

; TODO: there is a subrosian where this one should be?
interactionCode6bSubid26:
	call checkInteractionState
	jp nz,interactionRunScript
	ld hl,mainScripts.subrosianScript_templeFallenText
	call interactionSetScript
	jp interactionIncState
