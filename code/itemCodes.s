;;
; ITEMID_EMBER_SEED
; ITEMID_SCENT_SEED
; ITEMID_PEGASUS_SEED
; ITEMID_GALE_SEED
; ITEMID_MYSTERY_SEED
;
; @addr{4ced}
itemCode20:
itemCode21:
itemCode22:
itemCode23:
itemCode24:
	ld e,Item.state		; $4ced
	ld a,(de)		; $4cef
	rst_jumpTable			; $4cf0
	.dw @state0
	.dw _seedItemState1
	.dw _seedItemState2
	.dw _seedItemState3

@state0:
	call _itemLoadAttributesAndGraphics		; $4cf9
	xor a			; $4cfc
	call itemSetAnimation		; $4cfd
	call objectSetVisiblec1		; $4d00
	call itemIncState		; $4d03
	ld bc,$ffe0		; $4d06
	call objectSetSpeedZ		; $4d09

.ifdef ROM_AGES
	; Subid is nonzero if being used from seed shooter
	ld l,Item.subid		; $4d0c
	ld a,(hl)		; $4d0e
	or a			; $4d0f
	call z,itemUpdateAngle		; $4d10

	ld l,Item.var34		; $4d13
	ld (hl),$03		; $4d15
.else
	call itemUpdateAngle		; $4ce2
.endif

	ld l,Item.subid		; $4d17
	ldd a,(hl)		; $4d19
	or a			; $4d1a
.ifdef ROM_AGES
	jr nz,@shooter		; $4d1b
.else
	jr nz,@slingshot	; $4d1b
.endif

	; Satchel
	ldi a,(hl)		; $4d1d
	cp ITEMID_GALE_SEED			; $4d1e
	jr nz,++		; $4d20

	; Gale seed
	ld l,Item.zh		; $4d22
	ld a,(hl)		; $4d24
	add $f8			; $4d25
	ld (hl),a		; $4d27
	ld l,Item.angle		; $4d28
	ld (hl),$ff		; $4d2a
	ret			; $4d2c
++

.ifdef ROM_AGES
	ld hl,@satchelPositionOffsets		; $4d2d
	call _applyOffsetTableHL		; $4d30
.endif

	ld a,SPEED_c0		; $4d33
	jr @setSpeed		; $4d35

.ifdef ROM_AGES
@shooter:
	ld e,Item.angle		; $4d37
	ld a,(de)		; $4d39
	rrca			; $4d3a
	ld hl,@shooterPositionOffsets		; $4d3b
	rst_addAToHl			; $4d3e
	ldi a,(hl)		; $4d3f
	ld c,(hl)		; $4d40
	ld b,a			; $4d41

	ld h,d			; $4d42
	ld l,Item.zh		; $4d43
	ld a,(hl)		; $4d45
	add $fe			; $4d46
	ld (hl),a		; $4d48

	; Since 'd'='h', this will copy its own position and apply the offset
	call objectCopyPositionWithOffset		; $4d49
.else
@slingshot:
	ld hl,@slingshotAngleTable-1		; $4cff
	rst_addAToHl			; $4d02
	ld e,Item.angle		; $4d03
	ld a,(de)		; $4d05
	add (hl)		; $4d06
	and $1f			; $4d07
	ld (de),a		; $4d09
.endif

	ld hl,wIsSeedShooterInUse		; $4d4c
	inc (hl)		; $4d4f
	ld a,SPEED_300		; $4d50

@setSpeed:
	ld e,Item.speed		; $4d52
	ld (de),a		; $4d54
.ifdef ROM_SEASONS
	ld hl,@satchelPositionOffsets		; $4d13
	call _applyOffsetTableHL		; $4d16
.endif

	; If it's a mystery seed, get a random effect
	ld e,Item.id		; $4d55
	ld a,(de)		; $4d57
	cp ITEMID_MYSTERY_SEED			; $4d58
	ret nz			; $4d5a

	call getRandomNumber_noPreserveVars		; $4d5b
	and $03			; $4d5e
	ld e,Item.var03		; $4d60
	ld (de),a		; $4d62
	add $80|ITEMCOLLISION_EMBER_SEED			; $4d63
	ld e,Item.collisionType		; $4d65
	ld (de),a		; $4d67
	ret			; $4d68

.ifdef ROM_SEASONS
@slingshotAngleTable:
	.db $00 $02 $fe
.endif

; Y/X/Z position offsets relative to Link to make seeds appear at (for satchel)
@satchelPositionOffsets:
	.db $fc $00 $fe ; DIR_UP
	.db $01 $04 $fe ; DIR_RIGHT
	.db $05 $00 $fe ; DIR_DOWN
	.db $01 $fb $fe ; DIR_LEFT

.ifdef ROM_AGES
; Y/X offsets for shooter
@shooterPositionOffsets:
	.db $f2 $fc ; Up
	.db $fc $0b ; Up-right
	.db $05 $0c ; Right
	.db $09 $0b ; Down-right
	.db $0d $03 ; Down
	.db $0a $f8 ; Down-left
	.db $05 $f3 ; Left
	.db $f8 $f8 ; Up-left
.endif

;;
; State 1: seed moving
; @addr{4d85}
_seedItemState1:
	call _itemUpdateDamageToApply		; $4d85
.ifdef ROM_AGES
	jr z,@noCollision		; $4d88

	; Check bit 4 of Item.var2a
	bit 4,a			; $4d8a
	jr z,@seedCollidedWithEnemy	; $4d8c

	; [Item.var2a] = 0
	ld (hl),$00		; $4d8e

	call _func_50f4		; $4d90
	jr z,@updatePosition	; $4d93
	jr @seedCollidedWithWall		; $4d95
.else
	jr nz,@seedCollidedWithEnemy	; $4d3f
.endif

@noCollision:
	ld e,Item.subid		; $4d97
	ld a,(de)		; $4d99
	or a			; $4d9a
	jr z,@satchelUpdate	; $4d9b

@slingshotUpdate:
.ifdef ROM_AGES
	call _seedItemUpdateBouncing		; $4d9d
.else
	call _slingshotCheckCanPassSolidTile
.endif
	jr nz,@seedCollidedWithWall	; $4da0

@updatePosition:
.ifdef ROM_AGES
	call objectCheckWithinRoomBoundary		; $4da2
.else
	call objectCheckWithinScreenBoundary
.endif
	jp c,objectApplySpeed		; $4da5
	jp _seedItemDelete		; $4da8

@satchelUpdate:
	; Set speed to 0 if landed in water?
	ld h,d			; $4dab
	ld l,Item.var3b		; $4dac
	bit 0,(hl)		; $4dae
	jr z,+			; $4db0
	ld l,Item.speed		; $4db2
	ld (hl),SPEED_0		; $4db4
+
	call objectCheckWithinRoomBoundary		; $4db6
	jp nc,_seedItemDelete		; $4db9

	call objectApplySpeed		; $4dbc
	ld c,$1c		; $4dbf
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $4dc1
	jp c,_seedItemDelete		; $4dc4
	ret z			; $4dc7

; Landed on ground

	ld a,SND_BOMB_LAND	; $4dc8
	call playSound		; $4dca
	call itemAnimate		; $4dcd
	ld e,Item.id		; $4dd0
	ld a,(de)		; $4dd2
	sub ITEMID_EMBER_SEED			; $4dd3
	rst_jumpTable			; $4dd5
	.dw @emberStandard
	.dw @scentLanded
	.dw _seedItemDelete
	.dw @galeLanded
	.dw @mysteryStandard


; This activates the seed on collision with something. The behaviour is slightly different
; than when it lands on the ground (which is covered above).
@seedCollidedWithWall:
	call itemAnimate		; $4de0
	ld e,Item.id		; $4de3
	ld a,(de)		; $4de5
	sub ITEMID_EMBER_SEED			; $4de6
	rst_jumpTable			; $4de8
	.dw @emberStandard
	.dw @scentOrPegasusCollided
	.dw @scentOrPegasusCollided
	.dw @galeCollidedWithWall
	.dw @mysteryStandard


; Behaviour on collision with enemy; again slightly different
@seedCollidedWithEnemy:
	call itemAnimate		; $4df3
	ld e,Item.collisionType		; $4df6
	xor a			; $4df8
	ld (de),a		; $4df9
	ld e,Item.id		; $4dfa
	ld a,(de)		; $4dfc
	sub ITEMID_EMBER_SEED			; $4dfd
	rst_jumpTable			; $4dff
	.dw @emberStandard
	.dw @scentOrPegasusCollided
	.dw @scentOrPegasusCollided
	.dw @galeCollidedWithEnemy
	.dw @mysteryCollidedWithEnemy


@emberStandard:
@galeCollidedWithEnemy:
	call @initState3		; $4e0a
	jp objectSetVisible82		; $4e0d


@scentLanded:
	ld a,$27		; $4e10
	call @loadGfxVarsWithIndex		; $4e12
	ld a,$02		; $4e15
	call itemSetState		; $4e17
	ld l,Item.collisionType		; $4e1a
	res 7,(hl)		; $4e1c
	ld a,$01		; $4e1e
	call itemSetAnimation		; $4e20
	jp objectSetVisible83		; $4e23


@scentOrPegasusCollided:
	ld e,Item.collisionType		; $4e26
	xor a			; $4e28
	ld (de),a		; $4e29
	jr @initState3		; $4e2a


@galeLanded:
	call @breakTileWithGaleSeed		; $4e2c

	ld a,$25		; $4e2f
	call @loadGfxVarsWithIndex		; $4e31
	ld a,$02		; $4e34
	call itemSetState		; $4e36

	ld l,Item.collisionType		; $4e39
	xor a			; $4e3b
	ldi (hl),a		; $4e3c

	; Set collisionRadiusY/X
	inc l			; $4e3d
	ld a,$02		; $4e3e
	ldi (hl),a		; $4e40
	ld (hl),a		; $4e41

	jp objectSetVisible82		; $4e42


@breakTileWithGaleSeed:
	ld a,BREAKABLETILESOURCE_0d		; $4e45
	jp itemTryToBreakTile		; $4e47


@galeCollidedWithWall:
	call @breakTileWithGaleSeed		; $4e4a
	ld a,$26		; $4e4d
	call @loadGfxVarsWithIndex		; $4e4f
	ld a,$03		; $4e52
	call itemSetState		; $4e54
	ld l,Item.collisionType		; $4e57
	res 7,(hl)		; $4e59
	jp objectSetVisible82		; $4e5b


@mysteryCollidedWithEnemy:
	ld h,d			; $4e5e
	ld l,Item.var2a		; $4e5f
	bit 6,(hl)		; $4e61
	jr nz,@mysteryStandard	; $4e63

	; Change id to be the random type selected
	ld l,Item.var03		; $4e65
	ldd a,(hl)		; $4e67
	add ITEMID_EMBER_SEED			; $4e68
	dec l			; $4e6a
	ld (hl),a		; $4e6b

	call _itemLoadAttributesAndGraphics		; $4e6c
	xor a			; $4e6f
	call itemSetAnimation		; $4e70
	ld e,Item.health		; $4e73
	ld a,$ff		; $4e75
	ld (de),a		; $4e77
	jp @seedCollidedWithEnemy		; $4e78


@mysteryStandard:
	ld e,Item.collisionType		; $4e7b
	xor a			; $4e7d
	ld (de),a		; $4e7e
	call objectSetVisible82		; $4e7f

;;
; Sets state to 3, loads gfx for the new effect, plays sound, sets counter1.
;
; @addr{4e82}
@initState3:
	ld e,Item.state		; $4e82
	ld a,$03		; $4e84
	ld (de),a		; $4e86

	ld e,Item.id		; $4e87
	ld a,(de)		; $4e89

;;
; @param	a	Index to use for below table (plus $20, since
;			ITEMID_EMBER_SEED=$20)
; @addr{4e8a}
@loadGfxVarsWithIndex:
	add a			; $4e8a
	ld hl,@data-(ITEMID_EMBER_SEED*4)		; $4e8b
	rst_addDoubleIndex			; $4e8e

	ld e,Item.oamFlagsBackup		; $4e8f
	ldi a,(hl)		; $4e91
	ld (de),a		; $4e92
	inc e			; $4e93
	ld (de),a		; $4e94
	inc e			; $4e95
	ldi a,(hl)		; $4e96
	ld (de),a		; $4e97
	ldi a,(hl)		; $4e98
	ld e,Item.counter1		; $4e99
	ld (de),a		; $4e9b
	ld a,(hl)		; $4e9c
	jp playSound		; $4e9d

; b0: value for Item.oamFlags and oamFlagsBackup
; b1: value for Item.oamTileIndexBase
; b2: value for Item.counter1
; b3: sound effect
@data:
	.db $0a $06 $3a SND_LIGHTTORCH
	.db $0b $10 $3c SND_PIRATE_BELL
	.db $09 $18 $00 SND_LIGHTTORCH
	.db $09 $28 $32 SND_GALE_SEED
	.db $08 $18 $00 SND_MYSTERY_SEED

	.db $09 $28 $b4 SND_GALE_SEED
	.db $09 $28 $1e SND_GALE_SEED
	.db $0b $3c $96 SND_SCENT_SEED

;;
; @addr{4ec0}
_seedItemDelete:
	ld e,Item.subid		; $4ec0
	ld a,(de)		; $4ec2
	or a			; $4ec3
	jr z,@delete			; $4ec4

	ld hl,wIsSeedShooterInUse		; $4ec6
	ld a,(hl)		; $4ec9
	or a			; $4eca
	jr z,@delete			; $4ecb
	dec (hl)		; $4ecd
@delete:
	jp itemDelete		; $4ece


;;
; State 3: typically occurs when the seed collides with a wall or enemy (instead of the
; ground)
; @addr{4ed1}
_seedItemState3:
	ld e,Item.id		; $4ed1
	ld a,(de)		; $4ed3
	sub ITEMID_EMBER_SEED			; $4ed4
	rst_jumpTable			; $4ed6
	.dw _emberSeedBurn
	.dw _seedUpdateAnimation
	.dw _seedUpdateAnimation
	.dw _galeSeedUpdateAnimationAndCounter
	.dw _seedUpdateAnimation

_emberSeedBurn:
	ld h,d			; $4ee1
	ld l,Item.counter1		; $4ee2
	dec (hl)		; $4ee4
	jr z,@breakTile		; $4ee5

	call itemAnimate		; $4ee7
	call _itemUpdateDamageToApply		; $4eea
	ld l,Item.animParameter		; $4eed
	ld b,(hl)		; $4eef
	jr z,+			; $4ef0

	ld l,Item.collisionType		; $4ef2
	ld (hl),$00		; $4ef4
	bit 7,b			; $4ef6
	jr nz,@deleteSelf	; $4ef8
+
	ld l,Item.z		; $4efa
	ldi a,(hl)		; $4efc
	or (hl)			; $4efd
	ld c,$1c		; $4efe
	jp nz,objectUpdateSpeedZ_paramC		; $4f00
	bit 6,b			; $4f03
	ret z			; $4f05

	call objectCheckTileAtPositionIsWater		; $4f06
	jr c,@deleteSelf	; $4f09
	ret			; $4f0b

@breakTile:
	ld a,BREAKABLETILESOURCE_0c		; $4f0c
	call itemTryToBreakTile		; $4f0e
@deleteSelf:
	jp _seedItemDelete		; $4f11


;;
; Generic update function for seed states 2/3
;
; @addr{4f14}
_seedUpdateAnimation:
	ld e,Item.collisionType		; $4f14
	xor a			; $4f16
	ld (de),a		; $4f17
	call itemAnimate		; $4f18
	ld e,Item.animParameter		; $4f1b
	ld a,(de)		; $4f1d
	rlca			; $4f1e
	ret nc			; $4f1f
	jp _seedItemDelete		; $4f20

;;
; State 2: typically occurs when the seed lands on the ground
; @addr{4f23}
_seedItemState2:
	ld e,Item.id		; $4f23
	ld a,(de)		; $4f25
	sub ITEMID_EMBER_SEED			; $4f26
	rst_jumpTable			; $4f28
	.dw _emberSeedBurn
	.dw _scentSeedSmell
	.dw _seedUpdateAnimation
	.dw _galeSeedTryToWarpLink
	.dw _seedUpdateAnimation

;;
; Scent seed in the "smelling" state that attracts enemies
;
; @addr{4f33}
_scentSeedSmell:
	ld h,d			; $4f33
	ld l,Item.counter1		; $4f34
	ld a,(wFrameCounter)		; $4f36
	rrca			; $4f39
	jr c,+			; $4f3a
	dec (hl)		; $4f3c
	jp z,_seedItemDelete		; $4f3d
+
	; Toggle visibility when counter is low enough
	ld a,(hl)		; $4f40
	cp $1e			; $4f41
	jr nc,+			; $4f43
	ld l,Item.visible		; $4f45
	ld a,(hl)		; $4f47
	xor $80			; $4f48
	ld (hl),a		; $4f4a
+
	ld l,Item.yh		; $4f4b
	ldi a,(hl)		; $4f4d
	ldh (<hFFB2),a	; $4f4e
	inc l			; $4f50
	ldi a,(hl)		; $4f51
	ldh (<hFFB3),a	; $4f52

	ld a,$ff		; $4f54
	ld (wScentSeedActive),a		; $4f56
	call itemAnimate		; $4f59
	call _bombPullTowardPoint		; $4f5c
	jp c,_seedItemDelete		; $4f5f
	jp _itemUpdateSpeedZAndCheckHazards		; $4f62

;;
; @addr{4f65}
_galeSeedUpdateAnimationAndCounter:
	call _galeSeedUpdateAnimation		; $4f65
	call itemDecCounter1		; $4f68
	jp z,_seedItemDelete		; $4f6b

	; Toggle visibility when almost disappeared
	ld a,(hl)		; $4f6e
	cp $14			; $4f6f
	ret nc			; $4f71
	ld l,Item.visible		; $4f72
	ld a,(hl)		; $4f74
	xor $80			; $4f75
	ld (hl),a		; $4f77
	ret			; $4f78

;;
; Note: for some reason, this tends to be called twice per frame in the
; "_galeSeedTryToWarpLink" function, which causes the animation to go over, and it skips
; over some of the palettes?
;
; @addr{4f79}
_galeSeedUpdateAnimation:
	call itemAnimate		; $4f79
	ld e,Item.counter1		; $4f7c
	ld a,(de)		; $4f7e
	and $03			; $4f7f
	ret nz			; $4f81

	; Cycle through palettes
	ld e,Item.oamFlagsBackup		; $4f82
	ld a,(de)		; $4f84
	inc a			; $4f85
	and $0b			; $4f86
	ld (de),a		; $4f88
	inc e			; $4f89
	ld (de),a		; $4f8a
	ret			; $4f8b

;;
; Gale seed in its tornado state, will pull in Link if possible
; @addr{4f8c}
_galeSeedTryToWarpLink:
	call _galeSeedUpdateAnimation		; $4f8c
	ld e,Item.state2		; $4f8f
	ld a,(de)		; $4f91
	rst_jumpTable			; $4f92
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Test TILESETFLAG_OUTDOORS
	ld a,(wTilesetFlags)		; $4f9b
.ifdef ROM_AGES
	rrca			; $4f9e
	jr nc,@setSubstate3	; $4f9f
.else
	dec a
	jr nz,@setSubstate3	; $4f49
.endif

	; Check warps enabled, Link not riding companion
	ld a,(wWarpsDisabled)		; $4fa1
	or a			; $4fa4
	jr nz,_galeSeedUpdateAnimationAndCounter	; $4fa5
	ld a,(wLinkObjectIndex)		; $4fa7
	rrca			; $4faa
	jr c,_galeSeedUpdateAnimationAndCounter	; $4fab

	; Don't allow warp to occur if holding a very heavy object?
	ld a,(wLinkGrabState2)		; $4fad
	and $f0			; $4fb0
	cp $40			; $4fb2
	jr z,_galeSeedUpdateAnimationAndCounter	; $4fb4

.ifdef ROM_AGES
	call checkLinkVulnerableAndIDZero		; $4fb6
.else
	call checkLinkID0AndControlNormal
.endif
	jr nc,_galeSeedUpdateAnimationAndCounter	; $4fb9
	call objectCheckCollidedWithLink		; $4fbb
	jr nc,_galeSeedUpdateAnimationAndCounter	; $4fbe

	ld hl,w1Link		; $4fc0
	call objectTakePosition		; $4fc3
	ld e,Item.counter2		; $4fc6
	ld a,$3c		; $4fc8
	ld (de),a		; $4fca
	ld e,Item.state2		; $4fcb
	ld a,$01		; $4fcd
	ld (de),a		; $4fcf
	ld (wMenuDisabled),a		; $4fd0
	ld (wLinkCanPassNpcs),a		; $4fd3
	ld (wDisableScreenTransitions),a		; $4fd6
	ld a,LINK_STATE_SPINNING_FROM_GALE		; $4fd9
	ld (wLinkForceState),a		; $4fdb
	jp objectSetVisible80		; $4fde

@setSubstate3:
	ld e,Item.state2		; $4fe1
	ld a,$03		; $4fe3
	ld (de),a		; $4fe5
	ret			; $4fe6


; Substate 1: Link caught in the gale, but still on the ground
@substate1:
	ld a,(wLinkDeathTrigger)		; $4fe7
	or a			; $4fea
	jr nz,@setSubstate3	; $4feb
	ld h,d			; $4fed
	ld l,Item.counter2		; $4fee
	dec (hl)		; $4ff0
	jr z,+			; $4ff1

	; Only flicker if in group 0??? This causes it to look slightly different when
	; used in the past, as opposed to the present...
	ld a,(wActiveGroup)		; $4ff3
	or a			; $4ff6
	jr z,@flickerAndCopyPositionToLink	; $4ff7
	ret			; $4ff9
+
	ld a,$02		; $4ffa
	ld (de),a		; $4ffc


; Substate 2: Link and gale moving up
@substate2:
	; Move Z position up until it reaches $7f
	ld h,d			; $4ffd
	ld l,Item.zh		; $4ffe
	dec (hl)		; $5000
	dec (hl)		; $5001
	bit 7,(hl)		; $5002
	jr nz,@flickerAndCopyPositionToLink	; $5004

	ld a,$02		; $5006
	ld (w1Link.state2),a		; $5008
	ld a,CUTSCENE_16		; $500b
	ld (wCutsceneTrigger),a		; $500d

	; Open warp menu, delete self
	ld a,$05		; $5010
	call openMenu		; $5012
	jp _seedItemDelete		; $5015

@flickerAndCopyPositionToLink:
	ld e,Item.visible		; $5018
	ld a,(de)		; $501a
	xor $80			; $501b
	ld (de),a		; $501d

	xor a			; $501e
	ld (wLinkSwimmingState),a		; $501f
	ld hl,w1Link		; $5022
	jp objectCopyPosition		; $5025


; Substate 3: doesn't warp Link anywhere, just waiting for it to get deleted
@substate3:
	call itemDecCounter2		; $5028
	jp z,_seedItemDelete		; $502b
	ld l,Item.visible		; $502e
	ld a,(hl)		; $5030
	xor $80			; $5031
	ld (hl),a		; $5033
	ret			; $5034

.ifdef ROM_AGES
;;
; Called for seeds used with seed shooter. Checks for tile collisions and triggers
; "bounces" when that happens.
;
; @param[out]	zflag	Unset when the seed's "effect" should be activated
; @addr{5035}
_seedItemUpdateBouncing:
	call objectGetTileAtPosition		; $5035
	ld hl,_seedDontBounceTilesTable		; $5038
	call findByteInCollisionTable		; $503b
	jr c,@unsetZFlag	; $503e

	ld e,Item.angle		; $5040
	ld a,(de)		; $5042
	bit 2,a			; $5043
	jr z,@movingStraight		; $5045

; Moving diagonal

	call _seedItemCheckDiagonalCollision		; $5047

	; Call this just to update var3c/var3d (tile position / index)?
	push af			; $504a
	call _itemCheckCanPassSolidTile		; $504b
	pop af			; $504e

	jr z,@setZFlag		; $504f
	jr @bounce		; $5051

@movingStraight:
	ld e,Item.var33		; $5053
	xor a			; $5055
	ld (de),a		; $5056
	call objectCheckTileCollision_allowHoles		; $5057
	jr nc,@setZFlag		; $505a

	ld e,Item.var33		; $505c
	ld a,$03		; $505e
	ld (de),a		; $5060
	call _itemCheckCanPassSolidTile		; $5061
	jr z,@setZFlag		; $5064

@bounce:
	call _seedItemClearKnockback		; $5066

	; Decrement bounce counter
	ld h,d			; $5069
	ld l,Item.var34		; $506a
	dec (hl)		; $506c
	jr z,@unsetZFlag	; $506d

	ld l,Item.var33		; $506f
	ld a,(hl)		; $5071
	cp $03			; $5072
	jr z,@reverseBothComponents	; $5074

	; Calculate new angle based on whether it was a vertical or horizontal collision
	ld c,a			; $5076
	ld e,Item.angle		; $5077
	ld a,(de)		; $5079
	rrca			; $507a
	rrca			; $507b
	and $06			; $507c
	add c			; $507e
	ld hl,@angleCalcTable-1		; $507f
	rst_addAToHl			; $5082
	ld a,(hl)		; $5083
	ld (de),a		; $5084

@setZFlag:
	xor a			; $5085
	ret			; $5086

; Flips both X and Y componets
@reverseBothComponents:
	ld l,Item.angle		; $5087
	ld a,(hl)		; $5089
	xor $10			; $508a
	ld (hl),a		; $508c
	xor a			; $508d
	ret			; $508e

@unsetZFlag:
	or d			; $508f
	ret			; $5090


; Used for calculating new angle after bounces
@angleCalcTable:
	.db $1c $0c $14 $04 $0c $1c $04 $14

;;
; Called when a seed is moving in a diagonal direction.
;
; Sets var33 such that bits 0 and 1 are set on horizontal and vertical collisions,
; respectively.
;
; @param	a	Angle
; @param[out]	zflag	Unset if the seed should bounce
; @addr{5099}
_seedItemCheckDiagonalCollision:
	rrca			; $5099
	and $0c			; $509a
	ld hl,@collisionOffsets		; $509c
	rst_addAToHl			; $509f
	xor a			; $50a0
	ldh (<hFF8A),a	; $50a1

	; Loop will iterate twice (first for vertical collision, then horizontal).
	ld e,Item.var33		; $50a3
	ld a,$40		; $50a5
	ld (de),a		; $50a7

@nextComponent:
	ld e,Item.yh		; $50a8
	ld a,(de)		; $50aa
	add (hl)		; $50ab
	ld b,a			; $50ac
	inc hl			; $50ad
	ld e,Item.xh		; $50ae
	ld a,(de)		; $50b0
	add (hl)		; $50b1
	ld c,a			; $50b2

	inc hl			; $50b3
	push hl			; $50b4
	call checkTileCollisionAt_allowHoles		; $50b5
	jr nc,@next		; $50b8

; Collision occurred; check whether it should bounce (set carry flag if so)

	call getTileAtPosition		; $50ba
	ld hl,_seedDontBounceTilesTable		; $50bd
	call findByteInCollisionTable		; $50c0
	ccf			; $50c3
	jr nc,@next	; $50c4

	ld h,d			; $50c6
	ld l,Item.angle		; $50c7
	ld b,(hl)		; $50c9
	call _checkTileIsPassableFromDirection		; $50ca
	ccf			; $50cd
	jr c,@next	; $50ce
	jr z,@next	; $50d0

	; Bounce if the new elevation would be negative
	ld h,d			; $50d2
	ld l,Item.var3e		; $50d3
	add (hl)		; $50d5
	rlca			; $50d6

@next:
	; Rotate carry bit into var33
	ld h,d			; $50d7
	ld l,Item.var33		; $50d8
	rl (hl)			; $50da
	pop hl			; $50dc
	jr nc,@nextComponent	; $50dd

	ld e,Item.var33		; $50df
	ld a,(de)		; $50e1
	or a			; $50e2
	ret			; $50e3


; Offsets from item position to check for collisions at.
; First 2 bytes are offsets for vertical collisions, next 2 are for horizontal.
@collisionOffsets:
	.db $fc $00 $00 $03 ; Up-right
	.db $03 $00 $00 $03 ; Down-right
	.db $03 $00 $00 $fc ; Down-left
	.db $fc $00 $00 $fc ; Up-left


;;
; @param	h,d	Object
; @param[out]	zflag	Set if there are still bounces left?
; @addr{50f4}
_func_50f4:
	ld e,Item.angle		; $50f4
	ld l,Item.knockbackAngle		; $50f6
	ld a,(de)		; $50f8
	add (hl)		; $50f9
	ld hl,_data_5114		; $50fa
	rst_addAToHl			; $50fd
	ld c,(hl)		; $50fe
	ld a,(de)		; $50ff
	cp c			; $5100
	jr z,_seedItemClearKnockback	; $5101

	ld h,d			; $5103
	ld l,Item.var34		; $5104
	dec (hl)		; $5106
	jr z,@unsetZFlag	; $5107

	; Set Item.angle
	ld a,c			; $5109
	ld (de),a		; $510a
	xor a			; $510b
	ret			; $510c

@unsetZFlag:
	or d			; $510d
	ret			; $510e

;;
; @addr{510f}
_seedItemClearKnockback:
	ld e,Item.knockbackCounter		; $510f
	xor a			; $5111
	ld (de),a		; $5112
	ret			; $5113


_data_5114:
	.db $00 $08 $10 $18 $1c $04 $0c $14
	.db $18 $00 $08 $10 $14 $1c $04 $0c
	.db $10 $18 $00 $08 $0c $14 $1c $04
	.db $08 $10 $18 $00 $04 $0c $14 $1c


; List of tiles which seeds don't bounce off of. (Burnable stuff.)
_seedDontBounceTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
	.db $ce $cf $c5 $c5 $c6 $c7 $c8 $c9 $ca
@collisions1:
@collisions3:
@collisions4:
	.db $00

@collisions2:
@collisions5:
	.db TILEINDEX_UNLIT_TORCH
	.db TILEINDEX_LIT_TORCH
	.db $00
.else
;;
; @param[out]	zflag	z if no collision
; @addr{4fdf}
_slingshotCheckCanPassSolidTile:
	call objectCheckTileCollision_allowHoles		; $4fdf
	jr nc,++		; $4fe2
	call _itemCheckCanPassSolidTile		; $4fe4
	ret			; $4fe7
++
	xor a			; $4fe8
	ret			; $4fe9
.endif

;;
; This is an object which serves as a collision for enemies when Dimitri does his eating
; attack. Also checks for eatable tiles.
;
; ITEMID_DIMITRI_MOUTH
; @addr{514d}
itemCode2b:
	ld e,Item.state		; $514d
	ld a,(de)		; $514f
	or a			; $5150
	jr nz,+			; $5151

	; Initialization
	call _itemLoadAttributesAndGraphics		; $5153
	call itemIncState		; $5156
	ld l,Item.counter1		; $5159
	ld (hl),$0c		; $515b
+
	call @calcPosition		; $515d

	; Check for enemy collision?
	ld h,d			; $5160
	ld l,Item.var2a		; $5161
	bit 1,(hl)		; $5163
	jr nz,@swallow		; $5165

	ld a,BREAKABLETILESOURCE_DIMITRI_EAT		; $5167
	call itemTryToBreakTile		; $5169
	jr c,@swallow			; $516c

	; Delete self after 12 frames
	call itemDecCounter1		; $516e
	jr z,@delete		; $5171
	ret			; $5173

@swallow:
	; Set var35 to $01 to tell Dimitri to do his swallow animation?
	ld a,$01		; $5174
	ld (w1Companion.var35),a		; $5176

@delete:
	jp itemDelete		; $5179

;;
; Sets the position for this object around Dimitri's mouth.
;
; @addr{517c}
@calcPosition:
	ld a,(w1Companion.direction)		; $517c
	ld hl,@offsets		; $517f
	rst_addDoubleIndex			; $5182
	ldi a,(hl)		; $5183
	ld c,(hl)		; $5184
	ld b,a			; $5185
	ld hl,w1Companion.yh		; $5186
	jp objectTakePositionWithOffset		; $5189

@offsets:
	.db $f6 $00 ; DIR_UP
	.db $fe $0a ; DIR_RIGHT
	.db $04 $00 ; DIR_DOWN
	.db $fe $f6 ; DIR_LEFT


;;
; ITEMID_BOMBCHUS
; @addr{5194}
itemCode0d:
	call _bombchuCountdownToExplosion		; $5194

	; If state is $ff, it's exploding
	ld e,Item.state		; $5197
	ld a,(de)		; $5199
	cp $ff			; $519a
	jp nc,_itemUpdateExplosion		; $519c

	call objectCheckWithinRoomBoundary		; $519f
	jp nc,itemDelete		; $51a2

	call objectSetPriorityRelativeToLink_withTerrainEffects		; $51a5

	ld a,(wTilesetFlags)		; $51a8
	and TILESETFLAG_SIDESCROLL			; $51ab
	jr nz,@sidescroll	; $51ad

	; This call will return if the bombchu falls into a hole/water/lava.
	ld c,$20		; $51af
	call _itemUpdateSpeedZAndCheckHazards		; $51b1

	ld e,Item.state		; $51b4
	ld a,(de)		; $51b6
	rst_jumpTable			; $51b7

	.dw @tdState0
	.dw @tdState1
	.dw @tdState2
	.dw @tdState3
	.dw @tdState4

@sidescroll:
	ld e,Item.var32		; $51c2
	ld a,(de)		; $51c4
	or a			; $51c5
	jr nz,+			; $51c6

	ld c,$18		; $51c8
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $51ca
	jp c,itemDelete		; $51cd
+
	ld e,Item.state		; $51d0
	ld a,(de)		; $51d2
	rst_jumpTable			; $51d3

	.dw @ssState0
	.dw @ssState1
	.dw @ssState2
	.dw @ssState3


@tdState0:
	call _itemLoadAttributesAndGraphics		; $51dc
	call decNumBombchus		; $51df

	ld h,d			; $51e2
	ld l,Item.state		; $51e3
	inc (hl)		; $51e5

	; var30 used to cycle through possible targets
	ld l,Item.var30		; $51e6
	ld (hl),FIRST_ENEMY_INDEX		; $51e8

	ld l,Item.speedTmp		; $51ea
	ld (hl),SPEED_80		; $51ec

	ld l,Item.counter1		; $51ee
	ld (hl),$10		; $51f0

	; Explosion countdown
	inc l			; $51f2
	ld (hl),$b4		; $51f3

	; Collision radius is used as vision radius before a target is found
	ld l,Item.collisionRadiusY		; $51f5
	ld a,$18		; $51f7
	ldi (hl),a		; $51f9
	ld (hl),a		; $51fa

	; Default "direction to turn" on encountering a hole
	ld l,Item.var31		; $51fb
	ld (hl),$08		; $51fd

	; Initialize angle based on link's facing direction
	ld l,Item.angle		; $51ff
	ld a,(w1Link.direction)		; $5201
	swap a			; $5204
	rrca			; $5206
	ld (hl),a		; $5207
	ld l,Item.direction		; $5208
	ld (hl),$ff		; $520a

	call _bombchuSetAnimationFromAngle		; $520c
	jp _bombchuSetPositionInFrontOfLink		; $520f


; State 1: waiting to reach the ground (if dropped from midair)
@tdState1:
	ld h,d			; $5212
	ld l,Item.zh		; $5213
	bit 7,(hl)		; $5215
	jr nz,++		; $5217

	; Increment state if on the ground
	ld l,e			; $5219
	inc (hl)		; $521a

; State 2: searching for target
@tdState2:
	call _bombchuCheckForEnemyTarget		; $521b
	ret z			; $521e
++
	call _bombchuUpdateSpeed		; $521f
	call _itemUpdateConveyorBelt		; $5222

@animate:
	jp itemAnimate		; $5225


; State 3: target found
@tdState3:
	ld h,d			; $5228
	ld l,Item.counter1		; $5229
	dec (hl)		; $522b
	jp nz,_itemUpdateConveyorBelt		; $522c

	; Set counter
	ld (hl),$0a		; $522f

	; Increment state
	ld l,e			; $5231
	inc (hl)		; $5232


; State 4: Dashing toward target
@tdState4:
	call _bombchuCheckCollidedWithTarget		; $5233
	jp c,_bombchuClearCounter2AndInitializeExplosion		; $5236

	call _bombchuUpdateVelocity		; $5239
	call _itemUpdateConveyorBelt		; $523c
	jr @animate		; $523f


; Sidescrolling states

@ssState0:
	; Do the same initialization as top-down areas
	call @tdState0		; $5241

	; Force the bombchu to face left or right
	ld e,Item.angle		; $5244
	ld a,(de)		; $5246
	bit 3,a			; $5247
	ret nz			; $5249

	add $08			; $524a
	ld (de),a		; $524c
	jp _bombchuSetAnimationFromAngle		; $524d

; State 1: searching for target
@ssState1:
	ld e,Item.speed		; $5250
	ld a,SPEED_80		; $5252
	ld (de),a		; $5254
	call _bombchuCheckForEnemyTarget		; $5255
	ret z			; $5258

	; Target not found yet

	call _bombchuCheckWallsAndApplySpeed		; $5259

@ssAnimate:
	jp itemAnimate		; $525c


; State 2: Target found, wait for a few frames
@ssState2:
	call itemDecCounter1		; $525f
	ret nz			; $5262

	ld (hl),$0a		; $5263

	; Increment state
	ld l,e			; $5265
	inc (hl)		; $5266

; State 3: Chase after target
@ssState3:
	call _bombchuCheckCollidedWithTarget		; $5267
	jp c,_bombchuClearCounter2AndInitializeExplosion		; $526a
	call _bombchuUpdateVelocityAndClimbing_sidescroll		; $526d
	jr @ssAnimate		; $5270


;;
; Updates bombchu's position & speed every frame, and the angle every 8 frames.
;
; @addr{5272}
_bombchuUpdateVelocity:
	ld a,(wFrameCounter)		; $5272
	and $07			; $5275
	call z,_bombchuUpdateAngle_topDown		; $5277

;;
; @addr{527a}
_bombchuUpdateSpeed:
	call @updateSpeed		; $527a

	; Note: this will actually update the Z position for a second time in the frame?
	; (due to earlier call to _itemUpdateSpeedZAndCheckHazards)
	ld c,$18		; $527d
	call objectUpdateSpeedZ_paramC		; $527f

	jp objectApplySpeed		; $5282


; Update the speed based on what kind of tile it's on
@updateSpeed:
	ld e,Item.angle		; $5285
	call _bombchuGetTileCollisions		; $5287

	cp SPECIALCOLLISION_HOLE			; $528a
	jr z,@impassableTile	; $528c

	cp SPECIALCOLLISION_15			; $528e
	jr z,@impassableTile	; $5290

	; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	inc a			; $5292
	jr z,@impassableTile	; $5293

	; Set the bombchu's speed (halve it if it's on a solid tile)
	dec a			; $5295
	ld e,Item.speedTmp		; $5296
	ld a,(de)		; $5298
	jr z,+			; $5299

	ld e,a			; $529b
	ld hl,_bounceSpeedReductionMapping		; $529c
	call lookupKey		; $529f
+
	; If new speed < old speed, trigger a jump. (Happens when a bombchu starts
	; climbing a wall)
	ld h,d			; $52a2
	ld l,Item.speed		; $52a3
	cp (hl)			; $52a5
	ld (hl),a		; $52a6
	ret nc			; $52a7

	ld l,Item.speedZ		; $52a8
	ld a,$80		; $52aa
	ldi (hl),a		; $52ac
	ld (hl),$ff		; $52ad
	ret			; $52af

; Bombchus can pass most tiles, even walls, but not holes (perhaps a few other things).
@impassableTile:
	; Item.var31 holds the direction the bombchu should turn to continue moving closer
	; to the target.
	ld h,d			; $52b0
	ld l,Item.var31		; $52b1
	ld a,(hl)		; $52b3
	ld l,Item.angle		; $52b4
	add (hl)		; $52b6
	and $18			; $52b7
	ld (hl),a		; $52b9
	jp _bombchuSetAnimationFromAngle		; $52ba

;;
; Get tile collisions at the front end of the bombchu.
;
; @param	e	Angle address (object variable)
; @param[out]	a	Collision value
; @param[out]	hl	Address of collision data
; @param[out]	zflag	Set if there is no collision.
; @addr{52bd}
_bombchuGetTileCollisions:
	ld h,d			; $52bd
	ld l,Item.yh		; $52be
	ld b,(hl)		; $52c0
	ld l,Item.xh		; $52c1
	ld c,(hl)		; $52c3

	ld a,(de)		; $52c4
	rrca			; $52c5
	rrca			; $52c6
	ld hl,@offsets		; $52c7
	rst_addAToHl			; $52ca
	ldi a,(hl)		; $52cb
	add b			; $52cc
	ld b,a			; $52cd
	ld a,(hl)		; $52ce
	add c			; $52cf
	ld c,a			; $52d0
	jp getTileCollisionsAtPosition		; $52d1

@offsets:
	.db $fc $00 ; DIR_UP
	.db $02 $03 ; DIR_RIGHT
	.db $06 $00 ; DIR_DOWN
	.db $02 $fc ; DIR_LEFT

;;
; @addr{52dc}
_bombchuUpdateVelocityAndClimbing_sidescroll:
	ld a,(wFrameCounter)		; $52dc
	and $07			; $52df
	call z,_bombchuUpdateAngle_sidescrolling		; $52e1

;;
; In sidescrolling areas, this updates the bombchu's "climbing wall" state.
;
; @addr{52e4}
_bombchuCheckWallsAndApplySpeed:
	call @updateWallClimbing		; $52e4
	jp objectApplySpeed		; $52e7

;;
; @addr{52ea}
@updateWallClimbing:
	ld e,Item.var32		; $52ea
	ld a,(de)		; $52ec
	or a			; $52ed
	jr nz,@climbingWall	; $52ee

	; Return if it hasn't collided with a wall
	ld e,Item.angle		; $52f0
	call _bombchuGetTileCollisions		; $52f2
	ret z			; $52f5

	; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	inc a			; $52f6
	jr nz,+			; $52f7

	; Reverse direction if it runs into such a tile
	ld e,Item.angle		; $52f9
	ld a,(de)		; $52fb
	xor $10			; $52fc
	ld (de),a		; $52fe
	jp _bombchuSetAnimationFromAngle		; $52ff
+
	; Tell it to start climbing the wall
	ld h,d			; $5302
	ld l,Item.angle		; $5303
	ld a,(hl)		; $5305
	ld (hl),$00		; $5306
	ld l,Item.var33		; $5308
	ld (hl),a		; $530a
	ld l,Item.var32		; $530b
	ld (hl),$01		; $530d
	jp _bombchuSetAnimationFromAngle		; $530f

@climbingWall:
	; Check if the bombchu is still touching the wall it's supposed to be climbing
	ld e,Item.var33		; $5312
	call _bombchuGetTileCollisions		; $5314
	jr nz,@@touchingWall	; $5317

	; Bombchu is no longer touching the wall it's climbing. It will now "uncling"; the
	; following code figures out which direction to make it face.
	; The direction will be the "former angle" (var33) unless it's on the ceiling, in
	; which case, it will just continue in its current direction.

	ld h,d			; $5319
	ld l,Item.angle		; $531a
	ld e,Item.var33		; $531c
	ld a,(de)		; $531e
	or a			; $531f
	jr nz,+			; $5320

	ld a,(hl)		; $5322
	ld e,Item.var33		; $5323
	ld (de),a		; $5325
+
	; Revert to former angle and uncling
	ld a,(de)		; $5326
	ld (hl),a		; $5327
	ld l,Item.var32		; $5328
	xor a			; $532a
	ldi (hl),a		; $532b
	inc l			; $532c
	ld (hl),a		; $532d

	; Clear vertical speed
	ld l,Item.speedZ		; $532e
	ldi (hl),a		; $5330
	ldi (hl),a		; $5331

	ld l,Item.direction		; $5332
	ld (hl),$ff		; $5334
	jp _bombchuSetAnimationFromAngle		; $5336

@@touchingWall:
	; Check if it hits a wall
	ld e,Item.angle		; $5339
	call _bombchuGetTileCollisions		; $533b
	ret z			; $533e

	; If so, try to cling to it
	ld h,d			; $533f
	ld l,Item.angle		; $5340
	ld b,(hl)		; $5342
	ld e,Item.var33		; $5343
	ld a,(de)		; $5345
	xor $10			; $5346
	ld (hl),a		; $5348

	; If both the new and old angles are horizontal, stop clinging to the wall?
	bit 3,a			; $5349
	jr z,+			; $534b
	bit 3,b			; $534d
	jr z,+			; $534f

	ld l,Item.var32		; $5351
	ld (hl),$00		; $5353
+
	; Set var33
	ld a,b			; $5355
	ld (de),a		; $5356

	; If a==0 (old angle was "up"), the bombchu will cling to the ceiling (var34 will
	; be nonzero).
	or a			; $5357
	ld l,Item.var34		; $5358
	ld (hl),$00		; $535a
	jr nz,_bombchuSetAnimationFromAngle	; $535c
	inc (hl)		; $535e
	jr _bombchuSetAnimationFromAngle		; $535f

;;
; Sets the bombchu's angle relative to its target.
;
; @addr{5361}
_bombchuUpdateAngle_topDown:
	ld a,Object.yh		; $5361
	call objectGetRelatedObject2Var		; $5363
	ld b,(hl)		; $5366
	ld l,Enemy.xh		; $5367
	ld c,(hl)		; $5369
	call objectGetRelativeAngle		; $536a

	; Turn the angle into a cardinal direction, set that to the bombchu's angle
	ld b,a			; $536d
	add $04			; $536e
	and $18			; $5370
	ld e,Item.angle		; $5372
	ld (de),a		; $5374

	; Write $08 or $f8 to Item.var31, depending on which "side" the bombchu will need
	; to turn towards later?
	sub b			; $5375
	and $1f			; $5376
	cp $10			; $5378
	ld a,$08		; $537a
	jr nc,+			; $537c
	ld a,$f8		; $537e
+
	ld e,Item.var31		; $5380
	ld (de),a		; $5382

;;
; If [Item.angle] != [Item.direction], this updates the item's animation. The animation
; index is 0-3 depending on the item's angle (or sometimes it's 4-5 if var34 is set).
;
; Note: this sets the direction to equal the angle value, which is non-standard (usually
; the direction is a value from 0-3, not from $00-$1f).
;
; Also, this assumes that the item's angle is a cardinal direction?
;
; @addr{5383}
_bombchuSetAnimationFromAngle:
	ld h,d			; $5383
	ld l,Item.direction		; $5384
	ld e,Item.angle		; $5386
	ld a,(de)		; $5388
	cp (hl)			; $5389
	ret z			; $538a

	; Update Item.direction
	ld (hl),a		; $538b

	; Convert angle to a value from 0-3. (Assumes that the angle is a cardinal
	; direction?)
	swap a			; $538c
	rlca			; $538e

	ld l,Item.var34		; $538f
	bit 0,(hl)		; $5391
	jr z,+			; $5393
	dec a			; $5395
	ld a,$04		; $5396
	jr z,+			; $5398
	inc a			; $539a
+
	jp itemSetAnimation		; $539b

;;
; Sets up a bombchu's angle toward its target such that it will only move along its
; current axis; so if it's moving along the X axis, it will chase on the X axis, and
; vice-versa.
;
; @addr{539e}
_bombchuUpdateAngle_sidescrolling:
	ld a,Object.yh		; $539e
	call objectGetRelatedObject2Var		; $53a0
	ld b,(hl)		; $53a3
	ld l,Enemy.xh		; $53a4
	ld c,(hl)		; $53a6
	call objectGetRelativeAngle		; $53a7

	ld b,a			; $53aa
	ld e,Item.angle		; $53ab
	ld a,(de)		; $53ad
	bit 3,a			; $53ae
	ld a,b			; $53b0
	jr nz,@leftOrRight	; $53b1

; Bombchu facing up or down

	sub $08			; $53b3
	and $1f			; $53b5
	cp $10			; $53b7
	ld a,$00		; $53b9
	jr c,@setAngle		; $53bb
	ld a,$10		; $53bd
	jr @setAngle		; $53bf

; Bombchu facing left or right
@leftOrRight:
	cp $10			; $53c1
	ld a,$08		; $53c3
	jr c,@setAngle		; $53c5
	ld a,$18		; $53c7

@setAngle:
	ld e,Item.angle		; $53c9
	ld (de),a		; $53cb
	jr _bombchuSetAnimationFromAngle		; $53cc

;;
; Set a bombchu's position to be slightly in front of Link, based on his direction. If it
; would put the item in a wall, it will default to Link's exact position instead.
;
; @param[out]	zflag	Set if the item defaulted to Link's exact position due to a wall
; @addr{53ce}
_bombchuSetPositionInFrontOfLink:
	ld hl,w1Link.yh		; $53ce
	ld b,(hl)		; $53d1
	ld l,<w1Link.xh		; $53d2
	ld c,(hl)		; $53d4

	ld a,(wActiveGroup)		; $53d5
	cp FIRST_SIDESCROLL_GROUP			; $53d8
	ld l,<w1Link.direction		; $53da
	ld a,(hl)		; $53dc

	ld hl,@normalOffsets		; $53dd
	jr c,+			; $53e0
	ld hl,@sidescrollOffsets		; $53e2
+
	; Set the item's position to [Link's position] + [Offset from table]
	rst_addDoubleIndex			; $53e5
	ld e,Item.yh		; $53e6
	ldi a,(hl)		; $53e8
	add b			; $53e9
	ld (de),a		; $53ea
	ld e,Item.xh		; $53eb
	ld a,(hl)		; $53ed
	add c			; $53ee
	ld (de),a		; $53ef

	; Check if it's in a wall
	push bc			; $53f0
	call objectGetTileCollisions		; $53f1
	pop bc			; $53f4
	cp $0f			; $53f5
	ret nz			; $53f7

	; If the item would end up on a solid tile, put it directly on Link instead
	; (ignore the offset from the table)
	ld a,c			; $53f8
	ld (de),a		; $53f9
	ld e,Item.yh		; $53fa
	ld a,b			; $53fc
	ld (de),a		; $53fd
	ret			; $53fe

; Offsets relative to Link where items will appear

@normalOffsets:
	.db $f4 $00 ; DIR_UP
	.db $02 $0c ; DIR_RIGHT
	.db $0c $00 ; DIR_DOWN
	.db $02 $f4 ; DIR_LEFT

@sidescrollOffsets:
	.db $00 $00 ; DIR_UP
	.db $02 $0c ; DIR_RIGHT
	.db $00 $00 ; DIR_DOWN
	.db $02 $f4 ; DIR_LEFT


;;
; Bombchus call this every frame.
;
; @addr{540f}
_bombchuCountdownToExplosion:
	call itemDecCounter2		; $540f
	ret nz			; $5412

;;
; @addr{5413}
_bombchuClearCounter2AndInitializeExplosion:
	ld e,Item.counter2		; $5413
	xor a			; $5415
	ld (de),a		; $5416
	jp _itemInitializeBombExplosion		; $5417

;;
; @param[out]	cflag	Set on collision or if the enemy has died
; @addr{541a}
_bombchuCheckCollidedWithTarget:
	ld a,Object.health		; $541a
	call objectGetRelatedObject2Var		; $541c
	ld a,(hl)		; $541f
	or a			; $5420
	scf			; $5421
	ret z			; $5422
	jp checkObjectsCollided		; $5423

;;
; Each time this is called, it checks one enemy and sets it as the target if it meets all
; the conditions (close enough, valid target, etc).
;
; Each time it loops through all enemies, the bombchu's vision radius increases.
;
; @param[out]	zflag	Set if a valid target is found
; @addr{5426}
_bombchuCheckForEnemyTarget:
	; Check if the target enemy is enabled
	ld e,Item.var30		; $5426
	ld a,(de)		; $5428
	ld h,a			; $5429
	ld l,Enemy.enabled		; $542a
	ld a,(hl)		; $542c
	or a			; $542d
	jr z,@nextTarget	; $542e

	; Check it's visible
	ld l,Enemy.visible		; $5430
	bit 7,(hl)		; $5432
	jr z,@nextTarget	; $5434

	; Check it's a valid target (see data/bombchuTargets.s)
	ld l,Enemy.id		; $5436
	ld a,(hl)		; $5438
	push hl			; $5439
	ld hl,bombchuTargets		; $543a
	call checkFlag		; $543d
	pop hl			; $5440
	jr z,@nextTarget	; $5441

	; Check if it's within the bombchu's "collision radius" (actually used as vision
	; radius)
	call checkObjectsCollided		; $5443
	jr nc,@nextTarget	; $5446

	; Valid target established; set relatedObj2 to the target
	ld a,h			; $5448
	ld h,d			; $5449
	ld l,Item.relatedObj2+1		; $544a
	ldd (hl),a		; $544c
	ld (hl),Enemy.enabled		; $544d

	; Stop using collision radius as vision radius
	ld l,Item.collisionRadiusY		; $544f
	ld a,$06		; $5451
	ldi (hl),a		; $5453
	ld (hl),a		; $5454

	; Set counter1, speedTmp
	ld l,Item.counter1		; $5455
	ld (hl),$0c		; $5457
	ld l,Item.speedTmp		; $5459
	ld (hl),SPEED_1c0		; $545b

	; Increment state
	ld l,Item.state		; $545d
	inc (hl)		; $545f

	ld a,(wTilesetFlags)		; $5460
	and TILESETFLAG_SIDESCROLL			; $5463
	jr nz,+			; $5465

	call _bombchuUpdateAngle_topDown		; $5467
	xor a			; $546a
	ret			; $546b
+
	call _bombchuUpdateAngle_sidescrolling		; $546c
	xor a			; $546f
	ret			; $5470

@nextTarget:
	; Increment target enemy index by one
	inc h			; $5471
	ld a,h			; $5472
	cp LAST_ENEMY_INDEX+1			; $5473
	jr c,+			; $5475

	; Looped through all enemies
	call @incVisionRadius		; $5477
	ld a,FIRST_ENEMY_INDEX		; $547a
+
	ld e,Item.var30		; $547c
	ld (de),a		; $547e
	or d			; $547f
	ret			; $5480

@incVisionRadius:
	; Increase collisionRadiusY/X by increments of $10, but keep it below $70. (these
	; act as the bombchu's vision radius)
	ld e,Item.collisionRadiusY		; $5481
	ld a,(de)		; $5483
	add $10			; $5484
	cp $60			; $5486
	jr c,+			; $5488
	ld a,$18		; $548a
+
	ld (de),a		; $548c
	inc e			; $548d
	ld (de),a		; $548e
	ret			; $548f

.include "build/data/bombchuTargets.s"

;;
; ITEMID_BOMB
; @addr{54a0}
itemCode03:
	ld e,Item.var2f		; $54a0
	ld a,(de)		; $54a2
	bit 5,a			; $54a3
	jr nz,@label_07_153	; $54a5

	bit 7,a			; $54a7
	jp nz,_bombResetAnimationAndSetVisiblec1		; $54a9

	; Check if exploding
	bit 4,a			; $54ac
	jp nz,_bombUpdateExplosion		; $54ae

	ld e,Item.state		; $54b1
	ld a,(de)		; $54b3
	rst_jumpTable			; $54b4

	.dw @state0
	.dw @state1
	.dw @state2


; Not sure when this is executed. Causes the bomb to be deleted.
@label_07_153:
	ld h,d			; $54bb
	ld l,Item.state		; $54bc
	ldi a,(hl)		; $54be
	cp $02			; $54bf
	jr nz,+			; $54c1

	; Check bit 1 of Item.state2 (check if it's being held?)
	bit 1,(hl)		; $54c3
	call z,dropLinkHeldItem		; $54c5
+
	jp itemDelete		; $54c8

; State 1: bomb is motionless on the ground
@state1:
	ld c,$20		; $54cb
	call _bombUpdateThrowingVerticallyAndCheckDelete		; $54cd
	ret c			; $54d0

	; No idea what function is for
	call _bombPullTowardPoint		; $54d1
	jp c,itemDelete		; $54d4

	call _itemUpdateConveyorBelt		; $54d7
	jp _bombUpdateAnimation		; $54da

; State 0/2: bomb is being picked up / thrown around
@state0:
@state2:
	ld e,Item.state2		; $54dd
	ld a,(de)		; $54df
	rst_jumpTable			; $54e0

	.dw @heldState0
	.dw @heldState1
	.dw @heldState2
	.dw @heldState3


; Bomb just picked up
@heldState0:
	call itemIncState2		; $54e9

	ld l,Item.var2f		; $54ec
	set 6,(hl)		; $54ee

	ld l,Item.var37		; $54f0
	res 0,(hl)		; $54f2
	call _bombInitializeIfNeeded		; $54f4

; Bomb being held
@heldState1:
	; Bombs don't explode while being held if the peace ring is equipped
	ld a,PEACE_RING		; $54f7
	call cpActiveRing		; $54f9
	jp z,_bombResetAnimationAndSetVisiblec1		; $54fc

	call _bombUpdateAnimation		; $54ff
	ret z			; $5502

	; If z-flag was unset (bomb started exploding), release the item?
	jp dropLinkHeldItem		; $5503

; Bomb being thrown
@heldState2:
@heldState3:
	; Set state2 to $03
	ld a,$03		; $5506
	ld (de),a		; $5508

	; Update movement?
	call _bombUpdateThrowingLaterally		; $5509

	ld e,Item.var39		; $550c
	ld a,(de)		; $550e
	ld c,a			; $550f

	; Update throwing, return if the bomb was deleted from falling into a hazard
	call _bombUpdateThrowingVerticallyAndCheckDelete		; $5510
	ret c			; $5513

	; Jump if the item is not on the ground
	jr z,+			; $5514

	; If on the ground...
	call _itemBounce		; $5516
	jr c,@stoppedBouncing			; $5519

	; No idea what this function is for
	call _bombPullTowardPoint		; $551b
	jp c,itemDelete		; $551e
+
	jp _bombUpdateAnimation		; $5521

@stoppedBouncing:
	; Bomb goes to state 1 (motionless on the ground)
	ld h,d			; $5524
	ld l,Item.state		; $5525
	ld (hl),$01		; $5527

	ld l,Item.var2f		; $5529
	res 6,(hl)		; $552b

	jp _bombUpdateAnimation		; $552d

;;
; @param[out]	cflag	Set if the item was deleted
; @param[out]	zflag	Set if the bomb is not on the ground
; @addr{5530}
_bombUpdateThrowingVerticallyAndCheckDelete:
	push bc			; $5530
	ld a,(wTilesetFlags)		; $5531
	and TILESETFLAG_SIDESCROLL			; $5534
	jr z,+			; $5536

	; If in a sidescrolling area, allow Y values between $08-$f7?
	ld e,Item.yh		; $5538
	ld a,(de)		; $553a
	sub $08			; $553b
	cp $f0			; $553d
	ccf			; $553f
	jr c,++			; $5540
+
	call objectCheckWithinRoomBoundary		; $5542
++
	pop bc			; $5545
	jr nc,@delete		; $5546

	; Within the room boundary

	; Return if it hasn't landed in a hazard (hole/water/lava)
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $5548
	ret nc			; $554b

.ifdef ROM_AGES
	; Check if room $0050 (Present overworld, bomb upgrade screen)
	ld bc,$0050		; $554c
.else
	ld bc,$04ef		; $554c
.endif
	ld a,(wActiveGroup)		; $554f
	cp b			; $5552
	jr nz,@delete		; $5553
	ld a,(wActiveRoom)		; $5555
	cp c			; $5558
	jr nz,@delete		; $5559

	; If so, trigger a cutscene?
	ld a,$01		; $555b
	ld (wTmpcfc0.bombUpgradeCutscene.state),a		; $555d

@delete:
	call itemDelete		; $5560
	scf			; $5563
	ret			; $5564

;;
; Update function for bombs and bombchus while they're exploding
;
; @addr{5565}
_itemUpdateExplosion:
	; animParameter specifies:
	;  Bits 0-4: collision radius
	;  Bit 6:    Zero out "collisionType" if set?
	;  Bit 7:    End of animation (delete self)
	ld h,d			; $5565
	ld l,Item.animParameter		; $5566
	ld a,(hl)		; $5568
	bit 7,a			; $5569
	jp nz,itemDelete		; $556b

	ld l,Item.collisionType		; $556e
	bit 6,a			; $5570
	jr z,+			; $5572
	ld (hl),$00		; $5574
+
	ld c,(hl)		; $5576
	ld l,Item.collisionRadiusY		; $5577
	and $1f			; $5579
	ldi (hl),a		; $557b
	ldi (hl),a		; $557c

	; If bit 7 of Item.collisionType is set, check for collision with Link
	bit 7,c			; $557d
	call nz,_explosionCheckAndApplyLinkCollision		; $557f

	ld h,d			; $5582
	ld l,Item.counter1		; $5583
	bit 7,(hl)		; $5585
	call z,_explosionTryToBreakNextTile		; $5587
	jp itemAnimate		; $558a

;;
; Bombs call each frame if bit 4 of Item.var2f is set.
;
; @addr{558d}
_bombUpdateExplosion:
	ld h,d			; $558d
	ld l,Item.state		; $558e
	ld a,(hl)		; $5590
	cp $ff			; $5591
	jr nz,_itemInitializeBombExplosion	; $5593
	jr _itemUpdateExplosion		; $5595

;;
; @param[out]	zflag	Set if the bomb isn't exploding (not sure if it gets unset on just
;			one frame, or all frames after the explosion starts)
; @addr{5597}
_bombUpdateAnimation:
	call itemAnimate		; $5597
	ld e,Item.animParameter		; $559a
	ld a,(de)		; $559c
	or a			; $559d
	ret z			; $559e

;;
; Initializes a bomb explosion?
;
; @param[out]	zflag
; @addr{559f}
_itemInitializeBombExplosion:
	ld h,d			; $559f
	ld l,Item.oamFlagsBackup		; $55a0
	ld a,$0a		; $55a2
	ldi (hl),a		; $55a4
	ldi (hl),a		; $55a5

	; Set Item.oamTileIndexBase
	ld (hl),$0c		; $55a6

	; Enable collisions
	ld l,Item.collisionType		; $55a8
	set 7,(hl)		; $55aa

	; Decrease damage if not using blast ring
	ld a,BLAST_RING		; $55ac
	call cpActiveRing		; $55ae
	jr nz,+			; $55b1
	ld l,Item.damage		; $55b3
	dec (hl)		; $55b5
	dec (hl)		; $55b6
+
	; State $ff means exploding
	ld l,Item.state		; $55b7
	ld (hl),$ff		; $55b9
	ld l,Item.counter1		; $55bb
	ld (hl),$08		; $55bd

	ld l,Item.var2f		; $55bf
	ld a,(hl)		; $55c1
	or $50			; $55c2
	ld (hl),a		; $55c4

	ld l,Item.id		; $55c5
	ldd a,(hl)		; $55c7

	; Reset bit 1 of Item.enabled
	res 1,(hl)		; $55c8

	; Check if this is a bomb, as opposed to a bombchu?
	cp ITEMID_BOMB			; $55ca
	ld a,$01		; $55cc
	jr z,+			; $55ce
	ld a,$06		; $55d0
+
	call itemSetAnimation		; $55d2
	call objectSetVisible80		; $55d5
	ld a,SND_EXPLOSION		; $55d8
	call playSound		; $55da
	or d			; $55dd
	ret			; $55de

;;
; @addr{55df}
_bombInitializeIfNeeded:
	ld h,d			; $55df
	ld l,Item.var37		; $55e0
	bit 7,(hl)		; $55e2
	ret nz			; $55e4

	set 7,(hl)		; $55e5
	call decNumBombs		; $55e7
	call _itemLoadAttributesAndGraphics		; $55ea
	call _itemMergeZPositionIfSidescrollingArea		; $55ed

;;
; @addr{55f0}
_bombResetAnimationAndSetVisiblec1:
	xor a			; $55f0
	call itemSetAnimation		; $55f1
	jp objectSetVisiblec1		; $55f4

;;
; Bombs call this to check for collision with Link and apply the damage.
;
; @addr{55f7}
_explosionCheckAndApplyLinkCollision:
	; Return if the bomb has already hit Link
	ld h,d			; $55f7
	ld l,Item.var37		; $55f8
	bit 6,(hl)		; $55fa
	ret nz			; $55fc

	ld a,(w1Companion.id)		; $55fd
	cp SPECIALOBJECTID_MINECART			; $5600
	ret z			; $5602

	ld a,BOMBPROOF_RING		; $5603
	call cpActiveRing		; $5605
	ret z			; $5608

	call checkLinkVulnerable		; $5609
	ret nc			; $560c

	; Check if close enough on the Z axis
	ld h,d			; $560d
	ld l,Item.collisionRadiusY		; $560e
	ld a,(hl)		; $5610
	ld c,a			; $5611
	add a			; $5612
	ld b,a			; $5613
	ld l,Item.zh		; $5614
	ld a,(w1Link.zh)		; $5616
	sub (hl)		; $5619
	add c			; $561a
	cp b			; $561b
	ret nc			; $561c

	call objectCheckCollidedWithLink_ignoreZ		; $561d
	ret nc			; $5620

	; Collision occurred; now give Link knockback, etc.

	call objectGetAngleTowardLink		; $5621

	; Set bit 6 to prevent double-hits?
	ld h,d			; $5624
	ld l,Item.var37		; $5625
	set 6,(hl)		; $5627

	ld l,Item.damage		; $5629
	ld c,(hl)		; $562b
	ld hl,w1Link.damageToApply		; $562c
	ld (hl),c		; $562f

	ld l,<w1Link.knockbackCounter		; $5630
	ld (hl),$0c		; $5632

	; knockbackAngle
	dec l			; $5634
	ldd (hl),a		; $5635

	; invincibilityCounter
	ld (hl),$10		; $5636

	; var2a
	dec l			; $5638
	ld (hl),$01		; $5639

	jp linkApplyDamage		; $563b

;;
; Checks whether nearby tiles should be blown up from the explosion.
;
; Each call checks one tile for deletion. After 9 calls, all spots will have been checked.
;
; @param	hl	Pointer to a counter (should count down from 8 to 0)
; @addr{563e}
_explosionTryToBreakNextTile:
	ld a,(hl)		; $563e
	dec (hl)		; $563f
	ld l,a			; $5640
	add a			; $5641
	add l			; $5642
	ld hl,@data		; $5643
	rst_addAToHl			; $5646

	; Verify Z position is close enough (for non-sidescrolling areas)
	ld a,(wTilesetFlags)		; $5647
	and TILESETFLAG_SIDESCROLL			; $564a
	ld e,Item.zh		; $564c
	ld a,(de)		; $564e
	jr nz,+			; $564f

	sub $02			; $5651
	cp (hl)			; $5653
	ret c			; $5654

	xor a			; $5655
+
	ld c,a			; $5656
	inc hl			; $5657
	ldi a,(hl)		; $5658
	add c			; $5659
	ld b,a			; $565a

	ld a,(hl)		; $565b
	ld c,a			; $565c

	; bc = offset to add to explosion's position

	; Get Y position of tile, return if out of bounds
	ld h,d			; $565d
	ld e,$00		; $565e
	bit 7,b			; $5660
	jr z,+			; $5662
	dec e			; $5664
+
	ld l,Item.yh		; $5665
	ldi a,(hl)		; $5667
	add b			; $5668
	ld b,a			; $5669
	ld a,$00		; $566a
	adc e			; $566c
	ret nz			; $566d

	; Get X position of tile, return if out of bounds
	inc l			; $566e
	ld e,$00		; $566f
	bit 7,c			; $5671
	jr z,+			; $5673
	dec e			; $5675
+
	ld a,(hl)		; $5676
	add c			; $5677
	ld c,a			; $5678
	ld a,$00		; $5679
	adc e			; $567b
	ret nz			; $567c

	ld a,BREAKABLETILESOURCE_04		; $567d
	jp tryToBreakTile		; $567f

; The following is a list of offsets from the center of the bomb at which to try
; destroying tiles.
;
; b0: necessary Z-axis proximity (lower is closer?)
; b1: offset from y-position
; b2: offset from x-position

@data:
	.db $f8 $f3 $f3
	.db $f8 $0c $f3
	.db $f8 $0c $0c
	.db $f8 $f3 $0c
	.db $f4 $00 $f3
	.db $f4 $0c $00
	.db $f4 $00 $0c
	.db $f4 $f3 $00
	.db $f2 $00 $00

;;
; ITEMID_BOOMERANG
; @addr{569d}
itemCode06:
	ld e,Item.state		; $569d
	ld a,(de)		; $569f
	rst_jumpTable			; $56a0

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call _itemLoadAttributesAndGraphics		; $56ab
.ifdef ROM_AGES
	ld a,UNCMP_GFXH_18		; $56ae
.else
	ld e,Item.subid		; $554b
	ld a,(de)		; $554d
	add $18			; $554e
.endif
	call loadWeaponGfx		; $56b0

	call itemIncState		; $56b3

.ifdef ROM_AGES
	ld l,Item.speed		; $56b6
	ld (hl),SPEED_1a0		; $56b8

	ld l,Item.counter1		; $56ba
	ld (hl),$28		; $56bc
.else
	ld bc,(SPEED_1a0<<8|$28)		; $5556
	ld l,Item.subid		; $5559
	bit 0,(hl)		; $555b
	jr z,+			; $555d

	; level-2
	ld l,Item.collisionType		; $555f
	ld (hl),$96		; $5561
	ld l,Item.oamFlagsBackup		; $5563
	ld a,$0c		; $5565
	ldi (hl),a		; $5567
	ldi (hl),a		; $5568
	ld bc,(SPEED_260<<8|$78)		; $5569
+
	ld l,Item.speed		; $556c
	ld (hl),b		; $556e
	ld l,Item.counter1		; $556f
	ld (hl),c		; $5571
.endif

	ld c,-1		; $56be
	ld a,RANG_RING_L1		; $56c0
	call cpActiveRing		; $56c2
	jr z,+			; $56c5

	ld a,RANG_RING_L2		; $56c7
	call cpActiveRing		; $56c9
	jr nz,++		; $56cc
	ld c,-2		; $56ce
+
	; One of the rang rings are equipped; damage output increased (value of 'c')
	ld l,Item.damage		; $56d0
	ld a,(hl)		; $56d2
	add c			; $56d3
	ld (hl),a		; $56d4
++
	call objectSetVisible82		; $56d5
	xor a			; $56d8
	jp itemSetAnimation		; $56d9


; State 1: boomerang moving outward
@state1:
.ifdef ROM_SEASONS
	call magicBoomerangTryToBreakTile		; $5590
.endif

	ld e,Item.var2a		; $56dc
	ld a,(de)		; $56de
	or a			; $56df
	jr nz,@returnToLink	; $56e0

	call objectCheckTileCollision_allowHoles		; $56e2
	jr nc,@noCollision	; $56e5
	call _itemCheckCanPassSolidTile		; $56e7
	jr nz,@hitWall		; $56ea

@noCollision:
	call objectCheckWithinRoomBoundary		; $56ec
	jr nc,@returnToLink	; $56ef

	; Nudge angle toward a certain value. (Is this for the magical boomerang?)
	ld e,Item.var34		; $56f1
	ld a,(de)		; $56f3
	call objectNudgeAngleTowards		; $56f4

	; Decrement counter until boomerang must return
	call itemDecCounter1		; $56f7
	jr nz,@updateSpeedAndAnimation	; $56fa

; Decide on the angle to change to, then go to the next state
@returnToLink:
	call objectGetAngleTowardLink		; $56fc
	ld c,a			; $56ff

	; If the boomerang's Y or X has gone below 0 (above $f0), go directly to link?
	ld h,d			; $5700
	ld l,Item.yh		; $5701
	ld a,$f0		; $5703
	cp (hl)			; $5705
	jr c,@@setAngle		; $5706
	ld l,Item.xh		; $5708
	cp (hl)			; $570a
	jr c,@@setAngle		; $570b

	; If the boomerang is already moving in Link's general direction, don't bother
	; changing the angle?
	ld l,Item.angle		; $570d
	ld a,c			; $570f
	sub (hl)		; $5710
	add $08			; $5711
	cp $11			; $5713
	jr c,@nextState		; $5715

@@setAngle:
	ld l,Item.angle		; $5717
	ld (hl),c		; $5719
	jr @nextState		; $571a

@hitWall:
	call _objectCreateClinkInteraction		; $571c

	; Reverse direction
	ld h,d			; $571f
	ld l,Item.angle		; $5720
	ld a,(hl)		; $5722
	xor $10			; $5723
	ld (hl),a		; $5725

@nextState:
	ld l,Item.state		; $5726
	inc (hl)		; $5728

	; Clear link to parent item
	ld l,Item.relatedObj1		; $5729
	xor a			; $572b
	ldi (hl),a		; $572c
	ld (hl),a		; $572d

	jr @updateSpeedAndAnimation		; $572e


; State 2: boomerang returning to Link
@state2:
	call objectGetAngleTowardLink		; $5730
	call objectNudgeAngleTowards		; $5733

	; Increment state if within 10 pixels of Link
	ld bc,$140a		; $5736
	call _itemCheckWithinRangeOfLink		; $5739
	call c,itemIncState		; $573c

	jr @breakTileAndUpdateSpeedAndAnimation		; $573f


; State 3: boomerang within 10 pixels of link; move directly toward him instead of nudging
; the angle.
@state3:
	call objectGetAngleTowardLink		; $5741
	ld e,Item.angle		; $5744
	ld (de),a		; $5746

	; Check if within 2 pixels of Link
	ld bc,$0402		; $5747
	call _itemCheckWithinRangeOfLink		; $574a
	jr nc,@breakTileAndUpdateSpeedAndAnimation	; $574d

	; Go to state 4, make invisible, disable collisions
	call itemIncState		; $574f
	ld l,Item.counter1		; $5752
	ld (hl),$04		; $5754
	ld l,Item.collisionType		; $5756
	ld (hl),$00		; $5758
	jp objectSetInvisible		; $575a


; Stays in this state for 4 frames before deleting itself. I guess this creates a delay
; before the boomerang can be used again?
@state4:
	call itemDecCounter1		; $575d
	jp z,itemDelete		; $5760

	ld a,(wLinkObjectIndex)		; $5763
	ld h,a			; $5766
	ld l,SpecialObject.yh		; $5767
	jp objectTakePosition		; $5769

@breakTileAndUpdateSpeedAndAnimation:
.ifdef ROM_SEASONS
	call magicBoomerangTryToBreakTile		; $5623
.endif

@updateSpeedAndAnimation:
	call objectApplySpeed		; $576c
	ld h,d			; $576f
	ld l,Item.animParameter		; $5770
	ld a,(hl)		; $5772
	or a			; $5773
	ld (hl),$00		; $5774

	; Play sound when animParameter is nonzero
	ld a,SND_BOOMERANG		; $5776
	call nz,playSound		; $5778

	jp itemAnimate		; $577b

.ifdef ROM_SEASONS
magicBoomerangTryToBreakTile:
	ld e,Item.subid		; $5638
	ld a,(de)		; $563a
	or a			; $563b
	ret z			; $563c

	; level-2
	ld a,BREAKABLETILESOURCE_07	; $563d
	jp itemTryToBreakTile		; $563f
.endif

;;
; Assumes that both objects are of the same size (checks top-left positions)
;
; @param	b	Should be double the value of c
; @param	c	Range to be within
; @param[out]	cflag	Set if within specified range of link
; @addr{577e}
_itemCheckWithinRangeOfLink:
	ld hl,w1Link.yh		; $577e
	ld e,Item.yh		; $5781
	ld a,(de)		; $5783
	sub (hl)		; $5784
	add c			; $5785
	cp b			; $5786
	ret nc			; $5787

	ld l,<w1Link.xh		; $5788
	ld e,Item.xh		; $578a
	ld a,(de)		; $578c
	sub (hl)		; $578d
	add c			; $578e
	cp b			; $578f
	ret			; $5790

.ifdef ROM_AGES
;;
; The chain on the switch hook; cycles between 3 intermediate positions
;
; ITEMID_SWITCH_HOOK_CHAIN
; @addr{5791}
itemCode0bPost:
	ld a,(w1WeaponItem.id)		; $5791
	cp ITEMID_SWITCH_HOOK			; $5794
	jp nz,itemDelete		; $5796

	ld a,(w1WeaponItem.var2f)		; $5799
	bit 4,a			; $579c
	jp nz,itemDelete		; $579e

	; Copy Z position
	ld h,d			; $57a1
	ld a,(w1WeaponItem.zh)		; $57a2
	ld l,Item.zh		; $57a5
	ld (hl),a		; $57a7

	; Cycle through the 3 positions
	ld l,Item.counter1		; $57a8
	dec (hl)		; $57aa
	jr nz,+			; $57ab
	ld (hl),$03		; $57ad
+
	ld e,(hl)		; $57af

	; Set Y position
	push de			; $57b0
	ld b,$03		; $57b1
	ld hl,w1WeaponItem.yh		; $57b3
	call @setPositionComponent		; $57b6

	; Set X position
	pop de			; $57b9
	ld b,$00		; $57ba
	ld hl,w1WeaponItem.xh		; $57bc

; @param	b	Offset to add to position
; @param	e	Index, or which position to place this at (1-3)
; @param	hl	X or Y position variable
@setPositionComponent:
	ld a,(hl)		; $57bf
	cp $f8			; $57c0
	jr c,+			; $57c2
	xor a			; $57c4
+
	; Calculate: c = ([Switch hook pos] - [Link pos]) / 4
	ld h,>w1Link		; $57c5
	sub (hl)		; $57c7
	ld c,a			; $57c8
	ld a,$00		; $57c9
	sbc a			; $57cb
	rra			; $57cc
	rr c			; $57cd
	rra			; $57cf
	rr c			; $57d0

	; Calculate: a = c * e
	xor a			; $57d2
-
	add c			; $57d3
	dec e			; $57d4
	jr nz,-			; $57d5

	; Add this to the current position (plus offset 'b')
	add (hl)		; $57d7
	add b			; $57d8
	ld h,d			; $57d9
	ldi (hl),a		; $57da
	ret			; $57db

;;
; ITEMID_SWITCH_HOOK_CHAIN
; @addr{57dc}
itemCode0b:
	ld e,Item.state		; $57dc
	ld a,(de)		; $57de
	or a			; $57df
	ret nz			; $57e0

	call _itemLoadAttributesAndGraphics		; $57e1
	call itemIncState		; $57e4
	ld l,Item.counter1		; $57e7
	ld (hl),$03		; $57e9
	xor a			; $57eb
	call itemSetAnimation		; $57ec
	jp objectSetVisible83		; $57ef

;;
; ITEMID_SWITCH_HOOK
; @addr{57f2}
itemCode0aPost:
	call _cpRelatedObject1ID		; $57f2
	ret z			; $57f5

	ld a,(wSwitchHookState)		; $57f6
	or a			; $57f9
	jp z,itemDelete		; $57fa

	jp _func_5902		; $57fd

;;
; ITEMID_SWITCH_HOOK
; @addr{5800}
itemCode0a:
	ld a,$08		; $5800
	ld (wDisableRingTransformations),a		; $5802
	ld a,$80		; $5805
	ld (wcc92),a		; $5807
	ld e,Item.state		; $580a
	ld a,(de)		; $580c
	rst_jumpTable			; $580d
	.dw @state0
	.dw @state1
	.dw @state2
	.dw _switchHookState3

@state0:
	ld a,UNCMP_GFXH_1f		; $5816
	call loadWeaponGfx		; $5818

	ld hl,@offsetsTable		; $581b
	call _applyOffsetTableHL		; $581e

	call objectSetVisible82		; $5821
	call _loadAttributesAndGraphicsAndIncState		; $5824

	; Depending on the switch hook's level, set speed (b) and # frames to extend (c)
	ldbc SPEED_200,$29		; $5827
	ld a,(wSwitchHookLevel)		; $582a
	dec a			; $582d
	jr z,+			; $582e
	ldbc SPEED_300,$26		; $5830
+
	ld h,d			; $5833
	ld l,Item.speed		; $5834
	ld (hl),b		; $5836
	ld l,Item.counter1		; $5837
	ld (hl),c		; $5839

	ld l,Item.var2f		; $583a
	ld (hl),$01		; $583c
	call itemUpdateAngle		; $583e

	; Set animation based on Item.direction
	ld a,(hl)		; $5841
	add $02			; $5842
	jp itemSetAnimation		; $5844

; Offsets to make the switch hook centered with link
@offsetsTable:
	.db $01 $00 $00 ; DIR_UP
	.db $03 $01 $00 ; DIR_RIGHT
	.db $01 $00 $00 ; DIR_DOWN
	.db $03 $ff $00 ; DIR_LEFT

; State 1: extending the hook
@state1:
	; When var2a is nonzero, a collision has occured?
	ld e,Item.var2a		; $5853
	ld a,(de)		; $5855
	or a			; $5856
	jr z,+			; $5857

	; If bit 5 is set, the switch hook can exchange with the object
	bit 5,a			; $5859
	jr nz,@goToState3	; $585b

	; Otherwise, it will be pulled back
	jr @startRetracting		; $585d
+
	; Cancel the switch hook when you take damage
	ld h,d			; $585f
	ld l,Item.var2f		; $5860
	bit 5,(hl)		; $5862
	jp nz,itemDelete		; $5864

	call itemDecCounter1		; $5867
	jr z,@startRetracting	; $586a

	call objectCheckWithinRoomBoundary		; $586c
	jr nc,@startRetracting	; $586f

	; Check if collided with a tile
	call objectCheckTileCollision_allowHoles		; $5871
	jr nc,@noCollisionWithTile	; $5874

	; There is a collision, but check for exceptions (tiles that items can pass by)
	call _itemCheckCanPassSolidTile		; $5876
	jr nz,@collisionWithTile	; $5879

@noCollisionWithTile:
	; Bit 3 of var2f remembers whether a "chain" item has been created
	ld e,Item.var2f		; $587b
	ld a,(de)		; $587d
	bit 3,a			; $587e
	jr nz,++		; $5880

	call getFreeItemSlot		; $5882
	jr nz,++		; $5885

	inc a			; $5887
	ldi (hl),a		; $5888
	ld (hl),ITEMID_SWITCH_HOOK_CHAIN		; $5889

	; Remember to not create the item again
	ld h,d			; $588b
	ld l,Item.var2f		; $588c
	set 3,(hl)		; $588e
++
	call _updateSwitchHookSound		; $5890
	jp objectApplySpeed		; $5893

@collisionWithTile:
	call _objectCreateClinkInteraction		; $5896

	; Check if the tile is breakable (oring with $80 makes it perform only a check,
	; not the breakage itself).
	ld a,$80 | BREAKABLETILESOURCE_SWITCH_HOOK		; $5899
	call itemTryToBreakTile		; $589b
	; Retract if not breakable by the switch hook
	jr nc,@startRetracting	; $589e

	; Hooked onto a tile that can be swapped with
	ld e,Item.subid		; $58a0
	ld a,$01		; $58a2
	ld (de),a		; $58a4

@goToState3:
	ld a,$03		; $58a5
	call itemSetState		; $58a7

	; Disable collisions with objects?
	ld l,Item.collisionType		; $58aa
	res 7,(hl)		; $58ac

	ld a,$ff		; $58ae
	ld (wDisableLinkCollisionsAndMenu),a		; $58b0

	ld a,$01		; $58b3
	ld (wSwitchHookState),a		; $58b5

	jp resetLinkInvincibility		; $58b8

@label_07_185:
	xor a			; $58bb
	ld (wDisableLinkCollisionsAndMenu),a		; $58bc
	ld (wSwitchHookState),a		; $58bf

@startRetracting:
	ld h,d			; $58c2

	; Disable collisions with objects?
	ld l,Item.collisionType		; $58c3
	res 7,(hl)		; $58c5

	ld a,$02		; $58c7
	jp itemSetState		; $58c9

; State 2: retracting the hook
@state2:
	ld e,Item.state2		; $58cc
	ld a,(de)		; $58ce
	or a			; $58cf
	jr nz,@fullyRetracted		; $58d0

	; The counter is just for keeping track of the sound?
	call itemDecCounter1		; $58d2
	call _updateSwitchHookSound		; $58d5

	; Update angle based on position of link
	call objectGetAngleTowardLink		; $58d8
	ld e,Item.angle		; $58db
	ld (de),a		; $58dd

	call objectApplySpeed		; $58de

	; Check if within 8 pixels of link
	ld bc,$1008		; $58e1
	call _itemCheckWithinRangeOfLink		; $58e4
	ret nc			; $58e7

	; Item has reached Link

	call itemIncState2		; $58e8

	; Set Item.counter1 to $03
	inc l			; $58eb
	ld (hl),$03		; $58ec

	ld l,Item.var2f		; $58ee
	set 4,(hl)		; $58f0
	jp objectSetInvisible		; $58f2

@fullyRetracted:
	ld hl,w1Link.yh		; $58f5
	call objectTakePosition		; $58f8
	call itemDecCounter1		; $58fb
	ret nz			; $58fe
	jp itemDelete		; $58ff

;;
; Swap with an object?
; @addr{5902}
_func_5902:
	call _checkRelatedObject2States		; $5902
	jr nc,++		; $5905
	jr z,++			; $5907

	ld a,Object.state2		; $5909
	call objectGetRelatedObject2Var		; $590b
	ld (hl),$03		; $590e
++
	xor a			; $5910
	ld (wDisableLinkCollisionsAndMenu),a		; $5911
	ld (wSwitchHookState),a		; $5914
	jp itemDelete		; $5917

; State 3: grabbed something switchable
; Uses w1ReservedItemE as ITEMID_SWITCH_HOOK_HELPER to hold the positions for link and the
; object temporarily.
_switchHookState3:
	ld e,Item.state2		; $591a
	ld a,(de)		; $591c
	rst_jumpTable			; $591d
	.dw @s3subState0
	.dw @s3subState1
	.dw @s3subState2
	.dw @s3subState3

; Substate 0: grabbed an object/tile, doing the cling animation for several frames
@s3subState0:
	ld h,d			; $5926

	; Check if deletion was requested?
	ld l,Item.var2f		; $5927
	bit 5,(hl)		; $5929
	jp nz,_func_5902		; $592b

	; Wait until the animation writes bit 7 to animParameter
	ld l,Item.animParameter		; $592e
	bit 7,(hl)		; $5930
	jp z,itemAnimate		; $5932

	; At this point the animation is finished, now link and the hooked object/tile
	; will rise and swap

	call _checkRelatedObject2States		; $5935
	jr nc,itemCode0a@label_07_185	; $5938
	; Jump if an object collision, not a tile collision
	jr nz,@@objectCollision		; $593a

	; Tile collision

	; Break the tile underneath whatever was latched on to
	ld a,BREAKABLETILESOURCE_SWITCH_HOOK		; $593c
	call itemTryToBreakTile		; $593e
	jp nc,itemCode0a@label_07_185		; $5941

	ld h,d			; $5944
	ld l,Item.var03		; $5945
	ldh a,(<hFF8E)	; $5947
	ld (hl),a		; $5949

	ld l,Item.var3c		; $594a
	ldh a,(<hFF93)	; $594c
	ldi (hl),a		; $594e
	ldh a,(<hFF92)	; $594f
	ld (hl),a		; $5951

	; Imitate the tile that was grabbed
	call _itemMimicBgTile		; $5952

	ld h,d			; $5955
	ld l,Item.var3c		; $5956
	ld c,(hl)		; $5958
	call objectSetShortPosition		; $5959
	call objectSetVisiblec2		; $595c
	jr +++			; $595f

@@objectCollision:
	ld a,(w1ReservedInteraction1.id)		; $5961
	cp INTERACID_PUSHBLOCK			; $5964
	jr z,++			; $5966

	; Get the object being switched with's yx in bc
	ld a,Object.yh		; $5968
	call objectGetRelatedObject2Var		; $596a
	ldi a,(hl)		; $596d
	inc l			; $596e
	ld c,(hl)		; $596f
	ld b,a			; $5970

	callab bank5.checkPositionSurroundedByWalls		; $5971
	rl b			; $5979
	jr c,++			; $597b

	ld a,Object.yh		; $597d
	call objectGetRelatedObject2Var		; $597f
	call objectTakePosition		; $5982
	call objectSetInvisible		; $5985
+++
	ld a,$02		; $5988
	ld (wSwitchHookState),a		; $598a
	ld a,SND_SWITCH2		; $598d
	call playSound		; $598f

	call itemIncState2		; $5992

	ld l,Item.zh		; $5995
	ld (hl),$00		; $5997
	ld l,Item.var2f		; $5999
	set 1,(hl)		; $599b

	; Use w1ReservedItemE to keep copies of xyz positions
	ld hl,w1ReservedItemE		; $599d
	ld a,$01		; $59a0
	ldi (hl),a		; $59a2
	ld (hl),ITEMID_SWITCH_HOOK_HELPER		; $59a3

	; Zero Item.state and Item.state2
	ld l,Item.state		; $59a5
	xor a			; $59a7
	ldi (hl),a		; $59a8
	ldi (hl),a		; $59a9

	call objectCopyPosition		; $59aa
	jp resetLinkInvincibility		; $59ad
++
	ld a,Object.state2		; $59b0
	call objectGetRelatedObject2Var		; $59b2
	ld (hl),$03		; $59b5
	jp itemCode0a@label_07_185		; $59b7


; Substate 1: Link and the object are rising for several frames
@s3subState1:
	ld h,d			; $59ba
	ld l,Item.zh		; $59bb
	dec (hl)		; $59bd
	ld a,(hl)		; $59be
	cp $f1			; $59bf
	call c,itemIncState2		; $59c1
	jr @updateOtherPositions		; $59c4

; Substate 2: Link and the object swap positions
@s3subState2:
	push de			; $59c6

	; Swap Link and Hook's xyz (at least, the copies in w1ReservedItemE)
	ld hl,w1ReservedItemE.var36		; $59c7
	ld de,w1ReservedItemE.var30		; $59ca
	ld b,$06		; $59cd
--
	ld a,(de)		; $59cf
	ld c,(hl)		; $59d0
	ldi (hl),a		; $59d1
	ld a,c			; $59d2
	ld (de),a		; $59d3
	inc e			; $59d4
	dec b			; $59d5
	jr nz,--		; $59d6

	pop de			; $59d8
	ld e,Item.subid		; $59d9
	ld a,(de)		; $59db
	or a			; $59dc
	; Jump if hooked an object, and not a tile
	jr z,@doneCentering	; $59dd

	; Everything from here to @doneCentering involves centering the hooked tile at
	; link's position.

	ld a,(w1Link.direction)		; $59df
	; a *= 3
	ld l,a			; $59e2
	add a			; $59e3
	add l			; $59e4

	ld hl,itemCode0a@offsetsTable		; $59e5
	rst_addAToHl			; $59e8

	push de			; $59e9
	ld de,w1ReservedItemE.var31		; $59ea
	ld a,(de)		; $59ed
	add (hl)		; $59ee
	ld (de),a		; $59ef

	inc hl			; $59f0
	ld e,<w1ReservedItemE.var33		; $59f1
	ld a,(de)		; $59f3
	add (hl)		; $59f4
	ld (de),a		; $59f5

	ld e,<w1ReservedItemE.var31		; $59f6
	call getShortPositionFromDE		; $59f8
	pop de			; $59fb
	ld l,a			; $59fc
	call _checkCanPlaceDiamondOnTile		; $59fd
	jr z,++			; $5a00

	ld e,l			; $5a02
	ld a,(w1Link.direction)		; $5a03
	ld bc,@data		; $5a06
	call addAToBc		; $5a09
	ld a,(bc)		; $5a0c
	rst_addAToHl			; $5a0d
	call _checkCanPlaceDiamondOnTile		; $5a0e
	jr z,++			; $5a11
	ld l,e			; $5a13
++
	ld c,l			; $5a14
	ld hl,w1ReservedItemE.var31		; $5a15
	call setShortPosition_paramC		; $5a18

@doneCentering:
	ld e,Item.y		; $5a1b
	ld hl,w1ReservedItemE.var30		; $5a1d
	ld b,$04		; $5a20
	call copyMemory		; $5a22

	; Reverse link's direction
	ld hl,w1Link.direction		; $5a25
	ld a,(hl)		; $5a28
	xor $02			; $5a29
	ld (hl),a		; $5a2b

	call itemIncState2		; $5a2c
	call _checkRelatedObject2States		; $5a2f
	jr nc,+			; $5a32
	jr z,+			; $5a34
	ld (hl),$02		; $5a36
+
	jr @updateOtherPositions			; $5a38

@data:
	.db $10 $ff $f0 $01

; Update the positions (mainly z positions) for Link and the object being hooked.
@updateOtherPositions:
	; Update other object position if hooked to an enemy
	call _checkRelatedObject2States		; $5a3e
	call nz,objectCopyPosition		; $5a41

	; Update the Z position that w1ReservedItemE is keeping track of
	push de			; $5a44
	ld e,Item.zh		; $5a45
	ld a,(de)		; $5a47
	ld de,w1ReservedItemE.var3b		; $5a48
	ld (de),a		; $5a4b

	; Update link's position
	ld hl,w1Link.y		; $5a4c
	ld e,<w1ReservedItemE.var36		; $5a4f
	ld b,$06		; $5a51
	call copyMemoryReverse		; $5a53
	pop de			; $5a56
	ret			; $5a57

; Substate 3: Link and the other object are moving back to the ground
@s3subState3:
	ld h,d			; $5a58

	; Lower 1 pixel
	ld l,Item.zh		; $5a59
	inc (hl)		; $5a5b
	call @updateOtherPositions		; $5a5c

	; Return if link and the item haven't reached the ground yet
	ld e,Item.zh		; $5a5f
	ld a,(de)		; $5a61
	or a			; $5a62
	ret nz			; $5a63

	call _checkRelatedObject2States		; $5a64
	jr nz,@reenableEnemy		; $5a67

	; For tile collisions, check whether to make the interaction which shows it
	; breaking, or whether to keep the switch hook diamond there

	call objectGetTileCollisions		; $5a69
	call _checkCanPlaceDiamondOnTile		; $5a6c
	jr nz,+			; $5a6f

	; If the current block is the switch diamond, do NOT break it
	ld c,l			; $5a71
	ld e,Item.var3d		; $5a72
	ld a,(de)		; $5a74
	cp TILEINDEX_SWITCH_DIAMOND			; $5a75
	jr nz,+			; $5a77

	call setTile		; $5a79
	jr @delete			; $5a7c
+
	; Create the bush/pot/etc breakage animation (based on var03)
	callab bank6.itemMakeInteractionForBreakableTile		; $5a7e
	jr @delete		; $5a86

@reenableEnemy:
	ld (hl),$03		; $5a88
@delete:
	xor a			; $5a8a
	ld (wSwitchHookState),a		; $5a8b
	ld (wDisableLinkCollisionsAndMenu),a		; $5a8e
	jp itemDelete		; $5a91

;;
; This function is used for the switch hook.
;
; @param[out]	hl	Related object 2's state2 variable
; @param[out]	zflag	Set if latched onto a tile, not an object
; @param[out]	cflag	Unset if the related object is on state 3, substate 3?
; @addr{5a94}
_checkRelatedObject2States:
	; Jump if latched onto a tile, not an object
	ld e,Item.subid		; $5a94
	ld a,(de)		; $5a96
	dec a			; $5a97
	jr z,++			; $5a98

	; It might be assuming that there aren't any states above $03, so the carry flag
	; will always be set when returning here?
	ld a,Object.state		; $5a9a
	call objectGetRelatedObject2Var		; $5a9c
	ldi a,(hl)		; $5a9f
	cp $03			; $5aa0
	ret nz			; $5aa2

	ld a,(hl)		; $5aa3
	cp $03			; $5aa4
	ret nc			; $5aa6

	or d			; $5aa7
++
	scf			; $5aa8
	ret			; $5aa9

;;
; Plays the switch hook sound every 4 frames.
; @addr{5aaa}
_updateSwitchHookSound:
	ld e,Item.counter1		; $5aaa
	ld a,(de)		; $5aac
	and $03			; $5aad
	ret z			; $5aaf

	ld a,SND_SWITCH_HOOK		; $5ab0
	jp playSound		; $5ab2

;;
; @param l Position to check
; @param[out] zflag Set if the tile at l has a collision value of 0 (or is the somaria
; block?)
; @addr{5ab5}
_checkCanPlaceDiamondOnTile:
	ld h,>wRoomCollisions		; $5ab5
	ld a,(hl)		; $5ab7
	or a			; $5ab8
	ret z			; $5ab9
	ld h,>wRoomLayout		; $5aba
	ld a,(hl)		; $5abc
	cp TILEINDEX_SOMARIA_BLOCK			; $5abd
	ret			; $5abf


;;
; ITEMID_SWITCH_HOOK_HELPER
; Used with the switch hook in w1ReservedItemE to store position values.
; @addr{5ac0}
itemCode09:
	ld h,d			; $5ac0
	ld l,Item.var2f		; $5ac1
	bit 5,(hl)		; $5ac3
	jr nz,@state2		; $5ac5

	ld e,Item.state		; $5ac7
	ld a,(de)		; $5ac9
	rst_jumpTable			; $5aca
	.dw @state0
	.dw @state1
	.dw @state2

; Initialization (initial copying of positions)
@state0:
	call itemIncState		; $5ad1
	ld h,d			; $5ad4

	; Copy from Item.y to Item.var30
	ld l,Item.y		; $5ad5
	ld e,Item.var30		; $5ad7
	ld b,$06		; $5ad9
	call copyMemory		; $5adb

	; Copy from w1Link.y to Item.var36
	ld hl,w1Link.y		; $5ade
	ld b,$06		; $5ae1
	call copyMemory		; $5ae3

	; Set the focused object to this
	jp setCameraFocusedObject		; $5ae6

; State 1: do nothing until the switch hook is no longer in use, then delete self
@state1:
	ld a,(w1WeaponItem.id)		; $5ae9
	cp ITEMID_SWITCH_HOOK			; $5aec
	ret z			; $5aee

; State 2: Restore camera to focusing on Link and delete self
@state2:
	call setCameraFocusedObjectToLink		; $5aef
	jp itemDelete		; $5af2

;;
; Unused?
; @addr{5af5}
_func_5af5:
	ld hl,w1ReservedItemE		; $5af5
	bit 0,(hl)		; $5af8
	ret z			; $5afa
	ld l,Item.var2f		; $5afb
	set 5,(hl)		; $5afd
	ret			; $5aff
.endif

;;
; ITEMID_RICKY_TORNADO
; @addr{5b00}
itemCode2a:
	ld e,Item.state		; $5b00
	ld a,(de)		; $5b02
	rst_jumpTable			; $5b03

	.dw @state0
	.dw @state1


; State 0: initialization
@state0:
	call itemIncState		; $5b08
	ld l,Item.speed		; $5b0b
	ld (hl),SPEED_300		; $5b0d

	ld a,(w1Companion.direction)		; $5b0f
	ld c,a			; $5b12
	swap a			; $5b13
	rrca			; $5b15
	ld l,Item.angle		; $5b16
	ld (hl),a		; $5b18

	; Get offset from companion position to spawn at in 'bc'
	ld a,c			; $5b19
	ld hl,@offsets		; $5b1a
	rst_addDoubleIndex			; $5b1d
	ldi a,(hl)		; $5b1e
	ld c,(hl)		; $5b1f
	ld b,a			; $5b20

	; Copy companion's position
	ld hl,w1Companion.yh		; $5b21
	call objectTakePositionWithOffset		; $5b24

	; Make Z position 2 higher than companion
	sub $02			; $5b27
	ld (de),a		; $5b29

	call _itemLoadAttributesAndGraphics		; $5b2a
	xor a			; $5b2d
	call itemSetAnimation		; $5b2e
	jp objectSetVisiblec1		; $5b31

@offsets:
	.db $f0 $00 ; DIR_UP
	.db $00 $0c ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f4 ; DIR_LEFT


; State 1: flying away until it hits something
@state1:
	call objectApplySpeed		; $5b3c

	ld a,BREAKABLETILESOURCE_SWORD_L1		; $5b3f
	call itemTryToBreakTile		; $5b41

	call objectGetTileCollisions		; $5b44
	and $0f			; $5b47
	cp $0f			; $5b49
	jp z,itemDelete		; $5b4b

	jp itemAnimate		; $5b4e

.ifdef ROM_AGES
;;
; ITEMID_SHOOTER
; ITEMID_29
;
; @addr{5b51}
itemCode0f:
itemCode29:
	ld e,Item.state		; $5b51
	ld a,(de)		; $5b53
	rst_jumpTable			; $5b54
	.dw @state0
	.dw @state1

@state0:
	ld a,UNCMP_GFXH_1d		; $5b59
	call loadWeaponGfx		; $5b5b
	call _loadAttributesAndGraphicsAndIncState		; $5b5e
	ld e,Item.var30		; $5b61
	ld a,$ff		; $5b63
	ld (de),a		; $5b65
	jp objectSetVisible81		; $5b66

@state1:
	ret			; $5b69


;;
; ITEMID_SHOOTER
; @addr{5b6a}
itemCode0fPost:
	call _cpRelatedObject1ID		; $5b6a
	jp nz,itemDelete		; $5b6d

	ld hl,@data		; $5b70
	call _itemInitializeFromLinkPosition		; $5b73

	; Copy link Z position
	ld h,d			; $5b76
	ld a,(w1Link.zh)		; $5b77
	ld l,Item.zh		; $5b7a
	ld (hl),a		; $5b7c

	; Check if angle has changed
	ld l,Item.var30		; $5b7d
	ld a,(w1ParentItem2.angle)		; $5b7f
	cp (hl)			; $5b82
	ld (hl),a		; $5b83
	ret z			; $5b84
	jp itemSetAnimation		; $5b85


; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets relative to Link
@data:
	.db $00 $00 $00 $00
.else
;;
; ITEMID_MAGNET_GLOVES
; ITEMID_29
itemCode29:
	ld e,Item.state		; $56a6
	ld a,(de)		; $56a8
	rst_jumpTable			; $56a9
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $56b0
	ld (de),a		; $56b2

	ld h,d			; $56b3
	ld l,Item.speed		; $56b4
	ld (hl),SPEED_40		; $56b6
	ld l,Item.yh		; $56b8
	ld a,(hl)		; $56ba
	ld b,a			; $56bb
	ld l,Item.xh		; $56bc
	ld a,(hl)		; $56be
	ld l,Item.var31		; $56bf
	ldd (hl),a		; $56c1
	ld (hl),b		; $56c2
	call _itemLoadAttributesAndGraphics		; $56c3
	xor a			; $56c6
	call itemSetAnimation		; $56c7
	call objectSetVisiblec3		; $56ca

	ld a,(wActiveGroup)		; $56cd
	cp >ROOM_SEASONS_494		; $56d0
	jr nz,@state1	; $56d2
	ld a,(wActiveRoom)		; $56d4
	cp <ROOM_SEASONS_494		; $56d7
	jr nz,@state1	; $56d9
	ld e,Item.var03		; $56db
	ld a,$01		; $56dd
	ld (de),a		; $56df

@state1:
	call @seasonsFunc_07_56ef		; $56e0
	call @seasonsFunc_07_590f		; $56e3
	ld e,Item.collisionType		; $56e6
	ld a,(de)		; $56e8
	bit 7,a			; $56e9
	ret nz			; $56eb
	jp @seasonsFunc_07_5a06		; $56ec

@seasonsFunc_07_56ef:
	ld h,d			; $56ef
	ld l,Item.var03		; $56f0
	ld a,(hl)		; $56f2
	or a			; $56f3
	jr nz,+			; $56f4
	ld l,Item.collisionType		; $56f6
	res 7,(hl)		; $56f8
+
	call @seasonsFunc_07_5a28		; $56fa
	call @seasonsFunc_07_5a5e		; $56fd
	ld a,(wMagnetGloveState)		; $5700
	or a			; $5703
	jp z,@seasonsFunc_07_57bd		; $5704
	ld b,$0c		; $5707
	call objectCheckCenteredWithLink		; $5709
	jp nc,@seasonsFunc_07_57bd		; $570c
	call objectGetAngleTowardLink		; $570f
	add $04			; $5712
	add a			; $5714
	swap a			; $5715
	and $03			; $5717
	xor $02			; $5719
	ld b,a			; $571b
	ld a,(w1Link.direction)		; $571c
	cp b			; $571f
	jp nz,@seasonsFunc_07_57bd		; $5720
	ld e,$10		; $5723
	ld a,$28		; $5725
	ld (de),a		; $5727
	ld e,$32		; $5728
	ld a,(de)		; $572a
	or a			; $572b
	jr z,+			; $572c
	inc e			; $572e
	ld a,(de)		; $572f
	cp $10			; $5730
	jp nc,@seasonsFunc_07_57bd		; $5732
	inc e			; $5735
	ld a,(de)		; $5736
	cp $10			; $5737
	jp nc,@seasonsFunc_07_57bd		; $5739
	ld e,$32		; $573c
	xor a			; $573e
	ld (de),a		; $573f
+
	ld a,(wMagnetGloveState)		; $5740
	bit 1,a			; $5743
	jr nz,@seasonsFunc_07_578b	; $5745
	ld a,($d008)		; $5747
	ld hl,@seasonsTable_07_587b		; $574a
	rst_addDoubleIndex			; $574d
	ld a,($d00b)		; $574e
	add (hl)		; $5751
	ldh (<hFF8D),a	; $5752
	inc hl			; $5754
	ld a,($d00d)		; $5755
	add (hl)		; $5758
	ldh (<hFF8C),a	; $5759
	push bc			; $575b
	call @seasonsFunc_07_5842		; $575c
	pop bc			; $575f
	jp c,@seasonsFunc_07_5806		; $5760
	bit 0,b			; $5763
	jr nz,@seasonsFunc_07_5779	; $5765
	call @seasonsFunc_07_588d		; $5767
	ld e,$04		; $576a
	ld a,(de)		; $576c
	cp $01			; $576d
	ret nz			; $576f
	call @seasonsFunc_07_5972		; $5770
	call @seasonsFunc_07_594e		; $5773
	jp @seasonsFunc_07_5883		; $5776

@seasonsFunc_07_5779:
	call @seasonsFunc_07_5883		; $5779
	ld e,$04		; $577c
	ld a,(de)		; $577e
	cp $01			; $577f
	ret nz			; $5781
	call @seasonsFunc_07_5979		; $5782
	call @seasonsFunc_07_5966		; $5785
	jp @seasonsFunc_07_588d		; $5788

@seasonsFunc_07_578b:
	ld a,($d00b)		; $578b
	ldh (<hFF8D),a	; $578e
	ld a,($d00d)		; $5790
	ldh (<hFF8C),a	; $5793
	bit 0,b			; $5795
	jr nz,@seasonsFunc_07_57ab	; $5797
	call @seasonsFunc_07_588d		; $5799
	ld e,$04		; $579c
	ld a,(de)		; $579e
	cp $01			; $579f
	ret nz			; $57a1
	call @seasonsFunc_07_5972		; $57a2
	call @seasonsFunc_07_594e		; $57a5
	jp @seasonsFunc_07_5897		; $57a8

@seasonsFunc_07_57ab:
	call @seasonsFunc_07_5883		; $57ab
	ld e,$04		; $57ae
	ld a,(de)		; $57b0
	cp $01			; $57b1
	ret nz			; $57b3
	call @seasonsFunc_07_5979		; $57b4
	call @seasonsFunc_07_5966		; $57b7
	jp @seasonsFunc_07_58a1		; $57ba

@seasonsFunc_07_57bd:
	ld e,$33		; $57bd
	ld a,(de)		; $57bf
	or a			; $57c0
	jr z,+			; $57c1
	ld e,$32		; $57c3
	ld a,$01		; $57c5
	ld (de),a		; $57c7
	call @seasonsFunc_07_5980		; $57c8
	call @seasonsFunc_07_5980		; $57cb
	call @seasonsFunc_07_594e		; $57ce
	ld e,$09		; $57d1
	ld a,(de)		; $57d3
	call @seasonsFunc_07_58c3		; $57d4
+
	ld e,$34		; $57d7
	ld a,(de)		; $57d9
	or a			; $57da
	jr z,+			; $57db
	ld e,$32		; $57dd
	ld a,$01		; $57df
	ld (de),a		; $57e1
	call @seasonsFunc_07_598f		; $57e2
	call @seasonsFunc_07_598f		; $57e5
	call @seasonsFunc_07_5966		; $57e8
	ld e,$09		; $57eb
	ld a,(de)		; $57ed
	call @seasonsFunc_07_58c3		; $57ee
+
	call objectCheckIsOnHazard		; $57f1
	jp c,@seasonsFunc_07_57f8		; $57f4
	ret			; $57f7

@seasonsFunc_07_57f8:
	ldh (<hFF8B),a	; $57f8
	call @seasonsFunc_07_5a1f		; $57fa
	ldh a,(<hFF8B)	; $57fd
	dec a			; $57ff
	jp z,objectReplaceWithSplash		; $5800
	jp objectReplaceWithFallingDownHoleInteraction		; $5803

@seasonsFunc_07_5806:
	xor a			; $5806
	ld e,$33		; $5807
	ld (de),a		; $5809
	ld e,$34		; $580a
	ld (de),a		; $580c
	ld a,(wLinkAngle)		; $580d
	cp $ff			; $5810
	ret z			; $5812
	ld a,(wGameKeysPressed)		; $5813
	ld b,a			; $5816
	bit 6,b			; $5817
	jr z,+			; $5819
	ld a,$00		; $581b
	call @seasonsFunc_07_583c		; $581d
	jr ++			; $5820

+
	bit 7,b			; $5822
	jr z,++			; $5824
	ld a,$10		; $5826
	call @seasonsFunc_07_583c		; $5828
++
	ld a,(wGameKeysPressed)		; $582b
	ld b,a			; $582e
	bit 4,b			; $582f
	jr z,+			; $5831
	ld a,$08		; $5833
	jr @seasonsFunc_07_583c		; $5835
+
	bit 5,b			; $5837
	ld a,$18		; $5839
	ret z			; $583b

@seasonsFunc_07_583c:
	ld e,$09		; $583c
	ld (de),a		; $583e
	jp @seasonsFunc_07_58c3		; $583f

@seasonsFunc_07_5842:
	ldh a,(<hFF8D)	; $5842
	ld b,a			; $5844
	ldh a,(<hFF8C)	; $5845
	ld c,a			; $5847
	jp objectCheckContainsPoint		; $5848

@state2:
	ld h,d			; $584b
	ld l,$24		; $584c
	set 7,(hl)		; $584e
	ld l,$08		; $5850
	ldi a,(hl)		; $5852
	ld (hl),a		; $5853
	call objectApplySpeed		; $5854
	ld c,$20		; $5857
	call objectUpdateSpeedZ_paramC		; $5859
	ret nz			; $585c
	ld a,$77		; $585d
	call playSound		; $585f
	ld h,d			; $5862
	ld l,$06		; $5863
	dec (hl)		; $5865
	jr z,+			; $5866
	ld bc,$ff20		; $5868
	ld l,$14		; $586b
	ld (hl),c		; $586d
	inc l			; $586e
	ld (hl),b		; $586f
	ld l,$10		; $5870
	ld (hl),$14		; $5872
	ret			; $5874
+
	ld a,$01		; $5875
	ld e,$04		; $5877
	ld (de),a		; $5879
	ret			; $587a

@seasonsTable_07_587b:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

@seasonsFunc_07_5883:
	ld b,$00		; $5883
	ld c,$10		; $5885
	call @seasonsFunc_07_58ab		; $5887
	ret z			; $588a
	jr @seasonsFunc_07_58c3		; $588b

@seasonsFunc_07_588d:
	ld b,$18		; $588d
	ld c,$08		; $588f
	call @seasonsFunc_07_58bb		; $5891
	ret z			; $5894
	jr @seasonsFunc_07_58c3		; $5895

@seasonsFunc_07_5897:
	ld b,$10		; $5897
	ld c,$00		; $5899
	call @seasonsFunc_07_58ab		; $589b
	ret z			; $589e
	jr @seasonsFunc_07_58c3		; $589f

@seasonsFunc_07_58a1:
	ld b,$08		; $58a1
	ld c,$18		; $58a3
	call @seasonsFunc_07_58bb		; $58a5
	ret z			; $58a8
	jr @seasonsFunc_07_58c3		; $58a9

@seasonsFunc_07_58ab:
	ldh a,(<hFF8D)	; $58ab
	ld l,$0b		; $58ad
	ld e,$33		; $58af
-
	ld h,d			; $58b1
	cp (hl)			; $58b2
	ld a,b			; $58b3
	jr c,+			; $58b4
	ld a,c			; $58b6
+
	ld l,$09		; $58b7
	ld (hl),a		; $58b9
	ret			; $58ba

@seasonsFunc_07_58bb:
	ldh a,(<hFF8C)	; $58bb
	ld l,$0d		; $58bd
	ld e,$34		; $58bf
	jr -			; $58c1

@seasonsFunc_07_58c3:
	srl a			; $58c3
	ld hl,@seasonsTable_07_58ff		; $58c5
	rst_addAToHl			; $58c8
	call @seasonsFunc_07_58ed		; $58c9
	jr c,+			; $58cc
	call @seasonsFunc_07_58ed		; $58ce
	jr c,+			; $58d1
	ld h,d			; $58d3
	ld l,$24		; $58d4
	set 7,(hl)		; $58d6
	call objectApplySpeed		; $58d8
	jr @seasonsFunc_07_5930		; $58db
+
	call @seasonsFunc_07_59a9		; $58dd
	ld e,$09		; $58e0
	ld a,(de)		; $58e2
	bit 3,a			; $58e3
	ld e,$33		; $58e5
	jr z,+			; $58e7
	inc e			; $58e9
+
	xor a			; $58ea
	ld (de),a		; $58eb
	ret			; $58ec

@seasonsFunc_07_58ed:
	ld e,$0b		; $58ed
	ld a,(de)		; $58ef
	add (hl)		; $58f0
	inc hl			; $58f1
	ld b,a			; $58f2
	ld e,$0d		; $58f3
	ld a,(de)		; $58f5
	add (hl)		; $58f6
	inc hl			; $58f7
	ld c,a			; $58f8
	push hl			; $58f9
	call checkTileCollisionAt_allowHoles		; $58fa
	pop hl			; $58fd
	ret			; $58fe

@seasonsTable_07_58ff:
	.db $f8 $fc
	.db $f8 $04
	.db $fc $08
	.db $04 $08
	.db $08 $fc
	.db $08 $04
	.db $fc $f8
	.db $04 $f8

@seasonsFunc_07_590f:
	call objectGetTileAtPosition		; $590f
	ld hl,hazardCollisionTable		; $5912
	call lookupCollisionTable		; $5915
	ret nc			; $5918
	call objectGetPosition		; $5919
	ld a,$05		; $591c
	add b			; $591e
	ld b,a			; $591f
	call checkTileCollisionAt_allowHoles		; $5920
	ret nc			; $5923
	ld b,$14		; $5924
	call @seasonsFunc_07_5961		; $5926
	ld e,$09		; $5929
	xor a			; $592b
	ld (de),a		; $592c
	jp objectApplySpeed		; $592d

@seasonsFunc_07_5930:
	ld bc,$a8e8		; $5930
	ld e,$08		; $5933
	ld h,d			; $5935
	ld l,$0b		; $5936
	ld a,e			; $5938
	cp (hl)			; $5939
	jr c,+			; $593a
	ld (hl),a		; $593c
+
	ld a,b			; $593d
	cp (hl)			; $593e
	jr nc,+			; $593f
	ld (hl),a		; $5941
+
	ld l,$0d		; $5942
	ld a,e			; $5944
	cp (hl)			; $5945
	jr c,+			; $5946
	ld (hl),a		; $5948
+
	ld a,c			; $5949
	cp (hl)			; $594a
	ret nc			; $594b
	ld (hl),a		; $594c
	ret			; $594d

@seasonsFunc_07_594e:
	ld e,$33		; $594e
--
	ld a,(de)		; $5950
	cp $40			; $5951
	ld b,$78		; $5953
	jr nc,@seasonsFunc_07_5961	; $5955
	and $38			; $5957
	swap a			; $5959
	rlca			; $595b
	ld hl,@seasonsTable_596a		; $595c
	rst_addAToHl			; $595f
	ld b,(hl)		; $5960

@seasonsFunc_07_5961:
	ld a,b			; $5961
	ld e,$10		; $5962
	ld (de),a		; $5964
	ret			; $5965

@seasonsFunc_07_5966:
	ld e,$34		; $5966
	jr --			; $5968

@seasonsTable_596a:
	.db $0a $14
	.db $28 $32
	.db $3c $46
	.db $50 $50

@seasonsFunc_07_5972:
	ld h,d			; $5972
	ld l,$33		; $5973
	inc (hl)		; $5975
	ret nz			; $5976
	dec (hl)		; $5977
	ret			; $5978

@seasonsFunc_07_5979:
	ld h,d			; $5979
	ld l,$34		; $597a
	inc (hl)		; $597c
	ret nz			; $597d
	dec (hl)		; $597e
	ret			; $597f

@seasonsFunc_07_5980:
	ld l,$33		; $5980
--
	ld h,d			; $5982
	ld a,(hl)		; $5983
	cp $40			; $5984
	jr c,+			; $5986
	ld a,$40		; $5988
+
	or a			; $598a
	ret z			; $598b
	dec a			; $598c
	ld (hl),a		; $598d
	ret			; $598e

@seasonsFunc_07_598f:
	ld l,$34		; $598f
	jr --			; $5991

@seasonsFunc_07_5993:
	ld e,$0b		; $5993
	ld a,(de)		; $5995
	add (hl)		; $5996
	inc hl			; $5997
	ld b,a			; $5998
	ld e,$0d		; $5999
	ld a,(de)		; $599b
	add (hl)		; $599c
	inc hl			; $599d
	ld c,a			; $599e
	push hl			; $599f
	call getTileAtPosition		; $59a0
	pop hl			; $59a3
	sub $b0			; $59a4
	cp $04			; $59a6
	ret			; $59a8

@seasonsFunc_07_59a9:
	call @seasonsFunc_07_59fb		; $59a9
	add a			; $59ac
	ld hl,@seasonsTable_07_58ff		; $59ad
	rst_addDoubleIndex			; $59b0
	call @seasonsFunc_07_5993		; $59b1
	ret nc			; $59b4
	call @seasonsFunc_07_5993		; $59b5
	ret nc			; $59b8
	add $02			; $59b9
	and $03			; $59bb
	swap a			; $59bd
	rrca			; $59bf
	ld b,a			; $59c0
	ld e,$09		; $59c1
	ld a,(de)		; $59c3
	cp b			; $59c4
	ret nz			; $59c5
	sra a			; $59c6
	ld hl,@seasonsTable_07_59eb		; $59c8
	rst_addAToHl			; $59cb
	ldi a,(hl)		; $59cc
	ld e,$08		; $59cd
	ld (de),a		; $59cf
	ldi a,(hl)		; $59d0
	ld e,$10		; $59d1
	ld (de),a		; $59d3
	ldi a,(hl)		; $59d4
	ld e,$14		; $59d5
	ld (de),a		; $59d7
	inc e			; $59d8
	ld a,(hl)		; $59d9
	ld (de),a		; $59da
	xor a			; $59db
	ld h,d			; $59dc
	ld l,$32		; $59dd
	ldi (hl),a		; $59df
	ldi (hl),a		; $59e0
	ld (hl),a		; $59e1
	ld l,$06		; $59e2
	ld (hl),$02		; $59e4
	ld l,$04		; $59e6
	ld (hl),$02		; $59e8
	ret			; $59ea

@seasonsTable_07_59eb:
	.db $00 $28
	.db $40 $fe
	.db $08 $28
	.db $40 $fe
	.db $10 $28
	.db $40 $fe
	.db $18 $28
	.db $40 $fe

@seasonsFunc_07_59fb:
	ld e,$09		; $59fb
	ld a,(de)		; $59fd
	add $04			; $59fe
	add a			; $5a00
	swap a			; $5a01
	and $03			; $5a03
	ret			; $5a05

@seasonsFunc_07_5a06:
	ld hl,$d080		; $5a06
-
	ld a,(hl)		; $5a09
	or a			; $5a0a
	call nz,@seasonsFunc_07_5a15		; $5a0b
	inc h			; $5a0e
	ld a,h			; $5a0f
	cp $e0			; $5a10
	jr c,-			; $5a12
	ret			; $5a14

@seasonsFunc_07_5a15:
	push hl			; $5a15
	ld l,$8f		; $5a16
	bit 7,(hl)		; $5a18
	call z,preventObjectHFromPassingObjectD		; $5a1a
	pop hl			; $5a1d
	ret			; $5a1e

@seasonsFunc_07_5a1f:
	ld e,$30		; $5a1f
	ld a,(de)		; $5a21
	ld b,a			; $5a22
	inc e			; $5a23
	ld a,(de)		; $5a24
	ld c,a			; $5a25
	jr +			; $5a26

@seasonsFunc_07_5a28:
	call objectCheckIsOnHazard		; $5a28
	ret c			; $5a2b
	ld e,$0b		; $5a2c
	ld a,(de)		; $5a2e
	ld b,a			; $5a2f
	ld e,$0d		; $5a30
	ld a,(de)		; $5a32
	ld c,a			; $5a33
+
	ld e,$16		; $5a34
	ld a,(de)		; $5a36
	ld l,a			; $5a37
	inc e			; $5a38
	ld a,(de)		; $5a39
	ld h,a			; $5a3a
	push bc			; $5a3b
	ld bc,$0004		; $5a3c
	add hl,bc		; $5a3f
	pop bc			; $5a40
	ld a,b			; $5a41
	cp $18			; $5a42
	jr nc,+			; $5a44
	ld a,$18		; $5a46
+
	cp $99			; $5a48
	jr c,+			; $5a4a
	ld a,$98		; $5a4c
+
	ldi (hl),a		; $5a4e
	ld a,c			; $5a4f
	cp $18			; $5a50
	jr nc,+			; $5a52
	ld a,$18		; $5a54
+
	cp $d9			; $5a56
	jr c,+			; $5a58
	ld a,$d8		; $5a5a
+
	ld (hl),a		; $5a5c
	ret			; $5a5d

@seasonsFunc_07_5a5e:
	ld a,(wLinkInAir)		; $5a5e
	rlca			; $5a61
	ret c			; $5a62
	ld a,($d004)		; $5a63
	cp $01			; $5a66
	ret nz			; $5a68
	call objectCheckCollidedWithLink_ignoreZ		; $5a69
	ret nc			; $5a6c
	ld a,($d00b)		; $5a6d
	ld b,a			; $5a70
	ld a,($d00d)		; $5a71
	ld c,a			; $5a74
	call objectCheckContainsPoint		; $5a75
	jr c,+			; $5a78
	call objectGetAngleTowardLink		; $5a7a
	ld c,a			; $5a7d
	ld b,$78		; $5a7e
	jp updateLinkPositionGivenVelocity		; $5a80
+
	call objectGetAngleTowardLink		; $5a83
	ld c,a			; $5a86
	ld b,$14		; $5a87
	jp updateLinkPositionGivenVelocity		; $5a89
.endif

;;
; ITEMID_28 (ricky/moosh attack?)
;
; @addr{5b8c}
itemCode28:
	ld e,Item.state		; $5b8c
	ld a,(de)		; $5b8e
	or a			; $5b8f
	jr nz,+			; $5b90

	; Initialization
	call itemIncState		; $5b92
	ld l,Item.counter1		; $5b95
	ld (hl),$14		; $5b97
	call _itemLoadAttributesAndGraphics		; $5b99
	jr @calculatePosition			; $5b9c
+
	call @calculatePosition		; $5b9e
	call @tryToBreakTiles		; $5ba1
	call itemDecCounter1		; $5ba4
	ret nz			; $5ba7
	jp itemDelete		; $5ba8

@calculatePosition:
	ld a,(w1Companion.id)		; $5bab
	cp SPECIALOBJECTID_RICKY			; $5bae
	ld hl,@mooshData		; $5bb0
	jr nz,+			; $5bb3

	ld a,(w1Companion.direction)		; $5bb5
	add a			; $5bb8
	ld hl,@rickyData		; $5bb9
	rst_addDoubleIndex			; $5bbc
+
	jp _itemInitializeFromLinkPosition		; $5bbd


; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets from Link's position

@rickyData:
	.db $10 $0c $f4 $00 ; DIR_UP
	.db $0c $12 $fe $08 ; DIR_RIGHT
	.db $10 $0c $08 $00 ; DIR_DOWN
	.db $0c $12 $fe $f8 ; DIR_LEFT

@mooshData:
	.db $18 $18 $10 $00


@tryToBreakTiles:
	ld hl,@rickyBreakableTileOffsets		; $5bd4
	ld a,(w1Companion.id)		; $5bd7
	cp SPECIALOBJECTID_RICKY			; $5bda
	jr z,@nextTile			; $5bdc
	ld hl,@mooshBreakableTileOffsets		; $5bde

@nextTile:
	; Get item Y/X + offset in bc
	ld e,Item.yh		; $5be1
	ld a,(de)		; $5be3
	add (hl)		; $5be4
	ld b,a			; $5be5
	inc hl			; $5be6
	ld e,Item.xh		; $5be7
	ld a,(de)		; $5be9
	add (hl)		; $5bea
	ld c,a			; $5beb

	inc hl			; $5bec
	push hl			; $5bed
	ld a,(w1Companion.id)		; $5bee
	cp SPECIALOBJECTID_RICKY			; $5bf1
	ld a,BREAKABLETILESOURCE_0f		; $5bf3
	jr z,+			; $5bf5
	ld a,BREAKABLETILESOURCE_11		; $5bf7
+
	call tryToBreakTile		; $5bf9
	pop hl			; $5bfc
	ld a,(hl)		; $5bfd
	cp $ff			; $5bfe
	jr nz,@nextTile		; $5c00
	ret			; $5c02


; List of offsets from this object's position to try breaking tiles at

@rickyBreakableTileOffsets:
	.db $f8 $08
	.db $f8 $f8
	.db $08 $08
	.db $08 $f8
	.db $ff

@mooshBreakableTileOffsets:
	.db $00 $00
	.db $f0 $f0
	.db $f0 $00
	.db $f0 $10
	.db $00 $f0
	.db $00 $10
	.db $10 $f0
	.db $10 $00
	.db $10 $10
	.db $ff


;;
; ITEMID_SHOVEL
; @addr{5c1f}
itemCode15:
	ld e,Item.state		; $5c1f
	ld a,(de)		; $5c21
	or a			; $5c22
	jr nz,@state1		; $5c23

	; Initialization (state 0)

	call _itemLoadAttributesAndGraphics		; $5c25
	call itemIncState		; $5c28
	ld l,Item.counter1		; $5c2b
	ld (hl),$04		; $5c2d

	ld a,BREAKABLETILESOURCE_06		; $5c2f
	call itemTryToBreakTile		; $5c31
	ld a,SND_CLINK		; $5c34
	jr nc,+			; $5c36

	; Dig succeeded
	ld a,$01		; $5c38
	call addToGashaMaturity		; $5c3a
	ld a,SND_DIG		; $5c3d
+
	jp playSound		; $5c3f

; State 1: does nothing for 4 frames?
@state1:
	call itemDecCounter1		; $5c42
	ret nz			; $5c45
	jp itemDelete		; $5c46

.ifdef ROM_AGES
;;
; ITEMID_CANE_OF_SOMARIA
; @addr{5c49}
itemCode04:
	call _itemTransferKnockbackToLink		; $5c49
	ld e,Item.state		; $5c4c
	ld a,(de)		; $5c4e
	rst_jumpTable			; $5c4f

	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,UNCMP_GFXH_1c		; $5c56
	call loadWeaponGfx		; $5c58
	call _loadAttributesAndGraphicsAndIncState		; $5c5b

	ld a,SND_SWORDSLASH		; $5c5e
	call playSound		; $5c60

	xor a			; $5c63
	call itemSetAnimation		; $5c64
	jp objectSetVisible82		; $5c67

@state1:
	; Wait for a particular part of the swing animation
	ld a,(w1ParentItem2.animParameter)		; $5c6a
	cp $06			; $5c6d
	ret nz			; $5c6f

	call itemIncState		; $5c70

	ld c,ITEMID_18		; $5c73
	call findItemWithID		; $5c75
	jr nz,+			; $5c78

	; Set var2f of any previous instance of ITEMID_18 (triggers deletion?)
	ld l,Item.var2f		; $5c7a
	set 5,(hl)		; $5c7c
+
	; Get in bc the place to try to make a block
	ld a,(w1Link.direction)		; $5c7e
	ld hl,@somariaCreationOffsets		; $5c81
	rst_addDoubleIndex			; $5c84
	ld a,(w1Link.yh)		; $5c85
	add (hl)		; $5c88
	ld b,a			; $5c89
	inc hl			; $5c8a
	ld a,(w1Link.xh)		; $5c8b
	add (hl)		; $5c8e
	ld c,a			; $5c8f

	call getFreeItemSlot		; $5c90
	ret nz			; $5c93
	inc (hl)		; $5c94
	inc l			; $5c95
	ld (hl),ITEMID_18		; $5c96

	; Set Y/X of the new item as calculated earlier, and copy Link's Z position
	ld l,Item.yh		; $5c98
	ld (hl),b		; $5c9a
	ld a,(w1Link.zh)		; $5c9b
	ld l,Item.zh		; $5c9e
	ldd (hl),a		; $5ca0
	dec l			; $5ca1
	ld (hl),c		; $5ca2

@state2:
	ret			; $5ca3

; Offsets relative to link's position to try to create a somaria block?
@somariaCreationOffsets:
	.dw $00ec ; DIR_UP
	.dw $1300 ; DIR_RIGHT
	.dw $0013 ; DIR_DOWN
	.dw $ec00 ; DIR_LEFT


;;
; ITEMID_18 (somaria block object)
; @addr{5cac}
itemCode18:
	ld e,Item.state		; $5cac
	ld a,(de)		; $5cae
	rst_jumpTable			; $5caf

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4


; State 0: initialization
@state0:
	call _itemMergeZPositionIfSidescrollingArea		; $5cba
	call @alignOnTile		; $5cbd
	call _itemLoadAttributesAndGraphics		; $5cc0
	xor a			; $5cc3
	call itemSetAnimation		; $5cc4
	call itemIncState		; $5cc7
	ld a,SND_MYSTERY_SEED		; $5cca
	call playSound		; $5ccc
	jp objectSetVisible83		; $5ccf


; State 1: phasing in
@state1:
	call @checkBlockCanAppear		; $5cd2
	call z,@pushLinkAway		; $5cd5

	; Wait for phase-in animation to complete
	call itemAnimate		; $5cd8
	ld e,Item.animParameter		; $5cdb
	ld a,(de)		; $5cdd
	or a			; $5cde
	ret z			; $5cdf

	; Animation done

	ld h,d			; $5ce0
	ld l,Item.oamFlagsBackup		; $5ce1
	ld a,$0d		; $5ce3
	ldi (hl),a		; $5ce5
	ldi (hl),a		; $5ce6

	; Item.oamTileIndexBase
	ld (hl),$36		; $5ce7

	; Enable collisions with enemies?
	ld l,Item.collisionType		; $5ce9
	set 7,(hl)		; $5ceb

@checkCreateBlock:
	call @checkBlockCanAppear		; $5ced
	jr nz,@deleteSelfWithPuff	; $5cf0
	call @createBlockIfNotOnHazard		; $5cf2
	jr nz,@deleteSelfWithPuff	; $5cf5

	; Note: a = 0 here

	ld h,d			; $5cf7
	ld l,Item.zh		; $5cf8
	ld (hl),a		; $5cfa

	; Set [state]=3, [state2]=0
	ld l,Item.state2		; $5cfb
	ldd (hl),a		; $5cfd
	ld (hl),$03		; $5cfe

	ld l,Item.collisionRadiusY		; $5d00
	ld a,$04		; $5d02
	ldi (hl),a		; $5d04
	ldi (hl),a		; $5d05

	ld l,Item.var2f		; $5d06
	ld a,(hl)		; $5d08
	and $f0			; $5d09
	ld (hl),a		; $5d0b

	ld a,$01		; $5d0c
	jp itemSetAnimation		; $5d0e


; State 4: block being pushed
@state4:
	ld e,Item.state2		; $5d11
	ld a,(de)		; $5d13
	rst_jumpTable			; $5d14

	.dw @state4Substate0
	.dw @state4Substate1

@state4Substate0:
	call itemIncState2		; $5d19
	call itemUpdateAngle		; $5d1c

	; Set speed & counter1 based on bracelet level
	ldbc SPEED_80, $20		; $5d1f
	ld a,(wBraceletLevel)		; $5d22
	cp $02			; $5d25
	jr nz,+			; $5d27
	ldbc SPEED_c0, $15		; $5d29
+
	ld l,Item.speed		; $5d2c
	ld (hl),b		; $5d2e
	ld l,Item.counter1		; $5d2f
	ld (hl),c		; $5d31

	ld a,SND_MOVEBLOCK		; $5d32
	call playSound		; $5d34
	call @removeBlock		; $5d37

@state4Substate1:
	call _itemUpdateDamageToApply		; $5d3a
	jr c,@deleteSelfWithPuff	; $5d3d
	call @checkDeletionTrigger		; $5d3f
	jr nz,@deleteSelfWithPuff	; $5d42

	call objectApplySpeed		; $5d44
	call @pushLinkAway		; $5d47
	call itemDecCounter1		; $5d4a

	ld l,Item.collisionRadiusY		; $5d4d
	ld a,$04		; $5d4f
	ldi (hl),a		; $5d51
	ld (hl),a		; $5d52

	; Return if counter1 is not 0
	ret nz			; $5d53

	jr @checkCreateBlock		; $5d54


@removeBlockAndDeleteSelfWithPuff:
	call @removeBlock		; $5d56
@deleteSelfWithPuff:
	ld h,d			; $5d59
	ld l,Item.var2f		; $5d5a
	bit 4,(hl)		; $5d5c
	call z,objectCreatePuff		; $5d5e
@deleteSelf:
	jp itemDelete		; $5d61


; State 2: being picked up / thrown
@state2:
	ld e,Item.state2		; $5d64
	ld a,(de)		; $5d66
	rst_jumpTable			; $5d67

	.dw @state2Substate0
	.dw @state2Substate1
	.dw @state2Substate2
	.dw @state2Substate3

; Substate 0: just picked up
@state2Substate0:
	call itemIncState2		; $5d70
	call @removeBlock		; $5d73
	call objectSetVisiblec1		; $5d76
	ld a,$02		; $5d79
	jp itemSetAnimation		; $5d7b

; Substate 1: being lifted
@state2Substate1:
	call _itemUpdateDamageToApply		; $5d7e
	ret nc			; $5d81
	call dropLinkHeldItem		; $5d82
	jr @deleteSelfWithPuff		; $5d85

; Substate 2/3: being thrown
@state2Substate2:
@state2Substate3:
	call objectCheckWithinRoomBoundary		; $5d87
	jr nc,@deleteSelf	; $5d8a

	call _bombUpdateThrowingLaterally		; $5d8c
	call @checkDeletionTrigger		; $5d8f
	jr nz,@deleteSelfWithPuff	; $5d92

	; var39 = gravity
	ld l,Item.var39		; $5d94
	ld c,(hl)		; $5d96
	call _itemUpdateThrowingVerticallyAndCheckHazards		; $5d97
	jr c,@deleteSelf	; $5d9a

	ret z			; $5d9c
	jr @deleteSelfWithPuff		; $5d9d


; State 3: block is just sitting around
@state3:
	call @checkBlockInPlace		; $5d9f
	jr nz,@deleteSelfWithPuff	; $5da2

	; Check if health went below 0
	call _itemUpdateDamageToApply		; $5da4
	jr c,@removeBlockAndDeleteSelfWithPuff	; $5da7

	; Check bit 5 of var2f (set when another somaria block is being created)
	call @checkDeletionTrigger		; $5da9
	jr nz,@removeBlockAndDeleteSelfWithPuff	; $5dac

	; If Link somehow ends up on this tile, delete the block
	ld a,(wActiveTilePos)		; $5dae
	ld l,Item.var32		; $5db1
	cp (hl)			; $5db3
	jr z,@removeBlockAndDeleteSelfWithPuff	; $5db4

	; If in a sidescrolling area, check that the tile below is solid
	ld a,(wTilesetFlags)		; $5db6
	and TILESETFLAG_SIDESCROLL			; $5db9
	jr z,++			; $5dbb

	ld a,(hl)		; $5dbd
	add $10			; $5dbe
	ld c,a			; $5dc0
	ld b,>wRoomCollisions		; $5dc1
	ld a,(bc)		; $5dc3
	cp $0f			; $5dc4
	jr nz,@removeBlockAndDeleteSelfWithPuff	; $5dc6
++
	ld l,Item.var2f		; $5dc8
	bit 0,(hl)		; $5dca
	jp z,objectAddToGrabbableObjectBuffer		; $5dcc

	; Link pushed on the block
	ld a,$04		; $5dcf
	jp itemSetState		; $5dd1

;;
; @param[out]	zflag	Unset if slated for deletion
; @addr{5dd4}
@checkDeletionTrigger:
	ld h,d			; $5dd4
	ld l,Item.var2f		; $5dd5
	bit 5,(hl)		; $5dd7
	ret			; $5dd9

;;
; @addr{5dda}
@pushLinkAway:
	ld e,Item.collisionRadiusY		; $5dda
	ld a,$07		; $5ddc
	ld (de),a		; $5dde
	ld hl,w1Link		; $5ddf
	jp preventObjectHFromPassingObjectD		; $5de2

;;
; @param[out]	zflag	Set if the cane of somaria block is present, and is solid?
; @addr{5de5}
@checkBlockInPlace:
	ld e,Item.var32		; $5de5
	ld a,(de)		; $5de7
	ld l,a			; $5de8
	ld h,>wRoomLayout		; $5de9
	ld a,(hl)		; $5deb
	cp TILEINDEX_SOMARIA_BLOCK			; $5dec
	ret nz			; $5dee

	ld h,>wRoomCollisions		; $5def
	ld a,(hl)		; $5df1
	cp $0f			; $5df2
	ret			; $5df4

;;
; @addr{5df5}
@removeBlock:
	call @checkBlockInPlace		; $5df5
	ret nz			; $5df8

	; Restore tile
	ld e,Item.var32		; $5df9
	ld a,(de)		; $5dfb
	call getTileIndexFromRoomLayoutBuffer		; $5dfc
	jp setTile		; $5dff

;;
; @param[out]	zflag	Set if the block can appear at this position
; @addr{5e02}
@checkBlockCanAppear:
	; Disallow cane of somaria usage if in patch's minigame room
	ld a,(wActiveGroup)		; $5e02
	cp $05			; $5e05
	jr nz,+			; $5e07
	ld a,(wActiveRoom)		; $5e09
	cp $e8			; $5e0c
	jr z,@@disallow		; $5e0e
+
	; Must be close to the ground
	ld e,Item.zh		; $5e10
	ld a,(de)		; $5e12
	dec a			; $5e13
	cp $fc			; $5e14
	jr c,@@disallow		; $5e16

	; Can't be in a wall
	call objectGetTileCollisions		; $5e18
	ret nz			; $5e1b

	; If underwater, never allow it
	ld a,(wTilesetFlags)		; $5e1c
	bit TILESETFLAG_BIT_UNDERWATER,a			; $5e1f
	ret nz			; $5e21

	; If in a sidescrolling area, check for floor underneath
	and TILESETFLAG_SIDESCROLL			; $5e22
	ret z			; $5e24

	ld a,l			; $5e25
	add $10			; $5e26
	ld l,a			; $5e28
	ld a,(hl)		; $5e29
	cp $0f			; $5e2a
	ret			; $5e2c

@@disallow:
	or d			; $5e2d
	ret			; $5e2e

;;
; @param[out]	zflag	Set on success
; @addr{5e2f}
@createBlockIfNotOnHazard:
	call @alignOnTile		; $5e2f
	call objectGetTileAtPosition		; $5e32
	push hl			; $5e35
	ld hl,hazardCollisionTable		; $5e36
	call lookupCollisionTable		; $5e39
	pop hl			; $5e3c
	jr c,++			; $5e3d

	; Overwrite the tile with the somaria block
	ld b,(hl)		; $5e3f
	ld (hl),TILEINDEX_SOMARIA_BLOCK		; $5e40
	ld h,>wRoomCollisions		; $5e42
	ld (hl),$0f		; $5e44

	; Save the old value of the tile to w3RoomLayoutBuffer
	ld e,Item.var32		; $5e46
	ld a,l			; $5e48
	ld (de),a		; $5e49
	ld c,a			; $5e4a
	call setTileInRoomLayoutBuffer		; $5e4b
	xor a			; $5e4e
	ret			; $5e4f
++
	or d			; $5e50
	ret			; $5e51

@alignOnTile:
	call objectCenterOnTile		; $5e52
	ld l,Item.yh		; $5e55
	dec (hl)		; $5e57
	dec (hl)		; $5e58
	ret			; $5e59
.else
; ITEMID_ROD_OF_SEASONS
itemCode07:
	call _itemTransferKnockbackToLink		; $5b49
	ld e,Object.state		; $5b4c
	ld a,(de)		; $5b4e
	rst_jumpTable			; $5b4f
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $5b54
	ld (de),a		; $5b56
	ld h,d			; $5b57
	ld l,$00		; $5b58
	ld (hl),$03		; $5b5a
	ld l,$06		; $5b5c
	ld (hl),$10		; $5b5e
	ld a,$74		; $5b60
	call playSound		; $5b62
	ld a,$1c		; $5b65
	call loadWeaponGfx		; $5b67
	call _itemLoadAttributesAndGraphics		; $5b6a
	jp objectSetVisible82		; $5b6d
@state1:
	ld h,d			; $5b70
	ld l,$06		; $5b71
	dec (hl)		; $5b73
	ret nz			; $5b74
	ld a,(wActiveTileType)		; $5b75
	cp $08			; $5b78
	ret nz			; $5b7a
	call getFreeInteractionSlot		; $5b7b
	ret nz			; $5b7e
	ld (hl),INTERACID_USED_ROD_OF_SEASONS		; $5b7f
	ld e,$09		; $5b81
	ld l,$49		; $5b83
	ld a,(de)		; $5b85
	ldi (hl),a		; $5b86
	jp objectCopyPosition		; $5b87
.endif

;;
; ITEMID_MINECART_COLLISION
; @addr{5e5a}
itemCode1d:
	ld e,Item.state		; $5e5a
	ld a,(de)		; $5e5c
	or a			; $5e5d
	ret nz			; $5e5e

	call _itemLoadAttributesAndGraphics		; $5e5f
	call itemIncState		; $5e62
	ld l,Item.enabled		; $5e65
	set 1,(hl)		; $5e67

@ret:
	ret			; $5e69

;;
; ITEMID_MINECART_COLLISION
; @addr{5e6a}
itemCode1dPost:
	ld hl,w1Companion.id		; $5e6a
	ld a,(hl)		; $5e6d
	cp SPECIALOBJECTID_MINECART			; $5e6e
	jp z,objectTakePosition		; $5e70
	jp itemDelete		; $5e73

.ifdef ROM_AGES
;;
; ITEMID_SLINGSHOT
; @addr{5e76}
itemCode13:
	ret			; $5e76
.else
; ITEMID_SLINGSHOT
itemCode13:
	ld e,Item.state		; $5ba6
	ld a,(de)		; $5ba8
	or a			; $5ba9
	ret nz			; $5baa
	ld a,$1d		; $5bab
	call loadWeaponGfx		; $5bad
	call _loadAttributesAndGraphicsAndIncState		; $5bb0
	ld h,d			; $5bb3
	ld a,(wSlingshotLevel)		; $5bb4
	or $08			; $5bb7
	ld l,$1b		; $5bb9
	ldi (hl),a		; $5bbb
	ld (hl),a		; $5bbc
	jp objectSetVisible81		; $5bbd

foolsOreRet:
	ret			; $5bc0

; ITEMID_MAGNET_GLOVES
itemCode08:
	ld e,Item.state		; $5bc1
	ld a,(de)		; $5bc3
	rst_jumpTable			; $5bc4
	.dw @state0
	.dw @state1

@state0:
	ld a,$1e		; $5bc9
	call loadWeaponGfx	; $5bcb
	call _loadAttributesAndGraphicsAndIncState		; $5bce
	call objectSetVisible81		; $5bd1

@state1:
	ld a,(wMagnetGloveState)		; $5bd4
	bit 1,a			; $5bd7
	ld a,$0c		; $5bd9
	jr z,+			; $5bdb
	inc a			; $5bdd
+
	ld h,d			; $5bde
	ld l,Item.oamFlagsBackup		; $5bdf
	ldi (hl),a		; $5be1
	ld (hl),a		; $5be2
	ret			; $5be3
.endif

; ITEMID_FOOLS_ORE
itemCode1e:
.ifdef ROM_SEASONS
	ld e,Item.state		; $5be4
	ld a,(de)		; $5be6
	rst_jumpTable			; $5be7
	.dw @state0
	.dw foolsOreRet

@state0:
	ld a,$1f		; $5bec
	call loadWeaponGfx		; $5bee
	call _loadAttributesAndGraphicsAndIncState		; $5bf1
	xor a			; $5bf4
	call itemSetAnimation		; $5bf5
	jp objectSetVisible82		; $5bf8
.endif

;;
; ITEMID_BIGGORON_SWORD
; @addr{5e77}
itemCode0c:
	ld e,Item.state		; $5e77
	ld a,(de)		; $5e79
	rst_jumpTable			; $5e7a

	.dw @state0
	.dw itemCode1d@ret

@state0:
	ld a,UNCMP_GFXH_1b		; $5e7f
	call loadWeaponGfx		; $5e81
	call _loadAttributesAndGraphicsAndIncState		; $5e84
	ld a,SND_BIGSWORD		; $5e87
	call playSound		; $5e89
	jp objectSetVisible82		; $5e8c


;;
; ITEMID_SWORD
; @addr{5e8f}
itemCode05:
	call _itemTransferKnockbackToLink		; $5e8f
	ld e,Item.state		; $5e92
	ld a,(de)		; $5e94
	rst_jumpTable			; $5e95

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@swordSounds:
	.db SND_SWORDSLASH
	.db SND_UNKNOWN5
	.db SND_BOOMERANG
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH
	.db SND_UNKNOWN5
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH


@state0:
	ld a,UNCMP_GFXH_1a		; $5eac
	call loadWeaponGfx		; $5eae

	; Play a random sound
	call getRandomNumber_noPreserveVars		; $5eb1
	and $07			; $5eb4
	ld hl,@swordSounds		; $5eb6
	rst_addAToHl			; $5eb9
	ld a,(hl)		; $5eba
	call playSound		; $5ebb

	ld e,Item.var31		; $5ebe
	xor a			; $5ec0
	ld (de),a		; $5ec1


; State 6: partial re-initialization?
@state6:
	call _loadAttributesAndGraphicsAndIncState		; $5ec2

	; Load collisiontype and damage
	ld a,(wSwordLevel)		; $5ec5
	ld hl,@swordLevelData-2		; $5ec8
	rst_addDoubleIndex			; $5ecb

	ld e,Item.collisionType		; $5ecc
	ldi a,(hl)		; $5ece
	ld (de),a		; $5ecf
	ld c,(hl)		; $5ed0

	; If var31 was nonzero, skip whimsical ring check?
	ld e,Item.var31		; $5ed1
	ld a,(de)		; $5ed3
	or a			; $5ed4
	ld a,c			; $5ed5
	ld (de),a		; $5ed6
	jr nz,@@setDamage		; $5ed7

	; Whimsical ring: usually 1 damage, with a 1/256 chance of doing 12 damage
	ld a,WHIMSICAL_RING		; $5ed9
	call cpActiveRing		; $5edb
	jr nz,@@setDamage		; $5ede
	call getRandomNumber		; $5ee0
	or a			; $5ee3
	ld c,-1		; $5ee4
	jr nz,@@setDamage		; $5ee6
	ld a,SND_LIGHTNING		; $5ee8
	call playSound		; $5eea
	ld c,-12		; $5eed

@@setDamage:
	ld e,Item.var3a		; $5eef
	ld a,c			; $5ef1
	ld (de),a		; $5ef2

	ld e,Item.state		; $5ef3
	ld a,$01		; $5ef5
	ld (de),a		; $5ef7

	jp objectSetVisible82		; $5ef8

; b0: collisionType
; b1: base damage
@swordLevelData:
	; L-1
	.db ($80|ITEMCOLLISION_L1_SWORD)
	.db (-2)

	; L-2
	.db ($80|ITEMCOLLISION_L2_SWORD)
	.db (-3)

	; L-3
	.db ($80|ITEMCOLLISION_L3_SWORD)
	.db (-5)


; State 4: swordspinning
@state4:
	ld e,Item.collisionType		; $5f01
	ld a, $80 | ITEMCOLLISION_SWORDSPIN		; $5f03
	ld (de),a		; $5f05


; State 1: being swung
@state1:
	ld h,d			; $5f06
	ld l,Item.oamFlagsBackup		; $5f07
	ldi a,(hl)		; $5f09
	ld (hl),a		; $5f0a
	ret			; $5f0b


; State 2: charging
@state2:
	ld e,Item.var31		; $5f0c
	ld a,(de)		; $5f0e
	ld e,Item.var3a		; $5f0f
	ld (de),a		; $5f11
	ret			; $5f12


; State 3: sword fully charged, flashing
@state3:
	ld h,d			; $5f13
	ld l,Item.counter1		; $5f14
	inc (hl)		; $5f16
	bit 2,(hl)		; $5f17
	ld l,Item.oamFlagsBackup		; $5f19
	ldi a,(hl)		; $5f1b
	jr nz,+			; $5f1c
	ld a,$0d		; $5f1e
+
	ld (hl),a		; $5f20
	ret			; $5f21


; State 5: end of swordspin
@state5:
	; Try to break tile at Link's feet, then delete self
	ld a,$08		; $5f22
	call _tryBreakTileWithSword_calculateLevel		; $5f24
	jp itemDelete		; $5f27


;;
; ITEMID_PUNCH
; ITEMID_NONE also points here, but this doesn't get called from there normally
; @addr{5f2a}
itemCode00:
itemCode02:
	ld e,Item.state		; $5f2a
	ld a,(de)		; $5f2c
	rst_jumpTable			; $5f2d

	.dw @state0
	.dw @state1

@state0:
	call _itemLoadAttributesAndGraphics		; $5f32
	ld c,SND_STRIKE		; $5f35
	call itemIncState		; $5f37
	ld l,Item.counter1		; $5f3a
	ld (hl),$04		; $5f3c
	ld l,Item.subid		; $5f3e
	bit 0,(hl)		; $5f40
	jr z,++			; $5f42

	; Expert's ring (bit 0 of Item.subid set)

	ld l,Item.collisionRadiusY		; $5f44
	ld a,$06		; $5f46
	ldi (hl),a		; $5f48
	ldi (hl),a		; $5f49

	; Increase Item.damage
	ld a,(hl)		; $5f4a
	add $fd			; $5f4b
	ld (hl),a		; $5f4d

	; Different collisionType for expert's ring?
	ld l,Item.collisionType		; $5f4e
	inc (hl)		; $5f50

	; Check for clinks against bombable walls?
	call _tryBreakTileWithExpertsRing		; $5f51

	ld c,SND_EXPLOSION		; $5f54
++
	ld a,c			; $5f56
	jp playSound		; $5f57

@state1:
	call itemDecCounter1		; $5f5a
	jp z,itemDelete		; $5f5d
	ret			; $5f60


;;
; ITEMID_SWORD_BEAM
; @addr{5f61}
itemCode27:
	ld e,Item.state		; $5f61
	ld a,(de)		; $5f63
	rst_jumpTable			; $5f64

	.dw @state0
	.dw @state1

@state0:
	ld hl,@initialOffsetsTable		; $5f69
	call _applyOffsetTableHL		; $5f6c
	call _itemLoadAttributesAndGraphics		; $5f6f
	call itemIncState		; $5f72

	ld l,Item.speed		; $5f75
	ld (hl),SPEED_300		; $5f77

	; Calculate angle
	ld l,Item.direction		; $5f79
	ldi a,(hl)		; $5f7b
	ld c,a			; $5f7c
	swap a			; $5f7d
	rrca			; $5f7f
	ld (hl),a		; $5f80

	ld a,c			; $5f81
	call itemSetAnimation		; $5f82
	call objectSetVisible81		; $5f85

	ld a,SND_SWORDBEAM		; $5f88
	jp playSound		; $5f8a

@initialOffsetsTable:
	.db $f5 $fc $00 ; DIR_UP
	.db $00 $0c $00 ; DIR_RIGHT
	.db $0a $03 $00 ; DIR_DOWN
	.db $00 $f3 $00 ; DIR_LEFT

@state1:
	call _itemUpdateDamageToApply		; $5f99
	jr nz,@collision		; $5f9c

	; No collision with an object?

	call objectApplySpeed		; $5f9e
	call objectCheckTileCollision_allowHoles		; $5fa1
	jr nc,@noCollision			; $5fa4

	call _itemCheckCanPassSolidTile		; $5fa6
	jr nz,@collision		; $5fa9

@noCollision:
	; Flip palette every 4 frames
	ld a,(wFrameCounter)		; $5fab
	and $03			; $5fae
	jr nz,+			; $5fb0
	ld h,d			; $5fb2
	ld l,Item.oamFlagsBackup		; $5fb3
	ld a,(hl)		; $5fb5
	xor $01			; $5fb6
	ldi (hl),a		; $5fb8
	ldi (hl),a		; $5fb9
+
	call objectCheckWithinScreenBoundary		; $5fba
	ret c			; $5fbd
	jp itemDelete		; $5fbe

@collision:
	ldbc INTERACID_CLINK, $81		; $5fc1
	call objectCreateInteraction		; $5fc4
	jp itemDelete		; $5fc7

;;
; Used for sword, cane of somaria, rod of seasons. Updates animation, deals with
; destroying tiles?
;
; @addr{5fca}
_updateSwingableItemAnimation:
	ld l,Item.animParameter		; $5fca
.ifdef ROM_AGES
	cp $04			; $5fcc
.else
	cp $07			; $5fcc
.endif
	jr z,_label_07_227	; $5fce
	bit 6,(hl)		; $5fd0
	jr z,_label_07_227	; $5fd2

	res 6,(hl)		; $5fd4
	ld a,(hl)		; $5fd6
	and $1f			; $5fd7
	cp $10			; $5fd9
	jr nc,+			; $5fdb
	ld a,(w1Link.direction)		; $5fdd
	add a			; $5fe0
+
	and $07			; $5fe1
	push hl			; $5fe3
	call _tryBreakTileWithSword_calculateLevel		; $5fe4
	pop hl			; $5fe7

_label_07_227:
	ld c,$10		; $5fe8
	ld a,(hl)		; $5fea
	and $1f			; $5feb
	cp c			; $5fed
	jr nc,+			; $5fee

	srl a			; $5ff0
	ld c,a			; $5ff2
	ld a,(w1Link.direction)		; $5ff3
	add a			; $5ff6
	add a			; $5ff7
	add c			; $5ff8
	ld c,$00		; $5ff9
+
	ld hl,@data		; $5ffb
	rst_addAToHl			; $5ffe
	ld a,(hl)		; $5fff
	and $f0			; $6000
	swap a			; $6002
	add c			; $6004
	ld e,Item.var30		; $6005
	ld (de),a		; $6007

	ld a,(hl)		; $6008
	and $07			; $6009
	jp itemSetAnimation		; $600b


; For each byte:
;  Bits 4-7: value for Item.var30?
;  Bits 0-2: Animation index?
@data:
	.db $02 $41 $80 $c0 $10 $51 $92 $d2
	.db $26 $65 $a4 $e4 $30 $77 $b6 $f6

	.db $00 $11 $22 $33 $44 $55 $66 $77

;;
; Analagous to _updateSwingableItemAnimation, but specifically for biggoron's sword
;
; @addr{6026}
_updateBiggoronSwordAnimation:
	ld b,$00		; $6026
	ld l,Item.animParameter		; $6028
	bit 6,(hl)		; $602a
	jr z,+			; $602c
	res 6,(hl)		; $602e
	inc b			; $6030
+
	ld a,(hl)		; $6031
	and $0e			; $6032
	rrca			; $6034
	ld c,a			; $6035
	ld a,(w1Link.direction)		; $6036
	cp $01			; $6039
	jr nz,+			; $603b
	ld a,c			; $603d
	jr ++			; $603e
+
	inc a			; $6040
	add a			; $6041
	sub c			; $6042
++
	and $07			; $6043
	bit 0,b			; $6045
	jr z,++			; $6047

	push af			; $6049
	ld c,a			; $604a
	ld a,BREAKABLETILESOURCE_SWORD_L2		; $604b
	call _tryBreakTileWithSword		; $604d
	pop af			; $6050
++
	ld e,Item.var30		; $6051
	ld (de),a		; $6053
	jp itemSetAnimation		; $6054

;;
; ITEMID_MAGNET_GLOVES
;
; @addr{6057}
itemCode08Post:
	call _cpRelatedObject1ID		; $6057
	jp nz,itemDelete		; $605a

	ld hl,w1Link.yh		; $605d
	call objectTakePosition		; $6060
	ld a,(wFrameCounter)		; $6063
	rrca			; $6066
	rrca			; $6067
	ld a,(w1Link.direction)		; $6068
	adc a			; $606b
	ld e,Item.var30		; $606c
	ld (de),a		; $606e
	jp itemSetAnimation		; $606f

;;
; ITEMID_SLINGSHOT
;
; @addr{6072}
itemCode13Post:
	call _cpRelatedObject1ID		; $6072
	jp nz,itemDelete		; $6075

	ld hl,w1Link.yh		; $6078
	call objectTakePosition		; $607b
	ld a,(w1Link.direction)		; $607e
	ld e,Item.var30		; $6081
	ld (de),a		; $6083
	jp itemSetAnimation		; $6084

;;
; ITEMID_FOOLS_ORE
;
; @addr{6087}
itemCode1ePost:
	call _cpRelatedObject1ID		; $6087
	jp nz,itemDelete		; $608a

	ld l,Item.animParameter		; $608d
	ld a,(hl)		; $608f
	and $06			; $6090
	add a			; $6092
	ld b,a			; $6093
	ld a,(w1Link.direction)		; $6094
	add b			; $6097
	ld e,Item.var30		; $6098
	ld (de),a		; $609a
	ld hl,_swordArcData		; $609b
	jr _itemSetPositionInSwordArc		; $609e

;;
; ITEMID_PUNCH
;
; @addr{60a0}
itemCode00Post:
itemCode02Post:
	ld a,(w1Link.direction)		; $60a0
	add $18			; $60a3
	ld hl,_swordArcData		; $60a5
	jr _itemSetPositionInSwordArc		; $60a8

;;
; ITEMID_BIGGORON_SWORD
;
; @addr{60aa}
itemCode0cPost:
	call _cpRelatedObject1ID		; $60aa
	jp nz,itemDelete		; $60ad

	call _updateBiggoronSwordAnimation		; $60b0
	ld e,Item.var30		; $60b3
	ld a,(de)		; $60b5
	ld hl,_biggoronSwordArcData		; $60b6
	call _itemSetPositionInSwordArc		; $60b9
	jp _itemCalculateSwordDamage		; $60bc

;;
; ITEMID_CANE_OF_SOMARIA
; ITEMID_SWORD
; ITEMID_ROD_OF_SEASONS
;
; @addr{60bf}
itemCode04Post:
itemCode05Post:
itemCode07Post:
	call _cpRelatedObject1ID		; $60bf
	jp nz,itemDelete		; $60c2

	call _updateSwingableItemAnimation		; $60c5

	ld e,Item.var30		; $60c8
	ld a,(de)		; $60ca
	ld hl,_swordArcData		; $60cb
	call _itemSetPositionInSwordArc		; $60ce

	jp _itemCalculateSwordDamage		; $60d1

;;
; @param	a	Index for table 'hl'
; @param	hl	Usually points to _swordArcData
; @addr{60d4}
_itemSetPositionInSwordArc:
	add a			; $60d4
	rst_addDoubleIndex			; $60d5

;;
; Copy Link's position (accounting for raised floors, with Z position 2 higher than Link)
;
; @param	hl	Pointer to data for collision radii and position offsets
; @addr{60d6}
_itemInitializeFromLinkPosition:
	ld e,Item.collisionRadiusY		; $60d6
	ldi a,(hl)		; $60d8
	ld (de),a		; $60d9
	inc e			; $60da
	ldi a,(hl)		; $60db
	ld (de),a		; $60dc

	; Y
.ifdef ROM_AGES
	ld a,(wLinkRaisedFloorOffset)		; $60dd
	ld b,a			; $60e0
	ld a,(w1Link.yh)		; $60e1
	add b			; $60e4
.else
	ld a,(w1Link.yh)		; $5e61
.endif
	add (hl)		; $60e5
	ld e,Item.yh		; $60e6
	ld (de),a		; $60e8

	; X
	inc hl			; $60e9
	ld e,Item.xh		; $60ea
	ld a,(w1Link.xh)		; $60ec
	add (hl)		; $60ef
	ld (de),a		; $60f0

	; Z
	ld a,(w1Link.zh)		; $60f1
	ld e,Item.zh		; $60f4
	sub $02			; $60f6
	ld (de),a		; $60f8
	ret			; $60f9


; Each row probably corresponds to part of a sword's arc? (Also used by punches.)
; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets relative to Link
; @addr{60fa}
_swordArcData:
	.db $09 $06 $fe $10
	.db $06 $09 $f2 $00
	.db $09 $06 $00 $f1
	.db $06 $09 $f2 $00
	.db $07 $07 $f5 $0d
	.db $07 $07 $f5 $0d
	.db $07 $07 $11 $f3
	.db $07 $07 $f5 $f3
	.db $09 $06 $ef $fc
	.db $06 $09 $02 $13
	.db $09 $06 $15 $03
	.db $06 $09 $02 $ed
	.db $09 $06 $f6 $fc
	.db $04 $09 $02 $0c
	.db $09 $06 $10 $03
	.db $06 $09 $02 $f4
	.db $09 $09 $ef $fc
	.db $09 $09 $f2 $10
	.db $09 $09 $02 $13
	.db $09 $09 $12 $10
	.db $09 $09 $15 $03
	.db $09 $09 $11 $f3
	.db $09 $09 $02 $ed
	.db $09 $09 $f5 $f3
	.db $05 $05 $f4 $fd
	.db $05 $05 $00 $0c
	.db $05 $05 $0c $03
	.db $05 $05 $00 $f4

; @addr{616a}
_biggoronSwordArcData:
	.db $0b $0b $ef $fe
	.db $09 $0c $f2 $10
	.db $0b $0b $02 $13
	.db $0c $09 $12 $10
	.db $0b $0b $15 $01
	.db $09 $0c $11 $f3
	.db $0b $0b $02 $ed
	.db $0c $09 $f5 $f3


;;
; @addr{618a}
_tryBreakTileWithExpertsRing:
	ld a,(w1Link.direction)		; $618a
	add a			; $618d
	ld c,a			; $618e
	ld a,BREAKABLETILESOURCE_03		; $618f
	jr _tryBreakTileWithSword			; $6191

;;
; Same as below function, except this checks the sword's level to decide on the
; "breakableTileSource".
;
; @param	a	Direction (see below function)
; @addr{6193}
_tryBreakTileWithSword_calculateLevel:
	; Use BREAKABLETILESOURCE_SWORD_L1 or L2 depending on sword's level
	ld c,a			; $6193
	ld a,(wSwordLevel)		; $6194
	cp $01			; $6197
	jr z,_tryBreakTileWithSword		; $6199
	ld a,BREAKABLETILESOURCE_SWORD_L2		; $619b

;;
; Deals with sword slashing / spinning / poking against tiles, breaking them
;
; @param	a	See constants/breakableTileSources.s
; @param	c	Direction (0-7 are 45-degree increments, 8 is link's center)
; @addr{619d}
_tryBreakTileWithSword:
	; Check link is close enough to the ground
	ld e,a			; $619d
	ld a,(w1Link.zh)		; $619e
	dec a			; $61a1
	cp $f6			; $61a2
	ret c			; $61a4

	; Get Y/X relative to Link in bc
	ld a,c			; $61a5
	ld hl,@linkOffsets		; $61a6
	rst_addDoubleIndex			; $61a9
	ld a,(w1Link.yh)		; $61aa
	add (hl)		; $61ad
	ld b,a			; $61ae
	inc hl			; $61af
	ld a,(w1Link.xh)		; $61b0
	add (hl)		; $61b3
	ld c,a			; $61b4

	; Try to break the tile
	push bc			; $61b5
	ld a,e			; $61b6
	call tryToBreakTile		; $61b7

	; Copy tile position, then tile index
	ldh a,(<hFF93)	; $61ba
	ld (wccb0),a		; $61bc
	ldh a,(<hFF92)	; $61bf
	ld (wccaf),a		; $61c1
	pop bc			; $61c4

	; Return if the tile was broken
	ret c			; $61c5

	; Check for bombable wall clink sound
	ld hl,@clinkSoundTable		; $61c6
	call findByteInCollisionTable		; $61c9
	jr c,@bombableWallClink			; $61cc

	; Only continue if the sword is in a "poking" state
	ld a,(w1ParentItem2.subid)		; $61ce
	or a			; $61d1
	ret z			; $61d2

	; Check the second list of tiles to see if it produces no clink at all
	call findByteAtHl		; $61d3
	ret c			; $61d6

	; Produce a clink only if the tile is solid
	ldh a,(<hFF93)	; $61d7
	ld l,a			; $61d9
	ld h,>wRoomCollisions		; $61da
	ld a,(hl)		; $61dc
	cp $0f			; $61dd
	ret nz			; $61df
	ld e,$01		; $61e0
	jr @createClink			; $61e2

	; Play a different sound effect on bombable walls
@bombableWallClink:
	ld a,SND_CLINK2		; $61e4
	call playSound		; $61e6

	; Set bit 7 of subid to prevent 'clink' interaction from also playing a sound
	ld e,$80		; $61e9

@createClink:
	call getFreeInteractionSlot		; $61eb
	ret nz			; $61ee

	ld (hl),INTERACID_CLINK		; $61ef
	inc l			; $61f1
	ld (hl),e		; $61f2
	ld l,Interaction.yh		; $61f3
	ld (hl),b		; $61f5
	ld l,Interaction.xh		; $61f6
	ld (hl),c		; $61f8
	ret			; $61f9


@linkOffsets:
	.db $f2 $00 ; Up
	.db $f2 $0d ; Up-right
	.db $00 $0d ; Right
	.db $0d $0d ; Down-right
	.db $0d $00 ; Down
	.db $0d $f2 ; Down-left
	.db $00 $f2 ; Left
	.db $f2 $f2 ; Up-left
	.db $00 $00 ; Center


; 2 lists per entry:
; * The first is a list of tiles which produce an alternate "clinking" sound indicating
; they're bombable.
; * The second is a list of tiles which don't produce clinks at all.
;
; @addr{620c}
@clinkSoundTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES
@collisions0:
@collisions4:
	.db $c1 $c2 $c4 $d1 $cf
	.db $00

	.db $fd $fe $ff
	.db $00
	.db $00

@collisions1:
@collisions2:
@collisions5:
	.db $1f $30 $31 $32 $33 $38 $39 $3a $3b $68 $69
	.db $00

	.db $0a $0b
	.db $00

@collisions3:
	.db $12
	.db $00

	.db $00
.else
@collisions0:
	.db $c1 $c2 $e2 $cb
	.db $00

	.db $fd $fe $ff $d9 $da $20 $d7

@collisions1:
	.db $00

	.db $fd

@collisions2:
	.db $00
	.db $00

@collisions3:
@collisions4:
	.db $1f $30 $31 $32 $33 $38 $39 $3a $3b
	.db $00

	.db $0a $0b
	.db $00


@collisions5:
	.db $12
	.db $00

	.db $00
.endif

;;
; Calculates the value for Item.damage, accounting for ring modifiers.
;
; @addr{6235}
_itemCalculateSwordDamage:
	ld e,Item.var3a		; $6235
	ld a,(de)		; $6237
	ld b,a			; $6238
	ld a,(w1ParentItem2.var3a)		; $6239
	or a			; $623c
	jr nz,@applyDamageModifier	; $623d

	ld hl,@swordDamageModifiers		; $623f
	ld a,(wActiveRing)		; $6242
	ld e,a			; $6245
@nextRing:
	ldi a,(hl)		; $6246
	or a			; $6247
	jr z,@noRingModifier	; $6248
	cp e			; $624a
	jr z,@foundRingModifier	; $624b
	inc hl			; $624d
	jr @nextRing		; $624e

@noRingModifier:
	ld a,e			; $6250
	cp RED_RING			; $6251
	jr z,@redRing		; $6253
	cp GREEN_RING			; $6255
	jr z,@greenRing		; $6257
	cp CURSED_RING			; $6259
	jr z,@cursedRing	; $625b

	ld a,b			; $625d
	jr @setDamage		; $625e

@redRing:
	ld a,b			; $6260
	jr @applyDamageModifier		; $6261

@greenRing:
	ld a,b			; $6263
	cpl			; $6264
	inc a			; $6265
	sra a			; $6266
	cpl			; $6268
	inc a			; $6269
	jr @applyDamageModifier		; $626a

@cursedRing:
	ld a,b			; $626c
	cpl			; $626d
	inc a			; $626e
	sra a			; $626f
	cpl			; $6271
	inc a			; $6272
	jr @setDamage		; $6273

@foundRingModifier:
	ld a,(hl)		; $6275

@applyDamageModifier:
	add b			; $6276

@setDamage:
	; Make sure it's not positive (don't want to heal enemies)
	bit 7,a			; $6277
	jr nz,+			; $6279
	ld a,$ff		; $627b
+
	ld e,Item.damage		; $627d
	ld (de),a		; $627f
	ret			; $6280


; Negative values give the sword more damage for that ring.
@swordDamageModifiers:
	.db POWER_RING_L1	$ff
	.db POWER_RING_L2	$fe
	.db POWER_RING_L3	$fd
	.db ARMOR_RING_L1	$01
	.db ARMOR_RING_L2	$01
	.db ARMOR_RING_L3	$01
	.db $00


;;
; Makes the given item mimic a tile. Used for switch hooking bushes and pots and stuff,
; possibly for other things too?
; @addr{628e}
_itemMimicBgTile:
	call getTileMappingData		; $628e
	push bc			; $6291
	ld h,d			; $6292

	; Set Item.oamFlagsBackup, Item.oamFlags
	ld l,Item.oamFlagsBackup		; $6293
	ld a,$0f		; $6295
	ldi (hl),a		; $6297
	ldi (hl),a		; $6298

	; Set Item.oamTileIndexBase
	ld (hl),c		; $6299

	; Compare the top-right tile to the top-left tile, and select the appropriate
	; animation depending on whether they reuse the same tile or not.
	; If they don't, it assumes that the graphics are adjacent to each other, due to
	; sprite limitations?
	ld a,($cec1)		; $629a
	sub c			; $629d
	jr z,+			; $629e
	ld a,$01		; $62a0
+
	call itemSetAnimation		; $62a2

	; Copy the BG palette which the tile uses to OBJ palette 7
	pop af			; $62a5
	and $07			; $62a6
	swap a			; $62a8
	rrca			; $62aa
	ld hl,w2TilesetBgPalettes		; $62ab
	rst_addAToHl			; $62ae
	push de			; $62af
	ld a,:w2TilesetSprPalettes		; $62b0
	ld ($ff00+R_SVBK),a	; $62b2
	ld de,w2TilesetSprPalettes+7*8		; $62b4
	ld b,$08		; $62b7
	call copyMemory		; $62b9

	; Mark OBJ 7 as modified
	ld hl,hDirtySprPalettes	; $62bc
	set 7,(hl)		; $62bf

	xor a			; $62c1
	ld ($ff00+R_SVBK),a	; $62c2
	pop de			; $62c4
	ret			; $62c5

;;
; This is the object representation of a tile while being held / thrown?
;
; If it's not a tile (ie. it's dimitri), this is just an invisible item with collisions?
;
; ITEMID_BRACELET
; @addr{62c6}
itemCode16:
	ld e,Item.state		; $62c6
	ld a,(de)		; $62c8
	rst_jumpTable			; $62c9

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call _itemLoadAttributesAndGraphics		; $62d2
	ld h,d			; $62d5
	ld l,Item.enabled		; $62d6
	set 1,(hl)		; $62d8

	; Check subid, which is the index of tile being lifted, or 0 if not lifting a tile
	ld l,Item.subid		; $62da
	ld a,(hl)		; $62dc
	or a			; $62dd
	jr z,@notTile		; $62de

	ld l,Item.state		; $62e0
	ld (hl),$02		; $62e2
	call _itemMimicBgTile		; $62e4
	jp objectSetVisiblec0		; $62e7


; State 1/2: being held
@state1:
@state2:
	ld h,d			; $62ea
	ld l,Item.state2		; $62eb
	ld a,(hl)		; $62ed
	or a			; $62ee
	ret z			; $62ef

	; Item thrown; enable collisions
	ld l,Item.collisionRadiusX		; $62f0
	ld a,$06		; $62f2
	ldd (hl),a		; $62f4
	ldd (hl),a		; $62f5

	; bit 7 of Item.collisionType
	dec l			; $62f6
	set 7,(hl)		; $62f7

	jr @throwItem		; $62f9


; When a bracelet object is created that doesn't come from a tile on the ground, it is
; created at the time it is thrown, instead of the time it is picked up. Also, it's
; invisible, since its only purpose is to provide collisions?
@notTile:
	call _braceletCheckDeleteSelfWhileThrowing		; $62fb

	; Check if relatedObj2 is an item or not?
	ld a,h			; $62fe
	cp >w1Companion			; $62ff
	jr z,@@copyCollisions			; $6301
	ld a,l			; $6303
	cp Item.start+$40			; $6304
	jr c,@throwItem	; $6306

; This will copy collision attributes of non-item objects. This should allow "non-allied"
; objects to damage enemies?
@@copyCollisions:
	; Copy angle (this -> relatedObj2)
	ld a,Object.angle		; $6308
	call objectGetRelatedObject2Var		; $630a
	ld e,Item.angle		; $630d
	ld a,(de)		; $630f
	ld (hl),a		; $6310

	; Copy collisionRadius (relatedObj2 -> this)
	ld a,l			; $6311
	add Object.collisionRadiusY-Object.angle			; $6312
	ld l,a			; $6314
	ld e,Item.collisionRadiusY		; $6315
	ldi a,(hl)		; $6317
	ld (de),a		; $6318
	inc e			; $6319
	ldi a,(hl)		; $631a
	ld (de),a		; $631b

	; Enable collisions (on this)
	ld h,d			; $631c
	ld l,Item.collisionType		; $631d
	set 7,(hl)		; $631f

@throwItem:
	call _itemBeginThrow		; $6321
	ld h,d			; $6324
	ld l,Item.state		; $6325
	ld (hl),$03		; $6327
	inc l			; $6329
	ld (hl),$00		; $632a


; State 3: being thrown
@state3:
	call _braceletCheckDeleteSelfWhileThrowing		; $632c
	call _itemUpdateThrowingLaterally		; $632f
.ifdef ROM_AGES
	jr z,@@destroyWithAnimation	; $6332
.else
	jr z,@@preDestroyWithAnimation	; $6332
.endif

	ld e,Item.var39		; $6334
	ld a,(de)		; $6336
	ld c,a			; $6337
	call _itemUpdateThrowingVertically		; $6338
	jr nc,@@noCollision	; $633b

	; If it's breakable, destroy it; if not, let it bounce
	call _braceletCheckBreakable		; $633d

.ifdef ROM_AGES
	jr nz,@@destroyWithAnimation	; $6340
.else
	jr nz,@@preDestroyWithAnimation	; $60c2
	jr nc,+			; $60c4
	call objectReplaceWithAnimationIfOnHazard		; $60c6
	ret c			; $60c9
+
.endif

	call _itemBounce		; $6342
	jr c,@@release		; $6345

@@noCollision:
	; If this is not a breakable tile, copy this object's position to relatedObj2.
	ld e,Item.subid		; $6347
	ld a,(de)		; $6349
	or a			; $634a
	ret nz			; $634b
	ld a,Object.yh		; $634c
	call objectGetRelatedObject2Var		; $634e
	jp objectCopyPosition		; $6351

@@release:
.ifdef ROM_SEASONS
	ld e,$02		; $60dc
	ld a,(de)		; $60de
	cp $d7			; $60df
	jr z,@@createPuff	; $60e1
.endif

	ld a,Object.state2		; $6354
	call objectGetRelatedObject2Var		; $6356
	ld (hl),$03		; $6359
	jp itemDelete		; $635b

.ifdef ROM_SEASONS
@@preDestroyWithAnimation:
	ld e,Item.subid		; $60ed
	ld a,(de)		; $60ef
	cp $d7			; $60f0
	jr nz,@@destroyWithAnimation	; $60f2
@@createPuff:
	call objectCreatePuff		; $60f4
	jp itemDelete		; $60f7
.endif

@@destroyWithAnimation:
	call objectReplaceWithAnimationIfOnHazard		; $635e
	ret c			; $6361
	callab bank6.itemMakeInteractionForBreakableTile		; $6362
	jp itemDelete		; $636a

;;
; @param[out] zflag Set if Item.subid is zero
; @param[out] cflag Inverse of zflag?
; @addr{636d}
_braceletCheckBreakable:
	ld e,Item.subid		; $636d
	ld a,(de)		; $636f
	or a			; $6370
	ret z			; $6371
.ifdef ROM_SEASONS
	cp $d7			; $610e
.endif
	scf			; $6372
	ret			; $6373

;;
; Called each frame an item's being thrown. Returns from caller if it decides to delete
; itself.
;
; @param[out]	hl	relatedObj2.state2 or this.state2
; @addr{6374}
_braceletCheckDeleteSelfWhileThrowing:
	ld e,Item.subid		; $6374
	ld a,(de)		; $6376
	or a			; $6377
	jr nz,@throwingTile		; $6378

	lda Item.enabled			; $637a
	call objectGetRelatedObject2Var		; $637b
	bit 0,(hl)		; $637e
	jr z,@deleteSelfAndRetFromCaller	; $6380

	; Delete self unless related object is on state 2, substate 0/1/2 (being held by
	; Link or just released)
	ld a,l			; $6382
	add Object.state-Object.enabled			; $6383
	ld l,a			; $6385
	ldi a,(hl)		; $6386
	cp $02			; $6387
	jr nz,@deleteSelfAndRetFromCaller	; $6389
	ld a,(hl)		; $638b
	cp $03			; $638c
	ret c			; $638e

@deleteSelfAndRetFromCaller:
	pop af			; $638f
	jp itemDelete		; $6390

@throwingTile:
	call objectCheckWithinRoomBoundary		; $6393
	jr nc,@deleteSelfAndRetFromCaller	; $6396
	ld h,d			; $6398
	ld l,Item.state2		; $6399
	ret			; $639b

;;
; Called every frame a bomb is being thrown. Also used by somaria block?
;
; @addr{639c}
_bombUpdateThrowingLaterally:
	; If it's landed in water, set speed to 0 (for sidescrolling areas)
	ld h,d			; $639c
	ld l,Item.var3b		; $639d
	bit 0,(hl)		; $639f
	jr z,+			; $63a1
	ld l,Item.speed		; $63a3
	ld (hl),$00		; $63a5
+
	; If this is the start of the throw, initialize speed variables
	ld l,Item.var37		; $63a7
	bit 0,(hl)		; $63a9
	call z,_itemBeginThrow		; $63ab

	; Check for collisions with walls, update position.
	jp _itemUpdateThrowingLaterally		; $63ae

;;
; Items call this once on the frame they're thrown
;
; @addr{63b1}
_itemBeginThrow:
	call _itemSetVar3cToFF		; $63b1

	; Move the item one pixel in Link's facing direction
	ld a,(w1Link.direction)		; $63b4
	ld hl,@throwOffsets		; $63b7
	rst_addAToHl			; $63ba
	ldi a,(hl)		; $63bb
	ld c,(hl)		; $63bc

	ld h,d			; $63bd
	ld l,Item.yh		; $63be
	add (hl)		; $63c0
	ldi (hl),a		; $63c1
	inc l			; $63c2
	ld a,(hl)		; $63c3
	add c			; $63c4
	ld (hl),a		; $63c5

	ld l,Item.enabled		; $63c6
	res 1,(hl)		; $63c8

	; Mark as thrown?
	ld l,Item.var37		; $63ca
	set 0,(hl)		; $63cc

	; Item.var38 contains "weight" information (how the object will be thrown)
	inc l			; $63ce
	ld a,(hl)		; $63cf
	and $f0			; $63d0
	swap a			; $63d2
	add a			; $63d4
	ld hl,_itemWeights		; $63d5
	rst_addDoubleIndex			; $63d8

	; Byte 0 from hl: value for Item.var39 (gravity)
	ldi a,(hl)		; $63d9
	ld e,Item.var39		; $63da
	ld (de),a		; $63dc

	; If angle is $ff (motionless), skip the rest.
	ld e,Item.angle		; $63dd
	ld a,(de)		; $63df
	rlca			; $63e0
	jr c,@clearItemSpeed	; $63e1

	; Byte 1: Value for Item.speedZ (8-bit, high byte is $ff)
	ld e,Item.speedZ		; $63e3
	ldi a,(hl)		; $63e5
	ld (de),a		; $63e6
	inc e			; $63e7
	ld a,$ff		; $63e8
	ld (de),a		; $63ea

	; Bytes 2,3: Throw speed with and without toss ring, respectively
	ld a,TOSS_RING		; $63eb
	call cpActiveRing		; $63ed
	jr nz,+			; $63f0
	inc hl			; $63f2
+
	ld e,Item.speed		; $63f3
	ldi a,(hl)		; $63f5
	ld (de),a		; $63f6
	ret			; $63f7

@clearItemSpeed:
	ld h,d			; $63f8
	ld l,Item.speed		; $63f9
	xor a			; $63fb
	ld (hl),a		; $63fc
	ld l,Item.speedZ		; $63fd
	ldi (hl),a		; $63ff
	ldi (hl),a		; $6400
	ret			; $6401

; Offsets to move the item when it's thrown.
; Each direction value reads 2 of these, one for Y and one for X.
@throwOffsets:
	.db $ff
	.db $00
	.db $01
	.db $00
	.db $ff

;;
; Checks whether a throwable item has collided with a wall; if not, this updates its
; position.
;
; Called by throwable items each frame. See also "_itemUpdateThrowingVertically".
;
; @param[out]	zflag	Set if the item should break.
; @addr{6407}
_itemUpdateThrowingLaterally:
	ld e,Item.var38		; $6407
	ld a,(de)		; $6409

	; Check whether the "weight" value for the item equals 3?
	cp $40			; $640a
	jr nc,+			; $640c
.ifdef ROM_AGES
	cp $30			; $640e
.else
	cp $20			; $640e
.endif
	jr nc,@weight3		; $6410
+
	; Return if not moving
	ld e,Item.angle		; $6412
	ld a,(de)		; $6414
	cp $ff			; $6415
	jr z,@unsetZFlag	; $6417

	and $18			; $6419
	rrca			; $641b
	rrca			; $641c
	ld hl,_bombEdgeOffsets		; $641d
	rst_addAToHl			; $6420
	ldi a,(hl)		; $6421
	ld c,(hl)		; $6422

	; Load y position into b, jump if beyond room boundary.
	ld h,d			; $6423
	ld l,Item.yh		; $6424
	add (hl)		; $6426
	cp (LARGE_ROOM_HEIGHT*$10)			; $6427
	jr nc,@noCollision	; $6429

	ld b,a			; $642b
	ld l,Item.xh		; $642c
	ld a,c			; $642e
	add (hl)		; $642f
	ld c,a			; $6430

	call checkTileCollisionAt_allowHoles		; $6431
	jr nc,@noCollision	; $6434
	call _itemCheckCanPassSolidTileAt		; $6436
	jr z,@noCollision	; $6439
	jr @collision		; $643b

; This is probably a specific item with different dimensions than other throwable stuff
@weight3:
	ld h,d			; $643d
	ld l,Item.yh		; $643e
	ld b,(hl)		; $6440
	ld l,Item.xh		; $6441
	ld c,(hl)		; $6443

	ld e,Item.angle		; $6444
	ld a,(de)		; $6446
	and $18			; $6447
	ld hl,_data_649a		; $6449
	rst_addAToHl			; $644c

	; Loop 4 times, once for each corner of the object?
	ld e,$04		; $644d
--
	push bc			; $644f
	ldi a,(hl)		; $6450
	add b			; $6451
	ld b,a			; $6452
	ldi a,(hl)		; $6453
	add c			; $6454
	ld c,a			; $6455
	push hl			; $6456
	call checkTileCollisionAt_allowHoles		; $6457
	pop hl			; $645a
	pop bc			; $645b
	jr c,@collision	; $645c
	dec e			; $645e
	jr nz,--		; $645f
	jr @noCollision		; $6461

@collision:
	; Check if this is a breakable object (based on a tile that was picked up)?
	call _braceletCheckBreakable		; $6463
	jr nz,@setZFlag	; $6466

	; Clear angle, which will also set speed to 0
	ld e,Item.angle		; $6468
	ld a,$ff		; $646a
	ld (de),a		; $646c

@noCollision:
	ld a,(wTilesetFlags)		; $646d
	and TILESETFLAG_SIDESCROLL			; $6470
	jr z,+			; $6472

	; If in a sidescrolling area, don't apply speed if moving directly vertically?
	ld e,Item.angle		; $6474
	ld a,(de)		; $6476
	and $0f			; $6477
	jr z,@unsetZFlag	; $6479
+
	call objectApplySpeed		; $647b

@unsetZFlag:
	or d			; $647e
	ret			; $647f

@setZFlag:
	xor a			; $6480
	ret			; $6481

;;
; Called each time a particular item (ie a bomb) lands on a ground. This will cause it to
; bounce a few times before settling, reducing in speed with each bounce.
; @param[out] zflag Set if the item has reached a ground speed of zero.
; @param[out] cflag Set if the item has stopped bouncing.
; @addr{6482}
_itemBounce:
	ld a,SND_BOMB_LAND		; $6482
	call playSound		; $6484

	; Invert and reduce vertical speed
	call objectNegateAndHalveSpeedZ		; $6487
	ret c			; $648a

	; Reduce regular speed
	ld e,Item.speed		; $648b
	ld a,(de)		; $648d
	ld e,a			; $648e
	ld hl,_bounceSpeedReductionMapping		; $648f
	call lookupKey		; $6492
	ld e,Item.speed		; $6495
	ld (de),a		; $6497
	or a			; $6498
	ret			; $6499

; This seems to list the offsets of the 4 corners of a particular object, to be used for
; collision calculations.
; Somewhat similar to "_bombEdgeOffsets", except that is only used to check for collisions
; in the direction it's moving in, whereas this seems to cover the entire object.
_data_649a:
	.db $00 $00 $fa $fa $fa $00 $fa $05 ; DIR_UP
	.db $00 $00 $fa $05 $00 $05 $05 $05 ; DIR_RIGHT
	.db $00 $00 $05 $fb $05 $00 $05 $05 ; DIR_DOWN
	.db $00 $00 $fa $fa $00 $fa $06 $fa ; DIR_LEFT

; b0: Value to write to Item.var39 (gravity).
; b1: Low byte of Z speed to give the object (high byte will be $ff)
; b2: Throw speed without toss ring
; b3: Throw speed with toss ring
_itemWeights:
	.db $1c $10 SPEED_180 SPEED_280
	.db $20 $00 SPEED_080 SPEED_100
.ifdef ROM_AGES
	.db $28 $20 SPEED_1a0 SPEED_280
	.db $20 $00 SPEED_080 SPEED_100
.else
	.db $20 $00 SPEED_100 SPEED_180
	.db $20 $00 SPEED_0c0 SPEED_100
.endif
	.db $20 $e0 SPEED_140 SPEED_180
	.db $20 $00 SPEED_080 SPEED_100

; A series of key-value pairs where the key is a bouncing object's current speed, and the
; value is the object's new speed after one bounce.
; This returns roughly half the value of the key.
; @addr{64d2}
_bounceSpeedReductionMapping:
	.db SPEED_020 SPEED_000
	.db SPEED_040 SPEED_020
	.db SPEED_060 SPEED_020
	.db SPEED_080 SPEED_040
	.db SPEED_0a0 SPEED_040
	.db SPEED_0c0 SPEED_060
	.db SPEED_0e0 SPEED_060
	.db SPEED_100 SPEED_080
	.db SPEED_120 SPEED_080
	.db SPEED_140 SPEED_0a0
	.db SPEED_160 SPEED_0a0
	.db SPEED_180 SPEED_0c0
	.db SPEED_1a0 SPEED_0c0
	.db SPEED_1c0 SPEED_0e0
	.db SPEED_1e0 SPEED_0e0
	.db SPEED_200 SPEED_100
	.db SPEED_220 SPEED_100
	.db SPEED_240 SPEED_120
	.db SPEED_260 SPEED_120
	.db SPEED_280 SPEED_140
	.db SPEED_2a0 SPEED_140
	.db SPEED_2c0 SPEED_160
	.db SPEED_2e0 SPEED_160
	.db SPEED_300 SPEED_180
	.db $00 $00

;;
; ITEMID_DUST
; @addr{6504}
itemCode1a:
	ld e,Item.state2		; $6504
	ld a,(de)		; $6506
	rst_jumpTable			; $6507
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call _itemLoadAttributesAndGraphics		; $650e
	call itemIncState2		; $6511
	ld hl,w1Link.yh		; $6514
	call objectTakePosition		; $6517
	xor a			; $651a
	call itemSetAnimation		; $651b
	jp objectSetVisible80		; $651e


; Substate 1: initial dust cloud above Link (lasts less than a second)
@substate1:
	call itemAnimate		; $6521
	call @setOamTileIndexBaseFromAnimParameter		; $6524

	; Mess with Item.oamFlags and Item.oamFlagsBackup
	ld a,(hl)		; $6527
	inc a			; $6528
	and $fb			; $6529
	xor $60			; $652b
	ldd (hl),a		; $652d
	ld (hl),a		; $652e

	; If bit 7 of animParameter was set, go to state 2
	bit 7,b			; $652f
	ret z			; $6531

	; [Item.oamFlags] = [Item.oamFlagsBackup] = $0b
	ld a,$0b		; $6532
	ldi (hl),a		; $6534
	ld (hl),a		; $6535

	ld l,Item.z		; $6536
	xor a			; $6538
	ldi (hl),a		; $6539
	ld (hl),a		; $653a

	call objectSetInvisible		; $653b
	jp itemIncState2		; $653e


; Substate 2: dust by Link's feet (spends the majority of time in this state)
@substate2:
	call checkPegasusSeedCounter		; $6541
	jp z,itemDelete		; $6544

	call @initializeNextDustCloud		; $6547

	; Each frame, alternate between two dust cloud positions, with corresponding
	; variables stored at var30-var33 and var34-var37.
	call itemDecCounter1		; $654a
	bit 0,(hl)		; $654d
	ld l,Item.var30		; $654f
	jr z,+			; $6551
	ld l,Item.var34		; $6553
+
	bit 7,(hl)		; $6555
	jp z,objectSetInvisible		; $6557

	; Inc var30/var34 (acts as a counter)
	inc (hl)		; $655a
	ld a,(hl)		; $655b
	cp $82			; $655c
	jr c,++			; $655e

	; Reset the counter, increment var31/var35 (which controls the animation)
	ld (hl),$80		; $6560
	inc l			; $6562
	inc (hl)		; $6563
	ld a,(hl)		; $6564
	dec l			; $6565
	cp $03			; $6566
	jr nc,@clearDustCloudVariables	; $6568
++
	; c = [var31/var35]+1
	inc l			; $656a
	ldi a,(hl)		; $656b
	inc a			; $656c
	ld c,a			; $656d

	; [Item.yh] = [var32/var36], [Item.xh] = [var33/var37]
	ldi a,(hl)		; $656e
	ld e,Item.yh		; $656f
	ld (de),a		; $6571
	ldi a,(hl)		; $6572
	ld e,Item.xh		; $6573
	ld (de),a		; $6575

	; Load the animation (corresponding to [var31/var35])
	ld a,c			; $6576
	call itemSetAnimation		; $6577
	call objectSetVisible80		; $657a

;;
; @param[out]	b	[Item.animParameter]
; @param[out]	hl	Item.oamFlags
; @addr{657d}
@setOamTileIndexBaseFromAnimParameter:
	ld h,d			; $657d
	ld l,Item.animParameter		; $657e
	ld a,(hl)		; $6580
	ld b,a			; $6581
	and $7f			; $6582
	ld l,Item.oamTileIndexBase		; $6584
	ldd (hl),a		; $6586
	ret			; $6587

;;
; Clears one of the "slots" for the dust cloud objects.
; @addr{6588}
@clearDustCloudVariables:
	xor a			; $6588
	ldi (hl),a		; $6589
	ldi (hl),a		; $658a
	ldi (hl),a		; $658b
	ldi (hl),a		; $658c
	jp objectSetInvisible		; $658d

;;
; Initializes a dust cloud if one of the two slots are blank
;
; @addr{6590}
@initializeNextDustCloud:
	ld h,d			; $6590
	ld l,Item.subid		; $6591
	bit 0,(hl)		; $6593
	ret z			; $6595

	ld (hl),$00		; $6596

	ld l,Item.var30		; $6598
	bit 7,(hl)		; $659a
	jr z,+			; $659c
	ld l,Item.var34		; $659e
	bit 7,(hl)		; $65a0
	ret nz			; $65a2
+
	ld a,$80		; $65a3
	ldi (hl),a		; $65a5
	xor a			; $65a6
	ldi (hl),a		; $65a7
	ld a,(w1Link.yh)		; $65a8
	add $05			; $65ab
	ldi (hl),a		; $65ad
	ld a,(w1Link.xh)		; $65ae
	ld (hl),a		; $65b1
	ret			; $65b2
