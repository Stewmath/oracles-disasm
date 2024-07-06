; ==================================================================================================
; PART_GASHA_TREE
; ==================================================================================================
partCode17:
	jr z,@normalStatus
	ld e,Part.subid
	ld a,(de)
	add a
	ld hl,table_501e
	rst_addDoubleIndex
	ld e,Part.var2a
	ld a,(de)
	and $1f
	call checkFlag
	jr z,@normalStatus
	call checkLinkVulnerable
	jr nc,@normalStatus
	ld h,d
	ld l,Part.state
	ld (hl),$02
	ld l,Part.collisionType
	res 7,(hl)
	ld l,Part.subid
	ld a,(hl)
	or a
	jr z,@normalStatus
	ld a,$2a
	call objectGetRelatedObject1Var
	ld (hl),$ff

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	ld a,$26
	call objectGetRelatedObject1Var
	ld e,Part.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	; collisionRadiusX
	inc e
	ld a,(hl)
	ld (de),a
	call objectTakePosition
	ld e,Part.var30
	ld l,$41
	ld a,(hl)
	ld (de),a
	ret

@state1:
	call @func_4fb2
	ret z
	jp partDelete

@func_4fb2:
	ld a,$01
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(de)
	cp (hl)
	ret

@state2:
	call @func_4fb2
	jp nz,partDelete
	ld e,Part.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.speed
	ld (hl),SPEED_100
	ld a,$1a
	call objectGetRelatedObject1Var
	set 6,(hl)
	ld e,Part.subid
	ld a,(de)
	or a
	ld a,$10
	call nz,objectGetAngleTowardLink
	ld e,Part.angle
	ld (de),a
	ld bc,-$140
	jp objectSetSpeedZ

@substate1:
	ld c,$18
	call objectUpdateSpeedZAndBounce
	jr z,+
	call objectApplySpeed
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectCopyPosition
+
	ld e,Part.substate
	ld a,$02
	ld (de),a

@substate2:
	ld c,$18
	call objectUpdateSpeedZAndBounce
	jr nc,func_5010
	call func_5010
	jp partDelete

func_5010:
	call objectCheckTileCollision_allowHoles
	call nc,objectApplySpeed
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectCopyPosition

table_501e:
	.db $f0 $03 $00 $00
	.db $f0 $03 $00 $00
