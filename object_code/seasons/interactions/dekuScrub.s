; ==================================================================================================
; INTERAC_DEKU_SCRUB
; ==================================================================================================
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
	.db SPECIALOBJECT_RICKY
	.db SPECIALOBJECT_DIMITRI
	.db SPECIALOBJECT_MOOSH
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
