; ==============================================================================
; INTERACID_MAKU_TREE
; TODO: finish
; Variables:
;   ws_cc39: Maku tree stage
;   wc6e5: ???
;   ws_c6e0: ???
; ==============================================================================
interactionCode87:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	call interactionInitGraphics
	call objectSetVisible83
	call interactionSetAlwaysUpdateBit
	call makuTree_setAppropriateStage
	call makuTree_spawnGnarledKey
	ld hl,mainScripts.script710b
	call interactionSetScript
	ld a,($cc39)
	or a
	jr nz,+
	ld a,$01
	jr ++
+
	ld a,$02
++
	ld e,Interaction.state
	ld (de),a
	call interactionRunScript
	call interactionRunScript
	jp interactionRunScript

@subid1:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
	ld hl,mainScripts.script7255
	call interactionSetScript
	jp interactionRunScript

@subid2:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
	call interactionSetAlwaysUpdateBit
	ld hl,mainScripts.script7261
	call interactionSetScript
	jp interactionRunScript

@state1:
	call makuTree_setRoomFlag40OnGnarledKeyGet

@state2:
	call interactionRunScript

@state3:
	jp interactionAnimate


; This label in used directly from bank 0.
makuTree_setAppropriateStage:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,@setStageToLast
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,+
	xor a
+
	; dungeon 1,2,3,5?
	cp $17
	jr z,@highestEssenceIs5Except4
	; dungeon 1 to 5?
	cp $1f
	jr z,@highestEssenceIs5
	call getHighestSetBit
	jr nc,+
	inc a
+
	; 0 if no essences, 1-8 based on highest essence, otherwise
	call @setStage
	cp $01
	jr z,@highestEssenceIs1
	cp $08
	jr z,@highestEssenceIs8
	ret
	
@highestEssenceIs1:
	; highest essence is 1st essence
	ld a,>ROOM_SEASONS_12a
	ld b,<ROOM_SEASONS_12a
	call getRoomFlags
	and $40
	ret z
	ld a,$09
	jr @setStage
	
@highestEssenceIs5Except4:
	ld a,GLOBALFLAG_MET_MAKU_WITH_FIRST_5_ESSENCES_EXCEPT_4TH
	call setGlobalFlag
	ld a,$0a
	jr @setStage
	
@highestEssenceIs5:
	ld a,GLOBALFLAG_MET_MAKU_WITH_FIRST_5_ESSENCES_EXCEPT_4TH
	call checkGlobalFlag
	jr nz,+
	ld a,$05
	jr @setStage
+
	ld a,$0b
	jr @setStage
	
@highestEssenceIs8:
	ld a,(wc6e5)
	cp $09
	jr z,@all8Essences
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	call checkGlobalFlag
	ret z
	ld a,$0c
	jr @setStage

@all8Essences:
	ld a,$0d
	jr @setStage

@setStageToLast:
	ld a,$0e
@setStage:
	ld ($cc39),a
	ret

makuTree_setRoomFlag40OnGnarledKeyGet:
	call getThisRoomFlags
	and $40
	ret nz
	ld a,TREASURE_GNARLED_KEY
	call checkTreasureObtained
	ret nc
	set 6,(hl)
	ret

makuTree_spawnGnarledKey:
	call getThisRoomFlags
	bit 6,a
	ret nz
	; not yet gotten gnarled key
	bit 7,a
	ret z
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_GNARLED_KEY
	inc l
	ld (hl),$01
	ld l,Interaction.yh
	ld a,$58
	ldi (hl),a
	ld a,(ws_c6e0)
	ld l,Interaction.xh
	ld (hl),a
	ret


; INTERACID_88
; clouds above Onox castle?
interactionCode88:
	call checkInteractionState
	jr nz,@nonZeroState
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld (de),a
	ld e,$40
	ld a,(de)
	or $80
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible82
	call objectSetInvisible
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,+
	ld a,(wGfxRegs1.SCY)
	cpl
	inc a
+
	add $28
	ld l,$4b
	ld (hl),a
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
	call interactionIncSubstate
	ld hl,seasonsTable_09_7f33
	jp seasonsFunc_09_7f01
+
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call checkGlobalFlag
	jp nz,interactionDelete
	ld e,$46
	ld a,$3c
	ld (de),a
	ret
@nonZeroState:
	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	jr nz,+
	ld a,(wPaletteThread_mode)
	or a
	jp nz,interactionDelete
+
	call checkInteractionSubstate
	jr nz,+
	call interactionDecCounter1
	ret nz
	ld l,$46
	ld (hl),$3c
	call getRandomNumber_noPreserveVars
	and $01
	ret z
	call interactionIncSubstate
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,seasonsTable_09_7f2b
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp seasonsFunc_09_7f01
+
	ld e,$70
	ld a,(de)
	or a
	jr nz,seasonsFunc_09_7ee2
	ld a,$01
	ld (de),a
	ld e,$47
	ld a,(de)
	ld hl,seasonsTable_09_7f28
	rst_addAToHl
	ld a,(hl)
	call loadPaletteHeader
	ld a,$ff
	ld ($cd29),a
	ld a,(de)
	or a
	ld a,$d2
	call nz,playSound
	ld a,(de)
	cp $02
	jr z,+
	call objectSetInvisible
	jr seasonsFunc_09_7ee2
+
	call getRandomNumber
	and $01
	ld b,a
	ld a,$13
	jr z,+
	ld a,$8d
+
	ld e,$4d
	ld (de),a
	ld a,b
	call interactionSetAnimation
	call objectSetVisible

seasonsFunc_09_7ee2:
	ld e,$47
	ld a,(de)
	cp $02
	jr nz,+
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	jr nz,+
	call objectSetInvisible
+
	call interactionDecCounter1
	ret nz
	ld h,d
	ld l,$58
	ldi a,(hl)
	ld l,(hl)
	ld h,a
	inc hl
	inc hl

seasonsFunc_09_7f01:
	ld e,Interaction.relatedObj2
	ld a,h
	ld (de),a
	inc e
	ld a,l
	ld (de),a
	ldi a,(hl)
	inc a
	jr z,seasonsFunc_09_7f17
	ld e,$46
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld e,$70
	xor a
	ld (de),a
	ret

seasonsFunc_09_7f17:
	ld h,d
	ld l,$42
	ld a,(hl)
	or a
	jp z,interactionDelete
	ld l,$45
	ld (hl),$00
	ld l,$46
	ld (hl),$3c
	ret

seasonsTable_09_7f28:
	.db PALH_TILESET_ONOX_CASTLE_OUTSIDE_WINTER
	.db PALH_SEASONS_99
	.db PALH_SEASONS_9a

seasonsTable_09_7f2b:
	.dw seasonsTable_09_7f33
	.dw seasonsTable_09_7f33
	.dw seasonsTable_09_7f33
	.dw seasonsTable_09_7f33

seasonsTable_09_7f33:
	.db $3c $00
	.db $02 $01
	.db $04 $00
	.db $02 $02
	.db $78 $00
	.db $02 $01
	.db $02 $00
	.db $02 $01
	.db $02 $00
	.db $03 $01
	.db $01 $00
	.db $0c $02
	.db $3c $00
	.db $ff