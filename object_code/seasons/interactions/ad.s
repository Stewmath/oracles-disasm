; ==================================================================================================
; INTERAC_ad
; ==================================================================================================
interactionCodead:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectGetAngleTowardLink
	ld e,$49
	ld (de),a
	ld hl,mainScripts.script779e
	call interactionSetScript
	ld e,$42
	ld a,(de)
	ld hl,@table_6a67
	rst_addAToHl
	ld a,(hl)
	ld e,$76
	ld (de),a
	ld bc,$ff40
	call objectSetSpeedZ
	jp objectSetVisible82
@table_6a67:
	.db $10 $20 $18 $28 $08
@state1:
	ld e,$42
	ld a,(de)
	and $01
	call nz,func_6ae7
	call interactionAnimateAsNpc
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
@substate0:
	ld a,($c4ab)
	or a
	ret nz
	ld h,d
	ld l,$76
	dec (hl)
	ret nz
	jp interactionIncSubstate
@substate1:
	ld a,($cfc0)
	cp $01
	jr nz,+
	call interactionIncSubstate
	ld bc,$fe80
	jp objectSetSpeedZ
+
	ld e,$46
	ld a,(de)
	or a
	call nz,interactionAnimate
	jp interactionRunScript
@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$08
	ld l,$49
	ld a,(hl)
	add $10
	and $1f
	ld (hl),a
	ld l,$50
	ld (hl),$50
	ld l,$42
	ld a,(hl)
	add a
	inc a
	jp interactionSetAnimation
@substate3:
	call interactionDecCounter1
	ret nz
	ld l,$46
	ld (hl),$40
	jp interactionIncSubstate
@substate4:
	call interactionDecCounter1
	jp z,interactionDelete
	call objectApplySpeed
	call interactionAnimate
	jp interactionAnimateAsNpc
func_6ae7:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,$ff40
	jp objectSetSpeedZ
