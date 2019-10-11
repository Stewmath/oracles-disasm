; The table below outlines what should happen when Link obtains an item (ie. whether to
; add ammo to an item, increase an item's level, etc...)
;
; See the "applyParameter" subfunction of "giveTreasure_body" for where this is processed.
;
; Data format:
; b0: Low byte of an address in the C6XX block to do something with
; b1: bit 7:    Set if no sound effect should be played (b2 should be ignored)
;     bits 0-3: What to do when Link gets the item (ie. add to a quantity, set a weapon's
;               level, etc). Here are the values:
;               0: Do nothing extra.
;               1: Set bit [param] in [b0]. (Essence)
;               2: Increment [b0]. (Shovel, satchel, heart piece)
;               3: Increment [b0] as a BCD number. (Slate)
;               4: Add [param] to [b0] as a BCD number. (Bombchus, gasha seeds)
;               5: Set [b0] to [param]. (Harp, trade item)
;               6: Set bit [wDungeonIndex] in [b0]. (Boss key, map, compass)
;               7: Increment [b0+[wDungeonIndex]] and refresh the small key count.
;               8: Set [b0] to [param] if [b0]<[param]; update A/B buttons. (Shield,flute)
;               9: Add [param] to the unappraised ring list.
;               a: Add [param] to [b0]. (Heart container)
;               b: Set bit [param] in [$cca8]. (0x60-0x67)
;               c: Add [param] to [b0], using [b0+1] as a cap. (Health refill)
;                  Also plays the sound effect for regaining hearts if b0 == wLinkHealth.
;               d: Add [param] to [b0] as BCD, using [b0+1] as a cap. (Bombs)
;               e: Add rupee value [param] to 2-byte bcd value [b0].
;                  Also adds the value to wTotalRupeesCollected if b0 == wNumRupees.
;                  Note: [param] is not the amount of rupees that will be added; instead,
;                  [param] is passed to the "getRupeeValue" function, which returns the
;                  actual amount.
;               f: Add [param] to [b0] as a BCD number, check wSeedSatchelLevel for the
;                  maximum value. (Seed drops)
; b2: Sound effect to play when Link gets the item

; @addr{6c09}
treasureCollectionBehaviourTable:
	; TREASURE_NONE (0x00)
	.db $00
	.db $00
	.db $00

	; TREASURE_SHIELD (0x01)
	.db <wShieldLevel
	.db $08
	.db SND_GETITEM

	; TREASURE_PUNCH (0x02)
	.db <wc608
	.db $00
	.db SND_NONE

	; TREASURE_BOMBS (0x03)
	.db <wNumBombs
	.db $0d
	.db SND_GETSEED

	; TREASURE_CANE_OF_SOMARIA (0x04)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_SWORD (0x05)
	.db <wSwordLevel
	.db $88
	.db SND_GETITEM

	; TREASURE_BOOMERANG (0x06)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_ROD_OF_SEASONS (0x07)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_MAGNET_GLOVES (0x08)
	.db $00
	.db $00
	.db SND_GETSEED

	; TREASURE_SWITCH_HOOK_HELPER (0x09)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_SWITCH_HOOK (0x0a)
	.db <wSwitchHookLevel
	.db $08
	.db SND_GETITEM

	; TREASURE_SWITCH_HOOK_CHAIN (0x0b)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_BIGGORON_SWORD (0x0c)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_BOMBCHUS (0x0e)
	.db <wNumBombchus
	.db $04
	.db SND_GETITEM

	; TREASURE_FLUTE (0x0e)
	.db $10
	.db $08
	.db SND_GETITEM

	; TREASURE_SHOOTER (0x0f)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_10 (0x10)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_HARP (0x11)
	.db <wSelectedHarpSong
	.db $05
	.db SND_GETITEM

	; TREASURE_12 (0x12)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_SLINGSHOT (0x13)
	.db $00
	.db $00
	.db SND_GETSEED

	; TREASURE_14 (0x14)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_SHOVEL (0x15)
	.db $00
	.db $02
	.db SND_GETITEM

	; TREASURE_BRACELET (0x16)
	.db <wBraceletLevel
	.db $08
	.db SND_GETSEED

	; TREASURE_FEATHER (0x17)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_18 (0x18)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_SEED_SATCHEL (0x19)
	.db <wSeedSatchelLevel
	.db $02
	.db SND_GETITEM

	; TREASURE_1a (0x1a)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_1b (0x1b)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_1c (0x1c)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_MINECART_COLLISION (0x1d)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_FOOLS_ORE (0x1e)
	.db $00
	.db $00
	.db SND_GETSEED

	; TREASURE_1f (0x1f)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_EMBER_SEEDS (0x20)
	.db <wNumEmberSeeds
	.db $0f
	.db SND_GETSEED

	; TREASURE_SCENT_SEEDS (0x21)
	.db <wNumScentSeeds
	.db $0f
	.db SND_GETSEED

	; TREASURE_PEGASUS_SEEDS (0x22)
	.db <wNumPegasusSeeds
	.db $0f
	.db SND_GETSEED

	; TREASURE_GALE_SEEDS (0x23)
	.db <wNumGaleSeeds
	.db $0f
	.db SND_GETSEED

	; TREASURE_MYSTERY_SEEDS (0x24)
	.db <wNumMysterySeeds
	.db $0f
	.db SND_GETSEED

	; TREASURE_TUNE_OF_ECHOES (0x25)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_TUNE_OF_CURRENTS (0x26)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_TUNE_OF_AGES (0x27)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_RUPEES (0x28)
	.db <wNumRupees
	.db $0e
	.db SND_NONE

	; TREASURE_HEART_REFILL (0x29)
	.db <wLinkHealth
	.db $0c
	.db SND_NONE

	; TREASURE_HEART_CONTAINER (0x2a)
	.db <wLinkMaxHealth
	.db $8a
	.db SND_GETITEM

	; TREASURE_HEART_PIECE (0x2b)
	.db <wNumHeartPieces
	.db $02
	.db SND_GETITEM

	; TREASURE_RING_BOX (0x2c)
	.db <wRingBoxLevel
	.db $08
	.db SND_GETITEM

	; TREASURE_RING (0x2d)
	.db <wNumUnappraisedRingsBcd
	.db $09
	.db SND_GETSEED

	; TREASURE_FLIPPERS (0x2e)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_POTION (0x2f)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_SMALL_KEY (0x30)
	.db <wDungeonSmallKeys
	.db $87
	.db SND_GETSEED

	; TREASURE_BOSS_KEY (0x31)
	.db <wDungeonBossKeys
	.db $86
	.db SND_GETITEM

	; TREASURE_COMPASS (0x32)
	.db <wDungeonCompasses
	.db $86
	.db SND_GETITEM

	; TREASURE_MAP (0x33)
	.db $86
	.db $86
	.db SND_GETITEM

	; TREASURE_GASHA_SEEDS (0x34)
	.db <wNumGashaSeeds
	.db $04
	.db SND_GETSEED

	; TREASURE_35 (0x35)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_MAKU_SEED (0x36)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_ORE_CHUNKS (0x37)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_38 (0x38)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_39 (0x39)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_3a (0x3a)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_3b (0x3b)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_3c (0x3c)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_3d (0x3d)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_3e (0x3e)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_3f (0x3f)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_ESSENCE (0x40)
	.db <wEssencesObtained
	.db $01
	.db MUS_GET_ESSENCE

	; TREASURE_TRADEITEM (0x41)
	.db <wTradeItem
	.db $05
	.db SND_GETITEM

	; TREASURE_GRAVEYARD_KEY (0x42)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_CROWN_KEY (0x43)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_OLD_MERMAID_KEY (0x44)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_MERMAID_KEY (0x45)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_LIBRARY_KEY (0x46)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_47 (0x47)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_RICKY_GLOVES (0x48)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_BOMB_FLOWER (0x49)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_MERMAID_SUIT (0x4a)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_SLATE (0x4b)
	.db <wNumSlates
	.db $03
	.db SND_GETITEM

	; TREASURE_TUNI_NUT (0x4c)
	.db <wTuniNutState
	.db $05
	.db SND_GETITEM

	; TREASURE_SCENT_SEEDLING (0x4d)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_ZORA_SCALE (0x4e)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_TOKAY_EYEBALL (0x4f)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_EMPTY_BOTTLE (0x50)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_FAIRY_POWDER (0x51)
	.db $00
	.db $05
	.db SND_GETITEM

	; TREASURE_CHEVAL_ROPE (0x52)
	.db <wDeathRespawnBuffer.rememberedCompanionId
	.db $05
	.db SND_NONE

	; TREASURE_MEMBERS_CARD (0x53)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_ISLAND_CHART (0x54)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_BOOK_OF_SEALS (0x55)
	.db $00
	.db $05
	.db SND_GETITEM

	; TREASURE_56 (0x56)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_57 (0x57)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_58 (0x58)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_GORON_LETTER (0x59)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_LAVA_JUICE (0x5a)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_BROTHER_EMBLEM (0x5b)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_GORON_VASE (0x5c)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_GORONADE (0x5d)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_ROCK_BRISKET (0x5e)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_5f (0x5f)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_60 (0x60)
	.db $00
	.db $0b
	.db SND_GETITEM

	; TREASURE_BOMB_UPGRADE (0x61)
	.db $00
	.db $0b
	.db SND_GETITEM

	; TREASURE_SATCHEL_UPGRADE (0x62)
	.db <wSeedSatchelLevel
	.db $83
	.db SND_GETITEM

	; TREASURE_63 (0x63)
	.db $00
	.db $0b
	.db SND_NONE

	; TREASURE_64 (0x64)
	.db $00
	.db $0b
	.db SND_NONE

	; TREASURE_65 (0x65)
	.db $00
	.db $0b
	.db SND_NONE

	; TREASURE_66 (0x66)
	.db $00
	.db $0b
	.db SND_NONE

	; TREASURE_67 (0x67)
	.db $00
	.db $0b
	.db SND_NONE
