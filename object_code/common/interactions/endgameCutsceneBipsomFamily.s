; ==================================================================================================
; INTERAC_ENDGAME_CUTSCENE_BIPSOM_FAMILY
; ==================================================================================================
interactionCodea7:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics
	call objectSetVisible82

	ld e,Interaction.subid
	ld a,(de)
	cp $02
	ret nz

	ld a,(wChildStage)
	cp $04
	ret c

	ld a,$04
	call interactionSetAnimation
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_CHILD
	inc l
	ld a,(wChildStage)
	ld b,$00
	cp $07
	jr c,+
	ld b,$03
+
	ld a,(wChildPersonality)
	add b
	ldi (hl),a ; [child.subid]
	add $16
	ld (hl),a
	ld l,Interaction.yh
	ld (hl),$38
	inc l
	inc l
	ld (hl),$28
	ret

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wTmpcfc0.genericCutscene.state)
	or a
	jr z,++
	call interactionIncSubstate
	ld bc,-$100
	call objectSetSpeedZ
++
	jp interactionAnimate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),10
	ret

@substate2:
	call interactionDecCounter1
	ret nz
	ld a,$03
	jp interactionSetAnimation
