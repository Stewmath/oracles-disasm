; ITEM_ROD_OF_SEASONS
itemCode07:
	call itemTransferKnockbackToLink
	ld e,Object.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld h,d
	ld l,Item.enabled
	ld (hl),$03
	ld l,Item.counter1
	ld (hl),$10
	ld a,SND_SWORDSLASH
	call playSound
	ld a,UNCMP_GFXH_SEASONS_1c
	call loadWeaponGfx
	call itemLoadAttributesAndGraphics
	jp objectSetVisible82

@state1:
	ld h,d
	ld l,Item.counter1
	dec (hl)
	ret nz
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	ret nz
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_USED_ROD_OF_SEASONS
	ld e,Item.angle
	ld l,Interaction.angle
	ld a,(de)
	ldi (hl),a
	jp objectCopyPosition
