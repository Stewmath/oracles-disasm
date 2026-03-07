; ==================================================================================================
; INTERAC_AMBI
; ==================================================================================================
interactionCode4d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw ambi_state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid
	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw ambi_loadScript
	.dw ambi_ret
	.dw @initSubid0a


; Cutscene after escaping black tower
@initSubid01:
	ld a,($cfd0)
	cp $0b
	jp nz,ambi_loadScript
	call checkIsLinkedGame
	ret nz
	ld hl,mainScripts.ambiSubid01Script_part2
	jp interactionSetScript


; Cutscene where Ambi does evil stuff atop black tower (after d7)
@initSubid03:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete


; Same cutscene as subid $03, but second part
@initSubid04:
	callab agesInteractionsBank08.nayruState0@init0e
	jp ambi_loadScript


; Cutscene where you give mystery seeds to Ambi
@initSubid00:
	call soldierCheckBeatD6
	jp nc,interactionDelete


; Credits cutscene where Ambi observes construction of Link statue
@initSubid02:
	jp ambi_loadScript


; Cutscene where Ralph confronts Ambi
@initSubid05:
	; Call some of nayru's code to load possessed palette
	callab agesInteractionsBank08.nayruState0@init0e

	call objectSetVisiblec3
	jp ambi_loadScript


; Cutscene just before fighting possessed Ambi
@initSubid06:
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete

	; Load possessed palette and use it
	ld a,PALH_85
	call loadPaletteHeader
	ld h,d
	ld l,Interaction.oamFlags
	ld a,$06
	ldd (hl),a
	ld (hl),a

	ld a,$01
	ld (wNumEnemies),a

	; Create "ghost veran" object above Ambi
	call getFreeInteractionSlot
	jr z,++

	ld e,Interaction.state
	xor a
	ld (de),a
	ret
++
	ld (hl),INTERAC_GHOST_VERAN
	inc l
	inc (hl)
	ld bc,$f000
	call objectCopyPositionWithOffset

	ld a,SNDCTRL_STOPMUSIC
	call playSound

	; Set Link's direction & angle to "up"
	ld hl,w1Link.direction
	xor a
	ldi (hl),a
	ld (hl),a

	ld (wDisableLinkCollisionsAndMenu),a
	ld ($cfc0),a
	dec a
	ld (wActiveMusic),a

	ld hl,$cc93
	set 7,(hl)

	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$16
	ld (wLinkStateParameter),a


; Cutscene where Ambi regains control of herself
@initSubid07:
	jp ambi_loadScript

@initSubid0a:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld hl,wGroup4RoomFlags+$fc
	bit 7,(hl)
	jp z,interactionDelete
	jp ambi_loadScript

ambi_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw ambi_updateAnimationAndRunScript
	.dw ambi_runSubid01
	.dw ambi_runSubid02
	.dw ambi_runSubid03
	.dw ambi_runSubid04
	.dw ambi_runSubid05
	.dw ambi_runSubid06
	.dw ambi_runSubid07
	.dw ambi_runSubid08
	.dw interactionAnimate
	.dw ambi_runSubid0a

ambi_updateAnimationAndRunScript:
	call interactionAnimate
	jp interactionRunScript


; Cutscene after escaping black tower
ambi_runSubid01:
	call checkIsLinkedGame
	jr z,@updateSubstate
	ld a,($cfd0)
	cp $0b
	jp c,@updateSubstate

	call interactionAnimate
	jpab scriptHelp.turnToFaceSomething

@updateSubstate:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw ambi_updateAnimationAndRunScript

@substate0:
	ld a,($cfd0)
	cp $0e
	jr nz,ambi_updateAnimationAndRunScript

	callab agesInteractionsBank08.startJump
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.var3e
	inc (hl)

ambi_ret:
	ret


; Credits cutscene where Ambi observes construction of Link statue
ambi_runSubid02:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw interactionAnimateBasedOnSpeed

@substate0:
	call ambi_updateAnimationAndRunScript
	ret nc
	jp interactionIncSubstate

@substate1:
	call interactionAnimateBasedOnSpeed
	call objectApplySpeed
	ld a,($cfc0)
	cp $06
	ret nz
	call interactionIncSubstate
	ld bc,$5040
	jp interactionSetPosition


; Cutscene where Ambi does evil stuff atop black tower (after d7)
ambi_runSubid03:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @updateAnimationAndRunScript

@substate0:
	ld a,($cfc0)
	cp $01
	jr nz,@updateAnimationAndRunScript

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),SPEED_80

	call getFreePartSlot
	ret nz
	ld (hl),PART_LIGHTNING
	inc l
	inc (hl) ; [subid] = $01
	inc l
	inc (hl) ; [var03] = $01
	jp objectCopyPosition

@updateAnimationAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript

@substate1:
	call interactionDecCounter1
	ret nz
	xor a
	ld (wTmpcbb3),a
	dec a
	ld (wTmpcbba),a
	jp interactionIncSubstate

@substate2:
	ld hl,wTmpcbb3
	ld b,$02
	call flashScreen
	ret z

	call interactionIncSubstate
	ldbc INTERAC_SPARKLE,$08
	call objectCreateInteraction
	ld a,$02
	jp fadeinFromWhiteWithDelay

@substate3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$02
	ld ($cfc0),a
	jp interactionIncSubstate


; Same cutscene as subid $03 (black tower after d7), but second part
ambi_runSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw interactionAnimate

@substate0:
	call ambi_updateAnimationAndRunScript
	ret nc
	xor a
	ld (wTmpcbb3),a
	dec a
	ld (wTmpcbba),a
	jp interactionIncSubstate

@substate1:
	ld hl,wTmpcbb3
	ld b,$02
	call flashScreen
	ret z
	ld a,$03
	ld ($cfc0),a
	jp interactionIncSubstate

ambi_runSubid05:
	call interactionRunScript
	jp c,interactionDelete
	ld a,($cfc0)
	bit 1,a
	jp z,interactionAnimate
	ret

; Unused?
@data:
	.db $82 $90 $00 $55 $03


; $06: Cutscene just before fighting possessed Ambi
; $07: Cutscene where Ambi regains control of herself
ambi_runSubid06:
ambi_runSubid07:
	call interactionRunScript
	jp nc,interactionAnimate
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	jp interactionDelete


; Cutscene after d3 where you're told Ambi's tower will soon be complete
ambi_runSubid08:
	call ambi_updateAnimationAndRunScript
	ret nc

	ld a,$01
	ld ($cbb8),a
	ld a,CUTSCENE_BLACK_TOWER_EXPLANATION
	ld (wCutsceneTrigger),a
	jp interactionDelete


; NPC after Zelda is kidnapped
ambi_runSubid0a:
	call npcFaceLinkAndAnimate
	jp interactionRunScript


ambi_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.ambiSubid00Script
	.dw mainScripts.ambiSubid01Script_part1
	.dw mainScripts.ambiSubid02Script
	.dw mainScripts.ambiSubid03Script
	.dw mainScripts.ambiSubid04Script
	.dw mainScripts.ambiSubid05Script
	.dw mainScripts.ambiSubid06Script
	.dw mainScripts.ambiSubid07Script
	.dw mainScripts.ambiSubid08Script
	.dw mainScripts.stubScript
	.dw mainScripts.ambiSubid0aScript
