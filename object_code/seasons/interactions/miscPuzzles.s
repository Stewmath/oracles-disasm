; ==================================================================================================
; INTERAC_MISCELLANEOUS_2
; ==================================================================================================
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
	ld (hl),INTERAC_PUFF
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
	ld (hl),INTERAC_PUFF
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
	ldbc INTERAC_MINIBOSS_PORTAL $02
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
	ld (hl),INTERAC_TREASURE
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
	ld (hl),INTERAC_PUFF
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
	.db ENEMY_SPIKED_BEETLE $00
	.db ENEMY_GIBDO $00
	.db ENEMY_ARROW_DARKNUT $01
	.db ENEMY_MAGUNESU $00
	.db ENEMY_LYNEL $01
	.db ENEMY_IRON_MASK $00
	.db ENEMY_POLS_VOICE $00
	.db ENEMY_STALFOS $02
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
	ld (hl),INTERAC_TREASURE
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
	ld (hl),INTERAC_PORTAL_SPAWNER
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
