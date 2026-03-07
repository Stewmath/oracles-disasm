; ==================================================================================================
; INTERAC_BOOK_OF_SEALS_PODIUM
;
; Variables:
;   var03: Tile index to replace path with?
; ==================================================================================================
interactionCodeb4:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a ; [state]

	ld a,$06
	call objectSetCollideRadius
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit

	ld a,>TX_1200
	call interactionSetHighTextIndex

	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList

	ld e,Interaction.subid
	ld a,(de)
	or a
	ret nz

	; Subid 0
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld b,$10
	call z,clearMemory
	call getThisRoomFlags
	bit 6,a
	ret nz
	call interactionIncState
	ld hl,mainScripts.bookOfSealsPodiumScript
	jp interactionSetScript

@state1:
	inc e
	ld a,(de) ; [substate]
	or a
	call z,@spawnAllPodiums
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

@activatedBook:
	ld a,$01
	call interactionSetAnimation
	call @func_69ce
	ld a,c
	ld (wTmpcfc0.genericCutscene.cfd0),a

	ld hl,@textTable
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_1200
	call showText

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	ld h,d
	ld l,Interaction.var03
	ld a,$d3
	ldi (hl),a
	ld a,$03
	ldi (hl),a ; [state]
	inc l
	ld (hl),$02 ; [substate]
	ret

@textTable:
	.db <TX_120b, <TX_120c, <TX_120d, <TX_120e, <TX_120f, <TX_1210

@state2:
	inc e
	ld a,(de) ; [substate]
	or a
	call z,@spawnAllPodiums
	call interactionRunScript
	ret nc

	; Placed book on podium
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld a,SND_SOLVEPUZZLE
	call playSound
	ld a,TREASURE_BOOK_OF_SEALS
	call loseTreasure
	jr @activatedBook

@state3:
	call retIfTextIsActive
	call @replaceTiles
	ld a,(wDisabledObjects)
	or a
	ret nz
	ld e,Interaction.var03
	ld a,$f4
	ld (de),a
	jp @func_69ce

;;
@replaceTiles:
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	call interactionDecCounter1
	ret nz
	ld (hl),$02 ; [counter1]
	ld l,Interaction.scriptPtr
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	or a
	jr z,@label_0b_273

	ld c,a
	ld e,Interaction.var03
	ld a,(de)
	push hl
	call setTile
	pop hl
	ret z
	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@label_0b_273:
	; a == 0 here
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld e,Interaction.pressedAButton
	ld (de),a
	jp interactionIncState


@state4:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	jr z,++

	xor a
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@textTable
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_1200
	jp showText
++
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld e,Interaction.subid
	ld a,(de)
	cp (hl)
	ret z

	call retIfTextIsActive
	call @replaceTiles
	ld a,(wDisabledObjects)
	or a
	ret nz

	call interactionSetAnimation
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld e,Interaction.pressedAButton
	xor a
	ld (de),a
	ret

;;
; @param[out]	c	Subid
@func_69ce:
	ld e,Interaction.subid
	ld a,(de)
	ld c,a
	ld hl,@bookPathLists
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@spawnAllPodiums:
	call returnIfScrollMode01Unset
	ld a,$01
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	or a
	ret nz

	ld bc,@podiumPositions
	ld e,$05

@next:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_BOOK_OF_SEALS_PODIUM
	inc l
	ld (hl),e ; [subid]
	ld l,Interaction.yh
	ld a,(bc)
	ldi (hl),a
	inc l
	inc bc
	ld a,(bc)
	ld (hl),a
	inc bc
	dec e
	jr nz,@next
	ret


; List of tiles to become solid for each book
@bookPathLists:
	dbrel @subid0
	dbrel @subid1
	dbrel @subid2
	dbrel @subid3
	dbrel @subid4
	dbrel @subid5
@subid0:
	.db $99 $9a $9b $8b $7b $7c
	.db $00
@subid1:
	.db $6d $5d $5c $4c $3c $3d
	.db $00
@subid2:
	.db $2c $2b $1b $1a $19
	.db $00
@subid3:
	.db $28 $27 $26 $25 $15 $14 $13
	.db $00
@subid4:
	.db $22 $23 $33 $43 $42 $41 $51 $61
	.db $00
@subid5:
	.db $72 $82 $83 $84 $74 $75 $65 $66 $67
	.db $00

@podiumPositions:
	.db $84 $18
	.db $14 $18
	.db $14 $78
	.db $14 $d8
	.db $84 $d8
