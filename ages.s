; Main file for Oracle of Ages, US version

.include "include/rominfo.s"
.include "include/emptyfill.s"
.include "include/constants.s"
.include "include/structs.s"
.include "include/wram.s"
.include "include/hram.s"
.include "include/macros.s"
.include "include/script_commands.s"
.include "include/simplescript_commands.s"
.include "include/movementscript_commands.s"

.include "objects/macros.s"
.include "include/gfxDataMacros.s"

.include "build/textDefines.s"


.BANK $00 SLOT 0
.ORG 0

	.include "code/bank0.s"

.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"


.BANK $02 SLOT 1
.ORG 0

	.include "code/bank2.s"


.BANK $03 SLOT 1
.ORG 0

	.include "code/bank3.s"
	.include "code/ages/cutscenes/endgameCutscenes.s"
	.include "code/ages/cutscenes/miscCutscenes.s"

	.include "code/ages/garbage/bank03End.s"

.BANK $04 SLOT 1
.ORG 0

.include "code/bank4.s"

	; These 2 includes must be in the same bank
	.include "build/data/roomPacks.s"
	.include "build/data/musicAssignments.s"

	.include "build/data/roomLayoutGroupTable.s"
	.include "build/data/tilesets.s"
	.include "build/data/tilesetAssignments.s"

	.include "code/animations.s"

	.include "build/data/uniqueGfxHeaders.s"
	.include "build/data/uniqueGfxHeaderPointers.s"
	.include "build/data/animationGroups.s"
	.include "build/data/animationGfxHeaders.s"
	.include "build/data/animationData.s"

	.include "code/ages/tileSubstitutions.s"
	.include "build/data/singleTileChanges.s"
	.include "code/ages/roomSpecificTileChanges.s"

;;
; Left-over garbage from Seasons (d8LavaRoomsFillTilesWithLava), can be used
; for other tiles, not just lava
; @addr{6ba8}
func_04_6ba8:
	ld d,>wRoomLayout		; $6ba8
	ldi a,(hl)		; $6baa
	ld c,a			; $6bab
--
	ldi a,(hl)		; $6bac
	cp $ff			; $6bad
	ret z			; $6baf

	ld e,a			; $6bb0
	ld a,c			; $6bb1
	ld (de),a		; $6bb2
	jr --			; $6bb3

;;
; Fills a square in wRoomLayout using the data at hl.
; Data format:
; - Top-left position (YX)
; - Height
; - Width
; - Tile value
; @addr{6bb5}
fillRectInRoomLayout:
	ldi a,(hl)		; $6bb5
	ld e,a			; $6bb6
	ldi a,(hl)		; $6bb7
	ld b,a			; $6bb8
	ldi a,(hl)		; $6bb9
	ld c,a			; $6bba
	ldi a,(hl)		; $6bbb
	ld d,a			; $6bbc
	ld h,>wRoomLayout		; $6bbd
--
	ld a,d			; $6bbf
	ld l,e			; $6bc0
	push bc			; $6bc1
-
	ldi (hl),a		; $6bc2
	dec c			; $6bc3
	jr nz,-			; $6bc4

	ld a,e			; $6bc6
	add $10			; $6bc7
	ld e,a			; $6bc9
	pop bc			; $6bca
	dec b			; $6bcb
	jr nz,--		; $6bcc
	ret			; $6bce

;;
; Like fillRect, but reads a series of bytes for the tile values instead of
; just one.
; @addr{6bcf}
drawRectInRoomLayout:
	ld a,(de)		; $6bcf
	inc de			; $6bd0
	ld h,>wRoomLayout		; $6bd1
	ld l,a			; $6bd3
	ldh (<hFF8B),a	; $6bd4
	ld a,(de)		; $6bd6
	inc de			; $6bd7
	ld c,a			; $6bd8
	ld a,(de)		; $6bd9
	inc de			; $6bda
	ldh (<hFF8D),a	; $6bdb
---
	ldh a,(<hFF8D)	; $6bdd
	ld b,a			; $6bdf
--
	ld a,(de)		; $6be0
	inc de			; $6be1
	ldi (hl),a		; $6be2
	dec b			; $6be3
	jr nz,--		; $6be4

	ldh a,(<hFF8B)	; $6be6
	add $10			; $6be8
	ldh (<hFF8B),a	; $6bea
	ld l,a			; $6bec
	dec c			; $6bed
	jr nz,---		; $6bee
	ret			; $6bf0

.include "code/loadTilesToRam.s"

;;
; Called from loadTilesetData in bank 0.
;
; @addr{6d7a}
loadTilesetData_body:
	call getAdjustedRoomGroup		; $6d7a

	ld hl,roomTilesetsGroupTable
	rst_addDoubleIndex			; $6d80
	ldi a,(hl)		; $6d81
	ld h,(hl)		; $6d82
	ld l,a			; $6d83
	ld a,(wActiveRoom)		; $6d84
	rst_addAToHl			; $6d87
	ld a,(hl)		; $6d88
	ldh (<hFF8D),a	; $6d89
	call @func_6d94		; $6d8b
	call func_6de7		; $6d8e
	ret nc			; $6d91
	ldh a,(<hFF8D)	; $6d92
@func_6d94:
	and $80			; $6d94
	ldh (<hFF8B),a	; $6d96
	ldh a,(<hFF8D)	; $6d98

	and $7f			; $6d9a
	call multiplyABy8		; $6d9c
	ld hl,tilesetData
	add hl,bc		; $6da2

	ldi a,(hl)		; $6da3
	ld e,a			; $6da4
	ldi a,(hl)		; $6da5
	ld (wTilesetFlags),a		; $6da6
	bit TILESETFLAG_BIT_DUNGEON,a			; $6da9
	jr z,+

	ld a,e			; $6dad
	and $0f			; $6dae
	ld (wDungeonIndex),a		; $6db0
	jr ++
+
	ld a,$ff		; $6db5
	ld (wDungeonIndex),a		; $6db7
++
	ld a,e			; $6dba
	swap a			; $6dbb
	and $07			; $6dbd
	ld (wActiveCollisions),a		; $6dbf

	ld b,$06		; $6dc2
	ld de,wTilesetUniqueGfx		; $6dc4
@copyloop:
	ldi a,(hl)		; $6dc7
	ld (de),a		; $6dc8
	inc e			; $6dc9
	dec b			; $6dca
	jr nz,@copyloop

	ld e,wTilesetUniqueGfx&$ff
	ld a,(de)		; $6dcf
	ld b,a			; $6dd0
	ldh a,(<hFF8B)	; $6dd1
	or b			; $6dd3
	ld (de),a		; $6dd4
	ret			; $6dd5

;;
; Returns the group to load the room layout from, accounting for bit 0 of the room flag
; which tells it to use the underwater group
;
; @param[out]	a,b	The corrected group number
; @addr{6dd6}
getAdjustedRoomGroup:
	ld a,(wActiveGroup)		; $6dd6
	ld b,a			; $6dd9
	cp $02			; $6dda
	ret nc			; $6ddc
	call getThisRoomFlags		; $6ddd
	rrca			; $6de0
	jr nc,+
	set 1,b			; $6de3
+
	ld a,b			; $6de5
	ret			; $6de6

;;
; Modifies hFF8D to indicate changes to a room (ie. jabu flooding)?
; @addr{6de7}
func_6de7:
	call @func_04_6e0d		; $6de7
	ret c			; $6dea

	call @checkJabuFlooded		; $6deb
	ret c			; $6dee

	ld a,(wActiveGroup)		; $6def
	or a			; $6df2
	jr nz,@xor		; $6df3

	ld a,(wLoadingRoomPack)		; $6df5
	cp $7f			; $6df8
	jr nz,@xor		; $6dfa

	ld a,(wAnimalCompanion)		; $6dfc
	sub SPECIALOBJECTID_RICKY			; $6dff
	jr z,@xor		; $6e01

	ld b,a			; $6e03
	ldh a,(<hFF8D)	; $6e04
	add b			; $6e06
	ldh (<hFF8D),a	; $6e07
	scf			; $6e09
	ret			; $6e0a
@xor:
	xor a			; $6e0b
	ret			; $6e0c

;;
; @addr{6e0d}
@func_04_6e0d:
	ld a,(wActiveGroup)		; $6e0d
	or a			; $6e10
	ret nz			; $6e11

	ld a,(wActiveRoom)		; $6e12
	cp $38			; $6e15
	jr nz,+			; $6e17

	ld a,($c848)		; $6e19
	and $01			; $6e1c
	ret z			; $6e1e

	ld hl,hFF8D		; $6e1f
	inc (hl)		; $6e22
	inc (hl)		; $6e23
	scf			; $6e24
	ret			; $6e25
+
	xor a			; $6e26
	ret			; $6e27

;;
; @param[out]	cflag	Set if the current room is flooded in jabu-jabu?
; @addr{6e28}
@checkJabuFlooded:
	ld a,(wDungeonIndex)		; $6e28
	cp $07			; $6e2b
	jr nz,++		; $6e2d

	ld a,(wTilesetFlags)		; $6e2f
	and TILESETFLAG_SIDESCROLL			; $6e32
	jr nz,++		; $6e34

	ld a,$11		; $6e36
	ld (wDungeonFirstLayout),a		; $6e38
	callab bank1.findActiveRoomInDungeonLayoutWithPointlessBankSwitch		; $6e3b
	ld a,(wJabuWaterLevel)		; $6e43
	and $07			; $6e46
	ld hl,@data		; $6e48
	rst_addAToHl			; $6e4b
	ld a,(wDungeonFloor)		; $6e4c
	ld bc,bitTable		; $6e4f
	add c			; $6e52
	ld c,a			; $6e53
	ld a,(bc)		; $6e54
	and (hl)		; $6e55
	ret z			; $6e56

	ldh a,(<hFF8D)	; $6e57
	inc a			; $6e59
	ldh (<hFF8D),a	; $6e5a
	scf			; $6e5c
	ret			; $6e5d
++
	xor a			; $6e5e
	ret			; $6e5f

; @addr{6e60}
@data:
	.db $00 $01 $03

;;
; Ages only: For tiles 0x40-0x7f, in the past, replace blue palettes (6) with red palettes (0). This
; is done so that tilesets can reuse attribute data for both the past and present tilesets.
;
; This is annoying so it's disabled in the hack-base branch, which separates all tileset data
; anyway.
;
; @addr{6e63}
setPastCliffPalettesToRed:
	ld a,(wActiveCollisions)		; $6e63
	or a			; $6e66
	jr nz,@done		; $6e68

	ld a,(wTilesetFlags)		; $6e6a
	and TILESETFLAG_PAST			; $6e6d
	jr z,@done		; $6e6e

	ld a,(wActiveRoom)		; $6e70
	cp <ROOM_AGES_138			; $6e73
	ret z			; $6e75

	; Replace all attributes that have palette "6" with palette "0"
	ld a,:w3TileMappingData		; $6e76
	ld ($ff00+R_SVBK),a	; $6e78
	ld hl,w3TileMappingData + $204		; $6e7a
	ld d,$06		; $6e7d
---
	ld b,$04		; $6e7f
--
	ld a,(hl)		; $6e81
	and $07			; $6e82
	cp d			; $6e84
	jr nz,+			; $6e85

	ld a,(hl)		; $6e87
	and $f8			; $6e88
	ld (hl),a		; $6e8a
+
	inc hl			; $6e8b
	dec b			; $6e8c
	jr nz,--		; $6e8d

	ld a,$04		; $6e8f
	rst_addAToHl			; $6e91
	ld a,h			; $6e92
	cp $d4			; $6e93
	jr c,---		; $6e95
@done:
	xor a			; $6e97
	ld ($ff00+R_SVBK),a	; $6e98
	ret			; $6e9a

;;
; @addr{6e9b}
func_04_6e9b:
	ld a,$02		; $6e9b
	ld ($ff00+R_SVBK),a	; $6e9d
	ld hl,wRoomLayout		; $6e9f
	ld de,$d000		; $6ea2
	ld b,$c0		; $6ea5
	call copyMemory		; $6ea7
	ld hl,wRoomCollisions		; $6eaa
	ld de,$d100		; $6ead
	ld b,$c0		; $6eb0
	call copyMemory		; $6eb2
	ld hl,$df00		; $6eb5
	ld de,$d200		; $6eb8
	ld b,$c0		; $6ebb
--
	ld a,$03		; $6ebd
	ld ($ff00+R_SVBK),a	; $6ebf
	ldi a,(hl)		; $6ec1
	ld c,a			; $6ec2
	ld a,$02		; $6ec3
	ld ($ff00+R_SVBK),a	; $6ec5
	ld a,c			; $6ec7
	ld (de),a		; $6ec8
	inc de			; $6ec9
	dec b			; $6eca
	jr nz,--		; $6ecb

	xor a			; $6ecd
	ld ($ff00+R_SVBK),a	; $6ece
	ret			; $6ed0

;;
; @addr{6ed1}
func_04_6ed1:
	ld a,$02		; $6ed1
	ld ($ff00+R_SVBK),a	; $6ed3
	ld hl,wRoomLayout		; $6ed5
	ld de,$d000		; $6ed8
	ld b,$c0		; $6edb
	call copyMemoryReverse		; $6edd
	ld hl,wRoomCollisions		; $6ee0
	ld de,$d100		; $6ee3
	ld b,$c0		; $6ee6
	call copyMemoryReverse		; $6ee8
	ld hl,$df00		; $6eeb
	ld de,$d200		; $6eee
	ld b,$c0		; $6ef1
--
	ld a,$02		; $6ef3
	ld ($ff00+R_SVBK),a	; $6ef5
	ld a,(de)		; $6ef7
	inc de			; $6ef8
	ld c,a			; $6ef9
	ld a,$03		; $6efa
	ld ($ff00+R_SVBK),a	; $6efc
	ld a,c			; $6efe
	ldi (hl),a		; $6eff
	dec b			; $6f00
	jr nz,--		; $6f01

	xor a			; $6f03
	ld ($ff00+R_SVBK),a	; $6f04
	ret			; $6f06

;;
; @addr{6f07}
func_04_6f07:
	ld hl,$d800		; $6f07
	ld de,$dc00		; $6f0a
	ld bc,$0200		; $6f0d
	call @locFunc		; $6f10
	ld hl,$dc00		; $6f13
	ld de,$de00		; $6f16
	ld bc,$0200		; $6f19
@locFunc:
	ld a,$03		; $6f1c
	ld ($ff00+R_SVBK),a	; $6f1e
	ldi a,(hl)		; $6f20
	ldh (<hFF8B),a	; $6f21
	ld a,$06		; $6f23
	ld ($ff00+R_SVBK),a	; $6f25
	ldh a,(<hFF8B)	; $6f27
	ld (de),a		; $6f29
	inc de			; $6f2a
	dec bc			; $6f2b
	ld a,b			; $6f2c
	or c			; $6f2d
	jr nz,@locFunc		; $6f2e
	ret			; $6f30

;;
; @addr{6f31}
func_04_6f31:
	ld hl,$dc00		; $6f31
	ld de,$d800		; $6f34
	ld bc,$0200		; $6f37
	call @locFunc		; $6f3a
	ld hl,$de00		; $6f3d
	ld de,$dc00		; $6f40
	ld bc,$0200		; $6f43
@locFunc:
	ld a,$06		; $6f46
	ld ($ff00+R_SVBK),a	; $6f48
	ldi a,(hl)		; $6f4a
	ldh (<hFF8B),a	; $6f4b
	ld a,$03		; $6f4d
	ld ($ff00+R_SVBK),a	; $6f4f
	ldh a,(<hFF8B)	; $6f51
	ld (de),a		; $6f53
	inc de			; $6f54
	dec bc			; $6f55
	ld a,b			; $6f56
	or c			; $6f57
	jr nz,@locFunc	; $6f58
	ret			; $6f5a

; .ORGA $6f5b

	.include "build/data/warpData.s"

	.include "code/ages/garbage/bank04End.s"


.BANK $05 SLOT 1
.ORG 0

 m_section_force "Bank_5" NAMESPACE bank5

	.include "code/bank5.s"
	.include "build/data/tileTypeMappings.s"
	.include "build/data/cliffTilesTable.s"

	.include "code/ages/garbage/bank05End.s"

.ends


.BANK $06 SLOT 1
.ORG 0


 m_section_superfree "Bank_6" NAMESPACE bank6

	.include "code/interactableTiles.s"
	.include "code/specialObjectAnimationsAndDamage.s"
	.include "code/breakableTiles.s"

	.include "code/items/parentItemUsage.s"

	.include "code/items/shieldParent.s"
	.include "code/items/otherSwordsParent.s"
	.include "code/items/switchHookParent.s"
	.include "code/items/caneOfSomariaParent.s"
	.include "code/items/swordParent.s"
	.include "code/items/harpFluteParent.s"
	.include "code/items/seedsParent.s"
	.include "code/items/shovelParent.s"
	.include "code/items/boomerangParent.s"
	.include "code/items/bombsBraceletParent.s"
	.include "code/items/featherParent.s"
	.include "code/items/magnetGloveParent.s"

	.include "code/items/parentItemCommon.s"


; Following table affects how an item can be used (ie. how it interacts with other items
; being used).
;
; Data format:
;  b0: bits 4-7: Priority (higher value = higher precedence)
;                Gets written to high nibble of Item.enabled
;      bits 0-3: Determines what "parent item" slot to use when the button is pressed.
;                0: Item is unusable.
;                1: Uses w1ParentItem3 or 4.
;                2: Uses w1ParentItem3 or 4, but only one instance of the item may exist
;                   at once. (boomerang, seed satchel)
;                3: Uses w1ParentItem2. If an object is already there, it gets
;                   overwritten if this object's priority is high enough.
;                   (sword, cane, bombs, etc)
;                4: Same as 2, but the item can't be used if w1ParentItem2 is in use (Link
;                   is holding a sword or something)
;                5: Uses w1ParentItem5 (only if not already in use). (shield, flute, harp)
;                6-7: invalid
;  b1: Byte to check input against when the item is first used
;
; @addr{55be}
_itemUsageParameterTable:
	.db $00 <wGameKeysPressed	; ITEMID_NONE
	.db $05 <wGameKeysPressed	; ITEMID_SHIELD
	.db $03 <wGameKeysJustPressed	; ITEMID_PUNCH
	.db $23 <wGameKeysJustPressed	; ITEMID_BOMB
	.db $03 <wGameKeysJustPressed	; ITEMID_CANE_OF_SOMARIA
	.db $63 <wGameKeysJustPressed	; ITEMID_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOOMERANG
	.db $00 <wGameKeysJustPressed	; ITEMID_ROD_OF_SEASONS
	.db $00 <wGameKeysJustPressed	; ITEMID_MAGNET_GLOVES
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_HELPER
	.db $73 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_CHAIN
	.db $73 <wGameKeysJustPressed	; ITEMID_BIGGORON_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOMBCHUS
	.db $05 <wGameKeysJustPressed	; ITEMID_FLUTE
	.db $43 <wGameKeysJustPressed	; ITEMID_SHOOTER
	.db $00 <wGameKeysJustPressed	; ITEMID_10
	.db $05 <wGameKeysJustPressed	; ITEMID_HARP
	.db $00 <wGameKeysJustPressed	; ITEMID_12
	.db $00 <wGameKeysJustPressed	; ITEMID_SLINGSHOT
	.db $00 <wGameKeysJustPressed	; ITEMID_14
	.db $13 <wGameKeysJustPressed	; ITEMID_SHOVEL
	.db $13 <wGameKeysPressed	; ITEMID_BRACELET
	.db $01 <wGameKeysJustPressed	; ITEMID_FEATHER
	.db $00 <wGameKeysJustPressed	; ITEMID_18
	.db $02 <wGameKeysJustPressed	; ITEMID_SEED_SATCHEL
	.db $00 <wGameKeysJustPressed	; ITEMID_DUST
	.db $00 <wGameKeysJustPressed	; ITEMID_1b
	.db $00 <wGameKeysJustPressed	; ITEMID_1c
	.db $00 <wGameKeysJustPressed	; ITEMID_MINECART_COLLISION
	.db $00 <wGameKeysJustPressed	; ITEMID_FOOLS_ORE
	.db $00 <wGameKeysJustPressed	; ITEMID_1f



; Data format:
;  b0: bit 7:    If set, the corresponding bit in wLinkUsingItem1 will be set.
;      bits 4-6: Value for bits 0-2 of Item.var3f
;      bits 0-3: Determines parent item's relatedObj2?
;                A value of $6 refers to w1WeaponItem.
;  b1: Animation to set Link to? (see constants/linkAnimations.s)
;
; @addr{55fe}
_linkItemAnimationTable:
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_NONE
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_SHIELD
	.db $d6  LINK_ANIM_MODE_21	; ITEMID_PUNCH
	.db $30  LINK_ANIM_MODE_LIFT	; ITEMID_BOMB
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_CANE_OF_SOMARIA
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_SWORD
	.db $b0  LINK_ANIM_MODE_21	; ITEMID_BOOMERANG
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_ROD_OF_SEASONS
	.db $60  LINK_ANIM_MODE_NONE	; ITEMID_MAGNET_GLOVES
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_HELPER
	.db $f6  LINK_ANIM_MODE_21	; ITEMID_SWITCH_HOOK
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_CHAIN
	.db $f6  LINK_ANIM_MODE_23	; ITEMID_BIGGORON_SWORD
	.db $30  LINK_ANIM_MODE_21	; ITEMID_BOMBCHUS
	.db $70  LINK_ANIM_MODE_FLUTE	; ITEMID_FLUTE
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SHOOTER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_10
	.db $70  LINK_ANIM_MODE_HARP_2	; ITEMID_HARP
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_12
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SLINGSHOT
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_14
	.db $b0  LINK_ANIM_MODE_DIG_2	; ITEMID_SHOVEL
	.db $40  LINK_ANIM_MODE_LIFT_3	; ITEMID_BRACELET
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_FEATHER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_18
	.db $a0  LINK_ANIM_MODE_21	; ITEMID_SEED_SATCHEL
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_DUST
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1b
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1c
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_MINECART_COLLISION
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_FOOLS_ORE
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1f

	.include "object_code/common/specialObjects/minecart.s"
	.include "object_code/common/specialObjects/raft.s"

	.include "build/data/specialObjectAnimationData.s"
	.include "code/ages/cutscenes/companionCutscenes.s"
	.include "code/ages/cutscenes/linkCutscenes.s"
	.include "build/data/signText.s"
	.include "build/data/breakableTileCollisionTable.s"

;;
; @addr{79dc}
specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible		; $79dc
	bit 7,(hl)		; $79df
	ret z			; $79e1

	ld l,<w1Companion.var32		; $79e2
	ld a,(hl)		; $79e4
	call _getSpecialObjectGraphicsFrame		; $79e5
	ret z			; $79e8

	ld a,l			; $79e9
	and $f0			; $79ea
	ld l,a			; $79ec
	ld de,w6SpecialObjectGfxBuffer|(:w6SpecialObjectGfxBuffer)		; $79ed
	jp copy256BytesFromBank		; $79f0


	.include "code/ages/garbage/bank06End.s"

.ends

.BANK $07 SLOT 1
.ORG 0

.include "code/fileManagement.s"

 ; This section can't be superfree, since it must be in the same bank as section
 ; "Bank_7_Data".
 m_section_free "Enemy_Part_Collisions" namespace "bank7"
	.include "code/collisionEffects.s"
.ends


 m_section_superfree "Item_Code" namespace "itemCode"
.include "code/updateItems.s"

	.include "build/data/itemConveyorTilesTable.s"
	.include "build/data/itemPassableCliffTilesTable.s"
	.include "build/data/itemPassableTilesTable.s"
	.include "code/itemCodes.s"
	.include "build/data/itemAttributes.s"
	.include "data/itemAnimations.s"
.ends


 ; This section can't be superfree, since it must be in the same bank as section
 ; "Enemy_Part_Collisions".
 m_section_free "Bank_7_Data" namespace "bank7"

	.include "build/data/enemyActiveCollisions.s"
	.include "build/data/partActiveCollisions.s"
	.include "build/data/objectCollisionTable.s"

	.include "code/ages/garbage/bank07End.s"

.ends


.BANK $08 SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank08 NAMESPACE interactionBank08

	.include "object_code/common/interactionCode/group1.s"
	.include "object_code/ages/interactionCode/bank08.s"

.ends


.BANK $09 SLOT 1
.ORG 0

 m_section_force Interaction_Code_Bank09 NAMESPACE interactionBank09

	.include "object_code/common/interactionCode/group2.s"
        .include "object_code/common/interactionCode/treasure.s"
	.include "object_code/ages/interactionCode/bank09.s"

.ends


.BANK $0a SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank0a NAMESPACE interactionBank0a

	.include "object_code/common/interactionCode/group3.s"
        .include "object_code/common/interactionCode/group5.s"
	.include "object_code/ages/interactionCode/bank0a.s"

.ends


.BANK $0b SLOT 1
.ORG 0


 m_section_force Interaction_Code_Bank0b NAMESPACE interactionBank0b

	.include "object_code/common/interactionCode/group6.s"
        .include "object_code/common/interactionCode/group7.s"
        .include "object_code/common/interactionCode/group4.s"
	.include "object_code/ages/interactionCode/bank0b.s"

	.include "code/ages/garbage/bank0bEnd.s"

.ends


.BANK $0c SLOT 1
.ORG 0

	.include "code/scripting.s"
	.include "scripts/ages/scripts.s"


.BANK $0d SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

	.include "code/enemyCommon.s"
	.include "object_code/common/enemyCode/group1.s"
	.include "object_code/ages/enemyCode/bank0d.s"

.ends

 m_section_superfree Enemy_Animations
	.include "build/data/enemyAnimations.s"
.ends


.BANK $0e SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

	.include "code/enemyCommon.s"
	.include "object_code/common/enemyCode/group2.s"

        .include "build/data/orbMovementScript.s"
        .include "code/objectMovementScript.s"

	.include "object_code/ages/enemyCode/bank0e.s"
	.include "build/data/movingSidescrollPlatform.s"

	.include "code/ages/garbage/bank0eEnd.s"

.ends

.BANK $0f SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "object_code/ages/enemyCode/bank0f.s"

.ends

.BANK $10 SLOT 1
.ORG 0

 m_section_free Enemy_Code_Bank10 NAMESPACE bank10

	.include "code/enemyCommon.s"
	.include "code/enemyBossCommon.s"
	.include "object_code/common/enemyCode/group3.s"
	.include "object_code/ages/enemyCode/bank10.s"

.ends


; Some blank space here ($6e1f-$6eff)

.ORGA $6f00

 m_section_force Interaction_Code_Bank10 NAMESPACE interactionBank10

	.include "object_code/common/interactionCode/group8.s"
	.include "object_code/ages/interactionCode/bank10.s"

.ends


.BANK $11 SLOT 1
.ORG 0

	.define PART_BANK $11
	.export PART_BANK

 m_section_force "Bank_11" NAMESPACE "partCode"

	.include "code/partCommon.s"
	.include "object_code/common/partCode.s"
        .include "data/partCodeTable.s"
	.include "object_code/ages/partCode.s"
	.include "code/ages/garbage/bank11End.s"

.ends


.BANK $12 SLOT 1
.ORG 0

	.include "code/objectLoading.s"

 m_section_superfree "Room_Code" namespace "roomSpecificCode"

	.include "code/ages/roomSpecificCode.s"

.ends

 m_section_free "Objects_2" namespace "objectData"

	.include "objects/ages/mainData.s"
	.include "objects/ages/extraData3.s"

.ends

 m_section_superfree "Underwater Surface Data"

	.include "code/ages/underwaterSurface.s"

.ENDS

 m_section_free "Objects_3" namespace "objectData"

	.include "objects/ages/extraData4.s"

.ends


.BANK $13 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $13
	.export BASE_OAM_DATA_BANK

	.include "build/data/specialObjectOamData.s"
	.include "data/itemOamData.s"
	.include "build/data/enemyOamData.s"

.BANK $14 SLOT 1
.ORG 0

 m_section_superfree "Terrain_Effects" NAMESPACE "terrainEffects"
	.include "data/terrainEffects.s"
.ends

.include "build/data/interactionOamData.s"
.include "build/data/partOamData.s"


.BANK $15 SLOT 1
.ORG 0

.include "scripts/common/scriptHelper.s"

 m_section_free "Object_Pointers" namespace "objectData"

;;
; @addr{4315}
getObjectDataAddress:
	ld a,(wActiveGroup)		; $4315
	ld hl,objectDataGroupTable
	rst_addDoubleIndex			; $431b
	ldi a,(hl)		; $431c
	ld h,(hl)		; $431d
	ld l,a			; $431e
	ld a,(wActiveRoom)		; $431f
	ld e,a			; $4322
	ld d,$00		; $4323
	add hl,de		; $4325
	add hl,de		; $4326
	ldi a,(hl)		; $4327
	ld d,(hl)		; $4328
	ld e,a			; $4329
	ret			; $432a


	.include "objects/ages/pointers.s"

.ENDS

.include "scripts/ages/scriptHelper.s"


.BANK $16 SLOT 1
.ORG 0

.include "code/serialFunctions.s"

 m_section_force Bank16 NAMESPACE bank16

;;
; @param	d	Interaction index (should be of type INTERACID_TREASURE)
; @addr{451e}
interactionLoadTreasureData:
	ld e,Interaction.subid	; $451e
	ld a,(de)		; $4520
	ld e,Interaction.var30		; $4521
	ld (de),a		; $4523
	ld hl,treasureObjectData		; $4524
--
	call multiplyABy4		; $4527
	add hl,bc		; $452a
	bit 7,(hl)		; $452b
	jr z,+			; $452d

	inc hl			; $452f
	ldi a,(hl)		; $4530
	ld h,(hl)		; $4531
	ld l,a			; $4532
	ld e,Interaction.var03		; $4533
	ld a,(de)		; $4535
	jr --			; $4536
+
	; var31 = spawn mode
	ldi a,(hl)		; $4538
	ld b,a			; $4539
	swap a			; $453a
	and $07			; $453c
	ld e,Interaction.var31		; $453e
	ld (de),a		; $4540

	; var32 = collect mode
	ld a,b			; $4541
	and $07			; $4542
	inc e			; $4544
	ld (de),a		; $4545

	; var33 = ?
	ld a,b			; $4546
	and $08			; $4547
	inc e			; $4549
	ld (de),a		; $454a

	; var34 = parameter (value of 'c' for "giveTreasure")
	ldi a,(hl)		; $454b
	inc e			; $454c
	ld (de),a		; $454d

	; var35 = low text ID
	ldi a,(hl)		; $454e
	inc e			; $454f
	ld (de),a		; $4550

	; subid = graphics to use
	ldi a,(hl)		; $4551
	ld e,Interaction.subid		; $4552
	ld (de),a		; $4554
	ret			; $4555


.include "build/data/data_4556.s"
.include "build/data/endgameCutsceneOamData.s"

.ends


.include "code/staticObjects.s"
.include "build/data/staticDungeonObjects.s"
.include "build/data/chestData.s"

 m_section_force Bank16_2 NAMESPACE bank16

.include "build/data/treasureObjectData.s"

;;
; Used in the room in present Mermaid's Cave with the changing floor
;
; @param	b	Floor state (0/1)
; @addr{5766}
loadD6ChangingFloorPatternToBigBuffer:
	ld a,b			; $5766
	add a			; $5767
	ld hl,@changingFloorData		; $5768
	rst_addDoubleIndex			; $576b
	push hl			; $576c
	ldi a,(hl)		; $576d
	ld d,(hl)		; $576e
	ld e,a			; $576f
	ld b,$41		; $5770
	ld hl,wBigBuffer		; $5772
	call copyMemoryReverse		; $5775

	pop hl			; $5778
	inc hl			; $5779
	inc hl			; $577a
	ldi a,(hl)		; $577b
	ld d,(hl)		; $577c
	ld e,a			; $577d
	ld b,$41		; $577e
	ld hl,wBigBuffer+$80		; $5780
	call copyMemoryReverse		; $5783

	ldh a,(<hActiveObject)	; $5786
	ld d,a			; $5788
	ret			; $5789

@changingFloorData:
	.dw @tiles0_bottomHalf
	.dw @tiles0_topHalf

	.dw @tiles1
	.dw @tiles1

@tiles0_bottomHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles0_topHalf:
	.db $a0 $a0 $a0 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $ff
	.db $a0 $a0 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $ff
	.db $f4 $f4 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $f4 $f4 $f4 $f4
	.db $00

@tiles1:
	.db $a0 $a0 $f4 $1d $a0 $1d $f4 $f4 $f4 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $f4 $f4 $a0 $a0 $ff
	.db $a0 $a0 $a0 $f4 $f4 $f4 $f4 $f4 $a0 $ff
	.db $a0 $f4 $f4 $f4 $f4 $a0 $a0 $a0 $a0 $ff
	.db $a0 $a0 $a0 $a0 $a0 $a0 $f4 $f4 $a0 $ff
	.db $a0 $a0 $f4 $a0
	.db $00

.ends

.include "build/data/interactionAnimations.s"
.include "build/data/partAnimations.s"

.BANK $17 SLOT 1 ; Seasons: should be bank $16
.ORG 0

	.include "build/data/paletteData.s"
	.include "build/data/tilesetCollisions.s"
	.include "build/data/smallRoomLayoutTables.s"

.ifdef ROM_AGES
	.include "code/ages/garbage/bank17End.s"
.endif

.BANK $18 SLOT 1 ; Seasons: should be bank $17
.ORG 0

 m_section_superfree Tile_Mappings

	tileMappingIndexDataPointer:
		.dw tileMappingIndexData
	tileMappingAttributeDataPointer:
		.dw tileMappingAttributeData

	tileMappingTable:
		.incbin "build/tileset_layouts/tileMappingTable.bin"
	tileMappingIndexData:
		.incbin "build/tileset_layouts/tileMappingIndexData.bin"
	tileMappingAttributeData:
		.incbin "build/tileset_layouts/tileMappingAttributeData.bin"

.ifdef ROM_AGES
	.include "code/ages/garbage/bank18End.s"
.endif

.ends


.BANK $19 SLOT 1
.ORG 0

 m_section_superfree "Gfx_19_1" ALIGN $10
	.include "data/ages/gfxDataBank19_1.s"
.ends

 m_section_superfree "Tile_mappings"
	.include "build/data/tilesetMappings.s"
.ends

 m_section_superfree "Gfx_19_2" ALIGN $10
	.include "data/ages/gfxDataBank19_2.s"
.ends


.BANK $1a SLOT 1
.ORG 0


 m_section_free "Gfx_1a" ALIGN $20
	.include "data/gfxDataBank1a.s"
.ends


.BANK $1b SLOT 1
.ORG 0

 m_section_free "Gfx_1b" ALIGN $20
	.include "data/gfxDataBank1b.s"
.ends


.BANK $1c SLOT 1
.ORG 0

	; The first $e characters of gfx_font are blank, so they aren't
	; included in the rom. In order to get the offsets correct, use
	; gfx_font_start as the label instead of gfx_font.

	.define gfx_font_start gfx_font-$e0
	.export gfx_font_start

	m_GfxDataSimple gfx_font_jp ; $70000
	m_GfxDataSimple gfx_font_tradeitems ; $70600
	m_GfxDataSimple gfx_font $e0 ; $70800
	m_GfxDataSimple gfx_font_heartpiece ; $71720

	m_GfxDataSimple map_rings ; $717a0

	.include "build/data/largeRoomLayoutTables.s" ; $719c0

.ifdef ROM_AGES
	.include "code/ages/garbage/bank1cEnd.s"
.endif

; "build/textData.s" will determine where this data starts.
;   Ages:    1d:4000
;   Seasons: 1c:5c00

	.include "build/textData.s"

	.REDEFINE DATA_ADDR TEXT_END_ADDR
	.REDEFINE DATA_BANK TEXT_END_BANK

	.include "build/data/roomLayoutData.s"
	.include "build/data/gfxDataMain.s"



.BANK $3f SLOT 1
.ORG 0

 m_section_force Bank3f NAMESPACE bank3f

.define BANK_3f $3f

.include "code/loadGraphics.s"
.include "code/treasureAndDrops.s"
.include "code/textbox.s"

; @addr{5951}
data_5951:
	.db $3c $b4 $3c $50 $78 $b4 $3c $3c
	.db $3c $70 $78 $78

.ifdef ROM_AGES

; In Seasons these sprites are located elsewhere

titlescreenMakuSeedSprite:
	.db $13
	.db $48 $90 $62 $06
	.db $42 $8e $68 $06
	.db $51 $7a $56 $04
	.db $50 $82 $74 $04
	.db $58 $7a $6a $07
	.db $58 $82 $6c $07
	.db $58 $8a $6e $07
	.db $54 $8a $54 $03
	.db $54 $82 $52 $03
	.db $54 $7a $50 $03
	.db $64 $7a $70 $03
	.db $64 $82 $72 $03
	.db $64 $8a $70 $23
	.db $40 $86 $66 $06
	.db $40 $7f $64 $06
	.db $41 $70 $60 $06
	.db $55 $76 $5a $06
	.db $44 $68 $5e $26
	.db $74 $00 $46 $02

titlescreenPressStartSprites:
	.db $0a
	.db $80 $2c $38 $00
	.db $80 $34 $3a $00
	.db $80 $3c $3c $00
	.db $80 $44 $3e $00
	.db $80 $4c $3e $00
	.db $80 $5c $3e $00
	.db $80 $64 $40 $00
	.db $80 $6c $42 $00
	.db $80 $74 $3a $00
	.db $80 $7c $40 $00

; Sprites used on the closeup shot of Link on the horse in the intro
linkOnHorseCloseupSprites_2:
	.db $26
	.db $80 $80 $40 $06
	.db $80 $50 $42 $00
	.db $80 $58 $44 $00
	.db $68 $40 $46 $06
	.db $b8 $3d $20 $02
	.db $b8 $45 $22 $02
	.db $b8 $4d $24 $02
	.db $b8 $55 $26 $02
	.db $b8 $5d $28 $02
	.db $90 $28 $2c $02
	.db $90 $30 $2e $02
	.db $80 $30 $2a $02
	.db $20 $78 $48 $05
	.db $58 $68 $00 $02
	.db $58 $70 $02 $02
	.db $68 $68 $04 $02
	.db $48 $70 $06 $02
	.db $5a $40 $08 $01
	.db $5a $48 $0a $01
	.db $5a $50 $0c $01
	.db $38 $88 $0e $04
	.db $30 $78 $10 $04
	.db $30 $80 $12 $04
	.db $40 $80 $14 $04
	.db $50 $76 $16 $04
	.db $50 $7e $18 $04
	.db $41 $62 $1a $03
	.db $80 $28 $1c $02
	.db $a8 $59 $1e $02
	.db $98 $20 $30 $02
	.db $98 $28 $32 $02
	.db $8c $38 $34 $07
	.db $a8 $41 $36 $02
	.db $a8 $49 $38 $02
	.db $a8 $51 $3a $02
	.db $90 $40 $3e $07
	.db $8a $5c $4a $00
	.db $8a $64 $4c $00

; Sprites used to touch up the appearance of the temple in the intro (the scene where
; Link's on a cliff with his horse)
introTempleSprites:
	.db $05
	.db $30 $28 $48 $02
	.db $30 $30 $4a $02
	.db $18 $38 $4c $03
	.db $10 $40 $4e $03
	.db $18 $48 $50 $03


; Used in intro (ages only)
linkOnHorseFacingCameraSprite:
	.db $02
	.db $70 $08 $58 $02
	.db $70 $10 $5a $02

.endif ; ROM_AGES


.include "build/data/objectGfxHeaders.s"
.include "build/data/treeGfxHeaders.s"

.include "build/data/enemyData.s"
.include "build/data/partData.s"
.include "build/data/itemData.s"
.include "build/data/interactionData.s"

.include "build/data/treasureCollectionBehaviours.s"
.include "build/data/treasureDisplayData.s"

; @addr{714c}
oamData_714c:
	.db $10
	.db $c8 $38 $2e $0e
	.db $c8 $40 $30 $0e
	.db $c8 $48 $32 $0e
	.db $c8 $60 $34 $0f
	.db $c8 $68 $36 $0f
	.db $c8 $70 $38 $0f
	.db $d8 $78 $06 $2e
	.db $e8 $80 $00 $0d
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $e8 $30 $04 $0e
	.db $d8 $30 $06 $0e
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d

; @addr{718d}
oamData_718d:
	.db $10
	.db $a8 $38 $12 $0a
	.db $b8 $38 $0e $0f
	.db $c8 $38 $0a $0f
	.db $a8 $70 $14 $0a
	.db $b8 $70 $10 $0a
	.db $c8 $70 $0c $0f
	.db $e8 $80 $00 $0d
	.db $d8 $78 $06 $2e
	.db $e8 $78 $08 $0e
	.db $e0 $90 $00 $0d
	.db $d8 $a0 $00 $0d
	.db $f8 $28 $02 $0e
	.db $f0 $18 $00 $2d
	.db $e8 $08 $00 $2d
	.db $d8 $30 $06 $0e
	.db $e8 $30 $08 $2e

; @addr{71ce}
oamData_71ce:
	.db $0a
	.db $50 $40 $40 $0b
	.db $50 $48 $42 $0b
	.db $50 $50 $44 $0b
	.db $50 $58 $46 $0b
	.db $50 $60 $48 $0b
	.db $50 $68 $4a $0b
	.db $70 $70 $3c $0c
	.db $60 $70 $3e $2c
	.db $70 $38 $3a $0c
	.db $60 $38 $3e $0c

; @addr{71f7}
oamData_71f7:
	.db $0a
	.db $10 $40 $22 $08
	.db $10 $68 $22 $28
	.db $60 $38 $16 $0c
	.db $70 $38 $1a $0c
	.db $60 $70 $18 $0c
	.db $70 $70 $1a $2c
	.db $40 $40 $1c $08
	.db $40 $68 $1e $08
	.db $50 $40 $20 $08
	.db $50 $68 $20 $28

; @addr{7220}
oamData_7220:
	.db $0a
	.db $e0 $48 $24 $0b
	.db $e0 $60 $24 $2b
	.db $e0 $50 $26 $0b
	.db $e0 $58 $26 $2b
	.db $f0 $48 $28 $0b
	.db $f0 $60 $28 $2b
	.db $00 $48 $2a $0b
	.db $00 $60 $2a $2b
	.db $f8 $50 $2c $0b
	.db $f8 $58 $2c $2b

; @addr{7249}
oamData_7249:
	.db $27
	.db $38 $38 $00 $01
	.db $38 $58 $02 $00
	.db $30 $48 $04 $00
	.db $30 $50 $06 $00
	.db $40 $48 $08 $00
	.db $58 $38 $0a $00
	.db $50 $40 $0c $02
	.db $50 $48 $0e $04
	.db $58 $50 $10 $03
	.db $60 $57 $12 $03
	.db $60 $5f $14 $03
	.db $60 $30 $16 $00
	.db $72 $38 $18 $00
	.db $70 $30 $1a $03
	.db $88 $28 $1c $00
	.db $3b $9a $1e $04
	.db $4b $9a $20 $04
	.db $58 $90 $22 $05
	.db $58 $98 $24 $05
	.db $22 $a0 $26 $06
	.db $22 $a8 $28 $06
	.db $32 $a0 $2a $06
	.db $32 $a8 $2c $06
	.db $12 $a0 $2e $06
	.db $12 $a8 $30 $06
	.db $12 $b0 $32 $06
	.db $6c $b0 $34 $03
	.db $70 $c0 $36 $01
	.db $80 $c0 $38 $05
	.db $90 $58 $3a $03
	.db $30 $90 $3c $00
	.db $90 $c0 $3e $05
	.db $90 $78 $40 $05
	.db $80 $70 $42 $05
	.db $80 $78 $44 $05
	.db $80 $88 $46 $05
	.db $90 $80 $48 $05
	.db $48 $50 $4a $02
	.db $60 $40 $4c $00


.include "object_code/ages/interactionCode/bank3f.s"

.include "code/ages/garbage/bank3fEnd.s"

.ends
