;;
; ITEMID_BOOMERANG ($06)
; @addr{4fdd}
_parentItemCode_boomerang:
	ld e,Item.state		; $4fdd
	ld a,(de)		; $4fdf
	rst_jumpTable			; $4fe0

	.dw @state0
	.dw @state1

@state0:
	call _isLinkUnderwater		; $4fe5
	jp nz,_clearParentItem		; $4fe8

	ld a,(w1ParentItem2.id)		; $4feb
	cp ITEMID_SWITCH_HOOK			; $4fee
	jp z,_clearParentItem		; $4ff0

	ld a,(wLinkSwimmingState)		; $4ff3
	or a			; $4ff6
	jp nz,_clearParentItem		; $4ff7

	call _parentItemLoadAnimationAndIncState		; $4ffa
	ld a,$01		; $4ffd
	ld e,Item.state		; $4fff
	ld (de),a		; $5001

	; Try to create the physical boomerang object, delete self on failure
	dec a			; $5002
	ld c,a			; $5003
	ld e,Item.id		; $5004
	ld a,(de)		; $5006
	ld b,a			; $5007
	ld e,$01		; $5008
	call itemCreateChildWithID		; $500a
	jp c,_clearParentItem		; $500d

	; Calculate angle for newly created boomerang
	ld a,(wLinkAngle)		; $5010
	bit 7,a			; $5013
	jr z,+			; $5015
	ld a,(w1Link.direction)		; $5017
	swap a			; $501a
	rrca			; $501c
+
	ld l,Item.angle		; $501d
	ld (hl),a		; $501f
	ld l,Item.var34		; $5020
	ld (hl),a		; $5022
	ret			; $5023

@state1:
	ld e,Item.animParameter		; $5024
	ld a,(de)		; $5026
	rlca			; $5027
	jp nc,_specialObjectAnimate		; $5028
	jp _clearParentItem		; $502b
