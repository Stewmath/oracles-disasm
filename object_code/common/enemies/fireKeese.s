; ==================================================================================================
; ENEMY_FIRE_KEESE
;
; Variables:
;   var30: Distance away (in tiles) closest lit torch is
;   var31/var32: Position of lit torch it's moving towards to re-light itself
;   var33: Nonzero if fire has been shed (set to 2). Doubles as animation index?
;   var34: Position at which to search for a lit torch ($16 tiles are checked each frame,
;          so this gets incremented by $16 each frame)
;   var35: Angular rotation for subid 0. (set to -1 or 1 randomly on initialization, for
;          counterclockwise or clockwise movement)
; ==================================================================================================
enemyCode39:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackNoSolidity

	; ENEMYSTATUS_JUST_HIT
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	ret nz

	; We collided with Link; if still on fire, transfer that fire to the ground.
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret nz

	ld b,PART_FIRE
	call ecom_spawnProjectile

	ld h,d
	ld l,Enemy.oamFlags
	ld a,$01
	ldd (hl),a
	ld (hl),a

	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.damage
	ld (hl),-$04

	ld l,Enemy.var33
	ld (hl),$02

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	ld a,$03
	jp enemySetAnimation

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	cp $0b
	jr nc,fireKeese_stateBOrHigher
	rst_jumpTable
	.dw fireKeese_state_uninitialized
	.dw fireKeese_state_stub
	.dw fireKeese_state_stub
	.dw fireKeese_state_stub
	.dw fireKeese_state_stub
	.dw ecom_blownByGaleSeedState
	.dw fireKeese_state_stub
	.dw fireKeese_state_stub
	.dw fireKeese_state8
	.dw fireKeese_state9
	.dw fireKeese_stateA

fireKeese_stateBOrHigher:
	ld a,b
	rst_jumpTable
	.dw fireKeese_subid0
	.dw fireKeese_subid1


fireKeese_state_uninitialized:
	ld h,d
	ld l,Enemy.counter1
	ld (hl),$08

	ld l,Enemy.damage
	ld (hl),-$08

	bit 0,b
	ld l,e
	jr z,@subid0

@subid1:
	ld (hl),$0b ; [state]
	jp objectSetVisible82

@subid0:
	ld (hl),$0b ; [state]

	ld l,Enemy.zh
	ld (hl),-$1c

	ld l,Enemy.speed
	ld (hl),SPEED_80

	; Random angle
	ld bc,$1f01
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a

	; Set var35 to 1 or -1 for clockwise or counterclockwise movement.
	ld a,c
	or a
	jr nz,+
	dec a
+
	ld e,Enemy.var35
	ld (de),a

	ld a,$01
	call enemySetAnimation
	jp objectSetVisiblec1


fireKeese_state_stub:
	ret


; Just lost fire; looks for a torch if one exists, otherwise it will keep flying around
; like normal.
fireKeese_state8:
	; Initialize "infinite" distance away from closest lit torch (none found yet)
	ld e,Enemy.var30
	ld a,$ff
	ld (de),a

	; Check all tiles in the room, try to find a lit torch to light self back on fire
	call objectGetTileAtPosition
	ld c,l
	ld l,$00
@nextTile:
	ld a,(hl)
	cp TILEINDEX_LIT_TORCH
	call z,fireKeese_addCandidateTorch
	inc l
	ld a,l
	cp LARGE_ROOM_HEIGHT<<4
	jr c,@nextTile

	; Check if one was found
	ld e,Enemy.var30
	ld a,(de)
	inc a
	ld h,d
	jr nz,@torchFound

	; No torch found. Go back to doing subid-specific movement.

	ld l,Enemy.subid
	bit 0,(hl)
	ld a,$0d
	jr z,++

	; Subid 1
	ld l,Enemy.counter1
	ld (hl),120
	ld a,$0c
++
	ld l,Enemy.state
	ld (hl),a
	ret

@torchFound:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld a,$03
	jp enemySetAnimation


; Moving towards a torch's position, marked in var31/var32
fireKeese_state9:
	ld h,d
	ld l,Enemy.var31
	call ecom_readPositionVars
	cp c
	jr nz,@notAtTargetPosition

	ldh a,(<hFF8F)
	cp b
	jr z,@atTargetPosition

@notAtTargetPosition:
	call fireKeese_moveToGround
	call ecom_moveTowardPosition
	jp enemyAnimate

@atTargetPosition:
	call fireKeese_moveToGround
	ret c

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),60

	ld a,$02
	jp enemySetAnimation


; Touched down on the torch; in the process of being lit back on fire
fireKeese_stateA:
	call ecom_decCounter1
	jr z,@gotoNextState

	ld a,(hl) ; [counter1]
	sub 30
	ret nz

	; [counter1] == 30
	ld l,Enemy.oamFlags
	ld a,$05
	ldd (hl),a
	ld (hl),a

	ld l,Enemy.damage
	ld (hl),-$08
	ld l,Enemy.var33
	xor a
	ld (hl),a
	jp enemySetAnimation

@gotoNextState:
	ld l,Enemy.angle
	ld a,(hl)
	add $10
	and $1f
	ld (hl),a

	ld l,Enemy.subid
	bit 0,(hl)
	ld a,$0d
	jr z,++

	; Subid 1
	ld l,Enemy.counter1
	ld (hl),120
	ld a,$0c
++
	ld (de),a
	ld a,$01
	jp enemySetAnimation


; Keese which move up and down on Z axis
fireKeese_subid0:
	call fireKeese_checkForNewlyLitTorch
	; Above function call may pop its return address, ignore everything below here

	ld e,Enemy.state
	ld a,(de)
	sub $0b
	rst_jumpTable
	.dw fireKeese_subid0_stateB
	.dw fireKeese_subid0_stateC
	.dw fireKeese_subid0_stateD


; Flying around on fire
fireKeese_subid0_stateB:
	call fireKeese_checkCloseToLink
	jr nc,@linkNotClose

	; Link is close
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),91
	ld l,Enemy.speed
	ld (hl),SPEED_a0

@linkNotClose:
	call ecom_decCounter1
	jr nz,++

	ld (hl),$08 ; [counter1]

	; Move clockwise or counterclockwise (var35 is randomly set to 1 or -1 on
	; initialization)
	ld e,Enemy.var35
	ld a,(de)
	ld l,Enemy.angle
	add (hl)
	and $1f
	ld (hl),a
++
	call objectApplySpeed
	call fireKeese_moveTowardCenterIfOutOfBounds
	jr fireKeese_animate


; Divebombing because Link got close enough
fireKeese_subid0_stateC:
	call ecom_decCounter1
	jr nz,++
	ld l,Enemy.state
	inc (hl)
	jr fireKeese_animate
++
	; Add some amount to Z-position
	ld a,(hl)
	and $f0
	swap a
	ld hl,fireKeese_subid0_zOffsets
	rst_addAToHl

	ld e,Enemy.z
	ld a,(de)
	add (hl)
	ld (de),a
	inc e
	ld a,(de)
	adc $00
	ld (de),a

	; Adjust angle toward Link
	call objectGetAngleTowardEnemyTarget
	ld b,a
	ld e,Enemy.counter1
	ld a,(de)
	and $03
	ld a,b
	call z,objectNudgeAngleTowards

fireKeese_updatePosition:
	call ecom_bounceOffScreenBoundary
	call objectApplySpeed

fireKeese_animate:
	jp enemyAnimate


; Moving back up after divebombing
fireKeese_subid0_stateD:
	ld h,d
	ld l,Enemy.z
	ld a,(hl)
	sub <($0040)
	ldi (hl),a
	ld a,(hl)
	sbc >($0040)
	ld (hl),a

	cp $e4
	jr nc,fireKeese_updatePosition

	ld l,e
	ld (hl),$0b ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.counter1
	ld (hl),$08
	jr fireKeese_animate


; Keese which has no Z-axis movement
fireKeese_subid1:
	call fireKeese_checkForNewlyLitTorch
	; Above function call may pop its return address, ignore everything below here

	ld e,Enemy.state
	ld a,(de)
	sub $0b
	rst_jumpTable
	.dw fireKeese_subid1_stateB
	.dw fireKeese_subid1_stateC
	.dw fireKeese_subid1_stateD


; Waiting [counter1] frames (8 frames) before moving
fireKeese_subid1_stateB:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	; Random angle
	ld bc,$1f3f
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.angle
	ld a,b
	ld (de),a

	; Random counter1 between $c0-$ff
	ld a,$c0
	add c
	ld e,Enemy.counter1
	ld (de),a

	; Set animation based on if on fire
	ld e,Enemy.var33
	ld a,(de)
	inc a
	call enemySetAnimation

	; Create fire when initially spawning
	ld e,Enemy.var33
	ld a,(de)
	or a
	ld b,PART_FIRE
	call z,ecom_spawnProjectile
	jp enemyAnimate


; Moving around randomly for [counter1]*2 frames
fireKeese_subid1_stateC:
	call fireKeese_updatePosition

	ld a,(wFrameCounter)
	and $01
	ret nz

	call ecom_decCounter1
	jr z,@gotoNextState

	; 1 in 16 chance of changing angle (every 2 frames)
	ld bc,$0f1f
	call ecom_randomBitwiseAndBCE
	or b
	ret nz
	ld e,Enemy.angle
	ld a,c
	ld (de),a
	ret

@gotoNextState:
	ld l,Enemy.state
	inc (hl)
	ret


; Slowing down, then stopping for a brief period
fireKeese_subid1_stateD:
	ld e,Enemy.counter1
	ld a,(de)
	cp $68
	jr nc,++

	call ecom_bounceOffScreenBoundary
	call objectApplySpeed
++
	call fireKeese_subid1_setSpeedAndAnimateBasedOnCounter1

	ld h,d
	ld l,Enemy.counter1
	inc (hl)
	ld a,$7f
	cp (hl)
	ret nz

	; Time to start moving again; go back to state $0b where we'll abruptly go fast.
	ld l,Enemy.state
	ld (hl),$0b

	ld e,Enemy.var33
	ld a,(de)
	call enemySetAnimation

	; Set counter1 to random value from $20-$9f
	call getRandomNumber_noPreserveVars
	and $7f
	ld e,Enemy.counter1
	add $20
	ld (de),a
	ret


;;
; Subid 1 slows down gradually in state $0d.
fireKeese_subid1_setSpeedAndAnimateBasedOnCounter1:
	ld e,Enemy.counter1
	ld a,(de)
	and $0f
	jr nz,++

	; Set speed based on value of counter1
	ld a,(de)
	swap a
	ld hl,fireKeese_subid1_speeds
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
++
	; Animate at some rate based on value of counter1
	ld e,Enemy.counter1
	ld a,(de)
	and $f0
	swap a
	ld hl,fireKeese_subid1_animFrequencies
	rst_addAToHl
	ld a,(wFrameCounter)
	and (hl)
	jp z,enemyAnimate
	ret


;;
; @param[out]	cflag	c if Link is within 32 pixels of keese in each direction
fireKeese_checkCloseToLink:
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add $20
	cp $41
	ret nc
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $20
	cp $41
	ret


;;
; Given the position of a torch, checks whether to update "position of closest known
; torch" (var31/var32).
;
; @param	c	Position of lit torch
fireKeese_addCandidateTorch:
	; Get Y distance
	ld a,c
	and $f0
	swap a
	ld b,a
	ld a,l
	and $f0
	swap a
	sub b
	jr nc,+
	cpl
	inc a
+
	ld b,a

	; Get X distance
	ld a,c
	and $0f
	ld e,a
	ld a,l
	and $0f
	sub e
	jr nc,+
	cpl
	inc a
+
	; Compare with closest candidate, return if farther away
	add b
	ld b,a
	ld e,Enemy.var30
	ld a,(de)
	cp b
	ret c

	; This is the closest torch found so far.
	ld a,b
	ld (de),a

	; Mark its position in var31/var32
	ld e,Enemy.var31
	ld a,l
	and $f0
	add $08
	ld (de),a
	inc e
	ld a,l
	and $0f
	swap a
	add $08
	ld (de),a
	ret


;;
; While the keese is not lit on fire, this function checks if any new lit torches suddenly
; appear in the room. If so, it sets the state to 8 and returns from the caller (discards
; return address).
fireKeese_checkForNewlyLitTorch:
	; Return if on fire already
	ld e,Enemy.var33
	ld a,(de)
	or a
	ret z

	; Check $16 tiles per frame, searching for a torch. (Searching all of them could
	; cause lag, especially with a lot of bats on-screen.)
	ld e,Enemy.var34
	ld a,(de)
	ld l,a
	ld h,>wRoomLayout
	ld b,$16
@loop:
	ldi a,(hl)
	cp TILEINDEX_LIT_TORCH
	jr z,@foundTorch
	dec b
	jr nz,@loop

	ld a,l
	cp LARGE_ROOM_HEIGHT<<4
	jr nz,+
	xor a
+
	ld (de),a
	ret

@foundTorch:
	pop hl ; Return from caller

	ld h,d
	ld l,e
	ld (hl),$00 ; [var34]

	; State 8 will cause the bat to move toward the torch.
	; (var31/var32 are not set here because the search will be done again in state 8.)
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ret

;;
; @param[out]	cflag	nc if reached ground (or at most 6 units away)
fireKeese_moveToGround:
	ld e,Enemy.zh
	ld a,(de)
	or a
	ret z

	cp $fa
	ret nc

	; [Enemy.z] += $0080
	dec e
	ld a,(de)
	add <($0080)
	ld (de),a
	inc e
	ld a,(de)
	adc >($0080)
	ld (de),a
	scf
	ret


;;
fireKeese_moveTowardCenterIfOutOfBounds:
	ld e,Enemy.yh
	ld a,(de)
	cp LARGE_ROOM_HEIGHT<<4
	jr nc,@outOfBounds

	ld e,Enemy.xh
	ld a,(de)
	cp $f0
	ret c

@outOfBounds:
	ld e,Enemy.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Enemy.xh
	ld a,(de)
	ldh (<hFF8E),a

	ldbc ((LARGE_ROOM_HEIGHT/2)<<4) + 8, ((LARGE_ROOM_WIDTH/2)<<4) + 8
	call objectGetRelativeAngleWithTempVars
	ld c,a
	ld b,SPEED_100
	ld e,Enemy.angle
	jp objectApplyGivenSpeed


; Offsets for Z position, in subpixels.
fireKeese_subid0_zOffsets:
	.db $80 $60 $40 $30 $20 $20

; Speed values for subid 1, where it gradually slows down.
fireKeese_subid1_speeds:
	.db SPEED_c0 SPEED_80 SPEED_40 SPEED_40
	.db SPEED_20 SPEED_20 SPEED_20 SPEED_20

fireKeese_subid1_animFrequencies:
	.db $00 $00 $01 $01 $03 $03 $07 $00
