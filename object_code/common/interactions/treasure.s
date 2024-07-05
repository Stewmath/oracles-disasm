m_section_free Interaction_Code_Treasure NAMESPACE treasureInteraction

; ==================================================================================================
; INTERAC_TREASURE
;
; State $04 is used as a way to delete a treasure? (Bomb flower cutscene with goron elder
; sets the bomb flower to state 4 to delete it.)
;
; Variables:
;   subid: overwritten by call to "interactionLoadTreasureData" to correspond to a certain
;          graphic.
;   var30: former value of subid (treasure index)
;
;   var31-var35 based on data from "treasureObjectData.s":
;   var31: spawn mode
;   var32: collect mode
;   var33: if nonzero, set ROOMFLAG_ITEM
;   var34: parameter (value of 'c' for "giveTreasure" function)
;   var35: low text ID
;
;   var39: If set, this is part of the chest minigame? Gets written to "wDisabledObjects"?
; ==================================================================================================
interactionCode60:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw interactionDelete

@state0:
	ld a,$01
	ld (de),a
	callab treasureData.interactionLoadTreasureData
	ld a,$06
	call objectSetCollideRadius

	; Check whether to overwrite the "parameter" for the treasure?
	ld l,Interaction.var38
	ld a,(hl)
	or a
	jr z,+
	cp $ff
	jr z,+
	ld l,Interaction.var34
	ld (hl),a
+
	call interactionInitGraphics

	ld e,Interaction.var31
	ld a,(de)
	or a
	ret nz
	jp objectSetVisiblec2


; State 1: spawning in; goes to state 2 when finished spawning.
@state1:
	ld e,Interaction.var31
	ld a,(de)
	rst_jumpTable
	.dw @spawnMode0
	.dw @spawnMode1
	.dw @spawnMode2
	.dw @spawnMode3
	.dw @spawnMode4
	.dw @spawnMode5
	.dw @spawnMode6

; Spawns instantly
@spawnMode0:
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
	inc l
	ld (hl),$00
	call @checkLinkTouched
	jp c,@gotoState3
	jp objectSetVisiblec2

; Appears with a poof
@spawnMode1:
	ld e,Interaction.substate
	ld a,(de)
	or a
	jr nz,++

	ld a,$01
	ld (de),a
	ld e,Interaction.counter1
	ld a,30
	ld (de),a
	call objectCreatePuff
	ret nz
++
	call interactionDecCounter1
	ret nz
	jr @spawnMode0

; Falls from top of screen
@spawnMode2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,$01
	ld (de),a
	ld h,d
	ld l,Interaction.counter1
	ld (hl),40
	ld a,SND_SOLVEPUZZLE
	jp playSound

@@substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$02
	inc l
	ld (hl),$02

	ld l,Interaction.substate
	inc (hl)

	call objectGetZAboveScreen
	ld h,d
	ld l,Interaction.zh
	ld (hl),a

	call objectSetVisiblec0
	jp @setVisibleIfWithinScreenBoundary

@@substate2:
	call @checkLinkTouched
	jr c,@gotoState3
	call @setVisibleIfWithinScreenBoundary
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	call objectCheckIsOnHazard
	jr nc,+

	dec a
	jr z,@landedOnWater
	jp objectReplaceWithFallingDownHoleInteraction
+
.ifdef AGES_ENGINE
	ld a,SND_DROPESSENCE
	call playSound
.else
	ld e,Interaction.var30
	ld a,(de)
	cp TREASURE_SMALL_KEY
	ld a,SND_DROPESSENCE
	call z,playSound
.endif
	call interactionDecCounter1
	jr z,@gotoState2

	ld bc,-$aa
	jp objectSetSpeedZ

@gotoState2:
	call objectSetVisible
	call objectSetVisiblec2
	ld a,$02
	jr @gotoStateAndAlwaysUpdate

@setVisibleIfWithinScreenBoundary:
	call objectCheckWithinScreenBoundary
	jp nc,objectSetInvisible
	jp objectSetVisible

@gotoState3:
	call @giveTreasure
	ld a,$03

@gotoStateAndAlwaysUpdate:
	ld h,d
	ld l,Interaction.state
	ldi (hl),a
	xor a
	ld (hl),a

	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a

	jp interactionSetAlwaysUpdateBit

; If the treasure fell into the water, "reset" this object to state 0, increment var03.
@landedOnWater:
	ld h,d
	ld l,Interaction.var30
	ld a,(hl)
	ld l,Interaction.subid
	ldi (hl),a

	inc (hl) ; [var03]++ (use the subsequent entry in treasureObjectData)

	; Clear state
	inc l
	xor a
	ldi (hl),a
	ld (hl),a

	ld l,Interaction.visible
	res 7,(hl)
	ld b,INTERAC_SPLASH
	jp objectCreateInteractionWithSubid00


; Spawns from a chest
@spawnMode3:
	ld a,$80
	ld (wForceLinkPushAnimation),a
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @m3State0
	.dw @m3State1
	.dw @m3State2

@m3State0:
	ld a,$01
	ld (de),a
	ld (wDisableLinkCollisionsAndMenu),a
	call interactionSetAlwaysUpdateBit

	; Angle is already $00 (up), so don't need to set it
	ld l,Interaction.speed
	ld (hl),SPEED_40

	ld l,Interaction.counter1
	ld (hl),32
	jp objectSetVisible80

@m3State1:
	; Move up
	call objectApplySpeed
	call interactionDecCounter1
	ret nz

	; Finished moving up
	ld l,Interaction.substate
	inc (hl)
	ld l,Interaction.var39
	ld a,(hl)
	or a
	call z,@giveTreasure
	ld a,SND_GETITEM
	call playSound

	; Wait for player to close text
@m3State2:
	ld a,(wTextIsActive)
	and $7f
	ret nz

	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	ld e,Interaction.var39
	ld a,(de)
	ld (wDisabledObjects),a
	jp interactionDelete


; Appears at Link's position after a short delay
@spawnMode6:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @m6State0
	.dw @m6State1
	.dw @m6State2

@m6State0:
	ld a,$01
	ld (de),a
	ld (wDisableLinkCollisionsAndMenu),a
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.counter1
	ld (hl),15
@m6State1:
	call interactionDecCounter1
	ret nz

	; Delay done, give treasure to Link

	call interactionIncSubstate
	call objectSetVisible80
	call @giveTreasure
	ldbc $81,$00
	call @setLinkAnimationAndDeleteIfTextClosed
	ld a,SND_GETITEM
	jp playSound

@m6State2:
	ld a,(wTextIsActive)
	and $7f
	ret nz
	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	ld (wDisabledObjects),a
	jp interactionDelete


; Item that's underwater, must dive to get it (only used in seasons dungeon 4)
@spawnMode4:
	call @checkLinkTouched
	ret nc
	ld a,(wLinkSwimmingState)
	bit 7,a
	ret z
	call objectSetVisible82
	call @giveTreasure
	ld a,SND_GETITEM
	call playSound
	ld a,$03
	jp @gotoStateAndAlwaysUpdate


; Item that falls to Link's position when [wccaa]=$ff?
@spawnMode5:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @m5State0
	.dw @m5State1
	.dw @m5State2

@m5State0:
	ld a,$01
	ld (de),a
	call objectGetShortPosition
	ld (wccaa),a
	ret

@m5State1:
	ld a,(wScrollMode)
	and $0c
	jp nz,interactionDelete

	ld a,(wccaa)
	inc a
	ret nz

	ld bc,-$100
	call objectSetSpeedZ
	ld l,Interaction.substate
	inc (hl)
	ld a,(w1Link.direction)
	swap a
	rrca
	ld l,Interaction.angle
	ld (hl),a
	ld l,Interaction.speed
	ld (hl),SPEED_080
	jp objectSetVisiblec2

@m5State2:
	call objectCheckTileCollision_allowHoles
	call nc,objectApplySpeed
	ld c,$10
	call objectUpdateSpeedZAndBounce
	ret nz
	push af
	call objectReplaceWithAnimationIfOnHazard
	pop bc
	jp c,interactionDelete

	ld a,SND_DROPESSENCE
	call playSound
	bit 4,c
	ret z
	jp @gotoState2


; State 2: done spawning, waiting for Link to grab it
@state2:
	call returnIfScrollMode01Unset
	call @checkLinkTouched
	ret nc
	jp @gotoState3


; State 3: Link just grabbed it
@state3:
	ld e,Interaction.var32
	ld a,(de)
	rst_jumpTable
	.dw interactionDelete
	.dw @grabMode1
	.dw @grabMode2
	.dw @grabMode3
	.dw @grabMode1
	.dw @grabMode2

; Hold over head with 1 hand
@grabMode1:
	ldbc $80,$fc
	jr +

; Hold over head with 2 hands
@grabMode2:
	ldbc $81,$00
+
	ld e,Interaction.substate
	ld a,(de)
	or a
	jr nz,++

	inc a
	ld (de),a

;;
; @param	b	Animation to do (0 = 1-hand grab, 1 = 2-hand grab)
; @param	c	x-offset to put item relative to Link
@setLinkAnimationAndDeleteIfTextClosed:
	ld a,LINK_STATE_04
	ld (wLinkForceState),a
	ld a,b
	ld (wcc50),a
	ld hl,wDisabledObjects
	set 0,(hl)
	ld hl,w1Link
	ld b,$f2
	call objectTakePositionWithOffset
	call objectSetVisible80
	ld a,SND_GETITEM
	call playSound
++
	call retIfTextIsActive
	ld hl,wDisabledObjects
	res 0,(hl)

.ifndef REGION_JP
	ld a,$0f
	ld (wInstrumentsDisabledCounter),a
.endif

	jp interactionDelete


; Performs a spin slash upon obtaining the item
@grabMode3:
	ld a,Interaction.var38
	ld (wInstrumentsDisabledCounter),a
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @gm3State0
	.dw @gm3State1
	.dw @gm3State2
	.dw @gm3State3

@gm3State0:
	ld a,$01
	ld (de),a
	inc e

	ld a,$04
	ld (de),a ; [counter1] = $04

	ld a,$81
	ld (wDisabledObjects),a
	ld a,$ff
	call setLinkForceStateToState08_withParam
	ld hl,wLinkForceState
	jp objectSetInvisible

@gm3State1:
	call interactionDecCounter1
	ret nz

	ld l,Interaction.substate
	inc (hl)

	; Forces spinslash animation
	ld a,$ff
	ld (wcc63),a
	ret

@gm3State2:
	; Wait for spin to finish
	ld a,(wcc63)
	or a
	ret nz

	ld a,LINK_ANIM_MODE_GETITEM1HAND
	ld (wcc50),a

	; Calculate x/y position just above Link
	ld e,Interaction.yh
	ld a,(w1Link.yh)
	sub $0e
	ld (de),a
	ld e,Interaction.xh
	ld a,(w1Link.xh)
	sub $04
	ld (de),a

	call objectSetVisible
	call objectSetVisible80
	call interactionIncSubstate
	ld a,SND_SWORD_OBTAINED
	jp playSound

@gm3State3:
	ld a,(wDisabledObjects)
	or a
	ret nz
	jp interactionDelete

@giveTreasure:
	ld e,Interaction.var34
	ld a,(de)
	ld c,a
	ld e,Interaction.var30
	ld a,(de)
	ld b,a

	; If this is ore chunks, double the value if wearing an appropriate ring?
	cp TREASURE_ORE_CHUNKS
	jr nz,++

	ld a,GOLD_JOY_RING
	call cpActiveRing
	jr z,+

	ld a,GREEN_JOY_RING
	call cpActiveRing
	jr nz,++
+
	inc c
++
	ld a,b
	call giveTreasure
	ld b,a

	ld e,Interaction.var32
	ld a,(de)
	cp $03
	jr z,+

	ld a,b
	call playSound
+
	ld e,Interaction.var35
	ld a,(de)
	cp $ff
	jr z,++

	ld c,a
	ld b,>TX_0000
	call showText

	; Determine textbox position (after showText call...?)
	ldh a,(<hCameraY)
	ld b,a
	ld a,(w1Link.yh)
	sub b
	sub $10
	cp $48
	ld a,$02
	jr c,+
	xor a
+
	ld (wTextboxPosition),a
++
	ld e,Interaction.var33
	ld a,(de)
	or a
	ret z

	; Mark item as obtained
	call getThisRoomFlags
	set ROOMFLAG_BIT_ITEM,(hl)
	ret

;;
; @param[out]	cflag	Set if Link's touched this object so he should collect it
@checkLinkTouched:
	ld a,(wLinkForceState)
	or a
	ret nz

.ifndef REGION_JP
	ld a,(wLinkPlayingInstrument)
	or a
	ret nz
.endif

	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	jr z,+
	cp LINK_STATE_08
	jr nz,++
+
	ld a,(wLinkObjectIndex)
	rrca
	jr c,++

	; Check if Link's touched this
	ld e,Interaction.var2a
	ld a,(de)
	or a
	jp z,objectCheckCollidedWithLink_notDeadAndNotGrabbing
	scf
	ret
++
	xor a
	ret

.ends
