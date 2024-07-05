; ==================================================================================================
; INTERAC_RAFTWRECK_CUTSCENE
; ==================================================================================================
interactionCode9b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_40,a
	jp nz,interactionDelete

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.xh
	ld c,(hl)
	ld b,$76
	call interactionSetPosition
	call setLinkForceStateToState08
	ld (wTmpcfc0.genericCutscene.cfd0),a
	jp interactionIncState

@state1:
	call @updateSubstate
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.yh
	jp objectCopyPosition

@updateSubstate:
	ld e,Interaction.substate
	ld a,(de)
	cp $02
	call nc,interactionRunScript
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
	ld a,(wScrollMode)
	and SCROLLMODE_01
	ret z

	; Initialize Link's speed/direction to move to the center of the screen
	call interactionIncSubstate
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.xh
	ld a,(hl)
	sub $50
	ld c,DIR_LEFT
	ld b,ANGLE_LEFT
	jr nc,++
	ld c,DIR_RIGHT
	ld b,ANGLE_RIGHT
	cpl
	inc a
++
	ld l,Interaction.angle
	ld (hl),b
	ld l,Interaction.counter1
	add a
	ld (hl),a
	ld a,c
	jp setLinkDirection

@substate1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,++
	dec (hl)
	jp objectApplySpeed
++
	; Begin the script
	call interactionIncSubstate
	ld hl,mainScripts.raftwreckCutsceneScript
	jp interactionSetScript

@substate2:
	ld a,(wTmpcfc0.genericCutscene.state)
	cp $01
	ret nz

@initScreenFlashing:
	ld hl,wGenericCutscene.cbb3
	ld (hl),$00
	ld hl,wGenericCutscene.cbba
	ld (hl),$ff
	jp interactionIncSubstate

@substate3:
@substate5:
	ld hl,wGenericCutscene.cbb3
	ld b,$01
	call flashScreen
	ret z

	call interactionIncSubstate
	ldi a,(hl)
	cp $03
	ld a,$5a
	jr z,+
	ld a,$78
+
	ld (hl),a
	ld a,$f1
	ld (wPaletteThread_parameter),a
	jp darkenRoom

@substate4:
	call interactionDecCounter1
	ret nz
	jr @initScreenFlashing

@substate6:
	call interactionDecCounter1
	ret nz
	ld a,$02
	ld (wTmpcfc0.genericCutscene.state),a
	jp interactionIncSubstate

@substate7:
	ld a,(wTmpcfc0.genericCutscene.state)
	cp $03
	jr nz,++

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),20
	ret
++
	ld e,Interaction.var38
	ld a,(de)
	or a
	ret z
	jp @oscillateY

@substate8:
	call interactionDecCounter1
	ret nz
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	call getThisRoomFlags
	set ROOMFLAG_BIT_40,(hl)
	ld hl,w1Companion.enabled
	res 1,(hl)
	ld a,>w1Link
	ld (wLinkObjectIndex),a
	ld hl,@tokayWarpDest
	jp setWarpDestVariables

@tokayWarpDest:
	m_HardcodedWarpA ROOM_AGES_1aa, $00, $42, $03

@oscillateY:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,@yOscillation
	rst_addAToHl
	ld e,Interaction.yh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@yOscillation:
	.db $ff $fe $ff $00 $01 $02 $01 $00
