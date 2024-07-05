; ==================================================================================================
; ENEMY_DEKU_SCRUB
;
; Variables:
;   var03: Read by ENEMY_BUSH_OR_ROCK to control Z-offset
;   var30: Starts at 2, gets decremented each time one of the scrub's bullets hits itself.
;   var31: Index of ENEMY_BUSH_OR_ROCK
;   var32: "pressedAButton" variable (nonzero when player presses A)
;   var33: Former var03 value (low byte of text index, TX_45XX)
; ==================================================================================================
enemyCode27:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jr nz,@normalStatus

	; ENEMYSTATUS_JUST_HIT

	; Check var30, which is decremented by PART_DEKU_SCRUB_PROJECTILE each time it
	; hits the deku scrub.
	ld e,Enemy.var30
	ld a,(de)
	or a
	ret nz

	; We've been hit twice, go to state $0c and delete the bush.
	ld h,d
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.var31
	ld h,(hl)
	jp ecom_killObjectH

@dead:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp nz,enemyDie

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw dekuScrub_state_uninitialized
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state_stub
	.dw dekuScrub_state8
	.dw dekuScrub_state9
	.dw dekuScrub_stateA
	.dw dekuScrub_stateB
	.dw dekuScrub_stateC
	.dw dekuScrub_stateD


dekuScrub_state_uninitialized:
	call dekuScrub_spawnBush
	ret nz

	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00

	; The value of 'a' here depends on "objectMakeTileSolid".
	; It should be 0 if the enemy spawned on an empty space.
	; In any case it shouldn't matter since this enemy doesn't move.
	call ecom_setSpeedAndState8

	ld l,Enemy.counter1
	inc (hl)

	ld l,Enemy.var30
	ld (hl),$02

	ld l,Enemy.var03
	ld a,(hl)
	ld (hl),$00
	ld l,Enemy.var33
	ld (hl),a
	ret


dekuScrub_state_stub:
	ret


; Waiting for Link to be a certain distance away
dekuScrub_state8:
	ld c,$2c
	call objectCheckLinkWithinDistance
	ret c
	call ecom_decCounter1
	ret nz

	ld (hl),90

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.var03
	ld (hl),$02

	xor a
	call enemySetAnimation
	jp objectSetVisiblec3


; Link is at a good distance, wait a bit longer before emerging from bush
dekuScrub_state9:
	ld c,$2c
	call objectCheckLinkWithinDistance
	jp c,dekuScrub_hideInBush

	call ecom_decCounter1
	jr nz,dekuScrub_animate

	; Emerge from under the bush
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var03
	inc (hl)

	; Calculate angle to shoot
	call objectGetAngleTowardEnemyTarget
	ld hl,dekuScrub_targetAngles
	rst_addAToHl
	ld a,(hl)
	or a
	jr z,dekuScrub_hideInBush

	ld e,Enemy.angle
	ld (de),a
	rrca
	rrca
	sub $02
	ld hl,dekuScrub_fireAnimations
	rst_addAToHl
	ld a,(hl)
	jp enemySetAnimation


; Firing sequence
dekuScrub_stateA:
	ld c,$2c
	call objectCheckLinkWithinDistance
	jr c,dekuScrub_hideInBush

	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,dekuScrub_hideInBush

	ld a,(de)
	dec a
	jr nz,dekuScrub_animate
	ld (de),a

	ld b,PART_DEKU_SCRUB_PROJECTILE
	call ecom_spawnProjectile

dekuScrub_animate:
	jp enemyAnimate


; Go hide in the bush again
dekuScrub_stateB:
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr nz,dekuScrub_animate

	ld h,d
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.var03
	ld (hl),$00
	jp objectSetInvisible


; He's just been defeated
dekuScrub_stateC:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0d

	ld l,Enemy.collisionType
	res 7,(hl)

	ld e,Enemy.var32
	call objectAddToAButtonSensitiveObjectList
	ld a,$07
	call enemySetAnimation


; Waiting for Link to talk to him
dekuScrub_stateD:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,Enemy.var32
	ld a,(de)
	or a
	jr z,dekuScrub_animate

	; Pressed A in front of deku scrub
	ld e,Enemy.var32
	xor a
	ld (de),a

	; Show text
	ld e,Enemy.var33
	ld a,(de)
	ld c,a
	ld b,>TX_4500
	jp showText


;;
dekuScrub_hideInBush:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.counter1
	ld (hl),120

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.var03
	ld (hl),$02
	ld a,$06
	jp enemySetAnimation


; Takes the relative angle between the deku scrub and Link as an index, and the
; corresponding value is the angle at which to shoot a projectile. "0" means can't shoot
; from this angle.
dekuScrub_targetAngles:
	.db $00 $00 $00 $00 $00 $00 $00 $08
	.db $08 $08 $0c $0c $0c $0c $0c $10
	.db $10 $10 $14 $14 $14 $14 $14 $18
	.db $18 $18 $00 $00 $00 $00 $00 $00

dekuScrub_fireAnimations:
	.db $05 $04 $03 $02 $01

;;
; @param[out]	zflag	z if spawned bus successfully
dekuScrub_spawnBush:
	ld b,ENEMY_BUSH_OR_ROCK
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	call objectCopyPosition

	; [child.relatedObj1] = this
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	; Save projectile's index to var31
	ld e,Enemy.var31
	ld a,h
	ld (de),a

	ld l,Enemy.subid
	ld e,l
	ld a,(de)
	ld (hl),a
	xor a
	ret
