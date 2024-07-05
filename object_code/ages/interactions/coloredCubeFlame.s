; ==================================================================================================
; INTERAC_COLORED_CUBE_FLAME
; ==================================================================================================
interactionCode1a:
	call checkInteractionState
	jr nz,@initialized
	ld a,(wRotatingCubePos)
	or a
	ret z

	call @updateColor
	call interactionInitGraphics
	call objectSetVisible82
	call interactionIncState

@initialized:
	ld a,(wRotatingCubeColor)
	rlca
	jp nc,objectSetInvisible
	call objectSetVisible
	call @updateColor
	jp interactionAnimate

@updateColor:
	ld a,(wRotatingCubeColor)
	and $7f
	ld hl,@palettes
	rst_addAToHl
	ld e,Interaction.oamFlags
	ld a,(de)
	and $f8
	or (hl)
	ld (de),a
	ret

@palettes:
	.db $02 $03 $01
