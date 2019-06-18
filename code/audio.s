.include "include/rominfo.s"
.include "include/musicMacros.s"

.include "include/constants.s"

.BANK $39 SLOT 1
.ORG 0

;;
; @addr{4000}
b39_initSound:
	jp _initSound		; $4000

;;
; @addr{4003}
b39_updateSound:
	jp _updateSound		; $4003

;;
; @param	a	Sound to play
; @addr{4006}
b39_playSound:
	jp _playSound		; $4006

;;
; @addr{4009}
b39_stopSound:
	jp _stopSound		; $4009

;;
; Unused? (The address it jumps too doesn't seem like it would do anything useful...)
; @addr{400c}
func_39_400c:
	pop af			; $400c
	jp $4d3e		; $400d

;;
; @param	a	Volume (0-3)
; @addr{4010}
b39_updateMusicVolume:
	jp _updateMusicVolume		; $4010


; This is pointless?
.dw sound00


;;
; @addr{4015}
_initSound:
	ldh (<hSoundDataBaseBank),a	; $4015
	call _stopSound		; $4017
	ld a,$03		; $401a
	ld (wMusicVolume),a		; $401c
	ld a,$00		; $401f
	ld (wSoundFadeDirection),a		; $4021
	ld (wSoundFadeCounter),a		; $4024
	ld (wSoundDisabled),a		; $4027
	ld (wc023),a		; $402a
	ld a,$8f		; $402d
	ld ($ff00+R_NR52),a	; $402f
	ld a,$77		; $4031
	ld (wSoundVolume),a		; $4033
	ld ($ff00+R_NR50),a	; $4036
	ld a,$ff		; $4038
	ld ($ff00+R_NR51),a	; $403a
	ld c,@readFunctionEnd-@readFunction+2	; $403c
	ld hl,@readFunction		; $403e
	ld de,wMusicReadFunction		; $4041
-
	ldi a,(hl)		; $4044
	ld (de),a		; $4045
	inc de			; $4046
	dec c			; $4047
	jr nz,-			; $4048
	ret			; $404a

; This function is copied to wMusicReadFunction and executed there.
@readFunction:
	ldh (<hSoundDataBaseBank2),a	; $404b
	ld ($2000),a		; $404d
	ldi a,(hl)		; $4050
	ld c,a			; $4051
	ldh a,(<hSoundDataBaseBank)	; $4052
	ldh (<hSoundDataBaseBank2),a	; $4054
	ld ($2000),a		; $4056
	ld a,c			; $4059
	ret			; $405a
	ret			; $405b
	ret			; $405c
@readFunctionEnd:


;;
; @param	a	Volume (0-3)
;
; @addr{405d}
_updateMusicVolume:
	push bc			; $405d
	push de			; $405e
	push hl			; $405f
	push af			; $4060
	call @updateSquareChannelVolumes		; $4061

	pop af			; $4064
	ld (wMusicVolume),a		; $4065
	cp $00			; $4068
	jr nz,+			; $406a

	ld a,$01		; $406c
	jr ++			; $406e
+
	ld a,$00		; $4070
++
	ld (wc023),a		; $4072
	pop hl			; $4075
	pop de			; $4076
	pop bc			; $4077
	ret			; $4078

;;
; @addr{4079}
@updateSquareChannelVolumes:
	; Update square 1's volume
	ld a,$00		; $4079
	ld (wSoundChannel),a		; $407b
	ld hl,wChannelsEnabled		; $407e
	ld a,(wSoundChannel)		; $4081
	ld e,a			; $4084
	ld d,$00		; $4085
	add hl,de		; $4087
	ld a,(hl)		; $4088
	cp $00			; $4089
	jr z,+			; $408b
	call _updateChannelStuff		; $408d
+
	; Update square 2's volume
	ld a,$01		; $4090
	ld (wSoundChannel),a		; $4092
	ld hl,wChannelsEnabled		; $4095
	ld a,(wSoundChannel)		; $4098
	ld e,a			; $409b
	ld d,$00		; $409c
	add hl,de		; $409e
	ld a,(hl)		; $409f
	cp $00			; $40a0
	jr z,+			; $40a2
	call _updateChannelStuff		; $40a4
+
	ret			; $40a7

;;
; @addr{40a8}
_stopSound:
	ld a,$00		; $40a8
-
	ld (wSoundChannel),a		; $40aa
	call _channelCmdff		; $40ad
	ld a,(wSoundChannel)		; $40b0
	inc a			; $40b3
	cp $08			; $40b4
	jr nz,-			; $40b6
	ret			; $40b8

;;
; @addr{40b9}
_func_39_40b9:
	ld a,$00		; $40b9
-
	ld (wSoundChannel),a		; $40bb
	call _updateChannelStuff		; $40be
	ld a,(wSoundChannel)		; $40c1
	inc a			; $40c4
	cp $08			; $40c5
	jr nz,-			; $40c7
	ret			; $40c9

;;
; Disable all sound effect channels
;
; @addr{40ca}
_stopSfx:
	; Square 1
	ld a,$02		; $40ca
	ld (wSoundChannel),a		; $40cc
	ld hl,wChannelsEnabled		; $40cf
	ld a,(wSoundChannel)		; $40d2
	ld e,a			; $40d5
	ld d,$00		; $40d6
	add hl,de		; $40d8
	ld a,(hl)		; $40d9
	cp $00			; $40da
	jr z,+			; $40dc
	call _channelCmdff		; $40de
+
	; Square 2
	ld a,$03		; $40e1
	ld (wSoundChannel),a		; $40e3
	ld hl,wChannelsEnabled		; $40e6
	ld a,(wSoundChannel)		; $40e9
	ld e,a			; $40ec
	ld d,$00		; $40ed
	add hl,de		; $40ef
	ld a,(hl)		; $40f0
	cp $00			; $40f1
	jr z,+			; $40f3
	call _channelCmdff		; $40f5
+
	; Wave
	ld a,$05		; $40f8
	ld (wSoundChannel),a		; $40fa
	ld hl,wChannelsEnabled		; $40fd
	ld a,(wSoundChannel)		; $4100
	ld e,a			; $4103
	ld d,$00		; $4104
	add hl,de		; $4106
	ld a,(hl)		; $4107
	cp $00			; $4108
	jr z,+			; $410a
	call _channelCmdff		; $410c
+
	; Noise
	ld a,$07		; $410f
	ld (wSoundChannel),a		; $4111
	ld hl,wChannelsEnabled		; $4114
	ld a,(wSoundChannel)		; $4117
	ld e,a			; $411a
	ld d,$00		; $411b
	add hl,de		; $411d
	ld a,(hl)		; $411e
	cp $00			; $411f
	jr z,+			; $4121
	call _channelCmdff		; $4123
+
	ret			; $4126

;;
; @addr{4127}
_updateSound:
	push bc			; $4127
	push de			; $4128
	push hl			; $4129
	ld a,(wSoundDisabled)		; $412a
	cp $00			; $412d
	jr z,+			; $412f
	jp @ret			; $4131
+
	ld a,(wSoundVolume)		; $4134
	ld ($ff00+R_NR50),a	; $4137
	ld a,(wSoundFadeDirection)		; $4139
	cp $00			; $413c
	jr z,@updateChannels	; $413e

	ld a,(wSoundFadeSpeed)		; $4140
	ld b,a			; $4143
	ld a,(wSoundFadeCounter)		; $4144
	inc a			; $4147
	ld (wSoundFadeCounter),a		; $4148
	and b			; $414b
	cp b			; $414c
	jr nz,@updateChannels	; $414d

	ld a,(wSoundFadeDirection)		; $414f
	cp $0a			; $4152
	jr z,@incVolume		; $4154

@decVolume:
	ld a,(wSoundVolume)		; $4156
	cp $00			; $4159
	jr z,@stopSound		; $415b

	sub $11			; $415d
	ld (wSoundVolume),a		; $415f
	jp @updateChannels		; $4162

@incVolume:
	ld a,(wSoundVolume)		; $4165
	cp $77			; $4168
	jr z,@clearFadeVariables	; $416a

	add $11			; $416c
	ld (wSoundVolume),a		; $416e
	jp @updateChannels		; $4171

@stopSound:
	call _stopSound		; $4174

@clearFadeVariables:
	ld a,$00		; $4177
	ld (wSoundFadeCounter),a		; $4179
	ld (wSoundFadeDirection),a		; $417c

@updateChannels:
	ld a,$00		; $417f
@channelLoop:
	ld (wSoundChannel),a		; $4181
	ld hl,wChannelsEnabled		; $4184
	ld a,(wSoundChannel)		; $4187
	ld e,a			; $418a
	ld d,$00		; $418b
	add hl,de		; $418d
	ld a,(hl)		; $418e
	cp $00			; $418f
	jr z,@nextChannel	; $4191

	ld hl,wChannelWaitCounters		; $4193
	ld a,(wSoundChannel)		; $4196
	ld e,a			; $4199
	ld d,$00		; $419a
	add hl,de		; $419c
	ld a,(hl)		; $419d
	cp $00			; $419e
	jr nz,+		; $41a0

	call _doNextChannelCommand		; $41a2
	jr @nextChannel		; $41a5
+
	call _func_39_41c2		; $41a7
@nextChannel:
	ld a,(wSoundChannel)		; $41aa
	inc a			; $41ad
	cp $08			; $41ae
	jr nz,@channelLoop	; $41b0

	ld a,(wc023)		; $41b2
	cp $01			; $41b5
	jr nz,@ret			; $41b7

	ld a,$02		; $41b9
	ld (wc023),a		; $41bb

@ret:
	pop hl			; $41be
	pop de			; $41bf
	pop bc			; $41c0
	ret			; $41c1

;;
; @addr{41c2}
_func_39_41c2:
	ld hl,wChannelWaitCounters		; $41c2
	ld a,(wSoundChannel)		; $41c5
	ld e,a			; $41c8
	ld d,$00		; $41c9
	add hl,de		; $41cb
	ld a,(hl)		; $41cc
	dec a			; $41cd
	ld (hl),a		; $41ce
	ld a,(wSoundChannel)		; $41cf
	cp $06			; $41d2
	jr nc,@ret		; $41d4

	ld hl,wc039		; $41d6
	ld a,(wSoundChannel)		; $41d9
	ld e,a			; $41dc
	ld d,$00		; $41dd
	add hl,de		; $41df
	ld a,(hl)		; $41e0
	and $40			; $41e1
	jr nz,@ret		; $41e3
	ld a,(wSoundChannel)		; $41e5
	cp $05			; $41e8
	jr nc,+			; $41ea
	call _func_39_464c		; $41ec
+
	call _func_39_41f3		; $41ef
@ret:
	ret			; $41f2

;;
; @addr{41f3}
_func_39_41f3:
	ld hl,wc03f		; $41f3
	ld a,(wSoundChannel)		; $41f6
	ld e,a			; $41f9
	ld d,$00		; $41fa
	add hl,de		; $41fc
	ld a,(hl)		; $41fd
	ld c,a			; $41fe
	and $7f			; $41ff
	jr z,_label_39_024	; $4201

	ld a,c			; $4203
	and $80			; $4204
	jr nz,+			; $4206

	ld d,$00		; $4208
	jr ++			; $420a
+
	ld d,$ff		; $420c
++
	push de			; $420e
	ld hl,wc03f		; $420f
	ld a,(wSoundChannel)		; $4212
	ld e,a			; $4215
	ld d,$00		; $4216
	add hl,de		; $4218
	ld a,(hl)		; $4219
	pop de			; $421a
	ld e,a			; $421b
	ld a,(wSoundChannel)		; $421c
	sla a			; $421f
	ld b,a			; $4221
	ld a,b			; $4222
	add <hSoundData3			; $4223
	ld c,a			; $4225
	ld a,($ff00+c)		; $4226
	inc c			; $4227
	ld l,a			; $4228
	ld a,($ff00+c)		; $4229
	inc c			; $422a
	ld h,a			; $422b
	add hl,de		; $422c
	ld a,(wSoundChannel)		; $422d
	sla a			; $4230
	ld b,a			; $4232
	ld a,l			; $4233
	ld c,<hSoundData3		; $4234
	call _writeIndexedHighRamAndIncrement		; $4236
	ld a,h			; $4239
	ld ($ff00+c),a		; $423a
	inc c			; $423b
_label_39_024:
	ld hl,wc045		; $423c
	ld a,(wSoundChannel)		; $423f
	ld e,a			; $4242
	ld d,$00		; $4243
	add hl,de		; $4245
	ld a,(hl)		; $4246
	and $10			; $4247
	jr nz,_label_39_026	; $4249

	ld hl,wc051		; $424b
	ld a,(wSoundChannel)		; $424e
	ld e,a			; $4251
	ld d,$00		; $4252
	add hl,de		; $4254
	ld a,(hl)		; $4255
	cp $00			; $4256
	jr z,_label_39_025	; $4258

	dec a			; $425a
	ld hl,wc051		; $425b
	push af			; $425e
	ld a,(wSoundChannel)		; $425f
	ld e,a			; $4262
	ld d,$00		; $4263
	add hl,de		; $4265
	pop af			; $4266
	ld (hl),a		; $4267
	ld hl,$0000		; $4268
	jp _func_42d1		; $426b

_label_39_025:
	ld a,$10		; $426e
	ld hl,wc045		; $4270
	push af			; $4273
	ld a,(wSoundChannel)		; $4274
	ld e,a			; $4277
	ld d,$00		; $4278
	add hl,de		; $427a
	pop af			; $427b
	ld (hl),a		; $427c
	ld a,$00		; $427d
	ld hl,wc051		; $427f
	push af			; $4282
	ld a,(wSoundChannel)		; $4283
	ld e,a			; $4286
	ld d,$00		; $4287
	add hl,de		; $4289
	pop af			; $428a
	ld (hl),a		; $428b
_label_39_026:
	ld hl,wc051		; $428c
	ld a,(wSoundChannel)		; $428f
	ld e,a			; $4292
	ld d,$00		; $4293
	add hl,de		; $4295
	ld a,(hl)		; $4296
	cp $08			; $4297
	jr nz,_label_39_027	; $4299

	ld a,$00		; $429b
	ld hl,wc051		; $429d
	push af			; $42a0
	ld a,(wSoundChannel)		; $42a1
	ld e,a			; $42a4
	ld d,$00		; $42a5
	add hl,de		; $42a7
	pop af			; $42a8
	ld (hl),a		; $42a9
	ld a,$00		; $42aa
_label_39_027:
	ld hl,_data_4b40		; $42ac
	call _readWordFromTable		; $42af
	push hl			; $42b2
	ld hl,wc051		; $42b3
	ld a,(wSoundChannel)		; $42b6
	ld e,a			; $42b9
	ld d,$00		; $42ba
	add hl,de		; $42bc
	ld a,(hl)		; $42bd
	inc a			; $42be
	ld (hl),a		; $42bf
	ld hl,wChannelVibratos		; $42c0
	ld a,(wSoundChannel)		; $42c3
	ld e,a			; $42c6
	ld d,$00		; $42c7
	add hl,de		; $42c9
	ld a,(hl)		; $42ca
	and $0f			; $42cb
	pop hl			; $42cd
	call _func_39_4a10		; $42ce

;;
; @addr{42d1}
_func_42d1:
	ld a,(wSoundChannel)		; $42d1
	sla a			; $42d4
	ld b,a			; $42d6
	ld a,b			; $42d7
	add $f2			; $42d8
	ld c,a			; $42da
	ld a,($ff00+c)		; $42db
	inc c			; $42dc
	ld e,a			; $42dd
	ld a,($ff00+c)		; $42de
	inc c			; $42df
	ld d,a			; $42e0
	add hl,de		; $42e1
	ld a,l			; $42e2
	ld (wSoundFrequencyL),a		; $42e3
	ld a,h			; $42e6
	ld (wSoundFrequencyH),a		; $42e7

;;
; @addr{42ea}
_func_42ea:
	ld a,(wSoundChannel)		; $42ea
	scf			; $42ed
	ccf			; $42ee
	cp $04			; $42ef
	jr nc,_label_39_029	; $42f1

	cp $02			; $42f3
	jr nc,_label_39_028	; $42f5

	inc a			; $42f7
	inc a			; $42f8
	ld e,a			; $42f9
	ld hl,wChannelsEnabled		; $42fa
	ld d,$00		; $42fd
	add hl,de		; $42ff
	ld a,(hl)		; $4300
	cp $00			; $4301
	jr z,_label_39_028	; $4303
	ret			; $4305

_label_39_028:
	ld a,(wSoundChannel)		; $4306
	and $01			; $4309
	ld b,a			; $430b
	sla a			; $430c
	sla a			; $430e
	add b			; $4310
	ld b,a			; $4311
	push bc			; $4312
	ld a,(wSoundFrequencyL)		; $4313
	ld c,R_NR13		; $4316
	call _writeIndexedHighRamAndIncrement		; $4318
	ld a,(wSoundCmdEnvelope)		; $431b
	ld e,a			; $431e
	ld a,(wSoundFrequencyH)		; $431f
	or e			; $4322
	ld ($ff00+c),a		; $4323
	inc c			; $4324
	pop bc			; $4325
	push bc			; $4326
	ld hl,wChannelDutyCycles		; $4327
	ld a,(wSoundChannel)		; $432a
	ld e,a			; $432d
	ld d,$00		; $432e
	add hl,de		; $4330
	ld a,(hl)		; $4331
	pop bc			; $4332
	ld c,$11		; $4333
	call _writeIndexedHighRamAndIncrement		; $4335
	ret			; $4338

_label_39_029:
	call _func_39_434b		; $4339
	cp $00			; $433c
	jr nz,_label_39_030	; $433e
	ld a,l			; $4340
	ld ($ff00+R_NR33),a	; $4341
	ld a,h			; $4343
	ld ($ff00+R_NR34),a	; $4344
	ld a,$00		; $4346
	ld ($ff00+R_NR31),a	; $4348
_label_39_030:
	ret			; $434a

;;
; @param[out]	a	0 or 1 (something about whether wSoundChannel can be active?)
; @addr{434b}
_func_39_434b:
	ld a,(wSoundChannel)		; $434b
	cp $05			; $434e
	jr z,@zero		; $4350

	ld a,(wChannelsEnabled+5)		; $4352
	cp $00			; $4355
	jr nz,@one		; $4357

	ld a,(wc023)		; $4359
	cp $02			; $435c
	jr z,@one			; $435e
@zero:
	ld a,$00		; $4360
	ret			; $4362
@one:
	ld a,$01		; $4363
	ret			; $4365

;;
; @addr{4366}
_getNextChannelByte:
	push bc			; $4366
	push de			; $4367
	push hl			; $4368
	ld a,(wSoundChannel)		; $4369
	sla a			; $436c
	add <hSoundChannelAddresses	; $436e
	ld c,a			; $4370
	ld a,($ff00+c)		; $4371
	inc c			; $4372
	ld l,a			; $4373
	ld a,($ff00+c)		; $4374
	ld h,a			; $4375
	ld a,(wSoundChannel)		; $4376
	add <hSoundChannelBanks	; $4379
	ld c,a			; $437b
	ld a,($ff00+c)		; $437c
	inc c			; $437d
	call wMusicReadFunction		; $437e
	push af			; $4381
	ld a,(wSoundChannel)		; $4382
	sla a			; $4385
	ld b,a			; $4387
	ld a,l			; $4388
	ld c,<hSoundChannelAddresses		; $4389
	call _writeIndexedHighRamAndIncrement		; $438b
	ld a,h			; $438e
	ld ($ff00+c),a		; $438f
	inc c			; $4390
	pop af			; $4391
	pop hl			; $4392
	pop de			; $4393
	pop bc			; $4394
	ret			; $4395

;;
; @addr{4396}
_doNextChannelCommand:
	call _getNextChannelByte		; $4396
	scf			; $4399
	ccf			; $439a
	cp $f0			; $439b
	jr nc,@cmdf0Toff	; $439d

	scf			; $439f
	ccf			; $43a0
	cp $e0			; $43a1
	jr c,+			; $43a3
	jp _cmde0Toef		; $43a5
+
	scf			; $43a8
	ccf			; $43a9
	cp $d0			; $43aa
	jr c,+			; $43ac
	jp _cmdVolume		; $43ae
+
	ld (wSoundCmd),a		; $43b1
	jp _standardSoundCmd		; $43b4

@cmdf0Toff:
	ld e,a			; $43b7
	ld a,$ff		; $43b8
	sub e			; $43ba
	ld hl,@table		; $43bb
	call _readWordFromTable		; $43be
	jp hl			; $43c1

@table:
	.dw _channelCmdff
	.dw _channelCmdfe
	.dw _channelCmdfd
	.dw _channelCmdff
	.dw _channelCmdff
	.dw _channelCmdff
	.dw _channelCmdf9
	.dw _channelCmdf8
	.dw _channelCmdff
	.dw _channelCmdf6
	.dw _channelCmdff
	.dw _channelCmdff
	.dw _channelCmdf3
	.dw _channelCmdf2
	.dw _channelCmdf1
	.dw _channelCmdf0

;;
; @addr{43e2}
_channelCmdf1:
	jp _doNextChannelCommand		; $43e2
;;
; @addr{43e5}
_channelCmdf2:
	jp _doNextChannelCommand		; $43e5
;;
; @addr{43e8}
_channelCmdf3:
	jp _doNextChannelCommand		; $43e8

;;
; Vibrato
;
; @addr{43eb}
_channelCmdf9:
	ld a,(wSoundChannel)		; $43eb
	scf			; $43ee
	ccf			; $43ef
	cp $06			; $43f0
	jr nc,++		; $43f2

	call _getNextChannelByte		; $43f4
	ld hl,wChannelVibratos		; $43f7
	push af			; $43fa
	ld a,(wSoundChannel)		; $43fb
	ld e,a			; $43fe
	ld d,$00		; $43ff
	add hl,de		; $4401
	pop af			; $4402
	ld (hl),a		; $4403
	jp _doNextChannelCommand		; $4404

;;
; @addr{4407}
_channelCmdf8:
	ld a,(wSoundChannel)		; $4407
	scf			; $440a
	ccf			; $440b
	cp $06			; $440c
	jr nc,++		; $440e

	call _getNextChannelByte		; $4410
	ld hl,wc03f		; $4413
	push af			; $4416
	ld a,(wSoundChannel)		; $4417
	ld e,a			; $441a
	ld d,$00		; $441b
	add hl,de		; $441d
	pop af			; $441e
	ld (hl),a		; $441f
	jp _doNextChannelCommand		; $4420

;;
; @addr{4423}
_channelCmdfd:
	ld a,(wSoundChannel)		; $4423
	scf			; $4426
	ccf			; $4427
	cp $06			; $4428
	jr nc,++		; $442a

	call _getNextChannelByte		; $442c
	ld hl,wChannelPitchShift		; $442f
	push af			; $4432
	ld a,(wSoundChannel)		; $4433
	ld e,a			; $4436
	ld d,$00		; $4437
	add hl,de		; $4439
	pop af			; $443a
	ld (hl),a		; $443b
	jp _doNextChannelCommand		; $443c
++
	call _getNextChannelByte		; $443f
	jp _doNextChannelCommand		; $4442

;;
; @addr{4445}
_cmde0Toef:
	and $07			; $4445
	ld hl,wChannelEnvelopes		; $4447
	push af			; $444a
	ld a,(wSoundChannel)		; $444b
	ld e,a			; $444e
	ld d,$00		; $444f
	add hl,de		; $4451
	pop af			; $4452
	ld (hl),a		; $4453
	call _getNextChannelByte		; $4454
	and $07			; $4457
	ld hl,wChannelEnvelopes2		; $4459
	push af			; $445c
	ld a,(wSoundChannel)		; $445d
	ld e,a			; $4460
	ld d,$00		; $4461
	add hl,de		; $4463
	pop af			; $4464
	ld (hl),a		; $4465
	jp _doNextChannelCommand		; $4466

;;
; @addr{4469}
_channelCmdf0:
	ld a,(wSoundChannel)		; $4469
	cp $07			; $446c
	jr z,_label_39_038	; $446e

	call _getNextChannelByte		; $4470
	push af			; $4473
	and $3f			; $4474
	jr z,_label_39_037	; $4476

	pop af			; $4478
	ld hl,wChannelDutyCycles		; $4479
	push af			; $447c
	ld a,(wSoundChannel)		; $447d
	ld e,a			; $4480
	ld d,$00		; $4481
	add hl,de		; $4483
	pop af			; $4484
	ld (hl),a		; $4485
	ld a,$41		; $4486
	ld hl,wc039		; $4488
	push af			; $448b
	ld a,(wSoundChannel)		; $448c
	ld e,a			; $448f
	ld d,$00		; $4490
	add hl,de		; $4492
	pop af			; $4493
	ld (hl),a		; $4494
	jp _doNextChannelCommand		; $4495
_label_39_037:
	pop af			; $4498
	and $c0			; $4499
	ld hl,wChannelDutyCycles		; $449b
	push af			; $449e
	ld a,(wSoundChannel)		; $449f
	ld e,a			; $44a2
	ld d,$00		; $44a3
	add hl,de		; $44a5
	pop af			; $44a6
	ld (hl),a		; $44a7
	ld a,$01		; $44a8
	ld hl,wc039		; $44aa
	push af			; $44ad
	ld a,(wSoundChannel)		; $44ae
	ld e,a			; $44b1
	ld d,$00		; $44b2
	add hl,de		; $44b4
	pop af			; $44b5
	ld (hl),a		; $44b6
	jp _doNextChannelCommand		; $44b7
_label_39_038:
	call _getNextChannelByte		; $44ba
	ld ($ff00+R_NR42),a	; $44bd
	ld a,$00		; $44bf
	ld ($ff00+R_NR41),a	; $44c1
	ld a,$80		; $44c3
	ld ($c01c),a		; $44c5
	jp _doNextChannelCommand		; $44c8

; Command $d0 to $df
_cmdVolume:
	push af			; $44cb
	ld a,(wSoundChannel)		; $44cc
	cp $04			; $44cf
	jr z,@next			; $44d1

	pop af			; $44d3
	and $0f			; $44d4
	ld hl,wChannelVolumes		; $44d6
	push af			; $44d9
	ld a,(wSoundChannel)		; $44da
	ld e,a			; $44dd
	ld d,$00		; $44de
	add hl,de		; $44e0
	pop af			; $44e1
	ld (hl),a		; $44e2
	jp _doNextChannelCommand		; $44e3

@next:
	pop af			; $44e6
	jp _doNextChannelCommand		; $44e7

;;
; @addr{44ea}
_channelCmdf6:
	ld a,(wSoundChannel)		; $44ea
	cp $04			; $44ed
	jr z,@wave		; $44ef

	cp $05			; $44f1
	jr z,@wave		; $44f3

	call _getNextChannelByte		; $44f5
	and $03			; $44f8
	swap a			; $44fa
	sla a			; $44fc
	sla a			; $44fe
	ld hl,wChannelDutyCycles		; $4500
	push af			; $4503
	ld a,(wSoundChannel)		; $4504
	ld e,a			; $4507
	ld d,$00		; $4508
	add hl,de		; $450a
	pop af			; $450b
	ld (hl),a		; $450c
	jp _doNextChannelCommand		; $450d

@wave:
	call _getNextChannelByte		; $4510
	ld hl,wChannelDutyCycles		; $4513
	push af			; $4516
	ld a,(wSoundChannel)		; $4517
	ld e,a			; $451a
	ld d,$00		; $451b
	add hl,de		; $451d
	pop af			; $451e
	ld (hl),a		; $451f
	ld (wWaveformIndex),a		; $4520
	call _setWaveform		; $4523
	jp _doNextChannelCommand		; $4526

;;
; @addr{4529}
_standardSoundCmd:
	ld a,(wSoundChannel)		; $4529
	ld hl,@table		; $452c
	call _readWordFromTable		; $452f
	jp hl			; $4532

@table:
	.dw @channel0To3
	.dw @channel0To3
	.dw @channel0To3
	.dw @channel0To3
	.dw _standardCmdChannels4To5
	.dw _standardCmdChannels4To5
	.dw _standardCmdChannel6
	.dw _standardCmdChannel7

@channel0To3:
	ld hl,wc039		; $4543
	ld a,(wSoundChannel)		; $4546
	ld e,a			; $4549
	ld d,$00		; $454a
	add hl,de		; $454c
	ld a,(hl)		; $454d
	cp $00			; $454e
	jr z,+			; $4550

	call _getNextChannelByte		; $4552
	ld l,a			; $4555
	ld a,(wSoundCmd)		; $4556
	ld h,a			; $4559
	jp @cmdUnknown		; $455a
+
	ld a,(wSoundCmd)		; $455d
	cp $60			; $4560
	jr z,@cmd60		; $4562

	cp $61			; $4564
	jr z,@cmd61		; $4566

	jp @cmdFrequency		; $4568

@cmd60:
	ld hl,wChannelEnvelopes2		; $456b
	ld a,(wSoundChannel)		; $456e
	ld e,a			; $4571
	ld d,$00		; $4572
	add hl,de		; $4574
	ld a,(hl)		; $4575
	cp $00			; $4576
	jr nz,@cmd61		; $4578

	ld a,$02		; $457a
	ld hl,wc05d		; $457c
	push af			; $457f
	ld a,(wSoundChannel)		; $4580
	ld e,a			; $4583
	ld d,$00		; $4584
	add hl,de		; $4586
	pop af			; $4587
	ld (hl),a		; $4588
	call _getChannelVolume		; $4589
	sla a			; $458c
	sla a			; $458e
	sla a			; $4590
	sla a			; $4592
	ld c,$01		; $4594
	or c			; $4596
	ld (wSoundCmdEnvelope),a		; $4597
	call _updateChannelVolume		; $459a
	call _func_39_41f3		; $459d
@cmd61:
	jp _setChannelWaitCounter		; $45a0

@cmdFrequency:
	ld a,(wSoundCmd)		; $45a3
	sub $0c			; $45a6
	ld hl,_soundFrequencyTable		; $45a8
	call _readWordFromTable		; $45ab
@cmdUnknown:
	call _setSoundFrequency		; $45ae
	ld a,$00		; $45b1
	ld hl,wc05d		; $45b3
	push af			; $45b6
	ld a,(wSoundChannel)		; $45b7
	ld e,a			; $45ba
	ld d,$00		; $45bb
	add hl,de		; $45bd
	pop af			; $45be
	ld (hl),a		; $45bf
	call _func_39_464c		; $45c0
	ld a,$00		; $45c3
	ld hl,wc045		; $45c5
	push af			; $45c8
	ld a,(wSoundChannel)		; $45c9
	ld e,a			; $45cc
	ld d,$00		; $45cd
	add hl,de		; $45cf
	pop af			; $45d0
	ld (hl),a		; $45d1
	ld a,$00		; $45d2
	ld hl,wChannelVibratos		; $45d4
	ld a,(wSoundChannel)		; $45d7
	ld e,a			; $45da
	ld d,$00		; $45db
	add hl,de		; $45dd
	ld a,(hl)		; $45de
	and $f0			; $45df
	srl a			; $45e1
	srl a			; $45e3
	srl a			; $45e5
	ld hl,wc051		; $45e7
	push af			; $45ea
	ld a,(wSoundChannel)		; $45eb
	ld e,a			; $45ee
	ld d,$00		; $45ef
	add hl,de		; $45f1
	pop af			; $45f2
	ld (hl),a		; $45f3
	call _func_42ea		; $45f4
;;
; Read a byte, set the channel wait counter to the value
; @addr{45f7}
_setChannelWaitCounter:
	call _getNextChannelByte		; $45f7
	dec a			; $45fa
	ld hl,wChannelWaitCounters		; $45fb
	push af			; $45fe
	ld a,(wSoundChannel)		; $45ff
	ld e,a			; $4602
	ld d,$00		; $4603
	add hl,de		; $4605
	pop af			; $4606
	ld (hl),a		; $4607
	ret			; $4608

;;
; @addr{4609}
_func_39_4609:
	ld hl,_data_4ad0		; $4609
	ld a,b			; $460c
	sla a			; $460d
	sla a			; $460f
	sla a			; $4611
	add c			; $4613
	ld d,$00		; $4614
	ld e,a			; $4616
	add hl,de		; $4617
	ld a,(hl)		; $4618
	ret			; $4619

;;
; Sends wSoundFrequency to given value plus value in table at wChannelPitchShift.
; @addr{461a}
_setSoundFrequency:
	push hl			; $461a
	ld hl,wChannelPitchShift		; $461b
	ld a,(wSoundChannel)		; $461e
	ld e,a			; $4621
	ld d,$00		; $4622
	add hl,de		; $4624
	ld a,(hl)		; $4625
	ld d,a			; $4626
	sla d			; $4627
	jr c,+			; $4629

	ld d,$00		; $462b
	jr ++			; $462d
+
	ld d,$ff		; $462f
++
	ld e,a			; $4631
	pop hl			; $4632
	add hl,de		; $4633
	ld a,(wSoundChannel)		; $4634
	sla a			; $4637
	ld b,a			; $4639
	ld a,l			; $463a
	ld c,<hSoundData3		; $463b
	call _writeIndexedHighRamAndIncrement		; $463d
	ld a,h			; $4640
	ld ($ff00+c),a		; $4641
	inc c			; $4642
	ld a,l			; $4643
	ld (wSoundFrequencyL),a		; $4644
	ld a,h			; $4647
	ld (wSoundFrequencyH),a		; $4648
	ret			; $464b

;;
; @addr{464c}
_func_39_464c:
	ld a,(wSoundChannel)		; $464c
	cp $04			; $464f
	jr nz,+			; $4651
	jp _func_39_4766		; $4653
+
	ld hl,wc05d		; $4656
	ld a,(wSoundChannel)		; $4659
	ld e,a			; $465c
	ld d,$00		; $465d
	add hl,de		; $465f
	ld a,(hl)		; $4660
	cp $00			; $4661
	jr z,_label_39_047	; $4663

	cp $01			; $4665
	jr z,_label_39_048	; $4667

	ld a,$00		; $4669
	ld (wSoundCmdEnvelope),a		; $466b
	ret			; $466e
_label_39_047:
	ld hl,wChannelEnvelopes		; $466f
	ld a,(wSoundChannel)		; $4672
	ld e,a			; $4675
	ld d,$00		; $4676
	add hl,de		; $4678
	ld a,(hl)		; $4679
	cp $00			; $467a
	jr z,_label_39_049	; $467c

	ld c,a			; $467e
	or $18			; $467f
	ld (wSoundCmdEnvelope),a		; $4681
	push bc			; $4684
	call _getChannelVolume		; $4685
	pop bc			; $4688
	ld b,a			; $4689
	call _func_39_4609		; $468a
	ld hl,wc061		; $468d
	push af			; $4690
	ld a,(wSoundChannel)		; $4691
	ld e,a			; $4694
	ld d,$00		; $4695
	add hl,de		; $4697
	pop af			; $4698
	ld (hl),a		; $4699
	ld a,$01		; $469a
	ld hl,wc05d		; $469c
	push af			; $469f
	ld a,(wSoundChannel)		; $46a0
	ld e,a			; $46a3
	ld d,$00		; $46a4
	add hl,de		; $46a6
	pop af			; $46a7
	ld (hl),a		; $46a8
	jp _updateChannelVolume		; $46a9

_label_39_048:
	ld hl,wc061		; $46ac
	ld a,(wSoundChannel)		; $46af
	ld e,a			; $46b2
	ld d,$00		; $46b3
	add hl,de		; $46b5
	ld a,(hl)		; $46b6
	cp $00			; $46b7
	jr z,_label_39_049	; $46b9

	ld hl,wc061		; $46bb
	ld a,(wSoundChannel)		; $46be
	ld e,a			; $46c1
	ld d,$00		; $46c2
	add hl,de		; $46c4
	ld a,(hl)		; $46c5
	dec a			; $46c6
	ld (hl),a		; $46c7
	ld a,$00		; $46c8
	ld (wSoundCmdEnvelope),a		; $46ca
	ret			; $46cd

_label_39_049:
	ld hl,wChannelEnvelopes2		; $46ce
	ld a,(wSoundChannel)		; $46d1
	ld e,a			; $46d4
	ld d,$00		; $46d5
	add hl,de		; $46d7
	ld a,(hl)		; $46d8
	cp $00			; $46d9
	jr nz,+			; $46db

	ld a,$02		; $46dd
	jr ++			; $46df
+
	ld a,$03		; $46e1
++
	ld hl,wc05d		; $46e3
	push af			; $46e6
	ld a,(wSoundChannel)		; $46e7
	ld e,a			; $46ea
	ld d,$00		; $46eb
	add hl,de		; $46ed
	pop af			; $46ee
	ld (hl),a		; $46ef
	call _getChannelVolume		; $46f0
	sla a			; $46f3
	sla a			; $46f5
	sla a			; $46f7
	sla a			; $46f9
	ld (wSoundCmdEnvelope),a		; $46fb
	ld hl,wChannelEnvelopes2		; $46fe
	ld a,(wSoundChannel)		; $4701
	ld e,a			; $4704
	ld d,$00		; $4705
	add hl,de		; $4707
	ld a,(hl)		; $4708
	ld c,a			; $4709
	ld a,(wSoundCmdEnvelope)		; $470a
	or c			; $470d
	ld (wSoundCmdEnvelope),a		; $470e
	jp _updateChannelVolume		; $4711

;;
; @addr{4714}
_updateChannelVolume:
	ld a,(wSoundChannel)		; $4714
	cp $02			; $4717
	jr nc,++		; $4719

	ld a,(wMusicVolume)		; $471b
	cp $00			; $471e
	jr z,@ret		; $4720

	ld a,(wSoundChannel)		; $4722
	inc a			; $4725
	inc a			; $4726
	ld e,a			; $4727
	ld hl,wChannelsEnabled		; $4728
	ld d,$00		; $472b
	add hl,de		; $472d
	ld a,(hl)		; $472e
	cp $00			; $472f
	jr z,++			; $4731
@ret:
	ret			; $4733
++
	ld a,(wSoundChannel)		; $4734
	and $01			; $4737
	jr nz,+			; $4739

	; Channel 1 only: sweep off
	ld a,$08		; $473b
	ld ($ff00+R_NR10),a	; $473d
+
	; Set channel volume
	ld a,(wSoundChannel)		; $473f
	and $01			; $4742
	ld b,a			; $4744
	sla a			; $4745
	sla a			; $4747
	add b			; $4749
	ld b,a			; $474a
	ld a,(wSoundCmdEnvelope)		; $474b
	ld c,R_NR12		; $474e
	call _writeIndexedHighRamAndIncrement		; $4750
	ld hl,wc039		; $4753
	ld a,(wSoundChannel)		; $4756
	ld e,a			; $4759
	ld d,$00		; $475a
	add hl,de		; $475c
	ld a,(hl)		; $475d
	and $40			; $475e
	or $80			; $4760
	ld (wSoundCmdEnvelope),a		; $4762
	ret			; $4765

;;
; @addr{4766}
_func_39_4766:
	call _func_39_489e		; $4766
	ld b,a			; $4769
	ld a,(wc025+4)		; $476a
	cp b			; $476d
	jr z,+			; $476e

	call _func_39_489e		; $4770
	ld (wc025+4),a		; $4773
	call _func_39_434b		; $4776
	cp $00			; $4779
	jr nz,+			; $477b

	ld a,(wc025+4)		; $477d
	ld ($ff00+R_NR32),a	; $4780
+
	ret			; $4782

;;
; @addr{4783}
_getChannelVolume:
	ld a,(wSoundChannel)		; $4783
	scf			; $4786
	ccf			; $4787
	cp $02			; $4788
	jr nc,_label_39_056	; $478a
;;
; @addr{478c}
_func_39_478c:
	ld a,(wMusicVolume)		; $478c
	cp $00			; $478f
	jr z,_label_39_059	; $4791
	cp $01			; $4793
	jr z,_label_39_058	; $4795
	cp $02			; $4797
	jr z,_label_39_057	; $4799
_label_39_056:
	ld hl,wChannelVolumes		; $479b
	ld a,(wSoundChannel)		; $479e
	ld e,a			; $47a1
	ld d,$00		; $47a2
	add hl,de		; $47a4
	ld a,(hl)		; $47a5
	ret			; $47a6
_label_39_057:
	ld hl,wChannelVolumes		; $47a7
	ld a,(wSoundChannel)		; $47aa
	ld e,a			; $47ad
	ld d,$00		; $47ae
	add hl,de		; $47b0
	ld a,(hl)		; $47b1
	srl a			; $47b2
	ret			; $47b4
_label_39_058:
	ld hl,wChannelVolumes		; $47b5
	ld a,(wSoundChannel)		; $47b8
	ld e,a			; $47bb
	ld d,$00		; $47bc
	add hl,de		; $47be
	ld a,(hl)		; $47bf
	srl a			; $47c0
	srl a			; $47c2
	ret			; $47c4
_label_39_059:
	ld a,$00		; $47c5
	ret			; $47c7

_standardCmdChannels4To5:
	ld hl,wc039		; $47c8
	ld a,(wSoundChannel)		; $47cb
	ld e,a			; $47ce
	ld d,$00		; $47cf
	add hl,de		; $47d1
	ld a,(hl)		; $47d2
	cp $00			; $47d3
	jr z,+			; $47d5

	call _getNextChannelByte		; $47d7
	ld l,a			; $47da
	ld a,(wSoundCmd)		; $47db
	ld h,a			; $47de
	jp @cmdUnknown		; $47df
+
	ld a,(wSoundCmd)		; $47e2
	scf			; $47e5
	ccf			; $47e6
	cp $60			; $47e7
	jr nz,@freqCommand	; $47e9
@cmd60:
	ld a,$01		; $47eb
	ld hl,wc02d		; $47ed
	push af			; $47f0
	ld a,(wSoundChannel)		; $47f1
	ld e,a			; $47f4
	ld d,$00		; $47f5
	add hl,de		; $47f7
	pop af			; $47f8
	ld (hl),a		; $47f9
	call _func_39_489e		; $47fa
	ld hl,wc025		; $47fd
	push af			; $4800
	ld a,(wSoundChannel)		; $4801
	ld e,a			; $4804
	ld d,$00		; $4805
	add hl,de		; $4807
	pop af			; $4808
	ld (hl),a		; $4809
	call _func_39_434b		; $480a
	cp $00			; $480d
	jr nz,+			; $480f

	ld hl,wc025		; $4811
	ld a,(wSoundChannel)		; $4814
	ld e,a			; $4817
	ld d,$00		; $4818
	add hl,de		; $481a
	ld a,(hl)		; $481b
	ld ($ff00+R_NR32),a	; $481c
+
	jp _setChannelWaitCounter		; $481e
@freqCommand:
	ld a,$00		; $4821
	ld hl,wc02d		; $4823
	push af			; $4826
	ld a,(wSoundChannel)		; $4827
	ld e,a			; $482a
	ld d,$00		; $482b
	add hl,de		; $482d
	pop af			; $482e
	ld (hl),a		; $482f
	ld a,(wSoundCmd)		; $4830
	ld hl,_soundFrequencyTable		; $4833
	call _readWordFromTable		; $4836
@cmdUnknown:
	call _setSoundFrequency		; $4839
	ld a,$00		; $483c
	ld hl,wc045		; $483e
	push af			; $4841
	ld a,(wSoundChannel)		; $4842
	ld e,a			; $4845
	ld d,$00		; $4846
	add hl,de		; $4848
	pop af			; $4849
	ld (hl),a		; $484a
	ld a,$00		; $484b
	ld hl,wChannelVibratos		; $484d
	ld a,(wSoundChannel)		; $4850
	ld e,a			; $4853
	ld d,$00		; $4854
	add hl,de		; $4856
	ld a,(hl)		; $4857
	and $f0			; $4858
	srl a			; $485a
	srl a			; $485c
	srl a			; $485e
	ld hl,wc051		; $4860
	push af			; $4863
	ld a,(wSoundChannel)		; $4864
	ld e,a			; $4867
	ld d,$00		; $4868
	add hl,de		; $486a
	pop af			; $486b
	ld (hl),a		; $486c
	call _func_39_489e		; $486d
	ld hl,wc025		; $4870
	push af			; $4873
	ld a,(wSoundChannel)		; $4874
	ld e,a			; $4877
	ld d,$00		; $4878
	add hl,de		; $487a
	pop af			; $487b
	ld (hl),a		; $487c
	call _func_39_434b		; $487d
	cp $00			; $4880
	jr nz,+			; $4882

	ld hl,wc025		; $4884
	ld a,(wSoundChannel)		; $4887
	ld e,a			; $488a
	ld d,$00		; $488b
	add hl,de		; $488d
	ld a,(hl)		; $488e
	ld ($ff00+R_NR32),a	; $488f
	ld a,(wSoundFrequencyL)		; $4891
	ld ($ff00+R_NR33),a	; $4894
	ld a,(wSoundFrequencyH)		; $4896
	ld ($ff00+R_NR34),a	; $4899
+
	jp _setChannelWaitCounter		; $489b

;;
; @addr{489e}
_func_39_489e:
	ld hl,wc02d		; $489e
	ld a,(wSoundChannel)		; $48a1
	ld e,a			; $48a4
	ld d,$00		; $48a5
	add hl,de		; $48a7
	ld a,(hl)		; $48a8
	cp $00			; $48a9
	jr nz,_label_39_067	; $48ab
	ld a,(wSoundChannel)		; $48ad
	cp $05			; $48b0
	jr nc,_label_39_064	; $48b2
	ld a,(wMusicVolume)		; $48b4
	cp $00			; $48b7
	jr z,_label_39_067	; $48b9
	cp $01			; $48bb
	jr z,_label_39_066	; $48bd
	cp $02			; $48bf
	jr z,_label_39_065	; $48c1
_label_39_064:
	ld a,$20		; $48c3
	ret			; $48c5
_label_39_065:
	ld a,$40		; $48c6
	ret			; $48c8
_label_39_066:
	ld a,$60		; $48c9
	ret			; $48cb
_label_39_067:
	ld a,$00		; $48cc
	ret			; $48ce

;;
; @addr{48cf}
_standardCmdChannel6:
	ld a,(wSoundCmd)		; $48cf
	ld c,a			; $48d2
	ld de,_noiseFrequencyTable	; $48d3
-
	ld a,(de)		; $48d6
	inc de			; $48d7
	cp $ff			; $48d8
	jr z,@end		; $48da

	cp c			; $48dc
	jr z,+			; $48dd

	inc de			; $48df
	inc de			; $48e0
	jr -			; $48e1
+
	ld a,(de)		; $48e3
	ld l,a			; $48e4
	inc de			; $48e5
	ld a,(de)		; $48e6
	ld h,a			; $48e7
	ld a,($c074)		; $48e8
	cp $00			; $48eb
	jr nz,@end		; $48ed

	push hl			; $48ef
	call _func_39_478c		; $48f0
	pop hl			; $48f3
	sla a			; $48f4
	sla a			; $48f6
	sla a			; $48f8
	sla a			; $48fa
	or l			; $48fc
	ld ($ff00+R_NR42),a	; $48fd
	ld a,h			; $48ff
	ld ($ff00+R_NR43),a	; $4900
	ld a,$80		; $4902
	ld ($ff00+R_NR44),a	; $4904
@end:
	jp _setChannelWaitCounter		; $4906

;;
; @addr{4909}
_standardCmdChannel7:
	ld a,(wSoundCmd)		; $4909
	ld ($ff00+R_NR43),a	; $490c
	ld a,$00		; $490e
	ld ($ff00+R_NR41),a	; $4910
	ld a,($c01c)		; $4912
	cp $00			; $4915
	jr z,+			; $4917
	ld ($ff00+R_NR44),a	; $4919
+
	ld a,$00		; $491b
	ld ($c01c),a		; $491d
	jp _setChannelWaitCounter		; $4920

_channelCmdff:
	ld a,$00		; $4923
	ld hl,wChannelsEnabled		; $4925
	push af			; $4928
	ld a,(wSoundChannel)		; $4929
	ld e,a			; $492c
	ld d,$00		; $492d
	add hl,de		; $492f
	pop af			; $4930
	ld (hl),a		; $4931
;;
; Checks whether to call _updateChannelVolume on square channels, does some other things
; with the other types of channels...
;
; @addr{4932}
_updateChannelStuff:
	ld a,(wSoundChannel)		; $4932
	ld hl,@table		; $4935
	call _readWordFromTable		; $4938
	jp hl			; $493b

@table:
	.dw @musicSquareChannel
	.dw @musicSquareChannel
	.dw @sfxSquareChannel
	.dw @sfxSquareChannel
	.dw @musicWaveChannel
	.dw @sfxWaveChannel
	.dw @noiseChannel
	.dw @noiseChannel

@musicSquareChannel:
	; Only update if the corresponding sfx channel is not enabled
	ld a,(wSoundChannel)		; $494c
	inc a			; $494f
	inc a			; $4950
	ld e,a			; $4951
	ld hl,wChannelsEnabled		; $4952
	ld d,$00		; $4955
	add hl,de		; $4957
	ld a,(hl)		; $4958
	cp $00			; $4959
	jr z,+			; $495b
	ret			; $495d

@sfxSquareChannel:
	; Sfx always updates (but it still does this pointless check of the corresponding
	; music channel)
	ld a,(wSoundChannel)		; $495e
	dec a			; $4961
	dec a			; $4962
	ld e,a			; $4963
	ld hl,wChannelsEnabled		; $4964
	ld d,$00		; $4967
	add hl,de		; $4969
	ld a,(hl)		; $496a
	cp $00			; $496b
	jr z,+			; $496d
+
	ld hl,wc05d		; $496f
	ld a,(wSoundChannel)		; $4972
	ld e,a			; $4975
	ld d,$00		; $4976
	add hl,de		; $4978
	ld a,(hl)		; $4979
	cp $03			; $497a
	jr nz,+			; $497c
	ret			; $497e
+
	ld a,$08		; $497f
	ld (wSoundCmdEnvelope),a		; $4981
	call _updateChannelVolume		; $4984
	jp _func_42ea		; $4987

@musicWaveChannel:
	call _func_39_434b		; $498a
	cp $00			; $498d
	jr nz,+			; $498f

	ld a,$00		; $4991
	ld ($ff00+R_NR30),a	; $4993
+
	ret			; $4995

@sfxWaveChannel:
	ld a,(wChannelsEnabled+4)		; $4996
	cp $00			; $4999
	jr z,++			; $499b

	ld a,$04		; $499d
	ld e,a			; $499f
	ld hl,wChannelDutyCycles		; $49a0
	ld d,$00		; $49a3
	add hl,de		; $49a5
	ld a,(hl)		; $49a6
	ld (wWaveformIndex),a		; $49a7
	call _setWaveform		; $49aa
	ld a,(wc025+4)		; $49ad
	ld ($ff00+R_NR32),a	; $49b0
	ret			; $49b2
++
	ld a,$00		; $49b3
	ld ($ff00+R_NR30),a	; $49b5
	ret			; $49b7

@noiseChannel:
	ld a,$08		; $49b8
	ld ($ff00+R_NR42),a	; $49ba
	ld a,$80		; $49bc
	ld ($ff00+R_NR44),a	; $49be
	ret			; $49c0

;;
; @addr{49c1}
_setWaveform:
	call _func_39_434b		; $49c1
	cp $00			; $49c4
	jr z,@waitLoop			; $49c6
	ret			; $49c8

@waitLoop:
	; Wait for channel 3 to be on
	ld a,$00		; $49c9
	ld ($ff00+R_NR30),a	; $49cb
	ld a,($ff00+R_NR52)	; $49cd
	and $04			; $49cf
	jr nz,@waitLoop		; $49d1

	; Copy waveform to $ff30
	ld a,(wWaveformIndex)		; $49d3
	ld hl,_waveformTable		; $49d6
	call _readWordFromTable		; $49d9
	ld c,$10		; $49dc
	ld de,$ff30		; $49de
-
	ldi a,(hl)		; $49e1
	ld (de),a		; $49e2
	inc de			; $49e3
	dec c			; $49e4
	jr nz,-			; $49e5

-	; Enable channel 3
	ld a,$80		; $49e7
	ld ($ff00+R_NR30),a	; $49e9
	ld a,($ff00+R_NR30)	; $49eb
	and $80			; $49ed
	jr z,-			; $49ef

	; Restart channel 3 (but trashes lower frequency bits?)
	ld a,$80		; $49f1
	ld ($ff00+R_NR34),a	; $49f3
	ret			; $49f5

_channelCmdfe:
	call _getNextChannelByte		; $49f6
	ld l,a			; $49f9
	call _getNextChannelByte		; $49fa
	ld h,a			; $49fd
	ld a,(wSoundChannel)		; $49fe
	sla a			; $4a01
	ld b,a			; $4a03
	ld a,l			; $4a04
	ld c,<hSoundChannelAddresses		; $4a05
	call _writeIndexedHighRamAndIncrement		; $4a07
	ld a,h			; $4a0a
	ld ($ff00+c),a		; $4a0b
	inc c			; $4a0c
	jp _doNextChannelCommand		; $4a0d

;;
; @addr{4a10}
_func_39_4a10:
	cp $00			; $4a10
	jr nz,+			; $4a12
	ld hl,$0000		; $4a14
	ret			; $4a17
+
	ld e,l			; $4a18
	ld d,h			; $4a19
--
	dec a			; $4a1a
	jr z,+			; $4a1b

	add hl,de		; $4a1d
	jp --			; $4a1e
+
	ret			; $4a21

; @addr{4a22}
_soundFrequencyTable:
	.dw $002d
	.dw $009d
	.dw $0108
	.dw $016c
	.dw $01cb
	.dw $0224
	.dw $0279
	.dw $02c8
	.dw $0313
	.dw $0358
	.dw $039b
	.dw $03db
	.dw $0416
	.dw $044f
	.dw $0484
	.dw $04b6
	.dw $04e5
	.dw $0512
	.dw $053c
	.dw $0564
	.dw $058a
	.dw $05ac
	.dw $05ce
	.dw $05ed
	.dw $060b
	.dw $0627
	.dw $0642
	.dw $065b
	.dw $0673
	.dw $0689
	.dw $069e
	.dw $06b2
	.dw $06c5
	.dw $06d6
	.dw $06e7
	.dw $06f7
	.dw $0706
	.dw $0714
	.dw $0721
	.dw $072e
	.dw $0739
	.dw $0745
	.dw $074f
	.dw $0759
	.dw $0762
	.dw $076b
	.dw $0773
	.dw $077b
	.dw $0783
	.dw $078a
	.dw $0790
	.dw $0797
	.dw $079d
	.dw $07a2
	.dw $07a8
	.dw $07ad
	.dw $07b1
	.dw $07b6
	.dw $07ba
	.dw $07be
	.dw $07c1
	.dw $07c5
	.dw $07c8
	.dw $07cb
	.dw $07ce
	.dw $07d1
	.dw $07d4
	.dw $07d6
	.dw $07d9
	.dw $07db
	.dw $07dd
	.dw $07df
	.dw $07e1
	.dw $07e2
	.dw $07e4
	.dw $07e6
	.dw $07e7
	.dw $07e9
	.dw $07ea
	.dw $07eb
	.dw $07ec
	.dw $07ed
	.dw $07ee
	.dw $07ef
	.dw $07f0
	.dw $07f1
	.dw $07f2

; @addr{4ad0}
_data_4ad0:
	.db $00 $01 $02 $03 $04 $05 $06 $07
	.db $00 $02 $04 $06 $07 $09 $0b $0d
	.db $00 $03 $06 $08 $0b $0e $11 $14
	.db $00 $04 $07 $0b $0f $13 $16 $1a
	.db $00 $05 $09 $0e $13 $17 $1c $21
	.db $00 $06 $0b $11 $16 $1c $22 $27
	.db $00 $07 $0d $14 $1a $21 $27 $2e
	.db $00 $07 $0f $16 $1e $25 $2d $34
	.db $00 $08 $11 $19 $22 $2a $32 $3b
	.db $00 $09 $13 $1c $25 $2f $38 $41
	.db $00 $0a $15 $1f $29 $33 $3e $48
	.db $00 $0b $16 $22 $2d $38 $43 $4e
	.db $00 $0c $18 $24 $31 $3d $49 $55
	.db $00 $0d $1a $27 $34 $41 $4e $5b
; @addr{4b40}
_data_4b40:
	.db $00 $00 $01 $00 $02 $00 $01 $00
	.db $00 $00 $ff $ff $fe $ff $ff $ff

;;
; @param a The sound to play.
; @addr{4b50}
_playSound:
	push bc			; $4b50
	push de			; $4b51
	push hl			; $4b52
	ld (wSoundTmp),a		; $4b53
	cp $00			; $4b56
	jr nz,+			; $4b58
	jp @playSoundEnd		; $4b5a
+
	cp $f0			; $4b5d
	jr z,@sndf0		; $4b5f
	cp $f1			; $4b61
	jr z,@sndf1		; $4b63
	cp $f5			; $4b65
	jr z,@sndf5		; $4b67
	cp $f6			; $4b69
	jr z,@sndf6		; $4b6b
	cp $f7			; $4b6d
	jr z,@sndf7		; $4b6f
	cp $f8			; $4b71
	jr z,@sndf8		; $4b73
	cp $f9			; $4b75
	jr z,@sndf9		; $4b77
	cp $fa			; $4b79
	jr z,@sndfa		; $4b7b
	cp $fb			; $4b7d
	jr z,@sndfb		; $4b7f
	cp $fc			; $4b81
	jr z,@sndfc		; $4b83
	jr @normalSound		; $4b85

; Stop music
@sndf0:
	ld a,$de		; $4b87
	ld (wSoundTmp),a		; $4b89
	jr @normalSound		; $4b8c

; Stop sound effects
@sndf1:
	call _stopSfx		; $4b8e
	jp @playSoundEnd		; $4b91

; Disable sound
@sndf5:
	call _func_39_40b9		; $4b94
	ld a,$01		; $4b97
	ld (wSoundDisabled),a		; $4b99
	jp @setVolumeAndEnd		; $4b9c

; Enable sound
@sndf6:
	ld a,$00		; $4b9f
	ld (wSoundDisabled),a		; $4ba1
	jp @setVolumeAndEnd		; $4ba4

; Fast fadeout
@sndfa:
	ld a,$07		; $4ba7
	jr +			; $4ba9

; Medium fadeout
@sndfb:
	ld a,$0f		; $4bab
	jr +			; $4bad

; Slow fadeout
@sndfc:
	ld a,$1f		; $4baf
+
	ld (wSoundFadeSpeed),a		; $4bb1
	ld a,$00		; $4bb4
	ld (wSoundFadeCounter),a		; $4bb6
	ld a,$01		; $4bb9
	ld (wSoundFadeDirection),a		; $4bbb
	ld a,$77		; $4bbe
	ld (wSoundVolume),a		; $4bc0
	jp @playSoundEnd		; $4bc3

; Fast fadein
@sndf7:
	ld a,$03		; $4bc6
	jr +			; $4bc8

; Medium fadein
@sndf8:
	ld a,$07		; $4bca
	jr +			; $4bcc

; Slow fadein
@sndf9:
	ld a,$0f		; $4bce
+
	ld (wSoundFadeSpeed),a		; $4bd0
	ld a,$00		; $4bd3
	ld (wSoundFadeCounter),a		; $4bd5
	ld a,$0a		; $4bd8
	ld (wSoundFadeDirection),a		; $4bda
	ld a,$00		; $4bdd
	ld (wSoundVolume),a		; $4bdf
	jp @playSoundEnd		; $4be2

@normalSound:
	ld a,$00		; $4be5
	ld (wSoundFadeDirection),a		; $4be7
	ld a,(wSoundTmp)		; $4bea

	; Get a*3 in de
	ld d,$00		; $4bed
	ld e,a			; $4bef
	ld h,$00		; $4bf0
	ld l,a			; $4bf2
	sla l			; $4bf3
	rl h			; $4bf5
	add hl,de		; $4bf7
	ld d,h			; $4bf8
	ld e,l			; $4bf9

	ld hl,_soundPointers		; $4bfa
	add hl,de		; $4bfd
	ld a,(hl)		; $4bfe
	and $80			; $4bff
	jr z,+			; $4c01

	; What were the programmers on? Clearly this part of the code is unused
	call _noiseFrequencyTable	; $4c03

	jp @setVolumeAndEnd		; $4c06

+
	ldi a,(hl)		; $4c09
	ld c,a			; $4c0a
	ldh a,(<hSoundDataBaseBank)	; $4c0b
	add c			; $4c0d
	ld (wLoadingSoundBank),a		; $4c0e
	ldi a,(hl)		; $4c11
	ld c,a			; $4c12
	ld a,(hl)		; $4c13
	ld b,a			; $4c14
	ld l,c			; $4c15
	ld h,b			; $4c16

@nextSoundChannel:
	ldh a,(<hSoundDataBaseBank)	; $4c17
	call wMusicReadFunction		; $4c19
	cp $ff			; $4c1c
	jr nz,+			; $4c1e
	jp @setVolumeAndEnd		; $4c20
+
	ld (wSoundTmp),a		; $4c23
	and $f0			; $4c26
	swap a			; $4c28
	inc a			; $4c2a
	ld (wSoundChannelValue),a		; $4c2b
	ld a,(wSoundTmp)		; $4c2e
	and $0f			; $4c31
	ld (wSoundTmp),a		; $4c33
	ld e,a			; $4c36
	push hl			; $4c37
	ld hl,wChannelsEnabled		; $4c38
	ld d,$00		; $4c3b
	add hl,de		; $4c3d
	ld a,(hl)		; $4c3e
	pop hl			; $4c3f
	ld c,a			; $4c40
	ld a,(wSoundChannelValue)		; $4c41
	cp c			; $4c44
	jr nc,+			; $4c45

	inc hl			; $4c47
	inc hl			; $4c48
	jp @nextSoundChannel		; $4c49
+
	push hl			; $4c4c
	ld a,(wSoundTmp)		; $4c4d
	ld e,a			; $4c50
	ld a,(wSoundChannelValue)		; $4c51
	ld hl,wChannelsEnabled		; $4c54
	ld d,$00		; $4c57
	add hl,de		; $4c59
	ld (hl),a		; $4c5a
	ld a,$08		; $4c5b
	ld hl,wChannelVolumes		; $4c5d
	ld d,$00		; $4c60
	add hl,de		; $4c62
	ld (hl),a		; $4c63
	ld a,$00		; $4c64
	ld hl,wChannelWaitCounters		; $4c66
	ld d,$00		; $4c69
	add hl,de		; $4c6b
	ld (hl),a		; $4c6c
	ld a,(wSoundTmp)		; $4c6d
	cp $00			; $4c70
	jr z,@squareChannel	; $4c72
	cp $01			; $4c74
	jr z,@squareChannel	; $4c76
	cp $02			; $4c78
	jr z,@squareChannel	; $4c7a
	cp $03			; $4c7c
	jr z,@squareChannel	; $4c7e
	cp $04			; $4c80
	jr z,@waveChannel		; $4c82
	cp $05			; $4c84
	jr z,@waveChannel		; $4c86

	; Noise channels
	jr ++			; $4c88

@waveChannel:
	ld a,(wSoundTmp)		; $4c8a
	ld e,a			; $4c8d
	ld a,$00		; $4c8e
	ld hl,wChannelVibratos		; $4c90
	ld d,$00		; $4c93
	add hl,de		; $4c95
	ld (hl),a		; $4c96
	ld hl,wc03f		; $4c97
	ld d,$00		; $4c9a
	add hl,de		; $4c9c
	ld (hl),a		; $4c9d
	ld hl,wChannelPitchShift		; $4c9e
	ld d,$00		; $4ca1
	add hl,de		; $4ca3
	ld (hl),a		; $4ca4
	ld hl,wc039		; $4ca5
	ld d,$00		; $4ca8
	add hl,de		; $4caa
	ld (hl),a		; $4cab
	jr ++			; $4cac

@squareChannel:
	ld a,(wSoundTmp)		; $4cae
	ld e,a			; $4cb1

	; Clear a bunch of variables
	ld a,$00		; $4cb2
	ld hl,wChannelEnvelopes		; $4cb4
	ld d,$00		; $4cb7
	add hl,de		; $4cb9
	ld (hl),a		; $4cba
	ld hl,wChannelEnvelopes2		; $4cbb
	ld d,$00		; $4cbe
	add hl,de		; $4cc0
	ld (hl),a		; $4cc1
	ld hl,wChannelDutyCycles		; $4cc2
	ld d,$00		; $4cc5
	add hl,de		; $4cc7
	ld (hl),a		; $4cc8
	ld hl,wChannelVibratos		; $4cc9
	ld d,$00		; $4ccc
	add hl,de		; $4cce
	ld (hl),a		; $4ccf
	ld hl,wc03f		; $4cd0
	ld d,$00		; $4cd3
	add hl,de		; $4cd5
	ld (hl),a		; $4cd6
	ld hl,wChannelPitchShift		; $4cd7
	ld d,$00		; $4cda
	add hl,de		; $4cdc
	ld (hl),a		; $4cdd
	ld hl,wc039		; $4cde
	ld d,$00		; $4ce1
	add hl,de		; $4ce3
	ld (hl),a		; $4ce4
++
	; Write the bank for this sound channel into hSoundChannelBanks
	pop hl			; $4ce5
	ld a,(wSoundTmp)		; $4ce6
	ld b,a			; $4ce9
	ld a,(wLoadingSoundBank)		; $4cea
	ld c,<hSoundChannelBanks		; $4ced
	call _writeIndexedHighRamAndIncrement		; $4cef

	; Write the address for this sound channel into hSoundChannelAddresses
	ld a,(wSoundTmp)		; $4cf2
	sla a			; $4cf5
	ld b,a			; $4cf7
	push bc			; $4cf8
	ldh a,(<hSoundDataBaseBank)	; $4cf9
	call wMusicReadFunction		; $4cfb
	pop bc			; $4cfe
	ld c,<hSoundChannelAddresses		; $4cff
	call _writeIndexedHighRamAndIncrement		; $4d01
	push bc			; $4d04
	ldh a,(<hSoundDataBaseBank)	; $4d05
	call wMusicReadFunction		; $4d07
	pop bc			; $4d0a
	ld ($ff00+c),a		; $4d0b
	inc c			; $4d0c
	jp @nextSoundChannel		; $4d0d

@setVolumeAndEnd:
	ld a,$77		; $4d10
	ld (wSoundVolume),a		; $4d12
@playSoundEnd:
	pop hl			; $4d15
	pop de			; $4d16
	pop bc			; $4d17
	ret			; $4d18

;;
; Reads a word at hl+a*2 into de and hl. Index can't be higher than $7f.
; @addr{4d19}
_readWordFromTable:
	sla a			; $4d19
	ld d,$00		; $4d1b
	ld e,a			; $4d1d
	add hl,de		; $4d1e
	ld e,(hl)		; $4d1f
	inc hl			; $4d20
	ld d,(hl)		; $4d21
	ld h,d			; $4d22
	ld l,e			; $4d23
	ret			; $4d24

;;
; Adds b to c, writes a to ($ff00+c), increments c.
; @addr{4d25}
_writeIndexedHighRamAndIncrement:
	push af			; $4d25
	ld a,b			; $4d26
	add c			; $4d27
	ld c,a			; $4d28
	pop af			; $4d29
	ld ($ff00+c),a		; $4d2a
	inc c			; $4d2b
	ret			; $4d2c

	push af			; $4d2d
	ld a,(wSoundChannel)		; $4d2e
	ld b,a			; $4d31
	ld a,b			; $4d32
	add c			; $4d33
	ld c,a			; $4d34
	pop af			; $4d35
	ld ($ff00+c),a		; $4d36
	ret			; $4d37

; @addr{4d38}
_noiseFrequencyTable:
	.db $24 $01 $47
	.db $22 $00 $47
	.db $23 $02 $46
	.db $26 $02 $26
	.db $28 $00 $35
	.db $27 $02 $14
	.db $2a $01 $14
	.db $2e $06 $07
	.db $52 $03 $17
	.db $32 $02 $37
	.db $2f $02 $45
	.db $29 $02 $47
	.db $30 $00 $07
	.db $ff

; @addr{4d60}
_waveformTable:
	.dw @waveform00
	.dw @waveform01
	.dw @waveform02
	.dw @waveform03
	.dw @waveform04
	.dw @waveform05
	.dw @waveform06
	.dw @waveform07
	.dw @waveform08
	.dw @waveform09
	.dw @waveform0a
	.dw @waveform0b
	.dw @waveform0c
	.dw @waveform0d
	.dw @waveform0e
	.dw @waveform0f
	.dw @waveform10
	.dw @waveform11
	.dw @waveform12
	.dw @waveform13
	.dw @waveform14
	.dw @waveform15
	.dw @waveform16
	.dw @waveform17
	.dw @waveform18
	.dw @waveform19
	.dw @waveform1a
	.dw @waveform1b
	.dw @waveform1c
	.dw @waveform1d
	.dw @waveform1e
	.dw @waveform1f
	.dw @waveform20
	.dw @waveform21
	.dw @waveform22
	.dw @waveform23
	.dw @waveform24
	.dw @waveform25
	.dw @waveform26
	.dw @waveform27
	.dw @waveform28
	.dw @waveform29
	.dw @waveform2a
	.dw @waveform2b
	.dw @waveform2c
	.dw @waveform2d

@waveformUnused0:
	.db $00 $00 $00 $00 $66 $77 $88 $88 $88 $88 $88 $88 $88 $77 $66 $55

@waveform04:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $88 $99 $aa $aa $aa $aa $99 $88

@waveform0e:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88

@waveform28:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $44 $55 $66 $66 $66 $66 $55 $44

@waveform06:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $44 $55 $55 $55 $55 $44 $33

@waveform07:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $44 $55 $66 $66 $66 $66 $55 $44

@waveform26:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $11 $22 $33 $33 $22 $11 $00

@waveform09:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $33 $33 $55 $55 $33 $33 $00

@waveform16:
	.db $01 $23 $45 $67 $89 $ab $cd $ef $ed $cb $a9 $87 $65 $43 $21 $00

@waveform20:
	.db $00 $01 $23 $45 $67 $89 $ab $cd $cb $a9 $87 $65 $43 $21 $00 $00

@waveformUnused1:
	.db $00 $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88

@waveform0a:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $cc $cc $cc $cc $cc $cc $cc $cc

@waveform1e:
	.db $ff $ee $dd $cc $bb $aa $99 $88 $77 $66 $55 $44 $33 $22 $11 $00

@waveform21:
	.db $00 $00 $00 $00 $77 $77 $77 $77 $77 $77 $77 $77 $ff $ff $ff $ff

@waveformUnused2:
	.db $ff $ee $cc $bb $99 $88 $66 $55 $cc $aa $99 $77 $66 $44 $22 $00

@waveform23:
	.db $77 $77 $66 $66 $55 $55 $44 $44 $cc $bb $ba $aa $a9 $99 $88 $88

@waveformUnused3:
	.db $88 $aa $cc $ee $ff $ee $dd $cc $bb $aa $99 $88 $66 $44 $22 $00

@waveform22:
	.db $6c $6c $6c $6c $6b $6a $69 $68 $77 $66 $55 $44 $33 $22 $11 $00

@waveform1f:
	.db $11 $ff $33 $dd $55 $bb $77 $99 $88 $88 $77 $99 $55 $bb $33 $dd

@waveform24:
	.db $80 $ae $db $f6 $ff $f6 $db $ae $80 $4f $25 $0a $00 $0a $25 $4f

@waveformUnused4:
	.db $ff $f6 $db $ae $80 $4f $25 $0a $00 $0a $25 $4f $80 $ae $db $f6

@waveform25:
	.db $c0 $d2 $db $d2 $c0 $a3 $80 $5c $40 $2d $25 $2d $40 $5c $80 $a3

@waveformUnused5:
	.db $c0 $db $c0 $80 $40 $25 $40 $80 $c0 $db $c0 $80 $40 $25 $40 $80

@waveform1a:
	.db $80 $db $ff $db $80 $25 $00 $25 $80 $db $ff $db $80 $25 $00 $25

@waveform1b:
	.db $40 $6e $80 $6e $40 $13 $00 $13 $40 $6e $80 $6e $40 $13 $00 $13

@waveformUnused6:
	.db $20 $37 $40 $37 $20 $0a $00 $0a $20 $37 $40 $37 $20 $0a $00 $0a

@waveform27:
	.db $00 $00 $00 $00 $99 $bb $dd $ee $ff $ff $ee $dd $bb $99 $00 $00

@waveform01:
	.db $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88

@waveform02:
	.db $00 $00 $00 $00 $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff

@waveform1c:
	.db $ff $bb $00 $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb

@waveform1d:
	.db $77 $66 $55 $44 $33 $22 $11 $00 $77 $66 $55 $44 $33 $22 $11 $00

@waveform14:
	.db $30 $00 $00 $00 $00 $00 $00 $00 $03 $34 $45 $55 $55 $55 $54 $43

@waveform13:
	.db $00 $00 $00 $07 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77

@waveform15:
	.db $50 $00 $00 $00 $00 $00 $00 $00 $05 $46 $67 $77 $77 $77 $76 $65

@waveform12:
	.db $00 $00 $00 $09 $99 $99 $99 $99 $99 $99 $99 $99 $99 $99 $99 $99

@waveformUnused7:
	.db $01 $23 $45 $67 $89 $ab $cd $ef $fe $dc $ba $98 $76 $54 $32 $10

@waveform0c:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $11 $11 $11 $11 $11 $11 $11 $11

@waveform0d:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $33 $33 $33 $33 $33 $33 $33

@waveform0f:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $33 $33 $33 $33 $33 $33 $33

@waveform10:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $77 $77 $77 $77 $77 $77 $77 $77

@waveform11:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88

@waveform17:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $55 $55 $55 $55 $55 $55 $55 $55

@waveform18:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $99 $99 $99 $99 $99 $99 $99 $99

@waveform19:
	.db $00 $00 $00 $00 $00 $00 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77

@waveform08:
	.db $00 $00 $11 $12 $22 $33 $34 $44 $44 $43 $33 $22 $21 $11 $00 $00

@waveform00:
	.db $11 $22 $33 $44 $55 $66 $78 $9a $a9 $88 $77 $66 $55 $44 $33 $22

@waveform05:
	.db $11 $22 $33 $44 $55 $66 $78 $9a $a9 $88 $77 $66 $55 $44 $33 $22

@waveform03:
	.db $11 $33 $55 $77 $99 $bb $dd $ff $ff $dd $bb $99 $77 $55 $33 $11

@waveform0b:
	.db $00 $0d $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd

@waveform2b:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $44 $44 $44 $44 $44 $44 $44 $44

@waveform2c:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $22 $22 $22 $22 $22 $22 $22 $22

@waveform29:
	.db $00 $00 $00 $00 $22 $22 $22 $22 $22 $22 $22 $22 $22 $22 $22 $22

@waveform2a:
	.db $00 $00 $00 $00 $33 $33 $33 $33 $33 $33 $33 $33 $33 $33 $33 $33

@waveform2d:
	.db $9b $df $ff $fe $dc $ba $98 $76 $21 $00 $01 $23 $22 $22 $23 $23




.ifdef ROM_AGES
	.include "audio/ages/soundChannelPointers.s"
	.include "audio/ages/soundPointers.s"

	.ifdef BUILD_VANILLA
	.ORGA $59ff
	.endif

	.include "audio/ages/soundChannelData.s"

	.ifdef BUILD_VANILLA
		.db $ff $ff $ff
	.endif

.else; ROM_SEASONS
	.include "audio/seasons/soundChannelPointers.s"
	.include "audio/seasons/soundPointers.s"

	.ifdef BUILD_VANILLA
	.ORGA $5a86
	.endif

	.include "audio/seasons/soundChannelData.s"

	.ifdef BUILD_VANILLA
		.dsb 10 $ff
	.endif
.endif
