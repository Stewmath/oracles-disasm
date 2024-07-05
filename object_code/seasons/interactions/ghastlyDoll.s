; ==================================================================================================
; INTERAC_LON_LON_EGG
; ==================================================================================================
interactionCode94:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01
	ld ($cc02),a
	ld hl,$d02d
	ld a,(hl)
	or a
	ret nz
	ld a,$01
	ld (de),a
	call objectTakePosition
	ld bc,$3850
	call objectGetRelativeAngle
	and $1c
	ld e,$49
	ld (de),a
	ld bc,$ff00
	call objectSetSpeedZ
	ld l,$50
	ld (hl),$28
	call interactionInitGraphics
	ld a,($d01a)
	ld e,$5a
	ld (de),a
	ld a,$57
	jp playSound
@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	jp interactionIncState
@state2:
	ld hl,$d10b
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	ld a,(wMapleState)
	and $20
	jr z,+
	ld e,$4b
	ld a,(de)
	cp b
	jr nz,+
	ld e,$4d
	ld a,(de)
	cp c
	jr z,@func_53b6
+
	call objectGetRelativeAngle
	xor $10
	ld ($d109),a
	ret
@func_53b6:
	ld a,$ff
	ld ($d109),a
	call interactionIncState
	call objectSetInvisible
	ld a,$5e
	call playSound
	ld bc,TX_070a
	jp showText
@state3:
	ld a,$04
	ld ($cc6a),a
	ld a,$01
	ld ($cc6b),a
	ld hl,w1Link.yh
	ld bc,$f200
	call objectTakePositionWithOffset
	call interactionIncState
	ld l,$46
	ld (hl),$40
	ld l,$5b
	ld a,(hl)
	and $f8
	ldi (hl),a
	ldi (hl),a
	ld a,(hl)
	add $02
	ld (hl),a
	ld a,$03
	call interactionSetAnimation
	ld a,($d01a)
	ld e,$5a
	ld (de),a
	ld bc,TX_005c
	call showText
	ld a,TREASURE_TRADEITEM
	ld c,$02
	call giveTreasure
	ld a,$4c
	jp playSound
@state4:
	call interactionDecCounter1
	ret nz
	xor a
	ld ($cba0),a
	ld (wDisabledObjects),a
	ld a,$02
	ld ($d105),a
	jp interactionDelete
