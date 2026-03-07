; ==================================================================================================
; INTERAC_MINECART_GATE
; ==================================================================================================
interactionCode1b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a

	; Move bits 4-7 of subid to bits 0-3 (direction of gate)
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	swap a
	and $0f
	ld (de),a

	; Set var03 to a bitmask based on bits 0-2 of subid
	ld a,b
	and $07
	ld hl,bitTable
	add l
	ld l,a
	inc e
	ld a,(hl)
	ld (de),a

	call interactionInitGraphics
	call objectSetVisible82

	call @setAnimationAndUpdateCollisions
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	and $01
	inc a
	ld e,Interaction.state
	ld (de),a
	ld a,b
	xor $01
	jp interactionSetAnimation

;;
; Sets var30 to the animation to be done. Bit 0 set if the gate is open.
; Also modifies tile collisions appropriately.
@setAnimationAndUpdateCollisions:
	ld a,(wSwitchState)
	ld b,a
	ld e,Interaction.var03
	ld a,(de)
	and b
	ld c,$00
	jr nz,+
	ld c,$01
+
	dec e
	ld a,(de) ; a = [subid] (subid is 0 if facing left, 2 if facing right)
	or c
	ld e,Interaction.var30
	ld (de),a

	call interactionSetAnimation

	call objectGetTileAtPosition
	dec h ; h points to wRoomCollisions
	dec l

	; a = [var30]*3
	ld e,Interaction.var30
	ld a,(de)
	ld b,a
	add a
	add b

	ld bc,@collisions
	call addAToBc
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ld (hl),a

	inc bc
	ld a,(bc)
	add l
	ld l,a
	inc h
	ld a,(de)
	rrca
	jr c,+
	ld (hl),$5e
	ret
+
	ld (hl),$00
	ret

@collisions:
	.db $00 $0a  $ff ; Gate facing right
	.db $0c $0a  $ff
	.db $05 $00  $00 ; Gate facing left
	.db $05 $0c  $00


; State 1: waiting for switch to be pressed
@state1:
	call objectSetPriorityRelativeToLink
	ld a,(wSwitchState)
	cpl
	jr ++

; State 2: waiting for switch to be released
@state2:
	call objectSetPriorityRelativeToLink
	ld a,(wSwitchState)
++
	ld b,a
	ld e,Interaction.var03
	ld a,(de)
	and b
	ret z

	ld e,Interaction.state
	ld a,$03
	ld (de),a
	ld a,SND_OPEN_GATE
	call playSound
	jp @setAnimationAndUpdateCollisions


; State 3: in the process of opening or closing
@state3:
	call interactionAnimate
	call objectSetPriorityRelativeToLink

	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	ret nz

	ld e,Interaction.var30
	ld a,(de)
	and $01
	inc a
	ld e,Interaction.state
	ld (de),a
	ret
