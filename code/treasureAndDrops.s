;;
; Called from checkTreasureObtained in bank 0.
;
; @param	l	Item to check for (see constants/treasure.s)
; @param[out]	h	Bit 0 set if link has the item
; @param[out]	l	Value of the treasure's "related variable" (ie. item level)
; @addr{446d}
checkTreasureObtained_body:
	ld a,l			; $446d
	cp TREASURE_60			; $446e
	jr nc,@index60OrHigher		; $4470

	ldh (<hFF8B),a	; $4472
	ld hl,wObtainedTreasureFlags		; $4474
	call checkFlag		; $4477
	jr z,@dontHaveItem		; $447a

	push bc			; $447c
	ldh a,(<hFF8B)	; $447d
	ld c,a			; $447f
	ld b,$00		; $4480
	ld hl,treasureCollectionBehaviourTable		; $4482
	add hl,bc		; $4485
	add hl,bc		; $4486
	add hl,bc		; $4487
	pop bc			; $4488
	ldi a,(hl)		; $4489
	ld l,a			; $448a
	or a			; $448b
	jr z,@haveItem			; $448c

	ld h,>wc600Block		; $448e
	ld l,(hl)		; $4490

@haveItem:
	ld h,$01		; $4491
	ret			; $4493

@index60OrHigher:
	and $07			; $4494
	ld hl,wcca8		; $4496
	call checkFlag		; $4499
	jr nz,@haveItem		; $449c

@dontHaveItem:
	ld h,$00		; $449e
	ret			; $44a0

;;
; @param	b	Treasure
; @addr{44a1}
loseTreasure_body:
	push hl			; $44a1
	ld a,b			; $44a2
	call _loseTreasure_helper		; $44a3
	pop hl			; $44a6
	ret			; $44a7

;;
; Unset the bit in wObtainedTreasureFlags, and remove it from the inventory if it's an
; inventory item.
;
; @param	a	Treasure
; @addr{44a8}
_loseTreasure_helper:
	ld b,a			; $44a8
	ld hl,wObtainedTreasureFlags		; $44a9
	call unsetFlag		; $44ac

	; Only continue if it's an inventory item (index < $20)
	ld a,b			; $44af
	cp NUM_INVENTORY_ITEMS			; $44b0
	ret nc			; $44b2

	; Attempt to remove the item from the inventory
	ld hl,wInventoryB		; $44b3
	ld b,INVENTORY_CAPACITY+2		; $44b6
--
	cp (hl)			; $44b8
	jr z,@foundItem			; $44b9

	inc l			; $44bb
	dec b			; $44bc
	jr nz,--		; $44bd
	ret			; $44bf

@foundItem:
	ld (hl),$00		; $44c0

	; Refresh the A/B buttons on the status bar
	ld hl,wStatusBarNeedsRefresh		; $44c2
	set 0,(hl)		; $44c5

	ret			; $44c7

;;
; Called from giveTreasure in bank 0.
;
; @param	b	Item to give (see constants/treasure)
; @param	c	"Parameter"
; @param[out]	b	Sound to play
; @addr{44c8}
giveTreasure_body:
	push hl			; $44c8
	push de			; $44c9
	ld a,b			; $44ca
	ldh (<hFF8B),a	; $44cb
	push bc			; $44cd

	; Check if adding this item requires the removal of another item.
	ld hl,@itemsToRemoveTable		; $44ce
	call @findItemInTable		; $44d1
	jr z,+			; $44d4

	call _loseTreasure_helper		; $44d6
	ld a,c			; $44d9
	call _loseTreasure_helper		; $44da
+
	pop bc			; $44dd
	ld a,b			; $44de
	call @giveTreasure		; $44df

	; Check if adding this item requires adding another item.
	push af			; $44e2
	ld hl,@extraItemsToAddTable		; $44e3
	call @findItemInTable		; $44e6
	call nz,@giveTreasure		; $44e9

	pop bc			; $44ec
	pop de			; $44ed
	pop hl			; $44ee
	ret			; $44ef

;;
; @param	hl	Table to search through
; @param	hFF8B	The treasure currently being given to Link
; @param[out]	a,c	Two values associated with the item
; @param[out]	zflag	Set if the item being added wasn't in the table
; @addr{44f0}
@findItemInTable:
	ldh a,(<hFF8B)	; $44f0
	ld c,a			; $44f2
--
	ldi a,(hl)		; $44f3
	cp c			; $44f4
	jr z,+			; $44f5
	or a			; $44f7
	ret z			; $44f8

	inc hl			; $44f9
	inc hl			; $44fa
	jr --			; $44fb
+
	ldi a,(hl)		; $44fd
	ld c,(hl)		; $44fe
	or a			; $44ff
	ret			; $4500

;;
; @param	a	Item being added
; @param	c	Parameter
; @addr{4501}
@giveTreasure:
	ldh (<hFF8B),a	; $4501
	call _checkIncreaseGashaMaturityForGettingTreasure		; $4503
	call addTreasureToInventory		; $4506

	ld hl,wObtainedTreasureFlags		; $4509
	ldh a,(<hFF8B)	; $450c
	call setFlag		; $450e

	push bc			; $4511
	ldh a,(<hFF8B)	; $4512
	ld c,a			; $4514
	ld b,$00		; $4515
	ld hl,treasureCollectionBehaviourTable		; $4517
	add hl,bc		; $451a
	add hl,bc		; $451b
	add hl,bc		; $451c
	pop bc			; $451d
	ld d,>wc600Block		; $451e
	ldi a,(hl)		; $4520
	ld e,a			; $4521
	or a			; $4522
	jr nz,+			; $4523
	ld e,<wShortSecretIndex		; $4525
+
	ld a,(hl)		; $4527
	and $0f			; $4528
	push hl			; $452a
	call @applyParameter		; $452b

	; Check whether to play a sound effect
	pop hl			; $452e
	bit 7,(hl)		; $452f
	inc hl			; $4531
	ldi a,(hl)		; $4532
	jr nz,@ret			; $4533
	call playSound		; $4535
	xor a			; $4538

@ret:
	ret			; $4539

; When Link obtains any item in the first column, he will obtain the item in the second
; column with the parameter in the third column.
; Example: When Link gets the seed satchel, he also gets 20 ember seeds.
@extraItemsToAddTable:
	.db TREASURE_SEED_SATCHEL	TREASURE_EMBER_SEEDS	$20
	.db TREASURE_HEART_CONTAINER	TREASURE_HEART_REFILL	$40
	.db TREASURE_BOMB_FLOWER	TREASURE_58		$00
.ifdef ROM_AGES
	.db TREASURE_TUNE_OF_ECHOES	TREASURE_HARP		$01
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
; @addr{4548}
@applyParameter:
	rst_jumpTable			; $4548
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

; Set a bit in [$cca8].
@modeb:
	ld a,c			; $4569
	ld hl,wcca8		; $456a
	jp setFlag		; $456d

; Set [de] to c if [de]<c. Also refreshes part of status bar. Used for items with levels.
@mode8:
	ld a,(de)		; $4570
	cp c			; $4571
	ret nc			; $4572
	ld a,c			; $4573
	ld (de),a		; $4574
	ld hl,wStatusBarNeedsRefresh		; $4575
	set 0,(hl)		; $4578
	ret			; $457a

; [de] = c
@mode5:
	ld a,c			; $457b
	ld (de),a		; $457c
	ret			; $457d

; Set bit [wDungeonIndex] in [de].
@mode6:
	ld a,(wDungeonIndex)		; $457e
	ld c,a			; $4581

; Set bit c in [de].
@mode1:
	ld a,c			; $4582
	ld h,d			; $4583
	ld l,e			; $4584
	jp setFlag		; $4585

; Increment [de].
@mode2:
	ld a,(de)		; $4588
	inc a			; $4589
	ld (de),a		; $458a
	ret			; $458b

; Increment [de] as a bcd value.
@mode3:
	ld c,$01		; $458c

; Add c to [de] as a bcd value.
; Mode 4 is also called by mode d, mode f.
@mode4:
	ld a,(de)		; $458e
	add c			; $458f
	daa			; $4590
	jr nc,+			; $4591
	ld a,$99		; $4593
+
	ld (de),a		; $4595
	ret			; $4596

; Increment [de+[wDungeonIndex]].
; Used for small keys.
@mode7:
	ld a,(wDungeonIndex)		; $4597
	add e			; $459a
	ld l,a			; $459b
	ld h,d			; $459c
	inc (hl)		; $459d
	ld hl,wStatusBarNeedsRefresh		; $459e
	set 4,(hl)		; $45a1
	ret			; $45a3

; [de] += c.
@modea:
	ld a,(de)		; $45a4
	add c			; $45a5
	ld (de),a		; $45a6
	ret			; $45a7

; [de] += c, and [de+1] is the cap for this value.
; Also plays a sound effect if it's operating on wLinkHealth.
@modec:
	ld h,d			; $45a8
	ld l,e			; $45a9

	; Check if we're adding to wLinkHealth
	ld a,<wLinkHealth		; $45aa
	cp e			; $45ac
	ldi a,(hl)		; $45ad
	jr nz,+			; $45ae

	; If so, compare current health to max health
	cp (hl)			; $45b0
	jr nz,+			; $45b1

	; This code will probably only run when you get a heart, but your health is
	; already full.
	ld a,SND_GAINHEART		; $45b3
	jp playSound		; $45b5
+
	add c			; $45b8
	ld (de),a		; $45b9
	jr ++			; $45ba

; [de] += c (as bcd values), and [de+1] is the cap.
@moded:
	call @mode4		; $45bc
	ld h,d			; $45bf
	ld l,e			; $45c0
	inc l			; $45c1
++
	cp (hl)			; $45c2
	ret c			; $45c3
	ldd a,(hl)		; $45c4
	ld (hl),a		; $45c5
	ret			; $45c6

; Adds rupee value of 'c' to 2-byte bcd value at [de].
; Also adds to wTotalRupeesCollected if operating on wNumRupees.
@modee:
	; Get the value of the rupee in bc
	ld a,c			; $45c7
	call getRupeeValue		; $45c8

	; Check whether to add this to wTotalRupeesCollected
	ld a,e			; $45cb
	cp <wNumRupees			; $45cc
	jr nz,++		; $45ce

	ld a,GLOBALFLAG_10000_RUPEES_COLLECTED		; $45d0
	call checkGlobalFlag		; $45d2
	jr nz,++		; $45d5

	; Add the amount to the total rupee counter, set the flag when it reaches 10000.
	ld h,d			; $45d7
	ld l,<wTotalRupeesCollected		; $45d8
	call addDecimalToHlRef		; $45da
	jr nc,++		; $45dd
	ld a,GLOBALFLAG_10000_RUPEES_COLLECTED		; $45df
	call setGlobalFlag		; $45e1

++
	ld h,d			; $45e4
	ld l,e			; $45e5
	call addDecimalToHlRef		; $45e6

	; Check for overflow
	ldi a,(hl)		; $45e9
	ld h,(hl)		; $45ea
	ld l,a			; $45eb
	ld bc,$0999		; $45ec
	call compareHlToBc		; $45ef
	dec a			; $45f2
	ret nz			; $45f3

	ld a,c			; $45f4
	ld (de),a		; $45f5
	inc e			; $45f6
	ld a,b			; $45f7
	ld (de),a		; $45f8
	ld a,SND_RUPEE		; $45f9
	jp playSound		; $45fb

; [de] += c (as bcd values), check wSeedSatchelLevel for the cap.
; Used for giving seeds.
@modef:
	call @mode4		; $45fe
	call setStatusBarNeedsRefreshBit1		; $4601
	ld a,(wSeedSatchelLevel)		; $4604
	ld hl,@seedSatchelCapacities-1		; $4607
	rst_addAToHl			; $460a
	ld a,(de)		; $460b
	cp (hl)			; $460c
	ret c			; $460d

	ld a,(hl)		; $460e
	ld (de),a		; $460f
	ret			; $4610

@seedSatchelCapacities:
	.db $20 $50 $99

; Add a ring to the unappraised ring list.
@mode9:
	; Setting bit 6 means the ring is unappraised
	set 6,c			; $4614
	call realignUnappraisedRings		; $4616

	; Check that there are less than 64 unappraised rings (checking aginst a bcd
	; number)
	cp $64			; $4619
	jr c,+			; $461b

	; If there are already 64 unappraised rings, remove one duplicate ring and
	; re-align the list.
	call @removeOneDuplicateRing		; $461d
	call realignUnappraisedRings		; $4620
+
	; Add the ring to the end of the list
	ld a,c			; $4623
	ld (wUnappraisedRingsEnd-1),a		; $4624
	jr realignUnappraisedRings		; $4627

;;
; Decides on one ring to remove by counting all of the unappraised rings and finding the
; one with the most duplicates.
; @addr{4629}
@removeOneDuplicateRing:
	ld a,($ff00+R_SVBK)	; $4629
	push af			; $462b
	ld a,:w4TmpRingBuffer		; $462c
	ld ($ff00+R_SVBK),a	; $462e

	; Construct w4TmpRingBuffer such that each index corresponds to how many
	; unappraised rings of that index Link has.

	ld hl,w4TmpRingBuffer		; $4630
	ld b,NUM_RINGS		; $4633
	call clearMemory		; $4635

	ld de,wUnappraisedRings		; $4638
	ld b,wUnappraisedRingsEnd-wUnappraisedRings		; $463b
--
	ld a,(de)		; $463d
	and $3f			; $463e
	ld hl,w4TmpRingBuffer		; $4640
	rst_addAToHl			; $4643
	inc (hl)		; $4644
	inc e			; $4645
	dec b			; $4646
	jr nz,--		; $4647

	; Now loop through w4TmpRingBuffer to find the ring with the most duplicates.
	; d = max number of duplicates
	; e = the index with the most duplicates

	ld hl,w4TmpRingBuffer		; $4649
	ld de,$0000		; $464c
	ld b,NUM_RINGS		; $464f
--
	ld a,(hl)		; $4651
	cp d			; $4652
	jr c,+			; $4653
	ld d,a			; $4655
	ld e,l			; $4656
+
	inc l			; $4657
	dec b			; $4658
	jr nz,--		; $4659

	ld a,e			; $465b
	sub <w4TmpRingBuffer			; $465c
	or $40			; $465e
	ld e,a			; $4660

	; Restore wram bank
	pop af			; $4661
	ld ($ff00+R_SVBK),a	; $4662

	; Search for an instance of the ring to be replaced in wUnappraisedRings

	ld hl,wUnappraisedRingsEnd-1		; $4664
--
	ldd a,(hl)		; $4667
	cp e			; $4668
	jr nz,--		; $4669

	; Remove that ring from the list
	inc hl			; $466b
	ld (hl),$ff		; $466c
	ret			; $466e

;;
; Reorganize wUnappraisedRings so that there are no blank spaces (everything gets put into
; a contiguous block at the start). Also updates wNumUnappraisedRingsBcd.
;
; @param[out]	a	Number of unappraised rings (bcd)
; @param[out]	b	Number of unappraised rings (normal number)
; @addr{466f}
realignUnappraisedRings:
	ld hl,wUnappraisedRings		; $466f
--
	; Check if this slot is empty.
	ld a,(hl)		; $4672
	cp $ff			; $4673
	jr nz,++		; $4675

	; If there is a ring later in the list, move it to this slot.
	push hl			; $4677
	call @findNextFilledSlot		; $4678
	pop hl			; $467b
	jr nc,+++		; $467c

	ld (hl),a		; $467e
++
	inc l			; $467f
	ld a,l			; $4680
	cp <wUnappraisedRingsEnd			; $4681
	jr nz,--		; $4683
+++
	jr getNumUnappraisedRings		; $4685

;;
; Find the next filled slot in wUnappraisedRings, and clear it.
;
; @param	hl	Where to start searching in the unappraised ring list
; @param[out]	a	The value of the first non-empty ring slot encountered after hl
; @param[out]	cflag	Set if a non-empty ring slot was encountered
; @addr{4687}
@findNextFilledSlot:
	ldi a,(hl)		; $4687
	cp $ff			; $4688
	jr nz,++		; $468a
	ld a,l			; $468c
	cp <wUnappraisedRingsEnd			; $468d
	jr nz,@findNextFilledSlot		; $468f
	ret			; $4691
++
	dec hl			; $4692
	ld (hl),$ff		; $4693
	scf			; $4695
	ret			; $4696

;;
; Sets wNumUnappraisedRingsBcd, and returns the number of unappraised rings
; (non-bcd) in b.
;
; @param[out]	a	Number of unappraised rings (bcd)
; @param[out]	b	Number of unappraised rings (normal number)
; @addr{4697}
getNumUnappraisedRings:
	push de			; $4697
	ld hl,wUnappraisedRings		; $4698
	ld de,$4000		; $469b
--
	ldi a,(hl)		; $469e
	cp $ff			; $469f
	jr z,+			; $46a1
	inc e			; $46a3
+
	dec d			; $46a4
	jr nz,--		; $46a5

	push bc			; $46a7
	ld a,e			; $46a8
	call hexToDec		; $46a9
	swap c			; $46ac
	or c			; $46ae
	ld (wNumUnappraisedRingsBcd),a		; $46af
	pop bc			; $46b2
	ld b,e			; $46b3
	pop de			; $46b4
	ret			; $46b5

;;
; @param	hFF8B	Treasure index
; @addr{46b6}
addTreasureToInventory:
	ldh a,(<hFF8B)	; $46b6
	cp NUM_INVENTORY_ITEMS			; $46b8
	ret nc			; $46ba

	push bc			; $46bb
	call @addToInventory		; $46bc
	pop bc			; $46bf
	ret nc			; $46c0
	jp z,setStatusBarNeedsRefreshBit1		; $46c1

	; Do something weird with biggoron's sword...
	push bc			; $46c4
	cpl			; $46c5
	add <wInventoryB			; $46c6
	ld l,a			; $46c8
	ldh a,(<hFF8B)	; $46c9
	ld c,a			; $46cb
	cp TREASURE_BIGGORON_SWORD			; $46cc
	jr nz,+			; $46ce

	ld a,(hl)		; $46d0
	ld (hl),c		; $46d1
	call @addToInventory		; $46d2
+
	ld hl,wStatusBarNeedsRefresh		; $46d5
	set 0,(hl)		; $46d8
	pop bc			; $46da
	ret			; $46db

;;
; @param	a	Item to add
; @param[out]	a	Index of the inventory slot it went into
; @param[out]	zflag	z if already had the item
; @addr{46dc}
@addToInventory:
	ld c,a			; $46dc
	ld hl,wInventoryB		; $46dd

	; Check if link has the item already
	ld b,INVENTORY_CAPACITY+2		; $46e0
@nextItem:
	ldi a,(hl)		; $46e2
	cp c			; $46e3
	jr z,@assignItem	; $46e4
	dec b			; $46e6
	jr nz,@nextItem	; $46e7

	; Find the first available slot
	dec b			; $46e9
	ld l,<wInventoryB		; $46ea
--
	ldi a,(hl)		; $46ec
	or a			; $46ed
	jr nz,--		; $46ee

@assignItem:
	dec l			; $46f0
	ld (hl),c		; $46f1
	ld a,l			; $46f2
	sub <wInventoryStorage			; $46f3
	bit 7,b			; $46f5
	ret			; $46f7

;;
; Loads 7 bytes of "display data" describing a treasure's sprite, its palette, what its
; inventory text should be, and whether to display a "quantity" next to it (ie. level).
;
; See "treasureDisplayData2" to see the exact format of these 7 bytes.
;
; @param	l	Treasure index
; @param[out]	hl	Where the data is stored (wTmpcec0).
; @addr{46f8}
loadTreasureDisplayData:
	ld a,l			; $46f8
	push de			; $46f9
	call @getTableIndices		; $46fa

	; Set up hl to point to "[treasureDisplayData2+e*2]+d*7".

	push bc			; $46fd
	ld hl,$0000		; $46fe

	; hl = d*7
	ld a,d			; $4701
	or a			; $4702
	jr z,+			; $4703
	cpl			; $4705
	inc a			; $4706
	ld l,a			; $4707
	ld h,$ff		; $4708
	ld a,d			; $470a
	call multiplyABy8		; $470b
	add hl,bc		; $470e
+
	push hl			; $470f
	ld a,e			; $4710
	ld hl,treasureDisplayData2		; $4711
	rst_addDoubleIndex			; $4714
	ldi a,(hl)		; $4715
	ld h,(hl)		; $4716
	ld l,a			; $4717
	pop bc			; $4718
	add hl,bc		; $4719

	; Now copy the 7 bytes to wTmpcec0
	ld de,wTmpcec0		; $471a
	ld b,$07		; $471d
-
	ldi a,(hl)		; $471f
	ld (de),a		; $4720
	inc e			; $4721
	dec b			; $4722
	jr nz,-			; $4723

	ld hl,wTmpcec0		; $4725
	pop bc			; $4728
	pop de			; $4729
	ret			; $472a

;;
; @param	a	Item index
; @param[out]	d	Index to read from the sub-table (in turn determined by 'e')
;			This is usually the item's level/loaded ammo, but if the item is
;			not in treasureDisplayData1, then this equals 'a'.
; @param[out]	e	Which sub-table to use from treasureDisplayData2
; @addr{472b}
@getTableIndices:
	ld d,a			; $472b
	ld hl,treasureDisplayData1		; $472c
-
	ldi a,(hl)		; $472f
	or a			; $4730
	jr z,+			; $4731

	cp d			; $4733
	jr z,+			; $4734

	inc hl			; $4736
	inc hl			; $4737
	jr -			; $4738

.ifdef ROM_SEASONS
+
	cp ITEMID_SLINGSHOT			; $4740
	jr nz,+			; $4742
	ld a,(wSlingshotLevel)		; $4744
	cp $02			; $4747
	jr nz,+			; $4749
	inc a			; $474b
	rst_addAToHl			; $474c
.endif
+
	ldi a,(hl)		; $473a
	ld e,(hl)		; $473b
	or a			; $473c
	jr z,+			; $473d

	ld l,a			; $473f
	ld h,>wc600Block	; $4740
	ld d,(hl)		; $4742
+
	ret			; $4743

;;
; Decides what an enemy will drop.
;
; @param	c
; @param[out]	c	Subid for PARTID_ITEM_DROP (see constants/itemDrops.s) or $ff if no item
;			should drop
; @addr{4744}
decideItemDrop_body:
	ld a,c			; $4744
	or a			; $4745
	set 7,a			; $4746
	jr nz,+			; $4748

	; If parameter == 0, assume it's an enemy; use the enemy's ID for the drop table. (Assumes
	; that 'd' points to an instance of PARTID_ENEMY_DESTROYED or PARTID_BOSS_DEATH_EXPLOSION,
	; whose subid refers to the enemy that was killed? TODO: verify.)
	ldh a,(<hActiveObjectType)	; $474a
	add Object.subid			; $474c
	ld e,a			; $474e
	ld a,(de)		; $474f
+
	ld hl,itemDropTables		; $4750
	rst_addAToHl			; $4753
	ld a,(hl)		; $4754
	ld c,a			; $4755
	cp $ff			; $4756
	jr z,checkItemDropAvailable_body@done		; $4758

	swap a			; $475a
	rrca			; $475c
	and $07			; $475d
	ld hl,_itemDropProbabilityTable		; $475f
	rst_addDoubleIndex			; $4762
	ldi a,(hl)		; $4763
	ld h,(hl)		; $4764
	ld l,a			; $4765
	call getRandomNumber		; $4766
	and $3f			; $4769
	call checkFlag		; $476b
	jr z,checkItemDropAvailable_body@done		; $476e

	ld a,c			; $4770
	and $1f			; $4771
	ld hl,_itemDropSetTable		; $4773
	rst_addDoubleIndex			; $4776
	ldi a,(hl)		; $4777
	ld h,(hl)		; $4778
	ld l,a			; $4779
	call getRandomNumber		; $477a
	and $1f			; $477d
	rst_addAToHl			; $477f
	ld a,(hl)		; $4780
	ld c,a			; $4781

;;
; Checks whether an item drop of a given type can spawn.
;
; @param	c	Item drop index (see constants/itemDrops.s)
; @param[out]	c	$ff if item cannot spawn (Link doesn't have it), otherwise the item itself
; @addr{4782}
checkItemDropAvailable_body:
.ifdef ROM_SEASONS
	; different drop table for subrosia
	ld a,(wMinimapGroup)	; $4795
	dec a			; $4798
	ld a,c			; $4799
	jr nz,+			; $479a
	ld hl,subrosiaDropSet		; $479c
	rst_addAToHl		; $479f
	ld a,(hl)		; $47a0
	ld c,a			; $47a1
+
.else
	ld a,c			; $4782
.endif
	ld hl,_itemDropAvailabilityTable		; $4783
	rst_addDoubleIndex			; $4786
	ldi a,(hl)		; $4787
	ld b,(hl)		; $4788
	ld l,a			; $4789
	ld h,>wc600Block		; $478a
	ld a,(hl)		; $478c
	and b			; $478d
	ret nz			; $478e
@done:
	ld c,$ff		; $478f
	ret			; $4791


; Rings are divided into "tiers" (called "classes" in TourianTourist's ring guide). These
; tiers are mostly used by gasha spots, each of which can give rings from a set tier list.
;
; Each tier has 8 ring types (except for the last one, which only has 2). Some have
; repeated rings in order to fill that list.
;
; @addr{4792}
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

; @addr{47be}
_itemDropSetTable:
	.dw _itemDropSet0
	.dw _itemDropSet1
	.dw _itemDropSet2
	.dw _itemDropSet3
	.dw _itemDropSet4
	.dw _itemDropSet5
	.dw _itemDropSet6
	.dw _itemDropSet7
	.dw _itemDropSet8
	.dw _itemDropSet9
	.dw _itemDropSetA
	.dw _itemDropSetB
	.dw _itemDropSetC
	.dw _itemDropSetD
	.dw _itemDropSetE
	.dw _itemDropSetF


; Each row corresponds to an item drop (see constants/itemDrops.s).
;   Byte 0: Variable in $c600 block to check
;   Byte 1: Value to AND with that variable to check availability; if nonzero, the item
;           can drop.
; @addr{47de}
_itemDropAvailabilityTable:
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
; @addr{47fe}
_itemDropProbabilityTable:
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
_itemDropSet0:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $01

_itemDropSet1:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $02 $02 $03 $03 $00 $01 $02
	.db $06 $06 $06 $06 $05 $05 $09 $05

_itemDropSet2:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $07 $08 $09 $07 $06 $05 $05 $05
	.db $06 $06 $07 $07 $08 $08 $09 $05

_itemDropSet3:
	.db $0f $0f $0f $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $02 $02 $02 $02 $02 $02 $01
	.db $02 $03 $03 $03 $03 $02 $00 $00

_itemDropSet4:
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04

_itemDropSet5:
	.db $05 $05 $05 $05 $05 $05 $06 $06
	.db $06 $06 $06 $07 $07 $07 $07 $07
	.db $07 $08 $08 $08 $08 $08 $09 $09
	.db $09 $09 $09 $05 $06 $07 $08 $09

_itemDropSet6:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $02 $02 $02 $02 $02 $02
	.db $02 $02 $02 $03 $03 $00 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04

_itemDropSet7:
	.db $01 $01 $01 $01 $01 $01 $01 $02
	.db $02 $02 $02 $03 $03 $03 $03 $00
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $09 $08 $07 $07 $06 $06 $05 $05

_itemDropSet8:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $02 $02
	.db $02 $02 $03 $03 $00 $04 $04 $04
	.db $04 $09 $08 $07 $06 $05 $05 $07

_itemDropSet9:
	.db $0f $0f $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $02 $02 $03 $03 $00 $01 $02
	.db $06 $06 $06 $06 $05 $05 $09 $09

_itemDropSetA:
	.db $01 $01 $01 $01 $01 $01 $02 $02
	.db $02 $02 $02 $03 $03 $03 $00 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $09 $08 $07 $07 $06 $05 $06

_itemDropSetB:
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $03 $03 $03 $00 $04 $04 $04
	.db $04 $09 $09 $08 $08 $08 $07 $07
	.db $07 $06 $06 $06 $09 $05 $05 $05

_itemDropSetC:
	.db $01 $01 $01 $01 $02 $02 $02 $02
	.db $02 $02 $03 $03 $03 $03 $03 $03
	.db $04 $04 $04 $04 $04 $04 $04 $04
	.db $04 $04 $04 $04 $04 $04 $04 $04

_itemDropSetD:
	.db $02 $02 $02 $02 $02 $02 $02 $02
	.db $02 $02 $03 $03 $03 $03 $03 $03
	.db $09 $09 $08 $08 $08 $07 $07 $07
	.db $06 $06 $06 $05 $05 $05 $09 $05

_itemDropSetE:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $02
	.db $01 $02 $02 $02 $02 $02 $02 $02
	.db $02 $02 $02 $02 $03 $03 $03 $03

_itemDropSetF:
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00

; Data format (per byte):
;   Bits 0-2: Index for _itemDropProbabilityTable
;   Bits 3-7: Index for _itemDropSetTable
; Or it can be $ff for no item drop.
; Comments show changes in Seasons
; @addr{4a46}
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
; @addr{4ad6}
_checkIncreaseGashaMaturityForGettingTreasure:
	push bc			; $4ad6
	ld b,a			; $4ad7
	ld hl,@data-1		; $4ad8
--
	inc hl			; $4adb
	ldi a,(hl)		; $4adc
	or a			; $4add
	jr z,++			; $4ade
	cp b			; $4ae0
	jr nz,--		; $4ae1

	cp TREASURE_HEART_REFILL			; $4ae3
	ld a,c			; $4ae5
	jr z,+			; $4ae6
	ld a,(hl)		; $4ae8
+
	call addToGashaMaturity		; $4ae9
++
	pop bc			; $4aec
	ret			; $4aed

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
