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
	call _itemDrop_checkOnHazard		; $4198
	ret c			; $419b
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
	call _partCommon_decCounter1IfNonzero		; $42d6
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

	ld a,c			; $4310
	and $07			; $4311
	ld hl,@enemiesToSpawn		; $4313
	rst_addAToHl			; $4316
	ld b,(hl)		; $4317
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

_itemDrop_conveyorTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

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
	call _partCommon_decCounter1IfNonzero		; $45c5
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
	call _partCommon_decCounter1IfNonzero		; $45fa
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

	call objectGetTileAtPosition		; $4738
	sub TILEINDEX_BUTTON			; $473b
	cp $02 ; TILEINDEX_BUTTON or TILEINDEX_PRESSED_BUTTON
	jr nc,@somethingOnButton	; $473f

	call _partCommon_decCounter1IfNonzero		; $4741
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
	ld hl,bank0e.orbMovementScript		; $4806
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

	call _partCommon_decCounter1IfNonzero		; $4862
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
	call _partCommon_decCounter1IfNonzero		; $48e2
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
	call _partCommon_decCounter1IfNonzero		; $496a
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
	call _partCommon_decCounter1IfNonzero		; $49d9
	ret nz			; $49dc

	; Time to respawn
	ld (hl),$0c ; [counter1]
	ld l,e			; $49df
	inc (hl) ; [state] = 3
	ld a,TILEINDEX_RESPAWNING_BUSH_REGEN		; $49e1
	jr @setTileHere		; $49e3

@state3:
	call _partCommon_decCounter1IfNonzero		; $49e5
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
	call _partCommon_decCounter1IfNonzero		; $49f8
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
	call _partCommon_decCounter1IfNonzero		; $4b82
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
	call _partCommon_decCounter1IfNonzero		; $4c57
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
; @addr{4c94}
partCode13:
	jr z,_label_11_083	; $4c94
	ld e,$ea		; $4c96
	ld a,(de)		; $4c98
	cp $9a			; $4c99
	jr nz,_label_11_083	; $4c9b
	ld h,d			; $4c9d
	ld l,$c4		; $4c9e
	ld a,(hl)		; $4ca0
	cp $02			; $4ca1
	jr nc,_label_11_083	; $4ca3
	inc (hl)		; $4ca5
	ld l,$c6		; $4ca6
	ld (hl),$32		; $4ca8
_label_11_083:
	ld e,$c4		; $4caa
	ld a,(de)		; $4cac
	rst_jumpTable			; $4cad
.dw $4cb6
.dw $4cc7
.dw $4cc8
.dw $4cfb
	ld h,d			; $4cb6
	ld l,e			; $4cb7
	inc (hl)		; $4cb8
	ld l,$ff		; $4cb9
	set 5,(hl)		; $4cbb
	call objectMakeTileSolid		; $4cbd
	ld h,$cf		; $4cc0
	ld (hl),$00		; $4cc2
	jp objectSetVisible83		; $4cc4
	ret			; $4cc7
	call _partCommon_decCounter1IfNonzero		; $4cc8
	jr nz,_label_11_084	; $4ccb
	ld (hl),$1e		; $4ccd
	ld l,e			; $4ccf
	inc (hl)		; $4cd0
	ld a,$01		; $4cd1
	jp partSetAnimation		; $4cd3
_label_11_084:
	ld a,(hl)		; $4cd6
	and $07			; $4cd7
	ret nz			; $4cd9
	ld a,(hl)		; $4cda
	rrca			; $4cdb
	rrca			; $4cdc
	sub $02			; $4cdd
	ld hl,$4cef		; $4cdf
	rst_addAToHl			; $4ce2
	ldi a,(hl)		; $4ce3
	ld b,a			; $4ce4
	ld c,(hl)		; $4ce5
	call getFreeInteractionSlot		; $4ce6
	ret nz			; $4ce9
	ld (hl),$84		; $4cea
	jp objectCopyPositionWithOffset		; $4cec
	ld sp,hl		; $4cef
	dec b			; $4cf0
	ld b,$ff		; $4cf1
.DB $fc				; $4cf3
	ld a,($0702)		; $4cf4
	nop			; $4cf7
	ld a,($02ff)		; $4cf8
	call _partCommon_decCounter1IfNonzero		; $4cfb
	jr nz,_label_11_085	; $4cfe
	ld l,e			; $4d00
	ld (hl),$01		; $4d01
	xor a			; $4d03
	jp partSetAnimation		; $4d04
_label_11_085:
	ld a,(hl)		; $4d07
	cp $16			; $4d08
	ret nz			; $4d0a
	ld l,$c2		; $4d0b
	ld c,(hl)		; $4d0d
	ld b,$39		; $4d0e
	jp showText		; $4d10

;;
; @addr{4d13}
partCode14:
partCode15:
	ld e,$c2		; $4d13
	jr z,_label_11_086	; $4d15
	cp $02			; $4d17
	jp z,$4e20		; $4d19
	ld h,d			; $4d1c
	ld l,$c2		; $4d1d
	set 7,(hl)		; $4d1f
	ld l,$c4		; $4d21
	ld (hl),$03		; $4d23
	inc l			; $4d25
	ld (hl),$00		; $4d26
_label_11_086:
	ld e,$c4		; $4d28
	ld a,(de)		; $4d2a
	rst_jumpTable			; $4d2b
.dw $4d36
.dw $4d83
.dw objectReplaceWithAnimationIfOnHazard
.dw $4d9b
.dw $4dcc

	ld h,d			; $4d36
	ld l,e			; $4d37
	inc (hl)		; $4d38
	ld l,$e6		; $4d39
	ld a,$06		; $4d3b
	ldi (hl),a		; $4d3d
	ld (hl),a		; $4d3e
	call getRandomNumber		; $4d3f
	ld b,a			; $4d42
	and $70			; $4d43
	swap a			; $4d45
	ld hl,$4d6b		; $4d47
	rst_addAToHl			; $4d4a
	ld e,$d0		; $4d4b
	ld a,(hl)		; $4d4d
	ld (de),a		; $4d4e
	ld a,b			; $4d4f
	and $0e			; $4d50
	ld hl,$4d73		; $4d52
	rst_addAToHl			; $4d55
	ld e,$d4		; $4d56
	ldi a,(hl)		; $4d58
	ld (de),a		; $4d59
	inc e			; $4d5a
	ldi a,(hl)		; $4d5b
	ld (de),a		; $4d5c
	call getRandomNumber		; $4d5d
	ld e,$c9		; $4d60
	and $1f			; $4d62
	ld (de),a		; $4d64
	call $4ec0		; $4d65
	jp objectSetVisiblec3		; $4d68
	inc d			; $4d6b
	ld e,$28		; $4d6c
	ldd (hl),a		; $4d6e
	inc a			; $4d6f
	ld b,(hl)		; $4d70
	ld d,b			; $4d71
	ld e,d			; $4d72
	add b			; $4d73
	cp $40			; $4d74
	cp $00			; $4d76
	cp $c0			; $4d78
.DB $fd				; $4d7a
	add b			; $4d7b
.DB $fd				; $4d7c
	ld b,b			; $4d7d
.DB $fd				; $4d7e
	nop			; $4d7f
.DB $fd				; $4d80
	ret nz			; $4d81
.DB $fc				; $4d82
	call objectApplySpeed		; $4d83
	call $4f03		; $4d86
	ld c,$20		; $4d89
	call objectUpdateSpeedZAndBounce		; $4d8b
	jr nc,_label_11_087	; $4d8e
	ld h,d			; $4d90
	ld l,$e4		; $4d91
	set 7,(hl)		; $4d93
	ld l,$c4		; $4d95
	inc (hl)		; $4d97
_label_11_087:
	jp objectReplaceWithAnimationIfOnHazard		; $4d98
	inc e			; $4d9b
	ld a,(de)		; $4d9c
	or a			; $4d9d
	jr nz,_label_11_088	; $4d9e
	ld h,d			; $4da0
	ld l,e			; $4da1
	inc (hl)		; $4da2
	ld l,$cf		; $4da3
	ld (hl),$00		; $4da5
	ld a,$01		; $4da7
	call objectGetRelatedObject1Var		; $4da9
	ld a,(hl)		; $4dac
	ld e,$f0		; $4dad
	ld (de),a		; $4daf
	call objectSetVisible80		; $4db0
_label_11_088:
	call objectCheckCollidedWithLink		; $4db3
	jp c,$4e20		; $4db6
	ld a,$00		; $4db9
	call objectGetRelatedObject1Var		; $4dbb
	ldi a,(hl)		; $4dbe
	or a			; $4dbf
	jr z,_label_11_089	; $4dc0
	ld e,$f0		; $4dc2
	ld a,(de)		; $4dc4
	cp (hl)			; $4dc5
	jp z,objectTakePosition		; $4dc6
_label_11_089:
	jp partDelete		; $4dc9
	inc e			; $4dcc
	ld a,(de)		; $4dcd
	rst_jumpTable			; $4dce
.dw $4dd7
.dw $4de6
.dw $4dfe
.dw $4e18
	ld h,d			; $4dd7
	ld l,e			; $4dd8
	inc (hl)		; $4dd9
	ld a,($d128)		; $4dda
	dec a			; $4ddd
	ld l,$d0		; $4dde
	ld (hl),$14		; $4de0
	jr z,_label_11_090	; $4de2
	ld (hl),$28		; $4de4
_label_11_090:
	ld hl,$d128		; $4de6
	ld a,(hl)		; $4de9
	or a			; $4dea
	jr z,_label_11_091	; $4deb
	call $4f2f		; $4ded
	ret nz			; $4df0
	ld l,$c5		; $4df1
	inc (hl)		; $4df3
	ld l,$e4		; $4df4
	res 7,(hl)		; $4df6
	ld bc,$ffc0		; $4df8
	jp objectSetSpeedZ		; $4dfb
	ld c,$00		; $4dfe
	call objectUpdateSpeedZ_paramC		; $4e00
	ld e,$cf		; $4e03
	ld a,(de)		; $4e05
	cp $f7			; $4e06
	ret nc			; $4e08
_label_11_091:
	ld a,$01		; $4e09
	ld ($d125),a		; $4e0b
	ld h,d			; $4e0e
	ld l,$c5		; $4e0f
	ld (hl),$03		; $4e11
	ld l,$c3		; $4e13
	ld (hl),$00		; $4e15
	ret			; $4e17
	ld e,$c3		; $4e18
	ld a,(de)		; $4e1a
	rlca			; $4e1b
	ret nc			; $4e1c
	jp partDelete		; $4e1d
	ld a,(wDisabledObjects)		; $4e20
	bit 0,a			; $4e23
	ret nz			; $4e25
	ld e,$c2		; $4e26
	ld a,(de)		; $4e28
	and $7f			; $4e29
	ld hl,$4f4a		; $4e2b
	rst_addAToHl			; $4e2e
	ld a,($d12a)		; $4e2f
	add (hl)		; $4e32
	ld ($d12a),a		; $4e33
	ld a,(de)		; $4e36
	and $7f			; $4e37
	jr z,_label_11_097	; $4e39
	add a			; $4e3b
	ld hl,$4e88		; $4e3c
	rst_addDoubleIndex			; $4e3f
	ldi a,(hl)		; $4e40
	ld b,a			; $4e41
	ld a,$26		; $4e42
	call cpActiveRing		; $4e44
	ldi a,(hl)		; $4e47
	jr z,_label_11_093	; $4e48
	cp $ff			; $4e4a
	jr z,_label_11_094	; $4e4c
	call cpActiveRing		; $4e4e
	jr nz,_label_11_094	; $4e51
_label_11_093:
	inc hl			; $4e53
_label_11_094:
	ld c,(hl)		; $4e54
	ld a,b			; $4e55
	cp TREASURE_RING			; $4e56
	jr nz,_label_11_095	; $4e58
	call getRandomRingOfGivenTier		; $4e5a
_label_11_095:
	cp TREASURE_POTION			; $4e5d
	jr nz,_label_11_096	; $4e5f
	ld a,SND_GETSEED		; $4e61
	call playSound		; $4e63
	ld a,TREASURE_POTION		; $4e66
_label_11_096:
	call giveTreasure		; $4e68
	jp partDelete		; $4e6b
_label_11_097:
	ld bc,$2b02		; $4e6e
	call createTreasure		; $4e71
	ret nz			; $4e74
	ld l,$4b		; $4e75
	ld a,(w1Link.yh)		; $4e77
	ldi (hl),a		; $4e7a
	inc l			; $4e7b
	ld a,(w1Link.xh)		; $4e7c
	ld (hl),a		; $4e7f
	ld hl,wMapleState		; $4e80
	set 7,(hl)		; $4e83
	jp partDelete		; $4e85
	dec hl			; $4e88
	rst $38			; $4e89
	ld bc,$3401		; $4e8a
	rst $38			; $4e8d
	ld bc,$2d01		; $4e8e
	rst $38			; $4e91
	ld bc,$2d01		; $4e92
	rst $38			; $4e95
	ld (bc),a		; $4e96
	ld (bc),a		; $4e97
	cpl			; $4e98
	rst $38			; $4e99
	ld bc,$2001		; $4e9a
	rst $38			; $4e9d
	dec b			; $4e9e
	ld a,(bc)		; $4e9f
	ld hl,$05ff		; $4ea0
	ld a,(bc)		; $4ea3
	ldi (hl),a		; $4ea4
	rst $38			; $4ea5
	dec b			; $4ea6
	ld a,(bc)		; $4ea7
	inc hl			; $4ea8
	rst $38			; $4ea9
	dec b			; $4eaa
	ld a,(bc)		; $4eab
	inc h			; $4eac
	rst $38			; $4ead
	dec b			; $4eae
	ld a,(bc)		; $4eaf
	inc bc			; $4eb0
	rst $38			; $4eb1
	inc b			; $4eb2
	ld ($2529),sp		; $4eb3
	inc b			; $4eb6
	ld ($2428),sp		; $4eb7
	inc bc			; $4eba
	inc b			; $4ebb
	jr z,_label_11_098	; $4ebc
	ld bc,$1e02		; $4ebe
	jp nz,$4f1a		; $4ec1
	add a			; $4ec4
	add c			; $4ec5
	ld hl,$4ed9		; $4ec6
	rst_addAToHl			; $4ec9
	ld e,$dd		; $4eca
	ld a,(de)		; $4ecc
	add (hl)		; $4ecd
	ld (de),a		; $4ece
	inc hl			; $4ecf
	dec e			; $4ed0
	ldi a,(hl)		; $4ed1
	ld (de),a		; $4ed2
	dec e			; $4ed3
	ld (de),a		; $4ed4
	ld a,(hl)		; $4ed5
	jp partSetAnimation		; $4ed6
	stop			; $4ed9
	ld (bc),a		; $4eda
	stop			; $4edb
	ld a,(bc)		; $4edc
	ld bc,$0800		; $4edd
	nop			; $4ee0
	nop			; $4ee1
_label_11_098:
	ld ($0000),sp		; $4ee2
	nop			; $4ee5
	ld (bc),a		; $4ee6
	rrca			; $4ee7
	ld (de),a		; $4ee8
	ld (bc),a		; $4ee9
	dec b			; $4eea
	inc d			; $4eeb
	inc bc			; $4eec
	ld b,$16		; $4eed
	ld bc,$1807		; $4eef
	ld bc,$1a08		; $4ef2
	nop			; $4ef5
	ld ($0410),sp		; $4ef6
	inc b			; $4ef9
	ld (bc),a		; $4efa
	dec b			; $4efb
	ld bc,$0506		; $4efc
	inc bc			; $4eff
	inc b			; $4f00
	nop			; $4f01
	ld (bc),a		; $4f02
	ld h,d			; $4f03
	ld l,$cb		; $4f04
	ld a,(hl)		; $4f06
	cp $f0			; $4f07
	jr c,_label_11_099	; $4f09
	xor a			; $4f0b
_label_11_099:
	cp $20			; $4f0c
	jr nc,_label_11_100	; $4f0e
	ld (hl),$20		; $4f10
	jr _label_11_101		; $4f12
_label_11_100:
	cp $78			; $4f14
	jr c,_label_11_101	; $4f16
	ld (hl),$78		; $4f18
_label_11_101:
	ld l,$cd		; $4f1a
	ld a,(hl)		; $4f1c
	cp $f0			; $4f1d
	jr c,_label_11_102	; $4f1f
	xor a			; $4f21
_label_11_102:
	cp $08			; $4f22
	jr nc,_label_11_103	; $4f24
	ld (hl),$08		; $4f26
	ret			; $4f28
_label_11_103:
	cp $98			; $4f29
	ret c			; $4f2b
	ld (hl),$98		; $4f2c
	ret			; $4f2e
	ld l,$0b		; $4f2f
	ld b,(hl)		; $4f31
	ld l,$0d		; $4f32
	ld c,(hl)		; $4f34
	push bc			; $4f35
	call objectGetRelativeAngle		; $4f36
	ld e,$c9		; $4f39
	ld (de),a		; $4f3b
	call objectApplySpeed		; $4f3c
	pop bc			; $4f3f
	ld h,d			; $4f40
	ld l,$cb		; $4f41
	ldi a,(hl)		; $4f43
	cp b			; $4f44
	ret nz			; $4f45
	inc l			; $4f46
	ld a,(hl)		; $4f47
	cp c			; $4f48
	ret			; $4f49
	inc a			; $4f4a
	rrca			; $4f4b
	ld a,(bc)		; $4f4c
	ld ($0506),sp		; $4f4d
	dec b			; $4f50
	dec b			; $4f51
	dec b			; $4f52
	dec b			; $4f53
	inc b			; $4f54
	inc bc			; $4f55
	ld (bc),a		; $4f56
.db $01 $00

;;
; @addr{4f59}
partCode17:
	jr z,_label_11_104	; $4f59
	ld e,$c2		; $4f5b
	ld a,(de)		; $4f5d
	add a			; $4f5e
	ld hl,$501e		; $4f5f
	rst_addDoubleIndex			; $4f62
	ld e,$ea		; $4f63
	ld a,(de)		; $4f65
	and $1f			; $4f66
	call checkFlag		; $4f68
	jr z,_label_11_104	; $4f6b
	call checkLinkVulnerable		; $4f6d
	jr nc,_label_11_104	; $4f70
	ld h,d			; $4f72
	ld l,$c4		; $4f73
	ld (hl),$02		; $4f75
	ld l,$e4		; $4f77
	res 7,(hl)		; $4f79
	ld l,$c2		; $4f7b
	ld a,(hl)		; $4f7d
	or a			; $4f7e
	jr z,_label_11_104	; $4f7f
	ld a,$2a		; $4f81
	call objectGetRelatedObject1Var		; $4f83
	ld (hl),$ff		; $4f86
_label_11_104:
	ld e,$c4		; $4f88
	ld a,(de)		; $4f8a
	rst_jumpTable			; $4f8b
.dw $4f92
.dw $4fab
.dw $4fbc
	ld a,$01		; $4f92
	ld (de),a		; $4f94
	ld a,$26		; $4f95
	call objectGetRelatedObject1Var		; $4f97
	ld e,$e6		; $4f9a
	ldi a,(hl)		; $4f9c
	ld (de),a		; $4f9d
	inc e			; $4f9e
	ld a,(hl)		; $4f9f
	ld (de),a		; $4fa0
	call objectTakePosition		; $4fa1
	ld e,$f0		; $4fa4
	ld l,$41		; $4fa6
	ld a,(hl)		; $4fa8
	ld (de),a		; $4fa9
	ret			; $4faa
	call $4fb2		; $4fab
	ret z			; $4fae
	jp partDelete		; $4faf
	ld a,$01		; $4fb2
	call objectGetRelatedObject1Var		; $4fb4
	ld e,$f0		; $4fb7
	ld a,(de)		; $4fb9
	cp (hl)			; $4fba
	ret			; $4fbb
	call $4fb2		; $4fbc
	jp nz,partDelete		; $4fbf
	ld e,$c5		; $4fc2
	ld a,(de)		; $4fc4
	rst_jumpTable			; $4fc5
.dw $4fcc
.dw $4fec
.dw $5003
	ld h,d			; $4fcc
	ld l,e			; $4fcd
	inc (hl)		; $4fce
	ld l,$d0		; $4fcf
	ld (hl),$28		; $4fd1
	ld a,$1a		; $4fd3
	call objectGetRelatedObject1Var		; $4fd5
	set 6,(hl)		; $4fd8
	ld e,$c2		; $4fda
	ld a,(de)		; $4fdc
	or a			; $4fdd
	ld a,$10		; $4fde
	call nz,objectGetAngleTowardLink		; $4fe0
	ld e,$c9		; $4fe3
	ld (de),a		; $4fe5
	ld bc,$fec0		; $4fe6
	jp objectSetSpeedZ		; $4fe9
	ld c,$18		; $4fec
	call objectUpdateSpeedZAndBounce		; $4fee
	jr z,_label_11_105	; $4ff1
	call objectApplySpeed		; $4ff3
	ld a,$00		; $4ff6
	call objectGetRelatedObject1Var		; $4ff8
	jp objectCopyPosition		; $4ffb
_label_11_105:
	ld e,$c5		; $4ffe
	ld a,$02		; $5000
	ld (de),a		; $5002
	ld c,$18		; $5003
	call objectUpdateSpeedZAndBounce		; $5005
	jr nc,_label_11_106	; $5008
	call $5010		; $500a
	jp partDelete		; $500d
_label_11_106:
	call objectCheckTileCollision_allowHoles		; $5010
	call nc,objectApplySpeed		; $5013
	ld a,$00		; $5016
	call objectGetRelatedObject1Var		; $5018
	jp objectCopyPosition		; $501b
	ld a,($ff00+$03)	; $501e
	nop			; $5020
	nop			; $5021
	ld a,($ff00+$03)	; $5022
	nop			; $5024
	nop			; $5025

;;
; @addr{5026}
partCode18:
	jr z,_label_11_107	; $5026
	ld e,$ea		; $5028
	ld a,(de)		; $502a
	cp $80			; $502b
	jp z,partDelete		; $502d
	ld h,d			; $5030
	ld l,$c4		; $5031
	ld a,(hl)		; $5033
	cp $02			; $5034
	jr nc,_label_11_107	; $5036
	ld (hl),$02		; $5038
_label_11_107:
	ld e,$c4		; $503a
	ld a,(de)		; $503c
	rst_jumpTable			; $503d
.dw $5046
.dw $5050
.dw $5066
.dw _partCommon_updateSpeedAndDeleteWhenCounter1Is0
	ld h,d			; $5046
	ld l,e			; $5047
	inc (hl)		; $5048
	ld l,$d0		; $5049
	ld (hl),$50		; $504b
	jp objectSetVisible81		; $504d
	call objectCheckWithinScreenBoundary		; $5050
	jp nc,partDelete		; $5053
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5056
	jr nc,_label_11_108	; $5059
	jp z,partDelete		; $505b
	ld e,$c4		; $505e
	ld a,$02		; $5060
	ld (de),a		; $5062
_label_11_108:
	jp objectApplySpeed		; $5063
	ld a,$03		; $5066
	ld (de),a		; $5068
	xor a			; $5069
	jp _partCommon_bounceWhenCollisionsEnabled		; $506a

;;
; @addr{506d}
partCode19:
partCode31:
	jp nz,partDelete		; $506d
	ld e,$c4		; $5070
	ld a,(de)		; $5072
	rst_jumpTable			; $5073
.dw $507a
.dw $5088
.dw $50a8
	ld h,d			; $507a
	ld l,e			; $507b
	inc (hl)		; $507c
	ld l,$c6		; $507d
	ld (hl),$08		; $507f
	ld l,$d0		; $5081
	ld (hl),$3c		; $5083
	jp objectSetVisible81		; $5085
	call _partCommon_decCounter1IfNonzero		; $5088
	ret nz			; $508b
	ld l,e			; $508c
	inc (hl)		; $508d
	ld l,$c2		; $508e
	bit 0,(hl)		; $5090
	jr z,_label_11_109	; $5092
	ldh a,(<hFFB2)	; $5094
	ld b,a			; $5096
	ldh a,(<hFFB3)	; $5097
	ld c,a			; $5099
	call objectGetRelativeAngle		; $509a
	ld e,$c9		; $509d
	ld (de),a		; $509f
	ret			; $50a0
_label_11_109:
	call objectGetAngleTowardEnemyTarget		; $50a1
	ld e,$c9		; $50a4
	ld (de),a		; $50a6
	ret			; $50a7
	ld a,(wFrameCounter)		; $50a8
	and $03			; $50ab
	jr nz,_label_11_110	; $50ad
	ld e,$dc		; $50af
	ld a,(de)		; $50b1
	xor $07			; $50b2
	ld (de),a		; $50b4
_label_11_110:
	call objectApplySpeed		; $50b5
	call objectCheckWithinScreenBoundary		; $50b8
	jp nc,partDelete		; $50bb
	jp partAnimate		; $50be

;;
; @addr{50c1}
partCode1a:
	jr z,_label_11_111	; $50c1
	ld e,$ea		; $50c3
	ld a,(de)		; $50c5
	cp $80			; $50c6
	jr z,_label_11_115	; $50c8
	jr _label_11_116		; $50ca
_label_11_111:
	ld e,$c2		; $50cc
	ld a,(de)		; $50ce
	rst_jumpTable			; $50cf
.dw $50d4
.dw $5103
	ld e,$c4		; $50d4
	ld a,(de)		; $50d6
	rst_jumpTable			; $50d7
.dw $50de
.dw $50fa
.dw _partCommon_updateSpeedAndDeleteWhenCounter1Is0
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
_label_11_112:
	call _partCommon_checkTileCollisionOrOutOfBounds		; $50fa
	jr nc,_label_11_114	; $50fd
	jr z,_label_11_115	; $50ff
	jr _label_11_116		; $5101
	ld e,$c4		; $5103
	ld a,(de)		; $5105
	rst_jumpTable			; $5106
.dw $510f
.dw $5126
	ld a,($cf50)		; $510b
	ld b,b			; $510e
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
	call _partCommon_decCounter1IfNonzero		; $5126
	jr nz,_label_11_113	; $5129
	ld l,e			; $512b
	inc (hl)		; $512c
	jr _label_11_112		; $512d
_label_11_113:
	call _partCommon_checkOutOfBounds		; $512f
	jr z,_label_11_115	; $5132
_label_11_114:
	jp objectApplySpeed		; $5134
_label_11_115:
	jp partDelete		; $5137
_label_11_116:
	ld e,$c2		; $513a
	ld a,(de)		; $513c
	or a			; $513d
	ld a,$02		; $513e
	jr z,_label_11_117	; $5140
	ld a,$03		; $5142
_label_11_117:
	ld e,$c4		; $5144
	ld (de),a		; $5146
	ld a,$04		; $5147
	jp _partCommon_bounceWhenCollisionsEnabled		; $5149

;;
; @addr{514c}
partCode1b:
	jr z,_label_11_118	; $514c
	ld e,$ea		; $514e
	ld a,(de)		; $5150
	res 7,a			; $5151
	cp $04			; $5153
	jp c,partDelete		; $5155
_label_11_118:
	ld e,$c4		; $5158
	ld a,(de)		; $515a
	or a			; $515b
	jr z,_label_11_119	; $515c
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
_label_11_119:
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

;;
; @addr{5190}
partCode1c:
	jr z,_label_11_120	; $5190
	ld e,$ea		; $5192
	ld a,(de)		; $5194
	cp $80			; $5195
	jr z,_label_11_121	; $5197
	jr _label_11_123		; $5199
_label_11_120:
	ld e,$c4		; $519b
	ld a,(de)		; $519d
	rst_jumpTable			; $519e
.dw $51a5
.dw $51b5
.dw $51c6
	ld h,d			; $51a5
	ld l,e			; $51a6
	inc (hl)		; $51a7
	ld l,$d0		; $51a8
	ld (hl),$3c		; $51aa
	call objectGetAngleTowardEnemyTarget		; $51ac
	ld e,$c9		; $51af
	ld (de),a		; $51b1
	jp objectSetVisible81		; $51b2
	call _partCommon_checkTileCollisionOrOutOfBounds		; $51b5
	jr c,_label_11_122	; $51b8
	call objectApplySpeed		; $51ba
	call objectCheckWithinScreenBoundary		; $51bd
	jp c,partAnimate		; $51c0
_label_11_121:
	jp partDelete		; $51c3
	call _partCommon_decCounter1IfNonzero		; $51c6
	jr z,_label_11_121	; $51c9
	ld c,$0e		; $51cb
	call objectUpdateSpeedZ_paramC		; $51cd
	call objectApplySpeed		; $51d0
	ld a,(wFrameCounter)		; $51d3
	rrca			; $51d6
	ret c			; $51d7
	jp partAnimate		; $51d8
_label_11_122:
	jr z,_label_11_121	; $51db
_label_11_123:
	ld e,$c4		; $51dd
	ld a,$02		; $51df
	ld (de),a		; $51e1
	xor a			; $51e2
	jp _partCommon_bounceWhenCollisionsEnabled		; $51e3

;;
; @addr{51e6}
partCode1d:
	jr z,_label_11_125	; $51e6
	ld e,$ea		; $51e8
	ld a,(de)		; $51ea
	cp $80			; $51eb
	jr z,_label_11_125	; $51ed
	cp $8a			; $51ef
	jr z,_label_11_125	; $51f1
	ld a,$2b		; $51f3
	call objectGetRelatedObject1Var		; $51f5
	ld a,(hl)		; $51f8
	or a			; $51f9
	jr nz,_label_11_124	; $51fa
	ld e,$eb		; $51fc
	ld a,(de)		; $51fe
	ld (hl),a		; $51ff
_label_11_124:
	ld e,$ec		; $5200
	ld a,(de)		; $5202
	inc l			; $5203
	ldi (hl),a		; $5204
	ld e,$ed		; $5205
	ld a,(de)		; $5207
	ld (hl),a		; $5208
_label_11_125:
	ld e,$c4		; $5209
	ld a,(de)		; $520b
	or a			; $520c
	jr z,_label_11_127	; $520d
	ld h,d			; $520f
	ld l,$e4		; $5210
	set 7,(hl)		; $5212
	call $5273		; $5214
	jp nz,partDelete		; $5217
_label_11_126:
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
	ld hl,$524d		; $522e
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
	ld hl,$525d		; $5241
	rst_addAToHl			; $5244
	ld e,$e6		; $5245
	ldi a,(hl)		; $5247
	ld (de),a		; $5248
	inc e			; $5249
	ld a,(hl)		; $524a
	ld (de),a		; $524b
	ret			; $524c
	ld hl,sp+$04		; $524d
	or $04			; $524f
	inc b			; $5251
	rlca			; $5252
	inc b			; $5253
	add hl,bc		; $5254
	rlca			; $5255
.DB $fc				; $5256
	add hl,bc		; $5257
.DB $fc				; $5258
	inc b			; $5259
	ld sp,hl		; $525a
	inc b			; $525b
	rst $30			; $525c
	dec b			; $525d
	ld (bc),a		; $525e
	ld (bc),a		; $525f
	dec b			; $5260
_label_11_127:
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
	jr _label_11_126		; $5271
	ld a,$01		; $5273
	call objectGetRelatedObject1Var		; $5275
	ld e,$f0		; $5278
	ld a,(de)		; $527a
	cp (hl)			; $527b
	ret nz			; $527c
	ld l,$b0		; $527d
	bit 0,(hl)		; $527f
	jr nz,_label_11_128	; $5281
	ld l,$a9		; $5283
	ld a,(hl)		; $5285
	or a			; $5286
	jr z,_label_11_128	; $5287
	ld l,$ae		; $5289
	ld a,(hl)		; $528b
	or a			; $528c
	jr nz,_label_11_128	; $528d
	ld l,$bf		; $528f
	bit 1,(hl)		; $5291
	ret z			; $5293
_label_11_128:
	ld e,$e4		; $5294
	ld a,(de)		; $5296
	res 7,a			; $5297
	ld (de),a		; $5299
	xor a			; $529a
	ret			; $529b

;;
; @addr{529c}
partCode1e:
	jr z,_label_11_129	; $529c
	ld e,$ea		; $529e
	ld a,(de)		; $52a0
	cp $80			; $52a1
	jr z,_label_11_129	; $52a3
	call $52fd		; $52a5
	ld h,d			; $52a8
	ld l,$c4		; $52a9
	ld (hl),$03		; $52ab
	ld l,$e4		; $52ad
	res 7,(hl)		; $52af
_label_11_129:
	ld e,$c4		; $52b1
	ld a,(de)		; $52b3
	rst_jumpTable			; $52b4
.dw $52c1
.dw $52d4
.dw $52db
.dw $52ec
.dw _partCommon_updateSpeedAndDeleteWhenCounter1Is0
.dw $52f1
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
	call _partCommon_decCounter1IfNonzero		; $52d4
	jr nz,_label_11_131	; $52d7
	ld l,e			; $52d9
	inc (hl)		; $52da
_label_11_130:
	call _partCommon_checkTileCollisionOrOutOfBounds		; $52db
	jr nc,_label_11_131	; $52de
	jr nz,_label_11_133	; $52e0
	jr _label_11_132		; $52e2
_label_11_131:
	call objectCheckWithinScreenBoundary		; $52e4
	jp c,objectApplySpeed		; $52e7
	jr _label_11_132		; $52ea
	call $5336		; $52ec
	jr _label_11_130		; $52ef
_label_11_132:
	jp partDelete		; $52f1
_label_11_133:
	ld e,$c4		; $52f4
	ld a,$04		; $52f6
	ld (de),a		; $52f8
	xor a			; $52f9
	jp _partCommon_bounceWhenCollisionsEnabled		; $52fa
	ld e,$c9		; $52fd
	ld a,(de)		; $52ff
	bit 2,a			; $5300
	jr nz,_label_11_134	; $5302
	sub $08			; $5304
	rrca			; $5306
	ld b,a			; $5307
	ld a,(w1Link.direction)		; $5308
	add b			; $530b
	ld hl,$532a		; $530c
	rst_addAToHl			; $530f
	ld a,(hl)		; $5310
	ld (de),a		; $5311
	ret			; $5312
_label_11_134:
	sub $0c			; $5313
	rrca			; $5315
	ld b,a			; $5316
	ld a,(w1Link.direction)		; $5317
	add b			; $531a
	ld hl,$5322		; $531b
	rst_addAToHl			; $531e
	ld a,(hl)		; $531f
	ld (de),a		; $5320
	ret			; $5321
	inc b			; $5322
	ld ($1410),sp		; $5323
	inc e			; $5326
	inc c			; $5327
	stop			; $5328
	jr _label_11_135		; $5329
	ld ($180c),sp		; $532b
	nop			; $532e
_label_11_135:
	inc c			; $532f
	stop			; $5330
	inc d			; $5331
	inc e			; $5332
	ld ($1814),sp		; $5333
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

;;
; @addr{5353}
partCode1f:
	jr nz,_label_11_136	; $5353
	ld e,$c4		; $5355
	ld a,(de)		; $5357
	or a			; $5358
	jr z,_label_11_137	; $5359
	call objectCheckWithinScreenBoundary		; $535b
	jr nc,_label_11_136	; $535e
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5360
	jp nc,objectApplySpeed		; $5363
_label_11_136:
	jp partDelete		; $5366
_label_11_137:
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

;;
; @addr{537c}
partCode20:
	ld e,$c4		; $537c
	ld a,(de)		; $537e
	or a			; $537f
	jr z,_label_11_138	; $5380
	call _partCommon_decCounter1IfNonzero		; $5382
	jp z,partDelete		; $5385
	jp partAnimate		; $5388
_label_11_138:
	ld h,d			; $538b
	ld l,e			; $538c
	inc (hl)		; $538d
	ld l,$c6		; $538e
	ld (hl),$b4		; $5390
	jp objectSetVisible82		; $5392

;;
; @addr{5395}
partCode21:
	jr z,_label_11_139	; $5395
	ld e,$ea		; $5397
	ld a,(de)		; $5399
	res 7,a			; $539a
	sub $01			; $539c
	cp $03			; $539e
	jr nc,_label_11_139	; $53a0
	ld e,$c4		; $53a2
	ld a,$02		; $53a4
	ld (de),a		; $53a6
_label_11_139:
	ld e,$d7		; $53a7
	ld a,(de)		; $53a9
	inc a			; $53aa
	jr z,_label_11_142	; $53ab
	ld e,$c4		; $53ad
	ld a,(de)		; $53af
	rst_jumpTable			; $53b0
.dw $53b7
.dw $53c8
.dw $53db
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
	call objectCheckSimpleCollision		; $53c8
	jr nz,_label_11_143	; $53cb
	call _partCommon_decCounter1IfNonzero		; $53cd
	jr z,_label_11_143	; $53d0
	call $542a		; $53d2
_label_11_140:
	call objectApplySpeed		; $53d5
_label_11_141:
	jp partAnimate		; $53d8
	call $541a		; $53db
	call $53f5		; $53de
	jr nc,_label_11_140	; $53e1
	ld a,$18		; $53e3
	call objectGetRelatedObject1Var		; $53e5
	xor a			; $53e8
	ldi (hl),a		; $53e9
	ld (hl),a		; $53ea
_label_11_142:
	jp partDelete		; $53eb
_label_11_143:
	ld e,$c4		; $53ee
	ld a,$02		; $53f0
	ld (de),a		; $53f2
	jr _label_11_141		; $53f3
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
	call _partCommon_decCounter1IfNonzero		; $549c
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

;;
; @addr{54de}
partCode23:
	ld e,$c2		; $54de
	ld a,(de)		; $54e0
	ld e,$c4		; $54e1
_label_11_147:
	rst_jumpTable			; $54e3
.dw $54ea
.dw $54f9
.dw $5515
	ld a,(de)		; $54ea
	or a			; $54eb
	jr z,_label_11_148	; $54ec
	call _partCommon_decCounter1IfNonzero		; $54ee
	ret nz			; $54f1
	ld (hl),$78		; $54f2
	jr _label_11_149		; $54f4
_label_11_148:
	inc a			; $54f6
	ld (de),a		; $54f7
	ret			; $54f8
	ld a,(de)		; $54f9
	or a			; $54fa
	jr z,_label_11_148	; $54fb
	call _partCommon_decCounter1IfNonzero		; $54fd
	ret nz			; $5500
	call $553f		; $5501
_label_11_149:
	call getFreePartSlot		; $5504
	ret nz			; $5507
	ld (hl),$23		; $5508
	inc l			; $550a
	ld (hl),$02		; $550b
	ld l,$f0		; $550d
	ld e,l			; $550f
	ld a,(de)		; $5510
	ld (hl),a		; $5511
	jp objectCopyPosition		; $5512
	ld a,(de)		; $5515
	or a			; $5516
	jr z,_label_11_150	; $5517
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
_label_11_150:
	ld h,d			; $5535
	ld l,e			; $5536
	inc (hl)		; $5537
	ld l,$e4		; $5538
	set 7,(hl)		; $553a
	jp objectSetVisible81		; $553c
	ld e,$87		; $553f
	ld a,(de)		; $5541
	inc a			; $5542
	and $03			; $5543
	ld (de),a		; $5545
	ld hl,$554f		; $5546
	rst_addAToHl			; $5549
	ld e,$c6		; $554a
	ld a,(hl)		; $554c
	ld (de),a		; $554d
	ret			; $554e
	ld a,b			; $554f
	ld a,b			; $5550
	ld e,$1e		; $5551

;;
; @addr{5553}
partCode27:
	ld e,$c4		; $5553
	ld a,(de)		; $5555
	rst_jumpTable			; $5556
.dw $555d
.dw $5580
.dw $558e
	ld a,$01		; $555d
	ld (de),a		; $555f
	call getRandomNumber_noPreserveVars		; $5560
	ld e,$f0		; $5563
	and $06			; $5565
	ld (de),a		; $5567
	ld h,d			; $5568
	ld l,$cf		; $5569
	ld (hl),$c0		; $556b
	ld l,$d7		; $556d
	ld a,(hl)		; $556f
	or a			; $5570
	ret z			; $5571
	ld l,$c6		; $5572
	ld (hl),$1e		; $5574
	ld l,$cb		; $5576
	ldh a,(<hEnemyTargetY)	; $5578
	ldi (hl),a		; $557a
	inc l			; $557b
	ldh a,(<hEnemyTargetX)	; $557c
	ld (hl),a		; $557e
	ret			; $557f
	call _partCommon_decCounter1IfNonzero		; $5580
	ret nz			; $5583
	ld l,e			; $5584
	inc (hl)		; $5585
	ld a,SND_LIGHTNING		; $5586
	call playSound		; $5588
	jp objectSetVisible81		; $558b
	call partAnimate		; $558e
	ld e,$e1		; $5591
	ld a,(de)		; $5593
	inc a			; $5594
	jp z,partDelete		; $5595
	call $55a6		; $5598
	ld e,$c3		; $559b
	ld a,(de)		; $559d
	or a			; $559e
	ret z			; $559f
	ld a,$ff		; $55a0
	ld ($cfd2),a		; $55a2
	ret			; $55a5
	ld e,$e1		; $55a6
	ld a,(de)		; $55a8
	bit 7,a			; $55a9
	call nz,$55e7		; $55ab
	ld e,$e1		; $55ae
	ld a,(de)		; $55b0
	and $0e			; $55b1
	ld hl,$55da		; $55b3
	rst_addAToHl			; $55b6
	ld e,$e6		; $55b7
	ldi a,(hl)		; $55b9
	ld (de),a		; $55ba
	inc e			; $55bb
	ld a,(hl)		; $55bc
	ld (de),a		; $55bd
	ld e,$e1		; $55be
	ld a,(de)		; $55c0
	and $70			; $55c1
	swap a			; $55c3
	ld hl,$55e2		; $55c5
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
	ld (bc),a		; $55da
	ld (bc),a		; $55db
	inc b			; $55dc
	ld b,$05		; $55dd
	add hl,bc		; $55df
	inc b			; $55e0
	dec b			; $55e1
	ret nz			; $55e2
	ret nc			; $55e3
	ld ($ff00+$f0),a	; $55e4
	nop			; $55e6
	res 7,a			; $55e7
	ld (de),a		; $55e9
	and $0e			; $55ea
	sub $02			; $55ec
	ld b,a			; $55ee
	ld e,$f0		; $55ef
	ld a,(de)		; $55f1
	add b			; $55f2
	ld hl,$5603		; $55f3
	rst_addAToHl			; $55f6
	ldi a,(hl)		; $55f7
	ld c,(hl)		; $55f8
	ld b,a			; $55f9
	call getFreeInteractionSlot		; $55fa
	ret nz			; $55fd
	ld (hl),$08		; $55fe
	jp objectCopyPositionWithOffset		; $5600
	ld (bc),a		; $5603
	ld b,$00		; $5604
	ei			; $5606
	rst $38			; $5607
	rlca			; $5608
.DB $fd				; $5609
.DB $fc				; $560a
	nop			; $560b
	dec b			; $560c

;;
; @addr{560d}
partCode28:
	jr z,_label_11_151	; $560d
	cp $02			; $560f
	jp z,$569c		; $5611
	ld e,$c4		; $5614
	ld a,$02		; $5616
	ld (de),a		; $5618
_label_11_151:
	ld e,$c4		; $5619
	ld a,(de)		; $561b
	rst_jumpTable			; $561c
.dw $5623
.dw $5638
.dw $566a
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
	call _partCommon_decCounter1IfNonzero		; $5638
	jr z,_label_11_152	; $563b
	call $56cd		; $563d
	jp c,objectApplySpeed		; $5640
_label_11_152:
	call getRandomNumber_noPreserveVars		; $5643
	and $3e			; $5646
	add $08			; $5648
	ld e,$c6		; $564a
	ld (de),a		; $564c
	call getRandomNumber_noPreserveVars		; $564d
	and $03			; $5650
	ld hl,$5666		; $5652
	rst_addAToHl			; $5655
	ld e,$d0		; $5656
	ld a,(hl)		; $5658
	ld (de),a		; $5659
	call getRandomNumber_noPreserveVars		; $565a
	and $1e			; $565d
	ld h,d			; $565f
	ld l,$c9		; $5660
	ld (hl),a		; $5662
	jp $56b6		; $5663
	ld a,(bc)		; $5666
	inc d			; $5667
	ld e,$28		; $5668
	ld e,$c5		; $566a
	ld a,(de)		; $566c
	or a			; $566d
	jr nz,_label_11_154	; $566e
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
_label_11_154:
	call objectCheckCollidedWithLink		; $5683
	jp c,$569c		; $5686
	ld a,$00		; $5689
	call objectGetRelatedObject1Var		; $568b
	ldi a,(hl)		; $568e
	or a			; $568f
	jr z,_label_11_155	; $5690
	ld e,$f0		; $5692
	ld a,(de)		; $5694
	cp (hl)			; $5695
	jp z,objectTakePosition		; $5696
_label_11_155:
	jp partDelete		; $5699
	ld a,$26		; $569c
	call cpActiveRing		; $569e
	ld c,$18		; $56a1
	jr z,_label_11_156	; $56a3
	ld a,$25		; $56a5
	call cpActiveRing		; $56a7
	jr nz,_label_11_157	; $56aa
_label_11_156:
	ld c,$30		; $56ac
_label_11_157:
	ld a,$29		; $56ae
	call giveTreasure		; $56b0
	jp partDelete		; $56b3
	ld e,$c9		; $56b6
	ld a,(de)		; $56b8
	and $0f			; $56b9
	ret z			; $56bb
	ld a,(de)		; $56bc
	cp $10			; $56bd
	ld a,$00		; $56bf
	jr nc,_label_11_158	; $56c1
	inc a			; $56c3
_label_11_158:
	ld h,d			; $56c4
	ld l,$c8		; $56c5
	cp (hl)			; $56c7
	ret z			; $56c8
	ld (hl),a		; $56c9
	jp partSetAnimation		; $56ca
	ld e,$c9		; $56cd
	ld a,(de)		; $56cf
	and $07			; $56d0
	ld a,(de)		; $56d2
	jr z,_label_11_159	; $56d3
	and $18			; $56d5
	add $04			; $56d7
_label_11_159:
	and $1c			; $56d9
	rrca			; $56db
	ld hl,$56f5		; $56dc
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
.DB $fc				; $56f5
	nop			; $56f6
.DB $fc				; $56f7
	inc b			; $56f8
	nop			; $56f9
	inc b			; $56fa
	inc b			; $56fb
	inc b			; $56fc
	inc b			; $56fd
	nop			; $56fe
	inc b			; $56ff
.DB $fc				; $5700
	nop			; $5701
.DB $fc				; $5702
.DB $fc				; $5703
.DB $fc				; $5704
;;
; @addr{5705}
partCode29:
	jr z,_label_11_160	; $5705
	ld e,$ea		; $5707
	ld a,(de)		; $5709
	cp $83			; $570a
	jp z,partDelete		; $570c
_label_11_160:
	ld e,$c4		; $570f
	ld a,(de)		; $5711
	rst_jumpTable			; $5712
.dw $5719
.dw $5747
.dw $574e
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
	ld hl,$5737		; $572f
	rst_addAToHl			; $5732
	ld a,(hl)		; $5733
	jp partSetAnimation		; $5734
	nop			; $5737
	nop			; $5738
	ld bc,$0202		; $5739
	ld (bc),a		; $573c
	inc bc			; $573d
	inc b			; $573e
	inc b			; $573f
	inc b			; $5740
	dec b			; $5741
	ld b,$06		; $5742
	ld b,$07		; $5744
	nop			; $5746
	call _partCommon_decCounter1IfNonzero		; $5747
	jr nz,_label_11_161	; $574a
	ld l,e			; $574c
	inc (hl)		; $574d
	call $5758		; $574e
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5751
	jp c,partDelete		; $5754
	ret			; $5757
_label_11_161:
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

;;
; @addr{58f3}
partCode30:
	ld e,$c4		; $58f3
	ld a,(de)		; $58f5
	or a			; $58f6
	jr nz,_label_11_170	; $58f7
	ld h,d			; $58f9
	ld l,e			; $58fa
	inc (hl)		; $58fb
	ld l,$c6		; $58fc
	ld (hl),$03		; $58fe
	call objectSetVisible81		; $5900
_label_11_170:
	ldh a,(<hEnemyTargetY)	; $5903
	ld b,a			; $5905
	ldh a,(<hEnemyTargetX)	; $5906
	ld c,a			; $5908
	ld a,$20		; $5909
	ld e,$c9		; $590b
	call objectSetPositionInCircleArc		; $590d
	call _partCommon_decCounter1IfNonzero		; $5910
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
	call _partCommon_decCounter1IfNonzero		; $5996
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
	call _partCommon_checkOutOfBounds		; $59bb
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

;;
; @addr{59ee}
partCode4c:
	jr z,_label_11_178	; $59ee
	ld e,$ea		; $59f0
	ld a,(de)		; $59f2
	cp $80			; $59f3
	jp nz,partDelete		; $59f5
_label_11_178:
	ld e,$c2		; $59f8
	ld a,(de)		; $59fa
	or a			; $59fb
	ld e,$c4		; $59fc
	ld a,(de)		; $59fe
	jr z,_label_11_180	; $59ff
	or a			; $5a01
	jr z,_label_11_179	; $5a02
	call partAnimate		; $5a04
	call objectApplySpeed		; $5a07
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5a0a
	ret nz			; $5a0d
	jp partDelete		; $5a0e
_label_11_179:
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
_label_11_180:
	rst_jumpTable			; $5a31
.dw $5a38
.dw $5a46
.dw $5a54
	ld h,d			; $5a38
	ld l,e			; $5a39
	inc (hl)		; $5a3a
	ld l,$d0		; $5a3b
	ld (hl),$46		; $5a3d
	ld l,$c6		; $5a3f
	ld (hl),$1e		; $5a41
	jp objectSetVisible82		; $5a43
	call _partCommon_decCounter1IfNonzero		; $5a46
	jp nz,partAnimate		; $5a49
	ld l,e			; $5a4c
	inc (hl)		; $5a4d
	call objectGetAngleTowardEnemyTarget		; $5a4e
	ld e,$c9		; $5a51
	ld (de),a		; $5a53
	call partAnimate		; $5a54
	call objectApplySpeed		; $5a57
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5a5a
	ret nc			; $5a5d
	call objectGetAngleTowardEnemyTarget		; $5a5e
	sub $02			; $5a61
	and $1f			; $5a63
	ld c,a			; $5a65
	ld b,$03		; $5a66
_label_11_181:
	call getFreePartSlot		; $5a68
	jr nz,_label_11_182	; $5a6b
	ld (hl),$4c		; $5a6d
	inc l			; $5a6f
	inc (hl)		; $5a70
	ld l,$c9		; $5a71
	ld (hl),c		; $5a73
	call objectCopyPosition		; $5a74
_label_11_182:
	ld a,c			; $5a77
	add $02			; $5a78
	and $1f			; $5a7a
	ld c,a			; $5a7c
	dec b			; $5a7d
	jr nz,_label_11_181	; $5a7e
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
	call _partCommon_decCounter1IfNonzero		; $5ab5
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

;;
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
.dw $5af6
.dw $5b08
.dw $5b1e
	ld a,$01		; $5af6
	ld (de),a		; $5af8
	pop hl			; $5af9
	call objectTakePosition		; $5afa
	ld l,$b2		; $5afd
	ld a,(hl)		; $5aff
	or a			; $5b00
	jr z,_label_11_187	; $5b01
	ld a,$01		; $5b03
_label_11_187:
	jp partSetAnimation		; $5b05
	call partAnimate		; $5b08
	ld e,$e1		; $5b0b
	ld a,(de)		; $5b0d
	inc a			; $5b0e
	jr nz,_label_11_188	; $5b0f
	ld h,d			; $5b11
	ld l,$c4		; $5b12
	inc (hl)		; $5b14
	ld l,$e6		; $5b15
	ld a,$07		; $5b17
	ldi (hl),a		; $5b19
	ld (hl),a		; $5b1a
	call objectSetInvisible		; $5b1b
	pop hl			; $5b1e
	inc l			; $5b1f
	ld a,(hl)		; $5b20
	or a			; $5b21
	jp z,partDelete		; $5b22
	ld bc,$2000		; $5b25
	jp objectTakePositionWithOffset		; $5b28
_label_11_188:
	ld h,d			; $5b2b
	ld l,e			; $5b2c
	bit 7,(hl)		; $5b2d
	jr z,_label_11_189	; $5b2f
	res 7,(hl)		; $5b31
	call objectSetVisible82		; $5b33
	ld a,SND_BIGSWORD		; $5b36
	call playSound		; $5b38
	ld h,d			; $5b3b
	ld l,$e1		; $5b3c
_label_11_189:
	ld a,(hl)		; $5b3e
	ld hl,$5b5b		; $5b3f
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
	jr z,_label_11_190	; $5b52
	ld a,c			; $5b54
	cpl			; $5b55
	inc a			; $5b56
	ld c,a			; $5b57
_label_11_190:
	jp objectTakePositionWithOffset		; $5b58
	rlca			; $5b5b
	rlca			; $5b5c
	ret c			; $5b5d
	pop af			; $5b5e
	dec bc			; $5b5f
	rlca			; $5b60
	rst $20			; $5b61
	ld a,(de)		; $5b62
	jr nz,$0c		; $5b63
	rst $30			; $5b65
	add hl,de		; $5b66

;;
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
.dw $5b7e
.dw $5be2
.dw $5b9e
	ld a,(de)		; $5b7e
	or a			; $5b7f
	jr nz,_label_11_191	; $5b80
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
_label_11_191:
	call _partCommon_decCounter1IfNonzero		; $5b96
	jp z,partDelete		; $5b99
	jr _label_11_192		; $5b9c
	ld a,(de)		; $5b9e
	or a			; $5b9f
	jr z,_label_11_193	; $5ba0
	ld e,$e1		; $5ba2
	ld a,(de)		; $5ba4
	rlca			; $5ba5
	jp c,partDelete		; $5ba6
_label_11_192:
	ld e,$da		; $5ba9
	ld a,(de)		; $5bab
	xor $80			; $5bac
	ld (de),a		; $5bae
	jp partAnimate		; $5baf
_label_11_193:
	ld h,d			; $5bb2
	ld l,e			; $5bb3
	inc (hl)		; $5bb4
	ld l,$e4		; $5bb5
	set 7,(hl)		; $5bb7
	ld l,$c9		; $5bb9
	ld a,(hl)		; $5bbb
	ld b,$01		; $5bbc
	cp $0c			; $5bbe
	jr c,_label_11_194	; $5bc0
	inc b			; $5bc2
	cp $19			; $5bc3
	jr c,_label_11_194	; $5bc5
	inc b			; $5bc7
_label_11_194:
	ld a,b			; $5bc8
	dec a			; $5bc9
	and $01			; $5bca
	ld hl,$5bde		; $5bcc
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
	ld ($0a0a),sp		; $5bde
	ld a,(bc)		; $5be1
	ld a,(de)		; $5be2
	rst_jumpTable			; $5be3
.dw $5bea
.dw $5bff
.dw $5c2a
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
	call _partCommon_decCounter1IfNonzero		; $5bff
	jr nz,_label_11_197	; $5c02
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
	call _partCommon_checkTileCollisionOrOutOfBounds		; $5c2a
	jr nc,_label_11_195	; $5c2d
	ld b,$56		; $5c2f
	call objectCreateInteractionWithSubid00		; $5c31
	ld a,$3c		; $5c34
	call z,setScreenShakeCounter		; $5c36
	jp partDelete		; $5c39
_label_11_195:
	call _partCommon_decCounter1IfNonzero		; $5c3c
	ld a,(hl)		; $5c3f
	and $07			; $5c40
	jr nz,_label_11_196	; $5c42
	call getFreePartSlot		; $5c44
	jr nz,_label_11_196	; $5c47
	ld (hl),$51		; $5c49
	inc l			; $5c4b
	ld (hl),$02		; $5c4c
	ld l,$c9		; $5c4e
	ld e,l			; $5c50
	ld a,(de)		; $5c51
	ld (hl),a		; $5c52
	call objectCopyPosition		; $5c53
_label_11_196:
	call objectApplyComponentSpeed		; $5c56
_label_11_197:
	jp partAnimate		; $5c59

;;
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
.dw $5c73
.dw $5ca2
.dw $5d46
	ld a,(de)		; $5c73
	rst_jumpTable			; $5c74
.dw $5c7b
.dw $5c85
.dw $5c96
	ld h,d			; $5c7b
	ld l,e			; $5c7c
	inc (hl)		; $5c7d
	ld l,$c6		; $5c7e
	ld (hl),$0a		; $5c80
	jp objectSetVisible82		; $5c82
	call _partCommon_decCounter1IfNonzero		; $5c85
	jr nz,_label_11_198	; $5c88
	ld l,e			; $5c8a
	inc (hl)		; $5c8b
	ld a,SND_BEAM		; $5c8c
	call playSound		; $5c8e
	ld a,$02		; $5c91
	call partSetAnimation		; $5c93
	call _partCommon_checkOutOfBounds		; $5c96
	jp z,partDelete		; $5c99
	call objectApplySpeed		; $5c9c
_label_11_198:
	jp partAnimate		; $5c9f
	ld a,(de)		; $5ca2
	rst_jumpTable			; $5ca3
.dw $5cac
.dw $5ce0
.dw $5d11
.dw $5c96
	ld h,d			; $5cac
	ld l,$d0		; $5cad
	ld (hl),$50		; $5caf
	ld l,e			; $5cb1
	call objectSetVisible82		; $5cb2
	ld e,$c3		; $5cb5
	ld a,(de)		; $5cb7
	or a			; $5cb8
	jr z,_label_11_199	; $5cb9
	ld (hl),$03		; $5cbb
	ld l,$e6		; $5cbd
	ld a,$02		; $5cbf
	ldi (hl),a		; $5cc1
	ld (hl),a		; $5cc2
	ret			; $5cc3
_label_11_199:
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
	call _partCommon_decCounter1IfNonzero		; $5ce0
	jr z,_label_11_201	; $5ce3
	ld a,(hl)		; $5ce5
	rrca			; $5ce6
	ld e,$c9		; $5ce7
	jr c,_label_11_200	; $5ce9
	ld a,(de)		; $5ceb
	inc a			; $5cec
	and $1f			; $5ced
	ld (de),a		; $5cef
_label_11_200:
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
	jr _label_11_202		; $5d00
_label_11_201:
	ld (hl),$0a		; $5d02
	ld l,e			; $5d04
	inc (hl)		; $5d05
	ld a,SND_VERAN_PROJECTILE		; $5d06
	call playSound		; $5d08
	call objectSetVisible82		; $5d0b
_label_11_202:
	jp partAnimate		; $5d0e
	call _partCommon_decCounter1IfNonzero		; $5d11
	jr z,_label_11_203	; $5d14
	call objectApplySpeed		; $5d16
	jr _label_11_202		; $5d19
_label_11_203:
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
	call $5d31		; $5d2c
	ld b,$03		; $5d2f
	call getFreePartSlot		; $5d31
	ret nz			; $5d34
	ld (hl),$52		; $5d35
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
	ld a,(de)		; $5d46
	rst_jumpTable			; $5d47
.dw $5d50
.dw $5d5a
.dw $5d6e
.dw $5c96
	ld h,d			; $5d50
	ld l,e			; $5d51
	inc (hl)		; $5d52
	ld l,$c6		; $5d53
	ld (hl),$0f		; $5d55
	jp objectSetVisible82		; $5d57
	call _partCommon_decCounter1IfNonzero		; $5d5a
	jp nz,partAnimate		; $5d5d
	ld (hl),$0f		; $5d60
	ld l,e			; $5d62
	inc (hl)		; $5d63
	ld a,SND_VERAN_FAIRY_ATTACK		; $5d64
	call playSound		; $5d66
	ld a,$01		; $5d69
	jp partSetAnimation		; $5d6b
	call _partCommon_decCounter1IfNonzero		; $5d6e
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

;;
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
	call $5e1a		; $5db3
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
func_11_5df4:
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

	ld h,d			; $5e1a
	ld l,$f2		; $5e1b
	ldd a,(hl)		; $5e1d
	or a			; $5e1e
	jr nz,_label_11_211	; $5e1f
	ld e,$c3		; $5e21
	ld a,(de)		; $5e23
	add a			; $5e24
	add a			; $5e25
	ld e,$c8		; $5e26
	ld (de),a		; $5e28
	ld c,(hl)		; $5e29
	dec l			; $5e2a
	ld b,(hl)		; $5e2b
	ld a,$38		; $5e2c
	jp objectSetPositionInCircleArc		; $5e2e
_label_11_211:
	ld e,$cd		; $5e31
	ldd a,(hl)		; $5e33
	ld (de),a		; $5e34
	ld e,$cb		; $5e35
	ld a,(hl)		; $5e37
	ld (de),a		; $5e38
	ret			; $5e39
_label_11_212:
	ld d,$d0		; $5e3a
	ld a,d			; $5e3c
_label_11_213:
	ldh (<hActiveObject),a	; $5e3d
	ld e,$c0		; $5e3f
	ld a,(de)		; $5e41
	or a			; $5e42
	jr z,_label_11_215	; $5e43
	rlca			; $5e45
	jr c,_label_11_214	; $5e46
	ld e,$c4		; $5e48
	ld a,(de)		; $5e4a
	or a			; $5e4b
	jr nz,_label_11_215	; $5e4c
_label_11_214:
	call _func_11_5e8a		; $5e4e
_label_11_215:
	inc d			; $5e51
	ld a,d			; $5e52
	cp $e0			; $5e53
	jr c,_label_11_213	; $5e55
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
	call _partCommon_standardUpdate		; $5e8a

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
	.dw partCode00 ; 0x00
	.dw partCode01 ; 0x01
	.dw partCode02 ; 0x02
	.dw partCode03 ; 0x03
	.dw partCode04 ; 0x04
	.dw partCode05 ; 0x05
	.dw partCode06 ; 0x06
	.dw partCode07 ; 0x07
	.dw partCode08 ; 0x08
	.dw partCode09 ; 0x09
	.dw partCodeNil ; 0x0a
	.dw partCode0b ; 0x0b
	.dw partCode0c ; 0x0c
	.dw partCodeNil ; 0x0d
	.dw partCode0e ; 0x0e
	.dw partCode0f ; 0x0f
	.dw partCode10 ; 0x10
	.dw partCode11 ; 0x11
	.dw partCode12 ; 0x12
	.dw partCode13 ; 0x13
	.dw partCode14 ; 0x14
	.dw partCode15 ; 0x15
	.dw partCode16 ; 0x16
	.dw partCode17 ; 0x17
	.dw partCode18 ; 0x18
	.dw partCode19 ; 0x19
	.dw partCode1a ; 0x1a
	.dw partCode1b ; 0x1b
	.dw partCode1c ; 0x1c
	.dw partCode1d ; 0x1d
	.dw partCode1e ; 0x1e
	.dw partCode1f ; 0x1f
	.dw partCode20 ; 0x20
	.dw partCode21 ; 0x21
	.dw partCode22 ; 0x22
	.dw partCode23 ; 0x23
	.dw partCode24 ; 0x24
	.dw partCode25 ; 0x25
	.dw partCode26 ; 0x26
	.dw partCode27 ; 0x27
	.dw partCode28 ; 0x28
	.dw partCode29 ; 0x29
	.dw partCode2a ; 0x2a
	.dw partCode2b ; 0x2b
	.dw partCode2c ; 0x2c
	.dw partCode2d ; 0x2d
	.dw partCode2e ; 0x2e
	.dw partCode2f ; 0x2f
	.dw partCode30 ; 0x30
	.dw partCode31 ; 0x31
	.dw partCode32 ; 0x32
	.dw partCode33 ; 0x33
	.dw partCode34 ; 0x34
	.dw partCode35 ; 0x35
	.dw partCode36 ; 0x36
	.dw partCode37 ; 0x37
	.dw partCode38 ; 0x38
	.dw partCode39 ; 0x39
	.dw partCode3a ; 0x3a
	.dw partCode3b ; 0x3b
	.dw partCode3c ; 0x3c
	.dw partCode3d ; 0x3d
	.dw partCode3e ; 0x3e
	.dw partCode3f ; 0x3f
	.dw partCode40 ; 0x40
	.dw partCode41 ; 0x41
	.dw partCode42 ; 0x42
	.dw partCode43 ; 0x43
	.dw partCode44 ; 0x44
	.dw partCode45 ; 0x45
	.dw partCode46 ; 0x46
	.dw partCode47 ; 0x47
	.dw partCode48 ; 0x48
	.dw partCode49 ; 0x49
	.dw partCode4a ; 0x4a
	.dw partCode4b ; 0x4b
	.dw partCode4c ; 0x4c
	.dw partCode4d ; 0x4d
	.dw partCode4e ; 0x4e
	.dw partCode4f ; 0x4f
	.dw partCode50 ; 0x50
	.dw partCode51 ; 0x51
	.dw partCode52 ; 0x52
	.dw partCode53 ; 0x53
	.dw partCode54 ; 0x54
	.dw partCode55 ; 0x55
	.dw partCode56 ; 0x56
	.dw partCode57 ; 0x57
	.dw partCode58 ; 0x58
	.dw partCode59 ; 0x59
	.dw partCode5a ; 0x5a

;;
; @addr{5f55}
partCodeNil:
	ret			; $5f55

;;
; @addr{5f56}
partCode00:
	jp partDelete		; $5f56

;;
; @addr{5f59}
partCode16:
	ld e,$c4		; $5f59
	ld a,(de)		; $5f5b
	rst_jumpTable			; $5f5c
.dw $5f65
.dw $5fab
.dw $5fbc
.dw $5fd4
	ld h,d			; $5f65
	ld l,e			; $5f66
	inc (hl)		; $5f67
	ld l,$c0		; $5f68
	set 7,(hl)		; $5f6a
	ld l,$cd		; $5f6c
	ld a,(hl)		; $5f6e
	cp $50			; $5f6f
	ld bc,$ff80		; $5f71
	jr c,_label_11_218	; $5f74
	ld bc,$0080		; $5f76
_label_11_218:
	ld l,$d2		; $5f79
	ld (hl),c		; $5f7b
	inc l			; $5f7c
	ld (hl),b		; $5f7d
	call getRandomNumber_noPreserveVars		; $5f7e
	ld b,a			; $5f81
	and $07			; $5f82
	ld e,$c6		; $5f84
	ld (de),a		; $5f86
	ld a,b			; $5f87
	and $18			; $5f88
	swap a			; $5f8a
	rlca			; $5f8c
	ld hl,$5fa7		; $5f8d
	rst_addAToHl			; $5f90
	ld e,$d0		; $5f91
	ld a,(hl)		; $5f93
	ld (de),a		; $5f94
	ld a,b			; $5f95
_label_11_219:
	and $e0			; $5f96
	swap a			; $5f98
	add a			; $5f9a
	ld e,$c7		; $5f9b
	ld (de),a		; $5f9d
	ld e,$c2		; $5f9e
_label_11_220:
	ld a,(de)		; $5fa0
	call partSetAnimation		; $5fa1
	jp objectSetVisible82		; $5fa4
	ld e,$28		; $5fa7
	ldd (hl),a		; $5fa9
	inc a			; $5faa
	call _partCommon_decCounter1IfNonzero		; $5fab
	jr nz,_label_11_221	; $5fae
	inc l			; $5fb0
	ldd a,(hl)		; $5fb1
	ld (hl),a		; $5fb2
	ld l,e			; $5fb3
	inc (hl)		; $5fb4
_label_11_221:
	ld l,$da		; $5fb5
	ld a,(hl)		; $5fb7
	xor $80			; $5fb8
	ld (hl),a		; $5fba
	ret			; $5fbb
	call _partCommon_decCounter1IfNonzero		; $5fbc
	jr nz,_label_11_222	; $5fbf
	ld l,e			; $5fc1
	inc (hl)		; $5fc2
_label_11_222:
	ld l,$d2		; $5fc3
	ldi a,(hl)		; $5fc5
	ld b,(hl)		; $5fc6
	ld c,a			; $5fc7
	ld l,$cc		; $5fc8
	ld e,l			; $5fca
	ldi a,(hl)		; $5fcb
	ld h,(hl)		; $5fcc
	ld l,a			; $5fcd
	add hl,bc		; $5fce
	ld a,l			; $5fcf
	ld (de),a		; $5fd0
	inc e			; $5fd1
	ld a,h			; $5fd2
	ld (de),a		; $5fd3
	call objectApplySpeed		; $5fd4
	ld e,$cb		; $5fd7
	ld a,(de)		; $5fd9
	cp $f0			; $5fda
	jp nc,partDelete		; $5fdc
	ld h,d			; $5fdf
	ld l,$da		; $5fe0
	ld a,(hl)		; $5fe2
	xor $80			; $5fe3
	ld (hl),a		; $5fe5
	ld l,$c7		; $5fe6
	dec (hl)		; $5fe8
	and $0f			; $5fe9
	ret nz			; $5feb
	ld l,$d0		; $5fec
	ld a,(hl)		; $5fee
	sub $05			; $5fef
	cp $13			; $5ff1
	ret c			; $5ff3
	ld (hl),a		; $5ff4
	ret			; $5ff5

;;
; @addr{5ff6}
partCode24:
	jr z,_label_11_223	; $5ff6
	ld a,(wSwitchState)		; $5ff8
	ld h,d			; $5ffb
	ld l,$c2		; $5ffc
	xor (hl)		; $5ffe
	ld (wSwitchState),a		; $5fff
	ld l,$e4		; $6002
	res 7,(hl)		; $6004
	ld a,$01		; $6006
	call partSetAnimation		; $6008
	ld bc,$8280		; $600b
	jp objectCreateInteraction		; $600e
_label_11_223:
	ld e,$c4		; $6011
	ld a,(de)		; $6013
	or a			; $6014
	ret nz			; $6015
	inc a			; $6016
	ld (de),a		; $6017
	call getThisRoomFlags		; $6018
	bit 6,(hl)		; $601b
	jr z,_label_11_224	; $601d
	ld h,d			; $601f
	ld l,$e4		; $6020
	res 7,(hl)		; $6022
	ld a,$01		; $6024
	call partSetAnimation		; $6026
_label_11_224:
	call objectMakeTileSolid		; $6029
	ld h,$cf		; $602c
	ld (hl),$0a		; $602e
	jp objectSetVisible83		; $6030

;;
; @addr{6033}
partCode25:
	ld e,$c4		; $6033
	ld a,(de)		; $6035
	or a			; $6036
	jr nz,_label_11_225	; $6037
	ld h,d			; $6039
	ld l,e			; $603a
	inc (hl)		; $603b
	ld l,$c2		; $603c
	ld a,(hl)		; $603e
	swap a			; $603f
	rrca			; $6041
	ld l,$c9		; $6042
	ld (hl),a		; $6044
_label_11_225:
	call _partCommon_decCounter1IfNonzero		; $6045
	ret nz			; $6048
	ld e,$c2		; $6049
	ld a,(de)		; $604b
	bit 0,a			; $604c
	ld e,$cd		; $604e
	ldh a,(<hEnemyTargetX)	; $6050
	jr z,_label_11_226	; $6052
	ld e,$cb		; $6054
	ldh a,(<hEnemyTargetY)	; $6056
_label_11_226:
	ld b,a			; $6058
	ld a,(de)		; $6059
	sub b			; $605a
	add $10			; $605b
	cp $21			; $605d
	ret nc			; $605f
	ld e,$c6		; $6060
	ld a,$21		; $6062
	ld (de),a		; $6064
	ld hl,$6080		; $6065
	ld e,$c2		; $6068
	ld a,(de)		; $606a
	rst_addDoubleIndex			; $606b
	ldi a,(hl)		; $606c
	ld b,a			; $606d
	ld c,(hl)		; $606e
	call getFreePartSlot		; $606f
	ret nz			; $6072
	ld (hl),$1a		; $6073
	inc l			; $6075
	inc (hl)		; $6076
	call objectCopyPositionWithOffset		; $6077
	ld l,$c9		; $607a
	ld e,l			; $607c
	ld a,(de)		; $607d
	ld (hl),a		; $607e
	ret			; $607f
.DB $fc				; $6080
	nop			; $6081
	nop			; $6082
	inc b			; $6083
	inc b			; $6084
	nop			; $6085
	nop			; $6086
.DB $fc				; $6087
;;
; @addr{6088}
partCode26:
	ld e,$c4		; $6088
	ld a,(de)		; $608a
	or a			; $608b
	jr z,_label_11_229	; $608c
	call _partCommon_decCounter1IfNonzero		; $608e
	jr nz,_label_11_227	; $6091
	inc l			; $6093
	ldd a,(hl)		; $6094
	ld (hl),a		; $6095
	ld l,$f0		; $6096
	ld a,(hl)		; $6098
	cpl			; $6099
	add $01			; $609a
	ldi (hl),a		; $609c
	ld a,(hl)		; $609d
	cpl			; $609e
	adc $00			; $609f
	ld (hl),a		; $60a1
_label_11_227:
	ld e,$cd		; $60a2
	ld a,(de)		; $60a4
	ld b,a			; $60a5
	dec e			; $60a6
	ld a,(de)		; $60a7
	ld c,a			; $60a8
	ld l,$d2		; $60a9
	ldi a,(hl)		; $60ab
	ld h,(hl)		; $60ac
	ld l,a			; $60ad
	add hl,bc		; $60ae
	ld a,l			; $60af
	ld (de),a		; $60b0
	inc e			; $60b1
	ld a,h			; $60b2
	ld (de),a		; $60b3
	ld e,$f0		; $60b4
	ld a,(de)		; $60b6
	ld c,a			; $60b7
	inc e			; $60b8
	ld a,(de)		; $60b9
	ld b,a			; $60ba
	ld e,$d3		; $60bb
	ld a,(de)		; $60bd
	ld h,a			; $60be
	dec e			; $60bf
	ld a,(de)		; $60c0
	ld l,a			; $60c1
	add hl,bc		; $60c2
	ld a,l			; $60c3
	ld (de),a		; $60c4
	inc e			; $60c5
	ld a,h			; $60c6
	ld (de),a		; $60c7
	ld h,d			; $60c8
	ld l,$ce		; $60c9
	ld e,$d4		; $60cb
	ld a,(de)		; $60cd
	add (hl)		; $60ce
	ldi (hl),a		; $60cf
	ld a,(hl)		; $60d0
	adc $00			; $60d1
	jp z,partDelete		; $60d3
	ld (hl),a		; $60d6
	cp $e8			; $60d7
	jr c,_label_11_228	; $60d9
	ld l,$da		; $60db
	ld a,(hl)		; $60dd
	xor $80			; $60de
	ld (hl),a		; $60e0
_label_11_228:
	jp partAnimate		; $60e1
_label_11_229:
	ld h,d			; $60e4
	ld l,e			; $60e5
	inc (hl)		; $60e6
	call objectGetZAboveScreen		; $60e7
	ld l,$cf		; $60ea
	ld (hl),a		; $60ec
	ld e,$c3		; $60ed
	ld a,(de)		; $60ef
	or a			; $60f0
	jr z,_label_11_230	; $60f1
	ld (hl),$f0		; $60f3
_label_11_230:
	call getRandomNumber_noPreserveVars		; $60f5
	and $0c			; $60f8
	ld hl,$6114		; $60fa
	rst_addAToHl			; $60fd
	ld e,$f0		; $60fe
	ldi a,(hl)		; $6100
	ld (de),a		; $6101
	inc e			; $6102
	ldi a,(hl)		; $6103
	ld (de),a		; $6104
	ld e,$d4		; $6105
	ldi a,(hl)		; $6107
	ld (de),a		; $6108
	ld e,$c6		; $6109
	ld a,(hl)		; $610b
	ld (de),a		; $610c
	inc e			; $610d
	dec a			; $610e
	add a			; $610f
	ld (de),a		; $6110
	jp objectSetVisible81		; $6111
	ld a,($56ff)		; $6114
	inc c			; $6117
	rst $30			; $6118
	rst $38			; $6119
	ld d,h			; $611a
	ld a,(bc)		; $611b
	ld a,($ff00+c)		; $611c
	rst $38			; $611d
	ld e,h			; $611e
	ld c,$f5		; $611f
	rst $38			; $6121
	ld e,b			; $6122
	stop			; $6123

;;
; @addr{6124}
partCode2b:
	ld e,$c4		; $6124
	ld a,(de)		; $6126
	or a			; $6127
	jr nz,_label_11_231	; $6128
	inc a			; $612a
	ld (de),a		; $612b
	ld h,d			; $612c
	ld l,$c0		; $612d
	set 7,(hl)		; $612f
_label_11_231:
	call objectApplySpeed		; $6131
	ld e,$cb		; $6134
	ld a,(de)		; $6136
	add $04			; $6137
	cp $f4			; $6139
	jp nc,partDelete		; $613b
	ld a,$04		; $613e
	call objectGetRelatedObject1Var		; $6140
	ld a,(hl)		; $6143
	cp $03			; $6144
	ld e,$c2		; $6146
	ld a,(de)		; $6148
	jr c,_label_11_232	; $6149
	bit 1,a			; $614b
	jp nz,partDelete		; $614d
_label_11_232:
	ld l,$61		; $6150
	xor (hl)		; $6152
	rrca			; $6153
	jp c,objectSetInvisible		; $6154
	jp objectSetVisible83		; $6157

;;
; @addr{615a}
partCode2c:
	jp nz,partDelete		; $615a
	ld a,($cfd0)		; $615d
	or a			; $6160
	jr z,_label_11_233	; $6161
	call objectCreatePuff		; $6163
	jp partDelete		; $6166
_label_11_233:
	ld e,$c4		; $6169
	ld a,(de)		; $616b
	rst_jumpTable			; $616c
.dw $6177
.dw $61ac
.dw $61c2
.dw $61d2
.dw $61ff
	ld h,d			; $6177
	ld l,e			; $6178
	inc (hl)		; $6179
	ld l,$d0		; $617a
	ld (hl),$1e		; $617c
	ld e,$c2		; $617e
	ld a,(de)		; $6180
	swap a			; $6181
	add $08			; $6183
	ld l,$c9		; $6185
	ld (hl),a		; $6187
	bit 4,a			; $6188
	jr z,_label_11_234	; $618a
	ld l,$cb		; $618c
	ld (hl),$fe		; $618e
	call getRandomNumber_noPreserveVars		; $6190
	and $07			; $6193
	ld hl,$629f		; $6195
	rst_addAToHl			; $6198
	ld a,(hl)		; $6199
	ld hl,$61aa		; $619a
	rst_addAToHl			; $619d
	ld e,$cd		; $619e
	ld a,(hl)		; $61a0
	ld (de),a		; $61a1
	ld a,$01		; $61a2
	call partSetAnimation		; $61a4
_label_11_234:
	jp objectSetVisible82		; $61a7
	ret c			; $61aa
	cp b			; $61ab
	ld a,$20		; $61ac
	call objectUpdateSpeedZ_sidescroll		; $61ae
	jr nc,_label_11_235	; $61b1
	ld h,d			; $61b3
	ld l,$c4		; $61b4
	inc (hl)		; $61b6
	ld l,$f1		; $61b7
	ld (hl),$04		; $61b9
	ld l,$d4		; $61bb
	xor a			; $61bd
	ldi (hl),a		; $61be
	ld (hl),a		; $61bf
	jr _label_11_235		; $61c0
	ld h,d			; $61c2
	ld l,$f1		; $61c3
	dec (hl)		; $61c5
	jr nz,_label_11_235	; $61c6
	ld (hl),$04		; $61c8
	ld l,e			; $61ca
	inc (hl)		; $61cb
	inc l			; $61cc
	ld (hl),$00		; $61cd
_label_11_235:
	jp partAnimate		; $61cf
	ld e,$c5		; $61d2
	ld a,(de)		; $61d4
	rst_jumpTable			; $61d5
.dw $61da
.dw $61e6

_label_11_236:
	call $6248		; $61da
	call $6270		; $61dd
	ret c			; $61e0
	ld h,d			; $61e1
	ld l,$c4		; $61e2
	inc (hl)		; $61e4
	ret			; $61e5
	ld bc,$1000		; $61e6
	call objectGetRelativeTile		; $61e9
	cp $19			; $61ec
	jp z,$6248		; $61ee
	ld h,d			; $61f1
	ld l,$c5		; $61f2
	dec (hl)		; $61f4
	ld l,$c6		; $61f5
	xor a			; $61f7
	ld (hl),a		; $61f8
	ld l,$d4		; $61f9
	ldi (hl),a		; $61fb
	ld (hl),a		; $61fc
	jr _label_11_236		; $61fd
	ld e,$cb		; $61ff
	ld a,(de)		; $6201
	cp $b0			; $6202
	jp nc,partDelete		; $6204
	call $6248		; $6207
	call $6270		; $620a
	ret nc			; $620d
	ld h,d			; $620e
	ld l,$c4		; $620f
	ld (hl),$02		; $6211
	xor a			; $6213
	ld l,$d4		; $6214
_label_11_237:
	ldi (hl),a		; $6216
	ld (hl),a		; $6217
	ld l,$c6		; $6218
	ld (hl),a		; $621a
	ld e,$c2		; $621b
	ld a,(de)		; $621d
	swap a			; $621e
	rrca			; $6220
	inc l			; $6221
	add (hl)		; $6222
	inc (hl)		; $6223
	ld bc,$6238		; $6224
	call addAToBc		; $6227
	ld l,$c9		; $622a
	ld a,(bc)		; $622c
	ldd (hl),a		; $622d
	and $10			; $622e
	swap a			; $6230
	cp (hl)			; $6232
	ret z			; $6233
	ld (hl),a		; $6234
	jp partSetAnimation		; $6235
	ld ($1818),sp		; $6238
	ld ($ff08),sp		; $623b
	rst $38			; $623e
	rst $38			; $623f
	jr $18			; $6240
	ld ($1808),sp		; $6242
	jr $18			; $6245
	jr _label_11_237		; $6247
	sub (hl)		; $6249
_label_11_238:
	jr nz,_label_11_238	; $624a
	sub c			; $624c
	jr nz,_label_11_239	; $624d
	pop hl			; $624f
	call objectCreatePuff		; $6250
	jp partDelete		; $6253
_label_11_239:
	call _partCommon_getTileCollisionInFront		; $6256
	jr nz,_label_11_240	; $6259
	call objectApplySpeed		; $625b
	jp partAnimate		; $625e
_label_11_240:
	ld e,$c9		; $6261
	ld a,(de)		; $6263
	xor $10			; $6264
	ld (de),a		; $6266
	ld e,$c8		; $6267
	ld a,(de)		; $6269
	xor $01			; $626a
	ld (de),a		; $626c
	jp partSetAnimation		; $626d
	ld a,$20		; $6270
	call objectUpdateSpeedZ_sidescroll		; $6272
	ret c			; $6275
	ld a,(hl)		; $6276
	cp $02			; $6277
	jr c,_label_11_241	; $6279
	ld (hl),$02		; $627b
	dec l			; $627d
	ld (hl),$00		; $627e
_label_11_241:
	call _partCommon_decCounter1IfNonzero		; $6280
	ret nz			; $6283
	ld (hl),$10		; $6284
	ld bc,$1000		; $6286
	call objectGetRelativeTile		; $6289
	sub $19			; $628c
	or a			; $628e
	ret nz			; $628f
	call getRandomNumber		; $6290
	and $07			; $6293
	ld hl,$629f		; $6295
	rst_addAToHl			; $6298
	ld e,$c5		; $6299
	ld a,(hl)		; $629b
	ld (de),a		; $629c
	rrca			; $629d
	ret			; $629e
	nop			; $629f
	nop			; $62a0
	ld bc,$0100		; $62a1
	nop			; $62a4
	.db $01 $00

;;
; @addr{62a7}
partCode2d:
	jr nz,_label_11_244	; $42a7
	ld a,$29		; $62a9
	call objectGetRelatedObject1Var		; $62ab
	ld a,(hl)		; $62ae
	or a			; $62af
	jr z,_label_11_243	; $62b0
	ld e,$c4		; $62b2
	ld a,(de)		; $62b4
	or a			; $62b5
	jr z,_label_11_242	; $62b6
	call _partCommon_checkOutOfBounds		; $62b8
	jr z,_label_11_244	; $62bb
	call objectApplySpeed		; $62bd
	jp partAnimate		; $62c0
_label_11_242:
	ld h,d			; $62c3
	ld l,e			; $62c4
	inc (hl)		; $62c5
	ld l,$d0		; $62c6
	ld (hl),$3c		; $62c8
	call objectGetAngleTowardEnemyTarget		; $62ca
	ld e,$c9		; $62cd
	ld (de),a		; $62cf
	call objectSetVisible82		; $62d0
	ld a,SND_VERAN_FAIRY_ATTACK		; $62d3
	jp playSound		; $62d5
_label_11_243:
	call objectCreatePuff		; $62d8
_label_11_244:
	jp partDelete		; $62db

;;
; @addr{62de}
partCode2e:
	ld e,Part.state		; $62de
	ld a,(de)		; $62e0
	or a			; $62e1
	jr nz,@initialized	; $62e2

	inc a			; $62e4
	ld (de),a		; $62e5
	jp $6361		; $62e6

@initialized:
	ld a,(w1Link.state)		; $62e9
	sub LINK_STATE_NORMAL			; $62ec
	ret nz			; $62ee

	ld (wDisableScreenTransitions),a		; $62ef
	call checkLinkCollisionsEnabled		; $62f2
	jr c,+			; $62f5

	; Check if diving underwater
	ld a,(wLinkSwimmingState)		; $62f7
	rlca			; $62fa
	ret nc			; $62fb
+
	ld a,(wLinkObjectIndex)		; $62fc
	ld h,a			; $62ff
	ld l,SpecialObject.start		; $6300
	call objectTakePosition		; $6302

	ld l,SpecialObject.id		; $6305
	ld a,(hl)		; $6307
	cp SPECIALOBJECTID_RAFT			; $6308
	ld a,$05		; $630a
	jr nz,+			; $630c
	add a			; $630e
+
	ld h,d			; $630f
	ld l,Part.counter2		; $6310
	ld (hl),a		; $6312

	; Get position in bc
	ld l,Part.yh		; $6313
	ldi a,(hl)		; $6315
	ld b,a			; $6316
	inc l			; $6317
	ld c,(hl)		; $6318

	ld hl,hFF8B		; $6319
	ld (hl),$06		; $631c
--
	ld hl,hFF8B		; $631e
	dec (hl)		; $6321
	jr z,_label_11_249	; $6322
	ld h,d			; $6324
	ld l,$c7		; $6325
	dec (hl)		; $6327
	ld a,(hl)		; $6328
	ld hl,$63fc		; $6329
	rst_addDoubleIndex			; $632c
	ldi a,(hl)		; $632d
	add b			; $632e
	ld b,a			; $632f
	ld a,(hl)		; $6330
	add c			; $6331
	ld c,a			; $6332
	call getTileAtPosition		; $6333
	ld e,a			; $6336
	ld a,l			; $6337
	ldh (<hFF8A),a	; $6338
	ld hl,$6418		; $633a
	call lookupCollisionTable_paramE		; $633d
	jr nc,--		; $6340

	rst_jumpTable			; $6342
.dw $6367
.dw $6398
.dw $63a3

_label_11_249:
	ld a,(wTilesetFlags)		; $6349
	and $01			; $634c
	jr z,_label_11_250	; $634e
	call objectGetTileAtPosition		; $6350
	ld hl,$6437		; $6353
	call lookupCollisionTable		; $6356
	jr nc,_label_11_250	; $6359
	ld c,a			; $635b
	ld b,$3c		; $635c
	call updateLinkPositionGivenVelocity		; $635e
_label_11_250:
	ld e,$c6		; $6361
	ld a,$20		; $6363
	ld (de),a		; $6365
	ret			; $6366
	ldh a,(<hFF8A)	; $6367
	call convertShortToLongPosition		; $6369
	ld e,$cb		; $636c
	ld a,(de)		; $636e
	ldh (<hFF8F),a	; $636f
	ld e,$cd		; $6371
	ld a,(de)		; $6373
	ldh (<hFF8E),a	; $6374
	call objectGetRelativeAngleWithTempVars		; $6376
	xor $10			; $6379
	ld b,a			; $637b
	ld a,(wLinkObjectIndex)		; $637c
	ld h,a			; $637f
	ld l,$2b		; $6380
	ldd a,(hl)		; $6382
	or (hl)			; $6383
	ret nz			; $6384
	ld (hl),$01		; $6385
	inc l			; $6387
	ld (hl),$18		; $6388
	inc l			; $638a
	ld (hl),b		; $638b
	inc l			; $638c
	ld (hl),$0c		; $638d
	ld l,$25		; $638f
	ld (hl),$fe		; $6391
	ld a,SND_DAMAGE_LINK		; $6393
	jp playSound		; $6395
	ld a,(wLinkObjectIndex)		; $6398
	rrca			; $639b
	jr c,_label_11_251	; $639c
	ld a,(wLinkSwimmingState)		; $639e
	or a			; $63a1
	ret z			; $63a2
_label_11_251:
	ldh a,(<hFF8A)	; $63a3
	call convertShortToLongPosition		; $63a5
	ld e,$cb		; $63a8
	ld a,(de)		; $63aa
	ldh (<hFF8F),a	; $63ab
	ld e,$cd		; $63ad
	ld a,(de)		; $63af
	ldh (<hFF8E),a	; $63b0
	sub c			; $63b2
	inc a			; $63b3
	cp $03			; $63b4
	jr nc,_label_11_252	; $63b6
	ldh a,(<hFF8F)	; $63b8
	sub b			; $63ba
	inc a			; $63bb
	cp $03			; $63bc
	jr nc,_label_11_252	; $63be
	ld a,(wLinkObjectIndex)		; $63c0
	ld h,a			; $63c3
	ld l,$0b		; $63c4
	ld (hl),b		; $63c6
	ld l,$0d		; $63c7
	ld (hl),c		; $63c9
	ld a,$02		; $63ca
	ld (wLinkForceState),a		; $63cc
	xor a			; $63cf
	ld (wLinkStateParameter),a		; $63d0
	jp clearAllParentItems		; $63d3
_label_11_252:
	ld a,$ff		; $63d6
	ld (wDisableScreenTransitions),a		; $63d8
	call objectGetRelativeAngleWithTempVars		; $63db
	ld c,a			; $63de
	call _partCommon_decCounter1IfNonzero		; $63df
	ld a,(hl)		; $63e2
	and $1c			; $63e3
	rrca			; $63e5
	rrca			; $63e6
	ld hl,$6410		; $63e7
	rst_addAToHl			; $63ea
	ld a,(hl)		; $63eb
	ld b,a			; $63ec
	cp $19			; $63ed
	jr c,_label_11_253	; $63ef
	ld a,(wLinkObjectIndex)		; $63f1
	ld h,a			; $63f4
	ld l,$10		; $63f5
	ld (hl),$00		; $63f7
_label_11_253:
	jp updateLinkPositionGivenVelocity		; $63f9
	nop			; $63fc
	rst $30			; $63fd
	ld a,(bc)		; $63fe
	nop			; $63ff
	nop			; $6400
	add hl,bc		; $6401
.DB $fd				; $6402
	ei			; $6403
	nop			; $6404
	nop			; $6405
	nop			; $6406
	push af			; $6407
	dec bc			; $6408
	nop			; $6409
	nop			; $640a
	dec bc			; $640b
	ld a,($00fa)		; $640c
	nop			; $640f
	inc a			; $6410
	ldd (hl),a		; $6411
	jr z,_label_11_254	; $6412
	add hl,de		; $6414
	inc d			; $6415
	rrca			; $6416
	ld a,(bc)		; $6417
	inc h			; $6418
	ld h,h			; $6419
	jr z,$64		; $641a
	ld l,$64		; $641c
	jr z,_label_11_257	; $641e
	add hl,hl		; $6420
	ld h,h			; $6421
	ld l,$64		; $6422
.DB $eb				; $6424
	nop			; $6425
	jp hl			; $6426
	ld bc,$eb00		; $6427
	nop			; $642a
	jp hl			; $642b
	ld (bc),a		; $642c
	nop			; $642d
	inc a			; $642e
	ld (bc),a		; $642f
	dec a			; $6430
	ld (bc),a		; $6431
_label_11_254:
	ld a,$02		; $6432
	ccf			; $6434
	ld (bc),a		; $6435
_label_11_255:
	nop			; $6436
	ld c,h			; $6437
	ld h,h			; $6438
	ld d,h			; $6439
	ld h,h			; $643a
	ld b,e			; $643b
	ld h,h			; $643c
	ld d,h			; $643d
	ld h,h			; $643e
	ld d,h			; $643f
	ld h,h			; $6440
	ld b,e			; $6441
	ld h,h			; $6442
	ld d,h			; $6443
	nop			; $6444
	ld d,l			; $6445
	ld ($1056),sp		; $6446
	ld d,a			; $6449
	jr _label_11_256		; $644a
_label_11_256:
	ld ($ff00+R_P1),a	; $644c
	pop hl			; $644e
	stop			; $644f
	ld ($ff00+c),a		; $6450
	jr _label_11_255		; $6451
	.db $08 $00

;;
; @addr{6455}
partCode2f:
	jp nz,partDelete		; $6455
	ld a,$29 		; $6458
	call objectGetRelatedObject1Var		; $645a
	ld a,(hl)		; $645d
	or a			; $645e
	jr z,_label_11_260	; $645f
	ld b,h			; $6461
	ld e,$c4		; $6462
	ld a,(de)		; $6464
	rst_jumpTable			; $6465
.dw $646c
.dw $647f
.dw $6493
	ld h,d			; $646c
	ld l,e			; $646d
	inc (hl)		; $646e
	ld l,$d0		; $646f
	ld (hl),$14		; $6471
	ld l,$c6		; $6473
	ld (hl),$1e		; $6475
	ld a,SND_CHARGE		; $6477
	call playSound		; $6479
	jp objectSetVisible82		; $647c
	call _partCommon_decCounter1IfNonzero		; $647f
	jr nz,_label_11_259	; $6482
_label_11_257:
	ld l,e			; $6484
	inc (hl)		; $6485
	call objectGetAngleTowardEnemyTarget		; $6486
	ld e,$c9		; $6489
	ld (de),a		; $648b
	ld a,SND_BEAM2		; $648c
	call playSound		; $648e
	jr _label_11_259		; $6491
	ld c,$84		; $6493
	ld a,(bc)		; $6495
	cp $03			; $6496
	jr nz,_label_11_258	; $6498
	ld c,$83		; $649a
	ld a,(bc)		; $649c
	cp $02			; $649d
	jr nz,_label_11_258	; $649f
	ld a,(wFrameCounter)		; $64a1
	and $0f			; $64a4
	jr nz,_label_11_258	; $64a6
	call objectGetAngleTowardEnemyTarget		; $64a8
	call objectNudgeAngleTowards		; $64ab
_label_11_258:
	call _partCommon_checkOutOfBounds		; $64ae
	jr z,_label_11_261	; $64b1
	call objectApplySpeed		; $64b3
_label_11_259:
	jp partAnimate		; $64b6
_label_11_260:
	call objectCreatePuff		; $64b9
_label_11_261:
	jp partDelete		; $64bc

;;
; @addr{64bf}
partCode32:
	ld e,$c4		; $64bf
	ld a,(de)		; $64c1
	rst_jumpTable			; $64c2
.dw $64c7
.dw $64cf
	ld a,$01		; $64c7
	ld (de),a		; $64c9
	ld a,SND_DIG		; $64ca
	call playSound		; $64cc
	call partAnimate		; $64cf
	ld e,$e1		; $64d2
	ld a,(de)		; $64d4
	ld e,$da		; $64d5
	ld (de),a		; $64d7
	or a			; $64d8
	ret nz			; $64d9
	jp partDelete		; $64da

;;
; @addr{64dd}
partCode33:
	ld e,$c2		; $64dd
	ld a,(de)		; $64df
	ld b,a			; $64e0
	and $03			; $64e1
	ld e,$c4		; $64e3
	rst_jumpTable			; $64e5
.dw $64ee
.dw $653e
.dw $6566
.dw $65c0
	ld a,(de)		; $64ee
	or a			; $64ef
	jr z,_label_11_263	; $64f0
_label_11_262:
	call _partCommon_decCounter1IfNonzero		; $64f2
	ret nz			; $64f5
	ld e,$f0		; $64f6
	ld a,(de)		; $64f8
	ld (hl),a		; $64f9
	jp $657e		; $64fa
_label_11_263:
	ld c,b			; $64fd
	rlc c			; $64fe
	ld a,$01		; $6500
	jr nc,_label_11_264	; $6502
	ld a,$ff		; $6504
_label_11_264:
	ld h,d			; $6506
	ld l,$f1		; $6507
	ldd (hl),a		; $6509
	rlc c			; $650a
	ld a,$3c		; $650c
	jr nc,_label_11_265	; $650e
	add a			; $6510
_label_11_265:
	ld (hl),a		; $6511
	ld l,$c6		; $6512
	ld (hl),a		; $6514
	ld a,b			; $6515
	rrca			; $6516
	rrca			; $6517
	and $03			; $6518
	ld e,$c8		; $651a
	ld (de),a		; $651c
	call $6588		; $651d
	call objectMakeTileSolid		; $6520
	ld h,$cf		; $6523
	ld (hl),$0a		; $6525
	call objectSetVisible83		; $6527
	call getFreePartSlot		; $652a
	ret nz			; $652d
	ld (hl),$33		; $652e
	inc l			; $6530
	ld (hl),$03		; $6531
	ld l,$d6		; $6533
	ld a,$c0		; $6535
	ldi (hl),a		; $6537
	ld (hl),d		; $6538
	ld h,d			; $6539
	ld l,$c4		; $653a
	inc (hl)		; $653c
	ret			; $653d
	ld a,(de)		; $653e
	jr z,_label_11_266	; $653f
	ld h,d			; $6541
	ld l,$c3		; $6542
	ld a,(hl)		; $6544
	ld l,$d8		; $6545
	ldi a,(hl)		; $6547
	ld h,(hl)		; $6548
	ld l,a			; $6549
	and (hl)		; $654a
	ret z			; $654b
	jr _label_11_262		; $654c
_label_11_266:
	call $64fd		; $654e
	ld e,$c2		; $6551
	ld a,(de)		; $6553
	bit 4,a			; $6554
	ld hl,wToggleBlocksState		; $6556
	jr z,_label_11_267	; $6559
	ld hl,wActiveTriggers		; $655b
_label_11_267:
	ld e,$d8		; $655e
	ld a,l			; $6560
	ld (de),a		; $6561
	inc e			; $6562
	ld a,h			; $6563
	ld (de),a		; $6564
	ret			; $6565
	ld a,(de)		; $6566
	or a			; $6567
	jr z,_label_11_268	; $6568
	ld h,d			; $656a
	ld l,$f2		; $656b
	ld e,l			; $656d
	ld b,(hl)		; $656e
	ld l,$c3		; $656f
	ld c,(hl)		; $6571
	ld l,$d8		; $6572
	ldi a,(hl)		; $6574
	ld h,(hl)		; $6575
	ld l,a			; $6576
	ld a,(hl)		; $6577
	and c			; $6578
	ld c,a			; $6579
	xor b			; $657a
	ret z			; $657b
	ld a,c			; $657c
	ld (de),a		; $657d
	ld h,d			; $657e
	ld l,$f1		; $657f
	ld e,$c8		; $6581
	ld a,(de)		; $6583
	add (hl)		; $6584
	and $03			; $6585
	ld (de),a		; $6587
	ld b,a			; $6588
	ld hl,$6598		; $6589
	rst_addDoubleIndex			; $658c
	ld e,$e6		; $658d
	ldi a,(hl)		; $658f
	ld (de),a		; $6590
	inc e			; $6591
	ld a,(hl)		; $6592
	ld (de),a		; $6593
	ld a,b			; $6594
	jp partSetAnimation		; $6595
	ld b,$04		; $6598
	inc b			; $659a
	inc b			; $659b
	inc b			; $659c
	ld b,$04		; $659d
	inc b			; $659f
_label_11_268:
	ld c,b			; $65a0
	rlc c			; $65a1
	ld a,$01		; $65a3
	jr nc,_label_11_269	; $65a5
	ld a,$ff		; $65a7
_label_11_269:
	rlc c			; $65a9
	jr nc,_label_11_270	; $65ab
	add a			; $65ad
_label_11_270:
	ld h,d			; $65ae
	ld l,$f1		; $65af
	ld (hl),a		; $65b1
	call $6515		; $65b2
	call $6551		; $65b5
	ld e,$c3		; $65b8
	ld a,(de)		; $65ba
	and (hl)		; $65bb
	ld e,$f2		; $65bc
	ld (de),a		; $65be
	ret			; $65bf
	ld a,(de)		; $65c0
	or a			; $65c1
	jr z,_label_11_271	; $65c2
	ld a,$21		; $65c4
	call objectGetRelatedObject1Var		; $65c6
	ld e,l			; $65c9
	ld a,(hl)		; $65ca
	ld (de),a		; $65cb
	ld l,$e6		; $65cc
	ld e,l			; $65ce
	ldi a,(hl)		; $65cf
	ld (de),a		; $65d0
	inc e			; $65d1
	ld a,(hl)		; $65d2
	ld (de),a		; $65d3
	ret			; $65d4
_label_11_271:
	ld a,$0b		; $65d5
	call objectGetRelatedObject1Var		; $65d7
	ld bc,$0c00		; $65da
	call objectTakePositionWithOffset		; $65dd
	ld h,d			; $65e0
	ld l,$c4		; $65e1
	inc (hl)		; $65e3
	ld l,$cf		; $65e4
	ld (hl),$f2		; $65e6
	ret			; $65e8

;;
; @addr{65e9}
partCode34:
	ld e,$c4		; $65e9
	ld a,(de)		; $65eb
	cp $03			; $65ec
	jr nc,_label_11_272	; $65ee
	ld a,$0d		; $65f0
	call objectGetRelatedObject1Var		; $65f2
	ld a,(hl)		; $65f5
	ld e,$cd		; $65f6
	ld (de),a		; $65f8
_label_11_272:
	ld e,$c7		; $65f9
	ld a,(de)		; $65fb
	dec a			; $65fc
	ld (de),a		; $65fd
	and $03			; $65fe
	jr nz,_label_11_273	; $6600
	ld e,$dc		; $6602
	ld a,(de)		; $6604
	xor $01			; $6605
	ld (de),a		; $6607
_label_11_273:
	ld e,$c4		; $6608
	ld a,(de)		; $660a
	rst_jumpTable			; $660b
.dw $6616
.dw $662c
.dw $665c
.dw $666f
.dw partDelete
	ld a,$01		; $6616
	ld (de),a		; $6618
	ld h,d			; $6619
	ld l,$d0		; $661a
	ld (hl),$6e		; $661c
	ld l,$c9		; $661e
	ld (hl),$10		; $6620
	ld l,$c6		; $6622
	ld a,$07		; $6624
	ldi (hl),a		; $6626
	ld (hl),$03		; $6627
	call objectSetVisible80		; $6629
	ld e,$c3		; $662c
	ld a,(de)		; $662e
	or a			; $662f
	jr z,_label_11_274	; $6630
	call _partCommon_decCounter1IfNonzero		; $6632
	jp nz,objectApplySpeed		; $6635
_label_11_274:
	ld e,$c3		; $6638
	ld a,(de)		; $663a
	cp $06			; $663b
	jr z,_label_11_275	; $663d
	call getFreePartSlot		; $663f
	ret nz			; $6642
	ld (hl),$34		; $6643
	inc l			; $6645
	ld (hl),$0e		; $6646
	ld l,e			; $6648
	ld a,(de)		; $6649
	inc a			; $664a
	ld (hl),a		; $664b
	ld e,$d6		; $664c
	ld l,e			; $664e
	ld a,$c0		; $664f
	ldi (hl),a		; $6651
	ld a,d			; $6652
	ld (hl),a		; $6653
	call objectCopyPosition		; $6654
_label_11_275:
	ld e,$c4		; $6657
	ld a,$02		; $6659
	ld (de),a		; $665b
	ld a,$02		; $665c
	call objectGetRelatedObject1Var		; $665e
	ld a,(hl)		; $6661
	cp $0e			; $6662
	ret z			; $6664
	ld e,$c4		; $6665
	ld a,$03		; $6667
	ld (de),a		; $6669
	ld e,$c6		; $666a
	ld a,$07		; $666c
	ld (de),a		; $666e
	ld e,$c3		; $666f
	ld a,(de)		; $6671
	cp $06			; $6672
	jp z,partDelete		; $6674
	call _partCommon_decCounter1IfNonzero		; $6677
	jp nz,objectApplySpeed		; $667a
	ld e,$c2		; $667d
	ld (de),a		; $667f
	ld e,$c4		; $6680
	ld a,$04		; $6682
	ld (de),a		; $6684
	ret			; $6685

;;
; @addr{6686}
partCode35:
	ld a,$29		; $6686
	call objectGetRelatedObject1Var		; $6688
	ld a,(hl)		; $668b
	or a			; $668c
	jp z,partDelete		; $668d
	ld e,$c2		; $6690
	ld a,(de)		; $6692
	rlca			; $6693
	jr c,_label_11_276	; $6694
	ld a,(wLinkGrabState)		; $6696
	or a			; $6699
	call z,objectPushLinkAwayOnCollision		; $669a
	ld e,$c4		; $669d
	ld a,(de)		; $669f
	rst_jumpTable			; $66a0
.dw $66d2
.dw $673a
.dw $677c
.dw $680f
.dw $686d
.dw $68e2
.dw $6924

_label_11_276:
	ld e,$c6		; $66af
	ld a,(de)		; $66b1
	or a			; $66b2
	jr nz,_label_11_277	; $66b3
	ld e,$c4		; $66b5
	ld a,(de)		; $66b7
	cp $04			; $66b8
	jr z,_label_11_277	; $66ba
	ld e,$da		; $66bc
	ld a,(de)		; $66be
	xor $80			; $66bf
	ld (de),a		; $66c1
_label_11_277:
	ld e,$c4		; $66c2
	ld a,(de)		; $66c4
	rst_jumpTable			; $66c5
.dw $6705
.dw $6747
.dw $67f1
.dw $680f
.dw $68c3
.dw $690c
	call $6731		; $66d2
	ld e,$d7		; $66d5
	ld a,(de)		; $66d7
	ld e,$f0		; $66d8
	ld (de),a		; $66da
	call $6956		; $66db
	ld a,(de)		; $66de
	swap a			; $66df
	ld (de),a		; $66e1
	or $80			; $66e2
	ld (hl),a		; $66e4
	call $6992		; $66e5
	ld l,$d6		; $66e8
	ld a,$c0		; $66ea
	ldi (hl),a		; $66ec
	ld (hl),d		; $66ed
	ld e,$c2		; $66ee
	ld a,(de)		; $66f0
	swap a			; $66f1
	ld hl,$6703		; $66f3
	rst_addAToHl			; $66f6
	ld a,(hl)		; $66f7
	ld e,$c9		; $66f8
	ld (de),a		; $66fa
	ld a,SND_THROW		; $66fb
	call playSound		; $66fd
	jp objectSetVisiblec0		; $6700
	jr $08			; $6703
	call $6731		; $6705
	call $6956		; $6708
	call $6992		; $670b
	ld l,$d6		; $670e
	ld a,$c0		; $6710
	ldi (hl),a		; $6712
	ld (hl),d		; $6713
	ld l,$f0		; $6714
	ld e,l			; $6716
	ld a,(de)		; $6717
	ld (hl),a		; $6718
	ld a,$01		; $6719
	call partSetAnimation		; $671b
	ld e,$c2		; $671e
	ld a,(de)		; $6720
	and $0f			; $6721
	add $0a			; $6723
	ld e,$c6		; $6725
	ld (de),a		; $6727
	ld e,$e4		; $6728
	ld a,(de)		; $672a
	res 7,a			; $672b
	ld (de),a		; $672d
	jp objectSetVisiblec1		; $672e
	ld a,$01		; $6731
	ld (de),a		; $6733
	ld e,$cf		; $6734
	ld a,$81		; $6736
	ld (de),a		; $6738
	ret			; $6739
	ld c,$10		; $673a
	call objectUpdateSpeedZ_paramC		; $673c
	ret nz			; $673f
	ld e,$f1		; $6740
	ld a,(de)		; $6742
	or a			; $6743
	jr nz,_label_11_278	; $6744
	ret			; $6746
	call _partCommon_decCounter1IfNonzero		; $6747
	ret nz			; $674a
	ld c,$10		; $674b
	call objectUpdateSpeedZ_paramC		; $674d
	ret nz			; $6750
	ld l,$c7		; $6751
	ld a,(hl)		; $6753
	or a			; $6754
	jr nz,_label_11_278	; $6755
	inc (hl)		; $6757
	ld bc,$fe80		; $6758
	jp objectSetSpeedZ		; $675b
_label_11_278:
	ld a,$78		; $675e
	jr _label_11_279		; $6760
	ld a,$14		; $6762
_label_11_279:
	ld e,$d0		; $6764
	ld (de),a		; $6766
	ld a,$31		; $6767
	call objectGetRelatedObject1Var		; $6769
	inc (hl)		; $676c
	ld e,$c4		; $676d
	ld a,$03		; $676f
	ld (de),a		; $6771
	call $693b		; $6772
	call objectGetRelativeAngle		; $6775
	ld e,$c9		; $6778
	ld (de),a		; $677a
	ret			; $677b
	inc e			; $677c
	ld a,(de)		; $677d
	rst_jumpTable			; $677e
.dw $6787
.dw $67b7
.dw $67b0
.dw $67b0
	ld h,d			; $6787
	ld l,e			; $6788
	inc (hl)		; $6789
	ld a,$90		; $678a
	ld (wLinkGrabState2),a		; $678c
	xor a			; $678f
	ld l,$ca		; $6790
	ldd (hl),a		; $6792
	ld ($d00a),a		; $6793
	ld (hl),$10		; $6796
	ld l,$d0		; $6798
	ld (hl),$14		; $679a
	ld l,$c7		; $679c
	ld (hl),$60		; $679e
	call $69a5		; $67a0
	ld l,$b7		; $67a3
	ld e,$c2		; $67a5
	ld a,(de)		; $67a7
	swap a			; $67a8
	jp unsetFlag		; $67aa
_label_11_280:
	call dropLinkHeldItem		; $67ad
	ld a,SND_BIGSWORD		; $67b0
	call playSound		; $67b2
	jr _label_11_278		; $67b5
	call $69a5		; $67b7
	ldi a,(hl)		; $67ba
	cp $11			; $67bb
	jr z,_label_11_280	; $67bd
	ld a,($d221)		; $67bf
	or a			; $67c2
	jr nz,_label_11_281	; $67c3
	ld e,$f3		; $67c5
	ld (de),a		; $67c7
	ret			; $67c8
_label_11_281:
	ld h,d			; $67c9
	ld l,$c7		; $67ca
	ld a,(hl)		; $67cc
	or a			; $67cd
	ret z			; $67ce
	dec (hl)		; $67cf
	jr nz,_label_11_282	; $67d0
	dec l			; $67d2
	ld (hl),$14		; $67d3
	ld l,$f2		; $67d5
	inc (hl)		; $67d7
_label_11_282:
	ld l,$f3		; $67d8
	ld a,(hl)		; $67da
	or a			; $67db
	jr nz,_label_11_283	; $67dc
	ld a,SND_MOVEBLOCK		; $67de
	ld (hl),a		; $67e0
	call playSound		; $67e1
_label_11_283:
	ld h,d			; $67e4
	ld l,$c9		; $67e5
	ld c,(hl)		; $67e7
	ld l,$d0		; $67e8
	ld b,(hl)		; $67ea
	call updateLinkPositionGivenVelocity		; $67eb
	jp objectApplySpeed		; $67ee
	ld a,$0b		; $67f1
	call objectGetRelatedObject1Var		; $67f3
	ld e,$cb		; $67f6
	ld a,(de)		; $67f8
	sub (hl)		; $67f9
	cpl			; $67fa
	inc a			; $67fb
	cp $10			; $67fc
	jr c,_label_11_284	; $67fe
	ld a,(de)		; $6800
	inc a			; $6801
	ld (de),a		; $6802
_label_11_284:
	ld a,$04		; $6803
	call objectGetRelatedObject1Var		; $6805
	ld a,(hl)		; $6808
	cp $02			; $6809
	ret z			; $680b
	jp $675e		; $680c
	ld e,$c6		; $680f
	ld a,(de)		; $6811
	or a			; $6812
	jr z,_label_11_285	; $6813
	dec a			; $6815
	ld (de),a		; $6816
	jp objectApplySpeed		; $6817
_label_11_285:
	call $693b		; $681a
	call objectGetRelativeAngle		; $681d
	ld e,$c9		; $6820
	ld (de),a		; $6822
	call objectApplySpeed		; $6823
	call $6970		; $6826
	ret nz			; $6829
	ld e,$c2		; $682a
	ld a,(de)		; $682c
	rlca			; $682d
	jr c,_label_11_287	; $682e
	ld h,d			; $6830
	ld l,$e4		; $6831
	set 7,(hl)		; $6833
	ld e,$f2		; $6835
	ld a,(de)		; $6837
	or a			; $6838
	jr z,_label_11_286	; $6839
	xor a			; $683b
	ld (de),a		; $683c
	call $69a5		; $683d
	ld l,$ab		; $6840
	ld a,(hl)		; $6842
	or a			; $6843
	jr nz,_label_11_286	; $6844
	ld (hl),$3c		; $6846
	ld l,$b5		; $6848
	inc (hl)		; $684a
	ld a,SND_BOSS_DAMAGE		; $684b
	call playSound		; $684d
_label_11_286:
	ld e,$c6		; $6850
	ld a,$3c		; $6852
	ld (de),a		; $6854
	call $69a5		; $6855
	ld l,$b7		; $6858
	ld e,$c2		; $685a
	ld a,(de)		; $685c
	swap a			; $685d
	call setFlag		; $685f
	jr _label_11_288		; $6862
_label_11_287:
	call objectSetInvisible		; $6864
_label_11_288:
	ld e,$c4		; $6867
	ld a,$04		; $6869
	ld (de),a		; $686b
	ret			; $686c
	ld h,d			; $686d
	ld l,$e4		; $686e
	set 7,(hl)		; $6870
	call $68d7		; $6872
	call _partCommon_decCounter1IfNonzero		; $6875
	ret nz			; $6878
	call $69a5		; $6879
	ldi a,(hl)		; $687c
	cp $12			; $687d
	ret nz			; $687f
	ld a,(hl)		; $6880
	bit 5,a			; $6881
	jr nz,_label_11_289	; $6883
	ld e,$c2		; $6885
	ld a,(de)		; $6887
	cp (hl)			; $6888
	jr z,_label_11_289	; $6889
	call objectGetAngleTowardLink		; $688b
	cp $10			; $688e
	ret nz			; $6890
	ld a,(w1Link.direction)		; $6891
	or a			; $6894
	ret nz			; $6895
	ld h,d			; $6896
	ld l,$e4		; $6897
	res 7,(hl)		; $6899
	jp objectAddToGrabbableObjectBuffer		; $689b
_label_11_289:
	ld a,SND_EXPLOSION		; $689e
	call playSound		; $68a0
	call objectGetAngleTowardLink		; $68a3
	ld h,d			; $68a6
	ld l,$c9		; $68a7
	ld (hl),a		; $68a9
	ld l,$c4		; $68aa
	ld (hl),$05		; $68ac
	ld l,$c6		; $68ae
	ld (hl),$02		; $68b0
	ld l,$d0		; $68b2
	ld (hl),$78		; $68b4
	call $69a5		; $68b6
	ld l,$b7		; $68b9
	ld e,$c2		; $68bb
	ld a,(de)		; $68bd
	swap a			; $68be
	jp unsetFlag		; $68c0
	ld a,$04		; $68c3
	call objectGetRelatedObject1Var		; $68c5
	ld a,(hl)		; $68c8
	cp $04			; $68c9
	jr z,_label_11_290	; $68cb
	ld e,l			; $68cd
	ld (de),a		; $68ce
	ld l,$c9		; $68cf
	ld e,l			; $68d1
	ld a,(hl)		; $68d2
	ld (de),a		; $68d3
	jp objectSetVisible		; $68d4
_label_11_290:
	call $693b		; $68d7
	ld h,d			; $68da
	ld l,$cb		; $68db
	ld (hl),b		; $68dd
	ld l,$cd		; $68de
	ld (hl),c		; $68e0
	ret			; $68e1
	call _partCommon_getTileCollisionInFront		; $68e2
	jr nz,_label_11_292	; $68e5
	call objectApplySpeed		; $68e7
	call _partCommon_decCounter1IfNonzero		; $68ea
	ret nz			; $68ed
	ld (hl),$03		; $68ee
	ld e,$d0		; $68f0
	ld a,(de)		; $68f2
	or a			; $68f3
	jp z,$68fe		; $68f4
	sub $0a			; $68f7
	jr nc,_label_11_291	; $68f9
	xor a			; $68fb
_label_11_291:
	ld (de),a		; $68fc
	ret			; $68fd
_label_11_292:
	ld h,d			; $68fe
	ld l,$c4		; $68ff
	ld (hl),$06		; $6901
	ld l,$c6		; $6903
	ld (hl),$3c		; $6905
	ld l,$d0		; $6907
	ld (hl),$00		; $6909
	ret			; $690b
	ld a,$10		; $690c
	call objectGetRelatedObject1Var		; $690e
	ld e,l			; $6911
	ld a,(hl)		; $6912
	sub $19			; $6913
	jr nc,_label_11_293	; $6915
	xor a			; $6917
_label_11_293:
	ld (de),a		; $6918
	ld l,$c4		; $6919
	ld a,(hl)		; $691b
	cp $03			; $691c
	jp nz,objectApplySpeed		; $691e
	jp $6762		; $6921
	call _partCommon_decCounter1IfNonzero		; $6924
	ret nz			; $6927
	ld l,$e4		; $6928
	res 7,(hl)		; $692a
	call $69a5		; $692c
	inc l			; $692f
	ld a,(hl)		; $6930
	bit 5,a			; $6931
	jr z,_label_11_294	; $6933
	ld a,$80		; $6935
	ld (hl),a		; $6937
_label_11_294:
	jp $6762		; $6938
	ld e,$c2		; $693b
	ld a,(de)		; $693d
	swap a			; $693e
	ld c,$0c		; $6940
	rrca			; $6942
	jr nc,_label_11_295	; $6943
	ld c,$f4		; $6945
_label_11_295:
	ld e,$f0		; $6947
	ld a,(de)		; $6949
	ld h,a			; $694a
	ld l,$8b		; $694b
	ldi a,(hl)		; $694d
	add $0c			; $694e
	ld b,a			; $6950
	inc l			; $6951
	ld a,(hl)		; $6952
	add c			; $6953
	ld c,a			; $6954
	ret			; $6955
	ld e,$c2		; $6956
	ld a,(de)		; $6958
	and $0f			; $6959
	cp $02			; $695b
	ret z			; $695d
	call getFreePartSlot		; $695e
	ld a,$35		; $6961
	ldi (hl),a		; $6963
	ld a,(de)		; $6964
	inc a			; $6965
	ld (hl),a		; $6966
	ld e,$f0		; $6967
	ld l,e			; $6969
	ld a,(de)		; $696a
	ld (hl),a		; $696b
	ld l,$c2		; $696c
	ld e,l			; $696e
	ret			; $696f
	call $693b		; $6970
	ld e,$03		; $6973
	ld h,d			; $6975
	ld l,$cb		; $6976
	ld a,e			; $6978
	add b			; $6979
	cp (hl)			; $697a
	jr c,_label_11_296	; $697b
	sub e			; $697d
	sub e			; $697e
	cp (hl)			; $697f
	jr nc,_label_11_296	; $6980
	ld l,$cd		; $6982
	ld a,e			; $6984
	add c			; $6985
	cp (hl)			; $6986
	jr c,_label_11_296	; $6987
	sub e			; $6989
	sub e			; $698a
	cp (hl)			; $698b
	jr nc,_label_11_296	; $698c
	xor a			; $698e
	ret			; $698f
_label_11_296:
	or d			; $6990
	ret			; $6991
	push hl			; $6992
	ld a,(hl)		; $6993
	and $10			; $6994
	swap a			; $6996
	ld hl,$69a3		; $6998
	rst_addAToHl			; $699b
	ld c,(hl)		; $699c
	ld b,$fc		; $699d
	pop hl			; $699f
	jp objectCopyPositionWithOffset		; $69a0
	ld hl,sp+$08		; $69a3
	ld e,$f0		; $69a5
	ld a,(de)		; $69a7
	ld h,a			; $69a8
	ld l,$82		; $69a9
	ret			; $69ab


; ==============================================================================
; PARTID_CANDLE_FLAME
; ==============================================================================
partCode36:
	ld a,Object.id		; $69ac
	call objectGetRelatedObject1Var		; $69ae
	ld a,(hl)		; $69b1
	cp ENEMYID_CANDLE			; $69b2
	jp nz,partDelete		; $69b4

	ld b,h			; $69b7
	ld e,Part.state		; $69b8
	ld a,(de)		; $69ba
	rst_jumpTable			; $69bb
	.dw @state0
	.dw @state1
	.dw @state2


@state0:
	ld h,d			; $69c2
	ld l,e			; $69c3
	inc (hl) ; [state]
	call objectSetVisible81		; $69c5

@state1:
	; Check parent's speed
	ld h,b			; $69c8
	ld l,Enemy.speed		; $69c9
	ld a,(hl)		; $69cb
	cp SPEED_100			; $69cc
	jr z,@state2	; $69ce

	ld a,$02		; $69d0
	ld (de),a ; [state]

	push bc			; $69d3
	dec a			; $69d4
	call partSetAnimation		; $69d5
	pop bc			; $69d8

@state2:
	ld h,b			; $69d9
	ld l,Enemy.enemyCollisionMode		; $69da
	ld a,(hl)		; $69dc
	cp ENEMYCOLLISION_PODOBOO			; $69dd
	jp z,partDelete		; $69df

	call objectTakePosition		; $69e2
	ld e,Part.zh		; $69e5
	ld a,$f3		; $69e7
	ld (de),a		; $69e9
	jp partAnimate		; $69ea


; ==============================================================================
; PARTID_VERAN_PROJECTILE
; ==============================================================================
partCode37:
	jp nz,partDelete		; $69ed

	ld e,Part.subid		; $69f0
	ld a,(de)		; $69f2
	or a			; $69f3
	jp nz,_veranProjectile_subid1		; $69f4


; The "core" projectile spawner
_veranProjectile_subid0:
	ld a,Object.collisionType		; $69f7
	call objectGetRelatedObject1Var		; $69f9
	bit 7,(hl)		; $69fc
	jr z,@delete	; $69fe

	ld e,Part.state		; $6a00
	ld a,(de)		; $6a02
	rst_jumpTable			; $6a03
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d			; $6a0a
	ld l,e			; $6a0b
	inc (hl) ; [state]

	ld l,Part.zh		; $6a0d
	ld (hl),$fc		; $6a0f
	jp objectSetVisible81		; $6a11


; Moving upward
@state1:
	ld h,d			; $6a14
	ld l,Part.zh		; $6a15
	dec (hl)		; $6a17

	ld a,(hl)		; $6a18
	cp $f0			; $6a19
	jr nz,@animate	; $6a1b

	; Moved high enough to go to next state

	ld l,e			; $6a1d
	inc (hl) ; [state]

	ld l,Part.counter1		; $6a1f
	ld (hl),129		; $6a21
	jr @animate		; $6a23


; Firing projectiles every 8 frames until counter1 reaches 0
@state2:
	call _partCommon_decCounter1IfNonzero		; $6a25
	jr z,@delete	; $6a28

	ld a,(hl)		; $6a2a
	and $07			; $6a2b
	jr nz,@animate	; $6a2d

	; Calculate angle in 'b' based on counter1
	ld a,(hl)		; $6a2f
	rrca			; $6a30
	rrca			; $6a31
	and $1f			; $6a32
	ld b,a			; $6a34

	; Create a projectile
	call getFreePartSlot		; $6a35
	jr nz,@animate	; $6a38
	ld (hl),PARTID_VERAN_PROJECTILE		; $6a3a
	inc l			; $6a3c
	inc (hl) ; [subid] = 1

	ld l,Part.angle		; $6a3e
	ld (hl),b		; $6a40

	call objectCopyPosition		; $6a41

@animate:
	jp partAnimate		; $6a44

@delete:
	ldbc INTERACID_PUFF,$80		; $6a47
	call objectCreateInteraction		; $6a4a
	jp partDelete		; $6a4d


; An individiual projectile
_veranProjectile_subid1:
	ld e,Part.state		; $6a50
	ld a,(de)		; $6a52
	rst_jumpTable			; $6a53
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d			; $6a5a
	ld l,e			; $6a5b
	inc (hl) ; [state]

	ld l,Part.speed		; $6a5d
	ld (hl),SPEED_280		; $6a5f

	ld l,Part.collisionRadiusY		; $6a61
	ld a,$04		; $6a63
	ldi (hl),a		; $6a65
	ld (hl),a		; $6a66

	call objectSetVisible81		; $6a67

	ld a,SND_VERAN_PROJECTILE		; $6a6a
	call playSound		; $6a6c

	ld a,$01		; $6a6f
	jp partSetAnimation		; $6a71


; Moving to ground as well as in normal direction
@state1:
	ld h,d			; $6a74
	ld l,Part.zh		; $6a75
	inc (hl)		; $6a77
	jr nz,@state2	; $6a78

	ld l,e			; $6a7a
	inc (hl) ; [state]


; Just moving normally
@state2:
	call objectApplySpeed		; $6a7c
	call _partCommon_checkTileCollisionOrOutOfBounds		; $6a7f
	ret nz			; $6a82
	jp partDelete		; $6a83

;;
; @addr{6a86}
partCode38:
	jr z,_label_11_301	; $6a86
	ld e,$ea		; $6a88
	ld a,(de)		; $6a8a
	cp $80			; $6a8b
	jp z,partDelete		; $6a8d
	ld h,d			; $6a90
	ld l,$c4		; $6a91
	ld a,(hl)		; $6a93
	cp $02			; $6a94
	jr nc,_label_11_301	; $6a96
	ld (hl),$02		; $6a98
_label_11_301:
	ld h,d			; $6a9a
	ld l,$c6		; $6a9b
	ld a,(hl)		; $6a9d
	or a			; $6a9e
	jr z,_label_11_302	; $6a9f
	dec (hl)		; $6aa1
	ret			; $6aa2
_label_11_302:
	ld e,$c4		; $6aa3
	ld a,(de)		; $6aa5
	rst_jumpTable			; $6aa6
.dw $6aaf
.dw $6ae7
.dw $6b0c
.dw $6b24
	ld h,d			; $6aaf
	ld l,e			; $6ab0
	inc (hl)		; $6ab1
	ld l,$c9		; $6ab2
	ld (hl),$10		; $6ab4
	call objectSetVisible81		; $6ab6
	call getRandomNumber		; $6ab9
	and $0f			; $6abc
	ld hl,$6ad7		; $6abe
	rst_addAToHl			; $6ac1
	ld a,(hl)		; $6ac2
	ld h,d			; $6ac3
	ld l,$d0		; $6ac4
	or a			; $6ac6
	jr nz,_label_11_303	; $6ac7
	ld (hl),$64		; $6ac9
	ld a,SND_THROW		; $6acb
	jp playSound		; $6acd
_label_11_303:
	ld (hl),$3c		; $6ad0
	ld a,SND_FALLINHOLE		; $6ad2
	jp playSound		; $6ad4
	ld bc,$0101		; $6ad7
	ld bc,$0000		; $6ada
	nop			; $6add
	nop			; $6ade
	nop			; $6adf
	nop			; $6ae0
	nop			; $6ae1
	nop			; $6ae2
	nop			; $6ae3
	nop			; $6ae4
	nop			; $6ae5
	nop			; $6ae6
	call objectCheckWithinScreenBoundary		; $6ae7
	jp nc,$6c17		; $6aea
	call _partCommon_checkTileCollisionOrOutOfBounds		; $6aed
	jr nc,_label_11_304	; $6af0
	call $6b00		; $6af2
	jr nc,_label_11_304	; $6af5
	jp z,$6c17		; $6af7
	jp $6bf6		; $6afa
_label_11_304:
	jp objectApplySpeed		; $6afd
	scf			; $6b00
	push af			; $6b01
	ld a,(hl)		; $6b02
	cp $0f			; $6b03
	jr z,_label_11_305	; $6b05
	pop af			; $6b07
	ccf			; $6b08
	ret			; $6b09
_label_11_305:
	pop af			; $6b0a
	ret			; $6b0b
	ld a,$03		; $6b0c
	ld (de),a		; $6b0e
	ld a,SND_CLINK		; $6b0f
	call playSound		; $6b11
	ld h,d			; $6b14
	ld l,$c6		; $6b15
	ld (hl),$00		; $6b17
	ld l,$d0		; $6b19
	ld (hl),$78		; $6b1b
	ld l,$ec		; $6b1d
	ld a,(hl)		; $6b1f
	ld l,$c9		; $6b20
	ld (hl),a		; $6b22
	ret			; $6b23
	call objectCheckWithinScreenBoundary		; $6b24
	jp nc,$6c17		; $6b27
	ld b,$ff		; $6b2a
	call $6b5f		; $6b2c
	call _partCommon_checkTileCollisionOrOutOfBounds		; $6b2f
	jr nc,_label_11_306	; $6b32
	call $6b00		; $6b34
	jr nc,_label_11_306	; $6b37
	jp z,$6c17		; $6b39
	call $6c02		; $6b3c
_label_11_306:
	ld b,$02		; $6b3f
	call $6b5f		; $6b41
	call _partCommon_checkTileCollisionOrOutOfBounds		; $6b44
	jr nc,_label_11_307	; $6b47
	call $6b00		; $6b49
	jr nc,_label_11_307	; $6b4c
	jp z,$6c17		; $6b4e
	call $6c08		; $6b51
_label_11_307:
	ld b,$ff		; $6b54
	call $6b5f		; $6b56
	call partAnimate		; $6b59
	jp objectApplySpeed		; $6b5c
	ld e,$cd		; $6b5f
	ld a,(de)		; $6b61
	add b			; $6b62
	ld (de),a		; $6b63
	ret			; $6b64
	call objectGetTileAtPosition		; $6b65
	ld a,l			; $6b68
	ldh (<hFF8C),a	; $6b69
	ld c,(hl)		; $6b6b
	call $6b71		; $6b6c
	jr _label_11_311		; $6b6f
	ld a,$ff		; $6b71
	ld ($cfd5),a		; $6b73
	xor a			; $6b76
_label_11_308:
	ldh (<hFF8B),a	; $6b77
	ld hl,$6bab		; $6b79
	rst_addAToHl			; $6b7c
	ld a,(hl)		; $6b7d
	cp c			; $6b7e
	jr nz,_label_11_310	; $6b7f
	ld a,($ccd6)		; $6b81
	and $7f			; $6b84
	cp $01			; $6b86
	ldh a,(<hFF8B)	; $6b88
	ld ($cfd5),a		; $6b8a
	jr z,_label_11_309	; $6b8d
	add $04			; $6b8f
_label_11_309:
	ld hl,bitTable		; $6b91
	add l			; $6b94
	ld l,a			; $6b95
	ld a,($ccd4)		; $6b96
	or (hl)			; $6b99
	ld ($ccd4),a		; $6b9a
	jr $10			; $6b9d
_label_11_310:
	ldh a,(<hFF8B)	; $6b9f
	inc a			; $6ba1
	cp $04			; $6ba2
	jr nz,_label_11_308	; $6ba4
	ld hl,$ccd6		; $6ba6
	dec (hl)		; $6ba9
	ret			; $6baa
	reti			; $6bab
	rst_addAToHl			; $6bac
	call c,$cdd8		; $6bad
	sub (hl)		; $6bb0
	jr nz,_label_11_315	; $6bb1
	ld a,$a0		; $6bb3
	call setTile		; $6bb5
	ld h,d			; $6bb8
	ld l,$c6		; $6bb9
	ld (hl),$03		; $6bbb
	ld a,($ccd6)		; $6bbd
	and $7f			; $6bc0
	cp $01			; $6bc2
	ret nz			; $6bc4
	ld a,SND_SWITCH		; $6bc5
	jp playSound		; $6bc7
_label_11_311:
	ld a,($cfd5)		; $6bca
	cp $ff			; $6bcd
	ret z			; $6bcf
	ld a,$04		; $6bd0
_label_11_312:
	ldh (<hFF8B),a	; $6bd2
	ld bc,$9204		; $6bd4
	ld a,($cfd5)		; $6bd7
	cp $02			; $6bda
	jr c,_label_11_313	; $6bdc
	ld bc,$9205		; $6bde
_label_11_313:
	call objectCreateInteraction		; $6be1
	jr nz,_label_11_314	; $6be4
	ld l,$4b		; $6be6
	ldh a,(<hFF8C)	; $6be8
	call setShortPosition		; $6bea
	ld l,$49		; $6bed
	ldh a,(<hFF8B)	; $6bef
	dec a			; $6bf1
	ld (hl),a		; $6bf2
	jr nz,_label_11_312	; $6bf3
_label_11_314:
	ret			; $6bf5
	ld a,SND_STRIKE		; $6bf6
	call playSound		; $6bf8
	ld a,$01		; $6bfb
	ld ($cfd6),a		; $6bfd
	jr _label_11_316		; $6c00
_label_11_315:
	call $6c0e		; $6c02
	jp $6b65		; $6c05
	call $6c0e		; $6c08
	jp $6b65		; $6c0b
	xor a			; $6c0e
	ld ($cfd6),a		; $6c0f
	ld hl,$ccd6		; $6c12
	inc (hl)		; $6c15
	ret			; $6c16
	xor a			; $6c17
	ld ($cfd6),a		; $6c18
	ld a,($ccd6)		; $6c1b
	and $7f			; $6c1e
	jr nz,_label_11_316	; $6c20
	ld a,SND_ERROR		; $6c22
	call playSound		; $6c24
_label_11_316:
	ld hl,$ccd6		; $6c27
	set 7,(hl)		; $6c2a
	jp partDelete		; $6c2c

;;
; @addr{6c2f}
partCode39:
	ld e,$c4		; $6c2f
	ld a,(de)		; $6c31
	rst_jumpTable			; $6c32
.dw $6c39
.dw $6c6a
.dw $6caa
	ld h,d			; $6c39
	ld l,e			; $6c3a
	inc (hl)		; $6c3b
	ld l,$c6		; $6c3c
	ld (hl),$1e		; $6c3e
	ld l,$d4		; $6c40
	ld a,$20		; $6c42
	ldi (hl),a		; $6c44
	ld (hl),$fc		; $6c45
	call getRandomNumber_noPreserveVars		; $6c47
	and $10			; $6c4a
	add $08			; $6c4c
	ld e,$c9		; $6c4e
	ld (de),a		; $6c50
	call getRandomNumber_noPreserveVars		; $6c51
	and $03			; $6c54
	ld hl,$6c66		; $6c56
	rst_addAToHl			; $6c59
	ld e,$d0		; $6c5a
	ld a,(hl)		; $6c5c
	ld (de),a		; $6c5d
	call objectSetVisible82		; $6c5e
	ld a,SND_FALLINHOLE		; $6c61
	jp playSound		; $6c63
	rrca			; $6c66
	add hl,de		; $6c67
	inc hl			; $6c68
	dec l			; $6c69
	call objectApplySpeed		; $6c6a
	ld h,d			; $6c6d
	ld l,$d4		; $6c6e
	ld e,$ca		; $6c70
	call add16BitRefs		; $6c72
	dec l			; $6c75
	ld a,(hl)		; $6c76
	add $20			; $6c77
	ldi (hl),a		; $6c79
	ld a,(hl)		; $6c7a
	adc $00			; $6c7b
	ld (hl),a		; $6c7d
	call _partCommon_decCounter1IfNonzero		; $6c7e
	jr nz,_label_11_317	; $6c81
	ld a,(de)		; $6c83
	cp $b0			; $6c84
	jp nc,partDelete		; $6c86
	add $06			; $6c89
	ld b,a			; $6c8b
	ld l,$cd		; $6c8c
	ld c,(hl)		; $6c8e
	call checkTileCollisionAt_allowHoles		; $6c8f
	jr nc,_label_11_317	; $6c92
	ld h,d			; $6c94
	ld l,$c4		; $6c95
	inc (hl)		; $6c97
	ld l,$db		; $6c98
	ld a,$0b		; $6c9a
	ldi (hl),a		; $6c9c
	ldi (hl),a		; $6c9d
	ld (hl),$26		; $6c9e
	ld a,$01		; $6ca0
	call partSetAnimation		; $6ca2
	ld a,SND_BREAK_ROCK		; $6ca5
	jp playSound		; $6ca7
	ld e,$e1		; $6caa
	ld a,(de)		; $6cac
	bit 7,a			; $6cad
	jp nz,partDelete		; $6caf
	ld hl,$6cc0		; $6cb2
	rst_addAToHl			; $6cb5
	ld e,$e6		; $6cb6
	ldi a,(hl)		; $6cb8
	ld (de),a		; $6cb9
	inc e			; $6cba
	ld a,(hl)		; $6cbb
	ld (de),a		; $6cbc
_label_11_317:
	jp partAnimate		; $6cbd
	inc b			; $6cc0
	add hl,bc		; $6cc1
	ld b,$0b		; $6cc2
	add hl,bc		; $6cc4
	inc c			; $6cc5
	ld a,(bc)		; $6cc6
	dec c			; $6cc7
	dec bc			; $6cc8
	.db $0e

;;
; @addr{6cca}
partCode3a:
	jr z,+	 		; $6cca
	ld e,$ea		; $6ccc
	ld a,(de)		; $6cce
	res 7,a			; $6ccf
	cp $04			; $6cd1
	jp c,partDelete		; $6cd3
	jp $6e4a		; $6cd6
+
	ld e,$c2		; $6cd9
	ld a,(de)		; $6cdb
	ld e,$c4		; $6cdc
	rst_jumpTable			; $6cde
.dw $6ce7
.dw $6d06
.dw $6d39
.dw $6dfd
	ld a,(de)		; $6ce7
	or a			; $6ce8
	jr z,_label_11_319	; $6ce9
_label_11_318:
	call _partCommon_checkOutOfBounds		; $6ceb
	jp z,partDelete		; $6cee
	call objectApplySpeed		; $6cf1
	jp partAnimate		; $6cf4
_label_11_319:
	call $6e50		; $6cf7
	call objectGetAngleTowardEnemyTarget		; $6cfa
	ld e,$c9		; $6cfd
	ld (de),a		; $6cff
	call $6e5d		; $6d00
	jp objectSetVisible80		; $6d03
	ld a,(de)		; $6d06
	or a			; $6d07
	jr nz,_label_11_318	; $6d08
	call $6e50		; $6d0a
	call $6e2f		; $6d0d
	ld e,$c3		; $6d10
	ld a,(de)		; $6d12
	or a			; $6d13
	ret nz			; $6d14
	call objectGetAngleTowardEnemyTarget		; $6d15
	ld e,$c9		; $6d18
	ld (de),a		; $6d1a
	sub $02			; $6d1b
	and $1f			; $6d1d
	ld b,a			; $6d1f
	ld e,$01		; $6d20
	call getFreePartSlot		; $6d22
	ld (hl),$3a		; $6d25
	inc l			; $6d27
	ld (hl),e		; $6d28
	inc l			; $6d29
	inc (hl)		; $6d2a
	ld l,$c9		; $6d2b
	ld (hl),b		; $6d2d
	ld l,$d6		; $6d2e
	ld e,l			; $6d30
	ld a,(de)		; $6d31
	ldi (hl),a		; $6d32
	inc e			; $6d33
	ld a,(de)		; $6d34
	ld (hl),a		; $6d35
	jp objectCopyPosition		; $6d36
	ld a,(de)		; $6d39
	rst_jumpTable			; $6d3a
.dw $6d43
.dw $6d84
.dw $6dc6
.dw $6ceb
	ld h,d			; $6d43
	ld l,$db		; $6d44
	ld a,$03		; $6d46
	ldi (hl),a		; $6d48
	ld (hl),a		; $6d49
	ld l,$c3		; $6d4a
	ld a,(hl)		; $6d4c
	or a			; $6d4d
	jr z,_label_11_320	; $6d4e
	ld l,e			; $6d50
	ld (hl),$03		; $6d51
	call $6e5d		; $6d53
	ld a,$01		; $6d56
	call partSetAnimation		; $6d58
	jp objectSetVisible82		; $6d5b
_label_11_320:
	call $6e50		; $6d5e
	ld l,$f0		; $6d61
	ldh a,(<hEnemyTargetY)	; $6d63
	ldi (hl),a		; $6d65
	ldh a,(<hEnemyTargetX)	; $6d66
	ld (hl),a		; $6d68
	ld a,$29		; $6d69
	call objectGetRelatedObject1Var		; $6d6b
	ld a,(hl)		; $6d6e
	ld b,$19		; $6d6f
	cp $10			; $6d71
	jr nc,_label_11_321	; $6d73
	ld b,$2d		; $6d75
	cp $0a			; $6d77
	jr nc,_label_11_321	; $6d79
	ld b,$41		; $6d7b
_label_11_321:
	ld e,$d0		; $6d7d
	ld a,b			; $6d7f
	ld (de),a		; $6d80
	jp objectSetVisible80		; $6d81
	ld h,d			; $6d84
	ld l,$f0		; $6d85
	ld b,(hl)		; $6d87
	inc l			; $6d88
	ld c,(hl)		; $6d89
	ld l,$cb		; $6d8a
	ldi a,(hl)		; $6d8c
	ldh (<hFF8F),a	; $6d8d
	inc l			; $6d8f
	ld a,(hl)		; $6d90
	ldh (<hFF8E),a	; $6d91
	sub c			; $6d93
	add $02			; $6d94
	cp $05			; $6d96
	jr nc,_label_11_322	; $6d98
	ldh a,(<hFF8F)	; $6d9a
	sub b			; $6d9c
	add $02			; $6d9d
	cp $05			; $6d9f
	jr nc,_label_11_322	; $6da1
	ld bc,$0502		; $6da3
	call objectCreateInteraction		; $6da6
	ret nz			; $6da9
	ld e,$d8		; $6daa
	ld a,$40		; $6dac
	ld (de),a		; $6dae
	inc e			; $6daf
	ld a,h			; $6db0
	ld (de),a		; $6db1
	ld e,$c4		; $6db2
	ld a,$02		; $6db4
	ld (de),a		; $6db6
	jp objectSetInvisible		; $6db7
_label_11_322:
	call objectGetRelativeAngleWithTempVars		; $6dba
	ld e,$c9		; $6dbd
	ld (de),a		; $6dbf
	call objectApplySpeed		; $6dc0
	jp partAnimate		; $6dc3
	ld a,$21		; $6dc6
	call objectGetRelatedObject2Var		; $6dc8
	bit 7,(hl)		; $6dcb
	ret z			; $6dcd
	ld b,$05		; $6dce
	call checkBPartSlotsAvailable		; $6dd0
	ret nz			; $6dd3
	ld c,$05		; $6dd4
_label_11_323:
	ld a,c			; $6dd6
	dec a			; $6dd7
	ld hl,$6df8		; $6dd8
	rst_addAToHl			; $6ddb
	ld b,(hl)		; $6ddc
	ld e,$02		; $6ddd
	call $6d22		; $6ddf
	dec c			; $6de2
	jr nz,_label_11_323	; $6de3
	ld h,d			; $6de5
	ld l,$c4		; $6de6
	inc (hl)		; $6de8
	ld l,$c9		; $6de9
	ld (hl),$1d		; $6deb
	call $6e5d		; $6ded
	ld a,$01		; $6df0
	call partSetAnimation		; $6df2
	jp objectSetVisible82		; $6df5
	inc bc			; $6df8
	ld ($130d),sp		; $6df9
	jr $1a			; $6dfc
	or a			; $6dfe
	jr z,_label_11_325	; $6dff
	call _partCommon_decCounter1IfNonzero		; $6e01
	jp z,$6e4a		; $6e04
	inc l			; $6e07
	dec (hl)		; $6e08
	jr nz,_label_11_324	; $6e09
	ld (hl),$07		; $6e0b
	call objectGetAngleTowardEnemyTarget		; $6e0d
	call objectNudgeAngleTowards		; $6e10
_label_11_324:
	call objectApplySpeed		; $6e13
	jp partAnimate		; $6e16
_label_11_325:
	call $6e50		; $6e19
	ld l,$c6		; $6e1c
	ld (hl),$f0		; $6e1e
	inc l			; $6e20
	ld (hl),$07		; $6e21
	ld l,$db		; $6e23
	ld a,$02		; $6e25
	ldi (hl),a		; $6e27
	ld (hl),a		; $6e28
	call objectGetAngleTowardEnemyTarget		; $6e29
	ld e,$c9		; $6e2c
	ld (de),a		; $6e2e
	ld a,$29		; $6e2f
	call objectGetRelatedObject1Var		; $6e31
	ld a,(hl)		; $6e34
	ld b,$1e		; $6e35
	cp $10			; $6e37
	jr nc,_label_11_326	; $6e39
	ld b,$2d		; $6e3b
	cp $0a			; $6e3d
	jr nc,_label_11_326	; $6e3f
	ld b,$3c		; $6e41
_label_11_326:
	ld e,$d0		; $6e43
	ld a,b			; $6e45
	ld (de),a		; $6e46
	jp objectSetVisible80		; $6e47
	call objectCreatePuff		; $6e4a
	jp partDelete		; $6e4d
	ld h,d			; $6e50
	ld l,e			; $6e51
	inc (hl)		; $6e52
	ld l,$cf		; $6e53
	ld a,(hl)		; $6e55
	ld (hl),$00		; $6e56
	ld l,$cb		; $6e58
	add (hl)		; $6e5a
	ld (hl),a		; $6e5b
	ret			; $6e5c
	ld a,$29		; $6e5d
	call objectGetRelatedObject1Var		; $6e5f
	ld a,(hl)		; $6e62
	ld b,$3c		; $6e63
	cp $10			; $6e65
	jr nc,_label_11_327	; $6e67
	ld b,$5a		; $6e69
	cp $0a			; $6e6b
	jr nc,_label_11_327	; $6e6d
	ld b,$78		; $6e6f
_label_11_327:
	ld e,$d0		; $6e71
	ld a,b			; $6e73
	ld (de),a		; $6e74
	ret			; $6e75

;;
; @addr{6e76}
partCode3b:
	ld e,$c2		; $6e76
	ld a,(de)		; $6e78
	ld e,$c4		; $6e79
	or a			; $6e7b
	jr z,_label_11_328	; $6e7c
	jp $6ef3		; $6e7e
_label_11_328:
	ld a,(de)		; $6e81
	rst_jumpTable			; $6e82
.dw $6e89
.dw $6eae
.dw $6ed3
	ld h,d			; $6e89
	ld l,e			; $6e8a
	inc (hl)		; $6e8b
	ld l,$d5		; $6e8c
	ld (hl),$02		; $6e8e
	ld l,$cb		; $6e90
	ldh a,(<hCameraY)	; $6e92
	ldi (hl),a		; $6e94
	inc l			; $6e95
	ld a,(hl)		; $6e96
	or a			; $6e97
	jr nz,_label_11_329	; $6e98
	call getRandomNumber_noPreserveVars		; $6e9a
	and $7c			; $6e9d
	ld b,a			; $6e9f
	ldh a,(<hCameraX)	; $6ea0
	add b			; $6ea2
	ld e,$cd		; $6ea3
	ld (de),a		; $6ea5
_label_11_329:
	call objectSetVisible82		; $6ea6
	ld a,SND_FALLINHOLE		; $6ea9
	jp playSound		; $6eab
	ld a,$20		; $6eae
	call objectUpdateSpeedZ_sidescroll		; $6eb0
	jr c,_label_11_330	; $6eb3
	ld a,(de)		; $6eb5
	cp $b0			; $6eb6
	jr c,_label_11_331	; $6eb8
	jp partDelete		; $6eba
_label_11_330:
	ld h,d			; $6ebd
	ld l,$c4		; $6ebe
	inc (hl)		; $6ec0
	ld l,$db		; $6ec1
	ld a,$0b		; $6ec3
	ldi (hl),a		; $6ec5
	ldi (hl),a		; $6ec6
	ld (hl),$02		; $6ec7
	ld a,$01		; $6ec9
	call partSetAnimation		; $6ecb
	ld a,SND_BREAK_ROCK		; $6ece
	jp playSound		; $6ed0
	ld e,$e1		; $6ed3
	ld a,(de)		; $6ed5
	bit 7,a			; $6ed6
	jp nz,partDelete		; $6ed8
	ld hl,$6ee9		; $6edb
	rst_addAToHl			; $6ede
	ld e,$e6		; $6edf
	ldi a,(hl)		; $6ee1
	ld (de),a		; $6ee2
	inc e			; $6ee3
	ld a,(hl)		; $6ee4
	ld (de),a		; $6ee5
_label_11_331:
	jp partAnimate		; $6ee6
	inc b			; $6ee9
	add hl,bc		; $6eea
	ld b,$0b		; $6eeb
	add hl,bc		; $6eed
	inc c			; $6eee
	ld a,(bc)		; $6eef
	dec c			; $6ef0
	dec bc			; $6ef1
	ld c,$1a		; $6ef2
	rst_jumpTable			; $6ef4
.dw $6efb
.dw $6f23
.dw $6ed3
	ld h,d			; $6efb
	ld l,e			; $6efc
	inc (hl)		; $6efd
	ld l,$d5		; $6efe
	ld (hl),$02		; $6f00
	ld l,$cb		; $6f02
	ldi a,(hl)		; $6f04
	inc l			; $6f05
	or (hl)			; $6f06
	jr nz,_label_11_332	; $6f07
	call getRandomNumber_noPreserveVars		; $6f09
	and $7c			; $6f0c
	ld b,a			; $6f0e
	ldh a,(<hRng2)	; $6f0f
	and $7c			; $6f11
	ld c,a			; $6f13
	ld e,$cb		; $6f14
	ldh a,(<hCameraY)	; $6f16
	add b			; $6f18
	ld (de),a		; $6f19
	ld e,$cd		; $6f1a
	ldh a,(<hCameraX)	; $6f1c
	add c			; $6f1e
	ld (de),a		; $6f1f
_label_11_332:
	jp objectSetVisiblec2		; $6f20
	ld c,$20		; $6f23
	call objectUpdateSpeedZ_paramC		; $6f25
	jr nz,_label_11_331	; $6f28
	jr _label_11_330		; $6f2a

;;
; @addr{6f2c}
partCode3c:
	jp nz,partDelete		; $6f2c
	ld e,$c4		; $6f2f
	ld a,(de)		; $6f31
	or a			; $6f32
	jr z,_label_11_334	; $6f33
	call _partCommon_checkOutOfBounds		; $6f35
	jp z,partDelete		; $6f38
	call _partCommon_decCounter1IfNonzero		; $6f3b
	jr nz,_label_11_333	; $6f3e
	inc l			; $6f40
	ld e,$f0		; $6f41
	ld a,(de)		; $6f43
	inc a			; $6f44
	and $01			; $6f45
	ld (de),a		; $6f47
	add (hl)		; $6f48
	ldd (hl),a		; $6f49
	ld (hl),a		; $6f4a
	ld l,$c9		; $6f4b
	ld e,$c2		; $6f4d
	ld a,(de)		; $6f4f
	add (hl)		; $6f50
	and $1f			; $6f51
	ld (hl),a		; $6f53
_label_11_333:
	call objectApplySpeed		; $6f54
	jp partAnimate		; $6f57
_label_11_334:
	ld h,d			; $6f5a
	ld l,e			; $6f5b
	inc (hl)		; $6f5c
	ld l,$c6		; $6f5d
	ld a,$02		; $6f5f
	ldi (hl),a		; $6f61
	ld (hl),a		; $6f62
	ld l,$d0		; $6f63
	ld (hl),$64		; $6f65
	call objectSetVisible82		; $6f67
	ld a,SND_BEAM		; $6f6a
	jp playSound		; $6f6c


; ==============================================================================
; PARTID_BLUE_STALFOS_PROJECTILE
;
; Variables:
;   var03: 0 for reflectable ball type, 1 otherwise
;   relatedObj1: Instance of ENEMYID_BLUE_STALFOS
; ==============================================================================
partCode3d:
	jr z,@normalStatus	; $6f6f

	ld h,d			; $6f71
	ld l,Part.subid		; $6f72
	ldi a,(hl)		; $6f74
	or (hl)			; $6f75
	jr nz,@normalStatus	; $6f76

	; Check if hit Link
	ld l,Part.var2a		; $6f78
	ld a,(hl)		; $6f7a
	res 7,a			; $6f7b
	or a ; ITEMCOLLISION_LINK
	jp z,_blueStalfosProjectile_hitLink		; $6f7e

	; Check if hit Link's sword
	sub ITEMCOLLISION_L1_SWORD			; $6f81
	cp ITEMCOLLISION_SWORDSPIN - ITEMCOLLISION_L1_SWORD + 1			; $6f83
	jr nc,@normalStatus	; $6f85

	; Reflect the ball if not already reflected
	ld l,Part.state		; $6f87
	ld a,(hl)		; $6f89
	cp $04			; $6f8a
	jr nc,@normalStatus	; $6f8c

	ld (hl),$04		; $6f8e
	ld l,Part.speed		; $6f90
	ld (hl),SPEED_200		; $6f92
	ld a,SND_UNKNOWN3		; $6f94
	call playSound		; $6f96

@normalStatus:
	ld e,Part.subid		; $6f99
	ld a,(de)		; $6f9b
	rst_jumpTable			; $6f9c
	.dw _blueStalfosProjectile_subid0
	.dw _blueStalfosProjectile_subid1


_blueStalfosProjectile_subid0:
	ld e,Part.state		; $6fa1
	ld a,(de)		; $6fa3
	rst_jumpTable			; $6fa4
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

; Initialization, deciding which ball type this should be
@state0:
	ld h,d			; $6fb3
	ld l,e			; $6fb4
	inc (hl) ; [state]

	ld l,Part.counter1		; $6fb6
	ld (hl),40		; $6fb8

	ld l,Part.yh		; $6fba
	ld a,(hl)		; $6fbc
	sub $18			; $6fbd
	ld (hl),a		; $6fbf

	ld l,Part.speed		; $6fc0
	ld (hl),SPEED_180		; $6fc2

	push hl			; $6fc4
	ld a,Object.var32		; $6fc5
	call objectGetRelatedObject1Var		; $6fc7
	ld a,(hl)		; $6fca
	inc a			; $6fcb
	and $07			; $6fcc
	ld (hl),a		; $6fce

	ld hl,@ballPatterns		; $6fcf
	call checkFlag		; $6fd2
	pop hl			; $6fd5
	jr z,++			; $6fd6

	; Non-reflectable ball
	ld (hl),SPEED_200		; $6fd8
	ld l,Part.enemyCollisionMode		; $6fda
	ld (hl),ENEMYCOLLISION_PODOBOO		; $6fdc
	ld l,Part.var03		; $6fde
	inc (hl)		; $6fe0
++
	ld a,SND_CHARGE		; $6fe1
	call playSound		; $6fe3
	jp objectSetVisible81		; $6fe6

; A bit being 0 means the ball will be reflectable. Cycles through the next bit every time
; a projectile is created.
@ballPatterns:
	.db %10101101


; Charging
@state1:
	call _partCommon_decCounter1IfNonzero		; $6fea
	jr nz,@animate	; $6fed

	ld (hl),40 ; [counter1]
	inc l			; $6ff1
	inc (hl) ; [counter2]
	ld a,(hl)		; $6ff3
	cp $03			; $6ff4
	jp c,partSetAnimation		; $6ff6

	; Done charging
	ld (hl),20 ; [counter2]
	dec l			; $6ffb
	ld (hl),$00 ; [counter1]

	ld l,e			; $6ffe
	inc (hl) ; [state]

	ld l,Part.collisionType		; $7000
	set 7,(hl)		; $7002

	call objectGetAngleTowardEnemyTarget		; $7004
	ld e,Part.angle		; $7007
	ld (de),a		; $7009

	ld e,Part.var03		; $700a
	ld a,(de)		; $700c
	add $02			; $700d
	call partSetAnimation		; $700f
	ld a,SND_BEAM1		; $7012
	call playSound		; $7014
	jr @animate		; $7017


; Ball is moving (either version)
@state2:
	ld h,d			; $7019
	ld l,Part.counter2		; $701a
	dec (hl)		; $701c
	jr nz,+			; $701d
	ld l,e			; $701f
	inc (hl) ; [state]
+
	call _blueStalfosProjectile_checkShouldExplode		; $7021
	jr _blueStalfosProjectile_applySpeed		; $7024


; Ball is moving (baby ball only)
@state3:
	call _blueStalfosProjectile_checkShouldExplode		; $7026
	jr _blueStalfosProjectile_applySpeedAndDeleteIfOffScreen		; $7029


; Ball was just reflected (baby ball only)
@state4:
	ld h,d			; $702b
	ld l,e			; $702c
	inc (hl) ; [state]

	call objectGetAngleTowardEnemyTarget		; $702e
	xor $10			; $7031
	ld e,Part.angle		; $7033
	ld (de),a		; $7035
@animate:
	jp partAnimate		; $7036


; Ball is moving after being reflected (baby ball only)
@state5:
	call _blueStalfosProjectile_checkCollidedWithStalfos		; $7039
	jp c,partDelete		; $703c
	jr _blueStalfosProjectile_applySpeedAndDeleteIfOffScreen		; $703f


; Splits into 6 smaller projectiles (subid 1)
@state6:
	ld b,$06		; $7041
	call checkBPartSlotsAvailable		; $7043
	ret nz			; $7046
	call _blueStalfosProjectile_explode		; $7047
	ld a,SND_BEAM		; $704a
	call playSound		; $704c
	jp partDelete		; $704f


; Smaller projectile created from the explosion of the larger one
_blueStalfosProjectile_subid1:
	ld e,Part.state		; $7052
	ld a,(de)		; $7054
	or a			; $7055
	jr z,_blueStalfosProjectile_subid1_uninitialized	; $7056

_blueStalfosProjectile_applySpeedAndDeleteIfOffScreen:
	call _partCommon_checkOutOfBounds		; $7058
	jp z,partDelete		; $705b

_blueStalfosProjectile_applySpeed:
	call objectApplySpeed		; $705e
	jp partAnimate		; $7061


_blueStalfosProjectile_subid1_uninitialized:
	ld h,d			; $7064
	ld l,e			; $7065
	inc (hl) ; [state]

	ld l,Part.collisionType		; $7067
	set 7,(hl)		; $7069
	ld l,Part.enemyCollisionMode		; $706b
	ld (hl),ENEMYCOLLISION_PODOBOO		; $706d

	ld l,Part.speed		; $706f
	ld (hl),SPEED_1c0		; $7071

	ld l,Part.damage		; $7073
	ld (hl),-4		; $7075

	ld l,Part.collisionRadiusY		; $7077
	ld a,$02		; $7079
	ldi (hl),a		; $707b
	ld (hl),a		; $707c

	add a ; a = 4
	call partSetAnimation		; $707e
	jp objectSetVisible81		; $7081


;;
; Explodes the projectile (sets state to 6) if it's the correct type and is close to Link.
; Returns from caller if so.
; @addr{7084}
_blueStalfosProjectile_checkShouldExplode:
	ld a,(wFrameCounter)		; $7084
	and $07			; $7087
	ret nz			; $7089

	call _partCommon_decCounter1IfNonzero		; $708a
	ret nz			; $708d

	ld c,$28		; $708e
	call objectCheckLinkWithinDistance		; $7090
	ret nc			; $7093

	ld h,d			; $7094
	ld l,Part.counter1		; $7095
	dec (hl)		; $7097
	ld e,Part.var03		; $7098
	ld a,(de)		; $709a
	or a			; $709b
	ret z			; $709c

	pop bc ; Discard return address

	ld l,Part.collisionType		; $709e
	res 7,(hl)		; $70a0
	ld l,Part.state		; $70a2
	ld (hl),$06		; $70a4
	ret			; $70a6


;;
; @param[out]	cflag	c on collision
; @addr{70a7}
_blueStalfosProjectile_checkCollidedWithStalfos:
	ld a,Object.enabled		; $70a7
	call objectGetRelatedObject1Var		; $70a9
	call checkObjectsCollided		; $70ac
	ret nc			; $70af

	ld l,Enemy.invincibilityCounter		; $70b0
	ld (hl),30		; $70b2
	ld l,Enemy.state		; $70b4
	ld (hl),$14		; $70b6
	ret			; $70b8


;;
; Explodes into six parts
; @addr{70b9}
_blueStalfosProjectile_explode:
	ld c,$06		; $70b9
@next:
	call getFreePartSlot		; $70bb
	ld (hl),PARTID_BLUE_STALFOS_PROJECTILE		; $70be
	inc l			; $70c0
	inc (hl) ; [subid] = 1

	call objectCopyPosition		; $70c2

	; Copy ENEMYID_BLUE_STALFOS reference to new projectile
	ld l,Part.relatedObj1		; $70c5
	ld e,l			; $70c7
	ld a,(de)		; $70c8
	ldi (hl),a		; $70c9
	ld e,l			; $70ca
	ld a,(de)		; $70cb
	ld (hl),a		; $70cc

	; Set angle
	ld b,h			; $70cd
	ld a,c			; $70ce
	ld hl,@angleVals		; $70cf
	rst_addAToHl			; $70d2
	ld a,(hl)		; $70d3
	ld h,b			; $70d4
	ld l,Part.angle		; $70d5
	ld (hl),a		; $70d7

	dec c			; $70d8
	jr nz,@next	; $70d9
	ret			; $70db

@angleVals:
	.db $00 $00 $05 $0b $10 $15 $1b

_blueStalfosProjectile_hitLink:
	; [blueStalfos.state] = $10
	ld a,Object.state		; $70e3
	call objectGetRelatedObject1Var		; $70e5
	ld (hl),$10		; $70e8

	jp partDelete		; $70ea

;;
; @addr{70ed}
partCode3e:
	ld e,$c4		; $70ed
	ld a,(de)		; $70ef
	rst_jumpTable			; $70f0
.dw $70f9
.dw $7110
.dw $7129
.dw $714b
	ld h,d			; $70f9
	ld l,e			; $70fa
	inc (hl)		; $70fb
	ld e,$f0		; $70fc
	ld hl,$d081		; $70fe
_label_11_343:
	ld a,(hl)		; $7101
	cp $54			; $7102
	jr nz,_label_11_344	; $7104
	ld a,h			; $7106
	ld (de),a		; $7107
	inc e			; $7108
_label_11_344:
	inc h			; $7109
	ld a,h			; $710a
	cp $e0			; $710b
	jr c,_label_11_343	; $710d
	ret			; $710f
	ld hl,$d700		; $7110
_label_11_345:
	ld l,$24		; $7113
	ld a,(hl)		; $7115
	cp $98			; $7116
	jr z,_label_11_346	; $7118
	inc h			; $711a
	ld a,h			; $711b
	cp $dc			; $711c
	jr c,_label_11_345	; $711e
	ret			; $7120
_label_11_346:
	ld a,$02		; $7121
	ld (de),a		; $7123
	ld e,$d9		; $7124
	ld a,h			; $7126
	ld (de),a		; $7127
	ret			; $7128
	ld h,d			; $7129
	ld l,$c4		; $712a
	inc (hl)		; $712c
	ld l,$c6		; $712d
	ld (hl),$3c		; $712f
	ld l,$d9		; $7131
	ld b,(hl)		; $7133
	ld e,$f0		; $7134
_label_11_347:
	ld a,(de)		; $7136
	or a			; $7137
	ret z			; $7138
	ld h,a			; $7139
	ld l,$ba		; $713a
	ld (hl),$ff		; $713c
	ld l,$98		; $713e
	ld (hl),$00		; $7140
	inc l			; $7142
	ld (hl),b		; $7143
	inc e			; $7144
	ld a,e			; $7145
	cp $f4			; $7146
	jr c,_label_11_347	; $7148
	ret			; $714a
	call _partCommon_decCounter1IfNonzero		; $714b
	ret nz			; $714e
	ld l,e			; $714f
	ld (hl),$01		; $7150
	ret			; $7152


; ==============================================================================
; PARTID_KING_MOBLIN_BOMB
;
; Variables:
;   relatedObj1: Instance of ENEMYID_KING_MOBLIN
;   var30: If nonzero, damage has been applied to Link
;   var31: Number of red flashes before it explodes
; ==============================================================================
partCode3f:
	ld e,Part.state		; $7153
	ld a,(de)		; $7155
	rst_jumpTable			; $7156
	.dw _kingMoblinBomb_state0
	.dw _kingMoblinBomb_state1
	.dw _kingMoblinBomb_state2
	.dw _kingMoblinBomb_state3
	.dw _kingMoblinBomb_state4
	.dw _kingMoblinBomb_state5
	.dw _kingMoblinBomb_state6
	.dw _kingMoblinBomb_state7
	.dw _kingMoblinBomb_state8


_kingMoblinBomb_state0:
	ld h,d			; $7169
	ld l,e			; $716a
	inc (hl) ; [state] = 1

	ld l,Part.speed		; $716c
	ld (hl),SPEED_220		; $716e

	ld l,Part.yh		; $7170
	ld a,(hl)		; $7172
	add $08			; $7173
	ld (hl),a		; $7175

	call getRandomNumber_noPreserveVars		; $7176
	and $03			; $7179
	ld hl,@counter1Values		; $717b
	rst_addAToHl			; $717e
	ld e,Part.counter1		; $717f
	ld a,(hl)		; $7181
	ld (de),a		; $7182

	ld a,Object.health		; $7183
	call objectGetRelatedObject1Var		; $7185
	ld a,(hl)		; $7188
	dec a			; $7189
	ld hl,@numRedFlashes		; $718a
	rst_addAToHl			; $718d
	ld e,Part.var31		; $718e
	ld a,(hl)		; $7190
	ld (de),a		; $7191

	jp objectSetVisiblec2		; $7192

@counter1Values: ; One of these is chosen randomly.
	.db 120, 135, 160, 180

@numRedFlashes: ; Indexed by [kingMoblin.health] - 1.
	.db $06 $07 $08 $09 $0a $0c


; Bomb isn't doing anything except waiting to explode.
; This state's code is called by other states (2-4).
_kingMoblinBomb_state1:
	ld e,Part.counter1		; $719f
	ld a,(de)		; $71a1
	or a			; $71a2
	jr z,++			; $71a3
	ld a,(wFrameCounter)		; $71a5
	rrca			; $71a8
	ret c			; $71a9
++
	call _partCommon_decCounter1IfNonzero		; $71aa
	ret nz			; $71ad

	ld l,Part.animParameter		; $71ae
	bit 0,(hl)		; $71b0
	jr z,@animate	; $71b2

	ld (hl),$00		; $71b4
	ld l,Part.counter2		; $71b6
	inc (hl)		; $71b8

	ld a,(hl)		; $71b9
	ld l,Part.var31		; $71ba
	cp (hl)			; $71bc
	jr nc,_kingMoblinBomb_explode	; $71bd

@animate:
	jp partAnimate		; $71bf

	; Unused code snippet?
	or d			; $71c2
	ret			; $71c3

_kingMoblinBomb_explode:
	ld l,Part.state		; $71c4
	ld (hl),$05		; $71c6

	ld l,Part.oamFlagsBackup		; $71c8
	ld a,$0a		; $71ca
	ldi (hl),a		; $71cc
	ldi (hl),a		; $71cd
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01		; $71d0
	call partSetAnimation		; $71d2
	call objectSetVisible82		; $71d5
	ld a,SND_EXPLOSION		; $71d8
	call playSound		; $71da
	xor a			; $71dd
	ret			; $71de


; Being held by Link
_kingMoblinBomb_state2:
	inc e			; $71df
	ld a,(de)		; $71e0
	rst_jumpTable			; $71e1
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld a,$01		; $71ea
	ld (de),a ; [state2] = 1
	xor a			; $71ed
	ld (wLinkGrabState2),a		; $71ee
	call objectSetVisiblec1		; $71f1

@beingHeld:
	call _kingMoblinBomb_state1		; $71f4
	ret nz			; $71f7
	jp dropLinkHeldItem		; $71f8

@released:
	; Drastically reduce speed when Y < $30 (on moblin's platform), Z = 0,
	; and subid = 0.
	ld e,Part.yh		; $71fb
	ld a,(de)		; $71fd
	cp $30			; $71fe
	jr nc,@beingHeld	; $7200

	ld h,d			; $7202
	ld l,Part.zh		; $7203
	ld e,Part.subid		; $7205
	ld a,(de)		; $7207
	or (hl)			; $7208
	jr nz,@beingHeld	; $7209

	; Reduce speed
	ld hl,w1ReservedItemC.speedZ+1		; $720b
	sra (hl)		; $720e
	dec l			; $7210
	rr (hl)			; $7211
	ld l,Item.speed		; $7213
	ld (hl),SPEED_40		; $7215

	jp _kingMoblinBomb_state1		; $7217

@atRest:
	ld e,Part.state		; $721a
	ld a,$04		; $721c
	ld (de),a		; $721e

	call objectSetVisiblec2		; $721f
	jr _kingMoblinBomb_state4		; $7222


; Being thrown. (King moblin sets the state to this.)
_kingMoblinBomb_state3:
	call _kingMoblinBomb_state1		; $7224
	ret z			; $7227

	ld c,$20		; $7228
	call objectUpdateSpeedZAndBounce		; $722a
	jr c,@doneBouncing	; $722d

	ld a,SND_BOMB_LAND		; $722f
	call z,playSound		; $7231
	jp objectApplySpeed		; $7234

@doneBouncing:
	ld a,SND_BOMB_LAND		; $7237
	call playSound		; $7239
	ld h,d			; $723c
	ld l,Part.state		; $723d
	inc (hl) ; [state] = 4


; Waiting to be picked up (by link or king moblin)
_kingMoblinBomb_state4:
	call _kingMoblinBomb_state1		; $7240
	ret z			; $7243
	jp objectAddToGrabbableObjectBuffer		; $7244


; Exploding
_kingMoblinBomb_state5:
	ld h,d			; $7247
	ld l,Part.animParameter		; $7248
	ld a,(hl)		; $724a
	inc a			; $724b
	jp z,partDelete		; $724c

	dec a			; $724f
	jr z,@animate	; $7250

	ld l,Part.collisionRadiusY		; $7252
	ldi (hl),a		; $7254
	ld (hl),a		; $7255
	call _kingMoblinBomb_checkCollisionWithLink		; $7256
	call _kingMoblinBomb_checkCollisionWithKingMoblin		; $7259
@animate:
	jp partAnimate		; $725c


; States 6-8 might be unused? Bomb is chucked way upward, then explodes on the ground.
_kingMoblinBomb_state6:
	ld bc,-$240		; $725f
	call objectSetSpeedZ		; $7262

	ld l,e			; $7265
	inc (hl) ; [state] = 7

	ld l,Part.speed		; $7267
	ld (hl),SPEED_c0		; $7269

	ld l,Part.counter1		; $726b
	ld (hl),$07		; $726d

	; Decide angle to throw at based on king moblin's position
	ld a,Object.xh		; $726f
	call objectGetRelatedObject1Var		; $7271
	ld a,(hl)		; $7274
	cp $50			; $7275
	ld a,$07		; $7277
	jr c,+			; $7279
	ld a,$19		; $727b
+
	ld e,Part.angle		; $727d
	ld (de),a		; $727f
	ret			; $7280


_kingMoblinBomb_state7:
	call _partCommon_decCounter1IfNonzero		; $7281
	ret nz			; $7284

	ld l,e			; $7285
	inc (hl) ; [state] = 8


_kingMoblinBomb_state8:
	ld c,$20		; $7287
	call objectUpdateSpeedZAndBounce		; $7289
	jp nc,objectApplySpeed		; $728c

	ld h,d			; $728f
	jp _kingMoblinBomb_explode		; $7290

;;
; @addr{7293}
_kingMoblinBomb_checkCollisionWithLink:
	ld e,Part.var30		; $7293
	ld a,(de)		; $7295
	or a			; $7296
	ret nz			; $7297

	call checkLinkVulnerable		; $7298
	ret nc			; $729b

	call objectCheckCollidedWithLink_ignoreZ		; $729c
	ret nc			; $729f

	call objectGetAngleTowardEnemyTarget		; $72a0

	ld hl,w1Link.knockbackCounter		; $72a3
	ld (hl),$10		; $72a6
	dec l			; $72a8
	ldd (hl),a ; [w1Link.knockbackAngle]
	ld (hl),20 ; [w1Link.invincibilityCounter]
	dec l			; $72ac
	ld (hl),$01 ; [w1Link.var2a] (TODO: what does this mean?)

	ld e,Part.damage		; $72af
	ld l,<w1Link.damageToApply		; $72b1
	ld a,(de)		; $72b3
	ld (hl),a		; $72b4

	ld e,Part.var30		; $72b5
	ld a,$01		; $72b7
	ld (de),a		; $72b9
	ret			; $72ba

;;
; @addr{72bb}
_kingMoblinBomb_checkCollisionWithKingMoblin:
	ld e,Part.relatedObj1+1		; $72bb
	ld a,(de)		; $72bd
	or a			; $72be
	ret z			; $72bf

	; Check king moblin's collisions are enabled
	ld a,Object.collisionType		; $72c0
	call objectGetRelatedObject1Var		; $72c2
	bit 7,(hl)		; $72c5
	ret z			; $72c7

	ld l,Enemy.invincibilityCounter		; $72c8
	ld a,(hl)		; $72ca
	or a			; $72cb
	ret nz			; $72cc

	call checkObjectsCollided		; $72cd
	ret nc			; $72d0

	ld l,Enemy.var2a		; $72d1
	ld (hl),$80|ITEMCOLLISION_BOMB		; $72d3
	ld l,Enemy.invincibilityCounter		; $72d5
	ld (hl),30		; $72d7

	ld l,Enemy.health		; $72d9
	dec (hl)		; $72db
	ret			; $72dc

;;
; @addr{72dd}
partCode40:
	ld a,$01		; $72dd
	call objectGetRelatedObject1Var		; $72df
	ld a,(hl)		; $72e2
	cp $01			; $72e3
	jp nz,partDelete		; $72e5
	ld e,$c4		; $72e8
	ld a,(de)		; $72ea
	or a			; $72eb
	jr z,_label_11_356	; $72ec
	ld a,$20		; $72ee
	call objectUpdateSpeedZ_sidescroll		; $72f0
	jp c,partDelete		; $72f3
	call objectApplySpeed		; $72f6
	ld a,$00		; $72f9
	call objectGetRelatedObject1Var		; $72fb
	jp objectCopyPosition		; $72fe
_label_11_356:
	ld h,d			; $7301
	ld l,e			; $7302
	inc (hl)		; $7303
	call getRandomNumber_noPreserveVars		; $7304
	ld b,a			; $7307
	and $03			; $7308
	ld hl,$732c		; $730a
	rst_addAToHl			; $730d
	ld e,$d0		; $730e
	ld a,(hl)		; $7310
	ld (de),a		; $7311
	ld a,b			; $7312
	and $60			; $7313
	swap a			; $7315
	ld hl,$7330		; $7317
	rst_addAToHl			; $731a
	ld e,$d4		; $731b
	ldi a,(hl)		; $731d
	ld (de),a		; $731e
	inc e			; $731f
	ld a,(hl)		; $7320
	ld (de),a		; $7321
	ldh a,(<hRng2)	; $7322
	and $10			; $7324
	add $08			; $7326
	ld e,$c9		; $7328
	ld (de),a		; $732a
	ret			; $732b
	inc d			; $732c
	add hl,de		; $732d
	ld e,$23		; $732e
	nop			; $7330
.DB $fd				; $7331
	ld ($ff00+$fc),a	; $7332
	ret nz			; $7334
.DB $fc				; $7335
	and b			; $7336
.DB $fc				; $7337


; ==============================================================================
; PARTID_SHADOW_HAG_SHADOW
; ==============================================================================
partCode41:
	ld e,Part.state		; $7338
	ld a,(de)		; $733a
	rst_jumpTable			; $733b
	.dw @state0
	.dw @state1
	.dw @state2
	.dw partDelete

; Initialization
@state0:
	ld h,d			; $7344
	ld l,e			; $7345
	inc (hl) ; [state]

	ld l,Part.counter1		; $7347
	ld (hl),$08		; $7349

	ld l,Part.speed		; $734b
	ld (hl),SPEED_100		; $734d

	ld e,Part.angle		; $734f
	ld a,(de)		; $7351
	ld hl,@angles		; $7352
	rst_addAToHl			; $7355
	ld a,(hl)		; $7356
	ld (de),a		; $7357

	call objectSetVisible82		; $7358
	ld a,$01		; $735b
	jp partSetAnimation		; $735d

@angles:
	.db $04 $0c $14 $1c


; Shadows chasing Link
@state1:
	; If [shadowHag.counter1] == $ff, the shadows should converge to her position.
	ld a,Object.counter1		; $7364
	call objectGetRelatedObject1Var		; $7366
	ld a,(hl)		; $7369
	inc a			; $736a
	jr nz,++		; $736b

	ld e,Part.state		; $736d
	ld a,$02		; $736f
	ld (de),a		; $7371
++
	call _partCommon_decCounter1IfNonzero		; $7372
	jr nz,++		; $7375

	ld (hl),$08		; $7377
	call objectGetAngleTowardEnemyTarget		; $7379
	call objectNudgeAngleTowards		; $737c
++
	jp objectApplySpeed		; $737f


; Shadows converging back to shadow hag
@state2:
	ld a,Object.yh		; $7382
	call objectGetRelatedObject1Var		; $7384
	ld b,(hl)		; $7387
	ld l,Enemy.xh		; $7388
	ld c,(hl)		; $738a

	ld e,Part.yh		; $738b
	ld a,(de)		; $738d
	ldh (<hFF8F),a	; $738e
	ld e,Part.xh		; $7390
	ld a,(de)		; $7392
	ldh (<hFF8E),a	; $7393

	; Check if already close enough
	sub c			; $7395
	add $04			; $7396
	cp $09			; $7398
	jr nc,@updateAngleAndApplySpeed	; $739a
	ldh a,(<hFF8F)	; $739c
	sub b			; $739e
	add $04			; $739f
	cp $09			; $73a1
	jr nc,@updateAngleAndApplySpeed	; $73a3

	; We're close enough.

	; [shadowHag.counter2]--
	ld l,Enemy.counter2		; $73a5
	dec (hl)		; $73a7
	; [shadowHag.visible] = true
	ld l,Enemy.visible		; $73a8
	set 7,(hl)		; $73aa

	ld e,Part.state		; $73ac
	ld a,$03		; $73ae
	ld (de),a		; $73b0

@updateAngleAndApplySpeed:
	call objectGetRelativeAngleWithTempVars		; $73b1
	ld e,Part.angle		; $73b4
	ld (de),a		; $73b6
	jp objectApplySpeed		; $73b7

;;
; @addr{73ba}
partCode42:
	jp nz,partDelete		; $73ba
	ld e,$c4		; $73bd
	ld a,(de)		; $73bf
	rst_jumpTable			; $73c0
.dw $73c7
.dw $742c
.dw $7436
	ld h,d			; $73c7
	ld l,e			; $73c8
	inc (hl)		; $73c9
	ld l,$c6		; $73ca
	ld (hl),$08		; $73cc
	ld l,$d0		; $73ce
	ld (hl),$3c		; $73d0
	ld e,$cb		; $73d2
	ld l,$cf		; $73d4
	ld a,(de)		; $73d6
	add (hl)		; $73d7
	ld (de),a		; $73d8
	ld (hl),$00		; $73d9
	ld e,$c2		; $73db
	ld a,(de)		; $73dd
	ld bc,$7421		; $73de
	call addAToBc		; $73e1
	ld l,$c9		; $73e4
	ld a,(bc)		; $73e6
	add (hl)		; $73e7
	and $1f			; $73e8
	ld (hl),a		; $73ea
	ld a,(de)		; $73eb
	or a			; $73ec
	jr nz,_label_11_361	; $73ed
	ld a,(hl)		; $73ef
	rrca			; $73f0
	rrca			; $73f1
	ld hl,$7424		; $73f2
	rst_addAToHl			; $73f5
	ld e,$cb		; $73f6
	ld a,(de)		; $73f8
	add (hl)		; $73f9
	ld (de),a		; $73fa
	ld e,$cd		; $73fb
	inc hl			; $73fd
	ld a,(de)		; $73fe
	add (hl)		; $73ff
	ld (de),a		; $7400
	ld b,$02		; $7401
_label_11_360:
	call getFreePartSlot		; $7403
	jr nz,_label_11_361	; $7406
	ld (hl),$42		; $7408
	inc l			; $740a
	ld (hl),b		; $740b
	ld l,$c9		; $740c
	ld e,l			; $740e
	ld a,(de)		; $740f
	ld (hl),a		; $7410
	call objectCopyPosition		; $7411
	dec b			; $7414
	jr nz,_label_11_360	; $7415
_label_11_361:
	ld e,$c9		; $7417
	ld a,(de)		; $7419
	or a			; $741a
	jp z,objectSetVisible82		; $741b
	jp objectSetVisible81		; $741e
	nop			; $7421
	ld (bc),a		; $7422
	cp $fc			; $7423
	nop			; $7425
	ld (bc),a		; $7426
	inc b			; $7427
	inc b			; $7428
	nop			; $7429
	ld (bc),a		; $742a
.DB $fc				; $742b
	call _partCommon_decCounter1IfNonzero		; $742c
	jr nz,_label_11_362	; $742f
	ld l,e			; $7431
	inc (hl)		; $7432
	call objectSetVisible82		; $7433
_label_11_362:
	call partAnimate		; $7436
	call objectApplySpeed		; $7439
	call _partCommon_checkTileCollisionOrOutOfBounds		; $743c
	ret nc			; $743f
	jp partDelete		; $7440


; ==============================================================================
; PARTID_PLASMARINE_PROJECTILE
; ==============================================================================
partCode43:
	jr nz,@delete	; $7443

	ld a,Object.id		; $7445
	call objectGetRelatedObject1Var		; $7447
	ld a,(hl)		; $744a
	cp ENEMYID_PLASMARINE			; $744b
	jr nz,@delete	; $744d

	ld e,Part.state		; $744f
	ld a,(de)		; $7451
	or a			; $7452
	jr z,@state0	; $7453

@state1:
	; If projectile's color is different from plasmarine's color...
	ld l,Enemy.var32		; $7455
	ld e,Part.subid		; $7457
	ld a,(de)		; $7459
	cp (hl)			; $745a
	jr z,@noCollision		; $745b

	; Check for collision.
	call checkObjectsCollided		; $745d
	jr c,@collidedWithPlasmarine	; $7460

@noCollision:
	ld a,(wFrameCounter)		; $7462
	rrca			; $7465
	jr c,@updateMovement	; $7466

	call _partCommon_decCounter1IfNonzero		; $7468
	jp z,partDelete		; $746b

	; Flicker visibility for 30 frames or less remaining
	ld a,(hl)		; $746e
	cp 30			; $746f
	jr nc,++		; $7471
	ld e,Part.visible		; $7473
	ld a,(de)		; $7475
	xor $80			; $7476
	ld (de),a		; $7478
++
	; Slowly home in on Link
	inc l			; $7479
	dec (hl) ; [this.counter2]--
	jr nz,@updateMovement	; $747b
	ld (hl),$10		; $747d
	call objectGetAngleTowardEnemyTarget		; $747f
	call objectNudgeAngleTowards		; $7482

@updateMovement:
	call objectApplySpeed		; $7485
	call _partCommon_checkOutOfBounds		; $7488
	jp nz,partAnimate		; $748b
	jr @delete		; $748e

@collidedWithPlasmarine:
	ld l,Enemy.invincibilityCounter		; $7490
	ld a,(hl)		; $7492
	or a			; $7493
	jr nz,@noCollision	; $7494

	ld (hl),24
	ld l,Enemy.health		; $7498
	dec (hl)		; $749a
	jr nz,++		; $749b

	; Plasmarine is dead
	ld l,Enemy.collisionType		; $749d
	res 7,(hl)		; $749f
++
	ld a,SND_BOSS_DAMAGE		; $74a1
	call playSound		; $74a3
@delete:
	jp partDelete		; $74a6


@state0:
	ld l,Enemy.health		; $74a9
	ld a,(hl)		; $74ab
	cp $03			; $74ac
	ld a,SPEED_80		; $74ae
	jr nc,+			; $74b0
	ld a,SPEED_e0		; $74b2
+
	ld h,d			; $74b4
	ld l,e			; $74b5
	inc (hl) ; [state] = 1

	ld l,Part.speed		; $74b7
	ld (hl),a		; $74b9

	ld l,Part.counter1		; $74ba
	ld (hl),150 ; [counter1] (lifetime counter)
	inc l			; $74be
	ld (hl),$08 ; [counter2]

	; Set color & animation
	ld l,Part.subid		; $74c1
	ld a,(hl)		; $74c3
	inc a			; $74c4
	ld l,Part.oamFlags		; $74c5
	ldd (hl),a		; $74c7
	ld (hl),a		; $74c8
	dec a			; $74c9
	call partSetAnimation		; $74ca

	; Move toward Link
	call objectGetAngleTowardEnemyTarget		; $74cd
	ld e,Part.angle		; $74d0
	ld (de),a		; $74d2

	jp objectSetVisible82		; $74d3


; ==============================================================================
; PARTID_TINGLE_BALLOON
; ==============================================================================
partCode44:
	jr nz,@beenHit	; $74d6

	ld e,Part.state		; $74d8
	ld a,(de)		; $74da
	or a			; $74db
	jr nz,@state1	; $74dc

@state0:
	ld h,d			; $74de
	ld l,e			; $74df
	inc (hl) ; [state] = 1

	ld l,Part.counter1		; $74e1
	ld (hl),$38		; $74e3
	inc l			; $74e5
	ld (hl),$ff ; [counter2]

	ld l,Part.zh		; $74e8
	ld (hl),$f1		; $74ea
	ld bc,-$10		; $74ec
	call objectSetSpeedZ		; $74ef

	xor a			; $74f2
	call partSetAnimation		; $74f3
	call objectSetVisible81		; $74f6

@state1:
	call _partCommon_decCounter1IfNonzero		; $74f9
	jr nz,++		; $74fc

	; Reverse floating direction
	ld (hl),$38 ; [counter1]
	ld l,Part.speedZ		; $7500
	ld a,(hl)		; $7502
	cpl			; $7503
	inc a			; $7504
	ldi (hl),a		; $7505
	ld a,(hl)		; $7506
	cpl			; $7507
	ld (hl),a		; $7508
++
	ld c,$00		; $7509
	call objectUpdateSpeedZ_paramC		; $750b

	; Update Tingle's z position
	ld a,Object.zh		; $750e
	call objectGetRelatedObject1Var		; $7510
	ld e,Part.zh		; $7513
	ld a,(de)		; $7515
	ld (hl),a		; $7516
	ret			; $7517

@beenHit:
	ld a,Object.state		; $7518
	call objectGetRelatedObject1Var		; $751a
	inc (hl) ; [tingle.state] = 2

	; Spawn explosion
	call getFreeInteractionSlot		; $751e
	ld (hl),INTERACID_EXPLOSION		; $7521
	ld l,Interaction.var03		; $7523
	ld (hl),$01 ; Give it a higher draw priority?
	ld bc,$f000		; $7527
	call objectCopyPositionWithOffset		; $752a

	jp partDelete		; $752d

;;
; @addr{7530}
partCode45:
	ld e,$c4		; $7530
	ld a,(de)		; $7532
	rst_jumpTable			; $7533
.dw $753a
.dw $7562
.dw $758b
	ld h,d			; $753a
	ld l,e			; $753b
	inc (hl)		; $753c
	ld l,$d0		; $753d
	ld (hl),$32		; $753f
	ld l,$cb		; $7541
	ld a,(hl)		; $7543
	sub $08			; $7544
	jr z,_label_11_374	; $7546
	add $04			; $7548
_label_11_374:
	ldi (hl),a		; $754a
	ld e,$f0		; $754b
	ld (de),a		; $754d
	inc e			; $754e
	inc l			; $754f
	ld a,(hl)		; $7550
	ld (de),a		; $7551
	ld e,$c2		; $7552
	ld a,(de)		; $7554
	ld hl,$755e		; $7555
	rst_addAToHl			; $7558
	ld e,$c6		; $7559
	ld a,(hl)		; $755b
	ld (de),a		; $755c
	ret			; $755d
	dec l			; $755e
	ld e,d			; $755f
	add a			; $7560
	or h			; $7561
	call _partCommon_decCounter1IfNonzero		; $7562
	ret nz			; $7565
	ld l,e			; $7566
	inc (hl)		; $7567
	ld l,$e4		; $7568
	set 7,(hl)		; $756a
	ld l,$d4		; $756c
	ld a,$60		; $756e
	ldi (hl),a		; $7570
	ld (hl),$fe		; $7571
_label_11_375:
	call getRandomNumber_noPreserveVars		; $7573
	and $07			; $7576
	cp $07			; $7578
	jr nc,_label_11_375	; $757a
	sub $03			; $757c
	add $10			; $757e
	ld e,$c9		; $7580
	ld (de),a		; $7582
	call objectSetVisiblec1		; $7583
	ld a,SND_RUMBLE		; $7586
	jp playSound		; $7588
	ld c,$20		; $758b
	call objectUpdateSpeedZ_paramC		; $758d
	call z,$756c		; $7590
	call objectApplySpeed		; $7593
	ld e,$cb		; $7596
	ld a,(de)		; $7598
	cp $88			; $7599
	jp c,partAnimate		; $759b
	ld h,d			; $759e
	ld l,$c4		; $759f
	dec (hl)		; $75a1
	ld l,$e4		; $75a2
	res 7,(hl)		; $75a4
	ld l,$c6		; $75a6
	ld (hl),$b4		; $75a8
	ld e,$f0		; $75aa
	ld l,$cb		; $75ac
	ld a,(de)		; $75ae
	ldi (hl),a		; $75af
	inc e			; $75b0
	inc l			; $75b1
	ld a,(de)		; $75b2
	ld (hl),a		; $75b3
	jp objectSetInvisible		; $75b4

;;
; @addr{75b7}
partCode46:
	jr z,_label_11_376	; $75b7
	ld h,d			; $75b9
	ld l,$c6		; $75ba
	ld (hl),$2d		; $75bc
	ld l,$c2		; $75be
	ld a,(hl)		; $75c0
	and $07			; $75c1
	ld hl,wActiveTriggers		; $75c3
	call setFlag		; $75c6
	call objectSetVisible83		; $75c9
_label_11_376:
	ld e,$c4		; $75cc
	ld a,(de)		; $75ce
	or a			; $75cf
	jr z,_label_11_377	; $75d0
	call _partCommon_decCounter1IfNonzero		; $75d2
	ret nz			; $75d5
	ld e,$c2		; $75d6
	ld a,(de)		; $75d8
	ld hl,wActiveTriggers		; $75d9
	call unsetFlag		; $75dc
	jp objectSetInvisible		; $75df
_label_11_377:
	inc a			; $75e2
	ld (de),a		; $75e3
	ret			; $75e4


; ==============================================================================
; PARTID_BOMB
; ==============================================================================
partCode47:
	ld e,Part.state		; $75e5
	ld a,(de)		; $75e7
	rst_jumpTable			; $75e8
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d			; $75f1
	ld l,e			; $75f2
	inc (hl) ; [state] = 1

	ld l,Part.speed		; $75f4
	ld (hl),SPEED_200		; $75f6

	ld l,Part.speedZ		; $75f8
	ld a,<(-$280)		; $75fa
	ldi (hl),a		; $75fc
	ld (hl),>(-$280)		; $75fd

	call objectSetVisiblec1		; $75ff

; Waiting to be thrown
@state1:
	ld a,$00		; $7602
	call objectGetRelatedObject1Var		; $7604
	jp objectTakePosition		; $7607

; Being thrown
@state2:
	call objectApplySpeed		; $760a
	ld c,$20		; $760d
	call objectUpdateSpeedZ_paramC		; $760f
	jp nz,partAnimate		; $7612

	; Landed on ground; time to explode

	ld l,Part.state		; $7615
	inc (hl) ; [state] = 4

	ld l,Part.collisionType		; $7618
	set 7,(hl)		; $761a

	ld l,Part.oamFlagsBackup		; $761c
	ld a,$0a		; $761e
	ldi (hl),a		; $7620
	ldi (hl),a		; $7621
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01		; $7624
	call partSetAnimation		; $7626

	ld a,SND_EXPLOSION		; $7629
	call playSound		; $762b

	jp objectSetVisible83		; $762e

; Exploding
@state3:
	call partAnimate		; $7631
	ld e,Part.animParameter		; $7634
	ld a,(de)		; $7636
	inc a			; $7637
	jp z,partDelete		; $7638

	dec a			; $763b
	ld e,Part.collisionRadiusY		; $763c
	ld (de),a		; $763e
	inc e			; $763f
	ld (de),a		; $7640
	ret			; $7641


; ==============================================================================
; PARTID_OCTOGON_DEPTH_CHARGE
;
; Variables:
;   var30: gravity
; ==============================================================================
partCode48:
	jr z,@normalStatus	; $7642

	; For subid 1 only, delete self on collision with anything?
	ld e,Part.subid		; $7644
	ld a,(de)		; $7646
	or a			; $7647
	jp nz,partDelete		; $7648

@normalStatus:
	ld e,Part.subid		; $764b
	ld a,(de)		; $764d
	or a			; $764e
	ld e,Part.state		; $764f
	jr z,_octogonDepthCharge_subid0	; $7651


; Small (split) projectile
_octogonDepthCharge_subid1:
	ld a,(de)		; $7653
	or a			; $7654
	jr z,@state0	; $7655

@state1:
	call objectApplySpeed		; $7657
	call _partCommon_checkTileCollisionOrOutOfBounds		; $765a
	jp nz,partAnimate		; $765d
	jp partDelete		; $7660

@state0:
	ld h,d			; $7663
	ld l,e			; $7664
	inc (hl) ; [state] = 1

	ld l,Part.collisionRadiusY		; $7666
	ld a,$02		; $7668
	ldi (hl),a		; $766a
	ld (hl),a		; $766b

	ld l,Part.speed		; $766c
	ld (hl),SPEED_180		; $766e
	ld a,$01		; $7670
	call partSetAnimation		; $7672
	jp objectSetVisible82		; $7675


; Large projectile, before being split into 4 smaller ones (subid 1)
_octogonDepthCharge_subid0:
	ld a,(de)		; $7678
	rst_jumpTable			; $7679
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,Object.visible		; $7682
	call objectGetRelatedObject1Var		; $7684
	ld a,(hl)		; $7687

	ld h,d			; $7688
	ld l,Part.state		; $7689
	inc (hl)		; $768b

	rlca			; $768c
	jr c,@aboveWater		; $768d

@belowWater:
	inc (hl) ; [state] = 2 (skips the "moving up" part)
	ld l,Part.counter1		; $7690
	inc (hl)		; $7692

	ld l,Part.zh		; $7693
	ld (hl),$b8		; $7695
	ld l,Part.var30		; $7697
	ld (hl),$10		; $7699

	; Choose random position to spawn at
	call getRandomNumber_noPreserveVars		; $769b
	and $06			; $769e
	ld hl,@positionCandidates		; $76a0
	rst_addAToHl			; $76a3
	ld e,Part.yh		; $76a4
	ldi a,(hl)		; $76a6
	ld (de),a		; $76a7
	ld e,Part.xh		; $76a8
	ld a,(hl)		; $76aa
	ld (de),a		; $76ab

	ld a,SND_SPLASH		; $76ac
	call playSound		; $76ae
	jr @setVisible81		; $76b1

@positionCandidates:
	.db $38 $48
	.db $38 $a8
	.db $78 $48
	.db $78 $a8

@aboveWater:
	; Is shot up before coming back down
	ld l,Part.var30		; $76bb
	ld (hl),$20		; $76bd

	ld l,Part.yh		; $76bf
	ld a,(hl)		; $76c1
	sub $10			; $76c2
	ld (hl),a		; $76c4

	ld a,SND_SCENT_SEED		; $76c5
	call playSound		; $76c7

@setVisible81:
	jp objectSetVisible81		; $76ca


; Above water: being shot up
@state1:
	ld h,d			; $76cd
	ld l,Part.zh		; $76ce
	dec (hl)		; $76d0
	dec (hl)		; $76d1

	ld a,(hl)		; $76d2
	cp $d0			; $76d3
	jr nc,@animate	; $76d5

	cp $b8			; $76d7
	jr nc,@flickerVisibility	; $76d9

	ld l,e			; $76db
	inc (hl) ; [state] = 2

	ld l,Part.counter1		; $76dd
	ld (hl),30		; $76df

	ld l,Part.collisionType		; $76e1
	res 7,(hl)		; $76e3

	ld l,Part.yh		; $76e5
	ldh a,(<hEnemyTargetY)	; $76e7
	ldi (hl),a		; $76e9
	inc l			; $76ea
	ldh a,(<hEnemyTargetX)	; $76eb
	ld (hl),a		; $76ed

	jp objectSetInvisible		; $76ee

@flickerVisibility:
	ld l,Part.visible		; $76f1
	ld a,(hl)		; $76f3
	xor $80			; $76f4
	ld (hl),a		; $76f6

@animate:
	jp partAnimate		; $76f7


; Delay before falling to ground
@state2:
	call _partCommon_decCounter1IfNonzero		; $76fa
	ret nz			; $76fd

	ld l,e			; $76fe
	inc (hl) ; [state] = 3

	ld l,Part.collisionType		; $7700
	set 7,(hl)		; $7702
	jp objectSetVisiblec1		; $7704


; Falling to ground
@state3:
	ld e,Part.var30		; $7707
	ld a,(de)		; $7709
	call objectUpdateSpeedZ		; $770a
	jr nz,@animate	; $770d

	; Hit ground; split into four, then delete self.
	call getRandomNumber_noPreserveVars		; $770f
	and $04			; $7712
	ld b,a			; $7714
	ld c,$04		; $7715

@spawnNext:
	call getFreePartSlot		; $7717
	jr nz,++		; $771a
	ld (hl),PARTID_OCTOGON_DEPTH_CHARGE		; $771c
	inc l			; $771e
	inc (hl) ; [subid] = 1
	ld l,Part.angle		; $7720
	ld (hl),b		; $7722
	call objectCopyPosition		; $7723
	ld a,b			; $7726
	add $08			; $7727
	ld b,a			; $7729
++
	dec c			; $772a
	jr nz,@spawnNext	; $772b

	ld a,SND_UNKNOWN3		; $772d
	call playSound		; $772f
	jp partDelete		; $7732

;;
; @addr{7735}
partCode49:
	ld e,$c4		; $7735
	ld a,(de)		; $7737
	rst_jumpTable			; $7738
.dw $7745
.dw $7765
.dw $7788
.dw $77a2
.dw $77cf
.dw $77e0
	ld h,d			; $7745
	ld l,$c2		; $7746
	ld a,(hl)		; $7748
	cp $ff			; $7749
	jr nz,_label_11_388	; $774b
	ld l,$c4		; $774d
	ld (hl),$05		; $774f
	jp $77f0		; $7751
_label_11_388:
	ld l,$c4		; $7754
	inc (hl)		; $7756
	call $78e3		; $7757
	call $793b		; $775a
	ld a,SND_POOF		; $775d
	call playSound		; $775f
	call objectSetVisiblec1		; $7762
	call objectApplySpeed		; $7765
	ld h,d			; $7768
	ld l,$f1		; $7769
	ld c,(hl)		; $776b
	call objectUpdateSpeedZAndBounce		; $776c
	jr c,_label_11_390	; $776f
	jr nz,_label_11_389	; $7771
	ld e,$d0		; $7773
	ld a,(de)		; $7775
	srl a			; $7776
	ld (de),a		; $7778
_label_11_389:
	jp partAnimate		; $7779
_label_11_390:
	ld h,d			; $777c
	ld l,$c4		; $777d
	ld (hl),$03		; $777f
	ld l,$c6		; $7781
	ld (hl),$14		; $7783
	jp partAnimate		; $7785
	inc e			; $7788
	ld a,(de)		; $7789
	rst_jumpTable			; $778a
.dw $7793
.dw $779c
.dw $779c
.dw $779d
	xor a			; $7793
	ld (wLinkGrabState2),a		; $7794
	inc a			; $7797
	ld (de),a		; $7798
	jp objectSetVisiblec1		; $7799
	ret			; $779c
	call objectSetVisiblec2		; $779d
	jr _label_11_391		; $77a0
	ld h,d			; $77a2
	ld l,$c6		; $77a3
	dec (hl)		; $77a5
	jr z,_label_11_391	; $77a6
	call partAnimate		; $77a8
	call $79ab		; $77ab
	jp objectAddToGrabbableObjectBuffer		; $77ae
_label_11_391:
	ld h,d			; $77b1
	ld l,$c4		; $77b2
	ld (hl),$04		; $77b4
	ld l,$e4		; $77b6
	set 7,(hl)		; $77b8
	ld l,$db		; $77ba
	ld a,$0a		; $77bc
	ldi (hl),a		; $77be
	ldi (hl),a		; $77bf
	ld (hl),$0c		; $77c0
	ld a,$01		; $77c2
	call partSetAnimation		; $77c4
	ld a,SND_EXPLOSION		; $77c7
	call playSound		; $77c9
	jp objectSetVisible83		; $77cc
	call partAnimate		; $77cf
	ld e,$e1		; $77d2
	ld a,(de)		; $77d4
	inc a			; $77d5
	jp z,partDelete		; $77d6
	dec a			; $77d9
	ld e,$e6		; $77da
	ld (de),a		; $77dc
	inc e			; $77dd
	ld (de),a		; $77de
	ret			; $77df
	ld h,d			; $77e0
	ld l,$f0		; $77e1
	dec (hl)		; $77e3
	ret nz			; $77e4
	ld l,$c6		; $77e5
	inc (hl)		; $77e7
	call $77f0		; $77e8
	jp z,partDelete		; $77eb
	jr _label_11_393		; $77ee
	ld h,d			; $77f0
	ld l,$c6		; $77f1
	ld a,(hl)		; $77f3
	ld bc,$780f		; $77f4
	call addDoubleIndexToBc		; $77f7
	ld a,(bc)		; $77fa
	cp $ff			; $77fb
	jr nz,_label_11_392	; $77fd
	ld a,$01		; $77ff
	ld ($cfc0),a		; $7801
	ret			; $7804
_label_11_392:
	ld l,$f0		; $7805
	ld (hl),a		; $7807
	inc bc			; $7808
	ld a,(bc)		; $7809
	ld l,$f5		; $780a
	ld (hl),a		; $780c
	or d			; $780d
	ret			; $780e
	inc a			; $780f
	ld bc,$013c		; $7810
	inc a			; $7813
	ld bc,$013c		; $7814
	inc a			; $7817
	ld bc,$013c		; $7818
	jr z,$01		; $781b
	jr z,$01		; $781d
	jr z,$01		; $781f
	jr z,$01		; $7821
	jr z,$01		; $7823
	ld e,$01		; $7825
	ld e,$01		; $7827
	ld e,$01		; $7829
	ld e,$01		; $782b
	ld e,$01		; $782d
	inc d			; $782f
	ld bc,$0114		; $7830
	inc d			; $7833
	ld bc,$0114		; $7834
	inc d			; $7837
	ld bc,$0214		; $7838
	inc d			; $783b
	ld (bc),a		; $783c
	inc d			; $783d
	ld (bc),a		; $783e
	inc d			; $783f
	ld (bc),a		; $7840
	inc d			; $7841
	ld (bc),a		; $7842
	inc d			; $7843
	ld (bc),a		; $7844
	inc d			; $7845
	ld (bc),a		; $7846
	inc d			; $7847
	ld (bc),a		; $7848
	inc d			; $7849
	ld (bc),a		; $784a
	inc d			; $784b
	ld (bc),a		; $784c
	inc d			; $784d
	ld (bc),a		; $784e
	inc d			; $784f
	ld (bc),a		; $7850
	inc d			; $7851
	ld (bc),a		; $7852
	inc d			; $7853
	ld (bc),a		; $7854
	or h			; $7855
	ld (bc),a		; $7856
	rst $38			; $7857
_label_11_393:
	xor a			; $7858
	ld e,$f2		; $7859
	ld (de),a		; $785b
	inc e			; $785c
	ld (de),a		; $785d
	call $78bd		; $785e
	ld e,$f5		; $7861
	ld a,(de)		; $7863
_label_11_394:
	ldh (<hFF92),a	; $7864
	call $786f		; $7866
	ldh a,(<hFF92)	; $7869
	dec a			; $786b
	jr nz,_label_11_394	; $786c
	ret			; $786e
_label_11_395:
	ld e,$f4		; $786f
	ld a,(de)		; $7871
	add a			; $7872
	add a			; $7873
	ld bc,$789d		; $7874
	call addDoubleIndexToBc		; $7877
	call getRandomNumber		; $787a
	and $07			; $787d
	call addAToBc		; $787f
	ld a,(bc)		; $7882
	ldh (<hFF8B),a	; $7883
	ld h,d			; $7885
	ld l,$f2		; $7886
	call checkFlag		; $7888
	jr nz,_label_11_395	; $788b
	call getFreePartSlot		; $788d
	ret nz			; $7890
	ld (hl),$49		; $7891
	inc l			; $7893
	ldh a,(<hFF8B)	; $7894
	ld (hl),a		; $7896
	ld h,d			; $7897
	ld l,$f2		; $7898
	jp setFlag		; $789a
	nop			; $789d
	ld bc,$0605		; $789e
	ld a,(bc)		; $78a1
	dec bc			; $78a2
	rrca			; $78a3
	nop			; $78a4
	ld bc,$0602		; $78a5
	rlca			; $78a8
	dec bc			; $78a9
	inc c			; $78aa
	dec c			; $78ab
	ld bc,$0403		; $78ac
	dec b			; $78af
	add hl,bc		; $78b0
	ld a,(bc)		; $78b1
	ld c,$0f		; $78b2
_label_11_396:
	inc bc			; $78b4
	ld (bc),a		; $78b5
	inc bc			; $78b6
	rlca			; $78b7
	ld ($0d09),sp		; $78b8
	ld c,$02		; $78bb
	ld a,(w1Link.xh)		; $78bd
	cp $50			; $78c0
	jr nc,_label_11_399	; $78c2
	ld a,(w1Link.yh)		; $78c4
_label_11_397:
	cp $40			; $78c7
	jr nc,_label_11_398	; $78c9
	xor a			; $78cb
	jr _label_11_401		; $78cc
_label_11_398:
	ld a,$01		; $78ce
	jr _label_11_401		; $78d0
_label_11_399:
	ld a,(w1Link.yh)		; $78d2
	cp $40			; $78d5
	jr nc,_label_11_400	; $78d7
	ld a,$02		; $78d9
	jr _label_11_401		; $78db
_label_11_400:
	ld a,$03		; $78dd
_label_11_401:
	ld e,$f4		; $78df
	ld (de),a		; $78e1
	ret			; $78e2
	ld h,d			; $78e3
	ld l,$c2		; $78e4
	ld a,(hl)		; $78e6
	ld hl,$791b		; $78e7
	rst_addDoubleIndex			; $78ea
	ld e,$cb		; $78eb
	ldi a,(hl)		; $78ed
	ld (de),a		; $78ee
	ld e,$cd		; $78ef
	ldi a,(hl)		; $78f1
	ld (de),a		; $78f2
	call objectGetAngleTowardLink		; $78f3
	ld e,$c9		; $78f6
	ld (de),a		; $78f8
	call getRandomNumber		; $78f9
	and $0f			; $78fc
	ld hl,$790b		; $78fe
	rst_addAToHl			; $7901
	ld b,(hl)		; $7902
	ld e,$c9		; $7903
	ld a,(de)		; $7905
	add b			; $7906
	and $1f			; $7907
	ld (de),a		; $7909
	ret			; $790a
	ld bc,$0302		; $790b
	rst $38			; $790e
	cp $fd			; $790f
	nop			; $7911
	nop			; $7912
	ld bc,$0202		; $7913
	rst $38			; $7916
	cp $00			; $7917
	nop			; $7919
	nop			; $791a
	nop			; $791b
	nop			; $791c
	nop			; $791d
	jr z,_label_11_402	; $791e
_label_11_402:
	ld d,b			; $7920
	nop			; $7921
	ld a,b			; $7922
	nop			; $7923
	and b			; $7924
	jr nz,_label_11_397	; $7925
	ld b,b			; $7927
	and b			; $7928
	ld h,b			; $7929
	and b			; $792a
	add b			; $792b
	and b			; $792c
	add b			; $792d
	ld a,b			; $792e
	add b			; $792f
	ld d,b			; $7930
	add b			; $7931
	jr z,_label_11_396	; $7932
	nop			; $7934
	ld h,b			; $7935
	nop			; $7936
	ld b,b			; $7937
	nop			; $7938
	jr nz,_label_11_403	; $7939
_label_11_403:
	call $78bd		; $793b
	ld e,$c2		; $793e
	ld a,(de)		; $7940
	add a			; $7941
	ld hl,$7962		; $7942
	rst_addDoubleIndex			; $7945
	ld e,$f4		; $7946
	ld a,(de)		; $7948
	rst_addAToHl			; $7949
	ld a,(hl)		; $794a
	ld bc,$79a2		; $794b
	call addAToBc		; $794e
	ld a,(bc)		; $7951
	ld h,d			; $7952
	ld l,$d0		; $7953
	ld (hl),a		; $7955
	ld l,$f1		; $7956
	ld (hl),$20		; $7958
	ld l,$d4		; $795a
	ld (hl),$80		; $795c
	inc l			; $795e
	ld (hl),$fd		; $795f
	ret			; $7961
	ld bc,$0504		; $7962
	ld ($0300),sp		; $7965
	inc b			; $7968
	dec b			; $7969
	nop			; $796a
	inc b			; $796b
	nop			; $796c
	inc b			; $796d
	inc bc			; $796e
	dec b			; $796f
	nop			; $7970
	inc b			; $7971
	dec b			; $7972
	ld ($0401),sp		; $7973
	dec b			; $7976
	ld b,$00		; $7977
	ld (bc),a		; $7979
	dec b			; $797a
	dec b			; $797b
	nop			; $797c
	nop			; $797d
	ld b,$05		; $797e
	ld (bc),a		; $7980
	nop			; $7981
	ld ($0405),sp		; $7982
	ld bc,$0305		; $7985
	inc b			; $7988
	nop			; $7989
	inc b			; $798a
	nop			; $798b
	inc b			; $798c
	nop			; $798d
	inc b			; $798e
	nop			; $798f
	dec b			; $7990
	inc bc			; $7991
	inc b			; $7992
	ld bc,$0508		; $7993
	ld (bc),a		; $7996
	nop			; $7997
	ld b,$05		; $7998
	nop			; $799a
	nop			; $799b
	inc b			; $799c
	inc b			; $799d
	nop			; $799e
	ld (bc),a		; $799f
	dec b			; $79a0
	ld b,$28		; $79a1
	ldd (hl),a		; $79a3
	inc a			; $79a4
	ld b,(hl)		; $79a5
	ld d,b			; $79a6
	ld e,d			; $79a7
	ld h,h			; $79a8
	ld l,(hl)		; $79a9
	ld a,b			; $79aa
	call objectGetShortPosition		; $79ab
	ld hl,wRoomLayout		; $79ae
	rst_addAToHl			; $79b1
	ld a,(hl)		; $79b2
	cp $54			; $79b3
	jr z,_label_11_404	; $79b5
	cp $55			; $79b7
	jr z,_label_11_405	; $79b9
	cp $56			; $79bb
	jr z,_label_11_406	; $79bd
	cp $57			; $79bf
	jr z,_label_11_407	; $79c1
	ret			; $79c3
_label_11_404:
	ld hl,$79e3		; $79c4
	ld e,$ca		; $79c7
	jr _label_11_408		; $79c9
_label_11_405:
	ld hl,$79e1		; $79cb
	ld e,$cc		; $79ce
	jr _label_11_408		; $79d0
_label_11_406:
	ld hl,$79e1		; $79d2
	ld e,$ca		; $79d5
	jr _label_11_408		; $79d7
_label_11_407:
	ld hl,$79e3		; $79d9
	ld e,$cc		; $79dc
_label_11_408:
	jp add16BitRefs		; $79de
	nop			; $79e1
	ld bc,$ff00		; $79e2


; ==============================================================================
; PARTID_SMOG_PROJECTILE
; ==============================================================================
partCode4a:
	ld e,Part.state		; $79e5
	ld a,(de)		; $79e7
	rst_jumpTable			; $79e8
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $79ef
	ld (de),a ; [state] = 1

	call objectSetVisible81		; $79f2

	call objectGetAngleTowardLink		; $79f5
	ld e,Part.angle		; $79f8
	ld (de),a		; $79fa
	ld c,a			; $79fb

	ld a,SPEED_c0		; $79fc
	ld e,Part.speed		; $79fe
	ld (de),a		; $7a00

	; Check if this is a projectile from a large smog or a small smog
	ld e,Part.subid		; $7a01
	ld a,(de)		; $7a03
	or a			; $7a04
	jr z,@setAnimation	; $7a05

	; If from a large smog, change some properties
	ld a,SPEED_100		; $7a07
	ld e,Part.speed		; $7a09
	ld (de),a		; $7a0b

	ld a,$05		; $7a0c
	ld e,Part.oamFlags		; $7a0e
	ld (de),a		; $7a10

	ld e,Part.enemyCollisionMode		; $7a11
	ld a,ENEMYCOLLISION_PODOBOO		; $7a13
	ld (de),a		; $7a15

	ld a,c			; $7a16
	call convertAngleToDirection		; $7a17
	and $01			; $7a1a
	add $02			; $7a1c

@setAnimation:
	call partSetAnimation		; $7a1e

@state1:
	; Delete self if boss defeated
	call getThisRoomFlags		; $7a21
	bit 6,a			; $7a24
	jr nz,@delete	; $7a26

	ld a,(wNumEnemies)		; $7a28
	dec a			; $7a2b
	jr z,@delete	; $7a2c

	call objectCheckWithinScreenBoundary		; $7a2e
	jr nc,@delete	; $7a31

	call objectApplySpeed		; $7a33

	; If large smog's projectile, return (it passes through everything)
	ld e,Part.subid		; $7a36
	ld a,(de)		; $7a38
	or a			; $7a39
	ret nz			; $7a3a

	; Check for collision with items
	ld e,Part.var2a		; $7a3b
	ld a,(de)		; $7a3d
	or a			; $7a3e
	jr nz,@beginDestroyAnimation	; $7a3f

	; Check for collision with wall
	call _partCommon_getTileCollisionInFront		; $7a41
	jr z,@state2	; $7a44

@beginDestroyAnimation:
	ld h,d			; $7a46
	ld l,Part.collisionType		; $7a47
	res 7,(hl)		; $7a49

	ld a,$02		; $7a4b
	ld l,Part.state		; $7a4d
	ld (hl),a		; $7a4f

	dec a			; $7a50
	call partSetAnimation		; $7a51


@state2:
	call partAnimate		; $7a54
	ld e,Part.animParameter		; $7a57
	ld a,(de)		; $7a59
	or a			; $7a5a
	ret z			; $7a5b
@delete:
	jp partDelete		; $7a5c

;;
; @addr{7a5f}
partCode4f:
	ld e,$c4		; $7a5f
	ld a,(de)		; $7a61
	rst_jumpTable			; $7a62
.dw $7a69
.dw $7a78
.dw $7a99
	ld a,$01		; $7a69
	ld (de),a		; $7a6b
	inc a			; $7a6c
	call partSetAnimation		; $7a6d
	ld e,$c6		; $7a70
	ld a,$28		; $7a72
	ld (de),a		; $7a74
	jp objectSetVisible80		; $7a75
	call partAnimate		; $7a78
	ld a,$02		; $7a7b
	call objectGetRelatedObject1Var		; $7a7d
	ld a,(hl)		; $7a80
	cp $0f			; $7a81
	jr nz,_label_11_414	; $7a83
	call _partCommon_decCounter1IfNonzero		; $7a85
	ret nz			; $7a88
	call objectGetAngleTowardLink		; $7a89
	ld e,$c9		; $7a8c
	ld (de),a		; $7a8e
	ld a,$50		; $7a8f
	ld e,$d0		; $7a91
	ld (de),a		; $7a93
	ld e,$c4		; $7a94
	ld a,$02		; $7a96
	ld (de),a		; $7a98
	call partAnimate		; $7a99
	call _partCommon_decCounter1IfNonzero		; $7a9c
	jr nz,_label_11_413	; $7a9f
	ld (hl),$0a		; $7aa1
	call objectGetAngleTowardLink		; $7aa3
	jp objectNudgeAngleTowards		; $7aa6
_label_11_413:
	call objectApplySpeed		; $7aa9
	call objectCheckWithinScreenBoundary		; $7aac
	ret c			; $7aaf
_label_11_414:
	jp partDelete		; $7ab0

;;
; @addr{7ab3}
partCode54:
	ld e,$c2		; $7ab3
	ld a,(de)		; $7ab5
	or a			; $7ab6
	ld e,$c4		; $7ab7
	jp nz,$7adb		; $7ab9
	ld a,(de)		; $7abc
	or a			; $7abd
	jr z,_label_11_415	; $7abe
	call _partCommon_decCounter1IfNonzero		; $7ac0
	jp z,partDelete		; $7ac3
	ld a,(hl)		; $7ac6
	and $0f			; $7ac7
	ret nz			; $7ac9
	call getFreePartSlot		; $7aca
	ret nz			; $7acd
	ld (hl),$54		; $7ace
	inc l			; $7ad0
	inc (hl)		; $7ad1
	ret			; $7ad2
_label_11_415:
	ld h,d			; $7ad3
	ld l,e			; $7ad4
	inc (hl)		; $7ad5
	ld l,$c6		; $7ad6
	ld (hl),$96		; $7ad8
	ret			; $7ada
	ld a,(de)		; $7adb
	or a			; $7adc
	jr nz,_label_11_416	; $7add
	inc a			; $7adf
	ld (de),a		; $7ae0
	ldh a,(<hCameraY)	; $7ae1
	ld b,a			; $7ae3
	ldh a,(<hCameraX)	; $7ae4
	ld c,a			; $7ae6
	call getRandomNumber		; $7ae7
	ld l,a			; $7aea
	and $07			; $7aeb
	swap a			; $7aed
	add $28			; $7aef
	add c			; $7af1
	ld e,$cd		; $7af2
	ld (de),a		; $7af4
	ld a,l			; $7af5
	and $70			; $7af6
	add $08			; $7af8
	ld l,a			; $7afa
	add b			; $7afb
	ld e,$cb		; $7afc
	ld (de),a		; $7afe
	ld a,l			; $7aff
	cpl			; $7b00
	inc a			; $7b01
	sub $07			; $7b02
	ld e,$cf		; $7b04
	ld (de),a		; $7b06
	jp objectSetVisiblec1		; $7b07
_label_11_416:
	ld c,$20		; $7b0a
	call objectUpdateSpeedZ_paramC		; $7b0c
	jp nz,partAnimate		; $7b0f
	call objectReplaceWithAnimationIfOnHazard		; $7b12
	jr c,_label_11_417	; $7b15
	ld b,$06		; $7b17
	call objectCreateInteractionWithSubid00		; $7b19
_label_11_417:
	jp partDelete		; $7b1c


; ==============================================================================
; PARTID_OCTOGON_BUBBLE
; ==============================================================================
partCode55:
	jr z,@normalStatus	; $7b1f

	; Collision occured with something. Check if it was Link.
	ld e,Part.var2a		; $7b21
	ld a,(de)		; $7b23
	cp $80|ITEMCOLLISION_LINK			; $7b24
	jp nz,@gotoState2		; $7b26

	call checkLinkVulnerable		; $7b29
	jr nc,@normalStatus	; $7b2c

	; Immobilize Link
	ld hl,wLinkForceState		; $7b2e
	ld a,LINK_STATE_COLLAPSED		; $7b31
	ldi (hl),a		; $7b33
	ld (hl),$01 ; [wcc50]

	ld h,d			; $7b36
	ld l,Part.state		; $7b37
	ld (hl),$03		; $7b39

	ld l,Part.zh		; $7b3b
	ld (hl),$00		; $7b3d

	ld l,Part.collisionType		; $7b3f
	res 7,(hl)		; $7b41
	call objectSetVisible81		; $7b43

@normalStatus:
	ld e,Part.state		; $7b46
	ld a,(de)		; $7b48
	rst_jumpTable			; $7b49
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3


; Uninitialized
@state0:
	ld h,d			; $7b52
	ld l,e			; $7b53
	inc (hl) ; [state] = 1

	ld l,Part.speed		; $7b55
	ld (hl),SPEED_80		; $7b57

	ld l,Part.counter1		; $7b59
	ld (hl),180		; $7b5b
	jp objectSetVisible82		; $7b5d


; Moving forward
@state1:
	call _partCommon_decCounter1IfNonzero		; $7b60
	jr z,@gotoState2	; $7b63

	ld a,(wFrameCounter)		; $7b65
	and $18			; $7b68
	rlca			; $7b6a
	swap a			; $7b6b
	ld hl,@zPositions		; $7b6d
	rst_addAToHl			; $7b70
	ld e,Part.zh		; $7b71
	ld a,(hl)		; $7b73
	ld (de),a		; $7b74
	call objectApplySpeed		; $7b75
@animate:
	jp partAnimate		; $7b78

@zPositions:
	.db $ff $fe $ff $00


; Stopped in place, waiting for signal from animation to delete self
@state2:
	call partAnimate		; $7b7f
	ld e,Part.animParameter		; $7b82
	ld a,(de)		; $7b84
	inc a			; $7b85
	ret nz			; $7b86
	jp partDelete		; $7b87


; Collided with Link
@state3:
	ld hl,w1Link		; $7b8a
	call objectTakePosition		; $7b8d

	ld a,(wLinkForceState)		; $7b90
	cp LINK_STATE_COLLAPSED			; $7b93
	ret z			; $7b95

	ld l,<w1Link.state		; $7b96
	ldi a,(hl)		; $7b98
	cp LINK_STATE_COLLAPSED			; $7b99
	jr z,@animate	; $7b9b

@gotoState2:
	ld h,d			; $7b9d
	ld l,Part.state		; $7b9e
	ld (hl),$02		; $7ba0

	ld l,Part.collisionType		; $7ba2
	res 7,(hl)		; $7ba4

	ld a,$01		; $7ba6
	jp partSetAnimation		; $7ba8

;;
; @addr{7bab}
partCode56:
	jr z,_label_11_421	; $7bab
	ld e,$ea		; $7bad
	ld a,(de)		; $7baf
	cp $80			; $7bb0
	jr nz,_label_11_421	; $7bb2
	ld hl,$d031		; $7bb4
	ld (hl),$10		; $7bb7
	ld l,$30		; $7bb9
	ld (hl),$00		; $7bbb
	ld l,$24		; $7bbd
	res 7,(hl)		; $7bbf
	ld bc,$fa00		; $7bc1
	call objectCopyPositionWithOffset		; $7bc4
	ld h,d			; $7bc7
	ld l,$f0		; $7bc8
	ld (hl),$01		; $7bca
	ld l,$c4		; $7bcc
	ldi a,(hl)		; $7bce
	dec a			; $7bcf
	jr nz,_label_11_421	; $7bd0
	inc l			; $7bd2
	ld a,$01		; $7bd3
	ldi (hl),a		; $7bd5
	ld (hl),a		; $7bd6
_label_11_421:
	ld e,$c2		; $7bd7
	ld a,(de)		; $7bd9
	ld e,$c4		; $7bda
	rst_jumpTable			; $7bdc
.dw $7be5
.dw $7c3c
.dw $7d1f
.dw $7d42
	ld a,(de)		; $7be5
	or a			; $7be6
	jr z,_label_11_424	; $7be7
	call _partCommon_decCounter1IfNonzero		; $7be9
	jr nz,_label_11_422	; $7bec
	ld (hl),$04		; $7bee
	call getFreePartSlot		; $7bf0
	jr nz,_label_11_422	; $7bf3
	ld (hl),$56		; $7bf5
	inc l			; $7bf7
	ld (hl),$02		; $7bf8
	ld l,$d6		; $7bfa
	ld e,l			; $7bfc
	ld a,(de)		; $7bfd
	ldi (hl),a		; $7bfe
	inc e			; $7bff
	ld a,(de)		; $7c00
	ld (hl),a		; $7c01
	call objectCopyPosition		; $7c02
_label_11_422:
	ld a,$02		; $7c05
	call objectGetRelatedObject1Var		; $7c07
	ld a,(hl)		; $7c0a
	dec a			; $7c0b
	jp nz,$7c28		; $7c0c
	ld c,h			; $7c0f
	ldh a,(<hCameraY)	; $7c10
	ld b,a			; $7c12
	ld e,$cf		; $7c13
	ld a,(de)		; $7c15
	sub $04			; $7c16
	ld (de),a		; $7c18
	ld h,d			; $7c19
	ld l,$cb		; $7c1a
	add (hl)		; $7c1c
	sub b			; $7c1d
	cp $b0			; $7c1e
	ret c			; $7c20
	ld h,c			; $7c21
	ld l,$b8		; $7c22
	inc (hl)		; $7c24
	jp partDelete		; $7c25
_label_11_423:
	call objectCreatePuff		; $7c28
	jp partDelete		; $7c2b
_label_11_424:
	ld h,d			; $7c2e
	ld l,e			; $7c2f
	inc (hl)		; $7c30
	ld l,$c6		; $7c31
	inc (hl)		; $7c33
	call objectSetVisible80		; $7c34
_label_11_425:
	ld a,SND_BEAM2		; $7c37
	jp playSound		; $7c39
	ld a,$02		; $7c3c
	call objectGetRelatedObject1Var		; $7c3e
	ld a,(hl)		; $7c41
	dec a			; $7c42
	jr nz,_label_11_423	; $7c43
	ld l,$ad		; $7c45
	ld a,(hl)		; $7c47
	or a			; $7c48
	jr nz,_label_11_423	; $7c49
	ld e,$c4		; $7c4b
	ld a,(de)		; $7c4d
	rst_jumpTable			; $7c4e
.dw $7c59
.dw $7c92
.dw $7cc9
.dw $7cd1
.dw $7d10
	ld h,d			; $7c59
	ld l,e			; $7c5a
	inc (hl)		; $7c5b
	ld l,$c6		; $7c5c
	ld (hl),$01		; $7c5e
	inc l			; $7c60
	ld (hl),$05		; $7c61
	ld l,$e4		; $7c63
	set 7,(hl)		; $7c65
	ld l,$d0		; $7c67
	ld (hl),$50		; $7c69
	ld l,$f1		; $7c6b
	ld e,$cb		; $7c6d
	ld a,(de)		; $7c6f
	add $10			; $7c70
	ldi (hl),a		; $7c72
	ld (de),a		; $7c73
	ld e,$cd		; $7c74
	ld a,(de)		; $7c76
	ld (hl),a		; $7c77
	call objectGetAngleTowardLink		; $7c78
	cp $0e			; $7c7b
	ld b,$0c		; $7c7d
	jr c,_label_11_426	; $7c7f
	ld b,$10		; $7c81
	cp $13			; $7c83
	jr c,_label_11_426	; $7c85
	ld b,$14		; $7c87
_label_11_426:
	ld e,$c9		; $7c89
	ld a,b			; $7c8b
	ld (de),a		; $7c8c
	call objectSetVisible81		; $7c8d
	jr _label_11_425		; $7c90
	call _partCommon_decCounter1IfNonzero		; $7c92
	jr nz,_label_11_427	; $7c95
	ld (hl),$08		; $7c97
	inc l			; $7c99
	dec (hl)		; $7c9a
	jr z,_label_11_428	; $7c9b
	call getFreePartSlot		; $7c9d
	jr nz,_label_11_427	; $7ca0
	ld (hl),$56		; $7ca2
	inc l			; $7ca4
	ld (hl),$03		; $7ca5
	ld l,$d6		; $7ca7
	ld a,$c0		; $7ca9
	ldi (hl),a		; $7cab
	ld (hl),d		; $7cac
	call objectCopyPosition		; $7cad
_label_11_427:
	call _partCommon_checkTileCollisionOrOutOfBounds		; $7cb0
	jp nc,objectApplySpeed		; $7cb3
_label_11_428:
	ld h,d			; $7cb6
	ld l,$c4		; $7cb7
	inc (hl)		; $7cb9
	ld l,$c6		; $7cba
	ld (hl),$1e		; $7cbc
	ld l,$d0		; $7cbe
	ld (hl),$3c		; $7cc0
	ld l,$c9		; $7cc2
	ld a,(hl)		; $7cc4
	xor $10			; $7cc5
	ld (hl),a		; $7cc7
	ret			; $7cc8
	call _partCommon_decCounter1IfNonzero		; $7cc9
	ret nz			; $7ccc
	ld l,$c4		; $7ccd
	inc (hl)		; $7ccf
	ret			; $7cd0
	call objectApplySpeed		; $7cd1
	ld e,$f0		; $7cd4
	ld a,(de)		; $7cd6
	or a			; $7cd7
	jr z,_label_11_429	; $7cd8
	ld bc,$fa00		; $7cda
	ld hl,$d000		; $7cdd
	call objectCopyPositionWithOffset		; $7ce0
_label_11_429:
	ld h,d			; $7ce3
	ld l,$f1		; $7ce4
	ld e,$cb		; $7ce6
	ld a,(de)		; $7ce8
	sub (hl)		; $7ce9
	add $02			; $7cea
	cp $05			; $7cec
	ret nc			; $7cee
	ld l,$f2		; $7cef
	ld e,$cd		; $7cf1
	ld a,(de)		; $7cf3
	sub (hl)		; $7cf4
	add $02			; $7cf5
	cp $05			; $7cf7
	ret nc			; $7cf9
	ld a,$38		; $7cfa
	call objectGetRelatedObject1Var		; $7cfc
	inc (hl)		; $7cff
	ld e,$f0		; $7d00
	ld a,(de)		; $7d02
	or a			; $7d03
	jp z,partDelete		; $7d04
	ld l,$86		; $7d07
	ld (hl),$08		; $7d09
	ld h,d			; $7d0b
	ld l,$c4		; $7d0c
	inc (hl)		; $7d0e
	ret			; $7d0f
	ld hl,$d005		; $7d10
	ld a,(hl)		; $7d13
	cp $02			; $7d14
	jp z,partDelete		; $7d16
	ld bc,$0600		; $7d19
	jp objectTakePositionWithOffset		; $7d1c
	ld a,(de)		; $7d1f
	or a			; $7d20
	jr z,_label_11_431	; $7d21
	ld a,$1a		; $7d23
	call objectGetRelatedObject1Var		; $7d25
	bit 7,(hl)		; $7d28
	jr z,_label_11_430	; $7d2a
	ld l,$8f		; $7d2c
	ld b,(hl)		; $7d2e
	dec b			; $7d2f
	ld e,$cf		; $7d30
	ld a,(de)		; $7d32
	dec a			; $7d33
	cp b			; $7d34
	ret c			; $7d35
_label_11_430:
	jp partDelete		; $7d36
_label_11_431:
	inc a			; $7d39
	ld (de),a		; $7d3a
	inc a			; $7d3b
	call partSetAnimation		; $7d3c
	jp objectSetVisible80		; $7d3f
	ld a,(de)		; $7d42
	or a			; $7d43
	jr z,_label_11_433	; $7d44
	ld a,$01		; $7d46
	call objectGetRelatedObject1Var		; $7d48
	ld a,(hl)		; $7d4b
	cp $56			; $7d4c
	jr nz,_label_11_432	; $7d4e
	ld l,$cb		; $7d50
	ld e,l			; $7d52
	ld a,(de)		; $7d53
	cp (hl)			; $7d54
	ret c			; $7d55
_label_11_432:
	jp partDelete		; $7d56
_label_11_433:
	inc a			; $7d59
	ld (de),a		; $7d5a
	ld a,$09		; $7d5b
	call objectGetRelatedObject1Var		; $7d5d
	ld a,(hl)		; $7d60
	sub $0c			; $7d61
	rrca			; $7d63
	rrca			; $7d64
	inc a			; $7d65
	call partSetAnimation		; $7d66
	jp objectSetVisible83		; $7d69

;;
; @addr{7d6c}
partCode57:
	ld e,$c4		; $7d6c
	ld a,(de)		; $7d6e
	rst_jumpTable			; $7d6f
.dw $7d7e
.dw $7d9c
.dw $7dad
.dw $7dc7
.dw $7dcf
.dw $7dd6
.dw $7e10
	call objectCenterOnTile		; $7d7e
	call objectGetShortPosition		; $7d81
	ld e,$f0		; $7d84
	ld (de),a		; $7d86
	ld e,$c6		; $7d87
	ld a,$04		; $7d89
	ld (de),a		; $7d8b
	ld a,SND_UNKNOWN3		; $7d8c
	call playSound		; $7d8e
	ld hl,$7d98		; $7d91
	ld a,$60		; $7d94
	jr _label_11_434		; $7d96
	ld a,($ff00+R_IE)	; $7d98
	ld bc,wScreenScrollRow		; $7d9a
	and a			; $7d9d
	ld b,b			; $7d9e
	ret nz			; $7d9f
	ld (hl),$04		; $7da0
	ld hl,$7da9		; $7da2
	ld a,$60		; $7da5
	jr _label_11_434		; $7da7
	rst $28			; $7da9
	pop af			; $7daa
	rrca			; $7dab
	ld de,$a7cd		; $7dac
	ld b,b			; $7daf
	ret nz			; $7db0
	ld (hl),$2d		; $7db1
	ld l,e			; $7db3
	inc (hl)		; $7db4
	ld l,$60		; $7db5
	ld e,$f0		; $7db7
	ld a,(de)		; $7db9
	ld c,a			; $7dba
	ld b,$cf		; $7dbb
	ld a,(bc)		; $7dbd
	sub $02			; $7dbe
	cp $03			; $7dc0
	ret c			; $7dc2
	ld a,l			; $7dc3
	jp setTile		; $7dc4
	call _partCommon_decCounter1IfNonzero		; $7dc7
	ret nz			; $7dca
	ld (hl),$04		; $7dcb
	ld l,e			; $7dcd
	inc (hl)		; $7dce
	ld hl,$7da9		; $7dcf
	ld a,$a0		; $7dd2
	jr _label_11_434		; $7dd4
	call _partCommon_decCounter1IfNonzero		; $7dd6
	ret nz			; $7dd9
	ld (hl),$04		; $7dda
	ld hl,$7d98		; $7ddc
	ld a,$a0		; $7ddf
_label_11_434:
	ldh (<hFF8B),a	; $7de1
	ld e,$f0		; $7de3
	ld a,(de)		; $7de5
	ld c,a			; $7de6
	ld b,$04		; $7de7
_label_11_435:
	push bc			; $7de9
	ldi a,(hl)		; $7dea
	add c			; $7deb
	ld c,a			; $7dec
	ld b,$cf		; $7ded
	ld a,(bc)		; $7def
	cp $da			; $7df0
	jr z,_label_11_436	; $7df2
	sub $02			; $7df4
	cp $03			; $7df6
	jr c,_label_11_437	; $7df8
	ld b,$ce		; $7dfa
	ld a,(bc)		; $7dfc
	or a			; $7dfd
	jr nz,_label_11_437	; $7dfe
_label_11_436:
	ldh a,(<hFF8B)	; $7e00
	push hl			; $7e02
	call setTile		; $7e03
	pop hl			; $7e06
_label_11_437:
	pop bc			; $7e07
	dec b			; $7e08
	jr nz,_label_11_435	; $7e09
	ld h,d			; $7e0b
	ld l,$c4		; $7e0c
	inc (hl)		; $7e0e
	ret			; $7e0f
	call _partCommon_decCounter1IfNonzero		; $7e10
	ret nz			; $7e13
	ld l,$a0		; $7e14
	call $7db7		; $7e16
	jp partDelete		; $7e19

;;
; @addr{7e1c}
partCode58:
	jr z,_label_11_438	; $7e1c
	ld e,$ea		; $7e1e
	ld a,(de)		; $7e20
	cp $80			; $7e21
	jr nz,_label_11_438	; $7e23
	ld h,d			; $7e25
	ld l,$e4		; $7e26
	res 7,(hl)		; $7e28
	ld l,$c4		; $7e2a
	ld (hl),$03		; $7e2c
	ld l,$c6		; $7e2e
	ld (hl),$f0		; $7e30
	call objectSetInvisible		; $7e32
_label_11_438:
	ld e,$c4		; $7e35
	ld a,(de)		; $7e37
	rst_jumpTable			; $7e38
.dw $7e41
.dw $7e58
.dw $7e6a
.dw $7e76
	ld h,d			; $7e41
	ld l,e			; $7e42
	inc (hl)		; $7e43
	ld l,$c9		; $7e44
	ld (hl),$10		; $7e46
	ld l,$d0		; $7e48
	ld (hl),$78		; $7e4a
	ld l,$c6		; $7e4c
	ld (hl),$09		; $7e4e
	ld a,SND_BEAM		; $7e50
	call playSound		; $7e52
	call objectSetVisible83		; $7e55
	call _partCommon_decCounter1IfNonzero		; $7e58
	jr z,_label_11_439	; $7e5b
	ld a,$0b		; $7e5d
	call objectGetRelatedObject1Var		; $7e5f
	ld bc,$1400		; $7e62
	jp objectTakePositionWithOffset		; $7e65
_label_11_439:
	ld l,e			; $7e68
	inc (hl)		; $7e69
	call objectApplySpeed		; $7e6a
	ld e,$cb		; $7e6d
	ld a,(de)		; $7e6f
	cp $b0			; $7e70
	ret c			; $7e72
	jp partDelete		; $7e73
	call _partCommon_decCounter1IfNonzero		; $7e76
	jp z,partDelete		; $7e79
	ld a,(wGameKeysJustPressed)		; $7e7c
	or a			; $7e7f
	jr z,_label_11_441	; $7e80
	ld a,(hl)		; $7e82
	sub $0a			; $7e83
	jr nc,_label_11_440	; $7e85
	ld a,$01		; $7e87
_label_11_440:
	ld (hl),a		; $7e89
_label_11_441:
	ld hl,wccd8		; $7e8a
	set 5,(hl)		; $7e8d
	ld a,(wFrameCounter)		; $7e8f
	rrca			; $7e92
	ret nc			; $7e93
	ld hl,wLinkImmobilized		; $7e94
	set 5,(hl)		; $7e97
	ret			; $7e99

;;
; @addr{7e9a}
partCode59:
	ld e,$c4		; $7e9a
	ld a,(de)		; $7e9c
	rst_jumpTable			; $7e9d
.dw $7eaa
.dw $7ec1
.dw $7edc
.dw $7ee7
.dw $7f03
.dw $7f30
	ld h,d			; $7eaa
	ld l,e			; $7eab
	inc (hl)		; $7eac
	ld l,$d0		; $7ead
	ld (hl),$14		; $7eaf
	ld l,$c2		; $7eb1
	ld a,(hl)		; $7eb3
	ld hl,$7ebd		; $7eb4
	rst_addAToHl			; $7eb7
	ld e,$c6		; $7eb8
	ld a,(hl)		; $7eba
	ld (de),a		; $7ebb
	ret			; $7ebc
	ld bc,$2814		; $7ebd
	inc a			; $7ec0
	call _partCommon_decCounter1IfNonzero		; $7ec1
	ret nz			; $7ec4
	ld l,e			; $7ec5
	inc (hl)		; $7ec6
	ld l,$c2		; $7ec7
	ld a,(hl)		; $7ec9
	xor $03			; $7eca
	ld hl,$7ebd		; $7ecc
	rst_addAToHl			; $7ecf
	ld e,$c6		; $7ed0
	ld a,(hl)		; $7ed2
	ld (de),a		; $7ed3
	ld a,SND_LIGHTTORCH		; $7ed4
	call playSound		; $7ed6
	jp objectSetVisible83		; $7ed9
	call _partCommon_decCounter1IfNonzero		; $7edc
	jr nz,_label_11_444	; $7edf
	ld (hl),$14		; $7ee1
	ld l,e			; $7ee3
	inc (hl)		; $7ee4
	jr _label_11_444		; $7ee5
	call _partCommon_decCounter1IfNonzero		; $7ee7
	jr nz,_label_11_444	; $7eea
	ld hl,$6dbc		; $7eec
	ld e,$10		; $7eef
	call interBankCall		; $7ef1
	ld h,d			; $7ef4
	ld l,$c4		; $7ef5
	inc (hl)		; $7ef7
	ld a,b			; $7ef8
	or a			; $7ef9
	jr nz,_label_11_444	; $7efa
	inc (hl)		; $7efc
	ld l,$c6		; $7efd
	ld (hl),$10		; $7eff
	jr _label_11_444		; $7f01
	ld h,d			; $7f03
	ld l,$f0		; $7f04
	ldi a,(hl)		; $7f06
	ld b,a			; $7f07
	ld c,(hl)		; $7f08
	ld l,$cb		; $7f09
	ldi a,(hl)		; $7f0b
	ldh (<hFF8F),a	; $7f0c
	inc l			; $7f0e
	ld a,(hl)		; $7f0f
	ldh (<hFF8E),a	; $7f10
	cp c			; $7f12
	jr nz,_label_11_442	; $7f13
	ldh a,(<hFF8F)	; $7f15
	cp b			; $7f17
	jr nz,_label_11_442	; $7f18
	ld l,e			; $7f1a
	dec (hl)		; $7f1b
	ld l,$c6		; $7f1c
	ld (hl),$10		; $7f1e
	inc l			; $7f20
	inc (hl)		; $7f21
	jr _label_11_444		; $7f22
_label_11_442:
	call objectGetRelativeAngleWithTempVars		; $7f24
	ld e,$c9		; $7f27
	ld (de),a		; $7f29
	call objectApplySpeed		; $7f2a
_label_11_444:
	jp partAnimate		; $7f2d
	call _partCommon_decCounter1IfNonzero		; $7f30
	jr nz,_label_11_444	; $7f33
	call objectCreatePuff		; $7f35
	jp partDelete		; $7f38

;;
; Stone blocking path to Nayru at the start of the game (only after being moved)
; @addr{7f3b}
partCode5a:
	ld e,Part.state		; $7f3b
	ld a,(de)		; $7f3d
	or a			; $7f3e
	ret nz			; $7f3f

	inc a			; $7f40
	ld (de),a		; $7f41

	call getThisRoomFlags		; $7f42
	and $c0			; $7f45
	jp z,partDelete		; $7f47

	and $40			; $7f4a
	ld a,$28		; $7f4c
	jr nz,+			; $7f4e
	ld a,$48		; $7f50
+
	ld e,Part.xh		; $7f52
	ld (de),a		; $7f54
	call objectMakeTileSolid		; $7f55
	ld h,>wRoomLayout		; $7f58
	ld (hl),$00		; $7f5a
	ld a,PALH_98		; $7f5c
	call loadPaletteHeader		; $7f5e
	jp objectSetVisible83		; $7f61
