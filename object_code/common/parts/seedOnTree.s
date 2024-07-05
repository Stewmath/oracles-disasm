; ==================================================================================================
; PART_SEED_ON_TREE
; ==================================================================================================
partCode10:
	jr z,@normalStatus
	cp PARTSTATUS_DEAD
	jp z,@dead

	; PARTSTATUS_JUST_HIT
	ld e,Part.state
	ld a,$02
	ld (de),a

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a ; [state]

	ld e,Part.subid
	ld a,(de)
	ld hl,@oamData
	rst_addDoubleIndex
	ld e,Part.oamTileIndexBase
	ld a,(de)
	add (hl)
	ld (de),a ; [oamTileIndexBase]
	inc hl
	dec e
	ld a,(hl)
	ld (de),a ; [oamFlags]
	dec e
	ld (de),a ; [oamFlagsBackup]

	ld a,$01
	call partSetAnimation
	jp objectSetVisiblec3

@oamData:
	.db $12 $02
	.db $14 $03
	.db $16 $01
	.db $18 $01
	.db $1a $00

@state1:
	ret

@state2:
	ret

@state3:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr c,@giveToLink

	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZAndBounce
	ret nc

@giveToLink:
	ld h,d
	ld l,Part.state
	ld (hl),$04
	inc l
	ld (hl),$00
	ret

@state4:
	ld e,Part.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld e,Part.subid
	ld a,(de)
	ld l,a
	add TREASURE_EMBER_SEEDS
	call checkTreasureObtained
	jr c,@giveSeedAndSomething

	; First time getting this seed type
	ld e,Part.substate
	ld a,$01
	ld (de),a

	ld a,l ; [subid]
	ld hl,@textIndices
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_0000
	call showText
	ld c,$06
	jr @giveSeed

@textIndices:
	.db <TX_0029
	.db <TX_0029
	.db <TX_002b
	.db <TX_002c
	.db <TX_002a

@giveSeed:
	ld e,Part.subid
	ld a,(de)
	add TREASURE_EMBER_SEEDS
	jp giveTreasure

@giveSeedAndSomething:
	ld c,$06
	call @giveSeed

@relatedObj2Something:
	ld a,Object.enabled
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	jr z,@delete
	ld a,l
	add Object.var03 - Object.enabled
	ld l,a
	ld (hl),$01
@delete:
	jp partDelete

@substate1:
	call retIfTextIsActive
	jr @relatedObj2Something

@dead:
	ld h,d
	ld l,Part.collisionType
	res 7,(hl)
	ld a,($cfc0)
	or a
	ret nz

	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	jr c,@knockOffTree

	; Don't have satchel
	ld a,d
	ld ($cfc0),a
	ld bc,TX_0035
	jp showText

@knockOffTree:
	ld bc,-$140
	call objectSetSpeedZ
	ld l,Part.health
	ld a,$03
	ld (hl),a
	ld l,Part.state
	ldi (hl),a
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),$02 ; [counter1]
	ld l,Part.speed
	ld (hl),SPEED_100
	call objectGetAngleTowardLink
	ld e,Part.angle
	ld (de),a
	ret
