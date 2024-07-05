; ==================================================================================================
; PART_LIGHTNING
; ==================================================================================================
partCode27:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	call getRandomNumber_noPreserveVars
	ld e,Part.var30
	and $06
	ld (de),a

	ld h,d
	ld l,Part.zh
	ld (hl),$c0

	ld l,Part.relatedObj1+1
	ld a,(hl)
	or a
	ret z

	ld l,Part.counter1
	ld (hl),$1e
	ld l,Part.yh
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	inc l
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ret

@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld a,SND_LIGHTNING
	call playSound
	jp objectSetVisible81

@state2:
	call partAnimate
	ld e,Part.animParameter
	ld a,(de)
	inc a
	jp z,partDelete

	call @func_55a6
	ld e,Part.var03
	ld a,(de)
	or a
	ret z
.ifdef ROM_AGES
	ld a,$ff
.else
	ld b,a
	ld a,($cfd2)
	or b
.endif
	ld ($cfd2),a
	ret

@func_55a6:
	ld e,Part.animParameter
	ld a,(de)
	bit 7,a
	call nz,@func_55e7
	ld e,Part.animParameter
	ld a,(de)
	and $0e

	ld hl,@table_55da
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld e,Part.animParameter
	ld a,(de)
	and $70
	swap a
	ld hl,@table_55e2
	rst_addAToHl
	ld e,$cf
	ld a,(hl)
	ld (de),a
	ld e,$e1
	ld a,(de)
	bit 0,a
	ret z
	dec a
	ld (de),a
	ld a,$06
	jp setScreenShakeCounter

@table_55da:
	.db $02 $02
	.db $04 $06
	.db $05 $09
	.db $04 $05

@table_55e2:
	.db $c0 $d0
	.db $e0 $f0
	.db $00

@func_55e7:
	res 7,a
	ld (de),a
	and $0e
	sub $02
	ld b,a
	ld e,Part.var30
	ld a,(de)
	add b
	ld hl,@table_5603
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),$08
	jp objectCopyPositionWithOffset

@table_5603:
	.db $02 $06
	.db $00 $fb
	.db $ff $07
	.db $fd $fc
	.db $00 $05
