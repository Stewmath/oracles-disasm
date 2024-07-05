; ==================================================================================================
; INTERAC_GASHA_SPOT
; ==================================================================================================
.enum 0
	GASHATREASURE_HEART_PIECE	db ; $00
	GASHATREASURE_TIER0_RING	db ; $01
	GASHATREASURE_TIER1_RING	db ; $02
	GASHATREASURE_TIER2_RING	db ; $03
	GASHATREASURE_TIER3_RING	db ; $04
	GASHATREASURE_TIER4_RING	db ; $05
	GASHATREASURE_POTION		db ; $06
	GASHATREASURE_200_RUPEES	db ; $07
	GASHATREASURE_FAIRY		db ; $08
	GASHATREASURE_5_HEARTS		db ; $09
.ende

interactionCodeb6:
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

; Initialization
@state0:
	ld e,Interaction.subid
	ld a,(de)
	inc e
	ld (de),a
	ld hl,wGashaSpotsPlantedBitset
	call checkFlag
	jr nz,@seedPlanted

	ld e,Interaction.var3c
	ld a,(de)
	or a
	jr nz,+

	ld a,DISCOVERY_RING
	call cpActiveRing
	jr nz,+

	ld a,SND_COMPASS
	ld e,Interaction.var3c
	ld (de),a
	call playSound
+
	call objectGetTileAtPosition
	cp TILEINDEX_SOFT_SOIL
	ret nz
@unearthed:
	call interactionIncState
	ld a,$0a
	call objectSetCollideRadius
	ld e,Interaction.pressedAButton
	jp objectAddToAButtonSensitiveObjectList

@seedPlanted:
	ld a,(de)
	ld hl,wGashaSpotKillCounters
	rst_addAToHl
	ld a,(hl)
	cp 40
	jr c,@delete

@killedEnoughEnemies:
	call getFreePartSlot
	ret nz

	ld (hl),PART_GASHA_TREE
	inc l
	ld (hl),$01
	ld l,Part.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d

	; This interaction will now act as the nut.
	; Adjust x,y positions to be in the center of the tree
	ld h,d
	ld l,Interaction.var37
	ld e,Interaction.yh
	ld a,(de)
	ldi (hl),a
	add $f8
	ld (de),a
	ld e,Interaction.xh
	ld a,(de)
	ldi (hl),a
	add $08
	ld (de),a

	ld a,$04
	call objectSetCollideRadius

	; Set state 3
	ld l,Interaction.state
	ld (hl),$03

	; Load graphics for the nut
	ld l,Interaction.subid
	ld (hl),$0a
	call interactionInitGraphics
	jp objectSetVisible83

; Wait for player to press A button
@state1:
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

@pressedAButton:
	xor a
	ld (de),a
	ld bc,TX_3509
	ld a,(wNumGashaSeeds)
	or a
	jr z,+

	; To state 2
	call interactionIncState
	ld c,<TX_3500
+
	jp showText

; After text box has been shown, selected yes or no
@state2:
	ld a,(wSelectedTextOption)
	or a
	jr z,+

	; Back to state 1
	ld a,$01
	ld (de),a
	ret
+
	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_SOFT_SOIL_PLANTED
	call setTile

	ld e,Interaction.var03
	ld a,(de)
	ld hl,wGashaSpotsPlantedBitset
	call setFlag

	ld a,(de)
	ld l,<wGashaSpotKillCounters
	rst_addAToHl
	ld (hl),$00

	ld l,<wNumGashaSeeds
	ld a,(hl)
	sub $01
	daa
	ld (hl),a
	ld a,SND_GETSEED
	call playSound
@delete:
	jp interactionDelete

; Wait for link to slash the nut, then drop it
@state3:
	ld e,Interaction.var2a
	ld a,(de)
	cp $ff
	ret nz

	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	; To state 4
	ld h,d
	ld l,Interaction.state
	ld (hl),$04

	ld a,$06
	call objectSetCollideRadius
	ld bc,-$140
	call objectSetSpeedZ

	ld l,Interaction.speed
	ld (hl),SPEED_100

	call objectGetAngleTowardLink
	ld e,Interaction.angle
	ld (de),a
	jp objectSetVisible80

; Wait for the nut to collide with link, show corresponding text
@state4:
	; Dunno why this is necessary
	ld a,(wLinkDeathTrigger)
	or a
	jp nz,interactionDelete

	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr c,+

	; Hasn't collided with link yet
	call objectApplySpeed
	ld c,$20
	jp objectUpdateSpeedZ_paramC
+
	; To state 5
	call interactionIncState

	ld l,Interaction.visible
	res 7,(hl)
	ld bc,TX_3501
	jp showText

@state5:
	; Check if this is the first gasha nut harvested ever
	ld hl,wGashaSpotFlags
	bit 0,(hl)
	jr nz,+
	set 0,(hl)
	ld b,GASHATREASURE_TIER3_RING
	jr @spawnTreasure
+
	; Get a value of 0-4 in 'c', based on the range of wGashaMaturity (0 = best
	; prizes, 4 = worst prizes)
	ld c,$00
	ld hl,wGashaMaturity+1
	ldd a,(hl)
	srl a
	jr nz,++
	ld a,(hl)
	rra
	ld hl,@gashaMaturityValues
--
	cp (hl)
	jr nc,++
	inc hl
	inc c
	jr --
++
	; Get the probability distribution to use, based on 'c' (above) and which gasha
	; spot this is (var03)
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@gashaSpotRanks
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	; a = c*10
	ld a,c
	add a
	ld c,a
	add a
	add a
	add c

	rst_addAToHl
	call getRandomIndexFromProbabilityDistribution

	; If it would be a potion, but he has one already, just refill his health
	ld a,b
	cp GASHATREASURE_POTION
	jr nz,@notPotion

	ld a,TREASURE_POTION
	call checkTreasureObtained
	jr nc,@decGashaMaturity

	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ld (hl),a
	jr @decGashaMaturity

@notPotion:
	; If it would ba a heart piece, but he got it already, give tier 0 ring instead
	cp GASHATREASURE_HEART_PIECE
	jr nz,@decGashaMaturity
	ld hl,wGashaSpotFlags
	bit 1,(hl)
	jr z,+
	inc b
+
	set 1,(hl)

@decGashaMaturity:
	ld hl,wGashaMaturity
	ld a,(hl)
	sub 200
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	; Underflow check
	jr nc,@spawnTreasure
	xor a
	ldd (hl),a
	ld (hl),a

@spawnTreasure:
	; This object, which was previously the nut, will now become the item sprite being
	; held over Link's head; set the subid accordingly.
	ld a,b
	ld e,Interaction.subid
	ld (de),a
	ld hl,@gashaTreasures
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	cp TREASURE_RING
	jr nz,+
	call getRandomRingOfGivenTier
+
	ld b,a
	call giveTreasure

	; Set Link's animation
	ld hl,wLinkForceState
	ld a,LINK_STATE_04
	ldi (hl),a
	ld (hl),$01 ; [wcc50]

	; Set position above Link
	ld hl,w1Link.yh
	ld bc,$f300
	call objectTakePositionWithOffset

	call interactionIncState
	ld l,Interaction.visible
	set 7,(hl)

	ld e,Interaction.subid
	ld a,(de)
	cp GASHATREASURE_HEART_PIECE
	ld a,SND_GETITEM
	call nz,playSound

	; Load graphics, show text
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@lowTextIndices
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_3500
	jp showText

; Text to show upon getting each respective item
@lowTextIndices:
	.db <TX_3503, <TX_3504, <TX_3504, <TX_3504, <TX_3504, <TX_3504, <TX_3505, <TX_3506
	.db <TX_3508, <TX_3507

; Obtained the item and exited the textbox; wait for link's hearts or rupee
; count to update fully, then make the tree disappear
@state6:
	ld hl,wNumRupees
	ld a,(wDisplayedRupees)
	cp (hl)
	ret nz
	inc l
	ld a,(wDisplayedRupees+1)
	cp (hl)
	ret nz

	ld l,<wLinkHealth
	ld a,(wDisplayedHearts)
	cp (hl)
	ret nz

	ld a,SND_FAIRYCUTSCENE
	call playSound

	ld e,Interaction.var03
	ld a,(de)
	ld hl,@gfxHeaderToLoadWhenTreeDisappears
	rst_addAToHl
	ld a,(hl)
	push af

	; Object gfx headers 04-06 correspond to gfx headers 3d-3f?
	sub GFXH_GASHA_TREE_DISAPPEARED - OBJ_GFXH_04
	ld (wLoadedTreeGfxActive),a

	ld a,GFXH_GASHA_TREE_DISAPPEARED
	call loadGfxHeader
	pop af
	cp GFXH_GASHA_TREE_DISAPPEARED
	call nz,loadGfxHeader

	ldh a,(<hActiveObject)
	ld d,a
	ld h,d
	ld l,Interaction.var37
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a ; [yh] = [var37] (original Y position)
	ld e,Interaction.xh
	ldi a,(hl)
	ld (de),a ; [xh] = [var38] (original X position)

	ld l,Interaction.visible
	res 7,(hl)

	; Make tiles walkable again
	call objectGetTileCollisions
	xor a
	ldi (hl),a
	ldd (hl),a
	ld a,l
	sub $10
	ld l,a
	xor a
	ldi (hl),a
	ldd (hl),a

	; Calculate position in w3VramTiles?
	ld h,a
	ld e,l
	ld a,l
	and $f0
	ld l,a
	ld a,e
	and $0f
	sla l
	rl h
	add l
	ld l,a
	sla l
	rl h
	ld bc,w3VramTiles
	add hl,bc

	; Write calculated position to var3a
	ld e,Interaction.var3a
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	; Do something with w3VramAttributes ($400 bytes ahead)?
	ld bc,$0400
	add hl,bc
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramAttributes
	ld ($ff00+R_SVBK),a
	ld b,$04
---
	ld c,$04
	push bc
--
	ld a,(hl)
	and $f0
	or $04
	ldi (hl),a
	dec c
	jr nz,--

	ld bc,$001c
	add hl,bc
	pop bc
	dec b
	jr nz,---

	pop af
	ld ($ff00+R_SVBK),a
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$08

; Shrinking the tree (cycling through each frame of the animation)
@state7:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,@counter1Done

	dec a
	ld (hl),a
	ret nz

@counter1Done:
	ld a,$08
	ldi (hl),a
	ld a,(hl)
	inc a
	ld (hl),a
	cp $0a
	jr nc,@counter2Done

	ld hl,@treeDisappearanceFrames-1
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	; Retrieve position in w3VramTiles from var3a
	ld e,Interaction.var3a
	ld a,(de)
	ld c,a
	inc e
	ld a,(de)
	ld d,a
	ld e,c

	push hl
	push de
	pop hl
	pop de

	; Draw the next frame of the tree's disappearance
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	ld b,$04
---
	ld c,$04
	push bc
--
	ld a,(de)
	ldi (hl),a
	inc de
	dec c
	jr nz,--

	ld bc,$001c
	add hl,bc
	pop bc
	dec b
	jr nz,---

	pop af
	ld ($ff00+R_SVBK),a
	ld a,UNCMP_GFXH_29
	call loadUncompressedGfxHeader

	ldh a,(<hActiveObject)
	ld d,a
	ld e,Interaction.counter2
	ld a,(de)
	add UNCMP_GFXH_20 - 1
	call loadUncompressedGfxHeader

	call reloadTileMap
	ldh a,(<hActiveObject)
	ld d,a
	ret

@counter2Done:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld e,Interaction.var03
	ld a,(de)
	ld hl,wGashaSpotsPlantedBitset
	call unsetFlag

.ifdef ROM_AGES
.ifndef REGION_JP
	; Overwrite the 4 tiles making up the gasha tree in wRoomLayout
	ld a,TILEINDEX_GASHA_TREE_TL
	call findTileInRoom
	ret nz

	ld e,Interaction.var03
	ld a,(de)
	ld bc,@tileReplacements
	call addAToBc
	ld a,(bc)
	ld b,a
	ld a,b
	ldi (hl),a
	ld (hl),a
	ld a,$0f
	add l
	ld l,a
	ld a,b
	ldi (hl),a
	ld (hl),a
.endif
.endif
	jp interactionDelete

.ifdef ROM_AGES
.ifndef REGION_JP
@tileReplacements:
	.db $3a $1b $1b $3a $3a $bf $3a $bf
	.db $1b $3a $3a $1b $3a $3a $3a $bf
.endif
.endif


; These are values compared with "wGashaMaturity" which set the ranges for gasha prize
; "levels". A value of 300 or higher will give you the highest level prizes.
@gashaMaturityValues:
	.db 300/2
	.db 200/2
	.db 120/2
	.db  40/2
	.db   0/2


@gashaTreasures:
	.db TREASURE_HEART_PIECE, $01
	.db TREASURE_RING, RING_TIER_0
	.db TREASURE_RING, RING_TIER_1
	.db TREASURE_RING, RING_TIER_2
	.db TREASURE_RING, RING_TIER_3
	.db TREASURE_RING, RING_TIER_4
	.db TREASURE_POTION, $01
	.db TREASURE_RUPEES, RUPEEVAL_200
	.db TREASURE_HEART_REFILL, $18
	.db TREASURE_HEART_REFILL, $14


; Each row defines which type of gasha spot each subid is (rank 0 = best).
@gashaSpotRanks:
.ifdef ROM_AGES
	dbrel @rank1Spot ; $00
	dbrel @rank2Spot ; $01
	dbrel @rank2Spot ; $02
	dbrel @rank1Spot ; $03
	dbrel @rank4Spot ; $04
	dbrel @rank1Spot ; $05
	dbrel @rank1Spot ; $06
	dbrel @rank0Spot ; $07
	dbrel @rank3Spot ; $08
	dbrel @rank2Spot ; $09
	dbrel @rank2Spot ; $0a
	dbrel @rank1Spot ; $0b
	dbrel @rank4Spot ; $0c
	dbrel @rank3Spot ; $0d
	dbrel @rank1Spot ; $0e
	dbrel @rank0Spot ; $0f
.else
	dbrel @rank1Spot ; $00
	dbrel @rank0Spot ; $01
	dbrel @rank0Spot ; $02
	dbrel @rank3Spot ; $03
	dbrel @rank2Spot ; $04
	dbrel @rank3Spot ; $05
	dbrel @rank2Spot ; $06
	dbrel @rank4Spot ; $07
	dbrel @rank1Spot ; $08
	dbrel @rank2Spot ; $09
	dbrel @rank4Spot ; $0a
	dbrel @rank3Spot ; $0b
	dbrel @rank2Spot ; $0c
	dbrel @rank2Spot ; $0d
	dbrel @rank3Spot ; $0e
	dbrel @rank4Spot ; $0f
.endif


; Each row corresponds to a certain range for "wGashaMaturity". The first row is the most
; "mature" (occurs later in the game), while the later rows occur earlier in the game.
; Prizes get better as the game goes on.
;
; Each row is a "probability distribution" that adds up to 256. Each byte is a weighting
; for the corresponding treasure (GASHATREASURE_X).

@rank0Spot: ; Best type of spot
	.db $5a $40 $26 $00 $00 $1a $0d $0d $0c $00
	.db $40 $26 $26 $00 $00 $00 $40 $26 $0e $00
	.db $26 $33 $33 $00 $00 $00 $40 $26 $0e $00
	.db $1a $26 $26 $00 $00 $00 $40 $34 $26 $00
	.db $0c $1a $1a $00 $00 $00 $4d $33 $33 $0d
@rank1Spot:
	.db $1a $26 $5a $33 $00 $00 $19 $0d $0d $00
	.db $0d $1a $33 $40 $00 $00 $26 $33 $0d $00
	.db $08 $12 $33 $33 $00 $00 $26 $33 $1a $0d
	.db $05 $0d $1a $3b $00 $00 $26 $33 $26 $1a
	.db $03 $08 $0f $19 $00 $00 $1a $40 $4d $26
@rank2Spot:
	.db $00 $00 $26 $4d $66 $00 $0d $0d $0d $00
	.db $00 $00 $1a $32 $4d $00 $33 $1a $1a $00
	.db $00 $00 $0d $1a $26 $00 $40 $33 $33 $0d
	.db $00 $00 $08 $12 $1a $00 $40 $33 $33 $26
	.db $00 $00 $03 $0d $0d $00 $1a $4b $4b $33
@rank3Spot:
	.db $00 $00 $00 $5a $5a $00 $1a $1a $0c $0c
	.db $00 $00 $00 $33 $33 $00 $33 $33 $1a $1a
	.db $00 $00 $00 $26 $26 $00 $26 $33 $34 $27
	.db $00 $00 $00 $1a $1a $00 $1a $4d $32 $33
	.db $00 $00 $00 $0d $0d $00 $1a $40 $40 $4c
@rank4Spot: ; Worst type of spot
	.db $00 $00 $00 $40 $34 $00 $26 $26 $26 $1a
	.db $00 $00 $00 $26 $26 $00 $26 $33 $34 $27
	.db $00 $00 $00 $1a $26 $00 $26 $33 $34 $33
	.db $00 $00 $00 $12 $1a $00 $21 $33 $40 $40
	.db $00 $00 $00 $0d $0d $00 $0d $40 $4c $4d


; Each entry consists of a 4x4 block of subtiles (8x8 tiles) to draw while the tree is
; disappearing.
@treeDisappearanceFrames:
	dbrel @frame1
	dbrel @frame1
	dbrel @frame2
	dbrel @frame3
	dbrel @frame4
	dbrel @frame5
	dbrel @frame5
	dbrel @frame6
	dbrel @frame7

@frame1:
	.db $20 $21 $22 $23
	.db $24 $25 $26 $27
	.db $28 $29 $2a $2b
	.db $2c $2d $2e $2f
@frame2:
	.db $20 $21 $20 $21
	.db $24 $25 $26 $27
	.db $28 $29 $2a $2b
	.db $20 $2c $2d $2e
@frame3:
	.db $20 $21 $20 $21
	.db $24 $25 $26 $27
	.db $28 $29 $2a $2b
	.db $22 $2c $2d $23
@frame4:
	.db $20 $21 $20 $21
	.db $22 $24 $25 $23
	.db $20 $26 $27 $21
	.db $22 $28 $29 $23
@frame5:
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23
	.db $20 $24 $25 $21
	.db $22 $26 $27 $23
@frame6:
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23
	.db $20 $21 $20 $21
	.db $22 $24 $25 $23
@frame7:
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23


; Each subid loads one of 3 gfx headers while the tree disappears.
@gfxHeaderToLoadWhenTreeDisappears:
.ifdef ROM_AGES
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $00
	.db GFXH_GASHA_TREE_DISAPPEARED_DIRT ; $01
	.db GFXH_GASHA_TREE_DISAPPEARED_DIRT ; $02
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $03
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $04
	.db GFXH_GASHA_TREE_DISAPPEARED_SAND ; $05
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $06
	.db GFXH_GASHA_TREE_DISAPPEARED_SAND ; $07
	.db GFXH_GASHA_TREE_DISAPPEARED_DIRT ; $08
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $09
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $0a
	.db GFXH_GASHA_TREE_DISAPPEARED_DIRT ; $0b
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $0c
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $0d
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $0e
	.db GFXH_GASHA_TREE_DISAPPEARED_SAND ; $0f
.else
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $00
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $01
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $02
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $03
	.db GFXH_GASHA_TREE_DISAPPEARED_DIRT ; $04
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $05
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $06
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $07
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $08
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $09
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $0a
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $0b
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $0c
	.db GFXH_GASHA_TREE_DISAPPEARED_SAND ; $0d
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $0e
	.db GFXH_GASHA_TREE_DISAPPEARED      ; $0f
.endif
