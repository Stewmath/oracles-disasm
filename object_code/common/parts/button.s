; ==================================================================================================
; PART_BUTTON
;
; Variables:
;   var03: Bit index (copied from subid ignoring bit 7)
;   counter1: ?
;   var30: 1 if button is pressed
; ==================================================================================================
partCode09:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@state0

@state1:
	ld a,(wccb1)
	or a
	ret nz

	ld hl,w1Link
	call checkObjectsCollided
	jr c,@linkTouchedButton

.ifdef ROM_SEASONS
	ld hl,$dd00
	call checkObjectsCollided
	jr c,@dd00TouchedButton
.endif

	call objectGetTileAtPosition
	sub TILEINDEX_BUTTON
	cp $02 ; TILEINDEX_BUTTON or TILEINDEX_PRESSED_BUTTON
	jr nc,@somethingOnButton

	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,Part.var30
	bit 0,(hl)
	ret z
	ld e,Part.var30
	ld a,(de)
	or a
	ret z

	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_BUTTON
	call setTile

	ld e,Part.var03
	ld a,(de)
	ld hl,wActiveTriggers
	call unsetFlag
	ld e,$f0
	xor a
	ld (de),a

	ld a,SND_SPLASH
	jp playSound

; Tile is being held down by something (somaria block, pot, etc)
@somethingOnButton:
	ld h,d
	ld l,Part.subid
	bit 7,(hl)
	jr z,@delete

	ld l,Part.var30
	bit 0,(hl)
	ret nz

	ld l,Part.counter1
	ld (hl),$1c
	call objectGetShortPosition
	ld c,a
	ld b,TILEINDEX_PRESSED_BUTTON
	call setTileInRoomLayoutBuffer
	jr @setTriggerAndPlaySound

@delete:
	call @updateTileBeforeDeletion
	jp partDelete

@linkTouchedButton:
	ld a,(w1Link.zh)
	or a
	ret nz
@dd00TouchedButton:
	ld e,Part.subid
	ld a,(de)
	rlca
	jr nc,@delete

@checkButtonPushed:
	ld e,Part.var30
	ld a,(de)
	or a
	ret nz

	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_PRESSED_BUTTON
	call setTile

@setTriggerAndPlaySound:
	ld e,Part.var03
	ld a,(de)
	ld hl,wActiveTriggers
	call setFlag
	ld e,Part.var30
	ld a,$01
	ld (de),a
	ld a,SND_SPLASH
	jp playSound

@updateTileBeforeDeletion:
	call objectGetShortPosition
	ld c,a
	ld b,TILEINDEX_PRESSED_BUTTON
	call setTileInRoomLayoutBuffer
	call objectGetTileAtPosition
	cp TILEINDEX_BUTTON
	jr z,@checkButtonPushed
	jr @setTriggerAndPlaySound

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1
	ld l,Part.subid
	ldi a,(hl)
	and $07
	ldd (hl),a ; [var03]
	ret
