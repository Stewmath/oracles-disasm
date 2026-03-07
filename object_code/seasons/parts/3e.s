; ==================================================================================================
; PART_3e
; ==================================================================================================
partCode3e:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $9a
	jr nz,@normalStatus
	ld h,d
	ld l,$c2
	ld (hl),$01
	ld l,$e4
	res 7,(hl)
	ld l,$c6
	ld (hl),$96
	ld l,$c4
	ld a,$03
	ld (hl),a
	call partSetAnimation
@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c3
	ld a,(hl)
	or a
	ld a,$1e
	jr nz,@func_6d87
	ld l,$f0
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ld l,$d0
	ld (hl),$50
	ld l,$ff
	set 5,(hl)
	jp objectSetVisible83
@state1:
	ld h,d
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	sub c
	inc a
	cp $03
	jr nc,+
	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jr c,++
+
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
	jp objectApplySpeed
++
	ld a,$a0
@func_6d87:
	ld l,$c6
	ld (hl),a
	ld l,e
	ld (hl),$03
	ld l,$e4
	set 7,(hl)
	ld a,$ab
	call playSound
	ld a,$01
	call partSetAnimation
	jp objectSetVisible81
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	xor a
	ld (wLinkGrabState2),a
	inc a
	ld (de),a
	jp objectSetVisible81
@substate1:
	call func_6e70
	ret z
	call dropLinkHeldItem
	jp partDelete
@substate2:
	call func_6e37
	jp c,partDelete
	ld e,$cf
	ld a,(de)
	or a
	ret nz
	ld e,$c5
	ld a,$03
	ld (de),a
	ret
@substate3:
	ld b,INTERAC_SNOWDEBRIS
	call objectCreateInteractionWithSubid00
	ret nz
	jp partDelete
@state3:
	call func_6e70
	jp nz,partDelete
	call partCommon_decCounter1IfNonzero
	jr z,+
	ld e,$c2
	ld a,(de)
	or a
	jp nz,seasonsFunc_10_6e6a
	call partAnimate
	jr ++
+
	ld l,$c4
	inc (hl)
	ld a,$02
	jp partSetAnimation
@state4:
	ld e,$e1
	ld a,(de)
	inc a
	jp z,partDelete
	call partAnimate
++
	ld e,$e1
	ld a,(de)
	cp $ff
	ret z
	ld hl,table_6e10
	rst_addAToHl
	ld e,$e6
	ld a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ret
table_6e10:
	.db $02 $04 $06

func_6e13:
	ld e,$c2
	ld a,(de)
	cp $03
	ret nc
	call getFreePartSlot
	ret nz
	ld (hl),PART_3d
	inc l
	ld e,l
	ld a,(de)
	inc a
	ld (hl),a
	ld l,$c9
	ld e,l
	ld a,(de)
	ld (hl),a
	ld l,$d0
	ld (hl),$3c
	ld l,$d4
	ld a,$c0
	ldi (hl),a
	ld (hl),$ff
	jp objectCopyPosition
func_6e37:
	ld a,$00
	call objectGetRelatedObject1Var
	call checkObjectsCollided
	ret nc
	ld l,$82
	ld a,(hl)
	or a
	ret nz
	ld l,$ab
	ld a,(hl)
	or a
	ret nz
	ld (hl),$3c
	ld l,$b2
	ld (hl),$1e
	ld l,$a9
	ld a,(hl)
	sub $06
	ld (hl),a
	jr nc,+
	ld (hl),$00
	ld l,$a4
	res 7,(hl)
+
	ld a,$63
	call playSound
	ld a,$83
	call playSound
	scf
	ret

seasonsFunc_10_6e6a:
	call objectAddToGrabbableObjectBuffer
	jp objectPushLinkAwayOnCollision
func_6e70:
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $77
	ret z
	call objectCreatePuff
	or d
	ret
