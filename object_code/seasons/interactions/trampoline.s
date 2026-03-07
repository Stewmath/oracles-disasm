; ==================================================================================================
; INTERAC_TRAMPOLINE
; ==================================================================================================
interactionCode7c:
	call objectSetPriorityRelativeToLink
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$07
	call objectSetCollideRadius
	ld a,$14
	ld l,$50
	ld (hl),a
	jp objectSetVisible82
@state1:
	call returnIfScrollMode01Unset
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	jp func_76d4
@state2:
	ld a,($d00f)
	or a
	jr nz,@func_7677
	xor a
	ld e,$70
	ld (de),a
	ld a,$07
	call objectSetCollideRadius
	call objectPreventLinkFromPassing
	jr nc,@func_7671
	call objectCheckLinkPushingAgainstCenter
	jr nc,@func_7671
	ld a,$01
	ld (wForceLinkPushAnimation),a
	call interactionDecCounter1
	ret nz
	ld c,$28
	call objectCheckLinkWithinDistance
	ld e,$48
	xor $04
	ld (de),a
	call interactionCheckAdjacentTileIsSolid_viaDirection
	ret nz
	ld h,d
	ld l,$48
	ld a,(hl)
	add a
	add a
	ld l,$49
	ld (hl),a
	ld l,$46
	ld (hl),$20
	ld l,$44
	inc (hl)
	call func_76e0
	ld a,$71
	jp playSound
@func_7671:
	ld e,$46
	ld a,$1e
	ld (de),a
	ret
@func_7677:
	ld a,$0a
	call objectSetCollideRadius
	ld a,($d00b)
	ld b,a
	ld a,($d00d)
	ld c,a
	call interactionCheckContainsPoint
	ret nc
	ld a,($d00f)
	ld b,a
	cp $e8
	jr nc,+
	ld e,$70
	ld (de),a
+
	ld a,b
	cp $fc
	ret c
	ld e,$70
	ld a,(de)
	or a
	jr nz,+
	callab scriptHelp.trampoline_bounce
+
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	xor a
	call interactionSetAnimation
	ld a,$53
	jp playSound
@state3:
	call objectApplySpeed
	call objectPreventLinkFromPassing
	call interactionDecCounter1
	ret nz
	ld l,$44
	dec (hl)
	ld l,$46
	ld (hl),$1e
	jr func_76d4
@state4:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ret
func_76d4:
	call objectGetTileAtPosition
	ld e,$71
	ld (de),a
	ld (hl),$07
	dec h
	ld (hl),$14
	ret
func_76e0:
	call objectGetTileAtPosition
	ld e,$71
	ld a,(de)
	ld (hl),a
	dec h
	ld (hl),$00
	ret
