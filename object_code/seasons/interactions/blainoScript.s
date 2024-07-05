; ==================================================================================================
; INTERAC_BLAINO_SCRIPT
; ==================================================================================================
interactionCode5a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw interactionRunScript

@state0:
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld a,>TX_2300
	call interactionSetHighTextIndex
	ld hl,mainScripts.blainoScript
	call interactionSetScript

@state1:
	call interactionRunScript
	ret nc
	ld h,d
	ld l,Interaction.enabled
	ld (hl),$01
	ld l,Interaction.state
	ld (hl),$02
	ld a,$02
	ld ($cced),a
	xor a
	ld ($ccec),a
	inc a
	ld (wInBoxingMatch),a
	ret

@state2:
	call @checkFightDone
	ret z
	call restartSound
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.state
	ld (hl),$03
	ld a,$03
	ld ($cced),a
	xor a
	ld (wLinkPlayingInstrument),a
	call resetLinkInvincibility
	xor a
	ld (wInBoxingMatch),a
	ld hl,mainScripts.blainoFightDoneScript
	call interactionSetScript
	jp interactionRunScript

@checkFightDone:
	ld hl,wInventoryB
	ld a,(wLinkPlayingInstrument)
	or (hl)
	inc l
	or (hl)
	ld a,$03
	; equipped items (cheated)
	jr nz,+
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call @checkOutsideRing
	; won
	ld a,$01
	jr nc,+
	ld hl,w1Link.yh
	call @checkOutsideRing
	; lost
	ld a,$02
	jr nc,+
	xor a
+
	ld ($ccec),a
	or a
	ret

@checkOutsideRing:
	ldi a,(hl)
	sub $16
	cp $4c
	ret nc
	inc l
	ld a,(hl)
	sub $22
	cp $5c
	ret
