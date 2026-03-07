; ==================================================================================================
; ENEMY_FACADE
;
; Variables:
;   var03: The attack that has been randomly chosen.
;   var30: The number of Beetles that have been spawned by the Beetle attack.
; ==================================================================================================
enemyCode71:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	ret nz

	; Dead
	ld e,Enemy.collisionType
	ld a,(de)
	or a
	call nz,facade_killSpawnedBeetles

	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,enemyDie
	jp enemyBoss_dead

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw facade_state_uninitialized
	.dw facade_state_stub
	.dw facade_state_stub
	.dw facade_state_stub
	.dw facade_state_stub
	.dw facade_state_stub
	.dw facade_state_stub
	.dw facade_state_stub
	.dw facade_state_waiting
	.dw facade_state_chooseAttackAndBecomeVisible
	.dw facade_state_waitAndRumble
	.dw facade_state_attack
	.dw facade_state_resetAndInvisible

; Do different initialization depending on [subid]:
;   zero:     Just wait.
;   non-zero: Start the fight.
facade_state_uninitialized:
	call ecom_setSpeedAndState8

	ld l,Enemy.yh
	ld (hl),$58
	ld l,Enemy.xh
	ld (hl),$78

	; If subid == 0, jump to enemyBoss_initializeRoom.
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld a,$ff
	ld b,$00
	jp z,enemyBoss_initializeRoom

	; If subid is non-zero, start the fight.
	ld l,Enemy.counter1
	ld (hl),60

	; [state] = 9
	ld l,Enemy.state
	inc (hl)
	ret

facade_state_stub:
	ret

; Waiting for Link to enter the fight. Only entered when subid is 0.
facade_state_waiting:
	; If Link is below $58, the fight is triggered.
	ldh a,(<hEnemyTargetY)
	cp $58
	ret c

	; [state]++
	ld h,d
	ld l,e
	inc (hl)

	; [counter1] = 1
	; facade_state_chooseAttackAndBecomeVisible decrements counter1, and we don't want it to go below 0.
	ld l,Enemy.counter1
	inc (hl)

	ld a,MUS_MINIBOSS
	ld (wActiveMusic),a
	jp playSound

facade_state_chooseAttackAndBecomeVisible:
	; Wait for [counter1] to be zero.
	call ecom_decCounter1
	ret nz

	; [counter1] = $78
	ld a,$78
	ld (hl),a

	; [state]++
	ld l,e
	inc (hl)

	; Enable collision.
	ld l,Enemy.collisionType
	set 7,(hl)

	call setScreenShakeCounter

	; Choose a random attack, biased towards Volcano Rock. Put it in var03.
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,facade_attack_table
	rst_addAToHl
	ld e,Enemy.var03
	ld a,(hl)
	ld (de),a

	ld a,SND_RUMBLE2
	call playSound

	xor a
	call enemySetAnimation

	jp objectSetVisible83

facade_attack_table:
	; Spawn Beetles.
	.db $00
	; Make holes under Link.
	.db $01
	; Spawn Volcano Rocks.
	.db $02
	.db $02

facade_state_waitAndRumble:
	call ecom_decCounter1
	jr z,@nextState

	ld a,(hl)
	and $1f

	; Rumble when [counter1] & $1f == 0.
	ld a,SND_RUMBLE2
	call z,playSound
	jr @onlyAnimate

@nextState:
	; [state]++
	ld l,e
	inc (hl)

	; [substate] = 0, preparing for below.
	inc l
	ld (hl),$00

@onlyAnimate:
	jp enemyAnimate

; Attack, based on the previously chosen value in var03.
; These attacks make use of substate.
facade_state_attack:
	call enemyAnimate

	ld e,Enemy.var03
	ld a,(de)
	rst_jumpTable
	.dw @attack_beetle
	.dw @attack_holeMaker
	.dw @attack_volcanoRock

@attack_beetle:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @@attack_beetle_setup
	.dw @@attack_beetle_wait
	.dw @@attack_beetle_spawn

@@attack_beetle_setup:
	; [substate]++
	ld h,d
	ld l,e
	inc (hl)
	inc l

	; [counter1] = 20
	ld (hl),20
	ret

@@attack_beetle_wait:
	call ecom_decCounter1
	ret nz

	; [counter1] = 70
	ld (hl),70

	; [substate]++
	ld l,e
	inc (hl)
	ret

; Spawn 5 Beetles that fall from the ceiling.
@@attack_beetle_spawn:
	call ecom_decCounter1
	jp z,facade_incrementStateAndFadeOut

	; Spawn Beetles when ([counter1] & $0f) == 0.
	ld a,(hl)
	and $0f
	ret nz

	; We only spawn 5 Beetles at most.
	ld l,Enemy.var30
	ld a,(hl)
	cp $05
	ret nc

	jp facade_spawnBeetle

@attack_holeMaker:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @@attack_holeMaker_setup
	.dw @@attack_holeMaker_animateAndInvisible
	.dw @@attack_holeMaker_spawn

@@attack_holeMaker_setup:
	; [substate] = $01
	ld a,$01
	ld (de),a

	; Set animation $02.
	inc a
	jp enemySetAnimation

@@attack_holeMaker_animateAndInvisible:
	; Wait for [animParameter] == $7f. This happens in 24 frames.
	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	jp z,enemyAnimate

	; [substate]++
	ld l,e
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$b4

	; Disable collision.
	ld l,Enemy.collisionType
	res 7,(hl)

	jp objectSetInvisible

@@attack_holeMaker_spawn:
	call ecom_decCounter1
	jp z,facade_incrementStateAndFadeOut

	; Wait for ([counter1] & $1f) == 0
	ld a,(hl)
	and $1f
	ret nz

	jp facade_spawnHoleMaker

@attack_volcanoRock:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @@attack_volcanoRock_setup
	.dw @@attack_volcanoRock_spawn

@@attack_volcanoRock_setup:
	; substate++
	ld h,d
	ld l,e
	inc (hl)

	; counter1 = $f0
	inc l
	ld (hl),$f0

	; Load animation $01.
	; animParameter is 28 frames of $00 and 32 of $01 in a loop.
	ld a,$01
	jp enemySetAnimation

; Spawn Volcano Rocks.
; The combination of criteria ([counter1] & $0f == 0 && [animParameter] == 1) leads to us spawning 3 groups of 2.
@@attack_volcanoRock_spawn:
	call ecom_decCounter1
	jp z,facade_incrementStateAndFadeOut

	; Only spawn if (counter1 & $0f) == 0
	ld a,(hl)
	and $0f
	ret nz

	; Return if animParameter != 1.
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	ret nz

	ld a,SND_THROW
	call playSound

	jp facade_spawnVolcanoRock

; After the attack, Facade closes its eyes and goes invisible, before choosing another attack.
facade_state_resetAndInvisible:
	; Facade is on animation 2 here.
	; Wait for animParameter to be $ff (24 frames).
	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	jp z,enemyAnimate

	; [state] = $09
	ld l,e
	ld (hl),$09

	ld l,Enemy.counter1
	ld (hl),120

	; Disable collision.
	ld l,Enemy.collisionType
	res 7,(hl)

	jp objectSetInvisible

; Spawn a Beetle with subid $01 (ie, Beetle falls in from sky).
facade_spawnBeetle:
	ld b,ENEMY_BEETLE
	call ecom_spawnEnemyWithSubid01
	ret nz

	; [Beetle.relatedObj1] = Facade
	ld l,Enemy.relatedObj1
	ld a,Enemy
	ldi (hl),a
	ld (hl),d

	; [Facade.var30]++
	ld e,Enemy.var30
	ld a,(de)
	inc a
	ld (de),a

	; Randomize [Beetle.yh].
	call getRandomNumber
	; Save the random number to c to use below.
	ld c,a
	and $70
	add $20
	ld l,Enemy.yh
	ldi (hl),a

	; Randomize [Beetle.xh].
	inc l
	ld a,c
	and $07
	swap a
	add $40
	ld (hl),a

	ret

; Spawn the FACADE_HOLE_MAKER on a random tile on the 3x3 grid of tiles that
; has Link at its centre.
facade_spawnHoleMaker:
	ld b,PART_FACADE_HOLE_MAKER
	call ecom_spawnProjectile
	ret nz

	; Set b and c to random numbers < $1f.
	push hl
	ld bc,$1f1f
	call ecom_randomBitwiseAndBCE
	pop hl

	; [yh] = ([<hEnemyTargetY] + b - $10) & $f0 + $08
	; This chooses a tile from one tile below to one tile above Link,
	; biased to whichever is closer.
	ldh a,(<hEnemyTargetY)
	add b
	sub $10
	and $f0
	add $08
	ld l,Part.yh
	ld (hl),a

	; [xh] = ([<hEnemyTargetX] + c - $10) & $f0 + $08
	; This chooses a tile from one tile left to one tile right of Link,
	; biased to whichever is closer.
	ldh a,(<hEnemyTargetX)
	add c
	sub $10
	and $f0
	add $08
	ld l,Part.xh
	ld (hl),a

	ret

facade_spawnVolcanoRock:
	ld b,PART_VOLCANO_ROCK
	call ecom_spawnProjectile
	ret nz

	; [subid] = 1 - volcano.
	ld l,Part.subid
	inc (hl)

	ret

; This is used by the attack states to move to the next state and set the animation that closes its eyes.
facade_incrementStateAndFadeOut:
	ld l,Enemy.state
	inc (hl)

	ld a,$02
	jp enemySetAnimation

; Kill all the Beetles that were spawned.
facade_killSpawnedBeetles:
	ldhl FIRST_ENEMY_INDEX, Enemy.start
@loop:
	ld l,Enemy.id
	ld a,(hl)
	cp ENEMY_BEETLE
	call z,ecom_killObjectH

	; Loop h from $d0 to $df (all enemy object slots).
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX + 1
	jr c,@loop

	ret
