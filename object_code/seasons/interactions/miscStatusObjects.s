; ==================================================================================================
; INTERAC_MISC_STATIC_OBJECTS
; ==================================================================================================
interactionCode4c:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
	.dw @subid8
	.dw @subid9
	.dw @subidA
	.dw @subidB
	.dw @subidC
	.dw @subidD

	call @func_72de
	jp objectSetVisible80
	call @func_72de
	jp objectSetVisible81
@subid1:
@subid2:
@subid3:
	call @func_72de
	jp objectSetVisible82
@subid6:
@subidA:
@subidB:
@subidC:
@subidD:
	call @func_72de
	jp objectSetVisible83
@subid0:
	call checkInteractionState
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$40
	set 7,(hl)
	call interactionInitGraphics
	jp objectSetVisible80
+
	call getThisRoomFlags
	bit 6,(hl)
	jr z,+
	ld e,$60
	ld a,(de)
	cp $10
	jr nz,+
	ld a,$02
	ld (de),a
+
	jp interactionAnimate
@func_72de:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	jp interactionInitGraphics
+
	pop hl
	jp interactionAnimate
@subid7:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld a,$9b
	call loadPaletteHeader
	call interactionInitGraphics
	call objectSetVisible82
+
	jp interactionAnimate
@subid8:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	call interactionInitGraphics
	call objectSetVisible80
+
	call interactionAnimate
	ld a,(wFrameCounter)
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible
@subid9:
	call checkInteractionState
	ret nz
	call getThisRoomFlags
	and $40
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	jp objectSetVisible83
@subid4:
@subid5:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld bc,$fe00
	call objectSetSpeedZ
	ld l,$49
	ld (hl),$01
	ld l,$50
	ld (hl),$28
	ld a,$51
	call playSound
	call interactionInitGraphics
	jp objectSetVisiblec0
+
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld a,$77
	call playSound
	jp interactionDelete
