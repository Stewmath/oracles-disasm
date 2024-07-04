;;
; ITEM_SWITCH_HOOK ($08)
parentItemCode_switchHook:
.ifdef ROM_AGES
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,(wLinkObjectIndex)
	rrca
	jp c,clearParentItem
	ld a,(wLinkInAir)
	or a
	jp nz,clearParentItem
	call isLinkInHole
	jp c,clearParentItem

	call updateLinkDirectionFromAngle
	call clearVariousLinkVariables

	; Disable pressing the switch hook button again (set item priority to maximum)
	ld h,d
	ld l,Item.enabled
	ld (hl),$ff

	call parentItemLoadAnimationAndIncState
	call itemCreateChild

	; If underwater, use a different animation
	call isLinkUnderwater
	ret z
	ld a,LINK_ANIM_MODE_2e
	jp specialObjectSetAnimationWithLinkData

@state1:
	ld a,(w1WeaponItem.var2f)
	or a
	jp z,clearParentItem

	ld (wDisallowMountingCompanion),a
	call clearVariousLinkVariables

	; Cancel the switch hook usage if experiencing knockback?
	ld hl,w1Link.var2a
	ld a,(hl)
	ld l,<w1Link.knockbackCounter
	or (hl)
	ret z

	; Cancel switch hook usage?
	ld hl,w1WeaponItem.var2f
	set 5,(hl)
	ret
.endif
