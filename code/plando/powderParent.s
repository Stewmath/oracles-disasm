_parentItemCode_powder:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call _parentItemLoadAnimationAndIncState

	call updateLinkDirectionFromAngle

	ld e,2
	call itemCreateChild
	jp c,_clearParentItem

	ld a,SND_MAGIC_POWDER
	call playSound
	ret

@state1:
	; Wait for the animation to finish, then delete the item
	ld e,Item.animParameter		; $4b0c
	ld a,(de)		; $4b0e
	rlca			; $4b0f
	jp c,_clearParentItem		; $4b10
	ld a,(wGameKeysPressed)
	and $f0
	jp nz,_clearParentItem		; $4b13
	jp _specialObjectAnimate
