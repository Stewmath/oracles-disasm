; ==================================================================================================
; ENEMY_ANGLER_FISH
;
; Variables:
;   relatedObj1: reference to other subid (main <-> antenna)
; ==================================================================================================
enemyCode76:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@justHit

	; ENEMYSTATUS_DEAD
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp z,enemyBoss_dead
	call ecom_killRelatedObj1
	jp enemyDelete

@justHit:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,@fishHit

@antennaHit:
	ld a,Object.invincibilityCounter
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	ld (hl),a
	jr @normalStatus

@fishHit:
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_SCENT_SEED
	jr nz,@normalStatus

	ld h,d
	ld l,Enemy.state
	ld (hl),$0d

	ld l,Enemy.collisionType
	res 7,(hl)

	ld e,Enemy.direction
	ld a,(de)
	and $01
	add $04
	ld (de),a
	call enemySetAnimation

	ld b,INTERAC_EXPLOSION
	call objectCreateInteractionWithSubid00

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,@commonState
	ld a,b
	or a
	jp z,anglerFish_main
	jp anglerFish_antenna

@commonState:
	rst_jumpTable
	.dw anglerFish_state_uninitialized
	.dw anglerFish_state_stub
	.dw anglerFish_state_stub
	.dw anglerFish_state_stub
	.dw anglerFish_state_stub
	.dw anglerFish_state_stub
	.dw anglerFish_state_stub
	.dw anglerFish_state_stub


anglerFish_state_uninitialized:
	ld a,$ff
	ld b,$00
	call enemyBoss_initializeRoom

	; If bit 7 of subid is set, it's already been initialized
	ld e,Enemy.subid
	ld a,(de)
	bit 7,a
	res 7,a
	ld (de),a
	jr nz,@doneInit

	; Subid 1 has no special initialization
	dec a
	jr z,@doneInit

	; Subid 0 initialization; spawn subid 1, set their relatedObj1 to each other
	ld b,ENEMY_ANGLER_FISH
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz
	ld e,Enemy.relatedObj1
	ld l,e
	ld a,Enemy.start
	ld (de),a
	ldi (hl),a
	inc e
	ld (hl),d
	ld a,h
	ld (de),a

	; Make sure subid 0 comes before subid 1, otherwise swap them
	ld a,h
	cp d
	jr nc,@doneInit
	ld l,Enemy.subid
	ld (hl),$80
	ld e,l
	ld a,$01
	ld (de),a
@doneInit:
	jp ecom_setSpeedAndState8


anglerFish_state_stub:
	ret


anglerFish_main:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw anglerFish_main_state8
	.dw anglerFish_main_state9
	.dw anglerFish_main_stateA
	.dw anglerFish_main_stateB
	.dw anglerFish_main_stateC
	.dw anglerFish_main_stateD
	.dw anglerFish_main_stateE
	.dw anglerFish_main_stateF


; Waiting for Link to enter
anglerFish_main_state8:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,$42
	ld c,$80
	call setTile
	ld a,$52
	ld c,$90
	call setTile

	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	ld a,SND_DOORCLOSE
	jp playSound


; Delay before starting fight
anglerFish_main_state9:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.angle
	ld (hl),ANGLE_LEFT
	ld l,Enemy.speed
	ld (hl),SPEED_c0

	jp objectSetVisible82


; Falling to the ground, then the fight will begin
anglerFish_main_stateA:
	ld b,$0c
	ld a,$10
	call objectUpdateSpeedZ_sidescroll_givenYOffset
	jr c,@hitGround

	ld l,Enemy.speedZ+1
	ld a,(hl)
	cp $02
	ret c
	ld (hl),$02
	ret

@hitGround:
	call enemyBoss_beginMiniboss
	call ecom_incState

	ld l,Enemy.counter2
	ld (hl),180

anglerFish_bounceOffGround:
	ld h,d
	ld l,Enemy.speedZ
	ld a,<(-$320)
	ldi (hl),a
	ld (hl),>(-$320)

	ld a,SND_POOF
	jp playSound


; Bouncing around normally
anglerFish_main_stateB:
	call ecom_decCounter2
	call z,anglerFish_main_checkFireProjectile

anglerFish_updatePosition:
	ld b,$0c
	ld a,$10
	call objectUpdateSpeedZ_sidescroll_givenYOffset
	jr nc,anglerFish_applySpeed

	; Hit ground
	call anglerFish_bounceOffGround

	call getRandomNumber_noPreserveVars
	and $10
	add $08
	ld e,Enemy.angle
	ld (de),a

	and $10
	xor $10
	swap a
	ld b,a
	ld e,Enemy.direction
	ld a,(de)
	and $01
	cp b
	call nz,anglerFish_updateAnimation

anglerFish_applySpeed:
	call objectApplySpeed
	call ecom_bounceOffWallsAndHoles
	jp z,enemyAnimate

anglerFish_updateAnimation:
	ld e,Enemy.direction
	ld a,(de)
	xor $01
	ld (de),a
	jp enemySetAnimation


; Firing a projectile
anglerFish_main_stateC:
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,@doneFiring
	dec a
	jr z,anglerFish_updatePosition

	; Time to spawn the projectile
	xor a
	ld (de),a
	call getFreeEnemySlot_uncounted
	jr nz,anglerFish_updatePosition

	ld (hl),ENEMY_ANGLER_FISH_BUBBLE
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld a,SND_FALLINHOLE
	call playSound
	jr anglerFish_updatePosition

@doneFiring:
	ld h,d
	ld l,Enemy.state
	dec (hl)

	ld l,Enemy.direction
	ld a,(hl)
	sub $02
	ld (hl),a
	call enemySetAnimation

	jr anglerFish_updatePosition


; Just hit with a scent seed, falling to ground
anglerFish_main_stateD:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	ret nc

	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),150
	ret


; Vulnerable for [counter1] frames
anglerFish_main_stateE:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speedZ
	ld a,<(-$400)
	ldi (hl),a
	ld (hl),>(-$400)
	ret


; Bouncing back up after being deflated
anglerFish_main_stateF:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll

	ld l,Enemy.speedZ+1
	ld a,(hl)
	or a
	jr nz,anglerFish_applySpeed

	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.counter1
	ld (hl),180

	ld l,Enemy.direction
	ld a,(hl)
	sub $04
	ld (hl),a
	call enemySetAnimation

	ld a,SND_POOF
	jp playSound


anglerFish_antenna:
	ld a,(de)
	cp $08
	jr z,@state8

@state9:
	ld a,Object.direction
	call objectGetRelatedObject1Var
	ld a,(hl)
	push hl

	ld hl,@positionOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)

	pop hl
	call objectTakePositionWithOffset
	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	jp nz,objectSetInvisible

	ld a,(wFrameCounter)
	rrca
	ret c
	jp ecom_flickerVisibility

@positionOffsets:
	.db $f0 $f6
	.db $f0 $0a
	.db $f0 $f6
	.db $f0 $0a
	.db $fc $f7
	.db $fc $09

@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_ANGLER_FISH_ANTENNA

	ld l,Enemy.collisionRadiusY
	ld a,$03
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.oamTileIndexBase
	ld (hl),$1e

	ld l,Enemy.oamFlagsBackup
	ld a,$0d
	ldi (hl),a
	ld (hl),a

	ld a,$06
	jp enemySetAnimation

;;
; Changes state to $0c if conditions are appropriate to fire a projectile.
anglerFish_main_checkFireProjectile:
	ld e,Enemy.yh
	ld a,(de)
	cp $5c
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	sub $38
	cp $70
	ret nc

	ld (hl),180
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.direction
	ld a,(hl)
	add $02
	ld (hl),a
	jp enemySetAnimation
