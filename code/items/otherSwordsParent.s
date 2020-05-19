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
	call _clearParentItemIfCantUseSword

.ifdef ROM_AGES
	call _isLinkUnderwater
	jp nz,_clearParentItem
.endif

	; Biggoron's sword falls through to fool's ore code

;;
; ITEMID_FOOLS_ORE ($1e)
; @addr{4ab0}
_parentItemCode_foolsOre:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
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
	ld e,Item.enabled
	ld a,$ff
	ld (de),a
++
	call updateLinkDirectionFromAngle
	call _parentItemLoadAnimationAndIncState
	jp itemCreateChild

;;
; ITEMID_PUNCH ($02)
; @addr{4ac6}
_parentItemCode_punch:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld e,Item.enabled
	ld a,$ff
	ld (de),a

	call updateLinkDirectionFromAngle

	call _parentItemLoadAnimationAndIncState

	; hl = physical punch item
	call itemCreateChild

	; Check for fist ring (weak punch) or expert's ring (strong punch)
	ld a,(wActiveRing)
	cp EXPERTS_RING

.ifdef ROM_SEASONS
	ret nz

.else; ROM_AGES
	jr z,@expertsRing

	; If link is underwater with fist ring equipped, set animation to LINK_ANIM_MODE_37
	call _isLinkUnderwater
	ret z
	ld a,LINK_ANIM_MODE_37
	jp specialObjectSetAnimationWithLinkData
.endif

@expertsRing:
	ld l,Item.subid
	inc (hl)
	ld c,LINK_ANIM_MODE_34

.ifdef ROM_AGES
	; Check if riding something
	ld a,(wLinkObjectIndex)
	rrca
	jr nc,+

	; If riding something other than the raft, use LINK_ANIM_MODE_35
	ld a,(w1Companion.id)
	cp SPECIALOBJECTID_RAFT
	jr z,@setAnimation
	inc c
	jr @setAnimation
+
	; If underwater, use LINK_ANIM_MODE_36
	call _isLinkUnderwater
	jr z,@setAnimation
	ld c,LINK_ANIM_MODE_36

.else; ROM_SEASONS
	; Check if riding something
	ld a,(wLinkObjectIndex)
	rrca
	jr nc,@setAnimation
	inc c
.endif

@setAnimation:
	ld a,c
	jp specialObjectSetAnimationWithLinkData

; This is state 1 for: the punch, rod of seasons, biggoron's sword, and fool's ore.
@state1:
	; Wait for the animation to finish, then delete the item
	ld e,Item.animParameter
	ld a,(de)
	rlca
	jp nc,_specialObjectAnimate
	jp _clearParentItem
