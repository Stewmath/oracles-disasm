; ==================================================================================================
; INTERAC_LINKED_FOUNTAIN_LADY
; ==================================================================================================
interactionCoded8:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_GNARLED_KEY_GIVEN
	call checkGlobalFlag
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld l,$7e
	ld (hl),GLOBALFLAG_BEGAN_FAIRY_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc
