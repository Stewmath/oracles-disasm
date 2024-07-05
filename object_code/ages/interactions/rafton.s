; ==================================================================================================
; INTERAC_RAFTON
;
; Variables:
;   var38: "behaviour" (what he does based on the stage in the game)
; ==================================================================================================
interactionCode69:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	; Bit 7 of room flags set when Rafton isn't in this room?
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete

	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_2700
	call interactionSetHighTextIndex

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01

@initSubid00:
	ld a,GLOBALFLAG_RAFTON_CHANGED_ROOMS
	call checkGlobalFlag
	jp nz,interactionDelete
	ld c,$04
	ld a,TREASURE_ISLAND_CHART
	call checkTreasureObtained
	jr c,@setBehaviour

	dec c
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON
	call checkGlobalFlag
	jr nz,@setBehaviour

	dec c
	ld a,TREASURE_CHEVAL_ROPE
	call checkTreasureObtained
	jr c,@setBehaviour

	dec c
	ld a,(wEssencesObtained)
	bit 1,a
	jr nz,@setBehaviour
	dec c

@setBehaviour:
	ld h,d
	ld l,Interaction.var38
	ld (hl),c
	jr @loadScript


@initSubid01:
	ld a,GLOBALFLAG_RAFTON_CHANGED_ROOMS
	call checkGlobalFlag
	jp z,interactionDelete
	jr @loadScript


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runSubid01

@runSubid00:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var38
	ld a,(de)
	cp $04
	jp z,interactionAnimateBasedOnSpeed
	jp interactionAnimateAsNpc

@runSubid01:
	call interactionAnimateAsNpc
	jp interactionRunScript

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.rafton_subid00Script
	.dw mainScripts.rafton_subid01Script
