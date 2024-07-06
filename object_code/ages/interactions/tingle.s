; ==================================================================================================
; INTERAC_TINGLE
;
; Variables:
;   var3d: Satchel level (minus one); used by script.
;   var3e: Nonzero if Link has 3 seed types or more
;   var3f: Signal for the script, set to 1 when his "kooloo-limpah" animation ends
; ==================================================================================================
interactionCodec8:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a ; [state]

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call objectSetVisiblec0
	ld a,>TX_1e00
	call interactionSetHighTextIndex
	ld a,$06
	call objectSetCollideRadius

	; Count number of seed types Link has
	ldbc TREASURE_EMBER_SEEDS, 00
@checkNextSeed:
	ld a,b
	call checkTreasureObtained
	ld a,$00
	rla
	add c
	ld c,a
	inc b
	ld a,b
	cp TREASURE_MYSTERY_SEEDS+1
	jr nz,@checkNextSeed

	ld a,c
	cp $03
	jr c,++
	ld e,Interaction.var3e
	ld (de),a
++
	call getFreePartSlot
	ret nz
	ld (hl),PART_TINGLE_BALLOON
	call objectCopyPosition
	ld l,Part.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d


; Tingle's balloon will change the state to 2 when it gets popped
@state1:
	ret


; Falling from the air
@state3:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jp nz,interactionDecCounter1

	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
	ld hl,mainScripts.tingleScript
	call interactionSetScript
	ld a,$04
	ld e,Interaction.state
	ld (de),a
	ld a,$01
	jr @setAnimation


; Balloon just popped
@state2:
	ld a,$03
	ld (de),a ; [state]
	ld a,15
	ld e,Interaction.counter1
	ld (de),a
	ld a,$02

@setAnimation:
	jp interactionSetAnimation


; On the ground
@state4:
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	ld e,Interaction.var3d
	dec a
	ld (de),a
	call interactionRunScript
	call interactionAnimateAsNpc
	ld e,Interaction.animParameter
	ld a,(de)
	rrca
	jr nc,@label_0b_330

	ld bc,-$200
	call objectSetSpeedZ

	ld bc,$e800
	call objectCreateSparkle
	ld l,Interaction.angle
	ld (hl),$10

	ld bc,$f008
	call objectCreateSparkle
	ld l,Interaction.angle
	ld (hl),$10

	ld bc,$f0f8
	call objectCreateSparkle
	ld l,Interaction.angle
	ld (hl),$10

@label_0b_330:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Interaction.animParameter
	ld a,(de)
	rlca
	ret nc

	xor a
	ld e,Interaction.var3f
	ld (de),a
	ld a,$01
	jr @setAnimation
