 m_section_free Seasons_Interactions_Bank0a NAMESPACE seasonsInteractionsBank0a

; ==============================================================================
; INTERACID_FLOODED_HOUSE_GIRL
; INTERACID_MASTER_DIVERS_WIFE
; INTERACID_S_MASTER_DIVER
; ==============================================================================
interactionCode8a:
interactionCode8b:
interactionCode8d:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld e,$41
	ld a,(de)
	cp INTERACID_S_MASTER_DIVER
	jr nz,+
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jp nc,interactionDelete
	call getHighestSetBit
	cp $02
	jp c,interactionDelete
	; master diver - at least 3rd essence gotten
+
	call getSunkenCityNPCVisibleSubId_caller
	ld e,$42
	ld a,(de)
	cp b
	jp nz,interactionDelete
	cp $01
	jr nz,@npcShouldAppear
	; 4th essence gotten
	ld e,$41
	ld a,(de)
	cp INTERACID_MASTER_DIVERS_WIFE
	jr nz,@npcShouldAppear
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ld b,<ROOM_SEASONS_05d
	jr nz,@wifeShouldAppear
	ld b,<ROOM_SEASONS_1b6
@wifeShouldAppear:
	ld a,(wActiveRoom)
	cp b
	jp nz,interactionDelete
@npcShouldAppear:
	call interactionInitGraphics
	ld e,$49
	ld a,$04
	ld (de),a
	ld e,$41
	ld a,(de)
	ld hl,@floodedHouseGirlScripts
	cp INTERACID_FLOODED_HOUSE_GIRL
	jr z,@setScript
	ld hl,@masterDiversWifeScripts
	cp INTERACID_MASTER_DIVERS_WIFE
	jr z,@setScript
	ld hl,@masterDiverScripts
@setScript:
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@floodedHouseGirlScripts:
	.dw mainScripts.floodedHouseGirlScript_text1
	.dw mainScripts.floodedHouseGirlScript_text2
	.dw mainScripts.floodedHouseGirlScript_text3
	.dw mainScripts.floodedHouseGirlScript_text4
	.dw mainScripts.floodedHouseGirlScript_text5

@masterDiversWifeScripts:
	.dw mainScripts.masterDiversWifeScript_text1
	.dw mainScripts.masterDiversWifeScript_text2
	.dw mainScripts.masterDiversWifeScript_text3
	.dw mainScripts.masterDiversWifeScript_text4
	.dw mainScripts.masterDiversWifeScript_text5

@masterDiverScripts:
	.dw mainScripts.masterDiverScript_text1
	.dw mainScripts.masterDiverScript_text2
	.dw mainScripts.masterDiverScript_text3
	.dw mainScripts.masterDiverScript_text4
	.dw mainScripts.masterDiverScript_text5


; ==============================================================================
; INTERACID_FLYING_ROOSTER
;
; Variables:
;   var30/var31: Initial position
;   var32: Y-position necessary to clear the cliff
;   var33: Counter used along with var34
;   var34: Direction chicken is hopping in (up or down; when moving back to "base"
;          position)
;   var35: X-position at which the "destination" is (Link loses control)
; ==============================================================================
interactionCode8c:
	ld e,Interaction.subid
	ld a,(de)
	bit 7,a
	jp nz,flyingRooster_subidBit7Set

	ld a,(wLinkDeathTrigger)
	or a
	jp nz,interactionAnimate

	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	ld a,$01
	ld (de),a ; [state]

	ld a,$02
	call objectSetCollideRadius

	call flyingRooster_getSubidAndInitSpeed

	; Save initial position into var30/var31
	ld e,Interaction.yh
	ld l,Interaction.var30
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.xh
	ld a,(de)
	ld (hl),a

	ld a,c
	ld hl,@subidData
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.var32
	ld (de),a
	ld e,Interaction.var35
	ld a,(hl)
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisiblec2

; b0: var32 (?)
; b1: var35 (Target x-position)
@subidData:
	.db $18 $68 ; Subid 0
	.db $08 $48 ; Subid 1


; Waiting for Link to grab
@state1:
	call interactionAnimate
	call objectAddToGrabbableObjectBuffer
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,-$100
	jp objectSetSpeedZ


; "Grabbed" state
@state2:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @state2Substate1
	.dw @state2Substate2
	.dw @releaseFromLink
	.dw @state2Substate4

@justGrabbed:
	ld a,$01
	ld (de),a ; [substate]
	ld (wDisableScreenTransitions),a
	ld (wMenuDisabled),a
	ld a,$08
	ld (wLinkGrabState2),a
	ret

@state2Substate1:
	ld a,(wLinkInAir)
	or a
	ret nz

	ld a,(wLinkGrabState)
	and $07
	cp $03
	ret nz

	ld hl,w1Link.direction
	ld (hl),$01
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a

	ld l,<w1Link.zh
	ld a,(hl)
	dec a
	ld (hl),a
	cp $f8
	ret nz
	ld a,$02
	ld (de),a
	ret


; Moving toward "base" position before continuing
@state2Substate2:
	; Calculate angle toward original position
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	inc e
	ld a,(de)
	ld c,a
	push de
	ld de,w1Link.yh
	call getRelativeAngle
	pop de
	ld e,Interaction.angle
	ld (de),a

	call flyingRooster_applySpeedAndUpdatePositions

	ld h,d
	ld l,Interaction.var30
	ldi a,(hl)
	cp b
	ret nz
	ldi a,(hl)
	cp c
	ret nz

	; Reached base position
	ld l,Interaction.enabled
	res 1,(hl)

	ld l,Interaction.substate
	ld (hl),$04

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@angles
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.angle
	ld (de),a
	xor a
	ld (wDisableScreenTransitions),a
	ret

@angles:
	.db $08 $01


@state2Substate4:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@incState

	; Subid 0 (on top of d4) only: stay in this state until reaching cliff edge.
	call flyingRooster_applySpeedAndUpdatePositions
	ld l,<w1Link.xh
	ldi a,(hl)
	cp $30
	ret c

	; Reached edge. Re-jig Link's y and z positions to make him "in the air".
	ld l,<w1Link.yh
	ld a,(hl)
	sub $68
	ld l,<w1Link.zh
	add (hl)
	ld (hl),a
	ld a,$68
	ld l,<w1Link.yh
	ld (hl),a

	ld l,<w1Link.visible
	res 6,(hl)

	ld e,Interaction.visible
	ld a,(de)
	res 6,a
	ld (de),a

@incState:
	call interactionIncState
	ret


; The state where Link can adjust the rooster's height.
@state3:
	call interactionAnimate
	call flyingRooster_applySpeedAndUpdatePositions

	; Cap y-position?
	ld l,<w1Link.yh
	ld a,(hl)
	cp $58
	jr nc,+
	inc (hl)
+
	ld l,<w1Link.xh
	ld e,Interaction.var35
	ld a,(de)
	cp (hl)
	jr c,@reachedTargetXPosition

	call flyingRooster_updateGravityAndCheckCaps
	ld a,(wGameKeysJustPressed)
	and (BTN_A|BTN_B)
	ret z

	; Set z speed based on subid
	ld bc,-$b0
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,+
	ld bc,-$d0
+
	call objectSetSpeedZ
	ld a,SND_CHICKEN
	call playSound
	jp interactionAnimate

@reachedTargetXPosition:
	call flyingRooster_getVisualLinkYPosition
	ld e,Interaction.var32
	ld a,(de)
	add $08
	cp b
	jr c,@notHighEnough

	; High enough
	ld a,$08
	ld e,Interaction.angle
	ld (de),a
	ld a,$04
	ld e,Interaction.state
	ld (de),a
	ret

@notHighEnough:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@gotoState6

	; Subid 0 only
	ld a,(wScreenTransitionBoundaryY)
	ld b,a
	ld l,<w1Link.yh
	ld a,(hl)
	sub b

	ld l,<w1Link.zh
	add (hl)
	ld (hl),a
	ld l,<w1Link.yh
	ld (hl),b

	; Create helper object to handle screen transition when Link falls
	call getFreeInteractionSlot
	ld a,INTERACID_FLYING_ROOSTER
	ldi (hl),a
	ld (hl),$80
	ld l,Interaction.enabled
	ld a,$03
	ldi (hl),a

@gotoState6:
	ld e,Interaction.state
	ld a,$06
	ld (de),a
	ld e,Interaction.counter1
	ld a,60
	ld (de),a
	ret


; Cucco stopped in place as it failed to get high enough
@state6:
	call interactionAnimate
	call interactionAnimate
	ld e,Interaction.counter1
	ld a,(de)
	dec a
	ld (de),a
	ret nz
	jp @releaseFromLink


; Lost control; moving onto cliff
@state4:
	call interactionAnimate
	call flyingRooster_applySpeedAndUpdatePositions
	ld e,Interaction.var35
	ld a,(de)
	add $20
	ld l,<w1Link.xh
	cp (hl)
	jr z,@releaseFromLink

	; Still moving toward target position
	ld a,(hl)
	and $0f
	ret nz

	; Update Link's Y/Z positions
	call flyingRooster_getVisualLinkYPosition
	add $08
	ld l,<w1Link.yh
	ld (hl),a
	ld l,<w1Link.zh
	ld a,$f8
	ld (hl),a

	ld l,<w1Link.visible
	set 6,(hl)
	ld e,Interaction.visible
	ld a,(de)
	and $bf
	ld (de),a
	ret

@releaseFromLink:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld hl,w1Link.angle
	ld a,$ff
	ld (hl),a

	ld a,$05
	ld e,Interaction.state
	ld (de),a

	ld a,$08
	ld e,Interaction.var33
	ld (de),a

	xor a
	inc e
	ld (de),a ; [var34]

	ld a,$00
	call interactionSetAnimation
	jp dropLinkHeldItem


@state5:
	call interactionAnimate
	ld e,Interaction.var33
	ld a,(de)
	dec a
	ld (de),a
	jr nz,@updateHopping

	ld a,$08
	ld (de),a ; [var33]

	inc e
	ld a,(de) ; [var34]
	xor $01
	ld (de),a
	jr @moveTowardBasePosition

@updateHopping:
	and $01
	jr nz,@moveTowardBasePosition

	ld e,Interaction.var34
	ld a,(de)
	or a
	ld e,Interaction.zh
	ld a,(de)
	jr z,@decZ

@incZ:
	inc a
	jr @setZ
@decZ:
	dec a
@setZ:
	ld (de),a

@moveTowardBasePosition:
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	inc e
	ld a,(de)
	ld c,a

	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed

	ld h,d
	ld l,Interaction.var30
	ld e,Interaction.yh
	ld a,(de)
	cp (hl)
	ret nz

	inc l
	ld e,Interaction.xh
	ld a,(de)
	cp (hl)
	ret nz

	; Reached base position
	ld l,Interaction.state
	ld (hl),$01

	ld l,Interaction.visible
	set 6,(hl)
	call flyingRooster_getSubidAndInitSpeed
	ld a,$01
	jp interactionSetAnimation

;;
; @param[out]	bc	Y/X positions for Link
flyingRooster_applySpeedAndUpdatePositions:
	ld hl,w1Link.yh
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a
	inc l
	ld e,Interaction.xh
	ld a,(hl)
	ld (de),a
	call objectApplySpeed

	ld hl,w1Link.yh
	ld e,Interaction.yh
	ld a,(de)
	ld b,a
	ldi (hl),a
	inc l
	ld e,Interaction.xh
	ld a,(de)
	ld c,a
	ld (hl),a
	ret

;;
flyingRooster_updateGravityAndCheckCaps:
	; [this.z] = [w1Link.z]
	ld l,<w1Link.z
	ld e,Interaction.z
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	ld c,$20
	call objectUpdateSpeedZ_paramC

	; [w1Link.z] = [this.z]
	ld hl,w1Link.z
	ld e,Interaction.z
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a

	call flyingRooster_getVisualLinkYPosition
	ld e,Interaction.var32
	ld a,(de)
	cp b
	jr c,@checkBottomCap

	; Cap z-position at the top
	sub b
	ld l,<w1Link.zh
	add (hl)
	ld (hl),a
	ret

@checkBottomCap:
	ld l,<w1Link.zh
	ld a,(hl)
	cp $f8
	ret c

	; Cap z-position at bottom
	ld a,$f8
	ld (hl),a
	xor a
	ld e,Interaction.speedZ
	ld (de),a
	ld e,Interaction.speedZ+1
	ld (de),a
	ret

;;
; @param[out]	a,b	Link's Y-position + Z-position
flyingRooster_getVisualLinkYPosition:
	ld l,<w1Link.yh
	ld a,(hl)
	ld l,<w1Link.zh
	add (hl)
	ld b,a
	ret


; Helper object which handles the screen transition when Link falls down
flyingRooster_subidBit7Set:
	ld hl,w1Link.zh
	ld a,(wActiveRoom)
	and $f0
	jr nz,@nextScreen

	ld a,(hl)
	or a
	ret nz

	ld l,<w1Link.yh
	inc (hl)
	ld a,$80
	ld (wLinkInAir),a
	ld a,$82
	ld (wScreenTransitionDirection),a
	ret

@nextScreen:
	ld a,(wScrollMode)
	and $0e
	ret nz

	ld (hl),$e8 ; [w1Link.zh]
	ld l,<w1Link.yh
	ld (hl),$28
	jp interactionDelete

;;
flyingRooster_getSubidAndInitSpeed:
	ld l,Interaction.subid
	ld c,(hl)
	ld l,Interaction.speed
	ld (hl),SPEED_60
	ret


; ???
interactionCode8e:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible81
@state1:
	call interactionAnimate
	call objectGetRelatedObject1Var
	ld l,$76
	ld a,(hl)
	or a
	jp z,@func_4f4c
	xor a
	ld (hl),a
	call interactionSetAnimation
@func_4f4c:
	call objectSetVisible
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jp nz,objectSetInvisible
	ret


; ==============================================================================
; INTERACID_OLD_MAN_WITH_JEWEL
;
; Variables:
;   var35: $01 if Link has at least 5 essences
; ==============================================================================
interactionCode8f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics

	ld a,>TX_3600
	call interactionSetHighTextIndex

	ld hl,mainScripts.oldManWithJewelScript
	call interactionSetScript
	call @checkHaveEssences

	ld a,$02
	call interactionSetAnimation
	jr @state1

@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@checkHaveEssences:
	ld a,(wEssencesObtained)
	call getNumSetBits
	ld h,d
	ld l,Interaction.var38
	cp $05
	ld (hl),$00
	ret c
	inc (hl)
	ret


; ==============================================================================
; INTERACID_JEWEL_HELPER
; ==============================================================================
interactionCode90:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]

	; Load script
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init
	.dw @subid7Init

@subid0Init:
	call @spawnJewelGraphics
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	ret

@subid1Init:
	call checkIsLinkedGame
	jr z,@label_0a_130
	ld e,$4b
	ld a,(de)
	sub $08
	ld (de),a
@label_0a_130:
	jr @state1

@subid3Init:
	call interactionRunScript
	call interactionRunScript

@subid4Init:
@subid5Init:
	jr @state1

@subid2Init:
	call getThisRoomFlags
	and $40
	jr z,@label_0a_131
	ret
@label_0a_131:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTABLE_TORCH
	ld l,$cb
	ld (hl),$78
	ld l,$cd
	ld (hl),$78
	ret

@subid6Init:
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	call checkIsLinkedGame
	jr nz,@label_0a_132
	ld a,$34
	ld ($ccbd),a
	ld a,$01
	ld ($ccbe),a
	jp interactionDelete
@label_0a_132:
	xor a
	ld ($ccbc),a
	inc a
	ld ($ccbb),a
	ret

@subid7Init:
	call checkIsLinkedGame
	jp z,interactionDelete
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete
	bit 5,a
	jp z,interactionDelete
	call getFreeInteractionSlot
	ret nz
	ld (hl),$60
	inc l
	ld (hl),$4d
	inc l
	ld (hl),$01
	jp objectCopyPosition

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0State1
	.dw @runScript
	.dw @runScript
	.dw @runScript
	.dw @runScript
	.dw @runScript
	.dw @subid6State1
	.dw @subid7State1

@runScript:
	call interactionRunScript
	jp c,interactionDelete
	ret

@subid0State1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid0Substate0
	.dw @subid0Substate1
	.dw @subid0Substate2
	.dw @subid0Substate3
	.dw @subid0Substate4
	.dw @subid0Substate5

; Waiting for Link to insert jewels
@subid0Substate0:
	call @checkJewelInserted
	ret nc

	ld a,(hl)
	call loseTreasure
	ld a,(hl)
	call @insertJewel

	ld a,DISABLE_LINK|DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,SND_SOLVEPUZZLE
	call playSound

	call setLinkForceStateToState08
	xor a
	ld (w1Link.direction),a

	call interactionIncSubstate
	ld hl,mainScripts.jewelHelperScript_insertedJewel
	call interactionSetScript


; Just inserted jewel
@subid0Substate1:
	call interactionRunScript
	ret nc

	ld a,(wInsertedJewels)
	cp $0f
	jr z,@insertedAllJewels
	xor a
	ld e,Interaction.substate
	ld (de),a
	ld ($cc02),a
	ld (wDisabledObjects),a
	ret

@insertedAllJewels:
	call interactionIncSubstate
	ld hl,mainScripts.jewelHelperScript_insertedAllJewels
	call interactionSetScript


; Just inserted final jewel
@subid0Substate2:
	call interactionRunScript
	ret nc
	jp interactionIncSubstate


; Gate opening
@subid0Substate3:
	ld hl,@gateOpenTiles
	ld b,$04
---
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	push hl
	push bc
	call setInterleavedTile
	pop bc
	pop hl
	dec b
	jr nz,---

	ldh a,(<hActiveObject)
	ld d,a
	call interactionIncSubstate

	ld l,Interaction.counter1
	ld (hl),30

	ld a,$00
	call @spawnGatePuffs
	ld a,SND_KILLENEMY
	call playSound

@shakeScreen:
	ld a,$06
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	jp playSound


; Gate opening
@subid0Substate4:
	call interactionDecCounter1
	ret nz
	ld hl,@gateOpenTiles
	ld b,$04
---
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	push hl
	push bc
	call setTile
	pop bc
	pop hl
	inc hl
	inc hl
	inc hl
	dec b
	jr nz,---

	call @shakeScreen
	ld a,$04
	call @spawnGatePuffs
	ld a,SND_KILLENEMY
	call playSound
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),60
	ret

@gateOpenTiles:
	.db $14 $ad $a0 $03 $15 $ad $a0 $01
	.db $24 $ad $a1 $03 $25 $ad $a1 $01


; Gates fully opened
@subid0Substate5:
	call interactionDecCounter1
	ret nz
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete


@subid6State1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
@@substate0:
	ld a,($ccbc)
	or a
	ret z
	ld a,($cc34)
	or a
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ld a,$80
	ld ($cc02),a
	ld a,$81
	ld (wDisabledObjects),a
	ret
@@substate1:
	call interactionDecCounter1
	ret nz
	ldbc INTERACID_PUFF $80
	call objectCreateInteraction
	ret nz
	ld l,$4b
	ld a,(hl)
	sub $04
	ld (hl),a
	ld a,$85
	call playSound
	call interactionIncSubstate
	ld l,$46
	ld (hl),$10
	ret
@@substate2:
	call interactionDecCounter1
	ret nz
	ld b,$e3
	call objectCreateInteractionWithSubid00
	ret nz
	ld l,$4b
	ld a,(hl)
	sub $04
	ld (hl),a
	call getThisRoomFlags
	set 5,(hl)
	jp interactionDelete

@subid7State1:
	ld a,$4d
	call checkTreasureObtained
	ret nc
	call getThisRoomFlags
	set 7,(hl)
	jp interactionDelete

;;
@spawnJewelGraphics:
	ld c,$00
@@next:
	ld hl,wInsertedJewels
	ld a,c
	call checkFlag
	jr z,++
	push bc
	call @spawnJewelGraphic
	pop bc
++
	inc c
	ld a,c
	cp $04
	jr c,@@next
	ret

;;
; @param[out]	hl	Address of treasure index?
; @param[out]	cflag	c if inserted jewel
@checkJewelInserted:
	call checkLinkID0AndControlNormal
	ret nc

	ld hl,w1Link.direction
	ldi a,(hl)
	or a
	ret nz

	ld l,<w1Link.yh
	ld a,$36
	sub (hl)
	cp $15
	ret nc

	ld l,<w1Link.xh
	ld c,(hl)
	ld hl,@jewelPositions-1

@nextJewel:
	inc hl
	ldi a,(hl)
	or a
	ret z
	add $01
	sub c
	cp $03
	jr nc,@nextJewel
	ld a,(hl)
	jp checkTreasureObtained

@jewelPositions:
	.db $24, TREASURE_ROUND_JEWEL
	.db $34, TREASURE_PYRAMID_JEWEL
	.db $6c, TREASURE_SQUARE_JEWEL
	.db $7c, TREASURE_X_SHAPED_JEWEL
	.db $00

;;
@insertJewel:
	sub TREASURE_ROUND_JEWEL
	ld c,a
	ld hl,wInsertedJewels
	call setFlag

;;
; @param	c	Jewel index
@spawnJewelGraphic:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_JEWEL
	inc l
	ld (hl),c
	ret

;;
; @param	a	Which puffs to spawn (0 or 4)
@spawnGatePuffs:
	ld bc,@puffPositions
	call addDoubleIndexToBc
	ld a,$04
---
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	inc bc
	ldh a,(<hFF8B)
	dec a
	jr nz,---
	ret

@puffPositions:
	.db $18 $48
	.db $18 $58
	.db $28 $48
	.db $28 $58
	.db $18 $40
	.db $18 $60
	.db $28 $40
	.db $28 $60

@scriptTable:
	.dw mainScripts.jewelHelperScript_insertedJewel
	.dw mainScripts.jewelHelperScript_underwaterPyramidJewel
	.dw mainScripts.jewelHelperScript_createBridgeToXJewelMoldorm
	.dw mainScripts.jewelHelperScript_XjewelMoldorm
	.dw mainScripts.jewelHelperScript_spoolSwampSquareJewel
	.dw mainScripts.jewelHelperScript_eyeglassLakeSquareJewel
	.dw mainScripts.jewelHelperScript_stub
	.dw mainScripts.jewelHelperScript_stub


; ==============================================================================
; INTERACID_JEWEL
; ==============================================================================
interactionCode92:
	call checkInteractionState
	ret nz

@state0:
	inc a
	ld (de),a ; [state] = 1

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@xPositions
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,Interaction.xh
	ld (hl),a

	ld l,Interaction.yh
	ld (hl),$2c
	call interactionInitGraphics
	jp objectSetVisible83

@xPositions:
	.db $24 $34 $6c $7c


; ==============================================================================
; INTERACID_S_MAKU_SEED
; ==============================================================================
interactionCode93:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	call checkInteractionState
	ret nz
	call @func_5298
	call objectSetVisible80
	ld a,(wc6e5)
	ld b,$04
	cp $06
	jr z,+
	cp $07
	jp nz,interactionDelete
	ld a,$01
	call interactionSetAnimation
	ld b,$08
+
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SPARKLE
	inc l
	ld (hl),$04
	call objectCopyPosition
	ld l,Interaction.yh
	ld a,(hl)
	add b
	ld (hl),a
	ret

@func_5298:
	ld a,$ab
	call loadPaletteHeader
	call interactionInitGraphics
	jp interactionIncState

@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call @func_5298
	ld l,$4b
	ld (hl),$65
	ld l,$4d
	ld (hl),$50
	ld l,$4f
	ld (hl),$8b
	ld a,$02
	call interactionSetAnimation
	ld a,(wFrameCounter)
	cpl
	inc a
	ld e,$78
	ld (de),a
	call @func_5338

@state1:
	ld h,d
	ld l,$4f
	ldd a,(hl)
	cp $ed
	jp nc,interactionDelete
	ld bc,$0080
	ld a,c
	add (hl)
	ldi (hl),a
	ld a,b
	adc (hl)
	ld (hl),a
	ld a,(wFrameCounter)
	ld l,$78
	add (hl)
	push af
	and $0f
	call z,@func_52f3
	pop af
	and $3f
	ld a,$83
	call z,playSound
	jp objectSetPriorityRelativeToLink_withTerrainEffects

@func_52f3:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SPARKLE
	inc l
	ld (hl),$03
	ld e,$4b
	ld l,$4b
	ld a,(de)
	ldi (hl),a
	inc e
	inc e
	inc l
	ld a,(de)
	ldi (hl),a
	ld e,$4f
	ld l,$4b
	call objectApplyComponentSpeed@addSpeedComponent
	call getRandomNumber
	and $07
	add a
	push de
	ld de,@table_5328
	call addAToDe
	ld a,(de)
	ld l,Interaction.yh
	add (hl)
	ld (hl),a
	inc de
	ld a,(de)
	ld l,Interaction.xh
	add (hl)
	ld (hl),a
	pop de
	ret

@table_5328:
	.db $10 $02
	.db $10 $fe
	.db $08 $05
	.db $08 $fb
	.db $0c $08
	.db $0c $f8
	.db $06 $0b
	.db $06 $f5

@func_5338:
	ldbc INTERACID_SPARKLE $08
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld a,$40
	ldi (hl),a
	ld (hl),d
	ret


; ==============================================================================
; INTERACID_GHASTLY_DOLL
; ==============================================================================
interactionCode94:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01
	ld ($cc02),a
	ld hl,$d02d
	ld a,(hl)
	or a
	ret nz
	ld a,$01
	ld (de),a
	call objectTakePosition
	ld bc,$3850
	call objectGetRelativeAngle
	and $1c
	ld e,$49
	ld (de),a
	ld bc,$ff00
	call objectSetSpeedZ
	ld l,$50
	ld (hl),$28
	call interactionInitGraphics
	ld a,($d01a)
	ld e,$5a
	ld (de),a
	ld a,$57
	jp playSound
@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	jp interactionIncState
@state2:
	ld hl,$d10b
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	ld a,(wMapleState)
	and $20
	jr z,+
	ld e,$4b
	ld a,(de)
	cp b
	jr nz,+
	ld e,$4d
	ld a,(de)
	cp c
	jr z,@func_53b6
+
	call objectGetRelativeAngle
	xor $10
	ld ($d109),a
	ret
@func_53b6:
	ld a,$ff
	ld ($d109),a
	call interactionIncState
	call objectSetInvisible
	ld a,$5e
	call playSound
	ld bc,TX_070a
	jp showText
@state3:
	ld a,$04
	ld ($cc6a),a
	ld a,$01
	ld ($cc6b),a
	ld hl,w1Link.yh
	ld bc,$f200
	call objectTakePositionWithOffset
	call interactionIncState
	ld l,$46
	ld (hl),$40
	ld l,$5b
	ld a,(hl)
	and $f8
	ldi (hl),a
	ldi (hl),a
	ld a,(hl)
	add $02
	ld (hl),a
	ld a,$03
	call interactionSetAnimation
	ld a,($d01a)
	ld e,$5a
	ld (de),a
	ld bc,TX_005c
	call showText
	ld a,TREASURE_TRADEITEM
	ld c,$02
	call giveTreasure
	ld a,$4c
	jp playSound
@state4:
	call interactionDecCounter1
	ret nz
	xor a
	ld ($cba0),a
	ld (wDisabledObjects),a
	ld a,$02
	ld ($d105),a
	jp interactionDelete


; ==============================================================================
; INTERACID_KING_MOBLIN
; ==============================================================================
interactionCode95:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
@@subid0:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_S_2d
	call setGlobalFlag
@@subid1:
@@subid2:
	call interactionInitGraphics
	ld e,$5d
	ld a,$80
	ld (de),a
	ld e,$42
	ld a,(de)
	or a
	jp nz,objectSetVisible80
	call getThisRoomFlags
	ld b,a
	xor a
	sla b
	adc $00
	sla b
	adc $00
	ld hl,table_55bf
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_MOBLIN
	inc l
	ld (hl),$01
	ld e,$57
	ld a,h
	ld (de),a
+
	call @state1@subid0@func_5517
	ld hl,objectData.objectData7ea0
	call parseGivenObjectData
	call objectSetVisible83
	xor a
	ld ($cfd0),a
	ld ($cfd1),a
	jr @state1
@@subid4:
	ld hl,mainScripts.script73cd
	call interactionSetScript
@@subid3:
	call interactionInitGraphics
	jp interactionAnimateAsNpc
@@subid5:
	ld hl,mainScripts.script73d8
	call interactionSetScript
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld a,$95
	ld (wInteractionIDToLoadExtraGfx),a
	ld a,$05
	ld ($cc1e),a
	call interactionInitGraphics
	call objectSetVisible81
	jr @state1
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
@@subid0:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	ld hl,$cfd0
	ld a,(hl)
	cp $02
	jr nz,@@@func_54ec
	ld h,d
	ld l,$45
	ld (hl),$01
	ld l,$76
	ld (hl),$00
	ld a,$39
	call playSound
	jp interactionAnimateAsNpc
@@@func_54ec:
	inc a
	jp z,interactionDelete
	call interactionRunScript
	call interactionAnimate
	call objectPreventLinkFromPassing
	ld e,$76
	ld a,(de)
	or a
	jr nz,@@@func_550e
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	ld hl,$cfc0
	ld (hl),$01
	ld h,d
	ld l,$76
	inc (hl)
	ret
@@@func_550e:
	ld e,$61
	ld a,(de)
	inc a
	ret z
	ld e,$76
	xor a
	ld (de),a
@@@func_5517:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_97
	ld bc,$0c02
	call objectCopyPositionWithOffset
	ld e,$57
	ld l,e
	ld a,(de)
	ld (hl),a
	ret
@@@substate1:
	ld e,$76
	ld a,(de)
	or a
	jr nz,@@@func_5557
	ld a,$01
	ld (de),a
	ld e,$4b
	ld a,(de)
	sub $20
	ld b,a
	ld e,$4d
	ld a,(de)
	ld c,a
	ld a,$50
	call @@@func_5547
	ld hl,mainScripts.kingMoblinScript_trapLinkInBombedHouse
	jp interactionSetScript
@@@func_5547:
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),$9f
	ld l,$46
	ldh a,(<hFF8B)
	ld (hl),a
	jp objectCopyPositionWithOffset
@@@func_5557:
	call interactionRunScript
	jp c,interactionDelete
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,$77
	ld a,(de)
	or a
	ret nz
	call interactionAnimate
	call interactionAnimate
	jr @@func_557c
@@subid1:
	jp interactionCode96@state1@subid2
@@subid2:
	call interactionAnimate
	ld hl,$cfd0
	ld a,(hl)
	inc a
	ret nz
	jp interactionDelete
@@func_557c:
	ld h,d
	ld l,$61
	ld a,(hl)
	cp $70
	ret nz
	ld (hl),$00
	jp playSound
@@subid4:
	call interactionRunScript
	jp c,interactionDelete
	ld hl,$cfc0
	bit 0,(hl)
	jr z,@@subid3
	ld a,(wFrameCounter)
	and $0f
	jr nz,@@subid3
	ld a,$70
	call playSound
@@subid3:
	jp interactionAnimateAsNpc
@@subid5:
	call interactionRunScript
	jp c,interactionDelete
	ld e,$47
	ld a,(de)
	or a
	jr z,+
	ld a,(wFrameCounter)
	and $0f
	jr nz,+
	ld a,$70
	call playSound
+
	jp interactionAnimate
table_55bf:
	; based on room flags
	.dw mainScripts.script73ab ; bit 6 and 7 both not set
	.dw mainScripts.script73b5 ; 1 of bit 6 and 7 set
	.dw mainScripts.script73bf ; both of bits 6 and 7 set


; ==============================================================================
; INTERACID_S_MOBLIN
; ==============================================================================
interactionCode96:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw objectSetVisible82
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
@@subid0:
	ld hl,table_57d0
--
	call func_57ba
	jr @state1
@@subid1:
	call objectSetVisible81
	ld hl,table_57d6
	jr --
@@subid3:
	ld a,$02
	call interactionSetAnimation
	jp objectSetVisible80
@@subid4:
	ld hl,mainScripts.script7421
	call interactionSetScript
	ld e,$43
	ld a,(de)
	or a
	jr z,+
	inc a
+
	inc a
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@@subid5:
@@subid6:
	ld e,$43
	ld a,(de)
	ld hl,table_57dc
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$43
	ld a,(de)
	ld hl,@table_5630
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$5c
	ld (de),a
	ld a,(hl)
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@table_5630:
	.db $02 $08
	.db $02 $0a
	.db $01 $02
	.db $01 $02
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
@@subid0:
@@subid1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4
	.dw @@@substate5
	.dw @@@substate6
	.dw @@@substate7
@@@substate0:
	ld hl,$cfd0
	ld a,(hl)
	cp $02
	jp z,func_5768
	inc a
	jp z,interactionDelete
	call interactionRunScript
	ld e,$42
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	ld e,$47
	ld a,(de)
	or a
	call nz,interactionAnimate
	ld e,$71
	ld a,(de)
	or a
	jr z,+
	xor a
	ld (de),a
	ld bc,TX_3801
	call showText
+
	call interactionAnimate
	jp objectPreventLinkFromPassing
@@@substate1:
	call interactionAnimate
	call interactionAnimate
	call interactionDecCounter1
	jp nz,objectApplyComponentSpeed
	ld a,$08
	call setLinkIDOverride
	ld l,$02
	ld (hl),$09
	jp interactionIncSubstate
@@@substate2:
	ld hl,$cfd1
	ld a,(hl)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionIncSubstate
	ld l,$42
	ld a,(hl)
	add $0b
	jp interactionSetAnimation
@@@substate3:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	jp interactionIncSubstate
@@@substate4:
	ld e,$42
	ld a,(de)
	inc a
	ld b,a
	ld hl,$cfd1
	ld a,(hl)
	cp b
	jp nz,npcFaceLinkAndAnimate
	call interactionIncSubstate
	ld l,$50
	ld (hl),$28
	ld l,$4d
	ld a,(hl)
	cp $50
	jr z,@@@func_56fe
	ld a,$18
	jr nc,+
	ld a,$08
+
	ld e,$49
	ld (de),a
	call convertAngleDeToDirection
	jp interactionSetAnimation
@@@substate5:
	call objectApplySpeed
	cp $50
	jr nz,+
	call interactionIncSubstate
	ld l,$46
	ld (hl),$05
+
	call interactionAnimate
	jp interactionAnimate
@@@substate6:
	call interactionDecCounter1
	jp nz,interactionAnimate
@@@func_56fe:
	ld l,$45
	ld (hl),$07
	ld l,$49
	ld (hl),$10
	ld a,$02
	jp interactionSetAnimation
@@@substate7:
	call interactionAnimate
	call interactionAnimate
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
	ld hl,$cfd1
	ld e,$42
	ld a,(de)
	add $02
	ld (hl),a
	jp interactionDelete
@@subid2:
	call interactionAnimate
	call checkInteractionSubstate
	jr nz,+
	call interactionDecCounter1
	ret nz
	ld l,$50
	ld (hl),$50
	jp interactionIncSubstate
+
	call interactionAnimate
	call interactionCode95@state1@func_557c
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
	jp interactionDelete
@@subid3:
	call interactionAnimate
	ld hl,$cfd0
	ld a,(hl)
	inc a
	ret nz
	jp interactionDelete
@@subid4:
@@subid5:
@@subid6:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc
func_5768:
	call interactionIncSubstate
	ld l,$46
	ld (hl),$20
	ld l,$4b
	ld a,(hl)
	ld b,a
	ld hl,w1Link.yh
	ld a,(hl)
	sub b
	call func_57ad
	ld h,d
	ld l,$50
	ld (hl),c
	inc l
	ld (hl),b
	ld l,$4d
	ld a,(hl)
	ld b,a
	ld hl,w1Link.xh
	ld a,(hl)
	ld c,a
	ld e,$42
	ld a,(de)
	or a
	ld a,$0c
	jr nz,+
	ld a,$f4
+
	add c
	sub b
	call func_57ad
	ld h,d
	ld l,$52
	ld (hl),c
	inc l
	ld (hl),b
	call objectGetAngleTowardLink
	ld e,$49
	ld (de),a
	call convertAngleDeToDirection
	dec e
	ld (de),a
	jp interactionSetAnimation
func_57ad:
	ld b,a
	ld c,$00
	ld a,$05
-
	sra b
	rr c
	dec a
	jr nz,-
	ret
func_57ba:
	push hl
	call getThisRoomFlags
	ld b,a
	xor a
	sla b
	adc $00
	sla b
	adc $00
	pop hl
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript
table_57d0:
	.dw mainScripts.script73f3
	.dw mainScripts.script73f3
	.dw mainScripts.script73f3
table_57d6:
	.dw mainScripts.script73f6
	.dw mainScripts.script73f6
	.dw mainScripts.script73f6
table_57dc:
	.dw mainScripts.script7443
	.dw mainScripts.script7456
	.dw mainScripts.script7469
	.dw mainScripts.script7469


; moblin house-related?
interactionCode97:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible83
@state1:
	ld hl,$cfd0
	ld a,(hl)
	inc a
	jp z,interactionDelete
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
@substate0:
	ld hl,$cfd0
	ld a,(hl)
	cp $02
	ret z
	call interactionAnimate
	ld hl,$cfc0
	bit 1,(hl)
	ret z
	call interactionIncSubstate
	call objectSetVisible81
@func_581d:
	push de
	ld h,d
	ld l,$57
	ld a,(hl)
	ld d,a
	ld bc,$0301
	call objectCopyPositionWithOffset
	pop de
	ret
@substate1:
	ld hl,$cfc0
	bit 3,(hl)
	jr z,+
	call interactionIncSubstate
	ld l,$49
	ld (hl),$10
	ld l,$50
	ld (hl),$14
	ld bc,$fe80
	call objectSetSpeedZ
+
	jr @func_581d
@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	jp interactionDelete


; ==============================================================================
; INTERACID_S_OLD_MAN_WITH_RUPEES
; ==============================================================================
interactionCode99:
	call checkInteractionState
	jr nz,@state1
	inc a
	ld (de),a
	call interactionInitGraphics
	ld a,>TX_1f00
	call interactionSetHighTextIndex
	ld e,$42
	ld a,(de)
	ld hl,table_587b
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld h,d
	ld l,$4b
	ld (hl),$38
	ld l,$4d
	ld (hl),$80
@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
table_587b:
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_givesRupees
	.dw mainScripts.oldManScript_takesRupees
	.dw mainScripts.oldManScript_takesRupees
	.dw mainScripts.oldManScript_takesRupees


; same room as moblin rest house - event when moblin house explodes?
interactionCode9a:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	cp $02
	jr z,@@subid2
	call interactionInitGraphics
	jp objectSetVisible82
@@subid2:
	ld a,($cc36)
	or a
	jp z,interactionDelete
	xor a
	ld ($cc36),a
	ld a,GLOBALFLAG_DESTROYED_MOBLIN_HOUSE_REPAIRED
	call unsetGlobalFlag
	call getThisRoomFlags
	rlca
	jr nc,@bit7NotSet
	ld a,GLOBALFLAG_DESTROYED_MOBLIN_HOUSE_REPAIRED
	call setGlobalFlag
	xor a
	ld hl,$d100
	ld (hl),a
	ld l,$1a
	ld (hl),a
	push de
	ld de,@table_59e4
	call @func_59ba
	pop de
	; INTERACID_9a
	ld e,$42
	ld a,$03
	ld (de),a
	ld a,$b9
	jr ++
@bit7NotSet:
	call getThisRoomFlags
	call func_5b49@func_5b65
	ld c,(hl)
	ld a,$03
	ld b,$aa
	call getRoomFlags
	ld (hl),c
	ld a,$b4
++
	ld h,d
	ld l,$70
	ld (hl),a
	ld a,$01
	ld (wDisabledObjects),a
	ld ($cc02),a
	ld l,$46
	ld (hl),$5a
	ret
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw state1_subid3
@@subid0:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	ret z
	inc a
	jp z,interactionDelete
	xor a
	ld (de),a
	ld e,$43
	ld a,(de)
	or a
	ret z
	dec a
	ld hl,table_5a5e
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	push de
	ld b,(hl)
	inc hl
-
	ld c,(hl)
	inc hl
	ldi a,(hl)
	push bc
	push hl
	call setTile
	pop hl
	pop bc
	dec b
	jr nz,-
	pop de
	call getRandomNumber_noPreserveVars
	and $03
	add $02
	ld c,a
	ld b,$04
--
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_9a
	inc l
	ld (hl),$01
	ld a,b
	add a
	add a
	add a
	add c
	and $1f
	ld l,$49
	ld (hl),a
	call getRandomNumber
	and $03
	push hl
	ld hl,@@table_5972
	rst_addAToHl
	ld a,(hl)
	pop hl
	ld l,$50
	ld (hl),a
	ld bc,$fe80
	call objectSetSpeedZ
	call objectCopyPosition
	dec b
	jr nz,--
	ret
@@table_5972:
	.db $3c $46 $50 $5a
@@subid1:
	call objectApplySpeed
	ld c,$28
	call objectUpdateSpeedZ_paramC
	jp z,interactionDelete
	ret
@@subid2:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
@@@substate0:
	call returnIfScrollMode01Unset
	ld a,$01
	ld e,$45
	ld (de),a
	ret
@@@substate1:
	ld h,d
	ld l,$70
	dec (hl)
	jr nz,@@@substate2
	ld l,$45
	inc (hl)
	push de
	ld de,@table_59d8
	call @func_59ba
	pop de
@@@substate2:
	xor a
	call func_5a82
	ret nz
	ld hl,$cc69
	res 1,(hl)
	xor a
	ld (wDisabledObjects),a
	ld ($cc02),a
	jp interactionDelete

;;
; @param	de	Pointer to Interaction code to create 3 times
@func_59ba:
	ld b,$03
--
	call getFreeInteractionSlot
	jr nz,@ret
	ld a,(de)
	inc de
	ldi (hl),a
	ld a,(de)
	inc de
	ld (hl),a
	ld l,$4b
	ld a,(de)
	inc de
	ldi (hl),a
	inc l
	ld a,(de)
	inc de
	ld (hl),a
	ld l,$46
	ld (hl),$0a
	dec b
	jr nz,--
@ret:
	ret

@table_59d8:
	.db INTERACID_KING_MOBLIN, $01 $40 $78
	.db INTERACID_S_MOBLIN,    $02 $48 $68
	.db INTERACID_S_MOBLIN,    $02 $48 $88

@table_59e4:
	.db INTERACID_KING_MOBLIN, $02 $68 $78
	.db INTERACID_S_MOBLIN,    $03 $60 $58
	.db INTERACID_S_MOBLIN,    $03 $40 $58

state1_subid3:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	call returnIfScrollMode01Unset
	ld a,$01
	ld e,$45
	ld (de),a
	ret
@substate1:
	ld h,d
	ld l,$70
	dec (hl)
	jr nz,+
	ld l,$45
	inc (hl)
	call fadeoutToWhite
+
	xor a
	jp func_5a82
@substate2:
	ld a,($c4ab)
	or a
	ret nz
	ldh (<hSprPaletteSources),a
	dec a
	ldh (<hDirtySprPalettes),a
	ld ($cfd0),a
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ld hl,w1Link.yh
	ld a,$40
	ldi (hl),a
	inc l
	ld (hl),$50
	ld a,$80
	ld ($d01a),a
	ld a,$02
	ld ($d008),a
	call setLinkForceStateToState08
	push de
	call hideStatusBar
	pop de
	ld c,$02
	jpab bank1.loadDeathRespawnBufferPreset
@substate3:
	call interactionDecCounter1
	ret nz
	ld a,$03
	ld ($cc6a),a
	xor a
	ld (wLinkHealth),a
	jp interactionDelete
table_5a5e:
	; tile replacement tables
	; position - tiletype
	.dw @5a6a
	.dw @5a6d
	.dw @5a70
	.dw @5a73
	.dw @5a78
	.dw @5a7d
@5a6a:
	.db $01
	.db $36 $fd
@5a6d:
	.db $01
	.db $48 $fc
@5a70:
	.db $01
	.db $56 $fd
@5a73:
	.db $02
	.db $57 $fb
	.db $58 $fd
@5a78:
	.db $02
	.db $37 $fd
	.db $38 $fc
@5a7d:
	.db $02
	.db $46 $fb
	.db $47 $fd
func_5a82:
	ld h,d
	ld e,Interaction.counter1
	ld l,e
	dec (hl)
	ret nz
	ld hl,table_5ac4
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	; counter2
	inc e
	ld a,(de)
	add a
	rst_addDoubleIndex
	ld e,Interaction.counter1
	ldi a,(hl)
	ld (de),a
	inc a
	ret z

	; counter2 += 1 (next entry in the table next)
	inc e
	ld a,(de)
	inc a
	ld (de),a

	push de
	ld d,h
	ld e,l
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_9a
	inc l
	ld (hl),$00
	inc l
	ld a,(de)
	inc de
	ld (hl),a
	ld l,$4b
	ld a,(de)
	ldi (hl),a
	inc de
	inc l
	ld a,(de)
	ld (hl),a
	ld a,$6f
	call playSound
	ld a,$08
	call setScreenShakeCounter
++
	pop de
	or $01
	ret
table_5ac4:
	.dw @5ac8
	.dw @5ae1
@5ac8:
	; 0 - into counter1 (time to create next entry)
	; 1 - into new interaction $9a00 var03
	; 2 - into new interaction $9a00 yh
	; 3 - into new interaction $9a00 xh
	.db $14 $01 $3a $68
	.db $14 $02 $46 $8a
	.db $10 $03 $56 $6a
	.db $10 $04 $58 $86
	.db $0c $05 $32 $7e
	.db $0c $06 $48 $73
	.db $ff
@5ae1:
	.db $0a $00 $58 $80
	.db $0a $00 $18 $38
	.db $0a $00 $48 $30
	.db $0a $00 $28 $68
	.db $0a $00 $68 $60
	.db $0a $00 $38 $40
	.db $0a $00 $58 $80
	.db $0a $00 $18 $20
	.db $0a $00 $48 $30
	.db $0a $00 $28 $68
	.db $0a $00 $68 $60
	.db $0a $00 $38 $40
	.db $ff


; spawned inside King Moblin rest house - explosions?
interactionCode9b:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	xor a
	ld ($cfd0),a
	ld ($cfd1),a
@state1:
	ld a,($cfd0)
	cp $02
	jr nz,func_5b49
	ld hl,$cfd1
	ld a,(hl)
	cp $03
	ret nz
	ld ($cc02),a
	ld hl,$cc63
	ld a,$80
	ldi (hl),a
	ld a,$6f
	ldi (hl),a
	ld a,$0f
	ldi (hl),a
	ld a,$55
	ldi (hl),a
	ld (hl),$03
	jp interactionDelete
func_5b49:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	ld a,($cfd0)
	or a
	ret z
	xor a
	ld ($cbb3),a
	dec a
	ld ($cbba),a
	jp interactionIncSubstate
@func_5b65:
	bit 6,a
	set 6,(hl)
	ret z
	res 6,(hl)
	set 7,(hl)
	ret
@substate1:
	ld hl,$cbb3
	ld b,$02
	call flashScreen
	ret z
	ld hl,$cfd0
	ld (hl),$ff
	push de
	call hideStatusBar
	call clearItems
	pop de
	xor a
	ld ($d01a),a
	call clearPaletteFadeVariablesAndRefreshPalettes
	ld a,$ff
	ldh (<hDirtyBgPalettes),a
	ldh (<hBgPaletteSources),a
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ret
@substate2:
	ld a,$01
	call func_5a82
	ret nz
	ld a,$40
	ld (w1Link.yh),a
	ld a,$50
	ld (w1Link.xh),a
	ld a,$80
	ld ($d01a),a
	ld a,$02
	ld ($d008),a
	call setLinkForceStateToState08
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ld c,$02
	jpab bank1.loadDeathRespawnBufferPreset
@substate3:
	call interactionDecCounter1
	ret nz
	ld a,GLOBALFLAG_DESTROYED_MOBLIN_HOUSE_REPAIRED
	call unsetGlobalFlag
	call getThisRoomFlags
	call @func_5b65
	ld c,(hl)
	ld a,>ROOM_SEASONS_06f
	ld b,<ROOM_SEASONS_06f
	call getRoomFlags
	ld (hl),c
	ld a,$03
	ld ($cc6a),a
	xor a
	ld (wLinkHealth),a
	jp interactionDelete


; ==============================================================================
; INTERACID_SPRINGBLOOM_FLOWER
; ==============================================================================
interactionCode9c:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
@state0:
	ld a,$01
	ld (de),a
	ld a,($cc4e)
	or a
	jp nz,interactionDelete
	ld a,$06
	call objectSetCollideRadius
	call interactionInitGraphics
	call objectSetVisible83
@state1:
	ld a,($ccc3)
	or a
	jr z,+
	ld a,$05
	jr ++
+
	ld a,($cc88)
	or a
	ret nz
	ld a,($cc48)
	rrca
	ret c
	call objectCheckCollidedWithLink
	ret nc
	ld a,$02
	ld ($ccc3),a
++
	ld e,$44
	ld (de),a
	ld a,$01
	jp interactionSetAnimation
@state2:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	ret z
	ld a,($cc48)
	cp $d0
	jp nz,seasonsFunc_0a_5d18
	call checkLinkID0AndControlNormal
	jp nc,seasonsFunc_0a_5d18
	call objectCheckCollidedWithLink
	jp nc,seasonsFunc_0a_5d18
	ld e,$44
	ld a,$03
	ld (de),a
	call clearAllParentItems
	call dropLinkHeldItem
	call resetLinkInvincibility
	ld a,$83
	ld (wDisabledObjects),a
	ld ($cc88),a
	call setLinkForceStateToState08
	call interactionSetAlwaysUpdateBit
	xor a
	ld e,$61
	call func_5cf2
	ld e,$4d
	ld a,(de)
	ld (w1Link.xh),a
	xor a
	ld ($d00f),a
	ld a,$52
	call playSound
	ld a,$02
	jp interactionSetAnimation
@state3:
	ld a,$10
	ld ($cc6b),a
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	jr z,@func_5ca0
	cp $02
	call nc,func_5cf2
	ret
@func_5ca0:
	ld a,$06
	call func_5cf2
	xor a
	ld (wDisabledObjects),a
	ld e,$44
	ld a,$04
	ld (de),a
	ld a,$06
	ld ($cc6a),a
	jp objectSetVisible83
@state4:
@state7:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	jr seasonsFunc_0a_5d18
@state5:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	ret z
	ld a,$52
	call playSound
	call interactionIncState
	ld a,$02
	jp interactionSetAnimation
@state6:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	jr nz,@func_5ce8
	ld (de),a
	ld ($ccc3),a
	call objectSetVisible83
	jp interactionIncState
@func_5ce8:
	dec a
	ld ($ccc3),a
	cp $02
	ret c
	jp objectSetVisible82
func_5cf2:
	ld hl,table_5d08
	rst_addDoubleIndex
	xor a
	ld (de),a
	ld e,$4b
	ld a,(de)
	add (hl)
	ld (w1Link.yh),a
	inc hl
	ld e,$5a
	ld a,(de)
	and $f0
	or (hl)
	ld (de),a
	ret
table_5d08:
	; yh - xh
	.db $f9 $03
	.db $f9 $03
	.db $f8 $03
	.db $f9 $01
	.db $fa $01
	.db $ff $01
	.db $f0 $01
	.db $00 $01

seasonsFunc_0a_5d18:
	ld e,$44
	ld a,$01
	ld (de),a
	dec a
	ld ($ccc3),a
	call interactionSetAlwaysUpdateBit
	res 7,(hl)
	call objectSetVisible83
	ld a,$00
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_IMPA
; ==============================================================================
interactionCode9d:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call interactionInitGraphics
	call objectSetVisible82
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
@@subid0:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jp c,interactionDelete
	call getThisRoomFlags
	and $40
	jr nz,@@func_5d73
	ld a,$1f
	call playSound
	ld a,($cc62)
	ld (wActiveMusic),a
	jr ++
@@func_5d73:
	ld h,d
	ld l,$4b
	ld (hl),$28
	inc l
	inc l
	ld (hl),$18
	ld l,$42
	ld (hl),$01
++
	ld hl,mainScripts.impaScript_afterOnoxTakesDin
	jr @@setScript
@@subid1:
	call checkZeldaVillagersSeenButNoMakuSeed
	jp nz,interactionDelete
	call checkGotMakuSeedDidNotSeeZeldaKidnapped_body
	jp nz,interactionDelete
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jr z,+
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp z,interactionDelete
+
	call checkIsLinkedGame
	jr z,@@func_5db1
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jp z,@@func_5db1
	ld a,$0c
	jr @@func_5dd5
@@func_5db1:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	call getHighestSetBit
	jr @@func_5dd5
@@subid2:
	call checkZeldaVillagersSeenButNoMakuSeed
	jp z,interactionDelete
	ld a,$03
	ld e,$7b
	ld (de),a
	call interactionSetAnimation
	ld a,$08
	jr @@func_5dd5
@@subid3:
	call checkGotMakuSeedDidNotSeeZeldaKidnapped_body
	jp z,interactionDelete
	ld a,$09
@@func_5dd5:
	ld hl,table_5ec8
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
@@setScript:
	jp interactionSetScript
@@subid4:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jp nc,interactionDelete
	and $02
	jp z,interactionDelete
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jp nz,interactionDelete
	ld bc,$ff00
	call objectSetSpeedZ
	ld hl,simulatedInput_5ec3
	ld a,:simulatedInput_5ec3
	push de
	call setSimulatedInputAddress
	pop de
	ld hl,w1Link.yh
	ld (hl),$76
	inc l
	inc l
	ld (hl),$56
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_S_BIRD
	inc l
	ld (hl),$0a
	ld l,$56
	ld (hl),$40
	inc l
	ld (hl),d
	call objectCopyPosition
++
	call objectSetInvisible
	call interactionSetAlwaysUpdateBit
	ld a,$0a
	ld ($cc02),a
	jr @@func_5dd5
@@subid5:
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,$0b
	jr @@func_5dd5
@state1:
	call interactionRunScript
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@faceLinkAndAnimate
	.dw @@animateAsNPC
	.dw @@subid3
	.dw @@subid4
	.dw @@faceLinkAndAnimate
@@subid0:
	call checkInteractionSubstate
	jr nz,++
	inc a
	ld (de),a
	ld a,$08
	call setLinkIDOverride
	ld l,$02
	ld (hl),$02
	ld l,$0b
	ld (hl),$48
	ld l,$0d
	ld (hl),$58
	ld l,$08
	ld (hl),$00
++
	call getThisRoomFlags
	and $40
	jr z,+
	ld e,$42
	ld a,$01
	ld (de),a
+
	call interactionAnimate
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
@@faceLinkAndAnimate:
	jp npcFaceLinkAndAnimate
@@subid3:
	ld a,GLOBALFLAG_TALKED_TO_ZELDA_BEFORE_ONOX_FIGHT
	call checkGlobalFlag
	jp nz,npcFaceLinkAndAnimate
@@animateAsNPC:
	jp interactionAnimateAsNpc
@@subid4:
	call checkInteractionSubstate
	jr nz,func_5eb1
	ld a,($cbc3)
	rlca
	ret nc
	xor a
	ld ($cbc3),a
	inc a
	ld (wDisabledObjects),a
	call interactionIncSubstate
	jp objectSetVisible
func_5eb1:
	ld a,($cba0)
	or a
	call nz,seasonsFunc_0a_6710
	call interactionAnimateAsNpc
	ld e,$47
	ld a,(de)
	or a
	jp nz,interactionAnimate
	ret
simulatedInput_5ec3:
	dwb 32 BTN_UP
	.dw $ffff
table_5ec8:
	; for subid1, if Zelda Kidnapped not seen,
	; the rest are indexed by highest essence count
	.dw mainScripts.impaScript_after1stEssence
	.dw mainScripts.impaScript_after2ndEssence
	.dw mainScripts.impaScript_after3rdEssence
	.dw mainScripts.impaScript_after4thEssence
	.dw mainScripts.impaScript_after5thEssence
	.dw mainScripts.impaScript_after6thEssence
	.dw mainScripts.impaScript_after7thEssence
	.dw mainScripts.impaScript_after8thEssence
	.dw mainScripts.impaScript_villagersSeenButNoMakuSeed ; mainScripts.subid2
	.dw mainScripts.impaScript_gotMakuSeedDidntSeeZeldaKidnapped ; mainScripts.subid3
	.dw mainScripts.impaScript_askingToSaveZelda; mainScripts.subid4
	.dw mainScripts.impaScript_askedToSaveZeldaButHavent ; mainScripts.subid5
	.dw mainScripts.impaScript_afterZeldaKidnapped ; subid1 - zelda kidnapped mainScripts.seen


; ==============================================================================
; INTERACID_SAMASA_DESERT_GATE
; ==============================================================================
interactionCode9e:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld bc,table_604d
	ld l,$7b
	ld (hl),b
	inc hl
	ld (hl),c
	ret
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
@substate0:
	call func_5f8c
	ld e,$79
	ld a,(de)
	cp $ff
	ret nz
	call interactionIncSubstate
	ld l,$7d
	ld (hl),$28
	ld a,$81
	ld (wDisabledObjects),a
	ld a,$80
	ld ($cc02),a
	ld hl,mainScripts.script7556
	jp interactionSetScript
@substate1:
	call func_5f87
	ret nz
	call interactionIncSubstate
	ld l,$7d
	ld (hl),$78
	ld a,$b8
	jp playSound
@substate2:
	call func_606a
	call func_5f87
	ret nz
	call interactionIncSubstate
	ld l,$7d
	ld (hl),$01
	ret
@substate3:
	call interactionRunScript
	call func_606a
	call func_5f87
	ret nz
	call func_602c
	jr z,@func_5f67
	ld h,d
	ld l,$7d
	ld (hl),$32
	ld a,$6f
	jp playSound
@func_5f67:
	call interactionIncSubstate
	ld l,$7d
	ld (hl),$28
	ret
@substate4:
	call func_5f87
	ret nz
	xor a
	ld ($cc02),a
	ld (wDisabledObjects),a
	ld a,$4d
	call playSound
	call getThisRoomFlags
	set 7,(hl)
	jp interactionDelete
func_5f87:
	ld h,d
	ld l,$7d
	dec (hl)
	ret
func_5f8c:
	call func_5fcd
	jr z,++
	call checkLinkID0AndControlNormal
	ret nc
	ld a,($cc46)
	bit 6,a
	jr z,func_5fa3
	ld c,$01
	ld b,$b0
	jp func_5fba
func_5fa3:
	ld a,($cc45)
	bit 6,a
	ret nz
++
	ld h,d
	ld l,$78
	ld a,$00
	cp (hl)
	ret z
	ld c,$00
	ld b,$b1
	call func_5fba
	jp func_6001
func_5fba:
	ld h,d
	ld l,$78
	ld (hl),c
	ld a,$13
	ld l,$79
	add (hl)
	ld c,a
	ld a,b
	call setTile
	ld a,$70
	jp playSound

func_5fcd:
	ld hl,table_5ff4
	ld a,(w1Link.yh)
	ld c,a
	ld a,(w1Link.xh)
	ld b,a
--
	; bc is xh, yh
	ldi a,(hl)
	or a
	ret z
	add $04
	sub c
	cp $09
	jr nc,+
	ldi a,(hl)
	add $03
	sub b
	cp $07
	jr nc,++
	ld a,(hl)
	ld e,$79
	ld (de),a
	or d
	ret
+
	inc hl
++
	inc hl
	jr --

table_5ff4:
	; Byte 0: yh of door
	; Byte 1: xh of door
	; Byte 2: door index for checking later
	.db $20 $38 $00
	.db $20 $48 $01
	.db $20 $58 $02
	.db $20 $68 $03
	.db $00

func_6001:
	ld h,d
	ld l,$7a
	ld a,(hl)
	ld bc,table_6024
	call addAToBc
	ld a,(bc)
	ld b,a
	ld l,$79
	ld a,(hl)
	ld l,$7a
	cp b
	jr nz,func_601c
	ld a,(hl)
	cp $07
	jr z,func_601f
	inc (hl)
	ret

func_601c:
	ld (hl),$00
	ret

func_601f:
	ld l,$79
	ld (hl),$ff
	ret

table_6024:
	; order of samasa gate-pushing
	.db $02 $02 $01 $00
	.db $00 $03 $03 $03

func_602c:
	ld e,$7b
	ld a,(de)
	ld h,a
	inc de
	ld a,(de)
	ld l,a
--
	ldi a,(hl)
	or a
	jr z,@func_6044
	cp $ff
	jr z,@ret
	ld c,a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	jr --
@func_6044:
	ld e,$7b
	ld a,h
	ld (de),a
	inc e
	ld a,l
	ld (de),a
	or d
@ret:
	ret

table_604d:
	; pairs of tile location - tile to replace with
	.db $03 TILEINDEX_SAND
	.db $13 TILEINDEX_COLLAPSING_SAMASA_GATE
	.db $00

	.db $13 TILEINDEX_SAND
	.db $04 TILEINDEX_SAND
	.db $14 TILEINDEX_COLLAPSING_SAMASA_GATE
	.db $00

	.db $14 TILEINDEX_SAND
	.db $05 TILEINDEX_SAND
	.db $15 TILEINDEX_COLLAPSING_SAMASA_GATE
	.db $00

	.db $15 TILEINDEX_SAND
	.db $06 TILEINDEX_SAND
	.db $16 TILEINDEX_COLLAPSING_SAMASA_GATE
	.db $00

	.db $16 TILEINDEX_SAND
	.db $ff

func_606a:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,$02
	jp setScreenShakeCounter


; ==============================================================================
; INTERACID_MOVING_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea1:
	call sidescrollPlatform_checkLinkOnPlatform
	call @updateSubid
	jp sidescrollingPlatformCommon

@updateSubid:
	ld e,Interaction.state
	ld a,(de)
	sub $08
	jr c,@state0To7
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw movingPlatform_stateC

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.movingSidescrollPlatformScriptTable
.else
	ld hl,bank0d.movingSidescrollPlatformScriptTable
.endif
	call objectLoadMovementScript
	call interactionInitGraphics
	ld e,Interaction.direction
	ld a,(de)
	ld hl,@collisionRadii
	rst_addDoubleIndex
	ld e,Interaction.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld e,Interaction.direction
	ld a,(de)
	call interactionSetAnimation
	jp objectSetVisible82

@collisionRadii:
	.db $09 $0f
	.db $09 $17
	.db $19 $07
	.db $19 $0f
	.db $09 $07

@state8:
	ld e,Interaction.var32
	ld a,(de)
	ld h,d
	ld l,Interaction.yh
	cp (hl)
	jr nc,+
	jp objectApplySpeed
+
	ld a,(de)
	ld (hl),a
	jp sidescrollPlatformFunc_5bfc

@state9:
	ld e,Interaction.xh
	ld a,(de)
	ld h,d
	ld l,Interaction.var33
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_RIGHT
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jp objectApplySpeed
++
	ld a,(hl)
	ld (de),a
	jp sidescrollPlatformFunc_5bfc

@stateA:
	ld e,Interaction.yh
	ld a,(de)
	ld h,d
	ld l,Interaction.var32
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_DOWN
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jp objectApplySpeed
++
	ld a,(hl)
	ld (de),a
	jp sidescrollPlatformFunc_5bfc

@stateB:
	ld e,Interaction.var33
	ld a,(de)
	ld h,d
	ld l,Interaction.xh
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_LEFT
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jp objectApplySpeed
++
	ld a,(de)
	ld (hl),a
	jp sidescrollPlatformFunc_5bfc


movingPlatform_stateC:
	call interactionDecCounter1
	ret nz
	jp sidescrollPlatformFunc_5bfc


; ==============================================================================
; INTERACID_MOVING_SIDESCROLL_CONVEYOR
; ==============================================================================
interactionCodea2:
	call interactionAnimate
	call sidescrollPlatform_checkLinkOnPlatform
	call nz,sidescrollPlatform_updateLinkKnockbackForConveyor
	call @updateState
	jp sidescrollingPlatformCommon

@updateState:
	ld e,Interaction.state
	ld a,(de)
	sub $08
	jr c,@state0To7
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw movingPlatform_stateC

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.movingSidescrollConveyorScriptTable
.else
	ld hl,bank0d.movingSidescrollConveyorScriptTable
.endif
	call objectLoadMovementScript
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),$08
	inc l
	ld (hl),$0c
	ld e,Interaction.direction
	ld a,(de)
	call interactionSetAnimation
	jp objectSetVisible82

@state8:
	ld e,Interaction.var32
	ld a,(de)
	ld h,d
	ld l,Interaction.yh
	cp (hl)
	jr c,@applySpeed
	ld a,(de)
	ld (hl),a
	jp sidescrollPlatformFunc_5bfc

@state9:
	ld e,Interaction.xh
	ld a,(de)
	ld h,d
	ld l,Interaction.var33
	cp (hl)
	jr c,@applySpeed
	ld a,(hl)
	ld (de),a
	jp sidescrollPlatformFunc_5bfc

@stateA:
	ld e,Interaction.yh
	ld a,(de)
	ld h,d
	ld l,Interaction.var32
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_DOWN
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jr @applySpeed
++
	ld a,(hl)
	ld (de),a
	jp sidescrollPlatformFunc_5bfc

@stateB:
	ld e,Interaction.var33
	ld a,(de)
	ld h,d
	ld l,Interaction.xh
	cp (hl)
	jr c,@applySpeed
	ld a,(de)
	ld (hl),a
	jp sidescrollPlatformFunc_5bfc

@applySpeed:
	call objectApplySpeed
	ld a,(wLinkRidingObject)
	cp d
	ret nz

	ld e,Interaction.angle
	ld a,(de)
	rrca
	rrca
	ld b,a
	ld e,Interaction.direction
	ld a,(de)
	add b
	ld hl,@directions
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,a
	ld b,(hl)
	jp updateLinkPositionGivenVelocity

@directions:
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_100
	.db ANGLE_LEFT,  SPEED_060
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_060
	.db ANGLE_LEFT,  SPEED_100


; ==============================================================================
; INTERACID_DISAPPEARING_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea3:
	ld e,Interaction.state
	ld a,(de)
	cp $03
	jr z,++

	; Only do this if the platform isn't invisible
	call sidescrollPlatform_checkLinkOnPlatform
	call sidescrollingPlatformCommon
++
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
	ld hl,@subidData
	rst_addDoubleIndex

	ld e,Interaction.state
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.counter1
	ld a,(hl)
	ld (de),a

	ld e,Interaction.collisionRadiusY
	ld a,$08
	ld (de),a
	inc e
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jp z,objectSetVisible83
	ret

@subidData:
	.db $04,  60
	.db $03, 120
	.db $01,  60

@state1:
	call sidescrollPlatform_decCounter1
	ret nz
	ld (hl),30
	ld l,e
	inc (hl)
	xor a
	ret

@state2:
	call sidescrollPlatform_decCounter1
	jr nz,@flickerVisibility
	ld (hl),150
	ld l,e
	inc (hl)
	jp objectSetInvisible

@flickerVisibility
	ld e,Interaction.visible
	ld a,(de)
	xor $80
	ld (de),a
	ret

@state3:
	call @state1
	ret nz
	ld a,SND_MYSTERY_SEED
	jp playSound

@state4:
	call sidescrollPlatform_decCounter1
	jr nz,@flickerVisibility
	ld (hl),120
	ld l,e
	ld (hl),$01
	jp objectSetVisible83


;;
; Used by:
; * INTERACID_DISAPPEARING_SIDESCROLL_PLATFORM
sidescrollingPlatformCommon:
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	call objectCheckCollidedWithLink
	ret nc

	; Platform has collided with Link.

	call sidescrollPlatform_checkLinkIsClose
	jr c,@label_0b_183
	call sidescrollPlatform_getTileCollisionBehindLink
	jp z,sidescrollPlatform_pushLinkAwayHorizontal

	call sidescrollPlatform_checkLinkSquished
	ret c

	ld e,Interaction.yh
	ld a,(de)
	ld b,a
	ld a,(w1Link.yh)
	cp b
	ld c,ANGLE_UP
	jr nc,@moveLinkAtAngle
	ld c,ANGLE_DOWN
	jr @moveLinkAtAngle

@label_0b_183:
	call sidescrollPlatformFunc_5b51
	ld a,(hl)
	or a
	jp z,sidescrollPlatform_pushLinkAwayVertical

	call sidescrollPlatform_checkLinkSquished
	ret c
	ld a,(wLinkRidingObject)
	cp d
	jr nz,@label_0b_184
	ldh a,(<hFF8B)
	cp $03
	jr z,@label_0b_184

	push af
	call sidescrollPlatform_pushLinkAwayVertical
	pop af
	rrca
	jr ++

@label_0b_184:
	ld e,Interaction.xh
	ld a,(de)
	ld b,a
	ld a,(w1Link.xh)
	cp b
++
	ld c,ANGLE_RIGHT
	jr nc,@moveLinkAtAngle
	ld c,ANGLE_LEFT

;;
; @param	c	Angle
@moveLinkAtAngle:
	ld b,SPEED_80
	jp updateLinkPositionGivenVelocity

;;
; @param[out]	cflag	c if Link got squished
sidescrollPlatform_checkLinkSquished:
	ld h,d
	ld l,Interaction.collisionRadiusY
	ld a,(hl)
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	sub (hl)
	add b
	cp c
	ret nc

	ld l,Interaction.collisionRadiusX
	ld a,(hl)
	add $02
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	sub (hl)
	add b
	cp c
	ret nc

	xor a
	ld l,Interaction.angle
	bit 3,(hl)
	jr nz,+
	inc a
+
	ld (wcc50),a
	ld a,LINK_STATE_SQUISHED
	ld (wLinkForceState),a
	scf
	ret

;;
; @param[out]	cflag	c if Link's close enough to the platform?
sidescrollPlatform_checkLinkIsClose:
	ld a,(wLinkInAir)
	or a
	ld b,$05
	jr z,+
	dec b
+
	ld h,d
	ld l,Interaction.collisionRadiusX
	ld a,(hl)
	add b

	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	sub (hl)
	add b
	cp c
	ret nc

	ld l,Interaction.collisionRadiusY
	ld a,(hl)
	sub $02
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	sub (hl)
	add b
	cp c
	ccf
	ret

;;
; @param[out]	a	Collision value
; @param[out]	zflag	nz if a valid collision value is returned
sidescrollPlatform_getTileCollisionBehindLink:
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	cp (hl)
	ld b,-$05
	jr c,+
	ld b,$04
+
	add b
	ld c,a
	ld a,(w1Link.yh)
	sub $04
	ld b,a
	call getTileCollisionsAtPosition
	ret nz
	ld a,b
	add $08
	ld b,a
	jp getTileCollisionsAtPosition

;;
; @param[out]	hl
sidescrollPlatformFunc_5b51:
	ld h,d
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	cp (hl)
	ld b,-$06
	jr c,+
	ld b,$09
+
	add b
	ld b,a
	ld a,(w1Link.xh)
	sub $03
	ld c,a
	call getTileCollisionsAtPosition
	ld hl,hFF8B
	ld (hl),$00
	jr z,+
	set 1,(hl)
+
	ld a,c
	add $05
	ld c,a
	call getTileCollisionsAtPosition
	ld hl,hFF8B
	ret z
	inc (hl)
	ret

;;
; Checks if Link's on the platform, updates wLinkRidingObject if so.
;
; @param[out]	zflag	nz if Link is standing on the platform
sidescrollPlatform_checkLinkOnPlatform:
	call objectCheckCollidedWithLink
	jr nc,@notOnPlatform

	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	ld l,Interaction.collisionRadiusY
	sub (hl)
	sub $02
	ld b,a
	ld a,(w1Link.yh)
	cp b
	jr nc,@notOnPlatform

	call sidescrollPlatform_checkLinkIsClose
	jr nc,@notOnPlatform

	ld e,Interaction.var34
	ld a,(de)
	or a
	jr nz,@onPlatform
	ld a,$01
	ld (de),a
	call sidescrollPlatform_updateLinkSubpixels

@onPlatform:
	ld a,d
	ld (wLinkRidingObject),a
	xor a
	ret

@notOnPlatform:
	ld e,Interaction.var34
	ld a,(de)
	or a
	ret z
	ld a,$00
	ld (de),a
	ret

;;
sidescrollPlatform_updateLinkKnockbackForConveyor:
	ld e,Interaction.angle
	ld a,(de)
	bit 3,a
	ret z

	ld hl,w1Link.knockbackAngle
	ld e,Interaction.direction
	ld a,(de)
	swap a
	add $08
	ld (hl),a
	ld l,<w1Link.invincibilityCounter
	ld (hl),$fc
	ld l,<w1Link.knockbackCounter
	ld (hl),$0c
	ret

;;
; @param[out]	hl	counter1
sidescrollPlatform_decCounter1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

;;
sidescrollPlatform_pushLinkAwayVertical:
	ld hl,w1Link.collisionRadiusY
	ld e,Interaction.collisionRadiusY
	ld a,(de)
	add (hl)
	ld b,a
	ld l,<w1Link.yh
	ld e,Interaction.yh
	jr +++

;;
sidescrollPlatform_pushLinkAwayHorizontal:
	ld hl,w1Link.collisionRadiusX
	ld e,Interaction.collisionRadiusX
	ld a,(de)
	add (hl)
	ld b,a
	ld l,<w1Link.xh
	ld e,Interaction.xh
+++
	ld a,(de)
	cp (hl)
	jr c,++
	ld a,b
	cpl
	inc a
	ld b,a
++
	ld a,(de)
	add b
	ld (hl),a
	ret

;;
sidescrollPlatformFunc_5bfc:
	call objectRunMovementScript
	ld a,(wLinkRidingObject)
	cp d
	ret nz

;;
sidescrollPlatform_updateLinkSubpixels:
	ld e,Interaction.y
	ld a,(de)
	ld (w1Link.y),a
	ld e,Interaction.x
	ld a,(de)
	ld (w1Link.x),a
	ret


; ==============================================================================
; INTERACID_SUBROSIAN_SMITHY
; ==============================================================================
interactionCodea4:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,$49
	ld (hl),$04
	ld a,>TX_3b00
	call interactionSetHighTextIndex
	call @func_6418
	ld hl,mainScripts.subrosianSmithyScript
	call interactionSetScript
	call interactionAnimateAsNpc
	ld a,$02
	call interactionSetAnimation
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc
@func_6418:
	ld a,TREASURE_PIRATES_BELL
	call checkTreasureObtained
	jr nc,+
	or a
	ld a,$01
	jr z,smithyLoadIntoVar3f
+
	ld a,TREASURE_HARD_ORE
	call checkTreasureObtained
	jr nc,+
	ld a,$02
	jr smithyLoadIntoVar3f
	
+
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr nz,+
	ld a,$00
	jr smithyLoadIntoVar3f
+
	ld a,$03

smithyLoadIntoVar3f:
	; $00 if none of the below
	; $01 if rusty bell
	; $02 if hard ore
	; $03 if finished game
	ld e,$7f
	ld (de),a
	ret


; ==============================================================================
; INTERACID_S_DIN
; ==============================================================================
interactionCodea5:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw dinState0
	.dw dinState1
dinState0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subidStub
	.dw @subid4
	.dw @subidStub
	.dw @subid6
	.dw @subid7
	.dw @subid8
	.dw @subid9
@subid0:
	ld h,d
	ld l,$4b
	ld (hl),$00
	inc l
	inc l
	ld (hl),$a0
	ld l,$66
	ld (hl),$20
	inc l
	ld (hl),$08
	ld l,$49
	ld (hl),$10
	ld l,$50
	ld (hl),$14
	jp setCameraFocusedObject
@subid1:
	ld h,d
	ld l,$4b
	ld (hl),$98
	inc l
	inc l
	ld (hl),$a0
	ret
@subid2:
	ld hl,mainScripts.dinScript_subid2Init
	jp interactionSetScript
@subid4:
	ld hl,mainScripts.dinScript_subid4Init
	jp interactionSetScript
@subid6:
	ld h,d
	ld l,$4b
	ld (hl),$48
	inc l
	inc l
	ld (hl),$80
@subidStub:
	ret
@subid7:
	ld hl,mainScripts.dinScript_stubInit
	jp interactionSetScript
@subid8:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,$06
	call interactionSetAnimation
	ld a,INTERACID_S_DIN
	ld (wInteractionIDToLoadExtraGfx),a
	ld (wLoadedTreeGfxIndex),a
	ld hl,mainScripts.dinScript_subid8Init
	jp interactionSetScript
@subid9:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
	ld hl,mainScripts.dinScript_discoverLinkCollapsed
	jp interactionSetScript

dinState1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw dinState1_subid0
	.dw dinState1_subid0@ret
	.dw dinState1_subid2
	.dw dinState1_subid3
	.dw dinState1_subid4
	.dw interactionAnimate
	.dw dinState1_subid6
	.dw dinState1_subid7
	.dw dinState1_subid8
	.dw dinState1_subid9

dinState1_subid0:
	ld e,$45
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
@substate0:
	call interactionAnimate
	ld a,(wFrameCounter)
	and $0f
	call z,@func_6521
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $90
	ret nz
	call interactionIncSubstate
	xor a
	ld (wDisabledObjects),a
	inc a
	ld ($ccab),a
	jp setCameraFocusedObjectToLink
@func_6521:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SPARKLE
	inc l
	ld (hl),$05
	call getRandomNumber
	and $1f
	sub $10
	ld b,$00
	ld c,a
	jp objectCopyPositionWithOffset
@substate1:
	call objectOscillateZ
	call objectPreventLinkFromPassing
	ld c,$20
	call objectCheckLinkWithinDistance
	jp nc,interactionAnimate
	ld a,(wLinkInAir)
	or a
	ret nz
	call interactionIncSubstate
	ld a,$80
	ld (wDisabledObjects),a
	ld l,$46
	ld (hl),$32
	ld l,$4d
	ldd a,(hl)
	ld (hl),a
	ld hl,$d008
	ld (hl),$03
	call setLinkForceStateToState08
@ret:
	ret
@substate2:
	call interactionDecCounter1
	jr nz,@func_6576
	call interactionIncSubstate
	ld hl,$cbb3
	ld (hl),$00
	ld hl,$cbba
	ld (hl),$ff
	ret
@func_6576:
	call getRandomNumber_noPreserveVars
	and $03
	sub $02
	ld h,d
	ld l,$4c
	add (hl)
	inc l
	ld (hl),a
	jp interactionAnimate
@substate3:
	ld hl,$cbb3
	ld b,$01
	call flashScreen
	ret z
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ld b,$04
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_DINS_CRYSTAL_FADING
	inc l
	ld (hl),b
	dec (hl)
	call objectCopyPosition
	dec b
	jr nz,-
+
	ld a,$05
	call interactionSetAnimation
	ld a,$8a
	call playSound
	jp clearPaletteFadeVariablesAndRefreshPalettes
@substate4:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,$50
	ld (hl),$28
	ld l,$60
	ld (hl),$01
	jp interactionAnimate
@substate5:
	call objectApplySpeed
	ld h,d
	ld l,$4b
	ld a,(hl)
	sub $98
	ret nz
	call interactionIncSubstate
	ld l,$4f
	ld (hl),a
	ld l,$60
	ld (hl),$01
	jp interactionAnimate
@substate6:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	ret z
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	jp npcFaceLinkAndAnimate
@substate7:
	call interactionDecCounter1
	ret nz
	ld a,$01
	ld ($cfdf),a
	ret

dinState1_subid2:
	ld a,($c4ab)
	or a
	ret nz
	call interactionAnimate
	jp interactionRunScript

dinState1_subid3:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
@substate0:
	ld a,($cfc0)
	or a
	jr z,+
	call interactionIncSubstate
	ld bc,$ff00
	call objectSetSpeedZ
+
	jp interactionAnimate
@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0a
	ret
@substate2:
	call interactionDecCounter1
	ret nz
	ld a,$06
	jp interactionSetAnimation

dinState1_subid4:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
@substate0:
	ld a,($c4ab)
	or a
	ret nz
	call interactionAnimate
	call interactionRunScript
	ret nc
	ld bc,$ff20
	call objectSetSpeedZ
	ld l,$49
	ld (hl),$08
	ld l,$50
	ld (hl),$37
	jp interactionIncSubstate
@substate1:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,$60
	ld (hl),$20
@substate2:
	jp interactionAnimate

dinState1_subid6:
	call objectOscillateZ
	jp interactionAnimate

dinState1_subid7:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw interactionAnimate
@substate0:
	call interactionAnimate
	ld a,($cfc0)
	cp $04
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$78
	ld a,$08
	call interactionSetAnimation
	jp seasonsFunc_0a_6717
@substate1:
	call interactionDecCounter1
	jp nz,seasonsFunc_0a_6710
	call interactionIncSubstate
	xor a
	ld l,$4f
	ld (hl),a
	ld l,$46
	ld (hl),$1e
	jp interactionAnimate
@substate2:
	call interactionDecCounter1
	jr nz,+
	call interactionIncSubstate
	ld l,$46
	ld (hl),$3c
	ld bc,TX_3d09
	call showText
+
	jp interactionAnimate
@substate3:
	ld a,($cba0)
	or a
	jr nz,+
	call interactionDecCounter1
	jr nz,+
	call interactionIncSubstate
	ld hl,$cfc0
	ld (hl),$05
+
	jp interactionAnimate
	
dinState1_subid8:
	call interactionRunScript
	ld e,$78
	ld a,(de)
	or a
	call z,interactionAnimate
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
	
dinState1_subid9:
	ld e,$78
	ld a,(de)
	bit 7,a
	jr nz,+
	and $7f
	call nz,interactionAnimate
	call interactionAnimate
+
	call interactionRunScript
	ret nc
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call setGlobalFlag
	ld hl,@warpDestVariables
	jp setWarpDestVariables

@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_097 $00 $44 $83

seasonsFunc_0a_6710:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
seasonsFunc_0a_6717:
	ld bc,$ff00
	jp objectSetSpeedZ


; ==============================================================================
; INTERACID_DINS_CRYSTAL_FADING
; ==============================================================================
interactionCodea6:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$42
	ld a,(hl)
	add a
	add a
	add a
	add $04
	; angles are $04, $0c, $14, $1c
	ld l,Interaction.angle
	ld (hl),a
	ld l,$50
	ld (hl),$64
	ld l,$46
	ld (hl),$08
	jp objectSetVisible81
@state1:
	ld e,$45
	ld a,(de)
	or a
	jr nz,@substate1
	call interactionDecCounter1
	jr nz,@applySpeedTwice
	call interactionIncSubstate
	ld l,$46
	ld (hl),$14
@applySpeedTwice:
	call objectApplySpeed
	jp objectApplySpeed
@substate1:
	call interactionDecCounter1
	jp z,interactionDelete
	ld a,(wFrameCounter)
	xor d
	rrca
	ld l,$5a
	set 7,(hl)
	jr nc,@applySpeedTwice
	res 7,(hl)
	jr @applySpeedTwice


; ==============================================================================
; INTERACID_ENDGAME_CUTSCENE_BIPSOM_FAMILY
; ==============================================================================
interactionCodea7:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics
	call objectSetVisible82

	ld e,Interaction.subid
	ld a,(de)
	cp $02
	ret nz

	ld a,(wChildStage)
	cp $04
	ret c

	ld a,$04
	call interactionSetAnimation
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_CHILD
	inc l
	ld a,(wChildStage)
	ld b,$00
	cp $07
	jr c,+
	ld b,$03
+
	ld a,(wChildPersonality)
	add b
	ldi (hl),a ; [child.subid]
	add $16
	ld (hl),a
	ld l,Interaction.yh
	ld (hl),$38
	inc l
	inc l
	ld (hl),$28
	ret

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wTmpcfc0.genericCutscene.state)
	or a
	jr z,++
	call interactionIncSubstate
	ld bc,-$100
	call objectSetSpeedZ
++
	jp interactionAnimate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),10
	ret

@substate2:
	call interactionDecCounter1
	ret nz
	ld a,$03
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_a8
; ==============================================================================
interactionCodea8:
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
@subid1:
@subid2:
@subid3:
	ld a,(de)
	and $0f
	add SPECIALOBJECTID_RICKY_CUTSCENE
	ld b,a
	ld a,(de)
	swap a
	and $0f
	ld hl,w1Companion.enabled
	ld (hl),$01
	inc l
	ld (hl),b ; [w1Companion.id]
	inc l
	ld (hl),a ; [w1Companion.subid]
	call objectCopyPosition
	jp interactionDelete

@subid4:
	ld hl,w1Link.enabled
	ld (hl),$03
	call objectCopyPosition
	call @handleSubidHighNibble
	jp interactionDelete

@handleSubidHighNibble:
	ld e,$42
	ld a,(de)
	swap a
	and $0f
	ld b,a
	rst_jumpTable
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4
	.dw @thing5

@thing0:
	ld hl,simulatedInput_6869
	ld a,:simulatedInput_6869

@beginSimulatedInput:
	push de
	call setSimulatedInputAddress
	pop de
	xor a
	ld (wDisabledObjects),a
	ld hl,w1Link.id
	ld (hl),SPECIALOBJECTID_LINK
	ret

@thing1:
@thing2:
@thing3:
@thing4:
	ld a,b
	add $02
	ld hl,w1Link.id
	ld (hl),SPECIALOBJECTID_LINK_CUTSCENE
	inc l
	ld (hl),a
	ret

@thing5:
	ld a,d
	ld (wLinkObjectIndex),a
	ld hl,wActiveRing
	ld (hl),FIST_RING
	xor a
	ld l,<wInventoryB
	ldi (hl),a
	ld (hl),a

	ld hl,simulatedInput_6874
	ld a,:simulatedInput_6874

	jp @beginSimulatedInput

simulatedInput_6869:
	dwb 60 $00
	dwb 32 BTN_DOWN
	dwb 48 $00
	.dw $ffff

simulatedInput_6874:
	dwb 124 $00
	dwb 1   BTN_LEFT
	dwb 46  $00
	dwb 1   BTN_DOWN
	dwb 46  $00
	dwb 1   BTN_RIGHT
	dwb 46  $00
	dwb 1   BTN_UP
	dwb 46  $00
	dwb 1   BTN_LEFT
	dwb 46  $00
	dwb 1   BTN_DOWN
	dwb 104 $00
	dwb 1   BTN_UP
	dwb 56  $00
	dwb 1   BTN_RIGHT
	dwb 464 $00
	dwb 1   BTN_LEFT
	dwb 160 $00
	dwb 1   BTN_A
	dwb 48  $00
	.dw $ffff


; Similar to a9, possibly endgame cutscene people
interactionCodea9:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld e,$50
	ld a,$1e
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisiblec0

@state1:
	call interactionAnimate
	ld e,$42
	ld a,(de)
	cp $02
	ret z
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	ld a,($cfc0)
	or a
	ret z
	call interactionIncSubstate
	ld l,$42
	ld a,(hl)
	add a
	inc a
	jp interactionSetAnimation

@substate1:
	ld a,($cfc0)
	cp $02
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0a
	ret

@substate2:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld bc,$ff00
	jp objectSetSpeedZ

@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$50
	ret

@substate4:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,$42
	ld a,(hl)
	cp $01
	ld a,$04
	jr z,+
	xor a
+
	ld l,$49
	ld (hl),a
	ret

@substate5:
	ld e,$42
	ld a,(de)
	cp $01
	jr z,@applySpeed
	cp $04
	jr z,@applySpeed
	cp $05
	ret nz

@applySpeed:
	jp objectApplySpeed


; Impa, Zelda, Nayru?
interactionCodeaa:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	ld e,$42
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp objectSetVisible82
@state1:
	call interactionAnimate
	jp interactionRunScript
@scriptTable:
	.dw mainScripts.script769f
	.dw mainScripts.script76ad
	.dw mainScripts.script76b7
	.dw mainScripts.script76dc


; ==============================================================================
; INTERACID_MOBLIN_KEEP_SCENES
; ==============================================================================
interactionCodeab:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,>TX_3f00
	call interactionSetHighTextIndex
	ld e,$42
	ld a,(de)
	ld hl,moblinKeepScene_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,(wLinkObjectIndex)
	cp $d0
	jr z,+
	ld a,($d10d)
	jr ++
+
	ld a,(w1Link.xh)
++
	cp $3d
	jp c,interactionDelete
	ld a,$00
	call moblinKeepScene_spawnKingMoblin
@subid1:
	jp @state1
@subid2:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,interactionDelete
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	call setDeathRespawnPoint
@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret

moblinKeepScene_setLinkDirectionAndPositionAfterDestroyed:
	ld a,LINK_STATE_08
	ld (wLinkForceState),a
	ld hl,w1Link.direction
	ld (hl),DIR_DOWN
	ld l,<w1Link.yh
	ld (hl),$18
	ld l,<w1Link.xh
	ld (hl),$48
	ret

moblinKeepScene_spawnKingMoblin:
	add a
	ld bc,@kingMoblinSpawnData
	call addDoubleIndexToBc
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_KING_MOBLIN
	inc l
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4d
	ld a,(bc)
	ld (hl),a
	ret

@kingMoblinSpawnData:
	; subid - yh - xh - unused
        .db $03 $60 $24 $00
        .db $04 $50 $48 $00

moblinKeepScene_spawn2MoblinsAfterKeepDestroyed:
	ld bc,@moblinSpawnData
	ld e,$02
--
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_S_MOBLIN
	inc l
	ld (hl),$04
	inc l
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4d
	ld a,(bc)
	ld (hl),a
	inc bc
	inc bc
	dec e
	jr nz,--
	ret
@moblinSpawnData:
	; var03 - yh - xh
	.db $00 $56 $28 $00
	.db $01 $56 $68 $00

moblinKeepScene_scriptTable:
	.dw mainScripts.moblinKeepSceneScript_linkSeenOnRightSide
	.dw mainScripts.moblinKeepSceneScript_settingUpFight
	.dw mainScripts.moblinKeepSceneScript_postKeepDestruction


; some misc NPCs during endgame cutscene
interactionCodead:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectGetAngleTowardLink
	ld e,$49
	ld (de),a
	ld hl,mainScripts.script779e
	call interactionSetScript
	ld e,$42
	ld a,(de)
	ld hl,@table_6a67
	rst_addAToHl
	ld a,(hl)
	ld e,$76
	ld (de),a
	ld bc,$ff40
	call objectSetSpeedZ
	jp objectSetVisible82
@table_6a67:
	.db $10 $20 $18 $28 $08
@state1:
	ld e,$42
	ld a,(de)
	and $01
	call nz,func_6ae7
	call interactionAnimateAsNpc
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
@substate0:
	ld a,($c4ab)
	or a
	ret nz
	ld h,d
	ld l,$76
	dec (hl)
	ret nz
	jp interactionIncSubstate
@substate1:
	ld a,($cfc0)
	cp $01
	jr nz,+
	call interactionIncSubstate
	ld bc,$fe80
	jp objectSetSpeedZ
+
	ld e,$46
	ld a,(de)
	or a
	call nz,interactionAnimate
	jp interactionRunScript
@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$08
	ld l,$49
	ld a,(hl)
	add $10
	and $1f
	ld (hl),a
	ld l,$50
	ld (hl),$50
	ld l,$42
	ld a,(hl)
	add a
	inc a
	jp interactionSetAnimation
@substate3:
	call interactionDecCounter1
	ret nz
	ld l,$46
	ld (hl),$40
	jp interactionIncSubstate
@substate4:
	call interactionDecCounter1
	jp z,interactionDelete
	call objectApplySpeed
	call interactionAnimate
	jp interactionAnimateAsNpc
func_6ae7:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,$ff40
	jp objectSetSpeedZ


; ==============================================================================
; INTERACID_CREDITS_TEXT_HORIZONTAL
;
; Variables:
;   var03: ?
;   var30: ?
;   var31: ?
;   var32: ?
;   var33: ?
; ==============================================================================
interactionCodeae:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr nz,@var03Nonzero

	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	ld hl,horizontalCreditsText_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call creditsTextHorizontal_6559

	ld e,Interaction.subid
	ld a,(de)
	ld hl,horizontalCreditsText_65b1
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.var32
	ld (de),a
	ldi a,(hl)
	ld e,Interaction.counter2
	ld (de),a
	ret

@var03Nonzero:
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.var30
	ld (hl),$14
	ld l,Interaction.speed
	ld (hl),SPEED_200

	ld l,Interaction.counter2
	ld a,(hl)
	call interactionSetAnimation

	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	or a
	ld bc,$f018
	jr z,+
	ld bc,$0008
+
	ld l,Interaction.xh
	ld (hl),b
	ld l,Interaction.angle
	ld (hl),c
	jp objectSetVisible82

@state1:
	ld a,$01
	ld (de),a ; [state]
	ld e,Interaction.var03
	ld a,(de)
	or a
	jp nz,horizontalCreditsText_var03Nonzero

	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.var30
	call decHlRef16WithCap
	ret nz
	call creditsTextHorizontal_6537

@func_6457:
	ld e,Interaction.var30
	ld a,(de)
	rlca
	ret nc

	ld b,$01
	rlca
	jr nc,+
	ld b,$02
+
	ld h,d
	ld l,Interaction.counter1
	ld (hl),180
	ld l,Interaction.substate
	ld (hl),b
	ret

@substate1:
	ld e,Interaction.var33
	ld a,(de)
	rst_jumpTable
	.dw @subsubstate0
	.dw @subsubstate1
	.dw @subsubstate2
	.dw @subsubstate3

@subsubstate0:
	call interactionDecCounter1
	ret nz
	ld h,d
	ld l,Interaction.var33
	inc (hl)
	ret

@subsubstate1:
	ld a,(wFrameCounter)
	and $03
	ret nz

	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	cp $10
	jr nz,@label_0b_234

	ld l,Interaction.var33
	inc (hl)

	ld l,Interaction.scriptPtr
	ld a,(hl)
	sub $03
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	call creditsTextHorizontal_6554
	ld h,d
	ld l,Interaction.counter1
	ld (hl),30
	ret

@label_0b_234:
	ld a,($ff00+R_SVBK)
	push af
	ld l,Interaction.counter1
	ld a,(hl)
	ld b,a
	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a
	ld a,b
	ld hl,w4TileMap
	rst_addDoubleIndex
	ld b,$30
@loop:
	xor a
	ldi (hl),a
	ld (hl),a
	ld a,$1f
	rst_addAToHl
	dec b
	jr nz,@loop

	push de
	ld a,UNCMP_GFXH_09
	call loadUncompressedGfxHeader
	pop de
	pop af
	ld ($ff00+R_SVBK),a

	ld h,d
	ld l,Interaction.counter1
	inc (hl)
	ret

@subsubstate2:
	call interactionDecCounter1
	ret nz
	ld l,Interaction.var33
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),$10
	ret

@subsubstate3:
	ld a,(wFrameCounter)
	and $03
	ret nz
	call interactionDecCounter1
	jr nz,@label_0b_236

	xor a
	ld l,Interaction.substate
	ld (hl),a
	ld l,Interaction.var33
	ld (hl),a
	jp @func_6457

@label_0b_236:
	push de
	ld a,($ff00+R_SVBK)
	push af
	ld a,(hl) ; [counter1]
	ld b,a

	ld a,b
	ld hl,w4TileMap
	rst_addDoubleIndex
	ld a,b
	ld de,w3VramTiles
	call addDoubleIndexToDe
	ld b,$30
@tileLoop:
	push bc
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	ld a,(de)
	ld b,a
	inc de
	ld a,(de)
	ld c,a
	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a
	ld (hl),b
	inc hl
	ld (hl),c
	ld a,$1f
	ld c,a
	rst_addAToHl
	ld a,c
	call addAToDe
	pop bc
	dec b
	jr nz,@tileLoop

	ld a,UNCMP_GFXH_09
	call loadUncompressedGfxHeader
	pop af
	ld ($ff00+R_SVBK),a
	pop de
	ret

@substate2:
	call interactionDecCounter1
	ret nz
.ifdef ROM_AGES
	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld (hl),$ff
.else
	ld hl,$cfde
	ld (hl),$01
.endif
	jp interactionDelete

;;
creditsTextHorizontal_6537:
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_CREDITS_TEXT_HORIZONTAL
	inc l
	ld e,Interaction.var32
	ld a,(de)
	ldi (hl),a  ; [child.subid]
	ld (hl),$01 ; [child.var03]

	ld l,Interaction.counter1
	ld e,l
	ld a,(de)
	inc e
	ldi (hl),a
	ld a,(de) ; [counter2]
	ld (hl),a
	call objectCopyPosition
++
	ld h,d
	ld l,Interaction.counter2
	inc (hl)

;;
creditsTextHorizontal_6554:
	ld l,Interaction.scriptPtr
	ldi a,(hl)
	ld h,(hl)
	ld l,a

;;
; @param	hl	Script pointer
creditsTextHorizontal_6559:
	ldi a,(hl)
	ld e,Interaction.var30
	ld (de),a

	inc e
	ldi a,(hl)
	ld (de),a ; [var31]

	ldi a,(hl)
	ld e,Interaction.counter1
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a

	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Interaction.var31
	ld a,(de)
	or a
	ret nz

	dec e
	ld a,(de) ; [var30]
	or a
	ret nz
	jp creditsTextHorizontal_6537

;;
horizontalCreditsText_var03Nonzero:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld h,d
	ld l,Interaction.var30
	dec (hl)
	jr nz,@applySpeed

	call interactionIncSubstate
	ld b,$a0
	ld l,Interaction.subid
	ld a,(hl)
	or a
	jr z,+
	ld b,$50
+
	ld l,Interaction.xh
	ld (hl),b
	ret

@applySpeed:
	call objectApplySpeed
	jp objectApplySpeed

@substate1:
	ld e,Interaction.counter1
	ld a,(de)
	inc a
	ret z
	call interactionDecCounter1
	jp z,interactionDelete
	ret

horizontalCreditsText_65b1:
	.db $00 $00 $01 $04 $00 $0b $01 $13
	.db $00 $00 $01 $04 $00 $0b $01 $13


; Custom script format? TODO: figure this out
horizontalCreditsText_scriptTable:
	.dw @script0
	.dw @script1
	.dw @script2
	.dw @script3
	.dw @script0
	.dw @script1
	.dw @script2
	.dw @script3

@script0:
	.db $20 $00 $ff $f8
	.db $30 $00 $f0 $18
	.db $20 $00 $f0 $38
	.db $20 $00 $f0 $50
	.db $ff

@script1:
	.db $20 $00 $ff $f8
	.db $20 $00 $f8 $18
	.db $10 $00 $e8 $38
	.db $10 $00 $d8 $58
	.db $80 $00 $00 $ff
	.db $10 $00 $00 $ff
	.db $28 $00 $00 $ff
	.db $50 $ff

@script2:
	.db $20 $00 $fe $f8
	.db $10 $00 $e8 $18
	.db $0a $00 $d8 $38
	.db $0a $00 $c8 $58
	.db $80 $00 $00 $ff
	.db $f8 $00 $00 $ff
	.db $18 $00 $00 $ff
	.db $38 $00 $00 $ff
	.db $58 $ff

@script3:
	.db $20 $00 $f8 $f8
	.db $20 $00 $d8 $18
	.db $00 $00 $d8 $38
	.db $00 $00 $d8 $58
	.db $80 $00 $00 $ff
	.db $f8 $00 $00 $ff
	.db $18 $00 $00 $ff
	.db $38 $00 $00 $ff
	.db $58 $ff


; ???
interactionCodeaf:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	or a
	jr nz,@@subid1
	ld hl,table_6dd2
	jp func_6db4
@@subid1:
	ld h,d
	ld l,$50
	ld (hl),$14
	ret
@state1:
	ld e,$42
	ld a,(de)
	or a
	jr nz,state1_subid1
	ld a,($c4ab)
	or a
	ret nz
	ld h,d
	ld l,$70
	call decHlRef16WithCap
	ret nz
	call @@func_6d99
	ld e,$70
	ld a,(de)
	inc a
	ret nz
	ld hl,$cfde
	ld (hl),$01
	jp interactionDelete
@@func_6d99:
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_af
	inc l
	ld (hl),$01
	inc l
	ld e,$46
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
+
	ld h,d
	ld l,$46
	inc (hl)
	ld a,(hl)
	ld hl,table_6dd2
	rst_addDoubleIndex
func_6db4:
	ldi a,(hl)
	ld e,$70
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ret
state1_subid1:
	ld a,($c4ab)
	or a
	ret nz
	call objectApplySpeed
	ld h,d
	ld l,$4b
	ldi a,(hl)
	ld b,a
	or a
	jp z,interactionDelete
	inc l
	ld c,(hl)
	jp interactionFunc_3e6d
table_6dd2:
	; var30 - var31
	.db $20 $00
	.db $e0 $00
	.db $20 $01
	.db $10 $01
	.db $f0 $00
	.db $60 $01
	.db $f0 $00
	.db $20 $01
	.db $70 $01
	.db $70 $01
	.db $60 $01
	.db $40 $01
	.db $50 $01
	.db $10 $01
	.db $60 $01
	.db $a0 $01
	.db $ff


; ==============================================================================
; INTERACID_TWINROVA_FLAME
; ==============================================================================
.ifdef ROM_AGES
interactionCodea9:
.else
interactionCodeb0:
.endif
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionAnimate
	.dw @state2

@state0:
	ld a,$01
	ld (de),a ; [state]

	ld e,Interaction.subid
	ld a,(de)
.ifdef ROM_AGES
	cp $06
.else
	cp $0b
.endif
	call nc,interactionIncState

.ifdef ROM_SEASONS
	or a
	jr nz,+
	ld a,$b0
	ld (wInteractionIDToLoadExtraGfx),a
	ld (wLoadedTreeGfxIndex),a
+
.endif

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.subid
	ld a,(hl)
	ld b,a
.ifdef ROM_AGES
	cp $03
.else
	cp $08
.endif
	jr c,++
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete

	ld a,(de) ; [subid]
.ifdef ROM_AGES
++
	and $03
.else
	sub $05
++
.endif
	add a
	add a
	add a
	ld l,Interaction.animCounter ; BUG(?): Won't point to the object after "getThisRoomFlags" call?
	add (hl)
	ld (hl),a
	ld a,b
	ld hl,@positions
	rst_addDoubleIndex
	ldi a,(hl)
.ifdef ROM_AGES
	ld c,(hl)
	ld b,a
	call interactionSetPosition
.else
	ld e,Interaction.yh
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
.endif
	jp objectSetVisiblec2

@positions:
.ifdef ROM_SEASONS
	.db $32 $78
	.db $50 $80
	.db $50 $70
.endif

	.db $40 $a8
	.db $40 $48
	.db $10 $78

.ifdef ROM_SEASONS
	.db $48 $30
	.db $48 $70
.endif

	.db $50 $a8
	.db $50 $48
	.db $20 $78

	.db $50 $a8
	.db $50 $48
	.db $20 $78

@state2:
	call interactionAnimate
	ld a,(wFrameCounter)
	rrca
	jp c,objectSetVisible
	jp objectSetInvisible


; ==============================================================================
; INTERACID_SHIP_PIRATIAN
; ==============================================================================
interactionCodeb1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw piratian_state0
	.dw piratian_state1
	.dw piratian_state2
	.dw piratian_state3
	.dw piratian_state4
	.dw piratian_state5
	.dw piratian_state6


; ==============================================================================
; INTERACID_SHIP_PIRATIAN_CAPTAIN
; ==============================================================================
interactionCodeb2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw piratianCaptain_state0
	.dw piratian_state2
	.dw piratian_state1

piratian_state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$6b
	ld (hl),$00
	ld l,$49
	ld (hl),$ff
	ld e,$42
	ld a,(de)
	ld b,a
	cp $18
	; subid_00-17
	ld a,>TX_4e00
	jr c,+
	; subid_18-1a
	ld a,>TX_4d00
+
	call interactionSetHighTextIndex
	ld a,b
	ld hl,table_6f4b
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call objectSetVisiblec2
	call interactionRunScript
	call interactionRunScript
	jp c,interactionDelete
	ret

piratianCaptain_state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	ld hl,table_6f81
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call objectSetVisiblec2
	ld a,>TX_4e00
	call interactionSetHighTextIndex
	call interactionRunScript
	jp interactionRunScript

piratian_state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

piratian_state2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimate

piratian_state3:
	ld a,$10
	call setScreenShakeCounter
	call interactionRunScript
	jp c,interactionDelete
	ret

piratian_state4:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionAnimate
	call interactionRunScript
	jp c,interactionDelete
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld e,$48
	ld a,(de)
	inc a
	and $03
	ld (de),a
	jp interactionSetAnimation

piratian_state5:
	call objectPreventLinkFromPassing
	call interactionAnimate
	call interactionRunScript
	jp c,interactionDelete
	ld a,(wFrameCounter)
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible

piratian_state6:
	ld a,($cfc0)
	or a
	jp nz,interactionDelete
	call interactionRunScript
	jp c,interactionDelete
	jp objectSetInvisible

table_6f4b:
	.dw mainScripts.stubScript
	.dw mainScripts.shipPirationScript_piratianComingDownHandler
	.dw mainScripts.shipPiratianScript_piratianFromAbove
	.dw mainScripts.shipPirationScript_inShipLeavingSubrosia
	.dw mainScripts.shipPirationScript_inShipLeavingSubrosia
	.dw mainScripts.shipPirationScript_inShipLeavingSubrosia
	.dw mainScripts.shipPirationScript_inShipLeavingSubrosia
	.dw mainScripts.shipPiratianScript_leavingSamasaDesert
	.dw mainScripts.shipPiratianScript_dizzyPirate1Spawner
	.dw mainScripts.shipPiratianScript_swapShip
	.dw mainScripts.shipPiratianScript_1stDizzyPirateDescending
	.dw mainScripts.shipPirationScript_2ndDizzyPirateDescending
	.dw mainScripts.shipPirationScript_3rdDizzyPirateDescending
	.dw mainScripts.shipPiratianScript_dizzyPiratiansAlreadyInside
	.dw mainScripts.shipPiratianScript_dizzyPiratiansAlreadyInside
	.dw mainScripts.stubScript
	.dw mainScripts.shipPiratianScript_landedInWestCoast_shipTopHalf
	.dw mainScripts.shipPiratianScript_landedInWestCoast_shipBottomHalf
	.dw mainScripts.shipPiratianScript_insideDockedShip1
	.dw mainScripts.shipPiratianScript_insideDockedShip2
	.dw mainScripts.shipPiratianScript_insideDockedShip3
	.dw mainScripts.shipPiratianScript_insideDockedShip4
	.dw mainScripts.shipPiratianScript_insideDockedShip5
	.dw mainScripts.stubScript
	.dw mainScripts.shipPiratianScript_ghostPiratian
	.dw mainScripts.shipPiratianScript_NWofGhostPiration
	.dw mainScripts.shipPiratianScript_NEofGhostPiration
table_6f81:
	.dw mainScripts.shipPiratianCaptainScript_leavingSubrosia
	.dw mainScripts.shipPiratianCaptainScript_gettingSick
	.dw mainScripts.shipPiratianCaptainScript_arrivingInWestCoast
	.dw mainScripts.shipPiratianCaptainScript_inWestCoast


; ==============================================================================
; INTERACID_LINKED_CUTSCENE
; ==============================================================================
interactionCodeb3:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	call checkIsLinkedGame
	jp nz,interactionDelete
	ld a,GLOBALFLAG_WITCHES_1_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	jr @postCutscene

@subid1:
	call checkIsLinkedGame
	jp nz,interactionDelete
	ld a,GLOBALFLAG_WITCHES_2_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete
	jr @postCutscene

@subid2:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	jr @postCutscene

@subid3:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete
	jr @postCutscene

@subid4:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_FLAMES_OF_DESTRUCTION_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete

@postCutscene:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld hl,$cfc0
	ld (hl),$00
	ld a,>TX_5000
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret

@scriptTable:
	.dw mainScripts.linkedCutsceneScript_witches1
	.dw mainScripts.linkedCutsceneScript_witches2
	.dw mainScripts.linkedCutsceneScript_zeldaVillagers
	.dw mainScripts.linkedCutsceneScript_zeldaKidnapped
	.dw mainScripts.linkedCutsceneScript_flamesOfDestruction


; twinrova witches?
interactionCodeb4:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw twinrovaWitches_state0
	.dw twinrovaWitches_state1

twinrovaWitches_state0:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
@subid0:
@subid1:
	call twinrovaWitches_state0Init
	ld l,$42
	ld a,(hl)
	call func_7266
	jp twinrovaWitches_state1
@subid2:
@subid3:
	call twinrovaWitches_state0Init
	ld l,$4f
	ld (hl),$fb
	ld l,$42
	ld a,(hl)
	call func_7266
	jp twinrovaWitches_state1
@subid4:
	call twinrovaWitches_state0Init
	ld l,$4f
	ld (hl),$f0
	ld a,$04
	call func_7266
	ld a,$04
	call interactionSetAnimation
	jp twinrovaWitches_state1
@subid5:
	call twinrovaWitches_state0Init
	ld a,$04
	call func_7266
	ld a,$01
	call interactionSetAnimation
	jp twinrovaWitches_state1
@subid6:
	call twinrovaWitches_state0Init
	ld l,$4f
	ld (hl),$00
	ld a,$05
	call interactionSetAnimation
	jp twinrovaWitches_state1
@subid7:
	call twinrovaWitches_state0Init
	ld l,$4f
	ld (hl),$00
	ld a,$06
	call interactionSetAnimation
	jp twinrovaWitches_state1

twinrovaWitches_state0Init:
	call interactionInitGraphics
	call objectSetVisiblec0
	call interactionSetAlwaysUpdateBit
	call twinrovaWitches_getOamFlags
	call interactionIncState
	ld l,$50
	ld (hl),$50
	ld l,$4f
	ld (hl),$f8
	ld l,$48
	ld (hl),$ff
	ret

twinrovaWitches_state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
@subid0:
@subid1:
@subid2:
@subid3:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
@@substate0:
	call func_71ee
	call func_7220
	call func_720a
	call c,func_7232
	jp nc,@animate
	ld h,d
	ld l,$45
	ld (hl),$01
	ld l,$47
	ld (hl),$28
	ld l,$42
	ld a,(hl)
	cp $02
	jr nz,@@func_7105
	ld a,$00
	jr ++
@@func_7105:
	cp $03
	jr nz,@@func_710d
	ld a,$01
	jr ++
@@func_710d:
	ld a,$02
++
	call interactionSetAnimation
	jp @animate
@@substate1:
	call seasonsFunc_0a_71ce
	call @animate
	call interactionDecCounter2
	ret nz
	ld l,$45
	inc (hl)
	ld l,$47
	ld (hl),$28
@@func_7126:
	ld hl,$cfc6
	inc (hl)
	ld a,(hl)
	cp $02
	ret nz
	ld (hl),$00
	ld hl,$cfc0
	set 0,(hl)
	ret
@@substate2:
	call seasonsFunc_0a_71ce
	call @animate
	ld a,($cfc0)
	bit 0,a
	ret nz
	call interactionDecCounter2
	ret nz
	ld l,$45
	inc (hl)
	ld l,$48
	ld (hl),$ff
	ld l,$42
	ld a,(hl)
	add $04
	jp func_7266
@@substate3:
	ld e,$42
	ld a,(de)
	cp $02
	jr c,++
@@func_715c:
	call func_71ee
	call func_720a
	call c,func_7232
	jr c,+++
++
	call func_71ee
	ld e,$42
	ld a,(de)
	cp $04
	call nz,func_7220
	call func_720a
	call c,func_7232
	jr nc,@animate
+++
	ld e,$42
	ld a,(de)
	cp $02
	jr c,+
	cp $04
	jr c,++
+
	call @@func_7126
	jp interactionDelete
++
	call @@func_7126
	ld h,d
	ld l,$45
	inc (hl)
	ret
@@substate4:
	jp @animate
@subid4:
@subid5:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
@@substate0:
	call seasonsFunc_0a_71ce
	call @animate
	ld a,($cfc0)
	bit 0,a
	ret z
	call interactionIncSubstate
	ld l,$48
	ld (hl),$ff
	ret
@@substate1:
	jr @subid3@func_715c
@subid6:
@subid7:
	jp @animate
@animate:
	jp interactionAnimate

twinrovaWitches_getOamFlags:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@oamFlagsData
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.oamFlags
	ld (de),a
	ret

@oamFlagsData:
	.db $02 $01 $02 $01
	.db $00 $01 $02 $01

seasonsFunc_0a_71ce:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,table_71e6
	rst_addAToHl
	ld e,$4f
	ld a,(de)
	add (hl)
	ld (de),a
	ret
table_71e6:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00
	
func_71ee:
	ld h,d
	ld l,$7c
	ld a,(hl)
	add a
	ld b,a
	ld e,$7f
	ld a,(de)
	ld l,a
	ld e,$7e
	ld a,(de)
	ld h,a
	ld a,b
	rst_addAToHl
	ld b,(hl)
	inc hl
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	jp objectApplySpeed
	
func_720a:
	call func_7253
	ld l,$4b
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret nc
	inc bc
	ld l,$4d
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret
	
func_7220:
	ld h,d
	ld l,$49
	ld a,(hl)
	swap a
	and $01
	xor $01
	ld l,$48
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation
	
func_7232:
	call func_7242
	ld h,d
	ld l,$7d
	ld a,(hl)
	ld l,$7c
	inc (hl)
	cp (hl)
	ret nc
	ld (hl),$00
	scf
	ret
	
func_7242:
	call func_7253
	ld l,$4a
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4c
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	ret

func_7253:
	ld h,d
	ld l,$7c
	ld a,(hl)
	add a
	push af
	ld e,$7f
	ld a,(de)
	ld c,a
	ld e,$7e
	ld a,(de)
	ld b,a
	pop af
	call addAToBc
	ret

func_7266:
	add a
	add a
	ld hl,table_7279
	rst_addAToHl
	ld e,$7f
	ldi a,(hl)
	ld (de),a
	ld e,$7e
	ldi a,(hl)
	ld (de),a
	ld e,$7d
	ldi a,(hl)
	ld (de),a
	ret

table_7279:
	; var3f - var3e - var3d - unused
	; var3e/3f are pointers to below tables
	; var3d is index of last pair of entries in below tables
	dwbb table_7299 $08 $00
	dwbb table_72ab $08 $00
	dwbb table_72e5 $0b $00
	dwbb table_72fd $0b $00
	dwbb table_72bd $09 $00
	dwbb table_72d1 $09 $00
	dwbb table_7315 $04 $00
	dwbb table_731f $04 $00

table_7299:
	.db $22 $68 $28 $80 $2e $8a $34 $90
	.db $3a $8a $40 $80 $46 $68 $4a $50
	.db $50 $28
table_72ab:
	.db $22 $38 $28 $20 $2e $16 $34 $10
	.db $3a $16 $40 $20 $46 $38 $4a $50
	.db $50 $78
table_72bd:
	.db $54 $18 $58 $0e $60 $08 $68 $0c
	.db $72 $18 $78 $28 $80 $48 $88 $68
	.db $90 $80 $a0 $a0
table_72d1:
	.db $54 $88 $58 $92 $60 $98 $68 $94
	.db $72 $88 $78 $78 $80 $58 $88 $38
	.db $90 $20 $a0 $00
table_72e5:
	.db $01 $40 $29 $18 $39 $10 $45 $0c
	.db $51 $10 $61 $18 $71 $28 $77 $38
	.db $79 $48 $77 $58 $71 $68 $61 $78
table_72fd:
	.db $01 $60 $29 $88 $39 $90 $45 $94
	.db $51 $90 $61 $88 $71 $78 $77 $68
	.db $79 $58 $77 $48 $71 $38 $61 $28
table_7315:
	.db $5d $90 $4d $98 $39 $90 $2d $78
	.db $29 $60
table_731f:
	.db $5d $10 $4d $08 $39 $10 $2d $28
	.db $29 $40


; TODO: in first room of twinrova dungeon
; Variables:
;   $cbb3: substate0 = $00
;   $cbba: substate0 = $ff
interactionCodeb5:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
	set 6,(hl)

	call setDeathRespawnPoint
	ld a,$09
	ld (wc6e5),a
	xor a
	ld (wTextIsActive),a
	ld a,$78
	ld e,Interaction.counter1
	ld (de),a
	ldbc $58 $78
	jp createEnergySwirlGoingIn

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$08
	ld hl,$cbb3
	ld (hl),$00
	ld hl,$cbba
	ld (hl),$ff
	ret

@substate1:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr nz,+
	call setLinkForceStateToState08
	ld hl,w1Link.visible
	set 7,(hl)
+
	call interactionDecCounter1
	ld hl,$cbb3
	ld b,$01
	call flashScreen
	ret z
	call interactionIncSubstate
	ld a,$03
	jp fadeinFromWhiteWithDelay

@substate2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete


; ==============================================================================
; INTERACID_S_AMBI
; ==============================================================================
interactionCodeb8:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call checkIsLinkedGame
	jp z,interactionDelete
	call func_740a
	ld e,$42
	ld a,(de)
	cp $03
	jr z,@subid3
	ld hl,@var3eVals
	rst_addAToHl
	ld e,$7e
	ld a,(de)
	cp (hl)
	jp nz,interactionDelete
	jr ++
@subid3:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	jp nz,interactionDelete
++
	call interactionInitGraphics
	call interactionIncState
	ld e,$42
	ld a,(de)
	ld hl,table_7432
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,>TX_3a00
	call interactionSetHighTextIndex
	call objectSetVisible80
	ld a,$02
	call interactionSetAnimation
	jp @animate
@var3eVals:
	.db $00 $01 $02 $00 $03
@state1:
	call interactionRunScript
	ld e,$7f
	ld a,(de)
	or a
	jr nz,@animate
	jp npcFaceLinkAndAnimate
@animate:
	jp interactionAnimate

; Stores into var3e, in this order:
;   $03 - if pirates left for the ship
;   $02 - if 5th+ essence gotten
;   $01 - if 3rd+ essence gotten
;   $00 - otherwise
func_740a:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	jr nz,@piratesLeftForShip
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,@haveEssence
	xor a
@haveEssence:
	cp $10
	jr nc,@atLeast5thEssence
	cp $04
	jr nc,@atLeast3rdEssence
	xor a
	jr @storeIntoVar3e
@atLeast3rdEssence:
	ld a,$01
	jr @storeIntoVar3e
@atLeast5thEssence:
	ld a,$02
	jr @storeIntoVar3e
@piratesLeftForShip:
	ld a,$03
@storeIntoVar3e:
	ld e,$7e
	ld (de),a
	ret

table_7432:
	.dw mainScripts.ambiScript_mrsRuulsHouse
	.dw mainScripts.ambiScript_outsideSyrupHut
	.dw mainScripts.ambiScript_samasaShore
	.dw mainScripts.ambiScript_enteringPirateHouseBeforePiratesLeave
	.dw mainScripts.ambiScript_pirateHouseAfterTheyLeft


; endgame cutscene NPC?
interactionCodeb9:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	call objectSetInvisible
	ld e,$42
	ld a,(de)
	ld b,a
	ld hl,@@counter1Vals
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.counter1
	ld (de),a
	ld a,b
	ld hl,@@coordsToLookAt
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld a,(hl)
	ld c,a
	ld e,$76
	ld (de),a
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	ld e,$50
	ld a,$28
	ld (de),a
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@setSpeedZ
	.dw @@setSpeedZ
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
	.dw @@subid7
@@subid0:
	ld e,$49
	ld a,$04
	ld (de),a
	ld h,d
	ld l,$46
	ld (hl),$e0
	inc hl
	ld (hl),$01
@@setSpeedZ:
	ld e,$42
	ld a,(de)
	ld hl,@@speedZValues
	rst_addDoubleIndex
	ld c,(hl)
	inc hl
	ld b,(hl)
	jp objectSetSpeedZ
@@subid3:
	call @@setSpeedZ
	ld e,$50
	ld a,$3c
	ld (de),a
	jp @@setZhAndZ
@@subid4:
@@subid5:
@@subid6:
	call @@setSpeedZ
	ld e,$50
	ld a,$0a
	ld (de),a
@@setZhAndZ:
	ld e,$42
	ld a,(de)
	sub $03
	ld hl,@@zhAndZvalues
	rst_addDoubleIndex
	ld e,$4f
	ldi a,(hl)
	ld (de),a
	dec e
	ld a,(hl)
	ld (de),a
	ret
@@subid7:
	ld hl,mainScripts.script7a81
	jp interactionSetScript
@@counter1Vals:
	.db $e6 $5a $78 $be
	.db $c8 $d2 $dc $fa
@@coordsToLookAt:
	.db $58 $38
	.db $48 $40
	.db $4c $60
	.db $48 $78
	.db $1a $2c
	.db $10 $38
	.db $0a $44
	.db $18 $a0
@@speedZValues:
	.dw -$0c0
	.dw -$120
	.dw -$100
	.dw -$040
	.dw  $036
	.dw  $036
	.dw  $036
@@zhAndZvalues:
	.db $e8 $ff
	.db $c8 $ff
	.db $c8 $ff
	.db $c8 $ff
	
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
@@substate0:
	call interactionDecCounter1
	ret nz
	call objectSetVisible
	jp interactionIncSubstate
@@substate1:
	call interactionAnimate
	call objectApplySpeed
	ld h,d
	ld l,$4d
	ld a,(hl)
	ld l,$76
	cp (hl)
	jr nz,@@func_752b
	call interactionIncSubstate
	ld l,$4f
	ld (hl),$00
	ld l,$42
	ld a,(hl)
	add a
	inc a
	jp interactionSetAnimation
@@func_752b:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@@subid0
	.dw @@@subid1
	.dw @@@subid2
	.dw @@@subid3
	.dw @@@subid4
	.dw @@@subid5
	.dw @@@subid6
	.dw @@@subidStub
@@@subid0:
@@@subid1:
@@@subid2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld e,$42
	jp @state0@setSpeedZ
@@@subid3:
	ld c,$10
--
	ld e,$77
	ld a,(de)
	or a
	ret nz
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld l,$77
	inc (hl)
@@@subidStub:
	ret
@@@subid4:
@@@subid5:
@@@subid6:
	ld c,$01
	jr --
@@substate2:
	ld e,$42
	ld a,(de)
	or a
	jr nz,func_7573
	ld b,a
	ld h,d
	ld l,$46
	call decHlRef16WithCap
	jr nz,func_757f
	ld hl,$cfdf
	ld (hl),$01
	ret
func_7573:
	cp $07
	jr nz,func_757f
	call interactionRunScript
	ld e,$47
	ld a,(de)
	or a
	ret z
func_757f:
	jp interactionAnimate


interactionCodeba:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw interactionCodebb@subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
@subid1:
@subid2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call func_7867
	ld l,$43
	ld a,(hl)
	call interactionSetAnimation
@@state1:
	call interactionRunScript
	jp func_7886
@subid3:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call func_7867
@@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp func_7886


interactionCodebb:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
@@state0:
	call func_7867
	ld l,$43
	ld a,(hl)
	call interactionSetAnimation
@@state1:
	call interactionRunScript
	call func_7886
	ld a,($cfc0)
	bit 7,a
	ret z
	call func_788e
	jp interactionIncState
@@state2:
	call interactionRunScript
	call func_7886
	call decVar3c
	ret nz
	ld l,$44
	inc (hl)
	ld l,$7c
	ld (hl),$0a
	jp func_78c3
@@state3:
	call interactionRunScript
	call func_7886
	call decVar3c
	ret nz
	ld l,$44
	inc (hl)
	ld l,$50
	ld (hl),$28
	ld l,$7c
	ld (hl),$58
	call func_78b3
	ld a,$d2
	jp playSound
@@state4:
	call decVar3c
	jp z,interactionDelete
	call objectApplySpeed
	call interactionRunScript
	jp func_7886
@subid1:
@subid2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$42
	ld a,(hl)
	ld b,$02
	cp $03
	jr z,+
	ld b,$00
+
	ld l,$5c
	ld (hl),b
	ld l,$46
	ld (hl),$78
	jp objectSetVisiblec1
@@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	.dw @@substate8
	.dw @@substate9
	.dw @@substateA
	.dw @@substateB
@@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$66
	ld l,$50
	ld (hl),$32
	ld l,$49
	ld (hl),$18
	call interactionIncSubstate
@@setAnimationBasedOnAngle:
	ld e,$49
	ld a,(de)
	call convertAngleDeToDirection
	jp interactionSetAnimation
@@substate1:
	call @@animateTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz
	call getRandomNumber
	and $0f
	add $1e
	ld (hl),a
	ld l,$49
	ld (hl),$08
	call @@setAnimationBasedOnAngle
	jp interactionIncSubstate
@@animateTwiceAndApplySpeed:
	call interactionAnimate
	call interactionAnimate
	jp objectApplySpeed
@@substate2:
	call interactionDecCounter1
	ret nz
	call func_77eb
	jp interactionIncSubstate
@@substate3:
	call func_77e5
	ld a,($cfd0)
	cp $01
	ret nz
	ld e,$4f
	ld a,(de)
	or a
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ret
@@substate4:
	call interactionDecCounter1
	ret nz
	ld l,$50
	ld (hl),$50
	call @@func_772e
	jp interactionIncSubstate
@@substate5:
	ld a,($cfd0)
	cp $02
	jr nz,+
	ld e,$4f
	ld a,(de)
	or a
	jr nz,+
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0a
	ld l,$49
	ld (hl),$18
	jp @@setAnimationBasedOnAngle
+
	ld e,$77
	ld a,(de)
	rst_jumpTable
	.dw @@var77_00
	.dw @@var77_01
	.dw @@var77_02
@@var77_00:
	call @@animateTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz
	ld (hl),$0a
	ld l,$77
	inc (hl)
	cp $68
	ld a,$01
	jr c,+
	ld a,$03
+
	jp interactionSetAnimation
@@var77_01:
	call interactionDecCounter1
	ret nz
	ld (hl),$1e
	ld l,$77
	inc (hl)
	jp func_77eb
@@var77_02:
	call func_77e5
	call interactionDecCounter1
	ret nz
	xor a
	ld l,$4e
	ldi (hl),a
	ld (hl),a
	ld l,$77
	ld (hl),$00
@@func_772e:
	ld e,$42
	; subid_01-02
	ld a,(de)
	dec a
	ld b,a
	swap a
	sra a
	add b
	; subid01 - index $00, subid02 - index $09
	ld hl,@@table_775a
	rst_addAToHl
	ld e,Interaction.counter2
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	inc l
	ld e,$46
	ld (de),a
	ld e,$49
	ld a,b
	ld (de),a
	ld e,$47
	ld a,(de)
	ld b,a
	inc b
	ld a,(hl)
	or a
	jr nz,+
	ld b,$00
+
	ld a,b
	ld (de),a
	jp @@setAnimationBasedOnAngle
@@table_775a:
	; counter1 - angle
	; subid1
	.db $1a $09
	.db $16 $1f
	.db $17 $17
	.db $0c $0f
	.db $00
	; subid2
	.db $0c $09
	.db $18 $0a
	.db $16 $18
	.db $12 $1f
	.db $00
	; subid3 from interactionCodebc / bd / be
	.db $1d $08
	.db $19 $16
	.db $18 $0a
	.db $06 $01
	.db $00
@@substate6:
	call interactionDecCounter1
	ret nz
	ld e,$42
	ld a,(de)
	ld b,$34
	cp $03
	jr z,+
	ld b,$20
+
	ld (hl),b
	ld l,$50
	ld (hl),$3c
	jp interactionIncSubstate
@@substate7:
	call @@animateTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz
	call getRandomNumber
	and $07
	inc a
	ld (hl),a
	ld a,$01
	call interactionSetAnimation
	jp interactionIncSubstate
@@substate8:
	ld a,($cfd0)
	cp $03
	ret nz
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jr func_77eb
@@substate9:
	call func_77e5
	ld a,($cfd0)
	cp $04
	ret nz
	ld e,$4f
	ld a,(de)
	or a
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0c
	ret
@@substateA:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$50
	ld l,$50
	ld (hl),$3c
	ld a,$03
	jp interactionSetAnimation
@@substateB:
	call @@animateTwiceAndApplySpeed
	call interactionDecCounter1
	jp z,interactionDelete
	ret
func_77e5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
func_77eb:
	ld bc,$ff20
	jp objectSetSpeedZ


interactionCodebc:
interactionCodebd:
interactionCodebe:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw interactionCodebb@subid0
	.dw @subid1
	.dw @subid2
	.dw interactionCodebb@subid2
	.dw @subid4
@subid1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @runScriptAnimateAsNPC
@@state0:
	call func_7867
	ld e,$41
	ld a,(de)
	cp $bd
	jr nz,@runScriptAnimateAsNPC
	ld a,$01
	ld e,$7b
	ld (de),a
	call interactionSetAnimation
@runScriptAnimateAsNPC:
	call interactionRunScript
	jp interactionAnimateAsNpc
@subid2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @runScriptAnimateAsNPC
@@state0:
	call func_7867
	ld a,$02
	ld e,$7b
	ld (de),a
	call interactionSetAnimation
	jr @runScriptAnimateAsNPC
@subid4:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call checkIsLinkedGame
	jp z,interactionDelete
	call func_78ce
	ld e,$78
	ld a,(de)
	or a
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld l,$7e
	ld (hl),$02
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
@@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
	
decVar3c:
	ld h,d
	ld l,$7c
	dec (hl)
	ret

func_7867:
	call interactionInitGraphics
	ld e,$41
	ld a,(de)
	sub $ba
	ld hl,ba_to_beScripts
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call objectSetVisible81
	jp interactionIncState
	
func_7886:
	ld e,$7d
	ld a,(de)
	or a
	ret nz
	jp interactionAnimate

func_788e:
	ld e,$41
	ld a,(de)
	sub $ba
	ld hl,table_78a9
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$7c
	ld (de),a
	ld a,(hl)
	ld e,$49
	ld (de),a
	add $04
	and $18
	swap a
	rlca
	jp interactionSetAnimation

table_78a9:
	.db $50 $1e
	.db $01 $02
	.db $3c $16
	.db $28 $1c
	.db $78 $18

func_78b3:
	call getFreeInteractionSlot ; $78b3
	ret nz
	ld (hl),INTERACID_D1_RISING_STONES
	inc l
	ld (hl),$02
	ld l,$46
	ld (hl),$78
	jp objectCopyPosition

func_78c3:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTNING
	inc l
	inc (hl)
	jp objectCopyPosition

func_78ce:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,+
	xor a
+
	ld h,d
	ld l,$78
	cp $07
	ld (hl),$00
	ret c
	ld (hl),$01
	ret
	
ba_to_beScripts:
	.dw baScripts
	.dw bbScripts
	.dw bcScripts
	.dw bdScripts
	.dw beScripts
baScripts:
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_ba_subid1
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_ba_subid3
bbScripts:
	.dw mainScripts.zeldaNPCScript_stub
bcScripts:
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_bc_subid1
	.dw mainScripts.zeldaNPCScript_bc_subid2
bdScripts:
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_bd_subid1
	.dw mainScripts.zeldaNPCScript_bd_subid2
beScripts:
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_be_subid1
	.dw mainScripts.zeldaNPCScript_be_subid2


; cloaked twinrova?
interactionCodebf:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,$46
	ld (hl),$3c
	jp objectSetVisible80
@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
@substate0:
	call interactionDecCounter1
	jr z,+
	ld a,(wFrameCounter)
	rrca
	jp nc,objectSetInvisible
	jp objectSetVisible
+
	ld l,$45
	inc (hl)
	jp objectSetVisible
@substate1:
	ld h,d
	ld l,$42
	ld a,(hl)
	or a
	jr nz,@subid1
	ld a,($cfc0)
	bit 0,a
	ret z
	ld l,$45
	inc (hl)
	ld a,$02
	jp interactionSetAnimation
@subid1:
	ld a,($cfc0)
	bit 7,a
	jp nz,interactionDelete
	ret
@substate2:
	ld a,($cfc0)
	bit 1,a
	jp nz,interactionDelete
	ret


; ==============================================================================
; INTERACID_c1
;
; Variables:
;   counter1/counter2: 16-bit counter
;   var36: Counter for sparkle spawning
; ==============================================================================
interactionCodec1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.counter1
	ld (hl),<390
	inc l
	ld (hl),>390 ; [counter2]
	ld l,Interaction.var36
	ld (hl),$06
	ld l,Interaction.angle
	ld (hl),$15
	ld l,Interaction.speed
	ld (hl),SPEED_300
	jp objectSetVisible82

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.counter1
	call decHlRef16WithCap
	ret nz
	ld l,Interaction.counter1
	ld (hl),40
	jp interactionIncSubstate

@substate1:
	call @updateMovementAndSparkles
	jr nz,@ret
	ld l,Interaction.animCounter
	ld (hl),$01
	jp interactionIncSubstate

@substate2:
	call interactionAnimate
	call @updateSparkles
	call objectApplySpeed
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	jp z,interactionDelete
	ret

;;
; @param[out]	zflag	z if [counter1] == 0
@updateMovementAndSparkles:
	call @updateSparkles
	call objectApplySpeed
	jp interactionDecCounter1

@ret:
	ret

;;
; Unused
@func_7224:
	ld a,(wFrameCounter)
	and $01
	jp z,objectSetInvisible
	jp objectSetVisible

;;
@updateSparkles:
	ld h,d
	ld l,Interaction.var36
	dec (hl)
	ret nz
	ld (hl),$06 ; [var36]
.ifdef ROM_AGES
	ldbc INTERACID_SPARKLE, $09
.else
	ldbc INTERACID_SPARKLE, $05
.endif
	jp objectCreateInteraction


; ==============================================================================
; INTERACID_MAYORS_HOUSE_UNLINKED_GIRL
; ==============================================================================
interactionCodec2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,mainScripts.mayorsHouseGirlScript
	call interactionSetScript
	jp interactionAnimateAsNpc
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc


; ==============================================================================
; INTERACID_ZELDA_KIDNAPPED_ROOM
; ==============================================================================
interactionCodec3:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call checkInteractionSubstate
	jr nz,@substate1
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp nz,interactionDelete
	callab scriptHelp.zeldaKidnappedRoom_loadZeldaAndMoblins
	jp interactionIncSubstate
@substate1:
	call returnIfScrollMode01Unset
	call interactionIncState
	ld hl,mainScripts.ZeldaBeingKidnappedScript
	call interactionSetScript
@state1:
	jp interactionRunScript


; ==============================================================================
; INTERACID_ZELDA_VILLAGERS_ROOM
; ==============================================================================
interactionCodec4:
	call checkZeldaVillagersSeenButNoMakuSeed
	ld a,$00
	jr nz,+
	call checkGotMakuSeedDidNotSeeZeldaKidnapped_body
	jp z,interactionDelete
	ld a,$01
+
	ld hl,zeldaVillagersRoom_interactionsTableLookup
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld b,(hl)
	inc l
	push de
	ld d,h
	ld e,l
-
	call getFreeInteractionSlot
	jr nz,+
	ld a,(de)
	ldi (hl),a
	inc de
	ld a,(de)
	ld (hl),a
	inc de
	ld l,Interaction.yh
	ld a,(de)
	ldi (hl),a
	inc de
	inc l
	ld a,(de)
	ld (hl),a
	inc de
	dec b
	jr nz,-
+
	pop de
	jp interactionDelete


checkZeldaVillagersSeenButNoMakuSeed:
	call checkIsLinkedGame
	ret z
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	call checkGlobalFlag
	jp z,@checkZeldaVillagersSeen
	xor a
	ret

@checkZeldaVillagersSeen:
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	jp checkGlobalFlag

checkGotMakuSeedDidNotSeeZeldaKidnapped_body:
	call checkIsLinkedGame
	ret z
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jp z,@checkGotMakuSeed
	xor a
	ret

@checkGotMakuSeed:
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	jp checkGlobalFlag


zeldaVillagersRoom_interactionsTableLookup:
	.dw @villagersSeenInteractions ; checkZeldaVillagersSeenButNoMakuSeed
	.dw @gotMakuSeedInteractions ; checkGotMakuSeedDidNotSeeZeldaKidnapped

@villagersSeenInteractions:
	.db $05
	; interactioncode - subid - yh - xh
	.db INTERACID_S_ZELDA $07 $28 $48
	.db INTERACID_IMPA $02 $30 $60
	.db INTERACID_bc $01 $48 $60
	.db INTERACID_be $01 $48 $30
	.db INTERACID_bd $01 $30 $30

@gotMakuSeedInteractions:
	.db $03
	.db INTERACID_bc $02 $48 $60
	.db INTERACID_be $02 $48 $30
	.db INTERACID_bd $02 $30 $30


; ==============================================================================
; INTERACID_D4_HOLES_FLOORTRAP_ROOM
; ==============================================================================
interactionCodec5:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	call interactionIncState
	ld bc,d4floorTrapRoom_tilesToBreak
	jp d4floorTrapRoom_storeAddressOfFirstHoleTilePosition
@state1:
	ld a,($ccba)
	or a
	ret z
	ld a,$f1
	call @func_7aea
	ld a,$4d
	call playSound
	ld e,$47
	ld a,$20
	ld (de),a
	dec e
	ld a,$10
	ld (de),a
	jp interactionIncState
@func_7aea:
	ld c,$2c
	call setTile
	jp objectCreatePuff
@state2:
	ld a,(wFrameCounter)
	rrca
	ret c
	call interactionDecCounter1
	ret nz
	; counter2 into counter1
	inc l
	ldd a,(hl)
	ldi (hl),a
	
	rrca
	cp $04
	jr z,+
	ld (hl),a
+
	call d4floorTrapRoom_storeNextHoleTileAddressIntoHL
	ldi a,(hl)
	ld c,a
	call d4floorTrapRoom_storeIncrementedAddressOfNextHoleTile
	ld a,c
	or a
	jp z,interactionDelete
	ld a,TILEINDEX_BLANK_HOLE
	jp breakCrackedFloor
d4floorTrapRoom_tilesToBreak:
	.db $9d $8d $8c $9b $7b $8a $89 $98
	.db $77 $76 $86 $96 $74 $83 $72 $81
	.db $61 $21 $11 $22 $52 $33 $14 $44
	.db $35 $15 $16 $47 $37 $27 $17 $18
	.db $48 $49 $39 $19 $00
d4floorTrapRoom_storeAddressOfFirstHoleTilePosition:
	ld h,d
	ld l,$58
	ld (hl),c
	inc l
	ld (hl),b
	ret
d4floorTrapRoom_storeNextHoleTileAddressIntoHL:
	ld h,d
	ld l,$58
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ret
d4floorTrapRoom_storeIncrementedAddressOfNextHoleTile:
	ld e,$58
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret


; ==============================================================================
; INTERACID_HEROS_CAVE_SWORD_CHEST
; ==============================================================================
interactionCodec6:
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
	ld (wcca1),a
	jp interactionInitGraphics

@state1:
	ld a,(wcca2)
	or a
	ret z
	ld a,$81
	ld (wDisableLinkCollisionsAndMenu),a
	ld (wDisabledObjects),a
	call interactionIncState
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.speed
	ld (hl),SPEED_40
	ld l,Interaction.counter1
	ld (hl),$20
	jp objectSetVisible80

@state2:
	call interactionDecCounter1
	jp nz,objectApplySpeed

	call interactionIncState
	ld a,TREASURE_SWORD
	ld c,$01
	call giveTreasure
	ld a,SND_GETITEM
	call playSound
	ld bc,TX_001c
	jp showText

@state3:
	ld a,(wTextIsActive)
	or a
	ret nz
	call interactionIncState
	call objectSetInvisible
	ld e,Interaction.counter1
	ld a,90
	ld (de),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),>TREASURE_OBJECT_SWORD_03
	inc l
	ld (hl),<TREASURE_OBJECT_SWORD_03
	ld a,(w1Link.yh)
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a
	ld a,SNDCTRL_MEDIUM_FADEOUT
	jp playSound

@state4:
	call interactionDecCounter1
	ret nz
	call getThisRoomFlags
	set 5,(hl)
	ld hl,@warpDestVariables
	call setWarpDestVariables
	ld a,SND_FADEOUT
	call playSound
	jp interactionDelete

@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_0d4 $00 $54 $83

.ends
