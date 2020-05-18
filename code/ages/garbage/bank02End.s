.ifdef BUILD_VANILLA

; From here on are corrupted repeats of functions starting from
; "readParametersForRectangleDrawing".

;;
; @addr{7de7}
_fake_readParametersForRectangleDrawing:
	ldi a,(hl)		; $7de7
	ld b,a			; $7de8
	ldi a,(hl)		; $7de9
	ld c,a			; $7dea
	ret			; $7deb

;;
; @addr{7dec}
_fake_drawRectangleToVramTiles_withParameters:
	ld a,($ff00+R_SVBK)	; $7dec
	push af			; $7dee
	ld a,$03		; $7def
	ld ($ff00+R_SVBK),a	; $7df1
	jr _fake_drawRectangleToVramTiles@nextRow			; $7df3

;;
; @addr{7df5}
_fake_drawRectangleToVramTiles:
	ld a,($ff00+R_SVBK)	; $7df5
	push af			; $7df7
	ld a,$03		; $7df8
	ld ($ff00+R_SVBK),a	; $7dfa
	call $7de3		; $7dfc

@nextRow:
	push bc			; $7dff
--
	ldi a,(hl)		; $7e00
	ld (de),a		; $7e01
	set 2,d			; $7e02
	ldi a,(hl)		; $7e04
	ld (de),a		; $7e05
	res 2,d			; $7e06
	inc de			; $7e08
	dec c			; $7e09
	jr nz,--		; $7e0a

	pop bc			; $7e0c
	ld a,$20		; $7e0d
	sub c			; $7e0f
	call addAToDe		; $7e10
	dec b			; $7e13
	jr nz,@nextRow		; $7e14

	pop af			; $7e16
	ld ($ff00+R_SVBK),a	; $7e17
	ret			; $7e19

;;
; @addr{7e1a}
_fake_copyRectangleFromVramTilesToAddress_paramBc:
	ld l,c			; $7e1a
	ld h,b			; $7e1b

;;
; @addr{7e1c}
_fake_copyRectangleFromVramTilesToAddress:
	ld a,($ff00+R_SVBK)	; $7e1c
	push af			; $7e1e

	ldi a,(hl)		; $7e1f
	ld b,a			; $7e20
	ldi a,(hl)		; $7e21
	ld c,a			; $7e22
	ldi a,(hl)		; $7e23
	ld e,a			; $7e24
	ldi a,(hl)		; $7e25
	ld d,a			; $7e26
	ldi a,(hl)		; $7e27
	ld h,(hl)		; $7e28
	ld l,a			; $7e29

@nextRow:
	push bc			; $7e2a
--
	ld a,$02		; $7e2b
	ld ($ff00+R_SVBK),a	; $7e2d
	ldi a,(hl)		; $7e2f
	ld b,a			; $7e30
	ld a,$03		; $7e31
	ld ($ff00+R_SVBK),a	; $7e33
	ld a,b			; $7e35
	ld (de),a		; $7e36
	inc de			; $7e37
	dec c			; $7e38
	jr nz,--		; $7e39
	pop bc			; $7e3b
	ld a,$20		; $7e3c
	sub c			; $7e3e
	call addAToDe		; $7e3f
	ld a,$20		; $7e42
	sub c			; $7e44
	rst_addAToHl			; $7e45
	dec b			; $7e46
	jr nz,@nextRow		; $7e47

	pop af			; $7e49
	ld ($ff00+R_SVBK),a	; $7e4a
	ret			; $7e4c

;;
; @addr{7e4d}
_fake_copyRectangleToRoomLayoutAndCollisions:
	ldi a,(hl)		; $7e4d
	ld e,a			; $7e4e
	ldi a,(hl)		; $7e4f
	ld d,a			; $7e50

;;
; @addr{7e51}
_fake_copyRectangleToRoomLayoutAndCollisions_paramDe:
	ldi a,(hl)		; $7e51
	ld b,a			; $7e52
	ldi a,(hl)		; $7e53
	ld c,a			; $7e54

@nextRow:
	push bc			; $7e55
--
	ldi a,(hl)		; $7e56
	ld (de),a		; $7e57
	dec d			; $7e58
	ldi a,(hl)		; $7e59
	ld (de),a		; $7e5a
	inc d			; $7e5b
	inc de			; $7e5c
	dec c			; $7e5d
	jr nz,--		; $7e5e
	pop bc			; $7e60
	ld a,$10		; $7e61
	sub c			; $7e63
	call addAToDe		; $7e64
	dec b			; $7e67
	jr nz,@nextRow		; $7e68
	ret			; $7e6a

;;
; @addr{7e6b}
_fake_roomTileChangesAfterLoad04:
	ld hl,wInShop		; $7e6b
	set 1,(hl)		; $7e6e
	ld a,TREE_GFXH_03		; $7e70
	jp $1686		; $7e72

;;
; @addr{7e75}
_fake_checkLoadPastSignAndChestGfx:
	ld a,(wDungeonIndex)		; $7e75
	cp $0f			; $7e78
	ret z			; $7e7a

	ld a,(wTilesetFlags)		; $7e7b
	bit 7,a			; $7e7e
	ret z			; $7e80

	bit 0,a			; $7e81
	ret nz			; $7e83

	bit 5,a			; $7e84
	ret nz			; $7e86

	and $1c			; $7e87
	ret z			; $7e89

	ld a,UNCMP_GFXH_37		; $7e8a
	jp $05df		; $7e8c

_fake_rectangleData_02_7de1:
	.db $06 $06
	.dw w3VramTiles+8 w2TmpGfxBuffer

.endif ; BUILD_VANILLA
