; This code is included at the start of every enemy code bank (banks $0d-$10, inclusive). 
;
; Although the function names are the same in each bank, they won't cause conflicts
; because each bank is in its own namespace.

;;
; @addr{4000}
func_4000:
	ld h,d			; $4000
	ld l,$84		; $4001
	inc (hl)		; $4003
	ret			; $4004
	ld h,d			; $4005
	ld l,$85		; $4006
	inc (hl)		; $4008
	ret			; $4009
	xor a			; $400a
	ld e,$ac		; $400b
	call $420d		; $400d
_label_000:
	ld a,(de)		; $4010
	ld c,a			; $4011
	ld e,$ad		; $4012
	ld a,(de)		; $4014
	rlca			; $4015
	ld b,$50		; $4016
	jr nc,_label_001	; $4018
	ld b,$78		; $401a
	and $06			; $401c
	jr nz,_label_001	; $401e
	push bc			; $4020
	ld bc,$0f01		; $4021
	call objectCreateInteraction		; $4024
	pop bc			; $4027
_label_001:
	call $4161		; $4028
	ret nz			; $402b
	ld e,$ad		; $402c
	ld a,(de)		; $402e
	and $80			; $402f
	ld (de),a		; $4031
	ret			; $4032
	ld a,$02		; $4033
	ld e,$ac		; $4035
	call $420d		; $4037
	jr _label_000		; $403a
	call $400a		; $403c
	call $4043		; $403f
	ret			; $4042
	ldh (<hFF8F),a	; $4043
	xor a			; $4045
	ldh (<hFF8D),a	; $4046
	jr _label_002		; $4048
	call $400a		; $404a
	call $4051		; $404d
	ret			; $4050
	ldh (<hFF8F),a	; $4051
	ld a,$01		; $4053
	ldh (<hFF8D),a	; $4055
_label_002:
	ld e,$bf		; $4057
	ld a,(de)		; $4059
	and $07			; $405a
	jr nz,_label_005	; $405c
	ld e,$8f		; $405e
	ld a,(de)		; $4060
	rlca			; $4061
	jr c,_label_003	; $4062
	ld bc,$05ff		; $4064
	call objectGetRelativeTile		; $4067
	ld hl,hazardCollisionTable		; $406a
	call lookupCollisionTable		; $406d
	ld b,$ff		; $4070
	jr c,_label_004	; $4072
	ld bc,$0501		; $4074
	call objectGetRelativeTile		; $4077
	ld hl,hazardCollisionTable		; $407a
	call lookupCollisionTable		; $407d
	ld b,$01		; $4080
	jr c,_label_004	; $4082
	call $4123		; $4084
_label_003:
	ldh a,(<hFF8F)	; $4087
	or a			; $4089
	ret			; $408a
_label_004:
	ld h,d			; $408b
	ld l,$bf		; $408c
	ld e,l			; $408e
	or (hl)			; $408f
	ld (hl),a		; $4090
	ld l,$ab		; $4091
	ld (hl),$00		; $4093
	ld l,$ad		; $4095
	ld (hl),$00		; $4097
	ld l,$a4		; $4099
	res 7,(hl)		; $409b
	ld l,$86		; $409d
	ld (hl),$3c		; $409f
	inc l			; $40a1
	ldh a,(<hFF8D)	; $40a2
	ld (hl),a		; $40a4
	ld l,$8d		; $40a5
	ld a,(hl)		; $40a7
	add b			; $40a8
	ld (hl),a		; $40a9
_label_005:
	pop hl			; $40aa
	ld a,(de)		; $40ab
	rrca			; $40ac
	jr c,_label_006	; $40ad
	rrca			; $40af
	jr c,_label_011	; $40b0
	jr _label_007		; $40b2
	ret z			; $40b4
	ld b,b			; $40b5
	ret z			; $40b6
	ld b,b			; $40b7
	ret nz			; $40b8
	ld b,b			; $40b9
	ret z			; $40ba
	ld b,b			; $40bb
	ret z			; $40bc
	ld b,b			; $40bd
	ret nz			; $40be
	ld b,b			; $40bf
	ld d,h			; $40c0
	nop			; $40c1
	ld d,l			; $40c2
	ld ($1056),sp		; $40c3
	ld d,a			; $40c6
	jr _label_006		; $40c7
_label_006:
	ld b,$03		; $40c9
	jr _label_008		; $40cb
_label_007:
	ld b,$04		; $40cd
_label_008:
	call objectCreateInteractionWithSubid00		; $40cf
_label_009:
	call decNumEnemies		; $40d2
	jp enemyDelete		; $40d5
_label_010:
	call objectCreateFallingDownHoleInteraction		; $40d8
	jr _label_009		; $40db
_label_011:
	call $439a		; $40dd
	jr z,_label_010	; $40e0
	ld a,(hl)		; $40e2
	and $07			; $40e3
	jr nz,_label_012	; $40e5
	call $4108		; $40e7
	jr z,_label_010	; $40ea
	call objectGetRelativeAngleWithTempVars		; $40ec
	ld c,a			; $40ef
	ld b,$14		; $40f0
	call $4138		; $40f2
_label_012:
	ld h,d			; $40f5
	ld l,$87		; $40f6
	bit 0,(hl)		; $40f8
	ret z			; $40fa
	ld l,$a0		; $40fb
	ld a,(hl)		; $40fd
	sub $03			; $40fe
	jr nc,_label_013	; $4100
	xor a			; $4102
_label_013:
	inc a			; $4103
	ld (hl),a		; $4104
	jp enemyUpdateAnimCounter		; $4105
	ld l,$8b		; $4108
	ldi a,(hl)		; $410a
	ldh (<hFF8F),a	; $410b
	add $05			; $410d
	and $f0			; $410f
	add $08			; $4111
	ld b,a			; $4113
	inc l			; $4114
	ld a,(hl)		; $4115
	ldh (<hFF8E),a	; $4116
	and $f0			; $4118
	add $08			; $411a
	ld c,a			; $411c
	cp (hl)			; $411d
	ret nz			; $411e
	ldh a,(<hFF8F)	; $411f
	cp b			; $4121
	ret			; $4122
	ld e,$8f		; $4123
	ld a,(de)		; $4125
	rlca			; $4126
	ret c			; $4127
	ld bc,$0500		; $4128
	call objectGetRelativeTile		; $412b
	ld hl,$40b4		; $412e
	call lookupCollisionTable		; $4131
	ret nc			; $4134
	ld c,a			; $4135
	ld b,$14		; $4136
	ld hl,$425e		; $4138
	xor a			; $413b
	ldh (<hFF8A),a	; $413c
	push bc			; $413e
	ld a,c			; $413f
	call $4213		; $4140
	pop bc			; $4143
	jr _label_016		; $4144
	xor a			; $4146
	call $4204		; $4147
	jr _label_015		; $414a
	ld a,$01		; $414c
	call $4204		; $414e
	jr _label_015		; $4151
	xor a			; $4153
	jr _label_014		; $4154
	ld a,$01		; $4156
_label_014:
	call $420b		; $4158
_label_015:
	ld a,(de)		; $415b
	ld c,a			; $415c
	ld e,$90		; $415d
	ld a,(de)		; $415f
	ld b,a			; $4160
_label_016:
	ld a,c			; $4161
	ldh (<hFF8C),a	; $4162
	call getPositionOffsetForVelocity		; $4164
	xor a			; $4167
	ldh (<hFF8D),a	; $4168
	ld e,$8a		; $416a
	ldh a,(<hFF8B)	; $416c
	and $0c			; $416e
	jr nz,_label_017	; $4170
	call $41e1		; $4172
	jr _label_019		; $4175
_label_017:
	cp $0c			; $4177
	jr z,_label_019	; $4179
	bit 3,a			; $417b
	ldh a,(<hFF8C)	; $417d
	ld bc,$0060		; $417f
	jr nz,_label_018	; $4182
	xor $10			; $4184
	ld bc,$ffa0		; $4186
_label_018:
	cp $11			; $4189
	jr nc,_label_019	; $418b
	ld e,$8c		; $418d
	ld a,(de)		; $418f
	add c			; $4190
	ld (de),a		; $4191
	inc e			; $4192
	ld a,(de)		; $4193
	adc b			; $4194
	ld (de),a		; $4195
	ld e,$90		; $4196
	ld a,(de)		; $4198
	cp $32			; $4199
	jr nc,_label_019	; $419b
	ld a,$01		; $419d
	ldh (<hFF8D),a	; $419f
_label_019:
	ld e,$8c		; $41a1
	ld l,$c2		; $41a3
	ldh a,(<hFF8B)	; $41a5
	and $03			; $41a7
	jr nz,_label_020	; $41a9
	call $41e1		; $41ab
	jr _label_022		; $41ae
_label_020:
	cp $03			; $41b0
	jr z,_label_022	; $41b2
	rrca			; $41b4
	ldh a,(<hFF8C)	; $41b5
	ld bc,$0060		; $41b7
	jr nc,_label_021	; $41ba
	sub $10			; $41bc
	ld bc,$ffa0		; $41be
_label_021:
	add $08			; $41c1
	and $1f			; $41c3
	cp $11			; $41c5
	jr nc,_label_022	; $41c7
	ld e,$8a		; $41c9
	ld a,(de)		; $41cb
	add c			; $41cc
	ld (de),a		; $41cd
	inc e			; $41ce
	ld a,(de)		; $41cf
	adc b			; $41d0
	ld (de),a		; $41d1
	ld e,$90		; $41d2
	ld a,(de)		; $41d4
	cp $32			; $41d5
	jr nc,_label_022	; $41d7
	ld a,$01		; $41d9
	ldh (<hFF8D),a	; $41db
_label_022:
	ldh a,(<hFF8D)	; $41dd
	or a			; $41df
	ret			; $41e0
	ld a,(de)		; $41e1
	add (hl)		; $41e2
	ld (de),a		; $41e3
	ld b,(hl)		; $41e4
	inc l			; $41e5
	inc e			; $41e6
	ld a,(de)		; $41e7
	ld c,a			; $41e8
	adc (hl)		; $41e9
	ld (de),a		; $41ea
	sub c			; $41eb
	jr nz,_label_024	; $41ec
	ld c,$20		; $41ee
	ld e,$90		; $41f0
	ld a,(de)		; $41f2
	cp $32			; $41f3
	jr c,_label_023	; $41f5
	ld c,$60		; $41f7
_label_023:
	ld a,b			; $41f9
	cp c			; $41fa
	ret c			; $41fb
_label_024:
	ldh (<hFF8D),a	; $41fc
	ret			; $41fe
	ld hl,$429e		; $41ff
	jr _label_026		; $4202
	ld e,$89		; $4204
	ld hl,$429e		; $4206
	jr _label_025		; $4209
	ld e,$89		; $420b
	ld hl,$425e		; $420d
_label_025:
	ldh (<hFF8A),a	; $4210
	ld a,(de)		; $4212
_label_026:
	push de			; $4213
	call $4253		; $4214
	ld b,d			; $4217
	rst_addAToHl			; $4218
	ld d,h			; $4219
	ld e,l			; $421a
	ld h,b			; $421b
	ld l,$8b		; $421c
	ld b,(hl)		; $421e
	ld l,$8d		; $421f
	ld c,(hl)		; $4221
	ld a,$10		; $4222
	ldh (<hFF8B),a	; $4224
_label_027:
	call $4233		; $4226
	ldh a,(<hFF8B)	; $4229
	rla			; $422b
	ldh (<hFF8B),a	; $422c
	jr nc,_label_027	; $422e
	pop de			; $4230
	or a			; $4231
	ret			; $4232
	ld a,(de)		; $4233
	inc de			; $4234
	add b			; $4235
	ld b,a			; $4236
	ld a,(de)		; $4237
	inc de			; $4238
	add c			; $4239
	ld c,a			; $423a
	ldh a,(<hFF8A)	; $423b
	dec a			; $423d
	jp z,checkTileCollisionAt_disallowHoles		; $423e
	inc a			; $4241
	jr z,_label_028	; $4242
	call getTileCollisionsAtPosition		; $4244
	add $01			; $4247
	ret			; $4249
_label_028:
	call getTileCollisionsAtPosition		; $424a
	add $01			; $424d
	jp nc,checkTileCollisionAt_allowHoles		; $424f
	ret			; $4252
	rlca			; $4253
	ld b,a			; $4254
	and $0f			; $4255
	ld a,b			; $4257
	ret z			; $4258
	and $f0			; $4259
	add $08			; $425b
	ret			; $425d
.DB $fc				; $425e
	ei			; $425f
	nop			; $4260
	add hl,bc		; $4261
	inc b			; $4262
.DB $fc				; $4263
	nop			; $4264
	nop			; $4265
.DB $fc				; $4266
	ei			; $4267
	nop			; $4268
	add hl,bc		; $4269
	inc bc			; $426a
	ld (bc),a		; $426b
	ld b,$00		; $426c
	nop			; $426e
	nop			; $426f
	nop			; $4270
	nop			; $4271
	rst $38			; $4272
	ld b,$06		; $4273
	nop			; $4275
	rlca			; $4276
	ei			; $4277
	nop			; $4278
	add hl,bc		; $4279
	ld hl,sp+$02		; $427a
	ld b,$00		; $427c
	rlca			; $427e
	ei			; $427f
	nop			; $4280
	add hl,bc		; $4281
	ld sp,hl		; $4282
.DB $fc				; $4283
	nop			; $4284
	nop			; $4285
	rlca			; $4286
	ei			; $4287
	nop			; $4288
	add hl,bc		; $4289
	ld hl,sp-$0b		; $428a
	ld b,$00		; $428c
	nop			; $428e
	nop			; $428f
	nop			; $4290
	nop			; $4291
	rst $38			; $4292
	ld sp,hl		; $4293
	ld b,$00		; $4294
.DB $fc				; $4296
	ei			; $4297
	nop			; $4298
	add hl,bc		; $4299
	inc bc			; $429a
	push af			; $429b
	ld b,$00		; $429c
	rst $30			; $429e
	ld a,($0b00)		; $429f
	add hl,bc		; $42a2
	ei			; $42a3
	nop			; $42a4
	nop			; $42a5
	rst $30			; $42a6
.DB $fc				; $42a7
	nop			; $42a8
	ld a,(bc)		; $42a9
	ld (bc),a		; $42aa
	ld (bc),a		; $42ab
	ld a,(bc)		; $42ac
	nop			; $42ad
	nop			; $42ae
	nop			; $42af
	nop			; $42b0
	nop			; $42b1
	ld a,($0b08)		; $42b2
	nop			; $42b5
	ld ($00fc),sp		; $42b6
	ld a,(bc)		; $42b9
.DB $f4				; $42ba
	ld (bc),a		; $42bb
	ld a,(bc)		; $42bc
	nop			; $42bd
	ld ($00fa),sp		; $42be
	dec bc			; $42c1
	ld hl,sp-$05		; $42c2
	nop			; $42c4
	nop			; $42c5
	ld ($00f9),sp		; $42c6
	ld a,(bc)		; $42c9
.DB $f4				; $42ca
.DB $f4				; $42cb
	ld a,(bc)		; $42cc
	nop			; $42cd
	nop			; $42ce
	nop			; $42cf
	nop			; $42d0
	nop			; $42d1
	ld a,($0bf7)		; $42d2
	nop			; $42d5
	rst $30			; $42d6
	ld sp,hl		; $42d7
	nop			; $42d8
	ld a,(bc)		; $42d9
	ld (bc),a		; $42da
.DB $f4				; $42db
	ld a,(bc)		; $42dc
	nop			; $42dd
	ld a,$01		; $42de
	jr _label_029		; $42e0
	xor a			; $42e2
	jr _label_029		; $42e3
	ld a,$02		; $42e5
_label_029:
	call $420b		; $42e7
	call $4310		; $42ea
	ld a,c			; $42ed
	or a			; $42ee
	ret z			; $42ef
	cp $05			; $42f0
	jr z,_label_031	; $42f2
	ld hl,$432f		; $42f4
	bit 0,a			; $42f7
	jr nz,_label_030	; $42f9
	ld hl,$431f		; $42fb
_label_030:
	ld e,$89		; $42fe
	ld a,(de)		; $4300
	rst_addAToHl			; $4301
	ld a,(hl)		; $4302
	ld (de),a		; $4303
	or d			; $4304
	ret			; $4305
_label_031:
	ld e,$89		; $4306
	ld a,(de)		; $4308
	add $10			; $4309
	and $1f			; $430b
	ld (de),a		; $430d
	or d			; $430e
	ret			; $430f
	ld c,$00		; $4310
	ld b,a			; $4312
	and $03			; $4313
	jr z,_label_032	; $4315
	inc c			; $4317
_label_032:
	ld a,b			; $4318
	and $0c			; $4319
	ret z			; $431b
	set 2,c			; $431c
	ret			; $431e
	stop			; $431f
	rrca			; $4320
	ld c,$0d		; $4321
	inc c			; $4323
	dec bc			; $4324
	ld a,(bc)		; $4325
	add hl,bc		; $4326
	ld ($0607),sp		; $4327
	dec b			; $432a
	inc b			; $432b
	inc bc			; $432c
	ld (bc),a		; $432d
	ld bc,$1f00		; $432e
	ld e,$1d		; $4331
	inc e			; $4333
	dec de			; $4334
	ld a,(de)		; $4335
	add hl,de		; $4336
	jr $17			; $4337
	ld d,$15		; $4339
	inc d			; $433b
	inc de			; $433c
	ld (de),a		; $433d
	ld de,$0f10		; $433e
	ld c,$0d		; $4341
	inc c			; $4343
	dec bc			; $4344
	add hl,bc		; $4345
	ld ($0708),sp		; $4346
	ld b,$05		; $4349
	inc b			; $434b
	inc bc			; $434c
	ld (bc),a		; $434d
.db $01 $c5

	call getRandomNumber_noPreserveVars		; $4350
	pop bc			; $4353
	and e			; $4354
	ld e,a			; $4355
	ld a,h			; $4356
	and b			; $4357
	ld b,a			; $4358
	ld a,l			; $4359
	and c			; $435a
	ld c,a			; $435b
	xor a			; $435c
	ret			; $435d
	call $4364		; $435e
	jp objectSetVisiblec2		; $4361
	ld h,d			; $4364
	ld l,$90		; $4365
	ld (hl),a		; $4367
	ld l,$84		; $4368
	ld (hl),$08		; $436a
	ret			; $436c
	call getFreeEnemySlot_uncounted		; $436d
	ret nz			; $4370
	jr _label_033		; $4371
	call getFreeEnemySlot		; $4373
	ret nz			; $4376
_label_033:
	ld (hl),b		; $4377
	inc l			; $4378
	inc (hl)		; $4379
	xor a			; $437a
	ret			; $437b
	call getFreePartSlot		; $437c
	ret nz			; $437f
	ld (hl),b		; $4380
	call objectCopyPosition		; $4381
	ld l,$d6		; $4384
	ld a,$80		; $4386
	ldi (hl),a		; $4388
	ld (hl),d		; $4389
	ld e,$98		; $438a
	ld a,$c0		; $438c
	ld (de),a		; $438e
	inc e			; $438f
	ld a,h			; $4390
	ld (de),a		; $4391
	ld e,$89		; $4392
	ld l,$c9		; $4394
	ld a,(de)		; $4396
	ldi (hl),a		; $4397
	xor a			; $4398
	ret			; $4399
	ld h,d			; $439a
	ld l,$86		; $439b
	dec (hl)		; $439d
	ret			; $439e
	call $439a		; $439f
	ret nz			; $43a2
	ld h,d			; $43a3
	ld l,$87		; $43a4
	ld a,(hl)		; $43a6
	or a			; $43a7
	ret z			; $43a8
	dec (hl)		; $43a9
	ret			; $43aa
	call objectGetAngleTowardEnemyTarget		; $43ab
	xor $10			; $43ae
	ld e,$89		; $43b0
	ld (de),a		; $43b2
	ret			; $43b3
	call objectGetAngleTowardEnemyTarget		; $43b4
	add $04			; $43b7
	and $18			; $43b9
	ld e,$89		; $43bb
	ld (de),a		; $43bd
	ret			; $43be
	call objectGetAngleTowardEnemyTarget		; $43bf
	ld e,$89		; $43c2
	ld (de),a		; $43c4
	ret			; $43c5
	call getRandomNumber_noPreserveVars		; $43c6
	and $18			; $43c9
	ld e,$89		; $43cb
	ld (de),a		; $43cd
	ret			; $43ce
	call getRandomNumber_noPreserveVars		; $43cf
	and $1f			; $43d2
	ld e,$89		; $43d4
	ld (de),a		; $43d6
	ret			; $43d7
	ld h,d			; $43d8
	ld l,$89		; $43d9
	ldd a,(hl)		; $43db
	ld e,a			; $43dc
	ld bc,$43ff		; $43dd
	call addAToBc		; $43e0
	ld a,(bc)		; $43e3
	cp $04			; $43e4
	jr c,_label_034	; $43e6
	sub (hl)		; $43e8
	cp $07			; $43e9
	ret z			; $43eb
	sub $03			; $43ec
	cp $02			; $43ee
	ret c			; $43f0
	ld a,e			; $43f1
	add $04			; $43f2
	and $18			; $43f4
	swap a			; $43f6
	rlca			; $43f8
_label_034:
	cp (hl)			; $43f9
	ret z			; $43fa
	ld (hl),a		; $43fb
	jp enemySetAnimation		; $43fc
	nop			; $43ff
	nop			; $4400
	nop			; $4401
	inc b			; $4402
	inc b			; $4403
	inc b			; $4404
	ld bc,$0101		; $4405
	ld bc,$0501		; $4408
	dec b			; $440b
	dec b			; $440c
	ld (bc),a		; $440d
	ld (bc),a		; $440e
	ld (bc),a		; $440f
	ld (bc),a		; $4410
	ld (bc),a		; $4411
	ld b,$06		; $4412
	ld b,$03		; $4414
	inc bc			; $4416
	inc bc			; $4417
	inc bc			; $4418
	inc bc			; $4419
	rlca			; $441a
	rlca			; $441b
	rlca			; $441c
	nop			; $441d
	nop			; $441e
	ld e,$9a		; $441f
	ld a,(de)		; $4421
	xor $80			; $4422
	ld (de),a		; $4424
	ret			; $4425
	ld e,$82		; $4426
	ld a,(de)		; $4428
	ld b,a			; $4429
	ld e,$84		; $442a
	ld a,(de)		; $442c
	cp $08			; $442d
	ret			; $442f
	call objectGetRelativeAngleWithTempVars		; $4430
	ld e,$89		; $4433
	ld (de),a		; $4435
	jp objectApplySpeed		; $4436
	ld b,(hl)		; $4439
	inc l			; $443a
	ld c,(hl)		; $443b
	ld l,$8b		; $443c
	ldi a,(hl)		; $443e
	ldh (<hFF8F),a	; $443f
	inc l			; $4441
	ld a,(hl)		; $4442
	ldh (<hFF8E),a	; $4443
	ret			; $4445
	ld h,d			; $4446
	ld l,$8b		; $4447
	ld a,(hl)		; $4449
	add c			; $444a
	cpl			; $444b
	inc a			; $444c
	ld c,a			; $444d
	ldh a,(<hCameraY)	; $444e
	add c			; $4450
	jr nc,_label_035	; $4451
	ld a,c			; $4453
_label_035:
	bit 7,a			; $4454
	jr nz,_label_036	; $4456
	ld a,$80		; $4458
_label_036:
	ld l,$8f		; $445a
	ld (hl),a		; $445c
	ret			; $445d
	ld a,l			; $445e
	and $c0			; $445f
	or $29			; $4461
	ld l,a			; $4463
_label_037:
	ld (hl),$00		; $4464
	ld a,l			; $4466
	add $fb			; $4467
	ld l,a			; $4469
	res 7,(hl)		; $446a
	ret			; $446c
	ld a,$29		; $446d
	call objectGetRelatedObject1Var		; $446f
	jr _label_037		; $4472
	ld a,$29		; $4474
	call objectGetRelatedObject2Var		; $4476
	jr _label_037		; $4479
	call $43a3		; $447b
	jr z,_label_038	; $447e
	ld a,(hl)		; $4480
	and $03			; $4481
	ld hl,$44a8		; $4483
	rst_addAToHl			; $4486
	ld e,$8d		; $4487
	ld a,(de)		; $4489
	add (hl)		; $448a
	ld (de),a		; $448b
	scf			; $448c
	ret			; $448d
_label_038:
	call objectApplySpeed		; $448e
	ld c,$10		; $4491
	call objectUpdateSpeedZ_paramC		; $4493
	ldh a,(<hCameraY)	; $4496
	ld b,a			; $4498
	ld l,$8f		; $4499
	ld a,(hl)		; $449b
	cp $80			; $449c
	ccf			; $449e
	ret nc			; $449f
	ld e,$8b		; $44a0
	ld a,(de)		; $44a2
	add (hl)		; $44a3
	sub b			; $44a4
	cp $b0			; $44a5
	ret			; $44a7
	cp $02			; $44a8
	ld (bc),a		; $44aa
	cp $cd			; $44ab
	ld a,e			; $44ad
	ld b,h			; $44ae
	ret c			; $44af
	call decNumEnemies		; $44b0
	jp enemyDelete		; $44b3
	ld a,($ccd9)		; $44b6
	or a			; $44b9
	ret z			; $44ba
	ld e,$bf		; $44bb
	ld a,(de)		; $44bd
	bit 4,a			; $44be
	ret z			; $44c0
	ld e,$84		; $44c1
	ld a,(de)		; $44c3
	and $f8			; $44c4
	ret z			; $44c6
	ld a,$04		; $44c7
	ld (de),a		; $44c9
	ret			; $44ca
	ld h,d			; $44cb
	ld l,$bd		; $44cc
	dec (hl)		; $44ce
	ld a,(hl)		; $44cf
	and $0f			; $44d0
	ret nz			; $44d2
	ldh a,(<hFFB2)	; $44d3
	ld b,a			; $44d5
	ldh a,(<hFFB3)	; $44d6
	ld c,a			; $44d8
	call objectGetRelativeAngle		; $44d9
	ld e,$89		; $44dc
	ld (de),a		; $44de
	ret			; $44df
	ld b,$08		; $44e0
	ld c,$20		; $44e2
	call objectUpdateSpeedZ_paramC		; $44e4
	ret nz			; $44e7
	ld l,$a4		; $44e8
	set 7,(hl)		; $44ea
	ld l,$84		; $44ec
	ld (hl),b		; $44ee
	ret			; $44ef
