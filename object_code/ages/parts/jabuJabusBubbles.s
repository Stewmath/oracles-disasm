; ==================================================================================================
; PART_JABU_JABUS_BUBBLES
; Bubble spawned from Jabu Jabu?
; ==================================================================================================
partCode16:
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
	ld l,$c0
	set 7,(hl)
	ld l,$cd
	ld a,(hl)
	cp $50
	ld bc,$ff80
	jr c,+
	ld bc,$0080
+
	ld l,$d2
	ld (hl),c
	inc l
	ld (hl),b
	call getRandomNumber_noPreserveVars
	ld b,a
	and $07
	ld e,$c6
	ld (de),a
	ld a,b
	and $18
	swap a
	rlca
	ld hl,@table_5fa7
	rst_addAToHl
	ld e,$d0
	ld a,(hl)
	ld (de),a
	ld a,b
	and $e0
	swap a
	add a
	ld e,$c7
	ld (de),a
	ld e,$c2
	ld a,(de)
	call partSetAnimation
	jp objectSetVisible82
@table_5fa7:
	.db $1e $28
	.db $32 $3c
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	inc l
	ldd a,(hl)
	ld (hl),a
	ld l,e
	inc (hl)
+
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
	ret
@state2:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
+
	ld l,$d2
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	ld l,$cc
	ld e,l
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	add hl,bc
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
@state3:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	cp $f0
	jp nc,partDelete
	ld h,d
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
	ld l,$c7
	dec (hl)
	and $0f
	ret nz
	ld l,$d0
	ld a,(hl)
	sub $05
	cp $13
	ret c
	ld (hl),a
	ret
