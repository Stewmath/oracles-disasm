 m_section_free Interaction_Code_Group6 NAMESPACE commonInteractions6

; ==============================================================================
; INTERACID_BUSINESS_SCRUB
;
; Variables:
;   var38: Number of rupees to spend (1-byte value, converted with "rupeeValue" methods)
;   var39: Set when Link is close to the scrub (he pops out of his bush)
; ==============================================================================
interactionCodece:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit

.ifdef ROM_SEASONS
	ld e,Interaction.subid
	ld a,(de)
	; Sells cheap shield
	cp $06
	jr nz,+++

	ld hl,w1Companion
	ldi a,(hl)
	or a
	jr z,@noCompanion
	ld a,(hl)
	cp SPECIALOBJECTID_MOOSH
	jr z,@moosh
@noCompanion:
	ld a,(wEssencesObtained)
	bit 3,a
	jr nz,+++
@moosh:
	jp interactionDelete
+++
.endif

	ld e,Interaction.subid
	ld a,(de)
	bit 7,a
	jr nz,@mimicBush

	cp $00
	jr z,@sellingShield
	cp $03
	jr z,@sellingShield
	cp $06
	jr nz,+++

@sellingShield:
	ld c,a
	ld a,(wShieldLevel)
	or a
	jr z,+
	dec a
+
	add c
	ld (de),a
	ld hl,@itemPrices
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld hl,wTextNumberSubstitution
	ldi (hl),a
	ld (hl),b
+++
	ld e,Interaction.collisionRadiusY
	ld a,$06
	ld (de),a
	inc e
	ld (de),a

	call interactionInitGraphics
	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	call objectSetVisible80
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList

	call getFreeInteractionSlot
	ld a,INTERACID_BUSINESS_SCRUB
	ldi (hl),a
	ld a,$80
	ldi (hl),a
	ld l,Interaction.relatedObj2
	ld (hl),d
	jp objectCopyPosition

; Subid $80 initialization (the bush above the scrub)
@mimicBush:
	ld a,(wActiveGroup)
	or a
	ld a,TILEINDEX_OVERWORLD_BUSH_1
	jr z,+
.ifdef ROM_AGES
	ld a,TILEINDEX_OVERWORLD_BUSH_1
.else
	ld a,TILEINDEX_DUNGEON_BUSH
.endif
+
	call objectMimicBgTile
	ld a,$05
	call interactionSetAnimation
	jp objectSetVisible80

@state1:
	ld a,(wScrollMode)
	and SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02
	ret nz

	ld e,Interaction.subid
	ld a,(de)
	bit 7,a
	jr nz,@subid80State1

	call objectSetPriorityRelativeToLink_withTerrainEffects
	call interactionAnimate
	ld c,$20
	call objectCheckLinkWithinDistance
	ld e,Interaction.var39
	jr c,@linkIsClose

	; Link not close
	ld a,(de)
	or a
	ret z
	xor a
	ld (de),a
	ld a,$03
	jp interactionSetAnimation

@linkIsClose:
	ld a,(de)
	or a
	jr nz,++
	inc a
	ld (de),a
	ld a,$01
	jp interactionSetAnimation
++
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

	; Link talked to the scrub
	call interactionIncState
	ld a,$02
	call interactionSetAnimation
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@offerItemTextIndices
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_4500
	jp showTextNonExitable

; Subid $80: the bush above the scrub
@subid80State1:
	ld e,Interaction.relatedObj2
	ld a,(de)
	ld h,a
	ld l,Interaction.visible
	ld a,(hl)
	ld e,Interaction.visible
	ld (de),a
	ld l,Interaction.yh
	ld b,(hl)
	ld l,Interaction.animParameter
	ld a,(hl)
	ld hl,@bushYOffsets
	rst_addAToHl
	ld e,Interaction.yh
	ldi a,(hl)
	add b
	ld (de),a
	ret

@state2:
	call interactionAnimate
	ld a,(wTextIsActive)
	and $7f
	ret nz

	; Link just finished talking to the scrub
	ld a,(wSelectedTextOption)
	bit 7,a
	jr z,@label_0b_103

	ld e,Interaction.state
	ld a,$01
	ld (de),a
	xor a
	ld (wTextIsActive),a
	ld e,Interaction.pressedAButton
	ld (de),a
	dec a
	ld (wSelectedTextOption),a
	ld a,$04
	jp interactionSetAnimation

@label_0b_103:
	ld a,(wSelectedTextOption)
	or a
	jr z,@agreedToBuy

	; Declined to buy
	ld bc,TX_4506
	jr @showText

@agreedToBuy:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@rupeeValues
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var38
	ld (de),a
	call cpRupeeValue
	jr z,@enoughRupees

	; Not enough rupees
	ld bc,TX_4507
	jr @showText

@enoughRupees:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@treasuresToSell
	rst_addDoubleIndex
	ld a,(hl)
	cp TREASURE_BOMBS
	jr z,@giveBombs
	cp TREASURE_EMBER_SEEDS
	jr nz,@giveShield

@giveEmberSeeds:
	ld a,(wSeedSatchelLevel)
	ld bc,@maxSatchelCapacities-1
	call addAToBc
	ld a,(bc)
	ld c,a
	ld a,(wNumEmberSeeds)
	cp c
	jr nz,@giveTreasure
	jr @alreadyHaveTreasure

@giveBombs:
	ld bc,wNumBombs
	ld a,(bc)
	inc c
	ld e,a
	ld a,(bc)
	cp e
	jr nz,@giveTreasure
	jr @alreadyHaveTreasure

@giveShield:
	call checkTreasureObtained
	jr nc,@giveTreasure

@alreadyHaveTreasure:
	ld bc,TX_4508
	jr @showText

@giveTreasure:
	ldi a,(hl)
	ld c,(hl)
	call giveTreasure
	ld e,Interaction.var38
	ld a,(de)
	call removeRupeeValue
	ld a,SND_GETSEED
	call playSound
	ld bc,TX_4505
@showText:
	jp showText

@maxSatchelCapacities:
	.db $20 $50 $99

@offerItemTextIndices:
.ifdef ROM_AGES
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
.else
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_450b
	.db <TX_450b
	.db <TX_450b
	.db <TX_4502
	.db <TX_4502
	.db <TX_4502
	.db <TX_450d
	.db <TX_450c
.endif

@bushYOffsets:
	.db $00 ; Normally
	.db $f8 ; When Link approaches
	.db $f5 ; When Link is talking to him

; This should match with "@itemPrices" below
@rupeeValues:
.ifdef ROM_AGES
	.db RUPEEVAL_50
	.db RUPEEVAL_100
	.db RUPEEVAL_150
	.db RUPEEVAL_30
	.db RUPEEVAL_50
	.db RUPEEVAL_80
	.db RUPEEVAL_10
	.db RUPEEVAL_20
	.db RUPEEVAL_40
.else
	.db RUPEEVAL_050
	.db RUPEEVAL_100
	.db RUPEEVAL_150
	.db RUPEEVAL_050
	.db RUPEEVAL_100
	.db RUPEEVAL_150
	.db RUPEEVAL_050
	.db RUPEEVAL_100
	.db RUPEEVAL_150
	.db RUPEEVAL_030
	.db RUPEEVAL_020
.endif

@treasuresToSell:
	.db TREASURE_SHIELD      $01
	.db TREASURE_SHIELD      $02
	.db TREASURE_SHIELD      $03
	.db TREASURE_SHIELD      $01
	.db TREASURE_SHIELD      $02
	.db TREASURE_SHIELD      $03
	.db TREASURE_SHIELD      $01
	.db TREASURE_SHIELD      $02
	.db TREASURE_SHIELD      $03
	.db TREASURE_BOMBS       $10
	.db TREASURE_EMBER_SEEDS $10

; This should match with "@rupeeValues" above
@itemPrices:
.ifdef ROM_AGES
	.dw $0050
	.dw $0100
	.dw $0150
	.dw $0030
	.dw $0050
	.dw $0080
	.dw $0010
	.dw $0020
	.dw $0040
.else
	.dw $0050
	.dw $0100
	.dw $0150
	.dw $0050
	.dw $0100
	.dw $0150
	.dw $0050
	.dw $0100
	.dw $0150
.endif


; ==============================================================================
; INTERACID_cf
; ==============================================================================
interactionCodecf:
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
	ld hl,@positions
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
	jp objectSetVisible82

@positions:
	.db $18 $5c ; 0 == [subid]
	.db $40 $40 ; 1
	.db $38 $88 ; 2

@state1:
	jp interactionAnimate


; ==============================================================================
; INTERACID_COMPANION_TUTORIAL
; ==============================================================================
interactionCoded0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	ret

@state1:
	ld a,$02
	ld (de),a
	ld a,(w1Companion.enabled)
	or a
	jr z,@deleteIfSubid2Or5

	; Verify that the correct companion is on-screen, otherwise delete self
	ld e,Interaction.subid
	ld a,(de)
	srl a
	add SPECIALOBJECTID_FIRST_COMPANION
	cp SPECIALOBJECTID_LAST_COMPANION+1
	jr c,+
	ld a,SPECIALOBJECTID_MOOSH
+
	ld hl,w1Companion.id
	cp (hl)
	jr nz,@delete

	; Delete self if tutorial text was already shown
	ld a,(de)
	ld hl,@flagNumbers
	rst_addAToHl
	ld a,(hl)
	ld hl,wCompanionTutorialTextShown
	call checkFlag
	jr nz,@delete

	; Check whether to dismount? (subid 2 only)
	ld a,(de)
	cp $02
	jr nz,++
	ld a,(wLinkObjectIndex)
	rra
	ld a,(de)
	jr nc,++
	ld (wForceCompanionDismount),a
++
	ld hl,@tutorialTextToShow
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,a
	ld b,(hl)
	ld a,(wLinkObjectIndex)
	bit 0,a
	call nz,showText

@deleteIfSubid2Or5:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jr z,@delete
	cp $05
	ret nz
@delete:
	jp interactionDelete

@state2:
	ld a,(w1Companion.enabled)
	or a
	ret z
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
.ifdef ROM_AGES
	.dw @setFlagAndDeleteWhenCompanionIsBelowOrRight
	.dw @setFlagAndDeleteWhenCompanionIsAbove
	.dw @setFlagAndDeleteWhenCompanionIsBelow
	.dw @setFlagAndDeleteWhenCompanionIsAboveAndLinkInXRange
	.dw @setFlagAndDeleteWhenCompanionIsLeft
	.dw @setFlagAndDeleteWhenCompanionIsBelow
.else
	.dw @setFlagAndDeleteWhenCompanionIsBelow
	.dw @setFlagAndDeleteWhenCompanionIsAbove
	.dw @goToDelete
	.dw @setFlagAndDeleteWhenCompanionIsAboveAndVar38NonZero
	.dw @setFlagAndDeleteWhenCompanionIsBelow
	.dw @goToDelete
	.dw @setFlagAndDeleteWhenCompanionIsAbove
.endif

@setFlagAndDeleteWhenCompanionIsBelow:
	ld e,Interaction.yh
	ld a,(de)
	ld hl,w1Companion.yh
	cp (hl)
	ret nc
	jr @setFlagAndDelete

@setFlagAndDeleteWhenCompanionIsAboveAndVar38NonZero:
	ld a,(w1Companion.var38)
	or a
	ret z

@setFlagAndDeleteWhenCompanionIsAbove:
	call @cpYToCompanion
	ret c

@setFlagAndDelete:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@flagNumbers
	rst_addAToHl
	ld a,(hl)
	ld hl,wCompanionTutorialTextShown
	call setFlag

@goToDelete:
	jr @delete

.ifdef ROM_AGES
@setFlagAndDeleteWhenCompanionIsAboveAndLinkInXRange:
	call @checkLinkInXRange
	ret nz
	jr @setFlagAndDeleteWhenCompanionIsAbove

@setFlagAndDeleteWhenCompanionIsLeft:
	ld e,Interaction.xh
	ld a,(de)
	ld hl,w1Companion.xh
	cp (hl)
	ret nc
	jr @setFlagAndDelete

@setFlagAndDeleteWhenCompanionIsBelowOrRight:
	call @cpYToCompanion
	jr c,@setFlagAndDelete
	ld e,Interaction.xh
	ld a,(de)
	ld hl,w1Companion.xh
	cp (hl)
	ret c
	jr @setFlagAndDelete
.endif

;;
@cpYToCompanion:
	ld e,Interaction.yh
	ld a,(de)
	ld hl,w1Companion.yh
	cp (hl)
	ret

;;
; @param[out]	zflag	z if Link is within a certain range of X-positions for certain
;			rooms?
@checkLinkInXRange:
	ld a,(wActiveRoom)
	ld hl,@rooms
	ld b,$00
--
	cp (hl)
	jr z,++
	inc b
	inc hl
	jr --
++
	ld a,b
	ld hl,@xRanges
	rst_addDoubleIndex
	ld a,(w1Link.xh)
	cp (hl)
	jr c,++
	inc hl
	cp (hl)
	jr nc,++
	xor a
	ret
++
	or d
	ret

.ifdef ROM_AGES

@rooms:
	.db <ROOM_AGES_036
	.db <ROOM_AGES_037
	.db <ROOM_AGES_027

@xRanges:
	.db $40 $70
	.db $10 $30
	.db $40 $80

@tutorialTextToShow:
	.dw TX_2008
	.dw TX_2009
	.dw TX_0000
	.dw TX_2108
	.dw TX_2207
	.dw TX_2206

@flagNumbers:
	.db $00 $01 $00 $03 $04 $00

.else; ROM_SEASONS

; These seem unused in seasons, just copies of the Ages data
@rooms:
	.db <ROOM_SEASONS_036
	.db <ROOM_SEASONS_037
	.db <ROOM_SEASONS_027

@xRanges:
	.db $40 $70
	.db $10 $30
	.db $40 $80

; Although this really is used
@tutorialTextToShow:
	.dw TX_200d
	.dw TX_200e
	.dw TX_2121
	.dw TX_2122
	.dw TX_2218
	.dw TX_2217
	.dw TX_2218

@flagNumbers:
	.db $00 $01 $02 $03 $04 $05 $04

.endif


; ==============================================================================
; INTERACID_GAME_COMPLETE_DIALOG
; ==============================================================================
interactionCoded1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionRunScript

@state0:
	ld a,$01
	ld (de),a
	ld c,a
	callab bank1.loadDeathRespawnBufferPreset
	ld hl,mainScripts.gameCompleteDialogScript
	jp interactionSetScript


; ==============================================================================
; INTERACID_TITLESCREEN_CLOUDS
; ==============================================================================
interactionCoded2:
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
	ld hl,@positions
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld h,d
	ld l,Interaction.var37
	ld (hl),a
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld (hl),b

	ld l,Interaction.angle
	ld (hl),ANGLE_DOWN
	ld l,Interaction.speed
	ld (hl),SPEED_20
	ret

@positions:
	.db $bf $7c ; 0 == [subid]
	.db $bf $2a ; 1
	.db $9f $94 ; 2
	.db $a3 $10 ; 3


@state1:
	ld a,(wGfxRegs1.SCY)
	ld b,a
	ld e,Interaction.var37
	ld a,(de)
	sub b
	inc e
	ld e,Interaction.yh
	ld (de),a

	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	ld a,(wGfxRegs1.SCY)
	cp $e0
	ret nz
	call interactionIncSubstate
	call objectSetVisible82

@substate1:
	ld a,(wGfxRegs1.SCY)
	cp $88
	ret z

;;
; This is used by INTERACID_TITLESCREEN_CLOUDS and INTERACID_INTRO_BIRD.
; @param[out]	a	X position
introObject_applySpeed:
	ld h,d
	ld l,Interaction.angle
	ld c,(hl)
	ld l,Interaction.speed
	ld b,(hl)
	call getPositionOffsetForVelocity
	ret z

	ld e,Interaction.var36
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	inc l
	ld a,(de)
	adc (hl)
	ld (de),a

	ld e,Interaction.x
	inc l
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	inc l
	ld a,(de)
	adc (hl)
	ld (de),a
	ret


; ==============================================================================
; INTERACID_INTRO_BIRD
; ==============================================================================
interactionCoded3:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	; counter2: How long the bird should remain (it will respawn if it goes off-screen
	; before counter2 reaches 0)
	ld h,d
	ld l,Interaction.counter2
	ld (hl),45

	; Determine direction to move in based on subid
	ld l,Interaction.subid
	ld a,(hl)
	ld b,$00
	ld c,$1a
	cp $04
	jr c,+
	inc b
	ld c,$06
+
	ld l,Interaction.angle
	ld (hl),c
	ld l,Interaction.speed
	ld (hl),SPEED_140

	push af
	ld a,b
	call interactionSetAnimation

	pop af

@initializePositionAndCounter1:
	ld b,a
	add a
	add b
	ld hl,@birdPositionsAndAppearanceDelays
	rst_addAToHl
	ldi a,(hl)
	ld b,(hl)
	inc l
	ld c,(hl)
	ld h,d
	ld l,Interaction.var37
	ld (hl),a
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld (hl),b
	ld l,Interaction.counter1
	ld (hl),c
	ret

@state1:
	; Update Y
	ld a,(wGfxRegs1.SCY)
	ld b,a
	ld e,Interaction.var37
	ld a,(de)
	sub b
	inc e
	ld e,Interaction.yh
	ld (de),a

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wGfxRegs1.SCY)
	cp $10
	ret nz
	jp interactionIncSubstate

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp objectSetVisible82

@substate2:
	ld e,Interaction.counter2
	ld a,(de)
	or a
	jr z,+
	dec a
	ld (de),a
+
	call interactionAnimate
	call introObject_applySpeed
	cp $b0
	ret c

	; Bird is off-screen; check whether to "reset" the bird or just delete it.
	ld h,d
	ld l,Interaction.counter2
	ld a,(hl)
	or a
	jp z,interactionDelete

	ld l,Interaction.substate
	dec (hl)
	ld l,Interaction.subid
	ld a,(hl)
	call @initializePositionAndCounter1

	; Set counter1 (the delay before reappearing) randomly
	call getRandomNumber_noPreserveVars
	and $0f
	ld h,d
	ld l,Interaction.counter1
	ld (hl),a
	jp objectSetInvisible


; Data format:
;   b0: Y
;   b1: X
;   b2: counter1 (delay before appearing)
@birdPositionsAndAppearanceDelays:
	.db $4c $18 $01 ; 0 == [subid]
	.db $58 $20 $10 ; 1
	.db $5a $30 $14 ; 2
	.db $50 $28 $16 ; 3
	.db $50 $74 $04 ; 4
	.db $4c $84 $0a ; 5
	.db $5c $8c $12 ; 6
	.db $58 $7c $17 ; 7


; ==============================================================================
; INTERACID_LINK_SHIP
; ==============================================================================
interactionCoded4:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	ld b,a
	and $0f
	ld (hl),a

	ld a,b
	swap a
	and $0f
	add a
	add a
	ld l,Interaction.counter1
	ld (hl),a

	call interactionInitGraphics
	jp objectSetVisible82

@state1:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	ret z

	call interactionDecCounter1
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@seagull

@ship:
	; Update the "bobbing" of the ship using the Z position (every 32 frames)
	ld a,(wFrameCounter)
	ld b,a
	and $1f
	ret nz

	ld a,b
	and $e0
	swap a
	rrca
	ld hl,@zPositions
	rst_addAToHl
	ld e,Interaction.zh
	ld a,(hl)
	ld (de),a
	ret

@zPositions:
	.db $00 $ff $ff $00 $00 $01 $01 $00


@seagull:
	; Similarly update the "bobbing" of the seagull, but more frequently
	ld a,(hl) ; [counter1]
	and $07
	ret nz

	ld a,(hl)
	and $38
	swap a
	rlca
	ld hl,@zPositions
	rst_addAToHl
	ld e,Interaction.zh
	ld a,(hl)
	ld (de),a
	ret

.ends
