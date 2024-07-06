; ==================================================================================================
; PART_CUCCO_ATTACKER
; ==================================================================================================
partCode22:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),$18
	ld l,Part.zh
	ld (hl),$fa

	ld a,Object.var30
	call objectGetRelatedObject1Var
	ld a,(hl)
	sub $10
	and $1e
	rrca
	ld hl,@speedVals
	rst_addAToHl
	ld e,Part.speed
	ld a,(hl)
	ld (de),a

	call objectSetVisiblec1

	call getRandomNumber_noPreserveVars
	ld c,a
	and $30
	ld b,a
	swap b
	and $10
	ld hl,@xOrYVals
	rst_addAToHl
	ld a,c
	and $0f
	rst_addAToHl
	bit 0,b
	ld e,Part.yh
	ld c,Part.xh
	jr nz,+
	ld e,c
	ld c,Part.yh
+
	ld a,(hl)
	ld (de),a

	ld a,b
	ld hl,@screenEdgePositions
	rst_addAToHl
	ld e,c
	ld a,(hl)
	ld (de),a
	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

	; Decide animation based on angle
	cp $11
	ld a,$00
	jr nc,+
	inc a
+
	jp partSetAnimation


@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@applySpeedAndAnimate
	ld l,e
	inc (hl)
	jr @applySpeedAndAnimate


@state2:
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
@applySpeedAndAnimate:
	call objectApplySpeed
	jp partAnimate

@screenEdgePositions:
	.db $08 $98 $88 $08

@xOrYVals:
	.db $05 $0e $17 $20 $29 $32 $3b $44
	.db $4d $56 $5f $68 $71 $7a $83 $8c
	.db $05 $0f $19 $23 $2d $37 $41 $4b
	.db $55 $5f $69 $73 $7d $87 $91 $9b

@speedVals:
	.db SPEED_140 SPEED_180 SPEED_1c0 SPEED_200
	.db SPEED_240 SPEED_240 SPEED_280 SPEED_2c0
	.db SPEED_300
