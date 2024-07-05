; ==================================================================================================
; INTERAC_INGO
; ==================================================================================================
interactionCode57:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
--
	ld h,d
	ld l,$44
	ld (hl),$01
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,mainScripts.ingoScript_tradingVase
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
	jp @preventLinkFromPassing
@state1:
	call @func_7d5a
	call interactionRunScript
	jp npcFaceLinkAndAnimate
@state2:
	call interactionRunScript
	jr c,--
	jr @func7d84
@func_7d5a:
	ld a,($d00b)
	sub $20
	ret nc
	ld a,$22
	ld ($d00b),a
	ld a,($cc77)
	or a
	ret nz
	ld a,$80
	ld ($cca4),a
	ld a,$01
	ld ($cc02),a
	ld hl,mainScripts.ingoScript_LinkApproachingVases
	call interactionSetScript
	ld h,d
	ld l,$44
	ld (hl),$02
	inc l
	ld (hl),$00
	pop bc
	ret
@func7d84:
	call interactionAnimate
	ld e,$7e
	ld a,(de)
	or a
	jr z,@preventLinkFromPassing
	ld e,$60
	ld a,(de)
	cp $0d
	jr nz,@preventLinkFromPassing
	ld e,$60
	ld a,$01
	ld (de),a
@preventLinkFromPassing:
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
