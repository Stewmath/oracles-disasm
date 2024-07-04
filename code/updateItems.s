;;
updateItems:
	ld b,$00

	ld a,(wScrollMode)
	cp $08
	jr z,@dontUpdateItems

	ld a,(wDisabledObjects)
	and $90
	jr nz,@dontUpdateItems

	ld a,(wPaletteThread_mode)
	or a
	jr nz,@dontUpdateItems

	ld a,(wTextIsActive)
	or a
	jr z,++

	; Set b to $01, indicating items shouldn't be updated after initialization
@dontUpdateItems:
	inc b
++
	ld hl,wcc8b
	ld a,(hl)
	and $fe
	or b
	ld (hl),a

	xor a
	ld (wScentSeedActive),a

	ld a,Item.start
	ldh (<hActiveObjectType),a
	ld d,FIRST_ITEM_INDEX
	ld a,d

@itemLoop:
	ldh (<hActiveObject),a
	ld e,Item.start
	ld a,(de)
	or a
	jr z,@nextItem

	; Always update items when uninitialized
	ld e,Item.state
	ld a,(de)
	or a
	jr z,+

	; If already initialized, don't update items if this variable is set
	ld a,(wcc8b)
	or a
+
	call z,@updateItem
@nextItem:
	inc d
	ld a,d
	cp LAST_ITEM_INDEX+1
	jr c,@itemLoop
	ret

;;
; @param d Item index
@updateItem:
	ld e,Item.id
	ld a,(de)
	rst_jumpTable
.ifdef ROM_AGES
	.dw itemCode00 ; 0x00
	.dw itemDelete ; 0x01
	.dw itemCode02 ; 0x02
	.dw itemCode03 ; 0x03
	.dw itemCode04 ; 0x04
	.dw itemCode05 ; 0x05
	.dw itemCode06 ; 0x06
	.dw itemDelete ; 0x07
	.dw itemDelete ; 0x08
	.dw itemCode09 ; 0x09
	.dw itemCode0a ; 0x0a
	.dw itemCode0b ; 0x0b
	.dw itemCode0c ; 0x0c
	.dw itemCode0d ; 0x0d
	.dw itemDelete ; 0x0e
	.dw itemCode0f ; 0x0f
	.dw itemDelete ; 0x10
	.dw itemDelete ; 0x11
	.dw itemDelete ; 0x12
	.dw itemCode13 ; 0x13
	.dw itemDelete ; 0x14
	.dw itemCode15 ; 0x15
	.dw itemCode16 ; 0x16
	.dw itemDelete ; 0x17
	.dw itemCode18 ; 0x18
	.dw itemDelete ; 0x19
	.dw itemCode1a ; 0x1a
	.dw itemDelete ; 0x1b
	.dw itemDelete ; 0x1c
	.dw itemCode1d ; 0x1d
	.dw itemCode1e ; 0x1e
	.dw itemDelete ; 0x1f
	.dw itemCode20 ; 0x20
	.dw itemCode21 ; 0x21
	.dw itemCode22 ; 0x22
	.dw itemCode23 ; 0x23
	.dw itemCode24 ; 0x24
	.dw itemDelete ; 0x25
	.dw itemDelete ; 0x26
	.dw itemCode27 ; 0x27
	.dw itemCode28 ; 0x28
	.dw itemCode29 ; 0x29
	.dw itemCode2a ; 0x2a
	.dw itemCode2b ; 0x2b
.else
	.dw itemCode00 ; 0x00
	.dw itemDelete ; 0x01
	.dw itemCode02 ; 0x02
	.dw itemCode03 ; 0x03
	.dw itemDelete ; 0x04
	.dw itemCode05 ; 0x05
	.dw itemCode06 ; 0x06
	.dw itemCode07 ; 0x07
	.dw itemCode08 ; 0x08
	.dw itemDelete ; 0x09
	.dw itemDelete ; 0x0a
	.dw itemDelete ; 0x0b
	.dw itemCode0c ; 0x0c
	.dw itemCode0d ; 0x0d
	.dw itemDelete ; 0x0e
	.dw itemDelete ; 0x0f
	.dw itemDelete ; 0x10
	.dw itemDelete ; 0x11
	.dw itemDelete ; 0x12
	.dw itemCode13 ; 0x13
	.dw itemDelete ; 0x14
	.dw itemCode15 ; 0x15
	.dw itemCode16 ; 0x16
	.dw itemDelete ; 0x17
	.dw itemDelete ; 0x18
	.dw itemDelete ; 0x19
	.dw itemCode1a ; 0x1a
	.dw itemDelete ; 0x1b
	.dw itemDelete ; 0x1c
	.dw itemCode1d ; 0x1d
	.dw itemCode1e ; 0x1e
	.dw itemDelete ; 0x1f
	.dw itemCode20 ; 0x20
	.dw itemCode21 ; 0x21
	.dw itemCode22 ; 0x22
	.dw itemCode23 ; 0x23
	.dw itemCode24 ; 0x24
	.dw itemDelete ; 0x25
	.dw itemDelete ; 0x26
	.dw itemCode27 ; 0x27
	.dw itemCode28 ; 0x28
	.dw itemCode29 ; 0x29
	.dw itemCode2a ; 0x2a
	.dw itemCode2b ; 0x2b
.endif

;;
; The main difference between this and the above "updateItems" is that this is called
; after all of the other objects have been updated. This also doesn't have any conditions
; before it starts calling the update code.
;
updateItemsPost:
	lda Item.start
	ldh (<hActiveObjectType),a
	ld d,FIRST_ITEM_INDEX
	ld a,d
@itemLoop:
	ldh (<hActiveObject),a
	ld e,Item.enabled
	ld a,(de)
	or a
	call nz,updateItemPost
	inc d
	ld a,d
	cp $e0
	jr c,@itemLoop

itemCodeNilPost:
	ret

;;
updateItemPost:
	ld e,$01
	ld a,(de)
	rst_jumpTable

	.dw itemCode00Post	; 0x00
	.dw itemCodeNilPost	; 0x01
	.dw itemCode02Post	; 0x02
	.dw itemCodeNilPost	; 0x03
	.dw itemCode04Post	; 0x04
	.dw itemCode05Post	; 0x05
	.dw itemCodeNilPost	; 0x06
	.dw itemCode07Post	; 0x07
	.dw itemCode08Post	; 0x08
	.dw itemCodeNilPost	; 0x09
.ifdef ROM_AGES
	.dw itemCode0aPost	; 0x0a
	.dw itemCode0bPost	; 0x0b
	.dw itemCode0cPost	; 0x0c
	.dw itemCodeNilPost	; 0x0d
	.dw itemCodeNilPost	; 0x0e
	.dw itemCode0fPost	; 0x0f
.else
	.dw itemDelete		; 0x0a
	.dw itemDelete		; 0x0b
	.dw itemCode0cPost	; 0x0c
	.dw itemCodeNilPost	; 0x0d
	.dw itemCodeNilPost	; 0x0e
	.dw itemDelete		; 0x0f
.endif
	.dw itemCodeNilPost	; 0x10
	.dw itemCodeNilPost	; 0x11
	.dw itemCodeNilPost	; 0x12
	.dw itemCode13Post	; 0x13
	.dw itemCodeNilPost	; 0x14
	.dw itemCodeNilPost	; 0x15
	.dw itemCodeNilPost	; 0x16
	.dw itemCodeNilPost	; 0x17
	.dw itemCodeNilPost	; 0x18
	.dw itemCodeNilPost	; 0x19
	.dw itemCodeNilPost	; 0x1a
	.dw itemCodeNilPost	; 0x1b
	.dw itemCodeNilPost	; 0x1c
	.dw itemCode1dPost	; 0x1d
	.dw itemCode1ePost	; 0x1e
	.dw itemCodeNilPost	; 0x1f
	.dw itemCodeNilPost	; 0x20
	.dw itemCodeNilPost	; 0x21
	.dw itemCodeNilPost	; 0x22
	.dw itemCodeNilPost	; 0x23
	.dw itemCodeNilPost	; 0x24
	.dw itemCodeNilPost	; 0x25
	.dw itemCodeNilPost	; 0x26
	.dw itemCodeNilPost	; 0x27
	.dw itemCodeNilPost	; 0x28
	.dw itemCodeNilPost	; 0x29
	.dw itemCodeNilPost	; 0x2a
	.dw itemCodeNilPost	; 0x2b
