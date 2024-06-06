 m_section_free Interaction_Code_Group1 NAMESPACE commonInteractions1

; ==============================================================================
; INTERACID_GRASSDEBRIS (and other animations)
; ==============================================================================

interactionCode00:
interactionCode01:
interactionCode02:
interactionCode03:
interactionCode04:
interactionCode05:
interactionCode06:
interactionCode07:
interactionCode08:
interactionCode09:
interactionCode0a:
interactionCode0b:
interactionCode0c:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_80

	ld l,Interaction.subid
	bit 1,(hl)
	call z,interactionSetAlwaysUpdateBit

	call @doSpecializedInitialization

	ld e,Interaction.id
	ld a,(de)
	ld hl,@soundAndPriorityTable
	rst_addDoubleIndex
	ld e,Interaction.subid
	ld a,(de)
	rlca
	ldi a,(hl)
	ld e,(hl)
	call nc,playSound
	ld a,e
	rst_jumpTable
	.dw objectSetVisible80
	.dw objectSetVisible81
	.dw objectSetVisible82
	.dw objectSetVisible83

@soundAndPriorityTable: ; $4037
	.db SND_CUTGRASS	$03	; 0x00
	.db SND_CUTGRASS	$03	; 0x01
	.db SND_NONE		$00	; 0x02
	.db SND_SPLASH		$03	; 0x03
	.db SND_SPLASH		$03	; 0x04
	.db SND_POOF		$00	; 0x05
	.db SND_BREAK_ROCK	$00	; 0x06
	.db SND_CLINK		$00	; 0x07
	.db SND_KILLENEMY	$00	; 0x08
	.db SND_NONE		$03	; 0x09
	.db SND_NONE		$03	; 0x0a
	.db SND_UNKNOWN5	$02	; 0x0b
	.db SND_BREAK_ROCK	$00	; 0x0c

@state1:
	ld h,d
	ld l,Interaction.animParameter
	bit 7,(hl)
	jp nz,interactionDelete

	ld l,Interaction.subid
	bit 0,(hl)
	jr z,++

	ld a,(wFrameCounter)
	xor d
	rrca
	ld l,Interaction.visible
	set 7,(hl)
	jr nc,++

	res 7,(hl)
++
	ld e,Interaction.id
	ld a,(de)
	cp INTERACID_SHOVELDEBRIS
	jr nz,+

	ld c,$60
	call objectUpdateSpeedZ_paramC
	call objectApplySpeed
+
	jp interactionAnimate

;;
; Does specific things for interactions 0 (underwater bush breaking) and $0a (shovel
; debris)
@doSpecializedInitialization:
	ld e,Interaction.id
	ld a,(de)
	or a
	jr z,@interac00

	cp INTERACID_SHOVELDEBRIS
	ret nz

@interac0A:
	ld bc,-$240
	call objectSetSpeedZ
	ld e,Interaction.direction
	ld a,(de)
	jp interactionSetAnimation

@interac00:
.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	jr z,+

	ld a,$0e
	jr ++
.endif
+
	ld a,(wGrassAnimationModifier)
	and $03
	or $08
++
	ld e,Interaction.oamFlagsBackup
	ld (de),a
	inc e
	ld (de),a
	ret


; ==============================================================================
; INTERACID_FALLDOWNHOLE
; ==============================================================================
interactionCode0f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @interac0f_state0
	.dw @interac0f_state1
	.dw @interac0f_state2

@interac0f_state0:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState

	; [state] += [subid]
	ld e,Interaction.subid
	ld a,(de)
	add (hl)
	ld (hl),a

	ld l,Interaction.speed
	ld (hl),SPEED_60
	dec a
	jr z,@fallDownHole

@dust:
	call interactionSetAnimation
	jp objectSetVisible80

@fallDownHole:
	inc e
	ld a,(de)
	rlca
	ld a,SND_FALLINHOLE
	call nc,playSound
.ifdef ROM_AGES
	call @checkUpdateHoleEvent
.endif
	jp objectSetVisible83


; State 1: "falling into hole" animation
@interac0f_state1:
	ld h,d
	ld l,Interaction.animParameter
	bit 7,(hl)
	jr nz,@delete

	; Calculate the direction this should move in to move towards the
	; center of the hole
	ld l,Interaction.yh
	ldi a,(hl)
	ldh (<hFF8F),a
	add $05
	and $f0
	add $08
	ld b,a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	and $f0
	add $08
	ld c,a
	cp (hl)
	jr nz,+

	ldh a,(<hFF8F)
	cp b
	jr z,@animate
+
	call objectGetRelativeAngleWithTempVars
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed

@animate:
	jp interactionAnimate


; State 2: pegasus seed dust?
@interac0f_state2:
	ld h,d
	ld l,Interaction.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ld l,Interaction.animParameter
	bit 7,(hl)
	jr z,@animate
@delete:
	jp interactionDelete


.ifdef ROM_AGES
;;
; Certain rooms have things happen when something falls into a hole; this writes something
; around $cfd8 to provide a signal?
@checkUpdateHoleEvent:
	ld a,(wActiveRoom)
	ld e,a
	ld hl,@specialHoleRooms
	call lookupKey
	ret nc

	ld b,a
	ld a,(wActiveGroup)
	cp b
	ret nz

	ld hl,wTmpcfc0.fallDownHoleEvent.cfd8
	ld b,$04
--
	ldi a,(hl)
	cp $ff
	jr nz,++

	; This contains the ID of the object that fell in the hole?
	ld e,Interaction.counter2
	ld a,(de)
	ldd (hl),a
	dec e
	ld a,(de)
	ld (hl),a
	ret
++
	inc l
	dec b
	jr nz,--
	ret

@specialHoleRooms:
	.dw ROOM_AGES_5e8 ; Patch's room
	.dw ROOM_AGES_23e ; Toilet room
	.db $00

;;
clearFallDownHoleEventBuffer:
	ld hl,wTmpcfc0.fallDownHoleEvent.cfd8
	ld b,_sizeof_wTmpcfc0.fallDownHoleEvent.cfd8
	ld a,$ff
	jp fillMemory
.endif


; ==============================================================================
; INTERACID_FARORE
; ==============================================================================
interactionCode10:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics

	ld a,>TX_5500
	call interactionSetHighTextIndex

	ld hl,mainScripts.faroreScript
	call interactionSetScript

	ld a,GLOBALFLAG_SECRET_CHEST_WAITING
	call unsetGlobalFlag

	ld a,TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	ld a,$02
	ld (wTextboxPosition),a

	jp objectSetVisible82

@state1:
	ld bc,$1406
	call objectSetCollideRadii
	call interactionRunScript
	jp interactionAnimate


.ifdef ROM_AGES
.include "object_code/common/interactionCode/faroreMakeChest.s"
.else
interactionCode11_caller:
	jpab bank3f.interactionCode11
.endif


; ==============================================================================
; INTERACID_DUNGEON_STUFF
; ==============================================================================
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
	ld (hl),INTERACID_PUFF
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
	ld (hl),ITEMID_MAGNET_BALL
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


; ==============================================================================
; INTERACID_PUSHBLOCK_TRIGGER
; ==============================================================================
interactionCode13:
	call interactionDeleteAndRetIfEnabled02
	call returnIfScrollMode01Unset
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,Interaction.state
	ld (hl),$01

	call objectGetShortPosition
	ld l,Interaction.var18
	ld (hl),a

	; Replace the block at this position with TILEINDEX_PUSHABLE_BLOCK; save the old
	; value for the tile there into var19.
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	inc l
	ld (hl),a ; [var19] = tile at position
	ld a,TILEINDEX_PUSHABLE_BLOCK
	ld (bc),a

	ld hl,wNumEnemies
	inc (hl)
	ret

; Waiting for wNumEnemies to equal subid
@state1:
	ld a,(wNumEnemies)
	ld b,a
	ld e,Interaction.subid
	ld a,(de)
	cp b
	ret c

	ld e,Interaction.state
	ld a,$02
	ld (de),a

	ld e,Interaction.var18
	ld a,(de)
	ld c,a
	inc e
	ld a,(de)
	ld b,>wRoomLayout
	ld (bc),a
	ret

; Waiting for block to be pushed
@state2:
	ld e,Interaction.var18
	ld a,(de)
	ld l,a
	inc e
	ld a,(de)
	ld h,>wRoomLayout
	cp (hl)
	ret z

; Tile index changed; that must mean the block was pushed.

	ld e,Interaction.state
	ld a,$03
	ld (de),a
	ld e,Interaction.counter1
	ld a,$1e
	ld (de),a
	ret

@state3:
	call interactionDecCounter1
	ret nz
	xor a
	ld (wNumEnemies),a
	jp interactionDelete


; ==============================================================================
; INTERACID_PUSHBLOCK
;
; Variables:
;   var30: Initial position of block being pushed (set by whatever spawn the object)
;   var31: Tile index being pushed (this is also read by INTERACID_PUSHBLOCK_SYNCHRONIZER)
; ==============================================================================
interactionCode14:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
.ifdef ROM_SEASONS
	.dw @state2
.endif

; State 0: block just pushed.
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	; var30 is the position of the block being pushed.
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)

	; Set var31 to be the tile index to imitate.
	ld e,Interaction.var31
	ld (de),a
	call objectMimicBgTile

.ifdef ROM_AGES
	call @checkRotatingCubePermitsPushing
	jp c,interactionDelete
.endif

	ld a,$06
	call objectSetCollideRadius
	call @loadPushableTileProperties

	; If bit 2 of var34 is set, there's only a half-tile; animation 1 will flip it.
	; (Pots are like this). Otherwise, for tiles that aren't symmetrical, it will use
	; two consecutive tiles
	ld h,d
	ld l,Interaction.var34
.ifdef ROM_SEASONS
	ld a,(hl)
	and $02
	jr z,+
	ld e,Interaction.state
	ld a,$02
	ld (de),a
+
.endif
	bit 2,(hl)
	ld a,$01
	call nz,interactionSetAnimation

	; Determine speed to push with (L-2 bracelet pushes faster)
	ld h,d
	ldbc SPEED_80, $20
.ifdef ROM_AGES
	ld a,(wBraceletLevel)
	cp $02
	jr nz,+
	ld l,Interaction.var34
	bit 5,(hl)
	jr nz,+
	ldbc SPEED_c0, $15
+
.endif
	ld l,Interaction.speed
	ld (hl),b
	ld l,Interaction.counter1
	ld (hl),c

	ld l,Interaction.angle
	ld a,(hl)
	or $80
	ld (wBlockPushAngle),a

	call @replaceTileUnderneathBlock
	call objectSetVisible82

	ld a,SND_MOVEBLOCK
	call playSound

@state1:
	call @updateZPositionForButton
	call objectApplySpeed
	call objectPreventLinkFromPassing

	call interactionDecCounter1
	ret nz

; Finished moving; decide what to do next
@func_449d:

	call objectReplaceWithAnimationIfOnHazard
	jp c,interactionDelete

	; Update var30 with the new position.
	call objectGetShortPosition
	ld e,Interaction.var30
	ld (de),a

	; If the tile to place at the destination position is defined, place it.
	ld e,Interaction.var33
	ld a,(de)
	or a
	jr z,++
	ld b,a
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	ld a,b
	call setTile
++
	; Check whether to play the sound
	ld e,Interaction.var34
	ld a,(de)
	rlca
	jr nc,++
	xor a
	ld (wDisabledObjects),a
	ld a,SND_SOLVEPUZZLE
	call playSound
++
	jp interactionDelete

.ifdef ROM_SEASONS
@state2:
	call @updateZPositionForButton
	ld e,Interaction.speed
	ld a,SPEED_1c0
	ld (de),a
	call objectApplySpeed
	call objectPreventLinkFromPassing
	call @@func_438a
	ret z
	ld a,SND_CLINK
	call playSound
	jr @func_449d
@@func_438a:
	ld e,Interaction.angle
	ld a,(de)
	call convertAngleDeToDirection
	ld hl,@@table_43a2
	rst_addDoubleIndex
	ld e,Interaction.yh
	ld a,(de)
	add (hl)
	ld b,a
	inc hl
	ld e,Interaction.xh
	ld a,(de)
	add (hl)
	ld c,a
	jp getTileCollisionsAtPosition
@@table_43a2:
	.db $f8 $00
	.db $00 $08
	.db $08 $00
	.db $00 $f8
.endif

;;
; If this object is on top of an unpressed button, this raises the z position by 2 pixels.
@updateZPositionForButton:
	ld a,(wTilesetFlags)
	and (TILESETFLAG_LARGE_INDOORS | TILESETFLAG_DUNGEON)
	ret z
	call objectGetShortPosition
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	cp TILEINDEX_BUTTON
	ld a,-2
	jr z,+
	xor a
+
	ld e,Interaction.zh
	ld (de),a
	ret

;;
; Replaces the tile underneath the block with whatever ground tile it should be. This
; first checks w3RoomLayoutBuffer for what the tile there should be. If that tile is
; non-solid, it uses that; otherwise, it uses [var32] as the new tile index.
;
; @param	c	Position
@replaceTileUnderneathBlock:
	ld e,Interaction.var30
	ld a,(de)
	ld c,a
	call getTileIndexFromRoomLayoutBuffer_paramC
	jp nc,setTile

	ld e,Interaction.var32
	ld a,(de)
	jp setTile

.ifdef ROM_AGES
;;
; This appears to check whether pushing blocks $2c-$2e (colored blocks) is permitted,
; based on whether a rotating cube is present, and whether the correct color flames for
; the cube are lit.
;
; @param[out]	cflag	If set, this interaction will delete itself?
@checkRotatingCubePermitsPushing:
	ld a,(wRotatingCubePos)
	or a
	ret z
	ld a,(wRotatingCubeColor)
	bit 7,a
	jr z,++
	and $7f
	ld b,a
	ld e,Interaction.var31
	ld a,(de)
	sub TILEINDEX_RED_PUSHABLE_BLOCK
	cp b
	ret z
++
	scf
	ret
.endif

;;
; Loads var31-var34 with some variables relating to pushable blocks (see below).
@loadPushableTileProperties:
.ifdef ROM_AGES
	ld a,(wActiveCollisions)
.else
	ld a,(wActiveGroup)
.endif
	ld hl,pushableTilePropertiesTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	ld e,Interaction.var31
	ld a,(de)
	ld b,a
--
	ldi a,(hl)
	or a
	ret z
	cp b
	jr z,@match
	inc hl
	inc hl
	inc hl
	jr --

@match:
	; Write data to var31-var34.
	ld (de),a
	ldi a,(hl)
	inc e
	ld (de),a
	ldi a,(hl)
	inc e
	ld (de),a
	ldi a,(hl)
	inc e
	ld (de),a
	ret


pushableTilePropertiesTable:
	.db @collisions0-CADDR
	.db @collisions1-CADDR
	.db @collisions2-CADDR
	.db @collisions3-CADDR
	.db @collisions4-CADDR
	.db @collisions5-CADDR
.ifdef ROM_SEASONS
	.db @collisions6-CADDR
	.db @collisions7-CADDR
.endif

; Data format:
;   b0 (var31): tile index
;   b1 (var32): the tile underneath it after being pushed
;   b2 (var33): the tile it becomes after being pushed (ie. a pushable block may become
;               unpushable)
;   b3 (var34): bit 2: if set, the tile is symmetrical, and flips the left half of the
;                      tile to get the right half.
;               bit 5: if set, it's "heavy" and doesn't get pushed more quickly with L2
;                      bracelet?
;               bit 7: play secret discovery sound after moving, and set
;               	"wDisabledObjects" to 0 (it would have been set to 1 previously
;               	from the "interactableTilesTable".
.ifdef ROM_AGES
@collisions0:
	.db $d3 $3a $02 $01
	.db $d8 $3a $02 $05
	.db $d9 $dc $02 $85
	.db $02 $3a $02 $05

@collisions4:
@collisions5:
	.db $00

@collisions1:
@collisions2:
	.db $18 $a0 $1d $01
	.db $19 $a0 $1d $01
	.db $1a $a0 $1d $01
	.db $1b $a0 $1d $01
	.db $1c $a0 $1d $01
	.db $2a $a0 $2a $01
	.db $2c $a0 $2c $01
	.db $2d $a0 $2d $01
	.db $2e $a0 $2e $01
	.db $10 $a0 $10 $01
	.db $11 $a0 $10 $01
	.db $12 $a0 $10 $01
	.db $13 $0d $10 $01
	.db $25 $a0 $25 $01
	.db $07 $a0 $06 $01

@collisions3:
	.db $00
.else
@collisions0:
@collisions1:
	.db $d6 $04 $9c $01
@collisions2:
	.db $00
@collisions3:
@collisions4:
@collisions5:
	.db $18 $a0 $1d $01
	.db $19 $a0 $1d $01
	.db $1a $a0 $1d $01
	.db $1b $a0 $1d $01
	.db $1c $a0 $1d $01
	.db $2a $a0 $2a $01
	.db $2c $a0 $2c $01
	.db $2d $a0 $2d $01
	.db $10 $a0 $10 $01
	.db $11 $a0 $10 $01
	.db $12 $a0 $10 $01
	.db $13 $0d $10 $01
	.db $25 $a0 $25 $01
	.db $2f $8c $2f $02
@collisions6:
@collisions7:
	.db $00
.endif


; ==============================================================================
; INTERACID_MINECART
; ==============================================================================
interactionCode16:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw interactionDelete

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$06
	call objectSetCollideRadius
	ld l,Interaction.counter1
	ld (hl),$04

	; Check for position relative to platform, set direction based on that
	ld a,TILEINDEX_MINECART_PLATFORM
	call objectGetRelativePositionOfTile
	ld h,d
	ld l,Interaction.direction
	xor $02
	ldi (hl),a

	; Set Interaction.angle
	swap a
	rrca
	ldd (hl),a

	; Set animation based on facing direction
	ld a,(hl)
	and $01
	call interactionSetAnimation

	; Save the minecart in a "static object" slot so the game remembers where it is
	call objectDeleteRelatedObj1AsStaticObject
	call findFreeStaticObjectSlot
	ld a,STATICOBJTYPE_INTERACTION
	call z,objectSaveAsStaticObject

@state1:
	call objectSetPriorityRelativeToLink
	ld a,(wLinkInAir)
	add a
	jr c,+

	; Check for collision, also prevent link from walking through
	call objectPreventLinkFromPassing
	ret nc
+
	ld a,(w1Link.zh)
	or a
	jr nz,@resetCounter

	call checkLinkID0AndControlNormal
	jr nc,@resetCounter

	call objectCheckLinkPushingAgainstCenter
	jr nc,@resetCounter

	ld a,$01
	ld (wForceLinkPushAnimation),a
	call interactionDecCounter1
	ret nz

	call interactionIncState

	; Force link to jump, lock his speed
	ld a,$81
	ld (wLinkInAir),a
	ld hl,w1Link.speed
	ld (hl),SPEED_80

	ld l,<w1Link.speedZ
	ld (hl),$40
	inc l
	ld (hl),$fe

	call objectGetAngleTowardLink
	xor $10
	ld (w1Link.angle),a
	ret

@resetCounter:
	ld e,Interaction.counter1
	ld a,$04
	ld (de),a
	ret

@state2:
	; Wait for link to reach a certain z position
	ld hl,w1Link.zh
	ld a,(hl)
	cp $fa
	ret c

	; Wait for link to start falling
	ld l,<w1Link.speedZ+1
	bit 7,(hl)
	ret nz

	; Set minecart state to $03 (state $03 jumps to interactionDelete).
	ld a,$03
	ld (de),a

	; Use the "companion" slot to create a minecart.
	; Presumably this is necessary for it to persist between rooms?
	ld hl,w1Companion.enabled
	ldi (hl),a
	ld (hl),SPECIALOBJECTID_MINECART

	; Copy direction, angle
	ld e,Interaction.direction
	ld l,SpecialObject.direction
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a

	call objectCopyPosition

	; Minecart will be moved, so the static object slot will be updated later.
	jp objectDeleteRelatedObj1AsStaticObject


; ==============================================================================
; INTERACID_DUNGEON_KEY_SPRITE
; ==============================================================================
interactionCode17:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),$fc
	ld l,Interaction.counter1
	ld (hl),$08

	; Subid is the tile index of the door being opened; use that to calculate a new
	; subid which will determine the graphic to use.
	ld l,Interaction.subid
	ld a,(hl)
	ld hl,@keyDoorGraphicTable
	call lookupCollisionTable
	ld e,Interaction.subid
	ld (de),a
	call interactionInitGraphics

	call objectSetVisible80
	ld a,SND_GETSEED
	jp playSound

@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),$14

	ld l,Interaction.zh
	ld (hl),$f8

	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz
	ld (hl),$0f
	jp interactionDelete


@keyDoorGraphicTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

; Data format:
;   b0: tile index
;   b1: key type (0=small key, 1=boss key)

.ifdef ROM_AGES
@collisions0:
@collisions1:
@collisions3:
@collisions4:
	.db $00 $00

@collisions2:
@collisions5:
	.db $1e $00 ; Keyblock
	.db $70 $00 ; Small key doors
	.db $71 $00
	.db $72 $00
	.db $73 $00
	.db $74 $01 ; Boss key doors
	.db $75 $01
	.db $76 $01
	.db $77 $01
	.db $00
.else
@collisions0:
	.db $00
@collisions1:
	.db $ec $00
@collisions2:
@collisions3:
@collisions5:
	.db $00
@collisions4:
	.db $1e $00
	.db $70 $00
	.db $71 $00
	.db $72 $00
	.db $73 $00
	.db $74 $01
	.db $75 $01
	.db $76 $01
	.db $77 $01
	.db $00

.endif


; ==============================================================================
; INTERACID_OVERWORLD_KEY_SPRITE
; ==============================================================================
interactionCode18:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionIncState
	ld bc,-$200
	call objectSetSpeedZ
	call interactionSetAlwaysUpdateBit
	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	; Decrease speedZ, wait for it to stop moving up
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ld e,Interaction.speedZ+1
	ld a,(de)
	bit 7,a
	ret nz

	ld e,Interaction.counter1
	ld a,$3c
	ld (de),a
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz
	jp interactionDelete


; ==============================================================================
; INTERACID_FARORES_MEMORY
; ==============================================================================
interactionCode1c:
	call checkInteractionState
	jp nz,interactionRunScript

; Initialization

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr nz,+
	call checkIsLinkedGame
	jp z,interactionDelete
+
	call interactionInitGraphics
	call objectSetVisible83

	ld hl,mainScripts.faroresMemoryScript
	call interactionSetScript

	jp interactionIncState


.ifdef ROM_SEASONS

; This is the only interaction in this file that is completely game-exclusive

; ==============================================================================
; INTERACID_RUPEE_ROOM_RUPEES
; ==============================================================================
interactionCode1d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	add a
	add b
	ld hl,@@rupeeRoomTable
	rst_addAToHl
	ldi a,(hl)
	ld e,Interaction.var30
	ld (de),a
	ldi a,(hl)
	ld e,Interaction.var31
	ld (de),a
	ld a,(hl)
	inc e
	; var32
	ld (de),a
	ret

@@rupeeRoomTable:
	; top-left coords of rupees grid
	dbw $23 wD2RupeeRoomRupees
	dbw $34 wD6RupeeRoomRupees

@state1:
	ld a,(wActiveTileIndex)
	; is a rupee tile
	cp $3c
	jr z,+
	cp $3d
	ret nz
+
	ld h,d
	ld l,Interaction.var30
	ld a,(hl)
	ld a,(wActiveTilePos)
	sub (hl)
	ld b,a
	ld l,Interaction.var31
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,b
	swap a
	and $0f
	rst_addAToHl
	ld a,b
	and $0f
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	or (hl)
	ld (hl),a
	call getRandomNumber
	and $0f
	ld hl,@@chosenRupeeVal
	rst_addAToHl
	ld c,(hl)
	ld a,GOLD_JOY_RING
	call cpActiveRing
	jr z,@@doubleRupees
	ld a,RED_JOY_RING
	call cpActiveRing
	jr nz,@@giveRupees

@@doubleRupees:
	inc c

@@giveRupees:
	ld a,TREASURE_RUPEES
	call giveTreasure
	ld a,(wActiveTilePos)
	ld c,a
	ld a,TILEINDEX_STANDARD_FLOOR
	jp setTile

@@chosenRupeeVal:
	.db RUPEEVAL_001 RUPEEVAL_010 RUPEEVAL_010 RUPEEVAL_005
	.db RUPEEVAL_005 RUPEEVAL_005 RUPEEVAL_005 RUPEEVAL_001
	.db RUPEEVAL_001 RUPEEVAL_020 RUPEEVAL_001 RUPEEVAL_001
	.db RUPEEVAL_001 RUPEEVAL_001 RUPEEVAL_001 RUPEEVAL_001

.endif ; ROM_SEASONS


; ==============================================================================
; INTERACID_DOOR_CONTROLLER
; ==============================================================================
interactionCode1e:
	call interactionDeleteAndRetIfEnabled02
	call returnIfScrollMode01Unset
.ifdef ROM_AGES
	ld a,(wSwitchHookState)
	cp $02
	ret z
.endif

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

	; "xh" is actually a parameter. It's a value from 0-7; a bit for wActiveTriggers.
	ld h,d
	ld l,Interaction.xh
	ld e,Interaction.var3f
	ld a,(hl)
	ld (de),a
	and $07
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	ld l,Interaction.var3d
	ld (hl),a

	; Convert short-form position in yh to full y/x position
	ld l,Interaction.yh
	ld e,Interaction.var3e
	ld a,(hl)
	ld (de),a
	ld l,Interaction.yh
	call setShortPosition

	; Decide what script to run based on subid. The script will decide when to proceed
	; to state 2 (open door) or 3 (close door).
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptSubidTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call @func_47e5

@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.substate
	xor a
	ld (de),a
	ret


; State 2: a door is opening
@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state2Substate0
	.dw @state2Substate1

@state2Substate0:
	; The tile at this position must be solid
	call objectCheckTileCollision_allowHoles
	jr nc,@gotoState1

@interleaveDoorTile:
	ld a,SND_DOORCLOSE
	call @playSoundIfInScreenBoundary

	ld e,Interaction.angle
	ld a,(de)
	ld hl,@shutterTiles
	rst_addAToHl
	ld e,Interaction.var3e
	ld a,(de)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	and $03
	call setInterleavedTile

	ldh a,(<hActiveObject)
	ld d,a
	ld h,d
	ld l,Interaction.substate
	inc (hl)

	ld l,Interaction.counter1
	ld (hl),$06

	; Set the new tile in the room layout (but since we're not calling "setTile", the
	; visuals won't be updated just yet?)
	ld l,Interaction.var3e
	ld c,(hl)
	ld b,>wRoomLayout
	ldh a,(<hFF8F)
	ld (bc),a
	ret

@state2Substate1:
	call interactionDecCounter1
	ret nz

; Door will now open fully

	call @func_47ee
	ld e,Interaction.angle
	ld a,(de)
	ld hl,@shutterTiles
	rst_addAToHl
	jr @setTileAndPlaySound


; State 3: a door is closing
@state3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state3Substate0
	.dw @state3Substate1

@state3Substate0:
.ifdef ROM_AGES
	; The tile at this position must not be solid
	call objectGetTileAtPosition
	cp TILEINDEX_SOMARIA_BLOCK
	jr z,@interleaveDoorTile
.endif
	call objectCheckTileCollision_allowHoles
	jr c,@gotoState1
	jr @interleaveDoorTile

@state3Substate1:
	call interactionDecCounter1
	ret nz

; Door will now close fully

	call @checkRespawnLink
	call @func_47f9

	ld e,Interaction.angle
	ld a,(de)
	ld hl,@shutterTiles
	rst_addAToHl
	inc hl

@setTileAndPlaySound:
	ld e,Interaction.var3e
	ld a,(de)
	ld c,a
	ld a,(hl)
	call setTile
	ld a,SND_DOORCLOSE
	call @playSoundIfInScreenBoundary

@gotoState1:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	inc e
	xor a
	ld (de),a
	jp @state1

;;
; Force Link to respawn if he's on the same tile as this object.
@checkRespawnLink:
	ld a,(w1Link.yh)
	and $f0
	ld b,a
	ld a,(w1Link.xh)
	swap a
	and $0f
	or b
	ld b,a
	ld e,Interaction.var3e
	ld a,(de)
	cp b
	ret nz
	ld a,$02
	ld (wScreenTransitionDelay),a
	jp respawnLink

@func_47e5:
	ld e,Interaction.var3e
	ld a,(de)
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	ret nz

@func_47ee:
	ld e,Interaction.subid
	ld a,(de)
	cp $04
	ret c
	ld hl,wcc93
	inc (hl)
	ret

@func_47f9:
	ld e,Interaction.subid
	ld a,(de)
	cp $04
	ret c
	ld hl,wcc93
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ld a,(hl)
	and $7f
	ret nz
	res 7,(hl)
	ret

;;
; @param	a	Sound to play
@playSoundIfInScreenBoundary:
	ldh (<hFF8B),a
	call objectCheckWithinScreenBoundary
	ret nc
	ldh a,(<hFF8B)
	jp playSound


; Data format:
;   b0: tile to transition into
;   b1: tile to transition from

@shutterTiles:
	.db $a0 $70 ; Key doors
	.db $a0 $71
	.db $a0 $72
	.db $a0 $73
	.db $a0 $74 ; Boss doors
	.db $a0 $75
	.db $a0 $76
	.db $a0 $77
	.db $a0 $78 ; Shutters
	.db $a0 $79
	.db $a0 $7a
	.db $a0 $7b
	.db $5e $7c ; Minecart shutters
	.db $5d $7d
	.db $5e $7e
	.db $5d $7f


@scriptSubidTable:
	/* $00 */ .dw mainScripts.doorOpenerScript
	/* $01 */ .dw mainScripts.stubScript
	/* $02 */ .dw mainScripts.stubScript
	/* $03 */ .dw mainScripts.stubScript
	/* $04 */ .dw mainScripts.doorController_controlledByTriggers_up
	/* $05 */ .dw mainScripts.doorController_controlledByTriggers_right
	/* $06 */ .dw mainScripts.doorController_controlledByTriggers_down
	/* $07 */ .dw mainScripts.doorController_controlledByTriggers_left
	/* $08 */ .dw mainScripts.doorController_shutUntilEnemiesDead_up
	/* $09 */ .dw mainScripts.doorController_shutUntilEnemiesDead_right
	/* $0a */ .dw mainScripts.doorController_shutUntilEnemiesDead_down
	/* $0b */ .dw mainScripts.doorController_shutUntilEnemiesDead_left
	/* $0c */ .dw mainScripts.doorController_minecartDoor_up
	/* $0d */ .dw mainScripts.doorController_minecartDoor_right
	/* $0e */ .dw mainScripts.doorController_minecartDoor_down
	/* $0f */ .dw mainScripts.doorController_minecartDoor_left
	/* $10 */ .dw mainScripts.doorController_closeAfterLinkEnters_up
	/* $11 */ .dw mainScripts.doorController_closeAfterLinkEnters_right
	/* $12 */ .dw mainScripts.doorController_closeAfterLinkEnters_down
	/* $13 */ .dw mainScripts.doorController_closeAfterLinkEnters_left
	/* $14 */ .dw mainScripts.doorController_openWhenTorchesLit_up_2Torches
	/* $15 */ .dw mainScripts.doorController_openWhenTorchesLit_left_2Torches
.ifdef ROM_AGES
	/* $16 */ .dw mainScripts.doorController_openWhenTorchesLit_down_1Torch
	/* $17 */ .dw mainScripts.doorController_openWhenTorchesLit_left_1Torch
.endif

.ends
