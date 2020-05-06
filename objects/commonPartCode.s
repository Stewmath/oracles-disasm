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


; ==============================================================================
; PARTID_OWL_STATUE
; ==============================================================================
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


; ==============================================================================
; PARTID_OCTOROK_PROJECTILE
; ==============================================================================
; @addr{5026}
partCode18:
	jr z,@normalStatus	; $5026
	ld e,$ea		; $5028
	ld a,(de)		; $502a
	cp $80			; $502b
	jp z,partDelete		; $502d
	ld h,d			; $5030
	ld l,$c4		; $5031
	ld a,(hl)		; $5033
	cp $02			; $5034
	jr nc,@normalStatus	; $5036
	ld (hl),$02		; $5038

@normalStatus:
	ld e,$c4		; $503a
	ld a,(de)		; $503c
	rst_jumpTable			; $503d
	.dw @state0
	.dw @state1
	.dw @state2
	.dw _partCommon_updateSpeedAndDeleteWhenCounter1Is0

@state0:
	ld h,d			; $5046
	ld l,e			; $5047
	inc (hl)		; $5048
	ld l,$d0		; $5049
	ld (hl),$50		; $504b
	jp objectSetVisible81		; $504d

@state1:
	call objectCheckWithinScreenBoundary		; $5050
	jp nc,partDelete		; $5053
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5056
	jr nc,+			; $5059
	jp z,partDelete		; $505b
	ld e,$c4		; $505e
	ld a,$02		; $5060
	ld (de),a		; $5062
+
	jp objectApplySpeed		; $5063

@state2:
	ld a,$03		; $5066
	ld (de),a		; $5068
	xor a			; $5069
	jp _partCommon_bounceWhenCollisionsEnabled		; $506a


; ==============================================================================
; PARTID_ZORA_FIRE
; PARTID_GOPONGA_PROJECTILE
; ==============================================================================
; @addr{506d}
partCode19:
partCode31:
	jp nz,partDelete		; $506d
	ld e,$c4		; $5070
	ld a,(de)		; $5072
	rst_jumpTable			; $5073
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $507a
	ld l,e			; $507b
	inc (hl)		; $507c
	ld l,$c6		; $507d
	ld (hl),$08		; $507f
	ld l,$d0		; $5081
	ld (hl),$3c		; $5083
	jp objectSetVisible81		; $5085

@state1:
	call partCommon_decCounter1IfNonzero		; $5088
	ret nz			; $508b
	ld l,e			; $508c
	inc (hl)		; $508d
	ld l,$c2		; $508e
	bit 0,(hl)		; $5090
	jr z,+			; $5092
	ldh a,(<hFFB2)	; $5094
	ld b,a			; $5096
	ldh a,(<hFFB3)	; $5097
	ld c,a			; $5099
	call objectGetRelativeAngle		; $509a
	ld e,$c9		; $509d
	ld (de),a		; $509f
	ret			; $50a0
+
	call objectGetAngleTowardEnemyTarget		; $50a1
	ld e,$c9		; $50a4
	ld (de),a		; $50a6
	ret			; $50a7

@state2:
	ld a,(wFrameCounter)		; $50a8
	and $03			; $50ab
	jr nz,+			; $50ad
	ld e,$dc		; $50af
	ld a,(de)		; $50b1
	xor $07			; $50b2
	ld (de),a		; $50b4
+
	call objectApplySpeed		; $50b5
	call objectCheckWithinScreenBoundary		; $50b8
	jp nc,partDelete		; $50bb
	jp partAnimate		; $50be


; ==============================================================================
; PARTID_ENEMY_ARROW
; ==============================================================================
; @addr{50c1}
partCode1a:
	jr z,@normalStatus	; $50c1
	ld e,$ea		; $50c3
	ld a,(de)		; $50c5
	cp $80			; $50c6
	jr z,@partDelete	; $50c8
	jr @func_11_513a		; $50ca
@normalStatus:
	ld e,$c2		; $50cc
	ld a,(de)		; $50ce
	rst_jumpTable			; $50cf
	.dw @subid0
	.dw @subid1

@subid0:
	ld e,$c4		; $50d4
	ld a,(de)		; $50d6
	rst_jumpTable			; $50d7
	.dw @@state0
	.dw @@state1
	.dw _partCommon_updateSpeedAndDeleteWhenCounter1Is0

@@state0:
	ld h,d			; $50de
	ld l,e			; $50df
	inc (hl)		; $50e0
	ld l,$d0		; $50e1
	ld (hl),$50		; $50e3
	ld l,$cb		; $50e5
	ld b,(hl)		; $50e7
	ld l,$cd		; $50e8
	ld c,(hl)		; $50ea
	call _partCommon_setPositionOffsetAndRadiusFromAngle		; $50eb
	ld e,$c9		; $50ee
	ld a,(de)		; $50f0
	swap a			; $50f1
	rlca			; $50f3
	call partSetAnimation		; $50f4
	jp objectSetVisible81		; $50f7

@@state1:
	call _partCommon_checkTileCollisionOrOutOfBounds		; $50fa
	jr nc,@objectApplySpeed	; $50fd
	jr z,@partDelete	; $50ff
	jr @func_11_513a		; $5101

@subid1:
	ld e,$c4		; $5103
	ld a,(de)		; $5105
	rst_jumpTable			; $5106
	.dw @@state0
	.dw @@state1
	.dw @subid0@state1
	.dw _partCommon_updateSpeedAndDeleteWhenCounter1Is0

@@state0:
	ld h,d			; $510f
	ld l,e			; $5110
	inc (hl)		; $5111
	ld l,$c6		; $5112
	ld (hl),$08		; $5114
	ld l,$d0		; $5116
	ld (hl),$50		; $5118
	ld e,$c9		; $511a
	ld a,(de)		; $511c
	swap a			; $511d
	rlca			; $511f
	call partSetAnimation		; $5120
	jp objectSetVisible81		; $5123

@@state1:
	call partCommon_decCounter1IfNonzero		; $5126
	jr nz,+			; $5129
	ld l,e			; $512b
	inc (hl)		; $512c
	jr @subid0@state1		; $512d
+
	call partCommon_checkOutOfBounds		; $512f
	jr z,@partDelete	; $5132
@objectApplySpeed:
	jp objectApplySpeed		; $5134
@partDelete:
	jp partDelete		; $5137
@func_11_513a:
	ld e,$c2		; $513a
	ld a,(de)		; $513c
	or a			; $513d
	ld a,$02		; $513e
	jr z,+			; $5140
	ld a,$03		; $5142
+
	ld e,$c4		; $5144
	ld (de),a		; $5146
	ld a,$04		; $5147
	jp _partCommon_bounceWhenCollisionsEnabled		; $5149


; ==============================================================================
; PARTID_LYNEL_BEAM
; ==============================================================================
; @addr{514c}
partCode1b:
	jr z,@normalStatus	; $514c
	ld e,$ea		; $514e
	ld a,(de)		; $5150
	res 7,a			; $5151
	cp $04			; $5153
	jp c,partDelete		; $5155
@normalStatus:
	ld e,$c4		; $5158
	ld a,(de)		; $515a
	or a			; $515b
	jr z,+			; $515c
	call objectCheckWithinScreenBoundary		; $515e
	jp nc,partDelete		; $5161
	call objectApplySpeed		; $5164
	ld a,(wFrameCounter)		; $5167
	and $03			; $516a
	ret nz			; $516c
	ld e,$dc		; $516d
	ld a,(de)		; $516f
	xor $07			; $5170
	ld (de),a		; $5172
	ret			; $5173
+
	ld h,d			; $5174
	ld l,e			; $5175
	inc (hl)		; $5176
	ld l,$d0		; $5177
	ld (hl),$78		; $5179
	ld l,$cb		; $517b
	ld b,(hl)		; $517d
	ld l,$cd		; $517e
	ld c,(hl)		; $5180
	call _partCommon_setPositionOffsetAndRadiusFromAngle		; $5181
	ld e,$c9		; $5184
	ld a,(de)		; $5186
	swap a			; $5187
	rlca			; $5189
	call partSetAnimation		; $518a
	jp objectSetVisible81		; $518d


; ==============================================================================
; PARTID_STALFOS_BONE
; ==============================================================================
; @addr{5190}
partCode1c:
	jr z,@normalStatus	; $5190
	ld e,$ea		; $5192
	ld a,(de)		; $5194
	cp $80			; $5195
	jr z,@partDelete	; $5197
	jr @func_11_51dd		; $5199

@normalStatus:
	ld e,$c4		; $519b
	ld a,(de)		; $519d
	rst_jumpTable			; $519e
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $51a5
	ld l,e			; $51a6
	inc (hl)		; $51a7
	ld l,$d0		; $51a8
	ld (hl),$3c		; $51aa
	call objectGetAngleTowardEnemyTarget		; $51ac
	ld e,$c9		; $51af
	ld (de),a		; $51b1
	jp objectSetVisible81		; $51b2

@state1:
	call _partCommon_checkTileCollisionOrOutOfBounds		; $51b5
	jr c,+			; $51b8
	call objectApplySpeed		; $51ba
	call objectCheckWithinScreenBoundary		; $51bd
	jp c,partAnimate		; $51c0

@partDelete:
	jp partDelete		; $51c3

@state2:
	call partCommon_decCounter1IfNonzero		; $51c6
	jr z,@partDelete	; $51c9
	ld c,$0e		; $51cb
	call objectUpdateSpeedZ_paramC		; $51cd
	call objectApplySpeed		; $51d0
	ld a,(wFrameCounter)		; $51d3
	rrca			; $51d6
	ret c			; $51d7
	jp partAnimate		; $51d8
+
	jr z,@partDelete	; $51db
@func_11_51dd:
	ld e,$c4		; $51dd
	ld a,$02		; $51df
	ld (de),a		; $51e1
	xor a			; $51e2
	jp _partCommon_bounceWhenCollisionsEnabled		; $51e3


; ==============================================================================
; PARTID_ENEMY_SWORD
; ==============================================================================
; @addr{51e6}
partCode1d:
	jr z,@normalStatus	; $51e6
	ld e,$ea		; $51e8
	ld a,(de)		; $51ea
	cp $80			; $51eb
	jr z,@normalStatus	; $51ed
	cp $8a			; $51ef
	jr z,@normalStatus	; $51f1
	ld a,$2b		; $51f3
	call objectGetRelatedObject1Var		; $51f5
	ld a,(hl)		; $51f8
	or a			; $51f9
	jr nz,+			; $51fa
	ld e,$eb		; $51fc
	ld a,(de)		; $51fe
	ld (hl),a		; $51ff
+
	ld e,$ec		; $5200
	ld a,(de)		; $5202
	inc l			; $5203
	ldi (hl),a		; $5204
	ld e,$ed		; $5205
	ld a,(de)		; $5207
	ld (hl),a		; $5208
@normalStatus:
	ld e,$c4		; $5209
	ld a,(de)		; $520b
	or a			; $520c
	jr z,@func_5261	; $520d
	ld h,d			; $520f
	ld l,$e4		; $5210
	set 7,(hl)		; $5212
	call @func_5273		; $5214
	jp nz,partDelete		; $5217

@func_521a:
	ld l,$8b		; $521a
	ld b,(hl)		; $521c
	ld l,$8d		; $521d
	ld c,(hl)		; $521f
	ld l,$89		; $5220
	ld a,(hl)		; $5222
	add $04			; $5223
	and $18			; $5225
	rrca			; $5227
	ldh (<hFF8B),a	; $5228
	ld l,$a1		; $522a
	add (hl)		; $522c
	add (hl)		; $522d
	ld hl,@table_524d		; $522e
	rst_addAToHl			; $5231
	ld e,$cb		; $5232
	ldi a,(hl)		; $5234
	add b			; $5235
	ld (de),a		; $5236
	ld e,$cd		; $5237
	ld a,(hl)		; $5239
	add c			; $523a
	ld (de),a		; $523b
	ldh a,(<hFF8B)	; $523c
	rrca			; $523e
	and $02			; $523f
	ld hl,@table_525d		; $5241
	rst_addAToHl			; $5244
	ld e,$e6		; $5245
	ldi a,(hl)		; $5247
	ld (de),a		; $5248
	inc e			; $5249
	ld a,(hl)		; $524a
	ld (de),a		; $524b
	ret			; $524c

@table_524d:
	.db $f8 $04
	.db $f6 $04
	.db $04 $07
	.db $04 $09
	.db $07 $fc
	.db $09 $fc
	.db $04 $f9
	.db $04 $f7

@table_525d:
	.db $05 $02
	.db $02 $05

@func_5261:
	ld h,d			; $5261
	ld l,e			; $5262
	inc (hl)		; $5263
	ld l,$fe		; $5264
	ld (hl),$04		; $5266
	ld a,$01		; $5268
	call objectGetRelatedObject1Var		; $526a
	ld e,$f0		; $526d
	ld a,(hl)		; $526f
	ld (de),a		; $5270
	jr @func_521a		; $5271

@func_5273:
	ld a,$01		; $5273
	call objectGetRelatedObject1Var		; $5275
	ld e,$f0		; $5278
	ld a,(de)		; $527a
	cp (hl)			; $527b
	ret nz			; $527c
	ld l,$b0		; $527d
	bit 0,(hl)		; $527f
	jr nz,+			; $5281
	ld l,$a9		; $5283
	ld a,(hl)		; $5285
	or a			; $5286
	jr z,+			; $5287
	ld l,$ae		; $5289
	ld a,(hl)		; $528b
	or a			; $528c
	jr nz,+			; $528d
	ld l,$bf		; $528f
	bit 1,(hl)		; $5291
	ret z			; $5293
+
	ld e,$e4		; $5294
	ld a,(de)		; $5296
	res 7,a			; $5297
	ld (de),a		; $5299
	xor a			; $529a
	ret			; $529b


; ==============================================================================
; PARTID_DEKU_SCRUB_PROJECTILE
; ==============================================================================
; @addr{529c}
partCode1e:
	jr z,@normalStatus	; $529c
	ld e,$ea		; $529e
	ld a,(de)		; $52a0
	cp $80			; $52a1
	jr z,@normalStatus	; $52a3
	call _func_52fd		; $52a5
	ld h,d			; $52a8
	ld l,$c4		; $52a9
	ld (hl),$03		; $52ab
	ld l,$e4		; $52ad
	res 7,(hl)		; $52af
@normalStatus:
	ld e,$c4		; $52b1
	ld a,(de)		; $52b3
	rst_jumpTable			; $52b4
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw _partCommon_updateSpeedAndDeleteWhenCounter1Is0
	.dw @state5

@state0:
	ld h,d			; $52c1
	ld l,e			; $52c2
	inc (hl)		; $52c3
	ld l,$d0		; $52c4
	ld (hl),$50		; $52c6
	ld l,$c6		; $52c8
	ld (hl),$08		; $52ca
	ld a,SND_STRIKE		; $52cc
	call playSound		; $52ce
	jp objectSetVisible81		; $52d1

@state1:
	call partCommon_decCounter1IfNonzero		; $52d4
	jr nz,+			; $52d7
	ld l,e			; $52d9
	inc (hl)		; $52da

@state2:
	call _partCommon_checkTileCollisionOrOutOfBounds		; $52db
	jr nc,+			; $52de
	jr nz,_func_52f4	; $52e0
	jr @state5		; $52e2
+
	call objectCheckWithinScreenBoundary		; $52e4
	jp c,objectApplySpeed		; $52e7
	jr @state5		; $52ea

@state3:
	call _func_5336		; $52ec
	jr @state2		; $52ef

@state5:
	jp partDelete		; $52f1

_func_52f4:
	ld e,$c4		; $52f4
	ld a,$04		; $52f6
	ld (de),a		; $52f8
	xor a			; $52f9
	jp _partCommon_bounceWhenCollisionsEnabled		; $52fa

_func_52fd:
	ld e,$c9		; $52fd
	ld a,(de)		; $52ff
	bit 2,a			; $5300
	jr nz,_func_5313			; $5302
	sub $08			; $5304
	rrca			; $5306
	ld b,a			; $5307
	ld a,(w1Link.direction)		; $5308
	add b			; $530b
	ld hl,_table_532a		; $530c
	rst_addAToHl			; $530f
	ld a,(hl)		; $5310
	ld (de),a		; $5311
	ret			; $5312

_func_5313:
	sub $0c			; $5313
	rrca			; $5315
	ld b,a			; $5316
	ld a,(w1Link.direction)		; $5317
	add b			; $531a
	ld hl,_table_5322		; $531b
	rst_addAToHl			; $531e
	ld a,(hl)		; $531f
	ld (de),a		; $5320
	ret			; $5321

_table_5322:
	.db $04 $08 $10 $14
	.db $1c $0c $10 $18

_table_532a:
	.db $04 $08 $0c $18
	.db $00 $0c $10 $14
	.db $1c $08 $14 $18

_func_5336:
	ld a,$24		; $5336
	call objectGetRelatedObject1Var		; $5338
	bit 7,(hl)		; $533b
	ret z			; $533d
	call checkObjectsCollided		; $533e
	ret nc			; $5341
	ld l,$aa		; $5342
	ld (hl),$82		; $5344
	ld l,$b0		; $5346
	dec (hl)		; $5348
	ld l,$ab		; $5349
	ld (hl),$0c		; $534b
	ld e,$c4		; $534d
	ld a,$04		; $534f
	ld (de),a		; $5351
	ret			; $5352


; ==============================================================================
; PARTID_WIZZROBE_PROJECTILE
; ==============================================================================
; @addr{5353}
partCode1f:
	jr nz,@normalStatus	; $5353
	ld e,$c4		; $5355
	ld a,(de)		; $5357
	or a			; $5358
	jr z,_func_5369	; $5359
	call objectCheckWithinScreenBoundary		; $535b
	jr nc,@normalStatus	; $535e
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5360
	jp nc,objectApplySpeed		; $5363
@normalStatus:
	jp partDelete		; $5366

_func_5369:
	ld h,d			; $5369
	ld l,e			; $536a
	inc (hl)		; $536b
	ld l,$d0		; $536c
	ld (hl),$50		; $536e
	ld e,$c9		; $5370
	ld a,(de)		; $5372
	swap a			; $5373
	rlca			; $5375
	call partSetAnimation		; $5376
	jp objectSetVisible81		; $5379


; ==============================================================================
; PARTID_FIRE
; Created by fire keese
; ==============================================================================
; @addr{537c}
partCode20:
	ld e,$c4		; $537c
	ld a,(de)		; $537e
	or a			; $537f
	jr z,@state0	; $5380
	call partCommon_decCounter1IfNonzero		; $5382
	jp z,partDelete		; $5385
	jp partAnimate		; $5388

@state0:
	ld h,d			; $538b
	ld l,e			; $538c
	inc (hl)		; $538d
	ld l,$c6		; $538e
	ld (hl),$b4		; $5390
	jp objectSetVisible82		; $5392


; ==============================================================================
; PARTID_MOBLIN_BOOMERANG
; ==============================================================================
; @addr{5395}
partCode21:
	jr z,@normalStatus	; $5395
	ld e,$ea		; $5397
	ld a,(de)		; $5399
	res 7,a			; $539a
	sub $01			; $539c
	cp $03			; $539e
	jr nc,@normalStatus	; $53a0
	ld e,$c4		; $53a2
	ld a,$02		; $53a4
	ld (de),a		; $53a6

@normalStatus:
	ld e,$d7		; $53a7
	ld a,(de)		; $53a9
	inc a			; $53aa
	jr z,@partDelete	; $53ab
	ld e,$c4		; $53ad
	ld a,(de)		; $53af
	rst_jumpTable			; $53b0
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $53b7
	ld l,e			; $53b8
	inc (hl)		; $53b9
	ld l,$c6		; $53ba
	ld (hl),$2d		; $53bc
	inc l			; $53be
	ld (hl),$06		; $53bf
	ld l,$d0		; $53c1
	ld (hl),$50		; $53c3
	jp objectSetVisible81		; $53c5

@state1:
	call objectCheckSimpleCollision		; $53c8
	jr nz,@func_53ee	; $53cb
	call partCommon_decCounter1IfNonzero		; $53cd
	jr z,@func_53ee	; $53d0
	call _func_542a		; $53d2
@objectApplySpeed:
	call objectApplySpeed		; $53d5
@animate:
	jp partAnimate		; $53d8

@state2:
	call _func_541a		; $53db
	call _func_53f5		; $53de
	jr nc,@objectApplySpeed		; $53e1
	ld a,$18		; $53e3
	call objectGetRelatedObject1Var		; $53e5
	xor a			; $53e8
	ldi (hl),a		; $53e9
	ld (hl),a		; $53ea
@partDelete:
	jp partDelete		; $53eb

@func_53ee:
	ld e,$c4		; $53ee
	ld a,$02		; $53f0
	ld (de),a		; $53f2
	jr @animate		; $53f3

_func_53f5:
	ld a,$0b		; $53f5
	call objectGetRelatedObject1Var		; $53f7
	push hl			; $53fa
	ld b,(hl)		; $53fb
	ld l,$8d		; $53fc
	ld c,(hl)		; $53fe
	call objectGetRelativeAngle		; $53ff
	ld e,$c9		; $5402
	ld (de),a		; $5404
	pop hl			; $5405
	ld e,$cb		; $5406
	ld a,(de)		; $5408
	sub (hl)		; $5409
	add $04			; $540a
	cp $09			; $540c
	ret nc			; $540e
	ld l,$8d		; $540f
	ld e,$cd		; $5411
	ld a,(de)		; $5413
	sub (hl)		; $5414
	add $04			; $5415
	cp $09			; $5417
	ret			; $5419

_func_541a:
	ld a,(wFrameCounter)		; $541a
	and $03			; $541d
	ret nz			; $541f
	ld e,$d0		; $5420
	ld a,(de)		; $5422
	add $05			; $5423
	cp $50			; $5425
	ret nc			; $5427
	ld (de),a		; $5428
	ret			; $5429

_func_542a:
	ld h,d			; $542a
	ld l,$c7		; $542b
	dec (hl)		; $542d
	ret nz			; $542e
	ld (hl),$06		; $542f
	ld e,$d0		; $5431
	ld a,(de)		; $5433
	sub $05			; $5434
	ret c			; $5436
	ld (de),a		; $5437
	ret			; $5438


; ==============================================================================
; PARTID_CUCCO_ATTACKER
; ==============================================================================
partCode22:
	ld e,Part.state		; $5439
	ld a,(de)		; $543b
	rst_jumpTable			; $543c
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $5443
	ld l,e			; $5444
	inc (hl) ; [state]

	ld l,Part.counter1		; $5446
	ld (hl),$18		; $5448
	ld l,Part.zh		; $544a
	ld (hl),$fa		; $544c

	ld a,Object.var30		; $544e
	call objectGetRelatedObject1Var		; $5450
	ld a,(hl)		; $5453
	sub $10			; $5454
	and $1e			; $5456
	rrca			; $5458
	ld hl,@speedVals		; $5459
	rst_addAToHl			; $545c
	ld e,Part.speed		; $545d
	ld a,(hl)		; $545f
	ld (de),a		; $5460

	call objectSetVisiblec1		; $5461

	call getRandomNumber_noPreserveVars		; $5464
	ld c,a			; $5467
	and $30			; $5468
	ld b,a			; $546a
	swap b			; $546b
	and $10			; $546d
	ld hl,@xOrYVals		; $546f
	rst_addAToHl			; $5472
	ld a,c			; $5473
	and $0f			; $5474
	rst_addAToHl			; $5476
	bit 0,b			; $5477
	ld e,Part.yh		; $5479
	ld c,Part.xh		; $547b
	jr nz,+			; $547d
	ld e,c			; $547f
	ld c,Part.yh		; $5480
+
	ld a,(hl)		; $5482
	ld (de),a		; $5483

	ld a,b			; $5484
	ld hl,@screenEdgePositions		; $5485
	rst_addAToHl			; $5488
	ld e,c			; $5489
	ld a,(hl)		; $548a
	ld (de),a		; $548b
	call objectGetAngleTowardEnemyTarget		; $548c
	ld e,Part.angle		; $548f
	ld (de),a		; $5491

	; Decide animation based on angle
	cp $11			; $5492
	ld a,$00		; $5494
	jr nc,+			; $5496
	inc a			; $5498
+
	jp partSetAnimation		; $5499


@state1:
	call partCommon_decCounter1IfNonzero		; $549c
	jr nz,@applySpeedAndAnimate	; $549f
	ld l,e			; $54a1
	inc (hl)		; $54a2
	jr @applySpeedAndAnimate		; $54a3


@state2:
	call objectCheckWithinScreenBoundary		; $54a5
	jp nc,partDelete		; $54a8
@applySpeedAndAnimate:
	call objectApplySpeed		; $54ab
	jp partAnimate		; $54ae

@screenEdgePositions:
	.db $08 $98 $88 $08

@xOrYVals:
	.db $05 $0e $17 $20 $29 $32 $3b $44
	.db $4d $56 $5f $68 $71 $7a $83 $8c
	.db $05 $0f $19 $23 $2d $37 $41 $4b
	.db $55 $5f $69 $73 $7d $87 $91 $9b

@speedVals:
	.db SPEED_140 SPEED_180 SPEED_1c0 SPEED_200
	.db SPEED_240 SPEED_240 SPEED_280 SPEED_2c0
	.db SPEED_300


; ==============================================================================
; PARTID_FIRE_PIPES
; ==============================================================================
; @addr{54de}
partCode23:
	ld e,$c2		; $54de
	ld a,(de)		; $54e0
	ld e,$c4		; $54e1
	rst_jumpTable			; $54e3
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld a,(de)		; $54ea
	or a			; $54eb
	jr z,@func_54f6			; $54ec
	call partCommon_decCounter1IfNonzero		; $54ee
	ret nz			; $54f1
.ifdef ROM_AGES
	ld (hl),$78		; $54f2
.else
	ld (hl),$3c
.endif
	jr ++			; $54f4
@func_54f6:
	inc a			; $54f6
	ld (de),a		; $54f7
	ret			; $54f8

@subid1:
	ld a,(de)		; $54f9
	or a			; $54fa
	jr z,@func_54f6	; $54fb
	call partCommon_decCounter1IfNonzero		; $54fd
	ret nz			; $5500
	call _func_553f		; $5501
++
	call getFreePartSlot		; $5504
	ret nz			; $5507
	ld (hl),PARTID_FIRE_PIPES		; $5508
	inc l			; $550a
	ld (hl),$02		; $550b
	ld l,$f0		; $550d
	ld e,l			; $550f
	ld a,(de)		; $5510
	ld (hl),a		; $5511
	jp objectCopyPosition		; $5512

@subid2:
	ld a,(de)		; $5515
	or a			; $5516
	jr z,_func_5535			; $5517
	ld h,d			; $5519
	ld l,$cb		; $551a
	ld a,(hl)		; $551c
	cp $b0			; $551d
	jp nc,partDelete		; $551f
	ld l,$d0		; $5522
	ld e,$ca		; $5524
	call add16BitRefs		; $5526
	dec l			; $5529
	ld a,(hl)		; $552a
	add $10			; $552b
	ldi (hl),a		; $552d
	ld a,(hl)		; $552e
	adc $00			; $552f
	ld (hl),a		; $5531
	jp partAnimate		; $5532

_func_5535:
	ld h,d			; $5535
	ld l,e			; $5536
	inc (hl)		; $5537
	ld l,$e4		; $5538
	set 7,(hl)		; $553a
	jp objectSetVisible81		; $553c

_func_553f:
	ld e,$87		; $553f
	ld a,(de)		; $5541
	inc a			; $5542
	and $03			; $5543
	ld (de),a		; $5545
	ld hl,_table_554f		; $5546
	rst_addAToHl			; $5549
	ld e,$c6		; $554a
	ld a,(hl)		; $554c
	ld (de),a		; $554d
	ret			; $554e

_table_554f:
.ifdef ROM_AGES
	.db $78 $78
.else
	.db $3c $3c
.endif
	.db $1e $1e


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


; ==============================================================================
; PARTID_SMALL_FAIRY
; ==============================================================================
; @addr{560d}
partCode28:
	jr z,@normalStatus	; $560d
	cp $02			; $560f
	jp z,@collected		; $5611
	ld e,$c4		; $5614
	ld a,$02		; $5616
	ld (de),a		; $5618
@normalStatus:
	ld e,$c4		; $5619
	ld a,(de)		; $561b
	rst_jumpTable			; $561c
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $5623
	ld l,$c4		; $5624
	inc (hl)		; $5626
	ld l,$cf		; $5627
	ld (hl),$fa		; $5629
	ld l,$f1		; $562b
	ld e,$cb		; $562d
	ld a,(de)		; $562f
	ldi (hl),a		; $5630
	ld e,$cd		; $5631
	ld a,(de)		; $5633
	ld (hl),a		; $5634
	jp objectSetVisiblec2		; $5635

@state1:
	call partCommon_decCounter1IfNonzero		; $5638
	jr z,+			; $563b
	call _func_56cd		; $563d
	jp c,objectApplySpeed		; $5640
+
	call getRandomNumber_noPreserveVars		; $5643
	and $3e			; $5646
	add $08			; $5648
	ld e,$c6		; $564a
	ld (de),a		; $564c
	call getRandomNumber_noPreserveVars		; $564d
	and $03			; $5650
	ld hl,@table_5666		; $5652
	rst_addAToHl			; $5655
	ld e,$d0		; $5656
	ld a,(hl)		; $5658
	ld (de),a		; $5659
	call getRandomNumber_noPreserveVars		; $565a
	and $1e			; $565d
	ld h,d			; $565f
	ld l,$c9		; $5660
	ld (hl),a		; $5662
	jp _func_56b6		; $5663

@table_5666:
	.db $0a
	.db $14
	.db $1e
	.db $28

@state2:
	ld e,$c5		; $566a
	ld a,(de)		; $566c
	or a			; $566d
	jr nz,+			; $566e
	ld h,d			; $5670
	ld l,e			; $5671
	inc (hl)		; $5672
	ld l,$cf		; $5673
	ld (hl),$00		; $5675
	ld a,$01		; $5677
	call objectGetRelatedObject1Var		; $5679
	ld a,(hl)		; $567c
	ld e,$f0		; $567d
	ld (de),a		; $567f
	call objectSetVisible80		; $5680
+
	call objectCheckCollidedWithLink		; $5683
	jp c,@collected		; $5686
	ld a,$00		; $5689
	call objectGetRelatedObject1Var		; $568b
	ldi a,(hl)		; $568e
	or a			; $568f
	jr z,+			; $5690
	ld e,$f0		; $5692
	ld a,(de)		; $5694
	cp (hl)			; $5695
	jp z,objectTakePosition		; $5696
+
	jp partDelete		; $5699

@collected:
	ld a,$26		; $569c
	call cpActiveRing		; $569e
	ld c,$18		; $56a1
	jr z,+			; $56a3
	ld a,$25		; $56a5
	call cpActiveRing		; $56a7
	jr nz,++		; $56aa
+
	ld c,$30		; $56ac
++
	ld a,$29		; $56ae
	call giveTreasure		; $56b0
	jp partDelete		; $56b3

_func_56b6:
	ld e,$c9		; $56b6
	ld a,(de)		; $56b8
	and $0f			; $56b9
	ret z			; $56bb
	ld a,(de)		; $56bc
	cp $10			; $56bd
	ld a,$00		; $56bf
	jr nc,+			; $56c1
	inc a			; $56c3
+
	ld h,d			; $56c4
	ld l,$c8		; $56c5
	cp (hl)			; $56c7
	ret z			; $56c8
	ld (hl),a		; $56c9
	jp partSetAnimation		; $56ca

_func_56cd:
	ld e,$c9		; $56cd
	ld a,(de)		; $56cf
	and $07			; $56d0
	ld a,(de)		; $56d2
	jr z,+			; $56d3
	and $18			; $56d5
	add $04			; $56d7
+
	and $1c			; $56d9
	rrca			; $56db
	ld hl,_table_56f5		; $56dc
	rst_addAToHl			; $56df
	ld e,$cb		; $56e0
	ld a,(de)		; $56e2
	add (hl)		; $56e3
	ld b,a			; $56e4
	ld e,$cd		; $56e5
	inc hl			; $56e7
	ld a,(de)		; $56e8
	add (hl)		; $56e9
	sub $38			; $56ea
	cp $80			; $56ec
	ret nc			; $56ee
	ld a,b			; $56ef
	sub $18			; $56f0
	cp $50			; $56f2
	ret			; $56f4

_table_56f5:
	.db $fc $00 $fc $04
	.db $00 $04 $04 $04
	.db $04 $00 $04 $fc
	.db $00 $fc $fc $fc


; ==============================================================================
; PARTID_BEAM
; ==============================================================================
; @addr{5705}
partCode29:
	jr z,@normalStatus	; $5705
	ld e,$ea		; $5707
	ld a,(de)		; $5709
	cp $83			; $570a
	jp z,partDelete		; $570c
@normalStatus:
	ld e,$c4		; $570f
	ld a,(de)		; $5711
	rst_jumpTable			; $5712
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $5719
	ld l,e			; $571a
	inc (hl)		; $571b
	ld l,$c6		; $571c
	ld (hl),$02		; $571e
	ld l,$c9		; $5720
	ld c,(hl)		; $5722
	ld b,$50		; $5723
	ld a,$04		; $5725
	call objectSetComponentSpeedByScaledVelocity		; $5727
	ld e,$c9		; $572a
	ld a,(de)		; $572c
	and $0f			; $572d
	ld hl,@table_5737		; $572f
	rst_addAToHl			; $5732
	ld a,(hl)		; $5733
	jp partSetAnimation		; $5734

@table_5737:
	.db $00 $00 $01 $02
	.db $02 $02 $03 $04
	.db $04 $04 $05 $06
	.db $06 $06 $07 $00

@state1:
	call partCommon_decCounter1IfNonzero		; $5747
	jr nz,_func_5758	; $574a
	ld l,e			; $574c
	inc (hl)		; $574d

@state2:
	call _func_5758		; $574e
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5751
	jp c,partDelete		; $5754
	ret			; $5757

_func_5758:
	call objectApplyComponentSpeed		; $5758
	ld e,$c2		; $575b
	ld a,(de)		; $575d
	ld b,a			; $575e
	ld a,(wFrameCounter)		; $575f
	and b			; $5762
	jp z,objectSetVisible81		; $5763
	jp objectSetInvisible		; $5766


; ==============================================================================
; PARTID_SPIKED_BALL
;
; Variables:
;   speed: Nonstandard usage; it's a 16-bit variable which gets added to var30 (distance
;          away from origin).
;   relatedObj1: ENEMYID_BALL_AND_CHAIN_SOLDIER (for the head / subid 0),
;                or PARTID_SPIKED_BALL (the head; for subids 1-3).
;   var30: Distance away from origin point
; ==============================================================================
partCode2a:
	jr z,@normalStatus	; $5769

	; Check for sword or shield collision
	ld e,Part.var2a		; $576b
	ld a,(de)		; $576d
	res 7,a			; $576e
	sub ITEMCOLLISION_L1_SHIELD			; $5770
	cp ITEMCOLLISION_SWORD_HELD-ITEMCOLLISION_L1_SHIELD + 1
	jr nc,@normalStatus	; $5774

	; Make "parent" immune since the ball blocked the attack
	ld a,Object.invincibilityCounter		; $5776
	call objectGetRelatedObject1Var		; $5778
	ld a,(hl)		; $577b
	or a			; $577c
	jr nz,+			; $577d
	ld (hl),$f4		; $577f
+
	; If speedZ is positive, make it 0?
	ld h,d			; $5781
	ld l,Part.speedZ+1		; $5782
	ld a,(hl)		; $5784
	rlca			; $5785
	jr c,@normalStatus	; $5786
	xor a			; $5788
	ldd (hl),a		; $5789
	ld (hl),a		; $578a

@normalStatus:
	ld e,Part.subid		; $578b
	ld a,(de)		; $578d
	ld b,a			; $578e
	ld e,Part.state		; $578f
	ld a,b			; $5791
	rst_jumpTable			; $5792
	.dw _spikedBall_head
	.dw _spikedBall_chain
	.dw _spikedBall_chain
	.dw _spikedBall_chain


; The main part of the spiked ball (actually has collisions, etc)
_spikedBall_head:
	; Check if parent was deleted
	ld a,Object.id		; $579b
	call objectGetRelatedObject1Var		; $579d
	ld a,(hl)		; $57a0
	cp ENEMYID_BALL_AND_CHAIN_SOLDIER			; $57a1
	jp nz,partDelete		; $57a3

	ld b,h			; $57a6
	call _spikedBall_updateStateFromParent		; $57a7
	ld e,Part.state		; $57aa
	ld a,(de)		; $57ac
	rst_jumpTable			; $57ad
	.dw _spikedBall_head_state0
	.dw _spikedBall_head_state1
	.dw _spikedBall_head_state2
	.dw _spikedBall_head_state3
	.dw _spikedBall_head_state4
	.dw _spikedBall_head_state5


; Initialization
_spikedBall_head_state0:
	ld h,d			; $57ba
	ld l,e			; $57bb
	inc (hl) ; [state]

	ld l,Part.collisionType		; $57bd
	set 7,(hl)		; $57bf
	call objectSetVisible81		; $57c1


; Rotating slowly
_spikedBall_head_state1:
	ld e,Part.angle		; $57c4
	ld a,(de)		; $57c6
	inc a			; $57c7
	and $1f			; $57c8
	ld (de),a		; $57ca
	jr _spikedBall_head_setDefaultDistanceAway		; $57cb


; Rotating faster
_spikedBall_head_state2:
	ld e,Part.angle		; $57cd
	ld a,(de)		; $57cf
	add $02			; $57d0
	and $1f			; $57d2
	ld (de),a		; $57d4

_spikedBall_head_setDefaultDistanceAway:
	ld e,Part.var30		; $57d5
	ld a,$0a		; $57d7
	ld (de),a		; $57d9

;;
; @param	b	Enemy object
; @addr{57da}
_spikedBall_updatePosition:
	call _spikedBall_copyParentPosition		; $57da
	ld e,Part.var30		; $57dd
	ld a,(de)		; $57df
	ld e,Part.angle		; $57e0
	jp objectSetPositionInCircleArc		; $57e2


; About to throw the ball; waiting for it to rotate into a good position for throwing.
_spikedBall_head_state3:
	call _spikedBall_copyParentPosition		; $57e5

	; Compare the ball's angle with Link; must keep rotating it until it's aligned
	; perfectly.
	ldh a,(<hEnemyTargetY)	; $57e8
	ldh (<hFF8F),a	; $57ea
	ldh a,(<hEnemyTargetX)	; $57ec
	ldh (<hFF8E),a	; $57ee
	push hl			; $57f0
	call objectGetRelativeAngleWithTempVars		; $57f1
	pop bc			; $57f4
	xor $10			; $57f5
	ld e,a			; $57f7
	sub $06			; $57f8
	and $1f			; $57fa
	ld h,d			; $57fc
	ld l,Part.angle		; $57fd
	sub (hl)		; $57ff
	inc a			; $5800
	and $1f			; $5801
	cp $03			; $5803
	jr nc,_spikedBall_head_state2 ; keep rotating

	; It's aligned perfectly; begin throwing it.
	ld a,e			; $5807
	sub $03			; $5808
	and $1f			; $580a
	ld (hl),a ; [angle]

	ld l,Part.state		; $580d
	inc (hl)		; $580f

	ld l,Part.var30		; $5810
	ld (hl),$0d		; $5812
	jp _spikedBall_updatePosition		; $5814


; Ball has just been released
_spikedBall_head_state4:
	ld h,d			; $5817
	ld l,e			; $5818
	inc (hl) ; [state]

	ld l,Part.counter1		; $581a
	ld (hl),$00		; $581c

	ld l,Part.angle		; $581e
	ld a,(hl)		; $5820
	add $03			; $5821
	and $1f			; $5823
	ld (hl),a		; $5825

	; Distance from origin
	ld l,Part.var30		; $5826
	ld (hl),$12		; $5828

	; speed variable is used in a nonstandard way (added to var30, aka distance from
	; origin)
	ld l,Part.speed		; $582a
	ld a,<($0340)		; $582c
	ldi (hl),a		; $582e
	ld (hl),>($0340)		; $582f

	jp _spikedBall_updatePosition		; $5831


_spikedBall_head_state5:
	call _spikedBall_checkCollisionWithItem		; $5834
	call _spikedBall_head_updateDistanceFromOrigin		; $5837
	jp _spikedBall_updatePosition		; $583a


; The chain part of the ball (just decorative)
_spikedBall_chain:
	ld a,(de)		; $583d
	or a			; $583e
	jr nz,@state1	; $583f

@state0:
	inc a			; $5841
	ld (de),a ; [state]
	call partSetAnimation		; $5843
	call objectSetVisible81		; $5846

@state1:
	ld a,Object.id		; $5849
	call objectGetRelatedObject1Var		; $584b
	ld a,(hl)		; $584e
	cp PARTID_SPIKED_BALL			; $584f
	jp nz,partDelete		; $5851

	; Copy parent's angle
	ld l,Part.angle		; $5854
	ld e,l			; $5856
	ld a,(hl)		; $5857
	ld (de),a		; $5858

	call _spikedBall_chain_updateDistanceFromOrigin		; $5859
	ld l,Part.relatedObj1+1		; $585c
	ld b,(hl)		; $585e
	jp _spikedBall_updatePosition		; $585f


;;
; @param	b	Enemy object
; @addr{5862}
_spikedBall_copyParentPosition:
	ld h,b			; $5862
	ld l,Enemy.yh		; $5863
	ldi a,(hl)		; $5865
	sub $05			; $5866
	ld b,a			; $5868
	inc l			; $5869
	ldi a,(hl)		; $586a
	sub $05			; $586b
	ld c,a			; $586d
	inc l			; $586e
	ld a,(hl)		; $586f
	ld e,Part.zh		; $5870
	ld (de),a		; $5872
	ret			; $5873


;;
; If the ball collides with any item other than Link, this sets its speed to 0 (begins
; retracting earlier).
; @addr{5874}
_spikedBall_checkCollisionWithItem:
	; Check for collision with any item other than Link himself
	ld h,d			; $5874
	ld l,Part.var2a		; $5875
	bit 7,(hl)		; $5877
	ret z			; $5879
	ld a,(hl)		; $587a
	cp $80|ITEMCOLLISION_LINK			; $587b
	ret z			; $587d

	ld l,Part.speed+1		; $587e
	bit 7,(hl)		; $5880
	ret nz			; $5882
	xor a			; $5883
	ldd (hl),a		; $5884
	ld (hl),a		; $5885
	ret			; $5886


;;
; @addr{5887}
_spikedBall_head_updateDistanceFromOrigin:
	ld h,d			; $5887
	ld e,Part.var30		; $5888
	ld l,Part.speed+1		; $588a
	ld a,(de)		; $588c
	add (hl)		; $588d
	cp $0a			; $588e
	jr c,@fullyRetracted	; $5890

	ld (de),a		; $5892

	; Deceleration
	dec l			; $5893
	ld a,(hl)		; $5894
	sub <($0020)			; $5895
	ldi (hl),a		; $5897
	ld a,(hl)		; $5898
	sbc >($0020)			; $5899
	ld (hl),a		; $589b
	ret			; $589c

@fullyRetracted:
	; Tell parent (ENEMYID_BALL_AND_CHAIN_SOLDIER) we're fully retracted
	ld a,Object.counter1		; $589d
	call objectGetRelatedObject1Var		; $589f
	ld (hl),$00		; $58a2
	ret			; $58a4


;;
; Reads parent's var30 to decide whether to update state>
; @addr{58a5}
_spikedBall_updateStateFromParent:
	ld l,Enemy.var30		; $58a5

	; Check state between 1-3
	ld e,Part.state		; $58a7
	ld a,(de)		; $58a9
	dec a			; $58aa
	cp $03			; $58ab
	jr c,++			; $58ad

	; If uninitialized (state 0), return
	inc a			; $58af
	ret z			; $58b0

	; State is 4 or above (ball is being thrown).
	; Continue if [parent.var30] != 2 (signal to throw ball)
	ld a,(hl)		; $58b1
	cp $02			; $58b2
	ret z			; $58b4
++
	; Set state to:
	; * 1 if [parent.var30] == 0 (ball rotates slowly)
	; * 2 if [parent.var30] == 1 (ball rotates quickly)
	; * 3 if [parent.var30] >= 2 (ball should be thrown)
	ld a,(hl)		; $58b5
	or a			; $58b6
	ld c,$01		; $58b7
	jr z,++			; $58b9
	inc c			; $58bb
	dec a			; $58bc
	jr z,++			; $58bd
	inc c			; $58bf
++
	ld e,Part.state		; $58c0
	ld a,c			; $58c2
	ld (de),a		; $58c3
	ret			; $58c4

;;
; @param	h	Parent object (the actual ball)
; @addr{58c5}
_spikedBall_chain_updateDistanceFromOrigin:
	ld l,Part.var30		; $58c5
	push hl			; $58c7
	ld e,Part.subid		; $58c8
	ld a,(de)		; $58ca
	dec a			; $58cb
	rst_jumpTable			; $58cc
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid1:
	; [var30] = [parent.var30] * 3/4
	pop hl			; $58d3
	ld e,l			; $58d4
	ld a,(hl)		; $58d5
	srl a			; $58d6
	srl a			; $58d8
	ld b,a			; $58da
	add a			; $58db
	add b			; $58dc
	inc a			; $58dd
	ld (de),a		; $58de
	ret			; $58df

@subid2:
	; [var30] = [parent.var30] * 2/4
	pop hl			; $58e0
	ld e,l			; $58e1
	ld a,(hl)		; $58e2
	srl a			; $58e3
	srl a			; $58e5
	add a			; $58e7
	ld (de),a		; $58e8
	ret			; $58e9

@subid3:
	; [var30] = [parent.var30] * 1/4
	pop hl			; $58ea
	ld e,l			; $58eb
	ld a,(hl)		; $58ec
	srl a			; $58ed
	srl a			; $58ef
	ld (de),a		; $58f1
	ret			; $58f2


; ==============================================================================
; PARTID_GREAT_FAIRY_HEART
; ==============================================================================
; @addr{58f3}
partCode30:
	ld e,$c4		; $58f3
	ld a,(de)		; $58f5
	or a			; $58f6
	jr nz,+			; $58f7
	ld h,d			; $58f9
	ld l,e			; $58fa
	inc (hl)		; $58fb
	ld l,$c6		; $58fc
	ld (hl),$03		; $58fe
	call objectSetVisible81		; $5900
+
	ldh a,(<hEnemyTargetY)	; $5903
	ld b,a			; $5905
	ldh a,(<hEnemyTargetX)	; $5906
	ld c,a			; $5908
	ld a,$20		; $5909
	ld e,$c9		; $590b
	call objectSetPositionInCircleArc		; $590d
	call partCommon_decCounter1IfNonzero		; $5910
	ret nz			; $5913
	ld (hl),$03		; $5914
	ld l,$c9		; $5916
	ld a,(hl)		; $5918
	dec a			; $5919
	and $1f			; $591a
	ld (hl),a		; $591c
	ret nz			; $591d
	ld hl,wLinkMaxHealth		; $591e
	ld a,(wDisplayedHearts)		; $5921
	cp (hl)			; $5924
	ret nz			; $5925
	ld a,$31		; $5926
	call objectGetRelatedObject1Var		; $5928
	dec (hl)		; $592b
	jp partDelete		; $592c


; ==============================================================================
; PARTID_RED_TWINROVA_PROJECTILE
; PARTID_BLUE_TWINROVA_PROJECTILE
;
; Variables:
;   relatedObj1: Instance of ENEMYID_TWINROVA that fired the projectile
;   relatedObj2: Instance of ENEMYID_TWINROVA that could be hit by the projectile
; ==============================================================================
partCode4b:
partCode4d:
	jr z,@normalStatus	; $592f

	ld e,Part.var2a		; $5931
	ld a,(de)		; $5933
	cp $80|ITEMCOLLISION_L3_SHIELD			; $5934
	jp z,partDelete		; $5936

	cp $80|ITEMCOLLISION_LINK			; $5939
	jr z,@normalStatus	; $593b

	; Gets reflected
	call objectGetAngleTowardEnemyTarget		; $593d
	xor $10			; $5940
	ld h,d			; $5942
	ld l,Part.angle		; $5943
	ld (hl),a		; $5945
	ld l,Part.state		; $5946
	ld (hl),$03		; $5948
	ld l,Part.speed		; $594a
	ld (hl),SPEED_280		; $594c

@normalStatus:
	; Check if twinrova is dead
	ld a,Object.state		; $594e
	call objectGetRelatedObject1Var		; $5950
	ld a,(hl)		; $5953
	cp $0d			; $5954
	jp nc,@deleteWithPoof		; $5956

	ld e,Part.state		; $5959
	ld a,(de)		; $595b
	rst_jumpTable			; $595c
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d			; $5965
	ld l,e			; $5966
	inc (hl) ; [state] = 1

	ld l,Part.counter1		; $5968
	ld (hl),30		; $596a
	ld l,Part.speed		; $596c
	ld (hl),SPEED_200		; $596e

	; Transfer z-position to y-position
	ld l,Part.zh		; $5970
	ld a,(hl)		; $5972
	ld (hl),$00		; $5973
	ld l,Part.yh		; $5975
	add (hl)		; $5977
	ld (hl),a		; $5978

	; Get the other twinrova object, put it in relatedObj2
	ld a,Object.relatedObj1		; $5979
	call objectGetRelatedObject1Var		; $597b
	ld e,Part.relatedObj2		; $597e
	ldi a,(hl)		; $5980
	ld (de),a		; $5981
	inc e			; $5982
	ld a,(hl)		; $5983
	ld (de),a		; $5984

	; Play sound depending which one it is
	ld e,Part.id		; $5985
	ld a,(de)		; $5987
	cp PARTID_RED_TWINROVA_PROJECTILE			; $5988
	ld a,SND_BEAM1		; $598a
	jr z,+			; $598c
	ld a,SND_BEAM2		; $598e
+
	call playSound		; $5990
	call objectSetVisible81		; $5993

; Being charged up
@state1:
	call partCommon_decCounter1IfNonzero		; $5996
	jr z,@fire	; $5999

	; Copy parent's position
	ld a,Object.yh		; $599b
	call objectGetRelatedObject1Var		; $599d
	ld bc,$ea00		; $59a0
	call objectTakePositionWithOffset		; $59a3
	xor a			; $59a6
	ld (de),a ; [zh] = 0
	jr @animate		; $59a8

@fire:
	call objectGetAngleTowardEnemyTarget		; $59aa
	ld e,Part.angle		; $59ad
	ld (de),a		; $59af

	ld h,d			; $59b0
	ld l,Part.state		; $59b1
	inc (hl) ; [state] = 2

	ld l,Part.collisionType		; $59b4
	set 7,(hl)		; $59b6

; Moving
@state2:
	call objectApplySpeed		; $59b8
	call partCommon_checkOutOfBounds		; $59bb
	jr z,@delete	; $59be
@animate:
	jp partAnimate		; $59c0

@state3:
	ld a,$00		; $59c3
	call objectGetRelatedObject2Var		; $59c5
	call checkObjectsCollided		; $59c8
	jr nc,@state2	; $59cb

	; Collided with opposite-color twinrova
	ld l,Enemy.invincibilityCounter		; $59cd
	ld (hl),20		; $59cf
	ld l,Enemy.health		; $59d1
	dec (hl)		; $59d3
	jr nz,++		; $59d4

	; Other twinrova's health is 0; set a signal.
	ld l,Enemy.var32		; $59d6
	set 6,(hl)		; $59d8
++
	; Decrement health of same-color twinrova as well
	ld a,Object.health		; $59da
	call objectGetRelatedObject1Var		; $59dc
	dec (hl)		; $59df

	ld a,SND_BOSS_DAMAGE		; $59e0
	call playSound		; $59e2
@delete:
	jp partDelete		; $59e5

@deleteWithPoof:
	call objectCreatePuff		; $59e8
	jp partDelete		; $59eb


; ==============================================================================
; PARTID_TWINROVA_FLAME
; ==============================================================================
; @addr{59ee}
partCode4c:
	jr z,@normalStatus	; $59ee
	ld e,$ea		; $59f0
	ld a,(de)		; $59f2
	cp $80			; $59f3
	jp nz,partDelete		; $59f5
@normalStatus:
	ld e,$c2		; $59f8
	ld a,(de)		; $59fa
	or a			; $59fb
	ld e,$c4		; $59fc
	ld a,(de)		; $59fe
	jr z,@subid0	; $59ff
	or a			; $5a01
	jr z,+			; $5a02
	call partAnimate		; $5a04
	call objectApplySpeed		; $5a07
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5a0a
	ret nz			; $5a0d
	jp partDelete		; $5a0e
+
	ld h,d			; $5a11
	ld l,e			; $5a12
	inc (hl)		; $5a13
	ld l,$d0		; $5a14
	ld (hl),$50		; $5a16
	ld l,$db		; $5a18
	ld a,$05		; $5a1a
	ldi (hl),a		; $5a1c
	ld (hl),a		; $5a1d
	ld l,$e6		; $5a1e
	ld a,$02		; $5a20
	ldi (hl),a		; $5a22
	ld (hl),a		; $5a23
	ld a,SND_BEAM2		; $5a24
	call playSound		; $5a26
	ld a,$01		; $5a29
	call partSetAnimation		; $5a2b
	jp objectSetVisible82		; $5a2e

@subid0:
	rst_jumpTable			; $5a31
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $5a38
	ld l,e			; $5a39
	inc (hl)		; $5a3a
	ld l,$d0		; $5a3b
	ld (hl),$46		; $5a3d
	ld l,$c6		; $5a3f
	ld (hl),$1e		; $5a41
	jp objectSetVisible82		; $5a43

@state1:
	call partCommon_decCounter1IfNonzero		; $5a46
	jp nz,partAnimate		; $5a49
	ld l,e			; $5a4c
	inc (hl)		; $5a4d
	call objectGetAngleTowardEnemyTarget		; $5a4e
	ld e,$c9		; $5a51
	ld (de),a		; $5a53

@state2:
	call partAnimate		; $5a54
	call objectApplySpeed		; $5a57
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5a5a
	ret nc			; $5a5d
	call objectGetAngleTowardEnemyTarget		; $5a5e
	sub $02			; $5a61
	and $1f			; $5a63
	ld c,a			; $5a65
	ld b,$03		; $5a66
-
	call getFreePartSlot		; $5a68
	jr nz,+			; $5a6b
	ld (hl),PARTID_TWINROVA_FLAME		; $5a6d
	inc l			; $5a6f
	inc (hl)		; $5a70
	ld l,$c9		; $5a71
	ld (hl),c		; $5a73
	call objectCopyPosition		; $5a74
+
	ld a,c			; $5a77
	add $02			; $5a78
	and $1f			; $5a7a
	ld c,a			; $5a7c
	dec b			; $5a7d
	jr nz,-			; $5a7e
	call objectCreatePuff		; $5a80
	jp partDelete		; $5a83


; ==============================================================================
; PARTID_TWINROVA_SNOWBALL
; ==============================================================================
partCode4e:
	jr z,@normalStatus	; $5a86

	; Hit something
	ld e,Part.var2a		; $5a88
	ld a,(de)		; $5a8a
	cp $80|ITEMCOLLISION_L3_SHIELD			; $5a8b
	jr z,@destroy	; $5a8d

	res 7,a			; $5a8f
	sub ITEMCOLLISION_L2_SWORD			; $5a91
	cp ITEMCOLLISION_SWORDSPIN - ITEMCOLLISION_L2_SWORD + 1			; $5a93
	jp c,@destroy		; $5a95

@normalStatus:
	ld e,Part.state		; $5a98
	ld a,(de)		; $5a9a
	rst_jumpTable			; $5a9b
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $5aa2
	ld l,e			; $5aa3
	inc (hl) ; [state] = 1

	ld l,Part.counter1		; $5aa5
	ld (hl),30		; $5aa7

	ld l,Part.speed		; $5aa9
	ld (hl),SPEED_240		; $5aab

	ld a,SND_TELEPORT		; $5aad
	call playSound		; $5aaf
	jp objectSetVisible82		; $5ab2


; Spawning in, not moving yet
@state1:
	call partCommon_decCounter1IfNonzero		; $5ab5
	jr z,@beginMoving	; $5ab8

	ld l,Part.animParameter		; $5aba
	bit 0,(hl)		; $5abc
	jr z,@animate	; $5abe

	ld (hl),$00		; $5ac0
	ld l,Part.collisionType		; $5ac2
	set 7,(hl)		; $5ac4
@animate:
	jp partAnimate		; $5ac6

@beginMoving:
	ld l,e			; $5ac9
	inc (hl) ; [state] = 2

	call objectGetAngleTowardEnemyTarget		; $5acb
	ld e,Part.angle		; $5ace
	ld (de),a		; $5ad0


; Moving toward Link
@state2:
	call objectApplySpeed		; $5ad1
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5ad4
	ret nc			; $5ad7

@destroy:
	ld b,INTERACID_SNOWDEBRIS		; $5ad8
	call objectCreateInteractionWithSubid00		; $5ada
	jp partDelete		; $5add


; ==============================================================================
; PARTID_50
; Used by Ganon
; ==============================================================================
; @addr{5ae0}
partCode50:
	ld a,$04		; $5ae0
	call objectGetRelatedObject1Var		; $5ae2
	ld a,(hl)		; $5ae5
	cp $0e			; $5ae6
	jp z,partDelete		; $5ae8
	push hl			; $5aeb
	ld e,$c4		; $5aec
	ld a,(de)		; $5aee
	rst_jumpTable			; $5aef
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $5af6
	ld (de),a		; $5af8
	pop hl			; $5af9
	call objectTakePosition		; $5afa
	ld l,$b2		; $5afd
	ld a,(hl)		; $5aff
	or a			; $5b00
	jr z,+			; $5b01
	ld a,$01		; $5b03
+
	jp partSetAnimation		; $5b05

@state1:
	call partAnimate		; $5b08
	ld e,$e1		; $5b0b
	ld a,(de)		; $5b0d
	inc a			; $5b0e
	jr nz,_func_5b2b	; $5b0f
	ld h,d			; $5b11
	ld l,$c4		; $5b12
	inc (hl)		; $5b14
	ld l,$e6		; $5b15
	ld a,$07		; $5b17
	ldi (hl),a		; $5b19
	ld (hl),a		; $5b1a
	call objectSetInvisible		; $5b1b

@state2:
	pop hl			; $5b1e
	inc l			; $5b1f
	ld a,(hl)		; $5b20
	or a			; $5b21
	jp z,partDelete		; $5b22
	ld bc,$2000		; $5b25
	jp objectTakePositionWithOffset		; $5b28

_func_5b2b:
	ld h,d			; $5b2b
	ld l,e			; $5b2c
	bit 7,(hl)		; $5b2d
	jr z, +			; $5b2f
	res 7,(hl)		; $5b31
	call objectSetVisible82		; $5b33
	ld a,SND_BIGSWORD		; $5b36
	call playSound		; $5b38
	ld h,d			; $5b3b
	ld l,$e1		; $5b3c
+
	ld a,(hl)		; $5b3e
	ld hl,_table_5b5b		; $5b3f
	rst_addAToHl			; $5b42
	ld e,$e6		; $5b43
	ldi a,(hl)		; $5b45
	ld (de),a		; $5b46
	inc e			; $5b47
	ldi a,(hl)		; $5b48
	ld (de),a		; $5b49
	ldi a,(hl)		; $5b4a
	ld b,a			; $5b4b
	ld c,(hl)		; $5b4c
	pop hl			; $5b4d
	ld l,$b2		; $5b4e
	ld a,(hl)		; $5b50
	or a			; $5b51
	jr z,+			; $5b52
	ld a,c			; $5b54
	cpl			; $5b55
	inc a			; $5b56
	ld c,a			; $5b57
+
	jp objectTakePositionWithOffset		; $5b58

_table_5b5b:
	.db $07 $07 $d8 $f1
	.db $0b $07 $e7 $1a
	.db $20 $0c $f7 $19


; ==============================================================================
; PARTID_51
; Used by Ganon
; ==============================================================================
; @addr{5b67}
partCode51:
	ld a,$04		; $5b67
	call objectGetRelatedObject1Var		; $5b69
	ld a,(hl)		; $5b6c
	cp $0e			; $5b6d
	jp z,partDelete		; $5b6f
	ld e,$c2		; $5b72
	ld a,(de)		; $5b74
	ld e,$c4		; $5b75
	rst_jumpTable			; $5b77
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld a,(de)		; $5b7e
	or a			; $5b7f
	jr nz,+			; $5b80
	ld h,d			; $5b82
	ld l,e			; $5b83
	inc (hl)		; $5b84
	ld l,$c6		; $5b85
	ld (hl),$40		; $5b87
	ld l,$e8		; $5b89
	ld (hl),$f0		; $5b8b
	ld l,$da		; $5b8d
	ld (hl),$02		; $5b8f
	ld a,SND_ENERGYTHING		; $5b91
	call playSound		; $5b93
+
	call partCommon_decCounter1IfNonzero		; $5b96
	jp z,partDelete		; $5b99
	jr +			; $5b9c

@subid2:
	ld a,(de)		; $5b9e
	or a			; $5b9f
	jr z,++			; $5ba0
	ld e,$e1		; $5ba2
	ld a,(de)		; $5ba4
	rlca			; $5ba5
	jp c,partDelete		; $5ba6
+
	ld e,$da		; $5ba9
	ld a,(de)		; $5bab
	xor $80			; $5bac
	ld (de),a		; $5bae
	jp partAnimate		; $5baf
++
	ld h,d			; $5bb2
	ld l,e			; $5bb3
	inc (hl)		; $5bb4
	ld l,$e4		; $5bb5
	set 7,(hl)		; $5bb7
	ld l,$c9		; $5bb9
	ld a,(hl)		; $5bbb
	ld b,$01		; $5bbc
	cp $0c			; $5bbe
	jr c,+			; $5bc0
	inc b			; $5bc2
	cp $19			; $5bc3
	jr c,+			; $5bc5
	inc b			; $5bc7
+
	ld a,b			; $5bc8
	dec a			; $5bc9
	and $01			; $5bca
	ld hl,@table_5bde		; $5bcc
	rst_addDoubleIndex			; $5bcf
	ld e,$e6		; $5bd0
	ldi a,(hl)		; $5bd2
	ld (de),a		; $5bd3
	inc e			; $5bd4
	ld a,(hl)		; $5bd5
	ld (de),a		; $5bd6
	ld a,b			; $5bd7
	call partSetAnimation		; $5bd8
	jp objectSetVisible83		; $5bdb

@table_5bde:
	.db $08 $0a
	.db $0a $0a

@subid1:
	ld a,(de)		; $5be2
	rst_jumpTable			; $5be3
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d			; $5bea
	ld l,e			; $5beb
	inc (hl)		; $5bec
	ld l,$dd		; $5bed
	ld a,(hl)		; $5bef
	add $0e			; $5bf0
	ld (hl),a		; $5bf2
	ld l,$c6		; $5bf3
	ld (hl),$18		; $5bf5
	ld a,$04		; $5bf7
	call partSetAnimation		; $5bf9
	jp objectSetVisible82		; $5bfc

@state1:
	call partCommon_decCounter1IfNonzero		; $5bff
	jr nz,@animate	; $5c02
	dec (hl)		; $5c04
	ld l,e			; $5c05
	inc (hl)		; $5c06
	ld l,$e4		; $5c07
	set 7,(hl)		; $5c09
	ld l,$db		; $5c0b
	ld a,$05		; $5c0d
	ldi (hl),a		; $5c0f
	ld (hl),a		; $5c10
	ld l,$cb		; $5c11
	ld a,(hl)		; $5c13
	add $08			; $5c14
	ldi (hl),a		; $5c16
	inc l			; $5c17
	ld a,(hl)		; $5c18
	sub $10			; $5c19
	ld (hl),a		; $5c1b
	call objectGetAngleTowardLink		; $5c1c
	ld e,$c9		; $5c1f
	ld (de),a		; $5c21
	ld c,a			; $5c22
	ld b,$50		; $5c23
	ld a,$02		; $5c25
	jp objectSetComponentSpeedByScaledVelocity		; $5c27

@state2:
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5c2a
	jr nc,+			; $5c2d
	ld b,INTERACID_EXPLOSION		; $5c2f
	call objectCreateInteractionWithSubid00		; $5c31
	ld a,$3c		; $5c34
	call z,setScreenShakeCounter		; $5c36
	jp partDelete		; $5c39
+
	call partCommon_decCounter1IfNonzero		; $5c3c
	ld a,(hl)		; $5c3f
	and $07			; $5c40
	jr nz,+			; $5c42
	call getFreePartSlot		; $5c44
	jr nz,+			; $5c47
	ld (hl),PARTID_51		; $5c49
	inc l			; $5c4b
	ld (hl),$02		; $5c4c
	ld l,$c9		; $5c4e
	ld e,l			; $5c50
	ld a,(de)		; $5c51
	ld (hl),a		; $5c52
	call objectCopyPosition		; $5c53
+
	call objectApplyComponentSpeed		; $5c56
@animate:
	jp partAnimate		; $5c59


; ==============================================================================
; PARTID_52
; Used by Ganon
; ==============================================================================
; @addr{5c5c}
partCode52:
	ld a,$04		; $5c5c
	call objectGetRelatedObject1Var		; $5c5e
	ld a,(hl)		; $5c61
	cp $0e			; $5c62
	jp z,partDelete		; $5c64
	ld e,$c2		; $5c67
	ld a,(de)		; $5c69
	ld e,$c4		; $5c6a
	rst_jumpTable			; $5c6c
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld a,(de)		; $5c73
	rst_jumpTable			; $5c74
	.dw @@state0
	.dw @@state1
	.dw @@state2

@@state0:
	ld h,d			; $5c7b
	ld l,e			; $5c7c
	inc (hl)		; $5c7d
	ld l,$c6		; $5c7e
	ld (hl),$0a		; $5c80
	jp objectSetVisible82		; $5c82

@@state1:
	call partCommon_decCounter1IfNonzero		; $5c85
	jr nz,+			; $5c88
	ld l,e			; $5c8a
	inc (hl)		; $5c8b
	ld a,SND_BEAM		; $5c8c
	call playSound		; $5c8e
	ld a,$02		; $5c91
	call partSetAnimation		; $5c93

@@state2:
	call partCommon_checkOutOfBounds		; $5c96
	jp z,partDelete		; $5c99
	call objectApplySpeed		; $5c9c
+
	jp partAnimate		; $5c9f

@subid1:
	ld a,(de)		; $5ca2
	rst_jumpTable			; $5ca3
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @subid0@state2

@@state0:
	ld h,d			; $5cac
	ld l,$d0		; $5cad
	ld (hl),$50		; $5caf
	ld l,e			; $5cb1
	call objectSetVisible82		; $5cb2
	ld e,$c3		; $5cb5
	ld a,(de)		; $5cb7
	or a			; $5cb8
	jr z,+			; $5cb9
	ld (hl),$03		; $5cbb
	ld l,$e6		; $5cbd
	ld a,$02		; $5cbf
	ldi (hl),a		; $5cc1
	ld (hl),a		; $5cc2
	ret			; $5cc3
+
	inc (hl)		; $5cc4
	ld l,$c6		; $5cc5
	ld (hl),$28		; $5cc7
	ld l,$e6		; $5cc9
	ld a,$04		; $5ccb
	ldi (hl),a		; $5ccd
	ld (hl),a		; $5cce
	ld e,$cb		; $5ccf
	ld l,$f0		; $5cd1
	ld a,(de)		; $5cd3
	add $20			; $5cd4
	ldi (hl),a		; $5cd6
	ld e,$cd		; $5cd7
	ld a,(de)		; $5cd9
	ld (hl),a		; $5cda
	ld a,$01		; $5cdb
	call partSetAnimation		; $5cdd

@@state1:
	call partCommon_decCounter1IfNonzero		; $5ce0
	jr z,++			; $5ce3
	ld a,(hl)		; $5ce5
	rrca			; $5ce6
	ld e,$c9		; $5ce7
	jr c,+			; $5ce9
	ld a,(de)		; $5ceb
	inc a			; $5cec
	and $1f			; $5ced
	ld (de),a		; $5cef
+
	ld l,$da		; $5cf0
	ld a,(hl)		; $5cf2
	xor $80			; $5cf3
	ld (hl),a		; $5cf5
	ld l,$f0		; $5cf6
	ld b,(hl)		; $5cf8
	inc l			; $5cf9
	ld c,(hl)		; $5cfa
	ld a,$08		; $5cfb
	call objectSetPositionInCircleArc		; $5cfd
	jr @@animate	; $5d00
++
	ld (hl),$0a		; $5d02
	ld l,e			; $5d04
	inc (hl)		; $5d05
	ld a,SND_VERAN_PROJECTILE		; $5d06
	call playSound		; $5d08
	call objectSetVisible82		; $5d0b
@@animate:
	jp partAnimate		; $5d0e

@@state2:
	call partCommon_decCounter1IfNonzero		; $5d11
	jr z,+			; $5d14
	call objectApplySpeed		; $5d16
	jr @@animate		; $5d19
+
	ld l,e			; $5d1b
	inc (hl)		; $5d1c
	ld l,$e6		; $5d1d
	ld a,$02		; $5d1f
	ldi (hl),a		; $5d21
	ld (hl),a		; $5d22
	xor a			; $5d23
	call partSetAnimation		; $5d24
	call objectCreatePuff		; $5d27
	ld b,$fd		; $5d2a
	call @func_5d31		; $5d2c
	ld b,$03		; $5d2f

@func_5d31:
	call getFreePartSlot		; $5d31
	ret nz			; $5d34
	ld (hl),PARTID_52		; $5d35
	inc l			; $5d37
	inc (hl)		; $5d38
	inc l			; $5d39
	inc (hl)		; $5d3a
	ld l,$c9		; $5d3b
	ld e,l			; $5d3d
	ld a,(de)		; $5d3e
	add b			; $5d3f
	and $1f			; $5d40
	ld (hl),a		; $5d42
	jp objectCopyPosition		; $5d43

@subid2:
	ld a,(de)		; $5d46
	rst_jumpTable			; $5d47
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @subid0@state2

@@state0:
	ld h,d			; $5d50
	ld l,e			; $5d51
	inc (hl)		; $5d52
	ld l,$c6		; $5d53
	ld (hl),$0f		; $5d55
	jp objectSetVisible82		; $5d57

@@state1:
	call partCommon_decCounter1IfNonzero		; $5d5a
	jp nz,partAnimate		; $5d5d
	ld (hl),$0f		; $5d60
	ld l,e			; $5d62
	inc (hl)		; $5d63
	ld a,SND_VERAN_FAIRY_ATTACK		; $5d64
	call playSound		; $5d66
	ld a,$01		; $5d69
	jp partSetAnimation		; $5d6b

@@state2:
	call partCommon_decCounter1IfNonzero		; $5d6e
	jp nz,partAnimate		; $5d71
	ld l,e			; $5d74
	inc (hl)		; $5d75
	ld l,$d0		; $5d76
	ld (hl),$5a		; $5d78
	call objectGetAngleTowardLink		; $5d7a
	ld e,$c9		; $5d7d
	ld (de),a		; $5d7f
	ld a,$02		; $5d80
	jp partSetAnimation		; $5d82


; ==============================================================================
; PARTID_BLUE_ENERGY_BEAD
; Used by "createEnergySwirl" functions
; ==============================================================================
; @addr{5d85}
partCode53:
	ld e,$c4		; $5d85
	ld a,(de)		; $5d87
	or a			; $5d88
	jr z,@state0	; $5d89
	ld a,(wDeleteEnergyBeads)		; $5d8b
	or a			; $5d8e
	jp nz,partDelete		; $5d8f
	ld h,d			; $5d92
	ld l,$c6		; $5d93
	ld a,(hl)		; $5d95
	inc a			; $5d96
	jr z,+			; $5d97
	dec (hl)		; $5d99
	jp z,partDelete		; $5d9a
+
	inc e			; $5d9d
	ld a,(de)		; $5d9e
	or a			; $5d9f
	jr nz,+			; $5da0
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
+
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
	jr +			; $5dcb
@state0:
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
+
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
