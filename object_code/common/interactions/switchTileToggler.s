; ==================================================================================================
; INTERAC_SWITCH_TILE_TOGGLER
; ==================================================================================================
interactionCode78:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld a,(wSwitchState)
	ld e,Interaction.var03
	ld (de),a

@state1:
	ld a,(wSwitchState)
	ld b,a
	ld e,Interaction.var03
	ld a,(de)
	cp b
	ret z

	ld a,b
	ld (de),a
	ld e,Interaction.xh
	ld a,(de)
	ld hl,@tileReplacement
	rst_addDoubleIndex
	ld e,Interaction.subid
	ld a,(de)
	and b
	jr z,+
	inc hl
+
	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld a,(hl)
	jp setTile

; Index for this table is "Interaction.xh". Determines what tiles will appear when
; a switch is on or off.
;   b0: tile index when switch not pressed
;   b1: tile index when switch pressed
@tileReplacement:
	.db $5d $59 ; $00
	.db $5d $5a ; $01
	.db $5d $5b ; $02
	.db $5d $5c ; $03
	.db $5e $59 ; $04
	.db $5e $5a ; $05
	.db $5e $5b ; $06
	.db $5e $5c ; $07
	.db $59 $5d ; $08
	.db $5a $5d ; $09
	.db $5b $5d ; $0a
	.db $5c $5d ; $0b (patch's minecart game)
	.db $59 $5e ; $0c
	.db $5a $5e ; $0d
	.db $5b $5e ; $0e
	.db $5c $5e ; $0f
	.db $59 $5b ; $10
	.db $5a $5c ; $11
	.db $5b $59 ; $12
	.db $5c $5a ; $13
	.db $59 $5c ; $14
	.db $5a $5b ; $15
	.db $5b $5a ; $16
	.db $5c $59 ; $17
