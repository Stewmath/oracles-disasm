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
	ld e,Interaction.state		; $4000
	ld a,(de)		; $4002
	rst_jumpTable			; $4003
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4008
	ld (de),a		; $400a
	call interactionInitGraphics		; $400b
	ld h,d			; $400e
	ld l,Interaction.speed	; $400f
	ld (hl),SPEED_80		; $4011

	ld l,Interaction.subid	; $4013
	bit 1,(hl)		; $4015
	call z,interactionSetAlwaysUpdateBit		; $4017

	call @doSpecializedInitialization		; $401a

	ld e,Interaction.id		; $401d
	ld a,(de)		; $401f
	ld hl,@soundAndPriorityTable	; $4020
	rst_addDoubleIndex			; $4023
	ld e,Interaction.subid	; $4024
	ld a,(de)		; $4026
	rlca			; $4027
	ldi a,(hl)		; $4028
	ld e,(hl)		; $4029
	call nc,playSound		; $402a
	ld a,e			; $402d
	rst_jumpTable			; $402e
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
	ld h,d			; $4051
	ld l,Interaction.animParameter		; $4052
	bit 7,(hl)		; $4054
	jp nz,interactionDelete		; $4056

	ld l,Interaction.subid		; $4059
	bit 0,(hl)		; $405b
	jr z,++			; $405d

	ld a,(wFrameCounter)		; $405f
	xor d			; $4062
	rrca			; $4063
	ld l,Interaction.visible	; $4064
	set 7,(hl)		; $4066
	jr nc,++		; $4068

	res 7,(hl)		; $406a
++
	ld e,Interaction.id		; $406c
	ld a,(de)		; $406e
	cp INTERACID_SHOVELDEBRIS	; $406f
	jr nz,+			; $4071

	ld c,$60		; $4073
	call objectUpdateSpeedZ_paramC		; $4075
	call objectApplySpeed		; $4078
+
	jp interactionAnimate		; $407b

;;
; Does specific things for interactions 0 (underwater bush breaking) and $0a (shovel
; debris)
; @addr{407e}
@doSpecializedInitialization:
	ld e,Interaction.id		; $407e
	ld a,(de)		; $4080
	or a			; $4081
	jr z,@interac00		; $4082

	cp INTERACID_SHOVELDEBRIS	; $4084
	ret nz			; $4086

@interac0A:
	ld bc,-$240		; $4087
	call objectSetSpeedZ		; $408a
	ld e,Interaction.direction	; $408d
	ld a,(de)		; $408f
	jp interactionSetAnimation		; $4090

@interac00:
.ifdef ROM_AGES
	ld a,(wTilesetFlags)		; $4093
	and TILESETFLAG_UNDERWATER	; $4096
	jr z,+			; $4098

	ld a,$0e		; $409a
	jr ++			; $409c
.endif
+
	ld a,(wGrassAnimationModifier)		; $409e
	and $03			; $40a1
	or $08			; $40a3
++
	ld e,Interaction.oamFlagsBackup		; $40a5
	ld (de),a		; $40a7
	inc e			; $40a8
	ld (de),a		; $40a9
	ret			; $40aa


; ==============================================================================
; INTERACID_FALLDOWNHOLE
; ==============================================================================
interactionCode0f:
	ld e,Interaction.state	; $40ab
	ld a,(de)		; $40ad
	rst_jumpTable			; $40ae
	.dw @interac0f_state0
	.dw @interac0f_state1
	.dw @interac0f_state2

@interac0f_state0:
	call interactionInitGraphics		; $40b5
	call interactionSetAlwaysUpdateBit		; $40b8
	call interactionIncState		; $40bb

	; [state] += [subid]
	ld e,Interaction.subid	; $40be
	ld a,(de)		; $40c0
	add (hl)		; $40c1
	ld (hl),a		; $40c2

	ld l,Interaction.speed	; $40c3
	ld (hl),SPEED_60		; $40c5
	dec a			; $40c7
	jr z,@fallDownHole			; $40c8

@dust:
	call interactionSetAnimation		; $40ca
	jp objectSetVisible80		; $40cd

@fallDownHole:
	inc e			; $40d0
	ld a,(de)		; $40d1
	rlca			; $40d2
	ld a,SND_FALLINHOLE	; $40d3
	call nc,playSound		; $40d5
.ifdef ROM_AGES
	call @checkUpdateHoleEvent		; $40d8
.endif
	jp objectSetVisible83		; $40db


; State 1: "falling into hole" animation
@interac0f_state1:
	ld h,d			; $40de
	ld l,Interaction.animParameter		; $40df
	bit 7,(hl)		; $40e1
	jr nz,@delete		; $40e3

	; Calculate the direction this should move in to move towards the
	; center of the hole
	ld l,Interaction.yh		; $40e5
	ldi a,(hl)		; $40e7
	ldh (<hFF8F),a	; $40e8
	add $05			; $40ea
	and $f0			; $40ec
	add $08			; $40ee
	ld b,a			; $40f0
	inc l			; $40f1
	ld a,(hl)		; $40f2
	ldh (<hFF8E),a	; $40f3
	and $f0			; $40f5
	add $08			; $40f7
	ld c,a			; $40f9
	cp (hl)			; $40fa
	jr nz,+			; $40fb

	ldh a,(<hFF8F)	; $40fd
	cp b			; $40ff
	jr z,@animate			; $4100
+
	call objectGetRelativeAngleWithTempVars		; $4102
	ld e,Interaction.angle	; $4105
	ld (de),a		; $4107
	call objectApplySpeed		; $4108

@animate:
	jp interactionAnimate		; $410b


; State 2: pegasus seed dust?
@interac0f_state2:
	ld h,d			; $410e
	ld l,Interaction.visible	; $410f
	ld a,(hl)		; $4111
	xor $80			; $4112
	ld (hl),a		; $4114
	ld l,Interaction.animParameter		; $4115
	bit 7,(hl)		; $4117
	jr z,@animate			; $4119
@delete:
	jp interactionDelete		; $411b


.ifdef ROM_AGES
;;
; Certain rooms have things happen when something falls into a hole; this writes something
; around $cfd8 to provide a signal?
; @addr{411e}
@checkUpdateHoleEvent:
	ld a,(wActiveRoom)		; $411e
	ld e,a			; $4121
	ld hl,@specialHoleRooms		; $4122
	call lookupKey		; $4125
	ret nc			; $4128

	ld b,a			; $4129
	ld a,(wActiveGroup)		; $412a
	cp b			; $412d
	ret nz			; $412e

	ld hl,wTmpcfc0.fallDownHoleEvent.cfd8		; $412f
	ld b,$04		; $4132
--
	ldi a,(hl)		; $4134
	cp $ff			; $4135
	jr nz,++		; $4137

	; This contains the ID of the object that fell in the hole?
	ld e,Interaction.counter2		; $4139
	ld a,(de)		; $413b
	ldd (hl),a		; $413c
	dec e			; $413d
	ld a,(de)		; $413e
	ld (hl),a		; $413f
	ret			; $4140
++
	inc l			; $4141
	dec b			; $4142
	jr nz,--		; $4143
	ret			; $4145

; @addr{4146}
@specialHoleRooms:
	.dw ROOM_AGES_5e8 ; Patch's room
	.dw ROOM_AGES_23e ; Toilet room
	.db $00

;;
; @addr{414b}
clearFallDownHoleEventBuffer:
	ld hl,wTmpcfc0.fallDownHoleEvent.cfd8		; $414b
	ld b,_sizeof_wTmpcfc0.fallDownHoleEvent.cfd8		; $414e
	ld a,$ff		; $4150
	jp fillMemory		; $4152
.endif


; ==============================================================================
; INTERACID_FARORE
; ==============================================================================
interactionCode10:
	ld e,Interaction.state		; $4155
	ld a,(de)		; $4157
	rst_jumpTable			; $4158
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $415d
	ld (de),a		; $415f

	call interactionInitGraphics		; $4160

	ld a,>TX_5500		; $4163
	call interactionSetHighTextIndex		; $4165

	ld hl,faroreScript		; $4168
	call interactionSetScript		; $416b

	ld a,GLOBALFLAG_SECRET_CHEST_WAITING		; $416e
	call unsetGlobalFlag		; $4170

	ld a,TEXTBOXFLAG_DONTCHECKPOSITION		; $4173
	ld (wTextboxFlags),a		; $4175
	ld a,$02		; $4178
	ld (wTextboxPosition),a		; $417a

	jp objectSetVisible82		; $417d

@state1:
	ld bc,$1406		; $4180
	call objectSetCollideRadii		; $4183
	call interactionRunScript		; $4186
	jp interactionAnimate		; $4189


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
	ld e,Interaction.subid		; $42d0
	ld a,(de)		; $42d2
	rst_jumpTable			; $42d3
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
	call checkInteractionState		; $42de
	jr nz,@initialized	; $42e1

	; Delete self Link is not currently walking in from a whiteout transition
	ld a,(wScrollMode)		; $42e3
	and SCROLLMODE_02		; $42e6
	jp z,interactionDelete		; $42e8

	; Delete self if Link entered from the wrong side of the room
	ld a,(w1Link.yh)		; $42eb
	cp $78			; $42ee
	jp c,interactionDelete		; $42f0

	call interactionIncState		; $42f3
	ld a,$08		; $42f6
	call objectSetCollideRadius		; $42f8
	call initializeDungeonStuff		; $42fb
	ld a,(wDungeonIndex)		; $42fe
.ifdef ROM_AGES
	ld hl,@initialSpinnerValues		; $4301
	rst_addAToHl			; $4304
	ld a,(hl)		; $4305
.else
	cp $07			; $4182
	jr nz,+	; $4184
	ld a,$05		; $4186
	ld (wToggleBlocksState),a		; $4188
+
	ld a,(wDungeonIndex)		; $418b
	cp $08			; $418e
	jr nz,@initialized	; $4190
	ld a,$01		; $4192
.endif
	ld (wSpinnerState),a		; $4306

@initialized:
	call objectCheckCollidedWithLink_notDead		; $4309
	ret nc			; $430c

	ld a,(wDungeonIndex)		; $430d
	ld hl,@dungeonTextIndices	; $4310
	rst_addAToHl			; $4313
	ld c,(hl)		; $4314
	ld b,>TX_0200		; $4315
	call showText		; $4317
	call setDeathRespawnPoint		; $431a
	jp interactionDelete		; $431d


; Text shown on entering a dungeon. One byte per dungeon.
@dungeonTextIndices:
	.ifdef ROM_AGES
		.db <TX_0200 <TX_0201 <TX_0202 <TX_0203 <TX_0204 <TX_0205 <TX_0206 <TX_0207
		.db <TX_0208 <TX_0209 <TX_020a <TX_020b <TX_020c <TX_020d <TX_020e <TX_020f

	.else; ROM_SEASONS

		.db <TX_0200 <TX_0201 <TX_0202 <TX_0203 <TX_0204 <TX_0205 <TX_0206 <TX_0207
		.db <TX_0208 <TX_0209 <TX_020a <TX_0200 <TX_0200 <TX_0200 <TX_0200 <TX_0200
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
	call returnIfScrollMode01Unset		; $4340
	ld e,Interaction.state	; $4343
	ld a,(de)		; $4345
	rst_jumpTable			; $4346
	.dw @@substate0
	.dw @runScript

@@substate0:
	ld a,$01		; $434b
	ld (de),a		; $434d
	ld hl,dropSmallKeyWhenNoEnemiesScript		; $434e
	call interactionSetScript		; $4351

@runScript:
	call interactionRunScript		; $4354
	jp c,interactionDelete		; $4357
	ret			; $435a


; Create a chest when all enemies are killed
@subid02:
	ld e,Interaction.state		; $435b
	ld a,(de)		; $435d
	rst_jumpTable			; $435e
	.dw @@substate0
	.dw @runScript
	.dw @@substate2

@@substate0:
	ld a,$01		; $4365
	ld (de),a		; $4367
	ld hl,createChestWhenNoEnemiesScript		; $4368
	call interactionSetScript		; $436b
	jr @runScript		; $436e

@@substate2:
	; In substate 2, the chest has appeared; so it calls
	; "objectPreventLinkFromPassing" to push Link away?
	call objectPreventLinkFromPassing		; $4370
	jr @runScript		; $4373


; Set bit 7 of room flags when all enemies are killed
@subid03:
	call checkInteractionState		; $4375
	jr nz,@runScript	; $4378

	ld a,$01		; $437a
	ld (de),a		; $437c
	ld hl,setRoomFlagBit7WhenNoEnemiesScript		; $437d
	call interactionSetScript		; $4380
	jr @runScript		; $4383


; Create a staircase when all enemies are killed
@subid04:
	call returnIfScrollMode01Unset		; $4385

	call getThisRoomFlags		; $4388
	bit ROOMFLAG_BIT_KEYBLOCK,a			; $438b
	jp nz,interactionDelete		; $438d

	ld a,(wNumEnemies)		; $4390
	or a			; $4393
	ret nz			; $4394

	ld a,SND_SOLVEPUZZLE		; $4395
	call playSound		; $4397

	call getThisRoomFlags		; $439a
	set ROOMFLAG_BIT_KEYBLOCK,(hl)		; $439d

	; Search for all tiles with indices between $40 and $43, inclusive, and replace
	; them with staircases.
	ld bc, wRoomLayout + LARGE_ROOM_HEIGHT*16 - 1
--
	ld a,(bc)		; $43a2
	sub $40			; $43a3
	cp $04			; $43a5
	call c,@createStaircaseTile		; $43a7
	dec c			; $43aa
	jr nz,--		; $43ab
	ret			; $43ad

@createStaircaseTile:
	push bc			; $43ae
	push hl			; $43af
	ld hl,@replacementTiles		; $43b0
	rst_addAToHl			; $43b3
	ld a,(hl)		; $43b4
	call setTile		; $43b5
	call @createPuff		; $43b8
	pop hl			; $43bb
	pop bc			; $43bc
	ret			; $43bd

@replacementTiles:
	.db $46 $47 $44 $45

@createPuff:
	call getFreeInteractionSlot		; $43c2
	ret nz			; $43c5
	ld (hl),INTERACID_PUFF		; $43c6
	ld l,Interaction.yh		; $43c8
	jp setShortPosition_paramC		; $43ca

.ifdef ROM_SEASONS
@subid05:
	ld e,Interaction.state		; $424b
	ld a,(de)		; $424d
	rst_jumpTable			; $424e
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld a,$01		; $4255
	ld (de),a		; $4257
	call interactionInitGraphics		; $4258
	call objectSetVisible82		; $425b
@@state1:
	ld hl,$dd00		; $425e
	ld a,(hl)		; $4261
	or a			; $4262
	ret nz			; $4263

	ld (hl),$01		; $4264
	inc l			; $4266
	; TODO:
	ld (hl),$29		; $4267
	call objectCopyPosition		; $4269

	; copy relatedObj1 over
	ld e,Interaction.relatedObj1		; $426c
	ld l,$16		; $426e
	ld a,(de)		; $4270
	ldi (hl),a		; $4271
	inc e			; $4272
	ld a,(de)		; $4273
	ld (hl),a		; $4274

	ld e,Interaction.state		; $4275
	ld a,$02		; $4277
	ld (de),a		; $4279
	ret			; $427a
@@state2:
	jp interactionDelete		; $427b
.endif


; ==============================================================================
; INTERACID_PUSHBLOCK_TRIGGER
; ==============================================================================
interactionCode13:
	call interactionDeleteAndRetIfEnabled02		; $43cd
	call returnIfScrollMode01Unset		; $43d0
	ld e,Interaction.state		; $43d3
	ld a,(de)		; $43d5
	rst_jumpTable			; $43d6
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d			; $43df
	ld l,Interaction.state		; $43e0
	ld (hl),$01		; $43e2

	call objectGetShortPosition		; $43e4
	ld l,Interaction.var18		; $43e7
	ld (hl),a		; $43e9

	; Replace the block at this position with TILEINDEX_PUSHABLE_BLOCK; save the old
	; value for the tile there into var19.
	ld c,a			; $43ea
	ld b,>wRoomLayout		; $43eb
	ld a,(bc)		; $43ed
	inc l			; $43ee
	ld (hl),a ; [var19] = tile at position
	ld a,TILEINDEX_PUSHABLE_BLOCK		; $43f0
	ld (bc),a		; $43f2

	ld hl,wNumEnemies		; $43f3
	inc (hl)		; $43f6
	ret			; $43f7

; Waiting for wNumEnemies to equal subid
@state1:
	ld a,(wNumEnemies)		; $43f8
	ld b,a			; $43fb
	ld e,Interaction.subid		; $43fc
	ld a,(de)		; $43fe
	cp b			; $43ff
	ret c			; $4400

	ld e,Interaction.state		; $4401
	ld a,$02		; $4403
	ld (de),a		; $4405

	ld e,Interaction.var18		; $4406
	ld a,(de)		; $4408
	ld c,a			; $4409
	inc e			; $440a
	ld a,(de)		; $440b
	ld b,>wRoomLayout		; $440c
	ld (bc),a		; $440e
	ret			; $440f

; Waiting for block to be pushed
@state2:
	ld e,Interaction.var18		; $4410
	ld a,(de)		; $4412
	ld l,a			; $4413
	inc e			; $4414
	ld a,(de)		; $4415
	ld h,>wRoomLayout		; $4416
	cp (hl)			; $4418
	ret z			; $4419

; Tile index changed; that must mean the block was pushed.

	ld e,Interaction.state		; $441a
	ld a,$03		; $441c
	ld (de),a		; $441e
	ld e,Interaction.counter1		; $441f
	ld a,$1e		; $4421
	ld (de),a		; $4423
	ret			; $4424

@state3:
	call interactionDecCounter1		; $4425
	ret nz			; $4428
	xor a			; $4429
	ld (wNumEnemies),a		; $442a
	jp interactionDelete		; $442d


; ==============================================================================
; INTERACID_PUSHBLOCK
;
; Variables:
;   var30: Initial position of block being pushed (set by whatever spawn the object)
;   var31: Tile index being pushed (this is also read by INTERACID_PUSHBLOCK_SYNCHRONIZER)
; ==============================================================================
interactionCode14:
	ld e,Interaction.state		; $4430
	ld a,(de)		; $4432
	rst_jumpTable			; $4433
	.dw @state0
	.dw @state1
.ifdef ROM_SEASONS
	.dw @state2
.endif

; State 0: block just pushed.
@state0:
	ld a,$01		; $4438
	ld (de),a		; $443a
	call interactionInitGraphics		; $443b

	; var30 is the position of the block being pushed.
	ld e,Interaction.var30		; $443e
	ld a,(de)		; $4440
	ld c,a			; $4441
	ld b,>wRoomLayout		; $4442
	ld a,(bc)		; $4444

	; Set var31 to be the tile index to imitate.
	ld e,Interaction.var31		; $4445
	ld (de),a		; $4447
	call objectMimicBgTile		; $4448

.ifdef ROM_AGES
	call @checkRotatingCubePermitsPushing		; $444b
	jp c,interactionDelete		; $444e
.endif

	ld a,$06		; $4451
	call objectSetCollideRadius		; $4453
	call @loadPushableTileProperties		; $4456

	; If bit 2 of var34 is set, there's only a half-tile; animation 1 will flip it.
	; (Pots are like this). Otherwise, for tiles that aren't symmetrical, it will use
	; two consecutive tiles
	ld h,d			; $4459
	ld l,Interaction.var34		; $445a
.ifdef ROM_SEASONS
	ld a,(hl)		; $4309
	and $02			; $430a
	jr z,+			; $430c
	ld e,Interaction.state		; $430e
	ld a,$02		; $4310
	ld (de),a		; $4312
+
.endif
	bit 2,(hl)		; $445c
	ld a,$01		; $445e
	call nz,interactionSetAnimation		; $4460

	; Determine speed to push with (L-2 bracelet pushes faster)
	ld h,d			; $4463
	ldbc SPEED_80, $20		; $4464
.ifdef ROM_AGES
	ld a,(wBraceletLevel)		; $4467
	cp $02			; $446a
	jr nz,+			; $446c
	ld l,Interaction.var34		; $446e
	bit 5,(hl)		; $4470
	jr nz,+			; $4472
	ldbc SPEED_c0, $15		; $4474
+
.endif
	ld l,Interaction.speed		; $4477
	ld (hl),b		; $4479
	ld l,Interaction.counter1		; $447a
	ld (hl),c		; $447c

	ld l,Interaction.angle		; $447d
	ld a,(hl)		; $447f
	or $80			; $4480
	ld (wBlockPushAngle),a		; $4482

	call @replaceTileUnderneathBlock		; $4485
	call objectSetVisible82		; $4488

	ld a,SND_MOVEBLOCK		; $448b
	call playSound		; $448d

@state1:
	call @updateZPositionForButton		; $4490
	call objectApplySpeed		; $4493
	call objectPreventLinkFromPassing		; $4496

	call interactionDecCounter1		; $4499
	ret nz			; $449c

; Finished moving; decide what to do next
@func_449d:

	call objectReplaceWithAnimationIfOnHazard		; $449d
	jp c,interactionDelete		; $44a0

	; Update var30 with the new position.
	call objectGetShortPosition		; $44a3
	ld e,Interaction.var30		; $44a6
	ld (de),a		; $44a8

	; If the tile to place at the destination position is defined, place it.
	ld e,Interaction.var33		; $44a9
	ld a,(de)		; $44ab
	or a			; $44ac
	jr z,++			; $44ad
	ld b,a			; $44af
	ld e,Interaction.var30		; $44b0
	ld a,(de)		; $44b2
	ld c,a			; $44b3
	ld a,b			; $44b4
	call setTile		; $44b5
++
	; Check whether to play the sound
	ld e,Interaction.var34		; $44b8
	ld a,(de)		; $44ba
	rlca			; $44bb
	jr nc,++		; $44bc
	xor a			; $44be
	ld (wDisabledObjects),a		; $44bf
	ld a,SND_SOLVEPUZZLE		; $44c2
	call playSound		; $44c4
++
	jp interactionDelete		; $44c7

.ifdef ROM_SEASONS
@state2:
	call @updateZPositionForButton		; $4371
	ld e,Interaction.speed		; $4374
	ld a,SPEED_1c0		; $4376
	ld (de),a		; $4378
	call objectApplySpeed		; $4379
	call objectPreventLinkFromPassing		; $437c
	call @@func_438a		; $437f
	ret z			; $4382
	ld a,SND_CLINK		; $4383
	call playSound		; $4385
	jr @func_449d		; $4388
@@func_438a:
	ld e,Interaction.angle		; $438a
	ld a,(de)		; $438c
	call convertAngleDeToDirection		; $438d
	ld hl,@@table_43a2		; $4390
	rst_addDoubleIndex			; $4393
	ld e,Interaction.yh		; $4394
	ld a,(de)		; $4396
	add (hl)		; $4397
	ld b,a			; $4398
	inc hl			; $4399
	ld e,Interaction.xh		; $439a
	ld a,(de)		; $439c
	add (hl)		; $439d
	ld c,a			; $439e
	jp getTileCollisionsAtPosition		; $439f
@@table_43a2:
	.db $f8 $00
	.db $00 $08
	.db $08 $00
	.db $00 $f8
.endif

;;
; If this object is on top of an unpressed button, this raises the z position by 2 pixels.
; @addr{44ca}
@updateZPositionForButton:
	ld a,(wTilesetFlags)		; $44ca
	and (TILESETFLAG_10 | TILESETFLAG_DUNGEON)			; $44cd
	ret z			; $44cf
	call objectGetShortPosition		; $44d0
	ld c,a			; $44d3
	ld b,>wRoomLayout		; $44d4
	ld a,(bc)		; $44d6
	cp TILEINDEX_BUTTON			; $44d7
	ld a,-2			; $44d9
	jr z,+			; $44db
	xor a			; $44dd
+
	ld e,Interaction.zh		; $44de
	ld (de),a		; $44e0
	ret			; $44e1

;;
; Replaces the tile underneath the block with whatever ground tile it should be. This
; first checks w3RoomLayoutBuffer for what the tile there should be. If that tile is
; non-solid, it uses that; otherwise, it uses [var32] as the new tile index.
;
; @param	c	Position
; @addr{44ec}
@replaceTileUnderneathBlock:
	ld e,Interaction.var30		; $44e2
	ld a,(de)		; $44e4
	ld c,a			; $44e5
	call getTileIndexFromRoomLayoutBuffer_paramC		; $44e6
	jp nc,setTile		; $44e9

	ld e,Interaction.var32		; $44ec
	ld a,(de)		; $44ee
	jp setTile		; $44ef

.ifdef ROM_AGES
;;
; This appears to check whether pushing blocks $2c-$2e (colored blocks) is permitted,
; based on whether a rotating cube is present, and whether the correct color flames for
; the cube are lit.
;
; @param[out]	cflag	If set, this interaction will delete itself?
; @addr{44f2}
@checkRotatingCubePermitsPushing:
	ld a,(wRotatingCubePos)		; $44f2
	or a			; $44f5
	ret z			; $44f6
	ld a,(wRotatingCubeColor)		; $44f7
	bit 7,a			; $44fa
	jr z,++			; $44fc
	and $7f			; $44fe
	ld b,a			; $4500
	ld e,Interaction.var31		; $4501
	ld a,(de)		; $4503
	sub TILEINDEX_RED_PUSHABLE_BLOCK			; $4504
	cp b			; $4506
	ret z			; $4507
++
	scf			; $4508
	ret			; $4509
.endif

;;
; Loads var31-var34 with some variables relating to pushable blocks (see below).
; @addr{450a}
@loadPushableTileProperties:
.ifdef ROM_AGES
	ld a,(wActiveCollisions)		; $450a
.else
	ld a,(wActiveGroup)
.endif
	ld hl,_pushableTilePropertiesTable		; $450d
	rst_addAToHl			; $4510
	ld a,(hl)		; $4511
	rst_addAToHl			; $4512
	ld e,Interaction.var31		; $4513
	ld a,(de)		; $4515
	ld b,a			; $4516
--
	ldi a,(hl)		; $4517
	or a			; $4518
	ret z			; $4519
	cp b			; $451a
	jr z,@match		; $451b
	inc hl			; $451d
	inc hl			; $451e
	inc hl			; $451f
	jr --			; $4520

@match:
	; Write data to var31-var34.
	ld (de),a		; $4522
	ldi a,(hl)		; $4523
	inc e			; $4524
	ld (de),a		; $4525
	ldi a,(hl)		; $4526
	inc e			; $4527
	ld (de),a		; $4528
	ldi a,(hl)		; $4529
	inc e			; $452a
	ld (de),a		; $452b
	ret			; $452c


; @addr{452d}
_pushableTilePropertiesTable:
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
	ld e,Interaction.state		; $4581
	ld a,(de)		; $4583
	rst_jumpTable			; $4584
	.dw @state0
	.dw @state1
	.dw @state2
	.dw interactionDelete

@state0:
	ld a,$01		; $458d
	ld (de),a		; $458f
	call interactionInitGraphics		; $4590
	ld a,$06		; $4593
	call objectSetCollideRadius		; $4595
	ld l,Interaction.counter1		; $4598
	ld (hl),$04		; $459a

	; Check for position relative to platform, set direction based on that
	ld a,TILEINDEX_MINECART_PLATFORM		; $459c
	call objectGetRelativePositionOfTile		; $459e
	ld h,d			; $45a1
	ld l,Interaction.direction		; $45a2
	xor $02			; $45a4
	ldi (hl),a		; $45a6

	; Set Interaction.angle
	swap a			; $45a7
	rrca			; $45a9
	ldd (hl),a		; $45aa

	; Set animation based on facing direction
	ld a,(hl)		; $45ab
	and $01			; $45ac
	call interactionSetAnimation		; $45ae

	; Save the minecart in a "static object" slot so the game remembers where it is
	call objectDeleteRelatedObj1AsStaticObject		; $45b1
	call findFreeStaticObjectSlot		; $45b4
	ld a,STATICOBJTYPE_INTERACTION		; $45b7
	call z,objectSaveAsStaticObject		; $45b9

@state1:
	call objectSetPriorityRelativeToLink		; $45bc
	ld a,(wLinkInAir)		; $45bf
	add a			; $45c2
	jr c,+			; $45c3

	; Check for collision, also prevent link from walking through
	call objectPreventLinkFromPassing		; $45c5
	ret nc			; $45c8
+
	ld a,(w1Link.zh)		; $45c9
	or a			; $45cc
	jr nz,@resetCounter	; $45cd

	call checkLinkID0AndControlNormal		; $45cf
	jr nc,@resetCounter	; $45d2

	call objectCheckLinkPushingAgainstCenter		; $45d4
	jr nc,@resetCounter	; $45d7

	ld a,$01		; $45d9
	ld (wForceLinkPushAnimation),a		; $45db
	call interactionDecCounter1		; $45de
	ret nz			; $45e1

	call interactionIncState		; $45e2

	; Force link to jump, lock his speed
	ld a,$81		; $45e5
	ld (wLinkInAir),a		; $45e7
	ld hl,w1Link.speed		; $45ea
	ld (hl),SPEED_80		; $45ed

	ld l,<w1Link.speedZ		; $45ef
	ld (hl),$40		; $45f1
	inc l			; $45f3
	ld (hl),$fe		; $45f4

	call objectGetAngleTowardLink		; $45f6
	xor $10			; $45f9
	ld (w1Link.angle),a		; $45fb
	ret			; $45fe

@resetCounter:
	ld e,Interaction.counter1		; $45ff
	ld a,$04		; $4601
	ld (de),a		; $4603
	ret			; $4604

@state2:
	; Wait for link to reach a certain z position
	ld hl,w1Link.zh		; $4605
	ld a,(hl)		; $4608
	cp $fa			; $4609
	ret c			; $460b

	; Wait for link to start falling
	ld l,<w1Link.speedZ+1		; $460c
	bit 7,(hl)		; $460e
	ret nz			; $4610

	; Set minecart state to $03 (state $03 jumps to interactionDelete).
	ld a,$03		; $4611
	ld (de),a		; $4613

	; Use the "companion" slot to create a minecart.
	; Presumably this is necessary for it to persist between rooms?
	ld hl,w1Companion.enabled		; $4614
	ldi (hl),a		; $4617
	ld (hl),SPECIALOBJECTID_MINECART		; $4618

	; Copy direction, angle
	ld e,Interaction.direction		; $461a
	ld l,SpecialObject.direction		; $461c
	ld a,(de)		; $461e
	ldi (hl),a		; $461f
	inc e			; $4620
	ld a,(de)		; $4621
	ld (hl),a		; $4622

	call objectCopyPosition		; $4623

	; Minecart will be moved, so the static object slot will be updated later.
	jp objectDeleteRelatedObj1AsStaticObject		; $4626


; ==============================================================================
; INTERACID_DUNGEON_KEY_SPRITE
; ==============================================================================
interactionCode17:
	ld e,Interaction.state		; $4629
	ld a,(de)		; $462b
	rst_jumpTable			; $462c
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionIncState		; $4633
	ld l,Interaction.zh		; $4636
	ld (hl),$fc		; $4638
	ld l,Interaction.counter1		; $463a
	ld (hl),$08		; $463c

	; Subid is the tile index of the door being opened; use that to calculate a new
	; subid which will determine the graphic to use.
	ld l,Interaction.subid		; $463e
	ld a,(hl)		; $4640
	ld hl,@keyDoorGraphicTable		; $4641
	call lookupCollisionTable		; $4644
	ld e,Interaction.subid		; $4647
	ld (de),a		; $4649
	call interactionInitGraphics		; $464a

	call objectSetVisible80		; $464d
	ld a,SND_GETSEED		; $4650
	jp playSound		; $4652

@state1:
	call interactionDecCounter1		; $4655
	ret nz			; $4658
	ld (hl),$14		; $4659

	ld l,Interaction.zh		; $465b
	ld (hl),$f8		; $465d

	jp interactionIncState		; $465f

@state2:
	call interactionDecCounter1		; $4662
	ret nz			; $4665
	ld (hl),$0f		; $4666
	jp interactionDelete		; $4668


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
	ld e,Interaction.state		; $468c
	ld a,(de)		; $468e
	rst_jumpTable			; $468f
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionIncState		; $4696
	ld bc,-$200		; $4699
	call objectSetSpeedZ		; $469c
	call interactionSetAlwaysUpdateBit		; $469f
	call interactionInitGraphics		; $46a2
	jp objectSetVisible80		; $46a5

@state1:
	; Decrease speedZ, wait for it to stop moving up
	ld c,$28		; $46a8
	call objectUpdateSpeedZ_paramC		; $46aa
	ld e,Interaction.speedZ+1		; $46ad
	ld a,(de)		; $46af
	bit 7,a			; $46b0
	ret nz			; $46b2

	ld e,Interaction.counter1		; $46b3
	ld a,$3c		; $46b5
	ld (de),a		; $46b7
	jp interactionIncState		; $46b8

@state2:
	call interactionDecCounter1		; $46bb
	ret nz			; $46be
	jp interactionDelete		; $46bf


; ==============================================================================
; INTERACID_FARORES_MEMORY
; ==============================================================================
interactionCode1c:
	call checkInteractionState		; $46c2
	jp nz,interactionRunScript		; $46c5

; Initialization

	ld a,GLOBALFLAG_FINISHEDGAME		; $46c8
	call checkGlobalFlag		; $46ca
	jr nz,+			; $46cd
	call checkIsLinkedGame		; $46cf
	jp z,interactionDelete		; $46d2
+
	call interactionInitGraphics		; $46d5
	call objectSetVisible83		; $46d8

	ld hl,faroresMemoryScript		; $46db
	call interactionSetScript		; $46de

	jp interactionIncState		; $46e1


.ifdef ROM_SEASONS
.include "object_code/common/interactionCode/rupeeRoomRupees.s"
.endif


; ==============================================================================
; INTERACID_DOOR_CONTROLLER
; ==============================================================================
interactionCode1e:
	call interactionDeleteAndRetIfEnabled02		; $46e4
	call returnIfScrollMode01Unset		; $46e7
.ifdef ROM_AGES
	ld a,(wSwitchHookState)		; $46ea
	cp $02			; $46ed
	ret z			; $46ef
.endif

	ld e,Interaction.state		; $46f0
	ld a,(de)		; $46f2
	rst_jumpTable			; $46f3
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01		; $46fc
	ld (de),a		; $46fe

	; "xh" is actually a parameter. It's a value from 0-7; a bit for wActiveTriggers.
	ld h,d			; $46ff
	ld l,Interaction.xh		; $4700
	ld e,Interaction.var3f		; $4702
	ld a,(hl)		; $4704
	ld (de),a		; $4705
	and $07			; $4706
	ld bc,bitTable		; $4708
	add c			; $470b
	ld c,a			; $470c
	ld a,(bc)		; $470d
	ld l,Interaction.var3d		; $470e
	ld (hl),a		; $4710

	; Convert short-form position in yh to full y/x position
	ld l,Interaction.yh		; $4711
	ld e,Interaction.var3e		; $4713
	ld a,(hl)		; $4715
	ld (de),a		; $4716
	ld l,Interaction.yh		; $4717
	call setShortPosition		; $4719

	; Decide what script to run based on subid. The script will decide when to proceed
	; to state 2 (open door) or 3 (close door).
	ld e,Interaction.subid		; $471c
	ld a,(de)		; $471e
	ld hl,@scriptSubidTable		; $471f
	rst_addDoubleIndex			; $4722
	ldi a,(hl)		; $4723
	ld h,(hl)		; $4724
	ld l,a			; $4725
	call interactionSetScript		; $4726
	call @func_47e5		; $4729

@state1:
	call interactionRunScript		; $472c
	jp c,interactionDelete		; $472f

	ld e,Interaction.state2		; $4732
	xor a			; $4734
	ld (de),a		; $4735
	ret			; $4736


; State 2: a door is opening
@state2:
	ld a,(wPaletteThread_mode)		; $4737
	or a			; $473a
	ret nz			; $473b

	ld e,Interaction.state2		; $473c
	ld a,(de)		; $473e
	rst_jumpTable			; $473f
	.dw @state2Substate0
	.dw @state2Substate1

@state2Substate0:
	; The tile at this position must be solid
	call objectCheckTileCollision_allowHoles		; $4744
	jr nc,@gotoState1	; $4747

@interleaveDoorTile:
	ld a,SND_DOORCLOSE		; $4749
	call @playSoundIfInScreenBoundary		; $474b

	ld e,Interaction.angle		; $474e
	ld a,(de)		; $4750
	ld hl,@shutterTiles		; $4751
	rst_addAToHl			; $4754
	ld e,Interaction.var3e		; $4755
	ld a,(de)		; $4757
	ldh (<hFF8C),a	; $4758
	ldi a,(hl)		; $475a
	ldh (<hFF8F),a	; $475b
	ldi a,(hl)		; $475d
	ldh (<hFF8E),a	; $475e
	and $03			; $4760
	call setInterleavedTile		; $4762

	ldh a,(<hActiveObject)	; $4765
	ld d,a			; $4767
	ld h,d			; $4768
	ld l,Interaction.state2		; $4769
	inc (hl)		; $476b

	ld l,Interaction.counter1		; $476c
	ld (hl),$06		; $476e

	; Set the new tile in the room layout (but since we're not calling "setTile", the
	; visuals won't be updated just yet?)
	ld l,Interaction.var3e		; $4770
	ld c,(hl)		; $4772
	ld b,>wRoomLayout		; $4773
	ldh a,(<hFF8F)	; $4775
	ld (bc),a		; $4777
	ret			; $4778

@state2Substate1:
	call interactionDecCounter1		; $4779
	ret nz			; $477c

; Door will now open fully

	call @func_47ee		; $477d
	ld e,Interaction.angle		; $4780
	ld a,(de)		; $4782
	ld hl,@shutterTiles		; $4783
	rst_addAToHl			; $4786
	jr @setTileAndPlaySound		; $4787


; State 3: a door is closing
@state3:
	ld e,Interaction.state2		; $4789
	ld a,(de)		; $478b
	rst_jumpTable			; $478c
	.dw @state3Substate0
	.dw @state3Substate1

@state3Substate0:
.ifdef ROM_AGES
	; The tile at this position must not be solid
	call objectGetTileAtPosition		; $4791
	cp TILEINDEX_SOMARIA_BLOCK			; $4794
	jr z,@interleaveDoorTile	; $4796
.endif
	call objectCheckTileCollision_allowHoles		; $4798
	jr c,@gotoState1	; $479b
	jr @interleaveDoorTile		; $479d

@state3Substate1:
	call interactionDecCounter1		; $479f
	ret nz			; $47a2

; Door will now close fully

	call @checkRespawnLink		; $47a3
	call @func_47f9		; $47a6

	ld e,Interaction.angle		; $47a9
	ld a,(de)		; $47ab
	ld hl,@shutterTiles		; $47ac
	rst_addAToHl			; $47af
	inc hl			; $47b0

@setTileAndPlaySound:
	ld e,Interaction.var3e		; $47b1
	ld a,(de)		; $47b3
	ld c,a			; $47b4
	ld a,(hl)		; $47b5
	call setTile		; $47b6
	ld a,SND_DOORCLOSE		; $47b9
	call @playSoundIfInScreenBoundary		; $47bb

@gotoState1:
	ld e,Interaction.state		; $47be
	ld a,$01		; $47c0
	ld (de),a		; $47c2
	inc e			; $47c3
	xor a			; $47c4
	ld (de),a		; $47c5
	jp @state1		; $47c6

;;
; Force Link to respawn if he's on the same tile as this object.
; @addr{47c9}
@checkRespawnLink:
	ld a,(w1Link.yh)		; $47c9
	and $f0			; $47cc
	ld b,a			; $47ce
	ld a,(w1Link.xh)		; $47cf
	swap a			; $47d2
	and $0f			; $47d4
	or b			; $47d6
	ld b,a			; $47d7
	ld e,Interaction.var3e		; $47d8
	ld a,(de)		; $47da
	cp b			; $47db
	ret nz			; $47dc
	ld a,$02		; $47dd
	ld (wScreenTransitionDelay),a		; $47df
	jp respawnLink		; $47e2

@func_47e5:
	ld e,Interaction.var3e		; $47e5
	ld a,(de)		; $47e7
	ld c,a			; $47e8
	ld b,>wRoomCollisions		; $47e9
	ld a,(bc)		; $47eb
	or a			; $47ec
	ret nz			; $47ed

@func_47ee:
	ld e,Interaction.subid		; $47ee
	ld a,(de)		; $47f0
	cp $04			; $47f1
	ret c			; $47f3
	ld hl,wcc93		; $47f4
	inc (hl)		; $47f7
	ret			; $47f8

@func_47f9:
	ld e,Interaction.subid		; $47f9
	ld a,(de)		; $47fb
	cp $04			; $47fc
	ret c			; $47fe
	ld hl,wcc93		; $47ff
	ld a,(hl)		; $4802
	or a			; $4803
	ret z			; $4804
	dec (hl)		; $4805
	ld a,(hl)		; $4806
	and $7f			; $4807
	ret nz			; $4809
	res 7,(hl)		; $480a
	ret			; $480c

;;
; @param	a	Sound to play
; @addr{480d}
@playSoundIfInScreenBoundary:
	ldh (<hFF8B),a	; $480d
	call objectCheckWithinScreenBoundary		; $480f
	ret nc			; $4812
	ldh a,(<hFF8B)	; $4813
	jp playSound		; $4815


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


; @addr{4838}
@scriptSubidTable:
	/* $00 */ .dw doorOpenerScript
	/* $01 */ .dw stubScript
	/* $02 */ .dw stubScript
	/* $03 */ .dw stubScript
	/* $04 */ .dw doorController_controlledByTriggers_up
	/* $05 */ .dw doorController_controlledByTriggers_right
	/* $06 */ .dw doorController_controlledByTriggers_down
	/* $07 */ .dw doorController_controlledByTriggers_left
	/* $08 */ .dw doorController_shutUntilEnemiesDead_up
	/* $09 */ .dw doorController_shutUntilEnemiesDead_right
	/* $0a */ .dw doorController_shutUntilEnemiesDead_down
	/* $0b */ .dw doorController_shutUntilEnemiesDead_left
	/* $0c */ .dw doorController_minecartDoor_up
	/* $0d */ .dw doorController_minecartDoor_right
	/* $0e */ .dw doorController_minecartDoor_down
	/* $0f */ .dw doorController_minecartDoor_left
	/* $10 */ .dw doorController_closeAfterLinkEnters_up
	/* $11 */ .dw doorController_closeAfterLinkEnters_right
	/* $12 */ .dw doorController_closeAfterLinkEnters_down
	/* $13 */ .dw doorController_closeAfterLinkEnters_left
	/* $14 */ .dw doorController_openWhenTorchesLit_up_2Torches
	/* $15 */ .dw doorController_openWhenTorchesLit_left_2Torches
.ifdef ROM_AGES
	/* $16 */ .dw doorController_openWhenTorchesLit_down_1Torch
	/* $17 */ .dw doorController_openWhenTorchesLit_left_1Torch
.endif
