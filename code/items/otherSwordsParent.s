;;
; ITEMID_ROD_OF_SEASONS ($07)
_parentItemCode_rodOfSeasons:
.ifdef ROM_SEASONS
	call _clearParentItemIfCantUseSword
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw _parentItemCode_foolsOre@rod_state0
	.dw _parentItemCode_punch@state1
.endif

;;
; ITEMID_BIGGORON_SWORD ($0c)
; @addr{4aa7}
_parentItemCode_biggoronSword:
	call _clearParentItemIfCantUseSword		; $4aa7

.ifdef ROM_AGES
	call _isLinkUnderwater		; $4aaa
	jp nz,_clearParentItem		; $4aad
.endif

	; Biggoron's sword falls through to fool's ore code

;;
; ITEMID_FOOLS_ORE ($1e)
; @addr{4ab0}
_parentItemCode_foolsOre:
	ld e,Item.state		; $4ab0
	ld a,(de)		; $4ab2
	rst_jumpTable			; $4ab3
	.dw @state0
	.dw _parentItemCode_punch@state1

.ifdef ROM_SEASONS
@rod_state0:
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	jr nz,++
.endif

@state0:
	; Don't allow any other items to be used
	ld e,Item.enabled		; $4ab8
	ld a,$ff		; $4aba
	ld (de),a		; $4abc
++
	call updateLinkDirectionFromAngle		; $4abd
	call _parentItemLoadAnimationAndIncState		; $4ac0
	jp itemCreateChild		; $4ac3

;;
; ITEMID_PUNCH ($02)
; @addr{4ac6}
_parentItemCode_punch:
	ld e,Item.state		; $4ac6
	ld a,(de)		; $4ac8
	rst_jumpTable			; $4ac9
	.dw @state0
	.dw @state1

@state0:
	ld e,Item.enabled		; $4ace
	ld a,$ff		; $4ad0
	ld (de),a		; $4ad2

	call updateLinkDirectionFromAngle		; $4ad3

	call _parentItemLoadAnimationAndIncState		; $4ad6

	; hl = physical punch item
	call itemCreateChild		; $4ad9

	; Check for fist ring (weak punch) or expert's ring (strong punch)
	ld a,(wActiveRing)		; $4adc
	cp EXPERTS_RING			; $4adf

.ifdef ROM_SEASONS
	ret nz

.else; ROM_AGES
	jr z,@expertsRing			; $4ae1

	; If link is underwater with fist ring equipped, set animation to LINK_ANIM_MODE_37
	call _isLinkUnderwater		; $4ae3
	ret z			; $4ae6
	ld a,LINK_ANIM_MODE_37		; $4ae7
	jp specialObjectSetAnimationWithLinkData		; $4ae9
.endif

@expertsRing:
	ld l,Item.subid		; $4aec
	inc (hl)		; $4aee
	ld c,LINK_ANIM_MODE_34		; $4aef

.ifdef ROM_AGES
	; Check if riding something
	ld a,(wLinkObjectIndex)		; $4af1
	rrca			; $4af4
	jr nc,+			; $4af5

	; If riding something other than the raft, use LINK_ANIM_MODE_35
	ld a,(w1Companion.id)		; $4af7
	cp SPECIALOBJECTID_RAFT			; $4afa
	jr z,@setAnimation			; $4afc
	inc c			; $4afe
	jr @setAnimation			; $4aff
+
	; If underwater, use LINK_ANIM_MODE_36
	call _isLinkUnderwater		; $4b01
	jr z,@setAnimation			; $4b04
	ld c,LINK_ANIM_MODE_36		; $4b06

.else; ROM_SEASONS
	; Check if riding something
	ld a,(wLinkObjectIndex)		; $4af1
	rrca			; $4af4
	jr nc,@setAnimation			; $4af5
	inc c
.endif

@setAnimation:
	ld a,c			; $4b08
	jp specialObjectSetAnimationWithLinkData		; $4b09

; This is state 1 for: the punch, rod of seasons, biggoron's sword, and fool's ore.
@state1:
	; Wait for the animation to finish, then delete the item
	ld e,Item.animParameter		; $4b0c
	ld a,(de)		; $4b0e
	rlca			; $4b0f
	jp nc,_specialObjectAnimate		; $4b10
	jp _clearParentItem		; $4b13
