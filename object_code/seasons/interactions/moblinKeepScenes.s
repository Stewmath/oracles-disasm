; ==================================================================================================
; INTERAC_MOBLIN_KEEP_SCENES
; ==================================================================================================
interactionCodeab:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,>TX_3f00
	call interactionSetHighTextIndex
	ld e,$42
	ld a,(de)
	ld hl,moblinKeepScene_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,(wLinkObjectIndex)
	cp $d0
	jr z,+
	ld a,($d10d)
	jr ++
+
	ld a,(w1Link.xh)
++
	cp $3d
	jp c,interactionDelete
	ld a,$00
	call moblinKeepScene_spawnKingMoblin
@subid1:
	jp @state1
@subid2:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,interactionDelete
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	call setDeathRespawnPoint
@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret

moblinKeepScene_setLinkDirectionAndPositionAfterDestroyed:
	ld a,LINK_STATE_08
	ld (wLinkForceState),a
	ld hl,w1Link.direction
	ld (hl),DIR_DOWN
	ld l,<w1Link.yh
	ld (hl),$18
	ld l,<w1Link.xh
	ld (hl),$48
	ret

moblinKeepScene_spawnKingMoblin:
	add a
	ld bc,@kingMoblinSpawnData
	call addDoubleIndexToBc
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_KING_MOBLIN
	inc l
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4d
	ld a,(bc)
	ld (hl),a
	ret

@kingMoblinSpawnData:
	; subid - yh - xh - unused
        .db $03 $60 $24 $00
        .db $04 $50 $48 $00

moblinKeepScene_spawn2MoblinsAfterKeepDestroyed:
	ld bc,@moblinSpawnData
	ld e,$02
--
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MOBLIN
	inc l
	ld (hl),$04
	inc l
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4d
	ld a,(bc)
	ld (hl),a
	inc bc
	inc bc
	dec e
	jr nz,--
	ret
@moblinSpawnData:
	; var03 - yh - xh
	.db $00 $56 $28 $00
	.db $01 $56 $68 $00

moblinKeepScene_scriptTable:
	.dw mainScripts.moblinKeepSceneScript_linkSeenOnRightSide
	.dw mainScripts.moblinKeepSceneScript_settingUpFight
	.dw mainScripts.moblinKeepSceneScript_postKeepDestruction
