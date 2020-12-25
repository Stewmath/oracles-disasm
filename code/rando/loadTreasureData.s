; Return treasure data address and collect mode modified as necessary, given a treasure ID in dx42.
rando_modifyTreasure:
	push bc
	push de
	push hl

	call lookupCollectMode
	push af
	call rando_upgradeTreasure
	pop af

	pop hl
	pop de
	pop bc
	ret


; Given a treasure at dx40, return hl = the start of the treasure data + 1, accounting for
; progressive upgrades. Also writes the new treasure ID to dx70, which is used to set the treasure
; obtained flag.
rando_upgradeTreasure:
	; TODO
	ret


; Neturn a spawning item's collection mode in a and e, based on current room.  the table format is
; (group, room, mode), and modes 80+ are used to index a jump table for special cases. If no match
; is found, it returns the regular, non-overriden mode. Does nothing if the item's collect mode is
; already set.
lookupCollectMode:
	ld e,Interaction.var31 ; Check if collect mode has been set already
	ld a,(de)
	ld e,a
	and a
	ret nz

	ld a,(wActiveGroup)
	ld b,a
	ld a,(wActiveRoom)
	ld c,a
	ld e,$02
	ld hl,rando_collectPropertiesTable
	call searchDoubleKey
	ld e,a
	ret nc

	; Multiworld stuff
	;inc hl
	;ldd a,(hl)
	;ld e,INTERAC_MULTI_BYTE
	;ld (de),a

	ld a,(hl)
	ld e,a
	cp a,$80
	ret c

	; TODO: Special collect modes
	ret

	;ld hl,collectSpecialJumpTable
	;and a,$7f
	;add a
	;rst_addAToHl
	;ldi a,(hl)
	;ld h,(hl)
	;ld l,a
	;jp (hl)

.include "data/rando/collectPropertiesTable.s"
