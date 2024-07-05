; ==================================================================================================
; ENEMY_BLADE_TRAP
; ENEMY_FLAME_TRAP
;
; Variables for normal traps:
;   var30: Speed
;
; Variables for circular traps:
;   var30: Center Y for circular traps
;   var31: Center X for circular traps
;   var32: Radius of circle for circular traps
; ==================================================================================================
enemyCode0e:
.ifdef ROM_SEASONS
enemyCode2b:
.endif
	dec a
	ret z
	dec a
	ret z
	call enemyAnimate
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub

@normalState:
	ld a,b
	rst_jumpTable
	.dw bladeTrap_subid00
	.dw bladeTrap_subid01
	.dw bladeTrap_subid02
	.dw bladeTrap_subid03
	.dw bladeTrap_subid04
	.dw bladeTrap_subid05


@state_uninitialized:
	ld a,b
	sub $03
	cp $02
	call c,bladeTrap_initCircular

	; Set different animation and var3e value for the spinning trap
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld a,$08
	jr nz,++

	ld a,$01
	call enemySetAnimation
	ld a,$01
++
	ld e,Enemy.var3e
	ld (de),a
	jp ecom_setSpeedAndState8AndVisible

@state_stub:
	ret


; Red, spinning trap
bladeTrap_subid00:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld a,$01
	jp enemySetAnimation


; Waiting for Link to walk into range
@state9:
	ld b,$0e
	call bladeTrap_checkLinkAligned
	ret nc
	call bladeTrap_checkObstructionsToTarget
	ret nz

	ld h,d
	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.counter1
	ld (hl),$18

	ld a,SND_MOVEBLOCK
	call playSound

	ld a,$02
	jp enemySetAnimation


; Moving toward Link (half-speed, just starting up)
@stateA:
	ld e,Enemy.counter1
	ld a,(de)
	rrca
	call c,ecom_applyVelocityForTopDownEnemyNoHoles
	call ecom_decCounter1
	jr nz,@animate

	ld l,Enemy.state
	ld (hl),$0b
@animate:
	jp enemyAnimate


; Moving toward Link
@stateB:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	jr nz,@animate

	; Hit wall
	ld e,Enemy.state
	ld a,$09
	ld (de),a
	ld a,$01
	jp enemySetAnimation


; Blue, gold blade traps (reach exactly to the center of a large room, no further)
bladeTrap_subid01:
bladeTrap_subid02:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.subid
	ld a,(hl)
	dec a
	ld a,SPEED_180
	jr z,+
	ld a,SPEED_300
+
	ld l,Enemy.var30
	ld (hl),a


; Waiting for Link to walk into range
@state9:
	ld b,$0d
	call bladeTrap_checkLinkAligned
	ret nc
	call bladeTrap_checkObstructionsToTarget
	ret nz

	ld a,$01
	call ecom_getTopDownAdjacentWallsBitset
	ret nz

	call ecom_incState

	ld e,Enemy.var30
	ld l,Enemy.speed
	ld a,(de)
	ld (hl),a
	ld a,SND_UNKNOWN5
	jp playSound


; Moving
@stateA:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	ld h,d
	jr z,@beginRetracting

	; Blade trap spans about half the size of a large room (which is different in
	ld l,Enemy.angle
	bit 3,(hl)
	ld b,((LARGE_ROOM_HEIGHT/2)<<4) + 8
	ld l,Enemy.yh
	jr z,++

	ld b,((LARGE_ROOM_WIDTH/2)<<4) + 8
	ld l,Enemy.xh
++
	ld a,(hl)
	sub b
	add $07
	cp $0f
	ret nc

@beginRetracting:
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld l,Enemy.state
	inc (hl)
	ld a,SND_CLINK
	jp playSound


; Retracting
@stateB:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	ret nz
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Cooldown of 16 frames
@stateC:
	call ecom_decCounter1
	ret nz
	ld l,Enemy.state
	ld (hl),$09
	ret


; Circular blade traps (clockwise & counterclockwise, respectively)
bladeTrap_subid03:
bladeTrap_subid04:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8

@state8:
	ld a,(wFrameCounter)
	and $01
	call z,bladeTrap_updateAngle

	; Update position
	ld h,d
	ld l,Enemy.var30
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	ld e,Enemy.angle
	jp objectSetPositionInCircleArc


; Unlimited range green blade
bladeTrap_subid05:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Initialization
@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.var30
	ld (hl),SPEED_200


; Waiting for Link to walk into range
@state9:
	ld b,$0e
	call bladeTrap_checkLinkAligned
	ret nc
	call bladeTrap_checkObstructionsToTarget
	ret nz

	ld a,$01
	call ecom_getTopDownAdjacentWallsBitset
	ret nz

	ld h,d
	ld e,Enemy.var30
	ld l,Enemy.speed
	ld a,(de)
	ld (hl),a

	ld l,Enemy.state
	inc (hl)
	ld a,SND_UNKNOWN5
	jp playSound


; Moving toward Link
@stateA:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	ret nz

	call ecom_incState
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ld a,SND_CLINK
	jp playSound


; Retracting
@stateB:
	call ecom_applyVelocityForTopDownEnemyNoHoles
	ret nz
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$10
	ret


; Cooldown of 16 frames
@stateC:
	call ecom_decCounter1
	ret nz
	ld l,Enemy.state
	ld (hl),$09
	ret

;;
; Only for subids 3-4 (circular traps)
bladeTrap_updateAngle:
	ld e,Enemy.subid
	ld a,(de)
	cp $03
	ld e,Enemy.angle
	jp nz,bladeTrap_decAngle
	jp bladeTrap_incAngle

;;
bladeTrap_initCircular:
	call getRandomNumber_noPreserveVars
	and $1f
	ld e,Enemy.angle
	ld (de),a

	ld e,Enemy.yh
	ld a,(de)
	ld c,a
	and $f0
	add $08
	ld e,Enemy.var30
	ld (de),a
	ld b,a

	ld a,c
	and $0f
	swap a
	add $08
	ld e,Enemy.var31
	ld (de),a
	ld c,a

	ld e,Enemy.xh
	ld a,(de)
	ld e,Enemy.var32
	ld (de),a

	ld e,Enemy.angle
	jp objectSetPositionInCircleArc


; Position offset to add when checking each successive tile between the trap and the
; target for solidity
bladeTrap_directionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
; @param[out]	zflag	z if there are no obstructions (solid tiles) between trap and
;			target
bladeTrap_checkObstructionsToTarget:
	ld h,d
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ldh a,(<hEnemyTargetX)
	sub c
	add $04
	cp $09
	jr nc,++

	ldh a,(<hEnemyTargetY)
	sub b
	add $04
	cp $09
	ret c
++
	ld l,Enemy.angle
	call @getNumTilesToTarget

	; Get direction offset in hl
	ld a,(hl)
	rrca
	rrca
	ld hl,bladeTrap_directionOffsets
	rst_addAToHl
	ldi a,(hl)
	ld l,(hl)
	ld h,a

	; Check each tile between the trap and the target for solidity
	push de
	ld d,>wRoomCollisions
--
	call @checkNextTileSolid
	jr nz,++
	ldh a,(<hFF8B)
	dec a
	ldh (<hFF8B),a
	jr nz,--
++
	pop de
	ret

;;
; @param	bc	Tile we're at right now
; @param	d	>wRoomCollisions
; @param	hl	Value to add to bc each time (direction offset)
; @param[out]	zflag	nz if tile is solid
@checkNextTileSolid:
	ld a,b
	add h
	ld b,a
	and $f0
	ld e,a
	ld a,c
	add l
	ld c,a
	and $f0
	swap a
	or e
	ld e,a
	ld a,(de)
	or a
	ret

;;
; @param	bc	Enemy position
; @param	hl	Enemy angle
; @param[out]	hFF8B	Number of tiles between enemy and target
@getNumTilesToTarget:
	ld e,b
	ldh a,(<hEnemyTargetY)
	bit 3,(hl)
	jr z,+
	ld e,c
	ldh a,(<hEnemyTargetX)
+
	sub e
	jr nc,+
	cpl
	inc a
+
	swap a
	and $0f
	jr nz,+
	inc a
+
	ldh (<hFF8B),a
	ret

;;
; Determines if Link is aligned close enough on the X or Y axis to be attacked; if so,
; this sets the blade's angle accordingly.
;
; @param	b	How close Link must be (on the orthogonal axis relative to the
;			attack) before the trap can attack
; @param[out]	cflag	c if Link is in range
bladeTrap_checkLinkAligned:
	ld c,b
	sla c
	inc c
	ld e,$00
	ld h,d
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add b
	cp c
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	jr c,@inRange

	ld e,$18
	sub (hl)
	add b
	cp c
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	ret nc

@inRange:
	cp (hl)
	ld a,e
	jr c,+
	xor $10
+
	ld l,Enemy.angle
	ld (hl),a
	scf
	ret

;;
bladeTrap_incAngle:
	ld a,(de)
	inc a
	jr ++

;;
bladeTrap_decAngle:
	ld a,(de)
	dec a
++
	and $1f
	ld (de),a
	ret
