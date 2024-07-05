; ==================================================================================================
; INTERAC_MAKU_TREE
; TODO: finish
; Variables:
;   ws_cc39: Maku tree stage
;   wc6e5: ???
;   ws_c6e0: ???
; ==================================================================================================
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
	ld (hl),INTERAC_TREASURE
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
