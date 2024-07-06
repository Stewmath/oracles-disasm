; ==================================================================================================
; INTERAC_GURU_GURU
; ==================================================================================================
interactionCode58:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	ld h,d
	ld l,$44
	ld (hl),$01
	ld l,$7c
	ld (hl),$01
	ld l,$77
	ld (hl),$78
	ld l,$7b
	ld (hl),$01
	ld l,$79
	ld (hl),$01
	ld l,$50
	ld (hl),$0f
	call func_7e20
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.guruGuruScript
	call interactionSetScript
	jp func_7ddc
@state1:
	call interactionRunScript
	call func_7deb
	jr func_7ddc
func_7ddc:
	ld e,$79
	ld a,(de)
	or a
	jr z,+
	call interactionAnimate
+
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
func_7deb:
	ld e,$78
	ld a,(de)
	rst_jumpTable
	.dw @var38_00
	.dw func_7e38
@var38_00:
	ld e,$7b
	ld a,(de)
	or a
	jr z,func_7e0f
	ld h,d
	ld l,$77
	dec (hl)
	ret nz
	ld (hl),$78
	ld l,$49
	ld a,(hl)
	xor $10
	ld (hl),a
	ld l,$7a
	ld a,(hl)
	xor $02
	ld (hl),a
	jp interactionSetAnimation
func_7e0f:
	ld h,d
	ld l,$78
	ld (hl),$01
	ld l,$79
	ld (hl),$00
	ld a,($d00d)
	ld l,$4d
	cp (hl)
	jr nc,func_7e2c
func_7e20:
	ld l,$49
	ld (hl),$18
	ld l,$7a
	ld a,$03
	ld (hl),a
	jp interactionSetAnimation
func_7e2c:
	ld l,$49
	ld (hl),$08
	ld l,$7a
	ld a,$01
	ld (hl),a
	jp interactionSetAnimation
func_7e38:
	ld e,$7b
	ld a,(de)
	or a
	ret z
	ld h,d
	ld l,$78
	ld (hl),$00
	ld l,$79
	ld (hl),$01
	ld l,$77
	ld (hl),$78
	ret
