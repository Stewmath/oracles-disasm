; ==================================================================================================
; INTERAC_SUBROSIAN_AT_VOLCANO_ITEMS
; ==================================================================================================
interactionCode54:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw objectSetVisible82
@state0:
	ld a,$01
	ld (de),a
	call getRandomNumber
	and $0f
	ld hl,@table_7c0a
	rst_addAToHl
	ld a,(hl)
	ld e,$42
	ld (de),a
	ld bc,$fe40
	call objectSetSpeedZ
	ld l,$50
	ld (hl),$28
	ld l,$49
	ld (hl),$08
	call interactionInitGraphics
	jp objectSetVisiblec1
@table_7c0a:
	.db $0d ; Gasha seed
	.db $0e ; Ring
	.db $10 ; Lvl 1 Sword
	.db $3a ; Heart piece
	.db $40 ; Treasure map
	.db $54 ; Banana
	.db $76 ; Fish
	.db $57 ; Star ore
	.db $1b ; Shovel
	.db $5d ; Blaino's gloves
	.db $43 ; Big key
	.db $03 ; 1 ore chunk
	.db $31 ; Flippers
	.db $13 ; Lvl 1 shield
	.db $2e ; 200 rupees
	.db $23 ; Flute
@state1:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld e,$44
	ld a,$02
	ld (de),a
	jp objectReplaceWithAnimationIfOnHazard
