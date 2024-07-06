; ==================================================================================================
; ENEMY_DRAGONFLY
; ==================================================================================================
enemyCode53:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw dragonfly_state0
	.dw dragonfly_state1
	.dw dragonfly_state2
	.dw dragonfly_state3
	.dw dragonfly_state4
	.dw dragonfly_state5


; Initialization
dragonfly_state0:
.ifdef ROM_SEASONS
	ld a,(wRoomStateModifier)
	cp SEASON_AUTUMN
	jp nz,enemyDelete
.endif
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.subid
	ld a,(hl)
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.zh
	ld (hl),-$08
	jp objectSetVisiblec1


; Choosing new direction to move in
dragonfly_state1:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$03

	ld l,Enemy.speed
	ld (hl),SPEED_200

	call getRandomNumber_noPreserveVars
	and $06
	ld c,a

	ld b,$00
	ld e,Enemy.yh
	ld a,(de)
	cp (SMALL_ROOM_HEIGHT/2)<<4
	jr c,+
	inc b
+
	ld e,Enemy.xh
	ld a,(de)
	cp (SMALL_ROOM_WIDTH/2)<<4
	jr c,+
	set 1,b
+
	ld a,b
	ld hl,@angleVals
	rst_addAToHl
	ld a,(hl)
	add c
	and $1f
	ld e,Enemy.angle
	ld (de),a

	; Update animation
	ld e,Enemy.angle
	ld a,(de)
	ld b,a
	and $0f
	ret z

	ld a,b
	cp $10
	ld a,$01
	jr c,+
	dec a
+
	jp enemySetAnimation

@angleVals:
	.db $08 $02 $12 $18


; Move in given direction for 3 frames at SPEED_200
dragonfly_state2:
	call dragonfly_applySpeed
	jr nz,@nextState

	call ecom_decCounter1
	jr nz,dragonfly_animate

@nextState:
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$0c

dragonfly_animate:
	jp enemyAnimate


; Slowing down over 12 frames, eventually reaching SPEED_140
dragonfly_state3:
	call dragonfly_applySpeed
	jr nz,@nextState

	call ecom_decCounter1
	jr z,@nextState

	ld a,(hl) ; [counter1]
	rrca
	jr nc,dragonfly_animate

	ld l,Enemy.speed
	ld a,(hl)
	sub SPEED_20
	ld (hl),a
	jr dragonfly_animate

@nextState:
	ld e,Enemy.state
	ld a,$04
	ld (de),a

	; Set counter1 somewhere in range $18-$1f
	call getRandomNumber_noPreserveVars
	and $07
	add $18
	ld e,Enemy.counter1
	ld (de),a
	jr dragonfly_animate


; Moving at SPEED_140 for between 24-31 frames
dragonfly_state4:
	call dragonfly_applySpeed
	jr nz,@nextState

	call ecom_decCounter1
	jr nz,dragonfly_animate

@nextState:
	call getRandomNumber_noPreserveVars
	and $7f
	add $20
	ld e,Enemy.counter1
	ld (de),a

	ld e,Enemy.state
	ld a,$05
	ld (de),a
	jr dragonfly_animate


; Holding still for [counter1] frames
dragonfly_state5:
	call ecom_decCounter1
	jr nz,dragonfly_animate

	ld l,e
	ld (hl),$01 ; [state]
	jr dragonfly_animate


;;
; @param[out]	zflag	nz if touched a wall
dragonfly_applySpeed:
	ld a,$02 ; Only screen boundaries count as walls
	call ecom_getSideviewAdjacentWallsBitset
	ret nz
	call objectApplySpeed
	xor a
	ret
