; ==================================================================================================
; INTERAC_PIRATE
;
; Variables:
;   var3f: Push counter for subid 4 (tokay eyeball is inserted when it reached 0)
; ==================================================================================================
interactionCodec4:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init

@subid0Init:
@subid1Init:
@subid2Init:
@subid3Init:
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionInitGraphics
	call objectSetVisiblec2
	jp interactionIncState

@subid4Init:
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete

	call @resetPushCounter
	ld e,Interaction.state
	ld a,$03
	ld (de),a

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.pirateSubid0Script
	.dw mainScripts.pirateSubid1Script
	.dw mainScripts.pirateSubid2Script
	.dw mainScripts.pirateSubid3Script
	.dw mainScripts.pirateSubid4Script


; Subids 0-3: waiting for signal from piration captain to jump in excitement
@state1:
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 0,a
	jp nz,@jump
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@jump:
	ld a,$02
	call interactionSetAnimation
	ld bc,-$200
	call objectSetSpeedZ
	jp interactionIncState


; Subids 0-3: will set a signal when they're done jumping
@state2:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz
	ld hl,wTmpcfc0.genericCutscene.state
	set 1,(hl)
	jp interactionAnimate


;;
; @param[out]	cflag	c if Link is pushing up towards this object
@checkCenteredWithLink:
	ld a,(wLinkDeathTrigger)
	or a
	ret nz
	ld a,(wLinkPushingDirection)
	or a ; DIR_UP
	ret nz
	ld a,(wGameKeysPressed)
	and BTN_A | BTN_B
	ret nz
	ld b,$05
	jp objectCheckCenteredWithLink


; Subid 4: tokay eyeball slot, waiting to be put in
@state3:
	call objectCheckCollidedWithLink_notDead
	call nc,@resetPushCounter
	call @checkCenteredWithLink
	call nc,@resetPushCounter
	ld h,d
	ld l,Interaction.var3f
	dec (hl)
	jr nz,@state4

	ld a,TREASURE_TOKAY_EYEBALL
	call checkTreasureObtained
	jr c,@haveEyeball

	ld bc,TX_360d
	call showText
	jr @resetPushCounter

@haveEyeball:
	call checkLinkCollisionsEnabled
	jr nc,@resetPushCounter

	; Putting eyeball in
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld hl,mainScripts.pirateSubid4Script_insertEyeball
	call interactionSetScript

@state4:
	call interactionRunScript
	ret nc
	jp interactionDelete

@resetPushCounter:
	ld e,Interaction.var3f
	ld a,10
	ld (de),a
	ret
