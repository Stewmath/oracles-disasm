; ==================================================================================================
; INTERAC_TIMEWARP
;
; Variables:
;   var03: ?
;   relatedObj2: ?
; ==================================================================================================
interactionCodedd:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw timewarp_subid0
	.dw timewarp_subid1
	.dw timewarp_subid2
	.dw timewarp_subid3
	.dw timewarp_subid4

timewarp_subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw timewarp_common_state0
	.dw timewarp_subid0_state1
	.dw timewarp_subid0_state2
	.dw timewarp_animateUntilFinished


timewarp_common_state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.yh
	ldh a,(<hEnemyTargetY)
	add $08
	ldi (hl),a
	inc l
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	jp objectSetVisible83


timewarp_subid0_state1:
	call timewarp_animate
	jp z,interactionIncState
	dec a
	jr nz,+
	ret
+
	xor a
	ld (de),a ; [animParameter]

	ld b,$03

;;
; @param	b	Subid of INTERAC_TIMEWARP object to spawn
timewarp_spawnChild:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_TIMEWARP
	inc l
	ld (hl),b ; [subid]
	inc l
	ld e,l
	ld a,(de) ; [var03]
	ld (hl),a
	ld e,Interaction.relatedObj2
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld bc,$f800
	jp objectCopyPositionWithOffset


timewarp_subid0_state2:
	call interactionDecCounter1
	jr z,@counterReached0

	ld a,(hl) ; [counter1]
	cp 36
	ret c
	and $07
	ret nz
	ld a,(hl)
	and $38
	rrca
	ld hl,@data
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ld e,(hl)

	call getFreePartSlot
	ret nz
	ld (hl),PART_TIMEWARP_ANIMATION
	inc l
	ld (hl),e ; [subid]

	ld e,Interaction.relatedObj2+1
	ld a,(de)
	ld l,Part.relatedObj1+1
	ldd (hl),a
	ld (hl),Interaction.start

	ld l,Part.speed
	ld (hl),b

	ld b,$00
	jp objectCopyPositionWithOffset

@counterReached0:
	ld a,$01
	call interactionSetAnimation
	ld a,Object.state
	call objectGetRelatedObject2Var
	inc (hl)
	jp interactionIncState

; Data format:
;   b0: speed
;   b1: x-offset
;   b2: subid
;   b3: unused
@data:
	.db SPEED_280, $fc, $00, $00
	.db SPEED_2c0, $09, $03, $00
	.db SPEED_240, $f7, $02, $00
	.db SPEED_2c0, $04, $01, $00
	.db SPEED_240, $fc, $00, $00
	.db SPEED_280, $04, $01, $00
	.db SPEED_2c0, $f7, $02, $00
	.db SPEED_240, $09, $03, $00


timewarp_animateUntilFinished:
	call timewarp_animate
	ret nz
	jp interactionDelete


timewarp_subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw timewarp_common_state0
	.dw timewarp_subid1_state1
	.dw timewarp_animateUntilFinished ; TODO


timewarp_subid1_state1:
	call timewarp_animate
	jr z,++
	dec a
	ret z

	xor a
	ld (de),a ; [animParameter
	ld b,$04
	jp timewarp_spawnChild
++
	ld a,Object.state
	call objectGetRelatedObject2Var
	inc (hl)
	call interactionIncState
	ld a,$01
	jp interactionSetAnimation

timewarp_subid2:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.speedTmp
	ld (hl),$fc
	ld l,Interaction.counter1
	ld (hl),$06
	jp objectSetVisible81

@state1:
	call timewarp_animate
	ret nz
	jp interactionIncState

@state2:
	call objectApplyComponentSpeed
	ld e,Interaction.yh
	ld a,(de)
	cp $f0
	jp nc,interactionDelete
	call interactionDecCounter1
	ret nz
	ld (hl),$06
	ldbc INTERAC_SPARKLE, $01
	call objectCreateInteraction
	ret nz
	ld l,Interaction.var03
	inc (hl)
	ret


timewarp_subid3:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw itemwarp_subid3Or4_state0
	.dw timewarp_subid3_state1
	.dw interactionAnimate
	.dw timewarp_subid3Or4_state3
	.dw timewarp_subid3Or4_state4

itemwarp_subid3Or4_state0:
	ld e,Interaction.var03
	ld a,(de)
	add $c0
	call loadPaletteHeader
	call interactionInitGraphics
	call interactionIncState
	jp objectSetVisible82

timewarp_subid3_state1:
	call timewarp_animate
	ret nz
	ld a,$03
	call interactionSetAnimation
	jp interactionIncState

timewarp_subid3Or4_state3:
	call interactionIncState
	ld a,$04
	jp interactionSetAnimation

timewarp_subid3Or4_state4:
	call timewarp_animate
	ret nz
	jp interactionDelete


timewarp_subid4:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw itemwarp_subid3Or4_state0
	.dw interactionAnimate
	.dw timewarp_subid3Or4_state3 ; Actually state 2...
	.dw timewarp_subid3Or4_state4 ; Actually state 3...


;;
; @param[out]	a	[Interaction.animParameter]+1
timewarp_animate:
	call interactionAnimate
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	ret
