; ==================================================================================================
; INTERAC_TWINROVA_IN_CUTSCENE
; ==================================================================================================
interactionCodeb0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw twinrovaInCutscene_state0
	.dw twinrovaInCutscene_state1


twinrovaInCutscene_state0:
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_2800
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid0:
	ld a,$01
	call @commonInit1
	jr twinrovaInCutscene_loadScript

@subid1:
	ld a,$02

@commonInit1:
	ld e,Interaction.oamFlags
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	jp interactionSetAnimation


@subid2:
	ld a,$01
	jr @commonInit2

@subid3:
	ld a,$01
	call interactionSetAnimation
	ld a,$02

@commonInit2:
	ld e,Interaction.oamFlags
	ld (de),a
	jp interactionSetAlwaysUpdateBit


twinrovaInCutscene_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate

@subid0:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	call interactionAnimate
	call interactionRunScript
	ret nc
	ld a,SND_LIGHTNING
	call playSound
	xor a
	ld (wGenericCutscene.cbb3),a
	dec a
	ld (wGenericCutscene.cbba),a
	jp interactionIncSubstate

@substate1:
	ld hl,wGenericCutscene.cbb3
	ld b,$02
	call flashScreen
	ret z
	ld a,$02
	ld (wGenericCutscene.cbb8),a
	ld a,CUTSCENE_BLACK_TOWER_EXPLANATION
	ld (wCutsceneTrigger),a
	ret

twinrovaInCutscene_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.twinrovaInCutsceneScript
	.dw mainScripts.stubScript
