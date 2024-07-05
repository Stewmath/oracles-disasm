; ==================================================================================================
; INTERAC_LINKED_HEROS_CAVE_OLD_MAN
; ==================================================================================================
interactionCodee4:
	call checkInteractionState
	jr z,+
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate
+
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisible82
	ld a,>TX_3300
	call interactionSetHighTextIndex
	ld hl,mainScripts.linkedHerosCaveOldManScript
	jp interactionSetScript

linkedHerosCaveOldMan_spawnChests:
	ld a,$01
	ld (wcca1),a
	dec a
	ld (wcca2),a
	ld b,$08
-
	call func_6f39
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_PUFF
	ld l,$4b
	call setShortPosition_paramC
+
	push bc
	ld a,TILEINDEX_CHEST
	call setTile
	pop bc
	dec b
	jr nz,-
	ret

func_6f39:
	ld a,b
	dec a
	ld hl,table_6f41
	rst_addAToHl
	ld c,(hl)
	ret

table_6f41:
	.db $23 $35 $3b $43
	.db $59 $5b $66 $73

linkedHerosCaveOldMan_takeRupees:
	xor a
	ld ($cfd0),a
	ld a,RUPEEVAL_060
	call cpRupeeValue
	ret nz
	ld a,RUPEEVAL_060
	call removeRupeeValue
	ld a,$01
	ld ($cfd0),a
	ret
