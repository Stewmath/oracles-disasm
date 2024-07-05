; ==================================================================================================
; INTERAC_TIMEPORTAL
;
; Variables:
;   var03: Short-form position
; ==================================================================================================
interactionCodede:
	ld a,$02
	ld (wcddd),a
	ld a,(wMenuDisabled)
	or a
	jp nz,objectSetInvisible

	call objectSetVisible
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; Delete self if a timeportal exists already.
	; BUG: This only checks for timeportals in object slots before the current one. This makes
	; it possible to "stack" timeportals.
	ld c,INTERAC_TIMEPORTAL
	call objectFindSameTypeObjectWithID
	ld a,h
	cp d
	jp nz,interactionDelete

	ld a,$03
	call objectSetCollideRadius
	call objectGetShortPosition
	ld c,a

	call interactionIncState

	ld l,Interaction.var03
	ld (hl),c
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	call nc,interactionIncState
	call interactionInitGraphics
	jp objectSetVisible83

@state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jp nc,interactionIncState
	jr timeportal_updatePalette

@state2:
	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	ld a,(wPortalPos)
	cp b
	jp nz,interactionDelete

	call timeportal_updatePalette
	ld a,(wLinkObjectIndex)
	rrca
	ret c
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	call checkLinkCollisionsEnabled
	ret nc

	; Link touched the portal
	ld a,$ff
	ld (wPortalGroup),a

	; Fall through

;;
; Also called by INTERAC_TIMEPORTAL_SPAWNER.
interactionBeginTimewarp:
	call resetLinkInvincibility
	ld hl,w1Link
	call objectCopyPosition
	ld l,<w1Link.direction
	ld (hl),DIR_DOWN

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a

	call objectGetTileAtPosition
	ld (wActiveTileIndex),a
	ld a,l
	ld (wActiveTilePos),a
	inc a
	ld (wLinkTimeWarpTile),a
	ld (wcde0),a

	ld a,CUTSCENE_TIMEWARP
	ld (wCutsceneTrigger),a
	call restartSound
	jp interactionDelete

;;
timeportal_updatePalette:
	ld a,(wFrameCounter)
	and $01
	jr nz,@animate
	ld e,Interaction.oamFlags
	ld a,(de)
	inc a
	and $0b
	ld (de),a
@animate:
	jp interactionAnimate
