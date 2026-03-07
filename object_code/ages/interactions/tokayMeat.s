; ==================================================================================================
; INTERAC_TOKAY_MEAT
; ==================================================================================================
interactionCode8c:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30
	ld a,$08
	call objectSetCollideRadius

	ld bc,$3850
	call interactionSetPosition
	ld l,Interaction.zh
	ld (hl),-$40
	ld bc,$0000
	jp objectSetSpeedZ


@state1:
	call objectAddToGrabbableObjectBuffer
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0: ; Starts falling
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jp nz,interactionDecCounter1
	call interactionIncSubstate
	call objectSetVisiblec1
	ld a,SND_FALLINHOLE
	jp playSound

@@substate1: ; Wait for it to land
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld a,SND_BOMB_LAND
	jp playSound

@@substate2: ; Sitting on the ground
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; State 2 = grabbed by power bracelet state
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released

@justGrabbed:
	ld a,d
	ld (wTmpcfc0.wildTokay.activeMeatObject),a
	ld a,e
	ld (wTmpcfc0.wildTokay.activeMeatObject+1),a

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_TOKAY_MEAT
	jp interactionIncSubstate

@beingHeld:
	ret

@released:
	ld e,Interaction.zh
	ld a,(de)
	rlca
	ret c

	call dropLinkHeldItem
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),20
	jp objectSetVisible83


@state3: ; Disappearing after being dropped on the ground
	call interactionDecCounter1
	jr nz,+
	jp interactionDelete
+
	ld a,(wFrameCounter)
	and $01
	jp z,objectSetInvisible
	jp objectSetPriorityRelativeToLink
