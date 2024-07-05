; ==================================================================================================
; INTERAC_a8
; ==================================================================================================
interactionCodea8:
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
@subid1:
@subid2:
@subid3:
	ld a,(de)
	and $0f
	add SPECIALOBJECT_RICKY_CUTSCENE
	ld b,a
	ld a,(de)
	swap a
	and $0f
	ld hl,w1Companion.enabled
	ld (hl),$01
	inc l
	ld (hl),b ; [w1Companion.id]
	inc l
	ld (hl),a ; [w1Companion.subid]
	call objectCopyPosition
	jp interactionDelete

@subid4:
	ld hl,w1Link.enabled
	ld (hl),$03
	call objectCopyPosition
	call @handleSubidHighNibble
	jp interactionDelete

@handleSubidHighNibble:
	ld e,Interaction.subid
	ld a,(de)
	swap a
	and $0f
	ld b,a
	rst_jumpTable
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4
	.dw @thing5
	.dw @thing6

@thing2:
@thing3:
@thing4:
	ld a,b

@initLinkInCutscene:
	ld hl,w1Link.id
	ld (hl),SPECIALOBJECT_LINK_CUTSCENE
	inc l
	ld (hl),a
	ret

@thing5:
	ld a,d
	ld (wLinkObjectIndex),a
	ld hl,wActiveRing
	ld (hl),FIST_RING
	xor a
	ld l,<wInventoryB
	ldi (hl),a
	ld (hl),a

	ld hl,@simulatedInput_5eea
	ld a,:@simulatedInput_5eea

@beginSimulatedInput:
	push de
	call setSimulatedInputAddress
	pop de
	xor a
	ld (wDisabledObjects),a
	ld hl,w1Link.id
	ld (hl),SPECIALOBJECT_LINK
	ret

@thing6:
	ld a,$09
	jp @initLinkInCutscene

@thing1:
	ld a,$0a
	jp @initLinkInCutscene

@thing0:
	ld hl,w1Link.direction
	ld (hl),DIR_DOWN
	ld a,h
	ld (wLinkObjectIndex),a
	ld hl,wInventoryB
	ld (hl),ITEM_SWORD
	inc l
	ld (hl),$00 ; [wInventoryA]
	ld hl,@linkSwordDemonstrationInput
	ld a,:@linkSwordDemonstrationInput
	jr @beginSimulatedInput


; Seasons-only (address $5edf)
@unusedInputData:
	dwb 60 $00
	dwb 32 BTN_DOWN
	dwb 48 $00
	.dw $ffff


@simulatedInput_5eea:
	dwb 124 $00
	dwb 1   BTN_LEFT
	dwb 46  $00
	dwb 1   BTN_DOWN
	dwb 46  $00
	dwb 1   BTN_RIGHT
	dwb 46  $00
	dwb 1   BTN_UP
	dwb 46  $00
	dwb 1   BTN_LEFT
	dwb 46  $00
	dwb 1   BTN_DOWN
	dwb 104 $00
	dwb 1   BTN_UP
	dwb 56  $00
	dwb 1   BTN_RIGHT
	dwb 464 $00
	dwb 1   BTN_LEFT
	dwb 160 $00
	dwb 1   BTN_A
	dwb 48  $00
	.dw $ffff

; Demonstrating sword to Ralph in credits
@linkSwordDemonstrationInput:
	dwb 60  $00
	dwb 1   BTN_LEFT
	dwb 58  BTN_B
	dwb 60  $00
	dwb 1   BTN_RIGHT|BTN_B
	dwb 20  $00
	dwb 1   BTN_DOWN
	dwb 120 BTN_B
	dwb 50  $00
	dwb 1   BTN_RIGHT
	dwb 30  $00
	.dw $ffff
