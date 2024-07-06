; ==================================================================================================
; PART_TWINROVA_SNOWBALL
; ==================================================================================================
partCode4e:
	jr z,@normalStatus

	; Hit something
	ld e,Part.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_L3_SHIELD
	jr z,@destroy

	res 7,a
	sub ITEMCOLLISION_L2_SWORD
	cp ITEMCOLLISION_SWORDSPIN - ITEMCOLLISION_L2_SWORD + 1
	jp c,@destroy

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.counter1
	ld (hl),30

	ld l,Part.speed
	ld (hl),SPEED_240

	ld a,SND_TELEPORT
	call playSound
	jp objectSetVisible82


; Spawning in, not moving yet
@state1:
	call partCommon_decCounter1IfNonzero
	jr z,@beginMoving

	ld l,Part.animParameter
	bit 0,(hl)
	jr z,@animate

	ld (hl),$00
	ld l,Part.collisionType
	set 7,(hl)
@animate:
	jp partAnimate

@beginMoving:
	ld l,e
	inc (hl) ; [state] = 2

	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a


; Moving toward Link
@state2:
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nc

@destroy:
	ld b,INTERAC_SNOWDEBRIS
	call objectCreateInteractionWithSubid00
	jp partDelete
