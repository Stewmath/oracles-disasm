;;
; For each Enemy and each Part, check for collisions with Link and Items.
; @addr{41d1}
checkEnemyAndPartCollisions:
	; Calculate shield position
	ld a,(w1Link.direction)		; $41d1
	add a			; $41d4
	add a			; $41d5
	ld hl,@shieldPositionOffsets		; $41d6
	rst_addAToHl			; $41d9
	ld de,wShieldY		; $41da
	ld a,(w1Link.yh)		; $41dd
	add (hl)		; $41e0
	ld (de),a		; $41e1
	inc hl			; $41e2
	inc e			; $41e3
	ld a,(w1Link.xh)		; $41e4
	add (hl)		; $41e7
	ld (de),a		; $41e8

	inc hl			; $41e9
	inc e			; $41ea
	ldi a,(hl)		; $41eb
	ld (de),a		; $41ec
	inc e			; $41ed
	ldi a,(hl)		; $41ee
	ld (de),a		; $41ef

	; Check collisions for all Enemies
	ld a,Enemy.start		; $41f0
	ldh (<hActiveObjectType),a	; $41f2
	ld d,FIRST_ENEMY_INDEX		; $41f4
	ld a,d			; $41f6
@nextEnemy:
	ldh (<hActiveObject),a	; $41f7
	ld h,d			; $41f9
	ld l,Enemy.collisionType		; $41fa
	bit 7,(hl)		; $41fc
	jr z,+			; $41fe

	ld a,(hl)		; $4200
	ld l,Enemy.var2a		; $4201
	bit 7,(hl)		; $4203
	call z,_enemyCheckCollisions		; $4205
+
	inc d			; $4208
	ld a,d			; $4209
	cp LAST_ENEMY_INDEX+1			; $420a
	jr c,@nextEnemy		; $420c

	; Check collisions for all Parts
	ld a,Part.start		; $420e
	ldh (<hActiveObjectType),a	; $4210
	ld d,FIRST_PART_INDEX		; $4212
	ld a,d			; $4214
@nextPart:
	ldh (<hActiveObject),a	; $4215
	ld h,d			; $4217
	ld l,Part.collisionType		; $4218
	bit 7,(hl)		; $421a
	jr z,+			; $421c

	ld l,Part.var2a		; $421e
	bit 7,(hl)		; $4220
	jr nz,+			; $4222

	; Check Part.invincibilityCounter
	inc l			; $4224
	ld a,(hl)		; $4225
	or a			; $4226
	call z,_partCheckCollisions		; $4227
+
	inc d			; $422a
	ld a,d			; $422b
	cp LAST_PART_INDEX+1			; $422c
	jr c,@nextPart		; $422e

	ret			; $4230

; @addr{4231}
@shieldPositionOffsets:
	.db $f9 $01 $01 $06 ; DIR_UP
	.db $00 $06 $07 $01 ; DIR_RIGHT
	.db $06 $ff $01 $06 ; DIR_DOWN
	.db $00 $f9 $07 $01 ; DIR_LEFT


;;
; Check if the given part is colliding with an item or link, and do the appropriate
; action.
; @param d Part index
; @addr{4241}
_partCheckCollisions:
	ld e,Part.collisionType		; $4241
	ld a,(de)		; $4243
	ld hl,partActiveCollisions		; $4244
	ld e,Part.yh		; $4247
	jr ++			; $4249

;;
; Check if the given enemy is colliding with an item or link, and do the appropriate
; action.
; @param a Enemy.collisionType
; @param d Enemy index
; @addr{424b}
_enemyCheckCollisions:
	ld hl,enemyActiveCollisions		; $424b
	ld e,Enemy.yh		; $424e

++
	add a			; $4250
	ld c,a			; $4251
	ld b,$00		; $4252
	add hl,bc		; $4254
	add hl,bc		; $4255

	; Store pointer for later
	ld a,l			; $4256
	ldh (<hFF92),a	; $4257
	ld a,h			; $4259
	ldh (<hFF93),a	; $425a

	; Store X in hFF8E, Y in hFF8F, Z in hFF91
	ld h,d			; $425c
	ld l,e			; $425d
	ldi a,(hl)		; $425e
	ldh (<hFF8F),a	; $425f
	inc l			; $4261
	ldi a,(hl)		; $4262
	ldh (<hFF8E),a	; $4263
	inc l			; $4265
	ld a,(hl)		; $4266
	ldh (<hFF91),a	; $4267

	; Check invincibility
	ld a,l			; $4269
	add Object.invincibilityCounter-Object.zh		; $426a
	ld l,a			; $426c
	ld a,(hl)		; $426d
	or a			; $426e
	jr nz,@doneCheckingItems	; $426f

	; Check collisions with items
	ld h,FIRST_ITEM_INDEX		; $4271
@checkItem:
	ld l,Item.collisionType		; $4273
	ld a,(hl)		; $4275
	bit 7,a			; $4276
	jr z,@nextItem		; $4278

	and $7f			; $427a
	ldh (<hFF90),a	; $427c
	ld b,a			; $427e
	ld e,h			; $427f
	ldh a,(<hFF92)	; $4280
	ld l,a			; $4282
	ldh a,(<hFF93)	; $4283
	ld h,a			; $4285
	ld a,b			; $4286
	call @checkFlag		; $4287
	ld h,e			; $428a
	jr z,@nextItem		; $428b

	ld bc,$0e07		; $428d
	ldh a,(<hFF90)	; $4290
	cp ITEMCOLLISION_BOMB			; $4292
	jr nz,++		; $4294

	ld l,Item.collisionRadiusY		; $4296
	ld a,(hl)		; $4298
	ld c,a			; $4299
	add a			; $429a
	ld b,a			; $429b
++
	ld l,Item.zh		; $429c
	ldh a,(<hFF91)	; $429e
	sub (hl)		; $42a0
	add c			; $42a1
	cp b			; $42a2
	jr nc,@nextItem		; $42a3

	ld l,Item.yh		; $42a5
	ld b,(hl)		; $42a7
	ld l,Item.xh		; $42a8
	ld c,(hl)		; $42aa
	ld l,Item.collisionRadiusY		; $42ab
	ldh a,(<hActiveObjectType)	; $42ad
	add Object.collisionRadiusY			; $42af
	ld e,a			; $42b1
	call checkObjectsCollidedFromVariables		; $42b2
	jp c,@handleCollision		; $42b5

@nextItem:
	inc h			; $42b8
	ld a,h			; $42b9
	cp LAST_STANDARD_ITEM_INDEX+1			; $42ba
	jr c,@checkItem		; $42bc

@doneCheckingItems:
	call checkLinkVulnerable		; $42be
	ret nc			; $42c1

	; Check for collision with link
	; (hl points to link object from the call to checkLinkVulnerable)

	; Check if Z positions are within 7 pixels
	ld l,<w1Link.zh		; $42c2
	ldh a,(<hFF91)	; $42c4
	sub (hl)		; $42c6
	add $07			; $42c7
	cp $0e			; $42c9
	ret nc			; $42cb

	; If the shield is out...
	ld a,(wUsingShield)		; $42cc
	or a			; $42cf
	jr z,@checkHitLink		; $42d0

	; Store shield level as collision type
	ldh (<hFF90),a	; $42d2

	; Check if the shield can defend from this object
	ldh a,(<hFF92)	; $42d4
	ld l,a			; $42d6
	ldh a,(<hFF93)	; $42d7
	ld h,a			; $42d9
	ldh a,(<hFF90)	; $42da
	call @checkFlag		; $42dc
	jr z,@checkHitLink		; $42df

	; Check if current object is within the shield's hitbox
	ld hl,wShieldY		; $42e1
	ldi a,(hl)		; $42e4
	ld b,a			; $42e5
	ldi a,(hl)		; $42e6
	ld c,a			; $42e7
	ldh a,(<hActiveObjectType)	; $42e8
	add <Object.collisionRadiusY			; $42ea
	ld e,a			; $42ec
	call checkObjectsCollidedFromVariables		; $42ed
	ld hl,w1Link		; $42f0
	jp c,@handleCollision		; $42f3

	; Not using shield (or shield is ineffective)
@checkHitLink:
	ldh a,(<hActiveObjectType)	; $42f6
	add Object.stunCounter			; $42f8
	ld e,a			; $42fa
	ld a,(de)		; $42fb
	or a			; $42fc
	ret nz			; $42fd

	; Check if the current object responds to link's collisionType
	ld a,(wLinkObjectIndex)		; $42fe
	ld h,a			; $4301
	ld e,a			; $4302
	ld l,<w1Link.collisionType		; $4303
	ld a,(hl)		; $4305
	and $7f			; $4306
	ldh (<hFF90),a	; $4308
	ldh a,(<hFF92)	; $430a
	ld l,a			; $430c
	ldh a,(<hFF93)	; $430d
	ld h,a			; $430f
	ldh a,(<hFF90)	; $4310
	call @checkFlag		; $4312
	ret z			; $4315

	; If link and the current object collide, damage link

	ld h,e			; $4316
	ld l,<w1Link.yh		; $4317
	ld b,(hl)		; $4319
	ld l,<w1Link.xh		; $431a
	ld c,(hl)		; $431c
	ld l,<w1Link.collisionRadiusY		; $431d
	ldh a,(<hActiveObjectType)	; $431f
	add Object.collisionRadiusY			; $4321
	ld e,a			; $4323
	call checkObjectsCollidedFromVariables		; $4324
	jp c,@handleCollision		; $4327
	ret			; $432a

;;
; This appears to behave identically to the checkFlag function in bank 0.
; I guess it's a bit more efficient?
; @param a Bit to check
; @param hl Start of flags
; @addr{432b}
@checkFlag:
	ld b,a			; $432b
	and $f8			; $432c
	rlca			; $432e
	swap a			; $432f
	ld c,a			; $4331
	ld a,b			; $4332
	and $07			; $4333
	ld b,$00		; $4335
	add hl,bc		; $4337
	ld c,(hl)		; $4338
	ld hl,bitTable		; $4339
	add l			; $433c
	ld l,a			; $433d
	ld a,(hl)		; $433e
	and c			; $433f
	ret			; $4340

;;
; @param de Object 1 (Enemy/Part?)
; @param hl Object 2 (Link/Item?)
; @param hFF8D Y-position?
; @param hFF8E X-position?
; @param hFF90 Collision type
; @addr{4341}
@handleCollision:
	ld a,l			; $4341
	and $c0			; $4342
	ld l,a			; $4344
	push hl			; $4345
	ld a,WEAPON_ITEM_INDEX		; $4346
	cp h			; $4348
	jr nz,@notWeaponItem		; $4349

@weaponItem:
	ld a,(w1Link.yh)		; $434b
	ld b,a			; $434e
	ld a,(w1Link.xh)		; $434f
	jr ++			; $4352

@notWeaponItem:
	ldh a,(<hFF8D)	; $4354
	ld b,a			; $4356
	ldh a,(<hFF8C)	; $4357

++
	ld c,a			; $4359
	call objectGetRelativeAngleWithTempVars		; $435a
	ldh (<hFF8A),a	; $435d
	ldh a,(<hActiveObjectType)	; $435f
	add Object.enemyCollisionMode			; $4361
	ld e,a			; $4363
	ld a,(de)		; $4364
	add a			; $4365
	call multiplyABy16		; $4366
	ld hl,objectCollisionTable		; $4369
	add hl,bc		; $436c
	pop bc			; $436d
	ldh a,(<hFF90)	; $436e
	rst_addAToHl			; $4370
	ld a,(hl)		; $4371
	rst_jumpTable			; $4372
	.dw _collisionEffect00
	.dw _collisionEffect01
	.dw _collisionEffect02
	.dw _collisionEffect03
	.dw _collisionEffect04
	.dw _collisionEffect05
	.dw _collisionEffect06
	.dw _collisionEffect07
	.dw _collisionEffect08
	.dw _collisionEffect09
	.dw _collisionEffect0a
	.dw _collisionEffect0b
	.dw _collisionEffect0c
	.dw _collisionEffect0d
	.dw _collisionEffect0e
	.dw _collisionEffect0f
	.dw _collisionEffect10
	.dw _collisionEffect11
	.dw _collisionEffect12
	.dw _collisionEffect13
	.dw _collisionEffect14
	.dw _collisionEffect15
	.dw _collisionEffect16
	.dw _collisionEffect17
	.dw _collisionEffect18
	.dw _collisionEffect19
	.dw _collisionEffect1a
	.dw _collisionEffect1b
	.dw _collisionEffect1c
	.dw _collisionEffect1d
	.dw _collisionEffect1e
	.dw _collisionEffect1f
	.dw _collisionEffect20
	.dw _collisionEffect21
	.dw _collisionEffect22
	.dw _collisionEffect23
	.dw _collisionEffect24
	.dw _collisionEffect25
	.dw _collisionEffect26
	.dw _collisionEffect27
	.dw _collisionEffect28
	.dw _collisionEffect29
	.dw _collisionEffect2a
	.dw _collisionEffect2b
	.dw _collisionEffect2c
	.dw _collisionEffect2d
	.dw _collisionEffect2e
	.dw _collisionEffect2f
	.dw _collisionEffect30
	.dw _collisionEffect31
	.dw _collisionEffect32
	.dw _collisionEffect33
	.dw _collisionEffect34
	.dw _collisionEffect35
	.dw _collisionEffect36
	.dw _collisionEffect37
	.dw _collisionEffect38
	.dw _collisionEffect39
	.dw _collisionEffect3a
	.dw _collisionEffect3b
	.dw _collisionEffect3c
	.dw _collisionEffect3d
	.dw _collisionEffect3e
	.dw _collisionEffect3f

; Parameters which get passed to collision code functions:
; bc = link / item object (points to the start of the object)
; de = enemy / part object (points to Object.enemyCollisionMode)

;;
; COLLISIONEFFECT_NONE
; @addr{43f3}
_collisionEffect00:
	ret			; $43f3

;;
; COLLISIONEFFECT_DAMAGE_LINK_WITH_RING_MODIFIER
; This is the same as COLLISIONEFFECT_DAMAGE_LINK, but it checks for rings that reduce or
; prevent damage.
; @addr{43f4}
_collisionEffect3c:
	; Get Object.id
	ldh a,(<hActiveObjectType)	; $43f4
	inc a			; $43f6
	ld e,a			; $43f7
	ld a,(de)		; $43f8
	ld c,a			; $43f9

	; Try to find the id in @ringProtections
	ld hl,@ringProtections		; $43fa
--
	ldi a,(hl)		; $43fd
	or a			; $43fe
	jr z,_collisionEffect02	; $43ff

	cp c			; $4401
	ldi a,(hl)		; $4402
	jr nz,--		; $4403

	; If the id was found, check if the corresponding ring is equipped
	ld c,a			; $4405
	and $7f			; $4406
	call cpActiveRing		; $4408
	jr nz,_collisionEffect02	; $440b

	; If bit 7 is unset, destroy the projectile
	bit 7,c			; $440d
	ld a,ENEMYDMG_40		; $440f
	jp z,_applyDamageToEnemyOrPart		; $4411

	; Else, hit link but halve the damage
	call _collisionEffect02		; $4414
	ld h,b			; $4417
	ld l,<w1Link.damageToApply		; $4418
	sra (hl)		; $441a
	ret			; $441c

; @addr{441d}
@ringProtections:
	.db ENEMYID_BLADE_TRAP		$80|GREEN_LUCK_RING
	.db PARTID_OCTOROK_PROJECTILE	$00|RED_HOLY_RING
	.db PARTID_ZORA_FIRE		$00|BLUE_HOLY_RING
	.db PARTID_BEAM			$80|BLUE_LUCK_RING
	.db $00

;;
; COLLISIONEFFECT_DAMAGE_LINK_LOW_KNOCKBACK
; @addr{4426}
_collisionEffect01:
	ld e,LINKDMG_00		; $4426
	jr ++			; $4428

;;
; COLLISIONEFFECT_DAMAGE_LINK
; @addr{442a}
_collisionEffect02:
	ld e,LINKDMG_04		; $442a
	jr ++			; $442c

;;
; COLLISIONEFFECT_DAMAGE_LINK_HIGH_KNOCKBACK
; @addr{442e}
_collisionEffect03:
	ld e,LINKDMG_08		; $442e
	jr ++			; $4430

;;
; COLLISIONEFFECT_DAMAGE_LINK_NO_KNOCKBACK
; @addr{4432}
_collisionEffect04:
	ld e,LINKDMG_0c		; $4432
++
	call _applyDamageToLink_paramE		; $4434
	ld a,ENEMYDMG_1c		; $4437
	jp _applyDamageToEnemyOrPart		; $4439

;;
; COLLISIONEFFECT_SWORD_LOW_KNOCKBACK
; @addr{443c}
_collisionEffect08:
	ld e,ENEMYDMG_00		; $443c
	jr _label_07_027		; $443e

;;
; COLLISIONEFFECT_SWORD
; @addr{4440}
_collisionEffect09:
	ld e,ENEMYDMG_04		; $4440
	jr _label_07_027		; $4442

;;
; COLLISIONEFFECT_SWORD_HIGH_KNOCKBACK
; @addr{4440}
_collisionEffect0a:
	ld e,ENEMYDMG_08		; $4444
	jr _label_07_027		; $4446

;;
; COLLISIONEFFECT_SWORD_NO_KNOCKBACK
; @addr{4440}
_collisionEffect0b:
	call _func_07_47b7		; $4448
	ret z			; $444b
	ld e,ENEMYDMG_0c		; $444c
	jr _label_07_027		; $444e

;;
; COLLISIONEFFECT_21
; @addr{4450}
_collisionEffect21:
	ld e,ENEMYDMG_30		; $4450
_label_07_027:
	ldh a,(<hActiveObjectType)	; $4452
	add Object.var3e			; $4454
	ld l,a			; $4456
	ld h,d			; $4457
	ld c,Item.var2a		; $4458
	ld a,(bc)		; $445a
	or (hl)			; $445b
	ld (bc),a		; $445c
	ld a,e			; $445d
	jp _applyDamageToEnemyOrPart		; $445e

;;
; COLLISIONEFFECT_BUMP_WITH_CLINK_LOW_KNOCKBACK
; @addr{4461}
_collisionEffect12:
	call _createClinkInteraction		; $4461

;;
; COLLISIONEFFECT_BUMP_LOW_KNOCKBACK
; @addr{4464}
_collisionEffect0c:
	ld e,ENEMYDMG_10		; $4464
	jr _label_07_028		; $4466

;;
; COLLISIONEFFECT_BUMP_WITH_CLINK
; @addr{4468}
_collisionEffect13:
	call _createClinkInteraction		; $4468

;;
; COLLISIONEFFECT_BUMP
; @addr{446b}
_collisionEffect0d:
	ld e,ENEMYDMG_14		; $446b
	jr _label_07_028		; $446d

;;
; COLLISIONEFFECT_BUMP_WITH_CLINK_HIGH_KNOCKBACK
; @addr{446f}
_collisionEffect14:
	call _createClinkInteraction		; $446f

;;
; COLLISIONEFFECT_BUMP_HIGH_KNOCKBACK
; @addr{4472}
_collisionEffect0e:
	ld e,ENEMYDMG_18		; $4472
_label_07_028:
	ldh a,(<hActiveObjectType)	; $4474
	add Object.var3e			; $4476
	ld l,a			; $4478
	ld h,d			; $4479
	ld c,Item.var2a		; $447a
	ld a,(bc)		; $447c
	or (hl)			; $447d
	ld (bc),a		; $447e
	ld a,e			; $447f
	jp _applyDamageToEnemyOrPart		; $4480

;;
; COLLISIONEFFECT_05
; @addr{4483}
_collisionEffect05:
	ldhl LINKDMG_10, ENEMYDMG_1c		; $4483
	jr _applyDamageToBothObjects		; $4486

;;
; COLLISIONEFFECT_06
; @addr{4488}
_collisionEffect06:
	ldhl LINKDMG_14, ENEMYDMG_1c		; $4488
	jr _applyDamageToBothObjects		; $448b

;;
; COLLISIONEFFECT_07
; @addr{448d}
_collisionEffect07:
	ldhl LINKDMG_18, ENEMYDMG_1c		; $448d
	jr _applyDamageToBothObjects		; $4490

;;
; COLLISIONEFFECT_SHIELD_BUMP_WITH_CLINK
; @addr{4492}
_collisionEffect18:
	call _createClinkInteraction		; $4492

;;
; COLLISIONEFFECT_SHIELD_BUMP
; @addr{4495}
_collisionEffect0f:
	ldhl LINKDMG_10, ENEMYDMG_10		; $4495
	jr _applyDamageToBothObjects		; $4498

;;
; COLLISIONEFFECT_SHIELD_BUMP_WITH_CLINK_HIGH_KNOCKBACK
; @addr{449a}
_collisionEffect19:
	call _createClinkInteraction		; $449a

;;
; COLLISIONEFFECT_SHIELD_BUMP_HIGH_KNOCKBACK
; @addr{449d}
_collisionEffect10:
	ldhl LINKDMG_14, ENEMYDMG_14		; $449d
	jr _applyDamageToBothObjects		; $44a0

;;
; COLLISIONEFFECT_15
; @addr{44a2}
_collisionEffect15:
	call _createClinkInteraction		; $44a2
	ldhl LINKDMG_10, ENEMYDMG_34		; $44a5
	jr _applyDamageToBothObjects		; $44a8

;;
; COLLISIONEFFECT_16
; @addr{44aa}
_collisionEffect16:
	call _createClinkInteraction		; $44aa
	ldhl LINKDMG_14, ENEMYDMG_34		; $44ad
	jr _applyDamageToBothObjects		; $44b0

;;
; COLLISIONEFFECT_17
; @addr{44b2}
_collisionEffect17:
	call _createClinkInteraction		; $44b2
	ldhl LINKDMG_18, ENEMYDMG_34		; $44b5
	jr _applyDamageToBothObjects		; $44b8

;;
; COLLISIONEFFECT_1a
; @addr{44ba}
_collisionEffect1a:
	call _createClinkInteraction		; $44ba

;;
; COLLISIONEFFECT_11
; @addr{44bd}
_collisionEffect11:
	ldhl LINKDMG_18, ENEMYDMG_18		; $44bd
	jr _applyDamageToBothObjects		; $44c0

;;
; COLLISIONEFFECT_1b
; @addr{44c2}
_collisionEffect1b:
	call _createClinkInteraction		; $44c2
	ldhl LINKDMG_1c, ENEMYDMG_28		; $44c5
	jr _applyDamageToBothObjects		; $44c8

;;
; COLLISIONEFFECT_1d
; @addr{44ca}
_collisionEffect1d:
	ldhl LINKDMG_0c, ENEMYDMG_04		; $44ca
	jr _applyDamageToBothObjects		; $44cd

;;
; COLLISIONEFFECT_1e
; @addr{44cf}
_collisionEffect1e:
	ldhl LINKDMG_28, ENEMYDMG_34		; $44cf
	jr _applyDamageToBothObjects		; $44d2

;;
; COLLISIONEFFECT_1f
; @addr{44d4}
_collisionEffect1f:
	ldhl LINKDMG_20, ENEMYDMG_34		; $44d4
	jr _applyDamageToBothObjects		; $44d7

;;
; COLLISIONEFFECT_20
; @addr{44d9}
_collisionEffect20:
	ld h,b			; $44d9
	ld l,Item.id		; $44da
	ld a,(hl)		; $44dc
	cp $28			; $44dd
	jr nc,+			; $44df

	ld l,Item.collisionType		; $44e1
	res 7,(hl)		; $44e3
+
	call _func_07_47b7		; $44e5
	ret z			; $44e8

	ldhl LINKDMG_24, ENEMYDMG_44		; $44e9
	jr _applyDamageToBothObjects		; $44ec

;;
; COLLISIONEFFECT_STUN
; @addr{44ee}
_collisionEffect22:
	ldhl LINKDMG_1c, ENEMYDMG_24		; $44ee

;;
; @param h Damage type for link ( / item?)
; @param l Damage type for enemy / part
; @addr{44f1}
_applyDamageToBothObjects:
	ld a,h			; $44f1
	push hl			; $44f2
	call _applyDamageToLink		; $44f3
	pop hl			; $44f6
	ld a,l			; $44f7
	jp _applyDamageToEnemyOrPart		; $44f8

;;
; COLLISIONEFFECT_26
; @addr{44fb}
_collisionEffect26:
	ldhl LINKDMG_1c, ENEMYDMG_34		; $44fb
	jr _applyDamageToBothObjects		; $44fe

;;
; COLLISIONEFFECT_BURN
; @addr{4500}
_collisionEffect27:
	ld h,b			; $4500
	ld l,Item.collisionType		; $4501
	res 7,(hl)		; $4503
	call _func_07_47b7		; $4505
	ret z			; $4508

	call _createFlamePart		; $4509
	ldhl LINKDMG_1c, ENEMYDMG_2c		; $450c
	jr _applyDamageToBothObjects		; $450f

;;
; COLLISIONEFFECT_PEGASUS_SEED
; @addr{4511}
_collisionEffect28:
	ld h,b			; $4511
	ld l,Item.collisionType		; $4512
	res 7,(hl)		; $4514
	call _func_07_47b7		; $4516
	ret z			; $4519

	ldhl LINKDMG_1c, ENEMYDMG_38		; $451a
	jr _applyDamageToBothObjects		; $451d

;;
; COLLISIONEFFECT_3a
; Assumes that the first object is an Enemy, not a Part.
; @addr{451f}
_collisionEffect3a:
	ld e,Enemy.knockbackCounter		; $451f
	ld a,(de)		; $4521
	or a			; $4522
	ret nz			; $4523

;;
; COLLISIONEFFECT_LIKELIKE
; @addr{4524}
_collisionEffect3d:
	ld a,(w1Link.id)		; $4524
	or a			; $4527
	ret nz			; $4528

	ld a,(wWarpsDisabled)		; $4529
	or a			; $452c
	ret nz			; $452d

	ld a,LINK_STATE_GRABBED		; $452e
	ld (wLinkForceState),a		; $4530
	ldhl LINKDMG_2c, ENEMYDMG_1c		; $4533
	jr _applyDamageToBothObjects		; $4536

;;
; COLLISIONEFFECT_2b
; @addr{4538}
_collisionEffect2b:
	ldhl LINKDMG_1c, ENEMYDMG_3c		; $4538
	jr _applyDamageToBothObjects		; $453b

;;
; COLLISIONEFFECT_2c
; @addr{453d}
_collisionEffect2c:
	ldhl LINKDMG_14, ENEMYDMG_30		; $453d
	jr _applyDamageToBothObjects		; $4540

;;
; COLLISIONEFFECT_2f
; @addr{4542}
_collisionEffect2f:
	ldhl LINKDMG_30, ENEMYDMG_04		; $4542
	jr _applyDamageToBothObjects		; $4545

;;
; COLLISIONEFFECT_30
; @addr{4547}
_collisionEffect30:
	ldhl LINKDMG_1c, ENEMYDMG_44		; $4547
	jr _applyDamageToBothObjects		; $454a

;;
; COLLISIONEFFECT_1c
; @addr{454c}
_collisionEffect1c:
	ldhl LINKDMG_1c, ENEMYDMG_1c		; $454c
	jr _applyDamageToBothObjects		; $454f

;;
; COLLISIONEFFECT_SWITCH_HOOK
; @addr{4551}
_collisionEffect2e:
	ld h,d			; $4551
	ldh a,(<hActiveObjectType)	; $4552
	add Object.health			; $4554
	ld l,a			; $4556
	ld a,(hl)		; $4557
	or a			; $4558
	jr z,_collisionEffect1c	; $4559

	; Clear Object.stunCounter, Object.knockbackCounter
	ld a,l			; $455b
	add Object.stunCounter-Object.health			; $455c
	ld l,a			; $455e
	xor a			; $455f
	ldd (hl),a		; $4560
	ldd (hl),a		; $4561

	; l = Object.knockbackAngle
	ldh a,(<hFF8A)	; $4562
	xor $10			; $4564
	ld (hl),a		; $4566

	; l = Object.collisionType
	res 3,l			; $4567
	res 7,(hl)		; $4569

	ld a,l			; $456b
	add Object.state-Object.collisionType			; $456c
	ld l,a			; $456e
	ld (hl),$03		; $456f

	; l = Object.state2
	inc l			; $4571
	ld (hl),$00		; $4572

	; Now do something with link
	ld h,b			; $4574
	ld l,<w1Link.var2a		; $4575
	set 5,(hl)		; $4577
	ld l,<w1Link.collisionType		; $4579
	res 7,(hl)		; $457b
	ld l,<w1Link.relatedObj2		; $457d
	ldh a,(<hActiveObjectType)	; $457f
	ldi (hl),a		; $4581
	ld (hl),d		; $4582
	ret			; $4583

;;
; COLLISIONEFFECT_23
; @addr{4584}
_collisionEffect23:
	ldh a,(<hActiveObjectType)	; $4584
	add Object.health			; $4586
	ld l,a			; $4588
	ld h,d			; $4589
	ld (hl),$00		; $458a
	ret			; $458c

;;
; COLLISIONEFFECT_24
; @addr{458d}
_collisionEffect24:
	ldh a,(<hActiveObjectType)	; $458d
	add Object.var2a			; $458f
	ld e,a			; $4591
	ldh a,(<hFF90)	; $4592
	or $80			; $4594
	ld (de),a		; $4596

	ld a,e			; $4597
	add Object.relatedObj1-Object.var2a			; $4598
	ld l,a			; $459a
	ld h,d			; $459b
	ld (hl),c		; $459c
	inc l			; $459d
	ld (hl),b		; $459e

	ld c,Item.var2a		; $459f
	ld a,$01		; $45a1
	ld (bc),a		; $45a3
	ret			; $45a4

;;
; COLLISIONEFFECT_25
; @addr{45a5}
_collisionEffect25:
	call _killEnemyOrPart		; $45a5
	ld a,l			; $45a8
	add Object.var3f-Object.collisionType			; $45a9
	ld l,a			; $45ab
	set 7,(hl)		; $45ac

	ld c,Item.var2a		; $45ae
	ld a,$02		; $45b0
	ld (bc),a		; $45b2
	ret			; $45b3

;;
; COLLISIONEFFECT_GALE_SEED
; This assumes that second object is an Enemy, NOT a Part. At least, it does when
; func_07_47b7 returns nonzero...
; @addr{45b4}
_collisionEffect29:
	ld h,b			; $45b4
	ld l,Item.collisionType		; $45b5
	res 7,(hl)		; $45b7
	call _func_07_47b7		; $45b9
	ret z			; $45bc

	ld h,d			; $45bd
	ld l,Enemy.var2a		; $45be
	ld (hl),$9e		; $45c0
	ld l,Enemy.stunCounter		; $45c2
	ld (hl),$00		; $45c4
	ld l,Enemy.collisionType		; $45c6
	res 7,(hl)		; $45c8
	ld l,Enemy.state		; $45ca
	ld (hl),$05		; $45cc

	ld l,Enemy.visible		; $45ce
	ld a,(hl)		; $45d0
	and $c0			; $45d1
	or $02			; $45d3
	ld (hl),a		; $45d5

	ld l,Enemy.counter2		; $45d6
	ld (hl),$1e		; $45d8
	ld l,Enemy.speed		; $45da
	ld (hl),$05		; $45dc

	ld l,Enemy.speedZ		; $45de
	ld (hl),$00		; $45e0
	inc l			; $45e2
	ld (hl),$fa		; $45e3

	; Copy item's x/y position to enemy
	ld l,Enemy.yh		; $45e5
	ld c,Item.yh		; $45e7
	ld a,(bc)		; $45e9
	ldi (hl),a		; $45ea
	inc l			; $45eb
	ld c,Item.xh		; $45ec
	ld a,(bc)		; $45ee
	ldi (hl),a		; $45ef

	; l = Enemy.zh
	inc l			; $45f0
	ld a,(hl)		; $45f1
	rlca			; $45f2
	jr c,+			; $45f3
	ld (hl),$ff		; $45f5
+
	call getRandomNumber		; $45f7
	and $18			; $45fa
	ld e,Enemy.angle		; $45fc
	ld (de),a		; $45fe
	ld a,LINKDMG_1c		; $45ff
	jp _applyDamageToLink		; $4601

;;
; COLLISIONEFFECT_2a
; This assumes that the second object is a Part, not an Enemy.
; @addr{4604}
_collisionEffect2a:
	ld h,b			; $4604
	ld l,Item.knockbackCounter		; $4605
	ld a,d			; $4607
	cp (hl)			; $4608
	ret z			; $4609

	ldd (hl),a		; $460a

	; Write to Item.knockbackAngle
	ld e,Part.animParameter		; $460b
	ld a,(de)		; $460d
	ldd (hl),a		; $460e

	; l = Item.var2a
	dec l			; $460f
	set 4,(hl)		; $4610

	ld e,Part.var2a		; $4612
	ldh a,(<hFF90)	; $4614
	or $80			; $4616
	ld (de),a		; $4618
	ret			; $4619

;;
; COLLISIONEFFECT_2d
; @addr{461a}
_collisionEffect2d:
	ld h,b			; $461a
	ld l,Item.var2f		; $461b
	set 5,(hl)		; $461d
	ret			; $461f

;;
; COLLISIONEFFECT_31
; @addr{4620}
_collisionEffect31:
	ld a,ENEMYDMG_34		; $4620
	jp _applyDamageToEnemyOrPart		; $4622

;;
; COLLISIONEFFECT_32
; @addr{4625}
_collisionEffect32:
	ldhl LINKDMG_34, ENEMYDMG_48		; $4625
	jr _label_07_033		; $4628

;;
; COLLISIONEFFECT_33
; @addr{462a}
_collisionEffect33:
	ldhl LINKDMG_38, ENEMYDMG_4c		; $462a
_label_07_033:
	call _applyDamageToBothObjects		; $462d
	jp _createClinkInteraction		; $4630

;;
; COLLISIONEFFECT_34
; @addr{4633}
_collisionEffect34:
	call _createFlamePart		; $4633
	ld h,b			; $4636
	ld l,Item.collisionType		; $4637
	res 7,(hl)		; $4639
	ldhl LINKDMG_1c, ENEMYDMG_2c		; $463b
	call _applyDamageToBothObjects		; $463e
	jr _killEnemyOrPart		; $4641

;;
; COLLISIONEFFECT_35
; @addr{4643}
_collisionEffect35:
	ldhl LINKDMG_1c, ENEMYDMG_1c		; $4643
	call _applyDamageToBothObjects		; $4646

;;
; Set the Enemy/Part's health to zero, disable its collisions?
; @addr{4649}
_killEnemyOrPart:
	ld h,d			; $4649
	ldh a,(<hActiveObjectType)	; $464a
	add Object.health			; $464c
	ld l,a			; $464e
	ld (hl),$00		; $464f

	add Object.collisionType-Object.health			; $4651
	ld l,a			; $4653
	res 7,(hl)		; $4654
	ret			; $4656

;;
; COLLISIONEFFECT_ELECTRIC_SHOCK
; @addr{4657}
_collisionEffect36:
	ld h,d			; $4657
	ldh a,(<hActiveObjectType)	; $4658
	add Object.var2a			; $465a
	ld l,a			; $465c
	ld (hl),$80|ITEMCOLLISION_ELECTRIC_SHOCK		; $465d

	add Object.collisionType-Object.var2a			; $465f
	ld l,a			; $4661
	res 7,(hl)		; $4662

	; Apply damage if green holy ring is not equipped
	ld a,GREEN_HOLY_RING		; $4664
	call cpActiveRing		; $4666
	ld a,$f8		; $4669
	jr nz,+			; $466b
	xor a			; $466d
+
	ld hl,w1Link.damageToApply		; $466e
	ld (hl),a		; $4671

	ld l,<w1Link.knockbackAngle		; $4672
	ldh a,(<hFF8A)	; $4674
	ld (hl),a		; $4676

	ld l,<w1Link.knockbackCounter		; $4677
	ld (hl),$08		; $4679

	ld l,<w1Link.invincibilityCounter		; $467b
	ld (hl),$0c		; $467d

	ld a,(wIsLinkBeingShocked)		; $467f
	or a			; $4682
	jr nz,+			; $4683

	inc a			; $4685
	ld (wIsLinkBeingShocked),a		; $4686
+
	ld h,b			; $4689
	ld l,<Item.collisionType		; $468a
	res 7,(hl)		; $468c

	ld a,LINKDMG_1c		; $468e
	jp _applyDamageToLink		; $4690

;;
; COLLISIONEFFECT_37
; @addr{4693}
_collisionEffect37:
	ldh a,(<hActiveObjectType)	; $4693
	add Object.invincibilityCounter			; $4695
	ld e,a			; $4697
	ld a,(de)		; $4698
	or a			; $4699
	ret nz			; $469a

	ld a,(wWarpsDisabled)		; $469b
	or a			; $469e
	ret nz			; $469f

	ld a,(w1Link.state)		; $46a0
	cp LINK_STATE_NORMAL			; $46a3
	ret nz			; $46a5

	ld a,e			; $46a6
	add Object.collisionType-Object.invincibilityCounter		; $46a7
	ld e,a			; $46a9
	xor a			; $46aa
	ld (de),a		; $46ab

	ld a,LINK_STATE_GRABBED_BY_WALLMASTER		; $46ac
	ld (wLinkForceState),a		; $46ae
	ld a,ENEMYDMG_1c		; $46b1
	jp _applyDamageToEnemyOrPart		; $46b3

;;
; COLLISIONEFFECT_38
; @addr{46b6}
_collisionEffect38:
	ld h,d			; $46b6
	ldh a,(<hActiveObjectType)	; $46b7
	add Object.collisionType			; $46b9
	ld l,a			; $46bb
	res 7,(hl)		; $46bc

	add Object.counter1-Object.collisionType		; $46be
	ld l,a			; $46c0
	ld (hl),$60		; $46c1

	add Object.zh-Object.counter1			; $46c3
	ld l,a			; $46c5
	ld (hl),$00		; $46c6
	ld a,ENEMYDMG_1c		; $46c8
	jp _applyDamageToEnemyOrPart		; $46ca

;;
; COLLISIONEFFECT_39
; @addr{46cd}
_collisionEffect39:
	ret			; $46cd

;;
; COLLISIONEFFECT_3b
; @addr{46ce}
_collisionEffect3b:
	ld a,$02		; $46ce
	call setLinkIDOverride		; $46d0
	ld a,ENEMYDMG_1c		; $46d3
	jp _applyDamageToEnemyOrPart		; $46d5

;;
; COLLISIONEFFECT_3e
; @addr{46d8}
_collisionEffect3e:
	ret			; $46d8

;;
; COLLISIONEFFECT_3f
; @addr{46d9}
_collisionEffect3f:
	ret			; $46d9

;;
; @addr{46da}
_createFlamePart:
	call getFreePartSlot		; $46da
	ret nz			; $46dd

	ld (hl),PARTID_FLAME		; $46de
	ld l,Part.relatedObj1		; $46e0
	ldh a,(<hActiveObjectType)	; $46e2
	ldi (hl),a		; $46e4
	ld (hl),d		; $46e5
	ret			; $46e6

;;
; @addr{46e7}
_createClinkInteraction:
	call getFreeInteractionSlot		; $46e7
	jr nz,@ret		; $46ea

	ld (hl),INTERACID_CLINK		; $46ec
	ldh a,(<hFF8F)	; $46ee
	ld l,a			; $46f0
	ldh a,(<hFF8D)	; $46f1
	sub l			; $46f3
	sra a			; $46f4
	add l			; $46f6
	ld l,Interaction.yh		; $46f7
	ldi (hl),a		; $46f9
	ldh a,(<hFF8E)	; $46fa
	ld l,a			; $46fc
	ldh a,(<hFF8C)	; $46fd
	sub l			; $46ff
	sra a			; $4700
	add l			; $4702
	ld l,Interaction.xh		; $4703
	ld (hl),a		; $4705
@ret:
	ret			; $4706

;;
; Apply damage to the enemy/part
; @param	b	Item/Link object
; @param	d	Enemy/Part object
; @param	e	Enemy damage type (see enum below)
; @param	hFF90	CollisionType
; @addr{4707}
_applyDamageToEnemyOrPart:
	ld hl,@damageTypeTable		; $4707
	rst_addAToHl			; $470a
	ldh a,(<hActiveObjectType)	; $470b
	add Object.health			; $470d
	ld e,a			; $470f
	bit 7,(hl)		; $4710
	jr z,++			; $4712

	; Apply damage
	ld c,Item.damage		; $4714
	ld a,(bc)		; $4716
	ld c,a			; $4717
	ld a,(de)		; $4718
	add c			; $4719
	jr c,+			; $471a
	xor a			; $471c
+
	ld (de),a		; $471d
	jr nz,++		; $471e

	; If health reaches zero, disable collisions
	ld c,e			; $4720
	ld a,e			; $4721
	add Object.collisionType-Object.health		; $4722
	ld e,a			; $4724
	ld a,(de)		; $4725
	res 7,a			; $4726
	ld (de),a		; $4728
	ld e,c			; $4729
++
	; e = Object.var2a
	inc e			; $472a
	ldi a,(hl)		; $472b
	ld c,a			; $472c
	bit 6,c			; $472d
	jr z,+			; $472f

	; Set var2a to the collisionType of the object it collided with
	ldh a,(<hFF90)	; $4731
	or $80			; $4733
	ld (de),a		; $4735
+
	; e = Object.invincibilityCounter
	inc e			; $4736
	ldi a,(hl)		; $4737
	bit 5,c			; $4738
	jr z,+			; $473a
	ld (de),a		; $473c
+
	; e = Object.knockbackCounter
	inc e			; $473d
	inc e			; $473e
	bit 4,c			; $473f
	ldi a,(hl)		; $4741
	jr z,++			; $4742

	; Apply knockback
	ld (de),a		; $4744

	; Calculate value for Object.knockbackAngle
	ldh a,(<hFF8A)	; $4745
	xor $10			; $4747
	dec e			; $4749
	ld (de),a		; $474a
	inc e			; $474b
++
	; e = Object.stunCounter
	inc e			; $474c
	ldi a,(hl)		; $474d
	bit 3,c			; $474e
	jr z,+			; $4750
	ld (de),a		; $4752
+
	ld a,c			; $4753
	and $07			; $4754
	ret z			; $4756

	ld hl,@soundEffects		; $4757
	rst_addAToHl			; $475a
	ld a,(hl)		; $475b
	jp playSound		; $475c

; Data format:
; b0: bit 7: whether to apply damage to the enemy/part
;     bit 6: whether to write something to Object.var2a?
;     bit 5: whether to give invincibility frames
;     bit 4: whether to give knockback
;     bit 3: whether to stun it
;     bits 0-2: sound effect to play
; b1: Value to write to Object.invincibilityFrames (if applicable)
; b2: Value to write to Object.knockbackCounter (if applicable)
; b3: Value to write to Object.stunCounter (if applicable)

; @addr{475f}
@damageTypeTable:
	.db $f1 $10 $08 $00 ; ENEMYDMG_00
	.db $f1 $15 $0b $00 ; ENEMYDMG_04
	.db $f1 $1a $0f $00 ; ENEMYDMG_08
	.db $f1 $20 $00 $00 ; ENEMYDMG_0c
	.db $70 $f0 $08 $00 ; ENEMYDMG_10
	.db $70 $eb $0b $00 ; ENEMYDMG_14
	.db $70 $e6 $0f $00 ; ENEMYDMG_18
	.db $40 $00 $00 $00 ; ENEMYDMG_1c
	.db $e1 $20 $00 $00 ; ENEMYDMG_20
	.db $29 $f0 $00 $78 ; ENEMYDMG_24
	.db $60 $ec $00 $00 ; ENEMYDMG_28
	.db $e8 $a6 $00 $5a ; ENEMYDMG_2c
	.db $f2 $20 $00 $00 ; ENEMYDMG_30
	.db $60 $e4 $00 $00 ; ENEMYDMG_34
	.db $29 $f0 $00 $f0 ; ENEMYDMG_38
	.db $a9 $18 $00 $78 ; ENEMYDMG_3c
	.db $e3 $20 $00 $00 ; ENEMYDMG_40
	.db $50 $00 $00 $00 ; ENEMYDMG_44
	.db $70 $f7 $07 $00 ; ENEMYDMG_48
	.db $70 $f5 $09 $00 ; ENEMYDMG_4c


; @addr{47af}
@soundEffects:
	.db SND_NONE
	.db SND_DAMAGE_ENEMY
	.db SND_BOSS_DAMAGE
	.db SND_CLINK2
	.db SND_NONE
	.db SND_NONE
	.db SND_NONE
	.db SND_NONE

.ENUM 0 EXPORT
	ENEMYDMG_00	dsb 4
	ENEMYDMG_04	dsb 4
	ENEMYDMG_08	dsb 4
	ENEMYDMG_0c	dsb 4
	ENEMYDMG_10	dsb 4
	ENEMYDMG_14	dsb 4
	ENEMYDMG_18	dsb 4
	ENEMYDMG_1c	dsb 4
	ENEMYDMG_20	dsb 4
	ENEMYDMG_24	dsb 4
	ENEMYDMG_28	dsb 4
	ENEMYDMG_2c	dsb 4
	ENEMYDMG_30	dsb 4
	ENEMYDMG_34	dsb 4
	ENEMYDMG_38	dsb 4
	ENEMYDMG_3c	dsb 4
	ENEMYDMG_40	dsb 4
	ENEMYDMG_44	dsb 4
	ENEMYDMG_48	dsb 4
	ENEMYDMG_4c	dsb 4
.ENDE


;;
; @addr{47b7}
_func_07_47b7:
	ld c,Item.id		; $47b7
	ld a,(bc)		; $47b9
	cp ITEMID_MYSTERY_SEED			; $47ba
	ret nz			; $47bc

	ldh a,(<hActiveObjectType)	; $47bd
	add Object.var3f			; $47bf
	ld e,a			; $47c1
	ld a,(de)		; $47c2
	cpl			; $47c3
	bit 5,a			; $47c4
	ret nz			; $47c6

	ld h,b			; $47c7
	ld l,Item.var2a		; $47c8
	ld (hl),$40		; $47ca
	ld l,Item.collisionType		; $47cc
	res 7,(hl)		; $47ce

	ldh a,(<hActiveObjectType)	; $47d0
	add Object.var2a			; $47d2
	ld e,a			; $47d4
	ld a,$9a		; $47d5
	ld (de),a		; $47d7

	ld a,e			; $47d8
	add Object.stunCounter-Object.var2a			; $47d9
	ld e,a			; $47db
	xor a			; $47dc
	ld (de),a		; $47dd
	ret			; $47de

;;
; This can be called for either Link or an item object. (Perhaps other special objects?)
;
; @param	b	Link/Item object
; @param	d	Enemy / part object
; @param	e	Link damage type (see enum below)
; @addr{47df}
_applyDamageToLink_paramE:
	ld a,e			; $47df

;;
; @addr{47e0}
_applyDamageToLink:
	push af			; $47e0
	ldh a,(<hActiveObjectType)	; $47e1
	add Object.var3e			; $47e3
	ld e,a			; $47e5
	ld a,(de)		; $47e6
	ld (wTmpcec0),a		; $47e7
	pop af			; $47ea
	ld hl,@damageTypeTable		; $47eb
	rst_addAToHl			; $47ee

	bit 7,(hl)		; $47ef
	jr z,++			; $47f1

	ldh a,(<hActiveObjectType)	; $47f3
	add Object.damage			; $47f5
	ld e,a			; $47f7
	ld a,(de)		; $47f8
	ld c,Item.damageToApply		; $47f9
	ld (bc),a		; $47fb
++
	ldi a,(hl)		; $47fc
	ld e,a			; $47fd
	ld c,Item.var2a		; $47fe
	ld a,(bc)		; $4800
	ld c,a			; $4801
	ld a,(wTmpcec0)		; $4802
	or c			; $4805
	ld c,Item.var2a		; $4806
	ld (bc),a		; $4808

	; bc = invincibilityCounter
	inc c			; $4809
	ldi a,(hl)		; $480a
	bit 5,e			; $480b
	jr z,+			; $480d
	ld (bc),a		; $480f
+
	; bc = knockbackAngle
	inc c			; $4810
	ldh a,(<hFF8A)	; $4811
	ld (bc),a		; $4813

	; bc = knockbackCounter
	inc c			; $4814
	ldi a,(hl)		; $4815
	bit 4,e			; $4816
	jr z,+			; $4818
	ld (bc),a		; $481a
+
	; bc = stunCounter
	inc c			; $481b
	ldi a,(hl)		; $481c
	bit 4,e			; $481d
	jr z,+			; $481f
	ld (bc),a		; $4821
+
	ld a,e			; $4822
	and $07			; $4823
	ret z			; $4825

	ld hl,@soundEffects		; $4826
	rst_addAToHl			; $4829
	ld a,(hl)		; $482a
	jp playSound		; $482b

; Data format:
; b0: bit 7: whether to apply damage to Link
;     bit 6: does nothing?
;     bit 5: whether to give invincibility frames
;     bit 4: whether to give knockback
;     bit 3: whether to stun it
;     bits 0-2: sound effect to play
; b1: Value to write to Object.invincibilityFrames (if applicable)
; b2: Value to write to Object.knockbackCounter (if applicable)
; b3: Value to write to Object.stunCounter (if applicable)

; @addr{482e}
@damageTypeTable:
	.db $b2 $19 $07 $00 ; LINKDMG_00
	.db $b2 $22 $0f $00 ; LINKDMG_04
	.db $b2 $2a $15 $00 ; LINKDMG_08
	.db $b2 $20 $00 $00 ; LINKDMG_0c
	.db $31 $f8 $0b $00 ; LINKDMG_10
	.db $31 $f1 $13 $00 ; LINKDMG_14
	.db $31 $ea $19 $00 ; LINKDMG_18
	.db $40 $00 $00 $00 ; LINKDMG_1c
	.db $03 $00 $00 $00 ; LINKDMG_20
	.db $c0 $00 $00 $00 ; LINKDMG_24
	.db $13 $00 $10 $00 ; LINKDMG_28
	.db $62 $f4 $00 $00 ; LINKDMG_2c
	.db $c0 $00 $00 $00 ; LINKDMG_30
	.db $31 $fa $06 $00 ; LINKDMG_34
	.db $31 $f8 $08 $00 ; LINKDMG_38

; @addr{486a}
@soundEffects:
	.db SND_NONE
	.db SND_BOMB_LAND
	.db SND_DAMAGE_LINK
	.db SND_CLINK2
	.db SND_BOMB_LAND
	.db SND_BOMB_LAND
	.db SND_BOMB_LAND
	.db SND_BOMB_LAND

.ENUM 0 EXPORT
	LINKDMG_00	dsb 4
	LINKDMG_04	dsb 4
	LINKDMG_08	dsb 4
	LINKDMG_0c	dsb 4
	LINKDMG_10	dsb 4
	LINKDMG_14	dsb 4
	LINKDMG_18	dsb 4
	LINKDMG_1c	dsb 4
	LINKDMG_20	dsb 4
	LINKDMG_24	dsb 4
	LINKDMG_28	dsb 4
	LINKDMG_2c	dsb 4
	LINKDMG_30	dsb 4
	LINKDMG_34	dsb 4
	LINKDMG_38	dsb 4
.ENDE
