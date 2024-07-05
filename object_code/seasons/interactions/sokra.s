; ==================================================================================================
; INTERAC_SOKRA
; ==================================================================================================
interactionCode27:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,>TX_5200
	call interactionSetHighTextIndex
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
@@runScriptSetVisible:
	call interactionRunScript
	call interactionRunScript
	jp objectSetVisiblec2
@@subid0:
	ld a,(wObtainedSeasons)
	and $02
	jr nz,+
	ld a,<ROOM_SEASONS_071
	call getARoomFlags
	bit 6,a
	jp nz,interactionDelete
+
	ld hl,mainScripts.sokraScript_inVillage
	call interactionSetScript
	jr @@runScriptSetVisible
@@subid1:
	ld a,(wObtainedSeasons)
	and $08
	jr z,+
	call getThisRoomFlags
	bit 6,a
	jr nz,+
	ld hl,mainScripts.sokraScript_easternSuburbsPortal
	call interactionSetScript
	jr @@runScriptSetVisible
+
	ld hl,objectData.objectData7e4a
	call parseGivenObjectData
	jp interactionDelete
@@subid2:
	call getThisRoomFlags
	ld a,(wObtainedSeasons)
	and $02
	jr z,+
	res 6,(hl)
	jp interactionDelete
+
	set 6,(hl)
	ld hl,mainScripts.sokraScript_needSummerForD3
	call interactionSetScript
	jr @@runScriptSetVisible
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
@@subid0:
	call interactionRunScript
	call interactionAnimateAsNpc
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	ret nc
	call getThisRoomFlags
	bit 6,(hl)
	jr z,+
	ld e,$43
	ld a,(de)
	or a
	jr nz,++
	ret
+
	ld a,($d00d)
	cp $78
	ret c
	ld a,($d00b)
	cp $3c
	ret c
	cp $60
	ret nc
@@func_5bae:
	ld e,$77
	ld a,$01
	ld (de),a
	ret
++
	ld a,(wFrameCounter)
	and $3f
	ret nz
	ld b,$f4
	ld c,$fa
	jp objectCreateFloatingMusicNote
@@subid1:
	call interactionAnimateAsNpc
	call interactionRunScript
	jp c,interactionDelete
	call checkInteractionSubstate
	ret nz
	ld a,($d00d)
	cp $18
	ret c
	call interactionIncSubstate
	call @@func_5bae
	jp beginJump
@@subid2:
	ld a,(wDisabledObjects)
	and $01
	call z,createSokraSnore
	call interactionAnimateAsNpc
	jp interactionRunScript
