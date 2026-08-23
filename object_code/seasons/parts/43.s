; ==================================================================================================
; PART_GLEEOK_FLAME
; ==================================================================================================
partCode43:
	ld e,Part.subid
	ld a,(de)
	ld e,Part.state
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

; Single flame that moves south and then explodes into 6 smaller flames
@subid0:
	ld a,(de) ; [state]
	or a
	jr z,@initializeSouthMovingFlame
	call partAnimate
	call partCommon_decCounter1IfNonzero
	jp nz,objectApplyComponentSpeed
	; Spawn 6 small flames and delete self
	ld b,$06
-
	ld a,b
	dec a
	ld hl,@smallFlameAngles
	rst_addAToHl
	ld c,(hl)
	call @spawnSmallFlame
	dec b
	jr nz,-
	call objectCreatePuff
	jp partDelete

; Spawns a flame with subid 3 and the given angle
;
; @param	c	Angle
@spawnSmallFlame:
	call getFreePartSlot
	ret nz
	ld (hl),PART_GLEEOK_FLAME ; [id]
	inc l
	ld (hl),$03 ; [subid]
	ld l,Part.angle
	ld (hl),c
	jp objectCopyPosition

@smallFlameAngles:
	.db $03 $08 $0d
	.db $13 $18 $1d

@initializeSouthMovingFlame:
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld l,Part.oamTileIndexBase
	ld (hl),$06
	dec l
	ld a,$0a
	ldd (hl),a ; [oamFlags]
	ld (hl),a ; [oamFlagsBackup]
	ld l,Part.yh
	ld a,(hl)
	add $06
	ld (hl),a
	ld l,Part.collisionRadiusY
	ld a,$05
	ldi (hl),a
	ld (hl),a ; [collisionRadiusX]
	ld l,Part.counter1
	ld (hl),12
	ld l,Part.angle
	ld (hl),$10
	ld b,SPEED_200
	jr @subid1@setSpeedYXVisibleAndPlaySound

; Single stationary flame
@subid1:
	ld a,(de) ; [state]
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2

@@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld l,Part.counter1
	ld (hl),4
	ld l,Part.collisionType
	res 7,(hl)
	ld l,Part.oamTileIndexBase
	ld (hl),$06
	dec l
	ld a,$0a
	ldd (hl),a ; [oamFlags]
	ld (hl),a ; [oamFlagsBackup]
	ret

@@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),180 ; [counter1]
	ld l,e
	inc (hl) ; [state]
	ld l,Part.collisionType
	set 7,(hl)
	ld b,SPEED_180

@@setSpeedYXVisibleAndPlaySound:
	call gleeokFlame_setSpeedYX
	call objectSetVisible81
	ld a,SND_LIGHTTORCH
	jp playSound

@@state2:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	jp partAnimate

; The middle out of a burst of 3 flames moving generally south
@subid2:
	ld a,(de) ; [state]
	or a
	jr z,@initializeTripleFlame

@keepMovingUntilOutOfBounds:
	call partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplyComponentSpeed
	jp partAnimate

@initializeTripleFlame:
	ld b,$02
	call checkBPartSlotsAvailable
	ret nz
	ld h,d
	ld l,Part.state
	inc (hl)
	ld l,Part.oamTileIndexBase
	ld (hl),$06
	dec l
	ld a,$0a
	ldd (hl),a ; [oamFlags]
	ld (hl),a ; [oamFlagsBackup]
	ld l,Part.angle
	ld (hl),$10
	ld l,Part.yh
	ld a,(hl)
	add $06
	ld (hl),a
	ld b,SPEED_180
	call @subid1@setSpeedYXVisibleAndPlaySound
	ld bc,$0213
	call @spawnCompanionFlame
	ld bc,$030d

; Spawns a flame with a given angle that moves alongside the current flame
;
; @param	b	Value for var03 which will later get passed to partSetAnimation
; @param	c	Angle
@spawnCompanionFlame:
	call getFreePartSlot
	ld (hl),PART_GLEEOK_FLAME ; [id]
	inc l
	ld (hl),$04 ; [subid]
	inc l
	ld (hl),b ; [var03]
	ld l,Part.angle
	ld (hl),c
	jp objectCopyPosition

; Small flame that moves in a straight line for a bit and then disappears
@subid3:
	ld a,(de) ; [state]
	or a
	jr z,+
	call objectApplyComponentSpeed
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jp nz,partAnimate
	jp partDelete
+
	ld bc,$ff20
	call objectSetSpeedZ
	ld l,e
	inc (hl) ; [state]
	ld l,Part.collisionRadiusY
	ld (hl),$05
	inc l
	ld (hl),$02 ; [collisionRadiusX]
	ld b,SPEED_180
	call gleeokFlame_setSpeedYX
	call objectSetVisible82
	ld a,$01
	jp partSetAnimation

; The left or right out of a burst of 3 flames moving generally south
@subid4:
	ld a,(de) ; [state]
	or a
	jp nz,@keepMovingUntilOutOfBounds
	; Initialize
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld b,SPEED_180
	call gleeokFlame_setSpeedYX
	call objectSetVisible82
	ld e,Part.var03
	ld a,(de)
	jp partSetAnimation

; Combines the given speed value with the part's angle and sets speedY and speedX accordingly
;
; @param	b	Speed
gleeokFlame_setSpeedYX:
	ld e,Part.angle
	ld a,(de)
	ld c,a
	call getPositionOffsetForVelocity
	ld e,Part.speedY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a ; [speedY+1]
	inc e
	ldi a,(hl)
	ld (de),a ; [speedX]
	inc e
	ldi a,(hl)
	ld (de),a ; [speedX+1]
	ret
