; Code in this file is included by the "code/loadTreasureData.s" file, meaning it's in the
; "treasureData" namespace.


;;
; RANDO: Modify the variables of an interaction of type INTERACID_TREASURE. This is called both when
; it is spawned, and when it is time to give the treasure to Link.
;
; @param	d	Interaction to modify
modifyTreasureInteraction:
	ld e,Interaction.var30
	ld a,(de) ; Treasure ID
	ld b,a
	ld e,Interaction.var03
	ld a,(de) ; Treasure SubID
	ld c,a
	call getUpgradedTreasure
	jr nc,@loadedData

	ld a,b
	ld e,Interaction.subid
	ld (de),a
	ld a,c
	inc e
	ld (de),a ; var03
	; Call this again to make sure everything gets updated
	call interactionLoadTreasureData

@loadedData:
	; Small keys only: Change behaviour when falling from the ceiling
	ld a,b
	cp TREASURE_SMALL_KEY
	jr nz,++
	ld e,Interaction.var31
	ld a,(de)
	cp TREASURE_SPAWN_MODE_FROM_SCREEN_TOP
	jr nz,++

	; Use GRAB_MODE_NO_CHANGE instead of GRAB_MODE_1_HAND
	ld a,TREASURE_GRAB_MODE_NO_CHANGE
	ld e,Interaction.var32
	ld (de),a

	; Remove text
	ld a,$ff
	ld e,Interaction.var35
	ld (de),a
++
	ret


;;
; Looks up data for a treasure object, no rando-adjustments made.
;
; @param	bc	Treasure object ID to look up
; @param[out]	hl	Address of data
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
