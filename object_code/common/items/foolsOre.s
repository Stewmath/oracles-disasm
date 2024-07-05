; In common folder because Ages has a stub

;;
; ITEM_FOOLS_ORE
itemCode1e:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw foolsOreRet

@state0:
.ifdef ROM_AGES
	ld a,UNCMP_GFXH_AGES_FOOLS_ORE
.else
	ld a,UNCMP_GFXH_SEASONS_1f
.endif
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	xor a
	call itemSetAnimation
	jp objectSetVisible82
