; ==================================================================================================
; INTERAC_IMPA
; ==================================================================================================
interactionCode9d:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call interactionInitGraphics
	call objectSetVisible82
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
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jp c,interactionDelete
	call getThisRoomFlags
	and $40
	jr nz,@@func_5d73
	ld a,$1f
	call playSound
	ld a,($cc62)
	ld (wActiveMusic),a
	jr ++
@@func_5d73:
	ld h,d
	ld l,$4b
	ld (hl),$28
	inc l
	inc l
	ld (hl),$18
	ld l,$42
	ld (hl),$01
++
	ld hl,mainScripts.impaScript_afterOnoxTakesDin
	jr @@setScript
@@subid1:
	call checkZeldaVillagersSeenButNoMakuSeed
	jp nz,interactionDelete
	call checkGotMakuSeedDidNotSeeZeldaKidnapped_body
	jp nz,interactionDelete
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jr z,+
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp z,interactionDelete
+
	call checkIsLinkedGame
	jr z,@@func_5db1
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jp z,@@func_5db1
	ld a,$0c
	jr @@func_5dd5
@@func_5db1:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	call getHighestSetBit
	jr @@func_5dd5
@@subid2:
	call checkZeldaVillagersSeenButNoMakuSeed
	jp z,interactionDelete
	ld a,$03
	ld e,$7b
	ld (de),a
	call interactionSetAnimation
	ld a,$08
	jr @@func_5dd5
@@subid3:
	call checkGotMakuSeedDidNotSeeZeldaKidnapped_body
	jp z,interactionDelete
	ld a,$09
@@func_5dd5:
	ld hl,table_5ec8
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
@@setScript:
	jp interactionSetScript
@@subid4:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jp nc,interactionDelete
	and $02
	jp z,interactionDelete
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jp nz,interactionDelete
	ld bc,$ff00
	call objectSetSpeedZ
	ld hl,simulatedInput_5ec3
	ld a,:simulatedInput_5ec3
	push de
	call setSimulatedInputAddress
	pop de
	ld hl,w1Link.yh
	ld (hl),$76
	inc l
	inc l
	ld (hl),$56
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_BIRD
	inc l
	ld (hl),$0a
	ld l,$56
	ld (hl),$40
	inc l
	ld (hl),d
	call objectCopyPosition
++
	call objectSetInvisible
	call interactionSetAlwaysUpdateBit
	ld a,$0a
	ld ($cc02),a
	jr @@func_5dd5
@@subid5:
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,$0b
	jr @@func_5dd5
@state1:
	call interactionRunScript
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@faceLinkAndAnimate
	.dw @@animateAsNPC
	.dw @@subid3
	.dw @@subid4
	.dw @@faceLinkAndAnimate
@@subid0:
	call checkInteractionSubstate
	jr nz,++
	inc a
	ld (de),a
	ld a,$08
	call setLinkIDOverride
	ld l,$02
	ld (hl),$02
	ld l,$0b
	ld (hl),$48
	ld l,$0d
	ld (hl),$58
	ld l,$08
	ld (hl),$00
++
	call getThisRoomFlags
	and $40
	jr z,+
	ld e,$42
	ld a,$01
	ld (de),a
+
	call interactionAnimate
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
@@faceLinkAndAnimate:
	jp npcFaceLinkAndAnimate
@@subid3:
	ld a,GLOBALFLAG_TALKED_TO_ZELDA_BEFORE_ONOX_FIGHT
	call checkGlobalFlag
	jp nz,npcFaceLinkAndAnimate
@@animateAsNPC:
	jp interactionAnimateAsNpc
@@subid4:
	call checkInteractionSubstate
	jr nz,func_5eb1
	ld a,($cbc3)
	rlca
	ret nc
	xor a
	ld ($cbc3),a
	inc a
	ld (wDisabledObjects),a
	call interactionIncSubstate
	jp objectSetVisible
func_5eb1:
	ld a,($cba0)
	or a
	call nz,seasonsFunc_0a_6710
	call interactionAnimateAsNpc
	ld e,$47
	ld a,(de)
	or a
	jp nz,interactionAnimate
	ret
simulatedInput_5ec3:
	dwb 32 BTN_UP
	.dw $ffff
table_5ec8:
	; for subid1, if Zelda Kidnapped not seen,
	; the rest are indexed by highest essence count
	.dw mainScripts.impaScript_after1stEssence
	.dw mainScripts.impaScript_after2ndEssence
	.dw mainScripts.impaScript_after3rdEssence
	.dw mainScripts.impaScript_after4thEssence
	.dw mainScripts.impaScript_after5thEssence
	.dw mainScripts.impaScript_after6thEssence
	.dw mainScripts.impaScript_after7thEssence
	.dw mainScripts.impaScript_after8thEssence
	.dw mainScripts.impaScript_villagersSeenButNoMakuSeed ; mainScripts.subid2
	.dw mainScripts.impaScript_gotMakuSeedDidntSeeZeldaKidnapped ; mainScripts.subid3
	.dw mainScripts.impaScript_askingToSaveZelda; mainScripts.subid4
	.dw mainScripts.impaScript_askedToSaveZeldaButHavent ; mainScripts.subid5
	.dw mainScripts.impaScript_afterZeldaKidnapped ; subid1 - zelda kidnapped mainScripts.seen
