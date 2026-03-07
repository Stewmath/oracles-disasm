; ==================================================================================================
; PART_RAMROCK_GLOVE_FORM_ARM
; ==================================================================================================
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
	ld a,PART_RAMROCK_GLOVE_FORM_ARM
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
