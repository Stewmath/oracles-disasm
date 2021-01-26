; Code in this file is included by the "code/loadTreasureData.s" file, meaning it's in the
; "treasureData" namespace.


;;
; Modify the variables of an interaction of type INTERACID_TREASURE. This is called both when it is
; spawned, and when it is time to give the treasure to Link.
;
; Note that this is only called by treasure objects, and that the "giveTreasureCustom" function is
; an alternate method of giving treasure; so, certain things (like modifying text to be shown) need
; to be done in place that works for both.
;
; @param	d	Interaction to modify
modifyTreasureInteraction:
	push hl
	ld e,Interaction.var30
	ld a,(de) ; Treasure ID
	ld b,a
	ld e,Interaction.var03
	ld a,(de) ; Treasure SubID
	ld c,a
	call @upgradeTreasure
	call @modifyText
	call @modifyKeys
	pop hl
	ret

@upgradeTreasure:
	call getUpgradedTreasure
	ret nc

	ld a,b
	ld e,Interaction.subid
	ld (de),a
	ld a,c
	inc e
	ld (de),a ; var03

	push bc
	; Call this again to make sure everything gets updated
	call interactionLoadTreasureData
	pop bc
	ret

@modifyText:
	call getModifiedTreasureText
	ld e,Interaction.var35
	ld (de),a
	ret

; Change behaviour of falling small keys when in non-keysanity mode
@modifyKeys:
	ld a,RANDO_CONFIG_KEYSANITY
	call checkRandoConfig
	ret nz

	ld a,b
	cp TREASURE_SMALL_KEY
	ret nz

	; Only change behaviour when falling from ceiling
	ld e,Interaction.var31
	ld a,(de)
	cp TREASURE_SPAWN_MODE_FROM_SCREEN_TOP
	ret nz

	; Use GRAB_MODE_NO_CHANGE instead of GRAB_MODE_1_HAND
	ld a,TREASURE_GRAB_MODE_NO_CHANGE
	ld e,Interaction.var32
	ld (de),a

	; Remove text
	ld a,$ff
	ld e,Interaction.var35
	ld (de),a
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
; @param	bc	Treasure object ID to look up (may be modified)
; @param[out]	hl	The address of the treasure with ID b and subID c, accounting for
;			progressive upgrades.
_getTreasureDataHelper:
	push de
	call getTreasureData_noAdjust
	call getUpgradedTreasure
	pop de
	ret

;;
; Load final treasure ID, param, and text into b, c, and e (accounts for progressive upgrades).
getTreasureDataBCE:
	call getModifiedTreasureText
	call _getTreasureDataHelper
	inc hl
	ld c,(hl)
	ret

;;
; Load final treasure sprite into e (accounts for progressive upgrades).
;
; @param	bc	Treasure object ID
; @param[out]	e	Final treasure sprite
getTreasureDataSprite:
	call _getTreasureDataHelper
	inc hl
	inc hl
	inc hl
	ld e,(hl)
	ret

;;
; Same as above but not accounting for progression.
getTreasureDataSpriteWithoutProgression:
	call getTreasureData_noAdjust
	inc hl
	inc hl
	inc hl
	ld e,(hl)
	ret


;;
; Note about hide & seek minigame: This does nothing to the feather because of the
; "checkTreasureObtained" function call (you don't have the feather during the minigame).
;
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
	ret nc

	push hl
	push bc
	ld c,a ; "related variable" (item level)

	; RANDO-TODO: Check this harp stuff when ages is implemented
	ld a,b
	cp TREASURE_TUNE_OF_ECHOES
	jr nz,@harpDone
	ld a,TREASURE_TUNE_OF_CURRENTS
	ld e,a
	call checkTreasureObtained
	jr nc,@harpDone
	ld b,e

@harpDone:
	ld hl,progressiveUpgrades
	ld e,$02
	call searchDoubleKey
	jr nc,@done

	pop bc
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	pop hl
	call getTreasureData_noAdjust
	scf
	ret

@done:
	pop bc
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

	; Crossitems
	.db TREASURE_BRACELET,     $01, TREASURE_BRACELET,     $01 ; power glove
	.db TREASURE_SWITCH_HOOK,  $01, TREASURE_SWITCH_HOOK,  $01 ; long hook
	.db TREASURE_FLIPPERS,     $00, TREASURE_MERMAID_SUIT, $00 ; mermaid suit
	.db $ff

.else; ROM_AGES

	; RANDO-TODO
	.db $ff

.endif


;;
; This gets the text for a treasure, accounting for keysanity modifications and progressive
; upgrades. This may *also* write to wTextSubstitutions.
;
; @param	bc	Treasure object ID / SubID
; @param[out]	a,e	Text index
getModifiedTreasureText:
	push hl

	ld a,RANDO_CONFIG_KEYSANITY
	call checkRandoConfig
	jr z,@unmodifiedText

	; Keysanity: Change the text to show for dungeon items
	ld e,b
	ld hl,@keysanityTextTable
	call lookupKey
	jr nc,@unmodifiedText
	push af

	; Get dungeon name for text substitution
	call _getTreasureDataHelper
	inc hl
	ld a,(hl) ; Parameter (dungeon index)
	ld hl,@dungeonTextTable
	rst_addAToHl
	ld a,(hl)
	ld (wTextSubstitutions+2),a
	pop af
	pop hl
	ld e,a
	ret

@unmodifiedText:
	call _getTreasureDataHelper
	inc hl
	inc hl
	ld a,(hl)
	ld e,a
	pop hl
	ret


@keysanityTextTable:
	.db TREASURE_SMALL_KEY, <TX_00_KEYSANITY_KEY
	.db TREASURE_MAP,       <TX_00_KEYSANITY_MAP
	.db TREASURE_COMPASS,   <TX_00_KEYSANITY_COMPASS
	.db TREASURE_BOSS_KEY,  <TX_00_KEYSANITY_BOSS_KEY
	.db $00

@dungeonTextTable:
	.db <TX_00_D0_NAME
	.db <TX_00_D1_NAME
	.db <TX_00_D2_NAME
	.db <TX_00_D3_NAME
	.db <TX_00_D4_NAME
	.db <TX_00_D5_NAME
	.db <TX_00_D6_NAME
	.db <TX_00_D7_NAME
	.db <TX_00_D8_NAME
	.db $ff
	.db $ff
	.db <TX_00_D0_NAME ; Linked hero's cave
