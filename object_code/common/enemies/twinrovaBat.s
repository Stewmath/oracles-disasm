; ==================================================================================================
; ENEMY_TWINROVA_BAT
; ==================================================================================================
enemyCode5e:
	jr z,+
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie_uncounted
+
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMY_MERGED_TWINROVA
	jp nz,enemyDelete

	ld e,Enemy.counter1
	ld a,(de)
	inc a
	and $1f
	ld a,SND_BOOMERANG
	call z,playSound

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_200

	ld l,Enemy.counter2
	ld (hl),$50

	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	ld (de),a

	ld a,SND_VERAN_FAIRY_ATTACK
	call playSound
	jp objectSetVisible82


@state1:
	call @updateOamFlags
	call ecom_decCounter2
	jr nz,@animate

	ld l,e
	inc (hl) ; [state]
	call ecom_updateAngleTowardTarget


@state2:
	call @checkInBounds
	jp nc,enemyDelete

	call @updateOamFlags
	call objectApplySpeed
@animate:
	jp enemyAnimate


;;
; @param[out]	cflag	c if in bounds
@checkInBounds:
	ld e,Enemy.yh
	ld a,(de)
	cp LARGE_ROOM_HEIGHT<<4
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	cp LARGE_ROOM_WIDTH<<4
	ret

;;
@updateOamFlags:
	call ecom_decCounter1
	ld a,(hl)
	and $04
	rrca
	rrca
	add $02
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	ret
