; ==================================================================================================
; ENEMY_CANDLE
;
; Variables:
;   relatedObj1: reference to INTERAC_EXPLOSION while exploding
; ==================================================================================================
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
	ld b,PART_CANDLE_FLAME
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
	ld b,INTERAC_EXPLOSION
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
