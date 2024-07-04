;;
tryBreakTileWithExpertsRing:
	ld a,(w1Link.direction)
	add a
	ld c,a
	ld a,BREAKABLETILESOURCE_EXPERTS_RING
	jr tryBreakTileWithSword

;;
; Same as below function, except this checks the sword's level to decide on the
; "breakableTileSource".
;
; @param	a	Direction (see below function)
tryBreakTileWithSword_calculateLevel:
	; Use BREAKABLETILESOURCE_SWORD_L1 or L2 depending on sword's level
	ld c,a
	ld a,(wSwordLevel)
	cp $01
	jr z,tryBreakTileWithSword
	ld a,BREAKABLETILESOURCE_SWORD_L2

;;
; Deals with sword slashing / spinning / poking against tiles, breaking them
;
; @param	a	See constants/common/breakableTileSources.s
; @param	c	Direction (0-7 are 45-degree increments, 8 is link's center)
tryBreakTileWithSword:
	; Check link is close enough to the ground
	ld e,a
	ld a,(w1Link.zh)
	dec a
	cp $f6
	ret c

	; Get Y/X relative to Link in bc
	ld a,c
	ld hl,@linkOffsets
	rst_addDoubleIndex
	ld a,(w1Link.yh)
	add (hl)
	ld b,a
	inc hl
	ld a,(w1Link.xh)
	add (hl)
	ld c,a

	; Try to break the tile
	push bc
	ld a,e
	call tryToBreakTile

	; Copy tile position, then tile index
	ldh a,(<hFF93)
	ld (wccb0),a
	ldh a,(<hFF92)
	ld (wccaf),a
	pop bc

	; Return if the tile was broken
	ret c

	; Check for bombable wall clink sound
	ld hl,clinkSoundTable
	call findByteInCollisionTable
	jr c,@bombableWallClink

	; Only continue if the sword is in a "poking" state
	ld a,(w1ParentItem2.subid)
	or a
	ret z

	; Check the second list of tiles to see if it produces no clink at all
	call findByteAtHl
	ret c

	; Produce a clink only if the tile is solid
	ldh a,(<hFF93)
	ld l,a
	ld h,>wRoomCollisions
	ld a,(hl)
	cp $0f
	ret nz
	ld e,$01
	jr @createClink

	; Play a different sound effect on bombable walls
@bombableWallClink:
	ld a,SND_CLINK2
	call playSound

	; Set bit 7 of subid to prevent 'clink' interaction from also playing a sound
	ld e,$80

@createClink:
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERAC_CLINK
	inc l
	ld (hl),e
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ret


@linkOffsets:
	.db $f2 $00 ; Up
	.db $f2 $0d ; Up-right
	.db $00 $0d ; Right
	.db $0d $0d ; Down-right
	.db $0d $00 ; Down
	.db $0d $f2 ; Down-left
	.db $00 $f2 ; Left
	.db $f2 $f2 ; Up-left
	.db $00 $00 ; Center


.include {"{GAME_DATA_DIR}/tile_properties/clinkSounds.s"}


;;
; Calculates the value for Item.damage, accounting for ring modifiers.
;
itemCalculateSwordDamage:
	ld e,Item.var3a
	ld a,(de)
	ld b,a
	ld a,(w1ParentItem2.var3a)
	or a
	jr nz,@applyDamageModifier

	ld hl,@swordDamageModifiers
	ld a,(wActiveRing)
	ld e,a
@nextRing:
	ldi a,(hl)
	or a
	jr z,@noRingModifier
	cp e
	jr z,@foundRingModifier
	inc hl
	jr @nextRing

@noRingModifier:
	ld a,e
	cp RED_RING
	jr z,@redRing
	cp GREEN_RING
	jr z,@greenRing
	cp CURSED_RING
	jr z,@cursedRing

	ld a,b
	jr @setDamage

@redRing:
	ld a,b
	jr @applyDamageModifier

@greenRing:
	ld a,b
	cpl
	inc a
	sra a
	cpl
	inc a
	jr @applyDamageModifier

@cursedRing:
	ld a,b
	cpl
	inc a
	sra a
	cpl
	inc a
	jr @setDamage

@foundRingModifier:
	ld a,(hl)

@applyDamageModifier:
	add b

@setDamage:
	; Make sure it's not positive (don't want to heal enemies)
	bit 7,a
	jr nz,+
	ld a,$ff
+
	ld e,Item.damage
	ld (de),a
	ret


; Negative values give the sword more damage for that ring.
@swordDamageModifiers:
	.db POWER_RING_L1	$ff
	.db POWER_RING_L2	$fe
	.db POWER_RING_L3	$fd
	.db ARMOR_RING_L1	$01
	.db ARMOR_RING_L2	$01
	.db ARMOR_RING_L3	$01
	.db $00


;;
; Makes the given item mimic a tile. Used for switch hooking bushes and pots and stuff,
; possibly for other things too?
itemMimicBgTile:
	call getTileMappingData
	push bc
	ld h,d

	; Set Item.oamFlagsBackup, Item.oamFlags
	ld l,Item.oamFlagsBackup
	ld a,$0f
	ldi (hl),a
	ldi (hl),a

	; Set Item.oamTileIndexBase
	ld (hl),c

	; Compare the top-right tile to the top-left tile, and select the appropriate
	; animation depending on whether they reuse the same tile or not.
	; If they don't, it assumes that the graphics are adjacent to each other, due to
	; sprite limitations?
	ld a,($cec1)
	sub c
	jr z,+
	ld a,$01
+
	call itemSetAnimation

	; Copy the BG palette which the tile uses to OBJ palette 7
	pop af
	and $07
	swap a
	rrca
	ld hl,w2TilesetBgPalettes
	rst_addAToHl
	push de
	ld a,:w2TilesetSprPalettes
	ld ($ff00+R_SVBK),a
	ld de,w2TilesetSprPalettes+7*8
	ld b,$08
	call copyMemory

	; Mark OBJ 7 as modified
	ld hl,hDirtySprPalettes
	set 7,(hl)

	xor a
	ld ($ff00+R_SVBK),a
	pop de
	ret
