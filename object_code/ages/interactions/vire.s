; ==================================================================================================
; INTERAC_VIRE
;
; Variables:
;   relatedObj1: Zelda object (for vire subid 2 only)
;   var38: If nonzero, the script is run (subids 0 and 1 only)
; ==================================================================================================
interactionCodeb8:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw vire_subid0
	.dw vire_subid1
	.dw vire_subid2


; Vire at black tower entrance
vire_subid0:
	call checkInteractionState
	jr z,@state0

@state1:
	ld e,Interaction.var38
	ld a,(de)
	or a
	jr nz,@runScript

	call vire_disableObjectsIfLinkIsReady
	jr nc,@animate
	xor a
	ld (w1Link.direction),a

@runScript:
	call interactionRunScript
	jp c,vire_deleteAndReturnControl
@animate:
	jp interactionAnimate

@state0:
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete

	ld a,MUS_GREAT_MOBLIN
	call playSound
	ld hl,mainScripts.vireSubid0Script

vire_setScript:
	call interactionSetScript
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_200

	xor a
	ld (wTmpcfc0.genericCutscene.cfd0),a
	jp objectSetVisiblec2


; Vire in donkey kong minigame (lower level)
vire_subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,(wGroup5RoomFlags+(<ROOM_AGES_5e7))
	bit 6,a
	jp nz,interactionDelete

	call getThisRoomFlags
	bit 6,(hl)
	ld hl,mainScripts.vireSubid1Script
	jr z,vire_setScript

	ld a,(wActiveMusic)
	or a
	ld a,MUS_MINIBOSS
	call nz,playSound
	jr @gotoState2

@state1:
	ld e,Interaction.var38
	ld a,(de)
	or a
	jr nz,@runScript

	ld a,(w1Link.yh)
	cp $9b
	jp nc,interactionAnimate

	call vire_disableObjectsIfLinkIsReady
	jp nc,interactionAnimate

@runScript:
	call interactionRunScript
	jp nc,interactionAnimate
	call objectSetInvisible
	call vire_returnControl

@gotoState2:
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
	ld l,Interaction.counter1
	ld (hl),$08
	ret

@state2:
	call interactionDecCounter1
	ret nz

	ld hl,w1Link.yh
	ldi a,(hl)
	cp $10
	jr nc,@spawnFireball

	inc l
	ld a,(hl) ; [w1Link.xh]
	cp $a0
	jr nc,vire_setRandomCounter1

@spawnFireball:
	call getFreePartSlot
	jr nz,vire_setRandomCounter1
	ld (hl),PART_DONKEY_KONG_FLAME
	inc l
	inc (hl) ; [subid] = 1

vire_setRandomCounter1:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Interaction.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db 120, 160, 200, 240


; Vire in donkey kong minigame (upper level)
vire_subid2:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete

	ldbc INTERAC_ZELDA, $03
	call objectCreateInteraction
	ret nz

	ld e,Interaction.relatedObj1
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld hl,mainScripts.vireSubid2Script
	call vire_setScript
	ld l,Interaction.counter1
	ld (hl),$08
	ret

@state1:
	ld hl,w1Link.yh
	ldi a,(hl)
	cp $40
	jr nc,@gameStillGoing
	inc l
	ld a,(hl) ; [w1Link.xh]
	cp $58
	jr nc,@gameStillGoing

	call vire_disableObjectsIfLinkIsReady
	jr nc,@gameStillGoing

	; Link reached the top
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wTmpcfc0.genericCutscene.cfd0),a
	ld a,DIR_LEFT
	ld (w1Link.direction),a
	jp interactionIncState

@gameStillGoing:
	ld h,d
	ld l,Interaction.counter2
	ld a,(hl)
	or a
	jr z,++
	dec (hl) ; [counter2]
	jr nz,++

	ld e,Interaction.direction
	xor a
	ld (de),a
	call interactionSetAnimation
++
	call interactionDecCounter1
	jr nz,@animate

	call getFreePartSlot
	jr nz,++
	ld (hl),PART_DONKEY_KONG_FLAME
	call objectCopyPosition
	ld e,Interaction.direction
	ld a,$01
	ld (de),a
	call interactionSetAnimation
	ld e,Interaction.counter2
	ld a,$18
	ld (de),a
++
	call vire_setRandomCounter1
@animate:
	jp interactionAnimate

; Fight ended
@state2:
	call interactionIncState
	ld l,Interaction.counter1
	xor a
	ldi (hl),a
	ld (hl),a ; [counter2]
	ld e,Interaction.direction
	ld a,(de)
	dec a
	call z,interactionSetAnimation
	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound

@state3:
	call interactionRunScript
	jr nc,@animate

	; Increment Zelda's state
	ld a,Object.substate
	call objectGetRelatedObject1Var
	inc (hl)

	jp interactionDelete

;;
; @param[out]	cflag	c if successfully disabled objects
vire_disableObjectsIfLinkIsReady:
	ld a,(wLinkInAir)
	or a
	ret nz
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld e,Interaction.var38
	ld (de),a

	call clearAllParentItems
	call dropLinkHeldItem
	scf
	ret

;;
vire_deleteAndReturnControl:
	call interactionDelete

;;
vire_returnControl:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ret
