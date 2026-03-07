; ITEM_MAGNET_GLOVES
itemCode08:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,UNCMP_GFXH_SEASONS_1e
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	call objectSetVisible81

@state1:
	ld a,(wMagnetGloveState)
	bit 1,a
	ld a,$0c
	jr z,+
	inc a
+
	ld h,d
	ld l,Item.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	ret
