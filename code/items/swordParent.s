;;
; ITEMID_SWORD ($05)
; @addr{4b82}
_parentItemCode_sword:
	call _clearParentItemIfCantUseSword		; $4b82
	ld e,Item.state		; $4b85
	ld a,(de)		; $4b87
	rst_jumpTable			; $4b88

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6


; Initialization
@state0:
	ld hl,wcc63		; $4b97
	bit 7,(hl)		; $4b9a
	jr nz,++		; $4b9c

	ld (hl),$00		; $4b9e
	call updateLinkDirectionFromAngle		; $4ba0

	; If double-edged ring in use, [Item.var3a] = $f8
	ld a,(wLinkHealth)		; $4ba3
	cp $05			; $4ba6
	jr c,++			; $4ba8
	ld a,DBL_EDGED_RING		; $4baa
	call cpActiveRing		; $4bac
	jr nz,++		; $4baf
	ld e,Item.var3a		; $4bb1
	ld a,$f8		; $4bb3
	ld (de),a		; $4bb5
++
	; Initialize child item
	ld hl,w1WeaponItem.enabled		; $4bb6
	ld a,(hl)		; $4bb9
	or a			; $4bba
	ld b,$40		; $4bbb
	call nz,clearMemory		; $4bbd
	ld h,d			; $4bc0
	ld l,Item.enabled		; $4bc1
	set 7,(hl)		; $4bc3
	call _parentItemLoadAnimationAndIncState		; $4bc5
	jp itemCreateChild		; $4bc8


; Sword being swung
@state1:
	ld a,(wcc63)		; $4bcb
	rlca			; $4bce
	jp c,@label_4c8b		; $4bcf

	call _specialObjectAnimate		; $4bd2
	ld h,d			; $4bd5
	ld e,Item.animParameter		; $4bd6
	ld a,(de)		; $4bd8
	or a			; $4bd9
	jr z,++			; $4bda

	ld l,Item.var3a		; $4bdc
	bit 7,(hl)		; $4bde
	jr nz,++			; $4be0
	ld l,Item.enabled		; $4be2
	res 7,(hl)		; $4be4
++
	; Check for bit 7 of animParameter (marks end of swing animation)
	ld l,e			; $4be6
	bit 7,a			; $4be7
	jr nz,@state6		; $4be9

	bit 5,a			; $4beb
	ret z			; $4bed
	res 5,(hl)		; $4bee
	ld a,(wSwordLevel)		; $4bf0
	cp $02			; $4bf3
	jp nc,@checkCreateSwordBeam		; $4bf5
	ret			; $4bf8


; State 6: re-initialize after sword poke (also executed after sword swing)
@state6:
	ld a,(w1WeaponItem.var2a)		; $4bf9
	or a			; $4bfc
	jp nz,@enemyContact		; $4bfd

	ld a,(wLinkObjectIndex)		; $4c00
	rrca			; $4c03
	jp c,@deleteSelf		; $4c04
	call _parentItemCheckButtonPressed		; $4c07
	jp z,@deleteSelf		; $4c0a

	ld a,$01		; $4c0d
	ld (wcc63),a		; $4c0f

	; Set child item to state 2
	inc a			; $4c12
	ld (w1WeaponItem.state),a		; $4c13

	ld a, $80 | ITEMCOLLISION_SWORD_HELD		; $4c16
	ld (w1WeaponItem.collisionType),a		; $4c18

	ld l,Item.state		; $4c1b
	ld (hl),$02		; $4c1d

	; [Item.state2] = 0
	inc l			; $4c1f
	xor a			; $4c20
	ld (hl),a		; $4c21

	ld l,Item.var3a		; $4c22
	ld (hl),a		; $4c24
	ld l,Item.var3f		; $4c25
	ld (hl),a		; $4c27

	ld l,Item.counter1		; $4c28
	ld (hl),$28		; $4c2a

	jp _itemEnableLinkMovement		; $4c2c

; @param	a	Value of Item.var2a
@enemyContact:
	bit 0,a			; $4c2f
	jp z,@deleteSelf		; $4c31

	; Check for double-edged ring
	ld e,Item.var3a		; $4c34
	ld a,(de)		; $4c36
	or a			; $4c37
	jp z,@deleteSelf		; $4c38

	ld hl,w1Link.damageToApply		; $4c3b
	add (hl)		; $4c3e
	ld (hl),a		; $4c3f
	xor a			; $4c40
	ld (de),a		; $4c41
	jp @deleteSelf		; $4c42


; Sword being held, charging swordspin
@state2:
	ld a,(wLinkObjectIndex)		; $4c45
	rrca			; $4c48
	jp c,@deleteSelf		; $4c49
	call _parentItemCheckButtonPressed		; $4c4c
	jp z,@deleteSelf		; $4c4f
	call @checkAndRetForSwordPoke		; $4c52
	ld a,CHARGE_RING		; $4c55
	call cpActiveRing		; $4c57
	ld c,$01		; $4c5a
	jr nz,+			; $4c5c
	ld c,$04		; $4c5e
+
	ld l,Item.counter1		; $4c60
	ld a,(hl)		; $4c62
	sub c			; $4c63
	ld (hl),a		; $4c64
	ret nc			; $4c65

	ld a,ENERGY_RING		; $4c66
	call cpActiveRing		; $4c68
	jr nz,+			; $4c6b

	call @createSwordBeam		; $4c6d
	jp @triggerSwordPoke		; $4c70
+
	ld l,Item.state		; $4c73
	inc (hl)		; $4c75
	ld l,Item.enabled		; $4c76
	set 7,(hl)		; $4c78
	ld a,$03		; $4c7a
	ld (w1WeaponItem.state),a		; $4c7c
	ld a,SND_CHARGE_SWORD		; $4c7f
	jp playSound		; $4c81


; Sword being held, fully charged
@state3:
	call @checkAndRetForSwordPoke		; $4c84
	call _parentItemCheckButtonPressed		; $4c87
	ret nz			; $4c8a

@label_4c8b:
	ld h,d			; $4c8b
	ld a,$02		; $4c8c
	ld (wcc63),a		; $4c8e
	ld l,Item.state		; $4c91
	ld (hl),$04		; $4c93
	ld a,SPIN_RING		; $4c95
	call cpActiveRing		; $4c97
	ld a,$05		; $4c9a
	jr nz,+			; $4c9c
	ld a,$09		; $4c9e
+
	ld l,Item.counter1		; $4ca0
	ld (hl),a		; $4ca2
	ld l,Item.var3f		; $4ca3
	ld (hl),$0f		; $4ca5

.ifdef ROM_AGES
	call _isLinkUnderwater		; $4ca7
	ld c,LINK_ANIM_MODE_28		; $4caa
	jr z,+			; $4cac
	ld c,LINK_ANIM_MODE_30		; $4cae
+
	ld a,(w1Link.direction)		; $4cb0
	add c			; $4cb3

.else; ROM_SEASONS
	ld a,(w1Link.direction)
	add LINK_ANIM_MODE_28
.endif

	call specialObjectSetAnimationWithLinkData		; $4cb4
	ld h,d			; $4cb7
	ld l,Item.animParameter		; $4cb8
	res 6,(hl)		; $4cba

	ld hl,w1WeaponItem.state		; $4cbc
	ld (hl),$04		; $4cbf
	ld l,Item.var3a		; $4cc1
	sla (hl)		; $4cc3

	call _itemDisableLinkMovement		; $4cc5

	ld a,SND_SWORDSPIN		; $4cc8
	jp playSound		; $4cca


; Performing a swordspin
@state4:
	call _specialObjectAnimate		; $4ccd
	ld h,d			; $4cd0
	ld l,Item.animParameter		; $4cd1
	bit 7,(hl)		; $4cd3
	ret z			; $4cd5

	res 7,(hl)		; $4cd6
	ld l,Item.counter1		; $4cd8
	dec (hl)		; $4cda
	ret nz			; $4cdb

	ld a,$05		; $4cdc
	ld (w1WeaponItem.state),a		; $4cde
	jp @deleteSelf		; $4ce1

; Swordspin ending
@state5:
	call _specialObjectAnimate		; $4ce4
	ld h,d			; $4ce7
	ld l,Item.animParameter		; $4ce8
	bit 7,(hl)		; $4cea
	ret z			; $4cec

	ld l,Item.subid		; $4ced
	ld a,(hl)		; $4cef
	or a			; $4cf0
	jr z,@deleteSelf			; $4cf1

	; Go to state 6
	ld a,$06		; $4cf3
	ld (w1WeaponItem.state),a		; $4cf5
	ld l,Item.state		; $4cf8
	inc (hl)		; $4cfa

	xor a			; $4cfb
	ld (w1WeaponItem.var2a),a		; $4cfc
	ret			; $4cff


@deleteSelf:
	xor a			; $4d00
	ld (wcc63),a		; $4d01
	jp _clearParentItem		; $4d04


; Checks if Link's doing sword poke; sets animations, etc, and returns from the caller if
; so?
@checkAndRetForSwordPoke:
	xor a			; $4d07
	ld e,Item.subid		; $4d08
	ld (de),a		; $4d0a

	ld a,(w1WeaponItem.var2a)		; $4d0b
	cp $04			; $4d0e
	jr z,+			; $4d10
	or a			; $4d12
	jr nz,++		; $4d13
	call checkLinkPushingAgainstWall		; $4d15
	ret nc			; $4d18
+
	ld e,Item.subid		; $4d19
	ld a,$01		; $4d1b
	ld (de),a		; $4d1d
++
	; Return from caller
	pop hl			; $4d1e

	xor a			; $4d1f
	ld (w1WeaponItem.collisionType),a		; $4d20

@triggerSwordPoke:
	ld h,d			; $4d23
	ld l,Item.var3f		; $4d24
	ld (hl),$08		; $4d26

	ld l,Item.state		; $4d28
	ld (hl),$05		; $4d2a

	call _itemDisableLinkMovement		; $4d2c

.ifdef ROM_AGES
	call _isLinkUnderwater		; $4d2f
	ld a,LINK_ANIM_MODE_1f		; $4d32
	jr z,+			; $4d34
	ld a,LINK_ANIM_MODE_2c		; $4d36
+
.else; ROM_SEASONS
	ld a,LINK_ANIM_MODE_1f
.endif
	jp specialObjectSetAnimationWithLinkData		; $4d38

@checkCreateSwordBeam:
	ld c,$08		; $4d3b
	ld a,LIGHT_RING_L1		; $4d3d
	call cpActiveRing		; $4d3f
	jr z,++			; $4d42
	ld c,$0c		; $4d44
	ld a,LIGHT_RING_L2		; $4d46
	call cpActiveRing		; $4d48
	jr z,++			; $4d4b
	ld c,$00		; $4d4d
++
	ld hl,wLinkHealth		; $4d4f
	ldi a,(hl)		; $4d52
	add c			; $4d53
	cp (hl)			; $4d54
	ret c			; $4d55

@createSwordBeam:
	ldbc ITEMID_SWORD_BEAM,$00		; $4d56
	ld e,$01		; $4d59
	call _getFreeItemSlotWithObjectCap		; $4d5b
	ret c			; $4d5e

	inc (hl)		; $4d5f
	inc l			; $4d60
	ld a,b			; $4d61
	ldi (hl),a		; $4d62
	ld a,c			; $4d63
	ldi (hl),a		; $4d64

	; Copy link direction, angle, & position variables
	push de			; $4d65
	ld de,w1Link.direction		; $4d66
	ld l,Item.direction		; $4d69
	ld b,$08		; $4d6b
	call copyMemoryReverse		; $4d6d

	pop de			; $4d70
	scf			; $4d71
	ret			; $4d72
