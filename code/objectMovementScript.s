;;
; Called from objectRunMovementScript in bank0. See include/movementscript_commands.s.
;
; @param	hl	Script address
; @addr{6b2d}
objectLoadMovementScript_body:
	ldh a,(<hActiveObjectType)	; $6b2d
	add Object.subid			; $6b2f
	ld e,a			; $6b31
	ld a,(de)		; $6b32
	rst_addDoubleIndex			; $6b33
	ldi a,(hl)		; $6b34
	ld h,(hl)		; $6b35
	ld l,a			; $6b36

	ld a,e			; $6b37
	add Object.speed-Object.subid			; $6b38
	ld e,a			; $6b3a
	ldi a,(hl)		; $6b3b
	ld (de),a		; $6b3c

	ld a,e			; $6b3d
	add Object.direction-Object.speed			; $6b3e
	ld e,a			; $6b40
	ldi a,(hl)		; $6b41
	ld (de),a		; $6b42

	ld a,e			; $6b43
	add Object.var30-Object.direction 			; $6b44
	ld e,a			; $6b46
	ld a,l			; $6b47
	ld (de),a		; $6b48
	inc e			; $6b49
	ld a,h			; $6b4a
	ld (de),a		; $6b4b

;;
; Called from objectRunMovementScript in bank0. See include/movementscript_commands.s.
; @addr{6b4c}
objectRunMovementScript_body:
	ldh a,(<hActiveObjectType)	; $6b4c
	add Object.var30			; $6b4e
	ld e,a			; $6b50
	ld a,(de)		; $6b51
	ld l,a			; $6b52
	inc e			; $6b53
	ld a,(de)		; $6b54
	ld h,a			; $6b55

@nextOp:
	ldi a,(hl)		; $6b56
	push hl			; $6b57
	rst_jumpTable			; $6b58
	.dw @cmd00_jump
	.dw @moveUp
	.dw @moveRight
	.dw @moveDown
	.dw @moveLeft
	.dw @wait
.ifdef ROM_AGES
	.dw @setstate
.endif


@cmd00_jump:
	pop hl			; $6b67
	ldi a,(hl)		; $6b68
	ld h,(hl)		; $6b69
	ld l,a			; $6b6a
	jr @nextOp		; $6b6b


@moveUp:
	pop bc			; $6b6d
	ld h,d			; $6b6e
	ldh a,(<hActiveObjectType)	; $6b6f
	add Object.var32			; $6b71
	ld l,a			; $6b73
	ld a,(bc)		; $6b74
	ld (hl),a		; $6b75

	ld a,l			; $6b76
	add Object.angle-Object.var32			; $6b77
	ld l,a			; $6b79
	ld (hl),ANGLE_UP		; $6b7a

	add Object.state-Object.angle			; $6b7c
	ld l,a			; $6b7e
	ld (hl),$08		; $6b7f
	jr @storePointer		; $6b81


@moveRight:
	pop bc			; $6b83
	ld h,d			; $6b84
	ldh a,(<hActiveObjectType)	; $6b85
	add Object.var33			; $6b87
	ld l,a			; $6b89
	ld a,(bc)		; $6b8a
	ld (hl),a		; $6b8b

	ld a,l			; $6b8c
	add Object.angle-Object.var33			; $6b8d
	ld l,a			; $6b8f
	ld (hl),ANGLE_RIGHT		; $6b90

	add Object.state-Object.angle			; $6b92
	ld l,a			; $6b94
	ld (hl),$09		; $6b95
	jr @storePointer		; $6b97


@moveDown:
	pop bc			; $6b99
	ld h,d			; $6b9a
	ldh a,(<hActiveObjectType)	; $6b9b
	add Object.var32			; $6b9d
	ld l,a			; $6b9f
	ld a,(bc)		; $6ba0
	ld (hl),a		; $6ba1

	ld a,l			; $6ba2
	add Object.angle-Object.var32			; $6ba3
	ld l,a			; $6ba5
	ld (hl),ANGLE_DOWN		; $6ba6

	add Object.state-Object.angle			; $6ba8
	ld l,a			; $6baa
	ld (hl),$0a		; $6bab
	jr @storePointer		; $6bad


@moveLeft:
	pop bc			; $6baf
	ld h,d			; $6bb0
	ldh a,(<hActiveObjectType)	; $6bb1
	add Object.var33			; $6bb3
	ld l,a			; $6bb5
	ld a,(bc)		; $6bb6
	ld (hl),a		; $6bb7

	ld a,l			; $6bb8
	add Object.angle-Object.var33			; $6bb9
	ld l,a			; $6bbb
	ld (hl),ANGLE_LEFT		; $6bbc

	add Object.state-Object.angle			; $6bbe
	ld l,a			; $6bc0
	ld (hl),$0b		; $6bc1
	jr @storePointer		; $6bc3


@wait:
	pop bc			; $6bc5
	ld h,d			; $6bc6
	ldh a,(<hActiveObjectType)	; $6bc7
	add Object.counter1			; $6bc9
	ld l,a			; $6bcb
	ld a,(bc)		; $6bcc
.ifdef ROM_AGES
	ldd (hl),a		; $6bcd

	dec l			; $6bce
	ld (hl),$0c ; [state]
.else
	ld (hl),a		; $7a2d
	ld a,l			; $7a2e
	add $fe			; $7a2f
	ld l,a			; $7a31
	ld (hl),$0c		; $7a32
.endif

@storePointer:
	inc bc			; $6bd1
.ifdef ROM_AGES
	ld a,l			; $6bd2
.endif
	add Object.var30-Object.state			; $6bd3
	ld l,a			; $6bd5
	ld (hl),c		; $6bd6
	inc l			; $6bd7
	ld (hl),b		; $6bd8
	ret			; $6bd9

.ifdef ROM_AGES
@setstate:
	pop bc			; $6bda
	ld h,d			; $6bdb
	ldh a,(<hActiveObjectType)	; $6bdc
	add Object.counter1			; $6bde
	ld l,a			; $6be0
	ld a,(bc)		; $6be1
	ldd (hl),a		; $6be2

	dec l			; $6be3
	inc bc			; $6be4
	ld a,(bc)		; $6be5
	ld (hl),a ; [state]

	jr @storePointer		; $6be7
.endif
