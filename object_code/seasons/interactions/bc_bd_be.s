; ==================================================================================================
; INTERAC_bc
; INTERAC_bd
; INTERAC_be
; ==================================================================================================
interactionCodebc:
interactionCodebd:
interactionCodebe:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw interactionCodebb@subid0
	.dw @subid1
	.dw @subid2
	.dw interactionCodebb@subid2
	.dw @subid4
@subid1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @runScriptAnimateAsNPC
@@state0:
	call func_7867
	ld e,$41
	ld a,(de)
	cp $bd
	jr nz,@runScriptAnimateAsNPC
	ld a,$01
	ld e,$7b
	ld (de),a
	call interactionSetAnimation
@runScriptAnimateAsNPC:
	call interactionRunScript
	jp interactionAnimateAsNpc
@subid2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @runScriptAnimateAsNPC
@@state0:
	call func_7867
	ld a,$02
	ld e,$7b
	ld (de),a
	call interactionSetAnimation
	jr @runScriptAnimateAsNPC
@subid4:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call checkIsLinkedGame
	jp z,interactionDelete
	call func_78ce
	ld e,$78
	ld a,(de)
	or a
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld l,$7e
	ld (hl),$02
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
@@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
	
decVar3c:
	ld h,d
	ld l,$7c
	dec (hl)
	ret

func_7867:
	call interactionInitGraphics
	ld e,$41
	ld a,(de)
	sub $ba
	ld hl,ba_to_beScripts
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call objectSetVisible81
	jp interactionIncState
	
func_7886:
	ld e,$7d
	ld a,(de)
	or a
	ret nz
	jp interactionAnimate

func_788e:
	ld e,$41
	ld a,(de)
	sub $ba
	ld hl,table_78a9
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$7c
	ld (de),a
	ld a,(hl)
	ld e,$49
	ld (de),a
	add $04
	and $18
	swap a
	rlca
	jp interactionSetAnimation

table_78a9:
	.db $50 $1e
	.db $01 $02
	.db $3c $16
	.db $28 $1c
	.db $78 $18

func_78b3:
	call getFreeInteractionSlot ; $78b3
	ret nz
	ld (hl),INTERAC_D1_RISING_STONES
	inc l
	ld (hl),$02
	ld l,$46
	ld (hl),$78
	jp objectCopyPosition

func_78c3:
	call getFreePartSlot
	ret nz
	ld (hl),PART_LIGHTNING
	inc l
	inc (hl)
	jp objectCopyPosition

func_78ce:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,+
	xor a
+
	ld h,d
	ld l,$78
	cp $07
	ld (hl),$00
	ret c
	ld (hl),$01
	ret
	
ba_to_beScripts:
	.dw baScripts
	.dw bbScripts
	.dw bcScripts
	.dw bdScripts
	.dw beScripts
baScripts:
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_ba_subid1
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_ba_subid3
bbScripts:
	.dw mainScripts.zeldaNPCScript_stub
bcScripts:
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_bc_subid1
	.dw mainScripts.zeldaNPCScript_bc_subid2
bdScripts:
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_bd_subid1
	.dw mainScripts.zeldaNPCScript_bd_subid2
beScripts:
	.dw mainScripts.zeldaNPCScript_stub
	.dw mainScripts.zeldaNPCScript_be_subid1
	.dw mainScripts.zeldaNPCScript_be_subid2
