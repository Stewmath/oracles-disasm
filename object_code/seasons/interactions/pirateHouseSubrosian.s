; ==================================================================================================
; INTERAC_PIRATE_HOUSE_SUBROSIAN
; ==================================================================================================
interactionCode42:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	ld b,$00
	jr nz,+
	inc b
+
	ld e,$42
	ld a,(de)
	cp b
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld l,$42
	ld a,(hl)
	ld hl,table_6d14
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

table_6d14:
	.dw mainScripts.pirateHouseSubrosianScript_piratesAround
	.dw mainScripts.pirateHouseSubrosianScript_piratesLeft
