; ==================================================================================================
; INTERAC_RAFTWRECK_CUTSCENE_HELPER
; ==================================================================================================
interactionCode64:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05

@initSubid00:
@initSubid01:
@initSubid02:
	call interactionInitGraphics
	call objectSetVisible82

@loadAngleAndCounterPreset:
	ld b,$03
	callab agesInteractionsBank0a.loadAngleAndCounterPreset
	ld a,b
	or a
	ret

@initSubid03:
@initSubid04:
@initSubid05:
	ret

;;
; Reads from a table, gets a position, sets counter1, ...?
;
; @param	counter2	Index from table to read
; @param	hl		Table to read from
; @param[out]	bc		Position for a new object?
; @param[out]	e		Subid for a new object?
@func_73fd:
	ld e,Interaction.counter2
	ld a,(de)
	add a
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld a,(hl)
	ld h,d
	ld l,Interaction.counter1
	ld (hl),a
	ret

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runSubid03
	.dw @runSubid04
	.dw @runSubid05

@runSubid00:
@runSubid01:
@runSubid02:
	call interactionAnimate
	call objectApplySpeed
	cp $f0
	jp nc,interactionDelete
	call interactionDecCounter1
	call z,@loadAngleAndCounterPreset
	jp z,interactionDelete
	ret

@runSubid03:
@runSubid04:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld hl,@subid3Objects
	ld e,Interaction.subid
	ld a,(de)
	cp $03
	jr z,+
	ld hl,@subid4Objects
+
	call @func_73fd

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_RAFTWRECK_CUTSCENE_HELPER
	inc l
	ld (hl),e
	inc l
	ld e,Interaction.counter2
	ld a,(de)
	ld (hl),a
	ld e,Interaction.subid
	ld a,(de)
	cp $03
	ld a,SPEED_200
	jr z,+
	ld a,SPEED_300
+
	ld l,Interaction.speed
	ld (hl),a
	call interactionHSetPosition

	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jp z,interactionDelete
	inc l
	inc (hl)
	ret


; Tables of objects to spawn for the "wind" parts of the cutscene.
;   b0: Y position
;   b1: X position
;   b2: subID of this interaction type to spawn
;   b3: counter1
@subid3Objects:
	.db $00 $b8 $00 $14
	.db $10 $a8 $00 $14
	.db $40 $a8 $00 $14
	.db $48 $b8 $01 $14
	.db $20 $a8 $00 $00

@subid4Objects:
	.db $20 $b8 $00 $10
	.db $40 $a8 $00 $14
	.db $10 $b0 $01 $10
	.db $48 $b8 $00 $14
	.db $08 $b0 $01 $10
	.db $50 $a8 $00 $14
	.db $f0 $b0 $00 $10
	.db $08 $b8 $02 $10
	.db $48 $b8 $00 $14
	.db $08 $b0 $01 $10
	.db $50 $a8 $00 $14
	.db $18 $b0 $01 $10
	.db $38 $b8 $02 $10
	.db $58 $a8 $00 $14
	.db $28 $b0 $01 $10
	.db $00 $a8 $00 $00

@runSubid05:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld hl,@subid5Objects
	call @func_73fd

	; Create lightning
	call getFreePartSlot
	ret nz
	ld (hl),PART_LIGHTNING
	inc l
	ld (hl),e
	inc l
	inc (hl)
	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c

	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	inc l
	inc (hl)
	ret
+
	; Signal to INTERAC_RAFTWRECK_CUTSCENE that the cutscene is done
	ld a,$03
	ld (wTmpcfc0.genericCutscene.state),a
	jp interactionDelete


; Tables of lightning objects to spawn in the final part of the cutscene.
;   b0: Y position
;   b1: X position
;   b2: subID of this interaction type to spawn
;   b3: counter1
@subid5Objects:
	.db $28 $28 $01 $28
	.db $58 $38 $01 $5a
	.db $40 $50 $01 $00
