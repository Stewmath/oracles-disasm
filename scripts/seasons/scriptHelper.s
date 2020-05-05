 m_section_force Script_Helper2 NAMESPACE scriptHlp

D3spawnPitSpreader:
	; Part $0a, subid $00, yh $72
	ld bc,$0072		; $5481
	jp _spawnPitSpreader		; $5484


D3StatuePuzzleCheck:
	xor a			; $5487
	ld ($ccba),a		; $5488
	ld l,$84		; $548b
	ld h,>wRoomLayout		; $548d
	ldi a,(hl)		; $548f
	; blue statue
	cp $2c			; $5490
	ret nz			; $5492
	ldi a,(hl)		; $5493
	cp $2c			; $5494
	ret nz			; $5496
	ldi a,(hl)		; $5497
	cp $2c			; $5498
	ret nz			; $549a
	ldi a,(hl)		; $549b
	; red statue
	cp $2d			; $549c
	ret nz			; $549e
	ldi a,(hl)		; $549f
	cp $2d			; $54a0
	ret nz			; $54a2
	ldi a,(hl)		; $54a3
	cp $2d			; $54a4
	ret nz			; $54a6
	ld a,$01		; $54a7
	ld ($ccba),a		; $54a9
	ret			; $54ac


_solvedPuzzleSetRoomFlag07:
	call getThisRoomFlags		; $54ad
	set 7,(hl)		; $54b0
	ld a,SND_SOLVEPUZZLE		; $54b2
	jp playSound		; $54b4


_createBridgeSpawner:
	call getFreePartSlot		; $54b7
	ret nz			; $54ba
	ld (hl),PARTID_BRIDGE_SPAWNER		; $54bb
	ld l,Part.counter2		; $54bd
	ld (hl),b		; $54bf
	ld l,Part.angle		; $54c0
	ld (hl),c		; $54c2
	ld l,Part.yh		; $54c3
	ld (hl),e		; $54c5
	ret			; $54c6


D4spawnBridgeB2:
	call _solvedPuzzleSetRoomFlag07		; $54c7
	ld bc,$0601		; $54ca
	ld e,$59		; $54cd
	jp _createBridgeSpawner		; $54cf


D7spawnDarknutBridge:
	ld a,SND_SOLVEPUZZLE		; $54d2
	call playSound		; $54d4
	ld bc,$0801		; $54d7
	ld e,$77		; $54da
	jp _createBridgeSpawner		; $54dc


D8VerticalBridgeUnlockedByOrb:
	call _solvedPuzzleSetRoomFlag07		; $54df
	ld bc,$0c02		; $54e2
	ld e,$3c		; $54e5
	jp _createBridgeSpawner		; $54e7


D8VerticalBridgeInLava:
	call _solvedPuzzleSetRoomFlag07		; $54ea
	ld bc,$0e00		; $54ed
	ld e,$7b		; $54f0
	jp _createBridgeSpawner		; $54f2


D8HorizontalBridgeByMoldorms:
	call _solvedPuzzleSetRoomFlag07		; $54f5
	ld bc,$0e03		; $54f8
	ld e,$88		; $54fb
	jp _createBridgeSpawner		; $54fd


_spawnPitSpreader:
	call getFreePartSlot		; $5500
	ret nz			; $5503
	ld (hl),PARTID_HOLES_FLOORTRAP		; $5504
	inc l			; $5506
	; subid
	ld (hl),b		; $5507
	ld l,Part.yh		; $5508
	ld (hl),c		; $550a
	ret			; $550b


D3hallToMiniboss_buttonStepped:
	ld a,$01		; $550c
	ld ($ccbf),a		; $550e
	ret			; $5511


D3openEssenceDoorIfBossBeat_body:
	ld a,(wDungeonFlagsAddressH)		; $5512
	ld b,a			; $5515
	ld c,<ROOM_SEASONS_453		; $5516
	ld a,(bc)		; $5518
	bit 7,a			; $5519
	ret z			; $551b
	call getFreeInteractionSlot		; $551c
	ld (hl),INTERACID_DOOR_CONTROLLER		; $551f
	ld l,Interaction.angle		; $5521
	; shutter
	ld (hl),ANGLE_DOWN		; $5523
	ld l,Interaction.yh		; $5525
	ld (hl),$07		; $5527
	ret			; $5529


D6setFlagBit7InRoomWithLowIndexInAngle:
	ld e,Interaction.angle		; $552a
	ld a,(de)		; $552c
	ld l,a			; $552d
	jr _setFlagBit7InRoomLowIndexInL		; $552e


D6setFlagBit7InFirst4FRoom:
	ld l,<ROOM_SEASONS_4d4		; $5530
	jr _setFlagBit7InRoomLowIndexInL		; $5532


D6setFlagBit7InLast4FRoom:
	ld l,<ROOM_SEASONS_4d3		; $5534


_setFlagBit7InRoomLowIndexInL:
	ld a,(wDungeonFlagsAddressH)		; $5536
	ld h,a			; $5539
	set 7,(hl)		; $553a
	ret			; $553c


D6getRandomButtonResult:
	ld b,$00		; $553d
	ld a,(wActiveTriggers)		; $553f
	or a			; $5542
	jr z,+			; $5543
	ld a,(wFrameCounter)		; $5545
	and $01			; $5548
	inc a			; $554a
	ld b,a			; $554b
+
	ld a,b			; $554c
	ld ($cfc1),a		; $554d
	ret			; $5550


D6spawnFloorDestroyerAndEscapeBridge:
	call getFreePartSlot		; $5551
	ret nz			; $5554

	ld (hl),PARTID_HOLES_FLOORTRAP		; $5555
	inc l			; $5557
	ld (hl),$04		; $5558

	ld bc,$0603		; $555a
	ld e,$14		; $555d
	jp _createBridgeSpawner		; $555f


D6spawnChestAfterCrystalTrapRoom_body:
	xor a			; $5562
	ld ($cfd0),a		; $5563
	call getThisRoomFlags		; $5566
	inc hl			; $5569
	res 5,(hl)		; $556a
	ret			; $556c


warpToD7Entrance:
	ld hl,@warpDestVariables		; $556d
	jp setWarpDestVariables		; $5570
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_55b $00 $57 $03


D7randomlyPlaceNonEnemyArmos_body:
	call getRandomNumber		; $5578
	and $07			; $557b
	ld hl,@armosPositions		; $557d
	rst_addAToHl			; $5580
	ld l,(hl)		; $5581
	ld h,$cf		; $5582
	ld (hl),$25		; $5584
	ld a,$03		; $5586
	ld ($ff00+R_SVBK),a	; $5588
	ld h,$df		; $558a
	ld (hl),$25		; $558c

	xor a			; $558e
	ld ($ff00+R_SVBK),a	; $558f

	call getFreeEnemySlot		; $5591
	ret nz			; $5594

	ld (hl),$1d		; $5595
	inc l			; $5597
	ld (hl),$00		; $5598
	ld l,$8b		; $559a
	ld (hl),$27		; $559c
	ld l,$8d		; $559e
	ld (hl),$a0		; $55a0
	ret			; $55a2
@armosPositions:
	.db $36 $38 $45 $49
	.db $65 $69 $76 $78


D7MagnetBallRoom_removeChest:
	call objectGetTileAtPosition		; $55ab
	cp TILEINDEX_DUNGEON_a3			; $55ae
	ret z			; $55b0
	ld c,l			; $55b1
	ld a,TILEINDEX_DUNGEON_a3		; $55b2
	call setTile		; $55b4
	jr +		; $55b7


D7MagnetBallRoom_addChest:
	call objectGetTileAtPosition		; $55b9
	cp TILEINDEX_CHEST			; $55bc
	ret z			; $55be
	cp TILEINDEX_CHEST_OPENED			; $55bf
	ret z			; $55c1
	ld c,l			; $55c2
	ld a,TILEINDEX_CHEST		; $55c3
	call setTile		; $55c5
	ld a,SND_SOLVEPUZZLE		; $55c8
	call playSound		; $55ca
+
	jp objectCreatePuff		; $55cd


D7dropKeyDownAFloor:
	call getFreeInteractionSlot		; $55d0
	ret nz			; $55d3
	ld (hl),INTERACID_TREASURE		; $55d4
	inc l			; $55d6
	ld (hl),$30		; $55d7
	inc l			; $55d9
	ld (hl),$01		; $55da
	call objectCopyPosition		; $55dc
	call getThisRoomFlags		; $55df
	set 6,(hl)		; $55e2
	; room below
	ld l,<ROOM_SEASONS_545		; $55e4
	set 7,(hl)		; $55e6
	ld a,SND_SOLVEPUZZLE		; $55e8
	jp playSound		; $55ea


checkFirstPoeBeaten:
	ld a,<ROOM_SEASONS_556		; $55ed
checkPoeBeaten:
	call getARoomFlags		; $55ef
	bit 6,(hl)		; $55f2
	ld a,$01		; $55f4
	jr nz,+			; $55f6
	dec a			; $55f8
+
	ld ($cfc1),a		; $55f9
	ret			; $55fc


checkSecondPoeBeaten:
	ld a,<ROOM_SEASONS_54e		; $55fd
	jr checkPoeBeaten		; $55ff


D8armosCheckIfWillMove:
	ld a,(wLinkUsingItem1)		; $5601
	or a			; $5604
	jr nz,+			; $5605
	ld a,(wFrameCounter)		; $5607
	rrca			; $560a
	ret c			; $560b

	ld h,d			; $560c
	ld l,Interaction.direction		; $560d
	dec (hl)		; $560f
	ret nz			; $5610

	call getFreeEnemySlot		; $5611
	jr nz,+			; $5614
	ld (hl),$1d		; $5616
	ld l,Enemy.yh		; $5618
	ld (hl),$27		; $561a
	ld l,Enemy.xh		; $561c
	ld (hl),$a0		; $561e
	ld a,$45		; $5620
	ld (wcca2),a		; $5622
	ld a,SND_SOLVEPUZZLE		; $5625
	call playSound		; $5627
	call getThisRoomFlags		; $562a
	set 7,(hl)		; $562d
+
	ld e,Interaction.angle		; $562f
	ld a,$01		; $5631
	ld (de),a		; $5633
	ret			; $5634


D8setSpawnAtLavaHole:
	ld a,TILEINDEX_LAVA_HOLE		; $5635
	call findTileInRoom		; $5637
	ld a,l			; $563a
	ld l,Interaction.yh		; $563b
	ld h,d			; $563d
	jp setShortPosition		; $563e


D8SpawnLimitedFireKeese:
	ld a,(wDisabledObjects)		; $5641
	or a			; $5644
	ret nz			; $5645
	ld b,ENEMYID_FIRE_KEESE		; $5646
	call _countFireKeese		; $5648
	cp $04			; $564b
	ret nc			; $564d
	call getRandomNumber		; $564e
	cp $40			; $5651
	ret c			; $5653
	call getFreeEnemySlot_uncounted		; $5654
	ret nz			; $5657
	ld (hl),ENEMYID_FIRE_KEESE		; $5658
	inc l			; $565a
	ld (hl),$01		; $565b
	jp objectCopyPosition		; $565d


_countFireKeese:
	ld c,$00		; $5660
	ld hl,$d080		; $5662
-
	ldi a,(hl)		; $5665
	or a			; $5666
	jr z,+			; $5667
	ld a,(hl)		; $5669
	cp b			; $566a
	jr nz,+			; $566b
	inc c			; $566d
+
	dec l			; $566e
	inc h			; $566f
	ld a,h			; $5670
	cp $e0			; $5671
	jr c,-			; $5673
	ld a,c			; $5675
	or a			; $5676
	ret			; $5677


D8checkAllIceBlocksInPlace:
	xor a			; $5678
	ld ($cfc1),a		; $5679
	ld h,>wRoomLayout		; $567c
	ld l,$4d		; $567e
	ld a,TILEINDEX_PUSHABLE_ICE_BLOCK		; $5680
	cp (hl)			; $5682
	ret nz			; $5683
	ld l,$5d		; $5684
	cp (hl)			; $5686
	ret nz			; $5687
	ld l,$6d		; $5688
	cp (hl)			; $568a
	ret nz			; $568b
	ld a,$01		; $568c
	ld ($cfc1),a		; $568e
	ret			; $5691


D6RandomButtonSpawnRopes:
	ld e,$06		; $5692
-
	call getFreeEnemySlot		; $5694
	ret nz			; $5697
	ld (hl),$10		; $5698
	inc l			; $569a
	ld (hl),$01		; $569b
	call $56a4		; $569d
	dec e			; $56a0
	jr nz,-			; $56a1
	ret			; $56a3
@spawnRopeAtRandomPosition:
	call getRandomNumber		; $56a4
	and $07			; $56a7
	inc a			; $56a9
	swap a			; $56aa
	ld b,a			; $56ac
	bit 7,a			; $56ad
	jr nz,@spawnRopeAtRandomPosition	; $56af
	; b is 1 - 7
	call getRandomNumber		; $56b1
	and $07			; $56b4
	add $03			; $56b6
	; a is 3 - 10
	or b			; $56b8
	ld b,$ce		; $56b9
	ld c,a			; $56bb
	ld a,(bc)		; $56bc
	or a			; $56bd
	jr nz,@spawnRopeAtRandomPosition	; $56be
	ld l,$8b		; $56c0
	jp setShortPosition_paramC		; $56c2


toggleBlocksInAngleBitsHit:
	ld e,Interaction.angle		; $56c5
	ld a,(de)		; $56c7
	ld b,a			; $56c8
	ld a,(wToggleBlocksState)		; $56c9
	and b			; $56cc
	cp b			; $56cd
	ld a,$01		; $56ce
	jr z,+			; $56d0
	xor a			; $56d2
+
	ld (wActiveTriggers),a		; $56d3
	ret			; $56d6


createD7Trampoline:
	ld e,Interaction.angle		; $56d7
	ld a,(de)		; $56d9
	ld c,a			; $56da
	ld b,INTERACID_TRAMPOLINE		; $56db
	jp objectCreateInteraction		; $56dd


D9forceRoomClearsOnDungeonEntry:
	call getThisRoomFlags		; $56e0
	ld l,$93		; $56e3
	res 6,(hl)		; $56e5
	inc l			; $56e7
	res 6,(hl)		; $56e8
	inc l			; $56ea
	res 6,(hl)		; $56eb
	ret			; $56ed


D8createFiresGoingOut:
	ld a,TILEINDEX_UNLIT_TORCH		; $56ee
	call findTileInRoom		; $56f0
	ret nz			; $56f3

	call _createLightableTorches		; $56f4
-
	ld a,TILEINDEX_UNLIT_TORCH		; $56f7
	call backwardsSearch		; $56f9
	ret nz			; $56fc
	call _createLightableTorches		; $56fd
	jr -			; $5700


_createLightableTorches:
	push hl			; $5702
	ld c,l			; $5703
	call getFreePartSlot		; $5704
	jr nz,+			; $5707
	ld (hl),PARTID_LIGHTABLE_TORCH		; $5709
	inc l			; $570b
	ld (hl),$01		; $570c
	ld l,Part.counter2		; $570e
	ld (hl),$30		; $5710
	ld l,Part.yh		; $5712
	call setShortPosition_paramC		; $5714
+
	pop hl			; $5717
	dec hl			; $5718
	ret			; $5719


	call fadeoutToBlackWithDelay		; $571a
	jr _label_15_202		; $571d
	call fadeinFromBlackWithDelay		; $571f
_label_15_202:
	ld a,$ff		; $5722
	ld ($c4b1),a		; $5724
	ld ($c4b3),a		; $5727
	ld a,$01		; $572a
	ld ($c4b2),a		; $572c
	ld a,$fe		; $572f
	ld ($c4b4),a		; $5731
	ret			; $5734
	ld c,a			; $5735
	call checkIsLinkedGame		; $5736
	jr z,_label_15_203	; $5739
	ld a,c			; $573b
	add $1b			; $573c
	ld c,a			; $573e
_label_15_203:
	ld b,$17		; $573f
	jp showText		; $5741
	ld a,$10		; $5744
	jr _label_15_204		; $5746
	ld a,$08		; $5748
_label_15_204:
	ld h,d			; $574a
	ld l,$7e		; $574b
	ld b,(hl)		; $574d
	and b			; $574e
	ld l,$7f		; $574f
	ld (hl),$01		; $5751
	ret nz			; $5753
	ld (hl),$00		; $5754
	ret			; $5756
	ld a,($d601)		; $5757
	cp $05			; $575a
	ret nz			; $575c
	ld a,($cc7e)		; $575d
	or a			; $5760
	ret nz			; $5761
	call objectCheckCollidedWithLink_notDead		; $5762
	ret nc			; $5765
	ld a,$01		; $5766
	ld ($cfc0),a		; $5768
	ret			; $576b
	ld e,$42		; $576c
	ld a,(de)		; $576e
	cp $04			; $576f
	ret nz			; $5771
	call checkIsLinkedGame		; $5772
	ret z			; $5775
	call getFreeInteractionSlot		; $5776
	ret nz			; $5779
	ld (hl),$b3		; $577a
	inc l			; $577c
	ld (hl),$04		; $577d
	ld l,$4a		; $577f
	ld (hl),$28		; $5781
	ld l,$4c		; $5783
	ld (hl),$58		; $5785
	ret			; $5787
	ld e,$57		; $5788
	ld a,(de)		; $578a
	ld h,a			; $578b
	ld l,$4b		; $578c
	ld b,(hl)		; $578e
	ld l,$4d		; $578f
	ld c,(hl)		; $5791
	ld a,$6e		; $5792
	jp createEnergySwirlGoingIn		; $5794
	ld b,$00		; $5797
	jr _label_15_205		; $5799
	ld b,$01		; $579b
_label_15_205:
	call getFreeInteractionSlot		; $579d
	ret nz			; $57a0
	ld (hl),$50		; $57a1
	ld e,$43		; $57a3
	ld a,(de)		; $57a5
	inc l			; $57a6
	ldi (hl),a		; $57a7
	ld (hl),b		; $57a8
	ld l,$4b		; $57a9
	ld (hl),$18		; $57ab
	ld l,$4d		; $57ad
	ld (hl),$70		; $57af
	ld e,$57		; $57b1
	ld a,h			; $57b3
	ld (de),a		; $57b4
	ret			; $57b5
	ld a,($c6b0)		; $57b6
	add a			; $57b9
	call getNumSetBits		; $57ba
	ld h,d			; $57bd
	ld l,$7f		; $57be
	ld (hl),$00		; $57c0
	cp $04			; $57c2
	ret nz			; $57c4
	inc (hl)		; $57c5
	ld a,($cc4c)		; $57c6
	cp $f5			; $57c9
	ret z			; $57cb
	inc (hl)		; $57cc
	ret			; $57cd
	ld a,$05		; $57ce
	ld b,$b6		; $57d0
	call getRoomFlags		; $57d2
	and $40			; $57d5
	ld a,$01		; $57d7
	jr nz,_label_15_206	; $57d9
	xor a			; $57db
_label_15_206:
	ld e,$7c		; $57dc
	ld (de),a		; $57de
	ret			; $57df
	xor a			; $57e0
	ld ($d02b),a		; $57e1
	ret			; $57e4

seasonsFunc_15_57e5:
	ld a,$04		; $57e5
	call interactionSetAnimation		; $57e7
	ld b,$f0		; $57ea
	ld c,$fc		; $57ec
	ld a,$40		; $57ee
	jp objectCreateExclamationMark		; $57f0
	call objectApplySpeed		; $57f3
	ld c,$10		; $57f6
	call objectCheckLinkWithinDistance		; $57f8
	ret nc			; $57fb
	ld e,$76		; $57fc
	ld a,$01		; $57fe
	ld (de),a		; $5800
	ret			; $5801

seasonsFunc_15_5802:
	ld e,$4b		; $5802
	ld a,(de)		; $5804
	ld hl,$d00b		; $5805
	cp (hl)			; $5808
	jp nz,objectApplySpeed		; $5809
	ld e,$76		; $580c
	ld a,$01		; $580e
	ld (de),a		; $5810
	ret			; $5811

seasonsFunc_15_5812:
	ld b,a			; $5812
	push bc			; $5813
	call objectApplySpeed		; $5814
	ld e,$4b		; $5817
	ld a,(de)		; $5819
	pop bc			; $581a
	sub b			; $581b
	ret nz			; $581c
	ld e,$76		; $581d
	ld (de),a		; $581f
	ret			; $5820

seasonsFunc_15_5821:
	ld b,$00		; $5821
	ld a,($c6bb)		; $5823
	bit 1,a			; $5826
	jr z,_label_15_207	; $5828
	inc b			; $582a
	ld a,$30		; $582b
	call checkGlobalFlag		; $582d
	jr z,_label_15_207	; $5830
	inc b			; $5832
_label_15_207:
	ld hl,$cfc0		; $5833
	ld (hl),b		; $5836
	ret			; $5837

seasonsFunc_15_5838:
	call objectApplySpeed		; $5838
	ld c,$10		; $583b
	jp objectUpdateSpeedZ_paramC		; $583d

seasonsFunc_15_5840:
	ld e,$4b		; $5840
	ld a,(de)		; $5842
	ld hl,$d00b		; $5843
	cp (hl)			; $5846

seasonsFunc_15_5847:
	ld a,ANGLE_DOWN		; $5847
	jr c,+			; $5849
	xor a			; $584b
+
	ld e,Interaction.angle		; $584c
	ld (de),a		; $584e
	ret			; $584f


; ==============================================================================
; INTERACID_BIPIN
; ==============================================================================

;;
; Show some text based on bipin's subid (expected to be 1-9).
; @addr{4fb1}
bipin_showText_subid1To9:
	ld e,Interaction.subid		; $4fb1
	ld a,(de)		; $4fb3
	ld hl,@textIndices-1		; $4fb4
	rst_addAToHl			; $4fb7
	ld b,>TX_4300		; $4fb8
	ld c,(hl)		; $4fba
	jp showText		; $4fbb

@textIndices:
	.db <TX_4302
	.db <TX_4303
	.db <TX_4303
	.db <TX_4304
	.db <TX_4305
	.db <TX_4306
	.db <TX_4307
	.db <TX_4308
	.db <TX_4308


; ==============================================================================
; INTERACID_BLOSSOM
; ==============================================================================

;;
; @param	a	Value to write
; @addr{4fe1}
setNextChildStage:
	ld hl,wNextChildStage		; $4fe1
	ld (hl),a		; $4fe4
	ret			; $4fe5

;;
; @param	a	Bit to set
; @addr{4fe6}
setc6e2Bit:
	ld hl,wc6e2		; $4fe6
	jp setFlag		; $4fe9

;;
; @param	a	Bit to check
; @addr{4fec}
checkc6e2BitSet:
	ld hl,wc6e2		; $4fec
	call checkFlag		; $4fef
	ld a,$01		; $4ff2
	jr nz,+			; $4ff4
	xor a			; $4ff6
+
	ld e,Interaction.var3b		; $4ff7
	ld (de),a		; $4ff9
	ret			; $4ffa

	call cpRupeeValue		; $5880
	ld e,$7c		; $5883
	ld (de),a		; $5885
	ret			; $5886
	ld hl,$c60f		; $5887
	add (hl)		; $588a
	ld (hl),a		; $588b
	ret			; $588c
	ld hl,$c609		; $588d
	ld b,$00		; $5890
_label_15_210:
	ldi a,(hl)		; $5892
	or a			; $5893
	jr z,_label_15_211	; $5894
	and $0f			; $5896
	add b			; $5898
	ld b,a			; $5899
	jr _label_15_210		; $589a
_label_15_211:
	ld a,b			; $589c
_label_15_212:
	sub $03			; $589d
	jr nc,_label_15_212	; $589f
	add $04			; $58a1
	ld ($c60f),a		; $58a3
	ret			; $58a6
	ld a,$07		; $58a7
	jp openMenu		; $58a9
	ld hl,$cfde		; $58ac
	jr _label_15_213		; $58af
	ld hl,$cfdc		; $58b1
_label_15_213:
	ld (hl),d		; $58b4
	inc hl			; $58b5
	ld (hl),$58		; $58b6
	ret			; $58b8
	ld a,$10		; $58b9
	ld ($cc6b),a		; $58bb
	ld hl,$d008		; $58be
	ld (hl),$03		; $58c1
	ret			; $58c3
	ld a,($d00b)		; $58c4
	ld e,$4b		; $58c7
	ld (de),a		; $58c9
	ret			; $58ca
	ld a,($d00b)		; $58cb
	sub $08			; $58ce
	ld e,$4b		; $58d0
	ld (de),a		; $58d2
	ret			; $58d3
	ld e,$4d		; $58d4
	ld a,(de)		; $58d6
	ld b,a			; $58d7
	ld c,$f2		; $58d8
	jr _label_15_214		; $58da
	ld e,$4d		; $58dc
	ld a,(de)		; $58de
	ld b,a			; $58df
	ld c,$0e		; $58e0
_label_15_214:
	ld a,($cfc1)		; $58e2
	add c			; $58e5
	sub b			; $58e6
	ld e,$47		; $58e7
	ld (de),a		; $58e9
	ret			; $58ea
	ld a,$1e		; $58eb
	jp giveTreasure		; $58ed
	ld a,$64		; $58f0
	ld h,d			; $58f2
	ld l,$7e		; $58f3
	add (hl)		; $58f5
	call checkGlobalFlag		; $58f6
	ret z			; $58f9
	ld h,d			; $58fa
	ld l,$7f		; $58fb
	ld (hl),$01		; $58fd
	ret			; $58ff
	ld h,d			; $5900
	ld l,$7e		; $5901
	ld b,(hl)		; $5903
	ld a,$64		; $5904
	add b			; $5906
	call setGlobalFlag		; $5907
	ld a,$00		; $590a
	add b			; $590c
	ld ($c6e6),a		; $590d
	ld bc,$0003		; $5910
	jp secretFunctionCaller		; $5913
	ld c,a			; $5916
	ld a,$53		; $5917
	call interactionSetHighTextIndex		; $5919
	ld a,c			; $591c
	add $00			; $591d
	ld c,a			; $591f
	ld e,$7e		; $5920
	ld a,(de)		; $5922
	ld b,a			; $5923
	add a			; $5924
	add b			; $5925
	add a			; $5926
	add c			; $5927
	ld e,$72		; $5928
	ld (de),a		; $592a
	ret			; $592b
	ld a,($c626)		; $592c
	ld b,a			; $592f
	or a			; $5930
	ld c,$00		; $5931
	jr z,_label_15_215	; $5933
	inc c			; $5935
	cp $14			; $5936
	jr c,_label_15_215	; $5938
	inc c			; $593a
	cp $32			; $593b
	jr c,_label_15_215	; $593d
	inc c			; $593f
	cp $5a			; $5940
	jr c,_label_15_215	; $5942
	inc c			; $5944
	cp $64			; $5945
	jr c,_label_15_215	; $5947
	inc c			; $5949
_label_15_215:
	ld a,c			; $594a
	ld ($cfc0),a		; $594b
	ld a,b			; $594e
	call hexToDec		; $594f
	swap c			; $5952
	or c			; $5954
	ld ($cba8),a		; $5955
	ld a,b			; $5958
	ld ($cba9),a		; $5959
	ret			; $595c
	ld bc,$3700		; $595d
	jp giveRingToLink		; $5960
	ld a,$09		; $5963
	jp openMenu		; $5965
	ld e,$4d		; $5968
	ld a,(de)		; $596a
	srl a			; $596b
	add $10			; $596d
	ld e,$47		; $596f
	ld (de),a		; $5971
	ret			; $5972
	ld e,$77		; $5973
	xor a			; $5975
	ld (de),a		; $5976
	ld a,$46		; $5977
	jp loseTreasure		; $5979
	ld h,d			; $597c
	ld l,$42		; $597d
	ld (hl),$01		; $597f
	ld l,$44		; $5981
	xor a			; $5983
	ldi (hl),a		; $5984
	ld (hl),a		; $5985
	ld a,$27		; $5986
	ld (wActiveMusic),a		; $5988
	jp playSound		; $598b
	ld hl,$c60f		; $598e
	add (hl)		; $5991
	ld (hl),a		; $5992
	ret			; $5993
	call cpRupeeValue		; $5994
	ld e,$7c		; $5997
	ld (de),a		; $5999
	ret			; $599a
	ld hl,$cba5		; $599b
	add (hl)		; $599e
	ld ($c6dd),a		; $599f
	ret			; $59a2
	ld a,($c6dd)		; $59a3
	or a			; $59a6
	jr nz,_label_15_216	; $59a7
	ld a,$38		; $59a9
	jp playSound		; $59ab
_label_15_216:
	ld a,$4a		; $59ae
	jp playSound		; $59b0
	ld c,$40		; $59b3
	jr _label_15_217		; $59b5
	ld c,$04		; $59b7
_label_15_217:
	ld a,$29		; $59b9
	jp giveTreasure		; $59bb
	ld c,a			; $59be
	ld a,$28		; $59bf
	jp giveTreasure		; $59c1
	ld a,($c6c6)		; $59c4
	dec a			; $59c7
	ld c,$03		; $59c8
	jr z,_label_15_218	; $59ca
	ld c,$05		; $59cc
_label_15_218:
	ld b,$00		; $59ce
	ld hl,$cba8		; $59d0
	ld (hl),c		; $59d3
	inc hl			; $59d4
	ld (hl),b		; $59d5
	ret			; $59d6
	ld b,a			; $59d7
	ld e,$42		; $59d8
	ld a,(de)		; $59da
	add a			; $59db
	add b			; $59dc
	ld hl,$59e5		; $59dd
	rst_addAToHl			; $59e0
	ld b,$3a		; $59e1
	ld c,(hl)		; $59e3
	jp showText		; $59e4
	nop			; $59e7
	ld bc,$0302		; $59e8
	inc b			; $59eb
	dec b			; $59ec
	ld b,$07		; $59ed
	ld ($0908),sp		; $59ef
	add hl,bc		; $59f2
	ld c,$30		; $59f3
	call objectUpdateSpeedZ_paramC		; $59f5
	ret nz			; $59f8
	ld h,d			; $59f9
	ld l,$7d		; $59fa
	ld (hl),$01		; $59fc
	ret			; $59fe
	ld b,a			; $59ff
	ld e,$4d		; $5a00
	ld a,(de)		; $5a02
	and $f0			; $5a03
	swap a			; $5a05
	ld c,a			; $5a07
	ld a,b			; $5a08
	jp setTile		; $5a09
	ld a,$13		; $5a0c
	call setGlobalFlag		; $5a0e
	ld hl,$5a1c		; $5a11
	call setWarpDestVariables		; $5a14
	ld a,$8d		; $5a17
	jp playSound		; $5a19
	add c			; $5a1c
	ld (hl),h		; $5a1d
	nop			; $5a1e
	ld b,d			; $5a1f
	add e			; $5a20
	call getFreeInteractionSlot		; $5a21
	ret nz			; $5a24
	ld (hl),$40		; $5a25
	inc l			; $5a27
	ld (hl),$0c		; $5a28
	ld l,$4b		; $5a2a
	ld (hl),$28		; $5a2c
	ld l,$4d		; $5a2e
	ld (hl),$78		; $5a30
	ret			; $5a32
	call getFreeInteractionSlot		; $5a33
	ret nz			; $5a36
	ld (hl),$b8		; $5a37
	inc l			; $5a39
	ld (hl),$03		; $5a3a
	ld l,$4b		; $5a3c
	ld (hl),$88		; $5a3e
	ld l,$4d		; $5a40
	ld (hl),$50		; $5a42
	ret			; $5a44
	ld hl,$5a4d		; $5a45
	ld a,$15		; $5a48
	jp setSimulatedInputAddress		; $5a4a
	ld d,b			; $5a4d
	nop			; $5a4e
	stop			; $5a4f
	inc b			; $5a50
	nop			; $5a51
	nop			; $5a52
	jr nz,_label_15_219	; $5a53
_label_15_219:
	ld b,b			; $5a55
	ld ($0000),sp		; $5a56
	rst $38			; $5a59
	rst $38			; $5a5a
	ld hl,$d01a		; $5a5b
	res 7,(hl)		; $5a5e
	ret			; $5a60
	ld h,d			; $5a61
	ld l,$5a		; $5a62
	res 7,(hl)		; $5a64
	ret			; $5a66
	call setLinkForceStateToState08		; $5a67
	ld hl,$d008		; $5a6a
	ld (hl),$01		; $5a6d
	ret			; $5a6f
	ld e,$4d		; $5a70
	ld a,(de)		; $5a72
	ld hl,$d00d		; $5a73
	sub (hl)		; $5a76
	ld b,a			; $5a77
	add $0c			; $5a78
	cp $18			; $5a7a
	ret nc			; $5a7c
	ld a,($d00b)		; $5a7d
	cp $38			; $5a80
	ret c			; $5a82
	ld a,b			; $5a83
	sub (hl)		; $5a84
	ld a,$01		; $5a85
	jr nc,_label_15_220	; $5a87
	inc a			; $5a89
_label_15_220:
	ld e,$79		; $5a8a
	ld (de),a		; $5a8c
	ret			; $5a8d
	xor a			; $5a8e
	ld e,$79		; $5a8f
	ld (de),a		; $5a91
	ld hl,$c6a7		; $5a92
	ldi a,(hl)		; $5a95
	cp $77			; $5a96
	ret nz			; $5a98
	ld a,(hl)		; $5a99
	cp $07			; $5a9a
	ret nz			; $5a9c
	ld a,$01		; $5a9d
	ld (de),a		; $5a9f
	ret			; $5aa0
	ld hl,$c6ab		; $5aa1
	ld a,(hl)		; $5aa4
	add $20			; $5aa5
	ldd (hl),a		; $5aa7
	ld (hl),a		; $5aa8
	jp setStatusBarNeedsRefreshBit1		; $5aa9
	ld hl,$c6a3		; $5aac
	ld a,($c6a2)		; $5aaf
	cp (hl)			; $5ab2
	ret nz			; $5ab3
	ld e,$7f		; $5ab4
	ld a,$01		; $5ab6
	ld (de),a		; $5ab8
	ret			; $5ab9
	ld hl,$c6a2		; $5aba
	ld a,($cbe4)		; $5abd
	cp (hl)			; $5ac0
	ret nz			; $5ac1
	ld e,$7f		; $5ac2
	ld a,$01		; $5ac4
	ld (de),a		; $5ac6
	ret			; $5ac7
	ld b,$f8		; $5ac8
	ld c,$10		; $5aca
	ld a,$28		; $5acc
	jp objectCreateExclamationMark		; $5ace
	call getThisRoomFlags		; $5ad1
	res 5,(hl)		; $5ad4
	ret			; $5ad6
	ld hl,$d008		; $5ad7
	ld a,(hl)		; $5ada
	xor $02			; $5adb
	add $09			; $5add
	jp interactionSetAnimation		; $5adf
	ld b,a			; $5ae2
	ld c,$00		; $5ae3
	call checkIsLinkedGame		; $5ae5
	jr z,_label_15_221	; $5ae8
	ld c,$0a		; $5aea
_label_15_221:
	ld a,b			; $5aec
	add c			; $5aed
	ld h,d			; $5aee
	ld l,$72		; $5aef
	ldi (hl),a		; $5af1
	ld (hl),$0c		; $5af2
	ret			; $5af4
	jp loadAnimationData		; $5af5
	ld a,$41		; $5af8
	call checkTreasureObtained		; $5afa
	ld h,d			; $5afd
	ld l,$7f		; $5afe
	jr nc,_label_15_222	; $5b00
	cp $05			; $5b02
	jr c,_label_15_222	; $5b04
	ld (hl),$01		; $5b06
	ret			; $5b08
_label_15_222:
	ld (hl),$00		; $5b09
	ret			; $5b0b
	call getFreeInteractionSlot		; $5b0c
	ret nz			; $5b0f
	ld (hl),$84		; $5b10
	push de			; $5b12
	ld de,$d00b		; $5b13
	call objectCopyPosition_rawAddress		; $5b16
	pop de			; $5b19
	ret			; $5b1a
	ld a,$58		; $5b1b
	call loseTreasure		; $5b1d
	ld a,$49		; $5b20
	jp loseTreasure		; $5b22
	ld hl,$cfde		; $5b25
	ld bc,$627b		; $5b28
	jr _label_15_223		; $5b2b
	ld a,$0b		; $5b2d
	ld ($cc6a),a		; $5b2f
	ld hl,$d00b		; $5b32
	ld a,$68		; $5b35
	sub (hl)		; $5b37
	ld ($cc6c),a		; $5b38
	ld l,$08		; $5b3b
	ld (hl),$02		; $5b3d
	ld l,$09		; $5b3f
	ld (hl),$10		; $5b41
	ld hl,$cfde		; $5b43
	ld bc,$62c9		; $5b46
	call $5b52		; $5b49
	ld hl,$cfdc		; $5b4c
	ld bc,$62db		; $5b4f
_label_15_223:
	ldi a,(hl)		; $5b52
	ld l,(hl)		; $5b53
	ld h,a			; $5b54
	ld (hl),c		; $5b55
	inc l			; $5b56
	ld (hl),b		; $5b57
	ret			; $5b58
	ld c,$04		; $5b59
	jr _label_15_224		; $5b5b
	ld c,$05		; $5b5d
_label_15_224:
	ld b,$4c		; $5b5f
	jp objectCreateInteraction		; $5b61
	call getFreePartSlot		; $5b64
	ret nz			; $5b67
	ld (hl),$04		; $5b68
	ld l,$cb		; $5b6a
	ld (hl),$1c		; $5b6c
	ld l,$cd		; $5b6e
	ld (hl),$70		; $5b70
	ret			; $5b72
	ld a,$50		; $5b73
	call loseTreasure		; $5b75
	ld a,$51		; $5b78
	call loseTreasure		; $5b7a
	call getFreeInteractionSlot		; $5b7d
	ret nz			; $5b80
	ld (hl),$60		; $5b81
	inc l			; $5b83
	ld (hl),$52		; $5b84
	ld l,$4b		; $5b86
	ld (hl),$1c		; $5b88
	ld l,$4d		; $5b8a
	ld (hl),$70		; $5b8c
	ret			; $5b8e
	ld a,$e8		; $5b8f
	ld c,$06		; $5b91
	call setTile		; $5b93
	ld a,$e9		; $5b96
	ld c,$07		; $5b98
	call setTile		; $5b9a
	ld a,$ea		; $5b9d
	ld c,$16		; $5b9f
	call setTile		; $5ba1
	ld a,$eb		; $5ba4
	ld c,$17		; $5ba6
	call setTile		; $5ba8
	ld a,$70		; $5bab
	jp playSound		; $5bad
	ld a,$e4		; $5bb0
	ld c,$06		; $5bb2
	call setTile		; $5bb4
	ld a,$e5		; $5bb7
	ld c,$07		; $5bb9
	call setTile		; $5bbb
	ld a,$e6		; $5bbe
	ld c,$16		; $5bc0
	call setTile		; $5bc2
	ld a,$e7		; $5bc5
	ld c,$17		; $5bc7
	jp setTile		; $5bc9
	ld a,$01		; $5bcc
_label_15_225:
	ld ($ccab),a		; $5bce
	ld ($ccea),a		; $5bd1
	ret			; $5bd4
	xor a			; $5bd5
	jr _label_15_225		; $5bd6
	call refreshObjectGfx		; $5bd8
	ldh a,(<hActiveObject)	; $5bdb
	ld d,a			; $5bdd
	ld b,$54		; $5bde
	jp objectCreateInteractionWithSubid00		; $5be0
	ld h,d			; $5be3
	ld l,$50		; $5be4
	ld (hl),$28		; $5be6
	ld l,$54		; $5be8
	ld (hl),$00		; $5bea
	inc hl			; $5bec
	ld (hl),$fe		; $5bed
	ld a,$53		; $5bef
	jp playSound		; $5bf1
	ld c,$30		; $5bf4
	call objectUpdateSpeedZ_paramC		; $5bf6
	ret nz			; $5bf9
	ld h,d			; $5bfa
	ld l,$7d		; $5bfb
	ld (hl),$01		; $5bfd
	ret			; $5bff
	ld a,$1a		; $5c00
	call checkGlobalFlag		; $5c02
	ld a,$04		; $5c05
	jr z,_label_15_226	; $5c07
	ld a,$05		; $5c09
_label_15_226:
	ld e,$78		; $5c0b
	ld (de),a		; $5c0d
	call cpRupeeValue		; $5c0e
	ld e,$77		; $5c11
	ld (de),a		; $5c13
	ld a,$00		; $5c14
	ld ($cced),a		; $5c16
	xor a			; $5c19
	ld e,$71		; $5c1a
	ld (de),a		; $5c1c
	ld e,$44		; $5c1d
	ld a,$01		; $5c1f
	ld (de),a		; $5c21
	ret			; $5c22
	ld e,$78		; $5c23
	ld a,(de)		; $5c25
	jp removeRupeeValue		; $5c26
	ld e,$78		; $5c29
	ld a,(de)		; $5c2b
	call getRupeeValue		; $5c2c
	ld hl,$cba8		; $5c2f
	ld (hl),c		; $5c32
	inc hl			; $5c33
	ld (hl),b		; $5c34
	ret			; $5c35
	ld c,$07		; $5c36
	ld a,$28		; $5c38
	jp giveTreasure		; $5c3a
	call clearPegasusSeedCounter		; $5c3d
	call clearAllParentItems		; $5c40
	call dropLinkHeldItem		; $5c43
	jp clearItems		; $5c46
	call setLinkForceStateToState08		; $5c49
	ld hl,$d008		; $5c4c
	ld (hl),$03		; $5c4f
	ld l,$0b		; $5c51
	ld (hl),$40		; $5c53
	ld l,$0d		; $5c55
	ld (hl),$60		; $5c57
	xor a			; $5c59
	ld l,$0f		; $5c5a
	ld (hl),a		; $5c5c
	ld ($cc77),a		; $5c5d
	ret			; $5c60
	ld e,$79		; $5c61
	ld a,(de)		; $5c63
	ld h,a			; $5c64
	ld l,$44		; $5c65
	ld (hl),$02		; $5c67
	call getFreeEnemySlot		; $5c69
	ret nz			; $5c6c
	ld (hl),$54		; $5c6d
	ld l,$8b		; $5c6f
	ld (hl),$40		; $5c71
	ld l,$8d		; $5c73
	ld (hl),$40		; $5c75
	ld e,$56		; $5c77
	ld a,$80		; $5c79
	ld (de),a		; $5c7b
	inc e			; $5c7c
	ld a,h			; $5c7d
	ld (de),a		; $5c7e
	ret			; $5c7f
	push de			; $5c80
	call clearEnemies		; $5c81
	pop de			; $5c84
	ld bc,$4040		; $5c85
	call $5c9e		; $5c88
	ret nz			; $5c8b
	ld l,$4b		; $5c8c
	ld b,(hl)		; $5c8e
	ld l,$4d		; $5c8f
	ld c,(hl)		; $5c91
	ld e,$4b		; $5c92
	ld a,b			; $5c94
	ld (de),a		; $5c95
	ld e,$4d		; $5c96
	ld a,c			; $5c98
	ld (de),a		; $5c99
	ret			; $5c9a
	ld bc,$4050		; $5c9b
	call getFreeInteractionSlot		; $5c9e
	ret nz			; $5ca1
	ld (hl),$72		; $5ca2
	ld l,$4b		; $5ca4
	ld (hl),b		; $5ca6
	ld l,$4d		; $5ca7
	ld (hl),c		; $5ca9
	ld e,$79		; $5caa
	ld a,h			; $5cac
	ld (de),a		; $5cad
	xor a			; $5cae
	ret			; $5caf
	ldh (<hFF8B),a	; $5cb0
	ld a,$ff		; $5cb2
	ld ($cbea),a		; $5cb4
	ld hl,$c680		; $5cb7
	ld e,$df		; $5cba
	ldh a,(<hFF8B)	; $5cbc
	and $0f			; $5cbe
	call $5cdc		; $5cc0
	call $5cdf		; $5cc3
	ld l,$81		; $5cc6
	ldh a,(<hFF8B)	; $5cc8
	swap a			; $5cca
	and $0f			; $5ccc
	ld e,$de		; $5cce
	call $5cdc		; $5cd0
	ld a,b			; $5cd3
	cp $0c			; $5cd4
	call nz,$5cdf		; $5cd6
	jp disableActiveRing		; $5cd9
	ld b,(hl)		; $5cdc
	ld (hl),a		; $5cdd
	ret			; $5cde
	push de			; $5cdf
	ld d,$cf		; $5ce0
	ld l,$82		; $5ce2
_label_15_227:
	ld a,(hl)		; $5ce4
	or a			; $5ce5
	jr z,_label_15_228	; $5ce6
	inc l			; $5ce8
	jr _label_15_227		; $5ce9
_label_15_228:
	ld (hl),b		; $5ceb
	ld a,l			; $5cec
	ld (de),a		; $5ced
	pop de			; $5cee
	ret			; $5cef
	ld a,($ccec)		; $5cf0
	cp $03			; $5cf3
	jr z,_label_15_229	; $5cf5
	push de			; $5cf7
	ld a,$ff		; $5cf8
	ld ($cbea),a		; $5cfa
	ld h,$c6		; $5cfd
	ld de,$cfdf		; $5cff
	ld c,$80		; $5d02
	call $5d12		; $5d04
	ld e,$de		; $5d07
	ld c,$81		; $5d09
	call $5d12		; $5d0b
	pop de			; $5d0e
_label_15_229:
	jp enableActiveRing		; $5d0f
	ld a,(de)		; $5d12
	or a			; $5d13
	ret z			; $5d14
	ld l,a			; $5d15
	ld a,(hl)		; $5d16
	ld (hl),$00		; $5d17
	ld l,c			; $5d19
	ldi (hl),a		; $5d1a
	cp $0c			; $5d1b
	ret nz			; $5d1d
	ld (hl),a		; $5d1e
	ret			; $5d1f
	ld a,$01		; $5d20
	ld ($cfd2),a		; $5d22
	ld a,$04		; $5d25
	jr _label_15_230		; $5d27
	ld a,$ff		; $5d29
	ld ($cfd2),a		; $5d2b
	ld a,$04		; $5d2e
	jr _label_15_230		; $5d30
	ld a,$05		; $5d32
	jr _label_15_230		; $5d34
	ld a,$03		; $5d36
_label_15_230:
	ld ($cfd4),a		; $5d38
	ld a,$09		; $5d3b
	ld ($cfd1),a		; $5d3d
	ld hl,$cfda		; $5d40
	inc (hl)		; $5d43
	ret			; $5d44
	ld e,$54		; $5d45
	ld a,$80		; $5d47
	ld (de),a		; $5d49
	ld a,$fe		; $5d4a
	inc e			; $5d4c
	ld (de),a		; $5d4d
	ld e,$4e		; $5d4e
	ld a,$01		; $5d50
	ld (de),a		; $5d52
	ret			; $5d53
	call getThisRoomFlags		; $5d54
	bit 7,(hl)		; $5d57
	ld a,$03		; $5d59
	jr nz,_label_15_231	; $5d5b
	ld hl,$c781		; $5d5d
	bit 7,(hl)		; $5d60
	ld a,$02		; $5d62
	jr nz,_label_15_231	; $5d64
	call getThisRoomFlags		; $5d66
	bit 5,(hl)		; $5d69
	ld a,$01		; $5d6b
	jr nz,_label_15_231	; $5d6d
	dec a			; $5d6f
_label_15_231:
	ld ($cfc1),a		; $5d70
	ret			; $5d73
	ld a,$0e		; $5d74
	ld ($cc6a),a		; $5d76
	ld a,$01		; $5d79
	ld ($cc02),a		; $5d7b
	ld ($cca5),a		; $5d7e
	ld a,$ff		; $5d81
	ld ($cca4),a		; $5d83
	jp interactionSetAlwaysUpdateBit		; $5d86
	ld a,$11		; $5d89
	ld ($ccab),a		; $5d8b
	ld ($cca4),a		; $5d8e
	ret			; $5d91
	xor a			; $5d92
	ld ($ccab),a		; $5d93
	ld ($cc32),a		; $5d96
	ret			; $5d99
	ld h,$d7		; $5d9a
_label_15_232:
	ld l,$01		; $5d9c
	ld a,(hl)		; $5d9e
	sub $03			; $5d9f
	jr nz,_label_15_233	; $5da1
	ld l,$1a		; $5da3
	ld (hl),a		; $5da5
	ld l,$2f		; $5da6
	set 5,(hl)		; $5da8
_label_15_233:
	inc h			; $5daa
	ld a,h			; $5dab
	cp $dc			; $5dac
	jr c,_label_15_232	; $5dae
	ret			; $5db0
	ld a,$02		; $5db1
	ld ($cc9e),a		; $5db3
	ret			; $5db6
	ld hl,$c7cb		; $5db7
	set 7,(hl)		; $5dba
	xor a			; $5dbc
	ld ($cc9e),a		; $5dbd
	ld ($cc9f),a		; $5dc0
	ret			; $5dc3
	ld a,$1e		; $5dc4
	call addToGashaMaturity		; $5dc6
	ld hl,$c6e3		; $5dc9
	call incHlRefWithCap		; $5dcc
	call getThisRoomFlags		; $5dcf
	bit 5,(hl)		; $5dd2
	jr nz,_label_15_234	; $5dd4
	ld bc,loseTreasure		; $5dd6
	jr _label_15_237		; $5dd9
_label_15_234:
	ld a,($c6e3)		; $5ddb
	cp $08			; $5dde
	jr z,_label_15_236	; $5de0
	call getRandomNumber		; $5de2
	cp $60			; $5de5
	jr nc,_label_15_239	; $5de7
_label_15_235:
	ld bc,$3402		; $5de9
	jr _label_15_237		; $5dec
_label_15_236:
	call $5e20		; $5dee
	jr c,_label_15_235	; $5df1
	ld c,$03		; $5df3
	call createRingTreasure		; $5df5
	call $5e0a		; $5df8
	ld a,$14		; $5dfb
	jp setGlobalFlag		; $5dfd
_label_15_237:
	call getFreeInteractionSlot		; $5e00
	ret nz			; $5e03
	ld (hl),$60		; $5e04
	inc l			; $5e06
	ld (hl),b		; $5e07
	inc l			; $5e08
	ld (hl),c		; $5e09
_label_15_238:
	ld l,$4b		; $5e0a
	ld (hl),$48		; $5e0c
	inc l			; $5e0e
	inc l			; $5e0f
	ld (hl),$28		; $5e10
	ret			; $5e12
_label_15_239:
	call getFreeInteractionSlot		; $5e13
	ret nz			; $5e16
	ld (hl),$6b		; $5e17
	inc l			; $5e19
	ld (hl),$09		; $5e1a
	inc l			; $5e1c
	inc (hl)		; $5e1d
	jr _label_15_238		; $5e1e
	call getRandomNumber		; $5e20
	and $03			; $5e23
	ld c,a			; $5e25
	ld b,$04		; $5e26
_label_15_240:
	push bc			; $5e28
	ld a,c			; $5e29
	ld bc,$5e4a		; $5e2a
	call addAToBc		; $5e2d
	ld a,(bc)		; $5e30
	ld hl,$c616		; $5e31
	call checkFlag		; $5e34
	jr z,_label_15_241	; $5e37
	pop bc			; $5e39
	ld a,c			; $5e3a
	inc a			; $5e3b
	and $03			; $5e3c
	ld c,a			; $5e3e
	dec b			; $5e3f
	jr nz,_label_15_240	; $5e40
	ld b,$80		; $5e42
	scf			; $5e44
	ret			; $5e45
_label_15_241:
	ld a,(bc)		; $5e46
	pop bc			; $5e47
	ld b,a			; $5e48
	ret			; $5e49
	ld a,$3d		; $5e4a
	rra			; $5e4c
	ld a,(de)		; $5e4d

seasonsFunc_15_5e4e:
	call getFreePartSlot		; $5e4e
	ret nz			; $5e51
	ld (hl),$0e		; $5e52
	ld l,$d6		; $5e54
	ld a,$40		; $5e56
	ldi (hl),a		; $5e58
	ld (hl),d		; $5e59
	jp objectCopyPosition		; $5e5a

	call getFreeInteractionSlot		; $5e5d
	ret nz			; $5e60
	ld (hl),$6e		; $5e61
	ld l,$4b		; $5e63
	ld a,($d00b)		; $5e65
	ldi (hl),a		; $5e68
	inc l			; $5e69
	ld a,($d00d)		; $5e6a
	ld (hl),a		; $5e6d
	ret			; $5e6e

	call setLinkForceStateToState08		; $5e6f
	jp putLinkOnGround		; $5e72
	ld bc,$30a8		; $5e75
	ld e,$10		; $5e78
	call $5e82		; $5e7a
	ld bc,$34b8		; $5e7d
	ld e,$11		; $5e80
	call getFreeInteractionSlot		; $5e82
	ret nz			; $5e85
	ld (hl),$30		; $5e86
	inc l			; $5e88
	ld (hl),e		; $5e89
	ld l,$4b		; $5e8a
	ld (hl),b		; $5e8c
	ld l,$4d		; $5e8d
	ld (hl),c		; $5e8f
	ret			; $5e90
	ld hl,$d114		; $5e91
	ld (hl),$c0		; $5e94
	inc l			; $5e96
	ld (hl),$fe		; $5e97
	ld l,$3f		; $5e99
	ld (hl),$0b		; $5e9b
	ld l,$03		; $5e9d
	ld (hl),$03		; $5e9f
	ld l,$1c		; $5ea1
	ld (hl),$09		; $5ea3
	ret			; $5ea5
	ld hl,$d103		; $5ea6
	ld (hl),$04		; $5ea9
	ld l,$1a		; $5eab
	ld (hl),$c0		; $5ead
	ld l,$3f		; $5eaf
	ld (hl),$19		; $5eb1
	ret			; $5eb3
	ld a,$18		; $5eb4
	ld ($cc47),a		; $5eb6
	ld hl,$d009		; $5eb9
	ld (hl),a		; $5ebc
	ld l,$10		; $5ebd
	ld (hl),$32		; $5ebf
	ld a,$1d		; $5ec1
	ld ($d13f),a		; $5ec3
	ret			; $5ec6
	ld a,$02		; $5ec7
	ld ($d008),a		; $5ec9
	ld hl,$d108		; $5ecc
	ld (hl),$02		; $5ecf
	inc l			; $5ed1
	ld (hl),$10		; $5ed2
	ld l,$03		; $5ed4
	ld (hl),$06		; $5ed6
	ld a,$03		; $5ed8
	ld ($d13f),a		; $5eda
	ret			; $5edd
	ld a,($c610)		; $5ede
	cp $0d			; $5ee1
	ld a,$01		; $5ee3
	jr z,_label_15_242	; $5ee5
	xor a			; $5ee7
_label_15_242:
	ld e,$7b		; $5ee8
	ld (de),a		; $5eea
	ret			; $5eeb

seasonsFunc_15_5eec:
	call objectGetAngleTowardLink		; $5eec
	ld e,$49		; $5eef
	ld (de),a		; $5ef1
	call convertAngleDeToDirection		; $5ef2
	ld e,$48		; $5ef5
	ld (de),a		; $5ef7
	jp interactionSetAnimation		; $5ef8
	ld a,$09		; $5efb
	ld ($cc6a),a		; $5efd
	ld hl,$d00b		; $5f00
	call objectCopyPosition		; $5f03
	ld a,($d00b)		; $5f06
	swap a			; $5f09
	and $0f			; $5f0b
	ldh (<hFF8D),a	; $5f0d
	ld a,($d00d)		; $5f0f
	swap a			; $5f12
	and $0f			; $5f14
	xor $0f			; $5f16
	ldh (<hFF8C),a	; $5f18
	ld a,($cc49)		; $5f1a
	ld hl,seasonsTable_15_5f6f		; $5f1d
	cp $04			; $5f20
	jr z,_label_15_243	; $5f22
	ld hl,seasonsTable_5f85		; $5f24
_label_15_243:
	ld a,($cc4c)		; $5f27
	ld e,a			; $5f2a
_label_15_244:
	ldi a,(hl)		; $5f2b
	or a			; $5f2c
	jr z,_label_15_248	; $5f2d
	cp e			; $5f2f
	jr z,_label_15_245	; $5f30
	inc hl			; $5f32
	inc hl			; $5f33
	jr _label_15_244		; $5f34
_label_15_245:
	ldi a,(hl)		; $5f36
	ld h,(hl)		; $5f37
	ld l,a			; $5f38
	push hl			; $5f39
	ldh a,(<hFF8D)	; $5f3a
	rst_addDoubleIndex			; $5f3c
	ldh a,(<hFF8C)	; $5f3d
	call checkFlag		; $5f3f
	ld c,$01		; $5f42
	jr nz,_label_15_246	; $5f44
	ld c,$00		; $5f46
	ld e,$42		; $5f48
	ld a,(de)		; $5f4a
	or a			; $5f4b
	jr z,_label_15_246	; $5f4c
	pop hl			; $5f4e
	ld bc,$0016		; $5f4f
	add hl,bc		; $5f52
	ldh a,(<hFF8D)	; $5f53
	rst_addDoubleIndex			; $5f55
	ldh a,(<hFF8C)	; $5f56
	call checkFlag		; $5f58
	ld c,$80		; $5f5b
	jr z,_label_15_247	; $5f5d
	ld c,$82		; $5f5f
	jr _label_15_247		; $5f61
_label_15_246:
	pop hl			; $5f63
_label_15_247:
	ld a,c			; $5f64
	ld ($cc6b),a		; $5f65
	ret			; $5f68
_label_15_248:
	ld a,$03		; $5f69
	ld ($cc6b),a		; $5f6b
	ret			; $5f6e

seasonsTable_15_5f6f:
	.db $3e $98 $5f $3f $ae $5f $43 $c4
	.db $5f $b4 $da $5f $c1 $f0 $5f $c2
	.db $06 $60 $d3 $1c $60 $00

seasonsTable_5f85:
	scf			; $5f85
	ldd (hl),a		; $5f86
	ld h,b			; $5f87
	jr c,$48		; $5f88
	ld h,b			; $5f8a
	ldd a,(hl)		; $5f8b
	ld (hl),h		; $5f8c
	ld h,b			; $5f8d
	ld b,l			; $5f8e
	and b			; $5f8f
	ld h,b			; $5f90
	ld c,c			; $5f91
	or (hl)			; $5f92
	ld h,b			; $5f93
	ld c,l			; $5f94
	call z,$0060		; $5f95
	rst $38			; $5f98
	rst $38			; $5f99
	rst $38			; $5f9a
	rst $38			; $5f9b
	rst $38			; $5f9c
	rst $38			; $5f9d
	rst $38			; $5f9e
	ei			; $5f9f
	rst $38			; $5fa0
	rst $38			; $5fa1
	rst $38			; $5fa2
	rst $38			; $5fa3
	rst $38			; $5fa4
	rst $38			; $5fa5
	cp a			; $5fa6
	rst $38			; $5fa7
	rst $38			; $5fa8
	rst $38			; $5fa9
	rst $38			; $5faa
	rst $38			; $5fab
	rst $38			; $5fac
	rst $38			; $5fad
	rst $38			; $5fae
	rst $38			; $5faf
	rst $38			; $5fb0
	rst $38			; $5fb1
	rst $38			; $5fb2
	rst $38			; $5fb3
	rst $38			; $5fb4
	rst $38			; $5fb5
	rst $38			; $5fb6
	rst $38			; $5fb7
	rst $30			; $5fb8
	rst $38			; $5fb9
	rst $38			; $5fba
	rst $38			; $5fbb
	rst $38			; $5fbc
	rst $38			; $5fbd
	rst $38			; $5fbe
	rst $38			; $5fbf
	rst $38			; $5fc0
	rst $38			; $5fc1
	rst $38			; $5fc2
	rst $38			; $5fc3
	rst $38			; $5fc4
	rst $38			; $5fc5
	rst $38			; $5fc6
	rst $38			; $5fc7
	rst $38			; $5fc8
	rst $38			; $5fc9
	rrca			; $5fca
	ld ($ff00+$ef),a	; $5fcb
	xor $ef			; $5fcd
	xor $0f			; $5fcf
	ld ($ff00+$ff),a	; $5fd1
	rst $38			; $5fd3
	rst $38			; $5fd4
	rst $38			; $5fd5
	rst $38			; $5fd6
	rst $38			; $5fd7
	rst $38			; $5fd8
	rst $38			; $5fd9
	rst $38			; $5fda
	rst $38			; $5fdb
	rst $38			; $5fdc
	sbc a			; $5fdd
	rst $38			; $5fde
	cp a			; $5fdf
	rst $38			; $5fe0
	rst $38			; $5fe1
	rst $38			; $5fe2
	rst $38			; $5fe3
	rst $38			; $5fe4
	rst $38			; $5fe5
	rst $38			; $5fe6
	rst $38			; $5fe7
	rst $38			; $5fe8
	rst $38			; $5fe9
	rst $38			; $5fea
	rst $38			; $5feb
	rst $38			; $5fec
	rst $38			; $5fed
	rst $38			; $5fee
	rst $38			; $5fef
	rst $38			; $5ff0
	rst $38			; $5ff1
.DB $e3				; $5ff2
	rst $38			; $5ff3
.DB $e3				; $5ff4
	rst $38			; $5ff5
	rst $38			; $5ff6
	rst $38			; $5ff7
	rst $38			; $5ff8
	rst $38			; $5ff9
	rst $38			; $5ffa
	rst $38			; $5ffb
	rst $38			; $5ffc
	rst $38			; $5ffd
	rst $38			; $5ffe
	rst $38			; $5fff
	rst $38			; $6000
	rst $38			; $6001
	rst $38			; $6002
	rst $38			; $6003
	rst $38			; $6004
	rst $38			; $6005
	rst $38			; $6006
	rst $38			; $6007
	rst $38			; $6008
	rst $38			; $6009
	rst $38			; $600a
	rst $38			; $600b
	rst $38			; $600c
	rst $38			; $600d
	rst $38			; $600e
	rst $38			; $600f
	rst $38			; $6010
	rst $38			; $6011
	rst $38			; $6012
	rst $38			; $6013
	rst $38			; $6014
	rst $38			; $6015
	rst $8			; $6016
	sbc a			; $6017
	rst $8			; $6018
	sbc a			; $6019
	rst $38			; $601a
	rst $38			; $601b
	rst $38			; $601c
	rst $38			; $601d
	rst $38			; $601e
	rst $38			; $601f
	rst $38			; $6020
	rst $38			; $6021
	rst $38			; $6022
	rst $38			; $6023
	rst $38			; $6024
	rst $38			; $6025
	rst $38			; $6026
	rst $38			; $6027
	rst $38			; $6028
	rst $38			; $6029
	rst $38			; $602a
	rst $38			; $602b
	rst $38			; $602c
	rst $38			; $602d
	ld h,a			; $602e
.DB $fc				; $602f
	rst $38			; $6030
	rst $38			; $6031
	rst $38			; $6032
	rst $38			; $6033
	di			; $6034
	rst $38			; $6035
	di			; $6036
	rst $38			; $6037
	di			; $6038
	rst $38			; $6039
	di			; $603a
	rst $38			; $603b
	di			; $603c
	rst $38			; $603d
	rst $38			; $603e
	rst $38			; $603f
	di			; $6040
	rst $38			; $6041
	di			; $6042
	rst $38			; $6043
	di			; $6044
	rst $38			; $6045
	rst $38			; $6046
	rst $38			; $6047
	rst $38			; $6048
	rst $38			; $6049
	rra			; $604a
	rst $38			; $604b
	rst $38			; $604c
	rst $38			; $604d
	rst $38			; $604e
	rst $38			; $604f
	rst $38			; $6050
	rst $38			; $6051
	rst $38			; $6052
	add a			; $6053
	rst $38			; $6054
	add a			; $6055
	rst $38			; $6056
	rst $38			; $6057
	rst $38			; $6058
	rst $38			; $6059
	rst $38			; $605a
	rst $38			; $605b
	rst $38			; $605c
	rst $38			; $605d
	rst $38			; $605e
	rst $38			; $605f
	rst $38			; $6060
	rst $38			; $6061
	rst $38			; $6062
	rst $38			; $6063
	rst $38			; $6064
	rst $38			; $6065
	rst $38			; $6066
	rst $38			; $6067
	rst $38			; $6068
	add a			; $6069
	rst $38			; $606a
	add a			; $606b
	rst $38			; $606c
	rst $38			; $606d
	rst $38			; $606e
	rst $38			; $606f
	rst $38			; $6070
	rst $38			; $6071
	rst $38			; $6072
	rst $38			; $6073
	rst $38			; $6074
	rst $38			; $6075
	rst $38			; $6076
	rst $38			; $6077
	rra			; $6078
	ld a,($ff00+$1f)	; $6079
	ld a,($ff00+$1f)	; $607b
	ld a,($ff00+$1f)	; $607d
	ld a,($ff00+$1f)	; $607f
	ld a,($ff00+$1f)	; $6081
	ld a,($ff00+$1f)	; $6083
	ld a,($ff00+$ff)	; $6085
	rst $38			; $6087
	rst $38			; $6088
	rst $38			; $6089
	rst $38			; $608a
	rst $38			; $608b
	rst $38			; $608c
	rst $38			; $608d
	rra			; $608e
	ld a,($ff00+$1f)	; $608f
	ld a,($ff00+$1f)	; $6091
	ld a,($ff00+$1f)	; $6093
	ld a,($ff00+$1f)	; $6095
	ld a,($ff00+$1f)	; $6097
	ld a,($ff00+$1f)	; $6099
	ld a,($ff00+$ff)	; $609b
	rst $38			; $609d
	rst $38			; $609e
	rst $38			; $609f
	rst $38			; $60a0
	rst $38			; $60a1
	rst $38			; $60a2
	rst $38			; $60a3
	rst $38			; $60a4
	rst $30			; $60a5
	rst $38			; $60a6
	rst $38			; $60a7
	rst $38			; $60a8
	add c			; $60a9
	rst $38			; $60aa
	sub c			; $60ab
	rst $38			; $60ac
	add c			; $60ad
	rst $38			; $60ae
	add c			; $60af
	rst $38			; $60b0
	add c			; $60b1
	rst $38			; $60b2
	add c			; $60b3
	rst $38			; $60b4
	rst $38			; $60b5
	rst $38			; $60b6
	rst $38			; $60b7
	rst $38			; $60b8
	adc a			; $60b9
	rst $38			; $60ba
	rst $38			; $60bb
	rst $38			; $60bc
	rst $38			; $60bd
	rst $38			; $60be
	rst $38			; $60bf
	rst $38			; $60c0
	rst $38			; $60c1
	rst $38			; $60c2
	rst $38			; $60c3
	rst $38			; $60c4
	rst $38			; $60c5
	rst $38			; $60c6
	rst $38			; $60c7
	rst $38			; $60c8
	rst $38			; $60c9
	rst $38			; $60ca
	rst $38			; $60cb
	rst $38			; $60cc
	rst $38			; $60cd
	rst $38			; $60ce
	rst $38			; $60cf
	rst $38			; $60d0
	rst $38			; $60d1
	rst $38			; $60d2
	rst $38			; $60d3
	ld a,a			; $60d4
.DB $f4				; $60d5
	ld a,a			; $60d6
.DB $fc				; $60d7
	ld a,a			; $60d8
.DB $fc				; $60d9
	rst $38			; $60da
	rst $38			; $60db
	rst $38			; $60dc
	rst $38			; $60dd
	rst $38			; $60de
	rst $38			; $60df
	rst $38			; $60e0
	rst $38			; $60e1

seasonsFunc_15_60e2:
	ld hl,$c6e5		; $60e2
	ld (hl),a		; $60e5
	ret			; $60e6

seasonsFunc_15_60e7:
	ld c,a			; $60e7
	jr _label_15_249		; $60e8

seasonsFunc_15_60ea:
	call $60fc		; $60ea
	jr _label_15_249		; $60ed

seasonsFunc_15_60ef:
	call $6104		; $60ef
	jr _label_15_249		; $60f2

seasonsFunc_15_60f4:
	call $610c		; $60f4
_label_15_249:
	ld b,$17		; $60f7
	jp showText		; $60f9

seasonsFunc_15_60fc:
	ld a,(ws_cc39)		; $60fc
	ld hl,seasonsTable_15_6116		; $60ff
	rst_addAToHl			; $6102
	ld a,(hl)		; $6103
	call seasonsFunc_15_610c		; $6104
	ld hl,wMakuMapTextPresent		; $6107
	ld (hl),c		; $610a
	ret			; $610b

seasonsFunc_15_610c:
	ld c,a			; $610c
	call checkIsLinkedGame		; $610d
	ret z			; $6110
	ld a,c			; $6111
	add $1b			; $6112
	ld c,a			; $6114
	ret			; $6115

seasonsTable_15_6116:
	inc bc			; $6116
	dec b			; $6117
	ld ($0c0a),sp		; $6118
	ld de,$1513		; $611b
	rla			; $611e
	ld b,$0e		; $611f
	.db $11		; $6121
	.db $18		; $6122

seasonsFunc_15_6123:
	.db $fe		; $6123
	nop			; $6124
	jr nz,_label_15_250	; $6125
	call $615f		; $6127
	ld a,$00		; $612a
_label_15_250:
	ld e,$77		; $612c
	ld (de),a		; $612e
	jp interactionSetAnimation		; $612f

seasonsFunc_15_6132:
	call getFreeInteractionSlot		; $6132
	ret nz			; $6135
	ld (hl),$60		; $6136
	inc l			; $6138
	ld (hl),$42		; $6139
	inc l			; $613b
	ld (hl),$00		; $613c
	ld l,$4b		; $613e
	ld (hl),$60		; $6140
	ld a,($d00d)		; $6142
	ld b,$50		; $6145
	cp $64			; $6147
	jr nc,_label_15_251	; $6149
	cp $3c			; $614b
	jr c,_label_15_251	; $614d
	ld b,$40		; $614f
	cp $50			; $6151
	jr nc,_label_15_251	; $6153
	ld b,$60		; $6155
_label_15_251:
	ld l,$4d		; $6157
	ld (hl),b		; $6159
	ld a,b			; $615a
	ld ($c6e0),a		; $615b
	ret			; $615e
	call getFreeEnemySlot		; $615f
	ret nz			; $6162
	ld (hl),$56		; $6163
	inc l			; $6165
	ld e,$42		; $6166
	ld a,(de)		; $6168
	ld (hl),a		; $6169
	ld l,$98		; $616a
	ld a,$40		; $616c
	ldi (hl),a		; $616e
	ld (hl),d		; $616f
	ld e,$56		; $6170
	ld a,$80		; $6172
	ld (de),a		; $6174
	inc e			; $6175
	ld a,h			; $6176
	ld (de),a		; $6177
	ld hl,$cfc0		; $6178
	res 7,(hl)		; $617b
	ret			; $617d

seasonsFunc_15_617e:
	ld bc,$9301		; $617e
	jp objectCreateInteraction		; $6181

seasonsFunc_15_6184:
	ld a,$0e		; $6184
	ld ($cc04),a		; $6186
	ld a,$19		; $6189
	jp setGlobalFlag		; $618b

seasonsFunc_15_618e:
	call checkIsLinkedGame		; $618e
	ret nz			; $6191
	xor a			; $6192
	ld ($cc02),a		; $6193
	ld ($cca4),a		; $6196
	ret			; $6199

seasonsFunc_15_619a:
	ld a,($cc66)		; $619a
	or a			; $619d
	ret nz			; $619e
	call setLinkForceStateToState08		; $619f
	ld hl,$d008		; $61a2
	ld (hl),$00		; $61a5
	ld l,$0b		; $61a7
	ld (hl),$68		; $61a9
	ld l,$0d		; $61ab
	ld (hl),$50		; $61ad
	ld l,$0f		; $61af
	ld (hl),$00		; $61b1
	ret			; $61b3
	ld bc,$61ca		; $61b4
	call addDoubleIndexToBc		; $61b7
	call getFreeInteractionSlot		; $61ba
	ret nz			; $61bd
	ld (hl),$05		; $61be
	ld l,$4b		; $61c0
	ld a,(bc)		; $61c2
	ld (hl),a		; $61c3
	inc bc			; $61c4
	ld l,$4d		; $61c5
	ld a,(bc)		; $61c7
	ld (hl),a		; $61c8
	ret			; $61c9
	ld h,$26		; $61ca
	ld h,$30		; $61cc
	ld h,$3a		; $61ce
	jr nc,$26		; $61d0
	jr nc,$30		; $61d2
	jr nc,$3a		; $61d4
	ldd a,(hl)		; $61d6
	ld h,$3a		; $61d7
	jr nc,$3a		; $61d9
	ldd a,(hl)		; $61db
	call getFreeEnemySlot		; $61dc
	ret nz			; $61df
	ld (hl),$4f		; $61e0
	ld l,$8b		; $61e2
	ld (hl),$30		; $61e4
	ld l,$8d		; $61e6
	ld (hl),$30		; $61e8
	ret			; $61ea
	ld a,$01		; $61eb
	call interactionSetAnimation		; $61ed
	ld h,d			; $61f0
	ld l,$4b		; $61f1
	ld (hl),$30		; $61f3
	inc l			; $61f5
	inc l			; $61f6
	ld (hl),$78		; $61f7
	ret			; $61f9

seasonsFunc_15_61fa:
	call getFreeEnemySlot		; $61fa
	ret nz			; $61fd
	ld (hl),$20		; $61fe
	inc l			; $6200
	ld (hl),$01		; $6201
	jp objectCopyPosition		; $6203

seasonsFunc_15_6206:
	call getFreeEnemySlot		; $6206
	ret nz			; $6209
	ld (hl),$4a		; $620a
	jp objectCopyPosition		; $620c

seasonsFunc_15_620f:
	ld hl,$c6a5		; $620f
	ldi a,(hl)		; $6212
	or (hl)			; $6213
	ld e,$7f		; $6214
	ld (de),a		; $6216
	ret z			; $6217
	ld a,$01		; $6218
	ld (de),a		; $621a
	ld e,$42		; $621b
	ld a,(de)		; $621d
	ld hl,$6233		; $621e
	rst_addAToHl			; $6221
	ld a,(hl)		; $6222
	jp removeRupeeValue		; $6223

seasonsFunc_15_6226:
	ld e,$42		; $6226
	ld a,(de)		; $6228
	ld hl,$6233		; $6229
	rst_addAToHl			; $622c
	ld c,(hl)		; $622d
	ld a,$28		; $622e
	jp giveTreasure		; $6230
	stop			; $6233
	dec c			; $6234
	inc c			; $6235
	stop			; $6236
	inc c			; $6237
	dec c			; $6238
	dec bc			; $6239
	inc c			; $623a

seasonsFunc_15_623b:
	ld a,$40		; $623b
	call checkTreasureObtained		; $623d
	and $08			; $6240
	ld b,$00		; $6242
	jr nz,_label_15_252	; $6244
	inc b			; $6246
_label_15_252:
	ld hl,$cfc0		; $6247
	ld (hl),b		; $624a
	ret			; $624b

seasonsFunc_15_624c:
	call $624f		; $624c

seasonsFunc_15_624f:
	ld h,d			; $624f
	ld l,$7e		; $6250
	ld a,(hl)		; $6252
	inc (hl)		; $6253
	ld bc,$626a		; $6254
	call addDoubleIndexToBc		; $6257
	call getFreeInteractionSlot		; $625a
	ret nz			; $625d
	ld (hl),$05		; $625e
	ld l,$4b		; $6260
	ld a,(bc)		; $6262
	ld (hl),a		; $6263
	inc bc			; $6264
	ld l,$4d		; $6265
	ld a,(bc)		; $6267
	ld (hl),a		; $6268
	ret			; $6269
	ld e,$2e		; $626a
	ld e,$42		; $626c
	ld h,$38		; $626e
	ld d,$2e		; $6270
	ld d,$42		; $6272
	ld c,$38		; $6274
	ld a,(de)		; $6276
	jr c,$1e		; $6277
	ld a,$1e		; $6279
	ld d,d			; $627b
	ld h,$48		; $627c
	ld d,$3e		; $627e
	ld d,$52		; $6280
	ld c,$48		; $6282
	ld a,(de)		; $6284
	ld c,b			; $6285
	ld e,$4e		; $6286
	ld e,$62		; $6288
	ld h,$58		; $628a
	ld d,$4e		; $628c
	ld d,$62		; $628e
	ld c,$58		; $6290
	ld a,(de)		; $6292
	ld e,b			; $6293
	ld e,$5e		; $6294
	ld e,$72		; $6296
	ld h,$68		; $6298
	ld d,$5e		; $629a
	ld d,$72		; $629c
	ld c,$68		; $629e
	ld a,(de)		; $62a0
	ld l,b			; $62a1

seasonsFunc_15_62a2:
	ld a,$52		; $62a2
	call loseTreasure		; $62a4

seasonsFunc_15_62a7:
	ld a,$01		; $62a7
	call checkTreasureObtained		; $62a9
	jr c,_label_15_253	; $62ac
	xor a			; $62ae
_label_15_253:
	cp $03			; $62af
	jr c,_label_15_254	; $62b1
	ld a,$02		; $62b3
_label_15_254:
	ld c,a			; $62b5
	call getFreeInteractionSlot		; $62b6
	ret nz			; $62b9
	ld (hl),$60		; $62ba
	inc l			; $62bc
	ld (hl),$01		; $62bd
	inc l			; $62bf
	ld (hl),c		; $62c0
	push de			; $62c1
	ld de,$d00b		; $62c2
	call objectCopyPosition_rawAddress		; $62c5
	pop de			; $62c8
	ret			; $62c9

seasonsFunc_15_62ca:
	call objectGetAngleTowardLink		; $62ca
	call convertAngleToDirection		; $62cd
	jp interactionSetAnimation		; $62d0
	ld bc,$f300		; $62d3
	jp objectCreateExclamationMark		; $62d6

seasonsFunc_15_62d9:
	ld b,$f8		; $62d9
	ld c,$f0		; $62db
	ld a,$40		; $62dd
	jp objectCreateExclamationMark		; $62df

seasonsFunc_15_62e2:
	ld a,$16		; $62e2
	call setGlobalFlag		; $62e4
	ld a,$2f		; $62e7
	call setGlobalFlag		; $62e9
	ld hl,$62f7		; $62ec
	call setWarpDestVariables		; $62ef
	ld a,$bc		; $62f2
	jp playSound		; $62f4
	add b			; $62f7
	ld e,e			; $62f8
	nop			; $62f9
	inc d			; $62fa
	add e			; $62fb

seasonsFunc_15_62fc:
	ld a,$00		; $62fc
	ld ($d008),a		; $62fe
	jp setLinkForceStateToState08		; $6301

seasonsFunc_15_6304:
	call setLinkForceStateToState08		; $6304
	jp putLinkOnGround		; $6307

seasonsFunc_15_630a:
	ld hl,$cbb3		; $630a
	inc (hl)		; $630d
	ret			; $630e

seasonsFunc_15_630f:
	call getRandomNumber		; $630f
	and $03			; $6312
	jp interactionSetAnimation		; $6314

seasonsFunc_15_6317:
	call setLinkForceStateToState08		; $6317
	ld hl,$d008		; $631a
	ld (hl),$01		; $631d
	ld l,$1a		; $631f
	set 7,(hl)		; $6321
	ret			; $6323

seasonsFunc_15_6324:
	ld c,$10		; $6324
	call objectCheckLinkWithinDistance		; $6326
	rrca			; $6329
	and $03			; $632a
	jp interactionSetAnimation		; $632c

seasonsFunc_15_632f:
	call darkenRoom		; $632f
	jr _label_15_255		; $6332

seasonsFunc_15_6334:
	call brightenRoom		; $6334
_label_15_255:
	xor a			; $6337
	ld ($c4b2),a		; $6338
	ld ($c4b4),a		; $633b
	ld a,$7e		; $633e
	ld ($c4b1),a		; $6340
	ld ($c4b3),a		; $6343
	ret			; $6346

seasonsFunc_15_6347:
	ld bc,$5838		; $6347
	jr _label_15_256		; $634a

seasonsFunc_15_634c:
	ld bc,$1850		; $634c
_label_15_256:
	call getFreePartSlot		; $634f
	ret nz			; $6352
	ld (hl),$27		; $6353
	inc l			; $6355
	inc (hl)		; $6356
	ld l,$cb		; $6357
	ld (hl),b		; $6359
	ld l,$cd		; $635a
	ld (hl),c		; $635c
	ret			; $635d

seasonsFunc_15_635e:
	ld bc,$6372		; $635e
	jr _label_15_257		; $6361

seasonsFunc_15_6363:
	ld bc,$6375		; $6363
_label_15_257:
	call getFreeInteractionSlot		; $6366
	ret nz			; $6369
	ld (hl),$bf		; $636a
	inc l			; $636c
	ld a,(bc)		; $636d
	inc bc			; $636e
	ld (hl),a		; $636f
	jr _label_15_258		; $6370
	nop			; $6372
	ld h,b			; $6373
	jr c,$01		; $6374
	jr nz,$50		; $6376

seasonsFunc_15_6378:
	ld a,$01		; $6378
	ld ($cc17),a		; $637a
	ld a,$b4		; $637d
	ld ($cc1d),a		; $637f
	ret			; $6382

seasonsFunc_15_6383:
	ld bc,$63a0		; $6383
	call $638c		; $6386
	ld bc,$63a3		; $6389
	call getFreeInteractionSlot		; $638c
	ret nz			; $638f
	ld (hl),$b4		; $6390
	inc l			; $6392
	ld a,(bc)		; $6393
	inc bc			; $6394
	ld (hl),a		; $6395
_label_15_258:
	ld l,$4b		; $6396
	ld a,(bc)		; $6398
	inc bc			; $6399
	ld (hl),a		; $639a
	ld l,$4d		; $639b
	ld a,(bc)		; $639d
	ld (hl),a		; $639e
	ret			; $639f
	nop			; $63a0
	jr z,$50		; $63a1
	ld bc,$5028		; $63a3

seasonsFunc_15_63a6:
	call getFreeInteractionSlot		; $63a6
	ret nz			; $63a9
	ld (hl),$22		; $63aa
	inc l			; $63ac
	ld (hl),$09		; $63ad
	ld l,$4b		; $63af
	ld (hl),$40		; $63b1
	ld l,$4d		; $63b3
	ld (hl),$50		; $63b5
	ret			; $63b7

seasonsFunc_15_63b8:
_label_15_259:
	ld hl,$d008		; $63b8
	ld a,(hl)		; $63bb
	xor $02			; $63bc
	jp interactionSetAnimation		; $63be

seasonsFunc_15_63c1:
	ld b,a			; $63c1
	ld c,$00		; $63c2
	jp giveRingToLink		; $63c4
	ld a,$08		; $63c7
	call setLinkIDOverride		; $63c9
	ld l,$02		; $63cc
	ld (hl),$08		; $63ce
	ret			; $63d0

seasonsFunc_15_63d1:
	ld hl,$d008		; $63d1
	ld (hl),a		; $63d4
	jp setLinkForceStateToState08		; $63d5
	ld bc,$6417		; $63d8
	jr _label_15_260		; $63db
	ld bc,$640d		; $63dd
	call $63f5		; $63e0
	ld bc,$6412		; $63e3
	call $63f5		; $63e6
	ld bc,$641c		; $63e9
	call $63f5		; $63ec
	call $63f5		; $63ef
	call $63f5		; $63f2
_label_15_260:
	call getFreeInteractionSlot		; $63f5
	ret nz			; $63f8
	ld a,(bc)		; $63f9
	ldi (hl),a		; $63fa
	inc bc			; $63fb
	ld a,(bc)		; $63fc
	ldi (hl),a		; $63fd
	inc bc			; $63fe
	ld a,(bc)		; $63ff
	ldi (hl),a		; $6400
	inc bc			; $6401
	ld l,$4b		; $6402
	ld a,(bc)		; $6404
	ld (hl),a		; $6405
	inc bc			; $6406
	ld l,$4d		; $6407
	ld a,(bc)		; $6409
	ld (hl),a		; $640a
	inc bc			; $640b
	ret			; $640c
	sub l			; $640d
	dec b			; $640e
	nop			; $640f
	inc d			; $6410
	ld d,b			; $6411
	ld b,h			; $6412
	ld b,$00		; $6413
	ld c,b			; $6415
	ld d,b			; $6416
	cp d			; $6417
	inc bc			; $6418
	nop			; $6419
	adc b			; $641a
	ld b,b			; $641b
	sub (hl)		; $641c
	ld b,$00		; $641d
	ld c,b			; $641f
	jr c,_label_15_259	; $6420
	ld b,$01		; $6422
	ld c,b			; $6424
	ld l,b			; $6425
	sub (hl)		; $6426
	dec b			; $6427
	ld (bc),a		; $6428
	jr z,$30		; $6429
	sub (hl)		; $642b
	dec b			; $642c
	inc bc			; $642d
	jr z,_label_15_261	; $642e

seasonsFunc_15_6430:
	ld a,($ccf8)		; $6430
	ld hl,$cbaa		; $6433
	ldi (hl),a		; $6436
	ld (hl),$00		; $6437
	ld a,($ccf9)		; $6439
	ld hl,$cba8		; $643c
	ldi (hl),a		; $643f
	ld (hl),$00		; $6440
	ret			; $6442

seasonsFunc_15_6443:
	ld hl,$ccf7		; $6443
	xor a			; $6446
	ldi (hl),a		; $6447
	ldi (hl),a		; $6448
	ld (hl),a		; $6449
	ld e,$78		; $644a
	ld (de),a		; $644c
	ld e,$46		; $644d
	ld a,$01		; $644f
	ld (de),a		; $6451
	jp clearAllItemsAndPutLinkOnGround		; $6452

seasonsFunc_15_6455:
	ld a,$01		; $6455
	ld e,$7b		; $6457
	ld (de),a		; $6459
	jp objectSetInvisible		; $645a

seasonsFunc_15_645d:
	xor a			; $645d
	ld e,$7b		; $645e
	ld (de),a		; $6460
	jp objectSetVisible		; $6461

seasonsFunc_15_6464:
	push de			; $6464
	call clearEnemies		; $6465
	call clearItems		; $6468
	call clearParts		; $646b
	pop de			; $646e
	xor a			; $646f
	ld ($cc30),a		; $6470
	ld a,$01		; $6473
	ld ($cc17),a		; $6475
	call setLinkForceStateToState08		; $6478
	ld hl,$d008		; $647b
	ld (hl),$00		; $647e
	ld l,$0b		; $6480
	ld (hl),$88		; $6482
	ld l,$0d		; $6484
	ld (hl),$78		; $6486
	ld l,$0f		; $6488
	ld (hl),$00		; $648a
	ret			; $648c

seasonsFunc_15_648d:
	ld a,($d00b)		; $648d
	ld b,a			; $6490
	ld a,($d00d)		; $6491
	ld c,a			; $6494
	ld a,$6e		; $6495
	jp createEnergySwirlGoingIn		; $6497

seasonsFunc_15_649a:
	ld bc,$8400		; $649a
	jp objectCreateInteraction		; $649d

seasonsFunc_15_64a0:
_label_15_261:
	ld h,d			; $64a0
	ld l,$7c		; $64a1
	ld a,($cba5)		; $64a3
	xor $01			; $64a6
	cp (hl)			; $64a8
	ld l,$7f		; $64a9
	jr nz,_label_15_262	; $64ab
	ld (hl),$00		; $64ad
	ret			; $64af
_label_15_262:
	ld (hl),$01		; $64b0
	ret			; $64b2

seasonsFunc_15_64b3:
	call clearAllItemsAndPutLinkOnGround		; $64b3
	jp objectSetInvisible		; $64b6

seasonsFunc_15_64b9:
	jp objectSetVisible		; $64b9

seasonsFunc_15_64bc:
	call setLinkForceStateToState08		; $64bc
	ld hl,$d008		; $64bf
	ld (hl),$00		; $64c2
	ld l,$0b		; $64c4
	ld (hl),$5c		; $64c6
	ld l,$0d		; $64c8
	ld (hl),$50		; $64ca
	ld l,$0f		; $64cc
	ld (hl),$00		; $64ce
	ret			; $64d0

seasonsFunc_15_64d1:
	call clearAllParentItems		; $64d1
	call dropLinkHeldItem		; $64d4
	call clearItems		; $64d7
	call setLinkForceStateToState08		; $64da
	ld hl,$d008		; $64dd
	ld (hl),$00		; $64e0
	ret			; $64e2

seasonsFunc_15_64e3:
	ld hl,$d008		; $64e3
	ld (hl),$00		; $64e6
	ret			; $64e8

seasonsFunc_15_64e9:
	ld h,d			; $64e9
	ld l,$79		; $64ea
	ld a,(hl)		; $64ec
	or a			; $64ed
	ret nz			; $64ee
	ld l,$78		; $64ef
	ld a,(hl)		; $64f1
	ld b,$00		; $64f2
	cp $03			; $64f4
	jr nc,_label_15_263	; $64f6
	ld b,$01		; $64f8
_label_15_263:
	ld l,$79		; $64fa
	ld (hl),b		; $64fc
	ret			; $64fd

seasonsFunc_15_64fe:
	ld b,a			; $64fe
	ld hl,$cc63		; $64ff
	ld a,$84		; $6502
	ldi (hl),a		; $6504
	ld a,$f0		; $6505
	ldi (hl),a		; $6507
	ld a,$0f		; $6508
	ldi (hl),a		; $650a
	ld a,b			; $650b
	ldi (hl),a		; $650c
	ld a,$00		; $650d
	ld ($cc65),a		; $650f
	ld a,$03		; $6512
	ld ($cc67),a		; $6514
	ret			; $6517

seasonsFunc_15_6518:
	ld h,d			; $6518
	ld l,$73		; $6519
	ld (hl),$4c		; $651b
	ld b,$25		; $651d
	call getThisRoomFlags		; $651f
	and $03			; $6522
	dec a			; $6524
	jr z,_label_15_264	; $6525
	ld b,$27		; $6527
_label_15_264:
	ld a,b			; $6529
	ld e,$72		; $652a
	ld (de),a		; $652c
	ret			; $652d

seasonsFunc_15_652e:
	xor a			; $652e
	ld ($cca4),a		; $652f
	ld ($cc02),a		; $6532
	call getThisRoomFlags		; $6535
	and $c0			; $6538
	ld (hl),a		; $653a
	ret			; $653b

seasonsFunc_15_653c:
	ld b,a			; $653c
	call getThisRoomFlags		; $653d
	and $c0			; $6540
	or b			; $6542
	ld (hl),a		; $6543
	ret			; $6544

seasonsFunc_15_6545:
	call getThisRoomFlags		; $6545
	and $03			; $6548
	ld e,$7c		; $654a
	ld (de),a		; $654c
	ret			; $654d

seasonsFunc_15_654e:
	ld hl,$ccf7		; $654e
	xor a			; $6551
	ldi (hl),a		; $6552
	ldi (hl),a		; $6553
	ld (hl),a		; $6554
	jp clearAllItemsAndPutLinkOnGround		; $6555

seasonsFunc_15_6558:
	xor a			; $6558
	ld ($cfd1),a		; $6559
	ret			; $655c

seasonsFunc_15_655d:
	call setLinkForceStateToState08		; $655d
	ld hl,$d008		; $6560
	ld (hl),$00		; $6563
	ld l,$0b		; $6565
	ld (hl),$60		; $6567
	ld l,$0d		; $6569
	ld (hl),$50		; $656b
	ld l,$0f		; $656d
	ld (hl),$00		; $656f
	ret			; $6571

seasonsFunc_15_6572:
	ld hl,$ccf9		; $6572
	ldd a,(hl)		; $6575
	or a			; $6576
	jr nz,_label_15_265	; $6577
	ld a,(hl)		; $6579
	cp $31			; $657a
	jr nc,_label_15_265	; $657c
	ld a,$2e		; $657e
	jp setGlobalFlag		; $6580
_label_15_265:
	ld a,$2e		; $6583
	jp unsetGlobalFlag		; $6585

seasonsFunc_15_6588:
	ld hl,$6593		; $6588
	call setWarpDestVariables		; $658b
	ld a,$8d		; $658e
	jp playSound		; $6590
	add a			; $6593
	add sp,$00		; $6594
	ld b,$83		; $6596

seasonsFunc_15_6598:
	ld hl,$65a3		; $6598
	call setWarpDestVariables		; $659b
	ld a,$8d		; $659e
	jp playSound		; $65a0
	add e			; $65a3
	or (hl)			; $65a4
	nop			; $65a5
	ld b,l			; $65a6
	add e			; $65a7

seasonsFunc_15_65a8:
	ld e,$20		; $65a8
_label_15_266:
	ld a,e			; $65aa
	call checkTreasureObtained		; $65ab
	ret nc			; $65ae
	inc e			; $65af
	ld a,e			; $65b0
	cp $25			; $65b1
	jr c,_label_15_266	; $65b3
	ld a,($c6ae)		; $65b5
	ld hl,$65ce		; $65b8
	rst_addAToHl			; $65bb
	ld b,(hl)		; $65bc
	ld hl,$c6b5		; $65bd
_label_15_267:
	ld a,b			; $65c0
	cp (hl)			; $65c1
	ret nz			; $65c2
	inc l			; $65c3
	ld a,l			; $65c4
	cp $ba			; $65c5
	jr c,_label_15_267	; $65c7
	ld h,d			; $65c9
	ld l,$78		; $65ca
	ld (hl),$01		; $65cc
	ret			; $65ce
	jr nz,$50		; $65cf
	sbc c			; $65d1

.ends
