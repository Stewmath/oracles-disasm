; ==================================================================================================
; INTERAC_c1
;
; Variables:
;   counter1/counter2: 16-bit counter
;   var36: Counter for sparkle spawning
; ==================================================================================================
interactionCodec1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.counter1
	ld (hl),<390
	inc l
	ld (hl),>390 ; [counter2]
	ld l,Interaction.var36
	ld (hl),$06
	ld l,Interaction.angle
	ld (hl),$15
	ld l,Interaction.speed
	ld (hl),SPEED_300
	jp objectSetVisible82

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.counter1
	call decHlRef16WithCap
	ret nz
	ld l,Interaction.counter1
	ld (hl),40
	jp interactionIncSubstate

@substate1:
	call @updateMovementAndSparkles
	jr nz,@ret
	ld l,Interaction.animCounter
	ld (hl),$01
	jp interactionIncSubstate

@substate2:
	call interactionAnimate
	call @updateSparkles
	call objectApplySpeed
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	jp z,interactionDelete
	ret

;;
; @param[out]	zflag	z if [counter1] == 0
@updateMovementAndSparkles:
	call @updateSparkles
	call objectApplySpeed
	jp interactionDecCounter1

@ret:
	ret

;;
; Unused
@func_7224:
	ld a,(wFrameCounter)
	and $01
	jp z,objectSetInvisible
	jp objectSetVisible

;;
@updateSparkles:
	ld h,d
	ld l,Interaction.var36
	dec (hl)
	ret nz
	ld (hl),$06 ; [var36]
.ifdef ROM_AGES
	ldbc INTERAC_SPARKLE, $09
.else
	ldbc INTERAC_SPARKLE, $05
.endif
	jp objectCreateInteraction
