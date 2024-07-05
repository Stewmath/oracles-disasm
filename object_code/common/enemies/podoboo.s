; ==================================================================================================
; ENEMY_PODOBOO
;
; Variables:
;   relatedObj1: "Parent" (for subid 1, the lava particle)
;   var30: Animation index
;   var31: Initial Y position; the point at which the podoboo returns back to the lava
; ==================================================================================================
enemyCode29:
	; Return for ENEMYSTATUS_01 or ENEMYSTATUS_STUNNED
	dec a
	ret z
	dec a
	ret z

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw podoboo_state_uninitialized
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state_stub
	.dw podoboo_state8
	.dw podoboo_state9
	.dw podoboo_stateA
	.dw podoboo_stateB
	.dw podoboo_stateC

podoboo_state_uninitialized:
	; Note: a is uninitialized; arbitrary speed
	call ecom_setSpeedAndState8
	ld e,Enemy.subid
	ld a,(de)
	or a
	ret z

	; Subid 1 only

	ld (hl),$0c ; [state] = $0c

	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var30
	ld a,(hl)
	inc a
	call enemySetAnimation
	jp objectSetVisible83


podoboo_state_stub:
	ret


; Subid 0: Waiting for Link to approach horizontally
podoboo_state8:
	ld h,d
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $30
	cp $61
	ret nc

	; Save initial Y-position so we know when the leap is done
	ld l,Enemy.yh
	ld a,(hl)
	ld l,Enemy.var31
	ld (hl),a
	jr podoboo_beginMovingUp


; Leaping out of lava
podoboo_state9:
	call enemyAnimate
	call podoboo_updatePosition
	jr z,@doneLeaping

	ld a,(hl) ; hl == Enemy.speedZ+1
	or a
	jr nz,podoboo_spawnLavaParticleEvery16Frames

	; Moving down
	ld l,Enemy.var30
	cp (hl)
	ret z
	ld (hl),a
	call enemySetAnimation
	jr podoboo_spawnLavaParticle

@doneLeaping:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.collisionType
	res 7,(hl)


; Just re-entered the lava
podoboo_stateA:
	call podoboo_makeLavaSplash
	ret nz

	; Wait a random amount of time before resurfacing
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,podoboo_counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a

	call ecom_incState
	jp objectSetInvisible


; Waiting for [counter1] frames before jumping out again.
podoboo_stateB:
	call ecom_decCounter1
	ret nz
	inc (hl)
	jr podoboo_beginMovingUp


; State for "lava particle" (subid 1); just animate until time to delete self.
podoboo_stateC:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jp z,enemyDelete
	dec a
	jp nz,objectSetInvisible
	jp ecom_flickerVisibility


;;
podoboo_spawnLavaParticleEvery16Frames:
	call ecom_decCounter1
	ld a,(hl)
	and $0f
	ret nz

;;
podoboo_spawnLavaParticle:
	ld b,ENEMY_PODOBOO
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz
	call objectCopyPosition
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	ret


;;
; Makes a splash, sets animation and speed, enables collisions for when the splash has
; just spawned, sets state to 9.
podoboo_beginMovingUp:
	call podoboo_makeLavaSplash
	ret nz

	call objectSetVisible82

	ld e,Enemy.var30
	ld a,$02
	ld (de),a
	call enemySetAnimation

	ld bc,-$440
	call objectSetSpeedZ

	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.collisionType
	set 7,(hl)
	xor a
	ret


;;
; @param[out]	zflag	z if created successfully
podoboo_makeLavaSplash:
	ldbc INTERAC_LAVASPLASH,$01
	jp objectCreateInteraction


; Value randomly chosen from here
podoboo_counter1Vals:
	.db $10 $50 $50 $50


;;
; @param[out]	zflag	z if returned to original position.
podoboo_updatePosition:
	ld h,d
	ld l,Enemy.speedZ
	ld e,Enemy.y
	call add16BitRefs
	ld b,a

	; Check if Enemy.y has returned to its original position
	ld e,Enemy.var31
	ld a,(de)
	cp b
	jr c,++

	; If so, [Enemy.speedZ] += $001c
	dec l
	ld a,$1c
	add (hl)
	ldi (hl),a
	ld a,$00
	adc (hl)
	ld (hl),a
	or d
	ret
++
	; Reached original position.
	ld l,Enemy.yh
	ldd (hl),a
	ld (hl),$00
	xor a
	ret
