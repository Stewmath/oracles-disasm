; ==================================================================================================
; INTERAC_MAKU_CUTSCENES
; ==================================================================================================
interactionCode22:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @runScript
	.dw @state2
	
@state0:
	ld e,Interaction.subid
	ld a,(de)
	cp $08
	jr z,@outsideTempleOfWinter
	cp $09
	jr z,@haveWinterSeason
	jr nc,@atMakuTreeGate
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call @func_55f5
	jp z,interactionDelete
	call returnIfScrollMode01Unset
	call @setScript
	call interactionRunScript
	call interactionRunScript
	ld e,Interaction.subid
	ld a,(de)
	cp $07
	jr z,@outsideDungeon8
	call setMakuTreeStageAndMapText
	jr @runScript

@outsideDungeon8:
	ld hl,wMakuMapTextPresent
	; You already have the 8th essence
	ld (hl),<TX_1716
	jr @runScript

@outsideTempleOfWinter:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	ld a,TREASURE_ROD_OF_SEASONS
	call checkTreasureObtained
	jp nc,interactionDelete
	ld a,(wObtainedSeasons)
	add a
	jp z,interactionDelete

@haveWinterSeason:
	call @setScript
	call interactionRunScript
	call interactionRunScript
	call setMakuTreeStageAndMapText
	jr @runScript

@atMakuTreeGate:
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete
	call @setScript
	jr @runScript

@setScript:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@runScript:
	call interactionRunScript
	jp c,interactionDelete
	ret
	
@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld hl,@tileChangeTable
	ld b,$04
-
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	push hl
	push bc
	call setInterleavedTile
	pop bc
	pop hl
	dec b
	jr nz,-
	ldh a,(<hActiveObject)
	ld d,a
	ld e,Interaction.substate
	ld a,$01
	ld (de),a
	ld e,Interaction.counter1
	ld a,$1e
	ld (de),a
	xor a
	call @func_561f
	ld a,$73
	call playSound

@rumble:
	ld a,$06
	call setScreenShakeCounter
	ld a,$70
	jp playSound

@substate1:
	call interactionDecCounter1
	ret nz
	ld hl,@tileChangeTable
	ld b,$04
-
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	push hl
	push bc
	call setTile
	pop bc
	pop hl
	inc hl
	inc hl
	inc hl
	dec b
	jr nz,-
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	xor a
	inc e
	ld (de),a
	ld a,$04
	call @func_561f
	ld a,$73
	call playSound
	jr @rumble

@tileChangeTable:
	; 1st instance is for interleave:
	;   position of tile - tile 1, tile 2, type of interleave
	; 2nd instance is for settile:
	;   position of tile - tile to set to
	.db $14 $bf $a0 $03
	.db $15 $bf $a0 $01
	.db $24 $a9 $a1 $03
	.db $25 $aa $a1 $01

@func_55f5:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,@noEssence
	ld e,Interaction.var3e
	ld (de),a
	call @func_5610
	ld c,a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,bitTable
	add l
	ld l,a
	ld a,c
	and (hl)
	ret
@noEssence:
	xor a
	ret
	
@func_5610:
	push af
	ld hl,wc6e5
	ld (hl),$00
-
	add a
	jr nc,+
	inc (hl)
+
	or a
	jr nz,-
	pop af
	ret


@func_561f:
	ld bc,@table_563f
	call addDoubleIndexToBc
	ld a,$04
-
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUFF
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	inc bc
	ldh a,(<hFF8B)
	dec a
	jr nz,-
	ret

@table_563f:
	.db $18 $48
	.db $18 $58
	.db $28 $48
	.db $28 $58
	.db $18 $40
	.db $18 $60
	.db $28 $40
	.db $28 $60

@scriptTable:
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutscene
	.dw mainScripts.makuTreeScript_remoteCutsceneDontSetRoomFlag
	.dw mainScripts.makuTreeScript_gateHit
