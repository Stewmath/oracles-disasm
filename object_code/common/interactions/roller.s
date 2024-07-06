; ==================================================================================================
; INTERAC_ROLLER
;
; Variables:
;   counter1:
;   counter2:
;   var30: Original X-position, where it returns to
;   var31: Counter before showing "it's too heavy to move" text.
; ==================================================================================================
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
	ld a,ITEM_BRACELET
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
