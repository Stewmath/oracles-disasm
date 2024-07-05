; ==================================================================================================
; ENEMY_BEAMOS
; ==================================================================================================
enemyCode16:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9


@state_uninitialized:
	call ecom_setSpeedAndState8AndVisible
	ld l,Enemy.counter1
	ld (hl),$05
	jp objectMakeTileSolid


@state_stub:
	ret


@state8:
	call @updateAngle
	call ecom_decCounter2
	ret nz
	jr @checkFireBeam


@state9:
	call ecom_decCounter1
	jr nz,++
	ld (hl),$05 ; [counter1] = 5
	inc l
	ld (hl),40  ; [counter2] = 40
	ld l,e
	dec (hl) ; [state] = 8
	ret
++
	; Play sound on 11th-to-last frame
	ld a,(hl)
	cp $0b
	ld a,SND_BEAM
	jp z,playSound
	ret nc

	; Spawn projectile every frame for 10 frames
	ld b,PART_BEAM
	call ecom_spawnProjectile
	ret nz

	ld e,Enemy.counter1
	ld a,(de)
	and $01
	ld l,Part.subid
	ld (hl),a
	ret

;;
; Increments angle every 5 frames.
@updateAngle:
	call ecom_decCounter1
	ret nz

	ld (hl),$05
	ld l,Enemy.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a

	ld hl,@angleToAnimation
	rst_addAToHl
	ld a,(hl)
	jp enemySetAnimation

@angleToAnimation:
	.db $00 $00 $01 $01 $01 $01 $01 $02
	.db $02 $02 $03 $03 $03 $03 $03 $04
	.db $04 $04 $05 $05 $05 $05 $05 $06
	.db $06 $06 $07 $07 $07 $07 $07 $00

;;
@checkFireBeam:
	call objectGetAngleTowardEnemyTarget
	ld h,d
	ld l,Enemy.angle
	sub (hl)
	inc a
	cp $02
	ret nc

	ld l,Enemy.counter1
	ld (hl),20

	; "Invincibility" is just for the glowing effect?
	ld l,Enemy.invincibilityCounter
	ld (hl),$14

	ld l,Enemy.state
	inc (hl) ; [state] = 9
	ret
