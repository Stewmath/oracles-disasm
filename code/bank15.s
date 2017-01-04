.BANK $15 SLOT 1
.ORG 0

	ld a,($cc88)		; $4000
	inc a			; $4003
	jr nz,+			; $4004
	xor a			; $4006
---
	ld e,Interaction.var3f		; $4007
	ld (de),a		; $4009
	ret			; $400a
+
	ld a,(wSecretInputResult)		; $400b
	swap a			; $400e
	and $03			; $4010
	rst_jumpTable			; $4012
	.dw @jump0
	.dw @jump1Or2
	.dw @jump1Or2
	.dw @jump3

@jump1Or2:
	ld a,$04		; $401b
	jr ---			; $401d
@jump0:
	ld a,$03		; $401f
	jr ---			; $4021
@jump3:
	ld a,(wSecretInputResult)		; $4023
	and $0f			; $4026
	add GLOBALFLAG_5a			; $4028
	ld b,a			; $402a
	call checkGlobalFlag		; $402b
	ld a,$02		; $402e
	jr nz,---		; $4030

	ld a,b			; $4032
	sub GLOBALFLAG_INTRO_DONE			; $4033
	call checkGlobalFlag		; $4035
	ld a,$01		; $4038
	jr nz,---		; $403a
	ld a,$05		; $403c
	jr ---			; $403e

	ld a,(wSecretInputResult)		; $4040
	and $0f			; $4043
	add $0f			; $4045
	ld c,a			; $4047
	ld b,$55		; $4048
	jp showText		; $404a

	call getFreeInteractionSlot		; $404d
	ret nz			; $4050
	ld (hl),$d9		; $4051
	inc l			; $4053
	ld a,(wSecretInputResult)		; $4054
	and $0f			; $4057
	ld (hl),a		; $4059
	ld l,$4b		; $405a
	ld c,$75		; $405c
	jp setShortPosition_paramC		; $405e
	ld hl,$481b		; $4061
	ld e,$03		; $4064
	jp interBankCall		; $4066
	call objectGetShortPosition		; $4069
	ld c,a			; $406c
	ld a,(wLinkLocalRespawnY)		; $406d
	and $f0			; $4070
	ld b,a			; $4072
	ld a,(wLinkLocalRespawnX)		; $4073
	and $f0			; $4076
	swap a			; $4078
	or b			; $407a
	cp c			; $407b
	ret nz			; $407c
	ld e,$49		; $407d
	ld a,(de)		; $407f
	rrca			; $4080
	and $03			; $4081
	ld hl,$409c		; $4083
	rst_addAToHl			; $4086
	ld a,(hl)		; $4087
	add c			; $4088
	ld c,a			; $4089
	and $f0			; $408a
	or $08			; $408c
	ld (wLinkLocalRespawnY),a		; $408e
	ld a,c			; $4091
	swap a			; $4092
	and $f0			; $4094
	or $08			; $4096
	ld (wLinkLocalRespawnX),a		; $4098
	ret			; $409b
	stop			; $409c
	rst $38			; $409d
	ld a,($ff00+R_SB)	; $409e
	ld e,$7d		; $40a0
	ld a,(de)		; $40a2
	ld b,a			; $40a3
	ld a,(wActiveTriggers)		; $40a4
	and b			; $40a7
	jr z,_label_15_002	; $40a8
	call $40c0		; $40aa
	ld a,$01		; $40ad
	jr z,_label_15_003	; $40af
	xor a			; $40b1
	jr _label_15_003		; $40b2
_label_15_002:
	call $40d8		; $40b4
	ld a,$02		; $40b7
	jr z,_label_15_003	; $40b9
	xor a			; $40bb
_label_15_003:
	ld (wCFC1),a		; $40bc
	ret			; $40bf
	ld e,$49		; $40c0
	ld a,(de)		; $40c2
	sub $10			; $40c3
	srl a			; $40c5
	ld hl,$40d4		; $40c7
	rst_addAToHl			; $40ca
	ld e,$7e		; $40cb
	ld a,(de)		; $40cd
	ld c,a			; $40ce
	ld b,$cf		; $40cf
	ld a,(bc)		; $40d1
	cp (hl)			; $40d2
	ret			; $40d3
	ld a,b			; $40d4
	ld a,c			; $40d5
	ld a,d			; $40d6
	ld a,e			; $40d7
	ld e,$7e		; $40d8
	ld a,(de)		; $40da
	ld c,a			; $40db
	ld b,$ce		; $40dc
	ld a,(bc)		; $40de
	or a			; $40df
	ret			; $40e0
	xor a			; $40e1
	ld (wCFC1),a		; $40e2
	ld a,(wLinkObjectIndex)		; $40e5
	rrca			; $40e8
	ret nc			; $40e9
	call objectCheckCollidedWithLink_ignoreZ		; $40ea
	ret nc			; $40ed
	ld a,$01		; $40ee
	ld (wCFC1),a		; $40f0
	ret			; $40f3
	ld e,$7e		; $40f4
	ld a,(de)		; $40f6
	ld c,a			; $40f7
	ld b,$cf		; $40f8
	ld a,(bc)		; $40fa
	cp $5d			; $40fb
	ld b,$01		; $40fd
	jr z,_label_15_004	; $40ff
	cp $5e			; $4101
	jr z,_label_15_004	; $4103
	dec b			; $4105
_label_15_004:
	ld a,b			; $4106
	ld (wCFC1),a		; $4107
	ret			; $410a
	ld a,(wNumTorchesLit)		; $410b
	ld b,a			; $410e
	ld e,$50		; $410f
	ld a,(de)		; $4111
	cp b			; $4112
	ld a,$01		; $4113
	jr z,_label_15_005	; $4115
	dec a			; $4117
_label_15_005:
	ld (wTmpCec0),a		; $4118
	ret			; $411b
	ld a,$04		; $411c
	jp removeRupeeValue		; $411e
	ld a,(wDungeonIndex)		; $4121
	ld b,a			; $4124
	inc a			; $4125
	jr nz,_label_15_006	; $4126
	ld hl,$41be		; $4128
	jr _label_15_007		; $412b
_label_15_006:
	ld a,b			; $412d
	ld hl,$41be		; $412e
	rst_addDoubleIndex			; $4131
	ldi a,(hl)		; $4132
	ld h,(hl)		; $4133
	ld l,a			; $4134
_label_15_007:
	ld e,$72		; $4135
	ld a,(de)		; $4137
	rst_addDoubleIndex			; $4138
	ldi a,(hl)		; $4139
	ld h,(hl)		; $413a
	ld l,a			; $413b
	jr _label_15_012		; $413c
	ld e,$58		; $413e
	ld a,(de)		; $4140
	ld l,a			; $4141
	inc e			; $4142
	ld a,(de)		; $4143
	ld h,a			; $4144
_label_15_008:
	ldi a,(hl)		; $4145
	push hl			; $4146
	rst_jumpTable			; $4147
.dw $4160
.dw $416b
.dw $4177
.dw $417e
.dw $4185
.dw $418d
.dw $4160
.dw $4160
.dw $41a3
.dw $41a7
.dw $41ab
.dw $41af
	pop hl			; $4160
	ldi a,(hl)		; $4161
	ld e,$46		; $4162
	ld (de),a		; $4164
	ld e,$45		; $4165
	xor a			; $4167
	ld (de),a		; $4168
	jr _label_15_012		; $4169
_label_15_009:
	pop hl			; $416b
	ldi a,(hl)		; $416c
	ld e,$46		; $416d
	ld (de),a		; $416f
	ld e,$45		; $4170
	ld a,$01		; $4172
	ld (de),a		; $4174
	jr _label_15_012		; $4175
	pop hl			; $4177
	ldi a,(hl)		; $4178
	ld e,$49		; $4179
	ld (de),a		; $417b
	jr _label_15_008		; $417c
	pop hl			; $417e
	ldi a,(hl)		; $417f
	ld e,$50		; $4180
	ld (de),a		; $4182
	jr _label_15_008		; $4183
	pop hl			; $4185
	ld a,(hl)		; $4186
	call s8ToS16		; $4187
	add hl,bc		; $418a
	jr _label_15_008		; $418b
	pop hl			; $418d
	ld a,(wPlayingInstrument2)		; $418e
	cp d			; $4191
	jr nz,_label_15_010	; $4192
	inc hl			; $4194
	jr _label_15_008		; $4195
_label_15_010:
	dec hl			; $4197
	ld a,$01		; $4198
	ld e,$46		; $419a
	ld (de),a		; $419c
	xor a			; $419d
	ld e,$45		; $419e
	ld (de),a		; $41a0
	jr _label_15_012		; $41a1
	ld a,$00		; $41a3
	jr _label_15_011		; $41a5
	ld a,$08		; $41a7
	jr _label_15_011		; $41a9
	ld a,$10		; $41ab
	jr _label_15_011		; $41ad
	ld a,$18		; $41af
_label_15_011:
	ld e,$49		; $41b1
	ld (de),a		; $41b3
	jr _label_15_009		; $41b4
_label_15_012:
	ld e,$58		; $41b6
	ld a,l			; $41b8
	ld (de),a		; $41b9
	inc e			; $41ba
	ld a,h			; $41bb
	ld (de),a		; $41bc
	ret			; $41bd
	ret nc			; $41be
	ld b,c			; $41bf
	ret nc			; $41c0
	ld b,c			; $41c1
.DB $ec				; $41c2
	ld b,c			; $41c3
.DB $ec				; $41c4
	ld b,c			; $41c5
.DB $ec				; $41c6
	ld b,c			; $41c7
	ld c,b			; $41c8
	ld b,d			; $41c9
	ld c,b			; $41ca
	ld b,d			; $41cb
	ld c,b			; $41cc
	ld b,d			; $41cd
	ld c,b			; $41ce
	ld b,d			; $41cf
	call nc,$de41		; $41d0
	ld b,c			; $41d3
	nop			; $41d4
	ld ($8008),sp		; $41d5
	nop			; $41d8
	ld ($800a),sp		; $41d9
	inc b			; $41dc
	rst $30			; $41dd
	nop			; $41de
	ld ($400b),sp		; $41df
	nop			; $41e2
	ld ($8009),sp		; $41e3
	nop			; $41e6
	ld ($800b),sp		; $41e7
	inc b			; $41ea
	rst $30			; $41eb
	ld hl,sp+$41		; $41ec
	ld b,$42		; $41ee
	inc d			; $41f0
	ld b,d			; $41f1
	ldi (hl),a		; $41f2
	ld b,d			; $41f3
	jr nc,_label_15_013	; $41f4
	ldd a,(hl)		; $41f6
	ld b,d			; $41f7
	nop			; $41f8
	ld ($6008),sp		; $41f9
	nop			; $41fc
	ld ($a00a),sp		; $41fd
	nop			; $4200
	ld ($a008),sp		; $4201
	inc b			; $4204
	rst $30			; $4205
	nop			; $4206
	ld ($2008),sp		; $4207
	nop			; $420a
	ld ($c00a),sp		; $420b
	nop			; $420e
	ld ($c008),sp		; $420f
	inc b			; $4212
	rst $30			; $4213
	nop			; $4214
	ld ($4008),sp		; $4215
	nop			; $4218
	ld ($a00a),sp		; $4219
	nop			; $421c
	ld ($a008),sp		; $421d
	inc b			; $4220
	rst $30			; $4221
	nop			; $4222
	ld ($2009),sp		; $4223
	nop			; $4226
	ld ($c00b),sp		; $4227
	nop			; $422a
	ld ($c009),sp		; $422b
	inc b			; $422e
	rst $30			; $422f
	nop			; $4230
	ld ($600a),sp		; $4231
	nop			; $4234
	ld ($6008),sp		; $4235
_label_15_013:
	inc b			; $4238
	rst $30			; $4239
	nop			; $423a
	ld ($200b),sp		; $423b
	nop			; $423e
	ld ($a009),sp		; $423f
	nop			; $4242
	ld ($a00b),sp		; $4243
	inc b			; $4246
	rst $30			; $4247
	call objectGetPosition		; $4248
	ld a,$ff		; $424b
	jp createEnergySwirlGoingIn		; $424d
	ld a,$01		; $4250
	ld ($cd2d),a		; $4252
	ret			; $4255
	call getFreeInteractionSlot		; $4256
	ld bc,$2c00		; $4259
	ld (hl),$60		; $425c
	inc l			; $425e
	ld (hl),b		; $425f
	inc l			; $4260
	ld (hl),c		; $4261
	ld l,$4b		; $4262
	ld a,(w1Link.yh)		; $4264
	ldi (hl),a		; $4267
	inc l			; $4268
	ld a,(w1Link.xh)		; $4269
	ld (hl),a		; $426c
	ret			; $426d
	ld ($cbd3),a		; $426e
	ld a,$01		; $4271
	ld (wDisabledObjects),a		; $4273
	ld a,$04		; $4276
	jp openMenu		; $4278
	ld a,$02		; $427b
	jp func_1a44		; $427d
	ld a,GLOBALFLAG_28		; $4280
	call setGlobalFlag		; $4282
	ld bc,$0002		; $4285
	jp func_1a2e		; $4288
	ld e,$44		; $428b
	ld a,$05		; $428d
	ld (de),a		; $428f
	xor a			; $4290
	inc e			; $4291
	ld (de),a		; $4292
	ld b,$03		; $4293
	call func_1a2e		; $4295
	call serialFunc_0c85		; $4298
	ld a,(wSelectedTextOption)		; $429b
	ld e,$79		; $429e
	ld (de),a		; $42a0
	ld bc,$300e		; $42a1
	or a			; $42a4
	jr z,_label_15_014	; $42a5
	ld e,$45		; $42a7
	ld a,$03		; $42a9
	ld (de),a		; $42ab
	ld bc,$3028		; $42ac
_label_15_014:
	jp showText		; $42af
	ld a,$00		; $42b2
	call $42d4		; $42b4
	jr nz,_label_15_016	; $42b7
	ld a,$01		; $42b9
	call $42d4		; $42bb
	jr nz,_label_15_016	; $42be
	ld a,$02		; $42c0
	call $42d4		; $42c2
	jr nz,_label_15_016	; $42c5
	ld a,$03		; $42c7
_label_15_015:
	ld e,$7b		; $42c9
	ld (de),a		; $42cb
	ret			; $42cc
_label_15_016:
	ld e,$7a		; $42cd
	ld (de),a		; $42cf
	sub $34			; $42d0
	jr _label_15_015		; $42d2
	ld c,a			; $42d4
	call checkGlobalFlag		; $42d5
	jr z,_label_15_017	; $42d8
	ld a,c			; $42da
	add $04			; $42db
	ld c,a			; $42dd
	call checkGlobalFlag		; $42de
	jr nz,_label_15_017	; $42e1
	ld a,c			; $42e3
	call setGlobalFlag		; $42e4
	ld a,c			; $42e7
	add $30			; $42e8
	ret			; $42ea
_label_15_017:
	xor a			; $42eb
	ret			; $42ec
	ld a,$00		; $42ed
	jr _label_15_018		; $42ef
	ld a,$38		; $42f1
	jr _label_15_018		; $42f3
	ld e,$7a		; $42f5
	ld a,(de)		; $42f7
_label_15_018:
	ld b,a			; $42f8
	ld c,$00		; $42f9
	jp giveRingToLink		; $42fb
	xor a			; $42fe
	ld (wMapleKillCounter),a		; $42ff
	inc a			; $4302
	ld ($c614),a		; $4303
	ld a,$1c		; $4306
	ld ($c6e6),a		; $4308
	ld a,$8c		; $430b
	ld ($c6e7),a		; $430d
	ld a,GLOBALFLAG_FINISHEDGAME		; $4310
	jp setGlobalFlag		; $4312

;;
; @addr{4315}
getObjectDataAddress:
	ld a,(wActiveGroup)		; $4315
	ld hl,objectData.objectDataGroupTable
	rst_addDoubleIndex			; $431b
	ldi a,(hl)		; $431c
	ld h,(hl)		; $431d
	ld l,a			; $431e
	ld a,(wActiveRoom)		; $431f
	ld e,a			; $4322
	ld d,$00		; $4323
	add hl,de		; $4325
	add hl,de		; $4326
	ldi a,(hl)		; $4327
	ld d,(hl)		; $4328
	ld e,a			; $4329
	ret			; $432a

 m_section_free "Object_Pointers" namespace "objectData"

.include "objects/pointers.s"

.ENDS

.orga $4f3b

 m_section_force "Bank_15"

	ld hl,wActiveTriggers		; $4f3b
	ld a,(hl)		; $4f3e
	and $03			; $4f3f
	cp $03			; $4f41
	jr nz,_label_15_029	; $4f43
	set 2,(hl)		; $4f45
	ret			; $4f47
_label_15_029:
	res 2,(hl)		; $4f48
	ret			; $4f4a
	call getFreeInteractionSlot		; $4f4b
	ret nz			; $4f4e
	ld (hl),$c7		; $4f4f
	inc l			; $4f51
	ld (hl),$08		; $4f52
	ld l,$4b		; $4f54
	ld (hl),$06		; $4f56
	ld l,$4d		; $4f58
	ld (hl),$10		; $4f5a
	ret			; $4f5c
	call getThisRoomFlags		; $4f5d
	set 7,(hl)		; $4f60
	ld a,$4d		; $4f62
	jp playSound		; $4f64
	call getFreePartSlot		; $4f67
	ret nz			; $4f6a
	ld (hl),$0c		; $4f6b
	ld l,$c7		; $4f6d
	ld (hl),b		; $4f6f
	ld l,$c9		; $4f70
	ld (hl),c		; $4f72
	ld l,$cb		; $4f73
_label_15_030:
	ld (hl),e		; $4f75
	ret			; $4f76
	call getThisRoomFlags		; $4f77
	set 6,(hl)		; $4f7a
	ld a,$4d		; $4f7c
	call playSound		; $4f7e
	ld bc,$0800		; $4f81
	ld e,$69		; $4f84
	jp $4f67		; $4f86
	call getThisRoomFlags		; $4f89
	set 6,(hl)		; $4f8c
	ld a,$4d		; $4f8e
	call playSound		; $4f90
	ld bc,$0803		; $4f93
	ld e,$2a		; $4f96
	jp $4f67		; $4f98
	ld a,$0b		; $4f9b
	ld ($cc04),a		; $4f9d
	jp resetLinkInvincibility		; $4fa0
	xor a			; $4fa3
	ld (wDisabledObjects),a		; $4fa4
	ld (wMenuDisabled),a		; $4fa7
_label_15_031:
	ld ($cc91),a		; $4faa
	ld ($cc90),a		; $4fad
	ret			; $4fb0
	ld e,$42		; $4fb1
	ld a,(de)		; $4fb3
	ld hl,$4fbd		; $4fb4
	rst_addAToHl			; $4fb7
	ld b,$43		; $4fb8
	ld c,(hl)		; $4fba
	jp showText		; $4fbb
	ld (bc),a		; $4fbe
	inc bc			; $4fbf
	inc bc			; $4fc0
	inc b			; $4fc1
	dec b			; $4fc2
	ld b,$07		; $4fc3
	ld ($eb08),sp		; $4fc5
	cp (hl)			; $4fc8
	sbc (hl)		; $4fc9
	cp l			; $4fca
	or b			; $4fcb
	jr nz,_label_15_031	; $4fcc
	ld c,a			; $4fce
	sbc b			; $4fcf
	ld b,e			; $4fd0
	ld de,$34de		; $4fd1
	ld ($99f0),sp		; $4fd4
	sbc b			; $4fd7
	ld b,e			; $4fd8
	ld (de),a		; $4fd9
	ld c,a			; $4fda
	ret z			; $4fdb
	sbc b			; $4fdc
	ld b,e			; $4fdd
	inc de			; $4fde
	ld c,a			; $4fdf
	ret z			; $4fe0
	ld hl,$c6e1		; $4fe1
	ld (hl),a		; $4fe4
	ret			; $4fe5
	ld hl,$c6e2		; $4fe6
	jp setFlag		; $4fe9
	ld hl,$c6e2		; $4fec
	call checkFlag		; $4fef
	ld a,$01		; $4ff2
	jr nz,_label_15_032	; $4ff4
	xor a			; $4ff6
_label_15_032:
	ld e,$7b		; $4ff7
	ld (de),a		; $4ff9
	ret			; $4ffa
	call func_1765		; $4ffb
	ld e,$7c		; $4ffe
	ld (de),a		; $5000
	ret			; $5001
	ld hl,wC60f		; $5002
	add (hl)		; $5005
	ld (hl),a		; $5006
	ret			; $5007
	ld hl,wKidName		; $5008
	ld b,$00		; $500b
_label_15_033:
	ldi a,(hl)		; $500d
	or a			; $500e
	jr z,_label_15_034	; $500f
	and $0f			; $5011
	add b			; $5013
	ld b,a			; $5014
	jr _label_15_033		; $5015
_label_15_034:
	ld a,b			; $5017
_label_15_035:
	sub $03			; $5018
	jr nc,_label_15_035	; $501a
	add $04			; $501c
	ld (wC60f),a		; $501e
	ret			; $5021
	ld a,$07		; $5022
	jp openMenu		; $5024
	cp l			; $5027
	pop de			; $5028
	ld hl,sp-$6f		; $5029
	ld ($00d0),sp		; $502b
	or $e3			; $502e
	ld (hl),d		; $5030
	adc (hl)		; $5031
	ld e,d			; $5032
	add b			; $5033
	or $98			; $5034
	ld d,(hl)		; $5036
	inc de			; $5037
	nop			; $5038
	ld hl,wNumRupees		; $5039
	ldi a,(hl)		; $503c
	or (hl)			; $503d
	ld e,$7f		; $503e
	ld (de),a		; $5040
	ret z			; $5041
	ld a,$01		; $5042
	ld (de),a		; $5044
	ld e,$42		; $5045
	ld a,(de)		; $5047
	ld hl,$505d		; $5048
	rst_addAToHl			; $504b
	ld a,(hl)		; $504c
	jp removeRupeeValue		; $504d
	ld e,$42		; $5050
	ld a,(de)		; $5052
	ld hl,$505d		; $5053
	rst_addAToHl			; $5056
	ld c,(hl)		; $5057
	ld a,$28		; $5058
	jp addQuestItemToInventory		; $505a
	dec c			; $505d
	inc c			; $505e
	call getFreeInteractionSlot		; $505f
	ret nz			; $5062
	ld (hl),$30		; $5063
	inc l			; $5065
	ld (hl),$03		; $5066
	inc l			; $5068
	ld e,$42		; $5069
	ld a,(de)		; $506b
	ld (hl),a		; $506c
	ret			; $506d
	call $5074		; $506e
	jp $5118		; $5071
	ld hl,$508b		; $5074
	rst_addDoubleIndex			; $5077
	ldi a,(hl)		; $5078
	ld b,(hl)		; $5079
	ld c,a			; $507a
	ld hl,wTextNumberSubstitution		; $507b
	ldi a,(hl)		; $507e
	ld h,(hl)		; $507f
	ld l,a			; $5080
	call compareHlToBc		; $5081
	inc a			; $5084
	jr nz,_label_15_036	; $5085
	inc a			; $5087
	ret			; $5088
_label_15_036:
	xor a			; $5089
	ret			; $508a
	ld d,b			; $508b
	inc bc			; $508c
	ld d,b			; $508d
	ld (bc),a		; $508e
	ld d,b			; $508f
	ld bc,$0050		; $5090
	nop			; $5093
	inc b			; $5094
	nop			; $5095
	inc bc			; $5096
	nop			; $5097
	ld (bc),a		; $5098
	nop			; $5099
	ld bc,$0300		; $509a
	ld hl,hFF8A		; $509d
	ld a,(wInventoryA)		; $50a0
	cp $05			; $50a3
	jr nz,_label_15_037	; $50a5
	xor a			; $50a7
	ldi (hl),a		; $50a8
	ld a,$05		; $50a9
	ld (hl),a		; $50ab
	jr _label_15_038		; $50ac
_label_15_037:
	ld a,$05		; $50ae
	ldi (hl),a		; $50b0
	xor a			; $50b1
	ld (hl),a		; $50b2
	jr _label_15_038		; $50b3
	ld hl,hFF8A		; $50b5
	ld a,$0c		; $50b8
	ldi (hl),a		; $50ba
	ld (hl),a		; $50bb
_label_15_038:
	ld bc,wInventoryB		; $50bc
	ld hl,$cfd7		; $50bf
	ld a,(bc)		; $50c2
	ldi (hl),a		; $50c3
	ldh a,(<hFF8A)	; $50c4
	ld (bc),a		; $50c6
	inc c			; $50c7
	ld a,(bc)		; $50c8
	ldi (hl),a		; $50c9
	ldh a,(<hFF8B)	; $50ca
	ld (bc),a		; $50cc
	ld a,$ff		; $50cd
	ld (wStatusBarNeedsRefresh),a		; $50cf
	ret			; $50d2
	ld bc,wInventoryB		; $50d3
	ld hl,$cfd7		; $50d6
	ldi a,(hl)		; $50d9
	ld (bc),a		; $50da
	inc c			; $50db
	ldi a,(hl)		; $50dc
	ld (bc),a		; $50dd
	ld a,$ff		; $50de
	ld (wStatusBarNeedsRefresh),a		; $50e0
	ret			; $50e3
	ld a,(w1Link.yh)		; $50e4
	ld b,a			; $50e7
	ld a,(w1Link.xh)		; $50e8
	ld c,a			; $50eb
	ld a,$6e		; $50ec
	jp createEnergySwirlGoingIn		; $50ee
	ld b,$84		; $50f1
	jp objectCreateInteractionWithSubid00		; $50f3
	ld hl,$57bd		; $50f6
	ld e,$08		; $50f9
	jp interBankCall		; $50fb
	ld hl,$5111		; $50fe
	rst_addAToHl			; $5101
	ld c,$74		; $5102
_label_15_039:
	ldi a,(hl)		; $5104
	push hl			; $5105
	call setTile		; $5106
	pop hl			; $5109
	inc c			; $510a
	ld a,c			; $510b
	cp $76			; $510c
	jr nz,_label_15_039	; $510e
	ret			; $5110
	ld ($ff00+$e1),a	; $5111
	add $c6			; $5113
	call func_1765		; $5115
	push af			; $5118
	pop bc			; $5119
	ld a,c			; $511a
	ld ($cddb),a		; $511b
	ret			; $511e
	ld c,a			; $511f
	ld a,$28		; $5120
	jp addQuestItemToInventory		; $5122
	ld c,$40		; $5125
	jr _label_15_040		; $5127
	ld c,$04		; $5129
	jr _label_15_040		; $512b
	ld c,a			; $512d
_label_15_040:
	ld a,$29		; $512e
	jp addQuestItemToInventory		; $5130
_label_15_041:
	ld b,a			; $5133
	ld c,$00		; $5134
	jp giveRingToLink		; $5136
	call getRandomNumber		; $5139
	and $0f			; $513c
	ld hl,$5145		; $513e
	rst_addAToHl			; $5141
	ld a,(hl)		; $5142
	jr _label_15_041		; $5143
	jr $1d			; $5145
	dec e			; $5147
	dec e			; $5148
	dec e			; $5149
	rra			; $514a
	rra			; $514b
	rra			; $514c
	rra			; $514d
	rra			; $514e
	ldi a,(hl)		; $514f
	ldi a,(hl)		; $5150
	ldi a,(hl)		; $5151
	ldi a,(hl)		; $5152
	ldi a,(hl)		; $5153
	ldi a,(hl)		; $5154
	ld hl,w1Link.direction		; $5155
	ld (hl),a		; $5158
	jp setLinkForceStateToState08		; $5159
	ld a,$00		; $515c
	ld bc,$6050		; $515e
	jr _label_15_042		; $5161
	ld a,$01		; $5163
	ld bc,$6868		; $5165
	jr _label_15_042		; $5168
	ld a,$03		; $516a
	ld bc,$6838		; $516c
_label_15_042:
	ld hl,w1Link.yh		; $516f
	ld (hl),b		; $5172
	ld l,$0d		; $5173
	ld (hl),c		; $5175
	ld hl,w1Link.direction		; $5176
	ld (hl),a		; $5179
	call func_2a8c		; $517a
	jp setLinkForceStateToState08		; $517d
	call checkIsLinkedGame		; $5180
	jp $5118		; $5183
	call checkIsLinkedGame		; $5186
	call $5118		; $5189
	cpl			; $518c
	ld ($cddb),a		; $518d
	ret			; $5190
	ld h,d			; $5191
	ld l,$54		; $5192
	ld (hl),$00		; $5194
	inc hl			; $5196
	ld (hl),$fe		; $5197
	ld a,$53		; $5199
	jp playSound		; $519b
	ld c,$30		; $519e
	call objectUpdateSpeedZ_paramC		; $51a0
	jp $5118		; $51a3
	ld hl,$ccd4		; $51a6
	jr _label_15_043		; $51a9
	ld hl,wCFC0		; $51ab
_label_15_043:
	add (hl)		; $51ae
	ld (hl),a		; $51af
	ret			; $51b0
	cp l			; $51b1
	rst $30			; $51b2
	ld ($ff00+$6c),a	; $51b3
	ldd (hl),a		; $51b5
	pop de			; $51b6
	ld ($ff00+$d3),a	; $51b7
	ld d,b			; $51b9
	pop hl			; $51ba
	cp $50			; $51bb
	nop			; $51bd
	ld ($ff00+$f6),a	; $51be
	ld d,b			; $51c0
	ld ($ff00+$ad),a	; $51c1
	add hl,de		; $51c3
	ld ($ff00+$63),a	; $51c4
	ld d,c			; $51c6
	push af			; $51c7
	ldh (<hScriptAddressH),a	; $51c8
	ldd (hl),a		; $51ca
	pop de			; $51cb
.DB $e4				; $51cc
	rst $38			; $51cd
	rst $30			; $51ce
	ld ($ff00+$86),a	; $51cf
	ld d,c			; $51d1
	rst_jumpTable			; $51d2
.DB $db				; $51d3
	call $f780		; $51d4
	ld d,c			; $51d7
	rst_addDoubleIndex			; $51d8
	ld c,$e0		; $51d9
	ld d,c			; $51db
	or l			; $51dc
	dec e			; $51dd
	ld ($ff00+c),a		; $51de
	ld d,c			; $51df
	ld d,c			; $51e0
	rst $30			; $51e1
	pop hl			; $51e2
	ld l,(hl)		; $51e3
	ld d,b			; $51e4
	inc bc			; $51e5
	rst_jumpTable			; $51e6
.DB $db				; $51e7
	call $ee80		; $51e8
	ld d,c			; $51eb
	ld d,d			; $51ec
	rra			; $51ed
	sbc b			; $51ee
	ld ($f61b),sp		; $51ef
	sbc $0e			; $51f2
	nop			; $51f4
	ld d,d			; $51f5
	ld c,l			; $51f6
	pop hl			; $51f7
	ld l,(hl)		; $51f8
_label_15_044:
	ld d,b			; $51f9
	nop			; $51fa
	rst_jumpTable			; $51fb
.DB $db				; $51fc
	call $2480		; $51fd
	ld d,d			; $5200
	pop hl			; $5201
	ld l,(hl)		; $5202
	ld d,b			; $5203
	ld bc,$dbc7		; $5204
	call $2d80		; $5207
	ld d,d			; $520a
	pop hl			; $520b
	ld l,(hl)		; $520c
	ld d,b			; $520d
	ld (bc),a		; $520e
	rst_jumpTable			; $520f
.DB $db				; $5210
	call $3680		; $5211
	ld d,d			; $5214
	pop hl			; $5215
	ld l,(hl)		; $5216
	ld d,b			; $5217
	inc bc			; $5218
	rst_jumpTable			; $5219
.DB $db				; $521a
	call $4380		; $521b
	ld d,d			; $521e
	sbc b			; $521f
	ld ($5219),sp		; $5220
	ld c,l			; $5223
	sbc b			; $5224
	ld ($f615),sp		; $5225
	ld ($ff00+$39),a	; $5228
	ld d,c			; $522a
	ld d,d			; $522b
	ld c,l			; $522c
	sbc b			; $522d
	ld ($f616),sp		; $522e
	sbc $34			; $5231
	nop			; $5233
	ld d,d			; $5234
	ld c,l			; $5235
	sbc b			; $5236
	ld ($f617),sp		; $5237
	pop hl			; $523a
	rra			; $523b
	ld d,c			; $523c
	rlca			; $523d
	sbc b			; $523e
	nop			; $523f
	dec b			; $5240
	ld d,d			; $5241
	ld c,l			; $5242
	sbc b			; $5243
	ld ($f618),sp		; $5244
	sbc b			; $5247
	nop			; $5248
	ld d,c			; $5249
	ld ($ff00+$29),a	; $524a
	ld d,c			; $524c
	or $00			; $524d
	cp l			; $524f
	rst $30			; $5250
	ld ($ff00+$6c),a	; $5251
	ldd (hl),a		; $5253
	pop de			; $5254
	ld ($ff00+$d3),a	; $5255
	ld d,b			; $5257
	pop hl			; $5258
	cp $50			; $5259
	nop			; $525b
	ld ($ff00+$f6),a	; $525c
	ld d,b			; $525e
	ld ($ff00+$ad),a	; $525f
	add hl,de		; $5261
	ld ($ff00+$63),a	; $5262
	ld d,c			; $5264
	push af			; $5265
	ldh (<hScriptAddressH),a	; $5266
	ldd (hl),a		; $5268
	pop de			; $5269
.DB $e4				; $526a
	rst $38			; $526b
	rst $30			; $526c
	or b			; $526d
	jr nz,_label_15_044	; $526e
	ld d,d			; $5270
	pop hl			; $5271
	ld l,(hl)		; $5272
	ld d,b			; $5273
	rlca			; $5274
	rst_jumpTable			; $5275
.DB $db				; $5276
	call $8080		; $5277
	ld d,d			; $527a
	sbc b			; $527b
	inc h			; $527c
	reti			; $527d
	ld d,d			; $527e
	ldh (<hScriptAddressL),a	; $527f
	inc h			; $5281
	ret c			; $5282
	or $de			; $5283
	ld e,d			; $5285
	nop			; $5286
	ld d,d			; $5287
	ld ($ff00+$e1),a	; $5288
	ld l,(hl)		; $528a
	ld d,b			; $528b
	inc b			; $528c
	rst_jumpTable			; $528d
.DB $db				; $528e
	call $b680		; $528f
	ld d,d			; $5292
	pop hl			; $5293
	ld l,(hl)		; $5294
	ld d,b			; $5295
	dec b			; $5296
	rst_jumpTable			; $5297
.DB $db				; $5298
	call $c380		; $5299
	ld d,d			; $529c
	pop hl			; $529d
	ld l,(hl)		; $529e
	ld d,b			; $529f
	ld b,$c7		; $52a0
.DB $db				; $52a2
	call $cc80		; $52a3
	ld d,d			; $52a6
	pop hl			; $52a7
	ld l,(hl)		; $52a8
	ld d,b			; $52a9
	rlca			; $52aa
	rst_jumpTable			; $52ab
.DB $db				; $52ac
	call $d580		; $52ad
	ld d,d			; $52b0
	sbc b			; $52b1
	inc h			; $52b2
	sbc $52			; $52b3
_label_15_045:
	ld ($ff00+$df),a	; $52b5
	ld b,$c3		; $52b7
	ld d,d			; $52b9
	sbc b			; $52ba
	inc h			; $52bb
	jp c,$def6		; $52bc
	ld b,$02		; $52bf
	ld d,d			; $52c1
	ldh (<hScriptAddressL),a	; $52c2
	inc h			; $52c4
.DB $db				; $52c5
	or $de			; $52c6
	inc (hl)		; $52c8
	nop			; $52c9
	ld d,d			; $52ca
	ldh (<hScriptAddressL),a	; $52cb
	inc h			; $52cd
	call c,$def6		; $52ce
	inc bc			; $52d1
	dec b			; $52d2
	ld d,d			; $52d3
	ldh (<hScriptAddressL),a	; $52d4
	inc h			; $52d6
.DB $dd				; $52d7
	or $e1			; $52d8
	rra			; $52da
	ld d,c			; $52db
	rlca			; $52dc
	sbc b			; $52dd
	nop			; $52de
	dec b			; $52df
	or $00			; $52e0
	ld a,$20		; $52e2
	ld (wLinkStateParameter),a		; $52e4
	xor a			; $52e7
	ld ($d009),a		; $52e8
	ld (w1Link.direction),a		; $52eb
	jr _label_15_046		; $52ee
	ld a,$08		; $52f0
	ld (wLinkStateParameter),a		; $52f2
	ld a,$08		; $52f5
	ld ($d009),a		; $52f7
_label_15_046:
	ld a,$0b		; $52fa
	ld (wLinkForceState),a		; $52fc
	ret			; $52ff
	ld e,$7b		; $5300
	ld a,(de)		; $5302
	ld e,$5d		; $5303
	ld (de),a		; $5305
	ld e,$5c		; $5306
	ld a,$02		; $5308
	ld (de),a		; $530a
	ret			; $530b
	ld bc,$0131		; $530c
	jp showTextNonExitable		; $530f
	pop af			; $5312
	rrc c			; $5313
	ret nc			; $5315
	ld ($5321),sp		; $5316
	adc c			; $5319
	stop			; $531a
	adc e			; $531b
	ld a,(bc)		; $531c
	adc h			; $531d
	ld b,c			; $531e
	ld d,e			; $531f
	inc hl			; $5320
	rst_addAToHl			; $5321
	ld b,c			; $5322
	ld a,($0889)		; $5323
	adc e			; $5326
	jr z,_label_15_045	; $5327
	ld hl,wAItemSpriteXOffset		; $5329
	add hl,bc		; $532c
	ret nc			; $532d
	ld ($5334),sp		; $532e
.DB $ec				; $5331
	ld de,$91f2		; $5332
	ret nc			; $5335
	rst $8			; $5336
	rlca			; $5337
	adc a			; $5338
	nop			; $5339
	or $98			; $533a
	ld bc,$f609		; $533c
	adc e			; $533f
	inc d			; $5340
.DB $ec				; $5341
	jr nz,_label_15_047	; $5342
_label_15_047:
	sbc b			; $5344
	ld bc,$9124		; $5345
	ld ($00d0),sp		; $5348
	push af			; $534b
	xor b			; $534c
	add h			; $534d
	ld (hl),$09		; $534e
	ld hl,sp+$48		; $5350
	adc e			; $5352
	jr z,-$12		; $5353
	ld b,c			; $5355
	or $d4			; $5356
	ld a,b			; $5358
	inc b			; $5359
	adc (hl)		; $535a
	ld d,h			; $535b
	add b			; $535c
	adc (hl)		; $535d
	ld d,l			; $535e
	cp $f0			; $535f
	sbc b			; $5361
	ld bc,$a925		; $5362
	and d			; $5365
	sbc b			; $5366
_label_15_048:
	ld bc,$ab26		; $5367
	and h			; $536a
.DB $ec				; $536b
	ld b,c			; $536c
	nop			; $536d
	push de			; $536e
	ret nc			; $536f
	rst $8			; $5370
	ld bc,$008f		; $5371
	push de			; $5374
	ret nc			; $5375
	rst $8			; $5376
	ld (bc),a		; $5377
	adc a			; $5378
	inc bc			; $5379
	push de			; $537a
	ret nc			; $537b
	rst $8			; $537c
	inc bc			; $537d
	adc a			; $537e
	ld (bc),a		; $537f
	call nc,$0245		; $5380
	sub c			; $5383
	ret nc			; $5384
	rst $8			; $5385
	dec b			; $5386
	adc a			; $5387
	nop			; $5388
	ld a,($ff00+c)		; $5389
	adc (hl)		; $538a
	ld d,h			; $538b
	add b			; $538c
	adc (hl)		; $538d
	ld d,l			; $538e
	cp $f0			; $538f
	sbc b			; $5391
	ld bc,$9125		; $5392
	ret nc			; $5395
	rst $8			; $5396
	ld b,$d5		; $5397
	ret nc			; $5399
	rst $8			; $539a
	ld ($91f9),sp		; $539b
	ld ($01d0),sp		; $539e
	adc e			; $53a1
	jr z,-$14		; $53a2
	ld hl,$0891		; $53a4
	ret nc			; $53a7
	nop			; $53a8
	rst $28			; $53a9
	ld de,$41ec		; $53aa
	nop			; $53ad
.DB $eb				; $53ae
	adc e			; $53af
	jr z,_label_15_048	; $53b0
	inc a			; $53b2
	call $be53		; $53b3
	sbc (hl)		; $53b6
	cp l			; $53b7
	adc d			; $53b8
	or l			; $53b9
	add hl,sp		; $53ba
	ret z			; $53bb
	ld d,e			; $53bc
	sbc b			; $53bd
	ld bc,$8927		; $53be
	jr -$74			; $53c1
	stop			; $53c3
	or (hl)			; $53c4
	add hl,sp		; $53c5
	ld d,e			; $53c6
	or l			; $53c7
	sbc b			; $53c8
	ld bc,$5329		; $53c9
	or l			; $53cc
	pop de			; $53cd
	sub c			; $53ce
	dec c			; $53cf
	ret nc			; $53d0
	ld d,b			; $53d1
	ld hl,sp-$20		; $53d2
	ld ($ff00+c),a		; $53d4
	ld d,d			; $53d5
	rst_addAToHl			; $53d6
	stop			; $53d7
	rlc h			; $53d8
	ret nc			; $53da
	dec bc			; $53db
	sub $53			; $53dc
	sub c			; $53de
	ld ($01d0),sp		; $53df
	ld ($ff00+$f0),a	; $53e2
	ld d,d			; $53e4
	rst_addAToHl			; $53e5
	stop			; $53e6
	rlc h			; $53e7
	ret nc			; $53e9
	dec bc			; $53ea
	push hl			; $53eb
	ld d,e			; $53ec
	sub c			; $53ed
	ld ($00d0),sp		; $53ee
	sub c			; $53f1
	ret nc			; $53f2
	rst $8			; $53f3
	ld bc,w7TextAddressL		; $53f4
	rst $8			; $53f7
	ld (bc),a		; $53f8
	sub l			; $53f9
	nop			; $53fa
	cp $e3			; $53fb
	ld d,e			; $53fd
	ld a,($ff00+$d4)	; $53fe
	ld c,a			; $5400
	nop			; $5401
	sbc b			; $5402
	ld bc,$f628		; $5403
	sbc b			; $5406
	ld b,$03		; $5407
	sub c			; $5409
	ret nc			; $540a
	rst $8			; $540b
	inc bc			; $540c
	push de			; $540d
	ret nc			; $540e
	rst $8			; $540f
	inc b			; $5410
	sub c			; $5411
	ld ($03d0),sp		; $5412
	or $98			; $5415
	ld b,$04		; $5417
	sub c			; $5419
	ret nc			; $541a
	rst $8			; $541b
	dec b			; $541c
	push de			; $541d
	ret nc			; $541e
	rst $8			; $541f
	ld b,$91		; $5420
	ld ($00d0),sp		; $5422
	or $98			; $5425
	ld bc,$912a		; $5427
	ret nc			; $542a
	rst $8			; $542b
	rlca			; $542c
.DB $ec				; $542d
	ld h,b			; $542e
	sub c			; $542f
	ret nc			; $5430
	rst $8			; $5431
	ld ($0091),sp		; $5432
	call $b601		; $5435
	jr c,_label_15_049	; $5438
_label_15_049:
	ld a,$83		; $543a
	call playSound		; $543c
	ld bc,bitTable		; $543f
_label_15_050:
	call getFreePartSlot		; $5442
	ret nz			; $5445
	ld (hl),$26		; $5446
	ld l,$c3		; $5448
	inc (hl)		; $544a
	call objectCopyPositionWithOffset		; $544b
	ld a,c			; $544e
	add $08			; $544f
	ld c,a			; $5451
	cp $18			; $5452
	jr nz,_label_15_050	; $5454
	ret			; $5456
	ld hl,wC60f		; $5457
	add (hl)		; $545a
	ld (hl),a		; $545b
	ret			; $545c
	call func_1765		; $545d
	ld e,$7c		; $5460
	ld (de),a		; $5462
	ret			; $5463
	ld hl,wSelectedTextOption		; $5464
	add (hl)		; $5467
	ld ($c6e3),a		; $5468
	ret			; $546b
	ld a,($c6e3)		; $546c
	or a			; $546f
	jr nz,_label_15_051	; $5470
	ld a,$38		; $5472
	jp playSound		; $5474
_label_15_051:
	ld a,$4a		; $5477
	jp playSound		; $5479
	ld c,$40		; $547c
	jr _label_15_052		; $547e
	ld c,$04		; $5480
_label_15_052:
	ld a,$29		; $5482
	jp addQuestItemToInventory		; $5484
	ld c,a			; $5487
_label_15_053:
	ld a,$28		; $5488
	jp addQuestItemToInventory		; $548a
	push de			; $548d
	pop de			; $548e
	rst $8			; $548f
	dec b			; $5490
_label_15_054:
.DB $e3				; $5491
	cpl			; $5492
	ld hl,sp-$20		; $5493
	add h			; $5495
	ld e,$8b		; $5496
	jr z,_label_15_053	; $5498
	add hl,de		; $549a
	rst_addAToHl			; $549b
	ld h,h			; $549c
	sbc b			; $549d
	dec e			; $549e
	ld bc,$eef6		; $549f
	stop			; $54a2
	pop af			; $54a3
	.db $ed			; $54a4
	stop			; $54a5
	pop af			; $54a6
	xor $10			; $54a7
	pop af			; $54a9
	rst $28			; $54aa
	ld a,(bc)		; $54ab
	ld hl,sp-$68		; $54ac
	dec e			; $54ae
	ld (bc),a		; $54af
	or $98			; $54b0
	inc de			; $54b2
	ld b,$91		; $54b3
	pop de			; $54b5
	rst $8			; $54b6
	ld b,$d5		; $54b7
	pop de			; $54b9
	rst $8			; $54ba
	rlca			; $54bb
	or $8f			; $54bc
	ld b,$fa		; $54be
	pop hl			; $54c0
	xor e			; $54c1
	ldd (hl),a		; $54c2
	inc bc			; $54c3
	pop de			; $54c4
	sub c			; $54c5
	xor (hl)		; $54c6
	rlc h			; $54c7
	sbc b			; $54c9
	dec e			; $54ca
	inc bc			; $54cb
	or $00			; $54cc
	push de			; $54ce
	ret nc			; $54cf
	rst $8			; $54d0
	dec b			; $54d1
	cp l			; $54d2
	ld hl,sp-$68		; $54d3
	dec e			; $54d5
	rlca			; $54d6
	ld hl,sp-$68		; $54d7
	dec e			; $54d9
	add hl,bc		; $54da
	or $91			; $54db
	ret nc			; $54dd
	rst $8			; $54de
	ld b,$8f		; $54df
	inc b			; $54e1
.DB $e3				; $54e2
	ld a,($ff00+$e3)	; $54e3
	xor a			; $54e5
.DB $fc				; $54e6
	push af			; $54e7
	add h			; $54e8
	push bc			; $54e9
	ld (bc),a		; $54ea
	nop			; $54eb
	nop			; $54ec
	and a			; $54ed
	rst_addAToHl			; $54ee
	dec l			; $54ef
	sbc $27			; $54f0
	nop			; $54f2
	adc a			; $54f3
	ld (bc),a		; $54f4
	or $ba			; $54f5
	or $91			; $54f7
	ret nc			; $54f9
	rst $8			; $54fa
	rlca			; $54fb
	nop			; $54fc
	di			; $54fd
	adc a			; $54fe
	ld bc,$148b		; $54ff
	adc c			; $5502
	jr _label_15_054		; $5503
	jr nz,-$2b		; $5505
	dec bc			; $5507
	ret nc			; $5508
	ld l,b			; $5509
	sub c			; $550a
	jp $00cb		; $550b
	cp l			; $550e
	push af			; $550f
	.db $ed			; $5510
	stop			; $5511
	pop hl			; $5512
	ld d,l			; $5513
	ld d,c			; $5514
	inc bc			; $5515
	di			; $5516
	sbc b			; $5517
	dec e			; $5518
	dec bc			; $5519
	push af			; $551a
	sub c			; $551b
	ret nc			; $551c
	rst $8			; $551d
	ld (bc),a		; $551e
	push de			; $551f
	ret nc			; $5520
	rst $8			; $5521
_label_15_055:
	inc bc			; $5522
	pop hl			; $5523
	ld d,l			; $5524
	ld d,c			; $5525
	inc bc			; $5526
	di			; $5527
	sbc b			; $5528
	dec e			; $5529
	inc c			; $552a
	rst $30			; $552b
	sub c			; $552c
	ret nc			; $552d
	rst $8			; $552e
	inc b			; $552f
	rst_addAToHl			; $5530
	stop			; $5531
	adc e			; $5532
	jr z,_label_15_055	; $5533
	stop			; $5535
	rst_addAToHl			; $5536
	ld b,$ee		; $5537
	jr z,_label_15_056	; $5539
_label_15_056:
	rst_addAToHl			; $553b
	inc c			; $553c
	sub c			; $553d
	xor (hl)		; $553e
	rlc h			; $553f
	sbc b			; $5541
	dec e			; $5542
	stop			; $5543
	rst_addAToHl			; $5544
	stop			; $5545
	adc a			; $5546
	rlca			; $5547
	adc (hl)		; $5548
	ld c,b			; $5549
	rlca			; $554a
	pop hl			; $554b
	sbc b			; $554c
	inc c			; $554d
	xor l			; $554e
	rst_addAToHl			; $554f
	jp nc,$d7a8		; $5550
	ld c,e			; $5553
	xor b			; $5554
	adc a			; $5555
	ld (bc),a		; $5556
	adc (hl)		; $5557
	ld c,b			; $5558
	ld (bc),a		; $5559
	rst_addAToHl			; $555a
	stop			; $555b
	sub c			; $555c
	xor (hl)		; $555d
	rlc h			; $555e
	sbc b			; $5560
	dec e			; $5561
	ld de,$c584		; $5562
	nop			; $5565
_label_15_057:
	nop			; $5566
	nop			; $5567
	and a			; $5568
	rst_addAToHl			; $5569
	inc h			; $556a
	sub c			; $556b
	xor (hl)		; $556c
	rlc h			; $556d
	sbc $25			; $556f
	nop			; $5571
	rst_addAToHl			; $5572
	stop			; $5573
	nop			; $5574
	pop de			; $5575
	or $8b			; $5576
	jr z,_label_15_057	; $5578
	ld d,b			; $557a
	rst $28			; $557b
	stop			; $557c
	sub c			; $557d
	ld ($03d0),sp		; $557e
.DB $ec				; $5581
	ldi (hl),a		; $5582
	adc a			; $5583
	ld bc,$98f8		; $5584
	jr -$0a			; $5587
	adc a			; $5589
	ld (bc),a		; $558a
	sub c			; $558b
	ld ($02d0),sp		; $558c
	sub c			; $558f
	or l			; $5590
	rlc c			; $5591
	push de			; $5593
	or l			; $5594
	rlc d			; $5595
	or $91			; $5597
	ld ($03d0),sp		; $5599
	adc a			; $559c
	ld bc,$1998		; $559d
	or $8f			; $55a0
	ld (bc),a		; $55a2
	sub c			; $55a3
	ld ($02d0),sp		; $55a4
	sub c			; $55a7
	or l			; $55a8
	rlc e			; $55a9
	or $91			; $55ab
	or l			; $55ad
	rlc h			; $55ae
	xor $52			; $55b0
	adc (hl)		; $55b2
	ld c,e			; $55b3
	ld ($4d8e),sp		; $55b4
	ld (hl),b		; $55b7
	push de			; $55b8
	or l			; $55b9
	rlc l			; $55ba
	pop de			; $55bc
	xor $70			; $55bd
	sbc b			; $55bf
	ld c,$99		; $55c0
.DB $e4				; $55c2
	ld hl,$1891		; $55c3
	call $91b4		; $55c6
	add hl,de		; $55c9
	call $91b4		; $55ca
	nop			; $55cd
	call $9101		; $55ce
	or l			; $55d1
	rlc (hl)		; $55d2
	push de			; $55d4
	or l			; $55d5
	rlc a			; $55d6
	push af			; $55d8
	add h			; $55d9
	rlca			; $55da
	add b			; $55db
	ld (hl),h		; $55dc
	ld a,b			; $55dd
.DB $e3				; $55de
	add l			; $55df
	adc e			; $55e0
	ld d,b			; $55e1
	xor $18			; $55e2
	nop			; $55e4
	pop de			; $55e5
	ld hl,sp-$71		; $55e6
	ld bc,$e1f3		; $55e8
	ld d,l			; $55eb
	ld d,c			; $55ec
	inc bc			; $55ed
	di			; $55ee
	sbc b			; $55ef
	ld e,$f8		; $55f0
	sbc b			; $55f2
	rra			; $55f3
	or $91			; $55f4
	ret nc			; $55f6
	rst $8			; $55f7
	ld bc,$eb00		; $55f8
	sbc (hl)		; $55fb
	cp l			; $55fc
	di			; $55fd
	adc (hl)		; $55fe
	ld a,c			; $55ff
	ld bc,$a8e0		; $5600
	ld e,h			; $5603
	ld a,($ff00+c)		; $5604
	sbc b			; $5605
	ld hl,$8ff2		; $5606
	ld (bc),a		; $5609
	cp (hl)			; $560a
	push af			; $560b
	adc (hl)		; $560c
	ld a,c			; $560d
	nop			; $560e
	adc a			; $560f
	inc b			; $5610
	ld d,l			; $5611
	ei			; $5612
	ld a,$0f		; $5613
	ld b,a			; $5615
	ld a,(wFrameCounter)		; $5616
	and b			; $5619
	ret nz			; $561a
	ld hl,$7877		; $561b
	ld e,$0a		; $561e
	call interBankCall		; $5620
	call objectGetRelativeAngle		; $5623
	call convertAngleToDirection		; $5626
	ld h,d			; $5629
	ld l,$48		; $562a
	cp (hl)			; $562c
	ret z			; $562d
	ld (hl),a		; $562e
	jp interactionSetAnimation		; $562f
	push de			; $5632
	ld d,$d0		; $5633
	call specialObjectSetAnimation		; $5635
	pop de			; $5638
	ret			; $5639
	call getFreeInteractionSlot		; $563a
	ret nz			; $563d
	ld (hl),$5e		; $563e
	ld l,$57		; $5640
	ld a,d			; $5642
	ld (hl),a		; $5643
	jp objectCopyPosition		; $5644
	call objectGetAngleTowardEnemyTarget		; $5647
	add $04			; $564a
	and $18			; $564c
	swap a			; $564e
	rlca			; $5650
	call interactionSetAnimation		; $5651
	ld a,$1e		; $5654
	ld bc,$f30d		; $5656
	jp objectCreateExclamationMark		; $5659
	ld h,d			; $565c
	ld l,$54		; $565d
	ld (hl),$00		; $565f
	inc hl			; $5661
	ld (hl),$fc		; $5662
	ld a,$53		; $5664
	jp playSound		; $5666
	ld c,$c0		; $5669
	call objectUpdateSpeedZ_paramC		; $566b
	jp $5118		; $566e
	ld a,$03		; $5671
_label_15_058:
	ld (wActiveMusic2),a		; $5673
	ld (wActiveMusic),a		; $5676
	jp playSound		; $5679
	call $5682		; $567c
	jp $5118		; $567f
	ld a,(wCFD8+6)		; $5682
	rst_jumpTable			; $5685
.dw $5690
.dw $569d
.dw $569d
.dw $56ad
.dw $56b8
	ld a,$0a		; $5690
	ld (wCFD8+7),a		; $5692
	call func_2d5f		; $5695
	ld hl,wCFD8+6		; $5698
	inc (hl)		; $569b
	ret			; $569c
	ld hl,wCFD8+7		; $569d
	dec (hl)		; $56a0
	ret nz			; $56a1
	ld a,$0a		; $56a2
	ld (wCFD8+7),a		; $56a4
	call func_3263		; $56a7
	jp $5698		; $56aa
	ld a,$14		; $56ad
	ld (wCFD8+7),a		; $56af
	call func_2d5f		; $56b2
	jp $5698		; $56b5
	ld hl,wCFD8+7		; $56b8
_label_15_059:
	dec (hl)		; $56bb
	ret			; $56bc
	ld b,$01		; $56bd
	jp objectFlickerVisibility		; $56bf
	ld h,d			; $56c2
	ld l,$7f		; $56c3
_label_15_060:
	dec (hl)		; $56c5
	jp $5118		; $56c6
	pop hl			; $56c9
	ldd (hl),a		; $56ca
_label_15_061:
	ld d,(hl)		; $56cb
	nop			; $56cc
	ld a,($2a98)		; $56cd
	ld (bc),a		; $56d0
	or $8b			; $56d1
	dec b			; $56d3
	adc c			; $56d4
	ld ($818c),sp		; $56d5
	adc a			; $56d8
	ld ($98fa),sp		; $56d9
	ldi a,(hl)		; $56dc
	inc bc			; $56dd
	ld a,($098f)		; $56de
_label_15_062:
	di			; $56e1
_label_15_063:
	adc a			; $56e2
	ld a,(bc)		; $56e3
	ld hl,sp-$77		; $56e4
	jr _label_15_058		; $56e6
	dec b			; $56e8
	adc h			; $56e9
	ld b,c			; $56ea
	adc e			; $56eb
_label_15_064:
	ld a,(bc)		; $56ec
	adc h			; $56ed
	dec h			; $56ee
	or $98			; $56ef
	ldi a,(hl)		; $56f1
_label_15_065:
	inc b			; $56f2
	ld a,($d091)		; $56f3
	rst $8			; $56f6
	ld e,$f8		; $56f7
	adc a			; $56f9
	ld (bc),a		; $56fa
	sbc b			; $56fb
	ldi a,(hl)		; $56fc
	dec b			; $56fd
	or $8b			; $56fe
	ld d,b			; $5700
	.db $ed			; $5701
	add hl,de		; $5702
	adc a			; $5703
	ld (bc),a		; $5704
.DB $e3				; $5705
	ld a,b			; $5706
	ld a,($2a98)		; $5707
	ld b,$f6		; $570a
	adc e			; $570c
	ld a,b			; $570d
	xor $28			; $570e
	ld hl,sp-$6f		; $5710
	ret nc			; $5712
	rst $8			; $5713
	jr nz,_label_15_066	; $5714
_label_15_066:
	rst_addAToHl			; $5716
	ld b,$8f		; $5717
	ld (bc),a		; $5719
	di			; $571a
	sbc b			; $571b
	ldi a,(hl)		; $571c
	dec bc			; $571d
	push af			; $571e
	adc a			; $571f
	nop			; $5720
	push af			; $5721
	sbc b			; $5722
	ldi a,(hl)		; $5723
	ld b,$f3		; $5724
	adc e			; $5726
	ld d,b			; $5727
.DB $ec				; $5728
	ld b,h			; $5729
.DB $e3				; $572a
	ld a,($b1f6)		; $572b
	ld b,b			; $572e
	cp (hl)			; $572f
	nop			; $5730
	ld sp,hl		; $5731
.DB $e4				; $5732
	dec (hl)		; $5733
	xor b			; $5734
	adc e			; $5735
_label_15_067:
	ld d,b			; $5736
	rst $28			; $5737
	jr nc,_label_15_059	; $5738
	rst $38			; $573a
	adc e			; $573b
	jr z,-$11		; $573c
	jr nz,_label_15_061	; $573e
	inc d			; $5740
	rst $28			; $5741
	jr nz,_label_15_060	; $5742
	rst $38			; $5744
	or $8b			; $5745
	jr z,_label_15_067	; $5747
	jr nc,_label_15_062	; $5749
	nop			; $574b
	sbc b			; $574c
	ldi a,(hl)		; $574d
	ld a,(de)		; $574e
	or $8b			; $574f
_label_15_068:
	ld d,b			; $5751
	add c			; $5752
	nop			; $5753
	.db $ed			; $5754
	jr c,_label_15_070	; $5755
	ld (hl),a		; $5757
	ld sp,hl		; $5758
.DB $e4				; $5759
	dec (hl)		; $575a
	xor b			; $575b
	adc e			; $575c
	ld d,b			; $575d
.DB $ec				; $575e
	jr _label_15_063		; $575f
	rst $38			; $5761
	adc e			; $5762
	jr z,_label_15_068	; $5763
	jr nz,_label_15_065	; $5765
_label_15_069:
	inc d			; $5767
.DB $ec				; $5768
	jr nz,_label_15_064	; $5769
	rst $38			; $576b
	or $98			; $576c
	ldi a,(hl)		; $576e
	jr nz,_label_15_069	; $576f
	adc e			; $5771
	ld d,b			; $5772
	add c			; $5773
	nop			; $5774
	xor $38			; $5775
	or c			; $5777
	ld b,b			; $5778
	or $e4			; $5779
	rst $38			; $577b
	cp (hl)			; $577c
	nop			; $577d
.DB $eb				; $577e
	or b			; $577f
	ld b,b			; $5780
	ld sp,hl		; $5781
	ld d,a			; $5782
	cp l			; $5783
	add h			; $5784
	ld c,l			; $5785
	dec b			; $5786
	inc a			; $5787
	ld a,b			; $5788
.DB $e4				; $5789
	ld hl,$e3f8		; $578a
	xor e			; $578d
	adc a			; $578e
	inc b			; $578f
	ld hl,sp-$75		; $5790
	inc d			; $5792
	adc c			; $5793
	stop			; $5794
	xor b			; $5795
	adc h			; $5796
	ld de,$8cf5		; $5797
	ld de,$8cf5		; $579a
	ld de,$98f7		; $579d
	inc de			; $57a0
	inc de			; $57a1
	or $8b			; $57a2
	ld d,b			; $57a4
	ld ($ff00+$5c),a	; $57a5
	ld d,(hl)		; $57a7
	ld ($ff00+R_NR33),a	; $57a8
	jr nz,-$20		; $57aa
	ld l,c			; $57ac
	ld d,(hl)		; $57ad
_label_15_070:
	rst_jumpTable			; $57ae
.DB $db				; $57af
	call $b680		; $57b0
	ld d,a			; $57b3
	ld d,a			; $57b4
	xor b			; $57b5
	push af			; $57b6
	sbc b			; $57b7
	ldi a,(hl)		; $57b8
	dec de			; $57b9
	or $8b			; $57ba
	ld d,b			; $57bc
	adc c			; $57bd
	nop			; $57be
.DB $e3				; $57bf
	cp e			; $57c0
	adc h			; $57c1
	dec c			; $57c2
.DB $e3				; $57c3
	jp nc,$e0a9		; $57c4
	ld a,h			; $57c7
	ld d,(hl)		; $57c8
	rst_jumpTable			; $57c9
.DB $db				; $57ca
	call $d180		; $57cb
	ld d,a			; $57ce
	ld d,a			; $57cf
	add $88			; $57d0
	ld e,b			; $57d2
	ld h,b			; $57d3
	adc a			; $57d4
	inc c			; $57d5
	pop hl			; $57d6
	add h			; $57d7
	ldd (hl),a		; $57d8
	inc b			; $57d9
	pop de			; $57da
	or $98			; $57db
	inc de			; $57dd
	inc d			; $57de
	or $aa			; $57df
	or c			; $57e1
	ld b,b			; $57e2
	and e			; $57e3
.DB $e4				; $57e4
	rst $38			; $57e5
	cp (hl)			; $57e6
	sbc (hl)		; $57e7
	adc a			; $57e8
	inc c			; $57e9
	ld ($ff00+$a8),a	; $57ea
	ld e,h			; $57ec
	sbc b			; $57ed
	ldi a,(hl)		; $57ee
	inc e			; $57ef
	or $8f			; $57f0
	inc c			; $57f2
	sbc (hl)		; $57f3
	sbc b			; $57f4
	ldi a,(hl)		; $57f5
	dec e			; $57f6
	ld d,a			; $57f7
	di			; $57f8
	adc b			; $57f9
	ld e,b			; $57fa
	ld h,b			; $57fb
	adc a			; $57fc
	inc c			; $57fd
	ld d,a			; $57fe
	di			; $57ff
	ld b,$00		; $5800
	ld a,GLOBALFLAG_FINISHEDGAME		; $5802
	call checkGlobalFlag		; $5804
	jr z,_label_15_071	; $5807
	ld b,$05		; $5809
_label_15_071:
	call getRandomNumber		; $580b
	and $03			; $580e
	add b			; $5810
	add $08			; $5811
	ld e,$72		; $5813
	ld (de),a		; $5815
	ret			; $5816
	ld h,d			; $5817
	ld l,$4b		; $5818
	ld a,(w1Link.yh)		; $581a
	cp (hl)			; $581d
	ld a,$06		; $581e
	jr nc,_label_15_072	; $5820
	dec a			; $5822
_label_15_072:
	jp interactionSetAnimation		; $5823
	ld e,$7a		; $5826
	ld a,(de)		; $5828
	jp interactionSetAnimation		; $5829
	ld hl,w1Link.yh		; $582c
	ld e,$79		; $582f
	ld a,(de)		; $5831
	ld (hl),a		; $5832
	ret			; $5833
	call getFreeInteractionSlot		; $5834
	ret nz			; $5837
	ld (hl),$63		; $5838
	inc l			; $583a
	ld (hl),$3f		; $583b
	inc l			; $583d
	ld (hl),$01		; $583e
	ld l,$56		; $5840
	ld (hl),$40		; $5842
	inc l			; $5844
	ld (hl),d		; $5845
	ret			; $5846
	ld bc,$9500		; $5847
	call objectCreateInteraction		; $584a
	ret nz			; $584d
	ld bc,$4a3c		; $584e
	jp interactionHSetPosition		; $5851
	ld bc,$f300		; $5854
	jp objectCreateExclamationMark		; $5857
	ld hl,$5d87		; $585a
	ld e,$08		; $585d
	jp interBankCall		; $585f
	ld h,d			; $5862
	ld l,$60		; $5863
	ld (hl),$01		; $5865
	ld l,$78		; $5867
	dec (hl)		; $5869
	ld ($cfd3),a		; $586a
	jp interactionUpdateAnimCounter		; $586d
	ld b,a			; $5870
	call getFreePartSlot		; $5871
	ret nz			; $5874
	ld (hl),$27		; $5875
	inc l			; $5877
	inc (hl)		; $5878
	inc l			; $5879
	inc (hl)		; $587a
	ld a,b			; $587b
	or a			; $587c
	ld bc,$4838		; $587d
	jr z,_label_15_073	; $5880
	ld bc,$2878		; $5882
_label_15_073:
	ld l,$cb		; $5885
	ld (hl),b		; $5887
	ld l,$cd		; $5888
	ld (hl),c		; $588a
	ret			; $588b
	ld h,d			; $588c
	ld l,$7f		; $588d
	dec (hl)		; $588f
	ret nz			; $5890
	ld l,$7e		; $5891
	ld a,(hl)		; $5893
	cp $14			; $5894
	call $5118		; $5896
	ret z			; $5899
	ld a,(hl)		; $589a
	inc (hl)		; $589b
	ld hl,$58a9		; $589c
	rst_addDoubleIndex			; $589f
	ldi a,(hl)		; $58a0
	ld ($cc50),a		; $58a1
	ld a,(hl)		; $58a4
	ld e,$7f		; $58a5
	ld (de),a		; $58a7
	ret			; $58a8
	ld ($0914),sp		; $58a9
	inc d			; $58ac
	ld ($0914),sp		; $58ad
	inc d			; $58b0
	rlca			; $58b1
	inc d			; $58b2
	ld c,$14		; $58b3
	ld b,$14		; $58b5
	inc e			; $58b7
	inc d			; $58b8
	ld ($0914),sp		; $58b9
	inc d			; $58bc
	ld ($0814),sp		; $58bd
	jr z,_label_15_074	; $58c0
	ldd (hl),a		; $58c2
	rlca			; $58c3
	inc d			; $58c4
	ld c,$14		; $58c5
	ld b,$14		; $58c7
	inc e			; $58c9
	inc d			; $58ca
_label_15_074:
	ld ($0914),sp		; $58cb
	inc d			; $58ce
	ld ($0914),sp		; $58cf
	inc d			; $58d2
.DB $eb				; $58d3
	push de			; $58d4
	ld (bc),a		; $58d5
	call z,$e000		; $58d6
	ld hl,sp+$32		; $58d9
	pop de			; $58db
	sbc (hl)		; $58dc
	cp l			; $58dd
	or b			; $58de
	jr nz,_label_15_076	; $58df
	ld e,c			; $58e1
	ret z			; $58e2
	ld ($58ec),sp		; $58e3
	sbc b			; $58e6
	dec h			; $58e7
	rla			; $58e8
	cp (hl)			; $58e9
	ld e,b			; $58ea
	call c,$2598		; $58eb
	dec d			; $58ee
	or $c3			; $58ef
	nop			; $58f1
	or $58			; $58f2
	ld e,b			; $58f4
	and $8e			; $58f5
_label_15_075:
	ld a,l			; $58f7
	ld bc,$b1e1		; $58f8
	ld l,e			; $58fb
	ld (bc),a		; $58fc
	ld a,($ff00+$d5)	; $58fd
	ld bc,$00d0		; $58ff
	adc (hl)		; $5902
	ld a,l			; $5903
	nop			; $5904
	pop hl			; $5905
	halt			; $5906
	ld d,c			; $5907
	ld (bc),a		; $5908
	rst $30			; $5909
.DB $e4				; $590a
	ld sp,$e0fa		; $590b
	adc h			; $590e
	ld e,b			; $590f
	rst_jumpTable			; $5910
.DB $db				; $5911
	call $1880		; $5912
	ld e,c			; $5915
_label_15_076:
	ld e,c			; $5916
	dec c			; $5917
	ld ($ff00+$b2),a	; $5918
	inc c			; $591a
	rst $30			; $591b
.DB $e3				; $591c
	xor e			; $591d
	sub c			; $591e
	ld d,b			; $591f
	call z,$fa0f		; $5920
	pop hl			; $5923
	halt			; $5924
	ld d,c			; $5925
	nop			; $5926
	or $98			; $5927
	dec h			; $5929
	ld d,$f6		; $592a
	sbc $41			; $592c
	ld ($e4f6),sp		; $592e
	rst $38			; $5931
	cp (hl)			; $5932
	ld e,b			; $5933
	call c,$2598		; $5934
	jr _label_15_075		; $5937
	ld e,b			; $5939
	call c,$2e62		; $593a
	ld a,b			; $593d
	dec (hl)		; $593e
	ret z			; $593f
	call objectApplySpeed		; $5940
	jp objectApplySpeed		; $5943
	ld hl,sp-$6f		; $5946
	ret nc			; $5948
	rst $8			; $5949
	ld de,$8bfa		; $594a
	ld d,b			; $594d
	adc c			; $594e
	inc e			; $594f
.DB $e3				; $5950
	ld l,e			; $5951
	adc (hl)		; $5952
	ld a,b			; $5953
	ld de,$3be0		; $5954
	ld e,c			; $5957
	ld a,($ff00+$cc)	; $5958
_label_15_077:
	ld a,b			; $595a
	nop			; $595b
	ld h,b			; $595c
	ld e,c			; $595d
	ld e,c			; $595e
	ld d,l			; $595f
	ld a,($ff00+c)		; $5960
	adc c			; $5961
	dec bc			; $5962
.DB $e3				; $5963
	ld l,e			; $5964
	adc (hl)		; $5965
	ld a,b			; $5966
	dec h			; $5967
	ld ($ff00+$3b),a	; $5968
	ld e,c			; $596a
	ld a,($ff00+$cc)	; $596b
	ld a,b			; $596d
	nop			; $596e
	ld (hl),e		; $596f
	ld e,c			; $5970
	ld e,c			; $5971
	ld l,b			; $5972
	ld a,($ff00+c)		; $5973
	adc c			; $5974
	jr _label_15_077		; $5975
	ld l,e			; $5977
	adc (hl)		; $5978
	ld a,b			; $5979
	inc de			; $597a
	ld ($ff00+$3b),a	; $597b
	ld e,c			; $597d
	ld a,($ff00+$cc)	; $597e
	ld a,b			; $5980
	nop			; $5981
	add (hl)		; $5982
	ld e,c			; $5983
	ld e,c			; $5984
	ld a,e			; $5985
	ld a,($ff00+c)		; $5986
	adc c			; $5987
	ld (bc),a		; $5988
.DB $e3				; $5989
	ld l,e			; $598a
	adc (hl)		; $598b
	ld a,b			; $598c
	add hl,de		; $598d
	ld ($ff00+$3b),a	; $598e
	ld e,c			; $5990
	ld a,($ff00+$cc)	; $5991
	ld a,b			; $5993
	nop			; $5994
	sbc c			; $5995
	ld e,c			; $5996
	ld e,c			; $5997
	adc (hl)		; $5998
	ld a,($ff00+c)		; $5999
	adc c			; $599a
	ld a,(bc)		; $599b
.DB $e3				; $599c
	ld l,e			; $599d
	adc (hl)		; $599e
	ld a,b			; $599f
	inc c			; $59a0
	ld ($ff00+$3b),a	; $59a1
	ld e,c			; $59a3
	ld a,($ff00+$cc)	; $59a4
	ld a,b			; $59a6
	nop			; $59a7
	xor h			; $59a8
	ld e,c			; $59a9
	ld e,c			; $59aa
	and c			; $59ab
	ld a,($ff00+c)		; $59ac
	adc c			; $59ad
	inc d			; $59ae
.DB $e3				; $59af
	ld l,e			; $59b0
	adc (hl)		; $59b1
	ld a,b			; $59b2
	ld de,$3be0		; $59b3
	ld e,c			; $59b6
	ld a,($ff00+$cc)	; $59b7
	ld a,b			; $59b9
	nop			; $59ba
	cp a			; $59bb
	ld e,c			; $59bc
	ld e,c			; $59bd
	or h			; $59be
	or $91			; $59bf
	pop de			; $59c1
	rst $8			; $59c2
	ld bc,$8bf6		; $59c3
	inc d			; $59c6
	adc c			; $59c7
	dec bc			; $59c8
	adc h			; $59c9
	ld d,b			; $59ca
	or $98			; $59cb
	ld d,(hl)		; $59cd
	ld (bc),a		; $59ce
	or $91			; $59cf
	ret nc			; $59d1
	rst $8			; $59d2
	ld (de),a		; $59d3
	ld a,(vblankFunctionOffset4)		; $59d4
	adc c			; $59d7
	stop			; $59d8
	adc h			; $59d9
	add hl,hl		; $59da
	ld hl,sp-$72		; $59db
	ld c,l			; $59dd
	ld a,b			; $59de
.DB $e3				; $59df
	ld l,e			; $59e0
	adc e			; $59e1
	ld a,b			; $59e2
	adc c			; $59e3
	nop			; $59e4
	sub c			; $59e5
	ret nc			; $59e6
	rst $8			; $59e7
	inc de			; $59e8
	adc h			; $59e9
	ldi (hl),a		; $59ea
.DB $e3				; $59eb
	ld (hl),e		; $59ec
	sub c			; $59ed
	ret nc			; $59ee
	rst $8			; $59ef
	inc d			; $59f0
	ld hl,sp+$00		; $59f1
	or a			; $59f3
	jr nz,_label_15_079	; $59f4
	ld a,(w1Link.xh)		; $59f6
	ld b,$60		; $59f9
	sub $50			; $59fb
	jr nc,_label_15_078	; $59fd
	cpl			; $59ff
	inc a			; $5a00
	ld b,$50		; $5a01
_label_15_078:
	ld c,a			; $5a03
	push de			; $5a04
	ld hl,$51e8		; $5a05
	ld a,$09		; $5a08
	call setSimulatedInputAddress		; $5a0a
	pop de			; $5a0d
	ld a,c			; $5a0e
	rra			; $5a0f
	add c			; $5a10
	ld (wSimulatedInputCounter),a		; $5a11
	ld a,b			; $5a14
	ld (wSimulatedInputValue),a		; $5a15
	xor a			; $5a18
	ld (wDisabledObjects),a		; $5a19
	ret			; $5a1c
_label_15_079:
	push de			; $5a1d
	ld hl,$51ed		; $5a1e
	ld a,$09		; $5a21
	call setSimulatedInputAddress		; $5a23
	pop de			; $5a26
	ret			; $5a27
	ld a,$24		; $5a28
	ld c,$00		; $5a2a
	jp addQuestItemToInventory		; $5a2c
	jpab bank1.func_5945		; $5a2f
	call getRandomNumber		; $5a37
	and $03			; $5a3a
	ld hl,$5a49		; $5a3c
	rst_addAToHl			; $5a3f
	ld a,(hl)		; $5a40
	ld e,$72		; $5a41
	ld (de),a		; $5a43
	ld a,$59		; $5a44
	inc e			; $5a46
	ld (de),a		; $5a47
	ret			; $5a48
	dec c			; $5a49
	ld c,$0f		; $5a4a
	dec c			; $5a4c
	ld e,$43		; $5a4d
	ld a,(de)		; $5a4f
	ld hl,$5a5d		; $5a50
	rst_addAToHl			; $5a53
	ld a,(hl)		; $5a54
	ld e,$72		; $5a55
	ld (de),a		; $5a57
	ld a,$59		; $5a58
	inc e			; $5a5a
	ld (de),a		; $5a5b
	ret			; $5a5c
	ld (de),a		; $5a5d
	inc de			; $5a5e
	ld de,$1310		; $5a5f
	ld de,$1314		; $5a62
	dec d			; $5a65
	inc de			; $5a66
	ld (de),a		; $5a67
	dec d			; $5a68
	inc de			; $5a69
	inc de			; $5a6a
	ld (de),a		; $5a6b
	inc d			; $5a6c
	or l			; $5a6d
	dec bc			; $5a6e
	ld a,b			; $5a6f
	ld e,d			; $5a70
	rst_addDoubleIndex			; $5a71
	inc h			; $5a72
	ld a,e			; $5a73
	ld e,d			; $5a74
	sub a			; $5a75
	ld e,c			; $5a76
	inc bc			; $5a77
	sub a			; $5a78
	ld e,c			; $5a79
	add hl,bc		; $5a7a
	cp l			; $5a7b
	pop hl			; $5a7c
	ld d,l			; $5a7d
	ld d,c			; $5a7e
	nop			; $5a7f
	pop de			; $5a80
	ld hl,sp-$4a		; $5a81
	stop			; $5a83
	sbc b			; $5a84
	ld e,c			; $5a85
	inc b			; $5a86
	or $8f			; $5a87
	nop			; $5a89
	adc e			; $5a8a
	jr z,-$34		; $5a8b
	ld c,l			; $5a8d
	ld c,b			; $5a8e
	sub l			; $5a8f
	ld e,d			; $5a90
	adc c			; $5a91
	inc e			; $5a92
	ld e,d			; $5a93
	sub a			; $5a94
	adc c			; $5a95
	inc b			; $5a96
	pop hl			; $5a97
	di			; $5a98
	ld e,c			; $5a99
	nop			; $5a9a
	adc h			; $5a9b
	dec bc			; $5a9c
	adc c			; $5a9d
	nop			; $5a9e
	adc h			; $5a9f
	add b			; $5aa0
	nop			; $5aa1
	push de			; $5aa2
	dec bc			; $5aa3
	ret nc			; $5aa4
	ldi a,(hl)		; $5aa5
	ld ($ff00+R_BGPD),a	; $5aa6
	ld e,$e0		; $5aa8
	ld b,e			; $5aaa
	inc l			; $5aab
	sub c			; $5aac
	adc d			; $5aad
	call z,$bb01		; $5aae
	or $8b			; $5ab1
	ld e,$ed		; $5ab3
	ld c,e			; $5ab5
	rst_addAToHl			; $5ab6
	ld b,$8f		; $5ab7
	nop			; $5ab9
	push af			; $5aba
	pop hl			; $5abb
	ld d,h			; $5abc
	ld e,b			; $5abd
	jr z,-$08		; $5abe
	adc e			; $5ac0
	inc a			; $5ac1
.DB $ec				; $5ac2
	ld e,$f6		; $5ac3
	sbc b			; $5ac5
	ld e,c			; $5ac6
	dec bc			; $5ac7
	or $b1			; $5ac8
	ld b,b			; $5aca
	nop			; $5acb
	call getThisRoomFlags		; $5acc
	res 6,(hl)		; $5acf
	ret			; $5ad1
	call getThisRoomFlags		; $5ad2
	res 7,(hl)		; $5ad5
	ret			; $5ad7
	ld h,d			; $5ad8
	ld a,($c6ea)		; $5ad9
	cp $04			; $5adc
	jr nz,_label_15_080	; $5ade
	call getRandomNumber		; $5ae0
	and $07			; $5ae3
	ld a,$04		; $5ae5
	jr nz,_label_15_080	; $5ae7
	inc a			; $5ae9
_label_15_080:
	ld (wCFD8+5),a		; $5aea
	ld a,(wCFD8+5)		; $5aed
	ld bc,$5b04		; $5af0
	call addAToBc		; $5af3
	ld a,(bc)		; $5af6
	ld h,d			; $5af7
	ld l,$43		; $5af8
	ld (hl),a		; $5afa
	ld a,$04		; $5afb
	call func_1765		; $5afd
	ld e,$7d		; $5b00
	ld (de),a		; $5b02
	ret			; $5b03
	ld a,$2b		; $5b04
	inc l			; $5b06
	dec c			; $5b07
	dec l			; $5b08
	ld c,$cd		; $5b09
	ld l,$26		; $5b0b
	xor a			; $5b0d
	ld e,$7b		; $5b0e
	ld (de),a		; $5b10
	call getFreeInteractionSlot		; $5b11
	ret nz			; $5b14
	ld (hl),$63		; $5b15
	inc l			; $5b17
	ld e,$43		; $5b18
	ld a,(de)		; $5b1a
	ld (hl),a		; $5b1b
	ld l,$56		; $5b1c
	ld (hl),$40		; $5b1e
	inc l			; $5b20
	ld (hl),d		; $5b21
	ret			; $5b22
	ld a,$81		; $5b23
	ld (wLinkInAir),a		; $5b25
	ld hl,$d014		; $5b28
	ld (hl),$00		; $5b2b
	inc l			; $5b2d
	ld (hl),$fe		; $5b2e
	ld a,$53		; $5b30
	jp playSound		; $5b32
	ld b,$01		; $5b35
	ld c,$01		; $5b37
	ld a,(wShieldLevel)		; $5b39
	cp $02			; $5b3c
	jr c,_label_15_081	; $5b3e
	inc c			; $5b40
_label_15_081:
	call createTreasure		; $5b41
	ret nz			; $5b44
	ld de,w1Link.yh		; $5b45
	jp objectCopyPosition_rawAddress		; $5b48
	call getFreeInteractionSlot		; $5b4b
	ret nz			; $5b4e
	ld (hl),$60		; $5b4f
	inc l			; $5b51
	ld e,$43		; $5b52
	ld a,(de)		; $5b54
	ldi (hl),a		; $5b55
	dec e			; $5b56
	ld b,$06		; $5b57
	ld a,(de)		; $5b59
	cp $06			; $5b5a
	jr z,_label_15_082	; $5b5c
	ld b,$01		; $5b5e
_label_15_082:
	ld (hl),b		; $5b60
	cp $0a			; $5b61
	jr nz,_label_15_083	; $5b63
	ld a,$24		; $5b65
	call addQuestItemToInventory		; $5b67
	call func_180c		; $5b6a
	push hl			; $5b6d
	ld hl,$c6b4		; $5b6e
	dec (hl)		; $5b71
	pop hl			; $5b72
_label_15_083:
	ld e,$46		; $5b73
	ld a,$03		; $5b75
	ld (de),a		; $5b77
	ld de,w1Link.yh		; $5b78
	jp objectCopyPosition_rawAddress		; $5b7b
	ld a,(wCFD8+5)		; $5b7e
	cp $05			; $5b81
	jr z,_label_15_084	; $5b83
	call getFreeInteractionSlot		; $5b85
	ret nz			; $5b88
	ld (hl),$60		; $5b89
	inc l			; $5b8b
	ld a,($c6ea)		; $5b8c
	ld bc,$5bbb		; $5b8f
	call addDoubleIndexToBc		; $5b92
	ld a,(bc)		; $5b95
	ldi (hl),a		; $5b96
	inc bc			; $5b97
	ld a,(bc)		; $5b98
	ld (hl),a		; $5b99
	ld e,$46		; $5b9a
	ld a,$03		; $5b9c
	ld (de),a		; $5b9e
	ld de,w1Link.yh		; $5b9f
	call objectCopyPosition_rawAddress		; $5ba2
	jr _label_15_085		; $5ba5
_label_15_084:
	ld c,$02		; $5ba7
	call getRandomRingOfGivenTier		; $5ba9
	ld b,c			; $5bac
	ld c,$00		; $5bad
	call giveRingToLink		; $5baf
_label_15_085:
	ld hl,$c6ea		; $5bb2
	ld a,(hl)		; $5bb5
	cp $04			; $5bb6
	ret z			; $5bb8
	inc (hl)		; $5bb9
	ret			; $5bba
	ld c,l			; $5bbb
	nop			; $5bbc
	jr z,$0e		; $5bbd
	jr z,_label_15_086	; $5bbf
	inc (hl)		; $5bc1
	nop			; $5bc2
	jr z,_label_15_087	; $5bc3
	ld e,$7f		; $5bc5
	xor a			; $5bc7
	ld (de),a		; $5bc8
	ld c,$81		; $5bc9
	call objectFindSameTypeObjectWithID		; $5bcb
	ret nz			; $5bce
	ld (de),a		; $5bcf
_label_15_086:
	ret			; $5bd0
	xor a			; $5bd1
	ld e,$7f		; $5bd2
	ld (de),a		; $5bd4
_label_15_087:
	ld a,$20		; $5bd5
	call checkQuestItemObtained		; $5bd7
	ret nc			; $5bda
	or a			; $5bdb
	ret z			; $5bdc
	ld (de),a		; $5bdd
	ret			; $5bde
	ld a,$ff		; $5bdf
	ld (wStatusBarNeedsRefresh),a		; $5be1
	ld a,(wNumEmberSeeds)		; $5be4
	sub $01			; $5be7
	daa			; $5be9
	ld (wNumEmberSeeds),a		; $5bea
	ret			; $5bed
	call objectGetLinkRelativeAngle		; $5bee
	ld e,$49		; $5bf1
	add $04			; $5bf3
	and $18			; $5bf5
	ld (de),a		; $5bf7
_label_15_088:
	call convertAngleDeToDirection		; $5bf8
	jp interactionSetAnimation		; $5bfb
	ld e,$49		; $5bfe
	ld a,(de)		; $5c00
	xor $10			; $5c01
	ld (de),a		; $5c03
	jr _label_15_088		; $5c04
	call getThisRoomFlags		; $5c06
	set 7,(hl)		; $5c09
	dec h			; $5c0b
	set 7,(hl)		; $5c0c
	ld a,$4d		; $5c0e
	jp removeQuestItemFromInventory		; $5c10
	ld hl,wC6b1		; $5c13
	ld a,(hl)		; $5c16
	add $20			; $5c17
	ldd (hl),a		; $5c19
	ld (hl),a		; $5c1a
	jp setStatusBarNeedsRefreshBit1		; $5c1b
	ld bc,$f3f3		; $5c1e
	ld a,$1e		; $5c21
	jp objectCreateExclamationMark		; $5c23
.DB $eb				; $5c26
	sbc (hl)		; $5c27
	cp l			; $5c28
	or b			; $5c29
	ld b,b			; $5c2a
	dec sp			; $5c2b
	ld e,h			; $5c2c
	sbc b			; $5c2d
	ld l,b			; $5c2e
	or $8f			; $5c2f
	ld (bc),a		; $5c31
	adc (hl)		; $5c32
	ld a,e			; $5c33
	ld bc,$35e0		; $5c34
	ld e,e			; $5c37
	or c			; $5c38
	ld b,b			; $5c39
	or $98			; $5c3a
	ld l,c			; $5c3c
	cp (hl)			; $5c3d
	ld e,h			; $5c3e
	daa			; $5c3f
.DB $eb				; $5c40
	cp (hl)			; $5c41
	adc a			; $5c42
	ld (bc),a		; $5c43
	sbc (hl)		; $5c44
	cp l			; $5c45
	adc d			; $5c46
	or b			; $5c47
	ld b,b			; $5c48
	ld h,d			; $5c49
	ld e,h			; $5c4a
	or c			; $5c4b
	ld b,b			; $5c4c
	adc (hl)		; $5c4d
	ld (hl),c		; $5c4e
	nop			; $5c4f
	sub c			; $5c50
	ld ($03d0),sp		; $5c51
	ld ($ff00+R_NR34),a	; $5c54
	ld e,h			; $5c56
	adc (hl)		; $5c57
	ld d,h			; $5c58
	nop			; $5c59
	adc (hl)		; $5c5a
	ld d,h			; $5c5b
	rst $38			; $5c5c
	or $98			; $5c5d
	ld l,d			; $5c5f
	ld e,h			; $5c60
	ld b,c			; $5c61
	sbc b			; $5c62
	ld l,e			; $5c63
	ld e,h			; $5c64
	ld b,c			; $5c65
.DB $eb				; $5c66
	sbc (hl)		; $5c67
	cp l			; $5c68
	or b			; $5c69
	jr nz,-$5d		; $5c6a
	ld e,h			; $5c6c
	sbc b			; $5c6d
	nop			; $5c6e
	or $c8			; $5c6f
	inc bc			; $5c71
	ld a,c			; $5c72
	ld e,h			; $5c73
	sbc b			; $5c74
	add hl,bc		; $5c75
	cp (hl)			; $5c76
	ld e,h			; $5c77
	ld h,a			; $5c78
	sbc b			; $5c79
	ld bc,$c3f6		; $5c7a
	nop			; $5c7d
	add l			; $5c7e
	ld e,h			; $5c7f
	sbc b			; $5c80
	ld ($5cbe),sp		; $5c81
	ld h,a			; $5c84
	sbc b			; $5c85
	ld (bc),a		; $5c86
	or $98			; $5c87
	inc bc			; $5c89
	or $98			; $5c8a
	inc b			; $5c8c
	or $8e			; $5c8d
	ld a,a			; $5c8f
	ld bc,$0598		; $5c90
	call nc,$007e		; $5c93
	adc (hl)		; $5c96
	ld a,a			; $5c97
	nop			; $5c98
	rst $30			; $5c99
	sbc b			; $5c9a
_label_15_089:
	ld b,$f6		; $5c9b
	sbc $41			; $5c9d
	inc bc			; $5c9f
	cp (hl)			; $5ca0
	ld e,h			; $5ca1
	ld h,a			; $5ca2
	sbc b			; $5ca3
	rlca			; $5ca4
	cp (hl)			; $5ca5
	ld e,h			; $5ca6
	ld h,a			; $5ca7
	call objectGetLinkRelativeAngle		; $5ca8
	call convertAngleToDirection		; $5cab
	jp interactionSetAnimation		; $5cae
	ld b,$01		; $5cb1
	jp objectFlickerVisibility		; $5cb3
	ld h,d			; $5cb6
	ld l,$7f		; $5cb7
	dec (hl)		; $5cb9
	jp $5118		; $5cba
_label_15_090:
	ld e,$4f		; $5cbd
	ld a,(de)		; $5cbf
	sub $04			; $5cc0
	ld (de),a		; $5cc2
	cp $c0			; $5cc3
	jp $5118		; $5cc5
	or b			; $5cc8
	jr nz,_label_15_089	; $5cc9
	ld e,h			; $5ccb
	adc a			; $5ccc
	nop			; $5ccd
	ld e,h			; $5cce
	jp nc,$018f		; $5ccf
.DB $eb				; $5cd2
	sbc (hl)		; $5cd3
	cp l			; $5cd4
_label_15_091:
	or b			; $5cd5
	jr nz,_label_15_093	; $5cd6
	ld e,l			; $5cd8
	sbc b			; $5cd9
	dec e			; $5cda
	or $98			; $5cdb
	jr nz,_label_15_091	; $5cdd
	ret z			; $5cdf
	ld b,$e6		; $5ce0
_label_15_092:
	ld e,h			; $5ce2
	cp (hl)			; $5ce3
	ld e,h			; $5ce4
.DB $d3				; $5ce5
	sbc b			; $5ce6
_label_15_093:
	ld e,$f6		; $5ce7
	sbc b			; $5ce9
	jr nz,_label_15_092	; $5cea
	sbc b			; $5cec
	rra			; $5ced
	or $98			; $5cee
	jr nz,-$0a		; $5cf0
	sbc b			; $5cf2
	jr nz,-$0a		; $5cf3
	sbc b			; $5cf5
	ld hl,$c3f6		; $5cf6
	nop			; $5cf9
	ld bc,$985d		; $5cfa
_label_15_094:
	jr nz,_label_15_090	; $5cfd
	ld e,h			; $5cff
.DB $d3				; $5d00
	sbc b			; $5d01
	ldi (hl),a		; $5d02
	or $98			; $5d03
	jr nz,_label_15_094	; $5d05
	sbc b			; $5d07
	inc hl			; $5d08
	or $8f			; $5d09
	ld bc,$41de		; $5d0b
	ld b,$98		; $5d0e
	inc h			; $5d10
	or $be			; $5d11
	ld e,h			; $5d13
.DB $d3				; $5d14
	ld a,$01		; $5d15
	call checkQuestItemObtained		; $5d17
	jr c,_label_15_095	; $5d1a
	ld a,(wShieldLevel)		; $5d1c
_label_15_095:
	cp $03			; $5d1f
	jr c,_label_15_096	; $5d21
	ld a,$02		; $5d23
_label_15_096:
	ld c,a			; $5d25
	call getFreeInteractionSlot		; $5d26
	ret nz			; $5d29
	ld (hl),$60		; $5d2a
	inc l			; $5d2c
	ld (hl),$01		; $5d2d
	inc l			; $5d2f
	ld (hl),c		; $5d30
	push de			; $5d31
	ld de,w1Link.yh		; $5d32
	call objectCopyPosition_rawAddress		; $5d35
	pop de			; $5d38
	ret			; $5d39
	ld hl,$5d45		; $5d3a
	call setWarpDestVariables		; $5d3d
	ld a,$8d		; $5d40
	jp playSound		; $5d42
	add l			; $5d45
.DB $ec				; $5d46
	nop			; $5d47
	rla			; $5d48
	inc bc			; $5d49
	ld e,$78		; $5d4a
_label_15_097:
	ld a,(de)		; $5d4c
	jp interactionSetAnimation		; $5d4d
	or l			; $5d50
	inc d			; $5d51
	ld d,l			; $5d52
	ld e,l			; $5d53
	nop			; $5d54
.DB $eb				; $5d55
	sbc (hl)		; $5d56
	cp l			; $5d57
	or l			; $5d58
	ld (hl),d		; $5d59
	adc (hl)		; $5d5a
	ld e,l			; $5d5b
	sbc b			; $5d5c
	inc sp			; $5d5d
	stop			; $5d5e
	or $c3			; $5d5f
	nop			; $5d61
_label_15_098:
	ld l,c			; $5d62
	ld e,l			; $5d63
	sbc b			; $5d64
	inc sp			; $5d65
	ld de,$935d		; $5d66
	add (hl)		; $5d69
	inc b			; $5d6a
_label_15_099:
	or $cb			; $5d6b
	adc c			; $5d6d
	call z,$7700		; $5d6e
	ld e,l			; $5d71
	sbc b			; $5d72
	inc sp			; $5d73
	ld de,$935d		; $5d74
	or (hl)			; $5d77
	ld l,b			; $5d78
	sbc b			; $5d79
	inc sp			; $5d7a
	ld (de),a		; $5d7b
	or $c0			; $5d7c
	adc e			; $5d7e
	ld d,c			; $5d7f
	or $e0			; $5d80
	dec d			; $5d82
	ld e,l			; $5d83
	or $b6			; $5d84
	ld (hl),d		; $5d86
	add (hl)		; $5d87
	inc d			; $5d88
	sbc b			; $5d89
	inc sp			; $5d8a
	inc de			; $5d8b
	ld e,l			; $5d8c
	sub e			; $5d8d
	add (hl)		; $5d8e
	inc d			; $5d8f
	sbc b			; $5d90
	inc sp			; $5d91
	inc d			; $5d92
	or $e0			; $5d93
	ldd a,(hl)		; $5d95
	ld e,l			; $5d96
	cp (hl)			; $5d97
	ld a,($ff00+$5d)	; $5d98
	sbc b			; $5d9a
.DB $eb				; $5d9b
	cp (hl)			; $5d9c
	sbc (hl)		; $5d9d
	cp l			; $5d9e
	or b			; $5d9f
	jr nz,_label_15_098	; $5da0
	ld e,l			; $5da2
	sbc b			; $5da3
	inc sp			; $5da4
	ld ($20b5),sp		; $5da5
	xor h			; $5da8
	ld e,l			; $5da9
	ld e,l			; $5daa
	sbc h			; $5dab
_label_15_100:
	or $98			; $5dac
	inc sp			; $5dae
	add hl,bc		; $5daf
	sub (hl)		; $5db0
	nop			; $5db1
	or $b1			; $5db2
	jr nz,_label_15_097	; $5db4
	stop			; $5db6
	or $de			; $5db7
	ld d,l			; $5db9
	nop			; $5dba
	ldh a,(<hScriptAddressH)	; $5dbb
	cp (hl)			; $5dbd
	ld e,l			; $5dbe
	sbc h			; $5dbf
	sbc b			; $5dc0
	inc sp			; $5dc1
	ld a,(bc)		; $5dc2
	ld e,l			; $5dc3
	sbc h			; $5dc4
.DB $eb				; $5dc5
	sbc (hl)		; $5dc6
	or b			; $5dc7
	jr nz,_label_15_100	; $5dc8
	ld e,l			; $5dca
	cp l			; $5dcb
	sbc b			; $5dcc
	inc sp			; $5dcd
	dec bc			; $5dce
	sub (hl)		; $5dcf
	nop			; $5dd0
	or $b1			; $5dd1
	jr nz,_label_15_099	; $5dd3
	stop			; $5dd5
	or $de			; $5dd6
	ld d,c			; $5dd8
	nop			; $5dd9
	ldh a,(<hScriptAddressH)	; $5dda
	sbc b			; $5ddc
	inc sp			; $5ddd
	inc c			; $5dde
	sbc c			; $5ddf
	cp h			; $5de0
	nop			; $5de1
	sbc b			; $5de2
	inc sp			; $5de3
	dec c			; $5de4
	sbc c			; $5de5
	nop			; $5de6
	ld hl,$cde2		; $5de7
_label_15_101:
	call getRandomNumber		; $5dea
	and $03			; $5ded
	cp (hl)			; $5def
	jr z,_label_15_101	; $5df0
	ld (hl),a		; $5df2
	ret			; $5df3
	or l			; $5df4
	inc d			; $5df5
	ld a,($5d5d)		; $5df6
	cp $b0			; $5df9
	jr nz,_label_15_104	; $5dfb
	ld e,(hl)		; $5dfd
.DB $eb				; $5dfe
	sbc (hl)		; $5dff
	cp l			; $5e00
	or b			; $5e01
	jr nz,_label_15_105	; $5e02
	ld e,(hl)		; $5e04
	sbc b			; $5e05
	ld d,$f6		; $5e06
	ret z			; $5e08
	dec b			; $5e09
_label_15_102:
	ld de,$985e		; $5e0a
	rla			; $5e0d
	cp (hl)			; $5e0e
	ld e,l			; $5e0f
	rst $38			; $5e10
	sbc b			; $5e11
	jr _label_15_102		; $5e12
	jp $1d00		; $5e14
	ld e,(hl)		; $5e17
	sbc b			; $5e18
	dec de			; $5e19
	cp (hl)			; $5e1a
	ld e,l			; $5e1b
	rst $38			; $5e1c
	sbc b			; $5e1d
	add hl,de		; $5e1e
	or $de			; $5e1f
	ld b,c			; $5e21
	dec b			; $5e22
	or $98			; $5e23
	ld a,(de)		; $5e25
	cp (hl)			; $5e26
	ld e,l			; $5e27
	rst $38			; $5e28
	sbc b			; $5e29
_label_15_103:
	inc e			; $5e2a
_label_15_104:
	cp (hl)			; $5e2b
	ld e,l			; $5e2c
_label_15_105:
	rst $38			; $5e2d
	adc b			; $5e2e
	jr z,_label_15_106	; $5e2f
.DB $eb				; $5e31
	or l			; $5e32
	dec sp			; $5e33
	ld (hl),a		; $5e34
	ld e,(hl)		; $5e35
	sbc (hl)		; $5e36
	cp l			; $5e37
	or b			; $5e38
	add b			; $5e39
	ld (hl),d		; $5e3a
	ld e,(hl)		; $5e3b
	or l			; $5e3c
	ld l,d			; $5e3d
	ld e,(hl)		; $5e3e
	ld e,(hl)		; $5e3f
	sbc b			; $5e40
	ldd a,(hl)		; $5e41
	or $c3			; $5e42
	nop			; $5e44
	ld c,e			; $5e45
	ld e,(hl)		; $5e46
	sbc b			; $5e47
	dec sp			; $5e48
	ld e,(hl)		; $5e49
	ld (hl),h		; $5e4a
	add (hl)		; $5e4b
	ld b,$f6		; $5e4c
	res 1,c			; $5e4e
	call z,$5800		; $5e50
	ld e,(hl)		; $5e53
	sbc b			; $5e54
	dec a			; $5e55
	ld e,(hl)		; $5e56
	ld (hl),h		; $5e57
	or (hl)			; $5e58
	ld l,d			; $5e59
	sbc b			; $5e5a
	inc a			; $5e5b
	ld e,(hl)		; $5e5c
	ld h,b			; $5e5d
	sbc b			; $5e5e
	ld b,e			; $5e5f
	or $c3			; $5e60
	nop			; $5e62
	ld l,c			; $5e63
	ld e,(hl)		; $5e64
	sbc b			; $5e65
	ld a,$5e		; $5e66
	ld (hl),h		; $5e68
	sbc b			; $5e69
	ccf			; $5e6a
	or c			; $5e6b
	add b			; $5e6c
	ld ($ff00+$e7),a	; $5e6d
	ld e,l			; $5e6f
	ld e,(hl)		; $5e70
	ld (hl),h		; $5e71
	sbc b			; $5e72
	ld b,b			; $5e73
	cp (hl)			; $5e74
	ld e,(hl)		; $5e75
	ld (hl),$b0		; $5e76
	ld b,b			; $5e78
_label_15_106:
	adc a			; $5e79
	ld e,(hl)		; $5e7a
	cp l			; $5e7b
	pop hl			; $5e7c
	ld d,l			; $5e7d
	ld d,c			; $5e7e
	inc bc			; $5e7f
	sbc b			; $5e80
	ld b,c			; $5e81
	or $e1			; $5e82
	inc sp			; $5e84
	ld d,c			; $5e85
	ld hl,$40b1		; $5e86
	or $98			; $5e89
	ld b,d			; $5e8b
	cp (hl)			; $5e8c
	ld e,(hl)		; $5e8d
	sub d			; $5e8e
	adc b			; $5e8f
	ld a,(de)		; $5e90
	jr _label_15_103		; $5e91
	ld b,h			; $5e93
	call objectApplySpeed		; $5e94
	ld e,$4d		; $5e97
	ld a,(de)		; $5e99
	sub $18			; $5e9a
	cp $70			; $5e9c
	ret c			; $5e9e
	ld h,d			; $5e9f
	ld l,$49		; $5ea0
	ld a,(hl)		; $5ea2
	xor $10			; $5ea3
	ld (hl),a		; $5ea5
	ld b,$01		; $5ea6
	jr _label_15_107		; $5ea8
	ld b,$02		; $5eaa
_label_15_107:
	ld h,d			; $5eac
	ld l,$7f		; $5ead
	ld a,(hl)		; $5eaf
	xor b			; $5eb0
	ld (hl),a		; $5eb1
	jp interactionSetAnimation		; $5eb2
	call getRandomNumber		; $5eb5
	and $07			; $5eb8
	ld hl,$5ecc		; $5eba
	rst_addAToHl			; $5ebd
	ld a,(hl)		; $5ebe
	ld e,$7e		; $5ebf
	ld (de),a		; $5ec1
	call $5eda		; $5ec2
	ld h,d			; $5ec5
	ld l,$4e		; $5ec6
	xor a			; $5ec8
	ldi (hl),a		; $5ec9
	ld (hl),a		; $5eca
	ret			; $5ecb
	ld a,b			; $5ecc
	or h			; $5ecd
	ld a,($ff00+R_IE)	; $5ece
	or h			; $5ed0
	ld a,($ff00+R_IE)	; $5ed1
	rst $38			; $5ed3
	ld c,$20		; $5ed4
	call objectUpdateSpeedZ_paramC		; $5ed6
_label_15_108:
	ret nz			; $5ed9
	ld bc,$ff40		; $5eda
	jp objectSetSpeedZ		; $5edd
	ld h,d			; $5ee0
	ld l,$7e		; $5ee1
	dec (hl)		; $5ee3
	jp $5118		; $5ee4
	or b			; $5ee7
	jr nz,_label_15_108	; $5ee8
	ld b,l			; $5eea
.DB $eb				; $5eeb
	sbc (hl)		; $5eec
	cp l			; $5eed
	sbc b			; $5eee
	inc bc			; $5eef
	or $c8			; $5ef0
	ld bc,$5ef7		; $5ef2
	ld e,a			; $5ef5
	nop			; $5ef6
	sbc b			; $5ef7
	inc b			; $5ef8
	or $c3			; $5ef9
	nop			; $5efb
	inc bc			; $5efc
	ld e,a			; $5efd
	sbc b			; $5efe
	ld b,$be		; $5eff
	ld e,(hl)		; $5f01
.DB $ec				; $5f02
	sbc b			; $5f03
	dec b			; $5f04
	or $8e			; $5f05
	ld a,a			; $5f07
	ld bc,$508b		; $5f08
	.db $ed			; $5f0b
	dec e			; $5f0c
	xor $39			; $5f0d
	or $de			; $5f0f
	ld b,c			; $5f11
	ld bc,$00be		; $5f12
	call getRandomNumber_noPreserveVars		; $5f15
	and $1f			; $5f18
	sub $10			; $5f1a
	add $3c			; $5f1c
	ld e,$46		; $5f1e
	ld (de),a		; $5f20
	ret			; $5f21
	ld e,$43		; $5f22
	ld a,(de)		; $5f24
	ld hl,$5f2d		; $5f25
	rst_addAToHl			; $5f28
	ld a,(hl)		; $5f29
	jp interactionSetAnimation		; $5f2a
	nop			; $5f2d
	ld bc,$0100		; $5f2e
	nop			; $5f31
	ld bc,$0101		; $5f32
	call getRandomNumber		; $5f35
	and $07			; $5f38
	ld hl,$5f47		; $5f3a
	rst_addAToHl			; $5f3d
	ld a,(hl)		; $5f3e
	ld e,$72		; $5f3f
	ld (de),a		; $5f41
	ld a,$1b		; $5f42
	inc e			; $5f44
	ld (de),a		; $5f45
	ret			; $5f46
	ld bc,$0302		; $5f47
	inc b			; $5f4a
	dec b			; $5f4b
	ld bc,$0302		; $5f4c
	adc b			; $5f4f
	ld d,l			; $5f50
	ld a,$8f		; $5f51
	rlca			; $5f53
	ld ($ff00+$3c),a	; $5f54
	ld e,$f8		; $5f56
	adc e			; $5f58
	ld a,(bc)		; $5f59
	adc c			; $5f5a
	stop			; $5f5b
	adc h			; $5f5c
	inc d			; $5f5d
	di			; $5f5e
	adc c			; $5f5f
	ld ($308c),sp		; $5f60
	adc (hl)		; $5f63
	ld a,a			; $5f64
	ld bc,$91f5		; $5f65
	ret nz			; $5f68
	rst $8			; $5f69
	ld (bc),a		; $5f6a
	push de			; $5f6b
	ret nz			; $5f6c
	rst $8			; $5f6d
	inc b			; $5f6e
	adc (hl)		; $5f6f
	ld a,a			; $5f70
	nop			; $5f71
	adc c			; $5f72
	stop			; $5f73
	nop			; $5f74
	call objectGetLinkRelativeAngle		; $5f75
	call convertAngleToDirection		; $5f78
	cp $01			; $5f7b
	ret nz			; $5f7d
	ld hl,w1Link.yh		; $5f7e
	ld b,(hl)		; $5f81
	ld a,$48		; $5f82
	sub b			; $5f84
	ld b,a			; $5f85
	ld hl,$5f9e		; $5f86
	ld a,$15		; $5f89
	push de			; $5f8b
	call setSimulatedInputAddress		; $5f8c
	pop de			; $5f8f
	ld a,b			; $5f90
	ld (wSimulatedInputCounter),a		; $5f91
	ld a,$80		; $5f94
	ld (wSimulatedInputValue),a		; $5f96
	xor a			; $5f99
	ld (wDisabledObjects),a		; $5f9a
	ret			; $5f9d
	ld a,(bc)		; $5f9e
	nop			; $5f9f
	nop			; $5fa0
	ld bc,$4000		; $5fa1
	rst $38			; $5fa4
	ld a,a			; $5fa5
	nop			; $5fa6
	rst $38			; $5fa7
	rst $38			; $5fa8
	ld de,w1Link.yh		; $5fa9
	call getShortPositionFromDE		; $5fac
	ld ($cfd3),a		; $5faf
	ld e,$08		; $5fb2
	ld a,(de)		; $5fb4
	ld ($cfd4),a		; $5fb5
	ret			; $5fb8
	ld h,d			; $5fb9
	ld l,$50		; $5fba
	ld (hl),$14		; $5fbc
	ld l,$7f		; $5fbe
	ld (hl),$01		; $5fc0
	ret			; $5fc2
	ld h,d			; $5fc3
	ld l,$7e		; $5fc4
	ld (hl),a		; $5fc6
	ld b,a			; $5fc7
	swap a			; $5fc8
	rrca			; $5fca
	ld l,$49		; $5fcb
	ld (hl),a		; $5fcd
	ld a,b			; $5fce
	jp interactionSetAnimation		; $5fcf
	ld e,$7c		; $5fd2
	ld (de),a		; $5fd4
	ret			; $5fd5
	ld e,$7e		; $5fd6
	ld a,(de)		; $5fd8
	jp interactionSetAnimation		; $5fd9
	ld h,d			; $5fdc
	ld l,$7c		; $5fdd
	dec (hl)		; $5fdf
	jp $5118		; $5fe0
	ld e,$43		; $5fe3
	ld a,(de)		; $5fe5
	cp $04			; $5fe6
	jr z,_label_15_109	; $5fe8
	call getRandomNumber		; $5fea
	and $03			; $5fed
_label_15_109:
	ld hl,$5ffc		; $5fef
	rst_addAToHl			; $5ff2
	ld a,(hl)		; $5ff3
	ld e,$72		; $5ff4
	ld (de),a		; $5ff6
	ld a,$10		; $5ff7
	inc e			; $5ff9
	ld (de),a		; $5ffa
	ret			; $5ffb
	ld a,(bc)		; $5ffc
	dec bc			; $5ffd
	inc c			; $5ffe
	inc c			; $5fff
	dec c			; $6000
	call getBlackTowerProgress		; $6001
	jp $5118		; $6004
	call getBlackTowerProgress		; $6007
	cp $01			; $600a
	jp $5118		; $600c
.DB $eb				; $600f
	or b			; $6010
	add b			; $6011
	ld c,c			; $6012
	ld h,b			; $6013
	or b			; $6014
	ld b,b			; $6015
	dec hl			; $6016
	ld h,b			; $6017
	sbc (hl)		; $6018
	cp l			; $6019
	sbc b			; $601a
	inc bc			; $601b
	or $b1			; $601c
	ld b,b			; $601e
	ld ($ff00+$a9),a	; $601f
	ld e,a			; $6021
	sub c			; $6022
	cp b			; $6023
	rlc b			; $6024
	sub c			; $6026
	inc b			; $6027
	call z,$0008		; $6028
	cp l			; $602b
	ld ($ff00+$a8),a	; $602c
	ld e,h			; $602e
	pop de			; $602f
	ld hl,sp-$68		; $6030
	ld b,$e0		; $6032
	ld (hl),l		; $6034
	ld e,a			; $6035
	adc (hl)		; $6036
	ld a,b			; $6037
	ld bc,$8bf6		; $6038
	inc d			; $603b
	.db $ed			; $603c
	ld hl,$788e		; $603d
	nop			; $6040
	or $b1			; $6041
	add b			; $6043
	sub c			; $6044
	jp $00cb		; $6045
	cp (hl)			; $6048
	sbc (hl)		; $6049
	sbc b			; $604a
	inc b			; $604b
	ld h,b			; $604c
	ld c,c			; $604d
	ldh (<hIntroInputsEnabled),a	; $604e
	ld e,a			; $6050
	ld ($ff00+$e3),a	; $6051
	ld e,a			; $6053
.DB $eb				; $6054
	add $43			; $6055
	ld h,c			; $6057
	ld h,b			; $6058
	adc a			; $6059
	ld h,b			; $605a
.DB $d3				; $605b
	ld h,b			; $605c
.DB $eb				; $605d
	ld h,b			; $605e
	add hl,de		; $605f
	ld h,c			; $6060
	pop hl			; $6061
	jp $025f		; $6062
	pop hl			; $6065
	jp nc,$405f		; $6066
	ret nz			; $6069
	rla			; $606a
	ld h,(hl)		; $606b
	pop hl			; $606c
	jp $015f		; $606d
	pop hl			; $6070
	jp nc,$605f		; $6071
	ret nz			; $6074
	rla			; $6075
	ld h,(hl)		; $6076
	pop hl			; $6077
	jp $035f		; $6078
	pop hl			; $607b
	jp nc,$605f		; $607c
	ret nz			; $607f
	rla			; $6080
	ld h,(hl)		; $6081
	pop hl			; $6082
	jp $005f		; $6083
	pop hl			; $6086
	jp nc,$405f		; $6087
	ret nz			; $608a
	rla			; $608b
	ld h,(hl)		; $608c
	ld h,b			; $608d
	ld h,c			; $608e
	pop hl			; $608f
	jp $025f		; $6090
	pop hl			; $6093
	jp nc,$405f		; $6094
	ret nz			; $6097
	rla			; $6098
	ld h,(hl)		; $6099
	pop hl			; $609a
	jp $015f		; $609b
	pop hl			; $609e
	jp nc,$805f		; $609f
	ret nz			; $60a2
	rla			; $60a3
	ld h,(hl)		; $60a4
	pop hl			; $60a5
	jp $005f		; $60a6
	pop hl			; $60a9
	jp nc,$205f		; $60aa
	ret nz			; $60ad
	rla			; $60ae
	ld h,(hl)		; $60af
	pop hl			; $60b0
	jp $025f		; $60b1
	pop hl			; $60b4
	jp nc,$205f		; $60b5
	ret nz			; $60b8
	rla			; $60b9
	ld h,(hl)		; $60ba
	pop hl			; $60bb
	jp $035f		; $60bc
	pop hl			; $60bf
	jp nc,$805f		; $60c0
	ret nz			; $60c3
	rla			; $60c4
	ld h,(hl)		; $60c5
	pop hl			; $60c6
	jp $005f		; $60c7
	pop hl			; $60ca
	jp nc,$405f		; $60cb
	ret nz			; $60ce
	rla			; $60cf
	ld h,(hl)		; $60d0
	ld h,b			; $60d1
	adc a			; $60d2
	pop hl			; $60d3
	jp $015f		; $60d4
	pop hl			; $60d7
	jp nc,$a05f		; $60d8
	ret nz			; $60db
	rla			; $60dc
	ld h,(hl)		; $60dd
	pop hl			; $60de
	jp $035f		; $60df
	pop hl			; $60e2
	jp nc,$a05f		; $60e3
	ret nz			; $60e6
	rla			; $60e7
	ld h,(hl)		; $60e8
	ld h,b			; $60e9
.DB $d3				; $60ea
	pop hl			; $60eb
	jp $025f		; $60ec
	pop hl			; $60ef
	jp nc,$405f		; $60f0
	ret nz			; $60f3
	rla			; $60f4
	ld h,(hl)		; $60f5
	pop hl			; $60f6
	jp $015f		; $60f7
	pop hl			; $60fa
	jp nc,$a05f		; $60fb
	ret nz			; $60fe
	rla			; $60ff
	ld h,(hl)		; $6100
	pop hl			; $6101
	jp $035f		; $6102
	pop hl			; $6105
	jp nc,$a05f		; $6106
	ret nz			; $6109
	rla			; $610a
	ld h,(hl)		; $610b
	pop hl			; $610c
	jp $005f		; $610d
	pop hl			; $6110
	jp nc,$405f		; $6111
	ret nz			; $6114
	rla			; $6115
	ld h,(hl)		; $6116
	ld h,b			; $6117
.DB $eb				; $6118
	pop hl			; $6119
	jp $015f		; $611a
	pop hl			; $611d
	jp nc,$605f		; $611e
	ret nz			; $6121
	rla			; $6122
	ld h,(hl)		; $6123
	pop hl			; $6124
	jp $035f		; $6125
	pop hl			; $6128
	jp nc,$605f		; $6129
	ret nz			; $612c
	rla			; $612d
	ld h,(hl)		; $612e
	ld h,c			; $612f
	add hl,de		; $6130
	ld h,d			; $6131
	ld l,$7e		; $6132
	ld a,(hl)		; $6134
	or a			; $6135
	call $5118		; $6136
	jr z,_label_15_110	; $6139
	dec (hl)		; $613b
	ld a,(wFrameCounter)		; $613c
	rrca			; $613f
	rrca			; $6140
	jp nc,objectSetInvisible		; $6141
_label_15_110:
	jp objectSetVisible		; $6144
.DB $eb				; $6147
	sbc (hl)		; $6148
	cp l			; $6149
	add $43			; $614a
	ld d,d			; $614c
	ld h,c			; $614d
	ld l,d			; $614e
	ld h,c			; $614f
	add e			; $6150
	ld h,c			; $6151
	sbc b			; $6152
	dec bc			; $6153
	nop			; $6154
	or c			; $6155
	ld b,b			; $6156
	rst $30			; $6157
.DB $e3				; $6158
	sbc b			; $6159
	adc (hl)		; $615a
	ld a,(hl)		; $615b
	ld e,$e0		; $615c
	ld sp,$c761		; $615e
.DB $db				; $6161
	call $6880		; $6162
	ld h,c			; $6165
	ld h,c			; $6166
	ld e,l			; $6167
	cp (hl)			; $6168
	nop			; $6169
	sbc b			; $616a
	dec bc			; $616b
	ld bc,$40b1		; $616c
	or $8e			; $616f
	ld a,a			; $6171
	ld bc,$288b		; $6172
	adc a			; $6175
	ld (bc),a		; $6176
	adc c			; $6177
	stop			; $6178
	adc h			; $6179
	ld c,c			; $617a
	adc a			; $617b
	ld bc,$0889		; $617c
	adc h			; $617f
	add hl,sp		; $6180
	ld h,c			; $6181
	ld d,a			; $6182
	sbc b			; $6183
	dec bc			; $6184
	ld (bc),a		; $6185
	or $de			; $6186
	ld b,c			; $6188
	nop			; $6189
	ld h,c			; $618a
	ld d,a			; $618b
.DB $eb				; $618c
	sbc (hl)		; $618d
	cp l			; $618e
	or b			; $618f
	jr nz,-$4c		; $6190
	ld h,c			; $6192
	sbc b			; $6193
	inc sp			; $6194
	or $c8			; $6195
	dec bc			; $6197
	sbc (hl)		; $6198
	ld h,c			; $6199
	sbc b			; $619a
	inc (hl)		; $619b
	ld h,c			; $619c
	or (hl)			; $619d
	sbc b			; $619e
	dec (hl)		; $619f
	or $c3			; $61a0
	nop			; $61a2
	xor c			; $61a3
	ld h,c			; $61a4
	sbc b			; $61a5
	jr c,_label_15_114	; $61a6
	or (hl)			; $61a8
	sbc b			; $61a9
	ld (hl),$f6		; $61aa
	sbc $41			; $61ac
	dec bc			; $61ae
	or $98			; $61af
	scf			; $61b1
	ld h,c			; $61b2
	or (hl)			; $61b3
	sbc b			; $61b4
	add hl,sp		; $61b5
	cp (hl)			; $61b6
	ld h,c			; $61b7
	adc l			; $61b8
	ld hl,w1Link.yh		; $61b9
	ldi a,(hl)		; $61bc
	add $04			; $61bd
	and $f0			; $61bf
	ld b,a			; $61c1
	inc l			; $61c2
	ld a,(hl)		; $61c3
	sub $04			; $61c4
	and $f0			; $61c6
	swap a			; $61c8
	or b			; $61ca
	ld b,a			; $61cb
	ld hl,$61da		; $61cc
_label_15_111:
	ldi a,(hl)		; $61cf
	or a			; $61d0
	scf			; $61d1
	jr z,_label_15_112	; $61d2
	cp b			; $61d4
	jr nz,_label_15_111	; $61d5
_label_15_112:
	jp $5118		; $61d7
	ld d,a			; $61da
	ld l,b			; $61db
	ld h,a			; $61dc
	nop			; $61dd
	ld e,$48		; $61de
	ld a,(de)		; $61e0
	cp $02			; $61e1
	ret z			; $61e3
	ld a,$02		; $61e4
	jr _label_15_113		; $61e6
	ld a,$01		; $61e8
	jr _label_15_113		; $61ea
	ld a,$00		; $61ec
_label_15_113:
	ld e,$48		; $61ee
	ld (de),a		; $61f0
	jp interactionSetAnimation		; $61f1
	ld e,$5a		; $61f4
	ld a,(de)		; $61f6
	ld ($cddb),a		; $61f7
	ret			; $61fa
	adc l			; $61fb
	inc b			; $61fc
	ld b,$9b		; $61fd
	sbc (hl)		; $61ff
	cp l			; $6200
	or b			; $6201
	jr nz,_label_15_116	; $6202
	ld h,d			; $6204
	adc a			; $6205
	nop			; $6206
	sbc b			; $6207
	dec bc			; $6208
_label_15_114:
	dec c			; $6209
.DB $f4				; $620a
	adc a			; $620b
	ld bc,$0b98		; $620c
	ld c,$f4		; $620f
	adc a			; $6211
	nop			; $6212
	sbc b			; $6213
	dec bc			; $6214
	rrca			; $6215
.DB $f4				; $6216
	adc a			; $6217
	ld bc,$0b98		; $6218
	ld c,$f6		; $621b
	ret z			; $621d
	inc b			; $621e
	inc hl			; $621f
	ld h,d			; $6220
	ld h,d			; $6221
	ld d,(hl)		; $6222
	sbc b			; $6223
	dec bc			; $6224
	stop			; $6225
	or $c3			; $6226
	nop			; $6228
	jr nc,$62		; $6229
	sbc b			; $622b
	dec bc			; $622c
	inc d			; $622d
	ld h,d			; $622e
	ld d,(hl)		; $622f
	sbc b			; $6230
	dec bc			; $6231
	ld b,l			; $6232
.DB $f4				; $6233
	adc a			; $6234
	nop			; $6235
	sbc b			; $6236
	dec bc			; $6237
	ld de,$8ff4		; $6238
	ld bc,$0b98		; $623b
	ld (de),a		; $623e
.DB $f4				; $623f
	adc a			; $6240
	nop			; $6241
	sbc b			; $6242
	dec bc			; $6243
	inc de			; $6244
.DB $f4				; $6245
	adc a			; $6246
	ld bc,$0b98		; $6247
	ld b,l			; $624a
	or $de			; $624b
	ld b,c			; $624d
	inc b			; $624e
	adc a			; $624f
	nop			; $6250
	ld h,d			; $6251
	ld d,(hl)		; $6252
	sbc b			; $6253
_label_15_115:
	dec bc			; $6254
	dec d			; $6255
	cp (hl)			; $6256
_label_15_116:
	ld h,c			; $6257
	rst $38			; $6258
	ld a,(wEssencesObtained)		; $6259
	call getLogA		; $625c
	cp $03			; $625f
	jr c,_label_15_117	; $6261
	ld a,$02		; $6263
_label_15_117:
	ld e,$7f		; $6265
	ld (de),a		; $6267
	ret			; $6268
	call $6271		; $6269
	cpl			; $626c
	ld ($cddb),a		; $626d
	ret			; $6270
	ld hl,wEssencesObtained		; $6271
	call checkFlag		; $6274
	jp $5118		; $6277
	ld a,$04		; $627a
	jr _label_15_118		; $627c
	ld a,$00		; $627e
_label_15_118:
	ld h,d			; $6280
	ld l,$77		; $6281
	ld (hl),a		; $6283
	ld l,$7e		; $6284
	ld (hl),$ff		; $6286
	ret			; $6288
	ld h,d			; $6289
	ld l,$4d		; $628a
	ld a,(w1Link.xh)		; $628c
	cp (hl)			; $628f
	ld a,$01		; $6290
	jr nc,_label_15_119	; $6292
	xor a			; $6294
_label_15_119:
	ld l,$7e		; $6295
	cp (hl)			; $6297
	ret z			; $6298
	ld (hl),a		; $6299
	ld l,$77		; $629a
	add (hl)		; $629c
	jp interactionSetAnimation		; $629d
	ld ($ff00+$59),a	; $62a0
_label_15_120:
	ld h,d			; $62a2
	or b			; $62a3
	jr nz,_label_15_115	; $62a4
	ld h,d			; $62a6
	ld ($ff00+$7e),a	; $62a7
	ld h,d			; $62a9
	adc a			; $62aa
	ld bc,$b362		; $62ab
	ld ($ff00+$7a),a	; $62ae
	ld h,d			; $62b0
	adc a			; $62b1
	dec b			; $62b2
.DB $eb				; $62b3
	sbc (hl)		; $62b4
	cp l			; $62b5
	or b			; $62b6
	jr nz,_label_15_120	; $62b7
	ld h,d			; $62b9
	add $7f			; $62ba
	jp nz,$c662		; $62bc
	ld h,d			; $62bf
	jp z,$9862		; $62c0
	inc l			; $62c3
	ld h,d			; $62c4
.DB $eb				; $62c5
	sbc b			; $62c6
	dec l			; $62c7
	ld h,d			; $62c8
.DB $eb				; $62c9
	sbc b			; $62ca
	ld l,$f6		; $62cb
	ret z			; $62cd
	rlca			; $62ce
.DB $d3				; $62cf
	ld h,d			; $62d0
	ld h,d			; $62d1
	jp c,$2f98		; $62d2
	or $c3			; $62d5
	nop			; $62d7
	sbc $62			; $62d8
_label_15_121:
	sbc b			; $62da
	ld sp,$eb62		; $62db
	ld ($ff00+$7a),a	; $62de
	ld h,d			; $62e0
	sbc b			; $62e1
	jr nc,_label_15_121	; $62e2
	sbc $41			; $62e4
	rlca			; $62e6
	ld h,d			; $62e7
.DB $eb				; $62e8
	sbc b			; $62e9
	ldd (hl),a		; $62ea
	or $be			; $62eb
	ld h,d			; $62ed
	or h			; $62ee
	ld b,$20		; $62ef
	ld hl,wCFC0		; $62f1
	call clearMemory		; $62f4
	ld a,$02		; $62f7
	ld ($cfd2),a		; $62f9
	ld hl,w1Link.direction		; $62fc
	ld (hl),$02		; $62ff
	ld h,d			; $6301
	ld l,$44		; $6302
	ld (hl),$01		; $6304
	inc l			; $6306
	ld (hl),$00		; $6307
	ret			; $6309
	xor a			; $630a
	ld (wCFD8+2),a		; $630b
	ld (wCFD8+3),a		; $630e
	ld hl,w1Link.direction		; $6311
	ld (hl),$02		; $6314
	ld b,$0a		; $6316
	ld hl,$5786		; $6318
	ld e,$08		; $631b
	jp interBankCall		; $631d
	ld a,(wAreaFlags)		; $6320
	and $80			; $6323
	jp $5118		; $6325
	ld a,(wAreaFlags)		; $6328
	cpl			; $632b
	and $80			; $632c
	jp $5118		; $632e
	ld a,$02		; $6331
	ld bc,$5c50		; $6333
	jr _label_15_122		; $6336
	ld a,$00		; $6338
	ld bc,$8838		; $633a
	jr _label_15_122		; $633d
	ld a,$01		; $633f
	ld bc,$78a8		; $6341
	jr _label_15_122		; $6344
	ld a,$00		; $6346
	ld bc,$4850		; $6348
_label_15_122:
	ld hl,w1Link.direction		; $634b
	ld (hl),a		; $634e
	ld l,$0b		; $634f
	ld (hl),b		; $6351
	ld l,$0d		; $6352
	ld (hl),c		; $6354
	call func_2a8c		; $6355
	jp setLinkForceStateToState08		; $6358
	ld a,(wCFD8+3)		; $635b
	ld b,a			; $635e
	ld a,$08		; $635f
	sub b			; $6361
	ld hl,wTextNumberSubstitution		; $6362
	ld (hl),a		; $6365
	inc hl			; $6366
	ld (hl),$00		; $6367
	ld a,(wCFD8+3)		; $6369
	or a			; $636c
	jp $5118		; $636d
	ld a,(wAreaFlags)		; $6370
	and $80			; $6373
	jr nz,_label_15_123	; $6375
	ld b,$02		; $6377
	jr _label_15_124		; $6379
_label_15_123:
	ld b,$00		; $637b
	ld a,(wCFD8+5)		; $637d
	cp $00			; $6380
	jr z,_label_15_124	; $6382
	ld b,$02		; $6384
_label_15_124:
	call getRandomNumber		; $6386
	and $01			; $6389
	add b			; $638b
	ld hl,$6394		; $638c
	rst_addAToHl			; $638f
	ld a,(hl)		; $6390
	jp $5133		; $6391
	add hl,de		; $6394
	ccf			; $6395
	jr nc,_label_15_125	; $6396
	ld c,a			; $6398
	ld a,(wAreaFlags)		; $6399
	and $80			; $639c
	call z,$63a6		; $639e
	ld b,$24		; $63a1
	jp showText		; $63a3
	ld a,c			; $63a6
	add $20			; $63a7
	ld c,a			; $63a9
	ret			; $63aa
	ld c,a			; $63ab
	call checkIsLinkedGame		; $63ac
	jr nz,_label_15_128	; $63af
	ld a,(wAreaFlags)		; $63b1
	and $80			; $63b4
_label_15_125:
	jr z,_label_15_126	; $63b6
	jr _label_15_127		; $63b8
_label_15_126:
	ld a,c			; $63ba
	add $10			; $63bb
	ld c,a			; $63bd
_label_15_127:
	ld b,$24		; $63be
	jp showText		; $63c0
_label_15_128:
	ld a,(wAreaFlags)		; $63c3
	and $80			; $63c6
	jr z,_label_15_126	; $63c8
	ld a,c			; $63ca
	add $20			; $63cb
	ld c,a			; $63cd
	jr _label_15_127		; $63ce
	ld c,a			; $63d0
	ld a,(wAreaFlags)		; $63d1
	and $80			; $63d4
	call z,$63de		; $63d6
	ld b,$24		; $63d9
	jp showText		; $63db
	ld a,c			; $63de
	add $0c			; $63df
	ld c,a			; $63e1
	ret			; $63e2
	ld a,GLOBALFLAG_2f		; $63e3
	call checkGlobalFlag		; $63e5
	jr nz,_label_15_129	; $63e8
	ld c,$79		; $63ea
	jr _label_15_130		; $63ec
_label_15_129:
	ld c,$7a		; $63ee
_label_15_130:
	ld b,$24		; $63f0
	jp showText		; $63f2
	ld e,$43		; $63f5
	ld a,(de)		; $63f7
	cp $03			; $63f8
	jr nc,_label_15_132	; $63fa
	ld a,GLOBALFLAG_2f		; $63fc
	call checkGlobalFlag		; $63fe
	ld b,$00		; $6401
	jr z,_label_15_131	; $6403
	ld b,$01		; $6405
_label_15_131:
	ld e,$43		; $6407
	ld a,(de)		; $6409
	rlca			; $640a
	jr _label_15_133		; $640b
_label_15_132:
	ld b,$03		; $640d
_label_15_133:
	add b			; $640f
	ld hl,$641a		; $6410
	rst_addAToHl			; $6413
	ld b,$24		; $6414
	ld c,(hl)		; $6416
	jp showText		; $6417
	add d			; $641a
	add e			; $641b
	add h			; $641c
	add l			; $641d
	add (hl)		; $641e
.DB $e3				; $641f
	ld ($ff00+c),a		; $6420
.DB $e3				; $6421
	push hl			; $6422
	call $6429		; $6423
	jp $6469		; $6426
	ld a,(wAreaFlags)		; $6429
	and $80			; $642c
	jr z,_label_15_134	; $642e
	ld a,GLOBALFLAG_FINISHEDGAME		; $6430
	call checkGlobalFlag		; $6432
	jr nz,_label_15_137	; $6435
	ld a,GLOBALFLAG_2f		; $6437
	call checkGlobalFlag		; $6439
	jr nz,_label_15_136	; $643c
	jr _label_15_135		; $643e
_label_15_134:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6440
	call checkGlobalFlag		; $6442
	jr nz,_label_15_138	; $6445
	ld a,GLOBALFLAG_1a		; $6447
	call checkGlobalFlag		; $6449
	jr nz,_label_15_137	; $644c
	ld a,$03		; $644e
	ld hl,wEssencesObtained		; $6450
	call checkFlag		; $6453
	jr nz,_label_15_136	; $6456
_label_15_135:
	xor a			; $6458
	jr _label_15_139		; $6459
_label_15_136:
	ld a,$01		; $645b
	jr _label_15_139		; $645d
_label_15_137:
	ld a,$02		; $645f
	jr _label_15_139		; $6461
_label_15_138:
	ld a,$03		; $6463
_label_15_139:
	ld e,$7b		; $6465
	ld (de),a		; $6467
	ret			; $6468
	ld e,$42		; $6469
	ld a,(de)		; $646b
	sub $0c			; $646c
	ld hl,$6493		; $646e
	rst_addAToHl			; $6471
	ld a,(hl)		; $6472
	rst_addAToHl			; $6473
	ld e,$43		; $6474
	ld a,(de)		; $6476
	rlca			; $6477
	rst_addDoubleIndex			; $6478
	ld e,$7b		; $6479
	ld a,(de)		; $647b
	rst_addAToHl			; $647c
	ld a,(hl)		; $647d
	ld e,$72		; $647e
	ld (de),a		; $6480
	ld b,a			; $6481
	inc e			; $6482
	ld a,$31		; $6483
	ld (de),a		; $6485
	ld a,b			; $6486
	cp $27			; $6487
	ret nz			; $6489
	call checkIsLinkedGame		; $648a
	ret nz			; $648d
	ld a,$ff		; $648e
	dec e			; $6490
	ld (de),a		; $6491
	ret			; $6492
	ld b,e			; $6493
	ld l,$01		; $6494
	nop			; $6496
	rst $38			; $6497
	rst $38			; $6498
	rst $38			; $6499
	rst $38			; $649a
	ld bc,$0101		; $649b
	rst $38			; $649e
	ld (bc),a		; $649f
	ld (bc),a		; $64a0
	ld (bc),a		; $64a1
	rst $38			; $64a2
	rst $38			; $64a3
	inc bc			; $64a4
	inc b			; $64a5
	rst $38			; $64a6
	rst $38			; $64a7
	dec b			; $64a8
	dec b			; $64a9
	rst $38			; $64aa
	rst $38			; $64ab
	ld b,$06		; $64ac
	rst $38			; $64ae
	rst $38			; $64af
	rlca			; $64b0
	ld ($0a09),sp		; $64b1
	ld a,(bc)		; $64b4
	nop			; $64b5
	rst $38			; $64b6
	dec bc			; $64b7
	dec bc			; $64b8
	nop			; $64b9
	rst $38			; $64ba
	inc c			; $64bb
	dec c			; $64bc
	nop			; $64bd
	rst $38			; $64be
	ld c,$0f		; $64bf
	nop			; $64c1
	rst $38			; $64c2
	stop			; $64c3
	ld de,$ff12		; $64c4
	inc de			; $64c7
	inc d			; $64c8
	rst $38			; $64c9
	rst $38			; $64ca
	dec d			; $64cb
	dec d			; $64cc
	ld d,$1a		; $64cd
	ld a,(de)		; $64cf
	dec de			; $64d0
	nop			; $64d1
	rst $38			; $64d2
	inc e			; $64d3
	dec e			; $64d4
	nop			; $64d5
	rst $38			; $64d6
	ld e,$1f		; $64d7
	jr nz,-$01		; $64d9
	rst $38			; $64db
	ld hl,$ff22		; $64dc
	rst $38			; $64df
	inc hl			; $64e0
	inc hl			; $64e1
	rst $38			; $64e2
	rst $38			; $64e3
	inc h			; $64e4
	inc h			; $64e5
	rst $38			; $64e6
	dec h			; $64e7
	ld h,$00		; $64e8
	rst $38			; $64ea
	daa			; $64eb
	rst $38			; $64ec
	nop			; $64ed
	rst $38			; $64ee
	rst $38			; $64ef
	rla			; $64f0
	jr -$01			; $64f1
	rst $38			; $64f3
	add hl,de		; $64f4
	add hl,de		; $64f5
	ld bc,$1818		; $64f6
	call objectSetCollideRadii		; $64f9
	call objectCheckCollidedWithLink_ignoreZ		; $64fc
	ccf			; $64ff
	call $5118		; $6500
	ld bc,$0606		; $6503
	jp objectSetCollideRadii		; $6506
	ld h,d			; $6509
	ld l,$6b		; $650a
	ld (hl),$00		; $650c
	ld l,$49		; $650e
	ld (hl),$10		; $6510
	ld l,$7f		; $6512
	ld (hl),$00		; $6514
	ld a,$02		; $6516
	jp interactionSetAnimation		; $6518
	ld h,d			; $651b
	ld l,$7f		; $651c
	ld (hl),$01		; $651e
	jp interactionSetAnimation		; $6520
	ld h,d			; $6523
	ld l,$50		; $6524
	ld (hl),$14		; $6526
	ld l,$49		; $6528
	ld (hl),$18		; $652a
	ld l,$7c		; $652c
	ld (hl),$40		; $652e
	inc l			; $6530
	ld (hl),$00		; $6531
	ld l,$7f		; $6533
	ld (hl),$01		; $6535
	ld a,$03		; $6537
	ld e,$7e		; $6539
	ld (de),a		; $653b
	jp interactionSetAnimation		; $653c
	ld h,d			; $653f
	ld l,$7c		; $6540
	ld (hl),$80		; $6542
	inc l			; $6544
	ld (hl),$00		; $6545
	ld l,$49		; $6547
	ld a,(hl)		; $6549
	xor $10			; $654a
	ld (hl),a		; $654c
	ld l,$7e		; $654d
	ld a,(hl)		; $654f
	xor $02			; $6550
	ld (hl),a		; $6552
	jp interactionSetAnimation		; $6553
	ld e,$7e		; $6556
	ld a,(de)		; $6558
	jp interactionSetAnimation		; $6559
	ld h,d			; $655c
	ld l,$50		; $655d
	ld (hl),$28		; $655f
	ld l,$49		; $6561
	ld (hl),$10		; $6563
	ld a,$02		; $6565
	jp $651b		; $6567
	xor a			; $656a
	ld hl,w1Link.yh		; $656b
	add (hl)		; $656e
	jr _label_15_140		; $656f
	ld a,$60		; $6571
_label_15_140:
	ld h,d			; $6573
	ld l,$4b		; $6574
	cp (hl)			; $6576
	jp $5118		; $6577
	ld a,$f2		; $657a
	ld hl,w1Link.xh		; $657c
	add (hl)		; $657f
	jr _label_15_141		; $6580
	ld a,$48		; $6582
_label_15_141:
	ld h,d			; $6584
	ld l,$4d		; $6585
	cp (hl)			; $6587
	jp $5118		; $6588
	ld a,$49		; $658b
	call checkQuestItemObtained		; $658d
	call $5118		; $6590
	ret nc			; $6593
	ld h,d			; $6594
	ld l,$4b		; $6595
	ld a,(hl)		; $6597
	ld (hl),$88		; $6598
	push af			; $659a
	ld l,$4d		; $659b
	ld a,(hl)		; $659d
	ld (hl),$58		; $659e
	push af			; $65a0
	ld bc,$1808		; $65a1
	call objectSetCollideRadii		; $65a4
	call objectCheckCollidedWithLink_ignoreZ		; $65a7
	call $5118		; $65aa
	ld bc,$0606		; $65ad
	call objectSetCollideRadii		; $65b0
	pop af			; $65b3
	ld h,d			; $65b4
	ld l,$4d		; $65b5
	ld (hl),a		; $65b7
	pop af			; $65b8
	ld l,$4b		; $65b9
	ld (hl),a		; $65bb
	ret			; $65bc
	ld h,d			; $65bd
	ld l,$7c		; $65be
	call decHlRef16WithCap		; $65c0
	jp $5118		; $65c3
	ld h,d			; $65c6
	ld l,$7c		; $65c7
	ld (hl),$5a		; $65c9
	inc l			; $65cb
	ld (hl),$00		; $65cc
	ld l,$7e		; $65ce
	ld (hl),$01		; $65d0
	ret			; $65d2
	ld h,d			; $65d3
	ld l,$7e		; $65d4
	dec (hl)		; $65d6
	ret nz			; $65d7
	ld (hl),$05		; $65d8
	ld a,$a5		; $65da
	call playSound		; $65dc
	ld a,$04		; $65df
	jp setScreenShakeCounter		; $65e1
	ld b,$92		; $65e4
	jp objectCreateInteractionWithSubid00		; $65e6
	ld hl,$660b		; $65e9
	ld c,$31		; $65ec
	call $65f8		; $65ee
	ld c,$41		; $65f1
	call $65f8		; $65f3
	ld c,$51		; $65f6
	ld a,$05		; $65f8
_label_15_142:
	ldh (<hFF8B),a	; $65fa
	ldi a,(hl)		; $65fc
	push bc			; $65fd
	push hl			; $65fe
	call setTile		; $65ff
	pop hl			; $6602
	pop bc			; $6603
	inc c			; $6604
	ldh a,(<hFF8B)	; $6605
	dec a			; $6607
	jr nz,_label_15_142	; $6608
	ret			; $660a
	and d			; $660b
	and c			; $660c
	and d			; $660d
	and c			; $660e
	and d			; $660f
	and c			; $6610
	and d			; $6611
	and c			; $6612
	and d			; $6613
	and c			; $6614
	and d			; $6615
	and c			; $6616
	and d			; $6617
	and c			; $6618
	and d			; $6619
	ld bc,$f6fa		; $661a
	jr _label_15_143		; $661d
	ld bc,$f606		; $661f
_label_15_143:
	call getRandomNumber		; $6622
	and $01			; $6625
	ldh (<hFF8D),a	; $6627
	xor a			; $6629
_label_15_144:
	ldh (<hFF8B),a	; $662a
	call getFreeInteractionSlot		; $662c
	jr nz,_label_15_145	; $662f
	ld (hl),$92		; $6631
	inc l			; $6633
	ld (hl),$02		; $6634
	inc l			; $6636
	ld (hl),$01		; $6637
	ld l,$46		; $6639
	ldh a,(<hFF8D)	; $663b
	ld (hl),a		; $663d
	ld l,$49		; $663e
	ldh a,(<hFF8B)	; $6640
	ld (hl),a		; $6642
	call objectCopyPositionWithOffset		; $6643
	ldh a,(<hFF8B)	; $6646
	inc a			; $6648
	cp $04			; $6649
	jr nz,_label_15_144	; $664b
_label_15_145:
	ld a,$a5		; $664d
	jp playSound		; $664f
	ld a,$19		; $6652
	call checkQuestItemObtained		; $6654
	jr nc,_label_15_147	; $6657
	ld a,$20		; $6659
	call checkQuestItemObtained		; $665b
	jr nc,_label_15_147	; $665e
	cp $20			; $6660
	jr c,_label_15_147	; $6662
	push af			; $6664
	ld a,$03		; $6665
	call checkQuestItemObtained		; $6667
	jr nc,_label_15_146	; $666a
	cp $20			; $666c
	jr c,_label_15_146	; $666e
	sub $20			; $6670
	daa			; $6672
	ld (wNumBombs),a		; $6673
	pop af			; $6676
	sub $20			; $6677
	daa			; $6679
	ld (wNumEmberSeeds),a		; $667a
	call setStatusBarNeedsRefreshBit1		; $667d
	xor a			; $6680
	jp $5118		; $6681
_label_15_146:
	pop af			; $6684
_label_15_147:
	or d			; $6685
	jp $5118		; $6686
	ld a,(wSeedTreeRefilledBitset)		; $6689
	cpl			; $668c
	bit 0,a			; $668d
	call $5118		; $668f
	ld hl,wSeedTreeRefilledBitset		; $6692
	res 0,(hl)		; $6695
	ret			; $6697
	call getThisRoomFlags		; $6698
	bit 5,(hl)		; $669b
	jr nz,_label_15_148	; $669d
	xor a			; $669f
	jr _label_15_149		; $66a0
_label_15_148:
	call getRandomNumber		; $66a2
	and $0f			; $66a5
	ld hl,$66d8		; $66a7
	rst_addAToHl			; $66aa
	ld a,(hl)		; $66ab
	cp $04			; $66ac
	jr nz,_label_15_149	; $66ae
	ld a,$06		; $66b0
	call checkQuestItemObtained		; $66b2
	ld a,$04		; $66b5
	jr nc,_label_15_149	; $66b7
	ld a,$03		; $66b9
_label_15_149:
	ld ($cfd6),a		; $66bb
	ld hl,$66e8		; $66be
	rst_addDoubleIndex			; $66c1
	ld b,(hl)		; $66c2
	inc l			; $66c3
	ld c,(hl)		; $66c4
	call getFreeInteractionSlot		; $66c5
	ret nz			; $66c8
	ld (hl),$60		; $66c9
	inc l			; $66cb
	ld (hl),b		; $66cc
	inc l			; $66cd
	ld (hl),c		; $66ce
	ld l,$4b		; $66cf
	ld (hl),$78		; $66d1
	ld l,$4d		; $66d3
	ld (hl),$78		; $66d5
	ret			; $66d7
	ld bc,$0101		; $66d8
	ld bc,$0101		; $66db
	ld bc,$0201		; $66de
	ld (bc),a		; $66e1
	ld (bc),a		; $66e2
	inc bc			; $66e3
	inc bc			; $66e4
	inc b			; $66e5
	inc b			; $66e6
	inc b			; $66e7
	ld e,(hl)		; $66e8
	ld bc,$1128		; $66e9
	jr z,$12		; $66ec
	inc (hl)		; $66ee
	ld b,$06		; $66ef
	ld bc,$7dcd		; $66f1
	add hl,de		; $66f4
	bit 5,(hl)		; $66f5
	jr nz,_label_15_150	; $66f7
	xor a			; $66f9
	jr _label_15_151		; $66fa
_label_15_150:
	call getRandomNumber		; $66fc
	and $0f			; $66ff
	ld hl,$6732		; $6701
	rst_addAToHl			; $6704
	ld a,(hl)		; $6705
_label_15_151:
	cp $04			; $6706
	jr nz,_label_15_152	; $6708
	call getRandomNumber		; $670a
	and $01			; $670d
	add $04			; $670f
_label_15_152:
	ld ($cfd6),a		; $6711
	ld hl,$6742		; $6714
	rst_addDoubleIndex			; $6717
	ld b,(hl)		; $6718
	inc l			; $6719
	ld c,(hl)		; $671a
	call getFreeInteractionSlot		; $671b
	ret nz			; $671e
	ld (hl),$60		; $671f
	inc l			; $6721
	ld (hl),b		; $6722
	inc l			; $6723
	ld (hl),c		; $6724
	ld l,$4b		; $6725
	ld (hl),$38		; $6727
	ld l,$4d		; $6729
	ld (hl),$50		; $672b
	ld l,$4f		; $672d
	ld (hl),$f0		; $672f
	ret			; $6731
	ld bc,$0101		; $6732
	ld (bc),a		; $6735
	ld (bc),a		; $6736
	ld (bc),a		; $6737
	ld (bc),a		; $6738
	ld (bc),a		; $6739
	ld (bc),a		; $673a
	ld (bc),a		; $673b
	ld (bc),a		; $673c
	ld (bc),a		; $673d
	ld (bc),a		; $673e
	inc bc			; $673f
	inc bc			; $6740
	inc b			; $6741
	ld b,l			; $6742
	ld bc,$1228		; $6743
	jr z,$13		; $6746
	inc (hl)		; $6748
	ld b,$2d		; $6749
	ld (de),a		; $674b
	dec l			; $674c
	inc de			; $674d
	ld b,$60		; $674e
	call $6767		; $6750
	ld l,$44		; $6753
	ld (hl),$04		; $6755
	ret			; $6757
	ld b,$16		; $6758
	call $6767		; $675a
	push de			; $675d
	ld e,l			; $675e
	ld d,h			; $675f
	call objectDelete_de		; $6760
	pop de			; $6763
	jp clearStaticObjects		; $6764
	ld hl,$d240		; $6767
_label_15_153:
	ld a,(hl)		; $676a
	or a			; $676b
	jr z,_label_15_154	; $676c
	inc l			; $676e
	ldd a,(hl)		; $676f
	cp b			; $6770
	jr nz,_label_15_154	; $6771
	xor a			; $6773
	ret			; $6774
_label_15_154:
	inc h			; $6775
	ld a,h			; $6776
	cp $e0			; $6777
	jr c,_label_15_153	; $6779
	or h			; $677b
	ret			; $677c
	ld hl,$d080		; $677d
_label_15_155:
	ld a,(hl)		; $6780
	or a			; $6781
	jr z,_label_15_156	; $6782
	inc l			; $6784
	ldd a,(hl)		; $6785
	cp $63			; $6786
	jr nz,_label_15_156	; $6788
	push de			; $678a
	push hl			; $678b
	ld e,l			; $678c
	ld d,h			; $678d
	call objectDelete_de		; $678e
	ld hl,wNumEnemies		; $6791
	dec (hl)		; $6794
	pop hl			; $6795
	pop de			; $6796
_label_15_156:
	inc h			; $6797
	ld a,h			; $6798
	cp $e0			; $6799
	jr c,_label_15_155	; $679b
	ret			; $679d
	xor a			; $679e
	ld (wCFD8+3),a		; $679f
	ld (wCFD8+5),a		; $67a2
	ld (wCFD8+6),a		; $67a5
	ld (wCFD8+4),a		; $67a8
	jp $67b1		; $67ab
	jp $67b7		; $67ae
	call getThisRoomFlags		; $67b1
	set 7,(hl)		; $67b4
	ret			; $67b6
	call getThisRoomFlags		; $67b7
	res 7,(hl)		; $67ba
	ret			; $67bc
	ld a,(wLinkInAir)		; $67bd
	bit 7,a			; $67c0
	jp $5118		; $67c2
	ld a,(wLinkInAir)		; $67c5
	or a			; $67c8
	jp $5118		; $67c9
	ld a,(wCFD8+6)		; $67cc
	add $00			; $67cf
	daa			; $67d1
	ld hl,wTextNumberSubstitution		; $67d2
	ld (hl),a		; $67d5
	inc hl			; $67d6
	ld (hl),$00		; $67d7
	ret			; $67d9
	ld a,(wCFD8+6)		; $67da
	cp $0c			; $67dd
	jp $5118		; $67df
	ld a,(wCFD8+6)		; $67e2
	cp $09			; $67e5
	ccf			; $67e7
	jp $5118		; $67e8
	ld bc,wInventoryB		; $67eb
	ld hl,$cfd7		; $67ee
	ld a,(bc)		; $67f1
	ldi (hl),a		; $67f2
	ld a,(wInventoryA)		; $67f3
	cp $0f			; $67f6
	jr nz,_label_15_157	; $67f8
	xor a			; $67fa
	ld (bc),a		; $67fb
	inc c			; $67fc
	ld a,(bc)		; $67fd
	ldi (hl),a		; $67fe
	ld a,$0f		; $67ff
	ld (bc),a		; $6801
	jr _label_15_158		; $6802
_label_15_157:
	ld a,$0f		; $6804
	ld (bc),a		; $6806
	inc c			; $6807
	ld a,(bc)		; $6808
	ldi (hl),a		; $6809
	xor a			; $680a
	ld (bc),a		; $680b
_label_15_158:
	ld c,$ba		; $680c
	ld a,(bc)		; $680e
	ldi (hl),a		; $680f
	ld a,$99		; $6810
	ld (bc),a		; $6812
	ld c,$c5		; $6813
	ld a,(bc)		; $6815
	ldi (hl),a		; $6816
	ld a,$01		; $6817
	ld (bc),a		; $6819
	ld a,$ff		; $681a
	ld (wStatusBarNeedsRefresh),a		; $681c
	ret			; $681f
	ld bc,wInventoryB		; $6820
	ld hl,$cfd7		; $6823
	ldi a,(hl)		; $6826
	ld (bc),a		; $6827
	inc c			; $6828
	ldi a,(hl)		; $6829
	ld (bc),a		; $682a
	ld c,$ba		; $682b
	ldi a,(hl)		; $682d
	ld (bc),a		; $682e
	ld c,$c5		; $682f
	ldi a,(hl)		; $6831
	ld (bc),a		; $6832
	ld a,$ff		; $6833
	ld (wStatusBarNeedsRefresh),a		; $6835
	ret			; $6838
	call getThisRoomFlags		; $6839
	bit 5,(hl)		; $683c
	ld a,$00		; $683e
	jr z,_label_15_159	; $6840
	call getRandomNumber		; $6842
	and $01			; $6845
	inc a			; $6847
_label_15_159:
	ld ($cfd4),a		; $6848
	ld hl,objectData.objectData7870		; $684b
	jp parseGivenObjectData		; $684e
	xor a			; $6851
_label_15_160:
	ldh (<hFF8B),a	; $6852
	ld hl,wCFD8+5		; $6854
	call checkFlag		; $6857
	jr nz,_label_15_161	; $685a
	call getFreeEnemySlot		; $685c
	ldh a,(<hFF8B)	; $685f
	ld (hl),$63		; $6861
	inc l			; $6863
	ld (hl),a		; $6864
_label_15_161:
	ldh a,(<hFF8B)	; $6865
	inc a			; $6867
	cp $05			; $6868
	jr nz,_label_15_160	; $686a
	ret			; $686c
	ld a,$5a		; $686d
	call checkQuestItemObtained		; $686f
	jr nc,_label_15_162	; $6872
	ld a,$45		; $6874
	call checkQuestItemObtained		; $6876
	jr nc,_label_15_163	; $6879
	xor a			; $687b
	jr _label_15_164		; $687c
_label_15_162:
	ld a,$02		; $687e
	jr _label_15_164		; $6880
_label_15_163:
	ld a,$01		; $6882
_label_15_164:
	ld e,$7e		; $6884
	ld (de),a		; $6886
	ret			; $6887
	ld b,$00		; $6888
	ld a,(wEssencesObtained)		; $688a
	bit 5,a			; $688d
	jr nz,_label_15_166	; $688f
	ld hl,$68dc		; $6891
_label_15_165:
	inc b			; $6894
	ldi a,(hl)		; $6895
	call checkQuestItemObtained		; $6896
	jr c,_label_15_166	; $6899
	ld a,b			; $689b
	cp $08			; $689c
	jr nz,_label_15_165	; $689e
_label_15_166:
	ld a,b			; $68a0
	cp $03			; $68a1
	jr nz,_label_15_167	; $68a3
	ld a,$5a		; $68a5
	call checkQuestItemObtained		; $68a7
	jr nc,_label_15_168	; $68aa
	ld b,$09		; $68ac
	jr _label_15_168		; $68ae
_label_15_167:
	cp $05			; $68b0
	jr c,_label_15_168	; $68b2
	push bc			; $68b4
	ld a,$03		; $68b5
	ld b,$3e		; $68b7
	call getRoomFlags		; $68b9
	pop bc			; $68bc
	bit 6,(hl)		; $68bd
	jr z,_label_15_168	; $68bf
	ld b,$0a		; $68c1
_label_15_168:
	ld a,(wAreaFlags)		; $68c3
	and $80			; $68c6
	jr z,_label_15_169	; $68c8
	ld a,$43		; $68ca
	add b			; $68cc
	ld b,$31		; $68cd
	ld c,a			; $68cf
	jp showText		; $68d0
_label_15_169:
	ld a,$4f		; $68d3
	add b			; $68d5
	ld b,$31		; $68d6
	ld c,a			; $68d8
	jp showText		; $68d9
	ld b,h			; $68dc
	ld e,c			; $68dd
	ld b,l			; $68de
	ld e,l			; $68df
	ld e,h			; $68e0
	ld e,(hl)		; $68e1
	ld e,e			; $68e2
	ld h,d			; $68e3
	ld l,$7e		; $68e4
	ld (hl),$01		; $68e6
	xor a			; $68e8
	ld l,$66		; $68e9
	ldi (hl),a		; $68eb
	ld (hl),a		; $68ec
	jp objectSetInvisible		; $68ed
	ld h,d			; $68f0
	ld l,$7e		; $68f1
	ld (hl),$00		; $68f3
	ld a,$06		; $68f5
	ld l,$66		; $68f7
	ldi (hl),a		; $68f9
	ld (hl),a		; $68fa
	jp objectSetVisible		; $68fb
	ld a,(w1Link.invincibilityCounter)		; $68fe
	or a			; $6901
	call $5118		; $6902
	cpl			; $6905
	ld ($cddb),a		; $6906
	ret			; $6909
	call getFreePartSlot		; $690a
	ret nz			; $690d
	ld (hl),$49		; $690e
	inc l			; $6910
	ld (hl),$ff		; $6911
	ret			; $6913
	call getFreeInteractionSlot		; $6914
	ret nz			; $6917
	ld (hl),$60		; $6918
	inc l			; $691a
	ld (hl),$49		; $691b
	inc l			; $691d
	ld (hl),$01		; $691e
	ld l,$4b		; $6920
	ld (hl),$60		; $6922
	ld l,$4d		; $6924
	ld (hl),$38		; $6926
	ret			; $6928
	ld h,d			; $6929
	ld l,$7a		; $692a
	dec (hl)		; $692c
	ret nz			; $692d
	ld l,$7b		; $692e
	ld a,(hl)		; $6930
	inc a			; $6931
	and $07			; $6932
	ld (hl),a		; $6934
	ldh (<hFF8B),a	; $6935
	ld bc,$695e		; $6937
	call addAToBc		; $693a
	ld a,(bc)		; $693d
	ld l,$7a		; $693e
	ld (hl),a		; $6940
	ldh a,(<hFF8B)	; $6941
	add a			; $6943
	ld bc,$6966		; $6944
	call addDoubleIndexToBc		; $6947
	ld a,$04		; $694a
_label_15_170:
	ldh (<hFF8D),a	; $694c
	ld a,(bc)		; $694e
	cp $ff			; $694f
	ret z			; $6951
	push bc			; $6952
	call $6986		; $6953
	pop bc			; $6956
	inc bc			; $6957
	ldh a,(<hFF8D)	; $6958
	dec a			; $695a
	jr nz,_label_15_170	; $695b
	ret			; $695d
	dec bc			; $695e
	dec bc			; $695f
	dec bc			; $6960
	ld d,$0b		; $6961
	dec bc			; $6963
	dec bc			; $6964
	dec bc			; $6965
	ld bc,$ff02		; $6966
	rst $38			; $6969
	inc bc			; $696a
	ld b,$ff		; $696b
	rst $38			; $696d
	inc b			; $696e
	dec b			; $696f
	rst $38			; $6970
	rst $38			; $6971
	rlca			; $6972
	rst $38			; $6973
	rst $38			; $6974
	rst $38			; $6975
	inc bc			; $6976
	ld b,$ff		; $6977
	rst $38			; $6979
	inc b			; $697a
	dec b			; $697b
	rst $38			; $697c
	rst $38			; $697d
	ld bc,$ff02		; $697e
	rst $38			; $6981
	nop			; $6982
	rst $38			; $6983
	rst $38			; $6984
	rst $38			; $6985
	ld bc,$699c		; $6986
	call addDoubleIndexToBc		; $6989
	call getFreeInteractionSlot		; $698c
	ret nz			; $698f
	ld (hl),$56		; $6990
	ld l,$4b		; $6992
	ld a,(bc)		; $6994
	ld (hl),a		; $6995
	inc bc			; $6996
	ld l,$4d		; $6997
	ld a,(bc)		; $6999
	ld (hl),a		; $699a
	ret			; $699b
	ld h,b			; $699c
	jr c,$48		; $699d
	jr z,_label_15_174	; $699f
	ld c,b			; $69a1
	jr c,$18		; $69a2
	jr c,_label_15_175	; $69a4
	ld e,b			; $69a6
	jr _label_15_176		; $69a7
	ld e,b			; $69a9
	ld b,b			; $69aa
	jr c,$21		; $69ab
	ld a,($ff00+c)		; $69ad
	ld l,c			; $69ae
	ld c,$11		; $69af
	jr _label_15_171		; $69b1
	ld hl,$6a0a		; $69b3
	ld c,$41		; $69b6
	jr _label_15_171		; $69b8
	ld hl,$6a22		; $69ba
	ld c,$11		; $69bd
	jr _label_15_171		; $69bf
	ld hl,$6a3a		; $69c1
	ld c,$41		; $69c4
	jr _label_15_171		; $69c6
	ld hl,$6a52		; $69c8
	ld c,$11		; $69cb
	jr _label_15_171		; $69cd
	ld hl,$6a52		; $69cf
	ld c,$41		; $69d2
_label_15_171:
	ld a,$03		; $69d4
_label_15_172:
	ldh (<hFF93),a	; $69d6
	ld a,$08		; $69d8
_label_15_173:
	ldh (<hFF92),a	; $69da
	ldi a,(hl)		; $69dc
	push hl			; $69dd
	call setTile		; $69de
	pop hl			; $69e1
	inc c			; $69e2
	ldh a,(<hFF92)	; $69e3
	dec a			; $69e5
	jr nz,_label_15_173	; $69e6
	ld a,c			; $69e8
_label_15_174:
	add $08			; $69e9
	ld c,a			; $69eb
	ldh a,(<hFF93)	; $69ec
	dec a			; $69ee
	jr nz,_label_15_172	; $69ef
	ret			; $69f1
	rla			; $69f2
	ld d,a			; $69f3
	ld d,a			; $69f4
	ld d,a			; $69f5
	ld d,l			; $69f6
	ld d,l			; $69f7
	ld d,l			; $69f8
	ld d,(hl)		; $69f9
	ld d,(hl)		; $69fa
	ld d,a			; $69fb
	ld d,a			; $69fc
	ld d,h			; $69fd
_label_15_175:
	ld d,h			; $69fe
	rla			; $69ff
	ld d,l			; $6a00
_label_15_176:
	ld d,(hl)		; $6a01
	ld d,l			; $6a02
	ld d,l			; $6a03
	ld d,h			; $6a04
	ld d,h			; $6a05
	ld d,h			; $6a06
	ld d,h			; $6a07
	ld d,a			; $6a08
	ld d,a			; $6a09
	ld d,l			; $6a0a
	rla			; $6a0b
	ld d,(hl)		; $6a0c
	ld d,(hl)		; $6a0d
	ld d,(hl)		; $6a0e
	ld d,(hl)		; $6a0f
	ld d,a			; $6a10
	rla			; $6a11
	ld d,h			; $6a12
	ld d,a			; $6a13
	ld d,a			; $6a14
	ld d,(hl)		; $6a15
	rla			; $6a16
	ld d,l			; $6a17
	ld d,l			; $6a18
	ld d,h			; $6a19
	ld d,a			; $6a1a
	ld d,a			; $6a1b
	ld d,a			; $6a1c
	ld d,a			; $6a1d
	ld d,l			; $6a1e
	ld d,l			; $6a1f
	ld d,l			; $6a20
	ld d,h			; $6a21
	ld d,(hl)		; $6a22
	ld d,h			; $6a23
	ld d,(hl)		; $6a24
	ld d,h			; $6a25
	ld d,(hl)		; $6a26
	rla			; $6a27
	ld d,(hl)		; $6a28
	ld d,h			; $6a29
	ld d,(hl)		; $6a2a
	ld d,h			; $6a2b
	rla			; $6a2c
	ld d,h			; $6a2d
	ld d,(hl)		; $6a2e
	ld d,h			; $6a2f
	ld d,(hl)		; $6a30
	ld d,h			; $6a31
	ld d,(hl)		; $6a32
	ld d,h			; $6a33
	ld d,(hl)		; $6a34
	ld d,h			; $6a35
	ld d,(hl)		; $6a36
	ld d,h			; $6a37
	rla			; $6a38
	ld d,h			; $6a39
_label_15_177:
	ld d,h			; $6a3a
	ld d,(hl)		; $6a3b
	ld d,h			; $6a3c
	ld d,(hl)		; $6a3d
	ld d,h			; $6a3e
	ld d,(hl)		; $6a3f
	ld d,h			; $6a40
	ld d,(hl)		; $6a41
	ld d,h			; $6a42
	ld d,(hl)		; $6a43
	ld d,h			; $6a44
	ld d,(hl)		; $6a45
	rla			; $6a46
	ld d,(hl)		; $6a47
	ld d,h			; $6a48
	ld d,(hl)		; $6a49
	ld d,h			; $6a4a
	rla			; $6a4b
	ld d,h			; $6a4c
	ld d,(hl)		; $6a4d
	ld d,h			; $6a4e
	ld d,(hl)		; $6a4f
	ld d,h			; $6a50
	ld d,(hl)		; $6a51
	rst $28			; $6a52
	rst $28			; $6a53
	rst $28			; $6a54
	rst $28			; $6a55
	rst $28			; $6a56
	rst $28			; $6a57
	rst $28			; $6a58
	rst $28			; $6a59
	rst $28			; $6a5a
	rst $28			; $6a5b
	rst $28			; $6a5c
	rst $28			; $6a5d
	rst $28			; $6a5e
	rst $28			; $6a5f
	rst $28			; $6a60
	rst $28			; $6a61
	rst $28			; $6a62
	rst $28			; $6a63
	rst $28			; $6a64
	rst $28			; $6a65
	rst $28			; $6a66
	rst $28			; $6a67
	rst $28			; $6a68
	rst $28			; $6a69
	ld hl,$6a7d		; $6a6a
	rst_addAToHl			; $6a6d
	ld c,$73		; $6a6e
_label_15_178:
	ldi a,(hl)		; $6a70
	push hl			; $6a71
	call setTile		; $6a72
	pop hl			; $6a75
	inc c			; $6a76
	ld a,c			; $6a77
	cp $77			; $6a78
	jr nz,_label_15_178	; $6a7a
	ret			; $6a7c
	or l			; $6a7d
	rst $28			; $6a7e
	rst $28			; $6a7f
	or h			; $6a80
	or d			; $6a81
	or d			; $6a82
	or d			; $6a83
	or d			; $6a84
	cp l			; $6a85
	adc (hl)		; $6a86
	ld (hl),c		; $6a87
	nop			; $6a88
	or b			; $6a89
	ld b,b			; $6a8a
	scf			; $6a8b
	ld l,e			; $6a8c
	or b			; $6a8d
	add b			; $6a8e
	adc $6a			; $6a8f
	pop hl			; $6a91
	ret nc			; $6a92
	ld h,e			; $6a93
	sub b			; $6a94
	or $df			; $6a95
	ld e,e			; $6a97
	and b			; $6a98
	ld l,d			; $6a99
	pop hl			; $6a9a
	ret nc			; $6a9b
	ld h,e			; $6a9c
	sub c			; $6a9d
	ld l,a			; $6a9e
	rlca			; $6a9f
	pop hl			; $6aa0
	ret nc			; $6aa1
	ld h,e			; $6aa2
	sub d			; $6aa3
	or $8b			; $6aa4
	inc d			; $6aa6
	pop hl			; $6aa7
	dec de			; $6aa8
	ld h,l			; $6aa9
	inc bc			; $6aaa
	adc c			; $6aab
	jr _label_15_177		; $6aac
	ld hl,$028f		; $6aae
	or $e1			; $6ab1
	ret nc			; $6ab3
	ld h,e			; $6ab4
	sub e			; $6ab5
	or $b1			; $6ab6
	add b			; $6ab8
	ld ($ff00+R_NR41),a	; $6ab9
	ld h,e			; $6abb
	rst_jumpTable			; $6abc
.DB $db				; $6abd
	call $c880		; $6abe
	ld l,d			; $6ac1
	rst_addDoubleIndex			; $6ac2
	ld e,h			; $6ac3
	ld a,($ff00+c)		; $6ac4
	ld l,d			; $6ac5
	ld l,a			; $6ac6
	rlca			; $6ac7
	rst_addDoubleIndex			; $6ac8
	ld e,(hl)		; $6ac9
	ld a,($ff00+c)		; $6aca
	ld l,d			; $6acb
	ld l,a			; $6acc
	rlca			; $6acd
	set 0,b			; $6ace
	rst $8			; $6ad0
	ld bc,$6b05		; $6ad1
	pop hl			; $6ad4
	ret nc			; $6ad5
	ld h,e			; $6ad6
	sub h			; $6ad7
	or $e0			; $6ad8
	jr nz,_label_15_179	; $6ada
	rst_jumpTable			; $6adc
.DB $db				; $6add
	call $e880		; $6ade
	ld l,d			; $6ae1
	rst_addDoubleIndex			; $6ae2
	ld e,h			; $6ae3
	ld a,($ff00+c)		; $6ae4
	ld l,d			; $6ae5
	ld l,d			; $6ae6
.DB $ec				; $6ae7
	rst_addDoubleIndex			; $6ae8
	ld e,(hl)		; $6ae9
	ld a,($ff00+c)		; $6aea
	ld l,d			; $6aeb
	pop hl			; $6aec
	ret nc			; $6aed
	ld h,e			; $6aee
	sub l			; $6aef
	ld l,a			; $6af0
	rlca			; $6af1
	pop hl			; $6af2
	ret nc			; $6af3
	ld h,e			; $6af4
	sub (hl)		; $6af5
	or $c3			; $6af6
	nop			; $6af8
	stop			; $6af9
	ld l,e			; $6afa
	pop hl			; $6afb
	ret nc			; $6afc
	ld h,e			; $6afd
	sub a			; $6afe
	sub c			; $6aff
	ret nz			; $6b00
	rst $8			; $6b01
	ld bc,$076f		; $6b02
	pop hl			; $6b05
	ret nc			; $6b06
	ld h,e			; $6b07
	sbc b			; $6b08
	or $c3			; $6b09
	nop			; $6b0b
	stop			; $6b0c
	ld l,e			; $6b0d
	ld l,d			; $6b0e
	ei			; $6b0f
	pop hl			; $6b10
	ret nc			; $6b11
	ld h,e			; $6b12
	sbc c			; $6b13
	or $e0			; $6b14
	jr nz,_label_15_180	; $6b16
	rst_jumpTable			; $6b18
.DB $db				; $6b19
	call $2780		; $6b1a
	ld l,e			; $6b1d
	pop hl			; $6b1e
	inc sp			; $6b1f
	rla			; $6b20
	ld e,h			; $6b21
	sbc $5d			; $6b22
	nop			; $6b24
	ld l,e			; $6b25
	ld l,$e1		; $6b26
	inc sp			; $6b28
	rla			; $6b29
	ld e,(hl)		; $6b2a
	sbc $5c			; $6b2b
	nop			; $6b2d
	or c			; $6b2e
	ld b,b			; $6b2f
	or $e1			; $6b30
	ret nc			; $6b32
	ld h,e			; $6b33
	sbc d			; $6b34
	ld l,a			; $6b35
	rlca			; $6b36
	pop hl			; $6b37
	ret nc			; $6b38
	ld h,e			; $6b39
	sbc e			; $6b3a
	ld l,a			; $6b3b
	rlca			; $6b3c
.DB $eb				; $6b3d
	pop hl			; $6b3e
_label_15_179:
	ld l,c			; $6b3f
	ld h,d			; $6b40
	ld (bc),a		; $6b41
	rst_jumpTable			; $6b42
.DB $db				; $6b43
	call $5880		; $6b44
	ld l,e			; $6b47
	sbc h			; $6b48
	ld ($9e27),sp		; $6b49
	ld ($ff00+$a8),a	; $6b4c
	ld e,h			; $6b4e
	sbc l			; $6b4f
	di			; $6b50
	adc a			; $6b51
	ld (bc),a		; $6b52
	sbc h			; $6b53
	ld a,(bc)		; $6b54
	daa			; $6b55
	ld l,e			; $6b56
	ld c,e			; $6b57
	sbc (hl)		; $6b58
	cp l			; $6b59
	or b			; $6b5a
	jr nz,$7a		; $6b5b
	ld l,e			; $6b5d
	sbc b			; $6b5e
	stop			; $6b5f
	or $c8			; $6b60
	ld a,(bc)		; $6b62
	ld h,a			; $6b63
	ld l,e			; $6b64
	ld l,e			; $6b65
	ld a,h			; $6b66
	sbc b			; $6b67
	ld de,$c3f6		; $6b68
	nop			; $6b6b
	ld (hl),d		; $6b6c
	ld l,e			; $6b6d
	sbc b			; $6b6e
	inc de			; $6b6f
	ld l,e			; $6b70
	ld a,h			; $6b71
	sbc b			; $6b72
	ld (de),a		; $6b73
	or $de			; $6b74
	ld b,c			; $6b76
	ld a,(bc)		; $6b77
	ld l,e			; $6b78
	ld a,h			; $6b79
	sbc b			; $6b7a
_label_15_180:
	inc d			; $6b7b
	cp (hl)			; $6b7c
	ld l,e			; $6b7d
	ld e,b			; $6b7e
	ld a,GLOBALFLAG_43		; $6b7f
	jp setGlobalFlag		; $6b81
	ld hl,objectData.objectData78a9		; $6b84
	jp parseGivenObjectData		; $6b87
	ld hl,$c738		; $6b8a
	res 0,(hl)		; $6b8d
	ld hl,$c848		; $6b8f
	set 0,(hl)		; $6b92
	ret			; $6b94
	ld hl,w1Link.yh		; $6b95
	call $6ba4		; $6b98
	ld a,$01		; $6b9b
	jr nc,_label_15_181	; $6b9d
	xor a			; $6b9f
_label_15_181:
	or a			; $6ba0
	jp $5118		; $6ba1
	ldi a,(hl)		; $6ba4
	sub $22			; $6ba5
	cp $54			; $6ba7
	ret nc			; $6ba9
	inc l			; $6baa
	ld a,(hl)		; $6bab
	sub $14			; $6bac
	cp $84			; $6bae
	ret			; $6bb0
	push af			; $6bb1
	ld a,$08		; $6bb2
	call func_2acf		; $6bb4
	ld l,$02		; $6bb7
	ld (hl),$05		; $6bb9
	ld l,$03		; $6bbb
	pop af			; $6bbd
	ld (hl),a		; $6bbe
	ret			; $6bbf
	ld a,($c783)		; $6bc0
	bit 7,a			; $6bc3
	jp $5118		; $6bc5
	ld hl,w1Link.zh		; $6bc8
	ld a,(hl)		; $6bcb
	or a			; $6bcc
	ret nz			; $6bcd
	ld a,(wLinkGrabState)		; $6bce
	or a			; $6bd1
	ret nz			; $6bd2
	ld c,$0e		; $6bd3
	call objectCheckLinkWithinDistance		; $6bd5
	ld a,$01		; $6bd8
	jr c,_label_15_182	; $6bda
	xor a			; $6bdc
_label_15_182:
	ld e,$78		; $6bdd
	ld (de),a		; $6bdf
	ret			; $6be0
	ld hl,wC6b1		; $6be1
	ldd a,(hl)		; $6be4
	ld (hl),a		; $6be5
	ret			; $6be6
	cp l			; $6be7
	ld ($ff00+$b2),a	; $6be8
_label_15_183:
	inc c			; $6bea
	sub c			; $6beb
	sub c			; $6bec
	call z,$e001		; $6bed
	add h			; $6bf0
	ld l,e			; $6bf1
	ld hl,sp-$7c		; $6bf2
	dec b			; $6bf4
	nop			; $6bf5
	ld e,b			; $6bf6
	jr z,_label_15_183	; $6bf7
	rst $20			; $6bf9
	ld d,d			; $6bfa
	ld sp,hl		; $6bfb
	sub c			; $6bfc
	ret nz			; $6bfd
	rst $8			; $6bfe
	ld bc,$c0d5		; $6bff
	rst $8			; $6c02
	ld (bc),a		; $6c03
	or $98			; $6c04
	ld (de),a		; $6c06
	ld (bc),a		; $6c07
	or $91			; $6c08
	ret nz			; $6c0a
	rst $8			; $6c0b
	inc bc			; $6c0c
	push de			; $6c0d
	ret nz			; $6c0e
	rst $8			; $6c0f
	inc b			; $6c10
	or $98			; $6c11
	dec b			; $6c13
	ret nc			; $6c14
	or $e4			; $6c15
	ld hl,$c091		; $6c17
	rst $8			; $6c1a
	dec b			; $6c1b
	cp (hl)			; $6c1c
	adc l			; $6c1d
	inc b			; $6c1e
	ld d,b			; $6c1f
.DB $db				; $6c20
	cp l			; $6c21
	pop hl			; $6c22
	halt			; $6c23
	ld d,c			; $6c24
	nop			; $6c25
	sub c			; $6c26
	ret nz			; $6c27
	rst $8			; $6c28
	ld b,$d5		; $6c29
	ret nz			; $6c2b
	rst $8			; $6c2c
	ld ($98f6),sp		; $6c2d
	ld (de),a		; $6c30
	inc bc			; $6c31
.DB $e3				; $6c32
	ret z			; $6c33
	rst $30			; $6c34
	sub c			; $6c35
	ret nz			; $6c36
	rst $8			; $6c37
	add hl,bc		; $6c38
	rst_addAToHl			; $6c39
	ld (bc),a		; $6c3a
	cp (hl)			; $6c3b
	add a			; $6c3c
	pop de			; $6c3d
	call $6c4b		; $6c3e
	ld b,l			; $6c41
	ld l,h			; $6c42
	inc a			; $6c43
	ld l,h			; $6c44
	push af			; $6c45
	sbc b			; $6c46
	dec b			; $6c47
	pop de			; $6c48
	jp nc,$98f5		; $6c49
	dec b			; $6c4c
	jp nc,$bdf6		; $6c4d
	ld ($ff00+$b2),a	; $6c50
	inc c			; $6c52
	push af			; $6c53
.DB $e3				; $6c54
	ret z			; $6c55
	push af			; $6c56
.DB $e3				; $6c57
	ret z			; $6c58
	push af			; $6c59
.DB $e3				; $6c5a
	ret z			; $6c5b
	or $e1			; $6c5c
	or c			; $6c5e
	ld l,e			; $6c5f
	nop			; $6c60
	ld a,($ff00+$d5)	; $6c61
	ld bc,$00d0		; $6c63
	or $98			; $6c66
	dec b			; $6c68
.DB $d3				; $6c69
	or $84			; $6c6a
	halt			; $6c6c
	ld bc,$0000		; $6c6d
	or b			; $6c70
	add b			; $6c71
	ld (hl),a		; $6c72
	ld l,h			; $6c73
	ld a,($ff00+$6c)	; $6c74
	ld (hl),b		; $6c76
	rst $30			; $6c77
	or (hl)			; $6c78
	ccf			; $6c79
	sbc b			; $6c7a
	dec b			; $6c7b
	sub $91			; $6c7c
	rst $20			; $6c7e
	add $d6			; $6c7f
	or (hl)			; $6c81
	ld (de),a		; $6c82
	ld ($ff00+R_HDMA3),a	; $6c83
	ld a,$e0		; $6c85
	adc d			; $6c87
	ld l,e			; $6c88
.DB $e4				; $6c89
	rst $38			; $6c8a
	cp (hl)			; $6c8b
	ld a,($ff00+$e0)	; $6c8c
	sub l			; $6c8e
	ld l,e			; $6c8f
	rst_jumpTable			; $6c90
.DB $db				; $6c91
	call $8c80		; $6c92
	ld l,h			; $6c95
	sbc b			; $6c96
	dec b			; $6c97
	call nc,$9191		; $6c98
	call z,$0000		; $6c9b
	ld b,a			; $6c9e
	call getFreeInteractionSlot		; $6c9f
	ret nz			; $6ca2
	ld (hl),$49		; $6ca3
	ld l,$43		; $6ca5
	ld (hl),b		; $6ca7
	ret			; $6ca8
	ld a,($cfd1)		; $6ca9
	ld bc,$0003		; $6cac
_label_15_184:
	rrca			; $6caf
	jr nc,_label_15_185	; $6cb0
	inc b			; $6cb2
_label_15_185:
	dec c			; $6cb3
	jr nz,_label_15_184	; $6cb4
	ld a,b			; $6cb6
	ld hl,$6cc1		; $6cb7
	rst_addAToHl			; $6cba
	ld c,(hl)		; $6cbb
	ld b,$11		; $6cbc
	jp showText		; $6cbe
	dec b			; $6cc1
	ld b,$07		; $6cc2
	ld hl,w1Link.direction		; $6cc4
	ld (hl),$03		; $6cc7
	inc l			; $6cc9
	ld (hl),$18		; $6cca
	ld a,$0b		; $6ccc
	ld (wLinkForceState),a		; $6cce
	ld a,$08		; $6cd1
	ld (wLinkStateParameter),a		; $6cd3
	ret			; $6cd6
	pop hl			; $6cd7
	sbc (hl)		; $6cd8
	ld l,h			; $6cd9
	nop			; $6cda
	push af			; $6cdb
	pop hl			; $6cdc
	sbc (hl)		; $6cdd
	ld l,h			; $6cde
	ld bc,$e1f5		; $6cdf
	sbc (hl)		; $6ce2
	ld l,h			; $6ce3
	ld (bc),a		; $6ce4
	push de			; $6ce5
	jp nc,$03cf		; $6ce6
	push af			; $6ce9
	sbc b			; $6cea
	ld de,$f200		; $6ceb
	sbc b			; $6cee
	ld de,$f201		; $6cef
	sbc b			; $6cf2
	ld de,$f202		; $6cf3
	sbc b			; $6cf6
	ld de,$9903		; $6cf7
	sub c			; $6cfa
	jp nc,$00cf		; $6cfb
	push de			; $6cfe
	jp nc,$03cf		; $6cff
	nop			; $6d02
	push de			; $6d03
	jp nc,$01cf		; $6d04
	push af			; $6d07
	ld ($ff00+$a9),a	; $6d08
	ld l,h			; $6d0a
	sub c			; $6d0b
	jp nc,$00cf		; $6d0c
	push de			; $6d0f
	jp nc,$01cf		; $6d10
	nop			; $6d13
	adc l			; $6d14
	jr nz,_label_15_186	; $6d15
	sbc e			; $6d17
_label_15_186:
.DB $db				; $6d18
	sbc b			; $6d19
	ld de,$c30c		; $6d1a
	nop			; $6d1d
	ld h,$6d		; $6d1e
	ld ($ff00+$c4),a	; $6d20
	ld l,h			; $6d22
	di			; $6d23
	ld l,l			; $6d24
	jr _label_15_187		; $6d25
_label_15_187:
	ld a,$0b		; $6d27
	ld (wLinkForceState),a		; $6d29
	ld a,$08		; $6d2c
	ld (wLinkStateParameter),a		; $6d2e
	ld hl,w1Link.direction		; $6d31
	xor a			; $6d34
	ldi (hl),a		; $6d35
	ld (hl),a		; $6d36
	ret			; $6d37
	ld a,$f0		; $6d38
	call playSound		; $6d3a
	ld a,$18		; $6d3d
	ld bc,$f408		; $6d3f
	jp objectCreateExclamationMark		; $6d42
	ld h,d			; $6d45
	ld l,$4b		; $6d46
	ld b,(hl)		; $6d48
	ld l,$4d		; $6d49
	ld c,(hl)		; $6d4b
	ld a,$ff		; $6d4c
	jp createEnergySwirlGoingIn		; $6d4e
	ld b,a			; $6d51
	call getFreeInteractionSlot		; $6d52
	ret nz			; $6d55
	ld (hl),$6e		; $6d56
	inc l			; $6d58
	ld (hl),$04		; $6d59
	inc l			; $6d5b
	ld (hl),b		; $6d5c
	ret			; $6d5d
	ld hl,$6d6a		; $6d5e
	rst_addDoubleIndex			; $6d61
	ld e,$54		; $6d62
	ldi a,(hl)		; $6d64
	ld (de),a		; $6d65
	inc e			; $6d66
	ld a,(hl)		; $6d67
	ld (de),a		; $6d68
	ret			; $6d69
	add b			; $6d6a
	cp $00			; $6d6b
	rst $38			; $6d6d
	ld hl,$6d7a		; $6d6e
	rst_addDoubleIndex			; $6d71
_label_15_188:
	ld e,$49		; $6d72
	ldi a,(hl)		; $6d74
	ld (de),a		; $6d75
_label_15_189:
	ld a,(hl)		; $6d76
	jp interactionSetAnimation		; $6d77
	jr _label_15_190		; $6d7a
	nop			; $6d7c
	stop			; $6d7d
	nop			; $6d7e
	inc c			; $6d7f
	ld ($180d),sp		; $6d80
	rrca			; $6d83
	ld e,$50		; $6d84
	ld a,$0a		; $6d86
	ld (de),a		; $6d88
	ld e,$43		; $6d89
	ld a,(de)		; $6d8b
	ld hl,$6d92		; $6d8c
_label_15_190:
	rst_addDoubleIndex			; $6d8f
	jr _label_15_188		; $6d90
	rrca			; $6d92
	ld c,$12		; $6d93
	ld c,$07		; $6d95
	dec c			; $6d97
	ld a,(de)		; $6d98
	rrca			; $6d99
	ld (bc),a		; $6d9a
	inc c			; $6d9b
	ld e,$0c		; $6d9c
	ld e,$43		; $6d9e
	ld a,(de)		; $6da0
	ld hl,$6da7		; $6da1
	rst_addAToHl			; $6da4
	jr _label_15_189		; $6da5
	ld c,$0e		; $6da7
	ld c,$0f		; $6da9
	dec c			; $6dab
	rrca			; $6dac
	ld e,$78		; $6dad
	ld a,(de)		; $6daf
	or a			; $6db0
	jr z,_label_15_191	; $6db1
	ld ($d13f),a		; $6db3
_label_15_191:
	ld bc,$f000		; $6db6
	ld a,$1e		; $6db9
	jp objectCreateExclamationMark		; $6dbb
	call objectGetLinkRelativeAngle		; $6dbe
	ld e,$49		; $6dc1
	call convertAngleToDirection		; $6dc3
	add $01			; $6dc6
	ld ($d13f),a		; $6dc8
	ret			; $6dcb
	ld a,(wActiveMusic2)		; $6dcc
	ld (wActiveMusic),a		; $6dcf
	jp playSound		; $6dd2
	ld bc,$4903		; $6dd5
	call objectCreateInteraction		; $6dd8
	ld l,$43		; $6ddb
	ld (hl),$0f		; $6ddd
	ret			; $6ddf
	ld hl,$6de6		; $6de0
	jp setWarpDestVariables		; $6de3
	add b			; $6de6
	ld h,e			; $6de7
	nop			; $6de8
	ld d,(hl)		; $6de9
	inc bc			; $6dea
	ld a,$48		; $6deb
	jp removeQuestItemFromInventory		; $6ded
	push de			; $6df0
	jp nc,$02cf		; $6df1
	sbc b			; $6df4
	ld de,$9126		; $6df5
	jp nc,$00cf		; $6df8
	push de			; $6dfb
	jp nc,$01cf		; $6dfc
	cp (hl)			; $6dff
	nop			; $6e00
	rst_jumpTable			; $6e01
	ld b,a			; $6e02
	add $01			; $6e03
	ld d,$6e		; $6e05
	rst_jumpTable			; $6e07
	ld a,$d1		; $6e08
	ld (bc),a		; $6e0a
	rrca			; $6e0b
	ld l,(hl)		; $6e0c
	ld l,(hl)		; $6e0d
	rlca			; $6e0e
	sbc b			; $6e0f
	ld hl,$9200		; $6e10
	ld b,a			; $6e13
	add $01			; $6e14
	push de			; $6e16
	dec a			; $6e17
	pop de			; $6e18
	ld bc,$47c7		; $6e19
	add $02			; $6e1c
	ldi a,(hl)		; $6e1e
	ld l,(hl)		; $6e1f
	sbc b			; $6e20
	ld hl,$9100		; $6e21
	dec a			; $6e24
	pop de			; $6e25
	nop			; $6e26
	cp (hl)			; $6e27
	ld (hl),h		; $6e28
.DB $e3				; $6e29
	cp l			; $6e2a
	rl b			; $6e2b
	add $0c			; $6e2d
	ld (hl),$6e		; $6e2f
	sbc b			; $6e31
	ld hl,$6e01		; $6e32
	add hl,sp		; $6e35
	sbc b			; $6e36
	ld hl,$9102		; $6e37
	inc bc			; $6e3a
	pop de			; $6e3b
	ld bc,$d5b9		; $6e3c
	inc l			; $6e3f
	call z,$98d1		; $6e40
	ld hl,$9206		; $6e43
	ld b,a			; $6e46
	add $20			; $6e47
	cp (hl)			; $6e49
	nop			; $6e4a
	sbc b			; $6e4b
	ld de,$d520		; $6e4c
	jp nc,$02cf		; $6e4f
	sbc b			; $6e52
	ld de,$c321		; $6e53
	nop			; $6e56
	ld h,b			; $6e57
	ld l,(hl)		; $6e58
	sbc b			; $6e59
	ld de,$c321		; $6e5a
	ld bc,$6e59		; $6e5d
	sbc b			; $6e60
	ld de,$9130		; $6e61
	jp nc,$00cf		; $6e64
	push de			; $6e67
	jp nc,$01cf		; $6e68
	or c			; $6e6b
	ld b,b			; $6e6c
	or (hl)			; $6e6d
	xor e			; $6e6e
	or (hl)			; $6e6f
	ld b,d			; $6e70
	cp (hl)			; $6e71
	nop			; $6e72
	push de			; $6e73
	dec a			; $6e74
	pop de			; $6e75
	ld bc,$c7bd		; $6e76
	ld b,(hl)		; $6e79
	add $01			; $6e7a
	sub b			; $6e7c
	ld l,(hl)		; $6e7d
	sub d			; $6e7e
	ld b,(hl)		; $6e7f
	add $01			; $6e80
	rl b			; $6e82
	add $0b			; $6e84
	adc l			; $6e86
	ld l,(hl)		; $6e87
	sbc b			; $6e88
	jr nz,_label_15_192	; $6e89
_label_15_192:
	ld l,(hl)		; $6e8b
	sub b			; $6e8c
	sbc b			; $6e8d
	jr nz,_label_15_193	; $6e8e
	rst_addDoubleIndex			; $6e90
_label_15_193:
	ld c,b			; $6e91
	sbc (hl)		; $6e92
	ld l,(hl)		; $6e93
	sbc b			; $6e94
	jr nz,_label_15_194	; $6e95
	sub c			; $6e97
	dec a			; $6e98
	pop de			; $6e99
_label_15_194:
	nop			; $6e9a
	cp (hl)			; $6e9b
	ld (hl),h		; $6e9c
	rst_addDoubleIndex			; $6e9d
	sbc b			; $6e9e
	jr nz,_label_15_195	; $6e9f
	ld ($ff00+$eb),a	; $6ea1
	ld l,l			; $6ea3
	sub c			; $6ea4
_label_15_195:
	inc bc			; $6ea5
	pop de			; $6ea6
	ld bc,$d5b9		; $6ea7
	inc l			; $6eaa
	call z,$98d1		; $6eab
	jr nz,_label_15_196	; $6eae
	sub d			; $6eb0
	ld b,(hl)		; $6eb1
	add $20			; $6eb2
	cp h			; $6eb4
_label_15_196:
	nop			; $6eb5
	cp l			; $6eb6
	sbc b			; $6eb7
	ld de,$f62b		; $6eb8
	sbc b			; $6ebb
	ld de,$f62c		; $6ebc
	sbc b			; $6ebf
	ld de,$f62d		; $6ec0
	sbc b			; $6ec3
	ld de,$f62e		; $6ec4
	sbc b			; $6ec7
	ld de,$912f		; $6ec8
	jp nc,$00cf		; $6ecb
	set 2,d			; $6ece
	rst $8			; $6ed0
	inc bc			; $6ed1
	rst_addAToHl			; $6ed2
	ld l,(hl)		; $6ed3
	ld a,($ff00+$6e)	; $6ed4
	adc $98			; $6ed6
	ld de,$8e31		; $6ed8
	ld b,h			; $6edb
	ld (bc),a		; $6edc
	sbc c			; $6edd
	sbc b			; $6ede
	ld de,$9132		; $6edf
	inc bc			; $6ee2
	pop de			; $6ee3
	ld bc,$23b6		; $6ee4
	push de			; $6ee7
	inc l			; $6ee8
	call z,$b6d1		; $6ee9
	dec hl			; $6eec
	cp (hl)			; $6eed
	nop			; $6eee
	push de			; $6eef
	dec a			; $6ef0
	pop de			; $6ef1
	ld bc,$98bd		; $6ef2
	ld de,$e031		; $6ef5
	xor l			; $6ef8
	ld l,l			; $6ef9
	ld hl,sp-$68		; $6efa
	ld de,$e032		; $6efc
	push de			; $6eff
	ld l,l			; $6f00
	set 2,d			; $6f01
	rst $8			; $6f03
	ld (bc),a		; $6f04
	ld a,(bc)		; $6f05
	ld l,a			; $6f06
	ld a,($ff00+$6f)	; $6f07
	ld bc,$1198		; $6f09
	ldi a,(hl)		; $6f0c
	or (hl)			; $6f0d
	inc h			; $6f0e
	ld ($ff00+$e0),a	; $6f0f
	ld l,l			; $6f11
	nop			; $6f12
	ld hl,$6f1f		; $6f13
	rst_addDoubleIndex			; $6f16
	ld e,$49		; $6f17
	ldi a,(hl)		; $6f19
	ld (de),a		; $6f1a
	ld a,(hl)		; $6f1b
	jp interactionSetAnimation		; $6f1c
	nop			; $6f1f
	inc b			; $6f20
	ld ($1005),sp		; $6f21
	ld b,$18		; $6f24
	rlca			; $6f26
	call getFreeInteractionSlot		; $6f27
	ret nz			; $6f2a
	ld (hl),$8a		; $6f2b
	ld l,$43		; $6f2d
	ld (hl),$06		; $6f2f
	ret			; $6f31
	ld e,$50		; $6f32
	ld a,$32		; $6f34
	ld (de),a		; $6f36
	ld e,$49		; $6f37
	ld a,$18		; $6f39
	ld (de),a		; $6f3b
	ret			; $6f3c
	ld c,$02		; $6f3d
	ld a,$15		; $6f3f
	jr _label_15_198		; $6f41
	ld c,$03		; $6f43
	ld a,$15		; $6f45
	jr _label_15_198		; $6f47
	ld b,$17		; $6f49
	jr _label_15_197		; $6f4b
	ld b,$16		; $6f4d
_label_15_197:
	ld e,$7c		; $6f4f
	ld a,$15		; $6f51
	ld (de),a		; $6f53
	ld c,$02		; $6f54
	ld a,b			; $6f56
_label_15_198:
	ld e,$7b		; $6f57
	ld (de),a		; $6f59
	call $6f77		; $6f5a
	ld e,$7b		; $6f5d
	ld a,(de)		; $6f5f
	call removeQuestItemFromInventory		; $6f60
	ret			; $6f63
	ld e,$7c		; $6f64
	ld a,$01		; $6f66
	ld (de),a		; $6f68
	ld e,$42		; $6f69
	ld a,(de)		; $6f6b
	sub $04			; $6f6c
	ld c,a			; $6f6e
	jr _label_15_199		; $6f6f
	ld c,$03		; $6f71
	jr _label_15_199		; $6f73
	ld c,$02		; $6f75
_label_15_199:
	ld e,$7c		; $6f77
	ld a,(de)		; $6f79
	ld b,a			; $6f7a
	call createTreasure		; $6f7b
	ld l,$4b		; $6f7e
	ld a,(w1Link.yh)		; $6f80
	ldi (hl),a		; $6f83
	inc l			; $6f84
	ld a,(w1Link.xh)		; $6f85
	ld (hl),a		; $6f88
	ret			; $6f89
	ld l,$ba		; $6f8a
	jr _label_15_200		; $6f8c
	ld l,$bd		; $6f8e
_label_15_200:
	ld h,$c6		; $6f90
	ld a,(hl)		; $6f92
	sub $10			; $6f93
	daa			; $6f95
	ld (hl),a		; $6f96
	ld a,$ff		; $6f97
	ld (wStatusBarNeedsRefresh),a		; $6f99
	ret			; $6f9c
	ld b,$04		; $6f9d
_label_15_201:
	call getFreeInteractionSlot		; $6f9f
	ret nz			; $6fa2
	ld (hl),$83		; $6fa3
	inc l			; $6fa5
	inc (hl)		; $6fa6
	inc l			; $6fa7
	dec b			; $6fa8
	ld (hl),b		; $6fa9
	jr nz,_label_15_201	; $6faa
	ret			; $6fac
	call getFreePartSlot		; $6fad
	ret nz			; $6fb0
	dec l			; $6fb1
	set 7,(hl)		; $6fb2
	inc l			; $6fb4
	ld (hl),$27		; $6fb5
	inc l			; $6fb7
	inc (hl)		; $6fb8
	ld l,$cb		; $6fb9
	ldh a,(<hEnemyTargetY)	; $6fbb
	ldi (hl),a		; $6fbd
	inc l			; $6fbe
	ldh a,(<hEnemyTargetX)	; $6fbf
	ld (hl),a		; $6fc1
	ret			; $6fc2
	ld hl,wLinkHealth		; $6fc3
	ld a,(hl)		; $6fc6
	cp $04			; $6fc7
	ret c			; $6fc9
	ld (hl),$04		; $6fca
_label_15_202:
	ld a,$02		; $6fcc
	ld ($cc50),a		; $6fce
	ret			; $6fd1
	ld a,$01		; $6fd2
	ld (wNumBombs),a		; $6fd4
	call decNumBombs		; $6fd7
	jr _label_15_202		; $6fda
	ld a,(wTextNumberSubstitution)		; $6fdc
	ld (wC6b1),a		; $6fdf
	ld c,a			; $6fe2
	ld a,$03		; $6fe3
	jp addQuestItemToInventory		; $6fe5
	ld a,$ff		; $6fe8
	ld ($cfd0),a		; $6fea
	ld a,$04		; $6fed
	jp func_3284		; $6fef
	ld a,GLOBALFLAG_1c		; $6ff2
	jp setGlobalFlag		; $6ff4
	or $98			; $6ff7
	inc c			; $6ff9
	nop			; $6ffa
	add a			; $6ffb
	and l			; $6ffc
	rlc h			; $6ffd
	ld (hl),b		; $6fff
	ld (hl),$70		; $7000
	ld e,b			; $7002
	ld (hl),b		; $7003
	ld hl,sp-$68		; $7004
	inc c			; $7006
	ld bc,$01c3		; $7007
	ld hl,sp+$6f		; $700a
	ld hl,sp-$68		; $700c
	inc c			; $700e
	ld (bc),a		; $700f
	jp $f801		; $7010
	ld l,a			; $7013
	ld hl,sp-$6f		; $7014
	ret nc			; $7016
	rst $8			; $7017
	ld bc,$98f6		; $7018
	inc c			; $701b
	inc bc			; $701c
	ld ($ff00+$9d),a	; $701d
	ld l,a			; $701f
	ld a,($98e1)		; $7020
	inc c			; $7023
	ld a,c			; $7024
	ld ($ff00+$6c),a	; $7025
	ldd (hl),a		; $7027
	ld a,($ff00+$e0)	; $7028
	jp $f06f		; $702a
	ld ($ff00+$e8),a	; $702d
	ld l,a			; $702f
	ldh a,(<hScriptAddressL)	; $7030
	inc c			; $7032
	inc b			; $7033
	or $00			; $7034
	ld hl,sp-$68		; $7036
	inc c			; $7038
	dec b			; $7039
	jp $f801		; $703a
	ld l,a			; $703d
	ld hl,sp-$6f		; $703e
	ret nc			; $7040
	rst $8			; $7041
	ld bc,$98f6		; $7042
	inc c			; $7045
	ld b,$e0		; $7046
	xor l			; $7048
	ld l,a			; $7049
	push af			; $704a
	ld ($ff00+$d2),a	; $704b
	ld l,a			; $704d
	ld a,($ff00+$e0)	; $704e
	add sp,$6f		; $7050
	ldh a,(<hScriptAddressL)	; $7052
	inc c			; $7054
	inc b			; $7055
	or $00			; $7056
	sub c			; $7058
	ret nc			; $7059
	rst $8			; $705a
	ld bc,$98f6		; $705b
	inc c			; $705e
	rlca			; $705f
	or $e0			; $7060
	sbc l			; $7062
	ld l,a			; $7063
	ld a,($98e1)		; $7064
	inc c			; $7067
	ld a,c			; $7068
	ld ($ff00+$6c),a	; $7069
	ldd (hl),a		; $706b
	ld a,($ff00+$e0)	; $706c
	call c,$e06f		; $706e
	add sp,$6f		; $7071
	ldh a,(<hScriptAddressL)	; $7073
	inc c			; $7075
	ld ($e0f6),sp		; $7076
	ld a,($ff00+c)		; $7079
	ld l,a			; $707a
	nop			; $707b
	ld e,$7b		; $707c
	ld (de),a		; $707e
	jp interactionSetAnimation		; $707f
	call $70a2		; $7082
	jr _label_15_203		; $7085
	call $709c		; $7087
	jr _label_15_203		; $708a
	call $70a6		; $708c
	jr _label_15_203		; $708f
	call $70b2		; $7091
	jr _label_15_203		; $7094
	ld c,a			; $7096
_label_15_203:
	ld b,$05		; $7097
	jp showText		; $7099
	ld h,d			; $709c
	ld l,$7f		; $709d
	add (hl)		; $709f
	jr _label_15_204		; $70a0
	ld h,d			; $70a2
	ld l,$7f		; $70a3
	add (hl)		; $70a5
	call $70b2		; $70a6
	ld e,$7d		; $70a9
	ld a,(de)		; $70ab
	ld hl,$c6e6		; $70ac
	rst_addAToHl			; $70af
	ld (hl),c		; $70b0
	ret			; $70b1
_label_15_204:
	ld c,a			; $70b2
	call checkIsLinkedGame		; $70b3
	ret z			; $70b6
	call $70c2		; $70b7
	ld hl,$70ce		; $70ba
	rst_addAToHl			; $70bd
	ld a,(hl)		; $70be
	add c			; $70bf
	ld c,a			; $70c0
	ret			; $70c1
	ld h,d			; $70c2
	ld l,$41		; $70c3
	ld a,(hl)		; $70c5
	cp $8a			; $70c6
	jr nz,_label_15_205	; $70c8
	dec a			; $70ca
_label_15_205:
	sub $87			; $70cb
	ret			; $70cd
	jr nz,$20		; $70ce
	stop			; $70d0
	call getThisRoomFlags		; $70d1
	bit 7,a			; $70d4
	ret nz			; $70d6
	set 7,(hl)		; $70d7
	call getFreeInteractionSlot		; $70d9
	ld (hl),$60		; $70dc
	inc l			; $70de
	ld (hl),$19		; $70df
	inc l			; $70e1
	ld (hl),$02		; $70e2
	ld l,$4b		; $70e4
	ld (hl),$60		; $70e6
	ld a,(w1Link.xh)		; $70e8
	ld b,$50		; $70eb
	cp $64			; $70ed
	jr nc,_label_15_206	; $70ef
	cp $3c			; $70f1
	jr c,_label_15_206	; $70f3
	ld b,$40		; $70f5
	cp $50			; $70f7
	jr nc,_label_15_206	; $70f9
	ld b,$60		; $70fb
_label_15_206:
	ld l,$4d		; $70fd
	ld (hl),b		; $70ff
	ld a,b			; $7100
	ld ($c6eb),a		; $7101
	ret			; $7104
	call getThisRoomFlags		; $7105
	bit 5,a			; $7108
	ret nz			; $710a
	bit 7,a			; $710b
	ret z			; $710d
	call getFreeInteractionSlot		; $710e
	ld (hl),$60		; $7111
	inc l			; $7113
	ld (hl),$19		; $7114
	inc l			; $7116
	ld (hl),$03		; $7117
	ld l,$4b		; $7119
	ld a,$58		; $711b
	ldi (hl),a		; $711d
	ld a,($c6eb)		; $711e
	ld l,$4d		; $7121
	ld (hl),a		; $7123
	ret			; $7124
	ld bc,$a600		; $7125
	jp objectCreateInteraction		; $7128
	ld c,$5b		; $712b
	call checkIsLinkedGame		; $712d
	jr z,_label_15_207	; $7130
	ld c,$5f		; $7132
_label_15_207:
	ld e,$72		; $7134
	ld a,c			; $7136
	ld (de),a		; $7137
	ret			; $7138
	add $7e			; $7139
	ld c,c			; $713b
	ld (hl),c		; $713c
	ld e,b			; $713d
	ld (hl),c		; $713e
	ld (hl),b		; $713f
	ld (hl),c		; $7140
	adc a			; $7141
	ld (hl),c		; $7142
	adc a			; $7143
	ld (hl),c		; $7144
	sbc (hl)		; $7145
	ld (hl),c		; $7146
	cp l			; $7147
	ld (hl),c		; $7148
	pop hl			; $7149
	ld a,h			; $714a
	ld (hl),b		; $714b
	nop			; $714c
	adc l			; $714d
	ld ($9b08),sp		; $714e
	sbc (hl)		; $7151
	pop hl			; $7152
	add d			; $7153
	ld (hl),b		; $7154
	nop			; $7155
	ld (hl),c		; $7156
	ld d,c			; $7157
	pop hl			; $7158
	ld a,h			; $7159
	ld (hl),b		; $715a
	nop			; $715b
	adc l			; $715c
	ld ($9b08),sp		; $715d
	sbc (hl)		; $7160
	pop hl			; $7161
	ld a,h			; $7162
	ld (hl),b		; $7163
	inc bc			; $7164
	pop hl			; $7165
	add d			; $7166
	ld (hl),b		; $7167
	nop			; $7168
	ld a,($ff00+$e1)	; $7169
	ld a,h			; $716b
	ld (hl),b		; $716c
	nop			; $716d
	ld (hl),c		; $716e
	ld h,b			; $716f
	pop hl			; $7170
	ld a,h			; $7171
	ld (hl),b		; $7172
	nop			; $7173
	adc l			; $7174
	ld ($9b08),sp		; $7175
	sbc (hl)		; $7178
	cp l			; $7179
	pop hl			; $717a
	add d			; $717b
	ld (hl),b		; $717c
	nop			; $717d
	or $e1			; $717e
	ld a,h			; $7180
	ld (hl),b		; $7181
	inc b			; $7182
	pop hl			; $7183
	add a			; $7184
	ld (hl),b		; $7185
	ld bc,$e1f0		; $7186
	ld a,h			; $7189
	ld (hl),b		; $718a
	nop			; $718b
	cp (hl)			; $718c
	ld (hl),c		; $718d
	ld a,b			; $718e
	pop hl			; $718f
	ld a,h			; $7190
	ld (hl),b		; $7191
	inc b			; $7192
	adc l			; $7193
	ld ($9b08),sp		; $7194
	sbc (hl)		; $7197
	pop hl			; $7198
	add d			; $7199
	ld (hl),b		; $719a
	nop			; $719b
	ld (hl),c		; $719c
	sub a			; $719d
	pop hl			; $719e
	ld a,h			; $719f
	ld (hl),b		; $71a0
	nop			; $71a1
	adc l			; $71a2
	ld ($9b08),sp		; $71a3
	sbc (hl)		; $71a6
	cp l			; $71a7
	pop hl			; $71a8
	ld a,h			; $71a9
	ld (hl),b		; $71aa
	ld (bc),a		; $71ab
	pop hl			; $71ac
	add d			; $71ad
	ld (hl),b		; $71ae
	nop			; $71af
	or $e1			; $71b0
	ld a,h			; $71b2
	ld (hl),b		; $71b3
	nop			; $71b4
	pop hl			; $71b5
	add d			; $71b6
	ld (hl),b		; $71b7
	ld bc,$bef0		; $71b8
	ld (hl),c		; $71bb
	and (hl)		; $71bc
	cp e			; $71bd
	pop hl			; $71be
	ld a,h			; $71bf
	ld (hl),b		; $71c0
	nop			; $71c1
	adc l			; $71c2
	ld ($9b08),sp		; $71c3
	pop de			; $71c6
	rst_addAToHl			; $71c7
	jp nc,$6498		; $71c8
	ld hl,sp-$1d		; $71cb
	ld a,($ff00+$e1)	; $71cd
	ld a,h			; $71cf
	ld (hl),b		; $71d0
	inc b			; $71d1
	ld hl,sp-$1d		; $71d2
	or d			; $71d4
	sub c			; $71d5
	inc b			; $71d6
	call z,$d707		; $71d7
	jp nc,$4098		; $71da
.DB $e3				; $71dd
	or d			; $71de
	rst_addAToHl			; $71df
	jp nc,$4198		; $71e0
.DB $e3				; $71e3
	or d			; $71e4
	rst_addAToHl			; $71e5
	sub (hl)		; $71e6
	sub c			; $71e7
	ret nz			; $71e8
	rst $8			; $71e9
	ld bc,$53e0		; $71ea
	ld a,$00		; $71ed
	ld ($ff00+R_TIMA),a	; $71ef
	ld (hl),c		; $71f1
.DB $e4				; $71f2
	ld e,$e1		; $71f3
	ld a,h			; $71f5
	ld (hl),b		; $71f6
	nop			; $71f7
	adc l			; $71f8
	ld ($9b08),sp		; $71f9
	or b			; $71fc
	add b			; $71fd
	ld (hl),a		; $71fe
	ld (hl),d		; $71ff
	sbc (hl)		; $7200
	cp l			; $7201
	pop hl			; $7202
	ld a,h			; $7203
	ld (hl),b		; $7204
	ld (bc),a		; $7205
	sbc b			; $7206
	ld b,d			; $7207
	or $e1			; $7208
	ld a,h			; $720a
	ld (hl),b		; $720b
	inc bc			; $720c
	sbc b			; $720d
	ld b,e			; $720e
	or $e1			; $720f
	ld a,h			; $7211
	ld (hl),b		; $7212
	ld bc,$4498		; $7213
	or $e1			; $7216
	ld a,h			; $7218
	ld (hl),b		; $7219
	nop			; $721a
	sbc b			; $721b
	ld b,l			; $721c
	or $e1			; $721d
	ld a,h			; $721f
	ld (hl),b		; $7220
	ld bc,$4698		; $7221
	or $e1			; $7224
	ld a,h			; $7226
	ld (hl),b		; $7227
	inc b			; $7228
	sbc b			; $7229
	ld b,a			; $722a
	or $e1			; $722b
	ld a,h			; $722d
	ld (hl),b		; $722e
	nop			; $722f
	sbc b			; $7230
	ld c,b			; $7231
	or $e1			; $7232
	ld a,h			; $7234
	ld (hl),b		; $7235
	inc b			; $7236
	sbc b			; $7237
	ld c,c			; $7238
	or $f6			; $7239
	pop hl			; $723b
	ld a,h			; $723c
	ld (hl),b		; $723d
	nop			; $723e
	sbc b			; $723f
	ld c,d			; $7240
	or $c3			; $7241
	nop			; $7243
	inc l			; $7244
	ld (hl),d		; $7245
	pop hl			; $7246
	ld a,h			; $7247
	ld (hl),b		; $7248
	nop			; $7249
	sbc b			; $724a
	ld c,e			; $724b
	or $e1			; $724c
	ld a,h			; $724e
	ld (hl),b		; $724f
	inc b			; $7250
	sbc b			; $7251
	ld c,h			; $7252
	or $98			; $7253
	ld c,l			; $7255
	or $e1			; $7256
	ld a,h			; $7258
	ld (hl),b		; $7259
	inc bc			; $725a
	sbc b			; $725b
	ld c,(hl)		; $725c
	or $e1			; $725d
	ld a,h			; $725f
	ld (hl),b		; $7260
	nop			; $7261
	sbc b			; $7262
	ld c,a			; $7263
	or $b6			; $7264
	ld a,$91		; $7266
	and $c6			; $7268
	ld c,a			; $726a
	sbc b			; $726b
	ld d,b			; $726c
	or $e0			; $726d
	pop de			; $726f
	ld (hl),b		; $7270
	rst_addAToHl			; $7271
	adc h			; $7272
	sbc b			; $7273
	ld h,c			; $7274
	or $be			; $7275
	sbc (hl)		; $7277
	cp l			; $7278
	pop hl			; $7279
	ld a,h			; $727a
	ld (hl),b		; $727b
	nop			; $727c
	sbc b			; $727d
	ld c,a			; $727e
	or $e1			; $727f
	ld a,h			; $7281
	ld (hl),b		; $7282
	nop			; $7283
	cp (hl)			; $7284
	ld (hl),d		; $7285
	ld (hl),a		; $7286
	cp l			; $7287
	ld hl,sp-$68		; $7288
	ld e,c			; $728a
	or $e0			; $728b
	dec h			; $728d
	ld (hl),c		; $728e
	push de			; $728f
	ret nz			; $7290
	rst $8			; $7291
	ld bc,$5ee3		; $7292
	sbc $36			; $7295
	nop			; $7297
	or $91			; $7298
	inc b			; $729a
	call z,$d50e		; $729b
	ret nz			; $729e
	rst $8			; $729f
	ld (bc),a		; $72a0
	adc a			; $72a1
	ld (bc),a		; $72a2
	nop			; $72a3
	cp l			; $72a4
	ld ($ff00+$2b),a	; $72a5
	ld (hl),c		; $72a7
	pop de			; $72a8
	ld hl,sp-$63		; $72a9
	push af			; $72ab
	adc a			; $72ac
	nop			; $72ad
	di			; $72ae
	sub c			; $72af
	and $c6			; $72b0
	ld h,b			; $72b2
	sub h			; $72b3
	ld (hl),d		; $72b4
	ld bc,$f59d		; $72b5
	or (hl)			; $72b8
	inc de			; $72b9
	sub c			; $72ba
	ret nz			; $72bb
	rst $8			; $72bc
	inc b			; $72bd
	ld ($ff00+R_HDMA3),a	; $72be
	ld a,$be		; $72c0
	adc l			; $72c2
	ld ($9b08),sp		; $72c3
	sbc (hl)		; $72c6
	sbc l			; $72c7
	ld (hl),d		; $72c8
	add $1e			; $72c9
	ld a,e			; $72cb
	ld (de),a		; $72cc
	jp interactionSetAnimation		; $72cd
	add $7e			; $72d0
	ret c			; $72d2
	ld (hl),d		; $72d3
.DB $ec				; $72d4
	ld (hl),d		; $72d5
	inc b			; $72d6
	ld (hl),e		; $72d7
	pop hl			; $72d8
	jp z,$0272		; $72d9
	adc l			; $72dc
	ld ($9b08),sp		; $72dd
	sbc (hl)		; $72e0
	pop hl			; $72e1
	add d			; $72e2
	ld (hl),b		; $72e3
	nop			; $72e4
	sbc (hl)		; $72e5
	pop hl			; $72e6
	add d			; $72e7
	ld (hl),b		; $72e8
	ld bc,$e572		; $72e9
	pop hl			; $72ec
	jp z,$0072		; $72ed
	adc l			; $72f0
	ld ($9b08),sp		; $72f1
	sbc (hl)		; $72f4
	pop hl			; $72f5
	jp z,$0172		; $72f6
	pop hl			; $72f9
	add d			; $72fa
	ld (hl),b		; $72fb
	nop			; $72fc
	ld a,($ff00+$e1)	; $72fd
	jp z,$0072		; $72ff
	ld (hl),d		; $7302
.DB $f4				; $7303
	pop hl			; $7304
	jp z,$0072		; $7305
	adc l			; $7308
	ld ($9b08),sp		; $7309
	sbc (hl)		; $730c
	pop hl			; $730d
	add d			; $730e
	ld (hl),b		; $730f
	nop			; $7310
	sbc (hl)		; $7311
	pop hl			; $7312
	add d			; $7313
	ld (hl),b		; $7314
	ld bc,$1173		; $7315
	call func_32ab		; $7318
	jr _label_15_208		; $731b
	call func_32d1		; $731d
_label_15_208:
	ld a,$ff		; $7320
	ld (wPaletteFadeBG1),a		; $7322
	ld (wPaletteFadeBG2),a		; $7325
	ld a,$01		; $7328
	ld (wPaletteFadeSP1),a		; $732a
	ld a,$fe		; $732d
	ld (wPaletteFadeSP2),a		; $732f
	ret			; $7332
	ld e,$43		; $7333
	ld a,(de)		; $7335
	cp $09			; $7336
	ret nz			; $7338
	jpab bank1.func_626e		; $7339
	ld h,d			; $7341
	ld l,$7f		; $7342
	ld (hl),$01		; $7344
	ld a,$04		; $7346
	jp interactionSetAnimation		; $7348
	ld h,d			; $734b
	ld l,$7f		; $734c
	ld (hl),$00		; $734e
	ld a,$02		; $7350
	jp interactionSetAnimation		; $7352
	or l			; $7355
	inc d			; $7356
	rst $28			; $7357
	ld b,l			; $7358
	pop hl			; $7359
	ld l,c			; $735a
	ld h,d			; $735b
	inc b			; $735c
	rst_jumpTable			; $735d
.DB $db				; $735e
	call $ef80		; $735f
	ld b,l			; $7362
.DB $eb				; $7363
	or b			; $7364
	ld b,b			; $7365
	sub c			; $7366
	ld (hl),e		; $7367
	ld ($ff00+R_STAT),a	; $7368
	ld (hl),e		; $736a
	pop de			; $736b
	call nc,$ff61		; $736c
	ei			; $736f
	ld ($ff00+R_WX),a	; $7370
	ld (hl),e		; $7372
	sbc b			; $7373
	inc h			; $7374
	add a			; $7375
	or $e1			; $7376
	or c			; $7378
	ld l,e			; $7379
	ld bc,$d5f0		; $737a
	ld bc,$00d0		; $737d
	or $98			; $7380
	inc h			; $7382
	adc b			; $7383
	or $de			; $7384
	ld b,e			; $7386
	nop			; $7387
	cp l			; $7388
	or (hl)			; $7389
	cpl			; $738a
	or c			; $738b
	ld b,b			; $738c
	or $be			; $738d
	ld (hl),e		; $738f
	sub d			; $7390
	sbc (hl)		; $7391
	sbc b			; $7392
	inc h			; $7393
	adc c			; $7394
	ld (hl),e		; $7395
	sub c			; $7396
	or l			; $7397
	inc d			; $7398
	rst $28			; $7399
	ld b,l			; $739a
	pop hl			; $739b
	ld (hl),c		; $739c
	ld h,d			; $739d
	inc b			; $739e
	rst_jumpTable			; $739f
.DB $db				; $73a0
	call $ef80		; $73a1
	ld b,l			; $73a4
.DB $eb				; $73a5
	sbc (hl)		; $73a6
	sbc b			; $73a7
	inc h			; $73a8
.DB $e4				; $73a9
	ld (hl),e		; $73aa
	and (hl)		; $73ab
	rst_addAToHl			; $73ac
	stop			; $73ad
	ld ($ff00+R_NR31),a	; $73ae
	ld (hl),h		; $73b0
	ld ($ff00+R_BGPD),a	; $73b1
	ld e,$91		; $73b3
	ret nc			; $73b5
	rst $8			; $73b6
	ld ($21e3),sp		; $73b7
	pop hl			; $73ba
	ld d,l			; $73bb
	ld d,c			; $73bc
	ld bc,$98fa		; $73bd
	ld bc,$91f7		; $73c0
	ret nc			; $73c3
	rst $8			; $73c4
	add hl,bc		; $73c5
.DB $e3				; $73c6
	ld a,($d700)		; $73c7
	stop			; $73ca
	ld ($ff00+R_BGPD),a	; $73cb
	ld e,$e3		; $73cd
	ld hl,$98f8		; $73cf
	ld de,$00f6		; $73d2
	ld c,$00		; $73d5
	jr _label_15_209		; $73d7
	ld c,$01		; $73d9
	jr _label_15_209		; $73db
	ld c,$02		; $73dd
_label_15_209:
	push de			; $73df
	callab bank2.func_7b83		; $73e0
	call func_12fc		; $73e8
	pop de			; $73eb
	ld a,$0f		; $73ec
	call setScreenShakeCounter		; $73ee
	ld a,$70		; $73f1
	call playSound		; $73f3
	ld bc,$2060		; $73f6
	call $740b		; $73f9
	ld bc,$2070		; $73fc
	call $740b		; $73ff
	ld bc,$2080		; $7402
	call $740b		; $7405
	ld bc,$2090		; $7408
	call getFreeInteractionSlot		; $740b
	ret nz			; $740e
	ld (hl),$05		; $740f
	inc l			; $7411
	ld (hl),$81		; $7412
	ld l,$4b		; $7414
_label_15_210:
	ld (hl),b		; $7416
	ld l,$4d		; $7417
	ld (hl),c		; $7419
	ret			; $741a
	xor a			; $741b
	ldh (<hFF8B),a	; $741c
	call objectGetPosition		; $741e
	ldh a,(<hFF8B)	; $7421
	ld hl,$cfd5		; $7423
	ld (hl),b		; $7426
	inc l			; $7427
	add c			; $7428
	ld (hl),a		; $7429
	ret			; $742a
	adc a			; $742b
	ld (bc),a		; $742c
	adc (hl)		; $742d
	ld c,b			; $742e
	ld (bc),a		; $742f
	pop hl			; $7430
	inc e			; $7431
	ld (hl),h		; $7432
	jr _label_15_210		; $7433
	ld d,l			; $7435
	ld d,c			; $7436
	nop			; $7437
	ld sp,hl		; $7438
	pop hl			; $7439
_label_15_211:
	inc e			; $743a
	ld (hl),h		; $743b
	ld a,($ff00+$e3)	; $743c
	ld hl,$98f5		; $743e
	inc bc			; $7441
	push af			; $7442
	pop hl			; $7443
	inc e			; $7444
	ld (hl),h		; $7445
	ld b,b			; $7446
	rst_addAToHl			; $7447
	stop			; $7448
	sbc b			; $7449
	inc b			; $744a
	push af			; $744b
	pop hl			; $744c
	inc e			; $744d
	ld (hl),h		; $744e
	ld a,($ff00+$d7)	; $744f
	stop			; $7451
	sbc b			; $7452
	dec b			; $7453
	push af			; $7454
	pop hl			; $7455
	inc e			; $7456
	ld (hl),h		; $7457
	ld b,b			; $7458
	rst_addAToHl			; $7459
	stop			; $745a
	sbc b			; $745b
	ld b,$f5		; $745c
	pop hl			; $745e
	inc e			; $745f
	ld (hl),h		; $7460
	jr _label_15_211		; $7461
	stop			; $7463
	sbc b			; $7464
	rlca			; $7465
	ld hl,sp-$1d		; $7466
	ld a,($00f6)		; $7468
	adc a			; $746b
	ld (bc),a		; $746c
	adc (hl)		; $746d
	ld c,b			; $746e
	ld (bc),a		; $746f
	ld sp,hl		; $7470
	sbc b			; $7471
	ld (de),a		; $7472
	push af			; $7473
	sbc b			; $7474
	inc de			; $7475
	push af			; $7476
	sbc b			; $7477
	inc d			; $7478
	ld hl,sp+$00		; $7479
	adc a			; $747b
	ld (bc),a		; $747c
	adc (hl)		; $747d
	ld c,b			; $747e
	ld (bc),a		; $747f
	or $e3			; $7480
	ld hl,$98f8		; $7482
	ld d,$f5		; $7485
	sbc b			; $7487
	rla			; $7488
_label_15_212:
	ld hl,sp-$6f		; $7489
	ret nz			; $748b
	rst $8			; $748c
	inc bc			; $748d
.DB $fc				; $748e
	nop			; $748f
	ld hl,sp-$68		; $7490
	jr _label_15_212		; $7492
	sbc b			; $7494
	add hl,de		; $7495
	ld hl,sp+$00		; $7496
	ld h,d			; $7498
	ld l,$54		; $7499
	ld a,$80		; $749b
	ldi (hl),a		; $749d
	ld (hl),$fe		; $749e
	ld a,$01		; $74a0
	ld (wDisabledObjects),a		; $74a2
	ld (wMenuDisabled),a		; $74a5
	ld (wTextIsActive),a		; $74a8
	ld a,$8f		; $74ab
	jp playSound		; $74ad
	ld a,($cfd7)		; $74b0
	ld (wTextSubstitutions),a		; $74b3
	ret			; $74b6
	xor a			; $74b7
	ld (wDisabledObjects),a		; $74b8
	ld (wMenuDisabled),a		; $74bb
	ld a,$44		; $74be
	ld c,$49		; $74c0
	call setTile		; $74c2
	call getFreeInteractionSlot		; $74c5
	ret nz			; $74c8
	ld (hl),$05		; $74c9
	ld l,$4b		; $74cb
	ld (hl),$48		; $74cd
	ld l,$4d		; $74cf
	ld (hl),$98		; $74d1
	ret			; $74d3
	push de			; $74d4
	call func_19ad		; $74d5
	pop de			; $74d8
	call setLinkForceStateToState08		; $74d9
	call resetLinkInvincibility		; $74dc
	ld l,$0b		; $74df
	ld (hl),$48		; $74e1
	ld l,$0d		; $74e3
	ld (hl),$78		; $74e5
	ld l,$08		; $74e7
	ld (hl),a		; $74e9
	inc a			; $74ea
	ld ($cfd6),a		; $74eb
	jp func_12ce		; $74ee
	call objectGetLinkRelativeAngle		; $74f1
	add $04			; $74f4
	and $18			; $74f6
	swap a			; $74f8
	rlca			; $74fa
	ld e,$48		; $74fb
	ld (hl),a		; $74fd
	jp interactionSetAnimation		; $74fe
.DB $eb				; $7501
	sbc (hl)		; $7502
	rst_jumpTable			; $7503
	cp (hl)			; $7504
	ret z			; $7505
	ld b,$12		; $7506
	ld (hl),l		; $7508
	sub d			; $7509
	cp (hl)			; $750a
	ret z			; $750b
	ld b,$9a		; $750c
	ld e,b			; $750e
	nop			; $750f
	ld (hl),l		; $7510
	dec d			; $7511
	sbc d			; $7512
	ld e,b			; $7513
	ld bc,$00c3		; $7514
	ld e,$75		; $7517
	sbc b			; $7519
	ld e,b			; $751a
	ld (bc),a		; $751b
	ld (hl),l		; $751c
	ld (bc),a		; $751d
	add $78			; $751e
	add hl,hl		; $7520
	ld (hl),l		; $7521
	inc h			; $7522
	ld (hl),l		; $7523
	sbc b			; $7524
	ld e,b			; $7525
	inc bc			; $7526
	ld (hl),l		; $7527
	ld (bc),a		; $7528
	ldh (<hEnemyTargetY),a	; $7529
	ld (hl),h		; $752b
	sbc d			; $752c
	ld e,b			; $752d
	inc b			; $752e
	jp $3800		; $752f
	ld (hl),l		; $7532
	sbc b			; $7533
	ld e,b			; $7534
	dec b			; $7535
	ld (hl),l		; $7536
	ld (bc),a		; $7537
	ldh (<hScriptAddressL),a	; $7538
	ld (hl),h		; $753a
	ld a,($ff00+c)		; $753b
	sbc b			; $753c
	ld e,b			; $753d
	ld b,$f2		; $753e
	nop			; $7540
.DB $eb				; $7541
	sbc (hl)		; $7542
	sbc d			; $7543
	ld e,b			; $7544
	stop			; $7545
	jp $4f00		; $7546
	ld (hl),l		; $7549
	sbc b			; $754a
	ld e,b			; $754b
	ld (bc),a		; $754c
	ld (hl),l		; $754d
	ld b,d			; $754e
	ldh (<hEnemyTargetY),a	; $754f
	ld (hl),h		; $7551
	sbc d			; $7552
	ld e,b			; $7553
	inc b			; $7554
	jp $5e00		; $7555
	ld (hl),l		; $7558
	sbc b			; $7559
	ld e,b			; $755a
	dec b			; $755b
	ld (hl),l		; $755c
	ld b,d			; $755d
	ldh (<hScriptAddressL),a	; $755e
	ld (hl),h		; $7560
	ld a,($ff00+c)		; $7561
	sbc b			; $7562
	ld e,b			; $7563
	ld b,$f2		; $7564
	nop			; $7566
.DB $eb				; $7567
	sbc (hl)		; $7568
	sbc d			; $7569
	ld e,b			; $756a
	rlca			; $756b
	jp $8101		; $756c
	ld (hl),l		; $756f
	sbc d			; $7570
	ld e,b			; $7571
	ld ($00c3),sp		; $7572
	adc c			; $7575
	ld (hl),l		; $7576
	ldh (<hEnemyTargetY),a	; $7577
	ld (hl),h		; $7579
	sbc d			; $757a
	ld e,b			; $757b
	add hl,bc		; $757c
	jp $8900		; $757d
	ld (hl),l		; $7580
	ldh (<hEnemyTargetY),a	; $7581
	ld (hl),h		; $7583
	sbc b			; $7584
	ld e,b			; $7585
	dec b			; $7586
	ld (hl),l		; $7587
	ld l,b			; $7588
	sbc b			; $7589
	ld e,b			; $758a
	ld a,(bc)		; $758b
	pop hl			; $758c
	ret nz			; $758d
	ld (hl),h		; $758e
	and b			; $758f
	ld a,($ff00+c)		; $7590
	nop			; $7591
	call getFreeEnemySlot		; $7592
	ret nz			; $7595
	ld (hl),$20		; $7596
	jp objectCopyPosition		; $7598
	ld c,a			; $759b
	ld a,$1d		; $759c
	call setTile		; $759e
	ld a,c			; $75a1
	add $10			; $75a2
	ld c,a			; $75a4
	ld a,$1e		; $75a5
	call setTile		; $75a7
	ld hl,$cfd0		; $75aa
_label_15_213:
	inc (hl)		; $75ad
	ld a,$70		; $75ae
	jp playSound		; $75b0
	sbc e			; $75b3
	adc a			; $75b4
	inc b			; $75b5
	sbc (hl)		; $75b6
	adc a			; $75b7
	dec b			; $75b8
	or l			; $75b9
	inc hl			; $75ba
	jp $9875		; $75bb
	ld bc,$22b6		; $75be
	ld (hl),l		; $75c1
	or h			; $75c2
	set 2,b			; $75c3
_label_15_214:
	rst $8			; $75c5
	ld bc,$75e3		; $75c6
	sbc b			; $75c9
	ld (bc),a		; $75ca
	jp $d300		; $75cb
	ld (hl),l		; $75ce
	sbc b			; $75cf
	inc bc			; $75d0
	ld (hl),l		; $75d1
	or h			; $75d2
	sbc b			; $75d3
	inc b			; $75d4
	jp $dd00		; $75d5
	ld (hl),l		; $75d8
	sbc b			; $75d9
	dec b			; $75da
	ld (hl),l		; $75db
	push de			; $75dc
	sub c			; $75dd
	ret nc			; $75de
	rst $8			; $75df
	ld bc,$b475		; $75e0
	sbc b			; $75e3
	ld b,$75		; $75e4
	or h			; $75e6
	ld a,($ff00+c)		; $75e7
.DB $e3				; $75e8
	ld a,($61e1)		; $75e9
	ld a,$00		; $75ec
	adc c			; $75ee
	nop			; $75ef
	adc h			; $75f0
	ld l,h			; $75f1
	ld hl,sp-$1d		; $75f2
	ld hl,$15e0		; $75f4
	inc sp			; $75f7
	sub c			; $75f8
	xor c			; $75f9
	rst $38			; $75fa
	nop			; $75fb
	sub c			; $75fc
	and a			; $75fd
	rst $38			; $75fe
	nop			; $75ff
	pop de			; $7600
	ld sp,hl		; $7601
	sub c			; $7602
	ret nz			; $7603
	rst $8			; $7604
	ld bc,$d2e3		; $7605
	rst_addAToHl			; $7608
	ldi (hl),a		; $7609
.DB $e3				; $760a
	jp nc,$c0d5		; $760b
	rst $8			; $760e
	ld (bc),a		; $760f
	pop hl			; $7610
	ld c,d			; $7611
	halt			; $7612
	inc bc			; $7613
	push af			; $7614
	adc (hl)		; $7615
	ld a,b			; $7616
	ld bc,$148b		; $7617
	pop hl			; $761a
	ld h,c			; $761b
	ld a,$01		; $761c
	adc c			; $761e
	jr _label_15_213		; $761f
	ld h,c			; $7621
	ld sp,hl		; $7622
	adc (hl)		; $7623
	ld a,b			; $7624
	nop			; $7625
	adc e			; $7626
	ld e,$89		; $7627
	ld ($418c),sp		; $7629
	or $e3			; $762c
.DB $d3				; $762e
	pop hl			; $762f
	ld c,d			; $7630
	halt			; $7631
	inc b			; $7632
	di			; $7633
	adc e			; $7634
	ldd (hl),a		; $7635
	adc c			; $7636
	jr _label_15_214		; $7637
	ld sp,$e1f9		; $7639
	ld c,d			; $763c
	halt			; $763d
	dec b			; $763e
	adc (hl)		; $763f
	ld a,b			; $7640
	ld bc,$148b		; $7641
	adc c			; $7644
	ld ($ff8c),sp		; $7645
	ld hl,sp+$00		; $7648
	ld b,a			; $764a
	call getFreeInteractionSlot		; $764b
	ret nz			; $764e
	ld (hl),$64		; $764f
	inc l			; $7651
	ld (hl),b		; $7652
	ret			; $7653
	ld bc,$fe60		; $7654
	jp objectSetSpeedZ		; $7657
	ld hl,w1Link.y		; $765a
	call centerCoordinatesOnTile		; $765d
	ld l,$08		; $7660
	ld (hl),$01		; $7662
	ret			; $7664
	call getFreeInteractionSlot		; $7665
	ret nz			; $7668
	ld (hl),$c5		; $7669
	inc l			; $766b
	inc (hl)		; $766c
	ret			; $766d
	ld ($ff00+R_HDMA4),a	; $766e
	halt			; $7670
	ld hl,sp-$68		; $7671
	ld (bc),a		; $7673
.DB $e4				; $7674
	ldh a,(<hFF8B)	; $7675
	jr z,-$13		; $7677
	stop			; $7679
	ld ($ff00+R_HDMA4),a	; $767a
	halt			; $767c
	xor $0a			; $767d
.DB $e4				; $767f
	ld sp,$7dd7		; $7680
	add b			; $7683
	ld (bc),a		; $7684
	xor c			; $7685
	adc e			; $7686
	inc a			; $7687
	rst $28			; $7688
	stop			; $7689
.DB $f4				; $768a
	ret nz			; $768b
	or l			; $768c
	ld a,e			; $768d
	ret nz			; $768e
	or l			; $768f
	ld a,e			; $7690
	add b			; $7691
	inc b			; $7692
	ld a,($80a9)		; $7693
	ld (bc),a		; $7696
	.db $ed			; $7697
	stop			; $7698
	adc a			; $7699
_label_15_215:
	ld (bc),a		; $769a
	xor c			; $769b
	rst_addAToHl			; $769c
	ld b,(hl)		; $769d
	add b			; $769e
	inc bc			; $769f
	.db $ed			; $76a0
	stop			; $76a1
	adc a			; $76a2
	ld (bc),a		; $76a3
.DB $f4				; $76a4
	ret nz			; $76a5
	ret z			; $76a6
	ld a,e			; $76a7
	ret nz			; $76a8
	ret z			; $76a9
	ld a,e			; $76aa
	rst $28			; $76ab
	stop			; $76ac
	adc a			; $76ad
	ld (bc),a		; $76ae
	ld sp,hl		; $76af
.DB $e3				; $76b0
	ld a,($ff00+$e3)	; $76b1
	ld a,c			; $76b3
	xor c			; $76b4
	add b			; $76b5
	ld (bc),a		; $76b6
	adc e			; $76b7
	jr z,_label_15_215	; $76b8
	ld d,h			; $76ba
	halt			; $76bb
	xor $18			; $76bc
	adc a			; $76be
	inc bc			; $76bf
	ld ($ff00+$5a),a	; $76c0
	halt			; $76c2
	ld sp,hl		; $76c3
	sbc b			; $76c4
	inc bc			; $76c5
	ld hl,sp-$20		; $76c6
	ld h,l			; $76c8
	halt			; $76c9
	and a			; $76ca
	ld hl,sp-$1d		; $76cb
	pop af			; $76cd
	sbc $26			; $76ce
	nop			; $76d0
	xor b			; $76d1
	or c			; $76d2
	ld b,b			; $76d3
	cp (hl)			; $76d4
.DB $e4				; $76d5
	rst $38			; $76d6
	adc l			; $76d7
	ld b,$06		; $76d8
	add b			; $76da
	ld bc,$ae7b		; $76db
	ld bc,$f200		; $76de
	ld a,$1e		; $76e1
	jp objectCreateExclamationMark		; $76e3
	ld bc,$ff00		; $76e6
	jp objectSetSpeedZ		; $76e9
	ld a,$02		; $76ec
	ld (w1Link.direction),a		; $76ee
	jp clearAllParentItems		; $76f1
	ld a,(w1Link.xh)		; $76f4
	ld b,a			; $76f7
	ld e,$4d		; $76f8
	ld a,(de)		; $76fa
	sub b			; $76fb
	ld e,$47		; $76fc
	ld (de),a		; $76fe
	ret			; $76ff
	ld a,(w1Link.yh)		; $7700
	cp $18			; $7703
	ld a,$01		; $7705
	jr nc,_label_15_216	; $7707
	dec a			; $7709
_label_15_216:
	ld (wCFC1),a		; $770a
	ret			; $770d
	call checkIsLinkedGame		; $770e
	ld a,$01		; $7711
	jr nz,_label_15_217	; $7713
	dec a			; $7715
_label_15_217:
	ld (wCFC1),a		; $7716
	ret			; $7719
	ld a,$50		; $771a
	call playSound		; $771c
	ld a,$2d		; $771f
	ld bc,$f808		; $7721
	jp objectCreateExclamationMark		; $7724
	ld a,$00		; $7727
	jr _label_15_218		; $7729
	ld a,$01		; $772b
	jr _label_15_218		; $772d
	ld a,$02		; $772f
	jr _label_15_218		; $7731
	ld a,$03		; $7733
_label_15_218:
	ld (w1Link.direction),a		; $7735
	ret			; $7738
	ld a,$f0		; $7739
	call playSound		; $773b
	xor a			; $773e
	ld (wDisabledObjects),a		; $773f
	ld (wMenuDisabled),a		; $7742
	ld a,GLOBALFLAG_3c		; $7745
	call setGlobalFlag		; $7747
	ld hl,$7750		; $774a
	jp setWarpDestVariables		; $774d
	add b			; $7750
	ld h,l			; $7751
	nop			; $7752
	add l			; $7753
	inc bc			; $7754
_label_15_219:
	ldbc BLUE_JOY_RING, $00		; $7755
	jp giveRingToLink		; $7758
	ld ($ff00+$7b),a	; $775b
	ld e,$d5		; $775d
	ret nz			; $775f
	rst $8			; $7760
	ld bc,$69e0		; $7761
	ld e,$d5		; $7764
	ret nz			; $7766
	rst $8			; $7767
	ld b,$8f		; $7768
	inc bc			; $776a
	ld a,($ff00+c)		; $776b
	sub c			; $776c
	ret nz			; $776d
	rst $8			; $776e
	rlca			; $776f
	sbc b			; $7770
	dec a			; $7771
	inc c			; $7772
	di			; $7773
	adc a			; $7774
	rlca			; $7775
	adc c			; $7776
	jr -$75			; $7777
	dec b			; $7779
	adc h			; $777a
	ld e,$91		; $777b
	ret nz			; $777d
	rst $8			; $777e
	ld ($fb00),sp		; $777f
	adc e			; $7782
	inc d			; $7783
	rst $28			; $7784
	ret nz			; $7785
	adc (hl)		; $7786
_label_15_220:
	ld a,c			; $7787
	ld bc,$8ffa		; $7788
	nop			; $778b
	rst_addAToHl			; $778c
	sub (hl)		; $778d
	sub c			; $778e
	rst_addDoubleIndex			; $778f
	rst $8			; $7790
	ld bc,$d400		; $7791
	ld b,l			; $7794
	ld bc,$8bf6		; $7795
	jr z,_label_15_220	; $7798
	add hl,de		; $779a
	pop af			; $779b
.DB $ec				; $779c
	stop			; $779d
	pop af			; $779e
	.db $ed			; $779f
	dec c			; $77a0
	ld a,($ff00+c)		; $77a1
.DB $e4				; $77a2
	jr c,-$68		; $77a3
	ld b,$01		; $77a5
	ld ($ff00+R_HDMA5),a	; $77a7
	ld (hl),a		; $77a9
	or $98			; $77aa
	ld b,$02		; $77ac
	or $e0			; $77ae
	add hl,sp		; $77b0
	ld (hl),a		; $77b1
	nop			; $77b2
	pop de			; $77b3
	ld hl,sp-$75		; $77b4
	inc d			; $77b6
	xor $61			; $77b7
	ld hl,sp-$1f		; $77b9
	ld d,h			; $77bb
	ld e,b			; $77bc
	jr z,-$71		; $77bd
	ld ($8bf8),sp		; $77bf
	jr z,_label_15_219	; $77c2
	pop de			; $77c4
	rst $8			; $77c5
	ld bc,$31ee		; $77c6
	rst_addAToHl			; $77c9
	ld b,$91		; $77ca
	pop de			; $77cc
	rst $8			; $77cd
	ld (bc),a		; $77ce
	adc a			; $77cf
	inc bc			; $77d0
	push de			; $77d1
	pop de			; $77d2
	rst $8			; $77d3
	inc bc			; $77d4
	sbc b			; $77d5
	ld b,$00		; $77d6
	ld a,($df91)		; $77d8
	rst $8			; $77db
	rst $38			; $77dc
	nop			; $77dd
	ld a,($0998)		; $77de
	or $98			; $77e1
	ld a,(bc)		; $77e3
	or $00			; $77e4
	xor a			; $77e6
	ld (wActiveMusic),a		; $77e7
	ld a,$2d		; $77ea
	jp playSound		; $77ec
	ld a,$4c		; $77ef
	call checkQuestItemObtained		; $77f1
	ld b,$00		; $77f4
	jr nc,_label_15_221	; $77f6
	inc b			; $77f8
	or a			; $77f9
	jr z,_label_15_221	; $77fa
	inc b			; $77fc
_label_15_221:
	ld a,b			; $77fd
	ld (wCFC1),a		; $77fe
	ret			; $7801
	call getThisRoomFlags		; $7802
	ld e,$42		; $7805
	ld a,(de)		; $7807
	sub $08			; $7808
	or (hl)			; $780a
	ld (hl),a		; $780b
	ret			; $780c
	call $77ef		; $780d
	ld a,(wCFC1)		; $7810
	or a			; $7813
	ret nz			; $7814
	ld e,$42		; $7815
	ld a,(de)		; $7817
	sub $08			; $7818
	ld b,a			; $781a
	call getThisRoomFlags		; $781b
	and $0f			; $781e
	cp b			; $7820
	ld c,$00		; $7821
	jr z,_label_15_222	; $7823
	ld c,$03		; $7825
_label_15_222:
	ld a,c			; $7827
	ld (wCFC1),a		; $7828
	ret			; $782b
	ld a,$2c		; $782c
	call checkQuestItemObtained		; $782e
	jr c,_label_15_223	; $7831
	ld c,$03		; $7833
	jr _label_15_224		; $7835
_label_15_223:
	ld a,(wRingBoxLevel)		; $7837
	dec a			; $783a
	ld c,$03		; $783b
	jr z,_label_15_224	; $783d
	ld c,$05		; $783f
_label_15_224:
	ld hl,wTextNumberSubstitution		; $7841
	ld (hl),c		; $7844
	inc hl			; $7845
	ld (hl),$00		; $7846
	ret			; $7848
	or l			; $7849
	inc d			; $784a
	sub b			; $784b
	ld a,b			; $784c
	add b			; $784d
	rst $38			; $784e
	or l			; $784f
	add hl,hl		; $7850
	xor a			; $7851
	ld a,l			; $7852
.DB $eb				; $7853
	sbc (hl)		; $7854
	cp l			; $7855
	or l			; $7856
	ld l,$79		; $7857
	ld a,b			; $7859
	sbc b			; $785a
	stop			; $785b
	jp $6500		; $785c
	ld a,b			; $785f
	sbc b			; $7860
	inc de			; $7861
	cp (hl)			; $7862
	ld a,b			; $7863
	ld d,e			; $7864
	ld ($ff00+R_SC),a	; $7865
	ld a,b			; $7867
	or (hl)			; $7868
	ld l,$98		; $7869
	ld de,$00c3		; $786b
	ld (hl),h		; $786e
	ld a,b			; $786f
	sbc b			; $7870
	inc d			; $7871
	ld a,b			; $7872
	ld l,h			; $7873
	sbc b			; $7874
	ld (de),a		; $7875
	cp (hl)			; $7876
	ld a,b			; $7877
	adc b			; $7878
	cp (hl)			; $7879
	ld ($ff00+$0d),a	; $787a
	ld a,b			; $787c
	add a			; $787d
	pop bc			; $787e
	rst $8			; $787f
	adc b			; $7880
	ld a,b			; $7881
	adc h			; $7882
	ld a,b			; $7883
	adc (hl)		; $7884
	ld a,b			; $7885
	adc d			; $7886
	ld a,b			; $7887
	sub a			; $7888
	ld (de),a		; $7889
	sub a			; $788a
	dec d			; $788b
	sub a			; $788c
_label_15_225:
	ld d,$97		; $788d
	rla			; $788f
.DB $eb				; $7890
	sbc (hl)		; $7891
	cp l			; $7892
	or l			; $7893
	ld (hl),a		; $7894
	ret c			; $7895
	ld a,b			; $7896
	sbc b			; $7897
	inc h			; $7898
	or $c3			; $7899
	nop			; $789b
	and d			; $789c
	ld a,b			; $789d
	sbc b			; $789e
	dec h			; $789f
	ld a,b			; $78a0
	call c,$0986		; $78a1
	or $cb			; $78a4
	adc c			; $78a6
	call z,$af00		; $78a7
	ld a,b			; $78aa
	sbc b			; $78ab
	daa			; $78ac
	ld a,b			; $78ad
	call c,$6db6		; $78ae
	sbc b			; $78b1
	ld h,$f6		; $78b2
	rst_addDoubleIndex			; $78b4
_label_15_226:
	inc l			; $78b5
	cp h			; $78b6
	ld a,b			; $78b7
	sbc b			; $78b8
	ldi a,(hl)		; $78b9
	ld a,b			; $78ba
	pop bc			; $78bb
	sbc b			; $78bc
	jr z,_label_15_226	; $78bd
	sbc b			; $78bf
	add hl,hl		; $78c0
	or $e0			; $78c1
	inc l			; $78c3
	ld a,b			; $78c4
	res 5,b			; $78c5
	rlc l			; $78c7
	ret nc			; $78c9
	ld a,b			; $78ca
	sbc $2c			; $78cb
	ld bc,$d378		; $78cd
	sbc $2c			; $78d0
	ld (bc),a		; $78d2
	or $b1			; $78d3
	jr nz,_label_15_225	; $78d5
	ld (hl),a		; $78d7
	add (hl)		; $78d8
	add hl,de		; $78d9
	sbc b			; $78da
	dec hl			; $78db
	cp (hl)			; $78dc
	ld a,b			; $78dd
	sub c			; $78de
	or l			; $78df
	ld l,$e5		; $78e0
	ld a,b			; $78e2
	sub a			; $78e3
	dec bc			; $78e4
	or l			; $78e5
	add hl,hl		; $78e6
	ld l,$79		; $78e7
	or b			; $78e9
	ld b,b			; $78ea
	pop af			; $78eb
	ld a,b			; $78ec
	or l			; $78ed
	ldi a,(hl)		; $78ee
.DB $fd				; $78ef
	ld a,b			; $78f0
	or c			; $78f1
	ld b,b			; $78f2
	or (hl)			; $78f3
	ldi a,(hl)		; $78f4
	rst_addDoubleIndex			; $78f5
	ld c,h			; $78f6
	ei			; $78f7
	ld a,b			; $78f8
	sub a			; $78f9
	nop			; $78fa
	sub a			; $78fb
	ld bc,$efe0		; $78fc
	ld (hl),a		; $78ff
	add a			; $7900
	pop bc			; $7901
	rst $8			; $7902
	dec c			; $7903
	ld a,c			; $7904
	add hl,bc		; $7905
	ld a,c			; $7906
	dec bc			; $7907
	ld a,c			; $7908
	sub a			; $7909
	ld ($0997),sp		; $790a
.DB $eb				; $790d
	sbc (hl)		; $790e
	cp b			; $790f
	sbc b			; $7910
	ld (bc),a		; $7911
	cp l			; $7912
	or $98			; $7913
	inc b			; $7915
	ld a,c			; $7916
	inc e			; $7917
	sbc (hl)		; $7918
	sbc b			; $7919
	inc b			; $791a
	cp l			; $791b
	jp $2500		; $791c
	ld a,c			; $791f
	sbc b			; $7920
	rlca			; $7921
	cp (hl)			; $7922
	ld a,c			; $7923
	jr -$68			; $7924
	dec b			; $7926
	or $de			; $7927
	ld c,h			; $7929
	nop			; $792a
	cp (hl)			; $792b
	ld a,c			; $792c
	add hl,bc		; $792d
	sub a			; $792e
	ld a,(bc)		; $792f
	ld hl,$793e		; $7930
	call checkIsLinkedGame		; $7933
	jr z,_label_15_227	; $7936
	ld hl,$7943		; $7938
_label_15_227:
	jp setWarpDestVariables		; $793b
	add c			; $793e
	rst_addAToHl			; $793f
	ld bc,$0345		; $7940
	add b			; $7943
	ret z			; $7944
	ld bc,$0352		; $7945
.DB $eb				; $7948
	sbc (hl)		; $7949
	cp l			; $794a
	sbc a			; $794b
	ld (hl),$00		; $794c
	ld bc,$00c3		; $794e
	ld d,(hl)		; $7951
	ld a,c			; $7952
	cp (hl)			; $7953
	ld a,c			; $7954
	ld c,c			; $7955
	sbc a			; $7956
	ld (hl),$04		; $7957
	dec b			; $7959
	xor b			; $795a
	ld hl,sp-$68		; $795b
	ld (hl),$07		; $795d
	and c			; $795f
	pop hl			; $7960
	inc sp			; $7961
	rla			; $7962
	ld c,(hl)		; $7963
	sbc b			; $7964
	ld (hl),$06		; $7965
	or $de			; $7967
	ld c,a			; $7969
	nop			; $796a
	ld hl,sp-$20		; $796b
	jr nc,_label_15_228	; $796d
	or (hl)			; $796f
	inc (hl)		; $7970
	nop			; $7971
	ld c,$54		; $7972
	ld a,$a2		; $7974
	call setTile		; $7976
	inc c			; $7979
	ld a,$ef		; $797a
	call setTile		; $797c
	inc c			; $797f
	ld a,$a4		; $7980
	call setTile		; $7982
	ld a,$70		; $7985
	call playSound		; $7987
	ld bc,$0500		; $798a
	jp objectCreateInteraction		; $798d
	ld bc,$8404		; $7990
	call objectCreateInteraction		; $7993
	ret nz			; $7996
	ld l,$46		; $7997
	ld (hl),$78		; $7999
	ld a,(w1Link.yh)		; $799b
	ld l,$4b		; $799e
	ldi (hl),a		; $79a0
	inc l			; $79a1
	ld a,(w1Link.xh)		; $79a2
	ld (hl),a		; $79a5
	ret			; $79a6
	call getRandomNumber		; $79a7
	and $0f			; $79aa
	add $13			; $79ac
	ld (wTextSubstitutions),a		; $79ae
	ret			; $79b1
	or l			; $79b2
	inc d			; $79b3
	or a			; $79b4
	ld a,c			; $79b5
	nop			; $79b6
.DB $eb				; $79b7
	sbc (hl)		; $79b8
	cp l			; $79b9
	or l			; $79ba
	ld (hl),b		; $79bb
	jr nc,_label_15_229	; $79bc
	set 2,l			; $79be
	rst $8			; $79c0
	nop			; $79c1
	jp z,$cb79		; $79c2
	push de			; $79c5
	call z,$1601		; $79c6
	ld a,d			; $79c9
	or l			; $79ca
	ld h,(hl)		; $79cb
	ld a,($ff00+c)		; $79cc
	ld a,c			; $79cd
	sbc b			; $79ce
	inc l			; $79cf
	ld b,$f6		; $79d0
	jp $dc00		; $79d2
	ld a,c			; $79d5
	sbc b			; $79d6
	inc l			; $79d7
	rlca			; $79d8
	cp (hl)			; $79d9
	ld a,c			; $79da
	cp b			; $79db
	add (hl)		; $79dc
	ld (bc),a		; $79dd
	or $cb			; $79de
	adc c			; $79e0
	call z,$eb00		; $79e1
	ld a,c			; $79e4
	sbc b			; $79e5
	inc l			; $79e6
	add hl,bc		; $79e7
_label_15_228:
	cp (hl)			; $79e8
	ld a,c			; $79e9
	cp b			; $79ea
	or (hl)			; $79eb
	ld h,(hl)		; $79ec
	sbc b			; $79ed
	inc l			; $79ee
	ld ($f579),sp		; $79ef
	sbc b			; $79f2
	inc l			; $79f3
	ld c,$f6		; $79f4
	jp $0000		; $79f6
	ld a,d			; $79f9
	sbc b			; $79fa
	inc l			; $79fb
	rrca			; $79fc
	cp (hl)			; $79fd
	ld a,c			; $79fe
	cp b			; $79ff
	sbc b			; $7a00
	inc l			; $7a01
	ld a,(bc)		; $7a02
	or $c3			; $7a03
	ld bc,$7a00		; $7a05
	sbc b			; $7a08
	inc l			; $7a09
	dec bc			; $7a0a
	sub c			; $7a0b
	push de			; $7a0c
	rst $8			; $7a0d
	ld bc,$9ebe		; $7a0e
	sbc b			; $7a11
	inc l			; $7a12
	stop			; $7a13
	ld a,d			; $7a14
	stop			; $7a15
	sub c			; $7a16
	push de			; $7a17
	call z,$e000		; $7a18
	jp c,$c767		; $7a1b
.DB $db				; $7a1e
	call $2680		; $7a1f
	ld a,d			; $7a22
	cp (hl)			; $7a23
	ld a,d			; $7a24
	stop			; $7a25
	sbc b			; $7a26
	inc l			; $7a27
	inc c			; $7a28
	or $de			; $7a29
	dec c			; $7a2b
	ld (bc),a		; $7a2c
	or $b6			; $7a2d
	ld (hl),b		; $7a2f
	add (hl)		; $7a30
	ld (de),a		; $7a31
	sbc b			; $7a32
	inc l			; $7a33
	dec c			; $7a34
	cp (hl)			; $7a35
	ld a,c			; $7a36
	cp b			; $7a37
_label_15_229:
	or l			; $7a38
	inc d			; $7a39
	rst $28			; $7a3a
	ld b,l			; $7a3b
.DB $eb				; $7a3c
	sbc (hl)		; $7a3d
	or b			; $7a3e
	ld b,b			; $7a3f
	ld c,h			; $7a40
	ld a,d			; $7a41
	ldh (<hDirtySprPalettes),a	; $7a42
	ld a,c			; $7a44
	sbc b			; $7a45
	inc l			; $7a46
	ld de,$40b1		; $7a47
	ld a,d			; $7a4a
	dec a			; $7a4b
	ldh (<hDirtySprPalettes),a	; $7a4c
	ld a,c			; $7a4e
	sbc b			; $7a4f
	inc l			; $7a50
	ld (de),a		; $7a51
	ld a,d			; $7a52
	dec a			; $7a53
	call checkIsLinkedGame		; $7a54
	jr nz,_label_15_230	; $7a57
	jp $5118		; $7a59
_label_15_230:
	ld e,$7f		; $7a5c
	ld a,(de)		; $7a5e
	rst_jumpTable			; $7a5f
.dw $7a74
.dw $7a79
.dw $7a88
.dw $7a88
.dw $7a88
.dw $7a88
.dw $7a7e
.dw $7a88
.dw $7a88
.dw $7a83
	ld a,$03		; $7a74
	jp $6271		; $7a76
	ld a,$00		; $7a79
	jp $6271		; $7a7b
	ld a,$01		; $7a7e
	jp $6271		; $7a80
	ld a,$01		; $7a83
	jp $6271		; $7a85
	or d			; $7a88
	jp $5118		; $7a89
	ld e,$7f		; $7a8c
	ld a,(de)		; $7a8e
	ld hl,$7a98		; $7a8f
	rst_addAToHl			; $7a92
	ld a,(hl)		; $7a93
	or a			; $7a94
	jp $5118		; $7a95
	ld bc,$0101		; $7a98
	nop			; $7a9b
	nop			; $7a9c
	nop			; $7a9d
	ld bc,$0000		; $7a9e
	ld bc,$2e62		; $7aa1
	ld a,a			; $7aa4
	ld b,(hl)		; $7aa5
	ld a,GLOBALFLAG_50		; $7aa6
	add b			; $7aa8
	call setGlobalFlag		; $7aa9
	ld a,$20		; $7aac
	add b			; $7aae
	ld ($c6fb),a		; $7aaf
	ld bc,$0003		; $7ab2
	jp func_1a2e		; $7ab5
	ld a,$4d		; $7ab8
	jp interactionSetHighTextIndex		; $7aba
	add $00			; $7abd
	ld c,a			; $7abf
	ld e,$7f		; $7ac0
	ld a,(de)		; $7ac2
	ld b,a			; $7ac3
	add a			; $7ac4
	add a			; $7ac5
	add b			; $7ac6
	add c			; $7ac7
	ld e,$72		; $7ac8
	ld (de),a		; $7aca
	ret			; $7acb
	or l			; $7acc
	inc d			; $7acd
	jp c,$b57a		; $7ace
	ld de,$7ad7		; $7ad1
	sub a			; $7ad4
	scf			; $7ad5
	inc d			; $7ad6
	sub a			; $7ad7
	scf			; $7ad8
	dec d			; $7ad9
.DB $eb				; $7ada
	sbc (hl)		; $7adb
	cp l			; $7adc
	or l			; $7add
	ld (hl),c		; $7ade
	ld c,$7b		; $7adf
	sbc b			; $7ae1
	scf			; $7ae2
	nop			; $7ae3
	or $c3			; $7ae4
	nop			; $7ae6
	xor $7a			; $7ae7
	sbc b			; $7ae9
	scf			; $7aea
	ld bc,$117b		; $7aeb
	add (hl)		; $7aee
	inc bc			; $7aef
	or $cb			; $7af0
	adc c			; $7af2
	call z,$fc00		; $7af3
	ld a,d			; $7af6
	sbc b			; $7af7
	scf			; $7af8
	inc bc			; $7af9
	ld a,e			; $7afa
	ld de,$67b6		; $7afb
	sbc b			; $7afe
	scf			; $7aff
	ld (bc),a		; $7b00
	or $e1			; $7b01
	inc sp			; $7b03
	ld d,c			; $7b04
	cpl			; $7b05
	or (hl)			; $7b06
	ld (hl),c		; $7b07
	or $98			; $7b08
	scf			; $7b0a
	inc b			; $7b0b
	ld a,e			; $7b0c
	ld de,$3798		; $7b0d
	dec b			; $7b10
	cp (hl)			; $7b11
	ld a,d			; $7b12
.DB $db				; $7b13
	ld a,(wScrollMode)		; $7b14
	and $01			; $7b17
	call $5118		; $7b19
	cpl			; $7b1c
	ld ($cddb),a		; $7b1d
	ret			; $7b20
	ld a,($c6c3)		; $7b21
	or a			; $7b24
	ld b,$01		; $7b25
	jr nz,_label_15_231	; $7b27
	dec b			; $7b29
_label_15_231:
	ld a,b			; $7b2a
	ld (wCFC1),a		; $7b2b
	ret			; $7b2e
	ld a,$70		; $7b2f
	call playSound		; $7b31
	call objectGetTileAtPosition		; $7b34
	ld c,l			; $7b37
	ld e,$42		; $7b38
	ld a,(de)		; $7b3a
	ld b,a			; $7b3b
	ld a,$d4		; $7b3c
	add b			; $7b3e
	call setTile		; $7b3f
	call getThisRoomFlags		; $7b42
	ld e,$42		; $7b45
	ld a,(de)		; $7b47
	ld bc,bitTable		; $7b48
	add c			; $7b4b
	ld c,a			; $7b4c
	ld a,(bc)		; $7b4d
	or (hl)			; $7b4e
	ld (hl),a		; $7b4f
	ld hl,$c6c3		; $7b50
	dec (hl)		; $7b53
	ld e,$42		; $7b54
	ld a,(de)		; $7b56
	ld hl,$7b6b		; $7b57
	rst_addDoubleIndex			; $7b5a
	ldi a,(hl)		; $7b5b
	ld c,a			; $7b5c
	ld a,$09		; $7b5d
	push hl			; $7b5f
	call setTile		; $7b60
	pop hl			; $7b63
	ld a,(hl)		; $7b64
	ld c,a			; $7b65
	ld a,$09		; $7b66
	jp setTile		; $7b68
	add (hl)		; $7b6b
	adc b			; $7b6c
	ld c,e			; $7b6d
	ld l,e			; $7b6e
	ld h,$28		; $7b6f
	ld b,e			; $7b71
	ld h,e			; $7b72
	ld a,$0a		; $7b73
	call setScreenShakeCounter		; $7b75
	ld a,$3a		; $7b78
	ld c,$34		; $7b7a
	call setTile		; $7b7c
	ld a,$3a		; $7b7f
	ld c,$44		; $7b81
	call setTile		; $7b83
	ld hl,$7ba1		; $7b86
	call $7bde		; $7b89
	call $7bde		; $7b8c
	call $7bde		; $7b8f
	call $7bde		; $7b92
	ld bc,$4840		; $7b95
	call $7bee		; $7b98
	ld bc,$4850		; $7b9b
	jp $7bee		; $7b9e
	inc sp			; $7ba1
	ldd a,(hl)		; $7ba2
	adc c			; $7ba3
	ld bc,$3a35		; $7ba4
	adc c			; $7ba7
	inc bc			; $7ba8
	ld b,e			; $7ba9
	sbc b			; $7baa
.DB $ec				; $7bab
	ld bc,$9a45		; $7bac
.DB $ec				; $7baf
	inc bc			; $7bb0
	ld a,$0a		; $7bb1
	call setScreenShakeCounter		; $7bb3
	ld a,$3a		; $7bb6
	ld c,$33		; $7bb8
	call setTile		; $7bba
	ld a,$3a		; $7bbd
	ld c,$35		; $7bbf
	call setTile		; $7bc1
	ld a,$3a		; $7bc4
	ld c,$43		; $7bc6
	call setTile		; $7bc8
	ld a,$3a		; $7bcb
	ld c,$45		; $7bcd
	call setTile		; $7bcf
	ld bc,$4830		; $7bd2
	call $7bee		; $7bd5
	ld bc,$4860		; $7bd8
	jp $7bee		; $7bdb
	ldi a,(hl)		; $7bde
	ldh (<hFF8C),a	; $7bdf
	ldi a,(hl)		; $7be1
	ldh (<hFF8F),a	; $7be2
	ldi a,(hl)		; $7be4
	ldh (<hFF8E),a	; $7be5
	ldi a,(hl)		; $7be7
	push hl			; $7be8
	call setInterleavedTile		; $7be9
	pop hl			; $7bec
	ret			; $7bed
	call getFreeInteractionSlot		; $7bee
	ret nz			; $7bf1
	ld (hl),$05		; $7bf2
	ld l,$4b		; $7bf4
	ld (hl),b		; $7bf6
	ld l,$4d		; $7bf7
	ld (hl),c		; $7bf9
	ret			; $7bfa

.ends


