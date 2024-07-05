; ==================================================================================================
; INTERAC_INTRO_SPRITE
; ==================================================================================================
interactionCode75:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionIncState
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@notSubdId0
	ld hl,mainScripts.script6f48
	call interactionSetScript
	jp objectSetVisible82
@notSubdId0:
	ld h,d
	ld l,$4b
	ld (hl),$70
	inc l
	inc l
	ld (hl),$80
	ld l,$49
	ld (hl),$18
	ld l,$50
	ld (hl),$05
	ld l,$42
	ld a,(hl)
	cp $02
	jp z,objectSetVisible83
	ld l,$46
	ld (hl),$05
	jp objectSetVisible82
@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	dec a
	add GFXH_INTRO_LINK_MID_FRAME_1
	push de
	call loadGfxHeader
	ld a,UNCMP_GFXH_0c
	call loadUncompressedGfxHeader
	pop de
	ret
@subid1:
	call checkInteractionSubstate
	jr nz,@subid2
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jr z,@subid2
	ld (hl),$00
	ld l,$46
	dec (hl)
	jr nz,@subid2
	ld l,$45
	inc (hl)
	ld a,$04
	call interactionSetAnimation
@subid2:
	ld hl,$cbb6
	ld a,(hl)
	or a
	ret z
	jp objectApplySpeed
