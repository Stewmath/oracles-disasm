;;
; ITEM_SWORD
itemCode05:
	call itemTransferKnockbackToLink
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@swordSounds:
	.db SND_SWORDSLASH
	.db SND_UNKNOWN5
	.db SND_BOOMERANG
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH
	.db SND_UNKNOWN5
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH


@state0:
	ld a,UNCMP_GFXH_1a
	call loadWeaponGfx

	; Play a random sound
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@swordSounds
	rst_addAToHl
	ld a,(hl)
	call playSound

	ld e,Item.var31
	xor a
	ld (de),a


; State 6: partial re-initialization?
@state6:
	call loadAttributesAndGraphicsAndIncState

	; Load collisiontype and damage
	ld a,(wSwordLevel)
	ld hl,@swordLevelData-2
	rst_addDoubleIndex

	ld e,Item.collisionType
	ldi a,(hl)
	ld (de),a
	ld c,(hl)

	; If var31 was nonzero, skip whimsical ring check?
	ld e,Item.var31
	ld a,(de)
	or a
	ld a,c
	ld (de),a
	jr nz,@@setDamage

	; Whimsical ring: usually 1 damage, with a 1/256 chance of doing 12 damage
	ld a,WHIMSICAL_RING
	call cpActiveRing
	jr nz,@@setDamage
	call getRandomNumber
	or a
	ld c,-1
	jr nz,@@setDamage
	ld a,SND_LIGHTNING
	call playSound
	ld c,-12

@@setDamage:
	ld e,Item.var3a
	ld a,c
	ld (de),a

	ld e,Item.state
	ld a,$01
	ld (de),a

	jp objectSetVisible82

; b0: collisionType
; b1: base damage
@swordLevelData:
	; L-1
	.db ($80|ITEMCOLLISION_L1_SWORD)
	.db (-2)

	; L-2
	.db ($80|ITEMCOLLISION_L2_SWORD)
	.db (-3)

	; L-3
	.db ($80|ITEMCOLLISION_L3_SWORD)
	.db (-5)


; State 4: swordspinning
@state4:
	ld e,Item.collisionType
	ld a, $80 | ITEMCOLLISION_SWORDSPIN
	ld (de),a


; State 1: being swung
@state1:
	ld h,d
	ld l,Item.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a
	ret


; State 2: charging
@state2:
	ld e,Item.var31
	ld a,(de)
	ld e,Item.var3a
	ld (de),a
	ret


; State 3: sword fully charged, flashing
@state3:
	ld h,d
	ld l,Item.counter1
	inc (hl)
	bit 2,(hl)
	ld l,Item.oamFlagsBackup
	ldi a,(hl)
	jr nz,+
	ld a,$0d
+
	ld (hl),a
	ret


; State 5: end of swordspin
@state5:
	; Try to break tile at Link's feet, then delete self
	ld a,$08
	call tryBreakTileWithSword_calculateLevel
	jp itemDelete
