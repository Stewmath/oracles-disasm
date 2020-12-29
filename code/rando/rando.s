m_section_superfree Rando NAMESPACE rando

;;
; Takes a constant from "constants/randoItemSlots.s" and returns the treasure object to use for that
; item slot. This is used for non-chest items. (It does not account for progressive upgrades.)
;
; This should only be used as a helper function for internal rando stuff. Patched code should
; instead spawn items with "spawnRandomizedTreasure" or give them directly with
; "giveTreasureCustom".
;
; @param	bc	Item slot index (from data/rando/itemSlots.s)
; @param[out]	bc	Treasure object
lookupItemSlot:
	ld h,b
	ld l,c
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	ret


;;
; Spawn whatever is supposed to go in a particular item slot. This should be called *any* time
; a randomized treasure object is to be spawned.
;
; @param	bc	Item slot pointer (something from "data/rando/itemSlots.s")
; @param[out]	hl	Pointer to newly spawned treasure object
; @param[out]	d	Nonzero if failed to spawn the object
spawnRandomizedTreasure_body:
	call getFreeInteractionSlot
	ld d,1
	ret nz

	ld d,b
	ld e,c
	ld (hl),INTERACID_TREASURE ; id
	inc l
	ld a,(de)
	ldi (hl),a ; subid (treasure id)
	inc de
	ld a,(de)
	ld (hl),a ; var03 (treasure subid)
	ld l,Interaction.var31
	inc de
	ld a,(de)
	ld (hl),a ; Collect mode

	ld d,0
	ret


.include "data/rando/itemSlots.s"

.ends
