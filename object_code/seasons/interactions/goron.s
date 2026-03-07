; ==================================================================================================
; INTERAC_GORON
; ==================================================================================================
interactionCode3b:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	xor a
	ldh (<hFF8D),a
	ld a,TREASURE_TRADEITEM
	call checkTreasureObtained
	jr nc,+
	; Got Goron vase
	cp $05
	jr c,+
	ld a,$01
	ldh (<hFF8D),a
+
	ld h,d
	ld l,$42
	ld a,(hl)
	ld b,a
	and $0f
	ldi (hl),a
	ld c,a
	ld a,b
	swap a
	and $0f
	; upper nybble of subid goes into var03
	ld (hl),a
	ld a,c
	ld c,>TX_3700
	cp $07
	jr nz,+
	; subid_07
	ld a,(wIsLinkedGame)
	ld b,a
	ldh a,(<hFF8D)
	and b
	jp z,interactionDelete
	ld c,>TX_5300
+
	ld a,c
	call interactionSetHighTextIndex
	call interactionInitGraphics
	ld hl,@biggoronColdNotHealed
	ldh a,(<hFF8D)
	or a
	jr z,+
	ld hl,@biggoronColdHealed
+
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
@state1:
	ld e,$43
	ld a,(de)
	rst_jumpTable
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02
@var03_00:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
@var03_01:
	call interactionRunScript
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	ld c,$28
	call objectCheckLinkWithinDistance
	jr nc,+
	call interactionIncSubstate
	call @func_67fc
	add $06
	call interactionSetAnimation
+
	jp interactionAnimateAsNpc
@substate1:
	ld e,$61
	ld a,(de)
	inc a
	jr nz,+
	call interactionIncSubstate
	ld l,$49
	ld (hl),$ff
+
	jp interactionAnimateAsNpc
@substate2:
	ld c,$28
	call objectCheckLinkWithinDistance
	jr c,+
	call interactionIncSubstate
	call @func_67fc
	add $07
	call interactionSetAnimation
	jr @animateAsNPC
+
	jp npcFaceLinkAndAnimate
@substate3:
	ld e,$61
	ld a,(de)
	inc a
	jr nz,@animateAsNPC
	ld e,$45
	xor a
	ld (de),a
@animateAsNPC:
	jp interactionAnimateAsNpc
@var03_02:
	call interactionAnimate
	call interactionAnimate
	call checkInteractionSubstate
	jr nz,@func_67f0
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	jr z,@runScriptPushLinkAwayUpdateDrawPriority
	xor a
	ld (de),a
	call objectGetAngleTowardLink
	add $04
	add a
	swap a
	and $03
	ld e,$48
	ld (de),a
	call interactionSetAnimation
	ld bc,TX_3700
	call showText
	call interactionIncSubstate
@runScriptPushLinkAwayUpdateDrawPriority:
	call interactionRunScript
	jp interactionPushLinkAwayAndUpdateDrawPriority

@func_67f0:
	ld e,$76
	ld a,(de)
	call interactionSetAnimation
	ld e,$45
	xor a
	ld (de),a
	jr @runScriptPushLinkAwayUpdateDrawPriority
	
@func_67fc:
	ld e,$4d
	ld a,(de)
	ld hl,$d00d
	cp (hl)
	ld a,$02
	ret c
	xor a
	ret

@biggoronColdNotHealed:
	.dw mainScripts.goronScript_pacingLeftAndRight
	.dw mainScripts.goronScript_text1_biggoronSick
	.dw mainScripts.goronScript_text2
	.dw mainScripts.goronScript_text3_biggoronSick
	.dw mainScripts.goronScript_text4_biggoronSick
	.dw mainScripts.goronScript_text5
	.dw mainScripts.goronScript_upgradeRingBox
	.dw mainScripts.goronScript_giveSubrosianSecret

@biggoronColdHealed:
	.dw mainScripts.goronScript_pacingLeftAndRight
	.dw mainScripts.goronScript_text1_biggoronHealed
	.dw mainScripts.goronScript_text2
	.dw mainScripts.goronScript_text3_biggoronHealed
	.dw mainScripts.goronScript_text4_biggoronHealed
	.dw mainScripts.goronScript_text5
	.dw mainScripts.goronScript_upgradeRingBox
	.dw mainScripts.goronScript_giveSubrosianSecret
