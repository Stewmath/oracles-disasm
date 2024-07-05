; ==================================================================================================
; INTERAC_HEAD_SMELTER
; ==================================================================================================
interactionCode53:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	ld e,$44
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,mainScripts.headSmelterAtTempleScript
	call interactionSetScript
	jp objectSetVisible82
@@state1:
	call interactionRunScript
	call objectPreventLinkFromPassing
	jp npcFaceLinkAndAnimate
@@state2:
	call interactionAnimate
	call interactionRunScript
	jp c,interactionDelete
	ret
@subid1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @subid0@state1
	.dw @subid0@state2
	.dw @@state3
@@state0:
	ld a,GLOBALFLAG_UNBLOCKED_AUTUMN_TEMPLE
	call checkGlobalFlag
	jp z,interactionDelete
	ld e,$44
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,mainScripts.headSmelterAtFurnaceScript
	call interactionSetScript
	jp objectSetVisible82
@@state3:
	xor a
	ld ($cfc0),a
	call interactionRunScript
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
@@@substate0:
@@@substate1:
	call interactionAnimate
	ld a,($cfc0)
	call getHighestSetBit
	ret nc
	cp $03
	jr nz,+
	ld e,$44
	ld a,$01
	ld (de),a
	ret
+
	ld b,a
	inc b
	ld h,d
	ld l,$45
	ld (hl),b
	ld l,$43
	ld (hl),$08
	add $04
	jp interactionSetAnimation
@@@substate2:
@@@substate3:
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jr z,+
	ld (hl),$00
	ld l,$4d
	add (hl)
	ld (hl),a
+
	ld l,$43
	dec (hl)
	ret nz
	ld l,$45
	ld (hl),$01
	ret
