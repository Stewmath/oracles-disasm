.define NUM_RINGS		$40

.enum 0
	FRIENDSHIP_RING		db ; $00
	POWER_RING_L1		db ; $01
	POWER_RING_L2		db ; $02
	POWER_RING_L3		db ; $03
	ARMOR_RING_L1		db ; $04
	ARMOR_RING_L2		db ; $05
	ARMOR_RING_L3		db ; $06
	RED_RING		db ; $07
	BLUE_RING		db ; $08
	GREEN_RING		db ; $09
	CURSED_RING		db ; $0a
	EXPERTS_RING		db ; $0b
	BLAST_RING		db ; $0c
	RANG_RING_L1		db ; $0d
	GBA_TIME_RING		db ; $0e
	MAPLES_RING		db ; $0f
	STEADFAST_RING		db ; $10
	PEGASUS_RING		db ; $11
	TOSS_RING		db ; $12
	HEART_RING_L1		db ; $13
	HEART_RING_L2		db ; $14
	SWIMMERS_RING		db ; $15
	CHARGE_RING		db ; $16
	LIGHT_RING_L1		db ; $17
	LIGHT_RING_L2		db ; $18
	BOMBERS_RING		db ; $19
	GREEN_LUCK_RING		db ; $1a
	BLUE_LUCK_RING		db ; $1b
	GOLD_LUCK_RING		db ; $1c
	RED_LUCK_RING		db ; $1d
	GREEN_HOLY_RING		db ; $1e
	BLUE_HOLY_RING		db ; $1f
	RED_HOLY_RING		db ; $20
	SNOWSHOE_RING		db ; $21
	ROCS_RING		db ; $22
	QUICKSAND_RING		db ; $23
	RED_JOY_RING		db ; $24
	BLUE_JOY_RING		db ; $25
	GOLD_JOY_RING		db ; $26
	GREEN_JOY_RING		db ; $27
	DISCOVERY_RING		db ; $28
	RANG_RING_L2		db ; $29
	OCTO_RING		db ; $2a
	MOBLIN_RING		db ; $2b
	LIKE_LIKE_RING		db ; $2c
	SUBROSIAN_RING		db ; $2d
	FIRST_GEN_RING		db ; $2e
	SPIN_RING		db ; $2f
	BOMBPROOF_RING		db ; $30
	ENERGY_RING		db ; $31
	DBL_EDGED_RING		db ; $32
	GBA_NATURE_RING		db ; $33
	SLAYERS_RING		db ; $34
	RUPEE_RING		db ; $35
	VICTORY_RING		db ; $36
	SIGN_RING		db ; $37
	HUNDREDTH_RING		db ; $38: Constant name can't start with "100"
	WHISP_RING		db ; $39
	GASHA_RING		db ; $3a
	PEACE_RING		db ; $3b
	ZORA_RING		db ; $3c
	FIST_RING		db ; $3d
	WHIMSICAL_RING		db ; $3e
	PROTECTION_RING		db ; $3f
.ende


; Rings are categorized into tiers when random rings are given.
.enum 0
	RING_TIER_0 db ; Class 4 (TourianTourist's naming convention)
	RING_TIER_1 db ; Class 3
	RING_TIER_2 db ; Class 2
	RING_TIER_3 db ; Class 1
	RING_TIER_4 db ; Class 5
.ende
