; In common folder because Ages has a stub

;;
; ITEM_MAGNET_BALL
; Variables:
;   var03: Disables collisions and uses custom code to prevent enemies passing
;		   through it (for wall flame shooters)
;   var30/var31: Set to initial yh,xh to reset ball's position in wStaticObjects
;                if ball fell in hole
;   var32: boolean that restricts friction from its max of SPEED_300 to SPEED_100
;   var33: vertical friction - the higher, the faster
;   var34: horizontal friction
itemCode29:

.ifdef ROM_SEASONS
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @unitialized
	.dw @mainState
	.dw @fallingDownCliff

@unitialized:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,Item.speed
	ld (hl),SPEED_40
	ld l,Item.yh
	ld a,(hl)
	ld b,a
	ld l,Item.xh
	ld a,(hl)
	ld l,Item.var31
	ldd (hl),a
	ld (hl),b
	call itemLoadAttributesAndGraphics
	xor a
	call itemSetAnimation
	call objectSetVisiblec3

	; Room with the wall flame shooters
	ld a,(wActiveGroup)
	cp >ROOM_SEASONS_494
	jr nz,@mainState
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_494
	jr nz,@mainState
	ld e,Item.var03
	ld a,$01
	ld (de),a

@mainState:
	call @mainStateBody
	call @applySpeedIfNoCollision
	ld e,Item.collisionType
	ld a,(de)
	bit 7,a
	ret nz
	jp @blockAllWallFlameShooters

; Saves ball's position, deals with collision with Link, cliffs and holes,
; slows down if not hooked on to, checks if hooked on to, move the ball if hooked,
; begin attracting or repelling the ball
@mainStateBody:
	ld h,d
	ld l,Item.var03
	ld a,(hl)
	or a
	jr nz,+
	ld l,Item.collisionType
	res 7,(hl)
+
	call @savePositionInStaticObjects
	call @preventLinkFromPassing
	ld a,(wMagnetGloveState)
	or a
	jp z,@slowDownCheckCliffHolesAndRoomBoundary
	ld b,$0c
	call objectCheckCenteredWithLink
	jp nc,@slowDownCheckCliffHolesAndRoomBoundary

	; store in b 0-3 based on opposite angle towards Link
	call objectGetAngleTowardLink
	add $04
	add a
	swap a
	and $03
	xor $02
	ld b,a

	ld a,(w1Link.direction)
	cp b
	jp nz,@slowDownCheckCliffHolesAndRoomBoundary

	; Link facing ball, using magnet gloves, and near enough to ball
	ld e,Item.speed
	ld a,SPEED_100
	ld (de),a
	ld e,Item.var32
	ld a,(de)
	or a
	jr z,+
	; Item.var33
	inc e
	ld a,(de)
	cp $10
	jp nc,@slowDownCheckCliffHolesAndRoomBoundary
	; Item.var34
	inc e
	ld a,(de)
	cp $10
	jp nc,@slowDownCheckCliffHolesAndRoomBoundary
	ld e,Item.var32
	xor a
	ld (de),a
+
	ld a,(wMagnetGloveState)
	bit 1,a
	jr nz,@repelBall

	; attract ball
	ld a,(w1Link.direction)
	ld hl,@linksRelativePositionForFF8D_FF8CbasedOnLinkDirection
	rst_addDoubleIndex
	ld a,(w1Link.yh)
	add (hl)
	ldh (<hFF8D),a
	inc hl
	ld a,(w1Link.xh)
	add (hl)
	ldh (<hFF8C),a
	push bc
	call @checkLinkInBallsPosition
	pop bc
	jp c,@moveBallCheckCliffsAndRoomBoundary

	bit 0,b
	jr nz,+
	call @horizontalAttractBall
	ld e,Item.state
	ld a,(de)
	cp $01
	ret nz
	call @incVar33IfNotff
	call @applySpeedBasedOnVar33
	jp @verticalAttractBall
+
	call @verticalAttractBall
	ld e,Item.state
	ld a,(de)
	cp $01
	ret nz
	call @incVar34IfNotff
	call @applySpeedBasedOnVar34
	jp @horizontalAttractBall

@repelBall:
	ld a,(w1Link.yh)
	ldh (<hFF8D),a
	ld a,(w1Link.xh)
	ldh (<hFF8C),a
	bit 0,b
	jr nz,+
	call @horizontalAttractBall
	ld e,Item.state
	ld a,(de)
	cp $01
	ret nz
	call @incVar33IfNotff
	call @applySpeedBasedOnVar33
	jp @verticalRepelBall
+
	call @verticalAttractBall
	ld e,Item.state
	ld a,(de)
	cp $01
	ret nz
	call @incVar34IfNotff
	call @applySpeedBasedOnVar34
	jp @horizontalRepelBall

@slowDownCheckCliffHolesAndRoomBoundary:
	ld e,Item.var33
	ld a,(de)
	or a
	jr z,+
	ld e,Item.var32
	ld a,$01
	ld (de),a
	call @keepVar33LessThan40_decVar33IfNot0
	call @keepVar33LessThan40_decVar33IfNot0
	call @applySpeedBasedOnVar33
	ld e,Item.angle
	ld a,(de)
	call @checkBallShouldBeDroppedOffCliffOrLeavingRoom
+
	ld e,Item.var34
	ld a,(de)
	or a
	jr z,+
	ld e,Item.var32
	ld a,$01
	ld (de),a
	call @keepVar34LessThan40_decVar34IfNot0
	call @keepVar34LessThan40_decVar34IfNot0
	call @applySpeedBasedOnVar34
	ld e,Item.angle
	ld a,(de)
	call @checkBallShouldBeDroppedOffCliffOrLeavingRoom
+
	call objectCheckIsOnHazard
	jp c,@ballDropped_positionResetOnRoomReentry
	ret

@ballDropped_positionResetOnRoomReentry:
	ldh (<hFF8B),a
	call @saveInitialPositionInStaticObjects
	ldh a,(<hFF8B)
	dec a
	jp z,objectReplaceWithSplash
	jp objectReplaceWithFallingDownHoleInteraction

@moveBallCheckCliffsAndRoomBoundary:
	xor a
	ld e,Item.var33
	ld (de),a
	ld e,Item.var34
	ld (de),a

	ld a,(wLinkAngle)
	cp $ff
	ret z

	ld a,(wGameKeysPressed)
	ld b,a
	bit BTN_BIT_UP,b
	jr z,+
	ld a,ANGLE_UP
	call @setAngleAndCheckBallShouldBeDroppedOffCliffOrLeavingRoom
	jr ++

+
	bit BTN_BIT_DOWN,b
	jr z,++
	ld a,ANGLE_DOWN
	call @setAngleAndCheckBallShouldBeDroppedOffCliffOrLeavingRoom
++
	ld a,(wGameKeysPressed)
	ld b,a
	bit BTN_BIT_RIGHT,b
	jr z,+
	ld a,ANGLE_RIGHT
	jr @setAngleAndCheckBallShouldBeDroppedOffCliffOrLeavingRoom
+
	bit BTN_BIT_LEFT,b
	ld a,ANGLE_LEFT
	ret z

@setAngleAndCheckBallShouldBeDroppedOffCliffOrLeavingRoom:
	ld e,Item.angle
	ld (de),a
	jp @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@checkLinkInBallsPosition:
	ldh a,(<hFF8D)
	ld b,a
	ldh a,(<hFF8C)
	ld c,a
	jp objectCheckContainsPoint

@fallingDownCliff:
	ld h,d
	ld l,Item.collisionType
	set 7,(hl)
	ld l,Item.direction
	ldi a,(hl)
	; Item.angle
	ld (hl),a
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld a,SND_DROPESSENCE
	call playSound
	ld h,d
	ld l,Item.counter1
	dec (hl)
	jr z,+
	ld bc,$ff20
	ld l,Item.speedZ
	ld (hl),c
	inc l
	ld (hl),b
	ld l,Item.speed
	ld (hl),$14
	ret
+
	ld a,$01
	ld e,Item.state
	ld (de),a
	ret

@linksRelativePositionForFF8D_FF8CbasedOnLinkDirection:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

@verticalAttractBall:
	ld b,ANGLE_UP
	ld c,ANGLE_DOWN
	call @loadBIntoAngleIfLinkAboveBallElseLoadC
	ret z
	jr @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@horizontalAttractBall:
	ld b,ANGLE_LEFT
	ld c,ANGLE_RIGHT
	call @loadBIntoAngleIfLinkLeftOfBallElseLoadC
	ret z
	jr @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@verticalRepelBall:
	ld b,ANGLE_DOWN
	ld c,ANGLE_UP
	call @loadBIntoAngleIfLinkAboveBallElseLoadC
	ret z
	jr @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@horizontalRepelBall:
	ld b,ANGLE_RIGHT
	ld c,ANGLE_LEFT
	call @loadBIntoAngleIfLinkLeftOfBallElseLoadC
	ret z
	jr @checkBallShouldBeDroppedOffCliffOrLeavingRoom

@loadBIntoAngleIfLinkAboveBallElseLoadC:
	ldh a,(<hFF8D)
	ld l,Item.yh
	ld e,Item.var33
-
	ld h,d
	cp (hl)
	ld a,b
	jr c,+
	ld a,c
+
	ld l,Item.angle
	ld (hl),a
	ret

@loadBIntoAngleIfLinkLeftOfBallElseLoadC:
	ldh a,(<hFF8C)
	ld l,Item.xh
	ld e,Item.var34
	jr -

@checkBallShouldBeDroppedOffCliffOrLeavingRoom:
	srl a
	ld hl,@positionOf2TilesJustAheadOfBall
	rst_addAToHl
	call @checkRelativeHLTileCollision_allowHoles
	jr c,+
	call @checkRelativeHLTileCollision_allowHoles
	jr c,+
	ld h,d
	ld l,Item.collisionType
	set 7,(hl)
	call objectApplySpeed
	jr @preventFromLeavingRoom
+
	call @checkBallShouldBeDroppedOffCliff
	; var33 is set to 0 if angle is N/S
	; var34 is set to 0 if angle is E/W
	ld e,Item.angle
	ld a,(de)
	bit 3,a
	ld e,Item.var33
	jr z,+
	; Item.var34
	inc e
+
	xor a
	ld (de),a
	ret

@checkRelativeHLTileCollision_allowHoles:
	ld e,Item.yh
	ld a,(de)
	add (hl)
	inc hl
	ld b,a
	ld e,Item.xh
	ld a,(de)
	add (hl)
	inc hl
	ld c,a
	push hl
	call checkTileCollisionAt_allowHoles
	pop hl
	ret

@positionOf2TilesJustAheadOfBall:
	.db $f8 $fc $f8 $04
	.db $fc $08 $04 $08
	.db $08 $fc $08 $04
	.db $fc $f8 $04 $f8

@applySpeedIfNoCollision:
	call objectGetTileAtPosition
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	ret nc
	call objectGetPosition
	ld a,$05
	add b
	ld b,a
	call checkTileCollisionAt_allowHoles
	ret nc
	ld b,SPEED_80
	call @loadBIntoItemSpeed
	ld e,Item.angle
	xor a
	ld (de),a
	jp objectApplySpeed

@preventFromLeavingRoom:
	; max yh, xh
	ldbc $a8 $e8
	ld e,$08
	ld h,d
	ld l,Item.yh
	ld a,e
	cp (hl)
	jr c,+
	ld (hl),a
+
	ld a,b
	cp (hl)
	jr nc,+
	ld (hl),a
+
	ld l,Item.xh
	ld a,e
	cp (hl)
	jr c,+
	ld (hl),a
+
	ld a,c
	cp (hl)
	ret nc
	ld (hl),a
	ret

@applySpeedBasedOnVar33:
	ld e,Item.var33
--
	ld a,(de)
	cp $40
	ld b,SPEED_300
	jr nc,@loadBIntoItemSpeed
	and $38
	swap a
	rlca
	ld hl,@magnetBallSpeeds
	rst_addAToHl
	ld b,(hl)

@loadBIntoItemSpeed:
	ld a,b
	ld e,Item.speed
	ld (de),a
	ret

@applySpeedBasedOnVar34:
	ld e,Item.var34
	jr --

; moves faster the longer you've interacted with it
@magnetBallSpeeds:
	.db SPEED_040
	.db SPEED_080
	.db SPEED_100
	.db SPEED_140
	.db SPEED_180
	.db SPEED_1c0
	.db SPEED_200
	.db SPEED_200

@incVar33IfNotff:
	ld h,d
	ld l,Item.var33
	inc (hl)
	ret nz
	dec (hl)
	ret

@incVar34IfNotff:
	ld h,d
	ld l,Item.var34
	inc (hl)
	ret nz
	dec (hl)
	ret

@keepVar33LessThan40_decVar33IfNot0:
	ld l,Item.var33
--
	ld h,d
	ld a,(hl)
	cp $40
	jr c,+
	ld a,$40
+
	or a
	ret z
	dec a
	ld (hl),a
	ret

@keepVar34LessThan40_decVar34IfNot0:
	ld l,Item.var34
	jr --

@retCIfTileAtRelativePositionHLIsTopOfCliff:
	ld e,Item.yh
	ld a,(de)
	add (hl)
	inc hl
	ld b,a
	ld e,Item.xh
	ld a,(de)
	add (hl)
	inc hl
	ld c,a
	push hl
	call getTileAtPosition
	pop hl
	sub $b0
	cp $04
	ret

@checkBallShouldBeDroppedOffCliff:
	call @convertAngleTo0To3
	add a
	ld hl,@positionOf2TilesJustAheadOfBall
	rst_addDoubleIndex
	call @retCIfTileAtRelativePositionHLIsTopOfCliff
	ret nc
	call @retCIfTileAtRelativePositionHLIsTopOfCliff
	ret nc
	; a is the type of wall from 0 to 3
	add $02
	and $03
	swap a
	rrca
	ld b,a
	ld e,Item.angle
	ld a,(de)
	cp b
	ret nz
	sra a

	ld hl,@cliffDropData
	rst_addAToHl
	ldi a,(hl)
	ld e,Item.direction
	ld (de),a
	ldi a,(hl)
	ld e,Item.speed
	ld (de),a
	ldi a,(hl)
	ld e,Item.speedZ
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	; reset var32 - var34
	xor a
	ld h,d
	ld l,Item.var32
	ldi (hl),a
	ldi (hl),a
	ld (hl),a

	ld l,Item.counter1
	ld (hl),$02
	ld l,Item.state
	ld (hl),$02
	ret

@cliffDropData:
	dbbw ANGLE_UP    SPEED_100 $fe40
	dbbw ANGLE_RIGHT SPEED_100 $fe40
	dbbw ANGLE_DOWN  SPEED_100 $fe40
	dbbw ANGLE_LEFT  SPEED_100 $fe40

@convertAngleTo0To3:
	ld e,Item.angle
	ld a,(de)
	add $04
	add a
	swap a
	and $03
	ret

@blockAllWallFlameShooters:
	ldhl FIRST_ENEMY_INDEX, Enemy.start
-
	ld a,(hl)
	or a
	call nz,@blockWallFlameShooter
	inc h
	ld a,h
	cp $e0
	jr c,-
	ret

@blockWallFlameShooter:
	push hl
	ld l,Enemy.zh
	bit 7,(hl)
	call z,preventObjectHFromPassingObjectD
	pop hl
	ret

@saveInitialPositionInStaticObjects:
	ld e,Item.var30 ; yh
	ld a,(de)
	ld b,a
	; Item.var31 ; xh
	inc e
	ld a,(de)
	ld c,a
	jr +

@savePositionInStaticObjects:
	call objectCheckIsOnHazard
	ret c
	ld e,Item.yh
	ld a,(de)
	ld b,a
	ld e,Item.xh
	ld a,(de)
	ld c,a
+
	ld e,Item.relatedObj1
	ld a,(de)
	ld l,a
	inc e
	ld a,(de)
	ld h,a
	push bc
	ld bc,$0004
	add hl,bc
	pop bc
	; Make sure magnet ball is not too close to room edges so Link can walk in
	ld a,b
	cp $18
	jr nc,+
	ld a,$18
+
	cp $99
	jr c,+
	ld a,$98
+
	ldi (hl),a
	ld a,c
	cp $18
	jr nc,+
	ld a,$18
+
	cp $d9
	jr c,+
	ld a,$d8
+
	ld (hl),a
	ret

@preventLinkFromPassing:
	ld a,(wLinkInAir)
	rlca
	ret c
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	call objectCheckCollidedWithLink_ignoreZ
	ret nc
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	call objectCheckContainsPoint
	jr c,+
	call objectGetAngleTowardLink
	ld c,a
	ld b,SPEED_300
	jp updateLinkPositionGivenVelocity
+
	call objectGetAngleTowardLink
	ld c,a
	ld b,SPEED_080
	jp updateLinkPositionGivenVelocity

.endif
