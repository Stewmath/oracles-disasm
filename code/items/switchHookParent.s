;;
; ITEMID_SWITCH_HOOK ($08)
; @addr{4b16}
_parentItemCode_switchHook:
.ifdef ROM_AGES
	ld e,Item.state		; $4b16
	ld a,(de)		; $4b18
	rst_jumpTable			; $4b19
	.dw @state0
	.dw @state1

@state0:
	ld a,(wLinkObjectIndex)		; $4b1e
	rrca			; $4b21
	jp c,_clearParentItem		; $4b22
	ld a,(wLinkInAir)		; $4b25
	or a			; $4b28
	jp nz,_clearParentItem		; $4b29
	call _isLinkInHole		; $4b2c
	jp c,_clearParentItem		; $4b2f

	call updateLinkDirectionFromAngle		; $4b32
	call clearVariousLinkVariables		; $4b35

	; Disable pressing the switch hook button again (set item priority to maximum)
	ld h,d			; $4b38
	ld l,Item.enabled		; $4b39
	ld (hl),$ff		; $4b3b

	call _parentItemLoadAnimationAndIncState		; $4b3d
	call itemCreateChild		; $4b40

	; If underwater, use a different animation
	call _isLinkUnderwater		; $4b43
	ret z			; $4b46
	ld a,LINK_ANIM_MODE_2e		; $4b47
	jp specialObjectSetAnimationWithLinkData		; $4b49

@state1:
	ld a,(w1WeaponItem.var2f)		; $4b4c
	or a			; $4b4f
	jp z,_clearParentItem		; $4b50

	ld (wDisallowMountingCompanion),a		; $4b53
	call clearVariousLinkVariables		; $4b56

	; Cancel the switch hook usage if experiencing knockback?
	ld hl,w1Link.var2a		; $4b59
	ld a,(hl)		; $4b5c
	ld l,<w1Link.knockbackCounter		; $4b5d
	or (hl)			; $4b5f
	ret z			; $4b60

	; Cancel switch hook usage?
	ld hl,w1WeaponItem.var2f		; $4b61
	set 5,(hl)		; $4b64
	ret			; $4b66
.endif
