 m_section_force serialCode NAMESPACE serialCode

;;
; @addr{4000}
func_4000:
	ldh a,(<hSerialInterruptBehaviour)	; $4000
	or a			; $4002
	ret z			; $4003
	ld a,($ff00+R_SVBK)	; $4004
	push af			; $4006
	ld a,$04		; $4007
	ld ($ff00+R_SVBK),a	; $4009
	push de			; $400b
	call $4036		; $400c
	pop de			; $400f
	ld a,($ff00+R_SC)	; $4010
	rlca			; $4012
	jr c,_label_16_001	; $4013
	ldh a,(<hSerialInterruptBehaviour)	; $4015
	cp $e0			; $4017
	jr z,_label_16_000	; $4019
	ld a,($d98b)		; $401b
	or a			; $401e
	jr nz,_label_16_001	; $401f
	ld a,($d983)		; $4021
	xor $01			; $4024
	ld ($d983),a		; $4026
	jr z,_label_16_001	; $4029
	ldh a,(<hSerialInterruptBehaviour)	; $402b
_label_16_000:
	and $81			; $402d
	call writeToSC		; $402f
_label_16_001:
	pop af			; $4032
	ld ($ff00+R_SVBK),a	; $4033
	ret			; $4035
	ldh a,(<hFFBE)	; $4036
	rst_jumpTable			; $4038
.dw $420d
.dw $420d
.dw $421e
.dw $4143
.dw $410e
	call $41dc		; $4043
	cp $80			; $4046
	ret z			; $4048
	ld a,($d981)		; $4049
	ld hl,$d9e5		; $404c
	rst_addAToHl			; $404f
	ld a,($d981)		; $4050
	or a			; $4053
	jr nz,_label_16_003	; $4054
	ld a,(hl)		; $4056
	or a			; $4057
	jr nz,_label_16_002	; $4058
	inc a			; $405a
	ld ($d98b),a		; $405b
	ret			; $405e
_label_16_002:
	ld ($d987),a		; $405f
	xor a			; $4062
	ld ($d982),a		; $4063
_label_16_003:
	inc a			; $4066
	ld ($d981),a		; $4067
	ld a,($d987)		; $406a
	dec a			; $406d
	ld ($d987),a		; $406e
	ldi a,(hl)		; $4071
	jr nz,_label_16_004	; $4072
	xor a			; $4074
	ld ($d988),a		; $4075
	ld a,($d982)		; $4078
_label_16_004:
	ld ($ff00+R_SB),a	; $407b
	ld hl,$d982		; $407d
	add (hl)		; $4080
	ld (hl),a		; $4081
	xor a			; $4082
	ld ($d98b),a		; $4083
	ret			; $4086
	ldh a,(<hSerialRead)	; $4087
	or a			; $4089
	ret z			; $408a
	ld a,$01		; $408b
	ld ($d98b),a		; $408d
	xor a			; $4090
	ld ($ff00+R_SB),a	; $4091
	ldh (<hSerialRead),a	; $4093
	ret			; $4095
	call $41dc		; $4096
	cp $80			; $4099
	jp z,serialFunc_0c7e		; $409b
	jp $4269		; $409e
	call $41dc		; $40a1
	jp serialFunc_0c7e		; $40a4
	xor a			; $40a7
	ld ($d98b),a		; $40a8
	call $41dc		; $40ab
	cp $80			; $40ae
	ret z			; $40b0
	ld a,($d981)		; $40b1
	ld b,a			; $40b4
	or a			; $40b5
	jr nz,_label_16_007	; $40b6
	ldh a,(<hSerialByte)	; $40b8
	cp $ff			; $40ba
	jr z,_label_16_005	; $40bc
	or a			; $40be
	jr nz,_label_16_006	; $40bf
_label_16_005:
	ld a,($d985)		; $40c1
	or a			; $40c4
	ret nz			; $40c5
	ld hl,$d984		; $40c6
	inc (hl)		; $40c9
	ret nz			; $40ca
	ld a,$86		; $40cb
	ldh (<hFFBD),a	; $40cd
	xor a			; $40cf
	ld ($d988),a		; $40d0
	ret			; $40d3
_label_16_006:
	ld ($d987),a		; $40d4
_label_16_007:
	ld hl,$d987		; $40d7
	dec (hl)		; $40da
	jr nz,_label_16_009	; $40db
	ldh a,(<hSerialByte)	; $40dd
	ld hl,$d982		; $40df
	cp (hl)			; $40e2
	jr z,_label_16_008	; $40e3
	ld a,$81		; $40e5
	ldh (<hFFBD),a	; $40e7
_label_16_008:
	xor a			; $40e9
	ld ($d988),a		; $40ea
	ld ($d984),a		; $40ed
	ld ($ff00+R_SB),a	; $40f0
	ret			; $40f2
_label_16_009:
	ld a,b			; $40f3
	ld de,$d9e5		; $40f4
	call addAToDe		; $40f7
	ld a,b			; $40fa
	inc a			; $40fb
	ld ($d981),a		; $40fc
	ldh a,(<hSerialByte)	; $40ff
	ld (de),a		; $4101
	ld hl,$d982		; $4102
	add (hl)		; $4105
	ld (hl),a		; $4106
	xor a			; $4107
	ld ($ff00+R_SB),a	; $4108
	ld ($d984),a		; $410a
	ret			; $410d
	ldh a,(<hFFBF)	; $410e
	rst_jumpTable			; $4110
.dw $440d
.dw $4280
.dw $4411
.dw $4280
.dw $4415
.dw $4280
.dw $438e
.dw $4087
.dw $42ee
.dw $4305
.dw $438e
.dw $4370
.dw $43c5
.dw $4305
.dw $438e
.dw $4329
.dw $4280
.dw $4096
.dw $434d
.dw $4280
.dw $438e
.dw $43f5
.dw $4280
.dw $4096
.dw $437b
	ldh a,(<hFFBF)	; $4143
	rst_jumpTable			; $4145
.dw $4176
.dw $4280
.dw $438e
.dw $4179
.dw $4280
.dw $438e
.dw $417d
.dw $4280
.dw $438e
.dw $43f5
.dw $4280
.dw $42a7
.dw $4280
.dw $40a1
.dw $4280
.dw $4096
.dw $42de
.dw $4280
.dw $438e
.dw $430e
.dw $43f5
.dw $4280
.dw $438e
.dw $437b
	xor a			; $4176
	jr _label_16_010		; $4177
	ld a,$01		; $4179
	jr _label_16_010		; $417b
	ld a,$02		; $417d
_label_16_010:
	ldh (<hActiveFileSlot),a	; $417f
	call loadFile		; $4181
	ldh (<hFF8B),a	; $4184
	call $4269		; $4186
	ld hl,$d9e5		; $4189
	ld a,$21		; $418c
	ldi (hl),a		; $418e
	ld c,a			; $418f
	ldh a,(<hFF8B)	; $4190
	ldi (hl),a		; $4192
	ldi (hl),a		; $4193
	add a			; $4194
	add c			; $4195
	ld c,a			; $4196
	ld a,(wLinkMaxHealth)		; $4197
	ldi (hl),a		; $419a
	ldi (hl),a		; $419b
	add a			; $419c
	add c			; $419d
	ld c,a			; $419e
	ld a,(wDeathCounter)		; $419f
	ldi (hl),a		; $41a2
	add c			; $41a3
	ld c,a			; $41a4
	ld a,(wDeathCounter+1)		; $41a5
	ldi (hl),a		; $41a8
	add c			; $41a9
	ld c,a			; $41aa
	ld a,(wFileIsLinkedGame)		; $41ab
	ldi (hl),a		; $41ae
	add c			; $41af
	ld c,a			; $41b0
	ld a,(wFileIsHeroGame)		; $41b1
	add a			; $41b4
	ld e,a			; $41b5
	ld a,($c614)		; $41b6
	or e			; $41b9
	ldi (hl),a		; $41ba
	add c			; $41bb
	ld c,a			; $41bc
	ld de,wGameID		; $41bd
	ld b,$16		; $41c0
_label_16_011:
	ld a,(de)		; $41c2
	ldi (hl),a		; $41c3
	add c			; $41c4
	ld c,a			; $41c5
	inc e			; $41c6
	dec b			; $41c7
	jr nz,_label_16_011	; $41c8
.ifdef ROM_AGES
	ld a,$a1		; $41ca
.else
	ld a,$a0		; $41ca
.endif
	ldi (hl),a		; $41cc
	add c			; $41cd
	ld c,a			; $41ce
	ldh a,(<hActiveFileSlot)	; $41cf
	ld (hl),a		; $41d1
	add c			; $41d2
	ldi (hl),a		; $41d3
	ld a,$01		; $41d4
	ld ($d988),a		; $41d6
	jp $4049		; $41d9
	ldh a,(<hSerialRead)	; $41dc
	or a			; $41de
	jr nz,_label_16_014	; $41df
	ld a,($d985)		; $41e1
	or a			; $41e4
	jr nz,_label_16_012	; $41e5
	ld hl,$d989		; $41e7
	call decHlRef16WithCap		; $41ea
	jr z,_label_16_013	; $41ed
_label_16_012:
	pop af			; $41ef
	ret			; $41f0
_label_16_013:
	xor a			; $41f1
	ld ($d988),a		; $41f2
	ld a,$80		; $41f5
	ldh (<hFFBD),a	; $41f7
	ret			; $41f9
_label_16_014:
	ld ($d988),a		; $41fa
	xor a			; $41fd
	ldh (<hSerialRead),a	; $41fe
	ldh (<hFFBD),a	; $4200
_label_16_015:
	ld a,$b4		; $4202
	ld ($d989),a		; $4204
	ld a,$00		; $4207
	ld ($d98a),a		; $4209
	ret			; $420c
	ldh a,(<hFFBF)	; $420d
	rst_jumpTable			; $420f
.dw $4186
.dw $4280
.dw $438e
.dw $4293
.dw $4280
.dw $4096
.dw $422f
	ldh a,(<hFFBF)	; $421e
	rst_jumpTable			; $4220
.dw $4293
.dw $4280
.dw $4096
.dw $4186
.dw $4280
.dw $438e
.dw $422f
	call serialFunc_0c7e		; $422f
	xor a			; $4232
	ldh (<hFFBD),a	; $4233
	call $44ec		; $4235
	jr z,_label_16_017	; $4238
	ld hl,wGameID		; $423a
	ld a,(w4RingFortuneStuff)		; $423d
	add (hl)		; $4240
	and $7f			; $4241
	ld b,$00		; $4243
	and $7c			; $4245
	jr z,_label_16_016	; $4247
	inc b			; $4249
	and $60			; $424a
	jr z,_label_16_016	; $424c
	inc b			; $424e
_label_16_016:
	inc l			; $424f
	ld c,(hl)		; $4250
	ld a,b			; $4251
	ld hl,$4503		; $4252
	rst_addAToHl			; $4255
	ld a,(hl)		; $4256
	rst_addAToHl			; $4257
	ld a,($d98e)		; $4258
	add c			; $425b
	and $07			; $425c
	rst_addAToHl			; $425e
	ld a,(hl)		; $425f
	ld (w4RingFortuneStuff),a		; $4260
	ret			; $4263
_label_16_017:
	ld a,$84		; $4264
	ldh (<hFFBD),a	; $4266
	ret			; $4268
_label_16_018:
	ldh a,(<hFFBF)	; $4269
	inc a			; $426b
	ldh (<hFFBF),a	; $426c
_label_16_019:
	xor a			; $426e
	ld ($d981),a		; $426f
	ldh (<hFFBD),a	; $4272
	ld ($d982),a		; $4274
	ld ($d984),a		; $4277
	inc a			; $427a
	ld ($d988),a		; $427b
	jr _label_16_015		; $427e
	call $4043		; $4280
	call $44d7		; $4283
	ld a,($d986)		; $4286
	or a			; $4289
	jr z,_label_16_018	; $428a
	ldh a,(<hFFBF)	; $428c
	dec a			; $428e
	ldh (<hFFBF),a	; $428f
	jr _label_16_019		; $4291
	call $40a7		; $4293
	call $44d7		; $4296
	ld hl,w4RingFortuneStuff		; $4299
	ld de,$d9ee		; $429c
	ld b,$07		; $429f
	call copyMemoryReverse		; $42a1
	jp $43f5		; $42a4
	ld a,($d981)		; $42a7
	or a			; $42aa
	ld a,$00		; $42ab
	jr nz,_label_16_020	; $42ad
	inc a			; $42af
_label_16_020:
	ld ($d985),a		; $42b0
	call $40a7		; $42b3
	ld a,($d988)		; $42b6
	or a			; $42b9
	ret nz			; $42ba
	ld a,($d9e6)		; $42bb
	cp $c0			; $42be
	jr nz,_label_16_021	; $42c0
	jp $43f5		; $42c2
_label_16_021:
	cp $b0			; $42c5
	jp nz,$43e0		; $42c7
	ld a,($d9e7)		; $42ca
	ldh (<hActiveFileSlot),a	; $42cd
	cp $03			; $42cf
	jp nc,serialFunc_0c7e		; $42d1
	call loadFile		; $42d4
	ld a,$0d		; $42d7
	ldh (<hFFBF),a	; $42d9
	jp $43f5		; $42db
	call $4269		; $42de
	ld hl,w4RingFortuneStuff		; $42e1
	ld de,wRingsObtained		; $42e4
	ld b,$08		; $42e7
	call copyMemoryReverse		; $42e9
	jr _label_16_023		; $42ec
	call $4269		; $42ee
	ld hl,$d9e5		; $42f1
	ld a,$03		; $42f4
	ldi (hl),a		; $42f6
	ld a,$c0		; $42f7
	ldi (hl),a		; $42f9
	ld a,$c3		; $42fa
	ld (hl),a		; $42fc
	ld a,$01		; $42fd
	ld ($d988),a		; $42ff
	jp $4049		; $4302
	call $4043		; $4305
	call $44d7		; $4308
	jp $4269		; $430b
	call $40a7		; $430e
	call $44d7		; $4311
	ldh a,(<hFFBD)	; $4314
	cp $81			; $4316
	jp z,$4269		; $4318
	ld hl,w4RingFortuneStuff		; $431b
	ld de,$d9e6		; $431e
	ld b,$08		; $4321
	call copyMemoryReverse		; $4323
	jp $4269		; $4326
	call $40a7		; $4329
	call $44d7		; $432c
	ld hl,wRingsObtained		; $432f
	ld de,$d9e6		; $4332
	ld b,$08		; $4335
_label_16_022:
	ld a,(de)		; $4337
	or (hl)			; $4338
	ld (de),a		; $4339
	inc hl			; $433a
	inc de			; $433b
	dec b			; $433c
	jr nz,_label_16_022	; $433d
	ld hl,w4RingFortuneStuff		; $433f
	ld de,$d9e6		; $4342
	ld b,$08		; $4345
	call copyMemoryReverse		; $4347
	jp $43f5		; $434a
	call $4269		; $434d
_label_16_023:
	ld a,$0a		; $4350
	ld c,a			; $4352
	ld ($d9e5),a		; $4353
	ld de,$d9e6		; $4356
	ld hl,w4RingFortuneStuff		; $4359
	ld b,$08		; $435c
_label_16_024:
	ldi a,(hl)		; $435e
	ld (de),a		; $435f
	inc de			; $4360
	add c			; $4361
	ld c,a			; $4362
	dec b			; $4363
	jr nz,_label_16_024	; $4364
	ld a,c			; $4366
	ld (de),a		; $4367
	ld a,$01		; $4368
	ld ($d988),a		; $436a
	jp $4049		; $436d
	call $41dc		; $4370
	cp $80			; $4373
	jp z,serialFunc_0c7e		; $4375
	jp serialFunc_0c7e		; $4378
	call serialFunc_0c7e		; $437b
	ldh (<hFFBD),a	; $437e
	ld de,w4RingFortuneStuff		; $4380
	ld hl,wRingsObtained		; $4383
	ld b,$08		; $4386
	call copyMemoryReverse		; $4388
	jp saveFile		; $438b
	call $439a		; $438e
	call $44d7		; $4391
	call $4269		; $4394
	jp $4036		; $4397
	call $40a7		; $439a
	ld a,($d988)		; $439d
	or a			; $43a0
	ret nz			; $43a1
	ldh a,(<hFFBD)	; $43a2
	or a			; $43a4
	jr z,_label_16_025	; $43a5
	pop af			; $43a7
	jp serialFunc_0c7e		; $43a8
_label_16_025:
	ld a,($d9e6)		; $43ab
	cp $b1			; $43ae
	jr nz,_label_16_026	; $43b0
	xor a			; $43b2
	ld ($d986),a		; $43b3
	ldh a,(<hFFBF)	; $43b6
	sub $02			; $43b8
	ldh (<hFFBF),a	; $43ba
	ret			; $43bc
_label_16_026:
	cp $b0			; $43bd
	ret z			; $43bf
	ld a,$82		; $43c0
	ldh (<hFFBD),a	; $43c2
	ret			; $43c4
	call $4269		; $43c5
	ld hl,$d9e5		; $43c8
	ld a,$04		; $43cb
	ldi (hl),a		; $43cd
	ld a,$b0		; $43ce
	ldi (hl),a		; $43d0
	ld a,(wTmpcbbc)		; $43d1
	ldi (hl),a		; $43d4
	add $b4			; $43d5
	ldi (hl),a		; $43d7
	ld a,$01		; $43d8
	ld ($d988),a		; $43da
	jp $4049		; $43dd
_label_16_027:
	ld hl,$4500		; $43e0
	ld a,($d986)		; $43e3
	inc a			; $43e6
	ld ($d986),a		; $43e7
	cp $05			; $43ea
	jr c,_label_16_028	; $43ec
	ld a,$80		; $43ee
	ldh (<hFFBD),a	; $43f0
	jp serialFunc_0c7e		; $43f2
	xor a			; $43f5
	ld ($d986),a		; $43f6
	ld hl,$44fd		; $43f9
_label_16_028:
	call $4269		; $43fc
	ld a,(hl)		; $43ff
	ld b,a			; $4400
	ld de,$d9e5		; $4401
_label_16_029:
	ldi a,(hl)		; $4404
	ld (de),a		; $4405
	inc de			; $4406
	dec b			; $4407
	jr nz,_label_16_029	; $4408
	jp $4049		; $440a
	ld a,$00		; $440d
	jr _label_16_030		; $440f
	ld a,$01		; $4411
	jr _label_16_030		; $4413
	ld a,$02		; $4415
_label_16_030:
	ldh (<hFF8B),a	; $4417
	call $40a7		; $4419
	call $44d7		; $441c
	ldh a,(<hFF8B)	; $441f
	ld hl,$da05		; $4421
	jr nz,_label_16_027	; $4424
	swap a			; $4426
	rrca			; $4428
	ld hl,$d780		; $4429
	rst_addAToHl			; $442c
	ld de,$d9e6		; $442d
	ld b,$08		; $4430
_label_16_031:
	ld a,(de)		; $4432
	ldi (hl),a		; $4433
	inc de			; $4434
	dec b			; $4435
	jr nz,_label_16_031	; $4436
	ldh a,(<hFF8B)	; $4438
	add a			; $443a
	ld e,a			; $443b
	add a			; $443c
	add e			; $443d
	ld hl,w4NameBuffer		; $443e
	rst_addAToHl			; $4441
	ld de,$d9f0		; $4442
	ld b,$06		; $4445
	call copyMemoryReverse		; $4447
	ldh a,(<hFF8B)	; $444a
	inc a			; $444c
	ld hl,w4RingFortuneStuff		; $444d
	ld bc,$0016		; $4450
_label_16_032:
	dec a			; $4453
	jr z,_label_16_033	; $4454
	add hl,bc		; $4456
	jr _label_16_032		; $4457
_label_16_033:
	ld b,$16		; $4459
	ld de,$d9ee		; $445b
	call copyMemoryReverse		; $445e
	ld a,(wOpenedMenuType)		; $4461
	cp $08			; $4464
	jr nz,_label_16_034	; $4466
	ld de,$d9ee		; $4468
	call $44ef		; $446b
	jr nz,_label_16_035	; $446e
	ld hl,$da00		; $4470
	ldi a,(hl)		; $4473
	or (hl)			; $4474
	inc l			; $4475
	or (hl)			; $4476
	jr z,_label_16_035	; $4477
	jp $43f5		; $4479
_label_16_034:
	ld a,($da04)		; $447c
.ifdef ROM_AGES
	cp $a0			; $41ca
.else
	cp $a1			; $41ca
.endif
	jr nz,_label_16_035	; $4481
	ld a,($da02)		; $4483
	or a			; $4486
	jr z,_label_16_035	; $4487
	jp $43f5		; $4489
_label_16_035:
	ldh a,(<hFF8B)	; $448c
	ld d,$00		; $448e
	swap a			; $4490
	rrca			; $4492
	add d			; $4493
	ld hl,$d780		; $4494
	rst_addAToHl			; $4497
	set 7,(hl)		; $4498
	ldh a,(<hFF8B)	; $449a
	add a			; $449c
	ld e,a			; $449d
	add a			; $449e
	add e			; $449f
	ld hl,w4NameBuffer		; $44a0
	rst_addAToHl			; $44a3
	ld b,$06		; $44a4
	call clearMemory		; $44a6
	jp $43f5		; $44a9

;;
; @addr{44ac}
func_44ac:
	ld a,($ff00+R_SVBK)	; $44ac
	push af			; $44ae
	ld a,$04		; $44af
	ld ($ff00+R_SVBK),a	; $44b1
	xor a			; $44b3
	ld hl,$d980		; $44b4
	ldi (hl),a		; $44b7
	ldi (hl),a		; $44b8
	ldi (hl),a		; $44b9
	ldi (hl),a		; $44ba
	ldi (hl),a		; $44bb
	ldi (hl),a		; $44bc
	ldi (hl),a		; $44bd
	ldh (<hFFBE),a	; $44be
	ldh (<hFFBF),a	; $44c0
	ldh (<hFFBD),a	; $44c2
	call $4202		; $44c4
	ld a,$e1		; $44c7
	ld ($ff00+R_SB),a	; $44c9
	ld a,$80		; $44cb
	ld ($d988),a		; $44cd
	call writeToSC		; $44d0
	pop af			; $44d3
	ld ($ff00+R_SVBK),a	; $44d4
	ret			; $44d6

	ld a,($d988)		; $44d7
	or a			; $44da
	jr z,_label_16_036	; $44db
	pop af			; $44dd
	ret			; $44de
_label_16_036:
	ldh a,(<hFFBD)	; $44df
	or a			; $44e1
	ret z			; $44e2
	cp $81			; $44e3
	jp z,$43e0		; $44e5
	pop af			; $44e8
	jp serialFunc_0c7e		; $44e9
	ld de,w4RingFortuneStuff		; $44ec
	ld hl,wGameID		; $44ef
	ld b,$07		; $44f2
_label_16_037:
	ld a,(de)		; $44f4
	cp (hl)			; $44f5
	ret nz			; $44f6
	inc de			; $44f7
	inc l			; $44f8
	dec b			; $44f9
	jr nz,_label_16_037	; $44fa
	ret			; $44fc
	inc bc			; $44fd
	or b			; $44fe
	or e			; $44ff
	inc bc			; $4500
	or c			; $4501
	or h			; $4502
	inc bc			; $4503
	ld a,(bc)		; $4504
	ld de,$2e0f		; $4505
	ld l,$30		; $4508
	ld sp,$0f32		; $450a
	dec e			; $450d
	dec sp			; $450e
	inc d			; $450f
	inc h			; $4510
	inc h			; $4511
	ldd a,(hl)		; $4512
	dec sp			; $4513
	ld (de),a		; $4514
	inc a			; $4515
	ld a,(bc)		; $4516
	ld a,(de)		; $4517
	dec de			; $4518
	ld e,$1f		; $4519
	.db $20 $0a
	add hl,sp		; $451d

.ends