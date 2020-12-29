;;
; This is a replacement for giveTreasure that accounts for item progression. Call through
; giveTreasureCustom or giveTreasureCustomSilent, since this function doesn't xor the a that it
; returns. Importantly, "bc" represents an item slot pointer, NOT a treasure index.
;
; @param	bc	Item slot pointer (something from "data/rando/itemSlots.s")
giveTreasureCustom_body:
	call _lookupItemSlot
	push hl
	callab treasureData.getTreasureDataBCE
	pop hl
	ld a,b
	jp giveTreasure


giveTreasureCustomSilent:
	call giveTreasureCustom_body
	xor a
	ret


giveTreasureCustom:
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
	ret


;;
; Spawn whatever is supposed to go in a particular item slot. This should be called *any* time
; a randomized treasure object is to be spawned.
;
; @param	bc	Item slot pointer (something from "data/rando/itemSlots.s")
; @param[out]	hl	Pointer to newly spawned treasure object
; @param[out]	zflag	nz if failed to spawn the object
spawnRandomizedTreasure:
	push de
	callab rando.spawnRandomizedTreasure_body
	ld a,d
	or a
	pop de
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
; Called from the "spawnitem" script command. Replaces treasures spawned in specific rooms. (TODO)
;
; @param	bc	Original treasure object to be spawned
; @param[out]	bc	Replacement treasure (or unchanged)
randoLookupRoomTreasure:
	ret
