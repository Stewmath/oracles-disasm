 m_section_force serialCode NAMESPACE serialCode

;;
; @addr{4000}
func_4000:
	ldh a,(<hSerialInterruptBehaviour)	; $4000
	or a			; $4002
	ret z			; $4003
	ldh a,(<SVBK)	; $4004
	push af			; $4006
	ld a,$04		; $4007
	ldh (<SVBK),a	; $4009
	push de			; $400b
	call _func_4036		; $400c
	pop de			; $400f
	ldh a,(<SC)	; $4010
	rlca			; $4012
	jr c,++			; $4013
	ldh a,(<hSerialInterruptBehaviour)	; $4015
	cp $e0			; $4017
	jr z,+			; $4019
	ld a,($d98b)		; $401b
	or a			; $401e
	jr nz,++		; $401f
	ld a,($d983)		; $4021
	xor $01			; $4024
	ld ($d983),a		; $4026
	jr z,++			; $4029
	ldh a,(<hSerialInterruptBehaviour)	; $402b
+
	and $81			; $402d
	call writeToSC		; $402f
++
	pop af			; $4032
	ldh (<SVBK),a	; $4033
	ret			; $4035


_func_4036:
	ldh a,(<hFFBE)	; $4036
	rst_jumpTable			; $4038
	.dw _FFBE_00
	.dw _FFBE_01
	.dw _FFBE_02
	.dw _FFBE_03
	.dw _FFBE_04


_func_4043:
	call _func_41dc		; $4043
	cp $80			; $4046
	ret z			; $4048


_func_4049:
	ld a,($d981)		; $4049
	ld hl,$d9e5		; $404c
	rst_addAToHl			; $404f
	ld a,($d981)		; $4050
	or a			; $4053
	jr nz,_func_4066	; $4054
	ld a,(hl)		; $4056
	or a			; $4057
	jr nz,_func_405f	; $4058
	inc a			; $405a
	ld ($d98b),a		; $405b
	ret			; $405e


_func_405f:
	ld ($d987),a		; $405f
	xor a			; $4062
	ld ($d982),a		; $4063
_func_4066:
	inc a			; $4066
	ld ($d981),a		; $4067
	ld a,($d987)		; $406a
	dec a			; $406d
	ld ($d987),a		; $406e
	ldi a,(hl)		; $4071
	jr nz,+			; $4072
	xor a			; $4074
	ld ($d988),a		; $4075
	ld a,($d982)		; $4078
+
	ldh (<SB),a	; $407b
	ld hl,$d982		; $407d
	add (hl)		; $4080
	ld (hl),a		; $4081
	xor a			; $4082
	ld ($d98b),a		; $4083
	ret			; $4086


_func_4087:
	ldh a,(<hSerialRead)	; $4087
	or a			; $4089
	ret z			; $408a
	ld a,$01		; $408b
	ld ($d98b),a		; $408d
	xor a			; $4090
	ld ($ff00+R_SB),a	; $4091
	ldh (<hSerialRead),a	; $4093
	ret			; $4095


_func_4096:
	call _func_41dc		; $4096
	cp $80			; $4099
	jp z,serialFunc_0c7e		; $409b
	jp _func_4269		; $409e
_func_40a1:
	call _func_41dc		; $40a1
	jp serialFunc_0c7e		; $40a4
	

_func_40a7:
	xor a			; $40a7
	ld ($d98b),a		; $40a8
	call _func_41dc		; $40ab
	cp $80			; $40ae
	ret z			; $40b0
	ld a,($d981)		; $40b1
	ld b,a			; $40b4
	or a			; $40b5
	jr nz,_func_40d7	; $40b6
	ldh a,(<hSerialByte)	; $40b8
	cp $ff			; $40ba
	jr z,+			; $40bc
	or a			; $40be
	jr nz,_func_40d4	; $40bf
+
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


_func_40d4:
	ld ($d987),a		; $40d4
_func_40d7:
	ld hl,$d987		; $40d7
	dec (hl)		; $40da
	jr nz,_func_40f3	; $40db
	ldh a,(<hSerialByte)	; $40dd
	ld hl,$d982		; $40df
	cp (hl)			; $40e2
	jr z,+			; $40e3
	ld a,$81		; $40e5
	ldh (<hFFBD),a	; $40e7
+
	xor a			; $40e9
	ld ($d988),a		; $40ea
	ld ($d984),a		; $40ed
	ld ($ff00+R_SB),a	; $40f0
	ret			; $40f2


_func_40f3:
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


_FFBE_04:
	ldh a,(<hFFBF)	; $410e
	rst_jumpTable			; $4110
	.dw _FFBE_04_FFBF_00
	.dw _func_4280
	.dw _FFBE_04_FFBF_02
	.dw _func_4280
	.dw _FFBE_04_FFBF_04
	.dw _func_4280
	.dw _func_438e
	.dw _func_4087
	.dw _FFBE_04_FFBF_08
	.dw _FFBE_04_FFBF_09
	.dw _func_438e
	.dw _FFBE_04_FFBF_0b
	.dw _FFBE_04_FFBF_0c
	.dw _FFBE_04_FFBF_0d
	.dw _func_438e
	.dw _FFBE_04_FFBF_0f
	.dw _func_4280
	.dw _func_4096
	.dw _FFBE_04_FFBF_12
	.dw _func_4280
	.dw _func_438e
	.dw _func_43f5
	.dw _func_4280
	.dw _func_4096
	.dw _func_437b


_FFBE_03:
	ldh a,(<hFFBF)	; $4143
	rst_jumpTable			; $4145
	.dw _FFBE_03_FFBF_00
	.dw _func_4280
	.dw _func_438e
	.dw _FFBE_03_FFBF_03
	.dw _func_4280
	.dw _func_438e
	.dw _FFBE_03_FFBF_06
	.dw _func_4280
	.dw _func_438e
	.dw _func_43f5
	.dw _func_4280
	.dw _FFBE_03_FFBF_0b
	.dw _func_4280
	.dw _func_40a1
	.dw _func_4280
	.dw _func_4096
	.dw _FFBE_03_FFBF_10
	.dw _func_4280
	.dw _func_438e
	.dw _FFBE_03_FFBF_13
	.dw _func_43f5
	.dw _func_4280
	.dw _func_438e
	.dw _func_437b


_FFBE_03_FFBF_00:
	xor a			; $4176
	jr ++			; $4177
	
_FFBE_03_FFBF_03:
	ld a,$01		; $4179
	jr ++			; $417b
	
_FFBE_03_FFBF_06:
	ld a,$02		; $417d
++
	ldh (<hActiveFileSlot),a; $417f
	call loadFile		; $4181
	ldh (<hFF8B),a		; $4184
_func_4186:
	call _func_4269		; $4186
	ld hl,$d9e5		; $4189
	ld a,$21		; $418c
	ldi (hl),a		; $418e [hl = $d9e5]
	ld c,a			; $418f
	ldh a,(<hFF8B)		; $4190
	ldi (hl),a		; $4192 [hl = $d9e6]
	ldi (hl),a		; $4193 [hl = $d9e7]
	add a			; $4194
	add c			; $4195
	ld c,a			; $4196
	ld a,(wLinkMaxHealth)	; $4197
	ldi (hl),a		; $419a [hl = $d9e8]
	ldi (hl),a		; $419b [hl = $d9e9]
	add a			; $419c
	add c			; $419d
	ld c,a			; $419e
	ld a,(wDeathCounter)	; $419f
	ldi (hl),a		; $41a2 [hl = $d9ea]
	add c			; $41a3
	ld c,a			; $41a4
	ld a,(wDeathCounter+1)	; $41a5
	ldi (hl),a		; $41a8 [hl = $d9eb]
	add c			; $41a9
	ld c,a			; $41aa
	ld a,(wFileIsLinkedGame); $41ab
	ldi (hl),a		; $41ae [hl = $d9ec]
	add c			; $41af
	ld c,a			; $41b0
	ld a,(wFileIsHeroGame)	; $41b1
	add a			; $41b4
	ld e,a			; $41b5
	ld a,(wFileIsCompleted)	; $41b6
	or e			; $41b9
	ldi (hl),a		; $41ba [hl = $d9ed]
	add c			; $41bb
	ld c,a			; $41bc
	ld de,wGameID		; $41bd
	ld b,$16		; $41c0
--
	ld a,(de)		; $41c2
	ldi (hl),a		; $41c3 [hl = $d9ee-$da03]
	add c			; $41c4
	ld c,a			; $41c5
	inc e			; $41c6
	dec b			; $41c7
	jr nz,--		; $41c8
.ifdef ROM_AGES
	ld a,$a1		; $41ca
.else
	ld a,$a0		; $41ca
.endif
	ldi (hl),a		; $41cc [hl = $da04]
	add c			; $41cd
	ld c,a			; $41ce
	ldh a,(<hActiveFileSlot); $41cf
	ld (hl),a		; $41d1 [hl = $da05]
	add c			; $41d2
	ldi (hl),a		; $41d3 [hl = $da05]
	ld a,$01		; $41d4
	ld ($d988),a		; $41d6
	jp _func_4049		; $41d9


_func_41dc:
	ldh a,(<hSerialRead)	; $41dc
	or a			; $41de
	jr nz,_func_41fa	; $41df
	ld a,($d985)		; $41e1
	or a			; $41e4
	jr nz,+			; $41e5
	ld hl,$d989		; $41e7
	call decHlRef16WithCap		; $41ea
	jr z,_func_41f1	; $41ed
+
	pop af			; $41ef
	ret			; $41f0


_func_41f1:
	xor a			; $41f1
	ld ($d988),a		; $41f2
	ld a,$80		; $41f5
	ldh (<hFFBD),a	; $41f7
	ret			; $41f9


_func_41fa:
	ld ($d988),a		; $41fa
	xor a			; $41fd
	ldh (<hSerialRead),a	; $41fe
	ldh (<hFFBD),a	; $4200
_set_d989to00b4:
	ld a,$b4		; $4202
	ld ($d989),a		; $4204
	ld a,$00		; $4207
	ld ($d98a),a		; $4209
	ret			; $420c
	

_FFBE_00:
_FFBE_01:
	ldh a,(<hFFBF)	; $420d
	rst_jumpTable			; $420f
	.dw _func_4186
	.dw _func_4280
	.dw _func_438e
	.dw _func_4293
	.dw _func_4280
	.dw _func_4096
	.dw _func_422f


_FFBE_02:
	ldh a,(<hFFBF)	; $421e
	rst_jumpTable			; $4220
	.dw _func_4293
	.dw _func_4280
	.dw _func_4096
	.dw _func_4186
	.dw _func_4280
	.dw _func_438e
	.dw _func_422f


_func_422f:
	call serialFunc_0c7e		; $422f
	xor a			; $4232
	ldh (<hFFBD),a	; $4233
	call _func_44ec		; $4235
	jr z,_setBDto84	; $4238
	ld hl,wGameID		; $423a
	ld a,(w4RingFortuneStuff)		; $423d
	add (hl)		; $4240
	and $7f			; $4241
	ld b,$00		; $4243
	and $7c			; $4245
	jr z,+			; $4247
	inc b			; $4249
	and $60			; $424a
	jr z,+			; $424c
	inc b			; $424e
+
	inc l			; $424f
	ld c,(hl)		; $4250
	ld a,b			; $4251
	ld hl,_table_4503		; $4252
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
	
	
_setBDto84:
	ld a,$84		; $4264
	ldh (<hFFBD),a	; $4266
	ret			; $4268


_func_4269:
	ldh a,(<hFFBF)	; $4269
	inc a			; $426b
	ldh (<hFFBF),a	; $426c
_func_426e:
	xor a			; $426e
	ld ($d981),a		; $426f
	ldh (<hFFBD),a	; $4272
	ld ($d982),a		; $4274
	ld ($d984),a		; $4277
	inc a			; $427a
	ld ($d988),a		; $427b
	jr _set_d989to00b4		; $427e
	
	
_func_4280:
	call _func_4043		; $4280
	call _func_44d7		; $4283
	ld a,($d986)		; $4286
	or a			; $4289
	jr z,_func_4269	; $428a
	ldh a,(<hFFBF)	; $428c
	dec a			; $428e
	ldh (<hFFBF),a	; $428f
	jr _func_426e		; $4291
	
	
_func_4293:
	call _func_40a7		; $4293
	call _func_44d7		; $4296
	ld hl,w4RingFortuneStuff		; $4299
	ld de,$d9ee		; $429c
	ld b,$07		; $429f
	call copyMemoryReverse		; $42a1
	jp _func_43f5		; $42a4
	
	
_FFBE_03_FFBF_0b:
	ld a,($d981)		; $42a7
	or a			; $42aa
	ld a,$00		; $42ab
	jr nz,+			; $42ad
	inc a			; $42af
+
	ld ($d985),a		; $42b0
	call _func_40a7		; $42b3
	ld a,($d988)		; $42b6
	or a			; $42b9
	ret nz			; $42ba
	ld a,($d9e6)		; $42bb
	cp $c0			; $42be
	jr nz,_func_42c5	; $42c0
	jp _func_43f5		; $42c2
	
	
_func_42c5:
	cp $b0			; $42c5
	jp nz,_func_43e0		; $42c7
	ld a,($d9e7)		; $42ca
	ldh (<hActiveFileSlot),a	; $42cd
	cp $03			; $42cf
	jp nc,serialFunc_0c7e		; $42d1
	call loadFile		; $42d4
	ld a,$0d		; $42d7
	ldh (<hFFBF),a	; $42d9
	jp _func_43f5		; $42db
	
	
_FFBE_03_FFBF_10:
	call _func_4269		; $42de
	ld hl,w4RingFortuneStuff		; $42e1
	ld de,wRingsObtained		; $42e4
	ld b,$08		; $42e7
	call copyMemoryReverse		; $42e9
	jr _func_4350		; $42ec
	
	
_FFBE_04_FFBF_08:
	call _func_4269		; $42ee
	ld hl,$d9e5		; $42f1
	ld a,$03		; $42f4
	ldi (hl),a		; $42f6
	ld a,$c0		; $42f7
	ldi (hl),a		; $42f9
	ld a,$c3		; $42fa
	ld (hl),a		; $42fc
	ld a,$01		; $42fd
	ld ($d988),a		; $42ff
	jp _func_4049		; $4302
	
	
_FFBE_04_FFBF_09:
_FFBE_04_FFBF_0d:
	call _func_4043		; $4305
	call _func_44d7		; $4308
	jp _func_4269		; $430b
	
	
_FFBE_03_FFBF_13:
	call _func_40a7		; $430e
	call _func_44d7		; $4311
	ldh a,(<hFFBD)	; $4314
	cp $81			; $4316
	jp z,_func_4269		; $4318
	ld hl,w4RingFortuneStuff		; $431b
	ld de,$d9e6		; $431e
	ld b,$08		; $4321
	call copyMemoryReverse		; $4323
	jp _func_4269		; $4326
	
	
_FFBE_04_FFBF_0f:
	call _func_40a7		; $4329
	call _func_44d7		; $432c
	ld hl,wRingsObtained		; $432f
	ld de,$d9e6		; $4332
	ld b,$08		; $4335
-
	ld a,(de)		; $4337
	or (hl)			; $4338
	ld (de),a		; $4339
	inc hl			; $433a
	inc de			; $433b
	dec b			; $433c
	jr nz,-			; $433d
	ld hl,w4RingFortuneStuff		; $433f
	ld de,$d9e6		; $4342
	ld b,$08		; $4345
	call copyMemoryReverse		; $4347
	jp _func_43f5		; $434a
	
	
_FFBE_04_FFBF_12:
	call _func_4269		; $434d
_func_4350:
	ld a,$0a		; $4350
	ld c,a			; $4352
	ld ($d9e5),a		; $4353
	ld de,$d9e6		; $4356
	ld hl,w4RingFortuneStuff		; $4359
	ld b,$08		; $435c
-
	ldi a,(hl)		; $435e
	ld (de),a		; $435f
	inc de			; $4360
	add c			; $4361
	ld c,a			; $4362
	dec b			; $4363
	jr nz,-			; $4364
	ld a,c			; $4366
	ld (de),a		; $4367
	ld a,$01		; $4368
	ld ($d988),a		; $436a
	jp _func_4049		; $436d
	
	
_FFBE_04_FFBF_0b:
	call _func_41dc		; $4370
	cp $80			; $4373
	jp z,serialFunc_0c7e		; $4375
	jp serialFunc_0c7e		; $4378
	
	
_func_437b:
	call serialFunc_0c7e		; $437b
	ldh (<hFFBD),a		; $437e
	ld de,w4RingFortuneStuff		; $4380
	ld hl,wRingsObtained		; $4383
	ld b,$08		; $4386
	call copyMemoryReverse		; $4388
	jp saveFile		; $438b
	
	
_func_438e:
	call _func_439a		; $438e
	call _func_44d7		; $4391
	call _func_4269		; $4394
	jp _func_4036		; $4397
	
	
_func_439a:
	call _func_40a7		; $439a
	ld a,($d988)		; $439d
	or a			; $43a0
	ret nz			; $43a1
	ldh a,(<hFFBD)	; $43a2
	or a			; $43a4
	jr z,_func_43ab	; $43a5
	pop af			; $43a7
	jp serialFunc_0c7e		; $43a8
	
	
_func_43ab:
	ld a,($d9e6)		; $43ab
	cp $b1			; $43ae
	jr nz,_func_43bd	; $43b0
	xor a			; $43b2
	ld ($d986),a		; $43b3
	ldh a,(<hFFBF)	; $43b6
	sub $02			; $43b8
	ldh (<hFFBF),a	; $43ba
	ret			; $43bc
	
	
_func_43bd:
	cp $b0			; $43bd
	ret z			; $43bf
	ld a,$82		; $43c0
	ldh (<hFFBD),a	; $43c2
	ret			; $43c4
	
	
_FFBE_04_FFBF_0c:
	call _func_4269		; $43c5
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
	jp _func_4049		; $43dd
	
	
_func_43e0:
	ld hl,_table_4500		; $43e0
	ld a,($d986)		; $43e3
	inc a			; $43e6
	ld ($d986),a		; $43e7
	cp $05			; $43ea
	jr c,_func_43fc	; $43ec
	ld a,$80		; $43ee
	ldh (<hFFBD),a	; $43f0
	jp serialFunc_0c7e		; $43f2
	
	
_func_43f5:
	xor a			; $43f5
	ld ($d986),a		; $43f6
	ld hl,_table_44fd		; $43f9
_func_43fc:
	call _func_4269		; $43fc
	ld a,(hl)		; $43ff
	ld b,a			; $4400
	ld de,$d9e5		; $4401
-
	ldi a,(hl)		; $4404
	ld (de),a		; $4405
	inc de			; $4406
	dec b			; $4407
	jr nz,-			; $4408
	jp _func_4049		; $440a
	
	
_FFBE_04_FFBF_00:
	ld a,$00		; $440d
	jr ++			; $440f
	
_FFBE_04_FFBF_02:
	ld a,$01		; $4411
	jr ++			; $4413
	
_FFBE_04_FFBF_04:
	ld a,$02		; $4415
++
	ldh (<hFF8B),a	; $4417
	call _func_40a7		; $4419
	call _func_44d7		; $441c
	ldh a,(<hFF8B)	; $441f
	ld hl,$da05		; $4421
	jr nz,_func_43e0	; $4424
	swap a			; $4426
	rrca			; $4428
	ld hl,$d780		; $4429
	rst_addAToHl			; $442c
	ld de,$d9e6		; $442d
	ld b,$08		; $4430
-
	ld a,(de)		; $4432
	ldi (hl),a		; $4433
	inc de			; $4434
	dec b			; $4435
	jr nz,-			; $4436
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
-
	dec a			; $4453
	jr z,_func_4459	; $4454
	add hl,bc		; $4456
	jr -			; $4457
	
	
_func_4459:
	ld b,$16		; $4459
	ld de,$d9ee		; $445b
	call copyMemoryReverse		; $445e
	ld a,(wOpenedMenuType)		; $4461
	cp $08			; $4464
	jr nz,_func_447c	; $4466
	ld de,$d9ee		; $4468
	call _func_44ef		; $446b
	jr nz,_func_448c	; $446e
	ld hl,$da00		; $4470
	ldi a,(hl)		; $4473
	or (hl)			; $4474
	inc l			; $4475
	or (hl)			; $4476
	jr z,_func_448c	; $4477
	jp _func_43f5		; $4479
	
	
_func_447c:
	ld a,($da04)		; $447c
.ifdef ROM_AGES
	cp $a0			; $41ca
.else
	cp $a1			; $41ca
.endif
	jr nz,_func_448c	; $4481
	ld a,($da02)		; $4483
	or a			; $4486
	jr z,_func_448c	; $4487
	jp _func_43f5		; $4489


_func_448c:
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
	jp _func_43f5		; $44a9

;;
; @addr{44ac}
func_44ac:
	ldh a,(<SVBK)	; $44ac
	push af			; $44ae
	ld a,$04		; $44af
	ldh (<SVBK),a	; $44b1
	
	xor a			; $44b3
	ld hl,$d980		; $44b4
	ldi (hl),a		; $44b7
	ldi (hl),a		; $44b8
	ldi (hl),a		; $44b9
	ldi (hl),a		; $44ba
	ldi (hl),a		; $44bb
	ldi (hl),a		; $44bc
	ldi (hl),a		; $44bd
	ldh (<hFFBE),a		; $44be
	ldh (<hFFBF),a		; $44c0
	ldh (<hFFBD),a		; $44c2
	call _set_d989to00b4		; $44c4

	ld a,$e1		; $44c7
	ldh (<R_SB),a	; $44c9
	ld a,$80		; $44cb
	ld (w4Filler1+8),a		; $44cd
	call writeToSC		; $44d0
	
	pop af			; $44d3
	ldh (<SVBK),a	; $44d4
	ret			; $44d6


_func_44d7:
	ld a,($d988)		; $44d7
	or a			; $44da
	jr z,_func_44df	; $44db
	pop af			; $44dd
	ret			; $44de


_func_44df:
	ldh a,(<hFFBD)		; $44df
	or a			; $44e1
	ret z			; $44e2
	cp $81			; $44e3
	jp z,_func_43e0		; $44e5
	pop af			; $44e8
	jp serialFunc_0c7e		; $44e9


_func_44ec:
	ld de,w4RingFortuneStuff		; $44ec
_func_44ef:
	ld hl,wGameID		; $44ef
	ld b,$07		; $44f2
-
	ld a,(de)		; $44f4
	cp (hl)			; $44f5
	ret nz			; $44f6
	inc de			; $44f7
	inc l			; $44f8
	dec b			; $44f9
	jr nz,-			; $44fa
	ret			; $44fc


_table_44fd:
	; bytes to copy to $d9e5, incl itself
	.db $03 $b0 $b3

_table_4500:
	.db $03 $b1 $b4

_table_4503:
	.db _table_4506-CADDR		; $4503
	.db _table_450e-CADDR		; $4504
	.db _table_4516-CADDR		; $4505

_table_4506:
	.db $0f $2e $2e $30
	.db $31 $32 $0f $1d

_table_450e:
	.db $3b $14 $24 $24
	.db $3a $3b $12 $3c

_table_4516:
	.db $0a $1a $1b $1e
	.db $1f $20 $0a $39

.ends