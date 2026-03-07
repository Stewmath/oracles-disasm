; ==================================================================================================
; ENEMY_OCTOGON
;
; Variables:
;   var03: Where it actually is? (0 = above water, 1 = below water)
;   counter2: Counter until it moves above or below the water?
;   relatedObj1: Reference to other instance of ENEMY_OCTOGON?
;   var30: Index in "target position list"?
;   var31/var32: Target position to move to
;   var33/var34: Original Y/X position when this screen was entered
;   var35: Counter for animation purposes?
;   var36: Counter which, when 0 is reached, invokes a change of state (ie. fire at link
;          instead of moving around)
;   var37: Health value from when octogon appeared here (used to decide when to surface or
;          not)
; ==================================================================================================
enemyCode7d:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@justHit

	; Dead
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jp z,enemyDelete

	ld e,Enemy.collisionType
	ld a,(de)
	or a
	call nz,ecom_killRelatedObj1
	jp enemyBoss_dead

@justHit:
	ld a,Object.invincibilityCounter
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	ld (hl),a

	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr z,@normalStatus

	; Check if enough damage has been dealt to rise above or below the water
	ld h,d
	ld l,Enemy.health
	ld e,Enemy.var37
	ld a,(de)
	sub (hl)
	cp $0a
	jr c,+
	ld l,Enemy.counter2
	ld (hl),$01
+
	ld e,Enemy.health
	ld a,(de)
	or a
	jr nz,@normalStatus

	; Health just reached 0
	ld hl,wGroup5RoomFlags+(<ROOM_AGES_52d)
	set 7,(hl)
	ld l,<ROOM_AGES_536
	set 7,(hl)
	ld a,MUS_BOSS
	ld (wActiveMusic),a
	ret

@normalStatus:
	call @doJumpTable

	ld h,d
	ld l,Enemy.var34
	ld e,Enemy.xh
	ld a,(de)
	ldd (hl),a
	ld e,Enemy.yh
	ld a,(de)
	ld (hl),a
	ld l,Enemy.direction
	ld a,(hl)
	cp $10
	jr c,+
	ld a,$08
+
	and $0c
	rrca
	ld hl,@offsetData
	rst_addAToHl

	; Add offsets to Y/X position
	ld a,(de)
	add (hl)
	ld (de),a
	ld e,Enemy.xh
	inc hl
	ld a,(de)
	add (hl)
	ld (de),a

	; Store some persistent variables?

	ld hl,wTmpcfc0.octogonBoss.var03
	ld e,Enemy.var03
	ld a,(de)
	ldi (hl),a

	ld e,Enemy.direction
	ld a,(de)
	ldi (hl),a ; [wTmpcfc0.octogonBoss.direction]

	ld e,Enemy.health
	ld a,(de)
	ldi (hl),a ; [wTmpcfc0.octogonBoss.health]

	ld e,Enemy.var33
	ld a,(de)
	ldi (hl),a ; [wTmpcfc0.octogonBoss.var33]
	inc e
	ld a,(de) ; [var34]
	ldi (hl),a ; [wTmpcfc0.octogonBoss.var34]

	ld e,Enemy.var30
	ld a,(de)
	ld (hl),a ; [wTmpcfc0.octogonBoss.var30]
	ret

@offsetData:
	.db $f8 $00
	.db $00 $08
	.db $08 $00
	.db $00 $f8

@doJumpTable:
	ld e,Enemy.state
	ld a,(de)
	cp $08
	ld e,Enemy.subid
	jr c,@state8OrLess

	ld a,(de)
	rst_jumpTable
	.dw octogon_subid0
	.dw octogon_subid1
	.dw octogon_subid2


@state8OrLess:
	rst_jumpTable
	.dw octogon_state_uninitialized
	.dw octogon_state_stub
	.dw octogon_state_stub
	.dw octogon_state_stub
	.dw octogon_state_stub
	.dw octogon_state_stub
	.dw octogon_state_stub
	.dw octogon_state_stub


octogon_state_uninitialized:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,@notSubid2

	ld e,Enemy.enemyCollisionMode
	ld a,ENEMYCOLLISION_OCTOGON_SHELL
	ld (de),a
	jp ecom_setSpeedAndState8

@notSubid2:
	ld a,ENEMY_OCTOGON
	ld (wEnemyIDToLoadExtraGfx),a
	ld a,PALH_88
	call loadPaletteHeader

	ld hl,wTmpcfc0.octogonBoss.loadedExtraGfx
	ld a,(hl)
	or a
	jr nz,++
	inc (hl)
	call enemyBoss_initializeRoomWithoutExtraGfx
++
	; Create "child" with subid 2? They will reference each other with relatedObj2.
	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMY_OCTOGON
	inc l
	ld (hl),$02 ; [child.subid]
	ld l,Enemy.relatedObj1
	ld e,l
	ld a,Enemy.start
	ld (de),a
	ldi (hl),a
	inc e
	ld a,h
	ld (de),a
	ld (hl),d

	ld a,SPEED_100
	call ecom_setSpeedAndState8

	ld l,Enemy.var35
	ld (hl),$0c ; [this.var35]
	inc l
	ld (hl),120 ; [var36]

	ld l,Enemy.subid
	ld a,(hl)
	add a
	ld b,a
	call objectSetVisible83

	; Load persistent variables

	ld hl,wTmpcfc0.octogonBoss.var30
	ld e,Enemy.var30
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.yh
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.health
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.var37
	ld (de),a
	ld e,Enemy.direction
	ldd a,(hl)
	ld (de),a
	ld e,Enemy.var03
	ld a,(hl)
	ld (de),a

	add b
	rst_jumpTable
	.dw @subid0_0
	.dw @subid0_1
	.dw @subid1_0
	.dw @subid1_1

@subid0_0:
	call octogon_fixPositionAboveWater

	ld h,d
	ld l,Enemy.counter2
	ld (hl),120

	ld l,Enemy.var30
	ld a,(hl)
	inc a
	jp z,octogon_chooseRandomTargetPosition

	call octogon_loadTargetPosition
	ret z
	dec hl
	dec hl
	dec hl
	ld a,(hl)
	ld e,Enemy.direction
	ld (de),a
	jp enemySetAnimation

@subid0_1:
	call octogon_fixPositionAboveWater
	jp octogon_loadNormalSubmergedAnimation

@subid1_0:
	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)

	; Delete child object (subid 2)
	ld a,Object.start
	call objectGetRelatedObject1Var
	ld b,$40
	call clearMemory

	jp objectSetInvisible

@subid1_1:
	ld a,$01
	ld (wTmpcfc0.octogonBoss.posNeedsFixing),a

	ld h,d
	ld l,Enemy.oamFlagsBackup
	ld a,$06
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.counter1
	ld (hl),90
	inc l
	ld (hl),150 ; [counter2]

	ld l,Enemy.var31
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	call ecom_updateAngleTowardTarget
	add $04
	and $18
	rrca
	ld e,Enemy.direction
	ld (de),a
	call enemySetAnimation

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_BUBBLE
	inc l
	inc (hl) ; [bubble.subid] = 1
	ld l,Interaction.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	ret


octogon_state_stub:
	ret


octogon_subid0:
	; Initialize Y/X position
	ld h,d
	ld l,Enemy.var33
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	; Check if submerged
	ld e,Enemy.var03
	ld a,(de)
	or a
	ld e,Enemy.state
	ld a,(de)
	jp nz,octogon_subid0BelowWater

	sub $08
	rst_jumpTable
	.dw octogon_subid0AboveWater_state8
	.dw octogon_subid0AboveWater_state9
	.dw octogon_subid0AboveWater_stateA
	.dw octogon_subid0AboveWater_stateB
	.dw octogon_subid0AboveWater_stateC
	.dw octogon_subid0AboveWater_stateD
	.dw octogon_subid0AboveWater_stateE
	.dw octogon_subid0AboveWater_stateF
	.dw octogon_subid0AboveWater_state10
	.dw octogon_subid0AboveWater_state11


octogon_subid0AboveWater_state8:
	; Wait for shutters to close
	ld a,($cc93)
	or a
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	; Initialize music if necessary
	ld hl,wActiveMusic
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	ld a,MUS_BOSS
	jp playSound


; Moving normally around the room
octogon_subid0AboveWater_state9:
	call octogon_decVar36IfNonzero

	; Submerge into water after set amount of time
	ld a,(wFrameCounter)
	and $03
	jr nz,++
	ld l,Enemy.counter2
	dec (hl)
	jp z,octogon_subid0_submergeIntoWater
++
	; Check if lined up to fire at Link.
	; BUG: Should set 'b', not 'c'? (b happens to be $0f here, so it works out ok.)
	ld c,$08
	call objectCheckCenteredWithLink
	jp nc,octogon_updateMovementAndAnimation

	; If enough time has passed, begin firing at Link.
	ld h,d
	ld l,Enemy.var36
	ld a,(hl)
	or a
	jp nz,octogon_updateMovementAndAnimation

	ld (hl),120 ; [var36]

	; Begin turning toward Link to fire.
	call objectGetAngleTowardEnemyTarget
	add $14
	and $18
	ld b,a
	ld e,Enemy.direction
	ld a,(de)
	and $0c
	add a
	cp b
	jp nz,octogon_updateMovementAndAnimation

	ld h,d
	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.counter1
	ld (hl),$08
	ret


octogon_subid0AboveWater_stateA:
octogon_subid0_pauseMovement:
	call ecom_decCounter1
	ret nz

	ld l,e
	dec (hl) ; [state]--

	ld l,Enemy.var30
	ld a,(hl)
	inc a
	ld (hl),a

	and $07
	jr nz,octogon_loadTargetPosition


;;
octogon_chooseRandomTargetPosition:
	call getRandomNumber
	and $18
	ld (hl),a

;;
; @param	hl	Pointer to index for a table
; @param[out]	hl	Pointer to some data
; @param[out]	zflag	z if animation changed
octogon_loadTargetPosition:
	ld a,(hl)
	add a
	add (hl)
	ld hl,@targetPositionList
	rst_addAToHl
	ld e,Enemy.var31
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a ; [var32]
	ld e,Enemy.var03
	ld a,(de)
	or a
	ret nz

	ld a,(hl)
	bit 7,a
	ret nz

	ld e,Enemy.direction
	ld (de),a
	call enemySetAnimation
	xor a
	ret

; data format: target position (2 bytes), animation
@targetPositionList:
	.db $28 $38 $00
	.db $58 $30 $0c
	.db $88 $38 $ff
	.db $88 $78 $08
	.db $88 $b8 $ff
	.db $58 $c0 $04
	.db $28 $b8 $ff
	.db $28 $78 $00

	.db $28 $b8 $00
	.db $58 $c0 $04
	.db $88 $b8 $ff
	.db $88 $78 $08
	.db $88 $38 $ff
	.db $58 $30 $0c
	.db $28 $38 $ff
	.db $28 $78 $00

	.db $28 $38 $00
	.db $58 $30 $0c
	.db $88 $38 $ff
	.db $88 $78 $08
	.db $88 $38 $ff
	.db $58 $30 $0c
	.db $28 $38 $ff
	.db $28 $78 $00

	.db $28 $b8 $00
	.db $58 $c0 $04
	.db $88 $b8 $ff
	.db $88 $78 $08
	.db $88 $b8 $ff
	.db $58 $c0 $04
	.db $28 $b8 $ff
	.db $28 $78 $00


; Turning around to fire projectile (or just after doing so)?
octogon_subid0AboveWater_stateB:
octogon_subid0AboveWater_stateF:
	ld b,$06
	jr octogon_subid0AboveWater_turningAround


; Turning around?
octogon_subid0AboveWater_stateC:
	ld b,$18

octogon_subid0AboveWater_turningAround:
	call ecom_decCounter1
	ret nz

	ld (hl),b
	ld l,e
	inc (hl) ; [state]++

	ld l,Enemy.direction
	ld a,(hl)
	add $04
	and $0c
	ld (hl),a
	jp enemySetAnimation


; About to fire projectile?
octogon_subid0AboveWater_stateD:
	call ecom_decCounter1
	ret nz

	ld (hl),$08

	ld l,e
	inc (hl) ; [state] = $0e

	ld l,Enemy.direction
	ld a,(hl)
	add $02
	ld (hl),a
	jp enemySetAnimation


; Firing projectile
octogon_subid0AboveWater_stateE:
	call ecom_decCounter1
	ret nz

	ld (hl),40
	ld l,e
	inc (hl) ; [state] = $0f
	ld l,Enemy.direction
	inc (hl)
	ld a,(hl)
	call enemySetAnimation
	jp octogon_fireOctorokProjectile


; Turning around after firing projectile?
octogon_subid0AboveWater_state10:
	ld b,$0c
	jr octogon_subid0AboveWater_turningAround


; Delay before resuming normal movement
octogon_subid0AboveWater_state11:
	call ecom_decCounter1
	ret nz
	ld l,e
	ld (hl),$09 ; [state]
	ret


; Octogon code where octogon itself is below water, and link is above water
octogon_subid0BelowWater:
	sub $08
	rst_jumpTable
	.dw octogon_subid0BelowWater_state8
	.dw octogon_subid0BelowWater_state9
	.dw octogon_subid0BelowWater_stateA
	.dw octogon_subid0BelowWater_stateB
	.dw octogon_subid0BelowWater_stateC
	.dw octogon_subid0BelowWater_stateD


; Swimming normally
octogon_subid0BelowWater_state8:
	call enemyAnimate

	; Check whether to play swimming sound
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	jr nz,++
	inc a
	ld (de),a
	ld a,SND_LINK_SWIM
	call playSound
++
	call octogon_decVar36IfNonzero
	jp nz,octogon_moveTowardTargetPosition

	; Reached target position
	ld (hl),90 ; [var36]
	call getRandomNumber
	cp $50
	jp nc,octogon_moveTowardTargetPosition

	; Random chance of going to state $0a (firing projectile)
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.counter1
	ld (hl),60
	jr octogon_loadNormalSubmergedAnimation


; Waiting in place before moving again
octogon_subid0BelowWater_state9:
	call octogon_subid0_pauseMovement
octogon_animate:
	jp enemyAnimate


; Delay before firing projectile
octogon_subid0BelowWater_stateA:
	call ecom_decCounter1
	jr z,@beginFiring

	ld a,(hl)
	and $07
	ret nz
	ld l,Enemy.direction
	ld a,(hl)
	xor $01
	ld (hl),a
	jp enemySetAnimation

@beginFiring:
	ld (hl),$08
	ld l,e
	inc (hl) ; [state] = $0b

octogon_loadNormalSubmergedAnimation:
	ld e,Enemy.direction
	ld a,$12
	ld (de),a
	jp enemySetAnimation


; Firing projectile
octogon_subid0BelowWater_stateB:
	call ecom_decCounter1
	jr z,@fireProjectile

	ld a,(hl)
	cp $06
	ret nz

	ld l,Enemy.direction
	ld a,$14
	ld (hl),a
	jp enemySetAnimation

@fireProjectile:
	ld (hl),60 ; [counter1]
	ld l,e
	inc (hl) ; [state] = $0c
	ld b,PART_OCTOGON_DEPTH_CHARGE
	call ecom_spawnProjectile
	jr octogon_loadNormalSubmergedAnimation


; Delay before moving again
octogon_subid0BelowWater_stateC:
	call ecom_decCounter1
	jr nz,octogon_animate

	ld l,Enemy.var36
	ld (hl),90

	ld l,e
	ld (hl),$08 ; [state]

	jr octogon_animate


; Just submerged into water
octogon_subid0BelowWater_stateD:
	call ecom_decCounter1
	ret nz
	ld (hl),30

	ld l,e
	ld (hl),$08 ; [state]

	jr octogon_loadNormalSubmergedAnimation


; Link is below water
octogon_subid1:
	ld h,d
	ld l,Enemy.var33
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var03
	ld a,(de)
	or a
	ld e,Enemy.state
	ld a,(de)
	jp z,octogon_subid1_aboveWater

	sub $08
	rst_jumpTable
	.dw octogon_subid1_belowWater_state8
	.dw octogon_subid1_belowWater_state9
	.dw octogon_subid1_belowWater_stateA
	.dw octogon_subid1_belowWater_stateB
	.dw octogon_subid1_belowWater_stateC


; Normal movement (moving toward some target position decided already)
octogon_subid1_belowWater_state8:
	call octogon_decVar36IfNonzero
	jr nz,@normalMovement

	; var36 reached 0
	ld (hl),90

	; 50% chance to do check below...
	call getRandomNumber
	rrca
	jr nc,@normalMovement

	; If the direction toward Link has not changed...
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	cp b
	ld h,d
	jr nz,@normalMovement

	; Go to state $0b (fire bubble projectile)
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter1
	ld (hl),$08
	ld l,Enemy.direction
	ld a,(hl)
	and $0c
	add $02
	ld (hl),a
	jp enemySetAnimation

@normalMovement:
	; Will rise above water when counter2 reaches 0
	ld a,(wFrameCounter)
	and $03
	jr nz,++
	ld l,Enemy.counter2
	dec (hl)
	jp z,octogon_beginRisingAboveWater
++
	call ecom_decCounter1
	jr nz,octogon_updateMovementAndAnimation

	ld (hl),60 ; [counter1]

	ld l,Enemy.state
	inc (hl) ; [state] = 9
	ret

;;
; Moves toward target position and updates animation + sound effects accordingly
octogon_updateMovementAndAnimation:
	call octogon_moveTowardTargetPosition

	ld h,d
	ld l,Enemy.var35
	dec (hl)
	ret nz

	ld (hl),$0c

	ld l,Enemy.direction
	ld a,(hl)
	xor $01
	ld (hl),a
	call enemySetAnimation

	ld e,Enemy.subid
	ld a,(de)
	or a
	ld a,SND_LINK_SWIM
	jp nz,playSound

	; Above-water only (subid 0)

;;
octogon_doSplashAnimation:
	ld a,SND_SWORDSPIN
	call playSound

	; Splash animation
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_OCTOGON_SPLASH
	ld e,Enemy.direction
	ld a,(de)
	and $0c
	ld l,Interaction.direction
	ld (hl),a
	jp objectCopyPosition


; Waiting in place until counter1 reaches 0, then will charge at Link.
octogon_subid1_belowWater_state9:
	call ecom_decCounter1
	ret nz

	ld (hl),$0c ; [counter1]

	ld l,e
	inc (hl) ; [state] = $0a

	; Save Link's current position as target position to charge at
	ld l,Enemy.var31
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	; Do some weird math to decide animation
	call ecom_updateAngleTowardTarget
	ld h,d
	ld l,Enemy.direction
	ld a,(hl)
	and $0c
	add a
	ld b,a

	ld e,Enemy.angle
	ld a,(de)
	sub b
	and $1f
	ld b,a
	sub $04
	cp $18
	ret nc

	bit 4,b
	ld a,$04
	jr z,+
	ld a,$0c
+
	add (hl)
	and $0c
	ld (hl),a
	jp enemySetAnimation


; Waiting for a split second before charging
octogon_subid1_belowWater_stateA:
	call ecom_decCounter1
	ret nz

	ld (hl),90

	ld l,e
	ld (hl),$08 ; [state]

	ld l,Enemy.angle
	ldd a,(hl)
	add $04
	and $18
	rrca
	ld (hl),a
	jp enemySetAnimation


; Delay before firing bubble
octogon_subid1_belowWater_stateB:
	call ecom_decCounter1
	ret nz

	ld (hl),60

	ld l,e
	inc (hl) ; [state] = $0c

	ld l,Enemy.direction
	inc (hl)
	ld a,(hl)
	call enemySetAnimation

	call getFreePartSlot
	jr nz,++
	ld (hl),PART_OCTOGON_BUBBLE
	call octogon_initializeProjectile
++
	jp octogon_doSplashAnimation


; Delay after firing bubble
octogon_subid1_belowWater_stateC:
	call ecom_decCounter1
	ret nz

	ld l,e
	ld (hl),$08 ; [state]

	ld l,Enemy.direction
	ld a,(hl)
	and $0c
	ld (hl),a
	jp enemySetAnimation


; Octogon is above water, but Link is below water
octogon_subid1_aboveWater:
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	call ecom_decCounter1
	ret nz
	ld (hl),120
	ld b,PART_OCTOGON_DEPTH_CHARGE
	jp ecom_spawnProjectile


; States $09-$0a used while moving to surface
@state9:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state] = $0a

	ld l,Enemy.direction
	ld a,$11
	ld (hl),a
	call enemySetAnimation

	ld a,SND_ENEMY_JUMP
	call playSound

	ld bc,$0208
	jp enemyBoss_spawnShadow

@stateA:
	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub <($00c0)
	ldi (hl),a
	ld a,(hl)
	sbc >($00c0)
	ld (hl),a

	cp $d0
	ret nc

	cp $c0
	jp nz,ecom_flickerVisibility

	ld (hl),$00

	ld l,e
	ld (hl),$08 ; [state] = 8

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.counter1
	ld (hl),60

	call objectSetInvisible
	jp ecom_killRelatedObj1


; Invisible collision box for the shell
octogon_subid2:
	ld a,Object.direction
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $10
	jr c,+
	ld a,$08
+
	and $0c
	push hl
	ld hl,@data
	rst_addAToHl

	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	ldi a,(hl)
	ld c,(hl)
	ld b,a
	pop hl
	call objectTakePositionWithOffset
	pop hl
	ret

; Data format: collisionRadiusY, collisionRadiusX, Y position, X position
@data:
	.db $06 $0a $0e $00
	.db $0a $06 $00 $f2
	.db $06 $0a $f2 $00
	.db $0a $06 $00 $0e


;;
octogon_subid0_submergeIntoWater:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0d
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.var03
	ld (hl),$01
	ld l,Enemy.counter1
	ld (hl),$10
	ld l,Enemy.var36
	ld (hl),90
	ld l,Enemy.direction
	ld a,$15
	ld (hl),a
	jp enemySetAnimation


;;
octogon_beginRisingAboveWater:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.var03
	ld (hl),$00

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.var36
	ld (hl),90

	ld l,Enemy.direction
	ld a,$10
	ld (hl),a
	jp enemySetAnimation


;;
; Takes current position, fixes it to the closest valid spot above water, and decides
; a value for var30 (target position index).
octogon_fixPositionAboveWater:
	ld a,(wTmpcfc0.octogonBoss.posNeedsFixing)
	or a
	ret z

	xor a
	ld (wTmpcfc0.octogonBoss.posNeedsFixing),a

	ld h,d
	ld l,Enemy.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	call octogon_getClosestTargetPositionIndex
	ld l,e

	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	call octogon_getClosestTargetPositionIndex

	; BUG: supposed to compare 'l' against 'e', not 'a'. As a result octogon may not
	; move out of the way properly if Link surfaces in the same position.
	; (In effect, it only matters when they're both around centre-bottom, and maybe
	; one other spot?)
	cp l
	ld a,l
	jr nz,++
	ld hl,@linkCompensationIndices
	rst_addAToHl
	ld a,(hl)
++
	add a
	ld hl,@data
	rst_addDoubleIndex
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

	ld h,d
	ld l,e
	bit 7,a
	jp nz,octogon_chooseRandomTargetPosition
	jp octogon_loadTargetPosition

; Data format: Y, X, var30 (target position index), unused
@data:
	.db $28 $30 $01 $00
	.db $28 $78 $ff $00
	.db $28 $c0 $09 $00
	.db $58 $30 $02 $00
	.db $00 $00 $ff $00
	.db $58 $c0 $0a $00
	.db $88 $30 $0d $00
	.db $88 $78 $0c $00
	.db $88 $c0 $05 $00

; Corresponding index from this table is used if Link would have surfaced on top of
; octogon.
@linkCompensationIndices:
	.db $01 $00 $01 $06 $00 $08 $03 $08 $05

;;
octogon_fireOctorokProjectile:
	call getFreePartSlot
	ret nz
	ld (hl),PART_OCTOROK_PROJECTILE

;;
; @param	h	Projectile (could be PART_OCTOROK_PROJECTILE or
;			PART_OCTOGON_BUBBLE)
octogon_initializeProjectile:
	ld e,Enemy.direction
	ld a,(de)
	and $0c
	ld b,a
	add a
	ld l,Part.angle
	ld (hl),a

	ld a,b
	rrca
	push hl
	ld hl,@positionOffsets
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld c,(hl)

	pop hl
	call objectCopyPositionWithOffset
	ld a,SND_STRIKE
	jp playSound

@positionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
octogon_decVar36IfNonzero:
	ld h,d
	ld l,Enemy.var36
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

;;
; Moves toward position stored in var31/var32. Increments state and sets counter1 to 30
; when it reaches that position.
octogon_moveTowardTargetPosition:
	ld h,d
	ld l,Enemy.var31
	call ecom_readPositionVars
	sub c
	inc a
	cp $03
	jp nc,ecom_moveTowardPosition

	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jp nc,ecom_moveTowardPosition

	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),30
	ret


;;
; Given a position, this determines the "target position index" (value for var30) which
; that position most closely corresponds to.
;
; @param	bc	Position
; @param[out]	a
; @param[out]	e
octogon_getClosestTargetPositionIndex:
	ld e,$00

@checkY:
	ld a,b
	cp $40
	jr c,@checkX
	ld e,$03
	cp $70
	jr c,@checkX

	ld e,$06
@checkX:
	ld a,c
	cp $50
	jr c,++
	inc e
	cp $a0
	jr c,++

	inc e
++
	ld a,e
	cp $04
	ret nz

	ld e,$00
	ld a,b
	cp $58
	jr c,+
	ld e,$06
+
	ld a,c
	cp $78
	ret c
	inc e
	inc e
	ret
