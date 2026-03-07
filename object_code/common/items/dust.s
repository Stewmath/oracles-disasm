;;
; ITEM_DUST
itemCode1a:
	ld e,Item.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemLoadAttributesAndGraphics
	call itemIncSubstate
	ld hl,w1Link.yh
	call objectTakePosition
	xor a
	call itemSetAnimation
	jp objectSetVisible80


; Substate 1: initial dust cloud above Link (lasts less than a second)
@substate1:
	call itemAnimate
	call @setOamTileIndexBaseFromAnimParameter

	; Mess with Item.oamFlags and Item.oamFlagsBackup
	ld a,(hl)
	inc a
	and $fb
	xor $60
	ldd (hl),a
	ld (hl),a

	; If bit 7 of animParameter was set, go to state 2
	bit 7,b
	ret z

	; [Item.oamFlags] = [Item.oamFlagsBackup] = $0b
	ld a,$0b
	ldi (hl),a
	ld (hl),a

	ld l,Item.z
	xor a
	ldi (hl),a
	ld (hl),a

	call objectSetInvisible
	jp itemIncSubstate


; Substate 2: dust by Link's feet (spends the majority of time in this state)
@substate2:
	call checkPegasusSeedCounter
	jp z,itemDelete

	call @initializeNextDustCloud

	; Each frame, alternate between two dust cloud positions, with corresponding
	; variables stored at var30-var33 and var34-var37.
	call itemDecCounter1
	bit 0,(hl)
	ld l,Item.var30
	jr z,+
	ld l,Item.var34
+
	bit 7,(hl)
	jp z,objectSetInvisible

	; Inc var30/var34 (acts as a counter)
	inc (hl)
	ld a,(hl)
	cp $82
	jr c,++

	; Reset the counter, increment var31/var35 (which controls the animation)
	ld (hl),$80
	inc l
	inc (hl)
	ld a,(hl)
	dec l
	cp $03
	jr nc,@clearDustCloudVariables
++
	; c = [var31/var35]+1
	inc l
	ldi a,(hl)
	inc a
	ld c,a

	; [Item.yh] = [var32/var36], [Item.xh] = [var33/var37]
	ldi a,(hl)
	ld e,Item.yh
	ld (de),a
	ldi a,(hl)
	ld e,Item.xh
	ld (de),a

	; Load the animation (corresponding to [var31/var35])
	ld a,c
	call itemSetAnimation
	call objectSetVisible80

;;
; @param[out]	b	[Item.animParameter]
; @param[out]	hl	Item.oamFlags
@setOamTileIndexBaseFromAnimParameter:
	ld h,d
	ld l,Item.animParameter
	ld a,(hl)
	ld b,a
	and $7f
	ld l,Item.oamTileIndexBase
	ldd (hl),a
	ret

;;
; Clears one of the "slots" for the dust cloud objects.
@clearDustCloudVariables:
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	jp objectSetInvisible

;;
; Initializes a dust cloud if one of the two slots are blank
;
@initializeNextDustCloud:
	ld h,d
	ld l,Item.subid
	bit 0,(hl)
	ret z

	ld (hl),$00

	ld l,Item.var30
	bit 7,(hl)
	jr z,+
	ld l,Item.var34
	bit 7,(hl)
	ret nz
+
	ld a,$80
	ldi (hl),a
	xor a
	ldi (hl),a
	ld a,(w1Link.yh)
	add $05
	ldi (hl),a
	ld a,(w1Link.xh)
	ld (hl),a
	ret
