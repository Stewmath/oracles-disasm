; ==================================================================================================
; INTERAC_FALLING_ROCK
; ==================================================================================================
interactionCode92:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw fallingRock_subid00
	.dw fallingRock_subid01
	.dw fallingRock_subid02
	.dw fallingRock_subid03
	.dw fallingRock_subid04
	.dw fallingRock_subid05
	.dw fallingRock_subid06


; Spawner of falling rocks; stops when $cfdf is nonzero. Used when freeing goron elder.
fallingRock_subid00:
	call checkInteractionState
	jr nz,@state1

@state0:
	call interactionIncState
	ld l,Interaction.counter2
	ld (hl),$01
@state1:
	ld a,(wTmpcfc0.goronCutscenes.elder_stopFallingRockSpawner)
	or a
	jp nz,interactionDelete

	call interactionDecCounter2
	ret nz

	ld l,Interaction.counter2
	ld (hl),20
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_FALLING_ROCK
	inc l
	ld (hl),$01
	inc l
	ld e,Interaction.var03
	ld a,(de)
	ld (hl),a
	ret


; Instance of falling rock spawned by subid $00
fallingRock_subid01:
	call checkInteractionState
	jr nz,@state1
	call fallingRock_initGraphicsAndIncState
	call fallingRock_chooseRandomPosition

@state1:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jr nz,@ret

	; Rock has hit the ground
	call objectReplaceWithAnimationIfOnHazard
	jp c,interactionDelete

	ld a,SND_BREAK_ROCK
	call playSound
	call @spawnDebris
	ld a,$04
	call setScreenShakeCounter
	jp interactionDelete
@ret:
	ret

@spawnDebris:
	call getRandomNumber
	and $03
	ld c,a
	ld b,$00
@next:
	push bc
	ldbc INTERAC_FALLING_ROCK, $02
	call objectCreateInteraction
	pop bc
	ret nz
	ld l,Interaction.counter1
	ld (hl),c
	ld l,Interaction.angle
	ld (hl),b
	inc b
	ld a,b
	cp $04
	jr nz,@next
	ret


; Used by gorons when freeing elder?
fallingRock_subid02:
	call checkInteractionState
	jr nz,@state1

@state0:
	call fallingRock_initGraphicsAndIncState
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,++

	ld l,Interaction.counter1
	ld a,(hl)
	jr @loadAngle
++
	ld l,Interaction.counter1
	ld a,(hl)
	add $04
@loadAngle:
	add a
	add a
	ld l,Interaction.angle
	add (hl)
	ld bc,@angles
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,@lowSpeed

	ld l,Interaction.speed
	ld (hl),SPEED_180
	ld l,Interaction.speedZ
	ld a,$18
	ldi (hl),a
	ld (hl),$ff
	ret

@lowSpeed:
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.speedZ
	ld a,$1c
	ldi (hl),a
	ld (hl),$ff
	ret

; List of angle values.
; A byte is read from offset: ([counter1] + ([var03] != 0 ? 4 : 0)) * 4 + [angle]
; (These 3 variables should be set by whatever spawned this object)
@angles:
	.db $04 $0c $14 $1c $02 $0a $12 $1a
	.db $04 $0c $14 $1c $06 $0e $16 $1e
	.db $1a $14 $0c $06 $16 $1c $04 $0a

@state1:
	ld a,(wTmpcfc0.goronCutscenes.cfde)
	or a
	jp nz,interactionDelete

fallingRock_updateSpeedAndDeleteWhenLanded:
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jp z,interactionDelete
	jp objectApplySpeed


; A twinkle? angle is a value from 0-3, indicating a diagonal to move in.
fallingRock_subid03:
	call checkInteractionState
	jr nz,fallingRock_subid03_state1

@state0:
	call fallingRock_initGraphicsAndIncState
	call interactionSetAlwaysUpdateBit
fallingRock_initDiagonalAngle:
	ld l,Interaction.angle
	ld a,(hl)
	ld bc,@diagonalAngles
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ret

@diagonalAngles:
	.db $04 $0c $14 $1c

fallingRock_subid03_state1:
	ld e,Interaction.animParameter
	ld a,(de)
	cp $ff
	jp z,interactionDelete
	call interactionAnimate
	jp objectApplySpeed


; Blue/Red rock debris, moving straight on a diagonal? (angle from 0-3)
fallingRock_subid04:
fallingRock_subid05:
	call checkInteractionState
	jr nz,@state1

@state0:
	call fallingRock_initGraphicsAndIncState
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.counter1
	ld (hl),$0c
	jr fallingRock_initDiagonalAngle
@state1:
	call interactionDecCounter1
	jp z,interactionDelete
	call interactionAnimate
	jp objectApplySpeed


; Debris from pickaxe workers?
fallingRock_subid06:
	call checkInteractionState
	jp nz,fallingRock_updateSpeedAndDeleteWhenLanded

@state0:
	call fallingRock_initGraphicsAndIncState
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.var03
	ld a,(hl)
	or $08
	ld l,Interaction.oamFlags
	ld (hl),a
	ld l,Interaction.counter2
	ld a,(hl)
	or a
	jr z,+
	dec a
+
	ld b,a
	ld l,Interaction.visible
	ld a,(hl)
	and $bc
	or b
	ld (hl),a

	ld l,Interaction.angle
	ld a,(hl)
	ld bc,@angles
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.speedZ
	ld a,$40
	ldi (hl),a
	ld (hl),$ff
	ret

@angles:
	.db $08 $18

;;
fallingRock_initGraphicsAndIncState:
	call interactionInitGraphics
	call objectSetVisiblec1
	jp interactionIncState

;;
; Randomly choose a position from a list of possible positions. var03 determines which
; list it reads from?
fallingRock_chooseRandomPosition:
	ld e,Interaction.var03
	ld a,(de)
	or a
	ld hl,@positionList1
	jr z,++
	ld hl,@positionList2
	ld e,Interaction.oamFlags
	ld a,$04
	ld (de),a
++
	call getRandomNumber
	and $0f
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a
	cpl
	inc a
	sub $08
	ld e,Interaction.zh
	ld (de),a
	ldi a,(hl)
	ld e,Interaction.xh
	ld (de),a
	ret

@positionList1:
	.db $50 $18
	.db $60 $18
	.db $70 $18
	.db $48 $20
	.db $50 $28
	.db $70 $28
	.db $40 $38
	.db $60 $38
	.db $6c $38
	.db $78 $38
	.db $50 $48
	.db $70 $48
	.db $48 $50
	.db $50 $58
	.db $60 $58
	.db $70 $58

@positionList2:
	.db $50 $38
	.db $60 $38
	.db $70 $38
	.db $48 $40
	.db $50 $48
	.db $70 $48
	.db $40 $58
	.db $60 $58
	.db $6c $88
	.db $78 $88
	.db $50 $98
	.db $70 $98
	.db $48 $a0
	.db $50 $a8
	.db $60 $a8
	.db $70 $a8
