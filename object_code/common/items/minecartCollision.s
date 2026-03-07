;;
; ITEM_MINECART_COLLISION
itemCode1d:
	ld e,Item.state
	ld a,(de)
	or a
	ret nz

	call itemLoadAttributesAndGraphics
	call itemIncState
	ld l,Item.enabled
	set 1,(hl)

@ret:
	ret

;;
; ITEM_MINECART_COLLISION
itemCode1dPost:
	ld hl,w1Companion.id
	ld a,(hl)
	cp SPECIALOBJECT_MINECART
	jp z,objectTakePosition
	jp itemDelete
