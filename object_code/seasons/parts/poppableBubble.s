; ==================================================================================================
; PART_POPPABLE_BUBBLE
; ==================================================================================================
partCode32:
	jr z,@normalStatus
	ld e,$c5
	ld a,(de)
	or a
	jr nz,func_68d5
	call func_68cc
	ld a,$af
	jp playSound
@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld e,$c2
	ld a,(de)
	call partSetAnimation
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@table_68b9
	rst_addAToHl
	ld a,(hl)
	ld e,$d0
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $3f
	add $78
	ld h,d
	ld l,$c6
	ldi (hl),a
	ld (hl),$10
	jp objectSetVisible81
@table_68b9:
	.db $0a $0f $0f $14
@state1:
	ld e,$c5
	ld a,(de)
	or a
	jr nz,func_68d5
	call objectApplySpeed
	call partCommon_decCounter1IfNonzero
	jp nz,seasonsFunc_10_68e0

func_68cc:
	ld h,d
	ld l,$c5
	inc (hl)
	ld a,$02
	jp partSetAnimation

func_68d5:
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	jp z,partDelete
	ret

seasonsFunc_10_68e0:
	ld h,d
	ld l,$c7
	dec (hl)
	ret nz
	ld (hl),$10
	call getRandomNumber
	and $03
	ret nz
	and $01
	jr nz,+
	ld a,$ff
+
	ld l,$c9
	add (hl)
	ld (hl),a
	ret
