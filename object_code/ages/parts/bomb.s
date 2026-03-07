; ==================================================================================================
; PART_BOMB
; ==================================================================================================
partCode47:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.speed
	ld (hl),SPEED_200

	ld l,Part.speedZ
	ld a,<(-$280)
	ldi (hl),a
	ld (hl),>(-$280)

	call objectSetVisiblec1

; Waiting to be thrown
@state1:
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectTakePosition

; Being thrown
@state2:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,partAnimate

	; Landed on ground; time to explode

	ld l,Part.state
	inc (hl) ; [state] = 3

	ld l,Part.collisionType
	set 7,(hl)

	ld l,Part.oamFlagsBackup
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01
	call partSetAnimation

	ld a,SND_EXPLOSION
	call playSound

	jp objectSetVisible83

; Exploding
@state3:
	call partAnimate
	ld e,Part.animParameter
	ld a,(de)
	inc a
	jp z,partDelete

	dec a
	ld e,Part.collisionRadiusY
	ld (de),a
	inc e
	ld (de),a
	ret
