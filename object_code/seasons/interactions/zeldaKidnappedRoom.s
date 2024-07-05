; ==================================================================================================
; INTERAC_ZELDA_KIDNAPPED_ROOM
; ==================================================================================================
interactionCodec3:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call checkInteractionSubstate
	jr nz,@substate1
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp nz,interactionDelete
	callab scriptHelp.zeldaKidnappedRoom_loadZeldaAndMoblins
	jp interactionIncSubstate
@substate1:
	call returnIfScrollMode01Unset
	call interactionIncState
	ld hl,mainScripts.ZeldaBeingKidnappedScript
	call interactionSetScript
@state1:
	jp interactionRunScript
