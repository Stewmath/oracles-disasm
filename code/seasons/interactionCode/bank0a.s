interactionCode89:
	ld a,($cba0)		; $4000
	or a			; $4003
	jr nz,_label_0a_000	; $4004
	ld a,$02		; $4006
	ld ($cbac),a		; $4008
	ld a,$08		; $400b
	ld ($cbae),a		; $400d
_label_0a_000:
	call $401d		; $4010
	ld e,$42		; $4013
	ld a,(de)		; $4015
	or a			; $4016
	jp nz,objectSetPriorityRelativeToLink_withTerrainEffects		; $4017
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $401a
	ld e,$44		; $401d
	ld a,(de)		; $401f
	rst_jumpTable			; $4020
	dec l			; $4021
	ld b,b			; $4022
	ld e,a			; $4023
	ld b,b			; $4024
	adc h			; $4025
	ld b,b			; $4026
	jp z,$e840		; $4027
	ld b,b			; $402a
	add hl,bc		; $402b
	ld b,c			; $402c
	ld a,$01		; $402d
	ld (de),a		; $402f
	call interactionInitGraphics		; $4030
	call interactionSetAlwaysUpdateBit		; $4033
	ld a,$30		; $4036
	call interactionSetHighTextIndex		; $4038
	ld e,$42		; $403b
	ld a,(de)		; $403d
	or a			; $403e
	jr z,_label_0a_001	; $403f
	ld a,$06		; $4041
	call objectSetCollideRadius		; $4043
	call objectGetTileCollisions		; $4046
	ld (hl),$0f		; $4049
	ld a,(de)		; $404b
	call interactionSetAnimation		; $404c
	ld e,$71		; $404f
	jp objectAddToAButtonSensitiveObjectList		; $4051
_label_0a_001:
	ld a,$04		; $4054
	ld e,$44		; $4056
	ld (de),a		; $4058
	ld hl,$49e2		; $4059
	jp interactionSetScript		; $405c
	ld c,$18		; $405f
	call objectCheckLinkWithinDistance		; $4061
	ld e,$42		; $4064
	ld a,(de)		; $4066
	jp nc,interactionSetAnimation		; $4067
	call interactionAnimate		; $406a
	ld h,d			; $406d
	ld l,$71		; $406e
	ld a,(hl)		; $4070
	or a			; $4071
	ret z			; $4072
	xor a			; $4073
	ld (hl),a		; $4074
	inc a			; $4075
	ld ($cc02),a		; $4076
	ld ($cca4),a		; $4079
	ld e,l			; $407c
	call objectRemoveFromAButtonSensitiveObjectList		; $407d
	ld h,d			; $4080
	ld l,$44		; $4081
	ld a,$02		; $4083
	ldd (hl),a		; $4085
	dec l			; $4086
	ld a,(hl)		; $4087
	inc a			; $4088
	jp interactionSetAnimation		; $4089
	call $41c9		; $408c
	call interactionAnimate		; $408f
	ld e,$42		; $4092
	ld a,(de)		; $4094
	and $04			; $4095
	ld b,a			; $4097
	ld c,$00		; $4098
	ld e,$76		; $409a
	ld a,(de)		; $409c
	or a			; $409d
	jr z,_label_0a_002	; $409e
	ld a,$28		; $40a0
	call checkGlobalFlag		; $40a2
	jr nz,_label_0a_003	; $40a5
	ld hl,$c612		; $40a7
	ldi a,(hl)		; $40aa
	or (hl)			; $40ab
	jr nz,_label_0a_003	; $40ac
_label_0a_002:
	ld c,$02		; $40ae
_label_0a_003:
	ld a,b			; $40b0
	add c			; $40b1
	ld hl,$40c2		; $40b2
	rst_addAToHl			; $40b5
	ldi a,(hl)		; $40b6
	ld h,(hl)		; $40b7
	ld l,a			; $40b8
	call interactionSetScript		; $40b9
	ld e,$44		; $40bc
	ld a,$04		; $40be
	ld (de),a		; $40c0
	ret			; $40c1
	jp z,$c24a		; $40c2
	ld c,d			; $40c5
	ld ($ff00+c),a		; $40c6
	ld c,d			; $40c7
	and b			; $40c8
	ld c,d			; $40c9
	call interactionAnimate		; $40ca
	ld e,$61		; $40cd
	ld a,(de)		; $40cf
	or a			; $40d0
	ret z			; $40d1
	xor a			; $40d2
	ld ($cc02),a		; $40d3
	ld e,$44		; $40d6
	ld a,$01		; $40d8
	ld (de),a		; $40da
	ld e,$42		; $40db
	ld a,(de)		; $40dd
	or a			; $40de
	ret z			; $40df
	call interactionSetAnimation		; $40e0
	ld e,$71		; $40e3
	jp objectAddToAButtonSensitiveObjectList		; $40e5
	call $41c9		; $40e8
	call interactionAnimate		; $40eb
	call interactionRunScript		; $40ee
	ret nc			; $40f1
	xor a			; $40f2
	ld ($cc02),a		; $40f3
	ld ($cca4),a		; $40f6
	ld e,$42		; $40f9
	ld a,(de)		; $40fb
	or a			; $40fc
	ret z			; $40fd
	add $02			; $40fe
	call interactionSetAnimation		; $4100
	ld e,$44		; $4103
	ld a,$03		; $4105
	ld (de),a		; $4107
	ret			; $4108
	call interactionAnimate		; $4109
	ld e,$45		; $410c
	ld a,(de)		; $410e
	rst_jumpTable			; $410f
	ld a,(de)		; $4110
	ld b,c			; $4111
	dec l			; $4112
	ld b,c			; $4113
	ld e,c			; $4114
	ld b,c			; $4115
	and h			; $4116
	ld b,c			; $4117
	xor a			; $4118
	ld b,c			; $4119
	call retIfTextIsActive		; $411a
	call interactionIncState2		; $411d
	xor a			; $4120
	ld l,$46		; $4121
	ld (hl),a		; $4123
	ld l,$47		; $4124
	ld (hl),$02		; $4126
	ld a,$04		; $4128
	jp interactionSetAnimation		; $412a
	call interactionDecCounter1		; $412d
	jr nz,_label_0a_004	; $4130
	inc l			; $4132
	dec (hl)		; $4133
	jr nz,_label_0a_004	; $4134
	xor a			; $4136
	ld ($ff00+$01),a	; $4137
	ld hl,$4ad9		; $4139
	ld b,$80		; $413c
	jr _label_0a_006		; $413e
_label_0a_004:
	ldh a,(<hSerialInterruptBehaviour)	; $4140
	or a			; $4142
	jp z,serialFunc_0c73		; $4143
	and $01			; $4146
	add $01			; $4148
	ldh (<hFFBE),a	; $414a
	call interactionIncState2		; $414c
	ld l,$46		; $414f
	ld (hl),$b4		; $4151
	ld bc,$3030		; $4153
	jp showTextNonExitable		; $4156
	call serialFunc_0c8d		; $4159
	ldh a,(<hSerialInterruptBehaviour)	; $415c
	or a			; $415e
	ret nz			; $415f
	ld a,($ff00+$70)	; $4160
	push af			; $4162
	ld a,$04		; $4163
	ld ($ff00+$70),a	; $4165
	ldh a,(<hFFBD)	; $4167
	ld b,a			; $4169
	ld a,($cbc2)		; $416a
	ld e,a			; $416d
	ld a,($d98d)		; $416e
	ld c,a			; $4171
	pop af			; $4172
	ld ($ff00+$70),a	; $4173
	ld a,b			; $4175
	or e			; $4176
	jr nz,_label_0a_005	; $4177
	ld e,$7a		; $4179
	ld a,c			; $417b
	ld (de),a		; $417c
	call interactionDecCounter1		; $417d
	ret nz			; $4180
	ld hl,$4b0a		; $4181
	jr _label_0a_006		; $4184
_label_0a_005:
	ld hl,$4ad6		; $4186
	ld a,e			; $4189
	cp $8f			; $418a
	jr z,_label_0a_006	; $418c
	ld hl,$4adf		; $418e
	cp $85			; $4191
	jr z,_label_0a_006	; $4193
	ld hl,$4adc		; $4195
_label_0a_006:
	xor a			; $4198
	ld ($cca4),a		; $4199
	call $40b9		; $419c
	ld a,$02		; $419f
	jp interactionSetAnimation		; $41a1
	call retIfTextIsActive		; $41a4
	ld a,$08		; $41a7
	call openMenu		; $41a9
	jp interactionIncState2		; $41ac
	ld a,($ff00+$70)	; $41af
	push af			; $41b1
	ld a,$04		; $41b2
	ld ($ff00+$70),a	; $41b4
	ldh a,(<hFFBD)	; $41b6
	ld b,a			; $41b8
	ld a,($cbc2)		; $41b9
	ld e,a			; $41bc
	pop af			; $41bd
	ld ($ff00+$70),a	; $41be
	ld a,b			; $41c0
	or e			; $41c1
	jr nz,_label_0a_005	; $41c2
	ld hl,$4b14		; $41c4
	jr _label_0a_006		; $41c7
	ld a,$2c		; $41c9
	call checkTreasureObtained		; $41cb
	ld a,$00		; $41ce
	rla			; $41d0
	ld e,$76		; $41d1
	ld (de),a		; $41d3
	ld a,($c6c7)		; $41d4
	inc e			; $41d7
	ld (de),a		; $41d8
	ld hl,$c616		; $41d9
	ld b,$08		; $41dc
	xor a			; $41de
_label_0a_007:
	or (hl)			; $41df
	inc l			; $41e0
	dec b			; $41e1
	jr nz,_label_0a_007	; $41e2
	inc e			; $41e4
	ld (de),a		; $41e5
	ret			; $41e6

interactionCode91:
	ld e,$42		; $41e7
	ld a,(de)		; $41e9
	or a			; $41ea
	ld e,$44		; $41eb
	ld a,(de)		; $41ed
	jp nz,seasonsFunc_0a_4261		; $41ee
	or a			; $41f1
	jr z,_label_0a_009	; $41f2
	call $4284		; $41f4
	jp c,interactionDelete		; $41f7
	call objectApplySpeed		; $41fa
	ld e,$4b		; $41fd
	ld a,(de)		; $41ff
	cp $f0			; $4200
	jp nc,interactionDelete		; $4202
	call interactionDecCounter1		; $4205
	ret nz			; $4208
	ld (hl),$04		; $4209
	ld l,$71		; $420b
	dec (hl)		; $420d
	jr nz,_label_0a_008	; $420e
	ld (hl),$08		; $4210
	ld l,$70		; $4212
	ld a,(hl)		; $4214
	cpl			; $4215
	inc a			; $4216
	ld (hl),a		; $4217
_label_0a_008:
	ld e,$49		; $4218
	ld a,(de)		; $421a
	ld l,$70		; $421b
	add (hl)		; $421d
	and $1f			; $421e
	ld (de),a		; $4220
	ret			; $4221
_label_0a_009:
	call $4284		; $4222
	jp c,interactionDelete		; $4225
	call interactionInitGraphics		; $4228
	call interactionIncState		; $422b
	ld l,$50		; $422e
	ld (hl),$14		; $4230
	ld l,$46		; $4232
	ld a,$04		; $4234
	ldi (hl),a		; $4236
	ld (hl),$b4		; $4237
	ld l,$71		; $4239
	inc a			; $423b
	ldd (hl),a		; $423c
	call getRandomNumber		; $423d
	and $01			; $4240
	jr nz,_label_0a_010	; $4242
	dec a			; $4244
_label_0a_010:
	ld (hl),a		; $4245
	ld a,($cc50)		; $4246
	and $20			; $4249
	jp nz,objectSetVisible83		; $424b
_label_0a_011:
	call getRandomNumber_noPreserveVars		; $424e
	and $07			; $4251
	cp $05			; $4253
	jr nc,_label_0a_011	; $4255
	sub $02			; $4257
	and $1f			; $4259
	ld e,$49		; $425b
	ld (de),a		; $425d
	jp objectSetVisible81		; $425e

seasonsFunc_0a_4261:
	or a			; $4261
	jr z,_label_0a_012	; $4262
	ld a,$24		; $4264
	call objectGetRelatedObject1Var		; $4266
	bit 7,(hl)		; $4269
	jp z,interactionDelete		; $426b
	call objectTakePosition		; $426e
	call interactionDecCounter1		; $4271
	ret nz			; $4274
	ld (hl),$5a		; $4275
	ld b,$91		; $4277
	jp objectCreateInteractionWithSubid00		; $4279
_label_0a_012:
	call interactionIncState		; $427c
	ld l,$46		; $427f
	ld (hl),$1e		; $4281
	ret			; $4283
	ld a,($cc50)		; $4284
	and $20			; $4287
	jp nz,seasonsFunc_0a_429d		; $4289
	call interactionDecCounter2		; $428c
	ld a,(hl)		; $428f
	cp $3c			; $4290
	ret nc			; $4292
	or a			; $4293
	scf			; $4294
	ret z			; $4295
	ld l,$5a		; $4296
	ld a,(hl)		; $4298
	xor $80			; $4299
	ld (hl),a		; $429b
	ret			; $429c

seasonsFunc_0a_429d:
	call objectGetTileAtPosition		; $429d
	ld hl,hazardCollisionTable		; $42a0
	call lookupCollisionTable		; $42a3
	ccf			; $42a6
	ret			; $42a7

interactionCode98:
	ld e,$44		; $42a8
	ld a,(de)		; $42aa
	rst_jumpTable			; $42ab
	or b			; $42ac
	ld b,d			; $42ad
	add $42			; $42ae
	ld a,$01		; $42b0
	ld (de),a		; $42b2
	call interactionInitGraphics		; $42b3
	ld a,$07		; $42b6
	call objectSetCollideRadius		; $42b8
	ld e,$42		; $42bb
	ld a,(de)		; $42bd
	jr _label_0a_013		; $42be
_label_0a_013:
	call interactionSetAnimation		; $42c0
	jp objectSetVisible81		; $42c3
	ld a,($cc75)		; $42c6
	or a			; $42c9
	jr nz,_label_0a_014	; $42ca
	ld a,($cc48)		; $42cc
	bit 0,a			; $42cf
	jr nz,_label_0a_014	; $42d1
	ld a,($dc00)		; $42d3
	or a			; $42d6
	jr nz,_label_0a_014	; $42d7
	ld e,$42		; $42d9
	ld a,(de)		; $42db
	cp $02			; $42dc
	ld c,$11		; $42de
	jr c,_label_0a_015	; $42e0
	ld c,$19		; $42e2
	jr _label_0a_015		; $42e4
_label_0a_014:
	ld c,$0f		; $42e6
_label_0a_015:
	call objectGetShortPosition		; $42e8
	ld h,$ce		; $42eb
	ld l,a			; $42ed
	ld (hl),c		; $42ee
	ret			; $42ef

interactionCode9f:
	ld e,$44		; $42f0
	ld a,(de)		; $42f2
	rst_jumpTable			; $42f3
	ld hl,sp+$42		; $42f4
	ld b,$43		; $42f6
	ld a,$01		; $42f8
	ld (de),a		; $42fa
	ld h,d			; $42fb
	ld l,$40		; $42fc
	set 7,(hl)		; $42fe
	call interactionInitGraphics		; $4300
	jp objectSetVisible80		; $4303
	ld h,d			; $4306
	ld l,$46		; $4307
	ld a,(hl)		; $4309
	inc a			; $430a
	jp z,interactionAnimate		; $430b
	dec (hl)		; $430e
	jp nz,interactionAnimate		; $430f
	jp interactionDelete		; $4312
objectCreateExclamationMark_body:
	ldh (<hFF8B),a	; $4315
	call getFreeInteractionSlot		; $4317
	ret nz			; $431a
	ld (hl),$9f		; $431b
	ld l,$46		; $431d
	ldh a,(<hFF8B)	; $431f
	ld (hl),a		; $4321
	call objectCopyPositionWithOffset		; $4322
	push hl			; $4325
	ld a,$50		; $4326
	call playSound		; $4328
	pop hl			; $432b
	ret			; $432c
objectCreateFloatingImage:
	call getFreeInteractionSlot		; $432d
	ret nz			; $4330
	ld (hl),$a0		; $4331
	inc l			; $4333
	ldh a,(<hFF8D)	; $4334
	ldi (hl),a		; $4336
	ldh a,(<hFF8B)	; $4337
	ld (hl),a		; $4339
	jp objectCopyPositionWithOffset		; $433a

interactionCodea0:
	ld e,$44		; $433d
	ld a,(de)		; $433f
	rst_jumpTable			; $4340
	ld b,l			; $4341
	ld b,e			; $4342
	ld h,a			; $4343
	ld b,e			; $4344
	ld a,$01		; $4345
	ld (de),a		; $4347
	call interactionSetAlwaysUpdateBit		; $4348
	call interactionInitGraphics		; $434b
	ld h,d			; $434e
	ld b,$03		; $434f
	ld l,$43		; $4351
	ld a,(hl)		; $4353
	or a			; $4354
	jr nz,_label_0a_016	; $4355
	ld b,$1d		; $4357
_label_0a_016:
	ld l,$49		; $4359
	ld (hl),b		; $435b
	ld l,$50		; $435c
	ld (hl),$0f		; $435e
	ld l,$46		; $4360
	ld (hl),$46		; $4362
	jp objectSetVisible80		; $4364
	ld e,$42		; $4367
	ld a,(de)		; $4369
	or a			; $436a
	jr nz,_label_0a_017	; $436b
_label_0a_017:
	call interactionDecCounter1		; $436d
	jp z,interactionDelete		; $4370
	call objectApplySpeed		; $4373
	ld e,$70		; $4376
	ld (de),a		; $4378
	ld a,(wFrameCounter)		; $4379
	and $07			; $437c
	ret nz			; $437e
	push de			; $437f
	ld h,d			; $4380
	ld a,(wFrameCounter)		; $4381
	and $38			; $4384
	swap a			; $4386
	rlca			; $4388
	ld de,$4398		; $4389
	call addAToDe		; $438c
	ld a,(de)		; $438f
	ld l,$70		; $4390
	add (hl)		; $4392
	ld l,$4d		; $4393
	ld (hl),a		; $4395
	pop de			; $4396
	ret			; $4397
	rst $38			; $4398
	cp $ff			; $4399
	nop			; $439b
	ld bc,$0102		; $439c
	nop			; $439f

interactionCodeac:
	ld a,$28		; $43a0
	call checkGlobalFlag		; $43a2
	jp nz,interactionDelete		; $43a5
	call $4448		; $43a8
	call $43b9		; $43ab
	call $445d		; $43ae
	ld hl,$cc69		; $43b1
	res 0,(hl)		; $43b4
	jp interactionDelete		; $43b6
	ld a,($cc69)		; $43b9
	bit 0,a			; $43bc
	ret z			; $43be
	ld hl,$c6db		; $43bf
	ld a,(hl)		; $43c2
	ld a,(hl)		; $43c3
	rst_jumpTable			; $43c4
	reti			; $43c5
	ld b,e			; $43c6
	ld ($f243),a		; $43c7
	ld b,e			; $43ca
.DB $f4				; $43cb
	ld b,e			; $43cc
.DB $fc				; $43cd
	ld b,e			; $43ce
	ld a,($ff00+c)		; $43cf
	ld b,e			; $43d0
	ld a,($ff00+c)		; $43d1
	ld b,e			; $43d2
	ld ($f443),a		; $43d3
	ld b,e			; $43d6
.DB $fc				; $43d7
	ld b,e			; $43d8
_label_0a_018:
	ld a,($c6db)		; $43d9
	ld ($c6da),a		; $43dc
	cp $04			; $43df
	jp z,$4410		; $43e1
	cp $07			; $43e4
	jp z,$4415		; $43e6
	ret			; $43e9
	ld e,$78		; $43ea
	ld a,(de)		; $43ec
	cp $02			; $43ed
	ret c			; $43ef
	jr _label_0a_018		; $43f0
	jr _label_0a_018		; $43f2
	ld e,$78		; $43f4
	ld a,(de)		; $43f6
	cp $04			; $43f7
	ret c			; $43f9
	jr _label_0a_018		; $43fa
	ld e,$78		; $43fc
	ld a,(de)		; $43fe
	cp $06			; $43ff
	ret c			; $4401
	jr _label_0a_018		; $4402

;;
; This is called on file initialization. In a linked game, wChildStatus will be nonzero if
; he was given a name, so he will start at stage 5.
; @addr{4404}
initializeChildOnGameStart:
	ld hl,wChildStatus		; $4404
	ld a,(hl)		; $4407
	or a			; $4408
	ret z			; $4409

	ld a,$05		; $440a
	ld l,<wChildStage		; $440c
	ldi (hl),a		; $440e
	ldi (hl),a		; $440f

	ld hl,$4430		; $4410
	jr _label_0a_019		; $4413
	ld a,($c6de)		; $4415
	add a			; $4418
	ld b,a			; $4419
	add a			; $441a
	add b			; $441b
	ld hl,$4436		; $441c
	rst_addAToHl			; $441f
_label_0a_019:
	ld a,($c60f)		; $4420
_label_0a_020:
	cp (hl)			; $4423
	jr nc,_label_0a_021	; $4424
	inc hl			; $4426
	inc hl			; $4427
	jr _label_0a_020		; $4428
_label_0a_021:
	inc hl			; $442a
	ld a,(hl)		; $442b
	ld ($c6de),a		; $442c
	ret			; $442f
	dec bc			; $4430
	nop			; $4431
	ld b,$01		; $4432
	nop			; $4434
	ld (bc),a		; $4435
	ld a,(de)		; $4436
	ld (bc),a		; $4437
	dec d			; $4438
	ld bc,$0000		; $4439
	inc de			; $443c
	ld (bc),a		; $443d
	rrca			; $443e
	nop			; $443f
	nop			; $4440
	inc bc			; $4441
	ld c,$01		; $4442
	ld a,(bc)		; $4444
	nop			; $4445
	nop			; $4446
	inc bc			; $4447
	ld a,$40		; $4448
	call checkTreasureObtained		; $444a
	jr c,_label_0a_022	; $444d
	xor a			; $444f
_label_0a_022:
	ld h,d			; $4450
	ld l,$78		; $4451
	ld (hl),$00		; $4453
_label_0a_023:
	add a			; $4455
	jr nc,_label_0a_024	; $4456
	inc (hl)		; $4458
_label_0a_024:
	or a			; $4459
	jr nz,_label_0a_023	; $445a
	ret			; $445c
	ld e,$42		; $445d
	ld a,(de)		; $445f
	or a			; $4460
	ld hl,$4497		; $4461
	jr z,_label_0a_025	; $4464
	ld hl,$44d5		; $4466
_label_0a_025:
	ld a,($c6da)		; $4469
	cp $04			; $446c
	jr c,_label_0a_026	; $446e
	rst_addDoubleIndex			; $4470
	ldi a,(hl)		; $4471
	ld h,(hl)		; $4472
	ld l,a			; $4473
	ld a,($c6de)		; $4474
_label_0a_026:
	rst_addDoubleIndex			; $4477
	ldi a,(hl)		; $4478
	ld b,(hl)		; $4479
	ld c,a			; $447a
_label_0a_027:
	ld a,(bc)		; $447b
	or a			; $447c
	ret z			; $447d
	call getFreeInteractionSlot		; $447e
	ret nz			; $4481
	ld a,(bc)		; $4482
	ldi (hl),a		; $4483
	inc bc			; $4484
	ld a,(bc)		; $4485
	ldi (hl),a		; $4486
	inc bc			; $4487
	ld a,(bc)		; $4488
	ldi (hl),a		; $4489
	inc bc			; $448a
	ld l,$4b		; $448b
	ld a,(bc)		; $448d
	ld (hl),a		; $448e
	inc bc			; $448f
	ld l,$4d		; $4490
	ld a,(bc)		; $4492
	ld (hl),a		; $4493
	inc bc			; $4494
	jr _label_0a_027		; $4495
	inc de			; $4497
	ld b,l			; $4498
	ld e,$45		; $4499
	ldi a,(hl)		; $449b
	ld b,l			; $449c
	dec sp			; $449d
	ld b,l			; $449e
	xor e			; $449f
	ld b,h			; $44a0
	or c			; $44a1
	ld b,h			; $44a2
	or a			; $44a3
	ld b,h			; $44a4
	cp l			; $44a5
	ld b,h			; $44a6
	push bc			; $44a7
	ld b,h			; $44a8
	call $4744		; $44a9
	ld b,l			; $44ac
	ld d,d			; $44ad
	ld b,l			; $44ae
	ld e,l			; $44af
	ld b,l			; $44b0
	ld l,(hl)		; $44b1
	ld b,l			; $44b2
	ld a,(hl)		; $44b3
	ld b,l			; $44b4
	adc (hl)		; $44b5
	ld b,l			; $44b6
	sbc a			; $44b7
	ld b,l			; $44b8
	sbc a			; $44b9
	ld b,l			; $44ba
	and b			; $44bb
	ld b,l			; $44bc
	pop de			; $44bd
	ld b,l			; $44be
	rst_addAToHl			; $44bf
	ld b,l			; $44c0
.DB $dd				; $44c1
	ld b,l			; $44c2
	sbc $45			; $44c3
	dec d			; $44c5
	ld b,(hl)		; $44c6
	jr nz,_label_0a_028	; $44c7
	ld h,$46		; $44c9
	inc l			; $44cb
	ld b,(hl)		; $44cc
	ld e,c			; $44cd
	ld b,(hl)		; $44ce
	ld h,h			; $44cf
	ld b,(hl)		; $44d0
	ld l,a			; $44d1
	ld b,(hl)		; $44d2
	ld (hl),l		; $44d3
	ld b,(hl)		; $44d4
	dec e			; $44d5
	ld b,l			; $44d6
	inc h			; $44d7
	ld b,l			; $44d8
	dec (hl)		; $44d9
	ld b,l			; $44da
	ld b,c			; $44db
	ld b,l			; $44dc
	jp hl			; $44dd
	ld b,h			; $44de
	rst $28			; $44df
	ld b,h			; $44e0
	push af			; $44e1
	ld b,h			; $44e2
	ei			; $44e3
	ld b,h			; $44e4
	inc bc			; $44e5
	ld b,l			; $44e6
	dec bc			; $44e7
	ld b,l			; $44e8
	ld l,b			; $44e9
	ld b,l			; $44ea
	ld l,b			; $44eb
	ld b,l			; $44ec
	ld l,b			; $44ed
	ld b,l			; $44ee
	sbc (hl)		; $44ef
	ld b,l			; $44f0
	sbc (hl)		; $44f1
	ld b,l			; $44f2
	sbc (hl)		; $44f3
	ld b,l			; $44f4
	and (hl)		; $44f5
	ld b,l			; $44f6
	or (hl)			; $44f7
	ld b,l			; $44f8
	add $45			; $44f9
	jp hl			; $44fb
	ld b,l			; $44fc
.DB $f4				; $44fd
	ld b,l			; $44fe
	rst $38			; $44ff
	ld b,l			; $4500
	rrca			; $4501
	ld b,(hl)		; $4502
	ldd (hl),a		; $4503
	ld b,(hl)		; $4504
	jr c,_label_0a_033	; $4505
	ld b,e			; $4507
	ld b,(hl)		; $4508
	ld c,(hl)		; $4509
	ld b,(hl)		; $450a
	add b			; $450b
	ld b,(hl)		; $450c
	add (hl)		; $450d
	ld b,(hl)		; $450e
_label_0a_028:
	adc h			; $450f
	ld b,(hl)		; $4510
	sub a			; $4511
	ld b,(hl)		; $4512
	jr z,_label_0a_029	; $4513
_label_0a_029:
	nop			; $4515
	ld c,b			; $4516
	ld c,b			; $4517
	dec hl			; $4518
	nop			; $4519
	nop			; $451a
	jr c,_label_0a_040	; $451b
	nop			; $451d
	dec hl			; $451e
	ld bc,$1800		; $451f
	ld c,b			; $4522
	nop			; $4523
	jr z,_label_0a_030	; $4524
	nop			; $4526
_label_0a_030:
	jr c,_label_0a_038	; $4527
	nop			; $4529
	dec hl			; $452a
	ld (bc),a		; $452b
	nop			; $452c
	jr _label_0a_036		; $452d
	dec (hl)		; $452f
	rlca			; $4530
	nop			; $4531
	stop			; $4532
	jr c,_label_0a_031	; $4533
_label_0a_031:
	jr z,$02		; $4535
	nop			; $4537
	jr c,$58		; $4538
	nop			; $453a
	dec hl			; $453b
	inc bc			; $453c
	nop			; $453d
	jr c,$78		; $453e
	nop			; $4540
	jr z,_label_0a_032	; $4541
	nop			; $4543
	jr c,_label_0a_042	; $4544
_label_0a_032:
	nop			; $4546
	dec hl			; $4547
	inc b			; $4548
	nop			; $4549
	jr c,_label_0a_045	; $454a
	dec (hl)		; $454c
_label_0a_033:
	nop			; $454d
	ld bc,$6838		; $454e
	nop			; $4551
	dec hl			; $4552
	inc b			; $4553
	nop			; $4554
	jr c,$78		; $4555
	dec (hl)		; $4557
	ld bc,$3802		; $4558
	jr _label_0a_034		; $455b
_label_0a_034:
	dec hl			; $455d
	inc b			; $455e
	nop			; $455f
	jr c,_label_0a_049	; $4560
	dec (hl)		; $4562
	ld (bc),a		; $4563
	inc bc			; $4564
	jr nz,_label_0a_043	; $4565
	nop			; $4567
	jr z,_label_0a_035	; $4568
	nop			; $456a
	jr c,_label_0a_046	; $456b
	nop			; $456d
_label_0a_035:
	dec hl			; $456e
	dec b			; $456f
	nop			; $4570
	jr c,_label_0a_051	; $4571
	jr z,_label_0a_037	; $4573
	nop			; $4575
	ld e,b			; $4576
_label_0a_036:
	adc b			; $4577
	dec (hl)		; $4578
	nop			; $4579
_label_0a_037:
	inc b			; $457a
	jr c,$68		; $457b
	nop			; $457d
	dec hl			; $457e
	dec b			; $457f
	nop			; $4580
_label_0a_038:
	jr c,_label_0a_052	; $4581
	jr z,$05		; $4583
	nop			; $4585
	ld e,b			; $4586
	adc b			; $4587
	dec (hl)		; $4588
	ld bc,$3805		; $4589
	jr _label_0a_039		; $458c
_label_0a_039:
	dec hl			; $458e
	dec b			; $458f
	nop			; $4590
	jr c,_label_0a_054	; $4591
	jr z,_label_0a_041	; $4593
_label_0a_040:
	nop			; $4595
	ld e,b			; $4596
	adc b			; $4597
	dec (hl)		; $4598
	ld (bc),a		; $4599
_label_0a_041:
	ld b,$20		; $459a
	jr c,_label_0a_042	; $459c
_label_0a_042:
	nop			; $459e
_label_0a_043:
	nop			; $459f
	dec (hl)		; $45a0
	ld (bc),a		; $45a1
	add hl,bc		; $45a2
	jr nz,_label_0a_050	; $45a3
	nop			; $45a5
	dec hl			; $45a6
	ld b,$00		; $45a7
	ldi (hl),a		; $45a9
	ld e,b			; $45aa
	jr z,_label_0a_044	; $45ab
	nop			; $45ad
	jr c,$58		; $45ae
	dec (hl)		; $45b0
	nop			; $45b1
	rlca			; $45b2
_label_0a_044:
	jr c,$48		; $45b3
	nop			; $45b5
	dec hl			; $45b6
	ld b,$01		; $45b7
	ldi (hl),a		; $45b9
	ld e,b			; $45ba
	jr z,$06		; $45bb
	nop			; $45bd
	jr c,$58		; $45be
	dec (hl)		; $45c0
	ld bc,$1808		; $45c1
_label_0a_045:
	ld c,b			; $45c4
_label_0a_046:
	nop			; $45c5
	dec hl			; $45c6
	ld b,$02		; $45c7
	ldi (hl),a		; $45c9
	ld e,b			; $45ca
	jr z,_label_0a_047	; $45cb
	nop			; $45cd
	jr c,$58		; $45ce
	nop			; $45d0
	dec (hl)		; $45d1
	inc bc			; $45d2
_label_0a_047:
	ld a,(bc)		; $45d3
	inc h			; $45d4
	jr c,_label_0a_048	; $45d5
_label_0a_048:
	dec (hl)		; $45d7
	inc b			; $45d8
	dec bc			; $45d9
_label_0a_049:
	ld c,b			; $45da
	ld b,b			; $45db
	nop			; $45dc
_label_0a_050:
	nop			; $45dd
	dec hl			; $45de
	rlca			; $45df
	inc bc			; $45e0
	ld e,b			; $45e1
	adc b			; $45e2
	dec (hl)		; $45e3
	ld b,$0d		; $45e4
	jr c,_label_0a_060	; $45e6
	nop			; $45e8
	dec hl			; $45e9
	rlca			; $45ea
_label_0a_051:
	nop			; $45eb
	ldi (hl),a		; $45ec
	ld e,b			; $45ed
	jr z,$07		; $45ee
	nop			; $45f0
	jr c,_label_0a_057	; $45f1
	nop			; $45f3
	dec hl			; $45f4
	rlca			; $45f5
	ld bc,$5822		; $45f6
	jr z,_label_0a_053	; $45f9
_label_0a_052:
	nop			; $45fb
	jr c,$58		; $45fc
	nop			; $45fe
	dec hl			; $45ff
	rlca			; $4600
	ld (bc),a		; $4601
_label_0a_053:
	ld c,b			; $4602
	jr nc,_label_0a_055	; $4603
	rlca			; $4605
	nop			; $4606
	jr c,_label_0a_061	; $4607
	dec (hl)		; $4609
	dec b			; $460a
_label_0a_054:
	inc c			; $460b
	ldi (hl),a		; $460c
	ld e,b			; $460d
	nop			; $460e
	jr z,$07		; $460f
	nop			; $4611
	jr c,_label_0a_062	; $4612
	nop			; $4614
	dec hl			; $4615
	ld ($5800),sp		; $4616
	adc b			; $4619
	dec (hl)		; $461a
	inc bc			; $461b
	ld c,$44		; $461c
	ld a,b			; $461e
	nop			; $461f
	dec hl			; $4620
	ld ($3801),sp		; $4621
	ld a,b			; $4624
	nop			; $4625
	dec hl			; $4626
	ld ($3802),sp		; $4627
	ld a,b			; $462a
	nop			; $462b
	dec (hl)		; $462c
_label_0a_055:
	ld b,$11		; $462d
	inc d			; $462f
	ld h,$00		; $4630
	jr z,$08		; $4632
	nop			; $4634
	jr c,_label_0a_064	; $4635
	nop			; $4637
	jr z,_label_0a_056	; $4638
	nop			; $463a
	jr c,_label_0a_066	; $463b
	dec (hl)		; $463d
	inc b			; $463e
	rrca			; $463f
	jr $48			; $4640
_label_0a_056:
	nop			; $4642
	jr z,_label_0a_058	; $4643
	nop			; $4645
	ldd (hl),a		; $4646
	ld e,b			; $4647
	dec (hl)		; $4648
	dec b			; $4649
	stop			; $464a
_label_0a_057:
	ld c,b			; $464b
	ld e,b			; $464c
_label_0a_058:
	nop			; $464d
	jr z,$08		; $464e
	nop			; $4650
	jr c,_label_0a_069	; $4651
	dec hl			; $4653
	ld ($4803),sp		; $4654
	jr z,_label_0a_059	; $4657
_label_0a_059:
	dec hl			; $4659
	add hl,bc		; $465a
	nop			; $465b
	ld e,b			; $465c
	adc b			; $465d
_label_0a_060:
	dec (hl)		; $465e
	inc bc			; $465f
	ld (de),a		; $4660
_label_0a_061:
	ld b,h			; $4661
	ld a,b			; $4662
	nop			; $4663
	dec hl			; $4664
	add hl,bc		; $4665
	ld bc,$7838		; $4666
	dec (hl)		; $4669
	inc b			; $466a
	inc de			; $466b
_label_0a_062:
	ld c,b			; $466c
	ld b,b			; $466d
	nop			; $466e
	dec hl			; $466f
	add hl,bc		; $4670
	ld (bc),a		; $4671
	jr c,_label_0a_073	; $4672
	nop			; $4674
	dec hl			; $4675
	add hl,bc		; $4676
	inc bc			; $4677
	ld e,b			; $4678
	ld a,b			; $4679
	dec (hl)		; $467a
	ld b,$15		; $467b
	ld (hl),$68		; $467d
	nop			; $467f
	jr z,_label_0a_063	; $4680
	nop			; $4682
	jr c,$58		; $4683
	nop			; $4685
	jr z,_label_0a_065	; $4686
	nop			; $4688
	jr c,_label_0a_071	; $4689
_label_0a_063:
	nop			; $468b
	jr z,_label_0a_067	; $468c
	nop			; $468e
_label_0a_064:
	ldd (hl),a		; $468f
	ld e,b			; $4690
_label_0a_065:
	dec (hl)		; $4691
	dec b			; $4692
	inc d			; $4693
	ld c,b			; $4694
_label_0a_066:
	ld e,b			; $4695
	nop			; $4696
_label_0a_067:
	jr z,_label_0a_068	; $4697
	nop			; $4699
	jr c,_label_0a_074	; $469a
	nop			; $469c

interactionCodeb6:
	ld e,$44		; $469d
	ld a,(de)		; $469f
	rst_jumpTable			; $46a0
	or c			; $46a1
_label_0a_068:
	ld b,(hl)		; $46a2
	inc hl			; $46a3
	ld b,a			; $46a4
	dec sp			; $46a5
	ld b,a			; $46a6
	ld l,h			; $46a7
	ld b,a			; $46a8
	sub a			; $46a9
	ld b,a			; $46aa
_label_0a_069:
	cp b			; $46ab
	ld b,a			; $46ac
	ld (hl),b		; $46ad
	ld c,b			; $46ae
	dec bc			; $46af
	ld c,c			; $46b0
	ld e,$42		; $46b1
	ld a,(de)		; $46b3
	inc e			; $46b4
	ld (de),a		; $46b5
	ld hl,$c64a		; $46b6
	call checkFlag		; $46b9
	jr nz,_label_0a_072	; $46bc
	ld e,$7c		; $46be
	ld a,(de)		; $46c0
	or a			; $46c1
	jr nz,_label_0a_070	; $46c2
	ld a,$28		; $46c4
	call cpActiveRing		; $46c6
	jr nz,_label_0a_070	; $46c9
	ld a,$a2		; $46cb
	ld e,$7c		; $46cd
	ld (de),a		; $46cf
	call playSound		; $46d0
_label_0a_070:
	call objectGetTileAtPosition		; $46d3
	cp $e0			; $46d6
	ret nz			; $46d8
	call interactionIncState		; $46d9
	ld a,$0a		; $46dc
	call objectSetCollideRadius		; $46de
	ld e,$71		; $46e1
_label_0a_071:
	jp objectAddToAButtonSensitiveObjectList		; $46e3
_label_0a_072:
	ld a,(de)		; $46e6
	ld hl,$c64c		; $46e7
	rst_addAToHl			; $46ea
	ld a,(hl)		; $46eb
_label_0a_073:
	cp $28			; $46ec
	jr c,_label_0a_077	; $46ee
	call getFreePartSlot		; $46f0
	ret nz			; $46f3
_label_0a_074:
	ld (hl),$17		; $46f4
	inc l			; $46f6
	ld (hl),$01		; $46f7
	ld l,$d6		; $46f9
	ld a,$40		; $46fb
	ldi (hl),a		; $46fd
	ld (hl),d		; $46fe
	ld h,d			; $46ff
	ld l,$77		; $4700
	ld e,$4b		; $4702
	ld a,(de)		; $4704
	ldi (hl),a		; $4705
	add $f8			; $4706
	ld (de),a		; $4708
	ld e,$4d		; $4709
	ld a,(de)		; $470b
	ldi (hl),a		; $470c
	add $08			; $470d
	ld (de),a		; $470f
	ld a,$04		; $4710
	call objectSetCollideRadius		; $4712
	ld l,$44		; $4715
	ld (hl),$03		; $4717
	ld l,$42		; $4719
	ld (hl),$0a		; $471b
	call interactionInitGraphics		; $471d
	jp objectSetVisible83		; $4720
	ld e,$71		; $4723
	ld a,(de)		; $4725
	or a			; $4726
	ret z			; $4727
	xor a			; $4728
	ld (de),a		; $4729
	ld bc,$3509		; $472a
	ld a,($c6ba)		; $472d
	or a			; $4730
	jr z,_label_0a_075	; $4731
	call interactionIncState		; $4733
	ld c,$00		; $4736
_label_0a_075:
	jp showText		; $4738
	ld a,($cba5)		; $473b
	or a			; $473e
	jr z,_label_0a_076	; $473f
	ld a,$01		; $4741
	ld (de),a		; $4743
	ret			; $4744
_label_0a_076:
	call objectGetTileAtPosition		; $4745
	ld c,l			; $4748
	ld a,$f5		; $4749
	call setTile		; $474b
	ld e,$43		; $474e
	ld a,(de)		; $4750
	ld hl,$c64a		; $4751
	call setFlag		; $4754
	ld a,(de)		; $4757
	ld l,$4c		; $4758
	rst_addAToHl			; $475a
	ld (hl),$00		; $475b
	ld l,$ba		; $475d
	ld a,(hl)		; $475f
	sub $01			; $4760
	daa			; $4762
	ld (hl),a		; $4763
	ld a,$5e		; $4764
	call playSound		; $4766
_label_0a_077:
	jp interactionDelete		; $4769
	ld e,$6a		; $476c
	ld a,(de)		; $476e
	cp $ff			; $476f
	ret nz			; $4771
	ld a,$80		; $4772
	ld ($cca4),a		; $4774
	ld ($cc02),a		; $4777
	ld h,d			; $477a
	ld l,$44		; $477b
	ld (hl),$04		; $477d
	ld a,$06		; $477f
	call objectSetCollideRadius		; $4781
	ld bc,$fec0		; $4784
	call objectSetSpeedZ		; $4787
	ld l,$50		; $478a
	ld (hl),$28		; $478c
	call objectGetAngleTowardLink		; $478e
	ld e,$49		; $4791
	ld (de),a		; $4793
	jp objectSetVisible80		; $4794
	ld a,($cc34)		; $4797
	or a			; $479a
	jp nz,interactionDelete		; $479b
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $479e
	jr c,_label_0a_078	; $47a1
	call objectApplySpeed		; $47a3
	ld c,$20		; $47a6
	jp objectUpdateSpeedZ_paramC		; $47a8
_label_0a_078:
	call interactionIncState		; $47ab
	ld l,$5a		; $47ae
	res 7,(hl)		; $47b0
	ld bc,$3501		; $47b2
	jp showText		; $47b5
	ld hl,$c649		; $47b8
	bit 0,(hl)		; $47bb
	jr nz,_label_0a_079	; $47bd
	set 0,(hl)		; $47bf
	ld b,$04		; $47c1
	jr _label_0a_085		; $47c3
_label_0a_079:
	ld c,$00		; $47c5
	ld hl,$c65d		; $47c7
	ldd a,(hl)		; $47ca
	srl a			; $47cb
	jr nz,_label_0a_081	; $47cd
	ld a,(hl)		; $47cf
	rra			; $47d0
	ld hl,$4978		; $47d1
_label_0a_080:
	cp (hl)			; $47d4
	jr nc,_label_0a_081	; $47d5
	inc hl			; $47d7
	inc c			; $47d8
	jr _label_0a_080		; $47d9
_label_0a_081:
	ld e,$43		; $47db
	ld a,(de)		; $47dd
	ld hl,$4991		; $47de
	rst_addAToHl			; $47e1
	ld a,(hl)		; $47e2
	rst_addAToHl			; $47e3
	ld a,c			; $47e4
	add a			; $47e5
	ld c,a			; $47e6
	add a			; $47e7
	add a			; $47e8
	add c			; $47e9
	rst_addAToHl			; $47ea
	call getRandomIndexFromProbabilityDistribution		; $47eb
	ld a,b			; $47ee
	cp $06			; $47ef
	jr nz,_label_0a_082	; $47f1
	ld a,$2f		; $47f3
	call checkTreasureObtained		; $47f5
	jr nc,_label_0a_084	; $47f8
	ld hl,$c6a3		; $47fa
	ldd a,(hl)		; $47fd
	ld (hl),a		; $47fe
	jr _label_0a_084		; $47ff
_label_0a_082:
	cp $00			; $4801
	jr nz,_label_0a_084	; $4803
	ld hl,$c649		; $4805
	bit 1,(hl)		; $4808
	jr z,_label_0a_083	; $480a
	inc b			; $480c
_label_0a_083:
	set 1,(hl)		; $480d
_label_0a_084:
	ld hl,$c65c		; $480f
	ld a,(hl)		; $4812
	sub $c8			; $4813
	ldi (hl),a		; $4815
	ld a,(hl)		; $4816
	sbc $00			; $4817
	ld (hl),a		; $4819
	jr nc,_label_0a_085	; $481a
	xor a			; $481c
	ldd (hl),a		; $481d
	ld (hl),a		; $481e
_label_0a_085:
	ld a,b			; $481f
	ld e,$42		; $4820
	ld (de),a		; $4822
	ld hl,$497d		; $4823
	rst_addDoubleIndex			; $4826
	ldi a,(hl)		; $4827
	ld c,(hl)		; $4828
	cp $2d			; $4829
	jr nz,_label_0a_086	; $482b
	call getRandomRingOfGivenTier		; $482d
_label_0a_086:
	ld b,a			; $4830
	call giveTreasure		; $4831
	ld hl,$cc6a		; $4834
	ld a,$04		; $4837
	ldi (hl),a		; $4839
	ld (hl),$01		; $483a
	ld hl,$d00b		; $483c
	ld bc,$f300		; $483f
	call objectTakePositionWithOffset		; $4842
	call interactionIncState		; $4845
	ld l,$5a		; $4848
	set 7,(hl)		; $484a
	ld e,$42		; $484c
	ld a,(de)		; $484e
	cp $00			; $484f
	ld a,$4c		; $4851
	call nz,playSound		; $4853
	call interactionInitGraphics		; $4856
	ld e,$42		; $4859
	ld a,(de)		; $485b
	ld hl,$4866		; $485c
	rst_addAToHl			; $485f
	ld c,(hl)		; $4860
	ld b,$35		; $4861
	jp showText		; $4863
	inc bc			; $4866
	inc b			; $4867
	inc b			; $4868
	inc b			; $4869
	inc b			; $486a
	inc b			; $486b
	dec b			; $486c
	ld b,$08		; $486d
	rlca			; $486f
	ld hl,$c6a5		; $4870
	ld a,($cbe6)		; $4873
	cp (hl)			; $4876
	ret nz			; $4877
	inc l			; $4878
	ld a,($cbe7)		; $4879
	cp (hl)			; $487c
	ret nz			; $487d
	ld l,$a2		; $487e
	ld a,($cbe4)		; $4880
	cp (hl)			; $4883
	ret nz			; $4884
	ld a,$91		; $4885
	call playSound		; $4887
	ld e,$43		; $488a
	ld a,(de)		; $488c
	ld hl,$4b14		; $488d
	rst_addAToHl			; $4890
	ld a,(hl)		; $4891
	push af			; $4892
	sub $39			; $4893
	ld ($cc18),a		; $4895
	ld a,$3d		; $4898
	call loadGfxHeader		; $489a
	pop af			; $489d
	cp $3d			; $489e
	call nz,loadGfxHeader		; $48a0
	ldh a,(<hActiveObject)	; $48a3
	ld d,a			; $48a5
	ld h,d			; $48a6
	ld l,$77		; $48a7
	ld e,$4b		; $48a9
	ldi a,(hl)		; $48ab
	ld (de),a		; $48ac
	ld e,$4d		; $48ad
	ldi a,(hl)		; $48af
	ld (de),a		; $48b0
	ld l,$5a		; $48b1
	res 7,(hl)		; $48b3
	call objectGetTileCollisions		; $48b5
	xor a			; $48b8
	ldi (hl),a		; $48b9
	ldd (hl),a		; $48ba
	ld a,l			; $48bb
	sub $10			; $48bc
	ld l,a			; $48be
	xor a			; $48bf
	ldi (hl),a		; $48c0
	ldd (hl),a		; $48c1
	ld h,a			; $48c2
	ld e,l			; $48c3
	ld a,l			; $48c4
	and $f0			; $48c5
	ld l,a			; $48c7
	ld a,e			; $48c8
	and $0f			; $48c9
	sla l			; $48cb
	rl h			; $48cd
	add l			; $48cf
	ld l,a			; $48d0
	sla l			; $48d1
	rl h			; $48d3
	ld bc,$d800		; $48d5
	add hl,bc		; $48d8
	ld e,$7a		; $48d9
	ld a,l			; $48db
	ld (de),a		; $48dc
	inc e			; $48dd
	ld a,h			; $48de
	ld (de),a		; $48df
	ld bc,$0400		; $48e0
	add hl,bc		; $48e3
	ld a,($ff00+$70)	; $48e4
	push af			; $48e6
	ld a,$03		; $48e7
	ld ($ff00+$70),a	; $48e9
	ld b,$04		; $48eb
_label_0a_087:
	ld c,$04		; $48ed
	push bc			; $48ef
_label_0a_088:
	ld a,(hl)		; $48f0
	and $f0			; $48f1
	or $04			; $48f3
	ldi (hl),a		; $48f5
	dec c			; $48f6
	jr nz,_label_0a_088	; $48f7
	ld bc,$001c		; $48f9
	add hl,bc		; $48fc
	pop bc			; $48fd
	dec b			; $48fe
	jr nz,_label_0a_087	; $48ff
	pop af			; $4901
	ld ($ff00+$70),a	; $4902
	call interactionIncState		; $4904
	ld l,$46		; $4907
	ld (hl),$08		; $4909
	ld h,d			; $490b
	ld l,$46		; $490c
	ld a,(hl)		; $490e
	or a			; $490f
	jr z,_label_0a_089	; $4910
	dec a			; $4912
	ld (hl),a		; $4913
	ret nz			; $4914
_label_0a_089:
	ld a,$08		; $4915
	ldi (hl),a		; $4917
	ld a,(hl)		; $4918
	inc a			; $4919
	ld (hl),a		; $491a
	cp $0a			; $491b
	jr nc,_label_0a_092	; $491d
	ld hl,$4a9a		; $491f
	rst_addAToHl			; $4922
	ld a,(hl)		; $4923
	rst_addAToHl			; $4924
	ld e,$7a		; $4925
	ld a,(de)		; $4927
	ld c,a			; $4928
	inc e			; $4929
	ld a,(de)		; $492a
	ld d,a			; $492b
	ld e,c			; $492c
	push hl			; $492d
	push de			; $492e
	pop hl			; $492f
	pop de			; $4930
	ld a,($ff00+$70)	; $4931
	push af			; $4933
	ld a,$03		; $4934
	ld ($ff00+$70),a	; $4936
	ld b,$04		; $4938
_label_0a_090:
	ld c,$04		; $493a
	push bc			; $493c
_label_0a_091:
	ld a,(de)		; $493d
	ldi (hl),a		; $493e
	inc de			; $493f
	dec c			; $4940
	jr nz,_label_0a_091	; $4941
	ld bc,$001c		; $4943
	add hl,bc		; $4946
	pop bc			; $4947
	dec b			; $4948
	jr nz,_label_0a_090	; $4949
	pop af			; $494b
	ld ($ff00+$70),a	; $494c
	ld a,UNCMP_GFXH_29		; $494e
	call loadUncompressedGfxHeader		; $4950
	ldh a,(<hActiveObject)	; $4953
	ld d,a			; $4955
	ld e,$47		; $4956
	ld a,(de)		; $4958
	add $1f			; $4959
	call loadUncompressedGfxHeader		; $495b
	call reloadTileMap		; $495e
	ldh a,(<hActiveObject)	; $4961
	ld d,a			; $4963
	ret			; $4964
_label_0a_092:
	xor a			; $4965
	ld ($cca4),a		; $4966
	ld ($cc02),a		; $4969
	ld e,$43		; $496c
	ld a,(de)		; $496e
	ld hl,$c64a		; $496f
	call unsetFlag		; $4972
	jp interactionDelete		; $4975
	sub (hl)		; $4978
	ld h,h			; $4979
	inc a			; $497a
	inc d			; $497b
	nop			; $497c
	dec hl			; $497d
	ld bc,$002d		; $497e
	dec l			; $4981
	ld bc,$022d		; $4982
	dec l			; $4985
	inc bc			; $4986
	dec l			; $4987
	inc b			; $4988
	cpl			; $4989
	ld bc,$0d28		; $498a
	add hl,hl		; $498d
	jr _label_0a_093		; $498e
	inc d			; $4990
	ld b,d			; $4991
	rrca			; $4992
	ld c,$a3		; $4993
	ld (hl),b		; $4995
	and c			; $4996
	ld l,(hl)		; $4997
	pop de			; $4998
	ldd a,(hl)		; $4999
	ld l,e			; $499a
	adc $9b			; $499b
	ld l,b			; $499d
	ld h,a			; $499e
	sbc b			; $499f
	ret			; $49a0
	ld e,d			; $49a1
	ld b,b			; $49a2
	ld h,$00		; $49a3
	nop			; $49a5
	ld a,(de)		; $49a6
	dec c			; $49a7
	dec c			; $49a8
	inc c			; $49a9
	nop			; $49aa
	ld b,b			; $49ab
	ld h,$26		; $49ac
	nop			; $49ae
	nop			; $49af
	nop			; $49b0
	ld b,b			; $49b1
	ld h,$0e		; $49b2
	nop			; $49b4
	ld h,$33		; $49b5
	inc sp			; $49b7
	nop			; $49b8
_label_0a_093:
	nop			; $49b9
	nop			; $49ba
	ld b,b			; $49bb
	ld h,$0e		; $49bc
	nop			; $49be
	ld a,(de)		; $49bf
	ld h,$26		; $49c0
	nop			; $49c2
	nop			; $49c3
	nop			; $49c4
	ld b,b			; $49c5
	inc (hl)		; $49c6
	ld h,$00		; $49c7
	inc c			; $49c9
	ld a,(de)		; $49ca
	ld a,(de)		; $49cb
	nop			; $49cc
	nop			; $49cd
	nop			; $49ce
	ld c,l			; $49cf
	inc sp			; $49d0
	inc sp			; $49d1
	dec c			; $49d2
	ld a,(de)		; $49d3
	ld h,$5a		; $49d4
	inc sp			; $49d6
	nop			; $49d7
	nop			; $49d8
	add hl,de		; $49d9
	dec c			; $49da
	dec c			; $49db
	nop			; $49dc
	dec c			; $49dd
	ld a,(de)		; $49de
	inc sp			; $49df
	ld b,b			; $49e0
	nop			; $49e1
	nop			; $49e2
	ld h,$33		; $49e3
	dec c			; $49e5
	nop			; $49e6
	ld ($3312),sp		; $49e7
	inc sp			; $49ea
	nop			; $49eb
	nop			; $49ec
	ld h,$33		; $49ed
	ld a,(de)		; $49ef
	dec c			; $49f0
	dec b			; $49f1
	dec c			; $49f2
	ld a,(de)		; $49f3
	dec sp			; $49f4
	nop			; $49f5
	nop			; $49f6
	ld h,$33		; $49f7
	ld h,$1a		; $49f9
	inc bc			; $49fb
	ld ($190f),sp		; $49fc
	nop			; $49ff
	nop			; $4a00
	ld a,(de)		; $4a01
	ld b,b			; $4a02
	ld c,l			; $4a03
	ld h,$00		; $4a04
	nop			; $4a06
	ld h,$4d		; $4a07
	ld h,(hl)		; $4a09
	nop			; $4a0a
	dec c			; $4a0b
	dec c			; $4a0c
	dec c			; $4a0d
	nop			; $4a0e
	nop			; $4a0f
	nop			; $4a10
	ld a,(de)		; $4a11
	ldd (hl),a		; $4a12
	ld c,l			; $4a13
	nop			; $4a14
	inc sp			; $4a15
	ld a,(de)		; $4a16
	ld a,(de)		; $4a17
	nop			; $4a18
	nop			; $4a19
	nop			; $4a1a
	dec c			; $4a1b
	ld a,(de)		; $4a1c
	ld h,$00		; $4a1d
	ld b,b			; $4a1f
	inc sp			; $4a20
	inc sp			; $4a21
	dec c			; $4a22
	nop			; $4a23
	nop			; $4a24
	ld ($1a12),sp		; $4a25
	nop			; $4a28
	ld b,b			; $4a29
	inc sp			; $4a2a
	inc sp			; $4a2b
	ld h,$00		; $4a2c
	nop			; $4a2e
	inc bc			; $4a2f
	dec c			; $4a30
	dec c			; $4a31
	nop			; $4a32
	ld a,(de)		; $4a33
	ld c,e			; $4a34
	ld c,e			; $4a35
	inc sp			; $4a36
	nop			; $4a37
	nop			; $4a38
	nop			; $4a39
	ld e,d			; $4a3a
	ld e,d			; $4a3b
	nop			; $4a3c
	ld a,(de)		; $4a3d
	ld a,(de)		; $4a3e
	inc c			; $4a3f
	inc c			; $4a40
	nop			; $4a41
	nop			; $4a42
	nop			; $4a43
	inc sp			; $4a44
	inc sp			; $4a45
	nop			; $4a46
	inc sp			; $4a47
	inc sp			; $4a48
	ld a,(de)		; $4a49
	ld a,(de)		; $4a4a
	nop			; $4a4b
	nop			; $4a4c
	nop			; $4a4d
	ld h,$26		; $4a4e
	nop			; $4a50
	ld h,$33		; $4a51
	inc (hl)		; $4a53
	daa			; $4a54
	nop			; $4a55
	nop			; $4a56
	nop			; $4a57
	ld a,(de)		; $4a58
	ld a,(de)		; $4a59
	nop			; $4a5a
	ld a,(de)		; $4a5b
	ld c,l			; $4a5c
	ldd (hl),a		; $4a5d
	inc sp			; $4a5e
	nop			; $4a5f
	nop			; $4a60
	nop			; $4a61
	dec c			; $4a62
	dec c			; $4a63
	nop			; $4a64
	ld a,(de)		; $4a65
	ld b,b			; $4a66
	ld b,b			; $4a67
	ld c,h			; $4a68
	nop			; $4a69
	nop			; $4a6a
	nop			; $4a6b
	ld b,b			; $4a6c
	inc (hl)		; $4a6d
	nop			; $4a6e
	ld h,$26		; $4a6f
	ld h,$1a		; $4a71
	nop			; $4a73
	nop			; $4a74
	nop			; $4a75
	ld h,$26		; $4a76
	nop			; $4a78
	ld h,$33		; $4a79
	inc (hl)		; $4a7b
	daa			; $4a7c
	nop			; $4a7d
	nop			; $4a7e
	nop			; $4a7f
	ld a,(de)		; $4a80
	ld h,$00		; $4a81
	ld h,$33		; $4a83
	inc (hl)		; $4a85
	inc sp			; $4a86
	nop			; $4a87
	nop			; $4a88
	nop			; $4a89
	ld (de),a		; $4a8a
	ld a,(de)		; $4a8b
	nop			; $4a8c
	ld hl,$4033		; $4a8d
	ld b,b			; $4a90
	nop			; $4a91
	nop			; $4a92
	nop			; $4a93
	dec c			; $4a94
	dec c			; $4a95
	nop			; $4a96
	dec c			; $4a97
	ld b,b			; $4a98
	ld c,h			; $4a99
	ld c,l			; $4a9a
	add hl,bc		; $4a9b
	ld ($2617),sp		; $4a9c
	dec (hl)		; $4a9f
	ld b,h			; $4aa0
	ld b,e			; $4aa1
	ld d,d			; $4aa2
	ld h,c			; $4aa3
	jr nz,$21		; $4aa4
	ldi (hl),a		; $4aa6
	inc hl			; $4aa7
	inc h			; $4aa8
	dec h			; $4aa9
	ld h,$27		; $4aaa
	jr z,$29		; $4aac
	ldi a,(hl)		; $4aae
	dec hl			; $4aaf
	inc l			; $4ab0
	dec l			; $4ab1
	ld l,$2f		; $4ab2
	jr nz,$21		; $4ab4
	jr nz,_label_0a_094	; $4ab6
	inc h			; $4ab8
	dec h			; $4ab9
	ld h,$27		; $4aba
	jr z,$29		; $4abc
	ldi a,(hl)		; $4abe
	dec hl			; $4abf
	jr nz,_label_0a_095	; $4ac0
	dec l			; $4ac2
	ld l,$20		; $4ac3
	ld hl,$2120		; $4ac5
	inc h			; $4ac8
	dec h			; $4ac9
	ld h,$27		; $4aca
	jr z,$29		; $4acc
	ldi a,(hl)		; $4ace
	dec hl			; $4acf
	ldi (hl),a		; $4ad0
	inc l			; $4ad1
	dec l			; $4ad2
	inc hl			; $4ad3
	jr nz,$21		; $4ad4
	jr nz,_label_0a_096	; $4ad6
	ldi (hl),a		; $4ad8
_label_0a_094:
	inc h			; $4ad9
	dec h			; $4ada
	inc hl			; $4adb
	jr nz,_label_0a_097	; $4adc
	daa			; $4ade
	ld hl,$2822		; $4adf
	add hl,hl		; $4ae2
	inc hl			; $4ae3
	jr nz,$21		; $4ae4
	jr nz,_label_0a_098	; $4ae6
	ldi (hl),a		; $4ae8
	inc hl			; $4ae9
	ldi (hl),a		; $4aea
	inc hl			; $4aeb
	jr nz,_label_0a_099	; $4aec
_label_0a_095:
	dec h			; $4aee
	ld hl,$2622		; $4aef
	daa			; $4af2
	inc hl			; $4af3
	jr nz,_label_0a_100	; $4af4
	jr nz,_label_0a_101	; $4af6
	ldi (hl),a		; $4af8
_label_0a_096:
	inc hl			; $4af9
	ldi (hl),a		; $4afa
	inc hl			; $4afb
	jr nz,_label_0a_102	; $4afc
	jr nz,_label_0a_103	; $4afe
	ldi (hl),a		; $4b00
	inc h			; $4b01
	dec h			; $4b02
	inc hl			; $4b03
_label_0a_097:
	jr nz,_label_0a_104	; $4b04
	jr nz,_label_0a_105	; $4b06
	ldi (hl),a		; $4b08
_label_0a_098:
	inc hl			; $4b09
	ldi (hl),a		; $4b0a
	inc hl			; $4b0b
	jr nz,_label_0a_106	; $4b0c
	jr nz,$21		; $4b0e
	ldi (hl),a		; $4b10
	inc hl			; $4b11
_label_0a_099:
	ldi (hl),a		; $4b12
	inc hl			; $4b13
	dec a			; $4b14
	dec a			; $4b15
	dec a			; $4b16
_label_0a_100:
	dec a			; $4b17
	ccf			; $4b18
_label_0a_101:
	dec a			; $4b19
	dec a			; $4b1a
	dec a			; $4b1b
	dec a			; $4b1c
	dec a			; $4b1d
	dec a			; $4b1e
_label_0a_102:
	dec a			; $4b1f
	dec a			; $4b20
_label_0a_103:
	ld a,$3d		; $4b21
	dec a			; $4b23

interactionCodeb7:
	ld e,$44		; $4b24
	ld a,(de)		; $4b26
_label_0a_104:
	rst_jumpTable			; $4b27
	inc l			; $4b28
_label_0a_105:
	ld c,e			; $4b29
	cp b			; $4b2a
	dec h			; $4b2b
	ld a,$01		; $4b2c
	ld (de),a		; $4b2e
_label_0a_106:
	call interactionInitGraphics		; $4b2f
	jp objectSetVisible82		; $4b32

interactionCodec0:
	ld e,$44		; $4b35
	ld a,(de)		; $4b37
	rst_jumpTable			; $4b38
	dec a			; $4b39
	ld c,e			; $4b3a
	ld b,(hl)		; $4b3b
	ld c,e			; $4b3c
	ld a,$01		; $4b3d
	ld (de),a		; $4b3f
	call interactionInitGraphics		; $4b40
	jp objectSetVisible80		; $4b43
	call interactionAnimate		; $4b46
	ld a,$00		; $4b49
	call objectGetRelatedObject1Var		; $4b4b
	ld l,$01		; $4b4e
	ld a,(hl)		; $4b50
	cp $11			; $4b51
	jp nz,interactionDelete		; $4b53
	ld e,$48		; $4b56
	ld a,(de)		; $4b58
	ld l,$08		; $4b59
	cp (hl)			; $4b5b
	ld a,(hl)		; $4b5c
	jr z,_label_0a_107	; $4b5d
	ld (de),a		; $4b5f
	push af			; $4b60
	ld hl,$4b81		; $4b61
	rst_addAToHl			; $4b64
	ldi a,(hl)		; $4b65
	ld e,$5a		; $4b66
	ld (de),a		; $4b68
	pop af			; $4b69
	call interactionSetAnimation		; $4b6a
	ld a,$00		; $4b6d
	call objectGetRelatedObject1Var		; $4b6f
	ld l,$08		; $4b72
	ld a,(hl)		; $4b74
_label_0a_107:
	push hl			; $4b75
	ld hl,$4b85		; $4b76
	rst_addAToHl			; $4b79
	ld b,$00		; $4b7a
	ld c,(hl)		; $4b7c
	pop hl			; $4b7d
	jp objectTakePositionWithOffset		; $4b7e
	add e			; $4b81
	add e			; $4b82
	add b			; $4b83
	add e			; $4b84
	nop			; $4b85
	dec b			; $4b86
	nop			; $4b87
	ei			; $4b88

interactionCodec7:
	ld e,$42		; $4b89
	ld a,(de)		; $4b8b
	ld c,a			; $4b8c
	ld hl,$cf00		; $4b8d
	ld b,$b0		; $4b90
_label_0a_108:
	ld a,(hl)		; $4b92
	cp c			; $4b93
	call z,$4b9e		; $4b94
	inc l			; $4b97
	dec b			; $4b98
	jr nz,_label_0a_108	; $4b99
	jp interactionDelete		; $4b9b
	push hl			; $4b9e
	push bc			; $4b9f
	ld b,l			; $4ba0
	ld e,$4d		; $4ba1
	ld a,(de)		; $4ba3
	and $f0			; $4ba4
	swap a			; $4ba6
	call $4bcd		; $4ba8
	jr nz,_label_0a_109	; $4bab
	ld e,$4b		; $4bad
	ld a,(de)		; $4baf
	ldi (hl),a		; $4bb0
	ld e,$4d		; $4bb1
	ld a,(de)		; $4bb3
	and $0f			; $4bb4
	ld (hl),a		; $4bb6
	ld a,l			; $4bb7
	add $09			; $4bb8
	ld l,a			; $4bba
	ld a,b			; $4bbb
	and $f0			; $4bbc
	add $08			; $4bbe
	ldi (hl),a		; $4bc0
	inc l			; $4bc1
	ld a,b			; $4bc2
	and $0f			; $4bc3
	swap a			; $4bc5
	add $08			; $4bc7
	ld (hl),a		; $4bc9
_label_0a_109:
	pop bc			; $4bca
	pop hl			; $4bcb
	ret			; $4bcc
	or a			; $4bcd
	jp z,getFreeEnemySlot		; $4bce
	dec a			; $4bd1
	jp z,getFreePartSlot		; $4bd2
	dec a			; $4bd5
	jp z,getFreeInteractionSlot		; $4bd6
	ret			; $4bd9

interactionCode8a:
interactionCode8b:
interactionCode8d:
	call checkInteractionState		; $4bda
	jr nz,_label_0a_114	; $4bdd
	ld a,$01		; $4bdf
	ld (de),a		; $4be1
	ld e,$41		; $4be2
	ld a,(de)		; $4be4
	cp $8d			; $4be5
	jr nz,_label_0a_110	; $4be7
	ld a,$40		; $4be9
	call checkTreasureObtained		; $4beb
	jp nc,interactionDelete		; $4bee
	call getHighestSetBit		; $4bf1
	cp $02			; $4bf4
	jp c,interactionDelete		; $4bf6
_label_0a_110:
	call seasonsFunc_3e3e		; $4bf9
	ld e,$42		; $4bfc
	ld a,(de)		; $4bfe
	cp b			; $4bff
	jp nz,interactionDelete		; $4c00
	cp $01			; $4c03
	jr nz,_label_0a_112	; $4c05
	ld e,$41		; $4c07
	ld a,(de)		; $4c09
	cp $8b			; $4c0a
	jr nz,_label_0a_112	; $4c0c
	ld a,$16		; $4c0e
	call checkGlobalFlag		; $4c10
	ld b,$5d		; $4c13
	jr nz,_label_0a_111	; $4c15
	ld b,$b6		; $4c17
_label_0a_111:
	ld a,($cc4c)		; $4c19
	cp b			; $4c1c
	jp nz,interactionDelete		; $4c1d
_label_0a_112:
	call interactionInitGraphics		; $4c20
	ld e,$49		; $4c23
	ld a,$04		; $4c25
	ld (de),a		; $4c27
	ld e,$41		; $4c28
	ld a,(de)		; $4c2a
	ld hl,$4c4c		; $4c2b
	cp $8a			; $4c2e
	jr z,_label_0a_113	; $4c30
	ld hl,$4c56		; $4c32
	cp $8b			; $4c35
	jr z,_label_0a_113	; $4c37
	ld hl,$4c60		; $4c39
_label_0a_113:
	ld e,$42		; $4c3c
	ld a,(de)		; $4c3e
	rst_addDoubleIndex			; $4c3f
	ldi a,(hl)		; $4c40
	ld h,(hl)		; $4c41
	ld l,a			; $4c42
	call interactionSetScript		; $4c43
_label_0a_114:
	call interactionRunScript		; $4c46
	jp interactionAnimateAsNpc		; $4c49
	xor c			; $4c4c
	ld (hl),d		; $4c4d
	or h			; $4c4e
	ld (hl),d		; $4c4f
	or a			; $4c50
	ld (hl),d		; $4c51
	cp d			; $4c52
	ld (hl),d		; $4c53
	cp l			; $4c54
	ld (hl),d		; $4c55
	ret nz			; $4c56
	ld (hl),d		; $4c57
	call z,$e372		; $4c58
	ld (hl),d		; $4c5b
	and $72			; $4c5c
	jp hl			; $4c5e
	ld (hl),d		; $4c5f
.DB $ec				; $4c60
	ld (hl),d		; $4c61
	ld d,$73		; $4c62
	ld d,$73		; $4c64
	add hl,de		; $4c66
	ld (hl),e		; $4c67
	inc e			; $4c68
	ld (hl),e		; $4c69


; ==============================================================================
; INTERACID_FLYING_ROOSTER
;
; Variables:
;   var30/var31: Initial position
;   var32: Y-position necessary to clear the cliff
;   var33: Counter used along with var34
;   var34: Direction chicken is hopping in (up or down; when moving back to "base"
;          position)
;   var35: X-position at which the "destination" is (Link loses control)
; ==============================================================================
interactionCode8c:
	ld e,Interaction.subid		; $4c6a
	ld a,(de)		; $4c6c
	bit 7,a			; $4c6d
	jp nz,_flyingRooster_subidBit7Set		; $4c6f

	ld a,(wLinkDeathTrigger)		; $4c72
	or a			; $4c75
	jp nz,interactionAnimate		; $4c76

	ld e,Interaction.state		; $4c79
	ld a,(de)		; $4c7b
	rst_jumpTable			; $4c7c
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	ld a,$01		; $4c8b
	ld (de),a ; [state]

	ld a,$02		; $4c8e
	call objectSetCollideRadius		; $4c90

	call _flyingRooster_getSubidAndInitSpeed		; $4c93

	; Save initial position into var30/var31
	ld e,Interaction.yh		; $4c96
	ld l,Interaction.var30		; $4c98
	ld a,(de)		; $4c9a
	ldi (hl),a		; $4c9b
	ld e,Interaction.xh		; $4c9c
	ld a,(de)		; $4c9e
	ld (hl),a		; $4c9f

	ld a,c			; $4ca0
	ld hl,@subidData		; $4ca1
	rst_addDoubleIndex			; $4ca4
	ldi a,(hl)		; $4ca5
	ld e,Interaction.var32		; $4ca6
	ld (de),a		; $4ca8
	ld e,Interaction.var35		; $4ca9
	ld a,(hl)		; $4cab
	ld (de),a		; $4cac
	call interactionInitGraphics		; $4cad
	jp objectSetVisiblec2		; $4cb0

; b0: var32 (?)
; b1: var35 (Target x-position)
@subidData:
	.db $18 $68 ; Subid 0
	.db $08 $48 ; Subid 1


; Waiting for Link to grab
@state1:
	call interactionAnimate		; $4cb7
	call objectAddToGrabbableObjectBuffer		; $4cba
	ld c,$10		; $4cbd
	call objectUpdateSpeedZ_paramC		; $4cbf
	ret nz			; $4cc2
	ld bc,-$100		; $4cc3
	jp objectSetSpeedZ		; $4cc6


; "Grabbed" state
@state2:
	call interactionAnimate		; $4cc9
	ld e,Interaction.state2		; $4ccc
	ld a,(de)		; $4cce
	rst_jumpTable			; $4ccf
	.dw @justGrabbed
	.dw @state2Substate1
	.dw @state2Substate2
	.dw @releaseFromLink
	.dw @state2Substate4

@justGrabbed:
	ld a,$01		; $4cda
	ld (de),a ; [state2]
	ld (wDisableScreenTransitions),a		; $4cdd
	ld (wMenuDisabled),a		; $4ce0
	ld a,$08		; $4ce3
	ld (wLinkGrabState2),a		; $4ce5
	ret			; $4ce8

@state2Substate1:
	ld a,(wLinkInAir)		; $4ce9
	or a			; $4cec
	ret nz			; $4ced

	ld a,(wLinkGrabState)		; $4cee
	and $07			; $4cf1
	cp $03			; $4cf3
	ret nz			; $4cf5

	ld hl,w1Link.direction		; $4cf6
	ld (hl),$01		; $4cf9
	ld a,DISABLE_LINK		; $4cfb
	ld (wDisabledObjects),a		; $4cfd

	ld l,<w1Link.zh		; $4d00
	ld a,(hl)		; $4d02
	dec a			; $4d03
	ld (hl),a		; $4d04
	cp $f8			; $4d05
	ret nz			; $4d07
	ld a,$02		; $4d08
	ld (de),a		; $4d0a
	ret			; $4d0b


; Moving toward "base" position before continuing
@state2Substate2:
	; Calculate angle toward original position
	ld e,Interaction.var30		; $4d0c
	ld a,(de)		; $4d0e
	ld b,a			; $4d0f
	inc e			; $4d10
	ld a,(de)		; $4d11
	ld c,a			; $4d12
	push de			; $4d13
	ld de,w1Link.yh		; $4d14
	call getRelativeAngle		; $4d17
	pop de			; $4d1a
	ld e,Interaction.angle		; $4d1b
	ld (de),a		; $4d1d

	call _flyingRooster_applySpeedAndUpdatePositions		; $4d1e

	ld h,d			; $4d21
	ld l,Interaction.var30		; $4d22
	ldi a,(hl)		; $4d24
	cp b			; $4d25
	ret nz			; $4d26
	ldi a,(hl)		; $4d27
	cp c			; $4d28
	ret nz			; $4d29

	; Reached base position
	ld l,Interaction.enabled		; $4d2a
	res 1,(hl)		; $4d2c

	ld l,Interaction.state2		; $4d2e
	ld (hl),$04		; $4d30

	ld e,Interaction.subid		; $4d32
	ld a,(de)		; $4d34
	ld hl,@angles		; $4d35
	rst_addAToHl			; $4d38
	ld a,(hl)		; $4d39
	ld e,Interaction.angle		; $4d3a
	ld (de),a		; $4d3c
	xor a			; $4d3d
	ld (wDisableScreenTransitions),a		; $4d3e
	ret			; $4d41

@angles:
	.db $08 $01


@state2Substate4:
	ld e,Interaction.subid		; $4d44
	ld a,(de)		; $4d46
	or a			; $4d47
	jr nz,@incState	; $4d48

	; Subid 0 (on top of d4) only: stay in this state until reaching cliff edge.
	call _flyingRooster_applySpeedAndUpdatePositions		; $4d4a
	ld l,<w1Link.xh		; $4d4d
	ldi a,(hl)		; $4d4f
	cp $30			; $4d50
	ret c			; $4d52

	; Reached edge. Re-jig Link's y and z positions to make him "in the air".
	ld l,<w1Link.yh		; $4d53
	ld a,(hl)		; $4d55
	sub $68			; $4d56
	ld l,<w1Link.zh		; $4d58
	add (hl)		; $4d5a
	ld (hl),a		; $4d5b
	ld a,$68		; $4d5c
	ld l,<w1Link.yh		; $4d5e
	ld (hl),a		; $4d60

	ld l,<w1Link.visible		; $4d61
	res 6,(hl)		; $4d63

	ld e,Interaction.visible		; $4d65
	ld a,(de)		; $4d67
	res 6,a			; $4d68
	ld (de),a		; $4d6a

@incState:
	call interactionIncState		; $4d6b
	ret			; $4d6e


; The state where Link can adjust the rooster's height.
@state3:
	call interactionAnimate		; $4d6f
	call _flyingRooster_applySpeedAndUpdatePositions		; $4d72

	; Cap y-position?
	ld l,<w1Link.yh		; $4d75
	ld a,(hl)		; $4d77
	cp $58			; $4d78
	jr nc,+			; $4d7a
	inc (hl)		; $4d7c
+
	ld l,<w1Link.xh		; $4d7d
	ld e,Interaction.var35		; $4d7f
	ld a,(de)		; $4d81
	cp (hl)			; $4d82
	jr c,@reachedTargetXPosition	; $4d83

	call _flyingRooster_updateGravityAndCheckCaps		; $4d85
	ld a,(wGameKeysJustPressed)		; $4d88
	and (BTN_A|BTN_B)			; $4d8b
	ret z			; $4d8d

	; Set z speed based on subid
	ld bc,-$b0		; $4d8e
	ld e,Interaction.subid		; $4d91
	ld a,(de)		; $4d93
	or a			; $4d94
	jr z,+			; $4d95
	ld bc,-$d0		; $4d97
+
	call objectSetSpeedZ		; $4d9a
	ld a,SND_CHICKEN		; $4d9d
	call playSound		; $4d9f
	jp interactionAnimate		; $4da2

@reachedTargetXPosition:
	call _flyingRooster_getVisualLinkYPosition		; $4da5
	ld e,Interaction.var32		; $4da8
	ld a,(de)		; $4daa
	add $08			; $4dab
	cp b			; $4dad
	jr c,@notHighEnough	; $4dae

	; High enough
	ld a,$08		; $4db0
	ld e,Interaction.angle		; $4db2
	ld (de),a		; $4db4
	ld a,$04		; $4db5
	ld e,Interaction.state		; $4db7
	ld (de),a		; $4db9
	ret			; $4dba

@notHighEnough:
	ld e,Interaction.subid		; $4dbb
	ld a,(de)		; $4dbd
	or a			; $4dbe
	jr nz,@gotoState6	; $4dbf

	; Subid 0 only
	ld a,(wScreenTransitionBoundaryY)		; $4dc1
	ld b,a			; $4dc4
	ld l,<w1Link.yh		; $4dc5
	ld a,(hl)		; $4dc7
	sub b			; $4dc8

	ld l,<w1Link.zh		; $4dc9
	add (hl)		; $4dcb
	ld (hl),a		; $4dcc
	ld l,<w1Link.yh		; $4dcd
	ld (hl),b		; $4dcf

	; Create helper object to handle screen transition when Link falls
	call getFreeInteractionSlot		; $4dd0
	ld a,INTERACID_FLYING_ROOSTER		; $4dd3
	ldi (hl),a		; $4dd5
	ld (hl),$80		; $4dd6
	ld l,Interaction.enabled		; $4dd8
	ld a,$03		; $4dda
	ldi (hl),a		; $4ddc

@gotoState6:
	ld e,Interaction.state		; $4ddd
	ld a,$06		; $4ddf
	ld (de),a		; $4de1
	ld e,Interaction.counter1		; $4de2
	ld a,60		; $4de4
	ld (de),a		; $4de6
	ret			; $4de7


; Cucco stopped in place as it failed to get high enough
@state6:
	call interactionAnimate		; $4de8
	call interactionAnimate		; $4deb
	ld e,Interaction.counter1		; $4dee
	ld a,(de)		; $4df0
	dec a			; $4df1
	ld (de),a		; $4df2
	ret nz			; $4df3
	jp @releaseFromLink		; $4df4


; Lost control; moving onto cliff
@state4:
	call interactionAnimate		; $4df7
	call _flyingRooster_applySpeedAndUpdatePositions		; $4dfa
	ld e,Interaction.var35		; $4dfd
	ld a,(de)		; $4dff
	add $20			; $4e00
	ld l,<w1Link.xh		; $4e02
	cp (hl)			; $4e04
	jr z,@releaseFromLink	; $4e05

	; Still moving toward target position
	ld a,(hl)		; $4e07
	and $0f			; $4e08
	ret nz			; $4e0a

	; Update Link's Y/Z positions
	call _flyingRooster_getVisualLinkYPosition		; $4e0b
	add $08			; $4e0e
	ld l,<w1Link.yh		; $4e10
	ld (hl),a		; $4e12
	ld l,<w1Link.zh		; $4e13
	ld a,$f8		; $4e15
	ld (hl),a		; $4e17

	ld l,<w1Link.visible		; $4e18
	set 6,(hl)		; $4e1a
	ld e,Interaction.visible		; $4e1c
	ld a,(de)		; $4e1e
	and $bf			; $4e1f
	ld (de),a		; $4e21
	ret			; $4e22

@releaseFromLink:
	xor a			; $4e23
	ld (wDisabledObjects),a		; $4e24
	ld (wMenuDisabled),a		; $4e27

	ld hl,w1Link.angle		; $4e2a
	ld a,$ff		; $4e2d
	ld (hl),a		; $4e2f

	ld a,$05		; $4e30
	ld e,Interaction.state		; $4e32
	ld (de),a		; $4e34

	ld a,$08		; $4e35
	ld e,Interaction.var33		; $4e37
	ld (de),a		; $4e39

	xor a			; $4e3a
	inc e			; $4e3b
	ld (de),a ; [var34]

	ld a,$00		; $4e3d
	call interactionSetAnimation		; $4e3f
	jp dropLinkHeldItem		; $4e42


@state5:
	call interactionAnimate		; $4e45
	ld e,Interaction.var33		; $4e48
	ld a,(de)		; $4e4a
	dec a			; $4e4b
	ld (de),a		; $4e4c
	jr nz,@updateHopping	; $4e4d

	ld a,$08		; $4e4f
	ld (de),a ; [var33]

	inc e			; $4e52
	ld a,(de) ; [var34]
	xor $01			; $4e54
	ld (de),a		; $4e56
	jr @moveTowardBasePosition		; $4e57

@updateHopping:
	and $01			; $4e59
	jr nz,@moveTowardBasePosition	; $4e5b

	ld e,Interaction.var34		; $4e5d
	ld a,(de)		; $4e5f
	or a			; $4e60
	ld e,Interaction.zh		; $4e61
	ld a,(de)		; $4e63
	jr z,@decZ		; $4e64

@incZ:
	inc a			; $4e66
	jr @setZ		; $4e67
@decZ:
	dec a			; $4e69
@setZ:
	ld (de),a		; $4e6a

@moveTowardBasePosition:
	ld e,Interaction.var30		; $4e6b
	ld a,(de)		; $4e6d
	ld b,a			; $4e6e
	inc e			; $4e6f
	ld a,(de)		; $4e70
	ld c,a			; $4e71

	call objectGetRelativeAngle		; $4e72
	ld e,Interaction.angle		; $4e75
	ld (de),a		; $4e77
	call objectApplySpeed		; $4e78

	ld h,d			; $4e7b
	ld l,Interaction.var30		; $4e7c
	ld e,Interaction.yh		; $4e7e
	ld a,(de)		; $4e80
	cp (hl)			; $4e81
	ret nz			; $4e82

	inc l			; $4e83
	ld e,Interaction.xh		; $4e84
	ld a,(de)		; $4e86
	cp (hl)			; $4e87
	ret nz			; $4e88

	; Reached base position
	ld l,Interaction.state		; $4e89
	ld (hl),$01		; $4e8b

	ld l,Interaction.visible		; $4e8d
	set 6,(hl)		; $4e8f
	call _flyingRooster_getSubidAndInitSpeed		; $4e91
	ld a,$01		; $4e94
	jp interactionSetAnimation		; $4e96

;;
; @param[out]	bc	Y/X positions for Link
; @addr{4e99}
_flyingRooster_applySpeedAndUpdatePositions:
	ld hl,w1Link.yh		; $4e99
	ld e,Interaction.yh		; $4e9c
	ldi a,(hl)		; $4e9e
	ld (de),a		; $4e9f
	inc l			; $4ea0
	ld e,Interaction.xh		; $4ea1
	ld a,(hl)		; $4ea3
	ld (de),a		; $4ea4
	call objectApplySpeed		; $4ea5

	ld hl,w1Link.yh		; $4ea8
	ld e,Interaction.yh		; $4eab
	ld a,(de)		; $4ead
	ld b,a			; $4eae
	ldi (hl),a		; $4eaf
	inc l			; $4eb0
	ld e,Interaction.xh		; $4eb1
	ld a,(de)		; $4eb3
	ld c,a			; $4eb4
	ld (hl),a		; $4eb5
	ret			; $4eb6

;;
; @addr{4eb7}
_flyingRooster_updateGravityAndCheckCaps:
	; [this.z] = [w1Link.z]
	ld l,<w1Link.z		; $4eb7
	ld e,Interaction.z		; $4eb9
	ldi a,(hl)		; $4ebb
	ld (de),a		; $4ebc
	inc e			; $4ebd
	ld a,(hl)		; $4ebe
	ld (de),a		; $4ebf

	ld c,$20		; $4ec0
	call objectUpdateSpeedZ_paramC		; $4ec2

	; [w1Link.z] = [this.z]
	ld hl,w1Link.z		; $4ec5
	ld e,Interaction.z		; $4ec8
	ld a,(de)		; $4eca
	ldi (hl),a		; $4ecb
	inc e			; $4ecc
	ld a,(de)		; $4ecd
	ld (hl),a		; $4ece

	call _flyingRooster_getVisualLinkYPosition		; $4ecf
	ld e,Interaction.var32		; $4ed2
	ld a,(de)		; $4ed4
	cp b			; $4ed5
	jr c,@checkBottomCap	; $4ed6

	; Cap z-position at the top
	sub b			; $4ed8
	ld l,<w1Link.zh		; $4ed9
	add (hl)		; $4edb
	ld (hl),a		; $4edc
	ret			; $4edd

@checkBottomCap:
	ld l,<w1Link.zh		; $4ede
	ld a,(hl)		; $4ee0
	cp $f8			; $4ee1
	ret c			; $4ee3

	; Cap z-position at bottom
	ld a,$f8		; $4ee4
	ld (hl),a		; $4ee6
	xor a			; $4ee7
	ld e,Interaction.speedZ		; $4ee8
	ld (de),a		; $4eea
	ld e,Interaction.speedZ+1		; $4eeb
	ld (de),a		; $4eed
	ret			; $4eee

;;
; @param[out]	a,b	Link's Y-position + Z-position
; @addr{4eef}
_flyingRooster_getVisualLinkYPosition:
	ld l,<w1Link.yh		; $4eef
	ld a,(hl)		; $4ef1
	ld l,<w1Link.zh		; $4ef2
	add (hl)		; $4ef4
	ld b,a			; $4ef5
	ret			; $4ef6


; Helper object which handles the screen transition when Link falls down
_flyingRooster_subidBit7Set:
	ld hl,w1Link.zh		; $4ef7
	ld a,(wActiveRoom)		; $4efa
	and $f0			; $4efd
	jr nz,@nextScreen	; $4eff

	ld a,(hl)		; $4f01
	or a			; $4f02
	ret nz			; $4f03

	ld l,<w1Link.yh		; $4f04
	inc (hl)		; $4f06
	ld a,$80		; $4f07
	ld (wLinkInAir),a		; $4f09
	ld a,$82		; $4f0c
	ld (wScreenTransitionDirection),a		; $4f0e
	ret			; $4f11

@nextScreen:
	ld a,(wScrollMode)		; $4f12
	and $0e			; $4f15
	ret nz			; $4f17

	ld (hl),$e8 ; [w1Link.zh]
	ld l,<w1Link.yh		; $4f1a
	ld (hl),$28		; $4f1c
	jp interactionDelete		; $4f1e

;;
; @addr{4f21}
_flyingRooster_getSubidAndInitSpeed:
	ld l,Interaction.subid		; $4f21
	ld c,(hl)		; $4f23
	ld l,Interaction.speed		; $4f24
	ld (hl),SPEED_60		; $4f26
	ret			; $4f28


interactionCode8e:
	ld e,$44		; $4f29
	ld a,(de)		; $4f2b
	rst_jumpTable			; $4f2c
	ld sp,$3a4f		; $4f2d
	ld c,a			; $4f30
	ld a,$01		; $4f31
	ld (de),a		; $4f33
	call interactionInitGraphics		; $4f34
	jp objectSetVisible81		; $4f37
	call interactionAnimate		; $4f3a
	call objectGetRelatedObject1Var		; $4f3d
	ld l,$76		; $4f40
	ld a,(hl)		; $4f42
	or a			; $4f43
	jp z,$4f4c		; $4f44
	xor a			; $4f47
	ld (hl),a		; $4f48
	call interactionSetAnimation		; $4f49
	call objectSetVisible		; $4f4c
	ld h,d			; $4f4f
	ld l,$61		; $4f50
	ld a,(hl)		; $4f52
	or a			; $4f53
	jp nz,objectSetInvisible		; $4f54
	ret			; $4f57


; ==============================================================================
; INTERACID_OLD_MAN_WITH_JEWEL
;
; Variables:
;   var35: $01 if Link has at least 5 essences
; ==============================================================================
interactionCode8f:
	ld e,Interaction.state		; $4f58
	ld a,(de)		; $4f5a
	rst_jumpTable			; $4f5b
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4f60
	ld (de),a ; [state]
	call interactionInitGraphics		; $4f63

	ld a,>TX_3600		; $4f66
	call interactionSetHighTextIndex		; $4f68

	ld hl,oldManWithJewelScript		; $4f6b
	call interactionSetScript		; $4f6e
	call @checkHaveEssences		; $4f71

	ld a,$02		; $4f74
	call interactionSetAnimation		; $4f76
	jr @state1		; $4f79

@state1:
	call interactionRunScript		; $4f7b
	jp npcFaceLinkAndAnimate		; $4f7e

@checkHaveEssences:
	ld a,(wEssencesObtained)		; $4f81
	call getNumSetBits		; $4f84
	ld h,d			; $4f87
	ld l,Interaction.var38		; $4f88
	cp $05			; $4f8a
	ld (hl),$00		; $4f8c
	ret c			; $4f8e
	inc (hl)		; $4f8f
	ret			; $4f90


interactionCode90:
	ld e,Interaction.state		; $4f91
	ld a,(de)		; $4f93
	rst_jumpTable			; $4f94
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4f99
	ld (de),a ; [state]

	; Load script
	ld e,Interaction.subid		; $4f9c
	ld a,(de)		; $4f9e
	ld hl,@scriptTable		; $4f9f
	rst_addDoubleIndex			; $4fa2
	ldi a,(hl)		; $4fa3
	ld h,(hl)		; $4fa4
	ld l,a			; $4fa5
	call interactionSetScript		; $4fa6

	ld e,Interaction.subid		; $4fa9
	ld a,(de)		; $4fab
	rst_jumpTable			; $4fac
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init
	.dw @subid7Init

@subid0Init:
	call @spawnJewelGraphics		; $4fbd
	call getThisRoomFlags		; $4fc0
	bit 7,(hl)		; $4fc3
	jp nz,interactionDelete		; $4fc5
	ret			; $4fc8

@subid1Init:
	call checkIsLinkedGame		; $4fc9
	jr z,@label_0a_130	; $4fcc
	ld e,$4b		; $4fce
	ld a,(de)		; $4fd0
	sub $08			; $4fd1
	ld (de),a		; $4fd3
@label_0a_130:
	jr @state1		; $4fd4

@subid3Init:
	call interactionRunScript		; $4fd6
	call interactionRunScript		; $4fd9

@subid4Init:
@subid5Init:
	jr @state1		; $4fdc

@subid2Init:
	call getThisRoomFlags		; $4fde
	and $40			; $4fe1
	jr z,@label_0a_131	; $4fe3
	ret			; $4fe5
@label_0a_131:
	call getFreePartSlot		; $4fe6
	ret nz			; $4fe9
	ld (hl),$06		; $4fea
	ld l,$cb		; $4fec
	ld (hl),$78		; $4fee
	ld l,$cd		; $4ff0
	ld (hl),$78		; $4ff2
	ret			; $4ff4

@subid6Init:
	call getThisRoomFlags		; $4ff5
	bit 5,(hl)		; $4ff8
	jp nz,interactionDelete		; $4ffa
	call checkIsLinkedGame		; $4ffd
	jr nz,@label_0a_132	; $5000
	ld a,$34		; $5002
	ld ($ccbd),a		; $5004
	ld a,$01		; $5007
	ld ($ccbe),a		; $5009
	jp interactionDelete		; $500c
@label_0a_132:
	xor a			; $500f
	ld ($ccbc),a		; $5010
	inc a			; $5013
	ld ($ccbb),a		; $5014
	ret			; $5017

@subid7Init:
	call checkIsLinkedGame		; $5018
	jp z,interactionDelete		; $501b
	call getThisRoomFlags		; $501e
	bit 7,a			; $5021
	jp nz,interactionDelete		; $5023
	bit 5,a			; $5026
	jp z,interactionDelete		; $5028
	call getFreeInteractionSlot		; $502b
	ret nz			; $502e
	ld (hl),$60		; $502f
	inc l			; $5031
	ld (hl),$4d		; $5032
	inc l			; $5034
	ld (hl),$01		; $5035
	jp objectCopyPosition		; $5037

@state1:
	ld e,Interaction.subid		; $503a
	ld a,(de)		; $503c
	rst_jumpTable			; $503d
	.dw @subid0State1
	.dw @runScript
	.dw @runScript
	.dw @runScript
	.dw @runScript
	.dw @runScript
	.dw @subid6State1
	.dw @subid7State1

@runScript:
	call interactionRunScript		; $504e
	jp c,interactionDelete		; $5051
	ret			; $5054

@subid0State1:
	ld e,Interaction.state2		; $5055
	ld a,(de)		; $5057
	rst_jumpTable			; $5058
	.dw @subid0Substate0
	.dw @subid0Substate1
	.dw @subid0Substate2
	.dw @subid0Substate3
	.dw @subid0Substate4
	.dw @subid0Substate5

; Waiting for Link to insert jewels
@subid0Substate0:
	call @checkJewelInserted		; $5065
	ret nc			; $5068

	ld a,(hl)		; $5069
	call loseTreasure		; $506a
	ld a,(hl)		; $506d
	call @insertJewel		; $506e

	ld a,DISABLE_LINK|DISABLE_ALL_BUT_INTERACTIONS		; $5071
	ld (wDisabledObjects),a		; $5073
	ld (wMenuDisabled),a		; $5076

	ld a,SND_SOLVEPUZZLE		; $5079
	call playSound		; $507b

	call setLinkForceStateToState08		; $507e
	xor a			; $5081
	ld (w1Link.direction),a		; $5082

	call interactionIncState2		; $5085
	ld hl,jewelHelperScript_insertedJewel		; $5088
	call interactionSetScript		; $508b


; Just inserted jewel
@subid0Substate1:
	call interactionRunScript		; $508e
	ret nc			; $5091

	ld a,(wInsertedJewels)		; $5092
	cp $0f			; $5095
	jr z,@insertedAllJewels	; $5097
	xor a			; $5099
	ld e,Interaction.state2		; $509a
	ld (de),a		; $509c
	ld ($cc02),a		; $509d
	ld ($cca4),a		; $50a0
	ret			; $50a3

@insertedAllJewels:
	call interactionIncState2		; $50a4
	ld hl,jewelHelperScript_insertedAllJewels		; $50a7
	call interactionSetScript		; $50aa


; Just inserted final jewel
@subid0Substate2:
	call interactionRunScript		; $50ad
	ret nc			; $50b0
	jp interactionIncState2		; $50b1


; Gate opening
@subid0Substate3:
	ld hl,@gateOpenTiles		; $50b4
	ld b,$04		; $50b7
---
	ldi a,(hl)		; $50b9
	ldh (<hFF8C),a	; $50ba
	ldi a,(hl)		; $50bc
	ldh (<hFF8F),a	; $50bd
	ldi a,(hl)		; $50bf
	ldh (<hFF8E),a	; $50c0
	ldi a,(hl)		; $50c2
	push hl			; $50c3
	push bc			; $50c4
	call setInterleavedTile		; $50c5
	pop bc			; $50c8
	pop hl			; $50c9
	dec b			; $50ca
	jr nz,---		; $50cb

	ldh a,(<hActiveObject)	; $50cd
	ld d,a			; $50cf
	call interactionIncState2		; $50d0

	ld l,Interaction.counter1		; $50d3
	ld (hl),30		; $50d5

	ld a,$00		; $50d7
	call @spawnGatePuffs		; $50d9
	ld a,SND_KILLENEMY		; $50dc
	call playSound		; $50de

@shakeScreen:
	ld a,$06		; $50e1
	call setScreenShakeCounter		; $50e3
	ld a,SND_DOORCLOSE		; $50e6
	jp playSound		; $50e8


; Gate opening
@subid0Substate4:
	call interactionDecCounter1		; $50eb
	ret nz			; $50ee
	ld hl,@gateOpenTiles		; $50ef
	ld b,$04		; $50f2
---
	ldi a,(hl)		; $50f4
	ld c,a			; $50f5
	ld a,(hl)		; $50f6
	push hl			; $50f7
	push bc			; $50f8
	call setTile		; $50f9
	pop bc			; $50fc
	pop hl			; $50fd
	inc hl			; $50fe
	inc hl			; $50ff
	inc hl			; $5100
	dec b			; $5101
	jr nz,---		; $5102

	call @shakeScreen		; $5104
	ld a,$04		; $5107
	call @spawnGatePuffs		; $5109
	ld a,SND_KILLENEMY		; $510c
	call playSound		; $510e
	call interactionIncState2		; $5111
	ld l,Interaction.counter1		; $5114
	ld (hl),60		; $5116
	ret			; $5118

@gateOpenTiles:
	.db $14 $ad $a0 $03 $15 $ad $a0 $01
	.db $24 $ad $a1 $03 $25 $ad $a1 $01


; Gates fully opened
@subid0Substate5:
	call interactionDecCounter1		; $5129
	ret nz			; $512c
	xor a			; $512d
	ld (wMenuDisabled),a		; $512e
	ld (wDisabledObjects),a		; $5131
	ld a,SND_SOLVEPUZZLE		; $5134
	call playSound		; $5136
	jp interactionDelete		; $5139


@subid6State1:
	ld e,Interaction.state2		; $513c
	ld a,(de)		; $513e
	rst_jumpTable			; $513f
	ld b,(hl)		; $5140
	ld d,c			; $5141
	ld h,d			; $5142
	ld d,c			; $5143
	add b			; $5144
	ld d,c			; $5145
	ld a,($ccbc)		; $5146
	or a			; $5149
	ret z			; $514a
	ld a,($cc34)		; $514b
	or a			; $514e
	ret nz			; $514f
	call interactionIncState2		; $5150
	ld l,$46		; $5153
	ld (hl),$1e		; $5155
	ld a,$80		; $5157
	ld ($cc02),a		; $5159
	ld a,$81		; $515c
	ld ($cca4),a		; $515e
	ret			; $5161
	call interactionDecCounter1		; $5162
	ret nz			; $5165
	ld bc,$0580		; $5166
	call objectCreateInteraction		; $5169
	ret nz			; $516c
	ld l,$4b		; $516d
	ld a,(hl)		; $516f
	sub $04			; $5170
	ld (hl),a		; $5172
	ld a,$85		; $5173
	call playSound		; $5175
	call interactionIncState2		; $5178
	ld l,$46		; $517b
	ld (hl),$10		; $517d
	ret			; $517f
	call interactionDecCounter1		; $5180
	ret nz			; $5183
	ld b,$e3		; $5184
	call objectCreateInteractionWithSubid00		; $5186
	ret nz			; $5189
	ld l,$4b		; $518a
	ld a,(hl)		; $518c
	sub $04			; $518d
	ld (hl),a		; $518f
	call getThisRoomFlags		; $5190
	set 5,(hl)		; $5193
	jp interactionDelete		; $5195

@subid7State1:
	ld a,$4d		; $5198
	call checkTreasureObtained		; $519a
	ret nc			; $519d
	call getThisRoomFlags		; $519e
	set 7,(hl)		; $51a1
	jp interactionDelete		; $51a3

;;
@spawnJewelGraphics:
	ld c,$00		; $51a6
@@next:
	ld hl,wInsertedJewels		; $51a8
	ld a,c			; $51ab
	call checkFlag		; $51ac
	jr z,++			; $51af
	push bc			; $51b1
	call @spawnJewelGraphic		; $51b2
	pop bc			; $51b5
++
	inc c			; $51b6
	ld a,c			; $51b7
	cp $04			; $51b8
	jr c,@@next	; $51ba
	ret			; $51bc

;;
; @param[out]	hl	Address of treasure index?
; @param[out]	cflag	c if inserted jewel
@checkJewelInserted:
	call checkLinkID0AndControlNormal		; $51bd
	ret nc			; $51c0

	ld hl,w1Link.direction		; $51c1
	ldi a,(hl)		; $51c4
	or a			; $51c5
	ret nz			; $51c6

	ld l,<w1Link.yh		; $51c7
	ld a,$36		; $51c9
	sub (hl)		; $51cb
	cp $15			; $51cc
	ret nc			; $51ce

	ld l,<w1Link.xh		; $51cf
	ld c,(hl)		; $51d1
	ld hl,@jewelPositions-1		; $51d2

@nextJewel:
	inc hl			; $51d5
	ldi a,(hl)		; $51d6
	or a			; $51d7
	ret z			; $51d8
	add $01			; $51d9
	sub c			; $51db
	cp $03			; $51dc
	jr nc,@nextJewel	; $51de
	ld a,(hl)		; $51e0
	jp checkTreasureObtained		; $51e1

@jewelPositions:
	.db $24, TREASURE_ROUND_JEWEL
	.db $34, TREASURE_PYRAMID_JEWEL
	.db $6c, TREASURE_SQUARE_JEWEL
	.db $7c, TREASURE_X_SHAPED_JEWEL
	.db $00

;;
@insertJewel:
	sub TREASURE_ROUND_JEWEL			; $51ed
	ld c,a			; $51ef
	ld hl,wInsertedJewels		; $51f0
	call setFlag		; $51f3

;;
; @param	c	Jewel index
@spawnJewelGraphic:
	call getFreeInteractionSlot		; $51f6
	ret nz			; $51f9
	ld (hl),INTERACID_JEWEL		; $51fa
	inc l			; $51fc
	ld (hl),c		; $51fd
	ret			; $51fe

;;
; @param	a	Which puffs to spawn (0 or 4)
@spawnGatePuffs:
	ld bc,@puffPositions		; $51ff
	call addDoubleIndexToBc		; $5202
	ld a,$04		; $5205
---
	ldh (<hFF8B),a	; $5207
	call getFreeInteractionSlot		; $5209
	ret nz			; $520c
	ld (hl),INTERACID_PUFF		; $520d
	ld l,Interaction.yh		; $520f
	ld a,(bc)		; $5211
	ld (hl),a		; $5212
	inc bc			; $5213
	ld l,Interaction.xh		; $5214
	ld a,(bc)		; $5216
	ld (hl),a		; $5217
	inc bc			; $5218
	ldh a,(<hFF8B)	; $5219
	dec a			; $521b
	jr nz,---		; $521c
	ret			; $521e

@puffPositions:
	.db $18 $48
	.db $18 $58
	.db $28 $48
	.db $28 $58
	.db $18 $40
	.db $18 $60
	.db $28 $40
	.db $28 $60

@scriptTable:
	.dw jewelHelperScript_insertedJewel
	.dw script7345
	.dw script735b
	.dw script737e
	.dw script7382
	.dw script738a
	.dw script73aa
	.dw script73aa


; ==============================================================================
; INTERACID_JEWEL
; ==============================================================================
interactionCode92:
	call checkInteractionState		; $523f
	ret nz			; $5242

@state0:
	inc a			; $5243
	ld (de),a ; [state] = 1

	ld e,Interaction.subid		; $5245
	ld a,(de)		; $5247
	ld hl,@xPositions		; $5248
	rst_addAToHl			; $524b
	ld a,(hl)		; $524c
	ld h,d			; $524d
	ld l,Interaction.xh		; $524e
	ld (hl),a		; $5250

	ld l,Interaction.yh		; $5251
	ld (hl),$2c		; $5253
	call interactionInitGraphics		; $5255
	jp objectSetVisible83		; $5258

@xPositions:
	.db $24 $34 $6c $7c


interactionCode93:
	ld e,$42		; $525f
	ld a,(de)		; $5261
	rst_jumpTable			; $5262
	ld h,a			; $5263
	ld d,d			; $5264
	and e			; $5265
	ld d,d			; $5266
	call checkInteractionState		; $5267
	ret nz			; $526a
	call $5298		; $526b
	call objectSetVisible80		; $526e
	ld a,($c6df)		; $5271
	ld b,$04		; $5274
	cp $06			; $5276
	jr z,_label_0a_142	; $5278
	cp $07			; $527a
	jp nz,interactionDelete		; $527c
	ld a,$01		; $527f
	call interactionSetAnimation		; $5281
	ld b,$08		; $5284
_label_0a_142:
	call getFreeInteractionSlot		; $5286
	ret nz			; $5289
	ld (hl),$84		; $528a
	inc l			; $528c
	ld (hl),$04		; $528d
	call objectCopyPosition		; $528f
	ld l,$4b		; $5292
	ld a,(hl)		; $5294
	add b			; $5295
	ld (hl),a		; $5296
	ret			; $5297
	ld a,$ab		; $5298
	call loadPaletteHeader		; $529a
	call interactionInitGraphics		; $529d
	jp interactionIncState		; $52a0
	ld e,$44		; $52a3
	ld a,(de)		; $52a5
	rst_jumpTable			; $52a6
	xor e			; $52a7
	ld d,d			; $52a8
	jp z,$cd52		; $52a9
	sbc b			; $52ac
	ld d,d			; $52ad
	ld l,$4b		; $52ae
	ld (hl),$65		; $52b0
	ld l,$4d		; $52b2
	ld (hl),$50		; $52b4
	ld l,$4f		; $52b6
	ld (hl),$8b		; $52b8
	ld a,$02		; $52ba
	call interactionSetAnimation		; $52bc
	ld a,(wFrameCounter)		; $52bf
	cpl			; $52c2
	inc a			; $52c3
	ld e,$78		; $52c4
	ld (de),a		; $52c6
	call $5338		; $52c7
	ld h,d			; $52ca
	ld l,$4f		; $52cb
	ldd a,(hl)		; $52cd
	cp $ed			; $52ce
	jp nc,interactionDelete		; $52d0
	ld bc,$0080		; $52d3
	ld a,c			; $52d6
	add (hl)		; $52d7
	ldi (hl),a		; $52d8
	ld a,b			; $52d9
	adc (hl)		; $52da
	ld (hl),a		; $52db
	ld a,(wFrameCounter)		; $52dc
	ld l,$78		; $52df
	add (hl)		; $52e1
	push af			; $52e2
	and $0f			; $52e3
	call z,$52f3		; $52e5
	pop af			; $52e8
	and $3f			; $52e9
	ld a,$83		; $52eb
	call z,playSound		; $52ed
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $52f0
	call getFreeInteractionSlot		; $52f3
	ret nz			; $52f6
	ld (hl),$84		; $52f7
	inc l			; $52f9
	ld (hl),$03		; $52fa
	ld e,$4b		; $52fc
	ld l,$4b		; $52fe
	ld a,(de)		; $5300
	ldi (hl),a		; $5301
	inc e			; $5302
	inc e			; $5303
	inc l			; $5304
	ld a,(de)		; $5305
	ldi (hl),a		; $5306
	ld e,$4f		; $5307
	ld l,$4b		; $5309
	call $1fd3		; $530b
	call getRandomNumber		; $530e
	and $07			; $5311
	add a			; $5313
	push de			; $5314
	ld de,$5328		; $5315
	call addAToDe		; $5318
	ld a,(de)		; $531b
	ld l,$4b		; $531c
	add (hl)		; $531e
	ld (hl),a		; $531f
	inc de			; $5320
	ld a,(de)		; $5321
	ld l,$4d		; $5322
	add (hl)		; $5324
	ld (hl),a		; $5325
	pop de			; $5326
	ret			; $5327
	stop			; $5328
	ld (bc),a		; $5329
	stop			; $532a
	cp $08			; $532b
	dec b			; $532d
	ld ($0cfb),sp		; $532e
	ld ($f80c),sp		; $5331
	ld b,$0b		; $5334
	ld b,$f5		; $5336
	ld bc,$8408		; $5338
	call objectCreateInteraction		; $533b
	ret nz			; $533e
	ld l,$56		; $533f
	ld a,$40		; $5341
	ldi (hl),a		; $5343
	ld (hl),d		; $5344
	ret			; $5345

interactionCode94:
	ld e,$44		; $5346
	ld a,(de)		; $5348
	rst_jumpTable			; $5349
	ld d,h			; $534a
	ld d,e			; $534b
	adc b			; $534c
	ld d,e			; $534d
	sub e			; $534e
	ld d,e			; $534f
	call z,$0e53		; $5350
	ld d,h			; $5353
	ld a,$01		; $5354
	ld ($cc02),a		; $5356
	ld hl,$d02d		; $5359
	ld a,(hl)		; $535c
	or a			; $535d
	ret nz			; $535e
	ld a,$01		; $535f
	ld (de),a		; $5361
	call objectTakePosition		; $5362
	ld bc,$3850		; $5365
	call objectGetRelativeAngle		; $5368
	and $1c			; $536b
	ld e,$49		; $536d
	ld (de),a		; $536f
	ld bc,$ff00		; $5370
	call objectSetSpeedZ		; $5373
	ld l,$50		; $5376
	ld (hl),$28		; $5378
	call interactionInitGraphics		; $537a
	ld a,($d01a)		; $537d
	ld e,$5a		; $5380
	ld (de),a		; $5382
	ld a,$57		; $5383
	jp playSound		; $5385
	ld c,$20		; $5388
	call objectUpdateSpeedZ_paramC		; $538a
	jp nz,objectApplySpeed		; $538d
	jp interactionIncState		; $5390
	ld hl,$d10b		; $5393
	ldi a,(hl)		; $5396
	ld b,a			; $5397
	inc l			; $5398
	ld c,(hl)		; $5399
	ld a,($c641)		; $539a
	and $20			; $539d
	jr z,_label_0a_144	; $539f
	ld e,$4b		; $53a1
	ld a,(de)		; $53a3
	cp b			; $53a4
	jr nz,_label_0a_144	; $53a5
	ld e,$4d		; $53a7
	ld a,(de)		; $53a9
	cp c			; $53aa
	jr z,_label_0a_145	; $53ab
_label_0a_144:
	call objectGetRelativeAngle		; $53ad
	xor $10			; $53b0
	ld ($d109),a		; $53b2
	ret			; $53b5
_label_0a_145:
	ld a,$ff		; $53b6
	ld ($d109),a		; $53b8
	call interactionIncState		; $53bb
	call objectSetInvisible		; $53be
	ld a,$5e		; $53c1
	call playSound		; $53c3
	ld bc,$070a		; $53c6
	jp showText		; $53c9
	ld a,$04		; $53cc
	ld ($cc6a),a		; $53ce
	ld a,$01		; $53d1
	ld ($cc6b),a		; $53d3
	ld hl,$d00b		; $53d6
	ld bc,$f200		; $53d9
	call objectTakePositionWithOffset		; $53dc
	call interactionIncState		; $53df
	ld l,$46		; $53e2
	ld (hl),$40		; $53e4
	ld l,$5b		; $53e6
	ld a,(hl)		; $53e8
	and $f8			; $53e9
	ldi (hl),a		; $53eb
	ldi (hl),a		; $53ec
	ld a,(hl)		; $53ed
	add $02			; $53ee
	ld (hl),a		; $53f0
	ld a,$03		; $53f1
	call interactionSetAnimation		; $53f3
	ld a,($d01a)		; $53f6
	ld e,$5a		; $53f9
	ld (de),a		; $53fb
	ld bc,$005c		; $53fc
	call showText		; $53ff
	ld a,$41		; $5402
	ld c,$02		; $5404
	call giveTreasure		; $5406
	ld a,$4c		; $5409
	jp playSound		; $540b
	call interactionDecCounter1		; $540e
	ret nz			; $5411
	xor a			; $5412
	ld ($cba0),a		; $5413
	ld ($cca4),a		; $5416
	ld a,$02		; $5419
	ld ($d105),a		; $541b
	jp interactionDelete		; $541e

interactionCode95:
	ld e,$44		; $5421
	ld a,(de)		; $5423
	rst_jumpTable			; $5424
	add hl,hl		; $5425
	ld d,h			; $5426
	cp e			; $5427
	ld d,h			; $5428
	ld a,$01		; $5429
	ld (de),a		; $542b
	ld e,$42		; $542c
	ld a,(de)		; $542e
	rst_jumpTable			; $542f
	inc a			; $5430
	ld d,h			; $5431
	ld c,c			; $5432
	ld d,h			; $5433
	ld c,c			; $5434
	ld d,h			; $5435
	sbc b			; $5436
	ld d,h			; $5437
	sub d			; $5438
	ld d,h			; $5439
	sbc (hl)		; $543a
	ld d,h			; $543b
	ld a,$16		; $543c
	call checkGlobalFlag		; $543e
	jp z,interactionDelete		; $5441
	ld a,$2d		; $5444
	call setGlobalFlag		; $5446
	call interactionInitGraphics		; $5449
	ld e,$5d		; $544c
	ld a,$80		; $544e
	ld (de),a		; $5450
	ld e,$42		; $5451
	ld a,(de)		; $5453
	or a			; $5454
	jp nz,objectSetVisible80		; $5455
	call getThisRoomFlags		; $5458
	ld b,a			; $545b
	xor a			; $545c
	sla b			; $545d
	adc $00			; $545f
	sla b			; $5461
	adc $00			; $5463
	ld hl,$55bf		; $5465
	rst_addDoubleIndex			; $5468
	ldi a,(hl)		; $5469
	ld h,(hl)		; $546a
	ld l,a			; $546b
	call interactionSetScript		; $546c
	call getFreeInteractionSlot		; $546f
	jr nz,_label_0a_146	; $5472
	ld (hl),$96		; $5474
	inc l			; $5476
	ld (hl),$01		; $5477
	ld e,$57		; $5479
	ld a,h			; $547b
	ld (de),a		; $547c
_label_0a_146:
	call $5517		; $547d
	ld hl,$7ea0		; $5480
	call parseGivenObjectData		; $5483
	call objectSetVisible83		; $5486
	xor a			; $5489
	ld ($cfd0),a		; $548a
	ld ($cfd1),a		; $548d
	jr _label_0a_147		; $5490
	ld hl,$73cd		; $5492
	call interactionSetScript		; $5495
	call interactionInitGraphics		; $5498
	jp interactionAnimateAsNpc		; $549b
	ld hl,$73d8		; $549e
	call interactionSetScript		; $54a1
	ld a,$01		; $54a4
	ld ($cc17),a		; $54a6
	ld a,$95		; $54a9
	ld ($cc1d),a		; $54ab
	ld a,$05		; $54ae
	ld ($cc1e),a		; $54b0
	call interactionInitGraphics		; $54b3
	call objectSetVisible81		; $54b6
	jr _label_0a_147		; $54b9
_label_0a_147:
	ld e,$42		; $54bb
	ld a,(de)		; $54bd
	rst_jumpTable			; $54be
	bit 2,h			; $54bf
	ld l,l			; $54c1
	ld d,l			; $54c2
	ld (hl),b		; $54c3
	ld d,l			; $54c4
	and c			; $54c5
	ld d,l			; $54c6
	adc b			; $54c7
	ld d,l			; $54c8
	and h			; $54c9
	ld d,l			; $54ca
	ld e,$45		; $54cb
	ld a,(de)		; $54cd
	rst_jumpTable			; $54ce
.DB $d3				; $54cf
	ld d,h			; $54d0
	add hl,hl		; $54d1
	ld d,l			; $54d2
	ld hl,$cfd0		; $54d3
	ld a,(hl)		; $54d6
	cp $02			; $54d7
	jr nz,_label_0a_148	; $54d9
	ld h,d			; $54db
	ld l,$45		; $54dc
	ld (hl),$01		; $54de
	ld l,$76		; $54e0
	ld (hl),$00		; $54e2
	ld a,$39		; $54e4
	call playSound		; $54e6
	jp interactionAnimateAsNpc		; $54e9
_label_0a_148:
	inc a			; $54ec
	jp z,interactionDelete		; $54ed
	call interactionRunScript		; $54f0
	call interactionAnimate		; $54f3
	call objectPreventLinkFromPassing		; $54f6
	ld e,$76		; $54f9
	ld a,(de)		; $54fb
	or a			; $54fc
	jr nz,_label_0a_149	; $54fd
	ld e,$61		; $54ff
	ld a,(de)		; $5501
	inc a			; $5502
	ret nz			; $5503
	ld hl,$cfc0		; $5504
	ld (hl),$01		; $5507
	ld h,d			; $5509
	ld l,$76		; $550a
	inc (hl)		; $550c
	ret			; $550d
_label_0a_149:
	ld e,$61		; $550e
	ld a,(de)		; $5510
	inc a			; $5511
	ret z			; $5512
	ld e,$76		; $5513
	xor a			; $5515
	ld (de),a		; $5516
	call getFreeInteractionSlot		; $5517
	ret nz			; $551a
	ld (hl),$97		; $551b
	ld bc,$0c02		; $551d
	call objectCopyPositionWithOffset		; $5520
	ld e,$57		; $5523
	ld l,e			; $5525
	ld a,(de)		; $5526
	ld (hl),a		; $5527
	ret			; $5528
	ld e,$76		; $5529
	ld a,(de)		; $552b
	or a			; $552c
	jr nz,_label_0a_150	; $552d
	ld a,$01		; $552f
	ld (de),a		; $5531
	ld e,$4b		; $5532
	ld a,(de)		; $5534
	sub $20			; $5535
	ld b,a			; $5537
	ld e,$4d		; $5538
	ld a,(de)		; $553a
	ld c,a			; $553b
	ld a,$50		; $553c
	call $5547		; $553e
	ld hl,$73c9		; $5541
	jp interactionSetScript		; $5544
	ldh (<hFF8B),a	; $5547
	call getFreeInteractionSlot		; $5549
	ret nz			; $554c
	ld (hl),$9f		; $554d
	ld l,$46		; $554f
	ldh a,(<hFF8B)	; $5551
	ld (hl),a		; $5553
	jp objectCopyPositionWithOffset		; $5554
_label_0a_150:
	call interactionRunScript		; $5557
	jp c,interactionDelete		; $555a
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $555d
	ld e,$77		; $5560
	ld a,(de)		; $5562
	or a			; $5563
	ret nz			; $5564
	call interactionAnimate		; $5565
	call interactionAnimate		; $5568
	jr _label_0a_151		; $556b
	jp $5730		; $556d
	call interactionAnimate		; $5570
	ld hl,$cfd0		; $5573
	ld a,(hl)		; $5576
	inc a			; $5577
	ret nz			; $5578
	jp interactionDelete		; $5579
_label_0a_151:
	ld h,d			; $557c
	ld l,$61		; $557d
	ld a,(hl)		; $557f
	cp $70			; $5580
	ret nz			; $5582
	ld (hl),$00		; $5583
	jp playSound		; $5585
	call interactionRunScript		; $5588
	jp c,interactionDelete		; $558b
	ld hl,$cfc0		; $558e
	bit 0,(hl)		; $5591
	jr z,_label_0a_152	; $5593
	ld a,(wFrameCounter)		; $5595
	and $0f			; $5598
	jr nz,_label_0a_152	; $559a
	ld a,$70		; $559c
	call playSound		; $559e
_label_0a_152:
	jp interactionAnimateAsNpc		; $55a1
	call interactionRunScript		; $55a4
	jp c,interactionDelete		; $55a7
	ld e,$47		; $55aa
	ld a,(de)		; $55ac
	or a			; $55ad
	jr z,_label_0a_153	; $55ae
	ld a,(wFrameCounter)		; $55b0
	and $0f			; $55b3
	jr nz,_label_0a_153	; $55b5
	ld a,$70		; $55b7
	call playSound		; $55b9
_label_0a_153:
	jp interactionAnimate		; $55bc
	xor e			; $55bf
	ld (hl),e		; $55c0
	or l			; $55c1
	ld (hl),e		; $55c2
	cp a			; $55c3
	ld (hl),e		; $55c4

interactionCode96:
	ld e,$44		; $55c5
	ld a,(de)		; $55c7
	rst_jumpTable			; $55c8
	call $3855		; $55c9
	ld d,(hl)		; $55cc
	ld a,$01		; $55cd
	ld (de),a		; $55cf
	call interactionInitGraphics		; $55d0
	ld e,$42		; $55d3
	ld a,(de)		; $55d5
	rst_jumpTable			; $55d6
	push hl			; $55d7
	ld d,l			; $55d8
.DB $ed				; $55d9
	ld d,l			; $55da
	daa			; $55db
	ld e,$f5		; $55dc
	ld d,l			; $55de
.DB $fd				; $55df
	ld d,l			; $55e0
	ld de,$1156		; $55e1
	ld d,(hl)		; $55e4
	ld hl,$57d0		; $55e5
_label_0a_154:
	call $57ba		; $55e8
	jr _label_0a_156		; $55eb
	call objectSetVisible81		; $55ed
	ld hl,$57d6		; $55f0
	jr _label_0a_154		; $55f3
	ld a,$02		; $55f5
	call interactionSetAnimation		; $55f7
	jp objectSetVisible80		; $55fa
	ld hl,$7421		; $55fd
	call interactionSetScript		; $5600
	ld e,$43		; $5603
	ld a,(de)		; $5605
	or a			; $5606
	jr z,_label_0a_155	; $5607
	inc a			; $5609
_label_0a_155:
	inc a			; $560a
	call interactionSetAnimation		; $560b
	jp interactionAnimateAsNpc		; $560e
	ld e,$43		; $5611
	ld a,(de)		; $5613
	ld hl,$57dc		; $5614
	rst_addDoubleIndex			; $5617
	ldi a,(hl)		; $5618
	ld h,(hl)		; $5619
	ld l,a			; $561a
	call interactionSetScript		; $561b
	ld e,$43		; $561e
	ld a,(de)		; $5620
	ld hl,$5630		; $5621
	rst_addDoubleIndex			; $5624
	ldi a,(hl)		; $5625
	ld e,$5c		; $5626
	ld (de),a		; $5628
	ld a,(hl)		; $5629
	call interactionSetAnimation		; $562a
	jp interactionAnimateAsNpc		; $562d
	ld (bc),a		; $5630
	ld ($0a02),sp		; $5631
	ld bc,$0102		; $5634
	ld (bc),a		; $5637
@state1:
_label_0a_156:
	ld e,$42		; $5638
	ld a,(de)		; $563a
	rst_jumpTable			; $563b
	ld c,d			; $563c
	ld d,(hl)		; $563d
	ld c,d			; $563e
	ld d,(hl)		; $563f
	jr nc,_label_0a_158	; $5640
	ld d,e			; $5642
	ld d,a			; $5643
	ld e,a			; $5644
	ld d,a			; $5645
	ld e,a			; $5646
	ld d,a			; $5647
	ld e,a			; $5648
	ld d,a			; $5649
	ld e,$45		; $564a
	ld a,(de)		; $564c
	rst_jumpTable			; $564d
	ld e,(hl)		; $564e
	ld d,(hl)		; $564f
	sub b			; $5650
	ld d,(hl)		; $5651
	xor b			; $5652
	ld d,(hl)		; $5653
	cp e			; $5654
	ld d,(hl)		; $5655
	add $56			; $5656
	ld a,($ff00+$56)	; $5658
	inc b			; $565a
	ld d,a			; $565b
	rla			; $565c
	ld d,a			; $565d
	ld hl,$cfd0		; $565e
	ld a,(hl)		; $5661
	cp $02			; $5662
	jp z,$5768		; $5664
	inc a			; $5667
	jp z,interactionDelete		; $5668
	call interactionRunScript		; $566b
	ld e,$42		; $566e
	ld a,(de)		; $5670
	or a			; $5671
	jp z,npcFaceLinkAndAnimate		; $5672
	ld e,$47		; $5675
	ld a,(de)		; $5677
	or a			; $5678
	call nz,interactionAnimate		; $5679
	ld e,$71		; $567c
	ld a,(de)		; $567e
	or a			; $567f
	jr z,_label_0a_157	; $5680
	xor a			; $5682
	ld (de),a		; $5683
	ld bc,$3801		; $5684
	call showText		; $5687
_label_0a_157:
	call interactionAnimate		; $568a
	jp objectPreventLinkFromPassing		; $568d
	call interactionAnimate		; $5690
	call interactionAnimate		; $5693
	call interactionDecCounter1		; $5696
_label_0a_158:
	jp nz,objectApplyComponentSpeed		; $5699
	ld a,$08		; $569c
	call setLinkIDOverride		; $569e
	ld l,$02		; $56a1
	ld (hl),$09		; $56a3
	jp interactionIncState2		; $56a5
	ld hl,$cfd1		; $56a8
	ld a,(hl)		; $56ab
	or a			; $56ac
	jp z,npcFaceLinkAndAnimate		; $56ad
	call interactionIncState2		; $56b0
	ld l,$42		; $56b3
	ld a,(hl)		; $56b5
	add $0b			; $56b6
	jp interactionSetAnimation		; $56b8
	call interactionAnimate		; $56bb
	ld e,$61		; $56be
	ld a,(de)		; $56c0
	inc a			; $56c1
	ret nz			; $56c2
	jp interactionIncState2		; $56c3
	ld e,$42		; $56c6
	ld a,(de)		; $56c8
	inc a			; $56c9
	ld b,a			; $56ca
	ld hl,$cfd1		; $56cb
	ld a,(hl)		; $56ce
	cp b			; $56cf
	jp nz,npcFaceLinkAndAnimate		; $56d0
	call interactionIncState2		; $56d3
	ld l,$50		; $56d6
	ld (hl),$28		; $56d8
	ld l,$4d		; $56da
	ld a,(hl)		; $56dc
	cp $50			; $56dd
	jr z,_label_0a_161	; $56df
	ld a,$18		; $56e1
	jr nc,_label_0a_159	; $56e3
	ld a,$08		; $56e5
_label_0a_159:
	ld e,$49		; $56e7
	ld (de),a		; $56e9
	call convertAngleDeToDirection		; $56ea
	jp interactionSetAnimation		; $56ed
	call objectApplySpeed		; $56f0
	cp $50			; $56f3
	jr nz,_label_0a_160	; $56f5
	call interactionIncState2		; $56f7
	ld l,$46		; $56fa
	ld (hl),$05		; $56fc
_label_0a_160:
	call interactionAnimate		; $56fe
	jp interactionAnimate		; $5701
	call interactionDecCounter1		; $5704
	jp nz,interactionAnimate		; $5707
_label_0a_161:
	ld l,$45		; $570a
	ld (hl),$07		; $570c
	ld l,$49		; $570e
	ld (hl),$10		; $5710
	ld a,$02		; $5712
	jp interactionSetAnimation		; $5714
	call interactionAnimate		; $5717
	call interactionAnimate		; $571a
	call objectApplySpeed		; $571d
	call objectCheckWithinScreenBoundary		; $5720
	ret c			; $5723
	ld hl,$cfd1		; $5724
	ld e,$42		; $5727
	ld a,(de)		; $5729
	add $02			; $572a
	ld (hl),a		; $572c
	jp interactionDelete		; $572d
	call interactionAnimate		; $5730
	call checkInteractionState2		; $5733
	jr nz,_label_0a_162	; $5736
	call interactionDecCounter1		; $5738
	ret nz			; $573b
	ld l,$50		; $573c
	ld (hl),$50		; $573e
	jp interactionIncState2		; $5740
_label_0a_162:
	call interactionAnimate		; $5743
	call $557c		; $5746
	call objectApplySpeed		; $5749
	call objectCheckWithinScreenBoundary		; $574c
	ret c			; $574f
	jp interactionDelete		; $5750
	call interactionAnimate		; $5753
	ld hl,$cfd0		; $5756
	ld a,(hl)		; $5759
	inc a			; $575a
	ret nz			; $575b
	jp interactionDelete		; $575c
	call interactionRunScript		; $575f
	jp c,interactionDelete		; $5762
	jp interactionAnimateAsNpc		; $5765
	call interactionIncState2		; $5768
	ld l,$46		; $576b
	ld (hl),$20		; $576d
	ld l,$4b		; $576f
	ld a,(hl)		; $5771
	ld b,a			; $5772
	ld hl,$d00b		; $5773
	ld a,(hl)		; $5776
	sub b			; $5777
	call $57ad		; $5778
	ld h,d			; $577b
	ld l,$50		; $577c
	ld (hl),c		; $577e
	inc l			; $577f
	ld (hl),b		; $5780
	ld l,$4d		; $5781
	ld a,(hl)		; $5783
	ld b,a			; $5784
	ld hl,$d00d		; $5785
	ld a,(hl)		; $5788
	ld c,a			; $5789
	ld e,$42		; $578a
	ld a,(de)		; $578c
	or a			; $578d
	ld a,$0c		; $578e
	jr nz,_label_0a_163	; $5790
	ld a,$f4		; $5792
_label_0a_163:
	add c			; $5794
	sub b			; $5795
	call $57ad		; $5796
	ld h,d			; $5799
	ld l,$52		; $579a
	ld (hl),c		; $579c
	inc l			; $579d
	ld (hl),b		; $579e
	call objectGetAngleTowardLink		; $579f
	ld e,$49		; $57a2
	ld (de),a		; $57a4
	call convertAngleDeToDirection		; $57a5
	dec e			; $57a8
	ld (de),a		; $57a9
	jp interactionSetAnimation		; $57aa
	ld b,a			; $57ad
	ld c,$00		; $57ae
	ld a,$05		; $57b0
_label_0a_164:
	sra b			; $57b2
	rr c			; $57b4
	dec a			; $57b6
	jr nz,_label_0a_164	; $57b7
	ret			; $57b9
	push hl			; $57ba
	call getThisRoomFlags		; $57bb
	ld b,a			; $57be
	xor a			; $57bf
	sla b			; $57c0
	adc $00			; $57c2
	sla b			; $57c4
	adc $00			; $57c6
	pop hl			; $57c8
	rst_addDoubleIndex			; $57c9
	ldi a,(hl)		; $57ca
	ld h,(hl)		; $57cb
	ld l,a			; $57cc
	jp interactionSetScript		; $57cd
	di			; $57d0
	ld (hl),e		; $57d1
	di			; $57d2
	ld (hl),e		; $57d3
	di			; $57d4
	ld (hl),e		; $57d5
	or $73			; $57d6
	or $73			; $57d8
	or $73			; $57da
	ld b,e			; $57dc
	ld (hl),h		; $57dd
	ld d,(hl)		; $57de
	ld (hl),h		; $57df
	ld l,c			; $57e0
	ld (hl),h		; $57e1
	ld l,c			; $57e2
	ld (hl),h		; $57e3

interactionCode97:
	ld e,$44		; $57e4
	ld a,(de)		; $57e6
	rst_jumpTable			; $57e7
.DB $ec				; $57e8
	ld d,a			; $57e9
	push af			; $57ea
	ld d,a			; $57eb
	ld a,$01		; $57ec
	ld (de),a		; $57ee
	call interactionInitGraphics		; $57ef
	jp objectSetVisible83		; $57f2
	ld hl,$cfd0		; $57f5
	ld a,(hl)		; $57f8
	inc a			; $57f9
	jp z,interactionDelete		; $57fa
	ld e,$45		; $57fd
	ld a,(de)		; $57ff
	rst_jumpTable			; $5800
	rlca			; $5801
	ld e,b			; $5802
	dec hl			; $5803
	ld e,b			; $5804
	ld b,l			; $5805
	ld e,b			; $5806
	ld hl,$cfd0		; $5807
	ld a,(hl)		; $580a
	cp $02			; $580b
	ret z			; $580d
	call interactionAnimate		; $580e
	ld hl,$cfc0		; $5811
	bit 1,(hl)		; $5814
	ret z			; $5816
	call interactionIncState2		; $5817
	call objectSetVisible81		; $581a
_label_0a_165:
	push de			; $581d
	ld h,d			; $581e
	ld l,$57		; $581f
	ld a,(hl)		; $5821
	ld d,a			; $5822
	ld bc,$0301		; $5823
	call objectCopyPositionWithOffset		; $5826
	pop de			; $5829
	ret			; $582a
	ld hl,$cfc0		; $582b
	bit 3,(hl)		; $582e
	jr z,_label_0a_166	; $5830
	call interactionIncState2		; $5832
	ld l,$49		; $5835
	ld (hl),$10		; $5837
	ld l,$50		; $5839
	ld (hl),$14		; $583b
	ld bc,$fe80		; $583d
	call objectSetSpeedZ		; $5840
_label_0a_166:
	jr _label_0a_165		; $5843
	ld c,$20		; $5845
	call objectUpdateSpeedZ_paramC		; $5847
	jp nz,objectApplySpeed		; $584a
	jp interactionDelete		; $584d

interactionCode99:
	call checkInteractionState		; $5850
	jr nz,_label_0a_167	; $5853
	inc a			; $5855
	ld (de),a		; $5856
	call interactionInitGraphics		; $5857
	ld a,$1f		; $585a
	call interactionSetHighTextIndex		; $585c
	ld e,$42		; $585f
	ld a,(de)		; $5861
	ld hl,$587b		; $5862
	rst_addDoubleIndex			; $5865
	ldi a,(hl)		; $5866
	ld h,(hl)		; $5867
	ld l,a			; $5868
	call interactionSetScript		; $5869
	ld h,d			; $586c
	ld l,$4b		; $586d
	ld (hl),$38		; $586f
	ld l,$4d		; $5871
	ld (hl),$80		; $5873
_label_0a_167:
	call interactionRunScript		; $5875
	jp npcFaceLinkAndAnimate		; $5878
	ld (hl),d		; $587b
	ld (hl),h		; $587c
	ld (hl),d		; $587d
	ld (hl),h		; $587e
	ld (hl),d		; $587f
	ld (hl),h		; $5880
	ld (hl),d		; $5881
	ld (hl),h		; $5882
	ld (hl),d		; $5883
	ld (hl),h		; $5884
	adc b			; $5885
	ld (hl),h		; $5886
	adc b			; $5887
	ld (hl),h		; $5888
	adc b			; $5889
	ld (hl),h		; $588a

interactionCode9a:
	ld e,$44		; $588b
	ld a,(de)		; $588d
	rst_jumpTable			; $588e
	sub e			; $588f
	ld e,b			; $5890
	ld bc,$3e59		; $5891
	ld d,$cd		; $5894
	rst_jumpTable			; $5896
	jr nc,-$36		; $5897
	reti			; $5899
	ldd a,(hl)		; $589a
	ld a,$01		; $589b
	ld (de),a		; $589d
	ld e,$42		; $589e
	ld a,(de)		; $58a0
	cp $02			; $58a1
	jr z,_label_0a_168	; $58a3
	call interactionInitGraphics		; $58a5
	jp objectSetVisible82		; $58a8
_label_0a_168:
	ld a,($cc36)		; $58ab
	or a			; $58ae
	jp z,interactionDelete		; $58af
	xor a			; $58b2
	ld ($cc36),a		; $58b3
	ld a,$12		; $58b6
	call unsetGlobalFlag		; $58b8
	call getThisRoomFlags		; $58bb
	rlca			; $58be
	jr nc,_label_0a_169	; $58bf
	ld a,$12		; $58c1
	call setGlobalFlag		; $58c3
	xor a			; $58c6
	ld hl,$d100		; $58c7
	ld (hl),a		; $58ca
	ld l,$1a		; $58cb
	ld (hl),a		; $58cd
	push de			; $58ce
	ld de,$59e4		; $58cf
	call $59ba		; $58d2
	pop de			; $58d5
	ld e,$42		; $58d6
	ld a,$03		; $58d8
	ld (de),a		; $58da
	ld a,$b9		; $58db
	jr _label_0a_170		; $58dd
_label_0a_169:
	call getThisRoomFlags		; $58df
	call $5b65		; $58e2
	ld c,(hl)		; $58e5
	ld a,$03		; $58e6
	ld b,$aa		; $58e8
	call getRoomFlags		; $58ea
	ld (hl),c		; $58ed
	ld a,$b4		; $58ee
_label_0a_170:
	ld h,d			; $58f0
	ld l,$70		; $58f1
	ld (hl),a		; $58f3
	ld a,$01		; $58f4
	ld ($cca4),a		; $58f6
	ld ($cc02),a		; $58f9
	ld l,$46		; $58fc
	ld (hl),$5a		; $58fe
	ret			; $5900
	ld e,$42		; $5901
	ld a,(de)		; $5903
	rst_jumpTable			; $5904
	dec c			; $5905
	ld e,c			; $5906
	halt			; $5907
	ld e,c			; $5908
	add d			; $5909
	ld e,c			; $590a
	ld a,($ff00+$59)	; $590b
	call interactionAnimate		; $590d
	ld e,$61		; $5910
	ld a,(de)		; $5912
	or a			; $5913
	ret z			; $5914
	inc a			; $5915
	jp z,interactionDelete		; $5916
	xor a			; $5919
	ld (de),a		; $591a
	ld e,$43		; $591b
	ld a,(de)		; $591d
	or a			; $591e
	ret z			; $591f
	dec a			; $5920
	ld hl,$5a5e		; $5921
	rst_addDoubleIndex			; $5924
	ldi a,(hl)		; $5925
	ld h,(hl)		; $5926
	ld l,a			; $5927
	push de			; $5928
	ld b,(hl)		; $5929
	inc hl			; $592a
_label_0a_171:
	ld c,(hl)		; $592b
	inc hl			; $592c
	ldi a,(hl)		; $592d
	push bc			; $592e
	push hl			; $592f
	call setTile		; $5930
	pop hl			; $5933
	pop bc			; $5934
	dec b			; $5935
	jr nz,_label_0a_171	; $5936
	pop de			; $5938
	call getRandomNumber_noPreserveVars		; $5939
	and $03			; $593c
	add $02			; $593e
	ld c,a			; $5940
	ld b,$04		; $5941
_label_0a_172:
	call getFreeInteractionSlot		; $5943
	ret nz			; $5946
	ld (hl),$9a		; $5947
	inc l			; $5949
	ld (hl),$01		; $594a
	ld a,b			; $594c
	add a			; $594d
	add a			; $594e
	add a			; $594f
	add c			; $5950
	and $1f			; $5951
	ld l,$49		; $5953
	ld (hl),a		; $5955
	call getRandomNumber		; $5956
	and $03			; $5959
	push hl			; $595b
	ld hl,$5972		; $595c
	rst_addAToHl			; $595f
	ld a,(hl)		; $5960
	pop hl			; $5961
	ld l,$50		; $5962
	ld (hl),a		; $5964
	ld bc,$fe80		; $5965
	call objectSetSpeedZ		; $5968
	call objectCopyPosition		; $596b
	dec b			; $596e
	jr nz,_label_0a_172	; $596f
	ret			; $5971
	inc a			; $5972
	ld b,(hl)		; $5973
	ld d,b			; $5974
	ld e,d			; $5975
	call objectApplySpeed		; $5976
	ld c,$28		; $5979
	call objectUpdateSpeedZ_paramC		; $597b
	jp z,interactionDelete		; $597e
	ret			; $5981
	ld e,$45		; $5982
	ld a,(de)		; $5984
	rst_jumpTable			; $5985
	adc h			; $5986
	ld e,c			; $5987
	sub l			; $5988
	ld e,c			; $5989
	and (hl)		; $598a
	ld e,c			; $598b
	call returnIfScrollMode01Unset		; $598c
	ld a,$01		; $598f
	ld e,$45		; $5991
	ld (de),a		; $5993
	ret			; $5994
	ld h,d			; $5995
	ld l,$70		; $5996
	dec (hl)		; $5998
	jr nz,_label_0a_173	; $5999
	ld l,$45		; $599b
	inc (hl)		; $599d
	push de			; $599e
	ld de,$59d8		; $599f
	call $59ba		; $59a2
	pop de			; $59a5
_label_0a_173:
	xor a			; $59a6
	call $5a82		; $59a7
	ret nz			; $59aa
	ld hl,$cc69		; $59ab
	res 1,(hl)		; $59ae
	xor a			; $59b0
	ld ($cca4),a		; $59b1
	ld ($cc02),a		; $59b4
	jp interactionDelete		; $59b7
	ld b,$03		; $59ba
_label_0a_174:
	call getFreeInteractionSlot		; $59bc
	jr nz,_label_0a_175	; $59bf
	ld a,(de)		; $59c1
	inc de			; $59c2
	ldi (hl),a		; $59c3
	ld a,(de)		; $59c4
	inc de			; $59c5
	ld (hl),a		; $59c6
	ld l,$4b		; $59c7
	ld a,(de)		; $59c9
	inc de			; $59ca
	ldi (hl),a		; $59cb
	inc l			; $59cc
	ld a,(de)		; $59cd
	inc de			; $59ce
	ld (hl),a		; $59cf
	ld l,$46		; $59d0
	ld (hl),$0a		; $59d2
	dec b			; $59d4
	jr nz,_label_0a_174	; $59d5
_label_0a_175:
	ret			; $59d7
	sub l			; $59d8
	ld bc,$7840		; $59d9
	sub (hl)		; $59dc
	ld (bc),a		; $59dd
	ld c,b			; $59de
	ld l,b			; $59df
	sub (hl)		; $59e0
	ld (bc),a		; $59e1
	ld c,b			; $59e2
	adc b			; $59e3
	sub l			; $59e4
	ld (bc),a		; $59e5
	ld l,b			; $59e6
	ld a,b			; $59e7
	sub (hl)		; $59e8
	inc bc			; $59e9
	ld h,b			; $59ea
	ld e,b			; $59eb
	sub (hl)		; $59ec
	inc bc			; $59ed
	ld b,b			; $59ee
	ld e,b			; $59ef
	ld e,$45		; $59f0
	ld a,(de)		; $59f2
	rst_jumpTable			; $59f3
.DB $fc				; $59f4
	ld e,c			; $59f5
	dec b			; $59f6
	ld e,d			; $59f7
	dec d			; $59f8
	ld e,d			; $59f9
	ld c,(hl)		; $59fa
	ld e,d			; $59fb
	call returnIfScrollMode01Unset		; $59fc
	ld a,$01		; $59ff
	ld e,$45		; $5a01
	ld (de),a		; $5a03
	ret			; $5a04
	ld h,d			; $5a05
	ld l,$70		; $5a06
	dec (hl)		; $5a08
	jr nz,_label_0a_176	; $5a09
	ld l,$45		; $5a0b
	inc (hl)		; $5a0d
	call fadeoutToWhite		; $5a0e
_label_0a_176:
	xor a			; $5a11
	jp $5a82		; $5a12
	ld a,($c4ab)		; $5a15
	or a			; $5a18
	ret nz			; $5a19
	ldh (<hSprPaletteSources),a	; $5a1a
	dec a			; $5a1c
	ldh (<hDirtySprPalettes),a	; $5a1d
	ld ($cfd0),a		; $5a1f
	call interactionIncState2		; $5a22
	ld l,$46		; $5a25
	ld (hl),$1e		; $5a27
	ld hl,$d00b		; $5a29
	ld a,$40		; $5a2c
	ldi (hl),a		; $5a2e
	inc l			; $5a2f
	ld (hl),$50		; $5a30
	ld a,$80		; $5a32
	ld ($d01a),a		; $5a34
	ld a,$02		; $5a37
	ld ($d008),a		; $5a39
	call setLinkForceStateToState08		; $5a3c
	push de			; $5a3f
	call hideStatusBar		; $5a40
	pop de			; $5a43
	ld c,$02		; $5a44
	ld hl,$5d0d		; $5a46
	ld e,$01		; $5a49
	jp interBankCall		; $5a4b
	call interactionDecCounter1		; $5a4e
	ret nz			; $5a51
	ld a,$03		; $5a52
	ld ($cc6a),a		; $5a54
	xor a			; $5a57
	ld ($c6a2),a		; $5a58
	jp interactionDelete		; $5a5b
	ld l,d			; $5a5e
	ld e,d			; $5a5f
	ld l,l			; $5a60
	ld e,d			; $5a61
	ld (hl),b		; $5a62
	ld e,d			; $5a63
	ld (hl),e		; $5a64
	ld e,d			; $5a65
	ld a,b			; $5a66
	ld e,d			; $5a67
	ld a,l			; $5a68
	ld e,d			; $5a69
	ld bc,$fd36		; $5a6a
	ld bc,$fc48		; $5a6d
	ld bc,$fd56		; $5a70
	ld (bc),a		; $5a73
	ld d,a			; $5a74
	ei			; $5a75
	ld e,b			; $5a76
.DB $fd				; $5a77
	ld (bc),a		; $5a78
_label_0a_177:
	scf			; $5a79
.DB $fd				; $5a7a
	jr c,_label_0a_177	; $5a7b
	ld (bc),a		; $5a7d
	ld b,(hl)		; $5a7e
	ei			; $5a7f
	ld b,a			; $5a80
.DB $fd				; $5a81
	ld h,d			; $5a82
	ld e,$46		; $5a83
	ld l,e			; $5a85
	dec (hl)		; $5a86
	ret nz			; $5a87
	ld hl,$5ac4		; $5a88
	rst_addDoubleIndex			; $5a8b
	ldi a,(hl)		; $5a8c
	ld h,(hl)		; $5a8d
	ld l,a			; $5a8e
	inc e			; $5a8f
	ld a,(de)		; $5a90
	add a			; $5a91
	rst_addDoubleIndex			; $5a92
	ld e,$46		; $5a93
	ldi a,(hl)		; $5a95
	ld (de),a		; $5a96
	inc a			; $5a97
	ret z			; $5a98
	inc e			; $5a99
	ld a,(de)		; $5a9a
	inc a			; $5a9b
	ld (de),a		; $5a9c
	push de			; $5a9d
	ld d,h			; $5a9e
	ld e,l			; $5a9f
	call getFreeInteractionSlot		; $5aa0
	jr nz,_label_0a_178	; $5aa3
	ld (hl),$9a		; $5aa5
	inc l			; $5aa7
	ld (hl),$00		; $5aa8
	inc l			; $5aaa
	ld a,(de)		; $5aab
	inc de			; $5aac
	ld (hl),a		; $5aad
	ld l,$4b		; $5aae
	ld a,(de)		; $5ab0
	ldi (hl),a		; $5ab1
	inc de			; $5ab2
	inc l			; $5ab3
	ld a,(de)		; $5ab4
	ld (hl),a		; $5ab5
	ld a,$6f		; $5ab6
	call playSound		; $5ab8
	ld a,$08		; $5abb
	call setScreenShakeCounter		; $5abd
_label_0a_178:
	pop de			; $5ac0
	or $01			; $5ac1
	ret			; $5ac3
	ret z			; $5ac4
	ld e,d			; $5ac5
	pop hl			; $5ac6
	ld e,d			; $5ac7
	inc d			; $5ac8
	ld bc,$683a		; $5ac9
	inc d			; $5acc
	ld (bc),a		; $5acd
	ld b,(hl)		; $5ace
	adc d			; $5acf
	stop			; $5ad0
	inc bc			; $5ad1
	ld d,(hl)		; $5ad2
	ld l,d			; $5ad3
	stop			; $5ad4
	inc b			; $5ad5
	ld e,b			; $5ad6
	add (hl)		; $5ad7
	inc c			; $5ad8
	dec b			; $5ad9
	ldd (hl),a		; $5ada
	ld a,(hl)		; $5adb
	inc c			; $5adc
	ld b,$48		; $5add
	ld (hl),e		; $5adf
	rst $38			; $5ae0
	ld a,(bc)		; $5ae1
	nop			; $5ae2
	ld e,b			; $5ae3
	add b			; $5ae4
	ld a,(bc)		; $5ae5
	nop			; $5ae6
	jr _label_0a_179		; $5ae7
	ld a,(bc)		; $5ae9
	nop			; $5aea
	ld c,b			; $5aeb
	jr nc,$0a		; $5aec
	nop			; $5aee
	jr z,_label_0a_182	; $5aef
	ld a,(bc)		; $5af1
	nop			; $5af2
	ld l,b			; $5af3
	ld h,b			; $5af4
	ld a,(bc)		; $5af5
	nop			; $5af6
	jr c,$40		; $5af7
	ld a,(bc)		; $5af9
	nop			; $5afa
	ld e,b			; $5afb
	add b			; $5afc
	ld a,(bc)		; $5afd
	nop			; $5afe
	jr _label_0a_179		; $5aff
	ld a,(bc)		; $5b01
	nop			; $5b02
	ld c,b			; $5b03
	jr nc,$0a		; $5b04
	nop			; $5b06
	jr z,$68		; $5b07
	ld a,(bc)		; $5b09
	nop			; $5b0a
	ld l,b			; $5b0b
	ld h,b			; $5b0c
	ld a,(bc)		; $5b0d
	nop			; $5b0e
	jr c,_label_0a_181	; $5b0f
	rst $38			; $5b11

interactionCode9b:
	ld e,$44		; $5b12
	ld a,(de)		; $5b14
	rst_jumpTable			; $5b15
	ld a,(de)		; $5b16
	ld e,e			; $5b17
	inc h			; $5b18
	ld e,e			; $5b19
	ld a,$01		; $5b1a
	ld (de),a		; $5b1c
	xor a			; $5b1d
	ld ($cfd0),a		; $5b1e
_label_0a_179:
	ld ($cfd1),a		; $5b21
	ld a,($cfd0)		; $5b24
	cp $02			; $5b27
	jr nz,_label_0a_180	; $5b29
	ld hl,$cfd1		; $5b2b
	ld a,(hl)		; $5b2e
	cp $03			; $5b2f
	ret nz			; $5b31
	ld ($cc02),a		; $5b32
	ld hl,$cc63		; $5b35
	ld a,$80		; $5b38
	ldi (hl),a		; $5b3a
	ld a,$6f		; $5b3b
	ldi (hl),a		; $5b3d
	ld a,$0f		; $5b3e
	ldi (hl),a		; $5b40
	ld a,$55		; $5b41
	ldi (hl),a		; $5b43
	ld (hl),$03		; $5b44
	jp interactionDelete		; $5b46
_label_0a_180:
	ld e,$45		; $5b49
	ld a,(de)		; $5b4b
	rst_jumpTable			; $5b4c
	ld d,l			; $5b4d
	ld e,e			; $5b4e
	ld l,a			; $5b4f
	ld e,e			; $5b50
_label_0a_181:
	sbc d			; $5b51
	ld e,e			; $5b52
	ret z			; $5b53
	ld e,e			; $5b54
	ld a,($cfd0)		; $5b55
	or a			; $5b58
_label_0a_182:
	ret z			; $5b59
	xor a			; $5b5a
	ld ($cbb3),a		; $5b5b
	dec a			; $5b5e
	ld ($cbba),a		; $5b5f
	jp interactionIncState2		; $5b62
	bit 6,a			; $5b65
	set 6,(hl)		; $5b67
	ret z			; $5b69
	res 6,(hl)		; $5b6a
	set 7,(hl)		; $5b6c
	ret			; $5b6e
	ld hl,$cbb3		; $5b6f
	ld b,$02		; $5b72
	call flashScreen		; $5b74
	ret z			; $5b77
	ld hl,$cfd0		; $5b78
	ld (hl),$ff		; $5b7b
	push de			; $5b7d
	call hideStatusBar		; $5b7e
	call clearItems		; $5b81
	pop de			; $5b84
	xor a			; $5b85
	ld ($d01a),a		; $5b86
	call clearPaletteFadeVariablesAndRefreshPalettes		; $5b89
	ld a,$ff		; $5b8c
	ldh (<hDirtyBgPalettes),a	; $5b8e
	ldh (<hBgPaletteSources),a	; $5b90
	call interactionIncState2		; $5b92
	ld l,$46		; $5b95
	ld (hl),$1e		; $5b97
	ret			; $5b99
	ld a,$01		; $5b9a
	call $5a82		; $5b9c
	ret nz			; $5b9f
	ld a,$40		; $5ba0
	ld ($d00b),a		; $5ba2
	ld a,$50		; $5ba5
	ld ($d00d),a		; $5ba7
	ld a,$80		; $5baa
	ld ($d01a),a		; $5bac
	ld a,$02		; $5baf
	ld ($d008),a		; $5bb1
	call setLinkForceStateToState08		; $5bb4
	call interactionIncState2		; $5bb7
	ld l,$46		; $5bba
	ld (hl),$1e		; $5bbc
	ld c,$02		; $5bbe
	ld hl,$5d0d		; $5bc0
	ld e,$01		; $5bc3
	jp interBankCall		; $5bc5
	call interactionDecCounter1		; $5bc8
	ret nz			; $5bcb
	ld a,$12		; $5bcc
	call unsetGlobalFlag		; $5bce
	call getThisRoomFlags		; $5bd1
	call $5b65		; $5bd4
	ld c,(hl)		; $5bd7
	ld a,$00		; $5bd8
	ld b,$6f		; $5bda
	call getRoomFlags		; $5bdc
	ld (hl),c		; $5bdf
	ld a,$03		; $5be0
	ld ($cc6a),a		; $5be2
	xor a			; $5be5
	ld ($c6a2),a		; $5be6
	jp interactionDelete		; $5be9

interactionCode9c:
	ld e,$44		; $5bec
	ld a,(de)		; $5bee
	rst_jumpTable			; $5bef
	nop			; $5bf0
	ld e,h			; $5bf1
	dec d			; $5bf2
	ld e,h			; $5bf3
	ldd a,(hl)		; $5bf4
	ld e,h			; $5bf5
	adc h			; $5bf6
	ld e,h			; $5bf7
	or (hl)			; $5bf8
	ld e,h			; $5bf9
	ret nz			; $5bfa
	ld e,h			; $5bfb
	push de			; $5bfc
	ld e,h			; $5bfd
	or (hl)			; $5bfe
	ld e,h			; $5bff
	ld a,$01		; $5c00
	ld (de),a		; $5c02
	ld a,($cc4e)		; $5c03
	or a			; $5c06
	jp nz,interactionDelete		; $5c07
	ld a,$06		; $5c0a
	call objectSetCollideRadius		; $5c0c
	call interactionInitGraphics		; $5c0f
	call objectSetVisible83		; $5c12
	ld a,($ccc3)		; $5c15
	or a			; $5c18
	jr z,_label_0a_183	; $5c19
	ld a,$05		; $5c1b
	jr _label_0a_184		; $5c1d
_label_0a_183:
	ld a,($cc88)		; $5c1f
	or a			; $5c22
	ret nz			; $5c23
	ld a,($cc48)		; $5c24
	rrca			; $5c27
	ret c			; $5c28
	call objectCheckCollidedWithLink		; $5c29
	ret nc			; $5c2c
	ld a,$02		; $5c2d
	ld ($ccc3),a		; $5c2f
_label_0a_184:
	ld e,$44		; $5c32
	ld (de),a		; $5c34
	ld a,$01		; $5c35
	jp interactionSetAnimation		; $5c37
	call interactionAnimate		; $5c3a
	ld e,$61		; $5c3d
	ld a,(de)		; $5c3f
	or a			; $5c40
	ret z			; $5c41
	ld a,($cc48)		; $5c42
	cp $d0			; $5c45
	jp nz,seasonsFunc_0a_5d18		; $5c47
	call checkLinkID0AndControlNormal		; $5c4a
	jp nc,seasonsFunc_0a_5d18		; $5c4d
	call objectCheckCollidedWithLink		; $5c50
	jp nc,seasonsFunc_0a_5d18		; $5c53
	ld e,$44		; $5c56
	ld a,$03		; $5c58
	ld (de),a		; $5c5a
	call clearAllParentItems		; $5c5b
	call dropLinkHeldItem		; $5c5e
	call resetLinkInvincibility		; $5c61
	ld a,$83		; $5c64
	ld ($cca4),a		; $5c66
	ld ($cc88),a		; $5c69
	call setLinkForceStateToState08		; $5c6c
	call interactionSetAlwaysUpdateBit		; $5c6f
	xor a			; $5c72
	ld e,$61		; $5c73
	call $5cf2		; $5c75
	ld e,$4d		; $5c78
	ld a,(de)		; $5c7a
	ld ($d00d),a		; $5c7b
	xor a			; $5c7e
	ld ($d00f),a		; $5c7f
	ld a,$52		; $5c82
	call playSound		; $5c84
	ld a,$02		; $5c87
	jp interactionSetAnimation		; $5c89
	ld a,$10		; $5c8c
	ld ($cc6b),a		; $5c8e
	call interactionAnimate		; $5c91
	ld e,$61		; $5c94
	ld a,(de)		; $5c96
	inc a			; $5c97
	jr z,_label_0a_185	; $5c98
	cp $02			; $5c9a
	call nc,$5cf2		; $5c9c
	ret			; $5c9f
_label_0a_185:
	ld a,$06		; $5ca0
	call $5cf2		; $5ca2
	xor a			; $5ca5
	ld ($cca4),a		; $5ca6
	ld e,$44		; $5ca9
	ld a,$04		; $5cab
	ld (de),a		; $5cad
	ld a,$06		; $5cae
	ld ($cc6a),a		; $5cb0
	jp objectSetVisible83		; $5cb3
	call interactionAnimate		; $5cb6
	ld e,$61		; $5cb9
	ld a,(de)		; $5cbb
	inc a			; $5cbc
	ret nz			; $5cbd
	jr $58			; $5cbe
	call interactionAnimate		; $5cc0
	ld e,$61		; $5cc3
	ld a,(de)		; $5cc5
	or a			; $5cc6
	ret z			; $5cc7
	ld a,$52		; $5cc8
	call playSound		; $5cca
	call interactionIncState		; $5ccd
	ld a,$02		; $5cd0
	jp interactionSetAnimation		; $5cd2
	call interactionAnimate		; $5cd5
	ld e,$61		; $5cd8
	ld a,(de)		; $5cda
	inc a			; $5cdb
	jr nz,_label_0a_186	; $5cdc
	ld (de),a		; $5cde
	ld ($ccc3),a		; $5cdf
	call objectSetVisible83		; $5ce2
	jp interactionIncState		; $5ce5
_label_0a_186:
	dec a			; $5ce8
	ld ($ccc3),a		; $5ce9
	cp $02			; $5cec
	ret c			; $5cee
	jp objectSetVisible82		; $5cef
	ld hl,$5d08		; $5cf2
	rst_addDoubleIndex			; $5cf5
	xor a			; $5cf6
	ld (de),a		; $5cf7
	ld e,$4b		; $5cf8
	ld a,(de)		; $5cfa
	add (hl)		; $5cfb
	ld ($d00b),a		; $5cfc
	inc hl			; $5cff
	ld e,$5a		; $5d00
	ld a,(de)		; $5d02
	and $f0			; $5d03
	or (hl)			; $5d05
	ld (de),a		; $5d06
	ret			; $5d07
	ld sp,hl		; $5d08
	inc bc			; $5d09
	ld sp,hl		; $5d0a
	inc bc			; $5d0b
	ld hl,sp+$03		; $5d0c
	ld sp,hl		; $5d0e
	ld bc,$01fa		; $5d0f
	rst $38			; $5d12
	ld bc,$01f0		; $5d13
	nop			; $5d16
	.db $01		; $5d17

seasonsFunc_0a_5d18:
	ld e,$44		; $5d18
	ld a,$01		; $5d1a
	ld (de),a		; $5d1c
	dec a			; $5d1d
	ld ($ccc3),a		; $5d1e
	call interactionSetAlwaysUpdateBit		; $5d21
	res 7,(hl)		; $5d24
	call objectSetVisible83		; $5d26
	ld a,$00		; $5d29
	jp interactionSetAnimation		; $5d2b

interactionCode9d:
	ld e,$44		; $5d2e
	ld a,(de)		; $5d30
	rst_jumpTable			; $5d31
	ld (hl),$5d		; $5d32
	ld b,a			; $5d34
	ld e,(hl)		; $5d35
	ld a,$01		; $5d36
	ld (de),a		; $5d38
	ld a,$28		; $5d39
	call checkGlobalFlag		; $5d3b
	jp nz,interactionDelete		; $5d3e
	call interactionInitGraphics		; $5d41
	call objectSetVisible82		; $5d44
	ld e,$42		; $5d47
	ld a,(de)		; $5d49
	rst_jumpTable			; $5d4a
	ld d,a			; $5d4b
	ld e,l			; $5d4c
	add l			; $5d4d
	ld e,l			; $5d4e
	cp e			; $5d4f
	ld e,l			; $5d50
	call $df5d		; $5d51
	ld e,l			; $5d54
	inc sp			; $5d55
	ld e,(hl)		; $5d56
	ld a,$40		; $5d57
	call checkTreasureObtained		; $5d59
	jp c,interactionDelete		; $5d5c
	call getThisRoomFlags		; $5d5f
	and $40			; $5d62
	jr nz,_label_0a_187	; $5d64
	ld a,$1f		; $5d66
	call playSound		; $5d68
	ld a,($cc62)		; $5d6b
	ld (wActiveMusic),a		; $5d6e
	jr _label_0a_188		; $5d71
_label_0a_187:
	ld h,d			; $5d73
	ld l,$4b		; $5d74
	ld (hl),$28		; $5d76
	inc l			; $5d78
	inc l			; $5d79
	ld (hl),$18		; $5d7a
	ld l,$42		; $5d7c
	ld (hl),$01		; $5d7e
_label_0a_188:
	ld hl,$74a9		; $5d80
	jr _label_0a_192		; $5d83
	call $7a68		; $5d85
	jp nz,interactionDelete		; $5d88
	call $7a7b		; $5d8b
	jp nz,interactionDelete		; $5d8e
	ld a,$22		; $5d91
	call checkGlobalFlag		; $5d93
	jr z,_label_0a_189	; $5d96
	ld a,$23		; $5d98
	call checkGlobalFlag		; $5d9a
	jp z,interactionDelete		; $5d9d
_label_0a_189:
	call checkIsLinkedGame		; $5da0
	jr z,_label_0a_190	; $5da3
	ld a,$1f		; $5da5
	call checkGlobalFlag		; $5da7
	jp z,$5db1		; $5daa
	ld a,$0c		; $5dad
	jr _label_0a_191		; $5daf
_label_0a_190:
	ld a,$40		; $5db1
	call checkTreasureObtained		; $5db3
	call getHighestSetBit		; $5db6
	jr _label_0a_191		; $5db9
	call $7a68		; $5dbb
	jp z,interactionDelete		; $5dbe
	ld a,$03		; $5dc1
	ld e,$7b		; $5dc3
	ld (de),a		; $5dc5
	call interactionSetAnimation		; $5dc6
	ld a,$08		; $5dc9
	jr _label_0a_191		; $5dcb
	call $7a7b		; $5dcd
	jp z,interactionDelete		; $5dd0
	ld a,$09		; $5dd3
_label_0a_191:
	ld hl,$5ec8		; $5dd5
	rst_addDoubleIndex			; $5dd8
	ldi a,(hl)		; $5dd9
	ld h,(hl)		; $5dda
	ld l,a			; $5ddb
_label_0a_192:
	jp interactionSetScript		; $5ddc
	call checkIsLinkedGame		; $5ddf
	jp z,interactionDelete		; $5de2
	ld a,$40		; $5de5
	call checkTreasureObtained		; $5de7
	jp nc,interactionDelete		; $5dea
	and $02			; $5ded
	jp z,interactionDelete		; $5def
	ld a,$22		; $5df2
	call checkGlobalFlag		; $5df4
	jp nz,interactionDelete		; $5df7
	ld bc,$ff00		; $5dfa
	call objectSetSpeedZ		; $5dfd
	ld hl,$5ec3		; $5e00
	ld a,$0a		; $5e03
	push de			; $5e05
	call setSimulatedInputAddress		; $5e06
	pop de			; $5e09
	ld hl,$d00b		; $5e0a
	ld (hl),$76		; $5e0d
	inc l			; $5e0f
	inc l			; $5e10
	ld (hl),$56		; $5e11
	call getFreeInteractionSlot		; $5e13
	jr nz,_label_0a_193	; $5e16
	ld (hl),$2a		; $5e18
	inc l			; $5e1a
	ld (hl),$0a		; $5e1b
	ld l,$56		; $5e1d
	ld (hl),$40		; $5e1f
	inc l			; $5e21
	ld (hl),d		; $5e22
	call objectCopyPosition		; $5e23
_label_0a_193:
	call objectSetInvisible		; $5e26
	call interactionSetAlwaysUpdateBit		; $5e29
	ld a,$0a		; $5e2c
	ld ($cc02),a		; $5e2e
	jr _label_0a_191		; $5e31
	ld a,$22		; $5e33
	call checkGlobalFlag		; $5e35
	jp z,interactionDelete		; $5e38
	ld a,$23		; $5e3b
	call checkGlobalFlag		; $5e3d
	jp nz,interactionDelete		; $5e40
	ld a,$0b		; $5e43
	jr _label_0a_191		; $5e45
	call interactionRunScript		; $5e47
	ld e,$42		; $5e4a
	ld a,(de)		; $5e4c
	rst_jumpTable			; $5e4d
	ld e,d			; $5e4e
	ld e,(hl)		; $5e4f
	adc e			; $5e50
	ld e,(hl)		; $5e51
	sub (hl)		; $5e52
	ld e,(hl)		; $5e53
	adc (hl)		; $5e54
	ld e,(hl)		; $5e55
	sbc c			; $5e56
	ld e,(hl)		; $5e57
	adc e			; $5e58
	ld e,(hl)		; $5e59
	call checkInteractionState2		; $5e5a
	jr nz,_label_0a_194	; $5e5d
	inc a			; $5e5f
	ld (de),a		; $5e60
	ld a,$08		; $5e61
	call setLinkIDOverride		; $5e63
	ld l,$02		; $5e66
	ld (hl),$02		; $5e68
	ld l,$0b		; $5e6a
	ld (hl),$48		; $5e6c
	ld l,$0d		; $5e6e
	ld (hl),$58		; $5e70
	ld l,$08		; $5e72
	ld (hl),$00		; $5e74
_label_0a_194:
	call getThisRoomFlags		; $5e76
	and $40			; $5e79
	jr z,_label_0a_195	; $5e7b
	ld e,$42		; $5e7d
	ld a,$01		; $5e7f
	ld (de),a		; $5e81
_label_0a_195:
	call interactionAnimate		; $5e82
	call objectPreventLinkFromPassing		; $5e85
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $5e88
	jp npcFaceLinkAndAnimate		; $5e8b
	ld a,$26		; $5e8e
	call checkGlobalFlag		; $5e90
	jp nz,npcFaceLinkAndAnimate		; $5e93
	jp interactionAnimateAsNpc		; $5e96
	call checkInteractionState2		; $5e99
	jr nz,_label_0a_196	; $5e9c
	ld a,($cbc3)		; $5e9e
	rlca			; $5ea1
	ret nc			; $5ea2
	xor a			; $5ea3
	ld ($cbc3),a		; $5ea4
	inc a			; $5ea7
	ld ($cca4),a		; $5ea8
	call interactionIncState2		; $5eab
	jp objectSetVisible		; $5eae
_label_0a_196:
	ld a,($cba0)		; $5eb1
	or a			; $5eb4
	call nz,seasonsFunc_0a_6710		; $5eb5
	call interactionAnimateAsNpc		; $5eb8
	ld e,$47		; $5ebb
	ld a,(de)		; $5ebd
	or a			; $5ebe
	jp nz,interactionAnimate		; $5ebf
	ret			; $5ec2
	jr nz,_label_0a_197	; $5ec3
_label_0a_197:
	ld b,b			; $5ec5
	rst $38			; $5ec6
	rst $38			; $5ec7
	ld sp,hl		; $5ec8
	ld (hl),h		; $5ec9
	inc bc			; $5eca
	ld (hl),l		; $5ecb
	ld b,$75		; $5ecc
	stop			; $5ece
	ld (hl),l		; $5ecf
	inc de			; $5ed0
	ld (hl),l		; $5ed1
	jr nz,_label_0a_198	; $5ed2
	inc hl			; $5ed4
	ld (hl),l		; $5ed5
	ld h,$75		; $5ed6
	add hl,hl		; $5ed8
	ld (hl),l		; $5ed9
	scf			; $5eda
	ld (hl),l		; $5edb
	ld c,h			; $5edc
	ld (hl),l		; $5edd
	ld d,b			; $5ede
	ld (hl),l		; $5edf
	ld d,e			; $5ee0
	ld (hl),l		; $5ee1

interactionCode9e:
	ld e,$44		; $5ee2
	ld a,(de)		; $5ee4
	rst_jumpTable			; $5ee5
	ld ($015e),a		; $5ee6
	ld e,a			; $5ee9
	call getThisRoomFlags		; $5eea
	bit 7,(hl)		; $5eed
	jp nz,interactionDelete		; $5eef
	call interactionInitGraphics		; $5ef2
	call interactionIncState		; $5ef5
	ld bc,$604d		; $5ef8
	ld l,$7b		; $5efb
	ld (hl),b		; $5efd
	inc hl			; $5efe
	ld (hl),c		; $5eff
	ret			; $5f00
	ld e,$45		; $5f01
	ld a,(de)		; $5f03
	rst_jumpTable			; $5f04
	rrca			; $5f05
	ld e,a			; $5f06
	cpl			; $5f07
	ld e,a			; $5f08
	ccf			; $5f09
	ld e,a			; $5f0a
	ld c,(hl)		; $5f0b
	ld e,a			; $5f0c
	ld l,a			; $5f0d
	ld e,a			; $5f0e
	call $5f8c		; $5f0f
	ld e,$79		; $5f12
	ld a,(de)		; $5f14
	cp $ff			; $5f15
	ret nz			; $5f17
	call interactionIncState2		; $5f18
	ld l,$7d		; $5f1b
	ld (hl),$28		; $5f1d
	ld a,$81		; $5f1f
	ld ($cca4),a		; $5f21
	ld a,$80		; $5f24
	ld ($cc02),a		; $5f26
	ld hl,$7556		; $5f29
	jp interactionSetScript		; $5f2c
	call $5f87		; $5f2f
	ret nz			; $5f32
	call interactionIncState2		; $5f33
	ld l,$7d		; $5f36
	ld (hl),$78		; $5f38
	ld a,$b8		; $5f3a
	jp playSound		; $5f3c
	call $606a		; $5f3f
	call $5f87		; $5f42
	ret nz			; $5f45
	call interactionIncState2		; $5f46
_label_0a_198:
	ld l,$7d		; $5f49
	ld (hl),$01		; $5f4b
	ret			; $5f4d
	call interactionRunScript		; $5f4e
	call $606a		; $5f51
	call $5f87		; $5f54
	ret nz			; $5f57
	call $602c		; $5f58
	jr z,_label_0a_199	; $5f5b
	ld h,d			; $5f5d
	ld l,$7d		; $5f5e
	ld (hl),$32		; $5f60
	ld a,$6f		; $5f62
	jp playSound		; $5f64
_label_0a_199:
	call interactionIncState2		; $5f67
	ld l,$7d		; $5f6a
	ld (hl),$28		; $5f6c
	ret			; $5f6e
	call $5f87		; $5f6f
	ret nz			; $5f72
	xor a			; $5f73
	ld ($cc02),a		; $5f74
	ld ($cca4),a		; $5f77
	ld a,$4d		; $5f7a
	call playSound		; $5f7c
	call getThisRoomFlags		; $5f7f
	set 7,(hl)		; $5f82
	jp interactionDelete		; $5f84
	ld h,d			; $5f87
	ld l,$7d		; $5f88
	dec (hl)		; $5f8a
	ret			; $5f8b
	call $5fcd		; $5f8c
	jr z,_label_0a_201	; $5f8f
	call checkLinkID0AndControlNormal		; $5f91
	ret nc			; $5f94
	ld a,($cc46)		; $5f95
	bit 6,a			; $5f98
	jr z,_label_0a_200	; $5f9a
	ld c,$01		; $5f9c
	ld b,$b0		; $5f9e
	jp $5fba		; $5fa0
_label_0a_200:
	ld a,($cc45)		; $5fa3
	bit 6,a			; $5fa6
	ret nz			; $5fa8
_label_0a_201:
	ld h,d			; $5fa9
	ld l,$78		; $5faa
	ld a,$00		; $5fac
	cp (hl)			; $5fae
	ret z			; $5faf
	ld c,$00		; $5fb0
	ld b,$b1		; $5fb2
	call $5fba		; $5fb4
	jp $6001		; $5fb7
	ld h,d			; $5fba
	ld l,$78		; $5fbb
	ld (hl),c		; $5fbd
	ld a,$13		; $5fbe
	ld l,$79		; $5fc0
	add (hl)		; $5fc2
	ld c,a			; $5fc3
	ld a,b			; $5fc4
	call setTile		; $5fc5
	ld a,$70		; $5fc8
	jp playSound		; $5fca
	ld hl,$5ff4		; $5fcd
	ld a,($d00b)		; $5fd0
	ld c,a			; $5fd3
	ld a,($d00d)		; $5fd4
	ld b,a			; $5fd7
_label_0a_202:
	ldi a,(hl)		; $5fd8
	or a			; $5fd9
	ret z			; $5fda
	add $04			; $5fdb
	sub c			; $5fdd
	cp $09			; $5fde
	jr nc,_label_0a_203	; $5fe0
	ldi a,(hl)		; $5fe2
	add $03			; $5fe3
	sub b			; $5fe5
	cp $07			; $5fe6
	jr nc,_label_0a_204	; $5fe8
	ld a,(hl)		; $5fea
	ld e,$79		; $5feb
	ld (de),a		; $5fed
	or d			; $5fee
	ret			; $5fef
_label_0a_203:
	inc hl			; $5ff0
_label_0a_204:
	inc hl			; $5ff1
	jr _label_0a_202		; $5ff2
	jr nz,_label_0a_207	; $5ff4
	nop			; $5ff6
	jr nz,_label_0a_209	; $5ff7
	ld bc,$5820		; $5ff9
	ld (bc),a		; $5ffc
	jr nz,_label_0a_212	; $5ffd
	inc bc			; $5fff
	nop			; $6000
	ld h,d			; $6001
	ld l,$7a		; $6002
	ld a,(hl)		; $6004
	ld bc,$6024		; $6005
	call addAToBc		; $6008
	ld a,(bc)		; $600b
	ld b,a			; $600c
	ld l,$79		; $600d
	ld a,(hl)		; $600f
	ld l,$7a		; $6010
	cp b			; $6012
	jr nz,_label_0a_205	; $6013
	ld a,(hl)		; $6015
	cp $07			; $6016
	jr z,_label_0a_206	; $6018
	inc (hl)		; $601a
	ret			; $601b
_label_0a_205:
	ld (hl),$00		; $601c
	ret			; $601e
_label_0a_206:
	ld l,$79		; $601f
	ld (hl),$ff		; $6021
	ret			; $6023
	ld (bc),a		; $6024
	ld (bc),a		; $6025
	ld bc,$0000		; $6026
	inc bc			; $6029
	inc bc			; $602a
	inc bc			; $602b
	ld e,$7b		; $602c
_label_0a_207:
	ld a,(de)		; $602e
	ld h,a			; $602f
	inc de			; $6030
	ld a,(de)		; $6031
	ld l,a			; $6032
_label_0a_208:
	ldi a,(hl)		; $6033
	or a			; $6034
	jr z,_label_0a_210	; $6035
	cp $ff			; $6037
	jr z,_label_0a_211	; $6039
	ld c,a			; $603b
	ldi a,(hl)		; $603c
	push hl			; $603d
	call setTile		; $603e
_label_0a_209:
	pop hl			; $6041
	jr _label_0a_208		; $6042
_label_0a_210:
	ld e,$7b		; $6044
	ld a,h			; $6046
	ld (de),a		; $6047
	inc e			; $6048
	ld a,l			; $6049
	ld (de),a		; $604a
	or d			; $604b
_label_0a_211:
	ret			; $604c
	inc bc			; $604d
	xor a			; $604e
	inc de			; $604f
	and b			; $6050
	nop			; $6051
	inc de			; $6052
	xor a			; $6053
	inc b			; $6054
	xor a			; $6055
	inc d			; $6056
	and b			; $6057
	nop			; $6058
	inc d			; $6059
	xor a			; $605a
	dec b			; $605b
	xor a			; $605c
	dec d			; $605d
	and b			; $605e
	nop			; $605f
	dec d			; $6060
	xor a			; $6061
	ld b,$af		; $6062
	ld d,$a0		; $6064
	nop			; $6066
_label_0a_212:
	ld d,$af		; $6067
	rst $38			; $6069
	ld a,(wFrameCounter)		; $606a
	and $07			; $606d
	ret nz			; $606f
	ld a,$02		; $6070
	jp setScreenShakeCounter		; $6072


; ==============================================================================
; INTERACID_MOVING_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea1:
	call _sidescrollPlatform_checkLinkOnPlatform		; $5817
	call @updateSubid		; $581a
	jp _sidescrollingPlatformCommon		; $581d

@updateSubid:
	ld e,Interaction.state		; $5820
	ld a,(de)		; $5822
	sub $08			; $5823
	jr c,@state0To7		; $5825
	rst_jumpTable			; $5827
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw _movingPlatform_stateC

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.movingSidescrollPlatformScriptTable		; $5832
.else
	ld hl,movingSidescrollPlatformScriptTable
.endif
	call objectLoadMovementScript		; $5835
	call interactionInitGraphics		; $5838
	ld e,Interaction.direction		; $583b
	ld a,(de)		; $583d
	ld hl,@collisionRadii		; $583e
	rst_addDoubleIndex			; $5841
	ld e,Interaction.collisionRadiusY		; $5842
	ldi a,(hl)		; $5844
	ld (de),a		; $5845
	inc e			; $5846
	ld a,(hl)		; $5847
	ld (de),a		; $5848
	ld e,Interaction.direction		; $5849
	ld a,(de)		; $584b
	call interactionSetAnimation		; $584c
	jp objectSetVisible82		; $584f

@collisionRadii:
	.db $09 $0f
	.db $09 $17
	.db $19 $07
	.db $19 $0f
	.db $09 $07

@state8:
	ld e,Interaction.var32		; $585c
	ld a,(de)		; $585e
	ld h,d			; $585f
	ld l,Interaction.yh		; $5860
	cp (hl)			; $5862
	jr nc,+			; $5863
	jp objectApplySpeed		; $5865
+
	ld a,(de)		; $5868
	ld (hl),a		; $5869
	jp _sidescrollPlatformFunc_5bfc		; $586a

@state9:
	ld e,Interaction.xh		; $586d
	ld a,(de)		; $586f
	ld h,d			; $5870
	ld l,Interaction.var33		; $5871
	cp (hl)			; $5873
	jr nc,++		; $5874
	ld l,Interaction.speed		; $5876
	ld b,(hl)		; $5878
	ld c,ANGLE_RIGHT		; $5879
	ld a,(wLinkRidingObject)		; $587b
	cp d			; $587e
	call z,updateLinkPositionGivenVelocity		; $587f
	jp objectApplySpeed		; $5882
++
	ld a,(hl)		; $5885
	ld (de),a		; $5886
	jp _sidescrollPlatformFunc_5bfc		; $5887

@stateA:
	ld e,Interaction.yh		; $588a
	ld a,(de)		; $588c
	ld h,d			; $588d
	ld l,Interaction.var32		; $588e
	cp (hl)			; $5890
	jr nc,++		; $5891
	ld l,Interaction.speed		; $5893
	ld b,(hl)		; $5895
	ld c,ANGLE_DOWN		; $5896
	ld a,(wLinkRidingObject)		; $5898
	cp d			; $589b
	call z,updateLinkPositionGivenVelocity		; $589c
	jp objectApplySpeed		; $589f
++
	ld a,(hl)		; $58a2
	ld (de),a		; $58a3
	jp _sidescrollPlatformFunc_5bfc		; $58a4

@stateB:
	ld e,Interaction.var33		; $58a7
	ld a,(de)		; $58a9
	ld h,d			; $58aa
	ld l,Interaction.xh		; $58ab
	cp (hl)			; $58ad
	jr nc,++		; $58ae
	ld l,Interaction.speed		; $58b0
	ld b,(hl)		; $58b2
	ld c,ANGLE_LEFT		; $58b3
	ld a,(wLinkRidingObject)		; $58b5
	cp d			; $58b8
	call z,updateLinkPositionGivenVelocity		; $58b9
	jp objectApplySpeed		; $58bc
++
	ld a,(de)		; $58bf
	ld (hl),a		; $58c0
	jp _sidescrollPlatformFunc_5bfc		; $58c1


_movingPlatform_stateC:
	call interactionDecCounter1		; $58c4
	ret nz			; $58c7
	jp _sidescrollPlatformFunc_5bfc		; $58c8


; ==============================================================================
; INTERACID_MOVING_SIDESCROLL_CONVEYOR
; ==============================================================================
interactionCodea2:
	call interactionAnimate		; $58cb
	call _sidescrollPlatform_checkLinkOnPlatform		; $58ce
	call nz,_sidescrollPlatform_updateLinkKnockbackForConveyor		; $58d1
	call @updateState		; $58d4
	jp _sidescrollingPlatformCommon		; $58d7

@updateState:
	ld e,Interaction.state		; $58da
	ld a,(de)		; $58dc
	sub $08			; $58dd
	jr c,@state0To7		; $58df
	rst_jumpTable			; $58e1
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw _movingPlatform_stateC

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.movingSidescrollConveyorScriptTable		; $58ec
.else
	ld hl,movingSidescrollConveyorScriptTable
.endif
	call objectLoadMovementScript		; $58ef
	call interactionInitGraphics		; $58f2
	ld h,d			; $58f5
	ld l,Interaction.collisionRadiusY		; $58f6
	ld (hl),$08		; $58f8
	inc l			; $58fa
	ld (hl),$0c		; $58fb
	ld e,Interaction.direction		; $58fd
	ld a,(de)		; $58ff
	call interactionSetAnimation		; $5900
	jp objectSetVisible82		; $5903

@state8:
	ld e,Interaction.var32		; $5906
	ld a,(de)		; $5908
	ld h,d			; $5909
	ld l,Interaction.yh		; $590a
	cp (hl)			; $590c
	jr c,@applySpeed	; $590d
	ld a,(de)		; $590f
	ld (hl),a		; $5910
	jp _sidescrollPlatformFunc_5bfc		; $5911

@state9:
	ld e,Interaction.xh		; $5914
	ld a,(de)		; $5916
	ld h,d			; $5917
	ld l,Interaction.var33		; $5918
	cp (hl)			; $591a
	jr c,@applySpeed	; $591b
	ld a,(hl)		; $591d
	ld (de),a		; $591e
	jp _sidescrollPlatformFunc_5bfc		; $591f

@stateA:
	ld e,Interaction.yh		; $5922
	ld a,(de)		; $5924
	ld h,d			; $5925
	ld l,Interaction.var32		; $5926
	cp (hl)			; $5928
	jr nc,++		; $5929
	ld l,Interaction.speed		; $592b
	ld b,(hl)		; $592d
	ld c,ANGLE_DOWN		; $592e
	ld a,(wLinkRidingObject)		; $5930
	cp d			; $5933
	call z,updateLinkPositionGivenVelocity		; $5934
	jr @applySpeed		; $5937
++
	ld a,(hl)		; $5939
	ld (de),a		; $593a
	jp _sidescrollPlatformFunc_5bfc		; $593b

@stateB:
	ld e,Interaction.var33		; $593e
	ld a,(de)		; $5940
	ld h,d			; $5941
	ld l,Interaction.xh		; $5942
	cp (hl)			; $5944
	jr c,@applySpeed	; $5945
	ld a,(de)		; $5947
	ld (hl),a		; $5948
	jp _sidescrollPlatformFunc_5bfc		; $5949

@applySpeed:
	call objectApplySpeed		; $594c
	ld a,(wLinkRidingObject)		; $594f
	cp d			; $5952
	ret nz			; $5953

	ld e,Interaction.angle		; $5954
	ld a,(de)		; $5956
	rrca			; $5957
	rrca			; $5958
	ld b,a			; $5959
	ld e,Interaction.direction		; $595a
	ld a,(de)		; $595c
	add b			; $595d
	ld hl,@directions		; $595e
	rst_addDoubleIndex			; $5961
	ldi a,(hl)		; $5962
	ld c,a			; $5963
	ld b,(hl)		; $5964
	jp updateLinkPositionGivenVelocity		; $5965

@directions:
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_100
	.db ANGLE_LEFT,  SPEED_060
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_060
	.db ANGLE_LEFT,  SPEED_100


; ==============================================================================
; INTERACID_DISAPPEARING_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea3:
	ld e,Interaction.state		; $5978
	ld a,(de)		; $597a
	cp $03			; $597b
	jr z,++			; $597d

	; Only do this if the platform isn't invisible
	call _sidescrollPlatform_checkLinkOnPlatform		; $597f
	call _sidescrollingPlatformCommon		; $5982
++
	ld e,Interaction.state		; $5985
	ld a,(de)		; $5987
	rst_jumpTable			; $5988
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid		; $5993
	ld a,(de)		; $5995
	ld hl,@subidData		; $5996
	rst_addDoubleIndex			; $5999

	ld e,Interaction.state		; $599a
	ldi a,(hl)		; $599c
	ld (de),a		; $599d
	ld e,Interaction.counter1		; $599e
	ld a,(hl)		; $59a0
	ld (de),a		; $59a1

	ld e,Interaction.collisionRadiusY		; $59a2
	ld a,$08		; $59a4
	ld (de),a		; $59a6
	inc e			; $59a7
	ld (de),a		; $59a8
	call interactionInitGraphics		; $59a9
	ld e,Interaction.subid		; $59ac
	ld a,(de)		; $59ae
	cp $02			; $59af
	jp z,objectSetVisible83		; $59b1
	ret			; $59b4

@subidData:
	.db $04,  60
	.db $03, 120
	.db $01,  60

@state1:
	call _sidescrollPlatform_decCounter1		; $59bb
	ret nz			; $59be
	ld (hl),30		; $59bf
	ld l,e			; $59c1
	inc (hl)		; $59c2
	xor a			; $59c3
	ret			; $59c4

@state2:
	call _sidescrollPlatform_decCounter1		; $59c5
	jr nz,@flickerVisibility		; $59c8
	ld (hl),150		; $59ca
	ld l,e			; $59cc
	inc (hl)		; $59cd
	jp objectSetInvisible		; $59ce

@flickerVisibility
	ld e,Interaction.visible		; $59d1
	ld a,(de)		; $59d3
	xor $80			; $59d4
	ld (de),a		; $59d6
	ret			; $59d7

@state3:
	call @state1		; $59d8
	ret nz			; $59db
	ld a,SND_MYSTERY_SEED		; $59dc
	jp playSound		; $59de

@state4:
	call _sidescrollPlatform_decCounter1		; $59e1
	jr nz,@flickerVisibility	; $59e4
	ld (hl),120		; $59e6
	ld l,e			; $59e8
	ld (hl),$01		; $59e9
	jp objectSetVisible83		; $59eb


;;
; Used by:
; * INTERACID_DISAPPEARING_SIDESCROLL_PLATFORM
_sidescrollingPlatformCommon:
	ld a,(w1Link.state)		; $5a73
	cp LINK_STATE_NORMAL			; $5a76
	ret nz			; $5a78
	call objectCheckCollidedWithLink		; $5a79
	ret nc			; $5a7c

	; Platform has collided with Link.

	call _sidescrollPlatform_checkLinkIsClose		; $5a7d
	jr c,@label_0b_183	; $5a80
	call _sidescrollPlatform_getTileCollisionBehindLink		; $5a82
	jp z,_sidescrollPlatform_pushLinkAwayHorizontal		; $5a85

	call _sidescrollPlatform_checkLinkSquished		; $5a88
	ret c			; $5a8b

	ld e,Interaction.yh		; $5a8c
	ld a,(de)		; $5a8e
	ld b,a			; $5a8f
	ld a,(w1Link.yh)		; $5a90
	cp b			; $5a93
	ld c,ANGLE_UP		; $5a94
	jr nc,@moveLinkAtAngle	; $5a96
	ld c,ANGLE_DOWN		; $5a98
	jr @moveLinkAtAngle		; $5a9a

@label_0b_183:
	call _sidescrollPlatformFunc_5b51		; $5a9c
	ld a,(hl)		; $5a9f
	or a			; $5aa0
	jp z,_sidescrollPlatform_pushLinkAwayVertical		; $5aa1

	call _sidescrollPlatform_checkLinkSquished		; $5aa4
	ret c			; $5aa7
	ld a,(wLinkRidingObject)		; $5aa8
	cp d			; $5aab
	jr nz,@label_0b_184	; $5aac
	ldh a,(<hFF8B)	; $5aae
	cp $03			; $5ab0
	jr z,@label_0b_184	; $5ab2

	push af			; $5ab4
	call _sidescrollPlatform_pushLinkAwayVertical		; $5ab5
	pop af			; $5ab8
	rrca			; $5ab9
	jr ++			; $5aba

@label_0b_184:
	ld e,Interaction.xh		; $5abc
	ld a,(de)		; $5abe
	ld b,a			; $5abf
	ld a,(w1Link.xh)		; $5ac0
	cp b			; $5ac3
++
	ld c,ANGLE_RIGHT		; $5ac4
	jr nc,@moveLinkAtAngle	; $5ac6
	ld c,ANGLE_LEFT		; $5ac8

;;
; @param	c	Angle
; @addr{5aca}
@moveLinkAtAngle:
	ld b,SPEED_80		; $5aca
	jp updateLinkPositionGivenVelocity		; $5acc

;;
; @param[out]	cflag	c if Link got squished
; @addr{5acf}
_sidescrollPlatform_checkLinkSquished:
	ld h,d			; $5acf
	ld l,Interaction.collisionRadiusY		; $5ad0
	ld a,(hl)		; $5ad2
	ld b,a			; $5ad3
	add a			; $5ad4
	inc a			; $5ad5
	ld c,a			; $5ad6
	ld l,Interaction.yh		; $5ad7
	ld a,(w1Link.yh)		; $5ad9
	sub (hl)		; $5adc
	add b			; $5add
	cp c			; $5ade
	ret nc			; $5adf

	ld l,Interaction.collisionRadiusX		; $5ae0
	ld a,(hl)		; $5ae2
	add $02			; $5ae3
	ld b,a			; $5ae5
	add a			; $5ae6
	inc a			; $5ae7
	ld c,a			; $5ae8
	ld l,Interaction.xh		; $5ae9
	ld a,(w1Link.xh)		; $5aeb
	sub (hl)		; $5aee
	add b			; $5aef
	cp c			; $5af0
	ret nc			; $5af1

	xor a			; $5af2
	ld l,Interaction.angle		; $5af3
	bit 3,(hl)		; $5af5
	jr nz,+			; $5af7
	inc a			; $5af9
+
	ld (wcc50),a		; $5afa
	ld a,LINK_STATE_SQUISHED		; $5afd
	ld (wLinkForceState),a		; $5aff
	scf			; $5b02
	ret			; $5b03

;;
; @param[out]	cflag	c if Link's close enough to the platform?
; @addr{5b04}
_sidescrollPlatform_checkLinkIsClose:
	ld a,(wLinkInAir)		; $5b04
	or a			; $5b07
	ld b,$05		; $5b08
	jr z,+			; $5b0a
	dec b			; $5b0c
+
	ld h,d			; $5b0d
	ld l,Interaction.collisionRadiusX		; $5b0e
	ld a,(hl)		; $5b10
	add b			; $5b11

	ld b,a			; $5b12
	add a			; $5b13
	inc a			; $5b14
	ld c,a			; $5b15
	ld l,Interaction.xh		; $5b16
	ld a,(w1Link.xh)		; $5b18
	sub (hl)		; $5b1b
	add b			; $5b1c
	cp c			; $5b1d
	ret nc			; $5b1e

	ld l,Interaction.collisionRadiusY		; $5b1f
	ld a,(hl)		; $5b21
	sub $02			; $5b22
	ld b,a			; $5b24
	add a			; $5b25
	inc a			; $5b26
	ld c,a			; $5b27
	ld l,Interaction.yh		; $5b28
	ld a,(w1Link.yh)		; $5b2a
	sub (hl)		; $5b2d
	add b			; $5b2e
	cp c			; $5b2f
	ccf			; $5b30
	ret			; $5b31

;;
; @param[out]	a	Collision value
; @param[out]	zflag	nz if a valid collision value is returned
; @addr{5b32}
_sidescrollPlatform_getTileCollisionBehindLink:
	ld l,Interaction.xh		; $5b32
	ld a,(w1Link.xh)		; $5b34
	cp (hl)			; $5b37
	ld b,-$05		; $5b38
	jr c,+			; $5b3a
	ld b,$04		; $5b3c
+
	add b			; $5b3e
	ld c,a			; $5b3f
	ld a,(w1Link.yh)		; $5b40
	sub $04			; $5b43
	ld b,a			; $5b45
	call getTileCollisionsAtPosition		; $5b46
	ret nz			; $5b49
	ld a,b			; $5b4a
	add $08			; $5b4b
	ld b,a			; $5b4d
	jp getTileCollisionsAtPosition		; $5b4e

;;
; @param[out]	hl
; @addr{5b51}
_sidescrollPlatformFunc_5b51:
	ld h,d			; $5b51
	ld l,Interaction.yh		; $5b52
	ld a,(w1Link.yh)		; $5b54
	cp (hl)			; $5b57
	ld b,-$06		; $5b58
	jr c,+			; $5b5a
	ld b,$09		; $5b5c
+
	add b			; $5b5e
	ld b,a			; $5b5f
	ld a,(w1Link.xh)		; $5b60
	sub $03			; $5b63
	ld c,a			; $5b65
	call getTileCollisionsAtPosition		; $5b66
	ld hl,hFF8B		; $5b69
	ld (hl),$00		; $5b6c
	jr z,+			; $5b6e
	set 1,(hl)		; $5b70
+
	ld a,c			; $5b72
	add $05			; $5b73
	ld c,a			; $5b75
	call getTileCollisionsAtPosition		; $5b76
	ld hl,hFF8B		; $5b79
	ret z			; $5b7c
	inc (hl)		; $5b7d
	ret			; $5b7e

;;
; Checks if Link's on the platform, updates wLinkRidingObject if so.
;
; @param[out]	zflag	nz if Link is standing on the platform
; @addr{5b7f}
_sidescrollPlatform_checkLinkOnPlatform:
	call objectCheckCollidedWithLink		; $5b7f
	jr nc,@notOnPlatform	; $5b82

	ld h,d			; $5b84
	ld l,Interaction.yh		; $5b85
	ld a,(hl)		; $5b87
	ld l,Interaction.collisionRadiusY		; $5b88
	sub (hl)		; $5b8a
	sub $02			; $5b8b
	ld b,a			; $5b8d
	ld a,(w1Link.yh)		; $5b8e
	cp b			; $5b91
	jr nc,@notOnPlatform	; $5b92

	call _sidescrollPlatform_checkLinkIsClose		; $5b94
	jr nc,@notOnPlatform	; $5b97

	ld e,Interaction.var34		; $5b99
	ld a,(de)		; $5b9b
	or a			; $5b9c
	jr nz,@onPlatform		; $5b9d
	ld a,$01		; $5b9f
	ld (de),a		; $5ba1
	call _sidescrollPlatform_updateLinkSubpixels		; $5ba2

@onPlatform:
	ld a,d			; $5ba5
	ld (wLinkRidingObject),a		; $5ba6
	xor a			; $5ba9
	ret			; $5baa

@notOnPlatform:
	ld e,Interaction.var34		; $5bab
	ld a,(de)		; $5bad
	or a			; $5bae
	ret z			; $5baf
	ld a,$00		; $5bb0
	ld (de),a		; $5bb2
	ret			; $5bb3

;;
; @addr{5bb4}
_sidescrollPlatform_updateLinkKnockbackForConveyor:
	ld e,Interaction.angle		; $5bb4
	ld a,(de)		; $5bb6
	bit 3,a			; $5bb7
	ret z			; $5bb9

	ld hl,w1Link.knockbackAngle		; $5bba
	ld e,Interaction.direction		; $5bbd
	ld a,(de)		; $5bbf
	swap a			; $5bc0
	add $08			; $5bc2
	ld (hl),a		; $5bc4
	ld l,<w1Link.invincibilityCounter		; $5bc5
	ld (hl),$fc		; $5bc7
	ld l,<w1Link.knockbackCounter		; $5bc9
	ld (hl),$0c		; $5bcb
	ret			; $5bcd

;;
; @param[out]	hl	counter1
; @addr{5bce}
_sidescrollPlatform_decCounter1:
	ld h,d			; $5bce
	ld l,Interaction.counter1		; $5bcf
	ld a,(hl)		; $5bd1
	or a			; $5bd2
	ret z			; $5bd3
	dec (hl)		; $5bd4
	ret			; $5bd5

;;
; @addr{5bd6}
_sidescrollPlatform_pushLinkAwayVertical:
	ld hl,w1Link.collisionRadiusY		; $5bd6
	ld e,Interaction.collisionRadiusY		; $5bd9
	ld a,(de)		; $5bdb
	add (hl)		; $5bdc
	ld b,a			; $5bdd
	ld l,<w1Link.yh		; $5bde
	ld e,Interaction.yh		; $5be0
	jr +++			; $5be2

;;
; @addr{5be4}
_sidescrollPlatform_pushLinkAwayHorizontal:
	ld hl,w1Link.collisionRadiusX		; $5be4
	ld e,Interaction.collisionRadiusX		; $5be7
	ld a,(de)		; $5be9
	add (hl)		; $5bea
	ld b,a			; $5beb
	ld l,<w1Link.xh		; $5bec
	ld e,Interaction.xh		; $5bee
+++
	ld a,(de)		; $5bf0
	cp (hl)			; $5bf1
	jr c,++			; $5bf2
	ld a,b			; $5bf4
	cpl			; $5bf5
	inc a			; $5bf6
	ld b,a			; $5bf7
++
	ld a,(de)		; $5bf8
	add b			; $5bf9
	ld (hl),a		; $5bfa
	ret			; $5bfb

;;
; @addr{5bfc}
_sidescrollPlatformFunc_5bfc:
	call objectRunMovementScript		; $5bfc
	ld a,(wLinkRidingObject)		; $5bff
	cp d			; $5c02
	ret nz			; $5c03

;;
; @addr{5c04}
_sidescrollPlatform_updateLinkSubpixels:
	ld e,Interaction.y		; $5c04
	ld a,(de)		; $5c06
	ld (w1Link.y),a		; $5c07
	ld e,Interaction.x		; $5c0a
	ld a,(de)		; $5c0c
	ld (w1Link.x),a		; $5c0d
	ret			; $5c10


interactionCodea4:
	ld e,$44		; $63ea
	ld a,(de)		; $63ec
	rst_jumpTable			; $63ed
	ld a,($ff00+c)		; $63ee
	ld h,e			; $63ef
	ld (de),a		; $63f0
	ld h,h			; $63f1
	call interactionInitGraphics		; $63f2
	call interactionIncState		; $63f5
	ld l,$49		; $63f8
	ld (hl),$04		; $63fa
	ld a,$3b		; $63fc
	call interactionSetHighTextIndex		; $63fe
	call $6418		; $6401
	ld hl,$758a		; $6404
	call interactionSetScript		; $6407
	call interactionAnimateAsNpc		; $640a
	ld a,$02		; $640d
	call interactionSetAnimation		; $640f
	call interactionRunScript		; $6412
	jp interactionAnimateAsNpc		; $6415
	ld a,$4a		; $6418
	call checkTreasureObtained		; $641a
	jr nc,_label_0a_236	; $641d
	or a			; $641f
	ld a,$01		; $6420
	jr z,_label_0a_239	; $6422
_label_0a_236:
	ld a,$52		; $6424
	call checkTreasureObtained		; $6426
	jr nc,_label_0a_237	; $6429
	ld a,$02		; $642b
	jr _label_0a_239		; $642d
_label_0a_237:
	ld a,$28		; $642f
	call checkGlobalFlag		; $6431
	jr nz,_label_0a_238	; $6434
	ld a,$00		; $6436
	jr _label_0a_239		; $6438
_label_0a_238:
	ld a,$03		; $643a
_label_0a_239:
	ld e,$7f		; $643c
	ld (de),a		; $643e
	ret			; $643f

interactionCodea5:
	ld e,$44		; $6440
	ld a,(de)		; $6442
	rst_jumpTable			; $6443
	ld c,b			; $6444
	ld h,h			; $6445
.DB $d3				; $6446
	ld h,h			; $6447
	ld a,$01		; $6448
	ld (de),a		; $644a
	call interactionInitGraphics		; $644b
	call objectSetVisiblec2		; $644e
	ld e,$42		; $6451
	ld a,(de)		; $6453
	rst_jumpTable			; $6454
	ld l,c			; $6455
	ld h,h			; $6456
	add h			; $6457
	ld h,h			; $6458
	adc (hl)		; $6459
	ld h,h			; $645a
	and e			; $645b
	ld h,h			; $645c
	sub h			; $645d
	ld h,h			; $645e
	and e			; $645f
	ld h,h			; $6460
	sbc d			; $6461
	ld h,h			; $6462
	and h			; $6463
	ld h,h			; $6464
	xor d			; $6465
	ld h,h			; $6466
	push bc			; $6467
	ld h,h			; $6468
	ld h,d			; $6469
	ld l,$4b		; $646a
	ld (hl),$00		; $646c
	inc l			; $646e
	inc l			; $646f
	ld (hl),$a0		; $6470
	ld l,$66		; $6472
	ld (hl),$20		; $6474
	inc l			; $6476
	ld (hl),$08		; $6477
	ld l,$49		; $6479
	ld (hl),$10		; $647b
	ld l,$50		; $647d
	ld (hl),$14		; $647f
	jp setCameraFocusedObject		; $6481
	ld h,d			; $6484
	ld l,$4b		; $6485
	ld (hl),$98		; $6487
	inc l			; $6489
	inc l			; $648a
	ld (hl),$a0		; $648b
	ret			; $648d
	ld hl,$767c		; $648e
	jp interactionSetScript		; $6491
	ld hl,$7680		; $6494
	jp interactionSetScript		; $6497
	ld h,d			; $649a
	ld l,$4b		; $649b
	ld (hl),$48		; $649d
	inc l			; $649f
	inc l			; $64a0
	ld (hl),$80		; $64a1
	ret			; $64a3
	ld hl,$7684		; $64a4
	jp interactionSetScript		; $64a7
	ld a,$28		; $64aa
	call checkGlobalFlag		; $64ac
	jp z,interactionDelete		; $64af
	ld a,$06		; $64b2
	call interactionSetAnimation		; $64b4
	ld a,$a5		; $64b7
	ld ($cc1d),a		; $64b9
	ld ($cc17),a		; $64bc
	ld hl,$7685		; $64bf
	jp interactionSetScript		; $64c2
	call getThisRoomFlags		; $64c5
	bit 6,a			; $64c8
	jp nz,interactionDelete		; $64ca
	ld hl,$769b		; $64cd
	jp interactionSetScript		; $64d0
	ld e,$42		; $64d3
	ld a,(de)		; $64d5
	rst_jumpTable			; $64d6
	.dw $64eb
	.dw $6562
	.dw $65fa
	.dw $6605
	.dw $6638
	.dw $25b8
	.dw $6672
	.dw $6678
	.dw $66dd
	.dw $66ed
	ld e,$45		; $64eb
	ld a,(de)		; $64ed
	rst_jumpTable			; $64ee
	rst $38			; $64ef
	ld h,h			; $64f0
	scf			; $64f1
	ld h,l			; $64f2
	ld h,e			; $64f3
	ld h,l			; $64f4
	add (hl)		; $64f5
	ld h,l			; $64f6
	or l			; $64f7
	ld h,l			; $64f8
	rst_jumpTable			; $64f9
	ld h,l			; $64fa
	sbc $65			; $64fb
	ld a,($ff00+$65)	; $64fd
	call interactionAnimate		; $64ff
	ld a,(wFrameCounter)		; $6502
	and $0f			; $6505
	call z,$6521		; $6507
	call objectApplySpeed		; $650a
	ld e,$4b		; $650d
	ld a,(de)		; $650f
	cp $90			; $6510
	ret nz			; $6512
	call interactionIncState2		; $6513
	xor a			; $6516
	ld ($cca4),a		; $6517
	inc a			; $651a
	ld ($ccab),a		; $651b
	jp setCameraFocusedObjectToLink		; $651e
	call getFreeInteractionSlot		; $6521
	ret nz			; $6524
	ld (hl),$84		; $6525
	inc l			; $6527
	ld (hl),$05		; $6528
	call getRandomNumber		; $652a
	and $1f			; $652d
	sub $10			; $652f
	ld b,$00		; $6531
	ld c,a			; $6533
	jp objectCopyPositionWithOffset		; $6534
	call objectOscillateZ		; $6537
	call objectPreventLinkFromPassing		; $653a
	ld c,$20		; $653d
	call objectCheckLinkWithinDistance		; $653f
	jp nc,interactionAnimate		; $6542
	ld a,($cc77)		; $6545
	or a			; $6548
	ret nz			; $6549
	call interactionIncState2		; $654a
	ld a,$80		; $654d
	ld ($cca4),a		; $654f
	ld l,$46		; $6552
	ld (hl),$32		; $6554
	ld l,$4d		; $6556
	ldd a,(hl)		; $6558
	ld (hl),a		; $6559
	ld hl,$d008		; $655a
	ld (hl),$03		; $655d
	call setLinkForceStateToState08		; $655f
	ret			; $6562
	call interactionDecCounter1		; $6563
	jr nz,_label_0a_240	; $6566
	call interactionIncState2		; $6568
	ld hl,$cbb3		; $656b
	ld (hl),$00		; $656e
	ld hl,$cbba		; $6570
	ld (hl),$ff		; $6573
	ret			; $6575
_label_0a_240:
	call getRandomNumber_noPreserveVars		; $6576
	and $03			; $6579
	sub $02			; $657b
	ld h,d			; $657d
	ld l,$4c		; $657e
	add (hl)		; $6580
	inc l			; $6581
	ld (hl),a		; $6582
	jp interactionAnimate		; $6583
	ld hl,$cbb3		; $6586
	ld b,$01		; $6589
	call flashScreen		; $658b
	ret z			; $658e
	call interactionIncState2		; $658f
	ld l,$46		; $6592
	ld (hl),$1e		; $6594
	ld b,$04		; $6596
_label_0a_241:
	call getFreeInteractionSlot		; $6598
	jr nz,_label_0a_242	; $659b
	ld (hl),$a6		; $659d
	inc l			; $659f
	ld (hl),b		; $65a0
	dec (hl)		; $65a1
	call objectCopyPosition		; $65a2
	dec b			; $65a5
	jr nz,_label_0a_241	; $65a6
_label_0a_242:
	ld a,$05		; $65a8
	call interactionSetAnimation		; $65aa
	ld a,$8a		; $65ad
	call playSound		; $65af
	jp clearPaletteFadeVariablesAndRefreshPalettes		; $65b2
	call interactionDecCounter1		; $65b5
	ret nz			; $65b8
	call interactionIncState2		; $65b9
	ld l,$50		; $65bc
	ld (hl),$28		; $65be
	ld l,$60		; $65c0
	ld (hl),$01		; $65c2
	jp interactionAnimate		; $65c4
	call objectApplySpeed		; $65c7
	ld h,d			; $65ca
	ld l,$4b		; $65cb
	ld a,(hl)		; $65cd
	sub $98			; $65ce
	ret nz			; $65d0
	call interactionIncState2		; $65d1
	ld l,$4f		; $65d4
	ld (hl),a		; $65d6
	ld l,$60		; $65d7
	ld (hl),$01		; $65d9
	jp interactionAnimate		; $65db
	call interactionAnimate		; $65de
	ld e,$61		; $65e1
	ld a,(de)		; $65e3
	or a			; $65e4
	ret z			; $65e5
	call interactionIncState2		; $65e6
	ld l,$46		; $65e9
	ld (hl),$1e		; $65eb
	jp npcFaceLinkAndAnimate		; $65ed
	call interactionDecCounter1		; $65f0
	ret nz			; $65f3
	ld a,$01		; $65f4
	ld ($cfdf),a		; $65f6
	ret			; $65f9
	ld a,($c4ab)		; $65fa
	or a			; $65fd
	ret nz			; $65fe
	call interactionAnimate		; $65ff
	jp interactionRunScript		; $6602
	ld e,$45		; $6605
	ld a,(de)		; $6607
	rst_jumpTable			; $6608
	rrca			; $6609
	ld h,(hl)		; $660a
	ld hl,$2f66		; $660b
	ld h,(hl)		; $660e
	ld a,($cfc0)		; $660f
	or a			; $6612
	jr z,_label_0a_243	; $6613
	call interactionIncState2		; $6615
	ld bc,$ff00		; $6618
	call objectSetSpeedZ		; $661b
_label_0a_243:
	jp interactionAnimate		; $661e
	ld c,$20		; $6621
	call objectUpdateSpeedZ_paramC		; $6623
	ret nz			; $6626
	call interactionIncState2		; $6627
	ld l,$46		; $662a
	ld (hl),$0a		; $662c
	ret			; $662e
	call interactionDecCounter1		; $662f
	ret nz			; $6632
	ld a,$06		; $6633
	jp interactionSetAnimation		; $6635
	ld e,$45		; $6638
	ld a,(de)		; $663a
	rst_jumpTable			; $663b
	ld b,d			; $663c
	ld h,(hl)		; $663d
	ld e,a			; $663e
	ld h,(hl)		; $663f
	ld l,a			; $6640
	ld h,(hl)		; $6641
	ld a,($c4ab)		; $6642
	or a			; $6645
	ret nz			; $6646
	call interactionAnimate		; $6647
	call interactionRunScript		; $664a
	ret nc			; $664d
	ld bc,$ff20		; $664e
	call objectSetSpeedZ		; $6651
	ld l,$49		; $6654
	ld (hl),$08		; $6656
	ld l,$50		; $6658
	ld (hl),$37		; $665a
	jp interactionIncState2		; $665c
	call objectApplySpeed		; $665f
	ld c,$20		; $6662
	call objectUpdateSpeedZ_paramC		; $6664
	ret nz			; $6667
	call interactionIncState2		; $6668
	ld l,$60		; $666b
	ld (hl),$20		; $666d
	jp interactionAnimate		; $666f
	call objectOscillateZ		; $6672
	jp interactionAnimate		; $6675
	ld e,$45		; $6678
	ld a,(de)		; $667a
	rst_jumpTable			; $667b
	add (hl)		; $667c
	ld h,(hl)		; $667d
	sbc (hl)		; $667e
	ld h,(hl)		; $667f
	or d			; $6680
	ld h,(hl)		; $6681
	rst_jumpTable			; $6682
	ld h,(hl)		; $6683
	cp b			; $6684
	dec h			; $6685
	call interactionAnimate		; $6686
	ld a,($cfc0)		; $6689
	cp $04			; $668c
	ret nz			; $668e
	call interactionIncState2		; $668f
	ld l,$46		; $6692
	ld (hl),$78		; $6694
	ld a,$08		; $6696
	call interactionSetAnimation		; $6698
	jp $6717		; $669b
	call interactionDecCounter1		; $669e
	jp nz,seasonsFunc_0a_6710		; $66a1
	call interactionIncState2		; $66a4
	xor a			; $66a7
	ld l,$4f		; $66a8
	ld (hl),a		; $66aa
	ld l,$46		; $66ab
	ld (hl),$1e		; $66ad
	jp interactionAnimate		; $66af
	call interactionDecCounter1		; $66b2
	jr nz,_label_0a_244	; $66b5
	call interactionIncState2		; $66b7
	ld l,$46		; $66ba
	ld (hl),$3c		; $66bc
	ld bc,$3d09		; $66be
	call showText		; $66c1
_label_0a_244:
	jp interactionAnimate		; $66c4
	ld a,($cba0)		; $66c7
	or a			; $66ca
	jr nz,_label_0a_245	; $66cb
	call interactionDecCounter1		; $66cd
	jr nz,_label_0a_245	; $66d0
	call interactionIncState2		; $66d2
	ld hl,$cfc0		; $66d5
	ld (hl),$05		; $66d8
_label_0a_245:
	jp interactionAnimate		; $66da
	call interactionRunScript		; $66dd
	ld e,$78		; $66e0
	ld a,(de)		; $66e2
	or a			; $66e3
	call z,interactionAnimate		; $66e4
	call objectPreventLinkFromPassing		; $66e7
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $66ea
	ld e,$78		; $66ed
	ld a,(de)		; $66ef
	bit 7,a			; $66f0
	jr nz,_label_0a_246	; $66f2
	and $7f			; $66f4
	call nz,interactionAnimate		; $66f6
	call interactionAnimate		; $66f9
_label_0a_246:
	call interactionRunScript		; $66fc
	ret nc			; $66ff
	ld a,$30		; $6700
	call setGlobalFlag		; $6702
	ld hl,$670b		; $6705
	jp setWarpDestVariables		; $6708
	add b			; $670b
	sub a			; $670c
	nop			; $670d
	ld b,h			; $670e
	add e			; $670f

seasonsFunc_0a_6710:
	ld c,$20		; $6710
	call objectUpdateSpeedZ_paramC		; $6712
	ret nz			; $6715
	ld h,d			; $6716
	ld bc,$ff00		; $6717
	jp objectSetSpeedZ		; $671a

interactionCodea6:
	ld e,$44		; $671d
	ld a,(de)		; $671f
	rst_jumpTable			; $6720
	dec h			; $6721
	ld h,a			; $6722
	ld b,d			; $6723
	ld h,a			; $6724
	ld a,$01		; $6725
	ld (de),a		; $6727
	call interactionInitGraphics		; $6728
	ld h,d			; $672b
	ld l,$42		; $672c
	ld a,(hl)		; $672e
	add a			; $672f
	add a			; $6730
	add a			; $6731
	add $04			; $6732
	ld l,$49		; $6734
	ld (hl),a		; $6736
	ld l,$50		; $6737
	ld (hl),$64		; $6739
	ld l,$46		; $673b
	ld (hl),$08		; $673d
	jp objectSetVisible81		; $673f
	ld e,$45		; $6742
	ld a,(de)		; $6744
	or a			; $6745
	jr nz,_label_0a_248	; $6746
	call interactionDecCounter1		; $6748
	jr nz,_label_0a_247	; $674b
	call interactionIncState2		; $674d
	ld l,$46		; $6750
	ld (hl),$14		; $6752
_label_0a_247:
	call objectApplySpeed		; $6754
	jp objectApplySpeed		; $6757
_label_0a_248:
	call interactionDecCounter1		; $675a
	jp z,interactionDelete		; $675d
	ld a,(wFrameCounter)		; $6760
	xor d			; $6763
	rrca			; $6764
	ld l,$5a		; $6765
	set 7,(hl)		; $6767
	jr nc,_label_0a_247	; $6769
	res 7,(hl)		; $676b
	jr _label_0a_247		; $676d

interactionCodea7:
	ld e,$44		; $676f
	ld a,(de)		; $6771
	rst_jumpTable			; $6772
	ld (hl),a		; $6773
	ld h,a			; $6774
	or h			; $6775
	ld h,a			; $6776
	ld a,$01		; $6777
	ld (de),a		; $6779
	call interactionInitGraphics		; $677a
	call objectSetVisible82		; $677d
	ld e,$42		; $6780
	ld a,(de)		; $6782
	cp $02			; $6783
	ret nz			; $6785
	ld a,($c6da)		; $6786
	cp $04			; $6789
	ret c			; $678b
	ld a,$04		; $678c
	call interactionSetAnimation		; $678e
	call getFreeInteractionSlot		; $6791
	ret nz			; $6794
	ld (hl),$35		; $6795
	inc l			; $6797
	ld a,($c6da)		; $6798
	ld b,$00		; $679b
	cp $07			; $679d
	jr c,_label_0a_249	; $679f
	ld b,$03		; $67a1
_label_0a_249:
	ld a,($c6de)		; $67a3
	add b			; $67a6
	ldi (hl),a		; $67a7
	add $16			; $67a8
	ld (hl),a		; $67aa
	ld l,$4b		; $67ab
	ld (hl),$38		; $67ad
	inc l			; $67af
	inc l			; $67b0
	ld (hl),$28		; $67b1
	ret			; $67b3
	ld e,$45		; $67b4
	ld a,(de)		; $67b6
	rst_jumpTable			; $67b7
	cp (hl)			; $67b8
	ld h,a			; $67b9
	ret nc			; $67ba
	ld h,a			; $67bb
	sbc $67			; $67bc
	ld a,($cfc0)		; $67be
	or a			; $67c1
	jr z,_label_0a_250	; $67c2
	call interactionIncState2		; $67c4
	ld bc,$ff00		; $67c7
	call objectSetSpeedZ		; $67ca
_label_0a_250:
	jp interactionAnimate		; $67cd
	ld c,$20		; $67d0
	call objectUpdateSpeedZ_paramC		; $67d2
	ret nz			; $67d5
	call interactionIncState2		; $67d6
	ld l,$46		; $67d9
	ld (hl),$0a		; $67db
	ret			; $67dd
	call interactionDecCounter1		; $67de
	ret nz			; $67e1
	ld a,$03		; $67e2
	jp interactionSetAnimation		; $67e4

interactionCodea8:
	ld e,$42		; $67e7
	ld a,(de)		; $67e9
	and $0f			; $67ea
	rst_jumpTable			; $67ec
	rst $30			; $67ed
	ld h,a			; $67ee
	rst $30			; $67ef
	ld h,a			; $67f0
	rst $30			; $67f1
	ld h,a			; $67f2
	rst $30			; $67f3
	ld h,a			; $67f4
	ld de,$1a68		; $67f5
	and $0f			; $67f8
	add $0f			; $67fa
	ld b,a			; $67fc
	ld a,(de)		; $67fd
	swap a			; $67fe
	and $0f			; $6800
	ld hl,$d100		; $6802
	ld (hl),$01		; $6805
	inc l			; $6807
	ld (hl),b		; $6808
	inc l			; $6809
	ld (hl),a		; $680a
	call objectCopyPosition		; $680b
	jp interactionDelete		; $680e
	ld hl,$d000		; $6811
	ld (hl),$03		; $6814
	call objectCopyPosition		; $6816
	call $681f		; $6819
	jp interactionDelete		; $681c
	ld e,$42		; $681f
	ld a,(de)		; $6821
	swap a			; $6822
	and $0f			; $6824
	ld b,a			; $6826
	rst_jumpTable			; $6827
	inc (hl)		; $6828
	ld l,b			; $6829
	ld c,b			; $682a
	ld l,b			; $682b
	ld c,b			; $682c
	ld l,b			; $682d
	ld c,b			; $682e
	ld l,b			; $682f
	ld c,b			; $6830
	ld l,b			; $6831
	ld d,e			; $6832
	ld l,b			; $6833
	ld hl,$6869		; $6834
	ld a,$0a		; $6837
	push de			; $6839
	call setSimulatedInputAddress		; $683a
	pop de			; $683d
	xor a			; $683e
	ld ($cca4),a		; $683f
	ld hl,$d001		; $6842
	ld (hl),$00		; $6845
	ret			; $6847
	ld a,b			; $6848
	add $02			; $6849
_label_0a_251:
	ld hl,$d001		; $684b
	ld (hl),$08		; $684e
	inc l			; $6850
	ld (hl),a		; $6851
	ret			; $6852
	ld a,d			; $6853
	ld ($cc48),a		; $6854
	ld hl,$c6c5		; $6857
	ld (hl),$3d		; $685a
	xor a			; $685c
	ld l,$80		; $685d
	ldi (hl),a		; $685f
	ld (hl),a		; $6860
	ld hl,$6874		; $6861
	ld a,$0a		; $6864
	jp $6839		; $6866
	inc a			; $6869
	nop			; $686a
	nop			; $686b
	jr nz,_label_0a_252	; $686c
_label_0a_252:
	add b			; $686e
	jr nc,_label_0a_253	; $686f
_label_0a_253:
	nop			; $6871
	rst $38			; $6872
	rst $38			; $6873
	ld a,h			; $6874
	nop			; $6875
	nop			; $6876
	ld bc,$2000		; $6877
	ld l,$00		; $687a
	nop			; $687c
	ld bc,$8000		; $687d
	ld l,$00		; $6880
	nop			; $6882
	ld bc,$1000		; $6883
	ld l,$00		; $6886
	nop			; $6888
	ld bc,$4000		; $6889
	ld l,$00		; $688c
	nop			; $688e
	ld bc,$2000		; $688f
	ld l,$00		; $6892
	nop			; $6894
	ld bc,$8000		; $6895
	ld l,b			; $6898
	nop			; $6899
	nop			; $689a
	ld bc,$4000		; $689b
	jr c,_label_0a_254	; $689e
_label_0a_254:
	nop			; $68a0
	ld bc,$1000		; $68a1
	ret nc			; $68a4
	ld bc,$0100		; $68a5
	nop			; $68a8
	jr nz,_label_0a_251	; $68a9
	nop			; $68ab
	nop			; $68ac
	ld bc,$0100		; $68ad
	jr nc,_label_0a_255	; $68b0
_label_0a_255:
	nop			; $68b2
	rst $38			; $68b3
	rst $38			; $68b4

interactionCodea9:
	ld e,$44		; $68b5
	ld a,(de)		; $68b7
	rst_jumpTable			; $68b8
	cp l			; $68b9
	ld l,b			; $68ba
	bit 5,b			; $68bb
	ld a,$01		; $68bd
	ld (de),a		; $68bf
	ld e,$50		; $68c0
	ld a,$1e		; $68c2
	ld (de),a		; $68c4
	call interactionInitGraphics		; $68c5
	jp objectSetVisiblec0		; $68c8
	call interactionAnimate		; $68cb
	ld e,$42		; $68ce
	ld a,(de)		; $68d0
	cp $02			; $68d1
	ret z			; $68d3
	ld e,$45		; $68d4
	ld a,(de)		; $68d6
	rst_jumpTable			; $68d7
.DB $e4				; $68d8
	ld l,b			; $68d9
.DB $f4				; $68da
	ld l,b			; $68db
	ld (bc),a		; $68dc
	ld l,c			; $68dd
	rrca			; $68de
	ld l,c			; $68df
	dec e			; $68e0
	ld l,c			; $68e1
	ldd (hl),a		; $68e2
	ld l,c			; $68e3
	ld a,($cfc0)		; $68e4
	or a			; $68e7
	ret z			; $68e8
	call interactionIncState2		; $68e9
	ld l,$42		; $68ec
	ld a,(hl)		; $68ee
	add a			; $68ef
	inc a			; $68f0
	jp interactionSetAnimation		; $68f1
	ld a,($cfc0)		; $68f4
	cp $02			; $68f7
	ret nz			; $68f9
	call interactionIncState2		; $68fa
	ld l,$46		; $68fd
	ld (hl),$0a		; $68ff
	ret			; $6901
	call interactionDecCounter1		; $6902
	ret nz			; $6905
	call interactionIncState2		; $6906
	ld bc,$ff00		; $6909
	jp objectSetSpeedZ		; $690c
	ld c,$20		; $690f
	call objectUpdateSpeedZ_paramC		; $6911
	ret nz			; $6914
	call interactionIncState2		; $6915
	ld l,$46		; $6918
	ld (hl),$50		; $691a
	ret			; $691c
	call interactionDecCounter1		; $691d
	ret nz			; $6920
	call interactionIncState2		; $6921
	ld l,$42		; $6924
	ld a,(hl)		; $6926
	cp $01			; $6927
	ld a,$04		; $6929
	jr z,_label_0a_256	; $692b
	xor a			; $692d
_label_0a_256:
	ld l,$49		; $692e
	ld (hl),a		; $6930
	ret			; $6931
	ld e,$42		; $6932
	ld a,(de)		; $6934
	cp $01			; $6935
	jr z,_label_0a_257	; $6937
	cp $04			; $6939
	jr z,_label_0a_257	; $693b
	cp $05			; $693d
	ret nz			; $693f
_label_0a_257:
	jp objectApplySpeed		; $6940

interactionCodeaa:
	ld e,$44		; $6943
	ld a,(de)		; $6945
	rst_jumpTable			; $6946
	ld c,e			; $6947
	ld l,c			; $6948
	ld h,c			; $6949
	ld l,c			; $694a
	ld a,$01		; $694b
	ld (de),a		; $694d
	call interactionInitGraphics		; $694e
	ld e,$42		; $6951
	ld a,(de)		; $6953
	ld hl,$6967		; $6954
	rst_addDoubleIndex			; $6957
	ldi a,(hl)		; $6958
	ld h,(hl)		; $6959
	ld l,a			; $695a
	call interactionSetScript		; $695b
	jp objectSetVisible82		; $695e
	call interactionAnimate		; $6961
	jp interactionRunScript		; $6964
	.db $9f $76 $ad $76 $b7 $76 $dc $76

interactionCodeab:
	ld e,$44		; $696f
	ld a,(de)		; $6971
	rst_jumpTable			; $6972
	ld (hl),a		; $6973
	ld l,c			; $6974
	call $3e69		; $6975
	ld bc,$3e12		; $6978
	ccf			; $697b
	call interactionSetHighTextIndex		; $697c
	ld e,$42		; $697f
	ld a,(de)		; $6981
	ld hl,$6a33		; $6982
	rst_addDoubleIndex			; $6985
	ldi a,(hl)		; $6986
	ld h,(hl)		; $6987
	ld l,a			; $6988
	call interactionSetScript		; $6989
	ld e,$42		; $698c
	ld a,(de)		; $698e
	rst_jumpTable			; $698f
	sub (hl)		; $6990
	ld l,c			; $6991
	or a			; $6992
	ld l,c			; $6993
	cp d			; $6994
	ld l,c			; $6995
	ld a,$16		; $6996
	call checkGlobalFlag		; $6998
	jp nz,interactionDelete		; $699b
	ld a,($cc48)		; $699e
	cp $d0			; $69a1
	jr z,_label_0a_258	; $69a3
	ld a,($d10d)		; $69a5
	jr _label_0a_259		; $69a8
_label_0a_258:
	ld a,($d00d)		; $69aa
_label_0a_259:
	cp $3d			; $69ad
	jp c,interactionDelete		; $69af
	ld a,$00		; $69b2
	call $69e7		; $69b4
	jp $69cd		; $69b7
	ld a,$16		; $69ba
	call checkGlobalFlag		; $69bc
	jp z,interactionDelete		; $69bf
	call getThisRoomFlags		; $69c2
	bit 6,(hl)		; $69c5
	jp nz,interactionDelete		; $69c7
	call setDeathRespawnPoint		; $69ca
	call interactionRunScript		; $69cd
	jp c,interactionDelete		; $69d0
	ret			; $69d3

seasonsFunc_0a_69d4:
	ld a,LINK_STATE_08		; $69d4
	ld (wLinkForceState),a		; $69d6
	ld hl,w1Link.direction		; $69d9
	ld (hl),DIR_DOWN		; $69dc
	ld l,<w1Link.yh		; $69de
	ld (hl),$18		; $69e0
	ld l,<w1Link.xh		; $69e2
	ld (hl),$48		; $69e4
	ret			; $69e6

seasonsFunc_0a_69e7:
	add a			; $69e7
	ld bc,seasonsTable_0a_6a02		; $69e8
	call addDoubleIndexToBc		; $69eb
	call getFreeInteractionSlot		; $69ee
	ret nz			; $69f1
	ld (hl),$95		; $69f2
	inc l			; $69f4
	ld a,(bc)		; $69f5
	ld (hl),a		; $69f6
	inc bc			; $69f7
	ld l,$4b		; $69f8
	ld a,(bc)		; $69fa
	ld (hl),a		; $69fb
	inc bc			; $69fc
	ld l,$4d		; $69fd
	ld a,(bc)		; $69ff
	ld (hl),a		; $6a00
	ret			; $6a01

seasonsTable_0a_6a02:
        .db $03 $60 $24 $00
        .db $04 $50 $48 $00

seasonsFunc_0a_6a0a:
	ld bc,$6a2b		; $6a0a
	ld e,$02		; $6a0d
_label_0a_260:
	call getFreeInteractionSlot		; $6a0f
	ret nz			; $6a12
	ld (hl),$96		; $6a13
	inc l			; $6a15
	ld (hl),$04		; $6a16
	inc l			; $6a18
	ld a,(bc)		; $6a19
	ld (hl),a		; $6a1a
	inc bc			; $6a1b
	ld l,$4b		; $6a1c
	ld a,(bc)		; $6a1e
	ld (hl),a		; $6a1f
	inc bc			; $6a20
	ld l,$4d		; $6a21
	ld a,(bc)		; $6a23
	ld (hl),a		; $6a24
	inc bc			; $6a25
	inc bc			; $6a26
	dec e			; $6a27
	jr nz,_label_0a_260	; $6a28
	ret			; $6a2a

	nop			; $6a2b
	ld d,(hl)		; $6a2c
	jr z,_label_0a_261	; $6a2d
_label_0a_261:
	ld bc,$6856		; $6a2f
	nop			; $6a32
	dec b			; $6a33
	ld (hl),a		; $6a34
	inc sp			; $6a35
	ld (hl),a		; $6a36
	sub b			; $6a37
	ld (hl),a		; $6a38

interactionCodead:
	ld e,$44		; $6a39
	ld a,(de)		; $6a3b
	rst_jumpTable			; $6a3c
	ld b,c			; $6a3d
	ld l,d			; $6a3e
	ld l,h			; $6a3f
	ld l,d			; $6a40
	ld a,$01		; $6a41
	ld (de),a		; $6a43
	call interactionInitGraphics		; $6a44
	call objectGetAngleTowardLink		; $6a47
	ld e,$49		; $6a4a
	ld (de),a		; $6a4c
	ld hl,$779e		; $6a4d
	call interactionSetScript		; $6a50
	ld e,$42		; $6a53
	ld a,(de)		; $6a55
	ld hl,$6a67		; $6a56
	rst_addAToHl			; $6a59
	ld a,(hl)		; $6a5a
	ld e,$76		; $6a5b
	ld (de),a		; $6a5d
	ld bc,$ff40		; $6a5e
	call objectSetSpeedZ		; $6a61
	jp objectSetVisible82		; $6a64
	stop			; $6a67
	jr nz,$18		; $6a68
	jr z,_label_0a_262	; $6a6a
	ld e,$42		; $6a6c
	ld a,(de)		; $6a6e
	and $01			; $6a6f
	call nz,$6ae7		; $6a71
_label_0a_262:
	call interactionAnimateAsNpc		; $6a74
	ld e,$45		; $6a77
	ld a,(de)		; $6a79
	rst_jumpTable			; $6a7a
	add l			; $6a7b
	ld l,d			; $6a7c
	sub d			; $6a7d
	ld l,d			; $6a7e
	xor h			; $6a7f
	ld l,d			; $6a80
	call $d86a		; $6a81
	ld l,d			; $6a84
	ld a,($c4ab)		; $6a85
	or a			; $6a88
	ret nz			; $6a89
	ld h,d			; $6a8a
	ld l,$76		; $6a8b
	dec (hl)		; $6a8d
	ret nz			; $6a8e
	jp interactionIncState2		; $6a8f
	ld a,($cfc0)		; $6a92
	cp $01			; $6a95
	jr nz,_label_0a_263	; $6a97
	call interactionIncState2		; $6a99
	ld bc,$fe80		; $6a9c
	jp objectSetSpeedZ		; $6a9f
_label_0a_263:
	ld e,$46		; $6aa2
	ld a,(de)		; $6aa4
	or a			; $6aa5
	call nz,interactionAnimate		; $6aa6
	jp interactionRunScript		; $6aa9
	ld c,$20		; $6aac
	call objectUpdateSpeedZ_paramC		; $6aae
	ret nz			; $6ab1
	call interactionIncState2		; $6ab2
	ld l,$46		; $6ab5
	ld (hl),$08		; $6ab7
	ld l,$49		; $6ab9
	ld a,(hl)		; $6abb
	add $10			; $6abc
	and $1f			; $6abe
	ld (hl),a		; $6ac0
	ld l,$50		; $6ac1
	ld (hl),$50		; $6ac3
	ld l,$42		; $6ac5
	ld a,(hl)		; $6ac7
	add a			; $6ac8
	inc a			; $6ac9
	jp interactionSetAnimation		; $6aca
	call interactionDecCounter1		; $6acd
	ret nz			; $6ad0
	ld l,$46		; $6ad1
	ld (hl),$40		; $6ad3
	jp interactionIncState2		; $6ad5
	call interactionDecCounter1		; $6ad8
	jp z,interactionDelete		; $6adb
	call objectApplySpeed		; $6ade
	call interactionAnimate		; $6ae1
	jp interactionAnimateAsNpc		; $6ae4
	ld c,$20		; $6ae7
	call objectUpdateSpeedZ_paramC		; $6ae9
	ret nz			; $6aec
	ld bc,$ff40		; $6aed
	jp objectSetSpeedZ		; $6af0

interactionCodeae:
	ld e,$44		; $6af3
	ld a,(de)		; $6af5
	rst_jumpTable			; $6af6
	ei			; $6af7
	ld l,d			; $6af8
	ld c,d			; $6af9
	ld l,e			; $6afa
	ld a,$01		; $6afb
	ld (de),a		; $6afd
	ld e,$43		; $6afe
	ld a,(de)		; $6b00
	or a			; $6b01
	jr nz,_label_0a_264	; $6b02
	ld h,d			; $6b04
	ld l,$42		; $6b05
	ld a,(hl)		; $6b07
	ld hl,$6cd7		; $6b08
	rst_addDoubleIndex			; $6b0b
	ldi a,(hl)		; $6b0c
	ld h,(hl)		; $6b0d
	ld l,a			; $6b0e
	call $6c6f		; $6b0f
	ld e,$42		; $6b12
	ld a,(de)		; $6b14
	ld hl,$6cc7		; $6b15
	rst_addDoubleIndex			; $6b18
	ldi a,(hl)		; $6b19
	ld e,$72		; $6b1a
	ld (de),a		; $6b1c
	ldi a,(hl)		; $6b1d
	ld e,$47		; $6b1e
	ld (de),a		; $6b20
	ret			; $6b21
_label_0a_264:
	call interactionInitGraphics		; $6b22
	ld h,d			; $6b25
	ld l,$70		; $6b26
	ld (hl),$14		; $6b28
	ld l,$50		; $6b2a
	ld (hl),$50		; $6b2c
	ld l,$47		; $6b2e
	ld a,(hl)		; $6b30
	call interactionSetAnimation		; $6b31
	ld h,d			; $6b34
	ld l,$42		; $6b35
	ld a,(hl)		; $6b37
	or a			; $6b38
	ld bc,$f018		; $6b39
	jr z,_label_0a_265	; $6b3c
	ld bc,$0008		; $6b3e
_label_0a_265:
	ld l,$4d		; $6b41
	ld (hl),b		; $6b43
	ld l,$49		; $6b44
	ld (hl),c		; $6b46
	jp objectSetVisible82		; $6b47
	ld a,$01		; $6b4a
	ld (de),a		; $6b4c
	ld e,$43		; $6b4d
	ld a,(de)		; $6b4f
	or a			; $6b50
	jp nz,seasonsFunc_0a_6c91		; $6b51
	ld a,($c4ab)		; $6b54
	or a			; $6b57
	ret nz			; $6b58
	ld e,$45		; $6b59
	ld a,(de)		; $6b5b
	rst_jumpTable			; $6b5c
	ld h,e			; $6b5d
	ld l,e			; $6b5e
	add d			; $6b5f
	ld l,e			; $6b60
	ld b,c			; $6b61
	ld l,h			; $6b62
	ld h,d			; $6b63
	ld l,$70		; $6b64
	call decHlRef16WithCap		; $6b66
	ret nz			; $6b69
	call $6c4d		; $6b6a
	ld e,$70		; $6b6d
	ld a,(de)		; $6b6f
	rlca			; $6b70
	ret nc			; $6b71
	ld b,$01		; $6b72
	rlca			; $6b74
	jr nc,_label_0a_266	; $6b75
	ld b,$02		; $6b77
_label_0a_266:
	ld h,d			; $6b79
	ld l,$46		; $6b7a
	ld (hl),$b4		; $6b7c
	ld l,$45		; $6b7e
	ld (hl),b		; $6b80
	ret			; $6b81
	ld e,$73		; $6b82
	ld a,(de)		; $6b84
	rst_jumpTable			; $6b85
	adc (hl)		; $6b86
	ld l,e			; $6b87
	sub a			; $6b88
	ld l,e			; $6b89
	push hl			; $6b8a
	ld l,e			; $6b8b
	pop af			; $6b8c
	ld l,e			; $6b8d
	call interactionDecCounter1		; $6b8e
	ret nz			; $6b91
	ld h,d			; $6b92
	ld l,$73		; $6b93
	inc (hl)		; $6b95
	ret			; $6b96
	ld a,(wFrameCounter)		; $6b97
	and $03			; $6b9a
	ret nz			; $6b9c
	ld h,d			; $6b9d
	ld l,$46		; $6b9e
	ld a,(hl)		; $6ba0
	cp $10			; $6ba1
	jr nz,_label_0a_267	; $6ba3
	ld l,$73		; $6ba5
	inc (hl)		; $6ba7
	ld l,$58		; $6ba8
	ld a,(hl)		; $6baa
	sub $03			; $6bab
	ldi (hl),a		; $6bad
	ld a,(hl)		; $6bae
	sbc $00			; $6baf
	ld (hl),a		; $6bb1
	call $6c6a		; $6bb2
	ld h,d			; $6bb5
	ld l,$46		; $6bb6
	ld (hl),$1e		; $6bb8
	ret			; $6bba
_label_0a_267:
	ld a,($ff00+$70)	; $6bbb
	push af			; $6bbd
	ld l,$46		; $6bbe
	ld a,(hl)		; $6bc0
	ld b,a			; $6bc1
	ld a,$04		; $6bc2
	ld ($ff00+$70),a	; $6bc4
	ld a,b			; $6bc6
	ld hl,$d000		; $6bc7
	rst_addDoubleIndex			; $6bca
	ld b,$30		; $6bcb
_label_0a_268:
	xor a			; $6bcd
	ldi (hl),a		; $6bce
	ld (hl),a		; $6bcf
	ld a,$1f		; $6bd0
	rst_addAToHl			; $6bd2
	dec b			; $6bd3
	jr nz,_label_0a_268	; $6bd4
	push de			; $6bd6
	ld a,UNCMP_GFXH_09		; $6bd7
	call loadUncompressedGfxHeader		; $6bd9
	pop de			; $6bdc
	pop af			; $6bdd
	ld ($ff00+$70),a	; $6bde
	ld h,d			; $6be0
	ld l,$46		; $6be1
	inc (hl)		; $6be3
	ret			; $6be4
	call interactionDecCounter1		; $6be5
	ret nz			; $6be8
	ld l,$73		; $6be9
	inc (hl)		; $6beb
	ld l,$46		; $6bec
	ld (hl),$10		; $6bee
	ret			; $6bf0
	ld a,(wFrameCounter)		; $6bf1
	and $03			; $6bf4
	ret nz			; $6bf6
	call interactionDecCounter1		; $6bf7
	jr nz,_label_0a_269	; $6bfa
	xor a			; $6bfc
	ld l,$45		; $6bfd
	ld (hl),a		; $6bff
	ld l,$73		; $6c00
	ld (hl),a		; $6c02
	jp $6b6d		; $6c03
_label_0a_269:
	push de			; $6c06
	ld a,($ff00+$70)	; $6c07
	push af			; $6c09
	ld a,(hl)		; $6c0a
	ld b,a			; $6c0b
	ld a,b			; $6c0c
	ld hl,$d000		; $6c0d
	rst_addDoubleIndex			; $6c10
	ld a,b			; $6c11
	ld de,$d800		; $6c12
	call addDoubleIndexToDe		; $6c15
	ld b,$30		; $6c18
_label_0a_270:
	push bc			; $6c1a
	ld a,$03		; $6c1b
	ld ($ff00+$70),a	; $6c1d
	ld a,(de)		; $6c1f
	ld b,a			; $6c20
	inc de			; $6c21
	ld a,(de)		; $6c22
	ld c,a			; $6c23
	ld a,$04		; $6c24
	ld ($ff00+$70),a	; $6c26
	ld (hl),b		; $6c28
	inc hl			; $6c29
	ld (hl),c		; $6c2a
	ld a,$1f		; $6c2b
	ld c,a			; $6c2d
	rst_addAToHl			; $6c2e
	ld a,c			; $6c2f
	call addAToDe		; $6c30
	pop bc			; $6c33
	dec b			; $6c34
	jr nz,_label_0a_270	; $6c35
	ld a,UNCMP_GFXH_09		; $6c37
	call loadUncompressedGfxHeader		; $6c39
	pop af			; $6c3c
	ld ($ff00+$70),a	; $6c3d
	pop de			; $6c3f
	ret			; $6c40
	call interactionDecCounter1		; $6c41
	ret nz			; $6c44
	ld hl,$cfde		; $6c45
	ld (hl),$01		; $6c48
	jp interactionDelete		; $6c4a
	call getFreeInteractionSlot		; $6c4d
	jr nz,_label_0a_271	; $6c50
	ld (hl),$ae		; $6c52
	inc l			; $6c54
	ld e,$72		; $6c55
	ld a,(de)		; $6c57
	ldi (hl),a		; $6c58
	ld (hl),$01		; $6c59
	ld l,$46		; $6c5b
	ld e,l			; $6c5d
	ld a,(de)		; $6c5e
	inc e			; $6c5f
	ldi (hl),a		; $6c60
	ld a,(de)		; $6c61
	ld (hl),a		; $6c62
	call objectCopyPosition		; $6c63
_label_0a_271:
	ld h,d			; $6c66
	ld l,$47		; $6c67
	inc (hl)		; $6c69
	ld l,$58		; $6c6a
	ldi a,(hl)		; $6c6c
	ld h,(hl)		; $6c6d
	ld l,a			; $6c6e
	ldi a,(hl)		; $6c6f
	ld e,$70		; $6c70
	ld (de),a		; $6c72
	inc e			; $6c73
	ldi a,(hl)		; $6c74
	ld (de),a		; $6c75
	ldi a,(hl)		; $6c76
	ld e,$46		; $6c77
	ld (de),a		; $6c79
	ldi a,(hl)		; $6c7a
	ld e,$4b		; $6c7b
	ld (de),a		; $6c7d
	ld e,$58		; $6c7e
	ld a,l			; $6c80
	ld (de),a		; $6c81
	inc e			; $6c82
	ld a,h			; $6c83
	ld (de),a		; $6c84
	ld e,$71		; $6c85
	ld a,(de)		; $6c87
	or a			; $6c88
	ret nz			; $6c89
	dec e			; $6c8a
	ld a,(de)		; $6c8b
	or a			; $6c8c
	ret nz			; $6c8d
	jp $6c4d		; $6c8e

seasonsFunc_0a_6c91:
	ld a,($c4ab)		; $6c91
	or a			; $6c94
	ret nz			; $6c95
	ld e,$45		; $6c96
	ld a,(de)		; $6c98
	rst_jumpTable			; $6c99
	sbc (hl)		; $6c9a
	ld l,h			; $6c9b
	cp e			; $6c9c
	ld l,h			; $6c9d
	ld h,d			; $6c9e
	ld l,$70		; $6c9f
	dec (hl)		; $6ca1
	jr nz,_label_0a_273	; $6ca2
	call interactionIncState2		; $6ca4
	ld b,$a0		; $6ca7
	ld l,$42		; $6ca9
	ld a,(hl)		; $6cab
	or a			; $6cac
	jr z,_label_0a_272	; $6cad
	ld b,$50		; $6caf
_label_0a_272:
	ld l,$4d		; $6cb1
	ld (hl),b		; $6cb3
	ret			; $6cb4
_label_0a_273:
	call objectApplySpeed		; $6cb5
	jp objectApplySpeed		; $6cb8
	ld e,$46		; $6cbb
	ld a,(de)		; $6cbd
	inc a			; $6cbe
	ret z			; $6cbf
	call interactionDecCounter1		; $6cc0
	jp z,interactionDelete		; $6cc3
	ret			; $6cc6
	nop			; $6cc7
	nop			; $6cc8
	ld bc,$0004		; $6cc9
	dec bc			; $6ccc
	ld bc,$0013		; $6ccd
	nop			; $6cd0
	ld bc,$0004		; $6cd1
	dec bc			; $6cd4
	ld bc,$e713		; $6cd5
	ld l,h			; $6cd8
	ld hl,sp+$6c		; $6cd9
	ld d,$6d		; $6cdb
	jr c,_label_0a_287	; $6cdd
	rst $20			; $6cdf
	ld l,h			; $6ce0
	ld hl,sp+$6c		; $6ce1
	ld d,$6d		; $6ce3
	jr c,_label_0a_289	; $6ce5
	jr nz,_label_0a_274	; $6ce7
_label_0a_274:
	rst $38			; $6ce9
	ld hl,sp+$30		; $6cea
	nop			; $6cec
	ld a,($ff00+$18)	; $6ced
	jr nz,_label_0a_275	; $6cef
_label_0a_275:
	ld a,($ff00+$38)	; $6cf1
	jr nz,_label_0a_276	; $6cf3
_label_0a_276:
	ld a,($ff00+$50)	; $6cf5
	rst $38			; $6cf7
	jr nz,_label_0a_277	; $6cf8
_label_0a_277:
	rst $38			; $6cfa
	ld hl,sp+$20		; $6cfb
	nop			; $6cfd
	ld hl,sp+$18		; $6cfe
	stop			; $6d00
	nop			; $6d01
	add sp,$38		; $6d02
	stop			; $6d04
	nop			; $6d05
	ret c			; $6d06
	ld e,b			; $6d07
	add b			; $6d08
	nop			; $6d09
	nop			; $6d0a
	rst $38			; $6d0b
	stop			; $6d0c
	nop			; $6d0d
	nop			; $6d0e
	rst $38			; $6d0f
	jr z,_label_0a_278	; $6d10
_label_0a_278:
	nop			; $6d12
	rst $38			; $6d13
	ld d,b			; $6d14
	rst $38			; $6d15
	jr nz,_label_0a_279	; $6d16
_label_0a_279:
	cp $f8			; $6d18
	stop			; $6d1a
	nop			; $6d1b
	add sp,$18		; $6d1c
	ld a,(bc)		; $6d1e
	nop			; $6d1f
	ret c			; $6d20
	jr c,_label_0a_280	; $6d21
	nop			; $6d23
	ret z			; $6d24
	ld e,b			; $6d25
	add b			; $6d26
	nop			; $6d27
	nop			; $6d28
	rst $38			; $6d29
	ld hl,sp+$00		; $6d2a
	nop			; $6d2c
_label_0a_280:
	rst $38			; $6d2d
	jr _label_0a_281		; $6d2e
_label_0a_281:
	nop			; $6d30
	rst $38			; $6d31
	jr c,_label_0a_282	; $6d32
_label_0a_282:
	nop			; $6d34
	rst $38			; $6d35
	ld e,b			; $6d36
	rst $38			; $6d37
	jr nz,_label_0a_283	; $6d38
_label_0a_283:
	ld hl,sp-$08		; $6d3a
	jr nz,_label_0a_284	; $6d3c
_label_0a_284:
	ret c			; $6d3e
	jr _label_0a_285		; $6d3f
_label_0a_285:
	nop			; $6d41
	ret c			; $6d42
	jr c,_label_0a_286	; $6d43
_label_0a_286:
	nop			; $6d45
	ret c			; $6d46
	ld e,b			; $6d47
	add b			; $6d48
	nop			; $6d49
	nop			; $6d4a
	rst $38			; $6d4b
_label_0a_287:
	ld hl,sp+$00		; $6d4c
	nop			; $6d4e
	rst $38			; $6d4f
	jr _label_0a_288		; $6d50
_label_0a_288:
	nop			; $6d52
	rst $38			; $6d53
_label_0a_289:
	jr c,_label_0a_290	; $6d54
_label_0a_290:
	nop			; $6d56
	rst $38			; $6d57
	ld e,b			; $6d58
	rst $38			; $6d59

interactionCodeaf:
	ld e,$44		; $6d5a
	ld a,(de)		; $6d5c
	rst_jumpTable			; $6d5d
	ld h,d			; $6d5e
	ld l,l			; $6d5f
	ld (hl),a		; $6d60
	ld l,l			; $6d61
	ld a,$01		; $6d62
	ld (de),a		; $6d64
	ld e,$42		; $6d65
	ld a,(de)		; $6d67
	or a			; $6d68
	jr nz,_label_0a_291	; $6d69
	ld hl,$6dd2		; $6d6b
	jp $6db4		; $6d6e
_label_0a_291:
	ld h,d			; $6d71
	ld l,$50		; $6d72
	ld (hl),$14		; $6d74
	ret			; $6d76
	ld e,$42		; $6d77
	ld a,(de)		; $6d79
	or a			; $6d7a
	jr nz,_label_0a_293	; $6d7b
	ld a,($c4ab)		; $6d7d
	or a			; $6d80
	ret nz			; $6d81
	ld h,d			; $6d82
	ld l,$70		; $6d83
	call decHlRef16WithCap		; $6d85
	ret nz			; $6d88
	call $6d99		; $6d89
	ld e,$70		; $6d8c
	ld a,(de)		; $6d8e
	inc a			; $6d8f
	ret nz			; $6d90
	ld hl,$cfde		; $6d91
	ld (hl),$01		; $6d94
	jp interactionDelete		; $6d96
	call getFreeInteractionSlot		; $6d99
	jr nz,_label_0a_292	; $6d9c
	ld (hl),$af		; $6d9e
	inc l			; $6da0
	ld (hl),$01		; $6da1
	inc l			; $6da3
	ld e,$46		; $6da4
	ld a,(de)		; $6da6
	ld (hl),a		; $6da7
	call objectCopyPosition		; $6da8
_label_0a_292:
	ld h,d			; $6dab
	ld l,$46		; $6dac
	inc (hl)		; $6dae
	ld a,(hl)		; $6daf
	ld hl,$6dd2		; $6db0
	rst_addDoubleIndex			; $6db3
	ldi a,(hl)		; $6db4
	ld e,$70		; $6db5
	ld (de),a		; $6db7
	inc e			; $6db8
	ldi a,(hl)		; $6db9
	ld (de),a		; $6dba
	ret			; $6dbb
_label_0a_293:
	ld a,($c4ab)		; $6dbc
	or a			; $6dbf
	ret nz			; $6dc0
	call objectApplySpeed		; $6dc1
	ld h,d			; $6dc4
	ld l,$4b		; $6dc5
	ldi a,(hl)		; $6dc7
	ld b,a			; $6dc8
	or a			; $6dc9
	jp z,interactionDelete		; $6dca
	inc l			; $6dcd
	ld c,(hl)		; $6dce
	jp interactionFunc_3e6d		; $6dcf
	jr nz,_label_0a_294	; $6dd2
_label_0a_294:
	ld ($ff00+$00),a	; $6dd4
	jr nz,_label_0a_295	; $6dd6
	stop			; $6dd8
_label_0a_295:
	ld bc,$00f0		; $6dd9
	ld h,b			; $6ddc
	ld bc,$00f0		; $6ddd
	jr nz,_label_0a_296	; $6de0
	ld (hl),b		; $6de2
_label_0a_296:
	ld bc,$0170		; $6de3
	ld h,b			; $6de6
	ld bc,$0140		; $6de7
	ld d,b			; $6dea
	ld bc,$0110		; $6deb
	ld h,b			; $6dee
	ld bc,$01a0		; $6def
	rst $38			; $6df2

interactionCodeb0:
	ld e,$44		; $6df3
	ld a,(de)		; $6df5
	rst_jumpTable			; $6df6
.DB $fd				; $6df7
	ld l,l			; $6df8
	cp b			; $6df9
	dec h			; $6dfa
	ld e,a			; $6dfb
	ld l,(hl)		; $6dfc
	ld a,$01		; $6dfd
	ld (de),a		; $6dff
	ld e,$42		; $6e00
	ld a,(de)		; $6e02
	cp $0b			; $6e03
	call nc,interactionIncState		; $6e05
	or a			; $6e08
	jr nz,_label_0a_297	; $6e09
	ld a,$b0		; $6e0b
	ld ($cc1d),a		; $6e0d
	ld ($cc17),a		; $6e10
_label_0a_297:
	call interactionInitGraphics		; $6e13
	call interactionSetAlwaysUpdateBit		; $6e16
	ld l,$42		; $6e19
	ld a,(hl)		; $6e1b
	ld b,a			; $6e1c
	cp $08			; $6e1d
	jr c,_label_0a_298	; $6e1f
	call getThisRoomFlags		; $6e21
	and $80			; $6e24
	jp nz,interactionDelete		; $6e26
	ld a,(de)		; $6e29
	sub $05			; $6e2a
_label_0a_298:
	add a			; $6e2c
	add a			; $6e2d
	add a			; $6e2e
	ld l,$60		; $6e2f
	add (hl)		; $6e31
	ld (hl),a		; $6e32
	ld a,b			; $6e33
	ld hl,$6e43		; $6e34
	rst_addDoubleIndex			; $6e37
	ldi a,(hl)		; $6e38
	ld e,$4b		; $6e39
	ld (de),a		; $6e3b
	inc e			; $6e3c
	inc e			; $6e3d
	ld a,(hl)		; $6e3e
	ld (de),a		; $6e3f
	jp objectSetVisiblec2		; $6e40
	ldd (hl),a		; $6e43
	ld a,b			; $6e44
	ld d,b			; $6e45
	add b			; $6e46
	ld d,b			; $6e47
	ld (hl),b		; $6e48
	ld b,b			; $6e49
	xor b			; $6e4a
	ld b,b			; $6e4b
	ld c,b			; $6e4c
	stop			; $6e4d
	ld a,b			; $6e4e
	ld c,b			; $6e4f
	jr nc,_label_0a_299	; $6e50
	ld (hl),b		; $6e52
	ld d,b			; $6e53
	xor b			; $6e54
	ld d,b			; $6e55
	ld c,b			; $6e56
	jr nz,_label_0a_301	; $6e57
	ld d,b			; $6e59
	xor b			; $6e5a
	ld d,b			; $6e5b
	ld c,b			; $6e5c
	jr nz,$78		; $6e5d
	call interactionAnimate		; $6e5f
	ld a,(wFrameCounter)		; $6e62
	rrca			; $6e65
	jp c,objectSetVisible		; $6e66
	jp objectSetInvisible		; $6e69

interactionCodeb1:
	ld e,$44		; $6e6c
	ld a,(de)		; $6e6e
	rst_jumpTable			; $6e6f
	adc b			; $6e70
	ld l,(hl)		; $6e71
	rst_addDoubleIndex			; $6e72
	ld l,(hl)		; $6e73
.DB $ed				; $6e74
	ld l,(hl)		; $6e75
	ei			; $6e76
	ld l,(hl)		; $6e77
	rlca			; $6e78
	ld l,a			; $6e79
	dec h			; $6e7a
	ld l,a			; $6e7b
	dec sp			; $6e7c
	ld l,a			; $6e7d

interactionCodeb2:
	ld e,$44		; $6e7e
	ld a,(de)		; $6e80
	rst_jumpTable			; $6e81
	cp (hl)			; $6e82
	ld l,(hl)		; $6e83
.DB $ed				; $6e84
	ld l,(hl)		; $6e85
	rst_addDoubleIndex			; $6e86
	ld l,(hl)		; $6e87
	ld a,$01		; $6e88
	ld (de),a		; $6e8a
	call interactionInitGraphics		; $6e8b
	ld h,d			; $6e8e
	ld l,$6b		; $6e8f
	ld (hl),$00		; $6e91
	ld l,$49		; $6e93
	ld (hl),$ff		; $6e95
	ld e,$42		; $6e97
	ld a,(de)		; $6e99
_label_0a_299:
	ld b,a			; $6e9a
	cp $18			; $6e9b
	ld a,$4e		; $6e9d
	jr c,_label_0a_300	; $6e9f
	ld a,$4d		; $6ea1
_label_0a_300:
	call interactionSetHighTextIndex		; $6ea3
	ld a,b			; $6ea6
	ld hl,$6f4b		; $6ea7
	rst_addDoubleIndex			; $6eaa
	ldi a,(hl)		; $6eab
	ld h,(hl)		; $6eac
	ld l,a			; $6ead
	call interactionSetScript		; $6eae
	call objectSetVisiblec2		; $6eb1
	call interactionRunScript		; $6eb4
	call interactionRunScript		; $6eb7
	jp c,interactionDelete		; $6eba
	ret			; $6ebd
	ld a,$01		; $6ebe
	ld (de),a		; $6ec0
	call interactionInitGraphics		; $6ec1
	ld e,$42		; $6ec4
	ld a,(de)		; $6ec6
	ld hl,$6f81		; $6ec7
	rst_addDoubleIndex			; $6eca
	ldi a,(hl)		; $6ecb
	ld h,(hl)		; $6ecc
	ld l,a			; $6ecd
	call interactionSetScript		; $6ece
_label_0a_301:
	call objectSetVisiblec2		; $6ed1
	ld a,$4e		; $6ed4
	call interactionSetHighTextIndex		; $6ed6
	call interactionRunScript		; $6ed9
	jp interactionRunScript		; $6edc
	ld c,$20		; $6edf
	call objectUpdateSpeedZ_paramC		; $6ee1
	call interactionRunScript		; $6ee4
	jp c,interactionDelete		; $6ee7
	jp npcFaceLinkAndAnimate		; $6eea
	ld c,$20		; $6eed
	call objectUpdateSpeedZ_paramC		; $6eef
	call interactionRunScript		; $6ef2
	jp c,interactionDelete		; $6ef5
	jp interactionAnimate		; $6ef8
	ld a,$10		; $6efb
	call setScreenShakeCounter		; $6efd
	call interactionRunScript		; $6f00
	jp c,interactionDelete		; $6f03
	ret			; $6f06
	ld c,$20		; $6f07
	call objectUpdateSpeedZ_paramC		; $6f09
	call interactionAnimate		; $6f0c
	call interactionRunScript		; $6f0f
	jp c,interactionDelete		; $6f12
	ld a,(wFrameCounter)		; $6f15
	and $07			; $6f18
	ret nz			; $6f1a
	ld e,$48		; $6f1b
	ld a,(de)		; $6f1d
	inc a			; $6f1e
	and $03			; $6f1f
	ld (de),a		; $6f21
	jp interactionSetAnimation		; $6f22
	call objectPreventLinkFromPassing		; $6f25
	call interactionAnimate		; $6f28
	call interactionRunScript		; $6f2b
	jp c,interactionDelete		; $6f2e
	ld a,(wFrameCounter)		; $6f31
	rrca			; $6f34
	jp c,objectSetInvisible		; $6f35
	jp objectSetVisible		; $6f38
	ld a,($cfc0)		; $6f3b
	or a			; $6f3e
	jp nz,interactionDelete		; $6f3f
	call interactionRunScript		; $6f42
	jp c,interactionDelete		; $6f45
	jp objectSetInvisible		; $6f48
	ret c			; $6f4b
	ld b,l			; $6f4c
	xor c			; $6f4d
	ld (hl),a		; $6f4e
	call nz,$1177		; $6f4f
	ld a,b			; $6f52
	ld de,$1178		; $6f53
	ld a,b			; $6f56
	ld de,$2278		; $6f57
	ld a,b			; $6f5a
	dec hl			; $6f5b
	ld a,b			; $6f5c
	ld a,$78		; $6f5d
	ld d,(hl)		; $6f5f
	ld a,b			; $6f60
	sub a			; $6f61
	ld a,b			; $6f62
.DB $d3				; $6f63
	ld a,b			; $6f64
	rst $30			; $6f65
	ld a,b			; $6f66
	rst $30			; $6f67
	ld a,b			; $6f68
	ret c			; $6f69
	ld b,l			; $6f6a
	rst $38			; $6f6b
	ld a,b			; $6f6c
	ld b,$79		; $6f6d
	dec c			; $6f6f
	ld a,c			; $6f70
	rrca			; $6f71
	ld a,c			; $6f72
	ld de,$1379		; $6f73
	ld a,c			; $6f76
	dec d			; $6f77
	ld a,c			; $6f78
	ret c			; $6f79
	ld b,l			; $6f7a
	rla			; $6f7b
	ld a,c			; $6f7c
	inc a			; $6f7d
	ld a,c			; $6f7e
	ld c,l			; $6f7f
	ld a,c			; $6f80
	ld d,l			; $6f81
	ld a,c			; $6f82
	ld (hl),h		; $6f83
	ld a,c			; $6f84
	add l			; $6f85
	ld a,c			; $6f86
	and b			; $6f87
	ld a,c			; $6f88

interactionCodeb3:
	ld e,$44		; $6f89
	ld a,(de)		; $6f8b
	rst_jumpTable			; $6f8c
	sub c			; $6f8d
	ld l,a			; $6f8e
	add hl,de		; $6f8f
	ld (hl),b		; $6f90
	ld e,$42		; $6f91
	ld a,(de)		; $6f93
	rst_jumpTable			; $6f94
	sbc a			; $6f95
	ld l,a			; $6f96
	xor a			; $6f97
	ld l,a			; $6f98
	rst_jumpTable			; $6f99
	ld l,a			; $6f9a
	rst_addAToHl			; $6f9b
	ld l,a			; $6f9c
	rst $28			; $6f9d
	ld l,a			; $6f9e
	call checkIsLinkedGame		; $6f9f
	jp nz,interactionDelete		; $6fa2
	ld a,$1c		; $6fa5
	call checkGlobalFlag		; $6fa7
	jp nz,interactionDelete		; $6faa
	jr _label_0a_302		; $6fad
	call checkIsLinkedGame		; $6faf
	jp nz,interactionDelete		; $6fb2
	ld a,$1d		; $6fb5
	call checkGlobalFlag		; $6fb7
	jp nz,interactionDelete		; $6fba
	ld a,$36		; $6fbd
	call checkTreasureObtained		; $6fbf
	jp nc,interactionDelete		; $6fc2
	jr _label_0a_302		; $6fc5
	call checkIsLinkedGame		; $6fc7
	jp z,interactionDelete		; $6fca
	ld a,$1e		; $6fcd
	call checkGlobalFlag		; $6fcf
	jp nz,interactionDelete		; $6fd2
	jr _label_0a_302		; $6fd5
	call checkIsLinkedGame		; $6fd7
	jp z,interactionDelete		; $6fda
	ld a,$1f		; $6fdd
	call checkGlobalFlag		; $6fdf
	jp nz,interactionDelete		; $6fe2
	ld a,$36		; $6fe5
	call checkTreasureObtained		; $6fe7
	jp nc,interactionDelete		; $6fea
	jr _label_0a_302		; $6fed
	call checkIsLinkedGame		; $6fef
	jp z,interactionDelete		; $6ff2
	ld a,$20		; $6ff5
	call checkGlobalFlag		; $6ff7
	jp nz,interactionDelete		; $6ffa
_label_0a_302:
	ld h,d			; $6ffd
	ld l,$44		; $6ffe
	ld (hl),$01		; $7000
	ld hl,$cfc0		; $7002
	ld (hl),$00		; $7005
	ld a,$50		; $7007
	call interactionSetHighTextIndex		; $7009
	ld e,$42		; $700c
	ld a,(de)		; $700e
	ld hl,$7020		; $700f
	rst_addDoubleIndex			; $7012
	ldi a,(hl)		; $7013
	ld h,(hl)		; $7014
	ld l,a			; $7015
	call interactionSetScript		; $7016
	call interactionRunScript		; $7019
	jp c,interactionDelete		; $701c
	ret			; $701f
	or h			; $7020
	ld a,c			; $7021
	ld ($2a79),a		; $7022
	ld a,d			; $7025
	scf			; $7026
	ld a,d			; $7027
	inc a			; $7028
	ld a,d			; $7029

interactionCodeb4:
	ld e,$44		; $702a
	ld a,(de)		; $702c
	rst_jumpTable			; $702d
	ldd (hl),a		; $702e
	ld (hl),b		; $702f
	ret nz			; $7030
	ld (hl),b		; $7031
	ld e,$42		; $7032
	ld a,(de)		; $7034
	rst_jumpTable			; $7035
	ld b,(hl)		; $7036
	ld (hl),b		; $7037
	ld b,(hl)		; $7038
	ld (hl),b		; $7039
	ld d,d			; $703a
	ld (hl),b		; $703b
	ld d,d			; $703c
	ld (hl),b		; $703d
	ld h,d			; $703e
	ld (hl),b		; $703f
	halt			; $7040
	ld (hl),b		; $7041
	add (hl)		; $7042
	ld (hl),b		; $7043
	sub l			; $7044
	ld (hl),b		; $7045
	call $70a4		; $7046
	ld l,$42		; $7049
	ld a,(hl)		; $704b
	call $7266		; $704c
	jp $70c0		; $704f
	call $70a4		; $7052
	ld l,$4f		; $7055
	ld (hl),$fb		; $7057
	ld l,$42		; $7059
	ld a,(hl)		; $705b
	call $7266		; $705c
	jp $70c0		; $705f
	call $70a4		; $7062
	ld l,$4f		; $7065
	ld (hl),$f0		; $7067
	ld a,$04		; $7069
	call $7266		; $706b
	ld a,$04		; $706e
	call interactionSetAnimation		; $7070
	jp $70c0		; $7073
	call $70a4		; $7076
	ld a,$04		; $7079
	call $7266		; $707b
	ld a,$01		; $707e
	call interactionSetAnimation		; $7080
	jp $70c0		; $7083
	call $70a4		; $7086
	ld l,$4f		; $7089
	ld (hl),$00		; $708b
	ld a,$05		; $708d
	call interactionSetAnimation		; $708f
	jp $70c0		; $7092
	call $70a4		; $7095
	ld l,$4f		; $7098
	ld (hl),$00		; $709a
	ld a,$06		; $709c
	call interactionSetAnimation		; $709e
	jp $70c0		; $70a1
	call interactionInitGraphics		; $70a4
	call objectSetVisiblec0		; $70a7
	call interactionSetAlwaysUpdateBit		; $70aa
	call $71ba		; $70ad
	call interactionIncState		; $70b0
	ld l,$50		; $70b3
	ld (hl),$50		; $70b5
	ld l,$4f		; $70b7
	ld (hl),$f8		; $70b9
	ld l,$48		; $70bb
	ld (hl),$ff		; $70bd
	ret			; $70bf
	ld e,$42		; $70c0
	ld a,(de)		; $70c2
	rst_jumpTable			; $70c3
	call nc,$d470		; $70c4
	ld (hl),b		; $70c7
	call nc,$d470		; $70c8
	ld (hl),b		; $70cb
	sub (hl)		; $70cc
	ld (hl),c		; $70cd
	sub (hl)		; $70ce
	ld (hl),c		; $70cf
	or h			; $70d0
	ld (hl),c		; $70d1
	or h			; $70d2
	ld (hl),c		; $70d3
	ld e,$45		; $70d4
	ld a,(de)		; $70d6
	rst_jumpTable			; $70d7
	.dw $70e2
	dec d			; $70da
	ld (hl),c		; $70db
	ld (hl),$71		; $70dc
	ld d,l			; $70de
	ld (hl),c		; $70df
	sub e			; $70e0
	ld (hl),c		; $70e1
	call $71ee		; $70e2
	call $7220		; $70e5
	call $720a		; $70e8
	call c,$7232		; $70eb
	jp nc,_label_0a_311		; $70ee
	ld h,d			; $70f1
	ld l,$45		; $70f2
	ld (hl),$01		; $70f4
	ld l,$47		; $70f6
	ld (hl),$28		; $70f8
	ld l,$42		; $70fa
	ld a,(hl)		; $70fc
	cp $02			; $70fd
	jr nz,_label_0a_303	; $70ff
	ld a,$00		; $7101
	jr _label_0a_305		; $7103
_label_0a_303:
	cp $03			; $7105
	jr nz,_label_0a_304	; $7107
	ld a,$01		; $7109
	jr _label_0a_305		; $710b
_label_0a_304:
	ld a,$02		; $710d
_label_0a_305:
	call interactionSetAnimation		; $710f
	jp _label_0a_311		; $7112
	call $71ce		; $7115
	call _label_0a_311		; $7118
	call interactionDecCounter2		; $711b
	ret nz			; $711e
	ld l,$45		; $711f
	inc (hl)		; $7121
	ld l,$47		; $7122
	ld (hl),$28		; $7124
	ld hl,$cfc6		; $7126
	inc (hl)		; $7129
	ld a,(hl)		; $712a
	cp $02			; $712b
	ret nz			; $712d
	ld (hl),$00		; $712e
	ld hl,$cfc0		; $7130
	set 0,(hl)		; $7133
	ret			; $7135
	call $71ce		; $7136
	call _label_0a_311		; $7139
	ld a,($cfc0)		; $713c
	bit 0,a			; $713f
	ret nz			; $7141
	call interactionDecCounter2		; $7142
	ret nz			; $7145
	ld l,$45		; $7146
	inc (hl)		; $7148
	ld l,$48		; $7149
	ld (hl),$ff		; $714b
	ld l,$42		; $714d
	ld a,(hl)		; $714f
	add $04			; $7150
	jp $7266		; $7152
	ld e,$42		; $7155
	ld a,(de)		; $7157
	cp $02			; $7158
	jr c,_label_0a_307	; $715a
_label_0a_306:
	call $71ee		; $715c
	call $720a		; $715f
	call c,$7232		; $7162
	jr c,_label_0a_308	; $7165
_label_0a_307:
	call $71ee		; $7167
	ld e,$42		; $716a
	ld a,(de)		; $716c
	cp $04			; $716d
	call nz,$7220		; $716f
	call $720a		; $7172
	call c,$7232		; $7175
	jr nc,_label_0a_311	; $7178
_label_0a_308:
	ld e,$42		; $717a
	ld a,(de)		; $717c
	cp $02			; $717d
	jr c,_label_0a_309	; $717f
	cp $04			; $7181
	jr c,_label_0a_310	; $7183
_label_0a_309:
	call $7126		; $7185
	jp interactionDelete		; $7188
_label_0a_310:
	call $7126		; $718b
	ld h,d			; $718e
	ld l,$45		; $718f
	inc (hl)		; $7191
	ret			; $7192
	jp _label_0a_311		; $7193
	ld e,$45		; $7196
	ld a,(de)		; $7198
	rst_jumpTable			; $7199
	sbc (hl)		; $719a
	ld (hl),c		; $719b
	or d			; $719c
	ld (hl),c		; $719d
	call $71ce		; $719e
	call _label_0a_311		; $71a1
	ld a,($cfc0)		; $71a4
	bit 0,a			; $71a7
	ret z			; $71a9
	call interactionIncState2		; $71aa
	ld l,$48		; $71ad
	ld (hl),$ff		; $71af
	ret			; $71b1
	jr _label_0a_306		; $71b2
	jp _label_0a_311		; $71b4
_label_0a_311:
	jp interactionAnimate		; $71b7
	ld e,$42		; $71ba
	ld a,(de)		; $71bc
	ld hl,$71c6		; $71bd
	rst_addAToHl			; $71c0
	ld a,(hl)		; $71c1
	ld e,$5c		; $71c2
	ld (de),a		; $71c4
	ret			; $71c5
	ld (bc),a		; $71c6
	ld bc,$0102		; $71c7
	nop			; $71ca
	ld bc,$0102		; $71cb
	ld a,(wFrameCounter)		; $71ce
	and $07			; $71d1
	ret nz			; $71d3
	ld a,(wFrameCounter)		; $71d4
	and $38			; $71d7
	swap a			; $71d9
	rlca			; $71db
	ld hl,$71e6		; $71dc
	rst_addAToHl			; $71df
	ld e,$4f		; $71e0
	ld a,(de)		; $71e2
	add (hl)		; $71e3
	ld (de),a		; $71e4
	ret			; $71e5
	rst $38			; $71e6
	cp $ff			; $71e7
	nop			; $71e9
	ld bc,$0102		; $71ea
	nop			; $71ed
	ld h,d			; $71ee
	ld l,$7c		; $71ef
	ld a,(hl)		; $71f1
	add a			; $71f2
	ld b,a			; $71f3
	ld e,$7f		; $71f4
	ld a,(de)		; $71f6
	ld l,a			; $71f7
	ld e,$7e		; $71f8
	ld a,(de)		; $71fa
	ld h,a			; $71fb
	ld a,b			; $71fc
	rst_addAToHl			; $71fd
	ld b,(hl)		; $71fe
	inc hl			; $71ff
	ld c,(hl)		; $7200
	call objectGetRelativeAngle		; $7201
	ld e,$49		; $7204
	ld (de),a		; $7206
	jp objectApplySpeed		; $7207
	call $7253		; $720a
	ld l,$4b		; $720d
	ld a,(bc)		; $720f
	sub (hl)		; $7210
	add $01			; $7211
	cp $05			; $7213
	ret nc			; $7215
	inc bc			; $7216
	ld l,$4d		; $7217
	ld a,(bc)		; $7219
	sub (hl)		; $721a
	add $01			; $721b
_label_0a_312:
	cp $05			; $721d
	ret			; $721f
	ld h,d			; $7220
	ld l,$49		; $7221
	ld a,(hl)		; $7223
	swap a			; $7224
	and $01			; $7226
	xor $01			; $7228
	ld l,$48		; $722a
	cp (hl)			; $722c
	ret z			; $722d
	ld (hl),a		; $722e
	jp interactionSetAnimation		; $722f
	call $7242		; $7232
	ld h,d			; $7235
	ld l,$7d		; $7236
	ld a,(hl)		; $7238
	ld l,$7c		; $7239
	inc (hl)		; $723b
	cp (hl)			; $723c
	ret nc			; $723d
	ld (hl),$00		; $723e
	scf			; $7240
	ret			; $7241
	call $7253		; $7242
	ld l,$4a		; $7245
	xor a			; $7247
	ldi (hl),a		; $7248
	ld a,(bc)		; $7249
_label_0a_313:
	ld (hl),a		; $724a
	inc bc			; $724b
	ld l,$4c		; $724c
	xor a			; $724e
	ldi (hl),a		; $724f
	ld a,(bc)		; $7250
	ld (hl),a		; $7251
	ret			; $7252
	ld h,d			; $7253
	ld l,$7c		; $7254
	ld a,(hl)		; $7256
	add a			; $7257
	push af			; $7258
	ld e,$7f		; $7259
	ld a,(de)		; $725b
	ld c,a			; $725c
	ld e,$7e		; $725d
	ld a,(de)		; $725f
	ld b,a			; $7260
	pop af			; $7261
	call addAToBc		; $7262
	ret			; $7265
	add a			; $7266
	add a			; $7267
	ld hl,$7279		; $7268
	rst_addAToHl			; $726b
	ld e,$7f		; $726c
	ldi a,(hl)		; $726e
	ld (de),a		; $726f
	ld e,$7e		; $7270
_label_0a_314:
	ldi a,(hl)		; $7272
	ld (de),a		; $7273
	ld e,$7d		; $7274
	ldi a,(hl)		; $7276
	ld (de),a		; $7277
	ret			; $7278
	sbc c			; $7279
	ld (hl),d		; $727a
	ld ($ab00),sp		; $727b
	ld (hl),d		; $727e
	ld ($e500),sp		; $727f
	ld (hl),d		; $7282
	dec bc			; $7283
_label_0a_315:
	nop			; $7284
.DB $fd				; $7285
	ld (hl),d		; $7286
	dec bc			; $7287
	nop			; $7288
	cp l			; $7289
	ld (hl),d		; $728a
	add hl,bc		; $728b
	nop			; $728c
	pop de			; $728d
	ld (hl),d		; $728e
	add hl,bc		; $728f
	nop			; $7290
	dec d			; $7291
	ld (hl),e		; $7292
	inc b			; $7293
	nop			; $7294
	rra			; $7295
	ld (hl),e		; $7296
	inc b			; $7297
	nop			; $7298
	ldi (hl),a		; $7299
	ld l,b			; $729a
	jr z,_label_0a_312	; $729b
	ld l,$8a		; $729d
	inc (hl)		; $729f
	sub b			; $72a0
	ldd a,(hl)		; $72a1
	adc d			; $72a2
	ld b,b			; $72a3
	add b			; $72a4
	ld b,(hl)		; $72a5
	ld l,b			; $72a6
	ld c,d			; $72a7
	ld d,b			; $72a8
	ld d,b			; $72a9
	jr z,_label_0a_316	; $72aa
	jr c,_label_0a_317	; $72ac
	jr nz,_label_0a_318	; $72ae
	ld d,$34		; $72b0
	stop			; $72b2
	ldd a,(hl)		; $72b3
	ld d,$40		; $72b4
	jr nz,$46		; $72b6
	jr c,_label_0a_319	; $72b8
	ld d,b			; $72ba
	ld d,b			; $72bb
	ld a,b			; $72bc
	ld d,h			; $72bd
	jr _label_0a_320		; $72be
	ld c,$60		; $72c0
	ld ($0c68),sp		; $72c2
	ld (hl),d		; $72c5
	jr $78			; $72c6
	jr z,_label_0a_313	; $72c8
	ld c,b			; $72ca
	adc b			; $72cb
	ld l,b			; $72cc
	sub b			; $72cd
_label_0a_316:
	add b			; $72ce
	and b			; $72cf
	and b			; $72d0
	ld d,h			; $72d1
	adc b			; $72d2
	ld e,b			; $72d3
	sub d			; $72d4
	ld h,b			; $72d5
_label_0a_317:
	sbc b			; $72d6
	ld l,b			; $72d7
	sub h			; $72d8
	ld (hl),d		; $72d9
	adc b			; $72da
	ld a,b			; $72db
	ld a,b			; $72dc
	add b			; $72dd
_label_0a_318:
	ld e,b			; $72de
	adc b			; $72df
	jr c,_label_0a_314	; $72e0
	jr nz,_label_0a_315	; $72e2
	nop			; $72e4
	ld bc,$2940		; $72e5
	jr $39			; $72e8
	stop			; $72ea
	ld b,l			; $72eb
	inc c			; $72ec
	ld d,c			; $72ed
	stop			; $72ee
	ld h,c			; $72ef
	jr _label_0a_321		; $72f0
	jr z,$77		; $72f2
	jr c,_label_0a_322	; $72f4
	ld c,b			; $72f6
	ld (hl),a		; $72f7
	ld e,b			; $72f8
	ld (hl),c		; $72f9
	ld l,b			; $72fa
	ld h,c			; $72fb
	ld a,b			; $72fc
	ld bc,$2960		; $72fd
	adc b			; $7300
	add hl,sp		; $7301
	sub b			; $7302
	ld b,l			; $7303
_label_0a_319:
	sub h			; $7304
	ld d,c			; $7305
	sub b			; $7306
	ld h,c			; $7307
	adc b			; $7308
	ld (hl),c		; $7309
	ld a,b			; $730a
	ld (hl),a		; $730b
	ld l,b			; $730c
	ld a,c			; $730d
	ld e,b			; $730e
	ld (hl),a		; $730f
	ld c,b			; $7310
	ld (hl),c		; $7311
	jr c,_label_0a_323	; $7312
	jr z,$5d		; $7314
	sub b			; $7316
	ld c,l			; $7317
_label_0a_320:
	sbc b			; $7318
	add hl,sp		; $7319
	sub b			; $731a
	dec l			; $731b
	ld a,b			; $731c
	add hl,hl		; $731d
	ld h,b			; $731e
	ld e,l			; $731f
	stop			; $7320
	ld c,l			; $7321
	ld ($1039),sp		; $7322
	dec l			; $7325
	jr z,$29		; $7326
	ld b,b			; $7328

interactionCodeb5:
	ld e,$44		; $7329
	ld a,(de)		; $732b
	rst_jumpTable			; $732c
	ld sp,$5573		; $732d
	ld (hl),e		; $7330
	ld a,$01		; $7331
	ld (de),a		; $7333
	call getThisRoomFlags		; $7334
	bit 6,a			; $7337
	jp nz,interactionDelete		; $7339
	set 6,(hl)		; $733c
	call setDeathRespawnPoint		; $733e
	ld a,$09		; $7341
	ld ($c6df),a		; $7343
	xor a			; $7346
	ld ($cba0),a		; $7347
	ld a,$78		; $734a
	ld e,$46		; $734c
	ld (de),a		; $734e
	ld bc,$5878		; $734f
	jp createEnergySwirlGoingIn		; $7352
	ld e,$45		; $7355
	ld a,(de)		; $7357
	rst_jumpTable			; $7358
	ld e,a			; $7359
	ld (hl),e		; $735a
	ld (hl),l		; $735b
	ld (hl),e		; $735c
	sub a			; $735d
	ld (hl),e		; $735e
	call interactionDecCounter1		; $735f
	ret nz			; $7362
_label_0a_321:
	call interactionIncState2		; $7363
	ld l,$46		; $7366
	ld (hl),$08		; $7368
	ld hl,$cbb3		; $736a
	ld (hl),$00		; $736d
_label_0a_322:
	ld hl,$cbba		; $736f
	ld (hl),$ff		; $7372
	ret			; $7374
_label_0a_323:
	ld e,$46		; $7375
	ld a,(de)		; $7377
	or a			; $7378
	jr nz,_label_0a_324	; $7379
	call setLinkForceStateToState08		; $737b
	ld hl,$d01a		; $737e
	set 7,(hl)		; $7381
_label_0a_324:
	call interactionDecCounter1		; $7383
	ld hl,$cbb3		; $7386
	ld b,$01		; $7389
	call flashScreen		; $738b
	ret z			; $738e
	call interactionIncState2		; $738f
	ld a,$03		; $7392
	jp fadeinFromWhiteWithDelay		; $7394
	ld a,($c4ab)		; $7397
	or a			; $739a
	ret nz			; $739b
	xor a			; $739c
	ld ($cca4),a		; $739d
	ld ($cc02),a		; $73a0
	jp interactionDelete		; $73a3

interactionCodeb8:
	ld e,$44		; $73a6
	ld a,(de)		; $73a8
	rst_jumpTable			; $73a9
	xor (hl)		; $73aa
	ld (hl),e		; $73ab
	ei			; $73ac
	ld (hl),e		; $73ad
	call checkIsLinkedGame		; $73ae
	jp z,interactionDelete		; $73b1
	call $740a		; $73b4
	ld e,$42		; $73b7
	ld a,(de)		; $73b9
	cp $03			; $73ba
	jr z,_label_0a_325	; $73bc
	ld hl,$73f6		; $73be
	rst_addAToHl			; $73c1
	ld e,$7e		; $73c2
	ld a,(de)		; $73c4
	cp (hl)			; $73c5
	jp nz,interactionDelete		; $73c6
	jr _label_0a_326		; $73c9
_label_0a_325:
	ld a,$13		; $73cb
	call checkGlobalFlag		; $73cd
	jp nz,interactionDelete		; $73d0
_label_0a_326:
	call interactionInitGraphics		; $73d3
	call interactionIncState		; $73d6
	ld e,$42		; $73d9
	ld a,(de)		; $73db
	ld hl,$7432		; $73dc
	rst_addDoubleIndex			; $73df
	ldi a,(hl)		; $73e0
	ld h,(hl)		; $73e1
	ld l,a			; $73e2
	call interactionSetScript		; $73e3
	ld a,$3a		; $73e6
	call interactionSetHighTextIndex		; $73e8
	call objectSetVisible80		; $73eb
	ld a,$02		; $73ee
	call interactionSetAnimation		; $73f0
	jp $7407		; $73f3
	nop			; $73f6
	ld bc,$0002		; $73f7
	inc bc			; $73fa
	call interactionRunScript		; $73fb
	ld e,$7f		; $73fe
	ld a,(de)		; $7400
	or a			; $7401
	jr nz,_label_0a_327	; $7402
	jp npcFaceLinkAndAnimate		; $7404
_label_0a_327:
	jp interactionAnimate		; $7407
	ld a,$13		; $740a
	call checkGlobalFlag		; $740c
	jr nz,_label_0a_331	; $740f
	ld a,$40		; $7411
	call checkTreasureObtained		; $7413
	jr c,_label_0a_328	; $7416
	xor a			; $7418
_label_0a_328:
	cp $10			; $7419
	jr nc,_label_0a_330	; $741b
	cp $04			; $741d
	jr nc,_label_0a_329	; $741f
	xor a			; $7421
	jr _label_0a_332		; $7422
_label_0a_329:
	ld a,$01		; $7424
	jr _label_0a_332		; $7426
_label_0a_330:
	ld a,$02		; $7428
	jr _label_0a_332		; $742a
_label_0a_331:
	ld a,$03		; $742c
_label_0a_332:
	ld e,$7e		; $742e
	ld (de),a		; $7430
	ret			; $7431
	ld b,c			; $7432
	ld a,d			; $7433
	ld d,c			; $7434
	ld a,d			; $7435
	ld h,c			; $7436
	ld a,d			; $7437
	ld (hl),c		; $7438
	ld a,d			; $7439
	ld a,a			; $743a
	ld a,d			; $743b

interactionCodeb9:
	ld e,$44		; $743c
	ld a,(de)		; $743e
	rst_jumpTable			; $743f
	ld b,h			; $7440
	ld (hl),h		; $7441
	ld sp,hl		; $7442
	ld (hl),h		; $7443
	ld a,$01		; $7444
	ld (de),a		; $7446
	call interactionInitGraphics		; $7447
	call objectSetVisiblec2		; $744a
	call objectSetInvisible		; $744d
	ld e,$42		; $7450
	ld a,(de)		; $7452
	ld b,a			; $7453
	ld hl,$74cb		; $7454
	rst_addAToHl			; $7457
	ld a,(hl)		; $7458
	ld e,$46		; $7459
	ld (de),a		; $745b
	ld a,b			; $745c
	ld hl,$74d3		; $745d
	rst_addDoubleIndex			; $7460
	ld b,(hl)		; $7461
	inc hl			; $7462
	ld a,(hl)		; $7463
	ld c,a			; $7464
	ld e,$76		; $7465
	ld (de),a		; $7467
	call objectGetRelativeAngle		; $7468
	ld e,$49		; $746b
	ld (de),a		; $746d
	ld e,$50		; $746e
	ld a,$28		; $7470
	ld (de),a		; $7472
	ld e,$42		; $7473
	ld a,(de)		; $7475
	rst_jumpTable			; $7476
	add a			; $7477
	ld (hl),h		; $7478
	sub h			; $7479
	ld (hl),h		; $747a
	sub h			; $747b
	ld (hl),h		; $747c
	and c			; $747d
	ld (hl),h		; $747e
	xor h			; $747f
	ld (hl),h		; $7480
	xor h			; $7481
	ld (hl),h		; $7482
_label_0a_333:
	xor h			; $7483
	ld (hl),h		; $7484
	push bc			; $7485
	ld (hl),h		; $7486
	ld e,$49		; $7487
	ld a,$04		; $7489
	ld (de),a		; $748b
	ld h,d			; $748c
	ld l,$46		; $748d
	ld (hl),$e0		; $748f
	inc hl			; $7491
	ld (hl),$01		; $7492
	ld e,$42		; $7494
	ld a,(de)		; $7496
	ld hl,$74e3		; $7497
	rst_addDoubleIndex			; $749a
	ld c,(hl)		; $749b
	inc hl			; $749c
	ld b,(hl)		; $749d
	jp objectSetSpeedZ		; $749e
	call $7494		; $74a1
	ld e,$50		; $74a4
	ld a,$3c		; $74a6
	ld (de),a		; $74a8
	jp $74b4		; $74a9
	call $7494		; $74ac
	ld e,$50		; $74af
	ld a,$0a		; $74b1
	ld (de),a		; $74b3
	ld e,$42		; $74b4
	ld a,(de)		; $74b6
	sub $03			; $74b7
	ld hl,$74f1		; $74b9
	rst_addDoubleIndex			; $74bc
	ld e,$4f		; $74bd
	ldi a,(hl)		; $74bf
	ld (de),a		; $74c0
	dec e			; $74c1
	ld a,(hl)		; $74c2
	ld (de),a		; $74c3
	ret			; $74c4
	ld hl,$7a81		; $74c5
	jp interactionSetScript		; $74c8
	and $5a			; $74cb
	ld a,b			; $74cd
	cp (hl)			; $74ce
	ret z			; $74cf
	jp nc,$fadc		; $74d0
	ld e,b			; $74d3
	jr c,$48		; $74d4
	ld b,b			; $74d6
	ld c,h			; $74d7
	ld h,b			; $74d8
	ld c,b			; $74d9
	ld a,b			; $74da
	ld a,(de)		; $74db
	inc l			; $74dc
	stop			; $74dd
	jr c,_label_0a_334	; $74de
	ld b,h			; $74e0
	jr _label_0a_333		; $74e1
	ld b,b			; $74e3
	rst $38			; $74e4
	ld ($ff00+$fe),a	; $74e5
	nop			; $74e7
	rst $38			; $74e8
	ret nz			; $74e9
_label_0a_334:
	rst $38			; $74ea
	ld (hl),$00		; $74eb
	ld (hl),$00		; $74ed
	ld (hl),$00		; $74ef
	add sp,-$01		; $74f1
	ret z			; $74f3
	rst $38			; $74f4
	ret z			; $74f5
	rst $38			; $74f6
	ret z			; $74f7
	rst $38			; $74f8
	ld e,$45		; $74f9
	ld a,(de)		; $74fb
	rst_jumpTable			; $74fc
	inc bc			; $74fd
	ld (hl),l		; $74fe
	dec c			; $74ff
	ld (hl),l		; $7500
	ld e,(hl)		; $7501
	ld (hl),l		; $7502
	call interactionDecCounter1		; $7503
	ret nz			; $7506
	call objectSetVisible		; $7507
	jp interactionIncState2		; $750a
	call interactionAnimate		; $750d
	call objectApplySpeed		; $7510
	ld h,d			; $7513
	ld l,$4d		; $7514
	ld a,(hl)		; $7516
	ld l,$76		; $7517
	cp (hl)			; $7519
	jr nz,_label_0a_335	; $751a
	call interactionIncState2		; $751c
	ld l,$4f		; $751f
	ld (hl),$00		; $7521
	ld l,$42		; $7523
	ld a,(hl)		; $7525
	add a			; $7526
	inc a			; $7527
	jp interactionSetAnimation		; $7528
_label_0a_335:
	ld e,$42		; $752b
	ld a,(de)		; $752d
	rst_jumpTable			; $752e
	ccf			; $752f
	ld (hl),l		; $7530
	ccf			; $7531
	ld (hl),l		; $7532
	ccf			; $7533
	ld (hl),l		; $7534
	ld c,d			; $7535
	ld (hl),l		; $7536
	ld e,d			; $7537
	ld (hl),l		; $7538
	ld e,d			; $7539
	ld (hl),l		; $753a
	ld e,d			; $753b
	ld (hl),l		; $753c
	ld e,c			; $753d
	ld (hl),l		; $753e
	ld c,$20		; $753f
	call objectUpdateSpeedZ_paramC		; $7541
	ret nz			; $7544
	ld e,$42		; $7545
	jp $7494		; $7547
	ld c,$10		; $754a
_label_0a_336:
	ld e,$77		; $754c
	ld a,(de)		; $754e
	or a			; $754f
	ret nz			; $7550
	call objectUpdateSpeedZ_paramC		; $7551
	ret nz			; $7554
	ld h,d			; $7555
	ld l,$77		; $7556
	inc (hl)		; $7558
	ret			; $7559
	ld c,$01		; $755a
	jr _label_0a_336		; $755c
	ld e,$42		; $755e
	ld a,(de)		; $7560
	or a			; $7561
	jr nz,_label_0a_337	; $7562
	ld b,a			; $7564
	ld h,d			; $7565
	ld l,$46		; $7566
	call decHlRef16WithCap		; $7568
	jr nz,_label_0a_338	; $756b
	ld hl,$cfdf		; $756d
	ld (hl),$01		; $7570
	ret			; $7572
_label_0a_337:
	cp $07			; $7573
	jr nz,_label_0a_338	; $7575
	call interactionRunScript		; $7577
	ld e,$47		; $757a
	ld a,(de)		; $757c
	or a			; $757d
	ret z			; $757e
_label_0a_338:
	jp interactionAnimate		; $757f

interactionCodeba:
	ld e,$42		; $7582
	ld a,(de)		; $7584
	rst_jumpTable			; $7585
	jp $8e75		; $7586
	ld (hl),l		; $7589
	adc (hl)		; $758a
	ld (hl),l		; $758b
	and l			; $758c
	ld (hl),l		; $758d
	ld e,$44		; $758e
	ld a,(de)		; $7590
	rst_jumpTable			; $7591
	sub (hl)		; $7592
	ld (hl),l		; $7593
	sbc a			; $7594
	ld (hl),l		; $7595
	call $7867		; $7596
	ld l,$43		; $7599
	ld a,(hl)		; $759b
	call interactionSetAnimation		; $759c
	call interactionRunScript		; $759f
	jp $7886		; $75a2
	ld e,$44		; $75a5
	ld a,(de)		; $75a7
	rst_jumpTable			; $75a8
	xor l			; $75a9
	ld (hl),l		; $75aa
	or b			; $75ab
	ld (hl),l		; $75ac
	call $7867		; $75ad
	call interactionRunScript		; $75b0
	jp c,interactionDelete		; $75b3
	jp $7886		; $75b6

interactionCodebb:
	ld e,$42		; $75b9
	ld a,(de)		; $75bb
	rst_jumpTable			; $75bc
	jp $2c75		; $75bd
	halt			; $75c0
	inc l			; $75c1
	halt			; $75c2
	ld e,$44		; $75c3
	ld a,(de)		; $75c5
	rst_jumpTable			; $75c6
	pop de			; $75c7
	ld (hl),l		; $75c8
	jp c,$ec75		; $75c9
	ld (hl),l		; $75cc
	nop			; $75cd
	halt			; $75ce
	dec e			; $75cf
	halt			; $75d0
	call $7867		; $75d1
	ld l,$43		; $75d4
	ld a,(hl)		; $75d6
	call interactionSetAnimation		; $75d7
	call interactionRunScript		; $75da
	call $7886		; $75dd
	ld a,($cfc0)		; $75e0
	bit 7,a			; $75e3
	ret z			; $75e5
	call $788e		; $75e6
	jp interactionIncState		; $75e9
	call interactionRunScript		; $75ec
	call $7886		; $75ef
	call $7862		; $75f2
	ret nz			; $75f5
	ld l,$44		; $75f6
	inc (hl)		; $75f8
	ld l,$7c		; $75f9
	ld (hl),$0a		; $75fb
	jp $78c3		; $75fd
	call interactionRunScript		; $7600
	call $7886		; $7603
	call $7862		; $7606
	ret nz			; $7609
	ld l,$44		; $760a
	inc (hl)		; $760c
	ld l,$50		; $760d
	ld (hl),$28		; $760f
	ld l,$7c		; $7611
	ld (hl),$58		; $7613
	call $78b3		; $7615
	ld a,$d2		; $7618
	jp playSound		; $761a
	call $7862		; $761d
	jp z,interactionDelete		; $7620
	call objectApplySpeed		; $7623
	call interactionRunScript		; $7626
	jp $7886		; $7629
	ld e,$44		; $762c
	ld a,(de)		; $762e
	rst_jumpTable			; $762f
	inc (hl)		; $7630
	halt			; $7631
	ld d,b			; $7632
	halt			; $7633
	ld a,$01		; $7634
	ld (de),a		; $7636
	call interactionInitGraphics		; $7637
	ld h,d			; $763a
	ld l,$42		; $763b
	ld a,(hl)		; $763d
	ld b,$02		; $763e
	cp $03			; $7640
	jr z,_label_0a_339	; $7642
	ld b,$00		; $7644
_label_0a_339:
	ld l,$5c		; $7646
	ld (hl),b		; $7648
	ld l,$46		; $7649
	ld (hl),$78		; $764b
	jp objectSetVisiblec1		; $764d
	ld e,$45		; $7650
	ld a,(de)		; $7652
	rst_jumpTable			; $7653
	ld l,h			; $7654
	halt			; $7655
	add (hl)		; $7656
	halt			; $7657
	xor b			; $7658
	halt			; $7659
	or d			; $765a
	halt			; $765b
	ret z			; $765c
	halt			; $765d
	sub $76			; $765e
	ld (hl),l		; $7660
	ld (hl),a		; $7661
	adc h			; $7662
	ld (hl),a		; $7663
	and d			; $7664
	ld (hl),a		; $7665
	or c			; $7666
	ld (hl),a		; $7667
	rst_jumpTable			; $7668
	ld (hl),a		; $7669
.DB $db				; $766a
	ld (hl),a		; $766b
	call interactionDecCounter1		; $766c
	ret nz			; $766f
	ld (hl),$66		; $7670
	ld l,$50		; $7672
	ld (hl),$32		; $7674
	ld l,$49		; $7676
	ld (hl),$18		; $7678
	call interactionIncState2		; $767a
	ld e,$49		; $767d
	ld a,(de)		; $767f
	call convertAngleDeToDirection		; $7680
	jp interactionSetAnimation		; $7683
	call $769f		; $7686
	call interactionDecCounter1		; $7689
	ret nz			; $768c
	call getRandomNumber		; $768d
	and $0f			; $7690
	add $1e			; $7692
	ld (hl),a		; $7694
	ld l,$49		; $7695
	ld (hl),$08		; $7697
	call $767d		; $7699
	jp interactionIncState2		; $769c
	call interactionAnimate		; $769f
	call interactionAnimate		; $76a2
	jp objectApplySpeed		; $76a5
	call interactionDecCounter1		; $76a8
	ret nz			; $76ab
	call $77eb		; $76ac
	jp interactionIncState2		; $76af
	call $77e5		; $76b2
	ld a,($cfd0)		; $76b5
	cp $01			; $76b8
	ret nz			; $76ba
	ld e,$4f		; $76bb
	ld a,(de)		; $76bd
	or a			; $76be
	ret nz			; $76bf
	call interactionIncState2		; $76c0
	ld l,$46		; $76c3
	ld (hl),$1e		; $76c5
	ret			; $76c7
	call interactionDecCounter1		; $76c8
	ret nz			; $76cb
	ld l,$50		; $76cc
	ld (hl),$50		; $76ce
	call $772e		; $76d0
	jp interactionIncState2		; $76d3
	ld a,($cfd0)		; $76d6
	cp $02			; $76d9
	jr nz,_label_0a_340	; $76db
	ld e,$4f		; $76dd
	ld a,(de)		; $76df
	or a			; $76e0
	jr nz,_label_0a_340	; $76e1
	call interactionIncState2		; $76e3
	ld l,$46		; $76e6
	ld (hl),$0a		; $76e8
	ld l,$49		; $76ea
	ld (hl),$18		; $76ec
	jp $767d		; $76ee
_label_0a_340:
	ld e,$77		; $76f1
	ld a,(de)		; $76f3
	rst_jumpTable			; $76f4
	ei			; $76f5
	halt			; $76f6
	ld (de),a		; $76f7
	ld (hl),a		; $76f8
	ld e,$77		; $76f9
	call $769f		; $76fb
	call interactionDecCounter1		; $76fe
	ret nz			; $7701
	ld (hl),$0a		; $7702
	ld l,$77		; $7704
	inc (hl)		; $7706
	cp $68			; $7707
	ld a,$01		; $7709
	jr c,_label_0a_341	; $770b
	ld a,$03		; $770d
_label_0a_341:
	jp interactionSetAnimation		; $770f
	call interactionDecCounter1		; $7712
	ret nz			; $7715
	ld (hl),$1e		; $7716
	ld l,$77		; $7718
	inc (hl)		; $771a
	jp $77eb		; $771b
	call $77e5		; $771e
	call interactionDecCounter1		; $7721
	ret nz			; $7724
	xor a			; $7725
	ld l,$4e		; $7726
	ldi (hl),a		; $7728
	ld (hl),a		; $7729
	ld l,$77		; $772a
	ld (hl),$00		; $772c
	ld e,$42		; $772e
	ld a,(de)		; $7730
	dec a			; $7731
	ld b,a			; $7732
	swap a			; $7733
	sra a			; $7735
	add b			; $7737
	ld hl,$775a		; $7738
	rst_addAToHl			; $773b
	ld e,$47		; $773c
	ld a,(de)		; $773e
	rst_addDoubleIndex			; $773f
	ldi a,(hl)		; $7740
	ld b,(hl)		; $7741
	inc l			; $7742
	ld e,$46		; $7743
	ld (de),a		; $7745
	ld e,$49		; $7746
	ld a,b			; $7748
	ld (de),a		; $7749
	ld e,$47		; $774a
	ld a,(de)		; $774c
	ld b,a			; $774d
	inc b			; $774e
	ld a,(hl)		; $774f
	or a			; $7750
	jr nz,_label_0a_342	; $7751
	ld b,$00		; $7753
_label_0a_342:
	ld a,b			; $7755
	ld (de),a		; $7756
	jp $767d		; $7757
	ld a,(de)		; $775a
	add hl,bc		; $775b
	ld d,$1f		; $775c
	rla			; $775e
	rla			; $775f
	inc c			; $7760
	rrca			; $7761
	nop			; $7762
	inc c			; $7763
	add hl,bc		; $7764
	jr $0a			; $7765
	ld d,$18		; $7767
	ld (de),a		; $7769
	rra			; $776a
	nop			; $776b
	dec e			; $776c
	ld ($1619),sp		; $776d
	jr _label_0a_343		; $7770
	ld b,$01		; $7772
	nop			; $7774
	call interactionDecCounter1		; $7775
	ret nz			; $7778
	ld e,$42		; $7779
	ld a,(de)		; $777b
_label_0a_343:
	ld b,$34		; $777c
	cp $03			; $777e
	jr z,_label_0a_344	; $7780
	ld b,$20		; $7782
_label_0a_344:
	ld (hl),b		; $7784
	ld l,$50		; $7785
	ld (hl),$3c		; $7787
	jp interactionIncState2		; $7789
	call $769f		; $778c
	call interactionDecCounter1		; $778f
	ret nz			; $7792
	call getRandomNumber		; $7793
	and $07			; $7796
	inc a			; $7798
	ld (hl),a		; $7799
	ld a,$01		; $779a
	call interactionSetAnimation		; $779c
	jp interactionIncState2		; $779f
	ld a,($cfd0)		; $77a2
	cp $03			; $77a5
	ret nz			; $77a7
	call interactionDecCounter1		; $77a8
	ret nz			; $77ab
	call interactionIncState2		; $77ac
	jr _label_0a_345		; $77af
	call $77e5		; $77b1
	ld a,($cfd0)		; $77b4
	cp $04			; $77b7
	ret nz			; $77b9
	ld e,$4f		; $77ba
	ld a,(de)		; $77bc
	or a			; $77bd
	ret nz			; $77be
	call interactionIncState2		; $77bf
	ld l,$46		; $77c2
	ld (hl),$0c		; $77c4
	ret			; $77c6
	call interactionDecCounter1		; $77c7
	ret nz			; $77ca
	call interactionIncState2		; $77cb
	ld l,$46		; $77ce
	ld (hl),$50		; $77d0
	ld l,$50		; $77d2
	ld (hl),$3c		; $77d4
	ld a,$03		; $77d6
	jp interactionSetAnimation		; $77d8
	call $769f		; $77db
	call interactionDecCounter1		; $77de
	jp z,interactionDelete		; $77e1
	ret			; $77e4
	ld c,$20		; $77e5
	call objectUpdateSpeedZ_paramC		; $77e7
	ret nz			; $77ea
_label_0a_345:
	ld bc,$ff20		; $77eb
	jp objectSetSpeedZ		; $77ee

interactionCodebc:
interactionCodebd:
interactionCodebe:
	ld e,$42		; $77f1
	ld a,(de)		; $77f3
	rst_jumpTable			; $77f4
	jp $ff75		; $77f5
	ld (hl),a		; $77f8
	rra			; $77f9
	ld a,b			; $77fa
	inc l			; $77fb
	halt			; $77fc
	inc (hl)		; $77fd
	ld a,b			; $77fe
	ld e,$44		; $77ff
	ld a,(de)		; $7801
	rst_jumpTable			; $7802
	rlca			; $7803
	ld a,b			; $7804
	add hl,de		; $7805
	ld a,b			; $7806
	call $7867		; $7807
	ld e,$41		; $780a
	ld a,(de)		; $780c
	cp $bd			; $780d
	jr nz,_label_0a_346	; $780f
	ld a,$01		; $7811
	ld e,$7b		; $7813
	ld (de),a		; $7815
	call interactionSetAnimation		; $7816
_label_0a_346:
	call interactionRunScript		; $7819
	jp interactionAnimateAsNpc		; $781c
	ld e,$44		; $781f
	ld a,(de)		; $7821
	rst_jumpTable			; $7822
	daa			; $7823
	ld a,b			; $7824
	add hl,de		; $7825
	ld a,b			; $7826
	call $7867		; $7827
	ld a,$02		; $782a
	ld e,$7b		; $782c
	ld (de),a		; $782e
	call interactionSetAnimation		; $782f
	jr _label_0a_346		; $7832
	ld e,$44		; $7834
	ld a,(de)		; $7836
	rst_jumpTable			; $7837
	inc a			; $7838
	ld a,b			; $7839
	ld e,h			; $783a
	ld a,b			; $783b
	call checkIsLinkedGame		; $783c
	jp z,interactionDelete		; $783f
	call $78ce		; $7842
	ld e,$78		; $7845
	ld a,(de)		; $7847
	or a			; $7848
	jp z,interactionDelete		; $7849
	call interactionInitGraphics		; $784c
	call interactionIncState		; $784f
	ld l,$7e		; $7852
	ld (hl),$02		; $7854
	ld hl,$5779		; $7856
	call interactionSetScript		; $7859
	call interactionRunScript		; $785c
	jp npcFaceLinkAndAnimate		; $785f
	ld h,d			; $7862
	ld l,$7c		; $7863
	dec (hl)		; $7865
	ret			; $7866
	call interactionInitGraphics		; $7867
	ld e,$41		; $786a
	ld a,(de)		; $786c
	sub $ba			; $786d
	ld hl,$78e1		; $786f
	rst_addDoubleIndex			; $7872
	ldi a,(hl)		; $7873
	ld h,(hl)		; $7874
	ld l,a			; $7875
	ld e,$42		; $7876
	ld a,(de)		; $7878
	rst_addDoubleIndex			; $7879
	ldi a,(hl)		; $787a
	ld h,(hl)		; $787b
	ld l,a			; $787c
	call interactionSetScript		; $787d
	call objectSetVisible81		; $7880
	jp interactionIncState		; $7883
	ld e,$7d		; $7886
	ld a,(de)		; $7888
	or a			; $7889
	ret nz			; $788a
	jp interactionAnimate		; $788b
	ld e,$41		; $788e
	ld a,(de)		; $7890
	sub $ba			; $7891
	ld hl,$78a9		; $7893
	rst_addDoubleIndex			; $7896
	ldi a,(hl)		; $7897
	ld e,$7c		; $7898
	ld (de),a		; $789a
	ld a,(hl)		; $789b
	ld e,$49		; $789c
	ld (de),a		; $789e
	add $04			; $789f
	and $18			; $78a1
	swap a			; $78a3
	rlca			; $78a5
	jp interactionSetAnimation		; $78a6
	ld d,b			; $78a9
	ld e,$01		; $78aa
	ld (bc),a		; $78ac
	inc a			; $78ad
	ld d,$28		; $78ae
	inc e			; $78b0
	ld a,b			; $78b1
	jr -$33			; $78b2
	add $3a			; $78b4
	ret nz			; $78b6
	ld (hl),$4b		; $78b7
	inc l			; $78b9
	ld (hl),$02		; $78ba
	ld l,$46		; $78bc
	ld (hl),$78		; $78be
	jp objectCopyPosition		; $78c0
	call getFreePartSlot		; $78c3
	ret nz			; $78c6
	ld (hl),$27		; $78c7
	inc l			; $78c9
	inc (hl)		; $78ca
	jp objectCopyPosition		; $78cb
	ld a,$40		; $78ce
	call checkTreasureObtained		; $78d0
	jr c,_label_0a_347	; $78d3
	xor a			; $78d5
_label_0a_347:
	ld h,d			; $78d6
	ld l,$78		; $78d7
	cp $07			; $78d9
	ld (hl),$00		; $78db
	ret c			; $78dd
	ld (hl),$01		; $78de
	ret			; $78e0
.DB $eb				; $78e1
	ld a,b			; $78e2
	di			; $78e3
	ld a,b			; $78e4
	push af			; $78e5
	ld a,b			; $78e6
	ei			; $78e7
	ld a,b			; $78e8
	ld bc,$9179		; $78e9
	ld a,d			; $78ec
	sub d			; $78ed
	ld a,d			; $78ee
	sub c			; $78ef
	ld a,d			; $78f0
	or a			; $78f1
	ld a,d			; $78f2
	sub c			; $78f3
	ld a,d			; $78f4
	sub c			; $78f5
	ld a,d			; $78f6
	add $7a			; $78f7
	push de			; $78f9
	ld a,d			; $78fa
	sub c			; $78fb
	ld a,d			; $78fc
	jp c,$df7a		; $78fd
	ld a,d			; $7900
	sub c			; $7901
	ld a,d			; $7902
.DB $e4				; $7903
	ld a,d			; $7904
	jp hl			; $7905
	ld a,d			; $7906

interactionCodebf:
	ld e,$44		; $7907
	ld a,(de)		; $7909
	rst_jumpTable			; $790a
	rrca			; $790b
	ld a,c			; $790c
	inc e			; $790d
	ld a,c			; $790e
	call interactionInitGraphics		; $790f
	call interactionIncState		; $7912
	ld l,$46		; $7915
	ld (hl),$3c		; $7917
	jp objectSetVisible80		; $7919
	ld e,$45		; $791c
	ld a,(de)		; $791e
	rst_jumpTable			; $791f
	ld h,$79		; $7920
	dec sp			; $7922
	ld a,c			; $7923
	ld e,c			; $7924
	ld a,c			; $7925
	call interactionDecCounter1		; $7926
	jr z,_label_0a_348	; $7929
	ld a,(wFrameCounter)		; $792b
	rrca			; $792e
	jp nc,objectSetInvisible		; $792f
	jp objectSetVisible		; $7932
_label_0a_348:
	ld l,$45		; $7935
	inc (hl)		; $7937
	jp objectSetVisible		; $7938
	ld h,d			; $793b
	ld l,$42		; $793c
	ld a,(hl)		; $793e
	or a			; $793f
	jr nz,_label_0a_349	; $7940
	ld a,($cfc0)		; $7942
	bit 0,a			; $7945
	ret z			; $7947
	ld l,$45		; $7948
	inc (hl)		; $794a
	ld a,$02		; $794b
	jp interactionSetAnimation		; $794d
_label_0a_349:
	ld a,($cfc0)		; $7950
	bit 7,a			; $7953
	jp nz,interactionDelete		; $7955
	ret			; $7958
	ld a,($cfc0)		; $7959
	bit 1,a			; $795c
	jp nz,interactionDelete		; $795e
	ret			; $7961

interactionCodec1:
	ld e,$44		; $7962
	ld a,(de)		; $7964
	rst_jumpTable			; $7965
	ld l,d			; $7966
	ld a,c			; $7967
	add a			; $7968
	ld a,c			; $7969
	ld a,$01		; $796a
	ld (de),a		; $796c
	call interactionInitGraphics		; $796d
	ld h,d			; $7970
	ld l,$46		; $7971
	ld (hl),$86		; $7973
	inc l			; $7975
	ld (hl),$01		; $7976
	ld l,$76		; $7978
	ld (hl),$06		; $797a
	ld l,$49		; $797c
	ld (hl),$15		; $797e
	ld l,$50		; $7980
	ld (hl),$78		; $7982
	jp objectSetVisible82		; $7984
	ld e,$45		; $7987
	ld a,(de)		; $7989
	rst_jumpTable			; $798a
	sub c			; $798b
	ld a,c			; $798c
	sbc a			; $798d
	ld a,c			; $798e
	xor e			; $798f
	ld a,c			; $7990
	ld h,d			; $7991
	ld l,$46		; $7992
	call decHlRef16WithCap		; $7994
	ret nz			; $7997
	ld l,$46		; $7998
	ld (hl),$28		; $799a
	jp interactionIncState2		; $799c
	call $79bc		; $799f
	jr nz,_label_0a_350	; $79a2
	ld l,$60		; $79a4
	ld (hl),$01		; $79a6
	jp interactionIncState2		; $79a8
	call interactionAnimate		; $79ab
	call $79d1		; $79ae
	call objectApplySpeed		; $79b1
	ld e,$61		; $79b4
	ld a,(de)		; $79b6
	inc a			; $79b7
	jp z,interactionDelete		; $79b8
	ret			; $79bb
	call $79d1		; $79bc
	call objectApplySpeed		; $79bf
	jp interactionDecCounter1		; $79c2
_label_0a_350:
	ret			; $79c5
	ld a,(wFrameCounter)		; $79c6
	and $01			; $79c9
	jp z,objectSetInvisible		; $79cb
	jp objectSetVisible		; $79ce
	ld h,d			; $79d1
	ld l,$76		; $79d2
	dec (hl)		; $79d4
	ret nz			; $79d5
	ld (hl),$06		; $79d6
	ld bc,$8405		; $79d8
	jp objectCreateInteraction		; $79db

interactionCodec2:
	ld e,$44		; $79de
	ld a,(de)		; $79e0
	rst_jumpTable			; $79e1
	and $79			; $79e2
	push af			; $79e4
	ld a,c			; $79e5
	ld a,$01		; $79e6
	ld (de),a		; $79e8
	call interactionInitGraphics		; $79e9
	ld hl,$7aee		; $79ec
	call interactionSetScript		; $79ef
	jp interactionAnimateAsNpc		; $79f2
	call interactionRunScript		; $79f5
	jp interactionAnimateAsNpc		; $79f8

interactionCodec3:
	ld e,$44		; $79fb
	ld a,(de)		; $79fd
	rst_jumpTable			; $79fe
	inc bc			; $79ff
	ld a,d			; $7a00
	cpl			; $7a01
	ld a,d			; $7a02
	call checkInteractionState2		; $7a03
	jr nz,_label_0a_351	; $7a06
	ld a,$22		; $7a08
	call checkGlobalFlag		; $7a0a
	jp z,interactionDelete		; $7a0d
	ld a,$23		; $7a10
	call checkGlobalFlag		; $7a12
	jp nz,interactionDelete		; $7a15
	ld hl,$63dd		; $7a18
	ld e,$15		; $7a1b
	call interBankCall		; $7a1d
	jp interactionIncState2		; $7a20
_label_0a_351:
	call returnIfScrollMode01Unset		; $7a23
	call interactionIncState		; $7a26
	ld hl,$7aff		; $7a29
	call interactionSetScript		; $7a2c
	jp interactionRunScript		; $7a2f

interactionCodec4:
	call $7a68		; $7a32
	ld a,$00		; $7a35
	jr nz,_label_0a_352	; $7a37
	call $7a7b		; $7a39
	jp z,interactionDelete		; $7a3c
	ld a,$01		; $7a3f
_label_0a_352:
	ld hl,$7a8e		; $7a41
	rst_addDoubleIndex			; $7a44
	ldi a,(hl)		; $7a45
	ld h,(hl)		; $7a46
	ld l,a			; $7a47
	ld b,(hl)		; $7a48
	inc l			; $7a49
	push de			; $7a4a
	ld d,h			; $7a4b
	ld e,l			; $7a4c
_label_0a_353:
	call getFreeInteractionSlot		; $7a4d
	jr nz,_label_0a_354	; $7a50
	ld a,(de)		; $7a52
	ldi (hl),a		; $7a53
	inc de			; $7a54
	ld a,(de)		; $7a55
	ld (hl),a		; $7a56
	inc de			; $7a57
	ld l,$4b		; $7a58
	ld a,(de)		; $7a5a
	ldi (hl),a		; $7a5b
	inc de			; $7a5c
	inc l			; $7a5d
	ld a,(de)		; $7a5e
	ld (hl),a		; $7a5f
	inc de			; $7a60
	dec b			; $7a61
	jr nz,_label_0a_353	; $7a62
_label_0a_354:
	pop de			; $7a64
	jp interactionDelete		; $7a65
	call checkIsLinkedGame		; $7a68
	ret z			; $7a6b
	ld a,$19		; $7a6c
_label_0a_355:
	call checkGlobalFlag		; $7a6e
	jp z,$7a76		; $7a71
	xor a			; $7a74
	ret			; $7a75
	ld a,$1e		; $7a76
	jp checkGlobalFlag		; $7a78

seasonsFunc_0a_7a7b:
	call checkIsLinkedGame		; $7a7b
	ret z			; $7a7e

	ld a,GLOBALFLAG_S_1f		; $7a7f
	call checkGlobalFlag		; $7a81
	jp z,seasonsFunc_0a_7a89		; $7a84
	xor a			; $7a87
	ret			; $7a88

seasonsFunc_0a_7a89:
	ld a,GLOBALFLAG_S_19		; $7a89
	jp checkGlobalFlag		; $7a8b
	sub d			; $7a8e
	ld a,d			; $7a8f
	and a			; $7a90
	ld a,d			; $7a91
	dec b			; $7a92
	ld b,h			; $7a93
	rlca			; $7a94
	jr z,$48		; $7a95
	sbc l			; $7a97
	ld (bc),a		; $7a98
	jr nc,_label_0a_357	; $7a99
	cp h			; $7a9b
	ld bc,$6048		; $7a9c
	cp (hl)			; $7a9f
	ld bc,parseGivenObjectData		; $7aa0
	cp l			; $7aa3
	ld bc,$3030		; $7aa4
	inc bc			; $7aa7
	cp h			; $7aa8
	ld (bc),a		; $7aa9
	ld c,b			; $7aaa
	ld h,b			; $7aab
	cp (hl)			; $7aac
	ld (bc),a		; $7aad
	ld c,b			; $7aae
	jr nc,_label_0a_355	; $7aaf
	ld (bc),a		; $7ab1
	jr nc,_label_0a_356	; $7ab2

interactionCodec5:
	ld e,$44		; $7ab4
	ld a,(de)		; $7ab6
	rst_jumpTable			; $7ab7
	cp (hl)			; $7ab8
	ld a,d			; $7ab9
	rst $8			; $7aba
	ld a,d			; $7abb
	ld a,($ff00+c)		; $7abc
	ld a,d			; $7abd
	call getThisRoomFlags		; $7abe
	and $20			; $7ac1
	jp nz,interactionDelete		; $7ac3
	call interactionIncState		; $7ac6
	ld bc,$7b16		; $7ac9
	jp $7b3b		; $7acc
	ld a,($ccba)		; $7acf
	or a			; $7ad2
	ret z			; $7ad3
	ld a,$f1		; $7ad4
	call $7aea		; $7ad6
	ld a,$4d		; $7ad9
	call playSound		; $7adb
	ld e,$47		; $7ade
	ld a,$20		; $7ae0
	ld (de),a		; $7ae2
	dec e			; $7ae3
_label_0a_356:
	ld a,$10		; $7ae4
	ld (de),a		; $7ae6
	jp interactionIncState		; $7ae7
	ld c,$2c		; $7aea
	call setTile		; $7aec
	jp objectCreatePuff		; $7aef
	ld a,(wFrameCounter)		; $7af2
	rrca			; $7af5
	ret c			; $7af6
	call interactionDecCounter1		; $7af7
	ret nz			; $7afa

_label_0a_357:
	inc l			; $7afb
	ldd a,(hl)		; $7afc
	ldi (hl),a		; $7afd
	rrca			; $7afe
	cp $04			; $7aff
	jr z,_label_0a_358	; $7b01
	ld (hl),a		; $7b03
_label_0a_358:
	call $7b42		; $7b04
	ldi a,(hl)		; $7b07
	ld c,a			; $7b08
	call $7b49		; $7b09
	ld a,c			; $7b0c
	or a			; $7b0d
	jp z,interactionDelete		; $7b0e
	ld a,$f4		; $7b11
	jp breakCrackedFloor		; $7b13
	sbc l			; $7b16
	adc l			; $7b17
	adc h			; $7b18
	sbc e			; $7b19
	ld a,e			; $7b1a
	adc d			; $7b1b
	adc c			; $7b1c
	sbc b			; $7b1d
	ld (hl),a		; $7b1e
	halt			; $7b1f
	add (hl)		; $7b20
	sub (hl)		; $7b21
	ld (hl),h		; $7b22
	add e			; $7b23
	ld (hl),d		; $7b24
	add c			; $7b25
	ld h,c			; $7b26
	ld hl,$2211		; $7b27
	ld d,d			; $7b2a
	inc sp			; $7b2b
	inc d			; $7b2c
	ld b,h			; $7b2d
	dec (hl)		; $7b2e
	dec d			; $7b2f
	ld d,$47		; $7b30
	scf			; $7b32
	daa			; $7b33
	rla			; $7b34
	jr _label_0a_359		; $7b35
	ld c,c			; $7b37
	add hl,sp		; $7b38
	add hl,de		; $7b39
	nop			; $7b3a
	ld h,d			; $7b3b
	ld l,$58		; $7b3c
	ld (hl),c		; $7b3e
	inc l			; $7b3f
	ld (hl),b		; $7b40
	ret			; $7b41
	ld h,d			; $7b42
	ld l,$58		; $7b43
	ldi a,(hl)		; $7b45
	ld h,(hl)		; $7b46
	ld l,a			; $7b47
	ret			; $7b48
	ld e,$58		; $7b49
	ld a,l			; $7b4b
	ld (de),a		; $7b4c
	inc e			; $7b4d
	ld a,h			; $7b4e
	ld (de),a		; $7b4f
	ret			; $7b50

interactionCodec6:
	ld e,$44		; $7b51
	ld a,(de)		; $7b53
	rst_jumpTable			; $7b54
	ld e,a			; $7b55
	ld a,e			; $7b56
	ld l,b			; $7b57
	ld a,e			; $7b58
	add (hl)		; $7b59
	ld a,e			; $7b5a
	and c			; $7b5b
	ld a,e			; $7b5c
	call $3e7b		; $7b5d
	ld bc,$ea12		; $7b60
	cp e			; $7b63
	call z,$e9c3		; $7b64
	dec d			; $7b67
	ld a,($ccbc)		; $7b68
	or a			; $7b6b
	ret z			; $7b6c
	ld a,$81		; $7b6d
	ld ($cbca),a		; $7b6f
	ld ($cca4),a		; $7b72
	call interactionIncState		; $7b75
	call interactionSetAlwaysUpdateBit		; $7b78
	ld l,$50		; $7b7b
	ld (hl),$0a		; $7b7d
_label_0a_359:
	ld l,$46		; $7b7f
	ld (hl),$20		; $7b81
	jp objectSetVisible80		; $7b83
	call interactionDecCounter1		; $7b86
	jp nz,objectApplySpeed		; $7b89
	call interactionIncState		; $7b8c
	ld a,$05		; $7b8f
	ld c,$01		; $7b91
	call giveTreasure		; $7b93
	ld a,$4c		; $7b96
	call playSound		; $7b98
	ld bc,$001c		; $7b9b
	jp showText		; $7b9e
	ld a,($cba0)		; $7ba1
	or a			; $7ba4
	ret nz			; $7ba5
	call interactionIncState		; $7ba6
	call objectSetInvisible		; $7ba9
	ld e,$46		; $7bac
	ld a,$5a		; $7bae
	ld (de),a		; $7bb0
	call getFreeInteractionSlot		; $7bb1
	ret nz			; $7bb4
	ld (hl),$60		; $7bb5
	inc l			; $7bb7
	ld (hl),$05		; $7bb8
	inc l			; $7bba
	ld (hl),$03		; $7bbb
	ld a,($d00b)		; $7bbd
	ld l,$4b		; $7bc0
	ldi (hl),a		; $7bc2
	inc l			; $7bc3
	ld a,($d00d)		; $7bc4
	ld (hl),a		; $7bc7
	ld a,$fb		; $7bc8
	jp playSound		; $7bca
	call interactionDecCounter1		; $7bcd
	ret nz			; $7bd0
	call getThisRoomFlags		; $7bd1
	set 5,(hl)		; $7bd4
	ld hl,$7be4		; $7bd6
	call setWarpDestVariables		; $7bd9
	ld a,$b4		; $7bdc
	call playSound		; $7bde
	jp interactionDelete		; $7be1
	add b			; $7be4
	call nc,$5400		; $7be5
	add e			; $7be8
