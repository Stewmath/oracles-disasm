; Item animations relocated to save space in bank 7.

itemSetAnimationHook:
	ld b,$00		; $49e4
	ld e,Item.id		; $49e6
	ld a,(de)		; $49e8
	ld hl,itemAnimationTable		; $49e9
	rst_addDoubleIndex			; $49ec
	ldi a,(hl)		; $49ed
	ld h,(hl)		; $49ee
	ld l,a			; $49ef
	add hl,bc		; $49f0
	jr ++

itemNextAnimationFrameHook:
	ld h,b
	ld l,c

++
	ldi a,(hl)		; $49f1
	ld h,(hl)		; $49f2
	ld l,a			; $49f3

	; Byte 0: how many frames to hold it (or $ff to loop)
	ldi a,(hl)		; $49f4
	cp $ff			; $49f5
	jr nz,++		; $49f7

	; If $ff, animation loops
	ld b,a			; $49f9
	ld c,(hl)		; $49fa
	add hl,bc		; $49fb
	ldi a,(hl)		; $49fc
++
	ld e,Item.animCounter		; $49fd
	ld (de),a		; $49ff

	; Byte 1: frame index (store in bc for now)
	ldi a,(hl)		; $4a00
	ld c,a			; $4a01
	ld b,$00		; $4a02

	; Item.animParameter
	inc e			; $4a04
	ldi a,(hl)		; $4a05
	ld (de),a		; $4a06

	; Item.animPointer
	inc e			; $4a07
	; Save the current position in the animation
	ld a,l			; $4a08
	ld (de),a		; $4a09
	inc e			; $4a0a
	ld a,h			; $4a0b
	ld (de),a		; $4a0c

	ld e,Item.id		; $4a0d
	ld a,(de)		; $4a0f
	ld hl,itemOamDataTable		; $4a10
	rst_addDoubleIndex			; $4a13
	ldi a,(hl)		; $4a14
	ld h,(hl)		; $4a15
	ld l,a			; $4a16
	add hl,bc		; $4a17

	; Set the address of the oam data
	ld e,Item.oamDataAddress		; $4a18
	ldi a,(hl)		; $4a1a
	ld (de),a		; $4a1b
	inc e			; $4a1c
	ldi a,(hl)		; $4a1d
	;and $3f			; $4a1e
	ld (de),a		; $4a20

	jpab itemNextAnimationFrameHookRet


.include "data/itemAnimations.s"
