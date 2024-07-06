; ==================================================================================================
; PART_48
; ==================================================================================================
partCode48:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid0:
	ld a,(de)
	or a
	jr z,+
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	and $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PART_48
	inc l
	inc (hl)
	ret
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$96
	ret

@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ldh a,(<hCameraY)
	ld b,a
	ldh a,(<hCameraX)
	ld c,a
	call getRandomNumber
	ld e,a
	and $07
	swap a
	add $28
	add c
	ld l,$cd
	ld (hl),a
	ld a,e
	and $70
	add $08
	ld e,a
	add b
	ld l,$cb
	ld (hl),a
	ld a,e
	cpl
	inc a
	sub $07
	ld l,$cf
	ld (hl),a
	jp objectSetVisiblec1

@@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,+
	call objectReplaceWithAnimationIfOnHazard
	jp c,partDelete
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld (hl),$02
	ld a,$a5
	call playSound
	ld a,$01
	call partSetAnimation

@@state2:
	ld e,$e1
	ld a,(de)
	bit 7,a
	jp nz,partDelete
	ld hl,@table_7847
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
+
	jp partAnimate

@table_7847:
	.db $04 $09 $06 $0b $09
	.db $0c $0a $0d $0b $0e

@subid2:
	ld b,$06
	call checkBPartSlotsAvailable
	ret nz
	ld a,$00
	call objectGetRelatedObject1Var
	call objectTakePosition
	ld b,$06
-
	call getFreePartSlot
	ld (hl),PART_48
	inc l
	ld (hl),$03
	ld l,$c9
	ld (hl),b
	call objectCopyPosition
	dec b
	jr nz,-
	jp partDelete

@subid3:
	ld a,(de)
	or a
	jr z,+
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jp z,partDelete
	jp objectApplySpeed
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld a,$02
	ld (hl),a
	ld l,$e6
	ldi (hl),a
	ld (hl),a
	ld l,$e8
	ld (hl),$fc
	ld l,$d0
	ld (hl),$50
	ld l,$d4
	ld a,$20
	ldi (hl),a
	ld (hl),$ff
	ld l,$c9
	ld a,(hl)
	dec a
	ld bc,@table_78bb
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld a,$02
	call partSetAnimation
	jp objectSetVisible82

@table_78bb:
	.db $04 $08 $0d
	.db $16 $1a $1e

@subid4:
	ld a,(de)
	or a
	jr z,+
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	and $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PART_48
	inc l
	ld (hl),$05
	ret
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$61
	ret

@subid5:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cb
	ld (hl),$28
	call getRandomNumber_noPreserveVars
	and $7f
	cp $40
	jr c,+
	add $20
+
	ld e,$cd
	ld (de),a
	jp objectSetVisible82

@@state1:
	ld h,d
	ld l,$d4
	ld e,$ca
	call add16BitRefs
	cp $a0
	jr nc,+
	dec l
	ld a,(hl)
	add $10
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a
	ret
+
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld (hl),$02
	ld a,$a5
	call playSound
	ld a,$01
	call partSetAnimation

@@state2:
	ld e,$e1
	ld a,(de)
	bit 7,a
	jp nz,partDelete
	jp partAnimate
