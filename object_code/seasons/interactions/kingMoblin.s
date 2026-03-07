; ==================================================================================================
; INTERAC_KING_MOBLIN
; ==================================================================================================
interactionCode95:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
@@subid0:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_S_2d
	call setGlobalFlag
@@subid1:
@@subid2:
	call interactionInitGraphics
	ld e,$5d
	ld a,$80
	ld (de),a
	ld e,$42
	ld a,(de)
	or a
	jp nz,objectSetVisible80
	call getThisRoomFlags
	ld b,a
	xor a
	sla b
	adc $00
	sla b
	adc $00
	ld hl,table_55bf
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_MOBLIN
	inc l
	ld (hl),$01
	ld e,$57
	ld a,h
	ld (de),a
+
	call @state1@subid0@func_5517
	ld hl,objectData.objectData7ea0
	call parseGivenObjectData
	call objectSetVisible83
	xor a
	ld ($cfd0),a
	ld ($cfd1),a
	jr @state1
@@subid4:
	ld hl,mainScripts.script73cd
	call interactionSetScript
@@subid3:
	call interactionInitGraphics
	jp interactionAnimateAsNpc
@@subid5:
	ld hl,mainScripts.script73d8
	call interactionSetScript
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld a,$95
	ld (wInteractionIDToLoadExtraGfx),a
	ld a,$05
	ld ($cc1e),a
	call interactionInitGraphics
	call objectSetVisible81
	jr @state1
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
@@subid0:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	ld hl,$cfd0
	ld a,(hl)
	cp $02
	jr nz,@@@func_54ec
	ld h,d
	ld l,$45
	ld (hl),$01
	ld l,$76
	ld (hl),$00
	ld a,$39
	call playSound
	jp interactionAnimateAsNpc
@@@func_54ec:
	inc a
	jp z,interactionDelete
	call interactionRunScript
	call interactionAnimate
	call objectPreventLinkFromPassing
	ld e,$76
	ld a,(de)
	or a
	jr nz,@@@func_550e
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	ld hl,$cfc0
	ld (hl),$01
	ld h,d
	ld l,$76
	inc (hl)
	ret
@@@func_550e:
	ld e,$61
	ld a,(de)
	inc a
	ret z
	ld e,$76
	xor a
	ld (de),a
@@@func_5517:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_97
	ld bc,$0c02
	call objectCopyPositionWithOffset
	ld e,$57
	ld l,e
	ld a,(de)
	ld (hl),a
	ret
@@@substate1:
	ld e,$76
	ld a,(de)
	or a
	jr nz,@@@func_5557
	ld a,$01
	ld (de),a
	ld e,$4b
	ld a,(de)
	sub $20
	ld b,a
	ld e,$4d
	ld a,(de)
	ld c,a
	ld a,$50
	call @@@func_5547
	ld hl,mainScripts.kingMoblinScript_trapLinkInBombedHouse
	jp interactionSetScript
@@@func_5547:
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),$9f
	ld l,$46
	ldh a,(<hFF8B)
	ld (hl),a
	jp objectCopyPositionWithOffset
@@@func_5557:
	call interactionRunScript
	jp c,interactionDelete
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,$77
	ld a,(de)
	or a
	ret nz
	call interactionAnimate
	call interactionAnimate
	jr @@func_557c
@@subid1:
	jp interactionCode96@state1@subid2
@@subid2:
	call interactionAnimate
	ld hl,$cfd0
	ld a,(hl)
	inc a
	ret nz
	jp interactionDelete
@@func_557c:
	ld h,d
	ld l,$61
	ld a,(hl)
	cp $70
	ret nz
	ld (hl),$00
	jp playSound
@@subid4:
	call interactionRunScript
	jp c,interactionDelete
	ld hl,$cfc0
	bit 0,(hl)
	jr z,@@subid3
	ld a,(wFrameCounter)
	and $0f
	jr nz,@@subid3
	ld a,$70
	call playSound
@@subid3:
	jp interactionAnimateAsNpc
@@subid5:
	call interactionRunScript
	jp c,interactionDelete
	ld e,$47
	ld a,(de)
	or a
	jr z,+
	ld a,(wFrameCounter)
	and $0f
	jr nz,+
	ld a,$70
	call playSound
+
	jp interactionAnimate
table_55bf:
	; based on room flags
	.dw mainScripts.script73ab ; bit 6 and 7 both not set
	.dw mainScripts.script73b5 ; 1 of bit 6 and 7 set
	.dw mainScripts.script73bf ; both of bits 6 and 7 set
