; In common folder because Ages has a stub

;;
; ITEM_SLINGSHOT
itemCode13:
	ld e,Item.state
	ld a,(de)
	or a
	ret nz

.ifdef ROM_AGES
	ld a,UNCMP_GFXH_AGES_SLINGSHOT
.else
	ld a,UNCMP_GFXH_SEASONS_1d
.endif
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	ld h,d
	ld a,(wSlingshotLevel)
	or $08
	ld l,Item.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	jp objectSetVisible81

foolsOreRet:
	ret
