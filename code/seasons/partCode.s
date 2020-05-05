; ==============================================================================
; PARTID_ITEM_DROP
;
; Variables:
;   relatedObj1: ?
;   var30: ID of relatedObj1
;   var31/var32: Position to move towards?
;   var33: Counter until collisions are enabled (fairy only)
;   var34: Set to $01 when it hits water in a sidescrolling area
; ==============================================================================
partCode01:
	jr z,@normalStatus	; $4113
	cp PARTSTATUS_DEAD			; $4115
	jp z,@linkCollectedItem		; $4117

	; PARTSTATUS_JUST_HIT
	ld e,Part.state		; $411a
	ld a,$03		; $411c
	ld (de),a		; $411e

@normalStatus:
	call @checkCollidedWithLink		; $411f
	ld e,Part.state		; $4122
	ld a,(de)		; $4124
	rst_jumpTable			; $4125
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,(wIsMaplePresent)		; $412e
	or a			; $4131
	jp nz,partDelete		; $4132

	ld e,Part.subid		; $4135
	ld a,(de)		; $4137
	cp ITEM_DROP_100_RUPEES_OR_ENEMY			; $4138
	jr nz,@normalItem	; $413a

	call getRandomNumber_noPreserveVars		; $413c
	cp $e0			; $413f
	jp c,_itemDrop_spawnEnemy		; $4141
.ifdef ROM_SEASONS
	ld a,(wTilesetFlags)		; $4144
	cp (TILESETFLAG_SUBROSIA|TILESETFLAG_OUTDOORS)			; $4147
	jp z,partDelete		; $4149
.endif

@normalItem:
	call _itemDrop_initGfx		; $4144

	ld h,d			; $4147
	ld l,Part.speedZ		; $4148
	ld a,<(-$160)		; $414a
	ldi (hl),a		; $414c
	ld (hl),>(-$160)	; $414d

	ld l,Part.state		; $414f
	inc (hl) ; [state] = 1

	ld a,(wTilesetFlags)		; $4152
	and TILESETFLAG_SIDESCROLL			; $4155
	jr z,@label_11_008	; $4157

	; Sidescrolling only
	inc (hl) ; [state] = 2
	ld l,Part.collisionType		; $415a
	set 7,(hl)		; $415c
	ld l,Part.counter1		; $415e
	ld (hl),240		; $4160
	call objectCheckIsOnHazard		; $4162
	jr nc,@label_11_008	; $4165
	rrca			; $4167
	jr nc,@label_11_008	; $4168

	; On water
	ld e,Part.var34		; $416a
	ld a,$01		; $416c
	ld (de),a		; $416e

	; Back to common code for either sidescrolling or normal rooms
@label_11_008:
	ld e,Part.subid		; $416f
	ld a,(de)		; $4171
	call _itemDrop_initSpeed		; $4172
	ld e,Part.subid		; $4175
	ld a,(de)		; $4177
	jp partSetAnimation		; $4178

@state1:
	call _partCommon_getTileCollisionInFront_allowHoles		; $417b
	call nc,_itemDrop_updateSpeed		; $417e
	ld c,$20		; $4181
	call objectUpdateSpeedZAndBounce		; $4183
	jr c,@doneBouncing			; $4186
	call _itemDrop_checkHitGround		; $4188
	jr nc,@label_11_010	; $418b

@doneBouncing:
	ld h,d			; $418d
	ld l,Part.state		; $418e
	inc (hl) ; [state] = 2
	ld l,Part.counter1		; $4191
	ld (hl),240		; $4193
	call objectSetVisiblec3		; $4195

@label_11_010:
.ifdef ROM_SEASONS
	call _itemDrop_pullOreChunksWithMagnetGloves		; $41a0
	jr c,+
.endif
	call _itemDrop_checkOnHazard		; $4198
	ret c			; $419b
+
	ld e,Part.zh		; $419c
	ld a,(de)		; $419e
	rlca			; $419f
	ret c			; $41a0

	; On solid ground; check for conveyor tiles
	ld bc,$0500		; $41a1
	call objectGetRelativeTile		; $41a4
	ld hl,_itemDrop_conveyorTilesTable		; $41a7
	call lookupCollisionTable		; $41aa
	ret nc			; $41ad
	ld c,a			; $41ae
	ld b,SPEED_80		; $41af
	jp _itemDrop_applySpeed		; $41b1

; Item has stopped bouncing; waiting to be picked up
@state2:
	call _itemDrop_checkSidescrollingConditions		; $41b4
	call _itemDrop_moveTowardPoint		; $41b7
	jp c,@reachedPoint		; $41ba
	call _itemDrop_countdownToDisappear		; $41bd
	jp c,partDelete		; $41c0
	ld e,Part.subid		; $41c3
	ld a,(de)		; $41c5
	or a ; ITEM_DROP_FAIRY
	jr nz,@label_11_010	; $41c7
	jp _itemDrop_updateFairyMovement		; $41c9

@reachedPoint:
	ld h,d			; $41cc
	ld l,Part.var31		; $41cd
	ldi a,(hl)		; $41cf
	ld c,(hl)		; $41d0
	ld l,Part.yh		; $41d1
	ldi (hl),a		; $41d3
	inc l			; $41d4
	ld (hl),c ; [xh]
	jp partDelete		; $41d6


; Triggered by PARTSTATUS_JUST_HIT (ie. from a weapon or Link?)
@state3:
	ld e,Part.state2		; $41d9
	ld a,(de)		; $41db
	or a			; $41dc
	call z,@getRelatedObj1ID		; $41dd
	call objectCheckCollidedWithLink_ignoreZ		; $41e0
	jp c,@linkCollectedItem		; $41e3

	ld a,Object.enabled		; $41e6
	call objectGetRelatedObject1Var		; $41e8
	ldi a,(hl)		; $41eb
	or a			; $41ec
	jr z,++			; $41ed
	ld e,Part.var30		; $41ef
	ld a,(de)		; $41f1
	cp (hl)			; $41f2
	jp z,objectTakePosition		; $41f3
++
	jp partDelete		; $41f6

@getRelatedObj1ID:
	ld h,d			; $41f9
	ld l,e			; $41fa
	inc (hl) ; [state2]
	ld l,Part.zh		; $41fc
	ld (hl),$00		; $41fe
	ld a,Object.id		; $4200
	call objectGetRelatedObject1Var		; $4202
	ld a,(hl)		; $4205
	ld e,Part.var30		; $4206
	ld (de),a		; $4208
	jp objectSetVisible80		; $4209


@checkCollidedWithLink:
	ld e,Part.collisionType		; $420c
	ld a,(de)		; $420e
	rlca			; $420f
	ret nc			; $4210
	call objectCheckCollidedWithLink		; $4211
	ret nc			; $4214

	pop hl ; Return from caller (about to delete self)

@linkCollectedItem:
	ld a,(wLinkDeathTrigger)		; $4216
	or a			; $4219
	jr nz,@deleteSelf	; $421a

	ld e,Part.subid		; $421c
	ld a,(de)		; $421e
	add a			; $421f
	ld hl,@itemDropTreasureTable		; $4220
	rst_addDoubleIndex			; $4223

	ldi a,(hl)		; $4224
	or a			; $4225
	jr z,@deleteSelf	; $4226

	ld b,a			; $4228
	ld a,GOLD_JOY_RING		; $4229
	call cpActiveRing		; $422b
	ldi a,(hl)		; $422e
	jr z,@doubleDrop	; $422f

	or a			; $4231
	jr z,@giveDrop	; $4232
	call cpActiveRing		; $4234
	jr nz,@giveDrop	; $4237

@doubleDrop:
	inc hl			; $4239
@giveDrop:
	ld c,(hl)		; $423a
	ld a,b			; $423b
	call giveTreasure		; $423c
	ld e,Part.subid		; $423f
	ld a,(de)		; $4241
	cp ITEM_DROP_50_ORE_CHUNKS			; $4242
	jr nz,@deleteSelf	; $4244
	call getThisRoomFlags		; $4246
	set 5,(hl)		; $4249
@deleteSelf:
	jp partDelete		; $424b


; Data format:
;   b0: Treasure to give
;   b1: Ring to check for (in addition to gold joy ring)
;   b2: Amount to give without ring
;   b3: Amount to give with ring
@itemDropTreasureTable:
	.db TREASURE_HEART_REFILL,  BLUE_JOY_RING,  $18, $30 ; ITEM_DROP_FAIRY
	.db TREASURE_HEART_REFILL,  BLUE_JOY_RING,  $04, $08 ; ITEM_DROP_HEART
	.db TREASURE_RUPEES,        RED_JOY_RING,   RUPEEVAL_1, RUPEEVAL_2  ; ITEM_DROP_1_RUPEE
	.db TREASURE_RUPEES,        RED_JOY_RING,   RUPEEVAL_5, RUPEEVAL_10 ; ITEM_DROP_5_RUPEES
	.db TREASURE_BOMBS,         $00,            $04, $08 ; ITEM_DROP_BOMBS
	.db TREASURE_EMBER_SEEDS,   $00,            $05, $0a ; ITEM_DROP_EMBER_SEEDS
	.db TREASURE_SCENT_SEEDS,   $00,            $05, $0a ; ITEM_DROP_SCENT_SEEDS
	.db TREASURE_PEGASUS_SEEDS, $00,            $05, $0a ; ITEM_DROP_PEGASUS_SEEDS
	.db TREASURE_GALE_SEEDS,    $00,            $05, $0a ; ITEM_DROP_GALE_SEEDS
	.db TREASURE_MYSTERY_SEEDS, $00,            $05, $0a ; ITEM_DROP_MYSTERY_SEEDS
	.db $00,                    $00,            $00, $00 ; ITEM_DROP_0a
	.db $00,                    $00,            $00, $00 ; ITEM_DROP_0b
	.db TREASURE_ORE_CHUNKS,    GREEN_JOY_RING, RUPEEVAL_1,   RUPEEVAL_2   ; ITEM_DROP_1_ORE_CHUNK
	.db TREASURE_ORE_CHUNKS,    GREEN_JOY_RING, RUPEEVAL_10,  RUPEEVAL_20  ; ITEM_DROP_10_ORE_CHUNKS
	.db TREASURE_ORE_CHUNKS,    GREEN_JOY_RING, RUPEEVAL_50,  RUPEEVAL_100 ; ITEM_DROP_50_ORE_CHUNKS
	.db TREASURE_RUPEES,        RED_JOY_RING,   RUPEEVAL_100, RUPEEVAL_200 ; ITEM_DROP_100_RUPEES_OR_ENEMY


;;
; @addr{428e}
_itemDrop_initGfx:
	ld e,Part.subid		; $428e
	ld a,(de)		; $4290
	ld hl,@spriteData		; $4291
	rst_addDoubleIndex			; $4294
	ld e,Part.oamTileIndexBase		; $4295
	ld a,(de)		; $4297
	add (hl)		; $4298
	ld (de),a		; $4299
	inc hl			; $429a
	dec e			; $429b
	ld a,(hl)		; $429c
	ld (de),a ; [Part.oamFlags]
	dec e			; $429e
	ld (de),a ; [Part.oamFlagsBackup]
	jp objectSetVisiblec1		; $42a0


; Data format:
;   b0: Offset relative to oamTileIndexBase
;   b1: OAM flags
@spriteData:
	.db $00 $02 ; ITEM_DROP_FAIRY
	.db $02 $05 ; ITEM_DROP_HEART
	.db $04 $00 ; ITEM_DROP_1_RUPEE
	.db $06 $05 ; ITEM_DROP_5_RUPEES
	.db $10 $04 ; ITEM_DROP_BOMBS
	.db $12 $02 ; ITEM_DROP_EMBER_SEEDS
	.db $14 $03 ; ITEM_DROP_SCENT_SEEDS
	.db $16 $01 ; ITEM_DROP_PEGASUS_SEEDS
	.db $18 $01 ; ITEM_DROP_GALE_SEEDS
	.db $1a $00 ; ITEM_DROP_MYSTERY_SEEDS
	.db $1c $00 ; ITEM_DROP_0a
	.db $1e $00 ; ITEM_DROP_0b
	.db $0c $01 ; ITEM_DROP_1_ORE_CHUNK
	.db $0c $02 ; ITEM_DROP_10_ORE_CHUNKS
	.db $0c $03 ; ITEM_DROP_50_ORE_CHUNKS
	.db $08 $04 ; ITEM_DROP_100_RUPEES_OR_ENEMY


;;
; @param[out]	cflag	c if time to disappear
; @addr{42c3}
_itemDrop_countdownToDisappear:
	ld a,(wFrameCounter)		; $42c3
	xor d			; $42c6
	rrca			; $42c7
	ret nc			; $42c8

	ld h,d			; $42c9
	ld l,Part.var33		; $42ca
	ld a,(hl)		; $42cc
	or a			; $42cd
	jr z,++			; $42ce

	; Fairy only: countdown until collisions are enabled
	dec (hl)		; $42d0
	ret nz			; $42d1
	ld l,Part.collisionType		; $42d2
	set 7,(hl)		; $42d4
++
	call partCommon_decCounter1IfNonzero		; $42d6
	jr z,@disappear	; $42d9

	; Flickering
	ld a,(hl)		; $42db
	cp 60			; $42dc
	ret nc			; $42de
	ld l,Part.visible		; $42df
	ld a,(hl)		; $42e1
	xor $80			; $42e2
	ld (hl),a		; $42e4
	ret			; $42e5

@disappear:
	scf			; $42e6
	ret			; $42e7

;;
; @param	a	Subid
; @addr{42e8}
_itemDrop_initSpeed:
	ld h,d			; $42e8
	or a			; $42e9
	jr z,@fairy	; $42ea
	ld e,Part.var03		; $42ec
	ld a,(de) ; Check if dug up from shovel?
	rrca			; $42ef
	ret nc			; $42f0
	ld l,Part.speed		; $42f1
	ld (hl),SPEED_a0		; $42f3
	ret			; $42f5

@fairy:
	ld l,Part.zh		; $42f6
	ld a,(hl)		; $42f8
	ld (hl),$00		; $42f9
	ld l,Part.yh		; $42fb
	add (hl)		; $42fd
	ld (hl),a		; $42fe
	jp _itemDrop_chooseRandomFairyMovement		; $42ff

;;
; @addr{4302}
_itemDrop_updateSpeed:
	call objectCheckTileCollision_allowHoles		; $4302
	ret c			; $4305
	jp objectApplySpeed		; $4306

;;
; @addr{4309}
_itemDrop_spawnEnemy:
	ld c,a			; $4309
	ld a,(wDiggingUpEnemiesForbidden)		; $430a
	or a			; $430d
	jr nz,@delete	; $430e

.ifdef ROM_SEASONS
	ld b,ENEMYID_PODOBOO_TOWER		; $431d
	ld a,(wTilesetFlags)		; $431f
	cp (TILESETFLAG_SUBROSIA|TILESETFLAG_OUTDOORS)			; $4322
	jr z,+	; $4324
.endif

	ld a,c			; $4310
	and $07			; $4311
	ld hl,@enemiesToSpawn		; $4313
	rst_addAToHl			; $4316
	ld b,(hl)		; $4317
+
	call getFreeEnemySlot		; $4318
	jr nz,@delete	; $431b

	ld (hl),b		; $431d
	call objectCopyPosition		; $431e
	ld e,Part.var03		; $4321
	ld a,(de)		; $4323
	ld l,Enemy.subid		; $4324
	ld (hl),a		; $4326
@delete:
	jp partDelete		; $4327

@enemiesToSpawn:
	.db ENEMYID_ROPE,   ENEMYID_ROPE,   ENEMYID_ROPE,   ENEMYID_BEETLE
	.db ENEMYID_BEETLE, ENEMYID_BEETLE, ENEMYID_BEETLE, ENEMYID_BEETLE

;;
; Delete and return from caller if it goes out of bounds in a sidescrolling room
; @addr{4332}
_itemDrop_checkSidescrollingConditions:
	ld a,(wTilesetFlags)		; $4332
	and TILESETFLAG_SIDESCROLL			; $4335
	ret z			; $4337
	ld e,Part.subid		; $4338
	ld a,(de)		; $433a
	or a			; $433b
	ret z ; Return if it's ITEM_DROP_FAIRY

	ld a,$20		; $433d
	call objectUpdateSpeedZ_sidescroll		; $433f
	jr c,@checkY	; $4342

	ld e,Part.var34		; $4344
	ld a,(de)		; $4346
	rrca			; $4347
	jr nc,@checkY	; $4348

	; Hit water; fix speedZ to a specific value?
	ld b,$01		; $434a
	ld a,(hl) ; [speedZ+1]
	bit 7,a			; $434d
	jr z,+			; $434f
	ld b,$ff		; $4351
	inc a			; $4353
+
	cp $01			; $4354
	ret c			; $4356
	ld (hl),b ; [speedZ+1]
	dec l			; $4358
	ld (hl),$00 ; [speedZ]

@checkY:
	ld e,Part.yh		; $435b
	ld a,(de)		; $435d
	cp $b0			; $435e
	ret c			; $4360
	pop hl			; $4361
	jp partDelete		; $4362

;;
; Enables collisions once the item comes to rest
;
; @param[out]	cflag	c if it's a fairy and some condition is met?
; @addr{4365}
_itemDrop_checkHitGround:
	ld e,Part.subid		; $4365
	ld a,(de)		; $4367
	or a			; $4368
	jr z,@fairy	; $4369

	ld e,Part.speedZ+1		; $436b
	ld a,(de)		; $436d
	and $80			; $436e
	ret nz			; $4370
	ld h,d			; $4371
	ld l,Part.collisionType		; $4372
	set 7,(hl)		; $4374
	ret			; $4376

@fairy:
	ld e,Part.zh		; $4377
	ld a,(de)		; $4379
	cp $fa			; $437a
	ret nc			; $437c
	ld h,d			; $437d
	ld l,e			; $437e
	ld (hl),$fa ; [Part.zh]
	ld l,Part.var33		; $4381
	ld (hl),$05		; $4383
	ret			; $4385

;;
; @param[out]	cflag	c if it's over a hazard (and deleted itself)
; @addr{4386}
_itemDrop_checkOnHazard:
	call objectCheckIsOnHazard		; $4386
	jr c,@onHazard	; $4389

	ld e,Part.var34		; $438b
	ld a,(de)		; $438d
	rrca			; $438e
	ret nc			; $438f

	ld b,INTERACID_SPLASH		; $4390
	xor a			; $4392
	jr @onWaterSidescrolling		; $4393

@onHazard:
	rrca			; $4395
	jr c,@onWater	; $4396
	rrca			; $4398
	ld b,INTERACID_LAVASPLASH		; $4399
	jr nc,@replaceWithAnimation	; $439b

	call objectCreateFallingDownHoleInteraction		; $439d
	jr @delete		; $43a0

@replaceWithAnimation:
	call objectCreateInteractionWithSubid00		; $43a2
@delete:
	call partDelete		; $43a5
	scf			; $43a8
	ret			; $43a9

@onWater:
	ld b,INTERACID_SPLASH		; $43aa
	ld a,(wTilesetFlags)		; $43ac
	and TILESETFLAG_SIDESCROLL			; $43af
	jr z,@replaceWithAnimation	; $43b1

	ld e,Part.var34		; $43b3
	ld a,(de)		; $43b5
	rrca			; $43b6
	ccf			; $43b7
	ret nc			; $43b8

	ld a,$01		; $43b9

@onWaterSidescrolling:
	ld (de),a ; [var34]
	jp objectCreateInteractionWithSubid00		; $43bc

;;
; @addr{43bf}
_itemDrop_updateFairyMovement:
	ld h,d			; $43bf
	ld l,Part.counter2		; $43c0
	dec (hl)		; $43c2
	jr z,_itemDrop_chooseRandomFairyMovement	; $43c3
	call _partCommon_getTileCollisionInFront		; $43c5
	inc a			; $43c8
	jp nz,objectApplySpeed		; $43c9

;;
; Initializes speed, counter2, and angle randomly.
; @addr{43cc}
_itemDrop_chooseRandomFairyMovement:
	call getRandomNumber_noPreserveVars		; $43cc
	and $3e			; $43cf
	add $08			; $43d1
	ld e,Part.counter2		; $43d3
	ld (de),a		; $43d5

	call getRandomNumber_noPreserveVars		; $43d6
	and $03			; $43d9
	ld hl,@speedTable		; $43db
	rst_addAToHl			; $43de
	ld e,Part.speed		; $43df
	ld a,(hl)		; $43e1
	ld (de),a		; $43e2

	call getRandomNumber_noPreserveVars		; $43e3
	and $1e			; $43e6
	ld h,d			; $43e8
	ld l,Part.angle		; $43e9
	ld (hl),a		; $43eb
	and $0f			; $43ec
	ret z			; $43ee

	bit 4,(hl)		; $43ef
	ld l,Part.oamFlagsBackup		; $43f1
	ld a,(hl)		; $43f3
	res 5,a			; $43f4
	jr nz,+			; $43f6
	set 5,a			; $43f8
+
	ldi (hl),a		; $43fa
	ld (hl),a		; $43fb
	ret			; $43fc

@speedTable:
	.db SPEED_40, SPEED_80, SPEED_c0, SPEED_100

;;
; Moves toward position stored in var31/var32 if it's not there already?
;
; @param[out]	cflag	c if reached target position
; @addr{4401}
_itemDrop_moveTowardPoint:
	ld l,Part.var31		; $4401
	ld h,d			; $4403
	xor a			; $4404
	ld b,(hl) ; [var31]
	ldi (hl),a		; $4406
	ld c,(hl) ; [var32]
	ldi (hl),a		; $4408
	or b			; $4409
	ret z			; $440a

	push bc			; $440b
	call objectCheckContainsPoint		; $440c
	pop bc			; $440f
	ret c			; $4410

	call objectGetRelativeAngle		; $4411
	ld c,a			; $4414
	ld b,SPEED_40		; $4415
	ld e,Part.angle		; $4417
	call objectApplyGivenSpeed		; $4419
	xor a			; $441c
	ret			; $441d

.ifdef ROM_SEASONS
_itemDrop_pullOreChunksWithMagnetGloves:
	ld e,Part.subid		; $4434
	ld a,(de)		; $4436
	sub $0c			; $4437
	cp $03			; $4439
	ret nc			; $443b
	; ore chunks
	ld a,(wMagnetGloveState)		; $443c
	or a			; $443f
	ret z			; $4440
	call objectGetAngleTowardLink		; $4441
	ld c,a			; $4444
	ld h,d			; $4445
	ld l,Part.yh		; $4446
	ld a,(w1Link.yh)		; $4448
	sub (hl)		; $444b
	jr nc,+			; $444c
	cpl			; $444e
	inc a			; $444f
+
	ld b,a			; $4450
	ld l,Part.xh		; $4451
	ld a,(w1Link.xh)		; $4453
	sub (hl)		; $4456
	jr nc,+			; $4457
	cpl			; $4459
	inc a			; $445a
+
	cp b			; $445b
	jr nc,+			; $445c
	ld a,b			; $445e
+
	and $f0			; $445f
	swap a			; $4461
	bit 3,a			; $4463
	jr z,+			; $4465
	ld a,$07		; $4467
+
	ld hl,_itemDrop_magnetGlovePullSpeed		; $4469
	rst_addAToHl			; $446c
	ld b,(hl)		; $446d
.endif

;;
; @param	b	Speed
; @param	c	Angle
; @addr{441e}
_itemDrop_applySpeed:
	push bc			; $441e
	ld a,c			; $441f
	call _partCommon_getTileCollisionAtAngle_allowHoles		; $4420
	pop bc			; $4423
	ret c			; $4424
	ld e,Part.angle		; $4425
	call objectApplyGivenSpeed		; $4427
	scf			; $442a
	ret			; $442b

.ifdef ROM_SEASONS
_itemDrop_magnetGlovePullSpeed:
	.db SPEED_280 SPEED_280 SPEED_200 SPEED_180
	.db SPEED_100 SPEED_0c0 SPEED_080 SPEED_040
.endif

_itemDrop_conveyorTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES
@collisions2:
@collisions5:
	.db TILEINDEX_CONVEYOR_UP    $00
	.db TILEINDEX_CONVEYOR_RIGHT $08
	.db TILEINDEX_CONVEYOR_DOWN  $10
	.db TILEINDEX_CONVEYOR_LEFT  $18
@collisions0:
@collisions1:
@collisions3:
@collisions4:
	.db $00
.else
@collisions4:
	.db TILEINDEX_CONVEYOR_UP    $00
	.db TILEINDEX_CONVEYOR_RIGHT $08
	.db TILEINDEX_CONVEYOR_DOWN  $10
	.db TILEINDEX_CONVEYOR_LEFT  $18
@collisions0:
@collisions1:
@collisions2:
@collisions3:
@collisions5:
	.db $00
.endif


; ==============================================================================
; PARTID_ENEMY_DESTROYED
; ==============================================================================
partCode02:
	ld e,Part.state		; $4441
	ld a,(de)		; $4443
	or a			; $4444
	call z,@initialize		; $4445
	call partAnimate		; $4448
	ld a,(wFrameCounter)		; $444b
	rrca			; $444e
	jr c,++			; $444f
	ld e,Part.oamFlags		; $4451
	ld a,(de)		; $4453
	xor $01			; $4454
	ld (de),a		; $4456
++
	ld e,Part.animParameter		; $4457
	ld a,(de)		; $4459
	or a			; $445a
	ret z			; $445b

	call @decCounter2		; $445c
	ld a,(de) ; [counter2]
	rlca			; $4460
	jp c,partDelete		; $4461

	xor a			; $4464
	call decideItemDrop		; $4465
	jp z,partDelete		; $4468
	ld b,PARTID_ITEM_DROP		; $446b
	jp objectReplaceWithID		; $446d

@initialize:
	inc a			; $4470
	ld (de),a ; [state] = 1
	ld e,Part.knockbackCounter		; $4472
	ld a,(de)		; $4474
	rlca			; $4475
	ld a,$01		; $4476
	call c,partSetAnimation		; $4478
	jp objectSetVisible82		; $447b

@decCounter2:
	ld e,Part.counter2		; $447e
	ld a,(de)		; $4480
	rrca			; $4481
	ret nc			; $4482
	jp decNumEnemies		; $4483


; ==============================================================================
; PARTID_ORB
;
; Variables:
;   var03: Bitset to use with wToggleBlocksState (derived from subid)
; ==============================================================================
partCode03:
	cp PARTSTATUS_JUST_HIT			; $4486
	jr nz,@notJustHit	; $4488

	; Just hit
	ld a,(wToggleBlocksState)		; $448a
	ld h,d			; $448d
	ld l,Part.var03		; $448e
	xor (hl)		; $4490
	ld (wToggleBlocksState),a		; $4491
	ld l,Part.oamFlagsBackup		; $4494
	ld a,(hl)		; $4496
	and $01			; $4497
	inc a			; $4499
	ldi (hl),a		; $449a
	ld (hl),a		; $449b
	ld a,SND_SWITCH		; $449c
	jp playSound		; $449e

@notJustHit:
	ld e,Part.state		; $44a1
	ld a,(de)		; $44a3
	or a			; $44a4
	ret nz			; $44a5

@state0:
	inc a			; $44a6
	ld (de),a		; $44a7
	call objectMakeTileSolid		; $44a8
	ld h,Part.zh		; $44ab
	ld (hl),$0a		; $44ad

	ld h,d			; $44af
	ld l,Part.subid		; $44b0
	ldi a,(hl)		; $44b2
	and $07			; $44b3
	ld bc,bitTable		; $44b5
	add c			; $44b8
	ld c,a			; $44b9
	ld a,(bc)		; $44ba
	ld (hl),a ; [var03]

	ld a,(wToggleBlocksState)		; $44bc
	and (hl)		; $44bf
	ld a,$01		; $44c0
	jr z,+			; $44c2
	inc a			; $44c4
+
	ld l,Part.oamFlagsBackup		; $44c5
	ldi (hl),a		; $44c7
	ld (hl),a		; $44c8
	jp objectSetVisible82		; $44c9


; ==============================================================================
; PARTID_BOSS_DEATH_EXPLOSION
; ==============================================================================
partCode04:
	ld e,Part.state		; $44cc
	ld a,(de)		; $44ce
	or a			; $44cf
	jr z,@state0	; $44d0

@state1:
	ld e,Part.animParameter		; $44d2
	ld a,(de)		; $44d4
	inc a			; $44d5
	jp nz,partAnimate		; $44d6

	call decNumEnemies		; $44d9
	jr nz,@delete	; $44dc

	ld e,Part.subid		; $44de
	ld a,(de)		; $44e0
	or a			; $44e1
	jr z,@delete	; $44e2

	xor a			; $44e4
	call decideItemDrop		; $44e5
	jr z,@delete	; $44e8
	ld b,PARTID_ITEM_DROP		; $44ea
	jp objectReplaceWithID		; $44ec

@delete:
	jp partDelete		; $44ef

@state0:
	inc a			; $44f2
	ld (de),a ; [state] = 1
	ld e,Part.subid		; $44f4
	ld a,(de)		; $44f6
	or a			; $44f7
	ld a,SND_BIG_EXPLOSION		; $44f8
	call nz,playSound		; $44fa
	jp objectSetVisible80		; $44fd


; ==============================================================================
; PARTID_SWITCH
;
; Variables:
;   var30: Position of tile it's on
; ==============================================================================
partCode05:
	jr z,@normalStatus	; $4500

	; Just hit
	ld a,(wSwitchState)		; $4502
	ld h,d			; $4505
	ld l,Part.subid		; $4506
	xor (hl)		; $4508
	ld (wSwitchState),a		; $4509
	call @updateTile		; $450c
	ld a,SND_SWITCH		; $450f
	jp playSound		; $4511

@normalStatus:
	ld e,Part.state		; $4514
	ld a,(de)		; $4516
	or a			; $4517
	ret nz			; $4518

@state0:
	ld h,d			; $4519
	ld l,e			; $451a
	inc (hl) ; [state] = 1
	ld l,Part.zh		; $451c
	ld (hl),$fa		; $451e
	call objectGetShortPosition		; $4520
	ld e,Part.var30		; $4523
	ld (de),a		; $4525
	ret			; $4526

@updateTile:
	ld l,Part.var30		; $4527
	ld c,(hl)		; $4529
	ld a,(wActiveGroup)		; $452a
	or a			; $452d
	jr z,@flipOverworldSwitch	; $452e

	; Dungeon
	ld hl,wSwitchState		; $4530
	ld e,Part.subid		; $4533
	ld a,(de)		; $4535
	and (hl)		; $4536
	ld a,TILEINDEX_DUNGEON_SWITCH_OFF		; $4537
	jr z,+			; $4539
	inc a ; TILEINDEX_DUNGEON_SWITCH_ON
+
	jp setTile		; $453c

@flipOverworldSwitch:
	ld a,TILEINDEX_OVERWORLD_SWITCH_ON		; $453f
	call setTile		; $4541
	ld b,>wRoomLayout		; $4544
	xor a			; $4546
	ld (bc),a		; $4547
	call getThisRoomFlags		; $4548
	set 6,(hl)		; $454b
	jp partDelete		; $454d


; ==============================================================================
; PARTID_LIGHTABLE_TORCH
; ==============================================================================
partCode06:
	jr z,@normalStatus			; $4550

	; Just hit
	ld h,d			; $4552
	ld l,Part.subid		; $4553
	ld a,(hl)		; $4555
	cp $02			; $4556
	jr z,@normalStatus			; $4558

	ld l,Part.counter2		; $455a
	ldd a,(hl)		; $455c
	ld (hl),a ; [counter1] = [counter2]
	ld l,Part.state		; $455e
	ld (hl),$02		; $4560

@normalStatus:
	ld e,Part.subid		; $4562
	ld a,(de)		; $4564
	rst_jumpTable			; $4565
	.dw @subid0
	.dw @subid1
	.dw @subid2


; Subid 0: Once the torch is lit, it stays lit.
@subid0:
	ld e,Part.state		; $456c
	ld a,(de)		; $456e
	rst_jumpTable			; $456f
	.dw @gotoState1
	.dw @ret
	.dw @subid0State2

@gotoState1:
	ld a,$01		; $4576
	ld (de),a		; $4578

@ret:
	ret			; $4579

@subid0State2:
	ld hl,wNumTorchesLit		; $457a
	inc (hl)		; $457d
	ld a,SND_LIGHTTORCH		; $457e
	call playSound		; $4580
	call objectGetShortPosition		; $4583
	ld c,a			; $4586

	ld a,(wActiveGroup)		; $4587
	or a			; $458a
	ld a,TILEINDEX_OVERWORLD_LIT_TORCH		; $458b
	jr z,+			; $458d
	ld a,TILEINDEX_LIT_TORCH		; $458f
+
	call setTile		; $4591
	jp partDelete		; $4594


; Subid 1: Once lit, the torch stays lit for [counter2] frames.
@subid1:
	ld e,Part.state		; $4597
	ld a,(de)		; $4599
	rst_jumpTable			; $459a
	.dw @gotoState1
	.dw @ret
	.dw @subid1State2
	.dw @subid1State3

@subid1State2:
	ld h,d			; $45a3
	ld l,e			; $45a4
	inc (hl) ; [state] = 3

	ld l,Part.collisionType		; $45a6
	res 7,(hl)		; $45a8

	; [counter1] = [counter2]
	ld l,Part.counter2		; $45aa
	ldd a,(hl)		; $45ac
	ld (hl),a		; $45ad

	ld hl,wNumTorchesLit		; $45ae
	inc (hl)		; $45b1
	ld a,SND_LIGHTTORCH		; $45b2
	call playSound		; $45b4

	call objectGetShortPosition		; $45b7
	ld c,a			; $45ba
	ld a,TILEINDEX_LIT_TORCH		; $45bb
	jr @setTile		; $45bd

@subid1State3:
	ld a,(wFrameCounter)		; $45bf
	and $03			; $45c2
	ret nz			; $45c4
	call partCommon_decCounter1IfNonzero		; $45c5
	ret nz			; $45c8

	ld l,Part.collisionType		; $45c9
	set 7,(hl)		; $45cb
	ld l,Part.state		; $45cd
	ld (hl),$01		; $45cf

	ld hl,wNumTorchesLit		; $45d1
	dec (hl)		; $45d4

	call objectGetShortPosition		; $45d5
	ld c,a			; $45d8
	ld a,TILEINDEX_UNLIT_TORCH		; $45d9
	jr @setTile		; $45db


; Subid 2: ?
@subid2:
	ld e,Part.state		; $45dd
	ld a,(de)		; $45df
	rst_jumpTable			; $45e0
	.dw @gotoState1
	.dw @subid2State1
	.dw @subid2State2
	.dw @subid2State3
	.dw @subid2State4

@subid2State1:
	call @getTileAtRelatedObjPosition		; $45eb
	cp TILEINDEX_LIT_TORCH			; $45ee
	ret z			; $45f0

	ld h,d			; $45f1
	ld l,Part.state		; $45f2
	inc (hl)		; $45f4
	ld l,Part.counter1		; $45f5
	ld (hl),$f0		; $45f7
	ret			; $45f9

@subid2State2:
	call partCommon_decCounter1IfNonzero		; $45fa
	jp nz,@gotoState1IfTileAtRelatedObjPositionIsNotLit		; $45fd

	; [state] = 3
	ld l,e			; $4600
	inc (hl)		; $4601

	ld hl,wNumTorchesLit		; $4602
	dec (hl)		; $4605
	call objectGetShortPosition		; $4606
	ld c,a			; $4609
	ld a,TILEINDEX_UNLIT_TORCH		; $460a
@setTile:
	jp setTile		; $460c

@subid2State3:
	call @getTileAtRelatedObjPosition		; $460f
	cp TILEINDEX_UNLIT_TORCH			; $4612
	ret z			; $4614
	ld e,Part.state		; $4615
	ld a,$04		; $4617
	ld (de),a		; $4619
	ret			; $461a

@subid2State4:
	ld a,$01		; $461b
	ld (de),a ; [state]
	ld hl,wNumTorchesLit		; $461e
	inc (hl)		; $4621
	call objectGetShortPosition		; $4622
	ld c,a			; $4625
	ld a,TILEINDEX_LIT_TORCH		; $4626
	jr @setTile		; $4628

;;
; @addr{4636}
@getTileAtRelatedObjPosition:
	ld a,Object.yh		; $462a
	call objectGetRelatedObject2Var		; $462c
	ld b,(hl)		; $462f
	ld l,Part.xh		; $4630
	ld c,(hl)		; $4632
	jp getTileAtPosition		; $4633

@gotoState1IfTileAtRelatedObjPositionIsNotLit:
	call @getTileAtRelatedObjPosition		; $4636
	cp TILEINDEX_LIT_TORCH			; $4639
	ret nz			; $463b
	ld e,Part.state		; $463c
	ld a,$01		; $463e
	ld (de),a		; $4640
	ret			; $4641


; ==============================================================================
; PARTID_SHADOW
;
; Variables:
;   relatedObj1: Object that this shadow is for
;   var30: ID of relatedObj1 (deletes self if it changes)
; ==============================================================================
partCode07:
	ld e,Part.state		; $4642
	ld a,(de)		; $4644
	or a			; $4645
	call z,@initialize		; $4646

	; If parent's ID changed, delete self
	ld a,Object.id		; $4649
	call objectGetRelatedObject1Var		; $464b
	ld e,Part.var30		; $464e
	ld a,(de)		; $4650
	cp (hl)			; $4651
	jp nz,partDelete		; $4652

	; Take parent's position, with offset
	ld a,Object.yh		; $4655
	call objectGetRelatedObject1Var		; $4657
	ld e,Part.var03		; $465a
	ld a,(de)		; $465c
	ld b,a			; $465d
	ld c,$00		; $465e
	call objectTakePositionWithOffset		; $4660

	xor a			; $4663
	ld (de),a ; [this.zh] = 0

	ld a,(hl) ; [parent.zh]
	or a			; $4666
	jp z,objectSetInvisible		; $4667

	; Flicker visibility
	ld e,Part.visible		; $466a
	ld a,(de)		; $466c
	xor $80			; $466d
	ld (de),a		; $466f

	ld e,Part.subid		; $4670
	ld a,(de)		; $4672
	add a			; $4673
	ld bc,@animationIndices		; $4674
	call addDoubleIndexToBc		; $4677

	; Set shadow size based on how close the parent is to the ground
	ld a,(hl) ; [parent.zh]
	cp $e0			; $467b
	jr nc,@setAnim	; $467d
	inc bc			; $467f
	cp $c0			; $4680
	jr nc,@setAnim	; $4682
	inc bc			; $4684
	cp $a0			; $4685
	jr nc,@setAnim	; $4687
	inc bc			; $4689

@setAnim:
	ld a,(bc)		; $468a
	jp partSetAnimation		; $468b

@animationIndices:
	.db $01 $01 $00 $00 ; Subid 0
	.db $02 $01 $01 $00 ; Subid 1
	.db $03 $02 $01 $00 ; Subid 2

@initialize:
	inc a			; $469a
	ld (de),a ; [state] = 1

	ld a,Object.id		; $469c
	call objectGetRelatedObject1Var		; $469e
	ld e,Part.var30		; $46a1
	ld a,(hl)		; $46a3
	ld (de),a		; $46a4

	jp objectSetVisible83		; $46a5


; ==============================================================================
; PARTID_DARK_ROOM_HANDLER
;
; Variables:
;   counter1: Number of lightable torches in the room
;   counter2: Number of torches currently lit (last time it checked)
; ==============================================================================
partCode08:
	ld a,(wPaletteThread_mode)		; $46a8
	or a			; $46ab
	ret nz			; $46ac

	ld a,(wScrollMode)		; $46ad
	and $01			; $46b0
	ret z			; $46b2

	ld e,Part.state		; $46b3
	ld a,(de)		; $46b5
	or a			; $46b6
	call z,@state0		; $46b7

@state1:
	ld h,d			; $46ba
	ld l,Part.counter2		; $46bb
	ld b,(hl)		; $46bd
	ld a,(wNumTorchesLit)		; $46be
	cp (hl)			; $46c1
	ret z			; $46c2

	; No torches lit?
	ldd (hl),a ; [counter2]
	or a			; $46c4
	jp z,darkenRoom		; $46c5

	; All torches lit?
	cp (hl) ; [counter1]
	jp z,brightenRoom		; $46c9

	ld a,(wPaletteThread_parameter)		; $46cc
	cp $f7			; $46cf
	ret z			; $46d1

	; Check if # of lit torches increased or decreased
	ld a,(wNumTorchesLit)		; $46d2
	cp b			; $46d5
	jp nc,brightenRoomLightly		; $46d6
	jp darkenRoomLightly		; $46d9

;;
; @param	l	Position of an unlit torch
; @param[out]	c	Incremented
; @addr{46dc}
@spawnLightableTorch:
	push hl			; $46dc
	push bc			; $46dd
	ld c,l			; $46de
	call getFreePartSlot		; $46df
	jr nz,+++		; $46e2
	ld (hl),PARTID_LIGHTABLE_TORCH		; $46e4
	inc l			; $46e6
	ld e,l			; $46e7
	ld a,(de)		; $46e8
	ld (hl),a ; [child.subid] = [this.subid]

	; Set length of time the torch can remain lit
	ld e,Part.yh		; $46ea
	ld a,(de)		; $46ec
	and $f0			; $46ed
	ld l,a			; $46ef
	ld e,Part.xh		; $46f0
	ld a,(de)		; $46f2
	and $f0			; $46f3
	swap a			; $46f5
	or l			; $46f7
	ld l,Part.counter2		; $46f8
	ld (hl),a		; $46fa

	ld l,Part.yh		; $46fb
	call setShortPosition_paramC		; $46fd
+++
	pop bc			; $4700
	pop hl			; $4701
	inc c			; $4702
	ret			; $4703

@state0:
	inc a			; $4704
	ld (de),a ; [state] = 1

	ld e,Part.counter1		; $4706
	ld a,(de)		; $4708
	ld c,a			; $4709

	; Search for lightable torches
	ld hl,wRoomLayout		; $470a
	ld b,LARGE_ROOM_HEIGHT << 4		; $470d
--
	ld a,(hl)		; $470f
	cp TILEINDEX_UNLIT_TORCH			; $4710
	call z,@spawnLightableTorch		; $4712
	inc l			; $4715
	dec b			; $4716
	jr nz,--		; $4717

	ld e,Part.counter1		; $4719
	ld a,c			; $471b
	ld (de),a		; $471c
	call objectGetShortPosition		; $471d
	ld e,Part.yh		; $4720
	ld (de),a		; $4722
	ret			; $4723


; ==============================================================================
; PARTID_BUTTON
;
; Variables:
;   var03: Bit index (copied from subid ignoring bit 7)
;   counter1: ?
;   var30: 1 if button is pressed
; ==============================================================================
partCode09:
	ld e,Part.state		; $4724
	ld a,(de)		; $4726
	or a			; $4727
	call z,@state0		; $4728

@state1:
	ld a,(wccb1)		; $472b
	or a			; $472e
	ret nz			; $472f

	ld hl,w1Link		; $4730
	call checkObjectsCollided		; $4733
	jr c,@linkTouchedButton	; $4736

.ifdef ROM_SEASONS
	ld hl,$dd00		; $4790
	call checkObjectsCollided		; $4793
	jr c,@dd00TouchedButton	; $4796
.endif

	call objectGetTileAtPosition		; $4738
	sub TILEINDEX_BUTTON			; $473b
	cp $02 ; TILEINDEX_BUTTON or TILEINDEX_PRESSED_BUTTON
	jr nc,@somethingOnButton	; $473f

	call partCommon_decCounter1IfNonzero		; $4741
	ret nz			; $4744

	ld l,Part.var30		; $4745
	bit 0,(hl)		; $4747
	ret z			; $4749
	ld e,Part.var30		; $474a
	ld a,(de)		; $474c
	or a			; $474d
	ret z			; $474e

	call objectGetShortPosition		; $474f
	ld c,a			; $4752
	ld a,TILEINDEX_BUTTON		; $4753
	call setTile		; $4755

	ld e,Part.var03		; $4758
	ld a,(de)		; $475a
	ld hl,wActiveTriggers		; $475b
	call unsetFlag		; $475e
	ld e,$f0		; $4761
	xor a			; $4763
	ld (de),a		; $4764

	ld a,SND_SPLASH		; $4765
	jp playSound		; $4767

; Tile is being held down by something (somaria block, pot, etc)
@somethingOnButton:
	ld h,d			; $476a
	ld l,Part.subid		; $476b
	bit 7,(hl)		; $476d
	jr z,@delete	; $476f

	ld l,Part.var30		; $4771
	bit 0,(hl)		; $4773
	ret nz			; $4775

	ld l,Part.counter1		; $4776
	ld (hl),$1c		; $4778
	call objectGetShortPosition		; $477a
	ld c,a			; $477d
	ld b,TILEINDEX_PRESSED_BUTTON		; $477e
	call setTileInRoomLayoutBuffer		; $4780
	jr @setTriggerAndPlaySound		; $4783

@delete:
	call @updateTileBeforeDeletion		; $4785
	jp partDelete		; $4788

@linkTouchedButton:
	ld a,(w1Link.zh)		; $478b
	or a			; $478e
	ret nz			; $478f
@dd00TouchedButton:
	ld e,Part.subid		; $4790
	ld a,(de)		; $4792
	rlca			; $4793
	jr nc,@delete	; $4794

@checkButtonPushed:
	ld e,Part.var30		; $4796
	ld a,(de)		; $4798
	or a			; $4799
	ret nz			; $479a

	call objectGetShortPosition		; $479b
	ld c,a			; $479e
	ld a,TILEINDEX_PRESSED_BUTTON		; $479f
	call setTile		; $47a1

@setTriggerAndPlaySound:
	ld e,Part.var03		; $47a4
	ld a,(de)		; $47a6
	ld hl,wActiveTriggers		; $47a7
	call setFlag		; $47aa
	ld e,Part.var30		; $47ad
	ld a,$01		; $47af
	ld (de),a		; $47b1
	ld a,SND_SPLASH		; $47b2
	jp playSound		; $47b4

@updateTileBeforeDeletion:
	call objectGetShortPosition		; $47b7
	ld c,a			; $47ba
	ld b,TILEINDEX_PRESSED_BUTTON		; $47bb
	call setTileInRoomLayoutBuffer		; $47bd
	call objectGetTileAtPosition		; $47c0
	cp TILEINDEX_BUTTON			; $47c3
	jr z,@checkButtonPushed	; $47c5
	jr @setTriggerAndPlaySound		; $47c7

@state0:
	ld h,d			; $47c9
	ld l,e			; $47ca
	inc (hl) ; [state] = 1
	ld l,Part.subid		; $47cc
	ldi a,(hl)		; $47ce
	and $07			; $47cf
	ldd (hl),a ; [var03]
	ret			; $47d2


; =======================================================================================
; PARTID_MOVING_ORB
;
; Variables:
;   var32: Dest Y position (from movement script)
;   var33: Dest X position (from movement script)
; =======================================================================================
partCode0b:
	cp PARTSTATUS_JUST_HIT			; $47d3
	jr nz,@normalStatus	; $47d5

	; Just hit

	ld h,d			; $47d7
	ld l,Part.oamFlagsBackup		; $47d8
	ldi a,(hl)		; $47da
	ld (hl),a ; [oamFlags]

	ld l,Part.var03		; $47dc
	ld a,(wToggleBlocksState)		; $47de
	xor (hl)		; $47e1
	ld (wToggleBlocksState),a		; $47e2
	ld l,Part.oamFlagsBackup		; $47e5
	ld a,(hl)		; $47e7
	dec a			; $47e8
	jr nz,+			; $47e9
	ld a,$02		; $47eb
+
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]
	ld a,SND_SWITCH		; $47ef
	call playSound		; $47f1

@normalStatus:
	ld e,Part.state		; $47f4
	ld a,(de)		; $47f6
	sub $08			; $47f7
	jr c,@state0To7	; $47f9
	rst_jumpTable			; $47fb
	.dw @state8_up
	.dw @state9_right
	.dw @stateA_down
	.dw @stateB_left
	.dw @stateC_waiting

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.orbMovementScript		; $4806
.else
	ld hl,orbMovementScript
.endif
	call objectLoadMovementScript		; $4809

	ld h,d			; $480c
	ld l,Part.var03		; $480d
	ld b,$01		; $480f
	ld a,(wToggleBlocksState)		; $4811
	and (hl)		; $4814
	jr z,+			; $4815
	inc b			; $4817
+
	ld a,b			; $4818
	ld l,Part.oamFlagsBackup		; $4819
	ldi (hl),a		; $481b
	ld (hl),a  ; [oamFlags]
	jp objectSetVisible82		; $481d

@state8_up:
	ld h,d			; $4820
	ld e,Part.var32		; $4821
	ld a,(de)		; $4823
	ld l,Part.yh		; $4824
	cp (hl)			; $4826
	jp c,objectApplySpeed		; $4827
	jr @runMovementScript		; $482a

@state9_right:
	ld h,d			; $482c
	ld e,Part.xh		; $482d
	ld a,(de)		; $482f
	ld l,Part.var33		; $4830
	cp (hl)			; $4832
	jp c,objectApplySpeed		; $4833
	jr @runMovementScript		; $4836

@stateA_down:
	ld h,d			; $4838
	ld e,Part.yh		; $4839
	ld a,(de)		; $483b
	ld l,Part.var32		; $483c
	cp (hl)			; $483e
	jp c,objectApplySpeed		; $483f
	jr @runMovementScript		; $4842

@stateB_left:
	ld h,d			; $4844
	ld e,Part.var33		; $4845
	ld a,(de)		; $4847
	ld l,Part.xh		; $4848
	cp (hl)			; $484a
	jp c,objectApplySpeed		; $484b

@runMovementScript:
	ld a,(de)		; $484e
	ld (hl),a		; $484f
	jp objectRunMovementScript		; $4850

@stateC_waiting:
	ld h,d			; $4853
	ld l,Part.counter1		; $4854
	dec (hl)		; $4856
	ret nz			; $4857
	jp objectRunMovementScript		; $4858


; ==============================================================================
; PARTID_BRIDGE_SPAWNER
; ==============================================================================
partCode0c:
	ld e,Part.state		; $485b
	ld a,(de)		; $485d
	or a			; $485e
	call z,@state0		; $485f

	call partCommon_decCounter1IfNonzero		; $4862
	ret nz			; $4865

	; Time to create the next bridge tile
	ld l,Part.angle		; $4866
	ld a,(hl)		; $4868
	ld hl,@tileValues		; $4869
	rst_addDoubleIndex			; $486c
	ld e,Part.counter2		; $486d
	ld a,(de)		; $486f
	rrca			; $4870
	ldi a,(hl)		; $4871
	jr nc,+			; $4872
	ld a,(hl)		; $4874
+
	ld b,a			; $4875
	ld e,Part.yh		; $4876
	ld a,(de)		; $4878
	ld c,a			; $4879
	push bc			; $487a
	call setTileInRoomLayoutBuffer		; $487b
	pop bc			; $487e
	ld a,b			; $487f
	call setTile		; $4880
	ld a,SND_DOORCLOSE		; $4883
	call playSound		; $4885

	ld h,d			; $4888
	ld l,Part.counter1		; $4889
	ld (hl),$08		; $488b
	inc l			; $488d
	dec (hl) ; [counter2]
	jp z,partDelete		; $488f

	; Move to next tile every other time (since bridges are updated in halves)
	ld a,(hl) ; [counter1]
	rrca			; $4893
	ret c			; $4894

	ld l,Part.angle		; $4895
	ld a,(hl)		; $4897
	ld bc,@directionVals		; $4898
	call addAToBc		; $489b
	ld a,(bc)		; $489e
	ld l,Part.yh		; $489f
	add (hl)		; $48a1
	ld (hl),a		; $48a2
	ret			; $48a3

@tileValues:
	.db TILEINDEX_VERTICAL_BRIDGE_DOWN,    TILEINDEX_VERTICAL_BRIDGE
	.db TILEINDEX_HORIZONTAL_BRIDGE_LEFT,  TILEINDEX_HORIZONTAL_BRIDGE
	.db TILEINDEX_VERTICAL_BRIDGE_UP,      TILEINDEX_VERTICAL_BRIDGE
	.db TILEINDEX_HORIZONTAL_BRIDGE_RIGHT, TILEINDEX_HORIZONTAL_BRIDGE

@directionVals:
	.db $f0 $01 $10 $ff

@state0:
	ld h,d			; $48b0
	ld l,e			; $48b1
	inc (hl) ; [state] = 1
	ld l,Part.counter1		; $48b3
	ld (hl),$08		; $48b5
	ret			; $48b7


; ==============================================================================
; PARTID_DETECTION_HELPER
;
; Variables (for subid 0, the "controller"):
;   counter1: Countdown until firing another detection projectile forward
;   counter2: Countdown until firing another detection projectile in an arbitrary
;             direction (for close-range detection)
; ==============================================================================
partCode0e:
	jp nz,partDelete		; $48b8
	ld e,Part.subid		; $48bb
	ld a,(de)		; $48bd
	ld e,Part.state		; $48be
	rst_jumpTable			; $48c0
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3


; The "controller" (spawns other subids)
@subid0:
	ld a,(de)		; $48c9
	or a			; $48ca
	jr z,@subid0_state0	; $48cb

@subid0_state1:
	ld a,Object.enabled		; $48cd
	call objectGetRelatedObject1Var		; $48cf
	ld a,(hl)		; $48d2
	or a			; $48d3
	jp z,partDelete		; $48d4

	; Copy parent's angle and position
	ld e,Part.angle		; $48d7
	ld a,l			; $48d9
	or Object.angle			; $48da
	ld l,a			; $48dc
	ld a,(hl)		; $48dd
	ld (de),a		; $48de
	call objectTakePosition		; $48df

	; Countdown to spawn a "detection projectile" forward
	call partCommon_decCounter1IfNonzero		; $48e2
	jr nz,++		; $48e5

	ld (hl),$0f ; [counter1]
	ld e,Part.angle		; $48e9
	ld a,(de)		; $48eb
	ld b,a			; $48ec
	ld e,$01		; $48ed
	call @spawnCollisionHelper		; $48ef
++
	; Countdown to spawn "detection projectiles" to the sides, for nearby detection
	ld h,d			; $48f2
	ld l,Part.counter2		; $48f3
	dec (hl)		; $48f5
	ret nz			; $48f6

	ld (hl),$06 ; [counter2]

	ld l,Part.var03		; $48f9
	ld a,(hl)		; $48fb
	inc a			; $48fc
	and $03			; $48fd
	ld (hl),a		; $48ff

	ld c,a			; $4900
	ld l,Part.angle		; $4901
	ld b,(hl)		; $4903
	ld e,$02		; $4904
	call @spawnCollisionHelper		; $4906
	ld e,$03		; $4909


;;
; @param	b	Angle
; @param	c	var03
; @param	e	Subid
; @addr{490b}
@spawnCollisionHelper:
	call getFreePartSlot		; $490b
	ret nz			; $490e
	ld (hl),PARTID_DETECTION_HELPER		; $490f
	inc l			; $4911
	ld (hl),e		; $4912
	inc l			; $4913
	ld (hl),c		; $4914

	call objectCopyPosition		; $4915
	ld l,Part.angle		; $4918
	ld (hl),b		; $491a

	ld l,Part.relatedObj1		; $491b
	ld e,l			; $491d
	ld a,(de)		; $491e
	ldi (hl),a		; $491f
	inc e			; $4920
	ld a,(de)		; $4921
	ld (hl),a		; $4922
	ret			; $4923

@subid0_state0:
	ld h,d			; $4924
	ld l,e			; $4925
	inc (hl) ; [subid]

	ld l,Part.counter1		; $4927
	inc (hl)		; $4929
	inc l			; $492a
	inc (hl) ; [counter2]
	ret			; $492c


; This "moves" in a prescribed direction. If it hits Link, it triggers the guard; if it
; hits a wall, it deletes itself.
@subid1:
	ld a,(de)		; $492d
	or a			; $492e
	jr z,@subid1_state0	; $492f


@subid1_state1:
	call objectCheckCollidedWithLink_ignoreZ		; $4931
	jr c,@sawLink			; $4934

	; Move forward, delete self if hit a wall
	call objectApplyComponentSpeed		; $4936
	call objectCheckSimpleCollision		; $4939
	ret z			; $493c
	jr @delete		; $493d

@sawLink:
	ld a,Object.var3b		; $493f
	call objectGetRelatedObject1Var		; $4941
	ld (hl),$ff		; $4944
@delete:
	jp partDelete		; $4946


@subid1_state0:
	inc a			; $4949
	ld (de),a ; [state]

	; Determine collision radii depending on angle
	ld e,Part.angle		; $494b
	ld a,(de)		; $494d
	add $04			; $494e
	and $08			; $4950
	rrca			; $4952
	rrca			; $4953
	ld hl,@collisionRadii		; $4954
	rst_addAToHl			; $4957
	ld e,Part.collisionRadiusY		; $4958
	ldi a,(hl)		; $495a
	ld (de),a		; $495b
	inc e			; $495c
	ld a,(hl)		; $495d
	ld (de),a		; $495e

	jp @initSpeed		; $495f

@collisionRadii:
	.db $02 $01 ; Up/down
	.db $01 $02 ; Left/right


; Like subid 1, but this only lasts for 4 frames, and it detects Link at various angles
; relative to the guard (determined by var03). Used for close-range detection in any
; direction.
@subid2:
@subid3:
	ld a,(de)		; $4966
	or a			; $4967
	jr z,@subid2_state0	; $4968


@subid2_state1:
	call partCommon_decCounter1IfNonzero		; $496a
	jr nz,@subid1_state1	; $496d
	jr @delete		; $496f


@subid2_state0:
	ld h,d			; $4971
	ld l,e			; $4972
	inc (hl) ; [state]

	ld l,Part.counter1		; $4974
	ld (hl),$04		; $4976

	ld l,Part.var03		; $4978
	ld a,(hl)		; $497a
	inc a			; $497b
	add a			; $497c
	dec l			; $497d
	bit 0,(hl) ; [subid]
	jr nz,++		; $4980
	cpl			; $4982
	inc a			; $4983
++
	ld l,Part.angle		; $4984
	add (hl)		; $4986
	and $1f			; $4987
	ld (hl),a		; $4989

;;
; @addr{498a}
@initSpeed:
	ld h,d			; $498a
	ld l,Part.angle		; $498b
	ld c,(hl)		; $498d
	ld b,SPEED_280		; $498e
	ld a,$04		; $4990
	jp objectSetComponentSpeedByScaledVelocity		; $4992


; ==============================================================================
; PARTID_RESPAWNABLE_BUSH
; ==============================================================================
partCode0f:
	jr z,@normalStatus	; $4995

	; Just hit
	ld h,d			; $4997
	ld l,Part.state		; $4998
	inc (hl) ; [state] = 2

	ld l,Part.counter1		; $499b
	ld (hl),$f0		; $499d
	ld l,Part.collisionType		; $499f
	res 7,(hl)		; $49a1

	ld a,TILEINDEX_RESPAWNING_BUSH_CUT		; $49a3
	call @setTileHere		; $49a5

	; 50/50 drop chance
	call getRandomNumber_noPreserveVars		; $49a8
	rrca			; $49ab
	jr nc,@doneItemDropSpawn	; $49ac

	call getFreePartSlot		; $49ae
	jr nz,@doneItemDropSpawn	; $49b1
	ld (hl),PARTID_ITEM_DROP		; $49b3
	inc l			; $49b5
	ld e,l			; $49b6
	ld a,(de)		; $49b7
	ld (hl),a ; [itemDrop.subid] = [this.subid]
	call objectCopyPosition		; $49b9

@doneItemDropSpawn:
	ld b,INTERACID_GRASSDEBRIS		; $49bc
	call objectCreateInteractionWithSubid00		; $49be

@normalStatus:
	ld e,Part.state		; $49c1
	ld a,(de)		; $49c3
	rst_jumpTable			; $49c4
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01		; $49cf
	ld (de),a		; $49d1
	ret			; $49d2

@state1:
	ret			; $49d3

; Delay before respawning
@state2:
	ld a,(wFrameCounter)		; $49d4
	rrca			; $49d7
	ret nc			; $49d8
	call partCommon_decCounter1IfNonzero		; $49d9
	ret nz			; $49dc

	; Time to respawn
	ld (hl),$0c ; [counter1]
	ld l,e			; $49df
	inc (hl) ; [state] = 3
	ld a,TILEINDEX_RESPAWNING_BUSH_REGEN		; $49e1
	jr @setTileHere		; $49e3

@state3:
	call partCommon_decCounter1IfNonzero		; $49e5
	ret nz			; $49e8
	ld (hl),$08 ; [counter1]
	ld l,e			; $49eb
	inc (hl) ; [state] = 4
	ld a,TILEINDEX_RESPAWNING_BUSH_READY		; $49ed

;;
; @param	a	Tile index to set
; @addr{49ef}
@setTileHere:
	push af			; $49ef
	call objectGetShortPosition		; $49f0
	ld c,a			; $49f3
	pop af			; $49f4
	jp setTile		; $49f5


@state4:
	call partCommon_decCounter1IfNonzero		; $49f8
	ret nz			; $49fb
	ld l,e			; $49fc
	ld (hl),$01 ; [state] = 1

	ld l,Part.collisionType		; $49ff
	set 7,(hl)		; $4a01
	ret			; $4a03


; ==============================================================================
; PARTID_SEED_ON_TREE
; ==============================================================================
partCode10:
	jr z,@normalStatus	; $4a04
	cp PARTSTATUS_DEAD			; $4a06
	jp z,@dead		; $4a08

	; PARTSTATUS_JUST_HIT
	ld e,Part.state		; $4a0b
	ld a,$02		; $4a0d
	ld (de),a		; $4a0f

@normalStatus:
	ld e,Part.state		; $4a10
	ld a,(de)		; $4a12
	rst_jumpTable			; $4a13
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01		; $4a1e
	ld (de),a ; [state]

	ld e,Part.subid		; $4a21
	ld a,(de)		; $4a23
	ld hl,@oamData		; $4a24
	rst_addDoubleIndex			; $4a27
	ld e,Part.oamTileIndexBase		; $4a28
	ld a,(de)		; $4a2a
	add (hl)		; $4a2b
	ld (de),a ; [oamTileIndexBase]
	inc hl			; $4a2d
	dec e			; $4a2e
	ld a,(hl)		; $4a2f
	ld (de),a ; [oamFlags]
	dec e			; $4a31
	ld (de),a ; [oamFlagsBackup]

	ld a,$01		; $4a33
	call partSetAnimation		; $4a35
	jp objectSetVisiblec3		; $4a38

@oamData:
	.db $12 $02
	.db $14 $03
	.db $16 $01
	.db $18 $01
	.db $1a $00

@state1:
	ret			; $4a45

@state2:
	ret			; $4a46

@state3:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $4a47
	jr c,@giveToLink	; $4a4a

	call objectApplySpeed		; $4a4c
	ld c,$20		; $4a4f
	call objectUpdateSpeedZAndBounce		; $4a51
	ret nc			; $4a54

@giveToLink:
	ld h,d			; $4a55
	ld l,Part.state		; $4a56
	ld (hl),$04		; $4a58
	inc l			; $4a5a
	ld (hl),$00		; $4a5b
	ret			; $4a5d

@state4:
	ld e,Part.state2		; $4a5e
	ld a,(de)		; $4a60
	rst_jumpTable			; $4a61
	.dw @substate0
	.dw @substate1

@substate0:
	ld e,Part.subid		; $4a66
	ld a,(de)		; $4a68
	ld l,a			; $4a69
	add TREASURE_EMBER_SEEDS			; $4a6a
	call checkTreasureObtained		; $4a6c
	jr c,@giveSeedAndSomething	; $4a6f

	; First time getting this seed type
	ld e,Part.state2		; $4a71
	ld a,$01		; $4a73
	ld (de),a		; $4a75

	ld a,l ; [subid]
	ld hl,@textIndices		; $4a77
	rst_addAToHl			; $4a7a
	ld c,(hl)		; $4a7b
	ld b,>TX_0000		; $4a7c
	call showText		; $4a7e
	ld c,$06		; $4a81
	jr @giveSeed		; $4a83

@textIndices:
	.db <TX_0029
	.db <TX_0029
	.db <TX_002b
	.db <TX_002c
	.db <TX_002a

@giveSeed:
	ld e,Part.subid		; $4a8a
	ld a,(de)		; $4a8c
	add TREASURE_EMBER_SEEDS			; $4a8d
	jp giveTreasure		; $4a8f

@giveSeedAndSomething:
	ld c,$06		; $4a92
	call @giveSeed		; $4a94

@relatedObj2Something:
	ld a,Object.enabled		; $4a97
	call objectGetRelatedObject2Var		; $4a99
	ld a,(hl)		; $4a9c
	or a			; $4a9d
	jr z,@delete	; $4a9e
	ld a,l			; $4aa0
	add Object.var03 - Object.enabled
	ld l,a			; $4aa3
	ld (hl),$01		; $4aa4
@delete:
	jp partDelete		; $4aa6

@substate1:
	call retIfTextIsActive		; $4aa9
	jr @relatedObj2Something		; $4aac

@dead:
	ld h,d			; $4aae
	ld l,Part.collisionType		; $4aaf
	res 7,(hl)		; $4ab1
	ld a,($cfc0)		; $4ab3
	or a			; $4ab6
	ret nz			; $4ab7

	ld a,TREASURE_SEED_SATCHEL		; $4ab8
	call checkTreasureObtained		; $4aba
	jr c,@knockOffTree	; $4abd

	; Don't have satchel
	ld a,d			; $4abf
	ld ($cfc0),a		; $4ac0
	ld bc,TX_0035		; $4ac3
	jp showText		; $4ac6

@knockOffTree:
	ld bc,-$140		; $4ac9
	call objectSetSpeedZ		; $4acc
	ld l,Part.health		; $4acf
	ld a,$03		; $4ad1
	ld (hl),a		; $4ad3
	ld l,Part.state		; $4ad4
	ldi (hl),a		; $4ad6
	ld (hl),$00 ; [state2]
	inc l			; $4ad9
	ld (hl),$02 ; [counter1]
	ld l,Part.speed		; $4adc
	ld (hl),SPEED_100		; $4ade
	call objectGetAngleTowardLink		; $4ae0
	ld e,Part.angle		; $4ae3
	ld (de),a		; $4ae5
	ret			; $4ae6


; ==============================================================================
; PARTID_VOLCANO_ROCK
; ==============================================================================
partCode11:
	ld e,Part.subid		; $4ae7
	ld a,(de)		; $4ae9
	ld e,Part.state		; $4aea
	rst_jumpTable			; $4aec
	.dw _volcanoRock_subid0
	.dw _volcanoRock_subid1
	.dw _volcanoRock_subid2

_volcanoRock_subid0:
	ld a,(de)		; $4af3
	or a			; $4af4
	jr z,@state0	; $4af5

@state1:
	ld c,$16		; $4af7
	call objectUpdateSpeedZAndBounce		; $4af9
	jp c,partDelete		; $4afc
	jp nz,objectApplySpeed		; $4aff

	call getRandomNumber_noPreserveVars		; $4b02
	and $03			; $4b05
	dec a			; $4b07
	ret z			; $4b08
	ld b,a			; $4b09
	ld e,Part.angle		; $4b0a
	ld a,(de)		; $4b0c
	add b			; $4b0d
	and $1f			; $4b0e

@setAngleAndSpeed:
	ld (de),a		; $4b10
	jp _volcanoRock_subid0_setSpeedFromAngle		; $4b11

@state0:
	ld bc,-$280		; $4b14
	call objectSetSpeedZ		; $4b17
	ld l,e			; $4b1a
	inc (hl) ; [state]
	ld l,Part.collisionType		; $4b1c
	set 7,(hl)		; $4b1e
	call objectSetVisible80		; $4b20
	call getRandomNumber_noPreserveVars		; $4b23
	and $0f			; $4b26
	add $08			; $4b28
	ld e,Part.angle		; $4b2a
	jr @setAngleAndSpeed		; $4b2c


_volcanoRock_subid1:
	ld a,(de)		; $4b2e
	rst_jumpTable			; $4b2f
	.dw @substate0
	.dw @substate1
	.dw _volcanoRock_common_substate2
	.dw _volcanoRock_common_substate3
	.dw _volcanoRock_common_substate4
	.dw _volcanoRock_common_substate5

@substate0:
	ld h,d			; $4b3c
	ld l,e			; $4b3d
	inc (hl)		; $4b3e
	ld l,Part.collisionType		; $4b3f
	set 7,(hl)		; $4b41

	; Double hitbox size
	ld l,Part.collisionRadiusY		; $4b43
	ld a,(hl)		; $4b45
	add a			; $4b46
	ldi (hl),a		; $4b47
	ldi (hl),a		; $4b48

	; [damage] *= 2
	sla (hl)		; $4b49

	ld l,Part.speed		; $4b4b
	ld (hl),SPEED_20		; $4b4d

	ld l,Part.speedZ		; $4b4f
	ld a,<(-$400)		; $4b51
	ldi (hl),a		; $4b53
	ld (hl),>(-$400)		; $4b54

	; Random angle
	call getRandomNumber_noPreserveVars		; $4b56
	and $1f			; $4b59
	ld e,Part.angle		; $4b5b
	ld (de),a		; $4b5d

	ld a,$01		; $4b5e
	call partSetAnimation		; $4b60
	jp objectSetVisible80		; $4b63

@substate1:
	ld h,d			; $4b66
	ld l,Part.yh		; $4b67
	ld e,Part.zh		; $4b69
	ld a,(de)		; $4b6b
	add (hl)		; $4b6c
	add $08			; $4b6d
	cp $f8			; $4b6f
	ld c,$10		; $4b71
	jp c,objectUpdateSpeedZ_paramC		; $4b73

	ld l,Part.state		; $4b76
	inc (hl)		; $4b78
	ld l,Part.counter1		; $4b79
	ld (hl),30		; $4b7b
	call objectSetInvisible		; $4b7d
	jr _volcanoRock_setRandomPosition			; $4b80

_volcanoRock_common_substate2:
	call partCommon_decCounter1IfNonzero		; $4b82
	ret nz			; $4b85
	ld (hl),$10 ; [counter1]
	ld l,e			; $4b88
	inc (hl) ; [state2]++
	jp objectSetVisiblec0		; $4b8a

_volcanoRock_common_substate3:
	call partAnimate		; $4b8d
	ld h,d			; $4b90
	ld l,Part.zh		; $4b91
	inc (hl)		; $4b93
	inc (hl)		; $4b94
	ret nz			; $4b95

	call objectReplaceWithAnimationIfOnHazard		; $4b96
	jp c,partDelete		; $4b99

	ld h,d			; $4b9c
	ld l,Part.state		; $4b9d
	inc (hl)		; $4b9f
	ld l,Part.speedZ		; $4ba0
	xor a			; $4ba2
	ldi (hl),a		; $4ba3
	ld (hl),a		; $4ba4
	jp objectSetVisible82		; $4ba5

_volcanoRock_common_substate4:
	call partAnimate		; $4ba8
	ld c,$16		; $4bab
	call objectUpdateSpeedZ_paramC		; $4bad
	jp nz,objectApplySpeed		; $4bb0

	ld l,Part.state		; $4bb3
	inc (hl)		; $4bb5

	ld l,Part.oamTileIndexBase		; $4bb6
	ld (hl),$26		; $4bb8

	ld a,$03		; $4bba
	call partSetAnimation		; $4bbc
	ld a,SND_STRONG_POUND		; $4bbf
	jp playSound		; $4bc1

_volcanoRock_common_substate5:
	ld e,Part.animParameter		; $4bc4
	ld a,(de)		; $4bc6
	inc a			; $4bc7
	jp z,partDelete		; $4bc8
	call _volcanoRock_setCollisionSize		; $4bcb
	jp partAnimate		; $4bce


_volcanoRock_subid2:
	ld a,(de)		; $4bd1
	rst_jumpTable			; $4bd2
	.dw @substate0
	.dw _volcanoRock_common_substate2
	.dw _volcanoRock_common_substate3
	.dw _volcanoRock_common_substate4
	.dw _volcanoRock_common_substate5

@substate0:
	ld a,$01		; $4bdd
	ld (de),a ; [state2]

_volcanoRock_setRandomPosition:
	call getRandomNumber_noPreserveVars		; $4be0
	ld b,a			; $4be3
	ld hl,hCameraY		; $4be4
	ld e,Part.yh		; $4be7
	and $70			; $4be9
	add $08			; $4beb
	add (hl)		; $4bed
	ld (de),a		; $4bee
	cpl			; $4bef
	inc a			; $4bf0
	and $fe			; $4bf1
	ld e,Part.zh		; $4bf3
	ld (de),a		; $4bf5

	ld l,<hCameraX		; $4bf6
	ld e,Part.xh		; $4bf8
	ld a,b			; $4bfa
	and $07			; $4bfb
	inc a			; $4bfd
	swap a			; $4bfe
	add $08			; $4c00
	add (hl)		; $4c02
	ld (de),a		; $4c03
	ld a,$02		; $4c04
	jp partSetAnimation		; $4c06

;;
; @param	a	Angle
; @addr{4c09}
_volcanoRock_subid0_setSpeedFromAngle:
	ld b,SPEED_80		; $4c09
	cp $0d			; $4c0b
	jr c,@setSpeed	; $4c0d
	ld b,SPEED_40		; $4c0f
	cp $14			; $4c11
	jr c,@setSpeed	; $4c13
	ld b,SPEED_80		; $4c15
@setSpeed:
	ld a,b			; $4c17
	ld e,Part.speed		; $4c18
	ld (de),a		; $4c1a
	ret			; $4c1b

;;
; @param	a	Value from [animParameter] (should be multiple of 2)
; @addr{4c1c}
_volcanoRock_setCollisionSize:
	dec a			; $4c1c
	ld hl,@data		; $4c1d
	rst_addAToHl			; $4c20
	ld e,Part.collisionRadiusY		; $4c21
	ldi a,(hl)		; $4c23
	ld (de),a		; $4c24
	inc e			; $4c25
	ld a,(hl)		; $4c26
	ld (de),a		; $4c27
	ret			; $4c28

@data:
	.db $04 $09
	.db $06 $0b
	.db $09 $0c
	.db $0a $0d
	.db $0b $0e


; ==============================================================================
; PARTID_FLAME
;
; Variables:
;   var30: ID of enemy hit (relatedObj1)
;   var31: Old health value of enemy
; ==============================================================================
partCode12:
	ld e,Part.state		; $4c33
	ld a,(de)		; $4c35
	or a			; $4c36
	call z,@state0		; $4c37

@state1:
	ld a,Object.id		; $4c3a
	call objectGetRelatedObject1Var		; $4c3c
	ld e,Part.var30		; $4c3f
	ld a,(de)		; $4c41
	cp (hl)			; $4c42
	jr nz,@delete	; $4c43

	ld c,$10		; $4c45
	call objectUpdateSpeedZAndBounce		; $4c47

	ld a,Object.zh		; $4c4a
	call objectGetRelatedObject1Var		; $4c4c
	ld e,Part.zh		; $4c4f
	ld a,(de)		; $4c51
	ld (hl),a		; $4c52

	call objectTakePosition		; $4c53
	ld c,h			; $4c56
	call partCommon_decCounter1IfNonzero		; $4c57
	jp nz,partAnimate		; $4c5a

	; Done burning.

	; Restore enemy's health
	ld h,c			; $4c5d
	ld l,Enemy.health		; $4c5e
	ld e,Part.var31		; $4c60
	ld a,(de)		; $4c62
	ld (hl),a		; $4c63

	; Disable enemy collision if he's dead
	or a			; $4c64
	jr nz,+			; $4c65
	ld l,Enemy.collisionType		; $4c67
	res 7,(hl)		; $4c69
+
	ld l,Enemy.invincibilityCounter		; $4c6b
	ld (hl),$00		; $4c6d
	ld l,Enemy.stunCounter		; $4c6f
	ld (hl),$01		; $4c71
@delete:
	jp partDelete		; $4c73

@state0:
	ld h,d			; $4c76
	ld l,e			; $4c77
	inc (hl) ; [state]

	ld l,Part.counter1		; $4c79
	ld (hl),59		; $4c7b
	ld a,Object.id		; $4c7d
	call objectGetRelatedObject1Var		; $4c7f
	ld e,Part.var30		; $4c82
	ld a,(hl)		; $4c84
	ld (de),a		; $4c85

	ld e,Part.var31		; $4c86
	ld l,Enemy.health		; $4c88
	ld a,(hl)		; $4c8a
	ld (de),a		; $4c8b
	ld (hl),$01		; $4c8c
	call objectTakePosition		; $4c8e
	jp objectSetVisible80		; $4c91


;;
; Owl statue
; @addr{4c94}
partCode13:
	jr z,@normalStatus	; $4c94
	ld e,Part.var2a		; $4c96
	ld a,(de)		; $4c98
	cp $9a			; $4c99
	jr nz,@normalStatus	; $4c9b
	ld h,d			; $4c9d
	ld l,Part.state		; $4c9e
	ld a,(hl)		; $4ca0
	cp $02			; $4ca1
	jr nc,@normalStatus	; $4ca3
	inc (hl)		; $4ca5
	ld l,Part.counter1		; $4ca6
	ld (hl),$32		; $4ca8
@normalStatus:
	ld e,Part.state		; $4caa
	ld a,(de)		; $4cac
	rst_jumpTable			; $4cad
	.dw @state0
	.dw @stateStub
	.dw @state2
	.dw @state3

@state0:
	ld h,d			; $4cb6
	ld l,e			; $4cb7
	inc (hl)		; $4cb8
	ld l,Part.var3f		; $4cb9
	set 5,(hl)		; $4cbb
	call objectMakeTileSolid		; $4cbd
	ld h,>wRoomLayout		; $4cc0
	ld (hl),$00		; $4cc2
	jp objectSetVisible83		; $4cc4

@stateStub:
	ret			; $4cc7

@state2:
	call partCommon_decCounter1IfNonzero		; $4cc8
	jr nz,+			; $4ccb
	ld (hl),$1e		; $4ccd
	ld l,e			; $4ccf
	inc (hl)		; $4cd0
	ld a,$01		; $4cd1
	jp partSetAnimation		; $4cd3
+
	ld a,(hl)		; $4cd6
	and $07			; $4cd7
	ret nz			; $4cd9
	ld a,(hl)		; $4cda
	rrca			; $4cdb
	rrca			; $4cdc
	sub $02			; $4cdd
	ld hl,@owlStatueSparkleOffset		; $4cdf
	rst_addAToHl			; $4ce2
	ldi a,(hl)		; $4ce3
	ld b,a			; $4ce4
	ld c,(hl)		; $4ce5
	call getFreeInteractionSlot		; $4ce6
	ret nz			; $4ce9
	ld (hl),INTERACID_SPARKLE		; $4cea
.ifdef ROM_SEASONS
	; state2
	inc l			; $4d4c
	ld (hl),$05		; $4d4d
.endif
	jp objectCopyPositionWithOffset		; $4cec
@owlStatueSparkleOffset:
	.db $f9 $05
	.db $06 $ff
	.db $fc $fa
	.db $02 $07
	.db $00 $fa
	.db $ff $02

@state3:
	call partCommon_decCounter1IfNonzero		; $4cfb
	jr nz,+			; $4cfe
	ld l,e			; $4d00
	ld (hl),$01		; $4d01
	xor a			; $4d03
	jp partSetAnimation		; $4d04
+
	ld a,(hl)		; $4d07
	cp $16			; $4d08
	ret nz			; $4d0a
	ld l,Part.subid		; $4d0b
	ld c,(hl)		; $4d0d
	ld b,$39		; $4d0e
	jp showText		; $4d10


; ==============================================================================
; PARTID_ITEM_FROM_MAPLE
; PARTID_ITEM_FROM_MAPLE_2
; ==============================================================================
; @addr{4d13}
partCode14:
partCode15:
	ld e,Part.subid		; $4d13
	jr z,@normalStatus	; $4d15
	cp PARTSTATUS_DEAD			; $4d17
	jp z,@linkCollectedItem		; $4d19

	; PARTSTATUS_JUST_HIT
	ld h,d			; $4d1c
	ld l,Part.subid		; $4d1d
	set 7,(hl)		; $4d1f
	ld l,Part.state		; $4d21
	ld (hl),$03		; $4d23
	inc l			; $4d25
	ld (hl),$00		; $4d26

@normalStatus:
	ld e,Part.state		; $4d28
	ld a,(de)		; $4d2a
	rst_jumpTable			; $4d2b
	.dw @state0
	.dw @state1
	.dw objectReplaceWithAnimationIfOnHazard
	.dw @state3 ; just hit
	.dw @state4

@state0:
	ld h,d			; $4d36
	ld l,e			; $4d37
	inc (hl)		; $4d38

	ld l,Part.collisionRadiusY		; $4d39
	ld a,$06		; $4d3b
	ldi (hl),a		; $4d3d
	; collisionRadiusX
	ld (hl),a		; $4d3e

	call getRandomNumber		; $4d3f
	ld b,a			; $4d42
	and $70			; $4d43
	swap a			; $4d45
	ld hl,@speedValues		; $4d47
	rst_addAToHl			; $4d4a
	ld e,Part.speed		; $4d4b
	ld a,(hl)		; $4d4d
	ld (de),a		; $4d4e

	ld a,b			; $4d4f
	and $0e			; $4d50
	ld hl,@speedZValues		; $4d52
	rst_addAToHl			; $4d55
	ld e,Part.speedZ		; $4d56
	ldi a,(hl)		; $4d58
	ld (de),a		; $4d59
	inc e			; $4d5a
	ldi a,(hl)		; $4d5b
	ld (de),a		; $4d5c

	call getRandomNumber		; $4d5d
	ld e,Part.angle		; $4d60
	and $1f			; $4d62
	ld (de),a		; $4d64
	call @setOamData		; $4d65
	jp objectSetVisiblec3		; $4d68

@speedValues:
	.db SPEED_080
	.db SPEED_0c0
	.db SPEED_100
	.db SPEED_140
	.db SPEED_180
	.db SPEED_1c0
	.db SPEED_200
	.db SPEED_240

@speedZValues:
	.dw -$180
	.dw -$1c0
	.dw -$200
	.dw -$240
	.dw -$280
	.dw -$2c0
	.dw -$300
	.dw -$340

@state1:
	call objectApplySpeed		; $4d83
	call @setDroppedItemPosition		; $4d86
	ld c,$20		; $4d89
	call objectUpdateSpeedZAndBounce		; $4d8b
	jr nc,+			; $4d8e
	ld h,d			; $4d90
	ld l,Part.collisionType		; $4d91
	set 7,(hl)		; $4d93
	ld l,Part.state		; $4d95
	inc (hl)		; $4d97
+
	jp objectReplaceWithAnimationIfOnHazard		; $4d98

@state3:
	inc e			; $4d9b
	ld a,(de)		; $4d9c
	or a			; $4d9d
	jr nz,+			; $4d9e
	ld h,d			; $4da0
	ld l,e			; $4da1
	inc (hl)		; $4da2
	ld l,Part.zh		; $4da3
	ld (hl),$00		; $4da5
	ld a,$01		; $4da7
	call objectGetRelatedObject1Var		; $4da9
	ld a,(hl)		; $4dac
	ld e,Part.var30		; $4dad
	ld (de),a		; $4daf
	call objectSetVisible80		; $4db0
+
	call objectCheckCollidedWithLink		; $4db3
	jp c,@linkCollectedItem		; $4db6
	ld a,$00		; $4db9
	call objectGetRelatedObject1Var		; $4dbb
	ldi a,(hl)		; $4dbe
	or a			; $4dbf
	jr z,+			; $4dc0
	ld e,Part.var30		; $4dc2
	ld a,(de)		; $4dc4
	cp (hl)			; $4dc5
	jp z,objectTakePosition		; $4dc6
+
	jp partDelete		; $4dc9

@state4:
	inc e			; $4dcc
	ld a,(de)		; $4dcd
	rst_jumpTable			; $4dce
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d			; $4dd7
	ld l,e			; $4dd8
	inc (hl)		; $4dd9
	ld a,(w1Companion.damage)		; $4dda
	dec a			; $4ddd
	ld l,Part.speed		; $4dde
	ld (hl),SPEED_80		; $4de0
	jr z,@substate1		; $4de2
	ld (hl),SPEED_100		; $4de4

@substate1:
	ld hl,w1Companion.damage		; $4de6
	ld a,(hl)		; $4de9
	or a			; $4dea
	jr z,+			; $4deb
	call @moveToMaple		; $4ded
	ret nz			; $4df0
	ld l,Part.state2		; $4df1
	inc (hl)		; $4df3
	ld l,Part.collisionType		; $4df4
	res 7,(hl)		; $4df6
	ld bc,-$40		; $4df8
	jp objectSetSpeedZ		; $4dfb

@substate2:
	ld c,$00		; $4dfe
	call objectUpdateSpeedZ_paramC		; $4e00
	ld e,Part.zh		; $4e03
	ld a,(de)		; $4e05
	cp $f7			; $4e06
	ret nc			; $4e08
+
	ld a,$01		; $4e09
	ld (w1Companion.damageToApply),a		; $4e0b
	ld h,d			; $4e0e
	ld l,Part.state2		; $4e0f
	ld (hl),$03		; $4e11
	ld l,Part.var03		; $4e13
	ld (hl),$00		; $4e15
	ret			; $4e17

@substate3:
	ld e,Part.var03		; $4e18
	ld a,(de)		; $4e1a
	rlca			; $4e1b
	ret nc			; $4e1c
	jp partDelete		; $4e1d

@linkCollectedItem:
	ld a,(wDisabledObjects)		; $4e20
	bit 0,a			; $4e23
	ret nz			; $4e25
	ld e,Part.subid		; $4e26
	ld a,(de)		; $4e28
	and $7f			; $4e29
	ld hl,@obtainedValue		; $4e2b
	rst_addAToHl			; $4e2e
	ld a,(w1Companion.var2a)		; $4e2f
	add (hl)		; $4e32
	ld (w1Companion.var2a),a		; $4e33
	ld a,(de)		; $4e36
	and $7f			; $4e37
	jr z,@func_4e6e	; $4e39
	add a			; $4e3b
	ld hl,@itemDropTreasureTable		; $4e3c
	rst_addDoubleIndex			; $4e3f
	ldi a,(hl)		; $4e40
	ld b,a			; $4e41
	ld a,GOLD_JOY_RING		; $4e42
	call cpActiveRing		; $4e44
	ldi a,(hl)		; $4e47
	jr z,+			; $4e48
	cp $ff			; $4e4a
	jr z,++			; $4e4c
	call cpActiveRing		; $4e4e
	jr nz,++		; $4e51
+
	inc hl			; $4e53
++
	ld c,(hl)		; $4e54
	ld a,b			; $4e55
	cp TREASURE_RING			; $4e56
	jr nz,+			; $4e58
	call getRandomRingOfGivenTier		; $4e5a
+
	cp TREASURE_POTION			; $4e5d
	jr nz,+			; $4e5f
	ld a,SND_GETSEED		; $4e61
	call playSound		; $4e63
	ld a,TREASURE_POTION		; $4e66
+
	call giveTreasure		; $4e68
	jp partDelete		; $4e6b

@func_4e6e:
	ldbc TREASURE_HEART_PIECE $02		; $4e6e
	call createTreasure		; $4e71
	ret nz			; $4e74
	ld l,Interaction.yh		; $4e75
	ld a,(w1Link.yh)		; $4e77
	ldi (hl),a		; $4e7a
	inc l			; $4e7b
	ld a,(w1Link.xh)		; $4e7c
	ld (hl),a		; $4e7f
	ld hl,wMapleState		; $4e80
	set 7,(hl)		; $4e83
	jp partDelete		; $4e85

; Data format:
;   b0: Treasure to give
;   b1: Ring to check for (in addition to gold joy ring)
;   b2: Amount to give without ring
;   b3: Amount to give with ring
@itemDropTreasureTable:
	.db TREASURE_HEART_PIECE,   $ff            $01 $01
	.db TREASURE_GASHA_SEED,    $ff            $01 $01
	.db TREASURE_RING,          $ff            $01 $01
	.db TREASURE_RING,          $ff            $02 $02
	.db TREASURE_POTION,        $ff            $01 $01
	.db TREASURE_EMBER_SEEDS,   $ff            $05 $0a
	.db TREASURE_SCENT_SEEDS,   $ff            $05 $0a
	.db TREASURE_PEGASUS_SEEDS, $ff            $05 $0a
	.db TREASURE_GALE_SEEDS,    $ff            $05 $0a
	.db TREASURE_MYSTERY_SEEDS, $ff            $05 $0a
	.db TREASURE_BOMBS,         $ff            $04 $08
	.db TREASURE_HEART_REFILL,  BLUE_JOY_RING, $04 $08
	.db TREASURE_RUPEES,        RED_JOY_RING,  RUPEEVAL_005 RUPEEVAL_010
	.db TREASURE_RUPEES,        RED_JOY_RING,  RUPEEVAL_001 RUPEEVAL_002

@setOamData:
	ld e,Part.subid		; $4ec0
	ld a,(de)		; $4ec2
	ld c,a			; $4ec3
	add a			; $4ec4
	add c			; $4ec5
	ld hl,@oamData		; $4ec6
	rst_addAToHl			; $4ec9
	ld e,Part.oamTileIndexBase		; $4eca
	ld a,(de)		; $4ecc
	add (hl)		; $4ecd
	ld (de),a		; $4ece
	inc hl			; $4ecf
	; oamFlags
	dec e			; $4ed0
	ldi a,(hl)		; $4ed1
	ld (de),a		; $4ed2
	; oamFlagsBackup
	dec e			; $4ed3
	ld (de),a		; $4ed4
	ld a,(hl)		; $4ed5
	jp partSetAnimation		; $4ed6

@oamData:
	.db $10 $02 $10
	.db $0a $01 $00
	.db $08 $00 $00
	.db $08 $00 $00
	.db $00 $02 $0f
	.db $12 $02 $05
	.db $14 $03 $06
	.db $16 $01 $07
	.db $18 $01 $08
	.db $1a $00 $08
	.db $10 $04 $04
	.db $02 $05 $01
	.db $06 $05 $03
	.db $04 $00 $02

@setDroppedItemPosition:
	ld h,d			; $4f03
	ld l,Part.yh		; $4f04
	ld a,(hl)		; $4f06
	cp $f0			; $4f07
	jr c,+			; $4f09
	xor a			; $4f0b
+
	cp $20			; $4f0c
	jr nc,+			; $4f0e
	ld (hl),$20		; $4f10
	jr ++			; $4f12
+
	cp $78			; $4f14
	jr c,++			; $4f16
	ld (hl),$78		; $4f18
++
	ld l,Part.xh		; $4f1a
	ld a,(hl)		; $4f1c
	cp $f0			; $4f1d
	jr c,+			; $4f1f
	xor a			; $4f21
+
	cp $08			; $4f22
	jr nc,+			; $4f24
	ld (hl),$08		; $4f26
	ret			; $4f28
+
	cp $98			; $4f29
	ret c			; $4f2b
	ld (hl),$98		; $4f2c
	ret			; $4f2e

@moveToMaple:
	ld l,<w1Companion.yh		; $4f2f
	ld b,(hl)		; $4f31
	ld l,<w1Companion.xh		; $4f32
	ld c,(hl)		; $4f34
	push bc			; $4f35
	call objectGetRelativeAngle		; $4f36
	ld e,Part.angle		; $4f39
	ld (de),a		; $4f3b
	call objectApplySpeed		; $4f3c
	pop bc			; $4f3f
	ld h,d			; $4f40
	ld l,Part.yh		; $4f41
	ldi a,(hl)		; $4f43
	cp b			; $4f44
	ret nz			; $4f45
	inc l			; $4f46
	ld a,(hl)		; $4f47
	cp c			; $4f48
	ret			; $4f49

@obtainedValue:
	.db $3c $0f $0a $08 $06 $05 $05 $05
	.db $05 $05 $04 $03 $02 $01 $00


; ==============================================================================
; PARTID_GASHA_TREE
; ==============================================================================
; @addr{4f59}
partCode17:
	jr z,@normalStatus	; $4f59
	ld e,Part.subid		; $4f5b
	ld a,(de)		; $4f5d
	add a			; $4f5e
	ld hl,_table_501e		; $4f5f
	rst_addDoubleIndex			; $4f62
	ld e,Part.var2a		; $4f63
	ld a,(de)		; $4f65
	and $1f			; $4f66
	call checkFlag		; $4f68
	jr z,@normalStatus	; $4f6b
	call checkLinkVulnerable		; $4f6d
	jr nc,@normalStatus	; $4f70
	ld h,d			; $4f72
	ld l,Part.state		; $4f73
	ld (hl),$02		; $4f75
	ld l,Part.collisionType		; $4f77
	res 7,(hl)		; $4f79
	ld l,Part.subid		; $4f7b
	ld a,(hl)		; $4f7d
	or a			; $4f7e
	jr z,@normalStatus	; $4f7f
	ld a,$2a		; $4f81
	call objectGetRelatedObject1Var		; $4f83
	ld (hl),$ff		; $4f86

@normalStatus:
	ld e,Part.state		; $4f88
	ld a,(de)		; $4f8a
	rst_jumpTable			; $4f8b
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $4f92
	ld (de),a		; $4f94
	ld a,$26		; $4f95
	call objectGetRelatedObject1Var		; $4f97
	ld e,Part.collisionRadiusY		; $4f9a
	ldi a,(hl)		; $4f9c
	ld (de),a		; $4f9d
	; collisionRadiusX
	inc e			; $4f9e
	ld a,(hl)		; $4f9f
	ld (de),a		; $4fa0
	call objectTakePosition		; $4fa1
	ld e,Part.var30		; $4fa4
	ld l,$41		; $4fa6
	ld a,(hl)		; $4fa8
	ld (de),a		; $4fa9
	ret			; $4faa

@state1:
	call @func_4fb2		; $4fab
	ret z			; $4fae
	jp partDelete		; $4faf

@func_4fb2:
	ld a,$01		; $4fb2
	call objectGetRelatedObject1Var		; $4fb4
	ld e,Part.var30		; $4fb7
	ld a,(de)		; $4fb9
	cp (hl)			; $4fba
	ret			; $4fbb

@state2:
	call @func_4fb2		; $4fbc
	jp nz,partDelete		; $4fbf
	ld e,Part.state2		; $4fc2
	ld a,(de)		; $4fc4
	rst_jumpTable			; $4fc5
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d			; $4fcc
	ld l,e			; $4fcd
	inc (hl)		; $4fce
	ld l,Part.speed		; $4fcf
	ld (hl),SPEED_100		; $4fd1
	ld a,$1a		; $4fd3
	call objectGetRelatedObject1Var		; $4fd5
	set 6,(hl)		; $4fd8
	ld e,Part.subid		; $4fda
	ld a,(de)		; $4fdc
	or a			; $4fdd
	ld a,$10		; $4fde
	call nz,objectGetAngleTowardLink		; $4fe0
	ld e,Part.angle		; $4fe3
	ld (de),a		; $4fe5
	ld bc,-$140		; $4fe6
	jp objectSetSpeedZ		; $4fe9

@substate1:
	ld c,$18		; $4fec
	call objectUpdateSpeedZAndBounce		; $4fee
	jr z,+			; $4ff1
	call objectApplySpeed		; $4ff3
	ld a,$00		; $4ff6
	call objectGetRelatedObject1Var		; $4ff8
	jp objectCopyPosition		; $4ffb
+
	ld e,Part.state2		; $4ffe
	ld a,$02		; $5000
	ld (de),a		; $5002

@substate2:
	ld c,$18		; $5003
	call objectUpdateSpeedZAndBounce		; $5005
	jr nc,_func_5010	; $5008
	call _func_5010		; $500a
	jp partDelete		; $500d

_func_5010:
	call objectCheckTileCollision_allowHoles		; $5010
	call nc,objectApplySpeed		; $5013
	ld a,$00		; $5016
	call objectGetRelatedObject1Var		; $5018
	jp objectCopyPosition		; $501b

_table_501e:
	.db $f0 $03 $00 $00
	.db $f0 $03 $00 $00


partCode18:
	jr z,_label_10_114	; $5089
	ld e,$ea		; $508b
	ld a,(de)		; $508d
	cp $80			; $508e
	jp z,partDelete		; $5090
	ld h,d			; $5093
	ld l,$c4		; $5094
	ld a,(hl)		; $5096
	cp $02			; $5097
	jr nc,_label_10_114	; $5099
	ld (hl),$02		; $509b
_label_10_114:
	ld e,$c4		; $509d
	ld a,(de)		; $509f
	rst_jumpTable			; $50a0
	xor c			; $50a1
	ld d,b			; $50a2
	or e			; $50a3
	ld d,b			; $50a4
	ret			; $50a5
	ld d,b			; $50a6
	rst $8			; $50a7
	ld b,b			; $50a8
	ld h,d			; $50a9
	ld l,e			; $50aa
	inc (hl)		; $50ab
	ld l,$d0		; $50ac
	ld (hl),$50		; $50ae
	jp objectSetVisible81		; $50b0
	call objectCheckWithinScreenBoundary		; $50b3
	jp nc,partDelete		; $50b6
	call $4072		; $50b9
	jr nc,_label_10_115	; $50bc
	jp z,partDelete		; $50be
	ld e,$c4		; $50c1
	ld a,$02		; $50c3
	ld (de),a		; $50c5
_label_10_115:
	jp objectApplySpeed		; $50c6
	ld a,$03		; $50c9
	ld (de),a		; $50cb
	xor a			; $50cc
	jp $40af		; $50cd

partCode19:
partCode31:
	jp nz,partDelete		; $50d0
	ld e,$c4		; $50d3
	ld a,(de)		; $50d5
	rst_jumpTable			; $50d6
.DB $dd				; $50d7
	ld d,b			; $50d8
.DB $eb				; $50d9
	ld d,b			; $50da
	dec bc			; $50db
	ld d,c			; $50dc
	ld h,d			; $50dd
	ld l,e			; $50de
	inc (hl)		; $50df
	ld l,$c6		; $50e0
	ld (hl),$08		; $50e2
	ld l,$d0		; $50e4
	ld (hl),$3c		; $50e6
	jp objectSetVisible81		; $50e8
	call partCommon_decCounter1IfNonzero		; $50eb
	ret nz			; $50ee
	ld l,e			; $50ef
	inc (hl)		; $50f0
	ld l,$c2		; $50f1
	bit 0,(hl)		; $50f3
	jr z,_label_10_116	; $50f5
	ldh a,(<hFFB2)	; $50f7
	ld b,a			; $50f9
	ldh a,(<hFFB3)	; $50fa
	ld c,a			; $50fc
	call objectGetRelativeAngle		; $50fd
	ld e,$c9		; $5100
	ld (de),a		; $5102
	ret			; $5103
_label_10_116:
	call objectGetAngleTowardEnemyTarget		; $5104
	ld e,$c9		; $5107
	ld (de),a		; $5109
	ret			; $510a
	ld a,(wFrameCounter)		; $510b
	and $03			; $510e
	jr nz,_label_10_117	; $5110
	ld e,$dc		; $5112
	ld a,(de)		; $5114
	xor $07			; $5115
	ld (de),a		; $5117
_label_10_117:
	call objectApplySpeed		; $5118
	call objectCheckWithinScreenBoundary		; $511b
	jp nc,partDelete		; $511e
	jp partAnimate		; $5121

partCode1a:
	jr z,_label_10_118	; $5124
	ld e,$ea		; $5126
	ld a,(de)		; $5128
	cp $80			; $5129
	jr z,_label_10_122	; $512b
	jr _label_10_123		; $512d
_label_10_118:
	ld e,$c2		; $512f
	ld a,(de)		; $5131
	rst_jumpTable			; $5132
	scf			; $5133
	ld d,c			; $5134
	ld h,(hl)		; $5135
	ld d,c			; $5136
	ld e,$c4		; $5137
	ld a,(de)		; $5139
	rst_jumpTable			; $513a
	ld b,c			; $513b
	ld d,c			; $513c
	ld e,l			; $513d
	ld d,c			; $513e
	rst $8			; $513f
	ld b,b			; $5140
	ld h,d			; $5141
	ld l,e			; $5142
	inc (hl)		; $5143
	ld l,$d0		; $5144
	ld (hl),$50		; $5146
	ld l,$cb		; $5148
	ld b,(hl)		; $514a
	ld l,$cd		; $514b
	ld c,(hl)		; $514d
	call $40e0		; $514e
	ld e,$c9		; $5151
	ld a,(de)		; $5153
	swap a			; $5154
	rlca			; $5156
	call partSetAnimation		; $5157
	jp objectSetVisible81		; $515a
_label_10_119:
	call $4072		; $515d
	jr nc,_label_10_121	; $5160
	jr z,_label_10_122	; $5162
	jr _label_10_123		; $5164
	ld e,$c4		; $5166
	ld a,(de)		; $5168
	rst_jumpTable			; $5169
	ld (hl),d		; $516a
	ld d,c			; $516b
	adc c			; $516c
	ld d,c			; $516d
	ld e,l			; $516e
	ld d,c			; $516f
	rst $8			; $5170
	ld b,b			; $5171
	ld h,d			; $5172
	ld l,e			; $5173
	inc (hl)		; $5174
	ld l,$c6		; $5175
	ld (hl),$08		; $5177
	ld l,$d0		; $5179
	ld (hl),$50		; $517b
	ld e,$c9		; $517d
	ld a,(de)		; $517f
	swap a			; $5180
	rlca			; $5182
	call partSetAnimation		; $5183
	jp objectSetVisible81		; $5186
	call partCommon_decCounter1IfNonzero		; $5189
	jr nz,_label_10_120	; $518c
	ld l,e			; $518e
	inc (hl)		; $518f
	jr _label_10_119		; $5190
_label_10_120:
	call $407e		; $5192
	jr z,_label_10_122	; $5195
_label_10_121:
	jp objectApplySpeed		; $5197
_label_10_122:
	jp partDelete		; $519a
_label_10_123:
	ld e,$c2		; $519d
	ld a,(de)		; $519f
	or a			; $51a0
	ld a,$02		; $51a1
	jr z,_label_10_124	; $51a3
	ld a,$03		; $51a5
_label_10_124:
	ld e,$c4		; $51a7
	ld (de),a		; $51a9
	ld a,$04		; $51aa
	jp $40af		; $51ac

partCode1b:
	jr z,_label_10_125	; $51af
	ld e,$ea		; $51b1
	ld a,(de)		; $51b3
	res 7,a			; $51b4
	cp $04			; $51b6
	jp c,partDelete		; $51b8
_label_10_125:
	ld e,$c4		; $51bb
	ld a,(de)		; $51bd
	or a			; $51be
	jr z,_label_10_126	; $51bf
	call objectCheckWithinScreenBoundary		; $51c1
	jp nc,partDelete		; $51c4
	call objectApplySpeed		; $51c7
	ld a,(wFrameCounter)		; $51ca
	and $03			; $51cd
	ret nz			; $51cf
	ld e,$dc		; $51d0
	ld a,(de)		; $51d2
	xor $07			; $51d3
	ld (de),a		; $51d5
	ret			; $51d6
_label_10_126:
	ld h,d			; $51d7
	ld l,e			; $51d8
	inc (hl)		; $51d9
	ld l,$d0		; $51da
	ld (hl),$78		; $51dc
	ld l,$cb		; $51de
	ld b,(hl)		; $51e0
	ld l,$cd		; $51e1
	ld c,(hl)		; $51e3
	call $40e0		; $51e4
	ld e,$c9		; $51e7
	ld a,(de)		; $51e9
	swap a			; $51ea
	rlca			; $51ec
	call partSetAnimation		; $51ed
	jp objectSetVisible81		; $51f0

partCode1c:
	jr z,_label_10_127	; $51f3
	ld e,$ea		; $51f5
	ld a,(de)		; $51f7
	cp $80			; $51f8
	jr z,_label_10_128	; $51fa
	jr _label_10_130		; $51fc
_label_10_127:
	ld e,$c4		; $51fe
	ld a,(de)		; $5200
	rst_jumpTable			; $5201
	ld ($1852),sp		; $5202
	ld d,d			; $5205
	add hl,hl		; $5206
	ld d,d			; $5207
	ld h,d			; $5208
	ld l,e			; $5209
	inc (hl)		; $520a
	ld l,$d0		; $520b
	ld (hl),$3c		; $520d
	call objectGetAngleTowardEnemyTarget		; $520f
	ld e,$c9		; $5212
	ld (de),a		; $5214
	jp objectSetVisible81		; $5215
	call $4072		; $5218
	jr c,_label_10_129	; $521b
	call objectApplySpeed		; $521d
	call objectCheckWithinScreenBoundary		; $5220
	jp c,partAnimate		; $5223
_label_10_128:
	jp partDelete		; $5226
	call partCommon_decCounter1IfNonzero		; $5229
	jr z,_label_10_128	; $522c
	ld c,$0e		; $522e
	call objectUpdateSpeedZ_paramC		; $5230
	call objectApplySpeed		; $5233
	ld a,(wFrameCounter)		; $5236
	rrca			; $5239
	ret c			; $523a
	jp partAnimate		; $523b
_label_10_129:
	jr z,_label_10_128	; $523e
_label_10_130:
	ld e,$c4		; $5240
	ld a,$02		; $5242
	ld (de),a		; $5244
	xor a			; $5245
	jp $40af		; $5246

partCode1d:
	jr z,_label_10_132	; $5249
	ld e,$ea		; $524b
	ld a,(de)		; $524d
	cp $80			; $524e
	jr z,_label_10_132	; $5250
	cp $8a			; $5252
	jr z,_label_10_132	; $5254
	ld a,$2b		; $5256
	call objectGetRelatedObject1Var		; $5258
	ld a,(hl)		; $525b
	or a			; $525c
	jr nz,_label_10_131	; $525d
	ld e,$eb		; $525f
	ld a,(de)		; $5261
	ld (hl),a		; $5262
_label_10_131:
	ld e,$ec		; $5263
	ld a,(de)		; $5265
	inc l			; $5266
	ldi (hl),a		; $5267
	ld e,$ed		; $5268
	ld a,(de)		; $526a
	ld (hl),a		; $526b
_label_10_132:
	ld e,$c4		; $526c
	ld a,(de)		; $526e
	or a			; $526f
	jr z,_label_10_134	; $5270
	ld h,d			; $5272
	ld l,$e4		; $5273
	set 7,(hl)		; $5275
	call $52d6		; $5277
	jp nz,partDelete		; $527a
_label_10_133:
	ld l,$8b		; $527d
	ld b,(hl)		; $527f
	ld l,$8d		; $5280
	ld c,(hl)		; $5282
	ld l,$89		; $5283
	ld a,(hl)		; $5285
	add $04			; $5286
	and $18			; $5288
	rrca			; $528a
	ldh (<hFF8B),a	; $528b
	ld l,$a1		; $528d
	add (hl)		; $528f
	add (hl)		; $5290
	ld hl,$52b0		; $5291
	rst_addAToHl			; $5294
	ld e,$cb		; $5295
	ldi a,(hl)		; $5297
	add b			; $5298
	ld (de),a		; $5299
	ld e,$cd		; $529a
	ld a,(hl)		; $529c
	add c			; $529d
	ld (de),a		; $529e
	ldh a,(<hFF8B)	; $529f
	rrca			; $52a1
	and $02			; $52a2
	ld hl,$52c0		; $52a4
	rst_addAToHl			; $52a7
	ld e,$e6		; $52a8
	ldi a,(hl)		; $52aa
	ld (de),a		; $52ab
	inc e			; $52ac
	ld a,(hl)		; $52ad
	ld (de),a		; $52ae
	ret			; $52af
	ld hl,sp+$04		; $52b0
	or $04			; $52b2
	inc b			; $52b4
	rlca			; $52b5
	inc b			; $52b6
	add hl,bc		; $52b7
	rlca			; $52b8
.DB $fc				; $52b9
	add hl,bc		; $52ba
.DB $fc				; $52bb
	inc b			; $52bc
	ld sp,hl		; $52bd
	inc b			; $52be
	rst $30			; $52bf
	dec b			; $52c0
	ld (bc),a		; $52c1
	ld (bc),a		; $52c2
	dec b			; $52c3
_label_10_134:
	ld h,d			; $52c4
	ld l,e			; $52c5
	inc (hl)		; $52c6
	ld l,$fe		; $52c7
	ld (hl),$04		; $52c9
	ld a,$01		; $52cb
	call objectGetRelatedObject1Var		; $52cd
	ld e,$f0		; $52d0
	ld a,(hl)		; $52d2
	ld (de),a		; $52d3
	jr _label_10_133		; $52d4
	ld a,$01		; $52d6
	call objectGetRelatedObject1Var		; $52d8
	ld e,$f0		; $52db
	ld a,(de)		; $52dd
	cp (hl)			; $52de
	ret nz			; $52df
	ld l,$b0		; $52e0
	bit 0,(hl)		; $52e2
	jr nz,_label_10_135	; $52e4
	ld l,$a9		; $52e6
	ld a,(hl)		; $52e8
	or a			; $52e9
	jr z,_label_10_135	; $52ea
	ld l,$ae		; $52ec
	ld a,(hl)		; $52ee
	or a			; $52ef
	jr nz,_label_10_135	; $52f0
	ld l,$bf		; $52f2
	bit 1,(hl)		; $52f4
	ret z			; $52f6
_label_10_135:
	ld e,$e4		; $52f7
	ld a,(de)		; $52f9
	res 7,a			; $52fa
	ld (de),a		; $52fc
	xor a			; $52fd
	ret			; $52fe

partCode1e:
	jr z,_label_10_136	; $52ff
	ld e,$ea		; $5301
	ld a,(de)		; $5303
	cp $80			; $5304
	jr z,_label_10_136	; $5306
	call $5360		; $5308
	ld h,d			; $530b
	ld l,$c4		; $530c
	ld (hl),$03		; $530e
	ld l,$e4		; $5310
	res 7,(hl)		; $5312
_label_10_136:
	ld e,$c4		; $5314
	ld a,(de)		; $5316
	rst_jumpTable			; $5317
	inc h			; $5318
	ld d,e			; $5319
	scf			; $531a
	ld d,e			; $531b
	ld a,$53		; $531c
	ld c,a			; $531e
	ld d,e			; $531f
	rst $8			; $5320
	ld b,b			; $5321
	ld d,h			; $5322
	ld d,e			; $5323
	ld h,d			; $5324
	ld l,e			; $5325
	inc (hl)		; $5326
	ld l,$d0		; $5327
	ld (hl),$50		; $5329
	ld l,$c6		; $532b
	ld (hl),$08		; $532d
	ld a,$a6		; $532f
	call playSound		; $5331
	jp objectSetVisible81		; $5334
	call partCommon_decCounter1IfNonzero		; $5337
	jr nz,_label_10_138	; $533a
	ld l,e			; $533c
	inc (hl)		; $533d
_label_10_137:
	call $4072		; $533e
	jr nc,_label_10_138	; $5341
	jr nz,_label_10_140	; $5343
	jr _label_10_139		; $5345
_label_10_138:
	call objectCheckWithinScreenBoundary		; $5347
	jp c,objectApplySpeed		; $534a
	jr _label_10_139		; $534d
	call $5399		; $534f
	jr _label_10_137		; $5352
_label_10_139:
	jp partDelete		; $5354
_label_10_140:
	ld e,$c4		; $5357
	ld a,$04		; $5359
	ld (de),a		; $535b
	xor a			; $535c
	jp $40af		; $535d
	ld e,$c9		; $5360
	ld a,(de)		; $5362
	bit 2,a			; $5363
	jr nz,_label_10_141	; $5365
	sub $08			; $5367
	rrca			; $5369
	ld b,a			; $536a
	ld a,($d008)		; $536b
	add b			; $536e
	ld hl,$538d		; $536f
	rst_addAToHl			; $5372
	ld a,(hl)		; $5373
	ld (de),a		; $5374
	ret			; $5375
_label_10_141:
	sub $0c			; $5376
	rrca			; $5378
	ld b,a			; $5379
	ld a,($d008)		; $537a
	add b			; $537d
	ld hl,$5385		; $537e
	rst_addAToHl			; $5381
	ld a,(hl)		; $5382
	ld (de),a		; $5383
	ret			; $5384
	inc b			; $5385
	ld ($1410),sp		; $5386
	inc e			; $5389
	inc c			; $538a
	stop			; $538b
	jr _label_10_142		; $538c
	ld ($180c),sp		; $538e
	nop			; $5391
_label_10_142:
	inc c			; $5392
	stop			; $5393
	inc d			; $5394
	inc e			; $5395
	ld ($1814),sp		; $5396
	ld a,$24		; $5399
	call objectGetRelatedObject1Var		; $539b
	bit 7,(hl)		; $539e
	ret z			; $53a0
	call checkObjectsCollided		; $53a1
	ret nc			; $53a4
	ld l,$aa		; $53a5
	ld (hl),$82		; $53a7
	ld l,$b0		; $53a9
	dec (hl)		; $53ab
	ld l,$ab		; $53ac
	ld (hl),$0c		; $53ae
	ld e,$c4		; $53b0
	ld a,$04		; $53b2
	ld (de),a		; $53b4
	ret			; $53b5

partCode1f:
	jr nz,_label_10_143	; $53b6
	ld e,$c4		; $53b8
	ld a,(de)		; $53ba
	or a			; $53bb
	jr z,_label_10_144	; $53bc
	call objectCheckWithinScreenBoundary		; $53be
	jr nc,_label_10_143	; $53c1
	call $4072		; $53c3
	jp nc,objectApplySpeed		; $53c6
_label_10_143:
	jp partDelete		; $53c9
_label_10_144:
	ld h,d			; $53cc
	ld l,e			; $53cd
	inc (hl)		; $53ce
	ld l,$d0		; $53cf
	ld (hl),$50		; $53d1
	ld e,$c9		; $53d3
	ld a,(de)		; $53d5
	swap a			; $53d6
	rlca			; $53d8
	call partSetAnimation		; $53d9
	jp objectSetVisible81		; $53dc

partCode20:
	ld e,$c4		; $53df
	ld a,(de)		; $53e1
	or a			; $53e2
	jr z,_label_10_145	; $53e3
	call partCommon_decCounter1IfNonzero		; $53e5
	jp z,partDelete		; $53e8
	jp partAnimate		; $53eb
_label_10_145:
	ld h,d			; $53ee
	ld l,e			; $53ef
	inc (hl)		; $53f0
	ld l,$c6		; $53f1
	ld (hl),$b4		; $53f3
	jp objectSetVisible82		; $53f5

partCode21:
	jr z,_label_10_146	; $53f8
	ld e,$ea		; $53fa
	ld a,(de)		; $53fc
	res 7,a			; $53fd
	sub $01			; $53ff
	cp $03			; $5401
	jr nc,_label_10_146	; $5403
	ld e,$c4		; $5405
	ld a,$02		; $5407
	ld (de),a		; $5409
_label_10_146:
	ld e,$d7		; $540a
	ld a,(de)		; $540c
	inc a			; $540d
	jr z,_label_10_149	; $540e
	ld e,$c4		; $5410
	ld a,(de)		; $5412
	rst_jumpTable			; $5413
	ld a,(de)		; $5414
	ld d,h			; $5415
	dec hl			; $5416
	ld d,h			; $5417
	ld a,$54		; $5418
	ld h,d			; $541a
	ld l,e			; $541b
	inc (hl)		; $541c
	ld l,$c6		; $541d
	ld (hl),$2d		; $541f
	inc l			; $5421
	ld (hl),$06		; $5422
	ld l,$d0		; $5424
	ld (hl),$50		; $5426
	jp objectSetVisible81		; $5428
	call objectCheckSimpleCollision		; $542b
	jr nz,_label_10_150	; $542e
	call partCommon_decCounter1IfNonzero		; $5430
	jr z,_label_10_150	; $5433
	call $548d		; $5435
_label_10_147:
	call objectApplySpeed		; $5438
_label_10_148:
	jp partAnimate		; $543b
	call $547d		; $543e
	call $5458		; $5441
	jr nc,_label_10_147	; $5444
	ld a,$18		; $5446
	call objectGetRelatedObject1Var		; $5448
	xor a			; $544b
	ldi (hl),a		; $544c
	ld (hl),a		; $544d
_label_10_149:
	jp partDelete		; $544e
_label_10_150:
	ld e,$c4		; $5451
	ld a,$02		; $5453
	ld (de),a		; $5455
	jr _label_10_148		; $5456
	ld a,$0b		; $5458
	call objectGetRelatedObject1Var		; $545a
	push hl			; $545d
	ld b,(hl)		; $545e
	ld l,$8d		; $545f
	ld c,(hl)		; $5461
	call objectGetRelativeAngle		; $5462
	ld e,$c9		; $5465
	ld (de),a		; $5467
	pop hl			; $5468
	ld e,$cb		; $5469
	ld a,(de)		; $546b
	sub (hl)		; $546c
	add $04			; $546d
	cp $09			; $546f
	ret nc			; $5471
	ld l,$8d		; $5472
	ld e,$cd		; $5474
	ld a,(de)		; $5476
	sub (hl)		; $5477
	add $04			; $5478
	cp $09			; $547a
	ret			; $547c
	ld a,(wFrameCounter)		; $547d
	and $03			; $5480
	ret nz			; $5482
	ld e,$d0		; $5483
	ld a,(de)		; $5485
	add $05			; $5486
	cp $50			; $5488
	ret nc			; $548a
	ld (de),a		; $548b
	ret			; $548c
	ld h,d			; $548d
	ld l,$c7		; $548e
	dec (hl)		; $5490
	ret nz			; $5491
	ld (hl),$06		; $5492
	ld e,$d0		; $5494
	ld a,(de)		; $5496
	sub $05			; $5497
	ret c			; $5499
	ld (de),a		; $549a
	ret			; $549b

partCode22:
	ld e,$c4		; $549c
	ld a,(de)		; $549e
	rst_jumpTable			; $549f
	and (hl)		; $54a0
	ld d,h			; $54a1
	rst $38			; $54a2
	ld d,h			; $54a3
	ld ($6255),sp		; $54a4
	ld l,e			; $54a7
	inc (hl)		; $54a8
	ld l,$c6		; $54a9
	ld (hl),$18		; $54ab
	ld l,$cf		; $54ad
	ld (hl),$fa		; $54af
	ld a,$30		; $54b1
	call objectGetRelatedObject1Var		; $54b3
	ld a,(hl)		; $54b6
	sub $10			; $54b7
	and $1e			; $54b9
	rrca			; $54bb
	ld hl,$5538		; $54bc
	rst_addAToHl			; $54bf
	ld e,$d0		; $54c0
	ld a,(hl)		; $54c2
	ld (de),a		; $54c3
	call objectSetVisiblec1		; $54c4
	call getRandomNumber_noPreserveVars		; $54c7
	ld c,a			; $54ca
	and $30			; $54cb
	ld b,a			; $54cd
	swap b			; $54ce
	and $10			; $54d0
	ld hl,$5518		; $54d2
	rst_addAToHl			; $54d5
	ld a,c			; $54d6
	and $0f			; $54d7
	rst_addAToHl			; $54d9
	bit 0,b			; $54da
	ld e,$cb		; $54dc
	ld c,$cd		; $54de
	jr nz,_label_10_151	; $54e0
	ld e,c			; $54e2
	ld c,$cb		; $54e3
_label_10_151:
	ld a,(hl)		; $54e5
	ld (de),a		; $54e6
	ld a,b			; $54e7
	ld hl,$5514		; $54e8
	rst_addAToHl			; $54eb
	ld e,c			; $54ec
	ld a,(hl)		; $54ed
	ld (de),a		; $54ee
	call objectGetAngleTowardEnemyTarget		; $54ef
	ld e,$c9		; $54f2
	ld (de),a		; $54f4
	cp $11			; $54f5
	ld a,$00		; $54f7
	jr nc,_label_10_152	; $54f9
	inc a			; $54fb
_label_10_152:
	jp partSetAnimation		; $54fc
	call partCommon_decCounter1IfNonzero		; $54ff
	jr nz,_label_10_153	; $5502
	ld l,e			; $5504
	inc (hl)		; $5505
	jr _label_10_153		; $5506
	call objectCheckWithinScreenBoundary		; $5508
	jp nc,partDelete		; $550b
_label_10_153:
	call objectApplySpeed		; $550e
	jp partAnimate		; $5511
	ld ($8898),sp		; $5514
	ld ($0e05),sp		; $5517
	rla			; $551a
	jr nz,_label_10_154	; $551b
	ldd (hl),a		; $551d
	dec sp			; $551e
	ld b,h			; $551f
	ld c,l			; $5520
	ld d,(hl)		; $5521
	ld e,a			; $5522
	ld l,b			; $5523
	ld (hl),c		; $5524
	ld a,d			; $5525
	add e			; $5526
	adc h			; $5527
	dec b			; $5528
	rrca			; $5529
	add hl,de		; $552a
	inc hl			; $552b
	dec l			; $552c
	scf			; $552d
	ld b,c			; $552e
	ld c,e			; $552f
	ld d,l			; $5530
	ld e,a			; $5531
	ld l,c			; $5532
	ld (hl),e		; $5533
	ld a,l			; $5534
	add a			; $5535
	sub c			; $5536
	sbc e			; $5537
	ldd (hl),a		; $5538
	inc a			; $5539
	ld b,(hl)		; $553a
	ld d,b			; $553b
	ld e,d			; $553c
	ld e,d			; $553d
	ld h,h			; $553e
	ld l,(hl)		; $553f
	ld a,b			; $5540

partCode23:
	ld e,$c2		; $5541
	ld a,(de)		; $5543
	ld e,$c4		; $5544
_label_10_154:
	rst_jumpTable			; $5546
	ld c,l			; $5547
	ld d,l			; $5548
	ld e,h			; $5549
	ld d,l			; $554a
	ld a,b			; $554b
	ld d,l			; $554c
	ld a,(de)		; $554d
	or a			; $554e
	jr z,_label_10_155	; $554f
	call partCommon_decCounter1IfNonzero		; $5551
	ret nz			; $5554
	ld (hl),$3c		; $5555
	jr _label_10_156		; $5557
_label_10_155:
	inc a			; $5559
	ld (de),a		; $555a
	ret			; $555b
	ld a,(de)		; $555c
	or a			; $555d
	jr z,_label_10_155	; $555e
	call partCommon_decCounter1IfNonzero		; $5560
	ret nz			; $5563
	call $55a2		; $5564
_label_10_156:
	call getFreePartSlot		; $5567
	ret nz			; $556a
	ld (hl),$23		; $556b
	inc l			; $556d
	ld (hl),$02		; $556e
	ld l,$f0		; $5570
	ld e,l			; $5572
	ld a,(de)		; $5573
	ld (hl),a		; $5574
	jp objectCopyPosition		; $5575
	ld a,(de)		; $5578
	or a			; $5579
	jr z,_label_10_157	; $557a
	ld h,d			; $557c
	ld l,$cb		; $557d
	ld a,(hl)		; $557f
	cp $b0			; $5580
	jp nc,partDelete		; $5582
	ld l,$d0		; $5585
	ld e,$ca		; $5587
	call add16BitRefs		; $5589
	dec l			; $558c
	ld a,(hl)		; $558d
	add $10			; $558e
	ldi (hl),a		; $5590
	ld a,(hl)		; $5591
	adc $00			; $5592
	ld (hl),a		; $5594
	jp partAnimate		; $5595
_label_10_157:
	ld h,d			; $5598
	ld l,e			; $5599
	inc (hl)		; $559a
	ld l,$e4		; $559b
	set 7,(hl)		; $559d
	jp objectSetVisible81		; $559f
	ld e,$87		; $55a2
	ld a,(de)		; $55a4
	inc a			; $55a5
	and $03			; $55a6
	ld (de),a		; $55a8
	ld hl,$55b2		; $55a9
	rst_addAToHl			; $55ac
	ld e,$c6		; $55ad
	ld a,(hl)		; $55af
	ld (de),a		; $55b0
	ret			; $55b1
	inc a			; $55b2
	inc a			; $55b3
	ld e,$1e		; $55b4


; ==============================================================================
; PARTID_LIGHTNING
; ==============================================================================
; @addr{5553}
partCode27:
	ld e,Part.state		; $5553
	ld a,(de)		; $5555
	rst_jumpTable			; $5556
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $555d
	ld (de),a		; $555f
	call getRandomNumber_noPreserveVars		; $5560
	ld e,Part.var30		; $5563
	and $06			; $5565
	ld (de),a		; $5567

	ld h,d			; $5568
	ld l,Part.zh		; $5569
	ld (hl),$c0		; $556b

	ld l,Part.relatedObj1+1		; $556d
	ld a,(hl)		; $556f
	or a			; $5570
	ret z			; $5571

	ld l,Part.counter1		; $5572
	ld (hl),$1e		; $5574
	ld l,Part.yh		; $5576
	ldh a,(<hEnemyTargetY)	; $5578
	ldi (hl),a		; $557a
	inc l			; $557b
	ldh a,(<hEnemyTargetX)	; $557c
	ld (hl),a		; $557e
	ret			; $557f

@state1:
	call partCommon_decCounter1IfNonzero		; $5580
	ret nz			; $5583
	ld l,e			; $5584
	inc (hl)		; $5585
	ld a,SND_LIGHTNING		; $5586
	call playSound		; $5588
	jp objectSetVisible81		; $558b

@state2:
	call partAnimate		; $558e
	ld e,Part.animParameter		; $5591
	ld a,(de)		; $5593
	inc a			; $5594
	jp z,partDelete		; $5595

	call @func_55a6		; $5598
	ld e,Part.var03		; $559b
	ld a,(de)		; $559d
	or a			; $559e
	ret z			; $559f
.ifdef ROM_AGES
	ld a,$ff		; $55a0
.else
	ld b,a			; $5603
	ld a,($cfd2)		; $5604
	or b			; $5607
.endif
	ld ($cfd2),a		; $55a2
	ret			; $55a5

@func_55a6:
	ld e,Part.animParameter		; $55a6
	ld a,(de)		; $55a8
	bit 7,a			; $55a9
	call nz,@func_55e7		; $55ab
	ld e,Part.animParameter		; $55ae
	ld a,(de)		; $55b0
	and $0e			; $55b1

	ld hl,@table_55da		; $55b3
	rst_addAToHl			; $55b6
	ld e,$e6		; $55b7
	ldi a,(hl)		; $55b9
	ld (de),a		; $55ba
	inc e			; $55bb
	ld a,(hl)		; $55bc
	ld (de),a		; $55bd
	ld e,Part.animParameter		; $55be
	ld a,(de)		; $55c0
	and $70			; $55c1
	swap a			; $55c3
	ld hl,@table_55e2		; $55c5
	rst_addAToHl			; $55c8
	ld e,$cf		; $55c9
	ld a,(hl)		; $55cb
	ld (de),a		; $55cc
	ld e,$e1		; $55cd
	ld a,(de)		; $55cf
	bit 0,a			; $55d0
	ret z			; $55d2
	dec a			; $55d3
	ld (de),a		; $55d4
	ld a,$06		; $55d5
	jp setScreenShakeCounter		; $55d7

@table_55da:
	.db $02 $02
	.db $04 $06
	.db $05 $09
	.db $04 $05

@table_55e2:
	.db $c0 $d0
	.db $e0 $f0
	.db $00

@func_55e7:
	res 7,a			; $55e7
	ld (de),a		; $55e9
	and $0e			; $55ea
	sub $02			; $55ec
	ld b,a			; $55ee
	ld e,Part.var30		; $55ef
	ld a,(de)		; $55f1
	add b			; $55f2
	ld hl,@table_5603		; $55f3
	rst_addAToHl			; $55f6
	ldi a,(hl)		; $55f7
	ld c,(hl)		; $55f8
	ld b,a			; $55f9
	call getFreeInteractionSlot		; $55fa
	ret nz			; $55fd
	ld (hl),$08		; $55fe
	jp objectCopyPositionWithOffset		; $5600

@table_5603:
	.db $02 $06
	.db $00 $fb
	.db $ff $07
	.db $fd $fc
	.db $00 $05


partCode28:
	jr z,_label_10_158	; $5673
	cp $02			; $5675
	jp z,$5702		; $5677
	ld e,$c4		; $567a
	ld a,$02		; $567c
	ld (de),a		; $567e
_label_10_158:
	ld e,$c4		; $567f
	ld a,(de)		; $5681
	rst_jumpTable			; $5682
	adc c			; $5683
	ld d,(hl)		; $5684
	sbc (hl)		; $5685
	ld d,(hl)		; $5686
	ret nc			; $5687
	ld d,(hl)		; $5688
	ld h,d			; $5689
	ld l,$c4		; $568a
	inc (hl)		; $568c
	ld l,$cf		; $568d
	ld (hl),$fa		; $568f
	ld l,$f1		; $5691
	ld e,$cb		; $5693
	ld a,(de)		; $5695
	ldi (hl),a		; $5696
	ld e,$cd		; $5697
	ld a,(de)		; $5699
	ld (hl),a		; $569a
	jp objectSetVisiblec2		; $569b
	call partCommon_decCounter1IfNonzero		; $569e
	jr z,_label_10_159	; $56a1
	call $5733		; $56a3
	jp c,objectApplySpeed		; $56a6
_label_10_159:
	call getRandomNumber_noPreserveVars		; $56a9
	and $3e			; $56ac
	add $08			; $56ae
	ld e,$c6		; $56b0
	ld (de),a		; $56b2
	call getRandomNumber_noPreserveVars		; $56b3
	and $03			; $56b6
	ld hl,$56cc		; $56b8
	rst_addAToHl			; $56bb
	ld e,$d0		; $56bc
	ld a,(hl)		; $56be
	ld (de),a		; $56bf
	call getRandomNumber_noPreserveVars		; $56c0
	and $1e			; $56c3
	ld h,d			; $56c5
	ld l,$c9		; $56c6
	ld (hl),a		; $56c8
	jp $571c		; $56c9
	ld a,(bc)		; $56cc
	inc d			; $56cd
	ld e,$28		; $56ce
	ld e,$c5		; $56d0
	ld a,(de)		; $56d2
	or a			; $56d3
	jr nz,_label_10_160	; $56d4
	ld h,d			; $56d6
	ld l,e			; $56d7
	inc (hl)		; $56d8
	ld l,$cf		; $56d9
	ld (hl),$00		; $56db
	ld a,$01		; $56dd
	call objectGetRelatedObject1Var		; $56df
	ld a,(hl)		; $56e2
	ld e,$f0		; $56e3
	ld (de),a		; $56e5
	call objectSetVisible80		; $56e6
_label_10_160:
	call objectCheckCollidedWithLink		; $56e9
	jp c,$5702		; $56ec
	ld a,$00		; $56ef
	call objectGetRelatedObject1Var		; $56f1
	ldi a,(hl)		; $56f4
	or a			; $56f5
	jr z,_label_10_161	; $56f6
	ld e,$f0		; $56f8
	ld a,(de)		; $56fa
	cp (hl)			; $56fb
	jp z,objectTakePosition		; $56fc
_label_10_161:
	jp partDelete		; $56ff
	ld a,$26		; $5702
	call cpActiveRing		; $5704
	ld c,$18		; $5707
	jr z,_label_10_162	; $5709
	ld a,$25		; $570b
	call cpActiveRing		; $570d
	jr nz,_label_10_163	; $5710
_label_10_162:
	ld c,$30		; $5712
_label_10_163:
	ld a,$29		; $5714
	call giveTreasure		; $5716
	jp partDelete		; $5719
	ld e,$c9		; $571c
	ld a,(de)		; $571e
	and $0f			; $571f
	ret z			; $5721
	ld a,(de)		; $5722
	cp $10			; $5723
	ld a,$00		; $5725
	jr nc,_label_10_164	; $5727
	inc a			; $5729
_label_10_164:
	ld h,d			; $572a
	ld l,$c8		; $572b
	cp (hl)			; $572d
	ret z			; $572e
	ld (hl),a		; $572f
	jp partSetAnimation		; $5730
	ld e,$c9		; $5733
	ld a,(de)		; $5735
	and $07			; $5736
	ld a,(de)		; $5738
	jr z,_label_10_165	; $5739
	and $18			; $573b
	add $04			; $573d
_label_10_165:
	and $1c			; $573f
	rrca			; $5741
	ld hl,$575b		; $5742
	rst_addAToHl			; $5745
	ld e,$cb		; $5746
	ld a,(de)		; $5748
	add (hl)		; $5749
	ld b,a			; $574a
	ld e,$cd		; $574b
	inc hl			; $574d
	ld a,(de)		; $574e
	add (hl)		; $574f
	sub $38			; $5750
	cp $80			; $5752
	ret nc			; $5754
	ld a,b			; $5755
	sub $18			; $5756
	cp $50			; $5758
	ret			; $575a
.DB $fc				; $575b
	nop			; $575c
.DB $fc				; $575d
	inc b			; $575e
	nop			; $575f
	inc b			; $5760
	inc b			; $5761
	inc b			; $5762
	inc b			; $5763
	nop			; $5764
	inc b			; $5765
.DB $fc				; $5766
	nop			; $5767
.DB $fc				; $5768
.DB $fc				; $5769
.DB $fc				; $576a

partCode29:
	jr z,_label_10_166	; $576b
	ld e,$ea		; $576d
	ld a,(de)		; $576f
	cp $83			; $5770
	jp z,partDelete		; $5772
_label_10_166:
	ld e,$c4		; $5775
	ld a,(de)		; $5777
	rst_jumpTable			; $5778
	ld a,a			; $5779
	ld d,a			; $577a
	xor l			; $577b
	ld d,a			; $577c
	or h			; $577d
	ld d,a			; $577e
	ld h,d			; $577f
	ld l,e			; $5780
	inc (hl)		; $5781
	ld l,$c6		; $5782
	ld (hl),$02		; $5784
	ld l,$c9		; $5786
	ld c,(hl)		; $5788
	ld b,$50		; $5789
	ld a,$04		; $578b
	call objectSetComponentSpeedByScaledVelocity		; $578d
	ld e,$c9		; $5790
	ld a,(de)		; $5792
	and $0f			; $5793
	ld hl,$579d		; $5795
	rst_addAToHl			; $5798
	ld a,(hl)		; $5799
	jp partSetAnimation		; $579a
	nop			; $579d
	nop			; $579e
	ld bc,$0202		; $579f
	ld (bc),a		; $57a2
	inc bc			; $57a3
	inc b			; $57a4
	inc b			; $57a5
	inc b			; $57a6
	dec b			; $57a7
	ld b,$06		; $57a8
	ld b,$07		; $57aa
	nop			; $57ac
	call partCommon_decCounter1IfNonzero		; $57ad
	jr nz,_label_10_167	; $57b0
	ld l,e			; $57b2
	inc (hl)		; $57b3
	call $57be		; $57b4
	call $4072		; $57b7
	jp c,partDelete		; $57ba
	ret			; $57bd
_label_10_167:
	call objectApplyComponentSpeed		; $57be
	ld e,$c2		; $57c1
	ld a,(de)		; $57c3
	ld b,a			; $57c4
	ld a,(wFrameCounter)		; $57c5
	and b			; $57c8
	jp z,objectSetVisible81		; $57c9
	jp objectSetInvisible		; $57cc

partCode2a:
	jr z,_label_10_169	; $57cf
	ld e,$ea		; $57d1
	ld a,(de)		; $57d3
	res 7,a			; $57d4
	sub $01			; $57d6
	cp $09			; $57d8
	jr nc,_label_10_169	; $57da
	ld a,$2b		; $57dc
	call objectGetRelatedObject1Var		; $57de
	ld a,(hl)		; $57e1
	or a			; $57e2
	jr nz,_label_10_168	; $57e3
	ld (hl),$f4		; $57e5
_label_10_168:
	ld h,d			; $57e7
	ld l,$d5		; $57e8
	ld a,(hl)		; $57ea
	rlca			; $57eb
	jr c,_label_10_169	; $57ec
	xor a			; $57ee
	ldd (hl),a		; $57ef
	ld (hl),a		; $57f0
_label_10_169:
	ld e,$c2		; $57f1
	ld a,(de)		; $57f3
	ld b,a			; $57f4
	ld e,$c4		; $57f5
	ld a,b			; $57f7
	rst_jumpTable			; $57f8
	ld bc,$a358		; $57f9
	ld e,b			; $57fc
	and e			; $57fd
	ld e,b			; $57fe
	and e			; $57ff
	ld e,b			; $5800
	ld a,$01		; $5801
	call objectGetRelatedObject1Var		; $5803
	ld a,(hl)		; $5806
	cp $4b			; $5807
	jp nz,partDelete		; $5809
	ld b,h			; $580c
	call $590b		; $580d
	ld e,$c4		; $5810
	ld a,(de)		; $5812
	rst_jumpTable			; $5813
	jr nz,_label_10_172	; $5814
	ldi a,(hl)		; $5816
	ld e,b			; $5817
	inc sp			; $5818
	ld e,b			; $5819
	ld c,e			; $581a
	ld e,b			; $581b
	ld a,l			; $581c
	ld e,b			; $581d
	sbc d			; $581e
	ld e,b			; $581f
	ld h,d			; $5820
	ld l,e			; $5821
	inc (hl)		; $5822
	ld l,$e4		; $5823
	set 7,(hl)		; $5825
	call objectSetVisible81		; $5827
	ld e,$c9		; $582a
	ld a,(de)		; $582c
	inc a			; $582d
	and $1f			; $582e
	ld (de),a		; $5830
	jr _label_10_171		; $5831
_label_10_170:
	ld e,$c9		; $5833
	ld a,(de)		; $5835
	add $02			; $5836
	and $1f			; $5838
	ld (de),a		; $583a
_label_10_171:
	ld e,$f0		; $583b
	ld a,$0a		; $583d
	ld (de),a		; $583f
	call $58c8		; $5840
	ld e,$f0		; $5843
	ld a,(de)		; $5845
	ld e,$c9		; $5846
	jp objectSetPositionInCircleArc		; $5848
	call $58c8		; $584b
	ldh a,(<hEnemyTargetY)	; $584e
	ldh (<hFF8F),a	; $5850
	ldh a,(<hEnemyTargetX)	; $5852
	ldh (<hFF8E),a	; $5854
	push hl			; $5856
	call objectGetRelativeAngleWithTempVars		; $5857
	pop bc			; $585a
	xor $10			; $585b
	ld e,a			; $585d
	sub $06			; $585e
	and $1f			; $5860
	ld h,d			; $5862
	ld l,$c9		; $5863
	sub (hl)		; $5865
	inc a			; $5866
	and $1f			; $5867
	cp $03			; $5869
	jr nc,_label_10_170	; $586b
	ld a,e			; $586d
_label_10_172:
	sub $03			; $586e
	and $1f			; $5870
	ld (hl),a		; $5872
	ld l,$c4		; $5873
	inc (hl)		; $5875
	ld l,$f0		; $5876
	ld (hl),$0d		; $5878
	jp $5840		; $587a
	ld h,d			; $587d
	ld l,e			; $587e
	inc (hl)		; $587f
	ld l,$c6		; $5880
	ld (hl),$00		; $5882
	ld l,$c9		; $5884
	ld a,(hl)		; $5886
	add $03			; $5887
	and $1f			; $5889
	ld (hl),a		; $588b
	ld l,$f0		; $588c
	ld (hl),$12		; $588e
	ld l,$d0		; $5890
	ld a,$40		; $5892
	ldi (hl),a		; $5894
	ld (hl),$03		; $5895
	jp $5840		; $5897
	call $58da		; $589a
	call $58ed		; $589d
	jp $5840		; $58a0
	ld a,(de)		; $58a3
	or a			; $58a4
	jr nz,_label_10_173	; $58a5
	inc a			; $58a7
	ld (de),a		; $58a8
	call partSetAnimation		; $58a9
	call objectSetVisible81		; $58ac
_label_10_173:
	ld a,$01		; $58af
	call objectGetRelatedObject1Var		; $58b1
	ld a,(hl)		; $58b4
	cp $2a			; $58b5
	jp nz,partDelete		; $58b7
	ld l,$c9		; $58ba
	ld e,l			; $58bc
	ld a,(hl)		; $58bd
	ld (de),a		; $58be
	call $592b		; $58bf
	ld l,$d7		; $58c2
	ld b,(hl)		; $58c4
	jp $5840		; $58c5
	ld h,b			; $58c8
	ld l,$8b		; $58c9
	ldi a,(hl)		; $58cb
	sub $05			; $58cc
	ld b,a			; $58ce
	inc l			; $58cf
	ldi a,(hl)		; $58d0
	sub $05			; $58d1
	ld c,a			; $58d3
	inc l			; $58d4
	ld a,(hl)		; $58d5
	ld e,$cf		; $58d6
	ld (de),a		; $58d8
	ret			; $58d9
	ld h,d			; $58da
	ld l,$ea		; $58db
	bit 7,(hl)		; $58dd
	ret z			; $58df
	ld a,(hl)		; $58e0
	cp $80			; $58e1
	ret z			; $58e3
	ld l,$d1		; $58e4
	bit 7,(hl)		; $58e6
	ret nz			; $58e8
	xor a			; $58e9
	ldd (hl),a		; $58ea
	ld (hl),a		; $58eb
	ret			; $58ec
	ld h,d			; $58ed
	ld e,$f0		; $58ee
	ld l,$d1		; $58f0
	ld a,(de)		; $58f2
	add (hl)		; $58f3
	cp $0a			; $58f4
	jr c,_label_10_174	; $58f6
	ld (de),a		; $58f8
	dec l			; $58f9
	ld a,(hl)		; $58fa
	sub $20			; $58fb
	ldi (hl),a		; $58fd
	ld a,(hl)		; $58fe
	sbc $00			; $58ff
	ld (hl),a		; $5901
	ret			; $5902
_label_10_174:
	ld a,$06		; $5903
	call objectGetRelatedObject1Var		; $5905
	ld (hl),$00		; $5908
	ret			; $590a
	ld l,$b0		; $590b
	ld e,$c4		; $590d
	ld a,(de)		; $590f
	dec a			; $5910
	cp $03			; $5911
	jr c,_label_10_175	; $5913
	inc a			; $5915
	ret z			; $5916
	ld a,(hl)		; $5917
	cp $02			; $5918
	ret z			; $591a
_label_10_175:
	ld a,(hl)		; $591b
	or a			; $591c
	ld c,$01		; $591d
	jr z,_label_10_176	; $591f
	inc c			; $5921
	dec a			; $5922
	jr z,_label_10_176	; $5923
	inc c			; $5925
_label_10_176:
	ld e,$c4		; $5926
	ld a,c			; $5928
	ld (de),a		; $5929
	ret			; $592a
	ld l,$f0		; $592b
	push hl			; $592d
	ld e,$c2		; $592e
	ld a,(de)		; $5930
	dec a			; $5931
	rst_jumpTable			; $5932
	add hl,sp		; $5933
	ld e,c			; $5934
	ld b,(hl)		; $5935
	ld e,c			; $5936
	ld d,b			; $5937
	ld e,c			; $5938
	pop hl			; $5939
	ld e,l			; $593a
	ld a,(hl)		; $593b
	srl a			; $593c
	srl a			; $593e
	ld b,a			; $5940
	add a			; $5941
	add b			; $5942
	inc a			; $5943
	ld (de),a		; $5944
	ret			; $5945
	pop hl			; $5946
	ld e,l			; $5947
	ld a,(hl)		; $5948
	srl a			; $5949
	srl a			; $594b
	add a			; $594d
	ld (de),a		; $594e
	ret			; $594f
	pop hl			; $5950
	ld e,l			; $5951
	ld a,(hl)		; $5952
	srl a			; $5953
	srl a			; $5955
	ld (de),a		; $5957
	ret			; $5958

partCode30:
	ld e,$c4		; $5959
	ld a,(de)		; $595b
	or a			; $595c
	jr nz,_label_10_177	; $595d
	ld h,d			; $595f
	ld l,e			; $5960
	inc (hl)		; $5961
	ld l,$c6		; $5962
	ld (hl),$03		; $5964
	call objectSetVisible81		; $5966
_label_10_177:
	ldh a,(<hEnemyTargetY)	; $5969
	ld b,a			; $596b
	ldh a,(<hEnemyTargetX)	; $596c
	ld c,a			; $596e
	ld a,$20		; $596f
	ld e,$c9		; $5971
	call objectSetPositionInCircleArc		; $5973
	call partCommon_decCounter1IfNonzero		; $5976
	ret nz			; $5979
	ld (hl),$03		; $597a
	ld l,$c9		; $597c
	ld a,(hl)		; $597e
	dec a			; $597f
	and $1f			; $5980
	ld (hl),a		; $5982
	ret nz			; $5983
	ld hl,$c6a3		; $5984
	ld a,($cbe4)		; $5987
	cp (hl)			; $598a
	ret nz			; $598b
	ld a,$31		; $598c
	call objectGetRelatedObject1Var		; $598e
	dec (hl)		; $5991
	jp partDelete		; $5992

partCode4b:
partCode4d:
	jr z,_label_10_178	; $5995
	ld e,$ea		; $5997
	ld a,(de)		; $5999
	cp $83			; $599a
	jp z,partDelete		; $599c
	cp $80			; $599f
	jr z,_label_10_178	; $59a1
	call objectGetAngleTowardEnemyTarget		; $59a3
	xor $10			; $59a6
	ld h,d			; $59a8
	ld l,$c9		; $59a9
	ld (hl),a		; $59ab
	ld l,$c4		; $59ac
	ld (hl),$03		; $59ae
	ld l,$d0		; $59b0
	ld (hl),$64		; $59b2
_label_10_178:
	ld a,$04		; $59b4
	call objectGetRelatedObject1Var		; $59b6
	ld a,(hl)		; $59b9
	cp $0d			; $59ba
	jp nc,seasonsFunc_10_5a4e		; $59bc
	ld e,$c4		; $59bf
	ld a,(de)		; $59c1
	rst_jumpTable			; $59c2
	bit 3,c			; $59c3
.DB $fc				; $59c5
	ld e,c			; $59c6
	ld e,$5a		; $59c7
	add hl,hl		; $59c9
	ld e,d			; $59ca
	ld h,d			; $59cb
	ld l,e			; $59cc
	inc (hl)		; $59cd
	ld l,$c6		; $59ce
	ld (hl),$1e		; $59d0
	ld l,$d0		; $59d2
	ld (hl),$50		; $59d4
	ld l,$cf		; $59d6
	ld a,(hl)		; $59d8
	ld (hl),$00		; $59d9
	ld l,$cb		; $59db
	add (hl)		; $59dd
	ld (hl),a		; $59de
	ld a,$16		; $59df
	call objectGetRelatedObject1Var		; $59e1
	ld e,$d8		; $59e4
	ldi a,(hl)		; $59e6
	ld (de),a		; $59e7
	inc e			; $59e8
	ld a,(hl)		; $59e9
	ld (de),a		; $59ea
	ld e,$c1		; $59eb
	ld a,(de)		; $59ed
	cp $4b			; $59ee
	ld a,$ba		; $59f0
	jr z,_label_10_179	; $59f2
	ld a,$bb		; $59f4
_label_10_179:
	call playSound		; $59f6
	call objectSetVisible81		; $59f9
	call partCommon_decCounter1IfNonzero		; $59fc
	jr z,_label_10_180	; $59ff
	ld a,$0b		; $5a01
	call objectGetRelatedObject1Var		; $5a03
	ld bc,$ea00		; $5a06
	call objectTakePositionWithOffset		; $5a09
	xor a			; $5a0c
	ld (de),a		; $5a0d
	jr _label_10_182		; $5a0e
_label_10_180:
	call objectGetAngleTowardEnemyTarget		; $5a10
	ld e,$c9		; $5a13
	ld (de),a		; $5a15
	ld h,d			; $5a16
	ld l,$c4		; $5a17
	inc (hl)		; $5a19
	ld l,$e4		; $5a1a
	set 7,(hl)		; $5a1c
_label_10_181:
	call objectApplySpeed		; $5a1e
	call $407e		; $5a21
	jr z,_label_10_184	; $5a24
_label_10_182:
	jp partAnimate		; $5a26
	ld a,$00		; $5a29
	call objectGetRelatedObject2Var		; $5a2b
	call checkObjectsCollided		; $5a2e
	jr nc,_label_10_181	; $5a31
	ld l,$ab		; $5a33
	ld (hl),$14		; $5a35
	ld l,$a9		; $5a37
	dec (hl)		; $5a39
	jr nz,_label_10_183	; $5a3a
	ld l,$b2		; $5a3c
	set 6,(hl)		; $5a3e
_label_10_183:
	ld a,$29		; $5a40
	call objectGetRelatedObject1Var		; $5a42
	dec (hl)		; $5a45
	ld a,$63		; $5a46
	call playSound		; $5a48
_label_10_184:
	jp partDelete		; $5a4b

seasonsFunc_10_5a4e:
	call objectCreatePuff		; $5a4e
	jp partDelete		; $5a51

partCode4c:
	jr z,_label_10_185	; $5a54
	ld e,$ea		; $5a56
	ld a,(de)		; $5a58
	cp $80			; $5a59
	jp nz,partDelete		; $5a5b
_label_10_185:
	ld e,$c2		; $5a5e
	ld a,(de)		; $5a60
	or a			; $5a61
	ld e,$c4		; $5a62
	ld a,(de)		; $5a64
	jr z,_label_10_187	; $5a65
	or a			; $5a67
	jr z,_label_10_186	; $5a68
	call partAnimate		; $5a6a
	call objectApplySpeed		; $5a6d
	call $4072		; $5a70
	ret nz			; $5a73
	jp partDelete		; $5a74
_label_10_186:
	ld h,d			; $5a77
	ld l,e			; $5a78
	inc (hl)		; $5a79
	ld l,$d0		; $5a7a
	ld (hl),$50		; $5a7c
	ld l,$db		; $5a7e
	ld a,$05		; $5a80
	ldi (hl),a		; $5a82
	ld (hl),a		; $5a83
	ld l,$e6		; $5a84
	ld a,$02		; $5a86
	ldi (hl),a		; $5a88
	ld (hl),a		; $5a89
	ld a,$bb		; $5a8a
	call playSound		; $5a8c
	ld a,$01		; $5a8f
	call partSetAnimation		; $5a91
	jp objectSetVisible82		; $5a94
_label_10_187:
	rst_jumpTable			; $5a97
	sbc (hl)		; $5a98
	ld e,d			; $5a99
	xor h			; $5a9a
	ld e,d			; $5a9b
	cp d			; $5a9c
	ld e,d			; $5a9d
	ld h,d			; $5a9e
	ld l,e			; $5a9f
	inc (hl)		; $5aa0
	ld l,$d0		; $5aa1
	ld (hl),$46		; $5aa3
	ld l,$c6		; $5aa5
	ld (hl),$1e		; $5aa7
	jp objectSetVisible82		; $5aa9
	call partCommon_decCounter1IfNonzero		; $5aac
	jp nz,partAnimate		; $5aaf
	ld l,e			; $5ab2
	inc (hl)		; $5ab3
	call objectGetAngleTowardEnemyTarget		; $5ab4
	ld e,$c9		; $5ab7
	ld (de),a		; $5ab9
	call partAnimate		; $5aba
	call objectApplySpeed		; $5abd
	call $4072		; $5ac0
	ret nc			; $5ac3
	call objectGetAngleTowardEnemyTarget		; $5ac4
	sub $02			; $5ac7
	and $1f			; $5ac9
	ld c,a			; $5acb
	ld b,$03		; $5acc
_label_10_188:
	call getFreePartSlot		; $5ace
	jr nz,_label_10_189	; $5ad1
	ld (hl),$4c		; $5ad3
	inc l			; $5ad5
	inc (hl)		; $5ad6
	ld l,$c9		; $5ad7
	ld (hl),c		; $5ad9
	call objectCopyPosition		; $5ada
_label_10_189:
	ld a,c			; $5add
	add $02			; $5ade
	and $1f			; $5ae0
	ld c,a			; $5ae2
	dec b			; $5ae3
	jr nz,_label_10_188	; $5ae4
	call objectCreatePuff		; $5ae6
	jp partDelete		; $5ae9

partCode4e:
	jr z,_label_10_190	; $5aec
	ld e,$ea		; $5aee
	ld a,(de)		; $5af0
	cp $83			; $5af1
	jr z,_label_10_193	; $5af3
	res 7,a			; $5af5
	sub $05			; $5af7
	cp $04			; $5af9
	jp c,$5b3e		; $5afb
_label_10_190:
	ld e,$c4		; $5afe
	ld a,(de)		; $5b00
	rst_jumpTable			; $5b01
	ld ($1b5b),sp		; $5b02
	ld e,e			; $5b05
	scf			; $5b06
	ld e,e			; $5b07
	ld h,d			; $5b08
	ld l,e			; $5b09
	inc (hl)		; $5b0a
	ld l,$c6		; $5b0b
	ld (hl),$1e		; $5b0d
	ld l,$d0		; $5b0f
	ld (hl),$5a		; $5b11
	ld a,$8d		; $5b13
	call playSound		; $5b15
	jp objectSetVisible82		; $5b18
	call partCommon_decCounter1IfNonzero		; $5b1b
	jr z,_label_10_192	; $5b1e
	ld l,$e1		; $5b20
	bit 0,(hl)		; $5b22
	jr z,_label_10_191	; $5b24
	ld (hl),$00		; $5b26
	ld l,$e4		; $5b28
	set 7,(hl)		; $5b2a
_label_10_191:
	jp partAnimate		; $5b2c
_label_10_192:
	ld l,e			; $5b2f
	inc (hl)		; $5b30
	call objectGetAngleTowardEnemyTarget		; $5b31
	ld e,$c9		; $5b34
	ld (de),a		; $5b36
	call objectApplySpeed		; $5b37
	call $4072		; $5b3a
	ret nc			; $5b3d
_label_10_193:
	ld b,$09		; $5b3e
	call objectCreateInteractionWithSubid00		; $5b40
	jp partDelete		; $5b43

partCode50:
	ld a,$04		; $5b46
	call objectGetRelatedObject1Var		; $5b48
	ld a,(hl)		; $5b4b
	cp $0e			; $5b4c
	jp z,partDelete		; $5b4e
	push hl			; $5b51
	ld e,$c4		; $5b52
	ld a,(de)		; $5b54
	rst_jumpTable			; $5b55
	ld e,h			; $5b56
	ld e,e			; $5b57
	ld l,(hl)		; $5b58
	ld e,e			; $5b59
	add h			; $5b5a
	ld e,e			; $5b5b
	ld a,$01		; $5b5c
	ld (de),a		; $5b5e
	pop hl			; $5b5f
	call objectTakePosition		; $5b60
	ld l,$b2		; $5b63
	ld a,(hl)		; $5b65
	or a			; $5b66
	jr z,_label_10_194	; $5b67
	ld a,$01		; $5b69
_label_10_194:
	jp partSetAnimation		; $5b6b
	call partAnimate		; $5b6e
	ld e,$e1		; $5b71
	ld a,(de)		; $5b73
	inc a			; $5b74
	jr nz,_label_10_195	; $5b75
	ld h,d			; $5b77
	ld l,$c4		; $5b78
	inc (hl)		; $5b7a
	ld l,$e6		; $5b7b
	ld a,$07		; $5b7d
	ldi (hl),a		; $5b7f
	ld (hl),a		; $5b80
	call objectSetInvisible		; $5b81
	pop hl			; $5b84
	inc l			; $5b85
	ld a,(hl)		; $5b86
	or a			; $5b87
	jp z,partDelete		; $5b88
	ld bc,$2000		; $5b8b
	jp objectTakePositionWithOffset		; $5b8e
_label_10_195:
	ld h,d			; $5b91
	ld l,e			; $5b92
	bit 7,(hl)		; $5b93
	jr z,_label_10_196	; $5b95
	res 7,(hl)		; $5b97
	call objectSetVisible82		; $5b99
	ld a,$b1		; $5b9c
	call playSound		; $5b9e
	ld h,d			; $5ba1
	ld l,$e1		; $5ba2
_label_10_196:
	ld a,(hl)		; $5ba4
	ld hl,$5bc1		; $5ba5
	rst_addAToHl			; $5ba8
	ld e,$e6		; $5ba9
	ldi a,(hl)		; $5bab
	ld (de),a		; $5bac
	inc e			; $5bad
	ldi a,(hl)		; $5bae
	ld (de),a		; $5baf
	ldi a,(hl)		; $5bb0
	ld b,a			; $5bb1
	ld c,(hl)		; $5bb2
	pop hl			; $5bb3
	ld l,$b2		; $5bb4
	ld a,(hl)		; $5bb6
	or a			; $5bb7
	jr z,_label_10_197	; $5bb8
	ld a,c			; $5bba
	cpl			; $5bbb
	inc a			; $5bbc
	ld c,a			; $5bbd
_label_10_197:
	jp objectTakePositionWithOffset		; $5bbe
	rlca			; $5bc1
	rlca			; $5bc2
	ret c			; $5bc3
	pop af			; $5bc4
	dec bc			; $5bc5
	rlca			; $5bc6
	rst $20			; $5bc7
	ld a,(de)		; $5bc8
	jr nz,$0c		; $5bc9
	rst $30			; $5bcb
	add hl,de		; $5bcc

partCode51:
	ld a,$04		; $5bcd
	call objectGetRelatedObject1Var		; $5bcf
	ld a,(hl)		; $5bd2
	cp $0e			; $5bd3
	jp z,partDelete		; $5bd5
	ld e,$c2		; $5bd8
	ld a,(de)		; $5bda
	ld e,$c4		; $5bdb
	rst_jumpTable			; $5bdd
.DB $e4				; $5bde
	ld e,e			; $5bdf
	ld c,b			; $5be0
	ld e,h			; $5be1
	inc b			; $5be2
	ld e,h			; $5be3
	ld a,(de)		; $5be4
	or a			; $5be5
	jr nz,_label_10_198	; $5be6
	ld h,d			; $5be8
	ld l,e			; $5be9
	inc (hl)		; $5bea
	ld l,$c6		; $5beb
	ld (hl),$40		; $5bed
	ld l,$e8		; $5bef
	ld (hl),$f0		; $5bf1
	ld l,$da		; $5bf3
	ld (hl),$02		; $5bf5
	ld a,$5c		; $5bf7
	call playSound		; $5bf9
_label_10_198:
	call partCommon_decCounter1IfNonzero		; $5bfc
	jp z,partDelete		; $5bff
	jr _label_10_199		; $5c02
	ld a,(de)		; $5c04
	or a			; $5c05
	jr z,_label_10_200	; $5c06
	ld e,$e1		; $5c08
	ld a,(de)		; $5c0a
	rlca			; $5c0b
	jp c,partDelete		; $5c0c
_label_10_199:
	ld e,$da		; $5c0f
	ld a,(de)		; $5c11
	xor $80			; $5c12
	ld (de),a		; $5c14
	jp partAnimate		; $5c15
_label_10_200:
	ld h,d			; $5c18
	ld l,e			; $5c19
	inc (hl)		; $5c1a
	ld l,$e4		; $5c1b
	set 7,(hl)		; $5c1d
	ld l,$c9		; $5c1f
	ld a,(hl)		; $5c21
	ld b,$01		; $5c22
	cp $0c			; $5c24
	jr c,_label_10_201	; $5c26
	inc b			; $5c28
	cp $19			; $5c29
	jr c,_label_10_201	; $5c2b
	inc b			; $5c2d
_label_10_201:
	ld a,b			; $5c2e
	dec a			; $5c2f
	and $01			; $5c30
	ld hl,$5c44		; $5c32
	rst_addDoubleIndex			; $5c35
	ld e,$e6		; $5c36
	ldi a,(hl)		; $5c38
	ld (de),a		; $5c39
	inc e			; $5c3a
	ld a,(hl)		; $5c3b
	ld (de),a		; $5c3c
	ld a,b			; $5c3d
	call partSetAnimation		; $5c3e
	jp objectSetVisible83		; $5c41
	ld ($0a0a),sp		; $5c44
	ld a,(bc)		; $5c47
	ld a,(de)		; $5c48
	rst_jumpTable			; $5c49
	ld d,b			; $5c4a
	ld e,h			; $5c4b
	ld h,l			; $5c4c
	ld e,h			; $5c4d
	sub b			; $5c4e
	ld e,h			; $5c4f
	ld h,d			; $5c50
	ld l,e			; $5c51
	inc (hl)		; $5c52
	ld l,$dd		; $5c53
	ld a,(hl)		; $5c55
	add $0e			; $5c56
	ld (hl),a		; $5c58
	ld l,$c6		; $5c59
	ld (hl),$18		; $5c5b
	ld a,$04		; $5c5d
	call partSetAnimation		; $5c5f
	jp objectSetVisible82		; $5c62
	call partCommon_decCounter1IfNonzero		; $5c65
	jr nz,_label_10_204	; $5c68
	dec (hl)		; $5c6a
	ld l,e			; $5c6b
	inc (hl)		; $5c6c
	ld l,$e4		; $5c6d
	set 7,(hl)		; $5c6f
	ld l,$db		; $5c71
	ld a,$05		; $5c73
	ldi (hl),a		; $5c75
	ld (hl),a		; $5c76
	ld l,$cb		; $5c77
	ld a,(hl)		; $5c79
	add $08			; $5c7a
	ldi (hl),a		; $5c7c
	inc l			; $5c7d
	ld a,(hl)		; $5c7e
	sub $10			; $5c7f
	ld (hl),a		; $5c81
	call objectGetAngleTowardLink		; $5c82
	ld e,$c9		; $5c85
	ld (de),a		; $5c87
	ld c,a			; $5c88
	ld b,$50		; $5c89
	ld a,$02		; $5c8b
	jp objectSetComponentSpeedByScaledVelocity		; $5c8d
	call $4072		; $5c90
	jr nc,_label_10_202	; $5c93
	ld b,$56		; $5c95
	call objectCreateInteractionWithSubid00		; $5c97
	ld a,$3c		; $5c9a
	call z,setScreenShakeCounter		; $5c9c
	jp partDelete		; $5c9f
_label_10_202:
	call partCommon_decCounter1IfNonzero		; $5ca2
	ld a,(hl)		; $5ca5
	and $07			; $5ca6
	jr nz,_label_10_203	; $5ca8
	call getFreePartSlot		; $5caa
	jr nz,_label_10_203	; $5cad
	ld (hl),$51		; $5caf
	inc l			; $5cb1
	ld (hl),$02		; $5cb2
	ld l,$c9		; $5cb4
	ld e,l			; $5cb6
	ld a,(de)		; $5cb7
	ld (hl),a		; $5cb8
	call objectCopyPosition		; $5cb9
_label_10_203:
	call objectApplyComponentSpeed		; $5cbc
_label_10_204:
	jp partAnimate		; $5cbf

partCode52:
	ld a,$04		; $5cc2
	call objectGetRelatedObject1Var		; $5cc4
	ld a,(hl)		; $5cc7
	cp $0e			; $5cc8
	jp z,partDelete		; $5cca
	ld e,$c2		; $5ccd
	ld a,(de)		; $5ccf
	ld e,$c4		; $5cd0
	rst_jumpTable			; $5cd2
	reti			; $5cd3
	ld e,h			; $5cd4
	ld ($ac5d),sp		; $5cd5
	ld e,l			; $5cd8
	ld a,(de)		; $5cd9
	rst_jumpTable			; $5cda
	pop hl			; $5cdb
	ld e,h			; $5cdc
.DB $eb				; $5cdd
	ld e,h			; $5cde
.DB $fc				; $5cdf
	ld e,h			; $5ce0
	ld h,d			; $5ce1
	ld l,e			; $5ce2
	inc (hl)		; $5ce3
	ld l,$c6		; $5ce4
	ld (hl),$0a		; $5ce6
	jp objectSetVisible82		; $5ce8
	call partCommon_decCounter1IfNonzero		; $5ceb
	jr nz,_label_10_205	; $5cee
	ld l,e			; $5cf0
	inc (hl)		; $5cf1
	ld a,$a4		; $5cf2
	call playSound		; $5cf4
	ld a,$02		; $5cf7
	call partSetAnimation		; $5cf9
	call $407e		; $5cfc
	jp z,partDelete		; $5cff
	call objectApplySpeed		; $5d02
_label_10_205:
	jp partAnimate		; $5d05
	ld a,(de)		; $5d08
	rst_jumpTable			; $5d09
	ld (de),a		; $5d0a
	ld e,l			; $5d0b
	ld b,(hl)		; $5d0c
	ld e,l			; $5d0d
	ld (hl),a		; $5d0e
	ld e,l			; $5d0f
.DB $fc				; $5d10
	ld e,h			; $5d11
	ld h,d			; $5d12
	ld l,$d0		; $5d13
	ld (hl),$50		; $5d15
	ld l,e			; $5d17
	call objectSetVisible82		; $5d18
	ld e,$c3		; $5d1b
	ld a,(de)		; $5d1d
	or a			; $5d1e
	jr z,_label_10_206	; $5d1f
	ld (hl),$03		; $5d21
	ld l,$e6		; $5d23
	ld a,$02		; $5d25
	ldi (hl),a		; $5d27
	ld (hl),a		; $5d28
	ret			; $5d29
_label_10_206:
	inc (hl)		; $5d2a
	ld l,$c6		; $5d2b
	ld (hl),$28		; $5d2d
	ld l,$e6		; $5d2f
	ld a,$04		; $5d31
	ldi (hl),a		; $5d33
	ld (hl),a		; $5d34
	ld e,$cb		; $5d35
	ld l,$f0		; $5d37
	ld a,(de)		; $5d39
	add $20			; $5d3a
	ldi (hl),a		; $5d3c
	ld e,$cd		; $5d3d
	ld a,(de)		; $5d3f
	ld (hl),a		; $5d40
	ld a,$01		; $5d41
	call partSetAnimation		; $5d43
	call partCommon_decCounter1IfNonzero		; $5d46
	jr z,_label_10_208	; $5d49
	ld a,(hl)		; $5d4b
	rrca			; $5d4c
	ld e,$c9		; $5d4d
	jr c,_label_10_207	; $5d4f
	ld a,(de)		; $5d51
	inc a			; $5d52
	and $1f			; $5d53
	ld (de),a		; $5d55
_label_10_207:
	ld l,$da		; $5d56
	ld a,(hl)		; $5d58
	xor $80			; $5d59
	ld (hl),a		; $5d5b
	ld l,$f0		; $5d5c
	ld b,(hl)		; $5d5e
	inc l			; $5d5f
	ld c,(hl)		; $5d60
	ld a,$08		; $5d61
	call objectSetPositionInCircleArc		; $5d63
	jr _label_10_209		; $5d66
_label_10_208:
	ld (hl),$0a		; $5d68
	ld l,e			; $5d6a
	inc (hl)		; $5d6b
	ld a,$be		; $5d6c
	call playSound		; $5d6e
	call objectSetVisible82		; $5d71
_label_10_209:
	jp partAnimate		; $5d74
	call partCommon_decCounter1IfNonzero		; $5d77
	jr z,_label_10_210	; $5d7a
	call objectApplySpeed		; $5d7c
	jr _label_10_209		; $5d7f
_label_10_210:
	ld l,e			; $5d81
	inc (hl)		; $5d82
	ld l,$e6		; $5d83
	ld a,$02		; $5d85
	ldi (hl),a		; $5d87
	ld (hl),a		; $5d88
	xor a			; $5d89
	call partSetAnimation		; $5d8a
	call objectCreatePuff		; $5d8d
	ld b,$fd		; $5d90
	call $5d97		; $5d92
	ld b,$03		; $5d95
	call getFreePartSlot		; $5d97
	ret nz			; $5d9a
	ld (hl),$52		; $5d9b
	inc l			; $5d9d
	inc (hl)		; $5d9e
	inc l			; $5d9f
	inc (hl)		; $5da0
	ld l,$c9		; $5da1
	ld e,l			; $5da3
	ld a,(de)		; $5da4
	add b			; $5da5
	and $1f			; $5da6
	ld (hl),a		; $5da8
	jp objectCopyPosition		; $5da9
	ld a,(de)		; $5dac
	rst_jumpTable			; $5dad
	or (hl)			; $5dae
	ld e,l			; $5daf
	ret nz			; $5db0
	ld e,l			; $5db1
	call nc,$fc5d		; $5db2
	ld e,h			; $5db5
	ld h,d			; $5db6
	ld l,e			; $5db7
	inc (hl)		; $5db8
	ld l,$c6		; $5db9
	ld (hl),$0f		; $5dbb
	jp objectSetVisible82		; $5dbd
	call partCommon_decCounter1IfNonzero		; $5dc0
	jp nz,partAnimate		; $5dc3
	ld (hl),$0f		; $5dc6
	ld l,e			; $5dc8
	inc (hl)		; $5dc9
	ld a,$a8		; $5dca
	call playSound		; $5dcc
	ld a,$01		; $5dcf
	jp partSetAnimation		; $5dd1
	call partCommon_decCounter1IfNonzero		; $5dd4
	jp nz,partAnimate		; $5dd7
	ld l,e			; $5dda
	inc (hl)		; $5ddb
	ld l,$d0		; $5ddc
	ld (hl),$5a		; $5dde
	call objectGetAngleTowardLink		; $5de0
	ld e,$c9		; $5de3
	ld (de),a		; $5de5
	ld a,$02		; $5de6
	jp partSetAnimation		; $5de8


; ==============================================================================
; PARTID_BLUE_ENERGY_BEAD
; Used by "createEnergySwirl" functions
; ==============================================================================
; @addr{5d85}
partCode53:
	ld e,$c4		; $5d85
	ld a,(de)		; $5d87
	or a			; $5d88
	jr z,_label_11_206	; $5d89
	ld a,(wDeleteEnergyBeads)		; $5d8b
	or a			; $5d8e
	jp nz,partDelete		; $5d8f
	ld h,d			; $5d92
	ld l,$c6		; $5d93
	ld a,(hl)		; $5d95
	inc a			; $5d96
	jr z,_label_11_204	; $5d97
	dec (hl)		; $5d99
	jp z,partDelete		; $5d9a
_label_11_204:
	inc e			; $5d9d
	ld a,(de)		; $5d9e
	or a			; $5d9f
	jr nz,_label_11_205	; $5da0
	inc l			; $5da2
	dec (hl)		; $5da3
	ret nz			; $5da4
	ld l,e			; $5da5
	inc (hl)		; $5da6
	ld l,$f2		; $5da7
	ld a,(hl)		; $5da9
	swap a			; $5daa
	rrca			; $5dac
	ld l,$c3		; $5dad
	add (hl)		; $5daf
	call partSetAnimation		; $5db0
	call _func_5e1a		; $5db3
	jp objectSetVisible		; $5db6
_label_11_205:
	call objectApplySpeed		; $5db9
	call partAnimate		; $5dbc
	ld e,$e1		; $5dbf
	ld a,(de)		; $5dc1
	inc a			; $5dc2
	ret nz			; $5dc3
	ld h,d			; $5dc4
	ld l,$c5		; $5dc5
	dec (hl)		; $5dc7
	call objectSetInvisible		; $5dc8
	jr _label_11_207		; $5dcb
_label_11_206:
	ld h,d			; $5dcd
	ld l,e			; $5dce
	inc (hl)		; $5dcf
	ld l,$c0		; $5dd0
	set 7,(hl)		; $5dd2
	ld l,$d0		; $5dd4
	ld (hl),$78		; $5dd6
	ld l,$c3		; $5dd8
	ld a,(hl)		; $5dda
	add a			; $5ddb
	add a			; $5ddc
	xor $10			; $5ddd
	ld l,$c9		; $5ddf
	ld (hl),a		; $5de1
	xor a			; $5de2
	ld (wDeleteEnergyBeads),a		; $5de3
_label_11_207:
	call getRandomNumber_noPreserveVars		; $5de6
	and $07			; $5de9
	inc a			; $5deb
	ld e,$c7		; $5dec
	ld (de),a		; $5dee
	ret			; $5def

;;
; @addr{5df0}
createEnergySwirlGoingOut_body:
	ld a,$01		; $5df0
	jr ++			; $5df2

;;
; @param	bc	Center of the swirl
; @param	l	Duration of swirl ($ff and $00 are infinite)?
; @addr{5df4}
createEnergySwirlGoingIn_body:
	xor a			; $5df4
++
	ldh (<hFF8B),a	; $5df5
	push de			; $5df7
	ld e,l			; $5df8
	ld d,$08		; $5df9
--
	call getFreePartSlot		; $5dfb
	jr nz,@end		; $5dfe

	; Part.id
	ld (hl),PARTID_BLUE_ENERGY_BEAD		; $5e00

	; Set duration
	ld l,Part.counter1		; $5e02
	ld (hl),e		; $5e04

	; Set center of swirl
	ld l,Part.var30		; $5e05
	ld (hl),b		; $5e07
	inc l			; $5e08
	ld (hl),c		; $5e09
	inc l			; $5e0a

	; [Part.var32] = whether it's going in or out
	ldh a,(<hFF8B)	; $5e0b
	ld (hl),a		; $5e0d

	; Give each Part a unique index
	ld l,Part.var03		; $5e0e
	dec d			; $5e10
	ld (hl),d		; $5e11
	jr nz,--		; $5e12

@end:
	pop de			; $5e14
	ld a,SND_ENERGYTHING		; $5e15
	jp playSound		; $5e17

_func_5e1a:
	ld h,d			; $5e1a
	ld l,Part.var32		; $5e1b
	ldd a,(hl)		; $5e1d
	or a			; $5e1e
	jr nz,+			; $5e1f
	ld e,Part.var03		; $5e21
	ld a,(de)		; $5e23
	add a			; $5e24
	add a			; $5e25
	ld e,Part.direction		; $5e26
	ld (de),a		; $5e28
	ld c,(hl)		; $5e29
	dec l			; $5e2a
	ld b,(hl)		; $5e2b
	ld a,$38		; $5e2c
	jp objectSetPositionInCircleArc		; $5e2e
+
	ld e,Part.xh		; $5e31
	ldd a,(hl)		; $5e33
	ld (de),a		; $5e34
	ld e,Part.yh		; $5e35
	ld a,(hl)		; $5e37
	ld (de),a		; $5e38
	ret			; $5e39

.ifdef ROM_SEASONS
.ends

.include "code/roomInitialization.s"

 m_section_force "Part_Code_2" NAMESPACE "partCode"
.endif


_label_11_212:
	ld d,$d0		; $5e3a
	ld a,d			; $5e3c
-
	ldh (<hActiveObject),a	; $5e3d
	ld e,$c0		; $5e3f
	ld a,(de)		; $5e41
	or a			; $5e42
	jr z,++			; $5e43
	rlca			; $5e45
	jr c,+			; $5e46
	ld e,$c4		; $5e48
	ld a,(de)		; $5e4a
	or a			; $5e4b
	jr nz,++		; $5e4c
+
	call _func_11_5e8a		; $5e4e
++
	inc d			; $5e51
	ld a,d			; $5e52
	cp $e0			; $5e53
	jr c,-			; $5e55
	ret			; $5e57

;;
; @addr{5e58}
updateParts:
	ld a,$c0		; $5e58
	ldh (<hActiveObjectType),a	; $5e5a
	ld a,(wScrollMode)		; $5e5c
	cp $08			; $5e5f
	jr z,_label_11_212	; $5e61
	ld a,(wTextIsActive)		; $5e63
	or a			; $5e66
	jr nz,_label_11_212	; $5e67

	ld a,(wDisabledObjects)		; $5e69
	and $88			; $5e6c
	jr nz,_label_11_212	; $5e6e

	ld d,FIRST_PART_INDEX	; $5e70
	ld a,d			; $5e72
-
	ldh (<hActiveObject),a	; $5e73
	ld e,Part.enabled	; $5e75
	ld a,(de)		; $5e77
	or a			; $5e78
	jr z,+			; $5e79

	call _func_11_5e8a		; $5e7b
	ld h,d			; $5e7e
	ld l,Part.var2a		; $5e7f
	res 7,(hl)		; $5e81
+
	inc d			; $5e83
	ld a,d			; $5e84
	cp LAST_PART_INDEX+1			; $5e85
	jr c,-			; $5e87
	ret			; $5e89

;;
; @addr{5e8a}
_func_11_5e8a:
	call partCommon_standardUpdate		; $5e8a

	; hl = partCodeTable + [Part.id] * 2
	ld e,Part.id		; $5e8d
	ld a,(de)		; $5e8f
	add a			; $5e90
	add <partCodeTable	; $5e91
	ld l,a			; $5e93
	ld a,$00		; $5e94
	adc >partCodeTable	; $5e96
	ld h,a			; $5e98

	ldi a,(hl)		; $5e99
	ld h,(hl)		; $5e9a
	ld l,a			; $5e9b

	ld a,c			; $5e9c
	or a			; $5e9d
	jp hl			; $5e9e


partCodeTable:
	.dw partCode00
	.dw partCode01
	.dw partCode02
	.dw partCode03
	.dw partCode04
	.dw partCode05
	.dw partCode06
	.dw partCode07
	.dw partCode08
	.dw partCode09
	.dw partCode0a
	.dw partCode0b
	.dw partCode0c
	.dw partCode0d
	.dw partCode0e
	.dw partCode0f
	.dw partCode10
	.dw partCode11
	.dw partCode12
	.dw partCode13
	.dw partCode14
	.dw partCode15
	.dw partCode16
	.dw partCode17
	.dw partCode18
	.dw partCode19
	.dw partCode1a
	.dw partCode1b
	.dw partCode1c
	.dw partCode1d
	.dw partCode1e
	.dw partCode1f
	.dw partCode20
	.dw partCode21
	.dw partCode22
	.dw partCode23
	.dw partCode24
	.dw partCode25
	.dw partCode26
	.dw partCode27
	.dw partCode28
	.dw partCode29
	.dw partCode2a
	.dw partCode2b
	.dw partCode2c
	.dw partCode2d
	.dw partCode2e
	.dw partCode2f
	.dw partCode30
	.dw partCode31
	.dw partCode32
	.dw partCode33
	.dw partCodeNil
	.dw partCodeNil
	.dw partCodeNil
	.dw partCodeNil
	.dw partCode38
	.dw partCode39
	.dw partCode3a
	.dw partCode3b
	.dw partCode3c
	.dw partCode3d
	.dw partCode3e
	.dw partCode3f
	.dw partCode40
	.dw partCode41
	.dw partCode42
	.dw partCode43
	.dw partCode44
	.dw partCode45
	.dw partCode46
	.dw partCode47
	.dw partCode48
	.dw partCode49
	.dw partCode4a
	.dw partCode4b
	.dw partCode4c
	.dw partCode4d
	.dw partCode4e
	.dw partCode4f
	.dw partCode50
	.dw partCode51
	.dw partCode52
	.dw partCode53

partCodeNil:
	ret			; $62cb

partCode00:
	jp partDelete		; $62cc

.include "objects/seasons/partCode.s"