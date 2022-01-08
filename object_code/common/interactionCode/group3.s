 m_section_free Interaction_Code_Group3 NAMESPACE commonInteractions3

; ==============================================================================
; INTERACID_BOMB_FLOWER
; ==============================================================================
interactionCode6f:
.ifdef ROM_AGES
	jp interactionDelete
.else
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw bomb_flower_subid0
	.dw bomb_flower_subid1

bomb_flower_subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a

	call getThisRoomFlags
	bit 5,(hl)
	jr nz,+

	ld a,TREASURE_BOMB_FLOWER
	call checkTreasureObtained
	jr c,+

	ld a,$04
	call objectSetCollideRadius
	call interactionInitGraphics
	jp objectSetVisible82
+
	jp interactionDelete

@state1:
	call objectGetTileAtPosition
	ld (hl),$00
	call objectPreventLinkFromPassing
	jp objectAddToGrabbableObjectBuffer

@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call interactionIncSubstate
	ld a,$1c
	ld (wDisabledObjects),a
	xor a
	ld (wLinkGrabState2),a
	call interactionSetAnimation
	call objectSetVisible81
	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_DUG_HOLE
	jp setTile

@substate1:
	ld a,(wLinkGrabState)
	cp $83
	ret nz

	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call dropLinkHeldItem

	ld e,Interaction.substate
	ld a,$02
	ld (de),a

	call getThisRoomFlags
	set 5,(hl)
	ld a,LINK_STATE_04
	ld (wLinkForceState),a
	ld a,$01
	ld (wcc50),a
	ld bc,TX_003c
	call showText
	ld a,TREASURE_BOMB_FLOWER
	jp giveTreasure

@substate2:
@substate3:
	call retIfTextIsActive
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call updateLinkLocalRespawnPosition
	jp interactionDelete

bomb_flower_subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a

	ld hl,mainScripts.bombflower_unblockAutumnTemple
	call interactionSetScript
	call interactionInitGraphics
	xor a
	call interactionSetAnimation
	jp objectSetVisible82

@state2:
	call interactionAnimate

@state1:
	call interactionAnimate
	jp interactionRunScript

@state3:
	call objectSetInvisible
	jp interactionRunScript

.endif ; ROM_SEASONS


; ==============================================================================
; INTERACID_SWITCH_TILE_TOGGLER
; ==============================================================================
interactionCode78:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld a,(wSwitchState)
	ld e,Interaction.var03
	ld (de),a

@state1:
	ld a,(wSwitchState)
	ld b,a
	ld e,Interaction.var03
	ld a,(de)
	cp b
	ret z

	ld a,b
	ld (de),a
	ld e,Interaction.xh
	ld a,(de)
	ld hl,@tileReplacement
	rst_addDoubleIndex
	ld e,Interaction.subid
	ld a,(de)
	and b
	jr z,+
	inc hl
+
	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld a,(hl)
	jp setTile

; Index for this table is "Interaction.xh". Determines what tiles will appear when
; a switch is on or off.
;   b0: tile index when switch not pressed
;   b1: tile index when switch pressed
@tileReplacement:
	.db $5d $59 ; $00
	.db $5d $5a ; $01
	.db $5d $5b ; $02
	.db $5d $5c ; $03
	.db $5e $59 ; $04
	.db $5e $5a ; $05
	.db $5e $5b ; $06
	.db $5e $5c ; $07
	.db $59 $5d ; $08
	.db $5a $5d ; $09
	.db $5b $5d ; $0a
	.db $5c $5d ; $0b (patch's minecart game)
	.db $59 $5e ; $0c
	.db $5a $5e ; $0d
	.db $5b $5e ; $0e
	.db $5c $5e ; $0f
	.db $59 $5b ; $10
	.db $5a $5c ; $11
	.db $5b $59 ; $12
	.db $5c $5a ; $13
	.db $59 $5c ; $14
	.db $5a $5b ; $15
	.db $5b $5a ; $16
	.db $5c $59 ; $17


; ==============================================================================
; INTERACID_MOVING_PLATFORM
;
; Variables:
;   Subid: After being processed, this just represents the size (see @collisionRadii).
;   var32: Formerly bits 3-7 of subid; the index of the "script" to use.
; ==============================================================================
interactionCode79:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	and $07
	ld (de),a

	ld a,b
	ld e,Interaction.var32
	swap a
	rlca
	and $1f
	ld (de),a
	call interactionInitGraphics

	ld e,Interaction.speed
	ld a,SPEED_80
	ld (de),a

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@collisionRadii
	rst_addDoubleIndex
	ld e,Interaction.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	callab scriptHelp.movingPlatform_loadScript
	callab scriptHelp.movingPlatform_runScript
	jp objectSetVisible83

@collisionRadii:
	.db $08 $08
	.db $10 $08
	.db $18 $08
	.db $08 $10
	.db $08 $18
	.db $10 $10

@state1:
	ld a,(wLinkRidingObject)
	cp d
	jr z,@linkOnPlatform
	or a
	jr nz,@updateSubstate

	call @checkLinkTouching
	jr nc,@updateSubstate

	; Just got on platform
	ld a,d
	ld (wLinkRidingObject),a
	jr @updateSubstate

@linkOnPlatform:
	call @checkLinkTouching
	jr c,@updateSubstate
	xor a
	ld (wLinkRidingObject),a

@updateSubstate:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

;;
; @param[out]	cflag	Set if Link's touching the platform
@checkLinkTouching:
	ld hl,w1Link.yh
	ldi a,(hl)
	add $05
	ld b,a
	inc l
	ld c,(hl)
	jp interactionCheckContainsPoint


; Substate 0: not moving
@substate0:
	call interactionDecCounter1
	ret nz
	callab scriptHelp.movingPlatform_runScript
	ret

; Substate 1: moving
@substate1:
	ld a,(wLinkPlayingInstrument)
	or a
	ret nz

	call objectApplySpeed
	ld a,(wLinkRidingObject)
	cp d
	jr nz,@substate0

	ld a,(w1Link.state)
	cp $01
	jr nz,@substate0

	ld e,Interaction.speed
	ld a,(de)
	ld b,a
	ld e,Interaction.angle
	ld a,(de)
	ld c,a
	call updateLinkPositionGivenVelocity
	jr @substate0


; ==============================================================================
; INTERACID_ROLLER
;
; Variables:
;   counter1:
;   counter2:
;   var30: Original X-position, where it returns to
;   var31: Counter before showing "it's too heavy to move" text.
; ==============================================================================
interactionCode7a:
	call retIfTextIsActive
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	; [collisionRadiusY] = ([subid]+2)*8
	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	add $02
	swap a
	rrca
	ld l,Interaction.collisionRadiusY
	ldi (hl),a

	; [collisionRadiusX] = $06
	ld a,$06
	ld (hl),a

	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.counter1
	ld (hl),30
	ld l,Interaction.counter2
	ld (hl),60

	; Remember original X-position
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var30
	ld (hl),a

	call objectSetVisible83

@state1:
	call @preventLinkFromPassing
	jr c,@movingTowardRoller

@notPushingAgainstRoller:
	ld h,d
	ld l,Interaction.var31
	ld (hl),30

@moveTowardOriginalPosition:
	ld h,d
	ld l,Interaction.counter1
	ld (hl),30

	; Return if already in position
	ld l,Interaction.xh
	ld b,(hl)
	ld l,Interaction.var30
	ld a,(hl)
	cp b
	ret z

	; Return unless counter2 reached 0
	ld l,Interaction.counter2
	dec (hl)
	ret nz

	cp b
	ld bc,$0008
	jr nc,@moveRollerInDirection
	ld bc,$0118
	jr @moveRollerInDirection


@movingTowardRoller:
	; Check Link's Y position is high or low enough (can't be on the edge)?
	ld h,d
	ld l,Interaction.collisionRadiusY
	ld a,(hl)
	sub $02
	ld b,a
	ld c,b
	sla c
	inc c
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	sub (hl)
	add b
	cp c
	jr nc,@notPushingAgainstRoller

	; Must be moving directly toward the roller
	ld a,(wLinkAngle)
	cp $08
	ldbc $00,$08
	jr z,++
	cp $18
	ldbc $01,$18
	jr nz,@notPushingAgainstRoller
++
	ld a,$01
	ld (wForceLinkPushAnimation),a
	ld a,(wBraceletGrabbingNothing)
	and $03
	swap a
	rrca
	cp c
	jr z,@pushingAgainstRoller

	; Link isn't pushing against it with the bracelet. Check whether to show
	; informative text ("it's too heavy to move").

	; Check bracelet is not on A or B.
	ld hl,wInventoryB
	ld a,ITEMID_BRACELET
	cp (hl)
	jr z,@notPushingAgainstRoller
	inc hl
	cp (hl)
	jr z,@notPushingAgainstRoller

	; Check bracelet not being used.
	ld a,(wBraceletGrabbingNothing)
	or a
	jr nz,@notPushingAgainstRoller

	; Check not in air.
	ld a,(wLinkInAir)
	or a
	jr nz,@notPushingAgainstRoller

	; Countdown before showing informative text.
	ld h,d
	ld l,Interaction.var31
	dec (hl)
	jr nz,@moveTowardOriginalPosition

	call showInfoTextForRoller
	jr @notPushingAgainstRoller

@pushingAgainstRoller:
	ld a,60
	ld e,Interaction.counter2
	ld (de),a
	call @checkRollerCanBePushed
	jp nz,@notPushingAgainstRoller

	; Roller can be pushed; decrement counter until it gets pushed.
	call interactionDecCounter1
	ret nz

;;
; @param	b	Animation (0 for right, 1 for left)
; @param	c	Angle
@moveRollerInDirection:
	ld l,Interaction.state
	inc (hl)
	ld l,Interaction.angle
	ld (hl),c

	; Use animation [subid]*2+b
	ld l,Interaction.subid
	ld a,(hl)
	add a
	add b
	call interactionSetAnimation

	ld hl,wInformativeTextsShown
	set 6,(hl)


; State 2: moving in a direction.
@state2:
	call objectApplySpeed
	call interactionAnimate
	call objectCheckCollidedWithLink_ignoreZ
	jr nc,+
	call @updateLinkPositionWhileRollerMoving
+
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	jr z,@rollerSound
	inc a
	ret nz

	; animParameter signaled end of pushing animation.
	ld l,Interaction.counter1
	ld (hl),30
	inc l
	ld (hl),60
	ld l,Interaction.state
	dec (hl)
	ret
@rollerSound:
	ld (hl),$01
	ld a,SND_ROLLER
	jp playSound


@updateLinkPositionWhileRollerMoving:
	ld a,(w1Link.adjacentWallsBitset)
	cp $53
	jr z,@squashLink
	cp $ac
	jr z,@squashLink
	cp $33
	jr z,@squashLink
	cp $c3
	jr z,@squashLink
	cp $cc
	jr z,@squashLink
	cp $3c
	jr z,@squashLink

	call @preventLinkFromPassing

	; If Link's facing any walls on left or right sides, move him left or right; what
	; will actually happen, is the function call will see that he's facing a wall, and
	; move him up or down toward a "wall-free" area. This apparently does not happen
	; with the "@preventLinkFromPassing" call, so it must be done here.
	ld a,(w1Link.adjacentWallsBitset)
	and $0f
	ret z
	call objectGetAngleTowardLink
	cp $10
	ld c,$08
	jr c,+
	ld c,$18
+
	ld e,Interaction.angle
	ld a,(de)
	cp c
	ret nz
	ld b,SPEED_100
	jp updateLinkPositionGivenVelocity

@squashLink:
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	ld a,LINK_STATE_SQUISHED
	ld (wLinkForceState),a
	xor a
	ld (wcc50),a
	ret

;;
; @param	c	Angle it's moving toward
; @param[out]	zflag	z if can be pushed.
@checkRollerCanBePushed:
	; Do some weird math to get the topmost tile on the left or right side of the
	; roller?
	push bc
	ld e,Interaction.subid
	ld a,(de)
	add $02
	ldh (<hFF8B),a
	swap a
	rrca
	ld b,a
	ld e,Interaction.yh
	ld a,(de)
	sub b
	add $08
	and $f0
	ld b,a
	ld a,$08
	ld l,$01
	cp c
	jr z,+
	ld l,$ff
+
	ld e,Interaction.xh
	ld a,(de)
	swap a
	add l
	and $0f
	or b
	pop bc

	; Make sure there's no wall blocking the roller.
	ld l,a
	ld h,>wRoomCollisions
	ldh a,(<hFF8B)
	ld e,a
@nextTile:
	ld a,(hl)
	cp $10
	jr nc,+
	or a
	ret nz
+
	ld a,l
	add $10
	ld l,a
	dec e
	jr nz,@nextTile
	xor a
	ret

;;
; @param[out]	cflag	c if Link is pushing against the roller
@preventLinkFromPassing:
	ld a,(w1Link.collisionType)
	bit 7,a
	ret z
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	jp objectPreventLinkFromPassing


; ==============================================================================
; INTERACID_SPINNER
;
; Variables:
;   var3a: Bitmask for wSpinnerState (former value of "xh")
; ==============================================================================
interactionCode7d:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw spinner_subid02

@subid00:
@subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionRunScript
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3a
	ld (hl),a

	; Calculate subid (blue or red) based on whether the bit in wSpinnerState is set
	ld a,(wSpinnerState)
	and (hl)
	ld a,$01
	jr nz,+
	dec a
+
	ld l,Interaction.subid
	ld (hl),a

	; Calculate angle? (subid*8)
	swap a
	rrca
	ld l,Interaction.angle
	ld (hl),a

	ld l,Interaction.yh
	ld a,(hl)
	call setShortPosition

	call interactionInitGraphics
	ld hl,mainScripts.spinnerScript_initialization
	call interactionSetScript
	call objectSetVisible82

	; Create "arrow" object and set it as relatedObj1
	ldbc INTERACID_SPINNER, $02
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld (hl),d
	ret


; State 2: Link just touched the spinner.
@state2:
	ld hl,wcc95
	ld a,(wLinkInAir)
	or a
	jr nz,@revertToState1

	; Check if in midair or swimming?
	bit 4,(hl)
	jr nz,@beginTurning

@revertToState1:
	; Undo everything we just did
	res 7,(hl)
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld hl,mainScripts.spinnerScript_waitForLink
	jp interactionSetScript

@beginTurning:
	; State 3
	ld a,$03
	ld (de),a

	call clearAllParentItems

	; Determine the direction Link entered from
	ld c,$28
	call objectCheckLinkWithinDistance
	sra a
	ld e,Interaction.direction
	ld (de),a

	; Check angle
	ld b,a
	inc e
	ld a,(de)
	or a
	jr nz,@clockwise

@counterClockwise:
	ld a,b
	add a
	ld hl,spinner_counterClockwiseData
	rst_addDoubleIndex
	jr ++

@clockwise:
	ld a,b
	add a
	ld hl,spinner_clockwiseData
	rst_addDoubleIndex

++
	call spinner_setLinkRelativePosition
	ldi a,(hl)
	ld c,<w1Link.direction
	ld (bc),a

	ld e,Interaction.var39
	ld a,(hl)
	ld (de),a

	call setLinkForceStateToState08

	; Disable everything but interactions?
	ld a,(wDisabledObjects)
	or $80
	ld (wDisabledObjects),a

	ld a,$04
	call setScreenShakeCounter

	ld a,SND_OPENCHEST
	jp playSound


; State 3: In the process of turning
@state3:
	call spinner_updateLinkPosition

	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	jp nz,interactionAnimate

	; Finished turning, set up state 4
	ld h,d
	ld l,Interaction.state
	ld (hl),$04

	ld l,Interaction.counter1
	ld (hl),$10
	xor a
	ld (wDisabledObjects),a

	; Update Link's angle based on direction
	ld hl,w1Link.direction
	ldi a,(hl)
	swap a
	rrca
	ld (hl),a

	; Force him to move out
	ld hl,wLinkForceState
	ld a,LINK_STATE_FORCE_MOVEMENT
	ldi (hl),a
	inc l
	ld (hl),$10

	; Reset signal that spinner's being used?
	ld hl,wcc95
	res 7,(hl)
	ret

; State 4: Link moving out from spinner
@state4:
	call interactionDecCounter1
	ret nz

	; Toggle spinner state
	ld l,Interaction.var3a
	ld a,(wSpinnerState)
	xor (hl)
	ld (wSpinnerState),a

	; Toggle color
	ld l,Interaction.oamFlags
	ld a,(hl)
	xor $01
	ld (hl),a

	; Toggle angle
	ld l,Interaction.angle
	ld a,(hl)
	xor $08
	ld (hl),a

	; Go back to state 1
	ld l,Interaction.state
	ld (hl),$01
	ld hl,mainScripts.spinnerScript_waitForLinkAfterDelay
	jp interactionSetScript


; Arrow rotating around a spinner
spinner_subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	; [this.angle] = [relatedObj1.angle]
	ld e,Interaction.relatedObj1
	ld a,(de)
	ld h,d
	ld l,Interaction.angle
	ld e,l
	ld a,(hl)
	ld (de),a
	call objectSetVisible82

@state1:
	; Check if [this.angle] == [relatedObj1.angle]
	ld e,Interaction.relatedObj1
	ld a,(de)
	ld h,a
	ld l,Interaction.angle
	ld e,l
	ld a,(de)
	cp (hl)
	jr z,++

	; Angle changed (red to blue, or blue to red)
	ld a,(hl)
	ld (de),a
	swap a
	rlca
	add $02
	call interactionSetAnimation
++
	; [this.oamFlags] = [relatedObj1.oamFlags]
	ld e,Interaction.relatedObj1
	ld a,(de)
	ld h,a
	ld l,Interaction.oamFlags
	ld e,l
	ld a,(hl)
	ld (de),a

	jp interactionAnimate

;;
spinner_updateLinkPosition:
	; Check that the animParameter signals Link should change position (nonzero and
	; not $ff)
	ld e,Interaction.animParameter
	ld a,(de)
	ld b,a
	or a
	ret z
	inc a
	ret z

	xor a
	ld (de),a

	ld a,SND_DOORCLOSE
	call playSound

	; Read from table based on value of "animParameter" and "var39" to determine
	; Link's position relative to the spinner.
	ld e,Interaction.var39
	ld a,(de)
	add b
	and $0f
	ld hl,spinner_linkRelativePositions
	rst_addDoubleIndex

;;
; @param	hl	Address of 2 bytes (Y/X offset for Link relative to spinner)
spinner_setLinkRelativePosition:
	ld b,>w1Link
	ld e,Interaction.yh
	ld c,<w1Link.yh
	call @func

	ld e,Interaction.xh
	ld c,<w1Link.xh

@func:
	ld a,(de)
	add (hl)
	inc hl
	ld (bc),a
	ret


; Each row of below table represents data for a particular direction of transition:
;   b0: Y offset for Link relative to spinner
;   b1: X offset for Link relative to spinner
;   b2: Value for w1Link.direction
;   b3: Value for spinner.var39 (relative index for spinner_linkRelativePositions)
spinner_counterClockwiseData:
	.db $f4 $00 $03 $08 ; DIR_UP (Link enters from above)
	.db $00 $0c $00 $04 ; DIR_RIGHT
	.db $0c $00 $01 $00 ; DIR_DOWN
	.db $00 $f4 $02 $0c ; DIR_LEFT

spinner_clockwiseData:
	.db $f4 $00 $01 $08 ; DIR_UP
	.db $00 $0c $02 $04 ; DIR_RIGHT
	.db $0c $00 $03 $00 ; DIR_DOWN
	.db $00 $f4 $00 $0c ; DIR_LEFT


; Each row is a Y/X offset for Link. The row is selected from the animation's
; "animParameter" and "var39".
spinner_linkRelativePositions:
	.db $0c $00
	.db $0a $02
	.db $08 $08
	.db $02 $0a
	.db $00 $0c
	.db $fe $0a
	.db $f8 $08
	.db $f6 $02
	.db $f4 $00
	.db $f6 $fe
	.db $f8 $f8
	.db $fe $f6
	.db $00 $f4
	.db $02 $f6
	.db $08 $f8
	.db $0a $fe


; ==============================================================================
; INTERACID_MINIBOSS_PORTAL
; ==============================================================================
interactionCode7e:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
.ifdef ROM_SEASONS
	.dw @subid02
.endif


; Subid $00: miniboss portals
@subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @minibossState0
	.dw @state1
	.dw @state2
	.dw @minibossState3

@minibossState0:
	ld a,(wDungeonIndex)
	ld hl,@dungeonRoomTable
	rst_addDoubleIndex
	ld c,(hl)
	ld a,(wActiveGroup)
	ld hl,flagLocationGroupTable
	rst_addAToHl
	ld h,(hl)
	ld l,c

	; hl now points to room flags for the miniboss room
	; Delete if miniboss is not dead.
	ld a,(hl)
	and $80
	jp z,interactionDelete

	ld c,$57
	call objectSetShortPosition

@commonState0:
	call interactionInitGraphics
	ld a,$03
	call objectSetCollideRadius

	; Go to state 1 if Link's not touching the portal, state 2 if he is.
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ld a,$01
	jr nc,+
	inc a
+
	ld e,Interaction.state
	ld (de),a
	jp objectSetVisible83


; State 1: waiting for Link to touch the portal to initiate the warp.
@state1:
	call interactionAnimate
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc

	; Check that [w1Link.id] == SPECIALOBJECTID_LINK, check collisions are enabled
	ld a,(w1Link.id)
	or a
	call z,checkLinkCollisionsEnabled
	ret nc

	call resetLinkInvincibility
	ld a,$03
	ld e,Interaction.state
	ld (de),a
	ld (wLinkCanPassNpcs),a

	ld a,$30
	ld e,Interaction.counter1
	ld (de),a
	call setLinkForceStateToState08
	ld hl,w1Link.visible
	ld (hl),$82
	call objectCopyPosition ; Link.position = this.position

	ld a,$01
	ld (wDisabledObjects),a
	ld a,SND_TELEPORT
	jp playSound


; State 2: wait for Link to get off the portal before detecting collisions
@state2:
	call interactionAnimate
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret c
	ld a,$01
	ld e,Interaction.state
	ld (de),a
	ret


; State 3: Do the warp
@minibossState3:
	ld hl,w1Link
	call objectCopyPosition
	call @spinLink
	ret nz

	; Get starting room in 'b', miniboss room in 'c'
	ld a,(wDungeonIndex)
	ld hl,@dungeonRoomTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	ld hl,wWarpDestGroup
	ld a,(wActiveGroup)
	or $80
	ldi (hl),a
	ld a,(wActiveRoom)
	cp b
	jr nz,+
	ld b,c
+
	ld a,b
	ldi (hl),a  ; [wWarpDestRoom] = b
	lda TRANSITION_DEST_BASIC
	ldi (hl),a  ; [wWarpTransition] = TRANSITION_DEST_BASIC
	ld (hl),$57 ; [wWarpDestPos] = $57
	inc l
	ld (hl),$03 ; [wWarpTransition2] = $03 (fadeout)
	ret

; Each row corresponds to a dungeon. The first byte is the miniboss room index, the second
; is the dungeon entrance (the two locations of the portal).
; If bit 7 is set in the miniboss room's flags, the portal is enabled.
@dungeonRoomTable:
.ifdef ROM_AGES
	.db $01 $04
	.db $18 $24
	.db $34 $46
	.db $4d $66
	.db $80 $91
	.db $b4 $bb
	.db $12 $26
	.db $4d $56
	.db $82 $aa
.else
	.db $01 $01
	.db $0b $15
	.db $21 $39
	.db $48 $4b
	.db $6a $81
	.db $a2 $a7
	.db $c8 $ba
	.db $42 $5b
	.db $72 $87
.endif


@spinLink:
	call resetLinkInvincibility
	call interactionAnimate
	ld a,(wLinkDeathTrigger)
	or a
	ret nz
	ld a,(wFrameCounter)
	and $03
	jr nz,++
	ld hl,w1Link.direction
	ld a,(hl)
	inc a
	and $03
	ld (hl),a
++
	jp interactionDecCounter1


; Subid $01: miscellaneous portals used in Hero's Cave
@subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @herosCaveState0
	.dw @state1
	.dw @state2
	.dw @herosCaveState3

@herosCaveState0:
.ifdef ROM_AGES
	call interactionDeleteAndRetIfEnabled02
	ld e,Interaction.xh
	ld a,(de)
	ld e,Interaction.var03
	ld (de),a
	bit 7,a
	jr z,+
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ret z
+
	ld h,d
	ld e,Interaction.yh
	ld l,e
	ld a,(de)
	call setShortPosition
.else
	ld a,(wc64a)
	or a
	jp z,interactionDelete
.endif
	jp @commonState0

@herosCaveState3:
	call @spinLink
	ret nz

.ifdef ROM_AGES
	; Initiate the warp
	ld e,Interaction.var03
	ld a,(de)
	and $0f
	call @initHerosCaveWarp
	ld a,$84
	ld (wWarpDestGroup),a
	ret
.else
	ld a,(wc64a)
	jr @initHerosCaveWarp

@subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @herosCave2State0
	.dw @state1
	.dw @state2
	.dw @herosCave2State3

@herosCave2State0:
	call getThisRoomFlags
	and $20
	jp z,interactionDelete
	jp @commonState0

@herosCave2State3:
	call @spinLink
	ret nz
	xor a
.endif

@initHerosCaveWarp:
	ld hl,@herosCaveWarps
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld (wWarpDestPos),a
	ld a,$85
	ld (wWarpDestGroup),a
	lda TRANSITION_DEST_BASIC
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a ; Fadeout transition
	ret


; Each row corresponds to a value for bits 0-3 of "X" (later var03).
; First byte is "wWarpDestRoom" (room index), second is "wWarpDestPos".
@herosCaveWarps:
.ifdef ROM_AGES
	.db $c2 $11
	.db $c3 $2c
	.db $c4 $11
	.db $c5 $2c
	.db $c6 $7a
	.db $c9 $86
	.db $ce $57
	.db $cf $91
.else
	.db $30 $37
	.db $31 $9d
	.db $2f $95
	.db $28 $59
	.db $24 $57
	.db $34 $17
.endif


; ==============================================================================
; INTERACID_ESSENCE
; ==============================================================================
interactionCode7f:
	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interaction7f_subid00
	.dw interaction7f_subid01
	.dw interaction7f_subid02


; Subid $00: the essence itself
interaction7f_subid00:
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

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$04
	call objectSetCollideRadius

	; Create the pedestal
	ldbc INTERACID_ESSENCE, $01
	call objectCreateInteraction

	; Delete self if got essence
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete

	; Create the glow behind the essence
	ld hl,w1ReservedInteraction1
	ld b,$40
	call clearMemory
	ld hl,w1ReservedInteraction1
	ld (hl),$81
	inc l
	ld (hl),INTERACID_ESSENCE
	inc l
	ld (hl),$02
	call objectCopyPosition

	; [Glow.relatedObj1] = this
	ld l,Interaction.relatedObj1
	ldh a,(<hActiveObjectType)
	ldi (hl),a
	ldh a,(<hActiveObject)
	ld (hl),a

	; [this.zh] = -$10
	ld h,d
	ld l,Interaction.zh
	ld (hl),-$10

	ld a,(wDungeonIndex)
	dec a

.ifdef ROM_AGES
	; Override dungeon 6 past ($0b) with present ($05)
	cp $0b
	jr nz,+
	ld a,$05
+
.endif

	; [var03] = index of oam data?
	ld l,Interaction.var03
	ld (hl),a

	; a *= 3
	ld b,a
	add a
	add b

	ld hl,@essenceOamData
	rst_addAToHl
	ld e,Interaction.oamTileIndexBase
	ld a,(de)
	add (hl)
	inc hl
	ld (de),a

	; e = Interaction.oamFlags
	dec e
	ldi a,(hl)
	ld (de),a
	ld a,(hl)
	call interactionSetAnimation
	jp objectSetVisible81


; Each row is sprite data for an essence.
;   b0: Which tile index to start at (in gfx_essences.bin)
;   b1: palette (/ flags)
;   b2: which layout to use (2-tile or 4-tile)
@essenceOamData:
.ifdef ROM_AGES
	.db $00 $01 $01
	.db $04 $00 $02
	.db $06 $03 $02
	.db $08 $02 $02
	.db $0a $00 $02
	.db $0c $00 $02
	.db $0e $01 $01
	.db $12 $05 $01
.else
	.db $14 $00 $02
	.db $10 $01 $02
	.db $06 $05 $01
	.db $0a $04 $02
	.db $16 $05 $02
	.db $0c $04 $01
	.db $02 $02 $01
	.db $00 $03 $02
.endif


; State 1: waiting for Link to approach.
@state1:
	; Update z position every 4 frames
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld h,d
	ld l,Interaction.counter1
	inc (hl)
	ld a,(hl)
	and $0f
	ld hl,@essenceFloatOffsets
	rst_addAToHl
	ld a,(hl)
	add $f0
	ld e,Interaction.zh
	ld (de),a

	; Check various conditions for the essence to fall
	ld a,(wLinkInAir)
	or a
	ret nz
	ld a,(wLinkGrabState)
	or a
	ret nz
	ld b,$04
	call objectCheckCenteredWithLink
	ret nc
	ld c,$14
	call objectCheckLinkWithinDistance
	ret nc
	cp $04
	ret nz

	; Link has approached, essence will fall now.

	call clearAllParentItems
	ld a,$81
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a
	ld hl,w1Link.direction
	ld (hl),DIR_UP

	; Set angle, speed
	call objectGetAngleTowardLink
	ld h,d
	ld l,Interaction.angle
	ld (hl),a
	ld l,Interaction.speed
	ld (hl),SPEED_80

	ld l,Interaction.state
	inc (hl)

	call darkenRoom

	ld a,SND_DROPESSENCE
	call playSound
	ld a,SNDCTRL_SLOW_FADEOUT
	jp playSound

@essenceFloatOffsets:
	.db $00 $00 $ff $ff $ff $fe $fe $fe
	.db $fe $fe $fe $ff $ff $ff $ff $00


; State 2: Moving toward Link
@state2:
	call objectGetAngleTowardLink
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed
	call objectCheckCollidedWithLink_ignoreZ
	ret nc

	ld e,Interaction.collisionRadiusX
	ld a,$06
	ld (de),a
	jp interactionIncState


; State 3: Falling down
@state3:
	ld c,$08
	call objectUpdateSpeedZ_paramC
	jr z,++
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
++
	ld h,d
	ld l,Interaction.counter1
	ld (hl),30
	jp interactionIncState


; State 4: After delay, begin "essence get" cutscene
@state4:
	call interactionDecCounter1
	ret nz

	; Put Link in a 2-handed item get animation
	ld a,LINK_STATE_04
	ld (wLinkForceState),a
	ld a,$01
	ld (wcc50),a

	call interactionIncState

	; Set this object's position relative to Link
	ld a,(w1Link.yh)
	sub $0e
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ldi (hl),a
	inc l

	; [this.z] = 0
	xor a
	ldi (hl),a
	ld (hl),a

	; Show essence get text
	ld l,Interaction.var03
	ld a,(hl)
	ld hl,@getEssenceTextTable
	rst_addAToHl
	ld b,>TX_0000
	ld c,(hl)
	call showText

	call getThisRoomFlags
	set ROOMFLAG_BIT_ITEM,(hl)

	; Give treasure
	ld e,Interaction.var03
	ld a,(de)
	ld c,a
	ld a,TREASURE_ESSENCE
	jp giveTreasure

@getEssenceTextTable:
	.db <TX_000e
	.db <TX_000f
	.db <TX_0010
	.db <TX_0011
	.db <TX_0012
	.db <TX_0013
	.db <TX_0014
	.db <TX_0015


; State 5: waiting for textbox to close
@state5:
	call retIfTextIsActive

	call interactionIncState
	ld hl,mainScripts.essenceScript_essenceGetCutscene
	jp interactionSetScript


; State 6: running script (essence get cutscene)
@state6:
	call interactionRunScript
	ret nc

	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30


; State 7: After a delay, fade out
@state7:
	call interactionDecCounter1
	ret nz

	; Warp Link outta there
	ld l,Interaction.var03
	ld a,(hl)
	add a
	ld hl,@essenceWarps
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wWarpDestGroup),a
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld (wWarpDestPos),a
	ld a,(hl)
	ld (wWarpTransition),a
	ld a,$83
	ld (wWarpTransition2),a

	xor a
	ld (wActiveMusic),a

	jp clearStaticObjects


; Each row is warp data for getting an essence.
;   b0: wWarpDestGroup
;   b1: wWarpDestRoom
;   b2: wWarpDestPos
;   b3: wWarpTransition
@essenceWarps:
.ifdef ROM_AGES
	.db $80, $8d, $26, TRANSITION_DEST_SET_RESPAWN
	.db $81, $83, $25, TRANSITION_DEST_SET_RESPAWN
	.db $80, $ba, $55, TRANSITION_DEST_SET_RESPAWN
	.db $80, $03, $35, TRANSITION_DEST_X_SHIFTED
	.db $80, $0a, $17, TRANSITION_DEST_SET_RESPAWN
	.db $83, $0f, $16, TRANSITION_DEST_SET_RESPAWN
	.db $82, $90, $45, TRANSITION_DEST_X_SHIFTED
	.db $81, $5c, $15, TRANSITION_DEST_X_SHIFTED
.else
	.db $80, $96, $44, TRANSITION_DEST_SET_RESPAWN
	.db $80, $8d, $24, TRANSITION_DEST_SET_RESPAWN
	.db $80, $60, $25, TRANSITION_DEST_SET_RESPAWN
	.db $80, $1d, $13, TRANSITION_DEST_SET_RESPAWN
	.db $80, $8a, $25, TRANSITION_DEST_SET_RESPAWN
	.db $80, $00, $34, TRANSITION_DEST_SET_RESPAWN
	.db $80, $d0, $34, TRANSITION_DEST_SET_RESPAWN
	.db $81, $00, $33, TRANSITION_DEST_SET_RESPAWN
.endif


;;
; Pedestal for an essence
interaction7f_subid01:
	call checkInteractionState
	jp nz,objectPreventLinkFromPassing

	; Initialization
	ld a,$01
	ld (de),a
	ld bc,$060a
	call objectSetCollideRadii

	; Set tile above this one to be solid
	call objectGetTileAtPosition
	dec h
	ld (hl),$0f

.ifdef ROM_SEASONS
	ld a,(wDungeonIndex)
	cp $06
	jr nz,+
	ld hl,$ce24
	ld (hl),$05
	inc l
	ld (hl),$0a
+
.endif

	call interactionInitGraphics
	jp objectSetVisible83


;;
; The glowing thing behind the essence
interaction7f_subid02:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible82

@state1:
	call @copyEssencePosition
	call interactionAnimate

	; Flicker visibility when animParameter is nonzero
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	ld l,Interaction.visible
	ld a,$80
	xor (hl)
	ld (hl),a
	ret

@copyEssencePosition:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	jp objectTakePosition

.ends
