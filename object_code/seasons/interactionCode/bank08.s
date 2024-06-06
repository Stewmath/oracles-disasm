 m_section_free Seasons_Interactions_Bank08 NAMESPACE seasonsInteractionsBank08

; ==============================================================================
; INTERACID_USED_ROD_OF_SEASONS
; ==============================================================================
interactionCode15:
	ld a,(wMenuDisabled)
	ld b,a
	ld a,(wLinkDeathTrigger)
	or b
	jr nz,+
	ld a,(wActiveGroup)
	or a
	jr nz,+
	ld hl,wObtainedSeasons
	ld a,(hl)
	add a
	jr z,+
	ld a,(wRoomStateModifier)
-
	inc a
	and $03
	ld b,a
	call checkFlag
	ld a,b
	jr z,-
	call setSeason
	ld a,SND_ENERGYTHING
	call playSound
	ld a,$02
	ld (wPaletteThread_updateRate),a
+
	jp interactionDelete


; ==============================================================================
; INTERACID_S_SPECIAL_WARP
; ==============================================================================
interactionCode1f:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw specialWarp_subid0
	.dw specialWarp_subid1
	.dw specialWarp_subid2
	.dw specialWarp_subid3
	.dw specialWarp_subid4
	.dw specialWarp_subid5
	.dw specialWarp_subid6
	.dw specialWarp_subid7
	.dw specialWarp_subid8
	.dw specialWarp_subid9
	.dw specialWarp_subidA
	.dw specialWarp_subidB
	.dw specialWarp_subidC
	.dw specialWarp_subidD

specialWarp_subid0:
specialWarp_subid1:
	call checkInteractionState
	jr nz,+
	ld a,($cd00)
	and $01
	ret z
	ld a,$01
	ld (de),a
	call objectGetTileAtPosition
	ld (hl),$20
+
	ld a,($cc77)
	or a
	ret nz
	call objectGetTileAtPosition
	ld a,($ccb3)
	cp l
	ret nz
	ld (hl),$eb
	ld a,$81
	ld ($cca4),a
	jp interactionDelete

specialWarp_subid2:
specialWarp_subid3:
specialWarp_subid4:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld e,$42
	ld a,(de)
	sub $02
	add a
	ld hl,@table_51e5
	rst_addDoubleIndex
	ld e,$70
	ld b,$03
	call copyMemory
	ld e,$67
	ldi a,(hl)
	ld (de),a
	dec e
	ld a,$0a
	ld (de),a
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ld a,$01
	jr nc,+
	inc a
+
	ld e,$44
	ld (de),a
	ret

@table_51e5:
	.db $05 $bc $97 $10
	.db $05 $bd $97 $18
	.db $05 $0d $97 $18

	.db $00 $2e $61 $00
	.db $00 $2e $75 $00
	.db $00 $5a $54 $00

@state1:
	ld a,d
	ld (wDisableWarpTiles),a
	ld a,($cc48)
	cp $d1
	ret nz
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	xor a
	ld ($cc65),a
@setWarpVariables:
	ld h,d
	ld l,$70
	ldi a,(hl)
	ld (wWarpDestGroup),a
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ld a,(hl)
	ld (wWarpDestPos),a
	ld a,$03
	ld (wWarpTransition2),a
	ld a,$01
	ld (wScrollMode),a
	jp interactionDelete

@state2:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret c
	ld e,$44
	ld a,$01
	ld (de),a
	ret

specialWarp_subid5:
specialWarp_subid6:
specialWarp_subid7:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call specialWarp_subid4@state0
	xor a
	ld (wActiveMusic),a
	jp interactionSetAlwaysUpdateBit
@state1:
@state2:
	ld a,d
	ld ($ccab),a
	ld a,($cc48)
	cp $d1
	ret nz
	xor a
	ld ($ccab),a
	ld a,($cd00)
	and $01
	ret nz
	xor a
	ld ($cd00),a
	ld a,$ff
	ld ($cca4),a
	ld (wActiveMusic),a
	jr specialWarp_subid4@setWarpVariables

specialWarp_subid8:
specialWarp_subid9:
specialWarp_subidA:
specialWarp_subidB:
specialWarp_subidC:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	ld a,$02
	call objectSetCollideRadius
+
	ld a,($cc78)
	rlca
	ret nc
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	ld e,$42
	ld a,(de)
	sub $08
	ld hl,table_52a4
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ld a,(hl)
	ld (wWarpDestPos),a
	ld a,$87
	ld (wWarpDestGroup),a
	ld a,$01
	ld (wWarpTransition),a
@fadeoutTransition:
	ld a,$03
	ld (wWarpTransition2),a
	jp interactionDelete

table_52a4:
	.db $e0 $02
	.db $e1 $0b
	.db $e4 $02
	.db $e6 $02
	.db $e7 $0d

specialWarp_subidD:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	ld a,$02
	call objectSetCollideRadius
+
	ld a,($cc78)
	rlca
	ret nc
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	ld hl,$cc63
	ld (hl),$85
	inc l
	ld (hl),$12
	inc l
	ld (hl),$05
	inc l
	ld (hl),$29
	jr specialWarp_subidC@fadeoutTransition


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
	.dw @dungeonA
	.dw @dungeonB

@dungeon0:
	.dw mainScripts.dungeonScript_end
	.dw mainScripts.dungeonScript_checkActiveTriggersEq01

@dungeon1:
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_checkActiveTriggersEq01
	.dw mainScripts.dungeonScript_checkActiveTriggersEq01
	.dw mainScripts.dungeonScript_bossDeath

@dungeon2:
	.dw mainScripts.snakesRemainsScript_timerForChestDisappearing
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.snakesRemainsScript_bossDeath

@dungeon3:
	.dw mainScripts.poisonMothsLairScript_hallwayTrapRoom
	.dw mainScripts.poisonMothsLairScript_checkStatuePuzzle
	.dw mainScripts.poisonMothsLairScript_minibossDeath
	.dw mainScripts.poisonMothsLairScript_bossDeath
	.dw mainScripts.poisonMothsLairScript_openEssenceDoorIfBossBeat

@dungeon4:
	.dw mainScripts.dancingDragonScript_spawnStairsToB1
	.dw mainScripts.dancingDragonScript_torchesHallway
	.dw mainScripts.dancingDragonScript_torchesHallway
	.dw mainScripts.dancingDragonScript_spawnBossKey
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dancingDragonScript_pushingPotsRoom
	.dw mainScripts.dancingDragonScript_bridgeInB2

@dungeon5:
	.dw mainScripts.unicornsCaveScript_spawnBossKey
	.dw mainScripts.unicornsCaveScript_dropMagnetBallAfterDarknutKill
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath

@dungeon6:
	.dw mainScripts.dungeonScript_spawnKeyOnMagnetBallToButton
	.dw mainScripts.ancientRuinsScript_spawnStaircaseUp1FTopLeftRoom
	.dw mainScripts.ancientRuinsScript_spawnStaircaseUp1FTopMiddleRoom
	.dw mainScripts.ancientRuinsScript_4c50
	.dw mainScripts.ancientRuinsScript_5TorchesMovingPlatformsRoom
	.dw mainScripts.ancientRuinsScript_roomWithJustRopesSpawningButton
	.dw mainScripts.ancientRuinsScript_UShapePitToMagicBoomerangOrb
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.ancientRuinsScript_randomButtonRoom
	.dw mainScripts.ancientRuinsScript_4F3OrbsRoom
	.dw mainScripts.ancientRuinsScript_spawnStairsLeadingToBoss
	.dw mainScripts.ancientRuinsScript_spawnHeartContainerAndStairsUp
	.dw mainScripts.ancientRuinsScript_1FTopRightTrapButtonRoom
	.dw mainScripts.ancientRuinsScript_crystalTrapRoom
	.dw mainScripts.ancientRuinsScript_spawnChestAfterCrystalTrapRoom

@dungeon7:
	.dw mainScripts.explorersCryptScript_4OrbTrampoline
	.dw mainScripts.explorersCryptScript_magunesuTrampoline
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.explorersCryptScript_4d05
	.dw mainScripts.explorersCryptScript_randomlyPlaceNonEnemyArmos
	.dw mainScripts.dungeonScript_checkIfMagnetBallOnButton
	.dw mainScripts.explorersCryptScript_1stPoeSisterRoom
	.dw mainScripts.explorersCryptScript_2ndPoeSisterRoom
	.dw mainScripts.explorersCryptScript_4FiresRoom_1
	.dw mainScripts.explorersCryptScript_4FiresRoom_2
	.dw mainScripts.explorersCryptScript_darknutBridge
	.dw mainScripts.explorersCryptScript_roomLeftOfRandomArmosRoom
	.dw mainScripts.explorersCryptScript_dropKeyDownAFloor
	.dw mainScripts.explorersCryptScript_keyDroppedFromAbove

@dungeon8:
	.dw mainScripts.swordAndShieldMazeScript_verticalBridgeUnlockedByOrb
	.dw mainScripts.swordAndShieldMazeScript_verticalBridgeInLava
	.dw mainScripts.swordAndShieldMazeScript_armosBlockingStairs
	.dw mainScripts.dungeonScript_spawnKeyOnMagnetBallToButton
	.dw mainScripts.swordAndShieldMazeScript_7torchesAfterMiniboss
	.dw mainScripts.swordAndShieldMazeScript_spawnFireKeeseAtLavaHoles
	.dw mainScripts.swordAndShieldMazeScript_pushableIceBlocks
	.dw mainScripts.dungeonScript_minibossDeath
	.dw mainScripts.dungeonScript_bossDeath
	.dw mainScripts.swordAndShieldMazeScript_horizontalBridgeByMoldorms
	.dw mainScripts.swordAndShieldMazeScript_tripleEyesByMiniboss
	.dw mainScripts.swordAndShieldMazeScript_tripleEyesNearStart

@dungeon9:
	.dw mainScripts.onoxsCastleScript_setFlagOnAllEnemiesDefeated
	.dw mainScripts.onoxsCastleScript_resetRoomFlagsOnDungeonStart

@dungeonA:
@dungeonB:
	.dw mainScripts.dungeonScript_spawnKeyOnMagnetBallToButton
	.dw mainScripts.dungeonScript_checkActiveTriggersEq01
	.dw mainScripts.herosCaveScript_spawnChestOnTorchLit
	.dw mainScripts.dungeonScript_checkIfMagnetBallOnButton
	.dw mainScripts.herosCaveScript_check6OrbsHit
	.dw mainScripts.herosCaveScript_allButtonsPressedAndEnemiesDefeated
	.dw mainScripts.herosCaveScript_spawnChestOn2TorchesLit


; ==============================================================================
; INTERACID_GNARLED_KEYHOLE
; ==============================================================================
interactionCode21:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionRunScript
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete
	ld e,$44
	ld a,$01
	ld (de),a
	ld a,$01
	ld (wDisableWarpTiles),a
	call func_5469
	ld hl,mainScripts.gnarledKeyholeScript
	jp interactionSetScript
@state2:
	call interactionIncState
	ld l,$46
	ld (hl),$1e
	call setLinkForceStateToState08
	ld a,($cca4)
	or $80
	ld ($cca4),a
	call func_545d
@state3:
	call func_54ae
	call interactionDecCounter1
	jr nz,func_545d
	ld l,$47
	ld a,(hl)
	cp $04
	jr nc,+
	inc (hl)
	ld a,(hl)
	call func_549d
	ld a,$82
	call playSound
	ld e,$47
	ld a,(de)
	ld hl,@table_542d
	rst_addDoubleIndex
	dec e
	ldi a,(hl)
	ld (de),a
	ld a,(hl)
	or a
	jr z,func_5463
+
	ld l,$44
	inc (hl)
	jr func_5463
@table_542d:
	; counter1
	.db $1e $00
	.db $3c $00
	.db $2d $00
	.db $28 $00
	.db $23 $00
@state4:
	ld a,$09
	ld hl,table_5482
	ld bc,table_5494
	call func_5471
	xor a
	ld (wDisableWarpTiles),a
	ld ($cca4),a
	ld ($cc02),a
	ld a,$4d
	call playSound
	ld a,($cc62)
	ld (wActiveMusic),a
	call playSound
	jp interactionDelete

func_545d:
	ld a,$0f
	ld (wScreenShakeCounterX),a
	ret

func_5463:
	ld a,$04
	ld (wScreenShakeCounterY),a
	ret

func_5469:
	ld a,$09
	ld hl,table_5482
	ld bc,table_548b
func_5471:
	ld d,>wRoomCollisions
	ld e,a
-
	push de
	ldi a,(hl)
	ld e,a
	ld a,(bc)
	inc bc
	ld (de),a
	pop de
	dec e
	jr nz,-
	ldh a,(<hActiveObject)
	ld d,a
	ret
table_5482:
	.db $23 $24 $25
	.db $33 $34 $35
	.db $43 $44 $45
table_548b:
	; initial collisions
	.db $00 $00 $00
	.db $00 $00 $00
	.db $04 $0c $08
table_5494:
	; collisions after rising
	.db $01 $03 $02
	.db $0f $0f $0f
	.db $0f $0c $0f
func_549d:
	ld hl,table_54a9
	rst_addAToHl
	ld a,(hl)
	call uniqueGfxFunc_380b
	ldh a,(<hActiveObject)
	ld d,a
	ret
table_54a9:
	.db $20 $21 $22 $23 $04
func_54ae:
	ld a,(wFrameCounter)
	and $01
	ret nz
	call getRandomNumber_noPreserveVars
	ld e,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_D1_RISING_STONES
	inc l
	ld a,(wFrameCounter)
	and $06
	rrca
	ld bc,table_54e4
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld l,$4b
	ld a,e
	and $07
	sub $04
	add $48
	ldi (hl),a
	inc l
	ld a,e
	and $f8
	swap a
	rlca
	sub $10
	add $48
	ld (hl),a
	ret
table_54e4:
	.db $00 $01 $00 $00


; ==============================================================================
; INTERACID_MAKU_CUTSCENES
; ==============================================================================
interactionCode22:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @runScript
	.dw @state2
	
@state0:
	ld e,Interaction.subid
	ld a,(de)
	cp $08
	jr z,@outsideTempleOfWinter
	cp $09
	jr z,@haveWinterSeason
	jr nc,@atMakuTreeGate
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call @func_55f5
	jp z,interactionDelete
	call returnIfScrollMode01Unset
	call @setScript
	call interactionRunScript
	call interactionRunScript
	ld e,Interaction.subid
	ld a,(de)
	cp $07
	jr z,@outsideDungeon8
	call setMakuTreeStageAndMapText
	jr @runScript

@outsideDungeon8:
	ld hl,wMakuMapTextPresent
	; You already have the 8th essence
	ld (hl),<TX_1716
	jr @runScript

@outsideTempleOfWinter:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	ld a,TREASURE_ROD_OF_SEASONS
	call checkTreasureObtained
	jp nc,interactionDelete
	ld a,(wObtainedSeasons)
	add a
	jp z,interactionDelete

@haveWinterSeason:
	call @setScript
	call interactionRunScript
	call interactionRunScript
	call setMakuTreeStageAndMapText
	jr @runScript

@atMakuTreeGate:
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete
	call @setScript
	jr @runScript

@setScript:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@runScript:
	call interactionRunScript
	jp c,interactionDelete
	ret
	
@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld hl,@tileChangeTable
	ld b,$04
-
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	push hl
	push bc
	call setInterleavedTile
	pop bc
	pop hl
	dec b
	jr nz,-
	ldh a,(<hActiveObject)
	ld d,a
	ld e,Interaction.substate
	ld a,$01
	ld (de),a
	ld e,Interaction.counter1
	ld a,$1e
	ld (de),a
	xor a
	call @func_561f
	ld a,$73
	call playSound

@rumble:
	ld a,$06
	call setScreenShakeCounter
	ld a,$70
	jp playSound

@substate1:
	call interactionDecCounter1
	ret nz
	ld hl,@tileChangeTable
	ld b,$04
-
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	push hl
	push bc
	call setTile
	pop bc
	pop hl
	inc hl
	inc hl
	inc hl
	dec b
	jr nz,-
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	xor a
	inc e
	ld (de),a
	ld a,$04
	call @func_561f
	ld a,$73
	call playSound
	jr @rumble

@tileChangeTable:
	; 1st instance is for interleave:
	;   position of tile - tile 1, tile 2, type of interleave
	; 2nd instance is for settile:
	;   position of tile - tile to set to
	.db $14 $bf $a0 $03
	.db $15 $bf $a0 $01
	.db $24 $a9 $a1 $03
	.db $25 $aa $a1 $01

@func_55f5:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,@noEssence
	ld e,Interaction.var3e
	ld (de),a
	call @func_5610
	ld c,a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,bitTable
	add l
	ld l,a
	ld a,c
	and (hl)
	ret
@noEssence:
	xor a
	ret
	
@func_5610:
	push af
	ld hl,wc6e5
	ld (hl),$00
-
	add a
	jr nc,+
	inc (hl)
+
	or a
	jr nz,-
	pop af
	ret


@func_561f:
	ld bc,@table_563f
	call addDoubleIndexToBc
	ld a,$04
-
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	inc bc
	ldh a,(<hFF8B)
	dec a
	jr nz,-
	ret

@table_563f:
	.db $18 $48
	.db $18 $58
	.db $28 $48
	.db $28 $58
	.db $18 $40
	.db $18 $60
	.db $28 $40
	.db $28 $60

@scriptTable:
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutsceneDontSetRoomFlag
	.dw mainScripts.makuTreeScript_gateHit


; ==============================================================================
; INTERACID_SEASON_SPIRITS_SCRIPTS
; ==============================================================================
interactionCode23:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	ld a,$01
	ld (de),a
	ld a,>TX_0800
	call interactionSetHighTextIndex
	ld e,$42
	ld a,(de)
	ld b,a
	swap a
	and $0f
	ld e,$43
	ld (de),a
	ld hl,table_56a5
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,b
	and $0f
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$7e
	ld a,(wc6e5)
	cp $09
	ld a,$00
	jr c,+
	inc a
+
	ld (de),a
@substate1:
	call interactionRunScript
	jp c,interactionDelete
	ret

table_56a5:
	.dw table_56af
	.dw table_56af
	.dw table_56af
	.dw table_56af
	.dw table_56b3

table_56af:
	.dw mainScripts.seasonsSpiritsScript_winterTempleOrbBridge
	.dw mainScripts.seasonsSpiritsScript_spiritStatue

table_56b3:
	.dw mainScripts.seasonsSpiritsScript_enteringTempleArea


; ==============================================================================
; INTERACID_MAYORS_HOUSE_NPC
; ==============================================================================
interactionCode24:
; ==============================================================================
; INTERACID_MRS_RUUL
; ==============================================================================
interactionCode29:
; ==============================================================================
; INTERACID_MR_WRITE
; ==============================================================================
interactionCode2c:
; ==============================================================================
; INTERACID_FICKLE_LADY
; ==============================================================================
interactionCode2d:
; ==============================================================================
; INTERACID_MALON
; ==============================================================================
interactionCode2f:
; ==============================================================================
; INTERACID_BATHING_SUBROSIANS
; ==============================================================================
interactionCode33:
; ==============================================================================
; INTERACID_MASTER_DIVERS_SON
; ==============================================================================
interactionCode36:
; ==============================================================================
; INTERACID_FICKLE_MAN
; ==============================================================================
interactionCode37:
; ==============================================================================
; INTERACID_DUNGEON_WISE_OLD_MAN
; ==============================================================================
interactionCode38:
; ==============================================================================
; INTERACID_TREASURE_HUNTER
; ==============================================================================
interactionCode39:
; Unused
interactionCode3a:
; ==============================================================================
; INTERACID_OLD_LADY_FARMER
; ==============================================================================
interactionCode3c:
; ==============================================================================
; INTERACID_FOUNTAIN_OLD_MAN
; ==============================================================================
interactionCode3d:
; ==============================================================================
; INTERACID_TICK_TOCK
; ==============================================================================
interactionCode3f:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw miscNPC_state0
	.dw miscNPC_state1
miscNPC_state0:
	ld a,$01
	ld (de),a
	ld h,d
	ld l,$42
	ldi a,(hl)
	bit 7,a
	jr z,+
	; bit 7 in subid checked for in state1
	ldd (hl),a
	and $7f
	ld (hl),a
+
	call checkHoronVillageNPCShouldBeSeen
	jr nz,+
	jp nc,interactionDelete
	jr ++
+
	call getSunkenCityNPCVisibleSubId
	jr nz,+++
	ld e,$42
	ld a,(de)
	cp b
	jp nz,interactionDelete
++
	ld e,$42
	ld a,b
	ld (de),a
+++
	call interactionInitGraphics
	ld e,$41
	ld a,(de)
	cp INTERACID_MAYORS_HOUSE_NPC
	jr nz,+
	call checkMayorsHouseNPCshouldBeSeen
	jp z,interactionDelete
+
	sub $24
	ld hl,miscNPC_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$41
	ld a,(de)
	cp INTERACID_DUNGEON_WISE_OLD_MAN
	jp z,dungeonWiseOldMan_textLookup
	cp INTERACID_MR_WRITE
	jp z,mrWrite_spawnLightableTorch
	cp INTERACID_BATHING_SUBROSIANS
	call z,func_572c
	ld e,$41
	ld a,(de)
	cp INTERACID_MASTER_DIVERS_SON
	call z,func_572c
func_5723:
	xor a
	ld h,d
	ld l,$78
	ldi (hl),a
	ld (hl),a
	jp interactionAnimateAsNpc

func_572c:
	call interactionRunScript
	jp interactionRunScript

mrWrite_spawnLightableTorch:
	call getThisRoomFlags
	and $40
	jr z,+
	jp func_5723
+
	call getFreePartSlot
	jr nz,+
	ld (hl),PARTID_LIGHTABLE_TORCH
	ld l,$cb
	ld (hl),$38
	ld l,$cd
	ld (hl),$68
+
	jp func_5723

dungeonWiseOldMan_textLookup:
	ld e,$42
	ld a,(de)
	or a
	jr nz,@ret
	ld a,(wDungeonIndex)
	dec a
	bit 7,a
	jr z,+
	xor a
+
	ld hl,@textLookup
	rst_addAToHl
	ld e,$72
	ld a,(hl)
	ld (de),a
	inc e
	ld a,>TX_3300
	ld (de),a
@ret:
	jp func_5723
@textLookup:
	.db <TX_3300, $00, $00,      <TX_3301
	.db $00,      $00, $00,      $00
	.db $00,      $00, <TX_3302

;;
; @param[out]	zflag	set if NPC should not be seen
checkMayorsHouseNPCshouldBeSeen:
	; mayor disappears if unlinked game beat
	; or seen villagers, but not zelda kidnapped
	ld e,$42
	ld a,(de)
	ld b,a
	call checkIsLinkedGame
	jr z,@unlinked
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	call checkGlobalFlag
	jr z,@xor01IfMayorElsexorA
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jr z,@xorARet
	jr @xor01IfMayorElsexorA
@unlinked:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr z,@xor01IfMayorElsexorA
	ld a,b
	cp $03
	jr nz,@xorARet
	; unlinked game beat - woman in mayor's house
	jr @xor01
@xor01IfMayorElsexorA:
	ld a,b
	cp $03
	jr z,@xorARet
@xor01:
	ld e,$41
	ld a,(de)
	xor $01
	ret
@xorARet:
	xor a
	ret

miscNPC_state1:
	call interactionRunScript
	ld e,$43
	ld a,(de)
	and $80
	jp nz,interactionAnimateAsNpc
	jp npcFaceLinkAndAnimate

checkHoronVillageNPCShouldBeSeen:
	ld e,$41
	ld a,(de)
	ld b,$00
	cp INTERACID_FICKLE_LADY
	jr z,checkHoronVillageNPCShouldBeSeen_body@main
	inc b
	cp INTERACID_FICKLE_MAN
	jr nz,checkHoronVillageNPCShouldBeSeen_body
	ld e,$42
	ld a,(de)
	cp $06
	jr nz,checkHoronVillageNPCShouldBeSeen_body@main
	ld b,$0b
	jr checkHoronVillageNPCShouldBeSeen_body@scf

;;
; @param[out]	cflag	set if NPC is conditional and should be seen at current stage of the game
; @param[out]	zflag	unset if NPC is non-conditional
checkHoronVillageNPCShouldBeSeen_body:
	; non interactioncode2d/37 - b = $01
	inc b
	cp $3c
	jr z,@main
	inc b
	cp $3d
	ret nz

; This label is used directly in a number of places.
@main:
	; interactioncode2d - b = $00
	; interactioncode37 (except in advance shop) - b = $01
	; interactioncode3c - b = $02
	; interactioncode3d - b = $03
	; from interactioncode3e - b = $04/$05/$06
	; from interactioncode80 - b = $07
	ld a,b
	ld hl,conditionalHoronNPCLookupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	push hl
	call checkNPCStage
	pop hl
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
-
	ldi a,(hl)
	or a
	ret z
	dec a
	cp b
	jr nz,-
@scf:
	; interactioncode37 in advance shop - b = $0b
	scf
	ret

;;
; @param[out]	b	$0a if game finished
;			$09 if at least 2nd essence gotten, less than 5 essences gotten, and not saved Zelda from Vire
;			$08 if zelda kidnapped
;			$07 if got maku seed
;			$06 if zelda villagers seen
;			$05 if 8th essence gotten
;			$04 if 5 essences gotten
;			$03 if at least 2nd essence gotten, and saved Zelda from Vire if linked
;			$02 if at least 1st essence gotten
;			$01 if no essences, but met maku tree
;			$00 if no essences, and not met maku tree
checkNPCStage:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld b,$0a
	jr nz,+
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,@essenceGotten
	ld a,GLOBALFLAG_GNARLED_KEY_GIVEN
	call checkGlobalFlag
	ld b,$01
	jr nz,+
	ld b,$00
+
	xor a
	ret
@essenceGotten:
	ld c,a
	call getNumSetBits
	ldh (<hFF8B),a
	ld a,c
	call getHighestSetBit
	ld c,a
	call checkIsLinkedGame
	jr nz,@linkedGameCheck
@regularCheck:
	ld a,c
	ld b,$05
	cp $07
	ret nc
	dec b
	ldh a,(<hFF8B)
	cp $05
	ret nc
	ld a,c
	dec b
	cp $01
	ret nc
	dec b
	ret
@linkedGameCheck:
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	ld b,$08
	ret nz
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	call checkGlobalFlag
	ld b,$07
	ret nz
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	call checkGlobalFlag
	ld b,$06
	ret nz

	ld a,c
	cp $00
	jr z,@regularCheck
	ldh a,(<hFF8B)
	cp $05
	jr nc,@regularCheck
	ld b,$09
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	ret z
	ld b,$03
	ret

;;
; @param[out]	zflag	nz if not interactioncode36/39
; @param[out]	b	$04 if game finished
;			$03 if zelda kidnapped seen
;			$02 if 8th essence gotten
;			$01 if 4th essence gotten
;			$00 if none of the above
;			$ff if not interaction $36 or $39
getSunkenCityNPCVisibleSubId:
	ld e,$41
	ld a,(de)
	cp INTERACID_MASTER_DIVERS_SON
	jr z,@main
	cp INTERACID_TREASURE_HUNTER
	jr z,@main
	ld a,$ff
	ret

; This label is used directly in a number of places.
@main:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld b,$04
	jr nz,@xorARet
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	ld b,$03
	jr nz,@xorARet
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	ld b,$00
	jr nc,@xorARet
	ld c,a
	call checkIsLinkedGame
	jr z,+
+
	ld a,c
	call getHighestSetBit
	ld b,$02
	cp $07
	ret nc
	dec b
	ld a,c
	and $08
	jr nz,@xorARet
	dec b
@xorARet:
	xor a
	ret

conditionalHoronNPCLookupTable:
	.dw @fickleLady
	.dw @fickleMan
	.dw @oldLadyFarmer
	.dw @fountainOldMan
	.dw @boyWithDog
	.dw @horonVillageBoy
	.dw @boyPlaysWithSpringBloomFlower
	.dw @otherOldMan

@fickleLady:
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
@@subid0:
	.db $01 $00
@@subid1:
	.db $02 $03 $04 $0a $00
@@subid2:
	.db $05 $00
@@subid3:
	.db $06 $00
@@subid4:
	.db $07 $08 $00
@@subid5:
	.db $09 $00
@@subid6:
	.db $0b $00

@fickleMan:
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
@@subid0:
	.db $01 $02 $0b $00
@@subid1:
	.db $03 $00
@@subid2:
	.db $04 $00
@@subid3:
	.db $0a $00
@@subid4:
	.db $05 $00
@@subid5:
	.db $06 $07 $08 $09 $00

@oldLadyFarmer:
@fountainOldMan:
@boyPlaysWithSpringBloomFlower:
	.dw @@subid0

@@subid0:
	.db $01 $02 $03 $04 $0a $05 $06 $07
	.db $08 $09 $0b $00

@horonVillageBoy:
	.dw @@table_590a
	.dw @@table_590d
	.dw @@table_5914
	.dw @@table_5917

@@table_590a:
	.db $01 $02 $00

@@table_590d:
	.db $03 $04 $0a $05 $06 $0b $00

@@table_5914:
	.db $07 $08 $00

@@table_5917:
	.db $09 $00

@boyWithDog:
	.dw @@table_5923
	.dw @@table_5927
	.dw @@table_5929
	.dw @@table_592b
	.dw @@table_592f

@@table_5923:
	.db $01 $02 $03 $00

@@table_5927:
	.db $04 $00

@@table_5929:
	.db $0a $00

@@table_592b:
	.db $05 $06 $0b $00

@@table_592f:
	.db $07 $08 $09 $00

@otherOldMan:
	.dw @@table_593b
	.dw @@table_5941
	.dw @@table_5943
	.dw @@table_5948

@@table_593b:
	.db $01 $02 $03 $04 $0a $00

@@table_5941:
	.db $05 $00

@@table_5943:
	.db $06 $07 $08 $09 $00

@@table_5948:
	.db $0b $00

miscNPC_scriptTable:
	.dw @mayorsHouseScripts
	.dw @stub
	.dw @stub
	.dw @stub
	.dw @stub
	.dw @mrsRuulScripts
	.dw @stub
	.dw @stub
	.dw @mrWriteScripts
	.dw @fickleLadyScripts
	.dw @stub
	.dw @malonScripts
	.dw @stub
	.dw @stub
	.dw @stub
	.dw @bathingSubrosiansScripts
	.dw @stub
	.dw @stub
	.dw @masterDiversSonScripts
	.dw @fickleManScripts
	.dw @dungeonWiseOldManScripts
	.dw @sunkenCityTreasureHunterScripts
	.dw @stub
	.dw @stub
	.dw @villageFarmerScripts
	.dw @villageFountainManScripts
	.dw @stub
	.dw @tickTockScripts
	
@mayorsHouseScripts:
@stub:
	.dw mainScripts.mayorsScript
	.dw mainScripts.mayorsScript
	.dw mainScripts.mayorsScript
	.dw mainScripts.mayorsHouseLadyScript

@mrsRuulScripts:
	.dw mainScripts.mrsRuulScript

@mrWriteScripts:
	.dw mainScripts.mrWriteScript

@fickleLadyScripts:
	.dw mainScripts.fickleLadyScript_text1
	.dw mainScripts.fickleLadyScript_text2
	.dw mainScripts.fickleLadyScript_text2
	.dw mainScripts.fickleLadyScript_text2
	.dw mainScripts.fickleLadyScript_text3
	.dw mainScripts.fickleLadyScript_text4
	.dw mainScripts.fickleLadyScript_text5
	.dw mainScripts.fickleLadyScript_text5
	.dw mainScripts.fickleLadyScript_text6
	.dw mainScripts.fickleLadyScript_text2
	.dw mainScripts.fickleLadyScript_text7

@malonScripts:
	.dw mainScripts.malonScript

@bathingSubrosiansScripts:
	.dw mainScripts.bathingSubrosianScript_text1
	.dw mainScripts.bathingSubrosianScript_stub
	.dw mainScripts.bathingSubrosianScript_2
	.dw mainScripts.bathingSubrosianScript_text3
	.dw mainScripts.bathingSubrosianScript_stub
	.dw mainScripts.bathingSubrosianScript_stub

@masterDiversSonScripts:
	.dw mainScripts.masterDiversSonScript
	.dw mainScripts.masterDiversSonScript_4thEssenceGotten
	.dw mainScripts.masterDiversSonScript_8thEssenceGotten
	.dw mainScripts.masterDiversSonScript_ZeldaKidnapped
	.dw mainScripts.masterDiversSonScript_gameFinished

@fickleManScripts:
	.dw mainScripts.ficklManScript_text1
	.dw mainScripts.ficklManScript_text1
	.dw mainScripts.ficklManScript_text2
	.dw mainScripts.ficklManScript_text4
	.dw mainScripts.ficklManScript_text5
	.dw mainScripts.ficklManScript_text6
	.dw mainScripts.ficklManScript_text7
	.dw mainScripts.ficklManScript_text7
	.dw mainScripts.ficklManScript_text8
	.dw mainScripts.ficklManScript_text3
	.dw mainScripts.ficklManScript_text9
	.dw mainScripts.ficklManScript_textA

@dungeonWiseOldManScripts:
	.dw mainScripts.dungeonWiseOldManScript

@sunkenCityTreasureHunterScripts:
	.dw mainScripts.treasureHunterScript_text1
	.dw mainScripts.treasureHunterScript_text2
	.dw mainScripts.treasureHunterScript_text3
	.dw mainScripts.treasureHunterScript_text4
	.dw mainScripts.treasureHunterScript_text3

@villageFarmerScripts:
	.dw mainScripts.oldLadyFarmerScript_text1
	.dw mainScripts.oldLadyFarmerScript_text1
	.dw mainScripts.oldLadyFarmerScript_text2
	.dw mainScripts.oldLadyFarmerScript_text2
	.dw mainScripts.oldLadyFarmerScript_text3
	.dw mainScripts.oldLadyFarmerScript_text4
	.dw mainScripts.oldLadyFarmerScript_text5
	.dw mainScripts.oldLadyFarmerScript_text5
	.dw mainScripts.oldLadyFarmerScript_text6
	.dw mainScripts.oldLadyFarmerScript_text2
	.dw mainScripts.oldLadyFarmerScript_text7

@villageFountainManScripts:
	.dw mainScripts.fountainOldManScript_text1
	.dw mainScripts.fountainOldManScript_text2
	.dw mainScripts.fountainOldManScript_text3
	.dw mainScripts.fountainOldManScript_text4
	.dw mainScripts.fountainOldManScript_text6
	.dw mainScripts.fountainOldManScript_text7
	.dw mainScripts.fountainOldManScript_text8
	.dw mainScripts.fountainOldManScript_text8
	.dw mainScripts.fountainOldManScript_text9
	.dw mainScripts.fountainOldManScript_text5
	.dw mainScripts.fountainOldManScript_textA

@tickTockScripts:
	.dw mainScripts.tickTockScript


; ==============================================================================
; INTERACID_MITTENS
; ==============================================================================
interactionCode25:
; ==============================================================================
; INTERACID_MITTENS_OWNER
; ==============================================================================
interactionCode26:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call interactionInitGraphics
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld e,$41
	ld a,(de)
	cp INTERACID_MITTENS_OWNER
	jr z,@mittensOwner
	call getThisRoomFlags
	and $40
	ld e,$42
	ld a,(de)
	jr nz,@@savedMittens
	or a
	jp nz,interactionDelete
	jr @incStateSetScript
@@savedMittens:
	or a
	jp z,interactionDelete
	jr @incStateSetScript
@mittensOwner:
	call getThisRoomFlags
	and $40
	ld e,$42
	ld a,(de)
	jr nz,@@savedMittens
	or a
	jp nz,interactionDelete
	call @func_5a78
	ld a,$00
	call interactionSetAnimation
	jp @animate
@@savedMittens:
	or a
	jp z,interactionDelete
	call @func_5a78
	ld a,$02
	call interactionSetAnimation
	jp @animate
@incStateSetScript:
	ld h,d
	ld l,$44
	ld (hl),$01
	ld hl,mainScripts.mittensScript
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
	jp @animate
@func_5a78:
	ld h,d
	ld l,$44
	ld (hl),$02
	ld hl,mainScripts.mittensOwnerScript
	jp interactionSetScript
@state1:
	call interactionRunScript
	ld a,($cceb)
	or a
	jp z,npcFaceLinkAndAnimate
	call func_5a99
	jp @animate
@state2:
	call interactionRunScript
@animate:
	jp interactionAnimateAsNpc
	
func_5a99:
	ld e,$78
	ld a,(de)
	rst_jumpTable
	.dw @var38_00
	.dw @var38_01
	.dw @var38_02
	.dw @var38_03
@var38_00:
	ld h,d
	ld l,$78
	ld (hl),$01
	ld l,$49
	ld (hl),$08
	ld l,$50
	ld (hl),$28
	ld l,$54
	ld (hl),$00
	inc hl
	ld (hl),$fe
	ld l,$79
	ld (hl),$04
	ld a,$07
	jp interactionSetAnimation
@var38_01:
	ld h,d
	ld l,$79
	dec (hl)
	ret nz
	ld l,$78
	inc (hl)
	ld a,$08
	call interactionSetAnimation
	ld a,$53
	jp playSound
@var38_02:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	ld h,d
	ld l,$78
	inc (hl)
	ld l,$79
	ld (hl),$04
	ld a,$07
	call interactionSetAnimation
	ld a,$57
	jp playSound
@var38_03:
	ld h,d
	ld l,$79
	dec (hl)
	ret nz
	xor a
	ld ($cceb),a
	ld a,$02
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_SOKRA
; ==============================================================================
interactionCode27:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,>TX_5200
	call interactionSetHighTextIndex
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
@@runScriptSetVisible:
	call interactionRunScript
	call interactionRunScript
	jp objectSetVisiblec2
@@subid0:
	ld a,(wObtainedSeasons)
	and $02
	jr nz,+
	ld a,<ROOM_SEASONS_071
	call getARoomFlags
	bit 6,a
	jp nz,interactionDelete
+
	ld hl,mainScripts.sokraScript_inVillage
	call interactionSetScript
	jr @@runScriptSetVisible
@@subid1:
	ld a,(wObtainedSeasons)
	and $08
	jr z,+
	call getThisRoomFlags
	bit 6,a
	jr nz,+
	ld hl,mainScripts.sokraScript_easternSuburbsPortal
	call interactionSetScript
	jr @@runScriptSetVisible
+
	ld hl,objectData.objectData7e4a
	call parseGivenObjectData
	jp interactionDelete
@@subid2:
	call getThisRoomFlags
	ld a,(wObtainedSeasons)
	and $02
	jr z,+
	res 6,(hl)
	jp interactionDelete
+
	set 6,(hl)
	ld hl,mainScripts.sokraScript_needSummerForD3
	call interactionSetScript
	jr @@runScriptSetVisible
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
@@subid0:
	call interactionRunScript
	call interactionAnimateAsNpc
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	ret nc
	call getThisRoomFlags
	bit 6,(hl)
	jr z,+
	ld e,$43
	ld a,(de)
	or a
	jr nz,++
	ret
+
	ld a,($d00d)
	cp $78
	ret c
	ld a,($d00b)
	cp $3c
	ret c
	cp $60
	ret nc
@@func_5bae:
	ld e,$77
	ld a,$01
	ld (de),a
	ret
++
	ld a,(wFrameCounter)
	and $3f
	ret nz
	ld b,$f4
	ld c,$fa
	jp objectCreateFloatingMusicNote
@@subid1:
	call interactionAnimateAsNpc
	call interactionRunScript
	jp c,interactionDelete
	call checkInteractionSubstate
	ret nz
	ld a,($d00d)
	cp $18
	ret c
	call interactionIncSubstate
	call @@func_5bae
	jp beginJump
@@subid2:
	ld a,(wDisabledObjects)
	and $01
	call z,createSokraSnore
	call interactionAnimateAsNpc
	jp interactionRunScript


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
; INTERACID_S_BIRD
; ==============================================================================
interactionCode2a:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	cp $0a
	jr z,@birdWithImpa
	cp $0b
	jr nz,@knowItAllBird
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp nz,interactionDelete
	ld hl,mainScripts.panickingBirdScript
	jr @setScript
@knowItAllBird:
	ld hl,mainScripts.knowItAllBirdScript
@setScript:
	call interactionSetScript

	call getRandomNumber_noPreserveVars
	and $01
	ld e,$48
	ld (de),a
	call interactionSetAnimation
	call interactionSetAlwaysUpdateBit
	
	ld l,$76
	ld (hl),$1e
	
	call beginJump
	ld l,$42
	ld a,(hl)
	ld l,$72
	ld (hl),a
	
	ld l,$73
	ld (hl),$32
	jp objectSetVisible82
@birdWithImpa:
	call interactionSetAlwaysUpdateBit
	ld l,$46
	ld (hl),$b4
	ld l,$50
	ld (hl),$19
	call beginJump
	call objectSetVisible82
	jp objectSetInvisible
@state1:
	ld e,$42
	ld a,(de)
	cp $0a
	jr z,@panickingBirdState1
	call interactionRunScript
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	ld e,$77
	ld a,(de)
	or a
	jr z,@label_10_337
	
	call interactionIncSubstate
	ld l,$48
	ld a,(hl)
	add $02
	jp interactionSetAnimation

@label_10_337:
	call @decVar36
	jr nz,@animate
	ld l,$76
	ld (hl),$1e
	call getRandomNumber
	and $07
	jr nz,@animate
	ld l,$48
	ld a,(hl)
	xor $01
	ld (hl),a
	jp interactionSetAnimation

@animate:
	jp interactionAnimateAsNpc

@substate1:
	call interactionAnimate
	ld e,$77
	ld a,(de)
	or a
	jp nz,updateSpeedZ

	ld l,$76
	ld (hl),$3c

	ld l,$45
	ld (hl),a
	ld l,$4e
	ldi (hl),a
	ld (hl),a

	ld l,$48
	ld a,(hl)
	jp interactionSetAnimation

@panickingBirdState1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @panickingBirdSubstate0
	.dw @panickingBirdSubstate1
	.dw @panickingBirdSubstate2
	.dw @panickingBirdSubstate3
	.dw @panickingBirdSubstate4
@panickingBirdSubstate0:
	ld a,(wUseSimulatedInput)
	or a
	ret nz
	call interactionDecCounter1
	ret nz
	ld l,$45
	inc (hl)
	call func_5e04
	jp objectSetVisible
@panickingBirdSubstate1:
	call interactionAnimateAsNpc
	call updateSpeedZ
	ld a,(wFrameCounter)
	and $07
	call z,func_5e04
	ld c,$10
	call func_5e22
	jp nc,objectApplySpeed
	ld h,d
	ld l,$45
	inc (hl)
	ld l,$46
	ld (hl),$14
	ld l,$4f
	ld (hl),$00
	jp beginJump
@panickingBirdSubstate2:
	call interactionAnimateAsNpc
	call interactionDecCounter1
	ret nz
	ld l,$45
	inc (hl)
	ld l,$78
	ld a,(hl)
	add $02
	jp interactionSetAnimation
@panickingBirdSubstate3:
	call interactionAnimateAsNpc
	call @func_5de5
	ld e,$4f
	ld a,(de)
	or a
	ret nz
	ld c,$18
	call func_5e22
	ret c
	ld h,d
	ld l,$45
	inc (hl)
	call beginJump
	jp func_5e04
@panickingBirdSubstate4:
	call interactionAnimateAsNpc
	call updateSpeedZ
	ld a,(wFrameCounter)
	and $07
	call z,func_5e04
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
@func_5de5:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld bc,$fec0
	jp objectSetSpeedZ
	
@decVar36:
	ld h,d
	ld l,$76
	dec (hl)
	ret

updateSpeedZ:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

beginJump:
	ld bc,$ff40
	jp objectSetSpeedZ

func_5e04:
	call objectGetRelatedObject1Var
	ld l,$4b
	ld b,(hl)
	inc l
	inc l
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	and $10
	swap a
	xor $01
	ld h,d
	ld l,$78
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation
func_5e22:
	ld e,$4b
	ld a,(de)
	ld b,a
	call objectGetRelatedObject1Var
	ld l,$4b
	ld a,(hl)
	sub b
	cp c
	ret


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
; INTERACID_FICKLE_GIRL
; ==============================================================================
interactionCode2e:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call getSunkenCityNPCVisibleSubId@main
	ld e,$42
	ld a,(de)
	cp b
	jp nz,interactionDelete
	call interactionInitGraphics
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_06d
	jr z,+
	ld a,$01
	ld e,$48
	ld (de),a
	call interactionSetAnimation
+
	ld e,$42
	ld a,(de)
	ld hl,table_5f7e
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_8e
	inc l
	ld (hl),$00
	ld l,$57
	ld (hl),d
	ld l,$49
	call @func_5f4e
+
	jr @var03_00
@state1:
	call interactionRunScript
	ld e,$43
	ld a,(de)
	rst_jumpTable
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02
	.dw @var03_03
@var03_00:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	jr nz,@pushLinkAwayUpdateDrawPriority
@func_5efa:
	call func_5f70
@pushLinkAwayUpdateDrawPriority:
	jp interactionPushLinkAwayAndUpdateDrawPriority
@var03_01:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	jr z,@pushLinkAwayUpdateDrawPriority
	call @func_5f65
	call getRandomNumber_noPreserveVars
	and $03
	jr nz,@func_5f3b
	inc a
	jr @func_5f3b
@var03_02:
@var03_03:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	cp $02
	jr nz,@pushLinkAwayUpdateDrawPriority
	call @func_5f65
	call getFreePartSlot
	jr nz,+
	ld (hl),PARTID_POPPABLE_BUBBLE
	inc l
	ld (hl),$01
	ld l,$c9
	call @func_5f4e
+
	call getRandomNumber_noPreserveVars
	and $03
	sub $02
	ret c
	inc a
@func_5f3b:
	ld b,a
-
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_POPPABLE_BUBBLE
	inc l
	ld (hl),$00
	ld l,$c9
	call @func_5f4e
	dec b
	jr nz,-
	ret
@func_5f4e:
	push bc
	ld e,$48
	ld a,(de)
	rrca
	ld c,$f8
	ld a,$1c
	jr nc,+
	ld c,$0a
	ld a,$06
+
	ld (hl),a
	ld b,$02
	call objectCopyPositionWithOffset
	pop bc
	ret
@func_5f65:
	ld e,$48
	ld a,(de)
	and $01
	call interactionSetAnimation
	call @func_5efa
func_5f70:
	ld e,$76
	ld a,$01
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $03
	ld e,$43
	ld (de),a
	ret

table_5f7e:
	.dw mainScripts.sunkenCityFickleGirlScript_text1
	.dw mainScripts.sunkenCityFickleGirlScript_text2
	.dw mainScripts.sunkenCityFickleGirlScript_text2
	.dw mainScripts.sunkenCityFickleGirlScript_text3
	.dw mainScripts.sunkenCityFickleGirlScript_text2


; ==============================================================================
; INTERACID_S_SUBROSIAN
; ==============================================================================
interactionCode30:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$6b
	ld (hl),$00
	ld l,$49
	ld (hl),$ff
	ld l,$42
	ld a,(hl)
	cp $25
	jr nz,+
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_UNBLOCKED_AUTUMN_TEMPLE
	call checkGlobalFlag
	jp z,interactionDelete
	ld e,$7e
	ld a,GLOBALFLAG_BEGAN_PLEN_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld (de),a
+
	ld e,$42
	ld a,(de)
	ld hl,table_607f
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionRunScript
	call interactionRunScript
	jp c,interactionDelete
	jp objectSetVisible82
@state1:
	ld a,(wActiveGroup)
	dec a
	jr nz,+
	call objectGetTileAtPosition
	ld (hl),$00
+
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate
@state2:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	call c,@func_600e
@animateAndRunScript:
	call interactionAnimate
	call interactionAnimate
	call interactionRunScript
	ld c,$60
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,$fe00
	jp objectSetSpeedZ
@func_600e:
	ld hl,$cfc0
	set 1,(hl)
	ret
@state3:
	call objectGetAngleTowardLink
	ld e,$49
	ld (de),a
	call objectApplySpeed
	jr @animateAndRunScript
@state4:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	ret
@state5:
	call interactionRunScript
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	ld a,($cfc0)
	call getHighestSetBit
	ret nc
	cp $03
	jr nz,+
	ld e,$44
	ld a,$04
	ld (de),a
	ret
+
	ld b,a
	inc a
	ld e,$45
	ld (de),a
	ld a,b
	add $04
	jp interactionSetAnimation
@substate1:
	call interactionAnimate
	ld a,($cfc0)
	or a
	ret z
	ld e,$45
	xor a
	ld (de),a
	jr @substate0
@substate2:
@substate3:
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jr z,+
	ld (hl),$00
	ld l,$4d
	add (hl)
	ld (hl),a
+
	ld a,($cfc0)
	or a
	ret z
	ld l,$45
	ld (hl),$00
	jr @substate0

table_607f:
	/* $00 */ .dw mainScripts.subrosianScript_smelterByAutumnTemple
	/* $01 */ .dw mainScripts.subrosianScript_smelterText1 ; unused?
	/* $02 */ .dw mainScripts.subrosianScript_smelterText1
	/* $03 */ .dw mainScripts.subrosianScript_smelterText2
	/* $04 */ .dw mainScripts.subrosianScript_smelterText3
	/* $05 */ .dw mainScripts.subrosianScript_smelterText4
	/* $06 */ .dw mainScripts.subrosianScript_beachText1
	/* $07 */ .dw mainScripts.subrosianScript_beachText2
	/* $08 */ .dw mainScripts.subrosianScript_beachText3
	/* $09 */ .dw mainScripts.subrosianScript_beachText4
	/* $0a */ .dw mainScripts.subrosianScript_villageText1
	/* $0b */ .dw mainScripts.subrosianScript_villageText2
	/* $0c */ .dw mainScripts.subrosianScript_shopkeeper
	/* $0d */ .dw mainScripts.subrosianScript_wildsText1
	/* $0e */ .dw mainScripts.subrosianScript_wildsText2
	/* $0f */ .dw mainScripts.subrosianScript_wildsText3
	/* $10 */ .dw mainScripts.subrosianScript_strangeBrother1_stealingFeather
	/* $11 */ .dw mainScripts.subrosianScript_strangeBrother2_stealingFeather
	/* $12 */ .dw mainScripts.subrosianScript_strangeBrother1_inHouse
	/* $13 */ .dw mainScripts.subrosianScript_strangeBrother2_inHouse
	/* $14 */ .dw mainScripts.subrosianScript_5716
	/* $15 */ .dw mainScripts.subrosianScript_westVolcanoesText1
	/* $16 */ .dw mainScripts.subrosianScript_westVolcanoesText2
	/* $17 */ .dw mainScripts.subrosianScript_eastVolcanoesText1
	/* $18 */ .dw mainScripts.subrosianScript_eastVolcanoesText2
	/* $19 */ .dw mainScripts.subrosianScript_southOfExitToSuburbsPortal
	/* $1a */ .dw mainScripts.subrosianScript_nearExitToTempleRemainsNorthsPortal
	/* $1b */ .dw mainScripts.subrosianScript_wildsNearLockedDoor
	/* $1c */ .dw mainScripts.subrosianScript_boomerangSubrosianFriend
	/* $1d */ .dw mainScripts.subrosianScript_screenRightOfBoomerangSubrosian
	/* $1e */ .dw mainScripts.subrosianScript_wildsInAreaWithOre
	/* $1f */ .dw mainScripts.subrosianScript_wildsOtherSideOfTreesToOre
	/* $20 */ .dw mainScripts.subrosianScript_wildsNorthOfStrangeBrothersHouse
	/* $21 */ .dw mainScripts.subrosianScript_wildsOutsideStrangeBrothersHouse
	/* $22 */ .dw mainScripts.subrosianScript_villageSouthOfShop
	/* $23 */ .dw mainScripts.subrosianScript_hasLavaPoolInHouse
	/* $24 */ .dw mainScripts.subrosianScript_beachText5
	/* $25 */ .dw mainScripts.subrosianScript_goldenByBombFlower
	/* $26 */ .dw mainScripts.subrosianScript_signsGuy


; ==============================================================================
; INTERACID_DATING_ROSA_EVENT
; ==============================================================================
interactionCode31:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
@subid0:
@subid3:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,GLOBALFLAG_DATING_ROSA
	call checkGlobalFlag
	jp nz,interactionDelete
	ld h,d
	ld l,$6b
	ld (hl),$00
	ld l,$49
	ld (hl),$ff
	ld a,GLOBALFLAG_DATED_ROSA
	call checkGlobalFlag
	jr nz,+
	ld e,$77
	ld a,$04
	ld (de),a
+
	ld hl,mainScripts.rosaScript_goOnDate
	call interactionSetScript
	ld a,>TX_2900
	call interactionSetHighTextIndex
	call objectGetTileAtPosition
	ld (hl),$00
	jr +
@@state1:
	call interactionRunScript
+
	jp npcFaceLinkAndAnimate
@subid1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call makeActiveObjectFollowLink
	call interactionSetAlwaysUpdateBit
	call objectSetReservedBit1
	ld l,$73
	ld (hl),$01
	ld l,$70
	ld e,$4b
	ld a,(de)
	ldi (hl),a
	ld e,$4d
	ld a,(de)
	ldi (hl),a
	ld e,$48
	ld a,($d008)
	ld (de),a
	ld (hl),$00
	call interactionSetAnimation
	call objectSetVisiblec3
	jp objectSetPriorityRelativeToLink_withTerrainEffects
@@state1:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	call @@func_61a4
	ret c
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call z,@@func_6182
	call @@func_628e
	ld h,d
	ld l,$4b
	ld a,(hl)
	ld b,a
	ld l,$70
	cp (hl)
	jr nz,+
	ld l,$4d
	ld a,(hl)
	ld c,a
	ld l,$71
	cp (hl)
	ret z
+
	ld l,$70
	ld (hl),b
	inc l
	ld (hl),c
	jp interactionAnimate
@@func_6182:
	ld h,d
	ld l,$46
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret nz
	ld bc,$fe40
	jp objectSetSpeedZ
+
	ld a,($cc77)
	or a
	ret z
	ld a,($cca4)
	and $81
	ret nz
	ld a,($cc02)
	or a
	ret nz
	ld (hl),$10
	ret
@@func_61a4:
	ld a,(wActiveGroup)
	cp $06
	jr nc,@@goToState3
	ld a,(wActiveRoom)
	ld hl,@@roomTable_61dd
	call findRoomSpecificData
	ret nc
	rst_jumpTable
	.dw @@screenAboveRosa
	.dw @@beachEntranceScreen
	.dw @@goToState3
@@screenAboveRosa:
	ld e,$73
	ld a,(de)
	or a
	jr nz,+
	ld a,($cd00)
	and $01
	jr z,+
	ld e,$44
	ld a,$02
	ld (de),a
	scf
	ret
+
	xor a
	ret
@@beachEntranceScreen:
	ld e,$73
	xor a
	ld (de),a
	ret
@@goToState3:
	ld e,$44
	ld a,$03
	ld (de),a
	ret
@@roomTable_61dd:
	.dw @@group0
	.dw @@group1
	.dw @@group2
	.dw @@group3
	.dw @@group4
	.dw @@group5
	.dw @@group6
	.dw @@group7
@@group0:
@@group2:
@@group6:
@@group7:
	.db $00
@@group1:
	; beach entrance
	.db <ROOM_SEASONS_167 $01
	.db <ROOM_SEASONS_177 $00
	.db $00
@@group3:
	; 1F pirate house
	.db <ROOM_SEASONS_38a $02
	; Left room of Strange brother's house
	.db <ROOM_SEASONS_3b1 $02
	.db $00
@@group4:
	.db <ROOM_SEASONS_4f0 $02
@@group5:
	.db $00

@@state2:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
@@@substate0:
	ld a,$01
	ld (de),a
	call clearFollowingLinkObject
	ld a,GLOBALFLAG_DATING_ROSA
	call unsetGlobalFlag
	ld a,$01
	ld ($cca4),a
	ld a,$02
	ld ($d008),a
	ld a,$29
	call interactionSetHighTextIndex
	ld hl,mainScripts.rosaScript_dateEnded
	jp interactionSetScript
@@@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	call interactionRunScript
	ret nc
	ld e,$45
	ld a,$02
	ld (de),a
	ld bc,$4858
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	ret
@@@substate2:
	call interactionAnimate
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $48
	ret c
	ld h,d
	ld l,$42
	ld b,$06
	call clearMemory
	ld l,$40
	ld (hl),$01
	xor a
	ld ($cca4),a
	call objectGetTileAtPosition
	ld (hl),$00
	ld a,$28
	ld (wActiveMusic),a
	jp playSound
@@state3:
	call returnIfScrollMode01Unset
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	ld a,$01
	ld (de),a
	call clearFollowingLinkObject
	ld a,GLOBALFLAG_DATING_ROSA
	call unsetGlobalFlag
	ld bc,TX_291a
	jp showText
@@@substate1:
	call retIfTextIsActive
	jp interactionDelete
@@func_628e:
	ld h,d
	ld l,$48
	ld a,(hl)
	ld l,$72
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation
@subid2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_STAR_ORE_FOUND
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,(wcc84)
	or a
	jp nz,interactionDelete
	ld a,d
	ld (wcc84),a
	ld h,d
	ld l,$40
	set 1,(hl)
	call getRandomNumber
	and $03
	ld hl,@@table_62d3
	rst_addDoubleIndex
	ld e,$70
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld a,$ff
	ld e,$72
	ld (de),a
	ret
@@table_62d3:
	; var30 - var31
	.db $65 $57
	.db $66 $56
	.db $75 $27
	.db $76 $24
@@state1:
	ld e,$72
	ld a,(de)
	ld b,a
	ld a,(wActiveRoom)
	cp b
	ret z
	ld (de),a
	ld b,a
	ld e,$70
	ld a,(de)
	cp b
	jr nz,+
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_STAR_ORE
	ld e,$71
	ld a,(de)
	ld l,$4b
	jp setShortPosition
+
	ld a,TREASURE_STAR_ORE
	call checkTreasureObtained
	jr c,+
	ld a,b
	cp $60
	ret nc
-
	xor a
	ld (wcc84),a
	jp interactionDelete
+
	ld a,GLOBALFLAG_STAR_ORE_FOUND
	call setGlobalFlag
	jr -


; ==============================================================================
; INTERACID_SUBROSIAN_WITH_BUCKETS
; ==============================================================================
interactionCode32:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$6b
	ld (hl),$00
	ld l,$49
	ld (hl),$ff
	ld l,$42
	ld a,(hl)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionRunScript
	call interactionRunScript
	jp c,interactionDelete
	jr @animateAsNpc
@state1:
	ld a,(wActiveGroup)
	dec a
	jr nz,+
	call objectGetTileAtPosition
	ld (hl),$00
+
	call interactionRunScript
	ld c,$28
	call objectCheckLinkWithinDistance
	jr c,+
	ld a,$04
+
	ld l,$49
	cp (hl)
	jr z,@animateAsNpc
	ld (hl),a
	rrca
	call interactionSetAnimation
@animateAsNpc:
	jp interactionAnimateAsNpc
@scriptTable:
	.dw mainScripts.bucketSubrosianScript_text1
	.dw mainScripts.bucketSubrosianScript_text2
	.dw mainScripts.bucketSubrosianScript_text3
	.dw mainScripts.bucketSubrosianScript_text4
	.dw mainScripts.bucketSubrosianScript_text5
	.dw mainScripts.bucketSubrosianScript_text6
	.dw mainScripts.bucketSubrosianScript_text1
	.dw mainScripts.bucketSubrosianScript_text1


; ==============================================================================
; INTERACID_SUBROSIAN_SMITHS
; ==============================================================================
interactionCode34:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionInitGraphics
+
	call interactionAnimateAsNpc
	ld e,$61
	ld a,(de)
	cp $ff
	ret nz
	ld a,$50
	jp playSound


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
; INTERACID_S_GORON
; ==============================================================================
interactionCode3b:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	xor a
	ldh (<hFF8D),a
	ld a,TREASURE_TRADEITEM
	call checkTreasureObtained
	jr nc,+
	; Got Goron vase
	cp $05
	jr c,+
	ld a,$01
	ldh (<hFF8D),a
+
	ld h,d
	ld l,$42
	ld a,(hl)
	ld b,a
	and $0f
	ldi (hl),a
	ld c,a
	ld a,b
	swap a
	and $0f
	; upper nybble of subid goes into var03
	ld (hl),a
	ld a,c
	ld c,>TX_3700
	cp $07
	jr nz,+
	; subid_07
	ld a,(wIsLinkedGame)
	ld b,a
	ldh a,(<hFF8D)
	and b
	jp z,interactionDelete
	ld c,>TX_5300
+
	ld a,c
	call interactionSetHighTextIndex
	call interactionInitGraphics
	ld hl,@biggoronColdNotHealed
	ldh a,(<hFF8D)
	or a
	jr z,+
	ld hl,@biggoronColdHealed
+
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
@state1:
	ld e,$43
	ld a,(de)
	rst_jumpTable
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02
@var03_00:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
@var03_01:
	call interactionRunScript
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	ld c,$28
	call objectCheckLinkWithinDistance
	jr nc,+
	call interactionIncSubstate
	call @func_67fc
	add $06
	call interactionSetAnimation
+
	jp interactionAnimateAsNpc
@substate1:
	ld e,$61
	ld a,(de)
	inc a
	jr nz,+
	call interactionIncSubstate
	ld l,$49
	ld (hl),$ff
+
	jp interactionAnimateAsNpc
@substate2:
	ld c,$28
	call objectCheckLinkWithinDistance
	jr c,+
	call interactionIncSubstate
	call @func_67fc
	add $07
	call interactionSetAnimation
	jr @animateAsNPC
+
	jp npcFaceLinkAndAnimate
@substate3:
	ld e,$61
	ld a,(de)
	inc a
	jr nz,@animateAsNPC
	ld e,$45
	xor a
	ld (de),a
@animateAsNPC:
	jp interactionAnimateAsNpc
@var03_02:
	call interactionAnimate
	call interactionAnimate
	call checkInteractionSubstate
	jr nz,@func_67f0
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	jr z,@runScriptPushLinkAwayUpdateDrawPriority
	xor a
	ld (de),a
	call objectGetAngleTowardLink
	add $04
	add a
	swap a
	and $03
	ld e,$48
	ld (de),a
	call interactionSetAnimation
	ld bc,TX_3700
	call showText
	call interactionIncSubstate
@runScriptPushLinkAwayUpdateDrawPriority:
	call interactionRunScript
	jp interactionPushLinkAwayAndUpdateDrawPriority

@func_67f0:
	ld e,$76
	ld a,(de)
	call interactionSetAnimation
	ld e,$45
	xor a
	ld (de),a
	jr @runScriptPushLinkAwayUpdateDrawPriority
	
@func_67fc:
	ld e,$4d
	ld a,(de)
	ld hl,$d00d
	cp (hl)
	ld a,$02
	ret c
	xor a
	ret

@biggoronColdNotHealed:
	.dw mainScripts.goronScript_pacingLeftAndRight
	.dw mainScripts.goronScript_text1_biggoronSick
	.dw mainScripts.goronScript_text2
	.dw mainScripts.goronScript_text3_biggoronSick
	.dw mainScripts.goronScript_text4_biggoronSick
	.dw mainScripts.goronScript_text5
	.dw mainScripts.goronScript_upgradeRingBox
	.dw mainScripts.goronScript_giveSubrosianSecret

@biggoronColdHealed:
	.dw mainScripts.goronScript_pacingLeftAndRight
	.dw mainScripts.goronScript_text1_biggoronHealed
	.dw mainScripts.goronScript_text2
	.dw mainScripts.goronScript_text3_biggoronHealed
	.dw mainScripts.goronScript_text4_biggoronHealed
	.dw mainScripts.goronScript_text5
	.dw mainScripts.goronScript_upgradeRingBox
	.dw mainScripts.goronScript_giveSubrosianSecret


; ==============================================================================
; INTERACID_MISC_BOY_NPCS
; ==============================================================================
interactionCode3e:
	call checkInteractionState
	jp nz,@state1
	ld a,$01
	ld (de),a
	ld h,d
	ld l,$42
	ld a,(hl)
	ld b,a
	and $0f
	ldi (hl),a
	ld a,b
	and $f0
	swap a
	ld (hl),a
	cp $03
	jr nz,@nonVar03_03
	; subid30-34
	call getSunkenCityNPCVisibleSubId@main
	ld e,$42
	ld a,(de)
	cp b
	jp nz,interactionDelete
	cp $01
	jr nz,@continue
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ld a,<ROOM_SEASONS_06e
	jr nz,+
	ld a,<ROOM_SEASONS_05e
+
	ld hl,wActiveRoom
	cp (hl)
	jp nz,interactionDelete
	jr @continue
@nonVar03_03:
	add $04
	ld b,a
	call checkHoronVillageNPCShouldBeSeen_body@main
	jp nc,interactionDelete
@continue:
	ld e,$42
	ld a,b
	ld (de),a
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@var03_00
	.dw @@var03_01
	.dw @@var03_02
	.dw @@var03_03
@@var03_00:
	call @@var03_03
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_BALL_THROWN_TO_DOG
	ld bc,$00fd
	call objectCopyPositionWithOffset
	ld l,$4b
	ld a,(hl)
	ld l,$76
	ld (hl),a
	ld l,$4d
	ld a,(hl)
	ld l,$77
	ld (hl),a
+
	jr @func_68e9
@@var03_01:
@@var03_03:
	ld h,d
	ld l,$42
	ldi a,(hl)
	push af
	ldd a,(hl)
	ld (hl),a
	call interactionInitGraphics
	pop af
	ld e,$42
	ld (de),a
	inc e
	ld a,(de)
	ld hl,table_6ac9
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionRunScript
	jp objectSetVisible82
@@var03_02:
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	jp z,interactionDelete
	call @@var03_03
	ld a,(wRoomStateModifier)
	cp SEASON_SPRING
	ret nz
	ld h,d
	ld l,$49
	ld (hl),$08
	ld l,$50
	ld (hl),$28
	ld l,$4b
	ld (hl),$62
	ld l,$4d
	ld (hl),$28
	ld a,$06
	jp interactionSetAnimation
@func_68e9:
	call getRandomNumber
	and $3f
	add $78
	ld h,d
	ld l,$76
	ld (hl),a
	ret

@state1:
	ld e,$43
	ld a,(de)
	rst_jumpTable
	.dw @@var03_00
	.dw @@var03_01
	.dw @@var03_02
	.dw @@var03_03
@@var03_00:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	call func_6abc
	jr nz,+
	ld l,$60
	ld (hl),$01
	call interactionIncSubstate
	ld hl,$cceb
	ld (hl),$01
	call interactionAnimate
+
	jp @@@runScriptPushLinkAwayUpdateDrawPriority
@@@substate1:
	ld a,($cceb)
	cp $02
	jr nz,@@@runScriptPushLinkAwayUpdateDrawPriority
	call @func_68e9
	ld l,$45
	ld (hl),$00
	ld a,$08
	call interactionSetAnimation
@@@runScriptPushLinkAwayUpdateDrawPriority:
	call interactionRunScript
	jp interactionPushLinkAwayAndUpdateDrawPriority
@@var03_01:
	ld h,d
	ld l,$42
	ld a,(hl)
	cp $02
	jr c,@@var03_03
	call checkInteractionSubstate
	jr nz,+
	call interactionIncSubstate
	xor a
	ld l,$4e
	ldi (hl),a
	ld (hl),a
	call beginJump
+
	call updateSpeedZ
@@var03_03:
	call interactionRunScript
	jp interactionAnimateAsNpc
@@var03_02:
	ld a,(wRoomStateModifier)
	cp SEASON_SPRING
	jp nz,@@var03_03
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4
	.dw @@@substate5
	.dw @@@substate6
	.dw @@@substate7
	.dw @@@substate8
	.dw @@@substate9
	.dw @@@substateA
	.dw @@@substateB
	.dw @@@substateC
@@@substate0:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr nc,+
	ld h,d
	ld l,$77
	ld (hl),$0c
+
	call func_6ac1
	jp nz,runScriptSetPriorityRelativeToLink_withTerrainEffects
	call objectApplySpeed
	cp $4b
	jr c,+
	call interactionIncSubstate
	ld bc,$fe80
	call objectSetSpeedZ
	ld l,$50
	ld (hl),$14
	ld a,$09
	call interactionSetAnimation
+
	jp animateRunScript
@@@substate1:
	ld a,($ccc3)
	or a
	ret nz
	inc a
	ld ($ccc3),a
	call interactionIncSubstate
	jp objectSetVisiblec2
@@@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	call interactionIncSubstate
	ld l,$76
	ld (hl),$28
	call objectCenterOnTile
	ld l,$4b
	ld a,(hl)
	sub $05
	ld (hl),a
	ld a,$06
	jp interactionSetAnimation
@@@substate3:
	call func_6abc
	ret nz
	call interactionIncSubstate
	ld a,$05
	jp interactionSetAnimation
@@@substate4:
	ld e,$4f
	ld a,($ccc3)
	ld (de),a
	or a
	ret nz
	call interactionIncSubstate
	ld bc,$fd40
	call objectSetSpeedZ
	ld l,$4f
	ld (hl),$f6
	ld l,$50
	ld (hl),$28
	ld l,$49
	ld (hl),$00
	ld a,$53
	jp playSound
@@@substate5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	call interactionIncSubstate
	ld l,$76
	ld (hl),$10
	ld l,$71
	ld (hl),$00
	ret
@@@substate6:
	call func_6abc
	ret nz
	jp interactionIncSubstate
@@@substate7:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr nc,+
	ld h,d
	ld l,$77
	ld (hl),$0c
+
	call func_6ac1
	jp nz,runScriptSetPriorityRelativeToLink_withTerrainEffects
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $28
	jr nc,+
	call interactionIncSubstate
	ld l,$76
	ld (hl),$06
	ld l,$49
	ld (hl),$18
+
	jp animateRunScript
@@@substate8:
@@@substateA:
	call func_6abc
	ret nz
	ld l,$49
	ld a,(hl)
	swap a
	rlca
	add $05
	call interactionSetAnimation
	jp interactionIncSubstate
@@@substate9:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr nc,+
	ld h,d
	ld l,$77
	ld (hl),$0c
+
	call func_6ac1
	jr nz,runScriptSetPriorityRelativeToLink_withTerrainEffects
	call objectApplySpeed
	cp $18
	jr nc,+
	call interactionIncSubstate
	ld l,$76
	ld (hl),$06
	ld l,$49
	ld (hl),$10
+
	jp animateRunScript
@@@substateB:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr nc,+
	ld h,d
	ld l,$77
	ld (hl),$0c
+
	call func_6ac1
	jr nz,runScriptSetPriorityRelativeToLink_withTerrainEffects
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $62
	jr c,+
	call interactionIncSubstate
	ld l,$76
	ld (hl),$06
	ld l,$49
	ld (hl),$08
+
	jp animateRunScript
@@@substateC:
	call func_6abc
	ret nz
	ld l,$45
	ld (hl),$00
	ld a,$06
	jp interactionSetAnimation

animateRunScript:
	call interactionAnimate

runScriptSetPriorityRelativeToLink_withTerrainEffects:
	call interactionRunScript
	jp objectSetPriorityRelativeToLink_withTerrainEffects

func_6abc:
	ld h,d
	ld l,$76
	dec (hl)
	ret
	
func_6ac1:
	ld h,d
	ld l,$77
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

table_6ac9:
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02
	.dw @var03_03

@var03_00:
	.dw mainScripts.boyWithDogScript_text1
	.dw mainScripts.boyWithDogScript_text2
	.dw mainScripts.boyWithDogScript_text2
	.dw mainScripts.boyWithDogScript_text3
	.dw mainScripts.boyWithDogScript_text5
	.dw mainScripts.boyWithDogScript_text5
	.dw mainScripts.boyWithDogScript_text6
	.dw mainScripts.boyWithDogScript_text6
	.dw mainScripts.boyWithDogScript_text7
	.dw mainScripts.boyWithDogScript_text4
	.dw mainScripts.boyWithDogScript_text5

@var03_01:
	.dw mainScripts.horonVillageBoyScript_text1
	.dw mainScripts.horonVillageBoyScript_text1
	.dw mainScripts.horonVillageBoyScript_text2
	.dw mainScripts.horonVillageBoyScript_text2
	.dw mainScripts.horonVillageBoyScript_text3
	.dw mainScripts.horonVillageBoyScript_text4
	.dw mainScripts.horonVillageBoyScript_text5
	.dw mainScripts.horonVillageBoyScript_text6
	.dw mainScripts.horonVillageBoyScript_text7
	.dw mainScripts.horonVillageBoyScript_text2
	.dw mainScripts.horonVillageBoyScript_text4

@var03_02:
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text3

@var03_03:
	.dw mainScripts.sunkenCityBoyScript_text1
	.dw mainScripts.sunkenCityBoyScript_text2
	.dw mainScripts.sunkenCityBoyScript_text3
	.dw mainScripts.sunkenCityBoyScript_text4
	.dw mainScripts.sunkenCityBoyScript_text3


; ==============================================================================
; INTERACID_PIRATIAN
; ==============================================================================
interactionCode40:
; ==============================================================================
; INTERACID_PIRATIAN_CAPTAIN
; ==============================================================================
interactionCode41:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
	.dw @@subid7
	.dw @@subid8
	.dw @@subid9
	.dw @@subidA
	.dw @@subidB
	.dw @@subidC
	.dw @@subidD
	.dw @@subidE
@@subid0:
	call func_6c3c

@@subid1:
@@subid2:
@@subid3:
@@subid4:
@@subid5:
@@subid6:
@@subid9:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	jp nz,interactionDelete
	call objectGetTileAtPosition
	ld (hl),$00
@@subid7:
@@subid8:
	call @func_6b91
	ld a,$04
	jr @func_6b8b
@@subidB:
@@subidC:
@@subidD:
@@subidE:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	jp nz,interactionDelete
	call @func_6b91
	ld e,$42
	ld a,(de)
	cp $0d
	ld a,$00
	jr z,+
	ld a,$04
+
	jr @func_6b8b
@@subidA:
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	call @func_6b91
	ld a,$04
@func_6b8b:
	call interactionSetAnimation
	jp func_6bc4
@func_6b91:
	call interactionInitGraphics
	ld h,d
	ld l,$44
	ld (hl),$01
	ld a,>TX_3a00
	call interactionSetHighTextIndex
	call func_6c29
	ld e,$42
	ld a,(de)
	ld hl,table_6cbf
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionRunScript
@state1:
	ld e,$42
	ld a,(de)
	cp $08
	jr nz,+
	call func_6c51
+
	call interactionRunScript
	jp c,interactionDelete
	jp func_6bc4
func_6bc4:
	call interactionAnimate
	ld e,$7c
	ld a,(de)
	or a
	jr nz,func_6be9
	ld e,$60
	ld a,(de)
	dec a
	jr nz,+
	call getRandomNumber_noPreserveVars
	and $1f
	ld hl,table_6c09
	rst_addAToHl
	ld a,(hl)
	or a
	jr z,+
	ld e,$60
	ld (de),a
+
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
func_6be9:
	ld e,$50
	ld a,(de)
	cp $28
	jr z,+
	cp $50
	jr z,++
	ret
+
	ld e,$60
	ld a,(de)
	cp $09
	ret nz
	jr +++
++
	ld e,$60
	ld a,(de)
	cp $0c
	ret nz
+++
	ld e,$60
	ld a,$01
	ld (de),a
	ret
table_6c09:
	.db $00 $00 $04 $04 $00 $00 $08 $08
	.db $00 $00 $00 $00 $04 $04 $00 $00
	.db $00 $08 $08 $00 $00 $00 $10 $10
	.db $00 $00 $00 $20 $20 $00 $00 $00
func_6c29:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,+
	xor a
+
	cp $20
	ld a,$01
	jr nc,+
	xor a
+
	ld e,$7a
	ld (de),a
	ret
func_6c3c:
	ld a,TREASURE_PIRATES_BELL
	call checkTreasureObtained
	jr c,+
	xor a
	jr ++
+
	or a
	ld a,$01
	jr z,++
	ld a,$02
++
	ld e,$7b
	ld (de),a
	ret
func_6c51:
	call func_6c8b
	jr z,++
	ld a,($cc46)
	bit 6,a
	jr z,+
	ld c,$01
	ld b,$db
	jp func_6c78
+
	ld a,($cc45)
	bit 6,a
	ret nz
++
	ld h,d
	ld l,$7e
	ld a,$00
	cp (hl)
	ret z
	ld c,$00
	ld b,$d9
	jp func_6c78
func_6c78:
	ld h,d
	ld l,$7e
	ld (hl),c
	ld a,$05
	ld l,$7f
	add (hl)
	ld c,a
	ld a,b
	call setTile
	ld a,$70
	jp playSound
func_6c8b:
	ld hl,table_6cb2
	ld a,($d00b)
	ld c,a
	ld a,($d00d)
	ld b,a
---
	ldi a,(hl)
	or a
	ret z
	add $04
	sub c
	cp $09
	jr nc,+
	ldi a,(hl)
	add $03
	sub b
	cp $07
	jr nc,++
	ld a,(hl)
	ld e,$7f
	ld (de),a
	or d
	ret
+
	inc hl
++
	inc hl
	jr ---
table_6cb2:
	.db $18 $58 $00 $18
	.db $68 $01 $18 $78
	.db $02 $18 $88 $03
	.db $00

table_6cbf:
	.dw mainScripts.piratianCaptainScript_inHouse
	.dw mainScripts.piratian1FScript_text1BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text1BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text1BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text1BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text2BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text2BasedOnD6Beaten
	.dw mainScripts.unluckySailorScript
	.dw mainScripts.piratian2FScript_textBasedOnD6Beaten
	.dw mainScripts.piratianRoofScript
	.dw mainScripts.samasaGatePiratianScript
	.dw mainScripts.piratianCaptainByShipScript
	.dw mainScripts.piratianFromShipScript
	.dw mainScripts.piratianByCaptainWhenDeparting1Script
	.dw mainScripts.piratianByCaptainWhenDeparting2Script


; ==============================================================================
; INTERACID_PIRATE_HOUSE_SUBROSIAN
; ==============================================================================
interactionCode42:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	ld b,$00
	jr nz,+
	inc b
+
	ld e,$42
	ld a,(de)
	cp b
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld l,$42
	ld a,(hl)
	ld hl,table_6d14
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

table_6d14:
	.dw mainScripts.pirateHouseSubrosianScript_piratesAround
	.dw mainScripts.pirateHouseSubrosianScript_piratesLeft


; ==============================================================================
; INTERACID_SYRUP
;
; Variables:
;   var38: Item being bought
;   var39: Set to 0 if Link has enough rupees (instead of wShopHaveEnoughRupees)
;   var3a: Set to 1 if Link can't purchase an item (because he has too many of it)
;   var3b: "Return value" from purchase script (if $ff, the purchase failed)
;   var3c: Object index of item that Link is holding
; ==============================================================================
interactionCode43:
.ifdef ROM_AGES
	callab commonInteractions2.checkReloadShopItemTiles
.else
	call commonInteractions2.checkReloadShopItemTiles
.endif
	call @runState
	jp interactionAnimateAsNpc

@runState:
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

	ld l,Interaction.collisionRadiusY
	ld (hl),$12
	inc l
	ld (hl),$07

	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
.ifdef ROM_SEASONS
	call getThisRoomFlags
	and $40
	ld hl,mainScripts.syrupScript_notTradedMushroomYet
	jr z,+
.endif
	ld hl,mainScripts.syrupScript_spawnShopItems
+
	jr @setScriptAndGotoState2


; State 1: Waiting for Link to talk to her
@state1:
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

	xor a
	ld (de),a

	ld a,$81
	ld (wDisabledObjects),a

	ld a,(wLinkGrabState)
	or a
	jr z,@talkToSyrupWithoutItem

	; Get the object that Link is holding
	ld a,(w1Link.relatedObj2+1)
	ld h,a
.ifdef ROM_AGES
	ld e,Interaction.var3b
.else
	ld e,Interaction.var3c
.endif
	ld (de),a

	; Assume he's holding an INTERACID_SHOP_ITEM. Subids $07-$0c are for syrup's shop.
	ld l,Interaction.subid
	ld a,(hl)
	push af
	ld b,a
	sub $07

.ifdef ROM_AGES
	ld e,Interaction.var37
.else
	ld e,Interaction.var38
.endif
	ld (de),a

	; Check if Link has the rupees for it
	ld a,b
	ld hl,commonInteractions2.shopItemPrices
	rst_addAToHl
	ld a,(hl)
	call cpRupeeValue
.ifdef ROM_AGES
	ld (wShopHaveEnoughRupees),a
.else
	ld e,Interaction.var39
	ld (de),a
.endif
	ld ($cbad),a

	; Check the item type, see if Link is allowed to buy any more than he already has
	pop af
	cp $07
	jr z,@checkPotion
	cp $09
	jr z,@checkPotion

	cp $0b
	jr z,@checkBombchus

	ld a,(wNumGashaSeeds)
	jr @checkQuantity

@checkBombchus:
	ld a,(wNumBombchus)

@checkQuantity:
	; For bombchus and gasha seeds, amount caps at 99
	cp $99
	ld a,$01
	jr nc,@setCanPurchase
	jr @canPurchase

@checkPotion:
	ld a,TREASURE_POTION
	call checkTreasureObtained
	ld a,$01
	jr c,@setCanPurchase

@canPurchase:
	xor a

@setCanPurchase:
	; Set var38 to 1 if Link can't purchase the item because he has too much of it
.ifdef ROM_AGES
	ld e,Interaction.var38
.else
	ld e,Interaction.var3a
.endif
	ld (de),a

	ld hl,mainScripts.syrupScript_purchaseItem
	jr @setScriptAndGotoState2

@talkToSyrupWithoutItem:
	call commonInteractions2.shopkeeperCheckAllItemsBought
	jr z,@showWelcomeText

	ld hl,mainScripts.syrupScript_showClosedText
	jr @setScriptAndGotoState2

@showWelcomeText:
	ld hl,mainScripts.syrupScript_showWelcomeText

@setScriptAndGotoState2:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	jp interactionSetScript


; State 2: running a script
@state2:
	call interactionRunScript
	ret nc

	; Script done

	xor a
	ld (wDisabledObjects),a

	; Check response from script (was purchase successful?)
.ifdef ROM_AGES
	ld e,Interaction.var3a
.else
	ld e,Interaction.var3b
.endif
	ld a,(de)
	or a
	jr z,@gotoState1 ; Skip below code if he was holding nothing to begin with

	; If purchase was successful, set the held item (INTERACID_SHOP_ITEM) to state
	; 3 (link obtains it)
	inc a
	ld c,$03
	jr nz,++

	; If purchase was not successful, set the held item to state 4 (return to display
	; area)
	ld c,$04
++
	xor a
	ld (de),a
.ifdef ROM_AGES
	ld e,Interaction.var3b
.else
	ld e,Interaction.var3c
.endif
	ld a,(de)
	ld h,a
	ld l,Interaction.state
	ld (hl),c
	call dropLinkHeldItem

@gotoState1:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret


; ==============================================================================
; INTERACID_S_ZELDA
; ==============================================================================
interactionCode44:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw zelda_state0
	.dw zelda_state1

zelda_state0:
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	ld b,a
	ld hl,table_6ea3
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,b
	or a
	jr z,@subid0
	cp $08
	jr z,@subid8
	cp $09
	jr z,@subid9

@setVisibleInitGraphicsIncState:
	call objectSetVisible82
	call interactionInitGraphics
	jr zelda_state1

@subid0:
	ld a,$b0
	ld ($cc1d),a
	ld (wLoadedTreeGfxIndex),a
	
	call getThisRoomFlags
	bit 7,a
	jr z,+
	ld a,$01
	ld ($ccab),a
	ld a,(wActiveMusic)
	or a
	jr z,+
	xor a
	ld (wActiveMusic),a
	ld a,$38
	call playSound
+
	ld hl,$cbb3
	ld b,$10
	call clearMemory
	jr @setVisibleInitGraphicsIncState
@subid8:
	call checkGotMakuSeedDidNotSeeZeldaKidnapped
	bit 7,c
	jp nz,interactionDelete
	jr @setVisibleInitGraphicsIncState
@subid9:
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	jr @setVisibleInitGraphicsIncState

zelda_state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @runSubid5
	.dw @runSubid6
	.dw @faceLinkAndRunScript
	.dw @runSubid8
	.dw @faceLinkAndRunScript

@animateAndRunScript:
	call interactionRunScript
	jp interactionAnimate

@runSubid5:
	call interactionRunScript
	ld e,$47
	ld a,(de)
	or a
	jp nz,interactionAnimate
	ret

@runSubid6:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimate

@faceLinkAndRunScript:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@runSubid8:
	ld a,GLOBALFLAG_TALKED_TO_ZELDA_BEFORE_ONOX_FIGHT
	call checkGlobalFlag
	jr nz,@faceLinkAndRunScript
	jr @animateAndRunScript

table_6ea3:
	.dw mainScripts.zeldaScript_ganonBeat
	.dw mainScripts.zeldaScript_afterEscapingRoomOfRites
	.dw mainScripts.zeldaScript_zeldaKidnapped
	.dw mainScripts.script5fe6
	.dw mainScripts.script5fe6
	.dw mainScripts.script5fea
	.dw mainScripts.script5fee
	.dw mainScripts.zeldaScript_withAnimalsHopefulText
	.dw mainScripts.zeldaScript_blessingBeforeFightingOnox
	.dw mainScripts.zeldaScript_healLinkIfNeeded


; ==============================================================================
; INTERACID_TALON
; ==============================================================================
interactionCode45:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	or a
	jr nz,@@subid1
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	ld h,d
	ld l,$44
	ld (hl),$01
	ld l,$79
	ld (hl),$01
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.caveTalonScript
	call interactionSetScript
	ld a,$03
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@@subid1:
	ld h,d
	ld l,$44
	ld (hl),$02
	ld l,$78
	ld (hl),$ff
	call func_6f3c
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.returnedTalonScript
	call interactionSetScript
	jp interactionAnimateAsNpc
@state1:
	ld e,$79
	ld a,(de)
	or a
	jr z,+
	ld a,(wFrameCounter)
	and $3f
	jr nz,+
	ld a,$01
	ld b,$fa
	ld c,$0a
	call objectCreateFloatingSnore
+
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimate
	ld e,$7a
	ld a,(de)
	or a
	jr nz,+
	call objectPreventLinkFromPassing
+
	jp objectSetPriorityRelativeToLink_withTerrainEffects
@state2:
	call interactionRunScript
	call func_6f3c
	jp interactionAnimateAsNpc
func_6f3c:
	ld c,$28
	call objectCheckLinkWithinDistance
	jr nc,+
	ld e,$78
	ld a,(de)
	cp $06
	ret z
	ld a,$06
	jr ++
+
	ld e,$78
	ld a,(de)
	cp $05
	ret z
	ld a,$05
++
	ld (de),a
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_MAKU_LEAF
; leaves during maku tree cutscenes
; Variables:
;   var03: pointer to another interactionCode48
;   var3a:
;   var3b:
;   var3c:
; ==============================================================================
interactionCode48:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Interaction.var3a
	ld (hl),$01
	ld l,Interaction.subid
	ld a,(hl)
	or a
	ret z
	ld l,Interaction.state
	inc (hl)
	jp interactionInitGraphics

@state1:
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	ret nz
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MAKU_LEAF
	ld e,Interaction.var03
	ld a,(de)
	ld l,e
	ld (hl),a
	dec l
	ld e,Interaction.counter1
	ld a,(de)
	inc a
	ld (de),a
	ld (hl),a
	cp $03
	jp z,interactionDelete
	jp @func_7002

@state2:
	ld a,$03
	ld (de),a
	ld h,d
	ld l,Interaction.subid
	ldi a,(hl)
	add (hl)
	ld hl,@table_701e
	rst_addDoubleIndex
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	ld e,$4d
	ldi a,(hl)
	ld (de),a
	call @func_7012
	ld hl,@table_702c
	call @func_6fee
	ld a,$83
	call playSound
	ld a,$70
	ld e,$7c
	ld (de),a
	jp objectSetVisible80

@state3:
	call objectApplySpeed
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ld a,$83
	call z,playSound
+
	ld l,$4d
	ld a,(hl)
	and $f0
	cp $f0
	jp z,interactionDelete
	ld l,$7b
	dec (hl)
	call z,@func_7018
	call interactionDecCounter1
	ret nz
	ld l,$78
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(hl)
	inc a
	jp z,interactionDelete

@func_6fee:
	ld e,$49
	ldi a,(hl)
	ld (de),a
	ld e,$46
	ldi a,(hl)
	ld (de),a
	ld e,$50
	ldi a,(hl)
	ld (de),a
	ld e,$78
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@func_7002:
	ld e,Interaction.counter1
	ld a,(de)
	ld hl,@table_700e
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var3a
	ld (de),a
	ret

@table_700e:
	.db $01
	.db $3c
	.db $32
	.db $ff

@func_7012:
	ld e,Interaction.var3b
	ld a,$0b
	ld (de),a
	ret

@func_7018:
	ldbc INTERACID_SPARKLE $02
	call objectCreateInteraction

@table_701e:
	.db $18 $f2
	.db $00 $a8
	.db $d8 $c0
	.db $08 $c8
	.db $12 $cd
	.db $ea $e5
	.db $1a $ed

@table_702c:
	; angle - counter1 - speed
	.db $12 $0a $78
	.db $13 $09 $78
	.db $14 $08 $6e
	.db $15 $08 $6e
	.db $16 $08 $64
	.db $17 $06 $50
	.db $18 $04 $46
	.db $1a $04 $46
	.db $1c $05 $3c
	.db $1e $05 $3c
	.db $00 $06 $3c
	.db $02 $06 $3c
	.db $04 $05 $32
	.db $06 $04 $32
	.db $08 $02 $32
	.db $0a $01 $32
	.db $0c $02 $32
	.db $0e $04 $3c
	.db $10 $04 $3c
	.db $12 $06 $46
	.db $14 $06 $50
	.db $15 $0a $50
	.db $16 $0c $64
	.db $17 $16 $78
	.db $ff


; ==============================================================================
; INTERACID_SYRUP_CUCCO
;
; Variables:
;   var3c: $00 normally, $01 while cucco is chastizing Link
;   var3d: Animation index?
;   var3e: Also an animation index?
; ==============================================================================
.ifdef ROM_AGES
interactionCodec9:
.else
interactionCode49:
.endif
	call @runState
	jp @updateAnimation

@runState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@updateAnimation:
	ld e,Interaction.var3d
	ld a,(de)
	or a
.ifdef ROM_AGES
	ret z
	jp interactionAnimate
.else
	jr z,+
	call interactionAnimate
+
	jp objectSetVisible80
.endif

@state0:
.ifdef ROM_SEASONS
	call getThisRoomFlags
	and $40
	jp z,interactionDelete
.endif
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics

	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),$06
	inc l
	ld (hl),$06 ; [collisionRadiusX]

	ld l,Interaction.speed
	ld (hl),SPEED_a0
	call @beginHop
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
.ifdef ROM_AGES
	call objectSetVisible80
.endif
	jp @func_7710

@state1:
	call @updateHopping
	call @updateMovement

	; Return if [w1Link.yh] < $69
	ld hl,w1Link.yh
	ld c,$69
	ld b,(hl)
	ld a,$69
	ld l,a
	ld a,c
	cp b
	ret nc

	; Check if he's holding something
	ld a,(wLinkGrabState)
	or a
	ret z

	; Freeze Link
	ld e,Interaction.var3c
	ld a,$02
	ld (de),a
	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a

	ld a,l
	ld hl,w1Link.yh
	ld (hl),a
	jp @initState2

; Unused?
@func_766f:
	xor a
	ld (de),a ; ?
	ld e,Interaction.var3d
	ld (de),a
	ld e,Interaction.var3c
	ld a,$01
	ld (de),a
	ld a,(wLinkGrabState)
	or a
	jr z,@gotoState4

	; Do something with the item Link's holding?
	ld a,(w1Link.relatedObj2+1)
	ld h,a
	ld e,Interaction.var3a
	ld (de),a
	ld hl,mainScripts.syrupCuccoScript_awaitingMushroomText
	jp @setScriptAndGotoState4

@gotoState4:
	ld hl,mainScripts.syrupCuccoScript_awaitingMushroomText

@setScriptAndGotoState4:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	jp interactionSetScript


; Moving toward Link after he tried to steal something
@state2:
	call @updateHopping
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $0c
	ld hl,w1Link.xh
	cp (hl)
	ret nc

	; Reached Link
	ld e,Interaction.var3d
	xor a
	ld (de),a
	ld hl,mainScripts.syrupCuccoScript_triedToSteal
	jp @setScriptAndGotoState4


; Moving back to normal position
@state3:
	call @updateHopping
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	cp $78
	ret c

	xor a
	ld (wDisabledObjects),a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	jp @func_7710


@state4:
	call interactionRunScript
	ret nc

	ld e,Interaction.var3c
	ld a,(de)
	cp $02
	jr z,@beginMovingBack

	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld l,Interaction.var3c
	ld (hl),$00
	ld l,Interaction.var3d
	ld (hl),$01
	xor a
	ld (wDisabledObjects),a
	ret

@beginMovingBack:
	jp @initState3

;;
@updateHopping:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

;;
@beginHop:
	ld bc,-$c0
	jp objectSetSpeedZ

;;
@updateMovement:
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $68
	cp $20
	ret c

	; Reverse direction
	ld e,Interaction.angle
	ld a,(de)
	xor $10
	ld (de),a

	ld e,Interaction.var3e
	ld a,(de)
	xor $01
	ld (de),a
	jp interactionSetAnimation

;;
@func_7710:
	ld h,d
	ld l,Interaction.var3c
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),SPEED_80
	jr +++

;;
@initState2:
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
	ld l,Interaction.speed
	ld (hl),SPEED_200
+++
	ld l,Interaction.var3d
	ld (hl),$01
	ld l,Interaction.angle
	ld (hl),$18
	xor a
	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a
	ld l,Interaction.var3e
	ld a,$00
	ld (hl),a
	jp interactionSetAnimation

;;
@initState3:
	ld h,d
	ld l,Interaction.state
	ld (hl),$03
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld l,Interaction.var3d
	ld (hl),$01
	ld l,Interaction.angle
	ld (hl),$08
	xor a
	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a
	ld l,Interaction.var3e
	ld a,$01
	ld (hl),a
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_D1_RISING_STONES
; ==============================================================================
interactionCode4b:
	ld e,$44
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
	ld e,$42
	ld a,(de)
	add a
	inc a
	ld e,$44
	ld (de),a
	jp interactionInitGraphics
@state1:
	ld a,$02
	ld (de),a
	ld a,$6f
	call playSound
	jp objectSetVisible81
@state2:
	ld e,$61
	ld a,(de)
	inc a
	jp z,interactionDelete
	jp interactionAnimate
@state3:
	ld a,$04
	ld (de),a
	call getRandomNumber_noPreserveVars
	ld b,a
	and $60
	swap a
	ld hl,@table_7260
	rst_addAToHl
	ld e,$54
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld a,b
	and $03
	ld hl,@table_7268
	rst_addAToHl
	ld e,$50
	ld a,(hl)
	ld (de),a
	call getRandomNumber_noPreserveVars
	ld b,a
	and $30
	swap a
	ld hl,@table_726c
	rst_addAToHl
	ld e,$70
	ld a,(hl)
	ld (de),a
	ld a,b
	and $0f
	ld hl,@table_7270
	rst_addAToHl
	ld e,$49
	ld a,(hl)
	ld (de),a
	inc a
	and $07
	cp $03
	jp c,objectSetVisible82
	jp objectSetVisible80
@state4:
	call objectApplySpeed
	ld e,$70
	ld a,(de)
	call objectUpdateSpeedZ
	ret nz
	jp interactionDelete
@state5:
	ld a,$06
	ld (de),a
	jp objectSetVisible81
@state6:
	call interactionDecCounter1
	jp z,interactionDelete
	jp interactionAnimate
@table_7260:
	; speedZ vals
	.db $c0 $fe $a0 $fe $a0 $fe $80 $fe
@table_7268:
	; speed vals
	.db $05 $0a $0a $14
@table_726c:
	; speedZ acceleration
	.db $0d $0e $0f $10
@table_7270:
	; angle vals
	.db $00 $01 $02 $03 $04 $05 $06 $07
	.db $01 $02 $03 $05 $06 $07 $02 $06


; ==============================================================================
; INTERACID_MISC_STATIC_OBJECTS
; ==============================================================================
interactionCode4c:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
	.dw @subid8
	.dw @subid9
	.dw @subidA
	.dw @subidB
	.dw @subidC
	.dw @subidD

	call @func_72de
	jp objectSetVisible80
	call @func_72de
	jp objectSetVisible81
@subid1:
@subid2:
@subid3:
	call @func_72de
	jp objectSetVisible82
@subid6:
@subidA:
@subidB:
@subidC:
@subidD:
	call @func_72de
	jp objectSetVisible83
@subid0:
	call checkInteractionState
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$40
	set 7,(hl)
	call interactionInitGraphics
	jp objectSetVisible80
+
	call getThisRoomFlags
	bit 6,(hl)
	jr z,+
	ld e,$60
	ld a,(de)
	cp $10
	jr nz,+
	ld a,$02
	ld (de),a
+
	jp interactionAnimate
@func_72de:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	jp interactionInitGraphics
+
	pop hl
	jp interactionAnimate
@subid7:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld a,$9b
	call loadPaletteHeader
	call interactionInitGraphics
	call objectSetVisible82
+
	jp interactionAnimate
@subid8:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	call interactionInitGraphics
	call objectSetVisible80
+
	call interactionAnimate
	ld a,(wFrameCounter)
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible
@subid9:
	call checkInteractionState
	ret nz
	call getThisRoomFlags
	and $40
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	jp objectSetVisible83
@subid4:
@subid5:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld bc,$fe00
	call objectSetSpeedZ
	ld l,$49
	ld (hl),$01
	ld l,$50
	ld (hl),$28
	ld a,$51
	call playSound
	call interactionInitGraphics
	jp objectSetVisiblec0
+
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld a,$77
	call playSound
	jp interactionDelete


; ==============================================================================
; INTERACID_PIRATE_SKULL
; ==============================================================================
interactionCode4d:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_TALKED_WITH_GHOST_PIRATE
	call checkGlobalFlag
	jp z,interactionDelete
	ld c,INTERACID_PIRATE_SKULL
	call objectFindSameTypeObjectWithID
	jr nz,+
	; delete if carrying the skull
	ld a,h
	cp d
	jp nz,interactionDelete
	call func_228f
	jp z,interactionDelete
+
	ld a,TREASURE_PIRATES_BELL
	call checkTreasureObtained
	jr c,+
	call getRandomNumber
	and $03
	inc a
	ld e,$78
	ld (de),a
+
	ld a,>TX_4d00
	call interactionSetHighTextIndex
	ld hl,mainScripts.pirateSkullScript_notYetCarried
	call interactionSetScript
	call interactionInitGraphics
	jp objectSetVisiblec2
@@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	call objectPreventLinkFromPassing
	jp interactionRunScript
@@@substate1:
	ld e,$7a
	ld a,(de)
	or a
	jr z,+
	ld b,a
	inc e
	ld a,(de)
	ld c,a
	push bc
	call objectCheckContainsPoint
	pop bc
	jr c,++
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	ld e,$50
	ld a,$14
	ld (de),a
	call objectApplySpeed
+
	ld h,d
	ld l,$7a
	xor a
	ldi (hl),a
	ld (hl),a
	jp objectAddToGrabbableObjectBuffer
++
	ld bc,TX_4d0a
	call showText
	jp interactionDelete
@@state2:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
@@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	xor a
	ld (wLinkGrabState2),a
	ld l,$79
	ld (hl),a
	inc a
	call interactionSetAnimation
	jp objectSetVisiblec1
@@@substate1:
	ld hl,$ccc1
	bit 7,(hl)
	ld e,$78
	ld a,(de)
	ld (hl),a
	jr nz,+
	ld e,$46
	ld a,$14
	ld (de),a
	ld a,$01
	jp interactionSetAnimation
+
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	ld (hl),$14
	ld a,$7e
	jp playSound
@@@substate2:
	call objectCheckWithinRoomBoundary
	jp nc,interactionDelete
	call objectReplaceWithAnimationIfOnHazard
	jr c,@@@droppedInWater
	ld h,d
	ld l,$40
	res 1,(hl)
	ld l,$79
	ld (hl),d
	ret
@@@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call objectReplaceWithAnimationIfOnHazard
	jr c,@@@droppedInWater
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	ld h,d
	ld l,$40
	res 1,(hl)
	ld l,$44
	ld a,$01
	ldi (hl),a
	ld (hl),a
	ld l,$79
	ld a,(hl)
	or a
	ld bc,TX_4d06
	call nz,showText
	xor a
	call interactionSetAnimation
	jp objectSetVisible82
@@@droppedInWater:
	ld bc,TX_4d09
	jp showText
@subid1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
@@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ld a,$01
	ld ($cca4),a
	ld a,($d00b)
	ld e,$4b
	ld (de),a
	ld a,($d00d)
	ld e,$4d
	ld (de),a
	jp interactionInitGraphics
@@state1:
	ld a,($d00f)
	or a
	ret nz
	ld a,$02
	ld (de),a
	call objectGetZAboveScreen
	ld e,$4f
	ld (de),a
	call setLinkForceStateToState08
	jp objectSetVisiblec1
@@state2:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	ret nz
	call interactionIncState
	ld l,$50
	ld (hl),$14
	ld l,$49
	ld (hl),$10
	ld a,$02
	ld ($cc6b),a
	ld a,$ca
	jp playSound
@@state3:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZAndBounce
	push af
	ld a,$ca
	call z,playSound
	pop af
	ret nc
	call interactionIncState
	ld l,$46
	ld (hl),$28
	jp objectSetVisible82
@@state4:
	call interactionDecCounter1
	ret nz
	ld l,$44
	inc (hl)
	xor a
	ld ($cca4),a
	ld bc,TX_4d07
	jp showText
@@state5:
	ld a,($cfc0)
	or a
	ret z
	call objectCreatePuff
	jp interactionDelete


; ==============================================================================
; INTERACID_DIN_DANCING_EVENT
; ==============================================================================
interactionCode4e:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	cp $0b
	jr nz,@func_754f
	call getThisRoomFlags
	and $40
	jp nz,@seasonsFunc_08_754c
	ld hl,objectData.objectData7e4e
	call parseGivenObjectData
	ld hl,$cc1d
	ld (hl),$4e
	inc hl
	ld (hl),$06
	xor a
	ld hl,$cfd0
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld a,$03
	call setMusicVolume
@seasonsFunc_08_754c:
	jp interactionDelete

@func_754f:
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	cp $05
	jr nz,+
	ld e,$66
	ld a,$06
	ld (de),a
	inc e
	ld (de),a
	jr ++
+
	ld hl,table_770a
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$42
	ld a,(de)
	cp $07
	jp nz,++
	call interactionSetAlwaysUpdateBit
	jp objectSetVisible80
++
	call objectSetVisible83
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
	.dw @@subid7
	.dw @@subid8
	.dw @@subid9
	.dw @@subidA
@@subid5:
	ld a,($cfd0)
	or a
	jr nz,+
	call interactionAnimate
	jp interactionPushLinkAwayAndUpdateDrawPriority
+
	call objectCreatePuff
	jp interactionDelete
@@subid0:
@@subid1:
@@subid2:
@@subid3:
@@subid4:
@@subid8:
@@subid9:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@func75b5
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3

@@@func75b5:
	ld a,($cfd0)
	or a
	call nz,interactionIncSubstate
@@@animate:
	call interactionAnimate
@@@runScriptPushLinkAway:
	call interactionRunScript
	jp interactionPushLinkAwayAndUpdateDrawPriority
@@@substate1:
	ld e,$42
	ld a,(de)
	ld hl,bitTable
	add l
	ld l,a
	ld b,(hl)
	ld a,($cfd1)
	and b
	jr z,+
	call interactionIncSubstate
	ld l,$46
	ld (hl),$20
	ld l,$4d
	ldd a,(hl)
	ld (hl),a
+
	ld e,$42
	ld a,(de)
	cp $05
	call z,interactionAnimate
	jp @@@runScriptPushLinkAway
@@@substate2:
	call interactionDecCounter1
	jr nz,+
	call @@func_7612
	jp interactionIncSubstate
+
	call getRandomNumber_noPreserveVars
	and $0f
	sub $08
	ld h,d
	ld l,$4c
	add (hl)
	inc l
	ld (hl),a
	jp @@@runScriptPushLinkAway
@@@substate3:
	call objectApplySpeed
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
	jp interactionDelete
@@func_7612:
	ld e,$42
	ld a,(de)
	ld hl,@@table_7622
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$49
	ld (de),a
	ldi a,(hl)
	ld e,$50
	ld (de),a
	ret

@@table_7622:
	; angle - speed
	.db $04 $78
	.db $1d $78
	.db $1e $78
	.db $05 $78
	.db $15 $78
@@subid6:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4
	.dw @@@substate5
	.dw @@@substate6
@@@substate0:
	ld a,($cfd3)
	cp $3f
	jp nz,@@subid9@func75b5
	call interactionIncSubstate
	ld hl,mainScripts.troupeScript_startDanceScene
	call interactionSetScript
@@@substate1:
	call @@subid9@func75b5
	ld a,($cfd3)
	and $40
	ret z
	call fastFadeoutToWhite
	jp interactionIncSubstate
@@@substate2:
	ld a,($c4ab)
	or a
	ret nz
	ld a,$80
	ld ($cfd3),a
	ld a,CUTSCENE_S_DIN_DANCING
	ld ($cc04),a
	ld a,$08
	call setLinkIDOverride
	ld l,$02
	ld (hl),$01
	ld l,$19
	ld (hl),d
	jp interactionIncSubstate
@@@substate3:
	ld a,($cfd0)
	or a
	ret nz
	call @@subid9@runScriptPushLinkAway
	jp interactionIncSubstate
@@@substate4:
	ld a,($cfd0)
	cp $04
	ret nz
	call interactionIncSubstate
	ld a,$0d
	jp interactionSetAnimation
@@@substate5:
	ld a,($cfd0)
	cp $07
	ret nz
	call interactionIncSubstate
	ld l,$50
	ld (hl),$0a
	ld l,$49
	ld (hl),$08
	ret
@@@substate6:
	call objectApplySpeed
	ld a,($cfd1)
	rlca
	ret nc
	ld hl,$cfd0
	ld (hl),$08
	jp interactionDelete
@@subid7:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
@@@substate0:
	call interactionRunScript
	jr nc,@@@func_76e9
	call interactionIncSubstate
	ld hl,$cfd0
	ld (hl),$04
	jr @@@func_76e9
@@@substate1:
	call @@@func_76e9
	ld hl,$cfd0
	ld a,(hl)
	cp $06
	ret nz
	call interactionIncSubstate
	ld hl,mainScripts.troupeScript_tornadoEnd
	jp interactionSetScript
@@@substate2:
	call interactionRunScript
	jp c,interactionDelete
@@@func_76e9:
	call interactionAnimate
	ld a,(wFrameCounter)
	and $3f
	ret nz
	ld a,$d3
	jp playSound
@@subidA:
	call checkInteractionSubstate
	jr nz,+
	call interactionIncSubstate
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
+
	jp @@subid9@animate

table_770a:
	.dw mainScripts.troupeScript1
	.dw mainScripts.troupeScript2
	.dw mainScripts.troupeScript3
	.dw mainScripts.troupeScript4
	.dw mainScripts.troupeScript_Impa
	.dw mainScripts.troupeScript_stub
	.dw mainScripts.troupeScript_Din
	.dw mainScripts.troupeScript_tornadoStart
	.dw mainScripts.troupeScript_stub
	.dw mainScripts.troupeScript_stub
	.dw mainScripts.troupeScript_inHoronVillage


; ==============================================================================
; INTERACID_DIN_IMPRISONED_EVENT
; ==============================================================================
interactionCode4f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionCode4f_state0
	.dw interactionCode4f_state1

interactionCode4f_state0:
	call interactionIncState
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw objectSetVisible81
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid0:
	ld hl,mainScripts.dinImprisonedScript_setDinCoords
	call interactionSetScript
	jp objectSetVisiblec2

@subid1:
	ld hl,mainScripts.dinImprisonedScript_OnoxExplainsMotive
	call interactionSetScript
	jp objectSetVisible82

@subid3:
	call @setCounter2Between1To8
	ld e,Interaction.var03
	ld a,(de)
	add a
	add a
	add $10
	and $1f
	ld e,$49
	ld (de),a
	ld e,$50
	ld a,$78
	ld (de),a
	call objectSetVisible80
	jp objectSetInvisible

@subid4:
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr z,+
	ld a,$05
	call interactionSetAnimation
	jp objectSetVisible82
+
	jp objectSetVisible83

@subid5:
	ld hl,mainScripts.dinImprisonedScript_OnoxSaysComeIfYouDare
	call interactionSetScript
	jp objectSetVisible82

@func_7784:
	ld e,Interaction.var03
	ld a,(de)
	add $06
	ld b,a
	ld e,Interaction.var32
	ld a,(de)
	or a
	ld a,b
	jr z,+
	add $0b
+
	jp interactionSetAnimation

@func_7796:
	ld h,d
	ld l,$70
	ld e,Interaction.var32
	ld a,(de)
	or a
	jr nz,+
	ld e,Interaction.var03
	ld a,(de)
	add a
	add a
	ld e,$48
	ld (de),a
	ld b,(hl)
	inc l
	ld c,(hl)
	ld a,$38
	ld e,$48
	jp objectSetPositionInCircleArc
+
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
	ret

@setCounter2Between1To8:
	call getRandomNumber
	and $07
	inc a
	ld e,Interaction.counter2
	ld (de),a
	ret

interactionCode4f_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid0:
	ld a,($cfd0)
	cp $0e
	jp z,interactionDelete
	cp $0d
	jr nz,++
	call checkInteractionSubstate
	jr nz,+
	call interactionIncSubstate
	ld l,$4b
	ld (hl),$4a
	inc l
	inc l
	ld (hl),$81
	ld a,$0e
	call interactionSetAnimation
+
	call objectOscillateZ
++
	call interactionAnimate
	jp interactionRunScript

@subid2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	.dw @@substate8

@@substate0:
	call interactionIncSubstate
	ld a,$7c
	call @func_7957
	ld e,Interaction.var03
	ld a,(de)
	add a
	ld hl,@@table_784e
	rst_addDoubleIndex
	ld e,$49
	ldi a,(hl)
	ld (de),a
	ld e,$70
	ldi a,(hl)
	ld (de),a
	inc de
	ldi a,(hl)
	ld (de),a
	inc de
	ld a,(hl)
	ld (de),a
	xor a
	call @func_791f
	ld e,$46
	ld a,$3c
	ld (de),a

@@substate1:
	call interactionDecCounter1
	ld e,$5a
	jr nz,+
	ld a,(de)
	or $80
	ld (de),a
	jp interactionIncSubstate
+
	ld a,(de)
	xor $80
	ld (de),a
	ret

@@table_784e:
	.db $1c $30 $3c $5a
	.db $04 $30 $46 $50
	.db $1c $60 $50 $46
	.db $04 $60 $5a $3c

@@substate2:
	ld h,d
	ld l,$71
	dec (hl)
	ret nz
	ld l,$50
	ld (hl),$78
	jp interactionIncSubstate

@@substate3:
	call objectApplySpeed
	ld e,$70
	ld a,(de)
	ld b,a
	ld e,$4b
	ld a,(de)
	ld c,a
	cp b
	ld e,$43
	ld a,(de)
	jr nc,+
	xor a
	call @func_7941
	jp interactionIncSubstate
+
	or a
	ret nz
	jp @func_7a1e

@@substate4:
	ld h,d
	ld l,$72
	dec (hl)
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$a0
	ld l,$43
	ld a,(hl)
	or a
	ld bc,$4882
	ld a,$fe
	call z,@func_7968
	ret

@@substate5:
	call interactionDecCounter1
	jr nz,+
	call objectSetVisible
	ld l,$46
	ld (hl),$28
	ld a,$04
	call @func_791f
	jp interactionIncSubstate
+
	ld l,$49
	inc (hl)
	ld a,(hl)
	and $1f
	ld (hl),a
	ld a,$20
	ld e,$49
	ld bc,$4882
	jp objectSetPositionInCircleArc

@@substate6:
	call interactionDecCounter1
	ret nz
	ld l,$50
	ld (hl),$14
	ld l,$46
	ld (hl),$3c
	ld a,$04
	call @func_7941
	ld b,$02
--
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT
	inc l
	ld (hl),$04
	inc l
	ld a,b
	dec a
	ld (hl),a
	ld l,$46
	ld (hl),$0a
	jr z,+
	ld (hl),$14
+
	call objectCopyPosition
	ld e,$49
	ld l,e
	ld a,(de)
	ld (hl),a
	ld e,$50
	ld l,e
	ld a,(de)
	ld (hl),a
	dec b
	jr nz,--
++
	jp interactionIncSubstate

@@substate7:
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	ld hl,$cfd0
	ld (hl),$0c
	ld a,$79
	call @func_7957
	jp interactionIncSubstate

@@substate8:
	ld hl,$cfd0
	ld a,(hl)
	cp $0d
	ret nz
	jp interactionDelete

@func_791f:
	ld b,a
	ld e,$43
	ld a,(de)
	add b
	ld hl,@table_7931
	rst_addDoubleIndex
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	inc de
	inc de
	ldi a,(hl)
	ld (de),a
	ret

@table_7931:
	.db $60 $98
	.db $60 $68
	.db $90 $98
	.db $90 $68
	.db $30 $68
	.db $30 $98
	.db $60 $68
	.db $60 $98

@func_7941:
	ld b,a
	ld e,$43
	ld a,(de)
	add b
	ld hl,@table_794f
	rst_addAToHl
	ld e,$49
	ld a,(hl)
	ld (de),a
	ret

@table_794f:
	.db $1c
	.db $04
	.db $14
	.db $0c
	.db $0c
	.db $14
	.db $04
	.db $1c

@func_7957:
	ld b,a
	ld e,$43
	ld a,(de)
	or a
	ret nz
	ld a,b
	jp playSound
	ld hl,$ff8c
	ld (hl),$01
	jr +

@func_7968:
	ld hl,$ff8c
	ld (hl),$00
+
	ldh (<hFF8B),a
	ld a,$08
	ldh (<hFF8D),a
-
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT
	inc l
	ld (hl),$03
	ld l,$46
	ldh a,(<hFF8B)
	ld (hl),a
	ld l,$70
	ld (hl),b
	inc l
	ld (hl),c
	ld l,$72
	ldh a,(<hFF8C)
	ld (hl),a
	ldh a,(<hFF8D)
	dec a
	ldh (<hFF8D),a
	ld l,$43
	ld (hl),a
	jr nz,-
	ld a,$5c
	jp playSound

@subid3:
	ld h,d
	ld l,$46
	ld a,(hl)
	inc a
	jr z,+
	dec (hl)
	jp z,interactionDelete
+
	ld e,$45
	ld a,(de)
	or a
	jr nz,+
	call interactionDecCounter2
	ret nz
	call interactionCode4f_state0@func_7784
	call interactionCode4f_state0@func_7796
	call objectSetVisible
	jp interactionIncSubstate
+
	call objectApplySpeed
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	ld h,d
	ld l,$45
	ld (hl),$00
	call interactionCode4f_state0@setCounter2Between1To8
	jp objectSetInvisible

@subid4:
	call checkInteractionSubstate
	jr nz,+
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate
+
	ld hl,$cfd0
	ld a,(hl)
	cp $0c
	jp z,interactionDelete
	jp objectApplySpeed

@subid1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw interactionRunScript

@@substate0:
	call interactionRunScript
	jr c,+
	call interactionAnimate
	jr @@func_7a00
+
	jp interactionIncSubstate

@@func_7a00:
	ld h,d
	ld l,$61
	ld a,(hl)
	cp $70
	ld (hl),$00
	ret nz
	jp playSound

@@substate1:
	ld a,($cfd0)
	cp $0e
	ret nz
	call objectSetInvisible
	ld hl,mainScripts.dinImprisonedScript_OnoxSendsTempleDown
	call interactionSetScript
	jp interactionIncSubstate

@func_7a1e:
	ld a,($c486)
	ld b,a
	ld a,c
	sub b
	sub $40
	ld b,a
	ld a,($c486)
	add b
	cp $10
	ret nc
	ld ($c486),a
	ldh (<hCameraY),a
	ret

@subid5:
	call interactionAnimate
	call @subid1@func_7a00
	jp interactionRunScript


; ==============================================================================
; INTERACID_SMALL_VOLCANO
; ==============================================================================
interactionCode51:
	call checkInteractionState
	jr z,@state0
	ld a,(wFrameCounter)
	and $0f
	ld a,$b3
	call z,playSound
	ld a,($cd18)
	or a
	jr nz,+
	ld a,($cd19)
	or a
	call z,func_7a9a
+
	call interactionDecCounter1
	ret nz
	call func_7abe
	ld e,$42
	ld a,(de)
	or a
	ld c,$07
	jr z,+
	ld c,$0f
+
	call getRandomNumber
	and c
	srl c
	inc c
	sub c
	ld c,a
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_VOLCANO_ROCK
	ld e,$42
	inc l
	ld a,(de)
	ld (hl),a
	ld b,$00
	jp objectCopyPositionWithOffset
@state0:
	inc a
	ld (de),a
	ld ($ccae),a
	ld e,$42
	ld a,(de)
	ld hl,table_7acb
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$58
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret
func_7a9a:
	ld h,d
	ld l,$58
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	cp $ff
	jr nz,+
	pop hl
	jp interactionDelete
+
	ld ($cd18),a
	ldi a,(hl)
	ld ($cd19),a
	ld e,$70
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ld e,$58
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
func_7abe:
	call getRandomNumber_noPreserveVars
	ld h,d
	ld l,$70
	and (hl)
	inc l
	add (hl)
	ld l,$46
	ld (hl),a
	ret

table_7acb:
	.dw table_7acf
	.dw table_7ae8

table_7acf:
	; wScreenShakeCounterY - wScreenShakeCounterX - var30 - var31
	.db $00 $0f $00 $ff
	.db $0f $00 $00 $ff
	.db $96 $00 $0f $08
	.db $5a $5a $07 $03
	.db $00 $3c $1f $10
	.db $00 $78 $00 $ff
	.db $ff

table_7ae8:
	; wScreenShakeCounterY - wScreenShakeCounterX - var30 - var31
	.db $00 $1e $00 $ff
	.db $1e $00 $00 $ff
	.db $b4 $b4 $0f $08
	.db $3c $3c $1f $10
	.db $1e $00 $00 $ff
	.db $00 $78 $00 $ff
	.db $0f $0f $00 $ff
	.db $ff


; ==============================================================================
; INTERACID_BIGGORON
; ==============================================================================
interactionCode52:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call objectSetVisible82
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.biggoronScript
	jp interactionSetScript
@state1:
	call interactionAnimate
	jp interactionRunScript


; ==============================================================================
; INTERACID_HEAD_SMELTER
; ==============================================================================
interactionCode53:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	ld e,$44
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,mainScripts.headSmelterAtTempleScript
	call interactionSetScript
	jp objectSetVisible82
@@state1:
	call interactionRunScript
	call objectPreventLinkFromPassing
	jp npcFaceLinkAndAnimate
@@state2:
	call interactionAnimate
	call interactionRunScript
	jp c,interactionDelete
	ret
@subid1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @subid0@state1
	.dw @subid0@state2
	.dw @@state3
@@state0:
	ld a,GLOBALFLAG_UNBLOCKED_AUTUMN_TEMPLE
	call checkGlobalFlag
	jp z,interactionDelete
	ld e,$44
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,mainScripts.headSmelterAtFurnaceScript
	call interactionSetScript
	jp objectSetVisible82
@@state3:
	xor a
	ld ($cfc0),a
	call interactionRunScript
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
@@@substate0:
@@@substate1:
	call interactionAnimate
	ld a,($cfc0)
	call getHighestSetBit
	ret nc
	cp $03
	jr nz,+
	ld e,$44
	ld a,$01
	ld (de),a
	ret
+
	ld b,a
	inc b
	ld h,d
	ld l,$45
	ld (hl),b
	ld l,$43
	ld (hl),$08
	add $04
	jp interactionSetAnimation
@@@substate2:
@@@substate3:
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jr z,+
	ld (hl),$00
	ld l,$4d
	add (hl)
	ld (hl),a
+
	ld l,$43
	dec (hl)
	ret nz
	ld l,$45
	ld (hl),$01
	ret


; ==============================================================================
; INTERACID_SUBROSIAN_AT_D8_ITEMS
; ==============================================================================
interactionCode54:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw objectSetVisible82
@state0:
	ld a,$01
	ld (de),a
	call getRandomNumber
	and $0f
	ld hl,@table_7c0a
	rst_addAToHl
	ld a,(hl)
	ld e,$42
	ld (de),a
	ld bc,$fe40
	call objectSetSpeedZ
	ld l,$50
	ld (hl),$28
	ld l,$49
	ld (hl),$08
	call interactionInitGraphics
	jp objectSetVisiblec1
@table_7c0a:
	.db $0d ; Gasha seed
	.db $0e ; Ring
	.db $10 ; Lvl 1 Sword
	.db $3a ; Heart piece
	.db $40 ; Treasure map
	.db $54 ; Banana
	.db $76 ; Fish
	.db $57 ; Star ore
	.db $1b ; Shovel
	.db $5d ; Blaino's gloves
	.db $43 ; Big key
	.db $03 ; 1 ore chunk
	.db $31 ; Flippers
	.db $13 ; Lvl 1 shield
	.db $2e ; 200 rupees
	.db $23 ; Flute
@state1:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld e,$44
	ld a,$02
	ld (de),a
	jp objectReplaceWithAnimationIfOnHazard


; ==============================================================================
; INTERACID_SUBROSIAN_AT_D8
; ==============================================================================
interactionCode55:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw subrosianAtD8_subid0
	.dw subrosianAtD8_subid1

subrosianAtD8_subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call subrosianAtD8_getNumEssences
	cp $07
	jp c,interactionDelete

	call interactionInitGraphics
	ld hl,mainScripts.subrosianAtD8Script
	call interactionSetScript

	ld a,$06
	call objectSetCollideRadius

	ld l,Interaction.counter1
	ld (hl),60
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList

	call getThisRoomFlags
	and $40
	ld a,$02
	jr nz,+
	dec a
+
	ld e,Interaction.state
	ld (de),a
	jp objectSetVisiblec2

; Waiting for Link to throw bomb in
@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call interactionAnimate
	call objectPreventLinkFromPassing
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	jr nz,++

	call interactionDecCounter1
	ret nz
	ld l,Interaction.substate
	inc (hl)
	call objectSetVisiblec2
	ld hl,mainScripts.subrosianAtD8Script_tossItemIntoHole
	jp interactionSetScript
++
	xor a
	ld (de),a
	ld bc,TX_3c00
	jp showText

@substate1:
	call objectPreventLinkFromPassing
	call interactionAnimate
	call interactionRunScript
	ret nc

	ld h,d
	ld l,Interaction.counter1
	ld (hl),60
	ld l,Interaction.substate
	dec (hl)
	ret

@state2:
	ld c,$60
	call objectUpdateSpeedZ_paramC
	jr nz,++
	ld bc,-$200
	call objectSetSpeedZ
++
	call objectPreventLinkFromPassing
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	jp interactionRunScript


subrosianAtD8_subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call subrosianAtD8_getNumEssences
	cp $07
	jp c,interactionDelete

	call getThisRoomFlags
	and $40
	jp nz,interactionDelete

	ld a,(wLinkPlayingInstrument)
	or a
	ret nz
	ld a,(wTmpcfc0.genericCutscene.state)
	or a
	ret z
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wDisableScreenTransitions),a
	ld a,90
	call setScreenShakeCounter

	ld e,Interaction.state
	ld a,$01
	ld (de),a

	ld a,SNDCTRL_MEDIUM_FADEOUT
	jp playSound

@state1:
	ld a,(wScreenShakeCounterY)
	or a
	ret nz

	call getThisRoomFlags
	set 6,(hl)
	ld a,CUTSCENE_S_VOLCANO_ERUPTING
	ld (wCutsceneTrigger),a
	call fadeoutToWhite
	jp interactionDelete

;;
subrosianAtD8_getNumEssences:
	ld a,(wEssencesObtained)
	jp getNumSetBits


; ==============================================================================
; INTERACID_INGO
; ==============================================================================
interactionCode57:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
--
	ld h,d
	ld l,$44
	ld (hl),$01
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.ingoScript_tradingVase
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
	jp @preventLinkFromPassing
@state1:
	call @func_7d5a
	call interactionRunScript
	jp npcFaceLinkAndAnimate
@state2:
	call interactionRunScript
	jr c,--
	jr @func7d84
@func_7d5a:
	ld a,($d00b)
	sub $20
	ret nc
	ld a,$22
	ld ($d00b),a
	ld a,($cc77)
	or a
	ret nz
	ld a,$80
	ld ($cca4),a
	ld a,$01
	ld ($cc02),a
	ld hl,mainScripts.ingoScript_LinkApproachingVases
	call interactionSetScript
	ld h,d
	ld l,$44
	ld (hl),$02
	inc l
	ld (hl),$00
	pop bc
	ret
@func7d84:
	call interactionAnimate
	ld e,$7e
	ld a,(de)
	or a
	jr z,@preventLinkFromPassing
	ld e,$60
	ld a,(de)
	cp $0d
	jr nz,@preventLinkFromPassing
	ld e,$60
	ld a,$01
	ld (de),a
@preventLinkFromPassing:
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; ==============================================================================
; INTERACID_GURU_GURU
; ==============================================================================
interactionCode58:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	ld h,d
	ld l,$44
	ld (hl),$01
	ld l,$7c
	ld (hl),$01
	ld l,$77
	ld (hl),$78
	ld l,$7b
	ld (hl),$01
	ld l,$79
	ld (hl),$01
	ld l,$50
	ld (hl),$0f
	call func_7e20
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.guruGuruScript
	call interactionSetScript
	jp func_7ddc
@state1:
	call interactionRunScript
	call func_7deb
	jr func_7ddc
func_7ddc:
	ld e,$79
	ld a,(de)
	or a
	jr z,+
	call interactionAnimate
+
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
func_7deb:
	ld e,$78
	ld a,(de)
	rst_jumpTable
	.dw @var38_00
	.dw func_7e38
@var38_00:
	ld e,$7b
	ld a,(de)
	or a
	jr z,func_7e0f
	ld h,d
	ld l,$77
	dec (hl)
	ret nz
	ld (hl),$78
	ld l,$49
	ld a,(hl)
	xor $10
	ld (hl),a
	ld l,$7a
	ld a,(hl)
	xor $02
	ld (hl),a
	jp interactionSetAnimation
func_7e0f:
	ld h,d
	ld l,$78
	ld (hl),$01
	ld l,$79
	ld (hl),$00
	ld a,($d00d)
	ld l,$4d
	cp (hl)
	jr nc,func_7e2c
func_7e20:
	ld l,$49
	ld (hl),$18
	ld l,$7a
	ld a,$03
	ld (hl),a
	jp interactionSetAnimation
func_7e2c:
	ld l,$49
	ld (hl),$08
	ld l,$7a
	ld a,$01
	ld (hl),a
	jp interactionSetAnimation
func_7e38:
	ld e,$7b
	ld a,(de)
	or a
	ret z
	ld h,d
	ld l,$78
	ld (hl),$00
	ld l,$79
	ld (hl),$01
	ld l,$77
	ld (hl),$78
	ret


; ==============================================================================
; INTERACID_LOST_WOODS_SWORD
; ==============================================================================
interactionCode59:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	ld a,TREASURE_SWORD
	call checkTreasureObtained
	jr nc,+
	cp $03
	jp nc,interactionDelete
	sub $01
	ld e,$42
	ld (de),a
+
	call interactionInitGraphics
	call interactionIncState
	call objectSetVisible
	call objectSetVisible80
	ld hl,mainScripts.lostWoodsSwordScript
	call interactionSetScript
	ld a,$4d
	call playSound
	ldbc INTERACID_SPARKLE $04
	jp objectCreateInteraction
@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret


; ==============================================================================
; INTERACID_BLAINO_SCRIPT
; ==============================================================================
interactionCode5a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw interactionRunScript

@state0:
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld a,>TX_2300
	call interactionSetHighTextIndex
	ld hl,mainScripts.blainoScript
	call interactionSetScript

@state1:
	call interactionRunScript
	ret nc
	ld h,d
	ld l,Interaction.enabled
	ld (hl),$01
	ld l,Interaction.state
	ld (hl),$02
	ld a,$02
	ld ($cced),a
	xor a
	ld ($ccec),a
	inc a
	ld (wInBoxingMatch),a
	ret

@state2:
	call @checkFightDone
	ret z
	call restartSound
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.state
	ld (hl),$03
	ld a,$03
	ld ($cced),a
	xor a
	ld (wLinkPlayingInstrument),a
	call resetLinkInvincibility
	xor a
	ld (wInBoxingMatch),a
	ld hl,mainScripts.blainoFightDoneScript
	call interactionSetScript
	jp interactionRunScript

@checkFightDone:
	ld hl,wInventoryB
	ld a,(wLinkPlayingInstrument)
	or (hl)
	inc l
	or (hl)
	ld a,$03
	; equipped items (cheated)
	jr nz,+
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call @checkOutsideRing
	; won
	ld a,$01
	jr nc,+
	ld hl,w1Link.yh
	call @checkOutsideRing
	; lost
	ld a,$02
	jr nc,+
	xor a
+
	ld ($ccec),a
	or a
	ret

@checkOutsideRing:
	ldi a,(hl)
	sub $16
	cp $4c
	ret nc
	inc l
	ld a,(hl)
	sub $22
	cp $5c
	ret


; ==============================================================================
; INTERACID_LOST_WOODS_DEKU_SCRUB
; ==============================================================================
interactionCode5b:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	ld a,$86
	call loadPaletteHeader
	call interactionSetAlwaysUpdateBit
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld h,d
	ld l,$44
	ld (hl),$01
	ld l,$49
	ld (hl),$04
	ld hl,mainScripts.lostWoodsDekuScrubScript
	call interactionSetScript
@state1:
	call interactionRunScript
	call @func_7f55
	jp interactionAnimateAsNpc
@func_7f55:
	ld e,$79
	ld a,(de)
	rst_jumpTable
	.dw @@var39_00
	.dw @@var39_01
@@var39_00:
	ld h,d
	ld l,$77
	ld a,(hl)
	cp $04
	ret nz
	ld l,$79
	ld (hl),$01
	ld a,$3d
	jp playSound
@@var39_01:
	ret


; ==============================================================================
; INTERACID_LAVA_SOUP_SUBROSIAN
; ==============================================================================
interactionCode5c:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,$49
	ld (hl),$04
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.lavaSoupSubrosianScript
	call interactionSetScript
@state1:
	call interactionRunScript
	ld e,$7f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; ==============================================================================
; INTERACID_TRADE_ITEM
; ==============================================================================
interactionCode5d:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	ld a,$06
	call objectSetCollideRadius
	ld l,$44
	inc (hl)
	jp objectSetVisiblec0
@state1:
	ld e,$42
	ld a,(de)
	ld hl,$cfde
	call checkFlag
	jp nz,interactionDelete
	jp objectPreventLinkFromPassing

.ends
