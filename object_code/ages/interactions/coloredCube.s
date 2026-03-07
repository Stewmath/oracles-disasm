; ==================================================================================================
; INTERAC_COLORED_CUBE
; ==================================================================================================
interactionCode19:
	call objectReplaceWithAnimationIfOnHazard
	ret c
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


; State 0: initialization
@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Interaction.counter1
	ld (hl),$14 ; counter1: frames it takes to push it
	inc l
	ld (hl),$0a ; counter2: frames it takes to fall into a hole

	ld a,$06
	call objectSetCollideRadius
	call interactionInitGraphics

	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.direction
	ld (de),a

	call @setColor

	; Load palettes 6 and 7. Since it uses palette 6, you shouldn't be able to move
	; any blocks or hold anything while one of these blocks is on screen, since this
	; would interfere with the "objectMimicBgTile" function.
	ld a,PALH_89
	call loadPaletteHeader

	call @updatePosition
	jp objectSetVisible82


; State 1: waiting to be pushed
@state1:
	call interactionDecCounter2
	jr nz,+
	call objectGetTileAtPosition
	cp TILEINDEX_CRACKED_FLOOR
	jp z,@fallDownHole
+
	call @checkLinkPushingTowardBlock
	jr nz,@resetCounter1
	call interactionDecCounter1
	ret nz

; Block has been pushed for 20 frames.

	ld a,b
	swap a
	rrca
	ld e,Interaction.angle
	ld (de),a
	call interactionCheckAdjacentTileIsSolid
	jr nz,@resetCounter1

	; Set collisions to 0
	call objectGetShortPosition
	ld h,>wRoomCollisions
	ld l,a
	ld (hl),$00

	call interactionIncState
	ld l,Interaction.direction
	ldi a,(hl)
	add a
	add a
	ld b,a
	ld a,(hl)
	swap a
	rlca
	add b
	ld hl,@animations
	rst_addAToHl
	ld a,(hl)
	call interactionSetAnimation
	jr @checkAnimParameter

@resetCounter1:
	ld e,Interaction.counter1
	ld a,$14
	ld (de),a
	ret


; State 2: being pushed
@state2:
	call interactionAnimate

@checkAnimParameter:
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z
	ld b,a
	rlca
	jr c,@finishMovement

	xor a
	ld (de),a
	ld a,b
	sub $02
	ld hl,@directionOffsets
	rst_addAToHl
	ld e,Interaction.yh
	ld a,(de)
	add (hl)
	ld (de),a
	inc hl
	ld e,Interaction.xh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@finishMovement:
	ld h,d
	ld l,Interaction.state
	dec (hl)
	ld l,Interaction.counter1
	ld (hl),$14
	inc l
	ld (hl),$0a
	ld a,b
	and $7f
	ld e,Interaction.direction
	ld (de),a
	call @setColor
	call objectCenterOnTile

	ld a,SND_MOVE_BLOCK_2
	call playSound

;;
; Updates wRotatingCubePos and wRoomCollisions based on the object's current position.
@updatePosition:
	call objectGetShortPosition
	ld h,>wRoomCollisions
	ld l,a
	ld (hl),$0f
	ld (wRotatingCubePos),a

	; Push Link away? (only called once since solidity is handled by modifying
	; wRoomCollisions)
	jp objectPreventLinkFromPassing


@directionOffsets:
	.db $fc $00
	.db $00 $04
	.db $04 $00
	.db $00 $fc

;;
; @param[out]	b	Direction it's being pushed in
; @param[out]	zflag	Set if Link is pushing toward the block
@checkLinkPushingTowardBlock:
	ld a,(wLinkGrabState)
	or a
	ret nz
	ld a,(wLinkAngle)
	rlca
	ret c
	ld a,(w1Link.zh)
	rlca
	ret c

	ld a,(wGameKeysPressed)
	and (BTN_A | BTN_B)
	ret nz
	ld c,$14
	call objectCheckLinkWithinDistance
	jr nc,++
	srl a
	xor $02
	ld b,a
	ld a,(w1Link.direction)
	cp b
	ret
++
	or d
	ret

; These are the animations values to use when the tile is being pushed.
; Each row corresponds to an orientation of the cube (value of Interaction.direction).
; Each column corresponds to the direction it's being pushed in (Interaction.angle).
@animations:
	.db $12 $07 $13 $06 ; 0: yellow/red
	.db $14 $11 $15 $10 ; 1: red/yellow
	.db $16 $0b $17 $0a ; 2: red/blue
	.db $18 $09 $19 $08 ; 3: blue/red
	.db $1a $0f $1b $0e ; 4: blue/yellow
	.db $1c $0d $1d $0c ; 5: yellow/blue


;;
; Sets wRotatingCubeColor as well as the animation to use.
;
; @param	a	Orientation of cube (value of Interaction.direction)
@setColor:
	ld b,a
	ld hl,@colors
	rst_addAToHl
	ld a,(hl)
	ld (wRotatingCubeColor),a
	ld a,b
	jp interactionSetAnimation

@colors:
	.db $01 $00 $00 $02 $02 $01


@fallDownHole:
	ld c,l
	ld a,TILEINDEX_HOLE
	call setTile
	call objectCreateFallingDownHoleInteraction
	jp interactionDelete
