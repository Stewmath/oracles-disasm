; ==================================================================================================
; PART_FALLING_BOULDER_SPAWNER
;
; Variables:
;   var30: yh to spawn boulder at
;   var31: xh to spawn boulder at
; ==================================================================================================
partCode45:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Part.speed
	ld (hl),$32

	ld l,Part.yh
	ld a,(hl)
	sub $08
	jr z,+
	add $04
+
	ldi (hl),a
	ld e,Part.var30
	ld (de),a
	inc e
	inc l
	ld a,(hl)
	ld (de),a

	ld e,Part.subid
	ld a,(de)
	ld hl,@initialTimeToAppear
	rst_addAToHl
	ld e,Part.counter1
	ld a,(hl)
	ld (de),a
	ret

@initialTimeToAppear:
	.db $2d $5a $87 $b4

@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	
	ld l,e
	inc (hl)
	ld l,Part.collisionType
	set 7,(hl)
@bounceRandomlyDownwards:
	ld l,Part.speedZ
	ld a,<(-$1a0)
	ldi (hl),a
	ld (hl),>(-$1a0)
-
	call getRandomNumber_noPreserveVars
	and $07
	cp $07
	jr nc,-
	sub $03
	add $10
	ld e,Part.angle
	ld (de),a
	call objectSetVisiblec1
	ld a,SND_RUMBLE
	jp playSound

; Boulder falls until it hits the wall, then bounces again
; Once it's below the screen, it reappears in its original position
@state2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call z,@bounceRandomlyDownwards
	call objectApplySpeed
	
	ld e,Part.yh
	ld a,(de)
	cp $88
	jp c,partAnimate
	
	ld h,d
	ld l,Part.state
	dec (hl)
	
	ld l,Part.collisionType
	res 7,(hl)
	
	ld l,Part.counter1
	ld (hl),$b4
	ld e,Part.var30
	ld l,Part.yh
	ld a,(de)
	ldi (hl),a
	inc e
	inc l
	ld a,(de)
	ld (hl),a
	jp objectSetInvisible
