; ==================================================================================================
; INTERAC_STONE_PANEL
; ==================================================================================================
interactionCode7b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw objectPreventLinkFromPassing

@state0:
	ld bc,$0e08
	call objectSetCollideRadii
	call interactionInitGraphics
	call objectSetVisible83
	ld a,PALH_7e
	call loadPaletteHeader
	call getThisRoomFlags
	and $40
	jr nz,@initializeOpenedState

	; Closed
	ld hl,wRoomCollisions+$66
	ld a,$0f
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	jp interactionIncState

@initializeOpenedState:
	ld e,Interaction.state
	ld a,$03
	ld (de),a

	; Move position 10 left or right
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld b,$10
	jr nz,+
	ld b,$f0
+
	ld e,Interaction.xh
	ld a,(de)
	add b
	ld (de),a

	ld e,Interaction.state
	ld a,$03
	ld (de),a

@updateSolidityUponOpening:
	ld hl,wRoomCollisions+$66
	xor a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld l,$46
	ld (hl),$02
	ld l,$56
	ld (hl),$0a
	ld l,$66
	ld (hl),$08
	ld l,$48
	ld (hl),$01
	ld l,$58
	ld (hl),$05
	ld l,$68
	ld (hl),$04
	ret

; Wait for bit 7 of wActiveTriggers to open the panel.
@state1:
	call objectPreventLinkFromPassing
	ld a,(wActiveTriggers)
	bit 7,a
	ret z

	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld e,Interaction.counter1
	ld a,60
	ld (de),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp interactionIncState

@state2:
	call objectPreventLinkFromPassing
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0: ; Delay before opening
	call interactionDecCounter1
	ret nz

	ld (hl),$80
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld a,ANGLE_LEFT
	jr z,+
	ld a,ANGLE_RIGHT
+
	ld e,Interaction.angle
	ld (de),a
	ld e,Interaction.speed
	ld a,SPEED_20
	ld (de),a

	ld a,SND_OPENING
	call playSound
	jp interactionIncSubstate

@substate1: ; Currently opening
	ld a,(wFrameCounter)
	rrca
	ret nc
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	ld (hl),30
	jp interactionIncSubstate

@substate2: ; Done opening
	call interactionDecCounter1
	ret nz

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld hl,wActiveTriggers
	res 7,(hl)
	call getThisRoomFlags
	set 6,(hl)

	call @updateSolidityUponOpening
	ld a,(wActiveMusic)
	call playSound
	jp interactionIncState
