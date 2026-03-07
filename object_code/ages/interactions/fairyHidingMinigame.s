; ==================================================================================================
; INTERAC_FAIRY_HIDING_MINIGAME
; ==================================================================================================
interactionCode6c:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw fairyHidingMinigame_subid00
	.dw fairyHidingMinigame_subid01
	.dw fairyHidingMinigame_subid02


; Begins fairy-hiding minigame
fairyHidingMinigame_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; Delete self if game shouldn't happen right now
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jp nc,interactionDelete

	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld hl,wTmpcfc0.fairyHideAndSeek.active
	ldi a,(hl)
	or a
	jp z,interactionIncState

	; Minigame already started; spawn in the fairies Link's found.
	ld a,(hl)
	sub $07
	jr nz,@spawn3Fairies

	; Minigame just starting
	ld a,CUTSCENE_FAIRIES_HIDE
	ld (wCutsceneTrigger),a
	ld a,$80
	ld (wMenuDisabled),a
	ld a,DISABLE_COMPANION | DISABLE_LINK
	ld (wDisabledObjects),a
	xor a
	ld (w1Link.direction),a

@spawn3Fairies:
	jp fairyHidingMinigame_spawn3FairiesAndDelete

@state1:
	call fairyHidingMinigame_checkBeginCutscene
	ret nc
	ld a,(wScreenTransitionDirection)
	ld (w1Link.direction),a
	ld a,$01
	ld (wTmpcfc0.fairyHideAndSeek.active),a
	ld hl,mainScripts.fairyHidingMinigame_subid00Script
	jp interactionSetScript

@state2:
	call interactionRunScript
	ret nc
	ld a,CUTSCENE_FAIRIES_HIDE
	ld (wCutsceneTrigger),a
	jp interactionDelete


; Hiding spot for fairy
fairyHidingMinigame_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call fairyHidingMinigame_checkMinigameActive
	jp nc,interactionDelete

	; [var38] = original tile index
	call objectGetTileAtPosition
	ld e,Interaction.var38
	ld (de),a

	ld e,l
	ld hl,@table
	call lookupKey
	ld e,Interaction.var03
	ld (de),a

	; Delete if already found this fairy
	sub $03
	ld hl,wTmpcfc0.fairyHideAndSeek.foundFairiesBitset
	call checkFlag
	jp nz,interactionDelete

	xor a
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a
	ld e,Interaction.counter1
	ld a,$0c
	ld (de),a
	jp interactionIncState


; b0: tile position (lookup key)
; b1: value for var03 of fairy to spawn when found (subid is $00)
@table:
	.db $25 $03
	.db $54 $04
	.db $32 $05
	.db $00

@state1:
	; Check if tile changed
	call objectGetTileAtPosition
	ld b,a
	ld e,Interaction.var38
	ld a,(de)
	cp b
	ret z

	call interactionDecCounter1
	ret nz
	call fairyHidingMinigame_checkBeginCutscene
	ret nc
	ld a,$01
	ld (wDisableScreenTransitions),a

; Tile changed; fairy is revealed
@state2:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_FOREST_FAIRY
	ld l,Interaction.var03
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCreatePuff
	call interactionIncState
	ld hl,mainScripts.fairyHidingMinigame_subid01Script
	jp interactionSetScript

@state3:
	call interactionRunScript
	ret nc

	ld e,Interaction.var03
	ld a,(de)
	sub $03
	ld hl,wTmpcfc0.fairyHideAndSeek.foundFairiesBitset
	call setFlag

	; If found all fairies, warp out
	ld a,(wTmpcfc0.fairyHideAndSeek.foundFairiesBitset)
	cp $07
	jr z,@warpOut

	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld (wDisableScreenTransitions),a
	jr @delete

@warpOut:
	ld hl,@warpDestination
	call setWarpDestVariables
@delete:
	jp interactionDelete

@warpDestination:
	m_HardcodedWarpA ROOM_AGES_082, $00, $64, $03


; Checks for Link leaving the hide-and-seek area
fairyHidingMinigame_subid02:
	ld e,Interaction.state
	ld a,(de)
	or a
	jr z,@state0

@state1:
	call interactionRunScript
	ret nc

	; Clear hide-and-seek-related variables
	ld hl,wTmpcfc0.fairyHideAndSeek.active
	ld b,$10
	call clearMemory
	jp interactionDelete

@state0:
	call fairyHidingMinigame_checkMinigameActive
	jp nc,interactionDelete
	call interactionIncState
	ld hl,mainScripts.fairyHidingMinigame_subid02Script
	jp interactionSetScript

;;
; Spawns the 3 fairies; they should delete themselves if they're not found yet?
fairyHidingMinigame_spawn3FairiesAndDelete:
	ld b,$03

@spawnFairy:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_FOREST_FAIRY
	inc l
	inc (hl)   ; [subid] = $01
	inc l
	dec b
	ld (hl),b  ; [var03] = 0,1,2
	jr nz,@spawnFairy
	jp interactionDelete

;;
; @param[out]	cflag	c if Link is vulnerable (ready to begin cutscene?)
fairyHidingMinigame_checkBeginCutscene:
	call checkLinkVulnerable
	ret nc

	ld a,$80
	ld (wMenuDisabled),a

	ld a,DISABLE_COMPANION | DISABLE_LINK
	ld (wDisabledObjects),a

	call dropLinkHeldItem
	call clearAllParentItems
	call interactionIncState
	scf
	ret

;;
; @param[out]	cflag	c if minigame is active
fairyHidingMinigame_checkMinigameActive:
	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME
	call checkGlobalFlag
	ret nz
	ld a,(wTmpcfc0.fairyHideAndSeek.active)
	rrca
	ret
