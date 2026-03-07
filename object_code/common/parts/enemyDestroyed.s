; ==================================================================================================
; PART_ENEMY_DESTROYED
; ==================================================================================================
partCode02:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@initialize
	call partAnimate
	ld a,(wFrameCounter)
	rrca
	jr c,++
	ld e,Part.oamFlags
	ld a,(de)
	xor $01
	ld (de),a
++
	ld e,Part.animParameter
	ld a,(de)
	or a
	ret z

	call @decCounter2
	ld a,(de) ; [counter2]
	rlca
	jp c,partDelete

	xor a
	call decideItemDrop
	jp z,partDelete
	ld b,PART_ITEM_DROP
	jp objectReplaceWithID

@initialize:
	inc a
	ld (de),a ; [state] = 1
	ld e,Part.knockbackCounter
	ld a,(de)
	rlca
	ld a,$01
	call c,partSetAnimation
	jp objectSetVisible82

@decCounter2:
	ld e,Part.counter2
	ld a,(de)
	rrca
	ret nc
	jp decNumEnemies
