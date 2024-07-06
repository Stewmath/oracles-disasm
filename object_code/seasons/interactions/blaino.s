; ==================================================================================================
; INTERAC_BLAINO
; var37 - 0 if enough rupees, else 1
; var38 - RUPEEVAL_10 if cheated, otherwise RUPEEVAL_20
; var39 - pointer to Blaino / script ???
; $ccec - result of fight - $01 if won, $02 if lost, $03 if cheated
; $cced - $00 on init, $01 when starting fight, $03 when fight done
; ==================================================================================================
interactionCode72:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,blainoSubid01
	; subid00
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw interactionDelete

@state0:
	call interactionIncState
	ld a,($cced)
	cp $00
	jr z,+
	cp $01
	jr z,++
	cp $03
	jr z,+
+
	ld l,Interaction.var38
	ld (hl),$01
	ld l,Interaction.var37
	ld (hl),$02
	ld a,$06
	call objectSetCollideRadius
	call seasonsFunc_09_7055
	call interactionInitGraphics
	jr @animate
++
	ld l,Interaction.var38
	ld (hl),$00
	call interactionInitGraphics
	ld a,$01
	jp interactionSetAnimation
	jr +

@state1:
	ld e,Interaction.var38
	ld a,(de)
	or a
	jr z,+
	call seasonsFunc_09_7036
	call seasonsFunc_09_704f
@animate:
	call interactionAnimate
+
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects

blainoSubid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$04
	call interactionSetAnimation
	jp objectSetVisiblec1

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cbb5)
	or a
	jr z,@substate2
	ld h,d
	ld l,Interaction.substate
	inc (hl)
	ld l,Interaction.animCounter
	ld (hl),$01
	xor a
	ld l,Interaction.z
	ldi (hl),a
	; zh
	ld (hl),a
	jp interactionAnimate

@substate1:
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	jr z,+
	ld l,Interaction.substate
	inc (hl)
+
	jp interactionAnimate

@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld bc,$ff40
	jp objectSetSpeedZ

seasonsFunc_09_7036:
	ld a,(wFrameCounter)
	and $07
	ret nz
	call objectGetAngleTowardLink
	add $04
	and $18
	swap a
	rlca
	ld h,d
	ld l,Interaction.var37		; fickleOldManScript_text2
	cp (hl)
	ret z			; fickleOldManScript_text3
	ld (hl),a
	jp interactionSetAnimation

seasonsFunc_09_704f:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ret nz

seasonsFunc_09_7055:
	ld e,Interaction.speedZ
	ld a,$80
	ld (de),a
	inc e
	ld a,$ff
	ld (de),a
	ret
