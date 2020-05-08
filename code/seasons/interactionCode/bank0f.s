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


interactionCodec8:
	ld e,$44		; $7884
	ld a,(de)		; $7886
	rst_jumpTable			; $7887
	adc h			; $7888
	ld a,b			; $7889
	and l			; $788a
	ld a,b			; $788b
	ld a,$01		; $788c
	ld (de),a		; $788e
	ld a,$28		; $788f
	ld e,$78		; $7891
	ld (de),a		; $7893
	call interactionInitGraphics		; $7894
	call objectGetTileAtPosition		; $7897
	ld (hl),$00		; $789a
	ld hl,$7b03		; $789c
	call interactionSetScript		; $789f
	call $78cc		; $78a2
	call interactionRunScript		; $78a5
	call interactionPushLinkAwayAndUpdateDrawPriority		; $78a8
	ld e,$45		; $78ab
	ld a,(de)		; $78ad
	rst_jumpTable			; $78ae
	or e			; $78af
	ld a,b			; $78b0
.DB $d3				; $78b1
	ld a,b			; $78b2
	ld h,d			; $78b3
	ld l,$78		; $78b4
	dec (hl)		; $78b6
	ret nz			; $78b7
	call interactionIncState2		; $78b8
	ld b,$c9		; $78bb
	call objectCreateInteractionWithSubid00		; $78bd
	jr nz,_label_0f_333	; $78c0
	ld l,$56		; $78c2
	ld (hl),e		; $78c4
	inc l			; $78c5
	ld (hl),d		; $78c6
_label_0f_333:
	ld h,d			; $78c7
	ld l,$77		; $78c8
	ld (hl),$01		; $78ca
	ld l,$60		; $78cc
	ld (hl),$01		; $78ce
	jp interactionAnimate		; $78d0
	ld e,$77		; $78d3
	ld a,(de)		; $78d5
	or a			; $78d6
	ret nz			; $78d7
	ld h,d			; $78d8
	ld l,$45		; $78d9
	dec (hl)		; $78db
	call $78cc		; $78dc
	call getRandomNumber_noPreserveVars		; $78df
	and $3f			; $78e2
	add $3c			; $78e4
	ld e,$78		; $78e6
	ld (de),a		; $78e8
	ret			; $78e9

interactionCodec9:
	ld e,$44		; $78ea
	ld a,(de)		; $78ec
	rst_jumpTable			; $78ed
	ld a,($ff00+c)		; $78ee
	ld a,b			; $78ef
	add hl,bc		; $78f0
	ld a,c			; $78f1
	ld a,$01		; $78f2
	ld (de),a		; $78f4
	call interactionInitGraphics		; $78f5
	ld h,d			; $78f8
	ld bc,$4128		; $78f9
	ld l,$50		; $78fc
	ld (hl),b		; $78fe
	ld l,$46		; $78ff
	ld (hl),c		; $7901
	ld l,$49		; $7902
	ld (hl),$18		; $7904
	jp objectSetVisible82		; $7906
	ld e,$45		; $7909
	ld a,(de)		; $790b
	rst_jumpTable			; $790c
	ld de,$2f79		; $790d
	ld a,c			; $7910
	call interactionDecCounter1		; $7911
	jr nz,_label_0f_334	; $7914
	ld l,$49		; $7916
	ld (hl),$08		; $7918
	call interactionIncState2		; $791a
_label_0f_334:
	call objectApplySpeed		; $791d
_label_0f_335:
	ld h,d			; $7920
	ld l,$61		; $7921
	ld a,(hl)		; $7923
	or a			; $7924
	ld (hl),$00		; $7925
	ld a,$78		; $7927
	call nz,playSound		; $7929
	jp interactionAnimate		; $792c
	call objectApplySpeed		; $792f
	call objectGetRelatedObject1Var		; $7932
	ld l,$4d		; $7935
	ld e,l			; $7937
	ld a,(de)		; $7938
	add $08			; $7939
	cp (hl)			; $793b
	jr c,_label_0f_335	; $793c
	ld l,$77		; $793e
	ld (hl),$00		; $7940
	jp interactionDelete		; $7942

interactionCodeca:
	ld e,$44		; $7945
	ld a,(de)		; $7947
	rst_jumpTable			; $7948
	ld c,a			; $7949
	ld a,c			; $794a
	adc c			; $794b
	ld a,c			; $794c
	sub h			; $794d
	ld a,c			; $794e
	ld a,$28		; $794f
	call checkGlobalFlag		; $7951
	jp z,interactionDelete		; $7954
	call interactionInitGraphics		; $7957
	call interactionIncState		; $795a
	call $7aa7		; $795d
	ld a,$4c		; $7960
	call interactionSetHighTextIndex		; $7962
	ld a,$5a		; $7965
	call checkGlobalFlag		; $7967
	jr z,_label_0f_336	; $796a
	ld hl,$7bfc		; $796c
	jr _label_0f_337		; $796f
_label_0f_336:
	ld a,$50		; $7971
	call checkGlobalFlag		; $7973
	ld hl,$7b06		; $7976
	jr z,_label_0f_337	; $7979
	ld hl,$7b30		; $797b
_label_0f_337:
	call interactionSetScript		; $797e
	ld a,$02		; $7981
	call interactionSetAnimation		; $7983
	jp interactionAnimateAsNpc		; $7986
	call interactionRunScript		; $7989
	ld e,$7b		; $798c
	ld a,(de)		; $798e
	or a			; $798f
	ret nz			; $7990
	jp npcFaceLinkAndAnimate		; $7991
	call $79df		; $7994
	call interactionDecCounter1		; $7997
	jr nz,_label_0f_338	; $799a
	ld (hl),$b4		; $799c
	call $7a0d		; $799e
_label_0f_338:
	ld hl,$ccf8		; $79a1
	ldi a,(hl)		; $79a4
	cp $30			; $79a5
	jr nz,_label_0f_339	; $79a7
	ld a,(hl)		; $79a9
	cp $00			; $79aa
	jr nz,_label_0f_339	; $79ac
	ld a,$01		; $79ae
	jr _label_0f_340		; $79b0
_label_0f_339:
	ld h,d			; $79b2
	ld l,$78		; $79b3
	ld a,(hl)		; $79b5
	cp $0c			; $79b6
	ret nz			; $79b8
	ld a,($cc30)		; $79b9
	or a			; $79bc
	ret nz			; $79bd
	ld a,$00		; $79be
_label_0f_340:
	ld h,d			; $79c0
	ld l,$7a		; $79c1
	ld (hl),a		; $79c3
	ld l,$44		; $79c4
	ld (hl),$01		; $79c6
	ld hl,$6430		; $79c8
	ld e,$15		; $79cb
	call interBankCall		; $79cd
	ld hl,$7b64		; $79d0
	call interactionSetScript		; $79d3
	ret			; $79d6
	ld hl,$ccf7		; $79d7
	xor a			; $79da
	ldi (hl),a		; $79db
	ldi (hl),a		; $79dc
	ld (hl),a		; $79dd
	ret			; $79de
	ld hl,$ccf7		; $79df
	ldi a,(hl)		; $79e2
	cp $59			; $79e3
	jr nz,_label_0f_341	; $79e5
	ldi a,(hl)		; $79e7
	cp $59			; $79e8
	jr nz,_label_0f_341	; $79ea
	ld a,(hl)		; $79ec
	cp $99			; $79ed
	ret z			; $79ef
_label_0f_341:
	ld hl,$ccf7		; $79f0
	call $7a01		; $79f3
	ret nz			; $79f6
	inc hl			; $79f7
	call $7a01		; $79f8
	ret nz			; $79fb
	inc hl			; $79fc
	ld b,$00		; $79fd
	jr _label_0f_342		; $79ff
	ld b,$60		; $7a01
_label_0f_342:
	ld a,(hl)		; $7a03
	add $01			; $7a04
	daa			; $7a06
	cp b			; $7a07
	jr nz,_label_0f_343	; $7a08
	xor a			; $7a0a
_label_0f_343:
	ld (hl),a		; $7a0b
	ret			; $7a0c
	ld a,$04		; $7a0d
	ld hl,$cc30		; $7a0f
	sub (hl)		; $7a12
	ret z			; $7a13
	ldh (<hFF8D),a	; $7a14
	call getRandomNumber		; $7a16
	and $03			; $7a19
	ld e,$79		; $7a1b
	ld (de),a		; $7a1d
	xor a			; $7a1e
_label_0f_344:
	inc a			; $7a1f
	ldh (<hFF8B),a	; $7a20
	ld h,d			; $7a22
	ld l,$78		; $7a23
	ld a,(hl)		; $7a25
	cp $0c			; $7a26
	jr z,_label_0f_346	; $7a28
	inc a			; $7a2a
	ld (hl),a		; $7a2b
	ld hl,$7a3c		; $7a2c
	rst_addAToHl			; $7a2f
	ld a,(hl)		; $7a30
	call $7a49		; $7a31
	ldh a,(<hFF8B)	; $7a34
	ld hl,$ff8d		; $7a36
	cp (hl)			; $7a39
_label_0f_345:
	jr nz,_label_0f_344	; $7a3a
_label_0f_346:
	ret			; $7a3c
	nop			; $7a3d
	nop			; $7a3e
	nop			; $7a3f
	nop			; $7a40
	ld bc,$0201		; $7a41
	inc bc			; $7a44
	inc b			; $7a45
	dec b			; $7a46
	ld b,$07		; $7a47
	ld bc,$7a76		; $7a49
	call addDoubleIndexToBc		; $7a4c
	call getFreeEnemySlot		; $7a4f
	ret nz			; $7a52
	ld a,(bc)		; $7a53
	ldi (hl),a		; $7a54
	inc bc			; $7a55
	ld a,(bc)		; $7a56
	ldi (hl),a		; $7a57
	ld e,$79		; $7a58
	ld a,(de)		; $7a5a
	inc a			; $7a5b
	and $03			; $7a5c
	ld (de),a		; $7a5e
	ld bc,$7a86		; $7a5f
	call addDoubleIndexToBc		; $7a62
	ld l,$8b		; $7a65
	ld a,(bc)		; $7a67
	ld (hl),a		; $7a68
	inc bc			; $7a69
	ld l,$8d		; $7a6a
	ld a,(bc)		; $7a6c
	ld (hl),a		; $7a6d
	ld l,$81		; $7a6e
	ld a,(hl)		; $7a70
	cp $10			; $7a71
	ret z			; $7a73
	jr _label_0f_347		; $7a74
	stop			; $7a76
	ld bc,$0020		; $7a77
	ld c,b			; $7a7a
	nop			; $7a7b
	ld c,b			; $7a7c
	ld bc,$0140		; $7a7d
	ld b,b			; $7a80
	ld (bc),a		; $7a81
	dec c			; $7a82
	nop			; $7a83
	dec c			; $7a84
	ld bc,$4030		; $7a85
	jr nc,_label_0f_345	; $7a88
	add b			; $7a8a
	ld b,b			; $7a8b
	add b			; $7a8c
	or b			; $7a8d
_label_0f_347:
	ld e,$79		; $7a8e
	ld a,(de)		; $7a90
	ld bc,$7a86		; $7a91
	call addDoubleIndexToBc		; $7a94
	call getFreeInteractionSlot		; $7a97
	ret nz			; $7a9a
	ld (hl),$05		; $7a9b
	ld l,$4b		; $7a9d
	ld a,(bc)		; $7a9f
	ld (hl),a		; $7aa0
	inc bc			; $7aa1
	ld l,$4d		; $7aa2
	ld a,(bc)		; $7aa4
	ld (hl),a		; $7aa5
	ret			; $7aa6
	ld a,$05		; $7aa7
	call checkTreasureObtained		; $7aa9
	jr nc,_label_0f_349	; $7aac
	cp $03			; $7aae
	jp nc,_label_0f_349		; $7ab0
	sub $01			; $7ab3
_label_0f_348:
	ld e,$43		; $7ab5
	ld (de),a		; $7ab7
	ret			; $7ab8
_label_0f_349:
	ld a,$01		; $7ab9
	jr _label_0f_348		; $7abb

interactionCodecb:
	ld e,$44		; $7abd
	ld a,(de)		; $7abf
	rst_jumpTable			; $7ac0
	ret			; $7ac1
	ld a,d			; $7ac2
	ld (hl),b		; $7ac3
	ld a,e			; $7ac4
	cp a			; $7ac5
	ld a,e			; $7ac6
	di			; $7ac7
	ld a,e			; $7ac8
	ld e,$42		; $7ac9
	ld a,(de)		; $7acb
	rst_jumpTable			; $7acc
	push de			; $7acd
	ld a,d			; $7ace
	dec bc			; $7acf
	ld a,e			; $7ad0
	dec bc			; $7ad1
	ld a,e			; $7ad2
	ld d,c			; $7ad3
	ld a,e			; $7ad4
	ld a,$28		; $7ad5
	call checkGlobalFlag		; $7ad7
	jp z,interactionDelete		; $7ada
	call interactionInitGraphics		; $7add
	call interactionIncState		; $7ae0
	ld l,$79		; $7ae3
	ld (hl),$78		; $7ae5
	ld a,$4c		; $7ae7
	call interactionSetHighTextIndex		; $7ae9
	ld a,$5b		; $7aec
	call checkGlobalFlag		; $7aee
	jr z,_label_0f_350	; $7af1
	ld hl,$7cbf		; $7af3
	jr _label_0f_351		; $7af6
_label_0f_350:
	ld a,$51		; $7af8
	call checkGlobalFlag		; $7afa
	ld hl,$7bff		; $7afd
	jr z,_label_0f_351	; $7b00
	ld hl,$7c29		; $7b02
_label_0f_351:
	call interactionSetScript		; $7b05
	jp objectSetVisible81		; $7b08
	call interactionInitGraphics		; $7b0b
	ld h,d			; $7b0e
	ld l,$42		; $7b0f
	ld a,(hl)		; $7b11
	ld l,$5c		; $7b12
	ld (hl),a		; $7b14
	ld l,$44		; $7b15
	ld (hl),$02		; $7b17
	ld l,$46		; $7b19
	ld (hl),$1e		; $7b1b
	ld l,$4b		; $7b1d
	ld a,(hl)		; $7b1f
	ld l,$7b		; $7b20
	ld (hl),a		; $7b22
	ld l,$4d		; $7b23
	ld a,(hl)		; $7b25
	ld l,$7c		; $7b26
	ld (hl),a		; $7b28
	call getRandomNumber		; $7b29
	and $02			; $7b2c
	dec a			; $7b2e
	ld e,$7e		; $7b2f
	ld (de),a		; $7b31
	call getRandomNumber		; $7b32
	and $1f			; $7b35
	ld e,$49		; $7b37
	ld (de),a		; $7b39
	call getRandomNumber		; $7b3a
	and $03			; $7b3d
	ld hl,$7b4d		; $7b3f
	rst_addAToHl			; $7b42
	ld a,(hl)		; $7b43
	ld e,$7d		; $7b44
	ld (de),a		; $7b46
	call $7c3f		; $7b47
	jp objectSetVisible81		; $7b4a
	inc bc			; $7b4d
	inc b			; $7b4e
	dec b			; $7b4f
	ld b,$cd		; $7b50
	ld l,e			; $7b52
	add hl,de		; $7b53
	jp z,interactionDelete		; $7b54
	call interactionInitGraphics		; $7b57
	ld h,d			; $7b5a
	ld l,$5c		; $7b5b
	ld (hl),$02		; $7b5d
	ld l,$44		; $7b5f
	ld (hl),$03		; $7b61
	ld l,$7e		; $7b63
	ld (hl),$04		; $7b65
	ld hl,$5779		; $7b67
	call interactionSetScript		; $7b6a
	jp interactionAnimateAsNpc		; $7b6d
	ld e,$45		; $7b70
	ld a,(de)		; $7b72
	rst_jumpTable			; $7b73
	ld a,h			; $7b74
	ld a,e			; $7b75
	adc h			; $7b76
	ld a,e			; $7b77
	sbc b			; $7b78
	ld a,e			; $7b79
	and l			; $7b7a
	ld a,e			; $7b7b
	call interactionAnimate		; $7b7c
	call objectPreventLinkFromPassing		; $7b7f
	call interactionRunScript		; $7b82
	ret nc			; $7b85
	call interactionIncState2		; $7b86
	jp $7c0f		; $7b89
	call $7bf9		; $7b8c
	ret nz			; $7b8f
	ld l,$45		; $7b90
	inc (hl)		; $7b92
	ld l,$79		; $7b93
	ld (hl),$3c		; $7b95
	ret			; $7b97
	call $7bf9		; $7b98
	ret nz			; $7b9b
	ld l,$45		; $7b9c
	inc (hl)		; $7b9e
	ld hl,$7c5e		; $7b9f
	call interactionSetScript		; $7ba2
	call interactionAnimate		; $7ba5
	call objectPreventLinkFromPassing		; $7ba8
	call interactionRunScript		; $7bab
	ret nc			; $7bae
	ld h,d			; $7baf
	ld l,$45		; $7bb0
	ld (hl),$01		; $7bb2
	ld l,$7f		; $7bb4
	ld a,(hl)		; $7bb6
	cp $00			; $7bb7
	jp z,$7c15		; $7bb9
	jp $7c0f		; $7bbc
	call interactionAnimate		; $7bbf
	call $7be1		; $7bc2
	call $7bf9		; $7bc5
	jp z,interactionDelete		; $7bc8
	ld l,$46		; $7bcb
	ld a,(hl)		; $7bcd
	or a			; $7bce
	ret nz			; $7bcf
	ld l,$7d		; $7bd0
	ld a,(hl)		; $7bd2
	ld l,$7b		; $7bd3
	ld b,(hl)		; $7bd5
	ld l,$7c		; $7bd6
	ld c,(hl)		; $7bd8
	ld e,$7f		; $7bd9
	call objectSetPositionInCircleArc		; $7bdb
	jp $7bfe		; $7bde
	ld h,d			; $7be1
	ld l,$46		; $7be2
	ld a,(hl)		; $7be4
	or a			; $7be5
	jr z,_label_0f_352	; $7be6
	dec (hl)		; $7be8
	ld a,(wFrameCounter)		; $7be9
	rrca			; $7bec
	jp nc,objectSetInvisible		; $7bed
_label_0f_352:
	jp objectSetVisible		; $7bf0
	call interactionRunScript		; $7bf3
	jp interactionAnimateAsNpc		; $7bf6
	ld h,d			; $7bf9
	ld l,$79		; $7bfa
	dec (hl)		; $7bfc
	ret			; $7bfd
	ld a,(wFrameCounter)		; $7bfe
	rrca			; $7c01
	ret nc			; $7c02
	ld h,d			; $7c03
	ld l,$7e		; $7c04
	ld b,(hl)		; $7c06
	ld l,$7f		; $7c07
	ld a,(hl)		; $7c09
	add b			; $7c0a
	and $1f			; $7c0b
	ld (hl),a		; $7c0d
	ret			; $7c0e
	ld e,$7a		; $7c0f
	xor a			; $7c11
	ld (de),a		; $7c12
	jr _label_0f_354		; $7c13
	ld e,$7a		; $7c15
	ld a,(de)		; $7c17
	inc a			; $7c18
	cp $03			; $7c19
	jr c,_label_0f_353	; $7c1b
	xor a			; $7c1d
_label_0f_353:
	ld (de),a		; $7c1e
_label_0f_354:
	call $7c3f		; $7c1f
	call getRandomNumber		; $7c22
	and $01			; $7c25
	ld e,$7c		; $7c27
	ld (de),a		; $7c29
	push de			; $7c2a
	call clearEnemies		; $7c2b
	call clearItems		; $7c2e
	call clearParts		; $7c31
	pop de			; $7c34
	xor a			; $7c35
	ld ($cc30),a		; $7c36
	call $7c50		; $7c39
	jp $7cce		; $7c3c
	ld e,$7a		; $7c3f
	ld a,(de)		; $7c41
	ld bc,$7c4d		; $7c42
	call addAToBc		; $7c45
	ld a,(bc)		; $7c48
	ld e,$79		; $7c49
	ld (de),a		; $7c4b
	ret			; $7c4c
	ldh a,(<hMusicVolume)	; $7c4d
	ld a,b			; $7c4f
	ld hl,$cee0		; $7c50
	xor a			; $7c53
_label_0f_355:
	ldi (hl),a		; $7c54
	inc a			; $7c55
	cp $0d			; $7c56
	jr nz,_label_0f_355	; $7c58
	ld e,$7d		; $7c5a
	ld (de),a		; $7c5c
	xor a			; $7c5d
	ld e,$7b		; $7c5e
	ld (de),a		; $7c60
	ret			; $7c61
	ld e,$7d		; $7c62
	ld a,(de)		; $7c64
	ld b,a			; $7c65
	dec a			; $7c66
	ld (de),a		; $7c67
	call getRandomNumber		; $7c68
_label_0f_356:
	sub b			; $7c6b
	jr nc,_label_0f_356	; $7c6c
	add b			; $7c6e
	ld c,a			; $7c6f
	ld hl,$cee0		; $7c70
	rst_addAToHl			; $7c73
	ld a,(hl)		; $7c74
	ld e,$7e		; $7c75
	ld (de),a		; $7c77
	push de			; $7c78
	ld d,c			; $7c79
	ld e,b			; $7c7a
	dec e			; $7c7b
	ld b,h			; $7c7c
	ld c,l			; $7c7d
_label_0f_357:
	ld a,d			; $7c7e
	cp e			; $7c7f
	jr z,_label_0f_358	; $7c80
	inc bc			; $7c82
	ld a,(bc)		; $7c83
	ldi (hl),a		; $7c84
	inc d			; $7c85
	jr _label_0f_357		; $7c86
_label_0f_358:
	pop de			; $7c88
	ret			; $7c89
	ld h,d			; $7c8a
	ld l,$7a		; $7c8b
	ld a,(hl)		; $7c8d
	swap a			; $7c8e
	ld l,$7b		; $7c90
	add (hl)		; $7c92
	ld bc,$7c9e		; $7c93
	call addAToBc		; $7c96
	ld a,(bc)		; $7c99
	ld l,$7c		; $7c9a
	xor (hl)		; $7c9c
	ret			; $7c9d
	ld bc,$0101		; $7c9e
	nop			; $7ca1
	nop			; $7ca2
	nop			; $7ca3
	nop			; $7ca4
	nop			; $7ca5
	nop			; $7ca6
	nop			; $7ca7
	nop			; $7ca8
	nop			; $7ca9
	nop			; $7caa
	nop			; $7cab
	nop			; $7cac
	nop			; $7cad
	ld bc,$0101		; $7cae
	ld bc,$0001		; $7cb1
	nop			; $7cb4
	nop			; $7cb5
	nop			; $7cb6
	nop			; $7cb7
	nop			; $7cb8
	nop			; $7cb9
	nop			; $7cba
	nop			; $7cbb
	nop			; $7cbc
	nop			; $7cbd
	ld bc,$0101		; $7cbe
	ld bc,$0101		; $7cc1
	nop			; $7cc4
	nop			; $7cc5
	nop			; $7cc6
	nop			; $7cc7
	nop			; $7cc8
	nop			; $7cc9
	nop			; $7cca
	nop			; $7ccb
	nop			; $7ccc
	nop			; $7ccd
_label_0f_359:
	call getFreeInteractionSlot		; $7cce
	ret nz			; $7cd1
	ld (hl),$cb		; $7cd2
	inc hl			; $7cd4
	push hl			; $7cd5
	call $7c8a		; $7cd6
	pop hl			; $7cd9
	inc a			; $7cda
	ld (hl),a		; $7cdb
	ld e,$7a		; $7cdc
	ld a,(de)		; $7cde
	ld l,$7a		; $7cdf
	ld (hl),a		; $7ce1
	push hl			; $7ce2
	call $7c62		; $7ce3
	pop hl			; $7ce6
	ld e,$7e		; $7ce7
	ld a,(de)		; $7ce9
	ld bc,$7d03		; $7cea
	call addDoubleIndexToBc		; $7ced
	ld l,$4b		; $7cf0
	ld a,(bc)		; $7cf2
	ld (hl),a		; $7cf3
	inc bc			; $7cf4
	ld l,$4d		; $7cf5
	ld a,(bc)		; $7cf7
	ld (hl),a		; $7cf8
	ld e,$7b		; $7cf9
	ld a,(de)		; $7cfb
	inc a			; $7cfc
	ld (de),a		; $7cfd
	cp $0d			; $7cfe
	jr nz,_label_0f_359	; $7d00
	ret			; $7d02
	inc e			; $7d03
	jr nz,$1c	; $7d04
	ld b,b			; $7d06
	inc e			; $7d07
	ld h,b			; $7d08
	inc e			; $7d09
	add b			; $7d0a
	inc (hl)		; $7d0b
	jr nc,_label_0f_361	; $7d0c
	ld d,b			; $7d0e
	inc (hl)		; $7d0f
	ld (hl),b		; $7d10
	ld c,h			; $7d11
	jr nz,$4c		; $7d12
	ld b,b			; $7d14
	ld c,h			; $7d15
	ld h,b			; $7d16
	ld c,h			; $7d17
	add b			; $7d18
	ld h,h			; $7d19
	jr nc,$64		; $7d1a
	ld (hl),b		; $7d1c

interactionCodecc:
	ld e,$44		; $7d1d
	ld a,(de)		; $7d1f
	rst_jumpTable			; $7d20
	.dw $7d25
	.dw $7d6d
	ld a,$28		; $7d25
	call checkGlobalFlag		; $7d27
	jp z,interactionDelete		; $7d2a
	ld a,$01		; $7d2d
	ld (de),a		; $7d2f
	ld a,$4c		; $7d30
	call interactionSetHighTextIndex		; $7d32
	call getThisRoomFlags		; $7d35
	and $03			; $7d38
	or a			; $7d3a
	jr z,_label_0f_362	; $7d3b
	ld hl,seasonsTable_0f_7dc7		; $7d3d
	rst_addDoubleIndex			; $7d40
	ldi a,(hl)		; $7d41
_label_0f_361:
	ld h,(hl)		; $7d42
	ld l,a			; $7d43
	jr _label_0f_365		; $7d44
_label_0f_362:
	ld a,$5c		; $7d46
	call checkGlobalFlag		; $7d48
	jr z,_label_0f_363	; $7d4b
	ld hl,$7dac		; $7d4d
	jr _label_0f_365		; $7d50
_label_0f_363:
	call getThisRoomFlags		; $7d52
	bit 7,a			; $7d55
	jr z,_label_0f_364	; $7d57
	ld hl,$7db2		; $7d59
	jr _label_0f_365		; $7d5c
_label_0f_364:
	ld hl,$7cc2		; $7d5e
_label_0f_365:
	call interactionSetScript		; $7d61
	call interactionInitGraphics		; $7d64
	call seasonsFunc_0f_7dc1		; $7d67
	call interactionSetAlwaysUpdateBit		; $7d6a
	call interactionAnimateAsNpc		; $7d6d
	call interactionRunScript		; $7d70
	call seasonsFunc_0f_7dac		; $7d73
	call checkInteractionState2		; $7d76
	ret nz			; $7d79
	call $7d95		; $7d7a
	ld a,$f8		; $7d7d
	call findTileInRoom		; $7d7f
	ret z			; $7d82
	call interactionIncState2		; $7d83
	ld l,$78		; $7d86
	ld a,(hl)		; $7d88
	ld b,$02		; $7d89
	cp $04			; $7d8b
	jr nc,_label_0f_366	; $7d8d
	ld b,$03		; $7d8f
_label_0f_366:
	ld l,$79		; $7d91
	ld (hl),b		; $7d93
	ret			; $7d94
	ld c,$06		; $7d95
	call findItemWithID		; $7d97
	ld h,d			; $7d9a
	jr z,_label_0f_367	; $7d9b
	ld l,$77		; $7d9d
	ld (hl),$00		; $7d9f
	ret			; $7da1
_label_0f_367:
	ld l,$77		; $7da2
	ld a,(hl)		; $7da4
	or a			; $7da5
	ret nz			; $7da6
	ld (hl),$01		; $7da7
	inc l			; $7da9
	inc (hl)		; $7daa
	ret			; $7dab

seasonsFunc_0f_7dac:
	call getThisRoomFlags		; $7dac
	and $03			; $7daf
	or a			; $7db1
	and $01			; $7db2
	ret z			; $7db4
	ld e,$79		; $7db5
	ld a,(de)		; $7db7
	cp $03			; $7db8
	ret nz			; $7dba
	ld c,$20		; $7dbb
	call objectUpdateSpeedZ_paramC		; $7dbd
	ret nz			; $7dc0

seasonsFunc_0f_7dc1:
	ld bc,$ff40		; $7dc1
	jp objectSetSpeedZ		; $7dc4

seasonsTable_0f_7dc7:
	jp nz,$007c		; $7dc7
	.db $7d $87
	.db $7d $00
	.db $7d

interactionCodecd:
	ld e,$44		; $7dcf
	ld a,(de)		; $7dd1
	rst_jumpTable			; $7dd2
	.dw $7dd9
	.dw $7e69
	.dw $7e74
	ld e,$42		; $7dd9
	ld a,(de)		; $7ddb
	rst_jumpTable			; $7ddc
	.dw $7de3
	.dw $7e34
	.dw $7e57
	ld a,$28		; $7de3
	call checkGlobalFlag		; $7de5
	jp z,interactionDelete		; $7de8
	call interactionInitGraphics		; $7deb
	call interactionIncState		; $7dee
	ld a,$4c		; $7df1
	call interactionSetHighTextIndex		; $7df3
	ld a,$5d		; $7df6
	call checkGlobalFlag		; $7df8
	jp z,$7e03		; $7dfb
	ld hl,$7e6c		; $7dfe
	jr _label_0f_369		; $7e01
	ld a,$07		; $7e03
	ld b,$ea		; $7e05
	call getRoomFlags		; $7e07
	and $40			; $7e0a
	jr z,_label_0f_368	; $7e0c
	res 6,(hl)		; $7e0e
	ld hl,$7e48		; $7e10
	jr _label_0f_369		; $7e13
_label_0f_368:
	ld a,$53		; $7e15
	call checkGlobalFlag		; $7e17
	ld hl,$7db8		; $7e1a
	jr z,_label_0f_369	; $7e1d
	ld hl,$7de2		; $7e1f
_label_0f_369:
	call interactionSetScript		; $7e22
	xor a			; $7e25
	ld hl,$cfd0		; $7e26
	ldi (hl),a		; $7e29
	ldi (hl),a		; $7e2a
	ldi (hl),a		; $7e2b
	ld a,$02		; $7e2c
	call interactionSetAnimation		; $7e2e
	jp interactionAnimateAsNpc		; $7e31
	ld hl,$cfd1		; $7e34
	ld a,(hl)		; $7e37
	or a			; $7e38
	jp nz,interactionDelete		; $7e39
	inc (hl)		; $7e3c
	ld h,d			; $7e3d
	ld l,$44		; $7e3e
	ld (hl),$02		; $7e40
	ld a,$2e		; $7e42
	call unsetGlobalFlag		; $7e44
	ld a,$4c		; $7e47
	call interactionSetHighTextIndex		; $7e49
	ld hl,$7e0f		; $7e4c
	call interactionSetScript		; $7e4f
	call objectSetReservedBit1		; $7e52
	jr _label_0f_370		; $7e55

	ld h,d			; $7e57
	ld l,$44		; $7e58
	ld (hl),$02		; $7e5a
	ld a,$4c		; $7e5c
	call interactionSetHighTextIndex		; $7e5e
	ld hl,script7e6f		; $7e61
	call interactionSetScript		; $7e64
	jr _label_0f_370		; $7e67
	call interactionRunScript		; $7e69
	ld e,$7f		; $7e6c
	ld a,(de)		; $7e6e
	or a			; $7e6f
	ret nz			; $7e70
	jp interactionAnimateAsNpc		; $7e71
_label_0f_370:
	ld e,$42		; $7e74
	ld a,(de)		; $7e76
	dec a			; $7e77
	jr nz,_label_0f_371	; $7e78
	ld hl,$79df		; $7e7a
	ld e,$0f		; $7e7d
	call interBankCall		; $7e7f
_label_0f_371:
	call interactionRunScript		; $7e82
	jp c,interactionDelete		; $7e85
	ret			; $7e88

interactionCoded5:
	ld e,$44		; $7e89
	ld a,(de)		; $7e8b
	rst_jumpTable			; $7e8c
	sub c			; $7e8d
	ld a,(hl)		; $7e8e
	call z,$3e7e		; $7e8f
	ld bc,$1e12		; $7e92
	ld b,d			; $7e95
	ld a,(de)		; $7e96
	or a			; $7e97
	jr z,_label_0f_372	; $7e98
	call checkIsLinkedGame		; $7e9a
	jp z,interactionDelete		; $7e9d
	jr _label_0f_373		; $7ea0
_label_0f_372:
	ld a,$28		; $7ea2
	call checkGlobalFlag		; $7ea4
	jp z,interactionDelete		; $7ea7
_label_0f_373:
	call interactionInitGraphics		; $7eaa
	call interactionSetAlwaysUpdateBit		; $7ead
	ld h,d			; $7eb0
	ld l,e			; $7eb1
	inc (hl)		; $7eb2
	ld l,$4f		; $7eb3
	ld (hl),$f0		; $7eb5
	ld l,$77		; $7eb7
	ld (hl),$36		; $7eb9
	ld a,$41		; $7ebb
	call interactionSetHighTextIndex		; $7ebd
	xor a			; $7ec0
	ld (wActiveMusic),a		; $7ec1
	ld a,$0f		; $7ec4
	call playSound		; $7ec6
	jp objectCreatePuff		; $7ec9
	ld e,$45		; $7ecc
	ld a,(de)		; $7ece
	rst_jumpTable			; $7ecf
	call nc,$017e		; $7ed0
	ld a,a			; $7ed3
	ld h,d			; $7ed4
	ld l,$77		; $7ed5
	dec (hl)		; $7ed7
	ret nz			; $7ed8
	ld l,$45		; $7ed9
	inc (hl)		; $7edb
	xor a			; $7edc
	call interactionSetAnimation		; $7edd
	call objectSetVisiblec2		; $7ee0
	ld e,$7e		; $7ee3
	ld a,$07		; $7ee5
	ld (de),a		; $7ee7
	ld e,$42		; $7ee8
	ld a,(de)		; $7eea
	or a			; $7eeb
	ld hl,$5779		; $7eec
	jr nz,_label_0f_374	; $7eef
	ld a,$60		; $7ef1
	call checkGlobalFlag		; $7ef3
	ld hl,$7e73		; $7ef6
	jr z,_label_0f_374	; $7ef9
	ld hl,$7e99		; $7efb
_label_0f_374:
	jp interactionSetScript		; $7efe
	call interactionRunScript		; $7f01
	call interactionAnimateAsNpc		; $7f04
	ld a,(wFrameCounter)		; $7f07
	and $07			; $7f0a
	ret nz			; $7f0c
	ld a,(wFrameCounter)		; $7f0d
	and $38			; $7f10
	swap a			; $7f12
	rlca			; $7f14
	ld hl,$7f1f		; $7f15
	rst_addAToHl			; $7f18
	ld e,$4f		; $7f19
	ld a,(de)		; $7f1b
	add (hl)		; $7f1c
	ld (de),a		; $7f1d
	ret			; $7f1e
	rst $38			; $7f1f
	cp $ff			; $7f20
	nop			; $7f22
	ld bc,$0102		; $7f23
	nop			; $7f26

interactionCoded6:
	ld e,$44		; $7f27
	ld a,(de)		; $7f29
	rst_jumpTable			; $7f2a
	cpl			; $7f2b
	ld a,a			; $7f2c
	ld (hl),a		; $7f2d
	ld a,a			; $7f2e
	ld a,$01		; $7f2f
	ld (de),a		; $7f31
	ld e,$42		; $7f32
	ld a,(de)		; $7f34
	ld hl,$7f74		; $7f35
	rst_addAToHl			; $7f38
	ld a,($c610)		; $7f39
	cp (hl)			; $7f3c
	jp nz,interactionDelete		; $7f3d
	ld a,$86		; $7f40
	call loadPaletteHeader		; $7f42
	call interactionInitGraphics		; $7f45
	call interactionSetAlwaysUpdateBit		; $7f48
	ld a,$4c		; $7f4b
	call interactionSetHighTextIndex		; $7f4d
	ld a,$28		; $7f50
	call checkGlobalFlag		; $7f52
	ld hl,$7e9d		; $7f55
	jr z,_label_0f_375	; $7f58
	ld a,$61		; $7f5a
	call checkGlobalFlag		; $7f5c
	ld hl,$7ef0		; $7f5f
	jr nz,_label_0f_375	; $7f62
	call getThisRoomFlags		; $7f64
	bit 7,a			; $7f67
	ld hl,$7f01		; $7f69
	jr nz,_label_0f_375	; $7f6c
	ld hl,$7eb9		; $7f6e
_label_0f_375:
	jp interactionSetScript		; $7f71
	dec bc			; $7f74
	inc c			; $7f75
	dec c			; $7f76
	call interactionRunScript		; $7f77
	call interactionAnimateAsNpc		; $7f7a
	ld c,$20		; $7f7d
	call objectCheckLinkWithinDistance		; $7f7f
	ld h,d			; $7f82
	ld l,$77		; $7f83
	jr c,_label_0f_376	; $7f85
	ld a,(hl)		; $7f87
	or a			; $7f88
	ret z			; $7f89
	xor a			; $7f8a
	ld (hl),a		; $7f8b
	ld a,$03		; $7f8c
	jp interactionSetAnimation		; $7f8e
_label_0f_376:
	ld a,(hl)		; $7f91
	or a			; $7f92
	ret nz			; $7f93
	inc (hl)		; $7f94
	ld a,$01		; $7f95
	jp interactionSetAnimation		; $7f97

interactionCoded7:
	jp interactionDelete		; $7f9a
