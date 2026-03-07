; ==================================================================================================
; INTERAC_IMPA_NPC
; ==================================================================================================
interactionCode4f:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw impaNpc_subid00
	.dw impaNpc_subid01
	.dw impaNpc_subid02
	.dw impaNpc_subid03

impaNpc_subid00:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	ld e,Interaction.var03
	ld a,(de)
	dec a
	jr z,@animate

	cp $09
	call nz,impaNpc_faceLinkIfClose
@animate:
	jp interactionAnimateAsNpc

@state0:
	; Set the tile leading to nayru's basement to behave like stairs
	ld hl,wRoomLayout+$22
	ld (hl),TILEINDEX_INDOOR_DOWNSTAIRCASE

	call getImpaNpcState
	bit 7,b
	jp nz,interactionDelete

	call checkIsLinkedGame
	jr z,+
	ld a,$09
+
	add b
	call impaNpc_determineTextAndPositionInHouse

;;
; @param	hl	Script address
impaNpc_setScriptAndInitialize:
	call interactionSetScript
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.textID+1
	ld (hl),>TX_0100

	call objectMarkSolidPosition

	ld e,Interaction.var38
	ld a,(de)
	call interactionSetAnimation

	jp objectSetVisiblec2

;;
; Sets low byte of textID and returns a script address to use.
;
; May delete itself, then pop the return address from the stack to return from caller...
;
; @param	a	Index of "behaviour" ($00-$08 for unlinked, $09-$11 for linked)
; @param[out]	hl	Script address
impaNpc_determineTextAndPositionInHouse:
	ld e,Interaction.var03
	ld (de),a
	rst_jumpTable
	.dw @val00
	.dw @val01
	.dw @val02
	.dw @val03
	.dw @val04
	.dw @val05
	.dw @delete
	.dw @delete
	.dw @delete
	.dw @val09
	.dw @val0a
	.dw @val0b
	.dw @delete
	.dw @val0d
	.dw @val0e
	.dw @delete
	.dw @delete
	.dw @delete

@delete:
	pop hl
	jp interactionDelete

@val00:
@val09:
	ld bc,$3838
	ld a,<TX_0120
	jr @setTextAndPosition

@val01:
@val0a:
	ld bc,$4828
	ld a,<TX_0121
	call @setTextAndPosition
	ld (de),a
	ld hl,mainScripts.impaNpcScript_lookingAtPassage
	ret

@val02:
@val03:
@val04:
@val0b:
	ld bc,$2868
	ld a,<TX_0122
	jr @setTextAndPosition

@val0d:
	ld bc,$2868
	ld a,<TX_012c
	jr @setTextAndPosition

@val05:
@val0e:
	ld bc,$2868
	ld a,<TX_0123

@setTextAndPosition:
	ld e,Interaction.textID
	ld (de),a
	ld e,Interaction.yh
	ld a,b
	ld (de),a
	ld e,$4d
	ld a,c
	ld (de),a

	; var38 is the direction to face
	ld e,Interaction.var38
	ld a,$02
	ld (de),a

	ld hl,mainScripts.genericNpcScript
	xor a
	ret


; Impa in past (after telling you about Ralph's heritage)
impaNpc_subid01:
	call checkInteractionState
	jr nz,impaNpc_runScriptAndFaceLink
	call getImpaNpcState
	ld a,b
	cp $07
	jp nz,interactionDelete

	call checkIsLinkedGame
	ld a,<TX_012b
	jr z,impaNpc_setTextIndexAndLoadGenericNpcScript
	ld a,<TX_012e


;;
; @param	a	Low byte of text index (high byte is $01)
impaNpc_setTextIndexAndLoadGenericNpcScript:
	ld e,Interaction.textID
	ld (de),a

	; var38 is the direction to face
	ld e,Interaction.var38
	ld a,$02
	ld (de),a

	ld hl,mainScripts.genericNpcScript
	jp impaNpc_setScriptAndInitialize


; Impa after Zelda's been kidnapped
impaNpc_subid02:
	call checkInteractionState
	jr nz,impaNpc_runScriptAndFaceLink

@state0:
	call getImpaNpcState
	ld a,b
	cp $08
	jp nz,interactionDelete
	ld a,<TX_012f
	jr impaNpc_setTextIndexAndLoadGenericNpcScript


impaNpc_runScriptAndFaceLink:
	call interactionRunScript
	call impaNpc_faceLinkIfClose
	jp interactionAnimateAsNpc


; Impa after getting the maku seed
impaNpc_subid03:
	call checkInteractionState
	jr nz,impaNpc_runScriptAndFaceLink

	call getImpaNpcState
	ld a,b
	cp $06
	jp nz,interactionDelete

	ld a,<TX_0123
	jr impaNpc_setTextIndexAndLoadGenericNpcScript

;;
impaNpc_faceLinkIfClose:
	ld c,$28
	call objectCheckLinkWithinDistance
	jr nc,@noChange

	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	swap a
	rlca
	jr @updateDirection

@noChange:
	ld e,Interaction.var38
	ld a,(de)
@updateDirection:
	ld h,d
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation

;;
; Returns something in 'b':
; * $00 before d2 breaks down;
; * $01 after d2 breaks down;
; * $02 after obtaining harp;
; * $03 after beating d3;
; * $04 after saving Zelda from vire;
; * $05 after saving Nayru;
; * $06 after getting maku seed;
; * $07 after cutscene where Impa tells you about Ralph's heritage;
; * $08 after flame of despair is lit (beat Veran in a linked game);
; * $ff after finishing game
;
; @param[out]	b	Return value
getImpaNpcState:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld b,$ff
	ret nz
	inc b
	ld a,(wPresentRoomFlags+$83)
	rlca
	ret nc

	ld a,TREASURE_HARP
	call checkTreasureObtained
	ld b,$01
	ret nc

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jr nz,@savedNayru

	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA
	call checkGlobalFlag
	ld b,$04
	ret nz

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	bit 2,a
	ld b,$02
	ret z
	inc b
	ret

@savedNayru:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	ld b,$05
	ret nc

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	ld b,$06
	ret z

	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT
	call checkGlobalFlag
	ld b,$07
	ret z
	inc b
	ret
