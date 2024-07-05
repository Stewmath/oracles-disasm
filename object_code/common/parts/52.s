; ==================================================================================================
; PART_52
; Used by Ganon
; ==================================================================================================
partCode52:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	jp z,partDelete
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

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
	ld l,$c6
	ld (hl),$0a
	jp objectSetVisible82

@@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
	ld a,SND_BEAM
	call playSound
	ld a,$02
	call partSetAnimation

@@state2:
	call partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplySpeed
+
	jp partAnimate

@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @subid0@state2

@@state0:
	ld h,d
	ld l,$d0
	ld (hl),$50
	ld l,e
	call objectSetVisible82
	ld e,$c3
	ld a,(de)
	or a
	jr z,+
	ld (hl),$03
	ld l,$e6
	ld a,$02
	ldi (hl),a
	ld (hl),a
	ret
+
	inc (hl)
	ld l,$c6
	ld (hl),$28
	ld l,$e6
	ld a,$04
	ldi (hl),a
	ld (hl),a
	ld e,$cb
	ld l,$f0
	ld a,(de)
	add $20
	ldi (hl),a
	ld e,$cd
	ld a,(de)
	ld (hl),a
	ld a,$01
	call partSetAnimation

@@state1:
	call partCommon_decCounter1IfNonzero
	jr z,++
	ld a,(hl)
	rrca
	ld e,$c9
	jr c,+
	ld a,(de)
	inc a
	and $1f
	ld (de),a
+
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	ld a,$08
	call objectSetPositionInCircleArc
	jr @@animate
++
	ld (hl),$0a
	ld l,e
	inc (hl)
	ld a,SND_VERAN_PROJECTILE
	call playSound
	call objectSetVisible82
@@animate:
	jp partAnimate

@@state2:
	call partCommon_decCounter1IfNonzero
	jr z,+
	call objectApplySpeed
	jr @@animate
+
	ld l,e
	inc (hl)
	ld l,$e6
	ld a,$02
	ldi (hl),a
	ld (hl),a
	xor a
	call partSetAnimation
	call objectCreatePuff
	ld b,$fd
	call @func_5d31
	ld b,$03

@func_5d31:
	call getFreePartSlot
	ret nz
	ld (hl),PART_52
	inc l
	inc (hl)
	inc l
	inc (hl)
	ld l,$c9
	ld e,l
	ld a,(de)
	add b
	and $1f
	ld (hl),a
	jp objectCopyPosition

@subid2:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @subid0@state2

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$0f
	jp objectSetVisible82

@@state1:
	call partCommon_decCounter1IfNonzero
	jp nz,partAnimate
	ld (hl),$0f
	ld l,e
	inc (hl)
	ld a,SND_VERAN_FAIRY_ATTACK
	call playSound
	ld a,$01
	jp partSetAnimation

@@state2:
	call partCommon_decCounter1IfNonzero
	jp nz,partAnimate
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$5a
	call objectGetAngleTowardLink
	ld e,$c9
	ld (de),a
	ld a,$02
	jp partSetAnimation
