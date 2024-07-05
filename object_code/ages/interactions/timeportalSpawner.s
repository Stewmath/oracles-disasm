; ==================================================================================================
; INTERAC_TIMEPORTAL_SPAWNER
; ==================================================================================================
interactionCodee1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

; Portal is active
@state3:
	call objectSetVisible83
	ld b,$01
	call objectFlickerVisibility
	call interactionAnimate

	call @markSpotDiscovered

	; Wait for Link to touch the portal
	ld a,(wLinkObjectIndex)
	rrca
	ret c
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	call checkLinkCollisionsEnabled
	ret nc

	; Link touched the portal
	ld e,Interaction.subid
	ld a,(de)
	bit 6,a
	jr z,++
	call getThisRoomFlags
	set 1,(hl)
++
	jpab interactionBeginTimewarp
	; Above call will delete this object

@state0:
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @commonInit
	.dw @subid1Init
	.dw @subid2Init

@subid1Init:
	ld a,GLOBALFLAG_MAKU_TREE_SAVED
	call checkGlobalFlag
	jr nz,@commonInit
	jr @setSubidBit7

@subid2Init:
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	jr c,@commonInit

@setSubidBit7:
	ld h,d
	ld l,Interaction.subid
	set 7,(hl)

@commonInit:
	; If the portal tile is hidden, don't allow activation yet
	call objectGetTileAtPosition
	cp TILEINDEX_PORTAL_SPOT
	ret nz

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld a,$02
	call objectSetCollideRadius

	ld l,Interaction.subid
	ld b,(hl)
	bit 6,b
	jr z,@nextState

	call getThisRoomFlags
	and $02
	jr nz,@nextState

	set 7,b
@nextState:
	call interactionIncState
	bit 7,b
	ret z
	ld (hl),$03
	ret

@state1:
	ld a,(wLinkPlayingInstrument)
	dec a
	ret nz
	call interactionIncState

@markSpotDiscovered:
	call getThisRoomFlags
	set ROOMFLAG_BIT_PORTALSPOT_DISCOVERED,(hl)
	ret

@state2:
	ld a,(wLinkPlayingInstrument)
	or a
	ret nz
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_TELEPORT
	call playSound
	jp interactionIncState
