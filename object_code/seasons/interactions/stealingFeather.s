; ==================================================================================================
; INTERAC_STEALING_FEATHER
; ==================================================================================================
interactionCode6e:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,TREASURE_FEATHER
	call loseTreasure
	ld bc,$fd80
	call objectSetSpeedZ
	ld l,$50
	ld (hl),$0f
	ld l,$49
	ld (hl),$18
	ld l,$46
	ld (hl),$3c
	call interactionSetAlwaysUpdateBit
	jp objectSetVisiblec0
@@state1:
	call objectApplySpeed
	ld h,d
	ld l,$4d
	ld a,$18
	cp (hl)
	jr c,+
	ld (hl),a
+
	call interactionAnimate
	ld c,$14
	call objectUpdateSpeedZ_paramC
	call interactionDecCounter1
	ret nz
	ld l,$4f
	ld a,(hl)
	ld l,$52
	ld (hl),a
	ld l,$44
	inc (hl)
	ld l,$4d
	ld a,(hl)
	ld ($cfc1),a
	ld hl,$cfc0
	set 2,(hl)
	xor a
	call interactionSetAnimation
@@state2:
	ld hl,$cfc0
	bit 7,(hl)
	jp nz,interactionDelete
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld h,d
	ld l,$46
	inc (hl)
	ld a,(hl)
	and $0f
	ld hl,@@table_6baa
	rst_addAToHl
	ld e,$52
	ld a,(de)
	add (hl)
	ld e,$4f
	ld (de),a
	ret
@@table_6baa:
	.db $00 $00 $ff $ff $ff $fe $fe $fe
	.db $fe $fe $fe $ff $ff $ff $ff $00
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw interactionRunScript
	.dw @@state2
@@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	ld hl,mainScripts.stealingFeatherScript
	jp interactionSetScript
@@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
@@substate0:
	ld a,$01
	ld (de),a
	ld bc,$fe00
	call objectSetSpeedZ
	ld l,$4b
	ld a,($d00b)
	ldi (hl),a
	inc l
	ld a,($d00d)
	ld (hl),a
@@substate1:
	ld a,(wFrameCounter)
	rrca
	call c,@@func_6c19
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $08
	jr nc,+
	ld e,$49
	ld a,$0c
	ld (de),a
+
	ld c,$40
	call objectUpdateSpeedZAndBounce
	jr nc,@@func_6c22
	call @@func_6c22
	ld a,$02
	ld ($cc6b),a
	jp interactionDelete
@@func_6c19:
	ld hl,$d008
	ld a,(hl)
	inc a
	and $03
	ld (hl),a
	ret
@@func_6c22:
	ld hl,$d000
	jp objectCopyPosition
@subid2:
	ld a,GLOBALFLAG_SAW_STRANGE_BROTHERS_IN_HOUSE
	call unsetGlobalFlag
	ld a,GLOBALFLAG_STRANGE_BROTHERS_HIDING_IN_PROGRESS
	call unsetGlobalFlag
	ld a,GLOBALFLAG_JUST_CAUGHT_BY_STRANGE_BROTHERS
	call unsetGlobalFlag
	jp interactionDelete
