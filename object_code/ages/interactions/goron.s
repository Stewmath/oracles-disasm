; ==================================================================================================
; INTERAC_GORON
;
; Variables:
;   var3f: Nonzero when "napping" (link is far away)
; ==================================================================================================
interactionCode66:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw goronSubid00
	.dw goronSubid01
	.dw goronSubid02
	.dw goronSubid03
	.dw goronSubid04
	.dw goronSubid05
	.dw goronSubid06
	.dw goronSubid07
	.dw goronSubid08
	.dw goronSubid09
	.dw goronSubid0a
	.dw goronSubid0b
	.dw goronSubid0c
	.dw goronSubid0d
	.dw goronSubid0e
	.dw goronSubid0f
.ifndef REGION_JP
	.dw goronSubid10
.endif


; Graceful goron
goronSubid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4


; State 0: Initialization
@state0:
	call goron_initGraphicsAndIncState

	; Set palette (red/blue for past/present)
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	ld a,$01
	jr z,+
	ld a,$02
+
	ld e,Interaction.oamFlags
	ld (de),a

	; Load goron or subrosian dancers
	ld hl,objectData.goronDancers
	call checkIsLinkedGame
	jr z,@loadDancers
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@loadDancers
	ld hl,objectData.subrosianDancers
@loadDancers:
	call parseGivenObjectData

	ld b,wTmpcfc0.goronDance.dataEnd - wTmpcfc0.goronDance
	ld hl,wTmpcfc0.goronDance
	call clearMemory

	ld a,$02
	ld (wTmpcfc0.goronDance.danceAnimation),a

	xor a
	ld hl,goronDanceScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript


; State 1: waiting for script to end as a signal to start the dance minigame
@state1:
	call interactionRunScript
	jp c,@scriptDone
	jp npcFaceLinkAndAnimate

@scriptDone:
	; Dance begins when script ends
	ld b,$0a
	callab agesInteractionsBank08.shootingGallery_initializeGameRounds

	ld a,DIR_DOWN
	ld (wTmpcfc0.goronDance.danceAnimation),a
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30


; State 2: demonstrating dance sequence
@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state2Substate0
	.dw @state2Substate1
	.dw @state2Substate2
	.dw @state2Substate3
	.dw @state2Substate4

; Waiting to begin round
@state2Substate0:
	call interactionDecCounter1
	jp nz,@pushLinkAway

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),90
	ld a,SND_WHISTLE
	call playSound
	call goronDance_initNextRound

@state2Substate1:
	call interactionDecCounter1
	jp nz,@pushLinkAway
	call interactionIncSubstate
	jr @nextMove


; Waiting until doing the next "beat" of the dance
@state2Substate2:
	call interactionDecCounter1
	jr nz,@pushLinkAway

	call goronDance_incBeat
@nextMove:
	call goronDance_getNextMove
	jr nz,@finishedDemonstration

	call goronDance_updateConsecutiveBPressCounter
	call goronDance_updateGracefulGoronAnimation
	jr z,@jump

	call goronDance_playMoveSound
	ld h,d
	ld l,Interaction.counter1
	ld (hl),20

@pushLinkAway:
	jp interactionPushLinkAwayAndUpdateDrawPriority

@jump:
	; Jump after 5 consecutive B presses
	ld h,d
	ld l,Interaction.substate
	ld (hl),$03

	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.speedZ
	ld (hl),<(-$200)
	inc hl
	ld (hl),>(-$200)

	ld l,Interaction.counter1
	ld (hl),20
	ld a,SND_GORON_DANCE_B
	call playSound
	jp interactionPushLinkAwayAndUpdateDrawPriority


@finishedDemonstration:
	ld h,d
	ld l,Interaction.substate
	ld (hl),$04
	ld l,Interaction.counter1
	ld (hl),60
	ld a,DIR_DOWN
	call interactionSetAnimation
	jr @pushLinkAway


; Waiting to land if he jumped
@state2Substate3:
	call interactionDecCounter1
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@@landed

	ld h,d
	ld l,Interaction.speedZ+1
	ldd a,(hl)
	or (hl)
	jr nz,@pushLinkAway

	ld a,DIR_DOWN
	ld (wTmpcfc0.goronDance.danceAnimation),a
	call interactionSetAnimation
	jr @pushLinkAway

@@landed:
	ld h,d
	ld l,Interaction.substate
	ld (hl),$02
	jp @state2Substate2


; Counting down until going to state 3 (where Link replicates the dance)
@state2Substate4:
	call interactionDecCounter1
	jr nz,@pushLinkAway
	call interactionIncState
	ld l,Interaction.substate
	ld (hl),$00
	jr @pushLinkAway


; State 3: Link playing back dance sequence
@state3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state3Substate0
	.dw @state3Substate1
	.dw @state3Substate2
	.dw @state3Substate3
	.dw @state3Substate4

@state3Substate0:
	call interactionIncSubstate
	call goronDance_clearDanceVariables
	ld a,SND_WHISTLE
	call playSound

	ld a,DIR_DOWN
	ld (wTmpcfc0.goronDance.danceAnimation),a

	call goronDance_turnLinkToDirection
	jp @pushLinkAway

@state3Substate1:
	call goronDance_updateFrameCounter
	call goronDance_checkLinkInput
	jp @pushLinkAway

@state3Substate2:
	call goronDance_updateFrameCounter
	ld a,(wTmpcfc0.goronDance.linkJumping)
	or a
	jp nz,@pushLinkAway

	ld h,d
	ld l,Interaction.substate
	dec (hl)
	jp @pushLinkAway

@state3Substate3:
	call interactionDecCounter1
	jp nz,@pushLinkAway
	ld a,(wTmpcfc0.goronDance.roundIndex)
	cp $08
	jr z,@endDanceAndUpdateNpc

@nextRoundAndUpdateNpc:
	call @nextRound
	jp @pushLinkAway

@endDanceAndUpdateNpc:
	call @endDance
	jp @pushLinkAway


; Messed up?
@state3Substate4:
	ld e,Interaction.var3f
	ld a,(de)
	rst_jumpTable
	.dw @@initializeScript
	.dw @@runScript

@@initializeScript:
	call interactionDecCounter1
	jp nz,@pushLinkAway
	ld a,$01
	ld (wTmpcfc0.goronDance.cfd9),a
	ld hl,wTmpcfc0.goronDance.roundIndex
	inc (hl)
	ld hl,wTmpcfc0.goronDance.numFailedRounds
	inc (hl)
	ld a,(hl)
	cp $03
	jr z,++

	ld a,(wTmpcfc0.goronDance.roundIndex)
	cp $08
	jr z,@endDanceAndUpdateNpc
++
	ld h,d
	ld l,Interaction.var3f
	inc (hl)
	ld a,$01
	ld hl,goronDanceScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

@@runScript:
	call interactionRunScript
	jp nc,@pushLinkAway
	jp @nextRoundAndUpdateNpc

@nextRound:
	; Go to state 2 (begin next round)
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
	inc l
	ld (hl),$00
	ld l,Interaction.counter1
	ld (hl),30
	jr @resetDanceAnimationToDown

@endDance:
	; Go to state 4 (finished the whole minigame)
	ld h,d
	ld l,Interaction.state
	ld (hl),$04
	inc l
	ld (hl),$00
	ld l,Interaction.counter1
	ld (hl),60

@resetDanceAnimationToDown:
	xor a
	ld (wTmpcfc0.goronDance.linkStartedDance),a
	ld a,DIR_DOWN
	ld (wTmpcfc0.goronDance.danceAnimation),a
	jp goronDance_turnLinkToDirection


; State 4: dance ended successfully
@state4:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state4Substate0
	.dw @state4Substate1

@state4Substate0:
	call interactionIncSubstate
	xor a
	ld (wTmpcfc0.goronDance.linkStartedDance),a

	; Run script to give prize
	ld a,$02
	ld hl,goronDanceScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

@state4Substate1:
	call interactionRunScript
	jp nc,@pushLinkAway
	jp @pushLinkAway



; Goron support dancer. Code also used by subrosian subid $01?
goronSubid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call goron_loadScript

@faceDown:
	ld a,DIR_DOWN
	call interactionSetAnimation


; State 1: just running the script
@state1:
	ld a,(wTmpcfc0.goronDance.linkStartedDance)
	or a
	jr nz,@gotoState2
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

@gotoState2:
	call interactionIncState
	jr @updateAnimation


; State 2: doing whatever animation the dance dictates
@state2:
	ld a,(wTmpcfc0.goronDance.linkStartedDance)
	or a
	jr z,@gotoState1

@updateAnimation:
	; Copy Link's z position (for when he jumps)
	ld hl,w1Link.z
	ld e,Interaction.z
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	; Set animation based on whatever Link or the graceful goron is doing
	ld a,(wTmpcfc0.goronDance.danceAnimation)
	call interactionSetAnimation
	jp goronSubid00@pushLinkAway

@gotoState1:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	jp @faceDown


; A "fake" goron object that manages jumping in the dancing minigame?
goronSubid02:
	call checkInteractionState
	jr nz,@state1

@state0:
	call objectSetInvisible
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.speedZ
	ld (hl),<(-$200)
	inc hl
	ld (hl),>(-$200)

	ld l,Interaction.counter1
	ld (hl),20

	ld hl,w1Link.yh
	call objectTakePosition

	ld a,DIR_UP
	ld (wTmpcfc0.goronDance.danceAnimation),a
	call goronDance_turnLinkToDirection

	ld a,SND_GORON_DANCE_B
	call playSound

@state1:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,@landed

	ld hl,w1Link.yh
	call objectCopyPosition
	ld h,d
	ld l,Interaction.speedZ+1
	ldd a,(hl)
	or (hl)
	ret nz

	ld a,DIR_DOWN
	jp goronDance_turnLinkToDirection

@landed:
	ld hl,w1Link.yh
	call objectCopyPosition
	xor a
	ld (wTmpcfc0.goronDance.linkJumping),a
	jp interactionDelete


; Subid $03: Cutscene where goron appears after beating d5; the guy who digs a new tunnel.
; Subid $04: Goron pacing back and forth, worried about elder.
goronSubid03:
goronSubid04:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_loadScriptAndInitGraphics
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


; An NPC in the past cave near the elder? var03 ranges from 0-5.
goronSubid05:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_loadScriptFromTableAndInitGraphics
	call interactionRunScript
@state1:
	jr goron_runScriptAndDeleteWhenFinished


; NPC trying to break the elder out of the rock.
goronSubid06:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_loadScriptFromTableAndInitGraphics
	ld l,Interaction.var3e
	ld (hl),$0a
	ld e,Interaction.var03
	ld a,(de)

.ifdef REGION_JP
	cp $01
	jr nz,++
.else
	or a
	jr nz,+
	ld (wTmpcfc0.goronCutscenes.elderVar_cfdd),a
	jr ++
+
.endif

	ld b,wTmpcfc0.goronCutscenes.dataEnd - wTmpcfc0.goronCutscenes
	ld hl,wTmpcfc0.goronCutscenes
	call clearMemory
++
	call interactionRunScript
@state1:
	jr goron_runScriptAndDeleteWhenFinished


; Various NPCs...
goronSubid07:
goronSubid08:
goronSubid0a:
goronSubid0c:
goronSubid0d:
goronSubid0e:
goronSubid10:
	call checkInteractionState
	jr nz,goron_runScriptAndDeleteWhenFinished

	; State 0 (Initialize)
	call goron_loadScriptAndInitGraphics
	call interactionRunScript

goron_runScriptAndDeleteWhenFinished:
	call interactionRunScript
	jp c,interactionDelete

goron_faceLinkAndAnimateIfNotNapping:
	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc


; Target carts gorons; var03 = 0 or 1 for gorons on left and right.
goronSubid09:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr nz,@rightGuy

@leftGuy:
	call goron_loadScriptFromTableAndInitGraphics
	xor a
	ld (wTmpcfc0.targetCarts.cfdf),a
	ld (wTmpcfc0.targetCarts.beginGameTrigger),a

	; Reload crystals in first room if the game is in progress
	call getThisRoomFlags
	bit 7,(hl)
	jr z,++
	callab scriptHelp.goron_targetCarts_reloadCrystalsInFirstRoom
++
	call interactionRunScript
	jr @state1

@rightGuy:
	call goron_loadScriptFromTableAndInitGraphics
	call interactionRunScript
	jr @state1

@state1:
	jr goron_runScriptAndDeleteWhenFinished


; Goron running the big bang game
goronSubid0b:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_loadScriptFromTableAndInitGraphics
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDelete
	ld e,Interaction.var3e
	ld a,(de)
	or a
	ret nz
	jr goron_faceLinkAndAnimateIfNotNapping


; Linked NPC telling you the biggoron secret.
goronSubid0f:
	call checkInteractionState
	jr nz,@state1

@state0:
	call goron_initGraphicsAndIncState
	ld l,Interaction.var3f
	ld (hl),$08
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript
@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

;;
goronDance_updateFrameCounter:
	ld a,(wTmpcfc0.goronDance.linkStartedDance)
	or a
	ret z
	ld hl,wTmpcfc0.goronDance.frameCounter
	jp incHlRef16WithCap

;;
goronDance_initNextRound:
	ld a,(wTmpcfc0.goronDance.remainingRounds)
	or a
	jr z,goronDance_clearDanceVariables
	callab agesInteractionsBank08.shootingGallery_getNextTargetLayout

;;
goronDance_clearDanceVariables:
	xor a
	ld (wTmpcfc0.goronDance.linkJumping),a
	ld (wTmpcfc0.goronDance.linkStartedDance),a
	ld (wTmpcfc0.goronDance.frameCounter),a
	ld (wTmpcfc0.goronDance.frameCounter+1),a
	ld (wTmpcfc0.goronDance.currentMove),a
	ld (wTmpcfc0.goronDance.consecutiveBPressCounter),a
	ld (wTmpcfc0.goronDance.cfd9),a
	ld (wTmpcfc0.goronDance.beat),a
	ret

;;
; Waits for input from Link, checks for round failure conditions, updates link and goron
; animations when input is good, etc.
goronDance_checkLinkInput:
	call goronDance_getNextMove
	cp $00
	jr z,@rest

	call goronDance_checkTooLateToInput
	jr z,@tooLate

	ld a,(wGameKeysJustPressed)
	and (BTN_A | BTN_B)
	ret z

	ld b,a
	ld (wTmpcfc0.goronDance.linkStartedDance),a
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp b
	jr nz,@wrongMove

	; Check if too early
	call goronDance_checkInputNotTooEarlyOrLate
	jr z,@madeMistake
	jp @doDanceMove

@rest:
	call goronDance_checkExactInputTimePassed
	jr z,@doDanceMove
	ld a,(wGameKeysJustPressed)
	and $03
	jr nz,@wrongMove
	ret

@tooLate:
	ld a,$01
	ld (wTmpcfc0.goronDance.failureType),a
	jr @madeMistake

@wrongMove:
	ld a,$02
	ld (wTmpcfc0.goronDance.failureType),a

@madeMistake:
	ld h,d
	ld l,Interaction.substate
	ld (hl),$04
	ld l,Interaction.var3f
	ld (hl),$00
	ld l,Interaction.counter1
	ld (hl),30

	ld a,SND_ERROR
	call playSound

	ld a,LINK_ANIM_MODE_COLLAPSED
	ld (wcc50),a

	call checkIsLinkedGame
	jr z,@gorons
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@gorons

@subrosians:
	ld a,$02
	ld (wTmpcfc0.goronDance.danceAnimation),a
	ret
@gorons:
	ld a,$04
	ld (wTmpcfc0.goronDance.danceAnimation),a
	ret

@doDanceMove:
	call goronDance_updateConsecutiveBPressCounter
	call goronDance_updateLinkAndBackupDancerAnimation
	jr z,@jump

	call goronDance_playMoveSound
	call goronDance_incBeat
	call goronDance_getNextMove
	jr nz,@roundFinished
	ret

@jump:
	call goronDance_incBeat
	call goronDance_getNextMove
	call getFreeInteractionSlot
	ret nz

	; Spawn a goron with subid $02? (A "fake" object that manages a jump?)
	ld (hl),INTERAC_GORON
	inc l
	ld (hl),$02
	ld a,$01
	ld (wTmpcfc0.goronDance.linkJumping),a
	jp interactionIncSubstate

@roundFinished:
	xor a
	ld (wTmpcfc0.goronDance.cfd9),a
	ld hl,wTmpcfc0.goronDance.roundIndex
	inc (hl)

	ld h,d
	ld l,Interaction.substate
	ld (hl),$03
	ld l,Interaction.counter1
	ld (hl),30
	ret

;;
; @param[out]	zflag	z if too early or too late
goronDance_checkInputNotTooEarlyOrLate:
	call goronDance_getCurrentAndNeededFrameCounts

	; Add 8 to hl, 8 to bc (the "expected" moment to press the button?)
	ld a,$08
	rst_addAToHl
	ld a,$08
	call addAToBc

	; Subtract 8 from hl (check earliest possible frame?)
	push bc
	ld b,$ff
	ld c,$f8
	add hl,bc
	pop bc

	call compareHlToBc
	cp $01
	jr z,@tooEarly

	; Add $10 to hl (check latest possible frame?)
	ld a,$10
	rst_addAToHl
	call compareHlToBc
	cp $ff
	jr z,@tooLate
	ret

@tooEarly:
	ld a,$00
	ld (wTmpcfc0.goronDance.failureType),a
	ret

@tooLate:
	ld a,$01
	ld (wTmpcfc0.goronDance.failureType),a
	ret

;;
; @param[out]	zflag	z the window for input this beat has passed.
goronDance_checkTooLateToInput:
	call goronDance_getCurrentAndNeededFrameCounts
	ld a,$08
	rst_addAToHl
	jr ++

;;
; @param[out]	zflag	z if the exact expected time for the input has passed.
goronDance_checkExactInputTimePassed:
	call goronDance_getCurrentAndNeededFrameCounts
++
	call compareHlToBc
	cp $ff
	ret

;;
; @param[out]	bc	Current frame count
; @param[out]	hl	Needed frame count? (First OK frame to press button?)
goronDance_getCurrentAndNeededFrameCounts:
	; hl = [wTmpcfc0.goronDance.beat] * 20
	ld a,(wTmpcfc0.goronDance.beat)
	push af
	call multiplyABy4
	ld l,c
	ld h,b
	pop af
	call multiplyABy16
	add hl,bc

	ld a,(wTmpcfc0.goronDance.frameCounter)
	ld c,a
	ld a,(wTmpcfc0.goronDance.frameCounter+1)
	ld b,a
	ret

;;
goronDance_playMoveSound:
	ld a,(wTmpcfc0.goronDance.currentMove)
	bit 7,a
	ret nz
	cp $00
	ret z

	cp $02
	jr z,++
	ld a,SND_DING
	jp playSound
++
	ld a,SND_GORON_DANCE_B
	jp playSound

;;
goronDance_incBeat:
	ld hl,wTmpcfc0.goronDance.beat
	inc (hl)
	ret

;;
; Get the next dance move, based on "danceLevel", "dancePattern", and "beat".
;
; @param[out]	zflag	nz if the data ran out.
goronDance_getNextMove:
	ld a,(wTmpcfc0.goronDance.danceLevel)
	ld hl,goronDance_sequenceData
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wTmpcfc0.goronDance.dancePattern)
	swap a
	ld b,a
	ld a,(wTmpcfc0.goronDance.beat)
	add b
	rst_addAToHl
	ld a,(hl)
	ld (wTmpcfc0.goronDance.currentMove),a
	bit 7,a
	ret

;;
goronDance_updateConsecutiveBPressCounter:
	ld hl,wTmpcfc0.goronDance.consecutiveBPressCounter
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $02
	jr z,+
	ld (hl),$00
	ret
+
	inc (hl)
	ret

;;
; @param[out]	zflag	z if Link and dancers should jump
goronDance_updateLinkAndBackupDancerAnimation:
	call goronDance_updateBackupDancerAnimation
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $01
	jr nz,@bButton

@aButton:
	ld a,LINK_ANIM_MODE_DANCELEFT
	ld (wcc50),a
	or d
	ret

@bButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)
	ld hl,goronDance_linkBButtonAnimations
	rst_addAToHl

	; Should they jump?
	ld a,(hl)
	cp $50
	ret z

	cp $04
	jr nz,goronDance_turnLinkToDirection

	ld a,LINK_ANIM_MODE_GETITEM1HAND
	ld (wcc50),a
	or d
	ret

;;
; @param	a	Direction
goronDance_turnLinkToDirection:
	ld hl,w1Link.direction
	ld (hl),a
	ld a,LINK_ANIM_MODE_WALK
	ld (wcc50),a
	or d
	ret


; Link's direction values for consecutive B presses.
; $04 marks a particular animation, and $50 marks that he should jump.
goronDance_linkBButtonAnimations:
	.db $02 $03 $01 $04 $03 $50


;;
; @param[out]	zflag	z if they should jump
goronDance_updateBackupDancerAnimation:
	call checkIsLinkedGame
	jr z,@gorons
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@gorons

@subrosians:
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $01
	jr nz,@subrosianBButton

	; A button
	ld a,$06
	jr @setDanceAnimation

@subrosianBButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)
	ld hl,goronDance_subrosianBAnimations
	rst_addAToHl
	ld a,(hl)
	cp $50
	ret z
	ld (wTmpcfc0.goronDance.danceAnimation),a
	ret

@gorons:
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $01
	jr nz,@goronBButton

	; A button
	ld a,$06
	jr @setDanceAnimation

@goronBButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)
	ld hl,goronDance_goronBAnimations
	rst_addAToHl
	ld a,(hl)
	cp $50
	ret z

@setDanceAnimation:
	ld (wTmpcfc0.goronDance.danceAnimation),a
	ret

goronDance_goronBAnimations:
	.db $02 $03 $04 $01 $00 $50

goronDance_subrosianBAnimations:
	.db $02 $03 $01 $03 $00 $50


;;
; @param[out]	zflag	z if the graceful goron should jump (5 consecutive B presses)
goronDance_updateGracefulGoronAnimation:
	ld a,(wTmpcfc0.goronDance.currentMove)
	cp $01
	jr nz,@bButton

	; A button
	ld a,$06
	jr @setAnimation

@bButton:
	ld a,(wTmpcfc0.goronDance.consecutiveBPressCounter)
	ld hl,goronDance_goronBAnimations
	rst_addAToHl
	ld a,(hl)
	cp $50
	ret z

@setAnimation:
	call interactionSetAnimation
	or d
	ret


; This holds the patterns for the various levels of the goron dance.
goronDance_sequenceData:
	.dw @platinum
	.dw @gold
	.dw @silver
	.dw @bronze

; Each row represents one possible dance pattern.
;   $00 means "rest";
;   $01 means "A";
;   $02 means "B";
;   $ff means "End".

@platinum:
	.db $02 $02 $02 $01 $00 $00 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $00 $02 $02 $01 $00 $02 $00 $01 $00 $01 $ff $00 $00
	.db $02 $00 $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $00 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $00 $02 $02 $02 $00 $02 $02 $02 $02 $02 $01 $01 $ff
	.db $02 $02 $02 $01 $00 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $00 $01 $00 $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $01 $00 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00

@gold:
	.db $02 $01 $02 $00 $00 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $01 $00 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $00 $02 $01 $02 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $02 $00 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $00 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00
	.db $02 $02 $00 $02 $01 $02 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $00 $02 $02 $02 $00 $02 $02 $02 $01 $02 $02 $01 $ff
	.db $02 $02 $01 $00 $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00

@silver:
	.db $02 $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $00 $02 $01 $02 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00

@bronze:
	.db $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $00 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $01 $02 $01 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00
	.db $02 $00 $02 $02 $00 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00
	.db $02 $02 $01 $02 $02 $02 $01 $ff $00 $00 $00 $00 $00 $00 $00 $00

;;
goron_initGraphicsAndIncState:
	call goron_initGraphics
	jp interactionIncState

;;
goron_loadScriptAndInitGraphics:
	call goron_initGraphics
	jr goron_loadScript

;;
goron_loadScriptFromTableAndInitGraphics:
	call goron_initGraphics
	jr goron_loadScriptFromTable

;;
goron_initGraphics:
	call interactionLoadExtraGraphics
	jp interactionInitGraphics

;;
goron_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,goron_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; Load a script based on both subid and var03.
goron_loadScriptFromTable:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,goron_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	inc e
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

goron_scriptTable:
	.dw mainScripts.stubScript
	.dw mainScripts.goron_subid01Script
	.dw mainScripts.stubScript
	.dw mainScripts.goron_subid03Script
	.dw mainScripts.goron_subid04Script
	.dw @subid05ScriptTable
	.dw @subid06ScriptTable
	.dw mainScripts.goron_subid07Script
	.dw mainScripts.goron_subid08Script
	.dw @subid09ScriptTable
	.dw mainScripts.goron_subid0aScript
	.dw @subid0bScriptTable
	.dw mainScripts.goron_subid0cScript
	.dw mainScripts.goron_subid0dScript
	.dw mainScripts.goron_subid0eScript
.ifndef REGION_JP
	.dw mainScripts.stubScript
	.dw mainScripts.goron_subid10Script
.endif

@subid05ScriptTable:
	.dw mainScripts.goron_subid05Script_A
	.dw mainScripts.goron_subid05Script_A
	.dw mainScripts.goron_subid05Script_A
	.dw mainScripts.goron_subid05Script_B
	.dw mainScripts.goron_subid05Script_B
	.dw mainScripts.goron_subid05Script_B

@subid06ScriptTable:
	.dw mainScripts.goron_subid06Script_A
	.dw mainScripts.goron_subid06Script_B

@subid09ScriptTable:
	.dw mainScripts.goron_subid09Script_A
	.dw mainScripts.goron_subid09Script_B

@subid0bScriptTable:
	.dw mainScripts.goron_subid0bScript
	.dw mainScripts.goron_subid0bScript


goronDanceScriptTable:
	.dw mainScripts.goron_subid00Script
	.dw mainScripts.goronDanceScript_failedRound
	.dw mainScripts.goronDanceScript_givePrize
