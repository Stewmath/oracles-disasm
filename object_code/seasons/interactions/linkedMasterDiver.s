; ==================================================================================================
; INTERAC_LINKED_MASTER_DIVER
; ==================================================================================================
interactionCodecd:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld a,$4c
	call interactionSetHighTextIndex
	ld a,GLOBALFLAG_DONE_DIVER_SECRET
	call checkGlobalFlag
	jp z,@notDoneDiverSecret
	ld hl,mainScripts.masterDiverScript_secretDone
	jr @setScript
@notDoneDiverSecret:
	ld a,$07
	ld b,$ea
	call getRoomFlags
	and $40
	jr z,+
	res 6,(hl)
	ld hl,mainScripts.masterDiverScript_swimmingChallengeDone
	jr @setScript
+
	ld a,GLOBALFLAG_BEGAN_DIVER_SECRET
	call checkGlobalFlag
	ld hl,mainScripts.masterDiverScript_beginningSecret
	jr z,@setScript
	ld hl,mainScripts.masterDiverScript_begunSecret
@setScript:
	call interactionSetScript
	xor a
	ld hl,$cfd0
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld a,$02
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@subid1:
	ld hl,$cfd1
	ld a,(hl)
	or a
	jp nz,interactionDelete
	inc (hl)
	ld h,d
	ld l,$44
	ld (hl),$02
	ld a,GLOBALFLAG_SWIMMING_CHALLENGE_SUCCEEDED
	call unsetGlobalFlag
	ld a,>TX_4c00
	call interactionSetHighTextIndex
	ld hl,mainScripts.masterDiverScript_swimmingChallengeText
	call interactionSetScript
	call objectSetReservedBit1
	jr @state2
@subid2:
	ld h,d
	ld l,$44
	ld (hl),$02
	ld a,>TX_4c00
	call interactionSetHighTextIndex
	ld hl,mainScripts.masterDiverScript_spawnFakeStarOre
	call interactionSetScript
	jr @state2
@state1:
	call interactionRunScript
	ld e,$7f
	ld a,(de)
	or a
	ret nz
	jp interactionAnimateAsNpc
@state2:
	ld e,$42
	ld a,(de)
	dec a
	jr nz,+
	; Inside waterfall cave
	callab func_79df
+
	call interactionRunScript
	jp c,interactionDelete
	ret
