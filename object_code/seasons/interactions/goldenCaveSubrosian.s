; ==================================================================================================
; INTERAC_GOLDEN_CAVE_SUBROSIAN
; ==================================================================================================
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
