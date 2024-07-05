; ==================================================================================================
; INTERAC_TRIGGER_TRANSLATOR
; ==================================================================================================
interactionCode24:
	call interactionDeleteAndRetIfEnabled02
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

; Subid 0: control a bit in wActiveTriggers based on wToggleBlocksState.
@subid0:
	ld a,(wToggleBlocksState)
	ld c,a

@label_08_081:
	ld e,Interaction.subid
	ld a,(de)
	swap a
	and $07
	ld hl,bitTable
	add l
	ld l,a

	ld a,c
	and (hl)
	ld b,a
	ld a,(hl)
	cpl
	ld c,a
	ld a,(wActiveTriggers)
	and c
	or b
	ld (wActiveTriggers),a
	ret

; Subid 1: control a bit in wActiveTriggers based on wSwitchState.
@subid1:
	ld a,(wSwitchState)
	ld c,a
	jr @label_08_081

; Subid 2: check that [wNumLitTorches] == Y.
@subid2:
	ld e,Interaction.yh
	ld a,(de)
	ld b,a
	ld e,Interaction.xh
	ld a,(de)
	ld c,a
	ld a,(wNumTorchesLit)
	cp b
	jr nz,++
	ld a,(wActiveTriggers)
	or c
	ld (wActiveTriggers),a
	ret
++
	ld a,c
	cpl
	ld c,a
	ld a,(wActiveTriggers)
	and c
	ld (wActiveTriggers),a
	ret
