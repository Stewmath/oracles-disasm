; ==================================================================================================
; ENEMY_KING_MOBLIN
;
; Variables:
;   counter2: ?
;   relatedObj2: Instance of PART_KING_MOBLIN_BOMB
;   var30/var31: Object indices for two ENEMY_KING_MOBLIN_MINION instances
;   var32: Target x-position to walk toward to grab bomb
;   var33: Signal from ENEMY_KING_MOBLIN_MINION to trigger warp to the outside
; ==================================================================================================
enemyCode7f:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

	; Collision occurred

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_BOMB
	jr nz,@normalStatus

	ld a,SND_BOSS_DAMAGE
	call playSound

	; Determine speed based on health
	ld e,Enemy.health
	ld a,(de)
	dec a
	ld hl,@speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a

	jr @normalStatus

; Indexed by current health value
@speeds:
	.db SPEED_1c0, SPEED_1c0
	.db SPEED_140, SPEED_140
	.db SPEED_0c0, SPEED_0c0

@dead:
	call checkLinkCollisionsEnabled
	ret nc

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.health
	ld (hl),a ; [health] = $01

	ld l,Enemy.state
	ld (hl),$12

	ld l,Enemy.angle
	ld (hl),$00
	ld l,Enemy.speed
	ld (hl),SPEED_300

	ld l,Enemy.invincibilityCounter
	ld (hl),$00

	ld a,$06
	call enemySetAnimation

@normalStatus:
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	or a
	ret nz

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw kingMoblin_state_uninitialized
	.dw kingMoblin_state_stub
	.dw kingMoblin_state_stub
	.dw kingMoblin_state_stub
	.dw kingMoblin_state_stub
	.dw kingMoblin_state_stub
	.dw kingMoblin_state_stub
	.dw kingMoblin_state_stub
	.dw kingMoblin_state8
	.dw kingMoblin_state9
	.dw kingMoblin_stateA
	.dw kingMoblin_stateB
	.dw kingMoblin_stateC
	.dw kingMoblin_stateD
	.dw kingMoblin_stateE
	.dw kingMoblin_stateF
	.dw kingMoblin_state10
	.dw kingMoblin_state11
	.dw kingMoblin_state12
	.dw kingMoblin_state13
	.dw kingMoblin_state14
	.dw kingMoblin_state15


kingMoblin_state_uninitialized:
	ld a,ENEMY_KING_MOBLIN
	ld (wEnemyIDToLoadExtraGfx),a

	ld a,PALH_8c
	call loadPaletteHeader

	ld a,SNDCTRL_STOPMUSIC
	call playSound

	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	dec a
	ld (wActiveMusic),a

	ld b,$02
	call checkBEnemySlotsAvailable
	ret nz

	call @spawnMinion
	ld e,Enemy.var30
	ld (de),a

	call @spawnMinion
	ld l,Enemy.subid
	inc (hl)
	ld e,Enemy.var31
	ld (de),a
	ld a,SPEED_c0
	call ecom_setSpeedAndState8
	call objectSetVisible83
	ld a,$02
	jp enemySetAnimation

;;
; @param[out]	a,h	Object index
@spawnMinion:
	call getFreeEnemySlot_uncounted
	ld (hl),ENEMY_KING_MOBLIN_MINION
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	ld a,h
	ret


kingMoblin_state_stub:
	ret


; Waiting for Link to move in to start the fight
kingMoblin_state8:
	ld hl,w1Link.xh
	ld a,(hl)
	sub $40
	cp $20
	jr nc,kingMoblin_animate

	ld l,<w1Link.zh
	ld a,(hl)
	or a
	jr nz,kingMoblin_animate

	ld l,<w1Link.direction
	ld (hl),DIR_UP

	call checkLinkVulnerable
	ret nc

	call clearAllParentItems
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	; Make stairs disappear
	ld c,$61
	ld a,TILEINDEX_STANDARD_FLOOR
	call setTile

	; Poof at stairs
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_PUFF
	ld l,Interaction.yh
	ld (hl),$68
	ld l,Interaction.xh
	ld (hl),$18
++
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$18

kingMoblin_animate:
	jp enemyAnimate


; Delay before showing text
kingMoblin_state9:
	call ecom_decCounter1
	jr nz,kingMoblin_animate

	ld l,e
	inc (hl) ; [state] = $0a

	call checkIsLinkedGame
	ld bc,TX_2f19
	jr z,+
	ld bc,TX_2f1a
+
	jp showText


; Starting fight
kingMoblin_stateA:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0b

	ld l,Enemy.counter2
	ld (hl),30

	ld l,Enemy.var30
	ld b,(hl)
	ld c,e
	ld a,$02
	ld (bc),a ; [minion1.state] = $02
	inc l
	ld b,(hl)
	ld (bc),a ; [minion2.state] = $02

	call enemyBoss_beginBoss
	xor a
	jp enemySetAnimation


; Facing backwards while picking up a bomb
kingMoblin_stateB:
	call ecom_decCounter2
	jr nz,kingMoblin_animate

	ld b,PART_KING_MOBLIN_BOMB
	call ecom_spawnProjectile
	ret nz

	call ecom_incState

kingMoblin_initBombPickupAnimation:
	ld e,Enemy.health
	ld a,(de)
	dec a
	ld hl,@counter2Vals
	rst_addAToHl
	ld e,Enemy.counter2
	ld a,(hl)
	ld (de),a

	ld a,$04
	jp enemySetAnimation

@counter2Vals:
	.db 10 20 28 45 45 45


; Will raise bomb over head in [counter2] frames?
kingMoblin_stateC:
	call kingMoblin_checkMoveToCentre
	ret nz

	call ecom_decCounter2
	ret nz

	ld l,Enemy.state
	inc (hl) ; [state] = $0d

	; Set counter2 based on health
	ld l,Enemy.health
	ld a,(hl)
	dec a
	ld hl,@counter2Vals
	rst_addAToHl
	ld e,Enemy.counter2
	ld a,(hl)
	ld (de),a

	; Update bomb's position if it hasn't exploded
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $05
	jr z,+
	ld bc,$f0f2
	call objectCopyPositionWithOffset
+
	ld a,$02
	jp enemySetAnimation

; Indexed by [health]-1
@counter2Vals:
	.db 5, 10, 12, 15, 15, 15


; Delay before throwing bomb
kingMoblin_stateD:
	call kingMoblin_checkMoveToCentre
	ret nz

	call ecom_decCounter2
	ret nz

	ld (hl),30
	ld l,Enemy.state
	inc (hl) ; [state] = $0e

	; Decide angle of bomb's movement based on link's position
	call objectGetAngleTowardEnemyTarget
	ld b,a
	sub $0c
	cp $07
	jr c,++

	ld b,$0c
	rlca
	jr c,++

	ld b,$13
++
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $05
	jr z,++

	; Throw bomb
	ld (hl),$03 ; [bomb.state] = $03
	ld l,Part.angle
	ld (hl),b
	ld l,Part.speedZ
	ld (hl),<(-$180)
	inc l
	ld (hl),>(-$180)
++
	ld a,$05
	jp enemySetAnimation


; Delay after throwing bomb
kingMoblin_stateE:
	call ecom_decCounter2
	ret nz
	ld l,e
	inc (hl) ; [state] = $0f
	ld a,$02
	jp enemySetAnimation


; Waiting for something to do
kingMoblin_stateF:
	ld a,Object.id
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp PART_KING_MOBLIN_BOMB
	jp nz,kingMoblin_moveToCentre

	; Do several checks to see if king moblin can pick up the bomb.

	; Is the state ok?
	ld l,Part.state
	ld a,(hl)
	cp $04
	jr nz,kingMoblin_animate2

	; Is it above the ledge?
	ld l,Part.yh
	ldi a,(hl)
	cp $36
	jr nc,kingMoblin_animate2

	; Is it reachable on the x axis?
	inc l
	ld a,(hl) ; [bomb.xh]
	sub $30
	cp $41
	jr nc,kingMoblin_animate2

	; Bomb can be grabbed.

	; Is the bomb close enough to grab without walking?
	ld e,Enemy.xh
	ld a,(de)
	ld b,a
	sub (hl)
	add $08
	cp $11
	jr c,kingMoblin_grabBomb

	; No; must move toward it
	ld a,(hl)
	cp b
	ld h,d
	ld l,Enemy.var32
	ld (hl),a
	ld b,$11 ; state $11
	jp kingMoblin_setAngleStateAndAnimation

kingMoblin_grabBomb:
	ld a,Object.state
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $05
	jr z,++
	ld (hl),$01
	ld bc,$0800
	call objectCopyPositionWithOffset
++
	ld h,d
	ld l,Enemy.state
	ld (hl),$0c
	jp kingMoblin_initBombPickupAnimation


; Moving to centre of screen
kingMoblin_state10:
	ld e,Enemy.xh
	ld a,(de)
	sub $4e
	cp $05
	jr nc,++

	ld h,d
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter2
	ld (hl),30
	xor a
	jp enemySetAnimation
++
	call objectApplySpeed

kingMoblin_animate2:
	jp enemyAnimate


; Moving toward bomb
kingMoblin_state11:
	call kingMoblin_checkMoveToCentre
	ret nz

	call objectApplySpeed
	ld h,d
	ld l,Enemy.xh
	ld e,Enemy.var32
	ld a,(de)
	sub (hl)
	add $08
	cp $11
	jr c,kingMoblin_grabBomb
	jp enemyAnimate


; Just died
kingMoblin_state12:
	call objectApplySpeed
	ld e,Enemy.yh
	ld a,(de)
	cp $0c
	ret nc

	call ecom_incState

	ld l,Enemy.angle
	ld (hl),$10
	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.speedZ
	ld a,<(-$160)
	ldi (hl),a
	ld (hl),>(-$160)

	ld a,60
	jp setScreenShakeCounter


; Falling to ground
kingMoblin_state13:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jp nc,objectApplySpeed

	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),150
	ld l,Enemy.yh
	ld (hl),$20
	ret


; Wait for signal from ENEMY_KING_MOBLIN_MINION to go to state $15?
kingMoblin_state14:
	ld e,Enemy.var33
	ld a,(de)
	or a
	jr nz,@gotoState15

	ld a,(wFrameCounter)
	rrca
	ret c

	call ecom_decCounter1
	ret nz

	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter2
	ld (hl),30
	xor a
	jp enemySetAnimation

@gotoState15:
	call ecom_incState
	ld l,Enemy.counter2
	ld (hl),98
	ret


; All bombs at top of screen explode, then initiates warp outside
kingMoblin_state15:
	call ecom_decCounter2
	jr z,@warpOutside

	; Explosion every 32 frames
	ld a,(hl)
	dec a
	and $1f
	ret nz

	ld a,(hl)
	and $60
	rrca
	swap a
	ld hl,@explosionPositions
	rst_addAToHl

	ld c,(hl)
	ld b,$08
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_EXPLOSION
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c

	call getTileAtPosition
	ld c,l
	ld a,$a1
	jp setTile

@warpOutside:
	ld hl,wPresentRoomFlags+$09
	set 0,(hl)

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call setGlobalFlag
	ld a,GLOBALFLAG_16
	call setGlobalFlag

	ld hl,@warpDest
	jp setWarpDestVariables

@explosionPositions:
	.db $68 $38 $58 $48

@warpDest:
	m_HardcodedWarpA ROOM_AGES_009, $00, $45, $03


;;
; Updates state and angle values to move king moblin to centre of screen, if there is no
; bomb on screen. Sets state to $10 while moving, $0b when reached centre.
;
; @param[out]	zflag	nz if state changed
kingMoblin_checkMoveToCentre:
	ld a,Object.id
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp PART_KING_MOBLIN_BOMB
	ret z

;;
kingMoblin_moveToCentre:
	ld h,d
	ld l,Enemy.xh
	ld a,(hl)
	sub $4e
	cp $05
	jr nc,@moveTowardCentre

	; Reached centre
	ld l,Enemy.counter2
	ld (hl),30
	ld b,$0b
	xor a
	jr kingMoblin_setStateAndAnimation

@moveTowardCentre:
	cp $b0
	ld b,$10

kingMoblin_setAngleStateAndAnimation:
	ld a,ANGLE_RIGHT
	jr nc,+
	ld a,ANGLE_LEFT
+
	ld e,Enemy.angle
	ld (de),a
	swap a
	rlca

kingMoblin_setStateAndAnimation:
	ld l,Enemy.state
	ld (hl),b
	call enemySetAnimation
	or d
	ret
