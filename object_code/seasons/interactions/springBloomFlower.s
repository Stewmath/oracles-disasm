; ==================================================================================================
; INTERAC_SPRINGBLOOM_FLOWER
; ==================================================================================================
interactionCode9c:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
@state0:
	ld a,$01
	ld (de),a
	ld a,($cc4e)
	or a
	jp nz,interactionDelete
	ld a,$06
	call objectSetCollideRadius
	call interactionInitGraphics
	call objectSetVisible83
@state1:
	ld a,($ccc3)
	or a
	jr z,+
	ld a,$05
	jr ++
+
	ld a,($cc88)
	or a
	ret nz
	ld a,($cc48)
	rrca
	ret c
	call objectCheckCollidedWithLink
	ret nc
	ld a,$02
	ld ($ccc3),a
++
	ld e,$44
	ld (de),a
	ld a,$01
	jp interactionSetAnimation
@state2:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	ret z
	ld a,($cc48)
	cp $d0
	jp nz,seasonsFunc_0a_5d18
	call checkLinkID0AndControlNormal
	jp nc,seasonsFunc_0a_5d18
	call objectCheckCollidedWithLink
	jp nc,seasonsFunc_0a_5d18
	ld e,$44
	ld a,$03
	ld (de),a
	call clearAllParentItems
	call dropLinkHeldItem
	call resetLinkInvincibility
	ld a,$83
	ld (wDisabledObjects),a
	ld ($cc88),a
	call setLinkForceStateToState08
	call interactionSetAlwaysUpdateBit
	xor a
	ld e,$61
	call func_5cf2
	ld e,$4d
	ld a,(de)
	ld (w1Link.xh),a
	xor a
	ld ($d00f),a
	ld a,$52
	call playSound
	ld a,$02
	jp interactionSetAnimation
@state3:
	ld a,$10
	ld ($cc6b),a
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	jr z,@func_5ca0
	cp $02
	call nc,func_5cf2
	ret
@func_5ca0:
	ld a,$06
	call func_5cf2
	xor a
	ld (wDisabledObjects),a
	ld e,$44
	ld a,$04
	ld (de),a
	ld a,$06
	ld ($cc6a),a
	jp objectSetVisible83
@state4:
@state7:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	jr seasonsFunc_0a_5d18
@state5:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	ret z
	ld a,$52
	call playSound
	call interactionIncState
	ld a,$02
	jp interactionSetAnimation
@state6:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	jr nz,@func_5ce8
	ld (de),a
	ld ($ccc3),a
	call objectSetVisible83
	jp interactionIncState
@func_5ce8:
	dec a
	ld ($ccc3),a
	cp $02
	ret c
	jp objectSetVisible82
func_5cf2:
	ld hl,table_5d08
	rst_addDoubleIndex
	xor a
	ld (de),a
	ld e,$4b
	ld a,(de)
	add (hl)
	ld (w1Link.yh),a
	inc hl
	ld e,$5a
	ld a,(de)
	and $f0
	or (hl)
	ld (de),a
	ret
table_5d08:
	; yh - xh
	.db $f9 $03
	.db $f9 $03
	.db $f8 $03
	.db $f9 $01
	.db $fa $01
	.db $ff $01
	.db $f0 $01
	.db $00 $01

seasonsFunc_0a_5d18:
	ld e,$44
	ld a,$01
	ld (de),a
	dec a
	ld ($ccc3),a
	call interactionSetAlwaysUpdateBit
	res 7,(hl)
	call objectSetVisible83
	ld a,$00
	jp interactionSetAnimation
