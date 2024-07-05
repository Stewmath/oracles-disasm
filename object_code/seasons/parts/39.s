; ==================================================================================================
; PART_39
; ==================================================================================================
partCode39:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cb
	ld a,(hl)
	sub $1a
	ld (hl),a
	ld l,$c6
	ld (hl),$20
	ld l,$d0
	ld (hl),$3c
	call objectSetVisible80
	ld a,$bf
	jp playSound
+
	ld e,$d7
	ld a,(de)
	inc a
	jp z,partDelete
	call func_6a28
	ret nz
	call partCode.partCommon_checkOutOfBounds
	jp z,partDelete
	ld a,(wFrameCounter)
	rrca
	jr c,+
	ld e,$dc
	ld a,(de)
	xor $07
	ld (de),a
+
	jp objectApplySpeed

func_6a28:
	ld e,$c6
	ld a,(de)
	or a
	ret z
	ld a,$1a
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jp z,partDelete
	call partCommon_decCounter1IfNonzero
	dec a
	ld b,$01
	cp $17
	jr z,+
	or a
	jp nz,partAnimate
	ld h,d
	ld l,$e4
	set 7,(hl)
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	ld a,$be
	call playSound
	ld b,$02
+
	ld a,b
	call partSetAnimation
	or d
	ret
