; Code in this file is included by the "code/loadTreasureData.s" file, meaning it's in the
; "treasureData" namespace.

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


; Return a spawning item's collection mode in a and e, based on current room.  the table format is
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


;;
; Call through getTreasureDataBCE or getTreasureDataSprite.
;
; @param	bc	Treasure object ID to look up
; @param[out]	hl	The address of the treasure with ID b and subID c, accounting for
;			progressive upgrades.
getTreasureData_body:
	ld hl,treasureObjectData
	ld a,b
	add a,a
	rst_addAToHl
	ld a,b
	add a,a
	rst_addAToHl
	bit 7,(hl)
	jr z,@next
	inc hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
@next:
	ld a,c
	add a,a
	add a,a
	rst_addAToHl
	inc hl
	ret
	;jp getUpgradedTreasure ; RANDO-TODO

;;
; Load final treasure ID, param, and text into b, c, and e.
getTreasureDataBCE:
	call getTreasureData_body
	ld c,(hl)
	inc hl
	ld e,(hl)
	ret

;;
; @param	bc	Treasure object ID
; @param[out]	e	Final treasure sprite
; Load final treasure sprite into e.
getTreasureDataSprite:
	call getTreasureData_body
	inc hl
	inc hl
	ld e,(hl)
	ret
