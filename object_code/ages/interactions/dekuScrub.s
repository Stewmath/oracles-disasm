; ==================================================================================================
; INTERAC_DEKU_SCRUB
;
; Variables:
;   var3e: 0 if the deku scrub is hiding, 1 if not
;   var3f: Secret index (for "linkedGameNpcScript")
; ==================================================================================================
interactionCoded6:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initialize
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.var3f
	ld (hl),DEKU_SECRET & $0f
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript

@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition

	call interactionAnimateAsNpc
	ld c,$20
	call objectCheckLinkWithinDistance
	ld h,d
	ld l,Interaction.var3e
	jr c,@linkIsClose

	ld a,(hl) ; [var3e]
	or a
	ret z
	xor a
	ld (hl),a
	ld a,$03
	jp interactionSetAnimation

@linkIsClose:
	ld a,(hl) ; [var3e]
	or a
	ret nz
	inc (hl) ; [var3e]
	ld a,$01
	jp interactionSetAnimation

@initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState
