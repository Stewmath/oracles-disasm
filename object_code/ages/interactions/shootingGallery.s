; ==================================================================================================
; INTERAC_SHOOTING_GALLERY
; ==================================================================================================
interactionCode30:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw shootingGalleryNpc
	.dw shootingGalleryNpc
	.dw shootingGalleryNpc
	.dw shootingGalleryGame


;;
; Interaction $8b (goron elder) also calls this.
shootingGalleryNpc:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

; State 0: initializing
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	xor a
	ld (wTmpcfc0.shootingGallery.disableGoronNpcs),a
	call @setScript

; State 1: waiting for player to talk to the npc and start the game
@state1:
	call interactionRunScript
	jr nc,@updateAnimation
	xor a
	ld (wTmpcfc0.shootingGallery.gameStatus),a
	call interactionIncState

; State 2: waiting for the game to finish
@state2:
	ld a,(wTmpcfc0.shootingGallery.gameStatus)
	or a
	jr z,@updateAnimation
	ld a,$01
	call @setScript
	call interactionIncState

; State 3: waiting for "game wrapup" script to finish, then asks you to try again
@state3:
	call interactionRunScript

.ifdef REGION_JP
	jr c,@loadRetryScriptAndGotoState1
.else
	call c,@loadRetryScriptAndGotoState1
.endif

@updateAnimation:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jp nz,interactionAnimateAsNpc
	jp npcFaceLinkAndAnimate

;;
@loadRetryScriptAndGotoState1:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld a,$02

;;
; @param	a	Script index.
@setScript:
	; a *= 3
	ld b,a
	add a
	add b

	ld h,d
	ld l,Interaction.subid
	add (hl)
	ld hl,shootingGalleryScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

;;
; Interaction $30, subid $03 runs the shooting gallery game.
; It cycles through states 1-6 a total of 10 times.
; var3f is the round counter.
shootingGalleryGame:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	ld a,$01
	ld (wTmpcfc0.shootingGallery.disableGoronNpcs),a

	ld b,$0a
	call shootingGallery_initializeGameRounds

	; Initialize score
	xor a
	ld (wTextNumberSubstitution),a
	ld (wTextNumberSubstitution+1),a

	ld e,Interaction.var3f
	ld (de),a
	call interactionIncState

	ld l,Interaction.yh
	ld (hl),$2a
	ld l,Interaction.xh
	ld (hl),$50

	ld l,Interaction.counter1
	ld (hl),$78

	ld a,SND_WHISTLE
	call playSound

@state1:
	call interactionDecCounter1
	ret nz

	; These variables will be set by the "ball" object later?
	xor a
	ld (wShootingGalleryBallStatus),a
	ld (wShootingGalleryccd5),a
	ld (wShootingGalleryHitTargets),a

	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),$28
	ld a,SND_BASEBALL
	call playSound

@state2:
	call interactionDecCounter1
	ret nz

	call shootingGallery_createPuffAtEachTargetPosition
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$0a
	ret

@state3:
	call interactionDecCounter1
	ret nz

	call shootingGallery_setRandomTargetLayout
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$5a
	ret

@state4:
	call interactionDecCounter1
	ret nz

	call interactionIncState

	; Increment the "round" of the game
	ld l,Interaction.var3f
	inc (hl)

	jp shootingGallery_createBallHere

@state5:
	ld a,(wShootingGalleryBallStatus)
	bit 7,a
	ret z

; Ball has gone out-of-bounds

	and $7f
	jr nz,@hitSomething

	ld a,(wTmpcfc0.shootingGallery.isStrike)
	or a
	jr nz,@strike

	; Hit nothing, but not a strike.
	ld a,$14
	jr @setScript

@strike:
	ld a,$14
	call shootingGallery_addValueToScore
	ld a,$15
	jr @setScript

@hitSomething:
	cp $02
	jr z,@hit2Things

	ld a,(wShootingGalleryHitTargets)
	and $0f
	call getHighestSetBit
	jr @addValueToScore

@hit2Things:
	ld a,(wShootingGalleryHitTargets)
	and $0f
	call getHighestSetBit
	inc a
	add a
	add a
	ld b,a
	ld a,(wShootingGalleryHitTargets)
	swap a
	and $0f
	call getHighestSetBit
	add b

@addValueToScore:
	ldh (<hFF93),a
	call shootingGallery_addValueToScore
	ldh a,(<hFF93)

@setScript:
	ld hl,shootingGalleryHitScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),$28
	ld a,$81
	ld (wDisabledObjects),a
	ld a,$80
	ld (wMenuDisabled),a

@state6:
	call interactionRunScript
	ret nc

	; End the game on the tenth round
	ld e,Interaction.var3f
	ld a,(de)
	cp $0a
	jr z,++

	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld l,Interaction.counter1
	ld (hl),$14
	ret
++
	; Game is over
	ld a,$01
	ld (wTmpcfc0.shootingGallery.gameStatus),a
	xor a
	ld (wTmpcfc0.shootingGallery.disableGoronNpcs),a
	jp interactionDelete

;;
; Also used by goron dance minigame.
;
; @param	b	Number of rounds
shootingGallery_initializeGameRounds:
	ld hl,wShootingGalleryTileLayoutsToShow
	xor a
--
	ldi (hl),a
	inc a
	cp b
	jr nz,--

	ld (wTmpcfc0.shootingGallery.remainingRounds),a
	ret

;;
; Randomly choose the next layout to use. This uses a 10-byte buffer; each time a layout
; is picked, that value is removed from the buffer, and the buffer's size decreases by
; one.
;
; @param[out]	wTmpcfc0.shootingGallery.targetLayoutIndex	Index of the layout to use
shootingGallery_getNextTargetLayout:
	ld a,(wTmpcfc0.shootingGallery.remainingRounds)
	ld b,a
	dec a
	ld (wTmpcfc0.shootingGallery.remainingRounds),a

	; Get a random number between 0 and b-1
	call getRandomNumber
--
	sub b
	jr nc,--
	add b

	ld c,a
	ld hl,wShootingGalleryTileLayoutsToShow
	rst_addAToHl
	ld a,(hl)
	ld (wTmpcfc0.shootingGallery.targetLayoutIndex),a

	; Now shift the contents of the buffer down so that its total size decreases by
	; one, and the value we just read gets overwritten.
	push de
	ld d,c
	ld e,b
	dec e
	ld b,h
	ld c,l
--
	ld a,d
	cp e
	jr z,++
	inc bc
	ld a,(bc)
	ldi (hl),a
	inc d
	jr --
++
	pop de
	ret

;;
shootingGallery_removeAllTargets:
	ld a,$01
	ld (wTmpcfc0.shootingGallery.useTileIndexData),a
	ld e,Interaction.subid
	ld a,(de)
	sub $01
	jr z,@subid1
	jr nc,@subid2

@subid0:
	ld bc,shootingGallery_targetPositions_lynna
	jr shootingGallery_setTiles
@subid1:
	ld bc,shootingGallery_targetPositions_goron
	jr shootingGallery_setTiles
@subid2:
	ld bc,shootingGallery_targetPositions_biggoron
	jr shootingGallery_setTiles


;;
; Chooses one of the 10 target layouts to use and loads the tiles. (It never uses the same
; layout more than once, though.)
shootingGallery_setRandomTargetLayout:
	xor a
	ld (wTmpcfc0.shootingGallery.useTileIndexData),a
	call shootingGallery_getNextTargetLayout

	ld a,(wTmpcfc0.shootingGallery.targetLayoutIndex)

	; l = a*5
	ld l,a
	add a
	add a
	add l
	ld l,a

	ld e,Interaction.var03
	ld a,(de)
	sub $01
	ld a,l
	jr z,@goronGallery
	jr nc,@biggoronGallery

@lynnaGallery:
	ld hl,shootingGallery_targetTiles_lynna
	rst_addDoubleIndex
	ld bc,shootingGallery_targetPositions_lynna
	jr shootingGallery_setTiles

@goronGallery:
	ld hl,shootingGallery_targetTiles_goron
	rst_addDoubleIndex
	ld bc,shootingGallery_targetPositions_goron
	jr shootingGallery_setTiles

@biggoronGallery:
	ld hl,shootingGallery_targetTiles_biggoron
	rst_addDoubleIndex
	ld bc,shootingGallery_targetPositions_biggoron

;;
; @param	bc	Pointer to data containing positions of tiles to be replaced.
; @param	hl	Pointer to data containing tile indices for tiles to be replaced.
;			(optional)
; @param	wTmpcfc0.shootingGallery.useTileIndexData
;			If zero, it uses hl to get the tile indices; otherwise, all tiles
;			are replaced with TILEINDEX_STANDARD_FLOOR.
shootingGallery_setTiles:
	ld a,$0a
@nextTile:
	ldh (<hFF92),a
	ld a,(bc)
	inc bc
	push bc
	ld c,a
	ld a,(wTmpcfc0.shootingGallery.useTileIndexData)
	or a
	ld a,TILEINDEX_STANDARD_FLOOR
	jr nz,+
	ldi a,(hl)
+
	push hl
	call setTile
	pop hl
	pop bc
	ldh a,(<hFF92)
	dec a
	jr nz,@nextTile
	ret


; These are the positions of the tiles for the respective shooting gallery games.
shootingGallery_targetPositions_lynna:
	.db $31 $21 $12 $03 $04 $05 $06 $17 $28 $38

shootingGallery_targetPositions_goron:
	.db $21 $32 $12 $23 $04 $05 $26 $37 $17 $28

shootingGallery_targetPositions_biggoron:
	.db $21 $12 $03 $23 $14 $15 $06 $26 $17 $28


; These are the possible layouts of the tiles for the respective shooting gallery games.
; (One layout per line.)
shootingGallery_targetTiles_lynna:
	.db $d9 $dc $d9 $d9 $dc $d8 $d9 $d9 $dc $d9
	.db $dc $d9 $d9 $d8 $d9 $dc $dc $d9 $dc $d9
	.db $d9 $dc $d9 $dc $d7 $d9 $dc $d9 $d9 $d9
	.db $d9 $d9 $dc $d9 $d8 $d9 $dc $d8 $d9 $d9
	.db $dc $d8 $d9 $d9 $dc $d9 $d9 $dc $d9 $dc
	.db $d9 $d7 $d9 $d9 $d9 $d9 $d7 $d9 $d9 $d9
	.db $dc $dc $d9 $d9 $dc $d9 $d9 $d8 $d9 $d9
	.db $d9 $d9 $dc $d7 $d9 $d8 $d9 $d8 $d9 $d9
	.db $d9 $d9 $dc $d9 $d9 $dc $d9 $d9 $dc $dc
	.db $dc $d9 $d9 $d9 $d8 $d9 $dc $d9 $d9 $d9

shootingGallery_targetTiles_goron:
	.db $d9 $dc $d9 $d9 $d9 $d8 $d9 $d9 $dc $d9
	.db $dc $d9 $d9 $d8 $d9 $dc $d7 $d9 $dc $d9
	.db $d9 $dc $d9 $dc $d7 $d9 $d9 $dc $d9 $d9
	.db $d9 $d9 $dc $d9 $d8 $d9 $dc $d7 $d9 $d9
	.db $dc $d9 $d9 $d9 $d8 $d9 $d9 $dc $d9 $dc
	.db $d9 $dc $d9 $d9 $d9 $dc $d9 $d7 $d8 $d9
	.db $dc $d9 $d9 $d9 $dc $d9 $d9 $dc $d9 $d9
	.db $d9 $d9 $dc $d7 $d9 $d8 $d9 $d8 $d9 $d9
	.db $d9 $d9 $dc $d9 $d9 $dc $d8 $d9 $dc $d9
	.db $dc $d9 $d9 $dc $d9 $d9 $dc $d9 $d9 $dc

shootingGallery_targetTiles_biggoron:
	.db $d9 $d9 $dc $d7 $d9 $dc $d9 $d9 $d8 $dc
	.db $d9 $dc $d9 $d9 $d9 $d8 $dc $d9 $d9 $d8
	.db $d9 $d9 $d7 $dc $dc $d9 $dc $d9 $d9 $dc
	.db $d9 $d9 $dc $d9 $d8 $d9 $dc $d7 $d9 $d9
	.db $dc $d9 $d9 $dc $d9 $dc $dc $d9 $d9 $d8
	.db $d9 $dc $d9 $d9 $dc $d7 $dc $d9 $d9 $d9
	.db $d9 $d9 $d8 $d9 $dc $dc $d7 $d9 $d9 $dc
	.db $d9 $dc $d9 $dc $d9 $d8 $d9 $dc $dc $dc
	.db $dc $d9 $dc $d9 $d9 $dc $d9 $d8 $d9 $d7
	.db $d9 $d9 $d7 $d8 $dc $dc $d9 $dc $d9 $d9

;;
shootingGallery_createPuffAtEachTargetPosition:
	ld e,Interaction.var03
	ld a,(de)
	sub $01
	jr z,@subid1
	jr nc,@subid2

@subid0:
	ld bc,shootingGallery_targetPositions_lynna
	jr ++
@subid1:
	ld bc,shootingGallery_targetPositions_goron
	jr ++
@subid2:
	ld bc,shootingGallery_targetPositions_biggoron

++
	ld a,$0a
@nextTile:
	ldh (<hFF92),a
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERAC_PUFF
	ld a,(bc)
	inc bc
	push bc
	ld l,Interaction.yh
	call setShortPosition
	pop bc
	ldh a,(<hFF92)
	dec a
	jr nz,@nextTile
	ret

;;
shootingGallery_createBallHere:
	call getFreePartSlot
	ret nz
	ld (hl),PART_BALL
	jp objectCopyPosition

;;
; @param	a	Index?
shootingGallery_addValueToScore:
	ld hl,@scores
	rst_addDoubleIndex
	ld c,(hl)
	inc hl
	ld b,(hl)
	ld hl,wTextNumberSubstitution
	bit 0,c
	jr nz,+
	jp addDecimalToHlRef
+
	res 0,c
	jp subDecimalFromHlRef


; If the last digit is "1", the score is subtracted instead of added.
@scores:
	.dw $0030 ; $00
	.dw $0100 ; $01
	.dw $0011 ; $02
	.dw $0051 ; $03
	.dw $0060 ; $04
	.dw $0130 ; $05
	.dw $0020 ; $06
	.dw $0021 ; $07
	.dw $0130 ; $08
	.dw $0200 ; $09
	.dw $0090 ; $0a
	.dw $0050 ; $0b
	.dw $0020 ; $0c
	.dw $0090 ; $0d
	.dw $0021 ; $0e
	.dw $0061 ; $0f
	.dw $0021 ; $10
	.dw $0050 ; $11
	.dw $0061 ; $12
	.dw $00a1 ; $13
	.dw $0051 ; $14 (strike)


; Scripts for INTERAC_SHOOTING_GALLERY.

; NPC scripts
shootingGalleryScriptTable:
	; NPCs waiting to be talked to
	.dw mainScripts.shootingGalleryScript_humanNpc
	.dw mainScripts.shootingGalleryScript_goronNpc
	.dw mainScripts.shootingGalleryScript_goronElderNpc

	; Cleanup after finishing a game
	.dw mainScripts.shootingGalleryScript_humanNpc_gameDone
	.dw mainScripts.shootingGalleryScript_goronNpc_gameDone
	.dw mainScripts.shootingGalleryScript_goronElderNpc_gameDone

	; NPCs ask if you want to play again
	.dw mainScripts.shootingGalleryScript_humanNpc@tryAgain
	.dw mainScripts.shootingGalleryScript_goronNpc@tryAgain
	.dw mainScripts.shootingGalleryScript_goronElderNpc@beginGame


; Scripts to run when tile(s) of the corresponding types are hit.
shootingGalleryHitScriptTable:
	.dw mainScripts.shootingGalleryScript_hit1Blue        ; $00
	.dw mainScripts.shootingGalleryScript_hit1Fairy       ; $01
	.dw mainScripts.shootingGalleryScript_hit1Red         ; $02
	.dw mainScripts.shootingGalleryScript_hit1Imp         ; $03
	.dw mainScripts.shootingGalleryScript_hit2Blue        ; $04
	.dw mainScripts.shootingGalleryScript_hit1Blue1Fairy  ; $05
	.dw mainScripts.shootingGalleryScript_hit1Red1Blue    ; $06
	.dw mainScripts.shootingGalleryScript_hit1Blue1Imp    ; $07
	.dw mainScripts.shootingGalleryScript_hit1Blue1Fairy  ; $08
	.dw mainScripts.shootingGalleryScript_hit2Blue        ; $09
	.dw mainScripts.shootingGalleryScript_hit1Red1Fairy   ; $0a
	.dw mainScripts.shootingGalleryScript_hit1Fairy1Imp   ; $0b
	.dw mainScripts.shootingGalleryScript_hit1Red1Blue    ; $0c
	.dw mainScripts.shootingGalleryScript_hit1Red1Fairy   ; $0d
	.dw mainScripts.shootingGalleryScript_hit2Red         ; $0e
	.dw mainScripts.shootingGalleryScript_hit1Red1Imp     ; $0f
	.dw mainScripts.shootingGalleryScript_hit1Blue1Imp    ; $10
	.dw mainScripts.shootingGalleryScript_hit1Fairy1Imp   ; $11
	.dw mainScripts.shootingGalleryScript_hit1Red1Imp     ; $12
	.dw mainScripts.shootingGalleryScript_hit2Red         ; $13

	.dw mainScripts.shootingGalleryScript_hitNothing      ; $14
	.dw mainScripts.shootingGalleryScript_strike          ; $15
