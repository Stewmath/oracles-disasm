; ==================================================================================================
; INTERAC_POE
;
; var3e: Animations don't update when nonzero. (Used when disappearing.)
; var3f: If nonzero, doesn't face toward Link.
; ==================================================================================================
interactionCode59:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02


; (Note, these are labelled as subid, but they're really based on var03.)
; First encounter with poe.
@initSubid00:
	; Delete self if already talked (either in overworld on in tomb)
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	ld hl,wPresentRoomFlags+$2e
	bit 6,(hl)
	jp nz,interactionDelete

	jr @init


; Final encounter with poe where you get the clock
@initSubid02:
	; Delete self if already got item, or haven't talked yet in either overworld or
	; tomb
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,(hl)
	jp nz,interactionDelete
	bit 6,(hl)
	jp z,interactionDelete
	ld hl,wPresentRoomFlags+$2e
	bit 6,(hl)
	jp z,interactionDelete

	jr @init


; Poe in his tomb
@initSubid01:
	; Delete self if haven't talked in overworld, or have talked in tomb.
	ld hl,wPresentRoomFlags+$7c
	bit 6,(hl)
	jp z,interactionDelete
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete

@init:
	call @loadScriptAndInitGraphics
@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3e
	ld a,(de)
	or a
	ret nz
	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects


@unusedFunc_6bff:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
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
	.dw mainScripts.poeScript
