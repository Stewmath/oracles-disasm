;;
; This is a replacement for giveTreasure that handles randomized item slots. Call through
; giveTreasureCustom or giveTreasureCustomSilent, since this function doesn't xor the a that it
; returns. Importantly, "bc" represents an item slot pointer, NOT a treasure index.
;
; @param	bc	Item slot pointer (something from "data/rando/itemSlots.s")
; @param[out]	a	Result from giveTreasure (sound to play)
; @param[out]	e	Text to show
; @param[out]	zflag	Result from giveTreasure (status of 'a' register)
giveTreasureCustom_body:
	push bc
	call _lookupItemSlot
	callab treasureData.getTreasureDataBCE
	ld a,b
	push de
	call giveTreasure
	pop de

	; Run callback function if it exists
	pop bc
	push af
	call runRandoTreasureCallback
	pop af
	ret


giveTreasureCustomSilent:
	push hl
	call giveTreasureCustom_body
	xor a
	pop hl
	ret


giveTreasureCustom:
	push hl
	call giveTreasureCustom_body

	jr z,@noSound
	push hl
	call playSound
	pop hl

@noSound:
	ld a,e
	cp a,$ff
	ret z
	ld b,>TX_0000
	ld c,e
	call showText
	xor a
	pop hl
	ret


;;
; Run the callback function for an item slot.
;
; @param	bc	Pointer to item slot
runRandoTreasureCallback:
	push bc
	push de
	push hl

	ldh a,(<hRomBank)
	push af

	ld a,:rando.itemSlotCallbacksStart
	setrombank

	ld h,b
	ld l,c
	ld a,3
	rst_addAToHl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	or h
	jr z,+
	call jpHl
+
	pop af
	setrombank

	pop hl
	pop de
	pop bc
	ret


;;
; Spawn whatever is supposed to go in a particular item slot. This should be called *any* time
; a randomized treasure object is to be spawned.
;
; @param	bc	Item slot pointer (something from "data/rando/itemSlots.s")
; @param[out]	h	Pointer to newly spawned treasure object
; @param[out]	zflag	nz if failed to spawn the object
spawnRandomizedTreasure:
	push de
	callab rando.spawnRandomizedTreasure_body
	ld a,d
	or a
	pop de
	ret


;;
; Similar to above, but writes to a spawned treasure. The treasure object should have its ID set,
; but nothing else.
;
; @param	bc	Item slot pointer (something from "data/rando/itemSlots.s")
; @param	h	Treasure object
initializeRandomizedTreasure:
	push bc
	push de
	ld d,h
	callab rando.initializeRandomizedTreasure_body
	pop de
	pop bc
	ret


;;
; See "lookupItemSlot_body".
;
; @param	bc	Item slot index (from data/rando/itemSlots.s)
; @param[out]	bc	Treasure object
_lookupItemSlot:
	push de
	push hl
	callab rando.lookupItemSlot
	pop hl
	pop de
	ret

;;
; See "lookupRoomTreasure_body".
;
; @param	bc	Original treasure object to be spawned
; @param[out]	hl	Spawned treasure (if applicable)
; @param[out]	zflag	nz if failed to spawn the object
randoLookupRoomTreasure:
	push bc
	push de
	callab rando.lookupRoomTreasure_body
	ld a,d
	or a
	pop de
	pop bc
	ret
