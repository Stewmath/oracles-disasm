 m_section_free Seasons_Interactions_Bank15 NAMESPACE seasonsInteractionsBank15

; ==============================================================================
; INTERACID_LINKED_FOUNTAIN_LADY
; ==============================================================================
interactionCoded8:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_GNARLED_KEY_GIVEN
	call checkGlobalFlag
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld l,$7e
	ld (hl),GLOBALFLAG_BEGAN_FAIRY_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc


; ==============================================================================
; INTERACID_LINKED_SECRET_GIVERS
; ==============================================================================
interactionCodedb:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call checkIsLinkedGame
	jp z,interactionDelete

	call @func_662f
	jp z,interactionDelete
	ld e,$42
	ld a,(de)
	ld hl,@table_662c
	rst_addAToHl
	ld a,(hl)
	ld e,$7e
	ld (de),a
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionInitGraphics
	jp objectSetVisiblec2
@table_662c:
	.db GLOBALFLAG_BEGAN_TOKAY_SECRET - GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	.db GLOBALFLAG_BEGAN_MAMAMU_SECRET - GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	.db GLOBALFLAG_BEGAN_SYMMETRY_SECRET - GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
@func_662f:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld a,GLOBALFLAG_S_2d
	call checkGlobalFlag
	ret
@subid1:
	ld a,>ROOM_SEASONS_081
	ld b,<ROOM_SEASONS_081
	call getRoomFlags
	bit 7,a
	ret
@subid2:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,+
	call getHighestSetBit
	cp $01
	jr c,+
	or $01
	ret
+
	xor a
	ret
@state1:
	call interactionRunScript
	ld e,$42
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc


; ==============================================================================
; INTERACID_S_MISC_PUZZLES
; ==============================================================================
interactionCodedc:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw interactionCodedc_subid0
	.dw interactionCodedc_subid1
	.dw interactionCodedc_subid2
	.dw interactionCodedc_subid3
	.dw interactionCodedc_subid4
	.dw interactionCodedc_subid5
	.dw interactionCodedc_subid6
	.dw interactionCodedc_subid7
	.dw interactionCodedc_subid8
	.dw interactionCodedc_subid9
	.dw interactionCodedc_subidA
	.dw interactionCodedc_subidB
	.dw interactionCodedc_subidC
	.dw interactionCodedc_subidD
	.dw interactionCodedc_subidE
	.dw interactionCodedc_subidF

interactionCodedc_subidF:
	call interactionDeleteAndRetIfEnabled02
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ld e,$4d
	ld a,(de)
	ld b,a
	ld a,(wActiveTriggers)
	cp b
	jr nz,@func_66b9
	ld e,$4b
	ld a,(de)
	ld c,a
	ld b,$cf
	ld a,(bc)
	cp TILEINDEX_CHEST
	ret z
	ld a,TILEINDEX_CHEST
	call setTile
	call @func_66d2
	ld a,$4d
	jp playSound
@func_66b9:
	ld e,$4b
	ld a,(de)
	ld c,a
	ld b,$cf
	ld a,(bc)
	cp $f1
	ret nz
	ld a,$03
	ld ($ff00+$70),a
	ld b,$df
	ld a,(bc)
	ld l,a
	xor a
	ld ($ff00+$70),a
	ld a,l
	call setTile
@func_66d2:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,$4b
	jp setShortPosition_paramC

interactionCodedc_subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw interactionIncState
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,(wActiveTriggers)
	or a
	ret z
	ld a,$01
	ld e,$46
	ld (de),a
	jp interactionIncState
@state1:
	call interactionDecCounter1
	ret nz
	ld l,$45
	ld a,(hl)
	cp $03
	jr z,+
	inc (hl)
	ld hl,table_675a
	rst_addAToHl
	ld a,(hl)
	ld b,$6d
	jr func_6744
+
	call interactionIncState
	ld l,$46
	ld (hl),$43
@state2:
	call interactionDecCounter1
	ret nz
	ld (hl),$01
	jp interactionIncState
@state3:
	call interactionDecCounter1
	ret nz
	ld l,$45
	ld a,(hl)
	or a
	jp z,interactionIncState
	dec (hl)
	ld a,(hl)
	ld hl,table_675a
	rst_addAToHl
	ld a,(hl)
	ld b,$fd
	call func_6744
	ld (hl),$1e
	ret
@state4:
	ld a,(wActiveTriggers)
	or a
	ret nz
	ld a,$01
	ld e,$44
	ld (de),a
	ret
func_6744:
	ld c,a
	ld a,b
	call setTile
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,$4b
	call setShortPosition_paramC
	ld h,d
	ld l,$46
	ld (hl),$0f
	ret
table_675a:
	.db $65 $64 $63

interactionCodedc_subid1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call checkIsLinkedGame
	jp z,interactionDelete
	ld (wDisableWarpTiles),a
	ret
@state1:
	call returnIfScrollMode01Unset
	ld a,(wActiveTilePos)
	ld b,a
	ld a,(wEnteredWarpPosition)
	cp b
	ret z
	jp interactionIncState
@state2:
	call objectGetTileAtPosition
	ld b,a
	ld a,(wActiveTileIndex)
	cp b
	ret nz
	call checkLinkID0AndControlNormal
	ret nc
	ld hl,wWarpDestGroup
	ld (hl),$85
	inc l
	ld (hl),$30
	inc l
	ld (hl),$93
	inc l
	ld (hl),$ff
	ld a,$01
	ld (wWarpTransition2),a
	jp interactionDelete

interactionCodedc_subid2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw interactionCodedc_subid1@state0
	.dw @state1
@state1:
	ld a,$01
	ld (wDisableWarpTiles),a
	call objectGetTileAtPosition
	ld b,a
	ld a,(wActiveTileIndex)
	cp b
	ret nz
	ld a,(wLinkInAir)
	or a
	ret nz
	call getLinkedHerosCaveSideEntranceRoom
	ld a,$05
	ld (wWarpDestGroup),a
	ld a,$09
	ld (wWarpTransition),a
	ld a,$00
	ld (wScrollMode),a
	ld a,LINK_STATE_WARPING
	ld (wLinkForceState),a
	jp interactionDelete

interactionCodedc_subid3:
	ld h,d
	ld l,$4b
	ld a,(wActiveTriggers)
	and (hl)
	cp (hl)
	ld hl,wActiveTriggers
	jr nz,+
	set 7,(hl)
	ret
+
	ld hl,wActiveTriggers
	res 7,(hl)
	ret

interactionCodedc_subid4:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld e,$4d
	ld a,(de)
	ld e,$70
	ld (de),a
	ld b,a
	call getThisRoomFlags
	and $20
	jr z,+
	call @func_681b
	jp interactionDelete
+
	ld e,$4b
	ld a,(de)
	ld c,a
	call objectSetShortPosition
	jp interactionIncState
@func_681b:
	ld e,$70
	ld a,(de)
	ld hl,wc64a
	cp (hl)
	ret c
	ld (hl),a
	ret
@state1:
	call getThisRoomFlags
	and $20
	ret z
	call @func_681b
	call interactionIncState
	ld l,$46
	ld (hl),$28
@state2:
	call retIfTextIsActive
	call interactionDecCounter1
	ret nz
	ld (hl),$1e
	call objectCreatePuff
	jp interactionIncState
@state3:
	call interactionDecCounter1
	ret nz
	ld a,$4d
	call playSound
	ldbc INTERACID_MINIBOSS_PORTAL $02
	call objectCreateInteraction
	ret nz
	jp interactionDelete

interactionCodedc_subid5:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01
	ld (de),a
@state1:
	ld a,(wActiveTriggers)
	cp $1f
	ret nz
	ld h,d
	ld a,$0f
	ld l,$46
	ld (hl),$0f
	inc l
	ld (hl),$73
	jp interactionIncState
@state2:
	call interactionDecCounter1
	ret nz
	inc l
	ld a,(hl)
	ld b,$6d
	call func_6744
	ld a,c
	cp $7d
	jp z,interactionIncState
	ld l,$47
	inc (hl)
	ret
@state3:
	ld a,(wActiveTriggers)
	cp $1f
	ret z
	jp interactionIncState
@state4:
	call interactionDecCounter1
	ret nz
	inc l
	ld a,(hl)
	ld b,$f4
	call func_6744
	ld a,c
	cp $73
	jr z,+
	ld l,$47
	dec (hl)
	ret
+
	ld h,d
	ld l,$44
	ld (hl),$01
	ret

interactionCodedc_subid6:
	ld e,$44
	ld a,(de)
	or a
	jr nz,+
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	call interactionIncState
+
	ld a,($cc31)
	bit 6,a
	ret z
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_SMALL_KEY
	inc l
	ld (hl),$01
	call objectCopyPosition
	jp interactionDelete

interactionCodedc_subid7:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01
	ld (de),a
@state1:
	ld e,$70
	ld a,(de)
	ld b,a
	ld a,(wActiveTriggers)
	cp b
	ret z
	ld (de),a
	ld (wccb1),a
	ld c,a
	ld a,b
	cpl
	and c
	call getHighestSetBit
	ld h,d
	ld l,$71
	ld (hl),a
	jp interactionIncState
@state2:
	ld b,$04
-
	call @func_6923
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,$4b
	call setShortPosition_paramC
	dec b
	jr nz,-
	call interactionIncState
	ld l,$46
	ld (hl),$1e
	ret
@func_6923:
	ld a,b
	dec a
	ld hl,@table_692b
	rst_addAToHl
	ld c,(hl)
	ret
@table_692b:
	.db $22 $2c $82 $8c
@func_692f:
	ld e,$71
	ld a,(de)
	ld hl,@table_693a
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,(hl)
	ld d,a
	ret
@table_693a:
	.db ENEMYID_SPIKED_BEETLE $00
	.db ENEMYID_GIBDO $00
	.db ENEMYID_ARROW_DARKNUT $01
	.db ENEMYID_MAGUNESU $00
	.db ENEMYID_LYNEL $01
	.db ENEMYID_IRON_MASK $00
	.db ENEMYID_POLS_VOICE $00
	.db ENEMYID_STALFOS $02
@state3:
	call interactionDecCounter1
	ret nz
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	call @func_692f
	ld b,$04
-
	call @func_6923
	call getFreeEnemySlot
	ret nz
	ld (hl),d
	inc l
	ld (hl),e
	ld l,$8b
	call setShortPosition_paramC
	dec b
	jr nz,-
	ldh a,(<hActiveObject)
	ld d,a
	jp interactionIncState
@state4:
	ld a,($cc30)
	or a
	ret nz
	ld a,(wActiveTriggers)
	inc a
	jp z,interactionDelete
	xor a
	ld ($ccc8),a
	ld e,$44
	ld a,$01
	ld (de),a
	ret

interactionCodedc_subid8:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
@state1:
	ld a,(wcca2)
	or a
	ret z
	ld b,a
	ld e,$47
	ld a,(de)
	ld hl,table_6a02
	rst_addAToHl
	ld a,(hl)
	cp b
	jr nz,+
	ld a,(de)
	inc a
	ld (de),a
	jr ++
+
	ld e,$70
	ld a,$01
	ld (de),a
++
	ldbc TREASURE_RUPEES RUPEEVAL_070
	ld e,$70
	ld a,(de)
	or a
	jr nz,@wrongChest
	ldbc TREASURE_RUPEES RUPEEVAL_200
	ld e,$47
	ld a,(de)
	cp $08
	jr c,@spawnRupeeTreasure
	call getThisRoomFlags
	bit 5,a
	jr nz,@spawnRupeeTreasure
	set 7,(hl)
	call func_6a18
	ld a,$4f
	call setTile
	ld a,SND_SOLVEPUZZLE
	ldbc TREASURE_RUPEES RUPEEVAL_200
	jr @success
@wrongChest:
	ld a,SND_ERROR
@success:
	call playSound
@spawnRupeeTreasure:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	ld l,$4b
	ld a,($ccbc)
	ld b,a
	and $f0
	ldi (hl),a
	inc l
	ld a,b
	swap a
	and $f0
	or $08
	ld (hl),a
	ld a,$81
	ld ($cca4),a
	xor a
	ld ($ccbc),a
	ret
table_6a02:
	.db $66 $5b $43 $3b
	.db $59 $23 $73 $35

interactionCodedc_subid9:
	call getThisRoomFlags
	and $80
	jp z,interactionDelete
	call func_6a18
	jp interactionDelete
func_6a18:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PORTAL_SPAWNER
	inc l
	ld (hl),$01
	ld c,$57
	ld l,$4b
	jp setShortPosition_paramC

interactionCodedc_subidA:
	ld hl,$c904
	set 4,(hl)
	jp interactionDelete

interactionCodedc_subidB:
	xor a
	ld (wToggleBlocksState),a
	jp interactionDelete

interactionCodedc_subidC:
	call checkInteractionState
	jr nz,+
	call objectGetTileAtPosition
	ld a,(wEnteredWarpPosition)
	cp l
	jp nz,interactionDelete
	call interactionIncState
	call interactionSetAlwaysUpdateBit
	ld a,$81
	ld ($cca4),a
	ld ($cc02),a
+
	ld a,($c4ab)
	or a
	ret nz
	ld bc,TX_0202
	call showText
	xor a
	ld ($cca4),a
	ld ($cc02),a
	jp interactionDelete

interactionCodedc_subidD:
	ld a,(wWarpDestPos)
	cp $22
	jr nz,+
	xor a
	ld (wWarpDestPos),a
	call initializeDungeonStuff
+
	jp interactionDelete

interactionCodedc_subidE:
	ld a,(wScrollMode)
	and $01
	ret z
	ld hl,wRoomLayout|$79
-
	ld a,(hl)
	cp $fe
	jr z,+
	cp $ff
	jr nz,++
+
	ld (hl),$7b
++
	dec l
	jr nz,-
	jp interactionDelete


; ==============================================================================
; INTERACID_GOLDEN_BEAST_OLD_MAN
; ==============================================================================
interactionCodedd:
	ld e,$44
	ld a,(de)
	or a
	jr z,+
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate
+
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisible82
	ld a,>TX_1f00
	call interactionSetHighTextIndex
	ld hl,mainScripts.goldenBeastOldManScript
	jp interactionSetScript

checkGoldenBeastsKilled:
	xor a
	ld hl,wTextNumberSubstitution
	ldi (hl),a
	ldd (hl),a
	ld a,(wKilledGoldenEnemies)
	and $0f
	call getNumSetBits
	ld (hl),a
	cp $04
	ld a,$01
	jr z,+
	dec a
+
	ld ($cfc1),a
	ret

giveRedRing:
	ldbc RED_RING $00
	jp giveRingToLink


; ==============================================================================
; INTERACID_MAKU_SEED_AND_ESSENCES
; ==============================================================================
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
	ld b,INTERACID_SPARKLE
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
	ld (hl),INTERACID_MAKU_SEED_AND_ESSENCES
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
	ldbc INTERACID_SPARKLE $03
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


; ==============================================================================
; INTERACID_NAYRU_RALPH_CREDITS
; ==============================================================================
interactionCodedf:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.angle
	ld (hl),$18

	ld l,Interaction.counter1
	ld (hl),60
	ld l,Interaction.subid
	ld a,(hl)
	or a
	jp z,objectSetVisiblec2
	jp objectSetVisiblec0

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate

@substate1:
	call interactionAnimate
	call objectApplySpeed
	cp $68 ; [xh]
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),180

	ld l,Interaction.subid
	ld a,(hl)
	or a
	ret nz
	ld a,$05
	jp interactionSetAnimation

@substate2:
	call interactionDecCounter1
	ret nz
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld (hl),$01
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$04
	inc l
	ld (hl),$01 ; [counter2]
	jr @setRandomVar38

@substate3:
	ld h,d
	ld l,Interaction.counter1
	call decHlRef16WithCap
	jr nz,@label_10_330

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),100

	ld b,SPEED_80 ; Nayru
	ld c,$04
	ld l,Interaction.subid
	ld a,(hl)
	or a
	jr z,++
	ld b,SPEED_180 ; Ralph
	ld c,$02
++
	ld l,Interaction.speed
	ld (hl),b
	ld a,c
	call interactionSetAnimation
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld (hl),$02
	ret

@label_10_330:
	ld l,Interaction.subid
	ld a,(hl)
	or a
	call z,interactionAnimate

.ifdef ROM_AGES
	ld l,Interaction.var38
.else
	ld l,Interaction.var37
.endif
	dec (hl)
	ret nz

	ld l,Interaction.direction
	ld a,(hl)
	xor $01
	ld (hl),a

	ld e,Interaction.subid
	ld a,(de)
	add a
	add (hl)
	call interactionSetAnimation

@setRandomVar38:
	call getRandomNumber_noPreserveVars
	and $03
	swap a
	add $20
.ifdef ROM_AGES
	ld e,Interaction.var38
.else
	ld e,Interaction.var37
.endif
	ld (de),a
	ret

@substate4:
	call interactionDecCounter1
	ret nz

	ld b,120
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
	ld b,160
+
	ld (hl),b ; [counter1]
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld (hl),$03
	jp interactionIncSubstate

@substate5:
	call interactionDecCounter1
	ret nz
	ld (hl),60 ; [counter1]
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld (hl),$04
	jp interactionIncSubstate

@substate6:
	call interactionAnimate
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld (hl),$01
	ret


; ==============================================================================
; INTERACID_PORTAL_SPAWNER
; ==============================================================================
interactionCodee1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw interactionAnimate
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
@state1:
	ld a,(wActiveGroup)
	or a
	jr nz,+
	call objectGetTileAtPosition
	cp $e6
	ret nz
+
	call func_6e06
	ld a,$02
	ld e,$44
	ld (de),a
	jp objectSetVisible83
func_6e06:
	ld e,$42
	ld a,(de)
	or a
	ret nz
	call getThisRoomFlags
	ld a,(wActiveGroup)
	cp $02
	jr c,+
	cp $03
	ret nz
	ld a,(wActiveRoom)
	cp $a8
	ld hl,wPresentRoomFlags | <ROOM_SEASONS_004
	jr z,+
	ld hl,wPresentRoomFlags | <ROOM_SEASONS_0f7
+
	set 3,(hl)
	ret


; ==============================================================================
; INTERACID_S_VIRE
; ==============================================================================
interactionCodee3:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld bc,$fe00
	call objectSetSpeedZ
	ld hl,mainScripts.vireScript
	call interactionSetScript
	ld a,$bb
	call playSound
	ld a,$00
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	call func_6ede
	ld e,$4f
	ld a,(de)
	cp $e0
	jr c,+
	jp interactionAnimateAsNpc
+
	call interactionIncSubstate
	ld a,$39
	ld (wActiveMusic),a
	call playSound
	ld a,$01
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@substate1:
	callab seasonsInteractionsBank0a.seasonsFunc_0a_71ce
	call interactionRunScript
	jr c,+
	jp interactionAnimateAsNpc
+
	call interactionIncSubstate
	ld a,$74
	call playSound
	ld bc,$fc00
	call objectSetSpeedZ
@substate2:
	call func_6ede
	ld e,$4f
	ld a,(de)
	cp $b0
	jr c,+
	jp interactionAnimateAsNpc
+
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	call interactionIncSubstate
@substate3:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_JEWEL_HELPER
	inc l
	ld (hl),$07
	ld l,$4b
	ld (hl),$7c
	ld l,$4d
	ld (hl),$78
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_PUFF
	ld a,$78
	ld l,$4b
	ldi (hl),a
	inc l
	ld (hl),a
+
	jp interactionDelete
func_6ede:
	ldh a,(<hActiveObjectType)
	add $0e
	ld l,a
	add $06
	ld e,a
	ld h,d
	jp objectApplyComponentSpeed@addSpeedComponent


; ==============================================================================
; INTERACID_LINKED_HEROS_CAVE_OLD_MAN
; ==============================================================================
interactionCodee4:
	call checkInteractionState
	jr z,+
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate
+
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisible82
	ld a,>TX_3300
	call interactionSetHighTextIndex
	ld hl,mainScripts.linkedHerosCaveOldManScript
	jp interactionSetScript

linkedHerosCaveOldMan_spawnChests:
	ld a,$01
	ld (wcca1),a
	dec a
	ld (wcca2),a
	ld b,$08
-
	call func_6f39
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_PUFF
	ld l,$4b
	call setShortPosition_paramC
+
	push bc
	ld a,TILEINDEX_CHEST
	call setTile
	pop bc
	dec b
	jr nz,-
	ret

func_6f39:
	ld a,b
	dec a
	ld hl,table_6f41
	rst_addAToHl
	ld c,(hl)
	ret

table_6f41:
	.db $23 $35 $3b $43
	.db $59 $5b $66 $73

linkedHerosCaveOldMan_takeRupees:
	xor a
	ld ($cfd0),a
	ld a,RUPEEVAL_060
	call cpRupeeValue
	ret nz
	ld a,RUPEEVAL_060
	call removeRupeeValue
	ld a,$01
	ld ($cfd0),a
	ret


; ==============================================================================
; INTERACID_GET_ROD_OF_SEASONS
;
; Variables:
;   var03:    Index of a seasons' sparkle from 0 to 3
;   var3b:    Initial time for each seasons' sparkle to start dropping sparkles
;   $cceb:    Set to 1 when Rod disappears, to remove its aura, and continue cutscene
; ==============================================================================
interactionCodee6:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionCodee6_state0
	.dw interactionCodee6_state1

interactionCodee6_state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @sparkles
	.dw @rodOfSeasons
	.dw @rodOfSeasonsAura

@subid0:
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	xor a
	ld ($cceb),a
	ld hl,mainScripts.gettingRodOfSeasonsScript
	jp interactionSetScript

@sparkles:
	ld e,Interaction.var03
	ld a,(de)
	rlca
	ld hl,@sparklesData
	rst_addDoubleIndex

	ldi a,(hl)
	ld e,Interaction.angle
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.oamFlags
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.var3b
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.speed
	ld (de),a

	ld h,d
	ld l,Interaction.counter1
	ld (hl),$3c

	ld l,Interaction.counter2
	ld (hl),$5a
	jp objectSetVisible80
@sparklesData:
	; angle - oamFlags - var3b(time to start pulsing) - speed
	.db $03 $00 $08 SPEED_180
	.db $0b $02 $0c SPEED_100
	.db $15 $03 $10 SPEED_100
	.db $1d $01 $14 SPEED_180

@rodOfSeasons:
	ld a,$04
	call objectSetCollideRadius
	ld h,d
	ld l,Interaction.zh
	ld (hl),$f0

	ld l,Interaction.counter1
	ld (hl),$00

	ld l,Interaction.counter2
	ld (hl),$30

	ldbc INTERACID_GET_ROD_OF_SEASONS 03
	call objectCreateInteraction
	ret nz

	ld l,Interaction.relatedObj1
	ldh a,(<hActiveObjectType)
	ldi (hl),a
	ldh a,(<hActiveObject)
	ld (hl),a

	jp objectSetVisible81

@rodOfSeasonsAura:
	call interactionSetAlwaysUpdateBit
	jp objectSetVisible82

interactionCodee6_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @sparkles
	.dw @rodOfSeasons
	.dw @rodOfSeasonsAura

@subid0:
	call interactionRunScript
	jp c,interactionDelete
	ret

@sparkles:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@waitToMove
	.dw @@move

@@waitToMove:
	call interactionDecCounter2
	ret nz
	call interactionIncSubstate

@@move:
	call dropSparkles
	call objectApplySpeed
	call interactionDecCounter1
	jp z,interactionDelete
	ret

@rodOfSeasons:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6

@@substate0:
	ld a,(wFrameCounter)
	and $03
	ret nz

	ld h,d
	ld l,Interaction.counter1
	inc (hl)
	ld a,(hl)
	and $0f
	ld hl,@@seasonsTable_15_705f
	rst_addAToHl
	ld a,(hl)
	add $f0
	ld e,Interaction.zh
	ld (de),a
	ld h,d
	ld l,Interaction.counter2
	dec (hl)
	ret nz

	call clearAllParentItems

	ld hl,w1Link.direction
	ld (hl),DIR_UP

	call objectGetAngleTowardLink
	ld h,d
	ld l,Interaction.angle
	ld (hl),a

	ld l,Interaction.speed
	ld (hl),SPEED_80

	ld l,Interaction.substate
	inc (hl)
	ret

@@seasonsTable_15_705f:
	.db $00 $00 $ff $ff
	.db $ff $fe $fe $fe
	.db $fe $fe $fe $ff
	.db $ff $ff $ff $00

@@substate1:
	call objectGetAngleTowardLink
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed
	call objectCheckCollidedWithLink_ignoreZ
	ret nc

	ld e,Interaction.collisionRadiusX
	ld a,$06
	ld (de),a
	jp interactionIncSubstate

@@substate2:
	ld c,$08
	call objectUpdateSpeedZ_paramC
	jr z,+
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
+
	ld h,d
	ld l,Interaction.counter2
	ld (hl),$1e
	jp interactionIncSubstate

@@substate3:
	call interactionDecCounter2
	ret nz

	ld a,$04
	ld (wLinkForceState),a
	xor a
	ld (wcc50),a

	call interactionIncSubstate
	ld a,(w1Link.yh)
	sub $0e
	ld l,Interaction.yh
	ldi (hl),a

	inc l
	ld a,(w1Link.xh)
	sub $04
	ldi (hl),a

	; zh/speed
	inc l
	xor a
	ldi (hl),a
	ld (hl),a

	ld b,>TX_0071
	ld c,<TX_0071
	call showText

	call getThisRoomFlags
	set 5,(hl)

	ld a,MUS_ESSENCE
	call playSound

	ld c,$07
	ld a,TREASURE_ROD_OF_SEASONS
	call giveTreasure

	jp darkenRoom

@@substate4:
	call retIfTextIsActive
	call interactionIncSubstate
	ld hl,mainScripts.gettingRodOfSeasonsScript_setCounter1To32
	jp interactionSetScript

@@substate5:
	call interactionRunScript
	ret nc

	call interactionIncSubstate
	ld l,Interaction.counter2
	ld (hl),$14
	jp brightenRoom

@@substate6:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call interactionDecCounter2
	ret nz
	ld a,$01
	ld ($cceb),a
	jp interactionDelete

@rodOfSeasonsAura:
	ld a,($cceb)
	or a
	jp nz,interactionDelete

	ld a,$00
	call objectGetRelatedObject1Var
	call objectTakePosition
	call interactionAnimate
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	ld l,Interaction.visible
	ld a,$80
	xor (hl)
	ld (hl),a
	ret

dropSparkles:
	ld h,d
	ld l,Interaction.var3b
	dec (hl)
	ret nz

	ld l,Interaction.var3b
	ld (hl),$10
	ldbc INTERACID_SPARKLE, $01
	jp objectCreateInteraction


forceLinksDirection:
	ld hl,w1Link.direction
	ld (hl),a
	ld a,$80
	jp setLinkForceStateToState08_withParam


spawnRodOfSeasonsSparkles:
	ld bc,@spawnCoordinates
	xor a
-
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz

	; spawn subid $01 (the sparkles for each season)
	ld (hl),INTERACID_GET_ROD_OF_SEASONS
	inc l
	ld (hl),$01
	inc l

	; var03 = 0 to 3
	ldh a,(<hFF8B)
	ld (hl),a

	; yx from table below
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a

	inc bc
	ldh a,(<hFF8B)
	inc a

	cp $04
	jr nz,-
	ret

@spawnCoordinates:
	.db $78 $18
	.db $08 $18
	.db $08 $88
	.db $78 $88


; ==============================================================================
; INTERACID_LONE_ZORA
; ==============================================================================
interactionCodee7:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$36
	call interactionSetHighTextIndex
	ld e,$7e
	ld a,GLOBALFLAG_BEGAN_KING_ZORA_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld (de),a
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

.ends
