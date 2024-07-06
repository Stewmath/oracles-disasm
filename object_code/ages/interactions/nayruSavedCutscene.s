; ==================================================================================================
; INTERAC_NAYRU_SAVED_CUTSCENE
; ==================================================================================================
interactionCode6e:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw interaction6e_subid00
	.dw interaction6e_subid01
	.dw interaction6e_subid02
	.dw interaction6e_subid03
	.dw interaction6e_subid04


; Nayru waking up after being freed from possession
interaction6e_subid00:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.yh
	ld (hl),$58
	ld l,Interaction.xh
	ld (hl),$78
	ld l,Interaction.speed
	ld (hl),SPEED_40

	ld l,Interaction.oamFlagsBackup
	ld a,$01
	ldi (hl),a
	ld (hl),a
	ld (wLoadedTreeGfxIndex),a

	ld hl,w1Link.direction
	ld (hl),DIR_UP
	ld l,<w1Link.yh
	ld (hl),$64
	ld l,<w1Link.xh
	ld (hl),$78

	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld b,$10
	call clearMemory
	call setCameraFocusedObjectToLink
	call resetCamera
	ldh a,(<hActiveObject)
	ld d,a
	call fadeinFromWhite
	ld a,$0a
	call interactionSetAnimation
	call objectSetVisible82
	ld hl,mainScripts.interaction6e_subid00Script
	jp interactionSetScript

@state1:
	call interactionRunScript
	jp nc,interactionAnimate
	call interactionIncState
	ld a,$04
	jp fadeoutToWhiteWithDelay

@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,GLOBALFLAG_BEAT_POSSESSED_NAYRU
	call setGlobalFlag
	ld a,CUTSCENE_NAYRU_WARP_TO_MAKU_TREE
	ld (wCutsceneTrigger),a
	jp interactionDelete


; Queen Ambi
interaction6e_subid01:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.oamFlagsBackup
	ld a,$01
	ldi (hl),a
	ld (hl),a
	call objectSetVisiblec2
	ld hl,mainScripts.interaction6e_subid01Script_part1
	jp interactionSetScript

@state1:
	ld c,$30
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionRunScript
	jr nc,@animate

	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),244

	; Use "direction" variable temporarily as "animation"
	ld l,Interaction.direction
	ld (hl),$05
@animate
	jp interactionAnimate


; Veran circling Ambi (she's turning left and right)
@state2:
	call interactionDecCounter1
	jr z,++

	ld a,(hl)
	cp $c1
	jr nc,@animate
	and $1f
	ret nz

	ld l,Interaction.direction
	ld a,(hl)
	xor $02
	ld (hl),a
	jr @setAnimation
++
	ld l,e
	inc (hl)
	ld a,$06

@setAnimation:
	jp interactionSetAnimation


; Veran in process of possessing Ambi
@state3:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $07
	jr z,++

	; Shake X position
	ld a,(wFrameCounter)
	rrca
	ret c
	ld e,Interaction.xh
	ld a,(de)
	inc a
	and $01
	add $78
	ld (de),a
	ret
++
	call interactionIncState
	ld l,Interaction.xh
	ld (hl),$78
	ld l,Interaction.oamFlags
	ld a,$06
	ldd (hl),a
	ld (hl),a
	ld hl,mainScripts.interaction6e_subid01Script_part2
	call interactionSetScript

	ld a,SND_LIGHTNING
	call playSound
	ld a,MUS_DISASTER
	call playSound
	ld a,$04
	jp fadeinFromWhiteWithDelay


; Now finished being possessed
@state4:
	ld a,(wPaletteThread_mode)
	or a
	jr nz,++
	ld c,$30
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
++
	jp interactionAnimate


; Ghost Veran
interaction6e_subid02:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_200

	ld l,Interaction.angle
	ld (hl),$0e

	ld l,Interaction.counter1
	ld (hl),$48

	ld bc,TX_560c
	call showText

	ld a,SNDCTRL_STOPMUSIC
	call playSound

	jp objectSetVisible81


; Starting to move toward Ambi
@state1:
	ld e,Interaction.counter1
	ld a,(de)
	cp $48
	ld a,SND_BEAM
	call z,playSound
	call interactionDecCounter1
	jr nz,@applySpeedAndAnimate

	ld (hl),$ac

	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.angle
	ld (hl),$16

	; Link moves up, while facing down
	ld hl,w1Link.direction
	ld (hl),DIR_DOWN
	inc l
	ld (hl),ANGLE_UP
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$04
	ld (wLinkStateParameter),a

	ld a,SND_CIRCLING
	call playSound


; Circling around Ambi
@state2:
	call interactionDecCounter1
	jr z,@beginPossessingAmbi

	ld a,(hl)
	push af
	cp $56
	ld a,SND_CIRCLING
	call z,playSound

	pop af
	rrca
	ld e,Interaction.angle
	jr nc,++
	ld a,(de)
	dec a
	and $1f
	ld (de),a
++
	ld a,$10
	ld bc,$7e78
	call objectSetPositionInCircleArc
	jp interactionAnimate

@beginPossessingAmbi:
	ld (hl),$50

	ld l,e
	inc (hl) ; [state]++

	ld l,Interaction.speed
	ld (hl),SPEED_20
	ld l,Interaction.angle
	ld (hl),ANGLE_DOWN

	ld a,SND_BOSS_DAMAGE
	call playSound


; Moving into Ambi
@state3:
	call interactionDecCounter1
	jr nz,++
	ld a,$07
	ld (wTmpcfc0.genericCutscene.cfd0),a
	ld a,$04
	jp interactionDelete
++
	ld l,Interaction.visible
	ld a,(hl)
	xor $80
	ld (hl),a

@applySpeedAndAnimate:
	call objectApplySpeed
	jp interactionAnimate


; Ralph
interaction6e_subid03:
	ld a,(de)
	or a
	jr z,interaction6e_initRalph

interaction6e_runScriptAndAnimate:
	call interactionRunScript
	jp interactionAnimate

interaction6e_initRalph:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_200
	call objectSetVisible82
	ld hl,mainScripts.interaction6e_subid03Script
	jp interactionSetScript


; Guards that run into the room
interaction6e_subid04:
	ld a,(de)
	or a
	jr nz,interaction6e_runScriptAndAnimate

	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_180

	ld l,Interaction.yh
	ld (hl),$b0
	ld l,Interaction.xh
	ld (hl),$78
	call objectSetVisible82

	ld e,Interaction.var03
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.interaction6e_guard0Script
	.dw mainScripts.interaction6e_guard1Script
	.dw mainScripts.interaction6e_guard2Script
	.dw mainScripts.interaction6e_guard3Script
	.dw mainScripts.interaction6e_guard4Script
	.dw mainScripts.interaction6e_guard5Script
