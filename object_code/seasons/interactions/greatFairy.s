; ==================================================================================================
; INTERAC_GREAT_FAIRY
; ==================================================================================================
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
