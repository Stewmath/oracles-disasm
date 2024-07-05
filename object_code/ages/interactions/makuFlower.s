; ==================================================================================================
; INTERAC_MAKU_FLOWER
; ==================================================================================================
interactionCode86:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

; Present maku tree flower
@subid0:
	call checkInteractionState
	jr nz,@subid0State1

@subid0State0:
	call interactionInitGraphics
	call objectSetVisible82
	call interactionSetAlwaysUpdateBit
	call interactionIncState

@subid0State1:
	; Watch var3b of relatedObject1 to set the flower's animation
	ld a,Object.var3b
	call objectGetRelatedObject2Var
	ld a,(hl)
	ld bc,@anims
	call addAToBc
	ld a,(bc)
	cp $01
	jr z,@setAnimA
	ld b,a
	ld l,Interaction.subid
	ld a,(hl)
	cp $04
	jr nz,@setAnimB
	ld b,$03
@setAnimB:
	ld a,b
@setAnimA:
	jp interactionSetAnimation

@anims:
	.db $00 $00 $00 $00 $01


@subid1:
	call checkInteractionState
	jr nz,@subid1State1

@subid1State0:
	call interactionInitGraphics
	call objectSetVisible82
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),$d4
@subid1State1:
	ld h,d
	ld l,Interaction.zh
	inc (hl)
	jp z,interactionDelete
	ret
