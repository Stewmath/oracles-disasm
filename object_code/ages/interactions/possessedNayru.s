; ==================================================================================================
; INTERAC_POSSESSED_NAYRU
; ==================================================================================================
interactionCode6d:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw possessedNayru_subid00
	.dw possessedNayru_ghost
	.dw possessedNayru_ghost


possessedNayru_subid00:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,GLOBALFLAG_BEAT_POSSESSED_NAYRU
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,PALH_85
	call loadPaletteHeader

	ld a,GLOBALFLAG_BEGAN_POSSESSED_NAYRU_FIGHT
	call checkGlobalFlag
	jr nz,@state2

	; Spawn "ghost" veran
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_POSSESSED_NAYRU
	inc l
	ld (hl),$02
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.start
	inc l
	ld (hl),d

	call objectCopyPosition
	call interactionInitGraphics

	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$0e
	ld (wLinkStateParameter),a

	; Set Link's direction, angle
	ld hl,w1Link.direction
	ld a,(wScreenTransitionDirection)
	ldi (hl),a
	swap a
	rrca
	ld (hl),a

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call interactionIncState
	call objectSetVisible82
	ld hl,mainScripts.possessedNayru_beginFightScript
	jp interactionSetScript

@state1:
	call interactionRunScript
	ret nc
	call interactionIncState

@state2:
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMY_VERAN_POSSESSION_BOSS
	call objectCopyPosition
	ld h,d
	ld l,Interaction.state
	ld (hl),$03
	ret

@state3:
	ld a,GLOBALFLAG_BEGAN_POSSESSED_NAYRU_FIGHT
	call setGlobalFlag
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	inc a
	ld (wLoadedTreeGfxIndex),a
	jp interactionDelete


possessedNayru_ghost:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),-$04
	ret

@state1:
	ld a,Object.var37
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	ret z

	inc (hl)
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_80
	call objectSetVisible81
	ld hl,mainScripts.possessedNayru_veranGhostScript
	jp interactionSetScript

@state2:
	call interactionRunScript
	jp nc,interactionAnimate

	ld a,Object.var37
	call objectGetRelatedObject1Var
	ld (hl),$00
	jp interactionDelete
