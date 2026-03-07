; In common folder because Ages has a stub

;;
; ITEM_FOOLS_ORE
itemCode1e:

.ifdef ROM_SEASONS
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw foolsOreRet

@state0:
	ld a,UNCMP_GFXH_SEASONS_1f
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	xor a
	call itemSetAnimation
	jp objectSetVisible82
.endif
