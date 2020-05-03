applyAllTileSubstitutions:
	call applySingleTileChanges		; $5d94
	call applyStandardTileSubstitutions		; $5d97
	call replaceOpenedChest		; $5d9a
	ld a,(wActiveGroup)		; $5d9d
	cp $02			; $5da0
	jr z,++			; $5da2
	cp NUM_SMALL_GROUPS			; $5da4
	jr nc,+			; $5da6
	; groups 0,1,3
	call loadSubrosiaObjectGfxHeader		; $5da8
	jp applyRoomSpecificTileChanges		; $5dab
+
	; groups 4,5,6,7
	call replaceShutterForLinkEntering		; $5dae
	call replaceSwitchTiles		; $5db1
	jp applyRoomSpecificTileChanges		; $5db4
++
	; group 2
	ld e,OBJGFXH_04-1		; $5db7
	jp loadObjectGfxHeaderToSlot4		; $5db9

loadSubrosiaObjectGfxHeader:
	ld a,(wMinimapGroup)		; $5dbc
	cp $01			; $5dbf
	ret nz			; $5dc1
	ld e,OBJGFXH_07-1		; $5dc2
	jp loadObjectGfxHeaderToSlot4		; $5dc4

;;
; @param de Structure for tiles to replace
; (format: tile to replace with, tile to replace, repeat, $00 to end)
replaceTiles:
	ld a,(de)		; $5dc7
	or a			; $5dc8
	ret z			; $5dc9
	ld b,a			; $5dca
	inc de			; $5dcb
	ld a,(de)		; $5dcc
	inc de			; $5dcd
	call findTileInRoom		; $5dce
	jr nz,replaceTiles	; $5dd1
	ld (hl),b		; $5dd3
	ld c,a			; $5dd4
	ld a,l			; $5dd5
	or a			; $5dd6
	jr z,replaceTiles	; $5dd7
-
	dec l			; $5dd9
	ld a,c			; $5dda
	call backwardsSearch		; $5ddb
	jr nz,replaceTiles	; $5dde
	ld (hl),b		; $5de0
	ld c,a			; $5de1
	ld a,l			; $5de2
	or a			; $5de3
	jr z,replaceTiles	; $5de4
	jr -			; $5de6

applyStandardTileSubstitutions:
	call getThisRoomFlags		; $5de8
	ldh (<hFF8B),a	; $5deb
	ld hl,@bit0		; $5ded
	bit 0,a			; $5df0
	call nz,@locFunc		; $5df2

	ld hl,@bit1		; $5df5
	ldh a,(<hFF8B)	; $5df8
	bit 1,a			; $5dfa
	call nz,@locFunc		; $5dfc

	ld hl,@bit2		; $5dff
	ldh a,(<hFF8B)	; $5e02
	bit 2,a			; $5e04
	call nz,@locFunc		; $5e06

	ld hl,@bit3		; $5e09
	ldh a,(<hFF8B)	; $5e0c
	bit 3,a			; $5e0e
	call nz,@locFunc		; $5e10

	ld hl,@bit7		; $5e13
	ldh a,(<hFF8B)	; $5e16
	bit 7,a			; $5e18
	ret z			; $5e1a
@locFunc:
	ld a,(wActiveGroup)		; $5e1b
	rst_addDoubleIndex			; $5e1e
	ldi a,(hl)		; $5e1f
	ld h,(hl)		; $5e20
	ld l,a			; $5e21
	ld e,l			; $5e22
	ld d,h			; $5e23
	jr replaceTiles		; $5e24

@bit0:
	.dw @bit0Collisions0
	.dw @bit0Collisions1
	.dw @bit0Collisions2
	.dw @bit0Collisions3
	.dw @bit0Collisions4
	.dw @bit0Collisions5
	.dw @bit0Collisions6
	.dw @bit0Collisions7

@bit1:
	.dw @bit1Collisions0
	.dw @bit1Collisions1
	.dw @bit1Collisions2
	.dw @bit1Collisions3
	.dw @bit1Collisions4
	.dw @bit1Collisions5
	.dw @bit1Collisions6
	.dw @bit1Collisions7

@bit2:
	.dw @bit2Collisions0
	.dw @bit2Collisions1
	.dw @bit2Collisions2
	.dw @bit2Collisions3
	.dw @bit2Collisions4
	.dw @bit2Collisions5
	.dw @bit2Collisions6
	.dw @bit2Collisions7

@bit3:
	.dw @bit3Collisions0
	.dw @bit3Collisions1
	.dw @bit3Collisions2
	.dw @bit3Collisions3
	.dw @bit3Collisions4
	.dw @bit3Collisions5
	.dw @bit3Collisions6
	.dw @bit3Collisions7

@bit7:
	.dw @bit7Collisions0
	.dw @bit7Collisions1
	.dw @bit7Collisions2
	.dw @bit7Collisions3
	.dw @bit7Collisions4
	.dw @bit7Collisions5
	.dw @bit7Collisions6
	.dw @bit7Collisions7

@bit0Collisions0:
@bit0Collisions1:
@bit0Collisions2:
	.db $00

@bit0Collisions3:
@bit0Collisions4:
@bit0Collisions5:
	.db $34 $30
	.db $34 $38
	.db $a0 $70
	.db $a0 $74
	.db $00

@bit0Collisions6:
@bit0Collisions7:
	.db $00

@bit1Collisions0:
@bit1Collisions1:
@bit1Collisions2:
	.db $00

@bit1Collisions3:
@bit1Collisions4:
@bit1Collisions5:
	.db $35 $31
	.db $35 $39
	.db $a0 $71
	.db $a0 $75

@bit1Collisions6:
@bit1Collisions7:
	.db $00

@bit2Collisions0:
@bit2Collisions1:
@bit2Collisions2:
	.db $00

@bit2Collisions3:
@bit2Collisions4:
@bit2Collisions5:
	.db $36 $32
	.db $36 $3a
	.db $a0 $72
	.db $a0 $76

@bit2Collisions6:
@bit2Collisions7:
	.db $00

@bit3Collisions0:
@bit3Collisions1:
@bit3Collisions2:
	.db $00

@bit3Collisions3:
@bit3Collisions4:
@bit3Collisions5:
	.db $37 $33
	.db $37 $3b
	.db $a0 $73
	.db $a0 $77

@bit3Collisions6:
@bit3Collisions7:
	.db $00

@bit7Collisions0:
	.db $e7 $c1
	.db $e0 $c6
	.db $e0 $c2
	.db $e0 $e3
	.db $e6 $c5
	.db $e7 $cb
	.db $e8 $e2

@bit7Collisions1:
	.db $00

@bit7Collisions2:
	.db $00

@bit7Collisions3:
	.db $00

@bit7Collisions4:
@bit7Collisions5:
	.db $a0 $1e
	.db $44 $42
	.db $45 $43
	.db $46 $40
	.db $47 $41
	.db $45 $8d

@bit7Collisions6:
@bit7Collisions7:
	.db $00

replaceShutterForLinkEntering:
	ld a,(wDungeonIndex)		; $5ebd
	inc a			; $5ec0
	ret z			; $5ec1
	ld bc,wRoomLayout+$ae		; $5ec2
-
	ld a,(bc)		; $5ec5
	push bc			; $5ec6
	sub $78			; $5ec7
	cp $08			; $5ec9
	call c,@temporarilyOpenDoor		; $5ecb
	pop bc			; $5ece
	dec c			; $5ecf
	jr nz,-			; $5ed0
	ret			; $5ed2

@temporarilyOpenDoor:
	ld de,@shutterData		; $5ed3
	call addDoubleIndexToDe		; $5ed6
	ld a,(de)		; $5ed9
	ldh (<hFF8B),a	; $5eda
	inc de			; $5edc
	ld a,(de)		; $5edd
	ld e,a			; $5ede
	ld a,(wScrollMode)		; $5edf
	and $08			; $5ee2
	jr z,@doneReplacement	; $5ee4

	ld a,(wLinkObjectIndex)		; $5ee6
	ld h,a			; $5ee9
	ld a,($cd02)		; $5eea
	xor $02			; $5eed
	ld d,a			; $5eef
	ld a,e			; $5ef0
	and $03			; $5ef1
	cp d			; $5ef3
	ret nz			; $5ef4
	ld a,($cd02)		; $5ef5
	bit 0,a			; $5ef8
	jr nz,@horizontal	; $5efa

	and $02			; $5efc
	ld l,$0d		; $5efe
	ld a,(hl)		; $5f00
	jr nz,@down	; $5f01
@up:
	and $f0			; $5f03
	swap a			; $5f05
	or $a0			; $5f07
	jr @doReplacement		; $5f09
@down:
	and $f0			; $5f0b
	swap a			; $5f0d
	jr @doReplacement		; $5f0f
@horizontal:
	and $02			; $5f11
	ld l,$0b		; $5f13
	ld a,(hl)		; $5f15
	jr nz,@left	; $5f16
@right:
	and $f0			; $5f18
	jr @doReplacement		; $5f1a
@left:
	and $f0			; $5f1c
	or $0e			; $5f1e

@doReplacement:
	cp c			; $5f20
	jr nz,@doneReplacement	; $5f21

	push bc			; $5f23
	ld c,a			; $5f24
	ld a,(bc)		; $5f25
	sub $78			; $5f26
	cp $08			; $5f28
	jr nc,+			; $5f2a

	ldh a,(<hFF8B)	; $5f2c
	ld (bc),a		; $5f2e
+
	pop bc			; $5f2f

@doneReplacement:
	ld a,e			; $5f30
	bit 7,a			; $5f31
	ret nz			; $5f33
	and $7f			; $5f34
	ld e,a			; $5f36
	call getFreeInteractionSlot		; $5f37
	ret nz			; $5f3a
	ld (hl),$1e		; $5f3b
	inc l			; $5f3d
	ld (hl),e		; $5f3e
	ld l,$4b		; $5f3f
	ld (hl),c		; $5f41
	ret			; $5f42

@shutterData:
	.db $a0 $80
	.db $a0 $81
	.db $a0 $82
	.db $a0 $83
	.db $5e $0c
	.db $5d $0d
	.db $5e $0e
	.db $5d $0f

replaceOpenedChest:
	call getThisRoomFlags		; $5f53
	bit 5,a			; $5f56
	ret z			; $5f58
	call getChestData		; $5f59
	ld d,$cf		; $5f5c
	ld a,$f0		; $5f5e
	ld (de),a		; $5f60
	ret			; $5f61

replaceSwitchTiles:
	ld hl,@group4SwitchData		; $5f62
	ld a,($cc49)		; $5f65
	sub $04			; $5f68
	jr z,+	; $5f6a

	dec a			; $5f6c
	ret nz			; $5f6d

	ld hl,@group5SwitchData		; $5f6e
+
	ld a,($cc4c)		; $5f71
	ld b,a			; $5f74
	ld a,($cc32)		; $5f75
	ld c,a			; $5f78
	ld d,$cf		; $5f79
@next:
	ldi a,(hl)		; $5f7b
	or a			; $5f7c
	ret z			; $5f7d
	cp b			; $5f7e
	jr nz,@skip3Bytes	; $5f7f

	ldi a,(hl)		; $5f81
	and c			; $5f82
	jr z,@skip2Bytes	; $5f83

	ldi a,(hl)		; $5f85
	ld e,(hl)		; $5f86
	inc hl			; $5f87
	ld (de),a		; $5f88
	jr @next		; $5f89
@skip3Bytes:
	inc hl			; $5f8b
@skip2Bytes:
	inc hl			; $5f8c
	inc hl			; $5f8d
	jr @next		; $5f8e

@group4SwitchData:
	.db $0f $01 $0b $33
	.db $0f $01 $5a $74
	.db $6f $01 $0b $8c
	.db $6f $01 $5c $29
	.db $70 $02 $0b $28
	.db $70 $02 $5b $52
	.db $70 $04 $0b $59
	.db $70 $04 $5b $84
	.db $76 $08 $0b $17
	.db $76 $08 $5d $25
	.db $7e $10 $0b $56
	.db $7e $10 $5c $66
	.db $a0 $01 $5e $44
	.db $a0 $02 $5e $37
	.db $a0 $01 $0b $83
	.db $a0 $02 $0b $78
	.db $00

@group5SwitchData:
	.db $7e $01 $5c $2b
	.db $7e $01 $0b $78
	.db $00

applySingleTileChanges:
	ld a,($cc4c)		; $5fda
	ld b,a			; $5fdd
	call getThisRoomFlags		; $5fde
	ld c,a			; $5fe1
	ld d,$cf		; $5fe2
	ld a,($cc49)		; $5fe4
	ld hl,singleTileChangeGroupTable		; $5fe7
	rst_addDoubleIndex			; $5fea
	ldi a,(hl)		; $5feb
	ld h,(hl)		; $5fec
	ld l,a			; $5fed
@next:
	ldi a,(hl)		; $5fee
	cp b			; $5fef
	jr nz,@match	; $5ff0
	ld a,(hl)		; $5ff2
	and c			; $5ff3
	jr z,@match	; $5ff4
	inc hl			; $5ff6
	ldi a,(hl)		; $5ff7
	ld e,a			; $5ff8
	ldi a,(hl)		; $5ff9
	ld (de),a		; $5ffa
	jr @next		; $5ffb

@match:
	ld a,(hl)		; $5ffd
	or a			; $5ffe
	ret z			; $5fff
	inc hl			; $6000
	inc hl			; $6001
	inc hl			; $6002
	jr @next		; $6003
