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
	ld e,$44		; $4000
	ld a,(de)		; $4002
	rst_jumpTable			; $4003
	ld ($5140),sp		; $4004
	ld b,b			; $4007
	ld a,$01		; $4008
	ld (de),a		; $400a
	call interactionInitGraphics		; $400b
	ld h,d			; $400e
	ld l,$50		; $400f
	ld (hl),$14		; $4011
	ld l,$42		; $4013
	bit 1,(hl)		; $4015
	call z,interactionSetAlwaysUpdateBit		; $4017
	call $407e		; $401a
	ld e,$41		; $401d
	ld a,(de)		; $401f
	ld hl,$4037		; $4020
	rst_addDoubleIndex			; $4023
	ld e,$42		; $4024
	ld a,(de)		; $4026
	rlca			; $4027
	ldi a,(hl)		; $4028
	ld e,(hl)		; $4029
	call nc,playSound		; $402a
	ld a,e			; $402d
	rst_jumpTable			; $402e
	dec d			; $402f
	ld e,$1e		; $4030
	ld e,$27		; $4032
	ld e,$30		; $4034
	ld e,$6d		; $4036
	inc bc			; $4038
	ld l,l			; $4039
	inc bc			; $403a
	nop			; $403b
	nop			; $403c
	add a			; $403d
	inc bc			; $403e
	add a			; $403f
	inc bc			; $4040
	sbc b			; $4041
	nop			; $4042
	and l			; $4043
	nop			; $4044
	ld d,b			; $4045
	nop			; $4046
	ld (hl),e		; $4047
	nop			; $4048
	nop			; $4049
	inc bc			; $404a
	nop			; $404b
	inc bc			; $404c
	ld (hl),l		; $404d
	ld (bc),a		; $404e
	and l			; $404f
	nop			; $4050
	ld h,d			; $4051
	ld l,$61		; $4052
	bit 7,(hl)		; $4054
	jp nz,interactionDelete		; $4056
	ld l,$42		; $4059
	bit 0,(hl)		; $405b
	jr z,_label_08_000	; $405d
	ld a,(wFrameCounter)		; $405f
	xor d			; $4062
	rrca			; $4063
	ld l,$5a		; $4064
	set 7,(hl)		; $4066
	jr nc,_label_08_000	; $4068
	res 7,(hl)		; $406a
_label_08_000:
	ld e,$41		; $406c
	ld a,(de)		; $406e
	cp $0a			; $406f
	jr nz,_label_08_001	; $4071
	ld c,$60		; $4073
	call objectUpdateSpeedZ_paramC		; $4075
	call objectApplySpeed		; $4078
_label_08_001:
	jp interactionAnimate		; $407b
	ld e,$41		; $407e
	ld a,(de)		; $4080
	or a			; $4081
	jr z,_label_08_002	; $4082
	cp $0a			; $4084
	ret nz			; $4086
	ld bc,$fdc0		; $4087
	call objectSetSpeedZ		; $408a
	ld e,$48		; $408d
	ld a,(de)		; $408f
	jp interactionSetAnimation		; $4090
_label_08_002:
	ld a,($cc52)		; $4093
	and $03			; $4096
	or $08			; $4098
	ld e,$5b		; $409a
	ld (de),a		; $409c
	inc e			; $409d
	ld (de),a		; $409e
	ret			; $409f

interactionCode0f:
	ld e,$44		; $40a0
	ld a,(de)		; $40a2
	rst_jumpTable			; $40a3
	xor d			; $40a4
	ld b,b			; $40a5
	ret nc			; $40a6
	ld b,b			; $40a7
	nop			; $40a8
	ld b,c			; $40a9
	call interactionInitGraphics		; $40aa
	call interactionSetAlwaysUpdateBit		; $40ad
	call interactionIncState		; $40b0
	ld e,$42		; $40b3
	ld a,(de)		; $40b5
	add (hl)		; $40b6
	ld (hl),a		; $40b7
	ld l,$50		; $40b8
	ld (hl),$0f		; $40ba
	dec a			; $40bc
	jr z,_label_08_003	; $40bd
	call interactionSetAnimation		; $40bf
	jp objectSetVisible80		; $40c2
_label_08_003:
	inc e			; $40c5
	ld a,(de)		; $40c6
	rlca			; $40c7
	ld a,$59		; $40c8
	call nc,playSound		; $40ca
	jp objectSetVisible83		; $40cd
	ld h,d			; $40d0
	ld l,$61		; $40d1
	bit 7,(hl)		; $40d3
	jr nz,_label_08_006	; $40d5
	ld l,$4b		; $40d7
	ldi a,(hl)		; $40d9
	ldh (<hFF8F),a	; $40da
	add $05			; $40dc
	and $f0			; $40de
	add $08			; $40e0
	ld b,a			; $40e2
	inc l			; $40e3
	ld a,(hl)		; $40e4
	ldh (<hFF8E),a	; $40e5
	and $f0			; $40e7
	add $08			; $40e9
	ld c,a			; $40eb
	cp (hl)			; $40ec
	jr nz,_label_08_004	; $40ed
	ldh a,(<hFF8F)	; $40ef
	cp b			; $40f1
	jr z,_label_08_005	; $40f2
_label_08_004:
	call objectGetRelativeAngleWithTempVars		; $40f4
	ld e,$49		; $40f7
	ld (de),a		; $40f9
	call objectApplySpeed		; $40fa
_label_08_005:
	jp interactionAnimate		; $40fd
	ld h,d			; $4100
	ld l,$5a		; $4101
	ld a,(hl)		; $4103
	xor $80			; $4104
	ld (hl),a		; $4106
	ld l,$61		; $4107
	bit 7,(hl)		; $4109
	jr z,_label_08_005	; $410b
_label_08_006:
	jp interactionDelete		; $410d

interactionCode10:
	ld e,$44		; $4110
	ld a,(de)		; $4112
	rst_jumpTable			; $4113
	jr _label_08_007		; $4114
	dec sp			; $4116
	ld b,c			; $4117
	ld a,$01		; $4118
	ld (de),a		; $411a
	call interactionInitGraphics		; $411b
	ld a,$55		; $411e
	call interactionSetHighTextIndex		; $4120
	ld hl,$45de		; $4123
	call interactionSetScript		; $4126
	ld a,$2c		; $4129
	call unsetGlobalFlag		; $412b
	ld a,$08		; $412e
	ld ($cbae),a		; $4130
	ld a,$02		; $4133
	ld ($cbac),a		; $4135
	jp objectSetVisible82		; $4138
	ld bc,$1406		; $413b
	call objectSetCollideRadii		; $413e
	call interactionRunScript		; $4141
	jp interactionAnimate		; $4144

interactionCode11:
	jpab bank3f.interactionCode11_body

interactionCode12:
	ld e,$42		; $414f
	ld a,(de)		; $4151
	rst_jumpTable			; $4152
	ld e,a			; $4153
	ld b,c			; $4154
	cp (hl)			; $4155
	ld b,c			; $4156
_label_08_007:
	reti			; $4157
	ld b,c			; $4158
	di			; $4159
	ld b,c			; $415a
	inc bc			; $415b
	ld b,d			; $415c
	ld c,e			; $415d
	ld b,d			; $415e
	call checkInteractionState		; $415f
	jr nz,_label_08_009	; $4162
	ld a,($cd00)		; $4164
	and $02			; $4167
	jp z,interactionDelete		; $4169
	ld a,($d00b)		; $416c
	cp $78			; $416f
	jp c,interactionDelete		; $4171
	call interactionIncState		; $4174
	ld a,$08		; $4177
	call objectSetCollideRadius		; $4179
	call initializeDungeonStuff		; $417c
	ld a,($cc55)		; $417f
	cp $07			; $4182
	jr nz,_label_08_008	; $4184
	ld a,$05		; $4186
	ld ($cc31),a		; $4188
_label_08_008:
	ld a,($cc55)		; $418b
	cp $08			; $418e
	jr nz,_label_08_009	; $4190
	ld a,$01		; $4192
	ld ($cc33),a		; $4194
_label_08_009:
	call objectCheckCollidedWithLink_notDead		; $4197
	ret nc			; $419a
	ld a,($cc55)		; $419b
	ld hl,$41ae		; $419e
	rst_addAToHl			; $41a1
	ld c,(hl)		; $41a2
	ld b,$02		; $41a3
	call showText		; $41a5
	call setDeathRespawnPoint		; $41a8
	jp interactionDelete		; $41ab
	nop			; $41ae
	ld bc,$0302		; $41af
	inc b			; $41b2
	dec b			; $41b3
	ld b,$07		; $41b4
	ld ($0a09),sp		; $41b6
	nop			; $41b9
	nop			; $41ba
	nop			; $41bb
	nop			; $41bc
	nop			; $41bd
	call returnIfScrollMode01Unset		; $41be
	ld e,$44		; $41c1
	ld a,(de)		; $41c3
	rst_jumpTable			; $41c4
	ret			; $41c5
	ld b,c			; $41c6
	jp nc,$3e41		; $41c7
	ld bc,$2112		; $41ca
	ld l,h			; $41cd
	ld b,(hl)		; $41ce
	call interactionSetScript		; $41cf
_label_08_010:
	call interactionRunScript		; $41d2
	jp c,interactionDelete		; $41d5
	ret			; $41d8
	ld e,$44		; $41d9
	ld a,(de)		; $41db
	rst_jumpTable			; $41dc
.DB $e3				; $41dd
	ld b,c			; $41de
	jp nc,$ee41		; $41df
	ld b,c			; $41e2
	ld a,$01		; $41e3
	ld (de),a		; $41e5
	ld hl,$4672		; $41e6
	call interactionSetScript		; $41e9
	jr _label_08_010		; $41ec
	call objectPreventLinkFromPassing		; $41ee
	jr _label_08_010		; $41f1
	call checkInteractionState		; $41f3
	jr nz,_label_08_010	; $41f6
	ld a,$01		; $41f8
	ld (de),a		; $41fa
	ld hl,$4680		; $41fb
	call interactionSetScript		; $41fe
	jr _label_08_010		; $4201
	call returnIfScrollMode01Unset		; $4203
	call getThisRoomFlags		; $4206
	bit 7,a			; $4209
	jp nz,interactionDelete		; $420b
	ld a,($cc30)		; $420e
	or a			; $4211
	ret nz			; $4212
	ld a,$4d		; $4213
	call playSound		; $4215
	call getThisRoomFlags		; $4218
	set 7,(hl)		; $421b
	ld bc,$cfaf		; $421d
_label_08_011:
	ld a,(bc)		; $4220
	sub $40			; $4221
	cp $04			; $4223
	call c,$422c		; $4225
	dec c			; $4228
	jr nz,_label_08_011	; $4229
	ret			; $422b
	push bc			; $422c
	push hl			; $422d
	ld hl,$423c		; $422e
	rst_addAToHl			; $4231
	ld a,(hl)		; $4232
	call setTile		; $4233
	call $4240		; $4236
	pop hl			; $4239
	pop bc			; $423a
	ret			; $423b
	ld b,(hl)		; $423c
	ld b,a			; $423d
	ld b,h			; $423e
	ld b,l			; $423f
	call getFreeInteractionSlot		; $4240
	ret nz			; $4243
	ld (hl),$05		; $4244
	ld l,$4b		; $4246
	jp setShortPosition_paramC		; $4248
	ld e,$44		; $424b
	ld a,(de)		; $424d
	rst_jumpTable			; $424e
	ld d,l			; $424f
	ld b,d			; $4250
	ld e,(hl)		; $4251
	ld b,d			; $4252
	ld a,e			; $4253
	ld b,d			; $4254
	ld a,$01		; $4255
	ld (de),a		; $4257
	call interactionInitGraphics		; $4258
	call objectSetVisible82		; $425b
	ld hl,$dd00		; $425e
	ld a,(hl)		; $4261
	or a			; $4262
	ret nz			; $4263
	ld (hl),$01		; $4264
	inc l			; $4266
	ld (hl),$29		; $4267
	call objectCopyPosition		; $4269
	ld e,$56		; $426c
	ld l,$16		; $426e
	ld a,(de)		; $4270
	ldi (hl),a		; $4271
	inc e			; $4272
	ld a,(de)		; $4273
	ld (hl),a		; $4274
	ld e,$44		; $4275
	ld a,$02		; $4277
	ld (de),a		; $4279
	ret			; $427a
	jp interactionDelete		; $427b

interactionCode13:
	call interactionDeleteAndRetIfEnabled02		; $427e
	call returnIfScrollMode01Unset		; $4281
	ld e,$44		; $4284
	ld a,(de)		; $4286
	rst_jumpTable			; $4287
	sub b			; $4288
	ld b,d			; $4289
	xor c			; $428a
	ld b,d			; $428b
	pop bc			; $428c
	ld b,d			; $428d
	sub $42			; $428e
	ld h,d			; $4290
	ld l,$44		; $4291
	ld (hl),$01		; $4293
	call objectGetShortPosition		; $4295
	ld l,$58		; $4298
	ld (hl),a		; $429a
	ld c,a			; $429b
	ld b,$cf		; $429c
	ld a,(bc)		; $429e
	inc l			; $429f
	ld (hl),a		; $42a0
	ld a,$1d		; $42a1
	ld (bc),a		; $42a3
	ld hl,$cc30		; $42a4
	inc (hl)		; $42a7
	ret			; $42a8
	ld a,($cc30)		; $42a9
	ld b,a			; $42ac
	ld e,$42		; $42ad
	ld a,(de)		; $42af
	cp b			; $42b0
	ret c			; $42b1
	ld e,$44		; $42b2
	ld a,$02		; $42b4
	ld (de),a		; $42b6
	ld e,$58		; $42b7
	ld a,(de)		; $42b9
	ld c,a			; $42ba
	inc e			; $42bb
	ld a,(de)		; $42bc
	ld b,$cf		; $42bd
	ld (bc),a		; $42bf
	ret			; $42c0
	ld e,$58		; $42c1
	ld a,(de)		; $42c3
	ld l,a			; $42c4
	inc e			; $42c5
	ld a,(de)		; $42c6
	ld h,$cf		; $42c7
	cp (hl)			; $42c9
	ret z			; $42ca
	ld e,$44		; $42cb
	ld a,$03		; $42cd
	ld (de),a		; $42cf
	ld e,$46		; $42d0
	ld a,$1e		; $42d2
	ld (de),a		; $42d4
	ret			; $42d5
	call interactionDecCounter1		; $42d6
	ret nz			; $42d9
	xor a			; $42da
	ld ($cc30),a		; $42db
	jp interactionDelete		; $42de

interactionCode14:
	ld e,$44		; $42e1
	ld a,(de)		; $42e3
	rst_jumpTable			; $42e4
.DB $eb				; $42e5
	ld b,d			; $42e6
	scf			; $42e7
	ld b,e			; $42e8
	ld (hl),c		; $42e9
	ld b,e			; $42ea
	ld a,$01		; $42eb
	ld (de),a		; $42ed
	call interactionInitGraphics		; $42ee
	ld e,$70		; $42f1
	ld a,(de)		; $42f3
	ld c,a			; $42f4
	ld b,$cf		; $42f5
	ld a,(bc)		; $42f7
	ld e,$71		; $42f8
	ld (de),a		; $42fa
	call objectMimicBgTile		; $42fb
	ld a,$06		; $42fe
	call objectSetCollideRadius		; $4300
	call $43d2		; $4303
	ld h,d			; $4306
	ld l,$74		; $4307
	ld a,(hl)		; $4309
	and $02			; $430a
	jr z,_label_08_012	; $430c
	ld e,$44		; $430e
	ld a,$02		; $4310
	ld (de),a		; $4312
_label_08_012:
	bit 2,(hl)		; $4313
	ld a,$01		; $4315
	call nz,interactionSetAnimation		; $4317
	ld h,d			; $431a
	ld bc,$1420		; $431b
	ld l,$50		; $431e
	ld (hl),b		; $4320
	ld l,$46		; $4321
	ld (hl),c		; $4323
	ld l,$49		; $4324
	ld a,(hl)		; $4326
	or $80			; $4327
	ld ($ccc0),a		; $4329
	call $43c2		; $432c
	call objectSetVisible82		; $432f
	ld a,$71		; $4332
	call playSound		; $4334
	call $43aa		; $4337
	call objectApplySpeed		; $433a
	call objectPreventLinkFromPassing		; $433d
	call interactionDecCounter1		; $4340
	ret nz			; $4343
_label_08_013:
	call objectReplaceWithAnimationIfOnHazard		; $4344
	jp c,interactionDelete		; $4347
	call objectGetShortPosition		; $434a
	ld e,$70		; $434d
	ld (de),a		; $434f
	ld e,$73		; $4350
	ld a,(de)		; $4352
	or a			; $4353
	jr z,_label_08_014	; $4354
	ld b,a			; $4356
	ld e,$70		; $4357
	ld a,(de)		; $4359
	ld c,a			; $435a
	ld a,b			; $435b
	call setTile		; $435c
_label_08_014:
	ld e,$74		; $435f
	ld a,(de)		; $4361
	rlca			; $4362
	jr nc,_label_08_015	; $4363
	xor a			; $4365
	ld ($cca4),a		; $4366
	ld a,$4d		; $4369
	call playSound		; $436b
_label_08_015:
	jp interactionDelete		; $436e
	call $43aa		; $4371
	ld e,$50		; $4374
	ld a,$46		; $4376
	ld (de),a		; $4378
	call objectApplySpeed		; $4379
	call objectPreventLinkFromPassing		; $437c
	call $438a		; $437f
	ret z			; $4382
	ld a,$50		; $4383
	call playSound		; $4385
	jr _label_08_013		; $4388
	ld e,$49		; $438a
	ld a,(de)		; $438c
	call convertAngleDeToDirection		; $438d
	ld hl,$43a2		; $4390
	rst_addDoubleIndex			; $4393
	ld e,$4b		; $4394
	ld a,(de)		; $4396
	add (hl)		; $4397
	ld b,a			; $4398
	inc hl			; $4399
	ld e,$4d		; $439a
	ld a,(de)		; $439c
	add (hl)		; $439d
	ld c,a			; $439e
	jp getTileCollisionsAtPosition		; $439f
	ld hl,sp+$00		; $43a2
	nop			; $43a4
	ld ($0008),sp		; $43a5
	nop			; $43a8
	ld hl,sp-$06		; $43a9
	ld d,b			; $43ab
	call z,$18e6		; $43ac
	ret z			; $43af
	call objectGetShortPosition		; $43b0
	ld c,a			; $43b3
	ld b,$cf		; $43b4
	ld a,(bc)		; $43b6
	cp $0c			; $43b7
	ld a,$fe		; $43b9
	jr z,_label_08_016	; $43bb
	xor a			; $43bd
_label_08_016:
	ld e,$4f		; $43be
	ld (de),a		; $43c0
	ret			; $43c1
	ld e,$70		; $43c2
	ld a,(de)		; $43c4
	ld c,a			; $43c5
	call getTileIndexFromRoomLayoutBuffer_paramC		; $43c6
	jp nc,setTile		; $43c9
	ld e,$72		; $43cc
	ld a,(de)		; $43ce
	jp setTile		; $43cf
	ld a,($cc49)		; $43d2
	ld hl,$43f5		; $43d5
	rst_addAToHl			; $43d8
	ld a,(hl)		; $43d9
	rst_addAToHl			; $43da
	ld e,$71		; $43db
	ld a,(de)		; $43dd
	ld b,a			; $43de
_label_08_017:
	ldi a,(hl)		; $43df
	or a			; $43e0
	ret z			; $43e1
	cp b			; $43e2
	jr z,_label_08_018	; $43e3
	inc hl			; $43e5
	inc hl			; $43e6
	inc hl			; $43e7
	jr _label_08_017		; $43e8
_label_08_018:
	ld (de),a		; $43ea
	ldi a,(hl)		; $43eb
	inc e			; $43ec
	ld (de),a		; $43ed
	ldi a,(hl)		; $43ee
	inc e			; $43ef
	ld (de),a		; $43f0
	ldi a,(hl)		; $43f1
	inc e			; $43f2
	ld (de),a		; $43f3
	ret			; $43f4
	ld ($0a07),sp		; $43f5
	ld a,(bc)		; $43f8
	add hl,bc		; $43f9
	ld ($3e3f),sp		; $43fa
	sub $04			; $43fd
	sbc h			; $43ff
	ld bc,$1800		; $4400
	and b			; $4403
	dec e			; $4404
	ld bc,$a019		; $4405
	dec e			; $4408
	ld bc,$a01a		; $4409
	dec e			; $440c
	ld bc,$a01b		; $440d
	dec e			; $4410
	ld bc,$a01c		; $4411
	dec e			; $4414
	ld bc,$a02a		; $4415
	ldi a,(hl)		; $4418
	ld bc,$a02c		; $4419
	inc l			; $441c
	ld bc,$a02d		; $441d
	dec l			; $4420
	ld bc,$a010		; $4421
	stop			; $4424
	ld bc,$a011		; $4425
	stop			; $4428
	ld bc,$a012		; $4429
	stop			; $442c
	ld bc,$0d13		; $442d
	stop			; $4430
	ld bc,$a025		; $4431
	dec h			; $4434
	ld bc,$8c2f		; $4435
	cpl			; $4438
	ld (bc),a		; $4439
	nop			; $443a

interactionCode16:
	ld e,$44		; $443b
	ld a,(de)		; $443d
	rst_jumpTable			; $443e
	ld b,a			; $443f
	ld b,h			; $4440
	halt			; $4441
	ld b,h			; $4442
	cp a			; $4443
	ld b,h			; $4444
	reti			; $4445
	ldd a,(hl)		; $4446
	ld a,$01		; $4447
	ld (de),a		; $4449
	call interactionInitGraphics		; $444a
	ld a,$06		; $444d
	call objectSetCollideRadius		; $444f
	ld l,$46		; $4452
	ld (hl),$04		; $4454
	ld a,$5f		; $4456
	call objectGetRelativePositionOfTile		; $4458
	ld h,d			; $445b
	ld l,$48		; $445c
	xor $02			; $445e
	ldi (hl),a		; $4460
	swap a			; $4461
	rrca			; $4463
	ldd (hl),a		; $4464
	ld a,(hl)		; $4465
	and $01			; $4466
	call interactionSetAnimation		; $4468
	call objectDeleteRelatedObj1AsStaticObject		; $446b
	call findFreeStaticObjectSlot		; $446e
	ld a,$03		; $4471
	call z,objectSaveAsStaticObject		; $4473
	call objectSetPriorityRelativeToLink		; $4476
	ld a,($cc77)		; $4479
	add a			; $447c
	jr c,_label_08_019	; $447d
	call objectPreventLinkFromPassing		; $447f
	ret nc			; $4482
_label_08_019:
	ld a,($d00f)		; $4483
	or a			; $4486
	jr nz,_label_08_020	; $4487
	call checkLinkID0AndControlNormal		; $4489
	jr nc,_label_08_020	; $448c
	call objectCheckLinkPushingAgainstCenter		; $448e
	jr nc,_label_08_020	; $4491
	ld a,$01		; $4493
	ld ($cc81),a		; $4495
	call interactionDecCounter1		; $4498
	ret nz			; $449b
	call interactionIncState		; $449c
	ld a,$81		; $449f
	ld ($cc77),a		; $44a1
	ld hl,$d010		; $44a4
	ld (hl),$14		; $44a7
	ld l,$14		; $44a9
	ld (hl),$40		; $44ab
	inc l			; $44ad
	ld (hl),$fe		; $44ae
	call objectGetAngleTowardLink		; $44b0
	xor $10			; $44b3
	ld ($d009),a		; $44b5
	ret			; $44b8
_label_08_020:
	ld e,$46		; $44b9
	ld a,$04		; $44bb
	ld (de),a		; $44bd
	ret			; $44be
	ld hl,$d00f		; $44bf
	ld a,(hl)		; $44c2
	cp $fa			; $44c3
	ret c			; $44c5
	ld l,$15		; $44c6
	bit 7,(hl)		; $44c8
	ret nz			; $44ca
	ld a,$03		; $44cb
	ld (de),a		; $44cd
	ld hl,$d100		; $44ce
	ldi (hl),a		; $44d1
	ld (hl),$0a		; $44d2
	ld e,$48		; $44d4
	ld l,$08		; $44d6
	ld a,(de)		; $44d8
	ldi (hl),a		; $44d9
	inc e			; $44da
	ld a,(de)		; $44db
	ld (hl),a		; $44dc
	call objectCopyPosition		; $44dd
	jp objectDeleteRelatedObj1AsStaticObject		; $44e0

interactionCode17:
	ld e,$44		; $44e3
	ld a,(de)		; $44e5
	rst_jumpTable			; $44e6
.DB $ed				; $44e7
	ld b,h			; $44e8
	rrca			; $44e9
	ld b,l			; $44ea
	inc e			; $44eb
	ld b,l			; $44ec
	call interactionIncState		; $44ed
	ld l,$4f		; $44f0
	ld (hl),$fc		; $44f2
	ld l,$46		; $44f4
	ld (hl),$08		; $44f6
	ld l,$42		; $44f8
	ld a,(hl)		; $44fa
	ld hl,$4525		; $44fb
	call lookupCollisionTable		; $44fe
	ld e,$42		; $4501
	ld (de),a		; $4503
	call interactionInitGraphics		; $4504
	call objectSetVisible80		; $4507
	ld a,$5e		; $450a
	jp playSound		; $450c
	call interactionDecCounter1		; $450f
	ret nz			; $4512
	ld (hl),$14		; $4513
	ld l,$4f		; $4515
	ld (hl),$f8		; $4517
	jp interactionIncState		; $4519
	call interactionDecCounter1		; $451c
	ret nz			; $451f
	ld (hl),$0f		; $4520
	jp interactionDelete		; $4522
	ld sp,$3245		; $4525
	ld b,l			; $4528
	inc (hl)		; $4529
	ld b,l			; $452a
	inc (hl)		; $452b
	ld b,l			; $452c
	dec (hl)		; $452d
	ld b,l			; $452e
	inc (hl)		; $452f
	ld b,l			; $4530
	nop			; $4531
.DB $ec				; $4532
	nop			; $4533
	nop			; $4534
	ld e,$00		; $4535
	ld (hl),b		; $4537
	nop			; $4538
	ld (hl),c		; $4539
	nop			; $453a
	ld (hl),d		; $453b
	nop			; $453c
	ld (hl),e		; $453d
	nop			; $453e
	ld (hl),h		; $453f
	ld bc,$0175		; $4540
	halt			; $4543
	ld bc,$0177		; $4544
	nop			; $4547

interactionCode18:
	ld e,$44		; $4548
	ld a,(de)		; $454a
	rst_jumpTable			; $454b
	ld d,d			; $454c
	ld b,l			; $454d
	ld h,h			; $454e
	ld b,l			; $454f
	ld (hl),a		; $4550
	ld b,l			; $4551
	call interactionIncState		; $4552
	ld bc,$fe00		; $4555
	call objectSetSpeedZ		; $4558
	call interactionSetAlwaysUpdateBit		; $455b
	call interactionInitGraphics		; $455e
	jp objectSetVisible80		; $4561
	ld c,$28		; $4564
	call objectUpdateSpeedZ_paramC		; $4566
	ld e,$55		; $4569
	ld a,(de)		; $456b
	bit 7,a			; $456c
	ret nz			; $456e
	ld e,$46		; $456f
	ld a,$3c		; $4571
	ld (de),a		; $4573
	jp interactionIncState		; $4574
	call interactionDecCounter1		; $4577
	ret nz			; $457a
	jp interactionDelete		; $457b

interactionCode1c:
	call checkInteractionState		; $457e
	jp nz,interactionRunScript		; $4581
	ld a,$28		; $4584
	call checkGlobalFlag		; $4586
	jr nz,_label_08_021	; $4589
	call checkIsLinkedGame		; $458b
	jp z,interactionDelete		; $458e
_label_08_021:
	call interactionInitGraphics		; $4591
	call objectSetVisible83		; $4594
	ld hl,$4685		; $4597
	call interactionSetScript		; $459a
	jp interactionIncState		; $459d

interactionCode1d:
	ld e,$44		; $45a0
	ld a,(de)		; $45a2
	rst_jumpTable			; $45a3
	xor b			; $45a4
	ld b,l			; $45a5
	rst_jumpTable			; $45a6
	ld b,l			; $45a7
	ld a,$01		; $45a8
	ld (de),a		; $45aa
	ld e,$42		; $45ab
	ld a,(de)		; $45ad
	ld b,a			; $45ae
	add a			; $45af
	add b			; $45b0
	ld hl,$45c1		; $45b1
	rst_addAToHl			; $45b4
	ldi a,(hl)		; $45b5
	ld e,$70		; $45b6
	ld (de),a		; $45b8
	ldi a,(hl)		; $45b9
	ld e,$71		; $45ba
	ld (de),a		; $45bc
	ld a,(hl)		; $45bd
	inc e			; $45be
	ld (de),a		; $45bf
	ret			; $45c0
	inc hl			; $45c1
	ld a,($ff00+$c8)	; $45c2
	inc (hl)		; $45c4
	ld hl,sp-$38		; $45c5
	ld a,($ccb4)		; $45c7
	cp $3c			; $45ca
	jr z,_label_08_022	; $45cc
	cp $3d			; $45ce
	ret nz			; $45d0
_label_08_022:
	ld h,d			; $45d1
	ld l,$70		; $45d2
	ld a,(hl)		; $45d4
	ld a,($ccb3)		; $45d5
	sub (hl)		; $45d8
	ld b,a			; $45d9
	ld l,$71		; $45da
	ldi a,(hl)		; $45dc
	ld h,(hl)		; $45dd
	ld l,a			; $45de
	ld a,b			; $45df
	swap a			; $45e0
	and $0f			; $45e2
	rst_addAToHl			; $45e4
	ld a,b			; $45e5
	and $0f			; $45e6
	ld bc,bitTable		; $45e8
	add c			; $45eb
	ld c,a			; $45ec
	ld a,(bc)		; $45ed
	or (hl)			; $45ee
	ld (hl),a		; $45ef
	call getRandomNumber		; $45f0
	and $0f			; $45f3
	ld hl,$4617		; $45f5
	rst_addAToHl			; $45f8
	ld c,(hl)		; $45f9
	ld a,$26		; $45fa
	call cpActiveRing		; $45fc
	jr z,_label_08_023	; $45ff
	ld a,$24		; $4601
	call cpActiveRing		; $4603
	jr nz,_label_08_024	; $4606
_label_08_023:
	inc c			; $4608
_label_08_024:
	ld a,$28		; $4609
	call giveTreasure		; $460b
	ld a,($ccb3)		; $460e
	ld c,a			; $4611
	ld a,$a0		; $4612
	jp setTile		; $4614
	ld bc,$0404		; $4617
	inc bc			; $461a
	inc bc			; $461b
	inc bc			; $461c
	inc bc			; $461d
	ld bc,$0501		; $461e
	ld bc,$0101		; $4621
	ld bc,$0101		; $4624

interactionCode1e:
	call interactionDeleteAndRetIfEnabled02		; $4627
	call returnIfScrollMode01Unset		; $462a
	ld e,$44		; $462d
	ld a,(de)		; $462f
	rst_jumpTable			; $4630
	add hl,sp		; $4631
	ld b,(hl)		; $4632
	ld l,c			; $4633
	ld b,(hl)		; $4634
	ld (hl),h		; $4635
	ld b,(hl)		; $4636
	add $46			; $4637
	ld a,$01		; $4639
	ld (de),a		; $463b
	ld h,d			; $463c
	ld l,$4d		; $463d
	ld e,$7f		; $463f
	ld a,(hl)		; $4641
	ld (de),a		; $4642
	and $07			; $4643
	ld bc,bitTable		; $4645
	add c			; $4648
	ld c,a			; $4649
	ld a,(bc)		; $464a
	ld l,$7d		; $464b
	ld (hl),a		; $464d
	ld l,$4b		; $464e
	ld e,$7e		; $4650
	ld a,(hl)		; $4652
	ld (de),a		; $4653
	ld l,$4b		; $4654
	call setShortPosition		; $4656
	ld e,$42		; $4659
	ld a,(de)		; $465b
	ld hl,$476e		; $465c
	rst_addDoubleIndex			; $465f
	ldi a,(hl)		; $4660
	ld h,(hl)		; $4661
	ld l,a			; $4662
	call interactionSetScript		; $4663
	call $471b		; $4666
	call interactionRunScript		; $4669
	jp c,interactionDelete		; $466c
	ld e,$45		; $466f
	xor a			; $4671
	ld (de),a		; $4672
	ret			; $4673
	ld a,($c4ab)		; $4674
	or a			; $4677
	ret nz			; $4678
	ld e,$45		; $4679
	ld a,(de)		; $467b
	rst_jumpTable			; $467c
	add c			; $467d
	ld b,(hl)		; $467e
	or (hl)			; $467f
	ld b,(hl)		; $4680
	call objectCheckTileCollision_allowHoles		; $4681
	jr nc,_label_08_027	; $4684
_label_08_025:
	ld a,$70		; $4686
	call $4743		; $4688
	ld e,$49		; $468b
	ld a,(de)		; $468d
	ld hl,$474e		; $468e
	rst_addAToHl			; $4691
	ld e,$7e		; $4692
	ld a,(de)		; $4694
	ldh (<hFF8C),a	; $4695
	ldi a,(hl)		; $4697
	ldh (<hFF8F),a	; $4698
	ldi a,(hl)		; $469a
	ldh (<hFF8E),a	; $469b
	and $03			; $469d
	call setInterleavedTile		; $469f
	ldh a,(<hActiveObject)	; $46a2
	ld d,a			; $46a4
	ld h,d			; $46a5
	ld l,$45		; $46a6
	inc (hl)		; $46a8
	ld l,$46		; $46a9
	ld (hl),$06		; $46ab
	ld l,$7e		; $46ad
	ld c,(hl)		; $46af
	ld b,$cf		; $46b0
	ldh a,(<hFF8F)	; $46b2
	ld (bc),a		; $46b4
	ret			; $46b5
	call interactionDecCounter1		; $46b6
	ret nz			; $46b9
	call $4724		; $46ba
	ld e,$49		; $46bd
	ld a,(de)		; $46bf
	ld hl,$474e		; $46c0
	rst_addAToHl			; $46c3
	jr _label_08_026		; $46c4
	ld e,$45		; $46c6
	ld a,(de)		; $46c8
	rst_jumpTable			; $46c9
	adc $46			; $46ca
	push de			; $46cc
	ld b,(hl)		; $46cd
	call objectCheckTileCollision_allowHoles		; $46ce
	jr c,_label_08_027	; $46d1
	jr _label_08_025		; $46d3
	call interactionDecCounter1		; $46d5
	ret nz			; $46d8
	call $46ff		; $46d9
	call $472f		; $46dc
	ld e,$49		; $46df
	ld a,(de)		; $46e1
	ld hl,$474e		; $46e2
	rst_addAToHl			; $46e5
	inc hl			; $46e6
_label_08_026:
	ld e,$7e		; $46e7
	ld a,(de)		; $46e9
	ld c,a			; $46ea
	ld a,(hl)		; $46eb
	call setTile		; $46ec
	ld a,$70		; $46ef
	call $4743		; $46f1
_label_08_027:
	ld e,$44		; $46f4
	ld a,$01		; $46f6
	ld (de),a		; $46f8
	inc e			; $46f9
	xor a			; $46fa
	ld (de),a		; $46fb
	jp $4669		; $46fc
	ld a,($d00b)		; $46ff
	and $f0			; $4702
	ld b,a			; $4704
	ld a,($d00d)		; $4705
	swap a			; $4708
	and $0f			; $470a
	or b			; $470c
	ld b,a			; $470d
	ld e,$7e		; $470e
	ld a,(de)		; $4710
	cp b			; $4711
	ret nz			; $4712
	ld a,$02		; $4713
	ld ($cd15),a		; $4715
	jp respawnLink		; $4718
	ld e,$7e		; $471b
	ld a,(de)		; $471d
	ld c,a			; $471e
	ld b,$ce		; $471f
	ld a,(bc)		; $4721
	or a			; $4722
	ret nz			; $4723
	ld e,$42		; $4724
	ld a,(de)		; $4726
	cp $04			; $4727
	ret c			; $4729
	ld hl,wcc93		; $472a
	inc (hl)		; $472d
	ret			; $472e
	ld e,$42		; $472f
	ld a,(de)		; $4731
	cp $04			; $4732
	ret c			; $4734
	ld hl,wcc93		; $4735
	ld a,(hl)		; $4738
	or a			; $4739
	ret z			; $473a
	dec (hl)		; $473b
	ld a,(hl)		; $473c
	and $7f			; $473d
	ret nz			; $473f
	res 7,(hl)		; $4740
	ret			; $4742
	ldh (<hFF8B),a	; $4743
	call objectCheckWithinScreenBoundary		; $4745
	ret nc			; $4748
	ldh a,(<hFF8B)	; $4749
	jp playSound		; $474b
	and b			; $474e
	ld (hl),b		; $474f
	and b			; $4750
	ld (hl),c		; $4751
	and b			; $4752
	ld (hl),d		; $4753
	and b			; $4754
	ld (hl),e		; $4755
	and b			; $4756
	ld (hl),h		; $4757
	and b			; $4758
	ld (hl),l		; $4759
	and b			; $475a
	halt			; $475b
	and b			; $475c
	ld (hl),a		; $475d
	and b			; $475e
	ld a,b			; $475f
	and b			; $4760
	ld a,c			; $4761
	and b			; $4762
	ld a,d			; $4763
	and b			; $4764
	ld a,e			; $4765
	ld e,(hl)		; $4766
	ld a,h			; $4767
	ld e,l			; $4768
	ld a,l			; $4769
	ld e,(hl)		; $476a
	ld a,(hl)		; $476b
	ld e,l			; $476c
	ld a,a			; $476d
	sbc a			; $476e
	ld b,(hl)		; $476f
	ret c			; $4770
	ld b,l			; $4771
	ret c			; $4772
	ld b,l			; $4773
	ret c			; $4774
	ld b,l			; $4775
	and d			; $4776
	ld b,(hl)		; $4777
	xor c			; $4778
	ld b,(hl)		; $4779
	or b			; $477a
	ld b,(hl)		; $477b
	or a			; $477c
	ld b,(hl)		; $477d
	rst $20			; $477e
	ld b,(hl)		; $477f
	pop af			; $4780
	ld b,(hl)		; $4781
	ei			; $4782
	ld b,(hl)		; $4783
	dec b			; $4784
	ld b,a			; $4785
	dec hl			; $4786
	ld b,a			; $4787
	ldd (hl),a		; $4788
	ld b,a			; $4789
	add hl,sp		; $478a
	ld b,a			; $478b
	ld b,b			; $478c
	ld b,a			; $478d
	ld c,(hl)		; $478e
	ld b,a			; $478f
	ld d,l			; $4790
	ld b,a			; $4791
	ld e,h			; $4792
	ld b,a			; $4793
	ld h,e			; $4794
	ld b,a			; $4795
	ld a,a			; $4796
	ld b,a			; $4797
	adc b			; $4798
	ld b,a			; $4799
	ld a,($cd00)		; $479a
	cp $02			; $479d
	ret z			; $479f
	ld hl,$ccea		; $47a0
	bit 2,(hl)		; $47a3
	ret z			; $47a5
	res 2,(hl)		; $47a6
	push de			; $47a8
	ld a,UNCMP_GFXH_11		; $47a9
	call loadUncompressedGfxHeader		; $47ab
	pop de			; $47ae
	ret			; $47af

interactionCode46:
	call $479a		; $47b0
	call $47b9		; $47b3
	jp interactionAnimateAsNpc		; $47b6
	ld e,$44		; $47b9
	ld a,(de)		; $47bb
	rst_jumpTable			; $47bc
	bit 0,a			; $47bd
	rrca			; $47bf
	ld c,b			; $47c0
	ret z			; $47c1
	ld c,b			; $47c2
	rra			; $47c3
	ld c,c			; $47c4
	dec h			; $47c5
	ld c,c			; $47c6
	sub e			; $47c7
	ld c,c			; $47c8
	and l			; $47c9
	ld c,b			; $47ca
	ld a,$01		; $47cb
	ld (de),a		; $47cd
	ld e,$40		; $47ce
	ld a,(de)		; $47d0
	or $80			; $47d1
	ld (de),a		; $47d3
	ld a,$80		; $47d4
	ld ($ccbc),a		; $47d6
	call interactionInitGraphics		; $47d9
	ld e,$49		; $47dc
	ld a,$04		; $47de
	ld (de),a		; $47e0
	ld bc,$0614		; $47e1
	call objectSetCollideRadii		; $47e4
	ld l,$42		; $47e7
	ld a,(hl)		; $47e9
	cp $01			; $47ea
	jr nz,_label_08_028	; $47ec
	ld a,($c63f)		; $47ee
	and $0f			; $47f1
	cp $0f			; $47f3
	jr nz,_label_08_028	; $47f5
	set 7,(hl)		; $47f7
_label_08_028:
	ld a,$53		; $47f9
	call checkTreasureObtained		; $47fb
	jr nc,_label_08_029	; $47fe
	ld e,$7e		; $4800
	ld a,$01		; $4802
	ld (de),a		; $4804
_label_08_029:
	ld a,$0e		; $4805
	call interactionSetHighTextIndex		; $4807
	ld e,$71		; $480a
	jp objectAddToAButtonSensitiveObjectList		; $480c
	call retIfTextIsActive		; $480f
	ld e,$71		; $4812
	ld a,(de)		; $4814
	or a			; $4815
	jr nz,_label_08_034	; $4816
	ld e,$42		; $4818
	ld a,(de)		; $481a
	or a			; $481b
	jr nz,_label_08_030	; $481c
	ld e,$7d		; $481e
	ld a,(de)		; $4820
	or a			; $4821
	jr nz,_label_08_030	; $4822
	ld bc,$3008		; $4824
	call objectSetCollideRadii		; $4827
	call objectCheckCollidedWithLink		; $482a
	jr nc,_label_08_030	; $482d
	ld e,$44		; $482f
	ld a,$03		; $4831
	ld (de),a		; $4833
	ret			; $4834
_label_08_030:
	ld e,$42		; $4835
	ld a,(de)		; $4837
	or a			; $4838
	ld hl,$d00d		; $4839
	jr nz,_label_08_031	; $483c
	ld e,$4d		; $483e
	ld a,(de)		; $4840
	cp (hl)			; $4841
	jr nc,_label_08_035	; $4842
_label_08_031:
	ld l,$0b		; $4844
	ld e,$42		; $4846
	ld a,(de)		; $4848
	and $01			; $4849
	ld c,$69		; $484b
	ld b,(hl)		; $484d
	ld a,$69		; $484e
	jr z,_label_08_032	; $4850
	ld b,$27		; $4852
	ld c,(hl)		; $4854
	ld a,$27		; $4855
_label_08_032:
	ld l,a			; $4857
	ld a,c			; $4858
	cp b			; $4859
	jr nc,_label_08_033	; $485a
	ld a,($cc75)		; $485c
	or a			; $485f
	jr z,_label_08_033	; $4860
	ld a,$81		; $4862
	ld ($cca4),a		; $4864
	ld a,l			; $4867
	ld hl,$d00b		; $4868
	ld (hl),a		; $486b
	ld bc,$0606		; $486c
	call objectSetCollideRadii		; $486f
	ld e,$42		; $4872
	ld a,(de)		; $4874
	ld hl,$4ab9		; $4875
	rst_addDoubleIndex			; $4878
	ldi a,(hl)		; $4879
	ld h,(hl)		; $487a
	ld l,a			; $487b
	jp $490d		; $487c
_label_08_033:
	ld bc,$0614		; $487f
	jp objectSetCollideRadii		; $4882
_label_08_034:
	xor a			; $4885
	ld (de),a		; $4886
	call objectRemoveFromAButtonSensitiveObjectList		; $4887
	call $4aab		; $488a
	ld a,$81		; $488d
	ld ($cca4),a		; $488f
	ld e,$44		; $4892
	ld a,$02		; $4894
	ld (de),a		; $4896
	ret			; $4897
_label_08_035:
	ld a,$06		; $4898
	call objectSetCollideRadius		; $489a
	ld l,$44		; $489d
	ld (hl),$06		; $489f
	ld l,$7d		; $48a1
	ld (hl),d		; $48a3
	ret			; $48a4
	ld e,$71		; $48a5
	ld a,(de)		; $48a7
	or a			; $48a8
	jr nz,_label_08_036	; $48a9
	ld hl,$d00d		; $48ab
	ld e,$4d		; $48ae
	ld a,(de)		; $48b0
	cp (hl)			; $48b1
	ret nc			; $48b2
	jp $496e		; $48b3
_label_08_036:
	xor a			; $48b6
	ld (de),a		; $48b7
	call objectRemoveFromAButtonSensitiveObjectList		; $48b8
	ld a,$81		; $48bb
	ld ($cca4),a		; $48bd
	ld e,$44		; $48c0
	ld a,$02		; $48c2
	ld (de),a		; $48c4
	jp $4aab		; $48c5
	ld e,$42		; $48c8
	ld a,(de)		; $48ca
	and $80			; $48cb
	jr nz,_label_08_039	; $48cd
	ld a,$05		; $48cf
	call checkTreasureObtained		; $48d1
	ld hl,$4986		; $48d4
	jr nc,_label_08_038	; $48d7
	ld a,($cc75)		; $48d9
	or a			; $48dc
	jr z,_label_08_037	; $48dd
	ld a,($d019)		; $48df
	ld h,a			; $48e2
	ld e,$7b		; $48e3
	ld (de),a		; $48e5
	ld l,$42		; $48e6
	ld a,(hl)		; $48e8
	ld e,$77		; $48e9
	ld (de),a		; $48eb
	call $4a33		; $48ec
	ld e,$77		; $48ef
	ld a,(de)		; $48f1
	call $4a54		; $48f2
	ld hl,$47b8		; $48f5
	jp $490d		; $48f8
_label_08_037:
	call $4a93		; $48fb
	jr nz,_label_08_038	; $48fe
	ld e,$42		; $4900
	ld a,(de)		; $4902
	cp $02			; $4903
	ld hl,$47af		; $4905
	jr nz,_label_08_038	; $4908
	ld hl,$47b2		; $490a
_label_08_038:
	ld e,$44		; $490d
	ld a,$04		; $490f
	ld (de),a		; $4911
	jp interactionSetScript		; $4912
_label_08_039:
	ld a,$0c		; $4915
	call $4a33		; $4917
	ld hl,$48ba		; $491a
	jr _label_08_038		; $491d
	ld hl,shopkeeperScript_blockLinkAccess		; $491f
	jp $490d		; $4922
	ld e,$42		; $4925
	ld a,(de)		; $4927
	and $80			; $4928
	ld a,$0c		; $492a
	call nz,$4a33		; $492c
	call interactionRunScript		; $492f
	ret nc			; $4932
	xor a			; $4933
	ld ($cca4),a		; $4934
	ld e,$7f		; $4937
	ld a,(de)		; $4939
	or a			; $493a
	jr z,_label_08_040	; $493b
	ld c,a			; $493d
	xor a			; $493e
	ld (de),a		; $493f
	call getRandomRingOfGivenTier		; $4940
	ld b,c			; $4943
	ld c,$00		; $4944
	call giveRingToLink		; $4946
	ld a,$01		; $4949
	ld ($cca4),a		; $494b
	jr _label_08_042		; $494e
_label_08_040:
	ld e,$7a		; $4950
	ld a,(de)		; $4952
	or a			; $4953
	jr z,_label_08_042	; $4954
	inc a			; $4956
	ld c,$04		; $4957
	jr z,_label_08_041	; $4959
	ld c,$03		; $495b
	ld a,$81		; $495d
	ld ($cca4),a		; $495f
_label_08_041:
	xor a			; $4962
	ld (de),a		; $4963
	ld e,$7b		; $4964
	ld a,(de)		; $4966
	ld h,a			; $4967
	ld l,$44		; $4968
	ld (hl),c		; $496a
	call dropLinkHeldItem		; $496b
_label_08_042:
	ld e,$44		; $496e
	ld a,$01		; $4970
	ld (de),a		; $4972
	ld hl,$d00d		; $4973
	ld e,$4d		; $4976
	ld a,(de)		; $4978
	cp (hl)			; $4979
	jr nc,_label_08_043	; $497a
	ld bc,$0614		; $497c
	call objectSetCollideRadii		; $497f
	jr _label_08_044		; $4982
_label_08_043:
	ld a,$06		; $4984
	call objectSetCollideRadius		; $4986
_label_08_044:
	ld a,$01		; $4989
	call interactionSetAnimation		; $498b
	ld e,$71		; $498e
	jp objectAddToAButtonSensitiveObjectList		; $4990
	ld e,$45		; $4993
	ld a,(de)		; $4995
	rst_jumpTable			; $4996
	sbc a			; $4997
	ld c,c			; $4998
	or l			; $4999
	ld c,c			; $499a
	ld d,$4a		; $499b
	dec hl			; $499d
	ld c,d			; $499e
	ld a,$01		; $499f
	ld (de),a		; $49a1
	call getRandomNumber		; $49a2
	and $01			; $49a5
	ld e,$79		; $49a7
	ld (de),a		; $49a9
	call $4a48		; $49aa
	xor a			; $49ad
	ld ($ccbc),a		; $49ae
	ld e,$7f		; $49b1
	ld (de),a		; $49b3
	ret			; $49b4
	ld e,$71		; $49b5
	ld a,(de)		; $49b7
	or a			; $49b8
	jr z,_label_08_045	; $49b9
	xor a			; $49bb
	ld (de),a		; $49bc
	ld hl,$496e		; $49bd
	jp $490d		; $49c0
_label_08_045:
	ld a,($ccbc)		; $49c3
	or a			; $49c6
	ret z			; $49c7
	ld e,$45		; $49c8
	xor a			; $49ca
	ld (de),a		; $49cb
	ld a,$f1		; $49cc
	call findTileInRoom		; $49ce
	ld a,($ccbc)		; $49d1
	sub l			; $49d4
	rlca			; $49d5
	xor $01			; $49d6
	and $01			; $49d8
	ld h,d			; $49da
	ld l,$79		; $49db
	xor (hl)		; $49dd
	ld l,$7c		; $49de
	jr nz,_label_08_046	; $49e0
	ld (hl),a		; $49e2
	ld hl,$490d		; $49e3
	jp $490d		; $49e6
_label_08_046:
	add (hl)		; $49e9
	ld (hl),a		; $49ea
	call getFreeInteractionSlot		; $49eb
	ld (hl),$60		; $49ee
	ld l,$42		; $49f0
	ld (hl),$28		; $49f2
	inc l			; $49f4
	ld (hl),$08		; $49f5
	ld l,$71		; $49f7
	ld (hl),$03		; $49f9
	ld l,$79		; $49fb
	ld (hl),$01		; $49fd
	ld e,$79		; $49ff
	ld a,(de)		; $4a01
	ld bc,$4abf		; $4a02
	call addAToBc		; $4a05
	ld l,$4b		; $4a08
	ld (hl),$20		; $4a0a
	ld l,$4d		; $4a0c
	ld a,(bc)		; $4a0e
	ld (hl),a		; $4a0f
	ld hl,$4921		; $4a10
	jp $490d		; $4a13
	ld e,$49		; $4a16
	ld a,(de)		; $4a18
	swap a			; $4a19
	and $01			; $4a1b
	ld h,d			; $4a1d
	ld l,$79		; $4a1e
	xor (hl)		; $4a20
	jr nz,_label_08_047	; $4a21
	call $4a48		; $4a23
	ld e,$45		; $4a26
	ld a,$03		; $4a28
	ld (de),a		; $4a2a
_label_08_047:
	call interactionRunScript		; $4a2b
	ret nc			; $4a2e
	ld e,$45		; $4a2f
	xor a			; $4a31
	ld (de),a		; $4a32
	ld hl,$4c93		; $4a33
	rst_addAToHl			; $4a36
	ld a,(hl)		; $4a37
	call cpRupeeValue		; $4a38
	ld ($ccec),a		; $4a3b
	ld ($cbad),a		; $4a3e
	ld hl,$cba8		; $4a41
	ld (hl),c		; $4a44
	inc l			; $4a45
	ld (hl),b		; $4a46
	ret			; $4a47
	ld a,($ccbc)		; $4a48
	bit 7,a			; $4a4b
	ld c,a			; $4a4d
	ld a,$f1		; $4a4e
	jp z,setTile		; $4a50
	ret			; $4a53
	ld b,a			; $4a54
	xor a			; $4a55
	ld e,$78		; $4a56
	ld (de),a		; $4a58
	ld e,$42		; $4a59
	ld a,(de)		; $4a5b
	ld e,$78		; $4a5c
	or a			; $4a5e
	ret nz			; $4a5f
	ld h,$c6		; $4a60
	ld a,b			; $4a62
	cp $13			; $4a63
	ret z			; $4a65
	cp $03			; $4a66
	jr z,_label_08_050	; $4a68
	cp $11			; $4a6a
	jr z,_label_08_050	; $4a6c
	cp $12			; $4a6e
	jr z,_label_08_050	; $4a70
	cp $0d			; $4a72
	jr z,_label_08_051	; $4a74
	ld l,$aa		; $4a76
	cp $04			; $4a78
	jr z,_label_08_048	; $4a7a
	ld l,$a2		; $4a7c
_label_08_048:
	ldi a,(hl)		; $4a7e
	cp (hl)			; $4a7f
	ret nz			; $4a80
_label_08_049:
	ld a,$01		; $4a81
	ld (de),a		; $4a83
	ret			; $4a84
_label_08_050:
	ld a,$01		; $4a85
	jr _label_08_052		; $4a87
_label_08_051:
	ld a,$0e		; $4a89
_label_08_052:
	call checkTreasureObtained		; $4a8b
	ld e,$78		; $4a8e
	ret nc			; $4a90
	jr _label_08_049		; $4a91
	ld hl,$d240		; $4a93
_label_08_053:
	ld l,$40		; $4a96
	ldi a,(hl)		; $4a98
	or a			; $4a99
	jr z,_label_08_054	; $4a9a
	ld a,(hl)		; $4a9c
	cp $47			; $4a9d
	ret z			; $4a9f
_label_08_054:
	inc h			; $4aa0
	ld a,h			; $4aa1
	cp $e0			; $4aa2
	jr c,_label_08_053	; $4aa4
	ld hl,$47b5		; $4aa6
	or d			; $4aa9
	ret			; $4aaa
	call objectGetAngleTowardLink		; $4aab
	ld e,$49		; $4aae
	ld (de),a		; $4ab0
	call convertAngleDeToDirection		; $4ab1
	dec e			; $4ab4
	ld (de),a		; $4ab5
	jp interactionSetAnimation		; $4ab6
	sbc e			; $4ab9
	ld c,b			; $4aba
	xor l			; $4abb
	ld c,b			; $4abc
	sbc e			; $4abd
	ld c,b			; $4abe
	ld a,b			; $4abf
	ld e,b			; $4ac0

interactionCode47:
	ld e,$44		; $4ac1
	ld a,(de)		; $4ac3
	rst_jumpTable			; $4ac4
	pop de			; $4ac5
	ld c,d			; $4ac6
	ld (hl),l		; $4ac7
	dec hl			; $4ac8
	ld (hl),c		; $4ac9
	ld c,e			; $4aca
	ld ($ff00+$4b),a	; $4acb
	adc d			; $4acd
	ld c,e			; $4ace
	ld h,e			; $4acf
	ld c,e			; $4ad0
	ld a,($ccea)		; $4ad1
	and $02			; $4ad4
	ret z			; $4ad6
	ld a,$01		; $4ad7
	ld (de),a		; $4ad9
	ld a,$05		; $4ada
	call checkTreasureObtained		; $4adc
	jp nc,$4b6d		; $4adf
	ld e,$42		; $4ae2
	ld a,(de)		; $4ae4
	cp $03			; $4ae5
	jr nz,_label_08_055	; $4ae7
	call checkIsLinkedGame		; $4ae9
	jr z,_label_08_055	; $4aec
	ld a,$13		; $4aee
	ld (de),a		; $4af0
_label_08_055:
	ld a,$0e		; $4af1
	call checkTreasureObtained		; $4af3
	jr c,_label_08_056	; $4af6
	ld a,($c643)		; $4af8
	bit 5,a			; $4afb
	jr nz,_label_08_056	; $4afd
	ld a,($c6bb)		; $4aff
	bit 1,a			; $4b02
	jr z,_label_08_056	; $4b04
	call checkIsLinkedGame		; $4b06
	jr nz,_label_08_056	; $4b09
	ld c,$08		; $4b0b
	jr _label_08_057		; $4b0d
_label_08_056:
	ld c,$00		; $4b0f
_label_08_057:
	ld a,($c640)		; $4b11
	and $f7			; $4b14
	or c			; $4b16
	ld ($c640),a		; $4b17
	ld a,$0d		; $4b1a
	call checkTreasureObtained		; $4b1c
	ld c,$10		; $4b1f
	jr c,_label_08_058	; $4b21
	ld c,$20		; $4b23
_label_08_058:
	ld a,($c640)		; $4b25
	and $cf			; $4b28
	or c			; $4b2a
	ld ($c640),a		; $4b2b
_label_08_059:
	ld e,$42		; $4b2e
	ld a,(de)		; $4b30
	add a			; $4b31
	ld hl,$4cf6		; $4b32
	rst_addDoubleIndex			; $4b35
	ldi a,(hl)		; $4b36
	ld c,a			; $4b37
	ld b,$c6		; $4b38
	ld a,(bc)		; $4b3a
	and (hl)		; $4b3b
	jr z,_label_08_060	; $4b3c
	inc hl			; $4b3e
	ldi a,(hl)		; $4b3f
	bit 7,a			; $4b40
	jr nz,_label_08_061	; $4b42
	ld (de),a		; $4b44
	ld e,$4d		; $4b45
	ld a,(de)		; $4b47
	add (hl)		; $4b48
	ld (de),a		; $4b49
	jr _label_08_059		; $4b4a
_label_08_060:
	call interactionInitGraphics		; $4b4c
	ld a,$07		; $4b4f
	call objectSetCollideRadius		; $4b51
	ld l,$70		; $4b54
	ld e,$4b		; $4b56
	ld a,(de)		; $4b58
	ldi (hl),a		; $4b59
	ld e,$4d		; $4b5a
	ld a,(de)		; $4b5c
	ldi (hl),a		; $4b5d
	call objectSetVisible83		; $4b5e
	jr _label_08_063		; $4b61
	call retIfTextIsActive		; $4b63
	xor a			; $4b66
	ld ($cca4),a		; $4b67
	ld ($cc02),a		; $4b6a
_label_08_061:
	pop af			; $4b6d
	jp interactionDelete		; $4b6e
	ld e,$45		; $4b71
	ld a,(de)		; $4b73
	rst_jumpTable			; $4b74
	ld a,c			; $4b75
	ld c,e			; $4b76
	add (hl)		; $4b77
	ld c,e			; $4b78
	ld a,$01		; $4b79
	ld (de),a		; $4b7b
	ld a,$08		; $4b7c
	ld (wLinkGrabState2),a		; $4b7e
	call objectSetVisible80		; $4b81
	jr _label_08_062		; $4b84
	call $4ca7		; $4b86
	ret nz			; $4b89
	ld h,d			; $4b8a
	ld e,$4b		; $4b8b
	ld l,$70		; $4b8d
	ldi a,(hl)		; $4b8f
	ld (de),a		; $4b90
	ld e,$4d		; $4b91
	ld a,(hl)		; $4b93
	ld (de),a		; $4b94
	ld l,$4f		; $4b95
	ld (hl),$00		; $4b97
	ld l,$44		; $4b99
	ld (hl),$01		; $4b9b
	call $4bb8		; $4b9d
	call objectSetVisible83		; $4ba0
	jp dropLinkHeldItem		; $4ba3
_label_08_062:
	call $4c24		; $4ba6
	ret nc			; $4ba9
	push hl			; $4baa
	ld a,$03		; $4bab
	rst_addAToHl			; $4bad
	ld a,$20		; $4bae
	ldi (hl),a		; $4bb0
	inc l			; $4bb1
	ldi (hl),a		; $4bb2
	inc l			; $4bb3
	ldi (hl),a		; $4bb4
	pop hl			; $4bb5
	jr _label_08_064		; $4bb6
_label_08_063:
	call $4c24		; $4bb8
	ret nc			; $4bbb
_label_08_064:
	ld a,($ff00+$70)	; $4bbc
	push af			; $4bbe
	ld a,$03		; $4bbf
	ld ($ff00+$70),a	; $4bc1
	push de			; $4bc3
	ldi a,(hl)		; $4bc4
	ld e,a			; $4bc5
	ldi a,(hl)		; $4bc6
	ld d,a			; $4bc7
	ldi a,(hl)		; $4bc8
	ld b,a			; $4bc9
_label_08_065:
	ldi a,(hl)		; $4bca
	ld (de),a		; $4bcb
	set 2,d			; $4bcc
	ldi a,(hl)		; $4bce
	ld (de),a		; $4bcf
	res 2,d			; $4bd0
	inc de			; $4bd2
	dec b			; $4bd3
	jr nz,_label_08_065	; $4bd4
	pop de			; $4bd6
	pop af			; $4bd7
	ld ($ff00+$70),a	; $4bd8
	ld hl,$ccea		; $4bda
	set 2,(hl)		; $4bdd
	ret			; $4bdf
	ld e,$42		; $4be0
	ld a,(de)		; $4be2
	ld hl,$4c93		; $4be3
	rst_addAToHl			; $4be6
	ldi a,(hl)		; $4be7
	call removeRupeeValue		; $4be8
	ld e,$42		; $4beb
	ld a,(de)		; $4bed
	ld hl,$4cce		; $4bee
	rst_addDoubleIndex			; $4bf1
	ldi a,(hl)		; $4bf2
	ld c,(hl)		; $4bf3
	cp $00			; $4bf4
	jr nz,_label_08_066	; $4bf6
	call getRandomRingOfGivenTier		; $4bf8
_label_08_066:
	call giveTreasure		; $4bfb
	ld e,$42		; $4bfe
	ld a,(de)		; $4c00
	or a			; $4c01
	call z,refillSeedSatchel		; $4c02
	ld e,$44		; $4c05
	ld a,$05		; $4c07
	ld (de),a		; $4c09
	ld a,$04		; $4c0a
	ld ($cc6a),a		; $4c0c
	ld a,$01		; $4c0f
	ld ($cc6b),a		; $4c11
	ld e,$42		; $4c14
	ld a,(de)		; $4c16
	ld hl,$4d46		; $4c17
	rst_addAToHl			; $4c1a
	ld a,(hl)		; $4c1b
	ld c,a			; $4c1c
	or a			; $4c1d
	ld b,$00		; $4c1e
	jp nz,showText		; $4c20
	ret			; $4c23
	ld e,$42		; $4c24
	ld a,(de)		; $4c26
	ld c,a			; $4c27
	ld hl,$4c6b		; $4c28
	rst_addDoubleIndex			; $4c2b
	ldi a,(hl)		; $4c2c
	cp $ff			; $4c2d
	ret z			; $4c2f
	push de			; $4c30
	ld e,a			; $4c31
	ld d,(hl)		; $4c32
	ld a,c			; $4c33
	ld hl,$4c93		; $4c34
	rst_addAToHl			; $4c37
	ld a,(hl)		; $4c38
	call getRupeeValue		; $4c39
	ld hl,$cec0		; $4c3c
	ld (hl),e		; $4c3f
	inc l			; $4c40
	ld (hl),d		; $4c41
	inc l			; $4c42
	ld e,$03		; $4c43
	ld d,$30		; $4c45
	ld a,$02		; $4c47
	ldi (hl),a		; $4c49
	ld a,b			; $4c4a
	or a			; $4c4b
	jr z,_label_08_067	; $4c4c
	dec l			; $4c4e
	inc (hl)		; $4c4f
	inc l			; $4c50
	call $4c64		; $4c51
_label_08_067:
	ld a,c			; $4c54
	swap a			; $4c55
	call $4c64		; $4c57
	ld a,c			; $4c5a
	call $4c64		; $4c5b
	ld hl,$cec0		; $4c5e
	pop de			; $4c61
	scf			; $4c62
	ret			; $4c63
	and $0f			; $4c64
	add d			; $4c66
	ldi (hl),a		; $4c67
	ld (hl),e		; $4c68
	inc l			; $4c69
	ret			; $4c6a
	ld h,(hl)		; $4c6b
	ret c			; $4c6c
	ld l,a			; $4c6d
	ret c			; $4c6e
	ld l,d			; $4c6f
	ret c			; $4c70
	ld l,h			; $4c71
	ret c			; $4c72
	ld l,c			; $4c73
	ret c			; $4c74
	ld l,(hl)		; $4c75
	ret c			; $4c76
	ld l,d			; $4c77
	ret c			; $4c78
	ld l,b			; $4c79
	ret c			; $4c7a
	ld l,l			; $4c7b
	ret c			; $4c7c
	ld l,e			; $4c7d
	ret c			; $4c7e
	ld l,a			; $4c7f
	ret c			; $4c80
	ld h,a			; $4c81
	ret c			; $4c82
	rst $38			; $4c83
	rst $38			; $4c84
	ld l,a			; $4c85
	ret c			; $4c86
	ld h,a			; $4c87
	ret c			; $4c88
	ld l,e			; $4c89
	ret c			; $4c8a
	ld l,a			; $4c8b
	ret c			; $4c8c
	ld l,h			; $4c8d
	ret c			; $4c8e
	ld l,h			; $4c8f
	ret c			; $4c90
	ld l,h			; $4c91
	ret c			; $4c92
	stop			; $4c93
	inc b			; $4c94
	stop			; $4c95
	rlca			; $4c96
	dec b			; $4c97
	dec c			; $4c98
	ld de,$1010		; $4c99
	stop			; $4c9c
	stop			; $4c9d
	inc c			; $4c9e
	inc b			; $4c9f
	rrca			; $4ca0
	inc c			; $4ca1
	inc c			; $4ca2
	inc c			; $4ca3
	dec bc			; $4ca4
	inc de			; $4ca5
	rlca			; $4ca6
	ld a,($cc46)		; $4ca7
	and $03			; $4caa
	jr z,_label_08_068	; $4cac
	ld e,$71		; $4cae
	ld a,(de)		; $4cb0
	sub $0d			; $4cb1
	ld b,a			; $4cb3
	add $1a			; $4cb4
	ld hl,$d00d		; $4cb6
	cp (hl)			; $4cb9
	jr c,_label_08_068	; $4cba
	ld a,b			; $4cbc
	cp (hl)			; $4cbd
	jr nc,_label_08_068	; $4cbe
	ld l,$0b		; $4cc0
	ld a,(hl)		; $4cc2
	cp $3d			; $4cc3
	jr nc,_label_08_068	; $4cc5
	ld l,$08		; $4cc7
	ld a,(hl)		; $4cc9
	or a			; $4cca
	ret			; $4ccb
_label_08_068:
	or d			; $4ccc
	ret			; $4ccd
	add hl,de		; $4cce
	ld bc,$0c29		; $4ccf
	inc (hl)		; $4cd2
	ld bc,$0101		; $4cd3
	inc bc			; $4cd6
	stop			; $4cd7
	ld c,e			; $4cd8
	ld bc,$0134		; $4cd9
	cpl			; $4cdc
	ld bc,$0134		; $4cdd
	cpl			; $4ce0
	ld bc,$0134		; $4ce1
	dec c			; $4ce4
	dec b			; $4ce5
	nop			; $4ce6
	nop			; $4ce7
	ld c,$0d		; $4ce8
	inc (hl)		; $4cea
	ld bc,$332d		; $4ceb
	nop			; $4cee
	ld bc,$0201		; $4cef
	ld bc,$3403		; $4cf2
	ld bc,$013f		; $4cf5
	rst $38			; $4cf8
	nop			; $4cf9
	ld b,b			; $4cfa
	ld ($040d),sp		; $4cfb
	ccf			; $4cfe
	ld (bc),a		; $4cff
	ld b,$00		; $4d00
	xor c			; $4d02
	ld (bc),a		; $4d03
	ld de,$3f00		; $4d04
	nop			; $4d07
	rst $38			; $4d08
	nop			; $4d09
	ccf			; $4d0a
	ld ($00ff),sp		; $4d0b
	ccf			; $4d0e
	inc b			; $4d0f
	rst $38			; $4d10
	nop			; $4d11
	ld b,b			; $4d12
	stop			; $4d13
	add hl,bc		; $4d14
	jr _label_08_070		; $4d15
	stop			; $4d17
	ld a,(bc)		; $4d18
	stop			; $4d19
	ccf			; $4d1a
	nop			; $4d1b
	rst $38			; $4d1c
	nop			; $4d1d
	ccf			; $4d1e
	ld b,b			; $4d1f
	rst $38			; $4d20
	nop			; $4d21
	ld b,b			; $4d22
	jr nz,-$01		; $4d23
	nop			; $4d25
	ccf			; $4d26
	nop			; $4d27
	rst $38			; $4d28
	nop			; $4d29
	ld b,b			; $4d2a
	nop			; $4d2b
	rst $38			; $4d2c
	nop			; $4d2d
	ld b,b			; $4d2e
	ld bc,$00ff		; $4d2f
	ld b,b			; $4d32
	ld (bc),a		; $4d33
	rst $38			; $4d34
	nop			; $4d35
	ld b,b			; $4d36
	inc b			; $4d37
	rst $38			; $4d38
	nop			; $4d39
	xor c			; $4d3a
	ld bc,$0012		; $4d3b
	xor c			; $4d3e
	nop			; $4d3f
	rst $38			; $4d40
	nop			; $4d41
	ccf			; $4d42
	jr nz,_label_08_069	; $4d43
	nop			; $4d45
	ld b,(hl)		; $4d46
	ld c,h			; $4d47
_label_08_069:
	ld c,e			; $4d48
	rra			; $4d49
	ld c,l			; $4d4a
	ld l,h			; $4d4b
	ld c,e			; $4d4c
	ld l,l			; $4d4d
	ld c,e			; $4d4e
	ld l,l			; $4d4f
	ld c,e			; $4d50
	ldd (hl),a		; $4d51
	nop			; $4d52
	dec sp			; $4d53
	ld c,e			; $4d54
	ld d,h			; $4d55
	ld d,h			; $4d56
_label_08_070:
	jr nz,_label_08_071	; $4d57
	ld c,e			; $4d59

interactionCode4a:
	ld e,$44		; $4d5a
	ld a,(de)		; $4d5c
	rst_jumpTable			; $4d5d
	ld h,d			; $4d5e
	ld c,l			; $4d5f
	ld b,a			; $4d60
	ld c,(hl)		; $4d61
	call $4ddc		; $4d62
	ld e,$42		; $4d65
	ld a,(de)		; $4d67
	rst_jumpTable			; $4d68
	ld a,a			; $4d69
	ld c,l			; $4d6a
	ld a,a			; $4d6b
	ld c,l			; $4d6c
	ld a,a			; $4d6d
	ld c,l			; $4d6e
	sub l			; $4d6f
	ld c,l			; $4d70
	push de			; $4d71
	ld c,l			; $4d72
	call c,$dc4d		; $4d73
	ld c,l			; $4d76
	sub l			; $4d77
	ld c,l			; $4d78
	daa			; $4d79
_label_08_071:
	ld e,$a8		; $4d7a
	ld c,l			; $4d7c
	sub l			; $4d7d
	ld c,l			; $4d7e
	call getFreeInteractionSlot		; $4d7f
	jr nz,_label_08_072	; $4d82
	ld (hl),$4a		; $4d84
	inc l			; $4d86
	ld (hl),$04		; $4d87
	inc l			; $4d89
	ld e,$42		; $4d8a
	ld a,(de)		; $4d8c
	inc a			; $4d8d
	ld (hl),a		; $4d8e
	call $4f5d		; $4d8f
_label_08_072:
	jp objectSetVisible82		; $4d92
	ld e,$43		; $4d95
	ld a,(de)		; $4d97
	add a			; $4d98
	add a			; $4d99
	ld h,d			; $4d9a
	ld l,$60		; $4d9b
	add (hl)		; $4d9d
	ld (hl),a		; $4d9e
	call interactionSetAlwaysUpdateBit		; $4d9f
	call $4de3		; $4da2
	jp objectSetVisible80		; $4da5
	ld e,$43		; $4da8
	ld a,(de)		; $4daa
	ld hl,$4dcf		; $4dab
	rst_addDoubleIndex			; $4dae
	ldi a,(hl)		; $4daf
	ld e,$4b		; $4db0
	ld (de),a		; $4db2
	inc e			; $4db3
	inc e			; $4db4
	ld a,(hl)		; $4db5
	ld (de),a		; $4db6
	ld b,$03		; $4db7
_label_08_073:
	call getFreeInteractionSlot		; $4db9
	jr nz,_label_08_074	; $4dbc
	ld (hl),$4a		; $4dbe
	inc l			; $4dc0
	ld (hl),$0a		; $4dc1
	inc l			; $4dc3
	ld (hl),b		; $4dc4
	dec (hl)		; $4dc5
	call $4f5d		; $4dc6
	dec b			; $4dc9
	jr nz,_label_08_073	; $4dca
_label_08_074:
	jp objectSetVisible82		; $4dcc
	ld b,b			; $4dcf
	ld a,b			; $4dd0
	ld b,b			; $4dd1
	ld c,b			; $4dd2
	jr $60			; $4dd3
	call objectSetVisible83		; $4dd5
	xor $80			; $4dd8
	ld (de),a		; $4dda
	ret			; $4ddb
	ld h,d			; $4ddc
	ld l,$44		; $4ddd
	inc (hl)		; $4ddf
	jp interactionInitGraphics		; $4de0
	call objectGetRelatedObject1Var		; $4de3
	call objectTakePosition		; $4de6
	push bc			; $4de9
	ld e,$42		; $4dea
	ld a,(de)		; $4dec
	ld hl,$4e29		; $4ded
	cp $03			; $4df0
	jr z,_label_08_075	; $4df2
	cp $0a			; $4df4
	jr z,_label_08_075	; $4df6
	ld hl,$4e2f		; $4df8
	ld e,$47		; $4dfb
	ld a,(de)		; $4dfd
	inc a			; $4dfe
	ld (de),a		; $4dff
	and $03			; $4e00
	ld c,a			; $4e02
	add a			; $4e03
	add c			; $4e04
	rst_addDoubleIndex			; $4e05
_label_08_075:
	ld e,$43		; $4e06
	ld a,(de)		; $4e08
	rst_addDoubleIndex			; $4e09
	ldi a,(hl)		; $4e0a
	call $4e1f		; $4e0b
	ld b,a			; $4e0e
	ld e,$4b		; $4e0f
	ld a,(de)		; $4e11
	add b			; $4e12
	ld (de),a		; $4e13
	ld a,(hl)		; $4e14
	call $4e1f		; $4e15
	ld h,d			; $4e18
	ld l,$4d		; $4e19
	add (hl)		; $4e1b
	ld (hl),a		; $4e1c
	pop bc			; $4e1d
	ret			; $4e1e
	ld b,a			; $4e1f
	call getRandomNumber		; $4e20
	and $03			; $4e23
	sub $02			; $4e25
	add b			; $4e27
	ret			; $4e28
.DB $fc				; $4e29
.DB $fc				; $4e2a
	rlca			; $4e2b
	rst $38			; $4e2c
	rst $38			; $4e2d
	ld b,$f4		; $4e2e
.DB $f4				; $4e30
	ld c,$fe		; $4e31
	ld a,($fb09)		; $4e33
	ld a,($ff00+$09)	; $4e36
	rst $38			; $4e38
	inc b			; $4e39
	ld c,$06		; $4e3a
	ld hl,sp-$0c		; $4e3c
	ld ($070a),sp		; $4e3e
	dec bc			; $4e41
	ld a,($00f4)		; $4e42
	inc bc			; $4e45
	ld a,(bc)		; $4e46
	ld e,$42		; $4e47
	ld a,(de)		; $4e49
	cp $05			; $4e4a
	jr nc,_label_08_076	; $4e4c
	ld a,($cbb9)		; $4e4e
	cp $04			; $4e51
	jp z,interactionDelete		; $4e53
_label_08_076:
	ld a,(de)		; $4e56
	rst_jumpTable			; $4e57
	ld l,(hl)		; $4e58
	ld c,(hl)		; $4e59
	ld l,(hl)		; $4e5a
	ld c,(hl)		; $4e5b
	ld l,(hl)		; $4e5c
	ld c,(hl)		; $4e5d
	jr z,_label_08_078	; $4e5e
	ldd (hl),a		; $4e60
	ld c,a			; $4e61
	ldd (hl),a		; $4e62
	ld c,a			; $4e63
	ldd (hl),a		; $4e64
	ld c,a			; $4e65
	ld d,$4f		; $4e66
	ld c,(hl)		; $4e68
	ld c,a			; $4e69
	cp b			; $4e6a
	dec h			; $4e6b
	jr z,_label_08_081	; $4e6c
	ld e,$45		; $4e6e
	ld a,(de)		; $4e70
	rst_jumpTable			; $4e71
	ld a,(hl)		; $4e72
	ld c,(hl)		; $4e73
	sbc d			; $4e74
	ld c,(hl)		; $4e75
	call z,$e24e		; $4e76
	ld c,(hl)		; $4e79
	ld (bc),a		; $4e7a
	ld c,a			; $4e7b
	cp b			; $4e7c
	dec h			; $4e7d
	ld a,($cbb9)		; $4e7e
	cp $01			; $4e81
	jp nz,interactionAnimate		; $4e83
	ld b,$00		; $4e86
	ld e,$42		; $4e88
	ld a,(de)		; $4e8a
	cp $01			; $4e8b
	jr z,_label_08_077	; $4e8d
	ld b,$0a		; $4e8f
_label_08_077:
	call func_2d48		; $4e91
	call interactionIncState2		; $4e94
	ld l,$46		; $4e97
	ld (hl),b		; $4e99
	call interactionDecCounter1		; $4e9a
	jp nz,interactionAnimate		; $4e9d
	ld l,$42		; $4ea0
	ld a,(hl)		; $4ea2
	cp $01			; $4ea3
	jr nz,_label_08_079	; $4ea5
	ld l,$49		; $4ea7
	ld (hl),$00		; $4ea9
	ld l,$50		; $4eab
	ld (hl),$05		; $4ead
_label_08_078:
	ld b,$01		; $4eaf
	jr _label_08_082		; $4eb1
_label_08_079:
	or a			; $4eb3
	ld a,$18		; $4eb4
	jr z,_label_08_080	; $4eb6
	ld a,$08		; $4eb8
_label_08_080:
	ld l,$49		; $4eba
	ld (hl),a		; $4ebc
_label_08_081:
	ld l,$50		; $4ebd
	ld (hl),$05		; $4ebf
	ld b,$0b		; $4ec1
_label_08_082:
	call func_2d48		; $4ec3
	call interactionIncState2		; $4ec6
	ld l,$46		; $4ec9
	ld (hl),b		; $4ecb
	call interactionDecCounter1		; $4ecc
	jr nz,_label_08_083	; $4ecf
	ld b,$02		; $4ed1
	call func_2d48		; $4ed3
	call interactionIncState2		; $4ed6
	ld l,$46		; $4ed9
	ld (hl),b		; $4edb
_label_08_083:
	call objectApplySpeed		; $4edc
	jp interactionAnimate		; $4edf
	call interactionDecCounter1		; $4ee2
	jp nz,interactionAnimate		; $4ee5
	ld b,$03		; $4ee8
	call func_2d48		; $4eea
	call interactionIncState2		; $4eed
	ld l,$46		; $4ef0
	ld (hl),b		; $4ef2
	ld e,$42		; $4ef3
	ld a,(de)		; $4ef5
	cp $01			; $4ef6
	jr z,_label_08_084	; $4ef8
	jp interactionIncState2		; $4efa
_label_08_084:
	ld a,$5c		; $4efd
	jp playSound		; $4eff
	call interactionAnimate		; $4f02
	call interactionDecCounter1		; $4f05
	ret nz			; $4f08
	call interactionIncState2		; $4f09
	ld a,$02		; $4f0c
	ld ($cbb9),a		; $4f0e
	ld a,$7c		; $4f11
	jp playSound		; $4f13
	call objectSetVisible		; $4f16
	ld e,$43		; $4f19
	ld a,(de)		; $4f1b
	and $01			; $4f1c
	ld b,a			; $4f1e
	ld a,($cbb7)		; $4f1f
	and $01			; $4f22
	xor b			; $4f24
	call z,objectSetInvisible		; $4f25
	ld e,$61		; $4f28
	ld a,(de)		; $4f2a
	inc a			; $4f2b
	call z,$4de3		; $4f2c
	jp interactionAnimate		; $4f2f
	call interactionAnimate		; $4f32
	ld a,$00		; $4f35
	call objectGetRelatedObject1Var		; $4f37
	call objectTakePosition		; $4f3a
	ld e,$43		; $4f3d
	ld a,(de)		; $4f3f
	ld h,d			; $4f40
	ld l,$60		; $4f41
	cp (hl)			; $4f43
	ld l,$5a		; $4f44
	jr nz,_label_08_085	; $4f46
	set 7,(hl)		; $4f48
	ret			; $4f4a
_label_08_085:
	res 7,(hl)		; $4f4b
	ret			; $4f4d
	ld a,($c486)		; $4f4e
	or a			; $4f51
	jp z,interactionDelete		; $4f52
	ld b,a			; $4f55
	ld e,$4a		; $4f56
	ld a,(de)		; $4f58
	sub b			; $4f59
	inc e			; $4f5a
	ld (de),a		; $4f5b
	ret			; $4f5c
	ld l,$56		; $4f5d
	ld (hl),$40		; $4f5f
	inc l			; $4f61
	ld (hl),d		; $4f62
	ret			; $4f63

interactionCode50:
	ld e,$44		; $4f64
	ld a,(de)		; $4f66
	rst_jumpTable			; $4f67
	ld (hl),h		; $4f68
	ld c,a			; $4f69
	ld ($2e4f),a		; $4f6a
	ld d,b			; $4f6d
	ld d,e			; $4f6e
	ld d,b			; $4f6f
	ld a,h			; $4f70
	ld d,b			; $4f71
	adc c			; $4f72
	ld d,b			; $4f73
	ld e,$45		; $4f74
	ld a,(de)		; $4f76
	rst_jumpTable			; $4f77
	ld a,(hl)		; $4f78
	ld c,a			; $4f79
	sub l			; $4f7a
	ld c,a			; $4f7b
	and e			; $4f7c
	ld c,a			; $4f7d
	call interactionSetAlwaysUpdateBit		; $4f7e
	ld l,$45		; $4f81
	ld (hl),$01		; $4f83
	ld l,$46		; $4f85
	ld (hl),$01		; $4f87
	ld l,$4f		; $4f89
	ld (hl),$00		; $4f8b
	ld a,$0f		; $4f8d
	ld (wActiveMusic),a		; $4f8f
	jp playSound		; $4f92
	call interactionDecCounter1		; $4f95
	ret nz			; $4f98
	ld l,$45		; $4f99
	ld (hl),$02		; $4f9b
	ld l,$46		; $4f9d
	ld (hl),$10		; $4f9f
	jr _label_08_087		; $4fa1
	call interactionDecCounter1		; $4fa3
	ret nz			; $4fa6
	call interactionInitGraphics		; $4fa7
	call objectSetVisible80		; $4faa
	ld h,d			; $4fad
	ld l,$44		; $4fae
	ld (hl),$01		; $4fb0
	ld l,$45		; $4fb2
	ld (hl),$00		; $4fb4
	ld l,$43		; $4fb6
	ld a,(hl)		; $4fb8
	or a			; $4fb9
	jr nz,_label_08_086	; $4fba
	ld l,$46		; $4fbc
	ld (hl),$78		; $4fbe
	call $4fd3		; $4fc0
	jp $5079		; $4fc3
_label_08_086:
	ld l,$46		; $4fc6
	ld (hl),$3c		; $4fc8
	call $4fd8		; $4fca
	jp $5079		; $4fcd
_label_08_087:
	jp objectCreatePuff		; $4fd0
	ld bc,$8400		; $4fd3
	jr _label_08_088		; $4fd6
	ld bc,$8407		; $4fd8
	call objectCreateInteraction		; $4fdb
	ld e,$46		; $4fde
	ld a,(de)		; $4fe0
	ld l,e			; $4fe1
	ld (hl),a		; $4fe2
	ret			; $4fe3
	ld bc,$8401		; $4fe4
_label_08_088:
	jp objectCreateInteraction		; $4fe7
	call $50f6		; $4fea
	call interactionDecCounter1		; $4fed
	jr z,_label_08_089	; $4ff0
	call $5079		; $4ff2
	ld a,(wFrameCounter)		; $4ff5
	rrca			; $4ff8
	jp nc,objectSetInvisible		; $4ff9
	jp objectSetVisible		; $4ffc
_label_08_089:
	ld l,$43		; $4fff
	ld a,(hl)		; $5001
	or a			; $5002
	jr z,_label_08_090	; $5003
	ld l,$44		; $5005
	ld (hl),$05		; $5007
	ld hl,$cfc0		; $5009
	set 1,(hl)		; $500c
	call objectSetVisible		; $500e
	jr _label_08_092		; $5011
_label_08_090:
	ld l,$44		; $5013
	inc (hl)		; $5015
	ld l,$4f		; $5016
	ld (hl),$00		; $5018
	ld l,$7a		; $501a
	ld (hl),$30		; $501c
	ld l,$49		; $501e
	ld (hl),$00		; $5020
	ld l,$50		; $5022
	ld (hl),$14		; $5024
	call objectSetVisible		; $5026
	ld a,$4f		; $5029
	call playSound		; $502b
	call objectApplySpeed		; $502e
	ld h,d			; $5031
	ld l,$4b		; $5032
	ld a,(hl)		; $5034
	cp $10			; $5035
	jr nc,_label_08_092	; $5037
	ld l,$44		; $5039
	inc (hl)		; $503b
	ld l,$46		; $503c
	ld (hl),$04		; $503e
	ld l,$7b		; $5040
	ld (hl),$00		; $5042
	ld a,($d00b)		; $5044
	ld l,$4b		; $5047
	ld (hl),a		; $5049
	ld a,($d00d)		; $504a
	ld l,$4d		; $504d
	ld (hl),a		; $504f
	call $50b4		; $5050
	call $50dd		; $5053
	jr c,_label_08_091	; $5056
	call $5099		; $5058
	call $50c2		; $505b
	ld a,(de)		; $505e
	ld e,$7b		; $505f
	call objectSetPositionInCircleArc		; $5061
	call $50d0		; $5064
	ld a,(wFrameCounter)		; $5067
	and $07			; $506a
	call z,$4fe4		; $506c
	jr _label_08_092		; $506f
_label_08_091:
	ld l,$44		; $5071
	inc (hl)		; $5073
	ld hl,$cfc0		; $5074
	set 1,(hl)		; $5077
_label_08_092:
	jp interactionAnimate		; $5079
	call $50f6		; $507c
	ld a,($cfc0)		; $507f
	cp $07			; $5082
	jp z,interactionDelete		; $5084
	jr _label_08_092		; $5087
	call $50f6		; $5089
	ld a,($cfc0)		; $508c
	cp $07			; $508f
	jr nz,_label_08_092	; $5091
	call $4fd0		; $5093
	jp interactionDelete		; $5096
	ld l,$4b		; $5099
	ld e,$78		; $509b
	ld a,(de)		; $509d
	ldi (hl),a		; $509e
	inc l			; $509f
	inc e			; $50a0
	ld a,(de)		; $50a1
	ld (hl),a		; $50a2
	ld a,($d00b)		; $50a3
	ld b,a			; $50a6
	ld a,($d00d)		; $50a7
	ld c,a			; $50aa
	call objectGetRelativeAngle		; $50ab
	ld e,$49		; $50ae
	ld (de),a		; $50b0
	call objectApplySpeed		; $50b1
	ld h,d			; $50b4
	ld l,$4b		; $50b5
	ld e,$78		; $50b7
	ldi a,(hl)		; $50b9
	ld (de),a		; $50ba
	ld b,a			; $50bb
	inc l			; $50bc
	inc e			; $50bd
	ld a,(hl)		; $50be
	ld (de),a		; $50bf
	ld c,a			; $50c0
	ret			; $50c1
	ld e,$7a		; $50c2
	ld a,(de)		; $50c4
	or a			; $50c5
	ret z			; $50c6
	call interactionDecCounter1		; $50c7
	ret nz			; $50ca
	ld (hl),$04		; $50cb
	ld l,e			; $50cd
	dec (hl)		; $50ce
	ret			; $50cf
	ld a,(wFrameCounter)		; $50d0
	rrca			; $50d3
	ret nc			; $50d4
	ld e,$7b		; $50d5
	ld a,(de)		; $50d7
	inc a			; $50d8
	and $1f			; $50d9
	ld (de),a		; $50db
	ret			; $50dc
	ld h,d			; $50dd
	ld l,$4b		; $50de
	ld a,($d00b)		; $50e0
	add $f0			; $50e3
	sub (hl)		; $50e5
	add $04			; $50e6
	cp $09			; $50e8
	ret nc			; $50ea
	ld l,$4d		; $50eb
	ld a,($d00d)		; $50ed
	sub (hl)		; $50f0
	add $02			; $50f1
	cp $05			; $50f3
	ret			; $50f5
objectOscillateZ_body:
	ld a,(wFrameCounter)		; $50f6
	and $07			; $50f9
	ret nz			; $50fb
	ld a,(wFrameCounter)		; $50fc
	and $38			; $50ff
	swap a			; $5101
	rlca			; $5103
	ld hl,$510d		; $5104
	rst_addAToHl			; $5107
	ld e,$4f		; $5108
	ld a,(hl)		; $510a
	ld (de),a		; $510b
	ret			; $510c
	rst $38			; $510d
	cp $ff			; $510e
	nop			; $5110
	ld bc,$0102		; $5111
	nop			; $5114

interactionCode56:
	call checkInteractionState		; $5115
	jr z,_label_08_093	; $5118
	ld e,$61		; $511a
	ld a,(de)		; $511c
	inc a			; $511d
	jp nz,interactionAnimate		; $511e
	jp interactionDelete		; $5121
_label_08_093:
	inc a			; $5124
	ld (de),a		; $5125
	call interactionInitGraphics		; $5126
	ld a,$6f		; $5129
	call playSound		; $512b
	ld e,$43		; $512e
	ld a,(de)		; $5130
	rrca			; $5131
	jp c,objectSetVisible81		; $5132
	jp objectSetVisible82		; $5135

interactionCode15:
	ld a,(wMenuDisabled)		; $5138
	ld b,a			; $513b
	ld a,(wLinkDeathTrigger)		; $513c
	or b			; $513f
	jr nz,+			; $5140
	ld a,(wActiveGroup)		; $5142
	or a			; $5145
	jr nz,+			; $5146
	ld hl,wObtainedSeasons		; $5148
	ld a,(hl)		; $514b
	add a			; $514c
	jr z,+			; $514d
	ld a,(wRoomStateModifier)		; $514f
_label_08_094:
	inc a			; $5152
	and $03			; $5153
	ld b,a			; $5155
	call checkFlag		; $5156
	ld a,b			; $5159
	jr z,_label_08_094	; $515a
	call seasonsFunc_3a9c		; $515c
	ld a,SND_ENERGYTHING		; $515f
	call playSound		; $5161
	ld a,$02		; $5164
	ld (wPaletteThread_updateRate),a		; $5166
+
	jp interactionDelete		; $5169

interactionCode1f:
	ld e,$42		; $516c
	ld a,(de)		; $516e
	rst_jumpTable			; $516f
	adc h			; $5170
	ld d,c			; $5171
	adc h			; $5172
	ld d,c			; $5173
	or (hl)			; $5174
	ld d,c			; $5175
	or (hl)			; $5176
	ld d,c			; $5177
	or (hl)			; $5178
	ld d,c			; $5179
	dec (hl)		; $517a
	ld d,d			; $517b
	dec (hl)		; $517c
	ld d,d			; $517d
	dec (hl)		; $517e
	ld d,d			; $517f
	ld l,e			; $5180
	ld d,d			; $5181
	ld l,e			; $5182
	ld d,d			; $5183
	ld l,e			; $5184
	ld d,d			; $5185
	ld l,e			; $5186
	ld d,d			; $5187
	ld l,e			; $5188
	ld d,d			; $5189
	xor (hl)		; $518a
	ld d,d			; $518b
	call checkInteractionState		; $518c
	jr nz,_label_08_096	; $518f
	ld a,($cd00)		; $5191
	and $01			; $5194
	ret z			; $5196
	ld a,$01		; $5197
	ld (de),a		; $5199
	call objectGetTileAtPosition		; $519a
	ld (hl),$20		; $519d
_label_08_096:
	ld a,($cc77)		; $519f
	or a			; $51a2
	ret nz			; $51a3
	call objectGetTileAtPosition		; $51a4
	ld a,($ccb3)		; $51a7
	cp l			; $51aa
	ret nz			; $51ab
	ld (hl),$eb		; $51ac
	ld a,$81		; $51ae
	ld ($cca4),a		; $51b0
	jp interactionDelete		; $51b3
	ld e,$44		; $51b6
	ld a,(de)		; $51b8
	rst_jumpTable			; $51b9
	ret nz			; $51ba
	ld d,c			; $51bb
.DB $fd				; $51bc
	ld d,c			; $51bd
	dec hl			; $51be
	ld d,d			; $51bf
	ld e,$42		; $51c0
	ld a,(de)		; $51c2
	sub $02			; $51c3
	add a			; $51c5
	ld hl,$51e5		; $51c6
	rst_addDoubleIndex			; $51c9
	ld e,$70		; $51ca
	ld b,$03		; $51cc
	call copyMemory		; $51ce
	ld e,$67		; $51d1
	ldi a,(hl)		; $51d3
	ld (de),a		; $51d4
	dec e			; $51d5
	ld a,$0a		; $51d6
	ld (de),a		; $51d8
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $51d9
	ld a,$01		; $51dc
	jr nc,_label_08_097	; $51de
	inc a			; $51e0
_label_08_097:
	ld e,$44		; $51e1
	ld (de),a		; $51e3
	ret			; $51e4
	dec b			; $51e5
	cp h			; $51e6
	sub a			; $51e7
	stop			; $51e8
	dec b			; $51e9
	cp l			; $51ea
	sub a			; $51eb
	jr $05			; $51ec
	dec c			; $51ee
	sub a			; $51ef
	jr _label_08_098		; $51f0
_label_08_098:
	ld l,$61		; $51f2
	nop			; $51f4
	nop			; $51f5
	ld l,$75		; $51f6
	nop			; $51f8
	nop			; $51f9
	ld e,d			; $51fa
	ld d,h			; $51fb
	nop			; $51fc
	ld a,d			; $51fd
	ld ($ccaa),a		; $51fe
	ld a,($cc48)		; $5201
	cp $d1			; $5204
	ret nz			; $5206
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $5207
	ret nc			; $520a
	xor a			; $520b
	ld ($cc65),a		; $520c
_label_08_099:
	ld h,d			; $520f
	ld l,$70		; $5210
	ldi a,(hl)		; $5212
	ld ($cc63),a		; $5213
	ldi a,(hl)		; $5216
	ld ($cc64),a		; $5217
	ld a,(hl)		; $521a
	ld ($cc66),a		; $521b
	ld a,$03		; $521e
	ld ($cc67),a		; $5220
	ld a,$01		; $5223
	ld ($cd00),a		; $5225
	jp interactionDelete		; $5228
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $522b
	ret c			; $522e
	ld e,$44		; $522f
	ld a,$01		; $5231
	ld (de),a		; $5233
	ret			; $5234
	ld e,$44		; $5235
	ld a,(de)		; $5237
	rst_jumpTable			; $5238
	ccf			; $5239
	ld d,d			; $523a
	ld c,c			; $523b
	ld d,d			; $523c
	ld c,c			; $523d
	ld d,d			; $523e
	call $51c0		; $523f
	xor a			; $5242
	ld (wActiveMusic),a		; $5243
	jp interactionSetAlwaysUpdateBit		; $5246
	ld a,d			; $5249
	ld ($ccab),a		; $524a
	ld a,($cc48)		; $524d
	cp $d1			; $5250
	ret nz			; $5252
	xor a			; $5253
	ld ($ccab),a		; $5254
	ld a,($cd00)		; $5257
	and $01			; $525a
	ret nz			; $525c
	xor a			; $525d
	ld ($cd00),a		; $525e
	ld a,$ff		; $5261
	ld ($cca4),a		; $5263
	ld (wActiveMusic),a		; $5266
	jr _label_08_099		; $5269
	call checkInteractionState		; $526b
	jr nz,_label_08_100	; $526e
	ld a,$01		; $5270
	ld (de),a		; $5272
	ld a,$02		; $5273
	call objectSetCollideRadius		; $5275
_label_08_100:
	ld a,($cc78)		; $5278
	rlca			; $527b
	ret nc			; $527c
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $527d
	ret nc			; $5280
	ld e,$42		; $5281
	ld a,(de)		; $5283
	sub $08			; $5284
	ld hl,$52a4		; $5286
	rst_addDoubleIndex			; $5289
	ldi a,(hl)		; $528a
	ld ($cc64),a		; $528b
	ld a,(hl)		; $528e
	ld ($cc66),a		; $528f
	ld a,$87		; $5292
	ld ($cc63),a		; $5294
	ld a,$01		; $5297
	ld ($cc65),a		; $5299
_label_08_101:
	ld a,$03		; $529c
	ld ($cc67),a		; $529e
	jp interactionDelete		; $52a1
	ld ($ff00+$02),a	; $52a4
	pop hl			; $52a6
	dec bc			; $52a7
.DB $e4				; $52a8
	ld (bc),a		; $52a9
	and $02			; $52aa
	rst $20			; $52ac
	dec c			; $52ad
	call checkInteractionState		; $52ae
	jr nz,_label_08_102	; $52b1
	ld a,$01		; $52b3
	ld (de),a		; $52b5
	ld a,$02		; $52b6
	call objectSetCollideRadius		; $52b8
_label_08_102:
	ld a,($cc78)		; $52bb
	rlca			; $52be
	ret nc			; $52bf
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $52c0
	ret nc			; $52c3
	ld hl,$cc63		; $52c4
	ld (hl),$85		; $52c7
	inc l			; $52c9
	ld (hl),$12		; $52ca
	inc l			; $52cc
	ld (hl),$05		; $52cd
	inc l			; $52cf
	ld (hl),$29		; $52d0
	jr _label_08_101		; $52d2


; ==============================================================================
; INTERACID_DUNGEON_SCRIPT
; ==============================================================================
interactionCode20:
	call interactionDeleteAndRetIfEnabled02		; $52d4
	ld e,Interaction.state		; $52d7
	ld a,(de)		; $52d9
	rst_jumpTable			; $52da
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $52e1
	ld (de),a		; $52e3
	xor a			; $52e4
	ld ($cfc1),a		; $52e5
	ld ($cfc2),a		; $52e8

	ld a,(wDungeonIndex)		; $52eb
	cp $ff			; $52ee
	jp z,interactionDelete		; $52f0

	ld hl,@scriptTable		; $52f3
	rst_addDoubleIndex			; $52f6
	ldi a,(hl)		; $52f7
	ld h,(hl)		; $52f8
	ld l,a			; $52f9
	ld e,Interaction.subid		; $52fa
	ld a,(de)		; $52fc
	rst_addDoubleIndex			; $52fd
	ldi a,(hl)		; $52fe
	ld h,(hl)		; $52ff
	ld l,a			; $5300
	call interactionSetScript		; $5301
	jp interactionRunScript		; $5304

@state2:
	call objectPreventLinkFromPassing		; $5307

@state1:
	call interactionRunScript		; $530a
	ret nc			; $530d
	jp interactionDelete		; $530e

@scriptTable:
	.dw @dungeon0
	.dw @dungeon1
	.dw @dungeon2
	.dw @dungeon3
	.dw @dungeon4
	.dw @dungeon5
	.dw @dungeon6
	.dw @dungeon7
	.dw @dungeon8
	.dw @dungeon9
	.dw @dungeonA
	.dw @dungeonB

@dungeon0:
	.dw script4b77
	.dw script4b78

@dungeon1:
	.dw script4b69
	.dw script4b78
	.dw script4b78
	.dw script4b84

@dungeon2:
	.dw script4b97
	.dw script4b69
	.dw script4ba6

@dungeon3:
	.dw script4bb9
	.dw script4bc4
	.dw script4bca
	.dw script4bd9
	.dw script4be8

@dungeon4:
	.dw script4bec
	.dw script4bfb
	.dw script4bfb
	.dw script4c09
	.dw script4b84
	.dw script4b69
	.dw script4c0e
	.dw script4c17

@dungeon5:
	.dw script4c20
	.dw script4c25
	.dw script4b69
	.dw script4b84

@dungeon6:
	.dw script4c2b
	.dw script4c34
	.dw script4c47
	.dw script4c50
	.dw script4c58
	.dw script4c63
	.dw script4c6b
	.dw script4b69
	.dw script4c6f
	.dw script4c90
	.dw script4c94
	.dw script4ca5
	.dw script4cb5
	.dw script4cc0
	.dw script4ccf

@dungeon7:
	.dw script4ce6
	.dw script4cf2
	.dw script4b69
	.dw script4b84
	.dw script4d05
	.dw script4d12
	.dw script4d16
	.dw script4d28
	.dw script4d2c
	.dw script4d30
	.dw script4d44
	.dw script4d53
	.dw script4ce8
	.dw script4cd3
	.dw script4cdc

@dungeon8:
	.dw script4d5b
	.dw script4d64
	.dw script4d6d
	.dw script4c2b
	.dw script4d7a
	.dw script4d8c
	.dw script4d96
	.dw script4b69
	.dw script4b84
	.dw script4dab
	.dw script4db4
	.dw script4dbb

@dungeon9:
	.dw script4dc2
	.dw script4dc9

@dungeonA:
@dungeonB:
	.dw script4c2b
	.dw script4b78
	.dw script4dcd
	.dw script4d16
	.dw script4ddb
	.dw script4ddf
	.dw script4dd4

interactionCode21:
	ld e,$44		; $53c3
	ld a,(de)		; $53c5
	rst_jumpTable			; $53c6
	pop de			; $53c7
	ld d,e			; $53c8
	inc c			; $53c9
	dec h			; $53ca
.DB $ec				; $53cb
	ld d,e			; $53cc
	ld bc,$3754		; $53cd
	ld d,h			; $53d0
	call getThisRoomFlags		; $53d1
	bit 7,a			; $53d4
	jp nz,interactionDelete		; $53d6
	ld e,$44		; $53d9
	ld a,$01		; $53db
	ld (de),a		; $53dd
	ld a,$01		; $53de
	ld ($ccaa),a		; $53e0
	call $5469		; $53e3
	ld hl,$4dea		; $53e6
	jp interactionSetScript		; $53e9
	call interactionIncState		; $53ec
	ld l,$46		; $53ef
	ld (hl),$1e		; $53f1
	call setLinkForceStateToState08		; $53f3
	ld a,($cca4)		; $53f6
	or $80			; $53f9
	ld ($cca4),a		; $53fb
	call $545d		; $53fe
	call $54ae		; $5401
	call interactionDecCounter1		; $5404
	jr nz,_label_08_106	; $5407
	ld l,$47		; $5409
	ld a,(hl)		; $540b
	cp $04			; $540c
	jr nc,_label_08_104	; $540e
	inc (hl)		; $5410
	ld a,(hl)		; $5411
	call $549d		; $5412
	ld a,$82		; $5415
	call playSound		; $5417
	ld e,$47		; $541a
	ld a,(de)		; $541c
	ld hl,$542d		; $541d
	rst_addDoubleIndex			; $5420
	dec e			; $5421
	ldi a,(hl)		; $5422
	ld (de),a		; $5423
	ld a,(hl)		; $5424
	or a			; $5425
	jr z,_label_08_107	; $5426
_label_08_104:
	ld l,$44		; $5428
	inc (hl)		; $542a
	jr _label_08_107		; $542b
	ld e,$00		; $542d
	inc a			; $542f
	nop			; $5430
	dec l			; $5431
	nop			; $5432
	jr z,_label_08_105	; $5433
_label_08_105:
	inc hl			; $5435
	nop			; $5436
	ld a,$09		; $5437
	ld hl,$5482		; $5439
	ld bc,$5494		; $543c
	call $5471		; $543f
	xor a			; $5442
	ld ($ccaa),a		; $5443
	ld ($cca4),a		; $5446
	ld ($cc02),a		; $5449
	ld a,$4d		; $544c
	call playSound		; $544e
	ld a,($cc62)		; $5451
	ld (wActiveMusic),a		; $5454
	call playSound		; $5457
	jp interactionDelete		; $545a
_label_08_106:
	ld a,$0f		; $545d
	ld ($cd19),a		; $545f
	ret			; $5462
_label_08_107:
	ld a,$04		; $5463
	ld ($cd18),a		; $5465
	ret			; $5468
	ld a,$09		; $5469
	ld hl,$5482		; $546b
	ld bc,$548b		; $546e
	ld d,$ce		; $5471
	ld e,a			; $5473
_label_08_108:
	push de			; $5474
	ldi a,(hl)		; $5475
	ld e,a			; $5476
	ld a,(bc)		; $5477
	inc bc			; $5478
	ld (de),a		; $5479
	pop de			; $547a
	dec e			; $547b
	jr nz,_label_08_108	; $547c
	ldh a,(<hActiveObject)	; $547e
	ld d,a			; $5480
	ret			; $5481
	inc hl			; $5482
	inc h			; $5483
	dec h			; $5484
	inc sp			; $5485
	inc (hl)		; $5486
	dec (hl)		; $5487
	ld b,e			; $5488
	ld b,h			; $5489
	ld b,l			; $548a
	nop			; $548b
	nop			; $548c
	nop			; $548d
	nop			; $548e
	nop			; $548f
	nop			; $5490
	inc b			; $5491
	inc c			; $5492
	ld ($0301),sp		; $5493
	ld (bc),a		; $5496
	rrca			; $5497
	rrca			; $5498
	rrca			; $5499
	rrca			; $549a
	inc c			; $549b
	rrca			; $549c
	ld hl,$54a9		; $549d
	rst_addAToHl			; $54a0
	ld a,(hl)		; $54a1
	call uniqueGfxFunc_380b		; $54a2
	ldh a,(<hActiveObject)	; $54a5
	ld d,a			; $54a7
	ret			; $54a8
	jr nz,_label_08_109	; $54a9
	ldi (hl),a		; $54ab
	inc hl			; $54ac
	inc b			; $54ad
	ld a,(wFrameCounter)		; $54ae
	and $01			; $54b1
	ret nz			; $54b3
	call getRandomNumber_noPreserveVars		; $54b4
	ld e,a			; $54b7
	call getFreeInteractionSlot		; $54b8
	ret nz			; $54bb
	ld (hl),$4b		; $54bc
	inc l			; $54be
	ld a,(wFrameCounter)		; $54bf
	and $06			; $54c2
	rrca			; $54c4
	ld bc,$54e4		; $54c5
	call addAToBc		; $54c8
	ld a,(bc)		; $54cb
_label_08_109:
	ld (hl),a		; $54cc
	ld l,$4b		; $54cd
	ld a,e			; $54cf
	and $07			; $54d0
	sub $04			; $54d2
	add $48			; $54d4
	ldi (hl),a		; $54d6
	inc l			; $54d7
	ld a,e			; $54d8
	and $f8			; $54d9
	swap a			; $54db
	rlca			; $54dd
	sub $10			; $54de
	add $48			; $54e0
	ld (hl),a		; $54e2
	ret			; $54e3
	nop			; $54e4
	ld bc,$0000		; $54e5

interactionCode22:
	ld e,$44		; $54e8
	ld a,(de)		; $54ea
	rst_jumpTable			; $54eb
	ld a,($ff00+c)		; $54ec
	ld d,h			; $54ed
	ld (hl),b		; $54ee
	ld d,l			; $54ef
	ld (hl),a		; $54f0
	ld d,l			; $54f1
	ld e,$42		; $54f2
	ld a,(de)		; $54f4
	cp $08			; $54f5
	jr z,_label_08_111	; $54f7
	cp $09			; $54f9
	jr z,_label_08_112	; $54fb
	jr nc,_label_08_113	; $54fd
	call getThisRoomFlags		; $54ff
	and $40			; $5502
	jp nz,interactionDelete		; $5504
	call $55f5		; $5507
	jp z,interactionDelete		; $550a
	call returnIfScrollMode01Unset		; $550d
	call $555e		; $5510
	call interactionRunScript		; $5513
	call interactionRunScript		; $5516
	ld e,$42		; $5519
	ld a,(de)		; $551b
	cp $07			; $551c
	jr z,_label_08_110	; $551e
	call seasonsFunc_3e20		; $5520
	jr _label_08_114		; $5523
_label_08_110:
	ld hl,$c6e5		; $5525
	ld (hl),$16		; $5528
	jr _label_08_114		; $552a
_label_08_111:
	call getThisRoomFlags		; $552c
	and $40			; $552f
	jp nz,interactionDelete		; $5531
	ld a,$07		; $5534
	call checkTreasureObtained		; $5536
	jp nc,interactionDelete		; $5539
	ld a,($c6b0)		; $553c
	add a			; $553f
	jp z,interactionDelete		; $5540
_label_08_112:
	call $555e		; $5543
	call interactionRunScript		; $5546
	call interactionRunScript		; $5549
	call seasonsFunc_3e20		; $554c
	jr _label_08_114		; $554f
_label_08_113:
	call getThisRoomFlags		; $5551
	and $80			; $5554
	jp nz,interactionDelete		; $5556
	call $555e		; $5559
	jr _label_08_114		; $555c
	ld e,$44		; $555e
	ld a,$01		; $5560
	ld (de),a		; $5562
	ld e,$42		; $5563
	ld a,(de)		; $5565
	ld hl,$564f		; $5566
	rst_addDoubleIndex			; $5569
	ldi a,(hl)		; $556a
	ld h,(hl)		; $556b
	ld l,a			; $556c
	jp interactionSetScript		; $556d
_label_08_114:
	call interactionRunScript		; $5570
	jp c,interactionDelete		; $5573
	ret			; $5576
	ld e,$45		; $5577
	ld a,(de)		; $5579
	rst_jumpTable			; $557a
	ld a,a			; $557b
	ld d,l			; $557c
	cp b			; $557d
	ld d,l			; $557e
	ld hl,$55e5		; $557f
	ld b,$04		; $5582
_label_08_115:
	ldi a,(hl)		; $5584
	ldh (<hFF8C),a	; $5585
	ldi a,(hl)		; $5587
	ldh (<hFF8F),a	; $5588
	ldi a,(hl)		; $558a
	ldh (<hFF8E),a	; $558b
	ldi a,(hl)		; $558d
	push hl			; $558e
	push bc			; $558f
	call setInterleavedTile		; $5590
	pop bc			; $5593
	pop hl			; $5594
	dec b			; $5595
	jr nz,_label_08_115	; $5596
	ldh a,(<hActiveObject)	; $5598
	ld d,a			; $559a
	ld e,$45		; $559b
	ld a,$01		; $559d
	ld (de),a		; $559f
	ld e,$46		; $55a0
	ld a,$1e		; $55a2
	ld (de),a		; $55a4
	xor a			; $55a5
	call $561f		; $55a6
	ld a,$73		; $55a9
	call playSound		; $55ab
_label_08_116:
	ld a,$06		; $55ae
	call setScreenShakeCounter		; $55b0
	ld a,$70		; $55b3
	jp playSound		; $55b5
	call interactionDecCounter1		; $55b8
	ret nz			; $55bb
	ld hl,$55e5		; $55bc
	ld b,$04		; $55bf
_label_08_117:
	ldi a,(hl)		; $55c1
	ld c,a			; $55c2
	ld a,(hl)		; $55c3
	push hl			; $55c4
	push bc			; $55c5
	call setTile		; $55c6
	pop bc			; $55c9
	pop hl			; $55ca
	inc hl			; $55cb
	inc hl			; $55cc
	inc hl			; $55cd
	dec b			; $55ce
	jr nz,_label_08_117	; $55cf
	ld e,$44		; $55d1
	ld a,$01		; $55d3
	ld (de),a		; $55d5
	xor a			; $55d6
	inc e			; $55d7
	ld (de),a		; $55d8
	ld a,$04		; $55d9
	call $561f		; $55db
	ld a,$73		; $55de
	call playSound		; $55e0
	jr _label_08_116		; $55e3
	inc d			; $55e5
	cp a			; $55e6
	and b			; $55e7
	inc bc			; $55e8
	dec d			; $55e9
	cp a			; $55ea
	and b			; $55eb
	ld bc,$a924		; $55ec
	and c			; $55ef
	inc bc			; $55f0
	dec h			; $55f1
	xor d			; $55f2
	and c			; $55f3
	ld bc,$403e		; $55f4
	call checkTreasureObtained		; $55f7
	jr nc,_label_08_118	; $55fa
	ld e,$7e		; $55fc
	ld (de),a		; $55fe
	call $5610		; $55ff
	ld c,a			; $5602
	ld e,$42		; $5603
	ld a,(de)		; $5605
	ld hl,bitTable		; $5606
	add l			; $5609
	ld l,a			; $560a
	ld a,c			; $560b
	and (hl)		; $560c
	ret			; $560d
_label_08_118:
	xor a			; $560e
	ret			; $560f
	push af			; $5610
	ld hl,$c6df		; $5611
	ld (hl),$00		; $5614
_label_08_119:
	add a			; $5616
	jr nc,_label_08_120	; $5617
	inc (hl)		; $5619
_label_08_120:
	or a			; $561a
	jr nz,_label_08_119	; $561b
	pop af			; $561d
	ret			; $561e
	ld bc,$563f		; $561f
	call addDoubleIndexToBc		; $5622
	ld a,$04		; $5625
_label_08_121:
	ldh (<hFF8B),a	; $5627
	call getFreeInteractionSlot		; $5629
	ret nz			; $562c
	ld (hl),$05		; $562d
	ld l,$4b		; $562f
	ld a,(bc)		; $5631
	ld (hl),a		; $5632
	inc bc			; $5633
	ld l,$4d		; $5634
	ld a,(bc)		; $5636
	ld (hl),a		; $5637
	inc bc			; $5638
	ldh a,(<hFF8B)	; $5639
	dec a			; $563b
	jr nz,_label_08_121	; $563c
	ret			; $563e
	jr $48			; $563f
	jr $58			; $5641
	jr z,_label_08_122	; $5643
	jr z,$58		; $5645
	jr $40			; $5647
	jr _label_08_124		; $5649
	jr z,_label_08_122	; $564b
	jr z,_label_08_125	; $564d
	rst $30			; $564f
	ld c,l			; $5650
	rst $30			; $5651
	ld c,l			; $5652
	rst $30			; $5653
	ld c,l			; $5654
	rst $30			; $5655
	ld c,l			; $5656
	rst $30			; $5657
	ld c,l			; $5658
	rst $30			; $5659
	ld c,l			; $565a
	rst $30			; $565b
	ld c,l			; $565c
	rst $30			; $565d
	ld c,l			; $565e
	rst $30			; $565f
	ld c,l			; $5660
	ld a,($874d)		; $5661
	ld c,(hl)		; $5664

interactionCode23:
	ld e,$45		; $5665
	ld a,(de)		; $5667
	rst_jumpTable			; $5668
	ld l,l			; $5669
	ld d,(hl)		; $566a
	sbc (hl)		; $566b
	ld d,(hl)		; $566c
	ld a,$01		; $566d
	ld (de),a		; $566f
	ld a,$08		; $5670
	call interactionSetHighTextIndex		; $5672
	ld e,$42		; $5675
	ld a,(de)		; $5677
	ld b,a			; $5678
	swap a			; $5679
	and $0f			; $567b
	ld e,$43		; $567d
	ld (de),a		; $567f
	ld hl,$56a5		; $5680
	rst_addDoubleIndex			; $5683
	ldi a,(hl)		; $5684
	ld h,(hl)		; $5685
	ld l,a			; $5686
	ld a,b			; $5687
	and $0f			; $5688
	rst_addDoubleIndex			; $568a
	ldi a,(hl)		; $568b
	ld h,(hl)		; $568c
_label_08_122:
	ld l,a			; $568d
	call interactionSetScript		; $568e
	ld e,$7e		; $5691
	ld a,($c6df)		; $5693
	cp $09			; $5696
	ld a,$00		; $5698
	jr c,_label_08_123	; $569a
	inc a			; $569c
_label_08_123:
	ld (de),a		; $569d
	call interactionRunScript		; $569e
	jp c,interactionDelete		; $56a1
	ret			; $56a4
	xor a			; $56a5
	ld d,(hl)		; $56a6
	xor a			; $56a7
	ld d,(hl)		; $56a8
	xor a			; $56a9
	ld d,(hl)		; $56aa
_label_08_124:
	xor a			; $56ab
	ld d,(hl)		; $56ac
	or e			; $56ad
	ld d,(hl)		; $56ae
_label_08_125:
	xor c			; $56af
	ld c,(hl)		; $56b0
	xor l			; $56b1
	ld c,(hl)		; $56b2
	and l			; $56b3
	ld c,(hl)		; $56b4

interactionCode24:
interactionCode29:
interactionCode2c:
interactionCode2d:
interactionCode2f:
interactionCode33:
interactionCode36:
interactionCode37:
interactionCode38:
interactionCode39:
interactionCode3a:
interactionCode3c:
interactionCode3d:
interactionCode3f:
	ld e,$44		; $56b5
	ld a,(de)		; $56b7
	rst_jumpTable			; $56b8
	cp l			; $56b9
	ld d,(hl)		; $56ba
	xor e			; $56bb
	ld d,a			; $56bc
	ld a,$01		; $56bd
	ld (de),a		; $56bf
	ld h,d			; $56c0
	ld l,$42		; $56c1
	ldi a,(hl)		; $56c3
	bit 7,a			; $56c4
	jr z,_label_08_126	; $56c6
	ldd (hl),a		; $56c8
	and $7f			; $56c9
	ld (hl),a		; $56cb
_label_08_126:
	call $57b9		; $56cc
	jr nz,_label_08_127	; $56cf
	jp nc,interactionDelete		; $56d1
	jr _label_08_128		; $56d4
_label_08_127:
	call $5866		; $56d6
	jr nz,_label_08_129	; $56d9
	ld e,$42		; $56db
	ld a,(de)		; $56dd
	cp b			; $56de
	jp nz,interactionDelete		; $56df
_label_08_128:
	ld e,$42		; $56e2
	ld a,b			; $56e4
	ld (de),a		; $56e5
_label_08_129:
	call interactionInitGraphics		; $56e6
	ld e,$41		; $56e9
	ld a,(de)		; $56eb
	cp $24			; $56ec
	jr nz,_label_08_130	; $56ee
	call $5777		; $56f0
	jp z,interactionDelete		; $56f3
_label_08_130:
	sub $24			; $56f6
	ld hl,$594a		; $56f8
	rst_addDoubleIndex			; $56fb
	ldi a,(hl)		; $56fc
	ld h,(hl)		; $56fd
	ld l,a			; $56fe
	ld e,$42		; $56ff
	ld a,(de)		; $5701
	rst_addDoubleIndex			; $5702
	ldi a,(hl)		; $5703
	ld h,(hl)		; $5704
	ld l,a			; $5705
	call interactionSetScript		; $5706
	ld e,$41		; $5709
	ld a,(de)		; $570b
	cp $38			; $570c
	jp z,$574e		; $570e
	cp $2c			; $5711
	jp z,$5732		; $5713
	cp $33			; $5716
	call z,$572c		; $5718
	ld e,$41		; $571b
	ld a,(de)		; $571d
	cp $36			; $571e
	call z,$572c		; $5720
	xor a			; $5723
	ld h,d			; $5724
	ld l,$78		; $5725
	ldi (hl),a		; $5727
	ld (hl),a		; $5728
	jp interactionAnimateAsNpc		; $5729
	call interactionRunScript		; $572c
	jp interactionRunScript		; $572f
	call getThisRoomFlags		; $5732
	and $40			; $5735
	jr z,_label_08_131	; $5737
	jp $5723		; $5739
_label_08_131:
	call getFreePartSlot		; $573c
	jr nz,_label_08_132	; $573f
	ld (hl),$06		; $5741
	ld l,$cb		; $5743
	ld (hl),$38		; $5745
	ld l,$cd		; $5747
	ld (hl),$68		; $5749
_label_08_132:
	jp $5723		; $574b
	ld e,$42		; $574e
	ld a,(de)		; $5750
	or a			; $5751
	jr nz,_label_08_134	; $5752
	ld a,($cc55)		; $5754
	dec a			; $5757
	bit 7,a			; $5758
	jr z,_label_08_133	; $575a
	xor a			; $575c
_label_08_133:
	ld hl,$576c		; $575d
	rst_addAToHl			; $5760
	ld e,$72		; $5761
	ld a,(hl)		; $5763
	ld (de),a		; $5764
	inc e			; $5765
	ld a,$33		; $5766
	ld (de),a		; $5768
_label_08_134:
	jp $5723		; $5769
	nop			; $576c
	nop			; $576d
	nop			; $576e
	ld bc,$0000		; $576f
	nop			; $5772
	nop			; $5773
	nop			; $5774
	nop			; $5775
	ld (bc),a		; $5776
	ld e,$42		; $5777
	ld a,(de)		; $5779
	ld b,a			; $577a
	call checkIsLinkedGame		; $577b
	jr z,_label_08_135	; $577e
	ld a,$1e		; $5780
	call checkGlobalFlag		; $5782
	jr z,_label_08_136	; $5785
	ld a,$1f		; $5787
	call checkGlobalFlag		; $5789
	jr z,_label_08_138	; $578c
	jr _label_08_136		; $578e
_label_08_135:
	ld a,$28		; $5790
	call checkGlobalFlag		; $5792
	jr z,_label_08_136	; $5795
	ld a,b			; $5797
	cp $03			; $5798
	jr nz,_label_08_138	; $579a
	jr _label_08_137		; $579c
_label_08_136:
	ld a,b			; $579e
	cp $03			; $579f
	jr z,_label_08_138	; $57a1
_label_08_137:
	ld e,$41		; $57a3
	ld a,(de)		; $57a5
	xor $01			; $57a6
	ret			; $57a8
_label_08_138:
	xor a			; $57a9
	ret			; $57aa
	call interactionRunScript		; $57ab
	ld e,$43		; $57ae
	ld a,(de)		; $57b0
	and $80			; $57b1
	jp nz,interactionAnimateAsNpc		; $57b3
	jp npcFaceLinkAndAnimate		; $57b6
	ld e,$41		; $57b9
	ld a,(de)		; $57bb
	ld b,$00		; $57bc
	cp $2d			; $57be
	jr z,_label_08_140	; $57c0
	inc b			; $57c2
	cp $37			; $57c3
	jr nz,_label_08_139	; $57c5
	ld e,$42		; $57c7
	ld a,(de)		; $57c9
	cp $06			; $57ca
	jr nz,_label_08_140	; $57cc
	ld b,$0b		; $57ce
	jr _label_08_142		; $57d0
_label_08_139:
	inc b			; $57d2
	cp $3c			; $57d3
	jr z,_label_08_140	; $57d5
	inc b			; $57d7
	cp $3d			; $57d8
	ret nz			; $57da
_label_08_140:
	ld a,b			; $57db
	ld hl,$58a7		; $57dc
	rst_addDoubleIndex			; $57df
	ldi a,(hl)		; $57e0
	ld h,(hl)		; $57e1
	ld l,a			; $57e2
	push hl			; $57e3
	call $57f8		; $57e4
	pop hl			; $57e7
	ld e,$42		; $57e8
	ld a,(de)		; $57ea
	rst_addDoubleIndex			; $57eb
	ldi a,(hl)		; $57ec
	ld h,(hl)		; $57ed
	ld l,a			; $57ee
_label_08_141:
	ldi a,(hl)		; $57ef
	or a			; $57f0
	ret z			; $57f1
	dec a			; $57f2
	cp b			; $57f3
	jr nz,_label_08_141	; $57f4
_label_08_142:
	scf			; $57f6
	ret			; $57f7
	ld a,$28		; $57f8
	call checkGlobalFlag		; $57fa
	ld b,$0a		; $57fd
	jr nz,_label_08_143	; $57ff
	ld a,$40		; $5801
	call checkTreasureObtained		; $5803
	jr c,_label_08_144	; $5806
	ld a,$18		; $5808
	call checkGlobalFlag		; $580a
	ld b,$01		; $580d
	jr nz,_label_08_143	; $580f
	ld b,$00		; $5811
_label_08_143:
	xor a			; $5813
	ret			; $5814
_label_08_144:
	ld c,a			; $5815
	call getNumSetBits		; $5816
	ldh (<hFF8B),a	; $5819
	ld a,c			; $581b
	call getHighestSetBit		; $581c
	ld c,a			; $581f
	call checkIsLinkedGame		; $5820
	jr nz,_label_08_146	; $5823
_label_08_145:
	ld a,c			; $5825
	ld b,$05		; $5826
	cp $07			; $5828
	ret nc			; $582a
	dec b			; $582b
	ldh a,(<hFF8B)	; $582c
	cp $05			; $582e
	ret nc			; $5830
	ld a,c			; $5831
	dec b			; $5832
	cp $01			; $5833
	ret nc			; $5835
	dec b			; $5836
	ret			; $5837
_label_08_146:
	ld a,$1f		; $5838
	call checkGlobalFlag		; $583a
	ld b,$08		; $583d
	ret nz			; $583f
	ld a,$19		; $5840
	call checkGlobalFlag		; $5842
	ld b,$07		; $5845
	ret nz			; $5847
	ld a,$1e		; $5848
	call checkGlobalFlag		; $584a
	ld b,$06		; $584d
	ret nz			; $584f
	ld a,c			; $5850
	cp $00			; $5851
	jr z,_label_08_145	; $5853
	ldh a,(<hFF8B)	; $5855
	cp $05			; $5857
	jr nc,_label_08_145	; $5859
	ld b,$09		; $585b
	ld a,$23		; $585d
	call checkGlobalFlag		; $585f
	ret z			; $5862
	ld b,$03		; $5863
	ret			; $5865
	ld e,$41		; $5866
	ld a,(de)		; $5868
	cp $36			; $5869
	jr z,_label_08_147	; $586b
	cp $39			; $586d
	jr z,_label_08_147	; $586f
	ld a,$ff		; $5871
	ret			; $5873
_label_08_147:
	ld a,$28		; $5874
	call checkGlobalFlag		; $5876
	ld b,$04		; $5879
	jr nz,_label_08_149	; $587b
	ld a,$1f		; $587d
	call checkGlobalFlag		; $587f
	ld b,$03		; $5882
	jr nz,_label_08_149	; $5884
	ld a,$40		; $5886
	call checkTreasureObtained		; $5888
	ld b,$00		; $588b
	jr nc,_label_08_149	; $588d
	ld c,a			; $588f
	call checkIsLinkedGame		; $5890
	jr z,_label_08_148	; $5893
_label_08_148:
	ld a,c			; $5895
	call getHighestSetBit		; $5896
	ld b,$02		; $5899
	cp $07			; $589b
	ret nc			; $589d
	dec b			; $589e
	ld a,c			; $589f
	and $08			; $58a0
	jr nz,_label_08_149	; $58a2
	dec b			; $58a4
_label_08_149:
	xor a			; $58a5
	ret			; $58a6
	or a			; $58a7
	ld e,b			; $58a8
	rst_addAToHl			; $58a9
	ld e,b			; $58aa
.DB $f4				; $58ab
	ld e,b			; $58ac
.DB $f4				; $58ad
	ld e,b			; $58ae
	add hl,de		; $58af
	ld e,c			; $58b0
	ld (bc),a		; $58b1
	ld e,c			; $58b2
.DB $f4				; $58b3
	ld e,b			; $58b4
	inc sp			; $58b5
	ld e,c			; $58b6
	push bc			; $58b7
	ld e,b			; $58b8
	rst_jumpTable			; $58b9
	ld e,b			; $58ba
	call z,$ce58		; $58bb
	ld e,b			; $58be
	ret nc			; $58bf
	ld e,b			; $58c0
.DB $d3				; $58c1
	ld e,b			; $58c2
	push de			; $58c3
	ld e,b			; $58c4
	ld bc,$0200		; $58c5
	inc bc			; $58c8
	inc b			; $58c9
	ld a,(bc)		; $58ca
	nop			; $58cb
	dec b			; $58cc
	nop			; $58cd
	ld b,$00		; $58ce
	rlca			; $58d0
	ld ($0900),sp		; $58d1
	nop			; $58d4
	dec bc			; $58d5
	nop			; $58d6
.DB $e3				; $58d7
	ld e,b			; $58d8
	rst $20			; $58d9
	ld e,b			; $58da
	jp hl			; $58db
	ld e,b			; $58dc
.DB $eb				; $58dd
	ld e,b			; $58de
.DB $ed				; $58df
	ld e,b			; $58e0
	rst $28			; $58e1
	ld e,b			; $58e2
	ld bc,$0b02		; $58e3
	nop			; $58e6
	inc bc			; $58e7
	nop			; $58e8
	inc b			; $58e9
	nop			; $58ea
	ld a,(bc)		; $58eb
	nop			; $58ec
	dec b			; $58ed
	nop			; $58ee
	ld b,$07		; $58ef
	ld ($0009),sp		; $58f1
	or $58			; $58f4
	ld bc,$0302		; $58f6
	inc b			; $58f9
	ld a,(bc)		; $58fa
	dec b			; $58fb
	ld b,$07		; $58fc
	ld ($0b09),sp		; $58fe
	nop			; $5901
	ld a,(bc)		; $5902
	ld e,c			; $5903
	dec c			; $5904
	ld e,c			; $5905
	inc d			; $5906
	ld e,c			; $5907
	rla			; $5908
	ld e,c			; $5909
	ld bc,$0002		; $590a
	inc bc			; $590d
	inc b			; $590e
	ld a,(bc)		; $590f
	dec b			; $5910
	ld b,$0b		; $5911
	nop			; $5913
	rlca			; $5914
	ld ($0900),sp		; $5915
	nop			; $5918
	inc hl			; $5919
	ld e,c			; $591a
	daa			; $591b
	ld e,c			; $591c
	add hl,hl		; $591d
	ld e,c			; $591e
	dec hl			; $591f
	ld e,c			; $5920
	cpl			; $5921
	ld e,c			; $5922
	ld bc,$0302		; $5923
	nop			; $5926
	inc b			; $5927
	nop			; $5928
	ld a,(bc)		; $5929
	nop			; $592a
	dec b			; $592b
	ld b,$0b		; $592c
	nop			; $592e
	rlca			; $592f
	ld ($0009),sp		; $5930
	dec sp			; $5933
	ld e,c			; $5934
	ld b,c			; $5935
	ld e,c			; $5936
	ld b,e			; $5937
	ld e,c			; $5938
	ld c,b			; $5939
	ld e,c			; $593a
	ld bc,$0302		; $593b
	inc b			; $593e
	ld a,(bc)		; $593f
	nop			; $5940
	dec b			; $5941
	nop			; $5942
	ld b,$07		; $5943
	ld ($0009),sp		; $5945
	dec bc			; $5948
	nop			; $5949
	add d			; $594a
	ld e,c			; $594b
	add d			; $594c
	ld e,c			; $594d
	add d			; $594e
	ld e,c			; $594f
	add d			; $5950
	ld e,c			; $5951
	add d			; $5952
	ld e,c			; $5953
	adc d			; $5954
	ld e,c			; $5955
	add d			; $5956
	ld e,c			; $5957
	add d			; $5958
	ld e,c			; $5959
	adc h			; $595a
	ld e,c			; $595b
	adc (hl)		; $595c
	ld e,c			; $595d
	add d			; $595e
	ld e,c			; $595f
	and h			; $5960
	ld e,c			; $5961
	add d			; $5962
	ld e,c			; $5963
	add d			; $5964
	ld e,c			; $5965
	add d			; $5966
	ld e,c			; $5967
	and (hl)		; $5968
	ld e,c			; $5969
	add d			; $596a
	ld e,c			; $596b
	add d			; $596c
	ld e,c			; $596d
	or d			; $596e
	ld e,c			; $596f
	cp h			; $5970
	ld e,c			; $5971
	call nc,$d659		; $5972
	ld e,c			; $5975
	add d			; $5976
	ld e,c			; $5977
	add d			; $5978
	ld e,c			; $5979
	ld ($ff00+$59),a	; $597a
	or $59			; $597c
	add d			; $597e
	ld e,c			; $597f
	inc c			; $5980
	ld e,d			; $5981
	ret z			; $5982
	ld c,a			; $5983
	ret z			; $5984
	ld c,a			; $5985
	ret z			; $5986
	ld c,a			; $5987
.DB $e4				; $5988
	ld c,a			; $5989
	ld b,c			; $598a
	ld d,b			; $598b
	ld (hl),d		; $598c
	ld d,b			; $598d
	xor b			; $598e
	ld d,b			; $598f
	xor e			; $5990
	ld d,b			; $5991
	xor e			; $5992
	ld d,b			; $5993
	xor e			; $5994
	ld d,b			; $5995
	xor (hl)		; $5996
	ld d,b			; $5997
	or c			; $5998
	ld d,b			; $5999
	or h			; $599a
	ld d,b			; $599b
	or h			; $599c
	ld d,b			; $599d
	or a			; $599e
	ld d,b			; $599f
	xor e			; $59a0
	ld d,b			; $59a1
	cp d			; $59a2
	ld d,b			; $59a3
	cp l			; $59a4
	ld d,b			; $59a5
	ld (bc),a		; $59a6
	ld d,c			; $59a7
	ld ($0b51),sp		; $59a8
	ld d,c			; $59ab
	ld de,$0851		; $59ac
	ld d,c			; $59af
	ld ($1451),sp		; $59b0
	ld d,c			; $59b3
	ldi a,(hl)		; $59b4
	ld d,c			; $59b5
	ld b,(hl)		; $59b6
	ld d,c			; $59b7
	ld c,e			; $59b8
	ld d,c			; $59b9
	ld d,b			; $59ba
	ld d,c			; $59bb
	ld d,l			; $59bc
	ld d,c			; $59bd
	ld d,l			; $59be
	ld d,c			; $59bf
	ld e,b			; $59c0
	ld d,c			; $59c1
	ld e,(hl)		; $59c2
	ld d,c			; $59c3
	ld h,c			; $59c4
	ld d,c			; $59c5
	ld h,h			; $59c6
	ld d,c			; $59c7
	ld h,a			; $59c8
	ld d,c			; $59c9
	ld h,a			; $59ca
	ld d,c			; $59cb
	ld l,d			; $59cc
	ld d,c			; $59cd
	ld e,e			; $59ce
	ld d,c			; $59cf
	ld l,l			; $59d0
	ld d,c			; $59d1
	ld (hl),b		; $59d2
	ld d,c			; $59d3
	halt			; $59d4
	ld d,c			; $59d5
	ld a,(hl)		; $59d6
	ld d,c			; $59d7
	add c			; $59d8
	ld d,c			; $59d9
	add h			; $59da
	ld d,c			; $59db
	add a			; $59dc
	ld d,c			; $59dd
	add h			; $59de
	ld d,c			; $59df
	adc d			; $59e0
	ld d,c			; $59e1
	adc d			; $59e2
	ld d,c			; $59e3
	adc l			; $59e4
	ld d,c			; $59e5
	adc l			; $59e6
	ld d,c			; $59e7
	and h			; $59e8
	ld d,c			; $59e9
	and a			; $59ea
	ld d,c			; $59eb
	xor d			; $59ec
	ld d,c			; $59ed
	xor d			; $59ee
	ld d,c			; $59ef
	xor l			; $59f0
	ld d,c			; $59f1
	adc l			; $59f2
	ld d,c			; $59f3
	or b			; $59f4
	ld d,c			; $59f5
	or e			; $59f6
	ld d,c			; $59f7
	call nz,$c951		; $59f8
	ld d,c			; $59fb
	adc $51			; $59fc
	ret c			; $59fe
	ld d,c			; $59ff
.DB $dd				; $5a00
	ld d,c			; $5a01
	ld ($ff00+c),a		; $5a02
	ld d,c			; $5a03
	ld ($ff00+c),a		; $5a04
	ld d,c			; $5a05
	rst $20			; $5a06
	ld d,c			; $5a07
.DB $d3				; $5a08
	ld d,c			; $5a09
.DB $ec				; $5a0a
	ld d,c			; $5a0b
	pop af			; $5a0c
	ld d,c			; $5a0d

interactionCode25:
interactionCode26:
	ld e,$44		; $5a0e
	ld a,(de)		; $5a10
	rst_jumpTable			; $5a11
	jr $5a			; $5a12
	add e			; $5a14
	ld e,d			; $5a15
	sub e			; $5a16
	ld e,d			; $5a17
	call interactionInitGraphics		; $5a18
	ld a,$0b		; $5a1b
	call interactionSetHighTextIndex		; $5a1d
	ld e,$41		; $5a20
	ld a,(de)		; $5a22
	cp $26			; $5a23
	jr z,_label_08_151	; $5a25
	call getThisRoomFlags		; $5a27
	and $40			; $5a2a
	ld e,$42		; $5a2c
	ld a,(de)		; $5a2e
	jr nz,_label_08_150	; $5a2f
	or a			; $5a31
	jp nz,interactionDelete		; $5a32
	jr _label_08_153		; $5a35
_label_08_150:
	or a			; $5a37
	jp z,interactionDelete		; $5a38
	jr _label_08_153		; $5a3b
_label_08_151:
	call getThisRoomFlags		; $5a3d
	and $40			; $5a40
	ld e,$42		; $5a42
	ld a,(de)		; $5a44
	jr nz,_label_08_152	; $5a45
	or a			; $5a47
	jp nz,interactionDelete		; $5a48
	call $5a78		; $5a4b
	ld a,$00		; $5a4e
	call interactionSetAnimation		; $5a50
	jp $5a96		; $5a53
_label_08_152:
	or a			; $5a56
	jp z,interactionDelete		; $5a57
	call $5a78		; $5a5a
	ld a,$02		; $5a5d
	call interactionSetAnimation		; $5a5f
	jp $5a96		; $5a62
_label_08_153:
	ld h,d			; $5a65
	ld l,$44		; $5a66
	ld (hl),$01		; $5a68
	ld hl,$5225		; $5a6a
	call interactionSetScript		; $5a6d
	ld a,$02		; $5a70
	call interactionSetAnimation		; $5a72
	jp $5a96		; $5a75
	ld h,d			; $5a78
	ld l,$44		; $5a79
	ld (hl),$02		; $5a7b
	ld hl,$5227		; $5a7d
	jp interactionSetScript		; $5a80
	call interactionRunScript		; $5a83
	ld a,($cceb)		; $5a86
	or a			; $5a89
	jp z,npcFaceLinkAndAnimate		; $5a8a
	call $5a99		; $5a8d
	jp $5a96		; $5a90
	call interactionRunScript		; $5a93
	jp interactionAnimateAsNpc		; $5a96
	ld e,$78		; $5a99
	ld a,(de)		; $5a9b
	rst_jumpTable			; $5a9c
	and l			; $5a9d
	ld e,d			; $5a9e
	jp nz,$d45a		; $5a9f
	ld e,d			; $5aa2
	xor $5a			; $5aa3
	ld h,d			; $5aa5
	ld l,$78		; $5aa6
	ld (hl),$01		; $5aa8
	ld l,$49		; $5aaa
	ld (hl),$08		; $5aac
	ld l,$50		; $5aae
	ld (hl),$28		; $5ab0
	ld l,$54		; $5ab2
	ld (hl),$00		; $5ab4
	inc hl			; $5ab6
	ld (hl),$fe		; $5ab7
	ld l,$79		; $5ab9
	ld (hl),$04		; $5abb
	ld a,$07		; $5abd
	jp interactionSetAnimation		; $5abf
	ld h,d			; $5ac2
	ld l,$79		; $5ac3
	dec (hl)		; $5ac5
	ret nz			; $5ac6
	ld l,$78		; $5ac7
	inc (hl)		; $5ac9
	ld a,$08		; $5aca
	call interactionSetAnimation		; $5acc
	ld a,$53		; $5acf
	jp playSound		; $5ad1
	ld c,$28		; $5ad4
	call objectUpdateSpeedZ_paramC		; $5ad6
	jp nz,objectApplySpeed		; $5ad9
	ld h,d			; $5adc
	ld l,$78		; $5add
	inc (hl)		; $5adf
	ld l,$79		; $5ae0
	ld (hl),$04		; $5ae2
	ld a,$07		; $5ae4
	call interactionSetAnimation		; $5ae6
	ld a,$57		; $5ae9
	jp playSound		; $5aeb
	ld h,d			; $5aee
	ld l,$79		; $5aef
	dec (hl)		; $5af1
	ret nz			; $5af2
	xor a			; $5af3
	ld ($cceb),a		; $5af4
	ld a,$02		; $5af7
	jp interactionSetAnimation		; $5af9

interactionCode27:
	ld e,$44		; $5afc
	ld a,(de)		; $5afe
	rst_jumpTable			; $5aff
	inc b			; $5b00
	ld e,e			; $5b01
	ld a,e			; $5b02
	ld e,e			; $5b03
	ld a,$01		; $5b04
	ld (de),a		; $5b06
	ld a,$28		; $5b07
	call checkGlobalFlag		; $5b09
	jp nz,interactionDelete		; $5b0c
	ld a,$52		; $5b0f
	call interactionSetHighTextIndex		; $5b11
	call interactionInitGraphics		; $5b14
	ld e,$42		; $5b17
	ld a,(de)		; $5b19
	rst_jumpTable			; $5b1a
	ldi a,(hl)		; $5b1b
	ld e,e			; $5b1c
	ld b,e			; $5b1d
	ld e,e			; $5b1e
	ld h,d			; $5b1f
	ld e,e			; $5b20
_label_08_154:
	call interactionRunScript		; $5b21
	call interactionRunScript		; $5b24
	jp objectSetVisiblec2		; $5b27
	ld a,($c6b0)		; $5b2a
	and $02			; $5b2d
	jr nz,_label_08_155	; $5b2f
	ld a,$71		; $5b31
	call getARoomFlags		; $5b33
	bit 6,a			; $5b36
	jp nz,interactionDelete		; $5b38
_label_08_155:
	ld hl,$526d		; $5b3b
	call interactionSetScript		; $5b3e
	jr _label_08_154		; $5b41
	ld a,($c6b0)		; $5b43
	and $08			; $5b46
	jr z,_label_08_156	; $5b48
	call getThisRoomFlags		; $5b4a
	bit 6,a			; $5b4d
	jr nz,_label_08_156	; $5b4f
	ld hl,$52fa		; $5b51
	call interactionSetScript		; $5b54
	jr _label_08_154		; $5b57
_label_08_156:
	ld hl,$7e4a		; $5b59
	call parseGivenObjectData		; $5b5c
	jp interactionDelete		; $5b5f
	call getThisRoomFlags		; $5b62
	ld a,($c6b0)		; $5b65
	and $02			; $5b68
	jr z,_label_08_157	; $5b6a
	res 6,(hl)		; $5b6c
	jp interactionDelete		; $5b6e
_label_08_157:
	set 6,(hl)		; $5b71
	ld hl,$5358		; $5b73
	call interactionSetScript		; $5b76
	jr _label_08_154		; $5b79
	ld e,$42		; $5b7b
	ld a,(de)		; $5b7d
	rst_jumpTable			; $5b7e
	add l			; $5b7f
	ld e,e			; $5b80
	pop bc			; $5b81
	ld e,e			; $5b82
.DB $dd				; $5b83
	ld e,e			; $5b84
	call interactionRunScript		; $5b85
	call interactionAnimateAsNpc		; $5b88
	ld a,$19		; $5b8b
	call checkTreasureObtained		; $5b8d
	ret nc			; $5b90
	call getThisRoomFlags		; $5b91
	bit 6,(hl)		; $5b94
	jr z,_label_08_158	; $5b96
	ld e,$43		; $5b98
	ld a,(de)		; $5b9a
	or a			; $5b9b
	jr nz,_label_08_159	; $5b9c
	ret			; $5b9e
_label_08_158:
	ld a,($d00d)		; $5b9f
	cp $78			; $5ba2
	ret c			; $5ba4
	ld a,($d00b)		; $5ba5
	cp $3c			; $5ba8
	ret c			; $5baa
	cp $60			; $5bab
	ret nc			; $5bad
	ld e,$77		; $5bae
	ld a,$01		; $5bb0
	ld (de),a		; $5bb2
	ret			; $5bb3
_label_08_159:
	ld a,(wFrameCounter)		; $5bb4
	and $3f			; $5bb7
	ret nz			; $5bb9
	ld b,$f4		; $5bba
	ld c,$fa		; $5bbc
	jp objectCreateFloatingMusicNote		; $5bbe
	call interactionAnimateAsNpc		; $5bc1
	call interactionRunScript		; $5bc4
	jp c,interactionDelete		; $5bc7
	call checkInteractionState2		; $5bca
	ret nz			; $5bcd
	ld a,($d00d)		; $5bce
	cp $18			; $5bd1
	ret c			; $5bd3
	call interactionIncState2		; $5bd4
	call $5bae		; $5bd7
	jp $5dfe		; $5bda
	ld a,($cca4)		; $5bdd
	and $01			; $5be0
	call z,seasonsFunc_3d30		; $5be2
	call interactionAnimateAsNpc		; $5be5
	jp interactionRunScript		; $5be8

interactionCode28:
	ld e,$44		; $5beb
	ld a,(de)		; $5bed
	rst_jumpTable			; $5bee
	di			; $5bef
	ld e,e			; $5bf0
	ld b,d			; $5bf1
	ld e,h			; $5bf2
	call interactionInitGraphics		; $5bf3
	call interactionIncState		; $5bf6
	ld e,$42		; $5bf9
	ld a,(de)		; $5bfb
	ld hl,$5c87		; $5bfc
	rst_addDoubleIndex			; $5bff
	ldi a,(hl)		; $5c00
	ld h,(hl)		; $5c01
	ld l,a			; $5c02
	call interactionSetScript		; $5c03
	ld e,$42		; $5c06
	ld a,(de)		; $5c08
	rst_jumpTable			; $5c09
	ld e,$5c		; $5c0a
	ldd (hl),a		; $5c0c
	ld e,h			; $5c0d
	ldd (hl),a		; $5c0e
	ld e,h			; $5c0f
	ldd (hl),a		; $5c10
	ld e,h			; $5c11
	ldd (hl),a		; $5c12
	ld e,h			; $5c13
	ldd a,(hl)		; $5c14
	ld e,h			; $5c15
	ldd (hl),a		; $5c16
	ld e,h			; $5c17
	ldd (hl),a		; $5c18
	ld e,h			; $5c19
	ldd (hl),a		; $5c1a
	ld e,h			; $5c1b
	ldd (hl),a		; $5c1c
	ld e,h			; $5c1d
	ld h,d			; $5c1e
	ld l,$50		; $5c1f
	ld (hl),$28		; $5c21
	ld l,$49		; $5c23
	ld (hl),$18		; $5c25
	ld l,$7a		; $5c27
	ld a,$04		; $5c29
	ld (hl),a		; $5c2b
	call interactionSetAnimation		; $5c2c
	jp $5c66		; $5c2f
	ld a,$03		; $5c32
	call interactionSetAnimation		; $5c34
	jp $5c66		; $5c37
	ld a,$02		; $5c3a
	call interactionSetAnimation		; $5c3c
	jp $5c66		; $5c3f
	ld e,$42		; $5c42
	ld a,(de)		; $5c44
	rst_jumpTable			; $5c45
	ld e,d			; $5c46
	ld e,h			; $5c47
	ld e,l			; $5c48
	ld e,h			; $5c49
	ld e,l			; $5c4a
	ld e,h			; $5c4b
	ld e,l			; $5c4c
	ld e,h			; $5c4d
	ld e,l			; $5c4e
	ld e,h			; $5c4f
	ld e,l			; $5c50
	ld e,h			; $5c51
	ld e,l			; $5c52
	ld e,h			; $5c53
	ld e,l			; $5c54
	ld e,h			; $5c55
	ld e,l			; $5c56
	ld e,h			; $5c57
	ld e,l			; $5c58
	ld e,h			; $5c59
	call $5c6c		; $5c5a
	call interactionRunScript		; $5c5d
	jp $5c63		; $5c60
	call interactionAnimate		; $5c63
	call objectPreventLinkFromPassing		; $5c66
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $5c69
	call objectApplySpeed		; $5c6c
	ld e,$4d		; $5c6f
	ld a,(de)		; $5c71
	sub $28			; $5c72
	cp $30			; $5c74
	ret c			; $5c76
	ld h,d			; $5c77
	ld l,$49		; $5c78
	ld a,(hl)		; $5c7a
	xor $10			; $5c7b
	ld (hl),a		; $5c7d
	ld l,$7a		; $5c7e
	ld a,(hl)		; $5c80
	xor $01			; $5c81
	ld (hl),a		; $5c83
	jp interactionSetAnimation		; $5c84
	ld a,(hl)		; $5c87
	ld d,e			; $5c88
	sub e			; $5c89
	ld d,e			; $5c8a
	sub e			; $5c8b
	ld d,e			; $5c8c
	sub e			; $5c8d
	ld d,e			; $5c8e
	sub e			; $5c8f
	ld d,e			; $5c90
	and d			; $5c91
	ld d,e			; $5c92
	sub e			; $5c93
	ld d,e			; $5c94
	sub e			; $5c95
	ld d,e			; $5c96
	sub e			; $5c97
	ld d,e			; $5c98
	sub e			; $5c99
	ld d,e			; $5c9a

interactionCode2a:
	call checkInteractionState		; $5c9b
	jr nz,_label_08_163	; $5c9e
	ld a,$01		; $5ca0
	ld (de),a		; $5ca2
	call interactionInitGraphics		; $5ca3
	ld e,$42		; $5ca6
	ld a,(de)		; $5ca8
	cp $0a			; $5ca9
	jr z,_label_08_162	; $5cab
	cp $0b			; $5cad
	jr nz,_label_08_160	; $5caf
	ld a,$22		; $5cb1
	call checkGlobalFlag		; $5cb3
	jp z,interactionDelete		; $5cb6
	ld a,$23		; $5cb9
	call checkGlobalFlag		; $5cbb
	jp nz,interactionDelete		; $5cbe
	ld hl,$53d6		; $5cc1
	jr _label_08_161		; $5cc4
_label_08_160:
	ld hl,$53b8		; $5cc6
_label_08_161:
	call interactionSetScript		; $5cc9
	call getRandomNumber_noPreserveVars		; $5ccc
	and $01			; $5ccf
	ld e,$48		; $5cd1
	ld (de),a		; $5cd3
	call interactionSetAnimation		; $5cd4
	call interactionSetAlwaysUpdateBit		; $5cd7
	ld l,$76		; $5cda
	ld (hl),$1e		; $5cdc
	call $5dfe		; $5cde
	ld l,$42		; $5ce1
	ld a,(hl)		; $5ce3
	ld l,$72		; $5ce4
	ld (hl),a		; $5ce6
	ld l,$73		; $5ce7
	ld (hl),$32		; $5ce9
	jp objectSetVisible82		; $5ceb
_label_08_162:
	call interactionSetAlwaysUpdateBit		; $5cee
	ld l,$46		; $5cf1
	ld (hl),$b4		; $5cf3
	ld l,$50		; $5cf5
	ld (hl),$19		; $5cf7
	call $5dfe		; $5cf9
	call objectSetVisible82		; $5cfc
	jp objectSetInvisible		; $5cff
_label_08_163:
	ld e,$42		; $5d02
	ld a,(de)		; $5d04
	cp $0a			; $5d05
	jr z,_label_08_166	; $5d07
	call interactionRunScript		; $5d09
	ld e,$45		; $5d0c
	ld a,(de)		; $5d0e
	rst_jumpTable			; $5d0f
	inc d			; $5d10
	ld e,l			; $5d11
	ld b,c			; $5d12
	ld e,l			; $5d13
	ld e,$77		; $5d14
	ld a,(de)		; $5d16
	or a			; $5d17
	jr z,_label_08_164	; $5d18
	call interactionIncState2		; $5d1a
	ld l,$48		; $5d1d
	ld a,(hl)		; $5d1f
	add $02			; $5d20
	jp interactionSetAnimation		; $5d22
_label_08_164:
	call $5df2		; $5d25
	jr nz,_label_08_165	; $5d28
	ld l,$76		; $5d2a
	ld (hl),$1e		; $5d2c
	call getRandomNumber		; $5d2e
	and $07			; $5d31
	jr nz,_label_08_165	; $5d33
	ld l,$48		; $5d35
	ld a,(hl)		; $5d37
	xor $01			; $5d38
	ld (hl),a		; $5d3a
	jp interactionSetAnimation		; $5d3b
_label_08_165:
	jp interactionAnimateAsNpc		; $5d3e
	call interactionAnimate		; $5d41
	ld e,$77		; $5d44
	ld a,(de)		; $5d46
	or a			; $5d47
	jp nz,$5df7		; $5d48
	ld l,$76		; $5d4b
	ld (hl),$3c		; $5d4d
	ld l,$45		; $5d4f
	ld (hl),a		; $5d51
	ld l,$4e		; $5d52
	ldi (hl),a		; $5d54
	ld (hl),a		; $5d55
	ld l,$48		; $5d56
	ld a,(hl)		; $5d58
	jp interactionSetAnimation		; $5d59
_label_08_166:
	ld e,$45		; $5d5c
	ld a,(de)		; $5d5e
	rst_jumpTable			; $5d5f
	ld l,d			; $5d60
	ld e,l			; $5d61
	ld a,h			; $5d62
	ld e,l			; $5d63
	and c			; $5d64
	ld e,l			; $5d65
	or e			; $5d66
	ld e,l			; $5d67
	adc $5d			; $5d68
	ld a,($cbc3)		; $5d6a
	or a			; $5d6d
	ret nz			; $5d6e
	call interactionDecCounter1		; $5d6f
	ret nz			; $5d72
	ld l,$45		; $5d73
	inc (hl)		; $5d75
	call $5e04		; $5d76
	jp objectSetVisible		; $5d79
	call interactionAnimateAsNpc		; $5d7c
	call $5df7		; $5d7f
	ld a,(wFrameCounter)		; $5d82
	and $07			; $5d85
	call z,$5e04		; $5d87
	ld c,$10		; $5d8a
	call $5e22		; $5d8c
	jp nc,objectApplySpeed		; $5d8f
	ld h,d			; $5d92
	ld l,$45		; $5d93
	inc (hl)		; $5d95
	ld l,$46		; $5d96
	ld (hl),$14		; $5d98
	ld l,$4f		; $5d9a
	ld (hl),$00		; $5d9c
	jp $5dfe		; $5d9e
	call interactionAnimateAsNpc		; $5da1
	call interactionDecCounter1		; $5da4
	ret nz			; $5da7
	ld l,$45		; $5da8
	inc (hl)		; $5daa
	ld l,$78		; $5dab
	ld a,(hl)		; $5dad
	add $02			; $5dae
	jp interactionSetAnimation		; $5db0
	call interactionAnimateAsNpc		; $5db3
	call $5de5		; $5db6
	ld e,$4f		; $5db9
	ld a,(de)		; $5dbb
	or a			; $5dbc
	ret nz			; $5dbd
	ld c,$18		; $5dbe
	call $5e22		; $5dc0
	ret c			; $5dc3
	ld h,d			; $5dc4
	ld l,$45		; $5dc5
	inc (hl)		; $5dc7
	call $5dfe		; $5dc8
	jp $5e04		; $5dcb
	call interactionAnimateAsNpc		; $5dce
	call $5df7		; $5dd1
	ld a,(wFrameCounter)		; $5dd4
	and $07			; $5dd7
	call z,$5e04		; $5dd9
	call objectApplySpeed		; $5ddc
	call objectCheckWithinScreenBoundary		; $5ddf
	jp nc,interactionDelete		; $5de2
	ld c,$10		; $5de5
	call objectUpdateSpeedZ_paramC		; $5de7
	ret nz			; $5dea
	ld h,d			; $5deb
	ld bc,$fec0		; $5dec
	jp objectSetSpeedZ		; $5def
	ld h,d			; $5df2
	ld l,$76		; $5df3
	dec (hl)		; $5df5
	ret			; $5df6
	ld c,$20		; $5df7
	call objectUpdateSpeedZ_paramC		; $5df9
	ret nz			; $5dfc
	ld h,d			; $5dfd
	ld bc,$ff40		; $5dfe
	jp objectSetSpeedZ		; $5e01
	call objectGetRelatedObject1Var		; $5e04
	ld l,$4b		; $5e07
	ld b,(hl)		; $5e09
	inc l			; $5e0a
	inc l			; $5e0b
	ld c,(hl)		; $5e0c
	call objectGetRelativeAngle		; $5e0d
	ld e,$49		; $5e10
	ld (de),a		; $5e12
	and $10			; $5e13
	swap a			; $5e15
	xor $01			; $5e17
	ld h,d			; $5e19
	ld l,$78		; $5e1a
	cp (hl)			; $5e1c
	ret z			; $5e1d
	ld (hl),a		; $5e1e
	jp interactionSetAnimation		; $5e1f
	ld e,$4b		; $5e22
	ld a,(de)		; $5e24
	ld b,a			; $5e25
	call objectGetRelatedObject1Var		; $5e26
	ld l,$4b		; $5e29
	ld a,(hl)		; $5e2b
	sub b			; $5e2c
	cp c			; $5e2d
	ret			; $5e2e

interactionCode2b:
	ld e,$44		; $5e2f
	ld a,(de)		; $5e31
	rst_jumpTable			; $5e32
	scf			; $5e33
	ld e,(hl)		; $5e34
	ld (hl),a		; $5e35
	ld e,(hl)		; $5e36
	call interactionInitGraphics		; $5e37
	ld a,$44		; $5e3a
	call interactionSetHighTextIndex		; $5e3c
	call interactionIncState		; $5e3f
	ld e,$42		; $5e42
	ld a,(de)		; $5e44
	ld hl,$5e86		; $5e45
	rst_addDoubleIndex			; $5e48
	ldi a,(hl)		; $5e49
	ld h,(hl)		; $5e4a
	ld l,a			; $5e4b
	call interactionSetScript		; $5e4c
	ld e,$42		; $5e4f
	ld a,(de)		; $5e51
	rst_jumpTable			; $5e52
	ld h,a			; $5e53
	ld e,(hl)		; $5e54
	ld h,a			; $5e55
	ld e,(hl)		; $5e56
	ld l,a			; $5e57
	ld e,(hl)		; $5e58
	ld h,a			; $5e59
	ld e,(hl)		; $5e5a
	ld l,a			; $5e5b
	ld e,(hl)		; $5e5c
	ld l,a			; $5e5d
	ld e,(hl)		; $5e5e
	ld l,a			; $5e5f
	ld e,(hl)		; $5e60
	ld l,a			; $5e61
	ld e,(hl)		; $5e62
	ld l,a			; $5e63
	ld e,(hl)		; $5e64
	ld l,a			; $5e65
	ld e,(hl)		; $5e66
	ld a,$00		; $5e67
	call interactionSetAnimation		; $5e69
	jp $5e80		; $5e6c
	ld a,$04		; $5e6f
	call interactionSetAnimation		; $5e71
	jp $5e80		; $5e74
	call interactionRunScript		; $5e77
	jp $5e7d		; $5e7a
	call interactionAnimate		; $5e7d
	call objectPreventLinkFromPassing		; $5e80
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $5e83
	ld ($2653),a		; $5e86
	ld d,h			; $5e89
	jp nc,$de54		; $5e8a
	ld d,h			; $5e8d
	ld c,$55		; $5e8e
	stop			; $5e90
	ld d,l			; $5e91
	ld (de),a		; $5e92
	ld d,l			; $5e93
	or c			; $5e94
	ld d,l			; $5e95
	jp $d555		; $5e96
	ld d,l			; $5e99

interactionCode2e:
	ld e,$44		; $5e9a
	ld a,(de)		; $5e9c
	rst_jumpTable			; $5e9d
	and d			; $5e9e
	ld e,(hl)		; $5e9f
	ld ($ff00+c),a		; $5ea0
	ld e,(hl)		; $5ea1
	ld a,$01		; $5ea2
	ld (de),a		; $5ea4
	call $5874		; $5ea5
	ld e,$42		; $5ea8
	ld a,(de)		; $5eaa
	cp b			; $5eab
	jp nz,interactionDelete		; $5eac
	call interactionInitGraphics		; $5eaf
	ld a,($cc4c)		; $5eb2
	cp $6d			; $5eb5
	jr z,_label_08_167	; $5eb7
	ld a,$01		; $5eb9
	ld e,$48		; $5ebb
	ld (de),a		; $5ebd
	call interactionSetAnimation		; $5ebe
_label_08_167:
	ld e,$42		; $5ec1
	ld a,(de)		; $5ec3
	ld hl,$5f7e		; $5ec4
	rst_addDoubleIndex			; $5ec7
	ldi a,(hl)		; $5ec8
	ld h,(hl)		; $5ec9
	ld l,a			; $5eca
	call interactionSetScript		; $5ecb
	call getFreeInteractionSlot		; $5ece
	jr nz,_label_08_168	; $5ed1
	ld (hl),$8e		; $5ed3
	inc l			; $5ed5
	ld (hl),$00		; $5ed6
	ld l,$57		; $5ed8
	ld (hl),d		; $5eda
	ld l,$49		; $5edb
	call $5f4e		; $5edd
_label_08_168:
	jr _label_08_169		; $5ee0
	call interactionRunScript		; $5ee2
	ld e,$43		; $5ee5
	ld a,(de)		; $5ee7
	rst_jumpTable			; $5ee8
	pop af			; $5ee9
	ld e,(hl)		; $5eea
	nop			; $5eeb
	ld e,a			; $5eec
	ld d,$5f		; $5eed
	ld d,$5f		; $5eef
_label_08_169:
	call interactionAnimate		; $5ef1
	ld e,$61		; $5ef4
	ld a,(de)		; $5ef6
	inc a			; $5ef7
	jr nz,_label_08_170	; $5ef8
	call $5f70		; $5efa
_label_08_170:
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $5efd
	call interactionAnimate		; $5f00
	ld e,$61		; $5f03
	ld a,(de)		; $5f05
	or a			; $5f06
	jr z,_label_08_170	; $5f07
	call $5f65		; $5f09
	call getRandomNumber_noPreserveVars		; $5f0c
	and $03			; $5f0f
	jr nz,_label_08_172	; $5f11
	inc a			; $5f13
	jr _label_08_172		; $5f14
	call interactionAnimate		; $5f16
	ld e,$61		; $5f19
	ld a,(de)		; $5f1b
	cp $02			; $5f1c
	jr nz,_label_08_170	; $5f1e
	call $5f65		; $5f20
	call getFreePartSlot		; $5f23
	jr nz,_label_08_171	; $5f26
	ld (hl),$32		; $5f28
	inc l			; $5f2a
	ld (hl),$01		; $5f2b
	ld l,$c9		; $5f2d
	call $5f4e		; $5f2f
_label_08_171:
	call getRandomNumber_noPreserveVars		; $5f32
	and $03			; $5f35
	sub $02			; $5f37
	ret c			; $5f39
	inc a			; $5f3a
_label_08_172:
	ld b,a			; $5f3b
_label_08_173:
	call getFreePartSlot		; $5f3c
	ret nz			; $5f3f
	ld (hl),$32		; $5f40
	inc l			; $5f42
	ld (hl),$00		; $5f43
	ld l,$c9		; $5f45
	call $5f4e		; $5f47
	dec b			; $5f4a
	jr nz,_label_08_173	; $5f4b
	ret			; $5f4d
	push bc			; $5f4e
	ld e,$48		; $5f4f
	ld a,(de)		; $5f51
	rrca			; $5f52
	ld c,$f8		; $5f53
	ld a,$1c		; $5f55
	jr nc,_label_08_174	; $5f57
	ld c,$0a		; $5f59
	ld a,$06		; $5f5b
_label_08_174:
	ld (hl),a		; $5f5d
	ld b,$02		; $5f5e
	call objectCopyPositionWithOffset		; $5f60
	pop bc			; $5f63
	ret			; $5f64
	ld e,$48		; $5f65
	ld a,(de)		; $5f67
	and $01			; $5f68
	call interactionSetAnimation		; $5f6a
	call $5efa		; $5f6d
	ld e,$76		; $5f70
	ld a,$01		; $5f72
	ld (de),a		; $5f74
	call getRandomNumber_noPreserveVars		; $5f75
	and $03			; $5f78
	ld e,$43		; $5f7a
	ld (de),a		; $5f7c
	ret			; $5f7d
	.db $e7 $55 $ea $55 $ea $55 $f5 $55
	.db $ea $55

interactionCode30:
	ld e,$44		; $5f88
	ld a,(de)		; $5f8a
	rst_jumpTable			; $5f8b
	sbc b			; $5f8c
	ld e,a			; $5f8d
	jp c,$f35f		; $5f8e
	ld e,a			; $5f91
	inc d			; $5f92
	ld h,b			; $5f93
	rra			; $5f94
	ld h,b			; $5f95
	dec hl			; $5f96
	ld h,b			; $5f97
	ld a,$01		; $5f98
	ld (de),a		; $5f9a
	call interactionInitGraphics		; $5f9b
	ld h,d			; $5f9e
	ld l,$6b		; $5f9f
	ld (hl),$00		; $5fa1
	ld l,$49		; $5fa3
	ld (hl),$ff		; $5fa5
	ld l,$42		; $5fa7
	ld a,(hl)		; $5fa9
	cp $25			; $5faa
	jr nz,_label_08_175	; $5fac
	call checkIsLinkedGame		; $5fae
	jp z,interactionDelete		; $5fb1
	ld a,$0d		; $5fb4
	call checkGlobalFlag		; $5fb6
	jp z,interactionDelete		; $5fb9
	ld e,$7e		; $5fbc
	ld a,$03		; $5fbe
	ld (de),a		; $5fc0
_label_08_175:
	ld e,$42		; $5fc1
	ld a,(de)		; $5fc3
	ld hl,$607f		; $5fc4
	rst_addDoubleIndex			; $5fc7
	ldi a,(hl)		; $5fc8
	ld h,(hl)		; $5fc9
	ld l,a			; $5fca
	call interactionSetScript		; $5fcb
	call interactionRunScript		; $5fce
	call interactionRunScript		; $5fd1
	jp c,interactionDelete		; $5fd4
	jp objectSetVisible82		; $5fd7
	ld a,($cc49)		; $5fda
	dec a			; $5fdd
	jr nz,_label_08_176	; $5fde
	call objectGetTileAtPosition		; $5fe0
	ld (hl),$00		; $5fe3
_label_08_176:
	ld c,$20		; $5fe5
	call objectUpdateSpeedZ_paramC		; $5fe7
	call interactionRunScript		; $5fea
	jp c,interactionDelete		; $5fed
	jp npcFaceLinkAndAnimate		; $5ff0
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $5ff3
	call c,$600e		; $5ff6
_label_08_177:
	call interactionAnimate		; $5ff9
	call interactionAnimate		; $5ffc
	call interactionRunScript		; $5fff
	ld c,$60		; $6002
	call objectUpdateSpeedZ_paramC		; $6004
	ret nz			; $6007
	ld bc,$fe00		; $6008
	jp objectSetSpeedZ		; $600b
	ld hl,$cfc0		; $600e
	set 1,(hl)		; $6011
	ret			; $6013
	call objectGetAngleTowardLink		; $6014
	ld e,$49		; $6017
	ld (de),a		; $6019
	call objectApplySpeed		; $601a
	jr _label_08_177		; $601d
	ld c,$20		; $601f
	call objectUpdateSpeedZ_paramC		; $6021
	call interactionRunScript		; $6024
	jp c,interactionDelete		; $6027
	ret			; $602a
	call interactionRunScript		; $602b
	ld e,$45		; $602e
	ld a,(de)		; $6030
	rst_jumpTable			; $6031
	ldd a,(hl)		; $6032
	ld h,b			; $6033
	ld d,(hl)		; $6034
	ld h,b			; $6035
	ld h,h			; $6036
	ld h,b			; $6037
	ld h,h			; $6038
	ld h,b			; $6039
_label_08_178:
	ld a,($cfc0)		; $603a
	call getHighestSetBit		; $603d
	ret nc			; $6040
	cp $03			; $6041
	jr nz,_label_08_179	; $6043
	ld e,$44		; $6045
	ld a,$04		; $6047
	ld (de),a		; $6049
	ret			; $604a
_label_08_179:
	ld b,a			; $604b
	inc a			; $604c
	ld e,$45		; $604d
	ld (de),a		; $604f
	ld a,b			; $6050
	add $04			; $6051
	jp interactionSetAnimation		; $6053
	call interactionAnimate		; $6056
	ld a,($cfc0)		; $6059
	or a			; $605c
	ret z			; $605d
	ld e,$45		; $605e
	xor a			; $6060
	ld (de),a		; $6061
	jr _label_08_178		; $6062
	call interactionAnimate		; $6064
	ld h,d			; $6067
	ld l,$61		; $6068
	ld a,(hl)		; $606a
	or a			; $606b
	jr z,_label_08_180	; $606c
	ld (hl),$00		; $606e
	ld l,$4d		; $6070
	add (hl)		; $6072
	ld (hl),a		; $6073
_label_08_180:
	ld a,($cfc0)		; $6074
	or a			; $6077
	ret z			; $6078
	ld l,$45		; $6079
	ld (hl),$00		; $607b
	jr _label_08_178		; $607d
	ld hl,sp+$55		; $607f
	rst $38			; $6081
	ld d,l			; $6082
	rst $38			; $6083
	ld d,l			; $6084
	add hl,bc		; $6085
	ld d,(hl)		; $6086
	inc c			; $6087
	ld d,(hl)		; $6088
	ld (de),a		; $6089
	ld d,(hl)		; $608a
	jr _label_08_181		; $608b
	dec hl			; $608d
	ld d,(hl)		; $608e
	ld a,$56		; $608f
	ld c,h			; $6091
	ld d,(hl)		; $6092
	ld e,d			; $6093
	ld d,(hl)		; $6094
	ld l,b			; $6095
	ld d,(hl)		; $6096
	ld a,a			; $6097
	ld d,(hl)		; $6098
	sbc c			; $6099
	ld d,(hl)		; $609a
	and e			; $609b
	ld d,(hl)		; $609c
	xor l			; $609d
	ld d,(hl)		; $609e
	or b			; $609f
	ld d,(hl)		; $60a0
	rst $20			; $60a1
	ld d,(hl)		; $60a2
	ld hl,sp+$56		; $60a3
.DB $fc				; $60a5
	ld d,(hl)		; $60a6
	ld d,$57		; $60a7
	inc e			; $60a9
	ld d,a			; $60aa
	inc hl			; $60ab
	ld d,a			; $60ac
	dec l			; $60ad
	ld d,a			; $60ae
	jr nc,$57		; $60af
	inc sp			; $60b1
	ld d,a			; $60b2
	dec a			; $60b3
	ld d,a			; $60b4
	ld b,b			; $60b5
	ld d,a			; $60b6
	ld b,e			; $60b7
	ld d,a			; $60b8
	ld c,c			; $60b9
	ld d,a			; $60ba
	ld c,a			; $60bb
	ld d,a			; $60bc
	ld d,l			; $60bd
	ld d,a			; $60be
	ld e,b			; $60bf
	ld d,a			; $60c0
	ld e,(hl)		; $60c1
	ld d,a			; $60c2
	ld l,l			; $60c3
	ld d,a			; $60c4
	ld (hl),b		; $60c5
	ld d,a			; $60c6
	ld (hl),e		; $60c7
	ld d,a			; $60c8
	halt			; $60c9
	ld d,a			; $60ca
	cp l			; $60cb
	ld d,a			; $60cc

interactionCode31:
	ld e,$42		; $60cd
	ld a,(de)		; $60cf
	rst_jumpTable			; $60d0
	reti			; $60d1
	ld h,b			; $60d2
	inc e			; $60d3
	ld h,c			; $60d4
	sbc d			; $60d5
	ld h,d			; $60d6
	reti			; $60d7
	ld h,b			; $60d8
	ld e,$44		; $60d9
	ld a,(de)		; $60db
	rst_jumpTable			; $60dc
	pop hl			; $60dd
	ld h,b			; $60de
	ld d,$61		; $60df
	ld a,$01		; $60e1
_label_08_181:
	ld (de),a		; $60e3
	call interactionInitGraphics		; $60e4
	ld a,$0b		; $60e7
	call checkGlobalFlag		; $60e9
	jp nz,interactionDelete		; $60ec
	ld h,d			; $60ef
	ld l,$6b		; $60f0
	ld (hl),$00		; $60f2
	ld l,$49		; $60f4
	ld (hl),$ff		; $60f6
	ld a,$0c		; $60f8
	call checkGlobalFlag		; $60fa
	jr nz,_label_08_182	; $60fd
	ld e,$77		; $60ff
	ld a,$04		; $6101
	ld (de),a		; $6103
_label_08_182:
	ld hl,$5813		; $6104
	call interactionSetScript		; $6107
	ld a,$29		; $610a
	call interactionSetHighTextIndex		; $610c
	call objectGetTileAtPosition		; $610f
	ld (hl),$00		; $6112
	jr _label_08_183		; $6114
	call interactionRunScript		; $6116
_label_08_183:
	jp npcFaceLinkAndAnimate		; $6119
	ld e,$44		; $611c
	ld a,(de)		; $611e
	rst_jumpTable			; $611f
	jr z,_label_08_185	; $6120
	ld d,(hl)		; $6122
	ld h,c			; $6123
	ei			; $6124
	ld h,c			; $6125
	ld l,h			; $6126
	ld h,d			; $6127
	ld a,$01		; $6128
	ld (de),a		; $612a
	call interactionInitGraphics		; $612b
	call makeActiveObjectFollowLink		; $612e
	call interactionSetAlwaysUpdateBit		; $6131
	call objectSetReservedBit1		; $6134
	ld l,$73		; $6137
	ld (hl),$01		; $6139
	ld l,$70		; $613b
	ld e,$4b		; $613d
	ld a,(de)		; $613f
	ldi (hl),a		; $6140
	ld e,$4d		; $6141
	ld a,(de)		; $6143
	ldi (hl),a		; $6144
	ld e,$48		; $6145
	ld a,($d008)		; $6147
	ld (de),a		; $614a
	ld (hl),$00		; $614b
	call interactionSetAnimation		; $614d
	call objectSetVisiblec3		; $6150
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6153
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $6156
	call $61a4		; $6159
	ret c			; $615c
	ld c,$20		; $615d
	call objectUpdateSpeedZ_paramC		; $615f
	call z,$6182		; $6162
	call $628e		; $6165
	ld h,d			; $6168
	ld l,$4b		; $6169
	ld a,(hl)		; $616b
	ld b,a			; $616c
	ld l,$70		; $616d
	cp (hl)			; $616f
	jr nz,_label_08_184	; $6170
	ld l,$4d		; $6172
	ld a,(hl)		; $6174
	ld c,a			; $6175
	ld l,$71		; $6176
	cp (hl)			; $6178
	ret z			; $6179
_label_08_184:
	ld l,$70		; $617a
	ld (hl),b		; $617c
	inc l			; $617d
	ld (hl),c		; $617e
	jp interactionAnimate		; $617f
	ld h,d			; $6182
_label_08_185:
	ld l,$46		; $6183
	ld a,(hl)		; $6185
	or a			; $6186
	jr z,_label_08_186	; $6187
	dec (hl)		; $6189
	ret nz			; $618a
	ld bc,$fe40		; $618b
	jp objectSetSpeedZ		; $618e
_label_08_186:
	ld a,($cc77)		; $6191
	or a			; $6194
	ret z			; $6195
	ld a,($cca4)		; $6196
	and $81			; $6199
	ret nz			; $619b
	ld a,($cc02)		; $619c
	or a			; $619f
	ret nz			; $61a0
	ld (hl),$10		; $61a1
	ret			; $61a3
	ld a,($cc49)		; $61a4
	cp $06			; $61a7
	jr nc,_label_08_188	; $61a9
	ld a,($cc4c)		; $61ab
	ld hl,$61dd		; $61ae
	call findRoomSpecificData		; $61b1
	ret nc			; $61b4
	rst_jumpTable			; $61b5
	cp h			; $61b6
	ld h,c			; $61b7
	jp nc,$d761		; $61b8
	ld h,c			; $61bb
	ld e,$73		; $61bc
	ld a,(de)		; $61be
	or a			; $61bf
	jr nz,_label_08_187	; $61c0
	ld a,($cd00)		; $61c2
	and $01			; $61c5
	jr z,_label_08_187	; $61c7
	ld e,$44		; $61c9
	ld a,$02		; $61cb
	ld (de),a		; $61cd
	scf			; $61ce
	ret			; $61cf
_label_08_187:
	xor a			; $61d0
	ret			; $61d1
	ld e,$73		; $61d2
	xor a			; $61d4
	ld (de),a		; $61d5
	ret			; $61d6
_label_08_188:
	ld e,$44		; $61d7
	ld a,$03		; $61d9
	ld (de),a		; $61db
	ret			; $61dc
.DB $ed				; $61dd
	ld h,c			; $61de
	xor $61			; $61df
.DB $ed				; $61e1
	ld h,c			; $61e2
	di			; $61e3
	ld h,c			; $61e4
	ld hl,sp+$61		; $61e5
	ld a,($ed61)		; $61e7
	ld h,c			; $61ea
.DB $ed				; $61eb
	ld h,c			; $61ec
	nop			; $61ed
	ld h,a			; $61ee
	ld bc,$0077		; $61ef
	nop			; $61f2
	adc d			; $61f3
	ld (bc),a		; $61f4
	or c			; $61f5
	ld (bc),a		; $61f6
	nop			; $61f7
	ld a,($ff00+$02)	; $61f8
	nop			; $61fa
	ld e,$45		; $61fb
	ld a,(de)		; $61fd
	rst_jumpTable			; $61fe
	dec b			; $61ff
	ld h,d			; $6200
	dec h			; $6201
	ld h,d			; $6202
	ld b,e			; $6203
	ld h,d			; $6204
	ld a,$01		; $6205
	ld (de),a		; $6207
	call clearFollowingLinkObject		; $6208
	ld a,$0b		; $620b
	call unsetGlobalFlag		; $620d
	ld a,$01		; $6210
	ld ($cca4),a		; $6212
	ld a,$02		; $6215
	ld ($d008),a		; $6217
	ld a,$29		; $621a
	call interactionSetHighTextIndex		; $621c
	ld hl,$5855		; $621f
	jp interactionSetScript		; $6222
	ld c,$20		; $6225
	call objectUpdateSpeedZ_paramC		; $6227
	call interactionAnimate		; $622a
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $622d
	call interactionRunScript		; $6230
	ret nc			; $6233
	ld e,$45		; $6234
	ld a,$02		; $6236
	ld (de),a		; $6238
	ld bc,$4858		; $6239
	call objectGetRelativeAngle		; $623c
	ld e,$49		; $623f
	ld (de),a		; $6241
	ret			; $6242
	call interactionAnimate		; $6243
	call objectApplySpeed		; $6246
	ld e,$4b		; $6249
	ld a,(de)		; $624b
	cp $48			; $624c
	ret c			; $624e
	ld h,d			; $624f
	ld l,$42		; $6250
	ld b,$06		; $6252
	call clearMemory		; $6254
	ld l,$40		; $6257
	ld (hl),$01		; $6259
	xor a			; $625b
	ld ($cca4),a		; $625c
	call objectGetTileAtPosition		; $625f
	ld (hl),$00		; $6262
	ld a,$28		; $6264
	ld (wActiveMusic),a		; $6266
	jp playSound		; $6269
	call returnIfScrollMode01Unset		; $626c
	ld e,$45		; $626f
	ld a,(de)		; $6271
	rst_jumpTable			; $6272
	ld (hl),a		; $6273
	ld h,d			; $6274
	adc b			; $6275
	ld h,d			; $6276
	ld a,$01		; $6277
	ld (de),a		; $6279
	call clearFollowingLinkObject		; $627a
	ld a,$0b		; $627d
	call unsetGlobalFlag		; $627f
	ld bc,$291a		; $6282
	jp showText		; $6285
	call retIfTextIsActive		; $6288
	jp interactionDelete		; $628b
	ld h,d			; $628e
	ld l,$48		; $628f
	ld a,(hl)		; $6291
	ld l,$72		; $6292
	cp (hl)			; $6294
	ret z			; $6295
	ld (hl),a		; $6296
	jp interactionSetAnimation		; $6297
	ld e,$44		; $629a
	ld a,(de)		; $629c
	rst_jumpTable			; $629d
	and d			; $629e
	ld h,d			; $629f
.DB $db				; $62a0
	ld h,d			; $62a1
	ld a,$01		; $62a2
	ld (de),a		; $62a4
	ld a,$0e		; $62a5
	call checkGlobalFlag		; $62a7
	jp nz,interactionDelete		; $62aa
	ld a,($cc9e)		; $62ad
	or a			; $62b0
	jp nz,interactionDelete		; $62b1
	ld a,d			; $62b4
	ld ($cc9e),a		; $62b5
	ld h,d			; $62b8
	ld l,$40		; $62b9
	set 1,(hl)		; $62bb
	call getRandomNumber		; $62bd
	and $03			; $62c0
	ld hl,$62d3		; $62c2
	rst_addDoubleIndex			; $62c5
	ld e,$70		; $62c6
	ldi a,(hl)		; $62c8
	ld (de),a		; $62c9
	inc e			; $62ca
	ld a,(hl)		; $62cb
	ld (de),a		; $62cc
	ld a,$ff		; $62cd
	ld e,$72		; $62cf
	ld (de),a		; $62d1
	ret			; $62d2
	ld h,l			; $62d3
	ld d,a			; $62d4
	ld h,(hl)		; $62d5
	ld d,(hl)		; $62d6
	ld (hl),l		; $62d7
	daa			; $62d8
	halt			; $62d9
	inc h			; $62da
	ld e,$72		; $62db
	ld a,(de)		; $62dd
	ld b,a			; $62de
	ld a,($cc4c)		; $62df
	cp b			; $62e2
	ret z			; $62e3
	ld (de),a		; $62e4
	ld b,a			; $62e5
	ld e,$70		; $62e6
	ld a,(de)		; $62e8
	cp b			; $62e9
	jr nz,_label_08_189	; $62ea
	call getFreeInteractionSlot		; $62ec
	ret nz			; $62ef
	ld (hl),$60		; $62f0
	inc l			; $62f2
	ld (hl),$45		; $62f3
	ld e,$71		; $62f5
	ld a,(de)		; $62f7
	ld l,$4b		; $62f8
	jp setShortPosition		; $62fa
_label_08_189:
	ld a,$45		; $62fd
	call checkTreasureObtained		; $62ff
	jr c,_label_08_191	; $6302
	ld a,b			; $6304
	cp $60			; $6305
	ret nc			; $6307
_label_08_190:
	xor a			; $6308
	ld ($cc9e),a		; $6309
	jp interactionDelete		; $630c
_label_08_191:
	ld a,$0e		; $630f
	call setGlobalFlag		; $6311
	jr _label_08_190		; $6314

interactionCode32:
	ld e,$44		; $6316
	ld a,(de)		; $6318
	rst_jumpTable			; $6319
	ld e,$63		; $631a
	ld b,l			; $631c
	ld h,e			; $631d
	ld a,$01		; $631e
	ld (de),a		; $6320
	call interactionInitGraphics		; $6321
	ld h,d			; $6324
	ld l,$6b		; $6325
	ld (hl),$00		; $6327
	ld l,$49		; $6329
	ld (hl),$ff		; $632b
	ld l,$42		; $632d
	ld a,(hl)		; $632f
	ld hl,$6369		; $6330
	rst_addDoubleIndex			; $6333
	ldi a,(hl)		; $6334
	ld h,(hl)		; $6335
	ld l,a			; $6336
	call interactionSetScript		; $6337
	call interactionRunScript		; $633a
	call interactionRunScript		; $633d
	jp c,interactionDelete		; $6340
	jr _label_08_194		; $6343
	ld a,($cc49)		; $6345
	dec a			; $6348
	jr nz,_label_08_192	; $6349
	call objectGetTileAtPosition		; $634b
	ld (hl),$00		; $634e
_label_08_192:
	call interactionRunScript		; $6350
	ld c,$28		; $6353
	call objectCheckLinkWithinDistance		; $6355
	jr c,_label_08_193	; $6358
	ld a,$04		; $635a
_label_08_193:
	ld l,$49		; $635c
	cp (hl)			; $635e
	jr z,_label_08_194	; $635f
	ld (hl),a		; $6361
	rrca			; $6362
	call interactionSetAnimation		; $6363
_label_08_194:
	jp interactionAnimateAsNpc		; $6366
	ld h,c			; $6369
	ld e,b			; $636a
	ld h,h			; $636b
	ld e,b			; $636c
	ld l,e			; $636d
	ld e,b			; $636e
	ld (hl),c		; $636f
	ld e,b			; $6370
	ld (hl),h		; $6371
	ld e,b			; $6372
	ld (hl),a		; $6373
	ld e,b			; $6374
	ld h,c			; $6375
	ld e,b			; $6376
	ld h,c			; $6377
	ld e,b			; $6378

interactionCode34:
	call checkInteractionState		; $6379
	jr nz,_label_08_195	; $637c
	ld a,$01		; $637e
	ld (de),a		; $6380
	call interactionInitGraphics		; $6381
_label_08_195:
	call interactionAnimateAsNpc		; $6384
	ld e,$61		; $6387
	ld a,(de)		; $6389
	cp $ff			; $638a
	ret nz			; $638c
	ld a,$50		; $638d
	jp playSound		; $638f

interactionCode35:
	ld e,$44		; $6392
	ld a,(de)		; $6394
	rst_jumpTable			; $6395
	sbc d			; $6396
	ld h,e			; $6397
	ld l,b			; $6398
	ld h,h			; $6399
	call $6537		; $639a
	call interactionInitGraphics		; $639d
	call interactionIncState		; $63a0
	ld e,$43		; $63a3
	ld a,(de)		; $63a5
	ld hl,$66c4		; $63a6
	rst_addDoubleIndex			; $63a9
	ldi a,(hl)		; $63aa
	ld h,(hl)		; $63ab
	ld l,a			; $63ac
	call interactionSetScript		; $63ad
	ld e,$43		; $63b0
	ld a,(de)		; $63b2
	rst_jumpTable			; $63b3
	xor $63			; $63b4
.DB $fc				; $63b6
	ld h,e			; $63b7
	ld hl,$3a64		; $63b8
	ld h,h			; $63bb
.DB $fc				; $63bc
	ld h,e			; $63bd
	ld hl,$3a64		; $63be
	ld h,h			; $63c1
	rst $30			; $63c2
	ld h,e			; $63c3
	jr z,_label_08_197	; $63c4
	ldd a,(hl)		; $63c6
	ld h,h			; $63c7
	ld b,e			; $63c8
	ld h,h			; $63c9
	ld b,a			; $63ca
	ld h,h			; $63cb
	ld h,b			; $63cc
	ld h,h			; $63cd
	ld h,h			; $63ce
	ld h,h			; $63cf
	ld b,e			; $63d0
	ld h,h			; $63d1
	ld c,(hl)		; $63d2
	ld h,h			; $63d3
	ld h,b			; $63d4
	ld h,h			; $63d5
	ld h,h			; $63d6
	ld h,h			; $63d7
	ld b,e			; $63d8
	ld h,h			; $63d9
	ld b,a			; $63da
	ld h,h			; $63db
	ld h,b			; $63dc
	ld h,h			; $63dd
	ld h,h			; $63de
	ld h,h			; $63df
	jr $64			; $63e0
	xor $63			; $63e2
	ldd a,(hl)		; $63e4
	ld h,h			; $63e5
	ld b,e			; $63e6
	ld h,h			; $63e7
	xor $63			; $63e8
	xor $63			; $63ea
	ld h,h			; $63ec
	ld h,h			; $63ed
	ld e,$77		; $63ee
	ld a,(de)		; $63f0
	call interactionSetAnimation		; $63f1
	jp $651f		; $63f4
	ld a,$02		; $63f7
	call $6618		; $63f9
	ld h,d			; $63fc
	ld l,$79		; $63fd
	ld (hl),$01		; $63ff
	ld l,$50		; $6401
	ld (hl),$3c		; $6403
	ld l,$49		; $6405
	ld (hl),$18		; $6407
	ld a,$00		; $6409
_label_08_196:
	ld h,d			; $640b
	ld l,$7a		; $640c
	ld (hl),a		; $640e
	ld l,$77		; $640f
	add (hl)		; $6411
	call interactionSetAnimation		; $6412
	jp $651f		; $6415
	call $63fc		; $6418
	ld h,d			; $641b
	ld l,$50		; $641c
	ld (hl),$28		; $641e
	ret			; $6420
	ld a,$00		; $6421
	call $6618		; $6423
	jr _label_08_198		; $6426
	ld a,$01		; $6428
_label_08_197:
	call $6618		; $642a
_label_08_198:
	ld h,d			; $642d
	ld l,$79		; $642e
	ld (hl),$01		; $6430
	ld l,$50		; $6432
	ld (hl),$50		; $6434
	ld a,$00		; $6436
	jr _label_08_196		; $6438
	ld h,d			; $643a
	ld l,$79		; $643b
	ld (hl),$02		; $643d
	ld a,$00		; $643f
	jr _label_08_196		; $6441
	ld a,$00		; $6443
	jr _label_08_196		; $6445
	ld a,$03		; $6447
	call $6618		; $6449
	jr _label_08_199		; $644c
	ld a,$04		; $644e
	call $6618		; $6450
_label_08_199:
	ld h,d			; $6453
	ld l,$79		; $6454
	ld (hl),$01		; $6456
	ld l,$50		; $6458
	ld (hl),$14		; $645a
	ld a,$00		; $645c
	jr _label_08_196		; $645e
	ld a,$03		; $6460
	jr _label_08_196		; $6462
	ld a,$00		; $6464
	jr _label_08_196		; $6466
	ld e,$43		; $6468
	ld a,(de)		; $646a
	rst_jumpTable			; $646b
	or d			; $646c
	ld h,h			; $646d
	and (hl)		; $646e
	ld h,h			; $646f
	cp e			; $6470
	ld h,h			; $6471
	jp c,$a664		; $6472
	ld h,h			; $6475
	cp e			; $6476
	ld h,h			; $6477
	jp c,$c664		; $6478
	ld h,h			; $647b
	cp e			; $647c
	ld h,h			; $647d
	jp c,$e764		; $647e
	ld h,h			; $6481
	add $64			; $6482
	xor a			; $6484
	ld h,h			; $6485
	nop			; $6486
	ld h,l			; $6487
	rst $20			; $6488
	ld h,h			; $6489
	add $64			; $648a
	xor a			; $648c
	ld h,h			; $648d
	nop			; $648e
	ld h,l			; $648f
	rst $20			; $6490
	ld h,h			; $6491
	add $64			; $6492
	xor a			; $6494
	ld h,h			; $6495
	nop			; $6496
	ld h,l			; $6497
	or l			; $6498
	ld h,h			; $6499
	or d			; $649a
	ld h,h			; $649b
.DB $e4				; $649c
	ld h,h			; $649d
	rst $20			; $649e
	ld h,h			; $649f
	or d			; $64a0
	ld h,h			; $64a1
	or d			; $64a2
	ld h,h			; $64a3
	nop			; $64a4
	ld h,l			; $64a5
	ld e,$46		; $64a6
	ld a,(de)		; $64a8
	or a			; $64a9
	jr nz,_label_08_200	; $64aa
	call $654b		; $64ac
_label_08_200:
	call interactionRunScript		; $64af
	jp $651c		; $64b2
	call $657f		; $64b5
	jp $651c		; $64b8
	ld e,$46		; $64bb
	ld a,(de)		; $64bd
	or a			; $64be
	jr nz,_label_08_201	; $64bf
	call $6593		; $64c1
_label_08_201:
	jr _label_08_206		; $64c4
	ld e,$46		; $64c6
	ld a,(de)		; $64c8
	or a			; $64c9
	jr nz,_label_08_202	; $64ca
	call $65b3		; $64cc
	call $65f4		; $64cf
	call $65cf		; $64d2
	call c,$660c		; $64d5
_label_08_202:
	jr _label_08_206		; $64d8
	call $667b		; $64da
	ld e,$7d		; $64dd
	ld a,(de)		; $64df
	or a			; $64e0
	call z,interactionRunScript		; $64e1
	jp $651c		; $64e4
	ld a,(wFrameCounter)		; $64e7
	and $1f			; $64ea
	jr nz,_label_08_204	; $64ec
	ld e,$61		; $64ee
	ld a,(de)		; $64f0
	and $01			; $64f1
	ld c,$08		; $64f3
	jr nz,_label_08_203	; $64f5
	ld c,$fc		; $64f7
_label_08_203:
	ld b,$f4		; $64f9
	call objectCreateFloatingMusicNote		; $64fb
_label_08_204:
	jr _label_08_206		; $64fe
	ld a,(wFrameCounter)		; $6500
	and $1f			; $6503
	jr nz,_label_08_206	; $6505
	ld e,$48		; $6507
	ld a,(de)		; $6509
	or a			; $650a
	ld c,$fc		; $650b
	jr z,_label_08_205	; $650d
	ld c,$00		; $650f
_label_08_205:
	ld b,$fc		; $6511
	call objectCreateFloatingMusicNote		; $6513
_label_08_206:
	call interactionRunScript		; $6516
	jp $651c		; $6519
	call interactionAnimate		; $651c
	ld e,$79		; $651f
	ld a,(de)		; $6521
	cp $01			; $6522
	jr z,_label_08_207	; $6524
	cp $02			; $6526
	jp z,objectSetPriorityRelativeToLink_withTerrainEffects		; $6528
	call objectPreventLinkFromPassing		; $652b
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $652e
_label_08_207:
	call objectPushLinkAwayOnCollision		; $6531
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6534
	ld e,$42		; $6537
	ld a,(de)		; $6539
	ld hl,$6543		; $653a
	rst_addAToHl			; $653d
	ld a,(hl)		; $653e
	ld e,$77		; $653f
	ld (de),a		; $6541
	ret			; $6542
	nop			; $6543
	ld (bc),a		; $6544
	dec b			; $6545
	ld ($110b),sp		; $6546
	dec d			; $6549
	rla			; $654a
	call objectApplySpeed		; $654b
	ld h,d			; $654e
	ld l,$4d		; $654f
	ld a,(hl)		; $6551
	sub $29			; $6552
	cp $40			; $6554
	ret c			; $6556
	bit 7,a			; $6557
	jr nz,_label_08_208	; $6559
	dec (hl)		; $655b
	dec (hl)		; $655c
_label_08_208:
	inc (hl)		; $655d
	ld l,$7c		; $655e
	ld a,(hl)		; $6560
	inc a			; $6561
	and $03			; $6562
	ld (hl),a		; $6564
	ld bc,$657b		; $6565
	call addAToBc		; $6568
	ld a,(bc)		; $656b
	ld l,$49		; $656c
	ld (hl),a		; $656e
_label_08_209:
	ld l,$7a		; $656f
	ld a,(hl)		; $6571
	xor $01			; $6572
	ld (hl),a		; $6574
	ld l,$77		; $6575
	add (hl)		; $6577
	jp interactionSetAnimation		; $6578
	jr _label_08_211		; $657b
	jr _label_08_210		; $657d
	call objectApplySpeed		; $657f
	ld e,$4d		; $6582
	ld a,(de)		; $6584
_label_08_210:
	sub $14			; $6585
_label_08_211:
	cp $28			; $6587
	ret c			; $6589
	ld h,d			; $658a
	ld l,$49		; $658b
	ld a,(hl)		; $658d
	xor $10			; $658e
	ld (hl),a		; $6590
	jr _label_08_209		; $6591
	ld e,$45		; $6593
	ld a,(de)		; $6595
	rst_jumpTable			; $6596
	sbc e			; $6597
	ld h,l			; $6598
	and h			; $6599
	ld h,l			; $659a
	ld c,$18		; $659b
	call objectCheckLinkWithinDistance		; $659d
	ret nc			; $65a0
	call interactionIncState2		; $65a1
	call $65b3		; $65a4
	call $65cf		; $65a7
	ret nc			; $65aa
	ld h,d			; $65ab
	ld l,$45		; $65ac
	ld (hl),$00		; $65ae
	jp $660c		; $65b0
	ld h,d			; $65b3
	ld l,$7c		; $65b4
	ld a,(hl)		; $65b6
	add a			; $65b7
	ld b,a			; $65b8
	ld e,$7f		; $65b9
	ld a,(de)		; $65bb
	ld l,a			; $65bc
	ld e,$7e		; $65bd
	ld a,(de)		; $65bf
	ld h,a			; $65c0
	ld a,b			; $65c1
	rst_addAToHl			; $65c2
	ld b,(hl)		; $65c3
	inc hl			; $65c4
	ld c,(hl)		; $65c5
	call objectGetRelativeAngle		; $65c6
	ld e,$49		; $65c9
	ld (de),a		; $65cb
	jp objectApplySpeed		; $65cc
	ld h,d			; $65cf
	ld l,$7c		; $65d0
	ld a,(hl)		; $65d2
	add a			; $65d3
	push af			; $65d4
	ld e,$7f		; $65d5
	ld a,(de)		; $65d7
	ld c,a			; $65d8
	ld e,$7e		; $65d9
	ld a,(de)		; $65db
	ld b,a			; $65dc
	pop af			; $65dd
	call addAToBc		; $65de
	ld l,$4b		; $65e1
	ld a,(bc)		; $65e3
	sub (hl)		; $65e4
	add $01			; $65e5
	cp $03			; $65e7
	ret nc			; $65e9
	inc bc			; $65ea
	ld l,$4d		; $65eb
	ld a,(bc)		; $65ed
	sub (hl)		; $65ee
	add $01			; $65ef
	cp $03			; $65f1
	ret			; $65f3
	ld h,d			; $65f4
	ld l,$49		; $65f5
	ld a,(hl)		; $65f7
	swap a			; $65f8
	and $01			; $65fa
	xor $01			; $65fc
	ld l,$48		; $65fe
	cp (hl)			; $6600
	ret z			; $6601
	ld (hl),a		; $6602
	ld l,$7a		; $6603
	add (hl)		; $6605
	ld l,$77		; $6606
	add (hl)		; $6608
	jp interactionSetAnimation		; $6609
	ld h,d			; $660c
	ld l,$7d		; $660d
	ld a,(hl)		; $660f
	ld l,$7c		; $6610
	inc (hl)		; $6612
	cp (hl)			; $6613
	ret nc			; $6614
	ld (hl),$00		; $6615
	ret			; $6617
	add a			; $6618
	add a			; $6619
	ld hl,$662b		; $661a
	rst_addAToHl			; $661d
	ld e,$7f		; $661e
	ldi a,(hl)		; $6620
	ld (de),a		; $6621
	ld e,$7e		; $6622
	ldi a,(hl)		; $6624
	ld (de),a		; $6625
	ld e,$7d		; $6626
	ldi a,(hl)		; $6628
	ld (de),a		; $6629
	ret			; $662a
	ccf			; $662b
	ld h,(hl)		; $662c
	rlca			; $662d
	nop			; $662e
	ld c,a			; $662f
	ld h,(hl)		; $6630
	inc bc			; $6631
	nop			; $6632
	ld d,a			; $6633
	ld h,(hl)		; $6634
	dec bc			; $6635
	nop			; $6636
	ld l,a			; $6637
	ld h,(hl)		; $6638
	ld bc,$7300		; $6639
	ld h,(hl)		; $663c
	inc bc			; $663d
	nop			; $663e
	ld l,b			; $663f
	jr $68			; $6640
	ld l,b			; $6642
	jr z,$68		; $6643
	ld l,b			; $6645
	jr _label_08_213		; $6646
	jr _label_08_217		; $6648
	ld l,b			; $664a
	jr z,$68		; $664b
	jr c,$18		; $664d
	jr $18			; $664f
	ld e,b			; $6651
	jr $58			; $6652
	ld c,b			; $6654
	jr $48			; $6655
	jr z,$48		; $6657
	jr $44			; $6659
	jr _label_08_214		; $665b
	jr nz,$18		; $665d
	inc l			; $665f
	inc c			; $6660
	jr c,_label_08_212	; $6661
	ld b,h			; $6663
	inc c			; $6664
	ld d,b			; $6665
	jr _label_08_219		; $6666
	jr z,_label_08_220	; $6668
	ld b,h			; $666a
_label_08_212:
	ld c,b			; $666b
	ld c,b			; $666c
	jr c,_label_08_218	; $666d
	ld c,b			; $666f
	jr $48			; $6670
	ld l,b			; $6672
	jr _label_08_216		; $6673
	ld e,b			; $6675
	jr nc,_label_08_221	; $6676
	ld c,b			; $6678
	jr $48			; $6679
	ld e,$45		; $667b
	ld a,(de)		; $667d
	rst_jumpTable			; $667e
	add l			; $667f
_label_08_213:
	ld h,(hl)		; $6680
	and e			; $6681
	ld h,(hl)		; $6682
	cp l			; $6683
	ld h,(hl)		; $6684
_label_08_214:
	ld h,d			; $6685
	ld l,$50		; $6686
	ld (hl),$28		; $6688
	ld l,$49		; $668a
	ld (hl),$18		; $668c
_label_08_215:
	ld h,d			; $668e
	ld l,$45		; $668f
	ld (hl),$01		; $6691
	ld l,$7d		; $6693
	ld (hl),$01		; $6695
	ld l,$54		; $6697
	ld (hl),$00		; $6699
	inc hl			; $669b
	ld (hl),$fb		; $669c
	ld a,$53		; $669e
	jp playSound		; $66a0
	ld c,$50		; $66a3
_label_08_216:
	call objectUpdateSpeedZ_paramC		; $66a5
	jp nz,objectApplySpeed		; $66a8
	call interactionIncState2		; $66ab
	ld l,$7d		; $66ae
	ld (hl),$00		; $66b0
_label_08_217:
	ld l,$7c		; $66b2
	ld (hl),$78		; $66b4
	ld l,$49		; $66b6
	ld a,(hl)		; $66b8
	xor $10			; $66b9
_label_08_218:
	ld (hl),a		; $66bb
	ret			; $66bc
	ld h,d			; $66bd
	ld l,$7c		; $66be
_label_08_219:
	dec (hl)		; $66c0
	ret nz			; $66c1
_label_08_220:
	jr _label_08_215		; $66c2
	ld a,d			; $66c4
	ld e,b			; $66c5
	ld a,e			; $66c6
	ld e,b			; $66c7
	add d			; $66c8
	ld e,b			; $66c9
	adc c			; $66ca
	ld e,b			; $66cb
	sub b			; $66cc
	ld e,b			; $66cd
	sbc e			; $66ce
	ld e,b			; $66cf
_label_08_221:
	and (hl)		; $66d0
	ld e,b			; $66d1
	or c			; $66d2
	ld e,b			; $66d3
	push hl			; $66d4
	ld e,b			; $66d5
	add hl,de		; $66d6
	ld e,c			; $66d7
	ld c,l			; $66d8
	ld e,c			; $66d9
	ld e,b			; $66da
	ld e,c			; $66db
	ld h,e			; $66dc
	ld e,c			; $66dd
	ld l,(hl)		; $66de
	ld e,c			; $66df
	ld a,c			; $66e0
	ld e,c			; $66e1
	ld (hl),$5a		; $66e2
	sbc d			; $66e4
	ld e,d			; $66e5
	ret nz			; $66e6
	ld e,d			; $66e7
	push hl			; $66e8
	ld e,d			; $66e9
	daa			; $66ea
	ld e,e			; $66eb
	ld (hl),l		; $66ec
	ld e,e			; $66ed
	adc l			; $66ee
	ld e,e			; $66ef
	ld a,d			; $66f0
	ld e,b			; $66f1
	ld a,d			; $66f2
	ld e,b			; $66f3
	ld a,d			; $66f4
	ld e,b			; $66f5
	ld a,d			; $66f6
	ld e,b			; $66f7
	ld a,d			; $66f8
	ld e,b			; $66f9
	ld a,d			; $66fa
	ld e,b			; $66fb
	ld a,d			; $66fc
	ld e,b			; $66fd

interactionCode3b:
	call checkInteractionState		; $66fe
	jr nz,_label_08_225	; $6701
	ld a,$01		; $6703
	ld (de),a		; $6705
	xor a			; $6706
	ldh (<hFF8D),a	; $6707
	ld a,$41		; $6709
	call checkTreasureObtained		; $670b
	jr nc,_label_08_222	; $670e
	cp $05			; $6710
	jr c,_label_08_222	; $6712
	ld a,$01		; $6714
	ldh (<hFF8D),a	; $6716
_label_08_222:
	ld h,d			; $6718
	ld l,$42		; $6719
	ld a,(hl)		; $671b
	ld b,a			; $671c
	and $0f			; $671d
	ldi (hl),a		; $671f
	ld c,a			; $6720
	ld a,b			; $6721
	swap a			; $6722
	and $0f			; $6724
	ld (hl),a		; $6726
	ld a,c			; $6727
	ld c,$37		; $6728
	cp $07			; $672a
	jr nz,_label_08_223	; $672c
	ld a,($cc01)		; $672e
	ld b,a			; $6731
	ldh a,(<hFF8D)	; $6732
	and b			; $6734
	jp z,interactionDelete		; $6735
	ld c,$53		; $6738
_label_08_223:
	ld a,c			; $673a
	call interactionSetHighTextIndex		; $673b
	call interactionInitGraphics		; $673e
	ld hl,$6808		; $6741
	ldh a,(<hFF8D)	; $6744
	or a			; $6746
	jr z,_label_08_224	; $6747
	ld hl,$6818		; $6749
_label_08_224:
	ld e,$42		; $674c
	ld a,(de)		; $674e
	rst_addDoubleIndex			; $674f
	ldi a,(hl)		; $6750
	ld h,(hl)		; $6751
	ld l,a			; $6752
	call interactionSetScript		; $6753
_label_08_225:
	ld e,$43		; $6756
	ld a,(de)		; $6758
	rst_jumpTable			; $6759
	ld h,b			; $675a
	ld h,a			; $675b
	ld h,(hl)		; $675c
	ld h,a			; $675d
	cp (hl)			; $675e
	ld h,a			; $675f
	call interactionRunScript		; $6760
	jp npcFaceLinkAndAnimate		; $6763
	call interactionRunScript		; $6766
	ld e,$45		; $6769
	ld a,(de)		; $676b
	rst_jumpTable			; $676c
	ld (hl),l		; $676d
	ld h,a			; $676e
	adc d			; $676f
	ld h,a			; $6770
	sbc d			; $6771
	ld h,a			; $6772
	or c			; $6773
	ld h,a			; $6774
	ld c,$28		; $6775
	call objectCheckLinkWithinDistance		; $6777
	jr nc,_label_08_226	; $677a
	call interactionIncState2		; $677c
	call $67fc		; $677f
	add $06			; $6782
	call interactionSetAnimation		; $6784
_label_08_226:
	jp interactionAnimateAsNpc		; $6787
	ld e,$61		; $678a
	ld a,(de)		; $678c
	inc a			; $678d
	jr nz,_label_08_227	; $678e
	call interactionIncState2		; $6790
	ld l,$49		; $6793
	ld (hl),$ff		; $6795
_label_08_227:
	jp interactionAnimateAsNpc		; $6797
	ld c,$28		; $679a
	call objectCheckLinkWithinDistance		; $679c
	jr c,_label_08_228	; $679f
	call interactionIncState2		; $67a1
	call $67fc		; $67a4
	add $07			; $67a7
	call interactionSetAnimation		; $67a9
	jr _label_08_229		; $67ac
_label_08_228:
	jp npcFaceLinkAndAnimate		; $67ae
	ld e,$61		; $67b1
	ld a,(de)		; $67b3
	inc a			; $67b4
	jr nz,_label_08_229	; $67b5
	ld e,$45		; $67b7
	xor a			; $67b9
	ld (de),a		; $67ba
_label_08_229:
	jp interactionAnimateAsNpc		; $67bb
	call interactionAnimate		; $67be
	call interactionAnimate		; $67c1
	call checkInteractionState2		; $67c4
	jr nz,_label_08_231	; $67c7
	ld e,$71		; $67c9
	ld a,(de)		; $67cb
	or a			; $67cc
	jr z,_label_08_230	; $67cd
	xor a			; $67cf
	ld (de),a		; $67d0
	call objectGetAngleTowardLink		; $67d1
	add $04			; $67d4
	add a			; $67d6
	swap a			; $67d7
	and $03			; $67d9
	ld e,$48		; $67db
	ld (de),a		; $67dd
	call interactionSetAnimation		; $67de
	ld bc,$3700		; $67e1
	call showText		; $67e4
	call interactionIncState2		; $67e7
_label_08_230:
	call interactionRunScript		; $67ea
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $67ed
_label_08_231:
	ld e,$76		; $67f0
	ld a,(de)		; $67f2
	call interactionSetAnimation		; $67f3
	ld e,$45		; $67f6
	xor a			; $67f8
	ld (de),a		; $67f9
	jr _label_08_230		; $67fa
	ld e,$4d		; $67fc
	ld a,(de)		; $67fe
	ld hl,$d00d		; $67ff
	cp (hl)			; $6802
	ld a,$02		; $6803
	ret c			; $6805
	xor a			; $6806
	ret			; $6807
	xor a			; $6808
	ld e,e			; $6809
	jp nc,$d65b		; $680a
	ld e,e			; $680d
	sbc $5b			; $680e
.DB $ec				; $6810
	ld e,e			; $6811
	ld a,($ff00+$5b)	; $6812
	ld a,($ff00+c)		; $6814
	ld e,e			; $6815
	jr z,_label_08_235	; $6816
	xor a			; $6818
	ld e,e			; $6819
	call nc,$d65b		; $681a
	ld e,e			; $681d
.DB $e4				; $681e
	ld e,e			; $681f
	xor $5b			; $6820
	ld a,($ff00+$5b)	; $6822
	ld a,($ff00+c)		; $6824
	ld e,e			; $6825
	jr z,$5c		; $6826

interactionCode3e:
	call checkInteractionState		; $6828
	jp nz,$68f5		; $682b
	ld a,$01		; $682e
	ld (de),a		; $6830
	ld h,d			; $6831
	ld l,$42		; $6832
	ld a,(hl)		; $6834
	ld b,a			; $6835
	and $0f			; $6836
	ldi (hl),a		; $6838
	ld a,b			; $6839
	and $f0			; $683a
	swap a			; $683c
	ld (hl),a		; $683e
	cp $03			; $683f
	jr nz,_label_08_233	; $6841
	call $5874		; $6843
	ld e,$42		; $6846
	ld a,(de)		; $6848
	cp b			; $6849
	jp nz,interactionDelete		; $684a
	cp $01			; $684d
	jr nz,_label_08_234	; $684f
	ld a,$16		; $6851
	call checkGlobalFlag		; $6853
	ld a,$6e		; $6856
	jr nz,_label_08_232	; $6858
	ld a,$5e		; $685a
_label_08_232:
	ld hl,$cc4c		; $685c
	cp (hl)			; $685f
	jp nz,interactionDelete		; $6860
	jr _label_08_234		; $6863
_label_08_233:
	add $04			; $6865
	ld b,a			; $6867
	call $57db		; $6868
	jp nc,interactionDelete		; $686b
_label_08_234:
	ld e,$42		; $686e
	ld a,b			; $6870
	ld (de),a		; $6871
	inc e			; $6872
	ld a,(de)		; $6873
_label_08_235:
	rst_jumpTable			; $6874
	ld a,l			; $6875
	ld l,b			; $6876
	sbc e			; $6877
	ld l,b			; $6878
	jp nz,$9b68		; $6879
	ld l,b			; $687c
	call $689b		; $687d
	call getFreeInteractionSlot		; $6880
	jr nz,_label_08_236	; $6883
	ld (hl),$83		; $6885
	ld bc,$00fd		; $6887
	call objectCopyPositionWithOffset		; $688a
	ld l,$4b		; $688d
	ld a,(hl)		; $688f
	ld l,$76		; $6890
	ld (hl),a		; $6892
	ld l,$4d		; $6893
	ld a,(hl)		; $6895
	ld l,$77		; $6896
	ld (hl),a		; $6898
_label_08_236:
	jr _label_08_237		; $6899
	ld h,d			; $689b
	ld l,$42		; $689c
	ldi a,(hl)		; $689e
	push af			; $689f
	ldd a,(hl)		; $68a0
	ld (hl),a		; $68a1
	call interactionInitGraphics		; $68a2
	pop af			; $68a5
	ld e,$42		; $68a6
	ld (de),a		; $68a8
	inc e			; $68a9
	ld a,(de)		; $68aa
	ld hl,$6ac9		; $68ab
	rst_addDoubleIndex			; $68ae
	ldi a,(hl)		; $68af
	ld h,(hl)		; $68b0
	ld l,a			; $68b1
	ld e,$42		; $68b2
	ld a,(de)		; $68b4
	rst_addDoubleIndex			; $68b5
	ldi a,(hl)		; $68b6
	ld h,(hl)		; $68b7
	ld l,a			; $68b8
	call interactionSetScript		; $68b9
	call interactionRunScript		; $68bc
	jp objectSetVisible82		; $68bf
	ld a,($cc4e)		; $68c2
	cp $03			; $68c5
	jp z,interactionDelete		; $68c7
	call $689b		; $68ca
	ld a,($cc4e)		; $68cd
	cp $00			; $68d0
	ret nz			; $68d2
	ld h,d			; $68d3
	ld l,$49		; $68d4
	ld (hl),$08		; $68d6
	ld l,$50		; $68d8
	ld (hl),$28		; $68da
	ld l,$4b		; $68dc
	ld (hl),$62		; $68de
	ld l,$4d		; $68e0
	ld (hl),$28		; $68e2
	ld a,$06		; $68e4
	jp interactionSetAnimation		; $68e6
_label_08_237:
	call getRandomNumber		; $68e9
	and $3f			; $68ec
	add $78			; $68ee
	ld h,d			; $68f0
	ld l,$76		; $68f1
	ld (hl),a		; $68f3
	ret			; $68f4
	ld e,$43		; $68f5
	ld a,(de)		; $68f7
	rst_jumpTable			; $68f8
	ld bc,$3969		; $68f9
	ld l,c			; $68fc
	ld e,d			; $68fd
	ld l,c			; $68fe
	ld d,h			; $68ff
	ld l,c			; $6900
	ld e,$45		; $6901
	ld a,(de)		; $6903
	rst_jumpTable			; $6904
	add hl,bc		; $6905
	ld l,c			; $6906
	jr nz,_label_08_242	; $6907
	call $6abc		; $6909
	jr nz,_label_08_238	; $690c
	ld l,$60		; $690e
	ld (hl),$01		; $6910
	call interactionIncState2		; $6912
	ld hl,$cceb		; $6915
	ld (hl),$01		; $6918
	call interactionAnimate		; $691a
_label_08_238:
	jp $6933		; $691d
	ld a,($cceb)		; $6920
	cp $02			; $6923
	jr nz,_label_08_239	; $6925
	call $68e9		; $6927
	ld l,$45		; $692a
	ld (hl),$00		; $692c
	ld a,$08		; $692e
	call interactionSetAnimation		; $6930
_label_08_239:
	call interactionRunScript		; $6933
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $6936
	ld h,d			; $6939
	ld l,$42		; $693a
	ld a,(hl)		; $693c
	cp $02			; $693d
	jr c,_label_08_241	; $693f
	call checkInteractionState2		; $6941
	jr nz,_label_08_240	; $6944
	call interactionIncState2		; $6946
	xor a			; $6949
	ld l,$4e		; $694a
	ldi (hl),a		; $694c
	ld (hl),a		; $694d
	call $5dfe		; $694e
_label_08_240:
	call $5df7		; $6951
_label_08_241:
	call interactionRunScript		; $6954
	jp interactionAnimateAsNpc		; $6957
	ld a,($cc4e)		; $695a
	cp $00			; $695d
	jp nz,$6954		; $695f
	ld e,$45		; $6962
	ld a,(de)		; $6964
	rst_jumpTable			; $6965
	add b			; $6966
	ld l,c			; $6967
	xor h			; $6968
	ld l,c			; $6969
	cp e			; $696a
	ld l,c			; $696b
	ret c			; $696c
	ld l,c			; $696d
.DB $e4				; $696e
	ld l,c			; $696f
	ld b,$6a		; $6970
_label_08_242:
	ld a,(de)		; $6972
	ld l,d			; $6973
	ld hl,$496a		; $6974
	ld l,d			; $6977
	ld e,e			; $6978
	ld l,d			; $6979
	ld c,c			; $697a
	ld l,d			; $697b
	ld a,a			; $697c
	ld l,d			; $697d
	and (hl)		; $697e
	ld l,d			; $697f
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6980
	jr nc,_label_08_243	; $6983
	ld h,d			; $6985
	ld l,$77		; $6986
	ld (hl),$0c		; $6988
_label_08_243:
	call $6ac1		; $698a
	jp nz,$6ab6		; $698d
	call objectApplySpeed		; $6990
	cp $4b			; $6993
	jr c,_label_08_244	; $6995
	call interactionIncState2		; $6997
	ld bc,$fe80		; $699a
	call objectSetSpeedZ		; $699d
	ld l,$50		; $69a0
	ld (hl),$14		; $69a2
	ld a,$09		; $69a4
	call interactionSetAnimation		; $69a6
_label_08_244:
	jp $6ab3		; $69a9
	ld a,($ccc3)		; $69ac
	or a			; $69af
	ret nz			; $69b0
	inc a			; $69b1
	ld ($ccc3),a		; $69b2
	call interactionIncState2		; $69b5
	jp objectSetVisiblec2		; $69b8
	ld c,$20		; $69bb
	call objectUpdateSpeedZ_paramC		; $69bd
	jp nz,objectApplySpeed		; $69c0
	call interactionIncState2		; $69c3
	ld l,$76		; $69c6
	ld (hl),$28		; $69c8
	call objectCenterOnTile		; $69ca
	ld l,$4b		; $69cd
	ld a,(hl)		; $69cf
	sub $05			; $69d0
	ld (hl),a		; $69d2
	ld a,$06		; $69d3
	jp interactionSetAnimation		; $69d5
	call $6abc		; $69d8
	ret nz			; $69db
	call interactionIncState2		; $69dc
	ld a,$05		; $69df
	jp interactionSetAnimation		; $69e1
	ld e,$4f		; $69e4
	ld a,($ccc3)		; $69e6
	ld (de),a		; $69e9
	or a			; $69ea
	ret nz			; $69eb
	call interactionIncState2		; $69ec
	ld bc,$fd40		; $69ef
	call objectSetSpeedZ		; $69f2
	ld l,$4f		; $69f5
	ld (hl),$f6		; $69f7
	ld l,$50		; $69f9
	ld (hl),$28		; $69fb
	ld l,$49		; $69fd
	ld (hl),$00		; $69ff
	ld a,$53		; $6a01
	jp playSound		; $6a03
	ld c,$20		; $6a06
	call objectUpdateSpeedZ_paramC		; $6a08
	jp nz,objectApplySpeed		; $6a0b
	call interactionIncState2		; $6a0e
	ld l,$76		; $6a11
	ld (hl),$10		; $6a13
	ld l,$71		; $6a15
	ld (hl),$00		; $6a17
	ret			; $6a19
	call $6abc		; $6a1a
	ret nz			; $6a1d
	jp interactionIncState2		; $6a1e
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6a21
	jr nc,_label_08_245	; $6a24
	ld h,d			; $6a26
	ld l,$77		; $6a27
	ld (hl),$0c		; $6a29
_label_08_245:
	call $6ac1		; $6a2b
	jp nz,$6ab6		; $6a2e
	call objectApplySpeed		; $6a31
	ld e,$4b		; $6a34
	ld a,(de)		; $6a36
	cp $28			; $6a37
	jr nc,_label_08_246	; $6a39
	call interactionIncState2		; $6a3b
	ld l,$76		; $6a3e
	ld (hl),$06		; $6a40
	ld l,$49		; $6a42
	ld (hl),$18		; $6a44
_label_08_246:
	jp $6ab3		; $6a46
	call $6abc		; $6a49
	ret nz			; $6a4c
	ld l,$49		; $6a4d
	ld a,(hl)		; $6a4f
	swap a			; $6a50
	rlca			; $6a52
	add $05			; $6a53
	call interactionSetAnimation		; $6a55
	jp interactionIncState2		; $6a58
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6a5b
	jr nc,_label_08_247	; $6a5e
	ld h,d			; $6a60
	ld l,$77		; $6a61
	ld (hl),$0c		; $6a63
_label_08_247:
	call $6ac1		; $6a65
	jr nz,_label_08_251	; $6a68
	call objectApplySpeed		; $6a6a
	cp $18			; $6a6d
	jr nc,_label_08_248	; $6a6f
	call interactionIncState2		; $6a71
	ld l,$76		; $6a74
	ld (hl),$06		; $6a76
	ld l,$49		; $6a78
	ld (hl),$10		; $6a7a
_label_08_248:
	jp $6ab3		; $6a7c
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $6a7f
	jr nc,_label_08_249	; $6a82
	ld h,d			; $6a84
	ld l,$77		; $6a85
	ld (hl),$0c		; $6a87
_label_08_249:
	call $6ac1		; $6a89
	jr nz,_label_08_251	; $6a8c
	call objectApplySpeed		; $6a8e
	ld e,$4b		; $6a91
	ld a,(de)		; $6a93
	cp $62			; $6a94
	jr c,_label_08_250	; $6a96
	call interactionIncState2		; $6a98
	ld l,$76		; $6a9b
	ld (hl),$06		; $6a9d
	ld l,$49		; $6a9f
	ld (hl),$08		; $6aa1
_label_08_250:
	jp $6ab3		; $6aa3
	call $6abc		; $6aa6
	ret nz			; $6aa9
	ld l,$45		; $6aaa
	ld (hl),$00		; $6aac
	ld a,$06		; $6aae
	jp interactionSetAnimation		; $6ab0
	call interactionAnimate		; $6ab3
_label_08_251:
	call interactionRunScript		; $6ab6
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6ab9
	ld h,d			; $6abc
	ld l,$76		; $6abd
	dec (hl)		; $6abf
	ret			; $6ac0
	ld h,d			; $6ac1
	ld l,$77		; $6ac2
	ld a,(hl)		; $6ac4
	or a			; $6ac5
	ret z			; $6ac6
	dec (hl)		; $6ac7
	ret			; $6ac8
	pop de			; $6ac9
	ld l,d			; $6aca
	rst $20			; $6acb
	ld l,d			; $6acc
.DB $fd				; $6acd
	ld l,d			; $6ace
	inc de			; $6acf
	ld l,e			; $6ad0
	ld b,(hl)		; $6ad1
	ld e,h			; $6ad2
	ld c,c			; $6ad3
	ld e,h			; $6ad4
	ld c,c			; $6ad5
	ld e,h			; $6ad6
	ld d,h			; $6ad7
	ld e,h			; $6ad8
	ld e,d			; $6ad9
	ld e,h			; $6ada
	ld e,d			; $6adb
	ld e,h			; $6adc
	ld e,l			; $6add
	ld e,h			; $6ade
	ld e,l			; $6adf
	ld e,h			; $6ae0
	ld h,b			; $6ae1
	ld e,h			; $6ae2
	ld d,a			; $6ae3
	ld e,h			; $6ae4
	ld e,d			; $6ae5
	ld e,h			; $6ae6
	ld h,e			; $6ae7
	ld e,h			; $6ae8
	ld h,e			; $6ae9
	ld e,h			; $6aea
	ld l,(hl)		; $6aeb
	ld e,h			; $6aec
	ld l,(hl)		; $6aed
	ld e,h			; $6aee
	add l			; $6aef
	ld e,h			; $6af0
	adc b			; $6af1
	ld e,h			; $6af2
	adc e			; $6af3
	ld e,h			; $6af4
	sbc a			; $6af5
	ld e,h			; $6af6
	xor c			; $6af7
	ld e,h			; $6af8
	ld l,(hl)		; $6af9
	ld e,h			; $6afa
	adc b			; $6afb
	ld e,h			; $6afc
	or e			; $6afd
	ld e,h			; $6afe
	or e			; $6aff
	ld e,h			; $6b00
	or e			; $6b01
	ld e,h			; $6b02
	or e			; $6b03
	ld e,h			; $6b04
	push bc			; $6b05
	ld e,h			; $6b06
	push bc			; $6b07
	ld e,h			; $6b08
	push bc			; $6b09
	ld e,h			; $6b0a
	push bc			; $6b0b
	ld e,h			; $6b0c
	push bc			; $6b0d
	ld e,h			; $6b0e
	or e			; $6b0f
	ld e,h			; $6b10
	ret z			; $6b11
	ld e,h			; $6b12
	bit 3,h			; $6b13
	jp nc,$e65c		; $6b15
	ld e,h			; $6b18
	jp hl			; $6b19
	ld e,h			; $6b1a
	and $5c			; $6b1b

interactionCode40:
interactionCode41:
	ld e,$44		; $6b1d
	ld a,(de)		; $6b1f
	rst_jumpTable			; $6b20
	dec h			; $6b21
	ld l,e			; $6b22
	or c			; $6b23
	ld l,e			; $6b24
	ld e,$42		; $6b25
	ld a,(de)		; $6b27
	rst_jumpTable			; $6b28
	ld b,a			; $6b29
	ld l,e			; $6b2a
	ld c,d			; $6b2b
	ld l,e			; $6b2c
	ld c,d			; $6b2d
	ld l,e			; $6b2e
	ld c,d			; $6b2f
	ld l,e			; $6b30
	ld c,d			; $6b31
	ld l,e			; $6b32
	ld c,d			; $6b33
	ld l,e			; $6b34
	ld c,d			; $6b35
	ld l,e			; $6b36
	ld d,a			; $6b37
	ld l,e			; $6b38
	ld d,a			; $6b39
	ld l,e			; $6b3a
	ld c,d			; $6b3b
	ld l,e			; $6b3c
	ld a,(hl)		; $6b3d
	ld l,e			; $6b3e
	ld e,(hl)		; $6b3f
	ld l,e			; $6b40
	ld e,(hl)		; $6b41
	ld l,e			; $6b42
	ld e,(hl)		; $6b43
	ld l,e			; $6b44
	ld e,(hl)		; $6b45
	ld l,e			; $6b46
	call $6c3c		; $6b47
	ld a,$13		; $6b4a
	call checkGlobalFlag		; $6b4c
	jp nz,interactionDelete		; $6b4f
	call objectGetTileAtPosition		; $6b52
	ld (hl),$00		; $6b55
	call $6b91		; $6b57
	ld a,$04		; $6b5a
	jr _label_08_253		; $6b5c
	ld a,$13		; $6b5e
	call checkGlobalFlag		; $6b60
	jp z,interactionDelete		; $6b63
	ld a,$17		; $6b66
	call checkGlobalFlag		; $6b68
	jp nz,interactionDelete		; $6b6b
	call $6b91		; $6b6e
	ld e,$42		; $6b71
	ld a,(de)		; $6b73
	cp $0d			; $6b74
	ld a,$00		; $6b76
	jr z,_label_08_252	; $6b78
	ld a,$04		; $6b7a
_label_08_252:
	jr _label_08_253		; $6b7c
	call getThisRoomFlags		; $6b7e
	bit 6,(hl)		; $6b81
	jp nz,interactionDelete		; $6b83
	call $6b91		; $6b86
	ld a,$04		; $6b89
_label_08_253:
	call interactionSetAnimation		; $6b8b
	jp $6bc4		; $6b8e
	call interactionInitGraphics		; $6b91
	ld h,d			; $6b94
	ld l,$44		; $6b95
	ld (hl),$01		; $6b97
	ld a,$3a		; $6b99
	call interactionSetHighTextIndex		; $6b9b
	call $6c29		; $6b9e
	ld e,$42		; $6ba1
	ld a,(de)		; $6ba3
	ld hl,$6cbf		; $6ba4
	rst_addDoubleIndex			; $6ba7
	ldi a,(hl)		; $6ba8
	ld h,(hl)		; $6ba9
	ld l,a			; $6baa
	call interactionSetScript		; $6bab
	jp interactionRunScript		; $6bae
	ld e,$42		; $6bb1
	ld a,(de)		; $6bb3
	cp $08			; $6bb4
	jr nz,_label_08_254	; $6bb6
	call $6c51		; $6bb8
_label_08_254:
	call interactionRunScript		; $6bbb
	jp c,interactionDelete		; $6bbe
	jp $6bc4		; $6bc1
	call interactionAnimate		; $6bc4
	ld e,$7c		; $6bc7
	ld a,(de)		; $6bc9
	or a			; $6bca
	jr nz,_label_08_256	; $6bcb
	ld e,$60		; $6bcd
	ld a,(de)		; $6bcf
	dec a			; $6bd0
	jr nz,_label_08_255	; $6bd1
	call getRandomNumber_noPreserveVars		; $6bd3
	and $1f			; $6bd6
	ld hl,$6c09		; $6bd8
	rst_addAToHl			; $6bdb
	ld a,(hl)		; $6bdc
	or a			; $6bdd
	jr z,_label_08_255	; $6bde
	ld e,$60		; $6be0
	ld (de),a		; $6be2
_label_08_255:
	call objectPreventLinkFromPassing		; $6be3
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6be6
_label_08_256:
	ld e,$50		; $6be9
	ld a,(de)		; $6beb
	cp $28			; $6bec
	jr z,_label_08_257	; $6bee
	cp $50			; $6bf0
	jr z,_label_08_258	; $6bf2
	ret			; $6bf4
_label_08_257:
	ld e,$60		; $6bf5
	ld a,(de)		; $6bf7
	cp $09			; $6bf8
	ret nz			; $6bfa
	jr _label_08_259		; $6bfb
_label_08_258:
	ld e,$60		; $6bfd
	ld a,(de)		; $6bff
	cp $0c			; $6c00
	ret nz			; $6c02
_label_08_259:
	ld e,$60		; $6c03
	ld a,$01		; $6c05
	ld (de),a		; $6c07
	ret			; $6c08
	nop			; $6c09
	nop			; $6c0a
	inc b			; $6c0b
	inc b			; $6c0c
	nop			; $6c0d
	nop			; $6c0e
	ld ($0008),sp		; $6c0f
	nop			; $6c12
	nop			; $6c13
	nop			; $6c14
	inc b			; $6c15
	inc b			; $6c16
	nop			; $6c17
	nop			; $6c18
	nop			; $6c19
	ld ($0008),sp		; $6c1a
	nop			; $6c1d
	nop			; $6c1e
	stop			; $6c1f
	stop			; $6c20
	nop			; $6c21
	nop			; $6c22
	nop			; $6c23
	jr nz,_label_08_262	; $6c24
	nop			; $6c26
	nop			; $6c27
	nop			; $6c28
	ld a,$40		; $6c29
	call checkTreasureObtained		; $6c2b
	jr c,_label_08_260	; $6c2e
	xor a			; $6c30
_label_08_260:
	cp $20			; $6c31
	ld a,$01		; $6c33
	jr nc,_label_08_261	; $6c35
	xor a			; $6c37
_label_08_261:
	ld e,$7a		; $6c38
	ld (de),a		; $6c3a
	ret			; $6c3b
	ld a,$4a		; $6c3c
	call checkTreasureObtained		; $6c3e
	jr c,_label_08_262	; $6c41
	xor a			; $6c43
	jr _label_08_263		; $6c44
_label_08_262:
	or a			; $6c46
	ld a,$01		; $6c47
	jr z,_label_08_263	; $6c49
	ld a,$02		; $6c4b
_label_08_263:
	ld e,$7b		; $6c4d
	ld (de),a		; $6c4f
	ret			; $6c50
	call $6c8b		; $6c51
	jr z,_label_08_265	; $6c54
	ld a,($cc46)		; $6c56
	bit 6,a			; $6c59
	jr z,_label_08_264	; $6c5b
	ld c,$01		; $6c5d
	ld b,$db		; $6c5f
	jp $6c78		; $6c61
_label_08_264:
	ld a,($cc45)		; $6c64
	bit 6,a			; $6c67
	ret nz			; $6c69
_label_08_265:
	ld h,d			; $6c6a
	ld l,$7e		; $6c6b
	ld a,$00		; $6c6d
	cp (hl)			; $6c6f
	ret z			; $6c70
	ld c,$00		; $6c71
	ld b,$d9		; $6c73
	jp $6c78		; $6c75
	ld h,d			; $6c78
	ld l,$7e		; $6c79
	ld (hl),c		; $6c7b
	ld a,$05		; $6c7c
	ld l,$7f		; $6c7e
	add (hl)		; $6c80
	ld c,a			; $6c81
	ld a,b			; $6c82
	call setTile		; $6c83
	ld a,$70		; $6c86
	jp playSound		; $6c88
	ld hl,$6cb2		; $6c8b
	ld a,($d00b)		; $6c8e
	ld c,a			; $6c91
	ld a,($d00d)		; $6c92
	ld b,a			; $6c95
_label_08_266:
	ldi a,(hl)		; $6c96
	or a			; $6c97
	ret z			; $6c98
	add $04			; $6c99
	sub c			; $6c9b
	cp $09			; $6c9c
	jr nc,_label_08_267	; $6c9e
	ldi a,(hl)		; $6ca0
	add $03			; $6ca1
	sub b			; $6ca3
	cp $07			; $6ca4
	jr nc,_label_08_268	; $6ca6
	ld a,(hl)		; $6ca8
	ld e,$7f		; $6ca9
	ld (de),a		; $6cab
	or d			; $6cac
	ret			; $6cad
_label_08_267:
	inc hl			; $6cae
_label_08_268:
	inc hl			; $6caf
	jr _label_08_266		; $6cb0
	jr $58			; $6cb2
	nop			; $6cb4
	jr $68			; $6cb5
	ld bc,$7818		; $6cb7
	ld (bc),a		; $6cba
	jr -$78			; $6cbb
	inc bc			; $6cbd
	nop			; $6cbe
.DB $ec				; $6cbf
	ld e,h			; $6cc0
	add l			; $6cc1
	ld e,l			; $6cc2
	add l			; $6cc3
	ld e,l			; $6cc4
	add l			; $6cc5
	ld e,l			; $6cc6
	add l			; $6cc7
	ld e,l			; $6cc8
	cp h			; $6cc9
	ld e,l			; $6cca
	cp h			; $6ccb
	ld e,l			; $6ccc
.DB $dd				; $6ccd
	ld e,l			; $6cce
	ld c,e			; $6ccf
	ld e,(hl)		; $6cd0
	ld (hl),h		; $6cd1
	ld e,(hl)		; $6cd2
	halt			; $6cd3
	ld e,(hl)		; $6cd4
	sub e			; $6cd5
	ld e,(hl)		; $6cd6
	sub a			; $6cd7
	ld e,(hl)		; $6cd8
	ret			; $6cd9
	ld e,(hl)		; $6cda
	push hl			; $6cdb
	ld e,(hl)		; $6cdc

interactionCode42:
	ld e,$44		; $6cdd
	ld a,(de)		; $6cdf
	rst_jumpTable			; $6ce0
	push hl			; $6ce1
	ld l,h			; $6ce2
	ld c,$6d		; $6ce3
	ld a,$13		; $6ce5
	call checkGlobalFlag		; $6ce7
	ld b,$00		; $6cea
	jr nz,_label_08_269	; $6cec
	inc b			; $6cee
_label_08_269:
	ld e,$42		; $6cef
	ld a,(de)		; $6cf1
	cp b			; $6cf2
	jp z,interactionDelete		; $6cf3
	call interactionInitGraphics		; $6cf6
	call interactionIncState		; $6cf9
	ld l,$42		; $6cfc
	ld a,(hl)		; $6cfe
	ld hl,$6d14		; $6cff
	rst_addDoubleIndex			; $6d02
	ldi a,(hl)		; $6d03
	ld h,(hl)		; $6d04
	ld l,a			; $6d05
	call interactionSetScript		; $6d06
	ld a,$02		; $6d09
	call interactionSetAnimation		; $6d0b
	call interactionRunScript		; $6d0e
	jp npcFaceLinkAndAnimate		; $6d11
	inc e			; $6d14
	ld e,a			; $6d15
	rra			; $6d16
	ld e,a			; $6d17

interactionCode43:
	call $479a		; $6d18
	call $6d21		; $6d1b
	jp interactionAnimateAsNpc		; $6d1e
	ld e,$44		; $6d21
	ld a,(de)		; $6d23
	rst_jumpTable			; $6d24
	dec hl			; $6d25
	ld l,l			; $6d26
	ld c,a			; $6d27
	ld l,l			; $6d28
	push bc			; $6d29
	ld l,l			; $6d2a
	ld a,$01		; $6d2b
	ld (de),a		; $6d2d
	call interactionInitGraphics		; $6d2e
	call interactionSetAlwaysUpdateBit		; $6d31
	ld l,$66		; $6d34
	ld (hl),$12		; $6d36
	inc l			; $6d38
	ld (hl),$07		; $6d39
	ld e,$71		; $6d3b
	call objectAddToAButtonSensitiveObjectList		; $6d3d
	call getThisRoomFlags		; $6d40
	and $40			; $6d43
	ld hl,$5f22		; $6d45
	jr z,_label_08_270	; $6d48
	ld hl,$5f50		; $6d4a
_label_08_270:
	jr _label_08_278		; $6d4d
	ld e,$71		; $6d4f
	ld a,(de)		; $6d51
	or a			; $6d52
	ret z			; $6d53
	xor a			; $6d54
	ld (de),a		; $6d55
	ld a,$81		; $6d56
	ld ($cca4),a		; $6d58
	ld a,($cc75)		; $6d5b
	or a			; $6d5e
	jr z,_label_08_276	; $6d5f
	ld a,($d019)		; $6d61
	ld h,a			; $6d64
	ld e,$7c		; $6d65
	ld (de),a		; $6d67
	ld l,$42		; $6d68
	ld a,(hl)		; $6d6a
	push af			; $6d6b
	ld b,a			; $6d6c
	sub $07			; $6d6d
	ld e,$78		; $6d6f
	ld (de),a		; $6d71
	ld a,b			; $6d72
	ld hl,$4c93		; $6d73
	rst_addAToHl			; $6d76
	ld a,(hl)		; $6d77
	call cpRupeeValue		; $6d78
	ld e,$79		; $6d7b
	ld (de),a		; $6d7d
	ld ($cbad),a		; $6d7e
	pop af			; $6d81
	cp $07			; $6d82
	jr z,_label_08_273	; $6d84
	cp $09			; $6d86
	jr z,_label_08_273	; $6d88
	cp $0b			; $6d8a
	jr z,_label_08_271	; $6d8c
	ld a,($c6ba)		; $6d8e
	jr _label_08_272		; $6d91
_label_08_271:
	ld a,($c6ad)		; $6d93
_label_08_272:
	cp $99			; $6d96
	ld a,$01		; $6d98
	jr nc,_label_08_275	; $6d9a
	jr _label_08_274		; $6d9c
_label_08_273:
	ld a,$2f		; $6d9e
	call checkTreasureObtained		; $6da0
	ld a,$01		; $6da3
	jr c,_label_08_275	; $6da5
_label_08_274:
	xor a			; $6da7
_label_08_275:
	ld e,$7a		; $6da8
	ld (de),a		; $6daa
	ld hl,$5f68		; $6dab
	jr _label_08_278		; $6dae
_label_08_276:
	call $4a93		; $6db0
	jr z,_label_08_277	; $6db3
	ld hl,$5f64		; $6db5
	jr _label_08_278		; $6db8
_label_08_277:
	ld hl,$5f60		; $6dba
_label_08_278:
	ld e,$44		; $6dbd
	ld a,$02		; $6dbf
	ld (de),a		; $6dc1
	jp interactionSetScript		; $6dc2
	call interactionRunScript		; $6dc5
	ret nc			; $6dc8
	xor a			; $6dc9
	ld ($cca4),a		; $6dca
	ld e,$7b		; $6dcd
	ld a,(de)		; $6dcf
	or a			; $6dd0
	jr z,_label_08_280	; $6dd1
	inc a			; $6dd3
	ld c,$03		; $6dd4
	jr nz,_label_08_279	; $6dd6
	ld c,$04		; $6dd8
_label_08_279:
	xor a			; $6dda
	ld (de),a		; $6ddb
	ld e,$7c		; $6ddc
	ld a,(de)		; $6dde
	ld h,a			; $6ddf
	ld l,$44		; $6de0
	ld (hl),c		; $6de2
	call dropLinkHeldItem		; $6de3
_label_08_280:
	ld e,$44		; $6de6
	ld a,$01		; $6de8
	ld (de),a		; $6dea
	ret			; $6deb

interactionCode44:
	ld e,$44		; $6dec
	ld a,(de)		; $6dee
	rst_jumpTable			; $6def
.DB $f4				; $6df0
	ld l,l			; $6df1
	ld h,d			; $6df2
	ld l,(hl)		; $6df3
	ld a,$01		; $6df4
	ld (de),a		; $6df6
	ld e,$42		; $6df7
	ld a,(de)		; $6df9
	ld b,a			; $6dfa
	ld hl,$6ea3		; $6dfb
	rst_addDoubleIndex			; $6dfe
	ldi a,(hl)		; $6dff
	ld h,(hl)		; $6e00
	ld l,a			; $6e01
	call interactionSetScript		; $6e02
	ld a,b			; $6e05
	or a			; $6e06
	jr z,_label_08_282	; $6e07
	cp $08			; $6e09
	jr z,_label_08_284	; $6e0b
	cp $09			; $6e0d
	jr z,_label_08_285	; $6e0f
_label_08_281:
	call objectSetVisible82		; $6e11
	call interactionInitGraphics		; $6e14
	jr _label_08_286		; $6e17
_label_08_282:
	ld a,$b0		; $6e19
	ld ($cc1d),a		; $6e1b
	ld ($cc17),a		; $6e1e
	call getThisRoomFlags		; $6e21
	bit 7,a			; $6e24
	jr z,_label_08_283	; $6e26
	ld a,$01		; $6e28
	ld ($ccab),a		; $6e2a
	ld a,(wActiveMusic)		; $6e2d
	or a			; $6e30
	jr z,_label_08_283	; $6e31
	xor a			; $6e33
	ld (wActiveMusic),a		; $6e34
	ld a,$38		; $6e37
	call playSound		; $6e39
_label_08_283:
	ld hl,$cbb3		; $6e3c
	ld b,$10		; $6e3f
	call clearMemory		; $6e41
	jr _label_08_281		; $6e44
_label_08_284:
	call seasonsFunc_3d3d		; $6e46
	bit 7,c			; $6e49
	jp nz,interactionDelete		; $6e4b
	jr _label_08_281		; $6e4e
_label_08_285:
	ld a,$23		; $6e50
	call checkGlobalFlag		; $6e52
	jp z,interactionDelete		; $6e55
	ld a,$1e		; $6e58
	call checkGlobalFlag		; $6e5a
	jp nz,interactionDelete		; $6e5d
	jr _label_08_281		; $6e60
_label_08_286:
	ld e,$42		; $6e62
	ld a,(de)		; $6e64
	rst_jumpTable			; $6e65
	ld a,d			; $6e66
	ld l,(hl)		; $6e67
	ld a,d			; $6e68
	ld l,(hl)		; $6e69
	ld a,d			; $6e6a
	ld l,(hl)		; $6e6b
	ld a,d			; $6e6c
	ld l,(hl)		; $6e6d
	ld a,d			; $6e6e
	ld l,(hl)		; $6e6f
	add b			; $6e70
	ld l,(hl)		; $6e71
	adc e			; $6e72
	ld l,(hl)		; $6e73
	sub h			; $6e74
	ld l,(hl)		; $6e75
	sbc d			; $6e76
	ld l,(hl)		; $6e77
	sub h			; $6e78
	ld l,(hl)		; $6e79
_label_08_287:
	call interactionRunScript		; $6e7a
	jp interactionAnimate		; $6e7d
	call interactionRunScript		; $6e80
	ld e,$47		; $6e83
	ld a,(de)		; $6e85
	or a			; $6e86
	jp nz,interactionAnimate		; $6e87
	ret			; $6e8a
	call interactionRunScript		; $6e8b
	jp c,interactionDelete		; $6e8e
	jp interactionAnimate		; $6e91
_label_08_288:
	call interactionRunScript		; $6e94
	jp npcFaceLinkAndAnimate		; $6e97
	ld a,$26		; $6e9a
	call checkGlobalFlag		; $6e9c
	jr nz,_label_08_288	; $6e9f
	jr _label_08_287		; $6ea1
	jp $de5f		; $6ea3
	ld e,a			; $6ea6
	ld ($ff00+c),a		; $6ea7
	ld e,a			; $6ea8
	and $5f			; $6ea9
	and $5f			; $6eab
	ld ($ee5f),a		; $6ead
	ld e,a			; $6eb0
	inc e			; $6eb1
	ld h,b			; $6eb2
	rra			; $6eb3
	ld h,b			; $6eb4
	ld d,(hl)		; $6eb5
	ld h,b			; $6eb6

interactionCode45:
	ld e,$44		; $6eb7
	ld a,(de)		; $6eb9
	rst_jumpTable			; $6eba
	pop bc			; $6ebb
	ld l,(hl)		; $6ebc
	ld ($336f),sp		; $6ebd
	ld l,a			; $6ec0
	call interactionInitGraphics		; $6ec1
	ld e,$42		; $6ec4
	ld a,(de)		; $6ec6
	or a			; $6ec7
	jr nz,_label_08_289	; $6ec8
	call getThisRoomFlags		; $6eca
	and $40			; $6ecd
	jp nz,interactionDelete		; $6ecf
	ld h,d			; $6ed2
	ld l,$44		; $6ed3
	ld (hl),$01		; $6ed5
	ld l,$79		; $6ed7
	ld (hl),$01		; $6ed9
	ld a,$0b		; $6edb
	call interactionSetHighTextIndex		; $6edd
	ld hl,$6075		; $6ee0
	call interactionSetScript		; $6ee3
	ld a,$03		; $6ee6
	call interactionSetAnimation		; $6ee8
	jp interactionAnimateAsNpc		; $6eeb
_label_08_289:
	ld h,d			; $6eee
	ld l,$44		; $6eef
	ld (hl),$02		; $6ef1
	ld l,$78		; $6ef3
	ld (hl),$ff		; $6ef5
	call $6f3c		; $6ef7
	ld a,$0b		; $6efa
	call interactionSetHighTextIndex		; $6efc
	ld hl,$60a4		; $6eff
	call interactionSetScript		; $6f02
	jp interactionAnimateAsNpc		; $6f05
	ld e,$79		; $6f08
	ld a,(de)		; $6f0a
	or a			; $6f0b
	jr z,_label_08_290	; $6f0c
	ld a,(wFrameCounter)		; $6f0e
	and $3f			; $6f11
	jr nz,_label_08_290	; $6f13
	ld a,$01		; $6f15
	ld b,$fa		; $6f17
	ld c,$0a		; $6f19
	call objectCreateFloatingSnore		; $6f1b
_label_08_290:
	call interactionRunScript		; $6f1e
	jp c,interactionDelete		; $6f21
	call interactionAnimate		; $6f24
	ld e,$7a		; $6f27
	ld a,(de)		; $6f29
	or a			; $6f2a
	jr nz,_label_08_291	; $6f2b
	call objectPreventLinkFromPassing		; $6f2d
_label_08_291:
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6f30
	call interactionRunScript		; $6f33
	call $6f3c		; $6f36
	jp interactionAnimateAsNpc		; $6f39
	ld c,$28		; $6f3c
	call objectCheckLinkWithinDistance		; $6f3e
	jr nc,_label_08_292	; $6f41
	ld e,$78		; $6f43
	ld a,(de)		; $6f45
	cp $06			; $6f46
	ret z			; $6f48
	ld a,$06		; $6f49
	jr _label_08_293		; $6f4b
_label_08_292:
	ld e,$78		; $6f4d
	ld a,(de)		; $6f4f
	cp $05			; $6f50
	ret z			; $6f52
	ld a,$05		; $6f53
_label_08_293:
	ld (de),a		; $6f55
	jp interactionSetAnimation		; $6f56

interactionCode48:
	ld e,$44		; $6f59
	ld a,(de)		; $6f5b
	rst_jumpTable			; $6f5c
	ld h,l			; $6f5d
	ld l,a			; $6f5e
	ld (hl),a		; $6f5f
	ld l,a			; $6f60
	sub (hl)		; $6f61
	ld l,a			; $6f62
	ret nz			; $6f63
	ld l,a			; $6f64
	ld h,d			; $6f65
	ld l,e			; $6f66
	inc (hl)		; $6f67
	ld l,$7a		; $6f68
	ld (hl),$01		; $6f6a
	ld l,$42		; $6f6c
	ld a,(hl)		; $6f6e
	or a			; $6f6f
	ret z			; $6f70
	ld l,$44		; $6f71
	inc (hl)		; $6f73
	jp interactionInitGraphics		; $6f74
	ld h,d			; $6f77
	ld l,$7a		; $6f78
	dec (hl)		; $6f7a
	ret nz			; $6f7b
	call getFreeInteractionSlot		; $6f7c
	ret nz			; $6f7f
	ld (hl),$48		; $6f80
	ld e,$43		; $6f82
	ld a,(de)		; $6f84
	ld l,e			; $6f85
	ld (hl),a		; $6f86
	dec l			; $6f87
	ld e,$46		; $6f88
	ld a,(de)		; $6f8a
	inc a			; $6f8b
	ld (de),a		; $6f8c
	ld (hl),a		; $6f8d
	cp $03			; $6f8e
	jp z,interactionDelete		; $6f90
	jp $7002		; $6f93
	ld a,$03		; $6f96
	ld (de),a		; $6f98
	ld h,d			; $6f99
	ld l,$42		; $6f9a
	ldi a,(hl)		; $6f9c
	add (hl)		; $6f9d
	ld hl,$701e		; $6f9e
	rst_addDoubleIndex			; $6fa1
	ld e,$4b		; $6fa2
	ldi a,(hl)		; $6fa4
	ld (de),a		; $6fa5
	ld e,$4d		; $6fa6
	ldi a,(hl)		; $6fa8
	ld (de),a		; $6fa9
	call $7012		; $6faa
	ld hl,$702c		; $6fad
	call $6fee		; $6fb0
	ld a,$83		; $6fb3
	call playSound		; $6fb5
	ld a,$70		; $6fb8
	ld e,$7c		; $6fba
	ld (de),a		; $6fbc
	jp objectSetVisible80		; $6fbd
	call objectApplySpeed		; $6fc0
	ld h,d			; $6fc3
	ld l,$7c		; $6fc4
	ld a,(hl)		; $6fc6
	or a			; $6fc7
	jr z,_label_08_294	; $6fc8
	dec (hl)		; $6fca
	ld a,$83		; $6fcb
	call z,playSound		; $6fcd
_label_08_294:
	ld l,$4d		; $6fd0
	ld a,(hl)		; $6fd2
	and $f0			; $6fd3
	cp $f0			; $6fd5
	jp z,interactionDelete		; $6fd7
	ld l,$7b		; $6fda
	dec (hl)		; $6fdc
	call z,$7018		; $6fdd
	call interactionDecCounter1		; $6fe0
	ret nz			; $6fe3
	ld l,$78		; $6fe4
	ldi a,(hl)		; $6fe6
	ld h,(hl)		; $6fe7
	ld l,a			; $6fe8
	ld a,(hl)		; $6fe9
	inc a			; $6fea
	jp z,interactionDelete		; $6feb
	ld e,$49		; $6fee
	ldi a,(hl)		; $6ff0
	ld (de),a		; $6ff1
	ld e,$46		; $6ff2
	ldi a,(hl)		; $6ff4
	ld (de),a		; $6ff5
	ld e,$50		; $6ff6
	ldi a,(hl)		; $6ff8
	ld (de),a		; $6ff9
	ld e,$78		; $6ffa
	ld a,l			; $6ffc
	ld (de),a		; $6ffd
	inc e			; $6ffe
	ld a,h			; $6fff
	ld (de),a		; $7000
	ret			; $7001
	ld e,$46		; $7002
	ld a,(de)		; $7004
	ld hl,$700e		; $7005
	rst_addAToHl			; $7008
	ld a,(hl)		; $7009
	ld e,$7a		; $700a
	ld (de),a		; $700c
	ret			; $700d
	ld bc,$323c		; $700e
	rst $38			; $7011
_label_08_295:
	ld e,$7b		; $7012
	ld a,$0b		; $7014
	ld (de),a		; $7016
	ret			; $7017
	ld bc,$8402		; $7018
	call objectCreateInteraction		; $701b
	jr _label_08_295		; $701e
	nop			; $7020
	xor b			; $7021
	ret c			; $7022
	ret nz			; $7023
	ld ($12c8),sp		; $7024
	call $e5ea		; $7027
	ld a,(de)		; $702a
.DB $ed				; $702b
	ld (de),a		; $702c
	ld a,(bc)		; $702d
	ld a,b			; $702e
	inc de			; $702f
	add hl,bc		; $7030
	ld a,b			; $7031
	inc d			; $7032
	ld ($156e),sp		; $7033
	ld ($166e),sp		; $7036
	ld ($1764),sp		; $7039
	ld b,$50		; $703c
	jr _label_08_296		; $703e
	ld b,(hl)		; $7040
	ld a,(de)		; $7041
	inc b			; $7042
	ld b,(hl)		; $7043
_label_08_296:
	inc e			; $7044
	dec b			; $7045
	inc a			; $7046
	ld e,$05		; $7047
	inc a			; $7049
	nop			; $704a
	ld b,$3c		; $704b
	ld (bc),a		; $704d
	ld b,$3c		; $704e
	inc b			; $7050
	dec b			; $7051
	ldd (hl),a		; $7052
	ld b,$04		; $7053
	ldd (hl),a		; $7055
	ld ($3202),sp		; $7056
	ld a,(bc)		; $7059
	ld bc,$0c32		; $705a
	ld (bc),a		; $705d
	ldd (hl),a		; $705e
	ld c,$04		; $705f
	inc a			; $7061
	stop			; $7062
	inc b			; $7063
	inc a			; $7064
	ld (de),a		; $7065
	ld b,$46		; $7066
	inc d			; $7068
	ld b,$50		; $7069
	dec d			; $706b
	ld a,(bc)		; $706c
	ld d,b			; $706d
	ld d,$0c		; $706e
	ld h,h			; $7070
	rla			; $7071
	ld d,$78		; $7072
	rst $38			; $7074

interactionCode49:
	call $707b		; $7075
	jp $7089		; $7078
	ld e,$44		; $707b
	ld a,(de)		; $707d
	rst_jumpTable			; $707e
	sub l			; $707f
	ld (hl),b		; $7080
	cp d			; $7081
	ld (hl),b		; $7082
	dec bc			; $7083
	ld (hl),c		; $7084
	dec h			; $7085
	ld (hl),c		; $7086
	dec a			; $7087
	ld (hl),c		; $7088
	ld e,$7d		; $7089
	ld a,(de)		; $708b
	or a			; $708c
	jr z,_label_08_297	; $708d
	call interactionAnimate		; $708f
_label_08_297:
	jp objectSetVisible80		; $7092
	call getThisRoomFlags		; $7095
	and $40			; $7098
	jp z,interactionDelete		; $709a
	ld a,$01		; $709d
	ld (de),a		; $709f
	call interactionInitGraphics		; $70a0
	ld h,d			; $70a3
	ld l,$66		; $70a4
	ld (hl),$06		; $70a6
	inc l			; $70a8
	ld (hl),$06		; $70a9
	ld l,$50		; $70ab
	ld (hl),$19		; $70ad
	call $7164		; $70af
	ld e,$71		; $70b2
	call objectAddToAButtonSensitiveObjectList		; $70b4
	jp $7184		; $70b7
	call $715d		; $70ba
	call $716a		; $70bd
	ld hl,$d00b		; $70c0
	ld c,$69		; $70c3
	ld b,(hl)		; $70c5
	ld a,$69		; $70c6
	ld l,a			; $70c8
	ld a,c			; $70c9
	cp b			; $70ca
	ret nc			; $70cb
	ld a,($cc75)		; $70cc
	or a			; $70cf
	ret z			; $70d0
	ld e,$7c		; $70d1
	ld a,$02		; $70d3
	ld (de),a		; $70d5
	ld a,$80		; $70d6
	ld ($cca4),a		; $70d8
	ld a,l			; $70db
	ld hl,$d00b		; $70dc
	ld (hl),a		; $70df
	jp $718f		; $70e0
	xor a			; $70e3
	ld (de),a		; $70e4
	ld e,$7d		; $70e5
	ld (de),a		; $70e7
	ld e,$7c		; $70e8
	ld a,$01		; $70ea
	ld (de),a		; $70ec
	ld a,($cc75)		; $70ed
	or a			; $70f0
	jr z,_label_08_298	; $70f1
	ld a,($d019)		; $70f3
	ld h,a			; $70f6
	ld e,$7a		; $70f7
	ld (de),a		; $70f9
	ld hl,$60a6		; $70fa
	jp $7103		; $70fd
_label_08_298:
	ld hl,$60a6		; $7100
	ld e,$44		; $7103
	ld a,$04		; $7105
	ld (de),a		; $7107
	jp interactionSetScript		; $7108
	call $715d		; $710b
	call objectApplySpeed		; $710e
	ld e,$4d		; $7111
	ld a,(de)		; $7113
	sub $0c			; $7114
	ld hl,$d00d		; $7116
	cp (hl)			; $7119
	ret nc			; $711a
	ld e,$7d		; $711b
	xor a			; $711d
	ld (de),a		; $711e
	ld hl,$60aa		; $711f
	jp $7103		; $7122
	call $715d		; $7125
	call objectApplySpeed		; $7128
	ld e,$4d		; $712b
	ld a,(de)		; $712d
	cp $78			; $712e
	ret c			; $7130
	xor a			; $7131
	ld ($cca4),a		; $7132
	ld e,$44		; $7135
	ld a,$01		; $7137
	ld (de),a		; $7139
	jp $7184		; $713a
	call interactionRunScript		; $713d
	ret nc			; $7140
	ld e,$7c		; $7141
	ld a,(de)		; $7143
	cp $02			; $7144
	jr z,_label_08_299	; $7146
	ld h,d			; $7148
	ld l,$44		; $7149
	ld (hl),$01		; $714b
	ld l,$7c		; $714d
	ld (hl),$00		; $714f
	ld l,$7d		; $7151
	ld (hl),$01		; $7153
	xor a			; $7155
	ld ($cca4),a		; $7156
	ret			; $7159
_label_08_299:
	jp $71ad		; $715a
	ld c,$20		; $715d
	call objectUpdateSpeedZ_paramC		; $715f
	ret nz			; $7162
	ld h,d			; $7163
	ld bc,$ff40		; $7164
	jp objectSetSpeedZ		; $7167
	call objectApplySpeed		; $716a
	ld e,$4d		; $716d
	ld a,(de)		; $716f
	sub $68			; $7170
	cp $20			; $7172
	ret c			; $7174
	ld e,$49		; $7175
	ld a,(de)		; $7177
	xor $10			; $7178
	ld (de),a		; $717a
	ld e,$7e		; $717b
	ld a,(de)		; $717d
	xor $01			; $717e
	ld (de),a		; $7180
	jp interactionSetAnimation		; $7181
	ld h,d			; $7184
	ld l,$7c		; $7185
	ld (hl),$00		; $7187
	ld l,$50		; $7189
	ld (hl),$14		; $718b
	jr _label_08_300		; $718d
	ld h,d			; $718f
	ld l,$44		; $7190
	ld (hl),$02		; $7192
	ld l,$50		; $7194
	ld (hl),$50		; $7196
_label_08_300:
	ld l,$7d		; $7198
	ld (hl),$01		; $719a
	ld l,$49		; $719c
	ld (hl),$18		; $719e
	xor a			; $71a0
	ld l,$4e		; $71a1
	ldi (hl),a		; $71a3
	ld (hl),a		; $71a4
	ld l,$7e		; $71a5
	ld a,$00		; $71a7
	ld (hl),a		; $71a9
	jp interactionSetAnimation		; $71aa
	ld h,d			; $71ad
	ld l,$44		; $71ae
	ld (hl),$03		; $71b0
	ld l,$50		; $71b2
	ld (hl),$50		; $71b4
	ld l,$7d		; $71b6
	ld (hl),$01		; $71b8
	ld l,$49		; $71ba
	ld (hl),$08		; $71bc
	xor a			; $71be
	ld l,$4e		; $71bf
	ldi (hl),a		; $71c1
	ld (hl),a		; $71c2
	ld l,$7e		; $71c3
	ld a,$01		; $71c5
	ld (hl),a		; $71c7
	jp interactionSetAnimation		; $71c8

interactionCode4b:
	ld e,$44		; $71cb
	ld a,(de)		; $71cd
	rst_jumpTable			; $71ce
.DB $dd				; $71cf
	ld (hl),c		; $71d0
	add sp,$71		; $71d1
	di			; $71d3
	ld (hl),c		; $71d4
.DB $fd				; $71d5
	ld (hl),c		; $71d6
	ld b,h			; $71d7
	ld (hl),d		; $71d8
	ld d,c			; $71d9
	ld (hl),d		; $71da
	ld d,a			; $71db
	ld (hl),d		; $71dc
	ld e,$42		; $71dd
	ld a,(de)		; $71df
	add a			; $71e0
	inc a			; $71e1
	ld e,$44		; $71e2
	ld (de),a		; $71e4
	jp interactionInitGraphics		; $71e5
	ld a,$02		; $71e8
	ld (de),a		; $71ea
	ld a,$6f		; $71eb
	call playSound		; $71ed
	jp objectSetVisible81		; $71f0
	ld e,$61		; $71f3
	ld a,(de)		; $71f5
	inc a			; $71f6
	jp z,interactionDelete		; $71f7
	jp interactionAnimate		; $71fa
	ld a,$04		; $71fd
	ld (de),a		; $71ff
	call getRandomNumber_noPreserveVars		; $7200
	ld b,a			; $7203
	and $60			; $7204
	swap a			; $7206
	ld hl,$7260		; $7208
	rst_addAToHl			; $720b
	ld e,$54		; $720c
	ldi a,(hl)		; $720e
	ld (de),a		; $720f
	inc e			; $7210
	ld a,(hl)		; $7211
	ld (de),a		; $7212
	ld a,b			; $7213
	and $03			; $7214
	ld hl,$7268		; $7216
	rst_addAToHl			; $7219
	ld e,$50		; $721a
	ld a,(hl)		; $721c
	ld (de),a		; $721d
	call getRandomNumber_noPreserveVars		; $721e
	ld b,a			; $7221
	and $30			; $7222
	swap a			; $7224
	ld hl,$726c		; $7226
	rst_addAToHl			; $7229
	ld e,$70		; $722a
	ld a,(hl)		; $722c
	ld (de),a		; $722d
	ld a,b			; $722e
	and $0f			; $722f
	ld hl,$7270		; $7231
	rst_addAToHl			; $7234
	ld e,$49		; $7235
	ld a,(hl)		; $7237
	ld (de),a		; $7238
	inc a			; $7239
	and $07			; $723a
	cp $03			; $723c
	jp c,objectSetVisible82		; $723e
	jp objectSetVisible80		; $7241
	call objectApplySpeed		; $7244
	ld e,$70		; $7247
	ld a,(de)		; $7249
	call objectUpdateSpeedZ		; $724a
	ret nz			; $724d
	jp interactionDelete		; $724e
	ld a,$06		; $7251
	ld (de),a		; $7253
	jp objectSetVisible81		; $7254
	call interactionDecCounter1		; $7257
	jp z,interactionDelete		; $725a
	jp interactionAnimate		; $725d
.db $c0 $fe $a0 $fe $a0 $fe $80 $fe
.db $05 $0a $0a $14 $0d $0e $0f $10
.db $00 $01 $02 $03 $04 $05 $06 $07
.db $01 $02 $03 $05 $06 $07 $02 $06

interactionCode4c:
	ld e,Interaction.subid	; $7280
	ld a,(de)		; $7282
	rst_jumpTable			; $7283
	cp b			; $7284
	ld (hl),d		; $7285
	xor h			; $7286
	ld (hl),d		; $7287
	xor h			; $7288
	ld (hl),d		; $7289
	xor h			; $728a
	ld (hl),d		; $728b
	add hl,sp		; $728c
	ld (hl),e		; $728d
	add hl,sp		; $728e
	ld (hl),e		; $728f
	or d			; $7290
	ld (hl),d		; $7291
.DB $ed				; $7292
	ld (hl),d		; $7293
	ld b,$73		; $7294
	inc h			; $7296
	ld (hl),e		; $7297
	or d			; $7298
	ld (hl),d		; $7299
	or d			; $729a
	ld (hl),d		; $729b
	or d			; $729c
	ld (hl),d		; $729d
	or d			; $729e
	ld (hl),d		; $729f
	call $72de		; $72a0
	jp objectSetVisible80		; $72a3
	call $72de		; $72a6
	jp objectSetVisible81		; $72a9
	call $72de		; $72ac
	jp objectSetVisible82		; $72af
	call $72de		; $72b2
	jp objectSetVisible83		; $72b5
	call checkInteractionState		; $72b8
	jr nz,_label_08_301	; $72bb
	ld h,d			; $72bd
	ld l,e			; $72be
	inc (hl)		; $72bf
	ld l,$40		; $72c0
	set 7,(hl)		; $72c2
	call interactionInitGraphics		; $72c4
	jp objectSetVisible80		; $72c7
_label_08_301:
	call getThisRoomFlags		; $72ca
	bit 6,(hl)		; $72cd
	jr z,_label_08_302	; $72cf
	ld e,$60		; $72d1
	ld a,(de)		; $72d3
	cp $10			; $72d4
	jr nz,_label_08_302	; $72d6
	ld a,$02		; $72d8
	ld (de),a		; $72da
_label_08_302:
	jp interactionAnimate		; $72db
	call checkInteractionState		; $72de
	jr nz,_label_08_303	; $72e1
	ld a,$01		; $72e3
	ld (de),a		; $72e5
	jp interactionInitGraphics		; $72e6
_label_08_303:
	pop hl			; $72e9
	jp interactionAnimate		; $72ea
	call checkInteractionState		; $72ed
	jr nz,_label_08_304	; $72f0
	ld a,$01		; $72f2
	ld (de),a		; $72f4
	call interactionSetAlwaysUpdateBit		; $72f5
	ld a,$9b		; $72f8
	call loadPaletteHeader		; $72fa
	call interactionInitGraphics		; $72fd
	call objectSetVisible82		; $7300
_label_08_304:
	jp interactionAnimate		; $7303
	call checkInteractionState		; $7306
	jr nz,_label_08_305	; $7309
	ld a,$01		; $730b
	ld (de),a		; $730d
	call interactionSetAlwaysUpdateBit		; $730e
	call interactionInitGraphics		; $7311
	call objectSetVisible80		; $7314
_label_08_305:
	call interactionAnimate		; $7317
	ld a,(wFrameCounter)		; $731a
	rrca			; $731d
	jp c,objectSetInvisible		; $731e
	jp objectSetVisible		; $7321
	call checkInteractionState		; $7324
	ret nz			; $7327
	call getThisRoomFlags		; $7328
	and $40			; $732b
	jp z,interactionDelete		; $732d
	call interactionInitGraphics		; $7330
	call interactionIncState		; $7333
	jp objectSetVisible83		; $7336
	call checkInteractionState		; $7339
	jr nz,_label_08_306	; $733c
	ld a,$01		; $733e
	ld (de),a		; $7340
	call interactionSetAlwaysUpdateBit		; $7341
	ld bc,$fe00		; $7344
	call objectSetSpeedZ		; $7347
	ld l,$49		; $734a
	ld (hl),$01		; $734c
	ld l,$50		; $734e
	ld (hl),$28		; $7350
	ld a,$51		; $7352
	call playSound		; $7354
	call interactionInitGraphics		; $7357
	jp objectSetVisiblec0		; $735a
_label_08_306:
	call objectApplySpeed		; $735d
	ld c,$20		; $7360
	call objectUpdateSpeedZ_paramC		; $7362
	ret nz			; $7365
	ld a,$77		; $7366
	call playSound		; $7368
	jp interactionDelete		; $736b

interactionCode4d:
	ld e,$42		; $736e
	ld a,(de)		; $7370
	rst_jumpTable			; $7371
	halt			; $7372
	ld (hl),e		; $7373
	add h			; $7374
	ld (hl),h		; $7375
	ld e,$44		; $7376
	ld a,(de)		; $7378
	rst_jumpTable			; $7379
	add b			; $737a
	ld (hl),e		; $737b
	cp (hl)			; $737c
	ld (hl),e		; $737d
.DB $fd				; $737e
	ld (hl),e		; $737f
	ld a,$01		; $7380
	ld (de),a		; $7382
	ld a,$1b		; $7383
	call checkGlobalFlag		; $7385
	jp z,interactionDelete		; $7388
	ld c,$4d		; $738b
	call objectFindSameTypeObjectWithID		; $738d
	jr nz,_label_08_307	; $7390
	ld a,h			; $7392
	cp d			; $7393
	jp nz,interactionDelete		; $7394
	call func_228f		; $7397
	jp z,interactionDelete		; $739a
_label_08_307:
	ld a,$4a		; $739d
	call checkTreasureObtained		; $739f
	jr c,_label_08_308	; $73a2
	call getRandomNumber		; $73a4
	and $03			; $73a7
	inc a			; $73a9
	ld e,$78		; $73aa
	ld (de),a		; $73ac
_label_08_308:
	ld a,$4d		; $73ad
	call interactionSetHighTextIndex		; $73af
	ld hl,$60ae		; $73b2
	call interactionSetScript		; $73b5
	call interactionInitGraphics		; $73b8
	jp objectSetVisiblec2		; $73bb
	ld e,$45		; $73be
	ld a,(de)		; $73c0
	rst_jumpTable			; $73c1
	add $73			; $73c2
	call z,$cd73		; $73c4
	dec e			; $73c7
	ld h,$c3		; $73c8
	inc c			; $73ca
	dec h			; $73cb
	ld e,$7a		; $73cc
	ld a,(de)		; $73ce
	or a			; $73cf
	jr z,_label_08_309	; $73d0
	ld b,a			; $73d2
	inc e			; $73d3
	ld a,(de)		; $73d4
	ld c,a			; $73d5
	push bc			; $73d6
	call objectCheckContainsPoint		; $73d7
	pop bc			; $73da
	jr c,_label_08_310	; $73db
	call objectGetRelativeAngle		; $73dd
	ld e,$49		; $73e0
	ld (de),a		; $73e2
	ld e,$50		; $73e3
	ld a,$14		; $73e5
	ld (de),a		; $73e7
	call objectApplySpeed		; $73e8
_label_08_309:
	ld h,d			; $73eb
	ld l,$7a		; $73ec
	xor a			; $73ee
	ldi (hl),a		; $73ef
	ld (hl),a		; $73f0
	jp objectAddToGrabbableObjectBuffer		; $73f1
_label_08_310:
	ld bc,$4d0a		; $73f4
	call showText		; $73f7
	jp interactionDelete		; $73fa
	ld e,$45		; $73fd
	ld a,(de)		; $73ff
	rst_jumpTable			; $7400
	add hl,bc		; $7401
	ld (hl),h		; $7402
	ld a,(de)		; $7403
	ld (hl),h		; $7404
	dec a			; $7405
	ld (hl),h		; $7406
	ld d,c			; $7407
	ld (hl),h		; $7408
	ld h,d			; $7409
	ld l,e			; $740a
	inc (hl)		; $740b
	xor a			; $740c
	ld (wLinkGrabState2),a		; $740d
	ld l,$79		; $7410
	ld (hl),a		; $7412
	inc a			; $7413
	call interactionSetAnimation		; $7414
	jp objectSetVisiblec1		; $7417
	ld hl,$ccc1		; $741a
	bit 7,(hl)		; $741d
	ld e,$78		; $741f
	ld a,(de)		; $7421
	ld (hl),a		; $7422
	jr nz,_label_08_311	; $7423
	ld e,$46		; $7425
	ld a,$14		; $7427
	ld (de),a		; $7429
	ld a,$01		; $742a
	jp interactionSetAnimation		; $742c
_label_08_311:
	call interactionAnimate		; $742f
	call interactionDecCounter1		; $7432
	ret nz			; $7435
	ld (hl),$14		; $7436
	ld a,$7e		; $7438
	jp playSound		; $743a
	call objectCheckWithinRoomBoundary		; $743d
	jp nc,interactionDelete		; $7440
	call objectReplaceWithAnimationIfOnHazard		; $7443
	jr c,_label_08_312	; $7446
	ld h,d			; $7448
	ld l,$40		; $7449
	res 1,(hl)		; $744b
	ld l,$79		; $744d
	ld (hl),d		; $744f
	ret			; $7450
	ld c,$20		; $7451
	call objectUpdateSpeedZ_paramC		; $7453
	ret nz			; $7456
	call objectReplaceWithAnimationIfOnHazard		; $7457
	jr c,_label_08_312	; $745a
	call objectCheckWithinScreenBoundary		; $745c
	jp nc,interactionDelete		; $745f
	ld h,d			; $7462
	ld l,$40		; $7463
	res 1,(hl)		; $7465
	ld l,$44		; $7467
	ld a,$01		; $7469
	ldi (hl),a		; $746b
	ld (hl),a		; $746c
	ld l,$79		; $746d
	ld a,(hl)		; $746f
	or a			; $7470
	ld bc,$4d06		; $7471
	call nz,showText		; $7474
	xor a			; $7477
	call interactionSetAnimation		; $7478
	jp objectSetVisible82		; $747b
_label_08_312:
	ld bc,$4d09		; $747e
	jp showText		; $7481
	ld e,$44		; $7484
	ld a,(de)		; $7486
	rst_jumpTable			; $7487
	sub h			; $7488
	ld (hl),h		; $7489
	or e			; $748a
	ld (hl),h		; $748b
	rst_jumpTable			; $748c
	ld (hl),h		; $748d
	ld ($ff00+c),a		; $748e
	ld (hl),h		; $748f
.DB $fc				; $7490
	ld (hl),h		; $7491
	dec c			; $7492
	ld (hl),l		; $7493
	ld a,$01		; $7494
	ld (de),a		; $7496
	call getThisRoomFlags		; $7497
	and $20			; $749a
	jp nz,interactionDelete		; $749c
	ld a,$01		; $749f
	ld ($cca4),a		; $74a1
	ld a,($d00b)		; $74a4
	ld e,$4b		; $74a7
	ld (de),a		; $74a9
	ld a,($d00d)		; $74aa
	ld e,$4d		; $74ad
	ld (de),a		; $74af
	jp interactionInitGraphics		; $74b0
	ld a,($d00f)		; $74b3
	or a			; $74b6
	ret nz			; $74b7
	ld a,$02		; $74b8
	ld (de),a		; $74ba
	call objectGetZAboveScreen		; $74bb
	ld e,$4f		; $74be
	ld (de),a		; $74c0
	call setLinkForceStateToState08		; $74c1
	jp objectSetVisiblec1		; $74c4
	ld c,$20		; $74c7
	call objectUpdateSpeedZAndBounce		; $74c9
	ret nz			; $74cc
	call interactionIncState		; $74cd
	ld l,$50		; $74d0
	ld (hl),$14		; $74d2
	ld l,$49		; $74d4
	ld (hl),$10		; $74d6
	ld a,$02		; $74d8
	ld ($cc6b),a		; $74da
	ld a,$ca		; $74dd
	jp playSound		; $74df
	call objectApplySpeed		; $74e2
	ld c,$20		; $74e5
	call objectUpdateSpeedZAndBounce		; $74e7
	push af			; $74ea
	ld a,$ca		; $74eb
	call z,playSound		; $74ed
	pop af			; $74f0
	ret nc			; $74f1
	call interactionIncState		; $74f2
	ld l,$46		; $74f5
	ld (hl),$28		; $74f7
	jp objectSetVisible82		; $74f9
	call interactionDecCounter1		; $74fc
	ret nz			; $74ff
	ld l,$44		; $7500
	inc (hl)		; $7502
	xor a			; $7503
	ld ($cca4),a		; $7504
	ld bc,$4d07		; $7507
	jp showText		; $750a
	ld a,($cfc0)		; $750d
	or a			; $7510
	ret z			; $7511
	call objectCreatePuff		; $7512
	jp interactionDelete		; $7515

interactionCode4e:
	ld e,$44		; $7518
	ld a,(de)		; $751a
	rst_jumpTable			; $751b
	jr nz,_label_08_316	; $751c
	ld a,l			; $751e
	ld (hl),l		; $751f
	ld a,$01		; $7520
	ld (de),a		; $7522
	ld e,$42		; $7523
	ld a,(de)		; $7525
	cp $0b			; $7526
	jr nz,_label_08_313	; $7528
	call getThisRoomFlags		; $752a
	and $40			; $752d
	jp nz,$754c		; $752f
	ld hl,$7e4e		; $7532
	call parseGivenObjectData		; $7535
	ld hl,$cc1d		; $7538
	ld (hl),$4e		; $753b
	inc hl			; $753d
	ld (hl),$06		; $753e
	xor a			; $7540
	ld hl,$cfd0		; $7541
	ldi (hl),a		; $7544
	ldi (hl),a		; $7545
	ld (hl),a		; $7546
	ld a,$03		; $7547
	call setMusicVolume		; $7549
	jp interactionDelete		; $754c
_label_08_313:
	call interactionInitGraphics		; $754f
	ld e,$42		; $7552
	ld a,(de)		; $7554
	cp $05			; $7555
	jr nz,_label_08_314	; $7557
	ld e,$66		; $7559
	ld a,$06		; $755b
	ld (de),a		; $755d
	inc e			; $755e
	ld (de),a		; $755f
	jr _label_08_315		; $7560
_label_08_314:
	ld hl,$770a		; $7562
	rst_addDoubleIndex			; $7565
	ldi a,(hl)		; $7566
	ld h,(hl)		; $7567
	ld l,a			; $7568
	call interactionSetScript		; $7569
	ld e,$42		; $756c
	ld a,(de)		; $756e
	cp $07			; $756f
	jp nz,$757a		; $7571
	call interactionSetAlwaysUpdateBit		; $7574
	jp objectSetVisible80		; $7577
_label_08_315:
	call objectSetVisible83		; $757a
	ld e,$42		; $757d
	ld a,(de)		; $757f
	rst_jumpTable			; $7580
	xor c			; $7581
	ld (hl),l		; $7582
	xor c			; $7583
	ld (hl),l		; $7584
	xor c			; $7585
	ld (hl),l		; $7586
	xor c			; $7587
	ld (hl),l		; $7588
	xor c			; $7589
	ld (hl),l		; $758a
	sub a			; $758b
	ld (hl),l		; $758c
	inc l			; $758d
	halt			; $758e
	or a			; $758f
	halt			; $7590
	xor c			; $7591
	ld (hl),l		; $7592
_label_08_316:
	xor c			; $7593
	ld (hl),l		; $7594
	rst $30			; $7595
	halt			; $7596
	ld a,($cfd0)		; $7597
	or a			; $759a
	jr nz,_label_08_317	; $759b
	call interactionAnimate		; $759d
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $75a0
_label_08_317:
	call objectCreatePuff		; $75a3
	jp interactionDelete		; $75a6
	ld e,$45		; $75a9
	ld a,(de)		; $75ab
	rst_jumpTable			; $75ac
	or l			; $75ad
	ld (hl),l		; $75ae
	push bc			; $75af
	ld (hl),l		; $75b0
	ld ($0575),a		; $75b1
	halt			; $75b4
	ld a,($cfd0)		; $75b5
	or a			; $75b8
	call nz,interactionIncState2		; $75b9
	call interactionAnimate		; $75bc
	call interactionRunScript		; $75bf
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $75c2
	ld e,$42		; $75c5
	ld a,(de)		; $75c7
	ld hl,bitTable		; $75c8
	add l			; $75cb
	ld l,a			; $75cc
	ld b,(hl)		; $75cd
	ld a,($cfd1)		; $75ce
	and b			; $75d1
	jr z,_label_08_318	; $75d2
	call interactionIncState2		; $75d4
	ld l,$46		; $75d7
	ld (hl),$20		; $75d9
	ld l,$4d		; $75db
	ldd a,(hl)		; $75dd
	ld (hl),a		; $75de
_label_08_318:
	ld e,$42		; $75df
	ld a,(de)		; $75e1
	cp $05			; $75e2
	call z,interactionAnimate		; $75e4
	jp $75bf		; $75e7
	call interactionDecCounter1		; $75ea
	jr nz,_label_08_319	; $75ed
	call $7612		; $75ef
	jp interactionIncState2		; $75f2
_label_08_319:
	call getRandomNumber_noPreserveVars		; $75f5
	and $0f			; $75f8
	sub $08			; $75fa
	ld h,d			; $75fc
	ld l,$4c		; $75fd
	add (hl)		; $75ff
	inc l			; $7600
	ld (hl),a		; $7601
	jp $75bf		; $7602
	call objectApplySpeed		; $7605
	call objectApplySpeed		; $7608
	call objectCheckWithinScreenBoundary		; $760b
	ret c			; $760e
	jp interactionDelete		; $760f
	ld e,$42		; $7612
	ld a,(de)		; $7614
	ld hl,$7622		; $7615
	rst_addDoubleIndex			; $7618
	ldi a,(hl)		; $7619
	ld e,$49		; $761a
	ld (de),a		; $761c
	ldi a,(hl)		; $761d
	ld e,$50		; $761e
	ld (de),a		; $7620
	ret			; $7621
	inc b			; $7622
	ld a,b			; $7623
	dec e			; $7624
	ld a,b			; $7625
	ld e,$78		; $7626
	dec b			; $7628
	ld a,b			; $7629
	dec d			; $762a
	ld a,b			; $762b
	ld e,$45		; $762c
	ld a,(de)		; $762e
	rst_jumpTable			; $762f
	ld a,$76		; $7630
	ld c,a			; $7632
	halt			; $7633
	ld e,(hl)		; $7634
	halt			; $7635
	ld a,h			; $7636
	halt			; $7637
	add a			; $7638
	halt			; $7639
	sub l			; $763a
	halt			; $763b
	and a			; $763c
	halt			; $763d
	ld a,($cfd3)		; $763e
	cp $3f			; $7641
	jp nz,$75b5		; $7643
	call interactionIncState2		; $7646
	ld hl,$612d		; $7649
	call interactionSetScript		; $764c
	call $75b5		; $764f
	ld a,($cfd3)		; $7652
	and $40			; $7655
	ret z			; $7657
	call fastFadeoutToWhite		; $7658
	jp interactionIncState2		; $765b
	ld a,($c4ab)		; $765e
	or a			; $7661
	ret nz			; $7662
	ld a,$80		; $7663
	ld ($cfd3),a		; $7665
	ld a,$06		; $7668
	ld ($cc04),a		; $766a
	ld a,$08		; $766d
	call setLinkIDOverride		; $766f
	ld l,$02		; $7672
	ld (hl),$01		; $7674
	ld l,$19		; $7676
	ld (hl),d		; $7678
	jp interactionIncState2		; $7679
	ld a,($cfd0)		; $767c
	or a			; $767f
	ret nz			; $7680
	call $75bf		; $7681
	jp interactionIncState2		; $7684
	ld a,($cfd0)		; $7687
	cp $04			; $768a
	ret nz			; $768c
	call interactionIncState2		; $768d
	ld a,$0d		; $7690
	jp interactionSetAnimation		; $7692
	ld a,($cfd0)		; $7695
	cp $07			; $7698
	ret nz			; $769a
	call interactionIncState2		; $769b
	ld l,$50		; $769e
	ld (hl),$0a		; $76a0
	ld l,$49		; $76a2
	ld (hl),$08		; $76a4
	ret			; $76a6
	call objectApplySpeed		; $76a7
	ld a,($cfd1)		; $76aa
	rlca			; $76ad
	ret nc			; $76ae
	ld hl,$cfd0		; $76af
	ld (hl),$08		; $76b2
	jp interactionDelete		; $76b4
	ld e,$45		; $76b7
	ld a,(de)		; $76b9
	rst_jumpTable			; $76ba
	pop bc			; $76bb
	halt			; $76bc
	ret nc			; $76bd
	halt			; $76be
.DB $e3				; $76bf
	halt			; $76c0
	call interactionRunScript		; $76c1
	jr nc,_label_08_320	; $76c4
	call interactionIncState2		; $76c6
	ld hl,$cfd0		; $76c9
	ld (hl),$04		; $76cc
	jr _label_08_320		; $76ce
	call $76e9		; $76d0
	ld hl,$cfd0		; $76d3
	ld a,(hl)		; $76d6
	cp $06			; $76d7
	ret nz			; $76d9
	call interactionIncState2		; $76da
	ld hl,$6146		; $76dd
	jp interactionSetScript		; $76e0
	call interactionRunScript		; $76e3
	jp c,interactionDelete		; $76e6
_label_08_320:
	call interactionAnimate		; $76e9
	ld a,(wFrameCounter)		; $76ec
	and $3f			; $76ef
	ret nz			; $76f1
	ld a,$d3		; $76f2
	jp playSound		; $76f4
	call checkInteractionState2		; $76f7
	jr nz,_label_08_321	; $76fa
	call interactionIncState2		; $76fc
	ld a,$28		; $76ff
	call checkGlobalFlag		; $7701
	jp z,interactionDelete		; $7704
_label_08_321:
	jp $75bc		; $7707
	rst_jumpTable			; $770a
	ld h,b			; $770b
	call nc,$e860		; $770c
	ld h,b			; $770f
	push af			; $7710
	ld h,b			; $7711
	ld (bc),a		; $7712
	ld h,c			; $7713
	dec de			; $7714
	ld h,c			; $7715
	dec de			; $7716
	ld h,c			; $7717
	ld b,d			; $7718
	ld h,c			; $7719
	dec de			; $771a
	ld h,c			; $771b
	dec de			; $771c
	ld h,c			; $771d
	ld c,d			; $771e
	ld h,c			; $771f

interactionCode4f:
	ld e,$44		; $7720
	ld a,(de)		; $7722
	rst_jumpTable			; $7723
	jr z,_label_08_324	; $7724
	call nz,$cd77		; $7726
	sbc e			; $7729
	inc hl			; $772a
	call interactionInitGraphics		; $772b
	ld e,$42		; $772e
	ld a,(de)		; $7730
	rst_jumpTable			; $7731
	ld a,$77		; $7732
	ld b,a			; $7734
	ld (hl),a		; $7735
	ld e,$1e		; $7736
	ld d,b			; $7738
	ld (hl),a		; $7739
	ld l,d			; $773a
	ld (hl),a		; $773b
	ld a,e			; $773c
	ld (hl),a		; $773d
	ld hl,$6160		; $773e
	call interactionSetScript		; $7741
	jp objectSetVisiblec2		; $7744
	ld hl,$6164		; $7747
	call interactionSetScript		; $774a
	jp objectSetVisible82		; $774d
	call $77ba		; $7750
	ld e,$43		; $7753
	ld a,(de)		; $7755
	add a			; $7756
	add a			; $7757
	add $10			; $7758
	and $1f			; $775a
	ld e,$49		; $775c
	ld (de),a		; $775e
	ld e,$50		; $775f
	ld a,$78		; $7761
	ld (de),a		; $7763
	call objectSetVisible80		; $7764
	jp objectSetInvisible		; $7767
	ld e,$43		; $776a
	ld a,(de)		; $776c
	or a			; $776d
	jr z,_label_08_322	; $776e
	ld a,$05		; $7770
	call interactionSetAnimation		; $7772
	jp objectSetVisible82		; $7775
_label_08_322:
	jp objectSetVisible83		; $7778
	ld hl,$6172		; $777b
	call interactionSetScript		; $777e
	jp objectSetVisible82		; $7781
	ld e,$43		; $7784
	ld a,(de)		; $7786
	add $06			; $7787
	ld b,a			; $7789
	ld e,$72		; $778a
	ld a,(de)		; $778c
	or a			; $778d
	ld a,b			; $778e
	jr z,_label_08_323	; $778f
	add $0b			; $7791
_label_08_323:
	jp interactionSetAnimation		; $7793
	ld h,d			; $7796
	ld l,$70		; $7797
	ld e,$72		; $7799
	ld a,(de)		; $779b
	or a			; $779c
_label_08_324:
	jr nz,_label_08_325	; $779d
	ld e,$43		; $779f
	ld a,(de)		; $77a1
	add a			; $77a2
	add a			; $77a3
	ld e,$48		; $77a4
	ld (de),a		; $77a6
	ld b,(hl)		; $77a7
	inc l			; $77a8
	ld c,(hl)		; $77a9
	ld a,$38		; $77aa
	ld e,$48		; $77ac
	jp objectSetPositionInCircleArc		; $77ae
_label_08_325:
	ld e,$4b		; $77b1
	ldi a,(hl)		; $77b3
	ld (de),a		; $77b4
	inc e			; $77b5
	inc e			; $77b6
	ld a,(hl)		; $77b7
	ld (de),a		; $77b8
	ret			; $77b9
	call getRandomNumber		; $77ba
	and $07			; $77bd
	inc a			; $77bf
	ld e,$47		; $77c0
	ld (de),a		; $77c2
	ret			; $77c3
	ld e,$42		; $77c4
	ld a,(de)		; $77c6
	rst_jumpTable			; $77c7
	call nc,$e977		; $77c8
	ld a,c			; $77cb
	cp $77			; $77cc
	sbc d			; $77ce
	ld a,c			; $77cf
	pop de			; $77d0
	ld a,c			; $77d1
	inc (hl)		; $77d2
	ld a,d			; $77d3
	ld a,($cfd0)		; $77d4
	cp $0e			; $77d7
	jp z,interactionDelete		; $77d9
	cp $0d			; $77dc
	jr nz,_label_08_327	; $77de
	call checkInteractionState2		; $77e0
	jr nz,_label_08_326	; $77e3
	call interactionIncState2		; $77e5
	ld l,$4b		; $77e8
	ld (hl),$4a		; $77ea
	inc l			; $77ec
	inc l			; $77ed
	ld (hl),$81		; $77ee
	ld a,$0e		; $77f0
	call interactionSetAnimation		; $77f2
_label_08_326:
	call objectOscillateZ		; $77f5
_label_08_327:
	call interactionAnimate		; $77f8
	jp interactionRunScript		; $77fb
	ld e,$45		; $77fe
	ld a,(de)		; $7800
	rst_jumpTable			; $7801
	inc d			; $7802
	ld a,b			; $7803
	dec sp			; $7804
	ld a,b			; $7805
	ld e,(hl)		; $7806
	ld a,b			; $7807
	ld l,d			; $7808
	ld a,b			; $7809
	add a			; $780a
	ld a,b			; $780b
	and b			; $780c
	ld a,b			; $780d
	push bc			; $780e
	ld a,b			; $780f
	ld bc,$1579		; $7810
	ld a,c			; $7813
	call interactionIncState2		; $7814
	ld a,$7c		; $7817
	call $7957		; $7819
	ld e,$43		; $781c
	ld a,(de)		; $781e
	add a			; $781f
	ld hl,$784e		; $7820
	rst_addDoubleIndex			; $7823
	ld e,$49		; $7824
	ldi a,(hl)		; $7826
	ld (de),a		; $7827
	ld e,$70		; $7828
	ldi a,(hl)		; $782a
	ld (de),a		; $782b
	inc de			; $782c
	ldi a,(hl)		; $782d
	ld (de),a		; $782e
	inc de			; $782f
	ld a,(hl)		; $7830
	ld (de),a		; $7831
	xor a			; $7832
	call $791f		; $7833
	ld e,$46		; $7836
	ld a,$3c		; $7838
	ld (de),a		; $783a
	call interactionDecCounter1		; $783b
	ld e,$5a		; $783e
	jr nz,_label_08_328	; $7840
	ld a,(de)		; $7842
	or $80			; $7843
	ld (de),a		; $7845
	jp interactionIncState2		; $7846
_label_08_328:
	ld a,(de)		; $7849
	xor $80			; $784a
	ld (de),a		; $784c
	ret			; $784d
	inc e			; $784e
	jr nc,$3c		; $784f
	ld e,d			; $7851
	inc b			; $7852
	jr nc,$46		; $7853
	ld d,b			; $7855
	inc e			; $7856
	ld h,b			; $7857
	ld d,b			; $7858
	ld b,(hl)		; $7859
	inc b			; $785a
	ld h,b			; $785b
	ld e,d			; $785c
	inc a			; $785d
	ld h,d			; $785e
	ld l,$71		; $785f
	dec (hl)		; $7861
	ret nz			; $7862
	ld l,$50		; $7863
	ld (hl),$78		; $7865
	jp interactionIncState2		; $7867
	call objectApplySpeed		; $786a
	ld e,$70		; $786d
	ld a,(de)		; $786f
	ld b,a			; $7870
	ld e,$4b		; $7871
	ld a,(de)		; $7873
	ld c,a			; $7874
	cp b			; $7875
	ld e,$43		; $7876
	ld a,(de)		; $7878
	jr nc,_label_08_329	; $7879
	xor a			; $787b
	call $7941		; $787c
	jp interactionIncState2		; $787f
_label_08_329:
	or a			; $7882
	ret nz			; $7883
	jp $7a1e		; $7884
	ld h,d			; $7887
	ld l,$72		; $7888
	dec (hl)		; $788a
	ret nz			; $788b
	call interactionIncState2		; $788c
	ld l,$46		; $788f
	ld (hl),$a0		; $7891
	ld l,$43		; $7893
	ld a,(hl)		; $7895
	or a			; $7896
	ld bc,$4882		; $7897
	ld a,$fe		; $789a
	call z,$7968		; $789c
	ret			; $789f
	call interactionDecCounter1		; $78a0
	jr nz,_label_08_330	; $78a3
	call objectSetVisible		; $78a5
	ld l,$46		; $78a8
	ld (hl),$28		; $78aa
	ld a,$04		; $78ac
	call $791f		; $78ae
	jp interactionIncState2		; $78b1
_label_08_330:
	ld l,$49		; $78b4
	inc (hl)		; $78b6
	ld a,(hl)		; $78b7
	and $1f			; $78b8
	ld (hl),a		; $78ba
	ld a,$20		; $78bb
	ld e,$49		; $78bd
	ld bc,$4882		; $78bf
	jp objectSetPositionInCircleArc		; $78c2
	call interactionDecCounter1		; $78c5
	ret nz			; $78c8
	ld l,$50		; $78c9
	ld (hl),$14		; $78cb
	ld l,$46		; $78cd
	ld (hl),$3c		; $78cf
	ld a,$04		; $78d1
	call $7941		; $78d3
	ld b,$02		; $78d6
_label_08_331:
	call getFreeInteractionSlot		; $78d8
	jr nz,_label_08_333	; $78db
	ld (hl),$4f		; $78dd
	inc l			; $78df
	ld (hl),$04		; $78e0
	inc l			; $78e2
	ld a,b			; $78e3
	dec a			; $78e4
	ld (hl),a		; $78e5
	ld l,$46		; $78e6
	ld (hl),$0a		; $78e8
	jr z,_label_08_332	; $78ea
	ld (hl),$14		; $78ec
_label_08_332:
	call objectCopyPosition		; $78ee
	ld e,$49		; $78f1
	ld l,e			; $78f3
	ld a,(de)		; $78f4
	ld (hl),a		; $78f5
	ld e,$50		; $78f6
	ld l,e			; $78f8
	ld a,(de)		; $78f9
	ld (hl),a		; $78fa
	dec b			; $78fb
	jr nz,_label_08_331	; $78fc
_label_08_333:
	jp interactionIncState2		; $78fe
	call objectApplySpeed		; $7901
	call interactionDecCounter1		; $7904
	ret nz			; $7907
	ld hl,$cfd0		; $7908
	ld (hl),$0c		; $790b
	ld a,$79		; $790d
	call $7957		; $790f
	jp interactionIncState2		; $7912
	ld hl,$cfd0		; $7915
	ld a,(hl)		; $7918
	cp $0d			; $7919
	ret nz			; $791b
	jp interactionDelete		; $791c
	ld b,a			; $791f
	ld e,$43		; $7920
	ld a,(de)		; $7922
	add b			; $7923
	ld hl,$7931		; $7924
	rst_addDoubleIndex			; $7927
	ld e,$4b		; $7928
	ldi a,(hl)		; $792a
	ld (de),a		; $792b
	inc de			; $792c
	inc de			; $792d
	ldi a,(hl)		; $792e
	ld (de),a		; $792f
	ret			; $7930
	ld h,b			; $7931
	sbc b			; $7932
	ld h,b			; $7933
	ld l,b			; $7934
	sub b			; $7935
	sbc b			; $7936
	sub b			; $7937
	ld l,b			; $7938
	jr nc,$68		; $7939
	jr nc,-$68		; $793b
	ld h,b			; $793d
	ld l,b			; $793e
	ld h,b			; $793f
	sbc b			; $7940
	ld b,a			; $7941
	ld e,$43		; $7942
	ld a,(de)		; $7944
	add b			; $7945
	ld hl,$794f		; $7946
	rst_addAToHl			; $7949
	ld e,$49		; $794a
	ld a,(hl)		; $794c
	ld (de),a		; $794d
	ret			; $794e
	inc e			; $794f
	inc b			; $7950
	inc d			; $7951
	inc c			; $7952
	inc c			; $7953
	inc d			; $7954
	inc b			; $7955
	inc e			; $7956
	ld b,a			; $7957
	ld e,$43		; $7958
	ld a,(de)		; $795a
	or a			; $795b
	ret nz			; $795c
	ld a,b			; $795d
	jp playSound		; $795e
	ld hl,$ff8c		; $7961
	ld (hl),$01		; $7964
	jr _label_08_334		; $7966
	ld hl,$ff8c		; $7968
	ld (hl),$00		; $796b
_label_08_334:
	ldh (<hFF8B),a	; $796d
	ld a,$08		; $796f
	ldh (<hFF8D),a	; $7971
_label_08_335:
	call getFreeInteractionSlot		; $7973
	ret nz			; $7976
	ld (hl),$4f		; $7977
	inc l			; $7979
	ld (hl),$03		; $797a
	ld l,$46		; $797c
	ldh a,(<hFF8B)	; $797e
	ld (hl),a		; $7980
	ld l,$70		; $7981
	ld (hl),b		; $7983
	inc l			; $7984
	ld (hl),c		; $7985
	ld l,$72		; $7986
	ldh a,(<hFF8C)	; $7988
	ld (hl),a		; $798a
	ldh a,(<hFF8D)	; $798b
	dec a			; $798d
	ldh (<hFF8D),a	; $798e
	ld l,$43		; $7990
	ld (hl),a		; $7992
	jr nz,_label_08_335	; $7993
	ld a,$5c		; $7995
	jp playSound		; $7997
	ld h,d			; $799a
	ld l,$46		; $799b
	ld a,(hl)		; $799d
	inc a			; $799e
	jr z,_label_08_336	; $799f
	dec (hl)		; $79a1
	jp z,interactionDelete		; $79a2
_label_08_336:
	ld e,$45		; $79a5
	ld a,(de)		; $79a7
	or a			; $79a8
	jr nz,_label_08_337	; $79a9
	call interactionDecCounter2		; $79ab
	ret nz			; $79ae
	call $7784		; $79af
	call $7796		; $79b2
	call objectSetVisible		; $79b5
	jp interactionIncState2		; $79b8
_label_08_337:
	call objectApplySpeed		; $79bb
	call interactionAnimate		; $79be
	ld e,$61		; $79c1
	ld a,(de)		; $79c3
	inc a			; $79c4
	ret nz			; $79c5
	ld h,d			; $79c6
	ld l,$45		; $79c7
	ld (hl),$00		; $79c9
	call $77ba		; $79cb
	jp objectSetInvisible		; $79ce
	call checkInteractionState2		; $79d1
	jr nz,_label_08_338	; $79d4
	call interactionDecCounter1		; $79d6
	ret nz			; $79d9
	jp interactionIncState2		; $79da
_label_08_338:
	ld hl,$cfd0		; $79dd
	ld a,(hl)		; $79e0
	cp $0c			; $79e1
	jp z,interactionDelete		; $79e3
	jp objectApplySpeed		; $79e6
	ld e,$45		; $79e9
	ld a,(de)		; $79eb
	rst_jumpTable			; $79ec
	di			; $79ed
	ld a,c			; $79ee
	inc c			; $79ef
	ld a,d			; $79f0
	inc c			; $79f1
	dec h			; $79f2
	call interactionRunScript		; $79f3
	jr c,_label_08_339	; $79f6
	call interactionAnimate		; $79f8
	jr _label_08_340		; $79fb
_label_08_339:
	jp interactionIncState2		; $79fd
_label_08_340:
	ld h,d			; $7a00
	ld l,$61		; $7a01
	ld a,(hl)		; $7a03
	cp $70			; $7a04
	ld (hl),$00		; $7a06
	ret nz			; $7a08
	jp playSound		; $7a09
	ld a,($cfd0)		; $7a0c
	cp $0e			; $7a0f
	ret nz			; $7a11
	call objectSetInvisible		; $7a12
	ld hl,$6168		; $7a15
	call interactionSetScript		; $7a18
	jp interactionIncState2		; $7a1b
	ld a,($c486)		; $7a1e
	ld b,a			; $7a21
	ld a,c			; $7a22
	sub b			; $7a23
	sub $40			; $7a24
	ld b,a			; $7a26
	ld a,($c486)		; $7a27
	add b			; $7a2a
	cp $10			; $7a2b
	ret nc			; $7a2d
	ld ($c486),a		; $7a2e
	ldh (<hCameraY),a	; $7a31
	ret			; $7a33
	call interactionAnimate		; $7a34
	call $7a00		; $7a37
	jp interactionRunScript		; $7a3a

interactionCode51:
	call checkInteractionState		; $7a3d
	jr z,_label_08_343	; $7a40
	ld a,(wFrameCounter)		; $7a42
	and $0f			; $7a45
	ld a,$b3		; $7a47
	call z,playSound		; $7a49
	ld a,($cd18)		; $7a4c
	or a			; $7a4f
	jr nz,_label_08_341	; $7a50
	ld a,($cd19)		; $7a52
	or a			; $7a55
	call z,$7a9a		; $7a56
_label_08_341:
	call interactionDecCounter1		; $7a59
	ret nz			; $7a5c
	call $7abe		; $7a5d
	ld e,$42		; $7a60
	ld a,(de)		; $7a62
	or a			; $7a63
	ld c,$07		; $7a64
	jr z,_label_08_342	; $7a66
	ld c,$0f		; $7a68
_label_08_342:
	call getRandomNumber		; $7a6a
	and c			; $7a6d
	srl c			; $7a6e
	inc c			; $7a70
	sub c			; $7a71
	ld c,a			; $7a72
	call getFreePartSlot		; $7a73
	ret nz			; $7a76
	ld (hl),$11		; $7a77
	ld e,$42		; $7a79
	inc l			; $7a7b
	ld a,(de)		; $7a7c
	ld (hl),a		; $7a7d
	ld b,$00		; $7a7e
	jp objectCopyPositionWithOffset		; $7a80
_label_08_343:
	inc a			; $7a83
	ld (de),a		; $7a84
	ld ($ccae),a		; $7a85
	ld e,$42		; $7a88
	ld a,(de)		; $7a8a
	ld hl,$7acb		; $7a8b
	rst_addDoubleIndex			; $7a8e
	ldi a,(hl)		; $7a8f
	ld h,(hl)		; $7a90
	ld l,a			; $7a91
	ld e,$58		; $7a92
	ld a,l			; $7a94
	ld (de),a		; $7a95
	inc e			; $7a96
	ld a,h			; $7a97
	ld (de),a		; $7a98
	ret			; $7a99
	ld h,d			; $7a9a
	ld l,$58		; $7a9b
	ldi a,(hl)		; $7a9d
	ld h,(hl)		; $7a9e
	ld l,a			; $7a9f
	ldi a,(hl)		; $7aa0
	cp $ff			; $7aa1
	jr nz,_label_08_344	; $7aa3
	pop hl			; $7aa5
	jp interactionDelete		; $7aa6
_label_08_344:
	ld ($cd18),a		; $7aa9
	ldi a,(hl)		; $7aac
	ld ($cd19),a		; $7aad
	ld e,$70		; $7ab0
	ldi a,(hl)		; $7ab2
	ld (de),a		; $7ab3
	inc e			; $7ab4
	ldi a,(hl)		; $7ab5
	ld (de),a		; $7ab6
	ld e,$58		; $7ab7
	ld a,l			; $7ab9
	ld (de),a		; $7aba
	inc e			; $7abb
	ld a,h			; $7abc
	ld (de),a		; $7abd
	call getRandomNumber_noPreserveVars		; $7abe
	ld h,d			; $7ac1
	ld l,$70		; $7ac2
	and (hl)		; $7ac4
	inc l			; $7ac5
	add (hl)		; $7ac6
	ld l,$46		; $7ac7
	ld (hl),a		; $7ac9
	ret			; $7aca
	rst $8			; $7acb
	ld a,d			; $7acc
	add sp,$7a		; $7acd
	nop			; $7acf
	rrca			; $7ad0
	nop			; $7ad1
	rst $38			; $7ad2
	rrca			; $7ad3
	nop			; $7ad4
	nop			; $7ad5
	rst $38			; $7ad6
	sub (hl)		; $7ad7
	nop			; $7ad8
	rrca			; $7ad9
	ld ($5a5a),sp		; $7ada
	rlca			; $7add
	inc bc			; $7ade
	nop			; $7adf
	inc a			; $7ae0
	rra			; $7ae1
	stop			; $7ae2
	nop			; $7ae3
	ld a,b			; $7ae4
	nop			; $7ae5
	rst $38			; $7ae6
	rst $38			; $7ae7
	nop			; $7ae8
	ld e,$00		; $7ae9
	rst $38			; $7aeb
	ld e,$00		; $7aec
	nop			; $7aee
	rst $38			; $7aef
	or h			; $7af0
	or h			; $7af1
	rrca			; $7af2
	ld ($3c3c),sp		; $7af3
	rra			; $7af6
	stop			; $7af7
	ld e,$00		; $7af8
	nop			; $7afa
	rst $38			; $7afb
	nop			; $7afc
	ld a,b			; $7afd
	nop			; $7afe
	rst $38			; $7aff
	rrca			; $7b00
	rrca			; $7b01
	nop			; $7b02
	rst $38			; $7b03
	rst $38			; $7b04

interactionCode52:
	ld e,$44		; $7b05
	ld a,(de)		; $7b07
	rst_jumpTable			; $7b08
	dec c			; $7b09
	ld a,e			; $7b0a
	inc h			; $7b0b
	ld a,e			; $7b0c
	ld a,$01		; $7b0d
	ld (de),a		; $7b0f
	call interactionInitGraphics		; $7b10
	call interactionSetAlwaysUpdateBit		; $7b13
	call objectSetVisible82		; $7b16
	ld a,$0b		; $7b19
	call interactionSetHighTextIndex		; $7b1b
	ld hl,$6176		; $7b1e
	jp interactionSetScript		; $7b21
	call interactionAnimate		; $7b24
	jp interactionRunScript		; $7b27

interactionCode53:
	ld e,$42		; $7b2a
	ld a,(de)		; $7b2c
	rst_jumpTable			; $7b2d
	ldd (hl),a		; $7b2e
	ld a,e			; $7b2f
	ld l,b			; $7b30
	ld a,e			; $7b31
	ld e,$44		; $7b32
	ld a,(de)		; $7b34
	rst_jumpTable			; $7b35
	inc a			; $7b36
	ld a,e			; $7b37
	ld d,l			; $7b38
	ld a,e			; $7b39
	ld e,(hl)		; $7b3a
	ld a,e			; $7b3b
	call getThisRoomFlags		; $7b3c
	bit 7,(hl)		; $7b3f
	jp nz,interactionDelete		; $7b41
	ld e,$44		; $7b44
	ld a,$01		; $7b46
	ld (de),a		; $7b48
	call interactionInitGraphics		; $7b49
	ld hl,$6264		; $7b4c
	call interactionSetScript		; $7b4f
	jp objectSetVisible82		; $7b52
	call interactionRunScript		; $7b55
	call objectPreventLinkFromPassing		; $7b58
	jp npcFaceLinkAndAnimate		; $7b5b
	call interactionAnimate		; $7b5e
	call interactionRunScript		; $7b61
	jp c,interactionDelete		; $7b64
	ret			; $7b67
	ld e,$44		; $7b68
	ld a,(de)		; $7b6a
	rst_jumpTable			; $7b6b
	ld (hl),h		; $7b6c
	ld a,e			; $7b6d
	ld d,l			; $7b6e
	ld a,e			; $7b6f
	ld e,(hl)		; $7b70
	ld a,e			; $7b71
	adc l			; $7b72
	ld a,e			; $7b73
	ld a,$0d		; $7b74
	call checkGlobalFlag		; $7b76
	jp z,interactionDelete		; $7b79
	ld e,$44		; $7b7c
	ld a,$01		; $7b7e
	ld (de),a		; $7b80
	call interactionInitGraphics		; $7b81
	ld hl,$628b		; $7b84
	call interactionSetScript		; $7b87
	jp objectSetVisible82		; $7b8a
	xor a			; $7b8d
	ld ($cfc0),a		; $7b8e
	call interactionRunScript		; $7b91
	ld e,$45		; $7b94
	ld a,(de)		; $7b96
	rst_jumpTable			; $7b97
	and b			; $7b98
	ld a,e			; $7b99
	and b			; $7b9a
	ld a,e			; $7b9b
	jp $c37b		; $7b9c
	ld a,e			; $7b9f
	call interactionAnimate		; $7ba0
	ld a,($cfc0)		; $7ba3
	call getHighestSetBit		; $7ba6
	ret nc			; $7ba9
	cp $03			; $7baa
	jr nz,_label_08_345	; $7bac
	ld e,$44		; $7bae
	ld a,$01		; $7bb0
	ld (de),a		; $7bb2
	ret			; $7bb3
_label_08_345:
	ld b,a			; $7bb4
	inc b			; $7bb5
	ld h,d			; $7bb6
	ld l,$45		; $7bb7
	ld (hl),b		; $7bb9
	ld l,$43		; $7bba
	ld (hl),$08		; $7bbc
	add $04			; $7bbe
	jp interactionSetAnimation		; $7bc0
	call interactionAnimate		; $7bc3
	ld h,d			; $7bc6
	ld l,$61		; $7bc7
	ld a,(hl)		; $7bc9
	or a			; $7bca
	jr z,_label_08_346	; $7bcb
	ld (hl),$00		; $7bcd
	ld l,$4d		; $7bcf
	add (hl)		; $7bd1
	ld (hl),a		; $7bd2
_label_08_346:
	ld l,$43		; $7bd3
	dec (hl)		; $7bd5
	ret nz			; $7bd6
	ld l,$45		; $7bd7
	ld (hl),$01		; $7bd9
	ret			; $7bdb

interactionCode54:
	ld e,$44		; $7bdc
	ld a,(de)		; $7bde
	rst_jumpTable			; $7bdf
	and $7b			; $7be0
	ld a,(de)		; $7be2
	ld a,h			; $7be3
	daa			; $7be4
	ld e,$3e		; $7be5
	ld bc,$cd12		; $7be7
	ld a,(de)		; $7bea
	inc b			; $7beb
	and $0f			; $7bec
	ld hl,$7c0a		; $7bee
	rst_addAToHl			; $7bf1
	ld a,(hl)		; $7bf2
	ld e,$42		; $7bf3
	ld (de),a		; $7bf5
	ld bc,$fe40		; $7bf6
	call objectSetSpeedZ		; $7bf9
	ld l,$50		; $7bfc
	ld (hl),$28		; $7bfe
	ld l,$49		; $7c00
	ld (hl),$08		; $7c02
	call interactionInitGraphics		; $7c04
	jp objectSetVisiblec1		; $7c07
	dec c			; $7c0a
	ld c,$10		; $7c0b
	ldd a,(hl)		; $7c0d
	ld b,b			; $7c0e
	ld d,h			; $7c0f
	halt			; $7c10
	ld d,a			; $7c11
	dec de			; $7c12
	ld e,l			; $7c13
	ld b,e			; $7c14
	inc bc			; $7c15
	ld sp,$2e13		; $7c16
	inc hl			; $7c19
	call objectApplySpeed		; $7c1a
	ld c,$20		; $7c1d
	call objectUpdateSpeedZ_paramC		; $7c1f
	ret nz			; $7c22
	ld e,$44		; $7c23
	ld a,$02		; $7c25
	ld (de),a		; $7c27
	jp objectReplaceWithAnimationIfOnHazard		; $7c28


; ==============================================================================
; INTERACID_SUBROSIAN_AT_D8
; ==============================================================================
interactionCode55:
	ld e,Interaction.subid		; $7c2b
	ld a,(de)		; $7c2d
	rst_jumpTable			; $7c2e
	.dw _subrosianAtD8_subid0
	.dw _subrosianAtD8_subid1

_subrosianAtD8_subid0:
	ld e,Interaction.state		; $7c33
	ld a,(de)		; $7c35
	rst_jumpTable			; $7c36
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call _subrosianAtD8_getNumEssences		; $7c3d
	cp $07			; $7c40
	jp c,interactionDelete		; $7c42

	call interactionInitGraphics		; $7c45
	ld hl,subrosianAtD8Script		; $7c48
	call interactionSetScript		; $7c4b

	ld a,$06		; $7c4e
	call objectSetCollideRadius		; $7c50

	ld l,Interaction.counter1		; $7c53
	ld (hl),60		; $7c55
	ld e,Interaction.pressedAButton		; $7c57
	call objectAddToAButtonSensitiveObjectList		; $7c59

	call getThisRoomFlags		; $7c5c
	and $40			; $7c5f
	ld a,$02		; $7c61
	jr nz,+			; $7c63
	dec a			; $7c65
+
	ld e,Interaction.state		; $7c66
	ld (de),a		; $7c68
	jp objectSetVisiblec2		; $7c69

; Waiting for Link to throw bomb in
@state1:
	ld e,Interaction.state2		; $7c6c
	ld a,(de)		; $7c6e
	rst_jumpTable			; $7c6f
	.dw @substate0
	.dw @substate1

@substate0:
	call interactionAnimate		; $7c74
	call objectPreventLinkFromPassing		; $7c77
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $7c7a
	ld e,Interaction.pressedAButton		; $7c7d
	ld a,(de)		; $7c7f
	or a			; $7c80
	jr nz,++		; $7c81

	call interactionDecCounter1		; $7c83
	ret nz			; $7c86
	ld l,Interaction.state2		; $7c87
	inc (hl)		; $7c89
	call objectSetVisiblec2		; $7c8a
	ld hl,subrosianAtD8Script_tossItemIntoHole		; $7c8d
	jp interactionSetScript		; $7c90
++
	xor a			; $7c93
	ld (de),a		; $7c94
	ld bc,TX_3c00		; $7c95
	jp showText		; $7c98

@substate1:
	call objectPreventLinkFromPassing		; $7c9b
	call interactionAnimate		; $7c9e
	call interactionRunScript		; $7ca1
	ret nc			; $7ca4

	ld h,d			; $7ca5
	ld l,Interaction.counter1		; $7ca6
	ld (hl),60		; $7ca8
	ld l,Interaction.state2		; $7caa
	dec (hl)		; $7cac
	ret			; $7cad

@state2:
	ld c,$60		; $7cae
	call objectUpdateSpeedZ_paramC		; $7cb0
	jr nz,++		; $7cb3
	ld bc,-$200		; $7cb5
	call objectSetSpeedZ		; $7cb8
++
	call objectPreventLinkFromPassing		; $7cbb
	call interactionAnimate		; $7cbe
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $7cc1
	jp interactionRunScript		; $7cc4


_subrosianAtD8_subid1:
	ld e,Interaction.state		; $7cc7
	ld a,(de)		; $7cc9
	rst_jumpTable			; $7cca
	.dw @state0
	.dw @state1

@state0:
	call _subrosianAtD8_getNumEssences		; $7ccf
	cp $07			; $7cd2
	jp c,interactionDelete		; $7cd4

	call getThisRoomFlags		; $7cd7
	and $40			; $7cda
	jp nz,interactionDelete		; $7cdc

	ld a,(wLinkPlayingInstrument)		; $7cdf
	or a			; $7ce2
	ret nz			; $7ce3
	ld a,(wTmpcfc0.genericCutscene.state)		; $7ce4
	or a			; $7ce7
	ret z			; $7ce8
	call checkLinkVulnerable		; $7ce9
	ret nc			; $7cec

	ld a,DISABLE_LINK		; $7ced
	ld (wDisabledObjects),a		; $7cef
	ld (wMenuDisabled),a		; $7cf2
	ld (wDisableScreenTransitions),a		; $7cf5
	ld a,90		; $7cf8
	call setScreenShakeCounter		; $7cfa

	ld e,Interaction.state		; $7cfd
	ld a,$01		; $7cff
	ld (de),a		; $7d01

	ld a,SNDCTRL_MEDIUM_FADEOUT		; $7d02
	jp playSound		; $7d04

@state1:
	ld a,(wScreenShakeCounterY)		; $7d07
	or a			; $7d0a
	ret nz			; $7d0b

	call getThisRoomFlags		; $7d0c
	set 6,(hl)		; $7d0f
	ld a,CUTSCENE_S_VOLCANO_ERUPTING		; $7d11
	ld (wCutsceneTrigger),a		; $7d13
	call fadeoutToWhite		; $7d16
	jp interactionDelete		; $7d19

;;
; @addr{7d1c}
_subrosianAtD8_getNumEssences:
	ld a,($c6bb)		; $7d1c
	jp getNumSetBits		; $7d1f

interactionCode57:
	ld e,$44		; $7d22
	ld a,(de)		; $7d24
	rst_jumpTable			; $7d25
	inc l			; $7d26
	ld a,l			; $7d27
	ld c,d			; $7d28
	ld a,l			; $7d29
	ld d,e			; $7d2a
	ld a,l			; $7d2b
	call interactionInitGraphics		; $7d2c
	call interactionSetAlwaysUpdateBit		; $7d2f
_label_08_350:
	ld h,d			; $7d32
	ld l,$44		; $7d33
	ld (hl),$01		; $7d35
	ld a,$0b		; $7d37
	call interactionSetHighTextIndex		; $7d39
	ld hl,$6325		; $7d3c
	call interactionSetScript		; $7d3f
	ld a,$02		; $7d42
	call interactionSetAnimation		; $7d44
	jp $7d99		; $7d47
	call $7d5a		; $7d4a
	call interactionRunScript		; $7d4d
	jp npcFaceLinkAndAnimate		; $7d50
	call interactionRunScript		; $7d53
	jr c,_label_08_350	; $7d56
	jr _label_08_351		; $7d58
	ld a,($d00b)		; $7d5a
	sub $20			; $7d5d
	ret nc			; $7d5f
	ld a,$22		; $7d60
	ld ($d00b),a		; $7d62
	ld a,($cc77)		; $7d65
	or a			; $7d68
	ret nz			; $7d69
	ld a,$80		; $7d6a
	ld ($cca4),a		; $7d6c
	ld a,$01		; $7d6f
	ld ($cc02),a		; $7d71
	ld hl,$6362		; $7d74
	call interactionSetScript		; $7d77
	ld h,d			; $7d7a
	ld l,$44		; $7d7b
	ld (hl),$02		; $7d7d
	inc l			; $7d7f
	ld (hl),$00		; $7d80
	pop bc			; $7d82
	ret			; $7d83
_label_08_351:
	call interactionAnimate		; $7d84
	ld e,$7e		; $7d87
	ld a,(de)		; $7d89
	or a			; $7d8a
	jr z,_label_08_352	; $7d8b
	ld e,$60		; $7d8d
	ld a,(de)		; $7d8f
	cp $0d			; $7d90
	jr nz,_label_08_352	; $7d92
	ld e,$60		; $7d94
	ld a,$01		; $7d96
	ld (de),a		; $7d98
_label_08_352:
	call objectPreventLinkFromPassing		; $7d99
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7d9c

interactionCode58:
	ld e,$44		; $7d9f
	ld a,(de)		; $7da1
	rst_jumpTable			; $7da2
	and a			; $7da3
	ld a,l			; $7da4
	call nc,$cd7d		; $7da5
	jp hl			; $7da8
	dec d			; $7da9
	ld h,d			; $7daa
	ld l,$44		; $7dab
	ld (hl),$01		; $7dad
	ld l,$7c		; $7daf
	ld (hl),$01		; $7db1
	ld l,$77		; $7db3
	ld (hl),$78		; $7db5
	ld l,$7b		; $7db7
	ld (hl),$01		; $7db9
	ld l,$79		; $7dbb
	ld (hl),$01		; $7dbd
	ld l,$50		; $7dbf
	ld (hl),$0f		; $7dc1
	call $7e20		; $7dc3
	ld a,$0b		; $7dc6
	call interactionSetHighTextIndex		; $7dc8
	ld hl,$63ad		; $7dcb
	call interactionSetScript		; $7dce
	jp $7ddc		; $7dd1
	call interactionRunScript		; $7dd4
	call $7deb		; $7dd7
	jr _label_08_353		; $7dda
_label_08_353:
	ld e,$79		; $7ddc
	ld a,(de)		; $7dde
	or a			; $7ddf
	jr z,_label_08_354	; $7de0
	call interactionAnimate		; $7de2
_label_08_354:
	call objectPreventLinkFromPassing		; $7de5
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7de8
	ld e,$78		; $7deb
	ld a,(de)		; $7ded
	rst_jumpTable			; $7dee
	di			; $7def
	ld a,l			; $7df0
	jr c,$7e		; $7df1
	ld e,$7b		; $7df3
	ld a,(de)		; $7df5
	or a			; $7df6
	jr z,_label_08_355	; $7df7
	ld h,d			; $7df9
	ld l,$77		; $7dfa
	dec (hl)		; $7dfc
	ret nz			; $7dfd
	ld (hl),$78		; $7dfe
	ld l,$49		; $7e00
	ld a,(hl)		; $7e02
	xor $10			; $7e03
	ld (hl),a		; $7e05
	ld l,$7a		; $7e06
	ld a,(hl)		; $7e08
	xor $02			; $7e09
	ld (hl),a		; $7e0b
	jp interactionSetAnimation		; $7e0c
_label_08_355:
	ld h,d			; $7e0f
	ld l,$78		; $7e10
	ld (hl),$01		; $7e12
	ld l,$79		; $7e14
	ld (hl),$00		; $7e16
	ld a,($d00d)		; $7e18
	ld l,$4d		; $7e1b
	cp (hl)			; $7e1d
	jr nc,_label_08_356	; $7e1e
	ld l,$49		; $7e20
	ld (hl),$18		; $7e22
	ld l,$7a		; $7e24
	ld a,$03		; $7e26
	ld (hl),a		; $7e28
	jp interactionSetAnimation		; $7e29
_label_08_356:
	ld l,$49		; $7e2c
	ld (hl),$08		; $7e2e
	ld l,$7a		; $7e30
	ld a,$01		; $7e32
	ld (hl),a		; $7e34
	jp interactionSetAnimation		; $7e35
	ld e,$7b		; $7e38
	ld a,(de)		; $7e3a
	or a			; $7e3b
	ret z			; $7e3c
	ld h,d			; $7e3d
	ld l,$78		; $7e3e
	ld (hl),$00		; $7e40
	ld l,$79		; $7e42
	ld (hl),$01		; $7e44
	ld l,$77		; $7e46
	ld (hl),$78		; $7e48
	ret			; $7e4a

interactionCode59:
	ld e,$44		; $7e4b
	ld a,(de)		; $7e4d
	rst_jumpTable			; $7e4e
	ld d,e			; $7e4f
	ld a,(hl)		; $7e50
	adc c			; $7e51
	ld a,(hl)		; $7e52
	call getThisRoomFlags		; $7e53
	and $40			; $7e56
	jp nz,interactionDelete		; $7e58
	ld a,$05		; $7e5b
	call checkTreasureObtained		; $7e5d
	jr nc,_label_08_357	; $7e60
	cp $03			; $7e62
	jp nc,interactionDelete		; $7e64
	sub $01			; $7e67
	ld e,$42		; $7e69
	ld (de),a		; $7e6b
_label_08_357:
	call interactionInitGraphics		; $7e6c
	call interactionIncState		; $7e6f
	call objectSetVisible		; $7e72
	call objectSetVisible80		; $7e75
	ld hl,$63ff		; $7e78
	call interactionSetScript		; $7e7b
	ld a,$4d		; $7e7e
	call playSound		; $7e80
	ld bc,$8404		; $7e83
	jp objectCreateInteraction		; $7e86
	call interactionRunScript		; $7e89
	jp c,interactionDelete		; $7e8c
	ret			; $7e8f

interactionCode5a:
	ld e,$44		; $7e90
	ld a,(de)		; $7e92
	rst_jumpTable			; $7e93
	sbc h			; $7e94
	ld a,(hl)		; $7e95
	xor l			; $7e96
	ld a,(hl)		; $7e97
	ret z			; $7e98
	ld a,(hl)		; $7e99
	inc c			; $7e9a
	dec h			; $7e9b
	ld a,$01		; $7e9c
	ld (de),a		; $7e9e
	call interactionSetAlwaysUpdateBit		; $7e9f
	ld a,$23		; $7ea2
	call interactionSetHighTextIndex		; $7ea4
	ld hl,$6425		; $7ea7
	call interactionSetScript		; $7eaa
	call interactionRunScript		; $7ead
	ret nc			; $7eb0
	ld h,d			; $7eb1
	ld l,$40		; $7eb2
	ld (hl),$01		; $7eb4
	ld l,$44		; $7eb6
	ld (hl),$02		; $7eb8
	ld a,$02		; $7eba
	ld ($cced),a		; $7ebc
	xor a			; $7ebf
	ld ($ccec),a		; $7ec0
	inc a			; $7ec3
	ld ($ccc9),a		; $7ec4
	ret			; $7ec7
	call $7eef		; $7ec8
	ret z			; $7ecb
	call restartSound		; $7ecc
	call interactionSetAlwaysUpdateBit		; $7ecf
	ld l,$44		; $7ed2
	ld (hl),$03		; $7ed4
	ld a,$03		; $7ed6
	ld ($cced),a		; $7ed8
	xor a			; $7edb
	ld ($cca7),a		; $7edc
	call resetLinkInvincibility		; $7edf
	xor a			; $7ee2
	ld ($ccc9),a		; $7ee3
	ld hl,$649a		; $7ee6
	call interactionSetScript		; $7ee9
	jp interactionRunScript		; $7eec
	ld hl,$c680		; $7eef
	ld a,($cca7)		; $7ef2
	or (hl)			; $7ef5
	inc l			; $7ef6
	or (hl)			; $7ef7
	ld a,$03		; $7ef8
	jr nz,_label_08_358	; $7efa
	ld a,$0b		; $7efc
	call objectGetRelatedObject1Var		; $7efe
	call $7f18		; $7f01
	ld a,$01		; $7f04
	jr nc,_label_08_358	; $7f06
	ld hl,$d00b		; $7f08
	call $7f18		; $7f0b
	ld a,$02		; $7f0e
	jr nc,_label_08_358	; $7f10
	xor a			; $7f12
_label_08_358:
	ld ($ccec),a		; $7f13
	or a			; $7f16
	ret			; $7f17
	ldi a,(hl)		; $7f18
	sub $16			; $7f19
	cp $4c			; $7f1b
	ret nc			; $7f1d
	inc l			; $7f1e
	ld a,(hl)		; $7f1f
	sub $22			; $7f20
	cp $5c			; $7f22
	ret			; $7f24

interactionCode5b:
	ld e,$44		; $7f25
	ld a,(de)		; $7f27
	rst_jumpTable			; $7f28
	dec l			; $7f29
	ld a,a			; $7f2a
	ld c,h			; $7f2b
	ld a,a			; $7f2c
	call interactionInitGraphics		; $7f2d
	ld a,$86		; $7f30
	call loadPaletteHeader		; $7f32
	call interactionSetAlwaysUpdateBit		; $7f35
	ld a,$0b		; $7f38
	call interactionSetHighTextIndex		; $7f3a
	ld h,d			; $7f3d
	ld l,$44		; $7f3e
	ld (hl),$01		; $7f40
	ld l,$49		; $7f42
	ld (hl),$04		; $7f44
	ld hl,$6506		; $7f46
	call interactionSetScript		; $7f49
	call interactionRunScript		; $7f4c
	call $7f55		; $7f4f
	jp interactionAnimateAsNpc		; $7f52
	ld e,$79		; $7f55
	ld a,(de)		; $7f57
	rst_jumpTable			; $7f58
	ld e,l			; $7f59
	ld a,a			; $7f5a
	ld l,l			; $7f5b
	ld a,a			; $7f5c
	ld h,d			; $7f5d
	ld l,$77		; $7f5e
	ld a,(hl)		; $7f60
	cp $04			; $7f61
	ret nz			; $7f63
	ld l,$79		; $7f64
	ld (hl),$01		; $7f66
	ld a,$3d		; $7f68
	jp playSound		; $7f6a
	ret			; $7f6d

interactionCode5c:
	ld e,$44		; $7f6e
	ld a,(de)		; $7f70
	rst_jumpTable			; $7f71
	halt			; $7f72
	ld a,a			; $7f73
	adc e			; $7f74
	ld a,a			; $7f75
	call interactionInitGraphics		; $7f76
	call interactionIncState		; $7f79
	ld l,$49		; $7f7c
	ld (hl),$04		; $7f7e
	ld a,$0b		; $7f80
	call interactionSetHighTextIndex		; $7f82
	ld hl,$654a		; $7f85
	call interactionSetScript		; $7f88
	call interactionRunScript		; $7f8b
	ld e,$7f		; $7f8e
	ld a,(de)		; $7f90
	or a			; $7f91
	jp z,npcFaceLinkAndAnimate		; $7f92
	call interactionAnimate		; $7f95
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7f98

interactionCode5d:
	ld e,$44		; $7f9b
	ld a,(de)		; $7f9d
	rst_jumpTable			; $7f9e
	and e			; $7f9f
	ld a,a			; $7fa0
	or c			; $7fa1
	ld a,a			; $7fa2
	call interactionInitGraphics		; $7fa3
	ld a,$06		; $7fa6
	call objectSetCollideRadius		; $7fa8
	ld l,$44		; $7fab
	inc (hl)		; $7fad
	jp objectSetVisiblec0		; $7fae
	ld e,$42		; $7fb1
	ld a,(de)		; $7fb3
	ld hl,$cfde		; $7fb4
	call checkFlag		; $7fb7
	jp nz,interactionDelete		; $7fba
	jp objectPreventLinkFromPassing		; $7fbd
