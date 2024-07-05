;;
; ITEM_SHOVEL
itemCode15:
	ld e,Item.state
	ld a,(de)
	or a
	jr nz,@state1

	; Initialization (state 0)

	call itemLoadAttributesAndGraphics
	call itemIncState
	ld l,Item.counter1
	ld (hl),$04

	ld a,BREAKABLETILESOURCE_SHOVEL
	call itemTryToBreakTile
	ld a,SND_CLINK
	jr nc,+

	; Dig succeeded
	ld a,$01
	call addToGashaMaturity
	ld a,SND_DIG
+
	jp playSound

; State 1: does nothing for 4 frames?
@state1:
	call itemDecCounter1
	ret nz
	jp itemDelete
