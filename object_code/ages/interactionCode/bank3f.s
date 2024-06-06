; ==============================================================================
; INTERACID_MONKEY
;
; Variables:
;   var38/39: Copied to speedZ?
;   var3a:    Animation index?
; ==============================================================================
interactionCode39_body:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw monkeyState1

@state0:
	ld a,$01
	ld (de),a

	ld a,>TX_5700
	call interactionSetHighTextIndex

	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid

	ld e,Interaction.var03
	ld a,(de)
	cp $09
	ret z

	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
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
	ld a,$02
	call interactionSetAnimation

	ld hl,mainScripts.monkeySubid0Script
	jp interactionSetScript


@subid2Init:
	ld a,$02
	ld e,Interaction.oamFlags
	ld (de),a
	ld a,$06
	call interactionSetAnimation
	jr ++

@subid3Init:
	ld a,$07
	call interactionSetAnimation
++
	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	jp nz,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	sub $02
	ld hl,introMonkeyScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript


@subid1Init: ; Subids 4 and 5 calls this too
	ld e,Interaction.var03
	ld a,(de)
	ld c,a
	or a
	jr nz,@doneSpawning

	; Load PALH_ad if this isn't subid 5?
	dec e
	ld a,(de)
	cp $05
	jr z,++
	push bc
	ld a,PALH_ad
	call loadPaletteHeader
	pop bc
++

	; Spawn 9 monkeys
	ld b,$09

@nextMonkey:
	call getFreeInteractionSlot
	jr nz,@doneSpawning

	ld (hl),INTERACID_MONKEY
	inc l
	ld e,Interaction.subid
	ld a,(de)
	ld (hl),a ; Copy subid
	inc l
	ld (hl),b ; [var03] = b
	dec b
	jr nz,@nextMonkey

@doneSpawning:
	; Retrieve var03
	ld a,c
	add a

	ld hl,@monkeyPositions
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a
	ldi a,(hl)
	ld e,Interaction.xh
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.counter1
	ld (de),a
	ld a,(hl)
	call interactionSetAnimation

	; Randomize the animation slightly?
	call getRandomNumber_noPreserveVars
	and $0f
	ld h,d
	ld l,Interaction.counter2
	ld (hl),a
	sub $07
	ld l,Interaction.animCounter
	add (hl)
	ld (hl),a

	; Randomize jump speeds?
	call getRandomNumber
	and $03
	ld bc,@jumpSpeeds
	call addDoubleIndexToBc
	ld l,Interaction.var38
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ld (hl),a
	jp monkeySetJumpSpeed


@jumpSpeeds:
	.dw -$80
	.dw -$a0
	.dw -$70
	.dw -$90


; This table takes var03 as an index.
; Data format:
;   b0: Y
;   b1: X
;   b2: counter1
;   b3: animation
@monkeyPositions:
	.db $58 $88 $f0 $00
	.db $58 $78 $d2 $01
	.db $28 $28 $dc $01
	.db $38 $38 $be $02
	.db $18 $68 $64 $01
	.db $1c $80 $78 $00
	.db $30 $68 $50 $05
	.db $34 $88 $8c $02
	.db $50 $46 $b4 $02
.ifdef REGION_JP
	; Monkey was moved to prevent it from making Link clip into a tree
	.db $64 $18 $b8 $08
.else
	.db $64 $28 $b8 $08
.endif

@subid4Init:
	call objectSetInvisible
	call @subid1Init

	ld l,Interaction.oamFlags
	ld (hl),$06
	ld l,Interaction.counter2
	ld (hl),$3c

	ld l,Interaction.var03
	ld a,(hl)
	cp $09
	jr nz,++

	; Monkey $09: ?
	ld l,Interaction.var3c
	inc (hl)
	ld bc,$6424
	jp interactionSetPosition
++
	cp $08
	ret nz

	; Monkey $08: the monkey with a bowtie
	ld a,$fa
	ld e,Interaction.counter1
	ld (de),a

@initBowtieMonkey:
	ld a,$07
	call interactionSetAnimation

	; Create a bowtie
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_ACCESSORY
	inc l
	ld (hl),$3d
	inc l
	ld (hl),$01

	ld l,Interaction.relatedObj1
	ld (hl),Interaction.start
	inc l
	ld (hl),d

	ld e,Interaction.relatedObj2+1
	ld a,h
	ld (de),a
	ret

@subid5Init:
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jp z,interactionDelete
	call @subid1Init
	ld l,Interaction.counter1
	ldi (hl),a
	ld (hl),a
	ld hl,mainScripts.monkeySubid5Script

	ld e,Interaction.var03
	ld a,(de)
	cp $08
	jr nz,+

	; Bowtie monkey has a different script
	push af
	call @initBowtieMonkey
	ld hl,mainScripts.monkeySubid5Script_bowtieMonkey
	pop af
+
	; Monkey $05 gets the red palette
	cp $05
	ld a,$03
	jr nz,+
	ld a,$02
+
	ld e,Interaction.oamFlags
	ld (de),a
	jp interactionSetScript

@subid6Init:
	ld a,$05
	jp interactionSetAnimation

@subid7Init:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable
	.dw @subid7Init_0
	.dw @subid7Init_1
	.dw @subid7Init_2

@subid7Init_0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jp z,interactionDelete

	ld hl,mainScripts.monkeySubid7Script_0
	call interactionSetScript
	ld a,$06
	jr @setVar3aAnimation

@subid7Init_1:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld hl,mainScripts.monkeySubid7Script_1
	call interactionSetScript
	ld a,$05
	jr @setVar3aAnimation

@subid7Init_2:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_MAKU_TREE_SAVED
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ld hl,mainScripts.monkeySubid7Script_2
	jp z,@setScript
	ld hl,mainScripts.monkeySubid7Script_3
@setScript:
	call interactionSetScript
	ld a,$05

@setVar3aAnimation:
	ld e,Interaction.var3a
	ld (de),a
	jp interactionSetAnimation

monkeyState1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw monkeySubid0State1
	.dw monkeySubid1State1
	.dw monkeySubid2State1
	.dw monkeySubid3State1
	.dw monkeySubid4State1
	.dw monkeySubid5State1
	.dw interactionAnimate
	.dw monkeyAnimateAndRunScript

;;
monkeySubid0State1:
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
	.dw monkeySubid0State1Substate3

@substate0:
	ld a,($cfd0)
	cp $0e
	jp nz,interactionRunScript
	call interactionIncSubstate
	ld a,$06
	jp interactionSetAnimation

@substate1:
	ld a,($cfd0)
	cp $10
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$32
	ld a,$03
	call interactionSetAnimation
	jr monkeyJumpSpeed120

@substate2:
	call interactionDecCounter1
	jr nz,monkeyUpdateGravityAndHop

	call interactionIncSubstate
	ld l,Interaction.angle
	ld (hl),$02
	ld l,Interaction.zh
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),SPEED_180

monkeySetAnimationAndJump:
	call interactionSetAnimation

monkeyJumpSpeed100:
	ld bc,-$100
	jp objectSetSpeedZ

monkeySubid0State1Substate3:
	call objectCheckWithinScreenBoundary
	jr c,++
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	jp interactionDelete
++
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	ld a,$04
	jr monkeySetAnimationAndJump

monkeyUpdateGravityAndHop:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

monkeyJumpSpeed120:
	ld bc,-$120
	jp objectSetSpeedZ

;;
; Updates gravity, and if the monkey landed, resets speedZ to values of var38/var39.
monkeyUpdateGravityAndJumpIfLanded:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

;;
; Sets speedZ to values of var38/var39.
monkeySetJumpSpeed:
	ld l,Interaction.var38
	ldi a,(hl)
	ld e,Interaction.speedZ
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

;;
; Monkey disappearance cutscene
monkeySubid1State1:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable
	.dw monkey0Disappearance
	.dw monkey1Disappearance
	.dw monkey2Disappearance
	.dw monkey3Disappearance
	.dw monkey4Disappearance
	.dw monkey5Disappearance
	.dw monkey6Disappearance
	.dw monkey7Disappearance
	.dw monkey8Disappearance
	.dw monkey9Disappearance


monkey0Disappearance:
monkey1Disappearance:
monkey2Disappearance:
monkey4Disappearance:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw monkeyWaitBeforeFlickering
	.dw monkeyFlickerUntilDeletion

@substate0:
	call interactionAnimate
	call interactionDecCounter2
	ret nz
	jp interactionIncSubstate

@substate1:
	call interactionDecCounter1
	jr nz,+
	jr monkeyBeginDisappearing
+
	call monkeyUpdateGravityAndJumpIfLanded
	jp interactionAnimate

monkeyBeginDisappearing:
	ld (hl),$3c
	ld l,Interaction.oamFlags
	ld (hl),$06
	ld l,Interaction.zh
	ld (hl),$00

	ld a,SND_CLINK
	call playSound
	jp interactionIncSubstate

monkeyWaitBeforeFlickering:
	call interactionDecCounter1
	ret nz
	ld (hl),$3c
	jp interactionIncSubstate

monkeyFlickerUntilDeletion:
	call interactionDecCounter1
	jr nz,+
	jp interactionDelete
+
	ld b,$01
	jp objectFlickerVisibility


monkey3Disappearance:
monkey6Disappearance:
monkey7Disappearance:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw monkeyWaitBeforeFlickering
	.dw monkeyFlickerUntilDeletion

@substate0:
	call interactionDecCounter1
	jp nz,interactionAnimate
	jr monkeyBeginDisappearing


monkey5Disappearance:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw monkeyWaitBeforeFlickering
	.dw monkeyFlickerUntilDeletion

@substate0:
	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$02

@substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$b4
	call interactionIncSubstate
	ld bc,$f3f8
	ld a,$5a
	jp objectCreateExclamationMark

@substate2:
	call interactionDecCounter1
	ret nz
	jp monkeyBeginDisappearing


	; Unused code?
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw monkeyWaitBeforeFlickering
	.dw monkeyFlickerUntilDeletion

@@substate0:
	call interactionDecCounter1
	ret nz
	jr monkeyBeginDisappearing


monkey9Disappearance:
	call monkeyCheckChangeAnimation

	ld e,Interaction.substate
	ld a,(de)
	cp $04
	jr nc,++
	call interactionDecCounter1
	jr nz,++
	call monkeyBeginDisappearing
	ld l,Interaction.substate
	ld (hl),$04
++
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw monkeyWaitBeforeFlickering
	.dw monkeyFlickerUntilDeletion

@substate0:
	ld h,d
	ld l,Interaction.direction
	ld a,$08
	ldi (hl),a
	ld (hl),a

	ld l,Interaction.speed
	ld (hl),SPEED_100
	call interactionIncSubstate
	jp monkeyJumpSpeed100

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	call monkeyJumpSpeed100

	ld l,Interaction.var3c
	inc (hl)
	ld a,(hl)
	cp $03
	ret nz

	call interactionIncSubstate
	ld l,Interaction.var38
	ld (hl),$10
	ret

@substate2:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz

	ld (hl),$10
	call interactionIncSubstate

	ld l,Interaction.direction
	ld a,(hl)
	xor $10
	ldi (hl),a
	ld (hl),a

	ld l,Interaction.angle
	ld a,(hl)
	and $10
	ld a,$03
	jr nz,+
	ld a,$08
+
	jp monkeySetAnimationAndJump

@substate3:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz

	ld l,Interaction.var3c
	ld (hl),$00
	ld l,Interaction.substate
	dec (hl)
	dec (hl)
	ret

;;
; Checks if the monkey is in the air, updates var3a and animation accordingly?
monkeyCheckChangeAnimation:
	ld h,d
	ld l,Interaction.zh
	ld a,(hl)
	sub $03
	cp $fa
	ld a,$00
	jr nc,+
	inc a
+
	ld l,Interaction.var3a
	cp (hl)
	ret z
	ld (hl),a
	ld l,Interaction.animCounter
	ld (hl),$01
	jp interactionAnimate


monkey8Disappearance:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw monkeyWaitBeforeFlickering
	.dw @substate3
	.dw @substate4

@substate0:
	call interactionDecCounter1
	jr nz,++
	ld (hl),$5a
	call interactionIncSubstate
	ld bc,$f3f8
	ld a,$3c
	jp objectCreateExclamationMark
++
	ld a,(wFrameCounter)
	and $01
	ret nz
	jp interactionAnimate

@substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$b4
	jp interactionIncSubstate

@substate2:
	call interactionDecCounter1
	jr nz,+
	jp monkeyBeginDisappearing
+
	ld a,(wFrameCounter)
	and $0f
	ret nz
	ld l,Interaction.direction
	ld a,(hl)
	xor $01
	ld (hl),a
	jp interactionSetAnimation

@substate3:
	call interactionDecCounter1
	jr nz,++
	ld (hl),$1e
	call objectSetInvisible
	jp interactionIncSubstate
++
	ld b,$01
	jp objectFlickerVisibility

@substate4:
	call interactionDecCounter1
	ret nz
	ld a,$ff
	ld ($cfdf),a
	jp interactionDelete

;;
; Monkey that only exists before intro
monkeySubid2State1:
monkeySubid3State1:
	call interactionRunScript
	jp interactionAnimateAsNpc


;;
monkeySubid4State1:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable
	.dw @monkey0
	.dw @monkey0
	.dw @monkey0
	.dw @monkey3
	.dw @monkey0
	.dw @monkey3
	.dw @monkey3
	.dw @monkey3
	.dw @monkey3
	.dw @monkey9

@monkey0:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4_0

@substate0:
	call interactionDecCounter2
	ret nz
	jp interactionIncSubstate

@substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$3c
	ld l,Interaction.var03
	ld a,(hl)
	cp $08
	jr nz,++
	ld a,Object.enabled
	call objectGetRelatedObject2Var
	ld l,Interaction.oamFlags
	ld (hl),$06
++
	ld a,SND_GALE_SEED
	call playSound
	jp interactionIncSubstate

@substate2:
	call interactionDecCounter1
	jr nz,++
	ld (hl),$3c
	call objectSetVisible
	jp interactionIncSubstate
++
	ld b,$01
	jp objectFlickerVisibility

@substate3:
	call interactionDecCounter1
	ret nz
	ld b,$03
	ld l,Interaction.var03
	ld a,(hl)
	cp $05
	jr nz,+
	dec b
	jr ++
+
	cp $08
	jr nz,++
	ld a,Object.enabled
	call objectGetRelatedObject2Var
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$b4
++
	ld l,Interaction.oamFlags
	ld (hl),b
	jp interactionIncSubstate

@substate4_0:
	call monkeyUpdateGravityAndJumpIfLanded

@substate4_1:
	call interactionAnimate
	ld e,Interaction.var03
	ld a,(de)
	cp $08
	ret nz
	call interactionDecCounter1
	ret nz
	ld a,$ff
	ld ($cfdf),a
	ret

@monkey3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4_1

@monkey9:
	ld e,Interaction.substate
	ld a,(de)
	cp $04
	call nc,monkeyCheckChangeAnimation
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw monkey9Disappearance@substate0
	.dw monkey9Disappearance@substate1
	.dw monkey9Disappearance@substate2
	.dw monkey9Disappearance@substate3


;;
monkeySubid5State1:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable
	.dw @monkey0
	.dw @monkey0
	.dw @monkey0
	.dw monkeyAnimateAndRunScript
	.dw @monkey0
	.dw monkeyAnimateAndRunScript
	.dw monkeyAnimateAndRunScript
	.dw monkeyAnimateAndRunScript
	.dw monkeyAnimateAndRunScript
	.dw monkeySubid5State1_monkey9

@monkey0:
	call monkeyUpdateGravityAndJumpIfLanded

monkeyAnimateAndRunScript:
	call interactionRunScript
	jp interactionAnimateAsNpc

monkeySubid5State1_monkey9:
	call interactionRunScript
	call monkeyCheckChangeAnimation
.ifdef REGION_JP
	call objectPreventLinkFromPassing
.else
	call objectPushLinkAwayOnCollision
.endif
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw monkey9Disappearance@substate0
	.dw monkey9Disappearance@substate1
	.dw monkey9Disappearance@substate2
	.dw monkey9Disappearance@substate3

introMonkeyScriptTable:
	.dw mainScripts.monkeySubid2Script
	.dw mainScripts.monkeySubid3Script


; ==============================================================================
; INTERACID_RABBIT
; ==============================================================================
interactionCode4b_body:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

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
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2
	.dw @initSubid3
	.dw @initSubid4
	.dw @initSubid5
	.dw @initSubid6
	.dw @initSubid7

@initSubid0:
	ld hl,mainScripts.rabbitScript_listeningToNayruGameStart
	jp interactionSetScript

; This is also called from outside this interaction's code
@initSubid1:
	ld h,d
	ld l,Interaction.angle
	ld (hl),$18
	ld l,Interaction.speed
	ld (hl),SPEED_180

@setJumpAnimation:
	ld a,$05
	call interactionSetAnimation

	ld bc,-$180
	jp objectSetSpeedZ

@initSubid2:
	ld e,Interaction.counter1
	ld a,180
	ld (de),a
	callab agesInteractionsBank08.loadStoneNpcPalette
	jp rabbitSubid2SetRandomSpawnDelay

@initSubid6:
	; Delete if veran defeated
	ld hl,wGroup4Flags+$fc
	bit 7,(hl)
	jp nz,interactionDelete

	; Delete if haven't beaten Jabu
	ld a,(wEssencesObtained)
	bit 6,a
	jp z,interactionDelete

	callab agesInteractionsBank08.loadStoneNpcPalette
	ld a,$06
	call objectSetCollideRadius

@initSubid3:
	ld a,120
	ld e,Interaction.counter1
	ld (de),a

@setStonePaletteAndAnimation:
	ld a,$06
	ld e,Interaction.oamFlags
	ld (de),a
	jp interactionSetAnimation

@initSubid5:
	call interactionLoadExtraGraphics
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$0e
	inc l
	ld (hl),$01
	jr @setStonePaletteAndAnimation

@initSubid4:
	call interactionLoadExtraGraphics
	jp rabbitJump

@initSubid7:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_MAKU_TREE_SAVED
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ld hl,mainScripts.rabbitScript_waitingForNayru1
	jp z,+
	ld hl,mainScripts.rabbitScript_waitingForNayru2
+
	call interactionSetScript

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw rabbitSubid0
	.dw rabbitSubid1
	.dw rabbitSubid2
	.dw rabbitSubid3
	.dw rabbitSubid4
	.dw rabbitSubid5
	.dw interactionPushLinkAwayAndUpdateDrawPriority
	.dw rabbitSubid7


; Listening to Nayru at the start of the game
rabbitSubid0:
	call interactionAnimateAsNpc
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
	ld a,($cfd0)
	cp $10
	jp nz,interactionRunScript

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),40
	ret

@substate2:
	call interactionDecCounter1
	jp nz,interactionAnimate

	call interactionIncSubstate
	ld l,Interaction.angle
	ld (hl),$06
	ld l,Interaction.speed
	ld (hl),SPEED_180

@jump:
	ld bc,-$200
	call objectSetSpeedZ
	ld a,$04
	jp interactionSetAnimation

@substate3:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	jr @jump


rabbitSubid1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,@updateSubstate
	dec (hl)
	jr nz,@updateSubstate

	inc l
	ld a,30 ; [counter2] = 30

	ld (hl),a
	ld l,Interaction.substate
	ld (hl),$02
	ld bc,$f000
	call objectCreateExclamationMark

@updateSubstate:
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

; This is also called by subids 1 and 3
@substate0:
	call interactionAnimate
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z
	ld a,SND_JUMP
	call playSound
	jp interactionIncSubstate

; This is also called by subids 1 and 3
@substate1:
	ld e,Interaction.xh
	ld a,(de)
	cp $d0
	jp nc,interactionDelete

	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld h,d
	ld l,Interaction.substate
	dec (hl)
	jp interactionCode4b_body@setJumpAnimation

@substate2:
	call interactionDecCounter2
	ret nz

	ld (hl),60
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3d
	ld (hl),a
	jp interactionIncSubstate

@substate3:
	callab agesInteractionsBank08.interactionOscillateXRandomly
	call interactionDecCounter2
	ret nz
	ld (hl),20

	; Set stone color
	ld l,Interaction.oamFlags
	ld (hl),$06

	jp interactionIncSubstate

@substate4:
	call interactionDecCounter2
	ret nz

	ld bc,$0000
	call objectSetSpeedZ
	jp interactionIncSubstate

@substate5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter2
	ld (hl),240
	ld a,$04
	jp setScreenShakeCounter

@substate6:
	call interactionDecCounter2
	ret nz
	ld a,$ff
	ld ($cfdf),a
	ret


; "Controller" for the cutscene where rabbits turn to stone? (spawns subid $01)
rabbitSubid2:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	call z,spawnNextRabbitThatTurnsToStone
+
	; After a random delay, spawn a rabbit that just runs across the screen (doesn't
	; turn to stone)
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz

	call getRandomNumber_noPreserveVars
	and $07
	ld hl,rabbitSubid2YPositions
	rst_addAToHl
	ld b,(hl)
	call getRandomNumber
	and $0f
	cpl
	inc a
	add $b0
	ld c,a
	call spawnRabbitWithSubid1
	jp rabbitSubid2SetRandomSpawnDelay


; Rabbit being restored from stone cutscene (gets restored and jumps away)
rabbitSubid3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw rabbitSubid1@substate0
	.dw rabbitSubid1@substate1

@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$5a
	ld a,$01
	ld ($cfd1),a
	ld a,SND_RESTORE
	call playSound
	jp interactionIncSubstate

; This is also called from subid 5
@substate1:
	call interactionDecCounter1
	jr z,+
	jpab agesInteractionsBank08.childFlickerBetweenStone
+
	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld l,Interaction.var38
	ld (hl),$20
	jp interactionCode4b_body@initSubid1


; Rabbit being restored from stone cutscene (the one that wasn't stone)
rabbitSubid4:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw rabbitSubid4Substate2
	.dw rabbitSubid5@substate3
	.dw rabbitSubid5@ret

@substate0:
	ld a,($cfd1)
	cp $01
	jr nz,++

	ld h,d
	ld l,Interaction.substate
	ld (hl),$02
	ld hl,mainScripts.rabbitSubid4Script
	jp interactionSetScript
++
	call interactionAnimate
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld h,d
	ld l,Interaction.substate
	dec (hl)

;;
rabbitJump:
	ld a,$07
	call interactionSetAnimation
	ld bc,-$e0
	jp objectSetSpeedZ


rabbitSubid4Substate2:
	ld a,($cfd1)
	cp $02
	jp nz,interactionRunScript

	call interactionIncSubstate
	ld l,Interaction.angle
	ld (hl),$18

	ld l,Interaction.speed
	ld (hl),SPEED_a0
	ld bc,-$180
	call objectSetSpeedZ

	ld a,$09
	jp interactionSetAnimation

rabbitSubid5:
	ld h,d
	ld l,Interaction.var38
	ld a,(hl)
	or a
	jr z,@updateSubstate
	dec (hl)
	jr nz,@updateSubstate

	; Just collided with another rabbit?

	ld l,Interaction.substate
	ld (hl),$04
	ld l,Interaction.angle
	ld (hl),$08

	ld l,Interaction.speed
	ld (hl),SPEED_a0
	ld bc,-$1e0
	call objectSetSpeedZ

	ldbc INTERACID_CLINK,$80
	call objectCreateInteraction
	jr nz,@label_3f_367

	ld a,SND_DAMAGE_ENEMY
	call playSound
	ld a,$02
	ld ($cfd1),a

@label_3f_367:
	ld a,$08
	call interactionSetAnimation

@updateSubstate:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw rabbitSubid3@substate1
	.dw rabbitSubid1@substate0
	.dw rabbitSubid1@substate1
	.dw @substate3
	.dw @substate4

@substate0:
	ld h,d
	ld l,Interaction.counter1
	call decHlRef16WithCap
	ret nz

	ld (hl),$5a
	call interactionIncSubstate
	ld a,SND_RESTORE
	jp playSound

; Also called from subid 4
@substate3:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZAndBounce
	ret nc

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3c

@ret:
	ret

@substate4:
	call interactionDecCounter1
	ret nz

	ld a,$ff
	ld ($cfdf),a
	ret


; Generic NPC waiting around in the spot Nayru used to sing
rabbitSubid7:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

;;
; This might be setting one of 4 possible speed values to var38?
rabbitSubid2SetRandomSpawnDelay:
	call getRandomNumber_noPreserveVars
	and $03
	ld bc,rabbitSubid2SpawnDelays
	call addAToBc
	ld a,(bc)
	ld e,Interaction.var38
	ld (de),a
	ret

;;
; hl should point to "counter1".
spawnNextRabbitThatTurnsToStone:
	; Increment counter2, the index of the rabbit to spawn (0-2)
	inc l
	ld a,(hl)
	inc (hl)

	ld b,a
	add a
	add b
	ld hl,@data
	rst_addAToHl
	ldi a,(hl)
	ld e,Interaction.counter1
	ld (de),a
	ld b,(hl)
	inc hl
	ld c,(hl)

	; Spawn a rabbit that will turn to stone after 95 frames
	call spawnRabbitWithSubid1
	ld l,Interaction.counter1
	ld (hl),95
	ret

; Data for the rabbits that turn to stone in a cutscene. Format:
;   b0: Frames until next rabbit is spawned?
;   b1: Y position
;   b2: X position
@data:
	.db $5a $28 $b8
	.db $1e $40 $a8
	.db $00 $50 $c8

;;
; Spawns a rabbit for the cutscene where a bunch of rabbits turn to stone
;
; @param	bc	Position
spawnRabbitWithSubid1;
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_RABBIT
	inc l
	inc (hl)
	jp interactionHSetPosition


; A byte from here is chosen randomly to spawn a rabbit at.
rabbitSubid2YPositions:
	.db $66 $5e $58 $46 $3a $30 $20 $18

; A byte from here is chosen randomly as a delay before spawning another rabbit.
rabbitSubid2SpawnDelays:
	.db $1e $3c $50 $78


; ==============================================================================
; INTERACID_TUNI_NUT
; ==============================================================================
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

	ldbc INTERACID_SPARKLE, $07
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
