; ==================================================================================================
; INTERAC_SEASONS_FAIRY
; ==================================================================================================
interactionCode50:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

@state0:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.substate
	ld (hl),$01
	ld l,Interaction.counter1
	ld (hl),$01
	ld l,Interaction.zh
	ld (hl),$00

	ld a,MUS_FAIRY_FOUNTAIN
	ld (wActiveMusic),a
	jp playSound

@@substate1:
	call interactionDecCounter1
	ret nz

	ld l,Interaction.substate
	ld (hl),$02
	ld l,Interaction.counter1
	ld (hl),$10
	jr @createPuff

@@substate2:
	call interactionDecCounter1
	ret nz

	call interactionInitGraphics
	call objectSetVisible80

	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld l,Interaction.substate
	ld (hl),$00

	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,++

	ld l,Interaction.counter1
	ld (hl),120
	call @createSparkle0
	jp @updateAnimation
++
	ld l,Interaction.counter1
	ld (hl),60
	call @createSparkle1
	jp @updateAnimation


@createPuff:
	jp objectCreatePuff

@createSparkle0:
	ld bc,$8400
	jr @createInteraction

@createSparkle1:
	ldbc INTERAC_SPARKLE,$07
	call objectCreateInteraction
	ld e,Interaction.counter1
	ld a,(de)
	ld l,e
	ld (hl),a
	ret

@createSparkle2:
	ldbc INTERAC_SPARKLE,$01

@createInteraction:
	jp objectCreateInteraction


@state1:
	call objectOscillateZ_body
	call interactionDecCounter1
	jr z,++

	call @updateAnimation
	ld a,(wFrameCounter)
	rrca
	jp nc,objectSetInvisible
	jp objectSetVisible
++
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr z,++

	ld l,Interaction.state
	ld (hl),$05
	ld hl,$cfc0
	set 1,(hl)
	call objectSetVisible
	jr @updateAnimation
++
	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.zh
	ld (hl),$00
	ld l,Interaction.var3a
	ld (hl),$30

	ld l,Interaction.angle
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),SPEED_80

	call objectSetVisible
	ld a,SND_CHARGE_SWORD
	call playSound

@state2:
	call objectApplySpeed

	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	cp $10
	jr nc,@updateAnimation

	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),$04
	ld l,Interaction.var3b
	ld (hl),$00

	ld a,(w1Link.yh)
	ld l,Interaction.yh
	ld (hl),a
	ld a,(w1Link.xh)
	ld l,Interaction.xh
	ld (hl),a

	call @func_48eb

@state3:
	call @checkLinkIsClose
	jr c,++

	call @func_48d0
	call @func_48f9
	ld a,(de)
	ld e,Interaction.var3b
	call objectSetPositionInCircleArc
	call @func_4907
	ld a,(wFrameCounter)
	and $07
	call z,@createSparkle2
	jr @updateAnimation
++
	ld l,Interaction.state
	inc (hl)
	ld hl,$cfc0
	set 1,(hl)

@updateAnimation:
	jp interactionAnimate

@state4:
	call objectOscillateZ_body
	ld a,($cfc0)
	cp $07
	jp z,interactionDelete
	jr @updateAnimation

@state5:
	call objectOscillateZ_body
	ld a,($cfc0)
	cp $07
	jr nz,@updateAnimation
	call @createPuff
	jp interactionDelete

;;
@func_48d0:
	ld l,Interaction.yh
	ld e,Interaction.var38
	ld a,(de)
	ldi (hl),a
	inc l
	inc e
	ld a,(de)
	ld (hl),a
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed

;;
@func_48eb:
	ld h,d
	ld l,Interaction.yh
	ld e,Interaction.var38
	ldi a,(hl)
	ld (de),a
	ld b,a
	inc l
	inc e
	ld a,(hl)
	ld (de),a
	ld c,a
	ret

;;
@func_48f9:
	ld e,Interaction.var3a
	ld a,(de)
	or a
	ret z
	call interactionDecCounter1
	ret nz

	ld (hl),$04

	ld l,e
	dec (hl)
	ret

;;
@func_4907:
	ld a,(wFrameCounter)
	rrca
	ret nc

	ld e,Interaction.var3b
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	ret

;;
; @param[out]	cflag	Set if Link is close to this object
@checkLinkIsClose:
	ld h,d
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	add $f0
	sub (hl)
	add $04
	cp $09
	ret nc
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	sub (hl)
	add $02
	cp $05
	ret


;;
; When called once per frame, the object's Z positon will gently oscillate up and down.
;
objectOscillateZ_body:
	ld a,(wFrameCounter)
	and $07
	ret nz

	ld a,(wFrameCounter)
	and $38
	swap a
	rlca

	ld hl,@zOffsets
	rst_addAToHl
.ifdef ROM_AGES
	ldh a,(<hActiveObjectType)
	add Object.zh
	ld e,a
	ld a,(de)
	add (hl)
.else
	ld e,Interaction.zh
	ld a,(hl)
.endif
	ld (de),a
	ret

@zOffsets:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00
