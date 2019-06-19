; See data/ages/treasureCollectionBehaviours.s for documentation

treasureCollectionBehaviourTable:
	; TREASURE_NONE (0x00)
	.db $00
	.db $00
	.db SND_NONE

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
	.db <wBoomerangLevel
	.db $08
	.db SND_GETITEM

	; TREASURE_ROD_OF_SEASONS (0x07)
	.db <wObtainedSeasons
	.db $81
	.db SND_GETITEM

	; TREASURE_MAGNET_GLOVES (0x08)
	.db <wMagnetGlovePolarity
	.db $08
	.db SND_GETSEED

	; TREASURE_SWITCH_HOOK_HELPER (0x09)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_SWITCH_HOOK (0x09)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_SWITCH_HOOK_CHAIN (0x0b)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_BIGGORON_SWORD (0x0c)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_BOMBCHUS (0x0d)
	.db <wNumBombchus
	.db $04
	.db SND_GETITEM

	; TREASURE_FLUTE (0x0e)
	.db <wAnimalCompanion
	.db $05
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
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_12 (0x12)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_SLINGSHOT (0x13)
	.db <wSlingshotLevel
	.db $08
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
	.db $00
	.db $00
	.db SND_GETSEED

	; TREASURE_FEATHER (0x17)
	.db <wFeatherLevel
	.db $08
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
	.db <wDungeonMaps
	.db $86
	.db SND_GETITEM

	; TREASURE_GASHA_SEED (0x34)
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
	.db <wNumOreChunks
	.db $0e
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

	; TREASURE_GNARLED_KEY (0x42)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_FLOODGATE_KEY (0x43)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_DRAGON_KEY (0x44)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_STAR_ORE (0x45)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_RIBBON (0x46)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_SPRING_BANANA (0x47)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_RICKY_GLOVES (0x48)
	.db $00
	.db $05
	.db SND_GETITEM

	; TREASURE_BOMB_FLOWER (0x49)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_PIRATES_BELL (0x4a)
	.db <wPirateBellState
	.db $05
	.db SND_GETITEM

	; TREASURE_TREASURE_MAP (0x4b)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_ROUND_JEWEL (0x4c)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_PYRAMID_JEWEL (0x4d)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_SQUARE_JEWEL (0x4e)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_X_SHAPED_JEWEL (0x4f)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_RED_ORE (0x50)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_BLUE_ORE (0x51)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_HARD_ORE (0x52)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_MEMBERS_CARD (0x53)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_MASTERS_PLAQUE (0x54)
	.db $00
	.db $00
	.db SND_GETITEM

	; TREASURE_55 (0x55)
	.db $00
	.db $00
	.db SND_NONE

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

	; TREASURE_59 (0x59)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_5a (0x5a)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_5b (0x5b)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_5c (0x5c)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_5d (0x5d)
	.db $00
	.db $00
	.db SND_NONE

	; TREASURE_5e (0x5e)
	.db $00
	.db $00
	.db SND_NONE

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


