; ==================================================================================================
; INTERAC_HORON_DOG
; ==================================================================================================
interactionCode82:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld h,d
	ld l,$4e
	xor a
	ldi (hl),a
	ld (hl),a
	call func_7a99
	ld l,$46
	ld (hl),$5a
	call interactionInitGraphics
	jp objectSetVisible82
@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
@substate0:
	call @func_7a09
	call objectGetRelatedObject1Var
	ld l,$4d
	ld a,(hl)
	add $08
	ld b,a
	ld e,l
	ld a,(de)
	cp b
	jr c,@func_79fc
	call interactionIncSubstate
	ld l,$46
	ld (hl),$14
	ld a,$06
	call interactionSetAnimation
	jr @func_7a06
@func_79fc:
	ld e,$46
	ld a,(de)
	or a
	jp z,func_7a93
	jp interactionDecCounter1
@func_7a06:
	call func_7a93
@func_7a09:
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects
@substate1:
	call @func_7a06
	call interactionDecCounter1
	ret nz
	ld l,$49
	ld (hl),$18
	ld l,$50
	ld (hl),$28
	jp interactionIncSubstate
@substate2:
	call @func_7a06
	call objectGetRelatedObject1Var
	ld l,$4d
	ld a,(hl)
	add $04
	call func_7a9f
	jp nz,objectApplySpeed
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0c
	ld l,$4e
	xor a
	ldi (hl),a
	ld (hl),a
	jp func_7aa5
@substate3:
	call @func_7a09
	call interactionDecCounter1
	jp z,@func_7a4f
	call objectApplySpeed
	jr ++
@func_7a4f:
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ld l,$49
	ld (hl),$08
	ld a,$05
	call interactionSetAnimation
++
	jp func_7aa5
@substate4:
	call @func_7a09
	call func_7aa5
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate
@substate5:
	call @func_7a06
	call func_7aa5
	call objectApplySpeed
	ld e,$76
	ld a,(de)
	call func_7a9f
	ret nz
	ld hl,$cceb
	ld (hl),$02
	ld h,d
	ld l,$45
	ld (hl),$00
	ld l,$4e
	xor a
	ldi (hl),a
	ld (hl),a
	ld l,$46
	ld (hl),$3c
	ret
func_7a93:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
func_7a99:
	ld bc,$ff40
	jp objectSetSpeedZ
func_7a9f:
	ld b,a
	ld e,$4d
	ld a,(de)
	cp b
	ret
func_7aa5:
	ld a,$40
	call objectGetRelatedObject1Var
	ld e,$49
	ld a,(de)
	cp $18
	ld c,$07
	jr nz,+
	ld c,$fb
+
	ld b,$fe
	jp objectCopyPositionWithOffset
