; ==================================================================================================
; INTERAC_SUBROSIAN
; ==================================================================================================
interactionCode4e:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw subrosian_subid00
	.dw subrosian_subid01
	.dw subrosian_subid02
	.dw subrosian_subid03
	.dw subrosian_subid04


; Subrosian in lynna village (linked only)
subrosian_subid00:
	call checkInteractionState
	jr nz,@state1

@state0:
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_1c00
	call interactionSetHighTextIndex

	call checkIsLinkedGame
	jp z,interactionDeleteAndUnmarkSolidPosition

	callab getGameProgress_2
	ld a,b
	cp $05
	ld hl,mainScripts.subrosianInVillageScript_afterGotMakuSeed
	jr z,@setScript
	cp $07
	jp nz,interactionDeleteAndUnmarkSolidPosition

	ld hl,mainScripts.subrosianInVillageScript_postGame

@setScript:
	call interactionSetScript

@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

subrosian_subid01:
	; Borrow goron code?
	jpab goronSubid01


; Subrosian in goron dancing game (var03 is 0 or 1 for green or red npcs)
subrosian_subid02:
	call checkInteractionState
	jr nz,@state1

@state0:
	call subrosian_initSubid02
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


; Linked game NPC telling you the subrosian secret (for bombchus)
subrosian_subid03:
	call checkInteractionState
	jr nz,subrosian_subid04@state1

@state0:
	call subrosian_initGraphicsAndIncState
	ld a,$02
	jr subrosian_subid04@initSecretTellingNpc


; Linked game NPC telling you the smith secret (for shield upgrade)
subrosian_subid04:
	call checkInteractionState
	jr nz,@state1

@state0:
	call subrosian_initGraphicsAndIncState
	ld a,$04

@initSecretTellingNpc:
	ld e,Interaction.var3f
	ld (de),a
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition
	jp npcFaceLinkAndAnimate

;;
subrosian_initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

;;
subrosian_unused_63ec:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jr subrosian_loadScript


;;
subrosian_initSubid02:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jr subrosian_loadScriptIndex

;;
; Load a script based just on the subid.
subrosian_loadScript:
	call subrosian_getScriptPtr
	call interactionSetScript
	jp interactionIncState

;;
; Load a script based on the subid and var03.
subrosian_loadScriptIndex:
	call subrosian_getScriptPtr
	inc e
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; @param[out]	hl	Pointer read from scriptTable (either points to a script or to
;			a table of scripts)
subrosian_getScriptPtr:
	ld a,>TX_1c00
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ret

@scriptTable:
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw @subid02Scripts

@subid02Scripts:
	.dw mainScripts.subrosianAtGoronDanceScript_greenNpc
	.dw mainScripts.subrosianAtGoronDanceScript_redNpc
