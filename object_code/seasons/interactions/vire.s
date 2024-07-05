; ==================================================================================================
; INTERAC_VIRE
; ==================================================================================================
interactionCodee3:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld bc,$fe00
	call objectSetSpeedZ
	ld hl,mainScripts.vireScript
	call interactionSetScript
	ld a,$bb
	call playSound
	ld a,$00
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	call func_6ede
	ld e,$4f
	ld a,(de)
	cp $e0
	jr c,+
	jp interactionAnimateAsNpc
+
	call interactionIncSubstate
	ld a,$39
	ld (wActiveMusic),a
	call playSound
	ld a,$01
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@substate1:
	callab seasonsInteractionsBank0a.seasonsFunc_0a_71ce
	call interactionRunScript
	jr c,+
	jp interactionAnimateAsNpc
+
	call interactionIncSubstate
	ld a,$74
	call playSound
	ld bc,$fc00
	call objectSetSpeedZ
@substate2:
	call func_6ede
	ld e,$4f
	ld a,(de)
	cp $b0
	jr c,+
	jp interactionAnimateAsNpc
+
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	call interactionIncSubstate
@substate3:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_JEWEL_HELPER
	inc l
	ld (hl),$07
	ld l,$4b
	ld (hl),$7c
	ld l,$4d
	ld (hl),$78
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_PUFF
	ld a,$78
	ld l,$4b
	ldi (hl),a
	inc l
	ld (hl),a
+
	jp interactionDelete
func_6ede:
	ldh a,(<hActiveObjectType)
	add $0e
	ld l,a
	add $06
	ld e,a
	ld h,d
	jp objectApplyComponentSpeed@addSpeedComponent
