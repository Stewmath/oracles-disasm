; ==============================================================================
; INTERACID_USED_ROD_OF_SEASONS
; ==============================================================================
interactionCode15:
	ld a,(wMenuDisabled)		; $5138
	ld b,a			; $513b
	ld a,(wLinkDeathTrigger)		; $513c
	or b			; $513f
	jr nz,+			; $5140
	ld a,(wActiveGroup)		; $5142
	or a			; $5145
	jr nz,+			; $5146
	ld hl,wObtainedSeasons		; $5148
	ld a,(hl)		; $514b
	add a			; $514c
	jr z,+			; $514d
	ld a,(wRoomStateModifier)		; $514f
-
	inc a			; $5152
	and $03			; $5153
	ld b,a			; $5155
	call checkFlag		; $5156
	ld a,b			; $5159
	jr z,-			; $515a
	call setSeason		; $515c
	ld a,SND_ENERGYTHING		; $515f
	call playSound		; $5161
	ld a,$02		; $5164
	ld (wPaletteThread_updateRate),a		; $5166
+
	jp interactionDelete		; $5169


; ==============================================================================
; INTERACID_S_SPECIAL_WARP
; ==============================================================================
interactionCode1f:
	ld e,$42		; $516c
	ld a,(de)		; $516e
	rst_jumpTable			; $516f
	.dw _specialWarp_subid0
	.dw _specialWarp_subid1
	.dw _specialWarp_subid2
	.dw _specialWarp_subid3
	.dw _specialWarp_subid4
	.dw _specialWarp_subid5
	.dw _specialWarp_subid6
	.dw _specialWarp_subid7
	.dw _specialWarp_subid8
	.dw _specialWarp_subid9
	.dw _specialWarp_subidA
	.dw _specialWarp_subidB
	.dw _specialWarp_subidC
	.dw _specialWarp_subidD

_specialWarp_subid0:
_specialWarp_subid1:
	call checkInteractionState		; $518c
	jr nz,+			; $518f
	ld a,($cd00)		; $5191
	and $01			; $5194
	ret z			; $5196
	ld a,$01		; $5197
	ld (de),a		; $5199
	call objectGetTileAtPosition		; $519a
	ld (hl),$20		; $519d
+
	ld a,($cc77)		; $519f
	or a			; $51a2
	ret nz			; $51a3
	call objectGetTileAtPosition		; $51a4
	ld a,($ccb3)		; $51a7
	cp l			; $51aa
	ret nz			; $51ab
	ld (hl),$eb		; $51ac
	ld a,$81		; $51ae
	ld ($cca4),a		; $51b0
	jp interactionDelete		; $51b3

_specialWarp_subid2:
_specialWarp_subid3:
_specialWarp_subid4:
	ld e,$44		; $51b6
	ld a,(de)		; $51b8
	rst_jumpTable			; $51b9
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld e,$42		; $51c0
	ld a,(de)		; $51c2
	sub $02			; $51c3
	add a			; $51c5
	ld hl,@table_51e5		; $51c6
	rst_addDoubleIndex			; $51c9
	ld e,$70		; $51ca
	ld b,$03		; $51cc
	call copyMemory		; $51ce
	ld e,$67		; $51d1
	ldi a,(hl)		; $51d3
	ld (de),a		; $51d4
	dec e			; $51d5
	ld a,$0a		; $51d6
	ld (de),a		; $51d8
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $51d9
	ld a,$01		; $51dc
	jr nc,+			; $51de
	inc a			; $51e0
+
	ld e,$44		; $51e1
	ld (de),a		; $51e3
	ret			; $51e4

@table_51e5:
	.db $05 $bc $97 $10
	.db $05 $bd $97 $18
	.db $05 $0d $97 $18

	.db $00 $2e $61 $00
	.db $00 $2e $75 $00
	.db $00 $5a $54 $00

@state1:
	ld a,d			; $51fd
	ld ($ccaa),a		; $51fe
	ld a,($cc48)		; $5201
	cp $d1			; $5204
	ret nz			; $5206
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $5207
	ret nc			; $520a
	xor a			; $520b
	ld ($cc65),a		; $520c
@setWarpVariables:
	ld h,d			; $520f
	ld l,$70		; $5210
	ldi a,(hl)		; $5212
	ld (wWarpDestGroup),a		; $5213
	ldi a,(hl)		; $5216
	ld (wWarpDestRoom),a		; $5217
	ld a,(hl)		; $521a
	ld (wWarpDestPos),a		; $521b
	ld a,$03		; $521e
	ld (wWarpTransition2),a		; $5220
	ld a,$01		; $5223
	ld (wScrollMode),a		; $5225
	jp interactionDelete		; $5228

@state2:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $522b
	ret c			; $522e
	ld e,$44		; $522f
	ld a,$01		; $5231
	ld (de),a		; $5233
	ret			; $5234

_specialWarp_subid5:
_specialWarp_subid6:
_specialWarp_subid7:
	ld e,$44		; $5235
	ld a,(de)		; $5237
	rst_jumpTable			; $5238
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call _specialWarp_subid4@state0		; $523f
	xor a			; $5242
	ld (wActiveMusic),a		; $5243
	jp interactionSetAlwaysUpdateBit		; $5246
@state1:
@state2:
	ld a,d			; $5249
	ld ($ccab),a		; $524a
	ld a,($cc48)		; $524d
	cp $d1			; $5250
	ret nz			; $5252
	xor a			; $5253
	ld ($ccab),a		; $5254
	ld a,($cd00)		; $5257
	and $01			; $525a
	ret nz			; $525c
	xor a			; $525d
	ld ($cd00),a		; $525e
	ld a,$ff		; $5261
	ld ($cca4),a		; $5263
	ld (wActiveMusic),a		; $5266
	jr _specialWarp_subid4@setWarpVariables		; $5269

_specialWarp_subid8:
_specialWarp_subid9:
_specialWarp_subidA:
_specialWarp_subidB:
_specialWarp_subidC:
	call checkInteractionState		; $526b
	jr nz,+			; $526e
	ld a,$01		; $5270
	ld (de),a		; $5272
	ld a,$02		; $5273
	call objectSetCollideRadius		; $5275
+
	ld a,($cc78)		; $5278
	rlca			; $527b
	ret nc			; $527c
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $527d
	ret nc			; $5280
	ld e,$42		; $5281
	ld a,(de)		; $5283
	sub $08			; $5284
	ld hl,_table_52a4		; $5286
	rst_addDoubleIndex			; $5289
	ldi a,(hl)		; $528a
	ld (wWarpDestRoom),a		; $528b
	ld a,(hl)		; $528e
	ld (wWarpDestPos),a		; $528f
	ld a,$87		; $5292
	ld (wWarpDestGroup),a		; $5294
	ld a,$01		; $5297
	ld (wWarpTransition),a		; $5299
@fadeoutTransition:
	ld a,$03		; $529c
	ld (wWarpTransition2),a		; $529e
	jp interactionDelete		; $52a1

_table_52a4:
	.db $e0 $02
	.db $e1 $0b
	.db $e4 $02
	.db $e6 $02
	.db $e7 $0d

_specialWarp_subidD:
	call checkInteractionState		; $52ae
	jr nz,+			; $52b1
	ld a,$01		; $52b3
	ld (de),a		; $52b5
	ld a,$02		; $52b6
	call objectSetCollideRadius		; $52b8
+
	ld a,($cc78)		; $52bb
	rlca			; $52be
	ret nc			; $52bf
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $52c0
	ret nc			; $52c3
	ld hl,$cc63		; $52c4
	ld (hl),$85		; $52c7
	inc l			; $52c9
	ld (hl),$12		; $52ca
	inc l			; $52cc
	ld (hl),$05		; $52cd
	inc l			; $52cf
	ld (hl),$29		; $52d0
	jr _specialWarp_subidC@fadeoutTransition		; $52d2


; ==============================================================================
; INTERACID_DUNGEON_SCRIPT
; ==============================================================================
interactionCode20:
	call interactionDeleteAndRetIfEnabled02		; $52d4
	ld e,Interaction.state		; $52d7
	ld a,(de)		; $52d9
	rst_jumpTable			; $52da
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $52e1
	ld (de),a		; $52e3
	xor a			; $52e4
	ld ($cfc1),a		; $52e5
	ld ($cfc2),a		; $52e8

	ld a,(wDungeonIndex)		; $52eb
	cp $ff			; $52ee
	jp z,interactionDelete		; $52f0

	ld hl,@scriptTable		; $52f3
	rst_addDoubleIndex			; $52f6
	ldi a,(hl)		; $52f7
	ld h,(hl)		; $52f8
	ld l,a			; $52f9
	ld e,Interaction.subid		; $52fa
	ld a,(de)		; $52fc
	rst_addDoubleIndex			; $52fd
	ldi a,(hl)		; $52fe
	ld h,(hl)		; $52ff
	ld l,a			; $5300
	call interactionSetScript		; $5301
	jp interactionRunScript		; $5304

@state2:
	call objectPreventLinkFromPassing		; $5307

@state1:
	call interactionRunScript		; $530a
	ret nc			; $530d
	jp interactionDelete		; $530e

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
	.dw dungeonScript_end
	.dw dungeonScript_checkActiveTriggersEq01

@dungeon1:
	.dw dungeonScript_minibossDeath
	.dw dungeonScript_checkActiveTriggersEq01
	.dw dungeonScript_checkActiveTriggersEq01
	.dw dungeonScript_bossDeath

@dungeon2:
	.dw snakesRemainsScript_timerForChestDisappearing
	.dw dungeonScript_minibossDeath
	.dw snakesRemainsScript_bossDeath

@dungeon3:
	.dw poisonMothsLairScript_hallwayTrapRoom
	.dw poisonMothsLairScript_checkStatuePuzzle
	.dw poisonMothsLairScript_minibossDeath
	.dw poisonMothsLairScript_bossDeath
	.dw poisonMothsLairScript_openEssenceDoorIfBossBeat

@dungeon4:
	.dw dancingDragonScript_spawnStairsToB1
	.dw dancingDragonScript_torchesHallway
	.dw dancingDragonScript_torchesHallway
	.dw dancingDragonScript_spawnBossKey
	.dw dungeonScript_bossDeath
	.dw dungeonScript_minibossDeath
	.dw dancingDragonScript_pushingPotsRoom
	.dw dancingDragonScript_bridgeInB2

@dungeon5:
	.dw unicornsCaveScript_spawnBossKey
	.dw unicornsCaveScript_dropMagnetBallAfterDarknutKill
	.dw dungeonScript_minibossDeath
	.dw dungeonScript_bossDeath

@dungeon6:
	.dw dungeonScript_spawnKeyOnMagnetBallToButton
	.dw ancientRuinsScript_spawnStaircaseUp1FTopLeftRoom
	.dw ancientRuinsScript_spawnStaircaseUp1FTopMiddleRoom
	.dw script4c50
	.dw ancientRuinsScript_5TorchesMovingPlatformsRoom
	.dw ancientRuinsScript_roomWithJustRopesSpawningButton
	.dw ancientRuinsScript_UShapePitToMagicBoomerangOrb
	.dw dungeonScript_minibossDeath
	.dw ancientRuinsScript_randomButtonRoom
	.dw ancientRuinsScript_4F3OrbsRoom
	.dw ancientRuinsScript_spawnStairsLeadingToBoss
	.dw ancientRuinsScript_spawnHeartContainerAndStairsUp
	.dw ancientRuinsScript_1FTopRightTrapButtonRoom
	.dw ancientRuinsScript_crystalTrapRoom
	.dw ancientRuinsScript_spawnChestAfterCrystalTrapRoom

@dungeon7:
	.dw explorersCryptScript_4OrbTrampoline
	.dw explorersCryptScript_magunesuTrampoline
	.dw dungeonScript_minibossDeath
	.dw dungeonScript_bossDeath
	.dw script4d05
	.dw explorersCryptScript_randomlyPlaceNonEnemyArmos
	.dw dungeonScript_checkIfMagnetBallOnButton
	.dw explorersCryptScript_1stPoeSisterRoom
	.dw explorersCryptScript_2ndPoeSisterRoom
	.dw explorersCryptScript_4FiresRoom_1
	.dw explorersCryptScript_4FiresRoom_2
	.dw explorersCryptScript_darknutBridge
	.dw explorersCryptScript_roomLeftOfRandomArmosRoom
	.dw explorersCryptScript_dropKeyDownAFloor
	.dw explorersCryptScript_keyDroppedFromAbove

@dungeon8:
	.dw swordAndShieldMazeScript_verticalBridgeUnlockedByOrb
	.dw swordAndShieldMazeScript_verticalBridgeInLava
	.dw swordAndShieldMazeScript_armosBlockingStairs
	.dw dungeonScript_spawnKeyOnMagnetBallToButton
	.dw swordAndShieldMazeScript_7torchesAfterMiniboss
	.dw swordAndShieldMazeScript_spawnFireKeeseAtLavaHoles
	.dw swordAndShieldMazeScript_pushableIceBlocks
	.dw dungeonScript_minibossDeath
	.dw dungeonScript_bossDeath
	.dw swordAndShieldMazeScript_horizontalBridgeByMoldorms
	.dw swordAndShieldMazeScript_tripleEyesByMiniboss
	.dw swordAndShieldMazeScript_tripleEyesNearStart

@dungeon9:
	.dw onoxsCastleScript_setFlagOnAllEnemiesDefeated
	.dw onoxsCastleScript_resetRoomFlagsOnDungeonStart

@dungeonA:
@dungeonB:
	.dw dungeonScript_spawnKeyOnMagnetBallToButton
	.dw dungeonScript_checkActiveTriggersEq01
	.dw herosCaveScript_spawnChestOnTorchLit
	.dw dungeonScript_checkIfMagnetBallOnButton
	.dw herosCaveScript_check6OrbsHit
	.dw herosCaveScript_allButtonsPressedAndEnemiesDefeated
	.dw herosCaveScript_spawnChestOn2TorchesLit


; ==============================================================================
; INTERACID_GANRLED_KEYHOLE
; ==============================================================================
interactionCode21:
	ld e,$44		; $53c3
	ld a,(de)		; $53c5
	rst_jumpTable			; $53c6
	.dw @state0
	.dw interactionRunScript
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	call getThisRoomFlags		; $53d1
	bit 7,a			; $53d4
	jp nz,interactionDelete		; $53d6
	ld e,$44		; $53d9
	ld a,$01		; $53db
	ld (de),a		; $53dd
	ld a,$01		; $53de
	ld ($ccaa),a		; $53e0
	call _func_5469		; $53e3
	ld hl,gnarledKeyholeScript		; $53e6
	jp interactionSetScript		; $53e9
@state2:
	call interactionIncState		; $53ec
	ld l,$46		; $53ef
	ld (hl),$1e		; $53f1
	call setLinkForceStateToState08		; $53f3
	ld a,($cca4)		; $53f6
	or $80			; $53f9
	ld ($cca4),a		; $53fb
	call _func_545d		; $53fe
@state3:
	call _func_54ae		; $5401
	call interactionDecCounter1		; $5404
	jr nz,_func_545d	; $5407
	ld l,$47		; $5409
	ld a,(hl)		; $540b
	cp $04			; $540c
	jr nc,+			; $540e
	inc (hl)		; $5410
	ld a,(hl)		; $5411
	call _func_549d		; $5412
	ld a,$82		; $5415
	call playSound		; $5417
	ld e,$47		; $541a
	ld a,(de)		; $541c
	ld hl,@table_542d		; $541d
	rst_addDoubleIndex			; $5420
	dec e			; $5421
	ldi a,(hl)		; $5422
	ld (de),a		; $5423
	ld a,(hl)		; $5424
	or a			; $5425
	jr z,_func_5463	; $5426
+
	ld l,$44		; $5428
	inc (hl)		; $542a
	jr _func_5463		; $542b
@table_542d:
	; counter1
	.db $1e $00
	.db $3c $00
	.db $2d $00
	.db $28 $00
	.db $23 $00
@state4:
	ld a,$09		; $5437
	ld hl,_table_5482		; $5439
	ld bc,_table_5494		; $543c
	call _func_5471		; $543f
	xor a			; $5442
	ld ($ccaa),a		; $5443
	ld ($cca4),a		; $5446
	ld ($cc02),a		; $5449
	ld a,$4d		; $544c
	call playSound		; $544e
	ld a,($cc62)		; $5451
	ld (wActiveMusic),a		; $5454
	call playSound		; $5457
	jp interactionDelete		; $545a

_func_545d:
	ld a,$0f		; $545d
	ld (wScreenShakeCounterX),a		; $545f
	ret			; $5462

_func_5463:
	ld a,$04		; $5463
	ld (wScreenShakeCounterY),a		; $5465
	ret			; $5468

_func_5469:
	ld a,$09		; $5469
	ld hl,_table_5482		; $546b
	ld bc,_table_548b		; $546e
_func_5471:
	ld d,>wRoomCollisions		; $5471
	ld e,a			; $5473
-
	push de			; $5474
	ldi a,(hl)		; $5475
	ld e,a			; $5476
	ld a,(bc)		; $5477
	inc bc			; $5478
	ld (de),a		; $5479
	pop de			; $547a
	dec e			; $547b
	jr nz,-			; $547c
	ldh a,(<hActiveObject)	; $547e
	ld d,a			; $5480
	ret			; $5481
_table_5482:
	.db $23 $24 $25
	.db $33 $34 $35
	.db $43 $44 $45
_table_548b:
	; initial collisions
	.db $00 $00 $00
	.db $00 $00 $00
	.db $04 $0c $08
_table_5494:
	; collisions after rising
	.db $01 $03 $02
	.db $0f $0f $0f
	.db $0f $0c $0f
_func_549d:
	ld hl,_table_54a9		; $549d
	rst_addAToHl			; $54a0
	ld a,(hl)		; $54a1
	call uniqueGfxFunc_380b		; $54a2
	ldh a,(<hActiveObject)	; $54a5
	ld d,a			; $54a7
	ret			; $54a8
_table_54a9:
	.db $20 $21 $22 $23 $04
_func_54ae:
	ld a,(wFrameCounter)		; $54ae
	and $01			; $54b1
	ret nz			; $54b3
	call getRandomNumber_noPreserveVars		; $54b4
	ld e,a			; $54b7
	call getFreeInteractionSlot		; $54b8
	ret nz			; $54bb
	ld (hl),INTERACID_4b		; $54bc
	inc l			; $54be
	ld a,(wFrameCounter)		; $54bf
	and $06			; $54c2
	rrca			; $54c4
	ld bc,_table_54e4		; $54c5
	call addAToBc		; $54c8
	ld a,(bc)		; $54cb
	ld (hl),a		; $54cc
	ld l,$4b		; $54cd
	ld a,e			; $54cf
	and $07			; $54d0
	sub $04			; $54d2
	add $48			; $54d4
	ldi (hl),a		; $54d6
	inc l			; $54d7
	ld a,e			; $54d8
	and $f8			; $54d9
	swap a			; $54db
	rlca			; $54dd
	sub $10			; $54de
	add $48			; $54e0
	ld (hl),a		; $54e2
	ret			; $54e3
_table_54e4:
	.db $00 $01 $00 $00


; ==============================================================================
; INTERACID_MAKU_CUTSCENES
; ==============================================================================
interactionCode22:
	ld e,Interaction.state		; $54e8
	ld a,(de)		; $54ea
	rst_jumpTable			; $54eb
	.dw @state0
	.dw @runScript
	.dw @state2
	
@state0:
	ld e,Interaction.subid		; $54f2
	ld a,(de)		; $54f4
	cp $08			; $54f5
	jr z,@outsideTempleOfWinter	; $54f7
	cp $09			; $54f9
	jr z,@haveWinterSeason	; $54fb
	jr nc,@atMakuTreeGate	; $54fd
	call getThisRoomFlags		; $54ff
	and $40			; $5502
	jp nz,interactionDelete		; $5504
	call @func_55f5		; $5507
	jp z,interactionDelete		; $550a
	call returnIfScrollMode01Unset		; $550d
	call @setScript		; $5510
	call interactionRunScript		; $5513
	call interactionRunScript		; $5516
	ld e,Interaction.subid		; $5519
	ld a,(de)		; $551b
	cp $07			; $551c
	jr z,@outsideDungeon8	; $551e
	call setMakuTreeStageAndMapText		; $5520
	jr @runScript		; $5523

@outsideDungeon8:
	ld hl,wMakuMapTextPresent		; $5525
	; You already have the 8th essence
	ld (hl),<TX_1716		; $5528
	jr @runScript		; $552a

@outsideTempleOfWinter:
	call getThisRoomFlags		; $552c
	and $40			; $552f
	jp nz,interactionDelete		; $5531
	ld a,TREASURE_ROD_OF_SEASONS		; $5534
	call checkTreasureObtained		; $5536
	jp nc,interactionDelete		; $5539
	ld a,(wObtainedSeasons)		; $553c
	add a			; $553f
	jp z,interactionDelete		; $5540

@haveWinterSeason:
	call @setScript		; $5543
	call interactionRunScript		; $5546
	call interactionRunScript		; $5549
	call setMakuTreeStageAndMapText		; $554c
	jr @runScript		; $554f

@atMakuTreeGate:
	call getThisRoomFlags		; $5551
	and $80			; $5554
	jp nz,interactionDelete		; $5556
	call @setScript		; $5559
	jr @runScript		; $555c

@setScript:
	ld e,Interaction.state		; $555e
	ld a,$01		; $5560
	ld (de),a		; $5562
	ld e,Interaction.subid		; $5563
	ld a,(de)		; $5565
	ld hl,@scriptTable		; $5566
	rst_addDoubleIndex			; $5569
	ldi a,(hl)		; $556a
	ld h,(hl)		; $556b
	ld l,a			; $556c
	jp interactionSetScript		; $556d

@runScript:
	call interactionRunScript		; $5570
	jp c,interactionDelete		; $5573
	ret			; $5576
	
@state2:
	ld e,Interaction.state2		; $5577
	ld a,(de)		; $5579
	rst_jumpTable			; $557a
	.dw @substate0
	.dw @substate1

@substate0:
	ld hl,@tileChangeTable		; $557f
	ld b,$04		; $5582
-
	ldi a,(hl)		; $5584
	ldh (<hFF8C),a	; $5585
	ldi a,(hl)		; $5587
	ldh (<hFF8F),a	; $5588
	ldi a,(hl)		; $558a
	ldh (<hFF8E),a	; $558b
	ldi a,(hl)		; $558d
	push hl			; $558e
	push bc			; $558f
	call setInterleavedTile		; $5590
	pop bc			; $5593
	pop hl			; $5594
	dec b			; $5595
	jr nz,-			; $5596
	ldh a,(<hActiveObject)	; $5598
	ld d,a			; $559a
	ld e,Interaction.state2		; $559b
	ld a,$01		; $559d
	ld (de),a		; $559f
	ld e,Interaction.counter1		; $55a0
	ld a,$1e		; $55a2
	ld (de),a		; $55a4
	xor a			; $55a5
	call @func_561f		; $55a6
	ld a,$73		; $55a9
	call playSound		; $55ab

@rumble:
	ld a,$06		; $55ae
	call setScreenShakeCounter		; $55b0
	ld a,$70		; $55b3
	jp playSound		; $55b5

@substate1:
	call interactionDecCounter1		; $55b8
	ret nz			; $55bb
	ld hl,@tileChangeTable		; $55bc
	ld b,$04		; $55bf
-
	ldi a,(hl)		; $55c1
	ld c,a			; $55c2
	ld a,(hl)		; $55c3
	push hl			; $55c4
	push bc			; $55c5
	call setTile		; $55c6
	pop bc			; $55c9
	pop hl			; $55ca
	inc hl			; $55cb
	inc hl			; $55cc
	inc hl			; $55cd
	dec b			; $55ce
	jr nz,-			; $55cf
	ld e,Interaction.state		; $55d1
	ld a,$01		; $55d3
	ld (de),a		; $55d5
	xor a			; $55d6
	inc e			; $55d7
	ld (de),a		; $55d8
	ld a,$04		; $55d9
	call @func_561f		; $55db
	ld a,$73		; $55de
	call playSound		; $55e0
	jr @rumble		; $55e3

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
	ld a,TREASURE_ESSENCE		; $55f5
	call checkTreasureObtained		; $55f7
	jr nc,@noEssence	; $55fa
	ld e,Interaction.var3e		; $55fc
	ld (de),a		; $55fe
	call @func_5610		; $55ff
	ld c,a			; $5602
	ld e,Interaction.subid		; $5603
	ld a,(de)		; $5605
	ld hl,bitTable		; $5606
	add l			; $5609
	ld l,a			; $560a
	ld a,c			; $560b
	and (hl)		; $560c
	ret			; $560d
@noEssence:
	xor a			; $560e
	ret			; $560f
	
@func_5610:
	push af			; $5610
	ld hl,wc6e5		; $5611
	ld (hl),$00		; $5614
-
	add a			; $5616
	jr nc,+			; $5617
	inc (hl)		; $5619
+
	or a			; $561a
	jr nz,-			; $561b
	pop af			; $561d
	ret			; $561e


@func_561f:
	ld bc,@table_563f		; $561f
	call addDoubleIndexToBc		; $5622
	ld a,$04		; $5625
-
	ldh (<hFF8B),a	; $5627
	call getFreeInteractionSlot		; $5629
	ret nz			; $562c
	ld (hl),INTERACID_PUFF		; $562d
	ld l,Interaction.yh		; $562f
	ld a,(bc)		; $5631
	ld (hl),a		; $5632
	inc bc			; $5633
	ld l,Interaction.xh		; $5634
	ld a,(bc)		; $5636
	ld (hl),a		; $5637
	inc bc			; $5638
	ldh a,(<hFF8B)	; $5639
	dec a			; $563b
	jr nz,-			; $563c
	ret			; $563e

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
	.dw makuTreeScript_remoteCutscene
	.dw makuTreeScript_remoteCutscene
	.dw makuTreeScript_remoteCutscene
	.dw makuTreeScript_remoteCutscene
	.dw makuTreeScript_remoteCutscene
	.dw makuTreeScript_remoteCutscene
	.dw makuTreeScript_remoteCutscene
	.dw makuTreeScript_remoteCutscene
	.dw makuTreeScript_remoteCutscene
	.dw makuTreeScript_remoteCutsceneDontSetRoomFlag
	.dw makuTreeScript_gateHit


; ==============================================================================
; INTERACID_SEASON_SPIRITS_SCRIPTS
; ==============================================================================
interactionCode23:
	ld e,$45		; $5665
	ld a,(de)		; $5667
	rst_jumpTable			; $5668
	.dw @substate0
	.dw @substate1
@substate0:
	ld a,$01		; $566d
	ld (de),a		; $566f
	ld a,>TX_0800		; $5670
	call interactionSetHighTextIndex		; $5672
	ld e,$42		; $5675
	ld a,(de)		; $5677
	ld b,a			; $5678
	swap a			; $5679
	and $0f			; $567b
	ld e,$43		; $567d
	ld (de),a		; $567f
	ld hl,_table_56a5		; $5680
	rst_addDoubleIndex			; $5683
	ldi a,(hl)		; $5684
	ld h,(hl)		; $5685
	ld l,a			; $5686
	ld a,b			; $5687
	and $0f			; $5688
	rst_addDoubleIndex			; $568a
	ldi a,(hl)		; $568b
	ld h,(hl)		; $568c
	ld l,a			; $568d
	call interactionSetScript		; $568e
	ld e,$7e		; $5691
	ld a,(wc6e5)		; $5693
	cp $09			; $5696
	ld a,$00		; $5698
	jr c,+			; $569a
	inc a			; $569c
+
	ld (de),a		; $569d
@substate1:
	call interactionRunScript		; $569e
	jp c,interactionDelete		; $56a1
	ret			; $56a4

_table_56a5:
	.dw _table_56af
	.dw _table_56af
	.dw _table_56af
	.dw _table_56af
	.dw _table_56b3

_table_56af:
	.dw seasonsSpiritsScript_winterTempleOrbBridge
	.dw seasonsSpiritsScript_spiritStatue

_table_56b3:
	.dw seasonsSpiritsScript_enteringTempleArea


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
	ld e,$44		; $56b5
	ld a,(de)		; $56b7
	rst_jumpTable			; $56b8
	.dw _miscNPC_state0
	.dw _miscNPC_state1
_miscNPC_state0:
	ld a,$01		; $56bd
	ld (de),a		; $56bf
	ld h,d			; $56c0
	ld l,$42		; $56c1
	ldi a,(hl)		; $56c3
	bit 7,a			; $56c4
	jr z,+			; $56c6
	; bit 7 in subid checked for in state1
	ldd (hl),a		; $56c8
	and $7f			; $56c9
	ld (hl),a		; $56cb
+
	call _checkHoronVillageNPCShouldBeSeen		; $56cc
	jr nz,+			; $56cf
	jp nc,interactionDelete		; $56d1
	jr ++			; $56d4
+
	call getSunkenCityNPCVisibleSubId		; $56d6
	jr nz,+++		; $56d9
	ld e,$42		; $56db
	ld a,(de)		; $56dd
	cp b			; $56de
	jp nz,interactionDelete		; $56df
++
	ld e,$42		; $56e2
	ld a,b			; $56e4
	ld (de),a		; $56e5
+++
	call interactionInitGraphics		; $56e6
	ld e,$41		; $56e9
	ld a,(de)		; $56eb
	cp INTERACID_MAYORS_HOUSE_NPC			; $56ec
	jr nz,+			; $56ee
	call _checkMayorsHouseNPCshouldBeSeen		; $56f0
	jp z,interactionDelete		; $56f3
+
	sub $24			; $56f6
	ld hl,_miscNPC_scriptTable		; $56f8
	rst_addDoubleIndex			; $56fb
	ldi a,(hl)		; $56fc
	ld h,(hl)		; $56fd
	ld l,a			; $56fe
	ld e,$42		; $56ff
	ld a,(de)		; $5701
	rst_addDoubleIndex			; $5702
	ldi a,(hl)		; $5703
	ld h,(hl)		; $5704
	ld l,a			; $5705
	call interactionSetScript		; $5706
	ld e,$41		; $5709
	ld a,(de)		; $570b
	cp INTERACID_DUNGEON_WISE_OLD_MAN			; $570c
	jp z,_dungeonWiseOldMan_textLookup		; $570e
	cp INTERACID_MR_WRITE			; $5711
	jp z,_mrWrite_spawnLightableTorch		; $5713
	cp INTERACID_BATHING_SUBROSIANS			; $5716
	call z,_func_572c		; $5718
	ld e,$41		; $571b
	ld a,(de)		; $571d
	cp INTERACID_MASTER_DIVERS_SON			; $571e
	call z,_func_572c		; $5720
_func_5723:
	xor a			; $5723
	ld h,d			; $5724
	ld l,$78		; $5725
	ldi (hl),a		; $5727
	ld (hl),a		; $5728
	jp interactionAnimateAsNpc		; $5729

_func_572c:
	call interactionRunScript		; $572c
	jp interactionRunScript		; $572f

_mrWrite_spawnLightableTorch:
	call getThisRoomFlags		; $5732
	and $40			; $5735
	jr z,+			; $5737
	jp _func_5723		; $5739
+
	call getFreePartSlot		; $573c
	jr nz,+			; $573f
	ld (hl),PARTID_LIGHTABLE_TORCH		; $5741
	ld l,$cb		; $5743
	ld (hl),$38		; $5745
	ld l,$cd		; $5747
	ld (hl),$68		; $5749
+
	jp _func_5723		; $574b

_dungeonWiseOldMan_textLookup:
	ld e,$42		; $574e
	ld a,(de)		; $5750
	or a			; $5751
	jr nz,@ret	; $5752
	ld a,(wDungeonIndex)		; $5754
	dec a			; $5757
	bit 7,a			; $5758
	jr z,+			; $575a
	xor a			; $575c
+
	ld hl,@textLookup		; $575d
	rst_addAToHl			; $5760
	ld e,$72		; $5761
	ld a,(hl)		; $5763
	ld (de),a		; $5764
	inc e			; $5765
	ld a,>TX_3300		; $5766
	ld (de),a		; $5768
@ret:
	jp _func_5723		; $5769
@textLookup:
	.db <TX_3300 $00 $00 <TX_3301
	.db $00 $00 $00 $00
	.db $00 $00 <TX_3302

;;
; param[out]	zflag	set if NPC should not be seen
_checkMayorsHouseNPCshouldBeSeen:
	; mayor disappears if unlinked game beat
	; or seen villagers, but not zelda kidnapped
	ld e,$42		; $5777
	ld a,(de)		; $5779
	ld b,a			; $577a
	call checkIsLinkedGame		; $577b
	jr z,@unlinked	; $577e
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN		; $5780
	call checkGlobalFlag		; $5782
	jr z,@xor01IfMayorElsexorA	; $5785
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN		; $5787
	call checkGlobalFlag		; $5789
	jr z,@xorARet		; $578c
	jr @xor01IfMayorElsexorA		; $578e
@unlinked:
	ld a,GLOBALFLAG_FINISHEDGAME		; $5790
	call checkGlobalFlag		; $5792
	jr z,@xor01IfMayorElsexorA	; $5795
	ld a,b			; $5797
	cp $03			; $5798
	jr nz,@xorARet		; $579a
	; unlinked game beat - woman in mayor's house
	jr @xor01	; $579c
@xor01IfMayorElsexorA:
	ld a,b			; $579e
	cp $03			; $579f
	jr z,@xorARet		; $57a1
@xor01:
	ld e,$41		; $57a3
	ld a,(de)		; $57a5
	xor $01			; $57a6
	ret			; $57a8
@xorARet:
	xor a			; $57a9
	ret			; $57aa

_miscNPC_state1:
	call interactionRunScript		; $57ab
	ld e,$43		; $57ae
	ld a,(de)		; $57b0
	and $80			; $57b1
	jp nz,interactionAnimateAsNpc		; $57b3
	jp npcFaceLinkAndAnimate		; $57b6

_checkHoronVillageNPCShouldBeSeen:
	ld e,$41		; $57b9
	ld a,(de)		; $57bb
	ld b,$00		; $57bc
	cp INTERACID_FICKLE_LADY			; $57be
	jr z,checkHoronVillageNPCShouldBeSeen_body@main	; $57c0
	inc b			; $57c2
	cp INTERACID_FICKLE_MAN			; $57c3
	jr nz,checkHoronVillageNPCShouldBeSeen_body	; $57c5
	ld e,$42		; $57c7
	ld a,(de)		; $57c9
	cp $06			; $57ca
	jr nz,checkHoronVillageNPCShouldBeSeen_body@main	; $57cc
	ld b,$0b		; $57ce
	jr checkHoronVillageNPCShouldBeSeen_body@scf		; $57d0

;;
; param[out]	cflag	set if NPC is conditional and should be seen at current stage of the game
; param[out]	zflag	unset if NPC is non-conditional
checkHoronVillageNPCShouldBeSeen_body:
	; non interactioncode2d/37 - b = $01
	inc b			; $57d2
	cp $3c			; $57d3
	jr z,@main			; $57d5
	inc b			; $57d7
	cp $3d			; $57d8
	ret nz			; $57da
@main:
	; interactioncode2d - b = $00
	; interactioncode37 (except in advance shop) - b = $01
	; interactioncode3c - b = $02
	; interactioncode3d - b = $03
	; from interactioncode3e - b = $05/$06/$07 ?
	; from interactioncode80 - b = $07
	ld a,b			; $57db
	ld hl,_conditionalNPCLookupTable		; $57dc
	rst_addDoubleIndex			; $57df
	ldi a,(hl)		; $57e0
	ld h,(hl)		; $57e1
	ld l,a			; $57e2
	push hl			; $57e3
	call checkNPCStage		; $57e4
	pop hl			; $57e7
	ld e,$42		; $57e8
	ld a,(de)		; $57ea
	rst_addDoubleIndex			; $57eb
	ldi a,(hl)		; $57ec
	ld h,(hl)		; $57ed
	ld l,a			; $57ee
-
	ldi a,(hl)		; $57ef
	or a			; $57f0
	ret z			; $57f1
	dec a			; $57f2
	cp b			; $57f3
	jr nz,-			; $57f4
@scf:
	; interactioncode37 in advance shop - b = $0b
	scf			; $57f6
	ret			; $57f7

;;
; param[out]	b	$0a if game finished
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
	ld a,GLOBALFLAG_FINISHEDGAME		; $57f8
	call checkGlobalFlag		; $57fa
	ld b,$0a		; $57fd
	jr nz,+			; $57ff
	ld a,TREASURE_ESSENCE		; $5801
	call checkTreasureObtained		; $5803
	jr c,@essenceGotten		; $5806
	ld a,GLOBALFLAG_S_18		; $5808
	call checkGlobalFlag		; $580a
	ld b,$01		; $580d
	jr nz,+			; $580f
	ld b,$00		; $5811
+
	xor a			; $5813
	ret			; $5814
@essenceGotten:
	ld c,a			; $5815
	call getNumSetBits		; $5816
	ldh (<hFF8B),a	; $5819
	ld a,c			; $581b
	call getHighestSetBit		; $581c
	ld c,a			; $581f
	call checkIsLinkedGame		; $5820
	jr nz,@linkedGameCheck	; $5823
@regularCheck:
	ld a,c			; $5825
	ld b,$05		; $5826
	cp $07			; $5828
	ret nc			; $582a
	dec b			; $582b
	ldh a,(<hFF8B)	; $582c
	cp $05			; $582e
	ret nc			; $5830
	ld a,c			; $5831
	dec b			; $5832
	cp $01			; $5833
	ret nc			; $5835
	dec b			; $5836
	ret			; $5837
@linkedGameCheck:
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN		; $5838
	call checkGlobalFlag		; $583a
	ld b,$08		; $583d
	ret nz			; $583f
	ld a,GLOBALFLAG_GOT_MAKU_SEED		; $5840
	call checkGlobalFlag		; $5842
	ld b,$07		; $5845
	ret nz			; $5847
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN		; $5848
	call checkGlobalFlag		; $584a
	ld b,$06		; $584d
	ret nz			; $584f

	ld a,c			; $5850
	cp $00			; $5851
	jr z,@regularCheck	; $5853
	ldh a,(<hFF8B)	; $5855
	cp $05			; $5857
	jr nc,@regularCheck	; $5859
	ld b,$09		; $585b
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE		; $585d
	call checkGlobalFlag		; $585f
	ret z			; $5862
	ld b,$03		; $5863
	ret			; $5865

;;
; param[out]	zflag	unset if not interactioncode36/39
; param[out]	b	$04 if game finished
;			$03 if zelda kidnapped seen
;			$02 if 8th essence gotten
;			$01 if 4th essence gotten
;			$00 if none of the above
getSunkenCityNPCVisibleSubId:
	; returns b = $04 if game finished
	; b = $03 is zelda kidnapped seen
	; b = $02 if 8th essence gotten
	; b = $01 if 4th essence gotten
	; b = $00 if no essences, or none of the above
	; a = $ff if not interactioncode36 or 39
	ld e,$41		; $5866
	ld a,(de)		; $5868
	cp INTERACID_MASTER_DIVERS_SON			; $5869
	jr z,@main		; $586b
	cp INTERACID_TREASURE_HUNTER			; $586d
	jr z,@main		; $586f
	ld a,$ff		; $5871
	ret			; $5873
@main:
	ld a,GLOBALFLAG_FINISHEDGAME		; $5874
	call checkGlobalFlag		; $5876
	ld b,$04		; $5879
	jr nz,@xorARet		; $587b
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN		; $587d
	call checkGlobalFlag		; $587f
	ld b,$03		; $5882
	jr nz,@xorARet		; $5884
	ld a,TREASURE_ESSENCE		; $5886
	call checkTreasureObtained		; $5888
	ld b,$00		; $588b
	jr nc,@xorARet		; $588d
	ld c,a			; $588f
	call checkIsLinkedGame		; $5890
	jr z,+			; $5893
+
	ld a,c			; $5895
	call getHighestSetBit		; $5896
	ld b,$02		; $5899
	cp $07			; $589b
	ret nc			; $589d
	dec b			; $589e
	ld a,c			; $589f
	and $08			; $58a0
	jr nz,@xorARet		; $58a2
	dec b			; $58a4
@xorARet:
	xor a			; $58a5
	ret			; $58a6

_conditionalNPCLookupTable:
	.dw @fickleLady
	.dw @fickleMan
	.dw @oldLadyFarmer
	.dw @fountainOldMan
	.dw _table_5919
	.dw _table_5902
	.dw _table_58f4
	.dw _table_5933

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
_table_58f4:
	.dw __table_58f6

__table_58f6:
	.db $01 $02 $03 $04 $0a $05 $06 $07
	.db $08 $09 $0b $00

_table_5902:
	.dw __table_590a
	.dw __table_590d
	.dw __table_5914
	.dw __table_5917

__table_590a:
	.db $01 $02 $00

__table_590d:
	.db $03 $04 $0a $05 $06 $0b $00

__table_5914:
	.db $07 $08 $00

__table_5917:
	.db $09 $00

_table_5919:
	.dw __table_5923
	.dw __table_5927
	.dw __table_5929
	.dw __table_592b
	.dw __table_592f

__table_5923:
	.db $01 $02 $03 $00

__table_5927:
	.db $04 $00

__table_5929:
	.db $0a $00

__table_592b:
	.db $05 $06 $0b $00

__table_592f:
	.db $07 $08 $09 $00

_table_5933:
	.dw __table_593b
	.dw __table_5941
	.dw __table_5943
	.dw __table_5948

__table_593b:
	.db $01 $02 $03 $04 $0a $00

__table_5941:
	.db $05 $00

__table_5943:
	.db $06 $07 $08 $09 $00

__table_5948:
	.db $0b $00

_miscNPC_scriptTable:
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
	.dw mayorsScript
	.dw mayorsScript
	.dw mayorsScript
	.dw mayorsHouseLadyScript

@mrsRuulScripts:
	.dw mrsRuulScript

@mrWriteScripts:
	.dw mrWriteScript

@fickleLadyScripts:
	.dw fickleLadyScript_text1
	.dw fickleLadyScript_text2
	.dw fickleLadyScript_text2
	.dw fickleLadyScript_text2
	.dw fickleLadyScript_text3
	.dw fickleLadyScript_text4
	.dw fickleLadyScript_text5
	.dw fickleLadyScript_text5
	.dw fickleLadyScript_text6
	.dw fickleLadyScript_text2
	.dw fickleLadyScript_text7

@malonScripts:
	.dw malonScript

@bathingSubrosiansScripts:
	.dw bathingSubrosianScript_text1
	.dw bathingSubrosianScript_stub
	.dw bathingSubrosianScript_2
	.dw bathingSubrosianScript_text3
	.dw bathingSubrosianScript_stub
	.dw bathingSubrosianScript_stub

@masterDiversSonScripts:
	.dw masterDiversSonScript
	.dw masterDiversSonScript_4thEssenceGotten
	.dw masterDiversSonScript_8thEssenceGotten
	.dw masterDiversSonScript_ZeldaKidnapped
	.dw masterDiversSonScript_gameFinished

@fickleManScripts:
	.dw ficklManScript_text1
	.dw ficklManScript_text1
	.dw ficklManScript_text2
	.dw ficklManScript_text4
	.dw ficklManScript_text5
	.dw ficklManScript_text6
	.dw ficklManScript_text7
	.dw ficklManScript_text7
	.dw ficklManScript_text8
	.dw ficklManScript_text3
	.dw ficklManScript_text9
	.dw ficklManScript_textA

@dungeonWiseOldManScripts:
	.dw dungeonWiseOldManScript

@sunkenCityTreasureHunterScripts:
	.dw treasureHunterScript_text1
	.dw treasureHunterScript_text2
	.dw treasureHunterScript_text3
	.dw treasureHunterScript_text4
	.dw treasureHunterScript_text3

@villageFarmerScripts:
	.dw oldLadyFarmerScript_text1
	.dw oldLadyFarmerScript_text1
	.dw oldLadyFarmerScript_text2
	.dw oldLadyFarmerScript_text2
	.dw oldLadyFarmerScript_text3
	.dw oldLadyFarmerScript_text4
	.dw oldLadyFarmerScript_text5
	.dw oldLadyFarmerScript_text5
	.dw oldLadyFarmerScript_text6
	.dw oldLadyFarmerScript_text2
	.dw oldLadyFarmerScript_text7

@villageFountainManScripts:
	.dw fountainOldManScript_text1
	.dw fountainOldManScript_text2
	.dw fountainOldManScript_text3
	.dw fountainOldManScript_text4
	.dw fountainOldManScript_text6
	.dw fountainOldManScript_text7
	.dw fountainOldManScript_text8
	.dw fountainOldManScript_text8
	.dw fountainOldManScript_text9
	.dw fountainOldManScript_text5
	.dw fountainOldManScript_textA

@tickTockScripts:
	.dw tickTockScript


; Cat on tree interactions
interactionCode25:
interactionCode26:
	ld e,$44		; $5a0e
	ld a,(de)		; $5a10
	rst_jumpTable			; $5a11
	.dw $5a18
	.dw $5a83
	.dw $5a93
@state0:
	call interactionInitGraphics		; $5a18
	ld a,$0b		; $5a1b
	call interactionSetHighTextIndex		; $5a1d
	ld e,$41		; $5a20
	ld a,(de)		; $5a22
	cp $26			; $5a23
	jr z,_label_08_151	; $5a25
	call getThisRoomFlags		; $5a27
	and $40			; $5a2a
	ld e,$42		; $5a2c
	ld a,(de)		; $5a2e
	jr nz,_label_08_150	; $5a2f
	or a			; $5a31
	jp nz,interactionDelete		; $5a32
	jr _label_08_153		; $5a35
_label_08_150:
	or a			; $5a37
	jp z,interactionDelete		; $5a38
	jr _label_08_153		; $5a3b
_label_08_151:
	call getThisRoomFlags		; $5a3d
	and $40			; $5a40
	ld e,$42		; $5a42
	ld a,(de)		; $5a44
	jr nz,_label_08_152	; $5a45
	or a			; $5a47
	jp nz,interactionDelete		; $5a48
	call $5a78		; $5a4b
	ld a,$00		; $5a4e
	call interactionSetAnimation		; $5a50
	jp $5a96		; $5a53
_label_08_152:
	or a			; $5a56
	jp z,interactionDelete		; $5a57
	call $5a78		; $5a5a
	ld a,$02		; $5a5d
	call interactionSetAnimation		; $5a5f
	jp $5a96		; $5a62
_label_08_153:
	ld h,d			; $5a65
	ld l,$44		; $5a66
	ld (hl),$01		; $5a68
	ld hl,$5225		; $5a6a
	call interactionSetScript		; $5a6d
	ld a,$02		; $5a70
	call interactionSetAnimation		; $5a72
	jp $5a96		; $5a75
	ld h,d			; $5a78
	ld l,$44		; $5a79
	ld (hl),$02		; $5a7b
	ld hl,$5227		; $5a7d
	jp interactionSetScript		; $5a80
@state1:
	call interactionRunScript		; $5a83
	ld a,($cceb)		; $5a86
	or a			; $5a89
	jp z,npcFaceLinkAndAnimate		; $5a8a
	call $5a99		; $5a8d
	jp $5a96		; $5a90
@state2:
	call interactionRunScript		; $5a93
	jp interactionAnimateAsNpc		; $5a96
	ld e,$78		; $5a99
	ld a,(de)		; $5a9b
	rst_jumpTable			; $5a9c
	and l			; $5a9d
	ld e,d			; $5a9e
	jp nz,$d45a		; $5a9f
	ld e,d			; $5aa2
	xor $5a			; $5aa3
	ld h,d			; $5aa5
	ld l,$78		; $5aa6
	ld (hl),$01		; $5aa8
	ld l,$49		; $5aaa
	ld (hl),$08		; $5aac
	ld l,$50		; $5aae
	ld (hl),$28		; $5ab0
	ld l,$54		; $5ab2
	ld (hl),$00		; $5ab4
	inc hl			; $5ab6
	ld (hl),$fe		; $5ab7
	ld l,$79		; $5ab9
	ld (hl),$04		; $5abb
	ld a,$07		; $5abd
	jp interactionSetAnimation		; $5abf
	ld h,d			; $5ac2
	ld l,$79		; $5ac3
	dec (hl)		; $5ac5
	ret nz			; $5ac6
	ld l,$78		; $5ac7
	inc (hl)		; $5ac9
	ld a,$08		; $5aca
	call interactionSetAnimation		; $5acc
	ld a,$53		; $5acf
	jp playSound		; $5ad1
	ld c,$28		; $5ad4
	call objectUpdateSpeedZ_paramC		; $5ad6
	jp nz,objectApplySpeed		; $5ad9
	ld h,d			; $5adc
	ld l,$78		; $5add
	inc (hl)		; $5adf
	ld l,$79		; $5ae0
	ld (hl),$04		; $5ae2
	ld a,$07		; $5ae4
	call interactionSetAnimation		; $5ae6
	ld a,$57		; $5ae9
	jp playSound		; $5aeb
	ld h,d			; $5aee
	ld l,$79		; $5aef
	dec (hl)		; $5af1
	ret nz			; $5af2
	xor a			; $5af3
	ld ($cceb),a		; $5af4
	ld a,$02		; $5af7
	jp interactionSetAnimation		; $5af9


; ==============================================================================
; INTERACID_SOKRA
; ==============================================================================
interactionCode27:
	ld e,$44		; $5afc
	ld a,(de)		; $5afe
	rst_jumpTable			; $5aff
	inc b			; $5b00
	ld e,e			; $5b01
	ld a,e			; $5b02
	ld e,e			; $5b03
	ld a,$01		; $5b04
	ld (de),a		; $5b06
	ld a,$28		; $5b07
	call checkGlobalFlag		; $5b09
	jp nz,interactionDelete		; $5b0c
	ld a,$52		; $5b0f
	call interactionSetHighTextIndex		; $5b11
	call interactionInitGraphics		; $5b14
	ld e,$42		; $5b17
	ld a,(de)		; $5b19
	rst_jumpTable			; $5b1a
	ldi a,(hl)		; $5b1b
	ld e,e			; $5b1c
	ld b,e			; $5b1d
	ld e,e			; $5b1e
	ld h,d			; $5b1f
	ld e,e			; $5b20
_label_08_154:
	call interactionRunScript		; $5b21
	call interactionRunScript		; $5b24
	jp objectSetVisiblec2		; $5b27
	ld a,($c6b0)		; $5b2a
	and $02			; $5b2d
	jr nz,_label_08_155	; $5b2f
	ld a,$71		; $5b31
	call getARoomFlags		; $5b33
	bit 6,a			; $5b36
	jp nz,interactionDelete		; $5b38
_label_08_155:
	ld hl,$526d		; $5b3b
	call interactionSetScript		; $5b3e
	jr _label_08_154		; $5b41
	ld a,($c6b0)		; $5b43
	and $08			; $5b46
	jr z,_label_08_156	; $5b48
	call getThisRoomFlags		; $5b4a
	bit 6,a			; $5b4d
	jr nz,_label_08_156	; $5b4f
	ld hl,$52fa		; $5b51
	call interactionSetScript		; $5b54
	jr _label_08_154		; $5b57
_label_08_156:
	ld hl,objectData.objectData7e4a		; $5b59
	call parseGivenObjectData		; $5b5c
	jp interactionDelete		; $5b5f
	call getThisRoomFlags		; $5b62
	ld a,($c6b0)		; $5b65
	and $02			; $5b68
	jr z,_label_08_157	; $5b6a
	res 6,(hl)		; $5b6c
	jp interactionDelete		; $5b6e
_label_08_157:
	set 6,(hl)		; $5b71
	ld hl,$5358		; $5b73
	call interactionSetScript		; $5b76
	jr _label_08_154		; $5b79
	ld e,$42		; $5b7b
	ld a,(de)		; $5b7d
	rst_jumpTable			; $5b7e
	add l			; $5b7f
	ld e,e			; $5b80
	pop bc			; $5b81
	ld e,e			; $5b82
.DB $dd				; $5b83
	ld e,e			; $5b84
	call interactionRunScript		; $5b85
	call interactionAnimateAsNpc		; $5b88
	ld a,$19		; $5b8b
	call checkTreasureObtained		; $5b8d
	ret nc			; $5b90
	call getThisRoomFlags		; $5b91
	bit 6,(hl)		; $5b94
	jr z,_label_08_158	; $5b96
	ld e,$43		; $5b98
	ld a,(de)		; $5b9a
	or a			; $5b9b
	jr nz,_label_08_159	; $5b9c
	ret			; $5b9e
_label_08_158:
	ld a,($d00d)		; $5b9f
	cp $78			; $5ba2
	ret c			; $5ba4
	ld a,($d00b)		; $5ba5
	cp $3c			; $5ba8
	ret c			; $5baa
	cp $60			; $5bab
	ret nc			; $5bad
	ld e,$77		; $5bae
	ld a,$01		; $5bb0
	ld (de),a		; $5bb2
	ret			; $5bb3
_label_08_159:
	ld a,(wFrameCounter)		; $5bb4
	and $3f			; $5bb7
	ret nz			; $5bb9
	ld b,$f4		; $5bba
	ld c,$fa		; $5bbc
	jp objectCreateFloatingMusicNote		; $5bbe
	call interactionAnimateAsNpc		; $5bc1
	call interactionRunScript		; $5bc4
	jp c,interactionDelete		; $5bc7
	call checkInteractionState2		; $5bca
	ret nz			; $5bcd
	ld a,($d00d)		; $5bce
	cp $18			; $5bd1
	ret c			; $5bd3
	call interactionIncState2		; $5bd4
	call $5bae		; $5bd7
	jp $5dfe		; $5bda
	ld a,($cca4)		; $5bdd
	and $01			; $5be0
	call z,seasonsFunc_3d30		; $5be2
	call interactionAnimateAsNpc		; $5be5
	jp interactionRunScript		; $5be8

interactionCode28:
	ld e,$44		; $5beb
	ld a,(de)		; $5bed
	rst_jumpTable			; $5bee
	di			; $5bef
	ld e,e			; $5bf0
	ld b,d			; $5bf1
	ld e,h			; $5bf2
	call interactionInitGraphics		; $5bf3
	call interactionIncState		; $5bf6
	ld e,$42		; $5bf9
	ld a,(de)		; $5bfb
	ld hl,_table_5c87		; $5bfc
	rst_addDoubleIndex			; $5bff
	ldi a,(hl)		; $5c00
	ld h,(hl)		; $5c01
	ld l,a			; $5c02
	call interactionSetScript		; $5c03
	ld e,$42		; $5c06
	ld a,(de)		; $5c08
	rst_jumpTable			; $5c09
	ld e,$5c		; $5c0a
	ldd (hl),a		; $5c0c
	ld e,h			; $5c0d
	ldd (hl),a		; $5c0e
	ld e,h			; $5c0f
	ldd (hl),a		; $5c10
	ld e,h			; $5c11
	ldd (hl),a		; $5c12
	ld e,h			; $5c13
	ldd a,(hl)		; $5c14
	ld e,h			; $5c15
	ldd (hl),a		; $5c16
	ld e,h			; $5c17
	ldd (hl),a		; $5c18
	ld e,h			; $5c19
	ldd (hl),a		; $5c1a
	ld e,h			; $5c1b
	ldd (hl),a		; $5c1c
	ld e,h			; $5c1d
	ld h,d			; $5c1e
	ld l,$50		; $5c1f
	ld (hl),$28		; $5c21
	ld l,$49		; $5c23
	ld (hl),$18		; $5c25
	ld l,$7a		; $5c27
	ld a,$04		; $5c29
	ld (hl),a		; $5c2b
	call interactionSetAnimation		; $5c2c
	jp $5c66		; $5c2f
	ld a,$03		; $5c32
	call interactionSetAnimation		; $5c34
	jp $5c66		; $5c37
	ld a,$02		; $5c3a
	call interactionSetAnimation		; $5c3c
	jp $5c66		; $5c3f
	ld e,$42		; $5c42
	ld a,(de)		; $5c44
	rst_jumpTable			; $5c45
	ld e,d			; $5c46
	ld e,h			; $5c47
	ld e,l			; $5c48
	ld e,h			; $5c49
	ld e,l			; $5c4a
	ld e,h			; $5c4b
	ld e,l			; $5c4c
	ld e,h			; $5c4d
	ld e,l			; $5c4e
	ld e,h			; $5c4f
	ld e,l			; $5c50
	ld e,h			; $5c51
	ld e,l			; $5c52
	ld e,h			; $5c53
	ld e,l			; $5c54
	ld e,h			; $5c55
	ld e,l			; $5c56
	ld e,h			; $5c57
	ld e,l			; $5c58
	ld e,h			; $5c59
	call $5c6c		; $5c5a
	call interactionRunScript		; $5c5d
	jp $5c63		; $5c60
	call interactionAnimate		; $5c63
	call objectPreventLinkFromPassing		; $5c66
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $5c69
	call objectApplySpeed		; $5c6c
	ld e,$4d		; $5c6f
	ld a,(de)		; $5c71
	sub $28			; $5c72
	cp $30			; $5c74
	ret c			; $5c76
	ld h,d			; $5c77
	ld l,$49		; $5c78
	ld a,(hl)		; $5c7a
	xor $10			; $5c7b
	ld (hl),a		; $5c7d
	ld l,$7a		; $5c7e
	ld a,(hl)		; $5c80
	xor $01			; $5c81
	ld (hl),a		; $5c83
	jp interactionSetAnimation		; $5c84

_table_5c87:
	.dw script537e
	.dw script5393
	.dw script5393
	.dw script5393
	.dw script5393
	.dw script53a2
	.dw script5393
	.dw script5393
	.dw script5393
	.dw script5393


; Know-it-all birds? Different code in ages
interactionCode2a:
	call checkInteractionState		; $5c9b
	jr nz,_label_08_163	; $5c9e
	ld a,$01		; $5ca0
	ld (de),a		; $5ca2
	call interactionInitGraphics		; $5ca3
	ld e,$42		; $5ca6
	ld a,(de)		; $5ca8
	cp $0a			; $5ca9
	jr z,_label_08_162	; $5cab
	cp $0b			; $5cad
	jr nz,_label_08_160	; $5caf
	ld a,$22		; $5cb1
	call checkGlobalFlag		; $5cb3
	jp z,interactionDelete		; $5cb6
	ld a,$23		; $5cb9
	call checkGlobalFlag		; $5cbb
	jp nz,interactionDelete		; $5cbe
	ld hl,$53d6		; $5cc1
	jr _label_08_161		; $5cc4
_label_08_160:
	ld hl,$53b8		; $5cc6
_label_08_161:
	call interactionSetScript		; $5cc9
	call getRandomNumber_noPreserveVars		; $5ccc
	and $01			; $5ccf
	ld e,$48		; $5cd1
	ld (de),a		; $5cd3
	call interactionSetAnimation		; $5cd4
	call interactionSetAlwaysUpdateBit		; $5cd7
	ld l,$76		; $5cda
	ld (hl),$1e		; $5cdc
	call $5dfe		; $5cde
	ld l,$42		; $5ce1
	ld a,(hl)		; $5ce3
	ld l,$72		; $5ce4
	ld (hl),a		; $5ce6
	ld l,$73		; $5ce7
	ld (hl),$32		; $5ce9
	jp objectSetVisible82		; $5ceb
_label_08_162:
	call interactionSetAlwaysUpdateBit		; $5cee
	ld l,$46		; $5cf1
	ld (hl),$b4		; $5cf3
	ld l,$50		; $5cf5
	ld (hl),$19		; $5cf7
	call $5dfe		; $5cf9
	call objectSetVisible82		; $5cfc
	jp objectSetInvisible		; $5cff
_label_08_163:
	ld e,$42		; $5d02
	ld a,(de)		; $5d04
	cp $0a			; $5d05
	jr z,_label_08_166	; $5d07
	call interactionRunScript		; $5d09
	ld e,$45		; $5d0c
	ld a,(de)		; $5d0e
	rst_jumpTable			; $5d0f
	inc d			; $5d10
	ld e,l			; $5d11
	ld b,c			; $5d12
	ld e,l			; $5d13
	ld e,$77		; $5d14
	ld a,(de)		; $5d16
	or a			; $5d17
	jr z,_label_08_164	; $5d18
	call interactionIncState2		; $5d1a
	ld l,$48		; $5d1d
	ld a,(hl)		; $5d1f
	add $02			; $5d20
	jp interactionSetAnimation		; $5d22
_label_08_164:
	call $5df2		; $5d25
	jr nz,_label_08_165	; $5d28
	ld l,$76		; $5d2a
	ld (hl),$1e		; $5d2c
	call getRandomNumber		; $5d2e
	and $07			; $5d31
	jr nz,_label_08_165	; $5d33
	ld l,$48		; $5d35
	ld a,(hl)		; $5d37
	xor $01			; $5d38
	ld (hl),a		; $5d3a
	jp interactionSetAnimation		; $5d3b
_label_08_165:
	jp interactionAnimateAsNpc		; $5d3e
	call interactionAnimate		; $5d41
	ld e,$77		; $5d44
	ld a,(de)		; $5d46
	or a			; $5d47
	jp nz,seasonsFunc_08_5df7		; $5d48
	ld l,$76		; $5d4b
	ld (hl),$3c		; $5d4d
	ld l,$45		; $5d4f
	ld (hl),a		; $5d51
	ld l,$4e		; $5d52
	ldi (hl),a		; $5d54
	ld (hl),a		; $5d55
	ld l,$48		; $5d56
	ld a,(hl)		; $5d58
	jp interactionSetAnimation		; $5d59
_label_08_166:
	ld e,$45		; $5d5c
	ld a,(de)		; $5d5e
	rst_jumpTable			; $5d5f
	ld l,d			; $5d60
	ld e,l			; $5d61
	ld a,h			; $5d62
	ld e,l			; $5d63
	and c			; $5d64
	ld e,l			; $5d65
	or e			; $5d66
	ld e,l			; $5d67
	adc $5d			; $5d68
	ld a,($cbc3)		; $5d6a
	or a			; $5d6d
	ret nz			; $5d6e
	call interactionDecCounter1		; $5d6f
	ret nz			; $5d72
	ld l,$45		; $5d73
	inc (hl)		; $5d75
	call $5e04		; $5d76
	jp objectSetVisible		; $5d79
	call interactionAnimateAsNpc		; $5d7c
	call seasonsFunc_08_5df7		; $5d7f
	ld a,(wFrameCounter)		; $5d82
	and $07			; $5d85
	call z,$5e04		; $5d87
	ld c,$10		; $5d8a
	call $5e22		; $5d8c
	jp nc,objectApplySpeed		; $5d8f
	ld h,d			; $5d92
	ld l,$45		; $5d93
	inc (hl)		; $5d95
	ld l,$46		; $5d96
	ld (hl),$14		; $5d98
	ld l,$4f		; $5d9a
	ld (hl),$00		; $5d9c
	jp $5dfe		; $5d9e
	call interactionAnimateAsNpc		; $5da1
	call interactionDecCounter1		; $5da4
	ret nz			; $5da7
	ld l,$45		; $5da8
	inc (hl)		; $5daa
	ld l,$78		; $5dab
	ld a,(hl)		; $5dad
	add $02			; $5dae
	jp interactionSetAnimation		; $5db0
	call interactionAnimateAsNpc		; $5db3
	call $5de5		; $5db6
	ld e,$4f		; $5db9
	ld a,(de)		; $5dbb
	or a			; $5dbc
	ret nz			; $5dbd
	ld c,$18		; $5dbe
	call $5e22		; $5dc0
	ret c			; $5dc3
	ld h,d			; $5dc4
	ld l,$45		; $5dc5
	inc (hl)		; $5dc7
	call $5dfe		; $5dc8
	jp $5e04		; $5dcb
	call interactionAnimateAsNpc		; $5dce
	call seasonsFunc_08_5df7		; $5dd1
	ld a,(wFrameCounter)		; $5dd4
	and $07			; $5dd7
	call z,$5e04		; $5dd9
	call objectApplySpeed		; $5ddc
	call objectCheckWithinScreenBoundary		; $5ddf
	jp nc,interactionDelete		; $5de2
	ld c,$10		; $5de5
	call objectUpdateSpeedZ_paramC		; $5de7
	ret nz			; $5dea
	ld h,d			; $5deb
	ld bc,$fec0		; $5dec
	jp objectSetSpeedZ		; $5def
	ld h,d			; $5df2
	ld l,$76		; $5df3
	dec (hl)		; $5df5
	ret			; $5df6

seasonsFunc_08_5df7:
	ld c,$20		; $5df7
	call objectUpdateSpeedZ_paramC		; $5df9
	ret nz			; $5dfc
	ld h,d			; $5dfd
	ld bc,$ff40		; $5dfe
	jp objectSetSpeedZ		; $5e01
	call objectGetRelatedObject1Var		; $5e04
	ld l,$4b		; $5e07
	ld b,(hl)		; $5e09
	inc l			; $5e0a
	inc l			; $5e0b
	ld c,(hl)		; $5e0c
	call objectGetRelativeAngle		; $5e0d
	ld e,$49		; $5e10
	ld (de),a		; $5e12
	and $10			; $5e13
	swap a			; $5e15
	xor $01			; $5e17
	ld h,d			; $5e19
	ld l,$78		; $5e1a
	cp (hl)			; $5e1c
	ret z			; $5e1d
	ld (hl),a		; $5e1e
	jp interactionSetAnimation		; $5e1f
	ld e,$4b		; $5e22
	ld a,(de)		; $5e24
	ld b,a			; $5e25
	call objectGetRelatedObject1Var		; $5e26
	ld l,$4b		; $5e29
	ld a,(hl)		; $5e2b
	sub b			; $5e2c
	cp c			; $5e2d
	ret			; $5e2e


; ==============================================================================
; INTERACID_BLOSSOM
; ==============================================================================
interactionCode2b:
	ld e,$44		; $5e2f
	ld a,(de)		; $5e31
	rst_jumpTable			; $5e32
	scf			; $5e33
	ld e,(hl)		; $5e34
	ld (hl),a		; $5e35
	ld e,(hl)		; $5e36
	call interactionInitGraphics		; $5e37
	ld a,$44		; $5e3a
	call interactionSetHighTextIndex		; $5e3c
	call interactionIncState		; $5e3f
	ld e,$42		; $5e42
	ld a,(de)		; $5e44
	ld hl,_table_5e86		; $5e45
	rst_addDoubleIndex			; $5e48
	ldi a,(hl)		; $5e49
	ld h,(hl)		; $5e4a
	ld l,a			; $5e4b
	call interactionSetScript		; $5e4c
	ld e,$42		; $5e4f
	ld a,(de)		; $5e51
	rst_jumpTable			; $5e52
	.dw $5e67
	.dw $5e67
	.dw $5e6f
	.dw $5e67
	.dw $5e6f
	.dw $5e6f
	.dw $5e6f
	.dw $5e6f
	.dw $5e6f
	.dw $5e6f
	ld a,$00		; $5e67
	call interactionSetAnimation		; $5e69
	jp $5e80		; $5e6c
	ld a,$04		; $5e6f
	call interactionSetAnimation		; $5e71
	jp $5e80		; $5e74
	call interactionRunScript		; $5e77
	jp $5e7d		; $5e7a
	call interactionAnimate		; $5e7d
	call objectPreventLinkFromPassing		; $5e80
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $5e83

_table_5e86:
	.dw script53ea
	.dw script5426
	.dw script54d2
	.dw script54de
	.dw script550e
	.dw script5510
	.dw script5512
	.dw script55b1
	.dw script55c3
	.dw script55d5


; 2 screens of Sunken City NPCs? or their version of dragonflies?
interactionCode2e:
	ld e,$44		; $5e9a
	ld a,(de)		; $5e9c
	rst_jumpTable			; $5e9d
	and d			; $5e9e
	ld e,(hl)		; $5e9f
	ld ($ff00+c),a		; $5ea0
	ld e,(hl)		; $5ea1
	ld a,$01		; $5ea2
	ld (de),a		; $5ea4
	call $5874		; $5ea5
	ld e,$42		; $5ea8
	ld a,(de)		; $5eaa
	cp b			; $5eab
	jp nz,interactionDelete		; $5eac
	call interactionInitGraphics		; $5eaf
	ld a,($cc4c)		; $5eb2
	cp $6d			; $5eb5
	jr z,_label_08_167	; $5eb7
	ld a,$01		; $5eb9
	ld e,$48		; $5ebb
	ld (de),a		; $5ebd
	call interactionSetAnimation		; $5ebe
_label_08_167:
	ld e,$42		; $5ec1
	ld a,(de)		; $5ec3
	ld hl,_table_5f7e		; $5ec4
	rst_addDoubleIndex			; $5ec7
	ldi a,(hl)		; $5ec8
	ld h,(hl)		; $5ec9
	ld l,a			; $5eca
	call interactionSetScript		; $5ecb
	call getFreeInteractionSlot		; $5ece
	jr nz,_label_08_168	; $5ed1
	ld (hl),$8e		; $5ed3
	inc l			; $5ed5
	ld (hl),$00		; $5ed6
	ld l,$57		; $5ed8
	ld (hl),d		; $5eda
	ld l,$49		; $5edb
	call $5f4e		; $5edd
_label_08_168:
	jr _label_08_169		; $5ee0
	call interactionRunScript		; $5ee2
	ld e,$43		; $5ee5
	ld a,(de)		; $5ee7
	rst_jumpTable			; $5ee8
	pop af			; $5ee9
	ld e,(hl)		; $5eea
	nop			; $5eeb
	ld e,a			; $5eec
	ld d,$5f		; $5eed
	ld d,$5f		; $5eef
_label_08_169:
	call interactionAnimate		; $5ef1
	ld e,$61		; $5ef4
	ld a,(de)		; $5ef6
	inc a			; $5ef7
	jr nz,_label_08_170	; $5ef8
	call $5f70		; $5efa
_label_08_170:
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $5efd
	call interactionAnimate		; $5f00
	ld e,$61		; $5f03
	ld a,(de)		; $5f05
	or a			; $5f06
	jr z,_label_08_170	; $5f07
	call $5f65		; $5f09
	call getRandomNumber_noPreserveVars		; $5f0c
	and $03			; $5f0f
	jr nz,_label_08_172	; $5f11
	inc a			; $5f13
	jr _label_08_172		; $5f14
	call interactionAnimate		; $5f16
	ld e,$61		; $5f19
	ld a,(de)		; $5f1b
	cp $02			; $5f1c
	jr nz,_label_08_170	; $5f1e
	call $5f65		; $5f20
	call getFreePartSlot		; $5f23
	jr nz,_label_08_171	; $5f26
	ld (hl),$32		; $5f28
	inc l			; $5f2a
	ld (hl),$01		; $5f2b
	ld l,$c9		; $5f2d
	call $5f4e		; $5f2f
_label_08_171:
	call getRandomNumber_noPreserveVars		; $5f32
	and $03			; $5f35
	sub $02			; $5f37
	ret c			; $5f39
	inc a			; $5f3a
_label_08_172:
	ld b,a			; $5f3b
_label_08_173:
	call getFreePartSlot		; $5f3c
	ret nz			; $5f3f
	ld (hl),$32		; $5f40
	inc l			; $5f42
	ld (hl),$00		; $5f43
	ld l,$c9		; $5f45
	call $5f4e		; $5f47
	dec b			; $5f4a
	jr nz,_label_08_173	; $5f4b
	ret			; $5f4d
	push bc			; $5f4e
	ld e,$48		; $5f4f
	ld a,(de)		; $5f51
	rrca			; $5f52
	ld c,$f8		; $5f53
	ld a,$1c		; $5f55
	jr nc,_label_08_174	; $5f57
	ld c,$0a		; $5f59
	ld a,$06		; $5f5b
_label_08_174:
	ld (hl),a		; $5f5d
	ld b,$02		; $5f5e
	call objectCopyPositionWithOffset		; $5f60
	pop bc			; $5f63
	ret			; $5f64
	ld e,$48		; $5f65
	ld a,(de)		; $5f67
	and $01			; $5f68
	call interactionSetAnimation		; $5f6a
	call $5efa		; $5f6d
	ld e,$76		; $5f70
	ld a,$01		; $5f72
	ld (de),a		; $5f74
	call getRandomNumber_noPreserveVars		; $5f75
	and $03			; $5f78
	ld e,$43		; $5f7a
	ld (de),a		; $5f7c
	ret			; $5f7d

_table_5f7e:
	.dw script55e7
	.dw script55ea
	.dw script55ea
	.dw script55f5
	.dw script55ea


; ==============================================================================
; INTERACID_SUBROSIAN
; ==============================================================================
interactionCode30:
	ld e,$44		; $5f88
	ld a,(de)		; $5f8a
	rst_jumpTable			; $5f8b
	sbc b			; $5f8c
	ld e,a			; $5f8d
	jp c,$f35f		; $5f8e
	ld e,a			; $5f91
	inc d			; $5f92
	ld h,b			; $5f93
	rra			; $5f94
	ld h,b			; $5f95
	dec hl			; $5f96
	ld h,b			; $5f97
	ld a,$01		; $5f98
	ld (de),a		; $5f9a
	call interactionInitGraphics		; $5f9b
	ld h,d			; $5f9e
	ld l,$6b		; $5f9f
	ld (hl),$00		; $5fa1
	ld l,$49		; $5fa3
	ld (hl),$ff		; $5fa5
	ld l,$42		; $5fa7
	ld a,(hl)		; $5fa9
	cp $25			; $5faa
	jr nz,_label_08_175	; $5fac
	call checkIsLinkedGame		; $5fae
	jp z,interactionDelete		; $5fb1
	ld a,$0d		; $5fb4
	call checkGlobalFlag		; $5fb6
	jp z,interactionDelete		; $5fb9
	ld e,$7e		; $5fbc
	ld a,$03		; $5fbe
	ld (de),a		; $5fc0
_label_08_175:
	ld e,$42		; $5fc1
	ld a,(de)		; $5fc3
	ld hl,$607f		; $5fc4
	rst_addDoubleIndex			; $5fc7
	ldi a,(hl)		; $5fc8
	ld h,(hl)		; $5fc9
	ld l,a			; $5fca
	call interactionSetScript		; $5fcb
	call interactionRunScript		; $5fce
	call interactionRunScript		; $5fd1
	jp c,interactionDelete		; $5fd4
	jp objectSetVisible82		; $5fd7
	ld a,($cc49)		; $5fda
	dec a			; $5fdd
	jr nz,_label_08_176	; $5fde
	call objectGetTileAtPosition		; $5fe0
	ld (hl),$00		; $5fe3
_label_08_176:
	ld c,$20		; $5fe5
	call objectUpdateSpeedZ_paramC		; $5fe7
	call interactionRunScript		; $5fea
	jp c,interactionDelete		; $5fed
	jp npcFaceLinkAndAnimate		; $5ff0
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $5ff3
	call c,$600e		; $5ff6
_label_08_177:
	call interactionAnimate		; $5ff9
	call interactionAnimate		; $5ffc
	call interactionRunScript		; $5fff
	ld c,$60		; $6002
	call objectUpdateSpeedZ_paramC		; $6004
	ret nz			; $6007
	ld bc,$fe00		; $6008
	jp objectSetSpeedZ		; $600b
	ld hl,$cfc0		; $600e
	set 1,(hl)		; $6011
	ret			; $6013
	call objectGetAngleTowardLink		; $6014
	ld e,$49		; $6017
	ld (de),a		; $6019
	call objectApplySpeed		; $601a
	jr _label_08_177		; $601d
	ld c,$20		; $601f
	call objectUpdateSpeedZ_paramC		; $6021
	call interactionRunScript		; $6024
	jp c,interactionDelete		; $6027
	ret			; $602a
	call interactionRunScript		; $602b
	ld e,$45		; $602e
	ld a,(de)		; $6030
	rst_jumpTable			; $6031
	ldd a,(hl)		; $6032
	ld h,b			; $6033
	ld d,(hl)		; $6034
	ld h,b			; $6035
	ld h,h			; $6036
	ld h,b			; $6037
	ld h,h			; $6038
	ld h,b			; $6039
_label_08_178:
	ld a,($cfc0)		; $603a
	call getHighestSetBit		; $603d
	ret nc			; $6040
	cp $03			; $6041
	jr nz,_label_08_179	; $6043
	ld e,$44		; $6045
	ld a,$04		; $6047
	ld (de),a		; $6049
	ret			; $604a
_label_08_179:
	ld b,a			; $604b
	inc a			; $604c
	ld e,$45		; $604d
	ld (de),a		; $604f
	ld a,b			; $6050
	add $04			; $6051
	jp interactionSetAnimation		; $6053
	call interactionAnimate		; $6056
	ld a,($cfc0)		; $6059
	or a			; $605c
	ret z			; $605d
	ld e,$45		; $605e
	xor a			; $6060
	ld (de),a		; $6061
	jr _label_08_178		; $6062
	call interactionAnimate		; $6064
	ld h,d			; $6067
	ld l,$61		; $6068
	ld a,(hl)		; $606a
	or a			; $606b
	jr z,_label_08_180	; $606c
	ld (hl),$00		; $606e
	ld l,$4d		; $6070
	add (hl)		; $6072
	ld (hl),a		; $6073
_label_08_180:
	ld a,($cfc0)		; $6074
	or a			; $6077
	ret z			; $6078
	ld l,$45		; $6079
	ld (hl),$00		; $607b
	jr _label_08_178		; $607d
	ld hl,sp+$55		; $607f
	rst $38			; $6081
	ld d,l			; $6082
	rst $38			; $6083
	ld d,l			; $6084
	add hl,bc		; $6085
	ld d,(hl)		; $6086
	inc c			; $6087
	ld d,(hl)		; $6088
	ld (de),a		; $6089
	ld d,(hl)		; $608a
	jr _label_08_181		; $608b
	dec hl			; $608d
	ld d,(hl)		; $608e
	ld a,$56		; $608f
	ld c,h			; $6091
	ld d,(hl)		; $6092
	ld e,d			; $6093
	ld d,(hl)		; $6094
	ld l,b			; $6095
	ld d,(hl)		; $6096
	ld a,a			; $6097
	ld d,(hl)		; $6098
	sbc c			; $6099
	ld d,(hl)		; $609a
	and e			; $609b
	ld d,(hl)		; $609c
	xor l			; $609d
	ld d,(hl)		; $609e
	or b			; $609f
	ld d,(hl)		; $60a0
	rst $20			; $60a1
	ld d,(hl)		; $60a2
	ld hl,sp+$56		; $60a3
.DB $fc				; $60a5
	ld d,(hl)		; $60a6
	ld d,$57		; $60a7
	inc e			; $60a9
	ld d,a			; $60aa
	inc hl			; $60ab
	ld d,a			; $60ac
	dec l			; $60ad
	ld d,a			; $60ae
	jr nc,$57		; $60af
	inc sp			; $60b1
	ld d,a			; $60b2
	dec a			; $60b3
	ld d,a			; $60b4
	ld b,b			; $60b5
	ld d,a			; $60b6
	ld b,e			; $60b7
	ld d,a			; $60b8
	ld c,c			; $60b9
	ld d,a			; $60ba
	ld c,a			; $60bb
	ld d,a			; $60bc
	ld d,l			; $60bd
	ld d,a			; $60be
	ld e,b			; $60bf
	ld d,a			; $60c0
	ld e,(hl)		; $60c1
	ld d,a			; $60c2
	ld l,l			; $60c3
	ld d,a			; $60c4
	ld (hl),b		; $60c5
	ld d,a			; $60c6
	ld (hl),e		; $60c7
	ld d,a			; $60c8
	halt			; $60c9
	ld d,a			; $60ca
	cp l			; $60cb
	ld d,a			; $60cc


; subrosia beach entrance and rosa screen (her ribbon event?)
interactionCode31:
	ld e,$42		; $60cd
	ld a,(de)		; $60cf
	rst_jumpTable			; $60d0
	reti			; $60d1
	ld h,b			; $60d2
	inc e			; $60d3
	ld h,c			; $60d4
	sbc d			; $60d5
	ld h,d			; $60d6
	reti			; $60d7
	ld h,b			; $60d8
	ld e,$44		; $60d9
	ld a,(de)		; $60db
	rst_jumpTable			; $60dc
	pop hl			; $60dd
	ld h,b			; $60de
	ld d,$61		; $60df
	ld a,$01		; $60e1
_label_08_181:
	ld (de),a		; $60e3
	call interactionInitGraphics		; $60e4
	ld a,$0b		; $60e7
	call checkGlobalFlag		; $60e9
	jp nz,interactionDelete		; $60ec
	ld h,d			; $60ef
	ld l,$6b		; $60f0
	ld (hl),$00		; $60f2
	ld l,$49		; $60f4
	ld (hl),$ff		; $60f6
	ld a,$0c		; $60f8
	call checkGlobalFlag		; $60fa
	jr nz,_label_08_182	; $60fd
	ld e,$77		; $60ff
	ld a,$04		; $6101
	ld (de),a		; $6103
_label_08_182:
	ld hl,$5813		; $6104
	call interactionSetScript		; $6107
	ld a,$29		; $610a
	call interactionSetHighTextIndex		; $610c
	call objectGetTileAtPosition		; $610f
	ld (hl),$00		; $6112
	jr _label_08_183		; $6114
	call interactionRunScript		; $6116
_label_08_183:
	jp npcFaceLinkAndAnimate		; $6119
	ld e,$44		; $611c
	ld a,(de)		; $611e
	rst_jumpTable			; $611f
	jr z,_label_08_185	; $6120
	ld d,(hl)		; $6122
	ld h,c			; $6123
	ei			; $6124
	ld h,c			; $6125
	ld l,h			; $6126
	ld h,d			; $6127
	ld a,$01		; $6128
	ld (de),a		; $612a
	call interactionInitGraphics		; $612b
	call makeActiveObjectFollowLink		; $612e
	call interactionSetAlwaysUpdateBit		; $6131
	call objectSetReservedBit1		; $6134
	ld l,$73		; $6137
	ld (hl),$01		; $6139
	ld l,$70		; $613b
	ld e,$4b		; $613d
	ld a,(de)		; $613f
	ldi (hl),a		; $6140
	ld e,$4d		; $6141
	ld a,(de)		; $6143
	ldi (hl),a		; $6144
	ld e,$48		; $6145
	ld a,($d008)		; $6147
	ld (de),a		; $614a
	ld (hl),$00		; $614b
	call interactionSetAnimation		; $614d
	call objectSetVisiblec3		; $6150
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6153
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $6156
	call $61a4		; $6159
	ret c			; $615c
	ld c,$20		; $615d
	call objectUpdateSpeedZ_paramC		; $615f
	call z,$6182		; $6162
	call $628e		; $6165
	ld h,d			; $6168
	ld l,$4b		; $6169
	ld a,(hl)		; $616b
	ld b,a			; $616c
	ld l,$70		; $616d
	cp (hl)			; $616f
	jr nz,_label_08_184	; $6170
	ld l,$4d		; $6172
	ld a,(hl)		; $6174
	ld c,a			; $6175
	ld l,$71		; $6176
	cp (hl)			; $6178
	ret z			; $6179
_label_08_184:
	ld l,$70		; $617a
	ld (hl),b		; $617c
	inc l			; $617d
	ld (hl),c		; $617e
	jp interactionAnimate		; $617f
	ld h,d			; $6182
_label_08_185:
	ld l,$46		; $6183
	ld a,(hl)		; $6185
	or a			; $6186
	jr z,_label_08_186	; $6187
	dec (hl)		; $6189
	ret nz			; $618a
	ld bc,$fe40		; $618b
	jp objectSetSpeedZ		; $618e
_label_08_186:
	ld a,($cc77)		; $6191
	or a			; $6194
	ret z			; $6195
	ld a,($cca4)		; $6196
	and $81			; $6199
	ret nz			; $619b
	ld a,($cc02)		; $619c
	or a			; $619f
	ret nz			; $61a0
	ld (hl),$10		; $61a1
	ret			; $61a3
	ld a,($cc49)		; $61a4
	cp $06			; $61a7
	jr nc,_label_08_188	; $61a9
	ld a,($cc4c)		; $61ab
	ld hl,$61dd		; $61ae
	call findRoomSpecificData		; $61b1
	ret nc			; $61b4
	rst_jumpTable			; $61b5
	cp h			; $61b6
	ld h,c			; $61b7
	jp nc,$d761		; $61b8
	ld h,c			; $61bb
	ld e,$73		; $61bc
	ld a,(de)		; $61be
	or a			; $61bf
	jr nz,_label_08_187	; $61c0
	ld a,($cd00)		; $61c2
	and $01			; $61c5
	jr z,_label_08_187	; $61c7
	ld e,$44		; $61c9
	ld a,$02		; $61cb
	ld (de),a		; $61cd
	scf			; $61ce
	ret			; $61cf
_label_08_187:
	xor a			; $61d0
	ret			; $61d1
	ld e,$73		; $61d2
	xor a			; $61d4
	ld (de),a		; $61d5
	ret			; $61d6
_label_08_188:
	ld e,$44		; $61d7
	ld a,$03		; $61d9
	ld (de),a		; $61db
	ret			; $61dc
.DB $ed				; $61dd
	ld h,c			; $61de
	xor $61			; $61df
.DB $ed				; $61e1
	ld h,c			; $61e2
	di			; $61e3
	ld h,c			; $61e4
	ld hl,sp+$61		; $61e5
	ld a,($ed61)		; $61e7
	ld h,c			; $61ea
.DB $ed				; $61eb
	ld h,c			; $61ec
	nop			; $61ed
	ld h,a			; $61ee
	ld bc,$0077		; $61ef
	nop			; $61f2
	adc d			; $61f3
	ld (bc),a		; $61f4
	or c			; $61f5
	ld (bc),a		; $61f6
	nop			; $61f7
	ld a,($ff00+$02)	; $61f8
	nop			; $61fa
	ld e,$45		; $61fb
	ld a,(de)		; $61fd
	rst_jumpTable			; $61fe
	dec b			; $61ff
	ld h,d			; $6200
	dec h			; $6201
	ld h,d			; $6202
	ld b,e			; $6203
	ld h,d			; $6204
	ld a,$01		; $6205
	ld (de),a		; $6207
	call clearFollowingLinkObject		; $6208
	ld a,$0b		; $620b
	call unsetGlobalFlag		; $620d
	ld a,$01		; $6210
	ld ($cca4),a		; $6212
	ld a,$02		; $6215
	ld ($d008),a		; $6217
	ld a,$29		; $621a
	call interactionSetHighTextIndex		; $621c
	ld hl,$5855		; $621f
	jp interactionSetScript		; $6222
	ld c,$20		; $6225
	call objectUpdateSpeedZ_paramC		; $6227
	call interactionAnimate		; $622a
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $622d
	call interactionRunScript		; $6230
	ret nc			; $6233
	ld e,$45		; $6234
	ld a,$02		; $6236
	ld (de),a		; $6238
	ld bc,$4858		; $6239
	call objectGetRelativeAngle		; $623c
	ld e,$49		; $623f
	ld (de),a		; $6241
	ret			; $6242
	call interactionAnimate		; $6243
	call objectApplySpeed		; $6246
	ld e,$4b		; $6249
	ld a,(de)		; $624b
	cp $48			; $624c
	ret c			; $624e
	ld h,d			; $624f
	ld l,$42		; $6250
	ld b,$06		; $6252
	call clearMemory		; $6254
	ld l,$40		; $6257
	ld (hl),$01		; $6259
	xor a			; $625b
	ld ($cca4),a		; $625c
	call objectGetTileAtPosition		; $625f
	ld (hl),$00		; $6262
	ld a,$28		; $6264
	ld (wActiveMusic),a		; $6266
	jp playSound		; $6269
	call returnIfScrollMode01Unset		; $626c
	ld e,$45		; $626f
	ld a,(de)		; $6271
	rst_jumpTable			; $6272
	ld (hl),a		; $6273
	ld h,d			; $6274
	adc b			; $6275
	ld h,d			; $6276
	ld a,$01		; $6277
	ld (de),a		; $6279
	call clearFollowingLinkObject		; $627a
	ld a,$0b		; $627d
	call unsetGlobalFlag		; $627f
	ld bc,$291a		; $6282
	jp showText		; $6285
	call retIfTextIsActive		; $6288
	jp interactionDelete		; $628b
	ld h,d			; $628e
	ld l,$48		; $628f
	ld a,(hl)		; $6291
	ld l,$72		; $6292
	cp (hl)			; $6294
	ret z			; $6295
	ld (hl),a		; $6296
	jp interactionSetAnimation		; $6297
	ld e,$44		; $629a
	ld a,(de)		; $629c
	rst_jumpTable			; $629d
	and d			; $629e
	ld h,d			; $629f
.DB $db				; $62a0
	ld h,d			; $62a1
	ld a,$01		; $62a2
	ld (de),a		; $62a4
	ld a,$0e		; $62a5
	call checkGlobalFlag		; $62a7
	jp nz,interactionDelete		; $62aa
	ld a,($cc9e)		; $62ad
	or a			; $62b0
	jp nz,interactionDelete		; $62b1
	ld a,d			; $62b4
	ld ($cc9e),a		; $62b5
	ld h,d			; $62b8
	ld l,$40		; $62b9
	set 1,(hl)		; $62bb
	call getRandomNumber		; $62bd
	and $03			; $62c0
	ld hl,$62d3		; $62c2
	rst_addDoubleIndex			; $62c5
	ld e,$70		; $62c6
	ldi a,(hl)		; $62c8
	ld (de),a		; $62c9
	inc e			; $62ca
	ld a,(hl)		; $62cb
	ld (de),a		; $62cc
	ld a,$ff		; $62cd
	ld e,$72		; $62cf
	ld (de),a		; $62d1
	ret			; $62d2
	ld h,l			; $62d3
	ld d,a			; $62d4
	ld h,(hl)		; $62d5
	ld d,(hl)		; $62d6
	ld (hl),l		; $62d7
	daa			; $62d8
	halt			; $62d9
	inc h			; $62da
	ld e,$72		; $62db
	ld a,(de)		; $62dd
	ld b,a			; $62de
	ld a,($cc4c)		; $62df
	cp b			; $62e2
	ret z			; $62e3
	ld (de),a		; $62e4
	ld b,a			; $62e5
	ld e,$70		; $62e6
	ld a,(de)		; $62e8
	cp b			; $62e9
	jr nz,_label_08_189	; $62ea
	call getFreeInteractionSlot		; $62ec
	ret nz			; $62ef
	ld (hl),$60		; $62f0
	inc l			; $62f2
	ld (hl),$45		; $62f3
	ld e,$71		; $62f5
	ld a,(de)		; $62f7
	ld l,$4b		; $62f8
	jp setShortPosition		; $62fa
_label_08_189:
	ld a,$45		; $62fd
	call checkTreasureObtained		; $62ff
	jr c,_label_08_191	; $6302
	ld a,b			; $6304
	cp $60			; $6305
	ret nc			; $6307
_label_08_190:
	xor a			; $6308
	ld ($cc9e),a		; $6309
	jp interactionDelete		; $630c
_label_08_191:
	ld a,$0e		; $630f
	call setGlobalFlag		; $6311
	jr _label_08_190		; $6314


; ==============================================================================
; INTERACID_SUBROSIAN_WITH_BUCKETS
; ==============================================================================
interactionCode32:
	ld e,$44		; $6316
	ld a,(de)		; $6318
	rst_jumpTable			; $6319
	ld e,$63		; $631a
	ld b,l			; $631c
	ld h,e			; $631d
	ld a,$01		; $631e
	ld (de),a		; $6320
	call interactionInitGraphics		; $6321
	ld h,d			; $6324
	ld l,$6b		; $6325
	ld (hl),$00		; $6327
	ld l,$49		; $6329
	ld (hl),$ff		; $632b
	ld l,$42		; $632d
	ld a,(hl)		; $632f
	ld hl,$6369		; $6330
	rst_addDoubleIndex			; $6333
	ldi a,(hl)		; $6334
	ld h,(hl)		; $6335
	ld l,a			; $6336
	call interactionSetScript		; $6337
	call interactionRunScript		; $633a
	call interactionRunScript		; $633d
	jp c,interactionDelete		; $6340
	jr _label_08_194		; $6343
	ld a,($cc49)		; $6345
	dec a			; $6348
	jr nz,_label_08_192	; $6349
	call objectGetTileAtPosition		; $634b
	ld (hl),$00		; $634e
_label_08_192:
	call interactionRunScript		; $6350
	ld c,$28		; $6353
	call objectCheckLinkWithinDistance		; $6355
	jr c,_label_08_193	; $6358
	ld a,$04		; $635a
_label_08_193:
	ld l,$49		; $635c
	cp (hl)			; $635e
	jr z,_label_08_194	; $635f
	ld (hl),a		; $6361
	rrca			; $6362
	call interactionSetAnimation		; $6363
_label_08_194:
	jp interactionAnimateAsNpc		; $6366
	ld h,c			; $6369
	ld e,b			; $636a
	ld h,h			; $636b
	ld e,b			; $636c
	ld l,e			; $636d
	ld e,b			; $636e
	ld (hl),c		; $636f
	ld e,b			; $6370
	ld (hl),h		; $6371
	ld e,b			; $6372
	ld (hl),a		; $6373
	ld e,b			; $6374
	ld h,c			; $6375
	ld e,b			; $6376
	ld h,c			; $6377
	ld e,b			; $6378


; ==============================================================================
; INTERACID_SUBROSIAN_SMITHS
; ==============================================================================
interactionCode34:
	call checkInteractionState		; $6379
	jr nz,_label_08_195	; $637c
	ld a,$01		; $637e
	ld (de),a		; $6380
	call interactionInitGraphics		; $6381
_label_08_195:
	call interactionAnimateAsNpc		; $6384
	ld e,$61		; $6387
	ld a,(de)		; $6389
	cp $ff			; $638a
	ret nz			; $638c
	ld a,$50		; $638d
	jp playSound		; $638f


; spawned from objectData
interactionCode35:
	ld e,$44		; $6392
	ld a,(de)		; $6394
	rst_jumpTable			; $6395
	sbc d			; $6396
	ld h,e			; $6397
	ld l,b			; $6398
	ld h,h			; $6399
	call $6537		; $639a
	call interactionInitGraphics		; $639d
	call interactionIncState		; $63a0
	ld e,$43		; $63a3
	ld a,(de)		; $63a5
	ld hl,$66c4		; $63a6
	rst_addDoubleIndex			; $63a9
	ldi a,(hl)		; $63aa
	ld h,(hl)		; $63ab
	ld l,a			; $63ac
	call interactionSetScript		; $63ad
	ld e,$43		; $63b0
	ld a,(de)		; $63b2
	rst_jumpTable			; $63b3
	xor $63			; $63b4
.DB $fc				; $63b6
	ld h,e			; $63b7
	ld hl,$3a64		; $63b8
	ld h,h			; $63bb
.DB $fc				; $63bc
	ld h,e			; $63bd
	ld hl,$3a64		; $63be
	ld h,h			; $63c1
	rst $30			; $63c2
	ld h,e			; $63c3
	jr z,_label_08_197	; $63c4
	ldd a,(hl)		; $63c6
	ld h,h			; $63c7
	ld b,e			; $63c8
	ld h,h			; $63c9
	ld b,a			; $63ca
	ld h,h			; $63cb
	ld h,b			; $63cc
	ld h,h			; $63cd
	ld h,h			; $63ce
	ld h,h			; $63cf
	ld b,e			; $63d0
	ld h,h			; $63d1
	ld c,(hl)		; $63d2
	ld h,h			; $63d3
	ld h,b			; $63d4
	ld h,h			; $63d5
	ld h,h			; $63d6
	ld h,h			; $63d7
	ld b,e			; $63d8
	ld h,h			; $63d9
	ld b,a			; $63da
	ld h,h			; $63db
	ld h,b			; $63dc
	ld h,h			; $63dd
	ld h,h			; $63de
	ld h,h			; $63df
	jr $64			; $63e0
	xor $63			; $63e2
	ldd a,(hl)		; $63e4
	ld h,h			; $63e5
	ld b,e			; $63e6
	ld h,h			; $63e7
	xor $63			; $63e8
	xor $63			; $63ea
	ld h,h			; $63ec
	ld h,h			; $63ed
	ld e,$77		; $63ee
	ld a,(de)		; $63f0
	call interactionSetAnimation		; $63f1
	jp $651f		; $63f4
	ld a,$02		; $63f7
	call $6618		; $63f9
	ld h,d			; $63fc
	ld l,$79		; $63fd
	ld (hl),$01		; $63ff
	ld l,$50		; $6401
	ld (hl),$3c		; $6403
	ld l,$49		; $6405
	ld (hl),$18		; $6407
	ld a,$00		; $6409
_label_08_196:
	ld h,d			; $640b
	ld l,$7a		; $640c
	ld (hl),a		; $640e
	ld l,$77		; $640f
	add (hl)		; $6411
	call interactionSetAnimation		; $6412
	jp $651f		; $6415
	call $63fc		; $6418
	ld h,d			; $641b
	ld l,$50		; $641c
	ld (hl),$28		; $641e
	ret			; $6420
	ld a,$00		; $6421
	call $6618		; $6423
	jr _label_08_198		; $6426
	ld a,$01		; $6428
_label_08_197:
	call $6618		; $642a
_label_08_198:
	ld h,d			; $642d
	ld l,$79		; $642e
	ld (hl),$01		; $6430
	ld l,$50		; $6432
	ld (hl),$50		; $6434
	ld a,$00		; $6436
	jr _label_08_196		; $6438
	ld h,d			; $643a
	ld l,$79		; $643b
	ld (hl),$02		; $643d
	ld a,$00		; $643f
	jr _label_08_196		; $6441
	ld a,$00		; $6443
	jr _label_08_196		; $6445
	ld a,$03		; $6447
	call $6618		; $6449
	jr _label_08_199		; $644c
	ld a,$04		; $644e
	call $6618		; $6450
_label_08_199:
	ld h,d			; $6453
	ld l,$79		; $6454
	ld (hl),$01		; $6456
	ld l,$50		; $6458
	ld (hl),$14		; $645a
	ld a,$00		; $645c
	jr _label_08_196		; $645e
	ld a,$03		; $6460
	jr _label_08_196		; $6462
	ld a,$00		; $6464
	jr _label_08_196		; $6466
	ld e,$43		; $6468
	ld a,(de)		; $646a
	rst_jumpTable			; $646b
	or d			; $646c
	ld h,h			; $646d
	and (hl)		; $646e
	ld h,h			; $646f
	cp e			; $6470
	ld h,h			; $6471
	jp c,$a664		; $6472
	ld h,h			; $6475
	cp e			; $6476
	ld h,h			; $6477
	jp c,$c664		; $6478
	ld h,h			; $647b
	cp e			; $647c
	ld h,h			; $647d
	jp c,$e764		; $647e
	ld h,h			; $6481
	add $64			; $6482
	xor a			; $6484
	ld h,h			; $6485
	nop			; $6486
	ld h,l			; $6487
	rst $20			; $6488
	ld h,h			; $6489
	add $64			; $648a
	xor a			; $648c
	ld h,h			; $648d
	nop			; $648e
	ld h,l			; $648f
	rst $20			; $6490
	ld h,h			; $6491
	add $64			; $6492
	xor a			; $6494
	ld h,h			; $6495
	nop			; $6496
	ld h,l			; $6497
	or l			; $6498
	ld h,h			; $6499
	or d			; $649a
	ld h,h			; $649b
.DB $e4				; $649c
	ld h,h			; $649d
	rst $20			; $649e
	ld h,h			; $649f
	or d			; $64a0
	ld h,h			; $64a1
	or d			; $64a2
	ld h,h			; $64a3
	nop			; $64a4
	ld h,l			; $64a5
	ld e,$46		; $64a6
	ld a,(de)		; $64a8
	or a			; $64a9
	jr nz,_label_08_200	; $64aa
	call $654b		; $64ac
_label_08_200:
	call interactionRunScript		; $64af
	jp $651c		; $64b2
	call $657f		; $64b5
	jp $651c		; $64b8
	ld e,$46		; $64bb
	ld a,(de)		; $64bd
	or a			; $64be
	jr nz,_label_08_201	; $64bf
	call $6593		; $64c1
_label_08_201:
	jr _label_08_206		; $64c4
	ld e,$46		; $64c6
	ld a,(de)		; $64c8
	or a			; $64c9
	jr nz,_label_08_202	; $64ca
	call $65b3		; $64cc
	call $65f4		; $64cf
	call $65cf		; $64d2
	call c,$660c		; $64d5
_label_08_202:
	jr _label_08_206		; $64d8
	call $667b		; $64da
	ld e,$7d		; $64dd
	ld a,(de)		; $64df
	or a			; $64e0
	call z,interactionRunScript		; $64e1
	jp $651c		; $64e4
	ld a,(wFrameCounter)		; $64e7
	and $1f			; $64ea
	jr nz,_label_08_204	; $64ec
	ld e,$61		; $64ee
	ld a,(de)		; $64f0
	and $01			; $64f1
	ld c,$08		; $64f3
	jr nz,_label_08_203	; $64f5
	ld c,$fc		; $64f7
_label_08_203:
	ld b,$f4		; $64f9
	call objectCreateFloatingMusicNote		; $64fb
_label_08_204:
	jr _label_08_206		; $64fe
	ld a,(wFrameCounter)		; $6500
	and $1f			; $6503
	jr nz,_label_08_206	; $6505
	ld e,$48		; $6507
	ld a,(de)		; $6509
	or a			; $650a
	ld c,$fc		; $650b
	jr z,_label_08_205	; $650d
	ld c,$00		; $650f
_label_08_205:
	ld b,$fc		; $6511
	call objectCreateFloatingMusicNote		; $6513
_label_08_206:
	call interactionRunScript		; $6516
	jp $651c		; $6519
	call interactionAnimate		; $651c
	ld e,$79		; $651f
	ld a,(de)		; $6521
	cp $01			; $6522
	jr z,_label_08_207	; $6524
	cp $02			; $6526
	jp z,objectSetPriorityRelativeToLink_withTerrainEffects		; $6528
	call objectPreventLinkFromPassing		; $652b
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $652e
_label_08_207:
	call objectPushLinkAwayOnCollision		; $6531
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6534
	ld e,$42		; $6537
	ld a,(de)		; $6539
	ld hl,$6543		; $653a
	rst_addAToHl			; $653d
	ld a,(hl)		; $653e
	ld e,$77		; $653f
	ld (de),a		; $6541
	ret			; $6542
	nop			; $6543
	ld (bc),a		; $6544
	dec b			; $6545
	ld ($110b),sp		; $6546
	dec d			; $6549
	rla			; $654a
	call objectApplySpeed		; $654b
	ld h,d			; $654e
	ld l,$4d		; $654f
	ld a,(hl)		; $6551
	sub $29			; $6552
	cp $40			; $6554
	ret c			; $6556
	bit 7,a			; $6557
	jr nz,_label_08_208	; $6559
	dec (hl)		; $655b
	dec (hl)		; $655c
_label_08_208:
	inc (hl)		; $655d
	ld l,$7c		; $655e
	ld a,(hl)		; $6560
	inc a			; $6561
	and $03			; $6562
	ld (hl),a		; $6564
	ld bc,$657b		; $6565
	call addAToBc		; $6568
	ld a,(bc)		; $656b
	ld l,$49		; $656c
	ld (hl),a		; $656e
_label_08_209:
	ld l,$7a		; $656f
	ld a,(hl)		; $6571
	xor $01			; $6572
	ld (hl),a		; $6574
	ld l,$77		; $6575
	add (hl)		; $6577
	jp interactionSetAnimation		; $6578
	jr _label_08_211		; $657b
	jr _label_08_210		; $657d
	call objectApplySpeed		; $657f
	ld e,$4d		; $6582
	ld a,(de)		; $6584
_label_08_210:
	sub $14			; $6585
_label_08_211:
	cp $28			; $6587
	ret c			; $6589
	ld h,d			; $658a
	ld l,$49		; $658b
	ld a,(hl)		; $658d
	xor $10			; $658e
	ld (hl),a		; $6590
	jr _label_08_209		; $6591
	ld e,$45		; $6593
	ld a,(de)		; $6595
	rst_jumpTable			; $6596
	sbc e			; $6597
	ld h,l			; $6598
	and h			; $6599
	ld h,l			; $659a
	ld c,$18		; $659b
	call objectCheckLinkWithinDistance		; $659d
	ret nc			; $65a0
	call interactionIncState2		; $65a1
	call $65b3		; $65a4
	call $65cf		; $65a7
	ret nc			; $65aa
	ld h,d			; $65ab
	ld l,$45		; $65ac
	ld (hl),$00		; $65ae
	jp $660c		; $65b0
	ld h,d			; $65b3
	ld l,$7c		; $65b4
	ld a,(hl)		; $65b6
	add a			; $65b7
	ld b,a			; $65b8
	ld e,$7f		; $65b9
	ld a,(de)		; $65bb
	ld l,a			; $65bc
	ld e,$7e		; $65bd
	ld a,(de)		; $65bf
	ld h,a			; $65c0
	ld a,b			; $65c1
	rst_addAToHl			; $65c2
	ld b,(hl)		; $65c3
	inc hl			; $65c4
	ld c,(hl)		; $65c5
	call objectGetRelativeAngle		; $65c6
	ld e,$49		; $65c9
	ld (de),a		; $65cb
	jp objectApplySpeed		; $65cc
	ld h,d			; $65cf
	ld l,$7c		; $65d0
	ld a,(hl)		; $65d2
	add a			; $65d3
	push af			; $65d4
	ld e,$7f		; $65d5
	ld a,(de)		; $65d7
	ld c,a			; $65d8
	ld e,$7e		; $65d9
	ld a,(de)		; $65db
	ld b,a			; $65dc
	pop af			; $65dd
	call addAToBc		; $65de
	ld l,$4b		; $65e1
	ld a,(bc)		; $65e3
	sub (hl)		; $65e4
	add $01			; $65e5
	cp $03			; $65e7
	ret nc			; $65e9
	inc bc			; $65ea
	ld l,$4d		; $65eb
	ld a,(bc)		; $65ed
	sub (hl)		; $65ee
	add $01			; $65ef
	cp $03			; $65f1
	ret			; $65f3
	ld h,d			; $65f4
	ld l,$49		; $65f5
	ld a,(hl)		; $65f7
	swap a			; $65f8
	and $01			; $65fa
	xor $01			; $65fc
	ld l,$48		; $65fe
	cp (hl)			; $6600
	ret z			; $6601
	ld (hl),a		; $6602
	ld l,$7a		; $6603
	add (hl)		; $6605
	ld l,$77		; $6606
	add (hl)		; $6608
	jp interactionSetAnimation		; $6609
	ld h,d			; $660c
	ld l,$7d		; $660d
	ld a,(hl)		; $660f
	ld l,$7c		; $6610
	inc (hl)		; $6612
	cp (hl)			; $6613
	ret nc			; $6614
	ld (hl),$00		; $6615
	ret			; $6617
	add a			; $6618
	add a			; $6619
	ld hl,$662b		; $661a
	rst_addAToHl			; $661d
	ld e,$7f		; $661e
	ldi a,(hl)		; $6620
	ld (de),a		; $6621
	ld e,$7e		; $6622
	ldi a,(hl)		; $6624
	ld (de),a		; $6625
	ld e,$7d		; $6626
	ldi a,(hl)		; $6628
	ld (de),a		; $6629
	ret			; $662a
	ccf			; $662b
	ld h,(hl)		; $662c
	rlca			; $662d
	nop			; $662e
	ld c,a			; $662f
	ld h,(hl)		; $6630
	inc bc			; $6631
	nop			; $6632
	ld d,a			; $6633
	ld h,(hl)		; $6634
	dec bc			; $6635
	nop			; $6636
	ld l,a			; $6637
	ld h,(hl)		; $6638
	ld bc,$7300		; $6639
	ld h,(hl)		; $663c
	inc bc			; $663d
	nop			; $663e
	ld l,b			; $663f
	jr $68			; $6640
	ld l,b			; $6642
	jr z,$68		; $6643
	ld l,b			; $6645
	jr _label_08_213		; $6646
	jr _label_08_217		; $6648
	ld l,b			; $664a
	jr z,$68		; $664b
	jr c,$18		; $664d
	jr $18			; $664f
	ld e,b			; $6651
	jr $58			; $6652
	ld c,b			; $6654
	jr $48			; $6655
	jr z,$48		; $6657
	jr $44			; $6659
	jr _label_08_214		; $665b
	jr nz,$18		; $665d
	inc l			; $665f
	inc c			; $6660
	jr c,_label_08_212	; $6661
	ld b,h			; $6663
	inc c			; $6664
	ld d,b			; $6665
	jr _label_08_219		; $6666
	jr z,_label_08_220	; $6668
	ld b,h			; $666a
_label_08_212:
	ld c,b			; $666b
	ld c,b			; $666c
	jr c,_label_08_218	; $666d
	ld c,b			; $666f
	jr $48			; $6670
	ld l,b			; $6672
	jr _label_08_216		; $6673
	ld e,b			; $6675
	jr nc,_label_08_221	; $6676
	ld c,b			; $6678
	jr $48			; $6679
	ld e,$45		; $667b
	ld a,(de)		; $667d
	rst_jumpTable			; $667e
	add l			; $667f
_label_08_213:
	ld h,(hl)		; $6680
	and e			; $6681
	ld h,(hl)		; $6682
	cp l			; $6683
	ld h,(hl)		; $6684
_label_08_214:
	ld h,d			; $6685
	ld l,$50		; $6686
	ld (hl),$28		; $6688
	ld l,$49		; $668a
	ld (hl),$18		; $668c
_label_08_215:
	ld h,d			; $668e
	ld l,$45		; $668f
	ld (hl),$01		; $6691
	ld l,$7d		; $6693
	ld (hl),$01		; $6695
	ld l,$54		; $6697
	ld (hl),$00		; $6699
	inc hl			; $669b
	ld (hl),$fb		; $669c
	ld a,$53		; $669e
	jp playSound		; $66a0
	ld c,$50		; $66a3
_label_08_216:
	call objectUpdateSpeedZ_paramC		; $66a5
	jp nz,objectApplySpeed		; $66a8
	call interactionIncState2		; $66ab
	ld l,$7d		; $66ae
	ld (hl),$00		; $66b0
_label_08_217:
	ld l,$7c		; $66b2
	ld (hl),$78		; $66b4
	ld l,$49		; $66b6
	ld a,(hl)		; $66b8
	xor $10			; $66b9
_label_08_218:
	ld (hl),a		; $66bb
	ret			; $66bc
	ld h,d			; $66bd
	ld l,$7c		; $66be
_label_08_219:
	dec (hl)		; $66c0
	ret nz			; $66c1
_label_08_220:
	jr _label_08_215		; $66c2
	ld a,d			; $66c4
	ld e,b			; $66c5
	ld a,e			; $66c6
	ld e,b			; $66c7
	add d			; $66c8
	ld e,b			; $66c9
	adc c			; $66ca
	ld e,b			; $66cb
	sub b			; $66cc
	ld e,b			; $66cd
	sbc e			; $66ce
	ld e,b			; $66cf
_label_08_221:
	and (hl)		; $66d0
	ld e,b			; $66d1
	or c			; $66d2
	ld e,b			; $66d3
	push hl			; $66d4
	ld e,b			; $66d5
	add hl,de		; $66d6
	ld e,c			; $66d7
	ld c,l			; $66d8
	ld e,c			; $66d9
	ld e,b			; $66da
	ld e,c			; $66db
	ld h,e			; $66dc
	ld e,c			; $66dd
	ld l,(hl)		; $66de
	ld e,c			; $66df
	ld a,c			; $66e0
	ld e,c			; $66e1
	ld (hl),$5a		; $66e2
	sbc d			; $66e4
	ld e,d			; $66e5
	ret nz			; $66e6
	ld e,d			; $66e7
	push hl			; $66e8
	ld e,d			; $66e9
	daa			; $66ea
	ld e,e			; $66eb
	ld (hl),l		; $66ec
	ld e,e			; $66ed
	adc l			; $66ee
	ld e,e			; $66ef
	ld a,d			; $66f0
	ld e,b			; $66f1
	ld a,d			; $66f2
	ld e,b			; $66f3
	ld a,d			; $66f4
	ld e,b			; $66f5
	ld a,d			; $66f6
	ld e,b			; $66f7
	ld a,d			; $66f8
	ld e,b			; $66f9
	ld a,d			; $66fa
	ld e,b			; $66fb
	ld a,d			; $66fc
	ld e,b			; $66fd


; ==============================================================================
; INTERACID_GORON
; ==============================================================================
interactionCode3b:
	call checkInteractionState		; $66fe
	jr nz,_label_08_225	; $6701
	ld a,$01		; $6703
	ld (de),a		; $6705
	xor a			; $6706
	ldh (<hFF8D),a	; $6707
	ld a,$41		; $6709
	call checkTreasureObtained		; $670b
	jr nc,_label_08_222	; $670e
	cp $05			; $6710
	jr c,_label_08_222	; $6712
	ld a,$01		; $6714
	ldh (<hFF8D),a	; $6716
_label_08_222:
	ld h,d			; $6718
	ld l,$42		; $6719
	ld a,(hl)		; $671b
	ld b,a			; $671c
	and $0f			; $671d
	ldi (hl),a		; $671f
	ld c,a			; $6720
	ld a,b			; $6721
	swap a			; $6722
	and $0f			; $6724
	ld (hl),a		; $6726
	ld a,c			; $6727
	ld c,$37		; $6728
	cp $07			; $672a
	jr nz,_label_08_223	; $672c
	ld a,($cc01)		; $672e
	ld b,a			; $6731
	ldh a,(<hFF8D)	; $6732
	and b			; $6734
	jp z,interactionDelete		; $6735
	ld c,$53		; $6738
_label_08_223:
	ld a,c			; $673a
	call interactionSetHighTextIndex		; $673b
	call interactionInitGraphics		; $673e
	ld hl,$6808		; $6741
	ldh a,(<hFF8D)	; $6744
	or a			; $6746
	jr z,_label_08_224	; $6747
	ld hl,_table_6818		; $6749
_label_08_224:
	ld e,$42		; $674c
	ld a,(de)		; $674e
	rst_addDoubleIndex			; $674f
	ldi a,(hl)		; $6750
	ld h,(hl)		; $6751
	ld l,a			; $6752
	call interactionSetScript		; $6753
_label_08_225:
	ld e,$43		; $6756
	ld a,(de)		; $6758
	rst_jumpTable			; $6759
	ld h,b			; $675a
	ld h,a			; $675b
	ld h,(hl)		; $675c
	ld h,a			; $675d
	cp (hl)			; $675e
	ld h,a			; $675f
	call interactionRunScript		; $6760
	jp npcFaceLinkAndAnimate		; $6763
	call interactionRunScript		; $6766
	ld e,$45		; $6769
	ld a,(de)		; $676b
	rst_jumpTable			; $676c
	ld (hl),l		; $676d
	ld h,a			; $676e
	adc d			; $676f
	ld h,a			; $6770
	sbc d			; $6771
	ld h,a			; $6772
	or c			; $6773
	ld h,a			; $6774
	ld c,$28		; $6775
	call objectCheckLinkWithinDistance		; $6777
	jr nc,_label_08_226	; $677a
	call interactionIncState2		; $677c
	call $67fc		; $677f
	add $06			; $6782
	call interactionSetAnimation		; $6784
_label_08_226:
	jp interactionAnimateAsNpc		; $6787
	ld e,$61		; $678a
	ld a,(de)		; $678c
	inc a			; $678d
	jr nz,_label_08_227	; $678e
	call interactionIncState2		; $6790
	ld l,$49		; $6793
	ld (hl),$ff		; $6795
_label_08_227:
	jp interactionAnimateAsNpc		; $6797
	ld c,$28		; $679a
	call objectCheckLinkWithinDistance		; $679c
	jr c,_label_08_228	; $679f
	call interactionIncState2		; $67a1
	call $67fc		; $67a4
	add $07			; $67a7
	call interactionSetAnimation		; $67a9
	jr _label_08_229		; $67ac
_label_08_228:
	jp npcFaceLinkAndAnimate		; $67ae
	ld e,$61		; $67b1
	ld a,(de)		; $67b3
	inc a			; $67b4
	jr nz,_label_08_229	; $67b5
	ld e,$45		; $67b7
	xor a			; $67b9
	ld (de),a		; $67ba
_label_08_229:
	jp interactionAnimateAsNpc		; $67bb
	call interactionAnimate		; $67be
	call interactionAnimate		; $67c1
	call checkInteractionState2		; $67c4
	jr nz,_label_08_231	; $67c7
	ld e,$71		; $67c9
	ld a,(de)		; $67cb
	or a			; $67cc
	jr z,_label_08_230	; $67cd
	xor a			; $67cf
	ld (de),a		; $67d0
	call objectGetAngleTowardLink		; $67d1
	add $04			; $67d4
	add a			; $67d6
	swap a			; $67d7
	and $03			; $67d9
	ld e,$48		; $67db
	ld (de),a		; $67dd
	call interactionSetAnimation		; $67de
	ld bc,$3700		; $67e1
	call showText		; $67e4
	call interactionIncState2		; $67e7
_label_08_230:
	call interactionRunScript		; $67ea
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $67ed
_label_08_231:
	ld e,$76		; $67f0
	ld a,(de)		; $67f2
	call interactionSetAnimation		; $67f3
	ld e,$45		; $67f6
	xor a			; $67f8
	ld (de),a		; $67f9
	jr _label_08_230		; $67fa
	ld e,$4d		; $67fc
	ld a,(de)		; $67fe
	ld hl,$d00d		; $67ff
	cp (hl)			; $6802
	ld a,$02		; $6803
	ret c			; $6805
	xor a			; $6806
	ret			; $6807
	xor a			; $6808
	ld e,e			; $6809
	jp nc,$d65b		; $680a
	ld e,e			; $680d
	sbc $5b			; $680e
.DB $ec				; $6810
	ld e,e			; $6811
	ld a,($ff00+$5b)	; $6812
	ld a,($ff00+c)		; $6814
	ld e,e			; $6815
	jr z,_label_08_235	; $6816

_table_6818:
	.dw script5baf
	.dw script5bd4
	.dw script5bd6
	.dw script5be4
	.dw script5bee
	.dw script5bf0
	.dw script5bf2
	.dw script5c28


; dragonflies?
interactionCode3e:
	call checkInteractionState		; $6828
	jp nz,seasonsFunc_08_68f5		; $682b
	ld a,$01		; $682e
	ld (de),a		; $6830
	ld h,d			; $6831
	ld l,$42		; $6832
	ld a,(hl)		; $6834
	ld b,a			; $6835
	and $0f			; $6836
	ldi (hl),a		; $6838
	ld a,b			; $6839
	and $f0			; $683a
	swap a			; $683c
	ld (hl),a		; $683e
	cp $03			; $683f
	jr nz,_label_08_233	; $6841
	call $5874		; $6843
	ld e,$42		; $6846
	ld a,(de)		; $6848
	cp b			; $6849
	jp nz,interactionDelete		; $684a
	cp $01			; $684d
	jr nz,_label_08_234	; $684f
	ld a,$16		; $6851
	call checkGlobalFlag		; $6853
	ld a,$6e		; $6856
	jr nz,_label_08_232	; $6858
	ld a,$5e		; $685a
_label_08_232:
	ld hl,$cc4c		; $685c
	cp (hl)			; $685f
	jp nz,interactionDelete		; $6860
	jr _label_08_234		; $6863
_label_08_233:
	add $04			; $6865
	ld b,a			; $6867
	call checkHoronVillageNPCShouldBeSeen_body@main		; $6868
	jp nc,interactionDelete		; $686b
_label_08_234:
	ld e,$42		; $686e
	ld a,b			; $6870
	ld (de),a		; $6871
	inc e			; $6872
	ld a,(de)		; $6873
_label_08_235:
	rst_jumpTable			; $6874
	ld a,l			; $6875
	ld l,b			; $6876
	sbc e			; $6877
	ld l,b			; $6878
	jp nz,$9b68		; $6879
	ld l,b			; $687c
	call $689b		; $687d
	call getFreeInteractionSlot		; $6880
	jr nz,_label_08_236	; $6883
	ld (hl),$83		; $6885
	ld bc,$00fd		; $6887
	call objectCopyPositionWithOffset		; $688a
	ld l,$4b		; $688d
	ld a,(hl)		; $688f
	ld l,$76		; $6890
	ld (hl),a		; $6892
	ld l,$4d		; $6893
	ld a,(hl)		; $6895
	ld l,$77		; $6896
	ld (hl),a		; $6898
_label_08_236:
	jr _label_08_237		; $6899
	ld h,d			; $689b
	ld l,$42		; $689c
	ldi a,(hl)		; $689e
	push af			; $689f
	ldd a,(hl)		; $68a0
	ld (hl),a		; $68a1
	call interactionInitGraphics		; $68a2
	pop af			; $68a5
	ld e,$42		; $68a6
	ld (de),a		; $68a8
	inc e			; $68a9
	ld a,(de)		; $68aa
	ld hl,_table_6ac9		; $68ab
	rst_addDoubleIndex			; $68ae
	ldi a,(hl)		; $68af
	ld h,(hl)		; $68b0
	ld l,a			; $68b1
	ld e,$42		; $68b2
	ld a,(de)		; $68b4
	rst_addDoubleIndex			; $68b5
	ldi a,(hl)		; $68b6
	ld h,(hl)		; $68b7
	ld l,a			; $68b8
	call interactionSetScript		; $68b9
	call interactionRunScript		; $68bc
	jp objectSetVisible82		; $68bf
	ld a,($cc4e)		; $68c2
	cp $03			; $68c5
	jp z,interactionDelete		; $68c7
	call $689b		; $68ca
	ld a,($cc4e)		; $68cd
	cp $00			; $68d0
	ret nz			; $68d2
	ld h,d			; $68d3
	ld l,$49		; $68d4
	ld (hl),$08		; $68d6
	ld l,$50		; $68d8
	ld (hl),$28		; $68da
	ld l,$4b		; $68dc
	ld (hl),$62		; $68de
	ld l,$4d		; $68e0
	ld (hl),$28		; $68e2
	ld a,$06		; $68e4
	jp interactionSetAnimation		; $68e6
_label_08_237:
	call getRandomNumber		; $68e9
	and $3f			; $68ec
	add $78			; $68ee
	ld h,d			; $68f0
	ld l,$76		; $68f1
	ld (hl),a		; $68f3
	ret			; $68f4

seasonsFunc_08_68f5:
	ld e,$43		; $68f5
	ld a,(de)		; $68f7
	rst_jumpTable			; $68f8
	ld bc,$3969		; $68f9
	ld l,c			; $68fc
	ld e,d			; $68fd
	ld l,c			; $68fe
	ld d,h			; $68ff
	ld l,c			; $6900
	ld e,$45		; $6901
	ld a,(de)		; $6903
	rst_jumpTable			; $6904
	add hl,bc		; $6905
	ld l,c			; $6906
	jr nz,_label_08_242	; $6907
	call $6abc		; $6909
	jr nz,_label_08_238	; $690c
	ld l,$60		; $690e
	ld (hl),$01		; $6910
	call interactionIncState2		; $6912
	ld hl,$cceb		; $6915
	ld (hl),$01		; $6918
	call interactionAnimate		; $691a
_label_08_238:
	jp $6933		; $691d
	ld a,($cceb)		; $6920
	cp $02			; $6923
	jr nz,_label_08_239	; $6925
	call $68e9		; $6927
	ld l,$45		; $692a
	ld (hl),$00		; $692c
	ld a,$08		; $692e
	call interactionSetAnimation		; $6930
_label_08_239:
	call interactionRunScript		; $6933
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $6936
	ld h,d			; $6939
	ld l,$42		; $693a
	ld a,(hl)		; $693c
	cp $02			; $693d
	jr c,_label_08_241	; $693f
	call checkInteractionState2		; $6941
	jr nz,_label_08_240	; $6944
	call interactionIncState2		; $6946
	xor a			; $6949
	ld l,$4e		; $694a
	ldi (hl),a		; $694c
	ld (hl),a		; $694d
	call $5dfe		; $694e
_label_08_240:
	call seasonsFunc_08_5df7		; $6951
_label_08_241:
	call interactionRunScript		; $6954
	jp interactionAnimateAsNpc		; $6957
	ld a,($cc4e)		; $695a
	cp $00			; $695d
	jp nz,_label_08_241		; $695f
	ld e,$45		; $6962
	ld a,(de)		; $6964
	rst_jumpTable			; $6965
	add b			; $6966
	ld l,c			; $6967
	xor h			; $6968
	ld l,c			; $6969
	cp e			; $696a
	ld l,c			; $696b
	ret c			; $696c
	ld l,c			; $696d
.DB $e4				; $696e
	ld l,c			; $696f
	ld b,$6a		; $6970
_label_08_242:
	ld a,(de)		; $6972
	ld l,d			; $6973
	ld hl,$496a		; $6974
	ld l,d			; $6977
	ld e,e			; $6978
	ld l,d			; $6979
	ld c,c			; $697a
	ld l,d			; $697b
	ld a,a			; $697c
	ld l,d			; $697d
	and (hl)		; $697e
	ld l,d			; $697f
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6980
	jr nc,_label_08_243	; $6983
	ld h,d			; $6985
	ld l,$77		; $6986
	ld (hl),$0c		; $6988
_label_08_243:
	call $6ac1		; $698a
	jp nz,_label_08_251		; $698d
	call objectApplySpeed		; $6990
	cp $4b			; $6993
	jr c,_label_08_244	; $6995
	call interactionIncState2		; $6997
	ld bc,$fe80		; $699a
	call objectSetSpeedZ		; $699d
	ld l,$50		; $69a0
	ld (hl),$14		; $69a2
	ld a,$09		; $69a4
	call interactionSetAnimation		; $69a6
_label_08_244:
	jp $6ab3		; $69a9
	ld a,($ccc3)		; $69ac
	or a			; $69af
	ret nz			; $69b0
	inc a			; $69b1
	ld ($ccc3),a		; $69b2
	call interactionIncState2		; $69b5
	jp objectSetVisiblec2		; $69b8
	ld c,$20		; $69bb
	call objectUpdateSpeedZ_paramC		; $69bd
	jp nz,objectApplySpeed		; $69c0
	call interactionIncState2		; $69c3
	ld l,$76		; $69c6
	ld (hl),$28		; $69c8
	call objectCenterOnTile		; $69ca
	ld l,$4b		; $69cd
	ld a,(hl)		; $69cf
	sub $05			; $69d0
	ld (hl),a		; $69d2
	ld a,$06		; $69d3
	jp interactionSetAnimation		; $69d5
	call $6abc		; $69d8
	ret nz			; $69db
	call interactionIncState2		; $69dc
	ld a,$05		; $69df
	jp interactionSetAnimation		; $69e1
	ld e,$4f		; $69e4
	ld a,($ccc3)		; $69e6
	ld (de),a		; $69e9
	or a			; $69ea
	ret nz			; $69eb
	call interactionIncState2		; $69ec
	ld bc,$fd40		; $69ef
	call objectSetSpeedZ		; $69f2
	ld l,$4f		; $69f5
	ld (hl),$f6		; $69f7
	ld l,$50		; $69f9
	ld (hl),$28		; $69fb
	ld l,$49		; $69fd
	ld (hl),$00		; $69ff
	ld a,$53		; $6a01
	jp playSound		; $6a03
	ld c,$20		; $6a06
	call objectUpdateSpeedZ_paramC		; $6a08
	jp nz,objectApplySpeed		; $6a0b
	call interactionIncState2		; $6a0e
	ld l,$76		; $6a11
	ld (hl),$10		; $6a13
	ld l,$71		; $6a15
	ld (hl),$00		; $6a17
	ret			; $6a19
	call $6abc		; $6a1a
	ret nz			; $6a1d
	jp interactionIncState2		; $6a1e
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6a21
	jr nc,_label_08_245	; $6a24
	ld h,d			; $6a26
	ld l,$77		; $6a27
	ld (hl),$0c		; $6a29
_label_08_245:
	call $6ac1		; $6a2b
	jp nz,_label_08_251		; $6a2e
	call objectApplySpeed		; $6a31
	ld e,$4b		; $6a34
	ld a,(de)		; $6a36
	cp $28			; $6a37
	jr nc,_label_08_246	; $6a39
	call interactionIncState2		; $6a3b
	ld l,$76		; $6a3e
	ld (hl),$06		; $6a40
	ld l,$49		; $6a42
	ld (hl),$18		; $6a44
_label_08_246:
	jp $6ab3		; $6a46
	call $6abc		; $6a49
	ret nz			; $6a4c
	ld l,$49		; $6a4d
	ld a,(hl)		; $6a4f
	swap a			; $6a50
	rlca			; $6a52
	add $05			; $6a53
	call interactionSetAnimation		; $6a55
	jp interactionIncState2		; $6a58
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6a5b
	jr nc,_label_08_247	; $6a5e
	ld h,d			; $6a60
	ld l,$77		; $6a61
	ld (hl),$0c		; $6a63
_label_08_247:
	call $6ac1		; $6a65
	jr nz,_label_08_251	; $6a68
	call objectApplySpeed		; $6a6a
	cp $18			; $6a6d
	jr nc,_label_08_248	; $6a6f
	call interactionIncState2		; $6a71
	ld l,$76		; $6a74
	ld (hl),$06		; $6a76
	ld l,$49		; $6a78
	ld (hl),$10		; $6a7a
_label_08_248:
	jp $6ab3		; $6a7c
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6a7f
	jr nc,_label_08_249	; $6a82
	ld h,d			; $6a84
	ld l,$77		; $6a85
	ld (hl),$0c		; $6a87
_label_08_249:
	call $6ac1		; $6a89
	jr nz,_label_08_251	; $6a8c
	call objectApplySpeed		; $6a8e
	ld e,$4b		; $6a91
	ld a,(de)		; $6a93
	cp $62			; $6a94
	jr c,_label_08_250	; $6a96
	call interactionIncState2		; $6a98
	ld l,$76		; $6a9b
	ld (hl),$06		; $6a9d
	ld l,$49		; $6a9f
	ld (hl),$08		; $6aa1
_label_08_250:
	jp $6ab3		; $6aa3
	call $6abc		; $6aa6
	ret nz			; $6aa9
	ld l,$45		; $6aaa
	ld (hl),$00		; $6aac
	ld a,$06		; $6aae
	jp interactionSetAnimation		; $6ab0
	call interactionAnimate		; $6ab3
_label_08_251:
	call interactionRunScript		; $6ab6
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6ab9
	ld h,d			; $6abc
	ld l,$76		; $6abd
	dec (hl)		; $6abf
	ret			; $6ac0
	ld h,d			; $6ac1
	ld l,$77		; $6ac2
	ld a,(hl)		; $6ac4
	or a			; $6ac5
	ret z			; $6ac6
	dec (hl)		; $6ac7
	ret			; $6ac8

_table_6ac9:
	.dw _table_6ad1
	.dw _table_6ae7
	.dw _table_6afd
	.dw _table_6b13

_table_6ad1:
	.dw script5c46
	.dw script5c49
	.dw script5c49
	.dw script5c54
	.dw script5c5a
	.dw script5c5a
	.dw script5c5d
	.dw script5c5d
	.dw script5c60
	.dw script5c57
	.dw script5c5a

_table_6ae7:
	.dw script5c63
	.dw script5c63
	.dw script5c6e
	.dw script5c6e
	.dw script5c85
	.dw script5c88
	.dw script5c8b
	.dw script5c9f
	.dw script5ca9
	.dw script5c6e
	.dw script5c88

_table_6afd:
	.dw script5cb3
	.dw script5cb3
	.dw script5cb3
	.dw script5cb3
	.dw script5cc5
	.dw script5cc5
	.dw script5cc5
	.dw script5cc5
	.dw script5cc5
	.dw script5cb3
	.dw script5cc8

_table_6b13:
	.dw script5ccb
	.dw script5cd2
	.dw script5ce6
	.dw script5ce9
	.dw script5ce6


; pirates
interactionCode40:
interactionCode41:
	ld e,$44		; $6b1d
	ld a,(de)		; $6b1f
	rst_jumpTable			; $6b20
	dec h			; $6b21
	ld l,e			; $6b22
	or c			; $6b23
	ld l,e			; $6b24
	ld e,$42		; $6b25
	ld a,(de)		; $6b27
	rst_jumpTable			; $6b28
	ld b,a			; $6b29
	ld l,e			; $6b2a
	ld c,d			; $6b2b
	ld l,e			; $6b2c
	ld c,d			; $6b2d
	ld l,e			; $6b2e
	ld c,d			; $6b2f
	ld l,e			; $6b30
	ld c,d			; $6b31
	ld l,e			; $6b32
	ld c,d			; $6b33
	ld l,e			; $6b34
	ld c,d			; $6b35
	ld l,e			; $6b36
	ld d,a			; $6b37
	ld l,e			; $6b38
	ld d,a			; $6b39
	ld l,e			; $6b3a
	ld c,d			; $6b3b
	ld l,e			; $6b3c
	ld a,(hl)		; $6b3d
	ld l,e			; $6b3e
	ld e,(hl)		; $6b3f
	ld l,e			; $6b40
	ld e,(hl)		; $6b41
	ld l,e			; $6b42
	ld e,(hl)		; $6b43
	ld l,e			; $6b44
	ld e,(hl)		; $6b45
	ld l,e			; $6b46
	call $6c3c		; $6b47
	ld a,$13		; $6b4a
	call checkGlobalFlag		; $6b4c
	jp nz,interactionDelete		; $6b4f
	call objectGetTileAtPosition		; $6b52
	ld (hl),$00		; $6b55
	call $6b91		; $6b57
	ld a,$04		; $6b5a
	jr _label_08_253		; $6b5c
	ld a,$13		; $6b5e
	call checkGlobalFlag		; $6b60
	jp z,interactionDelete		; $6b63
	ld a,$17		; $6b66
	call checkGlobalFlag		; $6b68
	jp nz,interactionDelete		; $6b6b
	call $6b91		; $6b6e
	ld e,$42		; $6b71
	ld a,(de)		; $6b73
	cp $0d			; $6b74
	ld a,$00		; $6b76
	jr z,_label_08_252	; $6b78
	ld a,$04		; $6b7a
_label_08_252:
	jr _label_08_253		; $6b7c
	call getThisRoomFlags		; $6b7e
	bit 6,(hl)		; $6b81
	jp nz,interactionDelete		; $6b83
	call $6b91		; $6b86
	ld a,$04		; $6b89
_label_08_253:
	call interactionSetAnimation		; $6b8b
	jp $6bc4		; $6b8e
	call interactionInitGraphics		; $6b91
	ld h,d			; $6b94
	ld l,$44		; $6b95
	ld (hl),$01		; $6b97
	ld a,$3a		; $6b99
	call interactionSetHighTextIndex		; $6b9b
	call $6c29		; $6b9e
	ld e,$42		; $6ba1
	ld a,(de)		; $6ba3
	ld hl,_table_6cbf		; $6ba4
	rst_addDoubleIndex			; $6ba7
	ldi a,(hl)		; $6ba8
	ld h,(hl)		; $6ba9
	ld l,a			; $6baa
	call interactionSetScript		; $6bab
	jp interactionRunScript		; $6bae
	ld e,$42		; $6bb1
	ld a,(de)		; $6bb3
	cp $08			; $6bb4
	jr nz,_label_08_254	; $6bb6
	call $6c51		; $6bb8
_label_08_254:
	call interactionRunScript		; $6bbb
	jp c,interactionDelete		; $6bbe
	jp $6bc4		; $6bc1
	call interactionAnimate		; $6bc4
	ld e,$7c		; $6bc7
	ld a,(de)		; $6bc9
	or a			; $6bca
	jr nz,_label_08_256	; $6bcb
	ld e,$60		; $6bcd
	ld a,(de)		; $6bcf
	dec a			; $6bd0
	jr nz,_label_08_255	; $6bd1
	call getRandomNumber_noPreserveVars		; $6bd3
	and $1f			; $6bd6
	ld hl,$6c09		; $6bd8
	rst_addAToHl			; $6bdb
	ld a,(hl)		; $6bdc
	or a			; $6bdd
	jr z,_label_08_255	; $6bde
	ld e,$60		; $6be0
	ld (de),a		; $6be2
_label_08_255:
	call objectPreventLinkFromPassing		; $6be3
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6be6
_label_08_256:
	ld e,$50		; $6be9
	ld a,(de)		; $6beb
	cp $28			; $6bec
	jr z,_label_08_257	; $6bee
	cp $50			; $6bf0
	jr z,_label_08_258	; $6bf2
	ret			; $6bf4
_label_08_257:
	ld e,$60		; $6bf5
	ld a,(de)		; $6bf7
	cp $09			; $6bf8
	ret nz			; $6bfa
	jr _label_08_259		; $6bfb
_label_08_258:
	ld e,$60		; $6bfd
	ld a,(de)		; $6bff
	cp $0c			; $6c00
	ret nz			; $6c02
_label_08_259:
	ld e,$60		; $6c03
	ld a,$01		; $6c05
	ld (de),a		; $6c07
	ret			; $6c08
	nop			; $6c09
	nop			; $6c0a
	inc b			; $6c0b
	inc b			; $6c0c
	nop			; $6c0d
	nop			; $6c0e
	ld ($0008),sp		; $6c0f
	nop			; $6c12
	nop			; $6c13
	nop			; $6c14
	inc b			; $6c15
	inc b			; $6c16
	nop			; $6c17
	nop			; $6c18
	nop			; $6c19
	ld ($0008),sp		; $6c1a
	nop			; $6c1d
	nop			; $6c1e
	stop			; $6c1f
	stop			; $6c20
	nop			; $6c21
	nop			; $6c22
	nop			; $6c23
	jr nz,_label_08_262	; $6c24
	nop			; $6c26
	nop			; $6c27
	nop			; $6c28
	ld a,$40		; $6c29
	call checkTreasureObtained		; $6c2b
	jr c,_label_08_260	; $6c2e
	xor a			; $6c30
_label_08_260:
	cp $20			; $6c31
	ld a,$01		; $6c33
	jr nc,_label_08_261	; $6c35
	xor a			; $6c37
_label_08_261:
	ld e,$7a		; $6c38
	ld (de),a		; $6c3a
	ret			; $6c3b
	ld a,$4a		; $6c3c
	call checkTreasureObtained		; $6c3e
	jr c,_label_08_262	; $6c41
	xor a			; $6c43
	jr _label_08_263		; $6c44
_label_08_262:
	or a			; $6c46
	ld a,$01		; $6c47
	jr z,_label_08_263	; $6c49
	ld a,$02		; $6c4b
_label_08_263:
	ld e,$7b		; $6c4d
	ld (de),a		; $6c4f
	ret			; $6c50
	call $6c8b		; $6c51
	jr z,_label_08_265	; $6c54
	ld a,($cc46)		; $6c56
	bit 6,a			; $6c59
	jr z,_label_08_264	; $6c5b
	ld c,$01		; $6c5d
	ld b,$db		; $6c5f
	jp $6c78		; $6c61
_label_08_264:
	ld a,($cc45)		; $6c64
	bit 6,a			; $6c67
	ret nz			; $6c69
_label_08_265:
	ld h,d			; $6c6a
	ld l,$7e		; $6c6b
	ld a,$00		; $6c6d
	cp (hl)			; $6c6f
	ret z			; $6c70
	ld c,$00		; $6c71
	ld b,$d9		; $6c73
	jp $6c78		; $6c75
	ld h,d			; $6c78
	ld l,$7e		; $6c79
	ld (hl),c		; $6c7b
	ld a,$05		; $6c7c
	ld l,$7f		; $6c7e
	add (hl)		; $6c80
	ld c,a			; $6c81
	ld a,b			; $6c82
	call setTile		; $6c83
	ld a,$70		; $6c86
	jp playSound		; $6c88
	ld hl,$6cb2		; $6c8b
	ld a,($d00b)		; $6c8e
	ld c,a			; $6c91
	ld a,($d00d)		; $6c92
	ld b,a			; $6c95
_label_08_266:
	ldi a,(hl)		; $6c96
	or a			; $6c97
	ret z			; $6c98
	add $04			; $6c99
	sub c			; $6c9b
	cp $09			; $6c9c
	jr nc,_label_08_267	; $6c9e
	ldi a,(hl)		; $6ca0
	add $03			; $6ca1
	sub b			; $6ca3
	cp $07			; $6ca4
	jr nc,_label_08_268	; $6ca6
	ld a,(hl)		; $6ca8
	ld e,$7f		; $6ca9
	ld (de),a		; $6cab
	or d			; $6cac
	ret			; $6cad
_label_08_267:
	inc hl			; $6cae
_label_08_268:
	inc hl			; $6caf
	jr _label_08_266		; $6cb0
	jr $58			; $6cb2
	nop			; $6cb4
	jr $68			; $6cb5
	ld bc,$7818		; $6cb7
	ld (bc),a		; $6cba
	jr -$78			; $6cbb
	inc bc			; $6cbd
	nop			; $6cbe

_table_6cbf:
	.dw script5cec
	.dw script5d85
	.dw script5d85
	.dw script5d85
	.dw script5d85
	.dw script5dbc
	.dw script5dbc
	.dw script5ddd
	.dw script5e4b
	.dw script5e74
	.dw script5e76
	.dw script5e93
	.dw script5e97
	.dw script5ec9
	.dw script5ee5


; pirate captain and a pirate upstairs
interactionCode42:
	ld e,$44		; $6cdd
	ld a,(de)		; $6cdf
	rst_jumpTable			; $6ce0
	push hl			; $6ce1
	ld l,h			; $6ce2
	ld c,$6d		; $6ce3
	ld a,$13		; $6ce5
	call checkGlobalFlag		; $6ce7
	ld b,$00		; $6cea
	jr nz,_label_08_269	; $6cec
	inc b			; $6cee
_label_08_269:
	ld e,$42		; $6cef
	ld a,(de)		; $6cf1
	cp b			; $6cf2
	jp z,interactionDelete		; $6cf3
	call interactionInitGraphics		; $6cf6
	call interactionIncState		; $6cf9
	ld l,$42		; $6cfc
	ld a,(hl)		; $6cfe
	ld hl,_table_6d14		; $6cff
	rst_addDoubleIndex			; $6d02
	ldi a,(hl)		; $6d03
	ld h,(hl)		; $6d04
	ld l,a			; $6d05
	call interactionSetScript		; $6d06
	ld a,$02		; $6d09
	call interactionSetAnimation		; $6d0b
	call interactionRunScript		; $6d0e
	jp npcFaceLinkAndAnimate		; $6d11

_table_6d14:
	.dw script5f1c
	.dw script5f1f


; ==============================================================================
; INTERACID_SYRUP
; ==============================================================================
interactionCode43:
	call checkReloadShopItemTiles		; $6d18
	call $6d21		; $6d1b
	jp interactionAnimateAsNpc		; $6d1e
	ld e,$44		; $6d21
	ld a,(de)		; $6d23
	rst_jumpTable			; $6d24
	dec hl			; $6d25
	ld l,l			; $6d26
	ld c,a			; $6d27
	ld l,l			; $6d28
	push bc			; $6d29
	ld l,l			; $6d2a
	ld a,$01		; $6d2b
	ld (de),a		; $6d2d
	call interactionInitGraphics		; $6d2e
	call interactionSetAlwaysUpdateBit		; $6d31
	ld l,$66		; $6d34
	ld (hl),$12		; $6d36
	inc l			; $6d38
	ld (hl),$07		; $6d39
	ld e,$71		; $6d3b
	call objectAddToAButtonSensitiveObjectList		; $6d3d
	call getThisRoomFlags		; $6d40
	and $40			; $6d43
	ld hl,$5f22		; $6d45
	jr z,_label_08_270	; $6d48
	ld hl,$5f50		; $6d4a
_label_08_270:
	jr _label_08_278		; $6d4d
	ld e,$71		; $6d4f
	ld a,(de)		; $6d51
	or a			; $6d52
	ret z			; $6d53
	xor a			; $6d54
	ld (de),a		; $6d55
	ld a,$81		; $6d56
	ld ($cca4),a		; $6d58
	ld a,($cc75)		; $6d5b
	or a			; $6d5e
	jr z,_label_08_276	; $6d5f
	ld a,($d019)		; $6d61
	ld h,a			; $6d64
	ld e,$7c		; $6d65
	ld (de),a		; $6d67
	ld l,$42		; $6d68
	ld a,(hl)		; $6d6a
	push af			; $6d6b
	ld b,a			; $6d6c
	sub $07			; $6d6d
	ld e,$78		; $6d6f
	ld (de),a		; $6d71
	ld a,b			; $6d72
	ld hl,_shopItemPrices		; $6d73
	rst_addAToHl			; $6d76
	ld a,(hl)		; $6d77
	call cpRupeeValue		; $6d78
	ld e,$79		; $6d7b
	ld (de),a		; $6d7d
	ld ($cbad),a		; $6d7e
	pop af			; $6d81
	cp $07			; $6d82
	jr z,_label_08_273	; $6d84
	cp $09			; $6d86
	jr z,_label_08_273	; $6d88
	cp $0b			; $6d8a
	jr z,_label_08_271	; $6d8c
	ld a,($c6ba)		; $6d8e
	jr _label_08_272		; $6d91
_label_08_271:
	ld a,($c6ad)		; $6d93
_label_08_272:
	cp $99			; $6d96
	ld a,$01		; $6d98
	jr nc,_label_08_275	; $6d9a
	jr _label_08_274		; $6d9c
_label_08_273:
	ld a,$2f		; $6d9e
	call checkTreasureObtained		; $6da0
	ld a,$01		; $6da3
	jr c,_label_08_275	; $6da5
_label_08_274:
	xor a			; $6da7
_label_08_275:
	ld e,$7a		; $6da8
	ld (de),a		; $6daa
	ld hl,$5f68		; $6dab
	jr _label_08_278		; $6dae
_label_08_276:
	call _shopkeeperCheckAllItemsBought		; $6db0
	jr z,_label_08_277	; $6db3
	ld hl,$5f64		; $6db5
	jr _label_08_278		; $6db8
_label_08_277:
	ld hl,$5f60		; $6dba
_label_08_278:
	ld e,$44		; $6dbd
	ld a,$02		; $6dbf
	ld (de),a		; $6dc1
	jp interactionSetScript		; $6dc2
	call interactionRunScript		; $6dc5
	ret nc			; $6dc8
	xor a			; $6dc9
	ld ($cca4),a		; $6dca
	ld e,$7b		; $6dcd
	ld a,(de)		; $6dcf
	or a			; $6dd0
	jr z,_label_08_280	; $6dd1
	inc a			; $6dd3
	ld c,$03		; $6dd4
	jr nz,_label_08_279	; $6dd6
	ld c,$04		; $6dd8
_label_08_279:
	xor a			; $6dda
	ld (de),a		; $6ddb
	ld e,$7c		; $6ddc
	ld a,(de)		; $6dde
	ld h,a			; $6ddf
	ld l,$44		; $6de0
	ld (hl),c		; $6de2
	call dropLinkHeldItem		; $6de3
_label_08_280:
	ld e,$44		; $6de6
	ld a,$01		; $6de8
	ld (de),a		; $6dea
	ret			; $6deb


; ==============================================================================
; INTERACID_ZELDA
; ==============================================================================
interactionCode44:
	ld e,$44		; $6dec
	ld a,(de)		; $6dee
	rst_jumpTable			; $6def
.DB $f4				; $6df0
	ld l,l			; $6df1
	ld h,d			; $6df2
	ld l,(hl)		; $6df3
	ld a,$01		; $6df4
	ld (de),a		; $6df6
	ld e,$42		; $6df7
	ld a,(de)		; $6df9
	ld b,a			; $6dfa
	ld hl,_table_6ea3		; $6dfb
	rst_addDoubleIndex			; $6dfe
	ldi a,(hl)		; $6dff
	ld h,(hl)		; $6e00
	ld l,a			; $6e01
	call interactionSetScript		; $6e02
	ld a,b			; $6e05
	or a			; $6e06
	jr z,_label_08_282	; $6e07
	cp $08			; $6e09
	jr z,_label_08_284	; $6e0b
	cp $09			; $6e0d
	jr z,_label_08_285	; $6e0f
_label_08_281:
	call objectSetVisible82		; $6e11
	call interactionInitGraphics		; $6e14
	jr _label_08_286		; $6e17
_label_08_282:
	ld a,$b0		; $6e19
	ld ($cc1d),a		; $6e1b
	ld ($cc17),a		; $6e1e
	call getThisRoomFlags		; $6e21
	bit 7,a			; $6e24
	jr z,_label_08_283	; $6e26
	ld a,$01		; $6e28
	ld ($ccab),a		; $6e2a
	ld a,(wActiveMusic)		; $6e2d
	or a			; $6e30
	jr z,_label_08_283	; $6e31
	xor a			; $6e33
	ld (wActiveMusic),a		; $6e34
	ld a,$38		; $6e37
	call playSound		; $6e39
_label_08_283:
	ld hl,$cbb3		; $6e3c
	ld b,$10		; $6e3f
	call clearMemory		; $6e41
	jr _label_08_281		; $6e44
_label_08_284:
	call seasonsFunc_3d3d		; $6e46
	bit 7,c			; $6e49
	jp nz,interactionDelete		; $6e4b
	jr _label_08_281		; $6e4e
_label_08_285:
	ld a,$23		; $6e50
	call checkGlobalFlag		; $6e52
	jp z,interactionDelete		; $6e55
	ld a,$1e		; $6e58
	call checkGlobalFlag		; $6e5a
	jp nz,interactionDelete		; $6e5d
	jr _label_08_281		; $6e60
_label_08_286:
	ld e,$42		; $6e62
	ld a,(de)		; $6e64
	rst_jumpTable			; $6e65
	ld a,d			; $6e66
	ld l,(hl)		; $6e67
	ld a,d			; $6e68
	ld l,(hl)		; $6e69
	ld a,d			; $6e6a
	ld l,(hl)		; $6e6b
	ld a,d			; $6e6c
	ld l,(hl)		; $6e6d
	ld a,d			; $6e6e
	ld l,(hl)		; $6e6f
	add b			; $6e70
	ld l,(hl)		; $6e71
	adc e			; $6e72
	ld l,(hl)		; $6e73
	sub h			; $6e74
	ld l,(hl)		; $6e75
	sbc d			; $6e76
	ld l,(hl)		; $6e77
	sub h			; $6e78
	ld l,(hl)		; $6e79
_label_08_287:
	call interactionRunScript		; $6e7a
	jp interactionAnimate		; $6e7d
	call interactionRunScript		; $6e80
	ld e,$47		; $6e83
	ld a,(de)		; $6e85
	or a			; $6e86
	jp nz,interactionAnimate		; $6e87
	ret			; $6e8a
	call interactionRunScript		; $6e8b
	jp c,interactionDelete		; $6e8e
	jp interactionAnimate		; $6e91
_label_08_288:
	call interactionRunScript		; $6e94
	jp npcFaceLinkAndAnimate		; $6e97
	ld a,$26		; $6e9a
	call checkGlobalFlag		; $6e9c
	jr nz,_label_08_288	; $6e9f
	jr _label_08_287		; $6ea1

_table_6ea3:
	.dw script5fc3
	.dw script5fde
	.dw script5fe2
	.dw script5fe6
	.dw script5fe6
	.dw script5fea
	.dw script5fee
	.dw script601c
	.dw script601f
	.dw script6056


; ==============================================================================
; INTERACID_TALON
; ==============================================================================
interactionCode45:
	ld e,$44		; $6eb7
	ld a,(de)		; $6eb9
	rst_jumpTable			; $6eba
	pop bc			; $6ebb
	ld l,(hl)		; $6ebc
	ld ($336f),sp		; $6ebd
	ld l,a			; $6ec0
	call interactionInitGraphics		; $6ec1
	ld e,$42		; $6ec4
	ld a,(de)		; $6ec6
	or a			; $6ec7
	jr nz,_label_08_289	; $6ec8
	call getThisRoomFlags		; $6eca
	and $40			; $6ecd
	jp nz,interactionDelete		; $6ecf
	ld h,d			; $6ed2
	ld l,$44		; $6ed3
	ld (hl),$01		; $6ed5
	ld l,$79		; $6ed7
	ld (hl),$01		; $6ed9
	ld a,$0b		; $6edb
	call interactionSetHighTextIndex		; $6edd
	ld hl,$6075		; $6ee0
	call interactionSetScript		; $6ee3
	ld a,$03		; $6ee6
	call interactionSetAnimation		; $6ee8
	jp interactionAnimateAsNpc		; $6eeb
_label_08_289:
	ld h,d			; $6eee
	ld l,$44		; $6eef
	ld (hl),$02		; $6ef1
	ld l,$78		; $6ef3
	ld (hl),$ff		; $6ef5
	call $6f3c		; $6ef7
	ld a,$0b		; $6efa
	call interactionSetHighTextIndex		; $6efc
	ld hl,$60a4		; $6eff
	call interactionSetScript		; $6f02
	jp interactionAnimateAsNpc		; $6f05
	ld e,$79		; $6f08
	ld a,(de)		; $6f0a
	or a			; $6f0b
	jr z,_label_08_290	; $6f0c
	ld a,(wFrameCounter)		; $6f0e
	and $3f			; $6f11
	jr nz,_label_08_290	; $6f13
	ld a,$01		; $6f15
	ld b,$fa		; $6f17
	ld c,$0a		; $6f19
	call objectCreateFloatingSnore		; $6f1b
_label_08_290:
	call interactionRunScript		; $6f1e
	jp c,interactionDelete		; $6f21
	call interactionAnimate		; $6f24
	ld e,$7a		; $6f27
	ld a,(de)		; $6f29
	or a			; $6f2a
	jr nz,_label_08_291	; $6f2b
	call objectPreventLinkFromPassing		; $6f2d
_label_08_291:
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6f30
	call interactionRunScript		; $6f33
	call $6f3c		; $6f36
	jp interactionAnimateAsNpc		; $6f39
	ld c,$28		; $6f3c
	call objectCheckLinkWithinDistance		; $6f3e
	jr nc,_label_08_292	; $6f41
	ld e,$78		; $6f43
	ld a,(de)		; $6f45
	cp $06			; $6f46
	ret z			; $6f48
	ld a,$06		; $6f49
	jr _label_08_293		; $6f4b
_label_08_292:
	ld e,$78		; $6f4d
	ld a,(de)		; $6f4f
	cp $05			; $6f50
	ret z			; $6f52
	ld a,$05		; $6f53
_label_08_293:
	ld (de),a		; $6f55
	jp interactionSetAnimation		; $6f56


; leaves during maku tree cutscenes?
; INTERACID_48
; Variables:
;   var03: pointer to another interactionCode48
;   var3a:
;   var3b:
;   var3c:
interactionCode48:
	ld e,Interaction.state		; $6f59
	ld a,(de)		; $6f5b
	rst_jumpTable			; $6f5c
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d			; $6f65
	ld l,e			; $6f66
	inc (hl)		; $6f67
	ld l,Interaction.var3a		; $6f68
	ld (hl),$01		; $6f6a
	ld l,Interaction.subid		; $6f6c
	ld a,(hl)		; $6f6e
	or a			; $6f6f
	ret z			; $6f70
	ld l,Interaction.state		; $6f71
	inc (hl)		; $6f73
	jp interactionInitGraphics		; $6f74

@state1:
	ld h,d			; $6f77
	ld l,Interaction.var3a		; $6f78
	dec (hl)		; $6f7a
	ret nz			; $6f7b
	call getFreeInteractionSlot		; $6f7c
	ret nz			; $6f7f
	ld (hl),INTERACID_48		; $6f80
	ld e,Interaction.var03		; $6f82
	ld a,(de)		; $6f84
	ld l,e			; $6f85
	ld (hl),a		; $6f86
	dec l			; $6f87
	ld e,Interaction.counter1		; $6f88
	ld a,(de)		; $6f8a
	inc a			; $6f8b
	ld (de),a		; $6f8c
	ld (hl),a		; $6f8d
	cp $03			; $6f8e
	jp z,interactionDelete		; $6f90
	jp @func_7002		; $6f93

@state2:
	ld a,$03		; $6f96
	ld (de),a		; $6f98
	ld h,d			; $6f99
	ld l,Interaction.subid		; $6f9a
	ldi a,(hl)		; $6f9c
	add (hl)		; $6f9d
	ld hl,@table_701e		; $6f9e
	rst_addDoubleIndex			; $6fa1
	ld e,$4b		; $6fa2
	ldi a,(hl)		; $6fa4
	ld (de),a		; $6fa5
	ld e,$4d		; $6fa6
	ldi a,(hl)		; $6fa8
	ld (de),a		; $6fa9
	call @func_7012		; $6faa
	ld hl,@table_702c		; $6fad
	call @func_6fee		; $6fb0
	ld a,$83		; $6fb3
	call playSound		; $6fb5
	ld a,$70		; $6fb8
	ld e,$7c		; $6fba
	ld (de),a		; $6fbc
	jp objectSetVisible80		; $6fbd

@state3:
	call objectApplySpeed		; $6fc0
	ld h,d			; $6fc3
	ld l,Interaction.var3c		; $6fc4
	ld a,(hl)		; $6fc6
	or a			; $6fc7
	jr z,+			; $6fc8
	dec (hl)		; $6fca
	ld a,$83		; $6fcb
	call z,playSound		; $6fcd
+
	ld l,$4d		; $6fd0
	ld a,(hl)		; $6fd2
	and $f0			; $6fd3
	cp $f0			; $6fd5
	jp z,interactionDelete		; $6fd7
	ld l,$7b		; $6fda
	dec (hl)		; $6fdc
	call z,@func_7018		; $6fdd
	call interactionDecCounter1		; $6fe0
	ret nz			; $6fe3
	ld l,$78		; $6fe4
	ldi a,(hl)		; $6fe6
	ld h,(hl)		; $6fe7
	ld l,a			; $6fe8
	ld a,(hl)		; $6fe9
	inc a			; $6fea
	jp z,interactionDelete		; $6feb

@func_6fee:
	ld e,$49		; $6fee
	ldi a,(hl)		; $6ff0
	ld (de),a		; $6ff1
	ld e,$46		; $6ff2
	ldi a,(hl)		; $6ff4
	ld (de),a		; $6ff5
	ld e,$50		; $6ff6
	ldi a,(hl)		; $6ff8
	ld (de),a		; $6ff9
	ld e,$78		; $6ffa
	ld a,l			; $6ffc
	ld (de),a		; $6ffd
	inc e			; $6ffe
	ld a,h			; $6fff
	ld (de),a		; $7000
	ret			; $7001

@func_7002:
	ld e,Interaction.counter1		; $7002
	ld a,(de)		; $7004
	ld hl,@table_700e		; $7005
	rst_addAToHl			; $7008
	ld a,(hl)		; $7009
	ld e,Interaction.var3a		; $700a
	ld (de),a		; $700c
	ret			; $700d

@table_700e:
	.db $01
	.db $3c
	.db $32
	.db $ff

@func_7012:
	ld e,Interaction.var3b		; $7012
	ld a,$0b		; $7014
	ld (de),a		; $7016
	ret			; $7017

@func_7018:
	ldbc INTERACID_SPARKLE $02		; $7018
	call objectCreateInteraction		; $701b

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


; wanders in Syrup's shop (rooster?)
interactionCode49:
	call $707b		; $7075
	jp $7089		; $7078
	ld e,$44		; $707b
	ld a,(de)		; $707d
	rst_jumpTable			; $707e
	sub l			; $707f
	ld (hl),b		; $7080
	cp d			; $7081
	ld (hl),b		; $7082
	dec bc			; $7083
	ld (hl),c		; $7084
	dec h			; $7085
	ld (hl),c		; $7086
	dec a			; $7087
	ld (hl),c		; $7088
	ld e,$7d		; $7089
	ld a,(de)		; $708b
	or a			; $708c
	jr z,_label_08_297	; $708d
	call interactionAnimate		; $708f
_label_08_297:
	jp objectSetVisible80		; $7092
	call getThisRoomFlags		; $7095
	and $40			; $7098
	jp z,interactionDelete		; $709a
	ld a,$01		; $709d
	ld (de),a		; $709f
	call interactionInitGraphics		; $70a0
	ld h,d			; $70a3
	ld l,$66		; $70a4
	ld (hl),$06		; $70a6
	inc l			; $70a8
	ld (hl),$06		; $70a9
	ld l,$50		; $70ab
	ld (hl),$19		; $70ad
	call $7164		; $70af
	ld e,$71		; $70b2
	call objectAddToAButtonSensitiveObjectList		; $70b4
	jp $7184		; $70b7
	call $715d		; $70ba
	call $716a		; $70bd
	ld hl,$d00b		; $70c0
	ld c,$69		; $70c3
	ld b,(hl)		; $70c5
	ld a,$69		; $70c6
	ld l,a			; $70c8
	ld a,c			; $70c9
	cp b			; $70ca
	ret nc			; $70cb
	ld a,($cc75)		; $70cc
	or a			; $70cf
	ret z			; $70d0
	ld e,$7c		; $70d1
	ld a,$02		; $70d3
	ld (de),a		; $70d5
	ld a,$80		; $70d6
	ld ($cca4),a		; $70d8
	ld a,l			; $70db
	ld hl,$d00b		; $70dc
	ld (hl),a		; $70df
	jp $718f		; $70e0
	xor a			; $70e3
	ld (de),a		; $70e4
	ld e,$7d		; $70e5
	ld (de),a		; $70e7
	ld e,$7c		; $70e8
	ld a,$01		; $70ea
	ld (de),a		; $70ec
	ld a,($cc75)		; $70ed
	or a			; $70f0
	jr z,_label_08_298	; $70f1
	ld a,($d019)		; $70f3
	ld h,a			; $70f6
	ld e,$7a		; $70f7
	ld (de),a		; $70f9
	ld hl,$60a6		; $70fa
	jp $7103		; $70fd
_label_08_298:
	ld hl,$60a6		; $7100
	ld e,$44		; $7103
	ld a,$04		; $7105
	ld (de),a		; $7107
	jp interactionSetScript		; $7108
	call $715d		; $710b
	call objectApplySpeed		; $710e
	ld e,$4d		; $7111
	ld a,(de)		; $7113
	sub $0c			; $7114
	ld hl,$d00d		; $7116
	cp (hl)			; $7119
	ret nc			; $711a
	ld e,$7d		; $711b
	xor a			; $711d
	ld (de),a		; $711e
	ld hl,$60aa		; $711f
	jp $7103		; $7122
	call $715d		; $7125
	call objectApplySpeed		; $7128
	ld e,$4d		; $712b
	ld a,(de)		; $712d
	cp $78			; $712e
	ret c			; $7130
	xor a			; $7131
	ld ($cca4),a		; $7132
	ld e,$44		; $7135
	ld a,$01		; $7137
	ld (de),a		; $7139
	jp $7184		; $713a
	call interactionRunScript		; $713d
	ret nc			; $7140
	ld e,$7c		; $7141
	ld a,(de)		; $7143
	cp $02			; $7144
	jr z,_label_08_299	; $7146
	ld h,d			; $7148
	ld l,$44		; $7149
	ld (hl),$01		; $714b
	ld l,$7c		; $714d
	ld (hl),$00		; $714f
	ld l,$7d		; $7151
	ld (hl),$01		; $7153
	xor a			; $7155
	ld ($cca4),a		; $7156
	ret			; $7159
_label_08_299:
	jp $71ad		; $715a
	ld c,$20		; $715d
	call objectUpdateSpeedZ_paramC		; $715f
	ret nz			; $7162
	ld h,d			; $7163
	ld bc,$ff40		; $7164
	jp objectSetSpeedZ		; $7167
	call objectApplySpeed		; $716a
	ld e,$4d		; $716d
	ld a,(de)		; $716f
	sub $68			; $7170
	cp $20			; $7172
	ret c			; $7174
	ld e,$49		; $7175
	ld a,(de)		; $7177
	xor $10			; $7178
	ld (de),a		; $717a
	ld e,$7e		; $717b
	ld a,(de)		; $717d
	xor $01			; $717e
	ld (de),a		; $7180
	jp interactionSetAnimation		; $7181
	ld h,d			; $7184
	ld l,$7c		; $7185
	ld (hl),$00		; $7187
	ld l,$50		; $7189
	ld (hl),$14		; $718b
	jr _label_08_300		; $718d
	ld h,d			; $718f
	ld l,$44		; $7190
	ld (hl),$02		; $7192
	ld l,$50		; $7194
	ld (hl),$50		; $7196
_label_08_300:
	ld l,$7d		; $7198
	ld (hl),$01		; $719a
	ld l,$49		; $719c
	ld (hl),$18		; $719e
	xor a			; $71a0
	ld l,$4e		; $71a1
	ldi (hl),a		; $71a3
	ld (hl),a		; $71a4
	ld l,$7e		; $71a5
	ld a,$00		; $71a7
	ld (hl),a		; $71a9
	jp interactionSetAnimation		; $71aa
	ld h,d			; $71ad
	ld l,$44		; $71ae
	ld (hl),$03		; $71b0
	ld l,$50		; $71b2
	ld (hl),$50		; $71b4
	ld l,$7d		; $71b6
	ld (hl),$01		; $71b8
	ld l,$49		; $71ba
	ld (hl),$08		; $71bc
	xor a			; $71be
	ld l,$4e		; $71bf
	ldi (hl),a		; $71c1
	ld (hl),a		; $71c2
	ld l,$7e		; $71c3
	ld a,$01		; $71c5
	ld (hl),a		; $71c7
	jp interactionSetAnimation		; $71c8


; the stones that shoot out when D1 is rising?
interactionCode4b:
	ld e,$44		; $71cb
	ld a,(de)		; $71cd
	rst_jumpTable			; $71ce
.DB $dd				; $71cf
	ld (hl),c		; $71d0
	add sp,$71		; $71d1
	di			; $71d3
	ld (hl),c		; $71d4
.DB $fd				; $71d5
	ld (hl),c		; $71d6
	ld b,h			; $71d7
	ld (hl),d		; $71d8
	ld d,c			; $71d9
	ld (hl),d		; $71da
	ld d,a			; $71db
	ld (hl),d		; $71dc
	ld e,$42		; $71dd
	ld a,(de)		; $71df
	add a			; $71e0
	inc a			; $71e1
	ld e,$44		; $71e2
	ld (de),a		; $71e4
	jp interactionInitGraphics		; $71e5
	ld a,$02		; $71e8
	ld (de),a		; $71ea
	ld a,$6f		; $71eb
	call playSound		; $71ed
	jp objectSetVisible81		; $71f0
	ld e,$61		; $71f3
	ld a,(de)		; $71f5
	inc a			; $71f6
	jp z,interactionDelete		; $71f7
	jp interactionAnimate		; $71fa
	ld a,$04		; $71fd
	ld (de),a		; $71ff
	call getRandomNumber_noPreserveVars		; $7200
	ld b,a			; $7203
	and $60			; $7204
	swap a			; $7206
	ld hl,$7260		; $7208
	rst_addAToHl			; $720b
	ld e,$54		; $720c
	ldi a,(hl)		; $720e
	ld (de),a		; $720f
	inc e			; $7210
	ld a,(hl)		; $7211
	ld (de),a		; $7212
	ld a,b			; $7213
	and $03			; $7214
	ld hl,$7268		; $7216
	rst_addAToHl			; $7219
	ld e,$50		; $721a
	ld a,(hl)		; $721c
	ld (de),a		; $721d
	call getRandomNumber_noPreserveVars		; $721e
	ld b,a			; $7221
	and $30			; $7222
	swap a			; $7224
	ld hl,$726c		; $7226
	rst_addAToHl			; $7229
	ld e,$70		; $722a
	ld a,(hl)		; $722c
	ld (de),a		; $722d
	ld a,b			; $722e
	and $0f			; $722f
	ld hl,$7270		; $7231
	rst_addAToHl			; $7234
	ld e,$49		; $7235
	ld a,(hl)		; $7237
	ld (de),a		; $7238
	inc a			; $7239
	and $07			; $723a
	cp $03			; $723c
	jp c,objectSetVisible82		; $723e
	jp objectSetVisible80		; $7241
	call objectApplySpeed		; $7244
	ld e,$70		; $7247
	ld a,(de)		; $7249
	call objectUpdateSpeedZ		; $724a
	ret nz			; $724d
	jp interactionDelete		; $724e
	ld a,$06		; $7251
	ld (de),a		; $7253
	jp objectSetVisible81		; $7254
	call interactionDecCounter1		; $7257
	jp z,interactionDelete		; $725a
	jp interactionAnimate		; $725d
.db $c0 $fe $a0 $fe $a0 $fe $80 $fe
.db $05 $0a $0a $14 $0d $0e $0f $10
.db $00 $01 $02 $03 $04 $05 $06 $07
.db $01 $02 $03 $05 $06 $07 $02 $06


; hangs out on maku tree branches and village fountain
interactionCode4c:
	ld e,Interaction.subid	; $7280
	ld a,(de)		; $7282
	rst_jumpTable			; $7283
	cp b			; $7284
	ld (hl),d		; $7285
	xor h			; $7286
	ld (hl),d		; $7287
	xor h			; $7288
	ld (hl),d		; $7289
	xor h			; $728a
	ld (hl),d		; $728b
	add hl,sp		; $728c
	ld (hl),e		; $728d
	add hl,sp		; $728e
	ld (hl),e		; $728f
	or d			; $7290
	ld (hl),d		; $7291
.DB $ed				; $7292
	ld (hl),d		; $7293
	ld b,$73		; $7294
	inc h			; $7296
	ld (hl),e		; $7297
	or d			; $7298
	ld (hl),d		; $7299
	or d			; $729a
	ld (hl),d		; $729b
	or d			; $729c
	ld (hl),d		; $729d
	or d			; $729e
	ld (hl),d		; $729f
	call $72de		; $72a0
	jp objectSetVisible80		; $72a3
	call $72de		; $72a6
	jp objectSetVisible81		; $72a9
	call $72de		; $72ac
	jp objectSetVisible82		; $72af
	call $72de		; $72b2
	jp objectSetVisible83		; $72b5
	call checkInteractionState		; $72b8
	jr nz,_label_08_301	; $72bb
	ld h,d			; $72bd
	ld l,e			; $72be
	inc (hl)		; $72bf
	ld l,$40		; $72c0
	set 7,(hl)		; $72c2
	call interactionInitGraphics		; $72c4
	jp objectSetVisible80		; $72c7
_label_08_301:
	call getThisRoomFlags		; $72ca
	bit 6,(hl)		; $72cd
	jr z,_label_08_302	; $72cf
	ld e,$60		; $72d1
	ld a,(de)		; $72d3
	cp $10			; $72d4
	jr nz,_label_08_302	; $72d6
	ld a,$02		; $72d8
	ld (de),a		; $72da
_label_08_302:
	jp interactionAnimate		; $72db
	call checkInteractionState		; $72de
	jr nz,_label_08_303	; $72e1
	ld a,$01		; $72e3
	ld (de),a		; $72e5
	jp interactionInitGraphics		; $72e6
_label_08_303:
	pop hl			; $72e9
	jp interactionAnimate		; $72ea
	call checkInteractionState		; $72ed
	jr nz,_label_08_304	; $72f0
	ld a,$01		; $72f2
	ld (de),a		; $72f4
	call interactionSetAlwaysUpdateBit		; $72f5
	ld a,$9b		; $72f8
	call loadPaletteHeader		; $72fa
	call interactionInitGraphics		; $72fd
	call objectSetVisible82		; $7300
_label_08_304:
	jp interactionAnimate		; $7303
	call checkInteractionState		; $7306
	jr nz,_label_08_305	; $7309
	ld a,$01		; $730b
	ld (de),a		; $730d
	call interactionSetAlwaysUpdateBit		; $730e
	call interactionInitGraphics		; $7311
	call objectSetVisible80		; $7314
_label_08_305:
	call interactionAnimate		; $7317
	ld a,(wFrameCounter)		; $731a
	rrca			; $731d
	jp c,objectSetInvisible		; $731e
	jp objectSetVisible		; $7321
	call checkInteractionState		; $7324
	ret nz			; $7327
	call getThisRoomFlags		; $7328
	and $40			; $732b
	jp z,interactionDelete		; $732d
	call interactionInitGraphics		; $7330
	call interactionIncState		; $7333
	jp objectSetVisible83		; $7336
	call checkInteractionState		; $7339
	jr nz,_label_08_306	; $733c
	ld a,$01		; $733e
	ld (de),a		; $7340
	call interactionSetAlwaysUpdateBit		; $7341
	ld bc,$fe00		; $7344
	call objectSetSpeedZ		; $7347
	ld l,$49		; $734a
	ld (hl),$01		; $734c
	ld l,$50		; $734e
	ld (hl),$28		; $7350
	ld a,$51		; $7352
	call playSound		; $7354
	call interactionInitGraphics		; $7357
	jp objectSetVisiblec0		; $735a
_label_08_306:
	call objectApplySpeed		; $735d
	ld c,$20		; $7360
	call objectUpdateSpeedZ_paramC		; $7362
	ret nz			; $7365
	ld a,$77		; $7366
	call playSound		; $7368
	jp interactionDelete		; $736b


; ==============================================================================
; INTERACID_PIRATE_SKULL
; ==============================================================================
interactionCode4d:
	ld e,$42		; $736e
	ld a,(de)		; $7370
	rst_jumpTable			; $7371
	halt			; $7372
	ld (hl),e		; $7373
	add h			; $7374
	ld (hl),h		; $7375
	ld e,$44		; $7376
	ld a,(de)		; $7378
	rst_jumpTable			; $7379
	add b			; $737a
	ld (hl),e		; $737b
	cp (hl)			; $737c
	ld (hl),e		; $737d
.DB $fd				; $737e
	ld (hl),e		; $737f
	ld a,$01		; $7380
	ld (de),a		; $7382
	ld a,$1b		; $7383
	call checkGlobalFlag		; $7385
	jp z,interactionDelete		; $7388
	ld c,$4d		; $738b
	call objectFindSameTypeObjectWithID		; $738d
	jr nz,_label_08_307	; $7390
	ld a,h			; $7392
	cp d			; $7393
	jp nz,interactionDelete		; $7394
	call func_228f		; $7397
	jp z,interactionDelete		; $739a
_label_08_307:
	ld a,$4a		; $739d
	call checkTreasureObtained		; $739f
	jr c,_label_08_308	; $73a2
	call getRandomNumber		; $73a4
	and $03			; $73a7
	inc a			; $73a9
	ld e,$78		; $73aa
	ld (de),a		; $73ac
_label_08_308:
	ld a,$4d		; $73ad
	call interactionSetHighTextIndex		; $73af
	ld hl,$60ae		; $73b2
	call interactionSetScript		; $73b5
	call interactionInitGraphics		; $73b8
	jp objectSetVisiblec2		; $73bb
	ld e,$45		; $73be
	ld a,(de)		; $73c0
	rst_jumpTable			; $73c1
	add $73			; $73c2
	call z,$cd73		; $73c4
	dec e			; $73c7
	ld h,$c3		; $73c8
	inc c			; $73ca
	dec h			; $73cb
	ld e,$7a		; $73cc
	ld a,(de)		; $73ce
	or a			; $73cf
	jr z,_label_08_309	; $73d0
	ld b,a			; $73d2
	inc e			; $73d3
	ld a,(de)		; $73d4
	ld c,a			; $73d5
	push bc			; $73d6
	call objectCheckContainsPoint		; $73d7
	pop bc			; $73da
	jr c,_label_08_310	; $73db
	call objectGetRelativeAngle		; $73dd
	ld e,$49		; $73e0
	ld (de),a		; $73e2
	ld e,$50		; $73e3
	ld a,$14		; $73e5
	ld (de),a		; $73e7
	call objectApplySpeed		; $73e8
_label_08_309:
	ld h,d			; $73eb
	ld l,$7a		; $73ec
	xor a			; $73ee
	ldi (hl),a		; $73ef
	ld (hl),a		; $73f0
	jp objectAddToGrabbableObjectBuffer		; $73f1
_label_08_310:
	ld bc,$4d0a		; $73f4
	call showText		; $73f7
	jp interactionDelete		; $73fa
	ld e,$45		; $73fd
	ld a,(de)		; $73ff
	rst_jumpTable			; $7400
	add hl,bc		; $7401
	ld (hl),h		; $7402
	ld a,(de)		; $7403
	ld (hl),h		; $7404
	dec a			; $7405
	ld (hl),h		; $7406
	ld d,c			; $7407
	ld (hl),h		; $7408
	ld h,d			; $7409
	ld l,e			; $740a
	inc (hl)		; $740b
	xor a			; $740c
	ld (wLinkGrabState2),a		; $740d
	ld l,$79		; $7410
	ld (hl),a		; $7412
	inc a			; $7413
	call interactionSetAnimation		; $7414
	jp objectSetVisiblec1		; $7417
	ld hl,$ccc1		; $741a
	bit 7,(hl)		; $741d
	ld e,$78		; $741f
	ld a,(de)		; $7421
	ld (hl),a		; $7422
	jr nz,_label_08_311	; $7423
	ld e,$46		; $7425
	ld a,$14		; $7427
	ld (de),a		; $7429
	ld a,$01		; $742a
	jp interactionSetAnimation		; $742c
_label_08_311:
	call interactionAnimate		; $742f
	call interactionDecCounter1		; $7432
	ret nz			; $7435
	ld (hl),$14		; $7436
	ld a,$7e		; $7438
	jp playSound		; $743a
	call objectCheckWithinRoomBoundary		; $743d
	jp nc,interactionDelete		; $7440
	call objectReplaceWithAnimationIfOnHazard		; $7443
	jr c,_label_08_312	; $7446
	ld h,d			; $7448
	ld l,$40		; $7449
	res 1,(hl)		; $744b
	ld l,$79		; $744d
	ld (hl),d		; $744f
	ret			; $7450
	ld c,$20		; $7451
	call objectUpdateSpeedZ_paramC		; $7453
	ret nz			; $7456
	call objectReplaceWithAnimationIfOnHazard		; $7457
	jr c,_label_08_312	; $745a
	call objectCheckWithinScreenBoundary		; $745c
	jp nc,interactionDelete		; $745f
	ld h,d			; $7462
	ld l,$40		; $7463
	res 1,(hl)		; $7465
	ld l,$44		; $7467
	ld a,$01		; $7469
	ldi (hl),a		; $746b
	ld (hl),a		; $746c
	ld l,$79		; $746d
	ld a,(hl)		; $746f
	or a			; $7470
	ld bc,$4d06		; $7471
	call nz,showText		; $7474
	xor a			; $7477
	call interactionSetAnimation		; $7478
	jp objectSetVisible82		; $747b
_label_08_312:
	ld bc,$4d09		; $747e
	jp showText		; $7481
	ld e,$44		; $7484
	ld a,(de)		; $7486
	rst_jumpTable			; $7487
	sub h			; $7488
	ld (hl),h		; $7489
	or e			; $748a
	ld (hl),h		; $748b
	rst_jumpTable			; $748c
	ld (hl),h		; $748d
	ld ($ff00+c),a		; $748e
	ld (hl),h		; $748f
.DB $fc				; $7490
	ld (hl),h		; $7491
	dec c			; $7492
	ld (hl),l		; $7493
	ld a,$01		; $7494
	ld (de),a		; $7496
	call getThisRoomFlags		; $7497
	and $20			; $749a
	jp nz,interactionDelete		; $749c
	ld a,$01		; $749f
	ld ($cca4),a		; $74a1
	ld a,($d00b)		; $74a4
	ld e,$4b		; $74a7
	ld (de),a		; $74a9
	ld a,($d00d)		; $74aa
	ld e,$4d		; $74ad
	ld (de),a		; $74af
	jp interactionInitGraphics		; $74b0
	ld a,($d00f)		; $74b3
	or a			; $74b6
	ret nz			; $74b7
	ld a,$02		; $74b8
	ld (de),a		; $74ba
	call objectGetZAboveScreen		; $74bb
	ld e,$4f		; $74be
	ld (de),a		; $74c0
	call setLinkForceStateToState08		; $74c1
	jp objectSetVisiblec1		; $74c4
	ld c,$20		; $74c7
	call objectUpdateSpeedZAndBounce		; $74c9
	ret nz			; $74cc
	call interactionIncState		; $74cd
	ld l,$50		; $74d0
	ld (hl),$14		; $74d2
	ld l,$49		; $74d4
	ld (hl),$10		; $74d6
	ld a,$02		; $74d8
	ld ($cc6b),a		; $74da
	ld a,$ca		; $74dd
	jp playSound		; $74df
	call objectApplySpeed		; $74e2
	ld c,$20		; $74e5
	call objectUpdateSpeedZAndBounce		; $74e7
	push af			; $74ea
	ld a,$ca		; $74eb
	call z,playSound		; $74ed
	pop af			; $74f0
	ret nc			; $74f1
	call interactionIncState		; $74f2
	ld l,$46		; $74f5
	ld (hl),$28		; $74f7
	jp objectSetVisible82		; $74f9
	call interactionDecCounter1		; $74fc
	ret nz			; $74ff
	ld l,$44		; $7500
	inc (hl)		; $7502
	xor a			; $7503
	ld ($cca4),a		; $7504
	ld bc,$4d07		; $7507
	jp showText		; $750a
	ld a,($cfc0)		; $750d
	or a			; $7510
	ret z			; $7511
	call objectCreatePuff		; $7512
	jp interactionDelete		; $7515


; an animal?
interactionCode4e:
	ld e,$44		; $7518
	ld a,(de)		; $751a
	rst_jumpTable			; $751b
	jr nz,_label_08_316	; $751c
	ld a,l			; $751e
	ld (hl),l		; $751f
	ld a,$01		; $7520
	ld (de),a		; $7522
	ld e,$42		; $7523
	ld a,(de)		; $7525
	cp $0b			; $7526
	jr nz,_label_08_313	; $7528
	call getThisRoomFlags		; $752a
	and $40			; $752d
	jp nz,seasonsFunc_08_754c		; $752f
	ld hl,objectData.objectData7e4e		; $7532
	call parseGivenObjectData		; $7535
	ld hl,$cc1d		; $7538
	ld (hl),$4e		; $753b
	inc hl			; $753d
	ld (hl),$06		; $753e
	xor a			; $7540
	ld hl,$cfd0		; $7541
	ldi (hl),a		; $7544
	ldi (hl),a		; $7545
	ld (hl),a		; $7546
	ld a,$03		; $7547
	call setMusicVolume		; $7549

seasonsFunc_08_754c:
	jp interactionDelete		; $754c
_label_08_313:
	call interactionInitGraphics		; $754f
	ld e,$42		; $7552
	ld a,(de)		; $7554
	cp $05			; $7555
	jr nz,_label_08_314	; $7557
	ld e,$66		; $7559
	ld a,$06		; $755b
	ld (de),a		; $755d
	inc e			; $755e
	ld (de),a		; $755f
	jr _label_08_315		; $7560
_label_08_314:
	ld hl,_table_770a		; $7562
	rst_addDoubleIndex			; $7565
	ldi a,(hl)		; $7566
	ld h,(hl)		; $7567
	ld l,a			; $7568
	call interactionSetScript		; $7569
	ld e,$42		; $756c
	ld a,(de)		; $756e
	cp $07			; $756f
	jp nz,_label_08_315		; $7571
	call interactionSetAlwaysUpdateBit		; $7574
	jp objectSetVisible80		; $7577
_label_08_315:
	call objectSetVisible83		; $757a
	ld e,$42		; $757d
	ld a,(de)		; $757f
	rst_jumpTable			; $7580
	xor c			; $7581
	ld (hl),l		; $7582
	xor c			; $7583
	ld (hl),l		; $7584
	xor c			; $7585
	ld (hl),l		; $7586
	xor c			; $7587
	ld (hl),l		; $7588
	xor c			; $7589
	ld (hl),l		; $758a
	sub a			; $758b
	ld (hl),l		; $758c
	inc l			; $758d
	halt			; $758e
	or a			; $758f
	halt			; $7590
	xor c			; $7591
	ld (hl),l		; $7592
_label_08_316:
	xor c			; $7593
	ld (hl),l		; $7594
	rst $30			; $7595
	halt			; $7596
	ld a,($cfd0)		; $7597
	or a			; $759a
	jr nz,_label_08_317	; $759b
	call interactionAnimate		; $759d
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $75a0
_label_08_317:
	call objectCreatePuff		; $75a3
	jp interactionDelete		; $75a6
	ld e,$45		; $75a9
	ld a,(de)		; $75ab
	rst_jumpTable			; $75ac
	or l			; $75ad
	ld (hl),l		; $75ae
	push bc			; $75af
	ld (hl),l		; $75b0
	ld ($0575),a		; $75b1
	halt			; $75b4

seasonsFunc_08_75b5:
	ld a,($cfd0)		; $75b5
	or a			; $75b8
	call nz,interactionIncState2		; $75b9
	call interactionAnimate		; $75bc
	call interactionRunScript		; $75bf
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $75c2
	ld e,$42		; $75c5
	ld a,(de)		; $75c7
	ld hl,bitTable		; $75c8
	add l			; $75cb
	ld l,a			; $75cc
	ld b,(hl)		; $75cd
	ld a,($cfd1)		; $75ce
	and b			; $75d1
	jr z,_label_08_318	; $75d2
	call interactionIncState2		; $75d4
	ld l,$46		; $75d7
	ld (hl),$20		; $75d9
	ld l,$4d		; $75db
	ldd a,(hl)		; $75dd
	ld (hl),a		; $75de
_label_08_318:
	ld e,$42		; $75df
	ld a,(de)		; $75e1
	cp $05			; $75e2
	call z,interactionAnimate		; $75e4
	jp $75bf		; $75e7
	call interactionDecCounter1		; $75ea
	jr nz,_label_08_319	; $75ed
	call $7612		; $75ef
	jp interactionIncState2		; $75f2
_label_08_319:
	call getRandomNumber_noPreserveVars		; $75f5
	and $0f			; $75f8
	sub $08			; $75fa
	ld h,d			; $75fc
	ld l,$4c		; $75fd
	add (hl)		; $75ff
	inc l			; $7600
	ld (hl),a		; $7601
	jp $75bf		; $7602
	call objectApplySpeed		; $7605
	call objectApplySpeed		; $7608
	call objectCheckWithinScreenBoundary		; $760b
	ret c			; $760e
	jp interactionDelete		; $760f
	ld e,$42		; $7612
	ld a,(de)		; $7614
	ld hl,_table_7622		; $7615
	rst_addDoubleIndex			; $7618
	ldi a,(hl)		; $7619
	ld e,$49		; $761a
	ld (de),a		; $761c
	ldi a,(hl)		; $761d
	ld e,$50		; $761e
	ld (de),a		; $7620
	ret			; $7621

_table_7622:
	.db $04 $78
	.db $1d $78
	.db $1e $78
	.db $05 $78
	.db $15 $78
	ld e,$45		; $762c
	ld a,(de)		; $762e
	rst_jumpTable			; $762f
	.dw $763e
	.dw $764f
	.dw $765e
	.dw $767c
	.dw $7687
	.dw $7695
	.dw $76a7
	ld a,($cfd3)		; $763e
	cp $3f			; $7641
	jp nz,seasonsFunc_08_75b5		; $7643
	call interactionIncState2		; $7646
	ld hl,$612d		; $7649
	call interactionSetScript		; $764c
	call seasonsFunc_08_75b5		; $764f
	ld a,($cfd3)		; $7652
	and $40			; $7655
	ret z			; $7657
	call fastFadeoutToWhite		; $7658
	jp interactionIncState2		; $765b
	ld a,($c4ab)		; $765e
	or a			; $7661
	ret nz			; $7662
	ld a,$80		; $7663
	ld ($cfd3),a		; $7665
	ld a,$06		; $7668
	ld ($cc04),a		; $766a
	ld a,$08		; $766d
	call setLinkIDOverride		; $766f
	ld l,$02		; $7672
	ld (hl),$01		; $7674
	ld l,$19		; $7676
	ld (hl),d		; $7678
	jp interactionIncState2		; $7679
	ld a,($cfd0)		; $767c
	or a			; $767f
	ret nz			; $7680
	call $75bf		; $7681
	jp interactionIncState2		; $7684
	ld a,($cfd0)		; $7687
	cp $04			; $768a
	ret nz			; $768c
	call interactionIncState2		; $768d
	ld a,$0d		; $7690
	jp interactionSetAnimation		; $7692
	ld a,($cfd0)		; $7695
	cp $07			; $7698
	ret nz			; $769a
	call interactionIncState2		; $769b
	ld l,$50		; $769e
	ld (hl),$0a		; $76a0
	ld l,$49		; $76a2
	ld (hl),$08		; $76a4
	ret			; $76a6
	call objectApplySpeed		; $76a7
	ld a,($cfd1)		; $76aa
	rlca			; $76ad
	ret nc			; $76ae
	ld hl,$cfd0		; $76af
	ld (hl),$08		; $76b2
	jp interactionDelete		; $76b4
	ld e,$45		; $76b7
	ld a,(de)		; $76b9
	rst_jumpTable			; $76ba
	pop bc			; $76bb
	halt			; $76bc
	ret nc			; $76bd
	halt			; $76be
.DB $e3				; $76bf
	halt			; $76c0
	call interactionRunScript		; $76c1
	jr nc,_label_08_320	; $76c4
	call interactionIncState2		; $76c6
	ld hl,$cfd0		; $76c9
	ld (hl),$04		; $76cc
	jr _label_08_320		; $76ce
	call $76e9		; $76d0
	ld hl,$cfd0		; $76d3
	ld a,(hl)		; $76d6
	cp $06			; $76d7
	ret nz			; $76d9
	call interactionIncState2		; $76da
	ld hl,$6146		; $76dd
	jp interactionSetScript		; $76e0
	call interactionRunScript		; $76e3
	jp c,interactionDelete		; $76e6
_label_08_320:
	call interactionAnimate		; $76e9
	ld a,(wFrameCounter)		; $76ec
	and $3f			; $76ef
	ret nz			; $76f1
	ld a,$d3		; $76f2
	jp playSound		; $76f4
	call checkInteractionState2		; $76f7
	jr nz,_label_08_321	; $76fa
	call interactionIncState2		; $76fc
	ld a,$28		; $76ff
	call checkGlobalFlag		; $7701
	jp z,interactionDelete		; $7704
_label_08_321:
	jp $75bc		; $7707

_table_770a:
	.dw script60c7
	.dw script60d4
	.dw script60e8
	.dw script60f5
	.dw script6102
	.dw script611b
	.dw script611b
	.dw script6142
	.dw script611b
	.dw script611b
	.dw script614a


; INTERACID_4f
; Called by Din Imprisoned cutscene (crystals?)
; 2 in Din Imprisoned state2 (subid $00 and $01)
; 4 in Din Imprisoned state3 (subid $02, var03 of 0-3)
; 1 loop by this, state 1 subid 2 substate 4 (subid $03)
; 1 loop by this, state 1 subid 2 substate 6 (subid $04)
interactionCode4f:
	ld e,Interaction.state		; $7720
	ld a,(de)		; $7722
	rst_jumpTable			; $7723
	.dw _interactionCode4f_state0
	.dw _interactionCode4f_state1

_interactionCode4f_state0:
	call interactionIncState		; $7728
	call interactionInitGraphics		; $772b
	ld e,Interaction.subid		; $772e
	ld a,(de)		; $7730
	rst_jumpTable			; $7731
	.dw @subid0
	.dw @subid1
	.dw objectSetVisible81
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid0:
	ld hl,script6160		; $773e
	call interactionSetScript		; $7741
	jp objectSetVisiblec2		; $7744

@subid1:
	ld hl,script6164		; $7747
	call interactionSetScript		; $774a
	jp objectSetVisible82		; $774d

@subid3:
	call @setCounter2Between1To8		; $7750
	ld e,Interaction.var03		; $7753
	ld a,(de)		; $7755
	add a			; $7756
	add a			; $7757
	add $10			; $7758
	and $1f			; $775a
	ld e,$49		; $775c
	ld (de),a		; $775e
	ld e,$50		; $775f
	ld a,$78		; $7761
	ld (de),a		; $7763
	call objectSetVisible80		; $7764
	jp objectSetInvisible		; $7767

@subid4:
	ld e,Interaction.var03		; $776a
	ld a,(de)		; $776c
	or a			; $776d
	jr z,+			; $776e
	ld a,$05		; $7770
	call interactionSetAnimation		; $7772
	jp objectSetVisible82		; $7775
+
	jp objectSetVisible83		; $7778

@subid5:
	ld hl,script6172		; $777b
	call interactionSetScript		; $777e
	jp objectSetVisible82		; $7781

@func_7784:
	ld e,Interaction.var03		; $7784
	ld a,(de)		; $7786
	add $06			; $7787
	ld b,a			; $7789
	ld e,Interaction.var32		; $778a
	ld a,(de)		; $778c
	or a			; $778d
	ld a,b			; $778e
	jr z,+			; $778f
	add $0b			; $7791
+
	jp interactionSetAnimation		; $7793

@func_7796:
	ld h,d			; $7796
	ld l,$70		; $7797
	ld e,Interaction.var32		; $7799
	ld a,(de)		; $779b
	or a			; $779c
	jr nz,+			; $779d
	ld e,Interaction.var03		; $779f
	ld a,(de)		; $77a1
	add a			; $77a2
	add a			; $77a3
	ld e,$48		; $77a4
	ld (de),a		; $77a6
	ld b,(hl)		; $77a7
	inc l			; $77a8
	ld c,(hl)		; $77a9
	ld a,$38		; $77aa
	ld e,$48		; $77ac
	jp objectSetPositionInCircleArc		; $77ae
+
	ld e,Interaction.yh		; $77b1
	ldi a,(hl)		; $77b3
	ld (de),a		; $77b4
	inc e			; $77b5
	inc e			; $77b6
	ld a,(hl)		; $77b7
	ld (de),a		; $77b8
	ret			; $77b9

@setCounter2Between1To8:
	call getRandomNumber		; $77ba
	and $07			; $77bd
	inc a			; $77bf
	ld e,Interaction.counter2		; $77c0
	ld (de),a		; $77c2
	ret			; $77c3

_interactionCode4f_state1:
	ld e,Interaction.subid		; $77c4
	ld a,(de)		; $77c6
	rst_jumpTable			; $77c7
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid0:
	ld a,($cfd0)		; $77d4
	cp $0e			; $77d7
	jp z,interactionDelete		; $77d9
	cp $0d			; $77dc
	jr nz,++		; $77de
	call checkInteractionState2		; $77e0
	jr nz,+			; $77e3
	call interactionIncState2		; $77e5
	ld l,$4b		; $77e8
	ld (hl),$4a		; $77ea
	inc l			; $77ec
	inc l			; $77ed
	ld (hl),$81		; $77ee
	ld a,$0e		; $77f0
	call interactionSetAnimation		; $77f2
+
	call objectOscillateZ		; $77f5
++
	call interactionAnimate		; $77f8
	jp interactionRunScript		; $77fb

@subid2:
	ld e,Interaction.state2		; $77fe
	ld a,(de)		; $7800
	rst_jumpTable			; $7801
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
	call interactionIncState2		; $7814
	ld a,$7c		; $7817
	call @func_7957		; $7819
	ld e,Interaction.var03		; $781c
	ld a,(de)		; $781e
	add a			; $781f
	ld hl,@@table_784e		; $7820
	rst_addDoubleIndex			; $7823
	ld e,$49		; $7824
	ldi a,(hl)		; $7826
	ld (de),a		; $7827
	ld e,$70		; $7828
	ldi a,(hl)		; $782a
	ld (de),a		; $782b
	inc de			; $782c
	ldi a,(hl)		; $782d
	ld (de),a		; $782e
	inc de			; $782f
	ld a,(hl)		; $7830
	ld (de),a		; $7831
	xor a			; $7832
	call @func_791f		; $7833
	ld e,$46		; $7836
	ld a,$3c		; $7838
	ld (de),a		; $783a

@@substate1:
	call interactionDecCounter1		; $783b
	ld e,$5a		; $783e
	jr nz,+			; $7840
	ld a,(de)		; $7842
	or $80			; $7843
	ld (de),a		; $7845
	jp interactionIncState2		; $7846
+
	ld a,(de)		; $7849
	xor $80			; $784a
	ld (de),a		; $784c
	ret			; $784d

@@table_784e:
	.db $1c $30 $3c $5a
	.db $04 $30 $46 $50
	.db $1c $60 $50 $46
	.db $04 $60 $5a $3c

@@substate2:
	ld h,d			; $785e
	ld l,$71		; $785f
	dec (hl)		; $7861
	ret nz			; $7862
	ld l,$50		; $7863
	ld (hl),$78		; $7865
	jp interactionIncState2		; $7867

@@substate3:
	call objectApplySpeed		; $786a
	ld e,$70		; $786d
	ld a,(de)		; $786f
	ld b,a			; $7870
	ld e,$4b		; $7871
	ld a,(de)		; $7873
	ld c,a			; $7874
	cp b			; $7875
	ld e,$43		; $7876
	ld a,(de)		; $7878
	jr nc,+			; $7879
	xor a			; $787b
	call @func_7941		; $787c
	jp interactionIncState2		; $787f
+
	or a			; $7882
	ret nz			; $7883
	jp @func_7a1e		; $7884

@@substate4:
	ld h,d			; $7887
	ld l,$72		; $7888
	dec (hl)		; $788a
	ret nz			; $788b
	call interactionIncState2		; $788c
	ld l,$46		; $788f
	ld (hl),$a0		; $7891
	ld l,$43		; $7893
	ld a,(hl)		; $7895
	or a			; $7896
	ld bc,$4882		; $7897
	ld a,$fe		; $789a
	call z,@func_7968		; $789c
	ret			; $789f

@@substate5:
	call interactionDecCounter1		; $78a0
	jr nz,+			; $78a3
	call objectSetVisible		; $78a5
	ld l,$46		; $78a8
	ld (hl),$28		; $78aa
	ld a,$04		; $78ac
	call @func_791f		; $78ae
	jp interactionIncState2		; $78b1
+
	ld l,$49		; $78b4
	inc (hl)		; $78b6
	ld a,(hl)		; $78b7
	and $1f			; $78b8
	ld (hl),a		; $78ba
	ld a,$20		; $78bb
	ld e,$49		; $78bd
	ld bc,$4882		; $78bf
	jp objectSetPositionInCircleArc		; $78c2

@@substate6:
	call interactionDecCounter1		; $78c5
	ret nz			; $78c8
	ld l,$50		; $78c9
	ld (hl),$14		; $78cb
	ld l,$46		; $78cd
	ld (hl),$3c		; $78cf
	ld a,$04		; $78d1
	call @func_7941		; $78d3
	ld b,$02		; $78d6
--
	call getFreeInteractionSlot		; $78d8
	jr nz,++		; $78db
	ld (hl),INTERACID_4f		; $78dd
	inc l			; $78df
	ld (hl),$04		; $78e0
	inc l			; $78e2
	ld a,b			; $78e3
	dec a			; $78e4
	ld (hl),a		; $78e5
	ld l,$46		; $78e6
	ld (hl),$0a		; $78e8
	jr z,+			; $78ea
	ld (hl),$14		; $78ec
+
	call objectCopyPosition		; $78ee
	ld e,$49		; $78f1
	ld l,e			; $78f3
	ld a,(de)		; $78f4
	ld (hl),a		; $78f5
	ld e,$50		; $78f6
	ld l,e			; $78f8
	ld a,(de)		; $78f9
	ld (hl),a		; $78fa
	dec b			; $78fb
	jr nz,--		; $78fc
++
	jp interactionIncState2		; $78fe

@@substate7:
	call objectApplySpeed		; $7901
	call interactionDecCounter1		; $7904
	ret nz			; $7907
	ld hl,$cfd0		; $7908
	ld (hl),$0c		; $790b
	ld a,$79		; $790d
	call @func_7957		; $790f
	jp interactionIncState2		; $7912

@@substate8:
	ld hl,$cfd0		; $7915
	ld a,(hl)		; $7918
	cp $0d			; $7919
	ret nz			; $791b
	jp interactionDelete		; $791c

@func_791f:
	ld b,a			; $791f
	ld e,$43		; $7920
	ld a,(de)		; $7922
	add b			; $7923
	ld hl,@table_7931		; $7924
	rst_addDoubleIndex			; $7927
	ld e,$4b		; $7928
	ldi a,(hl)		; $792a
	ld (de),a		; $792b
	inc de			; $792c
	inc de			; $792d
	ldi a,(hl)		; $792e
	ld (de),a		; $792f
	ret			; $7930

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
	ld b,a			; $7941
	ld e,$43		; $7942
	ld a,(de)		; $7944
	add b			; $7945
	ld hl,@table_794f		; $7946
	rst_addAToHl			; $7949
	ld e,$49		; $794a
	ld a,(hl)		; $794c
	ld (de),a		; $794d
	ret			; $794e

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
	ld b,a			; $7957
	ld e,$43		; $7958
	ld a,(de)		; $795a
	or a			; $795b
	ret nz			; $795c
	ld a,b			; $795d
	jp playSound		; $795e
	ld hl,$ff8c		; $7961
	ld (hl),$01		; $7964
	jr +			; $7966

@func_7968:
	ld hl,$ff8c		; $7968
	ld (hl),$00		; $796b
+
	ldh (<hFF8B),a	; $796d
	ld a,$08		; $796f
	ldh (<hFF8D),a	; $7971
-
	call getFreeInteractionSlot		; $7973
	ret nz			; $7976
	ld (hl),INTERACID_4f		; $7977
	inc l			; $7979
	ld (hl),$03		; $797a
	ld l,$46		; $797c
	ldh a,(<hFF8B)	; $797e
	ld (hl),a		; $7980
	ld l,$70		; $7981
	ld (hl),b		; $7983
	inc l			; $7984
	ld (hl),c		; $7985
	ld l,$72		; $7986
	ldh a,(<hFF8C)	; $7988
	ld (hl),a		; $798a
	ldh a,(<hFF8D)	; $798b
	dec a			; $798d
	ldh (<hFF8D),a	; $798e
	ld l,$43		; $7990
	ld (hl),a		; $7992
	jr nz,-			; $7993
	ld a,$5c		; $7995
	jp playSound		; $7997

@subid3:
	ld h,d			; $799a
	ld l,$46		; $799b
	ld a,(hl)		; $799d
	inc a			; $799e
	jr z,+			; $799f
	dec (hl)		; $79a1
	jp z,interactionDelete		; $79a2
+
	ld e,$45		; $79a5
	ld a,(de)		; $79a7
	or a			; $79a8
	jr nz,+			; $79a9
	call interactionDecCounter2		; $79ab
	ret nz			; $79ae
	call _interactionCode4f_state0@func_7784		; $79af
	call _interactionCode4f_state0@func_7796		; $79b2
	call objectSetVisible		; $79b5
	jp interactionIncState2		; $79b8
+
	call objectApplySpeed		; $79bb
	call interactionAnimate		; $79be
	ld e,$61		; $79c1
	ld a,(de)		; $79c3
	inc a			; $79c4
	ret nz			; $79c5
	ld h,d			; $79c6
	ld l,$45		; $79c7
	ld (hl),$00		; $79c9
	call _interactionCode4f_state0@setCounter2Between1To8		; $79cb
	jp objectSetInvisible		; $79ce

@subid4:
	call checkInteractionState2		; $79d1
	jr nz,+			; $79d4
	call interactionDecCounter1		; $79d6
	ret nz			; $79d9
	jp interactionIncState2		; $79da
+
	ld hl,$cfd0		; $79dd
	ld a,(hl)		; $79e0
	cp $0c			; $79e1
	jp z,interactionDelete		; $79e3
	jp objectApplySpeed		; $79e6

@subid1:
	ld e,Interaction.state2		; $79e9
	ld a,(de)		; $79eb
	rst_jumpTable			; $79ec
	.dw @@substate0
	.dw @@substate1
	.dw interactionRunScript

@@substate0:
	call interactionRunScript		; $79f3
	jr c,+			; $79f6
	call interactionAnimate		; $79f8
	jr @@func_7a00			; $79fb
+
	jp interactionIncState2		; $79fd

@@func_7a00:
	ld h,d			; $7a00
	ld l,$61		; $7a01
	ld a,(hl)		; $7a03
	cp $70			; $7a04
	ld (hl),$00		; $7a06
	ret nz			; $7a08
	jp playSound		; $7a09

@@substate1:
	ld a,($cfd0)		; $7a0c
	cp $0e			; $7a0f
	ret nz			; $7a11
	call objectSetInvisible		; $7a12
	ld hl,script6168		; $7a15
	call interactionSetScript		; $7a18
	jp interactionIncState2		; $7a1b

@func_7a1e:
	ld a,($c486)		; $7a1e
	ld b,a			; $7a21
	ld a,c			; $7a22
	sub b			; $7a23
	sub $40			; $7a24
	ld b,a			; $7a26
	ld a,($c486)		; $7a27
	add b			; $7a2a
	cp $10			; $7a2b
	ret nc			; $7a2d
	ld ($c486),a		; $7a2e
	ldh (<hCameraY),a	; $7a31
	ret			; $7a33

@subid5:
	call interactionAnimate		; $7a34
	call @subid1@func_7a00		; $7a37
	jp interactionRunScript		; $7a3a


; ==============================================================================
; INTERACID_SMALL_VOLCANO
; ==============================================================================
interactionCode51:
	call checkInteractionState		; $7a3d
	jr z,_label_08_343	; $7a40
	ld a,(wFrameCounter)		; $7a42
	and $0f			; $7a45
	ld a,$b3		; $7a47
	call z,playSound		; $7a49
	ld a,($cd18)		; $7a4c
	or a			; $7a4f
	jr nz,_label_08_341	; $7a50
	ld a,($cd19)		; $7a52
	or a			; $7a55
	call z,$7a9a		; $7a56
_label_08_341:
	call interactionDecCounter1		; $7a59
	ret nz			; $7a5c
	call $7abe		; $7a5d
	ld e,$42		; $7a60
	ld a,(de)		; $7a62
	or a			; $7a63
	ld c,$07		; $7a64
	jr z,_label_08_342	; $7a66
	ld c,$0f		; $7a68
_label_08_342:
	call getRandomNumber		; $7a6a
	and c			; $7a6d
	srl c			; $7a6e
	inc c			; $7a70
	sub c			; $7a71
	ld c,a			; $7a72
	call getFreePartSlot		; $7a73
	ret nz			; $7a76
	ld (hl),$11		; $7a77
	ld e,$42		; $7a79
	inc l			; $7a7b
	ld a,(de)		; $7a7c
	ld (hl),a		; $7a7d
	ld b,$00		; $7a7e
	jp objectCopyPositionWithOffset		; $7a80
_label_08_343:
	inc a			; $7a83
	ld (de),a		; $7a84
	ld ($ccae),a		; $7a85
	ld e,$42		; $7a88
	ld a,(de)		; $7a8a
	ld hl,_table_7acb		; $7a8b
	rst_addDoubleIndex			; $7a8e
	ldi a,(hl)		; $7a8f
	ld h,(hl)		; $7a90
	ld l,a			; $7a91
	ld e,$58		; $7a92
	ld a,l			; $7a94
	ld (de),a		; $7a95
	inc e			; $7a96
	ld a,h			; $7a97
	ld (de),a		; $7a98
	ret			; $7a99

	ld h,d			; $7a9a
	ld l,$58		; $7a9b
	ldi a,(hl)		; $7a9d
	ld h,(hl)		; $7a9e
	ld l,a			; $7a9f
	ldi a,(hl)		; $7aa0
	cp $ff			; $7aa1
	jr nz,_label_08_344	; $7aa3
	pop hl			; $7aa5
	jp interactionDelete		; $7aa6
_label_08_344:
	ld ($cd18),a		; $7aa9
	ldi a,(hl)		; $7aac
	ld ($cd19),a		; $7aad
	ld e,$70		; $7ab0
	ldi a,(hl)		; $7ab2
	ld (de),a		; $7ab3
	inc e			; $7ab4
	ldi a,(hl)		; $7ab5
	ld (de),a		; $7ab6
	ld e,$58		; $7ab7
	ld a,l			; $7ab9
	ld (de),a		; $7aba
	inc e			; $7abb
	ld a,h			; $7abc
	ld (de),a		; $7abd
	call getRandomNumber_noPreserveVars		; $7abe
	ld h,d			; $7ac1
	ld l,$70		; $7ac2
	and (hl)		; $7ac4
	inc l			; $7ac5
	add (hl)		; $7ac6
	ld l,$46		; $7ac7
	ld (hl),a		; $7ac9
	ret			; $7aca

_table_7acb:
	.dw _table_7acf
	.dw _table_7ae8

_table_7acf:
	.db $00 $0f
	.db $00 $ff
	.db $0f $00
	.db $00 $ff
	.db $96 $00
	.db $0f $08
	.db $5a $5a
	.db $07 $03
	.db $00 $3c
	.db $1f $10
	.db $00 $78
	.db $00 $ff
	.db $ff

_table_7ae8:
	.db $00 $1e
	.db $00 $ff
	.db $1e $00
	.db $00 $ff
	.db $b4 $b4
	.db $0f $08
	.db $3c $3c
	.db $1f $10
	.db $1e $00
	.db $00 $ff
	.db $00 $78
	.db $00 $ff
	.db $0f $0f
	.db $00 $ff
	.db $ff


; ==============================================================================
; INTERACID_BIGGORON
; ==============================================================================
interactionCode52:
	ld e,$44		; $7b05
	ld a,(de)		; $7b07
	rst_jumpTable			; $7b08
	dec c			; $7b09
	ld a,e			; $7b0a
	inc h			; $7b0b
	ld a,e			; $7b0c
	ld a,$01		; $7b0d
	ld (de),a		; $7b0f
	call interactionInitGraphics		; $7b10
	call interactionSetAlwaysUpdateBit		; $7b13
	call objectSetVisible82		; $7b16
	ld a,$0b		; $7b19
	call interactionSetHighTextIndex		; $7b1b
	ld hl,$6176		; $7b1e
	jp interactionSetScript		; $7b21
	call interactionAnimate		; $7b24
	jp interactionRunScript		; $7b27


; ==============================================================================
; INTERACID_HEAD_SMELTER
; ==============================================================================
interactionCode53:
	ld e,$42		; $7b2a
	ld a,(de)		; $7b2c
	rst_jumpTable			; $7b2d
	ldd (hl),a		; $7b2e
	ld a,e			; $7b2f
	ld l,b			; $7b30
	ld a,e			; $7b31
	ld e,$44		; $7b32
	ld a,(de)		; $7b34
	rst_jumpTable			; $7b35
	inc a			; $7b36
	ld a,e			; $7b37
	ld d,l			; $7b38
	ld a,e			; $7b39
	ld e,(hl)		; $7b3a
	ld a,e			; $7b3b
	call getThisRoomFlags		; $7b3c
	bit 7,(hl)		; $7b3f
	jp nz,interactionDelete		; $7b41
	ld e,$44		; $7b44
	ld a,$01		; $7b46
	ld (de),a		; $7b48
	call interactionInitGraphics		; $7b49
	ld hl,$6264		; $7b4c
	call interactionSetScript		; $7b4f
	jp objectSetVisible82		; $7b52
	call interactionRunScript		; $7b55
	call objectPreventLinkFromPassing		; $7b58
	jp npcFaceLinkAndAnimate		; $7b5b
	call interactionAnimate		; $7b5e
	call interactionRunScript		; $7b61
	jp c,interactionDelete		; $7b64
	ret			; $7b67
	ld e,$44		; $7b68
	ld a,(de)		; $7b6a
	rst_jumpTable			; $7b6b
	ld (hl),h		; $7b6c
	ld a,e			; $7b6d
	ld d,l			; $7b6e
	ld a,e			; $7b6f
	ld e,(hl)		; $7b70
	ld a,e			; $7b71
	adc l			; $7b72
	ld a,e			; $7b73
	ld a,$0d		; $7b74
	call checkGlobalFlag		; $7b76
	jp z,interactionDelete		; $7b79
	ld e,$44		; $7b7c
	ld a,$01		; $7b7e
	ld (de),a		; $7b80
	call interactionInitGraphics		; $7b81
	ld hl,$628b		; $7b84
	call interactionSetScript		; $7b87
	jp objectSetVisible82		; $7b8a
	xor a			; $7b8d
	ld ($cfc0),a		; $7b8e
	call interactionRunScript		; $7b91
	ld e,$45		; $7b94
	ld a,(de)		; $7b96
	rst_jumpTable			; $7b97
	and b			; $7b98
	ld a,e			; $7b99
	and b			; $7b9a
	ld a,e			; $7b9b
	jp $c37b		; $7b9c
	ld a,e			; $7b9f
	call interactionAnimate		; $7ba0
	ld a,($cfc0)		; $7ba3
	call getHighestSetBit		; $7ba6
	ret nc			; $7ba9
	cp $03			; $7baa
	jr nz,_label_08_345	; $7bac
	ld e,$44		; $7bae
	ld a,$01		; $7bb0
	ld (de),a		; $7bb2
	ret			; $7bb3
_label_08_345:
	ld b,a			; $7bb4
	inc b			; $7bb5
	ld h,d			; $7bb6
	ld l,$45		; $7bb7
	ld (hl),b		; $7bb9
	ld l,$43		; $7bba
	ld (hl),$08		; $7bbc
	add $04			; $7bbe
	jp interactionSetAnimation		; $7bc0
	call interactionAnimate		; $7bc3
	ld h,d			; $7bc6
	ld l,$61		; $7bc7
	ld a,(hl)		; $7bc9
	or a			; $7bca
	jr z,_label_08_346	; $7bcb
	ld (hl),$00		; $7bcd
	ld l,$4d		; $7bcf
	add (hl)		; $7bd1
	ld (hl),a		; $7bd2
_label_08_346:
	ld l,$43		; $7bd3
	dec (hl)		; $7bd5
	ret nz			; $7bd6
	ld l,$45		; $7bd7
	ld (hl),$01		; $7bd9
	ret			; $7bdb

interactionCode54:
	ld e,$44		; $7bdc
	ld a,(de)		; $7bde
	rst_jumpTable			; $7bdf
	and $7b			; $7be0
	ld a,(de)		; $7be2
	ld a,h			; $7be3
	daa			; $7be4
	ld e,$3e		; $7be5
	ld bc,$cd12		; $7be7
	ld a,(de)		; $7bea
	inc b			; $7beb
	and $0f			; $7bec
	ld hl,$7c0a		; $7bee
	rst_addAToHl			; $7bf1
	ld a,(hl)		; $7bf2
	ld e,$42		; $7bf3
	ld (de),a		; $7bf5
	ld bc,$fe40		; $7bf6
	call objectSetSpeedZ		; $7bf9
	ld l,$50		; $7bfc
	ld (hl),$28		; $7bfe
	ld l,$49		; $7c00
	ld (hl),$08		; $7c02
	call interactionInitGraphics		; $7c04
	jp objectSetVisiblec1		; $7c07
	dec c			; $7c0a
	ld c,$10		; $7c0b
	ldd a,(hl)		; $7c0d
	ld b,b			; $7c0e
	ld d,h			; $7c0f
	halt			; $7c10
	ld d,a			; $7c11
	dec de			; $7c12
	ld e,l			; $7c13
	ld b,e			; $7c14
	inc bc			; $7c15
	ld sp,$2e13		; $7c16
	inc hl			; $7c19
	call objectApplySpeed		; $7c1a
	ld c,$20		; $7c1d
	call objectUpdateSpeedZ_paramC		; $7c1f
	ret nz			; $7c22
	ld e,$44		; $7c23
	ld a,$02		; $7c25
	ld (de),a		; $7c27
	jp objectReplaceWithAnimationIfOnHazard		; $7c28


; ==============================================================================
; INTERACID_SUBROSIAN_AT_D8
; ==============================================================================
interactionCode55:
	ld e,Interaction.subid		; $7c2b
	ld a,(de)		; $7c2d
	rst_jumpTable			; $7c2e
	.dw _subrosianAtD8_subid0
	.dw _subrosianAtD8_subid1

_subrosianAtD8_subid0:
	ld e,Interaction.state		; $7c33
	ld a,(de)		; $7c35
	rst_jumpTable			; $7c36
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call _subrosianAtD8_getNumEssences		; $7c3d
	cp $07			; $7c40
	jp c,interactionDelete		; $7c42

	call interactionInitGraphics		; $7c45
	ld hl,subrosianAtD8Script		; $7c48
	call interactionSetScript		; $7c4b

	ld a,$06		; $7c4e
	call objectSetCollideRadius		; $7c50

	ld l,Interaction.counter1		; $7c53
	ld (hl),60		; $7c55
	ld e,Interaction.pressedAButton		; $7c57
	call objectAddToAButtonSensitiveObjectList		; $7c59

	call getThisRoomFlags		; $7c5c
	and $40			; $7c5f
	ld a,$02		; $7c61
	jr nz,+			; $7c63
	dec a			; $7c65
+
	ld e,Interaction.state		; $7c66
	ld (de),a		; $7c68
	jp objectSetVisiblec2		; $7c69

; Waiting for Link to throw bomb in
@state1:
	ld e,Interaction.state2		; $7c6c
	ld a,(de)		; $7c6e
	rst_jumpTable			; $7c6f
	.dw @substate0
	.dw @substate1

@substate0:
	call interactionAnimate		; $7c74
	call objectPreventLinkFromPassing		; $7c77
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $7c7a
	ld e,Interaction.pressedAButton		; $7c7d
	ld a,(de)		; $7c7f
	or a			; $7c80
	jr nz,++		; $7c81

	call interactionDecCounter1		; $7c83
	ret nz			; $7c86
	ld l,Interaction.state2		; $7c87
	inc (hl)		; $7c89
	call objectSetVisiblec2		; $7c8a
	ld hl,subrosianAtD8Script_tossItemIntoHole		; $7c8d
	jp interactionSetScript		; $7c90
++
	xor a			; $7c93
	ld (de),a		; $7c94
	ld bc,TX_3c00		; $7c95
	jp showText		; $7c98

@substate1:
	call objectPreventLinkFromPassing		; $7c9b
	call interactionAnimate		; $7c9e
	call interactionRunScript		; $7ca1
	ret nc			; $7ca4

	ld h,d			; $7ca5
	ld l,Interaction.counter1		; $7ca6
	ld (hl),60		; $7ca8
	ld l,Interaction.state2		; $7caa
	dec (hl)		; $7cac
	ret			; $7cad

@state2:
	ld c,$60		; $7cae
	call objectUpdateSpeedZ_paramC		; $7cb0
	jr nz,++		; $7cb3
	ld bc,-$200		; $7cb5
	call objectSetSpeedZ		; $7cb8
++
	call objectPreventLinkFromPassing		; $7cbb
	call interactionAnimate		; $7cbe
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $7cc1
	jp interactionRunScript		; $7cc4


_subrosianAtD8_subid1:
	ld e,Interaction.state		; $7cc7
	ld a,(de)		; $7cc9
	rst_jumpTable			; $7cca
	.dw @state0
	.dw @state1

@state0:
	call _subrosianAtD8_getNumEssences		; $7ccf
	cp $07			; $7cd2
	jp c,interactionDelete		; $7cd4

	call getThisRoomFlags		; $7cd7
	and $40			; $7cda
	jp nz,interactionDelete		; $7cdc

	ld a,(wLinkPlayingInstrument)		; $7cdf
	or a			; $7ce2
	ret nz			; $7ce3
	ld a,(wTmpcfc0.genericCutscene.state)		; $7ce4
	or a			; $7ce7
	ret z			; $7ce8
	call checkLinkVulnerable		; $7ce9
	ret nc			; $7cec

	ld a,DISABLE_LINK		; $7ced
	ld (wDisabledObjects),a		; $7cef
	ld (wMenuDisabled),a		; $7cf2
	ld (wDisableScreenTransitions),a		; $7cf5
	ld a,90		; $7cf8
	call setScreenShakeCounter		; $7cfa

	ld e,Interaction.state		; $7cfd
	ld a,$01		; $7cff
	ld (de),a		; $7d01

	ld a,SNDCTRL_MEDIUM_FADEOUT		; $7d02
	jp playSound		; $7d04

@state1:
	ld a,(wScreenShakeCounterY)		; $7d07
	or a			; $7d0a
	ret nz			; $7d0b

	call getThisRoomFlags		; $7d0c
	set 6,(hl)		; $7d0f
	ld a,CUTSCENE_S_VOLCANO_ERUPTING		; $7d11
	ld (wCutsceneTrigger),a		; $7d13
	call fadeoutToWhite		; $7d16
	jp interactionDelete		; $7d19

;;
; @addr{7d1c}
_subrosianAtD8_getNumEssences:
	ld a,($c6bb)		; $7d1c
	jp getNumSetBits		; $7d1f


; ==============================================================================
; INTERACID_INGO
; ==============================================================================
interactionCode57:
	ld e,$44		; $7d22
	ld a,(de)		; $7d24
	rst_jumpTable			; $7d25
	inc l			; $7d26
	ld a,l			; $7d27
	ld c,d			; $7d28
	ld a,l			; $7d29
	ld d,e			; $7d2a
	ld a,l			; $7d2b
	call interactionInitGraphics		; $7d2c
	call interactionSetAlwaysUpdateBit		; $7d2f
_label_08_350:
	ld h,d			; $7d32
	ld l,$44		; $7d33
	ld (hl),$01		; $7d35
	ld a,$0b		; $7d37
	call interactionSetHighTextIndex		; $7d39
	ld hl,$6325		; $7d3c
	call interactionSetScript		; $7d3f
	ld a,$02		; $7d42
	call interactionSetAnimation		; $7d44
	jp $7d99		; $7d47
	call $7d5a		; $7d4a
	call interactionRunScript		; $7d4d
	jp npcFaceLinkAndAnimate		; $7d50
	call interactionRunScript		; $7d53
	jr c,_label_08_350	; $7d56
	jr _label_08_351		; $7d58
	ld a,($d00b)		; $7d5a
	sub $20			; $7d5d
	ret nc			; $7d5f
	ld a,$22		; $7d60
	ld ($d00b),a		; $7d62
	ld a,($cc77)		; $7d65
	or a			; $7d68
	ret nz			; $7d69
	ld a,$80		; $7d6a
	ld ($cca4),a		; $7d6c
	ld a,$01		; $7d6f
	ld ($cc02),a		; $7d71
	ld hl,$6362		; $7d74
	call interactionSetScript		; $7d77
	ld h,d			; $7d7a
	ld l,$44		; $7d7b
	ld (hl),$02		; $7d7d
	inc l			; $7d7f
	ld (hl),$00		; $7d80
	pop bc			; $7d82
	ret			; $7d83
_label_08_351:
	call interactionAnimate		; $7d84
	ld e,$7e		; $7d87
	ld a,(de)		; $7d89
	or a			; $7d8a
	jr z,_label_08_352	; $7d8b
	ld e,$60		; $7d8d
	ld a,(de)		; $7d8f
	cp $0d			; $7d90
	jr nz,_label_08_352	; $7d92
	ld e,$60		; $7d94
	ld a,$01		; $7d96
	ld (de),a		; $7d98
_label_08_352:
	call objectPreventLinkFromPassing		; $7d99
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7d9c


; ==============================================================================
; INTERACID_GURU_GURU
; ==============================================================================
interactionCode58:
	ld e,$44		; $7d9f
	ld a,(de)		; $7da1
	rst_jumpTable			; $7da2
	and a			; $7da3
	ld a,l			; $7da4
	call nc,$cd7d		; $7da5
	jp hl			; $7da8
	dec d			; $7da9
	ld h,d			; $7daa
	ld l,$44		; $7dab
	ld (hl),$01		; $7dad
	ld l,$7c		; $7daf
	ld (hl),$01		; $7db1
	ld l,$77		; $7db3
	ld (hl),$78		; $7db5
	ld l,$7b		; $7db7
	ld (hl),$01		; $7db9
	ld l,$79		; $7dbb
	ld (hl),$01		; $7dbd
	ld l,$50		; $7dbf
	ld (hl),$0f		; $7dc1
	call $7e20		; $7dc3
	ld a,$0b		; $7dc6
	call interactionSetHighTextIndex		; $7dc8
	ld hl,$63ad		; $7dcb
	call interactionSetScript		; $7dce
	jp $7ddc		; $7dd1
	call interactionRunScript		; $7dd4
	call $7deb		; $7dd7
	jr _label_08_353		; $7dda
_label_08_353:
	ld e,$79		; $7ddc
	ld a,(de)		; $7dde
	or a			; $7ddf
	jr z,_label_08_354	; $7de0
	call interactionAnimate		; $7de2
_label_08_354:
	call objectPreventLinkFromPassing		; $7de5
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7de8
	ld e,$78		; $7deb
	ld a,(de)		; $7ded
	rst_jumpTable			; $7dee
	di			; $7def
	ld a,l			; $7df0
	jr c,$7e		; $7df1
	ld e,$7b		; $7df3
	ld a,(de)		; $7df5
	or a			; $7df6
	jr z,_label_08_355	; $7df7
	ld h,d			; $7df9
	ld l,$77		; $7dfa
	dec (hl)		; $7dfc
	ret nz			; $7dfd
	ld (hl),$78		; $7dfe
	ld l,$49		; $7e00
	ld a,(hl)		; $7e02
	xor $10			; $7e03
	ld (hl),a		; $7e05
	ld l,$7a		; $7e06
	ld a,(hl)		; $7e08
	xor $02			; $7e09
	ld (hl),a		; $7e0b
	jp interactionSetAnimation		; $7e0c
_label_08_355:
	ld h,d			; $7e0f
	ld l,$78		; $7e10
	ld (hl),$01		; $7e12
	ld l,$79		; $7e14
	ld (hl),$00		; $7e16
	ld a,($d00d)		; $7e18
	ld l,$4d		; $7e1b
	cp (hl)			; $7e1d
	jr nc,_label_08_356	; $7e1e
	ld l,$49		; $7e20
	ld (hl),$18		; $7e22
	ld l,$7a		; $7e24
	ld a,$03		; $7e26
	ld (hl),a		; $7e28
	jp interactionSetAnimation		; $7e29
_label_08_356:
	ld l,$49		; $7e2c
	ld (hl),$08		; $7e2e
	ld l,$7a		; $7e30
	ld a,$01		; $7e32
	ld (hl),a		; $7e34
	jp interactionSetAnimation		; $7e35
	ld e,$7b		; $7e38
	ld a,(de)		; $7e3a
	or a			; $7e3b
	ret z			; $7e3c
	ld h,d			; $7e3d
	ld l,$78		; $7e3e
	ld (hl),$00		; $7e40
	ld l,$79		; $7e42
	ld (hl),$01		; $7e44
	ld l,$77		; $7e46
	ld (hl),$78		; $7e48
	ret			; $7e4a


; ==============================================================================
; INTERACID_LOST_WOODS_SWORD
; ==============================================================================
interactionCode59:
	ld e,$44		; $7e4b
	ld a,(de)		; $7e4d
	rst_jumpTable			; $7e4e
	ld d,e			; $7e4f
	ld a,(hl)		; $7e50
	adc c			; $7e51
	ld a,(hl)		; $7e52
	call getThisRoomFlags		; $7e53
	and $40			; $7e56
	jp nz,interactionDelete		; $7e58
	ld a,$05		; $7e5b
	call checkTreasureObtained		; $7e5d
	jr nc,_label_08_357	; $7e60
	cp $03			; $7e62
	jp nc,interactionDelete		; $7e64
	sub $01			; $7e67
	ld e,$42		; $7e69
	ld (de),a		; $7e6b
_label_08_357:
	call interactionInitGraphics		; $7e6c
	call interactionIncState		; $7e6f
	call objectSetVisible		; $7e72
	call objectSetVisible80		; $7e75
	ld hl,$63ff		; $7e78
	call interactionSetScript		; $7e7b
	ld a,$4d		; $7e7e
	call playSound		; $7e80
	ld bc,$8404		; $7e83
	jp objectCreateInteraction		; $7e86
	call interactionRunScript		; $7e89
	jp c,interactionDelete		; $7e8c
	ret			; $7e8f


; ==============================================================================
; INTERACID_BLAINO_SCRIPT
; ==============================================================================
interactionCode5a:
	ld e,Interaction.state		; $7e90
	ld a,(de)		; $7e92
	rst_jumpTable			; $7e93
	.dw @state0
	.dw @state1
	.dw @state2
	.dw interactionRunScript

@state0:
	ld a,$01		; $7e9c
	ld (de),a		; $7e9e
	call interactionSetAlwaysUpdateBit		; $7e9f
	ld a,>TX_2300		; $7ea2
	call interactionSetHighTextIndex		; $7ea4
	ld hl,blainoScript		; $7ea7
	call interactionSetScript		; $7eaa

@state1:
	call interactionRunScript		; $7ead
	ret nc			; $7eb0
	ld h,d			; $7eb1
	ld l,Interaction.enabled		; $7eb2
	ld (hl),$01		; $7eb4
	ld l,Interaction.state		; $7eb6
	ld (hl),$02		; $7eb8
	ld a,$02		; $7eba
	ld ($cced),a		; $7ebc
	xor a			; $7ebf
	ld ($ccec),a		; $7ec0
	inc a			; $7ec3
	ld (wInBoxingMatch),a		; $7ec4
	ret			; $7ec7

@state2:
	call @checkFightDone		; $7ec8
	ret z			; $7ecb
	call restartSound		; $7ecc
	call interactionSetAlwaysUpdateBit		; $7ecf
	ld l,Interaction.state		; $7ed2
	ld (hl),$03		; $7ed4
	ld a,$03		; $7ed6
	ld ($cced),a		; $7ed8
	xor a			; $7edb
	ld ($cca7),a		; $7edc
	call resetLinkInvincibility		; $7edf
	xor a			; $7ee2
	ld (wInBoxingMatch),a		; $7ee3
	ld hl,blainoFightDoneScript		; $7ee6
	call interactionSetScript		; $7ee9
	jp interactionRunScript		; $7eec

@checkFightDone:
	ld hl,wInventoryB		; $7eef
	ld a,($cca7)		; $7ef2
	or (hl)			; $7ef5
	inc l			; $7ef6
	or (hl)			; $7ef7
	ld a,$03		; $7ef8
	; equipped items (cheated)
	jr nz,+			; $7efa
	ld a,Object.yh		; $7efc
	call objectGetRelatedObject1Var		; $7efe
	call @checkOutsideRing		; $7f01
	; won
	ld a,$01		; $7f04
	jr nc,+			; $7f06
	ld hl,w1Link.yh		; $7f08
	call @checkOutsideRing		; $7f0b
	; lost
	ld a,$02		; $7f0e
	jr nc,+			; $7f10
	xor a			; $7f12
+
	ld ($ccec),a		; $7f13
	or a			; $7f16
	ret			; $7f17

@checkOutsideRing:
	ldi a,(hl)		; $7f18
	sub $16			; $7f19
	cp $4c			; $7f1b
	ret nc			; $7f1d
	inc l			; $7f1e
	ld a,(hl)		; $7f1f
	sub $22			; $7f20
	cp $5c			; $7f22
	ret			; $7f24


interactionCode5b:
	ld e,$44		; $7f25
	ld a,(de)		; $7f27
	rst_jumpTable			; $7f28
	dec l			; $7f29
	ld a,a			; $7f2a
	ld c,h			; $7f2b
	ld a,a			; $7f2c
	call interactionInitGraphics		; $7f2d
	ld a,$86		; $7f30
	call loadPaletteHeader		; $7f32
	call interactionSetAlwaysUpdateBit		; $7f35
	ld a,$0b		; $7f38
	call interactionSetHighTextIndex		; $7f3a
	ld h,d			; $7f3d
	ld l,$44		; $7f3e
	ld (hl),$01		; $7f40
	ld l,$49		; $7f42
	ld (hl),$04		; $7f44
	ld hl,$6506		; $7f46
	call interactionSetScript		; $7f49
	call interactionRunScript		; $7f4c
	call $7f55		; $7f4f
	jp interactionAnimateAsNpc		; $7f52
	ld e,$79		; $7f55
	ld a,(de)		; $7f57
	rst_jumpTable			; $7f58
	ld e,l			; $7f59
	ld a,a			; $7f5a
	ld l,l			; $7f5b
	ld a,a			; $7f5c
	ld h,d			; $7f5d
	ld l,$77		; $7f5e
	ld a,(hl)		; $7f60
	cp $04			; $7f61
	ret nz			; $7f63
	ld l,$79		; $7f64
	ld (hl),$01		; $7f66
	ld a,$3d		; $7f68
	jp playSound		; $7f6a
	ret			; $7f6d


; ==============================================================================
; INTERACID_LAVA_SOUP_SUBROSIAN
; ==============================================================================
interactionCode5c:
	ld e,$44		; $7f6e
	ld a,(de)		; $7f70
	rst_jumpTable			; $7f71
	halt			; $7f72
	ld a,a			; $7f73
	adc e			; $7f74
	ld a,a			; $7f75
	call interactionInitGraphics		; $7f76
	call interactionIncState		; $7f79
	ld l,$49		; $7f7c
	ld (hl),$04		; $7f7e
	ld a,$0b		; $7f80
	call interactionSetHighTextIndex		; $7f82
	ld hl,$654a		; $7f85
	call interactionSetScript		; $7f88
	call interactionRunScript		; $7f8b
	ld e,$7f		; $7f8e
	ld a,(de)		; $7f90
	or a			; $7f91
	jp z,npcFaceLinkAndAnimate		; $7f92
	call interactionAnimate		; $7f95
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7f98


; ?
interactionCode5d:
	ld e,$44		; $7f9b
	ld a,(de)		; $7f9d
	rst_jumpTable			; $7f9e
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics		; $7fa3
	ld a,$06		; $7fa6
	call objectSetCollideRadius		; $7fa8
	ld l,$44		; $7fab
	inc (hl)		; $7fad
	jp objectSetVisiblec0		; $7fae
@state1:
	ld e,$42		; $7fb1
	ld a,(de)		; $7fb3
	ld hl,$cfde		; $7fb4
	call checkFlag		; $7fb7
	jp nz,interactionDelete		; $7fba
	jp objectPreventLinkFromPassing		; $7fbd
