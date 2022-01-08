 m_section_free Interaction_Code_Group5 NAMESPACE commonInteractions5

; ==============================================================================
; INTERACID_WOODEN_TUNNEL
; ==============================================================================
interactionCode98:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$07
	call objectSetCollideRadius

	; Set animation (direction of tunnel) based on subid
	ld e,Interaction.subid
	ld a,(de)
	jr +
+
	call interactionSetAnimation
	jp objectSetVisible81

@state1:
	; Make solid if Link's grabbing something or is on the companion
	ld a,(wLinkGrabState)
	or a
	jr nz,@makeSolid
	ld a,(wLinkObjectIndex)
	bit 0,a
	jr nz,@makeSolid
	ld a,(w1ReservedItemC.enabled)
	or a
	jr nz,@makeSolid

	; Allow Link to pass, but set solidity so he can only pass through the center
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	ld c,SPECIALCOLLISION_VERTICAL_BRIDGE
	jr c,@setSolidity
	ld c,SPECIALCOLLISION_HORIZONTAL_BRIDGE
	jr @setSolidity

@makeSolid:
	ld c,$0f
@setSolidity:
	call objectGetShortPosition
	ld h,>wRoomCollisions
	ld l,a
	ld (hl),c
	ret


; ==============================================================================
; INTERACID_EXCLAMATION_MARK
; ==============================================================================
interactionCode9f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld h,d

	; Always update, even when textboxes are up
	ld l,Interaction.enabled
	set 7,(hl)

	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	inc a
	jp z,interactionAnimate
	dec (hl)
	jp nz,interactionAnimate
	jp interactionDelete

;;
; Called from "objectCreateExclamationMark" in bank 0.
; Creates an "exclamation mark" interaction, complete with sound effect.
;
; @param	a	How long to show the exclamation mark for (0 or $ff for
;                       indefinitely).
; @param	bc	Offset from the object to create the exclamation mark at.
; @param	d	The object to use for the base position of the exclamation mark.
objectCreateExclamationMark_body:
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_EXCLAMATION_MARK
	ld l,Interaction.counter1
	ldh a,(<hFF8B)
	ld (hl),a
	call objectCopyPositionWithOffset

	push hl
	ld a,SND_CLINK
	call playSound
	pop hl
	ret

;;
; Create an interaction with id $a0 (INTERACID_FLOATING_IMAGE). Its position will be
; placed at the current object's position + bc.
;
; @param	bc	Offset relative to object to place the interaction at
; @param	hFF8D	Interaction.subid (0 for snore, 1 for music note)
; @param	hFF8B	Interaction.var03 (0 to float left, 1 to float right)
objectCreateFloatingImage:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_FLOATING_IMAGE
	inc l
	ldh a,(<hFF8D)
	ldi (hl),a
	ldh a,(<hFF8B)
	ld (hl),a
	jp objectCopyPositionWithOffset


; ==============================================================================
; INTERACID_FLOATING_IMAGE
; ==============================================================================
interactionCodea0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call interactionSetAlwaysUpdateBit
	call interactionInitGraphics

	; Set 'b' to the angle to veer off toward (left or right, depending on var03)
	ld h,d
	ld b,$03
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,+
	ld b,$1d
+
	ld l,Interaction.angle
	ld (hl),b
	ld l,Interaction.speed
	ld (hl),SPEED_60

	; Delete after 70 frames
	ld l,Interaction.counter1
	ld (hl),70

	jp objectSetVisible80

@state1:
	; Check whether it's a snore or a music note (but the behaviour is the same)
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
+
	; Delete after 70 frames
	call interactionDecCounter1
	jp z,interactionDelete

	call objectApplySpeed
	ld e,Interaction.var30
	ld (de),a

	; Update x position every 8 frames based on wFrameCounter
	ld a,(wFrameCounter)
	and $07
	ret nz

	push de
	ld h,d
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld de,@xOffsets
	call addAToDe
	ld a,(de)
	ld l,Interaction.var30
	add (hl)
	ld l,Interaction.xh
	ld (hl),a
	pop de
	ret

@xOffsets:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00


; ==============================================================================
; INTERACID_BIPIN_BLOSSOM_FAMILY_SPAWNER
; ==============================================================================
interactionCodeac:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	call childSetVar38ToNumEssencesObtained
	call @checkUpdateState
	call spawnBipinBlossomFamilyObjects
	ld hl,wSeedTreeRefilledBitset
.ifdef ROM_AGES
	res 1,(hl)
.else
	res 0,(hl)
.endif
	jp interactionDelete


; Check whether the player has been gone long enough for the child to proceed to the next
; stage of development (uses wSeedTreeRefilledBitset to ensure that Link's been off
; somewhere else for a while).
; Also checks that Link has enough essences for certain stages of development.
@checkUpdateState:
	ld a,(wSeedTreeRefilledBitset)
.ifdef ROM_AGES
	bit 1,a
.else
	bit 0,a
.endif
	ret z

	ld hl,wNextChildStage
	ld a,(hl)
	ld a,(hl)
	rst_jumpTable
	.dw @gotoNextState
	.dw @need2Essences
	.dw @gotoNextState_2
	.dw @need4Essences
	.dw @need6Essences
	.dw @gotoNextState_2
	.dw @gotoNextState_2
	.dw @need2Essences
	.dw @need4Essences
	.dw @need6Essences

@gotoNextState:
	ld a,(wNextChildStage)
	ld (wChildStage),a
	cp $04
	jp z,decideInitialChildPersonality
	cp $07
	jp z,decideFinalChildPersonality
	ret

@need2Essences:
	ld e,Interaction.var38
	ld a,(de)
	cp $02
	ret c
	jr @gotoNextState

@gotoNextState_2:
	jr @gotoNextState

@need4Essences:
	ld e,Interaction.var38
	ld a,(de)
	cp $04
	ret c
	jr @gotoNextState

@need6Essences:
	ld e,Interaction.var38
	ld a,(de)
	cp $06
	ret c
	jr @gotoNextState

;;
; This is called on file initialization. In a linked game, wChildStatus will be nonzero if
; he was given a name, so he will start at stage 5.
initializeChildOnGameStart:
	ld hl,wChildStatus
	ld a,(hl)
	or a
	ret z

	ld a,$05
	ld l,<wChildStage
	ldi (hl),a
	ldi (hl),a

;;
decideInitialChildPersonality:
	ld hl,initialChildPersonalityTable
	jr label_0b_006

;;
decideFinalChildPersonality:
	; a = [wChildPersonality] * 6
	ld a,(wChildPersonality)
	add a
	ld b,a
	add a
	add b

	ld hl,finalChildPersonalityTable
	rst_addAToHl
label_0b_006:
	ld a,(wChildStatus)
@label_0b_007:
	cp (hl)
	jr nc,@label_0b_008
	inc hl
	inc hl
	jr @label_0b_007
@label_0b_008:
	inc hl
	ld a,(hl)
	ld (wChildPersonality),a
	ret

initialChildPersonalityTable:
	.db $0b $00 ; status >= 11: Hyperactive
	.db $06 $01 ; status >= 6:  Shy
	.db $00 $02 ; status >= 0:  Curious

finalChildPersonalityTable:
	; Hyperactive
	.db $1a $02 ; status >= 26: Arborist
	.db $15 $01 ; status >= 21: Warrior
	.db $00 $00 ; status >= 0:  Slacker

	; Shy
	.db $13 $02 ; status >= 19: Arborist
	.db $0f $00 ; status >= 15: Slacker
	.db $00 $03 ; status >= 0:  Singer

	; Curious
	.db $0e $01 ; status >= 14: Warrior
	.db $0a $00 ; status >= 10: Slacker
	.db $00 $03 ; status >= 0:  Singer

;;
childSetVar38ToNumEssencesObtained:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,+
	xor a
+
	ld h,d
	ld l,Interaction.var38
	ld (hl),$00
@nextBit:
	add a
	jr nc,+
	inc (hl)
+
	or a
	jr nz,@nextBit
	ret

;;
; Spawn bipin, blossom, and child objects depending on the stage of the child's
; development, which part of the house this is, and the child's personality.
;
spawnBipinBlossomFamilyObjects:
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld hl,@leftHouseInteractions
	jr z,+
	ld hl,@rightHouseInteractions
+
	ld a,(wChildStage)
	cp $04
	jr c,++

	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wChildPersonality)
++
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a

@loop:
	ld a,(bc)
	or a
	ret z
	call getFreeInteractionSlot
	ret nz

	; id
	ld a,(bc)
	ldi (hl),a

	; subid
	inc bc
	ld a,(bc)
	ldi (hl),a

	; var03
	inc bc
	ld a,(bc)
	ldi (hl),a

	; yh
	inc bc
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a

	; xh
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	inc bc
	jr @loop

@leftHouseInteractions:
	.dw @leftStage0
	.dw @leftStage1
	.dw @leftStage2
	.dw @leftStage3
	.dw @@stage4
	.dw @@stage5
	.dw @@stage6
	.dw @@stage7
	.dw @@stage8
	.dw @@stage9

@@stage4:
	.dw @leftStage4_hyperactive
	.dw @leftStage4_shy
	.dw @leftStage4_curious
@@stage5:
	.dw @leftStage5_hyperactive
	.dw @leftStage5_shy
	.dw @leftStage5_curious
@@stage6:
	.dw @leftStage6_hyperactive
	.dw @leftStage6_shy
	.dw @leftStage6_curious
@@stage7:
	.dw @leftStage7_slacker
	.dw @leftStage7_warrior
	.dw @leftStage7_arborist
	.dw @leftStage7_singer
@@stage8:
	.dw @leftStage8_slacker
	.dw @leftStage8_warrior
	.dw @leftStage8_arborist
	.dw @leftStage8_singer
@@stage9:
	.dw @leftStage9_slacker
	.dw @leftStage9_warrior
	.dw @leftStage9_arborist
	.dw @leftStage9_singer

@rightHouseInteractions:
	.dw @rightStage0
	.dw @rightStage1
	.dw @rightStage2
	.dw @rightStage3
	.dw @@stage4
	.dw @@stage5
	.dw @@stage6
	.dw @@stage7
	.dw @@stage8
	.dw @@stage9

@@stage4:
	.dw @rightStage4_hyperactive
	.dw @rightStage4_shy
	.dw @rightStage4_curious
@@stage5:
	.dw @rightStage5_hyperactive
	.dw @rightStage5_shy
	.dw @rightStage5_curious
@@stage6:
	.dw @rightStage6_hyperactive
	.dw @rightStage6_shy
	.dw @rightStage6_curious
@@stage7:
	.dw @rightStage7_slacker
	.dw @rightStage7_warrior
	.dw @rightStage7_arborist
	.dw @rightStage7_singer
@@stage8:
	.dw @rightStage8_slacker
	.dw @rightStage8_warrior
	.dw @rightStage8_arborist
	.dw @rightStage8_singer
@@stage9:
	.dw @rightStage9_slacker
	.dw @rightStage9_warrior
	.dw @rightStage9_arborist
	.dw @rightStage9_singer


; Data format:
;   b0: Interaction ID to spawn (or $00 to stop loading)
;   b1: subid
;   b2: var03
;   b3: Y position
;   b4: X position

@leftStage0:
	.db INTERACID_BIPIN   $00 $00 $48 $48
	.db INTERACID_BLOSSOM $00 $00 $38 $78
@rightStage0:
	.db $00

@leftStage1:
	.db INTERACID_BLOSSOM $01 $00 $18 $48
	.db $00
@rightStage1:
	.db INTERACID_BIPIN   $01 $00 $38 $58
	.db $00

@leftStage2:
	.db INTERACID_BLOSSOM $02 $00 $18 $48
	.db INTERACID_CHILD   $07 $00 $10 $38
	.db $00
@rightStage2:
	.db INTERACID_BIPIN   $02 $00 $38 $58
	.db $00

@leftStage3:
	.db INTERACID_BLOSSOM $03 $00 $38 $78
	.db $00
@rightStage3:
	.db INTERACID_BIPIN   $03 $00 $38 $58
	.db $00

@leftStage4_hyperactive:
	.db INTERACID_BLOSSOM $04 $00 $38 $78
	.db INTERACID_CHILD   $00 $01 $38 $68
	.db $00
@leftStage4_shy:
	.db INTERACID_BLOSSOM $04 $00 $38 $78
	.db INTERACID_CHILD   $01 $02 $38 $18
	.db $00
@leftStage4_curious:
	.db INTERACID_BLOSSOM $04 $00 $38 $78
	.db INTERACID_CHILD   $02 $03 $20 $38
	.db $00

@rightStage4_hyperactive:
@rightStage4_shy:
@rightStage4_curious:
	.db INTERACID_BIPIN   $04 $00 $38 $58
	.db $00

@leftStage5_hyperactive:
	.db INTERACID_BLOSSOM $05 $00 $38 $78
	.db INTERACID_BIPIN   $05 $00 $58 $88
	.db INTERACID_CHILD   $00 $04 $38 $68
	.db $00
@leftStage5_shy:
	.db INTERACID_BLOSSOM $05 $00 $38 $78
	.db INTERACID_BIPIN   $05 $00 $58 $88
	.db INTERACID_CHILD   $01 $05 $38 $18
	.db $00
@leftStage5_curious:
	.db INTERACID_BLOSSOM $05 $00 $38 $78
	.db INTERACID_BIPIN   $05 $00 $58 $88
	.db INTERACID_CHILD   $02 $06 $20 $38
	.db $00

@rightStage5_hyperactive:
@rightStage5_shy:
@rightStage5_curious:
	.db $00

@leftStage6_hyperactive:
@leftStage6_shy:
	.db $00
@leftStage6_curious:
	.db INTERACID_CHILD   $02 $09 $20 $38
	.db $00

@rightStage6_hyperactive:
	.db INTERACID_BLOSSOM $06 $00 $22 $58
	.db INTERACID_BIPIN   $06 $00 $38 $58
	.db INTERACID_CHILD   $00 $07 $38 $48
	.db $00
@rightStage6_shy:
	.db INTERACID_BLOSSOM $06 $01 $22 $58
	.db INTERACID_BIPIN   $06 $00 $38 $58
	.db INTERACID_CHILD   $01 $08 $18 $48
	.db $00
@rightStage6_curious:
	.db INTERACID_BLOSSOM $06 $02 $22 $58
	.db INTERACID_BIPIN   $06 $00 $38 $58
	.db $00

@leftStage7_slacker:
	.db INTERACID_CHILD   $03 $0a $24 $38
	.db $00
@leftStage7_warrior:
	.db INTERACID_CHILD   $04 $0b $48 $40
	.db $00
@leftStage7_arborist:
	.db $00
@leftStage7_singer:
	.db INTERACID_BLOSSOM $07 $03 $58 $88
	.db INTERACID_CHILD   $06 $0d $38 $76
	.db $00

@rightStage7_slacker:
	.db INTERACID_BLOSSOM $07 $00 $22 $58
	.db INTERACID_BIPIN   $07 $00 $38 $58
	.db $00
@rightStage7_warrior:
	.db INTERACID_BLOSSOM $07 $01 $22 $58
	.db INTERACID_BIPIN   $07 $00 $38 $58
	.db $00
@rightStage7_arborist:
	.db INTERACID_BLOSSOM $07 $02 $48 $30
	.db INTERACID_BIPIN   $07 $00 $38 $58
	.db INTERACID_CHILD   $05 $0c $22 $58
	.db $00
@rightStage7_singer:
	.db INTERACID_BIPIN   $07 $00 $38 $58
	.db $00

@leftStage8_slacker:
	.db INTERACID_BLOSSOM $08 $00 $58 $88
	.db INTERACID_CHILD   $03 $0e $44 $78
	.db $00
@leftStage8_warrior:
	.db INTERACID_BLOSSOM $08 $01 $38 $78
	.db $00
@leftStage8_arborist:
	.db INTERACID_BLOSSOM $08 $02 $38 $78
	.db $00
@leftStage8_singer:
	.db INTERACID_CHILD   $06 $11 $14 $26
	.db $00

@rightStage8_slacker:
	.db INTERACID_BIPIN   $08 $00 $38 $58
	.db $00
@rightStage8_warrior:
	.db INTERACID_BIPIN   $08 $00 $38 $58
	.db INTERACID_CHILD   $04 $0f $18 $48
	.db $00
@rightStage8_arborist:
	.db INTERACID_BIPIN   $08 $00 $32 $58
	.db INTERACID_CHILD   $05 $10 $48 $58
	.db $00
@rightStage8_singer:
	.db INTERACID_BIPIN   $08 $00 $38 $58
	.db INTERACID_BLOSSOM $08 $03 $48 $28
	.db $00

@leftStage9_slacker:
	.db INTERACID_BLOSSOM $09 $00 $58 $88
	.db INTERACID_CHILD   $03 $12 $44 $78
	.db $00
@leftStage9_warrior:
	.db INTERACID_BLOSSOM $09 $01 $38 $78
	.db INTERACID_CHILD   $04 $13 $48 $40
	.db $00
@leftStage9_arborist:
	.db INTERACID_BLOSSOM $09 $02 $38 $78
	.db $00
@leftStage9_singer:
	.db INTERACID_BLOSSOM $09 $03 $58 $78
	.db INTERACID_CHILD   $06 $15 $36 $68
	.db $00

@rightStage9_slacker:
	.db INTERACID_BIPIN   $09 $00 $38 $58
	.db $00
@rightStage9_warrior:
	.db INTERACID_BIPIN   $09 $00 $38 $58
	.db $00
@rightStage9_arborist:
	.db INTERACID_BIPIN   $09 $00 $32 $58
	.db INTERACID_CHILD   $05 $14 $48 $58
	.db $00
@rightStage9_singer:
	.db INTERACID_BIPIN   $09 $00 $38 $58
	.db $00


; ==============================================================================
; INTERACID_GASHA_SPOT
; ==============================================================================
.enum 0
	GASHATREASURE_HEART_PIECE	db ; $00
	GASHATREASURE_TIER0_RING	db ; $01
	GASHATREASURE_TIER1_RING	db ; $02
	GASHATREASURE_TIER2_RING	db ; $03
	GASHATREASURE_TIER3_RING	db ; $04
	GASHATREASURE_TIER4_RING	db ; $05
	GASHATREASURE_POTION		db ; $06
	GASHATREASURE_200_RUPEES	db ; $07
	GASHATREASURE_FAIRY		db ; $08
	GASHATREASURE_5_HEARTS		db ; $09
.ende

interactionCodeb6:
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
	.dw @state7

; Initialization
@state0:
	ld e,Interaction.subid
	ld a,(de)
	inc e
	ld (de),a
	ld hl,wGashaSpotsPlantedBitset
	call checkFlag
	jr nz,@seedPlanted

	ld e,Interaction.var3c
	ld a,(de)
	or a
	jr nz,+

	ld a,DISCOVERY_RING
	call cpActiveRing
	jr nz,+

	ld a,SND_COMPASS
	ld e,Interaction.var3c
	ld (de),a
	call playSound
+
	call objectGetTileAtPosition
	cp TILEINDEX_SOFT_SOIL
	ret nz
@unearthed:
	call interactionIncState
	ld a,$0a
	call objectSetCollideRadius
	ld e,Interaction.pressedAButton
	jp objectAddToAButtonSensitiveObjectList

@seedPlanted:
	ld a,(de)
	ld hl,wGashaSpotKillCounters
	rst_addAToHl
	ld a,(hl)
	cp 40
	jr c,@delete

@killedEnoughEnemies:
	call getFreePartSlot
	ret nz

	ld (hl),PARTID_GASHA_TREE
	inc l
	ld (hl),$01
	ld l,Part.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d

	; This interaction will now act as the nut.
	; Adjust x,y positions to be in the center of the tree
	ld h,d
	ld l,Interaction.var37
	ld e,Interaction.yh
	ld a,(de)
	ldi (hl),a
	add $f8
	ld (de),a
	ld e,Interaction.xh
	ld a,(de)
	ldi (hl),a
	add $08
	ld (de),a

	ld a,$04
	call objectSetCollideRadius

	; Set state 3
	ld l,Interaction.state
	ld (hl),$03

	; Load graphics for the nut
	ld l,Interaction.subid
	ld (hl),$0a
	call interactionInitGraphics
	jp objectSetVisible83

; Wait for player to press A button
@state1:
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

@pressedAButton:
	xor a
	ld (de),a
	ld bc,TX_3509
	ld a,(wNumGashaSeeds)
	or a
	jr z,+

	; To state 2
	call interactionIncState
	ld c,<TX_3500
+
	jp showText

; After text box has been shown, selected yes or no
@state2:
	ld a,(wSelectedTextOption)
	or a
	jr z,+

	; Back to state 1
	ld a,$01
	ld (de),a
	ret
+
	call objectGetTileAtPosition
	ld c,l
	ld a,TILEINDEX_SOFT_SOIL_PLANTED
	call setTile

	ld e,Interaction.var03
	ld a,(de)
	ld hl,wGashaSpotsPlantedBitset
	call setFlag

	ld a,(de)
	ld l,<wGashaSpotKillCounters
	rst_addAToHl
	ld (hl),$00

	ld l,<wNumGashaSeeds
	ld a,(hl)
	sub $01
	daa
	ld (hl),a
	ld a,SND_GETSEED
	call playSound
@delete:
	jp interactionDelete

; Wait for link to slash the nut, then drop it
@state3:
	ld e,Interaction.var2a
	ld a,(de)
	cp $ff
	ret nz

	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	; To state 4
	ld h,d
	ld l,Interaction.state
	ld (hl),$04

	ld a,$06
	call objectSetCollideRadius
	ld bc,-$140
	call objectSetSpeedZ

	ld l,Interaction.speed
	ld (hl),SPEED_100

	call objectGetAngleTowardLink
	ld e,Interaction.angle
	ld (de),a
	jp objectSetVisible80

; Wait for the nut to collide with link, show corresponding text
@state4:
	; Dunno why this is necessary
	ld a,(wLinkDeathTrigger)
	or a
	jp nz,interactionDelete

	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr c,+

	; Hasn't collided with link yet
	call objectApplySpeed
	ld c,$20
	jp objectUpdateSpeedZ_paramC
+
	; To state 5
	call interactionIncState

	ld l,Interaction.visible
	res 7,(hl)
	ld bc,TX_3501
	jp showText

@state5:
	; Check if this is the first gasha nut harvested ever
	ld hl,wGashaSpotFlags
	bit 0,(hl)
	jr nz,+
	set 0,(hl)
	ld b,GASHATREASURE_TIER3_RING
	jr @spawnTreasure
+
	; Get a value of 0-4 in 'c', based on the range of wGashaMaturity (0 = best
	; prizes, 4 = worst prizes)
	ld c,$00
	ld hl,wGashaMaturity+1
	ldd a,(hl)
	srl a
	jr nz,++
	ld a,(hl)
	rra
	ld hl,@gashaMaturityValues
--
	cp (hl)
	jr nc,++
	inc hl
	inc c
	jr --
++
	; Get the probability distribution to use, based on 'c' (above) and which gasha
	; spot this is (var03)
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@gashaSpotRanks
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	; a = c*10
	ld a,c
	add a
	ld c,a
	add a
	add a
	add c

	rst_addAToHl
	call getRandomIndexFromProbabilityDistribution

	; If it would be a potion, but he has one already, just refill his health
	ld a,b
	cp GASHATREASURE_POTION
	jr nz,@notPotion

	ld a,TREASURE_POTION
	call checkTreasureObtained
	jr nc,@decGashaMaturity

	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ld (hl),a
	jr @decGashaMaturity

@notPotion:
	; If it would ba a heart piece, but he got it already, give tier 0 ring instead
	cp GASHATREASURE_HEART_PIECE
	jr nz,@decGashaMaturity
	ld hl,wGashaSpotFlags
	bit 1,(hl)
	jr z,+
	inc b
+
	set 1,(hl)

@decGashaMaturity:
	ld hl,wGashaMaturity
	ld a,(hl)
	sub 200
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	; Underflow check
	jr nc,@spawnTreasure
	xor a
	ldd (hl),a
	ld (hl),a

@spawnTreasure:
	; This object, which was previously the nut, will now become the item sprite being
	; held over Link's head; set the subid accordingly.
	ld a,b
	ld e,Interaction.subid
	ld (de),a
	ld hl,@gashaTreasures
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	cp TREASURE_RING
	jr nz,+
	call getRandomRingOfGivenTier
+
	ld b,a
	call giveTreasure

	; Set Link's animation
	ld hl,wLinkForceState
	ld a,LINK_STATE_04
	ldi (hl),a
	ld (hl),$01 ; [wcc50]

	; Set position above Link
	ld hl,w1Link.yh
	ld bc,$f300
	call objectTakePositionWithOffset

	call interactionIncState
	ld l,Interaction.visible
	set 7,(hl)

	ld e,Interaction.subid
	ld a,(de)
	cp GASHATREASURE_HEART_PIECE
	ld a,SND_GETITEM
	call nz,playSound

	; Load graphics, show text
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@lowTextIndices
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_3500
	jp showText

; Text to show upon getting each respective item
@lowTextIndices:
	.db <TX_3503 <TX_3504 <TX_3504 <TX_3504 <TX_3504 <TX_3504 <TX_3505 <TX_3506
	.db <TX_3508 <TX_3507

; Obtained the item and exited the textbox; wait for link's hearts or rupee
; count to update fully, then make the tree disappear
@state6:
	ld hl,wNumRupees
	ld a,(wDisplayedRupees)
	cp (hl)
	ret nz
	inc l
	ld a,(wDisplayedRupees+1)
	cp (hl)
	ret nz

	ld l,<wLinkHealth
	ld a,(wDisplayedHearts)
	cp (hl)
	ret nz

	ld a,SND_FAIRYCUTSCENE
	call playSound

	ld e,Interaction.var03
	ld a,(de)
	ld hl,@gfxHeaderToLoadWhenTreeDisappears
	rst_addAToHl
	ld a,(hl)
	push af
	sub GFXH_39
	ld (wLoadedTreeGfxActive),a

	ld a,GFXH_3d
	call loadGfxHeader
	pop af
	cp GFXH_3d
	call nz,loadGfxHeader

	ldh a,(<hActiveObject)
	ld d,a
	ld h,d
	ld l,Interaction.var37
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a ; [yh] = [var37] (original Y position)
	ld e,Interaction.xh
	ldi a,(hl)
	ld (de),a ; [xh] = [var38] (original X position)

	ld l,Interaction.visible
	res 7,(hl)

	; Make tiles walkable again
	call objectGetTileCollisions
	xor a
	ldi (hl),a
	ldd (hl),a
	ld a,l
	sub $10
	ld l,a
	xor a
	ldi (hl),a
	ldd (hl),a

	; Calculate position in w3VramTiles?
	ld h,a
	ld e,l
	ld a,l
	and $f0
	ld l,a
	ld a,e
	and $0f
	sla l
	rl h
	add l
	ld l,a
	sla l
	rl h
	ld bc,w3VramTiles
	add hl,bc

	; Write calculated position to var3a
	ld e,Interaction.var3a
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	; Do something with w3VramAttributes ($400 bytes ahead)?
	ld bc,$0400
	add hl,bc
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramAttributes
	ld ($ff00+R_SVBK),a
	ld b,$04
---
	ld c,$04
	push bc
--
	ld a,(hl)
	and $f0
	or $04
	ldi (hl),a
	dec c
	jr nz,--

	ld bc,$001c
	add hl,bc
	pop bc
	dec b
	jr nz,---

	pop af
	ld ($ff00+R_SVBK),a
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$08

; Shrinking the tree (cycling through each frame of the animation)
@state7:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,@counter1Done

	dec a
	ld (hl),a
	ret nz

@counter1Done:
	ld a,$08
	ldi (hl),a
	ld a,(hl)
	inc a
	ld (hl),a
	cp $0a
	jr nc,@counter2Done

	ld hl,@treeDisappearanceFrames-1
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	; Retrieve position in w3VramTiles from var3a
	ld e,Interaction.var3a
	ld a,(de)
	ld c,a
	inc e
	ld a,(de)
	ld d,a
	ld e,c

	push hl
	push de
	pop hl
	pop de

	; Draw the next frame of the tree's disappearance
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	ld b,$04
---
	ld c,$04
	push bc
--
	ld a,(de)
	ldi (hl),a
	inc de
	dec c
	jr nz,--

	ld bc,$001c
	add hl,bc
	pop bc
	dec b
	jr nz,---

	pop af
	ld ($ff00+R_SVBK),a
	ld a,UNCMP_GFXH_29
	call loadUncompressedGfxHeader

	ldh a,(<hActiveObject)
	ld d,a
	ld e,Interaction.counter2
	ld a,(de)
	add UNCMP_GFXH_20 - 1
	call loadUncompressedGfxHeader

	call reloadTileMap
	ldh a,(<hActiveObject)
	ld d,a
	ret

@counter2Done:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld e,Interaction.var03
	ld a,(de)
	ld hl,wGashaSpotsPlantedBitset
	call unsetFlag

.ifdef ROM_AGES
.ifndef REGION_JP
	; Overwrite the 4 tiles making up the gasha tree in wRoomLayout
	ld a,TILEINDEX_GASHA_TREE_TL
	call findTileInRoom
	ret nz

	ld e,Interaction.var03
	ld a,(de)
	ld bc,@tileReplacements
	call addAToBc
	ld a,(bc)
	ld b,a
	ld a,b
	ldi (hl),a
	ld (hl),a
	ld a,$0f
	add l
	ld l,a
	ld a,b
	ldi (hl),a
	ld (hl),a
.endif
.endif
	jp interactionDelete

.ifdef ROM_AGES
.ifndef REGION_JP
@tileReplacements:
	.db $3a $1b $1b $3a $3a $bf $3a $bf
	.db $1b $3a $3a $1b $3a $3a $3a $bf
.endif
.endif


; These are values compared with "wGashaMaturity" which set the ranges for gasha prize
; "levels". A value of 300 or higher will give you the highest level prizes.
@gashaMaturityValues:
	.db 300/2
	.db 200/2
	.db 120/2
	.db  40/2
	.db   0/2


@gashaTreasures:
	.db TREASURE_HEART_PIECE, $01
	.db TREASURE_RING, RING_TIER_0
	.db TREASURE_RING, RING_TIER_1
	.db TREASURE_RING, RING_TIER_2
	.db TREASURE_RING, RING_TIER_3
	.db TREASURE_RING, RING_TIER_4
	.db TREASURE_POTION, $01
	.db TREASURE_RUPEES, RUPEEVAL_200
	.db TREASURE_HEART_REFILL, $18
	.db TREASURE_HEART_REFILL, $14


; Each row defines which type of gasha spot each subid is (rank 0 = best).
@gashaSpotRanks:
.ifdef ROM_AGES
	.db @rank1Spot-CADDR ; $00
	.db @rank2Spot-CADDR ; $01
	.db @rank2Spot-CADDR ; $02
	.db @rank1Spot-CADDR ; $03
	.db @rank4Spot-CADDR ; $04
	.db @rank1Spot-CADDR ; $05
	.db @rank1Spot-CADDR ; $06
	.db @rank0Spot-CADDR ; $07
	.db @rank3Spot-CADDR ; $08
	.db @rank2Spot-CADDR ; $09
	.db @rank2Spot-CADDR ; $0a
	.db @rank1Spot-CADDR ; $0b
	.db @rank4Spot-CADDR ; $0c
	.db @rank3Spot-CADDR ; $0d
	.db @rank1Spot-CADDR ; $0e
	.db @rank0Spot-CADDR ; $0f
.else
	.db @rank1Spot-CADDR ; $00
	.db @rank0Spot-CADDR ; $01
	.db @rank0Spot-CADDR ; $02
	.db @rank3Spot-CADDR ; $03
	.db @rank2Spot-CADDR ; $04
	.db @rank3Spot-CADDR ; $05
	.db @rank2Spot-CADDR ; $06
	.db @rank4Spot-CADDR ; $07
	.db @rank1Spot-CADDR ; $08
	.db @rank2Spot-CADDR ; $09
	.db @rank4Spot-CADDR ; $0a
	.db @rank3Spot-CADDR ; $0b
	.db @rank2Spot-CADDR ; $0c
	.db @rank2Spot-CADDR ; $0d
	.db @rank3Spot-CADDR ; $0e
	.db @rank4Spot-CADDR ; $0f
.endif


; Each row corresponds to a certain range for "wGashaMaturity". The first row is the most
; "mature" (occurs later in the game), while the later rows occur earlier in the game.
; Prizes get better as the game goes on.
;
; Each row is a "probability distribution" that adds up to 256. Each byte is a weighting
; for the corresponding treasure (GASHATREASURE_X).

@rank0Spot: ; Best type of spot
	.db $5a $40 $26 $00 $00 $1a $0d $0d $0c $00
	.db $40 $26 $26 $00 $00 $00 $40 $26 $0e $00
	.db $26 $33 $33 $00 $00 $00 $40 $26 $0e $00
	.db $1a $26 $26 $00 $00 $00 $40 $34 $26 $00
	.db $0c $1a $1a $00 $00 $00 $4d $33 $33 $0d
@rank1Spot:
	.db $1a $26 $5a $33 $00 $00 $19 $0d $0d $00
	.db $0d $1a $33 $40 $00 $00 $26 $33 $0d $00
	.db $08 $12 $33 $33 $00 $00 $26 $33 $1a $0d
	.db $05 $0d $1a $3b $00 $00 $26 $33 $26 $1a
	.db $03 $08 $0f $19 $00 $00 $1a $40 $4d $26
@rank2Spot:
	.db $00 $00 $26 $4d $66 $00 $0d $0d $0d $00
	.db $00 $00 $1a $32 $4d $00 $33 $1a $1a $00
	.db $00 $00 $0d $1a $26 $00 $40 $33 $33 $0d
	.db $00 $00 $08 $12 $1a $00 $40 $33 $33 $26
	.db $00 $00 $03 $0d $0d $00 $1a $4b $4b $33
@rank3Spot:
	.db $00 $00 $00 $5a $5a $00 $1a $1a $0c $0c
	.db $00 $00 $00 $33 $33 $00 $33 $33 $1a $1a
	.db $00 $00 $00 $26 $26 $00 $26 $33 $34 $27
	.db $00 $00 $00 $1a $1a $00 $1a $4d $32 $33
	.db $00 $00 $00 $0d $0d $00 $1a $40 $40 $4c
@rank4Spot: ; Worst type of spot
	.db $00 $00 $00 $40 $34 $00 $26 $26 $26 $1a
	.db $00 $00 $00 $26 $26 $00 $26 $33 $34 $27
	.db $00 $00 $00 $1a $26 $00 $26 $33 $34 $33
	.db $00 $00 $00 $12 $1a $00 $21 $33 $40 $40
	.db $00 $00 $00 $0d $0d $00 $0d $40 $4c $4d


; Each entry consists of a 4x4 block of subtiles (8x8 tiles) to draw while the tree is
; disappearing.
@treeDisappearanceFrames:
	.db @frame1-CADDR
	.db @frame1-CADDR
	.db @frame2-CADDR
	.db @frame3-CADDR
	.db @frame4-CADDR
	.db @frame5-CADDR
	.db @frame5-CADDR
	.db @frame6-CADDR
	.db @frame7-CADDR

@frame1:
	.db $20 $21 $22 $23
	.db $24 $25 $26 $27
	.db $28 $29 $2a $2b
	.db $2c $2d $2e $2f
@frame2:
	.db $20 $21 $20 $21
	.db $24 $25 $26 $27
	.db $28 $29 $2a $2b
	.db $20 $2c $2d $2e
@frame3:
	.db $20 $21 $20 $21
	.db $24 $25 $26 $27
	.db $28 $29 $2a $2b
	.db $22 $2c $2d $23
@frame4:
	.db $20 $21 $20 $21
	.db $22 $24 $25 $23
	.db $20 $26 $27 $21
	.db $22 $28 $29 $23
@frame5:
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23
	.db $20 $24 $25 $21
	.db $22 $26 $27 $23
@frame6:
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23
	.db $20 $21 $20 $21
	.db $22 $24 $25 $23
@frame7:
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23


; Each subid loads one of 3 gfx headers while the tree disappears.
@gfxHeaderToLoadWhenTreeDisappears:
.ifdef ROM_AGES
	.db GFXH_3d GFXH_3f GFXH_3f GFXH_3d GFXH_3d GFXH_3e GFXH_3d GFXH_3e
	.db GFXH_3f GFXH_3d GFXH_3d GFXH_3f GFXH_3d GFXH_3d GFXH_3d GFXH_3e
.else
	.db GFXH_3d GFXH_3d GFXH_3d GFXH_3d GFXH_3f GFXH_3d GFXH_3d GFXH_3d
	.db GFXH_3d GFXH_3d GFXH_3d GFXH_3d GFXH_3d GFXH_3e GFXH_3d GFXH_3d
.endif


; ==============================================================================
; INTERACID_KISS_HEART
; ==============================================================================
interactionCodeb7:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state1
	.dw interactionAnimate

@state1:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible82


; ==============================================================================
; INTERACID_BANANA
; ==============================================================================
interactionCodec0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	call interactionAnimate
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECTID_MOOSH_CUTSCENE
	jp nz,interactionDelete

	ld e,Interaction.direction
	ld a,(de)
	ld l,SpecialObject.direction
	cp (hl)
	ld a,(hl)
	jr z,@updatePosition

	; Direction changed

	ld (de),a
	push af
	ld hl,@visibleValues
	rst_addAToHl
	ldi a,(hl)
	ld e,Interaction.visible
	ld (de),a
	pop af
	call interactionSetAnimation

	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld l,SpecialObject.direction
	ld a,(hl)

@updatePosition:
	push hl
	ld hl,@xOffsets
	rst_addAToHl
	ld b,$00
	ld c,(hl)
	pop hl
	jp objectTakePositionWithOffset

@visibleValues:
	.db $83 $83 $80 $83

@xOffsets:
	.db $00 $05 $00 $fb



; ==============================================================================
; INTERACID_CREATE_OBJECT_AT_EACH_TILEINDEX
; ==============================================================================
interactionCodec7:
	ld e,Interaction.subid
	ld a,(de)
	ld c,a
	ld hl,wRoomLayout
	ld b,LARGE_ROOM_HEIGHT*$10
--
	ld a,(hl)
	cp c
	call z,@createObject
	inc l
	dec b
	jr nz,--
	jp interactionDelete

@createObject:
	push hl
	push bc
	ld b,l
	ld e,Interaction.xh
	ld a,(de)
	and $f0
	swap a
	call @spawnObjectType
	jr nz,@ret

	ld e,Interaction.yh
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.xh
	ld a,(de)
	and $0f
	ld (hl),a

	ld a,l
	add Object.yh-Object.subid
	ld l,a
	ld a,b
	and $f0
	add $08
	ldi (hl),a
	inc l
	ld a,b
	and $0f
	swap a
	add $08
	ld (hl),a

@ret:
	pop bc
	pop hl
	ret

;;
; @param	a	0 for enemy; 1 for part; 2 for interaction
; @param[out]	hl	Spawned object
@spawnObjectType:
	or a
	jp z,getFreeEnemySlot
	dec a
	jp z,getFreePartSlot
	dec a
	jp z,getFreeInteractionSlot
	ret

.ends
