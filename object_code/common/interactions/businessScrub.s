; ==================================================================================================
; INTERAC_BUSINESS_SCRUB
;
; Variables:
;   var38: Number of rupees to spend (1-byte value, converted with "rupeeValue" methods)
;   var39: Set when Link is close to the scrub (he pops out of his bush)
; ==================================================================================================
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
	cp SPECIALOBJECT_MOOSH
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
	ld a,INTERAC_BUSINESS_SCRUB
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
