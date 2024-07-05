; ==================================================================================================
; INTERAC_PIRATE_CAPTAIN
; ==================================================================================================
interactionCodec3:
	call checkInteractionState
	jr z,@state0

@state1:
	call objectPreventLinkFromPassing
	call interactionRunScript
	jp interactionAnimate

@state0:
	call interactionInitGraphics
	call objectSetVisible82
	call checkIsLinkedGame
	jr nz,++

	; Unlinked: mark room as in the past (for the minimap probably)
	ld hl,wTilesetFlags
	set TILESETFLAG_BIT_PAST,(hl)
++
	ld hl,mainScripts.pirateCaptainScript
	call interactionSetScript
	jp interactionIncState
