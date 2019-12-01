;;
; ITEMID_CANE_OF_SOMARIA ($04)
; @addr{4b67}
_parentItemCode_caneOfSomaria:
.ifdef ROM_AGES
	ld e,Item.state		; $4b67
	ld a,(de)		; $4b69
	rst_jumpTable			; $4b6a
	.dw @state0
	.dw @state1

@state0:
	call updateLinkDirectionFromAngle		; $4b6f
	call _parentItemLoadAnimationAndIncState		; $4b72
	jp itemCreateChild		; $4b75

@state1:
	; Delete self when animation is finished
	ld e,Item.animParameter		; $4b78
	ld a,(de)		; $4b7a
	rlca			; $4b7b
	jp nc,_specialObjectAnimate		; $4b7c
	jp _clearParentItem		; $4b7f
.endif
