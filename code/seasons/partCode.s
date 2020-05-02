partCode01:
	jr z,_label_10_006	; $4113
	cp $02			; $4115
	jp z,$4223		; $4117
	ld e,$c4		; $411a
	ld a,$03		; $411c
	ld (de),a		; $411e
_label_10_006:
	call $4219		; $411f
	ld e,$c4		; $4122
	ld a,(de)		; $4124
	rst_jumpTable			; $4125
	ld l,$41		; $4126
	add e			; $4128
	ld b,c			; $4129
	pop bc			; $412a
	ld b,c			; $412b
	and $41			; $412c
	ld a,($cc3a)		; $412e
	or a			; $4131
	jp nz,partDelete		; $4132
	ld e,$c2		; $4135
	ld a,(de)		; $4137
	cp $0f			; $4138
	jr nz,_label_10_007	; $413a
	call getRandomNumber_noPreserveVars		; $413c
	cp $e0			; $413f
	jp c,$4316		; $4141
	ld a,($cc50)		; $4144
	cp $81			; $4147
	jp z,partDelete		; $4149
_label_10_007:
	call $429b		; $414c
	ld h,d			; $414f
	ld l,$d4		; $4150
	ld a,$a0		; $4152
	ldi (hl),a		; $4154
	ld (hl),$fe		; $4155
	ld l,$c4		; $4157
	inc (hl)		; $4159
	ld a,($cc50)		; $415a
	and $20			; $415d
	jr z,_label_10_008	; $415f
	inc (hl)		; $4161
	ld l,$e4		; $4162
	set 7,(hl)		; $4164
	ld l,$c6		; $4166
	ld (hl),$f0		; $4168
	call objectCheckIsOnHazard		; $416a
	jr nc,_label_10_008	; $416d
	rrca			; $416f
	jr nc,_label_10_008	; $4170
	ld e,$f4		; $4172
	ld a,$01		; $4174
	ld (de),a		; $4176
_label_10_008:
	ld e,$c2		; $4177
	ld a,(de)		; $4179
	call $42f5		; $417a
	ld e,$c2		; $417d
	ld a,(de)		; $417f
	jp partSetAnimation		; $4180
	call $4030		; $4183
	call nc,$430f		; $4186
	ld c,$20		; $4189
	call objectUpdateSpeedZAndBounce		; $418b
	jr c,_label_10_009	; $418e
	call $437b		; $4190
	jr nc,_label_10_010	; $4193
_label_10_009:
	ld h,d			; $4195
	ld l,$c4		; $4196
	inc (hl)		; $4198
	ld l,$c6		; $4199
	ld (hl),$f0		; $419b
	call objectSetVisiblec3		; $419d
_label_10_010:
	call $4434		; $41a0
	jr c,_label_10_011	; $41a3
	call $439c		; $41a5
	ret c			; $41a8
_label_10_011:
	ld e,$cf		; $41a9
	ld a,(de)		; $41ab
	rlca			; $41ac
	ret c			; $41ad
	ld bc,$0500		; $41ae
	call objectGetRelativeTile		; $41b1
	ld hl,$4484		; $41b4
	call lookupCollisionTable		; $41b7
	ret nc			; $41ba
	ld c,a			; $41bb
	ld b,$14		; $41bc
	jp $446e		; $41be
	call $4348		; $41c1
	call $4417		; $41c4
	jp c,$41d9		; $41c7
	call $42d0		; $41ca
	jp c,partDelete		; $41cd
	ld e,$c2		; $41d0
	ld a,(de)		; $41d2
	or a			; $41d3
	jr nz,_label_10_010	; $41d4
	jp $43d5		; $41d6
	ld h,d			; $41d9
	ld l,$f1		; $41da
	ldi a,(hl)		; $41dc
	ld c,(hl)		; $41dd
	ld l,$cb		; $41de
	ldi (hl),a		; $41e0
	inc l			; $41e1
	ld (hl),c		; $41e2
	jp partDelete		; $41e3
	ld e,$c5		; $41e6
	ld a,(de)		; $41e8
	or a			; $41e9
	call z,$4206		; $41ea
	call objectCheckCollidedWithLink_ignoreZ		; $41ed
	jp c,$4223		; $41f0
	ld a,$00		; $41f3
	call objectGetRelatedObject1Var		; $41f5
	ldi a,(hl)		; $41f8
	or a			; $41f9
	jr z,_label_10_012	; $41fa
	ld e,$f0		; $41fc
	ld a,(de)		; $41fe
	cp (hl)			; $41ff
	jp z,objectTakePosition		; $4200
_label_10_012:
	jp partDelete		; $4203
	ld h,d			; $4206
	ld l,e			; $4207
	inc (hl)		; $4208
	ld l,$cf		; $4209
	ld (hl),$00		; $420b
	ld a,$01		; $420d
	call objectGetRelatedObject1Var		; $420f
	ld a,(hl)		; $4212
	ld e,$f0		; $4213
	ld (de),a		; $4215
	jp objectSetVisible80		; $4216
	ld e,$e4		; $4219
	ld a,(de)		; $421b
	rlca			; $421c
	ret nc			; $421d
	call objectCheckCollidedWithLink		; $421e
	ret nc			; $4221
	pop hl			; $4222
	ld a,($cc34)		; $4223
	or a			; $4226
	jr nz,_label_10_015	; $4227
	ld e,$c2		; $4229
	ld a,(de)		; $422b
	add a			; $422c
	ld hl,$425b		; $422d
	rst_addDoubleIndex			; $4230
	ldi a,(hl)		; $4231
	or a			; $4232
	jr z,_label_10_015	; $4233
	ld b,a			; $4235
	ld a,$26		; $4236
	call cpActiveRing		; $4238
	ldi a,(hl)		; $423b
	jr z,_label_10_013	; $423c
	or a			; $423e
	jr z,_label_10_014	; $423f
	call cpActiveRing		; $4241
	jr nz,_label_10_014	; $4244
_label_10_013:
	inc hl			; $4246
_label_10_014:
	ld c,(hl)		; $4247
	ld a,b			; $4248
	call giveTreasure		; $4249
	ld e,$c2		; $424c
	ld a,(de)		; $424e
	cp $0e			; $424f
	jr nz,_label_10_015	; $4251
	call getThisRoomFlags		; $4253
	set 5,(hl)		; $4256
_label_10_015:
	jp partDelete		; $4258
	add hl,hl		; $425b
	dec h			; $425c
	jr $30			; $425d
	add hl,hl		; $425f
	dec h			; $4260
	inc b			; $4261
	ld ($2428),sp		; $4262
	ld bc,$2802		; $4265
	inc h			; $4268
	inc bc			; $4269
	inc b			; $426a
	inc bc			; $426b
	nop			; $426c
	inc b			; $426d
	ld ($0020),sp		; $426e
	dec b			; $4271
	ld a,(bc)		; $4272
	ld hl,$0500		; $4273
	ld a,(bc)		; $4276
	ldi (hl),a		; $4277
	nop			; $4278
	dec b			; $4279
	ld a,(bc)		; $427a
	inc hl			; $427b
	nop			; $427c
	dec b			; $427d
	ld a,(bc)		; $427e
	inc h			; $427f
	nop			; $4280
	dec b			; $4281
	ld a,(bc)		; $4282
	nop			; $4283
	nop			; $4284
	nop			; $4285
	nop			; $4286
	nop			; $4287
	nop			; $4288
	nop			; $4289
	nop			; $428a
	scf			; $428b
	daa			; $428c
	ld bc,$3702		; $428d
	daa			; $4290
	inc b			; $4291
	dec b			; $4292
	scf			; $4293
	daa			; $4294
	dec bc			; $4295
	inc c			; $4296
	jr z,_label_10_016	; $4297
	inc c			; $4299
	dec c			; $429a
	ld e,$c2		; $429b
	ld a,(de)		; $429d
	ld hl,$42b0		; $429e
	rst_addDoubleIndex			; $42a1
	ld e,$dd		; $42a2
	ld a,(de)		; $42a4
	add (hl)		; $42a5
	ld (de),a		; $42a6
	inc hl			; $42a7
	dec e			; $42a8
	ld a,(hl)		; $42a9
	ld (de),a		; $42aa
	dec e			; $42ab
	ld (de),a		; $42ac
	jp objectSetVisiblec1		; $42ad
	nop			; $42b0
	ld (bc),a		; $42b1
	ld (bc),a		; $42b2
	dec b			; $42b3
	inc b			; $42b4
	nop			; $42b5
	ld b,$05		; $42b6
	stop			; $42b8
	inc b			; $42b9
	ld (de),a		; $42ba
	ld (bc),a		; $42bb
	inc d			; $42bc
_label_10_016:
	inc bc			; $42bd
	ld d,$01		; $42be
	jr _label_10_017		; $42c0
	ld a,(de)		; $42c2
_label_10_017:
	nop			; $42c3
	inc e			; $42c4
	nop			; $42c5
	ld e,$00		; $42c6
	inc c			; $42c8
	ld bc,$020c		; $42c9
	inc c			; $42cc
	inc bc			; $42cd
	ld ($fa04),sp		; $42ce
	nop			; $42d1
	call z,$0faa		; $42d2
	ret nc			; $42d5
	ld h,d			; $42d6
	ld l,$f3		; $42d7
	ld a,(hl)		; $42d9
	or a			; $42da
	jr z,_label_10_018	; $42db
	dec (hl)		; $42dd
	ret nz			; $42de
	ld l,$e4		; $42df
	set 7,(hl)		; $42e1
_label_10_018:
	call partCommon_decCounter1IfNonzero		; $42e3
	jr z,_label_10_019	; $42e6
	ld a,(hl)		; $42e8
	cp $3c			; $42e9
	ret nc			; $42eb
	ld l,$da		; $42ec
	ld a,(hl)		; $42ee
	xor $80			; $42ef
	ld (hl),a		; $42f1
	ret			; $42f2
_label_10_019:
	scf			; $42f3
	ret			; $42f4
	ld h,d			; $42f5
	or a			; $42f6
	jr z,_label_10_020	; $42f7
	ld e,$c3		; $42f9
	ld a,(de)		; $42fb
	rrca			; $42fc
	ret nc			; $42fd
	ld l,$d0		; $42fe
	ld (hl),$19		; $4300
	ret			; $4302
_label_10_020:
	ld l,$cf		; $4303
	ld a,(hl)		; $4305
	ld (hl),$00		; $4306
	ld l,$cb		; $4308
	add (hl)		; $430a
	ld (hl),a		; $430b
	jp $43e2		; $430c
	call objectCheckTileCollision_allowHoles		; $430f
	ret c			; $4312
	jp objectApplySpeed		; $4313
	ld c,a			; $4316
	ld a,($ccf4)		; $4317
	or a			; $431a
	jr nz,_label_10_022	; $431b
	ld b,$2d		; $431d
	ld a,($cc50)		; $431f
	cp $81			; $4322
	jr z,_label_10_021	; $4324
	ld a,c			; $4326
	and $07			; $4327
	ld hl,$4340		; $4329
	rst_addAToHl			; $432c
	ld b,(hl)		; $432d
_label_10_021:
	call getFreeEnemySlot		; $432e
	jr nz,_label_10_022	; $4331
	ld (hl),b		; $4333
	call objectCopyPosition		; $4334
	ld e,$c3		; $4337
	ld a,(de)		; $4339
	ld l,$82		; $433a
	ld (hl),a		; $433c
_label_10_022:
	jp partDelete		; $433d
	stop			; $4340
	stop			; $4341
	stop			; $4342
	ld d,c			; $4343
	ld d,c			; $4344
	ld d,c			; $4345
	ld d,c			; $4346
	ld d,c			; $4347
	ld a,($cc50)		; $4348
	and $20			; $434b
	ret z			; $434d
	ld e,$c2		; $434e
	ld a,(de)		; $4350
	or a			; $4351
	ret z			; $4352
	ld a,$20		; $4353
	call objectUpdateSpeedZ_sidescroll		; $4355
	jr c,_label_10_024	; $4358
	ld e,$f4		; $435a
	ld a,(de)		; $435c
	rrca			; $435d
	jr nc,_label_10_024	; $435e
	ld b,$01		; $4360
	ld a,(hl)		; $4362
	bit 7,a			; $4363
	jr z,_label_10_023	; $4365
	ld b,$ff		; $4367
	inc a			; $4369
_label_10_023:
	cp $01			; $436a
	ret c			; $436c
	ld (hl),b		; $436d
	dec l			; $436e
	ld (hl),$00		; $436f
_label_10_024:
	ld e,$cb		; $4371
	ld a,(de)		; $4373
	cp $b0			; $4374
	ret c			; $4376
	pop hl			; $4377
	jp partDelete		; $4378
	ld e,$c2		; $437b
	ld a,(de)		; $437d
	or a			; $437e
	jr z,_label_10_025	; $437f
	ld e,$d5		; $4381
	ld a,(de)		; $4383
	and $80			; $4384
	ret nz			; $4386
	ld h,d			; $4387
	ld l,$e4		; $4388
	set 7,(hl)		; $438a
	ret			; $438c
_label_10_025:
	ld e,$cf		; $438d
	ld a,(de)		; $438f
	cp $fa			; $4390
	ret nc			; $4392
	ld h,d			; $4393
	ld l,e			; $4394
	ld (hl),$fa		; $4395
	ld l,$f3		; $4397
	ld (hl),$05		; $4399
	ret			; $439b
	call objectCheckIsOnHazard		; $439c
	jr c,_label_10_026	; $439f
	ld e,$f4		; $43a1
	ld a,(de)		; $43a3
	rrca			; $43a4
	ret nc			; $43a5
	ld b,$03		; $43a6
	xor a			; $43a8
	jr _label_10_030		; $43a9
_label_10_026:
	rrca			; $43ab
	jr c,_label_10_029	; $43ac
	rrca			; $43ae
	ld b,$04		; $43af
	jr nc,_label_10_027	; $43b1
	call objectCreateFallingDownHoleInteraction		; $43b3
	jr _label_10_028		; $43b6
_label_10_027:
	call objectCreateInteractionWithSubid00		; $43b8
_label_10_028:
	call partDelete		; $43bb
	scf			; $43be
	ret			; $43bf
_label_10_029:
	ld b,$03		; $43c0
	ld a,($cc50)		; $43c2
	and $20			; $43c5
	jr z,_label_10_027	; $43c7
	ld e,$f4		; $43c9
	ld a,(de)		; $43cb
	rrca			; $43cc
	ccf			; $43cd
	ret nc			; $43ce
	ld a,$01		; $43cf
_label_10_030:
	ld (de),a		; $43d1
	jp objectCreateInteractionWithSubid00		; $43d2
	ld h,d			; $43d5
	ld l,$c7		; $43d6
	dec (hl)		; $43d8
	jr z,_label_10_031	; $43d9
	call _partCommon_getTileCollisionInFront		; $43db
	inc a			; $43de
	jp nz,objectApplySpeed		; $43df
_label_10_031:
	call getRandomNumber_noPreserveVars		; $43e2
	and $3e			; $43e5
	add $08			; $43e7
	ld e,$c7		; $43e9
	ld (de),a		; $43eb
	call getRandomNumber_noPreserveVars		; $43ec
	and $03			; $43ef
	ld hl,$4413		; $43f1
	rst_addAToHl			; $43f4
	ld e,$d0		; $43f5
	ld a,(hl)		; $43f7
	ld (de),a		; $43f8
	call getRandomNumber_noPreserveVars		; $43f9
	and $1e			; $43fc
	ld h,d			; $43fe
	ld l,$c9		; $43ff
	ld (hl),a		; $4401
	and $0f			; $4402
	ret z			; $4404
	bit 4,(hl)		; $4405
	ld l,$db		; $4407
	ld a,(hl)		; $4409
	res 5,a			; $440a
	jr nz,_label_10_032	; $440c
	set 5,a			; $440e
_label_10_032:
	ldi (hl),a		; $4410
	ld (hl),a		; $4411
	ret			; $4412
	ld a,(bc)		; $4413
	inc d			; $4414
	ld e,$28		; $4415
	ld l,$f1		; $4417
	ld h,d			; $4419
	xor a			; $441a
	ld b,(hl)		; $441b
	ldi (hl),a		; $441c
	ld c,(hl)		; $441d
	ldi (hl),a		; $441e
	or b			; $441f
	ret z			; $4420
	push bc			; $4421
	call objectCheckContainsPoint		; $4422
	pop bc			; $4425
	ret c			; $4426
	call objectGetRelativeAngle		; $4427
	ld c,a			; $442a
	ld b,$0a		; $442b
	ld e,$c9		; $442d
	call objectApplyGivenSpeed		; $442f
	xor a			; $4432
	ret			; $4433
	ld e,$c2		; $4434
	ld a,(de)		; $4436
	sub $0c			; $4437
	cp $03			; $4439
	ret nc			; $443b
	ld a,($cc79)		; $443c
	or a			; $443f
	ret z			; $4440
	call objectGetAngleTowardLink		; $4441
	ld c,a			; $4444
	ld h,d			; $4445
	ld l,$cb		; $4446
	ld a,($d00b)		; $4448
	sub (hl)		; $444b
	jr nc,_label_10_033	; $444c
	cpl			; $444e
	inc a			; $444f
_label_10_033:
	ld b,a			; $4450
	ld l,$cd		; $4451
	ld a,($d00d)		; $4453
	sub (hl)		; $4456
	jr nc,_label_10_034	; $4457
	cpl			; $4459
	inc a			; $445a
_label_10_034:
	cp b			; $445b
	jr nc,_label_10_035	; $445c
	ld a,b			; $445e
_label_10_035:
	and $f0			; $445f
	swap a			; $4461
	bit 3,a			; $4463
	jr z,_label_10_036	; $4465
	ld a,$07		; $4467
_label_10_036:
	ld hl,$447c		; $4469
	rst_addAToHl			; $446c
	ld b,(hl)		; $446d
	push bc			; $446e
	ld a,c			; $446f
	call $402a		; $4470
	pop bc			; $4473
	ret c			; $4474
	ld e,$c9		; $4475
	call objectApplyGivenSpeed		; $4477
	scf			; $447a
	ret			; $447b
	ld h,h			; $447c
	ld h,h			; $447d
	ld d,b			; $447e
	inc a			; $447f
	jr z,_label_10_038	; $4480
	inc d			; $4482
	ld a,(bc)		; $4483
	sbc b			; $4484
	ld b,h			; $4485
	sbc b			; $4486
	ld b,h			; $4487
	sbc b			; $4488
	ld b,h			; $4489
	sbc b			; $448a
	ld b,h			; $448b
	sub b			; $448c
	ld b,h			; $448d
	sbc b			; $448e
	ld b,h			; $448f
	ld d,h			; $4490
	nop			; $4491
	ld d,l			; $4492
	ld ($1056),sp		; $4493
	ld d,a			; $4496
	jr _label_10_037		; $4497

partCode02:
_label_10_037:
	ld e,$c4		; $4499
	ld a,(de)		; $449b
	or a			; $449c
	call z,$44c8		; $449d
_label_10_038:
	call partAnimate		; $44a0
	ld a,(wFrameCounter)		; $44a3
	rrca			; $44a6
	jr c,_label_10_039	; $44a7
	ld e,$dc		; $44a9
	ld a,(de)		; $44ab
	xor $01			; $44ac
	ld (de),a		; $44ae
_label_10_039:
	ld e,$e1		; $44af
	ld a,(de)		; $44b1
	or a			; $44b2
	ret z			; $44b3
	call $44d6		; $44b4
	ld a,(de)		; $44b7
	rlca			; $44b8
	jp c,partDelete		; $44b9
	xor a			; $44bc
	call decideItemDrop		; $44bd
	jp z,partDelete		; $44c0
	ld b,$01		; $44c3
	jp objectReplaceWithID		; $44c5
	inc a			; $44c8
	ld (de),a		; $44c9
	ld e,$ed		; $44ca
	ld a,(de)		; $44cc
	rlca			; $44cd
	ld a,$01		; $44ce
	call c,partSetAnimation		; $44d0
	jp objectSetVisible82		; $44d3
	ld e,$c7		; $44d6
	ld a,(de)		; $44d8
	rrca			; $44d9
	ret nc			; $44da
	jp decNumEnemies		; $44db

partCode03:
	cp $01			; $44de
	jr nz,_label_10_040	; $44e0
	ld a,($cc31)		; $44e2
	ld h,d			; $44e5
	ld l,$c3		; $44e6
	xor (hl)		; $44e8
	ld ($cc31),a		; $44e9
	ld l,$db		; $44ec
	ld a,(hl)		; $44ee
	and $01			; $44ef
	inc a			; $44f1
	ldi (hl),a		; $44f2
	ld (hl),a		; $44f3
	ld a,$7e		; $44f4
	jp playSound		; $44f6
_label_10_040:
	ld e,$c4		; $44f9
	ld a,(de)		; $44fb
	or a			; $44fc
	ret nz			; $44fd
	inc a			; $44fe
	ld (de),a		; $44ff
	call objectMakeTileSolid		; $4500
	ld h,$cf		; $4503
	ld (hl),$0a		; $4505
	ld h,d			; $4507
	ld l,$c2		; $4508
	ldi a,(hl)		; $450a
	and $07			; $450b
	ld bc,bitTable		; $450d
	add c			; $4510
	ld c,a			; $4511
	ld a,(bc)		; $4512
	ld (hl),a		; $4513
	ld a,($cc31)		; $4514
	and (hl)		; $4517
	ld a,$01		; $4518
	jr z,_label_10_041	; $451a
	inc a			; $451c
_label_10_041:
	ld l,$db		; $451d
	ldi (hl),a		; $451f
	ld (hl),a		; $4520
	jp objectSetVisible82		; $4521


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


partCode05:
	jr z,_label_10_044	; $4558
	ld a,($cc32)		; $455a
	ld h,d			; $455d
	ld l,$c2		; $455e
	xor (hl)		; $4560
	ld ($cc32),a		; $4561
	call $457f		; $4564
	ld a,$7e		; $4567
	jp playSound		; $4569
_label_10_044:
	ld e,$c4		; $456c
	ld a,(de)		; $456e
	or a			; $456f
	ret nz			; $4570
	ld h,d			; $4571
	ld l,e			; $4572
	inc (hl)		; $4573
	ld l,$cf		; $4574
	ld (hl),$fa		; $4576
	call objectGetShortPosition		; $4578
	ld e,$f0		; $457b
	ld (de),a		; $457d
	ret			; $457e
	ld l,$f0		; $457f
	ld c,(hl)		; $4581
	ld a,($cc49)		; $4582
	or a			; $4585
	jr z,_label_10_046	; $4586
	ld hl,$cc32		; $4588
	ld e,$c2		; $458b
	ld a,(de)		; $458d
	and (hl)		; $458e
	ld a,$0a		; $458f
	jr z,_label_10_045	; $4591
	inc a			; $4593
_label_10_045:
	jp setTile		; $4594
_label_10_046:
	ld a,$b0		; $4597
	call setTile		; $4599
	ld b,$cf		; $459c
	xor a			; $459e
	ld (bc),a		; $459f
	call getThisRoomFlags		; $45a0
	set 6,(hl)		; $45a3
	jp partDelete		; $45a5

partCode06:
	jr z,_label_10_047	; $45a8
	ld h,d			; $45aa
	ld l,$c2		; $45ab
	ld a,(hl)		; $45ad
	cp $02			; $45ae
	jr z,_label_10_047	; $45b0
	ld l,$c7		; $45b2
	ldd a,(hl)		; $45b4
	ld (hl),a		; $45b5
	ld l,$c4		; $45b6
	ld (hl),$02		; $45b8
_label_10_047:
	ld e,$c2		; $45ba
	ld a,(de)		; $45bc
	rst_jumpTable			; $45bd
	call nz,$ef45		; $45be
	ld b,l			; $45c1
	dec (hl)		; $45c2
	ld b,(hl)		; $45c3
	ld e,$c4		; $45c4
	ld a,(de)		; $45c6
	rst_jumpTable			; $45c7
	adc $45			; $45c8
	pop de			; $45ca
	ld b,l			; $45cb
	jp nc,$3e45		; $45cc
	ld bc,$c912		; $45cf
	ld hl,$cca9		; $45d2
	inc (hl)		; $45d5
	ld a,$72		; $45d6
	call playSound		; $45d8
	call objectGetShortPosition		; $45db
	ld c,a			; $45de
	ld a,($cc49)		; $45df
	or a			; $45e2
	ld a,$a1		; $45e3
	jr z,_label_10_048	; $45e5
	ld a,$09		; $45e7
_label_10_048:
	call setTile		; $45e9
	jp partDelete		; $45ec
	ld e,$c4		; $45ef
	ld a,(de)		; $45f1
	rst_jumpTable			; $45f2
	adc $45			; $45f3
	pop de			; $45f5
	ld b,l			; $45f6
	ei			; $45f7
	ld b,l			; $45f8
	rla			; $45f9
	ld b,(hl)		; $45fa
	ld h,d			; $45fb
	ld l,e			; $45fc
	inc (hl)		; $45fd
	ld l,$e4		; $45fe
	res 7,(hl)		; $4600
	ld l,$c7		; $4602
	ldd a,(hl)		; $4604
	ld (hl),a		; $4605
	ld hl,$cca9		; $4606
	inc (hl)		; $4609
	ld a,$72		; $460a
	call playSound		; $460c
	call objectGetShortPosition		; $460f
	ld c,a			; $4612
	ld a,$09		; $4613
	jr _label_10_049		; $4615
	ld a,(wFrameCounter)		; $4617
	and $03			; $461a
	ret nz			; $461c
	call partCommon_decCounter1IfNonzero		; $461d
	ret nz			; $4620
	ld l,$e4		; $4621
	set 7,(hl)		; $4623
	ld l,$c4		; $4625
	ld (hl),$01		; $4627
	ld hl,$cca9		; $4629
	dec (hl)		; $462c
	call objectGetShortPosition		; $462d
	ld c,a			; $4630
	ld a,$08		; $4631
	jr _label_10_049		; $4633
	ld e,$c4		; $4635
	ld a,(de)		; $4637
	rst_jumpTable			; $4638
	adc $45			; $4639
	ld b,e			; $463b
	ld b,(hl)		; $463c
	ld d,d			; $463d
	ld b,(hl)		; $463e
	ld h,a			; $463f
	ld b,(hl)		; $4640
	ld (hl),e		; $4641
	ld b,(hl)		; $4642
	call $4682		; $4643
	cp $09			; $4646
	ret z			; $4648
	ld h,d			; $4649
	ld l,$c4		; $464a
	inc (hl)		; $464c
	ld l,$c6		; $464d
	ld (hl),$f0		; $464f
	ret			; $4651
	call partCommon_decCounter1IfNonzero		; $4652
	jp nz,$468e		; $4655
	ld l,e			; $4658
	inc (hl)		; $4659
	ld hl,$cca9		; $465a
	dec (hl)		; $465d
	call objectGetShortPosition		; $465e
	ld c,a			; $4661
	ld a,$08		; $4662
_label_10_049:
	jp setTile		; $4664
	call $4682		; $4667
	cp $08			; $466a
	ret z			; $466c
	ld e,$c4		; $466d
	ld a,$04		; $466f
	ld (de),a		; $4671
	ret			; $4672
	ld a,$01		; $4673
	ld (de),a		; $4675
	ld hl,$cca9		; $4676
	inc (hl)		; $4679
	call objectGetShortPosition		; $467a
	ld c,a			; $467d
	ld a,$09		; $467e
	jr _label_10_049		; $4680
	ld a,$0b		; $4682
	call objectGetRelatedObject2Var		; $4684
	ld b,(hl)		; $4687
	ld l,$cd		; $4688
	ld c,(hl)		; $468a
	jp getTileAtPosition		; $468b
	call $4682		; $468e
	cp $09			; $4691
	ret nz			; $4693
	ld e,$c4		; $4694
	ld a,$01		; $4696
	ld (de),a		; $4698
	ret			; $4699

partCode07:
	ld e,$c4		; $469a
	ld a,(de)		; $469c
	or a			; $469d
	call z,$46f2		; $469e
	ld a,$01		; $46a1
	call objectGetRelatedObject1Var		; $46a3
	ld e,$f0		; $46a6
	ld a,(de)		; $46a8
	cp (hl)			; $46a9
	jp nz,partDelete		; $46aa
	ld a,$0b		; $46ad
	call objectGetRelatedObject1Var		; $46af
	ld e,$c3		; $46b2
	ld a,(de)		; $46b4
	ld b,a			; $46b5
	ld c,$00		; $46b6
	call objectTakePositionWithOffset		; $46b8
	xor a			; $46bb
	ld (de),a		; $46bc
	ld a,(hl)		; $46bd
	or a			; $46be
	jp z,objectSetInvisible		; $46bf
	ld e,$da		; $46c2
	ld a,(de)		; $46c4
	xor $80			; $46c5
	ld (de),a		; $46c7
	ld e,$c2		; $46c8
	ld a,(de)		; $46ca
	add a			; $46cb
	ld bc,$46e6		; $46cc
	call addDoubleIndexToBc		; $46cf
	ld a,(hl)		; $46d2
	cp $e0			; $46d3
	jr nc,_label_10_050	; $46d5
	inc bc			; $46d7
	cp $c0			; $46d8
	jr nc,_label_10_050	; $46da
	inc bc			; $46dc
	cp $a0			; $46dd
	jr nc,_label_10_050	; $46df
	inc bc			; $46e1
_label_10_050:
	ld a,(bc)		; $46e2
	jp partSetAnimation		; $46e3
	ld bc,$0001		; $46e6
	nop			; $46e9
	ld (bc),a		; $46ea
	ld bc,$0001		; $46eb
	inc bc			; $46ee
	ld (bc),a		; $46ef
	ld bc,$3c00		; $46f0
	ld (de),a		; $46f3
	ld a,$01		; $46f4
	call objectGetRelatedObject1Var		; $46f6
	ld e,$f0		; $46f9
	ld a,(hl)		; $46fb
	ld (de),a		; $46fc
	jp objectSetVisible83		; $46fd

partCode08:
	ld a,($c4ab)		; $4700
	or a			; $4703
	ret nz			; $4704
	ld a,($cd00)		; $4705
	and $01			; $4708
	ret z			; $470a
	ld e,$c4		; $470b
	ld a,(de)		; $470d
	or a			; $470e
	call z,$475c		; $470f
	ld h,d			; $4712
	ld l,$c7		; $4713
	ld b,(hl)		; $4715
	ld a,($cca9)		; $4716
	cp (hl)			; $4719
	ret z			; $471a
	ldd (hl),a		; $471b
	or a			; $471c
	jp z,darkenRoom		; $471d
	cp (hl)			; $4720
	jp z,brightenRoom		; $4721
	ld a,($c4ae)		; $4724
	cp $f7			; $4727
	ret z			; $4729
	ld a,($cca9)		; $472a
	cp b			; $472d
	jp nc,brightenRoomLightly		; $472e
	jp darkenRoomLightly		; $4731
	push hl			; $4734
	push bc			; $4735
	ld c,l			; $4736
	call getFreePartSlot		; $4737
	jr nz,_label_10_051	; $473a
	ld (hl),$06		; $473c
	inc l			; $473e
	ld e,l			; $473f
	ld a,(de)		; $4740
	ld (hl),a		; $4741
	ld e,$cb		; $4742
	ld a,(de)		; $4744
	and $f0			; $4745
	ld l,a			; $4747
	ld e,$cd		; $4748
	ld a,(de)		; $474a
	and $f0			; $474b
	swap a			; $474d
	or l			; $474f
	ld l,$c7		; $4750
	ld (hl),a		; $4752
	ld l,$cb		; $4753
	call setShortPosition_paramC		; $4755
_label_10_051:
	pop bc			; $4758
	pop hl			; $4759
	inc c			; $475a
	ret			; $475b
	inc a			; $475c
	ld (de),a		; $475d
	ld e,$c6		; $475e
	ld a,(de)		; $4760
	ld c,a			; $4761
	ld hl,$cf00		; $4762
	ld b,$b0		; $4765
_label_10_052:
	ld a,(hl)		; $4767
	cp $08			; $4768
	call z,$4734		; $476a
	inc l			; $476d
	dec b			; $476e
	jr nz,_label_10_052	; $476f
	ld e,$c6		; $4771
	ld a,c			; $4773
	ld (de),a		; $4774
	call objectGetShortPosition		; $4775
	ld e,$cb		; $4778
	ld (de),a		; $477a
	ret			; $477b

partCode09:
	ld e,$c4		; $477c
	ld a,(de)		; $477e
	or a			; $477f
	call z,$4829		; $4780
	ld a,($ccc8)		; $4783
	or a			; $4786
	ret nz			; $4787
	ld hl,$d000		; $4788
	call checkObjectsCollided		; $478b
	jr c,_label_10_055	; $478e
	ld hl,$dd00		; $4790
	call checkObjectsCollided		; $4793
	jr c,_label_10_056	; $4796
	call objectGetTileAtPosition		; $4798
	sub $0c			; $479b
	cp $02			; $479d
	jr nc,_label_10_053	; $479f
	call partCommon_decCounter1IfNonzero		; $47a1
	ret nz			; $47a4
	ld l,$f0		; $47a5
	bit 0,(hl)		; $47a7
	ret z			; $47a9
	ld e,$f0		; $47aa
	ld a,(de)		; $47ac
	or a			; $47ad
	ret z			; $47ae
	call objectGetShortPosition		; $47af
	ld c,a			; $47b2
	ld a,$0c		; $47b3
	call setTile		; $47b5
	ld e,$c3		; $47b8
	ld a,(de)		; $47ba
	ld hl,$ccba		; $47bb
	call unsetFlag		; $47be
	ld e,$f0		; $47c1
	xor a			; $47c3
	ld (de),a		; $47c4
	ld a,$87		; $47c5
	jp playSound		; $47c7
_label_10_053:
	ld h,d			; $47ca
	ld l,$c2		; $47cb
	bit 7,(hl)		; $47cd
	jr z,_label_10_054	; $47cf
	ld l,$f0		; $47d1
	bit 0,(hl)		; $47d3
	ret nz			; $47d5
	ld l,$c6		; $47d6
	ld (hl),$1c		; $47d8
	call objectGetShortPosition		; $47da
	ld c,a			; $47dd
	ld b,$0d		; $47de
	call setTileInRoomLayoutBuffer		; $47e0
	jr _label_10_058		; $47e3
_label_10_054:
	call $4817		; $47e5
	jp partDelete		; $47e8
_label_10_055:
	ld a,($d00f)		; $47eb
	or a			; $47ee
	ret nz			; $47ef
_label_10_056:
	ld e,$c2		; $47f0
	ld a,(de)		; $47f2
	rlca			; $47f3
	jr nc,_label_10_054	; $47f4
_label_10_057:
	ld e,$f0		; $47f6
	ld a,(de)		; $47f8
	or a			; $47f9
	ret nz			; $47fa
	call objectGetShortPosition		; $47fb
	ld c,a			; $47fe
	ld a,$0d		; $47ff
	call setTile		; $4801
_label_10_058:
	ld e,$c3		; $4804
	ld a,(de)		; $4806
	ld hl,$ccba		; $4807
	call setFlag		; $480a
	ld e,$f0		; $480d
	ld a,$01		; $480f
	ld (de),a		; $4811
	ld a,$87		; $4812
	jp playSound		; $4814
	call objectGetShortPosition		; $4817
	ld c,a			; $481a
	ld b,$0d		; $481b
	call setTileInRoomLayoutBuffer		; $481d
	call objectGetTileAtPosition		; $4820
	cp $0c			; $4823
	jr z,_label_10_057	; $4825
	jr _label_10_058		; $4827
	ld h,d			; $4829
	ld l,e			; $482a
	inc (hl)		; $482b
	ld l,$c2		; $482c
	ldi a,(hl)		; $482e
	and $07			; $482f
	ldd (hl),a		; $4831
	ret			; $4832

partCode0b:
	cp $01			; $4833
	jr nz,_label_10_060	; $4835
	ld h,d			; $4837
	ld l,$db		; $4838
	ldi a,(hl)		; $483a
	ld (hl),a		; $483b
	ld l,$c3		; $483c
	ld a,($cc31)		; $483e
	xor (hl)		; $4841
	ld ($cc31),a		; $4842
	ld l,$db		; $4845
	ld a,(hl)		; $4847
	dec a			; $4848
	jr nz,_label_10_059	; $4849
	ld a,$02		; $484b
_label_10_059:
	ldi (hl),a		; $484d
	ld (hl),a		; $484e
	ld a,$7e		; $484f
	call playSound		; $4851
_label_10_060:
	ld e,$c4		; $4854
	ld a,(de)		; $4856
	sub $08			; $4857
	jr c,_label_10_061	; $4859
	rst_jumpTable			; $485b
	add b			; $485c
	ld c,b			; $485d
	adc h			; $485e
	ld c,b			; $485f
	sbc b			; $4860
	ld c,b			; $4861
	and h			; $4862
	ld c,b			; $4863
	or e			; $4864
	ld c,b			; $4865
_label_10_061:
	ld hl,$6b30		; $4866
	call objectLoadMovementScript		; $4869
	ld h,d			; $486c
	ld l,$c3		; $486d
	ld b,$01		; $486f
	ld a,($cc31)		; $4871
	and (hl)		; $4874
	jr z,_label_10_062	; $4875
	inc b			; $4877
_label_10_062:
	ld a,b			; $4878
	ld l,$db		; $4879
	ldi (hl),a		; $487b
	ld (hl),a		; $487c
	jp objectSetVisible82		; $487d
	ld h,d			; $4880
	ld e,$f2		; $4881
	ld a,(de)		; $4883
	ld l,$cb		; $4884
	cp (hl)			; $4886
	jp c,objectApplySpeed		; $4887
	jr _label_10_063		; $488a
	ld h,d			; $488c
	ld e,$cd		; $488d
	ld a,(de)		; $488f
	ld l,$f3		; $4890
	cp (hl)			; $4892
	jp c,objectApplySpeed		; $4893
	jr _label_10_063		; $4896
	ld h,d			; $4898
	ld e,$cb		; $4899
	ld a,(de)		; $489b
	ld l,$f2		; $489c
	cp (hl)			; $489e
	jp c,objectApplySpeed		; $489f
	jr _label_10_063		; $48a2
	ld h,d			; $48a4
	ld e,$f3		; $48a5
	ld a,(de)		; $48a7
	ld l,$cd		; $48a8
	cp (hl)			; $48aa
	jp c,objectApplySpeed		; $48ab
_label_10_063:
	ld a,(de)		; $48ae
	ld (hl),a		; $48af
	jp objectRunMovementScript		; $48b0
	ld h,d			; $48b3
	ld l,$c6		; $48b4
	dec (hl)		; $48b6
	ret nz			; $48b7
	jp objectRunMovementScript		; $48b8

partCode0c:
	ld e,$c4		; $48bb
	ld a,(de)		; $48bd
	or a			; $48be
	call z,$4910		; $48bf
	call partCommon_decCounter1IfNonzero		; $48c2
	ret nz			; $48c5
	ld l,$c9		; $48c6
	ld a,(hl)		; $48c8
	ld hl,$4904		; $48c9
	rst_addDoubleIndex			; $48cc
	ld e,$c7		; $48cd
	ld a,(de)		; $48cf
	rrca			; $48d0
	ldi a,(hl)		; $48d1
	jr nc,_label_10_064	; $48d2
	ld a,(hl)		; $48d4
_label_10_064:
	ld b,a			; $48d5
	ld e,$cb		; $48d6
	ld a,(de)		; $48d8
	ld c,a			; $48d9
	push bc			; $48da
	call setTileInRoomLayoutBuffer		; $48db
	pop bc			; $48de
	ld a,b			; $48df
	call setTile		; $48e0
	ld a,$70		; $48e3
	call playSound		; $48e5
	ld h,d			; $48e8
	ld l,$c6		; $48e9
	ld (hl),$08		; $48eb
	inc l			; $48ed
	dec (hl)		; $48ee
	jp z,partDelete		; $48ef
	ld a,(hl)		; $48f2
	rrca			; $48f3
	ret c			; $48f4
	ld l,$c9		; $48f5
	ld a,(hl)		; $48f7
	ld bc,$490c		; $48f8
	call addAToBc		; $48fb
	ld a,(bc)		; $48fe
	ld l,$cb		; $48ff
	add (hl)		; $4901
	ld (hl),a		; $4902
	ret			; $4903
	ld l,e			; $4904
	ld l,d			; $4905
	ld l,(hl)		; $4906
	ld l,l			; $4907
	ld l,h			; $4908
	ld l,d			; $4909
	ld l,a			; $490a
	ld l,l			; $490b
	ld a,($ff00+$01)	; $490c
	stop			; $490e
	rst $38			; $490f
	ld h,d			; $4910
	ld l,e			; $4911
	inc (hl)		; $4912
	ld l,$c6		; $4913
	ld (hl),$08		; $4915
	ret			; $4917

partCode0e:
	jp nz,partDelete		; $4918
	ld e,$c2		; $491b
	ld a,(de)		; $491d
	ld e,$c4		; $491e
	rst_jumpTable			; $4920
	add hl,hl		; $4921
	ld c,c			; $4922
	adc l			; $4923
	ld c,c			; $4924
	add $49			; $4925
	add $49			; $4927
	ld a,(de)		; $4929
	or a			; $492a
	jr z,_label_10_066	; $492b
	ld a,$00		; $492d
	call objectGetRelatedObject1Var		; $492f
	ld a,(hl)		; $4932
	or a			; $4933
	jp z,partDelete		; $4934
	ld e,$c9		; $4937
	ld a,l			; $4939
	or $09			; $493a
	ld l,a			; $493c
	ld a,(hl)		; $493d
	ld (de),a		; $493e
	call objectTakePosition		; $493f
	call partCommon_decCounter1IfNonzero		; $4942
	jr nz,_label_10_065	; $4945
	ld (hl),$0f		; $4947
	ld e,$c9		; $4949
	ld a,(de)		; $494b
	ld b,a			; $494c
	ld e,$01		; $494d
	call $496b		; $494f
_label_10_065:
	ld h,d			; $4952
	ld l,$c7		; $4953
	dec (hl)		; $4955
	ret nz			; $4956
	ld (hl),$06		; $4957
	ld l,$c3		; $4959
	ld a,(hl)		; $495b
	inc a			; $495c
	and $03			; $495d
	ld (hl),a		; $495f
	ld c,a			; $4960
	ld l,$c9		; $4961
	ld b,(hl)		; $4963
	ld e,$02		; $4964
	call $496b		; $4966
	ld e,$03		; $4969
	call getFreePartSlot		; $496b
	ret nz			; $496e
	ld (hl),$0e		; $496f
	inc l			; $4971
	ld (hl),e		; $4972
	inc l			; $4973
	ld (hl),c		; $4974
	call objectCopyPosition		; $4975
	ld l,$c9		; $4978
	ld (hl),b		; $497a
	ld l,$d6		; $497b
	ld e,l			; $497d
	ld a,(de)		; $497e
	ldi (hl),a		; $497f
	inc e			; $4980
	ld a,(de)		; $4981
	ld (hl),a		; $4982
	ret			; $4983
_label_10_066:
	ld h,d			; $4984
	ld l,e			; $4985
	inc (hl)		; $4986
	ld l,$c6		; $4987
	inc (hl)		; $4989
	inc l			; $498a
	inc (hl)		; $498b
	ret			; $498c
	ld a,(de)		; $498d
	or a			; $498e
	jr z,_label_10_070	; $498f
_label_10_067:
	call objectCheckCollidedWithLink_ignoreZ		; $4991
	jr c,_label_10_068	; $4994
	call objectApplyComponentSpeed		; $4996
	call objectCheckSimpleCollision		; $4999
	ret z			; $499c
	jr _label_10_069		; $499d
_label_10_068:
	ld a,$3b		; $499f
	call objectGetRelatedObject1Var		; $49a1
	ld (hl),$ff		; $49a4
_label_10_069:
	jp partDelete		; $49a6
_label_10_070:
	inc a			; $49a9
	ld (de),a		; $49aa
	ld e,$c9		; $49ab
	ld a,(de)		; $49ad
	add $04			; $49ae
	and $08			; $49b0
	rrca			; $49b2
	rrca			; $49b3
	ld hl,$49c2		; $49b4
	rst_addAToHl			; $49b7
	ld e,$e6		; $49b8
	ldi a,(hl)		; $49ba
	ld (de),a		; $49bb
	inc e			; $49bc
	ld a,(hl)		; $49bd
	ld (de),a		; $49be
	jp $49ea		; $49bf
	ld (bc),a		; $49c2
	ld bc,$0201		; $49c3
	ld a,(de)		; $49c6
	or a			; $49c7
	jr z,_label_10_071	; $49c8
	call partCommon_decCounter1IfNonzero		; $49ca
	jr nz,_label_10_067	; $49cd
	jr _label_10_069		; $49cf
_label_10_071:
	ld h,d			; $49d1
	ld l,e			; $49d2
	inc (hl)		; $49d3
	ld l,$c6		; $49d4
	ld (hl),$04		; $49d6
	ld l,$c3		; $49d8
	ld a,(hl)		; $49da
	inc a			; $49db
	add a			; $49dc
	dec l			; $49dd
	bit 0,(hl)		; $49de
	jr nz,_label_10_072	; $49e0
	cpl			; $49e2
	inc a			; $49e3
_label_10_072:
	ld l,$c9		; $49e4
	add (hl)		; $49e6
	and $1f			; $49e7
	ld (hl),a		; $49e9
	ld h,d			; $49ea
	ld l,$c9		; $49eb
	ld c,(hl)		; $49ed
	ld b,$64		; $49ee
	ld a,$04		; $49f0
	jp objectSetComponentSpeedByScaledVelocity		; $49f2

partCode0f:
	jr z,_label_10_074	; $49f5
	ld h,d			; $49f7
	ld l,$c4		; $49f8
	inc (hl)		; $49fa
	ld l,$c6		; $49fb
	ld (hl),$f0		; $49fd
	ld l,$e4		; $49ff
	res 7,(hl)		; $4a01
	ld a,$02		; $4a03
	call $4a4f		; $4a05
	call getRandomNumber_noPreserveVars		; $4a08
	rrca			; $4a0b
	jr nc,_label_10_073	; $4a0c
	call getFreePartSlot		; $4a0e
	jr nz,_label_10_073	; $4a11
	ld (hl),$01		; $4a13
	inc l			; $4a15
	ld e,l			; $4a16
	ld a,(de)		; $4a17
	ld (hl),a		; $4a18
	call objectCopyPosition		; $4a19
_label_10_073:
	ld b,$00		; $4a1c
	call objectCreateInteractionWithSubid00		; $4a1e
_label_10_074:
	ld e,$c4		; $4a21
	ld a,(de)		; $4a23
	rst_jumpTable			; $4a24
	cpl			; $4a25
	ld c,d			; $4a26
	inc sp			; $4a27
	ld c,d			; $4a28
	inc (hl)		; $4a29
	ld c,d			; $4a2a
	ld b,l			; $4a2b
	ld c,d			; $4a2c
	ld e,b			; $4a2d
	ld c,d			; $4a2e
	ld a,$01		; $4a2f
	ld (de),a		; $4a31
	ret			; $4a32
	ret			; $4a33
	ld a,(wFrameCounter)		; $4a34
	rrca			; $4a37
	ret nc			; $4a38
	call partCommon_decCounter1IfNonzero		; $4a39
	ret nz			; $4a3c
	ld (hl),$0c		; $4a3d
	ld l,e			; $4a3f
	inc (hl)		; $4a40
	ld a,$03		; $4a41
	jr _label_10_075		; $4a43
	call partCommon_decCounter1IfNonzero		; $4a45
	ret nz			; $4a48
	ld (hl),$08		; $4a49
	ld l,e			; $4a4b
	inc (hl)		; $4a4c
	ld a,$04		; $4a4d
_label_10_075:
	push af			; $4a4f
	call objectGetShortPosition		; $4a50
	ld c,a			; $4a53
	pop af			; $4a54
	jp setTile		; $4a55
	call partCommon_decCounter1IfNonzero		; $4a58
	ret nz			; $4a5b
	ld l,e			; $4a5c
	ld (hl),$01		; $4a5d
	ld l,$e4		; $4a5f
	set 7,(hl)		; $4a61
	ret			; $4a63

partCode10:
	jr z,_label_10_076	; $4a64
	cp $02			; $4a66
	jp z,$4b0e		; $4a68
	ld e,$c4		; $4a6b
	ld a,$02		; $4a6d
	ld (de),a		; $4a6f
_label_10_076:
	ld e,$c4		; $4a70
	ld a,(de)		; $4a72
	rst_jumpTable			; $4a73
	ld a,(hl)		; $4a74
	ld c,d			; $4a75
	and l			; $4a76
	ld c,d			; $4a77
	and (hl)		; $4a78
	ld c,d			; $4a79
	and a			; $4a7a
	ld c,d			; $4a7b
	cp (hl)			; $4a7c
	ld c,d			; $4a7d
	ld a,$01		; $4a7e
	ld (de),a		; $4a80
	ld e,$c2		; $4a81
	ld a,(de)		; $4a83
	ld hl,$4a9b		; $4a84
	rst_addDoubleIndex			; $4a87
	ld e,$dd		; $4a88
	ld a,(de)		; $4a8a
	add (hl)		; $4a8b
	ld (de),a		; $4a8c
	inc hl			; $4a8d
	dec e			; $4a8e
	ld a,(hl)		; $4a8f
	ld (de),a		; $4a90
	dec e			; $4a91
	ld (de),a		; $4a92
	ld a,$01		; $4a93
	call partSetAnimation		; $4a95
	jp objectSetVisiblec3		; $4a98
	ld (de),a		; $4a9b
	ld (bc),a		; $4a9c
	inc d			; $4a9d
	inc bc			; $4a9e
	ld d,$01		; $4a9f
	jr _label_10_077		; $4aa1
	ld a,(de)		; $4aa3
_label_10_077:
	nop			; $4aa4
	ret			; $4aa5
	ret			; $4aa6
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $4aa7
	jr c,_label_10_078	; $4aaa
	call objectApplySpeed		; $4aac
	ld c,$20		; $4aaf
	call objectUpdateSpeedZAndBounce		; $4ab1
	ret nc			; $4ab4
_label_10_078:
	ld h,d			; $4ab5
	ld l,$c4		; $4ab6
	ld (hl),$04		; $4ab8
	inc l			; $4aba
	ld (hl),$00		; $4abb
	ret			; $4abd
	ld e,$c5		; $4abe
	ld a,(de)		; $4ac0
	rst_jumpTable			; $4ac1
	add $4a			; $4ac2
	add hl,bc		; $4ac4
	ld c,e			; $4ac5
	ld e,$c2		; $4ac6
	ld a,(de)		; $4ac8
	ld l,a			; $4ac9
	add $20			; $4aca
	call checkTreasureObtained		; $4acc
	jr c,_label_10_080	; $4acf
	ld e,$c5		; $4ad1
	ld a,$01		; $4ad3
	ld (de),a		; $4ad5
	ld a,l			; $4ad6
	ld hl,$4ae5		; $4ad7
	rst_addAToHl			; $4ada
	ld c,(hl)		; $4adb
	ld b,$00		; $4adc
	call showText		; $4ade
	ld c,$06		; $4ae1
	jr _label_10_079		; $4ae3
	add hl,hl		; $4ae5
	add hl,hl		; $4ae6
	dec hl			; $4ae7
	inc l			; $4ae8
	ldi a,(hl)		; $4ae9
_label_10_079:
	ld e,$c2		; $4aea
	ld a,(de)		; $4aec
	add $20			; $4aed
	jp giveTreasure		; $4aef
_label_10_080:
	ld c,$06		; $4af2
	call $4aea		; $4af4
_label_10_081:
	ld a,$00		; $4af7
	call objectGetRelatedObject2Var		; $4af9
	ld a,(hl)		; $4afc
	or a			; $4afd
	jr z,_label_10_082	; $4afe
	ld a,l			; $4b00
	add $03			; $4b01
	ld l,a			; $4b03
	ld (hl),$01		; $4b04
_label_10_082:
	jp partDelete		; $4b06
	call retIfTextIsActive		; $4b09
	jr _label_10_081		; $4b0c
	ld h,d			; $4b0e
	ld l,$e4		; $4b0f
	res 7,(hl)		; $4b11
	ld a,($cfc0)		; $4b13
	or a			; $4b16
	ret nz			; $4b17
	ld a,$19		; $4b18
	call checkTreasureObtained		; $4b1a
	jr c,_label_10_083	; $4b1d
	ld a,d			; $4b1f
	ld ($cfc0),a		; $4b20
	ld bc,$0035		; $4b23
	jp showText		; $4b26
_label_10_083:
	ld bc,$fec0		; $4b29
	call objectSetSpeedZ		; $4b2c
	ld l,$e9		; $4b2f
	ld a,$03		; $4b31
	ld (hl),a		; $4b33
	ld l,$c4		; $4b34
	ldi (hl),a		; $4b36
	ld (hl),$00		; $4b37
	inc l			; $4b39
	ld (hl),$02		; $4b3a
	ld l,$d0		; $4b3c
	ld (hl),$28		; $4b3e
	call objectGetAngleTowardLink		; $4b40
	ld e,$c9		; $4b43
	ld (de),a		; $4b45
	ret			; $4b46

partCode11:
	ld e,$c2		; $4b47
	ld a,(de)		; $4b49
	ld e,$c4		; $4b4a
	rst_jumpTable			; $4b4c
	ld d,e			; $4b4d
	ld c,e			; $4b4e
	adc (hl)		; $4b4f
	ld c,e			; $4b50
	ld sp,$1a4c		; $4b51
	or a			; $4b54
	jr z,_label_10_085	; $4b55
	ld c,$16		; $4b57
	call objectUpdateSpeedZAndBounce		; $4b59
	jp c,partDelete		; $4b5c
	jp nz,objectApplySpeed		; $4b5f
	call getRandomNumber_noPreserveVars		; $4b62
	and $03			; $4b65
	dec a			; $4b67
	ret z			; $4b68
	ld b,a			; $4b69
	ld e,$c9		; $4b6a
	ld a,(de)		; $4b6c
	add b			; $4b6d
	and $1f			; $4b6e
_label_10_084:
	ld (de),a		; $4b70
	jp $4c69		; $4b71
_label_10_085:
	ld bc,$fd80		; $4b74
	call objectSetSpeedZ		; $4b77
	ld l,e			; $4b7a
	inc (hl)		; $4b7b
	ld l,$e4		; $4b7c
	set 7,(hl)		; $4b7e
	call objectSetVisible80		; $4b80
	call getRandomNumber_noPreserveVars		; $4b83
	and $0f			; $4b86
	add $08			; $4b88
	ld e,$c9		; $4b8a
	jr _label_10_084		; $4b8c
	ld a,(de)		; $4b8e
	rst_jumpTable			; $4b8f
	sbc h			; $4b90
	ld c,e			; $4b91
	add $4b			; $4b92
	ld ($ff00+c),a		; $4b94
	ld c,e			; $4b95
.DB $ed				; $4b96
	ld c,e			; $4b97
	ld ($244c),sp		; $4b98
	ld c,h			; $4b9b
	ld h,d			; $4b9c
	ld l,e			; $4b9d
	inc (hl)		; $4b9e
	ld l,$e4		; $4b9f
	set 7,(hl)		; $4ba1
	ld l,$e6		; $4ba3
	ld a,(hl)		; $4ba5
	add a			; $4ba6
	ldi (hl),a		; $4ba7
	ldi (hl),a		; $4ba8
	sla (hl)		; $4ba9
	ld l,$d0		; $4bab
	ld (hl),$05		; $4bad
	ld l,$d4		; $4baf
	ld a,$00		; $4bb1
	ldi (hl),a		; $4bb3
	ld (hl),$fc		; $4bb4
	call getRandomNumber_noPreserveVars		; $4bb6
	and $1f			; $4bb9
	ld e,$c9		; $4bbb
	ld (de),a		; $4bbd
	ld a,$01		; $4bbe
	call partSetAnimation		; $4bc0
	jp objectSetVisible80		; $4bc3
	ld h,d			; $4bc6
	ld l,$cb		; $4bc7
	ld e,$cf		; $4bc9
	ld a,(de)		; $4bcb
	add (hl)		; $4bcc
	add $08			; $4bcd
	cp $f8			; $4bcf
	ld c,$10		; $4bd1
	jp c,objectUpdateSpeedZ_paramC		; $4bd3
	ld l,$c4		; $4bd6
	inc (hl)		; $4bd8
	ld l,$c6		; $4bd9
	ld (hl),$1e		; $4bdb
	call objectSetInvisible		; $4bdd
	jr _label_10_086		; $4be0
	call partCommon_decCounter1IfNonzero		; $4be2
	ret nz			; $4be5
	ld (hl),$10		; $4be6
	ld l,e			; $4be8
	inc (hl)		; $4be9
	jp objectSetVisiblec0		; $4bea
	call partAnimate		; $4bed
	ld h,d			; $4bf0
	ld l,$cf		; $4bf1
	inc (hl)		; $4bf3
	inc (hl)		; $4bf4
	ret nz			; $4bf5
	call objectReplaceWithAnimationIfOnHazard		; $4bf6
	jp c,partDelete		; $4bf9
	ld h,d			; $4bfc
	ld l,$c4		; $4bfd
	inc (hl)		; $4bff
	ld l,$d4		; $4c00
	xor a			; $4c02
	ldi (hl),a		; $4c03
	ld (hl),a		; $4c04
	jp objectSetVisible82		; $4c05
	call partAnimate		; $4c08
	ld c,$16		; $4c0b
	call objectUpdateSpeedZ_paramC		; $4c0d
	jp nz,objectApplySpeed		; $4c10
	ld l,$c4		; $4c13
	inc (hl)		; $4c15
	ld l,$dd		; $4c16
	ld (hl),$26		; $4c18
	ld a,$03		; $4c1a
	call partSetAnimation		; $4c1c
	ld a,$81		; $4c1f
	jp playSound		; $4c21
	ld e,$e1		; $4c24
	ld a,(de)		; $4c26
	inc a			; $4c27
	jp z,partDelete		; $4c28
	call $4c7c		; $4c2b
	jp partAnimate		; $4c2e
	ld a,(de)		; $4c31
	rst_jumpTable			; $4c32
	dec a			; $4c33
	ld c,h			; $4c34
	ld ($ff00+c),a		; $4c35
	ld c,e			; $4c36
.DB $ed				; $4c37
	ld c,e			; $4c38
	ld ($244c),sp		; $4c39
	ld c,h			; $4c3c
	ld a,$01		; $4c3d
	ld (de),a		; $4c3f
_label_10_086:
	call getRandomNumber_noPreserveVars		; $4c40
	ld b,a			; $4c43
	ld hl,$ffa8		; $4c44
	ld e,$cb		; $4c47
	and $70			; $4c49
	add $08			; $4c4b
	add (hl)		; $4c4d
	ld (de),a		; $4c4e
	cpl			; $4c4f
	inc a			; $4c50
	and $fe			; $4c51
	ld e,$cf		; $4c53
	ld (de),a		; $4c55
	ld l,$aa		; $4c56
	ld e,$cd		; $4c58
	ld a,b			; $4c5a
	and $07			; $4c5b
	inc a			; $4c5d
	swap a			; $4c5e
	add $08			; $4c60
	add (hl)		; $4c62
	ld (de),a		; $4c63
	ld a,$02		; $4c64
	jp partSetAnimation		; $4c66
	ld b,$14		; $4c69
	cp $0d			; $4c6b
	jr c,_label_10_087	; $4c6d
	ld b,$0a		; $4c6f
	cp $14			; $4c71
	jr c,_label_10_087	; $4c73
	ld b,$14		; $4c75
_label_10_087:
	ld a,b			; $4c77
	ld e,$d0		; $4c78
	ld (de),a		; $4c7a
	ret			; $4c7b
	dec a			; $4c7c
	ld hl,$4c89		; $4c7d
	rst_addAToHl			; $4c80
	ld e,$e6		; $4c81
	ldi a,(hl)		; $4c83
	ld (de),a		; $4c84
	inc e			; $4c85
	ld a,(hl)		; $4c86
	ld (de),a		; $4c87
	ret			; $4c88
	inc b			; $4c89
	add hl,bc		; $4c8a
	ld b,$0b		; $4c8b
	add hl,bc		; $4c8d
	inc c			; $4c8e
	ld a,(bc)		; $4c8f
	dec c			; $4c90
	dec bc			; $4c91
	.db $0e		; $4c92

partCode12:
	.db $1e		; $4c93
	call nz,$b71a		; $4c94
	call z,$4cd6		; $4c97
	ld a,$01		; $4c9a
	call objectGetRelatedObject1Var		; $4c9c
	ld e,$f0		; $4c9f
	ld a,(de)		; $4ca1
	cp (hl)			; $4ca2
	jr nz,_label_10_089	; $4ca3
	ld c,$10		; $4ca5
	call objectUpdateSpeedZAndBounce		; $4ca7
	ld a,$0f		; $4caa
	call objectGetRelatedObject1Var		; $4cac
	ld e,$cf		; $4caf
	ld a,(de)		; $4cb1
	ld (hl),a		; $4cb2
	call objectTakePosition		; $4cb3
	ld c,h			; $4cb6
	call partCommon_decCounter1IfNonzero		; $4cb7
	jp nz,partAnimate		; $4cba
	ld h,c			; $4cbd
	ld l,$a9		; $4cbe
	ld e,$f1		; $4cc0
	ld a,(de)		; $4cc2
	ld (hl),a		; $4cc3
	or a			; $4cc4
	jr nz,_label_10_088	; $4cc5
	ld l,$a4		; $4cc7
	res 7,(hl)		; $4cc9
_label_10_088:
	ld l,$ab		; $4ccb
	ld (hl),$00		; $4ccd
	ld l,$ae		; $4ccf
	ld (hl),$01		; $4cd1
_label_10_089:
	jp partDelete		; $4cd3
	ld h,d			; $4cd6
	ld l,e			; $4cd7
	inc (hl)		; $4cd8
	ld l,$c6		; $4cd9
	ld (hl),$3b		; $4cdb
	ld a,$01		; $4cdd
	call objectGetRelatedObject1Var		; $4cdf
	ld e,$f0		; $4ce2
	ld a,(hl)		; $4ce4
	ld (de),a		; $4ce5
	ld e,$f1		; $4ce6
	ld l,$a9		; $4ce8
	ld a,(hl)		; $4cea
	ld (de),a		; $4ceb
	ld (hl),$01		; $4cec
	call objectTakePosition		; $4cee
	jp objectSetVisible80		; $4cf1

partCode13:
	jr z,_label_10_090	; $4cf4
	ld e,$ea		; $4cf6
	ld a,(de)		; $4cf8
	cp $9a			; $4cf9
	jr nz,_label_10_090	; $4cfb
	ld h,d			; $4cfd
	ld l,$c4		; $4cfe
	ld a,(hl)		; $4d00
	cp $02			; $4d01
	jr nc,_label_10_090	; $4d03
	inc (hl)		; $4d05
	ld l,$c6		; $4d06
	ld (hl),$32		; $4d08
_label_10_090:
	ld e,$c4		; $4d0a
	ld a,(de)		; $4d0c
	rst_jumpTable			; $4d0d
	ld d,$4d		; $4d0e
	daa			; $4d10
	ld c,l			; $4d11
	jr z,_label_10_092	; $4d12
	ld e,(hl)		; $4d14
	ld c,l			; $4d15
	ld h,d			; $4d16
	ld l,e			; $4d17
	inc (hl)		; $4d18
	ld l,$ff		; $4d19
	set 5,(hl)		; $4d1b
	call objectMakeTileSolid		; $4d1d
	ld h,$cf		; $4d20
	ld (hl),$00		; $4d22
	jp objectSetVisible83		; $4d24
	ret			; $4d27
	call partCommon_decCounter1IfNonzero		; $4d28
	jr nz,_label_10_091	; $4d2b
	ld (hl),$1e		; $4d2d
	ld l,e			; $4d2f
	inc (hl)		; $4d30
	ld a,$01		; $4d31
	jp partSetAnimation		; $4d33
_label_10_091:
	ld a,(hl)		; $4d36
	and $07			; $4d37
	ret nz			; $4d39
	ld a,(hl)		; $4d3a
	rrca			; $4d3b
	rrca			; $4d3c
	sub $02			; $4d3d
	ld hl,$4d52		; $4d3f
	rst_addAToHl			; $4d42
	ldi a,(hl)		; $4d43
	ld b,a			; $4d44
	ld c,(hl)		; $4d45
	call getFreeInteractionSlot		; $4d46
	ret nz			; $4d49
	ld (hl),$84		; $4d4a
	inc l			; $4d4c
	ld (hl),$05		; $4d4d
	jp objectCopyPositionWithOffset		; $4d4f
	ld sp,hl		; $4d52
	dec b			; $4d53
	ld b,$ff		; $4d54
.DB $fc				; $4d56
	ld a,($0702)		; $4d57
	nop			; $4d5a
	ld a,($02ff)		; $4d5b
	call partCommon_decCounter1IfNonzero		; $4d5e
_label_10_092:
	jr nz,_label_10_093	; $4d61
	ld l,e			; $4d63
	ld (hl),$01		; $4d64
	xor a			; $4d66
	jp partSetAnimation		; $4d67
_label_10_093:
	ld a,(hl)		; $4d6a
	cp $16			; $4d6b
	ret nz			; $4d6d
	ld l,$c2		; $4d6e
	ld c,(hl)		; $4d70
	ld b,$39		; $4d71
	jp showText		; $4d73

partCode14:
partCode15:
	ld e,$c2		; $4d76
	jr z,_label_10_094	; $4d78
	cp $02			; $4d7a
	jp z,$4e83		; $4d7c
	ld h,d			; $4d7f
	ld l,$c2		; $4d80
	set 7,(hl)		; $4d82
	ld l,$c4		; $4d84
	ld (hl),$03		; $4d86
	inc l			; $4d88
	ld (hl),$00		; $4d89
_label_10_094:
	ld e,$c4		; $4d8b
	ld a,(de)		; $4d8d
	rst_jumpTable			; $4d8e
	sbc c			; $4d8f
	ld c,l			; $4d90
	and $4d			; $4d91
	ld ($ff00+$21),a	; $4d93
	cp $4d			; $4d95
	cpl			; $4d97
	ld c,(hl)		; $4d98
	ld h,d			; $4d99
	ld l,e			; $4d9a
	inc (hl)		; $4d9b
	ld l,$e6		; $4d9c
	ld a,$06		; $4d9e
	ldi (hl),a		; $4da0
	ld (hl),a		; $4da1
	call getRandomNumber		; $4da2
	ld b,a			; $4da5
	and $70			; $4da6
	swap a			; $4da8
	ld hl,$4dce		; $4daa
	rst_addAToHl			; $4dad
	ld e,$d0		; $4dae
	ld a,(hl)		; $4db0
	ld (de),a		; $4db1
	ld a,b			; $4db2
	and $0e			; $4db3
	ld hl,$4dd6		; $4db5
	rst_addAToHl			; $4db8
	ld e,$d4		; $4db9
	ldi a,(hl)		; $4dbb
	ld (de),a		; $4dbc
	inc e			; $4dbd
	ldi a,(hl)		; $4dbe
	ld (de),a		; $4dbf
	call getRandomNumber		; $4dc0
	ld e,$c9		; $4dc3
	and $1f			; $4dc5
	ld (de),a		; $4dc7
	call $4f23		; $4dc8
	jp objectSetVisiblec3		; $4dcb
	inc d			; $4dce
	ld e,$28		; $4dcf
	ldd (hl),a		; $4dd1
	inc a			; $4dd2
	ld b,(hl)		; $4dd3
	ld d,b			; $4dd4
	ld e,d			; $4dd5
	add b			; $4dd6
	cp $40			; $4dd7
	cp $00			; $4dd9
	cp $c0			; $4ddb
.DB $fd				; $4ddd
	add b			; $4dde
.DB $fd				; $4ddf
	ld b,b			; $4de0
.DB $fd				; $4de1
	nop			; $4de2
.DB $fd				; $4de3
	ret nz			; $4de4
.DB $fc				; $4de5
	call objectApplySpeed		; $4de6
	call $4f66		; $4de9
	ld c,$20		; $4dec
	call objectUpdateSpeedZAndBounce		; $4dee
	jr nc,_label_10_095	; $4df1
	ld h,d			; $4df3
	ld l,$e4		; $4df4
	set 7,(hl)		; $4df6
	ld l,$c4		; $4df8
	inc (hl)		; $4dfa
_label_10_095:
	jp objectReplaceWithAnimationIfOnHazard		; $4dfb
	inc e			; $4dfe
	ld a,(de)		; $4dff
	or a			; $4e00
	jr nz,_label_10_096	; $4e01
	ld h,d			; $4e03
	ld l,e			; $4e04
	inc (hl)		; $4e05
	ld l,$cf		; $4e06
	ld (hl),$00		; $4e08
	ld a,$01		; $4e0a
	call objectGetRelatedObject1Var		; $4e0c
	ld a,(hl)		; $4e0f
	ld e,$f0		; $4e10
	ld (de),a		; $4e12
	call objectSetVisible80		; $4e13
_label_10_096:
	call objectCheckCollidedWithLink		; $4e16
	jp c,$4e83		; $4e19
	ld a,$00		; $4e1c
	call objectGetRelatedObject1Var		; $4e1e
	ldi a,(hl)		; $4e21
	or a			; $4e22
	jr z,_label_10_097	; $4e23
	ld e,$f0		; $4e25
	ld a,(de)		; $4e27
	cp (hl)			; $4e28
	jp z,objectTakePosition		; $4e29
_label_10_097:
	jp partDelete		; $4e2c
	inc e			; $4e2f
	ld a,(de)		; $4e30
	rst_jumpTable			; $4e31
	ldd a,(hl)		; $4e32
	ld c,(hl)		; $4e33
	ld c,c			; $4e34
	ld c,(hl)		; $4e35
	ld h,c			; $4e36
	ld c,(hl)		; $4e37
	ld a,e			; $4e38
	ld c,(hl)		; $4e39
	ld h,d			; $4e3a
	ld l,e			; $4e3b
	inc (hl)		; $4e3c
	ld a,($d128)		; $4e3d
	dec a			; $4e40
	ld l,$d0		; $4e41
	ld (hl),$14		; $4e43
	jr z,_label_10_098	; $4e45
	ld (hl),$28		; $4e47
_label_10_098:
	ld hl,$d128		; $4e49
	ld a,(hl)		; $4e4c
	or a			; $4e4d
	jr z,_label_10_099	; $4e4e
	call $4f92		; $4e50
	ret nz			; $4e53
	ld l,$c5		; $4e54
	inc (hl)		; $4e56
	ld l,$e4		; $4e57
	res 7,(hl)		; $4e59
	ld bc,$ffc0		; $4e5b
	jp objectSetSpeedZ		; $4e5e
	ld c,$00		; $4e61
	call objectUpdateSpeedZ_paramC		; $4e63
	ld e,$cf		; $4e66
	ld a,(de)		; $4e68
	cp $f7			; $4e69
	ret nc			; $4e6b
_label_10_099:
	ld a,$01		; $4e6c
	ld ($d125),a		; $4e6e
	ld h,d			; $4e71
	ld l,$c5		; $4e72
	ld (hl),$03		; $4e74
	ld l,$c3		; $4e76
	ld (hl),$00		; $4e78
	ret			; $4e7a
	ld e,$c3		; $4e7b
	ld a,(de)		; $4e7d
	rlca			; $4e7e
	ret nc			; $4e7f
	jp partDelete		; $4e80
	ld a,($cca4)		; $4e83
	bit 0,a			; $4e86
	ret nz			; $4e88
	ld e,$c2		; $4e89
	ld a,(de)		; $4e8b
	and $7f			; $4e8c
	ld hl,$4fad		; $4e8e
	rst_addAToHl			; $4e91
	ld a,($d12a)		; $4e92
	add (hl)		; $4e95
	ld ($d12a),a		; $4e96
	ld a,(de)		; $4e99
	and $7f			; $4e9a
	jr z,_label_10_104	; $4e9c
	add a			; $4e9e
	ld hl,$4eeb		; $4e9f
	rst_addDoubleIndex			; $4ea2
	ldi a,(hl)		; $4ea3
	ld b,a			; $4ea4
	ld a,$26		; $4ea5
	call cpActiveRing		; $4ea7
	ldi a,(hl)		; $4eaa
	jr z,_label_10_100	; $4eab
	cp $ff			; $4ead
	jr z,_label_10_101	; $4eaf
	call cpActiveRing		; $4eb1
	jr nz,_label_10_101	; $4eb4
_label_10_100:
	inc hl			; $4eb6
_label_10_101:
	ld c,(hl)		; $4eb7
	ld a,b			; $4eb8
	cp $2d			; $4eb9
	jr nz,_label_10_102	; $4ebb
	call getRandomRingOfGivenTier		; $4ebd
_label_10_102:
	cp $2f			; $4ec0
	jr nz,_label_10_103	; $4ec2
	ld a,$5e		; $4ec4
	call playSound		; $4ec6
	ld a,$2f		; $4ec9
_label_10_103:
	call giveTreasure		; $4ecb
	jp partDelete		; $4ece
_label_10_104:
	ld bc,$2b02		; $4ed1
	call createTreasure		; $4ed4
	ret nz			; $4ed7
	ld l,$4b		; $4ed8
	ld a,($d00b)		; $4eda
	ldi (hl),a		; $4edd
	inc l			; $4ede
	ld a,($d00d)		; $4edf
	ld (hl),a		; $4ee2
	ld hl,$c641		; $4ee3
	set 7,(hl)		; $4ee6
	jp partDelete		; $4ee8
	dec hl			; $4eeb
	rst $38			; $4eec
	ld bc,$3401		; $4eed
	rst $38			; $4ef0
	ld bc,$2d01		; $4ef1
	rst $38			; $4ef4
	ld bc,$2d01		; $4ef5
	rst $38			; $4ef8
	ld (bc),a		; $4ef9
	ld (bc),a		; $4efa
	cpl			; $4efb
	rst $38			; $4efc
	ld bc,$2001		; $4efd
	rst $38			; $4f00
	dec b			; $4f01
	ld a,(bc)		; $4f02
	ld hl,$05ff		; $4f03
	ld a,(bc)		; $4f06
	ldi (hl),a		; $4f07
	rst $38			; $4f08
	dec b			; $4f09
	ld a,(bc)		; $4f0a
	inc hl			; $4f0b
	rst $38			; $4f0c
	dec b			; $4f0d
	ld a,(bc)		; $4f0e
	inc h			; $4f0f
	rst $38			; $4f10
	dec b			; $4f11
	ld a,(bc)		; $4f12
	inc bc			; $4f13
	rst $38			; $4f14
	inc b			; $4f15
	ld ($2529),sp		; $4f16
	inc b			; $4f19
	ld ($2428),sp		; $4f1a
	inc bc			; $4f1d
	inc b			; $4f1e
	jr z,_label_10_105	; $4f1f
	ld bc,$1e02		; $4f21
	jp nz,$4f1a		; $4f24
	add a			; $4f27
	add c			; $4f28
	ld hl,$4f3c		; $4f29
	rst_addAToHl			; $4f2c
	ld e,$dd		; $4f2d
	ld a,(de)		; $4f2f
	add (hl)		; $4f30
	ld (de),a		; $4f31
	inc hl			; $4f32
	dec e			; $4f33
	ldi a,(hl)		; $4f34
	ld (de),a		; $4f35
	dec e			; $4f36
	ld (de),a		; $4f37
	ld a,(hl)		; $4f38
	jp partSetAnimation		; $4f39
	stop			; $4f3c
	ld (bc),a		; $4f3d
	stop			; $4f3e
	ld a,(bc)		; $4f3f
	ld bc,$0800		; $4f40
	nop			; $4f43
	nop			; $4f44
_label_10_105:
	ld ($0000),sp		; $4f45
	nop			; $4f48
	ld (bc),a		; $4f49
	rrca			; $4f4a
	ld (de),a		; $4f4b
	ld (bc),a		; $4f4c
	dec b			; $4f4d
	inc d			; $4f4e
	inc bc			; $4f4f
	ld b,$16		; $4f50
	ld bc,$1807		; $4f52
	ld bc,$1a08		; $4f55
	nop			; $4f58
	ld ($0410),sp		; $4f59
	inc b			; $4f5c
	ld (bc),a		; $4f5d
	dec b			; $4f5e
	ld bc,$0506		; $4f5f
	inc bc			; $4f62
	inc b			; $4f63
	nop			; $4f64
	ld (bc),a		; $4f65
	ld h,d			; $4f66
	ld l,$cb		; $4f67
	ld a,(hl)		; $4f69
	cp $f0			; $4f6a
	jr c,_label_10_106	; $4f6c
	xor a			; $4f6e
_label_10_106:
	cp $20			; $4f6f
	jr nc,_label_10_107	; $4f71
	ld (hl),$20		; $4f73
	jr _label_10_108		; $4f75
_label_10_107:
	cp $78			; $4f77
	jr c,_label_10_108	; $4f79
	ld (hl),$78		; $4f7b
_label_10_108:
	ld l,$cd		; $4f7d
	ld a,(hl)		; $4f7f
	cp $f0			; $4f80
	jr c,_label_10_109	; $4f82
	xor a			; $4f84
_label_10_109:
	cp $08			; $4f85
	jr nc,_label_10_110	; $4f87
	ld (hl),$08		; $4f89
	ret			; $4f8b
_label_10_110:
	cp $98			; $4f8c
	ret c			; $4f8e
	ld (hl),$98		; $4f8f
	ret			; $4f91
	ld l,$0b		; $4f92
	ld b,(hl)		; $4f94
	ld l,$0d		; $4f95
	ld c,(hl)		; $4f97
	push bc			; $4f98
	call objectGetRelativeAngle		; $4f99
	ld e,$c9		; $4f9c
	ld (de),a		; $4f9e
	call objectApplySpeed		; $4f9f
	pop bc			; $4fa2
	ld h,d			; $4fa3
	ld l,$cb		; $4fa4
	ldi a,(hl)		; $4fa6
	cp b			; $4fa7
	ret nz			; $4fa8
	inc l			; $4fa9
	ld a,(hl)		; $4faa
	cp c			; $4fab
	ret			; $4fac
	inc a			; $4fad
	rrca			; $4fae
	ld a,(bc)		; $4faf
	ld ($0506),sp		; $4fb0
	dec b			; $4fb3
	dec b			; $4fb4
	dec b			; $4fb5
	dec b			; $4fb6
	inc b			; $4fb7
	inc bc			; $4fb8
	ld (bc),a		; $4fb9
	.db $01		; $4fba
	.db $00		; $4fbb

partCode17:
	.db $28		; $4fbc
	dec l			; $4fbd
	ld e,$c2		; $4fbe
	ld a,(de)		; $4fc0
	add a			; $4fc1
	ld hl,$5081		; $4fc2
	rst_addDoubleIndex			; $4fc5
	ld e,$ea		; $4fc6
	ld a,(de)		; $4fc8
	and $1f			; $4fc9
	call checkFlag		; $4fcb
	jr z,_label_10_111	; $4fce
	call checkLinkVulnerable		; $4fd0
	jr nc,_label_10_111	; $4fd3
	ld h,d			; $4fd5
	ld l,$c4		; $4fd6
	ld (hl),$02		; $4fd8
	ld l,$e4		; $4fda
	res 7,(hl)		; $4fdc
	ld l,$c2		; $4fde
	ld a,(hl)		; $4fe0
	or a			; $4fe1
	jr z,_label_10_111	; $4fe2
	ld a,$2a		; $4fe4
	call objectGetRelatedObject1Var		; $4fe6
	ld (hl),$ff		; $4fe9
_label_10_111:
	ld e,$c4		; $4feb
	ld a,(de)		; $4fed
	rst_jumpTable			; $4fee
	push af			; $4fef
	ld c,a			; $4ff0
	ld c,$50		; $4ff1
	rra			; $4ff3
	ld d,b			; $4ff4
	ld a,$01		; $4ff5
	ld (de),a		; $4ff7
	ld a,$26		; $4ff8
	call objectGetRelatedObject1Var		; $4ffa
	ld e,$e6		; $4ffd
	ldi a,(hl)		; $4fff
	ld (de),a		; $5000
	inc e			; $5001
	ld a,(hl)		; $5002
	ld (de),a		; $5003
	call objectTakePosition		; $5004
	ld e,$f0		; $5007
	ld l,$41		; $5009
	ld a,(hl)		; $500b
	ld (de),a		; $500c
	ret			; $500d
	call $5015		; $500e
	ret z			; $5011
	jp partDelete		; $5012
	ld a,$01		; $5015
	call objectGetRelatedObject1Var		; $5017
	ld e,$f0		; $501a
	ld a,(de)		; $501c
	cp (hl)			; $501d
	ret			; $501e
	call $5015		; $501f
	jp nz,partDelete		; $5022
	ld e,$c5		; $5025
	ld a,(de)		; $5027
	rst_jumpTable			; $5028
	cpl			; $5029
	ld d,b			; $502a
	ld c,a			; $502b
	ld d,b			; $502c
	ld h,(hl)		; $502d
	ld d,b			; $502e
	ld h,d			; $502f
	ld l,e			; $5030
	inc (hl)		; $5031
	ld l,$d0		; $5032
	ld (hl),$28		; $5034
	ld a,$1a		; $5036
	call objectGetRelatedObject1Var		; $5038
	set 6,(hl)		; $503b
	ld e,$c2		; $503d
	ld a,(de)		; $503f
	or a			; $5040
	ld a,$10		; $5041
	call nz,objectGetAngleTowardLink		; $5043
	ld e,$c9		; $5046
	ld (de),a		; $5048
	ld bc,$fec0		; $5049
	jp objectSetSpeedZ		; $504c
	ld c,$18		; $504f
	call objectUpdateSpeedZAndBounce		; $5051
	jr z,_label_10_112	; $5054
	call objectApplySpeed		; $5056
	ld a,$00		; $5059
	call objectGetRelatedObject1Var		; $505b
	jp objectCopyPosition		; $505e
_label_10_112:
	ld e,$c5		; $5061
	ld a,$02		; $5063
	ld (de),a		; $5065
	ld c,$18		; $5066
	call objectUpdateSpeedZAndBounce		; $5068
	jr nc,_label_10_113	; $506b
	call $5073		; $506d
	jp partDelete		; $5070
_label_10_113:
	call objectCheckTileCollision_allowHoles		; $5073
	call nc,objectApplySpeed		; $5076
	ld a,$00		; $5079
	call objectGetRelatedObject1Var		; $507b
	jp objectCopyPosition		; $507e
	ld a,($ff00+$03)	; $5081
	nop			; $5083
	nop			; $5084
	ld a,($ff00+$03)	; $5085
	nop			; $5087
	nop			; $5088

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

partCode27:
	ld e,$c4		; $55b6
	ld a,(de)		; $55b8
	rst_jumpTable			; $55b9
	ret nz			; $55ba
	ld d,l			; $55bb
.DB $e3				; $55bc
	ld d,l			; $55bd
	pop af			; $55be
	ld d,l			; $55bf
	ld a,$01		; $55c0
	ld (de),a		; $55c2
	call getRandomNumber_noPreserveVars		; $55c3
	ld e,$f0		; $55c6
	and $06			; $55c8
	ld (de),a		; $55ca
	ld h,d			; $55cb
	ld l,$cf		; $55cc
	ld (hl),$c0		; $55ce
	ld l,$d7		; $55d0
	ld a,(hl)		; $55d2
	or a			; $55d3
	ret z			; $55d4
	ld l,$c6		; $55d5
	ld (hl),$1e		; $55d7
	ld l,$cb		; $55d9
	ldh a,(<hEnemyTargetY)	; $55db
	ldi (hl),a		; $55dd
	inc l			; $55de
	ldh a,(<hEnemyTargetX)	; $55df
	ld (hl),a		; $55e1
	ret			; $55e2
	call partCommon_decCounter1IfNonzero		; $55e3
	ret nz			; $55e6
	ld l,e			; $55e7
	inc (hl)		; $55e8
	ld a,$d2		; $55e9
	call playSound		; $55eb
	jp objectSetVisible81		; $55ee
	call partAnimate		; $55f1
	ld e,$e1		; $55f4
	ld a,(de)		; $55f6
	inc a			; $55f7
	jp z,partDelete		; $55f8
	call $560c		; $55fb
	ld e,$c3		; $55fe
	ld a,(de)		; $5600
	or a			; $5601
	ret z			; $5602
	ld b,a			; $5603
	ld a,($cfd2)		; $5604
	or b			; $5607
	ld ($cfd2),a		; $5608
	ret			; $560b
	ld e,$e1		; $560c
	ld a,(de)		; $560e
	bit 7,a			; $560f
	call nz,$564d		; $5611
	ld e,$e1		; $5614
	ld a,(de)		; $5616
	and $0e			; $5617
	ld hl,$5640		; $5619
	rst_addAToHl			; $561c
	ld e,$e6		; $561d
	ldi a,(hl)		; $561f
	ld (de),a		; $5620
	inc e			; $5621
	ld a,(hl)		; $5622
	ld (de),a		; $5623
	ld e,$e1		; $5624
	ld a,(de)		; $5626
	and $70			; $5627
	swap a			; $5629
	ld hl,$5648		; $562b
	rst_addAToHl			; $562e
	ld e,$cf		; $562f
	ld a,(hl)		; $5631
	ld (de),a		; $5632
	ld e,$e1		; $5633
	ld a,(de)		; $5635
	bit 0,a			; $5636
	ret z			; $5638
	dec a			; $5639
	ld (de),a		; $563a
	ld a,$06		; $563b
	jp setScreenShakeCounter		; $563d
	ld (bc),a		; $5640
	ld (bc),a		; $5641
	inc b			; $5642
	ld b,$05		; $5643
	add hl,bc		; $5645
	inc b			; $5646
	dec b			; $5647
	ret nz			; $5648
	ret nc			; $5649
	ld ($ff00+$f0),a	; $564a
	nop			; $564c
	res 7,a			; $564d
	ld (de),a		; $564f
	and $0e			; $5650
	sub $02			; $5652
	ld b,a			; $5654
	ld e,$f0		; $5655
	ld a,(de)		; $5657
	add b			; $5658
	ld hl,$5669		; $5659
	rst_addAToHl			; $565c
	ldi a,(hl)		; $565d
	ld c,(hl)		; $565e
	ld b,a			; $565f
	call getFreeInteractionSlot		; $5660
	ret nz			; $5663
	ld (hl),$08		; $5664
	jp objectCopyPositionWithOffset		; $5666
	ld (bc),a		; $5669
	ld b,$00		; $566a
	ei			; $566c
	rst $38			; $566d
	rlca			; $566e
.DB $fd				; $566f
.DB $fc				; $5670
	nop			; $5671
	dec b			; $5672

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
	jp nc,$5a4e		; $59bc
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

partCode53:
	ld e,$c4		; $5deb
	ld a,(de)		; $5ded
	or a			; $5dee
	jr z,_label_10_213	; $5def
	ld a,($cd2d)		; $5df1
	or a			; $5df4
	jp nz,partDelete		; $5df5
	ld h,d			; $5df8
	ld l,$c6		; $5df9
	ld a,(hl)		; $5dfb
	inc a			; $5dfc
	jr z,_label_10_211	; $5dfd
	dec (hl)		; $5dff
	jp z,partDelete		; $5e00
_label_10_211:
	inc e			; $5e03
	ld a,(de)		; $5e04
	or a			; $5e05
	jr nz,_label_10_212	; $5e06
	inc l			; $5e08
	dec (hl)		; $5e09
	ret nz			; $5e0a
	ld l,e			; $5e0b
	inc (hl)		; $5e0c
	ld l,$f2		; $5e0d
	ld a,(hl)		; $5e0f
	swap a			; $5e10
	rrca			; $5e12
	ld l,$c3		; $5e13
	add (hl)		; $5e15
	call partSetAnimation		; $5e16
	call $5e80		; $5e19
	jp objectSetVisible		; $5e1c
_label_10_212:
	call objectApplySpeed		; $5e1f
	call partAnimate		; $5e22
	ld e,$e1		; $5e25
	ld a,(de)		; $5e27
	inc a			; $5e28
	ret nz			; $5e29
	ld h,d			; $5e2a
	ld l,$c5		; $5e2b
	dec (hl)		; $5e2d
	call objectSetInvisible		; $5e2e
	jr _label_10_214		; $5e31
_label_10_213:
	ld h,d			; $5e33
	ld l,e			; $5e34
	inc (hl)		; $5e35
	ld l,$c0		; $5e36
	set 7,(hl)		; $5e38
	ld l,$d0		; $5e3a
	ld (hl),$78		; $5e3c
	ld l,$c3		; $5e3e
	ld a,(hl)		; $5e40
	add a			; $5e41
	add a			; $5e42
	xor $10			; $5e43
	ld l,$c9		; $5e45
	ld (hl),a		; $5e47
	xor a			; $5e48
	ld ($cd2d),a		; $5e49
_label_10_214:
	call getRandomNumber_noPreserveVars		; $5e4c
	and $07			; $5e4f
	inc a			; $5e51
	ld e,$c7		; $5e52
	ld (de),a		; $5e54
	ret			; $5e55
createEnergySwirlGoingOut_body:
	ld a,$01		; $5e56
	jr _label_10_215		; $5e58
createEnergySwirlGoingIn_body:
	xor a			; $5e5a
_label_10_215:
	ldh (<hFF8B),a	; $5e5b
	push de			; $5e5d
	ld e,l			; $5e5e
	ld d,$08		; $5e5f
_label_10_216:
	call getFreePartSlot		; $5e61
	jr nz,_label_10_217	; $5e64
	ld (hl),$53		; $5e66
	ld l,$c6		; $5e68
	ld (hl),e		; $5e6a
	ld l,$f0		; $5e6b
	ld (hl),b		; $5e6d
	inc l			; $5e6e
	ld (hl),c		; $5e6f
	inc l			; $5e70
	ldh a,(<hFF8B)	; $5e71
	ld (hl),a		; $5e73
	ld l,$c3		; $5e74
	dec d			; $5e76
	ld (hl),d		; $5e77
	jr nz,_label_10_216	; $5e78
_label_10_217:
	pop de			; $5e7a
	ld a,$5c		; $5e7b
	jp playSound		; $5e7d
	ld h,d			; $5e80
	ld l,$f2		; $5e81
	ldd a,(hl)		; $5e83
	or a			; $5e84
	jr nz,_label_10_218	; $5e85
	ld e,$c3		; $5e87
	ld a,(de)		; $5e89
	add a			; $5e8a
	add a			; $5e8b
	ld e,$c8		; $5e8c
	ld (de),a		; $5e8e
	ld c,(hl)		; $5e8f
	dec l			; $5e90
	ld b,(hl)		; $5e91
	ld a,$38		; $5e92
	jp objectSetPositionInCircleArc		; $5e94
_label_10_218:
	ld e,$cd		; $5e97
	ldd a,(hl)		; $5e99
	ld (de),a		; $5e9a
	ld e,$cb		; $5e9b
	ld a,(hl)		; $5e9d
	ld (de),a		; $5e9e
	ret			; $5e9f

.ends

.include "code/roomInitialization.s"

 m_section_force "Part_Code_2" NAMESPACE "partCode"


_label_11_212:
	ld d,$d0		; $61be
	ld a,d			; $61c0
_label_10_245:
	ldh (<hActiveObject),a	; $61c1
	ld e,$c0		; $61c3
	ld a,(de)		; $61c5
	or a			; $61c6
	jr z,_label_10_247	; $61c7
	rlca			; $61c9
	jr c,_label_10_246	; $61ca
	ld e,$c4		; $61cc
	ld a,(de)		; $61ce
	or a			; $61cf
	jr nz,_label_10_247	; $61d0
_label_10_246:
	call $620e		; $61d2
_label_10_247:
	inc d			; $61d5
	ld a,d			; $61d6
	cp $e0			; $61d7
	jr c,_label_10_245	; $61d9
	ret			; $61db

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

_func_11_5e8a:
	call partCode.partCommon_standardUpdate		; $620e

	ld e,$c1		; $6211
	ld a,(de)		; $6213
	add a			; $6214
	add $23			; $6215
	ld l,a			; $6217
	ld a,$00		; $6218
	adc $62			; $621a
	ld h,a			; $621c

	ldi a,(hl)		; $621d
	ld h,(hl)		; $621e
	ld l,a			; $621f

	ld a,c			; $6220
	or a			; $6221
	jp hl			; $6222

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


; var30 - pointer to tile at part's position
; $ccbf - set to 1 when button in hallway to D3 miniboss is pressed
partCode0a:
	ld e,Part.subid		; $62cf
	ld a,(de)		; $62d1
	rst_jumpTable			; $62d2
	.dw @subid0
	.dw @subidStub
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	ld e,Part.state		; $62dd
	ld a,(de)		; $62df
	rst_jumpTable			; $62e0
	.dw @@state0
	.dw @@state1
@@state0:
	call @init_StoreTileAtPartInVar30		; $62e5
	ld l,Part.counter1		; $62e8
	ld (hl),$08		; $62ea
	ret			; $62ec
@@state1:
	; Proceed once button in D3 hallway to miniboss stepped on
	ld a,($ccbf)		; $62ed
	or a			; $62f0
	ret z			; $62f1

	call @breakFloorsAtInterval		; $62f2
	ret nz			; $62f5

	call @spreadVertical		; $62f6
	ret z			; $62f9

	call @spreadHorizontal		; $62fa
	ret z			; $62fd
	jp partDelete		; $62fe

@subidStub:
	jp partDelete		; $6301

@subid2:
@subid3:
	ld e,Part.state		; $6304
	ld a,(de)		; $6306
	rst_jumpTable			; $6307
	.dw @@state0
	.dw @@state1
@@state0:
	call @init_StoreTileAtPartInVar30		; $630c
	ld l,Part.counter1		; $630f
	ld (hl),$20		; $6311
	ret			; $6313
@@state1:
	ld a,($ccbf)		; $6314
	or a			; $6317
	ret z			; $6318
	call @breakFloorsAtInterval		; $6319
	ret nz			; $631c
	call $63ed		; $631d
	ret nz			; $6320
	jp partDelete		; $6321

@subid4:
	ld h,d			; $6324
	ld l,Part.state		; $6325
	ld a,(hl)		; $6327
	or a			; $6328
	jr nz,+			; $6329
	ld (hl),$01		; $632b
	ld l,Part.counter1		; $632d
	ld (hl),$08		; $632f
	inc l			; $6331
	ld (hl),$00		; $6332
	call @seasonsFunc_10_6348		; $6334
+
	ld a,$3c		; $6337
	call setScreenShakeCounter		; $6339
	call partCommon_decCounter1IfNonzero		; $633c
	ret nz			; $633f
	ld l,Part.yh		; $6340
	ld c,(hl)		; $6342
	ld a,TILEINDEX_BLANK_HOLE		; $6343
	call breakCrackedFloor		; $6345
@seasonsFunc_10_6348:
	ld e,Part.counter2		; $6348
	ld a,(de)		; $634a
	ld hl,@seasonsTable_10_6361		; $634b
	rst_addDoubleIndex			; $634e
	ld a,(hl)		; $634f
	or a			; $6350
	jp z,partDelete		; $6351

	ldi a,(hl)		; $6354
	ld e,Part.counter1		; $6355
	ld (de),a		; $6357

	ld a,(hl)		; $6358
	ld e,Part.yh		; $6359
	ld (de),a		; $635b

	ld h,d			; $635c
	ld l,Part.counter2		; $635d
	inc (hl)		; $635f
	ret			; $6360
@seasonsTable_10_6361:
	.db $1e $91
	.db $1e $81
	.db $01 $82
	.db $1d $71
	.db $01 $61
	.db $1d $83
	.db $01 $51
	.db $1d $84
	.db $01 $52
	.db $1d $85
	.db $01 $53
	.db $1d $86
	.db $01 $63
	.db $1d $87
	.db $01 $64
	.db $1d $88
	.db $01 $65
	.db $1d $89
	.db $01 $55
	.db $1d $79
	.db $01 $45
	.db $1d $69
	.db $01 $35
	.db $01 $68
	.db $1c $6a
	.db $01 $25
	.db $01 $58
	.db $1c $6b
	.db $01 $48
	.db $1d $5b
	.db $1e $38
	.db $1e $37
	.db $1e $36
	.db $00

@init_StoreTileAtPartInVar30:
	ld a,$01		; $63a4
	ld (de),a		; $63a6

	ld h,d			; $63a7
	ld l,Part.yh		; $63a8
	ld a,(hl)		; $63aa
	ld c,a			; $63ab

	ld b,>wRoomLayout		; $63ac
	ld a,(bc)		; $63ae

	ld l,Part.var30		; $63af
	ld (hl),a		; $63b1
	ret			; $63b2

@breakFloorsAtInterval:
	call partCommon_decCounter1IfNonzero		; $63b3
	ret nz			; $63b6

	; counter back to $08
	ld (hl),$08		; $63b7
	ld l,Part.var30		; $63b9
	ld a,TILEINDEX_CRACKED_FLOOR		; $63bb
	cp (hl)			; $63bd
	ld a,TILEINDEX_HOLE		; $63be
	jr z,+			; $63c0
	ld a,TILEINDEX_BLANK_HOLE		; $63c2
+
	ld l,Part.yh		; $63c4
	ld c,(hl)		; $63c6
	call breakCrackedFloor		; $63c7

	; proceed to below function
	xor a			; $63ca
	ret			; $63cb

@spreadVertical:
	ld h,$10		; $63cc
	jr @spread			; $63ce
@spreadHorizontal:
	ld h,$01		; $63d0
@spread:
	ld b,>wRoomLayout		; $63d2
	ld e,Part.var30		; $63d4
	ld a,(de)		; $63d6
	ld l,a			; $63d7

	ld e,Part.yh		; $63d8
	ld a,(de)		; $63da
	ld e,a			; $63db

	sub h			; $63dc
	ld c,a			; $63dd
	ld a,(bc)		; $63de
	cp l			; $63df
	jr z,+			; $63e0

	ld a,e			; $63e2
	add h			; $63e3
	ld c,a			; $63e4
	ld a,(bc)		; $63e5
	cp l			; $63e6
	ret nz			; $63e7
+
	ld a,c			; $63e8
	ld e,Part.yh		; $63e9
	ld (de),a		; $63eb
	ret			; $63ec

seasonsFunc_10_63ed:
	ld e,Part.var30		; $63ed
	ld a,(de)		; $63ef
	ld b,a			; $63f0
	ld c,$10		; $63f1
	ld hl,wRoomLayout		; $63f3
_label_10_254:
	ld a,b			; $63f6
	cp (hl)			; $63f7
	jr z,_label_10_256	; $63f8
	ld a,l			; $63fa
	cp $ae			; $63fb
	ret z			; $63fd
	add c			; $63fe
	cp $f0			; $63ff
	jr nc,_label_10_255	; $6401
	cp $b0			; $6403
	jr nc,_label_10_255	; $6405
	ld l,a			; $6407
	jr _label_10_254		; $6408
_label_10_255:
	ld a,c			; $640a
	cpl			; $640b
	inc a			; $640c
	ld c,a			; $640d
	ld a,l			; $640e
	add c			; $640f
	inc a			; $6410
	ld l,a			; $6411
	jr _label_10_254		; $6412
_label_10_256:
	ld a,l			; $6414
	ld e,Part.yh		; $6415
	ld (de),a		; $6417
	or d			; $6418
	ret			; $6419


partCode0d:
	jr z,_label_10_257	; $641a
	call objectSetVisible83		; $641c
	ld h,d			; $641f
	ld l,$c6		; $6420
	ld (hl),$2d		; $6422
	ld l,$c2		; $6424
	ld a,(hl)		; $6426
	ld b,a			; $6427
	and $07			; $6428
	ld hl,$ccba		; $642a
	call setFlag		; $642d
	bit 7,b			; $6430
	jr z,_label_10_257	; $6432
	ld e,$c4		; $6434
	ld a,$02		; $6436
	ld (de),a		; $6438
_label_10_257:
	ld e,$c4		; $6439
	ld a,(de)		; $643b
	rst_jumpTable			; $643c
	ld b,e			; $643d
	ld h,h			; $643e
	ld b,a			; $643f
	ld h,h			; $6440
	jr nc,$1e		; $6441
	ld a,$01		; $6443
	ld (de),a		; $6445
	ret			; $6446
	call partCommon_decCounter1IfNonzero		; $6447
	ret nz			; $644a
	ld e,$c2		; $644b
	ld a,(de)		; $644d
	ld hl,$ccba		; $644e
	call unsetFlag		; $6451
	jp objectSetInvisible		; $6454

partCode16:
	jr z,_label_10_259	; $6457
	ld h,d			; $6459
	ld l,$c4		; $645a
	ld (hl),$02		; $645c
	ld l,$c6		; $645e
	ld (hl),$14		; $6460
	ld l,$e4		; $6462
	ld (hl),$00		; $6464
	call getThisRoomFlags		; $6466
	and $c0			; $6469
	cp $80			; $646b
	jr nz,_label_10_258	; $646d
	ld a,($cd00)		; $646f
	and $01			; $6472
	jr z,_label_10_258	; $6474
	ld a,($cc34)		; $6476
	or a			; $6479
	jp nz,$6498		; $647a
	call $6515		; $647d
	inc a			; $6480
	ld ($ccab),a		; $6481
	ld ($cca4),a		; $6484
	ld ($cbca),a		; $6487
	inc a			; $648a
	ld ($cfd0),a		; $648b
	ld a,$08		; $648e
	ld ($cfc0),a		; $6490
_label_10_258:
	ld a,$01		; $6493
	ld ($cc36),a		; $6495
_label_10_259:
	ld hl,$cfd0		; $6498
	ld a,(hl)		; $649b
	inc a			; $649c
	jp z,partDelete		; $649d
	ld e,$c4		; $64a0
	ld a,(de)		; $64a2
	rst_jumpTable			; $64a3
	xor d			; $64a4
	ld h,h			; $64a5
	xor l			; $64a6
	ld h,h			; $64a7
	cp c			; $64a8
	ld h,h			; $64a9
	ld a,$01		; $64aa
	ld (de),a		; $64ac
	ld a,($cc48)		; $64ad
	ld h,a			; $64b0
	ld l,$00		; $64b1
	call preventObjectHFromPassingObjectD		; $64b3
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $64b6
	call $64ad		; $64b9
	ld hl,$cfd0		; $64bc
	ld a,(hl)		; $64bf
	cp $02			; $64c0
	ret z			; $64c2
	ld e,$c5		; $64c3
	ld a,(de)		; $64c5
	or a			; $64c6
	jr nz,_label_10_260	; $64c7
	call partCommon_decCounter1IfNonzero		; $64c9
	ret nz			; $64cc
	ld (hl),$b4		; $64cd
	inc l			; $64cf
	ld (hl),$08		; $64d0
	ld l,$f0		; $64d2
	ld (hl),$08		; $64d4
	ld l,e			; $64d6
	inc (hl)		; $64d7
	ret			; $64d8
_label_10_260:
	call partCommon_decCounter1IfNonzero		; $64d9
	jr nz,_label_10_261	; $64dc
	ld a,($cd00)		; $64de
	and $01			; $64e1
	jr z,_label_10_261	; $64e3
	ld a,($cc34)		; $64e5
	or a			; $64e8
	jp nz,$64fc		; $64e9
	call $6515		; $64ec
	inc a			; $64ef
	ld ($ccab),a		; $64f0
	ld ($cfd0),a		; $64f3
	ld ($cca4),a		; $64f6
	ld ($cbca),a		; $64f9
_label_10_261:
	ldi a,(hl)		; $64fc
	cp $5a			; $64fd
	jr nz,_label_10_262	; $64ff
	ld e,$f0		; $6501
	ld a,$04		; $6503
	ld (de),a		; $6505
_label_10_262:
	dec (hl)		; $6506
	ret nz			; $6507
	ld e,$f0		; $6508
	ld a,(de)		; $650a
	ld (hl),a		; $650b
	ld l,$dc		; $650c
	ld a,(hl)		; $650e
	dec a			; $650f
	xor $01			; $6510
	inc a			; $6512
	ld (hl),a		; $6513
	ret			; $6514
	ld a,($cc48)		; $6515
	ld b,a			; $6518
	ld c,$2b		; $6519
	ld a,$80		; $651b
	ld (bc),a		; $651d
	ld c,$2d		; $651e
	xor a			; $6520
	ld (bc),a		; $6521
	ret			; $6522

partCode24:
	jr z,_label_10_263	; $6523
	ld e,$ea		; $6525
	ld a,(de)		; $6527
	cp $80			; $6528
	jp nz,partDelete		; $652a
_label_10_263:
	ld e,$c2		; $652d
	ld a,(de)		; $652f
	ld e,$c4		; $6530
	rst_jumpTable			; $6532
	add hl,sp		; $6533
	ld h,l			; $6534
	add hl,sp		; $6535
	ld h,l			; $6536
	ld (hl),d		; $6537
	ld h,l			; $6538
	ld a,(de)		; $6539
	or a			; $653a
	jr z,_label_10_266	; $653b
	call partCommon_decCounter1IfNonzero		; $653d
	ret nz			; $6540
	ld l,$c2		; $6541
	bit 0,(hl)		; $6543
	ld l,$cd		; $6545
	ldh a,(<hEnemyTargetX)	; $6547
	jr nz,_label_10_264	; $6549
	cp (hl)			; $654b
	ret c			; $654c
	jr _label_10_265		; $654d
_label_10_264:
	cp (hl)			; $654f
	ret nc			; $6550
_label_10_265:
	call $65b8		; $6551
	ret nc			; $6554
	call getRandomNumber_noPreserveVars		; $6555
	cp $50			; $6558
	ret nc			; $655a
	call $65a6		; $655b
	ret nz			; $655e
	ld l,$c9		; $655f
	ld (hl),$08		; $6561
	ld e,$c2		; $6563
	ld a,(de)		; $6565
	or a			; $6566
	ret z			; $6567
	ld (hl),$18		; $6568
	ret			; $656a
_label_10_266:
	ld h,d			; $656b
	ld l,e			; $656c
	inc (hl)		; $656d
	ld l,$c6		; $656e
	inc (hl)		; $6570
	ret			; $6571
	ld a,(de)		; $6572
	rst_jumpTable			; $6573
	ld a,d			; $6574
	ld h,l			; $6575
	adc b			; $6576
	ld h,l			; $6577
	adc a			; $6578
	ld h,l			; $6579
	ld h,d			; $657a
	ld l,e			; $657b
	inc (hl)		; $657c
	ld l,$c6		; $657d
	ld (hl),$10		; $657f
	ld l,$e4		; $6581
	set 7,(hl)		; $6583
	jp objectSetVisible81		; $6585
	call partCommon_decCounter1IfNonzero		; $6588
	jr nz,_label_10_267	; $658b
	ld l,e			; $658d
	inc (hl)		; $658e
	call $4072		; $658f
	jp c,partDelete		; $6592
_label_10_267:
	call objectApplySpeed		; $6595
	ld a,(wFrameCounter)		; $6598
	and $03			; $659b
	ret nz			; $659d
	ld e,$dc		; $659e
	ld a,(de)		; $65a0
	inc a			; $65a1
	and $07			; $65a2
	ld (de),a		; $65a4
	ret			; $65a5
	call getFreePartSlot		; $65a6
	ret nz			; $65a9
	ld (hl),$24		; $65aa
	inc l			; $65ac
	ld (hl),$02		; $65ad
	call objectCopyPosition		; $65af
	ld l,$d0		; $65b2
	ld (hl),$3c		; $65b4
	xor a			; $65b6
	ret			; $65b7
	ld l,$cb		; $65b8
	ldh a,(<hEnemyTargetY)	; $65ba
	sub (hl)		; $65bc
	add $10			; $65bd
	cp $21			; $65bf
	ret nc			; $65c1
	ld e,$c6		; $65c2
	ld a,$1e		; $65c4
	ld (de),a		; $65c6
	ret			; $65c7

partCode25:
	ld e,$c4		; $65c8
	ld a,(de)		; $65ca
	or a			; $65cb
	jr nz,_label_10_268	; $65cc
	ld h,d			; $65ce
	ld l,e			; $65cf
	inc (hl)		; $65d0
	ld l,$c2		; $65d1
	ld a,(hl)		; $65d3
	swap a			; $65d4
	rrca			; $65d6
	ld l,$c9		; $65d7
	ld (hl),a		; $65d9
_label_10_268:
	call partCommon_decCounter1IfNonzero		; $65da
	ret nz			; $65dd
	ld e,$c2		; $65de
	ld a,(de)		; $65e0
	bit 0,a			; $65e1
	ld e,$cd		; $65e3
	ldh a,(<hEnemyTargetX)	; $65e5
	jr z,_label_10_269	; $65e7
	ld e,$cb		; $65e9
	ldh a,(<hEnemyTargetY)	; $65eb
_label_10_269:
	ld b,a			; $65ed
	ld a,(de)		; $65ee
	sub b			; $65ef
	add $10			; $65f0
	cp $21			; $65f2
	ret nc			; $65f4
	ld e,$c6		; $65f5
	ld a,$21		; $65f7
	ld (de),a		; $65f9
	ld hl,$6661		; $65fa
	jr _label_10_271		; $65fd

partCode2c:
	ld e,$c4		; $65ff
	ld a,(de)		; $6601
	or a			; $6602
	jr nz,_label_10_270	; $6603
	ld h,d			; $6605
	ld l,e			; $6606
	inc (hl)		; $6607
	ld l,$c2		; $6608
	ld a,(hl)		; $660a
	ld b,a			; $660b
	swap a			; $660c
	rrca			; $660e
	ld l,$c9		; $660f
	ld (hl),a		; $6611
	ld a,b			; $6612
	call partSetAnimation		; $6613
	call getRandomNumber_noPreserveVars		; $6616
	and $30			; $6619
	ld e,$c6		; $661b
	ld (de),a		; $661d
	call objectMakeTileSolid		; $661e
	jp objectSetVisible82		; $6621
_label_10_270:
	ldh a,(<hCameraY)	; $6624
	add $80			; $6626
	ld b,a			; $6628
	ld e,$cb		; $6629
	ld a,(de)		; $662b
	cp b			; $662c
	ret nc			; $662d
	ldh a,(<hCameraX)	; $662e
	add $a0			; $6630
	ld b,a			; $6632
	ld e,$cd		; $6633
	ld a,(de)		; $6635
	cp b			; $6636
	ret nc			; $6637
	call partCommon_decCounter1IfNonzero		; $6638
	ret nz			; $663b
	call getRandomNumber_noPreserveVars		; $663c
	and $60			; $663f
	add $20			; $6641
	ld e,$c6		; $6643
	ld (de),a		; $6645
	ld hl,$6669		; $6646
_label_10_271:
	ld e,$c2		; $6649
	ld a,(de)		; $664b
	rst_addDoubleIndex			; $664c
	ldi a,(hl)		; $664d
	ld b,a			; $664e
	ld c,(hl)		; $664f
	call getFreePartSlot		; $6650
	ret nz			; $6653
	ld (hl),$1a		; $6654
	inc l			; $6656
	inc (hl)		; $6657
	call objectCopyPositionWithOffset		; $6658
	ld l,$c9		; $665b
	ld e,l			; $665d
	ld a,(de)		; $665e
	ld (hl),a		; $665f
	ret			; $6660
.DB $fc				; $6661
	nop			; $6662
	nop			; $6663
	inc b			; $6664
	inc b			; $6665
	nop			; $6666
	nop			; $6667
.DB $fc				; $6668
	ld hl,sp+$00		; $6669
	nop			; $666b
	ld ($0008),sp		; $666c
	nop			; $666f
	.db $f8		; $6670

partCode26:
	.db $28		; $6671
	ld a,(bc)		; $6672
	ld e,$ea		; $6673
	ld a,(de)		; $6675
	res 7,a			; $6676
	cp $03			; $6678
	jp nc,$670c		; $667a
	call $66e7		; $667d
	jp c,$670c		; $6680
	ld e,$c4		; $6683
	ld a,(de)		; $6685
	rst_jumpTable			; $6686
	adc l			; $6687
	ld h,(hl)		; $6688
	and h			; $6689
	ld h,(hl)		; $668a
	push de			; $668b
	ld h,(hl)		; $668c
	ld h,d			; $668d
	ld l,e			; $668e
	inc (hl)		; $668f
	ld l,$d0		; $6690
	ld (hl),$46		; $6692
	ld l,$c6		; $6694
	ld (hl),$16		; $6696
	ld l,$c9		; $6698
	ld (hl),$10		; $669a
	ld a,$73		; $669c
	call playSound		; $669e
	jp objectSetVisible82		; $66a1
	call partCommon_decCounter1IfNonzero		; $66a4
	jr nz,_label_10_272	; $66a7
	ld (hl),$10		; $66a9
	ld l,e			; $66ab
	inc (hl)		; $66ac
	jr $26			; $66ad
_label_10_272:
	ld a,(hl)		; $66af
	rrca			; $66b0
	jr nc,_label_10_273	; $66b1
	ld l,$d0		; $66b3
	ld a,(hl)		; $66b5
	cp $78			; $66b6
	jr z,_label_10_273	; $66b8
	add $05			; $66ba
	ld (hl),a		; $66bc
_label_10_273:
	call objectApplySpeed		; $66bd
	call partAnimate		; $66c0
	ld e,$e1		; $66c3
	ld a,(de)		; $66c5
	ld hl,$66d2		; $66c6
	rst_addAToHl			; $66c9
	ld e,$e6		; $66ca
	ld a,(hl)		; $66cc
	ld (de),a		; $66cd
	inc e			; $66ce
	ld a,(hl)		; $66cf
	ld (de),a		; $66d0
	ret			; $66d1
	ld (bc),a		; $66d2
	inc b			; $66d3
	ld b,$cd		; $66d4
	and a			; $66d6
	ld b,b			; $66d7
	jp z,partDelete		; $66d8
	ld a,(hl)		; $66db
	rrca			; $66dc
	jr nc,_label_10_273	; $66dd
	ld l,$d0		; $66df
	ld a,(hl)		; $66e1
	sub $0a			; $66e2
	ld (hl),a		; $66e4
	jr _label_10_273		; $66e5
	ld e,$e6		; $66e7
	ld a,(de)		; $66e9
	add $09			; $66ea
	ld b,a			; $66ec
	ld e,$e7		; $66ed
	ld a,(de)		; $66ef
	add $09			; $66f0
	ld c,a			; $66f2
	ld hl,$dd0b		; $66f3
	ld e,$cb		; $66f6
	ld a,(de)		; $66f8
	sub (hl)		; $66f9
	add b			; $66fa
	sla b			; $66fb
	inc b			; $66fd
	cp b			; $66fe
	ret nc			; $66ff
	ld l,$0d		; $6700
	ld e,$cd		; $6702
	ld a,(de)		; $6704
	sub (hl)		; $6705
	add c			; $6706
	sla c			; $6707
	inc c			; $6709
	cp c			; $670a
	ret			; $670b
	call objectCreatePuff		; $670c
	jp partDelete		; $670f

partCode2b:
	jr z,_label_10_274	; $6712
	ld e,$ea		; $6714
	ld a,(de)		; $6716
	cp $9a			; $6717
	ret nz			; $6719
	ld hl,$cfc0		; $671a
	set 0,(hl)		; $671d
	jp partDelete		; $671f
_label_10_274:
	ld e,$c4		; $6722
	ld a,(de)		; $6724
	or a			; $6725
	ret nz			; $6726
	inc a			; $6727
	ld (de),a		; $6728
	ld h,d			; $6729
	ld l,$e7		; $672a
	ld (hl),$12		; $672c
	ld l,$ff		; $672e
	set 5,(hl)		; $6730
	ret			; $6732

partCode2d:
	jr z,_label_10_275	; $6733
	ld h,d			; $6735
	ld l,$f0		; $6736
	bit 0,(hl)		; $6738
	jp nz,$67cc		; $673a
	inc (hl)		; $673d
	ld l,$e9		; $673e
	ld (hl),$00		; $6740
	ld l,$c6		; $6742
	ld (hl),$41		; $6744
	jp objectSetInvisible		; $6746
_label_10_275:
	ld e,$c2		; $6749
	ld a,(de)		; $674b
	srl a			; $674c
	ld e,$c4		; $674e
	rst_jumpTable			; $6750
	ld d,l			; $6751
	ld h,a			; $6752
	add l			; $6753
	ld h,a			; $6754
	ld a,(de)		; $6755
	or a			; $6756
	jr nz,_label_10_277	; $6757
_label_10_276:
	ld h,d			; $6759
	ld l,e			; $675a
	inc (hl)		; $675b
	ld l,$cb		; $675c
	res 3,(hl)		; $675e
	ld l,$cd		; $6760
	res 3,(hl)		; $6762
	ld a,$16		; $6764
	call checkGlobalFlag		; $6766
	jp nz,partDelete		; $6769
	ld e,$c2		; $676c
	ld a,(de)		; $676e
	call partSetAnimation		; $676f
	jp objectSetVisible82		; $6772
_label_10_277:
	call partAnimate		; $6775
	ld e,$e1		; $6778
	ld a,(de)		; $677a
	or a			; $677b
	ret z			; $677c
	ld bc,$fa13		; $677d
	dec a			; $6780
	jr z,_label_10_279	; $6781
	jr _label_10_278		; $6783
	ld a,(de)		; $6785
	or a			; $6786
	jr z,_label_10_276	; $6787
	call partAnimate		; $6789
	ld e,$e1		; $678c
	ld a,(de)		; $678e
	or a			; $678f
	ret z			; $6790
	ld bc,$faed		; $6791
	dec a			; $6794
	jr z,_label_10_279	; $6795
_label_10_278:
	call getFreePartSlot		; $6797
	ret nz			; $679a
	ld (hl),$3f		; $679b
	inc l			; $679d
	inc (hl)		; $679e
	call objectCopyPositionWithOffset		; $679f
	jr _label_10_280		; $67a2
_label_10_279:
	ld (de),a		; $67a4
	ld a,$81		; $67a5
	call playSound		; $67a7
	call getFreeInteractionSlot		; $67aa
	ret nz			; $67ad
	ld (hl),$05		; $67ae
	ld l,$42		; $67b0
	ld (hl),$80		; $67b2
	jp objectCopyPositionWithOffset		; $67b4
_label_10_280:
	ld e,$c2		; $67b7
	ld a,(de)		; $67b9
	bit 1,a			; $67ba
	ld b,$04		; $67bc
	jr z,_label_10_281	; $67be
	ld b,$12		; $67c0
_label_10_281:
	call getRandomNumber		; $67c2
	and $06			; $67c5
	add b			; $67c7
	ld l,$c9		; $67c8
	ld (hl),a		; $67ca
	ret			; $67cb
	call partCommon_decCounter1IfNonzero		; $67cc
	jp z,partDelete		; $67cf
	ld a,(hl)		; $67d2
	cp $35			; $67d3
	jr z,_label_10_282	; $67d5
	and $0f			; $67d7
	ret nz			; $67d9
	ld a,(hl)		; $67da
	and $f0			; $67db
	swap a			; $67dd
	dec a			; $67df
	ld hl,$67f0		; $67e0
	rst_addDoubleIndex			; $67e3
	ldi a,(hl)		; $67e4
	ld c,(hl)		; $67e5
	ld b,a			; $67e6
	call getFreeInteractionSlot		; $67e7
	ret nz			; $67ea
	ld (hl),$56		; $67eb
	jp objectCopyPositionWithOffset		; $67ed
	ld hl,sp+$04		; $67f0
	ld ($fafe),sp		; $67f2
	ld hl,sp+$02		; $67f5
	inc c			; $67f7
_label_10_282:
	ld e,$cb		; $67f8
	ld a,(de)		; $67fa
	sub $08			; $67fb
	and $f0			; $67fd
	ld b,a			; $67ff
	ld e,$cd		; $6800
	ld a,(de)		; $6802
	sub $08			; $6803
	and $f0			; $6805
	swap a			; $6807
	or b			; $6809
	ld c,a			; $680a
	ld b,$a2		; $680b
	ld e,$c2		; $680d
	ld a,(de)		; $680f
	bit 1,a			; $6810
	jr z,_label_10_283	; $6812
	ld b,$a6		; $6814
_label_10_283:
	push bc			; $6816
	ld a,b			; $6817
	call setTile		; $6818
	pop bc			; $681b
	ld a,b			; $681c
	inc a			; $681d
	inc c			; $681e
	jp setTile		; $681f

partCode2e:
	ld e,$c4		; $6822
	ld a,(de)		; $6824
	or a			; $6825
	jr z,_label_10_285	; $6826
	ld e,$e1		; $6828
	ld a,(de)		; $682a
	or a			; $682b
	jr z,_label_10_284	; $682c
	bit 7,a			; $682e
	jp nz,partDelete		; $6830
	call $6853		; $6833
_label_10_284:
	jp partAnimate		; $6836
_label_10_285:
	ld a,$01		; $6839
	ld (de),a		; $683b
	call objectGetTileAtPosition		; $683c
	cp $f3			; $683f
	jp z,partDelete		; $6841
	ld h,$ce		; $6844
	ld a,(hl)		; $6846
	or a			; $6847
	jp nz,partDelete		; $6848
	ld a,$98		; $684b
	call playSound		; $684d
	jp objectSetVisible83		; $6850
	push af			; $6853
	xor a			; $6854
	ld (de),a		; $6855
	call objectGetTileAtPosition		; $6856
	pop af			; $6859
	ld e,$f0		; $685a
	dec a			; $685c
	jr z,_label_10_286	; $685d
	ld a,(de)		; $685f
	ld (hl),a		; $6860
	ret			; $6861
_label_10_286:
	ld a,(hl)		; $6862
	ld (de),a		; $6863
	ld (hl),$f3		; $6864
	ret			; $6866

partCode2f:
	ld e,$c4		; $6867
	ld a,(de)		; $6869
	or a			; $686a
	ret nz			; $686b
	inc a			; $686c
	ld (de),a		; $686d
	ld e,$cb		; $686e
	ld a,(de)		; $6870
	sub $02			; $6871
	ld (de),a		; $6873
	ld e,$cd		; $6874
	ld a,(de)		; $6876
	add $03			; $6877
	ld (de),a		; $6879
	ret			; $687a

partCode32:
	jr z,_label_10_287	; $687b
	ld e,$c5		; $687d
	ld a,(de)		; $687f
	or a			; $6880
	jr nz,_label_10_288	; $6881
	call $68cc		; $6883
	ld a,$af		; $6886
	jp playSound		; $6888
_label_10_287:
	ld e,$c4		; $688b
	ld a,(de)		; $688d
	rst_jumpTable			; $688e
	sub e			; $688f
	ld l,b			; $6890
	cp l			; $6891
	ld l,b			; $6892
	ld a,$01		; $6893
	ld (de),a		; $6895
	ld e,$c2		; $6896
	ld a,(de)		; $6898
	call partSetAnimation		; $6899
	call getRandomNumber_noPreserveVars		; $689c
	and $03			; $689f
	ld hl,$68b9		; $68a1
	rst_addAToHl			; $68a4
	ld a,(hl)		; $68a5
	ld e,$d0		; $68a6
	ld (de),a		; $68a8
	call getRandomNumber_noPreserveVars		; $68a9
	and $3f			; $68ac
	add $78			; $68ae
	ld h,d			; $68b0
	ld l,$c6		; $68b1
	ldi (hl),a		; $68b3
	ld (hl),$10		; $68b4
	jp objectSetVisible81		; $68b6
	ld a,(bc)		; $68b9
	rrca			; $68ba
	rrca			; $68bb
	inc d			; $68bc
	ld e,$c5		; $68bd
	ld a,(de)		; $68bf
	or a			; $68c0
	jr nz,_label_10_288	; $68c1
	call objectApplySpeed		; $68c3
	call partCommon_decCounter1IfNonzero		; $68c6
	jp nz,$68e0		; $68c9
	ld h,d			; $68cc
	ld l,$c5		; $68cd
	inc (hl)		; $68cf
	ld a,$02		; $68d0
	jp partSetAnimation		; $68d2
_label_10_288:
	call partAnimate		; $68d5
	ld e,$e1		; $68d8
	ld a,(de)		; $68da
	inc a			; $68db
	jp z,partDelete		; $68dc
	ret			; $68df
	ld h,d			; $68e0
	ld l,$c7		; $68e1
	dec (hl)		; $68e3
	ret nz			; $68e4
	ld (hl),$10		; $68e5
	call getRandomNumber		; $68e7
	and $03			; $68ea
	ret nz			; $68ec
	and $01			; $68ed
	jr nz,_label_10_289	; $68ef
	ld a,$ff		; $68f1
_label_10_289:
	ld l,$c9		; $68f3
	add (hl)		; $68f5
	ld (hl),a		; $68f6
	ret			; $68f7

partCode33:
	ld e,$c4		; $68f8
	ld a,(de)		; $68fa
	rst_jumpTable			; $68fb
	ld (bc),a		; $68fc
	ld l,c			; $68fd
	jr c,_label_10_293	; $68fe
	ld c,l			; $6900
	ld l,c			; $6901
	ld h,d			; $6902
	ld l,e			; $6903
	inc (hl)		; $6904
	ld l,$d0		; $6905
	ld (hl),$50		; $6907
	ld b,$00		; $6909
	ld a,($cc45)		; $690b
	and $30			; $690e
	jr z,_label_10_290	; $6910
	ld b,$20		; $6912
	and $20			; $6914
	jr z,_label_10_290	; $6916
	ld b,$e0		; $6918
_label_10_290:
	ld a,($d00d)		; $691a
	add b			; $691d
	ld c,a			; $691e
	sub $08			; $691f
	cp $90			; $6921
	jr c,_label_10_291	; $6923
	ld c,$08		; $6925
	cp $d0			; $6927
	jr nc,_label_10_291	; $6929
	ld c,$98		; $692b
_label_10_291:
	ld b,$a0		; $692d
	call objectGetRelativeAngle		; $692f
	ld e,$c9		; $6932
	ld (de),a		; $6934
	jp objectSetVisible81		; $6935
	call objectApplySpeed		; $6938
	ld e,$cb		; $693b
	ld a,(de)		; $693d
	cp $98			; $693e
	jr c,_label_10_292	; $6940
	ld h,d			; $6942
	ld l,$c4		; $6943
	inc (hl)		; $6945
	ld l,$c6		; $6946
	ld (hl),$78		; $6948
_label_10_292:
	jp partAnimate		; $694a
	call partCommon_decCounter1IfNonzero		; $694d
	jp z,partDelete		; $6950
	jr _label_10_292		; $6953

partCode38:
	ld e,$d7		; $6955
	ld a,(de)		; $6957
	or a			; $6958
	jp z,partDelete		; $6959
	ld e,$c4		; $695c
	ld a,(de)		; $695e
	rst_jumpTable			; $695f
	ld l,b			; $6960
	ld l,c			; $6961
	add b			; $6962
	ld l,c			; $6963
	adc c			; $6964
	ld l,c			; $6965
	or a			; $6966
	ld l,c			; $6967
	ld h,d			; $6968
_label_10_293:
	ld l,e			; $6969
	inc (hl)		; $696a
	ld l,$d0		; $696b
	ld (hl),$50		; $696d
	ld l,$c6		; $696f
	ld (hl),$14		; $6971
	ld a,$08		; $6973
	call objectGetRelatedObject1Var		; $6975
	ld a,(hl)		; $6978
	or a			; $6979
	jp z,objectSetVisible82		; $697a
	jp objectSetVisible81		; $697d
	call partCommon_decCounter1IfNonzero		; $6980
	ret nz			; $6983
	ld l,e			; $6984
	inc (hl)		; $6985
	call objectSetVisible81		; $6986
	ld h,d			; $6989
	ld l,$f0		; $698a
	ld b,(hl)		; $698c
	inc l			; $698d
	ld c,(hl)		; $698e
	call objectGetRelativeAngle		; $698f
	ld e,$c9		; $6992
	ld (de),a		; $6994
	ld h,d			; $6995
	ld l,$f0		; $6996
	ld e,$cb		; $6998
	ld a,(de)		; $699a
	sub (hl)		; $699b
	add $08			; $699c
	cp $11			; $699e
	jr nc,_label_10_294	; $69a0
	ld l,$f1		; $69a2
	ld e,$cd		; $69a4
	ld a,(de)		; $69a6
	sub (hl)		; $69a7
	add $08			; $69a8
	cp $11			; $69aa
	jr nc,_label_10_294	; $69ac
	ld l,$c4		; $69ae
	inc (hl)		; $69b0
_label_10_294:
	call objectApplySpeed		; $69b1
	jp partAnimate		; $69b4
	ld a,$0b		; $69b7
	call objectGetRelatedObject2Var		; $69b9
	push hl			; $69bc
	ld b,(hl)		; $69bd
	ld l,$8d		; $69be
	ld c,(hl)		; $69c0
	call objectGetRelativeAngle		; $69c1
	ld e,$c9		; $69c4
	ld (de),a		; $69c6
	pop hl			; $69c7
	ld e,$cb		; $69c8
	ld a,(de)		; $69ca
	sub (hl)		; $69cb
	add $04			; $69cc
	cp $09			; $69ce
	jr nc,_label_10_294	; $69d0
	ld l,$8d		; $69d2
	ld e,$cd		; $69d4
	ld a,(de)		; $69d6
	sub (hl)		; $69d7
	add $04			; $69d8
	cp $09			; $69da
	jr nc,_label_10_294	; $69dc
	ld a,$18		; $69de
	call objectGetRelatedObject1Var		; $69e0
	xor a			; $69e3
	ldi (hl),a		; $69e4
	ld (hl),a		; $69e5
	jp partDelete		; $69e6

partCode39:
	ld e,$c4		; $69e9
	ld a,(de)		; $69eb
	or a			; $69ec
	jr nz,_label_10_295	; $69ed
	ld h,d			; $69ef
	ld l,e			; $69f0
	inc (hl)		; $69f1
	ld l,$cb		; $69f2
	ld a,(hl)		; $69f4
	sub $1a			; $69f5
	ld (hl),a		; $69f7
	ld l,$c6		; $69f8
	ld (hl),$20		; $69fa
	ld l,$d0		; $69fc
	ld (hl),$3c		; $69fe
	call objectSetVisible80		; $6a00
	ld a,$bf		; $6a03
	jp playSound		; $6a05
_label_10_295:
	ld e,$d7		; $6a08
	ld a,(de)		; $6a0a
	inc a			; $6a0b
	jp z,partDelete		; $6a0c
	call $6a28		; $6a0f
	ret nz			; $6a12
	call $407e		; $6a13
	jp z,partDelete		; $6a16
	ld a,(wFrameCounter)		; $6a19
	rrca			; $6a1c
	jr c,_label_10_296	; $6a1d
	ld e,$dc		; $6a1f
	ld a,(de)		; $6a21
	xor $07			; $6a22
	ld (de),a		; $6a24
_label_10_296:
	jp objectApplySpeed		; $6a25
	ld e,$c6		; $6a28
	ld a,(de)		; $6a2a
	or a			; $6a2b
	ret z			; $6a2c
	ld a,$1a		; $6a2d
	call objectGetRelatedObject1Var		; $6a2f
	bit 7,(hl)		; $6a32
	jp z,partDelete		; $6a34
	call partCommon_decCounter1IfNonzero		; $6a37
	dec a			; $6a3a
	ld b,$01		; $6a3b
	cp $17			; $6a3d
	jr z,_label_10_297	; $6a3f
	or a			; $6a41
	jp nz,partAnimate		; $6a42
	ld h,d			; $6a45
	ld l,$e4		; $6a46
	set 7,(hl)		; $6a48
	call objectGetAngleTowardEnemyTarget		; $6a4a
	ld e,$c9		; $6a4d
	ld (de),a		; $6a4f
	ld a,$be		; $6a50
	call playSound		; $6a52
	ld b,$02		; $6a55
_label_10_297:
	ld a,b			; $6a57
	call partSetAnimation		; $6a58
	or d			; $6a5b
	ret			; $6a5c

partCode3a:
	jr z,_label_10_298	; $6a5d
	ld e,$ea		; $6a5f
	ld a,(de)		; $6a61
	res 7,a			; $6a62
	cp $04			; $6a64
	jp c,partDelete		; $6a66
	jp $6bdd		; $6a69
_label_10_298:
	ld e,$c2		; $6a6c
	ld a,(de)		; $6a6e
	ld e,$c4		; $6a6f
	rst_jumpTable			; $6a71
	ld a,d			; $6a72
	ld l,d			; $6a73
	sbc c			; $6a74
	ld l,d			; $6a75
	call z,$906a		; $6a76
	ld l,e			; $6a79
	ld a,(de)		; $6a7a
	or a			; $6a7b
	jr z,_label_10_300	; $6a7c
_label_10_299:
	call $407e		; $6a7e
	jp z,partDelete		; $6a81
	call objectApplySpeed		; $6a84
	jp partAnimate		; $6a87
_label_10_300:
	call $6be3		; $6a8a
	call objectGetAngleTowardEnemyTarget		; $6a8d
	ld e,$c9		; $6a90
	ld (de),a		; $6a92
	call $6bf0		; $6a93
	jp objectSetVisible80		; $6a96
	ld a,(de)		; $6a99
	or a			; $6a9a
	jr nz,_label_10_299	; $6a9b
	call $6be3		; $6a9d
	call $6bc2		; $6aa0
	ld e,$c3		; $6aa3
	ld a,(de)		; $6aa5
	or a			; $6aa6
	ret nz			; $6aa7
	call objectGetAngleTowardEnemyTarget		; $6aa8
	ld e,$c9		; $6aab
	ld (de),a		; $6aad
	sub $02			; $6aae
	and $1f			; $6ab0
	ld b,a			; $6ab2
	ld e,$01		; $6ab3
	call getFreePartSlot		; $6ab5
	ld (hl),$3a		; $6ab8
	inc l			; $6aba
	ld (hl),e		; $6abb
	inc l			; $6abc
	inc (hl)		; $6abd
	ld l,$c9		; $6abe
	ld (hl),b		; $6ac0
	ld l,$d6		; $6ac1
	ld e,l			; $6ac3
	ld a,(de)		; $6ac4
	ldi (hl),a		; $6ac5
	inc e			; $6ac6
	ld a,(de)		; $6ac7
	ld (hl),a		; $6ac8
	jp objectCopyPosition		; $6ac9
	ld a,(de)		; $6acc
	rst_jumpTable			; $6acd
	sub $6a			; $6ace
	rla			; $6ad0
	ld l,e			; $6ad1
	ld e,c			; $6ad2
	ld l,e			; $6ad3
	ld a,(hl)		; $6ad4
	ld l,d			; $6ad5
	ld h,d			; $6ad6
	ld l,$db		; $6ad7
	ld a,$03		; $6ad9
	ldi (hl),a		; $6adb
	ld (hl),a		; $6adc
	ld l,$c3		; $6add
	ld a,(hl)		; $6adf
	or a			; $6ae0
	jr z,_label_10_301	; $6ae1
	ld l,e			; $6ae3
	ld (hl),$03		; $6ae4
	call $6bf0		; $6ae6
	ld a,$01		; $6ae9
	call partSetAnimation		; $6aeb
	jp objectSetVisible82		; $6aee
_label_10_301:
	call $6be3		; $6af1
	ld l,$f0		; $6af4
	ldh a,(<hEnemyTargetY)	; $6af6
	ldi (hl),a		; $6af8
	ldh a,(<hEnemyTargetX)	; $6af9
	ld (hl),a		; $6afb
	ld a,$29		; $6afc
	call objectGetRelatedObject1Var		; $6afe
	ld a,(hl)		; $6b01
	ld b,$19		; $6b02
	cp $10			; $6b04
	jr nc,_label_10_302	; $6b06
	ld b,$2d		; $6b08
	cp $0a			; $6b0a
	jr nc,_label_10_302	; $6b0c
	ld b,$41		; $6b0e
_label_10_302:
	ld e,$d0		; $6b10
	ld a,b			; $6b12
	ld (de),a		; $6b13
	jp objectSetVisible80		; $6b14
	ld h,d			; $6b17
	ld l,$f0		; $6b18
	ld b,(hl)		; $6b1a
	inc l			; $6b1b
	ld c,(hl)		; $6b1c
	ld l,$cb		; $6b1d
	ldi a,(hl)		; $6b1f
	ldh (<hFF8F),a	; $6b20
	inc l			; $6b22
	ld a,(hl)		; $6b23
	ldh (<hFF8E),a	; $6b24
	sub c			; $6b26
	add $02			; $6b27
	cp $05			; $6b29
	jr nc,_label_10_303	; $6b2b
	ldh a,(<hFF8F)	; $6b2d
	sub b			; $6b2f
	add $02			; $6b30
	cp $05			; $6b32
	jr nc,_label_10_303	; $6b34
	ld bc,$0502		; $6b36
	call objectCreateInteraction		; $6b39
	ret nz			; $6b3c
	ld e,$d8		; $6b3d
	ld a,$40		; $6b3f
	ld (de),a		; $6b41
	inc e			; $6b42
	ld a,h			; $6b43
	ld (de),a		; $6b44
	ld e,$c4		; $6b45
	ld a,$02		; $6b47
	ld (de),a		; $6b49
	jp objectSetInvisible		; $6b4a
_label_10_303:
	call objectGetRelativeAngleWithTempVars		; $6b4d
	ld e,$c9		; $6b50
	ld (de),a		; $6b52
	call objectApplySpeed		; $6b53
	jp partAnimate		; $6b56
	ld a,$21		; $6b59
	call objectGetRelatedObject2Var		; $6b5b
	bit 7,(hl)		; $6b5e
	ret z			; $6b60
	ld b,$05		; $6b61
	call checkBPartSlotsAvailable		; $6b63
	ret nz			; $6b66
	ld c,$05		; $6b67
_label_10_304:
	ld a,c			; $6b69
	dec a			; $6b6a
	ld hl,$6b8b		; $6b6b
	rst_addAToHl			; $6b6e
	ld b,(hl)		; $6b6f
	ld e,$02		; $6b70
	call $6ab5		; $6b72
	dec c			; $6b75
	jr nz,_label_10_304	; $6b76
	ld h,d			; $6b78
	ld l,$c4		; $6b79
	inc (hl)		; $6b7b
	ld l,$c9		; $6b7c
	ld (hl),$1d		; $6b7e
	call $6bf0		; $6b80
	ld a,$01		; $6b83
	call partSetAnimation		; $6b85
	jp objectSetVisible82		; $6b88
	inc bc			; $6b8b
	ld ($130d),sp		; $6b8c
	jr $1a			; $6b8f
	or a			; $6b91
	jr z,_label_10_306	; $6b92
	call partCommon_decCounter1IfNonzero		; $6b94
	jp z,$6bdd		; $6b97
	inc l			; $6b9a
	dec (hl)		; $6b9b
	jr nz,_label_10_305	; $6b9c
	ld (hl),$07		; $6b9e
	call objectGetAngleTowardEnemyTarget		; $6ba0
	call objectNudgeAngleTowards		; $6ba3
_label_10_305:
	call objectApplySpeed		; $6ba6
	jp partAnimate		; $6ba9
_label_10_306:
	call $6be3		; $6bac
	ld l,$c6		; $6baf
	ld (hl),$f0		; $6bb1
	inc l			; $6bb3
	ld (hl),$07		; $6bb4
	ld l,$db		; $6bb6
	ld a,$02		; $6bb8
	ldi (hl),a		; $6bba
	ld (hl),a		; $6bbb
	call objectGetAngleTowardEnemyTarget		; $6bbc
	ld e,$c9		; $6bbf
	ld (de),a		; $6bc1
	ld a,$29		; $6bc2
	call objectGetRelatedObject1Var		; $6bc4
	ld a,(hl)		; $6bc7
	ld b,$1e		; $6bc8
	cp $10			; $6bca
	jr nc,_label_10_307	; $6bcc
	ld b,$2d		; $6bce
	cp $0a			; $6bd0
	jr nc,_label_10_307	; $6bd2
	ld b,$3c		; $6bd4
_label_10_307:
	ld e,$d0		; $6bd6
	ld a,b			; $6bd8
	ld (de),a		; $6bd9
	jp objectSetVisible80		; $6bda
	call objectCreatePuff		; $6bdd
	jp partDelete		; $6be0
	ld h,d			; $6be3
	ld l,e			; $6be4
	inc (hl)		; $6be5
	ld l,$cf		; $6be6
	ld a,(hl)		; $6be8
	ld (hl),$00		; $6be9
	ld l,$cb		; $6beb
	add (hl)		; $6bed
	ld (hl),a		; $6bee
	ret			; $6bef
	ld a,$29		; $6bf0
	call objectGetRelatedObject1Var		; $6bf2
	ld a,(hl)		; $6bf5
	ld b,$3c		; $6bf6
	cp $10			; $6bf8
	jr nc,_label_10_308	; $6bfa
	ld b,$5a		; $6bfc
	cp $0a			; $6bfe
	jr nc,_label_10_308	; $6c00
	ld b,$78		; $6c02
_label_10_308:
	ld e,$d0		; $6c04
	ld a,b			; $6c06
	ld (de),a		; $6c07
	ret			; $6c08

partCode3b:
	ld e,$c4		; $6c09
	ld a,(de)		; $6c0b
	or a			; $6c0c
	jr nz,_label_10_309	; $6c0d
	inc a			; $6c0f
	ld (de),a		; $6c10
_label_10_309:
	ld a,$01		; $6c11
	call objectGetRelatedObject1Var		; $6c13
	ld a,(hl)		; $6c16
	cp $7e			; $6c17
	jp nz,partDelete		; $6c19
	ld l,$a4		; $6c1c
	ld a,(hl)		; $6c1e
	and $80			; $6c1f
	ld b,a			; $6c21
	ld e,$e4		; $6c22
	ld a,(de)		; $6c24
	and $7f			; $6c25
	or b			; $6c27
	ld (de),a		; $6c28
	ld l,$b7		; $6c29
	bit 2,(hl)		; $6c2b
	jr z,_label_10_310	; $6c2d
	res 7,a			; $6c2f
	ld (de),a		; $6c31
_label_10_310:
	ld l,$8b		; $6c32
	ld b,(hl)		; $6c34
	ld l,$8d		; $6c35
	ld c,(hl)		; $6c37
	ld l,$88		; $6c38
	ld a,(hl)		; $6c3a
	cp $04			; $6c3b
	jr c,_label_10_311	; $6c3d
	sub $04			; $6c3f
	add a			; $6c41
	inc a			; $6c42
_label_10_311:
	add a			; $6c43
	ld hl,$6c5b		; $6c44
	rst_addDoubleIndex			; $6c47
	ld e,$cb		; $6c48
	ldi a,(hl)		; $6c4a
	add b			; $6c4b
	ld (de),a		; $6c4c
	ld e,$cd		; $6c4d
	ldi a,(hl)		; $6c4f
	add c			; $6c50
	ld (de),a		; $6c51
	ld e,$e6		; $6c52
	ldi a,(hl)		; $6c54
	ld (de),a		; $6c55
	inc e			; $6c56
	ld a,(hl)		; $6c57
	ld (de),a		; $6c58
	xor a			; $6c59
	ret			; $6c5a
	ld hl,sp+$06		; $6c5b
	ld b,$02		; $6c5d
	ld (bc),a		; $6c5f
	inc c			; $6c60
	ld (bc),a		; $6c61
	ld b,$09		; $6c62
	ld a,($0206)		; $6c64
	ld (bc),a		; $6c67
.DB $f4				; $6c68
	ld (bc),a		; $6c69
	.db $06		; $6c6a

partCode3c:
	.db $1e		; $6c6b
	call nz,$b71a		; $6c6c
	jr z,_label_10_314	; $6c6f
	ld bc,$0104		; $6c71
	call partCommon_decCounter1IfNonzero		; $6c74
	jr z,_label_10_313	; $6c77
	ld a,(hl)		; $6c79
	cp $46			; $6c7a
	jr z,_label_10_312	; $6c7c
	ld bc,$0206		; $6c7e
	cp $28			; $6c81
	jp nz,partAnimate		; $6c83
_label_10_312:
	ld l,$e6		; $6c86
	ld (hl),c		; $6c88
	inc l			; $6c89
	ld (hl),c		; $6c8a
	ld a,b			; $6c8b
	jp partSetAnimation		; $6c8c
_label_10_313:
	pop hl			; $6c8f
	jp partDelete		; $6c90
_label_10_314:
	ld h,d			; $6c93
	ld l,e			; $6c94
	inc (hl)		; $6c95
	ld l,$c6		; $6c96
	ld (hl),$64		; $6c98
	jp objectSetVisible83		; $6c9a

partCode3d:
	ld e,$c4		; $6c9d
	ld a,(de)		; $6c9f
	rst_jumpTable			; $6ca0
	xor c			; $6ca1
	ld l,h			; $6ca2
.DB $d3				; $6ca3
	ld l,h			; $6ca4
	cp $6c			; $6ca5
	inc c			; $6ca7
	ld l,l			; $6ca8
	ld h,d			; $6ca9
	ld l,e			; $6caa
	inc (hl)		; $6cab
	ld e,$c2		; $6cac
	ld a,(de)		; $6cae
	or a			; $6caf
	jr nz,_label_10_315	; $6cb0
	ld l,$d4		; $6cb2
	ld a,$40		; $6cb4
	ldi (hl),a		; $6cb6
	ld (hl),$ff		; $6cb7
	ld l,$d0		; $6cb9
	ld (hl),$3c		; $6cbb
_label_10_315:
	inc e			; $6cbd
	ld a,(de)		; $6cbe
	or a			; $6cbf
	jr z,_label_10_316	; $6cc0
	ld l,$c4		; $6cc2
	inc (hl)		; $6cc4
	ld l,$e4		; $6cc5
	res 7,(hl)		; $6cc7
	ld l,$c6		; $6cc9
	ld (hl),$1e		; $6ccb
	call $6cf4		; $6ccd
_label_10_316:
	jp objectSetVisiblec1		; $6cd0
	call $407e		; $6cd3
	jp z,partDelete		; $6cd6
	call objectApplySpeed		; $6cd9
	ld c,$0e		; $6cdc
	call objectUpdateSpeedZ_paramC		; $6cde
	jr nz,_label_10_317	; $6ce1
	ld l,$c4		; $6ce3
	inc (hl)		; $6ce5
	ld l,$c6		; $6ce6
	ld (hl),$a0		; $6ce8
	ld l,$e6		; $6cea
	ld (hl),$05		; $6cec
	inc l			; $6cee
	ld (hl),$04		; $6cef
	call $6e13		; $6cf1
	ld a,$6f		; $6cf4
	call playSound		; $6cf6
	ld a,$01		; $6cf9
	jp partSetAnimation		; $6cfb
	call partCommon_decCounter1IfNonzero		; $6cfe
	jr nz,_label_10_317	; $6d01
	ld (hl),$14		; $6d03
	ld l,e			; $6d05
	inc (hl)		; $6d06
	ld a,$02		; $6d07
	jp partSetAnimation		; $6d09
	call partCommon_decCounter1IfNonzero		; $6d0c
	jp z,partDelete		; $6d0f
_label_10_317:
	jp partAnimate		; $6d12

partCode3e:
	jr z,_label_10_318	; $6d15
	ld e,$ea		; $6d17
	ld a,(de)		; $6d19
	cp $9a			; $6d1a
	jr nz,_label_10_318	; $6d1c
	ld h,d			; $6d1e
	ld l,$c2		; $6d1f
	ld (hl),$01		; $6d21
	ld l,$e4		; $6d23
	res 7,(hl)		; $6d25
	ld l,$c6		; $6d27
	ld (hl),$96		; $6d29
	ld l,$c4		; $6d2b
	ld a,$03		; $6d2d
	ld (hl),a		; $6d2f
	call partSetAnimation		; $6d30
_label_10_318:
	ld e,$c4		; $6d33
	ld a,(de)		; $6d35
	rst_jumpTable			; $6d36
	ld b,c			; $6d37
	ld l,l			; $6d38
	ld e,a			; $6d39
	ld l,l			; $6d3a
	sbc (hl)		; $6d3b
	ld l,l			; $6d3c
	sub $6d			; $6d3d
	push af			; $6d3f
	ld l,l			; $6d40
	ld h,d			; $6d41
	ld l,e			; $6d42
	inc (hl)		; $6d43
	ld l,$c3		; $6d44
	ld a,(hl)		; $6d46
	or a			; $6d47
	ld a,$1e		; $6d48
	jr nz,_label_10_321	; $6d4a
	ld l,$f0		; $6d4c
	ldh a,(<hEnemyTargetY)	; $6d4e
	ldi (hl),a		; $6d50
	ldh a,(<hEnemyTargetX)	; $6d51
	ld (hl),a		; $6d53
	ld l,$d0		; $6d54
	ld (hl),$50		; $6d56
	ld l,$ff		; $6d58
	set 5,(hl)		; $6d5a
	jp objectSetVisible83		; $6d5c
	ld h,d			; $6d5f
	ld l,$f0		; $6d60
	ld b,(hl)		; $6d62
	inc l			; $6d63
	ld c,(hl)		; $6d64
	ld l,$cb		; $6d65
	ldi a,(hl)		; $6d67
	ldh (<hFF8F),a	; $6d68
	inc l			; $6d6a
	ld a,(hl)		; $6d6b
	ldh (<hFF8E),a	; $6d6c
	sub c			; $6d6e
	inc a			; $6d6f
	cp $03			; $6d70
	jr nc,_label_10_319	; $6d72
	ldh a,(<hFF8F)	; $6d74
	sub b			; $6d76
	inc a			; $6d77
	cp $03			; $6d78
	jr c,_label_10_320	; $6d7a
_label_10_319:
	call objectGetRelativeAngleWithTempVars		; $6d7c
	ld e,$c9		; $6d7f
	ld (de),a		; $6d81
	jp objectApplySpeed		; $6d82
_label_10_320:
	ld a,$a0		; $6d85
_label_10_321:
	ld l,$c6		; $6d87
	ld (hl),a		; $6d89
	ld l,e			; $6d8a
	ld (hl),$03		; $6d8b
	ld l,$e4		; $6d8d
	set 7,(hl)		; $6d8f
	ld a,$ab		; $6d91
	call playSound		; $6d93
	ld a,$01		; $6d96
	call partSetAnimation		; $6d98
	jp objectSetVisible81		; $6d9b
	inc e			; $6d9e
	ld a,(de)		; $6d9f
	rst_jumpTable			; $6da0
	xor c			; $6da1
	ld l,l			; $6da2
	or d			; $6da3
	ld l,l			; $6da4
	cp h			; $6da5
	ld l,l			; $6da6
	call $af6d		; $6da7
	ld (wLinkGrabState2),a		; $6daa
	inc a			; $6dad
	ld (de),a		; $6dae
	jp objectSetVisible81		; $6daf
	call $6e70		; $6db2
	ret z			; $6db5
	call dropLinkHeldItem		; $6db6
	jp partDelete		; $6db9
	call $6e37		; $6dbc
	jp c,partDelete		; $6dbf
	ld e,$cf		; $6dc2
	ld a,(de)		; $6dc4
	or a			; $6dc5
	ret nz			; $6dc6
	ld e,$c5		; $6dc7
	ld a,$03		; $6dc9
	ld (de),a		; $6dcb
	ret			; $6dcc
	ld b,$09		; $6dcd
	call objectCreateInteractionWithSubid00		; $6dcf
	ret nz			; $6dd2
	jp partDelete		; $6dd3
	call $6e70		; $6dd6
	jp nz,partDelete		; $6dd9
	call partCommon_decCounter1IfNonzero		; $6ddc
	jr z,_label_10_322	; $6ddf
	ld e,$c2		; $6de1
	ld a,(de)		; $6de3
	or a			; $6de4
	jp nz,$6e6a		; $6de5
	call partAnimate		; $6de8
	jr _label_10_323		; $6deb
_label_10_322:
	ld l,$c4		; $6ded
	inc (hl)		; $6def
	ld a,$02		; $6df0
	jp partSetAnimation		; $6df2
	ld e,$e1		; $6df5
	ld a,(de)		; $6df7
	inc a			; $6df8
	jp z,partDelete		; $6df9
	call partAnimate		; $6dfc
_label_10_323:
	ld e,$e1		; $6dff
	ld a,(de)		; $6e01
	cp $ff			; $6e02
	ret z			; $6e04
	ld hl,$6e10		; $6e05
	rst_addAToHl			; $6e08
	ld e,$e6		; $6e09
	ld a,(hl)		; $6e0b
	ld (de),a		; $6e0c
	inc e			; $6e0d
	ld (de),a		; $6e0e
	ret			; $6e0f
	ld (bc),a		; $6e10
	inc b			; $6e11
	ld b,$1e		; $6e12
	jp nz,$fe1a		; $6e14
	inc bc			; $6e17
	ret nc			; $6e18
	call getFreePartSlot		; $6e19
	ret nz			; $6e1c
	ld (hl),$3d		; $6e1d
	inc l			; $6e1f
	ld e,l			; $6e20
	ld a,(de)		; $6e21
	inc a			; $6e22
	ld (hl),a		; $6e23
	ld l,$c9		; $6e24
	ld e,l			; $6e26
	ld a,(de)		; $6e27
	ld (hl),a		; $6e28
	ld l,$d0		; $6e29
	ld (hl),$3c		; $6e2b
	ld l,$d4		; $6e2d
	ld a,$c0		; $6e2f
	ldi (hl),a		; $6e31
	ld (hl),$ff		; $6e32
	jp objectCopyPosition		; $6e34
	ld a,$00		; $6e37
	call objectGetRelatedObject1Var		; $6e39
	call checkObjectsCollided		; $6e3c
	ret nc			; $6e3f
	ld l,$82		; $6e40
	ld a,(hl)		; $6e42
	or a			; $6e43
	ret nz			; $6e44
	ld l,$ab		; $6e45
	ld a,(hl)		; $6e47
	or a			; $6e48
	ret nz			; $6e49
	ld (hl),$3c		; $6e4a
	ld l,$b2		; $6e4c
	ld (hl),$1e		; $6e4e
	ld l,$a9		; $6e50
	ld a,(hl)		; $6e52
	sub $06			; $6e53
	ld (hl),a		; $6e55
	jr nc,_label_10_324	; $6e56
	ld (hl),$00		; $6e58
	ld l,$a4		; $6e5a
	res 7,(hl)		; $6e5c
_label_10_324:
	ld a,$63		; $6e5e
	call playSound		; $6e60
	ld a,$83		; $6e63
	call playSound		; $6e65
	scf			; $6e68
	ret			; $6e69
	call objectAddToGrabbableObjectBuffer		; $6e6a
	jp objectPushLinkAwayOnCollision		; $6e6d
	ld a,$01		; $6e70
	call objectGetRelatedObject1Var		; $6e72
	ld a,(hl)		; $6e75
	cp $77			; $6e76
	ret z			; $6e78
	call objectCreatePuff		; $6e79
	or d			; $6e7c
	ret			; $6e7d

partCode3f:
	jr z,_label_10_325	; $6e7e
	ld e,$c2		; $6e80
	ld a,(de)		; $6e82
	or a			; $6e83
	jr nz,_label_10_325	; $6e84
	ld e,$ea		; $6e86
	ld a,(de)		; $6e88
	cp $95			; $6e89
	jr nz,_label_10_325	; $6e8b
	ld h,d			; $6e8d
	call $6fce		; $6e8e
_label_10_325:
	ld e,$c2		; $6e91
	ld a,(de)		; $6e93
	ld e,$c4		; $6e94
	rst_jumpTable			; $6e96
	sbc e			; $6e97
	ld l,(hl)		; $6e98
	ld (hl),c		; $6e99
	ld l,a			; $6e9a
	ld a,(de)		; $6e9b
	rst_jumpTable			; $6e9c
	xor a			; $6e9d
	ld l,(hl)		; $6e9e
	call nz,$c56e		; $6e9f
	ld l,(hl)		; $6ea2
	ld a,(bc)		; $6ea3
	ld l,a			; $6ea4
	ld e,$6f		; $6ea5
	dec h			; $6ea7
	ld l,a			; $6ea8
	dec a			; $6ea9
	ld l,a			; $6eaa
	ld e,a			; $6eab
	ld l,a			; $6eac
	ld h,l			; $6ead
	ld l,a			; $6eae
	ld h,d			; $6eaf
	ld l,e			; $6eb0
	inc (hl)		; $6eb1
	ld l,$c9		; $6eb2
	ld (hl),$10		; $6eb4
	ld l,$d0		; $6eb6
	ld (hl),$32		; $6eb8
	ld l,$d4		; $6eba
	ld (hl),$00		; $6ebc
	inc l			; $6ebe
	ld (hl),$fe		; $6ebf
	jp objectSetVisiblec2		; $6ec1
	ret			; $6ec4
	inc e			; $6ec5
	ld a,(de)		; $6ec6
	rst_jumpTable			; $6ec7
	ret nc			; $6ec8
	ld l,(hl)		; $6ec9
	jp c,$e16e		; $6eca
	ld l,(hl)		; $6ecd
	nop			; $6ece
	ld l,a			; $6ecf
	ld a,$01		; $6ed0
	ld (de),a		; $6ed2
	xor a			; $6ed3
	ld (wLinkGrabState2),a		; $6ed4
	jp objectSetVisiblec1		; $6ed7
_label_10_326:
	call $6fb8		; $6eda
	ret nz			; $6edd
	jp dropLinkHeldItem		; $6ede
	ld e,$cb		; $6ee1
	ld a,(de)		; $6ee3
	cp $30			; $6ee4
	jr nc,_label_10_326	; $6ee6
	ld h,d			; $6ee8
	ld l,$cf		; $6ee9
	ld e,$c2		; $6eeb
	ld a,(de)		; $6eed
	or (hl)			; $6eee
	jr nz,_label_10_326	; $6eef
	ld hl,$dc15		; $6ef1
	sra (hl)		; $6ef4
	dec l			; $6ef6
	rr (hl)			; $6ef7
	ld l,$10		; $6ef9
	ld (hl),$0a		; $6efb
	jp $6fb8		; $6efd
	ld e,$c4		; $6f00
	ld a,$04		; $6f02
	ld (de),a		; $6f04
	call objectSetVisiblec2		; $6f05
	jr _label_10_328		; $6f08
	ld c,$20		; $6f0a
	call objectUpdateSpeedZAndBounce		; $6f0c
	jr c,_label_10_327	; $6f0f
	call z,$6f9b		; $6f11
	jp objectApplySpeed		; $6f14
_label_10_327:
	ld h,d			; $6f17
	ld l,$c4		; $6f18
	inc (hl)		; $6f1a
	call $6f9b		; $6f1b
_label_10_328:
	call $6fb8		; $6f1e
	ret z			; $6f21
	jp objectAddToGrabbableObjectBuffer		; $6f22
	ld h,d			; $6f25
	ld l,$e1		; $6f26
	ld a,(hl)		; $6f28
	inc a			; $6f29
	jp z,partDelete		; $6f2a
	dec a			; $6f2d
	jr z,_label_10_329	; $6f2e
	ld l,$e6		; $6f30
	ldi (hl),a		; $6f32
	ld (hl),a		; $6f33
	call $6fed		; $6f34
	call $7015		; $6f37
_label_10_329:
	jp partAnimate		; $6f3a
	ld bc,$fdc0		; $6f3d
	call objectSetSpeedZ		; $6f40
	ld l,e			; $6f43
	inc (hl)		; $6f44
	ld l,$d0		; $6f45
	ld (hl),$1e		; $6f47
	ld l,$c6		; $6f49
	ld (hl),$07		; $6f4b
	ld a,$0d		; $6f4d
	call objectGetRelatedObject1Var		; $6f4f
	ld a,(hl)		; $6f52
	cp $50			; $6f53
	ld a,$07		; $6f55
	jr c,_label_10_330	; $6f57
	ld a,$19		; $6f59
_label_10_330:
	ld e,$c9		; $6f5b
	ld (de),a		; $6f5d
	ret			; $6f5e
	call partCommon_decCounter1IfNonzero		; $6f5f
	ret nz			; $6f62
	ld l,e			; $6f63
	inc (hl)		; $6f64
	ld c,$20		; $6f65
	call objectUpdateSpeedZAndBounce		; $6f67
	jp nc,objectApplySpeed		; $6f6a
	ld h,d			; $6f6d
	jp $6fce		; $6f6e
	ld a,(de)		; $6f71
	rst_jumpTable			; $6f72
	ld a,c			; $6f73
	ld l,a			; $6f74
	adc d			; $6f75
	ld l,a			; $6f76
	and b			; $6f77
	ld l,a			; $6f78
	ld h,d			; $6f79
	ld l,e			; $6f7a
	inc (hl)		; $6f7b
	ld l,$d0		; $6f7c
	ld (hl),$28		; $6f7e
	ld l,$d4		; $6f80
	ld (hl),$20		; $6f82
	inc l			; $6f84
	ld (hl),$fe		; $6f85
	jp objectSetVisiblec2		; $6f87
	ld c,$20		; $6f8a
	call objectUpdateSpeedZAndBounce		; $6f8c
	jr c,_label_10_331	; $6f8f
	call z,$6f9b		; $6f91
	jp objectApplySpeed		; $6f94
_label_10_331:
	ld h,d			; $6f97
	ld l,$c4		; $6f98
	inc (hl)		; $6f9a
	ld a,$52		; $6f9b
	jp playSound		; $6f9d
	ld h,d			; $6fa0
	ld l,$e1		; $6fa1
	bit 0,(hl)		; $6fa3
	jp z,partAnimate		; $6fa5
	ld (hl),$00		; $6fa8
	ld l,$c7		; $6faa
	inc (hl)		; $6fac
	ld a,(hl)		; $6fad
	cp $04			; $6fae
	jp c,partAnimate		; $6fb0
	ld l,$c2		; $6fb3
	dec (hl)		; $6fb5
	jr _label_10_333		; $6fb6
	ld h,d			; $6fb8
	ld l,$e1		; $6fb9
	bit 0,(hl)		; $6fbb
	jr z,_label_10_332	; $6fbd
	ld (hl),$00		; $6fbf
	ld l,$c7		; $6fc1
	inc (hl)		; $6fc3
	ld a,(hl)		; $6fc4
	cp $08			; $6fc5
	jr nc,_label_10_333	; $6fc7
_label_10_332:
	jp partAnimate		; $6fc9
	or d			; $6fcc
	ret			; $6fcd
_label_10_333:
	ld l,$c4		; $6fce
	ld (hl),$05		; $6fd0
	ld l,$e4		; $6fd2
	res 7,(hl)		; $6fd4
	ld l,$db		; $6fd6
	ld a,$0a		; $6fd8
	ldi (hl),a		; $6fda
	ldi (hl),a		; $6fdb
	ld (hl),$0c		; $6fdc
	ld a,$01		; $6fde
	call partSetAnimation		; $6fe0
	call objectSetVisible82		; $6fe3
	ld a,$6f		; $6fe6
	call playSound		; $6fe8
	xor a			; $6feb
	ret			; $6fec
	ld e,$f0		; $6fed
	ld a,(de)		; $6fef
	or a			; $6ff0
	ret nz			; $6ff1
	call checkLinkVulnerable		; $6ff2
	ret nc			; $6ff5
	call objectCheckCollidedWithLink_ignoreZ		; $6ff6
	ret nc			; $6ff9
	call objectGetAngleTowardEnemyTarget		; $6ffa
	ld hl,$d02d		; $6ffd
	ld (hl),$10		; $7000
	dec l			; $7002
	ldd (hl),a		; $7003
	ld (hl),$14		; $7004
	dec l			; $7006
	ld (hl),$01		; $7007
	ld e,$e8		; $7009
	ld l,$25		; $700b
	ld a,(de)		; $700d
	ld (hl),a		; $700e
	ld e,$f0		; $700f
	ld a,$01		; $7011
	ld (de),a		; $7013
	ret			; $7014
	ld e,$d7		; $7015
	ld a,(de)		; $7017
	or a			; $7018
	ret z			; $7019
	ld a,$24		; $701a
	call objectGetRelatedObject1Var		; $701c
	bit 7,(hl)		; $701f
	ret z			; $7021
	ld l,$ab		; $7022
	ld a,(hl)		; $7024
	or a			; $7025
	ret nz			; $7026
	call checkObjectsCollided		; $7027
	ret nc			; $702a
	ld l,$aa		; $702b
	ld (hl),$97		; $702d
	ld l,$ab		; $702f
	ld (hl),$1e		; $7031
	ld l,$a9		; $7033
	dec (hl)		; $7035
	ret			; $7036

partCode40:
	jp nz,partDelete		; $7037
	ld e,$c4		; $703a
	ld a,(de)		; $703c
	rst_jumpTable			; $703d
	ld b,h			; $703e
	ld (hl),b		; $703f
	ld d,(hl)		; $7040
	ld (hl),b		; $7041
	ld l,d			; $7042
	ld (hl),b		; $7043
	ld h,d			; $7044
	ld l,e			; $7045
	inc (hl)		; $7046
	ld l,$c6		; $7047
	ld (hl),$28		; $7049
	ld l,$d0		; $704b
	ld (hl),$50		; $704d
	ld e,$c2		; $704f
	ld a,(de)		; $7051
	or a			; $7052
	jr z,_label_10_334	; $7053
	ret			; $7055
	call partCommon_decCounter1IfNonzero		; $7056
	ret nz			; $7059
	ld l,e			; $705a
	inc (hl)		; $705b
	ld a,$00		; $705c
	call objectGetRelatedObject1Var		; $705e
	ld bc,$f0f0		; $7061
	call objectTakePositionWithOffset		; $7064
	jp objectSetVisible80		; $7067
	call objectApplySpeed		; $706a
	call $407e		; $706d
	jp z,partDelete		; $7070
	ld a,(wFrameCounter)		; $7073
	xor d			; $7076
	rrca			; $7077
	ret nc			; $7078
	ld e,$dc		; $7079
	ld a,(de)		; $707b
	inc a			; $707c
	and $03			; $707d
	ld (de),a		; $707f
	ret			; $7080
_label_10_334:
	call objectGetAngleTowardEnemyTarget		; $7081
	ld e,$c9		; $7084
	ld (de),a		; $7086
	ld c,$03		; $7087
	call $708e		; $7089
	ld c,$fd		; $708c
	call getFreePartSlot		; $708e
	ret nz			; $7091
	ld (hl),$40		; $7092
	inc l			; $7094
	inc (hl)		; $7095
	call objectCopyPosition		; $7096
	ld l,$c9		; $7099
	ld e,l			; $709b
	ld a,(de)		; $709c
	add c			; $709d
	and $1f			; $709e
	ld (hl),a		; $70a0
	ld l,$d6		; $70a1
	ld e,l			; $70a3
	ld a,(de)		; $70a4
	ldi (hl),a		; $70a5
	ld e,l			; $70a6
	ld a,(de)		; $70a7
	ld (hl),a		; $70a8
	ret			; $70a9

partCode41:
	ld e,$c4		; $70aa
	ld a,(de)		; $70ac
	or a			; $70ad
	jr z,_label_10_335	; $70ae
	call objectApplySpeed		; $70b0
	call objectCheckWithinScreenBoundary		; $70b3
	jp nc,partDelete		; $70b6
	jp partAnimate		; $70b9
_label_10_335:
	ld h,d			; $70bc
	ld l,$c4		; $70bd
	inc (hl)		; $70bf
	ld l,$d0		; $70c0
	ld (hl),$78		; $70c2
	ld l,$cb		; $70c4
	ld a,$04		; $70c6
	add (hl)		; $70c8
	ld (hl),a		; $70c9
	ld l,$c9		; $70ca
	ld a,(hl)		; $70cc
	bit 3,a			; $70cd
	ld e,$cb		; $70cf
	jr z,_label_10_336	; $70d1
	ld e,$cd		; $70d3
_label_10_336:
	swap a			; $70d5
	rlca			; $70d7
	ld b,a			; $70d8
	ld hl,$70f3		; $70d9
	rst_addAToHl			; $70dc
	ld a,(de)		; $70dd
	add (hl)		; $70de
	ld (de),a		; $70df
	ld a,b			; $70e0
	call partSetAnimation		; $70e1
	ld a,$72		; $70e4
	call playSound		; $70e6
	ld e,$c9		; $70e9
	ld a,(de)		; $70eb
	or a			; $70ec
	jp z,objectSetVisible82		; $70ed
	jp objectSetVisible81		; $70f0
	xor $12			; $70f3
	stop			; $70f5
	.db $ee			; $70f6

partCode42:
	.db $28			; $70f7
	add hl,bc		; $70f8
	ld e,$ea		; $70f9
	ld a,(de)		; $70fb
	res 7,a			; $70fc
	cp $04			; $70fe
	jr c,_label_10_338	; $7100
	ld e,$c4		; $7102
	ld a,(de)		; $7104
	or a			; $7105
	jr z,_label_10_339	; $7106
	call $4072		; $7108
	jr z,_label_10_338	; $710b
	ld e,$c2		; $710d
	ld a,(de)		; $710f
	cp $02			; $7110
	jr z,_label_10_337	; $7112
	call partCommon_decCounter1IfNonzero		; $7114
	jr nz,_label_10_337	; $7117
	inc l			; $7119
	ld e,$f0		; $711a
	ld a,(de)		; $711c
	inc a			; $711d
	and $01			; $711e
	ld (de),a		; $7120
	add (hl)		; $7121
	ldd (hl),a		; $7122
	ld (hl),a		; $7123
	ld l,$c9		; $7124
	ld a,(hl)		; $7126
	add $02			; $7127
	and $1f			; $7129
	ld (hl),a		; $712b
_label_10_337:
	call objectApplySpeed		; $712c
	call partAnimate		; $712f
	ld e,$e1		; $7132
	ld a,(de)		; $7134
	inc a			; $7135
	ret nz			; $7136
_label_10_338:
	jp partDelete		; $7137
_label_10_339:
	call $7174		; $713a
	ret nz			; $713d
	call objectSetVisible82		; $713e
	ld h,d			; $7141
	ld l,$c4		; $7142
	inc (hl)		; $7144
	ld e,$c2		; $7145
	ld a,(de)		; $7147
	cp $02			; $7148
	jr nz,_label_10_340	; $714a
	ld l,$cf		; $714c
	ld a,(hl)		; $714e
	ld (hl),$00		; $714f
	ld l,$cb		; $7151
	add (hl)		; $7153
	ld (hl),a		; $7154
	ld l,$d0		; $7155
	ld (hl),$32		; $7157
	ret			; $7159
_label_10_340:
	ld l,$cf		; $715a
	ld a,(hl)		; $715c
	ld (hl),$fa		; $715d
	add $06			; $715f
	ld l,$cb		; $7161
	add (hl)		; $7163
	ld (hl),a		; $7164
	ld l,$d0		; $7165
	ld (hl),$78		; $7167
	ld l,$c6		; $7169
	ld a,$02		; $716b
	ldi (hl),a		; $716d
	ld (hl),a		; $716e
	ld a,$01		; $716f
	jp partSetAnimation		; $7171
	ld e,$c2		; $7174
	ld a,(de)		; $7176
	bit 7,a			; $7177
	jr z,_label_10_343	; $7179
	rrca			; $717b
	ld a,$04		; $717c
	ld bc,$0300		; $717e
	jr nc,_label_10_341	; $7181
	ld a,$03		; $7183
	ld bc,$0503		; $7185
_label_10_341:
	ld e,$c9		; $7188
	ld (de),a		; $718a
	ld e,$c2		; $718b
	xor a			; $718d
	ld (de),a		; $718e
	push bc			; $718f
	call checkBPartSlotsAvailable		; $7190
	pop bc			; $7193
	ret nz			; $7194
	ld a,b			; $7195
	ldh (<hFF8B),a	; $7196
	ld a,c			; $7198
	ld bc,$71fc		; $7199
	call addAToBc		; $719c
_label_10_342:
	push bc			; $719f
	call getFreePartSlot		; $71a0
	ld (hl),$42		; $71a3
	call objectCopyPosition		; $71a5
	pop bc			; $71a8
	ld l,$c9		; $71a9
	ld a,(bc)		; $71ab
	ld (hl),a		; $71ac
	inc bc			; $71ad
	ld hl,$ff8b		; $71ae
	dec (hl)		; $71b1
	jr nz,_label_10_342	; $71b2
	ret			; $71b4
_label_10_343:
	dec a			; $71b5
	jr z,_label_10_344	; $71b6
	xor a			; $71b8
	ret			; $71b9
_label_10_344:
	ld b,$05		; $71ba
	call checkBPartSlotsAvailable		; $71bc
	ret nz			; $71bf
	ld a,$09		; $71c0
	call objectGetRelatedObject1Var		; $71c2
	ld a,(hl)		; $71c5
	add $08			; $71c6
	and $1f			; $71c8
	ld b,a			; $71ca
	ld c,$02		; $71cb
	ld h,d			; $71cd
	ld l,$c9		; $71ce
	sub c			; $71d0
	and $1f			; $71d1
	ld (hl),a		; $71d3
	ld l,$c2		; $71d4
	ld (hl),c		; $71d6
	call $71e2		; $71d7
	ld a,b			; $71da
	add $0c			; $71db
	and $1f			; $71dd
	ld b,a			; $71df
	ld c,$03		; $71e0
_label_10_345:
	push bc			; $71e2
	call getFreePartSlot		; $71e3
	ld (hl),$42		; $71e6
	inc l			; $71e8
	ld (hl),$02		; $71e9
	call objectCopyPosition		; $71eb
	pop bc			; $71ee
	ld l,$c9		; $71ef
	ld (hl),b		; $71f1
	ld a,b			; $71f2
	add $02			; $71f3
	and $1f			; $71f5
	ld b,a			; $71f7
	dec c			; $71f8
	jr nz,_label_10_345	; $71f9
	ret			; $71fb
	inc c			; $71fc
	inc d			; $71fd
	inc e			; $71fe
	ld ($130d),sp		; $71ff
	jr _label_10_346		; $7202

partCode43:
	ld e,$c2		; $7204
	ld a,(de)		; $7206
	ld e,$c4		; $7207
	rst_jumpTable			; $7209
	inc d			; $720a
	ld (hl),d		; $720b
	ld l,a			; $720c
	ld (hl),d		; $720d
	xor (hl)		; $720e
	ld (hl),d		; $720f
	ld sp,hl		; $7210
	ld (hl),d		; $7211
	daa			; $7212
	ld (hl),e		; $7213
	ld a,(de)		; $7214
	or a			; $7215
	jr z,_label_10_348	; $7216
	call partAnimate		; $7218
	call partCommon_decCounter1IfNonzero		; $721b
	jp nz,objectApplyComponentSpeed		; $721e
_label_10_346:
	ld b,$06		; $7221
_label_10_347:
	ld a,b			; $7223
	dec a			; $7224
	ld hl,$7245		; $7225
	rst_addAToHl			; $7228
	ld c,(hl)		; $7229
	call $7236		; $722a
	dec b			; $722d
	jr nz,_label_10_347	; $722e
	call objectCreatePuff		; $7230
	jp partDelete		; $7233
	call getFreePartSlot		; $7236
	ret nz			; $7239
	ld (hl),$43		; $723a
	inc l			; $723c
	ld (hl),$03		; $723d
	ld l,$c9		; $723f
	ld (hl),c		; $7241
	jp objectCopyPosition		; $7242
	inc bc			; $7245
	ld ($130d),sp		; $7246
	jr $1d			; $7249
_label_10_348:
	ld h,d			; $724b
	ld l,e			; $724c
	inc (hl)		; $724d
	ld l,$dd		; $724e
	ld (hl),$06		; $7250
	dec l			; $7252
	ld a,$0a		; $7253
	ldd (hl),a		; $7255
	ld (hl),a		; $7256
	ld l,$cb		; $7257
	ld a,(hl)		; $7259
	add $06			; $725a
	ld (hl),a		; $725c
	ld l,$e6		; $725d
	ld a,$05		; $725f
	ldi (hl),a		; $7261
	ld (hl),a		; $7262
	ld l,$c6		; $7263
	ld (hl),$0c		; $7265
	ld l,$c9		; $7267
	ld (hl),$10		; $7269
	ld b,$50		; $726b
	jr _label_10_349		; $726d
	ld a,(de)		; $726f
	rst_jumpTable			; $7270
	ld (hl),a		; $7271
	ld (hl),d		; $7272
	adc h			; $7273
	ld (hl),d		; $7274
	and l			; $7275
	ld (hl),d		; $7276
	ld h,d			; $7277
	ld l,e			; $7278
	inc (hl)		; $7279
	ld l,$c6		; $727a
	ld (hl),$04		; $727c
	ld l,$e4		; $727e
	res 7,(hl)		; $7280
	ld l,$dd		; $7282
	ld (hl),$06		; $7284
	dec l			; $7286
	ld a,$0a		; $7287
	ldd (hl),a		; $7289
	ld (hl),a		; $728a
	ret			; $728b
	call partCommon_decCounter1IfNonzero		; $728c
	ret nz			; $728f
	ld (hl),$b4		; $7290
	ld l,e			; $7292
	inc (hl)		; $7293
	ld l,$e4		; $7294
	set 7,(hl)		; $7296
	ld b,$3c		; $7298
_label_10_349:
	call $733d		; $729a
	call objectSetVisible81		; $729d
	ld a,$72		; $72a0
	jp playSound		; $72a2
	call partCommon_decCounter1IfNonzero		; $72a5
	jp z,partDelete		; $72a8
	jp partAnimate		; $72ab
	ld a,(de)		; $72ae
	or a			; $72af
	jr z,_label_10_350	; $72b0
	call $407e		; $72b2
	jp z,partDelete		; $72b5
	call objectApplyComponentSpeed		; $72b8
	jp partAnimate		; $72bb
_label_10_350:
	ld b,$02		; $72be
	call checkBPartSlotsAvailable		; $72c0
	ret nz			; $72c3
	ld h,d			; $72c4
	ld l,$c4		; $72c5
	inc (hl)		; $72c7
	ld l,$dd		; $72c8
	ld (hl),$06		; $72ca
	dec l			; $72cc
	ld a,$0a		; $72cd
	ldd (hl),a		; $72cf
	ld (hl),a		; $72d0
	ld l,$c9		; $72d1
	ld (hl),$10		; $72d3
	ld l,$cb		; $72d5
	ld a,(hl)		; $72d7
	add $06			; $72d8
	ld (hl),a		; $72da
	ld b,$3c		; $72db
	call $729a		; $72dd
	ld bc,$0213		; $72e0
	call $72e9		; $72e3
	ld bc,$030d		; $72e6
	call getFreePartSlot		; $72e9
	ld (hl),$43		; $72ec
	inc l			; $72ee
	ld (hl),$04		; $72ef
	inc l			; $72f1
	ld (hl),b		; $72f2
	ld l,$c9		; $72f3
	ld (hl),c		; $72f5
	jp objectCopyPosition		; $72f6
	ld a,(de)		; $72f9
	or a			; $72fa
	jr z,_label_10_351	; $72fb
	call objectApplyComponentSpeed		; $72fd
	ld c,$12		; $7300
	call objectUpdateSpeedZ_paramC		; $7302
	jp nz,partAnimate		; $7305
	jp partDelete		; $7308
_label_10_351:
	ld bc,$ff20		; $730b
	call objectSetSpeedZ		; $730e
	ld l,e			; $7311
	inc (hl)		; $7312
	ld l,$e6		; $7313
	ld (hl),$05		; $7315
	inc l			; $7317
	ld (hl),$02		; $7318
	ld b,$3c		; $731a
	call $733d		; $731c
	call objectSetVisible82		; $731f
	ld a,$01		; $7322
	jp partSetAnimation		; $7324
	ld a,(de)		; $7327
	or a			; $7328
	jp nz,$72b2		; $7329
	ld h,d			; $732c
	ld l,e			; $732d
	inc (hl)		; $732e
	ld b,$3c		; $732f
	call $733d		; $7331
	call objectSetVisible82		; $7334
	ld e,$c3		; $7337
	ld a,(de)		; $7339
	jp partSetAnimation		; $733a
	ld e,$c9		; $733d
	ld a,(de)		; $733f
	ld c,a			; $7340
	call getPositionOffsetForVelocity		; $7341
	ld e,$d0		; $7344
	ldi a,(hl)		; $7346
	ld (de),a		; $7347
	inc e			; $7348
	ldi a,(hl)		; $7349
	ld (de),a		; $734a
	inc e			; $734b
	ldi a,(hl)		; $734c
	ld (de),a		; $734d
	inc e			; $734e
	ldi a,(hl)		; $734f
	ld (de),a		; $7350
	ret			; $7351

partCode44:
	jr z,_label_10_354	; $7352
	ld e,$ea		; $7354
	ld a,(de)		; $7356
	cp $83			; $7357
	jr z,_label_10_353	; $7359
	ld a,$01		; $735b
	call objectGetRelatedObject1Var		; $735d
	ld a,(hl)		; $7360
	cp $7f			; $7361
	jr nz,_label_10_352	; $7363
	ld l,$b6		; $7365
	ld (hl),$01		; $7367
_label_10_352:
	ld a,$13		; $7369
	ld ($cc6a),a		; $736b
	jr _label_10_356		; $736e
_label_10_353:
	ld e,$c4		; $7370
	ld a,$02		; $7372
	ld (de),a		; $7374
	ld e,$c9		; $7375
	ld a,(de)		; $7377
	xor $10			; $7378
	ld (de),a		; $737a
	call $73ae		; $737b
	call objectGetAngleTowardEnemyTarget		; $737e
	ld ($d02c),a		; $7381
	ld a,$18		; $7384
	ld ($d02d),a		; $7386
	ld a,$52		; $7389
	call playSound		; $738b
_label_10_354:
	call $407e		; $738e
	jr z,_label_10_356	; $7391
	ld e,$c4		; $7393
	ld a,(de)		; $7395
	rst_jumpTable			; $7396
	sbc l			; $7397
	ld (hl),e		; $7398
	or (hl)			; $7399
	ld (hl),e		; $739a
	cp h			; $739b
	ld (hl),e		; $739c
	ld a,$01		; $739d
	ld (de),a		; $739f
	call objectSetVisible82		; $73a0
	ld e,$c2		; $73a3
	ld a,(de)		; $73a5
	ld hl,$73de		; $73a6
	rst_addAToHl			; $73a9
	ld e,$c9		; $73aa
	ld a,(hl)		; $73ac
	ld (de),a		; $73ad
	ld c,a			; $73ae
	ld b,$46		; $73af
	ld a,$02		; $73b1
	jp objectSetComponentSpeedByScaledVelocity		; $73b3
_label_10_355:
	call objectApplyComponentSpeed		; $73b6
	jp partAnimate		; $73b9
	ld a,$00		; $73bc
	call objectGetRelatedObject1Var		; $73be
	call checkObjectsCollided		; $73c1
	jr nc,_label_10_355	; $73c4
	ld l,$ae		; $73c6
	ld (hl),$78		; $73c8
	dec l			; $73ca
	ld (hl),$18		; $73cb
	push hl			; $73cd
	call objectGetAngleTowardEnemyTarget		; $73ce
	pop hl			; $73d1
	dec l			; $73d2
	xor $10			; $73d3
	ld (hl),a		; $73d5
	ld a,$4e		; $73d6
	call playSound		; $73d8
_label_10_356:
	jp partDelete		; $73db
	ld (bc),a		; $73de
	inc b			; $73df
	ld b,$08		; $73e0
	ld a,(bc)		; $73e2
	inc c			; $73e3
	ld c,$10		; $73e4
	ld (de),a		; $73e6
	inc d			; $73e7
	ld d,$18		; $73e8
	ld a,(de)		; $73ea
	inc e			; $73eb
	ld e,$00		; $73ec

partCode45:
	jr z,_label_10_357	; $73ee
	dec a			; $73f0
	jr nz,_label_10_358	; $73f1
	ld e,$ea		; $73f3
	ld a,(de)		; $73f5
	cp $80			; $73f6
	jr nz,_label_10_358	; $73f8
_label_10_357:
	ld e,$c2		; $73fa
	ld a,(de)		; $73fc
	or a			; $73fd
	ld e,$c4		; $73fe
	ld a,(de)		; $7400
	jr z,_label_10_360	; $7401
	or a			; $7403
	jr z,_label_10_359	; $7404
	call objectCheckSimpleCollision		; $7406
	jp z,objectApplyComponentSpeed		; $7409
_label_10_358:
	jp partDelete		; $740c
_label_10_359:
	ld h,d			; $740f
	ld l,e			; $7410
	inc (hl)		; $7411
	ld l,$e4		; $7412
	set 7,(hl)		; $7414
	ld a,$0b		; $7416
	call objectGetRelatedObject1Var		; $7418
	ld bc,$0f00		; $741b
	call objectTakePositionWithOffset		; $741e
	xor a			; $7421
	ld (de),a		; $7422
	ld bc,$5010		; $7423
	ld a,$08		; $7426
	call objectSetComponentSpeedByScaledVelocity		; $7428
	jp objectSetVisible82		; $742b
_label_10_360:
	or a			; $742e
	jr nz,_label_10_361	; $742f
	inc a			; $7431
	ld (de),a		; $7432
_label_10_361:
	ld a,$29		; $7433
	call objectGetRelatedObject1Var		; $7435
	ld a,(hl)		; $7438
	or a			; $7439
	jr z,_label_10_358	; $743a
	ld l,$ae		; $743c
	ld a,(hl)		; $743e
	or a			; $743f
	ret nz			; $7440
	call getFreePartSlot		; $7441
	ret nz			; $7444
	ld (hl),$45		; $7445
	inc l			; $7447
	inc (hl)		; $7448
	ld l,$d6		; $7449
	ld e,l			; $744b
	ld a,(de)		; $744c
	ldi (hl),a		; $744d
	ld e,l			; $744e
	ld a,(de)		; $744f
	ld (hl),a		; $7450
	ret			; $7451

partCode46:
	jr nz,_label_10_363	; $7452
	ld e,$c2		; $7454
	ld a,(de)		; $7456
	or a			; $7457
	jr z,_label_10_362	; $7458
	ld e,$c4		; $745a
	ld a,(de)		; $745c
	rst_jumpTable			; $745d
	sub $74			; $745e
.DB $eb				; $7460
	ld (hl),h		; $7461
	ld a,($ff00+c)		; $7462
	ld (hl),h		; $7463
_label_10_362:
	ld a,$29		; $7464
	call objectGetRelatedObject1Var		; $7466
	ld a,(hl)		; $7469
	or a			; $746a
	jr z,_label_10_363	; $746b
	ld l,$84		; $746d
	ld a,(hl)		; $746f
	cp $0a			; $7470
	jr nz,_label_10_363	; $7472
	ld l,$ae		; $7474
	ld a,(hl)		; $7476
	or a			; $7477
	ret nz			; $7478
	ld e,$c4		; $7479
	ld a,(de)		; $747b
	rst_jumpTable			; $747c
	add a			; $747d
	ld (hl),h		; $747e
	adc (hl)		; $747f
	ld (hl),h		; $7480
	sub h			; $7481
	ld (hl),h		; $7482
	or (hl)			; $7483
	ld (hl),h		; $7484
	or (hl)			; $7485
	ld (hl),h		; $7486
	ld h,d			; $7487
	ld l,e			; $7488
	inc (hl)		; $7489
	ld l,$c6		; $748a
	ld (hl),$1e		; $748c
	call partCommon_decCounter1IfNonzero		; $748e
	ret nz			; $7491
	ld l,e			; $7492
	inc (hl)		; $7493
	ld b,$03		; $7494
	call $7517		; $7496
	ret nz			; $7499
	ld a,b			; $749a
	sub $08			; $749b
	and $1f			; $749d
	ld b,a			; $749f
	call $74fd		; $74a0
	call $74fd		; $74a3
	call $74fd		; $74a6
	ld a,$ba		; $74a9
	call playSound		; $74ab
	ld h,d			; $74ae
	ld l,$c4		; $74af
	inc (hl)		; $74b1
	ld l,$c6		; $74b2
	ld (hl),$1e		; $74b4
	call partCommon_decCounter1IfNonzero		; $74b6
	ret nz			; $74b9
	ld l,e			; $74ba
	inc (hl)		; $74bb
	ld b,$02		; $74bc
	call $7517		; $74be
	ret nz			; $74c1
	ld a,b			; $74c2
	sub $06			; $74c3
	and $1f			; $74c5
	ld b,a			; $74c7
	call $74fd		; $74c8
	call $74fd		; $74cb
	ld a,$ba		; $74ce
	call playSound		; $74d0
_label_10_363:
	jp partDelete		; $74d3
	ld h,d			; $74d6
	ld l,e			; $74d7
	inc (hl)		; $74d8
	ld l,$e4		; $74d9
	set 7,(hl)		; $74db
	ld l,$d0		; $74dd
	ld (hl),$64		; $74df
	ld l,$c6		; $74e1
	ld (hl),$08		; $74e3
	call $7524		; $74e5
	call objectSetVisible82		; $74e8
	call partCommon_decCounter1IfNonzero		; $74eb
	jr nz,_label_10_364	; $74ee
	ld l,e			; $74f0
	inc (hl)		; $74f1
	call objectCheckSimpleCollision		; $74f2
	jr nz,_label_10_363	; $74f5
_label_10_364:
	call objectApplySpeed		; $74f7
	jp partAnimate		; $74fa
	call getFreePartSlot		; $74fd
	ret nz			; $7500
	ld (hl),$46		; $7501
	inc l			; $7503
	inc (hl)		; $7504
	ld l,$c9		; $7505
	ld a,b			; $7507
	add $04			; $7508
	and $1f			; $750a
	ld (hl),a		; $750c
	ld b,a			; $750d
	ld l,$d6		; $750e
	ld e,l			; $7510
	ld a,(de)		; $7511
	ldi (hl),a		; $7512
	ld e,l			; $7513
	ld a,(de)		; $7514
	ld (hl),a		; $7515
	ret			; $7516
	call checkBPartSlotsAvailable		; $7517
	ret nz			; $751a
	call $7524		; $751b
	call objectGetAngleTowardEnemyTarget		; $751e
	ld b,a			; $7521
	xor a			; $7522
	ret			; $7523
	ld a,$0b		; $7524
	call objectGetRelatedObject1Var		; $7526
	ld bc,$0a00		; $7529
	call objectTakePositionWithOffset		; $752c
	xor a			; $752f
	ld (de),a		; $7530
	ret			; $7531

partCode47:
	ld e,$c2		; $7532
	ld a,(de)		; $7534
	ld e,$c4		; $7535
	rst_jumpTable			; $7537
	ld b,d			; $7538
	ld (hl),l		; $7539
	ld a,b			; $753a
	ld (hl),l		; $753b
	rst $38			; $753c
	halt			; $753d
	dec l			; $753e
	ld (hl),a		; $753f
	ld b,a			; $7540
	ld (hl),a		; $7541
	ld b,$04		; $7542
	call checkBPartSlotsAvailable		; $7544
	ret nz			; $7547
	ld b,$04		; $7548
	ld e,$d7		; $754a
	ld a,(de)		; $754c
	ld c,a			; $754d
	call $7566		; $754e
	ld (hl),$80		; $7551
	ld c,h			; $7553
	dec b			; $7554
_label_10_365:
	call $7566		; $7555
	ld (hl),$c0		; $7558
	dec b			; $755a
	jr nz,_label_10_365	; $755b
	ld a,$19		; $755d
	call objectGetRelatedObject1Var		; $755f
	ld (hl),c		; $7562
	jp partDelete		; $7563
	call getFreePartSlot		; $7566
	ld (hl),$47		; $7569
	inc l			; $756b
	ld a,$05		; $756c
	sub b			; $756e
	ld (hl),a		; $756f
	call objectCopyPosition		; $7570
	ld l,$d7		; $7573
	ld (hl),c		; $7575
	dec l			; $7576
	ret			; $7577
	ld b,$02		; $7578
	call $777f		; $757a
	ld l,$a9		; $757d
	ld a,(hl)		; $757f
	or a			; $7580
	ld e,$c4		; $7581
	jr z,_label_10_366	; $7583
	ld a,(de)		; $7585
	rst_jumpTable			; $7586
	xor c			; $7587
	ld (hl),l		; $7588
	dec e			; $7589
	halt			; $758a
	ldd (hl),a		; $758b
	halt			; $758c
	ccf			; $758d
	halt			; $758e
	halt			; $758f
	halt			; $7590
	adc h			; $7591
	halt			; $7592
	cp h			; $7593
	halt			; $7594
	rst_jumpTable			; $7595
	halt			; $7596
	ld a,($ff00+$76)	; $7597
_label_10_366:
	ld a,(de)		; $7599
	cp $08			; $759a
	ret z			; $759c
	ld h,d			; $759d
	ld l,$e4		; $759e
	res 7,(hl)		; $75a0
	ld l,$da		; $75a2
	ld a,(hl)		; $75a4
	xor $80			; $75a5
	ld (hl),a		; $75a7
	ret			; $75a8
	inc e			; $75a9
	ld a,(de)		; $75aa
	rst_jumpTable			; $75ab
	or (hl)			; $75ac
	ld (hl),l		; $75ad
	ret c			; $75ae
	ld (hl),l		; $75af
.DB $fd				; $75b0
	ld (hl),l		; $75b1
	dec bc			; $75b2
	halt			; $75b3
	inc e			; $75b4
	halt			; $75b5
	ld h,d			; $75b6
	ld l,e			; $75b7
	inc (hl)		; $75b8
	ld l,$d4		; $75b9
	ld a,$20		; $75bb
	ldi (hl),a		; $75bd
	ld (hl),$ff		; $75be
	ld l,$c9		; $75c0
	ld (hl),$10		; $75c2
	ld l,$d0		; $75c4
	ld (hl),$78		; $75c6
	ld l,$cb		; $75c8
	ld a,$18		; $75ca
	ldi (hl),a		; $75cc
	inc l			; $75cd
	ld (hl),$78		; $75ce
	ld l,$f0		; $75d0
	ldi (hl),a		; $75d2
	ld (hl),$78		; $75d3
	jp objectSetVisible82		; $75d5
	ld c,$0e		; $75d8
	call objectUpdateSpeedZ_paramC		; $75da
	jr z,_label_10_367	; $75dd
	call objectApplySpeed		; $75df
	ld e,$cb		; $75e2
	ld a,(de)		; $75e4
	sub $18			; $75e5
	ld e,$f3		; $75e7
	ld (de),a		; $75e9
	ret			; $75ea
_label_10_367:
	ld l,$c5		; $75eb
	inc (hl)		; $75ed
	inc l			; $75ee
	ld a,$3c		; $75ef
	ld (hl),a		; $75f1
	call setScreenShakeCounter		; $75f2
	ld a,$6f		; $75f5
	call playSound		; $75f7
	jp $776f		; $75fa
	call partCommon_decCounter1IfNonzero		; $75fd
	ret nz			; $7600
	ld l,e			; $7601
	inc (hl)		; $7602
	ld l,$d0		; $7603
	ld a,$80		; $7605
	ldi (hl),a		; $7607
	ld (hl),$ff		; $7608
	ret			; $760a
	call objectApplyComponentSpeed		; $760b
	ld e,$cb		; $760e
	ld a,(de)		; $7610
	cp $18			; $7611
	ret nc			; $7613
	ld e,$c5		; $7614
	ld a,$04		; $7616
	ld (de),a		; $7618
	jp objectSetInvisible		; $7619
	ret			; $761c
	ld h,d			; $761d
	ld l,e			; $761e
	inc (hl)		; $761f
	ld l,$e4		; $7620
	set 7,(hl)		; $7622
	ld l,$c9		; $7624
	ld (hl),$12		; $7626
	ld l,$d4		; $7628
	ld a,$00		; $762a
	ldi (hl),a		; $762c
	ld (hl),$fe		; $762d
	call objectSetVisible82		; $762f
	ld h,d			; $7632
	ld l,$c9		; $7633
	ld a,(hl)		; $7635
	cp $1e			; $7636
	jr nz,_label_10_368	; $7638
	ld l,e			; $763a
	inc (hl)		; $763b
	call objectSetVisible81		; $763c
_label_10_368:
	ld a,(wFrameCounter)		; $763f
	and $0f			; $7642
	ld a,$a4		; $7644
	call z,playSound		; $7646
	ld e,$c9		; $7649
	ld a,(de)		; $764b
	inc a			; $764c
	and $1f			; $764d
	ld (de),a		; $764f
	and $0f			; $7650
	ld hl,$775f		; $7652
	rst_addAToHl			; $7655
	ld e,$f3		; $7656
	ld a,(hl)		; $7658
	ld (de),a		; $7659
	ld bc,$e605		; $765a
_label_10_369:
	ld a,$0b		; $765d
	call objectGetRelatedObject1Var		; $765f
	ldi a,(hl)		; $7662
	add b			; $7663
	ld b,a			; $7664
	ld e,$f0		; $7665
	ld (de),a		; $7667
	inc l			; $7668
	ld a,(hl)		; $7669
	add c			; $766a
	ld c,a			; $766b
	inc e			; $766c
	ld (de),a		; $766d
	ld e,$f3		; $766e
	ld a,(de)		; $7670
	ld e,$c9		; $7671
	jp objectSetPositionInCircleArc		; $7673
	ld a,(wFrameCounter)		; $7676
	and $07			; $7679
	ld a,$a4		; $767b
	call z,playSound		; $767d
	ld e,$c9		; $7680
	ld a,(de)		; $7682
	inc a			; $7683
	and $1f			; $7684
	ld (de),a		; $7686
	ld bc,$e009		; $7687
	jr _label_10_369		; $768a
	call partCommon_decCounter1IfNonzero		; $768c
	jr nz,_label_10_370	; $768f
	ld (hl),$02		; $7691
	ld l,$c9		; $7693
	inc (hl)		; $7695
	ld a,(hl)		; $7696
	cp $15			; $7697
	jr z,_label_10_371	; $7699
	ld c,a			; $769b
	ld b,$5a		; $769c
	ld a,$03		; $769e
	call objectSetComponentSpeedByScaledVelocity		; $76a0
_label_10_370:
	jp objectApplyComponentSpeed		; $76a3
_label_10_371:
	ld l,e			; $76a6
	inc (hl)		; $76a7
	ld l,$c6		; $76a8
	ld a,$3c		; $76aa
	ld (hl),a		; $76ac
	ld l,$e8		; $76ad
	ld (hl),$fc		; $76af
	call setScreenShakeCounter		; $76b1
	call $776f		; $76b4
	ld a,$6f		; $76b7
	jp playSound		; $76b9
	call partCommon_decCounter1IfNonzero		; $76bc
	ret nz			; $76bf
	ld l,e			; $76c0
	inc (hl)		; $76c1
	ld l,$d0		; $76c2
	ld (hl),$1e		; $76c4
	ret			; $76c6
	ld h,d			; $76c7
	ld l,$f0		; $76c8
	ld b,(hl)		; $76ca
	inc l			; $76cb
	ld c,(hl)		; $76cc
	ld l,$cb		; $76cd
	ldi a,(hl)		; $76cf
	ldh (<hFF8F),a	; $76d0
	inc l			; $76d2
	ld a,(hl)		; $76d3
	ldh (<hFF8E),a	; $76d4
	cp c			; $76d6
	jr nz,_label_10_372	; $76d7
	ldh a,(<hFF8F)	; $76d9
	cp b			; $76db
	jr nz,_label_10_372	; $76dc
	ld l,e			; $76de
	inc (hl)		; $76df
	ld l,$e4		; $76e0
	res 7,(hl)		; $76e2
	jp objectSetInvisible		; $76e4
_label_10_372:
	call objectGetRelativeAngleWithTempVars		; $76e7
	ld e,$c9		; $76ea
	ld (de),a		; $76ec
	jp objectApplySpeed		; $76ed
	ld a,$04		; $76f0
	call objectGetRelatedObject1Var		; $76f2
	ld a,(hl)		; $76f5
	cp $0a			; $76f6
	ret nz			; $76f8
	ld e,$c4		; $76f9
	ld a,$01		; $76fb
	ld (de),a		; $76fd
	ret			; $76fe
	ld a,(de)		; $76ff
	or a			; $7700
	jr z,_label_10_374	; $7701
	ld b,$47		; $7703
	call $777f		; $7705
	call $778b		; $7708
	ld a,e			; $770b
	add a			; $770c
	add e			; $770d
	add b			; $770e
	ld e,$cb		; $770f
	ld (de),a		; $7711
	ld a,l			; $7712
	add a			; $7713
	add l			; $7714
	add c			; $7715
	ld e,$cd		; $7716
	ld (de),a		; $7718
_label_10_373:
	ld a,$1a		; $7719
	call objectGetRelatedObject1Var		; $771b
	bit 7,(hl)		; $771e
	jp nz,objectSetVisible82		; $7720
	jp objectSetInvisible		; $7723
_label_10_374:
	inc a			; $7726
	ld (de),a		; $7727
	call partSetAnimation		; $7728
	jr _label_10_373		; $772b
	ld a,(de)		; $772d
	or a			; $772e
	jr z,_label_10_374	; $772f
	ld b,$47		; $7731
	call $777f		; $7733
	call $778b		; $7736
	ld a,e			; $7739
	add a			; $773a
	add b			; $773b
	ld e,$cb		; $773c
	ld (de),a		; $773e
	ld a,l			; $773f
	add a			; $7740
	add c			; $7741
	ld e,$cd		; $7742
	ld (de),a		; $7744
	jr _label_10_373		; $7745
	ld a,(de)		; $7747
	or a			; $7748
	jr z,_label_10_374	; $7749
	ld b,$47		; $774b
	call $777f		; $774d
	call $778b		; $7750
	ld a,e			; $7753
	add b			; $7754
	ld e,$cb		; $7755
	ld (de),a		; $7757
	ld a,l			; $7758
	add c			; $7759
	ld e,$cd		; $775a
	ld (de),a		; $775c
	jr _label_10_373		; $775d
	stop			; $775f
	ld de,$1412		; $7760
	ld d,$1a		; $7763
	ld e,$22		; $7765
	jr z,_label_10_375	; $7767
	ld e,$1a		; $7769
	ld d,$14		; $776b
	ld (de),a		; $776d
	ld de,$a7cd		; $776e
	ld a,$c0		; $7771
	ld (hl),$48		; $7773
	inc l			; $7775
	ld (hl),$02		; $7776
	ld l,$d6		; $7778
	ld a,$c0		; $777a
	ldi (hl),a		; $777c
	ld (hl),d		; $777d
	ret			; $777e
	ld a,$01		; $777f
	call objectGetRelatedObject1Var		; $7781
	ld a,(hl)		; $7784
	cp b			; $7785
	ret z			; $7786
	pop hl			; $7787
	jp partDelete		; $7788
_label_10_375:
	ld a,$30		; $778b
	call objectGetRelatedObject1Var		; $778d
	ld b,(hl)		; $7790
	inc l			; $7791
	ld c,(hl)		; $7792
	ld l,$cb		; $7793
	ldi a,(hl)		; $7795
	sub b			; $7796
	sra a			; $7797
	sra a			; $7799
	ld e,a			; $779b
	inc l			; $779c
	ld a,(hl)		; $779d
	sub c			; $779e
	sra a			; $779f
	sra a			; $77a1
	ld l,a			; $77a3
	ret			; $77a4

partCode48:
	ld e,$c2		; $77a5
	ld a,(de)		; $77a7
	ld e,$c4		; $77a8
	rst_jumpTable			; $77aa
	or a			; $77ab
	ld (hl),a		; $77ac
	sub $77			; $77ad
	ld d,c			; $77af
	ld a,b			; $77b0
	ld (hl),l		; $77b1
	ld a,b			; $77b2
	pop bc			; $77b3
	ld a,b			; $77b4
	pop hl			; $77b5
	ld a,b			; $77b6
	ld a,(de)		; $77b7
	or a			; $77b8
	jr z,_label_10_376	; $77b9
	call partCommon_decCounter1IfNonzero		; $77bb
	jp z,partDelete		; $77be
	ld a,(hl)		; $77c1
	and $0f			; $77c2
	ret nz			; $77c4
	call getFreePartSlot		; $77c5
	ret nz			; $77c8
	ld (hl),$48		; $77c9
	inc l			; $77cb
	inc (hl)		; $77cc
	ret			; $77cd
_label_10_376:
	ld h,d			; $77ce
	ld l,e			; $77cf
	inc (hl)		; $77d0
	ld l,$c6		; $77d1
	ld (hl),$96		; $77d3
	ret			; $77d5
	ld a,(de)		; $77d6
	rst_jumpTable			; $77d7
	sbc $77			; $77d8
	ld c,$78		; $77da
	ld sp,$6278		; $77dc
	ld l,e			; $77df
	inc (hl)		; $77e0
	ld l,$e4		; $77e1
	set 7,(hl)		; $77e3
	ldh a,(<hCameraY)	; $77e5
	ld b,a			; $77e7
	ldh a,(<hCameraX)	; $77e8
	ld c,a			; $77ea
	call getRandomNumber		; $77eb
	ld e,a			; $77ee
	and $07			; $77ef
	swap a			; $77f1
	add $28			; $77f3
	add c			; $77f5
	ld l,$cd		; $77f6
	ld (hl),a		; $77f8
	ld a,e			; $77f9
	and $70			; $77fa
	add $08			; $77fc
	ld e,a			; $77fe
	add b			; $77ff
	ld l,$cb		; $7800
	ld (hl),a		; $7802
	ld a,e			; $7803
	cpl			; $7804
	inc a			; $7805
	sub $07			; $7806
	ld l,$cf		; $7808
	ld (hl),a		; $780a
	jp objectSetVisiblec1		; $780b
	ld c,$20		; $780e
	call objectUpdateSpeedZ_paramC		; $7810
	jr nz,_label_10_377	; $7813
	call objectReplaceWithAnimationIfOnHazard		; $7815
	jp c,partDelete		; $7818
	ld h,d			; $781b
	ld l,$c4		; $781c
	inc (hl)		; $781e
	ld l,$db		; $781f
	ld a,$0b		; $7821
	ldi (hl),a		; $7823
	ldi (hl),a		; $7824
	ld (hl),$02		; $7825
	ld a,$a5		; $7827
	call playSound		; $7829
	ld a,$01		; $782c
	call partSetAnimation		; $782e
	ld e,$e1		; $7831
	ld a,(de)		; $7833
	bit 7,a			; $7834
	jp nz,partDelete		; $7836
	ld hl,$7847		; $7839
	rst_addAToHl			; $783c
	ld e,$e6		; $783d
	ldi a,(hl)		; $783f
	ld (de),a		; $7840
	inc e			; $7841
	ld a,(hl)		; $7842
	ld (de),a		; $7843
_label_10_377:
	jp partAnimate		; $7844
	inc b			; $7847
	add hl,bc		; $7848
	ld b,$0b		; $7849
	add hl,bc		; $784b
	inc c			; $784c
	ld a,(bc)		; $784d
	dec c			; $784e
	dec bc			; $784f
	ld c,$06		; $7850
	ld b,$cd		; $7852
	or b			; $7854
	jr nz,-$40		; $7855
	ld a,$00		; $7857
	call objectGetRelatedObject1Var		; $7859
	call objectTakePosition		; $785c
	ld b,$06		; $785f
_label_10_378:
	call getFreePartSlot		; $7861
	ld (hl),$48		; $7864
	inc l			; $7866
	ld (hl),$03		; $7867
	ld l,$c9		; $7869
	ld (hl),b		; $786b
	call objectCopyPosition		; $786c
	dec b			; $786f
	jr nz,_label_10_378	; $7870
	jp partDelete		; $7872
	ld a,(de)		; $7875
	or a			; $7876
	jr z,_label_10_379	; $7877
	ld c,$18		; $7879
	call objectUpdateSpeedZ_paramC		; $787b
	jp z,partDelete		; $787e
	jp objectApplySpeed		; $7881
_label_10_379:
	ld h,d			; $7884
	ld l,e			; $7885
	inc (hl)		; $7886
	ld l,$e4		; $7887
	set 7,(hl)		; $7889
	ld l,$db		; $788b
	ld a,$0b		; $788d
	ldi (hl),a		; $788f
	ldi (hl),a		; $7890
	ld a,$02		; $7891
	ld (hl),a		; $7893
	ld l,$e6		; $7894
	ldi (hl),a		; $7896
	ld (hl),a		; $7897
	ld l,$e8		; $7898
	ld (hl),$fc		; $789a
	ld l,$d0		; $789c
	ld (hl),$50		; $789e
	ld l,$d4		; $78a0
	ld a,$20		; $78a2
	ldi (hl),a		; $78a4
	ld (hl),$ff		; $78a5
	ld l,$c9		; $78a7
	ld a,(hl)		; $78a9
	dec a			; $78aa
	ld bc,$78bb		; $78ab
	call addAToBc		; $78ae
	ld a,(bc)		; $78b1
	ld (hl),a		; $78b2
	ld a,$02		; $78b3
	call partSetAnimation		; $78b5
	jp objectSetVisible82		; $78b8
	inc b			; $78bb
	ld ($160d),sp		; $78bc
	ld a,(de)		; $78bf
	ld e,$1a		; $78c0
	or a			; $78c2
	jr z,_label_10_380	; $78c3
	call partCommon_decCounter1IfNonzero		; $78c5
	jp z,partDelete		; $78c8
	ld a,(hl)		; $78cb
	and $0f			; $78cc
	ret nz			; $78ce
	call getFreePartSlot		; $78cf
	ret nz			; $78d2
	ld (hl),$48		; $78d3
	inc l			; $78d5
	ld (hl),$05		; $78d6
	ret			; $78d8
_label_10_380:
	ld h,d			; $78d9
	ld l,e			; $78da
	inc (hl)		; $78db
	ld l,$c6		; $78dc
	ld (hl),$61		; $78de
	ret			; $78e0
	ld a,(de)		; $78e1
	rst_jumpTable			; $78e2
	jp hl			; $78e3
	ld a,b			; $78e4
	ld bc,$2d79		; $78e5
	ld a,c			; $78e8
	ld h,d			; $78e9
	ld l,e			; $78ea
	inc (hl)		; $78eb
	ld l,$cb		; $78ec
	ld (hl),$28		; $78ee
	call getRandomNumber_noPreserveVars		; $78f0
	and $7f			; $78f3
	cp $40			; $78f5
	jr c,_label_10_381	; $78f7
	add $20			; $78f9
_label_10_381:
	ld e,$cd		; $78fb
	ld (de),a		; $78fd
	jp objectSetVisible82		; $78fe
	ld h,d			; $7901
	ld l,$d4		; $7902
	ld e,$ca		; $7904
	call add16BitRefs		; $7906
	cp $a0			; $7909
	jr nc,_label_10_382	; $790b
	dec l			; $790d
	ld a,(hl)		; $790e
	add $10			; $790f
	ldi (hl),a		; $7911
	ld a,(hl)		; $7912
	adc $00			; $7913
	ld (hl),a		; $7915
	ret			; $7916
_label_10_382:
	ld h,d			; $7917
	ld l,$c4		; $7918
	inc (hl)		; $791a
	ld l,$db		; $791b
	ld a,$0b		; $791d
	ldi (hl),a		; $791f
	ldi (hl),a		; $7920
	ld (hl),$02		; $7921
	ld a,$a5		; $7923
	call playSound		; $7925
	ld a,$01		; $7928
	call partSetAnimation		; $792a
	ld e,$e1		; $792d
	ld a,(de)		; $792f
	bit 7,a			; $7930
	jp nz,partDelete		; $7932
	jp partAnimate		; $7935

partCode49:
	ld e,$c4		; $7938
	ld a,(de)		; $793a
	rst_jumpTable			; $793b
	ld b,d			; $793c
	ld a,c			; $793d
	ld d,c			; $793e
	ld a,c			; $793f
	ld h,e			; $7940
	ld a,c			; $7941
	ld h,d			; $7942
	ld l,$c4		; $7943
	inc (hl)		; $7945
	ld l,$d0		; $7946
	ld (hl),$6e		; $7948
	ld l,$c6		; $794a
	ld (hl),$3c		; $794c
	jp objectSetVisible81		; $794e
	call partCommon_decCounter1IfNonzero		; $7951
	jr nz,_label_10_383	; $7954
	ld l,e			; $7956
	inc (hl)		; $7957
	ld a,$d3		; $7958
	call playSound		; $795a
	call objectGetAngleTowardEnemyTarget		; $795d
	ld e,$c9		; $7960
	ld (de),a		; $7962
	call $407e		; $7963
	jp z,partDelete		; $7966
	call objectApplySpeed		; $7969
_label_10_383:
	jp partAnimate		; $796c

partCode4a:
	jp nz,partDelete		; $796f
	ld e,$c4		; $7972
	ld a,(de)		; $7974
	rst_jumpTable			; $7975
	ld a,h			; $7976
	ld a,c			; $7977
	adc h			; $7978
	ld a,c			; $7979
	sbc (hl)		; $797a
	ld a,c			; $797b
	ld h,d			; $797c
	ld l,e			; $797d
	inc (hl)		; $797e
	ld l,$d0		; $797f
	ld (hl),$5a		; $7981
	ld l,$e6		; $7983
	ld a,$04		; $7985
	ldi (hl),a		; $7987
	ld (hl),a		; $7988
	jp objectSetVisible81		; $7989
	call $79ab		; $798c
	ld e,$cb		; $798f
	ld a,(de)		; $7991
	cp $88			; $7992
	jr c,_label_10_384	; $7994
	ld e,$c4		; $7996
	ld a,$02		; $7998
	ld (de),a		; $799a
_label_10_384:
	jp partAnimate		; $799b
	call objectApplySpeed		; $799e
	ld e,$cb		; $79a1
	ld a,(de)		; $79a3
	cp $b8			; $79a4
	jr c,_label_10_384	; $79a6
	jp partDelete		; $79a8
	ld e,$f1		; $79ab
	ld a,(de)		; $79ad
	ld c,a			; $79ae
	ld b,$9a		; $79af
	call objectGetRelativeAngle		; $79b1
	ld e,$c9		; $79b4
	ld (de),a		; $79b6
	jp objectApplySpeed		; $79b7

partCode4f:
	jr z,_label_10_386	; $79ba
	ld e,$c4		; $79bc
	ld a,(de)		; $79be
	cp $06			; $79bf
	jr nc,_label_10_386	; $79c1
	ld e,$ea		; $79c3
	ld a,(de)		; $79c5
	res 7,a			; $79c6
	cp $04			; $79c8
	jr c,_label_10_386	; $79ca
	cp $0c			; $79cc
	jp z,$7bc2		; $79ce
	cp $20			; $79d1
	jr nz,_label_10_385	; $79d3
	ld a,$24		; $79d5
	call objectGetRelatedObject2Var		; $79d7
	res 7,(hl)		; $79da
	ld e,$f3		; $79dc
	ld a,$01		; $79de
	ld (de),a		; $79e0
_label_10_385:
	ld h,d			; $79e1
	ld l,$e9		; $79e2
	ld (hl),$40		; $79e4
	ld l,$f2		; $79e6
	ld (hl),$3c		; $79e8
_label_10_386:
	ld e,$c2		; $79ea
	ld a,(de)		; $79ec
	ld e,$c4		; $79ed
	rst_jumpTable			; $79ef
.DB $f4				; $79f0
	ld a,c			; $79f1
	and h			; $79f2
	ld a,e			; $79f3
	ld h,d			; $79f4
	ld l,$f2		; $79f5
	ld a,(hl)		; $79f7
	or a			; $79f8
	jr z,_label_10_387	; $79f9
	dec (hl)		; $79fb
	jr nz,_label_10_387	; $79fc
	ld l,$e4		; $79fe
	set 7,(hl)		; $7a00
_label_10_387:
	ld a,(de)		; $7a02
	rst_jumpTable			; $7a03
	inc d			; $7a04
	ld a,d			; $7a05
	ld a,$7a		; $7a06
	and d			; $7a08
	ld a,d			; $7a09
	and e			; $7a0a
	ld a,d			; $7a0b
	cp c			; $7a0c
	ld a,d			; $7a0d
	dec e			; $7a0e
	ld a,e			; $7a0f
	ld (hl),$7b		; $7a10
	ld l,c			; $7a12
	ld a,e			; $7a13
	call getFreePartSlot		; $7a14
	ret nz			; $7a17
	ld (hl),$07		; $7a18
	inc l			; $7a1a
	ld (hl),$00		; $7a1b
	inc l			; $7a1d
	ld (hl),$08		; $7a1e
	ld l,$d6		; $7a20
	ld a,$c0		; $7a22
	ldi (hl),a		; $7a24
	ld (hl),d		; $7a25
	ld a,$0f		; $7a26
	ld ($cc6a),a		; $7a28
	ld h,d			; $7a2b
	ld l,$c4		; $7a2c
	inc (hl)		; $7a2e
	ld l,$cb		; $7a2f
	ld (hl),$50		; $7a31
	ld l,$cd		; $7a33
	ld (hl),$78		; $7a35
	ld l,$cf		; $7a37
	ld (hl),$fc		; $7a39
	jp objectSetVisible82		; $7a3b
	inc e			; $7a3e
	ld a,(de)		; $7a3f
	rst_jumpTable			; $7a40
	ld b,a			; $7a41
	ld a,d			; $7a42
	ld d,a			; $7a43
	ld a,d			; $7a44
	add d			; $7a45
	ld a,d			; $7a46
	ld a,($d00b)		; $7a47
	cp $78			; $7a4a
	jp nc,partAnimate		; $7a4c
	ld a,$01		; $7a4f
	ld (de),a		; $7a51
	ld a,$8d		; $7a52
	call playSound		; $7a54
	ld b,$04		; $7a57
	call checkBPartSlotsAvailable		; $7a59
	ret nz			; $7a5c
	ld bc,$0404		; $7a5d
_label_10_388:
	call getFreePartSlot		; $7a60
	ld (hl),$4f		; $7a63
	inc l			; $7a65
	inc (hl)		; $7a66
	ld l,$c9		; $7a67
	ld (hl),c		; $7a69
	call objectCopyPosition		; $7a6a
	ld a,c			; $7a6d
	add $08			; $7a6e
	ld c,a			; $7a70
	dec b			; $7a71
	jr nz,_label_10_388	; $7a72
	ld h,d			; $7a74
	ld l,$c5		; $7a75
	inc (hl)		; $7a77
	inc l			; $7a78
	ld (hl),$5a		; $7a79
	ld l,$cf		; $7a7b
	ld (hl),$00		; $7a7d
	jp objectSetInvisible		; $7a7f
	call partCommon_decCounter1IfNonzero		; $7a82
	ret nz			; $7a85
	call getFreeEnemySlot		; $7a86
	ret nz			; $7a89
	ld (hl),$02		; $7a8a
	ld e,$d8		; $7a8c
	ld a,$80		; $7a8e
	ld (de),a		; $7a90
	inc e			; $7a91
	ld a,h			; $7a92
	ld (de),a		; $7a93
	ld l,$96		; $7a94
	ld a,$c0		; $7a96
	ldi (hl),a		; $7a98
	ld (hl),d		; $7a99
	ld h,d			; $7a9a
	ld l,$c4		; $7a9b
	inc (hl)		; $7a9d
	inc l			; $7a9e
	ld (hl),$00		; $7a9f
	ret			; $7aa1
	ret			; $7aa2
	ld h,d			; $7aa3
	ld l,$cf		; $7aa4
	inc (hl)		; $7aa6
	ld a,(hl)		; $7aa7
	cp $fc			; $7aa8
	jr c,_label_10_389	; $7aaa
	ld l,e			; $7aac
	inc (hl)		; $7aad
	ld l,$e4		; $7aae
	set 7,(hl)		; $7ab0
	ld l,$d0		; $7ab2
	ld (hl),$14		; $7ab4
_label_10_389:
	jp partAnimate		; $7ab6
	ld a,$01		; $7ab9
	call objectGetRelatedObject2Var		; $7abb
	ld a,(hl)		; $7abe
	cp $02			; $7abf
	jr nz,_label_10_392	; $7ac1
	call $7bd6		; $7ac3
	ld l,$8b		; $7ac6
	ldi a,(hl)		; $7ac8
	srl a			; $7ac9
	ld b,a			; $7acb
	ld a,($d00b)		; $7acc
	srl a			; $7acf
	add b			; $7ad1
	ld b,a			; $7ad2
	inc l			; $7ad3
	ld a,(hl)		; $7ad4
	srl a			; $7ad5
	ld c,a			; $7ad7
	ld a,($d00d)		; $7ad8
	srl a			; $7adb
	add c			; $7add
	ld c,a			; $7ade
	ld e,$cd		; $7adf
	ld a,(de)		; $7ae1
	ldh (<hFF8E),a	; $7ae2
	ld e,$cb		; $7ae4
	ld a,(de)		; $7ae6
	ldh (<hFF8F),a	; $7ae7
	sub b			; $7ae9
	add $04			; $7aea
	cp $09			; $7aec
	jr nc,_label_10_390	; $7aee
	ldh a,(<hFF8E)	; $7af0
	sub c			; $7af2
	add $04			; $7af3
	cp $09			; $7af5
	jr c,_label_10_389	; $7af7
	ld a,(wFrameCounter)		; $7af9
	and $1f			; $7afc
	jr nz,_label_10_391	; $7afe
_label_10_390:
	call objectGetRelativeAngleWithTempVars		; $7b00
	ld e,$c9		; $7b03
	ld (de),a		; $7b05
_label_10_391:
	call objectApplySpeed		; $7b06
	jr _label_10_389		; $7b09
_label_10_392:
	ld h,d			; $7b0b
	ld l,$c4		; $7b0c
	ld e,l			; $7b0e
	ld (hl),$06		; $7b0f
	inc l			; $7b11
	ld (hl),$00		; $7b12
	ld l,$f2		; $7b14
	ld (hl),$00		; $7b16
	ld l,$e4		; $7b18
	res 7,(hl)		; $7b1a
	ret			; $7b1c
	call $7bd6		; $7b1d
	call partCommon_decCounter1IfNonzero		; $7b20
	jr z,_label_10_393	; $7b23
	call objectCheckTileCollision_allowHoles		; $7b25
	call nc,objectApplySpeed		; $7b28
	jr _label_10_389		; $7b2b
_label_10_393:
	ld l,$c4		; $7b2d
	dec (hl)		; $7b2f
	ld l,$d0		; $7b30
	ld (hl),$14		; $7b32
	jr _label_10_389		; $7b34
	inc e			; $7b36
	ld a,(de)		; $7b37
	rst_jumpTable			; $7b38
	ld b,c			; $7b39
	ld a,e			; $7b3a
	ld c,e			; $7b3b
	ld a,e			; $7b3c
	ld d,a			; $7b3d
	ld a,d			; $7b3e
	ld e,l			; $7b3f
	ld a,e			; $7b40
	ld h,d			; $7b41
	ld l,e			; $7b42
	inc (hl)		; $7b43
	ld l,$e6		; $7b44
	ld a,$10		; $7b46
	ldi (hl),a		; $7b48
	ld (hl),a		; $7b49
	ret			; $7b4a
	call objectCheckCollidedWithLink		; $7b4b
	jr nc,_label_10_394	; $7b4e
	ld e,$c5		; $7b50
	ld a,$02		; $7b52
	ld (de),a		; $7b54
	ld a,$8d		; $7b55
	call playSound		; $7b57
_label_10_394:
	jp partAnimate		; $7b5a
	ld h,d			; $7b5d
	ld l,$c4		; $7b5e
	inc (hl)		; $7b60
	ld l,$c6		; $7b61
	ld a,$3c		; $7b63
	ld (hl),a		; $7b65
	call setScreenShakeCounter		; $7b66
	call partCommon_decCounter1IfNonzero		; $7b69
	ret nz			; $7b6c
	ld a,$0f		; $7b6d
	ld (hl),a		; $7b6f
	call setScreenShakeCounter		; $7b70
_label_10_395:
	call getRandomNumber_noPreserveVars		; $7b73
	and $0f			; $7b76
	cp $0d			; $7b78
	jr nc,_label_10_395	; $7b7a
	inc a			; $7b7c
	ld c,a			; $7b7d
	push bc			; $7b7e
_label_10_396:
	call getRandomNumber_noPreserveVars		; $7b7f
	and $0f			; $7b82
	cp $09			; $7b84
	jr nc,_label_10_396	; $7b86
	pop bc			; $7b88
	inc a			; $7b89
	swap a			; $7b8a
	or c			; $7b8c
	ld c,a			; $7b8d
	ld b,$ce		; $7b8e
	ld a,(bc)		; $7b90
	or a			; $7b91
	jr nz,_label_10_395	; $7b92
	ld a,$48		; $7b94
	call breakCrackedFloor		; $7b96
	ld e,$c7		; $7b99
	ld a,(de)		; $7b9b
	inc a			; $7b9c
	cp $75			; $7b9d
	jp z,partDelete		; $7b9f
	ld (de),a		; $7ba2
	ret			; $7ba3
	ld a,(de)		; $7ba4
	or a			; $7ba5
	jr nz,_label_10_397	; $7ba6
	ld h,d			; $7ba8
	ld l,e			; $7ba9
	inc (hl)		; $7baa
	ld l,$c6		; $7bab
	ld (hl),$5a		; $7bad
	ld l,$d0		; $7baf
	ld (hl),$0f		; $7bb1
_label_10_397:
	call partCommon_decCounter1IfNonzero		; $7bb3
	jp z,partDelete		; $7bb6
	ld l,$da		; $7bb9
	ld a,(hl)		; $7bbb
	xor $80			; $7bbc
	ld (hl),a		; $7bbe
	jp objectApplySpeed		; $7bbf
	ld h,d			; $7bc2
	ld l,$c6		; $7bc3
	ld (hl),$78		; $7bc5
	ld l,$ec		; $7bc7
	ld a,(hl)		; $7bc9
	ld l,$c9		; $7bca
	ld (hl),a		; $7bcc
	ld l,$c4		; $7bcd
	ld (hl),$05		; $7bcf
	ld l,$d0		; $7bd1
	ld (hl),$50		; $7bd3
	ret			; $7bd5
	ld e,$f3		; $7bd6
	ld a,(de)		; $7bd8
	or a			; $7bd9
	ret z			; $7bda
	ld a,($ccf2)		; $7bdb
	or a			; $7bde
	ret nz			; $7bdf
	ld (de),a		; $7be0
	ld a,$29		; $7be1
	call objectGetRelatedObject2Var		; $7be3
	ld a,(hl)		; $7be6
	or a			; $7be7
	ret z			; $7be8
	ld l,$a4		; $7be9
	set 7,(hl)		; $7beb
	ret			; $7bed
