; ==================================================================================================
; PART_POE_SISTER_FLAME
; ==================================================================================================
partCode3c:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	ld bc,$0104
	call partCommon_decCounter1IfNonzero
	jr z,@delete
	ld a,(hl)
	cp $46
	jr z,+
	ld bc,$0206
	cp $28
	jp nz,partAnimate
+
	ld l,$e6
	ld (hl),c
	inc l
	ld (hl),c
	ld a,b
	jp partSetAnimation
@delete:
	pop hl
	jp partDelete
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$64
	jp objectSetVisible83
