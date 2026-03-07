; ==================================================================================================
; INTERAC_ADLAR
; ==================================================================================================
interactionCode29:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@state0:
	call interactionInitGraphics
	call interactionIncState

	; Decide on a value to write to var38; this will affect the script.

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld a,$04
	jr nz,@setVar38

	ld hl,wGroup4RoomFlags+$fc
	bit 7,(hl)
	ld a,$03
	jr nz,@setVar38

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ld a,$02
	jr nz,@setVar38

	call getThisRoomFlags
	bit 6,(hl)
	ld a,$01
	jr nz,@setVar38
	xor a
@setVar38:
	ld e,Interaction.var38
	ld (de),a
	call objectSetVisiblec2

	ld hl,mainScripts.adlarScript
	jp interactionSetScript
