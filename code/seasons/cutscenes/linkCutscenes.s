specialObjectCode_linkInCutscene:
	ld e,SpecialObject.subid
	ld a,(de)
	rst_jumpTable
	.dw linkCutscene0
	.dw linkCutscene1
	.dw linkCutscene2
	.dw linkCutscene3
	.dw linkCutscene4
	.dw linkCutscene5
	.dw linkCutscene6
	.dw linkCutscene7
	.dw linkCutscene8
	.dw linkCutscene9
	.dw linkCutsceneA

;;
; Opening cutscene with the triforce
linkCutscene0:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call linkCutscene_initOam_setVisible_incState
	call objectSetVisible81
	xor a
	call specialObjectSetAnimation

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
	.dw linkCutscene0_substate6

@substate0:
	ld a,(wLinkAngle)
	rlca
	ld a,$00
	jp c,specialObjectSetAnimation

	ld h,d
	ld l,SpecialObject.yh
	ld a,(wGameKeysPressed)
	bit BTN_BIT_DOWN,a
	jr z,+
	inc (hl)
+
	bit BTN_BIT_UP,a
	jr z,+
	dec (hl)
+
	ld a,(hl)
	cp $40
	jp nc,specialObjectAnimate
	ld a,$01
	ld (wTmpcbb9),a
	ld a,SND_DROPESSENCE
	call playSound
	jp itemIncSubstate

@substate1:
	ld a,(wTmpcbb9)
	cp $02
	ret nz

	call itemIncSubstate
	ld b,$04
	call func_2d48
	ld a,b
	ld e,SpecialObject.counter1
	ld (de),a
	ld a,$04
	jp specialObjectSetAnimation

@substate2:
	call itemDecCounter1
	jp nz,specialObjectAnimate

	ld l,SpecialObject.speed
	ld (hl),SPEED_20
	ld b,$05
	call func_2d48
	ld a,b
	ld e,SpecialObject.counter1
	ld (de),a
	jp itemIncSubstate

@substate3:
	call itemDecCounter1
	jp nz,++

	call itemIncSubstate
	ld b,$07
	call func_2d48
	ld a,b
	ld e,SpecialObject.counter1
	ld (de),a
++
	ld hl,linkCutscene_zOscillation0
.ifdef ROM_AGES
	jr linkCutscene_oscillateZ
.else
	jp linkCutscene_oscillateZ
.endif

@substate4:
	call itemDecCounter1
	jp nz,linkCutscene_oscillateZ_1
	ld a,$03
	ld (wTmpcbb9),a
	call itemIncSubstate

@substate5:
	ld a,(wTmpcbb9)
	cp $06
	jr nz,linkCutscene_oscillateZ_1

;;
; Creates the colored orb that appears under Link in the opening cutscene
linkCutscene_createGlowingOrb:
	ldbc INTERACID_SPARKLE, $06
	call objectCreateInteraction
	jr nz,+
	ld l,Interaction.relatedObj1
	ld a,SpecialObject.start
	ldi (hl),a
	ld (hl),d
+
	call itemIncSubstate
	ld a,$05
	jp specialObjectSetAnimation

;;
linkCutscene_oscillateZ_1:
	ld hl,linkCutscene_zOscillation1

;;
linkCutscene_oscillateZ:
	ld a,($cbb7)
.ifdef ROM_SEASONS
	ld b,a
	and $07
	jr nz,++

	ld a,b
.else
	and $07
	jr nz,++

	ld a,($cbb7)
.endif
	and $38
	swap a
	rlca
	rst_addAToHl
	ld e,SpecialObject.zh
.ifdef ROM_AGES
	ld a,(hl)
	ld b,a
	ld a,(de)
	add b
.else
	ld a,(de)
	add (hl)
.endif
	ld (de),a
++
	jp specialObjectAnimate

linkCutscene_zOscillation0:
	.db $ff $fe $fe $ff $00 $01 $01 $00

linkCutscene_zOscillation1:
	.db $ff $ff $ff $00 $01 $01 $01 $00

linkCutscene_zOscillation2:
	.db $02 $03 $04 $03 $02 $00 $ff $00


linkCutscene0_substate6:
	ld e,SpecialObject.animParameter
	ld a,(de)
	inc a
	jr nz,+
	ld a,$07
	ld (wTmpcbb9),a
	ret
+
	call specialObjectAnimate
	ld a,($cbb7)
	rrca
	jp nc,objectSetInvisible
	jp objectSetVisible


; Dancing with Din
linkCutscene1:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	jp linkCutscene_initOam_setVisible_incState

@state1:
	ld e,Item.substate
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
	.dw @substateB
	.dw @substateC
	.dw @substateD
	.dw @substateE
	.dw @substateF
	.dw @substate10
	.dw @substate11
	.dw @substate12
	.dw @substate13
	.dw @substate14
	.dw @ret

@substate0:
	ld a,($cfd0)
	or a
	ret nz

	call itemIncSubstate
	ld l,Item.counter1
	ld (hl),$aa

	ld l,Item.yh
	ld a,$30
	ldi (hl),a
	; xh
	inc l
	ld a,$50
	ld (hl),a

	ld l,Item.relatedObj2+1
	ld h,(hl)
	ld l,Interaction.yh
	ld a,$30
	ldi (hl),a
	; xh
	inc l
	ld a,$60
	ld (hl),a

	ld e,Item.direction
	xor a
	ld (de),a

@seasonsFunc_06_6f71:
	ld a,$07
	call specialObjectSetAnimation
	ld a,$08
	jp setRelatedObj2Animation

@substate1:
	call itemDecCounter1
	jr nz,@animateSelfAndRelatedObj2
	ld (hl),$1e
	call itemIncSubstate
	jr @seasonsFunc_06_6f71

@animateSelfAndRelatedObj2:
	call specialObjectAnimate
	jp animateRelatedObj2

@substate2:
	call itemDecCounter1
	ret nz
	ld (hl),$28
	ld a,$10
	call specialObjectSetAnimation
	ld a,$0d
	call setRelatedObj2Animation
	jp itemIncSubstate

@substate3:
	call itemDecCounter1
	ret nz
	ld (hl),$3c
	call itemIncSubstate
	ld bc,TX_0c17
	call checkIsLinkedGame
	jr z,+
	ld c,<TX_0c18
+
	jp showText

@substate4:
	ld a,(wTextIsActive)
	or a
	ret nz
	call itemDecCounter1
	ret nz
	ld (hl),$96
	call @seasonsFunc_06_6f71
	jp itemIncSubstate

@substate5:
	call itemDecCounter1
	jr nz,@animateSelfAndRelatedObj2
	ld a,$02
	ld ($cfd0),a
	jp itemIncSubstate

@substate6:
	ld a,($cfd0)
	cp $03
	jr nz,@animateSelfAndRelatedObj2
	call @seasonsFunc_06_6f71
	jp itemIncSubstate

@substate7:
	ld a,($cfd0)
	cp $04
	ret nz
	call itemIncSubstate
	ld l,Item.counter1
	ld (hl),$5a
	ld l,Item.direction
	ld (hl),DIR_LEFT
	xor a
	jp specialObjectSetAnimation

@substate8:
	call itemDecCounter1
	ret nz
	ld (hl),$12
	jp itemIncSubstate

@substate9:
	call itemDecCounter1
	jr nz,+
	ld (hl),$46
	xor a
	call specialObjectSetAnimation
	jp itemIncSubstate
+
	ld l,Item.xh
	dec (hl)
	jp specialObjectAnimate

@substateA:
	call itemDecCounter1
	ret nz
	ld hl,$cfd0
	ld (hl),$05
	jp itemIncSubstate

@substateB:
	ld hl,$cfd1
	bit 6,(hl)
	ret z
@seasonsFunc_06_7025:
	ld a,$14
	ld e,SpecialObject.counter1
	ld (de),a
	ld e,Item.xh
	ld a,(de)
	dec e
	ld (de),a
	jp itemIncSubstate

@substateC:
	call itemDecCounter1
	jr nz,@seasonsFunc_06_7052
	ld h,d
	ld l,Item.speed
	ld (hl),SPEED_200
	ld l,Item.angle
	ld (hl),$0e
	ld l,Item.xh
	ld (hl),$40
	ld a,$08
	call specialObjectSetAnimation
	ld bc,-$180
	call objectSetSpeedZ
	jp itemIncSubstate

@seasonsFunc_06_7052:
	call getRandomNumber
	and $0f
	sub $08
	ld b,a
	ld e,$0c
	ld a,(de)
	inc e
	add b
	ld (de),a

@ret:
	ret

@substateD:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	ld l,Item.counter1
	ld (hl),$28
	ld a,$14
	jp specialObjectSetAnimation

@substateE:
	call itemDecCounter1
	ret nz
	ld a,$07
	ld ($cfd0),a
	jp itemIncSubstate

@substateF:
	ld a,($cfd0)
	cp $09
	ret nz
	call itemIncSubstate
	ld l,Item.speedZ
	ld (hl),$f0
	inc l
	ld (hl),$fd
	; direction
	ld l,Item.direction
	ld (hl),DIR_DOWN
	ld a,$0a
	call specialObjectSetAnimation
	ld a,SND_JUMP
	jp playSound

@substate10:
	call specialObjectAnimate
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	ld l,Item.counter1
	ld (hl),$1e
	xor a
	ld l,Item.direction
	ld (hl),a
	jp specialObjectSetAnimation

@substate11:
	call itemDecCounter1
	ret nz
	ld (hl),$19
	ld l,Item.speed
	ld (hl),SPEED_200
	ld l,Item.angle
	ld (hl),$02
	jp itemIncSubstate

@substate12:
	call specialObjectAnimate
	call objectApplySpeed
	call itemDecCounter1
	ret nz
	jp @seasonsFunc_06_7025

@substate13:
	call itemDecCounter1
	jp nz,@seasonsFunc_06_7052
	ld e,Item.speed
	ld a,SPEED_300
	ld (de),a
	ld e,Item.angle
	ld a,$19
	ld (de),a
	ld e,Item.direction
	xor a
	ld (de),a
	ld (wScrollMode),a
	ld a,$08
	call specialObjectSetAnimation
	jp itemIncSubstate

@substate14:
	call specialObjectAnimate
	call objectApplySpeed
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
	ld a,$0a
	ld ($cfd0),a
	jp itemIncSubstate


linkCutscene2:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call linkCutscene_initOam_setVisible_incState
	ld a,$09
	call specialObjectSetAnimation

@state1:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld hl,$cfd0
	ld a,(hl)
	cp $01
	ret nz
	call specialObjectAnimate
	ld e,Item.animParameter
	ld a,(de)
	inc a
	ret nz
	call itemIncSubstate
	ld l,Item.speedZ
	ld (hl),$f0
	inc l
	ld (hl),$fd
	ld l,Item.direction
	ld (hl),DIR_DOWN
	ld a,$0a
	call specialObjectSetAnimation
	ld a,SND_JUMP
	call playSound

@substate1:
	call seasonsFunc_06_7178
	ret nz
	call itemIncSubstate
	ld l,Item.counter1
	ld (hl),$1e
	ret

@substate2:
	call itemDecCounter1
	ret nz
	ld hl,$cfd0
	ld (hl),$02
	call itemIncSubstate
	ld l,Item.direction
	ld (hl),DIR_LEFT
	ld a,$00
	jp specialObjectSetAnimation

@substate3:
	ld a,($cfd0)
	cp $03
	ret nz
	ld a,SPECIALOBJECTID_LINK
	jp setLinkIDOverride

seasonsFunc_06_7178:
	call specialObjectAnimate
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr z,+
	ld h,d
	ld l,Item.speedZ+1
	ld a,(hl)
	bit 7,a
	ret nz
	cp $03
	ret c
	ld l,Item.speedZ
	xor a
	ldi (hl),a
	ld a,$03
	ld (hl),a
	or a
	ret
+
	ld a,$00
	jp specialObjectSetAnimation

animateRelatedObj2:
	push de
	ld e,Item.relatedObj2+1
	ld a,(de)
	ld d,a
	call interactionAnimate
	pop de
	ret

; @param	a	animation
setRelatedObj2Animation:
	ld b,a
	push de
	ld e,Item.relatedObj2+1
	ld a,(de)
	ld d,a
	ld a,b
	call interactionSetAnimation
	pop de
	ret


linkCutscene3:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call linkCutscene_initOam_setVisible_incState
	ld l,Item.counter1
	ld (hl),$a8
	ld a,$0c
	jp specialObjectSetAnimation

@state1:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemDecCounter1
	jr nz,+
	ld a,$80
	ld ($cfc0),a
	call itemIncSubstate
	ld bc,-$100
	call objectSetSpeedZ
+
	jp specialObjectAnimate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	ld l,Item.counter1
	ld (hl),$0a
	ret

@substate2:
	call itemDecCounter1
	ret nz
	ld (hl),$78
	call itemIncSubstate
	ld a,$0c
	jp specialObjectSetAnimation

@substate3:
	call itemDecCounter1
	ret nz
	ld a,$01
	ld ($cfdf),a
	ret


linkCutscene4:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call linkCutscene_initOam_setVisible_incState
	ld l,Item.angle
	ld (hl),ANGLE_UP
	ld l,Item.speed
	ld (hl),SPEED_100
	ld l,Item.counter1
	ld (hl),$80
	ld a,$00
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

@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call specialObjectAnimate
	call objectApplySpeed
	call itemDecCounter1
	ret nz
	ld (hl),$06
	jp itemIncSubstate

@substate1:
	call itemDecCounter1
	ret nz
	ld (hl),$78
	call itemIncSubstate
	ld a,$03
	jp specialObjectSetAnimation

@substate2:
	call itemDecCounter1
	ret nz
	ld hl,$cfc0
	ld (hl),$01
	jp itemIncSubstate

@substate3:
	ld a,($cfc0)
	cp $02
	ret nz
	call itemIncSubstate
	ld l,Item.angle
	ld (hl),ANGLE_DOWN
	ld bc,-$100
	call objectSetSpeedZ
	ld a,$0d
	jp specialObjectSetAnimation

@substate4:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	ld l,Item.counter1
	ld (hl),$78
	ld l,Item.animCounter
	ld (hl),$01
	ret

@substate5:
	call itemDecCounter1
	jp nz,specialObjectAnimate
	ld hl,$cfdf
	ld (hl),$01
	ret


; Sokra?
linkCutscene5:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call linkCutscene_initOam_setVisible_incState
	ld l,Item.counter1
	ld (hl),$f0
	ld a,$03
	jp specialObjectSetAnimation

@state1:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call itemDecCounter1
	ret nz
	ld l,Item.counter1
	ld (hl),$3c
	call itemIncSubstate
	ld hl,$cfc0
	ld (hl),$01
@seasonsFunc_06_72d0:
	ld bc,$f804
	ld a,$ff
	call objectCreateExclamationMark
	ld l,Interaction.subid
	ld (hl),$01
	ld a,$0e
	jp specialObjectSetAnimation

@substate1:
	call itemDecCounter1
	ret nz
	ld hl,$cfdf
	ld (hl),$01

@ret:
	ret


;;
; Link being kissed by Zelda in ending cutscene - cutsceneA in ages
;
linkCutscene6:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call linkCutscene_initOam_setVisible_incState
	call objectSetInvisible

	call @checkShieldEquipped
	ld a,$0b
	jr nz,+
	ld a,$0f
+
	jp specialObjectSetAnimation

;;
; @param[out]	zflag	Set if shield equipped
@checkShieldEquipped:
	ld hl,wInventoryB
	ld a,ITEMID_SHIELD
	cp (hl)
	ret z
	inc l
	cp (hl)
	ret

@state1:
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfc0)
	cp $01
	ret nz

	call itemIncSubstate
.ifdef ROM_AGES
	jp objectSetVisible82
.else
	jp objectSetVisible
.endif

@substate1:
	ld a,($cfc0)
	cp $07
	ret nz

	call itemIncSubstate
	call @checkShieldEquipped
	ld a,$10
	jr nz,+
	inc a
+
	jp specialObjectSetAnimation

@substate2:
	ld a,($cfc0)
	cp $08
	ret nz

	call itemIncSubstate
	ld l,SpecialObject.counter1
	ld (hl),$68
	inc l
	ld (hl),$01
	ld b,$02
--
	call getFreeInteractionSlot
	jr nz,@@setAnimation
	ld (hl),INTERACID_KISS_HEART
	inc l
	ld a,b
	dec a
	ld (hl),a
	call objectCopyPosition
	dec b
	jr nz,--

@@setAnimation:
	ld a,$12
	jp specialObjectSetAnimation

@substate3:
	call specialObjectAnimate
	ld h,d
	ld l,SpecialObject.counter1
	call decHlRef16WithCap
	ret nz

	ld hl,$cfc0
	ld (hl),$09
	ret


; Sokra?
linkCutscene7:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw linkCutscene5@ret

@state0:
	call linkCutscene_initOam_setVisible_incState
	jp linkCutscene5@seasonsFunc_06_72d0

linkCutscene_initOam_setVisible_incState:
	callab bank5.specialObjectSetOamVariables
	call objectSetVisiblec1
	jp itemIncState


linkCutscene8:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call linkCutscene_initOam_setVisible_incState
	ld l,Item.speed
	ld (hl),SPEED_100
	ld a,$00
	call specialObjectSetAnimation

@state1:
	call specialObjectAnimate
	call angleToY48X50
	call moveToAngleSnapToGrid
	call checkCloseToY48X50
	ret nc
	ld a,SPECIALOBJECTID_LINK
	jp setLinkIDOverride


linkCutscene9:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call linkCutscene_initOam_setVisible_incState
	push de
	call clearItems
	pop de
	ld a,$13
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
	.dw @ret

@substate0:
	ld a,($cfd1)
	or a
	ret z
	call itemIncSubstate
	ld l,Item.counter1
	ld (hl),$28
	ld l,Item.speed
	ld (hl),SPEED_20
	ld l,Item.angle
	ld (hl),ANGLE_DOWN
	ret

@substate1:
	call itemDecCounter1
	jp nz,objectApplySpeed
	ld (hl),$19
	jp itemIncSubstate

@substate2:
	call itemDecCounter1
	ret nz
	call itemIncSubstate
	ld l,Item.speed
	ld (hl),SPEED_300
	ld l,Item.angle
	xor a
	ld (hl),a
	ld l,Item.zh
	ld (hl),$fa
@animate:
	ld l,Item.animCounter
	ld (hl),$01
	jp specialObjectAnimate

@substate3:
	call objectApplySpeed
	ld e,Item.yh
	ld a,(de)
	cp $10
	ret nc
	ld a,SND_ROLLER
	call playSound
	call itemIncSubstate
	ld l,Item.counter1
	ld (hl),$1e
	jr @animate

@substate4:
	call itemDecCounter1
	jr nz,+
	call itemIncSubstate
	ld bc,-$c0
	jp objectSetSpeedZ

@substate5:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	jr @animate
+
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld a,$04
	ld (wScreenShakeCounterY),a

@ret:
	ret


;;
; Cutscene played on starting a new game ("accept our quest, hero") - cutsceneA in ages
;
linkCutsceneA:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call linkCutscene_initOam_setVisible_incState
	call objectSetVisible81

	ld l,SpecialObject.counter1
	ld (hl),$2c
	inc hl
	ld (hl),$01
	ld l,SpecialObject.yh
	ld (hl),$d0
	ld l,SpecialObject.xh
	ld (hl),$50

	ld a,$08
	call specialObjectSetAnimation
	xor a
	ld (wTmpcbb9),a

.ifdef ROM_AGES
	ldbc INTERACID_SPARKLE, $0d
.else
	ldbc INTERACID_SPARKLE, $09
.endif
	call objectCreateInteraction
	jr nz,@state1
	ld l,Interaction.relatedObj1
	ld a,SpecialObject.start
	ldi (hl),a
	ld (hl),d

@state1:
	ld a,(wFrameCounter)
	ld ($cbb7),a
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call linkCutscene_oscillateZ_2
	ld hl,w1Link.counter1
	call decHlRef16WithCap
	ret nz

	ld (hl),$3c
	jp itemIncSubstate

@substate1:
	call linkCutscene_oscillateZ_2
	call itemDecCounter1
	ret nz

	call itemIncSubstate
.ifdef ROM_AGES
	ld bc,TX_1213
.else
	ld bc,TX_0c16
.endif
	jp showText

@substate2:
	ld hl,linkCutscene_zOscillation1
	call linkCutscene_oscillateZ
	ld a,(wTextIsActive)
	or a
	ret nz

	ld a,$06
	ld (wTmpcbb9),a
	ld a,SND_FAIRYCUTSCENE
	call playSound
	jp linkCutscene_createGlowingOrb

@substate3:
	ld e,SpecialObject.animParameter
	ld a,(de)
	inc a
	jr nz,+
	ld a,$07
	ld (wTmpcbb9),a
	ret
+
	call specialObjectAnimate
	ld a,(wFrameCounter)
	rrca
	jp nc,objectSetInvisible
	jp objectSetVisible


linkCutscene_oscillateZ_2:
	ld hl,linkCutscene_zOscillation2
	jp linkCutscene_oscillateZ


angleToY48X50:
	ld e,Item.var03
	ld a,(de)
	ld hl,checkCloseToY48X50@destination
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,Item.angle
	ld (de),a
	jp objectApplySpeed

checkCloseToY48X50:
	ld e,Item.var03
	ld a,(de)
	ld bc,@destination
	call addDoubleIndexToBc
	ld h,d
	ld l,Item.yh
	ld a,(bc)
	sub (hl)
	add $01
	cp $03
	ret nc
	inc bc
	ld l,Item.xh
	ld a,(bc)
	sub (hl)
	add $01
	cp $03
	ret
@destination:
	.db $48 $50

moveToAngleSnapToGrid:
	ld a,(wFrameCounter)
	and $07
	ret nz
	; Every 8 frames
	ld e,Item.angle
	ld a,(de)
	ld hl,angleToDirectionTable
	rst_addAToHl
	ld a,(hl)
	ld e,Item.direction
	ld (de),a
	ret
angleToDirectionTable:
	.db $00 $00 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $02
	.db $02 $02 $03 $03 $03 $03 $03 $03
	.db $03 $03 $03 $03 $03 $03 $03 $00
