;;
updatePirateShip:
	ld a,GLOBALFLAG_PIRATES_GONE
	call checkGlobalFlag
	ret nz

	call checkLoadPirateShip
	call updatePirateShipChangedTile
	call updatePirateShipAngle
	call updatePirateShipPosition
	jp updatePirateShipRoom

;;
checkLoadPirateShip:
	ld a,GLOBALFLAG_PIRATES_GONE
	call checkGlobalFlag
	ret nz

	ld a,(wTilesetFlags)
	ld b,a
	bit TILESETFLAG_BIT_OUTDOORS,b
	ret z

	bit TILESETFLAG_BIT_UNDERWATER,b
	ret nz

	call checkIsLinkedGame
	jr nz,+

	bit TILESETFLAG_BIT_PAST,b
	ret z
	jr ++
+
	bit TILESETFLAG_BIT_PAST,b
	ret nz
++
	ld a,(wPirateShipRoom)
	ld b,a
	ld a,(wActiveRoom)
	cp b
	ret nz

	ld hl,w1ReservedInteraction1.enabled
	ld a,(hl)
	or a
	ret nz

	ld (hl),$01
	inc l
	ld (hl),INTERAC_PIRATE_SHIP
	ld l,Interaction.yh
	ld a,(wPirateShipY)
	ldi (hl),a
	inc l
	ld a,(wPirateShipX)
	ld (hl),a
	ret

;;
; Update wPirateShipChangedTile when the ship is centered on a tile.
updatePirateShipChangedTile:
	ld a,(wPirateShipY)
	and $0f
	cp $08
	ret nz

	ld a,(wPirateShipX)
	and $0f
	cp $08
	ret nz

	ld a,(wPirateShipY)
	and $f0
	ld b,a
	ld a,(wPirateShipX)
	swap a
	and $0f
	or b
	ld (wPirateShipChangedTile),a
	ret

;;
updatePirateShipPosition:
	call retIfTextIsActive
	ld a,(wLinkPlayingInstrument)
	or a
	ret nz

	; Every other frame...
	ld a,(wFrameCounter)
	rrca
	ret c

	; Update the ship's position
	ld a,(wPirateShipAngle)
	and $03
	ld de,@speedComponents
	call addDoubleIndexToDe
	ld hl,wPirateShipY
	ld a,(de)
	add (hl)
	ldi (hl),a
	inc de
	ld a,(de)
	add (hl)
	ld (hl),a
	ret

@speedComponents:
	.db $ff $00 ; up
	.db $00 $01 ; right
	.db $01 $00 ; down
	.db $00 $ff ; left

;;
updatePirateShipRoom:
	ld a,(wPirateShipAngle)
	and $03
	rst_jumpTable
	.dw @movingUp
	.dw @movingRight
	.dw @movingDown
	.dw @movingLeft

;;
@movingUp:
	ld hl,wPirateShipY
	ldbc $80, $f0
	ld a,$f8

; @param a Position at which to cross rooms
; @param b Position to appear at in next room
; @param c Value to add to wPirateShipRoom
; @param hl Which component of pirate ship position to check
@updateRoom:
	cp (hl)
	ret nz

	ld (hl),b
	ld a,(wPirateShipRoom)
	add c
	ld (wPirateShipRoom),a
	ret

;;
@movingRight:
	ld hl,wPirateShipX
	ldbc $00, $01
	ld a,$98
	jr @updateRoom

;;
@movingDown:
	ld hl,wPirateShipY
	ld bc,$0010
	ld a,$88
	jr @updateRoom

;;
@movingLeft:
	ld hl,wPirateShipX
	ldbc $a0, $ff
	ld a,$f8
	jr @updateRoom

;;
updatePirateShipAngle:
	ld a,(wPirateShipChangedTile)
	or a
	ret z

	ldh (<hFF8B),a
	xor a
	ld (wPirateShipChangedTile),a
	ld hl,@shipDirectionsPast
	call checkIsLinkedGame
	jr z,@nextDirection

	ld hl,@shipDirectionsPresent

@nextDirection:
	ld a,(hl)
	or a
	ret z

	push hl
	ld a,(wPirateShipRoom)
	cp (hl)
	jr nz,++

	inc hl
	ldh a,(<hFF8B)
	cp (hl)
	jr nz,++

	inc hl
	ld a,(hl)
	ld (wPirateShipAngle),a
	pop hl
	ret
++
	pop hl
	ld a,$03
	rst_addAToHl
	jr @nextDirection

; Data format:
; b0: room index
; b1: YX position
; b2: new direction to move in when the ship reaches that position

@shipDirectionsPresent:
	.db $b6 $47 DIR_DOWN
	.db $d6 $27 DIR_RIGHT
	.db $d6 $28 DIR_UP
	.db $b6 $68 DIR_RIGHT
	.db $b8 $63 DIR_DOWN
	.db $d8 $23 DIR_RIGHT
	.db $d8 $25 DIR_UP
	.db $c8 $15 DIR_RIGHT
	.db $c8 $18 DIR_UP
	.db $a8 $68 DIR_LEFT
	.db $a8 $63 DIR_DOWN
	.db $b8 $43 DIR_LEFT
	.db $00

;  @addr{7f02}
@shipDirectionsPast:
	.db $b6 $34 DIR_DOWN
	.db $d6 $14 DIR_RIGHT
	.db $d7 $18 DIR_UP
	.db $c7 $58 DIR_LEFT
	.db $c7 $53 DIR_UP
	.db $b7 $33 DIR_LEFT
	.db $00
