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

	push bc

	ld d,b
	ld e,c
	ld (hl),INTERACID_TREASURE ; id
	inc l
	ld a,(de)
	ld b,a
	ldi (hl),a ; subid (treasure id)
	inc de
	ld a,(de)
	ld c,a
	ld (hl),a ; var03 (treasure subid)

	; Write collect mode to var3d
	ld l,Interaction.var3d
	inc de

	; Small keys only: Change COLLECT_MODE_FALL to COLLECT_MODE_FALL_KEY
	ld a,b
	cp TREASURE_SMALL_KEY
	jr nz,++
	ld a,(de)
	cp COLLECT_MODE_FALL
	jr nz,++
	ld a,COLLECT_MODE_FALL_KEY
	jr @setCollectMode
++
	ld a,(de)

@setCollectMode:
	ld (hl),a ; Collect mode

	; Write pointer to item slot
	pop bc
	ld l,Interaction.var3e
	ld a,c
	ldi (hl),a
	ld a,b
	ld (hl),a

	ld d,0
	ld l,Interaction.id
	ret


;;
; Called from the "spawnitem" script command. Replaces treasures spawned in specific rooms.
;
; This uses a room-based lookup table, meaning it replaces all treasure objects spawned in a given
; room using the "spawnitem" command. Ideally we would do a more surgical replacement, but this is
; less work and it works fine, since in the vast majority of cases only one treasure object is ever
; used in one room.
;
; This will spawn the treasure (either the randomized treasure or the original requested one).
;
; @param	bc	Original treasure object to be spawned
; @param[out]	hl	Spawned treasure object
; @param[out]	d	nz if failed to spawn the object
lookupRoomTreasure_body:
	push bc
	ld a,(wActiveGroup)
	ld b,a
	ld a,(wActiveRoom)
	ld c,a
	ld hl,@roomTreasureTable
	ld e,$02
	call searchDoubleKey
	jr nc,@notFound

	pop bc
	ldi a,(hl)
	ld c,a
	ld b,(hl)
	call spawnRandomizedTreasure_body
	ret

@notFound:
	pop bc
	call getFreeInteractionSlot
	ld d,1
	ret nz

	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	ld d,0
	ret


@roomTreasureTable:
	dbbw $04, $1b, seasonsSlot_d1_stalfosDrop
	.db $ff



.include "code/rando/itemEvents.s"
.include "data/rando/itemSlots.s"

.ends
