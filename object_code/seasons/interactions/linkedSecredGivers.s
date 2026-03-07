; ==================================================================================================
; INTERAC_LINKED_SECRET_GIVERS
; ==================================================================================================
interactionCodedb:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call checkIsLinkedGame
	jp z,interactionDelete

	call @func_662f
	jp z,interactionDelete
	ld e,$42
	ld a,(de)
	ld hl,@table_662c
	rst_addAToHl
	ld a,(hl)
	ld e,$7e
	ld (de),a
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionInitGraphics
	jp objectSetVisiblec2
@table_662c:
	.db GLOBALFLAG_BEGAN_TOKAY_SECRET - GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	.db GLOBALFLAG_BEGAN_MAMAMU_SECRET - GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	.db GLOBALFLAG_BEGAN_SYMMETRY_SECRET - GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
@func_662f:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld a,GLOBALFLAG_S_2d
	call checkGlobalFlag
	ret
@subid1:
	ld a,>ROOM_SEASONS_081
	ld b,<ROOM_SEASONS_081
	call getRoomFlags
	bit 7,a
	ret
@subid2:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,+
	call getHighestSetBit
	cp $01
	jr c,+
	or $01
	ret
+
	xor a
	ret
@state1:
	call interactionRunScript
	ld e,$42
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	jp interactionAnimateAsNpc
