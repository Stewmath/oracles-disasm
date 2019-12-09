;;
; Sets the object's animation using Link's animation data tables?
;
; @param	a	Animation (value for SpecialObject.animMode)
; @addr{4412}
specialObjectSetAnimationWithLinkData:
	ld e,SpecialObject.animMode		; $4412
	ld (de),a		; $4414
	add a			; $4415
	ld c,a			; $4416
	ld b,$00		; $4417
	ld a,(w1Link.id)		; $4419
	jr _label_06_032		; $441c

;;
; Same as "specialObjectAnimate" in bank 0, but optimized for this bank?
; @addr{441e}
_specialObjectAnimate:
	ld h,d			; $441e
	ld l,SpecialObject.animCounter		; $441f
	dec (hl)		; $4421
	ret nz			; $4422
	ld l,SpecialObject.animPointer		; $4423
	jr specialObjectNextAnimationFrame		; $4425

;;
; This is called from bank0.specialObjectSetAnimation.
; Called after changing w1Link.animMode (or w1Companion.AnimMode)
;
; @param	bc	Animation index (times 2)
; @param	d	Object
; @addr{4427}
specialObjectSetAnimation_body:
	ld e,SpecialObject.id		; $4427
	ld a,(de)		; $4429

_label_06_032:
	ld hl,specialObjectAnimationTable		; $442a
	rst_addDoubleIndex			; $442d
	ldi a,(hl)		; $442e
	ld h,(hl)		; $442f
	ld l,a			; $4430
	add hl,bc		; $4431

;;
; @param	d	Object
; @param	hl	Address of pointer to animation data
; @addr{4432}
specialObjectNextAnimationFrame:
	ldi a,(hl)		; $4432
	ld h,(hl)		; $4433
	ld l,a			; $4434

	; Check for loop
	ldi a,(hl)		; $4435
	cp $ff			; $4436
	jr nz,+			; $4438

	ld c,(hl)		; $443a
	ld b,a			; $443b
	add hl,bc		; $443c

	ldi a,(hl)		; $443d
+
	ld e,SpecialObject.animCounter		; $443e
	ld (de),a		; $4440

	; SpecialObject.animParameter
	inc e			; $4441
	ldi a,(hl)		; $4442
	ld c,a			; $4443
	ldi a,(hl)		; $4444
	ld (de),a		; $4445

	; SpecialObject.animPointer
	inc e			; $4446
	ld a,l			; $4447
	ld (de),a		; $4448
	inc e			; $4449
	ld a,h			; $444a
	ld (de),a		; $444b

	ld e,SpecialObject.var31		; $444c
	ld a,c			; $444e
	ld (de),a		; $444f
	ret			; $4450


	.include "build/data/specialObjectAnimationPointers.s"

;;
; @addr{44c9}
loadLinkAndCompanionAnimationFrame_body:
	ld a,$ff		; $44c9
	ld (wLinkPushingDirection),a		; $44cb
	ld a,(w1Link.visible)		; $44ce
	rlca			; $44d1
	jr nc,++		; $44d2

	call _func_4553		; $44d4
	ld a,(w1Link.id)		; $44d7
	ld hl,@data		; $44da
	rst_addAToHl			; $44dd
	ld a,b			; $44de
	cp (hl)			; $44df
	jr c,+			; $44e0

	ld a,(w1Link.direction)		; $44e2
	add b			; $44e5
+
	ld h,LINK_OBJECT_INDEX		; $44e6
	call @loadAnimationFrame		; $44e8

++
	; Companion / maple / whatever
	ld hl,w1Companion.visible		; $44eb
	bit 7,(hl)		; $44ee
	ret z			; $44f0

	ld l,<w1Companion.var31		; $44f1
	ld a,(hl)		; $44f3

;;
; @param	a	Frame index?
; @param	h	Object (should be LINK_OBJECT_INDEX ($d0) or COMPANION_OBJECT_INDEX ($d1))
; @addr{44f4}
@loadAnimationFrame:
	ld l,SpecialObject.var32		; $44f4
	cp (hl)			; $44f6
	ret z			; $44f7

	ld (hl),a		; $44f8
	call _getSpecialObjectGraphicsFrame		; $44f9
	ret z			; $44fc

	ld e,SpecialObject.id		; $44fd
	ld a,(de)		; $44ff
	cp SPECIALOBJECTID_MINECART			; $4500
	ld de,$8701		; $4502
	jr c,+			; $4505
	ld d,$86		; $4507
+
	jp queueDmaTransfer		; $4509

; These are animation frame indices; frame indices under the given value don't have link's direction
; added to them?
@data:
	.db $54 ; SPECIALOBJECTID_LINK
	.db $20
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
.ifdef ROM_AGES
	.db $ff ; SPECIALOBJECTID_LINK_CUTSCENE
.else; ROM_SEASONS
	.db $40
.endif
	.db $ff ; SPECIALOBJECTID_LINK_RIDING_ANIMAL

;;
; Gets size, address of graphics to load.
; Also sets w1Link.oamDataAddress.
;
; @param	a	Index of graphics to load
; @param[out]	b	Size of graphics
; @param[out]	c	Bank of graphics
; @param[out]	hl	Address of graphics
; @param[out]	zflag	Set if there are no graphics to load.
; @addr{4516}
_getSpecialObjectGraphicsFrame:
	ld c,a			; $4516
	ld b,$00		; $4517
	ld d,h			; $4519
	ld l,<w1Link.id		; $451a
	ld a,(hl)		; $451c
	ld e,a			; $451d
	ld hl,specialObjectGraphicsTable		; $451e
	rst_addDoubleIndex			; $4521
	ldi a,(hl)		; $4522
	ld h,(hl)		; $4523
	ld l,a			; $4524
	add hl,bc		; $4525
	add hl,bc		; $4526
	add hl,bc		; $4527

	; Byte 0
	ldi a,(hl)		; $4528
	push hl			; $4529
	add a			; $452a
	ld c,a			; $452b
	ld a,e			; $452c
	ld hl,specialObjectOamDataTable		; $452d
	rst_addDoubleIndex			; $4530
	ldi a,(hl)		; $4531
	ld h,(hl)		; $4532
	ld l,a			; $4533
	add hl,bc		; $4534
	ld e,<w1Link.oamDataAddress		; $4535
	ldi a,(hl)		; $4537
	ld (de),a		; $4538
	inc e			; $4539
	ldi a,(hl)		; $453a
	and $3f			; $453b
	ld (de),a		; $453d

	; Bytes 1-2: address of graphics
	pop hl			; $453e
	ldi a,(hl)		; $453f
	ld h,(hl)		; $4540
	ld l,a			; $4541
	or h			; $4542
	ret z			; $4543

	; Bit 0: bank select
	ld a,l			; $4544
	and $01			; $4545
	add :gfx_link		; $4547
	ld c,a			; $4549

	; Bits 1-4: size (divided by 16)
	ld a,l			; $454a
	and $1e			; $454b
	dec a			; $454d
	ld b,a			; $454e

	; Clear bit 4 (bits 0-3 will be ignored by dma)
	res 4,l			; $454f

	; Clear zero flag
	or d			; $4551
	ret			; $4552

;;
; @param[out]	b	Frame index to use (not accounting for direction)
;
; @addr{4553}
_func_4553:
	ld a,(w1Link.id)		; $4553
	or a			; $4556
	jr z,+			; $4557

	ld a,(w1Link.var31)		; $4559
	ld b,a			; $455c
	ret			; $455d
+
	ld hl,w1ParentItem2		; $455e
	ld bc,$0000		; $4561
--
	ld l,Item.var3f		; $4564
	ld a,(hl)		; $4566
	cp c			; $4567
	jr c,+			; $4568

	ld c,a			; $456a
	ld l,Item.var31		; $456b
	ld b,(hl)		; $456d
+
	inc h			; $456e
	ld a,h			; $456f
	cp FIRST_ITEM_INDEX			; $4570
	jr c,--			; $4572

	ld a,(w1Link.var3f)		; $4574
	cp c			; $4577
	ret c			; $4578

	ld a,(w1Link.var31)		; $4579
	ld b,a			; $457c
	ld a,(w1Link.animMode)		; $457d
	cp LINK_ANIM_MODE_WALK			; $4580
	ret nz			; $4582

	call @getLinkWalkingAnimation		; $4583
	add b			; $4586
	ld b,a			; $4587
	ret			; $4588

;;
; Determines what kind of walking animation link should be doing; whether he's pushing
; something, has a shield out, etc.
;
; @param[out]	a	Value written to w1Link.var34
; @addr{4589}
@getLinkWalkingAnimation:
.ifdef ROM_AGES
	ld c,$0a		; $4589
	ld a,(wAreaFlags)		; $458b
	and AREAFLAG_UNDERWATER			; $458e
	jr z,@notUnderwater			; $4590

@underwater:
	call checkLinkPushingAgainstWall		; $4592
	jp nc,@animationFound		; $4595

	ld a,(w1Link.direction)		; $4598
	ld (wLinkPushingDirection),a		; $459b
	jr @animationFound		; $459e
.endif

@notUnderwater:
	ld c,$00		; $45a0
	ld a,(wLinkGrabState)		; $45a2
	bit 6,a			; $45a5
	ret nz			; $45a7

	; Check if he's holding something
	or a			; $45a8
	jr z,+			; $45a9
	ld c,$02		; $45ab
+
	; Check if he's riding a cart / animal
	ld a,(wLinkObjectIndex)		; $45ad
	rrca			; $45b0
	jr nc,+			; $45b1

	; Check if he's riding a minecart
	ld a,(w1Companion.id)		; $45b3
	cp $0a			; $45b6
	jr nz,+			; $45b8
	inc c			; $45ba
+
	; Done if holding something or riding a minecart (or both)
	ld a,c			; $45bb
	or a			; $45bc
	jr nz,@animationFound	; $45bd

	; Check if using magnet gloves
	ld a,(wMagnetGloveState)		; $45bf
	or a			; $45c2
	jr z,+			; $45c3

	ld c,$09		; $45c5
	jr @animationFound		; $45c7
+
	; Check if he's holding out the shield, and what level
	ld a,(wUsingShield)		; $45c9
	or a			; $45cc
	jr z,+			; $45cd

	ld c,$07		; $45cf
	cp $02			; $45d1
	jr c,@animationFound	; $45d3

	inc c			; $45d5
	jr @animationFound		; $45d6
+
	; Don't do push animation while holding a sword, cane, etc.
	ld a,(wLinkTurningDisabled)		; $45d8
	or a			; $45db
	jr nz,@standingAnimation	; $45dc

	; Override to always do push animation?
	ld a,(wForceLinkPushAnimation)		; $45de
	dec a			; $45e1
	jr z,@pushingAnimation	; $45e2

	; Override to never do push animation?
	ld a,(wForceLinkPushAnimation)		; $45e4
	rlca			; $45e7
	jr c,@standingAnimation	; $45e8

	; If link is climbing a vine, he always faces up, so don't do push animation
	ld a,(wLinkClimbingVine)		; $45ea
	ld l,a			; $45ed

	; Also don't while text is active for some reason?
	ld a,(wTextIsActive)		; $45ee
	or l			; $45f1
	jr nz,@standingAnimation	; $45f2

	call checkLinkPushingAgainstWall		; $45f4
	jr nc,@standingAnimation	; $45f7

	; Pushing against a wall
@pushingAnimation:
	ld a,(w1Link.direction)		; $45f9
	ld (wLinkPushingDirection),a		; $45fc
	ld c,$04		; $45ff
	jr @animationFound		; $4601

	; Standard, just walking or standing animation
@standingAnimation:
	ld a,(wInventoryA)		; $4603
	cp ITEMID_SHIELD			; $4606
	jr z,@shieldEquipped	; $4608

	ld a,(wInventoryB)		; $460a
	cp ITEMID_SHIELD			; $460d
	jr nz,@animationFound	; $460f

	; Walking or standing with shield equipped
@shieldEquipped:
	ld c,$05		; $4611
	ld a,(wShieldLevel)		; $4613
	cp $01			; $4616
	jr z,@animationFound	; $4618
	ld c,$06		; $461a

@animationFound:
	ld a,(wLinkClimbingVine)		; $461c
	or a			; $461f
	jr z,+			; $4620

	xor a			; $4622
	ld (w1Link.direction),a		; $4623
+
	ld a,c			; $4626
	add a			; $4627
	add a			; $4628
	ld (w1Link.var34),a		; $4629
	ret			; $462c

;;
; Gets the ID to use for the Link object based on what transformation rings he's wearing
; (see constants/specialObjectTypes.s).
; Under normal circumstances, this will return 0 (SPECIALOBJECTID_LINK).
; @param[out] b Special object ID to use, based on the ring Link is wearing
; @addr{462d}
getTransformedLinkID:
	ld hl,wDisableRingTransformations		; $462d
	ld a,(hl)		; $4630
	or a			; $4631
	jr z,+			; $4632

	dec (hl)		; $4634
	jr ++			; $4635

	; Check whether Link is wearing a ring
+
	; Rings do nothing in sidescrolling, underwater areas
	ld a,(wAreaFlags)		; $4637
.ifdef ROM_AGES
	and AREAFLAG_UNDERWATER | AREAFLAG_SIDESCROLL			; $463a
.else
	and AREAFLAG_40 | AREAFLAG_SIDESCROLL
.endif
	jr nz,++		; $463c

	; Apparently, you can't be transformed when the menu is disabled
	ld a,(wMenuDisabled)		; $463e
	or a			; $4641
	jr nz,++		; $4642

	; Can't be transformed in a shop or while holding something
	ld a,(wInShop)		; $4644
	ld b,a			; $4647
	ld a,(wLinkGrabState)		; $4648
	or b			; $464b
	jr nz,++		; $464c

	ld a,(wActiveRing)		; $464e
	ld e,a			; $4651
	ld hl,@ringToID		; $4652
	call lookupKey		; $4655
	ld b,a			; $4658
	ret			; $4659
++
	ld b,$00		; $465a
	ret			; $465c

@ringToID:
	.db OCTO_RING		SPECIALOBJECTID_LINK_AS_OCTOROK
	.db MOBLIN_RING		SPECIALOBJECTID_LINK_AS_MOBLIN
	.db LIKE_LIKE_RING	SPECIALOBJECTID_LINK_AS_LIKELIKE
	.db SUBROSIAN_RING	SPECIALOBJECTID_LINK_AS_SUBROSIAN
	.db FIRST_GEN_RING	SPECIALOBJECTID_LINK_AS_RETRO
	.db $00

;;
; Updates Link's damageToApply variable to account for damage-modifying rings.
; @param d Link object
; @addr{4668}
linkUpdateDamageToApplyForRings:
	ld e,SpecialObject.damageToApply		; $4668
	ld a,(de)		; $466a
	or a			; $466b
	ret z			; $466c

	ld b,a			; $466d
	ld hl,@ringDamageModifierTable		; $466e
	ld a,(wActiveRing)		; $4671
	ld e,a			; $4674
--
	ldi a,(hl)		; $4675
	or a			; $4676
	jr z,@matchingRingNotFound		; $4677

	cp e			; $4679
	jr z,@matchingRingFound	; $467a
	inc hl			; $467c
	jr --			; $467d

@matchingRingNotFound:
	ld a,e			; $467f
	cp BLUE_RING			; $4680
	jr z,@blueRing			; $4682

	cp GREEN_RING			; $4684
	jr z,@greenRing			; $4686

	cp CURSED_RING			; $4688
	ret nz			; $468a

; Cursed ring: damage *= 2
	ld a,b			; $468b
	add a			; $468c
	jr @writeDamageToApply		; $468d

; Blue ring: damage /= 2
@blueRing:
	ld a,b			; $468f
	sra a			; $4690
	jr @writeDamageToApply		; $4692

; Green ring: damage /= 1.5
@greenRing:
	ld a,b			; $4694
	cpl			; $4695
	inc a			; $4696
	add a			; $4697
	add a			; $4698
	add b			; $4699
	sra a			; $469a
	sra a			; $469c
	cpl			; $469e
	inc a			; $469f
	jr @writeDamageToApply		; $46a0

@matchingRingFound:
	ld a,(hl)		; $46a2
	add b			; $46a3

@writeDamageToApply:
	bit 7,a			; $46a4
	jr nz,+			; $46a6
	ld a,$ff		; $46a8
+
	ld e,SpecialObject.damageToApply		; $46aa
	ld (de),a		; $46ac
	ret			; $46ad

; This is a table of values to add to any amount of damage that Link takes.
; @addr{46ae}
@ringDamageModifierTable:
	.db POWER_RING_L1 $fe
	.db POWER_RING_L2 $fc
	.db POWER_RING_L3 $f8
	.db ARMOR_RING_L1 $01
	.db ARMOR_RING_L2 $02
	.db ARMOR_RING_L3 $03
	.db $00

;;
; Reads w1Link.damageToApply, and reduces Link's health based on this value.
; Also triggers the potion if necessary, and accounts for the protection ring.
; @param d Link object
; @addr{46bb}
linkApplyDamage:
	ld h,d			; $46bb
	ld l,SpecialObject.damageToApply		; $46bc
	ld a,(hl)		; $46be
	ld (hl),$00		; $46bf
	or a			; $46c1
	jr z,++			; $46c2

	; Protection ring does fixed damage on each hit
	ld b,a			; $46c4
	ld a,PROTECTION_RING		; $46c5
	call cpActiveRing		; $46c7
	jr nz,+			; $46ca
	ld b,$f8		; $46cc
+
	; Add the value to w1Link.health. His "real" health variable is at wLinkHealth, so
	; this appears to be used as part of the calculation to reduce that.
	ld l,SpecialObject.health		; $46ce
	ld a,(hl)		; $46d0
	add b			; $46d1
	ld (hl),a		; $46d2
++
	ld l,SpecialObject.var2a		; $46d3
	ld a,(hl)		; $46d5
	or a			; $46d6
	jr z,+			; $46d7

	; Steadfast ring halves knockback
	ld a,STEADFAST_RING		; $46d9
	call cpActiveRing		; $46db
	jr nz,+			; $46de
	ld l,SpecialObject.knockbackCounter		; $46e0
	srl (hl)		; $46e2
+
	ld hl,wLinkHealth		; $46e4
	ld e,SpecialObject.health		; $46e7

	; Make sure that w1Link.health is negative. At this point, w1Link.health is
	; actually being used similarly to w1Link.damageToApply, and doesn't reflect his
	; actual health.
	ld a,(de)		; $46e9
	bit 7,a			; $46ea
	jr z,++			; $46ec

	; Apply the damage (finally update wLinkHealth)
	ld a,(de)		; $46ee
--
	dec (hl)		; $46ef
	add $02			; $46f0
	jr nc,--		; $46f2

	ld (de),a		; $46f4
++
	; Jump if [wLinkHealth] > 0
	ld a,(hl)		; $46f5
	dec a			; $46f6
	rlca			; $46f7
	jr nc,++		; $46f8

; Link's health has reached 0.

	; Replenish health if Link has a potion.
	ld a,TREASURE_POTION		; $46fa
	call checkTreasureObtained		; $46fc
	jr nc,@noPotion			; $46ff

	; [wLinkHealth] = [wLinkMaxHealth]
	ld hl,wLinkMaxHealth		; $4701
	ldd a,(hl)		; $4704
	ld (hl),a		; $4705

	; Set w1Link.health to $01 (again, this doesn't represent his actual health)
	ld a,$01		; $4706
	ld (de),a		; $4708

	ld a,TREASURE_POTION		; $4709
	call loseTreasure		; $470b
	jr ++			; $470e

; Link is dead, and has no potion.
@noPotion:
	; Clear wLinkHealth and w1Link.health
	xor a			; $4710
	ld (de),a		; $4711
	ld (hl),a		; $4712
	ld (wUsingShield),a		; $4713

	ld e,SpecialObject.state		; $4716
	ld a,(de)		; $4718
	cp LINK_STATE_GRABBED			; $4719
	jr z,++			; $471b

	ld a,$ff		; $471d
	ld (wLinkDeathTrigger),a		; $471f
	call clearAllParentItems		; $4722
++
	; Decrement the stun counter every other frame?
	ld a,(wFrameCounter)		; $4725
	rrca			; $4728
	jr nc,++			; $4729

	ld e,SpecialObject.stunCounter		; $472b
	ld a,(de)		; $472d
	or a			; $472e
	jr z,++			; $472f

	dec a			; $4731
	ld (de),a		; $4732
++
	ret			; $4733
