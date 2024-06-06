; ==============================================================================
; ENEMYID_BARI
;
; Variables:
;   var30/var31: Initial Y/X position (aka target position; they always hover around this
;                area. For subid 0 (large baris) only.)
;   var32: Counter for "bobbing" of Z position
; ==============================================================================
enemyCode3c:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback

	; ENEMYSTATUS_JUST_HIT
	; The bari should be split in two if it's subid 0, and the right kind of collision
	; occurred, while it's not in its "shocking" state.

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_GALE_SEED
	jr z,@normalStatus

	ld e,Enemy.health
	ld a,(de)
	or a
	ret z

	ld e,Enemy.subid
	ld a,(de)
	or a
	jr nz,@normalStatus

	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_BARI_ELECTRIC_SHOCK
	jr z,@normalStatus

	; FIXME: This checks if collisionType is strictly less than L3 shield, which is
	; odd? Does that mean the mirror shield would cause the bari to split? Though it
	; shouldn't matter anyway, shields can't be used underwater...
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_L3_SHIELD
	jr c,@normalStatus

	ld h,d
	ld l,Enemy.state
	ld (hl),$0a

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,@commonState

	call bari_updateZPosition
	ld e,Enemy.state
	ld a,b
	or a
	jp z,bari_subid0
	jp bari_subid1

@commonState:
	ld a,(de)
	rst_jumpTable
	.dw bari_state_uninitialized
	.dw bari_state_stub
	.dw bari_state_stub
	.dw bari_state_stub
	.dw bari_state_stub
	.dw ecom_blownByGaleSeedState
	.dw bari_state_stub
	.dw bari_state_stub


bari_state_uninitialized:
	ld a,SPEED_60
	call ecom_setSpeedAndState8AndVisible

	ld l,Enemy.counter1
	ld (hl),$04

	ld l,Enemy.zh
	ld (hl),$fc

	; Copy Y/X to var30/var31
	ld e,Enemy.yh
	ld l,Enemy.var30
	ld a,(de)
	ldi (hl),a
	ld e,Enemy.xh
	ld a,(de)
	ld (hl),a

	call getRandomNumber_noPreserveVars
	ld e,Enemy.var32
	ld (de),a

	ld e,Enemy.subid
	ld a,(de)
	or a
	jp z,bari_setRandomAngleAndCounter2

	; Subid 1 only
	ld e,Enemy.speed
	ld a,SPEED_40
	ld (de),a
	ld a,$02
	jp enemySetAnimation


bari_state_stub:
	ret


bari_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw bari_subid0_state8
	.dw bari_state9
	.dw bari_subid0_stateA


; "Non-electric-shock" state
bari_subid0_state8:
	call ecom_decCounter2
	jr nz,@dontShockYet

	; Begin electric shock
	ld (hl),60 ; [counter2]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BARI_ELECTRIC_SHOCK

	ld a,$01
	jp enemySetAnimation

@dontShockYet:
	call ecom_decCounter1
	jr nz,bari_applySpeed

	call getRandomNumber
	and $0e
	add $02
	ld (hl),a ; [counter1]

	; Nudge angle towards target position (original position)
	ld l,Enemy.var30
	call ecom_readPositionVars
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards

bari_applySpeed:
	call objectApplySpeed
	call ecom_bounceOffScreenBoundary

bari_animate:
	jp enemyAnimate


; In its "electric shock" state. This is shared between subids 0 and 1 (large and small).
bari_state9:
	call ecom_decCounter2
	jr nz,bari_animate

	; Stop the shock
	ld l,e
	dec (hl) ; [state] = 8

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BARI

	dec l
	set 7,(hl) ; [collisionType]

	xor a
	call enemySetAnimation


;;
bari_setRandomAngleAndCounter2:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter2Vals
	rst_addAToHl
	ld e,Enemy.counter2
	ld a,(hl)
	ld (de),a
	jp ecom_setRandomAngle

@counter2Vals:
	.db 60 90 120 150


; Bari has just been attacked; now it's splitting in two.
bari_subid0_stateA:
	inc e
	ld a,(de) ; [substate]
	or a
	jr z,@substate0

@substate1:
	call ecom_decCounter2
	ret nz

	; Spawn the two small baris, then delete self.
	call ecom_updateAngleTowardTarget
	ld c,$04
	call @spawnSmallBari
	ld c,$fc
	call @spawnSmallBari
	call decNumEnemies
	jp enemyDelete

;;
; @param	c	X-offset (and value to add to angle)
@spawnSmallBari:
	ld b,ENEMYID_BARI
	call ecom_spawnEnemyWithSubid01
	ret nz

	; Copy "enemy index" value
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	ld l,Enemy.angle
	ld e,l
	ld a,(de)
	add c
	and $1f
	ld (hl),a

	ld b,$00
	jp objectCopyPositionWithOffset

@substate0:
	ld b,INTERACID_KILLENEMYPUFF
	call objectCreateInteractionWithSubid00

	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.counter2
	ld (hl),$04

	ld l,Enemy.substate
	inc (hl)

	ld a,SND_KILLENEMY
	call playSound
	jp objectSetInvisible


; A small bari.
bari_subid1:
	ld a,(de)
	sub $08
	jp nz,bari_state9

@state8:
	call ecom_decCounter1
	jp nz,bari_applySpeed

	; Randomly choose counter1 value
	call getRandomNumber
	and $1c
	inc a
	ld (hl),a

	; Adjust angle toward Link
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
	jp bari_applySpeed


;;
; Bobs up and down
bari_updateZPosition:
	ld h,d
	ld l,Enemy.var32
	dec (hl)
	ld a,(hl)
	and $30
	swap a
	ld hl,@zVals
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(hl)
	ld (de),a
	ret

@zVals:
	.db $fc $fd $fe $fd


; ==============================================================================
; ENEMYID_GIANT_GHINI_CHILD
; ==============================================================================
enemyCode3f:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackNoSolidity

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jr nz,@normalStatus

	; Attach self to Link
	ld h,d
	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.counter1
	ld (hl),120

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.zh
	ld (hl),$00

	; Signal parent to charge at Link
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var32
	ld (hl),$01

	jr @normalStatus

@dead:
	; Decrement parent's "child counter" before deleting self
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.var30
	dec (hl)
	jp enemyDie

@normalStatus:
	; Die if parent is dead
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.health
	ld a,(hl)
	or a
	jr z,@dead

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw giantGhiniChild_state_uninitialized
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state8
	.dw giantGhiniChild_state9
	.dw giantGhiniChild_stateA
	.dw giantGhiniChild_stateB
	.dw giantGhiniChild_stateC


giantGhiniChild_state_stub:
	ret


giantGhiniChild_state_uninitialized:
	; Determine spawn offset based on subid
	ld e,Enemy.subid
	ld a,(de)
	and $7f
	dec a
	ld hl,giantGhiniChild_spawnOffsets
	rst_addDoubleIndex
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld (de),a
	inc hl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld (de),a

	ld a,SPEED_c0
	call ecom_setSpeedAndState8
	ld l,Enemy.zh
	ld (hl),$fc

	ld l,Enemy.subid
	ld a,(hl)
	rlca
	ret c

	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.counter1
	ld (hl),30
	call objectSetVisiblec1
	jp objectCreatePuff


; Waiting for battle to start
giantGhiniChild_state8:
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.state
	ld a,(hl)
	cp $09
	jr c,@battleNotStartedYet

	call giantGhiniChild_gotoStateA
	jp objectSetVisiblec1

@battleNotStartedYet:
	; Enable shadows
	ld l,Enemy.visible
	ld e,l
	ld a,(hl)
	or $40
	ld (de),a
	ret


; Just spawned in, will charge after [counter1] frames
giantGhiniChild_state9:
	call ecom_decCounter1
	ret nz

giantGhiniChild_gotoStateA:
	ld e,Enemy.state
	ld a,$0a
	ld (de),a
	ld e,Enemy.counter1
	ld a,$05
	ld (de),a

	call objectGetAngleTowardLink
	ld e,Enemy.angle
	ld (de),a
	ret


; Charging at Link
giantGhiniChild_stateA:
	call enemyAnimate
	call objectApplySpeed
	call ecom_decCounter1
	ret nz

	ld (hl),$05 ; [counter1]
	call objectGetAngleTowardLink
	jp objectNudgeAngleTowards


; Attached to Link
giantGhiniChild_stateB:
	call enemyAnimate

	ld a,(w1Link.yh)
	ld e,Enemy.yh
	ld (de),a
	ld a,(w1Link.xh)
	ld e,Enemy.xh
	ld (de),a

	call ecom_decCounter1
	jr z,@detach

	; Decrement counter more if pressing buttons
	ld a,(wGameKeysJustPressed)
	or a
	jr z,++
	ld a,(hl)
	sub BTN_A|BTN_B
	jr nc,+
	ld a,$01
+
	ld (hl),a
++
	; Adjust visibility
	ld a,(hl)
	and $03
	jr nz,++
	ld l,Enemy.visible
	ld a,(hl)
	xor $80
	ld (hl),a
++
	; Make Link slow, disable item use
	ld hl,wccd8
	set 5,(hl)
	ld a,(wFrameCounter)
	rrca
	ret nc
	ld hl,wLinkImmobilized
	set 5,(hl)
	ret

@detach:
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.counter1
	ld (hl),60

	; Cancel parent charging (or at least he won't adjust his angle anymore)
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var32
	ld (hl),$00
	ret


; Just detached from Link, fading away
giantGhiniChild_stateC:
	call enemyAnimate
	ld e,Enemy.visible
	ld a,(de)
	xor $80
	ld (de),a

	call ecom_decCounter1
	ret nz

	; Decrement parent's "child counter"
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.var30
	dec (hl)
	call decNumEnemies
	jp enemyDelete


giantGhiniChild_spawnOffsets:
	.db  $00, -$18
	.db -$18,  $00
	.db  $00,  $18


; ==============================================================================
; ENEMYID_SHADOW_HAG_BUG
;
; Variables:
;   counter2: Lifetime counter
; ==============================================================================
enemyCode42:
	jr z,++
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ret

@dead:
	; Decrement parent object's "bug count"
	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
	jp enemyDie_uncounted
++
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw shadowHagBug_state_uninitialized
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_galeSeed
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state_stub
	.dw shadowHagBug_state8
	.dw shadowHagBug_state9


shadowHagBug_state_uninitialized:
	ld a,SPEED_60
	call ecom_setSpeedAndState8

	ld l,Enemy.speedZ
	ld a,<(-$e0)
	ldi (hl),a
	ld (hl),>(-$e0)

	call getRandomNumber_noPreserveVars
	and $1f
	ld e,Enemy.angle
	ld (de),a
	jp objectSetVisible82


shadowHagBug_state_galeSeed:
	call ecom_galeSeedEffect
	ret c
	jp enemyDelete


shadowHagBug_state_stub:
	ret


shadowHagBug_state8:
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jr nz,shadowHagBug_applySpeedAndAnimate

	ld l,Enemy.state
	inc (hl)

	call getRandomNumber
	ld l,Enemy.counter1
	ldi (hl),a
	ld (hl),180 ; [counter2]


shadowHagBug_state9:
	call ecom_decCounter2
	jr z,shadowHagBug_delete

	ld a,(hl)
	cp 30
	call c,ecom_flickerVisibility

	dec l
	dec (hl) ; [counter1]
	ld a,(hl)
	and $07
	jr nz,shadowHagBug_applySpeedAndAnimate

	; Choose a random position within link's 16x16 square
	ld bc,$0f0f
	call ecom_randomBitwiseAndBCE
	ldh a,(<hEnemyTargetY)
	add b
	sub $08
	ld b,a
	ldh a,(<hEnemyTargetX)
	add c
	sub $08
	ld c,a

	; Nudge angle toward chosen position
	ld e,Enemy.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Enemy.xh
	ld a,(de)
	ldh (<hFF8E),a
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards

shadowHagBug_applySpeedAndAnimate:
	call objectApplySpeed
	jp enemyAnimate

shadowHagBug_delete:
	; Decrement parent's "bug count"
	ld a,Object.var30
	call objectGetRelatedObject1Var
	dec (hl)
	jp enemyDelete


; ==============================================================================
; ENEMYID_COLOR_CHANGING_GEL
;
; Variables:
;   var30/var31: Target position while hopping
;   var32: Tile index at current position (purposely outdated so there's lag in updating
;          the color)
; ==============================================================================
enemyCode47:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	; ENEMYSTATUS_JUST_HIT

	ld h,d
	ld l,Enemy.var2a
	ld a,(hl)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jr nz,@attacked

	; Mystery seed hit the gel
	call colorChangingGel_chooseRandomColor
	jr @normalStatus

@attacked:
	; Ignore all attacks if color matches floor
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_COLOR_CHANGING_GEL
	jr nz,@normalStatus

	; Only allow switch hook and sword attacks to kill the gel
	ldi a,(hl)
	res 7,a
	cp ITEMCOLLISION_SWITCH_HOOK
	jr z,@wasDamagingAttack
	sub ITEMCOLLISION_L1_SWORD
	cp ITEMCOLLISION_SWORD_HELD-ITEMCOLLISION_L1_SWORD + 1
	jr nc,@normalStatus

@wasDamagingAttack
	ld (hl),$f4 ; [invincibilityCounter] = $f4
	ld a,SND_DAMAGE_ENEMY
	call playSound

@normalStatus:
	call colorChangingGel_updateColor
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw colorChangingGel_state_uninitialized
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state_stub
	.dw ecom_blownByGaleSeedState
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state8
	.dw colorChangingGel_state9
	.dw colorChangingGel_stateA


colorChangingGel_state_uninitialized:
	ld a,SPEED_140
	call ecom_setSpeedAndState8AndVisible

	ld l,Enemy.counter1
	ld (hl),150
	inc l
	ld (hl),$00 ; [counter2]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_COLOR_CHANGING_GEL

	ld l,Enemy.var3f
	set 5,(hl)

	call objectGetTileAtPosition
	ld e,Enemy.var32
	ld (de),a

	ld a,PALH_bf
	call loadPaletteHeader
	ld a,$03
	jp enemySetAnimation


colorChangingGel_state_stub:
	ret


; Standing still for [counter1] frames
colorChangingGel_state8:
	call ecom_decCounter1
	ret nz

	inc (hl) ; [counter1] = 1

	; Choose random direction to jump
	call getRandomNumber_noPreserveVars
	and $0e
	ld hl,@directionsToJump
	rst_addAToHl

	; Store target position in var30/var31
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld e,Enemy.var30
	ld (de),a
	ld b,a

	ld e,Enemy.xh
	ld a,(de)
	inc hl
	add (hl)
	ld e,Enemy.var31
	ld (de),a
	ld c,a

	; Target position must not be solid (if it is, try again next frame)
	call getTileCollisionsAtPosition
	ret nz

	call ecom_incState

	ld l,Enemy.counter1
	ld (hl),60

	ld l,Enemy.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)

	ld a,$02
	jp enemySetAnimation

@directionsToJump:
	.db $f0 $f0
	.db $f0 $00
	.db $f0 $10
	.db $00 $f0
	.db $00 $10
	.db $10 $f0
	.db $10 $00
	.db $10 $10


; Waiting [counter1] frames before hopping to target position
colorChangingGel_state9:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [state]

	; Calculate angle to jump in
	ld h,d
	ld l,Enemy.var30
	call ecom_readPositionVars
	call objectGetRelativeAngleWithTempVars
	and $10
	swap a
	jp enemySetAnimation


; Hopping to target
colorChangingGel_stateA:
	ld c,$30
	call objectUpdateSpeedZ_paramC
	jr nz,@stillInAir

	; Landed
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.counter1
	ld (hl),150

	call objectCenterOnTile

	ld a,$03
	jp enemySetAnimation

@stillInAir:
	; Move toward position if we're not there yet already (ignoring Z position)
	ld l,Enemy.var30
	call ecom_readPositionVars
	sub c
	inc a
	cp $03
	jr nc,++
	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	ret c
++
	jp ecom_moveTowardPosition


;;
; Updates the gel's color with intentional lag. Every 90 frames, this uses the value of
; var32 (tile index) to set the gel's color, then it updates the value of var32. Due to
; the order this is done in, it takes 180 frames for the color to update fully.
colorChangingGel_updateColor:
	; Must be on ground
	ld e,Enemy.zh
	ld a,(de)
	rlca
	ret c

	; Wait for cooldown
	call ecom_decCounter2
	jr z,@updateStoredColor

	; If [counter2] == 1, update color
	ld a,(hl)
	dec a
	jr z,@updateColor

	pop bc
	jr @updateImmunity

@updateColor:
	; Update color based on tile index stored in var32 (which may be outdated).
	ld e,Enemy.var32
	ld a,(de)
	call @lookupFloorColor
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]

@updateStoredColor:
	call @updateImmunity
	ret z

	pop bc
	ld l,Enemy.counter2
	ld (hl),90

	; Write tile index to var32?
	ld l,Enemy.var32
	ld (hl),e
	ret

;;
; Sets enemyCollisionMode depending on whether the gel's color matches the floor or not.
;
; @param[out]	zflag	z if immune
@updateImmunity:
	call objectGetTileAtPosition
	cp TILEINDEX_SOMARIA_BLOCK
	ret z

	call @lookupFloorColor
	cp (hl)
	ld b,ENEMYCOLLISION_COLOR_CHANGING_GEL
	jr z,+
	ld b,ENEMYCOLLISION_GOHMA_GEL
+
	ld l,Enemy.enemyCollisionMode
	ld (hl),b
	ret

;;
; @param	a	Tile index
; @param[out]	a	Color (defaults to red ($02) if floor tile not listed)
; @param[out]	hl	Enemy.oamFlagsBackup
@lookupFloorColor:
	ld e,a
	ld hl,@floorColors
	call lookupKey
	ld h,d
	ld l,Enemy.oamFlagsBackup
	ret c
	ld a,$02
	ret

@floorColors:
	.db TILEINDEX_RED_FLOOR,         , $02
	.db TILEINDEX_YELLOW_FLOOR       , $06
	.db TILEINDEX_BLUE_FLOOR         , $01
	.db TILEINDEX_RED_TOGGLE_FLOOR   , $02
	.db TILEINDEX_YELLOW_TOGGLE_FLOOR, $06
	.db TILEINDEX_BLUE_TOGGLE_FLOOR  , $01
	.db $00

;;
; Sets the gel's color to something random that isn't its current color.
colorChangingGel_chooseRandomColor:
	call getRandomNumber_noPreserveVars
	and $01
	ld b,a
	ld e,Enemy.oamFlagsBackup
	ld a,(de)
	res 0,a
	add b
	ld hl,@oamFlagMap
	rst_addAToHl

	ldi a,(hl)
	ld (de),a ; [oamFlagsBackup]
	inc e
	ld (de),a ; [oamFlags]
	ret

@oamFlagMap:
	.db $02 $06 $01 $06 $ff $ff $01 $02


; ==============================================================================
; ENEMYID_AMBI_GUARD
;
; Variables:
;   relatedObj2: PARTID_DETECTION_HELPER; checks when Link is visible.
;   var30-var31: Movement script address
;   var32: Y-destination (reserved by movement script)
;   var33: X-destination (reserved by movement script)
;   var34: Bit 0 set when Link should be noticed; Bit 1 set once the guard has started
;          reacting to Link (shown exclamation mark).
;   var35: Nonzero if just hit with an indirect attack (moves more quickly)
;   var36: While this is nonzero, all "normal code" is ignored. It counts down to zero,
;          and once it's done, it sets var35 to 1 (move more quickly) and normal code
;          resumes. Used for the delay between noticing Link and taking action.
;   var37: Timer until guard "notices" scent seed.
;   var3a: When set to $ff, faces PARTID_DETECTION_HELPER?
;   var3b: When set to $ff, the guard immediately notices Link. (Written to by
;          PARTID_DETECTION_HELPER.)
; ==============================================================================
enemyCode54:
	jr z,@normalStatus	 
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,ambiGuard_noHealth
	dec a
	jp nz,ecom_updateKnockback
	call ambiGuard_collisionOccured

@normalStatus:
	ld e,Enemy.subid
	ld a,(de)
	rlca
	jp c,ambiGuard_attacksLink


; Subids $00-$7f
ambiGuard_tossesLinkOut:
	call ambiGuard_checkSpottedLink
	call ambiGuard_checkAlertTrigger
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw ambiGuard_tossesLinkOut_uninitialized
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_galeSeed
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state8
	.dw ambiGuard_state9
	.dw ambiGuard_stateA
	.dw ambiGuard_stateB
	.dw ambiGuard_stateC
	.dw ambiGuard_stateD
	.dw ambiGuard_stateE
	.dw ambiGuard_tossesLinkOut_stateF
	.dw ambiGuard_tossesLinkOut_state10
	.dw ambiGuard_tossesLinkOut_state11


ambiGuard_tossesLinkOut_uninitialized:
	ld hl,ambiGuard_tossesLinkOut_scriptTable
	call objectLoadMovementScript

	call ambiGuard_commonInitialization
	ret nz

	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation


; NOTE: Guards don't seem to react to gale seeds? Is this unused?
ambiGuard_state_galeSeed:
	call ecom_galeSeedEffect
	ret c

	ld e,Enemy.var34
	ld a,(de)
	or a
	ld e,Enemy.var35
	call z,ambiGuard_alertAllGuards
	call decNumEnemies
	jp enemyDelete


ambiGuard_state_stub:
	ret


; Moving up
ambiGuard_state8:
	ld e,Enemy.var32
	ld a,(de)
	ld h,d
	ld l,Enemy.yh
	cp (hl)
	jr nc,@reachedDestination
	call objectApplySpeed
	jr ambiGuard_animate

@reachedDestination:
	ld a,(de)
	ld (hl),a
	jp ambiGuard_runMovementScript


; Moving right
ambiGuard_state9:
	ld e,Enemy.xh
	ld a,(de)
	ld h,d
	ld l,Enemy.var33
	cp (hl)
	jr nc,@reachedDestination
	call objectApplySpeed
	jr ambiGuard_animate

@reachedDestination:
	ld a,(hl)
	ld (de),a
	jp ambiGuard_runMovementScript


; Moving down
ambiGuard_stateA:
	ld e,Enemy.yh
	ld a,(de)
	ld h,d
	ld l,Enemy.var32
	cp (hl)
	jr nc,@reachedDestination
	call objectApplySpeed
	jr ambiGuard_animate

@reachedDestination:
	ld a,(hl)
	ld (de),a
	jp ambiGuard_runMovementScript


; Moving left
ambiGuard_stateB:
	ld e,Enemy.var33
	ld a,(de)
	ld h,d
	ld l,Enemy.xh
	cp (hl)
	jr nc,@reachedDestination
	call objectApplySpeed
	jr ambiGuard_animate

@reachedDestination:
	ld a,(de)
	ld (hl),a
	jp ambiGuard_runMovementScript


; Waiting
ambiGuard_stateC:
ambiGuard_stateE:
	call ecom_decCounter1
	jp z,ambiGuard_runMovementScript

ambiGuard_animate:
	jp enemyAnimate


; Standing in place for [counter1] frames, then turn the other way for 30 frames, then
; resume movemnet
ambiGuard_stateD:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	swap a
	rlca
	jp enemySetAnimation


; Begin moving toward Link after noticing him
ambiGuard_tossesLinkOut_stateF:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),90
	call ambiGuard_turnToFaceLink
	ld a,SND_WHISTLE
	jp playSound


; Moving toward Link until screen fades out and Link gets booted out
ambiGuard_tossesLinkOut_state10:
	call enemyAnimate
	call ecom_decCounter1
	jr z,++
	ld c,$18
	call objectCheckLinkWithinDistance
	jp nc,ecom_applyVelocityForSideviewEnemyNoHoles
++
	ld a,CUTSCENE_BOOTED_FROM_PALACE
	ld (wCutsceneTrigger),a
	ret


ambiGuard_tossesLinkOut_state11:
	ret


ambiGuard_attacksLink:
	call ambiGuard_checkSpottedLink
	call ambiGuard_checkAlertTrigger
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw ambiGuard_attacksLink_state_uninitialized
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_galeSeed
	.dw ambiGuard_state_stub
	.dw ambiGuard_state_stub
	.dw ambiGuard_state8
	.dw ambiGuard_state9
	.dw ambiGuard_stateA
	.dw ambiGuard_stateB
	.dw ambiGuard_stateC
	.dw ambiGuard_stateD
	.dw ambiGuard_stateE
	.dw ambiGuard_attacksLink_stateF
	.dw ambiGuard_attacksLink_state10
	.dw ambiGuard_attacksLink_state11


ambiGuard_attacksLink_state_uninitialized:
	ld h,d
	ld l,Enemy.subid
	res 7,(hl)

	ld hl,ambiGuard_attacksLink_scriptTable
	call objectLoadMovementScript

	ld h,d
	ld l,Enemy.subid
	set 7,(hl)

	call ambiGuard_commonInitialization
	ret nz

	ld e,Enemy.direction
	ld a,(de)
	jp enemySetAnimation


; Just noticed Link
ambiGuard_attacksLink_stateF:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter2
	ld a,(hl)
	or a
	jr nz,+
	ld (hl),60
+
	call ambiGuard_createExclamationMark
	jr ambiGuard_turnToFaceLink


; Looking at Link; counting down until he starts chasing him
ambiGuard_attacksLink_state10:
	call ecom_decCounter2
	jr z,@beginChasing

	ld a,(hl)
	cp 60
	ret nz

	ld a,SND_WHISTLE
	call playSound
	ld e,Enemy.var34
	jp ambiGuard_alertAllGuards

@beginChasing:
	dec l
	ld (hl),20 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_180
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_AMBI_GUARD_CHASING_LINK

;;
ambiGuard_turnToFaceLink:
	call ecom_updateCardinalAngleTowardTarget
	swap a
	rlca
	jp enemySetAnimation


; Currently chasing Link
ambiGuard_attacksLink_state11:
	call ecom_decCounter1
	jr nz,++
	ld (hl),20
	call ambiGuard_turnToFaceLink
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp enemyAnimate

;;
; Deletes self if Veran was defeated, otherwise spawns PARTID_DETECTION_HELPER.
;
; @param[out]	zflag	nz if caller should return immediately (deleted self)
ambiGuard_commonInitialization:
	ld hl,wGroup4Flags+$fc
	bit 7,(hl)
	jr z,++
	call enemyDelete
	or d
	ret
++
	call getFreePartSlot
	jr nz,++
	ld (hl),PARTID_DETECTION_HELPER
	ld l,Part.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld e,Enemy.relatedObj2
	ld a,Part.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld h,d
	ld l,Enemy.direction
	ldi a,(hl)
	swap a
	rrca
	ld (hl),a
	call objectSetVisiblec2
	xor a
	ret
++
	ld e,Enemy.state
	xor a
	ld (de),a
	ret

;;
ambiGuard_runMovementScript:
	call objectRunMovementScript

	; Update animation
	ld e,Enemy.angle
	ld a,(de)
	and $18
	swap a
	rlca
	jp enemySetAnimation

;;
; When var36 is nonzero, this counts it down, then sets var35 to nonzero when var36
; reaches 0. (This alerts the guard to start moving faster.) Also, all other guards
; on-screen will be alerted in this way.
;
; As long as var36 is nonzero, this "returns from caller" (discards return address).
ambiGuard_checkAlertTrigger:
	ld h,d
	ld l,Enemy.var36
	ld a,(hl)
	or a
	ret z

	pop bc ; return from caller

	dec (hl)
	ld a,(hl)
	dec a
	jr nz,@stillCountingDown

	; Check if in a standard movement state
	ld l,Enemy.state
	ld a,(hl)
	sub $08
	cp $04
	ret nc

	; Update angle, animation based on state
	ld b,a
	swap a
	rrca
	ld e,Enemy.angle
	ld (de),a
	ld a,b
	jp enemySetAnimation

@stillCountingDown:
	cp 59
	ret nz

	; NOTE: Why on earth is this sound played? SND_WHISTLE would make more sense...
	ld a,SND_MAKU_TREE_PAST
	call playSound

	; Alert all guards to start moving more quickly
	ld e,Enemy.var35


;;
; @param	de	Variable to set on the guards. "var34" to alert them to Link
;			immediately, "var35" to make them patrol faster.
ambiGuard_alertAllGuards:
	ldhl FIRST_ENEMY_INDEX,Enemy.enabled
---
	ld l,Enemy.id
	ld a,(hl)
	cp ENEMYID_AMBI_GUARD
	jr nz,@nextEnemy

	ld a,h
	cp d
	jr z,@nextEnemy

	ld l,e
	ld a,(hl)
	or a
	jr nz,@nextEnemy

	inc (hl)
	bit 0,l
	jr z,@nextEnemy

	ld l,Enemy.var36
	ld (hl),60
@nextEnemy:
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,---
	ret


;;
; Checks for spotting Link, among other things?
ambiGuard_checkSpottedLink:
	ld a,(wScentSeedActive)
	or a
	jr nz,@scentSeed

@normalCheck:
	; Notice Link if playing the flute.
	; (Doesn't work properly for harp tunes?)
	ld a,(wLinkPlayingInstrument)
	or a
	jr nz,@faceLink

	; if var3a == $ff, turn toward part object?
	ld e,Enemy.var3a
	ld a,(de)
	inc a
	jr nz,@commonUpdate

	ld (de),a ; [var3a] = 0

	ld a,Object.yh
	call objectGetRelatedObject2Var
	ld b,(hl)
	ld l,Object.xh
	ld c,(hl)
	call objectGetRelativeAngle
	jr @alertGuardToMoveFast

@scentSeed:
	; When [var37] == 0, the guard notices the scent seed (turns toward it and has an
	; exclamation point).
	ld h,d
	ld l,Enemy.var37
	ld a,(hl)
	or a
	jr z,@noticedScentSeed

	ld a,(wFrameCounter)
	rrca
	jr c,@normalCheck
	dec (hl)
	jr @normalCheck

@noticedScentSeed:
	; Set the counter to more than the duration of a scent seed, so the guard only
	; turns toward it once...
	ld (hl),150 ; [var37]

@faceLink:
	call objectGetAngleTowardEnemyTarget

@alertGuardToMoveFast:
	; When reaching here, a == angle the guard should face
	ld h,d
	ld l,Enemy.var35
	inc (hl)
	inc l
	ld (hl),60 ; [var36]
	call ambiGuard_setAngle

@commonUpdate:
	; If [var3b] == $ff, notice Link immediately.
	ld h,d
	ld l,Enemy.var3b
	ld a,(hl)
	ld (hl),$00
	inc a
	jr nz,++
	ld l,Enemy.var34
	ld a,(hl)
	or a
	jr nz,++
	inc (hl) ; [var34]
	call ambiGuard_setCounter2ForAttackingTypeOnly
++
	ld e,Enemy.var34
	ld a,(de)
	rrca
	jr nc,@haventSeenLinkYet

	; Return if bit 1 of var34 set (already noticed Link)
	rrca
	ret c

	; Link is close enough to have been noticed. Do some extra checks for the "tossing
	; Link out" subids only.

	ld l,Enemy.subid
	bit 7,(hl)
	jr nz,@noticedLink

	call checkLinkCollisionsEnabled
	ret nc

	ld a,(w1Link.zh)
	rlca
	ret c

	; Link has been seen. Disable inputs, etc.

	ld a,$80
	ld (wMenuDisabled),a

	ld a,DISABLE_COMPANION|DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wDisableScreenTransitions),a

	; Wait for 60 frames
	ld e,Enemy.var36
	ld a,60
	ld (de),a

	call ambiGuard_createExclamationMark

@noticedLink:
	; Mark bit 1 to indicate the exclamation mark was shown already, etc.
	ld h,d
	ld l,Enemy.var34
	set 1,(hl)

	ld l,Enemy.state
	ld (hl),$0f

	; Delete PARTID_DETECTION_HELPER
	ld a,Object.health
	call objectGetRelatedObject2Var
	ld (hl),$00
	ret

@haventSeenLinkYet:
	; Was the guard hit with an indirect attack?
	inc e
	ld a,(de) ; [var35]
	rrca
	ret nc

	; He was; update speed, make exclamation mark.
	xor a
	ld (de),a

	ld l,Enemy.speed
	ld (hl),SPEED_140

	; fall through

;;
ambiGuard_createExclamationMark:
	ld a,45
	ld bc,$f408
	jp objectCreateExclamationMark


ambiGuard_collisionOccured:
	; If already noticed Link, return
	ld e,Enemy.var34
	ld a,(de)
	or a
	ret nz

	; Check whether attack type was direct or indirect
	ld h,d
	ld l,Enemy.var2a
	ld a,(hl)
	cp $92 ; Collisions up to & including ITEMCOLLISION_11 are "direct" attacks
	jr c,ambiGuard_directAttackOccurred

	cp $80|ITEMCOLLISION_GALE_SEED
	ret z

	; COLLISION_TYPE_SOMARIA_BLOCK or above (indirect attack)
	ld h,d
	ld l,Enemy.var35
	ld a,(hl)
	or a
	ret nz

	inc (hl) ; [var35] = 1 (make guard move move quickly)
	inc l
	ld (hl),90 ; [var36] (wait for 90 frames)

	ld l,Enemy.knockbackAngle
	ld a,(hl)
	xor $10

	; fall through


;;
; @param	a	Angle
ambiGuard_setAngle:
	add $04
	and $18
	ld e,Enemy.angle
	ld (de),a

	swap a
	rlca
	jp enemySetAnimation

;;
; A collision with one of Link's direct attacks (sword, fist, etc) occurred.
ambiGuard_directAttackOccurred:
	; Guard notices Link right away
	ld e,Enemy.var34
	ld a,$01
	ld (de),a

;;
; Does some initialization for "attacking link" type only, when they just notice Link.
ambiGuard_setCounter2ForAttackingTypeOnly:
	ld e,Enemy.subid
	ld a,(de)
	rlca
	ret nc

	; For "attacking Link" subids only, do extra initialization
	ld e,Enemy.counter2
	ld a,90
	ld (de),a
	ld e,Enemy.var36
	xor a
	ld (de),a
	ret


; Scampering away when health is 0
ambiGuard_noHealth:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.speedZ
	ld a,$00
	ldi (hl),a
	ld (hl),$ff

; Initial jump before moving away
@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; Landed
	ld l,Enemy.substate
	inc (hl)

	ld l,Enemy.speedZ
	ld a,<(-$1c0)
	ldi (hl),a
	ld (hl),>(-$1c0)

	ld l,Enemy.speed
	ld (hl),SPEED_140

	ld l,Enemy.knockbackAngle
	ld a,(hl)
	ld l,Enemy.angle
	ld (hl),a

	add $04
	and $18
	swap a
	rlca
	jp enemySetAnimation

; Moving away until off-screen
@substate2:
	ld e,Enemy.yh
	ld a,(de)
	cp LARGE_ROOM_HEIGHT<<4
	jp nc,enemyDelete

	ld e,Enemy.xh
	ld a,(de)
	cp LARGE_ROOM_WIDTH<<4
	jp nc,enemyDelete

	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,enemyAnimate

	; Landed on ground
	ld l,Enemy.speedZ
	ld a,<(-$1c0)
	ldi (hl),a
	ld (hl),>(-$1c0)
	ret


; The tables below define the guards' patrol patterns.
; See include/movementscript_commands.s.
ambiGuard_tossesLinkOut_scriptTable:
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05
	.dw @subid06
	.dw @subid07
	.dw @subid08
	.dw @subid09
	.dw @subid0a
	.dw @subid0b
	.dw @subid0c

@subid00:
	.db SPEED_c0
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_left  $28
	ms_down  $58
	ms_right $68
	ms_loop  @@loop

@subid01:
	.db SPEED_c0
	.db DIR_RIGHT
@@loop:
	ms_right $30
	ms_state 15, $0d
	ms_right $58
	ms_wait  30
	ms_left  $30
	ms_state 15, $0d
	ms_left  $08
	ms_wait  30
	ms_loop  @@loop

@subid02:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $78
	ms_down  $18
	ms_wait  60
	ms_left  $38
	ms_down  $18
	ms_wait  60
	ms_right $58
	ms_loop  @@loop

@subid03:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $78
	ms_up    $38
	ms_wait  60
	ms_left  $18
	ms_down  $38
	ms_wait  60
	ms_right $48
	ms_loop  @@loop

@subid04:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $38
	ms_right $48
	ms_wait  60
	ms_left  $18
	ms_down  $38
	ms_wait  60
	ms_up    $18
	ms_right $48
	ms_state 15, $0d
	ms_wait  40
	ms_state 15, $0d
	ms_loop  @@loop

@subid05:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $38
	ms_state 15, $0d
	ms_wait  40
	ms_state 15, $0d
	ms_left  $38
	ms_down  $58
	ms_left  $38
	ms_wait  60
	ms_right $68
	ms_state 15, $0d
	ms_wait  40
	ms_state 15, $0d
	ms_loop  @@loop

@subid06:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $38
	ms_down  $48
	ms_right $38
	ms_wait  60
	ms_down  $68
	ms_left  $18
	ms_up    $18
	ms_loop  @@loop

@subid07:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_right $88
	ms_down  $68
	ms_left  $68
	ms_up    $48
	ms_left  $68
	ms_wait  60
	ms_loop  @@loop

@subid08:
	.db SPEED_80
	.db DIR_LEFT
@@loop:
	ms_left  $18
	ms_state 15, $0d
	ms_up    $18
	ms_state 15, $0d
	ms_right $78
	ms_state 15, $0d
	ms_down  $58
	ms_state 15, $0d
	ms_left  $48
	ms_loop  @@loop

@subid09:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $78
	ms_state 15, $0d
	ms_up    $18
	ms_state 15, $0d
	ms_left  $28
	ms_state 15, $0d
	ms_down  $58
	ms_state 15, $0d
	ms_right $58
	ms_loop  @@loop

@subid0a:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_wait  127
	ms_loop  @@loop

@subid0b:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_wait  127
	ms_loop  @@loop

@subid0c:
	.db SPEED_80
	.db DIR_LEFT
@@loop:
	ms_wait  127
	ms_loop  @@loop


ambiGuard_attacksLink_scriptTable:
	.dw @subid80
	.dw @subid81
	.dw @subid82
	.dw @subid83
	.dw @subid84
	.dw @subid85
	.dw @subid86
	.dw @subid87
	.dw @subid88
	.dw @subid89
	.dw @subid8a
	.dw @subid8b
	.dw @subid8c


@subid80:
	.db SPEED_c0
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_left  $28
	ms_down  $58
	ms_right $68
	ms_loop  @@loop

@subid81:
	.db SPEED_c0
	.db DIR_RIGHT
@@loop:
	ms_right $30
	ms_state 15, $0d
	ms_right $58
	ms_wait  30
	ms_left  $30
	ms_state 15, $0d
	ms_left  $08
	ms_wait  30
	ms_loop  @@loop

@subid82:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $88
	ms_left  $28
	ms_up    $48
	ms_state 15, $0d
	ms_down  $88
	ms_right $98
	ms_up    $28
	ms_left  $28
	ms_down  $48
	ms_state 15, $0d
	ms_up    $28
	ms_right $98
	ms_loop  @@loop

@subid83:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $58
	ms_right $d8
	ms_up    $28
	ms_left  $98
	ms_down  $58
	ms_right $d8
	ms_down  $88
	ms_left  $98
	ms_up    $78
	ms_loop  @@loop

@subid84:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_right $d8
	ms_down  $88
	ms_left  $18
	ms_loop  @@loop

@subid85:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $88
	ms_left  $18
	ms_up    $18
	ms_right $d8
	ms_loop  @@loop

@subid86:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $58
	ms_left  $28
	ms_up    $28
	ms_right $68
	ms_loop  @@loop

@subid87:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $c8
	ms_up    $28
	ms_left  $88
	ms_down  $58
	ms_loop  @@loop

@subid88:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $58
	ms_left  $58
	ms_down  $88
	ms_right $98
	ms_loop  @@loop

@subid89:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $28
	ms_left  $38
	ms_down  $88
	ms_right $98
	ms_loop  @@loop

@subid8a:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $98
	ms_right $c8
	ms_up    $18
	ms_left  $a8
	ms_wait  60
	ms_right $c8
	ms_down  $98
	ms_left  $a8
	ms_up    $18
	ms_wait  60
	ms_loop  @@loop

@subid8b:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_left  $28
	ms_down  $58
	ms_right $48
	ms_down  $98
	ms_left  $28
	ms_up    $58
	ms_right $48
	ms_loop  @@loop

@subid8c:
	.db SPEED_80
	.db DIR_LEFT
@@loop:
	ms_left  $78
	ms_wait  60
	ms_down  $58
	ms_wait  60
	ms_right $78
	ms_wait  60
	ms_up    $58
	ms_wait  60
	ms_loop  @@loop



; ==============================================================================
; ENEMYID_CANDLE
;
; Variables:
;   relatedObj1: reference to INTERACID_EXPLOSION while exploding
; ==============================================================================
enemyCode55:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK
	; Check for ember seed collision to light self on fire
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_EMBER_SEED
	jr nz,@normalStatus

	ld e,Enemy.state
	ld a,(de)
	cp $0a
	jr nc,@normalStatus

	ld a,$0a
	ld (de),a

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw candle_state_uninitialized
	.dw candle_state_stub
	.dw candle_state_stub
	.dw candle_state_stub
	.dw candle_state_stub
	.dw candle_state_stub
	.dw candle_state_stub
	.dw candle_state_stub
	.dw candle_state8
	.dw candle_state9
	.dw candle_stateA
	.dw candle_stateB
	.dw candle_stateC
	.dw candle_stateD
	.dw candle_stateE


candle_state_uninitialized:
	ld e,Enemy.counter1
	ld a,30
	ld (de),a

	ld a,SPEED_40
	jp ecom_setSpeedAndState8AndVisible


candle_state_stub:
	ret


; Standing still for [counter1] frames
candle_state8:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),90

	; Choose random angle
	call getRandomNumber_noPreserveVars
	and $18
	add $04
	ld e,Enemy.angle
	ld (de),a
	ld a,$01
	jp enemySetAnimation


; Walking for [counter1] frames
candle_state9:
	call ecom_decCounter1
	jr nz,++

	ld (hl),30 ; [counter1]
	ld l,e
	dec (hl) ; [state]
	xor a
	call enemySetAnimation
++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr candle_animate


; Just lit on fire
candle_stateA:
	ld b,PARTID_CANDLE_FLAME
	call ecom_spawnProjectile
	ret nz

	call ecom_incState

	ld l,Enemy.counter1
	ld (hl),120

	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld a,$02
	jp enemySetAnimation


; Moving slowly at first
candle_stateB:
	call ecom_decCounter1
	jr nz,candle_applySpeed

	ld (hl),120 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_200
	ld a,$03
	call enemySetAnimation

candle_applySpeed:
	call objectApplySpeed
	call ecom_bounceOffWallsAndHoles

candle_animate:
	jp enemyAnimate


; Moving faster
candle_stateC:
	call ecom_decCounter1
	jr nz,candle_applySpeed

	ld (hl),60 ; [counter1]
	ld l,e
	inc (hl) ; [state]


; Flickering visibility, about to explode
candle_stateD:
	call ecom_flickerVisibility
	call ecom_decCounter1
	jr nz,candle_applySpeed

	inc (hl) ; [counter1] = 1

	; Create an explosion object; but the collisions are still provided by the candle
	; object, so this doesn't delete itself yet.
	ld b,INTERACID_EXPLOSION
	call objectCreateInteractionWithSubid00
	ret nz
	ld a,h
	ld h,d
	ld l,Enemy.relatedObj1+1
	ldd (hl),a
	ld (hl),Interaction.start

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO

	jp objectSetInvisible


; Waiting for explosion to end
candle_stateE:
	ld a,Object.animParameter
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret z

	rlca
	jr c,@done

	; Explosion radius increased
	ld (hl),$00 ; [child.animParameter]
	ld l,Enemy.collisionRadiusY
	ld a,$0c
	ldi (hl),a
	ld (hl),a
	ret

@done:
	call markEnemyAsKilledInRoom
	call decNumEnemies
	jp enemyDelete


; ==============================================================================
; ENEMYID_KING_MOBLIN_MINION
; ==============================================================================
enemyCode56:
	jpab bank10.enemyCode56_body


; ==============================================================================
; ENEMYID_VERAN_POSSESSION_BOSS
;
; Variables:
;   relatedObj1: For subid 2 (veran ghost/human), this is a reference to subid 0 or 1
;                (nayru/ambi form).
;   var30: Animation index
;   var31/var32: Target position when moving
;   var33: Number of hits remaining
;   var34: Current pillar index
;   var35: Bit 0 set if already showed veran's "taunting" text after using switch hook
; ==============================================================================
enemyCode61:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	; ENEMYSTATUS_KNOCKBACK or ENEMYSTATUS_JUST_HIT
	call veranPossessionBoss_wasHit

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,@commonState
	ld a,b
	rst_jumpTable
	.dw veranPossessionBoss_subid0
	.dw veranPossessionBoss_subid1
	.dw veranPossessionBoss_subid2
	.dw veranPossessionBoss_subid3

@commonState:
	rst_jumpTable
	.dw veranPossessionBoss_state_uninitialized
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_switchHook
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_stub


veranPossessionBoss_state_uninitialized:
	bit 1,b
	jr nz,++
	ld a,ENEMYID_VERAN_POSSESSION_BOSS
	ld (wEnemyIDToLoadExtraGfx),a
++
	ld a,b
	add a
	add b
	ld e,Enemy.var30
	ld (de),a
	call enemySetAnimation

	call objectSetVisible82

	ld a,SPEED_200
	call ecom_setSpeedAndState8

	ld l,Enemy.subid
	bit 1,(hl)
	ret z

	; For subids 2-3 only
	ld l,Enemy.oamFlagsBackup
	ld a,$01
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]

	ld l,Enemy.counter1
	ld (hl),$0c

	ld l,Enemy.speed
	ld (hl),SPEED_80
	ret


veranPossessionBoss_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw enemyAnimate
	.dw enemyAnimate
	.dw @substate3

@substate0:
	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)
	jp ecom_incSubstate

@substate3:
	ld b,$0b
	call ecom_fallToGroundAndSetState
	ld l,Enemy.counter1
	ld (hl),40
	ret


veranPossessionBoss_state_stub:
	ret


; Possessed Nayru
veranPossessionBoss_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw veranPossessionBoss_nayruAmbi_state8
	.dw veranPossessionBoss_nayruAmbi_state9
	.dw veranPossessionBoss_nayruAmbi_stateA
	.dw veranPossessionBoss_nayruAmbi_stateB
	.dw veranPossessionBoss_nayru_stateC
	.dw veranPossessionBoss_nayru_stateD
	.dw veranPossessionBoss_nayruAmbi_stateE
	.dw veranPossessionBoss_nayruAmbi_stateF
	.dw veranPossessionBoss_nayruAmbi_state10
	.dw veranPossessionBoss_nayruAmbi_state11
	.dw veranPossessionBoss_nayruAmbi_state12
	.dw veranPossessionBoss_nayruAmbi_state13
	.dw veranPossessionBoss_nayru_state14


; Initialization
veranPossessionBoss_nayruAmbi_state8:
	call getFreePartSlot
	ret nz

	ld (hl),PARTID_SHADOW
	ld l,Part.var03
	ld (hl),$06 ; Y-offset of shadow relative to self

	ld l,Part.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	; Go to state 9
	call veranPossessionBoss_nayruAmbi_beginMoving

	ld l,Enemy.var3f
	set 5,(hl)

	ld l,Enemy.var33
	ld (hl),$03
	inc l
	dec (hl) ; [var34] = $ff (current pillar index)

	xor a
	ld (wTmpcfc0.genericCutscene.cfd0),a

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	jp playSound


; Flickering before moving
veranPossessionBoss_nayruAmbi_state9:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.zh
	ld (hl),-2
	call objectSetInvisible

	; Choose a position to move to.
	; First it chooses a pillar randomly, then it chooses the side of the pillar based
	; on where Link is in relation.

@choosePillar:
	call getRandomNumber_noPreserveVars
	and $0e
	cp $0b
	jr nc,@choosePillar

	; Pillar must be different from last one
	ld h,d
	ld l,Enemy.var34
	cp (hl)
	jr z,@choosePillar

	ld (hl),a ; [var34]

	ld hl,@pillarList
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	push bc

	; Choose the side of the pillar that is furthest from Link
	ldh a,(<hEnemyTargetY)
	ldh (<hFF8F),a
	ldh a,(<hEnemyTargetX)
	ldh (<hFF8E),a
	call objectGetRelativeAngleWithTempVars
	add $04
	and $18
	rrca
	rrca

	ld hl,@pillarOffsets
	rst_addAToHl
	pop bc
	ldi a,(hl)
	add b
	ld e,Enemy.var31
	ld (de),a ; [var31]
	ld a,(hl)
	add c
	inc e
	ld (de),a ; [var32]

	ld a,SND_CIRCLING
	jp playSound

@pillarList:
	.db $58 $58
	.db $58 $98
	.db $38 $38
	.db $38 $b8
	.db $78 $38
	.db $78 $b8

@pillarOffsets:
	.db $e8 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0


; Moving to new position
veranPossessionBoss_nayruAmbi_stateA:
	ld h,d
	ld l,Enemy.var31
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition

	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition

	; Reached target position.

	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.zh
	ld (hl),$00

	ld l,Enemy.counter1
	ld (hl),30
	ret


; Just reached new position
veranPossessionBoss_nayruAmbi_stateB:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	call getRandomNumber_noPreserveVars
	and $0f
	ld b,a

	ld h,d
	ld l,Enemy.subid
	ld a,(hl)
	add a
	add a
	add (hl)
	ld l,Enemy.var33
	add (hl)
	dec a

	ld hl,@attackProbabilities
	rst_addAToHl
	ld a,b
	cp (hl)
	jr c,@beginAttacking

	; Move again
	call veranPossessionBoss_nayruAmbi_beginMoving
	ld (hl),30
	jp ecom_flickerVisibility

@beginAttacking:
	call ecom_incState

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.var30
	ld a,(hl)
	inc a
	call enemySetAnimation
	jp objectSetVisiblec2

; Each byte is the probability of veran attacking when she has 'n' hits left (ie. 1st byte is
; for when she has 1 hit left). Higher values mean a higher probability of attacking. If
; she doesn't attack, she moves again.
@attackProbabilities:
	.db $05 $0a $10 $10 $10 ; Nayru
	.db $05 $06 $08 $08 $08 ; Ambi


; Delay before attacking with projectiles. (Nayru only)
veranPossessionBoss_nayru_stateC:
	call ecom_decCounter1
	ret nz

	ld (hl),142 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld b,PARTID_VERAN_PROJECTILE
	jp ecom_spawnProjectile


; Attacking with projectiles. (This is only Nayru's state D, but Ambi's state D may call
; this if it's not spawning spiders instead.)
veranPossessionBoss_nayru_stateD:
	call ecom_decCounter1
	ret nz

veranPossessionBoss_doneAttacking:
	call veranPossessionBoss_nayruAmbi_beginMoving

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.var30
	ld a,(hl)
	jp enemySetAnimation


; Just shot with mystery seeds
veranPossessionBoss_nayruAmbi_stateE:
	call ecom_decCounter2
	ret nz

	; Spawn veran ghost form
	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMYID_VERAN_POSSESSION_BOSS
	inc l
	ld (hl),$02 ; [child.subid]

	; [child.var33] = [this.var33] (remaining hits before death)
	ld l,Enemy.var33
	ld e,l
	ld a,(de)
	ld (hl),a

	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld bc,$fc04
	call objectCopyPositionWithOffset

	call ecom_incState

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.oamFlagsBackup
	ld a,$01
	ldi (hl),a ; [child.oamFlagsBackup]
	ld (hl),a  ; [child.oamFlags]

	jp objectSetVisible83


; Collapsed (ghost Veran is showing)
veranPossessionBoss_nayruAmbi_stateF:
	ret


; Veran just returned to nayru/ambi's body
veranPossessionBoss_nayruAmbi_state10:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.oamFlagsBackup
	ld a,$06
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]

	ld l,Enemy.counter1
	ld (hl),15
	jp objectSetVisible82


; Remains collapsed on the floor for a few frames before moving again
veranPossessionBoss_nayruAmbi_state11:
	call ecom_decCounter1
	ret nz

	ld l,Enemy.var30
	ld a,(hl)
	call enemySetAnimation


veranPossessionBoss_nayruAmbi_beginMoving:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.counter1
	ld (hl),60
	ret


; Veran was just defeated.
veranPossessionBoss_nayruAmbi_state12:
	ld a,(wTextIsActive)
	or a
	ret nz
	call ecom_incState
	ld a,$02
	jp fadeoutToWhiteWithDelay


; Waiting for screen to go white
veranPossessionBoss_nayruAmbi_state13:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call ecom_incState
	jpab clearAllItemsAndPutLinkOnGround


; Delete all objects (including self), resume cutscene with a newly created object
veranPossessionBoss_nayru_state14:
	call clearWramBank1

	ld hl,w1Link.enabled
	ld (hl),$03

	call getFreeInteractionSlot
	ld (hl),INTERACID_NAYRU_SAVED_CUTSCENE
	ret


; Possessed Ambi
veranPossessionBoss_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw veranPossessionBoss_nayruAmbi_state8
	.dw veranPossessionBoss_nayruAmbi_state9
	.dw veranPossessionBoss_nayruAmbi_stateA
	.dw veranPossessionBoss_nayruAmbi_stateB
	.dw veranPossessionBoss_ambi_stateC
	.dw veranPossessionBoss_ambi_stateD
	.dw veranPossessionBoss_nayruAmbi_stateE
	.dw veranPossessionBoss_nayruAmbi_stateF
	.dw veranPossessionBoss_nayruAmbi_state10
	.dw veranPossessionBoss_nayruAmbi_state11
	.dw veranPossessionBoss_nayruAmbi_state12
	.dw veranPossessionBoss_nayruAmbi_state13
	.dw veranPossessionBoss_ambi_state14


; Delay before attacking with projectiles or spawning spiders. (Ambi only)
veranPossessionBoss_ambi_stateC:
	call ecom_decCounter1
	ret nz

	ld (hl),142 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	call getRandomNumber_noPreserveVars
	and $0f
	ld b,a

	ld e,Enemy.var33
	ld a,(de)
	dec a
	ld hl,@spiderSpawnProbabilities
	rst_addAToHl
	ld a,b
	cp (hl)

	; Set [var03] to 1 if we're spawning spiders, 0 otherwise
	ld h,d
	ld l,Enemy.var03
	ld (hl),$01
	ret nc

	dec (hl)
	ld b,PARTID_VERAN_PROJECTILE
	jp ecom_spawnProjectile

; Each byte is the probability of veran spawning spiders when she has 'n' hits left (ie.
; 1st byte is for when she has 1 hit left). Lower values mean a higher probability of
; spawning spiders. If she doesn't spawn spiders, she fires projectiles.
@spiderSpawnProbabilities:
	.db $08 $08 $0a $0a $0a


; Attacking with projectiles or spiders. (Ambi only)
veranPossessionBoss_ambi_stateD:
	; Jump to Nayru's state D if we're firing projectiles
	ld e,Enemy.var03
	ld a,(de)
	or a
	jp z,veranPossessionBoss_nayru_stateD

	; Spawning spiders

	call ecom_decCounter1
	jp z,veranPossessionBoss_doneAttacking

	; Spawn spider every 32 frames
	ld a,(hl) ; [counter1]
	and $1f
	ret nz

	ld a,(wNumEnemies)
	cp $06
	ret nc

	ld b,ENEMYID_VERAN_SPIDER
	jp ecom_spawnEnemyWithSubid01


; Ambi-specific cutscene after Veran defeated
veranPossessionBoss_ambi_state14:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; Deletes all objects, including self
	call clearWramBank1

	ld a,$01
	ld (wNumEnemies),a

	ld hl,w1Link.enabled
	ld (hl),$03

	ld l,<w1Link.yh
	ld (hl),$58
	ld l,<w1Link.xh
	ld (hl),$78

	call setCameraFocusedObjectToLink
	call resetCamera

	; Spawn subid 3 of this object
	call getFreeEnemySlot_uncounted
	ld (hl),ENEMYID_VERAN_POSSESSION_BOSS
	inc l
	ld (hl),$03 ; [subid]

	ld l,Enemy.yh
	ld (hl),$48
	ld l,Enemy.xh
	ld (hl),$78
	ret


; Veran emerged in human form
veranPossessionBoss_subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw veranPossessionBoss_humanForm_state8
	.dw veranPossessionBoss_humanForm_state9
	.dw veranPossessionBoss_humanForm_stateA
	.dw veranPossessionBoss_humanForm_stateB
	.dw veranPossessionBoss_humanForm_stateC
	.dw veranPossessionBoss_humanForm_stateD
	.dw veranPossessionBoss_humanForm_stateE
	.dw veranPossessionBoss_humanForm_stateF
	.dw veranPossessionBoss_humanForm_state10


; Moving upward just after spawning
veranPossessionBoss_humanForm_state8:
	call objectApplySpeed
	call ecom_decCounter1
	jr nz,veranPossessionBoss_animate

	ld (hl),120 ; [counter1]
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_VERAN_GHOST

	; If this is Nayru, and we haven't shown veran's taunting text yet, show it.
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,veranPossessionBoss_animate

	ld l,Enemy.var35
	bit 0,(hl)
	jr nz,veranPossessionBoss_animate

	inc (hl) ; [var35] |= 1

	ld bc,TX_2f2a
	call showText
	jr veranPossessionBoss_animate


; Waiting for Link to use switch hook
veranPossessionBoss_humanForm_state9:
	call ecom_decCounter1
	jr nz,veranPossessionBoss_animate

	ld (hl),12 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN

	ld l,Enemy.collisionType
	res 7,(hl)

veranPossessionBoss_animate:
	jp enemyAnimate


; Moving down to re-possess her victim
veranPossessionBoss_humanForm_stateA:
	call objectApplySpeed
	call ecom_decCounter1
	jr nz,veranPossessionBoss_animate

	ld l,Enemy.collisionType
	res 7,(hl)

veranPossessionBoss_humanForm_returnToHost:
	; Send parent to state $10
	ld a,Object.state
	call objectGetRelatedObject1Var
	inc (hl)

	; Update parent's "hits remaining" counter
	ld l,Enemy.var33
	ld e,l
	ld a,(de)
	ld (hl),a

	jp enemyDelete


; Just finished using switch hook on ghost. Flickering between ghost and human forms.
veranPossessionBoss_humanForm_stateB:
	call ecom_decCounter1
	jr nz,@flickerBetweenForms

	ld (hl),120 ; [counter1]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_VERAN_HUMAN

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	; NOTE: hl is supposed to be [counter1] for below, which it isn't. It only affects
	; the animation though, so no big deal...

@flickerBetweenForms:
	ld a,(hl) ; [counter1]
	rrca
	ld a,$09
	jr c,+
	ld a,$06
+
	jp enemySetAnimation


; Veran is vulnerable to attacks.
veranPossessionBoss_humanForm_stateC:
	call ecom_decCounter1
	jr nz,veranPossessionBoss_animate

	; Time to return to host

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_280

	ld l,Enemy.speedZ
	ld a,<(-$280)
	ldi (hl),a
	ld (hl),>(-$280)

	call objectSetVisiblec1

	; Set target position to be the nayru/ambi's position.
	; [this.var31] = [parent.yh], [this.var32] = [parent.xh]
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld e,Enemy.var31
	ldi a,(hl)
	ld (de),a ; [this.var31]
	inc e
	inc l
	ld a,(hl)
	ld (de),a ; [this.var32]

	jr veranPossessionBoss_animate


; Moving back to nayru/ambi
veranPossessionBoss_humanForm_stateD:
	ld c,$20
	call objectUpdateSpeedZ_paramC

	ld l,Enemy.var31
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition

	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition

	; Reached nayru/ambi.

	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c

	; Wait until reached ground
	ld e,Enemy.zh
	ld a,(de)
	or a
	ret nz

	jp veranPossessionBoss_humanForm_returnToHost


; Health is zero; about to begin cutscene.
veranPossessionBoss_humanForm_stateE:
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	or a
	ret nz

	call checkLinkCollisionsEnabled
	ret nc

	ldbc INTERACID_PUFF,$02
	call objectCreateInteraction
	ret nz
	ld a,h
	ld h,d
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Interaction.start

	ld l,Enemy.state
	inc (hl)

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	jp objectSetInvisible


; Waiting for puff to finish its animation
veranPossessionBoss_humanForm_stateF:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	jp ecom_incState


; Sets nayru/ambi's state to $12, shows text, then deletes self
veranPossessionBoss_humanForm_state10:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$12

	ld l,Enemy.subid
	bit 0,(hl)
	ld bc,TX_560b
	jr z,+
	ld bc,TX_5611
+
	call showText
	jp enemyDelete



; Collapsed Ambi after the fight.
veranPossessionBoss_subid3:
	ld a,(de)
	cp $08
	jr nz,@state9


; Waiting for palette to fade out
@state8:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call ecom_incState

	ld l,Enemy.counter2
	ld (hl),60

	ld a,$05
	call enemySetAnimation

	jp fadeinFromWhite


; Waiting for palette to fade in; then spawn the real Ambi object and delete self.
@state9:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call ecom_decCounter2
	ret nz

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_AMBI
	inc l
	ld (hl),$07 ; [subid]

	call objectCopyPosition

	ld a,TREE_GFXH_01
	ld (wLoadedTreeGfxIndex),a

	jp enemyDelete


;;
veranPossessionBoss_wasHit:
	ld h,d
	ld l,Enemy.knockbackCounter
	ld (hl),$00

	ld e,Enemy.subid
	ld a,(de)
	cp $02
	ld l,Enemy.var2a
	ld a,(hl)
	jr z,@subid2

	; Subid 0 or 1 (possessed Nayru or Ambi)

	res 7,a
	cp ITEMCOLLISION_MYSTERY_SEED
	jr z,@mysterySeed

	; Direct attacks from Link cause damage to Link, not Veran
	sub ITEMCOLLISION_L1_SWORD
	ret c
	cp ITEMCOLLISION_SHOVEL - ITEMCOLLISION_L1_SWORD + 1
	ret nc

	ld l,Enemy.invincibilityCounter
	ld (hl),-24
	ld hl,w1Link.invincibilityCounter
	ld (hl),40

	; [w1Link.knockbackAngle] = [this.knockbackAngle] ^ $10
	inc l
	ld e,Enemy.knockbackAngle
	ld a,(de)
	xor $10
	ldi (hl),a

	ld (hl),21 ; [w1Link.knockbackCounter]

	ld l,<w1Link.damageToApply
	ld (hl),-8
	ret

@mysterySeed:
	ld l,Enemy.state
	ld (hl),$0e

	ld l,Enemy.counter2
	ld (hl),30

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.var30
	ld a,(hl)
	add $02
	jp enemySetAnimation

@subid2:
	; Collisions on emerged Veran (ghost/human form)
	; Check if a direct attack occurred
	res 7,a
	cp ITEMCOLLISION_L1_SWORD
	ret c
	cp ITEMCOLLISION_EXPERT_PUNCH + 1
	ret nc

	ld l,Enemy.enemyCollisionMode
	ld a,(hl)
	cp ENEMYCOLLISION_VERAN_GHOST
	jr nz,++

	; No effect on ghost form
	ld l,Enemy.invincibilityCounter
	ld (hl),-8
	ret
++
	ld l,Enemy.counter1
	ld (hl),$08
	ld l,Enemy.var33
	dec (hl)
	ret nz

	; Veran has been hit enough times to die now.

	ld l,Enemy.health
	ld (hl),$80

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.state
	ld (hl),$0e

	ld a,$01
	ld (wTmpcfc0.genericCutscene.cfd0),a

	ld a,SNDCTRL_STOPMUSIC
	jp playSound


; ==============================================================================
; ENEMYID_VINE_SPROUT
;
; Variables:
;   var31: Tile index underneath the sprout?
;   var32: Short-form position of vine sprout
;   var33: Nonzero if the "tile properties" underneath this sprout have been modified
; ==============================================================================
enemyCode62:
	call objectReplaceWithAnimationIfOnHazard
	ret c

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw vineSprout_state0
	.dw vineSprout_state1
	.dw vineSprout_state_grabbed
	.dw vineSprout_state_switchHook
	.dw vineSprout_state4


; Initialization
vineSprout_state0:
	; Delete self if there is any other vine sprout on-screen already?
	ldhl FIRST_ENEMY_INDEX, Enemy.id
@nextEnemy:
	ld a,(hl)
	cp ENEMYID_VINE_SPROUT
	jr nz,++
	ld a,d
	cp h
	jp nz,enemyDelete
++
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),20

	ld l,Enemy.speed
	ld (hl),SPEED_c0

.ifdef REGION_JP
	; JP version of "vineSprout_getPosition" function. Instead of checking for certain specific
	; respawning tiles, this checks for solidity at the vine sprout's position. If the tile
	; there is solid, the sprout respawns back at its initial position.
	;
	; The only apparent difference this code makes (along with the other changes to vines in
	; general) is that when a vine is placed on the staircase in talus peaks using the switch
	; hook, in the japanese version, it will be forced to respawn back to its original position.
	; They "fixed" this in the US version.
	;
	; An apparent unintentional side-effect of the change to the US version is that, because
	; it always writes collision value "$00" back to the tile when the vine is pushed off, the
	; staircase values are set to collision "$00" instead of "SPECIALCOLLISION_STAIRS". This
	; doesn't seem to have any practical significance except that you can then use the cane of
	; somaria on the stair tiles, while normally you could not.
	;
	; (AFAIK, the staircases are the only things with a non-zero collision value that vines can
	; be put onto. If there is anything else like that, then those other things may also be
	; affected by these changes.)
	ld e,Enemy.subid
	ld a,(de)
	ld hl,wVinePositions
	rst_addAToHl
	ld c,(hl)

	ld b,>wRoomLayout
	ld a,(bc)
	or a
	jr z,++
	call vineSprout_getDefaultPosition
	ld c,a
++

.else
	call vineSprout_getPosition
.endif

	call objectSetShortPosition
	jp objectSetVisiblec2


vineSprout_state1:
	ld a,(wLinkInAir)
	rlca
	jp c,vineSprout_linkJumpingDownCliff

	call vineSprout_checkLinkInSprout
	ld e,Enemy.var33
	ld a,(de)
	jp c,vineSprout_restoreTileAtPosition

	call objectAddToGrabbableObjectBuffer
	call vineSprout_updateTileAtPosition

	; Check various conditions for whether to push the sprout
	ld hl,w1Link.id
	ld a,(hl)
	cpa SPECIALOBJECTID_LINK
	jr nz,@notPushingSprout

	ld l,<w1Link.state
	ld a,(hl)
	cp LINK_STATE_NORMAL
	jr nz,@notPushingSprout

	; Must not be in midair
	ld l,<w1Link.zh
	bit 7,(hl)
	jr nz,@notPushingSprout

	; Can't be swimming
	ld a,(wLinkSwimmingState)
	or a
	jr nz,@notPushingSprout

	; Must be moving
	ld a,(wLinkAngle)
	inc a
	jr z,@notPushingSprout

	; Must not be pressing A or B
	ld a,(wGameKeysPressed)
	and BTN_A|BTN_B
	jr nz,@notPushingSprout

.ifndef REGION_JP
	; Must not be holding anything
	ld a,(wLinkGrabState)
	or a
	jr nz,@notPushingSprout
.endif

	; Must be close enough
	ld c,$12
	call objectCheckLinkWithinDistance
	jr nc,@notPushingSprout

	; Must be aligned properly
	ld b,$04
	call objectCheckCenteredWithLink
	jr nc,@notPushingSprout

	; Link must be moving forwards
	call ecom_updateCardinalAngleAwayFromTarget
	add $04
	and $18
	ld (de),a ; [angle]
	swap a
	rlca
	ld b,a
	ld a,(w1Link.direction)
	cp b
	jr nz,@notPushingSprout

	; All the above must hold for 20 frames
	call ecom_decCounter1
	ret nz

	; Attempt to push the sprout.

	ld a,(de) ; [angle]
	rrca
	rrca
	ld hl,@pushOffsets
	rst_addAToHl

	; Get destination position
	call objectGetPosition
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a

	; Must not be solid there
	call getTileCollisionsAtPosition
	jr nz,@notPushingSprout

	; Push the sprout
	ld h,d
	ld l,Enemy.state
	ld (hl),$04
	ld l,Enemy.counter1
	ld (hl),$16
	ld a,SND_MOVEBLOCK
	call playSound
	jp vineSprout_restoreTileAtPosition

@notPushingSprout:
	ld e,Enemy.counter1
	ld a,20
	ld (de),a
	ret

@pushOffsets:
	.db $f0 $00 ; DIR_UP
	.db $00 $10 ; DIR_RIGHT
	.db $10 $00 ; DIR_DOWN
	.db $00 $f0 ; DIR_LEFT


vineSprout_linkJumpingDownCliff:
	call vineSprout_restoreTileAtPosition
	call vineSprout_checkLinkInSprout
	ret nc

	; Check Link is close to ground
	ld l,SpecialObject.zh
	ld a,(hl)
	add $03
	ret nc

vineSprout_destroy:
	ld b,INTERACID_ROCKDEBRIS
	call objectCreateInteractionWithSubid00

	call vineSprout_getDefaultPosition
	ld b,a
	ld a,(de) ; [subid]
	ld hl,wVinePositions
	rst_addAToHl
	ld (hl),b

	jp enemyDelete


vineSprout_state_grabbed:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @justReleased
	.dw @hitGround

@justGrabbed:
	xor a
	ld (wLinkGrabState2),a
	inc a
	ld (de),a
	call vineSprout_restoreTileAtPosition
	jp objectSetVisiblec1

@beingHeld:
	ret

@justReleased:
	ld h,d
	ld l,Enemy.enabled
	res 1,(hl) ; Don't persist across rooms anymore
	ld l,Enemy.zh
	bit 7,(hl)
	ret nz

@hitGround:
	jr vineSprout_destroy


vineSprout_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justLatched
	.dw @beforeSwitch
	.dw objectCenterOnTile
	.dw @released

@justLatched:
	call vineSprout_restoreTileAtPosition
	jp ecom_incSubstate

@beforeSwitch:
	ret

@released:
	ld b,$01
	call ecom_fallToGroundAndSetState
	ret nz
	call objectCenterOnTile
	jp vineSprout_updateTileAtPosition


; Being pushed
vineSprout_state4:
	ld hl,w1Link
	call preventObjectHFromPassingObjectD

	call ecom_decCounter1
	jp nz,ecom_applyVelocityForTopDownEnemyNoHoles

	; Done pushing
	ld (hl),20 ; [counter1]
	ld l,Enemy.state
	ld (hl),$01

	call objectCenterOnTile

	; fall through


;;
; Updates tile properties at current position, updates wVinePositions, if var33 is
; nonzero.
vineSprout_updateTileAtPosition:
	; Return if we've already done this
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret nz

	call objectGetTileCollisions

.ifdef REGION_JP
	ld e,Enemy.var30
	ld (de),a
	ld (hl),$0f
	inc e
.else
	ld (hl),$0f
	ld e,Enemy.var31
.endif

	ld h,>wRoomLayout
	ld a,(hl)
	ld (de),a ; [var31] = tile index
	inc e
	ld a,l
	ld (de),a ; [var32] = tile position
	ld (hl),TILEINDEX_00

	inc e
	ld a,$01
	ld (de),a ; [var33] = 1

	; Ensure that the position is not on the screen boundary.
	; BUG: This could push the sprout into a wall? (Probably not possible with the
	; room layouts of the vanilla game...)
@fixVerticalBoundary:
	ld a,l
	and $f0
	jr nz,++
	set 4,l
	jr @fixHorizontalBoundary
++
	cp (SMALL_ROOM_HEIGHT-1)<<4
	jr nz,@fixHorizontalBoundary
	res 4,l

@fixHorizontalBoundary:
	ld a,l
	and $0f
	jr nz,++
	inc l
	jr @setPosition
++
	cp SMALL_ROOM_WIDTH-1
	jr nz,@setPosition
	dec l

@setPosition:
	ld e,Enemy.subid
	ld a,(de)
	ld bc,wVinePositions
	call addAToBc
	ld a,l
	ld (bc),a
	ret

;;
; Undoes the changes done previously to the tile at the sprout's current position (the
; sprout is just moving off, or being destroyed, etc).
vineSprout_restoreTileAtPosition:
	; Return if there's nothing to undo
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret z

	xor a
	ld (de),a ; [var33]

	; Restore tile at this position
	dec e
	ld a,(de) ; [var32]
	ld l,a

	dec e
	ld a,(de) ; [var31]
	ld h,>wRoomLayout
	ld (hl),a

.ifdef REGION_JP
	dec e ; [var30]
	ld a,(de)
	ld h,>wRoomCollisions
	ld (hl),a
.else
	ld h,>wRoomCollisions
	ld (hl),$00
.endif
	ret


;;
; @param[out]	cflag	c if Link is in the sprout
vineSprout_checkLinkInSprout:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.yh
	ld e,Enemy.yh
	ld a,(de)
	sub (hl)
	add $06
	cp $0d
	ret nc

	ld l,SpecialObject.xh
	ld e,Enemy.xh
	ld a,(de)
	sub (hl)
	add $06
	cp $0d
	ret

;;
; @param[out]	a	Sprout's default position
; @param[out]	de	Enemy.subid
vineSprout_getDefaultPosition:
	ld e,Enemy.subid
	ld a,(de)
	ld bc,@defaultVinePositions
	call addAToBc
	ld a,(bc)
	ret

@defaultVinePositions:
	.include {"{GAME_DATA_DIR}/defaultVinePositions.s"}


.ifndef REGION_JP

;;
; @param[out]	c	Sprout's position
vineSprout_getPosition:
	ld e,Enemy.subid
	ld a,(de)
	ld hl,wVinePositions
	rst_addAToHl
	ld c,(hl)

	; Check if the sprout is under a "respawnable tile" (ie. a bush). If so, return to
	; default position.
	ld b,>wRoomLayout
	ld a,(bc)
	ld e,a
	ld hl,@respawnableTiles
-
	ldi a,(hl)
	or a
	ret z
	cp e
	jr nz,-

	call vineSprout_getDefaultPosition
	ld c,a
	ret

@respawnableTiles:
	.db $c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7
	.db $c8 $c9 $ca $00

.endif ; !REGION_JP


; ==============================================================================
; ENEMYID_TARGET_CART_CRYSTAL
;
; Variables:
;   var03: 0 for no movement, 1 for up/down, 2 for left/right
; ==============================================================================
enemyCode63:
	jr z,@normalStatus	 

	; ENEMYSTATUS_JUST_HIT
	ld e,Enemy.state
	ld a,$02
	ld (de),a

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw targetCartCrystal_state0
	.dw targetCartCrystal_state1
	.dw targetCartCrystal_state2


; Initialization
targetCartCrystal_state0:
	ld a,$01
	ld (de),a ; [state]
	call targetCartCrystal_loadPosition
	call targetCartCrystal_loadBehaviour
	jr z,+
	call targetCartCrystal_initSpeed
+
	jp objectSetVisible80


; Standard update state (update movement if it's a moving type)
targetCartCrystal_state1:
	ld e,Enemy.var03
	ld a,(de)
	or a
	jr z,+
	call targetCartCrystal_updateMovement
+
	ld e,Enemy.subid
	ld a,(de)
	cp $05
	jr nc,++
	ld a,(wTmpcfc0.targetCarts.cfdf)
	or a
	jp nz,enemyDelete
++
	jp enemyAnimate


; Target destroyed
targetCartCrystal_state2:
	ld hl,wTmpcfc0.targetCarts.numTargetsHit
	inc (hl)

	; If in the first room, mark this one as destroyed
	ld e,Enemy.subid
	ld a,(de)
	cp $05
	jr nc,++
	ld hl,wTmpcfc0.targetCarts.crystalsHitInFirstRoom
	call setFlag
++
	ld a,SND_GALE_SEED
	call playSound

	; Create the "debris" from destroying it
	ld a,$04
@spawnNext:
	ldh (<hFF8B),a
	ldbc INTERACID_FALLING_ROCK,$03
	call objectCreateInteraction
	jr nz,@delete
	ld l,Interaction.angle
	ldh a,(<hFF8B)
	dec a
	ld (hl),a
	jr nz,@spawnNext

@delete:
	jp enemyDelete



;;
; Sets var03 to "behaviour" value (0-2)
;
; @param[out]	zflag	z iff [var03] == 0
targetCartCrystal_loadBehaviour:
	ld a,(wTmpcfc0.targetCarts.targetConfiguration)
	swap a
	ld hl,@behaviourTable
	rst_addAToHl
	ld e,Enemy.subid
	ld a,(de)
	rst_addAToHl
	ld a,(hl)
	inc e
	ld (de),a ; [var03]
	or a
	ret

@behaviourTable:
	.db $00 $00 $00 $00 $00 $00 $00 $00 ; Configuration 0
	.db $00 $00 $00 $00 $00 $00 $00 $00

	.db $00 $00 $00 $00 $02 $00 $00 $00 ; Configuration 1
	.db $00 $01 $00 $02 $00 $00 $00 $00

	.db $01 $00 $02 $00 $00 $00 $00 $02 ; Configuration 2
	.db $01 $01 $02 $02 $00 $00 $00 $00


;;
; Sets Y/X position based on "wTmpcfc0.targetCarts.targetConfiguration" and subid.
targetCartCrystal_loadPosition:
	ld a,(wTmpcfc0.targetCarts.targetConfiguration)
	ld hl,@configurationTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	ld e,Enemy.subid
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Enemy.yh
	ld (de),a
	ld a,(hl)
	ld e,Enemy.xh
	ld (de),a
	ret


; Lists positions of the 12 targets for each of the 3 configurations.
@configurationTable:
	.db @configuration0 - CADDR
	.db @configuration1 - CADDR
	.db @configuration2 - CADDR

@configuration0:
	.db $18 $38 ; 0 == [subid]
	.db $48 $58 ; 1 == [subid]
	.db $28 $98 ; ...
	.db $48 $c8
	.db $18 $b8
	.db $58 $38
	.db $28 $98
	.db $28 $d8
	.db $58 $d8
	.db $98 $d8
	.db $98 $90
	.db $98 $58

@configuration1:
	.db $48 $18
	.db $18 $38
	.db $48 $58
	.db $48 $68
	.db $18 $a8
	.db $18 $48
	.db $58 $68
	.db $18 $88
	.db $18 $d8
	.db $58 $d8
	.db $98 $d8
	.db $98 $78

@configuration2:
	.db $20 $18
	.db $48 $68
	.db $18 $70
	.db $48 $98
	.db $48 $c8
	.db $28 $68
	.db $58 $68
	.db $18 $b8
	.db $40 $d8
	.db $80 $d8
	.db $98 $90
	.db $98 $50

;;
targetCartCrystal_initSpeed:
	ld h,d
	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.counter1
	ld (hl),$20

	ld l,Enemy.var03
	ld a,(hl)
	cp $02
	jr z,++
	ld l,Enemy.angle
	ld (hl),ANGLE_UP
	ret
++
	ld l,Enemy.angle
	ld (hl),ANGLE_LEFT
	ret

;;
; Crystal moves for a bit, switches directions, moves other way.
targetCartCrystal_updateMovement:
	call ecom_decCounter1
	jr nz,++
	ld (hl),$40
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
++
	jp objectApplySpeed
