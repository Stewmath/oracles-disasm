; ==================================================================================================
; INTERAC_NAYRU_RALPH_CREDITS
; ==================================================================================================
interactionCodedf:
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
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.angle
	ld (hl),$18

	ld l,Interaction.counter1
	ld (hl),60
	ld l,Interaction.subid
	ld a,(hl)
	or a
	jp z,objectSetVisiblec2
	jp objectSetVisiblec0

@state1:
	ld e,Interaction.substate
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
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate

@substate1:
	call interactionAnimate
	call objectApplySpeed
	cp $68 ; [xh]
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),180

	ld l,Interaction.subid
	ld a,(hl)
	or a
	ret nz
	ld a,$05
	jp interactionSetAnimation

@substate2:
	call interactionDecCounter1
	ret nz
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld (hl),$01
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$04
	inc l
	ld (hl),$01 ; [counter2]
	jr @setRandomVar38

@substate3:
	ld h,d
	ld l,Interaction.counter1
	call decHlRef16WithCap
	jr nz,@label_10_330

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),100

	ld b,SPEED_80 ; Nayru
	ld c,$04
	ld l,Interaction.subid
	ld a,(hl)
	or a
	jr z,++
	ld b,SPEED_180 ; Ralph
	ld c,$02
++
	ld l,Interaction.speed
	ld (hl),b
	ld a,c
	call interactionSetAnimation
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld (hl),$02
	ret

@label_10_330:
	ld l,Interaction.subid
	ld a,(hl)
	or a
	call z,interactionAnimate

.ifdef ROM_AGES
	ld l,Interaction.var38
.else
	ld l,Interaction.var37
.endif
	dec (hl)
	ret nz

	ld l,Interaction.direction
	ld a,(hl)
	xor $01
	ld (hl),a

	ld e,Interaction.subid
	ld a,(de)
	add a
	add (hl)
	call interactionSetAnimation

@setRandomVar38:
	call getRandomNumber_noPreserveVars
	and $03
	swap a
	add $20
.ifdef ROM_AGES
	ld e,Interaction.var38
.else
	ld e,Interaction.var37
.endif
	ld (de),a
	ret

@substate4:
	call interactionDecCounter1
	ret nz

	ld b,120
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
	ld b,160
+
	ld (hl),b ; [counter1]
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld (hl),$03
	jp interactionIncSubstate

@substate5:
	call interactionDecCounter1
	ret nz
	ld (hl),60 ; [counter1]
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld (hl),$04
	jp interactionIncSubstate

@substate6:
	call interactionAnimate
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld (hl),$01
	ret
