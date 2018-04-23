;;
; @addr{7dcc}
updatePirateShip:
	ld a,GLOBALFLAG_PIRATES_GONE		; $7dcc
	call checkGlobalFlag		; $7dce
	ret nz			; $7dd1

	call checkLoadPirateShip		; $7dd2
	call updatePirateShipChangedTile		; $7dd5
	call updatePirateShipAngle		; $7dd8
	call updatePirateShipPosition		; $7ddb
	jp updatePirateShipRoom		; $7dde

;;
; @addr{7de1}
checkLoadPirateShip:
	ld a,GLOBALFLAG_PIRATES_GONE		; $7de1
	call checkGlobalFlag		; $7de3
	ret nz			; $7de6

	ld a,(wAreaFlags)		; $7de7
	ld b,a			; $7dea
	bit AREAFLAG_BIT_OUTDOORS,b			; $7deb
	ret z			; $7ded

	bit AREAFLAG_BIT_UNDERWATER,b			; $7dee
	ret nz			; $7df0

	call checkIsLinkedGame		; $7df1
	jr nz,+			; $7df4

	bit AREAFLAG_BIT_PAST,b			; $7df6
	ret z			; $7df8
	jr ++			; $7df9
+
	bit AREAFLAG_BIT_PAST,b			; $7dfb
	ret nz			; $7dfd
++
	ld a,(wPirateShipRoom)		; $7dfe
	ld b,a			; $7e01
	ld a,(wActiveRoom)		; $7e02
	cp b			; $7e05
	ret nz			; $7e06

	ld hl,w1ReservedInteraction1.enabled		; $7e07
	ld a,(hl)		; $7e0a
	or a			; $7e0b
	ret nz			; $7e0c

	ld (hl),$01		; $7e0d
	inc l			; $7e0f
	ld (hl),INTERACID_PIRATE_SHIP		; $7e10
	ld l,Interaction.yh		; $7e12
	ld a,(wPirateShipY)		; $7e14
	ldi (hl),a		; $7e17
	inc l			; $7e18
	ld a,(wPirateShipX)		; $7e19
	ld (hl),a		; $7e1c
	ret			; $7e1d

;;
; Update wPirateShipChangedTile when the ship is centered on a tile.
; @addr{7e1e}
updatePirateShipChangedTile:
	ld a,(wPirateShipY)		; $7e1e
	and $0f			; $7e21
	cp $08			; $7e23
	ret nz			; $7e25

	ld a,(wPirateShipX)		; $7e26
	and $0f			; $7e29
	cp $08			; $7e2b
	ret nz			; $7e2d

	ld a,(wPirateShipY)		; $7e2e
	and $f0			; $7e31
	ld b,a			; $7e33
	ld a,(wPirateShipX)		; $7e34
	swap a			; $7e37
	and $0f			; $7e39
	or b			; $7e3b
	ld (wPirateShipChangedTile),a		; $7e3c
	ret			; $7e3f

;;
; @addr{7e40}
updatePirateShipPosition:
	call retIfTextIsActive		; $7e40
	ld a,(wLinkPlayingInstrument)		; $7e43
	or a			; $7e46
	ret nz			; $7e47

	; Every other frame...
	ld a,(wFrameCounter)		; $7e48
	rrca			; $7e4b
	ret c			; $7e4c

	; Update the ship's position
	ld a,(wPirateShipAngle)		; $7e4d
	and $03			; $7e50
	ld de,@speedComponents		; $7e52
	call addDoubleIndexToDe		; $7e55
	ld hl,wPirateShipY		; $7e58
	ld a,(de)		; $7e5b
	add (hl)		; $7e5c
	ldi (hl),a		; $7e5d
	inc de			; $7e5e
	ld a,(de)		; $7e5f
	add (hl)		; $7e60
	ld (hl),a		; $7e61
	ret			; $7e62

; @addr{7e63}
@speedComponents:
	.db $ff $00 ; up
	.db $00 $01 ; right
	.db $01 $00 ; down
	.db $00 $ff ; left

;;
; @addr{7e6b}
updatePirateShipRoom:
	ld a,(wPirateShipAngle)			; $7e6b
	and $03				; $7e6e
	rst_jumpTable			; $7e70
	.dw @movingUp
	.dw @movingRight
	.dw @movingDown
	.dw @movingLeft

;;
; @addr{7e79}
@movingUp:
	ld hl,wPirateShipY		; $7e79
	ldbc $80, $f0		; $7e7c
	ld a,$f8		; $7e7f

; @param a Position at which to cross rooms
; @param b Position to appear at in next room
; @param c Value to add to wPirateShipRoom
; @param hl Which component of pirate ship position to check
@updateRoom:
	cp (hl)			; $7e81
	ret nz			; $7e82

	ld (hl),b		; $7e83
	ld a,(wPirateShipRoom)		; $7e84
	add c			; $7e87
	ld (wPirateShipRoom),a		; $7e88
	ret			; $7e8b

;;
; @addr{7e8c}
@movingRight:
	ld hl,wPirateShipX		; $7e8c
	ldbc $00, $01		; $7e8f
	ld a,$98		; $7e92
	jr @updateRoom		; $7e94

;;
; @addr{7e96}
@movingDown:
	ld hl,wPirateShipY		; $7e96
	ld bc,$0010		; $7e99
	ld a,$88		; $7e9c
	jr @updateRoom		; $7e9e

;;
; @addr{7ea0}
@movingLeft:
	ld hl,wPirateShipX		; $7ea0
	ldbc $a0, $ff		; $7ea3
	ld a,$f8		; $7ea6
	jr @updateRoom		; $7ea8

;;
; @addr{7eaa}
updatePirateShipAngle:
	ld a,(wPirateShipChangedTile)		; $7eaa
	or a			; $7ead
	ret z			; $7eae

	ldh (<hFF8B),a	; $7eaf
	xor a			; $7eb1
	ld (wPirateShipChangedTile),a		; $7eb2
	ld hl,@shipDirectionsPast		; $7eb5
	call checkIsLinkedGame		; $7eb8
	jr z,@nextDirection			; $7ebb

	ld hl,@shipDirectionsPresent		; $7ebd

@nextDirection:
	ld a,(hl)		; $7ec0
	or a			; $7ec1
	ret z			; $7ec2

	push hl			; $7ec3
	ld a,(wPirateShipRoom)		; $7ec4
	cp (hl)			; $7ec7
	jr nz,++		; $7ec8

	inc hl			; $7eca
	ldh a,(<hFF8B)	; $7ecb
	cp (hl)			; $7ecd
	jr nz,++		; $7ece

	inc hl			; $7ed0
	ld a,(hl)		; $7ed1
	ld (wPirateShipAngle),a		; $7ed2
	pop hl			; $7ed5
	ret			; $7ed6
++
	pop hl			; $7ed7
	ld a,$03		; $7ed8
	rst_addAToHl			; $7eda
	jr @nextDirection		; $7edb

; Data format:
; b0: room index
; b1: YX position
; b2: new direction to move in when the ship reaches that position

; @addr{7edd}
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
