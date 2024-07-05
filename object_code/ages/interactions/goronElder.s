; ==================================================================================================
; INTERAC_GORON_ELDER
;
; Variables:
;   var3f: If zero, elder should face Link when he's close?
; ==================================================================================================
interactionCode8b:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
@subid1:
	call checkInteractionState
	jr nz,++
	call @loadScriptAndInitGraphics
++
	call interactionRunScript
	jp c,interactionDelete
	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc

@subid2:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	jpab agesInteractionsBank08.shootingGalleryNpc


@initGraphics: ; unused
	call interactionInitGraphics
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
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
	.dw mainScripts.goronElderScript_subid00
	.dw mainScripts.goronElderScript_subid01
