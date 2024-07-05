; ==================================================================================================
; INTERAC_SUBROSIAN_SMITHY
; ==================================================================================================
interactionCodea4:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,$49
	ld (hl),$04
	ld a,>TX_3b00
	call interactionSetHighTextIndex
	call @func_6418
	ld hl,mainScripts.subrosianSmithyScript
	call interactionSetScript
	call interactionAnimateAsNpc
	ld a,$02
	call interactionSetAnimation
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc
@func_6418:
	ld a,TREASURE_PIRATES_BELL
	call checkTreasureObtained
	jr nc,+
	or a
	ld a,$01
	jr z,smithyLoadIntoVar3f
+
	ld a,TREASURE_HARD_ORE
	call checkTreasureObtained
	jr nc,+
	ld a,$02
	jr smithyLoadIntoVar3f
	
+
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr nz,+
	ld a,$00
	jr smithyLoadIntoVar3f
+
	ld a,$03

smithyLoadIntoVar3f:
	; $00 if none of the below
	; $01 if rusty bell
	; $02 if hard ore
	; $03 if finished game
	ld e,$7f
	ld (de),a
	ret
