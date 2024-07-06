; ==================================================================================================
; INTERAC_DUNGEON_STUFF
; ==================================================================================================
interactionCode12:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
.ifdef ROM_SEASONS
	.dw @subid05
.endif


; Show text upon entering a dungeon
@subid00:
	call checkInteractionState
	jr nz,@initialized

	; Delete self Link is not currently walking in from a whiteout transition
	ld a,(wScrollMode)
	and SCROLLMODE_02
	jp z,interactionDelete

	; Delete self if Link entered from the wrong side of the room
	ld a,(w1Link.yh)
	cp $78
	jp c,interactionDelete

	call interactionIncState
	ld a,$08
	call objectSetCollideRadius
	call initializeDungeonStuff
	ld a,(wDungeonIndex)
.ifdef ROM_AGES
	ld hl,@initialSpinnerValues
	rst_addAToHl
	ld a,(hl)
.else
	cp $07
	jr nz,+
	ld a,$05
	ld (wToggleBlocksState),a
+
	ld a,(wDungeonIndex)
	cp $08
	jr nz,@initialized
	ld a,$01
.endif
	ld (wSpinnerState),a

@initialized:
	call objectCheckCollidedWithLink_notDead
	ret nc

	ld a,(wDungeonIndex)
	ld hl,@dungeonTextIndices
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_0200
	call showText
	call setDeathRespawnPoint
	jp interactionDelete


; Text shown on entering a dungeon. One byte per dungeon.
@dungeonTextIndices:
	.ifdef ROM_AGES
		.db <TX_0200, <TX_0201, <TX_0202, <TX_0203, <TX_0204, <TX_0205, <TX_0206, <TX_0207
		.db <TX_0208, <TX_0209, <TX_020a, <TX_020b, <TX_020c, <TX_020d, <TX_020e, <TX_020f

	.else; ROM_SEASONS

		.db <TX_0200, <TX_0201, <TX_0202, <TX_0203, <TX_0204, <TX_0205, <TX_0206, <TX_0207
		.db <TX_0208, <TX_0209, <TX_020a, <TX_0200, <TX_0200, <TX_0200, <TX_0200, <TX_0200
	.endif


.ifdef ROM_AGES
; Initial values for wSpinnerState. A set bit means the corresponding spinner starts red.
; One byte per dungeon.
@initialSpinnerValues:
	.db $00 $00 $00 $00 $00 $00 $02 $00
	.db $01 $00 $00 $00 $01 $00 $00 $00
.endif


; A small key falls when [wNumEnemies]==0.
@subid01:
	call returnIfScrollMode01Unset
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @runScript

@@substate0:
	ld a,$01
	ld (de),a
	ld hl,mainScripts.dropSmallKeyWhenNoEnemiesScript
	call interactionSetScript

@runScript:
	call interactionRunScript
	jp c,interactionDelete
	ret


; Create a chest when all enemies are killed
@subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @runScript
	.dw @@substate2

@@substate0:
	ld a,$01
	ld (de),a
	ld hl,mainScripts.createChestWhenNoEnemiesScript
	call interactionSetScript
	jr @runScript

@@substate2:
	; In substate 2, the chest has appeared; so it calls
	; "objectPreventLinkFromPassing" to push Link away?
	call objectPreventLinkFromPassing
	jr @runScript


; Set bit 7 of room flags when all enemies are killed
@subid03:
	call checkInteractionState
	jr nz,@runScript

	ld a,$01
	ld (de),a
	ld hl,mainScripts.setRoomFlagBit7WhenNoEnemiesScript
	call interactionSetScript
	jr @runScript


; Create a staircase when all enemies are killed
@subid04:
	call returnIfScrollMode01Unset

	call getThisRoomFlags
	bit ROOMFLAG_BIT_KEYBLOCK,a
	jp nz,interactionDelete

	ld a,(wNumEnemies)
	or a
	ret nz

	ld a,SND_SOLVEPUZZLE
	call playSound

	call getThisRoomFlags
	set ROOMFLAG_BIT_KEYBLOCK,(hl)

	; Search for all tiles with indices between $40 and $43, inclusive, and replace
	; them with staircases.
	ld bc, wRoomLayout + LARGE_ROOM_HEIGHT*16 - 1
--
	ld a,(bc)
	sub $40
	cp $04
	call c,@createStaircaseTile
	dec c
	jr nz,--
	ret

@createStaircaseTile:
	push bc
	push hl
	ld hl,@replacementTiles
	rst_addAToHl
	ld a,(hl)
	call setTile
	call @createPuff
	pop hl
	pop bc
	ret

@replacementTiles:
	.db $46 $47 $44 $45

@createPuff:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUFF
	ld l,Interaction.yh
	jp setShortPosition_paramC

.ifdef ROM_SEASONS
@subid05:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible82
@@state1:
	ld hl,w1MagnetBall
	ld a,(hl)
	or a
	ret nz

	ld (hl),$01
	inc l
	ld (hl),ITEM_MAGNET_BALL
	call objectCopyPosition

	; copy relatedObj1 over
	ld e,Interaction.relatedObj1
	ld l,Object.relatedObj1
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a

	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ret
@@state2:
	jp interactionDelete
.endif
