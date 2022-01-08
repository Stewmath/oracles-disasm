;;
; ITEMID_CANE_OF_SOMARIA ($04)
parentItemCode_caneOfSomaria:
.ifdef ROM_AGES
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call updateLinkDirectionFromAngle
	call parentItemLoadAnimationAndIncState
	jp itemCreateChild

@state1:
	; Delete self when animation is finished
	ld e,Item.animParameter
	ld a,(de)
	rlca
	jp nc,specialObjectAnimate_optimized
	jp clearParentItem
.endif
