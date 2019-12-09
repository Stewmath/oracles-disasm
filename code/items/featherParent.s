;;
; ITEMID_FEATHER ($17)
; @addr{52f3}
_parentItemCode_feather:
	ld e,Item.state		; $52f3
	ld a,(de)		; $52f5
	rst_jumpTable			; $52f6
	.dw @state0
	.dw @state1

@state0:

.ifdef ROM_AGES
	call _isLinkUnderwater		; $52fb
	jr nz,@deleteParent	; $52fe

	; Can't use the feather while using the switch hook
	ld a,(w1ParentItem2.id)		; $5300
	cp ITEMID_SWITCH_HOOK			; $5303
	jr z,@deleteParent	; $5305
.endif

	; No jumping in minecarts / on companions
	ld a,(wLinkObjectIndex)		; $5307
	rrca			; $530a
	jr c,@deleteParent	; $530b

	; No jumping when holding something?
	ld a,(wLinkGrabState)		; $530d
	or a			; $5310
	jr nz,@deleteParent	; $5311

	call _isLinkInHole		; $5313
	jr c,@deleteParent	; $5316

	ld hl,wLinkSwimmingState		; $5318
	ldi a,(hl)		; $531b
	; Check wMagnetGloveState as well
	or (hl)			; $531c
	jr nz,@deleteParent	; $531d

	ld a,(wLinkInAir)		; $531f
	add a			; $5322
	jr c,@deleteParent	; $5323

	add a			; $5325
	jr c,@state1		; $5326
	jr nz,@deleteParent	; $5328

	ld a,(w1Link.zh)		; $532a
	or a			; $532d
	jr nz,@deleteParent	; $532e

	; Jump higher in sidescrolling rooms
	ld bc,$fe20		; $5330
	ld a,(wActiveGroup)		; $5333
	cp $06			; $5336
	jr c,+			; $5338
	ld bc,$fdd0		; $533a
+
	ld hl,w1Link.speedZ		; $533d
	ld (hl),c		; $5340
	inc l			; $5341
	ld (hl),b		; $5342

	ld a,$01		; $5343

.ifdef ROM_SEASONS
	ld a,(wFeatherLevel)
	cp $02
	ld a,$41
	jr z,++
.endif
	ld a,$01		; $5183
++
	ld (wLinkInAir),a		; $5347
	jr nz,@deleteParent	; $534a

	ld e,Item.state		; $534c
	ld a,$01		; $534e
	ld (de),a		; $5350
	ret			; $5351

@deleteParent:
	jp _clearParentItem		; $5352

@state1:

.ifdef ROM_AGES
	jp _clearParentItem		; $5355
.else
	ld a,(wLinkInAir)
	bit 5,a
	jr nz,@deleteParent

	call _parentItemCheckButtonPressed
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
	jp _clearParentItem
.endif
