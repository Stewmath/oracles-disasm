; In common folder because Ages has a stub

;;
; ITEM_SLINGSHOT
itemCode13:

.ifdef ROM_AGES
	ret
.else
	ld e,Item.state
	ld a,(de)
	or a
	ret nz
	ld a,UNCMP_GFXH_SEASONS_1d
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

.endif
