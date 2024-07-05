; ==================================================================================================
; INTERAC_SUBROSIAN_SHOP
; Variables:
;   var37 - wram variable to check for number of 2nd currency
;   var38 - number of 2nd currency required
;   var39 - ore chunk cost
; ==================================================================================================
interactionCode81:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld a,$01
	ld (de),a
	ld e,$40
	ld a,(de)
	or $80
	ld (de),a
@func_7742:
	ld e,Interaction.subid
	ld a,(de)
	cp $0a
	jr z,@shield
	cp $0d
	jr nz,@func_7770
	; member's card
	ld a,(wEssencesObtained)
	bit 2,a
	jr z,@func_776b
	ld a,TREASURE_MEMBERS_CARD
	call checkTreasureObtained
	jr c,@func_776b
	jr @func_7770
@shield:
	ld a,(wShieldLevel)
	cp $02
	jr nc,@func_776b
	ld a,TREASURE_SHIELD
	call checkTreasureObtained
	jr nc,@func_7770
@func_776b:
	ld a,(de)
	inc a
	ld (de),a
	jr @func_7770
@func_7770:
	ld a,(de)
	add a
	ld hl,@table_779e
	rst_addDoubleIndex
	ld a,(wBoughtSubrosianShopItems)
	and (hl)
	jr nz,@func_7799
	inc hl
	ld e,$77
	ld b,$03
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-
	call interactionInitGraphics
	ld e,$66
	ld a,$06
	ld (de),a
	inc e
	ld (de),a
	ld e,$71
	call objectAddToAButtonSensitiveObjectList
	jp objectSetVisible82
@func_7799:
	; already bought item
	ld a,(de)
	inc a
	ld (de),a
	jr @func_7742
@table_779e:
	; Byte 0: wBoughtSubrosianShopItems flag it sets
	; Byte 1: variable to check for other currency
	; Byte 2: number of other currency required
	; Byte 3: ore chunk cost
	.db $01, $00,             $00, $00
	.db $04, <wNumBombs,      $10, RUPEEVAL_050
	.db $08, <wNumScentSeeds, $20, RUPEEVAL_040
	.db $00, <wNumScentSeeds, $20, RUPEEVAL_100
	.db $02, <wNumEmberSeeds, $10, RUPEEVAL_020
	.db $10, $00,             $00, RUPEEVAL_030
	.db $20, $00,             $00, RUPEEVAL_040
	.db $40, $00,             $00, RUPEEVAL_050
	.db $80, $00,             $00, RUPEEVAL_070
	.db $00, $00,             $00, RUPEEVAL_005
	.db $00, <wNumEmberSeeds, $05, $00
	.db $00, $00,             $00, RUPEEVAL_025
	.db $00, $00,             $00, RUPEEVAL_010
	.db $00, $00,             $00, RUPEEVAL_005
	.db $00, <wNumGaleSeeds,  $20, $00
@table_77da:
	.db TREASURE_RIBBON,        $00
	.db TREASURE_BOMBS,         $10
	.db TREASURE_GASHA_SEED,    $01
	.db TREASURE_GASHA_SEED,    $01
	.db TREASURE_HEART_PIECE,   $01
	.db TREASURE_RING,          $03
	.db TREASURE_RING,          $03
	.db TREASURE_RING,          $03
	.db TREASURE_RING,          $02
	.db TREASURE_EMBER_SEEDS,   $04
	.db TREASURE_SHIELD,        $01
	.db TREASURE_PEGASUS_SEEDS, $10
	.db TREASURE_HEART_REFILL,  $0c
	.db TREASURE_MEMBERS_CARD,  $10
	.db TREASURE_ORE_CHUNKS,    $04
@state1:
	call interactionAnimateAsNpc
	ld e,$71
	ld a,(de)
	or a
	ret z
	xor a
	ld (de),a
	ld e,$7d
	ld (de),a
	call func_7931
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,table_7994
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript
@state2:
	call interactionAnimateAsNpc
	call interactionRunScript
	ret nc
	ld e,$7d
	ld a,(de)
	bit 7,a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret nz
	ld a,$03
	ld (de),a
	inc e
	xor a
	ld (de),a
	ld a,$80
	ld ($cc02),a
	ret
@state3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
@substate0:
	call objectSetVisible80
	ld a,($ccea)
	dec a
	ld ($ccea),a
	call func_7973
	ld a,$04
	ld ($cc6a),a
	ld a,$01
	ld ($cc6b),a
	ld h,d
	ld l,$4b
	ld a,($d00b)
	sub $0e
	ld (hl),a
	ld l,$4d
	ld a,($d00d)
	ld (hl),a
	ld l,$46
	ld a,$80
	ldi (hl),a
	ld (hl),$04
	ld l,$45
	ld a,$01
	ld (hl),a
	ld hl,$cbea
	set 2,(hl)
	ld e,Interaction.subid
	ld a,(de)
	cp $01
	jr z,@func_78ac
	ld hl,@table_77da
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	cp $2d
	jr nz,+
	call getRandomRingOfGivenTier
+
	call giveTreasure
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@table_78b1
	rst_addAToHl
	ld c,(hl)
	ld b,$00
	call showText
	ld e,Interaction.subid
	ld a,(de)
	cp $04
	ret z
	ld a,$4c
	jp playSound
@func_78ac:
	ld h,d
	ld l,$45
	inc (hl)
	ret
@table_78b1:
	.db <TX_0041 ; Ribbon
	.db <TX_0000 ; this table not used for bomb upgrade
	.db <TX_004b ; Gasha seed
	.db <TX_004b ; Gasha seed
	.db <TX_0017 ; Piece of heart
	.db <TX_0054 ; Ring
	.db <TX_0054 ; Ring
	.db <TX_0054 ; Ring
	.db <TX_0054 ; Ring
	.db <TX_004f ; 4 ember seeds
	.db <TX_001f ; Shield
	.db <TX_0050 ; 10 pegasus seeds
	.db <TX_004c ; 3 hearts
	.db <TX_0045 ; Member's card
	.db <TX_004e ; 10 ore chunks
@substate1:
	call retIfTextIsActive
	xor a
	ld ($cca4),a
	ld ($cc02),a
	jp interactionDelete
@substate2:
	call interactionDecCounter1
	jr z,+
	inc l
	dec (hl)
	ret nz
	ld (hl),$04
	ld a,$01
	ld l,$5c
	xor (hl)
	ld (hl),a
	ret
+
	ld l,$5b
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$0c
	ld l,$45
	ld (hl),$03
	ld l,$47
	ld (hl),$1e
	ld a,$08
	call interactionSetAnimation
	ld a,$bc
	call playSound
	jp fadeoutToWhite
@substate3:
	call interactionAnimate
	ld a,($c4ab)
	or a
	ret nz
	call interactionDecCounter2
	ret nz
	ld l,$5a
	ld (hl),a
	ld l,$45
	ld (hl),$04
	ld hl,wMaxBombs
	ld a,(hl)
	add $20
	ldd (hl),a
	ld (hl),a
	call setStatusBarNeedsRefreshBit1
	jp fadeinFromWhite
@substate4:
	ld a,($c4ab)
	or a
	ret nz
	xor a
	ld ($cca4),a
	ld ($cc02),a
	ld bc,TX_2b0e
	call showText
	jp interactionDelete
	
func_7931:
	ld e,$7b
	xor a
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,buyingRibbon
	ld e,$77
	ld a,(de)
	or a
	jr z,+
	ld l,a
	ld h,>wc600Block
	inc e
	ld a,(de)
	ld b,a
	ld a,(hl)
	cp b
	jr c,++
+
	ld e,$7b
	ld a,$01
	ld (de),a
++
	ld e,$79
	ld a,(de)
	call cpOreChunkValue
	ld hl,$cba8
	ld (hl),c
	inc l
	ld (hl),b
	ld e,$7b
	xor $01
	jr z,+
	ld c,a
	ld a,(de)
	and c
+
	ld (de),a
	ret

buyingRibbon:
	ld a,TREASURE_STAR_ORE
	call checkTreasureObtained
	ret nc
	ld e,$7b
	ld a,$01
	ld (de),a
	ret

func_7973:
	ld e,Interaction.subid
	ld a,(de)
	or a
	ret z
	ld a,$ff
	ld ($cbea),a
	ld e,$77
	ld a,(de)
	or a
	jr z,+
	ld l,a
	ld h,>wc600Block
	inc e
	ld a,(de)
	ld c,a
	ld a,(hl)
	sub c
	daa
	ld (hl),a
+
	ld e,$79
	ld a,(de)
	ld c,a
	jp removeOreChunkValue
	
table_7994:
	.dw mainScripts.subrosianShopScript_ribbon
	.dw mainScripts.subrosianShopScript_bombUpgrade
	.dw mainScripts.subrosianShopScript_gashaSeed
	.dw mainScripts.subrosianShopScript_gashaSeed
	.dw mainScripts.subrosianShopScript_pieceOfHeart
	.dw mainScripts.subrosianShopScript_ring1
	.dw mainScripts.subrosianShopScript_ring2
	.dw mainScripts.subrosianShopScript_ring3
	.dw mainScripts.subrosianShopScript_ring4
	.dw mainScripts.subrosianShopScript_emberSeeds
	.dw mainScripts.subrosianShopScript_shield
	.dw mainScripts.subrosianShopScript_pegasusSeeds
	.dw mainScripts.subrosianShopScript_heartRefill
	.dw mainScripts.subrosianShopScript_membersCard
	.dw mainScripts.subrosianShopScript_oreChunks
