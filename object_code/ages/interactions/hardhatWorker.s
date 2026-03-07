; ==================================================================================================
; INTERAC_HARDHAT_WORKER
; ==================================================================================================
interactionCode58:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03


; NPC who gives you the shovel. If var03 is nonzero, he's just a generic guy.
@subid00:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptAndInitGraphics
	call interactionSetAlwaysUpdateBit
	ld a,$04
	call interactionSetAnimation
@@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


; Generic NPC.
@subid01:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptAndInitGraphics
	call interactionRunScript
	call interactionRunScript
@@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition
	jp npcFaceLinkAndAnimate


; NPC who guards the entrance to the black tower.
@subid02:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	ld a,(wEssencesObtained)
	bit 3,a
	jp nz,interactionDelete
	call getThisRoomFlags
	bit 7,a
	jr z,+
	ld bc,$3858
	call interactionSetPosition
+
	call @loadScriptAndInitGraphics
@@state1:
	call interactionRunScript
	ld e,Interaction.var38
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc


@subid03:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptAndInitGraphics
	call interactionRunScript
@@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionAnimateBasedOnSpeed
	jp interactionPushLinkAwayAndUpdateDrawPriority


@unusedFunc_6b70:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_1000
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.hardhatWorkerSubid00Script
	.dw mainScripts.hardhatWorkerSubid01Script
	.dw mainScripts.hardhatWorkerSubid02Script
	.dw mainScripts.hardhatWorkerSubid03Script
