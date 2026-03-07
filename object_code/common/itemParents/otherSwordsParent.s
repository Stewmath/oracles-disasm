;;
; ITEM_ROD_OF_SEASONS ($07)
parentItemCode_rodOfSeasons:
.ifdef ROM_SEASONS
	call clearParentItemIfCantUseSword
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw parentItemCode_foolsOre@rod_state0
	.dw parentItemCode_punch@state1
.endif

;;
; ITEM_BIGGORON_SWORD ($0c)
parentItemCode_biggoronSword:
	call clearParentItemIfCantUseSword

.ifdef ROM_AGES
	call isLinkUnderwater
	jp nz,clearParentItem
.endif

	; Biggoron's sword falls through to fool's ore code

;;
; ITEM_FOOLS_ORE ($1e)
parentItemCode_foolsOre:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw parentItemCode_punch@state1

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
	call parentItemLoadAnimationAndIncState
	jp itemCreateChild

;;
; ITEM_PUNCH ($02)
parentItemCode_punch:
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

	call parentItemLoadAnimationAndIncState

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
	call isLinkUnderwater
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
	cp SPECIALOBJECT_RAFT
	jr z,@setAnimation
	inc c
	jr @setAnimation
+
	; If underwater, use LINK_ANIM_MODE_36
	call isLinkUnderwater
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
	jp nc,specialObjectAnimate_optimized
	jp clearParentItem
