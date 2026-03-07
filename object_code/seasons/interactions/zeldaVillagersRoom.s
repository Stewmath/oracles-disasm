; ==================================================================================================
; INTERAC_ZELDA_VILLAGERS_ROOM
; ==================================================================================================
interactionCodec4:
	call checkZeldaVillagersSeenButNoMakuSeed
	ld a,$00
	jr nz,+
	call checkGotMakuSeedDidNotSeeZeldaKidnapped_body
	jp z,interactionDelete
	ld a,$01
+
	ld hl,zeldaVillagersRoom_interactionsTableLookup
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld b,(hl)
	inc l
	push de
	ld d,h
	ld e,l
-
	call getFreeInteractionSlot
	jr nz,+
	ld a,(de)
	ldi (hl),a
	inc de
	ld a,(de)
	ld (hl),a
	inc de
	ld l,Interaction.yh
	ld a,(de)
	ldi (hl),a
	inc de
	inc l
	ld a,(de)
	ld (hl),a
	inc de
	dec b
	jr nz,-
+
	pop de
	jp interactionDelete


checkZeldaVillagersSeenButNoMakuSeed:
	call checkIsLinkedGame
	ret z
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	call checkGlobalFlag
	jp z,@checkZeldaVillagersSeen
	xor a
	ret

@checkZeldaVillagersSeen:
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	jp checkGlobalFlag

checkGotMakuSeedDidNotSeeZeldaKidnapped_body:
	call checkIsLinkedGame
	ret z
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jp z,@checkGotMakuSeed
	xor a
	ret

@checkGotMakuSeed:
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	jp checkGlobalFlag


zeldaVillagersRoom_interactionsTableLookup:
	.dw @villagersSeenInteractions ; checkZeldaVillagersSeenButNoMakuSeed
	.dw @gotMakuSeedInteractions ; checkGotMakuSeedDidNotSeeZeldaKidnapped

@villagersSeenInteractions:
	.db $05
	; interactioncode - subid - yh - xh
	.db INTERAC_ZELDA $07 $28 $48
	.db INTERAC_IMPA $02 $30 $60
	.db INTERAC_bc $01 $48 $60
	.db INTERAC_be $01 $48 $30
	.db INTERAC_bd $01 $30 $30

@gotMakuSeedInteractions:
	.db $03
	.db INTERAC_bc $02 $48 $60
	.db INTERAC_be $02 $48 $30
	.db INTERAC_bd $02 $30 $30
