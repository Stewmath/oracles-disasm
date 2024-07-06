; ==================================================================================================
; ENEMY_VERAN_SPIDER
; ==================================================================================================
enemyCode0f:
	ld b,a

	; Kill spiders when a cutscene trigger occurs
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	or a
	ld a,b
	jr z,+
	ld a,ENEMYSTATUS_NO_HEALTH
+
	or a
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback
	ret

@normalStatus:
	call ecom_checkScentSeedActive
	jr z,++
	ld e,Enemy.speed
	ld a,SPEED_140
	ld (de),a
++
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw veranSpider_state_uninitialized
	.dw veranSpider_state_stub
	.dw veranSpider_state_stub
	.dw veranSpider_state_switchHook
	.dw veranSpider_state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw veranSpider_state_stub
	.dw veranSpider_state_stub
	.dw veranSpider_state8
	.dw veranSpider_state9
	.dw veranSpider_stateA


veranSpider_state_uninitialized:
	ld a,PALH_8a
	call loadPaletteHeader

	; Choose a random position roughly within the current screen bounds to spawn the
	; spider at. This prevents the spider from spawning off-screen. But, the width is
	; only checked properly in the last row; if this were spawned in a small room, the
	; spiders could spawn off-screen. (Large rooms aren't a problem since there is no
	; off-screen area to the right, aside from one column, which is marked as solid.)
--
	call getRandomNumber
	and $7f
	cp $70 + SCREEN_WIDTH
	jr nc,--

	ld c,a
	call objectSetShortPosition

	; Adjust position to be relative to screen bounds
	ldh a,(<hCameraX)
	add (hl)
	ldd (hl),a
	ld c,a

	dec l
	ldh a,(<hCameraY)
	add (hl)
	ld (hl),a
	ld b,a

	; If solid at this position, try again next frame.
	call getTileCollisionsAtPosition
	ret nz

	ld c,$08
	call ecom_setZAboveScreen
	ld a,SPEED_60
	call ecom_setSpeedAndState8

	ld l,Enemy.collisionType
	set 7,(hl)

	ld a,SND_FALLINHOLE
	call playSound
	jp objectSetVisiblec1


veranSpider_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret

@substate3:
	ld b,$09
	jp ecom_fallToGroundAndSetState


veranSpider_state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jr z,veranSpider_gotoState9

	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	and $18
	add $04
	ld (de),a
	call ecom_applyVelocityForSideviewEnemyNoHoles


;;
veranSpider_updateAnimation:
	ld h,d
	ld l,Enemy.animCounter
	ld a,(hl)
	sub $03
	jr nc,+
	xor a
+
	inc a
	ld (hl),a
	jp enemyAnimate

;;
veranSpider_gotoState9:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.speed
	ld (hl),SPEED_60
	ret


veranSpider_state_stub:
	ret


; Falling from sky
veranSpider_state8:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ret nz

	; Landed on ground
	ld l,Enemy.speedZ
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.state
	inc (hl)

	; Enable scent seeds
	ld l,Enemy.var3f
	set 4,(hl)

	call objectSetVisiblec2
	ld a,SND_BOMB_LAND
	call playSound

	call veranSpider_setRandomAngleAndCounter1
	jr veranSpider_animate


; Moving in some direction for [counter1] frames
veranSpider_state9:
	; Check if Link is along a diagonal relative to self?
	call objectGetAngleTowardEnemyTarget
	and $07
	sub $04
	inc a
	cp $03
	jr nc,@moveNormally

	; He is on a diagonal; if counter2 is zero, go to state $0a (charge at Link).
	ld e,Enemy.counter2
	ld a,(de)
	or a
	jr nz,@moveNormally

	call ecom_updateAngleTowardTarget
	and $18
	add $04
	ld (de),a

	call ecom_incState
	ld l,Enemy.speed
	ld (hl),SPEED_140
	ld l,Enemy.counter1
	ld (hl),120
	ret

@moveNormally:
	call ecom_decCounter2
	dec l
	dec (hl) ; [counter1]--
	call nz,ecom_applyVelocityForSideviewEnemyNoHoles
	jp z,veranSpider_setRandomAngleAndCounter1

veranSpider_animate:
	jp enemyAnimate


; Charging in some direction for [counter1] frames
veranSpider_stateA:
	call ecom_decCounter1
	jr z,++
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jp nz,veranSpider_updateAnimation
++
	call veranSpider_gotoState9
	ld l,Enemy.counter2
	ld (hl),$40


;;
veranSpider_setRandomAngleAndCounter1:
	ld bc,$1870
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	add $04
	ld (de),a
	ld e,Enemy.counter1
	ld a,c
	add $70
	ld (de),a
	ret
