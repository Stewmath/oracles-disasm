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
	.db $00, <wGameKeysPressed      ; ITEM_NONE
	.db $05, <wGameKeysPressed      ; ITEM_SHIELD
	.db $03, <wGameKeysJustPressed  ; ITEM_PUNCH
	.db $23, <wGameKeysJustPressed  ; ITEM_BOMB
	.db $03, <wGameKeysJustPressed  ; ITEM_CANE_OF_SOMARIA
	.db $63, <wGameKeysJustPressed  ; ITEM_SWORD
	.db $02, <wGameKeysJustPressed  ; ITEM_BOOMERANG
	.db $00, <wGameKeysJustPressed  ; ITEM_ROD_OF_SEASONS
	.db $00, <wGameKeysJustPressed  ; ITEM_MAGNET_GLOVES
	.db $00, <wGameKeysJustPressed  ; ITEM_SWITCH_HOOK_HELPER
	.db $73, <wGameKeysJustPressed  ; ITEM_SWITCH_HOOK
	.db $00, <wGameKeysJustPressed  ; ITEM_SWITCH_HOOK_CHAIN
	.db $73, <wGameKeysJustPressed  ; ITEM_BIGGORON_SWORD
	.db $02, <wGameKeysJustPressed  ; ITEM_BOMBCHUS
	.db $05, <wGameKeysJustPressed  ; ITEM_FLUTE
	.db $43, <wGameKeysJustPressed  ; ITEM_SHOOTER
	.db $00, <wGameKeysJustPressed  ; ITEM_10
	.db $05, <wGameKeysJustPressed  ; ITEM_HARP
	.db $00, <wGameKeysJustPressed  ; ITEM_12
	.db $00, <wGameKeysJustPressed  ; ITEM_SLINGSHOT
	.db $00, <wGameKeysJustPressed  ; ITEM_14
	.db $13, <wGameKeysJustPressed  ; ITEM_SHOVEL
	.db $13, <wGameKeysPressed      ; ITEM_BRACELET
	.db $01, <wGameKeysJustPressed  ; ITEM_FEATHER
	.db $00, <wGameKeysJustPressed  ; ITEM_18
	.db $02, <wGameKeysJustPressed  ; ITEM_SEED_SATCHEL
	.db $00, <wGameKeysJustPressed  ; ITEM_DUST
	.db $00, <wGameKeysJustPressed  ; ITEM_1b
	.db $00, <wGameKeysJustPressed  ; ITEM_1c
	.db $00, <wGameKeysJustPressed  ; ITEM_MINECART_COLLISION
	.db $00, <wGameKeysJustPressed  ; ITEM_FOOLS_ORE
	.db $00, <wGameKeysJustPressed  ; ITEM_1f



; Data format:
;  b0: bit 7:    If set, the corresponding bit in wLinkUsingItem1 will be set.
;      bits 4-6: Value for bits 0-2 of Item.var3f
;      bits 0-3: Determines parent item's relatedObj2?
;                A value of $6 refers to w1WeaponItem.
;  b1: Animation to set Link to? (see constants/common/linkAnimations.s)
;
linkItemAnimationTable:
	.db $00, LINK_ANIM_MODE_NONE    ; ITEM_NONE
	.db $00, LINK_ANIM_MODE_NONE    ; ITEM_SHIELD
	.db $d6, LINK_ANIM_MODE_21      ; ITEM_PUNCH
	.db $30, LINK_ANIM_MODE_LIFT    ; ITEM_BOMB
	.db $d6, LINK_ANIM_MODE_22      ; ITEM_CANE_OF_SOMARIA
	.db $e6, LINK_ANIM_MODE_22      ; ITEM_SWORD
	.db $b0, LINK_ANIM_MODE_21      ; ITEM_BOOMERANG
	.db $d6, LINK_ANIM_MODE_22      ; ITEM_ROD_OF_SEASONS
	.db $60, LINK_ANIM_MODE_NONE    ; ITEM_MAGNET_GLOVES
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_SWITCH_HOOK_HELPER
	.db $f6, LINK_ANIM_MODE_21      ; ITEM_SWITCH_HOOK
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_SWITCH_HOOK_CHAIN
	.db $f6, LINK_ANIM_MODE_23      ; ITEM_BIGGORON_SWORD
	.db $30, LINK_ANIM_MODE_21      ; ITEM_BOMBCHUS
	.db $70, LINK_ANIM_MODE_FLUTE   ; ITEM_FLUTE
	.db $c6, LINK_ANIM_MODE_21      ; ITEM_SHOOTER
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_10
	.db $70, LINK_ANIM_MODE_HARP_2  ; ITEM_HARP
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_12
	.db $c6, LINK_ANIM_MODE_21      ; ITEM_SLINGSHOT
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_14
	.db $b0, LINK_ANIM_MODE_DIG_2   ; ITEM_SHOVEL
	.db $40, LINK_ANIM_MODE_LIFT_3  ; ITEM_BRACELET
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_FEATHER
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_18
	.db $a0, LINK_ANIM_MODE_21      ; ITEM_SEED_SATCHEL
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_DUST
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_1b
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_1c
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_MINECART_COLLISION
	.db $e6, LINK_ANIM_MODE_22      ; ITEM_FOOLS_ORE
	.db $80, LINK_ANIM_MODE_NONE    ; ITEM_1f
