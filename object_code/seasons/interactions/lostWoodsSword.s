; ==================================================================================================
; INTERAC_LOST_WOODS_SWORD
; ==================================================================================================
interactionCode59:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	ld a,TREASURE_SWORD
	call checkTreasureObtained
	jr nc,+
	cp $03
	jp nc,interactionDelete
	sub $01
	ld e,$42
	ld (de),a
+
	call interactionInitGraphics
	call interactionIncState
	call objectSetVisible
	call objectSetVisible80
	ld hl,mainScripts.lostWoodsSwordScript
	call interactionSetScript
	ld a,$4d
	call playSound
	ldbc INTERAC_SPARKLE $04
	jp objectCreateInteraction
@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret
