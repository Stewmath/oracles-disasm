;;
; This is an object which serves as a collision for enemies when Dimitri does his eating
; attack. Also checks for eatable tiles.
;
; ITEM_DIMITRI_MOUTH
itemCode2b:
	ld e,Item.state
	ld a,(de)
	or a
	jr nz,+

	; Initialization
	call itemLoadAttributesAndGraphics
	call itemIncState
	ld l,Item.counter1
	ld (hl),$0c
+
	call @calcPosition

	; Check for enemy collision?
	ld h,d
	ld l,Item.var2a
	bit 1,(hl)
	jr nz,@swallow

	ld a,BREAKABLETILESOURCE_DIMITRI_EAT
	call itemTryToBreakTile
	jr c,@swallow

	; Delete self after 12 frames
	call itemDecCounter1
	jr z,@delete
	ret

@swallow:
	; Set var35 to $01 to tell Dimitri to do his swallow animation?
	ld a,$01
	ld (w1Companion.var35),a

@delete:
	jp itemDelete

;;
; Sets the position for this object around Dimitri's mouth.
;
@calcPosition:
	ld a,(w1Companion.direction)
	ld hl,@offsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	ld hl,w1Companion.yh
	jp objectTakePositionWithOffset

@offsets:
	.db $f6 $00 ; DIR_UP
	.db $fe $0a ; DIR_RIGHT
	.db $04 $00 ; DIR_DOWN
	.db $fe $f6 ; DIR_LEFT
