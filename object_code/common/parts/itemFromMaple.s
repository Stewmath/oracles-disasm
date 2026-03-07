; ==================================================================================================
; PART_ITEM_FROM_MAPLE
; PART_ITEM_FROM_MAPLE_2
; ==================================================================================================
partCode14:
partCode15:
	ld e,Part.subid
	jr z,@normalStatus
	cp PARTSTATUS_DEAD
	jp z,@linkCollectedItem

	; PARTSTATUS_JUST_HIT
	ld h,d
	ld l,Part.subid
	set 7,(hl)
	ld l,Part.state
	ld (hl),$03
	inc l
	ld (hl),$00

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw objectReplaceWithAnimationIfOnHazard
	.dw @state3 ; just hit
	.dw @state4

@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Part.collisionRadiusY
	ld a,$06
	ldi (hl),a
	; collisionRadiusX
	ld (hl),a

	call getRandomNumber
	ld b,a
	and $70
	swap a
	ld hl,@speedValues
	rst_addAToHl
	ld e,Part.speed
	ld a,(hl)
	ld (de),a

	ld a,b
	and $0e
	ld hl,@speedZValues
	rst_addAToHl
	ld e,Part.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	call getRandomNumber
	ld e,Part.angle
	and $1f
	ld (de),a
	call @setOamData
	jp objectSetVisiblec3

@speedValues:
	.db SPEED_080
	.db SPEED_0c0
	.db SPEED_100
	.db SPEED_140
	.db SPEED_180
	.db SPEED_1c0
	.db SPEED_200
	.db SPEED_240

@speedZValues:
	.dw -$180
	.dw -$1c0
	.dw -$200
	.dw -$240
	.dw -$280
	.dw -$2c0
	.dw -$300
	.dw -$340

@state1:
	call objectApplySpeed
	call @setDroppedItemPosition
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr nc,+
	ld h,d
	ld l,Part.collisionType
	set 7,(hl)
	ld l,Part.state
	inc (hl)
+
	jp objectReplaceWithAnimationIfOnHazard

@state3:
	inc e
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.zh
	ld (hl),$00
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld e,Part.var30
	ld (de),a
	call objectSetVisible80
+
	call objectCheckCollidedWithLink
	jp c,@linkCollectedItem
	ld a,$00
	call objectGetRelatedObject1Var
	ldi a,(hl)
	or a
	jr z,+
	ld e,Part.var30
	ld a,(de)
	cp (hl)
	jp z,objectTakePosition
+
	jp partDelete

@state4:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld a,(w1Companion.damage)
	dec a
	ld l,Part.speed
	ld (hl),SPEED_80
	jr z,@substate1
	ld (hl),SPEED_100

@substate1:
	ld hl,w1Companion.damage
	ld a,(hl)
	or a
	jr z,+
	call @moveToMaple
	ret nz
	ld l,Part.substate
	inc (hl)
	ld l,Part.collisionType
	res 7,(hl)
	ld bc,-$40
	jp objectSetSpeedZ

@substate2:
	ld c,$00
	call objectUpdateSpeedZ_paramC
	ld e,Part.zh
	ld a,(de)
	cp $f7
	ret nc
+
	ld a,$01
	ld (w1Companion.damageToApply),a
	ld h,d
	ld l,Part.substate
	ld (hl),$03
	ld l,Part.var03
	ld (hl),$00
	ret

@substate3:
	ld e,Part.var03
	ld a,(de)
	rlca
	ret nc
	jp partDelete

@linkCollectedItem:
	ld a,(wDisabledObjects)
	bit 0,a
	ret nz
	ld e,Part.subid
	ld a,(de)
	and $7f
	ld hl,@obtainedValue
	rst_addAToHl
	ld a,(w1Companion.var2a)
	add (hl)
	ld (w1Companion.var2a),a
	ld a,(de)
	and $7f
	jr z,@func_4e6e
	add a
	ld hl,@itemDropTreasureTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld a,GOLD_JOY_RING
	call cpActiveRing
	ldi a,(hl)
	jr z,+
	cp $ff
	jr z,++
	call cpActiveRing
	jr nz,++
+
	inc hl
++
	ld c,(hl)
	ld a,b
	cp TREASURE_RING
	jr nz,+
	call getRandomRingOfGivenTier
+
	cp TREASURE_POTION
	jr nz,+
	ld a,SND_GETSEED
	call playSound
	ld a,TREASURE_POTION
+
	call giveTreasure
	jp partDelete

@func_4e6e:
	ldbc TREASURE_HEART_PIECE $02
	call createTreasure
	ret nz
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a
	ld hl,wMapleState
	set 7,(hl)
	jp partDelete

; Data format:
;   b0: Treasure to give
;   b1: Ring to check for (in addition to gold joy ring)
;   b2: Amount to give without ring
;   b3: Amount to give with ring
@itemDropTreasureTable:
	.db TREASURE_HEART_PIECE,   $ff            $01 $01
	.db TREASURE_GASHA_SEED,    $ff            $01 $01
	.db TREASURE_RING,          $ff            $01 $01
	.db TREASURE_RING,          $ff            $02 $02
	.db TREASURE_POTION,        $ff            $01 $01
	.db TREASURE_EMBER_SEEDS,   $ff            $05 $0a
	.db TREASURE_SCENT_SEEDS,   $ff            $05 $0a
	.db TREASURE_PEGASUS_SEEDS, $ff            $05 $0a
	.db TREASURE_GALE_SEEDS,    $ff            $05 $0a
	.db TREASURE_MYSTERY_SEEDS, $ff            $05 $0a
	.db TREASURE_BOMBS,         $ff            $04 $08
	.db TREASURE_HEART_REFILL,  BLUE_JOY_RING, $04 $08
	.db TREASURE_RUPEES,        RED_JOY_RING,  RUPEEVAL_005 RUPEEVAL_010
	.db TREASURE_RUPEES,        RED_JOY_RING,  RUPEEVAL_001 RUPEEVAL_002

@setOamData:
	ld e,Part.subid
	ld a,(de)
	ld c,a
	add a
	add c
	ld hl,@oamData
	rst_addAToHl
	ld e,Part.oamTileIndexBase
	ld a,(de)
	add (hl)
	ld (de),a
	inc hl
	; oamFlags
	dec e
	ldi a,(hl)
	ld (de),a
	; oamFlagsBackup
	dec e
	ld (de),a
	ld a,(hl)
	jp partSetAnimation

@oamData:
	.db $10 $02 $10
	.db $0a $01 $00
	.db $08 $00 $00
	.db $08 $00 $00
	.db $00 $02 $0f
	.db $12 $02 $05
	.db $14 $03 $06
	.db $16 $01 $07
	.db $18 $01 $08
	.db $1a $00 $08
	.db $10 $04 $04
	.db $02 $05 $01
	.db $06 $05 $03
	.db $04 $00 $02

@setDroppedItemPosition:
	ld h,d
	ld l,Part.yh
	ld a,(hl)
	cp $f0
	jr c,+
	xor a
+
	cp $20
	jr nc,+
	ld (hl),$20
	jr ++
+
	cp $78
	jr c,++
	ld (hl),$78
++
	ld l,Part.xh
	ld a,(hl)
	cp $f0
	jr c,+
	xor a
+
	cp $08
	jr nc,+
	ld (hl),$08
	ret
+
	cp $98
	ret c
	ld (hl),$98
	ret

@moveToMaple:
	ld l,<w1Companion.yh
	ld b,(hl)
	ld l,<w1Companion.xh
	ld c,(hl)
	push bc
	call objectGetRelativeAngle
	ld e,Part.angle
	ld (de),a
	call objectApplySpeed
	pop bc
	ld h,d
	ld l,Part.yh
	ldi a,(hl)
	cp b
	ret nz
	inc l
	ld a,(hl)
	cp c
	ret

@obtainedValue:
	.db $3c $0f $0a $08 $06 $05 $05 $05
	.db $05 $05 $04 $03 $02 $01 $00
