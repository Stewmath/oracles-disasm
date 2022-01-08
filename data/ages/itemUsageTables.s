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
itemUsageParameterTable:
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
linkItemAnimationTable:
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
