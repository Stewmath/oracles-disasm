; ==================================================================================================
; INTERAC_BOY
; ==================================================================================================
interactionCode3c:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw boyState1

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
	.dw @setStoneAnimationAndLoadScript
	.dw @initSubid07
	.dw @initSubid08
	.dw @initSubid09
	.dw @setStoneAnimationAndLoadScript
	.dw @initSubid0b
	.dw @setStoneAnimationAndLoadScript
	.dw @initSubid0d
	.dw @initSubid0e
	.dw @initSubid0f
	.dw @initSubid10


@initSubid03:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	call @saveXToVar3d
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	jr @setRedPaletteAndLoadScript

@initSubid01:
	ld a,$01
	call interactionSetAnimation

@setRedPaletteAndLoadScript:
	ld a,$02
	ld e,Interaction.oamFlags
	ld (de),a
	jp boyLoadScript

@initSubid04:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	ld e,Interaction.counter1
	ld a,$3c
	ld (de),a
	xor a
	call interactionSetAnimation

@saveXToVar3d:
	ld e,Interaction.xh
	ld a,(de)
	ld e,Interaction.var3d
	ld (de),a
	ret

@initSubid05:
	call loadStoneNpcPalette
	ld e,Interaction.oamFlags
	ld a,$06
	ld (de),a
	ld e,Interaction.counter1
	ld a,$3c
	ld (de),a
	ld a,$03
	jp interactionSetAnimation

@setStoneAnimationAndLoadScript:
	ld a,$03
	call interactionSetAnimation
	ld a,$02
	ld e,Interaction.var38
	ld (de),a
	call loadStoneNpcPalette
	jp boyLoadScript

@initSubid0e:
	; Was Veran defeated?
	ld hl,wGroup4RoomFlags+$fc
	bit 7,(hl)
	ld a,<TX_251e
	jr nz,@@notStone

	ld a,(wEssencesObtained)
	bit 6,a
	ld a,<TX_251d
	jr z,@@notStone

	; If Veran's not defeated and d7 is beaten, change position to be in front of his
	; stone dad
	call objectUnmarkSolidPosition
	ld bc,$4848
	call interactionSetPosition
	call objectMarkSolidPosition

	ld h,d
	ld l,Interaction.var03
	inc (hl)

	ld a,$06
	call objectSetCollideRadius
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList

	ld a,<TX_251b
	jr @setTextIDAndLoadScript

@@notStone:
	push af
	xor a
	ld ($cfd3),a

	ldbc INTERAC_BALL,$00
	call objectCreateInteraction
	ld bc,$4a75
	call interactionHSetPosition

	pop af

@setTextIDAndLoadScript:
	ld e,Interaction.textID
	ld (de),a
	jr @setStoneAnimationAndLoadScript

@initSubid00:
	xor a
	call interactionSetAnimation
	jp boyLoadScript

@initSubid02:
	callab agesInteractionsBank09.getGameProgress_1
	ld a,b
	or a
	jr nz,++

	; In the early game, the boy only exists once you've gotten the satchel
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	jp nc,interactionDelete
	xor a
++
	ld hl,boySubid02ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jr boyState1

@initSubid07:
	ld h,d
	ld l,Interaction.var3f
	inc (hl)
	call boyLoadScript
	jr boyState1

@initSubid08:
@initSubid09:
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$78
	jp objectSetVisiblec1

@initSubid0b:
	xor a
	call interactionSetAnimation
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld a,<TX_2519
	jr z,+
	ld a,<TX_251a
+
	ld e,Interaction.textID
	ld (de),a
	inc e
	ld a,>TX_2500
	ld (de),a
	jp boyLoadScript

@initSubid0d:
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jr nz,@@notStone

	call loadStoneNpcPalette
	ld h,d
	ld l,Interaction.oamFlags
	ld (hl),$06
	ld a,$06
	call objectSetCollideRadius
	ld l,Interaction.var03
	inc (hl)
	ld a,$0c
	jp interactionSetAnimation

@@notStone:
	ld bc,$4868
	call interactionSetPosition

	; Load red palette
	ld l,Interaction.oamFlags
	ld (hl),$02

	jp boyLoadScript

@initSubid10:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

@initSubid0f:
	jp boyLoadScript

;;
boyState1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw boyRunSubid00
	.dw boyRunSubid01
	.dw boyRunSubid02
	.dw  boyRunSubid03
	.dw boyRunSubid04
	.dw boyRunSubid05
	.dw boyRunSubid06
	.dw boyRunSubid07
	.dw  boyRunSubid08
	.dw  boyRunSubid09
	.dw boyRunSubid0a
	.dw boyRunSubid0b
	.dw boyRunSubid0c
	.dw boyRunSubid0d
	.dw boyRunSubid0e
	.dw boyRunSubid0f
	.dw boyRunSubid10


; Watching Nayru sing in intro
boyRunSubid00:
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects

	ld e,Interaction.substate
	ld a,(de)
	or a
	call z,objectPreventLinkFromPassing

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)
	cp $0e
	jp nz,interactionRunScript

	call interactionIncSubstate
	ld a,$02
	jp interactionSetAnimation

@substate1:
	call interactionAnimate
	ld a,($cfd0)
	cp $10
	ret nz

	call interactionIncSubstate
	ld bc,-$180
	call objectSetSpeedZ
	ld a,$02
	jp interactionSetAnimation

@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; Run away
	call interactionIncSubstate
	ld l,Interaction.angle
	ld (hl),$02
	ld l,Interaction.speed
	ld (hl),SPEED_180
	xor a
	jp interactionSetAnimation

@substate3:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	jp objectApplySpeed


; Kid turning to stone cutscene
boyRunSubid01:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionRunScript
	ld a,($cfd1)
	cp $01
	jr nz,+
	jp interactionIncSubstate
+
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret z
	jp interactionAnimate2Times

@substate1:
	call interactionRunScript
	ld a,($cfd1)
	cp $02
	jr nz,++

	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$06
	ret
++
	; Flicker palette from red to stone every 8 frames
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld e,Interaction.oamFlags
	ld a,(de)
	xor $04
	ld (de),a
	ret

@substate2:
	call interactionRunScript
	jp nc,interactionAnimate
	ret


; Kid outside shop
boyRunSubid02:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


; Cutscene where kids talk about how they're scared of a ghost (red kid)
; Also called the "other" child interaction?
boyRunSubid03:
	call interactionRunScript

	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed

	call objectCheckWithinScreenBoundary
	ret c

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call getThisRoomFlags
	set 6,(hl)
	jp interactionDelete


; Cutscene where kids talk about how they're scared of a ghost (green kid)
boyRunSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw boyRunSubid03

@substate0:
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp startJump

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	jp boyLoadScript


; Cutscene where kid is restored from stone
boyRunSubid05:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw childSubid05Substate1
	.dw childAnimateIfVar39IsZeroAndRunScript

@substate0:
	call interactionDecCounter1
	ret nz

;;
; Used in cutscenes where people get restored from stone?
setCounter1To120AndPlaySoundEffectAndIncSubstate:
	ld a,120
	ld e,Interaction.counter1
	ld (de),a
	ld a,SND_ENERGYTHING
	call playSound
	jp interactionIncSubstate


childSubid05Substate1:
	call interactionDecCounter1
	jr nz,childFlickerBetweenStone

	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$02
	jp boyLoadScript

;;
; Called from other interactions as well?
childFlickerBetweenStone:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld e,Interaction.oamFlags
	ld a,(de)
	xor $04
	ld (de),a
	ret

childAnimateIfVar39IsZeroAndRunScript:
	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed
	jp interactionRunScript


; Cutscene where kid sees his dad turn to stone
boyRunSubid06:
	call checkInteractionSubstate
	call nz,interactionAnimateBasedOnSpeed
	jp interactionRunScript


; Depressed kid in trade sequence
boyRunSubid07:
	call interactionRunScript
	ld e,Interaction.var3d
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; Kid who runs around in a pattern? Used in a credits cutscene maybe?
; Also called by another interaction?
boyRunSubid08:
boyRunSubid09:
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
	.dw @substate9
	.dw @substateA
	.dw @substateB

@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$66

	ld l,Interaction.speed
	ld (hl),SPEED_140
	ld l,Interaction.angle
	ld (hl),$18

	call interactionIncSubstate

@setAnimationFromAngle:
	ld e,Interaction.angle
	ld a,(de)
	call convertAngleDeToDirection
	jp interactionSetAnimation


@substate1:
	call @updateAnimationTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz

	call getRandomNumber
	and $0f
	add $1e
	ld (hl),a

	ld l,Interaction.angle
	ld (hl),$08
	call @setAnimationFromAngle
	jp interactionIncSubstate

@updateAnimationTwiceAndApplySpeed:
	call interactionAnimate2Times
	jp objectApplySpeed


@substate2:
	call interactionDecCounter1
	ret nz
	call boyStartHop
	jp interactionIncSubstate

@substate3:
	call boyUpdateGravityAndHopWhenLanded
	ld a,($cfd0)
	cp $01
	ret nz

	ld e,Interaction.zh
	ld a,(de)
	or a
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$1e
	ret

@substate4:
	call interactionDecCounter1
	ret nz

	ld l,Interaction.speed
	ld (hl),SPEED_200
	call @updateAngleAndCounter
	jp interactionIncSubstate

@substate5:
	ld a,($cfd0)
	cp $02
	jr nz,++
	ld e,Interaction.zh
	ld a,(de)
	or a
	jr nz,++

	call interactionIncSubstate

	ld l,Interaction.counter1
	ld (hl),$0a
	ld l,Interaction.angle
	ld (hl),$18
	jp @setAnimationFromAngle
++
	ld e,Interaction.var37
	ld a,(de)
	rst_jumpTable
	.dw @@val0
	.dw @@val1
	.dw @@val2

@@val0:
	call @updateAnimationTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz
	ld (hl),$0a

	ld l,Interaction.var37
	inc (hl)
	cp $68
	ld a,$01
	jr c,+
	ld a,$03
+
	jp interactionSetAnimation

@@val1:
	call interactionDecCounter1
	ret nz
	ld (hl),$1e
	ld l,Interaction.var37
	inc (hl)
	jp boyStartHop

@@val2:
	call boyUpdateGravityAndHopWhenLanded
	call interactionDecCounter1
	ret nz

	xor a
	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a

	ld l,Interaction.var37
	ld (hl),$00

;;
@updateAngleAndCounter:
	ld e,Interaction.id
	ld a,(de)
	cp INTERAC_BOY
	jr z,@boy

	; Which interaction is this for?
	ld a,$02
	jr ++

@boy:
	ld e,Interaction.subid
	ld a,(de)
	sub $08
++
	; a *= 9
	ld b,a
	swap a
	sra a
	add b

	ld hl,@movementData
	rst_addAToHl
	ld e,Interaction.counter2
	ld a,(de)
	rst_addDoubleIndex

	ldi a,(hl)
	ld b,(hl)
	inc l
	ld e,Interaction.counter1
	ld (de),a
	ld e,Interaction.angle
	ld a,b
	ld (de),a

	ld e,Interaction.counter2
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
	jp @setAnimationFromAngle


; Data format:
;   b0: Number of frames to move
;   b1: Angle to move in
@movementData:
	.db $1a $09 ; Subid $08
	.db $16 $1f
	.db $17 $17
	.db $0c $0f
	.db $00

	.db $0c $09 ; Subid $09
	.db $18 $0a
	.db $16 $18
	.db $12 $1f
	.db $00

	.db $1d $08 ; Subid $0a
	.db $19 $16
	.db $18 $0a
	.db $06 $01
	.db $00

@substate6:
	call interactionDecCounter1
	ret nz

	ld e,Interaction.id
	ld a,(de)
	ld b,$34
	cp INTERAC_BOY_2
	jr z,+
	ld b,$20
+
	ld (hl),b
	ld l,Interaction.speed
	ld (hl),SPEED_180
	jp interactionIncSubstate


@substate7:
	call @updateAnimationTwiceAndApplySpeed
	call interactionDecCounter1
	ret nz

	call getRandomNumber
	and $07
	inc a
	ld (hl),a

	ld a,$01
	call interactionSetAnimation
	jp interactionIncSubstate


; Waiting for signal to start hopping again
@substate8:
	ld a,($cfd0)
	cp $03
	ret nz
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp boyStartHop


; Waiting for signal to move off the left side of the screen
@substate9:
	call boyUpdateGravityAndHopWhenLanded

	ld a,($cfd0)
	cp $04
	ret nz
	ld e,Interaction.zh
	ld a,(de)
	or a
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$0c
	ret

@substateA:
	call interactionDecCounter1
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$50
	ld l,Interaction.speed
	ld (hl),SPEED_180
	ld a,$03
	jp interactionSetAnimation

@substateB:
	call @updateAnimationTwiceAndApplySpeed
	call interactionDecCounter1
	jp z,interactionDelete
	ret


; Cutscene?
boyRunSubid0a:
	call interactionAnimate
	jp childAnimateIfVar39IsZeroAndRunScript


; NPC in eyeglasses library present
boyRunSubid0b:
	call interactionRunScript
	jp interactionAnimateAsNpc


; Cutscene where kid's dad gets restored from stone
boyRunSubid0c:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw childAnimateIfVar39IsZeroAndRunScript

@substate0:
	call interactionAnimate2Times
	ld a,($cfd1)
	cp $01
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$78

	ld a,$03
	call interactionSetAnimation

	ld a,$3c
	ld bc,$f408
	jp objectCreateExclamationMark

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld bc,-$1c0
	jp objectSetSpeedZ

@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld a,$02
	ld ($cfd1),a
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),120
	ret

@substate3:
	call interactionDecCounter1
	ret nz
	ld (hl),$3c
	jp interactionIncSubstate

@substate4:
	call interactionAnimate2Times
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate


; Kid with grandma who's either stone or was restored from stone
boyRunSubid0d:
	ld e,Interaction.var03
	ld a,(de)
	or a
	jp nz,interactionPushLinkAwayAndUpdateDrawPriority
	call interactionRunScript
	jp npcFaceLinkAndAnimate


; NPC playing catch with dad, or standing next to his stone dad
boyRunSubid0e:
	; Check if his dad is stone
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr z,+

	call interactionAnimate2Times
	jr ++
+
	call interactionRunScript
++
	call interactionPushLinkAwayAndUpdateDrawPriority
	ld h,d
	ld l,Interaction.pressedAButton
	ld a,(hl)
	or a
	ret z

	ld (hl),$00
	ld b,>TX_2500
	ld l,Interaction.textID
	ld c,(hl)
	jp showText

; Subid $0f: Cutscene where kid runs away?
; Subid $10: Kid listening to Nayru postgame
boyRunSubid0f:
boyRunSubid10:
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimateBasedOnSpeed
	jp interactionPushLinkAwayAndUpdateDrawPriority

;;
; Load palette used for turning npcs to stone?
loadStoneNpcPalette:
	ld a,PALH_a2
	jp loadPaletteHeader

;;
boyUpdateGravityAndHopWhenLanded:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

;;
boyStartHop:
	ld bc,-$e0
	jp objectSetSpeedZ

;;
; Load a script for INTERAC_BOY.
boyLoadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.boySubid00Script
	.dw mainScripts.boySubid01Script
	.dw mainScripts.boyStubScript
	.dw mainScripts.boySubid03Script
	.dw mainScripts.boySubid04Script
	.dw mainScripts.boySubid05Script
	.dw mainScripts.boySubid06Script
	.dw mainScripts.boySubid07Script
	.dw mainScripts.boyStubScript
	.dw mainScripts.boyStubScript
	.dw mainScripts.boySubid0aScript
	.dw mainScripts.boySubid0bScript
	.dw mainScripts.boySubid0cScript
	.dw mainScripts.boySubid0dScript
	.dw mainScripts.boySubid0eScript
	.dw mainScripts.boySubid0fScript
	.dw mainScripts.boySubid00Script

boySubid02ScriptTable:
	.dw mainScripts.boySubid02Script_afterGotSeedSatchel
	.dw mainScripts.boySubid02Script_afterd3
	.dw mainScripts.boySubid02Script_afterNayruSaved
	.dw mainScripts.boySubid02Script_afterd7
	.dw mainScripts.boySubid02Script_afterGotMakuSeed
	.dw mainScripts.boySubid02Script_postGame
