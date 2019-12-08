; (TODO: update with changes to constants/ages/enemyCollisionModes.s)
;
; The collision system works between two groups of objects: Items and Special Objects (A),
; and Enemies and Parts (B). We'll simplify these groups to "Items" and "Enemies". Link
; counts as an "item" (though he's really a "special object"), and enemies' projectiles
; count as "enemies" (though they're really "parts").
;
; When an item and an enemy collide, the result is determined by the interaction of the
; "Item.collisionType" and "Enemy.enemyCollisionMode" variables.
;
; Items have their value for this defined in "data/itemAttributes.s", and enemies / parts
; have them defined in "data/{game}/{enemy|part}Data.s" (although code can always change
; it). Bit 7 should be ignored on both values for the purpose of this file (it is
; a "collision enable" bit).
;
; Using these two values, a byte is read from the below table at:
;  [objectCollisionTable + Enemy.enemyCollisionMode * $20 + Item.collisionType]
;
; The byte which is read determines what will occur when the 2 objects collide.
;
; To put the above another way: each $20 bytes corresponds to one EnemyCollisionMode,
; and each of the $20 bytes in one of those sets corresponds to an ItemCollisionType.
; The value of the byte itself is a CollisionEffect.
;
; See also:
;  constants/itemCollisionTypes.s  (Values for Item.collisionType)
;  constants/enemyCollisionModes.s (Values for Enemy.collisionType)
;  constants/collisionEffects.s    (Each byte's value corresponds to a CollisionEffect)
;
;  data/{game}/enemyActiveCollisions.s (Collisions here don't work unless the
;                                      corresponding bit in this file is set)
;  data/{game}/partActiveCollisions.s  (Same as above but for part objects)

; @addr{6d0a}
objectCollisionTable:
	; ENEMYCOLLISION_00 (0x00)
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_ITEM (0x01)
	.db $23 $00 $00 $00 $23 $23 $23 $23 $23 $23 $23 $23 $00 $24 $23 $00
	.db $00 $00 $00 $00 $00 $00 $00 $24 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_DORMANT (0x02)
	.db $1c $1c $1c $1c $1c $1c $1c $1c $1c $1c $1c $1c $1c $1c $1c $1c
	.db $00 $00 $00 $00 $00 $1c $1c $1c $1c $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_SWITCH (0x03)
	.db $26 $26 $26 $26 $26 $26 $26 $26 $26 $26 $26 $26 $26 $26 $26 $26
	.db $00 $00 $00 $00 $00 $26 $26 $26 $26 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_PODOBOO (0x04)
	.db $02 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_05 (0x05)
	.db $1c $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_PROJECTILE (0x06)
	.db $02 $1f $1f $1f $1f $1f $1f $1f $1f $1f $1c $1c $1f $00 $1f $1c
	.db $00 $00 $00 $00 $00 $2f $1c $1c $1c $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_PROJECTILE_WITH_RING_MOD (0x07)
	.db $3c $1f $1f $1f $1f $1f $1f $1f $1f $1f $1c $1c $1f $00 $1f $1c
	.db $00 $00 $00 $00 $00 $2f $1c $1c $1c $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_MERGED_TWINROVA (0x08)
	.db $02 $06 $05 $05 $2c $2c $2c $2c $2c $2c $2c $2c $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $21 $21 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_ONOX (0x09)
	.db $02 $06 $05 $05 $21 $21 $21 $21 $21 $1c $21 $21 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $1c $20 $20 $21 $21 $20 $20 $00

	; ENEMYCOLLISION_TWINROVA (0x0a)
	.db $02 $06 $06 $06 $1c $1c $1c $1c $00 $1c $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_GANON (0x0b)
	.db $02 $05 $05 $05 $16 $15 $2c $15 $2c $16 $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_0c (0x0c)
	.db $02 $05 $05 $05 $1b $1b $1b $1b $1b $1b $1c $1c $00 $1b $1b $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $1c $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_0d (0x0d)
	.db $02 $05 $05 $05 $21 $21 $21 $21 $21 $21 $21 $21 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $21 $1c $21 $21 $20 $21 $21 $20 $20 $00

	; ENEMYCOLLISION_RAMROCK (0x0e)
	.db $02 $07 $06 $06 $1b $1b $1b $1b $1b $1b $1c $1c $00 $1b $1b $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $1c $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_MOTIONLESS_ENEMY (0x0f)
	.db $02 $05 $05 $05 $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $25
	.db $00 $00 $00 $00 $00 $2d $0b $1c $0b $0b $20 $34 $0b $28 $20 $00

	; ENEMYCOLLISION_STANDARD_ENEMY (0x10)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $2e $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_BURNABLE_ENEMY (0x11)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $2e $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $34 $08 $28 $29 $00

	; ENEMYCOLLISION_LYNEL (0x12)
	.db $02 $11 $10 $10 $0b $08 $08 $09 $09 $0b $0b $09 $00 $1c $0b $25
	.db $00 $00 $00 $00 $00 $2f $08 $22 $09 $0b $35 $27 $0b $28 $20 $00

	; ENEMYCOLLISION_BLADE_TRAP (0x13)
	.db $3c $06 $06 $06 $15 $16 $16 $16 $17 $15 $00 $00 $16 $1b $15 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_SWITCHHOOK_DAMAGE_ENEMY (0x14)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $08 $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_EYESOAR_CHILD (0x15)
	.db $02 $07 $06 $06 $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $25
	.db $00 $00 $00 $00 $00 $00 $0b $0b $0b $0b $20 $0b $0b $20 $20 $00

	; ENEMYCOLLISION_GIBDO (0x16)
	.db $02 $06 $06 $06 $0b $0b $0b $0b $0b $0b $0b $08 $00 $2e $0b $25
	.db $00 $00 $00 $00 $00 $2f $0b $22 $0b $0b $20 $27 $0b $28 $29 $00

	; ENEMYCOLLISION_SPARK (0x17)
	.db $02 $00 $00 $05 $1c $1c $1c $1c $00 $1c $00 $00 $00 $1c $1c $00
	.db $00 $00 $00 $00 $00 $2d $1c $35 $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_SPIKED_BEETLE (0x18)
	.db $02 $10 $0f $0f $15 $16 $16 $16 $17 $16 $00 $00 $0f $1b $15 $25
	.db $00 $00 $00 $00 $00 $0d $1c $1b $00 $20 $20 $20 $20 $28 $29 $00

	; ENEMYCOLLISION_BUBBLE (0x19)
	.db $01 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_GHINI (0x1a)
	.db $02 $00 $00 $0f $08 $09 $09 $0a $0a $08 $08 $0a $00 $08 $08 $00
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_BUZZBLOB (0x1b)
	.db $02 $10 $0f $0f $36 $36 $36 $36 $36 $36 $36 $36 $0d $36 $36 $25
	.db $00 $00 $00 $00 $00 $2f $0b $22 $0b $0b $20 $27 $0b $28 $29 $00

	; ENEMYCOLLISION_WHISP (0x1c)
	.db $02 $00 $00 $05 $1c $1c $1c $1c $00 $1c $00 $00 $00 $1c $1c $00
	.db $00 $00 $00 $00 $00 $2d $1c $35 $00 $20 $35 $20 $20 $20 $29 $00

	; ENEMYCOLLISION_IRON_MASK (0x1d)
	.db $02 $10 $0f $0f $18 $19 $19 $19 $1a $18 $00 $00 $19 $2e $18 $25
	.db $00 $00 $00 $00 $00 $0d $0d $12 $0b $20 $20 $20 $12 $20 $20 $00

	; ENEMYCOLLISION_ACTIVE_RED_ARMOS (0x1e)
	.db $02 $07 $06 $06 $15 $15 $15 $08 $16 $15 $00 $00 $15 $2e $15 $25
	.db $00 $00 $00 $00 $00 $2f $1c $22 $0b $20 $35 $20 $0b $28 $20 $00

	; ENEMYCOLLISION_KEESE (0x1f)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $08 $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $09 $0a $09 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_DARKNUT (0x20)
	.db $02 $10 $0f $0f $08 $08 $09 $0a $0a $08 $0b $09 $19 $2e $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $1b $0a $09 $20 $20 $08 $28 $20 $00

	; ENEMYCOLLISION_POLS_VOICE (0x21)
	.db $02 $0f $0f $0f $0c $0d $0d $0e $0e $0c $0c $09 $0d $0c $0c $25
	.db $00 $00 $00 $00 $00 $0d $09 $0d $0a $0d $20 $20 $0d $28 $29 $00

	; ENEMYCOLLISION_LIKE_LIKE (0x22)
	.db $3a $00 $00 $00 $08 $09 $09 $0a $0a $08 $08 $0a $0d $2e $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_GOPONGA_FLOWER (0x23)
	.db $02 $05 $05 $05 $1c $1c $0b $0b $0b $1c $00 $0b $00 $0b $00 $25
	.db $00 $00 $00 $00 $00 $2d $0b $1c $0b $20 $20 $34 $20 $20 $20 $00

	; ENEMYCOLLISION_ANGLER_FISH_BUBBLE (0x24)
	.db $02 $06 $05 $05 $1c $1c $1c $1c $1c $1c $1c $1c $00 $1c $1c $00
	.db $00 $00 $00 $00 $00 $2f $1c $1c $1c $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_WALLMASTER (0x25)
	.db $37 $00 $00 $00 $08 $09 $09 $0a $0a $08 $08 $0a $0d $08 $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_GIANT_BLADE_TRAP (0x26)
	.db $3c $07 $06 $06 $15 $16 $16 $16 $00 $15 $00 $00 $16 $1b $15 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_THWIMP (0x27)
	.db $02 $06 $05 $05 $15 $16 $16 $16 $17 $15 $00 $00 $16 $1b $15 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_THWOMP (0x28)
	.db $02 $07 $06 $06 $15 $16 $16 $16 $17 $15 $00 $00 $16 $1b $15 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_ZOL (0x29)
	.db $02 $10 $0f $0f $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $25
	.db $00 $00 $00 $00 $00 $2f $0b $22 $0b $0b $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_CUCCO (0x2a)
	.db $00 $00 $00 $00 $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $25
	.db $00 $00 $00 $00 $00 $2f $0b $2b $0b $0b $20 $27 $0b $0b $29 $00

	; ENEMYCOLLISION_FIRE_KEESE (0x2b)
	.db $02 $00 $0f $0f $08 $09 $09 $0a $0a $08 $00 $0a $00 $08 $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $09 $0a $09 $20 $1c $08 $28 $29 $00

	; ENEMYCOLLISION_GIANT_CUCCO (0x2c)
	.db $02 $07 $07 $07 $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $00
	.db $00 $00 $00 $00 $00 $2f $0b $0b $0b $0b $0b $0b $0b $0b $0b $00

	; ENEMYCOLLISION_BARI (0x2d)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $00 $08 $08 $00
	.db $00 $00 $00 $00 $00 $2f $09 $09 $0a $08 $20 $0b $0b $20 $29 $00

	; ENEMYCOLLISION_PEAHAT_VULNERABLE (0x2e)
	.db $02 $05 $05 $05 $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $25
	.db $00 $00 $00 $00 $00 $2f $0b $22 $0b $0b $20 $34 $0b $28 $29 $00

	; ENEMYCOLLISION_GIANT_GHINI_CHILD (0x2f)
	.db $1c $00 $00 $00 $08 $09 $09 $0a $0a $08 $08 $0a $00 $08 $08 $00
	.db $00 $00 $00 $00 $00 $2f $09 $08 $0a $08 $20 $0b $0b $20 $20 $00

	; ENEMYCOLLISION_WIZZROBE (0x30)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $2e $08 $25
	.db $00 $00 $00 $00 $00 $00 $09 $1c $0a $09 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_CROW (0x31)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $00 $08 $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $09 $0a $09 $20 $27 $08 $20 $29 $00

	; ENEMYCOLLISION_SHADOW_HAG_BUG (0x32)
	.db $02 $00 $00 $00 $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $25
	.db $00 $00 $00 $00 $00 $2f $0b $0b $0b $0b $20 $27 $0b $28 $29 $00

	; ENEMYCOLLISION_GEL (0x33)
	.db $38 $00 $00 $00 $0b $0b $0b $0b $0b $0b $0b $0b $0b $0b $0b $25
	.db $00 $00 $00 $00 $00 $2f $0b $0b $0b $0b $20 $27 $0b $28 $29 $00

	; ENEMYCOLLISION_PINCER (0x34)
	.db $02 $07 $06 $06 $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $25
	.db $00 $00 $00 $00 $00 $2f $0b $22 $0b $0b $20 $27 $0b $28 $20 $00

	; ENEMYCOLLISION_GOHMA_GEL (0x35)
	.db $02 $00 $00 $00 $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $25
	.db $00 $00 $00 $00 $00 $2f $0b $22 $0b $0b $20 $27 $0b $28 $29 $00

	; ENEMYCOLLISION_SWORD_MASKED_MOBLIN (0x36)
	.db $02 $10 $0f $0f $09 $09 $09 $0a $0a $08 $08 $0a $0d $2e $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $34 $08 $28 $29 $00

	; ENEMYCOLLISION_BALL_AND_CHAIN_SOLDIER (0x37)
	.db $02 $06 $05 $05 $0b $0b $0b $0b $0b $0b $00 $0b $16 $2e $1b $25
	.db $00 $00 $00 $00 $00 $2f $0b $1b $0b $0b $20 $20 $0b $20 $20 $00

	; ENEMYCOLLISION_HARDHAT_BEETLE (0x38)
	.db $02 $10 $10 $10 $0d $0d $0d $0e $0e $0d $00 $00 $0d $0d $0d $25
	.db $00 $00 $00 $00 $00 $0d $0d $0d $0e $0d $20 $20 $0d $28 $29 $00

	; ENEMYCOLLISION_ARM_MIMIC (0x39)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $2e $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $08 $35 $27 $08 $20 $29 $00

	; ENEMYCOLLISION_MOLDORM (0x3a)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $08 $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $1b $0a $08 $20 $20 $08 $20 $20 $00

	; ENEMYCOLLISION_BEETLE (0x3b)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $08 $08 $25
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $08 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_FLYING_TILE (0x3c)
	.db $02 $07 $06 $06 $1c $1c $1c $1c $1c $1c $1c $1c $1c $1c $1c $00
	.db $00 $00 $00 $00 $00 $00 $1c $1c $1c $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_AMBI_GUARD_CHASING_LINK (0x3d)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $00 $1b $08 $00
	.db $00 $00 $00 $00 $00 $2f $09 $1b $0a $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_CANDLE (0x3e)
	.db $02 $00 $00 $00 $0f $0f $0f $0f $0f $0f $00 $00 $00 $0c $0f $00
	.db $00 $00 $00 $00 $00 $0c $1c $0c $00 $0c $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_3f (0x3f)
	.db $02 $07 $06 $06 $0b $0b $0b $0b $0b $0b $0b $0b $00 $0b $0b $00
	.db $00 $00 $00 $00 $00 $00 $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_BUSH (0x40)
	.db $00 $00 $00 $00 $0b $0b $0b $0b $0b $00 $00 $00 $00 $2e $00 $00
	.db $00 $00 $00 $00 $00 $00 $1c $1c $0b $20 $20 $27 $20 $20 $20 $00

	; ENEMYCOLLISION_TWINROVA_BAT (0x41)
	.db $02 $07 $06 $06 $0b $0b $0b $0b $0b $0b $00 $00 $00 $0b $0b $00
	.db $00 $00 $00 $00 $00 $2f $1c $1c $0b $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_HARMLESS_HARDHAT_BEETLE (0x42)
	.db $06 $10 $10 $10 $0d $0d $0d $0e $0e $0d $00 $00 $0d $0d $0d $00
	.db $00 $00 $00 $00 $00 $0d $0d $0d $0e $0d $20 $20 $0d $28 $20 $00

	; ENEMYCOLLISION_VERAN_POSSESSION_BOSS (0x43)
	.db $02 $07 $07 $07 $30 $30 $30 $30 $30 $30 $30 $30 $00 $1c $1c $00
	.db $00 $00 $00 $00 $00 $00 $1c $1c $00 $1c $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_STANDARD_MINIBOSS (0x44)
	.db $02 $06 $05 $05 $21 $21 $21 $21 $21 $21 $21 $21 $00 $21 $1c $00
	.db $00 $00 $00 $00 $00 $2d $21 $1c $21 $21 $20 $20 $21 $20 $20 $00

	; ENEMYCOLLISION_SMASHER (0x45)
	.db $02 $00 $05 $05 $1c $1c $1c $1c $00 $1c $00 $00 $00 $1c $1c $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_VIRE (0x46)
	.db $03 $00 $00 $07 $21 $21 $21 $21 $21 $21 $00 $21 $00 $1c $21 $00
	.db $00 $00 $00 $00 $00 $2d $21 $1c $21 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_ANGLER_FISH_ANTENNA (0x47)
	.db $02 $06 $05 $05 $21 $21 $21 $21 $21 $21 $21 $21 $00 $21 $00 $00
	.db $00 $00 $00 $00 $00 $2d $21 $21 $21 $20 $20 $21 $21 $20 $20 $00

	; ENEMYCOLLISION_BLUE_STALFOS (0x48)
	.db $02 $06 $05 $05 $1c $1c $1c $1c $00 $1c $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_PUMPKIN_HEAD_BODY (0x49)
	.db $02 $05 $06 $06 $21 $21 $21 $21 $21 $21 $21 $21 $00 $1c $1c $00
	.db $00 $00 $00 $00 $00 $2d $21 $20 $21 $21 $20 $21 $21 $20 $20 $00

	; ENEMYCOLLISION_HEAD_THWOMP (0x4a)
	.db $02 $00 $00 $00 $1b $1b $1b $1b $1b $1b $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_SHADOW_HAG (0x4b)
	.db $02 $00 $00 $04 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $00 $00 $00 $00 $20 $21 $21 $20 $20 $00

	; ENEMYCOLLISION_EYESOAR_VULNERABLE (0x4c)
	.db $02 $06 $05 $05 $21 $21 $21 $21 $21 $21 $21 $21 $00 $2e $00 $00
	.db $00 $00 $00 $00 $00 $2d $21 $21 $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_SMOG (0x4d)
	.db $36 $00 $00 $00 $21 $21 $21 $21 $21 $21 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_OCTOGON (0x4e)
	.db $03 $06 $06 $06 $21 $21 $21 $21 $21 $21 $21 $21 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $21 $20 $21 $21 $20 $20 $00

	; ENEMYCOLLISION_PLASMARINE (0x4f)
	.db $02 $06 $05 $05 $26 $26 $26 $26 $26 $26 $26 $26 $00 $2e $26 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_KING_MOBLIN (0x50)
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $00 $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_SPIKED_BEETLE_FLIPPED (0x51)
	.db $02 $0f $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $08 $08 $00
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_ROCK (0x52)
	.db $00 $00 $00 $00 $1b $1b $1b $1b $1b $00 $00 $00 $00 $2e $00 $00
	.db $00 $00 $00 $00 $00 $00 $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_UNMASKED_IRON_MASK (0x53)
	.db $02 $10 $0f $0f $08 $09 $09 $0a $0a $08 $08 $0a $0d $2e $08 $00
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $27 $08 $28 $29 $00

	; ENEMYCOLLISION_ACTIVE_BLUE_ARMOS (0x54)
	.db $02 $07 $06 $06 $0b $0b $0b $0b $0b $0b $0b $0b $00 $2e $0b $00
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0b $0b $35 $20 $0b $28 $20 $00

	; ENEMYCOLLISION_STALFOS_BLOCKED_WITH_SWORD (0x55)
	.db $02 $10 $0f $0f $00 $00 $00 $00 $0a $00 $00 $00 $00 $2e $00 $25
	.db $00 $00 $00 $00 $00 $2f $09 $22 $0a $09 $20 $34 $08 $28 $20 $00

	; ENEMYCOLLISION_DARKNUT_BLOCKED_WITH_SWORD (0x56)
	.db $02 $10 $0f $0f $00 $00 $00 $00 $0a $00 $00 $00 $00 $2e $00 $25
	.db $00 $00 $00 $00 $00 $2f $09 $1b $0a $09 $20 $20 $08 $28 $20 $00

	; ENEMYCOLLISION_BIG_GOPONGA_FLOWER (0x57)
	.db $02 $05 $05 $05 $1c $1c $0b $0b $0b $1c $00 $0b $00 $0b $00 $25
	.db $00 $00 $00 $00 $00 $2d $0b $1c $0b $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_PEAHAT (0x58)
	.db $02 $06 $05 $05 $1c $1c $1c $1c $00 $1c $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $00 $1c $1c $00 $20 $20 $34 $20 $20 $20 $00

	; ENEMYCOLLISION_BARI_ELECTRIC_SHOCK (0x59)
	.db $36 $00 $00 $05 $36 $36 $36 $36 $36 $36 $00 $00 $00 $36 $36 $00
	.db $00 $00 $00 $00 $00 $2f $09 $08 $0a $08 $20 $0b $0b $20 $29 $00

	; ENEMYCOLLISION_AMBI_GUARD (0x5a)
	.db $30 $00 $00 $00 $30 $30 $30 $30 $30 $30 $30 $30 $30 $30 $30 $00
	.db $00 $00 $00 $00 $00 $2d $30 $30 $30 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_VERAN_GHOST (0x5b)
	.db $02 $00 $00 $00 $1c $1c $1c $1c $00 $1c $00 $00 $00 $2e $1c $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_VERAN_FAIRY (0x5c)
	.db $02 $06 $05 $05 $21 $21 $21 $21 $21 $21 $21 $21 $00 $1c $1c $00
	.db $00 $00 $00 $00 $00 $2d $21 $1c $21 $21 $20 $20 $21 $20 $20 $00

	; ENEMYCOLLISION_PUMPKIN_HEAD_HEAD (0x5d)
	.db $00 $05 $06 $06 $1b $1b $1b $1b $1b $1b $00 $00 $00 $1b $1b $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_PUMPKIN_HEAD_GHOST (0x5e)
	.db $02 $05 $06 $06 $21 $21 $21 $21 $21 $21 $21 $21 $00 $21 $21 $00
	.db $00 $00 $00 $00 $00 $2f $21 $1c $21 $21 $20 $21 $21 $20 $20 $00

	; ENEMYCOLLISION_SUBTERROR_DRILLING (0x5f)
	.db $02 $06 $05 $05 $1b $1b $1b $1b $1b $1b $00 $1b $00 $1b $1b $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_ARMOS_WARRIOR_PROTECTED (0x60)
	.db $02 $06 $06 $06 $16 $16 $16 $17 $00 $15 $00 $00 $00 $1b $1b $00
	.db $00 $00 $00 $00 $00 $2d $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_ARMOS_WARRIOR_SHIELD (0x61)
	.db $02 $06 $06 $06 $15 $16 $16 $17 $00 $15 $00 $00 $00 $1b $1b $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_ARMOS_WARRIOR_SWORD (0x62)
	.db $02 $07 $06 $06 $17 $17 $17 $17 $00 $16 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_SMASHER_BALL (0x63)
	.db $02 $00 $05 $05 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_ANGLER_FISH (0x64)
	.db $02 $06 $05 $05 $1c $1c $1c $1c $00 $1c $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $1c $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_BLUE_STALFOS_BAT (0x65)
	.db $02 $05 $05 $05 $21 $21 $21 $21 $21 $21 $21 $21 $21 $21 $21 $00
	.db $00 $00 $00 $00 $00 $2f $21 $21 $21 $20 $20 $20 $21 $20 $20 $00

	; ENEMYCOLLISION_BLUE_STALFOS_SICKLE (0x66)
	.db $02 $07 $06 $06 $15 $16 $16 $16 $00 $15 $00 $00 $00 $1b $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_OCTOGON_SHELL (0x67)
	.db $03 $06 $06 $06 $1b $1b $1b $1b $1b $1b $00 $00 $00 $1b $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_PLASMARINE_SHOCK (0x68)
	.db $36 $36 $36 $36 $36 $36 $36 $36 $36 $36 $36 $36 $00 $36 $36 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_SUBTERROR_UNDERGROUND (0x69)
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $1c $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_VERAN_FINAL_FORM (0x6a)
	.db $02 $06 $05 $05 $00 $00 $00 $00 $00 $1c $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_6b (0x6b)
	.db $02 $06 $05 $05 $21 $21 $21 $21 $21 $21 $21 $21 $00 $1b $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $21 $21 $20 $20 $00

	; ENEMYCOLLISION_6c (0x6c)
	.db $02 $06 $05 $05 $1b $1b $1b $14 $1b $1b $00 $00 $00 $1b $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $0e $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_EYESOAR (0x6d)
	.db $02 $06 $05 $05 $1b $1b $1b $1b $1b $1b $00 $00 $00 $2e $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_COLOR_CHANGING_GEL (0x6e)
	.db $02 $00 $00 $00 $1c $1c $1c $1c $1c $1c $00 $00 $00 $1c $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1c $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_LYNEL_BEAM (0x6f)
	.db $03 $00 $00 $1e $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_ENEMY_SWORD (0x70)
	.db $02 $19 $18 $18 $33 $33 $32 $14 $00 $32 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_FIRE (0x71)
	.db $01 $00 $00 $1e $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_72 (0x72)
	.db $03 $00 $00 $06 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_73 (0x73)
	.db $03 $00 $00 $07 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_SPIKED_BALL (0x74)
	.db $02 $17 $16 $16 $15 $15 $15 $16 $1b $15 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $1c $1b $00 $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_75 (0x75)
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $2a $2a $2a $2a $2a $00

	; ENEMYCOLLISION_VIRE_PROJECTILE (0x76)
	.db $02 $1f $1f $1f $1c $1c $1c $1c $1c $1c $00 $1c $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $1c $1c $1c $20 $20 $20 $20 $20 $20 $00

	; ENEMYCOLLISION_77 (0x77)
	.db $3b $00 $00 $1e $1c $1c $1c $1c $1c $00 $00 $00 $1c $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_KING_MOBLIN_BOMB (0x78)
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $1c $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_79 (0x79)
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $31 $31 $31 $31 $31 $00

	; ENEMYCOLLISION_TWINROVA_PROJECTILE (0x7a)
	.db $02 $00 $00 $1e $00 $1c $1c $00 $1c $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_7b (0x7b)
	.db $03 $00 $06 $06 $16 $16 $16 $16 $16 $16 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $2d $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

	; ENEMYCOLLISION_7c (0x7c)
	.db $3d $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
