; ==================================================================================================
; PART_VOLCANO_ROCK
; ==================================================================================================
partCode11:
	ld e,Part.subid
	ld a,(de)
	ld e,Part.state
	rst_jumpTable
	.dw volcanoRock_subid0
	.dw volcanoRock_subid1
	.dw volcanoRock_subid2

volcanoRock_subid0:
	ld a,(de)
	or a
	jr z,@state0

@state1:
	ld c,$16
	call objectUpdateSpeedZAndBounce
	jp c,partDelete
	jp nz,objectApplySpeed

	call getRandomNumber_noPreserveVars
	and $03
	dec a
	ret z
	ld b,a
	ld e,Part.angle
	ld a,(de)
	add b
	and $1f

@setAngleAndSpeed:
	ld (de),a
	jp volcanoRock_subid0_setSpeedFromAngle

@state0:
	ld bc,-$280
	call objectSetSpeedZ
	ld l,e
	inc (hl) ; [state]
	ld l,Part.collisionType
	set 7,(hl)
	call objectSetVisible80
	call getRandomNumber_noPreserveVars
	and $0f
	add $08
	ld e,Part.angle
	jr @setAngleAndSpeed


volcanoRock_subid1:
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw volcanoRock_common_substate2
	.dw volcanoRock_common_substate3
	.dw volcanoRock_common_substate4
	.dw volcanoRock_common_substate5

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.collisionType
	set 7,(hl)

	; Double hitbox size
	ld l,Part.collisionRadiusY
	ld a,(hl)
	add a
	ldi (hl),a
	ldi (hl),a

	; [damage] *= 2
	sla (hl)

	ld l,Part.speed
	ld (hl),SPEED_20

	ld l,Part.speedZ
	ld a,<(-$400)
	ldi (hl),a
	ld (hl),>(-$400)

	; Random angle
	call getRandomNumber_noPreserveVars
	and $1f
	ld e,Part.angle
	ld (de),a

	ld a,$01
	call partSetAnimation
	jp objectSetVisible80

@substate1:
	ld h,d
	ld l,Part.yh
	ld e,Part.zh
	ld a,(de)
	add (hl)
	add $08
	cp $f8
	ld c,$10
	jp c,objectUpdateSpeedZ_paramC

	ld l,Part.state
	inc (hl)
	ld l,Part.counter1
	ld (hl),30
	call objectSetInvisible
	jr volcanoRock_setRandomPosition

volcanoRock_common_substate2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$10 ; [counter1]
	ld l,e
	inc (hl) ; [substate]++
	jp objectSetVisiblec0

volcanoRock_common_substate3:
	call partAnimate
	ld h,d
	ld l,Part.zh
	inc (hl)
	inc (hl)
	ret nz

	call objectReplaceWithAnimationIfOnHazard
	jp c,partDelete

	ld h,d
	ld l,Part.state
	inc (hl)
	ld l,Part.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	jp objectSetVisible82

volcanoRock_common_substate4:
	call partAnimate
	ld c,$16
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	ld l,Part.state
	inc (hl)

	ld l,Part.oamTileIndexBase
	ld (hl),$26

	ld a,$03
	call partSetAnimation
	ld a,SND_STRONG_POUND
	jp playSound

volcanoRock_common_substate5:
	ld e,Part.animParameter
	ld a,(de)
	inc a
	jp z,partDelete
	call volcanoRock_setCollisionSize
	jp partAnimate


volcanoRock_subid2:
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw volcanoRock_common_substate2
	.dw volcanoRock_common_substate3
	.dw volcanoRock_common_substate4
	.dw volcanoRock_common_substate5

@substate0:
	ld a,$01
	ld (de),a ; [substate]

volcanoRock_setRandomPosition:
	call getRandomNumber_noPreserveVars
	ld b,a
	ld hl,hCameraY
	ld e,Part.yh
	and $70
	add $08
	add (hl)
	ld (de),a
	cpl
	inc a
	and $fe
	ld e,Part.zh
	ld (de),a

	ld l,<hCameraX
	ld e,Part.xh
	ld a,b
	and $07
	inc a
	swap a
	add $08
	add (hl)
	ld (de),a
	ld a,$02
	jp partSetAnimation

;;
; @param	a	Angle
volcanoRock_subid0_setSpeedFromAngle:
	ld b,SPEED_80
	cp $0d
	jr c,@setSpeed
	ld b,SPEED_40
	cp $14
	jr c,@setSpeed
	ld b,SPEED_80
@setSpeed:
	ld a,b
	ld e,Part.speed
	ld (de),a
	ret

;;
; @param	a	Value from [animParameter] (should be multiple of 2)
volcanoRock_setCollisionSize:
	dec a
	ld hl,@data
	rst_addAToHl
	ld e,Part.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

@data:
	.db $04 $09
	.db $06 $0b
	.db $09 $0c
	.db $0a $0d
	.db $0b $0e
