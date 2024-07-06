; ==================================================================================================
; PART_3d
; ==================================================================================================
partCode3d:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld e,$c2
	ld a,(de)
	or a
	jr nz,+
	ld l,$d4
	ld a,$40
	ldi (hl),a
	ld (hl),$ff
	ld l,$d0
	ld (hl),$3c
+
	inc e
	ld a,(de)
	or a
	jr z,+
	ld l,$c4
	inc (hl)
	ld l,$e4
	res 7,(hl)
	ld l,$c6
	ld (hl),$1e
	call @func_6cf4
+
	jp objectSetVisiblec1
@state1:
	call partCode.partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplySpeed
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jr nz,@animate
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld (hl),$a0
	ld l,$e6
	ld (hl),$05
	inc l
	ld (hl),$04
	call func_6e13
@func_6cf4:
	ld a,$6f
	call playSound
	ld a,$01
	jp partSetAnimation
@state2:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld (hl),$14
	ld l,e
	inc (hl)
	ld a,$02
	jp partSetAnimation
@state3:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
@animate:
	jp partAnimate
