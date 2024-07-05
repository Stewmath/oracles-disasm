; ==================================================================================================
; INTERAC_RALPH
;
; Variables:
;   var3f: for some subids, ralph's animations only updates when this is 0.
; ==================================================================================================
interactionCode37:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw ralphState0
	.dw ralphRunSubid

ralphState0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
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
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08
	.dw @initSubid09
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @initSubid0d
	.dw @initSubid0e
	.dw @initSubid0f
	.dw @initSubid10
	.dw @initSubid11
	.dw @initSubid12


@initSubid06:
	ld hl,mainScripts.ralphSubid06Script_part1
	ld a,($cfd0)
	cp $0b
	jr nz,++
	ld bc,$4850
	call interactionSetPosition
	ld hl,mainScripts.ralphSubid06Script_part2
++
	call interactionSetScript

@initSubid00:
@initSubid05:
	xor a

@setAnimation:
	call interactionSetAnimation
	jp objectSetVisiblec2

@initSubid02:
	ld a,$09
	call interactionSetAnimation

	ld hl,mainScripts.ralphSubid02Script
	call interactionSetScript

	call interactionLoadExtraGraphics
	jp objectSetVisiblec2

@initSubid03:
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON
	call checkGlobalFlag
	jp z,interactionDelete

	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,$03
	call interactionSetAnimation

	ld h,d
	ld l,Interaction.counter1
	ld (hl),$78
	ld l,Interaction.direction
	ld (hl),$01
	jp objectSetVisiblec2

@initSubid04:
	ld a,$01
	call interactionSetAnimation
	ld a,($cfd0)
	cp $03
	jr z,++
	ld hl,mainScripts.ralphSubid04Script_part1
	call interactionSetScript
	jp objectSetInvisible
++
	ld hl,mainScripts.ralphSubid04Script_part2
	call interactionSetScript
	jp objectSetVisiblec2

@initSubid07:
	ld hl,mainScripts.ralphSubid07Script
	call interactionSetScript
	jp objectSetInvisible

@initSubid08:
	callab scriptHelp.ralph_createLinkedSwordAnimation

	ld hl,mainScripts.ralphSubid08Script
	call interactionSetScript
	jp objectSetVisiblec2

@initSubid09:
	ld a,GLOBALFLAG_RALPH_ENTERED_AMBIS_PALACE
	call checkGlobalFlag
	jr nz,@deleteSelf

	; Check that we have the 5th essence
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,@deleteSelf
	bit 5,a
	jr nz,++

@deleteSelf:
	jp interactionDelete

++
	ld e,Interaction.speed
	ld a,SPEED_200
	ld (de),a

	ld a,MUS_RALPH
	ld (wActiveMusic),a
	call playSound

	call setLinkForceStateToState08
	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,(wScreenTransitionDirection)
	ld (w1Link.direction),a

	ld hl,mainScripts.ralphSubid09Script
	call interactionSetScript
	xor a
	call interactionSetAnimation
	jp objectSetVisiblec2

@initSubid0a:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_RALPH_ENTERED_BLACK_TOWER
	call checkGlobalFlag
	jp nz,interactionDelete

	call checkIsLinkedGame
	ld hl,mainScripts.ralphSubid0aScript_unlinked
	jr z,@@setScript

	; Linked game: adjust position, load a different script
	ld h,d
	ld l,Interaction.xh
	ld (hl),$50
	ld l,Interaction.var38
	ld (hl),$1e

	ld hl,mainScripts.ralphSubid0aScript_linked

@@setScript:
	call interactionSetScript
	call setLinkForceStateToState08
	ld ($cfd0),a
	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp objectSetVisiblec2

@initSubid0e:
	ld e,Interaction.var3f
	ld a,$ff
	ld (de),a
	ld hl,mainScripts.ralphSubid0eScript
	jr @setScriptAndRunState1

@initSubid0f:
	ld a,$01
	jp @setAnimation

@initSubid01:
	ld hl,mainScripts.ralphSubid01Script

@setScriptAndRunState1:
	call interactionSetScript
	jp ralphRunSubid

@delete:
	jp interactionDelete

@initSubid0b:
	ld a,TREASURE_TUNE_OF_CURRENTS
	call checkTreasureObtained
	jr c,@delete

	call getThisRoomFlags
	and $40
	jr nz,@delete

	; Check that Link has timewarped in from a specific spot
	ld a,(wScreenTransitionDirection)
	or a
	jr nz,@delete
	ld a,(wWarpDestPos)
	cp $24
	jr nz,@delete

	ld hl,mainScripts.ralphSubid0bScript

@setScriptAndDisableObjects:
	call interactionSetScript

	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	call objectSetVisiblec1
	jp ralphRunSubid

@initSubid10:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete

	ld a,GLOBALFLAG_TALKED_TO_CHEVAL
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,(wWarpDestPos)
	cp $17
	jp nz,interactionDelete

	ld hl,mainScripts.ralphSubid10Script
	jr @setScriptAndDisableObjects

@initSubid11:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,$03
	call interactionSetAnimation
	ld hl,mainScripts.ralphSubid11Script
	call interactionSetScript
	jr ralphRunSubid

@initSubid0c:
	ld hl,wGroup4RoomFlags+$fc
	bit 7,(hl)
	jp nz,interactionDelete

	call interactionLoadExtraGraphics
	callab scriptHelp.ralph_createLinkedSwordAnimation
	ld hl,mainScripts.ralphSubid0cScript
	call interactionSetScript
	xor a
	ld ($cfde),a
	ld ($cfdf),a
	call interactionSetAnimation
	call interactionRunScript
	jr ralphRunSubid

@initSubid12:
	call checkIsLinkedGame
	jp z,interactionDelete
	ld hl,wGroup4RoomFlags + (<ROOM_AGES_4fc)
	bit 7,(hl)
	jp z,interactionDelete
	call objectSetVisiblec2
	ld hl,mainScripts.ralphSubid12Script
	jp interactionSetScript

@initSubid0d:
	ld a,(wScreenTransitionDirection)
	cp $01
	jp nz,interactionDelete

	ld hl,mainScripts.ralphSubid0dScript
	call interactionSetScript
	call objectSetVisiblec0

;;
ralphRunSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw ralphSubid00
	.dw ralphSubid01
	.dw ralphSubid02
	.dw ralphSubid03
	.dw ralphSubid04
	.dw ralphSubid05
	.dw ralphSubid06
	.dw ralphSubid07
	.dw ralphSubid08
	.dw ralphSubid09
	.dw ralphSubid0a
	.dw ralphSubid0b
	.dw ralphRunScriptAndDeleteWhenOver
	.dw ralphRunScriptWithConditionalAnimation
	.dw ralphSubid0e
	.dw interactionAnimate
	.dw ralphSubid10
	.dw nayruRunScriptWithConditionalAnimation
	.dw ralphSubid12

;;
; Cutscene where Nayru gets possessed
ralphSubid00:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call interactionAnimate
	ld a,($cfd0)
	cp $09
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3c

	ld bc,$3088
	call interactionSetPosition
	ld a,$03
	call interactionSetAnimation

	ld hl,mainScripts.ralphSubid00Script
	jp interactionSetScript

@substate1:
	call interactionAnimate
	call interactionRunScript
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret z

	; Animate more quickly if moving fast
	ld e,Interaction.speed
	ld a,(de)
	cp SPEED_100
	jp nc,interactionAnimate
	ret

;;
; Cutscene after Nayru is possessed
ralphSubid02:
	; They probably meant to call "checkInteractionSubstate" instead? It looks like
	; @state0 will never be run...
	call checkInteractionState
	jr nz,@state1

@state0:
	call interactionRunScript
	call interactionAnimate
	ld a,($cfd0)
	cp $1f
	ret nz
	jp interactionIncSubstate

@state1:
	callab scriptHelp.objectWritePositionTocfd5
	ld e,Interaction.counter2
	ld a,(de)
	or a
	call nz,interactionAnimate
	call    interactionAnimate

	call interactionRunScript
	ret nc

	; Script done
	ld a,SNDCTRL_MEDIUM_FADEOUT
	call playSound
	jp interactionDelete

;;
; Cutscene outside Ambi's palace before getting mystery seeds
ralphSubid01:
	call interactionRunScript
	jp c,interactionDelete

	call ralphTurnLinkTowardSelf
	ld e,Interaction.var3f
	ld a,(de)
	or a
	call z,interactionAnimate2Times
	jp interactionPushLinkAwayAndUpdateDrawPriority

;;
; Cutscene after talking to Rafton
ralphSubid03:
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

	ld (hl),$1e
	ld a,$02
	call interactionSetAnimation
	jp interactionIncSubstate
++
	ld a,(wFrameCounter)
	and $0f
	ret nz
	ld e,Interaction.direction
	ld a,(de)
	xor $02
	ld (de),a
	jp interactionSetAnimation

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp startJump

@substate2:
	call interactionAnimate
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$0a
	ret

@substate3:
	call interactionDecCounter1
	ret nz
	ld (hl),$1e
	call interactionIncSubstate
	ld bc,TX_2a0a
	jp showText

@substate4:
	call interactionDecCounter1IfTextNotActive
	ret nz
	ld (hl),$30

	call interactionIncSubstate

	ld l,Interaction.angle
	ld (hl),$10
	ld l,Interaction.speed
	ld (hl),SPEED_100

	ld a,$02
	jp interactionSetAnimation

@substate5:
	call interactionAnimate2Times
	call interactionDecCounter1
	jp nz,objectApplySpeed

	ld (hl),$06
	jp interactionIncSubstate

@substate6:
	call interactionDecCounter1
	ret nz
	ld (hl),$0a

	; Align with Link's x-position
	call interactionIncSubstate
	ld a,(w1Link.xh)
	ld l,Interaction.xh
	sub (hl)
	jr z,@startScript
	jr c,@@moveLeft

@@moveRight:
	ld b,$08
	ld c,DIR_RIGHT
	jr ++

@@moveLeft:
	cpl
	inc a
	ld b,$18
	ld c,DIR_LEFT
++
	ld l,Interaction.counter1
	ld (hl),a
	ld l,Interaction.angle
	ld (hl),b
	ld a,c
	jp interactionSetAnimation

@substate7:
	call interactionAnimate2Times
	call interactionDecCounter1
	jp nz,objectApplySpeed

@startScript:
	call interactionIncSubstate
	ld hl,mainScripts.ralphSubid03Script
	jp interactionSetScript

@substate8:
	call ralphAnimateBasedOnSpeedAndRunScript
	ret nc

	ld a,MUS_OVERWORLD_PAST
	ld (wActiveMusic2),a
	ld (wActiveMusic),a
	call playSound
	jp interactionDelete

;;
; Cutscene on maku tree screen after saving Nayru
ralphSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw nayruSubid02Substate0 ; Borrow some of Nayru's code from the same cutscene
	.dw @substate1
	.dw @substate2

@substate1:
	ld a,($cfd0)
	cp $08
	jp nz,nayruFlipDirectionAtRandomIntervals

	call interactionIncSubstate
	ld hl,mainScripts.ralphSubid04Script_part3
	call interactionSetScript
	jp @substate2

@substate2:
	call ralphAnimateBasedOnSpeedAndRunScript
	ret nc
	jp interactionDelete

;;
; Cutscene in black tower where Nayru/Ralph meet you to try to escape
ralphSubid05:
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw ralphRunScript

@substate0:
	ld a,($cfd0)
	cp $01
	ret nz
	call startJump
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld hl,mainScripts.ralphSubid05Script
	call interactionSetScript
	jp interactionIncSubstate

@substate2:
	ld a,($cfd0)
	cp $02
	jp nz,interactionRunScript
	call startJump
	jp interactionIncSubstate

@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.var3e
	inc (hl)

ralphRunScript:
	jp interactionRunScript

;;
ralphSubid06:
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw ralphRunScript

@substate0:
	callab scriptHelp.objectWritePositionTocfd5
	ld a,($cfd0)
	cp $08
	jp nz,interactionRunScript
	call startJump
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.var3e
	inc (hl)
	jr ralphRunScript

;;
; Cutscene postgame where they warp to the maku tree, Ralph notices the statue
ralphSubid07:
	callab scriptHelp.objectWritePositionTocfd5
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw ralphAnimateBasedOnSpeedAndRunScript
	.dw ralphSubid07Substate1
	.dw ralphSubid07Substate2
	.dw ralphAnimateBasedOnSpeedAndRunScript

ralphAnimateBasedOnSpeedAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript

ralphSubid07Substate1:
	call interactionIncSubstate
	call objectSetVisiblec2
	ld bc,-$1c0
	call objectSetSpeedZ

ralphSubid07Substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.var3e
	inc (hl)
	jp objectSetVisible82

;;
; Cutscene in credits where Ralph is training with his sword
ralphSubid08:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionAnimate
	call interactionRunScript
	ret nc

	; Script done

	call interactionIncSubstate
	ld l,Interaction.speed
	ld (hl),SPEED_c0

@getNextAngle:
	ld b,$02
	callab agesInteractionsBank0a.loadAngleAndCounterPreset
	ld a,b
	or a
	ret

@substate1:
	call interactionAnimate
	call objectApplySpeed
	call interactionDecCounter1
	call z,@getNextAngle
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$5a
	ld a,$08
	jp interactionSetAnimation

@substate2:
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	ld a,$ff
	ld ($cfdf),a
	ret

;;
; Cutscene where Ralph charges in to Ambi's palace
ralphSubid09:
	call interactionRunScript
	jp nc,interactionAnimateBasedOnSpeed

	; Script done
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete

;;
; Cutscene where Ralph's about to charge into the black tower
ralphSubid0a:
	call checkIsLinkedGame
	jp nz,ralphSubid0a_linked

; Unlinked game

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	; Create an exclamation mark above Link
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_EXCLAMATION_MARK
	ld l,Interaction.counter1
	ld (hl),$1e
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	add $0e
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	sub $0a
	ld (hl),a

	ld a,SND_CLINK
	call playSound

	call interactionIncSubstate

	ld l,Interaction.counter1
	ld (hl),$1e
	ld l,Interaction.speed
	ld (hl),SPEED_180
	ret

@substate1:
	call interactionDecCounter1
	ret nz

	xor a
	call interactionSetAnimation

@moveHorizontallyTowardRalph:
	ld a,(w1Link.xh)
	sub $50
	ld b,a
	add $02
	cp $05
	jr c,@incSubstate

	ld a,b
	bit 7,a
	ld b,$18
	jr z,+
	ld b,$08
	cpl
	inc a
+
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,b
	ld hl,w1Link.angle
	ldd (hl),a
	swap a
	rlca
	ld (hl),a ; [w1Link.direction]

@incSubstate:
	jp interactionIncSubstate

@substate2:
	ld b,$50

@moveVerticallyTowardRalph:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z

	; Make Link move vertically toward Ralph
	ld hl,w1Link.angle
	ld (hl),$10
	dec l
	ld (hl),DIR_DOWN
	ld a,b
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	jp interactionIncSubstate

@substate3:
	ldbc DIR_RIGHT,$03

@setDirectionAndAnimationWhenLinkFinishedMoving:
	ld a,(w1Link.state)
	cp LINK_STATE_FORCE_MOVEMENT
	ret z

	call setLinkForceStateToState08
	ld a,b
	ld (w1Link.direction),a
	ld a,c
	call interactionSetAnimation
	jp interactionIncSubstate

@substate4:
	call interactionRunScript
	jp nc,interactionAnimateBasedOnSpeed
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete

;;
ralphSubid0a_linked:
	call interactionRunScript
	jp c,interactionDelete

	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz
	jp ralphSubid0a@moveHorizontallyTowardRalph

@substate1:
	ld b,$18
	jp ralphSubid0a@moveVerticallyTowardRalph

@substate2:
	ldbc DIR_DOWN, $00
	jp ralphSubid0a@setDirectionAndAnimationWhenLinkFinishedMoving

@substate3:
	ret


;;
; $0b: Cutscene where Ralph tells you about getting Tune of Currents
; $10: Cutscene after talking to Cheval
ralphSubid0b:
ralphSubid10:
	ld a,($cfc0)
	or a
	call nz,ralphTurnLinkTowardSelf

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw ralphRunScriptWithConditionalAnimation

@substate0:
	call interactionAnimate
	jr ralphRunScriptWithConditionalAnimation

@substate1:
	; Create dust at Ralph's feet every 8 frames
	ld a,(wFrameCounter)
	and $07
	jr nz,ralphRunScriptWithConditionalAnimation

	call getFreeInteractionSlot
	jr nz,ralphRunScriptWithConditionalAnimation

	ld (hl),INTERAC_PUFF
	inc l
	ld (hl),$81
	ld bc,$0804
	call objectCopyPositionWithOffset
	jr ralphRunScriptWithConditionalAnimation

;;
; Runs script, deletes self when finished, and updates animations only if var3f is 0.
ralphRunScriptWithConditionalAnimation:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,interactionAnimate
	ret


;;
; Cutscene with Nayru and Ralph when Link exits the black tower
ralphSubid0e:
	ld a,(wScreenShakeCounterY)
	cp $5a
	jr nc,ralphRunScriptAndDeleteWhenOver
	or a
	jr z,ralphRunScriptAndDeleteWhenOver

	ld a,(w1Link.direction)
	sub $02
	and $03
	ld h,d
	ld l,Interaction.var3f
	cp (hl)
	jr z,ralphRunScriptAndDeleteWhenOver

	ld (hl),a
	call interactionSetAnimation

;;
ralphRunScriptAndDeleteWhenOver:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


;;
; NPC after beating Veran, before beating Twinrova in a linked game
ralphSubid12:
	call npcFaceLinkAndAnimate
	jp interactionRunScript

;;
; Unused?
ralphFunc_738b:
	ld h,d
	ld l,Interaction.var38
	ld a,(hl)
	or a
	jr nz,++

	ld bc,$2068
	ld a,(wFrameCounter)
	rrca
	ret nc

	ld l,Interaction.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a
	cp $0e
	ret nz
	ld l,Interaction.var38
	inc (hl)
	ld l,Interaction.angle
	ld (hl),$1f
++
	ld bc,$6890
	ld a,(wFrameCounter)
	rrca
	ret nc

	ld l,Interaction.angle
	ld a,(hl)
	dec a
	and $1f
	ld (hl),a
	ret

;;
ralphTurnLinkTowardSelf:
	ld a,(w1Link.xh)
	add $10
	ld b,a
	ld e,Interaction.xh
	ld a,(de)
	add $10
	sub b
	ld b,DIR_RIGHT
	jr nc,+
	ld b,DIR_LEFT
	cpl
+
	cp $0c
	jr nc,+
	ld b,DIR_DOWN
+
	ld hl,w1Link.direction
	ld (hl),b
	jp setLinkForceStateToState08

;;
startJump:
	ld bc,-$1c0
	call objectSetSpeedZ
	ld a,SND_JUMP
	jp playSound
