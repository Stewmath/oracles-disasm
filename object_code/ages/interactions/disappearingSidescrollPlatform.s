; ==================================================================================================
; INTERAC_DISAPPEARING_SIDESCROLL_PLATFORM
; ==================================================================================================
interactionCodea3:
	ld e,Interaction.state
	ld a,(de)
	cp $03
	jr z,++

	; Only do this if the platform isn't invisible
	call sidescrollPlatform_checkLinkOnPlatform
	call sidescrollingPlatformCommon
++
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@subidData
	rst_addDoubleIndex

	ld e,Interaction.state
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.counter1
	ld a,(hl)
	ld (de),a

	ld e,Interaction.collisionRadiusY
	ld a,$08
	ld (de),a
	inc e
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jp z,objectSetVisible83
	ret

@subidData:
	.db $04,  60
	.db $03, 120
	.db $01,  60

@state1:
	call sidescrollPlatform_decCounter1
	ret nz
	ld (hl),30
	ld l,e
	inc (hl)
	xor a
	ret

@state2:
	call sidescrollPlatform_decCounter1
	jr nz,@flickerVisibility
	ld (hl),150
	ld l,e
	inc (hl)
	jp objectSetInvisible

@flickerVisibility
	ld e,Interaction.visible
	ld a,(de)
	xor $80
	ld (de),a
	ret

@state3:
	call @state1
	ret nz
	ld a,SND_MYSTERY_SEED
	jp playSound

@state4:
	call sidescrollPlatform_decCounter1
	jr nz,@flickerVisibility
	ld (hl),120
	ld l,e
	ld (hl),$01
	jp objectSetVisible83
