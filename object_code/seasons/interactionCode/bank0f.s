 m_section_free Seasons_Interactions_Bank0f NAMESPACE seasonsInteractionsBank0f

; ==============================================================================
;INTERACID_BOOMERANG_SUBROSIAN
; ==============================================================================
interactionCodec8:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,$28
	ld e,$78
	ld (de),a
	call interactionInitGraphics
	call objectGetTileAtPosition
	ld (hl),$00
	ld hl,mainScripts.boomerangSubrosianScript
	call interactionSetScript
	call @func_78cc
@state1:
	call interactionRunScript
	call interactionPushLinkAwayAndUpdateDrawPriority
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	ld h,d
	ld l,$78
	dec (hl)
	ret nz
	call interactionIncSubstate
	ld b,INTERACID_BOOMERANG
	call objectCreateInteractionWithSubid00
	jr nz,+
	ld l,$56
	ld (hl),e
	inc l
	ld (hl),d
+
	ld h,d
	ld l,$77
	ld (hl),$01
@func_78cc:
	ld l,$60
	ld (hl),$01
	jp interactionAnimate
@substate1:
	ld e,$77
	ld a,(de)
	or a
	ret nz
	ld h,d
	ld l,$45
	dec (hl)
	call @func_78cc
	call getRandomNumber_noPreserveVars
	and $3f
	add $3c
	ld e,$78
	ld (de),a
	ret


; ==============================================================================
; INTERACID_BOOMERANG
; ==============================================================================
interactionCodec9:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ldbc $41 $28
	ld l,$50
	ld (hl),b
	ld l,$46
	ld (hl),c
	ld l,$49
	ld (hl),$18
	jp objectSetVisible82
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	call interactionDecCounter1
	jr nz,+
	ld l,$49
	ld (hl),$08
	call interactionIncSubstate
+
	call objectApplySpeed
--
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	ld (hl),$00
	ld a,$78
	call nz,playSound
	jp interactionAnimate
@substate1:
	call objectApplySpeed
	call objectGetRelatedObject1Var
	ld l,$4d
	ld e,l
	ld a,(de)
	add $08
	cp (hl)
	jr c,--
	ld l,$77
	ld (hl),$00
	jp interactionDelete


; ==============================================================================
; INTERACID_TROY
; ==============================================================================
interactionCodeca:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	call func_7aa7
	ld a,>TX_4c00
	call interactionSetHighTextIndex
	ld a,GLOBALFLAG_DONE_CLOCK_SHOP_SECRET
	call checkGlobalFlag
	jr z,+
	ld hl,mainScripts.troyScript_doneSecret
	jr ++
+
	ld a,GLOBALFLAG_BEGAN_CLOCK_SHOP_SECRET
	call checkGlobalFlag
	ld hl,mainScripts.troyScript_beginningSecret
	jr z,++
	ld hl,mainScripts.troyScript_beganSecret
++
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@state1:
	call interactionRunScript
	ld e,$7b
	ld a,(de)
	or a
	ret nz
	jp npcFaceLinkAndAnimate
@state2:
	call func_79df
	call interactionDecCounter1
	jr nz,+
	ld (hl),$b4
	call func_7a0d
+
	ld hl,$ccf8
	ldi a,(hl)
	cp $30
	jr nz,+
	ld a,(hl)
	cp $00
	jr nz,+
	ld a,$01
	jr ++
+
	ld h,d
	ld l,$78
	ld a,(hl)
	cp $0c
	ret nz
	ld a,(wNumEnemies)
	or a
	ret nz
	ld a,$00
++
	ld h,d
	ld l,$7a
	ld (hl),a
	ld l,$44
	ld (hl),$01
	callab scriptHelp.linkedFunc_15_6430
	ld hl,mainScripts.troyScript_gameBegun
	call interactionSetScript
	ret
	ld hl,$ccf7
	xor a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret
func_79df:
	ld hl,$ccf7
	ldi a,(hl)
	cp $59
	jr nz,+
	ldi a,(hl)
	cp $59
	jr nz,+
	ld a,(hl)
	cp $99
	ret z
+
	ld hl,$ccf7
	call func_7a01
	ret nz
	inc hl
	call func_7a01
	ret nz
	inc hl
	ld b,$00
	jr +
func_7a01:
	ld b,$60
+
	ld a,(hl)
	add $01
	daa
	cp b
	jr nz,+
	xor a
+
	ld (hl),a
	ret
func_7a0d:
	ld a,$04
	ld hl,$cc30
	sub (hl)
	ret z
	ldh (<hFF8D),a
	call getRandomNumber
	and $03
	ld e,$79
	ld (de),a
	xor a
--
	inc a
	ldh (<hFF8B),a
	ld h,d
	ld l,$78
	ld a,(hl)
	cp $0c
	jr z,+
	inc a
	ld (hl),a
	ld hl,table_7a3d-1
	rst_addAToHl
	ld a,(hl)
	call func_7a49
	ldh a,(<hFF8B)
	ld hl,$ff8d
	cp (hl)
func_7a3a:
	jr nz,--
+
	ret

table_7a3d:
	; lookup into enemy table below
	.db $00 $00
	.db $00 $00
	.db $01 $01
	.db $02 $03
	.db $04 $05
	.db $06 $07
func_7a49:
	ld bc,table_7a76
	call addDoubleIndexToBc
	call getFreeEnemySlot
	ret nz
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ldi (hl),a
	ld e,$79
	ld a,(de)
	inc a
	and $03
	ld (de),a
	ld bc,table_7a86
	call addDoubleIndexToBc
	ld l,$8b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$8d
	ld a,(bc)
	ld (hl),a
	ld l,$81
	ld a,(hl)
	cp $10
	ret z
	jr func_7a8e
table_7a76:
	.db ENEMYID_ROPE $01
	.db ENEMYID_MASKED_MOBLIN $00
	.db ENEMYID_SWORD_DARKNUT $00
	.db ENEMYID_SWORD_DARKNUT $01
	.db ENEMYID_WIZZROBE $01
	.db ENEMYID_WIZZROBE $02
	.db ENEMYID_LYNEL $00
	.db ENEMYID_LYNEL $01
table_7a86:
	.db $30 $40
	.db $30 $b0
	.db $80 $40
	.db $80 $b0
func_7a8e:
	ld e,$79
	ld a,(de)
	ld bc,table_7a86
	call addDoubleIndexToBc
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,$4b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4d
	ld a,(bc)
	ld (hl),a
	ret
func_7aa7:
	ld a,TREASURE_SWORD
	call checkTreasureObtained
	jr nc,@nobleSword
	cp $03
	jp nc,@nobleSword
	sub $01
-
	ld e,Interaction.var03
	ld (de),a
	ret
@nobleSword:
	ld a,$01
	jr -


; ==============================================================================
; INTERACID_S_LINKED_GAME_GHINI
; ==============================================================================
interactionCodecb:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
@@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld l,$79
	ld (hl),$78
	ld a,>TX_4c00
	call interactionSetHighTextIndex
	ld a,GLOBALFLAG_DONE_GRAVEYARD_SECRET
	call checkGlobalFlag
	jr z,@@notDoneSecret
	ld hl,mainScripts.linkedGhiniScript_doneSecret
	jr @@setScript
@@notDoneSecret:
	ld a,GLOBALFLAG_BEGAN_GRAVEYARD_SECRET
	call checkGlobalFlag
	ld hl,mainScripts.linkedGhiniScript_beginningSecret
	jr z,@@setScript
	ld hl,mainScripts.linkedGhiniScript_begunSecret
@@setScript:
	call interactionSetScript
	jp objectSetVisible81
@@subid1:
@@subid2:
	call interactionInitGraphics
	ld h,d
	ld l,$42
	ld a,(hl)
	ld l,$5c
	ld (hl),a
	ld l,$44
	ld (hl),$02
	ld l,$46
	ld (hl),$1e
	ld l,$4b
	ld a,(hl)
	ld l,$7b
	ld (hl),a
	ld l,$4d
	ld a,(hl)
	ld l,$7c
	ld (hl),a
	call getRandomNumber
	and $02
	dec a
	ld e,$7e
	ld (de),a
	call getRandomNumber
	and $1f
	ld e,$49
	ld (de),a
	call getRandomNumber
	and $03
	ld hl,@@table_7b4d
	rst_addAToHl
	ld a,(hl)
	ld e,$7d
	ld (de),a
	call func_7c3f
	jp objectSetVisible81
@@table_7b4d:
	.db $03 $04 $05 $06

@@subid3:
	call checkIsLinkedGame
	jp z,interactionDelete
	call interactionInitGraphics
	ld h,d
	ld l,$5c
	ld (hl),$02
	ld l,$44
	ld (hl),$03
	ld l,$7e
	ld (hl),GLOBALFLAG_BEGAN_LIBRARY_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	jp interactionAnimateAsNpc

@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
@@substate0:
	call interactionAnimate
	call objectPreventLinkFromPassing
	call interactionRunScript
	ret nc
	call interactionIncSubstate
	jp func_7c0f
@@substate1:
	call func_7bf9
	ret nz
	ld l,$45
	inc (hl)
	ld l,$79
	ld (hl),$3c
	ret
@@substate2:
	call func_7bf9
	ret nz
	ld l,$45
	inc (hl)
	ld hl,mainScripts.linkedGhiniScript_startRound
	call interactionSetScript
@@substate3:
	call interactionAnimate
	call objectPreventLinkFromPassing
	call interactionRunScript
	ret nc
	ld h,d
	ld l,$45
	ld (hl),$01
	ld l,$7f
	ld a,(hl)
	cp $00
	jp z,func_71c5
	jp func_7c0f
@state2:
	call interactionAnimate
	call @func_7be1
	call func_7bf9
	jp z,interactionDelete
	ld l,$46
	ld a,(hl)
	or a
	ret nz
	ld l,$7d
	ld a,(hl)
	ld l,$7b
	ld b,(hl)
	ld l,$7c
	ld c,(hl)
	ld e,$7f
	call objectSetPositionInCircleArc
	jp func_7bfe

@func_7be1:
	ld h,d
	ld l,$46
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ld a,(wFrameCounter)
	rrca
	jp nc,objectSetInvisible
+
	jp objectSetVisible
@state3:
	call interactionRunScript
	jp interactionAnimateAsNpc
func_7bf9:
	ld h,d
	ld l,$79
	dec (hl)
	ret
func_7bfe:
	ld a,(wFrameCounter)
	rrca
	ret nc
	ld h,d
	ld l,$7e
	ld b,(hl)
	ld l,$7f
	ld a,(hl)
	add b
	and $1f
	ld (hl),a
	ret
func_7c0f:
	ld e,$7a
	xor a
	ld (de),a
	jr ++
func_71c5:
	ld e,$7a
	ld a,(de)
	inc a
	cp $03
	jr c,+
	xor a
+
	ld (de),a
++
	call func_7c3f
	call getRandomNumber
	and $01
	ld e,$7c
	ld (de),a
	push de
	call clearEnemies
	call clearItems
	call clearParts
	pop de
	xor a
	ld ($cc30),a
	call func_7c50
	jp func_7cce
func_7c3f:
	ld e,$7a
	ld a,(de)
	ld bc,table_7c4d
	call addAToBc
	ld a,(bc)
	ld e,$79
	ld (de),a
	ret
table_7c4d:
	.db $f0 $b4 $78

func_7c50:
	ld hl,$cee0
	xor a
-
	ldi (hl),a
	inc a
	cp $0d
	jr nz,-
	ld e,$7d
	ld (de),a
	xor a
	ld e,$7b
	ld (de),a
	ret
func_7c62:
	ld e,$7d
	ld a,(de)
	ld b,a
	dec a
	ld (de),a
	call getRandomNumber
-
	sub b
	jr nc,-
	add b
	ld c,a
	ld hl,$cee0
	rst_addAToHl
	ld a,(hl)
	ld e,$7e
	ld (de),a
	push de
	ld d,c
	ld e,b
	dec e
	ld b,h
	ld c,l
-
	ld a,d
	cp e
	jr z,+
	inc bc
	ld a,(bc)
	ldi (hl),a
	inc d
	jr -
+
	pop de
	ret
func_7c8a:
	ld h,d
	ld l,$7a
	ld a,(hl)
	swap a
	ld l,$7b
	add (hl)
	ld bc,table_7c9e
	call addAToBc
	ld a,(bc)
	ld l,$7c
	xor (hl)
	ret
table_7c9e:
	.db $01 $01 $01 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $01 $01 $01 $01 $01 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $01 $01 $01 $01 $01 $01 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00

func_7cce:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_S_LINKED_GAME_GHINI
	inc hl
	push hl
	call func_7c8a
	pop hl
	inc a
	ld (hl),a
	ld e,$7a
	ld a,(de)
	ld l,$7a
	ld (hl),a
	push hl
	call func_7c62
	pop hl
	ld e,$7e
	ld a,(de)
	ld bc,table_7d03
	call addDoubleIndexToBc
	ld l,$4b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4d
	ld a,(bc)
	ld (hl),a
	ld e,$7b
	ld a,(de)
	inc a
	ld (de),a
	cp $0d
	jr nz,func_7cce
	ret
table_7d03:
	.db $1c $20 $1c $40 $1c $60 $1c $80
	.db $34 $30 $34 $50 $34 $70 $4c $20
	.db $4c $40 $4c $60 $4c $80 $64 $30
	.db $64 $70


; ==============================================================================
; INTERACID_GOLDEN_CAVE_SUBROSIAN
; ==============================================================================
interactionCodecc:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,$01
	ld (de),a
	ld a,>TX_4c00
	call interactionSetHighTextIndex
	call getThisRoomFlags
	and $03
	or a
	jr z,+
	ld hl,seasonsTable_0f_7dc7
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jr @setScript
+
	ld a,GLOBALFLAG_DONE_SUBROSIAN_SECRET
	call checkGlobalFlag
	jr z,@notDoneSubrosianScript
	ld hl,mainScripts.script7dac
	jr @setScript
@notDoneSubrosianScript:
	call getThisRoomFlags
	bit 7,a
	jr z,@notGivenSecret
	ld hl,mainScripts.goldenCaveSubrosianScript_givenSecret
	jr @setScript
@notGivenSecret:
	ld hl,mainScripts.goldenCaveSubrosianScript_beginningSecret
@setScript:
	call interactionSetScript
	call interactionInitGraphics
	call seasonsFunc_0f_7dc1
	call interactionSetAlwaysUpdateBit
@state1:
	call interactionAnimateAsNpc
	call interactionRunScript
	call seasonsFunc_0f_7dac
	call checkInteractionSubstate
	ret nz
	call func_7d95
	ld a,TILEINDEX_GRASS
	call findTileInRoom
	ret z
	call interactionIncSubstate
	ld l,$78
	ld a,(hl)
	ld b,$02
	cp $04
	jr nc,+
	ld b,$03
+
	ld l,$79
	ld (hl),b
	ret
func_7d95:
	ld c,TREASURE_BOOMERANG
	call findItemWithID
	ld h,d
	jr z,@failed
	ld l,$77
	ld (hl),$00
	ret
@failed:
	ld l,$77
	ld a,(hl)
	or a
	ret nz
	ld (hl),$01
	inc l
	inc (hl)
	ret

seasonsFunc_0f_7dac:
	call getThisRoomFlags
	and $03
	or a
	and $01
	ret z
	ld e,$79
	ld a,(de)
	cp $03
	ret nz
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

seasonsFunc_0f_7dc1:
	ld bc,$ff40
	jp objectSetSpeedZ

seasonsTable_0f_7dc7:
	.dw mainScripts.goldenCaveSubrosianScript_beginningSecret
	.dw mainScripts.goldenCaveSubrosianScript_7d00
	.dw mainScripts.goldenCaveSubrosianScript_7d87
	.dw mainScripts.goldenCaveSubrosianScript_7d00


; ==============================================================================
; INTERACID_LINKED_MASTER_DIVER
; ==============================================================================
interactionCodecd:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld a,$4c
	call interactionSetHighTextIndex
	ld a,GLOBALFLAG_DONE_DIVER_SECRET
	call checkGlobalFlag
	jp z,@notDoneDiverSecret
	ld hl,mainScripts.masterDiverScript_secretDone
	jr @setScript
@notDoneDiverSecret:
	ld a,$07
	ld b,$ea
	call getRoomFlags
	and $40
	jr z,+
	res 6,(hl)
	ld hl,mainScripts.masterDiverScript_swimmingChallengeDone
	jr @setScript
+
	ld a,GLOBALFLAG_BEGAN_DIVER_SECRET
	call checkGlobalFlag
	ld hl,mainScripts.masterDiverScript_beginningSecret
	jr z,@setScript
	ld hl,mainScripts.masterDiverScript_begunSecret
@setScript:
	call interactionSetScript
	xor a
	ld hl,$cfd0
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld a,$02
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@subid1:
	ld hl,$cfd1
	ld a,(hl)
	or a
	jp nz,interactionDelete
	inc (hl)
	ld h,d
	ld l,$44
	ld (hl),$02
	ld a,GLOBALFLAG_SWIMMING_CHALLENGE_SUCCEEDED
	call unsetGlobalFlag
	ld a,>TX_4c00
	call interactionSetHighTextIndex
	ld hl,mainScripts.masterDiverScript_swimmingChallengeText
	call interactionSetScript
	call objectSetReservedBit1
	jr @state2
@subid2:
	ld h,d
	ld l,$44
	ld (hl),$02
	ld a,>TX_4c00
	call interactionSetHighTextIndex
	ld hl,mainScripts.masterDiverScript_spawnFakeStarOre
	call interactionSetScript
	jr @state2
@state1:
	call interactionRunScript
	ld e,$7f
	ld a,(de)
	or a
	ret nz
	jp interactionAnimateAsNpc
@state2:
	ld e,$42
	ld a,(de)
	dec a
	jr nz,+
	; Inside waterfall cave
	callab func_79df
+
	call interactionRunScript
	jp c,interactionDelete
	ret


; ==============================================================================
; INTERACID_S_GREAT_FAIRY
; ==============================================================================
interactionCoded5:
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
	or a
	jr z,@subid0
	call checkIsLinkedGame
	jp z,interactionDelete
	jr @subid1
@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
@subid1:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld h,d
	ld l,e
	inc (hl)
	ld l,$4f
	ld (hl),$f0
	ld l,$77
	ld (hl),$36
	ld a,>TX_4100
	call interactionSetHighTextIndex
	xor a
	ld (wActiveMusic),a
	ld a,$0f
	call playSound
	jp objectCreatePuff
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	ld h,d
	ld l,$77
	dec (hl)
	ret nz
	ld l,$45
	inc (hl)
	xor a
	call interactionSetAnimation
	call objectSetVisiblec2
	ld e,Interaction.var3e
	ld a,GLOBALFLAG_BEGAN_TINGLE_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld (de),a
	ld e,$42
	ld a,(de)
	or a
	ld hl,mainScripts.linkedGameNpcScript
	jr nz,@setScript

	ld a,GLOBALFLAG_DONE_TEMPLE_SECRET
	call checkGlobalFlag
	ld hl,mainScripts.templeGreatFairyScript_beginningSecret
	jr z,@setScript

	ld hl,mainScripts.templeGreatFairyScript_doneSecret
@setScript:
	jp interactionSetScript
@substate1:
	call interactionRunScript
	call interactionAnimateAsNpc
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,table_7f1f
	rst_addAToHl
	ld e,$4f
	ld a,(de)
	add (hl)
	ld (de),a
	ret
table_7f1f:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00


; ==============================================================================
; INTERACID_DEKU_SCRUB
; ==============================================================================
interactionCoded6:
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
	ld hl,@table_7f74
	rst_addAToHl
	ld a,(wAnimalCompanion)
	cp (hl)
	jp nz,interactionDelete
	ld a,$86
	call loadPaletteHeader
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld a,>TX_4c00
	call interactionSetHighTextIndex

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld hl,mainScripts.dekuScrubScript_notFinishedGame
	jr z,@setScript

	ld a,GLOBALFLAG_DONE_DEKU_SECRET
	call checkGlobalFlag
	ld hl,mainScripts.dekuScrubScript_doneSecret
	jr nz,@setScript

	call getThisRoomFlags
	bit 7,a
	ld hl,mainScripts.dekuScrubScript_gaveSecret
	jr nz,@setScript

	ld hl,mainScripts.dekuScrubScript_beginningSecret
@setScript:
	jp interactionSetScript
@table_7f74:
	.db SPECIALOBJECTID_RICKY
	.db SPECIALOBJECTID_DIMITRI
	.db SPECIALOBJECTID_MOOSH
@state1:
	call interactionRunScript
	call interactionAnimateAsNpc
	ld c,$20
	call objectCheckLinkWithinDistance
	ld h,d
	ld l,$77
	jr c,+
	ld a,(hl)
	or a
	ret z
	xor a
	ld (hl),a
	ld a,$03
	jp interactionSetAnimation
+
	ld a,(hl)
	or a
	ret nz
	inc (hl)
	ld a,$01
	jp interactionSetAnimation

interactionCoded7:
	jp interactionDelete

.ends
