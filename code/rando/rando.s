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

	ld (hl),INTERACID_TREASURE ; id
	inc l

	ld d,h
	call initializeRandomizedTreasure_body

	ld d,0
	ld l,Interaction.id
	ret


;;
; Similar to above, but writes to a spawned treasure.
;
; @param	bc	Item slot pointer (something from "data/rando/itemSlots.s")
; @param	de	Treasure object
initializeRandomizedTreasure_body:
	ld h,d

	push bc

	ld d,b
	ld e,c
	ld a,(de)
	ld b,a
	ld l,Interaction.subid
	ldi (hl),a ; subid (treasure id)
	inc de
	ld a,(de)
	ld c,a
	ld (hl),a ; var03 (treasure subid)

	; Write collect mode to var3d
	ld l,Interaction.var3d
	inc de

	ld a,(de)
	ld (hl),a ; Collect mode

	; Write pointer to item slot
	pop bc
	ld l,Interaction.var3e
	ld a,c
	ldi (hl),a
	ld a,b
	ld (hl),a
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


; Data format per row:
;   dbbw group, room, itemslot
@roomTreasureTable:

.ifdef ROM_SEASONS
	dbbw $07, $e5, seasonsSlot_divingSpotOutsideD4
	dbbw $03, $94, seasonsSlot_oldManInTreehouse

	dbbw $04, $1b, seasonsSlot_d1_stalfosDrop
	dbbw $04, $12, seasonsSlot_d1_boss
	dbbw $04, $34, seasonsSlot_d2_ropeDrop
	dbbw $04, $29, seasonsSlot_d2_boss
	dbbw $04, $53, seasonsSlot_d3_boss
	dbbw $04, $7b, seasonsSlot_d4_potPuzzle
	dbbw $04, $75, seasonsSlot_d4_pool
	dbbw $04, $6c, seasonsSlot_d4_diveSpot
	dbbw $04, $5f, seasonsSlot_d4_boss
	dbbw $04, $8c, seasonsSlot_d5_boss
	dbbw $04, $ab, seasonsSlot_d6_magnetBallDrop
	dbbw $04, $d5, seasonsSlot_d6_boss
	dbbw $05, $3d, seasonsSlot_d7_b2fDrop
	dbbw $05, $50, seasonsSlot_d7_boss
	dbbw $05, $82, seasonsSlot_d8_eyeDrop
	dbbw $05, $75, seasonsSlot_d8_hardhatDrop
	dbbw $05, $7f, seasonsSlot_d8_ghostArmosDrop
	dbbw $05, $64, seasonsSlot_d8_boss

	; For fixing small keys only (not randomized)
	dbbw $05, $32, seasonsSlot_herosCave_holeRoomDrop
	dbbw $05, $2a, seasonsSlot_herosCave_waterRoomDrop
	.db $ff

.else; ROM_AGES

	dbbw $04, $1e, agesSlot_d1_ghiniDrop
	dbbw $04, $13, agesSlot_d1_boss
	dbbw $04, $39, agesSlot_d2_moblinDrop
	dbbw $06, $2b, agesSlot_d2_boss
	dbbw $04, $4b, agesSlot_d3_moldormDrop
	dbbw $04, $5e, agesSlot_d3_armosDrop
	dbbw $04, $4a, agesSlot_d3_boss
	dbbw $04, $6b, agesSlot_d4_boss
	dbbw $04, $bf, agesSlot_d5_boss
	dbbw $05, $36, agesSlot_d6_boss
	dbbw $05, $4b, agesSlot_d7_flowerRoom
	dbbw $05, $62, agesSlot_d7_boss
	dbbw $05, $78, agesSlot_d8_boss
	.db $ff

.endif


;;
; Replaces the "playCompassSoundIfKeyInRoom" function in bank 1.
playCompassSoundIfKeyInRoom_override:
	; Original game did this check, but this causes compass chimes to be skipped when entering
	; buildings. I guess it was used to mute the compass during specific circumstances, ie.
	; throwing ice blocks down in seasons D8. Maybe another way can be found to handle that?
	;ld a,(wMenuDisabled)
	;or a
	;ret nz

	ld a,(wActiveGroup)
	ld b,a
	ld a,(wActiveRoom)
	ld c,a

	; Substitute rooms (ie. maku tree screen variants always look at the 1st variant for data)
	ld hl,@roomSubstitutionTable
	ld e,2
	call searchDoubleKey
	jr nc,+
	ld b,(hl)
	inc hl
	ld c,(hl)
+
	ld hl,slotsStart + 3
	ld d,(slotsEnd - slotsStart) / ITEM_SLOT_SIZE

@loop:
	ld a,b
	cp (hl)
	inc hl
	jr nz,@nextSlot
	ld a,c
	cp (hl)
	jr nz,@nextSlot

	; This item slot is for this room
	push hl
	push de
	push bc
	dec hl
	dec hl
	dec hl
	dec hl
	ldi a,(hl)
	cp TREASURE_SMALL_KEY
	jr z,@key
	cp TREASURE_BOSS_KEY
	jr nz,@popVars

@key:
	; It's a key. Do we have the compass for it?
	push hl
	ld a,(hl) ; Treasure subid (always the same as parameter, or dungeon index)
	ld e,a
	ld hl,wDungeonCompasses
	call checkFlag
	pop hl
	jr z,@popVars

	; Check if we already got it. In most cases this just means checking ROOMFLAG_ITEM, but
	; there are a handful of item slots that this doesn't work with. For those cases, we check
	; for the item slot's "isItemObtained" callback function.
	dec hl
	ld b,h
	ld c,l
	ld a,1
	call getItemSlotCallback
	jr nz,@callback
	
	; No callback defined; default is to check room flags
	call getThisRoomFlags
	ld a,ROOMFLAG_ITEM
	and (hl)
	jr z,@playSound
	jr @popVars

@callback:
	push de
	call jpHl
	pop de
	jr c,@popVars

@playSound:
	call @getSoundToPlay
	call playSound
	pop bc
	pop de
	pop hl
	ret

@popVars:
	pop bc
	pop de
	pop hl

@nextSlot:
	ld a,ITEM_SLOT_SIZE - 1
	rst_addAToHl
	dec d
	jr nz,@loop
	ret


@getSoundToPlay:
	ld a,RANDO_CONFIG_KEYSANITY
	call checkRandoConfig
	ld a,SND_COMPASS
	ret z
	ld a,e ; Dungeon index

.ifdef ROM_AGES
	; Special case for D6 past compass chime
	cp $0c
	jr nz,@notD6Past
	ld a,$da
	ret

@notD6Past:
.endif

	add $d4 ; Sounds $d5-$dc are the compass chimes
	ret



; If in room X, check room Y for item slot data. Use this when an item slot can occupy multiple
; rooms. This is used for checking compass chimes.
@roomSubstitutionTable:

.ifdef ROM_SEASONS
	dwbe $020c, $020b ; Maku Tree variant screens
	dwbe $022b, $020b
	dwbe $022c, $020b
	dwbe $022d, $020b
	dwbe $025b, $020b
	dwbe $025c, $020b
	dwbe $025d, $020b
	dwbe $027b, $020b

	dwbe $0176, $0166 ; Subrosia Seaside
	dwbe $0175, $0166
	dwbe $0165, $0166

	;dwbe $052c, $0405 ; Linked variant of d0 rupee chest (idk what I'll do with this yet)
	.db $ff
.else; ROM_AGES
	dwbe $036f, $036e ; Symmetry city brothers

	dwbe $02ec, $02f4 ; Nuun highlands cave (ricky)
	dwbe $05b8, $02f4 ; Nuun highlands cave (dimitri)

	dwbe $02ef, $02ed ; First goron dance

	.db $ff
.endif


.include "code/rando/itemEvents.s"
.include "data/rando/itemSlots.s"

.ends
