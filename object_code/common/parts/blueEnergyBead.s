; ==================================================================================================
; PART_BLUE_ENERGY_BEAD
; Used by "createEnergySwirl" functions
; ==================================================================================================
partCode53:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	ld a,(wDeleteEnergyBeads)
	or a
	jp nz,partDelete
	ld h,d
	ld l,$c6
	ld a,(hl)
	inc a
	jr z,+
	dec (hl)
	jp z,partDelete
+
	inc e
	ld a,(de)
	or a
	jr nz,+
	inc l
	dec (hl)
	ret nz
	ld l,e
	inc (hl)
	ld l,$f2
	ld a,(hl)
	swap a
	rrca
	ld l,$c3
	add (hl)
	call partSetAnimation
	call func_5e1a
	jp objectSetVisible
+
	call objectApplySpeed
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	ret nz
	ld h,d
	ld l,$c5
	dec (hl)
	call objectSetInvisible
	jr +
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c0
	set 7,(hl)
	ld l,$d0
	ld (hl),$78
	ld l,$c3
	ld a,(hl)
	add a
	add a
	xor $10
	ld l,$c9
	ld (hl),a
	xor a
	ld (wDeleteEnergyBeads),a
+
	call getRandomNumber_noPreserveVars
	and $07
	inc a
	ld e,$c7
	ld (de),a
	ret

;;
createEnergySwirlGoingOut_body:
	ld a,$01
	jr ++

;;
; @param	bc	Center of the swirl
; @param	l	Duration of swirl ($ff and $00 are infinite)?
createEnergySwirlGoingIn_body:
	xor a
++
	ldh (<hFF8B),a
	push de
	ld e,l
	ld d,$08
--
	call getFreePartSlot
	jr nz,@end

	; Part.id
	ld (hl),PART_BLUE_ENERGY_BEAD

	; Set duration
	ld l,Part.counter1
	ld (hl),e

	; Set center of swirl
	ld l,Part.var30
	ld (hl),b
	inc l
	ld (hl),c
	inc l

	; [Part.var32] = whether it's going in or out
	ldh a,(<hFF8B)
	ld (hl),a

	; Give each Part a unique index
	ld l,Part.var03
	dec d
	ld (hl),d
	jr nz,--

@end:
	pop de
	ld a,SND_ENERGYTHING
	jp playSound

func_5e1a:
	ld h,d
	ld l,Part.var32
	ldd a,(hl)
	or a
	jr nz,+
	ld e,Part.var03
	ld a,(de)
	add a
	add a
	ld e,Part.direction
	ld (de),a
	ld c,(hl)
	dec l
	ld b,(hl)
	ld a,$38
	jp objectSetPositionInCircleArc
+
	ld e,Part.xh
	ldd a,(hl)
	ld (de),a
	ld e,Part.yh
	ld a,(hl)
	ld (de),a
	ret
