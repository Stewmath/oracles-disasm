; ==================================================================================================
; ENEMY_OCTOROK
;
; Variables:
;   counter1: How many frames to wait after various actions.
;   var30: How many frames to walk for.
;   var32: Should be 1, 3, or 7. Lower values make the octorok move and shoot more often.
; ==================================================================================================
enemyCode09:
	call ecom_checkHazards
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead

	; Check ENEMYSTATUS_KNOCKBACK
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@dead:
	ld e,Enemy.subid
	ld a,(de)
	cp $04
	jr nz,++
	ld hl,wKilledGoldenEnemies
	set 0,(hl)
++
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw octorok_state_uninitialized
	.dw octorok_state_stub
	.dw octorok_state_stub
	.dw octorok_state_latchedBySwitchHook
	.dw octorok_state_followingScentSeed
	.dw ecom_blownByGaleSeedState
	.dw octorok_state_stub
	.dw octorok_state_stub
	.dw octorok_state_08
	.dw octorok_state_09
	.dw octorok_state_0a
	.dw octorok_state_0b


octorok_state_uninitialized:
	; Delete self if it's a golden enemy that's been defeated
	ld e,Enemy.subid
	ld a,(de)
	cp $04
	jr nz,++
	ld hl,wKilledGoldenEnemies
	bit 0,(hl)
	jp nz,enemyDelete
++
	; If bit 1 of subid is set, octorok is faster
	rrca
	ld a,SPEED_80
	jr nc,+
	ld a,SPEED_c0
+
	call ecom_setSpeedAndState8AndVisible
	ld (hl),$0a ; [state] = $0a

	; Enable moving toward scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	; Determine range of possible counter1 values, read into 'e' and 'var32'.
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@counter1Ranges
	rst_addAToHl
	ld e,Enemy.var32
	ld a,(hl)
	ld (de),a

	; Decide random counter1, angle, and var30.
	ld e,a
	ldbc $18,$03
	call ecom_randomBitwiseAndBCE
	ld a,e
	ld hl,octorok_counter1Values
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	; Random initial angle
	ld e,Enemy.angle
	ld a,b
	ld (de),a

	ld a,c
	ld hl,octorok_walkCounterValues
	rst_addAToHl
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a
	jp ecom_updateAnimationFromAngle


; For each subid, each byte determines the maximum index of the value that can be read
; from "octorok_counter1Values" below. Effectively, lower values attack more often.
@counter1Ranges:
	.db $07 $07 $03 $03 $01


octorok_state_followingScentSeed:
	ld a,(wScentSeedActive)
	or a
	jr nz,++
	ld a,$08
	ld (de),a ; [state] = 8
	ret
++
	; Set angle toward scent seed (must be cardinal direction)
	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a

	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForTopDownEnemy
	jp enemyAnimate


octorok_state_latchedBySwitchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret

octorok_state_stub:
	ret


; State 8: Octorok decides what to do next after previous action
octorok_state_08:
	; Decide whether to move or shoot based on [var32] & [random number]. If var32 is
	; low, this means it will shoot more often.
	call getRandomNumber_noPreserveVars
	ld h,d
	ld l,Enemy.var32
	and (hl)
	ld l,Enemy.state
	jr nz,@standStill

	; Shoot a projectile after [counter1] frames
	ld (hl),$0b ; [state] = $0b
	ld l,Enemy.counter1
	ld (hl),$10

	; Blue and golden octoroks change direction to face Link before shooting
	ld l,Enemy.subid
	ld a,(hl)
	cp $02
	ret c
	call ecom_updateCardinalAngleTowardTarget
	jp ecom_updateAnimationFromAngle

@standStill:
	inc (hl) ; [state] = $09
	ld bc,octorok_counter1Values
	call addAToBc
	ld l,Enemy.counter1
	ld a,(bc)
	ld (hl),a
	ret


; A random value for counter1 is chosen from here when the octorok changes direction?
; Red octoroks read the whole range, blue octoroks only the first 4, golden ones only the
; first 2.
; Effectively, blue & golden octoroks move more often.
octorok_counter1Values:
	.db 30 45 60 75 45 60 75 90


; State 9: Standing still for [counter1] frames.
octorok_state_09:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state] = $0a (Walking)

	ld e,$03
	ld bc,$0318
	call ecom_randomBitwiseAndBCE

	; Randomly set how many frames to walk
	ld a,e
	ld hl,octorok_walkCounterValues
	rst_addAToHl
	ld a,(hl)
	ld e,Enemy.var30
	ld (de),a

	; Set random angle
	ld e,Enemy.angle
	ld a,c
	ld (de),a

	; 1 in 4 chance of changing direction toward Link (overriding previous angle)
	ld a,b
	or a
	call z,ecom_updateCardinalAngleTowardTarget
	jp ecom_updateAnimationFromAngle


; Values for var30 (how many frames to walk).
octorok_walkCounterValues:
	.db $19 $21 $29 $31


; State $0a: Octorok is walking for [var30] frames.
octorok_state_0a:
	ld h,d
	ld l,Enemy.var30
	dec (hl)
	jr nz,++

	ld l,e
	ld (hl),$08 ; [state] = $08
	ret
++
	call ecom_applyVelocityForTopDownEnemyNoHoles
	jr nz,++

	; Stopped moving, set new angle
	call ecom_setRandomCardinalAngle
	call ecom_updateAnimationFromAngle
++
	jp enemyAnimate


; State $0b: Waiting [counter1] frames, then shooting a projectile
octorok_state_0b:
	call ecom_decCounter1
	ret nz

	ld (hl),$20 ; [counter1] = $20 (wait this many frames after shooting)
	ld l,e
	ld (hl),$09 ; [state] = $09

	ld b,PART_OCTOROK_PROJECTILE
	call ecom_spawnProjectile
	ret nz
	ld a,SND_THROW
	jp playSound
