; ==================================================================================================
; INTERAC_SYRUP_CUCCO
;
; Variables:
;   var3c: $00 normally, $01 while cucco is chastizing Link
;   var3d: Animation index?
;   var3e: Also an animation index?
; ==================================================================================================
.ifdef ROM_AGES
interactionCodec9:
.else
interactionCode49:
.endif
	call @runState
	jp @updateAnimation

@runState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@updateAnimation:
	ld e,Interaction.var3d
	ld a,(de)
	or a
.ifdef ROM_AGES
	ret z
	jp interactionAnimate
.else
	jr z,+
	call interactionAnimate
+
	jp objectSetVisible80
.endif

@state0:
.ifdef ROM_SEASONS
	call getThisRoomFlags
	and $40
	jp z,interactionDelete
.endif
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics

	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),$06
	inc l
	ld (hl),$06 ; [collisionRadiusX]

	ld l,Interaction.speed
	ld (hl),SPEED_a0
	call @beginHop
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
.ifdef ROM_AGES
	call objectSetVisible80
.endif
	jp @func_7710

@state1:
	call @updateHopping
	call @updateMovement

	; Return if [w1Link.yh] < $69
	ld hl,w1Link.yh
	ld c,$69
	ld b,(hl)
	ld a,$69
	ld l,a
	ld a,c
	cp b
	ret nc

	; Check if he's holding something
	ld a,(wLinkGrabState)
	or a
	ret z

	; Freeze Link
	ld e,Interaction.var3c
	ld a,$02
	ld (de),a
	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a

	ld a,l
	ld hl,w1Link.yh
	ld (hl),a
	jp @initState2

; Unused?
@func_766f:
	xor a
	ld (de),a ; ?
	ld e,Interaction.var3d
	ld (de),a
	ld e,Interaction.var3c
	ld a,$01
	ld (de),a
	ld a,(wLinkGrabState)
	or a
	jr z,@gotoState4

	; Do something with the item Link's holding?
	ld a,(w1Link.relatedObj2+1)
	ld h,a
	ld e,Interaction.var3a
	ld (de),a
	ld hl,mainScripts.syrupCuccoScript_awaitingMushroomText
	jp @setScriptAndGotoState4

@gotoState4:
	ld hl,mainScripts.syrupCuccoScript_awaitingMushroomText

@setScriptAndGotoState4:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	jp interactionSetScript


; Moving toward Link after he tried to steal something
@state2:
	call @updateHopping
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $0c
	ld hl,w1Link.xh
	cp (hl)
	ret nc

	; Reached Link
	ld e,Interaction.var3d
	xor a
	ld (de),a
	ld hl,mainScripts.syrupCuccoScript_triedToSteal
	jp @setScriptAndGotoState4


; Moving back to normal position
@state3:
	call @updateHopping
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	cp $78
	ret c

	xor a
	ld (wDisabledObjects),a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	jp @func_7710


@state4:
	call interactionRunScript
	ret nc

	ld e,Interaction.var3c
	ld a,(de)
	cp $02
	jr z,@beginMovingBack

	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld l,Interaction.var3c
	ld (hl),$00
	ld l,Interaction.var3d
	ld (hl),$01
	xor a
	ld (wDisabledObjects),a
	ret

@beginMovingBack:
	jp @initState3

;;
@updateHopping:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

;;
@beginHop:
	ld bc,-$c0
	jp objectSetSpeedZ

;;
@updateMovement:
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $68
	cp $20
	ret c

	; Reverse direction
	ld e,Interaction.angle
	ld a,(de)
	xor $10
	ld (de),a

	ld e,Interaction.var3e
	ld a,(de)
	xor $01
	ld (de),a
	jp interactionSetAnimation

;;
@func_7710:
	ld h,d
	ld l,Interaction.var3c
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),SPEED_80
	jr +++

;;
@initState2:
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
	ld l,Interaction.speed
	ld (hl),SPEED_200
+++
	ld l,Interaction.var3d
	ld (hl),$01
	ld l,Interaction.angle
	ld (hl),$18
	xor a
	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a
	ld l,Interaction.var3e
	ld a,$00
	ld (hl),a
	jp interactionSetAnimation

;;
@initState3:
	ld h,d
	ld l,Interaction.state
	ld (hl),$03
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld l,Interaction.var3d
	ld (hl),$01
	ld l,Interaction.angle
	ld (hl),$08
	xor a
	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a
	ld l,Interaction.var3e
	ld a,$01
	ld (hl),a
	jp interactionSetAnimation
