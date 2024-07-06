; ==================================================================================================
; INTERAC_VOLCANO_HANDLER
; ==================================================================================================
interactionCodeb2:
	call checkInteractionState
	jr z,@state0

@state1:
	ld a,(wFrameCounter)
	and $0f
	ld a,SND_RUMBLE
	call z,playSound

	ld a,(wScreenShakeCounterY)
	or a
	jr nz,++
	ld a,(wScreenShakeCounterX)
	or a
	call z,@runScript
++
	call interactionDecCounter1
	ret nz
	call @setRandomCounter1

	ld c,$0f
	call getRandomNumber
	and c
	srl c
	inc c
	sub c
	ld c,a
	call getFreePartSlot
	ret nz
	ld (hl),PART_VOLCANO_ROCK
	inc l
	ld (hl),$01 ; [subid]
	ld b,$00
	jp objectCopyPositionWithOffset

@state0:
	inc a
	ld (de),a ; [state]
	ld (wScreenShakeMagnitude),a
	ld hl,@script
	jp interactionSetMiniScript

@runScript:
	call interactionGetMiniScript
	ldi a,(hl)
	cp $ff
	jr nz,@handleOpcode
	ld hl,@script
	call interactionSetMiniScript
	jr @runScript

@handleOpcode:
	ld (wScreenShakeCounterY),a
	ldi a,(hl)
	ld (wScreenShakeCounterX),a

	ld e,Interaction.var30
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	call interactionSetMiniScript

@setRandomCounter1:
	call getRandomNumber_noPreserveVars
	ld h,d
	ld l,Interaction.var30
	and (hl)
	inc l
	add (hl)
	ld l,Interaction.counter1
	ld (hl),a
	ret


; "Script" format per line:
;   b0: wScreenShakeCounterY
;   b1: wScreenShakeCounterX
;   b2: ANDed with a random number and added to...
;   b3: Base value for counter1 (time until a rock spawns)
@script:
	.db 0  , 30 , $00, $ff
	.db 30 , 0  , $00, $ff
	.db 180, 180, $0f, $08
	.db 60 , 60 , $1f, $10
	.db 30 , 0  , $00, $ff
	.db 0  , 120, $00, $ff
	.db 15 , 15 , $00, $ff
	.db $ff
