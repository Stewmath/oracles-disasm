; ==================================================================================================
; INTERAC_PLAY_HARP_SONG
; ==================================================================================================
interactionCodec5:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	call setLinkForceStateToState08
	ld hl,w1Link.yh
	call objectTakePosition
	ld e,Interaction.counter1
	ld a,$04
	ld (de),a
	jp interactionIncState

@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),52 ; [counter1]

	ld a,LINK_ANIM_MODE_HARP_2
	ld (wcc50),a

	call interactionIncState

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@sounds
	rst_addAToHl
	ld a,(hl)
	jp playSound

@sounds:
	.db SND_TUNE_OF_ECHOES
	.db SND_TUNE_OF_CURRENTS
	.db SND_TUNE_OF_AGES


; Facing left
@state2:
@state4:
	ld a,(wFrameCounter)
	and $1f
	jr nz,@stateCommon
	xor a
	ld bc,$f8f8
	call objectCreateFloatingMusicNote

@stateCommon:
	push de
	ld de,w1Link
	callab specialObjectAnimate
	pop de
	call interactionDecCounter1
	ret nz
	ld (hl),52 ; [counter1]
	jp interactionIncState


; Facing right
@state3:
@state5:
	ld a,(wFrameCounter)
	and $1f
	jr nz,@stateCommon

	ld a,$01
	ld bc,$f808
	call objectCreateFloatingMusicNote
	jr @stateCommon


; Signal to a "cutscene handler" that we're done, then delete self
@state6:
	ld hl,wTmpcfc0.genericCutscene.state
	set 7,(hl)
	ld a,LINK_ANIM_MODE_WALK
	ld (wcc50),a
	jp interactionDelete
