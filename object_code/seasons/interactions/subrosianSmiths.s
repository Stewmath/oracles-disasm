; ==================================================================================================
; INTERAC_SUBROSIAN_SMITHS
; ==================================================================================================
interactionCode34:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionInitGraphics
+
	call interactionAnimateAsNpc
	ld e,$61
	ld a,(de)
	cp $ff
	ret nz
	ld a,$50
	jp playSound
