;;
; For each Enemy and each Part, check for collisions with Link and Items.
; @addr{41d1}
checkEnemyAndPartCollisions:
	; Calculate shield position
	ld a,(w1Link.direction)
	add a
	add a
	ld hl,@shieldPositionOffsets
	rst_addAToHl
	ld de,wShieldY
	ld a,(w1Link.yh)
	add (hl)
	ld (de),a
	inc hl
	inc e
	ld a,(w1Link.xh)
	add (hl)
	ld (de),a

	inc hl
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; Check collisions for all Enemies
	ld a,Enemy.start
	ldh (<hActiveObjectType),a
	ld d,FIRST_ENEMY_INDEX
	ld a,d
@nextEnemy:
	ldh (<hActiveObject),a
	ld h,d
	ld l,Enemy.collisionType
	bit 7,(hl)
	jr z,+

	ld a,(hl)
	ld l,Enemy.var2a
	bit 7,(hl)
	call z,_enemyCheckCollisions
+
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	; Check collisions for all Parts
	ld a,Part.start
	ldh (<hActiveObjectType),a
	ld d,FIRST_PART_INDEX
	ld a,d
@nextPart:
	ldh (<hActiveObject),a
	ld h,d
	ld l,Part.collisionType
	bit 7,(hl)
	jr z,+

	ld l,Part.var2a
	bit 7,(hl)
	jr nz,+

	; Check Part.invincibilityCounter
	inc l
	ld a,(hl)
	or a
	call z,_partCheckCollisions
+
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,@nextPart

	ret

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
	ld e,Part.collisionType
	ld a,(de)
	ld hl,partActiveCollisions
	ld e,Part.yh
	jr ++

;;
; Check if the given enemy is colliding with an item or link, and do the appropriate
; action.
; @param a Enemy.collisionType
; @param d Enemy index
; @addr{424b}
_enemyCheckCollisions:
	ld hl,enemyActiveCollisions
	ld e,Enemy.yh

++
	add a
	ld c,a
	ld b,$00
	add hl,bc
	add hl,bc

	; Store pointer for later
	ld a,l
	ldh (<hFF92),a
	ld a,h
	ldh (<hFF93),a

	; Store X in hFF8E, Y in hFF8F, Z in hFF91
	ld h,d
	ld l,e
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ldi a,(hl)
	ldh (<hFF8E),a
	inc l
	ld a,(hl)
	ldh (<hFF91),a

	; Check invincibility
	ld a,l
	add Object.invincibilityCounter-Object.zh
	ld l,a
	ld a,(hl)
	or a
	jr nz,@doneCheckingItems

	; Check collisions with items
	ld h,FIRST_ITEM_INDEX
@checkItem:
	ld l,Item.collisionType
	ld a,(hl)
	bit 7,a
	jr z,@nextItem

	and $7f
	ldh (<hFF90),a
	ld b,a
	ld e,h
	ldh a,(<hFF92)
	ld l,a
	ldh a,(<hFF93)
	ld h,a
	ld a,b
	call @checkFlag
	ld h,e
	jr z,@nextItem

	ld bc,$0e07
	ldh a,(<hFF90)
	cp ITEMCOLLISION_BOMB
	jr nz,++

	ld l,Item.collisionRadiusY
	ld a,(hl)
	ld c,a
	add a
	ld b,a
++
	ld l,Item.zh
	ldh a,(<hFF91)
	sub (hl)
	add c
	cp b
	jr nc,@nextItem

	ld l,Item.yh
	ld b,(hl)
	ld l,Item.xh
	ld c,(hl)
	ld l,Item.collisionRadiusY
	ldh a,(<hActiveObjectType)
	add Object.collisionRadiusY
	ld e,a
	call checkObjectsCollidedFromVariables
	jp c,@handleCollision

@nextItem:
	inc h
	ld a,h
	cp LAST_STANDARD_ITEM_INDEX+1
	jr c,@checkItem

@doneCheckingItems:
	call checkLinkVulnerable
	ret nc

	; Check for collision with link
	; (hl points to link object from the call to checkLinkVulnerable)

	; Check if Z positions are within 7 pixels
	ld l,<w1Link.zh
	ldh a,(<hFF91)
	sub (hl)
	add $07
	cp $0e
	ret nc

	; If the shield is out...
	ld a,(wUsingShield)
	or a
	jr z,@checkHitLink

	; Store shield level as collision type
	ldh (<hFF90),a

	; Check if the shield can defend from this object
	ldh a,(<hFF92)
	ld l,a
	ldh a,(<hFF93)
	ld h,a
	ldh a,(<hFF90)
	call @checkFlag
	jr z,@checkHitLink

	; Check if current object is within the shield's hitbox
	ld hl,wShieldY
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ldh a,(<hActiveObjectType)
	add <Object.collisionRadiusY
	ld e,a
	call checkObjectsCollidedFromVariables
	ld hl,w1Link
	jp c,@handleCollision

	; Not using shield (or shield is ineffective)
@checkHitLink:
	ldh a,(<hActiveObjectType)
	add Object.stunCounter
	ld e,a
	ld a,(de)
	or a
	ret nz

	; Check if the current object responds to link's collisionType
	ld a,(wLinkObjectIndex)
	ld h,a
	ld e,a
	ld l,<w1Link.collisionType
	ld a,(hl)
	and $7f
	ldh (<hFF90),a
	ldh a,(<hFF92)
	ld l,a
	ldh a,(<hFF93)
	ld h,a
	ldh a,(<hFF90)
	call @checkFlag
	ret z

	; If link and the current object collide, damage link

	ld h,e
	ld l,<w1Link.yh
	ld b,(hl)
	ld l,<w1Link.xh
	ld c,(hl)
	ld l,<w1Link.collisionRadiusY
	ldh a,(<hActiveObjectType)
	add Object.collisionRadiusY
	ld e,a
	call checkObjectsCollidedFromVariables
	jp c,@handleCollision
	ret

;;
; This appears to behave identically to the checkFlag function in bank 0.
; I guess it's a bit more efficient?
; @param a Bit to check
; @param hl Start of flags
; @addr{432b}
@checkFlag:
	ld b,a
	and $f8
	rlca
	swap a
	ld c,a
	ld a,b
	and $07
	ld b,$00
	add hl,bc
	ld c,(hl)
	ld hl,bitTable
	add l
	ld l,a
	ld a,(hl)
	and c
	ret

;;
; @param de Object 1 (Enemy/Part?)
; @param hl Object 2 (Link/Item?)
; @param hFF8D Y-position?
; @param hFF8E X-position?
; @param hFF90 Collision type
; @addr{4341}
@handleCollision:
	ld a,l
	and $c0
	ld l,a
	push hl
	ld a,WEAPON_ITEM_INDEX
	cp h
	jr nz,@notWeaponItem

@weaponItem:
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	jr ++

@notWeaponItem:
	ldh a,(<hFF8D)
	ld b,a
	ldh a,(<hFF8C)

++
	ld c,a
	call objectGetRelativeAngleWithTempVars
	ldh (<hFF8A),a
	ldh a,(<hActiveObjectType)
	add Object.enemyCollisionMode
	ld e,a
	ld a,(de)
	add a
	call multiplyABy16
	ld hl,objectCollisionTable
	add hl,bc
	pop bc
	ldh a,(<hFF90)
	rst_addAToHl
	ld a,(hl)
	rst_jumpTable
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
	ret

;;
; COLLISIONEFFECT_DAMAGE_LINK_WITH_RING_MODIFIER
; This is the same as COLLISIONEFFECT_DAMAGE_LINK, but it checks for rings that reduce or
; prevent damage.
; @addr{43f4}
_collisionEffect3c:
	; Get Object.id
	ldh a,(<hActiveObjectType)
	inc a
	ld e,a
	ld a,(de)
	ld c,a

	; Try to find the id in @ringProtections
	ld hl,@ringProtections
--
	ldi a,(hl)
	or a
	jr z,_collisionEffect02

	cp c
	ldi a,(hl)
	jr nz,--

	; If the id was found, check if the corresponding ring is equipped
	ld c,a
	and $7f
	call cpActiveRing
	jr nz,_collisionEffect02

	; If bit 7 is unset, destroy the projectile
	bit 7,c
	ld a,ENEMYDMG_40
	jp z,_applyDamageToEnemyOrPart

	; Else, hit link but halve the damage
	call _collisionEffect02
	ld h,b
	ld l,<w1Link.damageToApply
	sra (hl)
	ret

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
	ld e,LINKDMG_00
	jr ++

;;
; COLLISIONEFFECT_DAMAGE_LINK
; @addr{442a}
_collisionEffect02:
	ld e,LINKDMG_04
	jr ++

;;
; COLLISIONEFFECT_DAMAGE_LINK_HIGH_KNOCKBACK
; @addr{442e}
_collisionEffect03:
	ld e,LINKDMG_08
	jr ++

;;
; COLLISIONEFFECT_DAMAGE_LINK_NO_KNOCKBACK
; @addr{4432}
_collisionEffect04:
	ld e,LINKDMG_0c
++
	call _applyDamageToLink_paramE
	ld a,ENEMYDMG_1c
	jp _applyDamageToEnemyOrPart

;;
; COLLISIONEFFECT_SWORD_LOW_KNOCKBACK
; @addr{443c}
_collisionEffect08:
	ld e,ENEMYDMG_00
	jr _label_07_027

;;
; COLLISIONEFFECT_SWORD
; @addr{4440}
_collisionEffect09:
	ld e,ENEMYDMG_04
	jr _label_07_027

;;
; COLLISIONEFFECT_SWORD_HIGH_KNOCKBACK
; @addr{4440}
_collisionEffect0a:
	ld e,ENEMYDMG_08
	jr _label_07_027

;;
; COLLISIONEFFECT_SWORD_NO_KNOCKBACK
; @addr{4440}
_collisionEffect0b:
	call _func_07_47b7
	ret z
	ld e,ENEMYDMG_0c
	jr _label_07_027

;;
; COLLISIONEFFECT_21
; @addr{4450}
_collisionEffect21:
	ld e,ENEMYDMG_30
_label_07_027:
	ldh a,(<hActiveObjectType)
	add Object.var3e
	ld l,a
	ld h,d
	ld c,Item.var2a
	ld a,(bc)
	or (hl)
	ld (bc),a
	ld a,e
	jp _applyDamageToEnemyOrPart

;;
; COLLISIONEFFECT_BUMP_WITH_CLINK_LOW_KNOCKBACK
; @addr{4461}
_collisionEffect12:
	call _createClinkInteraction

;;
; COLLISIONEFFECT_BUMP_LOW_KNOCKBACK
; @addr{4464}
_collisionEffect0c:
	ld e,ENEMYDMG_10
	jr _label_07_028

;;
; COLLISIONEFFECT_BUMP_WITH_CLINK
; @addr{4468}
_collisionEffect13:
	call _createClinkInteraction

;;
; COLLISIONEFFECT_BUMP
; @addr{446b}
_collisionEffect0d:
	ld e,ENEMYDMG_14
	jr _label_07_028

;;
; COLLISIONEFFECT_BUMP_WITH_CLINK_HIGH_KNOCKBACK
; @addr{446f}
_collisionEffect14:
	call _createClinkInteraction

;;
; COLLISIONEFFECT_BUMP_HIGH_KNOCKBACK
; @addr{4472}
_collisionEffect0e:
	ld e,ENEMYDMG_18
_label_07_028:
	ldh a,(<hActiveObjectType)
	add Object.var3e
	ld l,a
	ld h,d
	ld c,Item.var2a
	ld a,(bc)
	or (hl)
	ld (bc),a
	ld a,e
	jp _applyDamageToEnemyOrPart

;;
; COLLISIONEFFECT_05
; @addr{4483}
_collisionEffect05:
	ldhl LINKDMG_10, ENEMYDMG_1c
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_06
; @addr{4488}
_collisionEffect06:
	ldhl LINKDMG_14, ENEMYDMG_1c
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_07
; @addr{448d}
_collisionEffect07:
	ldhl LINKDMG_18, ENEMYDMG_1c
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_SHIELD_BUMP_WITH_CLINK
; @addr{4492}
_collisionEffect18:
	call _createClinkInteraction

;;
; COLLISIONEFFECT_SHIELD_BUMP
; @addr{4495}
_collisionEffect0f:
	ldhl LINKDMG_10, ENEMYDMG_10
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_SHIELD_BUMP_WITH_CLINK_HIGH_KNOCKBACK
; @addr{449a}
_collisionEffect19:
	call _createClinkInteraction

;;
; COLLISIONEFFECT_SHIELD_BUMP_HIGH_KNOCKBACK
; @addr{449d}
_collisionEffect10:
	ldhl LINKDMG_14, ENEMYDMG_14
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_15
; @addr{44a2}
_collisionEffect15:
	call _createClinkInteraction
	ldhl LINKDMG_10, ENEMYDMG_34
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_16
; @addr{44aa}
_collisionEffect16:
	call _createClinkInteraction
	ldhl LINKDMG_14, ENEMYDMG_34
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_17
; @addr{44b2}
_collisionEffect17:
	call _createClinkInteraction
	ldhl LINKDMG_18, ENEMYDMG_34
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_1a
; @addr{44ba}
_collisionEffect1a:
	call _createClinkInteraction

;;
; COLLISIONEFFECT_11
; @addr{44bd}
_collisionEffect11:
	ldhl LINKDMG_18, ENEMYDMG_18
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_1b
; @addr{44c2}
_collisionEffect1b:
	call _createClinkInteraction
	ldhl LINKDMG_1c, ENEMYDMG_28
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_1d
; @addr{44ca}
_collisionEffect1d:
	ldhl LINKDMG_0c, ENEMYDMG_04
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_1e
; @addr{44cf}
_collisionEffect1e:
	ldhl LINKDMG_28, ENEMYDMG_34
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_1f
; @addr{44d4}
_collisionEffect1f:
	ldhl LINKDMG_20, ENEMYDMG_34
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_20
; @addr{44d9}
_collisionEffect20:
	ld h,b
	ld l,Item.id
	ld a,(hl)
	cp $28
	jr nc,+

	ld l,Item.collisionType
	res 7,(hl)
+
	call _func_07_47b7
	ret z

	ldhl LINKDMG_24, ENEMYDMG_44
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_STUN
; @addr{44ee}
_collisionEffect22:
	ldhl LINKDMG_1c, ENEMYDMG_24

;;
; @param h Damage type for link ( / item?)
; @param l Damage type for enemy / part
; @addr{44f1}
_applyDamageToBothObjects:
	ld a,h
	push hl
	call _applyDamageToLink
	pop hl
	ld a,l
	jp _applyDamageToEnemyOrPart

;;
; COLLISIONEFFECT_26
; @addr{44fb}
_collisionEffect26:
	ldhl LINKDMG_1c, ENEMYDMG_34
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_BURN
; @addr{4500}
_collisionEffect27:
	ld h,b
	ld l,Item.collisionType
	res 7,(hl)
	call _func_07_47b7
	ret z

	call _createFlamePart
	ldhl LINKDMG_1c, ENEMYDMG_2c
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_PEGASUS_SEED
; @addr{4511}
_collisionEffect28:
	ld h,b
	ld l,Item.collisionType
	res 7,(hl)
	call _func_07_47b7
	ret z

	ldhl LINKDMG_1c, ENEMYDMG_38
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_3a
; Assumes that the first object is an Enemy, not a Part.
; @addr{451f}
_collisionEffect3a:
	ld e,Enemy.knockbackCounter
	ld a,(de)
	or a
	ret nz

;;
; COLLISIONEFFECT_LIKELIKE
; @addr{4524}
_collisionEffect3d:
	ld a,(w1Link.id)
	or a
	ret nz

	ld a,(wWarpsDisabled)
	or a
	ret nz

	ld a,LINK_STATE_GRABBED
	ld (wLinkForceState),a
	ldhl LINKDMG_2c, ENEMYDMG_1c
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_2b
; @addr{4538}
_collisionEffect2b:
	ldhl LINKDMG_1c, ENEMYDMG_3c
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_2c
; @addr{453d}
_collisionEffect2c:
	ldhl LINKDMG_14, ENEMYDMG_30
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_2f
; @addr{4542}
_collisionEffect2f:
	ldhl LINKDMG_30, ENEMYDMG_04
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_30
; @addr{4547}
_collisionEffect30:
	ldhl LINKDMG_1c, ENEMYDMG_44
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_1c
; @addr{454c}
_collisionEffect1c:
	ldhl LINKDMG_1c, ENEMYDMG_1c
	jr _applyDamageToBothObjects

;;
; COLLISIONEFFECT_SWITCH_HOOK
; @addr{4551}
_collisionEffect2e:
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.health
	ld l,a
	ld a,(hl)
	or a
	jr z,_collisionEffect1c

	; Clear Object.stunCounter, Object.knockbackCounter
	ld a,l
	add Object.stunCounter-Object.health
	ld l,a
	xor a
	ldd (hl),a
	ldd (hl),a

	; l = Object.knockbackAngle
	ldh a,(<hFF8A)
	xor $10
	ld (hl),a

	; l = Object.collisionType
	res 3,l
	res 7,(hl)

	ld a,l
	add Object.state-Object.collisionType
	ld l,a
	ld (hl),$03

	; l = Object.state2
	inc l
	ld (hl),$00

	; Now do something with link
	ld h,b
	ld l,<w1Link.var2a
	set 5,(hl)
	ld l,<w1Link.collisionType
	res 7,(hl)
	ld l,<w1Link.relatedObj2
	ldh a,(<hActiveObjectType)
	ldi (hl),a
	ld (hl),d
	ret

;;
; COLLISIONEFFECT_23
; @addr{4584}
_collisionEffect23:
	ldh a,(<hActiveObjectType)
	add Object.health
	ld l,a
	ld h,d
	ld (hl),$00
	ret

;;
; COLLISIONEFFECT_24
; @addr{458d}
_collisionEffect24:
	ldh a,(<hActiveObjectType)
	add Object.var2a
	ld e,a
	ldh a,(<hFF90)
	or $80
	ld (de),a

	ld a,e
	add Object.relatedObj1-Object.var2a
	ld l,a
	ld h,d
	ld (hl),c
	inc l
	ld (hl),b

	ld c,Item.var2a
	ld a,$01
	ld (bc),a
	ret

;;
; COLLISIONEFFECT_25
; @addr{45a5}
_collisionEffect25:
	call _killEnemyOrPart
	ld a,l
	add Object.var3f-Object.collisionType
	ld l,a
	set 7,(hl)

	ld c,Item.var2a
	ld a,$02
	ld (bc),a
	ret

;;
; COLLISIONEFFECT_GALE_SEED
; This assumes that second object is an Enemy, NOT a Part. At least, it does when
; func_07_47b7 returns nonzero...
; @addr{45b4}
_collisionEffect29:
	ld h,b
	ld l,Item.collisionType
	res 7,(hl)
	call _func_07_47b7
	ret z

	ld h,d
	ld l,Enemy.var2a
	ld (hl),$9e
	ld l,Enemy.stunCounter
	ld (hl),$00
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.state
	ld (hl),$05

	ld l,Enemy.visible
	ld a,(hl)
	and $c0
	or $02
	ld (hl),a

	ld l,Enemy.counter2
	ld (hl),$1e
	ld l,Enemy.speed
	ld (hl),$05

	ld l,Enemy.speedZ
	ld (hl),$00
	inc l
	ld (hl),$fa

	; Copy item's x/y position to enemy
	ld l,Enemy.yh
	ld c,Item.yh
	ld a,(bc)
	ldi (hl),a
	inc l
	ld c,Item.xh
	ld a,(bc)
	ldi (hl),a

	; l = Enemy.zh
	inc l
	ld a,(hl)
	rlca
	jr c,+
	ld (hl),$ff
+
	call getRandomNumber
	and $18
	ld e,Enemy.angle
	ld (de),a
	ld a,LINKDMG_1c
	jp _applyDamageToLink

;;
; COLLISIONEFFECT_2a
; This assumes that the second object is a Part, not an Enemy.
; @addr{4604}
_collisionEffect2a:
	ld h,b
	ld l,Item.knockbackCounter
	ld a,d
	cp (hl)
	ret z

	ldd (hl),a

	; Write to Item.knockbackAngle
	ld e,Part.animParameter
	ld a,(de)
	ldd (hl),a

	; l = Item.var2a
	dec l
	set 4,(hl)

	ld e,Part.var2a
	ldh a,(<hFF90)
	or $80
	ld (de),a
	ret

;;
; COLLISIONEFFECT_2d
; @addr{461a}
_collisionEffect2d:
	ld h,b
	ld l,Item.var2f
	set 5,(hl)
	ret

;;
; COLLISIONEFFECT_31
; @addr{4620}
_collisionEffect31:
	ld a,ENEMYDMG_34
	jp _applyDamageToEnemyOrPart

;;
; COLLISIONEFFECT_32
; @addr{4625}
_collisionEffect32:
	ldhl LINKDMG_34, ENEMYDMG_48
	jr _label_07_033

;;
; COLLISIONEFFECT_33
; @addr{462a}
_collisionEffect33:
	ldhl LINKDMG_38, ENEMYDMG_4c
_label_07_033:
	call _applyDamageToBothObjects
	jp _createClinkInteraction

;;
; COLLISIONEFFECT_34
; @addr{4633}
_collisionEffect34:
	call _createFlamePart
	ld h,b
	ld l,Item.collisionType
	res 7,(hl)
	ldhl LINKDMG_1c, ENEMYDMG_2c
	call _applyDamageToBothObjects
	jr _killEnemyOrPart

;;
; COLLISIONEFFECT_35
; @addr{4643}
_collisionEffect35:
	ldhl LINKDMG_1c, ENEMYDMG_1c
	call _applyDamageToBothObjects

;;
; Set the Enemy/Part's health to zero, disable its collisions?
; @addr{4649}
_killEnemyOrPart:
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.health
	ld l,a
	ld (hl),$00

	add Object.collisionType-Object.health
	ld l,a
	res 7,(hl)
	ret

;;
; COLLISIONEFFECT_ELECTRIC_SHOCK
; @addr{4657}
_collisionEffect36:
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.var2a
	ld l,a
	ld (hl),$80|ITEMCOLLISION_ELECTRIC_SHOCK

	add Object.collisionType-Object.var2a
	ld l,a
	res 7,(hl)

	; Apply damage if green holy ring is not equipped
	ld a,GREEN_HOLY_RING
	call cpActiveRing
	ld a,$f8
	jr nz,+
	xor a
+
	ld hl,w1Link.damageToApply
	ld (hl),a

	ld l,<w1Link.knockbackAngle
	ldh a,(<hFF8A)
	ld (hl),a

	ld l,<w1Link.knockbackCounter
	ld (hl),$08

	ld l,<w1Link.invincibilityCounter
	ld (hl),$0c

	ld a,(wIsLinkBeingShocked)
	or a
	jr nz,+

	inc a
	ld (wIsLinkBeingShocked),a
+
	ld h,b
	ld l,<Item.collisionType
	res 7,(hl)

	ld a,LINKDMG_1c
	jp _applyDamageToLink

;;
; COLLISIONEFFECT_37
; @addr{4693}
_collisionEffect37:
	ldh a,(<hActiveObjectType)
	add Object.invincibilityCounter
	ld e,a
	ld a,(de)
	or a
	ret nz

	ld a,(wWarpsDisabled)
	or a
	ret nz

	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz

	ld a,e
	add Object.collisionType-Object.invincibilityCounter
	ld e,a
	xor a
	ld (de),a

	ld a,LINK_STATE_GRABBED_BY_WALLMASTER
	ld (wLinkForceState),a
	ld a,ENEMYDMG_1c
	jp _applyDamageToEnemyOrPart

;;
; COLLISIONEFFECT_38
; @addr{46b6}
_collisionEffect38:
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.collisionType
	ld l,a
	res 7,(hl)

	add Object.counter1-Object.collisionType
	ld l,a
	ld (hl),$60

	add Object.zh-Object.counter1
	ld l,a
	ld (hl),$00
	ld a,ENEMYDMG_1c
	jp _applyDamageToEnemyOrPart

;;
; COLLISIONEFFECT_39
; @addr{46cd}
_collisionEffect39:
	ret

;;
; COLLISIONEFFECT_3b
; @addr{46ce}
_collisionEffect3b:
	ld a,$02
	call setLinkIDOverride
	ld a,ENEMYDMG_1c
	jp _applyDamageToEnemyOrPart

;;
; COLLISIONEFFECT_3e
; @addr{46d8}
_collisionEffect3e:
	ret

;;
; COLLISIONEFFECT_3f
; @addr{46d9}
_collisionEffect3f:
	ret

;;
; @addr{46da}
_createFlamePart:
	call getFreePartSlot
	ret nz

	ld (hl),PARTID_FLAME
	ld l,Part.relatedObj1
	ldh a,(<hActiveObjectType)
	ldi (hl),a
	ld (hl),d
	ret

;;
; @addr{46e7}
_createClinkInteraction:
	call getFreeInteractionSlot
	jr nz,@ret

	ld (hl),INTERACID_CLINK
	ldh a,(<hFF8F)
	ld l,a
	ldh a,(<hFF8D)
	sub l
	sra a
	add l
	ld l,Interaction.yh
	ldi (hl),a
	ldh a,(<hFF8E)
	ld l,a
	ldh a,(<hFF8C)
	sub l
	sra a
	add l
	ld l,Interaction.xh
	ld (hl),a
@ret:
	ret

;;
; Apply damage to the enemy/part
; @param	b	Item/Link object
; @param	d	Enemy/Part object
; @param	e	Enemy damage type (see enum below)
; @param	hFF90	CollisionType
; @addr{4707}
_applyDamageToEnemyOrPart:
	ld hl,@damageTypeTable
	rst_addAToHl
	ldh a,(<hActiveObjectType)
	add Object.health
	ld e,a
	bit 7,(hl)
	jr z,++

	; Apply damage
	ld c,Item.damage
	ld a,(bc)
	ld c,a
	ld a,(de)
	add c
	jr c,+
	xor a
+
	ld (de),a
	jr nz,++

	; If health reaches zero, disable collisions
	ld c,e
	ld a,e
	add Object.collisionType-Object.health
	ld e,a
	ld a,(de)
	res 7,a
	ld (de),a
	ld e,c
++
	; e = Object.var2a
	inc e
	ldi a,(hl)
	ld c,a
	bit 6,c
	jr z,+

	; Set var2a to the collisionType of the object it collided with
	ldh a,(<hFF90)
	or $80
	ld (de),a
+
	; e = Object.invincibilityCounter
	inc e
	ldi a,(hl)
	bit 5,c
	jr z,+
	ld (de),a
+
	; e = Object.knockbackCounter
	inc e
	inc e
	bit 4,c
	ldi a,(hl)
	jr z,++

	; Apply knockback
	ld (de),a

	; Calculate value for Object.knockbackAngle
	ldh a,(<hFF8A)
	xor $10
	dec e
	ld (de),a
	inc e
++
	; e = Object.stunCounter
	inc e
	ldi a,(hl)
	bit 3,c
	jr z,+
	ld (de),a
+
	ld a,c
	and $07
	ret z

	ld hl,@soundEffects
	rst_addAToHl
	ld a,(hl)
	jp playSound

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
	ld c,Item.id
	ld a,(bc)
	cp ITEMID_MYSTERY_SEED
	ret nz

	ldh a,(<hActiveObjectType)
	add Object.var3f
	ld e,a
	ld a,(de)
	cpl
	bit 5,a
	ret nz

	ld h,b
	ld l,Item.var2a
	ld (hl),$40
	ld l,Item.collisionType
	res 7,(hl)

	ldh a,(<hActiveObjectType)
	add Object.var2a
	ld e,a
	ld a,$9a
	ld (de),a

	ld a,e
	add Object.stunCounter-Object.var2a
	ld e,a
	xor a
	ld (de),a
	ret

;;
; This can be called for either Link or an item object. (Perhaps other special objects?)
;
; @param	b	Link/Item object
; @param	d	Enemy / part object
; @param	e	Link damage type (see enum below)
; @addr{47df}
_applyDamageToLink_paramE:
	ld a,e

;;
; @addr{47e0}
_applyDamageToLink:
	push af
	ldh a,(<hActiveObjectType)
	add Object.var3e
	ld e,a
	ld a,(de)
	ld (wTmpcec0),a
	pop af
	ld hl,@damageTypeTable
	rst_addAToHl

	bit 7,(hl)
	jr z,++

	ldh a,(<hActiveObjectType)
	add Object.damage
	ld e,a
	ld a,(de)
	ld c,Item.damageToApply
	ld (bc),a
++
	ldi a,(hl)
	ld e,a
	ld c,Item.var2a
	ld a,(bc)
	ld c,a
	ld a,(wTmpcec0)
	or c
	ld c,Item.var2a
	ld (bc),a

	; bc = invincibilityCounter
	inc c
	ldi a,(hl)
	bit 5,e
	jr z,+
	ld (bc),a
+
	; bc = knockbackAngle
	inc c
	ldh a,(<hFF8A)
	ld (bc),a

	; bc = knockbackCounter
	inc c
	ldi a,(hl)
	bit 4,e
	jr z,+
	ld (bc),a
+
	; bc = stunCounter
	inc c
	ldi a,(hl)
	bit 4,e
	jr z,+
	ld (bc),a
+
	ld a,e
	and $07
	ret z

	ld hl,@soundEffects
	rst_addAToHl
	ld a,(hl)
	jp playSound

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
