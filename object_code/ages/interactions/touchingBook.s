; ==================================================================================================
; INTERAC_TOUCHING_BOOK
; ==================================================================================================
interactionCodea5:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
	.dw @state8

@state0:
	ld a,$01
	ld (wMenuDisabled),a
	ld hl,w1Link.knockbackCounter
	ld a,(hl)
	or a
	ret nz

	ld a,$01
	ld (de),a ; [state]

	call objectTakePosition
	ld bc,$3850
	call objectGetRelativeAngle
	and $1c
	ld e,Interaction.angle
	ld (de),a

	ld bc,-$100
	call objectSetSpeedZ

	ld l,Interaction.speed
	ld (hl),SPEED_100

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit

	ld a,(w1Link.visible)
	ld e,Interaction.visible
	ld (de),a

	ld a,SND_GAINHEART
	jp playSound

@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	jp interactionIncState

@state2:
	call @updateMapleAngle
	ret nz
	ld a,$ff
	ld (w1Companion.angle),a
	call interactionIncState
	call objectSetInvisible
	ld a,SND_GETSEED
	call playSound
	ld bc,TX_070e
	jp showText

@state3:
	call retIfTextIsActive
	ld hl,w1Link.xh
	ldd a,(hl)
	ld b,$f0
	cp $58
	jr nc,+
	ld b,$10
+
	add b
	ld e,Interaction.xh
	ld (de),a
	dec l
	ld a,(hl) ; [w1Link.yh]
	ld e,Interaction.yh
	ld (de),a
	xor a
	ld (w1Companion.angle),a
	jp interactionIncState

@state4:
	call @updateMapleAngle
	ret nz
	ld hl,w1Companion.angle
	ld a,$ff
	ldd (hl),a
	ld a,(hl) ; [w1Companion.direction]
	xor $02
	dec h
	ld (hl),a ; [w1Link.direction]
	call interactionIncState
	ld bc,TX_070f
	jp showText

@state5:
	call retIfTextIsActive
	ld a,(w1Companion.direction)
	xor $02
	set 7,a
	ld (w1Companion.direction),a
	call interactionIncState
	ld bc,TX_0710
	jp showText

@state6:
	call retIfTextIsActive
	ld a,(w1Companion.direction)
	res 7,a
	ld (w1Companion.direction),a
	jp interactionIncState

@state7:
	ldbc TREASURE_TRADEITEM, TRADEITEM_MAGIC_OAR
	call createTreasure
	ret nz
	ld e,Interaction.counter1
	ld a,$02
	ld (de),a
	push de
	ld de,w1Link.yh
	call objectCopyPosition_rawAddress
	pop de
	jp interactionIncState

@state8:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr z,++
	dec a
	ld (de),a
	ret
++
	call retIfTextIsActive

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a

	ld a,$02
	ld (w1Companion.substate),a
	jp interactionDelete

;;
; @param[out]	zflag	z if reached touching book
@updateMapleAngle:
	ld hl,w1Companion.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)

	ld a,(wMapleState)
	and $20
	jr z,++
	ld e,Interaction.yh
	ld a,(de)
	cp b
	jr nz,++
	ld e,Interaction.xh
	ld a,(de)
	cp c
	ret z
++
	call objectGetRelativeAngle
	xor $10
	ld (w1Companion.angle),a
	or d
	ret
