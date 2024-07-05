; ==================================================================================================
; INTERAC_BOMB_FLOWER
; ==================================================================================================
interactionCode6f:
.ifdef ROM_AGES
	jp interactionDelete
.else
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw bomb_flower_subid0
	.dw bomb_flower_subid1

bomb_flower_subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a

	call getThisRoomFlags
	bit 5,(hl)
	jr nz,+

	ld a,TREASURE_BOMB_FLOWER
	call checkTreasureObtained
	jr c,+

	ld a,$04
	call objectSetCollideRadius
	call interactionInitGraphics
	jp objectSetVisible82
+
	jp interactionDelete

@state1:
	call objectGetTileAtPosition
	ld (hl),$00
	call objectPreventLinkFromPassing
	jp objectAddToGrabbableObjectBuffer

@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call interactionIncSubstate
	ld a,$1c
	ld (wDisabledObjects),a
	xor a
	ld (wLinkGrabState2),a
	call interactionSetAnimation
	call objectSetVisible81
	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_DUG_HOLE
	jp setTile

@substate1:
	ld a,(wLinkGrabState)
	cp $83
	ret nz

	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call dropLinkHeldItem

	ld e,Interaction.substate
	ld a,$02
	ld (de),a

	call getThisRoomFlags
	set 5,(hl)
	ld a,LINK_STATE_04
	ld (wLinkForceState),a
	ld a,$01
	ld (wcc50),a
	ld bc,TX_003c
	call showText
	ld a,TREASURE_BOMB_FLOWER
	jp giveTreasure

@substate2:
@substate3:
	call retIfTextIsActive
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call updateLinkLocalRespawnPosition
	jp interactionDelete

bomb_flower_subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a

	ld hl,mainScripts.bombflower_unblockAutumnTemple
	call interactionSetScript
	call interactionInitGraphics
	xor a
	call interactionSetAnimation
	jp objectSetVisible82

@state2:
	call interactionAnimate

@state1:
	call interactionAnimate
	jp interactionRunScript

@state3:
	call objectSetInvisible
	jp interactionRunScript

.endif ; ROM_SEASONS
