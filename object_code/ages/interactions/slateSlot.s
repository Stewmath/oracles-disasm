; ==================================================================================================
; INTERAC_SLATE_SLOT
;
; Variables:
;   var3f: Counter to push against this object until the slate will be placed
; ==================================================================================================
interactionCodedb:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; Check if slate already placed
	ld e,Interaction.subid
	ld a,(de)
	ld bc,bitTable
	add c
	ld c,a
	call getThisRoomFlags
	ld a,(bc)
	and (hl)
	jp nz,interactionDelete

	ld hl,mainScripts.slateSlotScript
	call interactionSetScript
	jp interactionIncState

@state1:
	call objectCheckCollidedWithLink_notDead
	call nc,@resetCounter
	call objectCheckLinkPushingAgainstCenter
	call nc,@resetCounter

	ld h,d
	ld l,Interaction.var3f
	dec (hl)
	jr nz,@state2

	; Time to place the slate, if available
	ld a,(wNumSlates)
	or a
	jr nz,@placeSlate

	; Not enough slates
	ld bc,TX_5111
	call showText

@resetCounter:
	ld e,Interaction.var3f
	ld a,$0a
	ld (de),a
	ret

@placeSlate:
	call checkLinkVulnerable
	jr nc,@resetCounter

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld hl,mainScripts.slateSlotScript_placeSlate
	call interactionSetScript
	call interactionIncState

@state2:
	call interactionRunScript
	ret nc
	jp interactionDelete
