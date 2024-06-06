; ==============================================================================
; PARTID_JABU_JABUS_BUBBLES
; Bubble spawned from Jabu Jabu?
; ==============================================================================
partCode16:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c0
	set 7,(hl)
	ld l,$cd
	ld a,(hl)
	cp $50
	ld bc,$ff80
	jr c,+
	ld bc,$0080
+
	ld l,$d2
	ld (hl),c
	inc l
	ld (hl),b
	call getRandomNumber_noPreserveVars
	ld b,a
	and $07
	ld e,$c6
	ld (de),a
	ld a,b
	and $18
	swap a
	rlca
	ld hl,@table_5fa7
	rst_addAToHl
	ld e,$d0
	ld a,(hl)
	ld (de),a
	ld a,b
	and $e0
	swap a
	add a
	ld e,$c7
	ld (de),a
	ld e,$c2
	ld a,(de)
	call partSetAnimation
	jp objectSetVisible82
@table_5fa7:
	.db $1e $28
	.db $32 $3c
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	inc l
	ldd a,(hl)
	ld (hl),a
	ld l,e
	inc (hl)
+
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
	ret
@state2:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
+
	ld l,$d2
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	ld l,$cc
	ld e,l
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
@state3:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	cp $f0
	jp nc,partDelete
	ld h,d
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
	ld l,$c7
	dec (hl)
	and $0f
	ret nz
	ld l,$d0
	ld a,(hl)
	sub $05
	cp $13
	ret c
	ld (hl),a
	ret


; ==============================================================================
; PARTID_GROTTO_CRYSTAL
; ==============================================================================
partCode24:
	jr z,@normalStatus
	ld a,(wSwitchState)
	ld h,d
	ld l,$c2
	xor (hl)
	ld (wSwitchState),a
	ld l,$e4
	res 7,(hl)
	ld a,$01
	call partSetAnimation
	; sarcophagus when it breaks
	ldbc, INTERACID_SARCOPHAGUS $80
	jp objectCreateInteraction
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	ret nz
	inc a
	ld (de),a
	call getThisRoomFlags
	bit 6,(hl)
	jr z,+
	ld h,d
	ld l,$e4
	res 7,(hl)
	ld a,$01
	call partSetAnimation
+
	call objectMakeTileSolid
	ld h,$cf
	ld (hl),$0a
	jp objectSetVisible83


; ==============================================================================
; PARTID_WALL_ARROW_SHOOTER
; ==============================================================================
partCode25:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c2
	ld a,(hl)
	swap a
	rrca
	ld l,$c9
	ld (hl),a
+
	call partCommon_decCounter1IfNonzero
	ret nz
	ld e,$c2
	ld a,(de)
	bit 0,a
	ld e,$cd
	ldh a,(<hEnemyTargetX)
	jr z,+
	ld e,$cb
	ldh a,(<hEnemyTargetY)
+
	ld b,a
	ld a,(de)
	sub b
	add $10
	cp $21
	ret nc
	ld e,$c6
	ld a,$21
	ld (de),a
	ld hl,table_6080
	
	ld e,$c2
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_ENEMY_ARROW
	inc l
	inc (hl)
	call objectCopyPositionWithOffset
	ld l,$c9
	ld e,l
	ld a,(de)
	ld (hl),a
	ret

table_6080:
	.db $fc $00 ; shooting up
	.db $00 $04 ; shooting right
	.db $04 $00 ; shooting down
	.db $00 $fc ; shooting left


; ==============================================================================
; PARTID_SPARKLE
; ==============================================================================
partCode26:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call partCommon_decCounter1IfNonzero
	jr nz,@counter1NonZero
	inc l
	ldd a,(hl)
	ld (hl),a
	ld l,$f0
	ld a,(hl)
	cpl
	add $01
	ldi (hl),a
	ld a,(hl)
	cpl
	adc $00
	ld (hl),a
@counter1NonZero:
	ld e,Part.xh
	ld a,(de)
	ld b,a
	dec e
	ld a,(de)
	ld c,a
	ld l,$d2
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld e,$f0
	ld a,(de)
	ld c,a
	inc e
	ld a,(de)
	ld b,a
	ld e,$d3
	ld a,(de)
	ld h,a
	dec e
	ld a,(de)
	ld l,a
	add hl,bc
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld h,d
	ld l,$ce
	ld e,$d4
	ld a,(de)
	add (hl)
	ldi (hl),a
	ld a,(hl)
	adc $00
	jp z,partDelete
	ld (hl),a
	cp $e8
	jr c,@animate
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
@animate:
	jp partAnimate
@state0:
	ld h,d
	ld l,e
	inc (hl)
	call objectGetZAboveScreen
	ld l,$cf
	ld (hl),a
	ld e,$c3
	ld a,(de)
	or a
	jr z,@var03_00
	ld (hl),$f0
@var03_00:
	call getRandomNumber_noPreserveVars
	and $0c
	ld hl,table_6114
	rst_addAToHl
	ld e,Part.var30
	ldi a,(hl)
	ld (de),a

	; Part.var31
	inc e
	ldi a,(hl)
	ld (de),a

	ld e,Part.speedZ
	ldi a,(hl)
	ld (de),a

	ld e,Part.counter1
	ld a,(hl)
	ld (de),a

	inc e
	dec a
	add a
	ld (de),a
	jp objectSetVisible81
table_6114:
	.db $fa $ff $56 $0c
	.db $f7 $ff $54 $0a
	.db $f2 $ff $5c $0e
	.db $f5 $ff $58 $10


; ==============================================================================
; PARTID_TIMEWARP_ANIMATION
; ==============================================================================
partCode2b:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,@state1
	inc a
	ld (de),a
	ld h,d
	ld l,$c0
	set 7,(hl)
@state1:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	add $04
	cp $f4
	jp nc,partDelete
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $03
	ld e,$c2
	ld a,(de)
	jr c,@relatedObj1_stateLessThan3
	bit 1,a
	jp nz,partDelete
@relatedObj1_stateLessThan3:
	ld l,$61
	xor (hl)
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible83


; ==============================================================================
; PARTID_DONKEY_KONG_FLAME
; ==============================================================================
partCode2c:
	jp nz,partDelete
	ld a,($cfd0)
	or a
	jr z,+
	call objectCreatePuff
	jp partDelete
+
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Part.speed
	ld (hl),$1e

	ld e,Part.subid
	ld a,(de)
	swap a
	add $08
	ld l,Part.angle
	ld (hl),a

	bit 4,a
	jr z,+
	ld l,$cb
	ld (hl),$fe
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,table_629f
	rst_addAToHl
	ld a,(hl)
	ld hl,@table_61aa
	rst_addAToHl
	ld e,$cd
	ld a,(hl)
	ld (de),a
	ld a,$01
	call partSetAnimation
+
	jp objectSetVisible82
@table_61aa:
	; xh vals, 3/8 chance of $b8, 5/8 chance of $d8
	.db $d8 $b8
@state1:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	jr nc,@animate
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$f1
	ld (hl),$04
	ld l,$d4
	xor a
	ldi (hl),a
	ld (hl),a
	jr @animate
@state2:
	ld h,d
	ld l,$f1
	dec (hl)
	jr nz,@animate
	ld (hl),$04
	ld l,e
	inc (hl)
	inc l
	ld (hl),$00
@animate:
	jp partAnimate
@state3:
	ld e,$c5
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	call func_6248
	call func_6270
	ret c
	ld h,d
	ld l,$c4
	inc (hl)
	ret
@substate1:
	ld bc,$1000
	call objectGetRelativeTile
	cp $19
	jp z,func_6248
	ld h,d
	ld l,$c5
	dec (hl)
	ld l,$c6
	xor a
	ld (hl),a
	ld l,$d4
	ldi (hl),a
	ld (hl),a
	jr @substate0
@state4:
	ld e,$cb
	ld a,(de)
	cp $b0
	jp nc,partDelete
	call func_6248
	call func_6270
	ret nc
	ld h,d
	ld l,$c4
	ld (hl),$02
	xor a
	ld l,$d4
	ldi (hl),a
	ld (hl),a
	ld l,$c6
	ld (hl),a

	ld e,Part.subid
	ld a,(de)
	swap a
	rrca
	inc l
	add (hl)
	inc (hl)
	ld bc,table_6238
	call addAToBc
	ld l,$c9
	ld a,(bc)
	ldd (hl),a
	and $10
	swap a
	cp (hl)
	ret z
	ld (hl),a
	jp partSetAnimation
table_6238:
	; angle vals
	.db $08 $18 $18 $08 $08 $ff $ff $ff
	.db $18 $18 $08 $08 $18 $18 $18 $18

func_6248:
	call objectGetShortPosition
	cp $91
	jr nz,func_6256
	pop hl
	call objectCreatePuff
	jp partDelete
func_6256:
	call partCommon_getTileCollisionInFront
	jr nz,func_6261
	call objectApplySpeed
	jp partAnimate
func_6261:
	ld e,$c9
	ld a,(de)
	xor $10
	ld (de),a
	ld e,$c8
	ld a,(de)
	xor $01
	ld (de),a
	jp partSetAnimation
func_6270:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	ret c
	ld a,(hl)
	cp $02
	jr c,+
	ld (hl),$02
	dec l
	ld (hl),$00
+
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$10
	ld bc,$1000
	call objectGetRelativeTile
	sub $19
	or a
	ret nz
	call getRandomNumber
	and $07
	ld hl,table_629f
	rst_addAToHl
	ld e,$c5
	ld a,(hl)
	ld (de),a
	rrca
	ret
table_629f:
	.db $00 $00 $01 $00
	.db $01 $00 $01 $00


; ==============================================================================
; PARTID_VERAN_FAIRY_PROJECTILE
; ==============================================================================
partCode2d:
	jr nz,@notNormalStatus
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,@noRelatedObj
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call partCommon_checkOutOfBounds
	jr z,@notNormalStatus
	call objectApplySpeed
	jp partAnimate
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$3c
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	call objectSetVisible82
	ld a,SND_VERAN_FAIRY_ATTACK
	jp playSound
@noRelatedObj:
	call objectCreatePuff
@notNormalStatus:
	jp partDelete


; ==============================================================================
; PARTID_SEA_EFFECTS
; When this object exists, it applies the effects of whirlpool and pollution tiles.
; It's a bit weird to put this functionality in an object...
; ==============================================================================
partCode2e:
	ld e,Part.state
	ld a,(de)
	or a
	jr nz,@initialized

	inc a
	ld (de),a
	jp @setCounter1To20

@initialized:
	ld a,(w1Link.state)
	sub LINK_STATE_NORMAL
	ret nz

	ld (wDisableScreenTransitions),a
	call checkLinkCollisionsEnabled
	jr c,+

	; Check if diving underwater
	ld a,(wLinkSwimmingState)
	rlca
	ret nc
+
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.start
	call objectTakePosition

	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECTID_RAFT
	ld a,$05
	jr nz,+
	add a
+
	ld h,d
	ld l,Part.counter2
	ld (hl),a

	; Get position in bc
	ld l,Part.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)

	ld hl,hFF8B
	ld (hl),$06
--
	ld hl,hFF8B
	dec (hl)
	jr z,@applyCurrentsDirection

	ld h,d
	ld l,Part.counter2
	dec (hl)
	ld a,(hl)
	ld hl,@positionOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a
	call getTileAtPosition
	ld e,a
	ld a,l
	ldh (<hFF8A),a
	ld hl,harmfulWaterTilesCollisionTable
	call lookupCollisionTable_paramE
	jr nc,--

	rst_jumpTable
	.dw @collision0
	.dw @collision1
	.dw @collision2

@applyCurrentsDirection:
	ld a,(wTilesetFlags)
	and TILESETFLAG_OUTDOORS
	jr z,@setCounter1To20
	call objectGetTileAtPosition
	ld hl,currentsCollisionTable
	call lookupCollisionTable
	jr nc,@setCounter1To20
	ld c,a
	ld b,$3c
	call updateLinkPositionGivenVelocity

@setCounter1To20:
	ld e,$c6
	ld a,$20
	ld (de),a
	ret

@collision0:
	ldh a,(<hFF8A)
	call convertShortToLongPosition
	ld e,$cb
	ld a,(de)
	ldh (<hFF8F),a
	ld e,$cd
	ld a,(de)
	ldh (<hFF8E),a
	call objectGetRelativeAngleWithTempVars
	xor $10
	ld b,a
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,$2b
	ldd a,(hl)
	or (hl)
	ret nz
	ld (hl),$01
	inc l
	ld (hl),$18
	inc l
	ld (hl),b
	inc l
	ld (hl),$0c
	ld l,$25
	ld (hl),$fe
	ld a,SND_DAMAGE_LINK
	jp playSound

@collision1:
	ld a,(wLinkObjectIndex)
	rrca
	jr c,@collision2
	ld a,(wLinkSwimmingState)
	or a
	ret z

@collision2:
	ldh a,(<hFF8A)
	call convertShortToLongPosition
	ld e,$cb
	ld a,(de)
	ldh (<hFF8F),a
	ld e,$cd
	ld a,(de)
	ldh (<hFF8E),a
	sub c
	inc a
	cp $03
	jr nc,@func_63d6
	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jr nc,@func_63d6
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,$0b
	ld (hl),b
	ld l,$0d
	ld (hl),c
	ld a,$02
	ld (wLinkForceState),a
	xor a
	ld (wLinkStateParameter),a
	jp clearAllParentItems

@func_63d6:
	ld a,$ff
	ld (wDisableScreenTransitions),a
	call objectGetRelativeAngleWithTempVars
	ld c,a
	call partCommon_decCounter1IfNonzero
	ld a,(hl)
	and $1c
	rrca
	rrca
	ld hl,@speedValues
	rst_addAToHl
	ld a,(hl)
	ld b,a
	cp $19
	jr c,+
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,Object.speed
	ld (hl),$00
+
	jp updateLinkPositionGivenVelocity

@positionOffsets:
	.db $00 $f7
	.db $0a $00
	.db $00 $09
	.db $fd $fb
	.db $00 $00
	.db $00 $f5
	.db $0b $00
	.db $00 $0b
	.db $fa $fa
	.db $00 $00

@speedValues:
	.db $3c $32 $28 $1e
	.db $19 $14 $0f $0a
	
harmfulWaterTilesCollisionTable:
	.dw @overworld
	.dw @stub
	.dw @dungeon
	.dw @stub
	.dw @underwater
	.dw @dungeon
@overworld:
	.db TILEINDEX_POLLUTION $00
	.db TILEINDEX_WHIRLPOOL $01
@stub:
	.db $00
@underwater:
	.db TILEINDEX_POLLUTION $00
	.db TILEINDEX_WHIRLPOOL $02
	.db $00
@dungeon:
	; 4 different variants of the currents pits in underwater dungeons
	.db $3c $02
	.db $3d $02
	.db $3e $02
	.db $3f $02
	.db $00
	
;;
; Entries are the 4 directional currents tiles
currentsCollisionTable:
	.dw @overworld
	.dw @stub
	.dw @dungeon
	.dw @stub
	.dw @stub
	.dw @dungeon
@dungeon:
	.db $54 ANGLE_UP
	.db $55 ANGLE_RIGHT
	.db $56 ANGLE_DOWN
	.db $57 ANGLE_LEFT
	.db $00
@overworld:
	.db $e0 ANGLE_UP
	.db $e1 ANGLE_DOWN
	.db $e2 ANGLE_LEFT
	.db $e3 ANGLE_RIGHT
@stub:
	.db $00


; ==============================================================================
; PARTID_BABY_BALL
; Turns Link into a baby
; ==============================================================================
partCode2f:
	jp nz,partDelete
	ld a,Object.health 
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,@veranFairyBeat
	ld b,h
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$14
	ld l,$c6
	ld (hl),$1e
	ld a,SND_BLUE_STALFOS_CHARGE
	call playSound
	jp objectSetVisible82
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld l,e
	inc (hl)
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	ld a,SND_BEAM2
	call playSound
	jr @animate
@state2:
	ld c,Enemy.state
	ld a,(bc)
	cp $03
	jr nz,@applySpeed
	; Veran Fairy moving and attacking
	ld c,Enemy.var03
	ld a,(bc)
	cp $02
	jr nz,@applySpeed
	ld a,(wFrameCounter)
	and $0f
	jr nz,@applySpeed
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
@applySpeed:
	call partCommon_checkOutOfBounds
	jr z,@delete
	call objectApplySpeed
@animate:
	jp partAnimate
@veranFairyBeat:
	call objectCreatePuff
@delete:
	jp partDelete


; ==============================================================================
; PARTID_SUBTERROR_DIRT
; ==============================================================================
partCode32:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,SND_DIG
	call playSound
@state1:
	call partAnimate
	ld e,$e1
	ld a,(de)
	ld e,$da
	ld (de),a
	or a
	ret nz
	jp partDelete


; ==============================================================================
; PARTID_ROTATABLE_SEED_THING
; ==============================================================================
partCode33:
	ld e,$c2
	ld a,(de)
	ld b,a
	and $03
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	
@subid0:
	ld a,(de)
	or a
	jr z,@subid0_state0
@func_64f2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld e,$f0
	ld a,(de)
	ld (hl),a
	jp @func_657e
@subid0_state0:
	ld c,b
	rlc c
	ld a,$01
	jr nc,+
	ld a,$ff
+
	ld h,d
	ld l,$f1
	ldd (hl),a
	rlc c
	ld a,$3c
	jr nc,+
	add a
+
	ld (hl),a
	ld l,$c6
	ld (hl),a
@func_6515:
	ld a,b
	rrca
	rrca
	and $03
	ld e,$c8
	ld (de),a
	call @func_6588
	call objectMakeTileSolid
	ld h,$cf
	ld (hl),$0a
	call objectSetVisible83
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_ROTATABLE_SEED_THING
	inc l
	ld (hl),$03
	ld l,$d6
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	ld h,d
	ld l,$c4
	inc (hl)
	ret
	
@subid1:
	ld a,(de)
	jr z,@@state0
	ld h,d
	ld l,$c3
	ld a,(hl)
	ld l,$d8
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	and (hl)
	ret z
	jr @func_64f2
@@state0:
	call @subid0_state0
@func_6551:
	ld e,$c2
	ld a,(de)
	bit 4,a
	ld hl,wToggleBlocksState
	jr z,+
	ld hl,wActiveTriggers
+
	ld e,$d8
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret
	
@subid2:
	ld a,(de)
	or a
	jr z,@subid2_state0
	ld h,d
	ld l,$f2
	ld e,l
	ld b,(hl)
	ld l,$c3
	ld c,(hl)
	ld l,$d8
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(hl)
	and c
	ld c,a
	xor b
	ret z
	ld a,c
	ld (de),a
@func_657e:
	ld h,d
	ld l,$f1
	ld e,$c8
	ld a,(de)
	add (hl)
	and $03
	ld (de),a
@func_6588:
	ld b,a
	ld hl,@table_6598
	rst_addDoubleIndex
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld a,b
	jp partSetAnimation
	
@table_6598:
	.db $06 $04
	.db $04 $04
	.db $04 $06
	.db $04 $04

@subid2_state0:
	ld c,b
	rlc c
	ld a,$01
	jr nc,+
	ld a,$ff
+
	rlc c
	jr nc,+
	add a
+
	ld h,d
	ld l,$f1
	ld (hl),a
	call @func_6515
	call @func_6551
	ld e,$c3
	ld a,(de)
	and (hl)
	ld e,$f2
	ld (de),a
	ret
@subid3:
	ld a,(de)
	or a
	jr z,func_65d5
	ld a,$21
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(hl)
	ld (de),a
	ld l,$e6
	ld e,l
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

func_65d5:
	ld a,$0b
	call objectGetRelatedObject1Var
	ld bc,$0c00
	call objectTakePositionWithOffset
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$cf
	ld (hl),$f2
	ret


; ==============================================================================
; PARTID_RAMROCK_SEED_FORM_LASER
; ==============================================================================
partCode34:
	ld e,Part.state
	ld a,(de)
	cp $03
	; moving towards you in state3
	jr nc,+
	ld a,Object.xh
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld e,Part.xh
	ld (de),a
+
	ld e,Part.counter2
	ld a,(de)
	dec a
	ld (de),a
	and $03
	; pulsate between red and blue
	jr nz,+
	ld e,Part.oamFlags
	ld a,(de)
	xor $01
	ld (de),a
+
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw partDelete
@state0:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,Part.speed
	ld (hl),SPEED_2c0
	ld l,Part.angle
	ld (hl),ANGLE_DOWN

	; counter1 - $07, counter2 - $03
	ld l,Part.counter1
	ld a,$07
	ldi (hl),a
	ld (hl),$03
	call objectSetVisible80

@state1:
	ld e,Part.var03
	ld a,(de)
	or a
	jr z,+
	call partCommon_decCounter1IfNonzero
	jp nz,objectApplySpeed
+
	ld e,Part.var03
	ld a,(de)
	cp $06
	jr z,+
	call getFreePartSlot
	ret nz

	; spawn self with var03+1
	ld (hl),PARTID_RAMROCK_SEED_FORM_LASER
	inc l
	ld (hl),$0e
	ld l,e
	ld a,(de)
	inc a
	ld (hl),a

	ld e,Part.relatedObj1
	ld l,e
	ld a,Part
	ldi (hl),a
	ld a,d
	ld (hl),a
	call objectCopyPosition
+
	ld e,Part.state
	ld a,$02
	ld (de),a

@state2:
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	ret z

	ld e,Part.state
	ld a,$03
	ld (de),a

	ld e,$c6
	ld a,$07
	ld (de),a

@state3:
	ld e,Part.var03
	ld a,(de)
	cp $06
	jp z,partDelete
	call partCommon_decCounter1IfNonzero
	jp nz,objectApplySpeed
	ld e,$c2
	ld (de),a

	ld e,Part.state
	ld a,$04
	ld (de),a
	ret


; ==============================================================================
; PARTID_RAMROCK_GLOVE_FORM_ARM
; ==============================================================================
partCode35:
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,partDelete
	ld e,Part.subid
	ld a,(de)
	rlca
	jr c,@subidBit7SetArm
	ld a,(wLinkGrabState)
	or a
	call z,objectPushLinkAwayOnCollision
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@subidBit7SetArm:
	ld e,$c6
	ld a,(de)
	or a
	jr nz,+
	ld e,$c4
	ld a,(de)
	cp $04
	jr z,+
	ld e,$da
	ld a,(de)
	xor $80
	ld (de),a
+
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @subidBit7SetArm_state0
	.dw @subidBit7SetArm_state1
	.dw @subidBit7SetArm_state2
	.dw @state3
	.dw @subidBit7SetArm_state4
	.dw @subidBit7SetArm_state5

@state0:
	call @state0func_6731
	ld e,$d7
	ld a,(de)
	ld e,$f0
	ld (de),a
	call state0func_6956
	ld a,(de)
	swap a
	ld (de),a
	or $80
	ld (hl),a
	call state0func_6992
	ld l,$d6
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	ld e,Part.subid
	ld a,(de)
	swap a
	ld hl,@@table_6703
	rst_addAToHl
	ld a,(hl)
	ld e,$c9
	ld (de),a
	ld a,SND_THROW
	call playSound
	jp objectSetVisiblec0
@@table_6703:
	.db ANGLE_LEFT, ANGLE_RIGHT

@subidBit7SetArm_state0:
	call @state0func_6731
	call state0func_6956
	call state0func_6992
	ld l,$d6
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	ld l,$f0
	ld e,l
	ld a,(de)
	ld (hl),a
	ld a,$01
	call partSetAnimation
	ld e,Part.subid
	ld a,(de)
	and $0f
	add $0a
	ld e,$c6
	ld (de),a
	ld e,$e4
	ld a,(de)
	res 7,a
	ld (de),a
	jp objectSetVisiblec1

@state0func_6731:
	ld a,$01
	ld (de),a
	ld e,$cf
	ld a,$81
	ld (de),a
	ret

@state1:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld e,$f1
	ld a,(de)
	or a
	jr nz,@func_675e
	ret

@subidBit7SetArm_state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,$c7
	ld a,(hl)
	or a
	jr nz,@func_675e
	inc (hl)
	ld bc,$fe80
	jp objectSetSpeedZ
	
@func_675e:
	ld a,$78
	jr ++

@func_6762:
	ld a,$14
++
	ld e,$d0
	ld (de),a
	ld a,$31
	call objectGetRelatedObject1Var
	inc (hl)
	ld e,$c4
	ld a,$03
	ld (de),a
	call func_693b
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	ret

@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld a,$90
	ld (wLinkGrabState2),a
	xor a
	ld l,$ca
	ldd (hl),a
	ld ($d00a),a
	ld (hl),$10
	ld l,$d0
	ld (hl),$14
	ld l,$c7
	ld (hl),$60
	call func_69a5
	ld l,$b7
	ld e,Part.subid
	ld a,(de)
	swap a
	jp unsetFlag
@@dropLinkHeldItem:
	call dropLinkHeldItem
@@substate2:
@@substate3:
	ld a,SND_BIGSWORD
	call playSound
	jr @func_675e
@@substate1:
	call func_69a5
	ldi a,(hl)
	cp $11
	jr z,@@dropLinkHeldItem
	ld a,($d221)
	or a
	jr nz,@state2func_67c9
	ld e,$f3
	ld (de),a
	ret

@state2func_67c9:
	ld h,d
	ld l,$c7
	ld a,(hl)
	or a
	ret z
	dec (hl)
	jr nz,+
	dec l
	ld (hl),$14
	ld l,$f2
	inc (hl)
+
	ld l,$f3
	ld a,(hl)
	or a
	jr nz,+
	ld a,SND_MOVEBLOCK
	ld (hl),a
	call playSound
+
	ld h,d
	ld l,$c9
	ld c,(hl)
	ld l,$d0
	ld b,(hl)
	call updateLinkPositionGivenVelocity
	jp objectApplySpeed

@subidBit7SetArm_state2:
	ld a,$0b
	call objectGetRelatedObject1Var
	ld e,$cb
	ld a,(de)
	sub (hl)
	cpl
	inc a
	cp $10
	jr c,+
	ld a,(de)
	inc a
	ld (de),a
+
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $02
	ret z
	jp @func_675e

@state3:
	ld e,$c6
	ld a,(de)
	or a
	jr z,@state3func_681a
	dec a
	ld (de),a
	jp objectApplySpeed
	
@state3func_681a:
	call func_693b
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	call objectApplySpeed
	call state3func_6970
	ret nz
	ld e,Part.subid
	ld a,(de)
	rlca
	jr c,@state3func_6864
	ld h,d
	ld l,$e4
	set 7,(hl)
	ld e,$f2
	ld a,(de)
	or a
	jr z,+
	xor a
	ld (de),a
	call func_69a5
	ld l,$ab
	ld a,(hl)
	or a
	jr nz,+
	ld (hl),$3c
	ld l,$b5
	inc (hl)
	ld a,SND_BOSS_DAMAGE
	call playSound
+
	ld e,$c6
	ld a,$3c
	ld (de),a
	call func_69a5
	ld l,$b7
	ld e,Part.subid
	ld a,(de)
	swap a
	call setFlag
	jr ++
	
@state3func_6864:
	call objectSetInvisible
++
	ld e,$c4
	ld a,$04
	ld (de),a
	ret

@state4:
	ld h,d
	ld l,$e4
	set 7,(hl)
	call @state4func_68d7
	call partCommon_decCounter1IfNonzero
	ret nz
	call func_69a5
	ldi a,(hl)
	cp $12
	ret nz
	ld a,(hl)
	bit 5,a
	jr nz,@state4func_689e
	ld e,Part.subid
	ld a,(de)
	cp (hl)
	jr z,@state4func_689e
	call objectGetAngleTowardLink
	cp $10
	ret nz
	ld a,(w1Link.direction)
	or a
	ret nz
	ld h,d
	ld l,$e4
	res 7,(hl)
	jp objectAddToGrabbableObjectBuffer
	
@state4func_689e:
	ld a,SND_EXPLOSION
	call playSound
	call objectGetAngleTowardLink
	ld h,d
	ld l,$c9
	ld (hl),a
	ld l,$c4
	ld (hl),$05
	ld l,$c6
	ld (hl),$02
	ld l,$d0
	ld (hl),$78
	call func_69a5
	ld l,$b7
	ld e,Part.subid
	ld a,(de)
	swap a
	jp unsetFlag

@subidBit7SetArm_state4:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $04
	jr z,@state4func_68d7
	ld e,l
	ld (de),a
	ld l,$c9
	ld e,l
	ld a,(hl)
	ld (de),a
	jp objectSetVisible

@state4func_68d7:
	call func_693b
	ld h,d
	ld l,$cb
	ld (hl),b
	ld l,$cd
	ld (hl),c
	ret

@state5:
	call partCommon_getTileCollisionInFront
	jr nz,@state5func_68fe
	call objectApplySpeed
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$03
	ld e,$d0
	ld a,(de)
	or a
	jp z,@state5func_68fe
	sub $0a
	jr nc,+
	xor a
+
	ld (de),a
	ret

@state5func_68fe:
	ld h,d
	ld l,$c4
	ld (hl),$06
	ld l,$c6
	ld (hl),$3c
	ld l,$d0
	ld (hl),$00
	ret

@subidBit7SetArm_state5:
	ld a,$10
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(hl)
	sub $19
	jr nc,+
	xor a
+
	ld (de),a
	ld l,$c4
	ld a,(hl)
	cp $03
	jp nz,objectApplySpeed
	jp @func_6762

@state6:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,$e4
	res 7,(hl)
	call func_69a5
	inc l
	ld a,(hl)
	bit 5,a
	jr z,+
	ld a,$80
	ld (hl),a
+
	jp @func_6762
	
func_693b:
	ld e,Part.subid
	ld a,(de)
	swap a
	ld c,$0c
	rrca
	jr nc,+
	ld c,$f4
+
	ld e,$f0
	ld a,(de)
	ld h,a
	ld l,$8b
	ldi a,(hl)
	add $0c
	ld b,a
	inc l
	ld a,(hl)
	add c
	ld c,a
	ret

state0func_6956:
	ld e,Part.subid
	ld a,(de)
	and $0f
	cp $02
	ret z
	call getFreePartSlot
	ld a,PARTID_RAMROCK_GLOVE_FORM_ARM
	ldi (hl),a
	ld a,(de)
	inc a
	ld (hl),a
	ld e,$f0
	ld l,e
	ld a,(de)
	ld (hl),a
	ld l,Part.subid
	ld e,l
	ret

state3func_6970:
	call func_693b
	ld e,$03
	ld h,d
	ld l,$cb
	ld a,e
	add b
	cp (hl)
	jr c,++
	sub e
	sub e
	cp (hl)
	jr nc,++
	ld l,$cd
	ld a,e
	add c
	cp (hl)
	jr c,++
	sub e
	sub e
	cp (hl)
	jr nc,++
	xor a
	ret
++
	or d
	ret

state0func_6992:
	push hl
	ld a,(hl)
	and $10
	swap a
	ld hl,@table_69a3
	rst_addAToHl
	ld c,(hl)
	ld b,$fc
	pop hl
	jp objectCopyPositionWithOffset
@table_69a3:
	.db $f8 $08

func_69a5:
	ld e,$f0
	ld a,(de)
	ld h,a
	ld l,$82
	ret


; ==============================================================================
; PARTID_CANDLE_FLAME
; ==============================================================================
partCode36:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMYID_CANDLE
	jp nz,partDelete

	ld b,h
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
	call objectSetVisible81

@state1:
	; Check parent's speed
	ld h,b
	ld l,Enemy.speed
	ld a,(hl)
	cp SPEED_100
	jr z,@state2

	ld a,$02
	ld (de),a ; [state]

	push bc
	dec a
	call partSetAnimation
	pop bc

@state2:
	ld h,b
	ld l,Enemy.enemyCollisionMode
	ld a,(hl)
	cp ENEMYCOLLISION_PODOBOO
	jp z,partDelete

	call objectTakePosition
	ld e,Part.zh
	ld a,$f3
	ld (de),a
	jp partAnimate


; ==============================================================================
; PARTID_VERAN_PROJECTILE
; ==============================================================================
partCode37:
	jp nz,partDelete

	ld e,Part.subid
	ld a,(de)
	or a
	jp nz,veranProjectile_subid1


; The "core" projectile spawner
veranProjectile_subid0:
	ld a,Object.collisionType
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jr z,@delete

	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.zh
	ld (hl),$fc
	jp objectSetVisible81


; Moving upward
@state1:
	ld h,d
	ld l,Part.zh
	dec (hl)

	ld a,(hl)
	cp $f0
	jr nz,@animate

	; Moved high enough to go to next state

	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),129
	jr @animate


; Firing projectiles every 8 frames until counter1 reaches 0
@state2:
	call partCommon_decCounter1IfNonzero
	jr z,@delete

	ld a,(hl)
	and $07
	jr nz,@animate

	; Calculate angle in 'b' based on counter1
	ld a,(hl)
	rrca
	rrca
	and $1f
	ld b,a

	; Create a projectile
	call getFreePartSlot
	jr nz,@animate
	ld (hl),PARTID_VERAN_PROJECTILE
	inc l
	inc (hl) ; [subid] = 1

	ld l,Part.angle
	ld (hl),b

	call objectCopyPosition

@animate:
	jp partAnimate

@delete:
	ldbc INTERACID_PUFF,$80
	call objectCreateInteraction
	jp partDelete


; An individiual projectile
veranProjectile_subid1:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.speed
	ld (hl),SPEED_280

	ld l,Part.collisionRadiusY
	ld a,$04
	ldi (hl),a
	ld (hl),a

	call objectSetVisible81

	ld a,SND_VERAN_PROJECTILE
	call playSound

	ld a,$01
	jp partSetAnimation


; Moving to ground as well as in normal direction
@state1:
	ld h,d
	ld l,Part.zh
	inc (hl)
	jr nz,@state2

	ld l,e
	inc (hl) ; [state]


; Just moving normally
@state2:
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nz
	jp partDelete


; ==============================================================================
; PARTID_BALL
; Ball for the shooting gallery
; ==============================================================================
partCode38:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jp z,partDelete
	ld h,d
	ld l,$c4
	ld a,(hl)
	cp $02
	jr nc,@normalStatus
	ld (hl),$02
@normalStatus:
	ld h,d
	ld l,$c6
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c9
	ld (hl),$10
	call objectSetVisible81
	call getRandomNumber
	and $0f
	ld hl,@table_6ad7
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,$d0
	or a
	jr nz,@func_6ad0
	ld (hl),$64
	ld a,SND_THROW
	jp playSound
; 1/4 chance of being a slow ball
@func_6ad0:
	ld (hl),$3c
	ld a,SND_FALLINHOLE
	jp playSound
@table_6ad7:
	.db $01 $01 $01 $01
	.db $00 $00 $00 $00
	.db $00 $00 $00 $00
	.db $00 $00 $00 $00
	
@state1:
	call objectCheckWithinScreenBoundary
	jp nc,func_6c17
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,@objectApplySpeed
	call @func_6b00
	jr nc,@objectApplySpeed
	jp z,func_6c17
	jp func_6bf6
	
@objectApplySpeed:
	jp objectApplySpeed
	
@func_6b00:
	scf
	push af
	ld a,(hl)
	cp $0f
	jr z,+
	pop af
	ccf
	ret
+
	pop af
	ret
	
@state2:
	ld a,$03
	ld (de),a
	ld a,SND_CLINK
	call playSound
	ld h,d
	ld l,$c6
	ld (hl),$00
	ld l,$d0
	ld (hl),$78
	ld l,$ec
	ld a,(hl)
	ld l,$c9
	ld (hl),a
	ret
	
@state3:
	call objectCheckWithinScreenBoundary
	jp nc,func_6c17
	ld b,$ff
	call func_6b5f
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	call @func_6b00
	jr nc,+
	jp z,func_6c17
	call func_6c02
+
	ld b,$02
	call func_6b5f
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	call @func_6b00
	jr nc,+
	jp z,func_6c17
	call func_6c08
+
	ld b,$ff
	call func_6b5f
	call partAnimate
	jp objectApplySpeed
	
func_6b5f:
	ld e,$cd
	ld a,(de)
	add b
	ld (de),a
	ret
	
func_6b65:
	call objectGetTileAtPosition
	ld a,l
	ldh (<hFF8C),a
	ld c,(hl)
	call func_6b71
	jr func_6bca
	
func_6b71:
	ld a,$ff
	ld ($cfd5),a
	xor a
func_6b77:
	ldh (<hFF8B),a
	ld hl,table_6bab
	rst_addAToHl
	ld a,(hl)
	cp c
	jr nz,func_6b9f
	ld a,($ccd6)
	and $7f
	cp $01
	ldh a,(<hFF8B)
	ld ($cfd5),a
	jr z,+
	add $04
+
	ld hl,bitTable
	add l
	ld l,a
	ld a,($ccd4)
	or (hl)
	ld ($ccd4),a
	jr func_6baf

func_6b9f:
	ldh a,(<hFF8B)
	inc a
	cp $04
	jr nz,func_6b77
	ld hl,$ccd6
	dec (hl)
	ret
	
table_6bab:
	.db $d9
	.db $d7
	.db $dc
	.db $d8

func_6baf:
	call objectGetShortPosition
	ld c,a
	ld a,$a0
	call setTile
	ld h,d
	ld l,$c6
	ld (hl),$03
	ld a,($ccd6)
	and $7f
	cp $01
	ret nz
	ld a,SND_SWITCH
	jp playSound

func_6bca:
	ld a,($cfd5)
	cp $ff
	ret z
	ld a,$04
--
	ldh (<hFF8B),a
	ldbc, INTERACID_FALLING_ROCK $04
	ld a,($cfd5)
	cp $02
	jr c,+
	ldbc, INTERACID_FALLING_ROCK $05
+
	call objectCreateInteraction
	jr nz,+
	ld l,$4b
	ldh a,(<hFF8C)
	call setShortPosition
	ld l,$49
	ldh a,(<hFF8B)
	dec a
	ld (hl),a
	jr nz,--
+
	ret

func_6bf6:
	ld a,SND_STRIKE
	call playSound
	ld a,$01
	ld ($cfd6),a
	jr func_6c27

func_6c02:
	call func_6c0e
	jp func_6b65
	
func_6c08:
	call func_6c0e
	jp func_6b65

func_6c0e:
	xor a
	ld ($cfd6),a
	ld hl,$ccd6
	inc (hl)
	ret
	
func_6c17:
	xor a
	ld ($cfd6),a
	ld a,($ccd6)
	and $7f
	jr nz,func_6c27
	ld a,SND_ERROR
	call playSound
func_6c27:
	ld hl,$ccd6
	set 7,(hl)
	jp partDelete


; ==============================================================================
; PARTID_HEAD_THWOMP_FIREBALL
; ==============================================================================
partCode39:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$1e
	ld l,$d4
	ld a,$20
	ldi (hl),a
	ld (hl),$fc
	call getRandomNumber_noPreserveVars
	and $10
	add $08
	ld e,$c9
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@table_6c66
	rst_addAToHl
	ld e,$d0
	ld a,(hl)
	ld (de),a
	call objectSetVisible82
	ld a,SND_FALLINHOLE
	jp playSound
@table_6c66:
	.db $0f $19 $23 $2d
@state1:
	call objectApplySpeed
	ld h,d
	ld l,$d4
	ld e,$ca
	call add16BitRefs
	dec l
	ld a,(hl)
	add $20
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld a,(de)
	cp $b0
	jp nc,partDelete
	add $06
	ld b,a
	ld l,$cd
	ld c,(hl)
	call checkTileCollisionAt_allowHoles
	jr nc,@animate
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld (hl),$26
	ld a,$01
	call partSetAnimation
	ld a,SND_BREAK_ROCK
	jp playSound
@state2:
	ld e,$e1
	ld a,(de)
	bit 7,a
	jp nz,partDelete
	ld hl,@table_6cc0
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
@animate:
	jp partAnimate
@table_6cc0:
	.db $04 $09
	.db $06 $0b
	.db $09 $0c
	.db $0a $0d
	.db $0b $0e


; ==============================================================================
; PARTID_VIRE_PROJECTILE
; ==============================================================================
partCode3a:
	jr z,+	 
	ld e,$ea
	ld a,(de)
	res 7,a
	cp $04
	jp c,partDelete
	jp func_6e4a
+
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	
@subid0:
	ld a,(de)
	or a
	jr z,@subid0_state0
@func_6ceb:
	call partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplySpeed
	jp partAnimate
@subid0_state0:
	call func_6e50
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	call func_6e5d
	jp objectSetVisible80
	
@subid1:
	ld a,(de)
	or a
	jr nz,@func_6ceb
	call func_6e50
	call func_6e2f
	ld e,$c3
	ld a,(de)
	or a
	ret nz
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	sub $02
	and $1f
	ld b,a
	ld e,$01
;;
; @param	b	angle of new part
; @param	e	subid of new part
@func_6d22:
	call getFreePartSlot
	ld (hl),PARTID_VIRE_PROJECTILE
	inc l
	ld (hl),e
	inc l
	inc (hl)
	ld l,$c9
	ld (hl),b
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	jp objectCopyPosition

@subid2:
	ld a,(de)
	rst_jumpTable
	.dw @subid2_state0
	.dw @subid2_state1
	.dw @subid2_state2
	.dw @func_6ceb
@subid2_state0:
	ld h,d
	ld l,$db
	ld a,$03
	ldi (hl),a
	ld (hl),a
	ld l,$c3
	ld a,(hl)
	or a
	jr z,@fimc_6d5e
	ld l,e
	ld (hl),$03
	call func_6e5d
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82
	
@fimc_6d5e:
	call func_6e50
	ld l,$f0
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld b,$19
	cp $10
	jr nc,+
	ld b,$2d
	cp $0a
	jr nc,+
	ld b,$41
+
	ld e,$d0
	ld a,b
	ld (de),a
	jp objectSetVisible80
	
@subid2_state1:
	ld h,d
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	sub c
	add $02
	cp $05
	jr nc,@func_6dba
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jr nc,@func_6dba
	ldbc INTERACID_PUFF $02
	call objectCreateInteraction
	ret nz
	ld e,$d8
	ld a,$40
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld e,$c4
	ld a,$02
	ld (de),a
	jp objectSetInvisible

@func_6dba:
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
	call objectApplySpeed
	jp partAnimate
	
@subid2_state2:
	ld a,$21
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	ld b,$05
	call checkBPartSlotsAvailable
	ret nz
	ld c,$05
-
	ld a,c
	dec a
	ld hl,@table_6df8
	rst_addAToHl
	ld b,(hl)
	ld e,$02
	call @func_6d22
	dec c
	jr nz,-
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c9
	ld (hl),$1d
	call func_6e5d
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82
@table_6df8:
	.db $03 $08 $0d $13 $18
	
@subid3:
	ld a,(de)
	or a
	jr z,@subid3_state0
	call partCommon_decCounter1IfNonzero
	jp z,func_6e4a
	inc l
	dec (hl)
	jr nz,+
	ld (hl),$07
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
+
	call objectApplySpeed
	jp partAnimate

@subid3_state0:
	call func_6e50
	ld l,$c6
	ld (hl),$f0
	inc l
	ld (hl),$07
	ld l,$db
	ld a,$02
	ldi (hl),a
	ld (hl),a
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	
func_6e2f:
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld b,$1e
	cp $10
	jr nc,+
	ld b,$2d
	cp $0a
	jr nc,+
	ld b,$3c
+
	ld e,$d0
	ld a,b
	ld (de),a
	jp objectSetVisible80

func_6e4a:
	call objectCreatePuff
	jp partDelete

func_6e50:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cf
	ld a,(hl)
	ld (hl),$00
	ld l,$cb
	add (hl)
	ld (hl),a
	ret
	
func_6e5d:
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld b,$3c
	cp $10
	jr nc,+
	ld b,$5a
	cp $0a
	jr nc,+
	ld b,$78
+
	ld e,$d0
	ld a,b
	ld (de),a
	ret


; ==============================================================================
; PARTID_3b
; Used by head thwomp (purple face); a boulder.
; ==============================================================================
partCode3b:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	or a
	jr z,@subid0
	jp @subid1
	
@subid0:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d5
	ld (hl),$02
	ld l,$cb
	ldh a,(<hCameraY)
	ldi (hl),a
	inc l
	ld a,(hl)
	or a
	jr nz,+
	call getRandomNumber_noPreserveVars
	and $7c
	ld b,a
	ldh a,(<hCameraX)
	add b
	ld e,$cd
	ld (de),a
+
	call objectSetVisible82
	ld a,SND_FALLINHOLE
	jp playSound
@@state1:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	jr c,@@func_6ebd
	ld a,(de)
	cp $b0
	jr c,@@animate
	jp partDelete
@@func_6ebd:
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld (hl),$02
	ld a,$01
	call partSetAnimation
	ld a,SND_BREAK_ROCK
	jp playSound
@@state2:
	ld e,$e1
	ld a,(de)
	bit 7,a
	jp nz,partDelete
	ld hl,@@table_6ee9
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
@@animate:
	jp partAnimate
@@table_6ee9:
	.db $04 $09 $06 $0b $09
	.db $0c $0a $0d $0b $0e
	
@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @subid0@state2
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d5
	ld (hl),$02
	ld l,$cb
	ldi a,(hl)
	inc l
	or (hl)
	jr nz,@@setVisiblec2
	call getRandomNumber_noPreserveVars
	and $7c
	ld b,a
	ldh a,(<hRng2)
	and $7c
	ld c,a
	ld e,$cb
	ldh a,(<hCameraY)
	add b
	ld (de),a
	ld e,$cd
	ldh a,(<hCameraX)
	add c
	ld (de),a
@@setVisiblec2:
	jp objectSetVisiblec2
@@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,@subid0@animate
	jr @subid0@func_6ebd


; ==============================================================================
; PARTID_HEAD_THWOMP_CIRCULAR_PROJECTILE
; ==============================================================================
partCode3c:
	jp nz,partDelete
	ld e,Part.state
	ld a,(de)
	or a
	jr z,@state0

	call partCommon_checkOutOfBounds
	jp z,partDelete
	call partCommon_decCounter1IfNonzero
	jr nz,@counter1NonZero

	inc l
	ld e,Part.var30
	ld a,(de)
	inc a
	and $01
	ld (de),a
	add (hl)
	ldd (hl),a
	ld (hl),a

	ld l,Part.angle
	ld e,Part.subid
	ld a,(de)
	add (hl)
	and $1f
	ld (hl),a

@counter1NonZero:
	call objectApplySpeed
	jp partAnimate

@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Part.counter1
	ld a,$02
	ldi (hl),a
	ld (hl),a

	ld l,Part.speed
	ld (hl),SPEED_280
	call objectSetVisible82
	ld a,SND_BEAM
	jp playSound


; ==============================================================================
; PARTID_BLUE_STALFOS_PROJECTILE
;
; Variables:
;   var03: 0 for reflectable ball type, 1 otherwise
;   relatedObj1: Instance of ENEMYID_BLUE_STALFOS
; ==============================================================================
partCode3d:
	jr z,@normalStatus

	ld h,d
	ld l,Part.subid
	ldi a,(hl)
	or (hl)
	jr nz,@normalStatus

	; Check if hit Link
	ld l,Part.var2a
	ld a,(hl)
	res 7,a
	or a ; ITEMCOLLISION_LINK
	jp z,blueStalfosProjectile_hitLink

	; Check if hit Link's sword
	sub ITEMCOLLISION_L1_SWORD
	cp ITEMCOLLISION_SWORDSPIN - ITEMCOLLISION_L1_SWORD + 1
	jr nc,@normalStatus

	; Reflect the ball if not already reflected
	ld l,Part.state
	ld a,(hl)
	cp $04
	jr nc,@normalStatus

	ld (hl),$04
	ld l,Part.speed
	ld (hl),SPEED_200
	ld a,SND_UNKNOWN3
	call playSound

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	rst_jumpTable
	.dw blueStalfosProjectile_subid0
	.dw blueStalfosProjectile_subid1


blueStalfosProjectile_subid0:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

; Initialization, deciding which ball type this should be
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),40

	ld l,Part.yh
	ld a,(hl)
	sub $18
	ld (hl),a

	ld l,Part.speed
	ld (hl),SPEED_180

	push hl
	ld a,Object.var32
	call objectGetRelatedObject1Var
	ld a,(hl)
	inc a
	and $07
	ld (hl),a

	ld hl,@ballPatterns
	call checkFlag
	pop hl
	jr z,++

	; Non-reflectable ball
	ld (hl),SPEED_200
	ld l,Part.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	ld l,Part.var03
	inc (hl)
++
	ld a,SND_BLUE_STALFOS_CHARGE
	call playSound
	jp objectSetVisible81

; A bit being 0 means the ball will be reflectable. Cycles through the next bit every time
; a projectile is created.
@ballPatterns:
	.db %10101101


; Charging
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate

	ld (hl),40 ; [counter1]
	inc l
	inc (hl) ; [counter2]
	ld a,(hl)
	cp $03
	jp c,partSetAnimation

	; Done charging
	ld (hl),20 ; [counter2]
	dec l
	ld (hl),$00 ; [counter1]

	ld l,e
	inc (hl) ; [state]

	ld l,Part.collisionType
	set 7,(hl)

	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

	ld e,Part.var03
	ld a,(de)
	add $02
	call partSetAnimation
	ld a,SND_BEAM1
	call playSound
	jr @animate


; Ball is moving (either version)
@state2:
	ld h,d
	ld l,Part.counter2
	dec (hl)
	jr nz,+
	ld l,e
	inc (hl) ; [state]
+
	call blueStalfosProjectile_checkShouldExplode
	jr blueStalfosProjectile_applySpeed


; Ball is moving (baby ball only)
@state3:
	call blueStalfosProjectile_checkShouldExplode
	jr blueStalfosProjectile_applySpeedAndDeleteIfOffScreen


; Ball was just reflected (baby ball only)
@state4:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	call objectGetAngleTowardEnemyTarget
	xor $10
	ld e,Part.angle
	ld (de),a
@animate:
	jp partAnimate


; Ball is moving after being reflected (baby ball only)
@state5:
	call blueStalfosProjectile_checkCollidedWithStalfos
	jp c,partDelete
	jr blueStalfosProjectile_applySpeedAndDeleteIfOffScreen


; Splits into 6 smaller projectiles (subid 1)
@state6:
	ld b,$06
	call checkBPartSlotsAvailable
	ret nz
	call blueStalfosProjectile_explode
	ld a,SND_BEAM
	call playSound
	jp partDelete


; Smaller projectile created from the explosion of the larger one
blueStalfosProjectile_subid1:
	ld e,Part.state
	ld a,(de)
	or a
	jr z,blueStalfosProjectile_subid1_uninitialized

blueStalfosProjectile_applySpeedAndDeleteIfOffScreen:
	call partCommon_checkOutOfBounds
	jp z,partDelete

blueStalfosProjectile_applySpeed:
	call objectApplySpeed
	jp partAnimate


blueStalfosProjectile_subid1_uninitialized:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.collisionType
	set 7,(hl)
	ld l,Part.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO

	ld l,Part.speed
	ld (hl),SPEED_1c0

	ld l,Part.damage
	ld (hl),-4

	ld l,Part.collisionRadiusY
	ld a,$02
	ldi (hl),a
	ld (hl),a

	add a ; a = 4
	call partSetAnimation
	jp objectSetVisible81


;;
; Explodes the projectile (sets state to 6) if it's the correct type and is close to Link.
; Returns from caller if so.
blueStalfosProjectile_checkShouldExplode:
	ld a,(wFrameCounter)
	and $07
	ret nz

	call partCommon_decCounter1IfNonzero
	ret nz

	ld c,$28
	call objectCheckLinkWithinDistance
	ret nc

	ld h,d
	ld l,Part.counter1
	dec (hl)
	ld e,Part.var03
	ld a,(de)
	or a
	ret z

	pop bc ; Discard return address

	ld l,Part.collisionType
	res 7,(hl)
	ld l,Part.state
	ld (hl),$06
	ret


;;
; @param[out]	cflag	c on collision
blueStalfosProjectile_checkCollidedWithStalfos:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	call checkObjectsCollided
	ret nc

	ld l,Enemy.invincibilityCounter
	ld (hl),30
	ld l,Enemy.state
	ld (hl),$14
	ret


;;
; Explodes into six parts
blueStalfosProjectile_explode:
	ld c,$06
@next:
	call getFreePartSlot
	ld (hl),PARTID_BLUE_STALFOS_PROJECTILE
	inc l
	inc (hl) ; [subid] = 1

	call objectCopyPosition

	; Copy ENEMYID_BLUE_STALFOS reference to new projectile
	ld l,Part.relatedObj1
	ld e,l
	ld a,(de)
	ldi (hl),a
	ld e,l
	ld a,(de)
	ld (hl),a

	; Set angle
	ld b,h
	ld a,c
	ld hl,@angleVals
	rst_addAToHl
	ld a,(hl)
	ld h,b
	ld l,Part.angle
	ld (hl),a

	dec c
	jr nz,@next
	ret

@angleVals:
	.db $00 $00 $05 $0b $10 $15 $1b

blueStalfosProjectile_hitLink:
	; [blueStalfos.state] = $10
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$10

	jp partDelete


; ==============================================================================
; PARTID_3e
;
; Variables:
;   var30-3f: stores enemy index of every loaded Ambi Guard
; ==============================================================================
partCode3e:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld e,Part.var30
	ldhl FIRST_ENEMY_INDEX, Enemy.id
-
	ld a,(hl)
	cp ENEMYID_AMBI_GUARD
	jr nz,+
	ld a,h
	ld (de),a
	inc e
+
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,-
	ret

@state1:
	ld hl,$d700
-
	ld l,Object.collisionType
	ld a,(hl)
	cp $98
	jr z,+
	inc h
	ld a,h
	cp $dc
	jr c,-
	ret
+
	ld a,$02
	ld (de),a

	ld e,Part.relatedObj2+1
	ld a,h
	ld (de),a
	ret

@state2:
	ld h,d
	ld l,Part.state
	inc (hl)

	ld l,Part.counter1
	ld (hl),$3c

	ld l,Part.relatedObj2+1
	ld b,(hl)
	ld e,Part.var30
-
	ld a,(de)
	or a
	ret z

	ld h,a
	ld l,Enemy.var3a
	ld (hl),$ff
	ld l,Enemy.relatedObj2
	ld (hl),$00
	inc l
	ld (hl),b
	inc e
	ld a,e
	cp Part.var34
	jr c,-
	ret

@state3:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	ld (hl),$01
	ret


; ==============================================================================
; PARTID_KING_MOBLIN_BOMB
;
; Variables:
;   relatedObj1: Instance of ENEMYID_KING_MOBLIN
;   var30: If nonzero, damage has been applied to Link
;   var31: Number of red flashes before it explodes
; ==============================================================================
partCode3f:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw kingMoblinBomb_state0
	.dw common_kingMoblinBomb_state1
	.dw kingMoblinBomb_state2
	.dw kingMoblinBomb_state3
	.dw kingMoblinBomb_state4
	.dw kingMoblinBomb_state5
	.dw kingMoblinBomb_state6
	.dw kingMoblinBomb_state7
	.dw kingMoblinBomb_state8


kingMoblinBomb_state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.speed
	ld (hl),SPEED_220

	ld l,Part.yh
	ld a,(hl)
	add $08
	ld (hl),a

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Values
	rst_addAToHl
	ld e,Part.counter1
	ld a,(hl)
	ld (de),a

	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	dec a
	ld hl,@numRedFlashes
	rst_addAToHl
	ld e,Part.var31
	ld a,(hl)
	ld (de),a

	jp objectSetVisiblec2

@counter1Values: ; One of these is chosen randomly.
	.db 120, 135, 160, 180

@numRedFlashes: ; Indexed by [kingMoblin.health] - 1.
	.db $06 $07 $08 $09 $0a $0c


; Bomb isn't doing anything except waiting to explode.
; This state's code is called by other states (2-4).
common_kingMoblinBomb_state1:
	ld e,Part.counter1
	ld a,(de)
	or a
	jr z,++
	ld a,(wFrameCounter)
	rrca
	ret c
++
	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,Part.animParameter
	bit 0,(hl)
	jr z,@animate

	ld (hl),$00
	ld l,Part.counter2
	inc (hl)

	ld a,(hl)
	ld l,Part.var31
	cp (hl)
	jr nc,kingMoblinBomb_explode

@animate:
	jp partAnimate

	; Unused code snippet?
	or d
	ret

kingMoblinBomb_explode:
	ld l,Part.state
	ld (hl),$05

.ifdef ROM_SEASONS
	ld l,Part.collisionType
	res 7,(hl)
.endif

	ld l,Part.oamFlagsBackup
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01
	call partSetAnimation
	call objectSetVisible82
	ld a,SND_EXPLOSION
	call playSound
	xor a
	ret


; Being held by Link
kingMoblinBomb_state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld a,$01
	ld (de),a ; [substate] = 1
	xor a
	ld (wLinkGrabState2),a
.ifdef ROM_AGES
	call objectSetVisiblec1
.else
	jp objectSetVisiblec1
.endif

@beingHeld:
	call common_kingMoblinBomb_state1
	ret nz
	jp dropLinkHeldItem

@released:
	; Drastically reduce speed when Y < $30 (on moblin's platform), Z = 0,
	; and subid = 0.
	ld e,Part.yh
	ld a,(de)
	cp $30
	jr nc,@beingHeld

	ld h,d
	ld l,Part.zh
	ld e,Part.subid
	ld a,(de)
	or (hl)
	jr nz,@beingHeld

	; Reduce speed
	ld hl,w1ReservedItemC.speedZ+1
	sra (hl)
	dec l
	rr (hl)
	ld l,Item.speed
	ld (hl),SPEED_40

	jp common_kingMoblinBomb_state1

@atRest:
	ld e,Part.state
	ld a,$04
	ld (de),a

	call objectSetVisiblec2
	jr kingMoblinBomb_state4


; Being thrown. (King moblin sets the state to this.)
kingMoblinBomb_state3:
	call common_kingMoblinBomb_state1
	ret z

	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing

	ld a,SND_BOMB_LAND
	call z,playSound
	jp objectApplySpeed

@doneBouncing:
	ld a,SND_BOMB_LAND
	call playSound
	ld h,d
	ld l,Part.state
	inc (hl) ; [state] = 4


; Waiting to be picked up (by link or king moblin)
kingMoblinBomb_state4:
	call common_kingMoblinBomb_state1
	ret z
	jp objectAddToGrabbableObjectBuffer


; Exploding
kingMoblinBomb_state5:
	ld h,d
	ld l,Part.animParameter
	ld a,(hl)
	inc a
	jp z,partDelete

	dec a
	jr z,@animate

	ld l,Part.collisionRadiusY
	ldi (hl),a
	ld (hl),a
	call kingMoblinBomb_checkCollisionWithLink
	call kingMoblinBomb_checkCollisionWithKingMoblin
@animate:
	jp partAnimate


; States 6-8 might be unused? Bomb is chucked way upward, then explodes on the ground.
kingMoblinBomb_state6:
	ld bc,-$240
	call objectSetSpeedZ

	ld l,e
	inc (hl) ; [state] = 7

	ld l,Part.speed
	ld (hl),SPEED_c0

	ld l,Part.counter1
	ld (hl),$07

	; Decide angle to throw at based on king moblin's position
	ld a,Object.xh
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $50
	ld a,$07
	jr c,+
	ld a,$19
+
	ld e,Part.angle
	ld (de),a
	ret


kingMoblinBomb_state7:
	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,e
	inc (hl) ; [state] = 8


kingMoblinBomb_state8:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jp nc,objectApplySpeed

	ld h,d
	jp kingMoblinBomb_explode

;;
kingMoblinBomb_checkCollisionWithLink:
	ld e,Part.var30
	ld a,(de)
	or a
	ret nz

	call checkLinkVulnerable
	ret nc

	call objectCheckCollidedWithLink_ignoreZ
	ret nc

	call objectGetAngleTowardEnemyTarget

	ld hl,w1Link.knockbackCounter
	ld (hl),$10
	dec l
	ldd (hl),a ; [w1Link.knockbackAngle]
	ld (hl),20 ; [w1Link.invincibilityCounter]
	dec l
	ld (hl),$01 ; [w1Link.var2a] (TODO: what does this mean?)

	ld e,Part.damage
	ld l,<w1Link.damageToApply
	ld a,(de)
	ld (hl),a

	ld e,Part.var30
	ld a,$01
	ld (de),a
	ret

;;
kingMoblinBomb_checkCollisionWithKingMoblin:
	ld e,Part.relatedObj1+1
	ld a,(de)
	or a
	ret z

	; Check king moblin's collisions are enabled
	ld a,Object.collisionType
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret z

	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	ret nz

	call checkObjectsCollided
	ret nc

	ld l,Enemy.var2a
	ld (hl),$80|ITEMCOLLISION_BOMB
	ld l,Enemy.invincibilityCounter
	ld (hl),30

	ld l,Enemy.health
	dec (hl)
	ret


; ==============================================================================
; PARTID_HEAD_THWOMP_BOMB_DROPPER
; ==============================================================================
partCode40:
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $01
	jp nz,partDelete
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	jp c,partDelete
	call objectApplySpeed
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectCopyPosition

@state0:
	ld h,d
	ld l,e
	inc (hl)
	call getRandomNumber_noPreserveVars
	ld b,a
	and $03
	ld hl,@speedVals
	rst_addAToHl
	ld e,$d0
	ld a,(hl)
	ld (de),a
	ld a,b
	and $60
	swap a
	ld hl,@speedZVals
	rst_addAToHl
	ld e,$d4
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ldh a,(<hRng2)
	and $10
	add $08
	ld e,$c9
	ld (de),a
	ret

@speedVals:
	.db SPEED_080
	.db SPEED_0a0
	.db SPEED_0c0
	.db SPEED_0e0

@speedZVals:
	.dw -$300
	.dw -$320
	.dw -$340
	.dw -$360


; ==============================================================================
; PARTID_SHADOW_HAG_SHADOW
; ==============================================================================
partCode41:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw partDelete

; Initialization
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),$08

	ld l,Part.speed
	ld (hl),SPEED_100

	ld e,Part.angle
	ld a,(de)
	ld hl,@angles
	rst_addAToHl
	ld a,(hl)
	ld (de),a

	call objectSetVisible82
	ld a,$01
	jp partSetAnimation

@angles:
	.db $04 $0c $14 $1c


; Shadows chasing Link
@state1:
	; If [shadowHag.counter1] == $ff, the shadows should converge to her position.
	ld a,Object.counter1
	call objectGetRelatedObject1Var
	ld a,(hl)
	inc a
	jr nz,++

	ld e,Part.state
	ld a,$02
	ld (de),a
++
	call partCommon_decCounter1IfNonzero
	jr nz,++

	ld (hl),$08
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
++
	jp objectApplySpeed


; Shadows converging back to shadow hag
@state2:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	ld e,Part.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Part.xh
	ld a,(de)
	ldh (<hFF8E),a

	; Check if already close enough
	sub c
	add $04
	cp $09
	jr nc,@updateAngleAndApplySpeed
	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	jr nc,@updateAngleAndApplySpeed

	; We're close enough.

	; [shadowHag.counter2]--
	ld l,Enemy.counter2
	dec (hl)
	; [shadowHag.visible] = true
	ld l,Enemy.visible
	set 7,(hl)

	ld e,Part.state
	ld a,$03
	ld (de),a

@updateAngleAndApplySpeed:
	call objectGetRelativeAngleWithTempVars
	ld e,Part.angle
	ld (de),a
	jp objectApplySpeed


; ==============================================================================
; PARTID_PUMPKIN_HEAD_PROJECTILE
; ==============================================================================
partCode42:
	jp nz,partDelete
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$08
	ld l,$d0
	ld (hl),$3c
	ld e,$cb
	ld l,$cf
	ld a,(de)
	add (hl)
	ld (de),a
	ld (hl),$00
	ld e,$c2
	ld a,(de)
	ld bc,@table_7421
	call addAToBc
	ld l,$c9
	ld a,(bc)
	add (hl)
	and $1f
	ld (hl),a
	ld a,(de)
	or a
	jr nz,++
	ld a,(hl)
	rrca
	rrca
	ld hl,@table_7424
	rst_addAToHl
	ld e,$cb
	ld a,(de)
	add (hl)
	ld (de),a
	ld e,$cd
	inc hl
	ld a,(de)
	add (hl)
	ld (de),a
	ld b,$02
-
	call getFreePartSlot
	jr nz,++
	ld (hl),PARTID_PUMPKIN_HEAD_PROJECTILE
	inc l
	ld (hl),b
	ld l,$c9
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
	dec b
	jr nz,-
++
	ld e,$c9
	ld a,(de)
	or a
	jp z,objectSetVisible82
	jp objectSetVisible81

@table_7421:
	.db $00 $02 $fe

@table_7424:
	.db $fc $00 $02 $04
	.db $04 $00 $02 $fc

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@state2
	ld l,e
	inc (hl)
	call objectSetVisible82

@state2:
	call partAnimate
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nc
	jp partDelete


; ==============================================================================
; PARTID_PLASMARINE_PROJECTILE
; ==============================================================================
partCode43:
	jr nz,@delete

	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMYID_PLASMARINE
	jr nz,@delete

	ld e,Part.state
	ld a,(de)
	or a
	jr z,@state0

@state1:
	; If projectile's color is different from plasmarine's color...
	ld l,Enemy.var32
	ld e,Part.subid
	ld a,(de)
	cp (hl)
	jr z,@noCollision

	; Check for collision.
	call checkObjectsCollided
	jr c,@collidedWithPlasmarine

@noCollision:
	ld a,(wFrameCounter)
	rrca
	jr c,@updateMovement

	call partCommon_decCounter1IfNonzero
	jp z,partDelete

	; Flicker visibility for 30 frames or less remaining
	ld a,(hl)
	cp 30
	jr nc,++
	ld e,Part.visible
	ld a,(de)
	xor $80
	ld (de),a
++
	; Slowly home in on Link
	inc l
	dec (hl) ; [this.counter2]--
	jr nz,@updateMovement
	ld (hl),$10
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards

@updateMovement:
	call objectApplySpeed
	call partCommon_checkOutOfBounds
	jp nz,partAnimate
	jr @delete

@collidedWithPlasmarine:
	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	jr nz,@noCollision

	ld (hl),24
	ld l,Enemy.health
	dec (hl)
	jr nz,++

	; Plasmarine is dead
	ld l,Enemy.collisionType
	res 7,(hl)
++
	ld a,SND_BOSS_DAMAGE
	call playSound
@delete:
	jp partDelete


@state0:
	ld l,Enemy.health
	ld a,(hl)
	cp $03
	ld a,SPEED_80
	jr nc,+
	ld a,SPEED_e0
+
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.speed
	ld (hl),a

	ld l,Part.counter1
	ld (hl),150 ; [counter1] (lifetime counter)
	inc l
	ld (hl),$08 ; [counter2]

	; Set color & animation
	ld l,Part.subid
	ld a,(hl)
	inc a
	ld l,Part.oamFlags
	ldd (hl),a
	ld (hl),a
	dec a
	call partSetAnimation

	; Move toward Link
	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

	jp objectSetVisible82


; ==============================================================================
; PARTID_TINGLE_BALLOON
; ==============================================================================
partCode44:
	jr nz,@beenHit

	ld e,Part.state
	ld a,(de)
	or a
	jr nz,@state1

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.counter1
	ld (hl),$38
	inc l
	ld (hl),$ff ; [counter2]

	ld l,Part.zh
	ld (hl),$f1
	ld bc,-$10
	call objectSetSpeedZ

	xor a
	call partSetAnimation
	call objectSetVisible81

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,++

	; Reverse floating direction
	ld (hl),$38 ; [counter1]
	ld l,Part.speedZ
	ld a,(hl)
	cpl
	inc a
	ldi (hl),a
	ld a,(hl)
	cpl
	ld (hl),a
++
	ld c,$00
	call objectUpdateSpeedZ_paramC

	; Update Tingle's z position
	ld a,Object.zh
	call objectGetRelatedObject1Var
	ld e,Part.zh
	ld a,(de)
	ld (hl),a
	ret

@beenHit:
	ld a,Object.state
	call objectGetRelatedObject1Var
	inc (hl) ; [tingle.state] = 2

	; Spawn explosion
	call getFreeInteractionSlot
	ld (hl),INTERACID_EXPLOSION
	ld l,Interaction.var03
	ld (hl),$01 ; Give it a higher draw priority?
	ld bc,$f000
	call objectCopyPositionWithOffset

	jp partDelete


; ==============================================================================
; PARTID_FALLING_BOULDER_SPAWNER
;
; Variables:
;   var30: yh to spawn boulder at
;   var31: xh to spawn boulder at
; ==============================================================================
partCode45:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Part.speed
	ld (hl),$32

	ld l,Part.yh
	ld a,(hl)
	sub $08
	jr z,+
	add $04
+
	ldi (hl),a
	ld e,Part.var30
	ld (de),a
	inc e
	inc l
	ld a,(hl)
	ld (de),a

	ld e,Part.subid
	ld a,(de)
	ld hl,@initialTimeToAppear
	rst_addAToHl
	ld e,Part.counter1
	ld a,(hl)
	ld (de),a
	ret

@initialTimeToAppear:
	.db $2d $5a $87 $b4

@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	
	ld l,e
	inc (hl)
	ld l,Part.collisionType
	set 7,(hl)
@bounceRandomlyDownwards:
	ld l,Part.speedZ
	ld a,<(-$1a0)
	ldi (hl),a
	ld (hl),>(-$1a0)
-
	call getRandomNumber_noPreserveVars
	and $07
	cp $07
	jr nc,-
	sub $03
	add $10
	ld e,Part.angle
	ld (de),a
	call objectSetVisiblec1
	ld a,SND_RUMBLE
	jp playSound

; Boulder falls until it hits the wall, then bounces again
; Once it's below the screen, it reappears in its original position
@state2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call z,@bounceRandomlyDownwards
	call objectApplySpeed
	
	ld e,Part.yh
	ld a,(de)
	cp $88
	jp c,partAnimate
	
	ld h,d
	ld l,Part.state
	dec (hl)
	
	ld l,Part.collisionType
	res 7,(hl)
	
	ld l,Part.counter1
	ld (hl),$b4
	ld e,Part.var30
	ld l,Part.yh
	ld a,(de)
	ldi (hl),a
	inc e
	inc l
	ld a,(de)
	ld (hl),a
	jp objectSetInvisible


; ==============================================================================
; PARTID_SEED_SHOOTER_EYE_STATUE
; ==============================================================================
partCode46:
	jr z,@normalStatus
	ld h,d
	ld l,$c6
	ld (hl),$2d
	ld l,$c2
	ld a,(hl)
	and $07
	ld hl,wActiveTriggers
	call setFlag
	call objectSetVisible83
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call partCommon_decCounter1IfNonzero
	ret nz
	ld e,$c2
	ld a,(de)
	ld hl,wActiveTriggers
	call unsetFlag
	jp objectSetInvisible

@state0:
	inc a
	ld (de),a
	ret


; ==============================================================================
; PARTID_BOMB
; ==============================================================================
partCode47:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.speed
	ld (hl),SPEED_200

	ld l,Part.speedZ
	ld a,<(-$280)
	ldi (hl),a
	ld (hl),>(-$280)

	call objectSetVisiblec1

; Waiting to be thrown
@state1:
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectTakePosition

; Being thrown
@state2:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,partAnimate

	; Landed on ground; time to explode

	ld l,Part.state
	inc (hl) ; [state] = 3

	ld l,Part.collisionType
	set 7,(hl)

	ld l,Part.oamFlagsBackup
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01
	call partSetAnimation

	ld a,SND_EXPLOSION
	call playSound

	jp objectSetVisible83

; Exploding
@state3:
	call partAnimate
	ld e,Part.animParameter
	ld a,(de)
	inc a
	jp z,partDelete

	dec a
	ld e,Part.collisionRadiusY
	ld (de),a
	inc e
	ld (de),a
	ret


; ==============================================================================
; PARTID_OCTOGON_DEPTH_CHARGE
;
; Variables:
;   var30: gravity
; ==============================================================================
partCode48:
	jr z,@normalStatus

	; For subid 1 only, delete self on collision with anything?
	ld e,Part.subid
	ld a,(de)
	or a
	jp nz,partDelete

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	or a
	ld e,Part.state
	jr z,octogonDepthCharge_subid0


; Small (split) projectile
octogonDepthCharge_subid1:
	ld a,(de)
	or a
	jr z,@state0

@state1:
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	jp nz,partAnimate
	jp partDelete

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.collisionRadiusY
	ld a,$02
	ldi (hl),a
	ld (hl),a

	ld l,Part.speed
	ld (hl),SPEED_180
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82


; Large projectile, before being split into 4 smaller ones (subid 1)
octogonDepthCharge_subid0:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,Object.visible
	call objectGetRelatedObject1Var
	ld a,(hl)

	ld h,d
	ld l,Part.state
	inc (hl)

	rlca
	jr c,@aboveWater

@belowWater:
	inc (hl) ; [state] = 2 (skips the "moving up" part)
	ld l,Part.counter1
	inc (hl)

	ld l,Part.zh
	ld (hl),$b8
	ld l,Part.var30
	ld (hl),$10

	; Choose random position to spawn at
	call getRandomNumber_noPreserveVars
	and $06
	ld hl,@positionCandidates
	rst_addAToHl
	ld e,Part.yh
	ldi a,(hl)
	ld (de),a
	ld e,Part.xh
	ld a,(hl)
	ld (de),a

	ld a,SND_SPLASH
	call playSound
	jr @setVisible81

@positionCandidates:
	.db $38 $48
	.db $38 $a8
	.db $78 $48
	.db $78 $a8

@aboveWater:
	; Is shot up before coming back down
	ld l,Part.var30
	ld (hl),$20

	ld l,Part.yh
	ld a,(hl)
	sub $10
	ld (hl),a

	ld a,SND_SCENT_SEED
	call playSound

@setVisible81:
	jp objectSetVisible81


; Above water: being shot up
@state1:
	ld h,d
	ld l,Part.zh
	dec (hl)
	dec (hl)

	ld a,(hl)
	cp $d0
	jr nc,@animate

	cp $b8
	jr nc,@flickerVisibility

	ld l,e
	inc (hl) ; [state] = 2

	ld l,Part.counter1
	ld (hl),30

	ld l,Part.collisionType
	res 7,(hl)

	ld l,Part.yh
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	inc l
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	jp objectSetInvisible

@flickerVisibility:
	ld l,Part.visible
	ld a,(hl)
	xor $80
	ld (hl),a

@animate:
	jp partAnimate


; Delay before falling to ground
@state2:
	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,e
	inc (hl) ; [state] = 3

	ld l,Part.collisionType
	set 7,(hl)
	jp objectSetVisiblec1


; Falling to ground
@state3:
	ld e,Part.var30
	ld a,(de)
	call objectUpdateSpeedZ
	jr nz,@animate

	; Hit ground; split into four, then delete self.
	call getRandomNumber_noPreserveVars
	and $04
	ld b,a
	ld c,$04

@spawnNext:
	call getFreePartSlot
	jr nz,++
	ld (hl),PARTID_OCTOGON_DEPTH_CHARGE
	inc l
	inc (hl) ; [subid] = 1
	ld l,Part.angle
	ld (hl),b
	call objectCopyPosition
	ld a,b
	add $08
	ld b,a
++
	dec c
	jr nz,@spawnNext

	ld a,SND_UNKNOWN3
	call playSound
	jp partDelete


; ==============================================================================
; PARTID_BIGBANG_BOMB_SPAWNER
; ==============================================================================
partCode49:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	
@state0:
	ld h,d
	ld l,$c2
	ld a,(hl)
	cp $ff
	jr nz,@func_7754
	ld l,$c4
	ld (hl),$05
	jp func_77f0
@func_7754:
	ld l,$c4
	inc (hl)
	call func_78e3
	call func_793b
	ld a,SND_POOF
	call playSound
	call objectSetVisiblec1
	
@state1:
	call objectApplySpeed
	ld h,d
	ld l,$f1
	ld c,(hl)
	call objectUpdateSpeedZAndBounce
	jr c,@@noBounce
	jr nz,@@inAir
	ld e,$d0
	ld a,(de)
	srl a
	ld (de),a
@@inAir:
	jp partAnimate
@@noBounce:
	ld h,d
	ld l,$c4
	ld (hl),$03
	ld l,$c6
	ld (hl),$14
	jp partAnimate
	
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substateStub
	.dw @@substateStub
	.dw @@substate3
@@substate0:
	xor a
	ld (wLinkGrabState2),a
	inc a
	ld (de),a
	jp objectSetVisiblec1
@@substateStub:
	ret
@@substate3:
	call objectSetVisiblec2
	jr @func_77b1
	
@state3:
	ld h,d
	ld l,$c6
	dec (hl)
	jr z,@func_77b1
	call partAnimate
	call func_79ab
	jp objectAddToGrabbableObjectBuffer
@func_77b1:
	ld h,d
	ld l,$c4
	ld (hl),$04
	ld l,$e4
	set 7,(hl)
	ld l,$db
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$0c
	ld a,$01
	call partSetAnimation
	ld a,SND_EXPLOSION
	call playSound
	jp objectSetVisible83
	
@state4:
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	jp z,partDelete
	dec a
	ld e,$e6
	ld (de),a
	inc e
	ld (de),a
	ret
	
@state5:
	ld h,d
	ld l,$f0
	dec (hl)
	ret nz
	ld l,$c6
	inc (hl)
	call func_77f0
	jp z,partDelete
	jr func_7858
	
func_77f0:
	ld h,d
	ld l,$c6
	ld a,(hl)
	ld bc,table_780f
	call addDoubleIndexToBc
	ld a,(bc)
	cp $ff
	jr nz,func_7805
	ld a,$01
	ld ($cfc0),a
	ret
	
func_7805:
	ld l,$f0
	ld (hl),a
	inc bc
	ld a,(bc)
	ld l,$f5
	ld (hl),a
	or d
	ret
	
table_780f:
	.db $3c $01
	.db $3c $01
	.db $3c $01
	.db $3c $01
	.db $3c $01
	.db $3c $01
	.db $28 $01
	.db $28 $01
	.db $28 $01
	.db $28 $01
	.db $28 $01
	.db $1e $01
	.db $1e $01
	.db $1e $01
	.db $1e $01
	.db $1e $01
	.db $14 $01
	.db $14 $01
	.db $14 $01
	.db $14 $01
	.db $14 $01
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $b4 $02
	.db $ff
	
func_7858:
	xor a
	ld e,$f2
	ld (de),a
	inc e
	ld (de),a
	call func_78bd
	ld e,$f5
	ld a,(de)
-
	ldh (<hFF92),a
	call func_786f
	ldh a,(<hFF92)
	dec a
	jr nz,-
	ret

func_786f:
	ld e,$f4
	ld a,(de)
	add a
	add a
	ld bc,table_789d
	call addDoubleIndexToBc
	call getRandomNumber
	and $07
	call addAToBc
	ld a,(bc)
	ldh (<hFF8B),a
	ld h,d
	ld l,$f2
	call checkFlag
	jr nz,func_786f
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_BIGBANG_BOMB_SPAWNER
	inc l
	ldh a,(<hFF8B)
	ld (hl),a
	ld h,d
	ld l,$f2
	jp setFlag
	
table_789d:
	.db $00 $01 $05 $06 $0a $0b $0f $00
	.db $01 $02 $06 $07 $0b $0c $0d $01
	.db $03 $04 $05 $09 $0a $0e $0f $03
	.db $02 $03 $07 $08 $09 $0d $0e $02

func_78bd:
	ld a,(w1Link.xh)
	cp $50
	jr nc,func_78d2
	ld a,(w1Link.yh)
	cp $40
	jr nc,func_78ce
	xor a
	jr ++
	
func_78ce:
	ld a,$01
	jr ++

func_78d2:
	ld a,(w1Link.yh)
	cp $40
	jr nc,func_78dd
	ld a,$02
	jr ++
	
func_78dd:
	ld a,$03
++
	ld e,$f4
	ld (de),a
	ret

func_78e3:
	ld h,d
	ld l,$c2
	ld a,(hl)
	ld hl,table_791b
	rst_addDoubleIndex
	ld e,$cb
	ldi a,(hl)
	ld (de),a
	ld e,$cd
	ldi a,(hl)
	ld (de),a
	call objectGetAngleTowardLink
	ld e,$c9
	ld (de),a
	call getRandomNumber
	and $0f
	ld hl,table_790b
	rst_addAToHl
	ld b,(hl)
	ld e,$c9
	ld a,(de)
	add b
	and $1f
	ld (de),a
	ret

table_790b:
	.db $01 $02 $03 $ff
	.db $fe $fd $00 $00
	.db $01 $02 $02 $ff
	.db $fe $00 $00 $00

table_791b:
	.db $00 $00
	.db $00 $28
	.db $00 $50
	.db $00 $78
	.db $00 $a0
	.db $20 $a0
	.db $40 $a0
	.db $60 $a0
	.db $80 $a0
	.db $80 $78
	.db $80 $50
	.db $80 $28
	.db $80 $00
	.db $60 $00
	.db $40 $00
	.db $20 $00

func_793b:
	call func_78bd
	ld e,$c2
	ld a,(de)
	add a
	ld hl,table_7962
	rst_addDoubleIndex
	ld e,$f4
	ld a,(de)
	rst_addAToHl
	ld a,(hl)
	ld bc,table_79a2
	call addAToBc
	ld a,(bc)
	ld h,d
	ld l,$d0
	ld (hl),a
	ld l,$f1
	ld (hl),$20
	ld l,$d4
	ld (hl),$80
	inc l
	ld (hl),$fd
	ret

table_7962:
	.db $01 $04 $05 $08
	.db $00 $03 $04 $05
	.db $00 $04 $00 $04
	.db $03 $05 $00 $04
	.db $05 $08 $01 $04
	.db $05 $06 $00 $02
	.db $05 $05 $00 $00
	.db $06 $05 $02 $00
	.db $08 $05 $04 $01
	.db $05 $03 $04 $00
	.db $04 $00 $04 $00
	.db $04 $00 $05 $03
	.db $04 $01 $08 $05
	.db $02 $00 $06 $05
	.db $00 $00 $04 $04
	.db $00 $02 $05 $06

table_79a2:
	.db $28 $32 $3c
	.db $46 $50 $5a
	.db $64 $6e $78

func_79ab:
	call objectGetShortPosition
	ld hl,wRoomLayout
	rst_addAToHl
	ld a,(hl)
	cp $54
	jr z,func_79c4
	cp $55
	jr z,func_79cb
	cp $56
	jr z,func_79d2
	cp $57
	jr z,func_79d9
	ret
	
func_79c4:
	ld hl,table_79e3
	ld e,$ca
	jr ++
	
func_79cb:
	ld hl,table_79e1
	ld e,$cc
	jr ++
	
func_79d2:
	ld hl,table_79e1
	ld e,$ca
	jr ++
	
func_79d9:
	ld hl,table_79e3
	ld e,$cc
++
	jp add16BitRefs

table_79e1:
	.db $00 $01

table_79e3:
	.db $00 $ff


; ==============================================================================
; PARTID_SMOG_PROJECTILE
; ==============================================================================
partCode4a:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a ; [state] = 1

	call objectSetVisible81

	call objectGetAngleTowardLink
	ld e,Part.angle
	ld (de),a
	ld c,a

	ld a,SPEED_c0
	ld e,Part.speed
	ld (de),a

	; Check if this is a projectile from a large smog or a small smog
	ld e,Part.subid
	ld a,(de)
	or a
	jr z,@setAnimation

	; If from a large smog, change some properties
	ld a,SPEED_100
	ld e,Part.speed
	ld (de),a

	ld a,$05
	ld e,Part.oamFlags
	ld (de),a

	ld e,Part.enemyCollisionMode
	ld a,ENEMYCOLLISION_PODOBOO
	ld (de),a

	ld a,c
	call convertAngleToDirection
	and $01
	add $02

@setAnimation:
	call partSetAnimation

@state1:
	; Delete self if boss defeated
	call getThisRoomFlags
	bit 6,a
	jr nz,@delete

	ld a,(wNumEnemies)
	dec a
	jr z,@delete

	call objectCheckWithinScreenBoundary
	jr nc,@delete

	call objectApplySpeed

	; If large smog's projectile, return (it passes through everything)
	ld e,Part.subid
	ld a,(de)
	or a
	ret nz

	; Check for collision with items
	ld e,Part.var2a
	ld a,(de)
	or a
	jr nz,@beginDestroyAnimation

	; Check for collision with wall
	call partCommon_getTileCollisionInFront
	jr z,@state2

@beginDestroyAnimation:
	ld h,d
	ld l,Part.collisionType
	res 7,(hl)

	ld a,$02
	ld l,Part.state
	ld (hl),a

	dec a
	call partSetAnimation


@state2:
	call partAnimate
	ld e,Part.animParameter
	ld a,(de)
	or a
	ret z
@delete:
	jp partDelete


; ==============================================================================
; PARTID_RAMROCK_SEED_FORM_ORB
; ==============================================================================
partCode4f:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	
@state0:
	ld a,$01
	ld (de),a
	inc a
	call partSetAnimation
	ld e,$c6
	ld a,$28
	ld (de),a
	jp objectSetVisible80
	
@state1:
	call partAnimate
	ld a,$02
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0f
	jr nz,@delete
	call partCommon_decCounter1IfNonzero
	ret nz
	call objectGetAngleTowardLink
	ld e,$c9
	ld (de),a
	ld a,$50
	ld e,$d0
	ld (de),a
	ld e,$c4
	ld a,$02
	ld (de),a
	
@state2:
	call partAnimate
	call partCommon_decCounter1IfNonzero
	jr nz,@func_7aa9
	ld (hl),$0a
	call objectGetAngleTowardLink
	jp objectNudgeAngleTowards

@func_7aa9:
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
@delete:
	jp partDelete


; ==============================================================================
; PARTID_ROOM_OF_RITES_FALLING_BOULDER
; ==============================================================================
partCode54:
	ld e,$c2
	ld a,(de)
	or a
	ld e,$c4
	jp nz,func_7adb
	ld a,(de)
	or a
	jr z,func_7ad3
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	and $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_ROOM_OF_RITES_FALLING_BOULDER
	inc l
	inc (hl)
	ret
	
func_7ad3:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$96
	ret
	
func_7adb:
	ld a,(de)
	or a
	jr nz,func_7b0a
	inc a
	ld (de),a
	ldh a,(<hCameraY)
	ld b,a
	ldh a,(<hCameraX)
	ld c,a
	call getRandomNumber
	ld l,a
	and $07
	swap a
	add $28
	add c
	ld e,$cd
	ld (de),a
	ld a,l
	and $70
	add $08
	ld l,a
	add b
	ld e,$cb
	ld (de),a
	ld a,l
	cpl
	inc a
	sub $07
	ld e,$cf
	ld (de),a
	jp objectSetVisiblec1
	
func_7b0a:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,partAnimate
	call objectReplaceWithAnimationIfOnHazard
	jr c,@delete
	ld b,INTERACID_ROCKDEBRIS
	call objectCreateInteractionWithSubid00
@delete:
	jp partDelete


; ==============================================================================
; PARTID_OCTOGON_BUBBLE
; ==============================================================================
partCode55:
	jr z,@normalStatus

	; Collision occured with something. Check if it was Link.
	ld e,Part.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jp nz,@gotoState2

	call checkLinkVulnerable
	jr nc,@normalStatus

	; Immobilize Link
	ld hl,wLinkForceState
	ld a,LINK_STATE_COLLAPSED
	ldi (hl),a
	ld (hl),$01 ; [wcc50]

	ld h,d
	ld l,Part.state
	ld (hl),$03

	ld l,Part.zh
	ld (hl),$00

	ld l,Part.collisionType
	res 7,(hl)
	call objectSetVisible81

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3


; Uninitialized
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.speed
	ld (hl),SPEED_80

	ld l,Part.counter1
	ld (hl),180
	jp objectSetVisible82


; Moving forward
@state1:
	call partCommon_decCounter1IfNonzero
	jr z,@gotoState2

	ld a,(wFrameCounter)
	and $18
	rlca
	swap a
	ld hl,@zPositions
	rst_addAToHl
	ld e,Part.zh
	ld a,(hl)
	ld (de),a
	call objectApplySpeed
@animate:
	jp partAnimate

@zPositions:
	.db $ff $fe $ff $00


; Stopped in place, waiting for signal from animation to delete self
@state2:
	call partAnimate
	ld e,Part.animParameter
	ld a,(de)
	inc a
	ret nz
	jp partDelete


; Collided with Link
@state3:
	ld hl,w1Link
	call objectTakePosition

	ld a,(wLinkForceState)
	cp LINK_STATE_COLLAPSED
	ret z

	ld l,<w1Link.state
	ldi a,(hl)
	cp LINK_STATE_COLLAPSED
	jr z,@animate

@gotoState2:
	ld h,d
	ld l,Part.state
	ld (hl),$02

	ld l,Part.collisionType
	res 7,(hl)

	ld a,$01
	jp partSetAnimation


; ==============================================================================
; PARTID_VERAN_SPIDERWEB
; ==============================================================================
partCode56:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr nz,@normalStatus
	ld hl,$d031
	ld (hl),$10
	ld l,$30
	ld (hl),$00
	ld l,$24
	res 7,(hl)
	ld bc,$fa00
	call objectCopyPositionWithOffset
	ld h,d
	ld l,$f0
	ld (hl),$01
	ld l,$c4
	ldi a,(hl)
	dec a
	jr nz,@normalStatus
	inc l
	ld a,$01
	ldi (hl),a
	ld (hl),a
@normalStatus:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	
@subid0:
	ld a,(de)
	or a
	jr z,@func_7c2e
	call partCommon_decCounter1IfNonzero
	jr nz,++
	ld (hl),$04
	call getFreePartSlot
	jr nz,++
	ld (hl),PARTID_VERAN_SPIDERWEB
	inc l
	ld (hl),$02
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
++
	ld a,$02
	call objectGetRelatedObject1Var
	ld a,(hl)
	dec a
	jp nz,@func_7c28
	ld c,h
	ldh a,(<hCameraY)
	ld b,a
	ld e,$cf
	ld a,(de)
	sub $04
	ld (de),a
	ld h,d
	ld l,$cb
	add (hl)
	sub b
	cp $b0
	ret c
	ld h,c
	ld l,$b8
	inc (hl)
	jp partDelete

@func_7c28:
	call objectCreatePuff
	jp partDelete
	
@func_7c2e:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	inc (hl)
	call objectSetVisible80
@beamSound:
	ld a,SND_BEAM2
	jp playSound
	
@subid1:
	ld a,$02
	call objectGetRelatedObject1Var
	ld a,(hl)
	dec a
	jr nz,@func_7c28
	ld l,$ad
	ld a,(hl)
	or a
	jr nz,@func_7c28
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$01
	inc l
	ld (hl),$05
	ld l,$e4
	set 7,(hl)
	ld l,$d0
	ld (hl),$50
	ld l,$f1
	ld e,$cb
	ld a,(de)
	add $10
	ldi (hl),a
	ld (de),a
	ld e,$cd
	ld a,(de)
	ld (hl),a
	call objectGetAngleTowardLink
	cp $0e
	ld b,$0c
	jr c,+
	ld b,$10
	cp $13
	jr c,+
	ld b,$14
+
	ld e,$c9
	ld a,b
	ld (de),a
	call objectSetVisible81
	jr @beamSound
	
@@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld (hl),$08
	inc l
	dec (hl)
	jr z,++
	call getFreePartSlot
	jr nz,+
	ld (hl),PARTID_VERAN_SPIDERWEB
	inc l
	ld (hl),$03
	ld l,$d6
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	call objectCopyPosition
+
	call partCommon_checkTileCollisionOrOutOfBounds
	jp nc,objectApplySpeed
++
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld (hl),$1e
	ld l,$d0
	ld (hl),$3c
	ld l,$c9
	ld a,(hl)
	xor $10
	ld (hl),a
	ret
	
@@state2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,$c4
	inc (hl)
	ret
	
@@state3:
	call objectApplySpeed
	ld e,$f0
	ld a,(de)
	or a
	jr z,+
	ld bc,$fa00
	ld hl,$d000
	call objectCopyPositionWithOffset
+
	ld h,d
	ld l,$f1
	ld e,$cb
	ld a,(de)
	sub (hl)
	add $02
	cp $05
	ret nc
	ld l,$f2
	ld e,$cd
	ld a,(de)
	sub (hl)
	add $02
	cp $05
	ret nc
	ld a,$38
	call objectGetRelatedObject1Var
	inc (hl)
	ld e,$f0
	ld a,(de)
	or a
	jp z,partDelete
	ld l,$86
	ld (hl),$08
	ld h,d
	ld l,$c4
	inc (hl)
	ret
	
@@state4:
	ld hl,$d005
	ld a,(hl)
	cp $02
	jp z,partDelete
	ld bc,$0600
	jp objectTakePositionWithOffset
	
@subid2:
	ld a,(de)
	or a
	jr z,@func_7d39
	ld a,$1a
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jr z,@@delete
	ld l,$8f
	ld b,(hl)
	dec b
	ld e,$cf
	ld a,(de)
	dec a
	cp b
	ret c
@@delete:
	jp partDelete
	
@func_7d39:
	inc a
	ld (de),a
	inc a
	call partSetAnimation
	jp objectSetVisible80
	
@subid3:
	ld a,(de)
	or a
	jr z,@func_7d59
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $56
	jr nz,@@delete
	ld l,$cb
	ld e,l
	ld a,(de)
	cp (hl)
	ret c
@@delete:
	jp partDelete

@func_7d59:
	inc a
	ld (de),a
	ld a,$09
	call objectGetRelatedObject1Var
	ld a,(hl)
	sub $0c
	rrca
	rrca
	inc a
	call partSetAnimation
	jp objectSetVisible83


; ==============================================================================
; PARTID_VERAN_ACID_POOL
; ==============================================================================
partCode57:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	call objectCenterOnTile
	call objectGetShortPosition
	ld e,$f0
	ld (de),a
	ld e,$c6
	ld a,$04
	ld (de),a
	ld a,SND_UNKNOWN3
	call playSound
	ld hl,@table_7d98
	ld a,$60
	jr @func_7de1

@table_7d98:
	.db $f0 $ff $01 $10

@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$04
	ld hl,@table_7da9
	ld a,$60
	jr @func_7de1

@table_7da9:
	.db $ef $f1 $0f $11

@state2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$2d
	ld l,e
	inc (hl)
	ld l,$60
@func_7db7:
	ld e,$f0
	ld a,(de)
	ld c,a
	ld b,$cf
	ld a,(bc)
	sub $02
	cp $03
	ret c
	ld a,l
	jp setTile

@state3:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$04
	ld l,e
	inc (hl)

@state4:
	ld hl,@table_7da9
	ld a,$a0
	jr @func_7de1

@state5:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$04
	ld hl,@table_7d98
	ld a,$a0
@func_7de1:
	ldh (<hFF8B),a
	ld e,$f0
	ld a,(de)
	ld c,a
	ld b,$04
---
	push bc
	ldi a,(hl)
	add c
	ld c,a
	ld b,$cf
	ld a,(bc)
	cp $da
	jr z,+
	sub $02
	cp $03
	jr c,++
	ld b,$ce
	ld a,(bc)
	or a
	jr nz,++
+
	ldh a,(<hFF8B)
	push hl
	call setTile
	pop hl
++
	pop bc
	dec b
	jr nz,---
	ld h,d
	ld l,$c4
	inc (hl)
	ret

@state6:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,$a0
	call @func_7db7
	jp partDelete


; ==============================================================================
; PARTID_VERAN_BEE_PROJECTILE
; ==============================================================================
partCode58:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr nz,@normalStatus
	ld h,d
	ld l,$e4
	res 7,(hl)
	ld l,$c4
	ld (hl),$03
	ld l,$c6
	ld (hl),$f0
	call objectSetInvisible
@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c9
	ld (hl),$10
	ld l,$d0
	ld (hl),$78
	ld l,$c6
	ld (hl),$09
	ld a,SND_BEAM
	call playSound
	call objectSetVisible83
	
@state1:
	call partCommon_decCounter1IfNonzero
	jr z,@@incState
	ld a,$0b
	call objectGetRelatedObject1Var
	ld bc,$1400
	jp objectTakePositionWithOffset
@@incState:
	ld l,e
	inc (hl)
	
@state2:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	cp $b0
	ret c
	jp partDelete
	
@state3:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(wGameKeysJustPressed)
	or a
	jr z,++
	ld a,(hl)
	sub $0a
	jr nc,+
	ld a,$01
+
	ld (hl),a
++
	ld hl,wccd8
	set 5,(hl)
	ld a,(wFrameCounter)
	rrca
	ret nc
	ld hl,wLinkImmobilized
	set 5,(hl)
	ret


; ==============================================================================
; PARTID_BLACK_TOWER_MOVING_FLAMES
;
; Variables:
;   var30: next yh to move to
;   var31: next xh to move to
; ==============================================================================
partCode59:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$14
	ld l,$c2
	ld a,(hl)
	ld hl,@table_7ebd
	rst_addAToHl
	ld e,$c6
	ld a,(hl)
	ld (de),a
	ret

@table_7ebd:
	.db $01 $14 $28 $3c
	
@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld l,$c2
	ld a,(hl)
	xor $03
	ld hl,@table_7ebd
	rst_addAToHl
	ld e,$c6
	ld a,(hl)
	ld (de),a
	ld a,SND_LIGHTTORCH
	call playSound
	jp objectSetVisible83
	
@state2:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld (hl),$14
	ld l,e
	inc (hl)
	jr @animate
	
@state3:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	callab bank10.blackTower_getMovingFlamesNextTileCoords
	ld h,d
	ld l,$c4
	inc (hl)
	ld a,b
	or a
	jr nz,@animate
	inc (hl)
	ld l,$c6
	ld (hl),$10
	jr @animate
	
@state4:
	ld h,d
	ld l,$f0
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	cp c
	jr nz,@moveToBC
	ldh a,(<hFF8F)
	cp b
	jr nz,@moveToBC
	ld l,e
	dec (hl)
	ld l,$c6
	ld (hl),$10
	inc l
	inc (hl)
	jr @animate
	
@moveToBC:
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
	call objectApplySpeed
@animate:
	jp partAnimate
	
@state5:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	call objectCreatePuff
	jp partDelete


; ==============================================================================
; PARTID_TRIFORCE_STONE
; Stone blocking path to Nayru at the start of the game (only after being moved)
; ==============================================================================
partCode5a:
	ld e,Part.state
	ld a,(de)
	or a
	ret nz

	inc a
	ld (de),a

	call getThisRoomFlags
	and $c0
	jp z,partDelete

	and $40
	ld a,$28
	jr nz,+
	ld a,$48
+
	ld e,Part.xh
	ld (de),a
	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	ld a,PALH_98
	call loadPaletteHeader
	jp objectSetVisible83
