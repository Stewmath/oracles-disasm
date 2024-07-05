; ==================================================================================================
; INTERAC_SEASON_SPIRITS_SCRIPTS
; ==================================================================================================
interactionCode23:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	ld a,$01
	ld (de),a
	ld a,>TX_0800
	call interactionSetHighTextIndex
	ld e,$42
	ld a,(de)
	ld b,a
	swap a
	and $0f
	ld e,$43
	ld (de),a
	ld hl,table_56a5
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,b
	and $0f
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$7e
	ld a,(wc6e5)
	cp $09
	ld a,$00
	jr c,+
	inc a
+
	ld (de),a
@substate1:
	call interactionRunScript
	jp c,interactionDelete
	ret

table_56a5:
	.dw table_56af
	.dw table_56af
	.dw table_56af
	.dw table_56af
	.dw table_56b3

table_56af:
	.dw mainScripts.seasonsSpiritsScript_winterTempleOrbBridge
	.dw mainScripts.seasonsSpiritsScript_spiritStatue

table_56b3:
	.dw mainScripts.seasonsSpiritsScript_enteringTempleArea
