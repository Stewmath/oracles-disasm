; ==================================================================================================
; INTERAC_MAKU_SEED_AND_ESSENCES
; ==================================================================================================
interactionCodede:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1To8
	.dw @subid1To8
	.dw @subid1To8
	.dw @subid1To8
	.dw @subid1To8
	.dw @subid1To8
	.dw @subid1To8
	.dw @subid1To8
@subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,($d00b)
	sub $0e
	ld e,$4b
	ld (de),a
	ld a,($d00d)
	ld e,$4d
	ld (de),a
	call setLinkForceStateToState08
	ld a,$f1
	call playSound
	ld a,$77
	call playSound
	ld b,INTERAC_SPARKLE
	call objectCreateInteractionWithSubid00
	ret nz
	ld l,$46
	ld e,l
	ld a,$78
	ld (hl),a
	ld (de),a
	jp objectSetVisible82
@@state1:
	ld a,$0f
	ld ($cc6b),a
	call interactionDecCounter1
	ret nz
	ld (hl),$40
	ld l,$50
	ld (hl),$14
	jp interactionIncState
@@state2:
	call objectApplySpeed
	call func_6c94
	call interactionDecCounter1
	ret nz
	ld (hl),$78
	ld a,$10
	ld ($cc6b),a
	ld l,$4b
	ld (hl),$28
	ld l,$4d
	ld (hl),$50
	ld a,$8a
	call playSound
	ld a,$03
	call fadeinFromWhiteWithDelay
	jp interactionIncState
@@state3:
	call func_6c94
	call func_6ccb
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
@@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$14
	inc l
	ld (hl),$08
	jp interactionIncSubstate
@@substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$14
	inc l
	dec (hl)
	ld b,(hl)
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MAKU_SEED_AND_ESSENCES
	call objectCopyPosition
	ld a,b
	ld bc,@@table_6bc3
	call addDoubleIndexToBc
	ld a,(bc)
	ld l,$42
	ld (hl),a
	ld l,$49
	inc bc
	ld a,(bc)
	ld (hl),a
	ld e,$47
	ld a,(de)
	or a
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$78
	ret
@@table_6bc3:
	; subid - angle
	.db $08 $1a
	.db $07 $16
	.db $06 $12
	.db $05 $0e
	.db $04 $0a
	.db $03 $06
	.db $02 $02
	.db $01 $1e
@@substate2:
	call interactionDecCounter1
	ret nz
	ld (hl),$3c
	ld a,$01
	ld ($cfc0),a
	ld a,$20
	ld ($cfc1),a
	jp interactionIncSubstate
@@substate3:
@@substate5:
@@substate7:
	ld a,(wFrameCounter)
	and $03
	jr nz,@@incSubstateAtInterval
	ld hl,$cfc1
	dec (hl)
	jr @@incSubstateAtInterval
@@substate4:
@@substate6:
	ld a,(wFrameCounter)
	and $03
	jr nz,@@incSubstateAtInterval
	ld hl,$cfc1
	inc (hl)
@@incSubstateAtInterval:
	call interactionDecCounter1
	ret nz
	ld (hl),$3c
	jp interactionIncSubstate
@@substate8:
	ld hl,$cfc1
	inc (hl)
	ld a,$b4
	call playSound
	ld a,$04
	call fadeoutToWhiteWithDelay
	jp interactionIncSubstate
@@substate9:
	ld hl,$cfc1
	inc (hl)
	ld a,($c4ab)
	or a
	ret nz
	ld hl,$cbb3
	inc (hl)
	ld a,$08
	call fadeinFromWhiteWithDelay
	jp interactionDelete
@subid1To8:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
@@state0:
	ld a,$01
	ld (de),a
	ld h,d
	ld l,$46
	ld (hl),$10
	ld l,$50
	ld (hl),$50
	ld a,$98
	call playSound
	call objectCenterOnTile
	ld l,$4d
	ld a,(hl)
	sub $08
	ldi (hl),a
	xor a
	ldi (hl),a
	ld (hl),a
	call interactionInitGraphics
	jp objectSetVisible80
@@state1:
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	jp interactionIncState
@@state2:
	ld a,($cfc0)
	or a
	ret z
	jp interactionIncState
@@state3:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	ld a,(wFrameCounter)
	rrca
	ret c
	ld h,d
	ld l,$49
	inc (hl)
	ld a,(hl)
	and $1f
	ld (hl),a
	ld e,l
	or a
	call z,func_6c8f
	ld bc,$2850
	ld a,($cfc1)
	jp objectSetPositionInCircleArc
func_6c8f:
	ld a,SND_CIRCLING
	jp playSound
func_6c94:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ldbc INTERAC_SPARKLE $03
	call objectCreateInteraction
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld bc,table_6cbb
	call addDoubleIndexToBc
	ld l,$4b
	ld a,(bc)
	add (hl)
	ld (hl),a
	inc bc
	ld l,$4d
	ld a,(bc)
	add (hl)
	ld (hl),a
	ret
table_6cbb:
	.db $10 $02
	.db $10 $fe
	.db $08 $05
	.db $08 $fb
	.db $0c $08
	.db $0c $f8
	.db $06 $0b
	.db $06 $f5
func_6ccb:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,table_6ce2
	rst_addAToHl
	ld e,$4f
	ld a,(hl)
	ld (de),a
	ret
table_6ce2:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00
