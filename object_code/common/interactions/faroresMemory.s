; ==================================================================================================
; INTERAC_FARORES_MEMORY
; ==================================================================================================
interactionCode1c:
	call checkInteractionState
	jp nz,interactionRunScript

; Initialization

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr nz,+
	call checkIsLinkedGame
	jp z,interactionDelete
+
	call interactionInitGraphics
	call objectSetVisible83

	ld hl,mainScripts.faroresMemoryScript
	call interactionSetScript

	jp interactionIncState
