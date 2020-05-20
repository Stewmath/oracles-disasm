;;
; Called from objectRunMovementScript in bank0. See include/movementscript_commands.s.
;
; @param	hl	Script address
objectLoadMovementScript_body:
	ldh a,(<hActiveObjectType)
	add Object.subid
	ld e,a
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,e
	add Object.speed-Object.subid
	ld e,a
	ldi a,(hl)
	ld (de),a

	ld a,e
	add Object.direction-Object.speed
	ld e,a
	ldi a,(hl)
	ld (de),a

	ld a,e
	add Object.var30-Object.direction 
	ld e,a
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

;;
; Called from objectRunMovementScript in bank0. See include/movementscript_commands.s.
objectRunMovementScript_body:
	ldh a,(<hActiveObjectType)
	add Object.var30
	ld e,a
	ld a,(de)
	ld l,a
	inc e
	ld a,(de)
	ld h,a

@nextOp:
	ldi a,(hl)
	push hl
	rst_jumpTable
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
	pop hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jr @nextOp


@moveUp:
	pop bc
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.var32
	ld l,a
	ld a,(bc)
	ld (hl),a

	ld a,l
	add Object.angle-Object.var32
	ld l,a
	ld (hl),ANGLE_UP

	add Object.state-Object.angle
	ld l,a
	ld (hl),$08
	jr @storePointer


@moveRight:
	pop bc
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.var33
	ld l,a
	ld a,(bc)
	ld (hl),a

	ld a,l
	add Object.angle-Object.var33
	ld l,a
	ld (hl),ANGLE_RIGHT

	add Object.state-Object.angle
	ld l,a
	ld (hl),$09
	jr @storePointer


@moveDown:
	pop bc
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.var32
	ld l,a
	ld a,(bc)
	ld (hl),a

	ld a,l
	add Object.angle-Object.var32
	ld l,a
	ld (hl),ANGLE_DOWN

	add Object.state-Object.angle
	ld l,a
	ld (hl),$0a
	jr @storePointer


@moveLeft:
	pop bc
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.var33
	ld l,a
	ld a,(bc)
	ld (hl),a

	ld a,l
	add Object.angle-Object.var33
	ld l,a
	ld (hl),ANGLE_LEFT

	add Object.state-Object.angle
	ld l,a
	ld (hl),$0b
	jr @storePointer


@wait:
	pop bc
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.counter1
	ld l,a
	ld a,(bc)
.ifdef ROM_AGES
	ldd (hl),a

	dec l
	ld (hl),$0c ; [state]
.else
	ld (hl),a
	ld a,l
	add $fe
	ld l,a
	ld (hl),$0c
.endif

@storePointer:
	inc bc
.ifdef ROM_AGES
	ld a,l
.endif
	add Object.var30-Object.state
	ld l,a
	ld (hl),c
	inc l
	ld (hl),b
	ret

.ifdef ROM_AGES
@setstate:
	pop bc
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.counter1
	ld l,a
	ld a,(bc)
	ldd (hl),a

	dec l
	inc bc
	ld a,(bc)
	ld (hl),a ; [state]

	jr @storePointer
.endif
