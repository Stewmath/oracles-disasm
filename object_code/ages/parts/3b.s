; ==================================================================================================
; PART_3b
; Used by head thwomp (purple face); a boulder.
; ==================================================================================================
partCode3b:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	or a
	jr z,@subid0
	jp @subid1
	
@subid0:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d5
	ld (hl),$02
	ld l,$cb
	ldh a,(<hCameraY)
	ldi (hl),a
	inc l
	ld a,(hl)
	or a
	jr nz,+
	call getRandomNumber_noPreserveVars
	and $7c
	ld b,a
	ldh a,(<hCameraX)
	add b
	ld e,$cd
	ld (de),a
+
	call objectSetVisible82
	ld a,SND_FALLINHOLE
	jp playSound
@@state1:
	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	jr c,@@func_6ebd
	ld a,(de)
	cp $b0
	jr c,@@animate
	jp partDelete
@@func_6ebd:
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld (hl),$02
	ld a,$01
	call partSetAnimation
	ld a,SND_BREAK_ROCK
	jp playSound
@@state2:
	ld e,$e1
	ld a,(de)
	bit 7,a
	jp nz,partDelete
	ld hl,@@table_6ee9
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
@@animate:
	jp partAnimate
@@table_6ee9:
	.db $04 $09 $06 $0b $09
	.db $0c $0a $0d $0b $0e
	
@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @subid0@state2
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d5
	ld (hl),$02
	ld l,$cb
	ldi a,(hl)
	inc l
	or (hl)
	jr nz,@@setVisiblec2
	call getRandomNumber_noPreserveVars
	and $7c
	ld b,a
	ldh a,(<hRng2)
	and $7c
	ld c,a
	ld e,$cb
	ldh a,(<hCameraY)
	add b
	ld (de),a
	ld e,$cd
	ldh a,(<hCameraX)
	add c
	ld (de),a
@@setVisiblec2:
	jp objectSetVisiblec2
@@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,@subid0@animate
	jr @subid0@func_6ebd
