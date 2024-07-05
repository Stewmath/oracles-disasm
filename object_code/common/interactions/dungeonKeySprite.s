; ==================================================================================================
; INTERAC_DUNGEON_KEY_SPRITE
; ==================================================================================================
interactionCode17:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),$fc
	ld l,Interaction.counter1
	ld (hl),$08

	; Subid is the tile index of the door being opened; use that to calculate a new
	; subid which will determine the graphic to use.
	ld l,Interaction.subid
	ld a,(hl)
	ld hl,keyDoorGraphicTable
	call lookupCollisionTable
	ld e,Interaction.subid
	ld (de),a
	call interactionInitGraphics

	call objectSetVisible80
	ld a,SND_GETSEED
	jp playSound

@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),$14

	ld l,Interaction.zh
	ld (hl),$f8

	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz
	ld (hl),$0f
	jp interactionDelete


.include {"{GAME_DATA_DIR}/tile_properties/keydoorTiles.s"}
