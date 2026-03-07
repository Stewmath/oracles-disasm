; ==================================================================================================
; INTERAC_LIBRARIAN
; ==================================================================================================
interactionCode2a:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.textID+1
	ld (hl),>TX_2700

	ld l,Interaction.collisionRadiusY
	ld (hl),$0c
	inc l
	ld (hl),$06

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld a,<TX_2715
	jr z,+
	ld a,<TX_2716
+
	ld e,Interaction.textID
	ld (de),a

	call objectSetVisiblec2

	ld hl,mainScripts.librarianScript
	jp interactionSetScript
