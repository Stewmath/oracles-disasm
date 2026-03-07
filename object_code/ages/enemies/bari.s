; ==================================================================================================
; ENEMY_BARI
;
; Variables:
;   var30/var31: Initial Y/X position (aka target position; they always hover around this
;                area. For subid 0 (large baris) only.)
;   var32: Counter for "bobbing" of Z position
; ==================================================================================================
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
	ld b,ENEMY_BARI
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
	ld b,INTERAC_KILLENEMYPUFF
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
