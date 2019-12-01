;;
; ITEMID_SHIELD ($01)
; @addr{4a57}
_parentItemCode_shield:
	; Verify that the shield can be used
	call @checkShieldIsUsable		; $4a57
	jr nc,@deleteSelf	; $4a5a

	; Return if any other item is in use
	call _checkNoOtherParentItemsInUse		; $4a5c
	ret nz			; $4a5f

	ld e,Item.state		; $4a60
	ld a,(de)		; $4a62
	rst_jumpTable			; $4a63
	.dw @state0
	.dw @state1

@state0:
	; Go to state 1
	ld a,$01		; $4a68
	ld (de),a		; $4a6a

	ld a,SND_SWITCHHOOK		; $4a6b
	call playSound		; $4a6d

@state1:
	; It seems that wUsingShield will get unset from elsewhere each frame, so not
	; running this code would suffice to stop using the shield
	ld a,(wShieldLevel)		; $4a70
	add $00			; $4a73
	ld (wUsingShield),a		; $4a75
	ret			; $4a78

@deleteSelf:
	xor a			; $4a79
	ld (wUsingShield),a		; $4a7a
	jp _clearParentItem		; $4a7d

;;
; @param[out]	cflag	Set if the shield is ok to use (and the button is held)
; @addr{4a80}
@checkShieldIsUsable:
	; Can't use while swimming
	ld a,(wLinkSwimmingState)		; $4a80
	or a			; $4a83
	jr nz,@@disallowShield	; $4a84

	; Check if in a spinner
	ld a,($cc95)		; $4a86
	rlca			; $4a89
	jr c,@@disallowShield	; $4a8a

	; Can't use underwater
	call _isLinkUnderwater		; $4a8c
	jr nz,@@disallowShield	; $4a8f

	; Can use on the raft, but not on any other rides
	ld a,(w1Companion.id)		; $4a91
	cp SPECIALOBJECTID_RAFT			; $4a94
	jr z,+			; $4a96
	ld a,(wLinkObjectIndex)		; $4a98
	rrca			; $4a9b
	jr c,@@disallowShield	; $4a9c
+
	; Shield is allowed; now check that the button is still held
	call _parentItemCheckButtonPressed		; $4a9e
	jr z,@@disallowShield	; $4aa1
	scf			; $4aa3
	ret			; $4aa4

@@disallowShield:
	xor a			; $4aa5
	ret			; $4aa6

;;
; ITEMID_ROD_OF_SEASONS ($07)
; ITEMID_BIGGORON_SWORD ($0c)
; @addr{4aa7}
_parentItemCode_rodOfSeasons:
_parentItemCode_biggoronSword:
	call _clearParentItemIfCantUseSword		; $4aa7
	call _isLinkUnderwater		; $4aaa
	jp nz,_clearParentItem		; $4aad

	; Rod of seasons & biggoron's sword fall through to fool's ore code

;;
; ITEMID_FOOLS_ORE ($1e)
; @addr{4ab0}
_parentItemCode_foolsOre:
	ld e,Item.state		; $4ab0
	ld a,(de)		; $4ab2
	rst_jumpTable			; $4ab3
	.dw @state0
	.dw _parentItemCode_punch@state1

@state0:
	ld e,Item.enabled		; $4ab8
	ld a,$ff		; $4aba
	ld (de),a		; $4abc
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
	jr z,@expertsRing			; $4ae1

; fist ring equipped

	; If link is underwater, set animation to LINK_ANIM_MODE_37
	call _isLinkUnderwater		; $4ae3
	ret z			; $4ae6
	ld a,LINK_ANIM_MODE_37		; $4ae7
	jp specialObjectSetAnimationWithLinkData		; $4ae9

@expertsRing:
	ld l,Item.subid		; $4aec
	inc (hl)		; $4aee
	ld c,LINK_ANIM_MODE_34		; $4aef

	; Check if riding something
	ld a,(wLinkObjectIndex)		; $4af1
	rrca			; $4af4
	jr nc,+			; $4af5

	; If riding something other than the raft, use LINK_ANIM_MODE_35
	ld a,(w1Companion.id)		; $4af7
	cp SPECIALOBJECTID_RAFT			; $4afa
	jr z,++			; $4afc
	inc c			; $4afe
	jr ++			; $4aff
+
	; If underwater, use LINK_ANIM_MODE_36
	call _isLinkUnderwater		; $4b01
	jr z,++			; $4b04
	ld c,LINK_ANIM_MODE_36		; $4b06
++
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

;;
; ITEMID_SWITCH_HOOK ($08)
; @addr{4b16}
_parentItemCode_switchHook:
	ld e,Item.state		; $4b16
	ld a,(de)		; $4b18
	rst_jumpTable			; $4b19
	.dw @state0
	.dw @state1

@state0:
	ld a,(wLinkObjectIndex)		; $4b1e
	rrca			; $4b21
	jp c,_clearParentItem		; $4b22
	ld a,(wLinkInAir)		; $4b25
	or a			; $4b28
	jp nz,_clearParentItem		; $4b29
	call _isLinkInHole		; $4b2c
	jp c,_clearParentItem		; $4b2f

	call updateLinkDirectionFromAngle		; $4b32
	call clearVariousLinkVariables		; $4b35

	; Disable pressing the switch hook button again (set item priority to maximum)
	ld h,d			; $4b38
	ld l,Item.enabled		; $4b39
	ld (hl),$ff		; $4b3b

	call _parentItemLoadAnimationAndIncState		; $4b3d
	call itemCreateChild		; $4b40

	; If underwater, use a different animation
	call _isLinkUnderwater		; $4b43
	ret z			; $4b46
	ld a,LINK_ANIM_MODE_2e		; $4b47
	jp specialObjectSetAnimationWithLinkData		; $4b49

@state1:
	ld a,(w1WeaponItem.var2f)		; $4b4c
	or a			; $4b4f
	jp z,_clearParentItem		; $4b50

	ld (wDisallowMountingCompanion),a		; $4b53
	call clearVariousLinkVariables		; $4b56

	; Cancel the switch hook usage if experiencing knockback?
	ld hl,w1Link.var2a		; $4b59
	ld a,(hl)		; $4b5c
	ld l,<w1Link.knockbackCounter		; $4b5d
	or (hl)			; $4b5f
	ret z			; $4b60

	; Cancel switch hook usage?
	ld hl,w1WeaponItem.var2f		; $4b61
	set 5,(hl)		; $4b64
	ret			; $4b66

;;
; ITEMID_CANE_OF_SOMARIA ($04)
; @addr{4b67}
_parentItemCode_somaria:
	ld e,Item.state		; $4b67
	ld a,(de)		; $4b69
	rst_jumpTable			; $4b6a
	.dw @state0
	.dw @state1

@state0:
	call updateLinkDirectionFromAngle		; $4b6f
	call _parentItemLoadAnimationAndIncState		; $4b72
	jp itemCreateChild		; $4b75

@state1:
	; Delete self when animation is finished
	ld e,Item.animParameter		; $4b78
	ld a,(de)		; $4b7a
	rlca			; $4b7b
	jp nc,_specialObjectAnimate		; $4b7c
	jp _clearParentItem		; $4b7f

;;
; ITEMID_SWORD ($05)
; @addr{4b82}
_parentItemCode_sword:
	call _clearParentItemIfCantUseSword		; $4b82
	ld e,Item.state		; $4b85
	ld a,(de)		; $4b87
	rst_jumpTable			; $4b88

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6


; Initialization
@state0:
	ld hl,$cc63		; $4b97
	bit 7,(hl)		; $4b9a
	jr nz,++		; $4b9c

	ld (hl),$00		; $4b9e
	call updateLinkDirectionFromAngle		; $4ba0

	; If double-edged ring in use, [Item.var3a] = $f8
	ld a,(wLinkHealth)		; $4ba3
	cp $05			; $4ba6
	jr c,++			; $4ba8
	ld a,DBL_EDGED_RING		; $4baa
	call cpActiveRing		; $4bac
	jr nz,++		; $4baf
	ld e,Item.var3a		; $4bb1
	ld a,$f8		; $4bb3
	ld (de),a		; $4bb5
++
	; Initialize child item
	ld hl,w1WeaponItem.enabled		; $4bb6
	ld a,(hl)		; $4bb9
	or a			; $4bba
	ld b,$40		; $4bbb
	call nz,clearMemory		; $4bbd
	ld h,d			; $4bc0
	ld l,Item.enabled		; $4bc1
	set 7,(hl)		; $4bc3
	call _parentItemLoadAnimationAndIncState		; $4bc5
	jp itemCreateChild		; $4bc8


; Sword being swung
@state1:
	ld a,($cc63)		; $4bcb
	rlca			; $4bce
	jp c,@label_4c8b		; $4bcf

	call _specialObjectAnimate		; $4bd2
	ld h,d			; $4bd5
	ld e,Item.animParameter		; $4bd6
	ld a,(de)		; $4bd8
	or a			; $4bd9
	jr z,++			; $4bda

	ld l,Item.var3a		; $4bdc
	bit 7,(hl)		; $4bde
	jr nz,++			; $4be0
	ld l,Item.enabled		; $4be2
	res 7,(hl)		; $4be4
++
	; Check for bit 7 of animParameter (marks end of swing animation)
	ld l,e			; $4be6
	bit 7,a			; $4be7
	jr nz,@state6		; $4be9

	bit 5,a			; $4beb
	ret z			; $4bed
	res 5,(hl)		; $4bee
	ld a,(wSwordLevel)		; $4bf0
	cp $02			; $4bf3
	jp nc,@checkCreateSwordBeam		; $4bf5
	ret			; $4bf8


; State 6: re-initialize after sword poke (also executed after sword swing)
@state6:
	ld a,(w1WeaponItem.var2a)		; $4bf9
	or a			; $4bfc
	jp nz,@enemyContact		; $4bfd

	ld a,(wLinkObjectIndex)		; $4c00
	rrca			; $4c03
	jp c,@deleteSelf		; $4c04
	call _parentItemCheckButtonPressed		; $4c07
	jp z,@deleteSelf		; $4c0a

	ld a,$01		; $4c0d
	ld ($cc63),a		; $4c0f

	; Set child item to state 2
	inc a			; $4c12
	ld (w1WeaponItem.state),a		; $4c13

	ld a, $80 | ITEMCOLLISION_SWORD_HELD		; $4c16
	ld (w1WeaponItem.collisionType),a		; $4c18

	ld l,Item.state		; $4c1b
	ld (hl),$02		; $4c1d

	; [Item.state2] = 0
	inc l			; $4c1f
	xor a			; $4c20
	ld (hl),a		; $4c21

	ld l,Item.var3a		; $4c22
	ld (hl),a		; $4c24
	ld l,Item.var3f		; $4c25
	ld (hl),a		; $4c27

	ld l,Item.counter1		; $4c28
	ld (hl),$28		; $4c2a

	jp _itemEnableLinkMovement		; $4c2c

; @param	a	Value of Item.var2a
@enemyContact:
	bit 0,a			; $4c2f
	jp z,@deleteSelf		; $4c31

	; Check for double-edged ring
	ld e,Item.var3a		; $4c34
	ld a,(de)		; $4c36
	or a			; $4c37
	jp z,@deleteSelf		; $4c38

	ld hl,w1Link.damageToApply		; $4c3b
	add (hl)		; $4c3e
	ld (hl),a		; $4c3f
	xor a			; $4c40
	ld (de),a		; $4c41
	jp @deleteSelf		; $4c42


; Sword being held, charging swordspin
@state2:
	ld a,(wLinkObjectIndex)		; $4c45
	rrca			; $4c48
	jp c,@deleteSelf		; $4c49
	call _parentItemCheckButtonPressed		; $4c4c
	jp z,@deleteSelf		; $4c4f
	call @checkAndRetForSwordPoke		; $4c52
	ld a,CHARGE_RING		; $4c55
	call cpActiveRing		; $4c57
	ld c,$01		; $4c5a
	jr nz,+			; $4c5c
	ld c,$04		; $4c5e
+
	ld l,Item.counter1		; $4c60
	ld a,(hl)		; $4c62
	sub c			; $4c63
	ld (hl),a		; $4c64
	ret nc			; $4c65

	ld a,ENERGY_RING		; $4c66
	call cpActiveRing		; $4c68
	jr nz,+			; $4c6b

	call @createSwordBeam		; $4c6d
	jp @triggerSwordPoke		; $4c70
+
	ld l,Item.state		; $4c73
	inc (hl)		; $4c75
	ld l,Item.enabled		; $4c76
	set 7,(hl)		; $4c78
	ld a,$03		; $4c7a
	ld (w1WeaponItem.state),a		; $4c7c
	ld a,SND_CHARGE_SWORD		; $4c7f
	jp playSound		; $4c81


; Sword being held, fully charged
@state3:
	call @checkAndRetForSwordPoke		; $4c84
	call _parentItemCheckButtonPressed		; $4c87
	ret nz			; $4c8a

@label_4c8b:
	ld h,d			; $4c8b
	ld a,$02		; $4c8c
	ld ($cc63),a		; $4c8e
	ld l,Item.state		; $4c91
	ld (hl),$04		; $4c93
	ld a,SPIN_RING		; $4c95
	call cpActiveRing		; $4c97
	ld a,$05		; $4c9a
	jr nz,+			; $4c9c
	ld a,$09		; $4c9e
+
	ld l,Item.counter1		; $4ca0
	ld (hl),a		; $4ca2
	ld l,Item.var3f		; $4ca3
	ld (hl),$0f		; $4ca5

	call _isLinkUnderwater		; $4ca7
	ld c,LINK_ANIM_MODE_28		; $4caa
	jr z,+			; $4cac
	ld c,LINK_ANIM_MODE_30		; $4cae
+
	ld a,(w1Link.direction)		; $4cb0
	add c			; $4cb3
	call specialObjectSetAnimationWithLinkData		; $4cb4
	ld h,d			; $4cb7
	ld l,Item.animParameter		; $4cb8
	res 6,(hl)		; $4cba

	ld hl,w1WeaponItem.state		; $4cbc
	ld (hl),$04		; $4cbf
	ld l,Item.var3a		; $4cc1
	sla (hl)		; $4cc3

	call _itemDisableLinkMovement		; $4cc5

	ld a,SND_SWORDSPIN		; $4cc8
	jp playSound		; $4cca


; Performing a swordspin
@state4:
	call _specialObjectAnimate		; $4ccd
	ld h,d			; $4cd0
	ld l,Item.animParameter		; $4cd1
	bit 7,(hl)		; $4cd3
	ret z			; $4cd5

	res 7,(hl)		; $4cd6
	ld l,Item.counter1		; $4cd8
	dec (hl)		; $4cda
	ret nz			; $4cdb

	ld a,$05		; $4cdc
	ld (w1WeaponItem.state),a		; $4cde
	jp @deleteSelf		; $4ce1

; Swordspin ending
@state5:
	call _specialObjectAnimate		; $4ce4
	ld h,d			; $4ce7
	ld l,Item.animParameter		; $4ce8
	bit 7,(hl)		; $4cea
	ret z			; $4cec

	ld l,Item.subid		; $4ced
	ld a,(hl)		; $4cef
	or a			; $4cf0
	jr z,@deleteSelf			; $4cf1

	; Go to state 6
	ld a,$06		; $4cf3
	ld (w1WeaponItem.state),a		; $4cf5
	ld l,Item.state		; $4cf8
	inc (hl)		; $4cfa

	xor a			; $4cfb
	ld (w1WeaponItem.var2a),a		; $4cfc
	ret			; $4cff


@deleteSelf:
	xor a			; $4d00
	ld ($cc63),a		; $4d01
	jp _clearParentItem		; $4d04


; Checks if Link's doing sword poke; sets animations, etc, and returns from the caller if
; so?
@checkAndRetForSwordPoke:
	xor a			; $4d07
	ld e,Item.subid		; $4d08
	ld (de),a		; $4d0a

	ld a,(w1WeaponItem.var2a)		; $4d0b
	cp $04			; $4d0e
	jr z,+			; $4d10
	or a			; $4d12
	jr nz,++		; $4d13
	call checkLinkPushingAgainstWall		; $4d15
	ret nc			; $4d18
+
	ld e,Item.subid		; $4d19
	ld a,$01		; $4d1b
	ld (de),a		; $4d1d
++
	; Return from caller
	pop hl			; $4d1e

	xor a			; $4d1f
	ld (w1WeaponItem.collisionType),a		; $4d20

@triggerSwordPoke:
	ld h,d			; $4d23
	ld l,Item.var3f		; $4d24
	ld (hl),$08		; $4d26

	ld l,Item.state		; $4d28
	ld (hl),$05		; $4d2a

	call _itemDisableLinkMovement		; $4d2c
	call _isLinkUnderwater		; $4d2f
	ld a,LINK_ANIM_MODE_1f		; $4d32
	jr z,+			; $4d34
	ld a,LINK_ANIM_MODE_2c		; $4d36
+
	jp specialObjectSetAnimationWithLinkData		; $4d38

@checkCreateSwordBeam:
	ld c,$08		; $4d3b
	ld a,LIGHT_RING_L1		; $4d3d
	call cpActiveRing		; $4d3f
	jr z,++			; $4d42
	ld c,$0c		; $4d44
	ld a,LIGHT_RING_L2		; $4d46
	call cpActiveRing		; $4d48
	jr z,++			; $4d4b
	ld c,$00		; $4d4d
++
	ld hl,wLinkHealth		; $4d4f
	ldi a,(hl)		; $4d52
	add c			; $4d53
	cp (hl)			; $4d54
	ret c			; $4d55

@createSwordBeam:
	ldbc ITEMID_SWORD_BEAM,$00		; $4d56
	ld e,$01		; $4d59
	call _getFreeItemSlotWithObjectCap		; $4d5b
	ret c			; $4d5e

	inc (hl)		; $4d5f
	inc l			; $4d60
	ld a,b			; $4d61
	ldi (hl),a		; $4d62
	ld a,c			; $4d63
	ldi (hl),a		; $4d64

	; Copy link direction, angle, & position variables
	push de			; $4d65
	ld de,w1Link.direction		; $4d66
	ld l,Item.direction		; $4d69
	ld b,$08		; $4d6b
	call copyMemoryReverse		; $4d6d

	pop de			; $4d70
	scf			; $4d71
	ret			; $4d72

;;
; ITEMID_FLUTE ($0e)
; ITEMID_HARP ($11)
; @addr{4d73}
_parentItemCode_flute:
_parentItemCode_harp:
	ld e,Item.state		; $4d73
	ld a,(de)		; $4d75
	rst_jumpTable			; $4d76
	.dw @state0
	.dw @state1

@state0:
	call _checkLinkOnGround		; $4d7b
	jp nz,_clearParentItem		; $4d7e
	ld a,(wInstrumentsDisabledCounter)		; $4d81
	or a			; $4d84
	jp nz,_clearParentItem		; $4d85
	call _isLinkInHole		; $4d88
	jp c,_clearParentItem		; $4d8b
	call _checkNoOtherParentItemsInUse		; $4d8e
	jp nz,_clearParentItem		; $4d91

	ld a,$80		; $4d94
	ld ($cc95),a		; $4d96
	ld a,$7e		; $4d99
	ld (wDisabledObjects),a		; $4d9b

	call _parentItemLoadAnimationAndIncState		; $4d9e

	; Determine what sound to play
	ld b,$00		; $4da1
	call @getSelectedSongAddr		; $4da3
	jr z,+			; $4da6
	ld b,$03		; $4da8
+
	ld a,(hl)		; $4daa
	add b			; $4dab
	ld hl,@sfxList		; $4dac
	rst_addAToHl			; $4daf
	ld a,(hl)		; $4db0
	call playSound		; $4db1

@state1:
	ld hl,w1Link.collisionType		; $4db4
	res 7,(hl)		; $4db7

	; Create floating music note every $20 frames
	call itemDecCounter1		; $4db9
	ld a,(hl)		; $4dbc
	and $1f			; $4dbd
	jr nz,++		; $4dbf

	ld l,Item.animParameter		; $4dc1
	bit 0,(hl)		; $4dc3
	ld bc,$fcf8		; $4dc5
	jr z,+			; $4dc8
	ld c,$08		; $4dca
+
	call getRandomNumber		; $4dcc
	and $01			; $4dcf
	push de			; $4dd1
	ld d,>w1Link		; $4dd2
	call objectCreateFloatingMusicNote		; $4dd4
	pop de			; $4dd7
++
	call _specialObjectAnimate		; $4dd8
	call @getSelectedSongAddr		; $4ddb
	ld a,$ff		; $4dde
	jr z,+			; $4de0
	ld a,(hl)		; $4de2
+
	ld (wLinkPlayingInstrument),a		; $4de3
	ld (wLinkRidingObject),a		; $4de6
	ld c,$80		; $4de9
	jr nz,++			; $4deb
	ld a,(hl)		; $4ded
	or a			; $4dee
	jr nz,++			; $4def
	ld c,$40		; $4df1
++
	ld e,Item.animParameter		; $4df3
	ld a,(de)		; $4df5
	and c			; $4df6
	ret z			; $4df7

; Done playing song

	ld hl,w1Link.collisionType		; $4df8
	set 7,(hl)		; $4dfb
	call @getSelectedSongAddr		; $4dfd
	jr nz,@harp		; $4e00

	; Flute: try to spawn companion
	ldbc INTERACID_COMPANION_SPAWNER, $80		; $4e02
	call objectCreateInteraction		; $4e05

@clearSelf:
	xor a			; $4e08
	ld (wDisabledObjects),a		; $4e09
	ld ($cc95),a		; $4e0c
	jp _clearParentItem		; $4e0f

@tuneEchoesInVain:
	ld bc,TX_5110		; $4e12
	call showText		; $4e15
	jr @clearSelf		; $4e18

@harp:
	; Only allow harp playing on overworld, non-maku tree screens
	ld a,(wAreaFlags)		; $4e1a
	and (AREAFLAG_UNDERWATER|AREAFLAG_SIDESCROLL|AREAFLAG_10|AREAFLAG_DUNGEON|AREAFLAG_INDOORS|AREAFLAG_MAKU)
	jr nz,@clearSelf	; $4e1f

	ld a,(hl)		; $4e21
	rst_jumpTable			; $4e22
	.dw @clearSelf
	.dw @tuneOfEchoes
	.dw @tuneOfCurrents
	.dw @tuneOfAges

@tuneOfEchoes:
	call getThisRoomFlags		; $4e2b
	bit ROOMFLAG_BIT_PORTALSPOT_DISCOVERED,(hl)		; $4e2e
	jr nz,@clearSelf	; $4e30
	jr @tuneEchoesInVain		; $4e32

@tuneOfCurrents:
	; Test AREAFLAG_BIT_PAST
	ld a,(wAreaFlags)		; $4e34
	rlca			; $4e37
	jr nc,@tuneEchoesInVain	; $4e38

@tuneOfAges:
	call restartSound		; $4e3a

	ld a,CUTSCENE_TIMEWARP		; $4e3d
	ld (wCutsceneTrigger),a		; $4e3f

	ld a,$6d		; $4e42
	ld (wDisabledObjects),a		; $4e44
	ld (wDisableLinkCollisionsAndMenu),a		; $4e47
	ld (wcde0),a		; $4e4a
	call clearAllItemsAndPutLinkOnGround		; $4e4d
	jp _specialObjectAnimate		; $4e50

@sfxList:
	.db SND_CRANEGAME
	.db SND_FLUTE_RICKY
	.db SND_FLUTE_DIMITRI
	.db SND_FLUTE_MOOSH
.ifdef ROM_AGES
	.db SND_ECHO
	.db SND_CURRENT
	.db SND_AGES
.endif

;;
; @param[out]	hl	wFluteIcon or wSelectedHarpSong
; @param[out]	zflag	Set if using flute, unset for harp
; @addr{4e5a}
@getSelectedSongAddr:
	ld hl,wFluteIcon		; $4e5a
	ld e,Item.id		; $4e5d
	ld a,(de)		; $4e5f
	cp ITEMID_FLUTE			; $4e60
	ret z			; $4e62
	ld l,<wSelectedHarpSong		; $4e63
	ret			; $4e65

;;
; ITEMID_SHOOTER ($0f)
; ITEMID_SLINGSHOT ($13)
; @addr{4e66}
_parentItemCode_shooter:
_parentItemCode_slingshot:
	ld e,Item.state		; $4e66
	ld a,(de)		; $4e68
	rst_jumpTable			; $4e69
	.dw @state0
	.dw @state1
	.dw @state2

; Initialization
@state0:
	ld a,$01		; $4e70
	call _clearSelfIfNoSeeds		; $4e72

	call updateLinkDirectionFromAngle		; $4e75
	call _parentItemLoadAnimationAndIncState		; $4e78
	call itemCreateChild		; $4e7b
	ld a,(wLinkAngle)		; $4e7e
	bit 7,a			; $4e81
	jr z,@updateAngleFrom5Bit	; $4e83
	ld a,(w1Link.direction)		; $4e85
	add a			; $4e88
	jr @updateAngle		; $4e89


; Waiting for button to be released
@state1:
	ld a,$01		; $4e8b
	call _clearSelfIfNoSeeds		; $4e8d
	call _parentItemCheckButtonPressed		; $4e90
	jr nz,@checkUpdateAngle	; $4e93

; Button released

	ld a,(wIsSeedShooterInUse)		; $4e95
	or a			; $4e98
	jp nz,_clearParentItem		; $4e99

	ld e,Item.relatedObj2+1		; $4e9c
	ld a,>w1Link		; $4e9e
	ld (de),a		; $4ea0

	ld a,$01		; $4ea1
	call _clearSelfIfNoSeeds		; $4ea3

	; Note: here, 'c' = the "behaviour" value from the "_itemUsageParameterTable" for
	; button B, and this will become the subid for the new item? (The only important
	; thing is that it's nonzero, to indicate the seed came from the shooter.)
	push bc			; $4ea6
	ld e,$01		; $4ea7
	call itemCreateChildWithID		; $4ea9

	; Calculate child item's angle?
	ld e,Item.angle		; $4eac
	ld a,(de)		; $4eae
	add a			; $4eaf
	add a			; $4eb0
	ld l,Item.angle		; $4eb1
	ld (hl),a		; $4eb3

	pop bc			; $4eb4
	ld a,b			; $4eb5
	call decNumActiveSeeds		; $4eb6

	call itemIncState		; $4eb9
	ld l,Item.counter2		; $4ebc
	ld (hl),$0c		; $4ebe

	ld a,SND_SEEDSHOOTER		; $4ec0
	jp playSound		; $4ec2


; Waiting for counter to reach 0 before putting away the seed shooter
@state2:
	call itemDecCounter2		; $4ec5
	ret nz			; $4ec8
	ld a,(wLinkAngle)		; $4ec9
	push af			; $4ecc
	ld l,Item.angle		; $4ecd
	ld a,(hl)		; $4ecf
	add a			; $4ed0
	add a			; $4ed1
	ld (wLinkAngle),a		; $4ed2
	call updateLinkDirectionFromAngle		; $4ed5
	pop af			; $4ed8
	ld (wLinkAngle),a		; $4ed9
	jp _clearParentItem		; $4edc


; Note: seed shooter's angle is a value from 0-7, instead of $00-$1f like usual

@updateAngleFrom5Bit:
	rrca			; $4edf
	rrca			; $4ee0
	jr @updateAngle		; $4ee1

@checkUpdateAngle:
	ld a,(wGameKeysJustPressed)		; $4ee3
	and (BTN_RIGHT|BTN_LEFT|BTN_UP|BTN_DOWN)			; $4ee6
	jr nz,+			; $4ee8
	call itemDecCounter2		; $4eea
	jr nz,@determineBaseAnimation	; $4eed
+
	ld a,(wLinkAngle)		; $4eef
	rrca			; $4ef2
	rrca			; $4ef3
	jr c,@determineBaseAnimation	; $4ef4
	ld h,d			; $4ef6
	ld l,Item.angle		; $4ef7
	sub (hl)		; $4ef9
	jr z,@determineBaseAnimation	; $4efa

	bit 2,a			; $4efc
	ld a,$ff		; $4efe
	jr nz,+			; $4f00
	ld a,$01		; $4f02
+
	add (hl)		; $4f04

@updateAngle:
	ld h,d			; $4f05
	ld l,Item.angle		; $4f06
	and $07			; $4f08
	ld (hl),a		; $4f0a
	ld l,Item.counter2		; $4f0b
	ld (hl),$10		; $4f0d

@determineBaseAnimation:
	call _isLinkUnderwater		; $4f0f
	ld a,$48		; $4f12
	jr nz,++		; $4f14
	ld a,(w1Companion.id)		; $4f16
	cp SPECIALOBJECTID_MINECART			; $4f19
	ld a,$40		; $4f1b
	jr z,++			; $4f1d
	ld a,$38		; $4f1f
++
	ld h,d			; $4f21
	ld l,Item.angle		; $4f22
	add (hl)		; $4f24
	ld l,Item.var31		; $4f25
	ld (hl),a		; $4f27
	ld l,Item.var3f		; $4f28
	ld (hl),$04		; $4f2a
	ret			; $4f2c

;;
; ITEMID_SEED_SATCHEL ($19)
; @addr{4f2d}
_parentItemCode_satchel:
	ld e,Item.state		; $4f2d
	ld a,(de)		; $4f2f
	rst_jumpTable			; $4f30
	.dw @state0
	.dw _parentItemGenericState1

@state0:
	ld a,(w1Companion.id)		; $4f35
	cp SPECIALOBJECTID_RAFT			; $4f38
	jp z,_clearParentItem		; $4f3a
	call _isLinkUnderwater		; $4f3d
	jp nz,_clearParentItem		; $4f40
	ld a,(wLinkSwimmingState)		; $4f43
	or a			; $4f46
	jp nz,_clearParentItem		; $4f47

	call _clearSelfIfNoSeeds		; $4f4a

	ld a,b			; $4f4d
	cp $22			; $4f4e
	jr z,@pegasusSeeds	; $4f50

	push bc			; $4f52
	call _parentItemLoadAnimationAndIncState		; $4f53
	pop bc			; $4f56
	push bc			; $4f57
	ld c,$00		; $4f58
	ld e,$01		; $4f5a
	call itemCreateChildWithID		; $4f5c
	pop bc			; $4f5f
	jp c,_clearParentItem		; $4f60

	ld a,b			; $4f63
	jp decNumActiveSeeds		; $4f64

@pegasusSeeds:
	ld hl,wPegasusSeedCounter		; $4f67
	ldi a,(hl)		; $4f6a
	or (hl)			; $4f6b
	jr nz,@clear		; $4f6c

	ld a,$03		; $4f6e
	ldd (hl),a		; $4f70
	ld (hl),$c0		; $4f71

	ld a,b			; $4f73
	call decNumActiveSeeds		; $4f74

	; Create pegasus seed "puffs"?
	ld hl,w1ReservedItemF		; $4f77
	ld a,$03		; $4f7a
	ldi (hl),a		; $4f7c
	ld (hl),ITEMID_DUST		; $4f7d
@clear:
	jp _clearParentItem		; $4f7f

;;
; Gets the number of seeds available, or returns from caller if none are available.
;
; @param	a	0 for satchel, 1 for shooter
; @param[out]	a	# of seeds of that type
; @param[out]	b	Item ID for seed type (value between $20-$24)
; @param[out]	hl	Address of "wNum*Seeds" variable
; @addr{4f82}
_clearSelfIfNoSeeds:
	ld hl,wSatchelSelectedSeeds		; $4f82
	rst_addAToHl			; $4f85
	ld a,(hl)		; $4f86
	ld b,a			; $4f87
	set 5,b			; $4f88
	ld hl,wNumEmberSeeds		; $4f8a

	rst_addAToHl			; $4f8d
	ld a,(hl)		; $4f8e
	or a			; $4f8f
	ret nz			; $4f90
	pop hl			; $4f91
	jp _clearParentItem		; $4f92

;;
; This is "state 1" for the satchel, bombchu, and bomb "parent items". It simply updates
; Link's animation, then deletes the parent.
;
; @addr{4f95}
_parentItemGenericState1:
	ld e,Item.animParameter		; $4f95
	ld a,(de)		; $4f97
	rlca			; $4f98
	jp nc,_specialObjectAnimate		; $4f99
	jp _clearParentItem		; $4f9c


;;
; ITEMID_SHOVEL ($15)
; @addr{4f9f}
_parentItemCode_shovel:
	ld e,Item.state		; $4f9f
	ld a,(de)		; $4fa1
	rst_jumpTable			; $4fa2

	.dw @state0
	.dw @state1

@state0:
	call _checkLinkOnGround		; $4fa7
	jp nz,_clearParentItem		; $4faa
	jp _parentItemLoadAnimationAndIncState		; $4fad

@state1:
	call _specialObjectAnimate		; $4fb0
	ld e,Item.animParameter		; $4fb3
	ld a,(de)		; $4fb5
	bit 7,a			; $4fb6
	jp nz,_clearParentItem		; $4fb8

	; When [animParameter] == 1, create the child item
	dec a			; $4fbb
	ret nz			; $4fbc

	ld (de),a		; $4fbd
	call itemCreateChildIfDoesntExistAlready		; $4fbe

	; Calculate Y/X position to give to child item
	push hl			; $4fc1
	ld l,Item.direction		; $4fc2
	ld a,(hl)		; $4fc4
	ld hl,@offsets		; $4fc5
	rst_addDoubleIndex			; $4fc8
	ldi a,(hl)		; $4fc9
	ld c,(hl)		; $4fca
	pop hl			; $4fcb
	ld l,Item.yh		; $4fcc
	add (hl)		; $4fce
	ldi (hl),a		; $4fcf
	inc l			; $4fd0
	ld a,(hl)		; $4fd1
	add c			; $4fd2
	ldi (hl),a		; $4fd3
	ret			; $4fd4

@offsets:
	.db $f8 $00 ; DIR_UP
	.db $04 $06 ; DIR_RIGHT
	.db $07 $00 ; DIR_DOWN
	.db $04 $f9 ; DIR_LEFT


;;
; ITEMID_BOOMERANG ($06)
; @addr{4fdd}
_parentItemCode_boomerang:
	ld e,Item.state		; $4fdd
	ld a,(de)		; $4fdf
	rst_jumpTable			; $4fe0

	.dw @state0
	.dw @state1

@state0:
	call _isLinkUnderwater		; $4fe5
	jp nz,_clearParentItem		; $4fe8

	ld a,(w1ParentItem2.id)		; $4feb
	cp ITEMID_SWITCH_HOOK			; $4fee
	jp z,_clearParentItem		; $4ff0

	ld a,(wLinkSwimmingState)		; $4ff3
	or a			; $4ff6
	jp nz,_clearParentItem		; $4ff7

	call _parentItemLoadAnimationAndIncState		; $4ffa
	ld a,$01		; $4ffd
	ld e,Item.state		; $4fff
	ld (de),a		; $5001

	; Try to create the physical boomerang object, delete self on failure
	dec a			; $5002
	ld c,a			; $5003
	ld e,Item.id		; $5004
	ld a,(de)		; $5006
	ld b,a			; $5007
	ld e,$01		; $5008
	call itemCreateChildWithID		; $500a
	jp c,_clearParentItem		; $500d

	; Calculate angle for newly created boomerang
	ld a,(wLinkAngle)		; $5010
	bit 7,a			; $5013
	jr z,+			; $5015
	ld a,(w1Link.direction)		; $5017
	swap a			; $501a
	rrca			; $501c
+
	ld l,Item.angle		; $501d
	ld (hl),a		; $501f
	ld l,Item.var34		; $5020
	ld (hl),a		; $5022
	ret			; $5023

@state1:
	ld e,Item.animParameter		; $5024
	ld a,(de)		; $5026
	rlca			; $5027
	jp nc,_specialObjectAnimate		; $5028
	jp _clearParentItem		; $502b

;;
; ITEMID_BOMBCHUS ($0d)
; @addr{502e}
_parentItemCode_bombchu:
	ld e,Item.state		; $502e
	ld a,(de)		; $5030
	rst_jumpTable			; $5031
	.dw @state0
	.dw _parentItemGenericState1

@state0:
	; Must be above water
	call _isLinkUnderwater		; $5036
	jp nz,_clearParentItem		; $5039

	; Can't be on raft
	ld a,(w1Companion.id)		; $503c
	cp SPECIALOBJECTID_RAFT			; $503f
	jp z,_clearParentItem		; $5041

	; Can't be swimming
	ld a,(wLinkSwimmingState)		; $5044
	or a			; $5047
	jp nz,_clearParentItem		; $5048

	; Must have bombchus
	ld a,(wNumBombchus)		; $504b
	or a			; $504e
	jp z,_clearParentItem		; $504f

	call _parentItemLoadAnimationAndIncState		; $5052

	; Create a bombchu if there isn't one on the screen already
	ld e,$01		; $5055
	jp itemCreateChildAndDeleteOnFailure		; $5057

;;
; ITEMID_BOMB ($03)
; @addr{505a}
_parentItemCode_bomb:
	ld e,Item.state		; $505a
	ld a,(de)		; $505c
	rst_jumpTable			; $505d

	.dw @state0
	.dw _parentItemGenericState1
	.dw _parentItemCode_bracelet@state2
	.dw _parentItemCode_bracelet@state3
	.dw _parentItemCode_bracelet@state4

@state0:
	call _isLinkUnderwater		; $5068
	jp nz,_clearParentItem		; $506b

	; If Link is riding something other than a raft, don't allow usage of bombs
	ld a,(w1Companion.id)		; $506e
	cp SPECIALOBJECTID_RAFT			; $5071
	jr z,+			; $5073
	ld a,(wLinkObjectIndex)		; $5075
	rrca			; $5078
	jp c,_clearParentItem		; $5079
+
	ld a,(wLinkSwimmingState)		; $507c
	ld b,a			; $507f
	ld a,(wLinkInAir)		; $5080
	or b			; $5083
	jp nz,_clearParentItem		; $5084

	; Try to pick up a bomb
	call _tryPickupBombs		; $5087
	jp nz,_parentItemCode_bracelet@beginPickupAndSetAnimation		; $508a

	; Try to create a bomb
	ld a,(wNumBombs)		; $508d
	or a			; $5090
	jp z,_clearParentItem		; $5091

	call _parentItemLoadAnimationAndIncState		; $5094
	ld e,$01		; $5097
	ld a,BOMBERS_RING		; $5099
	call cpActiveRing		; $509b
	jr nz,+			; $509e
	inc e			; $50a0
+
	call itemCreateChild		; $50a1
	jp c,_clearParentItem		; $50a4

	call _makeLinkPickupObjectH		; $50a7
	jp _parentItemCode_bracelet@beginPickup		; $50aa

;;
; Makes Link pick up a bomb object if such an object exists and Link's touching it.
;
; @param[out]	zflag	Unset if a bomb was picked up
; @addr{50ad}
_tryPickupBombs:
	; Return if Link's using something?
	ld a,(wLinkUsingItem1)		; $50ad
	or a			; $50b0
	jr nz,@setZFlag	; $50b1

	; Return with zflag set if there is no existing bomb object
	ld c,ITEMID_BOMB		; $50b3
	call findItemWithID		; $50b5
	jr nz,@setZFlag	; $50b8

	call @pickupObjectIfTouchingLink		; $50ba
	ret nz			; $50bd

	; Try to find a second bomb object & pick that up
	ld c,ITEMID_BOMB		; $50be
	call findItemWithID_startingAfterH		; $50c0
	jr nz,@setZFlag	; $50c3


; @param	h	Object to check
; @param[out]	zflag	Set on failure (no collision with Link)
@pickupObjectIfTouchingLink:
	ld l,Item.var2f		; $50c5
	ld a,(hl)		; $50c7
	and $b0			; $50c8
	jr nz,@setZFlag	; $50ca
	call objectHCheckCollisionWithLink		; $50cc
	jr c,_makeLinkPickupObjectH	; $50cf

@setZFlag:
	xor a			; $50d1
	ret			; $50d2

;;
; @param	h	Object to make Link pick up
; @addr{50d3}
_makeLinkPickupObjectH:
	ld l,Item.enabled		; $50d3
	set 1,(hl)		; $50d5

	ld l,Item.state2		; $50d7
	xor a			; $50d9
	ldd (hl),a		; $50da
	ld (hl),$02		; $50db

	ld (w1Link.relatedObj2),a		; $50dd
	ld a,h			; $50e0
	ld (w1Link.relatedObj2+1),a		; $50e1
	or a			; $50e4
	ret			; $50e5


;;
; Bracelet's code is also heavily used by bombs.
;
; ITEMID_BRACELET ($16)
; @addr{50e6}
_parentItemCode_bracelet:
	ld e,Item.state		; $50e6
	ld a,(de)		; $50e8
	rst_jumpTable			; $50e9

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

; State 0: not grabbing anything
@state0:
	call _checkLinkOnGround		; $50f6
	jp nz,_clearParentItem		; $50f9
	ld a,(w1ReservedItemC.enabled)		; $50fc
	or a			; $50ff
	jp nz,_clearParentItem		; $5100

	call _parentItemCheckButtonPressed		; $5103
	jp z,@dropAndDeleteSelf		; $5106

	ld a,(wLinkUsingItem1)		; $5109
	or a			; $510c
	jr nz,++		; $510d

	; Check if there's anything to pick up
	call checkGrabbableObjects		; $510f
	jr c,@beginPickupAndSetAnimation	; $5112
	call _tryPickupBombs		; $5114
	jr nz,@beginPickupAndSetAnimation	; $5117

	; Try to grab a solid tile
	call @checkWallInFrontOfLink		; $5119
	jr nz,++		; $511c
	ld a,$41		; $511e
	ld (wLinkGrabState),a		; $5120
	jp _parentItemLoadAnimationAndIncState		; $5123
++
	ld a,(w1Link.direction)		; $5126
	or $80			; $5129
	ld (wBraceletGrabbingNothing),a		; $512b
	ret			; $512e


; State 1: grabbing a wall
@state1:
	call @deleteAndRetIfSwimmingOrGrabState0		; $512f
	ld a,(w1Link.knockbackCounter)		; $5132
	or a			; $5135
	jp nz,@dropAndDeleteSelf		; $5136

	call _parentItemCheckButtonPressed		; $5139
	jp z,@dropAndDeleteSelf		; $513c

	ld a,(wLinkInAir)		; $513f
	or a			; $5142
	jp nz,@dropAndDeleteSelf		; $5143

	call @checkWallInFrontOfLink		; $5146
	jp nz,@dropAndDeleteSelf		; $5149

	; Check that the correct direction button is pressed
	ld a,(w1Link.direction)		; $514c
	ld hl,@counterDirections		; $514f
	rst_addAToHl			; $5152
	call _andHlWithGameKeysPressed		; $5153
	ld a,LINK_ANIM_MODE_LIFT_3		; $5156
	jp z,specialObjectSetAnimationWithLinkData		; $5158

	; Update animation, wait for animParameter to set bit 7
	call _specialObjectAnimate		; $515b
	ld e,Item.animParameter		; $515e
	ld a,(de)		; $5160
	rlca			; $5161
	ret nc			; $5162

	; Try to lift the tile, return if not possible
	call @checkWallInFrontOfLink		; $5163
	jp nz,@dropAndDeleteSelf		; $5166
	lda BREAKABLETILESOURCE_00			; $5169
	call tryToBreakTile		; $516a
	ret nc			; $516d

	; Create the sprite to replace the broken tile
	ld hl,w1ReservedItemC.enabled		; $516e
	ld a,$03		; $5171
	ldi (hl),a		; $5173
	ld (hl),ITEMID_BRACELET		; $5174

	; Set subid to former tile ID
	inc l			; $5176
	ldh a,(<hFF92)	; $5177
	ldi (hl),a		; $5179
	ld e,Item.var37		; $517a
	ld (de),a		; $517c

	; Set child item's var03 (the interaction ID for the effect on breakage)
	ldh a,(<hFF8E)	; $517d
	ldi (hl),a		; $517f

	lda Item.start			; $5180
	ld (w1Link.relatedObj2),a		; $5181
	ld a,h			; $5184
	ld (w1Link.relatedObj2+1),a		; $5185

@beginPickupAndSetAnimation:
	ld a,LINK_ANIM_MODE_LIFT_4		; $5188
	call specialObjectSetAnimationWithLinkData		; $518a

@beginPickup:
	call _itemDisableLinkMovement		; $518d
	call _itemDisableLinkTurning		; $5190
	ld a,$c2		; $5193
	ld (wLinkGrabState),a		; $5195
	xor a			; $5198
	ld (wLinkGrabState2),a		; $5199
	ld hl,w1Link.collisionType		; $519c
	res 7,(hl)		; $519f

	ld a,$02		; $51a1
	ld e,Item.state		; $51a3
	ld (de),a		; $51a5
	ld e,Item.var3f		; $51a6
	ld a,$0f		; $51a8
	ld (de),a		; $51aa

	ld a,SND_PICKUP		; $51ab
	jp playSound		; $51ad


; Opposite direction to press in order to use bracelet
@counterDirections:
	.db BTN_DOWN	; DIR_UP
	.db BTN_LEFT	; DIR_RIGHT
	.db BTN_UP	; DIR_DOWN
	.db BTN_RIGHT	; DIR_LEFT


; State 2: picking an item up.
; This is also state 2 for bombs.
@state2:
	call @deleteAndRetIfSwimmingOrGrabState0		; $51b4
	call _specialObjectAnimate		; $51b7

	; Check if link's pulling a lever?
	ld a,(wLinkGrabState2)		; $51ba
	rlca			; $51bd
	jr nc,++		; $51be

	; Go to state 5 for lever pulling?
	ld a,$83		; $51c0
	ld (wLinkGrabState),a		; $51c2
	ld e,Item.state		; $51c5
	ld a,$05		; $51c7
	ld (de),a		; $51c9
	ld a,LINK_ANIM_MODE_LIFT_2		; $51ca
	jp specialObjectSetAnimationWithLinkData		; $51cc
++
	ld h,d			; $51cf
	ld l,Item.animParameter		; $51d0
	bit 7,(hl)		; $51d2
	jr nz,++		; $51d4

	; The animParameter determines the object's offset relative to Link?
	ld a,(wLinkGrabState2)		; $51d6
	and $f0			; $51d9
	add (hl)		; $51db
	ld (wLinkGrabState2),a		; $51dc
	ret			; $51df
++
	; Pickup animation finished
	ld a,$83		; $51e0
	ld (wLinkGrabState),a		; $51e2
	ld l,Item.state		; $51e5
	inc (hl)		; $51e7
	ld l,Item.var3f		; $51e8
	ld (hl),$00		; $51ea

	; Re-enable link collisions & movement
	ld hl,w1Link.collisionType		; $51ec
	set 7,(hl)		; $51ef
	call _itemEnableLinkTurning		; $51f1
	jp _itemEnableLinkMovement		; $51f4


; State 3: holding the object
; This is also state 3 for bombs.
@state3:
	call @deleteAndRetIfSwimmingOrGrabState0		; $51f7
	ld a,(wLinkInAir)		; $51fa
	rlca			; $51fd
	ret c			; $51fe
	ld a,($cc67)		; $51ff
	or a			; $5202
	ret nz			; $5203
	ld a,(w1Link.var2a)		; $5204
	or a			; $5207
	jr nz,++		; $5208

	ld a,(wGameKeysJustPressed)		; $520a
	and BTN_A|BTN_B			; $520d
	ret z			; $520f

	call updateLinkDirectionFromAngle		; $5210
++
	; Item is being thrown

	; Unlink related object from Link, set its "state2" to $02 (meaning just thrown)
	ld hl,w1Link.relatedObj2		; $5213
	xor a			; $5216
	ld c,(hl)		; $5217
	ldi (hl),a		; $5218
	ld b,(hl)		; $5219
	ldi (hl),a		; $521a
	ld a,c			; $521b
	add Object.state2			; $521c
	ld l,a			; $521e
	ld h,b			; $521f
	ld (hl),$02		; $5220

	; If it was a tile that was picked up, don't create any new objects
	ld e,Item.var37		; $5222
	ld a,(de)		; $5224
	or a			; $5225
	jr nz,@@throwItem	; $5226

	; If this is referencing an item object beyond index $d7, don't create object $dc
	ld a,c			; $5228
	cpa Item.start			; $5229
	jr nz,@@createPlaceholder	; $522a
	ld a,b			; $522c
	cp FIRST_DYNAMIC_ITEM_INDEX			; $522d
	jr nc,@@throwItem	; $522f

	; Create an invisible bracelet object to be used for collisions?
	; This is used when throwing dimitri, but not for picked-up tiles.
@@createPlaceholder:
	push de			; $5231
	ld hl,w1ReservedItemC.enabled		; $5232
	inc (hl)		; $5235
	inc l			; $5236
	ld a,ITEMID_BRACELET		; $5237
	ldi (hl),a		; $5239

	; Copy over this parent item's former relatedObj2 & Y/X to the new "physical" item
	ld l,Item.relatedObj2		; $523a
	ld a,c			; $523c
	ldi (hl),a		; $523d
	ld (hl),b		; $523e
	add Item.yh			; $523f
	ld e,a			; $5241
	ld d,b			; $5242
	call objectCopyPosition_rawAddress		; $5243
	pop de			; $5246

@@throwItem:
	ld a,(wLinkAngle)		; $5247
	rlca			; $524a
	jr c,+			; $524b
	ld a,(w1Link.direction)		; $524d
	swap a			; $5250
	rrca			; $5252
+
	ld l,Item.angle		; $5253
	ld (hl),a		; $5255
	ld l,Item.var38		; $5256
	ld a,(wLinkGrabState2)		; $5258
	ld (hl),a		; $525b
	xor a			; $525c
	ld (wLinkGrabState2),a		; $525d
	ld (wLinkGrabState),a		; $5260
	ld h,d			; $5263
	ld l,Item.state		; $5264
	inc (hl)		; $5266
	ld l,Item.var3f		; $5267
	ld (hl),$0f		; $5269

	; Load animation depending on whether Link's riding a minecart
	ld c,LINK_ANIM_MODE_THROW		; $526b
	ld a,(w1Companion.id)		; $526d
	cp SPECIALOBJECTID_MINECART			; $5270
	jr nz,+			; $5272
	ld a,(wLinkObjectIndex)		; $5274
	rrca			; $5277
	jr nc,+			; $5278
	ld c,LINK_ANIM_MODE_25		; $527a
+
	ld a,c			; $527c
	call specialObjectSetAnimationWithLinkData		; $527d
	call _itemDisableLinkMovement		; $5280
	call _itemDisableLinkTurning		; $5283
	ld a,SND_THROW		; $5286
	jp playSound		; $5288


; State 4: Link in throwing animation.
; This is also state 4 for bombs.
@state4:
	ld e,Item.animParameter		; $528b
	ld a,(de)		; $528d
	rlca			; $528e
	jp nc,_specialObjectAnimate		; $528f
	jr @dropAndDeleteSelf		; $5292

;;
; @addr{5294}
@deleteAndRetIfSwimmingOrGrabState0:
	ld a,(wLinkSwimmingState)		; $5294
	or a			; $5297
	jr nz,+			; $5298
	ld a,(wLinkGrabState)		; $529a
	or a			; $529d
	ret nz			; $529e
+
	pop af			; $529f

@dropAndDeleteSelf:
	call dropLinkHeldItem		; $52a0
	jp _clearParentItem		; $52a3

;;
; @param[out]	bc	Y/X of tile Link is grabbing
; @param[out]	zflag	Set if Link is directly facing a wall
; @addr{52a6}
@checkWallInFrontOfLink:
	ld a,(w1Link.direction)		; $52a6
	ld b,a			; $52a9
	add a			; $52aa
	add b			; $52ab
	ld hl,@@data		; $52ac
	rst_addAToHl			; $52af
	ld a,(w1Link.adjacentWallsBitset)		; $52b0
	and (hl)		; $52b3
	cp (hl)			; $52b4
	ret nz			; $52b5

	inc hl			; $52b6
	ld a,(w1Link.yh)		; $52b7
	add (hl)		; $52ba
	ld b,a			; $52bb
	inc hl			; $52bc
	ld a,(w1Link.xh)		; $52bd
	add (hl)		; $52c0
	ld c,a			; $52c1
	xor a			; $52c2
	ret			; $52c3

; b0: bits in w1Link.adjacentWallsBitset that should be set
; b1/b2: Y/X offsets from Link's position
@@data:
	.db $c0 $fb $00 ; DIR_UP
	.db $03 $00 $07 ; DIR_RIGHT
	.db $30 $07 $00 ; DIR_DOWN
	.db $0c $00 $f8 ; DIR_LEFT


; State 5: pulling a lever?
@state5:
	call _parentItemCheckButtonPressed	; $52d0
	jp z,@dropAndDeleteSelf		; $52d3
	call @deleteAndRetIfSwimmingOrGrabState0		; $52d6
	ld a,(w1Link.knockbackCounter)		; $52d9
	or a			; $52dc
	jp nz,@dropAndDeleteSelf		; $52dd

	ld a,(w1Link.direction)		; $52e0
	ld hl,@counterDirections		; $52e3
	rst_addAToHl			; $52e6
	ld a,(wGameKeysPressed)		; $52e7
	and (hl)		; $52ea
	ld a,LINK_ANIM_MODE_LIFT_2		; $52eb
	jp z,specialObjectSetAnimationWithLinkData		; $52ed
	jp _specialObjectAnimate		; $52f0


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
	; Check wcc5e as well
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


;;
; ITEMID_MAGNET_GLOVES ($08)
; @addr{5358}
_parentItemCode_magnetGloves:
	call _checkNoOtherParentItemsInUse		; $5358
--
	push hl			; $535b
	call nz,_clearParentItemH		; $535c
	pop hl			; $535f
	call _checkNoOtherParentItemsInUse@nextItem		; $5360
	jr nz,--		; $5363
	ret			; $5365

;;
; @param	d	The current parent item
; @param[out]	zflag	Set if there are no other parent item slots in use
; @addr{5366}
_checkNoOtherParentItemsInUse:
	ld hl,w1ParentItem2.enabled		; $5366
--
	ld a,d			; $5369
	cp h			; $536a
	jr z,@nextItem		; $536b
	ld a,(hl)		; $536d
	or a			; $536e
	ret nz			; $536f
@nextItem:
	inc h			; $5370
	ld a,h			; $5371
	cp >w1WeaponItem			; $5372
	jr c,--		; $5374

	xor a			; $5376
	ret			; $5377

;;
; Items which immobilize Link in place tend to call this.
;
; * Disables movement, turning
; * Sets Item.state to $01
; * Loads an animation for Link by reading from _linkItemAnimationTable
; * Sets Item.relatedObj2 to something
; * Sets Item.var3f to something
;
; @addr{5378}
_parentItemLoadAnimationAndIncState:
	call _itemDisableLinkMovement		; $5378
	call _itemDisableLinkTurning		; $537b

	ld e,Item.state		; $537e
	ld a,$01		; $5380
	ld (de),a		; $5382

	ld e,Item.id		; $5383
	ld a,(de)		; $5385
	ld hl,_linkItemAnimationTable		; $5386
	rst_addDoubleIndex			; $5389

	; Read Item.relatedObj2 from the table
	ld e,Item.relatedObj2		; $538a
	lda Item.start			; $538c
	ld (de),a		; $538d
	inc e			; $538e
	ld a,(hl)		; $538f
	and $0f			; $5390
	cp $01			; $5392
	jr z,+			; $5394
	or $d0			; $5396
+
	ld (de),a		; $5398

	; Set Item.var3f
	ldi a,(hl)		; $5399
	ld b,a			; $539a
	swap a			; $539b
	and $07			; $539d
	ld e,Item.var3f		; $539f
	ld (de),a		; $53a1

	ld c,(hl)		; $53a2
	bit 7,b			; $53a3
	call nz,_setLinkUsingItem1		; $53a5

	ld a,(w1Companion.id)		; $53a8
	cp SPECIALOBJECTID_RAFT			; $53ab
	ld a,c			; $53ad
	jr z,@setAnimation	; $53ae

	ld a,(w1Link.var2f)		; $53b0
	bit 7,a			; $53b3
	jr z,@notUnderwater			; $53b5

; Link is underwater

	ld a,c			; $53b7
	cp LINK_ANIM_MODE_22			; $53b8
	jr nz,@setAnimation	; $53ba

	ld a,LINK_ANIM_MODE_2d		; $53bc
	jr @setAnimation		; $53be

@notUnderwater:
	; Check if Link is riding something
	ld a,(wLinkObjectIndex)		; $53c0
	rrca			; $53c3
	ld a,c			; $53c4
	jr nc,@setAnimation	; $53c5

	cp LINK_ANIM_MODE_20			; $53c7
	jr c,@setAnimation	; $53c9

	cp LINK_ANIM_MODE_24			; $53cb
	jr nc,@setAnimation	; $53cd
	add $04			; $53cf

@setAnimation:
	jp specialObjectSetAnimationWithLinkData		; $53d1

;;
; Same as below, except it's assumed that only one instance of the child can exist.
;
; @addr{53d4}
itemCreateChildIfDoesntExistAlready:
	ld e,$01		; $53d4

;;
; Creates the child if the given # of instances don't already exist; delete the parent on
; failure.
;
; @param	e	Max # of instances of the child
; @addr{53d6}
itemCreateChildAndDeleteOnFailure:
	call itemCreateChild		; $53d6
	ret nc			; $53d9
	jp _clearParentItem		; $53da

;;
; Creates an item object, based on the id of another item object?
;
; "Parent" items call this to create an actual physical object (since parent items don't
; get drawn).
;
; @param	d	Parent item
; @param	e	Max # instances of the object that can exist (0 means 256)
; @param[out]	h	The newly created child item
; @param[out]	cflag	Set on failure
; @addr{53dd}
itemCreateChild:
	ld c,$00		; $53dd
	ld h,d			; $53df
	ld l,Item.id		; $53e0
	ld b,(hl)		; $53e2

;;
; @param	b	Item ID to create (see constants/itemTypes.s)
; @param	c	Subid for item
; @param	d	Points to w1ParentItem2, or some parent item?
; @param	e	Max # instances of the object that can exist (0 means 256)
; @param[out]	h	The newly created child item
; @param[out]	cflag	Set on failure
; @addr{53e3}
itemCreateChildWithID:
	ld h,d			; $53e3
	ld l,Item.relatedObj2+1		; $53e4
	ldd a,(hl)		; $53e6
	ld l,(hl)		; $53e7
	ld h,a			; $53e8
	cp $01			; $53e9
	scf			; $53eb
	ret z			; $53ec

	cp >w1Link			; $53ed
	call z,_getFreeItemSlotWithObjectCap		; $53ef
	ret c			; $53f2

	; Set Item.enabled
	inc (hl)		; $53f3

	; Set Item.id and Item.subid
	inc l			; $53f4
	ld a,b			; $53f5
	ldi (hl),a		; $53f6
	ld a,c			; $53f7
	ldi (hl),a		; $53f8

	; Clear Item.var03, Item.state, Item.state2
	xor a			; $53f9
	ldi (hl),a		; $53fa
	ldi (hl),a		; $53fb
	ldi (hl),a		; $53fc

	; Copy link's direction and position variables to the item
	push de			; $53fd
	ld de,w1Link.direction		; $53fe
	ld l,Item.direction		; $5401
	ld b,$08		; $5403
	call copyMemoryReverse		; $5405
	pop de			; $5408

	; Set "parent" object?
	ld l,Item.relatedObj1		; $5409
	lda Item.start			; $540b
	ldi (hl),a		; $540c
	ld (hl),d		; $540d

	; And vice versa; set parent's "child" object?
	ld e,Item.relatedObj2		; $540e
	ld (de),a		; $5410
	inc e			; $5411
	ld a,h			; $5412
	ld (de),a		; $5413

	xor a			; $5414
	ret			; $5415

;;
; @param	bc	ID of item to create.
; @param	e	Maximum number of items with ID "bc" that can exist (0 means 256).
; @param[out]	hl	Free item slot
; @param[out]	cflag	Set on failure.
; @addr{5416}
_getFreeItemSlotWithObjectCap:
	ldhl FIRST_DYNAMIC_ITEM_INDEX, Item.id		; $5416

	; Loop through all existing items, make sure that the maximum number of objects of
	; type "bc" allowed is not exceeded.
@itemLoop:
	; Compare Item.id and Item.subid with bc
	ld a,(hl)		; $5419
	cp b			; $541a
	jr nz,@nextItem		; $541b
	inc l			; $541d
	ldd a,(hl)		; $541e
	cp c			; $541f
	jr nz,@nextItem		; $5420

	dec e			; $5422
	jr z,@failure		; $5423
@nextItem:
	inc h			; $5425
	ld a,h			; $5426
	cp LAST_DYNAMIC_ITEM_INDEX+1			; $5427
	jr c,@itemLoop		; $5429

	; End of loop; maximum number of objects not exceeded.
	call getFreeItemSlot		; $542b
	ret z			; $542e

@failure:
	scf			; $542f
	ret			; $5430

;;
; Unused?
;
; @param[out]	zflag
; @addr{5431}
_func_5431:
	ldhl FIRST_DYNAMIC_ITEM_INDEX, Item.start		; $5431
	ld b,$00		; $5434
--
	ld a,(hl)		; $5436
	or a			; $5437
	jr nz,+			; $5438
	inc b			; $543a
+
	inc h			; $543b
	ld a,h			; $543c
	cp LAST_DYNAMIC_ITEM_INDEX+1			; $543d
	jr c,--			; $543f
	ld a,b			; $5441
	or a			; $5442
	ret			; $5443

;;
; @param d Parent item to add to wLinkUsingItem1
; @addr{5444}
_setLinkUsingItem1:
	call _itemIndexToBit		; $5444
	swap a			; $5447
	or (hl)			; $5449
	ld hl,wLinkUsingItem1		; $544a
	or (hl)			; $544d
	ld (hl),a		; $544e
	ret			; $544f

;;
; @param d Parent item to clear from wLinkUsingItem1
; @addr{5450}
_clearLinkUsingItem1:
	call _itemIndexToBit		; $5450
	swap a			; $5453
	or (hl)			; $5455
	cpl			; $5456
	ld hl,wLinkUsingItem1		; $5457
	and (hl)		; $545a
	ld (hl),a		; $545b
	ret			; $545c

;;
; @param d Parent item to add to wLinkImmobilized
; @addr{545d}
_itemDisableLinkMovement:
	call _itemIndexToBit		; $545d
	ld hl,wLinkImmobilized		; $5460
	or (hl)			; $5463
	ld (hl),a		; $5464
	ret			; $5465

;;
; @param d Parent item to clear from wLinkImmobilized
; @addr{5466}
_itemEnableLinkMovement:
	call _itemIndexToBit		; $5466
	ld hl,wLinkImmobilized		; $5469
	cpl			; $546c
	and (hl)		; $546d
	ld (hl),a		; $546e
	ret			; $546f

;;
; @param d Parent item to add to wLinkTurningDisabled
; @addr{5470}
_itemDisableLinkTurning:
	call _itemIndexToBit		; $5470
	ld hl,wLinkTurningDisabled		; $5473
	or (hl)			; $5476
	ld (hl),a		; $5477
	ret			; $5478

;;
; @param d Parent item to clear from wLinkTurningDisabled
; @addr{5479}
_itemEnableLinkTurning:
	call _itemIndexToBit		; $5479
	ld hl,wLinkTurningDisabled		; $547c
	cpl			; $547f
	and (hl)		; $5480
	ld (hl),a		; $5481
	ret			; $5482

;;
; Unused?
;
; @param d Parent item to add to $cc95
; @addr{5483}
_setCc95Bit:
	call _itemIndexToBit		; $5483
	ld hl,$cc95		; $5486
	or (hl)			; $5489
	ld (hl),a		; $548a
	ret			; $548b

;;
; Turn an item index (starting at $d2) into a bit.
;
; @param	d	Parent item object
; @param[out]	a	Bitmask for the item
; @addr{548c}
_itemIndexToBit:
	ld a,d			; $548c
	sub >w1ParentItem2			; $548d
	ld hl,bitTable		; $548f
	add l			; $5492
	ld l,a			; $5493
	ld a,(hl)		; $5494
	ret			; $5495

;;
; Checks if the button corresponding to the parent item object is pressed (the bitmask is
; stored in var03).
;
; @addr{5496}
_parentItemCheckButtonPressed:
	ld h,d			; $5496
	ld l,Item.var03		; $5497

;;
; @param	hl
; @addr{5499}
_andHlWithGameKeysPressed:
	ld a,(wGameKeysPressed)		; $5499
	and (hl)		; $549c
	ret			; $549d

;;
; @param	d	Parent item object
; @addr{549e}
_clearParentItemIfCantUseSword:
	; Check if in a spinner
	ld a,($cc95)		; $549e
	rlca			; $54a1
	jr c,@cantUseSword	; $54a2

	ld a,(wLinkClimbingVine)		; $54a4
	inc a			; $54a7
	jr z,@cantUseSword	; $54a8

	ld a,($ccd8)		; $54aa
	ld b,a			; $54ad
	ld a,(wSwordDisabledCounter)		; $54ae
	or b			; $54b1
	ret z			; $54b2

	ld e,Item.state		; $54b3
	ld a,(de)		; $54b5
	or a			; $54b6
	ld a,SND_ERROR		; $54b7
	call z,playSound		; $54b9

@cantUseSword:
	pop af			; $54bc
	xor a			; $54bd
	ld ($cc63),a		; $54be
	jp _clearParentItem		; $54c1

;;
; @param[out]	zflag	Set if link is on the ground (not on companion, not underwater,
;			not swimming, not in the air).
; @addr{54c4}
_checkLinkOnGround:
	ld a,(wLinkObjectIndex)		; $54c4
	and $01			; $54c7
	ret nz			; $54c9

	ld hl,wLinkInAir		; $54ca
	ldi a,(hl)		; $54cd
	; Check wLinkSwimmingState
	or (hl)			; $54ce
	ret nz			; $54cf
	jr _isLinkUnderwater		; $54d0

;;
; @param[out]	zflag	Set if Link is not in an underwater map
; @addr{54d2}
_isLinkUnderwater:
	ld a,(w1Link.var2f)		; $54d2
	bit 7,a			; $54d5
	ret			; $54d7

;;
; @param[out]	cflag	Set if link is currently in a hole.
; @addr{54d8}
_isLinkInHole:
	ld a,(wActiveTileType)		; $54d8
	dec a			; $54db
	cp $02			; $54dc
	ret			; $54de

;;
; Updates the position of a grabbed object (overwrites its x/y/z variables).
;
; @addr{54df}
updateGrabbedObjectPosition:
	ld a,(wLinkGrabState2)		; $54df
	ld b,a			; $54e2
	rlca			; $54e3
	ret c			; $54e4

	; Set active object
	ld de,w1Link		; $54e5
	ld a,e			; $54e8
	ldh (<hActiveObjectType),a	; $54e9
	ld a,d			; $54eb
	ldh (<hActiveObject),a	; $54ec

	; If the lift animation is finished, use the animParameter to help determine which
	; frame data to use
	ld a,(wLinkGrabState)		; $54ee
	cp $83			; $54f1
	jr nz,+			; $54f3
	ld e,<w1Link.animParameter		; $54f5
	ld a,(de)		; $54f7
	and $0f			; $54f8
	add b			; $54fa
	ld b,a			; $54fb
+
	; Get position offsets in 'bc'
	ld e,<w1Link.direction		; $54fc
	ld a,(de)		; $54fe
	add b			; $54ff
	ld hl,@liftedObjectPositions		; $5500
	rst_addDoubleIndex			; $5503
	ldi a,(hl)		; $5504
	ld b,a			; $5505
	ldi a,(hl)		; $5506
	ld c,a			; $5507

	; Link.yh -> Object.yh
	ld a,Object.yh		; $5508
	call objectGetRelatedObject2Var		; $550a
	ld e,<w1Link.yh		; $550d
	ld a,(de)		; $550f
	ldi (hl),a		; $5510

	; Link.xh + 'c' -> Object.xh
	inc l			; $5511
	ld e,<w1Link.xh		; $5512
	ld a,(de)		; $5514
	add c			; $5515
	ldi (hl),a		; $5516

	; Link.zh + 'b' -> Object.zh
	inc l			; $5517
	ld e,<w1Link.zh		; $5518
	ld a,(de)		; $551a
	add b			; $551b
	ldi (hl),a		; $551c
	ret			; $551d


; Each 2 bytes are Z/X offsets relative to Link where an object should be placed.
; Each row has 8 bytes, 2 for each of Link's facing directions.
;
; @addr{551e}
@liftedObjectPositions:
	; Weight 0
	.db $f8 $00 $00 $07 $06 $00 $00 $f8 ; Frame 0 (lifting 1)
	.db $fa $00 $f8 $03 $04 $00 $f8 $fc ; Frame 1 (lifting 2)
	.db $f3 $00 $f2 $00 $f3 $00 $f2 $00 ; Frame 2 (walking 1 / standing still)
	.db $f3 $00 $f3 $00 $f3 $00 $f3 $00 ; Frame 3 (walking 2)

	; Weight 1
	.db $f4 $00 $00 $14 $0c $00 $00 $ec
	.db $f2 $00 $f2 $10 $f2 $00 $f2 $f0
	.db $ef $00 $ef $00 $ef $00 $ef $00
	.db $f0 $00 $f0 $00 $f0 $00 $f0 $00

	; Weight 2
	.db $f8 $00 $00 $07 $06 $00 $00 $f8
	.db $fa $00 $f8 $03 $04 $00 $f8 $fc
	.db $f3 $00 $f2 $00 $f3 $00 $f2 $00
	.db $f3 $00 $f3 $00 $f3 $00 $f3 $00

	; Weight 3
	.db $f4 $00 $00 $14 $0c $00 $00 $ec
	.db $f2 $00 $f2 $10 $f2 $00 $f2 $f0
	.db $ef $00 $ef $00 $ef $00 $ef $00
	.db $f0 $00 $f0 $00 $f0 $00 $f0 $00

	; Weight 4
	.db $f6 $00 $00 $0a $0a $00 $00 $f6
	.db $f4 $00 $f4 $0e $f4 $00 $f4 $f2
	.db $f2 $00 $f1 $00 $f2 $00 $f1 $00
	.db $f2 $00 $f2 $00 $f2 $00 $f2 $00



; Following table affects how an item can be used (ie. how it interacts with other items
; being used).
;
; Data format:
;  b0: bits 4-7: Priority (higher value = higher precedence)
;                Gets written to high nibble of Item.enabled
;      bits 0-3: Determines what "parent item" slot to use when the button is pressed.
;                0: Item is unusable.
;                1: Uses w1ParentItem3 or 4.
;                2: Uses w1ParentItem3 or 4, but only one instance of the item may exist
;                   at once. (boomerang, seed satchel)
;                3: Uses w1ParentItem2. If an object is already there, it gets
;                   overwritten if this object's priority is high enough.
;                   (sword, cane, bombs, etc)
;                4: Same as 2, but the item can't be used if w1ParentItem2 is in use (Link
;                   is holding a sword or something)
;                5: Uses w1ParentItem5 (only if not already in use). (shield, flute, harp)
;                6-7: invalid
;  b1: Byte to check input against when the item is first used
;
; @addr{55be}
_itemUsageParameterTable:
	.db $00 <wGameKeysPressed	; ITEMID_NONE
	.db $05 <wGameKeysPressed	; ITEMID_SHIELD
	.db $03 <wGameKeysJustPressed	; ITEMID_PUNCH
	.db $23 <wGameKeysJustPressed	; ITEMID_BOMB
	.db $03 <wGameKeysJustPressed	; ITEMID_CANE_OF_SOMARIA
	.db $63 <wGameKeysJustPressed	; ITEMID_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOOMERANG
	.db $00 <wGameKeysJustPressed	; ITEMID_ROD_OF_SEASONS
	.db $00 <wGameKeysJustPressed	; ITEMID_MAGNET_GLOVES
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_HELPER
	.db $73 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK
	.db $00 <wGameKeysJustPressed	; ITEMID_SWITCH_HOOK_CHAIN
	.db $73 <wGameKeysJustPressed	; ITEMID_BIGGORON_SWORD
	.db $02 <wGameKeysJustPressed	; ITEMID_BOMBCHUS
	.db $05 <wGameKeysJustPressed	; ITEMID_FLUTE
	.db $43 <wGameKeysJustPressed	; ITEMID_SHOOTER
	.db $00 <wGameKeysJustPressed	; ITEMID_10
	.db $05 <wGameKeysJustPressed	; ITEMID_HARP
	.db $00 <wGameKeysJustPressed	; ITEMID_12
	.db $00 <wGameKeysJustPressed	; ITEMID_SLINGSHOT
	.db $00 <wGameKeysJustPressed	; ITEMID_14
	.db $13 <wGameKeysJustPressed	; ITEMID_SHOVEL
	.db $13 <wGameKeysPressed	; ITEMID_BRACELET
	.db $01 <wGameKeysJustPressed	; ITEMID_FEATHER
	.db $00 <wGameKeysJustPressed	; ITEMID_18
	.db $02 <wGameKeysJustPressed	; ITEMID_SEED_SATCHEL
	.db $00 <wGameKeysJustPressed	; ITEMID_DUST
	.db $00 <wGameKeysJustPressed	; ITEMID_1b
	.db $00 <wGameKeysJustPressed	; ITEMID_1c
	.db $00 <wGameKeysJustPressed	; ITEMID_MINECART_COLLISION
	.db $00 <wGameKeysJustPressed	; ITEMID_FOOLS_ORE
	.db $00 <wGameKeysJustPressed	; ITEMID_1f



; Data format:
;  b0: bit 7:    If set, the corresponding bit in wLinkUsingItem1 will be set.
;      bits 4-6: Value for bits 0-2 of Item.var3f
;      bits 0-3: Determines parent item's relatedObj2?
;                A value of $6 refers to w1WeaponItem.
;  b1: Animation to set Link to? (see constants/linkAnimations.s)
;
; @addr{55fe}
_linkItemAnimationTable:
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_NONE
	.db $00  LINK_ANIM_MODE_NONE	; ITEMID_SHIELD
	.db $d6  LINK_ANIM_MODE_21	; ITEMID_PUNCH
	.db $30  LINK_ANIM_MODE_LIFT	; ITEMID_BOMB
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_CANE_OF_SOMARIA
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_SWORD
	.db $b0  LINK_ANIM_MODE_21	; ITEMID_BOOMERANG
	.db $d6  LINK_ANIM_MODE_22	; ITEMID_ROD_OF_SEASONS
	.db $60  LINK_ANIM_MODE_NONE	; ITEMID_MAGNET_GLOVES
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_HELPER
	.db $f6  LINK_ANIM_MODE_21	; ITEMID_SWITCH_HOOK
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_SWITCH_HOOK_CHAIN
	.db $f6  LINK_ANIM_MODE_23	; ITEMID_BIGGORON_SWORD
	.db $30  LINK_ANIM_MODE_21	; ITEMID_BOMBCHUS
	.db $70  LINK_ANIM_MODE_FLUTE	; ITEMID_FLUTE
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SHOOTER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_10
	.db $70  LINK_ANIM_MODE_HARP_2	; ITEMID_HARP
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_12
	.db $c6  LINK_ANIM_MODE_21	; ITEMID_SLINGSHOT
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_14
	.db $b0  LINK_ANIM_MODE_DIG_2	; ITEMID_SHOVEL
	.db $40  LINK_ANIM_MODE_LIFT_3	; ITEMID_BRACELET
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_FEATHER
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_18
	.db $a0  LINK_ANIM_MODE_21	; ITEMID_SEED_SATCHEL
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_DUST
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1b
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1c
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_MINECART_COLLISION
	.db $e6  LINK_ANIM_MODE_22	; ITEMID_FOOLS_ORE
	.db $80  LINK_ANIM_MODE_NONE	; ITEMID_1f
