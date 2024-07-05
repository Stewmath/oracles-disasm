; ==================================================================================================
; INTERAC_SUBROSIAN_WITH_BUCKETS
; ==================================================================================================
interactionCode32:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$6b
	ld (hl),$00
	ld l,$49
	ld (hl),$ff
	ld l,$42
	ld a,(hl)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionRunScript
	call interactionRunScript
	jp c,interactionDelete
	jr @animateAsNpc
@state1:
	ld a,(wActiveGroup)
	dec a
	jr nz,+
	call objectGetTileAtPosition
	ld (hl),$00
+
	call interactionRunScript
	ld c,$28
	call objectCheckLinkWithinDistance
	jr c,+
	ld a,$04
+
	ld l,$49
	cp (hl)
	jr z,@animateAsNpc
	ld (hl),a
	rrca
	call interactionSetAnimation
@animateAsNpc:
	jp interactionAnimateAsNpc
@scriptTable:
	.dw mainScripts.bucketSubrosianScript_text1
	.dw mainScripts.bucketSubrosianScript_text2
	.dw mainScripts.bucketSubrosianScript_text3
	.dw mainScripts.bucketSubrosianScript_text4
	.dw mainScripts.bucketSubrosianScript_text5
	.dw mainScripts.bucketSubrosianScript_text6
	.dw mainScripts.bucketSubrosianScript_text1
	.dw mainScripts.bucketSubrosianScript_text1
