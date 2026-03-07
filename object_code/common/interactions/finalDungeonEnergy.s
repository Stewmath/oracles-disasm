; ==================================================================================================
; INTERAC_FINAL_DUNGEON_ENERGY
; ==================================================================================================
interactionCodeb5:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]

	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	set 6,(hl) ; [room flags]
	call setDeathRespawnPoint

.ifdef ROM_SEASONS
	ld a,$09
	ld (wc6e5),a
.endif

	xor a
	ld (wTextIsActive),a

	ld a,120
	ld e,Interaction.counter1
	ld (de),a

	ld bc,$5878
	jp createEnergySwirlGoingIn

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionDecCounter1
	ret nz

	call interactionIncSubstate

	ld l,Interaction.counter1
	ld (hl),$08

	ld hl,wGenericCutscene.cbb3
	ld (hl),$00
	ld hl,wGenericCutscene.cbba
	ld (hl),$ff
	ret

@substate1:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr nz,++
	call setLinkForceStateToState08
	ld hl,w1Link.visible
	set 7,(hl)
++
	call interactionDecCounter1
	ld hl,wGenericCutscene.cbb3
	ld b,$01
	call flashScreen
	ret z
	call interactionIncSubstate
	ld a,$03
	jp fadeinFromWhiteWithDelay

@substate2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

.ifdef ROM_AGES
	ld (wUseSimulatedInput),a
.endif

	jp interactionDelete
