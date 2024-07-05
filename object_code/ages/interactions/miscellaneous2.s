; ==================================================================================================
; INTERAC_MISCELLANEOUS_2
; ==================================================================================================
interactionCodedc:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interactiondc_subid00
	.dw interactiondc_subid01
	.dw interactiondc_subid02
	.dw interactiondc_subid03
	.dw interactiondc_subid04
	.dw interactiondc_subid05
	.dw interactiondc_subid06
	.dw interactiondc_subid07
	.dw interactiondc_subid08
	.dw interactiondc_subid09
	.dw interactiondc_subid0A
	.dw interactiondc_subid0B
	.dw interactiondc_subid0C
	.dw interactiondc_subid0D
	.dw interactiondc_subid0E
	.dw interactiondc_subid0F
	.dw interactiondc_subid10
	.dw interactiondc_subid11
	.dw interactiondc_subid12
	.dw interactiondc_subid13
	.dw interactiondc_subid14
	.dw interactiondc_subid15
	.dw interactiondc_subid16
	.dw interactiondc_subid17


; Heart piece spawner
interactiondc_subid07:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete
	ld bc,TREASURE_OBJECT_HEART_PIECE_00
	call createTreasure
	call objectCopyPosition
	jp interactionDelete


; Replaces a tile at a position with a given value when destroyed
interactiondc_subid08:
	call checkInteractionState
	jr z,@state0

@state1:
	ld e,Interaction.yh
	ld a,(de)
	ld c,a

	ld b,>wRoomLayout
	ld a,(bc)
	ld l,a
	ld e,Interaction.var03
	ld a,(de)
	cp l
	ret z

	call getThisRoomFlags
	ld e,Interaction.xh
	ld a,(de)
	or (hl)
	ld (hl),a
	jp interactionDelete

@state0:
	call getThisRoomFlags
	ld e,Interaction.xh
	ld a,(de)
	and (hl)
	jp nz,interactionDelete

	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	ld e,Interaction.var03
	ld (de),a
	jp interactionIncState


; Graveyard key spawner
interactiondc_subid00:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete
	ld a,(wNumTorchesLit)
	cp $02
	ret nz
	ld bc,TREASURE_OBJECT_GRAVEYARD_KEY_00
	call createTreasure
	call objectCopyPosition
	jp interactionDelete


; Graveyard gate opening cutscene
interactiondc_subid01:
	call checkInteractionState
	jp nz,interactionRunScript
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete
	ld hl,mainScripts.interactiondcSubid01Script
	call interactionSetScript
	call interactionSetAlwaysUpdateBit
	jp interactionIncState


; Initiates cutscene where present d2 collapses
interactiondc_subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionDeleteAndRetIfEnabled02
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete

	ld a,d
	ld (wDiggingUpEnemiesForbidden),a

	call objectGetTileAtPosition
	cp TILEINDEX_OVERWORLD_STANDARD_GROUND
	ret nz

	ld c,l
	ld a,TILEINDEX_OVERWORLD_DUG_DIRT
	call setTile
	jp interactionIncState

@state1:
	ld a,(wLinkGrabState)
	cp $83
	ret nz

	ld a,DIR_RIGHT
	ld (w1Link.direction),a

	ld e,Interaction.counter1
	ld a,30
	ld (de),a

	call checkLinkCollisionsEnabled
	ret nc

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call resetLinkInvincibility
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp interactionIncState

; Screen shaking just before present collapse
@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),60 ; [counter1]
	ld a,60
	ld bc,$f800
	call objectCreateExclamationMark
	call clearAllParentItems
	call dropLinkHeldItem
	jp interactionIncSubstate

@substate1:
	ld a,$28
	call setScreenShakeCounter
	call interactionDecCounter1
	ret nz
	ld a,CUTSCENE_D2_COLLAPSE
	ld (wCutsceneTrigger),a
	jp interactionDelete


; Reveals portal spot under bush in symmetry (left side)
interactiondc_subid03:
	call checkInteractionState
	jr nz,interactiondc_subid3And4_state1

@state0:
	call getThisRoomFlags
	and $02
	jp nz,interactionDelete
	ld e,Interaction.var03
	ld a,$02
	ld (de),a
	jp interactionIncState

interactiondc_subid3And4_state1:
	call objectGetTileAtPosition
	cp TILEINDEX_OVERWORLD_STANDARD_GROUND
	ret nz
	ld a,TILEINDEX_PORTAL_SPOT
	ld c,l
	call setTile

	call getThisRoomFlags
	ld e,Interaction.var03
	ld a,(de)
	or (hl)
	ld (hl),a

	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete


; Reveals portal spot under bush in symmetry (right side)
interactiondc_subid04:
	call checkInteractionState
	jr nz,interactiondc_subid3And4_state1

@state0:
	call getThisRoomFlags
	and $04
	jp nz,interactionDelete
	ld e,Interaction.var03
	ld a,$04
	ld (de),a
	jp interactionIncState


; Makes screen shake before tuni nut is restored
interactiondc_subid05:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,GLOBALFLAG_TUNI_NUT_PLACED
	call checkGlobalFlag
	jp nz,interactionDelete

	call returnIfScrollMode01Unset

	ld a,SNDCTRL_STOPSFX
	call playSound

	ld a,$01
	ld (wScreenShakeMagnitude),a

	call @setRandomShakeDuration
	ld a,(wFrameCounter)
	rrca
	call c,interactionIncState
	jp interactionIncState

@state1:
	xor a
	call @shakeScreen
	ret nz
	call @setRandomShakeDuration
	jp interactionIncState

@state2:
	ld a,(wFrameCounter)
	and $0f
	ld a,SND_RUMBLE
	call z,playSound
	ld a,$08
	call @shakeScreen
	ret nz
	ld l,Interaction.state
	ld (hl),$01

@setRandomShakeDuration:
	call getRandomNumber
	and $7f
	sub $40
	add $60
	ld e,Interaction.counter1
	ld (de),a
	ret

@shakeScreen:
	call setScreenShakeCounter
	ld a,(wFrameCounter)
	rrca
	ret c
	jp interactionDecCounter1


; Makes volcanoes erupt before tuni nut is restored (spawns INTERAC_VOLCANO_HANLDER)
interactiondc_subid06:
	ld a,GLOBALFLAG_TUNI_NUT_PLACED
	call checkGlobalFlag
	jr nz,@delete
	ldbc INTERAC_VOLCANO_HANDLER,$01
	call objectCreateInteraction
@delete:
	jp interactionDelete


; Animates jabu-jabu
interactiondc_subid09:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionIncState
	.dw @state1
	.dw @state2
	.dw @state3

@state1:
	ld a,(wMenuDisabled)
	or a
	ret nz

	ld a,(wFrameCounter)
	and $07
	ret nz
	call getRandomNumber_noPreserveVars
	and $07
	ret nz

	ld e,Interaction.substate
	xor a
	ld (de),a
	ldh a,(<hRng2)
	rrca
	call c,interactionIncState
	jp interactionIncState

@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state2Substate0
	.dw @state2Substate1
	.dw @returnToState1

@state2Substate0:
	ld e,Interaction.counter1
	ld a,$08
	ld (de),a
	ld hl,@tiles0

@replaceTileListAndIncSubstateA:
	call @replaceTileList
	jp interactionIncSubstate

@state2Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld hl,@tiles1
	jr @replaceTileListAndIncSubstateA

@returnToState1:
	call interactionDecCounter1
	ret nz
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret

@state3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state3Substate0
	.dw @state3Substate1
	.dw @state3Substate2
	.dw @returnToState1

@state3Substate0:
	ld e,Interaction.counter1
	ld a,$0c
	ld (de),a
	ld hl,@tiles2

@replaceTileListAndIncSubstateB:
	call @replaceTileList
	jp interactionIncSubstate

@state3Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),$0c
	ld hl,@tiles3
	jr @replaceTileListAndIncSubstateB

@state3Substate2:
	call interactionDecCounter1
	ret nz
	ld (hl),$0c
	ld hl,@tiles4
	jr @replaceTileListAndIncSubstateB

;;
; @param	hl	List of tile postiion/value pairs to set
@replaceTileList:
	ldi a,(hl)
	or a
	ret z
	ld c,a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	jr @replaceTileList

@tiles0:
	.db $24 $87
	.db $25 $88
	.db $34 $97
	.db $35 $98
	.db $00

@tiles1:
	.db $24 $9b
	.db $25 $9c
	.db $34 $ab
	.db $35 $ac
	.db $00

@tiles2:
	.db $22 $0e
	.db $23 $0f
	.db $32 $1e
	.db $33 $1f
	.db $26 $4e
	.db $27 $4f
	.db $36 $5e
	.db $37 $5f
	.db $00

@tiles3:
	.db $22 $2e
	.db $23 $2f
	.db $32 $3e
	.db $33 $3f
	.db $26 $6e
	.db $27 $6f
	.db $36 $7e
	.db $37 $7f
	.db $00

@tiles4:
	.db $22 $99
	.db $23 $9a
	.db $32 $a9
	.db $33 $aa
	.db $26 $9d
	.db $27 $9e
	.db $36 $ad
	.db $37 $ae
	.db $00


; Initiates jabu opening his mouth cutscene
interactiondc_subid0A:
	call checkInteractionState
	jr z,@state0

@state1:
	ld a,GLOBALFLAG_GOT_PERMISSION_TO_ENTER_JABU
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,DISABLE_ALL_BUT_INTERACTIONS|DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	xor a
	ld (w1Link.direction),a
	ld a,CUTSCENE_JABU_OPEN
	ld (wCutsceneTrigger),a
	jp interactionDelete

@state0:
	call getThisRoomFlags
	and $02
	jp nz,interactionDelete
	jp interactionIncState


; Handles floor falling in King Moblin's castle
interactiondc_subid0B:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a
	ld a,$18
	call objectSetCollideRadius
	ld hl,@listOfTilesToBreak
	jp interactionSetMiniScript

@state1:
	call objectCheckCollidedWithLink_ignoreZ
	ret nc
	call checkLinkCollisionsEnabled
	ret nc

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a

	ld a,SND_CLINK
	call playSound

	ld hl,w1Link
	call objectTakePosition

	ld e,Interaction.counter1
	ld a,30
	ld (de),a

	ld bc,$f808
	call objectCreateExclamationMark
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz
	ld (hl),30 ; [counter1]
	xor a
	ld (wDisabledObjects),a
	jp interactionIncState

@state3:
	call interactionDecCounter1
	ret nz
	ld (hl),$07 ; [counter1]

	call interactionGetMiniScript
	ldi a,(hl)
	ld c,a
	call interactionSetMiniScript
	ld a,c
	or a
	jp z,interactionDelete

	ld a,TILEINDEX_WARP_HOLE
	jp breakCrackedFloor

@listOfTilesToBreak:
	.db $67 $66 $65 $64 $63 $62 $61 $51
	.db $41 $31 $21 $11 $12 $13 $23 $33
	.db $43 $44 $45 $46 $47 $48 $38 $28
	.db $18 $17 $16 $00


; Bridge handler in Rolling Ridge past (subid 0c) and present (subid 0d)
interactiondc_subid0C:
interactiondc_subid0D:
	call checkInteractionState
	jr z,@state0

@state1:
	ld a,(wActiveTriggers)
	or a
	ret z

	ld e,Interaction.subid
	ld a,(de)
	sub $0c
	ld bc,$0801
	ld e,$56
	jr z,++
	ld bc,$0603
	ld e,$28
++
	call getFreePartSlot
	ret nz
	ld (hl),PART_BRIDGE_SPAWNER
	ld l,Part.counter2
	ld (hl),b
	ld l,Part.angle
	ld (hl),c
	ld l,Part.yh
	ld (hl),e

	call getThisRoomFlags
	set 7,(hl)

	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete

@state0:
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete
	jp interactionIncState


; Puzzle at entrance to sea of no return (ancient tomb)
interactiondc_subid0E:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete
	jp interactionIncState

@state1:
	call objectGetTileAtPosition
	cp TILEINDEX_GRAVE_STATIONARY
	ret nz
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld e,Interaction.counter1
	ld a,45
	ld (de),a

	call interactionIncState

	ld c,$04
	ld a,$30
	call setTile
	inc c
	ld a,$32
	call setTile
	ld c,$14
	ld a,$3a
	call setTile
	inc c
	ld a,$3a
	call setTile

	ld c,$04
	call @spawnPuff
	ld c,$05
	call @spawnPuff
	ld c,$14
	call @spawnPuff
	ld c,$15

@spawnPuff:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUFF
	ld l,Interaction.yh
	jp setShortPosition_paramC

@state2:
	call interactionDecCounter1
	ret nz
	ld a,SND_SOLVEPUZZLE
	call playSound
	call getThisRoomFlags
	set 7,(hl)
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete


; Shows text upon entering a room (only used for sea of no return entrance and black tower turret)
interactiondc_subid0F:
	call checkInteractionState
	jr z,@state0
	call objectCheckCollidedWithLink_notDead
	ret nc

	ld bc,TX_120a
	ld a,(wActiveRoom)
	cp $d0
	jr nz,@showText
	ld bc,TX_0209
@showText:
	call showText
	jp interactionDelete

@state0:
	ld a,(wScrollMode)
	and $02
	jp z,interactionDelete
	ld a,(w1Link.yh)
	cp $78
	jp c,interactionDelete
	ld a,$08
	call objectSetCollideRadius
	jp interactionIncState


; Black tower entrance handler: warps Link to different variants of black tower.
interactiondc_subid10:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld hl,wRoomLayout+$44
	xor a
	ldi (hl),a
	ld (hl),a

	ld bc,$0410
	call objectSetCollideRadii

	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	call nc,interactionIncState
	jp interactionIncState

@state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret c
	jp interactionIncState

@state2:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	call checkLinkVulnerable
	ret nc

	call getThisRoomFlags
	and $01
	ld hl,@warp1
	jr z,+
	ld hl,@warp2
+
	call setWarpDestVariables
	ld a,SND_ENTERCAVE
	call playSound
	jp interactionDelete

@warp1:
	m_HardcodedWarpA ROOM_AGES_4e7, $93, $ff, $01

@warp2:
	m_HardcodedWarpA ROOM_AGES_4f3, $93, $ff, $01


; Gives D6 Past boss key when you get D6 Present boss key
interactiondc_subid11:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ret z
	ld hl,wDungeonBossKeys
	ld a,$0c
	jp setFlag


; Bridge handler for cave leading to Tingle
interactiondc_subid12:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete

	ld a,(wToggleBlocksState)
	or a
	ret z

	call getFreePartSlot
	ret nz
	ld (hl),PART_BRIDGE_SPAWNER
	ld l,Part.counter2
	ld (hl),$0c
	ld l,Part.angle
	ld (hl),$01
	ld l,Part.yh
	ld (hl),$13

	call getThisRoomFlags
	set 6,(hl)

	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete


; Makes lava-waterfall an d4 entrance behave like lava instead of just a wall, so that the fireballs
; "sink" into it instead of exploding like on land.
interactiondc_subid13:
	call returnIfScrollMode01Unset
	ld a,TILEINDEX_OVERWORLD_LAVA_1 ; TODO
	ld hl,wRoomLayout+$14
	ldi (hl),a
	ld (hl),a
	ld l,$24
	ldi (hl),a
	ld (hl),a
	ld l,$34
	ldi (hl),a
	ld (hl),a
	jp interactionDelete


; Spawns portal to final dungeon from maku tree
interactiondc_subid14:
	call objectGetTileAtPosition
	cp $dc ; TODO
	jr nz,@delete
	ld b,INTERAC_DECORATION
	call objectCreateInteractionWithSubid00
@delete:
	jp interactionDelete



; Sets present sea of storms chest contents (changes if linked)
interactiondc_subid15:
	call checkInteractionState
	jr z,interactiondc_subid15And16_state0

@state1:
	call checkIsLinkedGame
	ld a,$01
	jr nz,interactiondc_subid15And16_setChestContents
	dec a

interactiondc_subid15And16_setChestContents:
	ld hl,@chestContents
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wChestContentsOverride),a
	ld a,(hl)
	ld (wChestContentsOverride+1),a
	jp interactionDelete

@chestContents:
	dwbe TREASURE_OBJECT_GASHA_SEED_01 ; Unlinked
	dwbe TREASURE_OBJECT_RING_1e       ; Linked

interactiondc_subid15And16_state0:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete
	jp interactionIncState


; Sets past sea of storms chest contents (changes if linked)
interactiondc_subid16:
	call checkInteractionState
	jr z,interactiondc_subid15And16_state0
	call checkIsLinkedGame
	ld a,$00
	jr nz,interactiondc_subid15And16_setChestContents
	inc a
	jr interactiondc_subid15And16_setChestContents


; Forces Link to be squished when he's in a wall (used in ages d5 BK room)
interactiondc_subid17:
	call checkInteractionState
	jp z,interactionIncState

@state1:
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	callab bank5.checkPositionSurroundedByWalls
	rl b
	ret nc

	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz

	ld hl,wLinkForceState
	ld a,(hl)
	or a
	ret nz

	ld a,LINK_STATE_SQUISHED
	ldi (hl),a
	ld a,(wBlockPushAngle)
	and $08
	xor $08
	ld (hl),a ; [wcc50]
	ret
