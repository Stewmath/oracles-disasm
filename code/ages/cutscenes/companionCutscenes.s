;;
specialObjectCode_companionCutscene:
	ld hl,w1Companion.id
	ld a,(hl)
	sub SPECIALOBJECTID_RICKY_CUTSCENE
	rst_jumpTable
	.dw specialObjectCode_rickyCutscene
	.dw specialObjectCode_dimitriCutscene
	.dw specialObjectCode_mooshCutscene
	.dw specialObjectCode_mapleCutscene

;;
specialObjectCode_rickyCutscene:
	ld e,SpecialObject.state
	ld a,(de)
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw rickyCutscene_state1

@state0:
	call companionCutsceneInitOam
	ld h,d
	ld l,SpecialObject.speed
	ld (hl),SPEED_200
	ld l,SpecialObject.angle
	ld (hl),$08

rickyCutsceneJump:
	ld bc,$fe00
	call objectSetSpeedZ
	ld a,$02
	jp specialObjectSetAnimation


;;
; @param	de	Pointer to Object.state variable
companionCutsceneInitOam:
	ld a,$01
	ld (de),a
	callab bank5.specialObjectSetOamVariables
	jp objectSetVisiblec0


rickyCutscene_state1:
	ld e,SpecialObject.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	ret

@subid1:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA

@substate0:
	ld l,SpecialObject.substate
	inc (hl)

@substate1:
	call objectApplySpeed

	ld e,SpecialObject.xh
	ld a,(de)
	bit 7,a
	jr nz,++

	ld hl,w1Link.xh
	ld b,(hl)
	add $18
	cp b
	jr c,++

	call itemIncSubstate
	inc (hl)
	ld l,SpecialObject.z
	xor a
	ldi (hl),a
	ld (hl),a
	ld l,SpecialObject.counter1
	ld (hl),$3c
	jp specialObjectAnimate
++
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	ld l,SpecialObject.counter1
	ld (hl),$08
	jp specialObjectAnimate

@substate2:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	dec (hl)
	jp rickyCutsceneJump

@substate3:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$5a
	ld a,$14
	jp specialObjectSetAnimation

@substate4:
	call specialObjectAnimate
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$0c
	ld a,$1f
	call specialObjectSetAnimation
	call getFreeInteractionSlot
	ret nz

	ld (hl),$07
	ld bc,$f812
	jp objectCopyPositionWithOffset

	ld l,SpecialObject.substate
	ld (hl),$00
	ld a,$1e
	jp specialObjectSetAnimation

@substate5:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$3c
	ld a,$1e
	jp specialObjectSetAnimation

@substate6:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)

	; counter1
	inc l
	ld (hl),$1e

	ld hl,wActiveRing
	ld (hl),$ff
	ld a,$81
	ld (wLinkInAir),a
	ld hl,w1Link.speed
	ld (hl),SPEED_80
	ld l,SpecialObject.speedZ
	ld (hl),$00
	inc l
	ld (hl),$fe

	ld a,$18
	ld (w1Link.angle),a
	ld a,SND_JUMP
	jp playSound

@substate7:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$14
	xor a
	ld hl,w1Link.visible
	ld (hl),a
	inc a
	ld (wDisabledObjects),a
	ret

@substate8:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.angle
	ld (hl),$18

@jump:
	ld a,$1c
	call specialObjectSetAnimation
	ld bc,$fe00
	jp objectSetSpeedZ

@substate9:
	call objectApplySpeed
	ld e,SpecialObject.xh
	ld a,(de)
	sub $10
	rlca
	jr nc,+
	ld hl,$cfdf
	ld (hl),$01
	ret
+
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	ld l,SpecialObject.counter1
	ld (hl),$08
	jp specialObjectAnimate

@substateA:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	dec (hl)
	jp @jump

;;
specialObjectCode_mooshCutscene:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call companionCutsceneInitOam
	ld h,d
	ld l,SpecialObject.counter1
	ld (hl),$5a
	ld l,SpecialObject.speed
	ld (hl),SPEED_160
	ld l,SpecialObject.var36
	ld (hl),$05
	ld l,SpecialObject.angle
	ld (hl),$10
	ld l,SpecialObject.z
	ld (hl),$ff
	inc l
	ld (hl),$e0

	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_BANANA
	ld l,Interaction.relatedObj1+1
	ld (hl),d
+
	ld a,$07
	jp specialObjectSetAnimation

@state1:
	ld e,SpecialObject.substate
	ld a,(de)
	or a
	jr z,+
	call specialObjectAnimate
	call objectApplySpeed
+
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call itemDecCounter1
	ret nz
	ld (hl),$48
	ld l,SpecialObject.substate
	inc (hl)
	ret

@substate1:
	call itemDecCounter1
	ret nz
	ld (hl),$06
	ld l,SpecialObject.substate
	inc (hl)
	jp companionCutsceneFunc_7081

@substate2:
	ld h,d
	ld l,SpecialObject.angle
	ld a,(hl)
	cp $10
	jr z,@label_6ec2
	ld l,SpecialObject.substate
	inc (hl)
	ret

@label_6ec2:
	ld l,SpecialObject.counter1
	dec (hl)
	ret nz
	call companionCutsceneDecAngle
	ld (hl),$06
	jp companionCutsceneFunc_7081

@substate3:
	ld h,d
	ld l,SpecialObject.angle
	ld a,(hl)
	cp $10
	jr nz,@label_6ec2
	ld l,SpecialObject.substate
	inc (hl)
	ld a,$07
	jp specialObjectSetAnimation

@substate4:
	ld e,SpecialObject.yh
	ld a,(de)
	cp $b0
	ret c

	ld hl,w1Companion.id
	ld b,$3f
	call clearMemory
	ld hl,w1Companion.id
	ld (hl),SPECIALOBJECTID_DIMITRI_CUTSCENE
	ld l,SpecialObject.yh
	ld (hl),$e8
	inc l
	inc l
	ld (hl),$28
	ret

;;
specialObjectCode_dimitriCutscene:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call companionCutsceneInitOam
	ld h,d
	ld l,SpecialObject.speed
	ld (hl),SPEED_100
	ld l,SpecialObject.z
	ld (hl),$e0
	inc l
	ld (hl),$ff
	ld a,$19
	jp specialObjectSetAnimation

@state1:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	ld h,d
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter2
	ld a,(hl)
	cp $02
	jr nz,+

	push af
	ld a,$1a
	call specialObjectSetAnimation
	pop af
+
	ld b,a
	add a
	add b
	ld hl,@@data
	rst_addAToHl
	ldi a,(hl)
	ld e,SpecialObject.angle
	ld (de),a
	ld c,(hl)
	inc hl
	ld b,(hl)
	jp objectSetSpeedZ


; b0: angle
; b1/b2: speedZ
@@data:
	dbw $0c $fd40
	dbw $0c $fda0
	dbw $13 $fe80


@substate1:
	call specialObjectAnimate
	call objectApplySpeed
	ld c,$18
	call objectUpdateSpeedZ_paramC
	ret nz

	ld h,d
	ld l,SpecialObject.counter2
	inc (hl)
	ld a,(hl)
	ld l,SpecialObject.substate
	cp $03
	jr z,+
	dec (hl)
	ld l,SpecialObject.counter1
	ld (hl),$08
	ret
+
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$06
	ret

@substate2:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$14
	ld a,$27
	jp specialObjectSetAnimation

@substate3:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$78
	ret

@substate4:
	call specialObjectAnimate
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)
	ld l,SpecialObject.counter1
	ld (hl),$3c
	ld l,SpecialObject.angle
	ld (hl),$0b
	ld l,SpecialObject.speed
	ld (hl),SPEED_80
	ret

@substate5:
	call itemDecCounter1
	ret nz
	ld l,SpecialObject.substate
	inc (hl)
	ld a,$26
	jp specialObjectSetAnimation

@substate6:
	call specialObjectAnimate
	call objectApplySpeed
	ld e,SpecialObject.xh
	ld a,(de)
	cp $78
	jr nz,+
	ld a,$05
	jp specialObjectSetAnimation
+
	cp $b0
	ret c

	ld hl,w1Companion.id
	ld b,$3f
	call clearMemory
	ld hl,w1Companion.id
	ld (hl),SPECIALOBJECTID_RICKY_CUTSCENE
	inc l
	ld (hl),$01
	ld l,SpecialObject.yh
	ld (hl),$48
	inc l
	inc l
	ld (hl),$d8
	ret

;;
specialObjectCode_mapleCutscene:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call companionCutsceneInitOam
	ld h,d
	ld l,SpecialObject.zh
	ld (hl),$f0
	ld l,SpecialObject.angle
	ld (hl),$08
	ld l,SpecialObject.counter1
	ld (hl),$5a
	ret

@initPositionSpeedAnimation:
	ld l,SpecialObject.counter2
	ld a,(hl)
	add a
	ld hl,@@data
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,SpecialObject.speed
	ld (de),a
	ldi a,(hl)
	ld e,SpecialObject.counter1
	ld (de),a
	ldi a,(hl)
	ld e,SpecialObject.yh
	ld (de),a
	ld a,(hl)
	jp specialObjectSetAnimation


; b0: speed
; b1: counter1
; b2: yh
; b3: animation
@@data:
	.db SPEED_200 $60 $78 $05
	.db SPEED_1c0 $6e $70 $07
	.db SPEED_180 $7d $68 $05
	.db SPEED_040 $e6 $2c $05


@state1:
	call specialObjectAnimate
	call objectOscillateZ
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,(wPaletteThread_mode)
	or a
	call z,itemDecCounter1
	ret nz
	call itemIncSubstate
	jr @initPositionSpeedAnimation

@substate1:
	call itemDecCounter1
	jp nz,objectApplySpeed
	ld (hl),$5a
	inc l
	inc (hl)
	jp itemIncSubstate

@substate2:
	call itemDecCounter1
	ret nz

	; Check counter2
	inc l
	ld a,(hl)
	cp $04
	jr nz,++

	; Set counter1
	dec l
	ld (hl),$1e

	call itemIncSubstate
	ld a,$07
	jp specialObjectSetAnimation
++
	ld l,SpecialObject.substate
	dec (hl)
	ld l,SpecialObject.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	jr @initPositionSpeedAnimation

@substate3:
	call itemDecCounter1
	jr z,+
	ld c,$02
	jp objectUpdateSpeedZ_paramC
+
	ld a,$ff
	ld ($cfdf),a
	ret

;;
; @param	a	Angle
companionCutsceneFunc_7081:
	sub $04
	and $07
	ret nz
	ld e,SpecialObject.angle
	call convertAngleDeToDirection
	dec a
	and $03
	ld h,d
	ld l,SpecialObject.direction
	ld (hl),a
	ld l,SpecialObject.var36
	add (hl)
	jp specialObjectSetAnimation

;;
companionCutsceneDecAngle:
	ld e,SpecialObject.angle
	ld a,(de)
	dec a
	and $1f
	ld (de),a
	ret
