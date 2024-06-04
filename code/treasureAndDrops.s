;;
; Called from checkTreasureObtained in bank 0.
;
; @param	l	Item to check for (see constants/treasure.s)
; @param[out]	h	Bit 0 set if link has the item
; @param[out]	l	Value of the treasure's "related variable" (ie. item level)
checkTreasureObtained_body:
	ld a,l
	cp FIRST_UPGRADE_TREASURE
	jr nc,@isUpgrade

	ldh (<hFF8B),a
	ld hl,wObtainedTreasureFlags
	call checkFlag
	jr z,@dontHaveItem

	push bc
	ldh a,(<hFF8B)
	ld c,a
	ld b,$00
	ld hl,treasureCollectionBehaviourTable
	add hl,bc
	add hl,bc
	add hl,bc
	pop bc
	ldi a,(hl)
	ld l,a
	or a
	jr z,@haveItem

	ld h,>wc600Block
	ld l,(hl)

@haveItem:
	ld h,$01
	ret

@isUpgrade:
	and $07
	ld hl,wUpgradesObtained
	call checkFlag
	jr nz,@haveItem

@dontHaveItem:
	ld h,$00
	ret

;;
; @param	b	Treasure
loseTreasure_body:
	push hl
	ld a,b
	call loseTreasure_helper
	pop hl
	ret

;;
; Unset the bit in wObtainedTreasureFlags, and remove it from the inventory if it's an
; inventory item.
;
; @param	a	Treasure
loseTreasure_helper:
	ld b,a
	ld hl,wObtainedTreasureFlags
	call unsetFlag

	; Only continue if it's an inventory item (index < $20)
	ld a,b
	cp NUM_INVENTORY_ITEMS
	ret nc

	; Attempt to remove the item from the inventory
	ld hl,wInventoryB
	ld b,INVENTORY_CAPACITY+2
--
	cp (hl)
	jr z,@foundItem

	inc l
	dec b
	jr nz,--
	ret

@foundItem:
	ld (hl),$00

	; Refresh the A/B buttons on the status bar
	ld hl,wStatusBarNeedsRefresh
	set 0,(hl)

	ret

;;
; Called from giveTreasure in bank 0.
;
; @param	b	Item to give (see constants/treasure)
; @param	c	"Parameter"
; @param[out]	b	Sound to play
giveTreasure_body:
	push hl
	push de
	ld a,b
	ldh (<hFF8B),a
	push bc

	; Check if adding this item requires the removal of another item.
	ld hl,@itemsToRemoveTable
	call @findItemInTable
	jr z,+

	call loseTreasure_helper
	ld a,c
	call loseTreasure_helper
+
	pop bc
	ld a,b
	call @giveTreasure

	; Check if adding this item requires adding another item.
	push af
	ld hl,@extraItemsToAddTable
	call @findItemInTable
	call nz,@giveTreasure

	pop bc
	pop de
	pop hl
	ret

;;
; @param	hl	Table to search through
; @param	hFF8B	The treasure currently being given to Link
; @param[out]	a,c	Two values associated with the item
; @param[out]	zflag	Set if the item being added wasn't in the table
@findItemInTable:
	ldh a,(<hFF8B)
	ld c,a
--
	ldi a,(hl)
	cp c
	jr z,+
	or a
	ret z

	inc hl
	inc hl
	jr --
+
	ldi a,(hl)
	ld c,(hl)
	or a
	ret

;;
; @param	a	Item being added
; @param	c	Parameter
@giveTreasure:
	ldh (<hFF8B),a
	call checkIncreaseGashaMaturityForGettingTreasure
	call addTreasureToInventory

	ld hl,wObtainedTreasureFlags
	ldh a,(<hFF8B)
	call setFlag

	push bc
	ldh a,(<hFF8B)
	ld c,a
	ld b,$00
	ld hl,treasureCollectionBehaviourTable
	add hl,bc
	add hl,bc
	add hl,bc
	pop bc
	ld d,>wc600Block
	ldi a,(hl)
	ld e,a
	or a
	jr nz,+
	ld e,<wShortSecretIndex
+
	ld a,(hl)
	and $0f
	push hl
	call @applyParameter

	; Check whether to play a sound effect
	pop hl
	bit 7,(hl)
	inc hl
	ldi a,(hl)
	jr nz,@ret
	call playSound
	xor a

@ret:
	ret

; When Link obtains any item in the first column, he will obtain the item in the second
; column with the parameter in the third column.
; Example: When Link gets the seed satchel, he also gets 20 ember seeds.
@extraItemsToAddTable:
	.db TREASURE_SEED_SATCHEL	TREASURE_EMBER_SEEDS		$20
	.db TREASURE_HEART_CONTAINER	TREASURE_HEART_REFILL		$40
	.db TREASURE_BOMB_FLOWER	TREASURE_BOMB_FLOWER_LOWER_HALF	$00
.ifdef ROM_AGES
	.db TREASURE_TUNE_OF_ECHOES	TREASURE_HARP			$01
.endif
	.db $00

; This is similar to above, except whenever Link obtains an item in the first column, the
; game takes away the items in the next two columns. Apparently unused in ages.
@itemsToRemoveTable:
.ifdef ROM_SEASONS
	.db TREASURE_RIBBON	TREASURE_STAR_ORE	$00
	.db TREASURE_HARD_ORE	TREASURE_RED_ORE	TREASURE_BLUE_ORE
	.db TREASURE_FEATHER	TREASURE_FOOLS_ORE	$00
.endif
	.db $00

;;
; This function does something with the "parameter" passed at the start of the function.
;
; See the comments in "treasureCollectionBehaviourTable" for a detailed description of
; what each value does.
;
; @param	a	Index indicating what to do with the parameter
; @param	c	Parameter (could be # of seeds, or the item's level, etc)
; @param	de	The item's "variable" (ie. item level, or ammo)
@applyParameter:
	rst_jumpTable
	.dw @ret
	.dw @mode1
	.dw @mode2
	.dw @mode3
	.dw @mode4
	.dw @mode5
	.dw @mode6
	.dw @mode7
	.dw @mode8
	.dw @mode9
	.dw @modea
	.dw @modeb
	.dw @modec
	.dw @moded
	.dw @modee
	.dw @modef

; Set a bit in [wUpgradesObtained].
@modeb:
	ld a,c
	ld hl,wUpgradesObtained
	jp setFlag

; Set [de] to c if [de]<c. Also refreshes part of status bar. Used for items with levels.
@mode8:
	ld a,(de)
	cp c
	ret nc
	ld a,c
	ld (de),a
	ld hl,wStatusBarNeedsRefresh
	set 0,(hl)
	ret

; [de] = c
@mode5:
	ld a,c
	ld (de),a
	ret

; Set bit [wDungeonIndex] in [de].
@mode6:
	ld a,(wDungeonIndex)
	ld c,a

; Set bit c in [de].
@mode1:
	ld a,c
	ld h,d
	ld l,e
	jp setFlag

; Increment [de].
@mode2:
	ld a,(de)
	inc a
	ld (de),a
	ret

; Increment [de] as a bcd value.
@mode3:
	ld c,$01

; Add c to [de] as a bcd value.
; Mode 4 is also called by mode d, mode f.
@mode4:
	ld a,(de)
	add c
	daa
	jr nc,+
	ld a,$99
+
	ld (de),a
	ret

; Increment [de+[wDungeonIndex]].
; Used for small keys.
@mode7:
	ld a,(wDungeonIndex)
	add e
	ld l,a
	ld h,d
	inc (hl)
	ld hl,wStatusBarNeedsRefresh
	set 4,(hl)
	ret

; [de] += c.
@modea:
	ld a,(de)
	add c
	ld (de),a
	ret

; [de] += c, and [de+1] is the cap for this value.
; Also plays a sound effect if it's operating on wLinkHealth.
@modec:
	ld h,d
	ld l,e

	; Check if we're adding to wLinkHealth
	ld a,<wLinkHealth
	cp e
	ldi a,(hl)
	jr nz,+

	; If so, compare current health to max health
	cp (hl)
	jr nz,+

	; This code will probably only run when you get a heart, but your health is
	; already full.
	ld a,SND_GAINHEART
	jp playSound
+
	add c
	ld (de),a
	jr ++

; [de] += c (as bcd values), and [de+1] is the cap.
@moded:
	call @mode4
	ld h,d
	ld l,e
	inc l
++
	cp (hl)
	ret c
	ldd a,(hl)
	ld (hl),a
	ret

; Adds rupee value of 'c' to 2-byte bcd value at [de].
; Also adds to wTotalRupeesCollected if operating on wNumRupees.
@modee:
	; Get the value of the rupee in bc
	ld a,c
	call getRupeeValue

	; Check whether to add this to wTotalRupeesCollected
	ld a,e
	cp <wNumRupees
	jr nz,++

	ld a,GLOBALFLAG_10000_RUPEES_COLLECTED
	call checkGlobalFlag
	jr nz,++

	; Add the amount to the total rupee counter, set the flag when it reaches 10000.
	ld h,d
	ld l,<wTotalRupeesCollected
	call addDecimalToHlRef
	jr nc,++
	ld a,GLOBALFLAG_10000_RUPEES_COLLECTED
	call setGlobalFlag

++
	ld h,d
	ld l,e
	call addDecimalToHlRef

	; Check for overflow
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld bc,$0999
	call compareHlToBc
	dec a
	ret nz

	ld a,c
	ld (de),a
	inc e
	ld a,b
	ld (de),a
	ld a,SND_RUPEE
	jp playSound

; [de] += c (as bcd values), check wSeedSatchelLevel for the cap.
; Used for giving seeds.
@modef:
	call @mode4
	call setStatusBarNeedsRefreshBit1
	ld a,(wSeedSatchelLevel)
	ld hl,@seedSatchelCapacities-1
	rst_addAToHl
	ld a,(de)
	cp (hl)
	ret c

	ld a,(hl)
	ld (de),a
	ret

@seedSatchelCapacities:
	.db $20 $50 $99

; Add a ring to the unappraised ring list.
@mode9:
	; Setting bit 6 means the ring is unappraised
	set 6,c
	call realignUnappraisedRings

	; Check that there are less than 64 unappraised rings (checking aginst a bcd
	; number)
	cp $64
	jr c,+

	; If there are already 64 unappraised rings, remove one duplicate ring and
	; re-align the list.
	call @removeOneDuplicateRing
	call realignUnappraisedRings
+
	; Add the ring to the end of the list
	ld a,c
	ld (wUnappraisedRingsEnd-1),a
	jr realignUnappraisedRings

;;
; Decides on one ring to remove by counting all of the unappraised rings and finding the
; one with the most duplicates.
@removeOneDuplicateRing:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w4TmpRingBuffer
	ld ($ff00+R_SVBK),a

	; Construct w4TmpRingBuffer such that each index corresponds to how many
	; unappraised rings of that index Link has.

	ld hl,w4TmpRingBuffer
	ld b,NUM_RINGS
	call clearMemory

	ld de,wUnappraisedRings
	ld b,wUnappraisedRingsEnd-wUnappraisedRings
--
	ld a,(de)
	and $3f
	ld hl,w4TmpRingBuffer
	rst_addAToHl
	inc (hl)
	inc e
	dec b
	jr nz,--

	; Now loop through w4TmpRingBuffer to find the ring with the most duplicates.
	; d = max number of duplicates
	; e = the index with the most duplicates

	ld hl,w4TmpRingBuffer
	ld de,$0000
	ld b,NUM_RINGS
--
	ld a,(hl)
	cp d
	jr c,+
	ld d,a
	ld e,l
+
	inc l
	dec b
	jr nz,--

	ld a,e
	sub <w4TmpRingBuffer
	or $40
	ld e,a

	; Restore wram bank
	pop af
	ld ($ff00+R_SVBK),a

	; Search for an instance of the ring to be replaced in wUnappraisedRings

	ld hl,wUnappraisedRingsEnd-1
--
	ldd a,(hl)
	cp e
	jr nz,--

	; Remove that ring from the list
	inc hl
	ld (hl),$ff
	ret

;;
; Reorganize wUnappraisedRings so that there are no blank spaces (everything gets put into
; a contiguous block at the start). Also updates wNumUnappraisedRingsBcd.
;
; @param[out]	a	Number of unappraised rings (bcd)
; @param[out]	b	Number of unappraised rings (normal number)
realignUnappraisedRings:
	ld hl,wUnappraisedRings
--
	; Check if this slot is empty.
	ld a,(hl)
	cp $ff
	jr nz,++

	; If there is a ring later in the list, move it to this slot.
	push hl
	call @findNextFilledSlot
	pop hl
	jr nc,+++

	ld (hl),a
++
	inc l
	ld a,l
	cp <wUnappraisedRingsEnd
	jr nz,--
+++
	jr getNumUnappraisedRings

;;
; Find the next filled slot in wUnappraisedRings, and clear it.
;
; @param	hl	Where to start searching in the unappraised ring list
; @param[out]	a	The value of the first non-empty ring slot encountered after hl
; @param[out]	cflag	Set if a non-empty ring slot was encountered
@findNextFilledSlot:
	ldi a,(hl)
	cp $ff
	jr nz,++
	ld a,l
	cp <wUnappraisedRingsEnd
	jr nz,@findNextFilledSlot
	ret
++
	dec hl
	ld (hl),$ff
	scf
	ret

;;
; Sets wNumUnappraisedRingsBcd, and returns the number of unappraised rings
; (non-bcd) in b.
;
; @param[out]	a	Number of unappraised rings (bcd)
; @param[out]	b	Number of unappraised rings (normal number)
getNumUnappraisedRings:
	push de
	ld hl,wUnappraisedRings
	ld de,$4000
--
	ldi a,(hl)
	cp $ff
	jr z,+
	inc e
+
	dec d
	jr nz,--

	push bc
	ld a,e
	call hexToDec
	swap c
	or c
	ld (wNumUnappraisedRingsBcd),a
	pop bc
	ld b,e
	pop de
	ret

;;
; @param	hFF8B	Treasure index
addTreasureToInventory:
	ldh a,(<hFF8B)
	cp NUM_INVENTORY_ITEMS
	ret nc

	push bc
	call @addToInventory
	pop bc
	ret nc
	jp z,setStatusBarNeedsRefreshBit1

	; Do something weird with biggoron's sword...
	push bc
	cpl
	add <wInventoryB
	ld l,a
	ldh a,(<hFF8B)
	ld c,a
	cp TREASURE_BIGGORON_SWORD
	jr nz,+

	ld a,(hl)
	ld (hl),c
	call @addToInventory
+
	ld hl,wStatusBarNeedsRefresh
	set 0,(hl)
	pop bc
	ret

;;
; @param	a	Item to add
; @param[out]	a	Index of the inventory slot it went into
; @param[out]	zflag	z if already had the item
@addToInventory:
	ld c,a
	ld hl,wInventoryB

	; Check if link has the item already
	ld b,INVENTORY_CAPACITY+2
@nextItem:
	ldi a,(hl)
	cp c
	jr z,@assignItem
	dec b
	jr nz,@nextItem

	; Find the first available slot
	dec b
	ld l,<wInventoryB
--
	ldi a,(hl)
	or a
	jr nz,--

@assignItem:
	dec l
	ld (hl),c
	ld a,l
	sub <wInventoryStorage
	bit 7,b
	ret

;;
; Loads 7 bytes of "display data" describing a treasure's sprite, its palette, what its
; inventory text should be, and whether to display a "quantity" next to it (ie. level).
;
; See "treasureDisplayData2" to see the exact format of these 7 bytes.
;
; @param	l	Treasure index
; @param[out]	hl	Where the data is stored (wTmpcec0).
loadTreasureDisplayData:
	ld a,l
	push de
	call @getTableIndices

	; Set up hl to point to "[treasureDisplayData2+e*2]+d*7".

	push bc
	ld hl,$0000

	; hl = d*7
	ld a,d
	or a
	jr z,+
	cpl
	inc a
	ld l,a
	ld h,$ff
	ld a,d
	call multiplyABy8
	add hl,bc
+
	push hl
	ld a,e
	ld hl,treasureDisplayData2
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	pop bc
	add hl,bc

	; Now copy the 7 bytes to wTmpcec0
	ld de,wTmpcec0
	ld b,$07
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-

	ld hl,wTmpcec0
	pop bc
	pop de
	ret

;;
; @param	a	Item index
; @param[out]	d	Index to read from the sub-table (in turn determined by 'e')
;			This is usually the item's level/loaded ammo, but if the item is
;			not in treasureDisplayData1, then this equals 'a'.
; @param[out]	e	Which sub-table to use from treasureDisplayData2
@getTableIndices:
	ld d,a
	ld hl,treasureDisplayData1
-
	ldi a,(hl)
	or a
	jr z,+

	cp d
	jr z,+

	inc hl
	inc hl
	jr -

.ifdef ROM_SEASONS
+
	cp ITEMID_SLINGSHOT
	jr nz,+
	ld a,(wSlingshotLevel)
	cp $02
	jr nz,+
	inc a
	rst_addAToHl
.endif
+
	ldi a,(hl)
	ld e,(hl)
	or a
	jr z,+

	ld l,a
	ld h,>wc600Block
	ld d,(hl)
+
	ret

;;
; Decides what an enemy will drop.
;
; @param	c
; @param[out]	c	Subid for PARTID_ITEM_DROP (see constants/itemDrops.s) or $ff if no item
;			should drop
decideItemDrop_body:
	ld a,c
	or a
	set 7,a
	jr nz,+

	; If parameter == 0, assume it's an enemy; use the enemy's ID for the drop table. (Assumes
	; that 'd' points to an instance of PARTID_ENEMY_DESTROYED or PARTID_BOSS_DEATH_EXPLOSION,
	; whose subid refers to the enemy that was killed? TODO: verify.)
	ldh a,(<hActiveObjectType)
	add Object.subid
	ld e,a
	ld a,(de)
+
	ld hl,itemDropTables
	rst_addAToHl
	ld a,(hl)
	ld c,a
	cp $ff
	jr z,checkItemDropAvailable_body@done

	swap a
	rrca
	and $07
	ld hl,itemDropProbabilityTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call getRandomNumber
	and $3f
	call checkFlag
	jr z,checkItemDropAvailable_body@done

	ld a,c
	and $1f
	ld hl,itemDropSetTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call getRandomNumber
	and $1f
	rst_addAToHl
	ld a,(hl)
	ld c,a

;;
; Checks whether an item drop of a given type can spawn.
;
; @param	c	Item drop index (see constants/itemDrops.s)
; @param[out]	c	$ff if item cannot spawn (Link doesn't have it), otherwise the item itself
checkItemDropAvailable_body:
.ifdef ROM_SEASONS
	; different drop table for subrosia
	ld a,(wMinimapGroup)
	dec a
	ld a,c
	jr nz,+
	ld hl,subrosiaDropSet
	rst_addAToHl
	ld a,(hl)
	ld c,a
+
.else
	ld a,c
.endif
	ld hl,itemDropAvailabilityTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld l,a
	ld h,>wc600Block
	ld a,(hl)
	and b
	ret nz
@done:
	ld c,$ff
	ret


; Rings are divided into "tiers" (called "classes" in TourianTourist's ring guide). These
; tiers are mostly used by gasha spots, each of which can give rings from a set tier list.
;
; Each tier has 8 ring types (except for the last one, which only has 2). Some have
; repeated rings in order to fill that list.
;
ringTierTable:
	.dw @tier0
	.dw @tier1
	.dw @tier2
	.dw @tier3
	.dw @tier4

@tier0:
	.db EXPERTS_RING	CHARGE_RING	FIRST_GEN_RING	BOMBPROOF_RING
	.db ENERGY_RING		DBL_EDGED_RING	CHARGE_RING	DBL_EDGED_RING
@tier1:
	.db POWER_RING_L2	PEACE_RING	HEART_RING_L2	RED_JOY_RING
	.db GASHA_RING		PEACE_RING	WHIMSICAL_RING	PROTECTION_RING
@tier2:
	.db MAPLES_RING		TOSS_RING	RED_LUCK_RING	WHISP_RING
	.db ZORA_RING		FIST_RING	QUICKSAND_RING	ROCS_RING
@tier3:
	.db CURSED_RING		LIKE_LIKE_RING	BLUE_LUCK_RING	GREEN_HOLY_RING
	.db BLUE_HOLY_RING	RED_HOLY_RING	OCTO_RING	MOBLIN_RING
@tier4:
	.db GREEN_RING		RANG_RING_L2

itemDropSetTable:
	.dw itemDropSet0
	.dw itemDropSet1
	.dw itemDropSet2
	.dw itemDropSet3
	.dw itemDropSet4
	.dw itemDropSet5
	.dw itemDropSet6
	.dw itemDropSet7
	.dw itemDropSet8
	.dw itemDropSet9
	.dw itemDropSetA
	.dw itemDropSetB
	.dw itemDropSetC
	.dw itemDropSetD
	.dw itemDropSetE
	.dw itemDropSetF


; Each row corresponds to an item drop (see constants/itemDrops.s).
;   Byte 0: Variable in $c600 block to check
;   Byte 1: Value to AND with that variable to check availability; if nonzero, the item
;           can drop.
itemDropAvailabilityTable:
	.db <wc608, $ff				; ITEM_DROP_FAIRY
	.db <wc608, $ff				; ITEM_DROP_HEART
	.db <wc608, $ff				; ITEM_DROP_1_RUPEE
	.db <wc608, $ff				; ITEM_DROP_5_RUPEES
	.db (<wObtainedTreasureFlags+TREASURE_BOMBS/8)        , 1<<(TREASURE_BOMBS&7)
	.db (<wObtainedTreasureFlags+TREASURE_EMBER_SEEDS/8)  , 1<<(TREASURE_EMBER_SEEDS&7)
	.db (<wObtainedTreasureFlags+TREASURE_SCENT_SEEDS/8)  , 1<<(TREASURE_SCENT_SEEDS&7)
	.db (<wObtainedTreasureFlags+TREASURE_PEGASUS_SEEDS/8), 1<<(TREASURE_PEGASUS_SEEDS&7)
	.db (<wObtainedTreasureFlags+TREASURE_GALE_SEEDS/8)   , 1<<(TREASURE_GALE_SEEDS&7)
	.db (<wObtainedTreasureFlags+TREASURE_MYSTERY_SEEDS/8), 1<<(TREASURE_MYSTERY_SEEDS&7)
	.db <wLinkNameNullTerminator, $00	; ITEM_DROP_0a
	.db <wLinkNameNullTerminator, $00	; ITEM_DROP_0b
.ifdef ROM_AGES
	.db <wLinkNameNullTerminator, $00	; ITEM_DROP_1_ORE_CHUNK
	.db <wLinkNameNullTerminator, $00	; ITEM_DROP_10_ORE_CHUNKS
	.db <wLinkNameNullTerminator, $00	; ITEM_DROP_50_ORE_CHUNKS
.else
	.db <wMinimapGroup $01			; ITEM_DROP_1_ORE_CHUNK
	.db <wMinimapGroup $01			; ITEM_DROP_10_ORE_CHUNKS
	.db <wMinimapGroup $01			; ITEM_DROP_50_ORE_CHUNKS
.endif
	.db <wc608, $ff				; ITEM_DROP_100_RUPEES_OR_ENEMY


; Each entry in this table is a bitset. A random bit is chosen. If the bit is 0, no item drops.
itemDropProbabilityTable:
	.dw @probability0
	.dw @probability1
	.dw @probability2
	.dw @probability3
	.dw @probability4
	.dw @probability5
	.dw @probability6
	.dw @probability7

@probability0:
@probability1:
	.db $08 $00 $00 $20 $80 $00 $00 $10

@probability2:
	.db $08 $10 $08 $20 $80 $01 $80 $10

@probability3:
	.db $08 $50 $09 $24 $88 $81 $b0 $12

@probability4:
	.db $49 $50 $49 $24 $88 $99 $b2 $d2

@probability5:
	.db $b2 $e3 $aa $cc $81 $8f $c6 $6c

@probability6:
	.db $ba $ff $ea $dd $bd $bf $d6 $ed

@probability7:
	.db $ff $ff $ff $ff $ff $ff $ff $ff

.ifdef ROM_SEASONS
subrosiaDropSet:
	.db ITEM_DROP_HEART
	.db ITEM_DROP_1_ORE_CHUNK
	.db ITEM_DROP_1_ORE_CHUNK
	.db ITEM_DROP_1_ORE_CHUNK
	.db ITEM_DROP_1_ORE_CHUNK
	.db ITEM_DROP_1_ORE_CHUNK
	.db ITEM_DROP_10_ORE_CHUNKS
	.db ITEM_DROP_1_ORE_CHUNK
	.db ITEM_DROP_1_ORE_CHUNK
	.db ITEM_DROP_10_ORE_CHUNKS
	.db ITEM_DROP_10_ORE_CHUNKS
	.db ITEM_DROP_10_ORE_CHUNKS
	.db ITEM_DROP_1_ORE_CHUNK
	.db ITEM_DROP_10_ORE_CHUNKS
	.db ITEM_DROP_50_ORE_CHUNKS
	.db ITEM_DROP_100_RUPEES_OR_ENEMY
.endif

; See constants/itemDrops.s for what these values are
itemDropSet0:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $01

itemDropSet1:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $02 $02 $03 $03 $00 $01 $02
	.db $06 $06 $06 $06 $05 $05 $09 $05

itemDropSet2:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $07 $08 $09 $07 $06 $05 $05 $05
	.db $06 $06 $07 $07 $08 $08 $09 $05

itemDropSet3:
	.db $0f $0f $0f $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $02 $02 $02 $02 $02 $02 $01
	.db $02 $03 $03 $03 $03 $02 $00 $00

itemDropSet4:
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04

itemDropSet5:
	.db $05 $05 $05 $05 $05 $05 $06 $06
	.db $06 $06 $06 $07 $07 $07 $07 $07
	.db $07 $08 $08 $08 $08 $08 $09 $09
	.db $09 $09 $09 $05 $06 $07 $08 $09

itemDropSet6:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $02 $02 $02 $02 $02 $02
	.db $02 $02 $02 $03 $03 $00 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04

itemDropSet7:
	.db $01 $01 $01 $01 $01 $01 $01 $02
	.db $02 $02 $02 $03 $03 $03 $03 $00
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $09 $08 $07 $07 $06 $06 $05 $05

itemDropSet8:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $02 $02
	.db $02 $02 $03 $03 $00 $04 $04 $04
	.db $04 $09 $08 $07 $06 $05 $05 $07

itemDropSet9:
	.db $0f $0f $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $02 $02 $03 $03 $00 $01 $02
	.db $06 $06 $06 $06 $05 $05 $09 $09

itemDropSetA:
	.db $01 $01 $01 $01 $01 $01 $02 $02
	.db $02 $02 $02 $03 $03 $03 $00 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $09 $08 $07 $07 $06 $05 $06

itemDropSetB:
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $03 $03 $03 $00 $04 $04 $04
	.db $04 $09 $09 $08 $08 $08 $07 $07
	.db $07 $06 $06 $06 $09 $05 $05 $05

itemDropSetC:
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $02 $03 $03 $03 $03 $03 $03
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04

itemDropSetD:
	.db $02 $02 $02 $02 $02 $02 $02 $02
	.db $02 $02 $03 $03 $03 $03 $03 $03
	.db $09 $09 $08 $08 $08 $07 $07 $07
	.db $06 $06 $06 $05 $05 $05 $09 $05

itemDropSetE:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $02
	.db $01 $02 $02 $02 $02 $02 $02 $02
	.db $02 $02 $02 $02 $03 $03 $03 $03

itemDropSetF:
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00

; Data format (per byte):
;   Bits 0-2: Index for itemDropProbabilityTable
;   Bits 3-7: Index for itemDropSetTable
; Or it can be $ff for no item drop.
; Comments show changes in Seasons
itemDropTables:
.ifdef ROM_AGES
	.db $ff $ef $ff $ff $ff $ff $ff $ff
	.db $a6 $8e $86 $c1 $ac $86 $ff $85 ; index 7: $85 -> $ff
	.db $81 $ff $8e $ef $8e $c0 $ff $60
	.db $a5 $ee $8e $cb $80 $c7 $8e $8e
	.db $ac $88 $47 $a4 $42 $c2 $47 $ff
	.db $ae $ff $ff $ff $60 $ff $ff $ff
	.db $81 $8e $ae $ff $ff $ae $ff $ff
	.db $ff $61 $ff $ff $60 $aa $a2 $ff ; index 4: $60 -> $ae
	.db $8e $6d $85 $8e $ff $8d $82 $a0 ; index 2: $85 -> $44
	.db $87 $88 $ac $a0 $64 $ff $27 $cb
	.db $a5 $8c $67 $ff $ff $8e $ff $ff
	.db $ff $ff $ff $ff $ff $ff $a2 $ff
	.db $ff $ff $ff $ff $e0 $ff $ff $ff ; index 4: $e0 -> $ff
	.db $ff $ff $ff $ff $ff $ff $ff $ff
	.db $ef $ef $ef $ef $ef $ef $ef $ef
	.db $ff $ff $ff $ff $ff $ff $ff $ff ; index 6: $ff -> $ef
	.db $ff $41 $87 $65 $86 $8e $a7 $ae
	.db $a0 $63 $69 $a5 $6e $ff $ff $ff
.else
	.db $ff $ef $ff $ff $ff $ff $ff $ff
	.db $a6 $8e $86 $c1 $ac $86 $ff $ff
	.db $81 $ff $8e $ef $8e $c0 $ff $60
	.db $a5 $ee $8e $cb $80 $c7 $8e $8e
	.db $ac $88 $47 $a4 $42 $c2 $47 $ff
	.db $ae $ff $ff $ff $60 $ff $ff $ff
	.db $81 $8e $ae $ff $ff $ae $ff $ff
	.db $ff $61 $ff $ff $ae $aa $a2 $ff
	.db $8e $6d $44 $8e $ff $8d $82 $a0
	.db $87 $88 $ac $a0 $64 $ff $27 $cb
	.db $a5 $8c $67 $ff $ff $8e $ff $ff
	.db $ff $ff $ff $ff $ff $ff $a2 $ff
	.db $ff $ff $ff $ff $ff $ff $ff $ff
	.db $ff $ff $ff $ff $ff $ff $ff $ff
	.db $ef $ef $ef $ef $ef $ef $ef $ef
	.db $ff $ff $ff $ff $ff $ff $ef $ff
	.db $ff $41 $87 $65 $86 $8e $a7 $ae
	.db $a0 $63 $69 $a5 $6e $ff $ff $ff
.endif

;;
; @param	a	Treasure index
; @param	c	Treasure "parameter"
checkIncreaseGashaMaturityForGettingTreasure:
	push bc
	ld b,a
	ld hl,@data-1
--
	inc hl
	ldi a,(hl)
	or a
	jr z,++
	cp b
	jr nz,--

	cp TREASURE_HEART_REFILL
	ld a,c
	jr z,+
	ld a,(hl)
+
	call addToGashaMaturity
++
	pop bc
	ret

@data:
	.db TREASURE_ESSENCE		150
.ifdef ROM_AGES
	.db TREASURE_HEART_PIECE	 36
.else
	.db TREASURE_HEART_PIECE	100
.endif
	.db TREASURE_TRADEITEM		100
	.db TREASURE_HEART_REFILL	  4
	.db $00
