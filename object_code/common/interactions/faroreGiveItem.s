; ==================================================================================================
; INTERAC_FARORE_GIVEITEM
; ==================================================================================================
interactionCoded9:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactiond9_state0
	.dw interactiond9_state1
	.dw interactiond9_state2

interactiond9_state0:
	ld a,$01
	ld (wLoadedTreeGfxIndex),a

	; Check if the secret has been told already
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
.ifdef ROM_AGES
	add GLOBALFLAG_FIRST_AGES_DONE_SECRET
.else
	add GLOBALFLAG_FIRST_SEASONS_DONE_SECRET
.endif
	call checkGlobalFlag
	jr z,@secretNotTold

	ld bc,TX_550c ; "You told me this secret already"
	call showText

	; Bit 1 is a signal for Farore to continue talking
	ld a,$02
	ld (wTmpcfc0.genericCutscene.state),a

	jp interactionDelete

@secretNotTold:
	; Decide whether to go to state 1 or 2 based on the secret told.
	ld a,b
	ld hl,@bits
	call checkFlag
	ld a,$02
	jr nz,+
	dec a
+
	ld e,Interaction.state
	ld (de),a
	ret

; If a bit is set for a corresponding secret, it's an upgrade (go to state 2); otherwise,
; it's a new item (go to state 1).
@bits:
	dbrev %10001101 %01000000

;;
; @param[out]	bc	The item ID.
;			If this is an upgrade, 'c' is a value from 0-4 indicating the
;			behaviour (ie. compare with current ring box level, sword level)
interactiond9_getItemID:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@chestContents
	rst_addDoubleIndex
	ld b,(hl)
	inc l
	ld c,(hl)
	ret

@chestContents:
	.db  TREASURE_SWORD,           $00 ; upgrade
	dwbe TREASURE_OBJECT_HEART_CONTAINER_01
	dwbe TREASURE_OBJECT_BOMBCHUS_01
	dwbe TREASURE_OBJECT_RING_0c
	.db  TREASURE_SHIELD,          $01 ; upgrade
	.db  TREASURE_BOMB_UPGRADE,    $02 ; upgrade
	dwbe TREASURE_OBJECT_RING_0d
	.db  TREASURE_SATCHEL_UPGRADE, $03 ; upgrade
	dwbe TREASURE_OBJECT_BIGGORON_SWORD_01
	.db  TREASURE_RING_BOX,        $04 ; upgrade


; State 1: it's a new item, not an upgrade
interactiond9_state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld a,$01
	ld (de),a
	xor a
	ld (wcca2),a

	call interactiond9_getItemID
	ld a,b
	ld (wChestContentsOverride),a
	ld a,c
	ld (wChestContentsOverride+1),a

	ld b,INTERAC_FARORE_MAKECHEST
	jp objectCreateInteractionWithSubid00

@substate1:
	ld a,(wTmpcfc0.genericCutscene.state)
	or a
	ret z

	ld e,Interaction.counter1
	ld a,$3c
	ld (de),a
	jp interactionIncSubstate

@substate2:
	call interactionDecCounter1
	ret nz

	ld a,GLOBALFLAG_SECRET_CHEST_WAITING
	call setGlobalFlag

	; Bit 1 of $cfc0 is a signal for Farore to continue talking
	ld a,$02
	ld ($cfc0),a

	ld bc,TX_5509 ; "Your secrets have called forth power"
	call showText
	jp interactionIncSubstate

@substate3:
	; Wait for the chest to be opened
	ld a,(wcca2)
	or a
	ret z

	call interactiond9_markSecretAsTold
	ld e,Interaction.counter1
	ld a,$1e
	ld (de),a
	jp interactionIncSubstate

@substate4:
	call interactionDecCounter1
	ret nz

	; Remove the chest
	call objectCreatePuff
	call objectGetShortPosition
	ld c,a
	ld a,$ac
	call setTile
	jp interactionDelete


; State 2: it's an upgrade; it doesn't go in a chest.
interactiond9_state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

@substate0:
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),30
	ld hl,w1Link
	jp objectTakePosition

@substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),60

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_SPARKLE
	ld l,Interaction.yh
	ld (hl),$28
	ld l,Interaction.xh
	ld (hl),$58
	jp interactionIncSubstate

@substate2:
	call interactionDecCounter1
	ret nz
	ld (hl),20

	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	ld a,$78
	call createEnergySwirlGoingIn
	jp interactionIncSubstate

@substate3:
@substate4:
	call interactionDecCounter1
	ret nz
	ld (hl),$14
	call fadeinFromWhite

@playFadeOutSoundAndIncState:
	ld a,SND_FADEOUT
	call playSound
	jp interactionIncSubstate

@substate5:
	call interactionDecCounter1
	ret nz
	ld a,$02
	call fadeinFromWhiteWithDelay
	jr @playFadeOutSoundAndIncState

@substate6:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactiond9_getItemID
	ld a,c
	rst_jumpTable
	.dw @swordUpgrade
	.dw @shieldUpgrade
	.dw @bombUpgrade
	.dw @satchelUpgrade
	.dw @ringBoxUpgrade

@ringBoxUpgrade:
	ld a,(wRingBoxLevel)
	and $03
	ld hl,@ringBoxSubids
	rst_addAToHl
	ld c,(hl)
	ld b,TREASURE_RING_BOX
	jr @createTreasureAndIncSubstate

@ringBoxSubids:
	.db $03 $03 $04 $04

@swordShieldSubids:
	.db $03 $01
	.db $03 $01
	.db $05 $02
	.db $05 $02

@swordUpgrade:
	ld a,(wSwordLevel)
	jr ++

@shieldUpgrade:
	ld a,(wShieldLevel)
++
	ld hl,@swordShieldSubids
	rst_addDoubleIndex
	inc hl
	ld a,(hl)
	jr @label_0b_135

@bombUpgrade:
	ld bc,TREASURE_OBJECT_BOMB_UPGRADE_00
	call @createTreasureAndIncSubstate
	ld hl,wMaxBombs
	ld a,(hl)
	add $20
	ldd (hl),a
	ld (hl),a
	jp setStatusBarNeedsRefreshBit1

@satchelUpgrade:
	ld a,(wSeedSatchelLevel)

	; This index differs in ages and seasons (see constants/common/treasure.s)
	ld bc,TREASURE_OBJECT_SEED_SATCHEL_UPGRADE
	jr @createTreasureAndIncSubstate

@label_0b_135:
	and $03
	ld c,a

@createTreasureAndIncSubstate:
	call @createTreasure
	ld e,Interaction.counter1
	ld a,30
	ld (de),a
	jp interactionIncSubstate

@substate7:
	call retIfTextIsActive
	call interactionDecCounter1
	ret nz

	ld e,Interaction.subid
	ld a,(de)
	cp $07
	jr z,@fillSatchel
	or a
	jr nz,@cleanup

	; The sword upgrade acts differently? Maybe due to Link doing a spin slash?
	ld a,(wSwordLevel)
	add $02
	ld c,a
	ld b,TREASURE_SWORD
	call @createTreasure
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$5a
	ret

@fillSatchel:
	call refillSeedSatchel

@cleanup:
	; Bit 1 of $cfc0 is a signal for Farore to continue talking
	ld a,$02
	ld ($cfc0),a

	ld bc,TX_5509
	call showText
	call interactiond9_markSecretAsTold
	jp interactionDelete

@substate8:
	call interactionDecCounter1
	ret nz
	jr @cleanup

;;
; @param	bc	The treasure to create
@createTreasure:
	call createTreasure
	ret nz
	jp objectCopyPosition

;;
interactiond9_markSecretAsTold:
	ld e,Interaction.subid
	ld a,(de)
.ifdef ROM_AGES
	add GLOBALFLAG_FIRST_AGES_DONE_SECRET
.else
	add GLOBALFLAG_FIRST_SEASONS_DONE_SECRET
.endif
	call setGlobalFlag
	ld a,GLOBALFLAG_SECRET_CHEST_WAITING
	jp unsetGlobalFlag
