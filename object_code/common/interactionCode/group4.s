; ==============================================================================
; INTERACID_FARORE_GIVEITEM
; ==============================================================================
interactionCoded9:
	ld e,Interaction.state		; $4dda
	ld a,(de)		; $4ddc
	rst_jumpTable			; $4ddd
	.dw _interactiond9_state0
	.dw _interactiond9_state1
	.dw _interactiond9_state2

_interactiond9_state0:
	ld a,$01		; $4de4
	ld (wLoadedTreeGfxIndex),a		; $4de6

	; Check if the secret has been told already
	ld e,Interaction.subid		; $4de9
	ld a,(de)		; $4deb
	ld b,a			; $4dec
.ifdef ROM_AGES
	add GLOBALFLAG_FIRST_AGES_DONE_SECRET			; $4ded
.else
	add GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET			; $4ded
.endif
	call checkGlobalFlag		; $4def
	jr z,@secretNotTold			; $4df2

	ld bc,TX_550c ; "You told me this secret already"
	call showText		; $4df7

	; Bit 1 is a signal for Farore to continue talking
	ld a,$02		; $4dfa
	ld (wTmpcfc0.genericCutscene.state),a		; $4dfc

	jp interactionDelete		; $4dff

@secretNotTold:
	; Decide whether to go to state 1 or 2 based on the secret told.
	ld a,b			; $4e02
	ld hl,@bits		; $4e03
	call checkFlag		; $4e06
	ld a,$02		; $4e09
	jr nz,+			; $4e0b
	dec a			; $4e0d
+
	ld e,Interaction.state		; $4e0e
	ld (de),a		; $4e10
	ret			; $4e11

; If a bit is set for a corresponding secret, it's an upgrade (go to state 2); otherwise,
; it's a new item (go to state 1).
@bits:
	dbrev %10001101 %01000000

;;
; @param[out]	bc	The item ID.
;			If this is an upgrade, 'c' is a value from 0-4 indicating the
;			behaviour (ie. compare with current ring box level, sword level)
; @addr{4e14}
_interactiond9_getItemID:
	ld e,Interaction.subid		; $4e14
	ld a,(de)		; $4e16
	ld hl,@chestContents		; $4e17
	rst_addDoubleIndex			; $4e1a
	ld b,(hl)		; $4e1b
	inc l			; $4e1c
	ld c,(hl)		; $4e1d
	ret			; $4e1e

@chestContents:
	.db  TREASURE_SWORD,           $00 ; upgrade
	dwbe TREASURE_HEART_CONTAINER_SUBID_01
	dwbe TREASURE_BOMBCHUS_SUBID_01
	dwbe TREASURE_RING_SUBID_0c
	.db  TREASURE_SHIELD,          $01 ; upgrade
	.db  TREASURE_BOMB_UPGRADE,    $02 ; upgrade
	dwbe TREASURE_RING_SUBID_0d
	.db  TREASURE_SATCHEL_UPGRADE, $03 ; upgrade
	dwbe TREASURE_BIGGORON_SWORD_SUBID_01
	.db  TREASURE_RING_BOX,        $04 ; upgrade


; State 1: it's a new item, not an upgrade
_interactiond9_state1:
	ld e,Interaction.state2		; $4e33
	ld a,(de)		; $4e35
	rst_jumpTable			; $4e36
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld a,$01		; $4e41
	ld (de),a		; $4e43
	xor a			; $4e44
	ld (wcca2),a		; $4e45

	call _interactiond9_getItemID		; $4e48
	ld a,b			; $4e4b
	ld (wChestContentsOverride),a		; $4e4c
	ld a,c			; $4e4f
	ld (wChestContentsOverride+1),a		; $4e50

	ld b,INTERACID_FARORE_MAKECHEST		; $4e53
	jp objectCreateInteractionWithSubid00		; $4e55

@substate1:
	ld a,(wTmpcfc0.genericCutscene.state)		; $4e58
	or a			; $4e5b
	ret z			; $4e5c

	ld e,Interaction.counter1		; $4e5d
	ld a,$3c		; $4e5f
	ld (de),a		; $4e61
	jp interactionIncState2		; $4e62

@substate2:
	call interactionDecCounter1		; $4e65
	ret nz			; $4e68

	ld a,GLOBALFLAG_SECRET_CHEST_WAITING		; $4e69
	call setGlobalFlag		; $4e6b

	; Bit 1 of $cfc0 is a signal for Farore to continue talking
	ld a,$02		; $4e6e
	ld ($cfc0),a		; $4e70

	ld bc,TX_5509 ; "Your secrets have called forth power"
	call showText		; $4e76
	jp interactionIncState2		; $4e79

@substate3:
	; Wait for the chest to be opened
	ld a,(wcca2)		; $4e7c
	or a			; $4e7f
	ret z			; $4e80

	call _interactiond9_markSecretAsTold		; $4e81
	ld e,Interaction.counter1		; $4e84
	ld a,$1e		; $4e86
	ld (de),a		; $4e88
	jp interactionIncState2		; $4e89

@substate4:
	call interactionDecCounter1		; $4e8c
	ret nz			; $4e8f

	; Remove the chest
	call objectCreatePuff		; $4e90
	call objectGetShortPosition		; $4e93
	ld c,a			; $4e96
	ld a,$ac		; $4e97
	call setTile		; $4e99
	jp interactionDelete		; $4e9c


; State 2: it's an upgrade; it doesn't go in a chest.
_interactiond9_state2:
	ld e,Interaction.state2		; $4e9f
	ld a,(de)		; $4ea1
	rst_jumpTable			; $4ea2
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
	call interactionIncState2		; $4eb5
	ld l,Interaction.counter1		; $4eb8
	ld (hl),30		; $4eba
	ld hl,w1Link		; $4ebc
	jp objectTakePosition		; $4ebf

@substate1:
	call interactionDecCounter1		; $4ec2
	ret nz			; $4ec5
	ld (hl),60		; $4ec6

	call getFreeInteractionSlot		; $4ec8
	ret nz			; $4ecb
	ld (hl),INTERACID_SPARKLE		; $4ecc
	ld l,Interaction.yh		; $4ece
	ld (hl),$28		; $4ed0
	ld l,Interaction.xh		; $4ed2
	ld (hl),$58		; $4ed4
	jp interactionIncState2		; $4ed6

@substate2:
	call interactionDecCounter1		; $4ed9
	ret nz			; $4edc
	ld (hl),20		; $4edd

	ld a,(w1Link.yh)		; $4edf
	ld b,a			; $4ee2
	ld a,(w1Link.xh)		; $4ee3
	ld c,a			; $4ee6
	ld a,$78		; $4ee7
	call createEnergySwirlGoingIn		; $4ee9
	jp interactionIncState2		; $4eec

@substate3:
@substate4:
	call interactionDecCounter1		; $4eef
	ret nz			; $4ef2
	ld (hl),$14		; $4ef3
	call fadeinFromWhite		; $4ef5

@playFadeOutSoundAndIncState:
	ld a,SND_FADEOUT		; $4ef8
	call playSound		; $4efa
	jp interactionIncState2		; $4efd

@substate5:
	call interactionDecCounter1		; $4f00
	ret nz			; $4f03
	ld a,$02		; $4f04
	call fadeinFromWhiteWithDelay		; $4f06
	jr @playFadeOutSoundAndIncState		; $4f09

@substate6:
	ld a,(wPaletteThread_mode)		; $4f0b
	or a			; $4f0e
	ret nz			; $4f0f
	call _interactiond9_getItemID		; $4f10
	ld a,c			; $4f13
	rst_jumpTable			; $4f14
	.dw @swordUpgrade
	.dw @shieldUpgrade
	.dw @bombUpgrade
	.dw @satchelUpgrade
	.dw @ringBoxUpgrade

@ringBoxUpgrade:
	ld a,(wRingBoxLevel)		; $4f1f
	and $03			; $4f22
	ld hl,@ringBoxSubids		; $4f24
	rst_addAToHl			; $4f27
	ld c,(hl)		; $4f28
	ld b,TREASURE_RING_BOX		; $4f29
	jr @createTreasureAndIncState2		; $4f2b

@ringBoxSubids:
	.db $03 $03 $04 $04

@swordShieldSubids:
	.db $03 $01
	.db $03 $01
	.db $05 $02
	.db $05 $02

@swordUpgrade:
	ld a,(wSwordLevel)		; $4f39
	jr ++			; $4f3c

@shieldUpgrade:
	ld a,(wShieldLevel)		; $4f3e
++
	ld hl,@swordShieldSubids		; $4f41
	rst_addDoubleIndex			; $4f44
	inc hl			; $4f45
	ld a,(hl)		; $4f46
	jr @label_0b_135		; $4f47

@bombUpgrade:
	ldbc TREASURE_BOMB_UPGRADE, $00		; $4f49
	call @createTreasureAndIncState2		; $4f4c
	ld hl,wMaxBombs		; $4f4f
	ld a,(hl)		; $4f52
	add $20			; $4f53
	ldd (hl),a		; $4f55
	ld (hl),a		; $4f56
	jp setStatusBarNeedsRefreshBit1		; $4f57

@satchelUpgrade:
	ld a,(wSeedSatchelLevel)		; $4f5a
.ifdef ROM_AGES
	ldbc TREASURE_SEED_SATCHEL, $04		; $4f5d
.else
	ldbc TREASURE_SEED_SATCHEL, $01		; $4f5d
.endif
	jr @createTreasureAndIncState2		; $4f60

@label_0b_135:
	and $03			; $4f62
	ld c,a			; $4f64

@createTreasureAndIncState2:
	call @createTreasure		; $4f65
	ld e,Interaction.counter1		; $4f68
	ld a,30		; $4f6a
	ld (de),a		; $4f6c
	jp interactionIncState2		; $4f6d

@substate7:
	call retIfTextIsActive		; $4f70
	call interactionDecCounter1		; $4f73
	ret nz			; $4f76

	ld e,Interaction.subid		; $4f77
	ld a,(de)		; $4f79
	cp $07			; $4f7a
	jr z,@fillSatchel	; $4f7c
	or a			; $4f7e
	jr nz,@cleanup	; $4f7f

	; The sword upgrade acts differently? Maybe due to Link doing a spin slash?
	ld a,(wSwordLevel)		; $4f81
	add $02			; $4f84
	ld c,a			; $4f86
	ld b,TREASURE_SWORD		; $4f87
	call @createTreasure		; $4f89
	call interactionIncState2		; $4f8c
	ld l,Interaction.counter1		; $4f8f
	ld (hl),$5a		; $4f91
	ret			; $4f93

@fillSatchel:
	call refillSeedSatchel		; $4f94

@cleanup:
	; Bit 1 of $cfc0 is a signal for Farore to continue talking
	ld a,$02		; $4f97
	ld ($cfc0),a		; $4f99

	ld bc,TX_5509		; $4f9c
	call showText		; $4f9f
	call _interactiond9_markSecretAsTold		; $4fa2
	jp interactionDelete		; $4fa5

@substate8:
	call interactionDecCounter1		; $4fa8
	ret nz			; $4fab
	jr @cleanup		; $4fac

;;
; @param	bc	The treasure to create
@createTreasure:
	call createTreasure		; $4fae
	ret nz			; $4fb1
	jp objectCopyPosition		; $4fb2

;;
; @addr{4fb5}
_interactiond9_markSecretAsTold:
	ld e,Interaction.subid		; $4fb5
	ld a,(de)		; $4fb7
.ifdef ROM_AGES
	add GLOBALFLAG_FIRST_AGES_DONE_SECRET			; $4fb8
.else
	add GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET			; $4fb8
.endif
	call setGlobalFlag		; $4fba
	ld a,GLOBALFLAG_SECRET_CHEST_WAITING		; $4fbd
	jp unsetGlobalFlag		; $4fbf


; ==============================================================================
; INTERACID_ZELDA_APPROACH_TRIGGER
; ==============================================================================
interactionCodeda:
	ld e,Interaction.state		; $4fc2
	ld a,(de)		; $4fc4
	rst_jumpTable			; $4fc5
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4fca
	ld (de),a		; $4fcc
	call getThisRoomFlags		; $4fcd
	and ROOMFLAG_80			; $4fd0
	jp nz,interactionDelete		; $4fd2
.ifdef ROM_AGES
	ld a,PALH_ac		; $4fd5
.else
	ld a,SEASONS_PALH_ac		; $4fd5
.endif
	jp loadPaletteHeader		; $4fd7

@state1:
	call checkLinkVulnerable		; $4fda
	ret nc			; $4fdd
	ld a,(wScrollMode)		; $4fde
	and SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02			; $4fe1
	ret nz			; $4fe3

	ld hl,w1Link.yh		; $4fe4
	ld e,Interaction.yh		; $4fe7
	ld a,(de)		; $4fe9
	cp (hl)			; $4fea
	ret c			; $4feb

	ld l,<w1Link.xh		; $4fec
	ld e,Interaction.xh		; $4fee
	ld a,(de)		; $4ff0
	sub (hl)		; $4ff1
	jr nc,+			; $4ff2
	cpl			; $4ff4
	inc a			; $4ff5
+
	cp $09			; $4ff6
	ret nc			; $4ff8

	; Link has approached, start the cutscene
	ld a,CUTSCENE_WARP_TO_TWINROVA_FIGHT		; $4ff9
	ld (wCutsceneTrigger),a		; $4ffb
	ld (wMenuDisabled),a		; $4ffe

	; Make the flames invisible
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.enabled		; $5001
--
	ld l,Interaction.enabled		; $5004
	ldi a,(hl)		; $5006
	or a			; $5007
	jr z,++			; $5008
	ldi a,(hl)		; $500a
	cp INTERACID_TWINROVA_FLAME			; $500b
	jr nz,++		; $500d
	ld l,Interaction.visible		; $500f
	res 7,(hl)		; $5011
++
	inc h			; $5013
	ld a,h			; $5014
	cp LAST_INTERACTION_INDEX+1			; $5015
	jr c,--			; $5017
	jp interactionDelete		; $5019
