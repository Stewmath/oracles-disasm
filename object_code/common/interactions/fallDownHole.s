; ==================================================================================================
; INTERAC_FALLDOWNHOLE
; ==================================================================================================
interactionCode0f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @interac0f_state0
	.dw @interac0f_state1
	.dw @interac0f_state2

@interac0f_state0:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState

	; [state] += [subid]
	ld e,Interaction.subid
	ld a,(de)
	add (hl)
	ld (hl),a

	ld l,Interaction.speed
	ld (hl),SPEED_60
	dec a
	jr z,@fallDownHole

@dust:
	call interactionSetAnimation
	jp objectSetVisible80

@fallDownHole:
	inc e
	ld a,(de)
	rlca
	ld a,SND_FALLINHOLE
	call nc,playSound
.ifdef ROM_AGES
	call @checkUpdateHoleEvent
.endif
	jp objectSetVisible83


; State 1: "falling into hole" animation
@interac0f_state1:
	ld h,d
	ld l,Interaction.animParameter
	bit 7,(hl)
	jr nz,@delete

	; Calculate the direction this should move in to move towards the
	; center of the hole
	ld l,Interaction.yh
	ldi a,(hl)
	ldh (<hFF8F),a
	add $05
	and $f0
	add $08
	ld b,a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	and $f0
	add $08
	ld c,a
	cp (hl)
	jr nz,+

	ldh a,(<hFF8F)
	cp b
	jr z,@animate
+
	call objectGetRelativeAngleWithTempVars
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed

@animate:
	jp interactionAnimate


; State 2: pegasus seed dust?
@interac0f_state2:
	ld h,d
	ld l,Interaction.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ld l,Interaction.animParameter
	bit 7,(hl)
	jr z,@animate
@delete:
	jp interactionDelete


.ifdef ROM_AGES
;;
; Certain rooms have things happen when something falls into a hole; this writes something
; around $cfd8 to provide a signal?
@checkUpdateHoleEvent:
	ld a,(wActiveRoom)
	ld e,a
	ld hl,@specialHoleRooms
	call lookupKey
	ret nc

	ld b,a
	ld a,(wActiveGroup)
	cp b
	ret nz

	ld hl,wTmpcfc0.fallDownHoleEvent.cfd8
	ld b,$04
--
	ldi a,(hl)
	cp $ff
	jr nz,++

	; This contains the ID of the object that fell in the hole?
	ld e,Interaction.counter2
	ld a,(de)
	ldd (hl),a
	dec e
	ld a,(de)
	ld (hl),a
	ret
++
	inc l
	dec b
	jr nz,--
	ret

@specialHoleRooms:
	.dw ROOM_AGES_5e8 ; Patch's room
	.dw ROOM_AGES_23e ; Toilet room
	.db $00

;;
clearFallDownHoleEventBuffer:
	ld hl,wTmpcfc0.fallDownHoleEvent.cfd8
	ld b,_sizeof_wTmpcfc0.fallDownHoleEvent.cfd8
	ld a,$ff
	jp fillMemory
.endif
