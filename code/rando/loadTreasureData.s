; Code in this file is included by the "code/loadTreasureData.s" file, meaning it's in the
; "treasureData" namespace.

;;
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


;;
; Given a treasure at dx40, return hl = the start of the treasure data + 1, accounting for
; progressive upgrades. Also writes the new treasure ID to dx70, which is used to set the treasure
; obtained flag.
rando_upgradeTreasure:
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	inc de
	ld a,(de)
	ld c,a
	;call getMultiworldItemDest
	call getUpgradedTreasure

	; Update Treasure ID
	ld e,Interaction.var30
	ld a,b
	ld (de),a
	ret


;;
; Return a spawning item's collection mode in a and e, based on current room. The table format is
; (group, room, mode), and modes 80+ are used to index a jump table for special cases. If no match
; is found, it returns the regular, non-overriden mode. Does nothing if the item's collect mode is
; already set.
lookupCollectMode:
	push hl
	call @helper
	pop hl
	cp $ff
	ret nz

	; Retrieve the original collect mode byte
	dec hl
	ldi a,(hl)
	ret

@helper:
	; This might be multiworld related
	;ld e,Interaction.var31 ; Check if collect mode has been set already
	;ld a,(de)
	;ld e,a
	;and a
	;ret nz

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
; Looks up data for a treasure object, no rando-adjustments made.
getTreasureData_noAdjust:
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

;;
; Call through getTreasureDataBCE or getTreasureDataSprite.
;
; @param	bc	Treasure object ID to look up
; @param[out]	hl	The address of the treasure with ID b and subID c, accounting for
;			progressive upgrades.
getTreasureData_body:
	call getTreasureData_noAdjust
	jp getUpgradedTreasure

;;
; Load final treasure ID, param, and text into b, c, and e.
getTreasureDataBCE:
	call getTreasureData_body
	ld c,(hl)
	inc hl
	ld e,(hl)
	ret

;;
; Load final treasure sprite into e.
;
; @param	bc	Treasure object ID
; @param[out]	e	Final treasure sprite
getTreasureDataSprite:
	call getTreasureData_body
	inc hl
	inc hl
	ld e,(hl)
	ret


;;
; @param	bc	Treasure object ID (may be modified)
; @param[out]	hl	The start of the upgraded treasure data (or unchanged)
; @param[out]	cflag	c if the treasure existed in the progressiveUpgrades table
getUpgradedTreasure:
	ld a,b
	cp a,TREASURE_SWORD
	jr nz,@notSpinSlash
	ld a,c
	cp a,<TREASURE_OBJECT_SWORD_03
	ld a,b
	ret nc

@notSpinSlash:
	call checkTreasureObtained
	ld c,a
	ld a,b
	ret nc
	cp TREASURE_TUNE_OF_ECHOES
	jr nz,@harpDone
	ld a,TREASURE_TUNE_OF_CURRENTS
	ld e,a
	call checkTreasureObtained
	jr nc,@harpDone
	ld b,e

@harpDone:
	push hl
	ld hl,progressiveUpgrades
	ld e,$02
	call searchDoubleKey
	jr nc,@done

	ldi a,(hl)
	ld b,a
	ld c,(hl)
	pop hl
	call getTreasureData_noAdjust
	scf
	ret

@done:
	pop hl
	xor a
	ret


; Progressive item upgrade data. Format:
; - Old ID
; - Old related var (level)
; - New ID
; - New SubID (will use this data from the treasureObjectData table)
progressiveUpgrades:

.ifdef ROM_SEASONS
	.db TREASURE_SHIELD,       $02, TREASURE_SHIELD,       $02 ; mirror shield
	.db TREASURE_SWORD,        $01, TREASURE_SWORD,        $01 ; noble sword
	.db TREASURE_SWORD,        $02, TREASURE_SWORD,        $02 ; master sword
	.db TREASURE_BOOMERANG,    $01, TREASURE_BOOMERANG,    $01 ; magic boomerang
	.db TREASURE_SLINGSHOT,    $01, TREASURE_SLINGSHOT,    $01 ; hyper slingshot
	.db TREASURE_FEATHER,      $01, TREASURE_FEATHER,      $01 ; roc's cape
	.db TREASURE_SEED_SATCHEL, $01, TREASURE_SEED_SATCHEL, $01 ; satchel upgrade 1
	.db TREASURE_SEED_SATCHEL, $02, TREASURE_SEED_SATCHEL, $01 ; satchel upgrade 2 (same deal)
	.db $ff

.else; ROM_AGES

	; RANDO-TODO
	.db $ff

.endif
