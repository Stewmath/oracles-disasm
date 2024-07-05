; ==================================================================================================
; INTERAC_bb
; ==================================================================================================
interactionCodebb:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
@@state0:
	call func_7867
	ld l,$43
	ld a,(hl)
	call interactionSetAnimation
@@state1:
	call interactionRunScript
	call func_7886
	ld a,($cfc0)
	bit 7,a
	ret z
	call func_788e
	jp interactionIncState
@@state2:
	call interactionRunScript
	call func_7886
	call decVar3c
	ret nz
	ld l,$44
	inc (hl)
	ld l,$7c
	ld (hl),$0a
	jp func_78c3
@@state3:
	call interactionRunScript
	call func_7886
	call decVar3c
	ret nz
	ld l,$44
	inc (hl)
	ld l,$50
	ld (hl),$28
	ld l,$7c
	ld (hl),$58
	call func_78b3
	ld a,$d2
	jp playSound
@@state4:
	call decVar3c
	jp z,interactionDelete
	call objectApplySpeed
	call interactionRunScript
	jp func_7886
@subid1:
@subid2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$42
	ld a,(hl)
	ld b,$02
	cp $03
	jr z,+
	ld b,$00
+
	ld l,$5c
	ld (hl),b
	ld l,$46
	ld (hl),$78
	jp objectSetVisiblec1
@@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	.dw @@substate8
	.dw @@substate9
	.dw @@substateA
	.dw @@substateB
@@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$66
	ld l,$50
	ld (hl),$32
	ld l,$49
	ld (hl),$18
	call interactionIncSubstate
@@setAnimationBasedOnAngle:
	ld e,$49
	ld a,(de)
	call convertAngleDeToDirection
	jp interactionSetAnimation
@@substate1:
	call @@animateTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz
	call getRandomNumber
	and $0f
	add $1e
	ld (hl),a
	ld l,$49
	ld (hl),$08
	call @@setAnimationBasedOnAngle
	jp interactionIncSubstate
@@animateTwiceAndApplySpeed:
	call interactionAnimate
	call interactionAnimate
	jp objectApplySpeed
@@substate2:
	call interactionDecCounter1
	ret nz
	call func_77eb
	jp interactionIncSubstate
@@substate3:
	call func_77e5
	ld a,($cfd0)
	cp $01
	ret nz
	ld e,$4f
	ld a,(de)
	or a
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ret
@@substate4:
	call interactionDecCounter1
	ret nz
	ld l,$50
	ld (hl),$50
	call @@func_772e
	jp interactionIncSubstate
@@substate5:
	ld a,($cfd0)
	cp $02
	jr nz,+
	ld e,$4f
	ld a,(de)
	or a
	jr nz,+
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0a
	ld l,$49
	ld (hl),$18
	jp @@setAnimationBasedOnAngle
+
	ld e,$77
	ld a,(de)
	rst_jumpTable
	.dw @@var77_00
	.dw @@var77_01
	.dw @@var77_02
@@var77_00:
	call @@animateTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz
	ld (hl),$0a
	ld l,$77
	inc (hl)
	cp $68
	ld a,$01
	jr c,+
	ld a,$03
+
	jp interactionSetAnimation
@@var77_01:
	call interactionDecCounter1
	ret nz
	ld (hl),$1e
	ld l,$77
	inc (hl)
	jp func_77eb
@@var77_02:
	call func_77e5
	call interactionDecCounter1
	ret nz
	xor a
	ld l,$4e
	ldi (hl),a
	ld (hl),a
	ld l,$77
	ld (hl),$00
@@func_772e:
	ld e,$42
	; subid_01-02
	ld a,(de)
	dec a
	ld b,a
	swap a
	sra a
	add b
	; subid01 - index $00, subid02 - index $09
	ld hl,@@table_775a
	rst_addAToHl
	ld e,Interaction.counter2
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	inc l
	ld e,$46
	ld (de),a
	ld e,$49
	ld a,b
	ld (de),a
	ld e,$47
	ld a,(de)
	ld b,a
	inc b
	ld a,(hl)
	or a
	jr nz,+
	ld b,$00
+
	ld a,b
	ld (de),a
	jp @@setAnimationBasedOnAngle
@@table_775a:
	; counter1 - angle
	; subid1
	.db $1a $09
	.db $16 $1f
	.db $17 $17
	.db $0c $0f
	.db $00
	; subid2
	.db $0c $09
	.db $18 $0a
	.db $16 $18
	.db $12 $1f
	.db $00
	; subid3 from interactionCodebc / bd / be
	.db $1d $08
	.db $19 $16
	.db $18 $0a
	.db $06 $01
	.db $00
@@substate6:
	call interactionDecCounter1
	ret nz
	ld e,$42
	ld a,(de)
	ld b,$34
	cp $03
	jr z,+
	ld b,$20
+
	ld (hl),b
	ld l,$50
	ld (hl),$3c
	jp interactionIncSubstate
@@substate7:
	call @@animateTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz
	call getRandomNumber
	and $07
	inc a
	ld (hl),a
	ld a,$01
	call interactionSetAnimation
	jp interactionIncSubstate
@@substate8:
	ld a,($cfd0)
	cp $03
	ret nz
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jr func_77eb
@@substate9:
	call func_77e5
	ld a,($cfd0)
	cp $04
	ret nz
	ld e,$4f
	ld a,(de)
	or a
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0c
	ret
@@substateA:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$50
	ld l,$50
	ld (hl),$3c
	ld a,$03
	jp interactionSetAnimation
@@substateB:
	call @@animateTwiceAndApplySpeed
	call interactionDecCounter1
	jp z,interactionDelete
	ret
func_77e5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
func_77eb:
	ld bc,$ff20
	jp objectSetSpeedZ
