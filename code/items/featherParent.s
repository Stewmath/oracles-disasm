;;
; ITEMID_FEATHER ($17)
parentItemCode_feather:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:

.ifdef ROM_AGES
	call isLinkUnderwater
	jr nz,@deleteParent

	; Can't use the feather while using the switch hook
	ld a,(w1ParentItem2.id)
	cp ITEMID_SWITCH_HOOK
	jr z,@deleteParent
.endif

	; No jumping in minecarts / on companions
	ld a,(wLinkObjectIndex)
	rrca
	jr c,@deleteParent

	; No jumping when holding something?
	ld a,(wLinkGrabState)
	or a
	jr nz,@deleteParent

	call isLinkInHole
	jr c,@deleteParent

	ld hl,wLinkSwimmingState
	ldi a,(hl)
	; Check wMagnetGloveState as well
	or (hl)
	jr nz,@deleteParent

	ld a,(wLinkInAir)
	add a
	jr c,@deleteParent

	add a
	jr c,@state1
	jr nz,@deleteParent

	ld a,(w1Link.zh)
	or a
	jr nz,@deleteParent

	; Jump higher in sidescrolling rooms
	ld bc,$fe20
	ld a,(wActiveGroup)
	cp FIRST_SIDESCROLL_GROUP
	jr c,+
	ld bc,$fdd0
+
	ld hl,w1Link.speedZ
	ld (hl),c
	inc l
	ld (hl),b

	ld a,$01

.ifdef ROM_SEASONS
	ld a,(wFeatherLevel)
	cp $02
	ld a,$41
	jr z,++
.endif
	ld a,$01
++
	ld (wLinkInAir),a
	jr nz,@deleteParent

	ld e,Item.state
	ld a,$01
	ld (de),a
	ret

@deleteParent:
	jp clearParentItem

@state1:

.ifdef ROM_AGES
	jp clearParentItem
.else
	ld a,(wLinkInAir)
	bit 5,a
	jr nz,@deleteParent

	call parentItemCheckButtonPressed
	jr z,@deleteParent

	ld hl,w1Link.speedZ
	ldi a,(hl)
	ld h,(hl)
	bit 7,h
	ret nz

	ld l,a
	ld bc,$0100
	call compareHlToBc
	inc a
	ret z

	ld hl,w1Link.speedZ
	ld (hl),<(-$80)
	inc l
	ld (hl),>(-$80)

	push de
	ld d,h
	ld a,LINK_ANIM_MODE_ROCS_CAPE
	call specialObjectSetAnimation
	pop de
	ld hl,wLinkInAir
	set 5,(hl)
	ld a,SND_THROW
	call playSound
	jp clearParentItem
.endif
