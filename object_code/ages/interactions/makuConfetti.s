; ==================================================================================================
; INTERAC_MAKU_CONFETTI
;
; This object uses component speed (instead of using one byte for speed value, two words
; are used, for Y/X speeds respectively).
;
; Variables:
;   var03:    If nonzero, this is an index for the confetti which determines position,
;             acceleration values? (If zero, this is the "spawner" for subsequent
;             confetti.)
;
; Variables for "spawner" / "parent" (var03 == 0, uses state 1):
;   counter1: Number of pieces of confetti spawned so far
;   var37:    Counter until next piece of confetti spawns
;
; Variables for actual pieces of confetti (var03 != 0, uses state 2):
;   var3a:    Counter until another sparkle is created
;   var3c/3d: Y acceleration?
;   var3e/3f: X acceleration?
; ==================================================================================================
interactionCode62:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw makuConfetti_subid0
	.dw makuConfetti_subid1


; Subid 0: Flowers (in the present)
makuConfetti_subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,+

	; var03 is zero; next state is state 1.
	jp @setDelayUntilNextConfettiSpawns
+
	; a *= 3 (assume hl still points to a's source)
	add a
	add (hl)

	; Set Y-pos, X-pos, Y-accel (var3c), X-accel (var3e)
	ld hl,@initialPositionsAndAccelerations-6
	rst_addDoubleIndex
	ld e,Interaction.yh
	ldh a,(<hCameraY)
	add (hl)
	inc hl
	ld (de),a
	inc e
	inc e
	ldh a,(<hCameraX)
	add (hl)
	inc hl
	ld (de),a
	ld e,Interaction.var3c
	call @copyAccelerationComponent
	call @copyAccelerationComponent

	; Increment state again; next state is state 2.
	ld h,d
	ld l,Interaction.state
	inc (hl)

	ld l,Interaction.var3a
	ld (hl),$10

	ld l,Interaction.direction
	ld (hl),$00
	call interactionInitGraphics
	jp objectSetVisible80


@copyAccelerationComponent:
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ret


; Data format:
;   b0: Y position
;   b1: X position
;   w2: Y-acceleration (var3c)
;   w3: X-acceleration (var3e)
@initialPositionsAndAccelerations:
	dbbww $e8, $38, $0018, $0018 ; $01 == [var03]
	dbbww $e8, $60, $0018, $0018 ; $02
	dbbww $e8, $10, $0010, $0010 ; $03
	dbbww $e8, $50, $0014, $0014 ; $04
	dbbww $e8, $20, $0018, $0018 ; $05


; State 1: this is the "spawner" for confetti, not actually drawn itself.
@state1:
	ld h,d
	ld l,Interaction.var37
	dec (hl)
	ret nz
	ld (hl),$01

	; Spawn a piece of confetti
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MAKU_CONFETTI

	; [new.var03] = ++[this.counter1]
	ld e,Interaction.counter1
	ld a,(de)
	inc a
	ld (de),a
	ld l,Interaction.var03
	ld (hl),a

	; [new.counter2] = 180 (counter until it makes magic powder noise)
	ld l,Interaction.counter2
	ld (hl),180

	ld a,SND_MAGIC_POWDER
	call playSound

	; Delete self if 5 pieces of confetti have been spawned
	ld e,Interaction.counter1
	ld a,(de)
	cp $05
	jp z,interactionDelete

@setDelayUntilNextConfettiSpawns:
	ld e,Interaction.counter1
	ld a,(de)
	ld hl,@spawnDelayValues
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var37
	ld (de),a
	ret

@spawnDelayValues:
	.db $01 $32 $14 $1e $28 $1e


; State 2: This is an individual piece of confetti, falling down the screen.
@state2:
	; Play magic powder sound every 3 seconds
	call interactionDecCounter2
	jr nz,++
	ld (hl),180
	ld a,SND_MAGIC_POWDER
	call playSound
++
	; Make a sparkle every $18 frames
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	jr nz,++
	ld (hl),$18
	call @makeSparkle
++
	; Update Y/X position and speed
	ld hl,@yOffset
	ld e,Interaction.y
	call add16BitRefs
	call makuConfetti_updateSpeedY
	call makuConfetti_updateSpeedX
	call objectApplyComponentSpeed

	; Delete when off-screen
	ld e,Interaction.yh
	ld a,(de)
	cp $88
	jp c,++
	cp $d8
	jp c,interactionDelete
++
	; Invert Y acceleration when speedY > $100.
	ld h,d
	ld l,Interaction.speedY
	ld c,(hl)
	inc l
	ld b,(hl)
	bit 7,(hl)
	jr z,+
	call @negateBC
+
	ld hl,$0100
	call compareHlToBc
	cp $01
	jr z,+
	ld e,Interaction.var3c
	call @negateWordAtDE
+
	; Invert X acceleration when speedX > $200.
	ld h,d
	ld l,Interaction.speedX
	ld c,(hl)
	inc l
	ld b,(hl)
	bit 7,(hl)
	jr z,+
	call @negateBC
+
	ld hl,$0200
	call compareHlToBc
	cp $01
	jr z,+
	ld e,Interaction.var3e
	call @negateWordAtDE
+
	; Check whether to invert the animation direction (speed switches from positive to
	; negative or vice-versa).
	ld h,d
	ld l,Interaction.speedX+1
	bit 7,(hl)
	ld l,Interaction.direction
	ld a,(hl)
	jr z,+
	or a
	ret nz
	jr ++
+
	or a
	ret z
++
	xor $01
	ld (hl),a
	jp interactionSetAnimation


; Value added to y position each frame, in addition to speedY?
@yOffset:
	.dw $00c0

;;
; @param	bc	Speed
; @param[out]	bc	Inverted speed
@negateBC:
	xor a
	ld a,c
	cpl
	add $01
	ld c,a
	ld a,b
	cpl
	adc $00
	ld b,a
	ret

;;
; @param	de	Address of value to invert
@negateWordAtDE:
	xor a
	ld a,(de)
	cpl
	add $01
	ld (de),a
	inc e
	ld a,(de)
	cpl
	adc $00
	ld (de),a
	ret

@makeSparkle:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_SPARKLE
	inc l
	ld (hl),$02
	jp objectCopyPosition



; Subid 1: In the past.
makuConfetti_subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Interaction.var03
	ld a,(hl)
	or a
	jr nz,+

	; var03 is zero; next state is state 1.
	ld l,Interaction.counter2
	ld (hl),$0a
	jp @setDelayUntilNextConfettiSpawns
+
	dec a
	cp $06
	jr c,+
	sub $06
+
	ld hl,@initialPositions
	rst_addDoubleIndex

	; Set Y-pos, X-pos.
	ld e,Interaction.yh
	ldh a,(<hCameraY)
	add (hl)
	inc hl
	ld (de),a
	inc e
	inc e
	ldh a,(<hCameraX)
	add (hl)
	inc hl
	ld (de),a

	; Initialize speedY, speedX
	ld h,d
	ld l,Interaction.speedY
	ld b,$80
	ld c,$fd
	call @setSpeedComponent
	ld b,$00
	ld c,$04
	call @setSpeedComponent

	; Initialize speedZ; this is actually used as X acceleration.
	ld b,$f0
	ld c,$ff
	call @setSpeedComponent

	; Increment state again; next state is state 2.
	ld l,Interaction.state
	inc (hl)

	call interactionInitGraphics
	jp objectSetVisible80

@setSpeedComponent:
	ld (hl),b
	inc l
	ld (hl),c
	inc l
	ret

; Data format:
;   b0: Y position
;   b1: X position
@initialPositions:
	.db $80 $10 ; $01,$07 == [var03]
	.db $60 $00 ; $02,$08
	.db $80 $18 ; $03,$09
	.db $80 $48 ; $04,$0a
	.db $50 $00 ; $05,$0b
	.db $80 $10 ; $06,$0c


; State 1: this is the "spawner" for confetti, not actually drawn itself.
@state1:
	call interactionDecCounter2
	jr nz,+
	ld (hl),45
	ld a,SND_MAKU_TREE_PAST
	call playSound
+
	ld h,d
	ld l,Interaction.var37
	dec (hl)
	ret nz

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MAKU_CONFETTI
	inc l
	ld (hl),$01 ; [new.subid] = $02

	; [new.var03] = ++[this.counter1]
	ld e,Interaction.counter1
	ld a,(de)
	inc a
	ld (de),a
	ld l,Interaction.var03
	ld (hl),a

	; Delete self if 12 pieces of confetti have been spawned
	cp 12
	jp z,interactionDelete

@setDelayUntilNextConfettiSpawns:
	ld e,Interaction.counter1
	ld a,(de)
	ld hl,@spawnDelayValues
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var37
	ld (de),a
	ret

@spawnDelayValues:
	.db $01 $32 $1e $0f $0f $0f $0f $0f
	.db $0f $0f $0f $14


; State 2: This is an individual piece of confetti, falling down the screen.
@state2:
	call makuConfetti_updateSpeedXUsingSpeedZ
	ld e,Interaction.speedX+1
	ld a,(de)
	bit 7,a
	jp nz,interactionDelete
	jp objectApplyComponentSpeed

makuConfetti_updateSpeedY:
	ld e,Interaction.speedY
	ld l,Interaction.var3c
	jr makuConfetti_add16BitRefs

makuConfetti_updateSpeedX:
	ld e,Interaction.speedX
	ld l,Interaction.var3e
	jr makuConfetti_add16BitRefs

makuConfetti_updateSpeedYUsingSpeedZ: ; Unused
	ld e,Interaction.speedY
	ld l,Interaction.speedZ
	jr makuConfetti_add16BitRefs

; Use speedZ as acceleration for speedX (since speedZ isn't used for anything else)
makuConfetti_updateSpeedXUsingSpeedZ:
	ld e,Interaction.speedX
	ld l,Interaction.speedZ

makuConfetti_add16BitRefs
	ld h,d
	call add16BitRefs
	ret
