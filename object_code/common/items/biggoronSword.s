;;
; ITEM_BIGGORON_SWORD
itemCode0c:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw itemCode1d@ret

@state0:
	ld a,UNCMP_GFXH_1b
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	ld a,SND_BIGSWORD
	call playSound
	jp objectSetVisible82
