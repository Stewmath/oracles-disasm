; ==================================================================================================
; INTERAC_TALON
; ==================================================================================================
interactionCode45:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	or a
	jr nz,@@subid1
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	ld h,d
	ld l,$44
	ld (hl),$01
	ld l,$79
	ld (hl),$01
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.caveTalonScript
	call interactionSetScript
	ld a,$03
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@@subid1:
	ld h,d
	ld l,$44
	ld (hl),$02
	ld l,$78
	ld (hl),$ff
	call func_6f3c
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.returnedTalonScript
	call interactionSetScript
	jp interactionAnimateAsNpc
@state1:
	ld e,$79
	ld a,(de)
	or a
	jr z,+
	ld a,(wFrameCounter)
	and $3f
	jr nz,+
	ld a,$01
	ld b,$fa
	ld c,$0a
	call objectCreateFloatingSnore
+
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimate
	ld e,$7a
	ld a,(de)
	or a
	jr nz,+
	call objectPreventLinkFromPassing
+
	jp objectSetPriorityRelativeToLink_withTerrainEffects
@state2:
	call interactionRunScript
	call func_6f3c
	jp interactionAnimateAsNpc
func_6f3c:
	ld c,$28
	call objectCheckLinkWithinDistance
	jr nc,+
	ld e,$78
	ld a,(de)
	cp $06
	ret z
	ld a,$06
	jr ++
+
	ld e,$78
	ld a,(de)
	cp $05
	ret z
	ld a,$05
++
	ld (de),a
	jp interactionSetAnimation
