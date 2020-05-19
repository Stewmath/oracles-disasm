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
	ld (hl),INTERACID_D1_RISING_STONES		; $54bc
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
	; from interactioncode3e - b = $04/$05/$06
	; from interactioncode80 - b = $07
	ld a,b			; $57db
	ld hl,_conditionalHoronNPCLookupTable		; $57dc
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
	ld a,GLOBALFLAG_GNARLED_KEY_GIVEN		; $5808
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

_conditionalHoronNPCLookupTable:
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


; ==============================================================================
; INTERACID_MITTENS
; ==============================================================================
interactionCode25:
; ==============================================================================
; INTERACID_MITTENS_OWNER
; ==============================================================================
interactionCode26:
	ld e,$44		; $5a0e
	ld a,(de)		; $5a10
	rst_jumpTable			; $5a11
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call interactionInitGraphics		; $5a18
	ld a,>TX_0b00		; $5a1b
	call interactionSetHighTextIndex		; $5a1d
	ld e,$41		; $5a20
	ld a,(de)		; $5a22
	cp INTERACID_MITTENS_OWNER			; $5a23
	jr z,@mittensOwner		; $5a25
	call getThisRoomFlags		; $5a27
	and $40			; $5a2a
	ld e,$42		; $5a2c
	ld a,(de)		; $5a2e
	jr nz,@@savedMittens		; $5a2f
	or a			; $5a31
	jp nz,interactionDelete		; $5a32
	jr @incStateSetScript		; $5a35
@@savedMittens:
	or a			; $5a37
	jp z,interactionDelete		; $5a38
	jr @incStateSetScript		; $5a3b
@mittensOwner:
	call getThisRoomFlags		; $5a3d
	and $40			; $5a40
	ld e,$42		; $5a42
	ld a,(de)		; $5a44
	jr nz,@@savedMittens			; $5a45
	or a			; $5a47
	jp nz,interactionDelete		; $5a48
	call @func_5a78		; $5a4b
	ld a,$00		; $5a4e
	call interactionSetAnimation		; $5a50
	jp @animate		; $5a53
@@savedMittens:
	or a			; $5a56
	jp z,interactionDelete		; $5a57
	call @func_5a78		; $5a5a
	ld a,$02		; $5a5d
	call interactionSetAnimation		; $5a5f
	jp @animate		; $5a62
@incStateSetScript:
	ld h,d			; $5a65
	ld l,$44		; $5a66
	ld (hl),$01		; $5a68
	ld hl,mittensScript		; $5a6a
	call interactionSetScript		; $5a6d
	ld a,$02		; $5a70
	call interactionSetAnimation		; $5a72
	jp @animate		; $5a75
@func_5a78:
	ld h,d			; $5a78
	ld l,$44		; $5a79
	ld (hl),$02		; $5a7b
	ld hl,mittensOwnerScript		; $5a7d
	jp interactionSetScript		; $5a80
@state1:
	call interactionRunScript		; $5a83
	ld a,($cceb)		; $5a86
	or a			; $5a89
	jp z,npcFaceLinkAndAnimate		; $5a8a
	call _func_5a99		; $5a8d
	jp @animate		; $5a90
@state2:
	call interactionRunScript		; $5a93
@animate:
	jp interactionAnimateAsNpc		; $5a96
	
_func_5a99:
	ld e,$78		; $5a99
	ld a,(de)		; $5a9b
	rst_jumpTable			; $5a9c
	.dw @var38_00
	.dw @var38_01
	.dw @var38_02
	.dw @var38_03
@var38_00:
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
@var38_01:
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
@var38_02:
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
@var38_03:
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
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $5b04
	ld (de),a		; $5b06
	ld a,GLOBALFLAG_FINISHEDGAME		; $5b07
	call checkGlobalFlag		; $5b09
	jp nz,interactionDelete		; $5b0c
	ld a,>TX_5200		; $5b0f
	call interactionSetHighTextIndex		; $5b11
	call interactionInitGraphics		; $5b14
	ld e,$42		; $5b17
	ld a,(de)		; $5b19
	rst_jumpTable			; $5b1a
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
@@runScriptSetVisible:
	call interactionRunScript		; $5b21
	call interactionRunScript		; $5b24
	jp objectSetVisiblec2		; $5b27
@@subid0:
	ld a,(wObtainedSeasons)		; $5b2a
	and $02			; $5b2d
	jr nz,+			; $5b2f
	ld a,<ROOM_SEASONS_071		; $5b31
	call getARoomFlags		; $5b33
	bit 6,a			; $5b36
	jp nz,interactionDelete		; $5b38
+
	ld hl,sokraScript_inVillage		; $5b3b
	call interactionSetScript		; $5b3e
	jr @@runScriptSetVisible		; $5b41
@@subid1:
	ld a,(wObtainedSeasons)		; $5b43
	and $08			; $5b46
	jr z,+			; $5b48
	call getThisRoomFlags		; $5b4a
	bit 6,a			; $5b4d
	jr nz,+			; $5b4f
	ld hl,sokraScript_easternSuburbsPortal		; $5b51
	call interactionSetScript		; $5b54
	jr @@runScriptSetVisible		; $5b57
+
	ld hl,objectData.objectData7e4a		; $5b59
	call parseGivenObjectData		; $5b5c
	jp interactionDelete		; $5b5f
@@subid2:
	call getThisRoomFlags		; $5b62
	ld a,(wObtainedSeasons)		; $5b65
	and $02			; $5b68
	jr z,+			; $5b6a
	res 6,(hl)		; $5b6c
	jp interactionDelete		; $5b6e
+
	set 6,(hl)		; $5b71
	ld hl,sokraScript_needSummerForD3		; $5b73
	call interactionSetScript		; $5b76
	jr @@runScriptSetVisible		; $5b79
@state1:
	ld e,$42		; $5b7b
	ld a,(de)		; $5b7d
	rst_jumpTable			; $5b7e
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
@@subid0:
	call interactionRunScript		; $5b85
	call interactionAnimateAsNpc		; $5b88
	ld a,TREASURE_SEED_SATCHEL		; $5b8b
	call checkTreasureObtained		; $5b8d
	ret nc			; $5b90
	call getThisRoomFlags		; $5b91
	bit 6,(hl)		; $5b94
	jr z,+			; $5b96
	ld e,$43		; $5b98
	ld a,(de)		; $5b9a
	or a			; $5b9b
	jr nz,++		; $5b9c
	ret			; $5b9e
+
	ld a,($d00d)		; $5b9f
	cp $78			; $5ba2
	ret c			; $5ba4
	ld a,($d00b)		; $5ba5
	cp $3c			; $5ba8
	ret c			; $5baa
	cp $60			; $5bab
	ret nc			; $5bad
@@func_5bae:
	ld e,$77		; $5bae
	ld a,$01		; $5bb0
	ld (de),a		; $5bb2
	ret			; $5bb3
++
	ld a,(wFrameCounter)		; $5bb4
	and $3f			; $5bb7
	ret nz			; $5bb9
	ld b,$f4		; $5bba
	ld c,$fa		; $5bbc
	jp objectCreateFloatingMusicNote		; $5bbe
@@subid1:
	call interactionAnimateAsNpc		; $5bc1
	call interactionRunScript		; $5bc4
	jp c,interactionDelete		; $5bc7
	call checkInteractionState2		; $5bca
	ret nz			; $5bcd
	ld a,($d00d)		; $5bce
	cp $18			; $5bd1
	ret c			; $5bd3
	call interactionIncState2		; $5bd4
	call @@func_5bae		; $5bd7
	jp _beginJump		; $5bda
@@subid2:
	ld a,(wDisabledObjects)		; $5bdd
	and $01			; $5be0
	call z,createSokraSnore		; $5be2
	call interactionAnimateAsNpc		; $5be5
	jp interactionRunScript		; $5be8


; ==============================================================================
; INTERACID_BIPIN
; ==============================================================================
interactionCode28:
	ld e,Interaction.state		; $5385
	ld a,(de)		; $5387
	rst_jumpTable			; $5388
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics		; $538d
	call interactionIncState		; $5390

	; Decide what script to load based on subid
	ld e,Interaction.subid		; $5393
	ld a,(de)		; $5395
	ld hl,@scriptTable		; $5396
	rst_addDoubleIndex			; $5399
	ldi a,(hl)		; $539a
	ld h,(hl)		; $539b
	ld l,a			; $539c
	call interactionSetScript		; $539d

	ld e,Interaction.subid		; $53a0
	ld a,(de)		; $53a2
	rst_jumpTable			; $53a3
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
	ld h,d			; $53ba
	ld l,Interaction.speed		; $53bb
	ld (hl),SPEED_100		; $53bd
	ld l,Interaction.angle		; $53bf
	ld (hl),$18		; $53c1

	ld l,Interaction.var3a		; $53c3
	ld a,$04		; $53c5
	ld (hl),a		; $53c7
	call interactionSetAnimation		; $53c8

	jp @updateCollisionAndVisibility		; $53cb


; Bipin gives you a random tip
@bipin1:
	ld a,$03		; $53ce
	call interactionSetAnimation		; $53d0
	jp @updateCollisionAndVisibility		; $53d3


; Bipin just moved to Labrynna/Holodrum?
@bipin2:
	ld a,$02		; $53d6
	call interactionSetAnimation		; $53d8
	jp @updateCollisionAndVisibility		; $53db


.ifdef ROM_AGES
; "Past" version of Bipin who gives you a gasha seed
@bipin3:
	ld a,$09		; $53de
	call interactionSetAnimation		; $53e0
	jp @updateCollisionAndVisibility		; $53e3
.endif


@state1:
	ld e,Interaction.subid		; $53e6
	ld a,(de)		; $53e8
	rst_jumpTable			; $53e9
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
	call @updateSpeed		; $5400

@runScriptAndAnimate:
	call interactionRunScript		; $5403
	jp @updateAnimation		; $5406

@updateAnimation:
	call interactionAnimate		; $5409

@updateCollisionAndVisibility:
	call objectPreventLinkFromPassing		; $540c
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $540f


; Bipin runs around like a madman when his baby is first born
@updateSpeed:
	call objectApplySpeed		; $5412
	ld e,Interaction.xh		; $5415
	ld a,(de)		; $5417
	sub $28			; $5418
	cp $30			; $541a
	ret c			; $541c

	; Reverse direction
	ld h,d			; $541d
	ld l,Interaction.angle		; $541e
	ld a,(hl)		; $5420
	xor $10			; $5421
	ld (hl),a		; $5423

	ld l,Interaction.var3a		; $5424
	ld a,(hl)		; $5426
	xor $01			; $5427
	ld (hl),a		; $5429
	jp interactionSetAnimation		; $542a


@scriptTable:
	.dw bipinScript0
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript2
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript1
.ifdef ROM_AGES
	.dw bipinScript3
.endif


; ==============================================================================
; INTERACID_S_BIRD
; ==============================================================================
interactionCode2a:
	call checkInteractionState		; $5c9b
	jr nz,@state1	; $5c9e

@state0:
	ld a,$01		; $5ca0
	ld (de),a		; $5ca2
	call interactionInitGraphics		; $5ca3
	ld e,$42		; $5ca6
	ld a,(de)		; $5ca8
	cp $0a			; $5ca9
	jr z,@birdWithImpa	; $5cab
	cp $0b			; $5cad
	jr nz,@knowItAllBird	; $5caf
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA		; $5cb1
	call checkGlobalFlag		; $5cb3
	jp z,interactionDelete		; $5cb6
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE		; $5cb9
	call checkGlobalFlag		; $5cbb
	jp nz,interactionDelete		; $5cbe
	ld hl,panickingBirdScript		; $5cc1
	jr @setScript		; $5cc4
@knowItAllBird:
	ld hl,knowItAllBirdScript		; $5cc6
@setScript:
	call interactionSetScript		; $5cc9

	call getRandomNumber_noPreserveVars		; $5ccc
	and $01			; $5ccf
	ld e,$48		; $5cd1
	ld (de),a		; $5cd3
	call interactionSetAnimation		; $5cd4
	call interactionSetAlwaysUpdateBit		; $5cd7
	
	ld l,$76		; $5cda
	ld (hl),$1e		; $5cdc
	
	call _beginJump		; $5cde
	ld l,$42		; $5ce1
	ld a,(hl)		; $5ce3
	ld l,$72		; $5ce4
	ld (hl),a		; $5ce6
	
	ld l,$73		; $5ce7
	ld (hl),$32		; $5ce9
	jp objectSetVisible82		; $5ceb
@birdWithImpa:
	call interactionSetAlwaysUpdateBit		; $5cee
	ld l,$46		; $5cf1
	ld (hl),$b4		; $5cf3
	ld l,$50		; $5cf5
	ld (hl),$19		; $5cf7
	call _beginJump		; $5cf9
	call objectSetVisible82		; $5cfc
	jp objectSetInvisible		; $5cff
@state1:
	ld e,$42		; $5d02
	ld a,(de)		; $5d04
	cp $0a			; $5d05
	jr z,@panickingBirdState1	; $5d07
	call interactionRunScript		; $5d09
	ld e,$45		; $5d0c
	ld a,(de)		; $5d0e
	rst_jumpTable			; $5d0f
	.dw @substate0
	.dw @substate1
@substate0:
	ld e,$77		; $5d14
	ld a,(de)		; $5d16
	or a			; $5d17
	jr z,@label_10_337	; $5d18
	
	call interactionIncState2		; $5d1a
	ld l,$48		; $5d1d
	ld a,(hl)		; $5d1f
	add $02			; $5d20
	jp interactionSetAnimation		; $5d22

@label_10_337:
	call @decVar36		; $5d25
	jr nz,@animate	; $5d28
	ld l,$76		; $5d2a
	ld (hl),$1e		; $5d2c
	call getRandomNumber		; $5d2e
	and $07			; $5d31
	jr nz,@animate	; $5d33
	ld l,$48		; $5d35
	ld a,(hl)		; $5d37
	xor $01			; $5d38
	ld (hl),a		; $5d3a
	jp interactionSetAnimation		; $5d3b

@animate:
	jp interactionAnimateAsNpc		; $5d3e

@substate1:
	call interactionAnimate		; $5d41
	ld e,$77		; $5d44
	ld a,(de)		; $5d46
	or a			; $5d47
	jp nz,_updateSpeedZ		; $5d48

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

@panickingBirdState1:
	ld e,$45		; $5d5c
	ld a,(de)		; $5d5e
	rst_jumpTable			; $5d5f
	.dw @panickingBirdSubstate0
	.dw @panickingBirdSubstate1
	.dw @panickingBirdSubstate2
	.dw @panickingBirdSubstate3
	.dw @panickingBirdSubstate4
@panickingBirdSubstate0:
	ld a,(wUseSimulatedInput)		; $5d6a
	or a			; $5d6d
	ret nz			; $5d6e
	call interactionDecCounter1		; $5d6f
	ret nz			; $5d72
	ld l,$45		; $5d73
	inc (hl)		; $5d75
	call _func_5e04		; $5d76
	jp objectSetVisible		; $5d79
@panickingBirdSubstate1:
	call interactionAnimateAsNpc		; $5d7c
	call _updateSpeedZ		; $5d7f
	ld a,(wFrameCounter)		; $5d82
	and $07			; $5d85
	call z,_func_5e04		; $5d87
	ld c,$10		; $5d8a
	call _func_5e22		; $5d8c
	jp nc,objectApplySpeed		; $5d8f
	ld h,d			; $5d92
	ld l,$45		; $5d93
	inc (hl)		; $5d95
	ld l,$46		; $5d96
	ld (hl),$14		; $5d98
	ld l,$4f		; $5d9a
	ld (hl),$00		; $5d9c
	jp _beginJump		; $5d9e
@panickingBirdSubstate2:
	call interactionAnimateAsNpc		; $5da1
	call interactionDecCounter1		; $5da4
	ret nz			; $5da7
	ld l,$45		; $5da8
	inc (hl)		; $5daa
	ld l,$78		; $5dab
	ld a,(hl)		; $5dad
	add $02			; $5dae
	jp interactionSetAnimation		; $5db0
@panickingBirdSubstate3:
	call interactionAnimateAsNpc		; $5db3
	call @func_5de5		; $5db6
	ld e,$4f		; $5db9
	ld a,(de)		; $5dbb
	or a			; $5dbc
	ret nz			; $5dbd
	ld c,$18		; $5dbe
	call _func_5e22		; $5dc0
	ret c			; $5dc3
	ld h,d			; $5dc4
	ld l,$45		; $5dc5
	inc (hl)		; $5dc7
	call _beginJump		; $5dc8
	jp _func_5e04		; $5dcb
@panickingBirdSubstate4:
	call interactionAnimateAsNpc		; $5dce
	call _updateSpeedZ		; $5dd1
	ld a,(wFrameCounter)		; $5dd4
	and $07			; $5dd7
	call z,_func_5e04		; $5dd9
	call objectApplySpeed		; $5ddc
	call objectCheckWithinScreenBoundary		; $5ddf
	jp nc,interactionDelete		; $5de2
@func_5de5:
	ld c,$10		; $5de5
	call objectUpdateSpeedZ_paramC		; $5de7
	ret nz			; $5dea
	ld h,d			; $5deb
	ld bc,$fec0		; $5dec
	jp objectSetSpeedZ		; $5def
	
@decVar36:
	ld h,d			; $5df2
	ld l,$76		; $5df3
	dec (hl)		; $5df5
	ret			; $5df6

_updateSpeedZ:
	ld c,$20		; $5df7
	call objectUpdateSpeedZ_paramC		; $5df9
	ret nz			; $5dfc
	ld h,d			; $5dfd

_beginJump:
	ld bc,$ff40		; $5dfe
	jp objectSetSpeedZ		; $5e01

_func_5e04:
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
_func_5e22:
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
	ld e,Interaction.state		; $54b8
	ld a,(de)		; $54ba
	rst_jumpTable			; $54bb
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics		; $54c0
	ld a,>TX_4400		; $54c3
	call interactionSetHighTextIndex		; $54c5
	call interactionIncState		; $54c8

	ld e,Interaction.subid		; $54cb
	ld a,(de)		; $54cd
	ld hl,@scriptTable		; $54ce
	rst_addDoubleIndex			; $54d1
	ldi a,(hl)		; $54d2
	ld h,(hl)		; $54d3
	ld l,a			; $54d4
	call interactionSetScript		; $54d5

	ld e,Interaction.subid		; $54d8
	ld a,(de)		; $54da
	rst_jumpTable			; $54db
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
	ld a,$00		; $54f0
	call interactionSetAnimation		; $54f2
	jp @updateCollisionAndVisibility		; $54f5

@initAnimation4:
	ld a,$04		; $54f8
	call interactionSetAnimation		; $54fa
	jp @updateCollisionAndVisibility		; $54fd

@state1:
	call interactionRunScript		; $5500
	jp @updateAnimation		; $5503

@updateAnimation:
	call interactionAnimate		; $5506

@updateCollisionAndVisibility:
	call objectPreventLinkFromPassing		; $5509
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $550c

@scriptTable:
	.dw blossomScript0
	.dw blossomScript1
	.dw blossomScript2
	.dw blossomScript3
	.dw blossomScript4
	.dw blossomScript5
	.dw blossomScript6
	.dw blossomScript7
	.dw blossomScript8
	.dw blossomScript9


; ==============================================================================
; INTERACID_FICKLE_GIRL
; ==============================================================================
interactionCode2e:
	ld e,$44		; $5e9a
	ld a,(de)		; $5e9c
	rst_jumpTable			; $5e9d
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $5ea2
	ld (de),a		; $5ea4
	call getSunkenCityNPCVisibleSubId@main		; $5ea5
	ld e,$42		; $5ea8
	ld a,(de)		; $5eaa
	cp b			; $5eab
	jp nz,interactionDelete		; $5eac
	call interactionInitGraphics		; $5eaf
	ld a,(wActiveRoom)		; $5eb2
	cp <ROOM_SEASONS_06d			; $5eb5
	jr z,+			; $5eb7
	ld a,$01		; $5eb9
	ld e,$48		; $5ebb
	ld (de),a		; $5ebd
	call interactionSetAnimation		; $5ebe
+
	ld e,$42		; $5ec1
	ld a,(de)		; $5ec3
	ld hl,_table_5f7e		; $5ec4
	rst_addDoubleIndex			; $5ec7
	ldi a,(hl)		; $5ec8
	ld h,(hl)		; $5ec9
	ld l,a			; $5eca
	call interactionSetScript		; $5ecb
	call getFreeInteractionSlot		; $5ece
	jr nz,+			; $5ed1
	ld (hl),INTERACID_8e		; $5ed3
	inc l			; $5ed5
	ld (hl),$00		; $5ed6
	ld l,$57		; $5ed8
	ld (hl),d		; $5eda
	ld l,$49		; $5edb
	call @func_5f4e		; $5edd
+
	jr @var03_00			; $5ee0
@state1:
	call interactionRunScript		; $5ee2
	ld e,$43		; $5ee5
	ld a,(de)		; $5ee7
	rst_jumpTable			; $5ee8
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02
	.dw @var03_03
@var03_00:
	call interactionAnimate		; $5ef1
	ld e,$61		; $5ef4
	ld a,(de)		; $5ef6
	inc a			; $5ef7
	jr nz,@pushLinkAwayUpdateDrawPriority			; $5ef8
@func_5efa:
	call _func_5f70		; $5efa
@pushLinkAwayUpdateDrawPriority:
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $5efd
@var03_01:
	call interactionAnimate		; $5f00
	ld e,$61		; $5f03
	ld a,(de)		; $5f05
	or a			; $5f06
	jr z,@pushLinkAwayUpdateDrawPriority	; $5f07
	call @func_5f65		; $5f09
	call getRandomNumber_noPreserveVars		; $5f0c
	and $03			; $5f0f
	jr nz,@func_5f3b	; $5f11
	inc a			; $5f13
	jr @func_5f3b		; $5f14
@var03_02:
@var03_03:
	call interactionAnimate		; $5f16
	ld e,$61		; $5f19
	ld a,(de)		; $5f1b
	cp $02			; $5f1c
	jr nz,@pushLinkAwayUpdateDrawPriority	; $5f1e
	call @func_5f65		; $5f20
	call getFreePartSlot		; $5f23
	jr nz,+			; $5f26
	ld (hl),PARTID_32		; $5f28
	inc l			; $5f2a
	ld (hl),$01		; $5f2b
	ld l,$c9		; $5f2d
	call @func_5f4e		; $5f2f
+
	call getRandomNumber_noPreserveVars		; $5f32
	and $03			; $5f35
	sub $02			; $5f37
	ret c			; $5f39
	inc a			; $5f3a
@func_5f3b:
	ld b,a			; $5f3b
-
	call getFreePartSlot		; $5f3c
	ret nz			; $5f3f
	ld (hl),PARTID_32		; $5f40
	inc l			; $5f42
	ld (hl),$00		; $5f43
	ld l,$c9		; $5f45
	call @func_5f4e		; $5f47
	dec b			; $5f4a
	jr nz,-			; $5f4b
	ret			; $5f4d
@func_5f4e:
	push bc			; $5f4e
	ld e,$48		; $5f4f
	ld a,(de)		; $5f51
	rrca			; $5f52
	ld c,$f8		; $5f53
	ld a,$1c		; $5f55
	jr nc,+			; $5f57
	ld c,$0a		; $5f59
	ld a,$06		; $5f5b
+
	ld (hl),a		; $5f5d
	ld b,$02		; $5f5e
	call objectCopyPositionWithOffset		; $5f60
	pop bc			; $5f63
	ret			; $5f64
@func_5f65:
	ld e,$48		; $5f65
	ld a,(de)		; $5f67
	and $01			; $5f68
	call interactionSetAnimation		; $5f6a
	call @func_5efa		; $5f6d
_func_5f70:
	ld e,$76		; $5f70
	ld a,$01		; $5f72
	ld (de),a		; $5f74
	call getRandomNumber_noPreserveVars		; $5f75
	and $03			; $5f78
	ld e,$43		; $5f7a
	ld (de),a		; $5f7c
	ret			; $5f7d

_table_5f7e:
	.dw sunkenCityFickleGirlScript_text1
	.dw sunkenCityFickleGirlScript_text2
	.dw sunkenCityFickleGirlScript_text2
	.dw sunkenCityFickleGirlScript_text3
	.dw sunkenCityFickleGirlScript_text2


; ==============================================================================
; INTERACID_S_SUBROSIAN
; ==============================================================================
interactionCode30:
	ld e,$44		; $5f88
	ld a,(de)		; $5f8a
	rst_jumpTable			; $5f8b
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
@state0:
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
	jr nz,+			; $5fac
	call checkIsLinkedGame		; $5fae
	jp z,interactionDelete		; $5fb1
	ld a,GLOBALFLAG_UNBLOCKED_AUTUMN_TEMPLE		; $5fb4
	call checkGlobalFlag		; $5fb6
	jp z,interactionDelete		; $5fb9
	ld e,$7e		; $5fbc
	ld a,GLOBALFLAG_BEGAN_PLEN_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET		; $5fbe
	ld (de),a		; $5fc0
+
	ld e,$42		; $5fc1
	ld a,(de)		; $5fc3
	ld hl,_table_607f		; $5fc4
	rst_addDoubleIndex			; $5fc7
	ldi a,(hl)		; $5fc8
	ld h,(hl)		; $5fc9
	ld l,a			; $5fca
	call interactionSetScript		; $5fcb
	call interactionRunScript		; $5fce
	call interactionRunScript		; $5fd1
	jp c,interactionDelete		; $5fd4
	jp objectSetVisible82		; $5fd7
@state1:
	ld a,(wActiveGroup)		; $5fda
	dec a			; $5fdd
	jr nz,+			; $5fde
	call objectGetTileAtPosition		; $5fe0
	ld (hl),$00		; $5fe3
+
	ld c,$20		; $5fe5
	call objectUpdateSpeedZ_paramC		; $5fe7
	call interactionRunScript		; $5fea
	jp c,interactionDelete		; $5fed
	jp npcFaceLinkAndAnimate		; $5ff0
@state2:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $5ff3
	call c,@func_600e		; $5ff6
@animateAndRunScript:
	call interactionAnimate		; $5ff9
	call interactionAnimate		; $5ffc
	call interactionRunScript		; $5fff
	ld c,$60		; $6002
	call objectUpdateSpeedZ_paramC		; $6004
	ret nz			; $6007
	ld bc,$fe00		; $6008
	jp objectSetSpeedZ		; $600b
@func_600e:
	ld hl,$cfc0		; $600e
	set 1,(hl)		; $6011
	ret			; $6013
@state3:
	call objectGetAngleTowardLink		; $6014
	ld e,$49		; $6017
	ld (de),a		; $6019
	call objectApplySpeed		; $601a
	jr @animateAndRunScript		; $601d
@state4:
	ld c,$20		; $601f
	call objectUpdateSpeedZ_paramC		; $6021
	call interactionRunScript		; $6024
	jp c,interactionDelete		; $6027
	ret			; $602a
@state5:
	call interactionRunScript		; $602b
	ld e,$45		; $602e
	ld a,(de)		; $6030
	rst_jumpTable			; $6031
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	ld a,($cfc0)		; $603a
	call getHighestSetBit		; $603d
	ret nc			; $6040
	cp $03			; $6041
	jr nz,+			; $6043
	ld e,$44		; $6045
	ld a,$04		; $6047
	ld (de),a		; $6049
	ret			; $604a
+
	ld b,a			; $604b
	inc a			; $604c
	ld e,$45		; $604d
	ld (de),a		; $604f
	ld a,b			; $6050
	add $04			; $6051
	jp interactionSetAnimation		; $6053
@substate1:
	call interactionAnimate		; $6056
	ld a,($cfc0)		; $6059
	or a			; $605c
	ret z			; $605d
	ld e,$45		; $605e
	xor a			; $6060
	ld (de),a		; $6061
	jr @substate0		; $6062
@substate2:
@substate3:
	call interactionAnimate		; $6064
	ld h,d			; $6067
	ld l,$61		; $6068
	ld a,(hl)		; $606a
	or a			; $606b
	jr z,+			; $606c
	ld (hl),$00		; $606e
	ld l,$4d		; $6070
	add (hl)		; $6072
	ld (hl),a		; $6073
+
	ld a,($cfc0)		; $6074
	or a			; $6077
	ret z			; $6078
	ld l,$45		; $6079
	ld (hl),$00		; $607b
	jr @substate0		; $607d

_table_607f:
	/* $00 */ .dw subrosianScript_smelterByAutumnTemple
	/* $01 */ .dw subrosianScript_smelterText1 ; unused?
	/* $02 */ .dw subrosianScript_smelterText1
	/* $03 */ .dw subrosianScript_smelterText2
	/* $04 */ .dw subrosianScript_smelterText3
	/* $05 */ .dw subrosianScript_smelterText4
	/* $06 */ .dw subrosianScript_beachText1
	/* $07 */ .dw subrosianScript_beachText2
	/* $08 */ .dw subrosianScript_beachText3
	/* $09 */ .dw subrosianScript_beachText4
	/* $0a */ .dw subrosianScript_villageText1
	/* $0b */ .dw subrosianScript_villageText2
	/* $0c */ .dw subrosianScript_shopkeeper
	/* $0d */ .dw subrosianScript_wildsText1
	/* $0e */ .dw subrosianScript_wildsText2
	/* $0f */ .dw subrosianScript_wildsText3
	/* $10 */ .dw subrosianScript_strangeBrother1_stealingFeather
	/* $11 */ .dw subrosianScript_strangeBrother2_stealingFeather
	/* $12 */ .dw subrosianScript_strangeBrother1_inHouse
	/* $13 */ .dw subrosianScript_strangeBrother2_inHouse
	/* $14 */ .dw subrosianScript_5716
	/* $15 */ .dw subrosianScript_westVolcanoesText1
	/* $16 */ .dw subrosianScript_westVolcanoesText2
	/* $17 */ .dw subrosianScript_eastVolcanoesText1
	/* $18 */ .dw subrosianScript_eastVolcanoesText2
	/* $19 */ .dw subrosianScript_southOfExitToSuburbsPortal
	/* $1a */ .dw subrosianScript_nearExitToTempleRemainsNorthsPortal
	/* $1b */ .dw subrosianScript_wildsNearLockedDoor
	/* $1c */ .dw subrosianScript_boomerangSubrosianFriend
	/* $1d */ .dw subrosianScript_screenRightOfBoomerangSubrosian
	/* $1e */ .dw subrosianScript_wildsInAreaWithOre
	/* $1f */ .dw subrosianScript_wildsOtherSideOfTreesToOre
	/* $20 */ .dw subrosianScript_wildsNorthOfStrangeBrothersHouse
	/* $21 */ .dw subrosianScript_wildsOutsideStrangeBrothersHouse
	/* $22 */ .dw subrosianScript_villageSouthOfShop
	/* $23 */ .dw subrosianScript_hasLavaPoolInHouse
	/* $24 */ .dw subrosianScript_beachText5
	/* $25 */ .dw subrosianScript_goldenByBombFlower
	/* $26 */ .dw subrosianScript_signsGuy


; ==============================================================================
; INTERACID_DATING_ROSA_EVENT
; ==============================================================================
interactionCode31:
	ld e,$42		; $60cd
	ld a,(de)		; $60cf
	rst_jumpTable			; $60d0
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
@subid0:
@subid3:
	ld e,$44		; $60d9
	ld a,(de)		; $60db
	rst_jumpTable			; $60dc
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01		; $60e1
	ld (de),a		; $60e3
	call interactionInitGraphics		; $60e4
	ld a,GLOBALFLAG_DATING_ROSA		; $60e7
	call checkGlobalFlag		; $60e9
	jp nz,interactionDelete		; $60ec
	ld h,d			; $60ef
	ld l,$6b		; $60f0
	ld (hl),$00		; $60f2
	ld l,$49		; $60f4
	ld (hl),$ff		; $60f6
	ld a,GLOBALFLAG_DATED_ROSA		; $60f8
	call checkGlobalFlag		; $60fa
	jr nz,+			; $60fd
	ld e,$77		; $60ff
	ld a,$04		; $6101
	ld (de),a		; $6103
+
	ld hl,rosaScript_goOnDate		; $6104
	call interactionSetScript		; $6107
	ld a,>TX_2900		; $610a
	call interactionSetHighTextIndex		; $610c
	call objectGetTileAtPosition		; $610f
	ld (hl),$00		; $6112
	jr +			; $6114
@@state1:
	call interactionRunScript		; $6116
+
	jp npcFaceLinkAndAnimate		; $6119
@subid1:
	ld e,$44		; $611c
	ld a,(de)		; $611e
	rst_jumpTable			; $611f
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
@@state0:
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
@@state1:
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $6156
	call @@func_61a4		; $6159
	ret c			; $615c
	ld c,$20		; $615d
	call objectUpdateSpeedZ_paramC		; $615f
	call z,@@func_6182		; $6162
	call @@func_628e		; $6165
	ld h,d			; $6168
	ld l,$4b		; $6169
	ld a,(hl)		; $616b
	ld b,a			; $616c
	ld l,$70		; $616d
	cp (hl)			; $616f
	jr nz,+			; $6170
	ld l,$4d		; $6172
	ld a,(hl)		; $6174
	ld c,a			; $6175
	ld l,$71		; $6176
	cp (hl)			; $6178
	ret z			; $6179
+
	ld l,$70		; $617a
	ld (hl),b		; $617c
	inc l			; $617d
	ld (hl),c		; $617e
	jp interactionAnimate		; $617f
@@func_6182:
	ld h,d			; $6182
	ld l,$46		; $6183
	ld a,(hl)		; $6185
	or a			; $6186
	jr z,+			; $6187
	dec (hl)		; $6189
	ret nz			; $618a
	ld bc,$fe40		; $618b
	jp objectSetSpeedZ		; $618e
+
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
@@func_61a4:
	ld a,(wActiveGroup)		; $61a4
	cp $06			; $61a7
	jr nc,@@goToState3	; $61a9
	ld a,(wActiveRoom)		; $61ab
	ld hl,@@roomTable_61dd		; $61ae
	call findRoomSpecificData		; $61b1
	ret nc			; $61b4
	rst_jumpTable			; $61b5
	.dw @@screenAboveRosa
	.dw @@beachEntranceScreen
	.dw @@goToState3
@@screenAboveRosa:
	ld e,$73		; $61bc
	ld a,(de)		; $61be
	or a			; $61bf
	jr nz,+			; $61c0
	ld a,($cd00)		; $61c2
	and $01			; $61c5
	jr z,+			; $61c7
	ld e,$44		; $61c9
	ld a,$02		; $61cb
	ld (de),a		; $61cd
	scf			; $61ce
	ret			; $61cf
+
	xor a			; $61d0
	ret			; $61d1
@@beachEntranceScreen:
	ld e,$73		; $61d2
	xor a			; $61d4
	ld (de),a		; $61d5
	ret			; $61d6
@@goToState3:
	ld e,$44		; $61d7
	ld a,$03		; $61d9
	ld (de),a		; $61db
	ret			; $61dc
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
	ld e,$45		; $61fb
	ld a,(de)		; $61fd
	rst_jumpTable			; $61fe
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
@@@substate0:
	ld a,$01		; $6205
	ld (de),a		; $6207
	call clearFollowingLinkObject		; $6208
	ld a,GLOBALFLAG_DATING_ROSA		; $620b
	call unsetGlobalFlag		; $620d
	ld a,$01		; $6210
	ld ($cca4),a		; $6212
	ld a,$02		; $6215
	ld ($d008),a		; $6217
	ld a,$29		; $621a
	call interactionSetHighTextIndex		; $621c
	ld hl,rosaScript_dateEnded		; $621f
	jp interactionSetScript		; $6222
@@@substate1:
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
@@@substate2:
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
@@state3:
	call returnIfScrollMode01Unset		; $626c
	ld e,$45		; $626f
	ld a,(de)		; $6271
	rst_jumpTable			; $6272
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	ld a,$01		; $6277
	ld (de),a		; $6279
	call clearFollowingLinkObject		; $627a
	ld a,GLOBALFLAG_DATING_ROSA		; $627d
	call unsetGlobalFlag		; $627f
	ld bc,TX_291a		; $6282
	jp showText		; $6285
@@@substate1:
	call retIfTextIsActive		; $6288
	jp interactionDelete		; $628b
@@func_628e:
	ld h,d			; $628e
	ld l,$48		; $628f
	ld a,(hl)		; $6291
	ld l,$72		; $6292
	cp (hl)			; $6294
	ret z			; $6295
	ld (hl),a		; $6296
	jp interactionSetAnimation		; $6297
@subid2:
	ld e,$44		; $629a
	ld a,(de)		; $629c
	rst_jumpTable			; $629d
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01		; $62a2
	ld (de),a		; $62a4
	ld a,GLOBALFLAG_STAR_ORE_FOUND		; $62a5
	call checkGlobalFlag		; $62a7
	jp nz,interactionDelete		; $62aa
	ld a,(wcc84)		; $62ad
	or a			; $62b0
	jp nz,interactionDelete		; $62b1
	ld a,d			; $62b4
	ld (wcc84),a		; $62b5
	ld h,d			; $62b8
	ld l,$40		; $62b9
	set 1,(hl)		; $62bb
	call getRandomNumber		; $62bd
	and $03			; $62c0
	ld hl,@@table_62d3		; $62c2
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
@@table_62d3:
	; var30 - var31
	.db $65 $57
	.db $66 $56
	.db $75 $27
	.db $76 $24
@@state1:
	ld e,$72		; $62db
	ld a,(de)		; $62dd
	ld b,a			; $62de
	ld a,(wActiveRoom)		; $62df
	cp b			; $62e2
	ret z			; $62e3
	ld (de),a		; $62e4
	ld b,a			; $62e5
	ld e,$70		; $62e6
	ld a,(de)		; $62e8
	cp b			; $62e9
	jr nz,+			; $62ea
	call getFreeInteractionSlot		; $62ec
	ret nz			; $62ef
	ld (hl),INTERACID_TREASURE		; $62f0
	inc l			; $62f2
	ld (hl),TREASURE_STAR_ORE		; $62f3
	ld e,$71		; $62f5
	ld a,(de)		; $62f7
	ld l,$4b		; $62f8
	jp setShortPosition		; $62fa
+
	ld a,TREASURE_STAR_ORE		; $62fd
	call checkTreasureObtained		; $62ff
	jr c,+			; $6302
	ld a,b			; $6304
	cp $60			; $6305
	ret nc			; $6307
-
	xor a			; $6308
	ld (wcc84),a		; $6309
	jp interactionDelete		; $630c
+
	ld a,GLOBALFLAG_STAR_ORE_FOUND		; $630f
	call setGlobalFlag		; $6311
	jr -			; $6314


; ==============================================================================
; INTERACID_SUBROSIAN_WITH_BUCKETS
; ==============================================================================
interactionCode32:
	ld e,$44		; $6316
	ld a,(de)		; $6318
	rst_jumpTable			; $6319
	.dw @state0
	.dw @state1
@state0:
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
	ld hl,@scriptTable		; $6330
	rst_addDoubleIndex			; $6333
	ldi a,(hl)		; $6334
	ld h,(hl)		; $6335
	ld l,a			; $6336
	call interactionSetScript		; $6337
	call interactionRunScript		; $633a
	call interactionRunScript		; $633d
	jp c,interactionDelete		; $6340
	jr @animateAsNpc		; $6343
@state1:
	ld a,(wActiveGroup)		; $6345
	dec a			; $6348
	jr nz,+			; $6349
	call objectGetTileAtPosition		; $634b
	ld (hl),$00		; $634e
+
	call interactionRunScript		; $6350
	ld c,$28		; $6353
	call objectCheckLinkWithinDistance		; $6355
	jr c,+			; $6358
	ld a,$04		; $635a
+
	ld l,$49		; $635c
	cp (hl)			; $635e
	jr z,@animateAsNpc	; $635f
	ld (hl),a		; $6361
	rrca			; $6362
	call interactionSetAnimation		; $6363
@animateAsNpc:
	jp interactionAnimateAsNpc		; $6366
@scriptTable:
	.dw bucketSubrosianScript_text1
	.dw bucketSubrosianScript_text2
	.dw bucketSubrosianScript_text3
	.dw bucketSubrosianScript_text4
	.dw bucketSubrosianScript_text5
	.dw bucketSubrosianScript_text6
	.dw bucketSubrosianScript_text1
	.dw bucketSubrosianScript_text1


; ==============================================================================
; INTERACID_SUBROSIAN_SMITHS
; ==============================================================================
interactionCode34:
	call checkInteractionState		; $6379
	jr nz,+			; $637c
	ld a,$01		; $637e
	ld (de),a		; $6380
	call interactionInitGraphics		; $6381
+
	call interactionAnimateAsNpc		; $6384
	ld e,$61		; $6387
	ld a,(de)		; $6389
	cp $ff			; $638a
	ret nz			; $638c
	ld a,$50		; $638d
	jp playSound		; $638f


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
	ld e,Interaction.state		; $650f
	ld a,(de)		; $6511
	rst_jumpTable			; $6512
	.dw @state0
	.dw _interac65_state1

@state0:
	call _childDetermineAnimationBase		; $6517
	call interactionInitGraphics		; $651a
	call interactionIncState		; $651d

	ld e,Interaction.var03		; $6520
	ld a,(de)		; $6522
	ld hl,_childScriptTable		; $6523
	rst_addDoubleIndex			; $6526
	ldi a,(hl)		; $6527
	ld h,(hl)		; $6528
	ld l,a			; $6529
	call interactionSetScript		; $652a

	ld e,Interaction.var03		; $652d
	ld a,(de)		; $652f
	rst_jumpTable			; $6530

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
	ld e,Interaction.var37		; $656b
	ld a,(de)		; $656d
	call interactionSetAnimation		; $656e
	jp _childUpdateSolidityAndVisibility		; $6571

@hyperactiveStage6:
	ld a,$02		; $6574
	call _childLoadPositionListPointer		; $6576

@hyperactiveStage4Or5:
	ld h,d			; $6579
	ld l,Interaction.var39		; $657a
	ld (hl),$01		; $657c

	ld l,Interaction.speed		; $657e
	ld (hl),SPEED_180		; $6580
	ld l,Interaction.angle		; $6582
	ld (hl),$18		; $6584

	ld a,$00		; $6586

@setAnimation:
	ld h,d			; $6588
	ld l,Interaction.var3a		; $6589
	ld (hl),a		; $658b
	ld l,Interaction.var37		; $658c
	add (hl)		; $658e
	call interactionSetAnimation		; $658f
	jp _childUpdateSolidityAndVisibility		; $6592

@val16:
	call @hyperactiveStage4Or5		; $6595
	ld h,d			; $6598
	ld l,Interaction.speed		; $6599
	ld (hl),SPEED_100		; $659b
	ret			; $659d

@shyStage4Or5:
	ld a,$00		; $659e
	call _childLoadPositionListPointer		; $65a0
	jr ++			; $65a3

@shyStage6:
	ld a,$01		; $65a5
	call _childLoadPositionListPointer		; $65a7
++
	ld h,d			; $65aa
	ld l,Interaction.var39		; $65ab
	ld (hl),$01		; $65ad
	ld l,Interaction.speed		; $65af
	ld (hl),SPEED_200		; $65b1
	ld a,$00		; $65b3
	jr @setAnimation		; $65b5

@curious:
	ld h,d			; $65b7
	ld l,Interaction.var39		; $65b8
	ld (hl),$02		; $65ba
	ld a,$00		; $65bc
	jr @setAnimation		; $65be

@slacker:
	ld a,$00		; $65c0
	jr @setAnimation		; $65c2

@warrior:
	ld a,$03		; $65c4
	call _childLoadPositionListPointer		; $65c6
	jr ++			; $65c9

@script0f:
	ld a,$04		; $65cb
	call _childLoadPositionListPointer		; $65cd
++
	ld h,d			; $65d0
	ld l,Interaction.var39		; $65d1
	ld (hl),$01		; $65d3
	ld l,Interaction.speed		; $65d5
	ld (hl),SPEED_80		; $65d7
	ld a,$00		; $65d9
	jr @setAnimation		; $65db

@arborist:
	ld a,$03		; $65dd
	jr @setAnimation		; $65df

@singer:
	ld a,$00		; $65e1
	jr @setAnimation		; $65e3


_interac65_state1:
	ld e,Interaction.var03		; $65e5
	ld a,(de)		; $65e7
	rst_jumpTable			; $65e8

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
	ld e,Interaction.counter1		; $6623
	ld a,(de)		; $6625
	or a			; $6626
	jr nz,+			; $6627
	call _childUpdateHyperactiveMovement		; $6629
+

@arboristMovement:
	call interactionRunScript		; $662c

@updateAnimationAndSolidity:
	jp _childUpdateAnimationAndSolidity		; $662f

@val16:
	call _childUpdateUnknownMovement		; $6632
	jp _childUpdateAnimationAndSolidity		; $6635

@shyMovement:
	ld e,Interaction.counter1		; $6638
	ld a,(de)		; $663a
	or a			; $663b
	jr nz,+			; $663c
	call _childUpdateShyMovement		; $663e
+
	jr @runScriptAndUpdateAnimation		; $6641

@usePositionList:
	ld e,Interaction.counter1		; $6643
	ld a,(de)		; $6645
	or a			; $6646
	jr nz,++		; $6647
	call _childUpdateAngleAndApplySpeed		; $6649
	call _childCheckAnimationDirectionChanged		; $664c
	call _childCheckReachedDestination		; $664f
	call c,_childIncPositionIndex		; $6652
++
	jr @runScriptAndUpdateAnimation		; $6655

@curiousMovement:
	call _childUpdateCuriousMovement		; $6657
	ld e,Interaction.var3d		; $665a
	ld a,(de)		; $665c
	or a			; $665d
	call z,interactionRunScript		; $665e

@val1b:
	jp _childUpdateAnimationAndSolidity		; $6661

@slackerMovement:
	ld a,(wFrameCounter)		; $6664
	and $1f			; $6667
	jr nz,++		; $6669
	ld e,Interaction.animParameter		; $666b
	ld a,(de)		; $666d
	and $01			; $666e
	ld c,$08		; $6670
	jr nz,+			; $6672
	ld c,$fc		; $6674
+
	ld b,$f4		; $6676
	call objectCreateFloatingMusicNote		; $6678
++
	jr @runScriptAndUpdateAnimation		; $667b

@singerMovement:
	ld a,(wFrameCounter)		; $667d
	and $1f			; $6680
	jr nz,@runScriptAndUpdateAnimation	; $6682
	ld e,Interaction.direction		; $6684
	ld a,(de)		; $6686
	or a			; $6687
	ld c,$fc		; $6688
	jr z,+			; $668a
	ld c,$00		; $668c
+
	ld b,$fc		; $668e
	call objectCreateFloatingMusicNote		; $6690

@runScriptAndUpdateAnimation:
	call interactionRunScript		; $6693
	jp _childUpdateAnimationAndSolidity		; $6696


;;
; @addr{6699}
_childUpdateAnimationAndSolidity:
	call interactionAnimate		; $6699

;;
; @addr{669c}
_childUpdateSolidityAndVisibility:
	ld e,Interaction.var39		; $669c
	ld a,(de)		; $669e
	cp $01			; $669f
	jr z,++			; $66a1
	cp $02			; $66a3
	jp z,objectSetPriorityRelativeToLink_withTerrainEffects		; $66a5
	call objectPreventLinkFromPassing		; $66a8
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $66ab
++
	call objectPushLinkAwayOnCollision		; $66ae
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $66b1

;;
; Writes the "base" animation index to var37 based on subid (personality type)?
; @addr{66b4}
_childDetermineAnimationBase:
	ld e,Interaction.subid		; $66b4
	ld a,(de)		; $66b6
	ld hl,@animations		; $66b7
	rst_addAToHl			; $66ba
	ld a,(hl)		; $66bb
	ld e,Interaction.var37		; $66bc
	ld (de),a		; $66be
	ret			; $66bf

@animations:
	.db $00 $02 $05 $08 $0b $11 $15 $17

;;
; @addr{66c8}
_childUpdateHyperactiveMovement:
	call objectApplySpeed		; $66c8
	ld h,d			; $66cb
	ld l,Interaction.xh		; $66cc
	ld a,(hl)		; $66ce
	sub $29			; $66cf
	cp $40			; $66d1
	ret c			; $66d3
	bit 7,a			; $66d4
	jr nz,+			; $66d6
	dec (hl)		; $66d8
	dec (hl)		; $66d9
+
	inc (hl)		; $66da
	ld l,Interaction.var3c		; $66db
	ld a,(hl)		; $66dd
	inc a			; $66de
	and $03			; $66df
	ld (hl),a		; $66e1
	ld bc,_childHyperactiveMovementAngles		; $66e2
	call addAToBc		; $66e5
	ld a,(bc)		; $66e8
	ld l,Interaction.angle		; $66e9
	ld (hl),a		; $66eb

_childFlipAnimation:
	ld l,Interaction.var3a		; $66ec
	ld a,(hl)		; $66ee
	xor $01			; $66ef
	ld (hl),a		; $66f1
	ld l,Interaction.var37		; $66f2
	add (hl)		; $66f4
	jp interactionSetAnimation		; $66f5

_childHyperactiveMovementAngles:
	.db $18 $0a $18 $06

;;
; @addr{66fc}
_childUpdateUnknownMovement:
	call objectApplySpeed		; $66fc
	ld e,Interaction.xh		; $66ff
	ld a,(de)		; $6701
	sub $14			; $6702
	cp $28			; $6704
	ret c			; $6706
	ld h,d			; $6707
	ld l,Interaction.angle		; $6708
	ld a,(hl)		; $670a
	xor $10			; $670b
	ld (hl),a		; $670d
	jr _childFlipAnimation		; $670e

;;
; Updates movement for "shy" personality type (runs away when Link approaches)
; @addr{6710}
_childUpdateShyMovement:
	ld e,Interaction.state2		; $6710
	ld a,(de)		; $6712
	rst_jumpTable			; $6713
	.dw @substate0
	.dw @substate1

@substate0:
	ld c,$18		; $6718
	call objectCheckLinkWithinDistance		; $671a
	ret nc			; $671d

	call interactionIncState2		; $671e

@substate1:
	call _childUpdateAngleAndApplySpeed		; $6721
	call _childCheckReachedDestination		; $6724
	ret nc			; $6727

	ld h,d			; $6728
	ld l,Interaction.state2		; $6729
	ld (hl),$00		; $672b
	jp _childIncPositionIndex		; $672d

;;
; @addr{6730}
_childUpdateAngleAndApplySpeed:
	ld h,d			; $6730
	ld l,Interaction.var3c		; $6731
	ld a,(hl)		; $6733
	add a			; $6734
	ld b,a			; $6735
	ld e,Interaction.var3f		; $6736
	ld a,(de)		; $6738
	ld l,a			; $6739
	ld e,Interaction.var3e		; $673a
	ld a,(de)		; $673c
	ld h,a			; $673d
	ld a,b			; $673e
	rst_addAToHl			; $673f
	ld b,(hl)		; $6740
	inc hl			; $6741
	ld c,(hl)		; $6742
	call objectGetRelativeAngle		; $6743
	ld e,Interaction.angle		; $6746
	ld (de),a		; $6748
	jp objectApplySpeed		; $6749

;;
; @param[out]	cflag	Set if the child's reached the position he's moving toward (or is
;			within 1 pixel from the destination on both axes)
; @addr{674c}
_childCheckReachedDestination:
	ld h,d			; $674c
	ld l,Interaction.var3c		; $674d
	ld a,(hl)		; $674f
	add a			; $6750
	push af			; $6751

	ld e,Interaction.var3f		; $6752
	ld a,(de)		; $6754
	ld c,a			; $6755
	ld e,Interaction.var3e		; $6756
	ld a,(de)		; $6758
	ld b,a			; $6759

	pop af			; $675a
	call addAToBc		; $675b
	ld l,Interaction.yh		; $675e
	ld a,(bc)		; $6760
	sub (hl)		; $6761
	add $01			; $6762
	cp $03			; $6764
	ret nc			; $6766
	inc bc			; $6767
	ld l,Interaction.xh		; $6768
	ld a,(bc)		; $676a
	sub (hl)		; $676b
	add $01			; $676c
	cp $03			; $676e
	ret			; $6770

;;
; Updates animation if the child's direction has changed?
; @addr{6771}
_childCheckAnimationDirectionChanged:
	ld h,d			; $6771
	ld l,Interaction.angle		; $6772
	ld a,(hl)		; $6774
	swap a			; $6775
	and $01			; $6777
	xor $01			; $6779
	ld l,Interaction.direction		; $677b
	cp (hl)			; $677d
	ret z			; $677e
	ld (hl),a		; $677f
	ld l,Interaction.var3a		; $6780
	add (hl)		; $6782
	ld l,Interaction.var37		; $6783
	add (hl)		; $6785
	jp interactionSetAnimation		; $6786

;;
; @addr{6789}
_childIncPositionIndex:
	ld h,d			; $6789
	ld l,Interaction.var3d		; $678a
	ld a,(hl)		; $678c
	ld l,Interaction.var3c		; $678d
	inc (hl)		; $678f
	cp (hl)			; $6790
	ret nc			; $6791
	ld (hl),$00		; $6792
	ret			; $6794

;;
; Loads address of position list into var3e/var3f, and the number of positions to loop
; through (minus one) into var3d.
;
; @param	a	Data index
; @addr{6795}
_childLoadPositionListPointer:
	add a			; $6795
	add a			; $6796
	ld hl,@positionTable		; $6797
	rst_addAToHl			; $679a
	ld e,Interaction.var3f		; $679b
	ldi a,(hl)		; $679d
	ld (de),a		; $679e
	ld e,Interaction.var3e		; $679f
	ldi a,(hl)		; $67a1
	ld (de),a		; $67a2
	ld e,Interaction.var3d		; $67a3
	ldi a,(hl)		; $67a5
	ld (de),a		; $67a6
	ret			; $67a7


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
; @addr{67f8}
_childUpdateCuriousMovement:
	ld e,Interaction.state2		; $67f8
	ld a,(de)		; $67fa
	rst_jumpTable			; $67fb
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d			; $6802
	ld l,Interaction.speed		; $6803
	ld (hl),SPEED_100		; $6805
	ld l,Interaction.angle		; $6807
	ld (hl),$18		; $6809

@gotoSubstate1AndJump:
	ld h,d			; $680b
	ld l,Interaction.state2		; $680c
	ld (hl),$01		; $680e
	ld l,Interaction.var3d		; $6810
	ld (hl),$01		; $6812

	ld l,Interaction.speedZ		; $6814
	ld (hl),$00		; $6816
	inc hl			; $6818
	ld (hl),$fb		; $6819
	ld a,SND_JUMP		; $681b
	jp playSound		; $681d

@substate1:
	ld c,$50		; $6820
	call objectUpdateSpeedZ_paramC		; $6822
	jp nz,objectApplySpeed		; $6825

	call interactionIncState2		; $6828

	ld l,Interaction.var3d		; $682b
	ld (hl),$00		; $682d
	ld l,Interaction.var3c		; $682f
	ld (hl),$78		; $6831

	ld l,Interaction.angle		; $6833
	ld a,(hl)		; $6835
	xor $10			; $6836
	ld (hl),a		; $6838
	ret			; $6839

@substate2:
	ld h,d			; $683a
	ld l,Interaction.var3c		; $683b
	dec (hl)		; $683d
	ret nz			; $683e
	jr @gotoSubstate1AndJump		; $683f


_childScriptTable:
	.dw childScript00
	.dw childScript_stage4_hyperactive
	.dw childScript_stage4_shy
	.dw childScript_stage4_curious
	.dw childScript_stage5_hyperactive
	.dw childScript_stage5_shy
	.dw childScript_stage5_curious
	.dw childScript_stage6_hyperactive
	.dw childScript_stage6_shy
	.dw childScript_stage6_curious
	.dw childScript_stage7_slacker
	.dw childScript_stage7_warrior
	.dw childScript_stage7_arborist
	.dw childScript_stage7_singer
	.dw childScript_stage8_slacker
	.dw childScript_stage8_warrior
	.dw childScript_stage8_arborist
	.dw childScript_stage8_singer
	.dw childScript_stage9_slacker
	.dw childScript_stage9_warrior
	.dw childScript_stage9_arborist
	.dw childScript_stage9_singer
	.dw childScript00
	.dw childScript00
	.dw childScript00
	.dw childScript00
	.dw childScript00
	.dw childScript00
	.dw childScript00


; ==============================================================================
; INTERACID_S_GORON
; ==============================================================================
interactionCode3b:
	call checkInteractionState		; $66fe
	jr nz,@state1	; $6701
	ld a,$01		; $6703
	ld (de),a		; $6705
	xor a			; $6706
	ldh (<hFF8D),a	; $6707
	ld a,TREASURE_TRADEITEM		; $6709
	call checkTreasureObtained		; $670b
	jr nc,+			; $670e
	; Got Goron vase
	cp $05			; $6710
	jr c,+			; $6712
	ld a,$01		; $6714
	ldh (<hFF8D),a	; $6716
+
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
	; upper nybble of subid goes into var03
	ld (hl),a		; $6726
	ld a,c			; $6727
	ld c,>TX_3700		; $6728
	cp $07			; $672a
	jr nz,+			; $672c
	; subid_07
	ld a,(wIsLinkedGame)		; $672e
	ld b,a			; $6731
	ldh a,(<hFF8D)	; $6732
	and b			; $6734
	jp z,interactionDelete		; $6735
	ld c,>TX_5300		; $6738
+
	ld a,c			; $673a
	call interactionSetHighTextIndex		; $673b
	call interactionInitGraphics		; $673e
	ld hl,@biggoronColdNotHealed		; $6741
	ldh a,(<hFF8D)	; $6744
	or a			; $6746
	jr z,+			; $6747
	ld hl,@biggoronColdHealed		; $6749
+
	ld e,$42		; $674c
	ld a,(de)		; $674e
	rst_addDoubleIndex			; $674f
	ldi a,(hl)		; $6750
	ld h,(hl)		; $6751
	ld l,a			; $6752
	call interactionSetScript		; $6753
@state1:
	ld e,$43		; $6756
	ld a,(de)		; $6758
	rst_jumpTable			; $6759
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02
@var03_00:
	call interactionRunScript		; $6760
	jp npcFaceLinkAndAnimate		; $6763
@var03_01:
	call interactionRunScript		; $6766
	ld e,$45		; $6769
	ld a,(de)		; $676b
	rst_jumpTable			; $676c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	ld c,$28		; $6775
	call objectCheckLinkWithinDistance		; $6777
	jr nc,+			; $677a
	call interactionIncState2		; $677c
	call @func_67fc		; $677f
	add $06			; $6782
	call interactionSetAnimation		; $6784
+
	jp interactionAnimateAsNpc		; $6787
@substate1:
	ld e,$61		; $678a
	ld a,(de)		; $678c
	inc a			; $678d
	jr nz,+			; $678e
	call interactionIncState2		; $6790
	ld l,$49		; $6793
	ld (hl),$ff		; $6795
+
	jp interactionAnimateAsNpc		; $6797
@substate2:
	ld c,$28		; $679a
	call objectCheckLinkWithinDistance		; $679c
	jr c,+			; $679f
	call interactionIncState2		; $67a1
	call @func_67fc		; $67a4
	add $07			; $67a7
	call interactionSetAnimation		; $67a9
	jr @animateAsNPC		; $67ac
+
	jp npcFaceLinkAndAnimate		; $67ae
@substate3:
	ld e,$61		; $67b1
	ld a,(de)		; $67b3
	inc a			; $67b4
	jr nz,@animateAsNPC			; $67b5
	ld e,$45		; $67b7
	xor a			; $67b9
	ld (de),a		; $67ba
@animateAsNPC:
	jp interactionAnimateAsNpc		; $67bb
@var03_02:
	call interactionAnimate		; $67be
	call interactionAnimate		; $67c1
	call checkInteractionState2		; $67c4
	jr nz,@func_67f0	; $67c7
	ld e,Interaction.pressedAButton		; $67c9
	ld a,(de)		; $67cb
	or a			; $67cc
	jr z,@runScriptPushLinkAwayUpdateDrawPriority	; $67cd
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
	ld bc,TX_3700		; $67e1
	call showText		; $67e4
	call interactionIncState2		; $67e7
@runScriptPushLinkAwayUpdateDrawPriority:
	call interactionRunScript		; $67ea
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $67ed

@func_67f0:
	ld e,$76		; $67f0
	ld a,(de)		; $67f2
	call interactionSetAnimation		; $67f3
	ld e,$45		; $67f6
	xor a			; $67f8
	ld (de),a		; $67f9
	jr @runScriptPushLinkAwayUpdateDrawPriority		; $67fa
	
@func_67fc:
	ld e,$4d		; $67fc
	ld a,(de)		; $67fe
	ld hl,$d00d		; $67ff
	cp (hl)			; $6802
	ld a,$02		; $6803
	ret c			; $6805
	xor a			; $6806
	ret			; $6807

@biggoronColdNotHealed:
	.dw goronScript_pacingLeftAndRight
	.dw goronScript_text1_biggoronSick
	.dw goronScript_text2
	.dw goronScript_text3_biggoronSick
	.dw goronScript_text4_biggoronSick
	.dw goronScript_text5
	.dw goronScript_upgradeRingBox
	.dw goronScript_giveSubrosianSecret

@biggoronColdHealed:
	.dw goronScript_pacingLeftAndRight
	.dw goronScript_text1_biggoronHealed
	.dw goronScript_text2
	.dw goronScript_text3_biggoronHealed
	.dw goronScript_text4_biggoronHealed
	.dw goronScript_text5
	.dw goronScript_upgradeRingBox
	.dw goronScript_giveSubrosianSecret


; ==============================================================================
; INTERACID_MISC_BOY_NPCS
; ==============================================================================
interactionCode3e:
	call checkInteractionState		; $6828
	jp nz,@state1		; $682b
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
	jr nz,@nonVar03_03	; $6841
	; subid30-34
	call getSunkenCityNPCVisibleSubId@main		; $6843
	ld e,$42		; $6846
	ld a,(de)		; $6848
	cp b			; $6849
	jp nz,interactionDelete		; $684a
	cp $01			; $684d
	jr nz,@continue		; $684f
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $6851
	call checkGlobalFlag		; $6853
	ld a,<ROOM_SEASONS_06e		; $6856
	jr nz,+			; $6858
	ld a,<ROOM_SEASONS_05e		; $685a
+
	ld hl,wActiveRoom		; $685c
	cp (hl)			; $685f
	jp nz,interactionDelete		; $6860
	jr @continue		; $6863
@nonVar03_03:
	add $04			; $6865
	ld b,a			; $6867
	call checkHoronVillageNPCShouldBeSeen_body@main		; $6868
	jp nc,interactionDelete		; $686b
@continue:
	ld e,$42		; $686e
	ld a,b			; $6870
	ld (de),a		; $6871
	inc e			; $6872
	ld a,(de)		; $6873
	rst_jumpTable			; $6874
	.dw @@var03_00
	.dw @@var03_01
	.dw @@var03_02
	.dw @@var03_03
@@var03_00:
	call @@var03_03		; $687d
	call getFreeInteractionSlot		; $6880
	jr nz,+			; $6883
	ld (hl),INTERACID_BALL_THROWN_TO_DOG		; $6885
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
+
	jr @func_68e9		; $6899
@@var03_01:
@@var03_03:
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
@@var03_02:
	ld a,(wRoomStateModifier)		; $68c2
	cp SEASON_WINTER			; $68c5
	jp z,interactionDelete		; $68c7
	call @@var03_03		; $68ca
	ld a,(wRoomStateModifier)		; $68cd
	cp SEASON_SPRING			; $68d0
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
@func_68e9:
	call getRandomNumber		; $68e9
	and $3f			; $68ec
	add $78			; $68ee
	ld h,d			; $68f0
	ld l,$76		; $68f1
	ld (hl),a		; $68f3
	ret			; $68f4

@state1:
	ld e,$43		; $68f5
	ld a,(de)		; $68f7
	rst_jumpTable			; $68f8
	.dw @@var03_00
	.dw @@var03_01
	.dw @@var03_02
	.dw @@var03_03
@@var03_00:
	ld e,$45		; $6901
	ld a,(de)		; $6903
	rst_jumpTable			; $6904
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	call _func_6abc		; $6909
	jr nz,+			; $690c
	ld l,$60		; $690e
	ld (hl),$01		; $6910
	call interactionIncState2		; $6912
	ld hl,$cceb		; $6915
	ld (hl),$01		; $6918
	call interactionAnimate		; $691a
+
	jp @@@runScriptPushLinkAwayUpdateDrawPriority		; $691d
@@@substate1:
	ld a,($cceb)		; $6920
	cp $02			; $6923
	jr nz,@@@runScriptPushLinkAwayUpdateDrawPriority	; $6925
	call @func_68e9		; $6927
	ld l,$45		; $692a
	ld (hl),$00		; $692c
	ld a,$08		; $692e
	call interactionSetAnimation		; $6930
@@@runScriptPushLinkAwayUpdateDrawPriority:
	call interactionRunScript		; $6933
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $6936
@@var03_01:
	ld h,d			; $6939
	ld l,$42		; $693a
	ld a,(hl)		; $693c
	cp $02			; $693d
	jr c,@@var03_03	; $693f
	call checkInteractionState2		; $6941
	jr nz,+			; $6944
	call interactionIncState2		; $6946
	xor a			; $6949
	ld l,$4e		; $694a
	ldi (hl),a		; $694c
	ld (hl),a		; $694d
	call _beginJump		; $694e
+
	call _updateSpeedZ		; $6951
@@var03_03:
	call interactionRunScript		; $6954
	jp interactionAnimateAsNpc		; $6957
@@var03_02:
	ld a,(wRoomStateModifier)		; $695a
	cp SEASON_SPRING			; $695d
	jp nz,@@var03_03		; $695f
	ld e,$45		; $6962
	ld a,(de)		; $6964
	rst_jumpTable			; $6965
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
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6980
	jr nc,+			; $6983
	ld h,d			; $6985
	ld l,$77		; $6986
	ld (hl),$0c		; $6988
+
	call _func_6ac1		; $698a
	jp nz,_runScriptSetPriorityRelativeToLink_withTerrainEffects		; $698d
	call objectApplySpeed		; $6990
	cp $4b			; $6993
	jr c,+			; $6995
	call interactionIncState2		; $6997
	ld bc,$fe80		; $699a
	call objectSetSpeedZ		; $699d
	ld l,$50		; $69a0
	ld (hl),$14		; $69a2
	ld a,$09		; $69a4
	call interactionSetAnimation		; $69a6
+
	jp _animateRunScript		; $69a9
@@@substate1:
	ld a,($ccc3)		; $69ac
	or a			; $69af
	ret nz			; $69b0
	inc a			; $69b1
	ld ($ccc3),a		; $69b2
	call interactionIncState2		; $69b5
	jp objectSetVisiblec2		; $69b8
@@@substate2:
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
@@@substate3:
	call _func_6abc		; $69d8
	ret nz			; $69db
	call interactionIncState2		; $69dc
	ld a,$05		; $69df
	jp interactionSetAnimation		; $69e1
@@@substate4:
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
@@@substate5:
	ld c,$20		; $6a06
	call objectUpdateSpeedZ_paramC		; $6a08
	jp nz,objectApplySpeed		; $6a0b
	call interactionIncState2		; $6a0e
	ld l,$76		; $6a11
	ld (hl),$10		; $6a13
	ld l,$71		; $6a15
	ld (hl),$00		; $6a17
	ret			; $6a19
@@@substate6:
	call _func_6abc		; $6a1a
	ret nz			; $6a1d
	jp interactionIncState2		; $6a1e
@@@substate7:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6a21
	jr nc,+			; $6a24
	ld h,d			; $6a26
	ld l,$77		; $6a27
	ld (hl),$0c		; $6a29
+
	call _func_6ac1		; $6a2b
	jp nz,_runScriptSetPriorityRelativeToLink_withTerrainEffects		; $6a2e
	call objectApplySpeed		; $6a31
	ld e,$4b		; $6a34
	ld a,(de)		; $6a36
	cp $28			; $6a37
	jr nc,+			; $6a39
	call interactionIncState2		; $6a3b
	ld l,$76		; $6a3e
	ld (hl),$06		; $6a40
	ld l,$49		; $6a42
	ld (hl),$18		; $6a44
+
	jp _animateRunScript		; $6a46
@@@substate8:
@@@substateA:
	call _func_6abc		; $6a49
	ret nz			; $6a4c
	ld l,$49		; $6a4d
	ld a,(hl)		; $6a4f
	swap a			; $6a50
	rlca			; $6a52
	add $05			; $6a53
	call interactionSetAnimation		; $6a55
	jp interactionIncState2		; $6a58
@@@substate9:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6a5b
	jr nc,+			; $6a5e
	ld h,d			; $6a60
	ld l,$77		; $6a61
	ld (hl),$0c		; $6a63
+
	call _func_6ac1		; $6a65
	jr nz,_runScriptSetPriorityRelativeToLink_withTerrainEffects	; $6a68
	call objectApplySpeed		; $6a6a
	cp $18			; $6a6d
	jr nc,+			; $6a6f
	call interactionIncState2		; $6a71
	ld l,$76		; $6a74
	ld (hl),$06		; $6a76
	ld l,$49		; $6a78
	ld (hl),$10		; $6a7a
+
	jp _animateRunScript		; $6a7c
@@@substateB:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6a7f
	jr nc,+			; $6a82
	ld h,d			; $6a84
	ld l,$77		; $6a85
	ld (hl),$0c		; $6a87
+
	call _func_6ac1		; $6a89
	jr nz,_runScriptSetPriorityRelativeToLink_withTerrainEffects	; $6a8c
	call objectApplySpeed		; $6a8e
	ld e,$4b		; $6a91
	ld a,(de)		; $6a93
	cp $62			; $6a94
	jr c,+			; $6a96
	call interactionIncState2		; $6a98
	ld l,$76		; $6a9b
	ld (hl),$06		; $6a9d
	ld l,$49		; $6a9f
	ld (hl),$08		; $6aa1
+
	jp _animateRunScript		; $6aa3
@@@substateC:
	call _func_6abc		; $6aa6
	ret nz			; $6aa9
	ld l,$45		; $6aaa
	ld (hl),$00		; $6aac
	ld a,$06		; $6aae
	jp interactionSetAnimation		; $6ab0

_animateRunScript:
	call interactionAnimate		; $6ab3

_runScriptSetPriorityRelativeToLink_withTerrainEffects:
	call interactionRunScript		; $6ab6
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6ab9

_func_6abc:
	ld h,d			; $6abc
	ld l,$76		; $6abd
	dec (hl)		; $6abf
	ret			; $6ac0
	
_func_6ac1:
	ld h,d			; $6ac1
	ld l,$77		; $6ac2
	ld a,(hl)		; $6ac4
	or a			; $6ac5
	ret z			; $6ac6
	dec (hl)		; $6ac7
	ret			; $6ac8

_table_6ac9:
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02
	.dw @var03_03

@var03_00:
	.dw boyWithDogScript_text1
	.dw boyWithDogScript_text2
	.dw boyWithDogScript_text2
	.dw boyWithDogScript_text3
	.dw boyWithDogScript_text5
	.dw boyWithDogScript_text5
	.dw boyWithDogScript_text6
	.dw boyWithDogScript_text6
	.dw boyWithDogScript_text7
	.dw boyWithDogScript_text4
	.dw boyWithDogScript_text5

@var03_01:
	.dw horonVillageBoyScript_text1
	.dw horonVillageBoyScript_text1
	.dw horonVillageBoyScript_text2
	.dw horonVillageBoyScript_text2
	.dw horonVillageBoyScript_text3
	.dw horonVillageBoyScript_text4
	.dw horonVillageBoyScript_text5
	.dw horonVillageBoyScript_text6
	.dw horonVillageBoyScript_text7
	.dw horonVillageBoyScript_text2
	.dw horonVillageBoyScript_text4

@var03_02:
	.dw springBloomBoyScript_text1
	.dw springBloomBoyScript_text1
	.dw springBloomBoyScript_text1
	.dw springBloomBoyScript_text1
	.dw springBloomBoyScript_text2
	.dw springBloomBoyScript_text2
	.dw springBloomBoyScript_text2
	.dw springBloomBoyScript_text2
	.dw springBloomBoyScript_text2
	.dw springBloomBoyScript_text1
	.dw springBloomBoyScript_text3

@var03_03:
	.dw sunkenCityBoyScript_text1
	.dw sunkenCityBoyScript_text2
	.dw sunkenCityBoyScript_text3
	.dw sunkenCityBoyScript_text4
	.dw sunkenCityBoyScript_text3


; ==============================================================================
; INTERACID_PIRATIAN
; ==============================================================================
interactionCode40:
; ==============================================================================
; INTERACID_PIRATIAN_CAPTAIN
; ==============================================================================
interactionCode41:
	ld e,$44		; $6b1d
	ld a,(de)		; $6b1f
	rst_jumpTable			; $6b20
	.dw @state0
	.dw @state1
@state0:
	ld e,$42		; $6b25
	ld a,(de)		; $6b27
	rst_jumpTable			; $6b28
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
	call _func_6c3c		; $6b47

@@subid1:
@@subid2:
@@subid3:
@@subid4:
@@subid5:
@@subid6:
@@subid9:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP		; $6b4a
	call checkGlobalFlag		; $6b4c
	jp nz,interactionDelete		; $6b4f
	call objectGetTileAtPosition		; $6b52
	ld (hl),$00		; $6b55
@@subid7:
@@subid8:
	call @func_6b91		; $6b57
	ld a,$04		; $6b5a
	jr @func_6b8b		; $6b5c
@@subidB:
@@subidC:
@@subidD:
@@subidE:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP		; $6b5e
	call checkGlobalFlag		; $6b60
	jp z,interactionDelete		; $6b63
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED		; $6b66
	call checkGlobalFlag		; $6b68
	jp nz,interactionDelete		; $6b6b
	call @func_6b91		; $6b6e
	ld e,$42		; $6b71
	ld a,(de)		; $6b73
	cp $0d			; $6b74
	ld a,$00		; $6b76
	jr z,+			; $6b78
	ld a,$04		; $6b7a
+
	jr @func_6b8b		; $6b7c
@@subidA:
	call getThisRoomFlags		; $6b7e
	bit 6,(hl)		; $6b81
	jp nz,interactionDelete		; $6b83
	call @func_6b91		; $6b86
	ld a,$04		; $6b89
@func_6b8b:
	call interactionSetAnimation		; $6b8b
	jp _func_6bc4		; $6b8e
@func_6b91:
	call interactionInitGraphics		; $6b91
	ld h,d			; $6b94
	ld l,$44		; $6b95
	ld (hl),$01		; $6b97
	ld a,>TX_3a00		; $6b99
	call interactionSetHighTextIndex		; $6b9b
	call _func_6c29		; $6b9e
	ld e,$42		; $6ba1
	ld a,(de)		; $6ba3
	ld hl,_table_6cbf		; $6ba4
	rst_addDoubleIndex			; $6ba7
	ldi a,(hl)		; $6ba8
	ld h,(hl)		; $6ba9
	ld l,a			; $6baa
	call interactionSetScript		; $6bab
	jp interactionRunScript		; $6bae
@state1:
	ld e,$42		; $6bb1
	ld a,(de)		; $6bb3
	cp $08			; $6bb4
	jr nz,+			; $6bb6
	call _func_6c51		; $6bb8
+
	call interactionRunScript		; $6bbb
	jp c,interactionDelete		; $6bbe
	jp _func_6bc4		; $6bc1
_func_6bc4:
	call interactionAnimate		; $6bc4
	ld e,$7c		; $6bc7
	ld a,(de)		; $6bc9
	or a			; $6bca
	jr nz,_func_6be9	; $6bcb
	ld e,$60		; $6bcd
	ld a,(de)		; $6bcf
	dec a			; $6bd0
	jr nz,+			; $6bd1
	call getRandomNumber_noPreserveVars		; $6bd3
	and $1f			; $6bd6
	ld hl,_table_6c09		; $6bd8
	rst_addAToHl			; $6bdb
	ld a,(hl)		; $6bdc
	or a			; $6bdd
	jr z,+			; $6bde
	ld e,$60		; $6be0
	ld (de),a		; $6be2
+
	call objectPreventLinkFromPassing		; $6be3
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6be6
_func_6be9:
	ld e,$50		; $6be9
	ld a,(de)		; $6beb
	cp $28			; $6bec
	jr z,+			; $6bee
	cp $50			; $6bf0
	jr z,++			; $6bf2
	ret			; $6bf4
+
	ld e,$60		; $6bf5
	ld a,(de)		; $6bf7
	cp $09			; $6bf8
	ret nz			; $6bfa
	jr +++			; $6bfb
++
	ld e,$60		; $6bfd
	ld a,(de)		; $6bff
	cp $0c			; $6c00
	ret nz			; $6c02
+++
	ld e,$60		; $6c03
	ld a,$01		; $6c05
	ld (de),a		; $6c07
	ret			; $6c08
_table_6c09:
	.db $00 $00 $04 $04 $00 $00 $08 $08
	.db $00 $00 $00 $00 $04 $04 $00 $00
	.db $00 $08 $08 $00 $00 $00 $10 $10
	.db $00 $00 $00 $20 $20 $00 $00 $00
_func_6c29:
	ld a,TREASURE_ESSENCE		; $6c29
	call checkTreasureObtained		; $6c2b
	jr c,+			; $6c2e
	xor a			; $6c30
+
	cp $20			; $6c31
	ld a,$01		; $6c33
	jr nc,+			; $6c35
	xor a			; $6c37
+
	ld e,$7a		; $6c38
	ld (de),a		; $6c3a
	ret			; $6c3b
_func_6c3c:
	ld a,TREASURE_PIRATES_BELL		; $6c3c
	call checkTreasureObtained		; $6c3e
	jr c,+			; $6c41
	xor a			; $6c43
	jr ++			; $6c44
+
	or a			; $6c46
	ld a,$01		; $6c47
	jr z,++			; $6c49
	ld a,$02		; $6c4b
++
	ld e,$7b		; $6c4d
	ld (de),a		; $6c4f
	ret			; $6c50
_func_6c51:
	call _func_6c8b		; $6c51
	jr z,++			; $6c54
	ld a,($cc46)		; $6c56
	bit 6,a			; $6c59
	jr z,+			; $6c5b
	ld c,$01		; $6c5d
	ld b,$db		; $6c5f
	jp _func_6c78		; $6c61
+
	ld a,($cc45)		; $6c64
	bit 6,a			; $6c67
	ret nz			; $6c69
++
	ld h,d			; $6c6a
	ld l,$7e		; $6c6b
	ld a,$00		; $6c6d
	cp (hl)			; $6c6f
	ret z			; $6c70
	ld c,$00		; $6c71
	ld b,$d9		; $6c73
	jp _func_6c78		; $6c75
_func_6c78:
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
_func_6c8b:
	ld hl,_table_6cb2		; $6c8b
	ld a,($d00b)		; $6c8e
	ld c,a			; $6c91
	ld a,($d00d)		; $6c92
	ld b,a			; $6c95
---
	ldi a,(hl)		; $6c96
	or a			; $6c97
	ret z			; $6c98
	add $04			; $6c99
	sub c			; $6c9b
	cp $09			; $6c9c
	jr nc,+			; $6c9e
	ldi a,(hl)		; $6ca0
	add $03			; $6ca1
	sub b			; $6ca3
	cp $07			; $6ca4
	jr nc,++		; $6ca6
	ld a,(hl)		; $6ca8
	ld e,$7f		; $6ca9
	ld (de),a		; $6cab
	or d			; $6cac
	ret			; $6cad
+
	inc hl			; $6cae
++
	inc hl			; $6caf
	jr ---		; $6cb0
_table_6cb2:
	.db $18 $58 $00 $18
	.db $68 $01 $18 $78
	.db $02 $18 $88 $03
	.db $00

_table_6cbf:
	.dw piratianCaptainScript_inHouse
	.dw piratian1FScript_text1BasedOnD6Beaten
	.dw piratian1FScript_text1BasedOnD6Beaten
	.dw piratian1FScript_text1BasedOnD6Beaten
	.dw piratian1FScript_text1BasedOnD6Beaten
	.dw piratian1FScript_text2BasedOnD6Beaten
	.dw piratian1FScript_text2BasedOnD6Beaten
	.dw unluckySailorScript
	.dw piratian2FScript_textBasedOnD6Beaten
	.dw piratianRoofScript
	.dw samasaGatePiratianScript
	.dw piratianCaptainByShipScript
	.dw piratianFromShipScript
	.dw piratianByCaptainWhenDeparting1Script
	.dw piratianByCaptainWhenDeparting2Script


; ==============================================================================
; INTERACID_PIRATE_HOUSE_SUBROSIAN
; ==============================================================================
interactionCode42:
	ld e,$44		; $6cdd
	ld a,(de)		; $6cdf
	rst_jumpTable			; $6ce0
	.dw @state0
	.dw @state1
@state0:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP		; $6ce5
	call checkGlobalFlag		; $6ce7
	ld b,$00		; $6cea
	jr nz,+			; $6cec
	inc b			; $6cee
+
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
@state1:
	call interactionRunScript		; $6d0e
	jp npcFaceLinkAndAnimate		; $6d11

_table_6d14:
	.dw pirateHouseSubrosianScript_piratesAround
	.dw pirateHouseSubrosianScript_piratesLeft


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
	callab checkReloadShopItemTiles		; $6e96
.else
	call checkReloadShopItemTiles		; $6d18
.endif
	call @runState		; $6d1b
	jp interactionAnimateAsNpc		; $6ea1

@runState:
	ld e,Interaction.state		; $6ea4
	ld a,(de)		; $6ea6
	rst_jumpTable			; $6ea7
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $6eae
	ld (de),a		; $6eb0

	call interactionInitGraphics		; $6eb1
	call interactionSetAlwaysUpdateBit		; $6eb4

	ld l,Interaction.collisionRadiusY		; $6eb7
	ld (hl),$12		; $6eb9
	inc l			; $6ebb
	ld (hl),$07		; $6ebc

	ld e,Interaction.pressedAButton		; $6ebe
	call objectAddToAButtonSensitiveObjectList		; $6ec0
.ifdef ROM_SEASONS
	call getThisRoomFlags		; $6d40
	and $40			; $6d43
	ld hl,syrupScript_notTradedMushroomYet		; $6d45
	jr z,+			; $6d48
.endif
	ld hl,syrupScript_spawnShopItems		; $6d4a
+
	jr @setScriptAndGotoState2		; $6d4d


; State 1: Waiting for Link to talk to her
@state1:
	ld e,Interaction.pressedAButton		; $6ec8
	ld a,(de)		; $6eca
	or a			; $6ecb
	ret z			; $6ecc

	xor a			; $6ecd
	ld (de),a		; $6ece

	ld a,$81		; $6ecf
	ld (wDisabledObjects),a		; $6ed1

	ld a,(wLinkGrabState)		; $6ed4
	or a			; $6ed7
	jr z,@talkToSyrupWithoutItem	; $6ed8

	; Get the object that Link is holding
	ld a,(w1Link.relatedObj2+1)		; $6eda
	ld h,a			; $6edd
.ifdef ROM_AGES
	ld e,Interaction.var3b		; $6ede
.else
	ld e,Interaction.var3c		; $6ede
.endif
	ld (de),a		; $6ee0

	; Assume he's holding an INTERACID_SHOP_ITEM. Subids $07-$0c are for syrup's shop.
	ld l,Interaction.subid		; $6ee1
	ld a,(hl)		; $6ee3
	push af			; $6ee4
	ld b,a			; $6ee5
	sub $07			; $6ee6

.ifdef ROM_AGES
	ld e,Interaction.var37		; $6ee8
.else
	ld e,Interaction.var38		; $6ee8
.endif
	ld (de),a		; $6eea

	; Check if Link has the rupees for it
	ld a,b			; $6eeb
	ld hl,_shopItemPrices		; $6eec
	rst_addAToHl			; $6eef
	ld a,(hl)		; $6ef0
	call cpRupeeValue		; $6ef1
.ifdef ROM_AGES
	ld (wShopHaveEnoughRupees),a		; $6ef4
.else
	ld e,Interaction.var39
	ld (de),a
.endif
	ld ($cbad),a		; $6ef7

	; Check the item type, see if Link is allowed to buy any more than he already has
	pop af			; $6efa
	cp $07			; $6efb
	jr z,@checkPotion	; $6efd
	cp $09			; $6eff
	jr z,@checkPotion	; $6f01

	cp $0b			; $6f03
	jr z,@checkBombchus	; $6f05

	ld a,(wNumGashaSeeds)		; $6f07
	jr @checkQuantity		; $6f0a

@checkBombchus:
	ld a,(wNumBombchus)		; $6f0c

@checkQuantity:
	; For bombchus and gasha seeds, amount caps at 99
	cp $99			; $6f0f
	ld a,$01		; $6f11
	jr nc,@setCanPurchase	; $6f13
	jr @canPurchase		; $6f15

@checkPotion:
	ld a,TREASURE_POTION		; $6f17
	call checkTreasureObtained		; $6f19
	ld a,$01		; $6f1c
	jr c,@setCanPurchase	; $6f1e

@canPurchase:
	xor a			; $6f20

@setCanPurchase:
	; Set var38 to 1 if Link can't purchase the item because he has too much of it
.ifdef ROM_AGES
	ld e,Interaction.var38		; $6f21
.else
	ld e,Interaction.var3a		; $6f21
.endif
	ld (de),a		; $6f23

	ld hl,syrupScript_purchaseItem		; $6f24
	jr @setScriptAndGotoState2		; $6f27

@talkToSyrupWithoutItem:
	call _shopkeeperCheckAllItemsBought		; $6f29
	jr z,@showWelcomeText	; $6f2c

	ld hl,syrupScript_showClosedText		; $6f2e
	jr @setScriptAndGotoState2		; $6f31

@showWelcomeText:
	ld hl,syrupScript_showWelcomeText		; $6f33

@setScriptAndGotoState2:
	ld e,Interaction.state		; $6f36
	ld a,$02		; $6f38
	ld (de),a		; $6f3a
	jp interactionSetScript		; $6f3b


; State 2: running a script
@state2:
	call interactionRunScript		; $6f3e
	ret nc			; $6f41

	; Script done

	xor a			; $6f42
	ld (wDisabledObjects),a		; $6f43

	; Check response from script (was purchase successful?)
.ifdef ROM_AGES
	ld e,Interaction.var3a		; $6f46
.else
	ld e,Interaction.var3b		; $6f46
.endif
	ld a,(de)		; $6f48
	or a			; $6f49
	jr z,@gotoState1 ; Skip below code if he was holding nothing to begin with

	; If purchase was successful, set the held item (INTERACID_SHOP_ITEM) to state
	; 3 (link obtains it)
	inc a			; $6f4c
	ld c,$03		; $6f4d
	jr nz,++		; $6f4f

	; If purchase was not successful, set the held item to state 4 (return to display
	; area)
	ld c,$04		; $6f51
++
	xor a			; $6f53
	ld (de),a		; $6f54
.ifdef ROM_AGES
	ld e,Interaction.var3b		; $6ede
.else
	ld e,Interaction.var3c		; $6ede
.endif
	ld a,(de)		; $6f57
	ld h,a			; $6f58
	ld l,Interaction.state		; $6f59
	ld (hl),c		; $6f5b
	call dropLinkHeldItem		; $6f5c

@gotoState1:
	ld e,Interaction.state		; $6f5f
	ld a,$01		; $6f61
	ld (de),a		; $6f63
	ret			; $6f64


; ==============================================================================
; INTERACID_S_ZELDA
; ==============================================================================
interactionCode44:
	ld e,$44		; $6dec
	ld a,(de)		; $6dee
	rst_jumpTable			; $6def
	.dw _zelda_state0
	.dw _zelda_state1

_zelda_state0:
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
	jr z,@subid0	; $6e07
	cp $08			; $6e09
	jr z,@subid8	; $6e0b
	cp $09			; $6e0d
	jr z,@subid9	; $6e0f

@setVisibleInitGraphicsIncState:
	call objectSetVisible82		; $6e11
	call interactionInitGraphics		; $6e14
	jr _zelda_state1		; $6e17

@subid0:
	ld a,$b0		; $6e19
	ld ($cc1d),a		; $6e1b
	ld (wLoadedTreeGfxIndex),a		; $6e1e
	
	call getThisRoomFlags		; $6e21
	bit 7,a			; $6e24
	jr z,+			; $6e26
	ld a,$01		; $6e28
	ld ($ccab),a		; $6e2a
	ld a,(wActiveMusic)		; $6e2d
	or a			; $6e30
	jr z,+			; $6e31
	xor a			; $6e33
	ld (wActiveMusic),a		; $6e34
	ld a,$38		; $6e37
	call playSound		; $6e39
+
	ld hl,$cbb3		; $6e3c
	ld b,$10		; $6e3f
	call clearMemory		; $6e41
	jr @setVisibleInitGraphicsIncState		; $6e44
@subid8:
	call checkGotMakuSeedDidNotSeeZeldaKidnapped		; $6e46
	bit 7,c			; $6e49
	jp nz,interactionDelete		; $6e4b
	jr @setVisibleInitGraphicsIncState		; $6e4e
@subid9:
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE		; $6e50
	call checkGlobalFlag		; $6e52
	jp z,interactionDelete		; $6e55
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN		; $6e58
	call checkGlobalFlag		; $6e5a
	jp nz,interactionDelete		; $6e5d
	jr @setVisibleInitGraphicsIncState		; $6e60

_zelda_state1:
	ld e,$42		; $6e62
	ld a,(de)		; $6e64
	rst_jumpTable			; $6e65
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
	call interactionRunScript		; $6e7a
	jp interactionAnimate		; $6e7d

@runSubid5:
	call interactionRunScript		; $6e80
	ld e,$47		; $6e83
	ld a,(de)		; $6e85
	or a			; $6e86
	jp nz,interactionAnimate		; $6e87
	ret			; $6e8a

@runSubid6:
	call interactionRunScript		; $6e8b
	jp c,interactionDelete		; $6e8e
	jp interactionAnimate		; $6e91

@faceLinkAndRunScript:
	call interactionRunScript		; $6e94
	jp npcFaceLinkAndAnimate		; $6e97

@runSubid8:
	ld a,GLOBALFLAG_TALKED_TO_ZELDA_BEFORE_ONOX_FIGHT		; $6e9a
	call checkGlobalFlag		; $6e9c
	jr nz,@faceLinkAndRunScript	; $6e9f
	jr @animateAndRunScript		; $6ea1

_table_6ea3:
	.dw zeldaScript_ganonBeat
	.dw zeldaScript_afterEscapingRoomOfRites
	.dw zeldaScript_zeldaKidnapped
	.dw script5fe6
	.dw script5fe6
	.dw script5fea
	.dw script5fee
	.dw zeldaScript_withAnimalsHopefulText
	.dw zeldaScript_blessingBeforeFightingOnox
	.dw zeldaScript_healLinkIfNeeded


; ==============================================================================
; INTERACID_TALON
; ==============================================================================
interactionCode45:
	ld e,$44		; $6eb7
	ld a,(de)		; $6eb9
	rst_jumpTable			; $6eba
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call interactionInitGraphics		; $6ec1
	ld e,$42		; $6ec4
	ld a,(de)		; $6ec6
	or a			; $6ec7
	jr nz,@@subid1	; $6ec8
	call getThisRoomFlags		; $6eca
	and $40			; $6ecd
	jp nz,interactionDelete		; $6ecf
	ld h,d			; $6ed2
	ld l,$44		; $6ed3
	ld (hl),$01		; $6ed5
	ld l,$79		; $6ed7
	ld (hl),$01		; $6ed9
	ld a,>TX_0b00		; $6edb
	call interactionSetHighTextIndex		; $6edd
	ld hl,caveTalonScript		; $6ee0
	call interactionSetScript		; $6ee3
	ld a,$03		; $6ee6
	call interactionSetAnimation		; $6ee8
	jp interactionAnimateAsNpc		; $6eeb
@@subid1:
	ld h,d			; $6eee
	ld l,$44		; $6eef
	ld (hl),$02		; $6ef1
	ld l,$78		; $6ef3
	ld (hl),$ff		; $6ef5
	call _func_6f3c		; $6ef7
	ld a,>TX_0b00		; $6efa
	call interactionSetHighTextIndex		; $6efc
	ld hl,returnedTalonScript		; $6eff
	call interactionSetScript		; $6f02
	jp interactionAnimateAsNpc		; $6f05
@state1:
	ld e,$79		; $6f08
	ld a,(de)		; $6f0a
	or a			; $6f0b
	jr z,+			; $6f0c
	ld a,(wFrameCounter)		; $6f0e
	and $3f			; $6f11
	jr nz,+			; $6f13
	ld a,$01		; $6f15
	ld b,$fa		; $6f17
	ld c,$0a		; $6f19
	call objectCreateFloatingSnore		; $6f1b
+
	call interactionRunScript		; $6f1e
	jp c,interactionDelete		; $6f21
	call interactionAnimate		; $6f24
	ld e,$7a		; $6f27
	ld a,(de)		; $6f29
	or a			; $6f2a
	jr nz,+			; $6f2b
	call objectPreventLinkFromPassing		; $6f2d
+
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6f30
@state2:
	call interactionRunScript		; $6f33
	call _func_6f3c		; $6f36
	jp interactionAnimateAsNpc		; $6f39
_func_6f3c:
	ld c,$28		; $6f3c
	call objectCheckLinkWithinDistance		; $6f3e
	jr nc,+			; $6f41
	ld e,$78		; $6f43
	ld a,(de)		; $6f45
	cp $06			; $6f46
	ret z			; $6f48
	ld a,$06		; $6f49
	jr ++			; $6f4b
+
	ld e,$78		; $6f4d
	ld a,(de)		; $6f4f
	cp $05			; $6f50
	ret z			; $6f52
	ld a,$05		; $6f53
++
	ld (de),a		; $6f55
	jp interactionSetAnimation		; $6f56


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
	ld (hl),INTERACID_MAKU_LEAF		; $6f80
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
	call @runState		; $760a
	jp @updateAnimation		; $760d

@runState:
	ld e,Interaction.state		; $7610
	ld a,(de)		; $7612
	rst_jumpTable			; $7613
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@updateAnimation:
	ld e,Interaction.var3d		; $761e
	ld a,(de)		; $7620
	or a			; $7621
.ifdef ROM_AGES
	ret z			; $7622
	jp interactionAnimate		; $7623
.else
	jr z,+			; $708d
	call interactionAnimate		; $708f
+
	jp objectSetVisible80		; $7092
.endif

@state0:
.ifdef ROM_SEASONS
	call getThisRoomFlags		; $7095
	and $40			; $7098
	jp z,interactionDelete		; $709a
.endif
	ld a,$01		; $7626
	ld (de),a ; [state]
	call interactionInitGraphics		; $7629

	ld h,d			; $762c
	ld l,Interaction.collisionRadiusY		; $762d
	ld (hl),$06		; $762f
	inc l			; $7631
	ld (hl),$06 ; [collisionRadiusX]

	ld l,Interaction.speed		; $7634
	ld (hl),SPEED_a0		; $7636
	call @beginHop		; $7638
	ld e,Interaction.pressedAButton		; $763b
	call objectAddToAButtonSensitiveObjectList		; $763d
.ifdef ROM_AGES
	call objectSetVisible80		; $7640
.endif
	jp @func_7710		; $7643

@state1:
	call @updateHopping		; $7646
	call @updateMovement		; $7649

	; Return if [w1Link.yh] < $69
	ld hl,w1Link.yh		; $764c
	ld c,$69		; $764f
	ld b,(hl)		; $7651
	ld a,$69		; $7652
	ld l,a			; $7654
	ld a,c			; $7655
	cp b			; $7656
	ret nc			; $7657

	; Check if he's holding something
	ld a,(wLinkGrabState)		; $7658
	or a			; $765b
	ret z			; $765c

	; Freeze Link
	ld e,Interaction.var3c		; $765d
	ld a,$02		; $765f
	ld (de),a		; $7661
	ld a,DISABLE_ALL_BUT_INTERACTIONS		; $7662
	ld (wDisabledObjects),a		; $7664

	ld a,l			; $7667
	ld hl,w1Link.yh		; $7668
	ld (hl),a		; $766b
	jp @initState2		; $766c

; Unused?
@func_766f:
	xor a			; $766f
	ld (de),a ; ?
	ld e,Interaction.var3d		; $7671
	ld (de),a		; $7673
	ld e,Interaction.var3c		; $7674
	ld a,$01		; $7676
	ld (de),a		; $7678
	ld a,(wLinkGrabState)		; $7679
	or a			; $767c
	jr z,@gotoState4	; $767d

	; Do something with the item Link's holding?
	ld a,(w1Link.relatedObj2+1)		; $767f
	ld h,a			; $7682
	ld e,Interaction.var3a		; $7683
	ld (de),a		; $7685
	ld hl,syrupCuccoScript_awaitingMushroomText		; $7686
	jp @setScriptAndGotoState4			; $7689

@gotoState4:
	ld hl,syrupCuccoScript_awaitingMushroomText		; $768c

@setScriptAndGotoState4:
	ld e,Interaction.state		; $768f
	ld a,$04		; $7691
	ld (de),a		; $7693
	jp interactionSetScript		; $7694


; Moving toward Link after he tried to steal something
@state2:
	call @updateHopping		; $7697
	call objectApplySpeed		; $769a
	ld e,Interaction.xh		; $769d
	ld a,(de)		; $769f
	sub $0c			; $76a0
	ld hl,w1Link.xh		; $76a2
	cp (hl)			; $76a5
	ret nc			; $76a6

	; Reached Link
	ld e,Interaction.var3d		; $76a7
	xor a			; $76a9
	ld (de),a		; $76aa
	ld hl,syrupCuccoScript_triedToSteal		; $76ab
	jp @setScriptAndGotoState4		; $76ae


; Moving back to normal position
@state3:
	call @updateHopping		; $76b1
	call objectApplySpeed		; $76b4
	ld e,Interaction.xh		; $76b7
	ld a,(de)		; $76b9
	cp $78			; $76ba
	ret c			; $76bc

	xor a			; $76bd
	ld (wDisabledObjects),a		; $76be
	ld e,Interaction.state		; $76c1
	ld a,$01		; $76c3
	ld (de),a		; $76c5
	jp @func_7710		; $76c6


@state4:
	call interactionRunScript		; $76c9
	ret nc			; $76cc

	ld e,Interaction.var3c		; $76cd
	ld a,(de)		; $76cf
	cp $02			; $76d0
	jr z,@beginMovingBack	; $76d2

	ld h,d			; $76d4
	ld l,Interaction.state		; $76d5
	ld (hl),$01		; $76d7
	ld l,Interaction.var3c		; $76d9
	ld (hl),$00		; $76db
	ld l,Interaction.var3d		; $76dd
	ld (hl),$01		; $76df
	xor a			; $76e1
	ld (wDisabledObjects),a		; $76e2
	ret			; $76e5

@beginMovingBack:
	jp @initState3		; $76e6

;;
; @addr{76e9}
@updateHopping:
	ld c,$20		; $76e9
	call objectUpdateSpeedZ_paramC		; $76eb
	ret nz			; $76ee
	ld h,d			; $76ef

;;
; @addr{76f0}
@beginHop:
	ld bc,-$c0		; $76f0
	jp objectSetSpeedZ		; $76f3

;;
; @addr{76f6}
@updateMovement:
	call objectApplySpeed		; $76f6
	ld e,Interaction.xh		; $76f9
	ld a,(de)		; $76fb
	sub $68			; $76fc
	cp $20			; $76fe
	ret c			; $7700

	; Reverse direction
	ld e,Interaction.angle		; $7701
	ld a,(de)		; $7703
	xor $10			; $7704
	ld (de),a		; $7706

	ld e,Interaction.var3e		; $7707
	ld a,(de)		; $7709
	xor $01			; $770a
	ld (de),a		; $770c
	jp interactionSetAnimation		; $770d

;;
; @addr{7710}
@func_7710:
	ld h,d			; $7710
	ld l,Interaction.var3c		; $7711
	ld (hl),$00		; $7713
	ld l,Interaction.speed		; $7715
	ld (hl),SPEED_80		; $7717
	jr +++			; $7719

;;
; @addr{771b}
@initState2:
	ld h,d			; $771b
	ld l,Interaction.state		; $771c
	ld (hl),$02		; $771e
	ld l,Interaction.speed		; $7720
	ld (hl),SPEED_200		; $7722
+++
	ld l,Interaction.var3d		; $7724
	ld (hl),$01		; $7726
	ld l,Interaction.angle		; $7728
	ld (hl),$18		; $772a
	xor a			; $772c
	ld l,Interaction.z		; $772d
	ldi (hl),a		; $772f
	ld (hl),a		; $7730
	ld l,Interaction.var3e		; $7731
	ld a,$00		; $7733
	ld (hl),a		; $7735
	jp interactionSetAnimation		; $7736

;;
; @addr{7739}
@initState3:
	ld h,d			; $7739
	ld l,Interaction.state		; $773a
	ld (hl),$03		; $773c
	ld l,Interaction.speed		; $773e
	ld (hl),SPEED_200		; $7740
	ld l,Interaction.var3d		; $7742
	ld (hl),$01		; $7744
	ld l,Interaction.angle		; $7746
	ld (hl),$08		; $7748
	xor a			; $774a
	ld l,Interaction.z		; $774b
	ldi (hl),a		; $774d
	ld (hl),a		; $774e
	ld l,Interaction.var3e		; $774f
	ld a,$01		; $7751
	ld (hl),a		; $7753
	jp interactionSetAnimation		; $7754


; ==============================================================================
; INTERACID_D1_RISING_STONES
; ==============================================================================
interactionCode4b:
	ld e,$44		; $71cb
	ld a,(de)		; $71cd
	rst_jumpTable			; $71ce
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
@state0:
	ld e,$42		; $71dd
	ld a,(de)		; $71df
	add a			; $71e0
	inc a			; $71e1
	ld e,$44		; $71e2
	ld (de),a		; $71e4
	jp interactionInitGraphics		; $71e5
@state1:
	ld a,$02		; $71e8
	ld (de),a		; $71ea
	ld a,$6f		; $71eb
	call playSound		; $71ed
	jp objectSetVisible81		; $71f0
@state2:
	ld e,$61		; $71f3
	ld a,(de)		; $71f5
	inc a			; $71f6
	jp z,interactionDelete		; $71f7
	jp interactionAnimate		; $71fa
@state3:
	ld a,$04		; $71fd
	ld (de),a		; $71ff
	call getRandomNumber_noPreserveVars		; $7200
	ld b,a			; $7203
	and $60			; $7204
	swap a			; $7206
	ld hl,@table_7260		; $7208
	rst_addAToHl			; $720b
	ld e,$54		; $720c
	ldi a,(hl)		; $720e
	ld (de),a		; $720f
	inc e			; $7210
	ld a,(hl)		; $7211
	ld (de),a		; $7212
	ld a,b			; $7213
	and $03			; $7214
	ld hl,@table_7268		; $7216
	rst_addAToHl			; $7219
	ld e,$50		; $721a
	ld a,(hl)		; $721c
	ld (de),a		; $721d
	call getRandomNumber_noPreserveVars		; $721e
	ld b,a			; $7221
	and $30			; $7222
	swap a			; $7224
	ld hl,@table_726c		; $7226
	rst_addAToHl			; $7229
	ld e,$70		; $722a
	ld a,(hl)		; $722c
	ld (de),a		; $722d
	ld a,b			; $722e
	and $0f			; $722f
	ld hl,@table_7270		; $7231
	rst_addAToHl			; $7234
	ld e,$49		; $7235
	ld a,(hl)		; $7237
	ld (de),a		; $7238
	inc a			; $7239
	and $07			; $723a
	cp $03			; $723c
	jp c,objectSetVisible82		; $723e
	jp objectSetVisible80		; $7241
@state4:
	call objectApplySpeed		; $7244
	ld e,$70		; $7247
	ld a,(de)		; $7249
	call objectUpdateSpeedZ		; $724a
	ret nz			; $724d
	jp interactionDelete		; $724e
@state5:
	ld a,$06		; $7251
	ld (de),a		; $7253
	jp objectSetVisible81		; $7254
@state6:
	call interactionDecCounter1		; $7257
	jp z,interactionDelete		; $725a
	jp interactionAnimate		; $725d
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
	ld e,Interaction.subid	; $7280
	ld a,(de)		; $7282
	rst_jumpTable			; $7283
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

	call @func_72de		; $72a0
	jp objectSetVisible80		; $72a3
	call @func_72de		; $72a6
	jp objectSetVisible81		; $72a9
@subid1:
@subid2:
@subid3:
	call @func_72de		; $72ac
	jp objectSetVisible82		; $72af
@subid6:
@subidA:
@subidB:
@subidC:
@subidD:
	call @func_72de		; $72b2
	jp objectSetVisible83		; $72b5
@subid0:
	call checkInteractionState		; $72b8
	jr nz,+			; $72bb
	ld h,d			; $72bd
	ld l,e			; $72be
	inc (hl)		; $72bf
	ld l,$40		; $72c0
	set 7,(hl)		; $72c2
	call interactionInitGraphics		; $72c4
	jp objectSetVisible80		; $72c7
+
	call getThisRoomFlags		; $72ca
	bit 6,(hl)		; $72cd
	jr z,+			; $72cf
	ld e,$60		; $72d1
	ld a,(de)		; $72d3
	cp $10			; $72d4
	jr nz,+			; $72d6
	ld a,$02		; $72d8
	ld (de),a		; $72da
+
	jp interactionAnimate		; $72db
@func_72de:
	call checkInteractionState		; $72de
	jr nz,+			; $72e1
	ld a,$01		; $72e3
	ld (de),a		; $72e5
	jp interactionInitGraphics		; $72e6
+
	pop hl			; $72e9
	jp interactionAnimate		; $72ea
@subid7:
	call checkInteractionState		; $72ed
	jr nz,+			; $72f0
	ld a,$01		; $72f2
	ld (de),a		; $72f4
	call interactionSetAlwaysUpdateBit		; $72f5
	ld a,$9b		; $72f8
	call loadPaletteHeader		; $72fa
	call interactionInitGraphics		; $72fd
	call objectSetVisible82		; $7300
+
	jp interactionAnimate		; $7303
@subid8:
	call checkInteractionState		; $7306
	jr nz,+			; $7309
	ld a,$01		; $730b
	ld (de),a		; $730d
	call interactionSetAlwaysUpdateBit		; $730e
	call interactionInitGraphics		; $7311
	call objectSetVisible80		; $7314
+
	call interactionAnimate		; $7317
	ld a,(wFrameCounter)		; $731a
	rrca			; $731d
	jp c,objectSetInvisible		; $731e
	jp objectSetVisible		; $7321
@subid9:
	call checkInteractionState		; $7324
	ret nz			; $7327
	call getThisRoomFlags		; $7328
	and $40			; $732b
	jp z,interactionDelete		; $732d
	call interactionInitGraphics		; $7330
	call interactionIncState		; $7333
	jp objectSetVisible83		; $7336
@subid4:
@subid5:
	call checkInteractionState		; $7339
	jr nz,+			; $733c
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
+
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
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,$44		; $7376
	ld a,(de)		; $7378
	rst_jumpTable			; $7379
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld a,$01		; $7380
	ld (de),a		; $7382
	ld a,GLOBALFLAG_TALKED_WITH_GHOST_PIRATE		; $7383
	call checkGlobalFlag		; $7385
	jp z,interactionDelete		; $7388
	ld c,INTERACID_PIRATE_SKULL		; $738b
	call objectFindSameTypeObjectWithID		; $738d
	jr nz,+			; $7390
	; delete if carrying the skull
	ld a,h			; $7392
	cp d			; $7393
	jp nz,interactionDelete		; $7394
	call func_228f		; $7397
	jp z,interactionDelete		; $739a
+
	ld a,TREASURE_PIRATES_BELL		; $739d
	call checkTreasureObtained		; $739f
	jr c,+			; $73a2
	call getRandomNumber		; $73a4
	and $03			; $73a7
	inc a			; $73a9
	ld e,$78		; $73aa
	ld (de),a		; $73ac
+
	ld a,>TX_4d00		; $73ad
	call interactionSetHighTextIndex		; $73af
	ld hl,pirateSkullScript_notYetCarried		; $73b2
	call interactionSetScript		; $73b5
	call interactionInitGraphics		; $73b8
	jp objectSetVisiblec2		; $73bb
@@state1:
	ld e,$45		; $73be
	ld a,(de)		; $73c0
	rst_jumpTable			; $73c1
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	call objectPreventLinkFromPassing		; $73c6
	jp interactionRunScript			; $73c9
@@@substate1:
	ld e,$7a		; $73cc
	ld a,(de)		; $73ce
	or a			; $73cf
	jr z,+			; $73d0
	ld b,a			; $73d2
	inc e			; $73d3
	ld a,(de)		; $73d4
	ld c,a			; $73d5
	push bc			; $73d6
	call objectCheckContainsPoint		; $73d7
	pop bc			; $73da
	jr c,++			; $73db
	call objectGetRelativeAngle		; $73dd
	ld e,$49		; $73e0
	ld (de),a		; $73e2
	ld e,$50		; $73e3
	ld a,$14		; $73e5
	ld (de),a		; $73e7
	call objectApplySpeed		; $73e8
+
	ld h,d			; $73eb
	ld l,$7a		; $73ec
	xor a			; $73ee
	ldi (hl),a		; $73ef
	ld (hl),a		; $73f0
	jp objectAddToGrabbableObjectBuffer		; $73f1
++
	ld bc,TX_4d0a		; $73f4
	call showText		; $73f7
	jp interactionDelete		; $73fa
@@state2:
	ld e,$45		; $73fd
	ld a,(de)		; $73ff
	rst_jumpTable			; $7400
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
@@@substate0:
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
@@@substate1:
	ld hl,$ccc1		; $741a
	bit 7,(hl)		; $741d
	ld e,$78		; $741f
	ld a,(de)		; $7421
	ld (hl),a		; $7422
	jr nz,+			; $7423
	ld e,$46		; $7425
	ld a,$14		; $7427
	ld (de),a		; $7429
	ld a,$01		; $742a
	jp interactionSetAnimation		; $742c
+
	call interactionAnimate		; $742f
	call interactionDecCounter1		; $7432
	ret nz			; $7435
	ld (hl),$14		; $7436
	ld a,$7e		; $7438
	jp playSound		; $743a
@@@substate2:
	call objectCheckWithinRoomBoundary		; $743d
	jp nc,interactionDelete		; $7440
	call objectReplaceWithAnimationIfOnHazard		; $7443
	jr c,@@@droppedInWater	; $7446
	ld h,d			; $7448
	ld l,$40		; $7449
	res 1,(hl)		; $744b
	ld l,$79		; $744d
	ld (hl),d		; $744f
	ret			; $7450
@@@substate3:
	ld c,$20		; $7451
	call objectUpdateSpeedZ_paramC		; $7453
	ret nz			; $7456
	call objectReplaceWithAnimationIfOnHazard		; $7457
	jr c,@@@droppedInWater	; $745a
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
	ld bc,TX_4d06		; $7471
	call nz,showText		; $7474
	xor a			; $7477
	call interactionSetAnimation		; $7478
	jp objectSetVisible82		; $747b
@@@droppedInWater:
	ld bc,TX_4d09		; $747e
	jp showText		; $7481
@subid1:
	ld e,$44		; $7484
	ld a,(de)		; $7486
	rst_jumpTable			; $7487
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
@@state0:
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
@@state1:
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
@@state2:
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
@@state3:
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
@@state4:
	call interactionDecCounter1		; $74fc
	ret nz			; $74ff
	ld l,$44		; $7500
	inc (hl)		; $7502
	xor a			; $7503
	ld ($cca4),a		; $7504
	ld bc,TX_4d07		; $7507
	jp showText		; $750a
@@state5:
	ld a,($cfc0)		; $750d
	or a			; $7510
	ret z			; $7511
	call objectCreatePuff		; $7512
	jp interactionDelete		; $7515


; ==============================================================================
; INTERACID_DIN_DANCING_EVENT
; ==============================================================================
interactionCode4e:
	ld e,$44		; $7518
	ld a,(de)		; $751a
	rst_jumpTable			; $751b
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $7520
	ld (de),a		; $7522
	ld e,$42		; $7523
	ld a,(de)		; $7525
	cp $0b			; $7526
	jr nz,@func_754f	; $7528
	call getThisRoomFlags		; $752a
	and $40			; $752d
	jp nz,@seasonsFunc_08_754c		; $752f
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
@seasonsFunc_08_754c:
	jp interactionDelete		; $754c

@func_754f:
	call interactionInitGraphics		; $754f
	ld e,$42		; $7552
	ld a,(de)		; $7554
	cp $05			; $7555
	jr nz,+			; $7557
	ld e,$66		; $7559
	ld a,$06		; $755b
	ld (de),a		; $755d
	inc e			; $755e
	ld (de),a		; $755f
	jr ++			; $7560
+
	ld hl,_table_770a		; $7562
	rst_addDoubleIndex			; $7565
	ldi a,(hl)		; $7566
	ld h,(hl)		; $7567
	ld l,a			; $7568
	call interactionSetScript		; $7569
	ld e,$42		; $756c
	ld a,(de)		; $756e
	cp $07			; $756f
	jp nz,++		; $7571
	call interactionSetAlwaysUpdateBit		; $7574
	jp objectSetVisible80		; $7577
++
	call objectSetVisible83		; $757a
@state1:
	ld e,$42		; $757d
	ld a,(de)		; $757f
	rst_jumpTable			; $7580
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
	ld a,($cfd0)		; $7597
	or a			; $759a
	jr nz,+			; $759b
	call interactionAnimate		; $759d
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $75a0
+
	call objectCreatePuff		; $75a3
	jp interactionDelete		; $75a6
@@subid0:
@@subid1:
@@subid2:
@@subid3:
@@subid4:
@@subid8:
@@subid9:
	ld e,$45		; $75a9
	ld a,(de)		; $75ab
	rst_jumpTable			; $75ac
	.dw @@@func75b5
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3

@@@func75b5:
	ld a,($cfd0)		; $75b5
	or a			; $75b8
	call nz,interactionIncState2		; $75b9
@@@animate:
	call interactionAnimate		; $75bc
@@@runScriptPushLinkAway:
	call interactionRunScript		; $75bf
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $75c2
@@@substate1:
	ld e,$42		; $75c5
	ld a,(de)		; $75c7
	ld hl,bitTable		; $75c8
	add l			; $75cb
	ld l,a			; $75cc
	ld b,(hl)		; $75cd
	ld a,($cfd1)		; $75ce
	and b			; $75d1
	jr z,+			; $75d2
	call interactionIncState2		; $75d4
	ld l,$46		; $75d7
	ld (hl),$20		; $75d9
	ld l,$4d		; $75db
	ldd a,(hl)		; $75dd
	ld (hl),a		; $75de
+
	ld e,$42		; $75df
	ld a,(de)		; $75e1
	cp $05			; $75e2
	call z,interactionAnimate		; $75e4
	jp @@@runScriptPushLinkAway		; $75e7
@@@substate2:
	call interactionDecCounter1		; $75ea
	jr nz,+			; $75ed
	call @@func_7612		; $75ef
	jp interactionIncState2		; $75f2
+
	call getRandomNumber_noPreserveVars		; $75f5
	and $0f			; $75f8
	sub $08			; $75fa
	ld h,d			; $75fc
	ld l,$4c		; $75fd
	add (hl)		; $75ff
	inc l			; $7600
	ld (hl),a		; $7601
	jp @@@runScriptPushLinkAway		; $7602
@@@substate3:
	call objectApplySpeed		; $7605
	call objectApplySpeed		; $7608
	call objectCheckWithinScreenBoundary		; $760b
	ret c			; $760e
	jp interactionDelete		; $760f
@@func_7612:
	ld e,$42		; $7612
	ld a,(de)		; $7614
	ld hl,@@table_7622		; $7615
	rst_addDoubleIndex			; $7618
	ldi a,(hl)		; $7619
	ld e,$49		; $761a
	ld (de),a		; $761c
	ldi a,(hl)		; $761d
	ld e,$50		; $761e
	ld (de),a		; $7620
	ret			; $7621

@@table_7622:
	; angle - speed
	.db $04 $78
	.db $1d $78
	.db $1e $78
	.db $05 $78
	.db $15 $78
@@subid6:
	ld e,$45		; $762c
	ld a,(de)		; $762e
	rst_jumpTable			; $762f
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4
	.dw @@@substate5
	.dw @@@substate6
@@@substate0:
	ld a,($cfd3)		; $763e
	cp $3f			; $7641
	jp nz,@@subid9@func75b5		; $7643
	call interactionIncState2		; $7646
	ld hl,troupeScript_startDanceScene		; $7649
	call interactionSetScript		; $764c
@@@substate1:
	call @@subid9@func75b5		; $764f
	ld a,($cfd3)		; $7652
	and $40			; $7655
	ret z			; $7657
	call fastFadeoutToWhite		; $7658
	jp interactionIncState2		; $765b
@@@substate2:
	ld a,($c4ab)		; $765e
	or a			; $7661
	ret nz			; $7662
	ld a,$80		; $7663
	ld ($cfd3),a		; $7665
	ld a,CUTSCENE_S_DIN_DANCING		; $7668
	ld ($cc04),a		; $766a
	ld a,$08		; $766d
	call setLinkIDOverride		; $766f
	ld l,$02		; $7672
	ld (hl),$01		; $7674
	ld l,$19		; $7676
	ld (hl),d		; $7678
	jp interactionIncState2		; $7679
@@@substate3:
	ld a,($cfd0)		; $767c
	or a			; $767f
	ret nz			; $7680
	call @@subid9@runScriptPushLinkAway		; $7681
	jp interactionIncState2		; $7684
@@@substate4:
	ld a,($cfd0)		; $7687
	cp $04			; $768a
	ret nz			; $768c
	call interactionIncState2		; $768d
	ld a,$0d		; $7690
	jp interactionSetAnimation		; $7692
@@@substate5:
	ld a,($cfd0)		; $7695
	cp $07			; $7698
	ret nz			; $769a
	call interactionIncState2		; $769b
	ld l,$50		; $769e
	ld (hl),$0a		; $76a0
	ld l,$49		; $76a2
	ld (hl),$08		; $76a4
	ret			; $76a6
@@@substate6:
	call objectApplySpeed		; $76a7
	ld a,($cfd1)		; $76aa
	rlca			; $76ad
	ret nc			; $76ae
	ld hl,$cfd0		; $76af
	ld (hl),$08		; $76b2
	jp interactionDelete		; $76b4
@@subid7:
	ld e,$45		; $76b7
	ld a,(de)		; $76b9
	rst_jumpTable			; $76ba
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
@@@substate0:
	call interactionRunScript		; $76c1
	jr nc,@@@func_76e9	; $76c4
	call interactionIncState2		; $76c6
	ld hl,$cfd0		; $76c9
	ld (hl),$04		; $76cc
	jr @@@func_76e9		; $76ce
@@@substate1:
	call @@@func_76e9		; $76d0
	ld hl,$cfd0		; $76d3
	ld a,(hl)		; $76d6
	cp $06			; $76d7
	ret nz			; $76d9
	call interactionIncState2		; $76da
	ld hl,troupeScript_tornadoEnd		; $76dd
	jp interactionSetScript		; $76e0
@@@substate2:
	call interactionRunScript		; $76e3
	jp c,interactionDelete		; $76e6
@@@func_76e9:
	call interactionAnimate		; $76e9
	ld a,(wFrameCounter)		; $76ec
	and $3f			; $76ef
	ret nz			; $76f1
	ld a,$d3		; $76f2
	jp playSound		; $76f4
@@subidA:
	call checkInteractionState2		; $76f7
	jr nz,+			; $76fa
	call interactionIncState2		; $76fc
	ld a,GLOBALFLAG_FINISHEDGAME		; $76ff
	call checkGlobalFlag		; $7701
	jp z,interactionDelete		; $7704
+
	jp @@subid9@animate		; $7707

_table_770a:
	.dw troupeScript1
	.dw troupeScript2
	.dw troupeScript3
	.dw troupeScript4
	.dw troupeScript_Impa
	.dw troupeScript_stub
	.dw troupeScript_Din
	.dw troupeScript_tornadoStart
	.dw troupeScript_stub
	.dw troupeScript_stub
	.dw troupeScript_inHoronVillage


; ==============================================================================
; INTERACID_DIN_IMPRISONED_EVENT
; ==============================================================================
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
	ld hl,dinImprisonedScript_setDinCoords		; $773e
	call interactionSetScript		; $7741
	jp objectSetVisiblec2		; $7744

@subid1:
	ld hl,dinImprisonedScript_OnoxExplainsMotive		; $7747
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
	ld hl,dinImprisonedScript_OnoxSaysComeIfYouDare		; $777b
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
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT		; $78dd
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
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT		; $7977
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
	ld hl,dinImprisonedScript_OnoxSendsTempleDown		; $7a15
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
	jr z,@state0	; $7a40
	ld a,(wFrameCounter)		; $7a42
	and $0f			; $7a45
	ld a,$b3		; $7a47
	call z,playSound		; $7a49
	ld a,($cd18)		; $7a4c
	or a			; $7a4f
	jr nz,+			; $7a50
	ld a,($cd19)		; $7a52
	or a			; $7a55
	call z,_func_7a9a		; $7a56
+
	call interactionDecCounter1		; $7a59
	ret nz			; $7a5c
	call _func_7abe		; $7a5d
	ld e,$42		; $7a60
	ld a,(de)		; $7a62
	or a			; $7a63
	ld c,$07		; $7a64
	jr z,+			; $7a66
	ld c,$0f		; $7a68
+
	call getRandomNumber		; $7a6a
	and c			; $7a6d
	srl c			; $7a6e
	inc c			; $7a70
	sub c			; $7a71
	ld c,a			; $7a72
	call getFreePartSlot		; $7a73
	ret nz			; $7a76
	ld (hl),PARTID_VOLCANO_ROCK		; $7a77
	ld e,$42		; $7a79
	inc l			; $7a7b
	ld a,(de)		; $7a7c
	ld (hl),a		; $7a7d
	ld b,$00		; $7a7e
	jp objectCopyPositionWithOffset		; $7a80
@state0:
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
_func_7a9a:
	ld h,d			; $7a9a
	ld l,$58		; $7a9b
	ldi a,(hl)		; $7a9d
	ld h,(hl)		; $7a9e
	ld l,a			; $7a9f
	ldi a,(hl)		; $7aa0
	cp $ff			; $7aa1
	jr nz,+			; $7aa3
	pop hl			; $7aa5
	jp interactionDelete		; $7aa6
+
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
_func_7abe:
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
	; wScreenShakeCounterY - wScreenShakeCounterX - var30 - var31
	.db $00 $0f $00 $ff
	.db $0f $00 $00 $ff
	.db $96 $00 $0f $08
	.db $5a $5a $07 $03
	.db $00 $3c $1f $10
	.db $00 $78 $00 $ff
	.db $ff

_table_7ae8:
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
	ld e,$44		; $7b05
	ld a,(de)		; $7b07
	rst_jumpTable			; $7b08
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $7b0d
	ld (de),a		; $7b0f
	call interactionInitGraphics		; $7b10
	call interactionSetAlwaysUpdateBit		; $7b13
	call objectSetVisible82		; $7b16
	ld a,>TX_0b00		; $7b19
	call interactionSetHighTextIndex		; $7b1b
	ld hl,biggoronScript		; $7b1e
	jp interactionSetScript		; $7b21
@state1:
	call interactionAnimate		; $7b24
	jp interactionRunScript		; $7b27


; ==============================================================================
; INTERACID_HEAD_SMELTER
; ==============================================================================
interactionCode53:
	ld e,$42		; $7b2a
	ld a,(de)		; $7b2c
	rst_jumpTable			; $7b2d
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,$44		; $7b32
	ld a,(de)		; $7b34
	rst_jumpTable			; $7b35
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	call getThisRoomFlags		; $7b3c
	bit 7,(hl)		; $7b3f
	jp nz,interactionDelete		; $7b41
	ld e,$44		; $7b44
	ld a,$01		; $7b46
	ld (de),a		; $7b48
	call interactionInitGraphics		; $7b49
	ld hl,headSmelterAtTempleScript		; $7b4c
	call interactionSetScript		; $7b4f
	jp objectSetVisible82		; $7b52
@@state1:
	call interactionRunScript		; $7b55
	call objectPreventLinkFromPassing		; $7b58
	jp npcFaceLinkAndAnimate		; $7b5b
@@state2:
	call interactionAnimate		; $7b5e
	call interactionRunScript		; $7b61
	jp c,interactionDelete		; $7b64
	ret			; $7b67
@subid1:
	ld e,$44		; $7b68
	ld a,(de)		; $7b6a
	rst_jumpTable			; $7b6b
	.dw @@state0
	.dw @subid0@state1
	.dw @subid0@state2
	.dw @@state3
@@state0:
	ld a,GLOBALFLAG_UNBLOCKED_AUTUMN_TEMPLE		; $7b74
	call checkGlobalFlag		; $7b76
	jp z,interactionDelete		; $7b79
	ld e,$44		; $7b7c
	ld a,$01		; $7b7e
	ld (de),a		; $7b80
	call interactionInitGraphics		; $7b81
	ld hl,headSmelterAtFurnaceScript		; $7b84
	call interactionSetScript		; $7b87
	jp objectSetVisible82		; $7b8a
@@state3:
	xor a			; $7b8d
	ld ($cfc0),a		; $7b8e
	call interactionRunScript		; $7b91
	ld e,$45		; $7b94
	ld a,(de)		; $7b96
	rst_jumpTable			; $7b97
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
@@@substate0:
@@@substate1:
	call interactionAnimate		; $7ba0
	ld a,($cfc0)		; $7ba3
	call getHighestSetBit		; $7ba6
	ret nc			; $7ba9
	cp $03			; $7baa
	jr nz,+			; $7bac
	ld e,$44		; $7bae
	ld a,$01		; $7bb0
	ld (de),a		; $7bb2
	ret			; $7bb3
+
	ld b,a			; $7bb4
	inc b			; $7bb5
	ld h,d			; $7bb6
	ld l,$45		; $7bb7
	ld (hl),b		; $7bb9
	ld l,$43		; $7bba
	ld (hl),$08		; $7bbc
	add $04			; $7bbe
	jp interactionSetAnimation		; $7bc0
@@@substate2:
@@@substate3:
	call interactionAnimate		; $7bc3
	ld h,d			; $7bc6
	ld l,$61		; $7bc7
	ld a,(hl)		; $7bc9
	or a			; $7bca
	jr z,+			; $7bcb
	ld (hl),$00		; $7bcd
	ld l,$4d		; $7bcf
	add (hl)		; $7bd1
	ld (hl),a		; $7bd2
+
	ld l,$43		; $7bd3
	dec (hl)		; $7bd5
	ret nz			; $7bd6
	ld l,$45		; $7bd7
	ld (hl),$01		; $7bd9
	ret			; $7bdb


; ==============================================================================
; INTERACID_SUBROSIAN_AT_D8_ITEMS
; ==============================================================================
interactionCode54:
	ld e,$44		; $7bdc
	ld a,(de)		; $7bde
	rst_jumpTable			; $7bdf
	.dw @state0
	.dw @state1
	.dw objectSetVisible82
@state0:
	ld a,$01		; $7be6
	ld (de),a		; $7be8
	call getRandomNumber	; $7be9
	and $0f			; $7bec
	ld hl,@table_7c0a		; $7bee
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
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call interactionInitGraphics		; $7d2c
	call interactionSetAlwaysUpdateBit		; $7d2f
--
	ld h,d			; $7d32
	ld l,$44		; $7d33
	ld (hl),$01		; $7d35
	ld a,>TX_0b00		; $7d37
	call interactionSetHighTextIndex		; $7d39
	ld hl,ingoScript_tradingVase		; $7d3c
	call interactionSetScript		; $7d3f
	ld a,$02		; $7d42
	call interactionSetAnimation		; $7d44
	jp @preventLinkFromPassing		; $7d47
@state1:
	call @func_7d5a		; $7d4a
	call interactionRunScript		; $7d4d
	jp npcFaceLinkAndAnimate		; $7d50
@state2:
	call interactionRunScript		; $7d53
	jr c,--			; $7d56
	jr @func7d84		; $7d58
@func_7d5a:
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
	ld hl,ingoScript_LinkApproachingVases		; $7d74
	call interactionSetScript		; $7d77
	ld h,d			; $7d7a
	ld l,$44		; $7d7b
	ld (hl),$02		; $7d7d
	inc l			; $7d7f
	ld (hl),$00		; $7d80
	pop bc			; $7d82
	ret			; $7d83
@func7d84:
	call interactionAnimate		; $7d84
	ld e,$7e		; $7d87
	ld a,(de)		; $7d89
	or a			; $7d8a
	jr z,@preventLinkFromPassing	; $7d8b
	ld e,$60		; $7d8d
	ld a,(de)		; $7d8f
	cp $0d			; $7d90
	jr nz,@preventLinkFromPassing	; $7d92
	ld e,$60		; $7d94
	ld a,$01		; $7d96
	ld (de),a		; $7d98
@preventLinkFromPassing:
	call objectPreventLinkFromPassing		; $7d99
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7d9c


; ==============================================================================
; INTERACID_GURU_GURU
; ==============================================================================
interactionCode58:
	ld e,$44		; $7d9f
	ld a,(de)		; $7da1
	rst_jumpTable			; $7da2
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics			; $7da7
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
	call _func_7e20		; $7dc3
	ld a,>TX_0b00		; $7dc6
	call interactionSetHighTextIndex		; $7dc8
	ld hl,guruGuruScript		; $7dcb
	call interactionSetScript		; $7dce
	jp _func_7ddc		; $7dd1
@state1:
	call interactionRunScript		; $7dd4
	call _func_7deb		; $7dd7
	jr _func_7ddc		; $7dda
_func_7ddc:
	ld e,$79		; $7ddc
	ld a,(de)		; $7dde
	or a			; $7ddf
	jr z,+			; $7de0
	call interactionAnimate		; $7de2
+
	call objectPreventLinkFromPassing		; $7de5
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7de8
_func_7deb:
	ld e,$78		; $7deb
	ld a,(de)		; $7ded
	rst_jumpTable			; $7dee
	.dw @var38_00
	.dw _func_7e38
@var38_00:
	ld e,$7b		; $7df3
	ld a,(de)		; $7df5
	or a			; $7df6
	jr z,_func_7e0f	; $7df7
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
_func_7e0f:
	ld h,d			; $7e0f
	ld l,$78		; $7e10
	ld (hl),$01		; $7e12
	ld l,$79		; $7e14
	ld (hl),$00		; $7e16
	ld a,($d00d)		; $7e18
	ld l,$4d		; $7e1b
	cp (hl)			; $7e1d
	jr nc,_func_7e2c	; $7e1e
_func_7e20:
	ld l,$49		; $7e20
	ld (hl),$18		; $7e22
	ld l,$7a		; $7e24
	ld a,$03		; $7e26
	ld (hl),a		; $7e28
	jp interactionSetAnimation		; $7e29
_func_7e2c:
	ld l,$49		; $7e2c
	ld (hl),$08		; $7e2e
	ld l,$7a		; $7e30
	ld a,$01		; $7e32
	ld (hl),a		; $7e34
	jp interactionSetAnimation		; $7e35
_func_7e38:
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
	.dw @state0
	.dw @state1
@state0:
	call getThisRoomFlags		; $7e53
	and $40			; $7e56
	jp nz,interactionDelete		; $7e58
	ld a,TREASURE_SWORD		; $7e5b
	call checkTreasureObtained		; $7e5d
	jr nc,+			; $7e60
	cp $03			; $7e62
	jp nc,interactionDelete		; $7e64
	sub $01			; $7e67
	ld e,$42		; $7e69
	ld (de),a		; $7e6b
+
	call interactionInitGraphics		; $7e6c
	call interactionIncState		; $7e6f
	call objectSetVisible		; $7e72
	call objectSetVisible80		; $7e75
	ld hl,lostWoodsSwordScript		; $7e78
	call interactionSetScript		; $7e7b
	ld a,$4d		; $7e7e
	call playSound		; $7e80
	ldbc INTERACID_SPARKLE $04		; $7e83
	jp objectCreateInteraction		; $7e86
@state1:
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


; ==============================================================================
; INTERACID_LOST_WOODS_DEKU_SCRUB
; ==============================================================================
interactionCode5b:
	ld e,$44		; $7f25
	ld a,(de)		; $7f27
	rst_jumpTable			; $7f28
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics		; $7f2d
	ld a,$86		; $7f30
	call loadPaletteHeader		; $7f32
	call interactionSetAlwaysUpdateBit		; $7f35
	ld a,>TX_0b00		; $7f38
	call interactionSetHighTextIndex		; $7f3a
	ld h,d			; $7f3d
	ld l,$44		; $7f3e
	ld (hl),$01		; $7f40
	ld l,$49		; $7f42
	ld (hl),$04		; $7f44
	ld hl,lostWoodsDekuScrubScript		; $7f46
	call interactionSetScript		; $7f49
@state1:
	call interactionRunScript		; $7f4c
	call @func_7f55		; $7f4f
	jp interactionAnimateAsNpc		; $7f52
@func_7f55:
	ld e,$79		; $7f55
	ld a,(de)		; $7f57
	rst_jumpTable			; $7f58
	.dw @@var39_00
	.dw @@var39_01
@@var39_00:
	ld h,d			; $7f5d
	ld l,$77		; $7f5e
	ld a,(hl)		; $7f60
	cp $04			; $7f61
	ret nz			; $7f63
	ld l,$79		; $7f64
	ld (hl),$01		; $7f66
	ld a,$3d		; $7f68
	jp playSound		; $7f6a
@@var39_01:
	ret			; $7f6d


; ==============================================================================
; INTERACID_LAVA_SOUP_SUBROSIAN
; ==============================================================================
interactionCode5c:
	ld e,$44		; $7f6e
	ld a,(de)		; $7f70
	rst_jumpTable			; $7f71
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics		; $7f76
	call interactionIncState		; $7f79
	ld l,$49		; $7f7c
	ld (hl),$04		; $7f7e
	ld a,>TX_0b00		; $7f80
	call interactionSetHighTextIndex		; $7f82
	ld hl,lavaSoupSubrosianScript		; $7f85
	call interactionSetScript		; $7f88
@state1:
	call interactionRunScript		; $7f8b
	ld e,$7f		; $7f8e
	ld a,(de)		; $7f90
	or a			; $7f91
	jp z,npcFaceLinkAndAnimate		; $7f92
	call interactionAnimate		; $7f95
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7f98


; ==============================================================================
; INTERACID_TRADE_ITEM
; ==============================================================================
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
