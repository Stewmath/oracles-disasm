; ==================================================================================================
; ENEMY_ENABLE_SIDESCROLL_DOWN_TRANSITION
; ==================================================================================================
enemyCode2b:
	ld e,Enemy.state
	ld a,(de)
	or a
	jp z,ecom_incState

	ld hl,w1Link.xh
	ld a,(hl)
	cp $d0
	ret c

	ld l,<w1Link.yh
	ld a,(hl)
	ld l,<w1Link.speedZ+1
	add (hl)
	cp (LARGE_ROOM_HEIGHT<<4) - 8
	ret c

	ld a,$80|DIR_DOWN
	ld (wScreenTransitionDirection),a
	ret
