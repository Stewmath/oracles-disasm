; ==================================================================================================
; INTERAC_CLOAKED_TWINROVA
; ==================================================================================================
interactionCode8d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_2800
	call interactionSetHighTextIndex

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2

@initSubid0:
	ld a,$03
	call interactionSetAnimation
	ld bc,$4088
	call interactionSetPosition

@initSubid2:
	call @loadScript
	jp objectSetInvisible

@initSubid1:
	ld bc,$4050
	call interactionSetPosition
	ld l,Interaction.counter1
	ld (hl),30
	jp objectSetInvisible


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw @runSubid1
	.dw @runSubid0

@runSubid0:
@runSubid2:
	call interactionRunScript
	jp nc,interactionAnimate

	call objectCreatePuff

	; Subid 2 only: when done the script, create the "real" twinrova objects
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,++
	ldbc INTERAC_TWINROVA, $02
	call objectCreateInteraction
++
	jp interactionDelete


; Cutscene after d7; black tower is complete
@runSubid1:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid1Substate0
	.dw @subid1Substate1
	.dw @subid1Substate2
	.dw @subid1Substate3

@subid1Substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),20
	ld a,MUS_DISASTER
	call playSound
	call objectSetVisible
	call fadeinFromBlack
	ld a,$06
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	ld a,$03
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	jp interactionIncSubstate

@subid1Substate1:
	call interactionDecCounter1IfPaletteNotFading
	ret nz
	ld (hl),20
	call interactionIncSubstate
	ld bc,TX_2808
	jp showText

@subid1Substate2:
	call interactionDecCounter1IfTextNotActive
	ret nz
	ld a,SND_LIGHTNING
	call playSound
	ld hl,wGenericCutscene.cbb3
	ld (hl),$00
	ld hl,wGenericCutscene.cbba
	ld (hl),$ff
	jp interactionIncSubstate

@subid1Substate3:
	ld hl,wGenericCutscene.cbb3
	ld b,$02
	call flashScreen
	ret z
	ld a,$02
	ld (wGenericCutscene.cbb8),a
	ld a,CUTSCENE_BLACK_TOWER_EXPLANATION
	ld (wCutsceneTrigger),a
	jp interactionDelete


@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.cloakedTwinrova_subid00Script
	.dw mainScripts.stubScript
	.dw mainScripts.cloakedTwinrova_subid02Script
