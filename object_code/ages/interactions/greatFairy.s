; ==================================================================================================
; INTERAC_GREAT_FAIRY
;
; Variables:
;   var3e: ?
;   var3f: Secret index (for "linkedGameNpcScript")
; ==================================================================================================
interactionCoded5:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw greatFairy_subid0
	.dw greatFairy_subid1


; Linked game NPC
greatFairy_subid0:
	call checkInteractionState
	jr nz,@state1

@state0:
	call greatFairy_initialize
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.zh
	ld (hl),$f0
	ld l,Interaction.var3f
	ld (hl),TEMPLE_SECRET & $0f
	call interactionRunScript

@state1:
	call returnIfScrollMode01Unset
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition

	ld e,Interaction.var3e
	ld a,(de)
	or a
	ret nz
	call interactionAnimateAsNpc

	; Update Z position every 8 frames (floats up and down)
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,@zPositions
	rst_addAToHl
	ld e,Interaction.zh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@zPositions:
	.db $ff $fe $ff $00 $01 $02 $01 $00


; Cutscene after being healed from being an octorok
greatFairy_subid1:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,SND_PIECE_OF_POWER
	call playSound

	call greatFairy_initialize
	call objectSetVisiblec1
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.zh
	ld (hl),$f0
	ld l,Interaction.counter1
	ld a,180
	ldi (hl),a
	ld (hl),$02 ; [counter2]

	ldbc INTERAC_SPARKLE, $04
	call objectCreateInteraction
	ld l,Interaction.counter1
	ld (hl),120

	; Create sparkles
	ld b,$00
--
	push bc
	ldbc INTERAC_SPARKLE, $0a
	call objectCreateInteraction
	pop bc
	ld l,Interaction.angle
	ld (hl),b
	ld a,b
	add $04
	ld b,a
	bit 5,a
	jr z,--
	ret

@state1:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$40
	ld l,Interaction.angle
	ld (hl),$08
	ld l,Interaction.speed
	ld (hl),SPEED_300
	ld bc,TX_4109
	call showText
	jp interactionIncSubstate

@substate1:
	call retIfTextIsActive
	call objectApplySpeed

	; Update angle (moving in a circle)
	call interactionDecCounter2
	jr nz,@updateSparklesAndSoundEffect
	ld (hl),$02
	ld l,Interaction.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a
	call interactionDecCounter1
	jp z,interactionIncSubstate

@updateSparklesAndSoundEffect:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ldbc INTERAC_SPARKLE, $02
	call objectCreateInteraction
	ld a,(wFrameCounter)
	and $1f
	ld a,SND_MAGIC_POWDER
	call z,playSound
	ret

; Moving up out of the screen
@substate2:
	call @updateSparklesAndSoundEffect
	ld h,d
	ld l,Interaction.zh
	ld a,(hl)
	sub $02
	ld (hl),a
	cp $b0
	ret nc
	call fadeoutToWhite
	jp interactionIncSubstate

; Transition to next part of cutscene
@substate3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,CUTSCENE_CLEAN_SEAS
	ld (wCutsceneTrigger),a
	jp interactionDelete

;;
; Unused
@func_795a:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


greatFairy_initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.greatFairySubid0Script
