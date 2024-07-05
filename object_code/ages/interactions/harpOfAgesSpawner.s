; ==================================================================================================
; INTERAC_HARP_OF_AGES_SPAWNER
; ==================================================================================================
interactionCodeb3:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,(hl)
	jp nz,interactionDelete ; Already got harp

	xor a
	ld (wTmpcfc0.genericCutscene.state),a

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_TREASURE
	inc l
	ld (hl),TREASURE_HARP

	ld l,Interaction.yh
	ld (hl),$38
	ld l,Interaction.xh
	ld (hl),$58
	ld b,h

	; Spawn a sparkle object attached to the harp of ages object we just spawned
	call getFreeInteractionSlot
	jr nz,@incState
	ld (hl),INTERAC_SPARKLE
	inc l
	ld (hl),$0c ; [subid]
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),b

@incState:
	call interactionSetAlwaysUpdateBit
	jp interactionIncState


@state1:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,(hl)
	ret z

	; Got harp; start cutscene
	ld a,SNDCTRL_STOPMUSIC
	call playSound

	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	call interactionIncState


@state2:
	ld a,(wTextIsActive)
	or a
	ret z

	xor a
	ld (w1Link.direction),a
	jp interactionIncState


@state3:
	ld a,(wTextIsActive)
	or a
	ret nz

	ld hl,wTmpcfc0.genericCutscene.state
	set 0,(hl)
	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),40

	ld a,$02
	call fadeoutToBlackWithDelay

	ld a,$ff
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ld a,$01
	ld (wDirtyFadeSprPalettes),a
	ld a,$fe
	ld (wFadeSprPaletteSources),a

	call hideStatusBar
	ldh a,(<hActiveObject)
	ld d,a
	ret

@state4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionDecCounter1
	ret nz

	inc (hl) ; [counter1] = 1

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_NAYRU
	inc l
	ld (hl),$07 ; [subid]
	call objectCopyPosition

	jp interactionDelete
