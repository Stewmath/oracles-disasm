; ==================================================================================================
; INTERAC_TOKKEY
; ==================================================================================================
interactionCode9d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call interactionInitGraphics
	ld a,>TX_2c00
	call interactionSetHighTextIndex
	ld hl,mainScripts.tokkeyScript
	call interactionSetScript
	call objectSetVisible82
	jp interactionIncState


@state1:
	; Check that Link's talked to the guy once
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 0,a
	jr z,@runScript

	ld a,(wLinkPlayingInstrument)
	cp $01
	jr nz,@runScript

	call checkLinkCollisionsEnabled
	ret nc

	ld a,(wActiveTilePos)
	cp $32
	jr z,++
	ld bc,TX_2c05
	jp showText
++
	ld a,60
	ld bc,$f810
	call objectCreateExclamationMark
	ld hl,mainScripts.tokkeyScript_justHeardTune
	call interactionSetScript
	jp interactionIncState

@runScript:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


@state2:
	call @checkCreateMusicNote
	call interactionAnimate

@state4:
	call interactionRunScript
	ld c,$20
	jp objectUpdateSpeedZ_paramC

@state3:
	call @checkCreateMusicNote
	call interactionRunScript
	call interactionAnimate
	call interactionAnimate
	ld c,$60
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,-$200
	jp objectSetSpeedZ


@checkCreateMusicNote:
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 1,a
	ret z
	ld a,(wFrameCounter)
	and $0f
	ret nz
	call getRandomNumber
	and $01
	ld bc,$f808
	jp objectCreateFloatingMusicNote
