; Code in this file is included by the "code/loadTreasureData.s" file, meaning it's in the
; "treasureData" namespace.


;;
; Looks up data for a treasure object, no rando-adjustments made.
;
; @param	bc	Treasure object ID to look up
; @param[out]	hl	Add
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
	ret

;;
; Call through getTreasureDataBCE or getTreasureDataSprite.
;
; @param	bc	Treasure object ID to look up
; @param[out]	hl	The address of the treasure with ID b and subID c, accounting for
;			progressive upgrades.
getTreasureDataHelper:
	call getTreasureData_noAdjust
	jp getUpgradedTreasure

;;
; Load final treasure ID, param, and text into b, c, and e (accounts for progressive upgrades).
getTreasureDataBCE:
	call getTreasureDataHelper
	inc hl
	ld c,(hl)
	inc hl
	ld e,(hl)
	ret

;;
; Load final treasure sprite into e (accounts for progressive upgrades).
;
; @param	bc	Treasure object ID
; @param[out]	e	Final treasure sprite
getTreasureDataSprite:
	call getTreasureDataHelper
	inc hl
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
