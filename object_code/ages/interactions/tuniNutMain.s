; ==================================================================================================
; INTERAC_TUNI_NUT
; ==================================================================================================
interactionCodeb1_body:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw tuniNut_state0
	.dw tuniNut_state1
	.dw tuniNut_state2
	.dw tuniNut_state3
	.dw objectPreventLinkFromPassing


tuniNut_state0:
	call interactionInitGraphics
	ld a,GLOBALFLAG_TUNI_NUT_PLACED
	call checkGlobalFlag
	jr nz,tuniNut_gotoState4

	ld a,TREASURE_TUNI_NUT
	call checkTreasureObtained
	jr nc,@delete
	cp $02
	jr nz,@delete

	ld bc,$0810
	call objectSetCollideRadii
	jp interactionIncState

@delete:
	jp interactionDelete


tuniNut_gotoState4:
	ld bc,$1878
	call interactionSetPosition
	ld l,Interaction.state
	ld (hl),$04
	ld a,$06
	call objectSetCollideRadius
	jp objectSetVisible82


; Waiting for Link to walk up to the object (currently invisible, acting as a cutscene trigger)
tuniNut_state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	call checkLinkCollisionsEnabled
	ret nc

	push de
	call clearAllItemsAndPutLinkOnGround
	pop de

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,(w1Link.xh)
	sub LARGE_ROOM_WIDTH<<3
	jr z,@perfectlyCentered
	jr c,@leftSide

	; Right side
	ld b,DIR_LEFT
	jr @moveToCenter

@leftSide:
	cpl
	inc a
	ld b,DIR_RIGHT

@moveToCenter:
	ld (wLinkStateParameter),a
	ld e,Interaction.counter1
	ld (de),a
	ld a,b
	ld (w1Link.direction),a
	swap a
	rrca
	ld (w1Link.angle),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	jp interactionIncState

@perfectlyCentered:
	call interactionIncState
	jr tuniNut_beginMovingIntoPlace


tuniNut_state2:
	call interactionDecCounter1
	ret nz

tuniNut_beginMovingIntoPlace:
	xor a
	ld (w1Link.direction),a

	ld e,Interaction.counter1
	ld a,60
	ld (de),a

	ldbc INTERAC_SPARKLE, $07
	call objectCreateInteraction
	ld l,Interaction.relatedObj1
	ld a,e
	ldi (hl),a
	ld a,d
	ld (hl),a

	call darkenRoomLightly
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	call objectSetVisiblec0
	jp interactionIncState


tuniNut_state3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$10
	jp interactionIncSubstate

@substate1:
	ld a,(wFrameCounter)
	rrca
	ret c
	ld h,d
	ld l,Interaction.zh
	dec (hl)
	call interactionDecCounter1
	ret nz
	call objectCenterOnTile
	jp interactionIncSubstate

@substate2:
	ld b,SPEED_40
	ld c,$00
	ld e,Interaction.angle
	call objectApplyGivenSpeed
	ld e,Interaction.yh
	ld a,(de)
	cp $18
	ret nc
	call objectCenterOnTile
	jp interactionIncSubstate

@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld a,SND_DROPESSENCE
	call playSound
	ld e,Interaction.counter1
	ld a,90
	ld (de),a
	ld a,SND_SOLVEPUZZLE_2
	call playSound
	jp interactionIncSubstate

@substate4:
	call interactionDecCounter1
	ret nz
	call brightenRoom
	jp interactionIncSubstate

@substate5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,GLOBALFLAG_TUNI_NUT_PLACED
	call setGlobalFlag

	ld a,TREASURE_TUNI_NUT
	call loseTreasure

	call @setSymmetryVillageRoomFlags

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld hl,wTmpcfc0.genericCutscene.state
	set 0,(hl)

	ld a,(wActiveMusic)
	call playSound
	jp tuniNut_gotoState4

;;
; Sets the room flags so present symmetry village is nice and cheerful now
@setSymmetryVillageRoomFlags:
	ld hl,wPresentRoomFlags+$02
	call @setRow
	ld l,$12
@setRow:
	set 0,(hl)
	inc l
	set 0,(hl)
	inc l
	set 0,(hl)
	inc l
	ret
