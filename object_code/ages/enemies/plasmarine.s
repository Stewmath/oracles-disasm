; ==================================================================================================
; ENEMY_PLASMARINE
;
; Variables:
;   counter2: Number of times to do shock attack before firing projectiles
;   var30/var31: Target position?
;   var32: Color (0 for blue, 1 for red)
;   var33: ?
;   var34: Number of projectiles to fire in one attack
; ==================================================================================================
enemyCode7e:
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyBoss_dead

	; Hit by something
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_PLASMARINE_SHOCK
	jr z,@normalStatus

	ld e,Enemy.var2a
	ld a,(de)
	res 7,a
	cp ITEMCOLLISION_L1_SWORD
	call nc,plasmarine_state_switchHook@swapColor

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw plasmarine_state_uninitialized
	.dw plasmarine_state_stub
	.dw plasmarine_state_stub
	.dw plasmarine_state_switchHook
	.dw plasmarine_state_stub
	.dw plasmarine_state_stub
	.dw plasmarine_state_stub
	.dw plasmarine_state_stub
	.dw plasmarine_state8
	.dw plasmarine_state9
	.dw plasmarine_stateA
	.dw plasmarine_stateB
	.dw plasmarine_stateC
	.dw plasmarine_stateD
	.dw plasmarine_stateE
	.dw plasmarine_stateF


plasmarine_state_uninitialized:
	ld a,SPEED_280
	call ecom_setSpeedAndState8
	ld l,Enemy.angle
	ld (hl),$08

	ld l,Enemy.counter1
	ld (hl),$04

	ld l,Enemy.var30
	ld (hl),$58
	inc l
	ld (hl),$78

	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	ld a,ENEMY_PLASMARINE
	ld b,$00
	call enemyBoss_initializeRoom
	jp objectSetVisible83


plasmarine_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justLatched
	.dw @beforeSwitch
	.dw @afterSwitch
	.dw @released

@justLatched:
	xor a
	ld e,Enemy.var33
	ld (de),a
	call enemySetAnimation
	jp ecom_incSubstate

@afterSwitch:
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret nz
	inc a
	ld (de),a
	ld a,SND_MYSTERY_SEED
	call playSound


; This is called from outside "plasmarine_state_switchHook" (ie. when sword slash occurs).
@swapColor:
	ld h,d
	ld l,Enemy.var32
	ld a,(hl)
	xor $01
	ld (hl),a
	inc a
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a


@beforeSwitch:
	ret


@released:
	ld b,$0a
	call ecom_fallToGroundAndSetState
	ret nz
	ld l,Enemy.counter1
	ld (hl),60
	jp plasmarine_decideNumberOfShockAttacks


plasmarine_state_stub:
	ret


; Moving toward centre of room before starting fight
plasmarine_state8:
	call plasmarine_checkCloseToTargetPosition
	jr c,@reachedTarget

	call ecom_decCounter1
	jr nz,++
	ld (hl),$04
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards
++
	call objectApplySpeed
	jr plasmarine_animate

@reachedTarget:
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	jr plasmarine_animate


; 60 frame delay before starting fight
plasmarine_state9:
	call ecom_decCounter1
	jr nz,plasmarine_animate

	ld (hl),60 ; [counter1]
	ld l,e
	inc (hl) ; [state] = $0a

	ld l,Enemy.collisionType
	set 7,(hl)

	call plasmarine_decideNumberOfShockAttacks
	call enemyBoss_beginBoss
	xor a
	jp enemySetAnimation


; Standing in place before charging
plasmarine_stateA:
	call ecom_decCounter1
	jr nz,plasmarine_animate

	inc (hl) ; [counter1] = 1

	ld l,Enemy.animParameter
	bit 0,(hl)
	jr z,plasmarine_animate

	; Initialize stuff for state $0b (charge at Link)
	ld l,Enemy.counter1
	ld (hl),$0c
	ld l,e
	inc (hl) ; [state] = $0b
	ld l,Enemy.speed
	ld (hl),SPEED_300

	ld l,Enemy.var30
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a

plasmarine_animate:
	jp enemyAnimate


; Charging toward Link
plasmarine_stateB:
	call ecom_decCounter1
	jr nz,++
	ld l,e
	inc (hl) ; [state] = $0c
++
	ld l,Enemy.speed
	ld a,(hl)
	sub SPEED_20
	ld (hl),a
	; Fall through

plasmarine_stateC:
	call plasmarine_checkCloseToTargetPosition
	jp nc,ecom_moveTowardPosition

	; Reached target position.
	ld l,Enemy.counter2
	dec (hl)
	ld l,e
	jr z,@fireProjectiles

	; Do shock attack (state $0d)
	ld (hl),$0d ; [state]
	ld l,Enemy.counter1
	ld (hl),65

	ld l,Enemy.damage
	ld (hl),-8

	ld l,Enemy.var32
	ld a,(hl)
	add $04
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PLASMARINE_SHOCK
	ld a,$02
	jp enemySetAnimation

@fireProjectiles:
	ld (hl),$0e ; [state]
	ld l,Enemy.health
	ld a,(hl)
	dec a
	ld hl,@numProjectilesToFire
	rst_addAToHl
	ld e,Enemy.var34
	ld a,(hl)
	ld (de),a

	ld a,$01
	jp enemySetAnimation

; Takes health value as index, returns number of projectiles to fire in one attack
@numProjectilesToFire:
	.db $03 $03 $02 $02 $02 $01 $01


; Shock attack
plasmarine_stateD:
	call ecom_decCounter1
	jr z,@doneAttack

	ld a,(hl)
	and $0f
	ld a,SND_SHOCK
	call z,playSound

	; Update oamFlags based on animParameter
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ld b,$04
	jr z,+
	ld b,$01
+
	ld e,Enemy.var32
	ld a,(de)
	add b
	ld h,d
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	jr plasmarine_animate

@doneAttack:
	ld (hl),60 ; [counter1]
	ld l,e
	ld (hl),$0a ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.damage
	ld (hl),-4

	ld l,Enemy.var32
	ld a,(hl)
	inc a
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PLASMARINE
	xor a
	jp enemySetAnimation


; Firing projectiles
plasmarine_stateE:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jr z,@fire

	inc a
	ret z

	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),60
	xor a
	jp enemySetAnimation

@fire:
	ld (de),a ; [animParameter] = 0

	call getFreePartSlot
	ret nz
	ld (hl),PART_PLASMARINE_PROJECTILE
	inc l
	ld e,Enemy.oamFlags
	ld a,(de)
	dec a
	ld (hl),a ; [projectile.var03]

	ld l,Part.relatedObj1+1
	ld (hl),d
	dec l
	ld (hl),Enemy.start

	ld bc,$ec00
	call objectCopyPositionWithOffset
	ld a,SND_VERAN_FAIRY_ATTACK
	jp playSound


; Decides whether to return to state $0e (fire another projectile) or charge at Link again
plasmarine_stateF:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,Enemy.var34
	dec (hl)
	ld l,e
	jr z,@chargeAtLink

	dec (hl) ; [state] = $0e
	ld a,$01
	jp enemySetAnimation

@chargeAtLink:
	ld (hl),$0a
	ld l,Enemy.counter1
	ld (hl),30

;;
plasmarine_decideNumberOfShockAttacks:
	call getRandomNumber_noPreserveVars
	and $01
	inc a
	ld e,Enemy.counter2
	ld (de),a
	ret

;;
; @param[out]	cflag	c if close enough to target position
plasmarine_checkCloseToTargetPosition:
	ld h,d
	ld l,Enemy.var30
	call ecom_readPositionVars
	sub c
	add $04
	cp $09
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	ret

; TODO: what is this? Unused data?
.db $ec $ec $ec $14 $14 $14 $14 $ec
.db $00 $e8 $e8 $00 $00 $18 $18 $00
