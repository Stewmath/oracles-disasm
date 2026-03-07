; ==================================================================================================
; INTERAC_BLACK_TOWER_DOOR_HANDLER
; ==================================================================================================
interactionCodec6:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


@state0:
	call getThisRoomFlags
	and ROOMFLAG_40
	jr z,@cutsceneNotDone

	; Already did the cutscene. Replace the door with a staircase (functionally, not visually)
	; for some reason...
	ld hl,wRoomLayout+$47
	ld (hl),$44
	jp interactionDelete

@cutsceneNotDone:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jr nc,@noMakuSeed

	; Time to start the cutscene.
.ifndef REGION_JP
	call clearAllItemsAndPutLinkOnGround
.endif
	call resetLinkInvincibility

	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$70
	ld (wLinkStateParameter),a

	ld e,Interaction.counter1
	ld (de),a
	ld hl,w1Link.direction
	ld (hl),$01
	inc l
	ld (hl),$08 ; [w1Link.angle]

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	call interactionIncState
	ld a,PALH_ab
	call loadPaletteHeader
	jp restartSound

@noMakuSeed:
	; Replace door tiles with staircase tiles? This will only affect behaviour (not appearance),
	; so this might be because the door tiles are actually fake for some reason?
	ld a,$44
	ld hl,wRoomLayout+$44
	ld (hl),a
	ld l,$47
	ld (hl),a
	ld l,$4a
	ld (hl),a

	; Prevent them from sending you anywhere
	ld (wDisableWarps),a

	jp interactionDelete


; Delay before making Link face up
@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),30
	xor a ; DIR_UP
	ld hl,w1Link.direction
	ldi (hl),a
	ld (hl),a
	jp interactionIncState


; Delay before starting cutscene
@state2:
	call interactionDecCounter1
	ret nz
	ld b,INTERAC_MAKU_SEED_AND_ESSENCES
	call objectCreateInteractionWithSubid00
	jp interactionDelete
