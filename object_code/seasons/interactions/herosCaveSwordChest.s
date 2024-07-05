; ==================================================================================================
; INTERAC_HEROS_CAVE_SWORD_CHEST
; ==================================================================================================
interactionCodec6:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a
	ld (wcca1),a
	jp interactionInitGraphics

@state1:
	ld a,(wcca2)
	or a
	ret z
	ld a,$81
	ld (wDisableLinkCollisionsAndMenu),a
	ld (wDisabledObjects),a
	call interactionIncState
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.speed
	ld (hl),SPEED_40
	ld l,Interaction.counter1
	ld (hl),$20
	jp objectSetVisible80

@state2:
	call interactionDecCounter1
	jp nz,objectApplySpeed

	call interactionIncState
	ld a,TREASURE_SWORD
	ld c,$01
	call giveTreasure
	ld a,SND_GETITEM
	call playSound
	ld bc,TX_001c
	jp showText

@state3:
	ld a,(wTextIsActive)
	or a
	ret nz
	call interactionIncState
	call objectSetInvisible
	ld e,Interaction.counter1
	ld a,90
	ld (de),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_TREASURE
	inc l
	ld (hl),>TREASURE_OBJECT_SWORD_03
	inc l
	ld (hl),<TREASURE_OBJECT_SWORD_03
	ld a,(w1Link.yh)
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a
	ld a,SNDCTRL_MEDIUM_FADEOUT
	jp playSound

@state4:
	call interactionDecCounter1
	ret nz
	call getThisRoomFlags
	set 5,(hl)
	ld hl,@warpDestVariables
	call setWarpDestVariables
	ld a,SND_FADEOUT
	call playSound
	jp interactionDelete

@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_0d4 $00 $54 $83
