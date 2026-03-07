; ==================================================================================================
; ENEMY_ANGLER_FISH_BUBBLE
; ==================================================================================================
enemyCode26:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	call @popBubble

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	; Can bounce off walls 5 times before popping
	ld l,Enemy.counter1
	ld (hl),$05

	ld l,Enemy.speed
	ld (hl),SPEED_100

	ld a,Object.direction
	call objectGetRelatedObject1Var
	bit 0,(hl)
	ld c,$f4
	jr z,+
	ld c,$0c
+
	ld b,$00
	call objectTakePositionWithOffset
	call ecom_updateAngleTowardTarget
	jp objectSetVisible81


; Bubble moving around
@state1:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMY_ANGLER_FISH
	jr nz,@popBubble

	call objectApplySpeed
	call ecom_bounceOffWallsAndHoles
	jr z,@animate

	; Each time it bounces off a wall, decrement counter1
	call ecom_decCounter1
	jr z,@popBubble

@animate:
	jp enemyAnimate

@popBubble:
	ld h,d
	ld l,Enemy.state
	ld (hl),$02

	ld l,Enemy.counter1
	ld (hl),$08

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.knockbackCounter
	ld (hl),$00

	; 1 in 4 chance of item drop
	call getRandomNumber_noPreserveVars
	cp $40
	jr nc,++

	call getFreePartSlot
	jr nz,++
	ld (hl),PART_ITEM_DROP
	inc l
	ld (hl),ITEM_DROP_SCENT_SEEDS

	ld l,Part.invincibilityCounter
	ld (hl),$f0
	call objectCopyPosition
++
	; Bubble pop animation
	ld a,$01
	call enemySetAnimation
	jp objectSetVisible83


; Bubble in the process of popping
@state2:
	call ecom_decCounter1
	jr nz,@animate
	jp enemyDelete
