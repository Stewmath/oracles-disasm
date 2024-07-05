; ==================================================================================================
; INTERAC_MAKU_SEED_AND_ESSENCES
;
; Variables:
;   counter1: Essence index (for the maku seed / spawner object)
; ==================================================================================================
interactionCoded7:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interactiond7_makuSeed
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence


interactiond7_makuSeed:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	ld a,(w1Link.yh)
	sub $0e
	ld e,Interaction.yh
	ld (de),a
	ld a,(w1Link.xh)
	ld e,Interaction.xh
	ld (de),a

	call setLinkForceStateToState08

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_DROPESSENCE
	call playSound

	ldbc INTERAC_SPARKLE, $04
	call objectCreateInteraction
	ret nz
	ld l,Interaction.counter1
	ld e,l
	ld a,120
	ld (hl),a
	ld (de),a
	jp objectSetVisible82

@state1:
	ld a,LINK_ANIM_MODE_GETITEM2HAND
	ld (wcc50),a

	call interactionDecCounter1
	ret nz
	ld (hl),$40 ; [counter1]
	ld l,Interaction.speed
	ld (hl),SPEED_80
	jp interactionIncState

@state2:
	call objectApplySpeed
	call interactiond7_updateSmallSparkles
	call interactionDecCounter1
	ret nz

	ld (hl),120 ; [counter1]
	ld a,LINK_ANIM_MODE_WALK
	ld (wcc50),a
	ld l,Interaction.yh
	ld (hl),$58
	ld l,Interaction.xh
	ld (hl),$78
	ld a,SND_PIECE_OF_POWER
	call playSound
	ld a,$03
	call fadeinFromWhiteWithDelay
	jp interactionIncState

@state3:
	call interactiond7_updateSmallSparkles
	call interactiond7_updateFloating
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state3Substate0
	.dw @state3Substate1
	.dw @state3Substate2
	.dw @state3Substate3
	.dw @state3Substate4
	.dw @state3Substate5
	.dw @state3Substate6
	.dw @state3Substate7
	.dw @state3Substate8
	.dw @state3Substate9

@state3Substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),20
	inc l
	ld (hl),$08
	jp interactionIncSubstate


; Spawning the essences
@state3Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),20
	inc l
	dec (hl)
	ld b,(hl)

	; Spawn next essence
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MAKU_SEED_AND_ESSENCES
	call objectCopyPosition
	ld a,b
	ld bc,@essenceSpawnerData
	call addDoubleIndexToBc

	ld a,(bc)
	ld l,Interaction.subid
	ld (hl),a
	ld l,Interaction.angle
	inc bc
	ld a,(bc)
	ld (hl),a
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),120
	ret

; b0: subid
; b1: angle (the direction it moves out from the maku seed)
@essenceSpawnerData:
	.db $08 $1a
	.db $07 $16
	.db $06 $12
	.db $05 $0e
	.db $04 $0a
	.db $03 $06
	.db $02 $02
	.db $01 $1e


; All essences spawned. Delay before next state.
@state3Substate2:
	call interactionDecCounter1
	ret nz
	ld (hl),60 ; [counter1]
	ld a,$01
	ld (wTmpcfc0.genericCutscene.state),a
	ld a,$20
	ld (wTmpcfc0.genericCutscene.cfc1),a
	jp interactionIncSubstate


; Essences rotating & moving in
@state3Substate3:
@state3Substate5:
@state3Substate7:
	ld a,(wFrameCounter)
	and $03
	jr nz,@essenceRotationCommon
	ld hl,wTmpcfc0.genericCutscene.cfc1
	dec (hl)
	jr @essenceRotationCommon


; Essences rotating & moving out
@state3Substate4:
@state3Substate6:
	ld a,(wFrameCounter)
	and $03
	jr nz,@essenceRotationCommon
	ld hl,wTmpcfc0.genericCutscene.cfc1
	inc (hl)

@essenceRotationCommon:
	call interactionDecCounter1
	ret nz
	ld (hl),60
	jp interactionIncSubstate


; Fadeout as the essences leave the screen
@state3Substate8:
	ld hl,wTmpcfc0.genericCutscene.cfc1
	inc (hl)
	ld a,SND_FADEOUT
	call playSound
	ld a,$04
	call fadeoutToWhiteWithDelay
	jp interactionIncSubstate


; Waiting for fadeout to end
@state3Substate9:
	ld hl,wTmpcfc0.genericCutscene.cfc1
	inc (hl)
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionIncState
	inc l
	ld (hl),$00
	jp objectSetInvisible


@state4:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state4Substate0
	.dw @state4Substate1
	.dw @state4Substate2
	.dw @state4Substate3
	.dw @state4Substate4


; Modifying the room layout so only 1 door remains.
@state4Substate0:
	ld hl,@tileReplacements
--
	ldi a,(hl)
	or a
	jr z,++
	ld c,(hl)
	inc hl
	push hl
	call setTile
	pop hl
	jr --
++
	ld e,Interaction.counter1
	ld a,30
	ld (de),a
	jp interactionIncSubstate

; b0: tile position
; b1: tile index
@tileReplacements:
	.db $a3 $33
	.db $a3 $34
	.db $a3 $35
	.db $b7 $43
	.db $b7 $44
	.db $b7 $45
	.db $88 $53
	.db $88 $54
	.db $88 $55
	.db $a3 $39
	.db $a3 $3a
	.db $a3 $3b
	.db $b7 $49
	.db $b7 $4a
	.db $b7 $4b
	.db $88 $59
	.db $88 $5a
	.db $88 $5b
	.db $00


; Delay before fading back in
@state4Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),120
	ld a,$08
	call fadeinFromWhiteWithDelay
	jp interactionIncSubstate


; Fading back in
@state4Substate2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,SND_SOLVEPUZZLE_2
	call playSound
	jp interactionIncSubstate


@state4Substate3:
	call interactionDecCounter1
	ret nz
	call getThisRoomFlags
	set 6,(hl)

	; Change the door tile?
	ld hl,wRoomLayout+$47
	ld (hl),$44

	call checkIsLinkedGame
	jr z,@@unlinkedGame

	call fadeoutToBlack
	jp interactionIncSubstate

@@unlinkedGame:
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,(wActiveMusic)
	call playSound
	jp interactionDelete


; Linked game only: trigger cutscene
@state4Substate4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,CUTSCENE_FLAME_OF_SORROW
	ld (wCutsceneTrigger),a
	jp interactionDelete


interactiond7_essence:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a ; [state]
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$10
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld a,SND_POOF
	call playSound
	call objectCenterOnTile
	ld l,Interaction.z
	xor a
	ldi (hl),a
	ld (hl),a
	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	jp interactionIncState

@state2:
	ld a,(wTmpcfc0.genericCutscene.state)
	or a
	ret z
	jp interactionIncState

@state3:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	ld a,(wFrameCounter)
	rrca
	ret c
	ld h,d
	ld l,Interaction.angle
	inc (hl)
	ld a,(hl)
	and $1f
	ld (hl),a
	ld e,l
	or a
	call z,@playCirclingSound
	ld bc,$5878
	ld a,(wTmpcfc0.genericCutscene.cfc1)
	jp objectSetPositionInCircleArc

@playCirclingSound:
	ld a,SND_CIRCLING
	jp playSound

;;
interactiond7_updateSmallSparkles:
	ld a,(wFrameCounter)
	and $07
	ret nz

	ldbc INTERAC_SPARKLE, $03
	call objectCreateInteraction
	ret nz

	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld bc,@sparklePositionOffsets
	call addDoubleIndexToBc
	ld l,Interaction.yh
	ld a,(bc)
	add (hl)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	add (hl)
	ld (hl),a
	ret

@sparklePositionOffsets:
	.db $10 $02
	.db $10 $fe
	.db $08 $05
	.db $08 $fb
	.db $0c $08
	.db $0c $f8
	.db $06 $0b
	.db $06 $f5

;;
; Updates Z-position based on frame counter.
interactiond7_updateFloating:
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
	ld a,(hl)
	ld (de),a
	ret

@zPositions:
	.db $ff $fe $ff $00 $01 $02 $01 $00
