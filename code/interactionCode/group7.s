; ==============================================================================
; INTERACID_BUSINESS_SCRUB
;
; Variables:
;   var38: Number of rupees to spent (1-byte value, converted with "rupeeValue" methods)
;   var39: Set when Link is close to the scrub (he pops out of his bush)
; ==============================================================================
interactionCodece:
	ld e,Interaction.state		; $495d
	ld a,(de)		; $495f
	rst_jumpTable			; $4960
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $4967
	ld (de),a		; $4969
	call interactionSetAlwaysUpdateBit		; $496a

.ifdef ROM_SEASONS
	ld e,Interaction.subid		; $7410
	ld a,(de)		; $7412
	; Sells cheap shield
	cp $06			; $7413
	jr nz,+++		; $7415

	ld hl,w1Companion		; $7417
	ldi a,(hl)		; $741a
	or a			; $741b
	jr z,@noCompanion	; $741c
	ld a,(hl)		; $741e
	cp SPECIALOBJECTID_MOOSH			; $741f
	jr z,@moosh		; $7421
@noCompanion:
	ld a,(wEssencesObtained)		; $7423
	bit 3,a			; $7426
	jr nz,+++		; $7428
@moosh:
	jp interactionDelete		; $742a
+++
.endif

	ld e,Interaction.subid		; $496d
	ld a,(de)		; $496f
	bit 7,a			; $4970
	jr nz,@mimicBush	; $4972

	cp $00			; $4974
	jr z,@sellingShield	; $4976
	cp $03			; $4978
	jr z,@sellingShield	; $497a
	cp $06			; $497c
	jr nz,+++		; $497e

@sellingShield:
	ld c,a			; $4980
	ld a,(wShieldLevel)		; $4981
	or a			; $4984
	jr z,+			; $4985
	dec a			; $4987
+
	add c			; $4988
	ld (de),a		; $4989
	ld hl,@itemPrices		; $498a
	rst_addDoubleIndex			; $498d
	ldi a,(hl)		; $498e
	ld b,(hl)		; $498f
	ld hl,wTextNumberSubstitution		; $4990
	ldi (hl),a		; $4993
	ld (hl),b		; $4994
+++
	ld e,Interaction.collisionRadiusY		; $4995
	ld a,$06		; $4997
	ld (de),a		; $4999
	inc e			; $499a
	ld (de),a		; $499b

	call interactionInitGraphics		; $499c
	call objectMakeTileSolid		; $499f
	ld h,>wRoomLayout		; $49a2
	ld (hl),$00		; $49a4
	call objectSetVisible80		; $49a6
	ld e,Interaction.pressedAButton		; $49a9
	call objectAddToAButtonSensitiveObjectList		; $49ab

	call getFreeInteractionSlot		; $49ae
	ld a,INTERACID_BUSINESS_SCRUB		; $49b1
	ldi (hl),a		; $49b3
	ld a,$80		; $49b4
	ldi (hl),a		; $49b6
	ld l,Interaction.relatedObj2		; $49b7
	ld (hl),d		; $49b9
	jp objectCopyPosition		; $49ba

; Subid $80 initialization (the bush above the scrub)
@mimicBush:
	ld a,(wActiveGroup)		; $49bd
	or a			; $49c0
	ld a,TILEINDEX_OVERWORLD_BUSH_1		; $49c1
	jr z,+			; $49c3
.ifdef ROM_AGES
	ld a,TILEINDEX_OVERWORLD_BUSH_1		; $49c5
.else
	ld a,$20		; $49c5
.endif
+
	call objectMimicBgTile		; $49c7
	ld a,$05		; $49ca
	call interactionSetAnimation		; $49cc
	jp objectSetVisible80		; $49cf

@state1:
	ld a,(wScrollMode)		; $49d2
	and SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02			; $49d5
	ret nz			; $49d7

	ld e,Interaction.subid		; $49d8
	ld a,(de)		; $49da
	bit 7,a			; $49db
	jr nz,@subid80State1	; $49dd

	call objectSetPriorityRelativeToLink_withTerrainEffects		; $49df
	call interactionAnimate		; $49e2
	ld c,$20		; $49e5
	call objectCheckLinkWithinDistance		; $49e7
	ld e,Interaction.var39		; $49ea
	jr c,@linkIsClose	; $49ec

	; Link not close
	ld a,(de)		; $49ee
	or a			; $49ef
	ret z			; $49f0
	xor a			; $49f1
	ld (de),a		; $49f2
	ld a,$03		; $49f3
	jp interactionSetAnimation		; $49f5

@linkIsClose:
	ld a,(de)		; $49f8
	or a			; $49f9
	jr nz,++		; $49fa
	inc a			; $49fc
	ld (de),a		; $49fd
	ld a,$01		; $49fe
	jp interactionSetAnimation		; $4a00
++
	ld e,Interaction.pressedAButton		; $4a03
	ld a,(de)		; $4a05
	or a			; $4a06
	ret z			; $4a07

	; Link talked to the scrub
	call interactionIncState		; $4a08
	ld a,$02		; $4a0b
	call interactionSetAnimation		; $4a0d
	ld e,Interaction.subid		; $4a10
	ld a,(de)		; $4a12
	ld hl,@offerItemTextIndices		; $4a13
	rst_addAToHl			; $4a16
	ld c,(hl)		; $4a17
	ld b,>TX_4500		; $4a18
	jp showTextNonExitable		; $4a1a

; Subid $80: the bush above the scrub
@subid80State1:
	ld e,Interaction.relatedObj2		; $4a1d
	ld a,(de)		; $4a1f
	ld h,a			; $4a20
	ld l,Interaction.visible		; $4a21
	ld a,(hl)		; $4a23
	ld e,Interaction.visible		; $4a24
	ld (de),a		; $4a26
	ld l,Interaction.yh		; $4a27
	ld b,(hl)		; $4a29
	ld l,Interaction.animParameter		; $4a2a
	ld a,(hl)		; $4a2c
	ld hl,@bushYOffsets		; $4a2d
	rst_addAToHl			; $4a30
	ld e,Interaction.yh		; $4a31
	ldi a,(hl)		; $4a33
	add b			; $4a34
	ld (de),a		; $4a35
	ret			; $4a36

@state2:
	call interactionAnimate		; $4a37
	ld a,(wTextIsActive)		; $4a3a
	and $7f			; $4a3d
	ret nz			; $4a3f

	; Link just finished talking to the scrub
	ld a,(wSelectedTextOption)		; $4a40
	bit 7,a			; $4a43
	jr z,@label_0b_103	; $4a45

	ld e,Interaction.state		; $4a47
	ld a,$01		; $4a49
	ld (de),a		; $4a4b
	xor a			; $4a4c
	ld (wTextIsActive),a		; $4a4d
	ld e,Interaction.pressedAButton		; $4a50
	ld (de),a		; $4a52
	dec a			; $4a53
	ld (wSelectedTextOption),a		; $4a54
	ld a,$04		; $4a57
	jp interactionSetAnimation		; $4a59

@label_0b_103:
	ld a,(wSelectedTextOption)		; $4a5c
	or a			; $4a5f
	jr z,@agreedToBuy	; $4a60

	; Declined to buy
	ld bc,TX_4506		; $4a62
	jr @showText		; $4a65

@agreedToBuy:
	ld e,Interaction.subid		; $4a67
	ld a,(de)		; $4a69
	ld hl,@rupeeValues		; $4a6a
	rst_addAToHl			; $4a6d
	ld a,(hl)		; $4a6e
	ld e,Interaction.var38		; $4a6f
	ld (de),a		; $4a71
	call cpRupeeValue		; $4a72
	jr z,@enoughRupees	; $4a75

	; Not enough rupees
	ld bc,TX_4507		; $4a77
	jr @showText		; $4a7a

@enoughRupees:
	ld e,Interaction.subid		; $4a7c
	ld a,(de)		; $4a7e
	ld hl,@treasuresToSell		; $4a7f
	rst_addDoubleIndex			; $4a82
	ld a,(hl)		; $4a83
	cp TREASURE_BOMBS			; $4a84
	jr z,@giveBombs	; $4a86
	cp TREASURE_EMBER_SEEDS			; $4a88
	jr nz,@giveShield	; $4a8a

@giveEmberSeeds:
	ld a,(wSeedSatchelLevel)		; $4a8c
	ld bc,@maxSatchelCapacities-1		; $4a8f
	call addAToBc		; $4a92
	ld a,(bc)		; $4a95
	ld c,a			; $4a96
	ld a,(wNumEmberSeeds)		; $4a97
	cp c			; $4a9a
	jr nz,@giveTreasure	; $4a9b
	jr @alreadyHaveTreasure		; $4a9d

@giveBombs:
	ld bc,wNumBombs		; $4a9f
	ld a,(bc)		; $4aa2
	inc c			; $4aa3
	ld e,a			; $4aa4
	ld a,(bc)		; $4aa5
	cp e			; $4aa6
	jr nz,@giveTreasure	; $4aa7
	jr @alreadyHaveTreasure		; $4aa9

@giveShield:
	call checkTreasureObtained		; $4aab
	jr nc,@giveTreasure	; $4aae

@alreadyHaveTreasure:
	ld bc,TX_4508		; $4ab0
	jr @showText		; $4ab3

@giveTreasure:
	ldi a,(hl)		; $4ab5
	ld c,(hl)		; $4ab6
	call giveTreasure		; $4ab7
	ld e,Interaction.var38		; $4aba
	ld a,(de)		; $4abc
	call removeRupeeValue		; $4abd
	ld a,SND_GETSEED		; $4ac0
	call playSound		; $4ac2
	ld bc,TX_4505		; $4ac5
@showText:
	jp showText		; $4ac8

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
	ld e,Interaction.state		; $4b0b
	ld a,(de)		; $4b0d
	rst_jumpTable			; $4b0e
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4b13
	ld (de),a		; $4b15
	call interactionInitGraphics		; $4b16
	ld e,Interaction.subid		; $4b19
	ld a,(de)		; $4b1b
	ld hl,@positions		; $4b1c
	rst_addDoubleIndex			; $4b1f
	ldi a,(hl)		; $4b20
	ld e,Interaction.yh		; $4b21
	ld (de),a		; $4b23
	inc e			; $4b24
	inc e			; $4b25
	ld a,(hl)		; $4b26
	ld (de),a		; $4b27
	jp objectSetVisible82		; $4b28

@positions:
	.db $18 $5c ; 0 == [subid]
	.db $40 $40 ; 1
	.db $38 $88 ; 2

@state1:
	jp interactionAnimate		; $4b31


; ==============================================================================
; INTERACID_COMPANION_TUTORIAL
; ==============================================================================
interactionCoded0:
	ld e,Interaction.state		; $4b34
	ld a,(de)		; $4b36
	rst_jumpTable			; $4b37
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $4b3e
	ld (de),a		; $4b40
	ret			; $4b41

@state1:
	ld a,$02		; $4b42
	ld (de),a		; $4b44
	ld a,(w1Companion.enabled)		; $4b45
	or a			; $4b48
	jr z,@deleteIfSubid2Or5	; $4b49

	; Verify that the correct companion is on-screen, otherwise delete self
	ld e,Interaction.subid		; $4b4b
	ld a,(de)		; $4b4d
	srl a			; $4b4e
	add SPECIALOBJECTID_FIRST_COMPANION			; $4b50
	cp SPECIALOBJECTID_LAST_COMPANION+1			; $4b52
	jr c,+			; $4b54
	ld a,SPECIALOBJECTID_MOOSH		; $4b56
+
	ld hl,w1Companion.id		; $4b58
	cp (hl)			; $4b5b
	jr nz,@delete	; $4b5c

	; Delete self if tutorial text was already shown
	ld a,(de)		; $4b5e
	ld hl,@flagNumbers		; $4b5f
	rst_addAToHl			; $4b62
	ld a,(hl)		; $4b63
	ld hl,wCompanionTutorialTextShown		; $4b64
	call checkFlag		; $4b67
	jr nz,@delete	; $4b6a

	; Check whether to dismount? (subid 2 only)
	ld a,(de)		; $4b6c
	cp $02			; $4b6d
	jr nz,++		; $4b6f
	ld a,(wLinkObjectIndex)		; $4b71
	rra			; $4b74
	ld a,(de)		; $4b75
	jr nc,++		; $4b76
	ld (wForceCompanionDismount),a		; $4b78
++
	ld hl,@tutorialTextToShow		; $4b7b
	rst_addDoubleIndex			; $4b7e
	ldi a,(hl)		; $4b7f
	ld c,a			; $4b80
	ld b,(hl)		; $4b81
	ld a,(wLinkObjectIndex)		; $4b82
	bit 0,a			; $4b85
	call nz,showText		; $4b87

@deleteIfSubid2Or5:
	ld e,Interaction.subid		; $4b8a
	ld a,(de)		; $4b8c
	cp $02			; $4b8d
	jr z,@delete	; $4b8f
	cp $05			; $4b91
	ret nz			; $4b93
@delete:
	jp interactionDelete		; $4b94

@state2:
	ld a,(w1Companion.enabled)		; $4b97
	or a			; $4b9a
	ret z			; $4b9b
	ld e,Interaction.subid		; $4b9c
	ld a,(de)		; $4b9e
	rst_jumpTable			; $4b9f
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
	ld e,Interaction.yh		; $4bac
	ld a,(de)		; $4bae
	ld hl,w1Companion.yh		; $4baf
	cp (hl)			; $4bb2
	ret nc			; $4bb3
	jr @setFlagAndDelete		; $4bb4

@setFlagAndDeleteWhenCompanionIsAboveAndVar38NonZero:
	ld a,(w1Companion.var38)		; $4bb6
	or a			; $4bb9
	ret z			; $4bba

@setFlagAndDeleteWhenCompanionIsAbove:
	call @cpYToCompanion		; $4bbb
	ret c			; $4bbe

@setFlagAndDelete:
	ld e,Interaction.subid		; $4bbf
	ld a,(de)		; $4bc1
	ld hl,@flagNumbers		; $4bc2
	rst_addAToHl			; $4bc5
	ld a,(hl)		; $4bc6
	ld hl,wCompanionTutorialTextShown		; $4bc7
	call setFlag		; $4bca

@goToDelete:
	jr @delete		; $4bcd

.ifdef ROM_AGES
@setFlagAndDeleteWhenCompanionIsAboveAndLinkInXRange:
	call @checkLinkInXRange		; $4bcf
	ret nz			; $4bd2
	jr @setFlagAndDeleteWhenCompanionIsAbove		; $4bd3

@setFlagAndDeleteWhenCompanionIsLeft:
	ld e,Interaction.xh		; $4bd5
	ld a,(de)		; $4bd7
	ld hl,w1Companion.xh		; $4bd8
	cp (hl)			; $4bdb
	ret nc			; $4bdc
	jr @setFlagAndDelete		; $4bdd

@setFlagAndDeleteWhenCompanionIsBelowOrRight:
	call @cpYToCompanion		; $4bdf
	jr c,@setFlagAndDelete	; $4be2
	ld e,Interaction.xh		; $4be4
	ld a,(de)		; $4be6
	ld hl,w1Companion.xh		; $4be7
	cp (hl)			; $4bea
	ret c			; $4beb
	jr @setFlagAndDelete		; $4bec
.endif

;;
; @addr{4bee}
@cpYToCompanion:
	ld e,Interaction.yh		; $4bee
	ld a,(de)		; $4bf0
	ld hl,w1Companion.yh		; $4bf1
	cp (hl)			; $4bf4
	ret			; $4bf5

;;
; @param[out]	zflag	z if Link is within a certain range of X-positions for certain
;			rooms?
; @addr{4bf6}
@checkLinkInXRange:
	ld a,(wActiveRoom)		; $4bf6
	ld hl,@rooms		; $4bf9
	ld b,$00		; $4bfc
--
	cp (hl)			; $4bfe
	jr z,++			; $4bff
	inc b			; $4c01
	inc hl			; $4c02
	jr --			; $4c03
++
	ld a,b			; $4c05
	ld hl,@xRanges		; $4c06
	rst_addDoubleIndex			; $4c09
	ld a,(w1Link.xh)		; $4c0a
	cp (hl)			; $4c0d
	jr c,++			; $4c0e
	inc hl			; $4c10
	cp (hl)			; $4c11
	jr nc,++		; $4c12
	xor a			; $4c14
	ret			; $4c15
++
	or d			; $4c16
	ret			; $4c17

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
.else
@rooms:
	.db <ROOM_SEASONS_036
	.db <ROOM_SEASONS_037
	.db <ROOM_SEASONS_027

@xRanges:
	.db $40 $70
	.db $10 $30
	.db $40 $80

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
	ld e,Interaction.state		; $4c33
	ld a,(de)		; $4c35
	rst_jumpTable			; $4c36
	.dw @state0
	.dw interactionRunScript

@state0:
	ld a,$01		; $4c3b
	ld (de),a		; $4c3d
	ld c,a			; $4c3e
	callab bank1.loadDeathRespawnBufferPreset		; $4c3f
	ld hl,gameCompleteDialogScript		; $4c47
	jp interactionSetScript		; $4c4a


; ==============================================================================
; INTERACID_TITLESCREEN_CLOUDS
; ==============================================================================
interactionCoded2:
	ld e,Interaction.state		; $4c4d
	ld a,(de)		; $4c4f
	rst_jumpTable			; $4c50
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4c55
	ld (de),a		; $4c57
	call interactionInitGraphics		; $4c58
	ld e,Interaction.subid		; $4c5b
	ld a,(de)		; $4c5d
	ld hl,@positions		; $4c5e
	rst_addDoubleIndex			; $4c61
	ldi a,(hl)		; $4c62
	ld b,(hl)		; $4c63
	ld h,d			; $4c64
	ld l,Interaction.var37		; $4c65
	ld (hl),a		; $4c67
	ld l,Interaction.yh		; $4c68
	ldi (hl),a		; $4c6a
	inc l			; $4c6b
	ld (hl),b		; $4c6c

	ld l,Interaction.angle		; $4c6d
	ld (hl),ANGLE_DOWN		; $4c6f
	ld l,Interaction.speed		; $4c71
	ld (hl),SPEED_20		; $4c73
	ret			; $4c75

@positions:
	.db $bf $7c ; 0 == [subid]
	.db $bf $2a ; 1
	.db $9f $94 ; 2
	.db $a3 $10 ; 3


@state1:
	ld a,(wGfxRegs1.SCY)		; $4c7e
	ld b,a			; $4c81
	ld e,Interaction.var37		; $4c82
	ld a,(de)		; $4c84
	sub b			; $4c85
	inc e			; $4c86
	ld e,Interaction.yh		; $4c87
	ld (de),a		; $4c89

	call checkInteractionState2		; $4c8a
	jr nz,@substate1	; $4c8d

@substate0:
	ld a,(wGfxRegs1.SCY)		; $4c8f
	cp $e0			; $4c92
	ret nz			; $4c94
	call interactionIncState2		; $4c95
	call objectSetVisible82		; $4c98

@substate1:
	ld a,(wGfxRegs1.SCY)		; $4c9b
	cp $88			; $4c9e
	ret z			; $4ca0

;;
; This is used by INTERACID_TITLESCREEN_CLOUDS and INTERACID_INTRO_BIRD.
; @param[out]	a	X position
; @addr{4ca1}
_introObject_applySpeed:
	ld h,d			; $4ca1
	ld l,Interaction.angle		; $4ca2
	ld c,(hl)		; $4ca4
	ld l,Interaction.speed		; $4ca5
	ld b,(hl)		; $4ca7
	call getPositionOffsetForVelocity		; $4ca8
	ret z			; $4cab

	ld e,Interaction.var36		; $4cac
	ld a,(de)		; $4cae
	add (hl)		; $4caf
	ld (de),a		; $4cb0
	inc e			; $4cb1
	inc l			; $4cb2
	ld a,(de)		; $4cb3
	adc (hl)		; $4cb4
	ld (de),a		; $4cb5

	ld e,Interaction.x		; $4cb6
	inc l			; $4cb8
	ld a,(de)		; $4cb9
	add (hl)		; $4cba
	ld (de),a		; $4cbb
	inc e			; $4cbc
	inc l			; $4cbd
	ld a,(de)		; $4cbe
	adc (hl)		; $4cbf
	ld (de),a		; $4cc0
	ret			; $4cc1


; ==============================================================================
; INTERACID_INTRO_BIRD
; ==============================================================================
interactionCoded3:
	ld e,Interaction.state		; $4cc2
	ld a,(de)		; $4cc4
	rst_jumpTable			; $4cc5
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4cca
	ld (de),a		; $4ccc
	call interactionInitGraphics		; $4ccd

	; counter2: How long the bird should remain (it will respawn if it goes off-screen
	; before counter2 reaches 0)
	ld h,d			; $4cd0
	ld l,Interaction.counter2		; $4cd1
	ld (hl),45		; $4cd3

	; Determine direction to move in based on subid
	ld l,Interaction.subid		; $4cd5
	ld a,(hl)		; $4cd7
	ld b,$00		; $4cd8
	ld c,$1a		; $4cda
	cp $04			; $4cdc
	jr c,+			; $4cde
	inc b			; $4ce0
	ld c,$06		; $4ce1
+
	ld l,Interaction.angle		; $4ce3
	ld (hl),c		; $4ce5
	ld l,Interaction.speed		; $4ce6
	ld (hl),SPEED_140		; $4ce8

	push af			; $4cea
	ld a,b			; $4ceb
	call interactionSetAnimation		; $4cec

	pop af			; $4cef

@initializePositionAndCounter1:
	ld b,a			; $4cf0
	add a			; $4cf1
	add b			; $4cf2
	ld hl,@birdPositionsAndAppearanceDelays		; $4cf3
	rst_addAToHl			; $4cf6
	ldi a,(hl)		; $4cf7
	ld b,(hl)		; $4cf8
	inc l			; $4cf9
	ld c,(hl)		; $4cfa
	ld h,d			; $4cfb
	ld l,Interaction.var37		; $4cfc
	ld (hl),a		; $4cfe
	ld l,Interaction.yh		; $4cff
	ldi (hl),a		; $4d01
	inc l			; $4d02
	ld (hl),b		; $4d03
	ld l,Interaction.counter1		; $4d04
	ld (hl),c		; $4d06
	ret			; $4d07

@state1:
	; Update Y
	ld a,(wGfxRegs1.SCY)		; $4d08
	ld b,a			; $4d0b
	ld e,Interaction.var37		; $4d0c
	ld a,(de)		; $4d0e
	sub b			; $4d0f
	inc e			; $4d10
	ld e,Interaction.yh		; $4d11
	ld (de),a		; $4d13

	ld e,Interaction.state2		; $4d14
	ld a,(de)		; $4d16
	rst_jumpTable			; $4d17
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wGfxRegs1.SCY)		; $4d1e
	cp $10			; $4d21
	ret nz			; $4d23
	jp interactionIncState2		; $4d24

@substate1:
	call interactionDecCounter1		; $4d27
	ret nz			; $4d2a
	call interactionIncState2		; $4d2b
	jp objectSetVisible82		; $4d2e

@substate2:
	ld e,Interaction.counter2		; $4d31
	ld a,(de)		; $4d33
	or a			; $4d34
	jr z,+			; $4d35
	dec a			; $4d37
	ld (de),a		; $4d38
+
	call interactionAnimate		; $4d39
	call _introObject_applySpeed		; $4d3c
	cp $b0			; $4d3f
	ret c			; $4d41

	; Bird is off-screen; check whether to "reset" the bird or just delete it.
	ld h,d			; $4d42
	ld l,Interaction.counter2		; $4d43
	ld a,(hl)		; $4d45
	or a			; $4d46
	jp z,interactionDelete		; $4d47

	ld l,Interaction.state2		; $4d4a
	dec (hl)		; $4d4c
	ld l,Interaction.subid		; $4d4d
	ld a,(hl)		; $4d4f
	call @initializePositionAndCounter1		; $4d50

	; Set counter1 (the delay before reappearing) randomly
	call getRandomNumber_noPreserveVars		; $4d53
	and $0f			; $4d56
	ld h,d			; $4d58
	ld l,Interaction.counter1		; $4d59
	ld (hl),a		; $4d5b
	jp objectSetInvisible		; $4d5c


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
	ld e,Interaction.state		; $4d77
	ld a,(de)		; $4d79
	rst_jumpTable			; $4d7a
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4d7f
	ld (de),a		; $4d81
	ld h,d			; $4d82
	ld l,Interaction.subid		; $4d83
	ld a,(hl)		; $4d85
	ld b,a			; $4d86
	and $0f			; $4d87
	ld (hl),a		; $4d89

	ld a,b			; $4d8a
	swap a			; $4d8b
	and $0f			; $4d8d
	add a			; $4d8f
	add a			; $4d90
	ld l,Interaction.counter1		; $4d91
	ld (hl),a		; $4d93

	call interactionInitGraphics		; $4d94
	jp objectSetVisible82		; $4d97

@state1:
	ld e,Interaction.subid		; $4d9a
	ld a,(de)		; $4d9c
	cp $02			; $4d9d
	ret z			; $4d9f

	call interactionDecCounter1		; $4da0
	ld e,Interaction.subid		; $4da3
	ld a,(de)		; $4da5
	or a			; $4da6
	jr nz,@seagull	; $4da7

@ship:
	; Update the "bobbing" of the ship using the Z position (every 32 frames)
	ld a,(wFrameCounter)		; $4da9
	ld b,a			; $4dac
	and $1f			; $4dad
	ret nz			; $4daf

	ld a,b			; $4db0
	and $e0			; $4db1
	swap a			; $4db3
	rrca			; $4db5
	ld hl,@zPositions		; $4db6
	rst_addAToHl			; $4db9
	ld e,Interaction.zh		; $4dba
	ld a,(hl)		; $4dbc
	ld (de),a		; $4dbd
	ret			; $4dbe

@zPositions:
	.db $00 $ff $ff $00 $00 $01 $01 $00


@seagull:
	; Similarly update the "bobbing" of the seagull, but more frequently
	ld a,(hl) ; [counter1]
	and $07			; $4dc8
	ret nz			; $4dca

	ld a,(hl)		; $4dcb
	and $38			; $4dcc
	swap a			; $4dce
	rlca			; $4dd0
	ld hl,@zPositions		; $4dd1
	rst_addAToHl			; $4dd4
	ld e,Interaction.zh		; $4dd5
	ld a,(hl)		; $4dd7
	ld (de),a		; $4dd8
	ret			; $4dd9
