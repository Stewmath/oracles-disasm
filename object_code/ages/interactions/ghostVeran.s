; ==================================================================================================
; INTERAC_GHOST_VERAN
; ==================================================================================================
interactionCode3e:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init

@subid0Init:
	ld e,Interaction.counter1
	ld a,Interaction.var38
	ld (de),a
	jp interactionSetAlwaysUpdateBit

@subid1Init:
	ld h,d
	ld l,Interaction.angle
	ld (hl),$10
	ld l,Interaction.speed
	ld (hl),SPEED_c0
	ld hl,mainScripts.ghostVeranSubid1Script
	call interactionSetScript
	call interactionSetAlwaysUpdateBit
	jp objectSetVisible81

@subid2Init:
	ld e,Interaction.speed
	ld a,SPEED_200
	ld (de),a
	ld a,SND_BEAM
	jp playSound


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw runVeranGhostSubid0
	.dw runVeranGhostSubid1
	.dw runVeranGhostSubid2


; Cutscene at start of game (unpossessing Impa)
runVeranGhostSubid0:
	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

@substate0:
	call interactionDecCounter1
	jr nz,++

	; Appear out of Impa
	ld (hl),$5a
	ld l,Interaction.angle
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),$0a
	call interactionIncSubstate
	ld a,MUS_ROOM_OF_RITES
	call playSound
	jp objectSetVisible80
++
	ld a,(wFrameCounter)
	rrca
	jp nc,objectSetVisible83
	jp objectSetVisible80

@substate1:
	call interactionDecCounter1
	jp nz,objectApplySpeed
	call interactionIncSubstate
	ld hl,mainScripts.ghostVeranSubid0Script_part1
	jp interactionSetScript

@substate2:
	ld a,($cfd1)
	or a
	jr z,++

	ldbc INTERAC_HUMAN_VERAN, $00
	call objectCreateInteraction
	ret nz

	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d
---
	call interactionIncSubstate
	ld l,Interaction.var38
	ld (hl),$78
	ld l,Interaction.var39
	inc (hl)
	xor a
	call interactionSetAnimation
	ld a,SND_TELEPORT
	jp playSound
++
	call objectGetPosition
	ld hl,$cfd5
	ld (hl),b
	inc l
	ld e,Interaction.var3d
	ld a,c
	ld (de),a
	ld (hl),a
	jp interactionRunScript

@substate3:
@substate5:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ld b,$01
	jp nz,objectFlickerVisibility

	ld l,Interaction.var39
	dec (hl)
	call interactionIncSubstate
	ld a,(hl)
	cp $04
	jp nz,objectSetVisible
	call objectSetInvisible
	ld a,SND_SWORD_OBTAINED
	jp playSound

@substate4:
	ld a,($cfd1)
	cp $02
	ret nz
	jr ---

@substate6:
	ld a,($cfd0)
	cp $12
	jr nz,+
	ld bc,$0302
	call @rumbleAndRandomizeX
	jr ++
+
	call objectGetPosition
	ld hl,$cfd5
	ld (hl),b
	inc l
	ld e,Interaction.var3d
	ld a,c
	ld (de),a
	ld (hl),a
++
	call interactionRunScript
	ret nc
	call objectSetInvisible
	jp interactionIncSubstate

;;
@rumbleAndRandomizeX:
	ld a,(wFrameCounter)
	and $0f
	ld a,SND_RUMBLE2
	call z,playSound
	call getRandomNumber
	and b
	sub c
	ld h,d
	ld l,Interaction.var3d
	add (hl)
	ld l,Interaction.xh
	ld (hl),a
	ret

@substate7:
	ld a,($cfd0)
	cp $17
	ret nz

	call interactionIncSubstate
	ld hl,mainScripts.ghostVeranSubid1Script_part2
	call interactionSetScript
	call objectSetVisible80

@substate8:
	call interactionRunScript
	ret nc
	jp interactionDelete


; Cutscene just before fighting possessed Ambi
runVeranGhostSubid1:
	ld a,(wTextIsActive)
	or a
	jr nz,+
	call interactionRunScript
	jp c,interactionDelete
+
	jp interactionAnimate


; Cutscene just after fighting possessed Ambi
runVeranGhostSubid2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld bc,$5878
	ld e,Interaction.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Interaction.xh
	ld a,(de)
	ldh (<hFF8E),a
	sub c
	inc a
	cp $03
	jr nc,++

	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jr nc,++

	call interactionIncSubstate
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ld l,Interaction.counter1
	ld (hl),$3c
	jr @animate
++
	call objectGetRelativeAngleWithTempVars
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed

@animate:
	jp interactionAnimate

@substate1:
	call interactionDecCounter1
	jr nz,@animate
	ld l,e
	inc (hl)
	ld bc,TX_560e
	jp showText

@substate2:
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMY_VERAN_FAIRY
	call objectCopyPosition
	ld e,Interaction.relatedObj2
	ld a,Enemy.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3d
	ret

@substate3:
	call interactionDecCounter1
	jr z,++

	ld a,Object.visible
	call objectGetRelatedObject2Var
	bit 7,(hl)
	jp z,objectSetVisible82
	jp objectSetInvisible
++
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	jp interactionDelete
