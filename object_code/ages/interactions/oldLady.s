; ==================================================================================================
; INTERAC_OLD_LADY
; ==================================================================================================
interactionCode3d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid

	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid0
	.dw @loadScript
	.dw @initSubid2
	.dw @initSubid3
	.dw @initSubid4
	.dw @initSubid5

@initSubid0:
	ld a,$03
	call interactionSetAnimation

	; Check whether her grandson is stone
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jr z,@loadScript

	; Set var03 to nonzero if her grandson is stone, also change her position
	ld a,$01
	ld e,Interaction.var03
	ld (de),a
	ld bc,$4878
	call interactionSetPosition

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,oldLadyScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid2:
	; This NPC only exists between saving Nayru and beating d7?
	callab agesInteractionsBank09.getGameProgress_1
	ld e,Interaction.subid
	ld a,(de)
	cp b
	jp nz,interactionDelete
	jr @loadScript

@initSubid3:
	ld e,Interaction.counter1
	ld a,220
	ld (de),a

	ld a,$03
	jp interactionSetAnimation

@initSubid4:
	ld a,$00
	jr ++

@initSubid5:
	ld a,$09
++
	ld e,Interaction.var3f
	ld (de),a
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript
	jr @state1

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw @runSubid1
	.dw @runSubid2
	.dw @runSubid3
	.dw @runSubid4
	.dw @runSubid5


; NPC with a grandson that is stone for part of the game
@runSubid0:
	call interactionRunScript

	ld e,Interaction.var03
	ld a,(de)
	or a
	jp z,interactionAnimateAsNpc
	jp npcFaceLinkAndAnimate


; Cutscene where her grandson gets turned to stone
@runSubid1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	call interactionAnimate
	call interactionRunScript
	jr nc,++

	; Script ended
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),60
	ret
++
	ld e,Interaction.counter2
	ld a,(de)
	or a
	jp nz,interactionAnimate2Times
	ret

@@substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),20
	jp interactionIncSubstate

@@substate2:
	call interactionDecCounter1
	jp nz,interactionAnimate3Times
	ld (hl),60
	jp interactionIncSubstate

@@substate3:
	call interactionDecCounter1
	ret nz
	ld a,$ff
	ld ($cfdf),a
	ret


; NPC in present, screen left from bipin&blossom's house
@runSubid2:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


; Cutscene where her grandson is restored from stone
@runSubid3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionDecCounter1
	ret nz
	call startJump
	jp interactionIncSubstate

@@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.var38
	ld (hl),$b4
	jp @loadScript

@@substate2:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	jr nz,++
	ld a,$ff
	ld ($cfdf),a
++
	call interactionRunScript
	jp interactionAnimateBasedOnSpeed


; Linked game NPC
@runSubid4:
@runSubid5:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


oldLadyScriptTable:
	.dw mainScripts.oldLadySubid0Script
	.dw mainScripts.oldLadySubid1Script
	.dw mainScripts.oldLadySubid2Script
	.dw mainScripts.oldLadySubid3Script
