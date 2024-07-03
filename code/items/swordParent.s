;;
; ITEM_SWORD ($05)
parentItemCode_sword:
	call clearParentItemIfCantUseSword
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


; Initialization
@state0:
	ld hl,wcc63
	bit 7,(hl)
	jr nz,++

	ld (hl),$00
	call updateLinkDirectionFromAngle

	; If double-edged ring in use, [Item.var3a] = $f8
	ld a,(wLinkHealth)
	cp $05
	jr c,++
	ld a,DBL_EDGED_RING
	call cpActiveRing
	jr nz,++
	ld e,Item.var3a
	ld a,$f8
	ld (de),a
++
	; Initialize child item
	ld hl,w1WeaponItem.enabled
	ld a,(hl)
	or a
	ld b,$40
	call nz,clearMemory
	ld h,d
	ld l,Item.enabled
	set 7,(hl)
	call parentItemLoadAnimationAndIncState
	jp itemCreateChild


; Sword being swung
@state1:
	ld a,(wcc63)
	rlca
	jp c,@label_4c8b

	call specialObjectAnimate_optimized
	ld h,d
	ld e,Item.animParameter
	ld a,(de)
	or a
	jr z,++

	ld l,Item.var3a
	bit 7,(hl)
	jr nz,++
	ld l,Item.enabled
	res 7,(hl)
++
	; Check for bit 7 of animParameter (marks end of swing animation)
	ld l,e
	bit 7,a
	jr nz,@state6

	bit 5,a
	ret z
	res 5,(hl)
	ld a,(wSwordLevel)
	cp $02
	jp nc,@checkCreateSwordBeam
	ret


; State 6: re-initialize after sword poke (also executed after sword swing)
@state6:
	ld a,(w1WeaponItem.var2a)
	or a
	jp nz,@enemyContact

	ld a,(wLinkObjectIndex)
	rrca
	jp c,@deleteSelf
	call parentItemCheckButtonPressed
	jp z,@deleteSelf

	ld a,$01
	ld (wcc63),a

	; Set child item to state 2
	inc a
	ld (w1WeaponItem.state),a

	ld a, $80 | ITEMCOLLISION_SWORD_HELD
	ld (w1WeaponItem.collisionType),a

	ld l,Item.state
	ld (hl),$02

	; [Item.substate] = 0
	inc l
	xor a
	ld (hl),a

	ld l,Item.var3a
	ld (hl),a
	ld l,Item.var3f
	ld (hl),a

	ld l,Item.counter1
	ld (hl),$28

	jp itemEnableLinkMovement

; @param	a	Value of Item.var2a
@enemyContact:
	bit 0,a
	jp z,@deleteSelf

	; Check for double-edged ring
	ld e,Item.var3a
	ld a,(de)
	or a
	jp z,@deleteSelf

	ld hl,w1Link.damageToApply
	add (hl)
	ld (hl),a
	xor a
	ld (de),a
	jp @deleteSelf


; Sword being held, charging swordspin
@state2:
	ld a,(wLinkObjectIndex)
	rrca
	jp c,@deleteSelf
	call parentItemCheckButtonPressed
	jp z,@deleteSelf
	call @checkAndRetForSwordPoke
	ld a,CHARGE_RING
	call cpActiveRing
	ld c,$01
	jr nz,+
	ld c,$04
+
	ld l,Item.counter1
	ld a,(hl)
	sub c
	ld (hl),a
	ret nc

	ld a,ENERGY_RING
	call cpActiveRing
	jr nz,+

	call @createSwordBeam
	jp @triggerSwordPoke
+
	ld l,Item.state
	inc (hl)
	ld l,Item.enabled
	set 7,(hl)
	ld a,$03
	ld (w1WeaponItem.state),a
	ld a,SND_CHARGE_SWORD
	jp playSound


; Sword being held, fully charged
@state3:
	call @checkAndRetForSwordPoke
	call parentItemCheckButtonPressed
	ret nz

@label_4c8b:
	ld h,d
	ld a,$02
	ld (wcc63),a
	ld l,Item.state
	ld (hl),$04
	ld a,SPIN_RING
	call cpActiveRing
	ld a,$05
	jr nz,+
	ld a,$09
+
	ld l,Item.counter1
	ld (hl),a
	ld l,Item.var3f
	ld (hl),$0f

.ifdef ROM_AGES
	call isLinkUnderwater
	ld c,LINK_ANIM_MODE_28
	jr z,+
	ld c,LINK_ANIM_MODE_30
+
	ld a,(w1Link.direction)
	add c

.else; ROM_SEASONS
	ld a,(w1Link.direction)
	add LINK_ANIM_MODE_28
.endif

	call specialObjectSetAnimationWithLinkData
	ld h,d
	ld l,Item.animParameter
	res 6,(hl)

	ld hl,w1WeaponItem.state
	ld (hl),$04
	ld l,Item.var3a
	sla (hl)

	call itemDisableLinkMovement

	ld a,SND_SWORDSPIN
	jp playSound


; Performing a swordspin
@state4:
	call specialObjectAnimate_optimized
	ld h,d
	ld l,Item.animParameter
	bit 7,(hl)
	ret z

	res 7,(hl)
	ld l,Item.counter1
	dec (hl)
	ret nz

	ld a,$05
	ld (w1WeaponItem.state),a
	jp @deleteSelf

; Swordspin ending
@state5:
	call specialObjectAnimate_optimized
	ld h,d
	ld l,Item.animParameter
	bit 7,(hl)
	ret z

	ld l,Item.subid
	ld a,(hl)
	or a
	jr z,@deleteSelf

	; Go to state 6
	ld a,$06
	ld (w1WeaponItem.state),a
	ld l,Item.state
	inc (hl)

	xor a
	ld (w1WeaponItem.var2a),a
	ret


@deleteSelf:
	xor a
	ld (wcc63),a
	jp clearParentItem


; Checks if Link's doing sword poke; sets animations, etc, and returns from the caller if
; so?
@checkAndRetForSwordPoke:
	xor a
	ld e,Item.subid
	ld (de),a

	ld a,(w1WeaponItem.var2a)
	cp $04
	jr z,+
	or a
	jr nz,++
	call checkLinkPushingAgainstWall
	ret nc
+
	ld e,Item.subid
	ld a,$01
	ld (de),a
++
	; Return from caller
	pop hl

	xor a
	ld (w1WeaponItem.collisionType),a

@triggerSwordPoke:
	ld h,d
	ld l,Item.var3f
	ld (hl),$08

	ld l,Item.state
	ld (hl),$05

	call itemDisableLinkMovement

.ifdef ROM_AGES
	call isLinkUnderwater
	ld a,LINK_ANIM_MODE_1f
	jr z,+
	ld a,LINK_ANIM_MODE_2c
+
.else; ROM_SEASONS
	ld a,LINK_ANIM_MODE_1f
.endif
	jp specialObjectSetAnimationWithLinkData

@checkCreateSwordBeam:
	ld c,$08
	ld a,LIGHT_RING_L1
	call cpActiveRing
	jr z,++
	ld c,$0c
	ld a,LIGHT_RING_L2
	call cpActiveRing
	jr z,++
	ld c,$00
++
	ld hl,wLinkHealth
	ldi a,(hl)
	add c
	cp (hl)
	ret c

@createSwordBeam:
	ldbc ITEM_SWORD_BEAM,$00
	ld e,$01
	call getFreeItemSlotWithObjectCap
	ret c

	inc (hl)
	inc l
	ld a,b
	ldi (hl),a
	ld a,c
	ldi (hl),a

	; Copy link direction, angle, & position variables
	push de
	ld de,w1Link.direction
	ld l,Item.direction
	ld b,$08
	call copyMemoryReverse

	pop de
	scf
	ret
