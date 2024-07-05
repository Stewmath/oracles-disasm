; ==================================================================================================
; PART_DODONGO_FIREBALL
; ==================================================================================================
partCode41:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
	jp partAnimate
@state0:
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$d0
	ld (hl),$78
	ld l,$cb
	ld a,$04
	add (hl)
	ld (hl),a
	ld l,$c9
	ld a,(hl)
	bit 3,a
	ld e,$cb
	jr z,+
	ld e,$cd
+
	swap a
	rlca
	ld b,a
	ld hl,table_70f3
	rst_addAToHl
	ld a,(de)
	add (hl)
	ld (de),a
	ld a,b
	call partSetAnimation
	ld a,$72
	call playSound
	ld e,$c9
	ld a,(de)
	or a
	jp z,objectSetVisible82
	jp objectSetVisible81
table_70f3:
	.db $ee $12 $10 $ee
