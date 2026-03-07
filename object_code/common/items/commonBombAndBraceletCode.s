;;
; Called every frame a bomb is being thrown. Also used by somaria block?
;
bombUpdateThrowingLaterally:
	; If it's landed in water, set speed to 0 (for sidescrolling areas)
	ld h,d
	ld l,Item.var3b
	bit 0,(hl)
	jr z,+
	ld l,Item.speed
	ld (hl),$00
+
	; If this is the start of the throw, initialize speed variables
	ld l,Item.var37
	bit 0,(hl)
	call z,itemBeginThrow

	; Check for collisions with walls, update position.
	jp itemUpdateThrowingLaterally

;;
; Items call this once on the frame they're thrown
;
itemBeginThrow:
	call itemSetVar3cToFF

	; Move the item one pixel in Link's facing direction
	ld a,(w1Link.direction)
	ld hl,@throwOffsets
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)

	ld h,d
	ld l,Item.yh
	add (hl)
	ldi (hl),a
	inc l
	ld a,(hl)
	add c
	ld (hl),a

	ld l,Item.enabled
	res 1,(hl)

	; Mark as thrown?
	ld l,Item.var37
	set 0,(hl)

	; Item.var38 contains "weight" information (how the object will be thrown)
	inc l
	ld a,(hl)
	and $f0
	swap a
	add a
	ld hl,itemWeights
	rst_addDoubleIndex

	; Byte 0 from hl: value for Item.var39 (gravity)
	ldi a,(hl)
	ld e,Item.var39
	ld (de),a

	; If angle is $ff (motionless), skip the rest.
	ld e,Item.angle
	ld a,(de)
	rlca
	jr c,@clearItemSpeed

	; Byte 1: Value for Item.speedZ (8-bit, high byte is $ff)
	ld e,Item.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,$ff
	ld (de),a

	; Bytes 2,3: Throw speed with and without toss ring, respectively
	ld a,TOSS_RING
	call cpActiveRing
	jr nz,+
	inc hl
+
	ld e,Item.speed
	ldi a,(hl)
	ld (de),a
	ret

@clearItemSpeed:
	ld h,d
	ld l,Item.speed
	xor a
	ld (hl),a
	ld l,Item.speedZ
	ldi (hl),a
	ldi (hl),a
	ret

; Offsets to move the item when it's thrown.
; Each direction value reads 2 of these, one for Y and one for X.
@throwOffsets:
	.db $ff
	.db $00
	.db $01
	.db $00
	.db $ff

;;
; Checks whether a throwable item has collided with a wall; if not, this updates its
; position.
;
; Called by throwable items each frame. See also "itemUpdateThrowingVertically".
;
; @param[out]	zflag	Set if the item should break.
itemUpdateThrowingLaterally:
	ld e,Item.var38
	ld a,(de)

	; Check whether the "weight" value for the item equals 3?
	cp $40
	jr nc,+
.ifdef ROM_AGES
	cp $30
.else
	cp $20
.endif
	jr nc,@weight3
+
	; Return if not moving
	ld e,Item.angle
	ld a,(de)
	cp $ff
	jr z,@unsetZFlag

	and $18
	rrca
	rrca
	ld hl,bombEdgeOffsets
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)

	; Load y position into b, jump if beyond room boundary.
	ld h,d
	ld l,Item.yh
	add (hl)
	cp (LARGE_ROOM_HEIGHT*$10)
	jr nc,@noCollision

	ld b,a
	ld l,Item.xh
	ld a,c
	add (hl)
	ld c,a

	call checkTileCollisionAt_allowHoles
	jr nc,@noCollision
	call itemCheckCanPassSolidTileAt
	jr z,@noCollision
	jr @collision

; This is probably a specific item with different dimensions than other throwable stuff
@weight3:
	ld h,d
	ld l,Item.yh
	ld b,(hl)
	ld l,Item.xh
	ld c,(hl)

	ld e,Item.angle
	ld a,(de)
	and $18
	ld hl,data_649a
	rst_addAToHl

	; Loop 4 times, once for each corner of the object?
	ld e,$04
--
	push bc
	ldi a,(hl)
	add b
	ld b,a
	ldi a,(hl)
	add c
	ld c,a
	push hl
	call checkTileCollisionAt_allowHoles
	pop hl
	pop bc
	jr c,@collision
	dec e
	jr nz,--
	jr @noCollision

@collision:
	; Check if this is a breakable object (based on a tile that was picked up)?
	call braceletCheckBreakable
	jr nz,@setZFlag

	; Clear angle, which will also set speed to 0
	ld e,Item.angle
	ld a,$ff
	ld (de),a

@noCollision:
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr z,+

	; If in a sidescrolling area, don't apply speed if moving directly vertically?
	ld e,Item.angle
	ld a,(de)
	and $0f
	jr z,@unsetZFlag
+
	call objectApplySpeed

@unsetZFlag:
	or d
	ret

@setZFlag:
	xor a
	ret

;;
; Called each time a particular item (ie a bomb) lands on a ground. This will cause it to
; bounce a few times before settling, reducing in speed with each bounce.
; @param[out] zflag Set if the item has reached a ground speed of zero.
; @param[out] cflag Set if the item has stopped bouncing.
itemBounce:
	ld a,SND_BOMB_LAND
	call playSound

	; Invert and reduce vertical speed
	call objectNegateAndHalveSpeedZ
	ret c

	; Reduce regular speed
	ld e,Item.speed
	ld a,(de)
	ld e,a
	ld hl,bounceSpeedReductionMapping
	call lookupKey
	ld e,Item.speed
	ld (de),a
	or a
	ret

; This seems to list the offsets of the 4 corners of a particular object, to be used for
; collision calculations.
; Somewhat similar to "bombEdgeOffsets", except that is only used to check for collisions
; in the direction it's moving in, whereas this seems to cover the entire object.
data_649a:
	.db $00 $00 $fa $fa $fa $00 $fa $05 ; DIR_UP
	.db $00 $00 $fa $05 $00 $05 $05 $05 ; DIR_RIGHT
	.db $00 $00 $05 $fb $05 $00 $05 $05 ; DIR_DOWN
	.db $00 $00 $fa $fa $00 $fa $06 $fa ; DIR_LEFT

; b0: Value to write to Item.var39 (gravity).
; b1: Low byte of Z speed to give the object (high byte will be $ff)
; b2: Throw speed without toss ring
; b3: Throw speed with toss ring
itemWeights:
	.db $1c $10 SPEED_180 SPEED_280
	.db $20 $00 SPEED_080 SPEED_100
.ifdef ROM_AGES
	.db $28 $20 SPEED_1a0 SPEED_280
	.db $20 $00 SPEED_080 SPEED_100
.else
	.db $20 $00 SPEED_100 SPEED_180
	.db $20 $00 SPEED_0c0 SPEED_100
.endif
	.db $20 $e0 SPEED_140 SPEED_180
	.db $20 $00 SPEED_080 SPEED_100

; A series of key-value pairs where the key is a bouncing object's current speed, and the
; value is the object's new speed after one bounce.
; This returns roughly half the value of the key.
bounceSpeedReductionMapping:
	.db SPEED_020 SPEED_000
	.db SPEED_040 SPEED_020
	.db SPEED_060 SPEED_020
	.db SPEED_080 SPEED_040
	.db SPEED_0a0 SPEED_040
	.db SPEED_0c0 SPEED_060
	.db SPEED_0e0 SPEED_060
	.db SPEED_100 SPEED_080
	.db SPEED_120 SPEED_080
	.db SPEED_140 SPEED_0a0
	.db SPEED_160 SPEED_0a0
	.db SPEED_180 SPEED_0c0
	.db SPEED_1a0 SPEED_0c0
	.db SPEED_1c0 SPEED_0e0
	.db SPEED_1e0 SPEED_0e0
	.db SPEED_200 SPEED_100
	.db SPEED_220 SPEED_100
	.db SPEED_240 SPEED_120
	.db SPEED_260 SPEED_120
	.db SPEED_280 SPEED_140
	.db SPEED_2a0 SPEED_140
	.db SPEED_2c0 SPEED_160
	.db SPEED_2e0 SPEED_160
	.db SPEED_300 SPEED_180
	.db $00 $00
