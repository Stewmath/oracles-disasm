; ==================================================================================================
; PART_VERAN_BEE_PROJECTILE
; ==================================================================================================
partCode58:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr nz,@normalStatus
	ld h,d
	ld l,$e4
	res 7,(hl)
	ld l,$c4
	ld (hl),$03
	ld l,$c6
	ld (hl),$f0
	call objectSetInvisible
@normalStatus:
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
	ld l,$c9
	ld (hl),$10
	ld l,$d0
	ld (hl),$78
	ld l,$c6
	ld (hl),$09
	ld a,SND_BEAM
	call playSound
	call objectSetVisible83
	
@state1:
	call partCommon_decCounter1IfNonzero
	jr z,@@incState
	ld a,$0b
	call objectGetRelatedObject1Var
	ld bc,$1400
	jp objectTakePositionWithOffset
@@incState:
	ld l,e
	inc (hl)
	
@state2:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	cp $b0
	ret c
	jp partDelete
	
@state3:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(wGameKeysJustPressed)
	or a
	jr z,++
	ld a,(hl)
	sub $0a
	jr nc,+
	ld a,$01
+
	ld (hl),a
++
	ld hl,wccd8
	set 5,(hl)
	ld a,(wFrameCounter)
	rrca
	ret nc
	ld hl,wLinkImmobilized
	set 5,(hl)
	ret
