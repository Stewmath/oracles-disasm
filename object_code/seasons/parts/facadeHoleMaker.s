; ==================================================================================================
; PART_FACADE_HOLE_MAKER
;
; Facade spawns this to make temporary holes under link.
;
; animParameter has the following values, which are critical to the function of this part:
;   $00 (24 frames)  : animation only.
;   $01 (90 frames)  : change the tile to hole, storing current tile in var30.
;   $02 (10 frames)  : revert the tile to original.
;   $00 (20 frames)  : animation only.
;   $ff (128 frames) : despawn.
;
; Variables:
;   var30: Used to store the kind of tile that has been replaced by a hole, so that it can be reset later.
; ==================================================================================================
partCode2e:
	ld e,Part.state
	ld a,(de)
	or a
	jr z,@initialize

	ld e,Part.animParameter
	ld a,(de)
	or a
	jr z,@onlyAnimate

	; Despawn if animation is complete and animParameter is $ff.
	bit 7,a
	jp nz,partDelete

	call @modifyTile

@onlyAnimate:
	jp partAnimate

; In state 0, do some initialization.
@initialize:
	; Set state to 1.
	ld a,$01
	ld (de),a

	call objectGetTileAtPosition

	; If this tile was already made a hole, don't do it again.
	cp TILEINDEX_HOLE
	jp z,partDelete

	; Check if wRoomCollisions at this location is 0?
	ld h,>wRoomCollisions
	ld a,(hl)
	or a
	jp nz,partDelete

	ld a,SND_POOF
	call playSound

	jp objectSetVisible83

; Either make a hole or reset the tile at this position, depending on the value
; of animParameter.
@modifyTile:
	; Set animParameter to 0 so we only run this once.
	push af
	xor a
	ld (de),a
	call objectGetTileAtPosition
	pop af

	ld e,Part.var30

	; If [animParameter] == 1, make a hole, otherwise (if it's 2), reset.
	dec a
	jr z,@@makeHole

	; Reset the tile to what it was before.
	ld a,(de)
	ld (hl),a
	ret

; Store the current kind of tile in var30, then make the tile a hole.
@@makeHole:
	ld a,(hl)
	ld (de),a
	ld (hl),TILEINDEX_HOLE
	ret
