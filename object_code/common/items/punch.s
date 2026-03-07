;;
; ITEM_PUNCH
; ITEM_NONE also points here, but this doesn't get called from there normally
itemCode00:
itemCode02:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1

@state0:
	call itemLoadAttributesAndGraphics
	ld c,SND_STRIKE
	call itemIncState
	ld l,Item.counter1
	ld (hl),$04
	ld l,Item.subid
	bit 0,(hl)
	jr z,++

	; Expert's ring (bit 0 of Item.subid set)

	ld l,Item.collisionRadiusY
	ld a,$06
	ldi (hl),a
	ldi (hl),a

	; Increase Item.damage
	ld a,(hl)
	add $fd
	ld (hl),a

	; Use ITEMCOLLISION_EXPERT_PUNCH for expert's ring
	ld l,Item.collisionType
	inc (hl)

	; Check for clinks against bombable walls?
	call tryBreakTileWithExpertsRing

	ld c,SND_EXPLOSION
++
	ld a,c
	jp playSound

@state1:
	call itemDecCounter1
	jp z,itemDelete
	ret
