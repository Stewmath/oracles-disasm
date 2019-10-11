.define SCRIPT_BANK $0c

;;
; @param a Command to execute
; @param hl Current address of script
; @addr{4000}
runScriptCommand:
	bit 7,a			; $4000
	jp z,_scriptCmd_jump2byte		; $4002
	push hl			; $4005
	and $7f			; $4006
	rst_jumpTable			; $4008
	.dw _scriptCmd_setState ; 0x80
	.dw _scriptCmd_setState2 ; 0x81
	.dw _scriptCmd_jump2byte ; 0x82
	.dw scriptCmd_loadScript ; 0x83
	.dw _scriptCmd_spawnInteraction ; 0x84
	.dw _scriptCmd_spawnEnemy ; 0x85
	.dw _scriptCmd_showPasswordScreen ; 0x86
	.dw _scriptCmd_jumpTable_memoryAddress ; 0x87
	.dw _scriptCmd_setCoords ; 0x88
	.dw _scriptCmd_setAngle ; 0x89
	.dw _scriptCmd_8a ; 0x8a
	.dw _scriptCmd_setSpeed ; 0x8b
	.dw _scriptCmd_checkCounter2ZeroAndReset ; 0x8c
	.dw _scriptCmd_setCollideRadii ; 0x8d
	.dw _scriptCmd_writeInteractionByte ; 0x8e
	.dw _scriptCmd_loadSprite ; 0x8f
	.dw _scriptCmd_cpLinkX ; 0x90
	.dw _scriptCmd_writeMemory ; 0x91
	.dw _scriptCmd_orMemory ; 0x92
	.dw _scriptCmd_getRandomBits ; 0x93
	.dw _scriptCmd_addinteractionByte ; 0x94
	.dw _scriptCmd_setZSpeed ; 0x95
	.dw _scriptCmd_setAngleAndExtra ; 0x96
	.dw _scriptCmd_runGenericNpc ; 0x97
	.dw _scriptCmd_showText ; 0x98
	.dw _scriptCmd_waitForText ; 0x99
	.dw _scriptCmd_showTextNonExitable ; 0x9a
	.dw _scriptCmd_checkSomething ; 0x9b
	.dw _scriptCmd_setTextID ; 0x9c
	.dw _scriptCmd_showLoadedText ; 0x9d
	.dw _scriptCmd_checkAButton ; 0x9e
	.dw _scriptCmd_showTextDifferentForLinked ; 0x9f
	.dw _scriptCmd_checkCFC0Bit ; 0xa0
	.dw _scriptCmd_checkCFC0Bit ; 0xa1
	.dw _scriptCmd_checkCFC0Bit ; 0xa2
	.dw _scriptCmd_checkCFC0Bit ; 0xa3
	.dw _scriptCmd_checkCFC0Bit ; 0xa4
	.dw _scriptCmd_checkCFC0Bit ; 0xa5
	.dw _scriptCmd_checkCFC0Bit ; 0xa6
	.dw _scriptCmd_checkCFC0Bit ; 0xa7
	.dw _scriptCmd_xorCFC0Bit ; 0xa8
	.dw _scriptCmd_xorCFC0Bit ; 0xa9
	.dw _scriptCmd_xorCFC0Bit ; 0xaa
	.dw _scriptCmd_xorCFC0Bit ; 0xab
	.dw _scriptCmd_xorCFC0Bit ; 0xac
	.dw _scriptCmd_xorCFC0Bit ; 0xad
	.dw _scriptCmd_xorCFC0Bit ; 0xae
	.dw _scriptCmd_xorCFC0Bit ; 0xaf
	.dw _scriptCmd_jumpIfRoomFlagSet ; 0xb0
	.dw _scriptCmd_orRoomFlags ; 0xb1
	.dw _scriptCmd_none ; 0xb2
	.dw _scriptCmd_jumpIfC6xxSet ; 0xb3
	.dw _scriptCmd_writeC6xx ; 0xb4
	.dw _scriptCmd_jumpIfGlobalFlagSet ; 0xb5
	.dw _scriptCmd_setOrUnsetGlobalFlag ; 0xb6
	.dw _scriptCmd_none ; 0xb7
	.dw _scriptCmd_setLinkCantMoveTo91 ; 0xb8
	.dw _scriptCmd_setLinkCantMoveTo00 ; 0xb9
	.dw _scriptCmd_setLinkCantMoveTo11 ; 0xba
	.dw _scriptCmd_disableMenu ; 0xbb
	.dw _scriptCmd_enableMenu ; 0xbc
	.dw _scriptCmd_disableInput ; 0xbd
	.dw _scriptCmd_enableInput ; 0xbe
	.dw _scriptCmd_none ; 0xbf
	.dw _scriptCmd_callScript ; 0xc0
	.dw _scriptCmd_ret ; 0xc1
	.dw _scriptCmd_none ; 0xc2
	.dw _scriptCmd_jumpIfCBA5Eq ; 0xc3
	.dw _scriptCmd_jumpRandom ; 0xc4
	.dw _scriptCmd_none ; 0xc5
	.dw _scriptCmd_jumpTable ; 0xc6
	.dw _scriptCmd_jumpIfMemorySet ; 0xc7
	.dw _scriptCmd_jumpIfSomething ; 0xc8
	.dw _scriptCmd_jumpIfNoEnemies ; 0xc9
	.dw _scriptCmd_jumpIfLinkVariableNe ; 0xca
	.dw _scriptCmd_jumpIfMemoryEq ; 0xcb
	.dw _scriptCmd_jumpIfInteractionByteEq ; 0xcc
	.dw _scriptCmd_stopIfItemFlagSet ; 0xcd
	.dw _scriptCmd_stopIfRoomFlag40Set ; 0xce
	.dw _scriptCmd_stopIfRoomFlag80Set ; 0xcf
	.dw _scriptCmd_checkCollidedWithLink_onGround ; 0xd0
	.dw _scriptCmd_checkPaletteFadeDone ; 0xd1
	.dw _scriptCmd_checkNoEnemies ; 0xd2
	.dw _scriptCmd_checkFlagSet ; 0xd3
	.dw _scriptCmd_checkInteractionByteEq ; 0xd4
	.dw _scriptCmd_checkMemoryEq ; 0xd5
	.dw _scriptCmd_checkNotCollidedWithLink_ignoreZ ; 0xd6
	.dw _scriptCmd_setCounter1 ; 0xd7
	.dw _scriptCmd_checkCounter2Zero ; 0xd8
	.dw _scriptCmd_checkHeartDisplayUpdated ; 0xd9
	.dw _scriptCmd_checkRupeeDisplayUpdated ; 0xda
	.dw _scriptCmd_checkCollidedWithLink_ignoreZ ; 0xdb
	.dw _scriptCmd_none ; 0xdc
	.dw _scriptCmd_spawnItem ; 0xdd
	.dw _scriptCmd_spawnItem ; 0xde
	.dw _scriptCmd_df ; 0xdf
	.dw scriptCmd_asmCall ; 0xe0
	.dw scriptCmd_asmCallWithParam ; 0xe1
	.dw _scriptCmd_createPuff ; 0xe2
	.dw _scriptCmd_playSound ; 0xe3
	.dw _scriptCmd_setMusic ; 0xe4
	.dw _scriptCmd_setLinkCantMove ; 0xe5
	.dw _scriptCmd_spawnEnemyHere ; 0xe6
	.dw _scriptCmd_setTile ; 0xe7
	.dw _scriptCmd_setTileHere ; 0xe8
	.dw _scriptCmd_updateLinkLocalRespawnPosition ; 0xe9
	.dw _scriptCmd_shakeScreen ; 0xea
	.dw _scriptCmd_initNpcHitbox ; 0xeb
	.dw _scriptCmd_moveNpcUp ; 0xec
	.dw _scriptCmd_moveNpcRight ; 0xed
	.dw _scriptCmd_moveNpcDown ; 0xee
	.dw _scriptCmd_moveNpcLeft ; 0xef
	.dw _scriptCmd_delay ; 0xf0
	.dw _scriptCmd_delay ; 0xf1
	.dw _scriptCmd_delay ; 0xf2
	.dw _scriptCmd_delay ; 0xf3
	.dw _scriptCmd_delay ; 0xf4
	.dw _scriptCmd_delay ; 0xf5
	.dw _scriptCmd_delay ; 0xf6
	.dw _scriptCmd_delay ; 0xf7
	.dw _scriptCmd_delay ; 0xf8
	.dw _scriptCmd_delay ; 0xf9
	.dw _scriptCmd_delay ; 0xfa
	.dw _scriptCmd_delay ; 0xfb
	.dw _scriptCmd_delay ; 0xfc

;;
; @addr{4103}
_scriptCmd_none:
	pop hl			; $4103
	ret			; $4104

;;
; @addr{4105}
_scriptCmd_stopIfItemFlagSet:
	ld b,ROOMFLAG_ITEM	; $4105
	jr _scriptFunc_checkRoomFlag		; $4107
;;
; @addr{4109}
_scriptCmd_stopIfRoomFlag40Set:
	ld b,ROOMFLAG_40	; $4109
	jr _scriptFunc_checkRoomFlag		; $410b
;;
; @addr{410d}
_scriptCmd_stopIfRoomFlag80Set:
	ld b,ROOMFLAG_80	; $410d
_scriptFunc_checkRoomFlag:
	call getThisRoomFlags		; $410f
	and b			; $4112
	jp z,_scriptFunc_popHlAndInc		; $4113
	pop hl			; $4116
	ld hl,stubScript		; $4117
	scf			; $411a
	ret			; $411b

;;
; @addr{411c}
_scriptCmd_showPasswordScreen:
	pop hl			; $411c
	inc hl			; $411d
	ldi a,(hl)		; $411e
	push hl			; $411f
	cp $ff			; $4120
	jr z,@openSecretMenu	; $4122

	ld b,a			; $4124
	swap a			; $4125
	and $03			; $4127
	rst_jumpTable			; $4129

.ifdef ROM_AGES
	.dw @askForSecret
	.dw @generateSecret
	.dw @generateSecret
	.dw @askForSecret
.else; ROM_SEASONS
	.dw @generateSecret
	.dw @askForSecret
	.dw @askForSecret
	.dw @generateSecret
.endif

;;
; @addr{4132}
@askForSecret:
	ld a,b			; $4132
	or $80			; $4133
;;
; @addr{4135}
@openSecretMenu:
	call openSecretInputMenu		; $4135
	jr ++			; $4138

;;
; @addr{413a}
@generateSecret:
	ld a,b			; $413a
	ld (wShortSecretIndex),a		; $413b
	ld bc,$0003		; $413e
	call secretFunctionCaller		; $4141
++
	pop hl			; $4144
	xor a			; $4145
	ret			; $4146

;;
; @addr{4147}
_scriptCmd_disableInput:
	ld a,$81		; $4147
	ld (wDisabledObjects),a		; $4149
_scriptCmd_disableMenu:
	ld a,$80		; $414c
	ld (wMenuDisabled),a		; $414e
	call clearAllParentItems		; $4151
	call dropLinkHeldItem		; $4154
	call _func_0c_4177		; $4157
_scriptFunc_popHlAndInc:
	pop hl			; $415a
	inc hl			; $415b
	scf			; $415c
	ret			; $415d

;;
; @addr{415e}
_scriptCmd_enableInput:
	xor a			; $415e
	ld (wDisabledObjects),a		; $415f
_scriptCmd_enableMenu:
	xor a			; $4162
	ld (wMenuDisabled),a		; $4163
	jr _scriptFunc_popHlAndInc	; $4166

_scriptCmd_setLinkCantMoveTo91:
	ld a,$91		; $4168
_scriptFunc_setLinkCantMove:
	ld (wDisabledObjects),a		; $416a
	pop hl			; $416d
	inc hl			; $416e
	ret			; $416f

;;
; @addr{4170}
_scriptCmd_setLinkCantMoveTo00:
	xor a			; $4170
	jr _scriptFunc_setLinkCantMove		; $4171
;;
; @addr{4173}
_scriptCmd_setLinkCantMoveTo11:
	ld a,$11		; $4173
	jr _scriptFunc_setLinkCantMove		; $4175

;;
; @addr{4177}
_func_0c_4177:
	push hl			; $4177
	ld a,(wLinkObjectIndex)		; $4178
	ld h,a			; $417b
	ld l,<w1Link.invincibilityCounter		; $417c
	ld (hl),$80		; $417e
	ld l,<w1Link.knockbackCounter		; $4180
	ld (hl),$00		; $4182
	pop hl			; $4184
	ret			; $4185

;;
; @addr{4186}
_scriptCmd_setState:
	pop hl			; $4186
	inc hl			; $4187
	ld e,Interaction.state	; $4188
;;
; @addr{418a}
_scriptFunc_setState:
	ldi a,(hl)		; $418a
	cp $ff			; $418b
	jr z,++			; $418d

	ld (de),a		; $418f
	xor a			; $4190
	ret			; $4191
++
	ld a,(de)		; $4192
	inc a			; $4193
	ld (de),a		; $4194
	xor a			; $4195
	ret			; $4196

;;
; @addr{4197}
_scriptCmd_setState2:
	pop hl			; $4197
	inc hl			; $4198
	ld e,Interaction.state2	; $4199
	jr _scriptFunc_setState	; $419b

;;
; This is for all commands under $80.
; @addr{419d}
_scriptCmd_jump2byte:

.ifdef ROM_AGES
	ld a,h			; $419d
	cp $80			; $419e
	jr c,++			; $41a0

	ldh a,(<hScriptAddressL)	; $41a2
	ld c,a			; $41a4
	ldh a,(<hScriptAddressH)	; $41a5
	ld b,a			; $41a7
	inc hl			; $41a8
	ldd a,(hl)		; $41a9
	sub c			; $41aa
	ld e,a			; $41ab
	ld a,(hl)		; $41ac
	sbc b			; $41ad
	or a			; $41ae
	jr nz,++		; $41af

	ld l,e			; $41b1
	ld h,>wBigBuffer	; $41b2
	ret			; $41b4
++
.endif
	ldi a,(hl)		; $41b5
	ld l,(hl)		; $41b6
	ld h,a			; $41b7
	scf			; $41b8
	ret			; $41b9

;;
; @addr{41ba}
_scriptCmd_spawnInteraction:
	pop hl			; $41ba
	inc hl			; $41bb
	call _scriptFunc_loadBcAndDe		; $41bc
	push hl			; $41bf
	call getFreeInteractionSlot		; $41c0
	jr nz,_scriptFunc_restoreActiveObject			; $41c3

	ld a,Interaction.yh		; $41c5
	call _scriptFunc_initializeObject		; $41c7
_scriptFunc_restoreActiveObject:
	ldh a,(<hActiveObject)	; $41ca
	ld d,a			; $41cc
	pop hl			; $41cd
	ret			; $41ce

;;
; Loads bc and de from hl (bc first, de second, big-endian).
; @addr{41cf}
_scriptFunc_loadBcAndDe:
	ldi a,(hl)		; $41cf
	ld b,a			; $41d0
	ldi a,(hl)		; $41d1
	ld c,a			; $41d2
	ldi a,(hl)		; $41d3
	ld d,a			; $41d4
	ldi a,(hl)		; $41d5
	ld e,a			; $41d6
	ret			; $41d7

;;
; @param[in] a Address of object's YH variable
; @param[in] bc ID of the object
; @param[in] de YX coordinates
; @param[in] hl Address of object
; @addr{41d8}
_scriptFunc_initializeObject:
	ld (hl),b		; $41d8
	inc l			; $41d9
	ld (hl),c		; $41da
	inc l			; $41db
	ld l,a			; $41dc
	ld (hl),d		; $41dd
	inc l			; $41de
	inc l			; $41df
	ld (hl),e		; $41e0
	ret			; $41e1

;;
; @addr{41e2}
_scriptCmd_spawnEnemy:
	pop hl			; $41e2
	inc hl			; $41e3
	call _scriptFunc_loadBcAndDe		; $41e4
	push hl			; $41e7
	call getFreeEnemySlot		; $41e8
	jr nz,_scriptFunc_restoreActiveObject	; $41eb

	ld a,Enemy.yh		; $41ed
	call _scriptFunc_initializeObject		; $41ef
	jr _scriptFunc_restoreActiveObject		; $41f2

_scriptCmd_spawnEnemyHere:
	pop hl			; $41f4
	inc hl			; $41f5
	ldi a,(hl)		; $41f6
	ld b,a			; $41f7
	ldi a,(hl)		; $41f8
	ld c,a			; $41f9
	push hl			; $41fa
	ld e,Interaction.yh		; $41fb
	ld a,(de)		; $41fd
	ld l,a			; $41fe
	ld e,Interaction.xh		; $41ff
	ld a,(de)		; $4201
	ld e,a			; $4202
	ld d,l			; $4203
	call getFreeEnemySlot		; $4204
	jr nz,_scriptFunc_restoreActiveObject	; $4207
	ld a,Enemy.yh		; $4209
	call _scriptFunc_initializeObject		; $420b
	jr _scriptFunc_restoreActiveObject		; $420e

_scriptCmd_jumpTable_memoryAddress:
	pop hl			; $4210
	inc hl			; $4211
	ldi a,(hl)		; $4212
	ld c,a			; $4213
	ldi a,(hl)		; $4214
	ld b,a			; $4215
	ld a,(bc)		; $4216
	rst_addDoubleIndex			; $4217
	jp scriptFunc_jump		; $4218

_scriptCmd_setCoords:
	pop hl			; $421b
	inc hl			; $421c
	ldi a,(hl)		; $421d
	ld b,a			; $421e
	ldi a,(hl)		; $421f
	ld c,a			; $4220
	push hl			; $4221
	ld h,d			; $4222
	ld l,Interaction.yh		; $4223
	ld (hl),b		; $4225
	ld l,Interaction.xh		; $4226
	ld (hl),c		; $4228
	pop hl			; $4229
	ret			; $422a

_scriptCmd_setAngle:
	pop hl			; $422b
	inc hl			; $422c
	ldi a,(hl)		; $422d
	ld e,Interaction.angle	; $422e
	ld (de),a		; $4230
	ret			; $4231

_scriptCmd_setSpeed:
	pop hl			; $4232
	inc hl			; $4233
	ldi a,(hl)		; $4234
	ld e,Interaction.speed	; $4235
	ld (de),a		; $4237
	ret			; $4238

_scriptCmd_setZSpeed:
	pop hl			; $4239
	inc hl			; $423a
	ld e,Interaction.speedZ	; $423b
	ldi a,(hl)		; $423d
	ld (de),a		; $423e
	inc e			; $423f
	ldi a,(hl)		; $4240
	ld (de),a		; $4241
	scf			; $4242
	ret			; $4243

_scriptCmd_checkCounter2ZeroAndReset:
	pop hl			; $4244
	ld e,Interaction.counter2	; $4245
	ld a,(de)		; $4247
	or a			; $4248
	ret nz			; $4249

	inc hl			; $424a
	ldi a,(hl)		; $424b
	ld (de),a		; $424c
	ret			; $424d

_scriptCmd_setCollideRadii:
	pop hl			; $424e
	inc hl			; $424f
	ldi a,(hl)		; $4250
	ld e,Interaction.collisionRadiusY	; $4251
	ld (de),a		; $4253
	inc e			; $4254
	ldi a,(hl)		; $4255
	ld (de),a		; $4256
	ret			; $4257

_scriptCmd_writeInteractionByte:
	pop hl			; $4258
	inc hl			; $4259
	ldi a,(hl)		; $425a
	ld e,a			; $425b
	ldi a,(hl)		; $425c
	ld (de),a		; $425d
	ret			; $425e

_scriptCmd_addinteractionByte:
	pop hl			; $425f
	inc hl			; $4260
	ldi a,(hl)		; $4261
	ld e,a			; $4262
	ldi a,(hl)		; $4263
	ld b,a			; $4264
	ld a,(de)		; $4265
	add b			; $4266
	ld (de),a		; $4267
	scf			; $4268
	ret			; $4269

_scriptCmd_getRandomBits:
	pop hl			; $426a
	inc hl			; $426b
	call getRandomNumber		; $426c
	ld b,a			; $426f
	ldi a,(hl)		; $4270
	ld e,a			; $4271
	ldi a,(hl)		; $4272
	and b			; $4273
	ld (de),a		; $4274
	ret			; $4275

_scriptCmd_loadSprite:
	pop hl			; $4276
	inc hl			; $4277
	ldi a,(hl)		; $4278
	cp $ff			; $4279
	jr nz,+			; $427b

	ld e,Interaction.angle	; $427d
	call convertAngleDeToDirection		; $427f
	jr ++			; $4282
+
	cp $fe			; $4284
	jr nz,++		; $4286

	ldi a,(hl)		; $4288
	ld e,a			; $4289
	ld a,(de)		; $428a
++
	push hl			; $428b
	call interactionSetAnimation		; $428c
	pop hl			; $428f
	ld a,:_scriptCmd_loadSprite	; $4290
	setrombank		; $4292
	ret			; $4297

_scriptCmd_8a:
	call objectGetAngleTowardEnemyTarget		; $4298
	add $04			; $429b
	and $18			; $429d
	swap a			; $429f
	rlca			; $42a1
	call interactionSetAnimation		; $42a2
	jp _scriptFunc_popHlAndInc		; $42a5

_scriptCmd_setAngleAndExtra:
	pop hl			; $42a8
	inc hl			; $42a9
	ldi a,(hl)		; $42aa
	ld e,Interaction.angle	; $42ab
	ld (de),a		; $42ad
	call convertAngleDeToDirection		; $42ae
	push hl			; $42b1
	call interactionSetAnimation		; $42b2
	pop hl			; $42b5
	scf			; $42b6
	ret			; $42b7

_scriptCmd_runGenericNpc:
	pop hl			; $42b8
	inc hl			; $42b9
	call _scriptFunc_getTextIndex		; $42ba
	ld a,c			; $42bd
	ld e,Interaction.textID	; $42be
	ld (de),a		; $42c0
	ld a,b			; $42c1
	inc e			; $42c2
	ld (de),a		; $42c3
	ld hl,genericNpcScript		; $42c4
	ret			; $42c7

;;
; @addr{42c8}
_scriptFunc_getTextIndex:
	ld e,Interaction.useTextID	; $42c8
	ld a,(de)		; $42ca
	or a			; $42cb
	jr z,+			; $42cc

	ld e,Interaction.textID+1	; $42ce
	ld a,(de)		; $42d0
	ld b,a			; $42d1
	jr ++			; $42d2
+
	ldi a,(hl)		; $42d4
	ld b,a			; $42d5
++
	ldi a,(hl)		; $42d6
	ld c,a			; $42d7
	ret			; $42d8

_scriptCmd_showText:
	pop hl			; $42d9
	inc hl			; $42da
	call _scriptFunc_getTextIndex		; $42db
	push hl			; $42de
	call showText		; $42df
	pop hl			; $42e2
	ret			; $42e3

_scriptCmd_showTextDifferentForLinked:
	pop hl			; $42e4
	inc hl			; $42e5
	ldi a,(hl)		; $42e6
	ld b,a			; $42e7
	call checkIsLinkedGame		; $42e8
	jr nz,@linked			; $42eb
@unlinked:
	ldi a,(hl)		; $42ed
	inc hl			; $42ee
	jr ++			; $42ef
@linked:
	inc hl			; $42f1
	ldi a,(hl)		; $42f2
++
	ld c,a			; $42f3
	push hl			; $42f4
	call showText		; $42f5
	pop hl			; $42f8
	ret			; $42f9

_scriptCmd_showTextNonExitable:
	pop hl			; $42fa
	inc hl			; $42fb
	call _scriptFunc_getTextIndex		; $42fc
	push hl			; $42ff
	call showTextNonExitable		; $4300
	pop hl			; $4303
	ret			; $4304

_scriptCmd_waitForText:
	pop hl			; $4305
	ld a,(wTextIsActive)		; $4306
	or a			; $4309
	ret nz			; $430a
	inc hl			; $430b
	ret			; $430c

_scriptCmd_setCounter1:
	pop hl			; $430d
	inc hl			; $430e
	ldi a,(hl)		; $430f
_scriptFunc_4310:
	ld e,Interaction.counter1	; $4310
	ld (de),a		; $4312
	xor a			; $4313
	ret			; $4314

_scriptCmd_cpLinkX:
	pop hl			; $4315
	inc hl			; $4316
	push hl			; $4317
	ld e,Interaction.xh		; $4318
	ld a,(de)		; $431a
	ld hl,w1Link.xh		; $431b
	cp (hl)			; $431e
	pop hl			; $431f
	ldi a,(hl)		; $4320
	ld e,a			; $4321
	ld a,$00		; $4322
	jr nc,+			; $4324
	inc a			; $4326
+
	ld (de),a		; $4327
	scf			; $4328
	ret			; $4329

_scriptCmd_shakeScreen:
	pop hl			; $432a
	inc hl			; $432b
	ldi a,(hl)		; $432c
	ld (wScreenShakeCounterX),a		; $432d
	ret			; $4330

_scriptCmd_writeMemory:
	pop hl			; $4331
	inc hl			; $4332
	ldi a,(hl)		; $4333
	ld c,a			; $4334
	ldi a,(hl)		; $4335
	ld b,a			; $4336
	ldi a,(hl)		; $4337
	ld (bc),a		; $4338
	scf			; $4339
	ret			; $433a

_scriptCmd_checkPaletteFadeDone:
	pop hl			; $433b
	ld a,(wPaletteThread_mode)		; $433c
	or a			; $433f
	ret nz			; $4340
	inc hl			; $4341
	ret			; $4342

_scriptCmd_checkCFC0Bit:
	pop hl			; $4343
	ld a,(hl)		; $4344
	and $07			; $4345
	ld bc,bitTable		; $4347
	add c			; $434a
	ld c,a			; $434b
	ld a,(bc)		; $434c
	ld b,a			; $434d
	ld a,($cfc0)		; $434e
	and b			; $4351
	ret z			; $4352
	inc hl			; $4353
	ret			; $4354

_scriptCmd_xorCFC0Bit:
	pop hl			; $4355
	ld a,(hl)		; $4356
	and $07			; $4357
	ld bc,bitTable		; $4359
	add c			; $435c
	ld c,a			; $435d
	ld a,(bc)		; $435e
	ld b,a			; $435f
	ld a,($cfc0)		; $4360
	xor b			; $4363
	ld ($cfc0),a		; $4364
	inc hl			; $4367
	ret			; $4368

_scriptCmd_jumpIfNoEnemies:
	pop hl			; $4369
	ld a,(wNumEnemies)		; $436a
	or a			; $436d
	jp nz,scriptFunc_add3ToHl		; $436e
	inc hl			; $4371
	jp scriptFunc_jump		; $4372

_scriptCmd_jumpIfC6xxSet:
	pop hl			; $4375
	inc hl			; $4376
	ld b,$c6		; $4377
	ld c,(hl)		; $4379
	inc hl			; $437a
	ld a,(bc)		; $437b
	and (hl)		; $437c
	jp z,scriptFunc_add3ToHl		; $437d
	inc hl			; $4380
	jp scriptFunc_jump		; $4381

_scriptCmd_playSound:
	pop hl			; $4384
	inc hl			; $4385
	ldi a,(hl)		; $4386
	push hl			; $4387
	call playSound		; $4388
	pop hl			; $438b
	ret			; $438c

_scriptCmd_updateLinkLocalRespawnPosition:
	call updateLinkLocalRespawnPosition		; $438d
	pop hl			; $4390
	inc hl			; $4391
	ret			; $4392

_scriptCmd_jumpIfLinkVariableNe:
	pop hl			; $4393
	inc hl			; $4394
	ldi a,(hl)		; $4395
	ld d,LINK_OBJECT_INDEX	; $4396
	ld e,a			; $4398
	ld a,(de)		; $4399
	cp (hl)			; $439a
	jr z,+			; $439b

	inc hl			; $439d
	jp scriptFunc_jump		; $439e
+
	ld bc,$0003		; $43a1
	add hl,bc		; $43a4
	ldh a,(<hActiveObject)	; $43a5
	ld d,a			; $43a7
	ret			; $43a8

_scriptCmd_jumpIfMemoryEq:
	pop hl			; $43a9
	inc hl			; $43aa
	ld c,(hl)		; $43ab
	inc hl			; $43ac
	ld b,(hl)		; $43ad
	inc hl			; $43ae
	ld a,(bc)		; $43af
--
	cp (hl)			; $43b0
	jp nz,scriptFunc_add3ToHl_scf		; $43b1
	inc hl			; $43b4
	jp scriptFunc_jump_scf		; $43b5

_scriptCmd_jumpIfInteractionByteEq:
	pop hl			; $43b8
	inc hl			; $43b9
	ldi a,(hl)		; $43ba
	ld e,a			; $43bb
	ld a,(de)		; $43bc
	jr --			; $43bd

_scriptCmd_jumpIfRoomFlagSet:
	pop hl			; $43bf
	inc hl			; $43c0
	ldi a,(hl)		; $43c1
	ld b,a			; $43c2
	push hl			; $43c3
	call getThisRoomFlags		; $43c4
	and b			; $43c7
	jr nz,@flagset		; $43c8
@flagunset:
	pop hl			; $43ca
	inc hl			; $43cb
	inc hl			; $43cc
	scf			; $43cd
	ret			; $43ce
@flagset:
	pop hl			; $43cf
	jp scriptFunc_jump_scf		; $43d0

_scriptCmd_orRoomFlags:
	pop hl			; $43d3
	inc hl			; $43d4
	ldi a,(hl)		; $43d5
	ld b,a			; $43d6
	push hl			; $43d7
	call getThisRoomFlags		; $43d8
	or b			; $43db
	ld (hl),a		; $43dc
	pop hl			; $43dd
	ret			; $43de

_scriptCmd_checkSomething:
	ld e,Interaction.pressedAButton		; $43df
	call objectAddToAButtonSensitiveObjectList		; $43e1
	pop hl			; $43e4
	jr nc,+			; $43e5
	inc hl			; $43e7
+
	ret			; $43e8

_scriptCmd_showLoadedText:
	ld e,Interaction.textID	; $43e9
	ld a,(de)		; $43eb
	ld c,a			; $43ec
	inc e			; $43ed
	ld a,(de)		; $43ee
	ld b,a			; $43ef
	call showText		; $43f0
	pop hl			; $43f3
	inc hl			; $43f4
	ret			; $43f5

_scriptCmd_setTextID:
	pop hl			; $43f6
	inc hl			; $43f7
	ldi a,(hl)		; $43f8
	ld e,Interaction.textID	; $43f9
	ld (de),a		; $43fb
	inc e			; $43fc
	ldi a,(hl)		; $43fd
	ld (de),a		; $43fe
	scf			; $43ff
	ret			; $4400

_scriptCmd_setMusic:
	pop hl			; $4401
	inc hl			; $4402
	ldi a,(hl)		; $4403
	cp $ff			; $4404
	jr nz,+			; $4406
	ld a,(wActiveMusic2)		; $4408
+
	ld (wActiveMusic),a		; $440b
	push hl			; $440e
	call playSound		; $440f
	pop hl			; $4412
	ret			; $4413

_scriptCmd_orMemory:
	pop hl			; $4414
	inc hl			; $4415
	ldi a,(hl)		; $4416
	ld c,a			; $4417
	ldi a,(hl)		; $4418
	ld b,a			; $4419
	ld a,(bc)		; $441a
	or (hl)			; $441b
	ld (bc),a		; $441c
	inc hl			; $441d
	scf			; $441e
	ret			; $441f

_scriptCmd_spawnItem:
	pop hl			; $4420
	ld e,(hl)		; $4421
	inc hl			; $4422
	ldi a,(hl)		; $4423
	ld b,a			; $4424
	ldi a,(hl)		; $4425
	ld c,a			; $4426
	push hl			; $4427
	call getFreeInteractionSlot		; $4428
	jp nz,_scriptFunc_restoreActiveObject		; $442b
	ld (hl),INTERACID_TREASURE		; $442e
	inc l			; $4430
	ld (hl),b		; $4431
	inc l			; $4432
	ld (hl),c		; $4433
	ld a,e			; $4434
	cp $de			; $4435
	jr z,+			; $4437
	call objectCopyPosition		; $4439
	jp _scriptFunc_restoreActiveObject		; $443c
+
	ld e,Interaction.counter1	; $443f
	ld a,$03		; $4441
	ld (de),a		; $4443
	ld de,w1Link.yh		; $4444
	call objectCopyPosition_rawAddress		; $4447
	jp _scriptFunc_restoreActiveObject		; $444a

_scriptCmd_df:
	pop hl			; $444d
	inc hl			; $444e
	ldi a,(hl)		; $444f
	call checkTreasureObtained		; $4450
	ld ($cfc1),a		; $4453
	jr nc,+			; $4456
	jp scriptFunc_jump		; $4458
+
	inc hl			; $445b
	inc hl			; $445c
	ret			; $445d

_scriptCmd_jumpIfSomething:
	pop hl			; $445e
	inc hl			; $445f
	ld a,TREASURE_TRADEITEM		; $4460
	call checkTreasureObtained		; $4462
	jr nc,++		; $4465

	ld b,a			; $4467
	ldi a,(hl)		; $4468
	dec a			; $4469
	cp b			; $446a
	jr nz,+++		; $446b
	jp scriptFunc_jump		; $446d
++
	inc hl			; $4470
+++
	inc hl			; $4471
	inc hl			; $4472
	ret			; $4473

_scriptCmd_setLinkCantMove:
	pop hl			; $4474
	inc hl			; $4475
	ldi a,(hl)		; $4476
	ld (wDisabledObjects),a		; $4477
	ret			; $447a

_scriptCmd_checkCounter2Zero:
	pop hl			; $447b
	ld e,Interaction.counter2	; $447c
	ld a,(de)		; $447e
	or a			; $447f
	ret nz			; $4480
	inc hl			; $4481
	ret			; $4482

_scriptCmd_setTile:
	pop hl			; $4483
	inc hl			; $4484
	ldi a,(hl)		; $4485
--
	ld c,a			; $4486
	ldi a,(hl)		; $4487
	push hl			; $4488
	call setTile		; $4489
	pop hl			; $448c
	scf			; $448d
	ret			; $448e

_scriptCmd_setTileHere:
	pop hl			; $448f
	inc hl			; $4490
	call objectGetShortPosition		; $4491
	jr --			; $4494

_scriptCmd_callScript:
	pop hl			; $4496
	inc hl			; $4497
	ldi a,(hl)		; $4498
	ld c,a			; $4499
	ldi a,(hl)		; $449a
	ld b,a			; $449b
	ld e,Interaction.scriptRet	; $449c
	ld a,l			; $449e
	ld (de),a		; $449f
	inc e			; $44a0
	ld a,h			; $44a1
	ld (de),a		; $44a2
	ld l,c			; $44a3
	ld h,b			; $44a4
	ret			; $44a5

_scriptCmd_ret:
	pop hl			; $44a6
	ld e,Interaction.scriptRet	; $44a7
	ld a,(de)		; $44a9
	ld l,a			; $44aa
	inc e			; $44ab
	ld a,(de)		; $44ac
	ld h,a			; $44ad
	ret			; $44ae

--
	inc hl			; $44af
	jp scriptFunc_jump_scf		; $44b0
_scriptCmd_jumpIfCBA5Eq:
	pop hl			; $44b3
	inc hl			; $44b4
	ld a,(wSelectedTextOption)		; $44b5
	cp (hl)			; $44b8
	jr z,--			; $44b9
	jp scriptFunc_add3ToHl_scf		; $44bb

_scriptCmd_jumpRandom:
.ifdef ROM_AGES
	pop hl			; $44be
	inc hl			; $44bf
	jp scriptFunc_jump_scf		; $44c0

.else; ROM_SEASONS
	pop hl			; $44a6
	inc hl			; $44a7
	call getRandomNumber		; $44a8
	and $01			; $44ab
	add a			; $44ad
	rst_addAToHl			; $44ae
	jp scriptFunc_jump_scf		; $44af
.endif

_scriptCmd_jumpTable:
	pop hl			; $44c3
	inc hl			; $44c4
	ldi a,(hl)		; $44c5
	ld e,a			; $44c6
	ld a,(de)		; $44c7
	rst_addDoubleIndex			; $44c8
	jp scriptFunc_jump		; $44c9

_scriptCmd_jumpIfMemorySet:
	pop hl			; $44cc
	inc hl			; $44cd
	ldi a,(hl)		; $44ce
	ld b,(hl)		; $44cf
	ld c,a			; $44d0
	inc hl			; $44d1
	ld a,(bc)		; $44d2
	and (hl)		; $44d3
	jp z,scriptFunc_add3ToHl		; $44d4
	inc hl			; $44d7
	jp scriptFunc_jump_scf		; $44d8

_scriptCmd_writeC6xx:
	pop hl			; $44db
	inc hl			; $44dc
	ld b,$c6		; $44dd
	ld c,(hl)		; $44df
	inc hl			; $44e0
	ldi a,(hl)		; $44e1
	ld (bc),a		; $44e2
	ret			; $44e3

_scriptCmd_checkCollidedWithLink_ignoreZ:
	call objectCheckCollidedWithLink_ignoreZ		; $44e4
	pop hl			; $44e7
	ret nc			; $44e8
	jr ++			; $44e9

_scriptCmd_checkCollidedWithLink_onGround:
	call objectCheckCollidedWithLink_onGround		; $44eb
	pop hl			; $44ee
	ret nc			; $44ef
++
	call _func_0c_4177		; $44f0
	inc hl			; $44f3
	ret			; $44f4

_scriptCmd_checkAButton:
	ld e,Interaction.pressedAButton		; $44f5
	ld a,(de)		; $44f7
	or a			; $44f8
	pop hl			; $44f9
	ret z			; $44fa

	xor a			; $44fb
	ld (de),a		; $44fc
	call _func_0c_4177		; $44fd
	inc hl			; $4500
	scf			; $4501
	ret			; $4502

_scriptCmd_checkNoEnemies:
	pop hl			; $4503
	ld a,(wNumEnemies)		; $4504
	or a			; $4507
	ret nz			; $4508
	inc hl			; $4509
	ret			; $450a

_scriptCmd_checkFlagSet:
	pop hl			; $450b
	push hl			; $450c
	inc hl			; $450d
	ldi a,(hl)		; $450e
	ld b,a			; $450f
	ldi a,(hl)		; $4510
	ld h,(hl)		; $4511
	ld l,a			; $4512
	ld a,b			; $4513
	call checkFlag		; $4514
	pop hl			; $4517
	ret z			; $4518
	ld bc,$0004		; $4519
	add hl,bc		; $451c
	scf			; $451d
	ret			; $451e

_scriptCmd_checkInteractionByteEq:
	pop hl			; $451f
	push hl			; $4520
	inc hl			; $4521
	ldi a,(hl)		; $4522
	ld e,a			; $4523
	ld a,(de)		; $4524
	cp (hl)			; $4525
	jr z,+			; $4526

	pop hl			; $4528
	xor a			; $4529
	ret			; $452a
+
	pop bc			; $452b
	inc hl			; $452c
	ret			; $452d

_scriptCmd_checkMemoryEq:
	pop hl			; $452e
	push hl			; $452f
	inc hl			; $4530
	ldi a,(hl)		; $4531
	ld c,a			; $4532
	ldi a,(hl)		; $4533
	ld b,a			; $4534
	ld a,(bc)		; $4535
	cp (hl)			; $4536
	jr z,+			; $4537

	pop hl			; $4539
	xor a			; $453a
	ret			; $453b
+
	pop bc			; $453c
	inc hl			; $453d
	ret			; $453e

_scriptCmd_checkHeartDisplayUpdated:
	pop hl			; $453f
	ld a,(wDisplayedHearts)		; $4540
	ld b,a			; $4543
	ld a,(wLinkHealth)		; $4544
	cp b			; $4547
	jr z,+			; $4548
	xor a			; $454a
	ret			; $454b
+
	inc hl			; $454c
	scf			; $454d
	ret			; $454e

_scriptCmd_checkRupeeDisplayUpdated:
	ld hl,wNumRupees		; $454f
	ld a,(wDisplayedRupees)		; $4552
	cp (hl)			; $4555
	jr nz,+			; $4556

	inc l			; $4558
	ld a,(wDisplayedRupees+1)		; $4559
	cp (hl)			; $455c
	jp z,_scriptFunc_popHlAndInc		; $455d
+
	pop hl			; $4560
	xor a			; $4561
	ret			; $4562

_scriptCmd_checkNotCollidedWithLink_ignoreZ:
	call objectCheckCollidedWithLink_ignoreZ		; $4563
	pop hl			; $4566
	jr c,+			; $4567
	inc hl			; $4569
	ret			; $456a
+
	xor a			; $456b
	ret			; $456c

_scriptCmd_createPuff:
	call objectCreatePuff		; $456d
	pop hl			; $4570
	inc hl			; $4571
	ret			; $4572

_scriptCmd_jumpIfGlobalFlagSet:
	pop hl			; $4573
	inc hl			; $4574
	ldi a,(hl)		; $4575
	push hl			; $4576
	call checkGlobalFlag		; $4577
	pop hl			; $457a
	jr z,+			; $457b
	jp scriptFunc_jump_scf		; $457d
+
	inc hl			; $4580
	inc hl			; $4581
	scf			; $4582
	ret			; $4583

_scriptCmd_setOrUnsetGlobalFlag:
	pop hl			; $4584
	inc hl			; $4585
	ldi a,(hl)		; $4586
	bit 7,a			; $4587
	jr nz,@unset		; $4589
@set:
	push hl			; $458b
	call setGlobalFlag		; $458c
	pop hl			; $458f
	scf			; $4590
	ret			; $4591
@unset:
	and $7f			; $4592
	push hl			; $4594
	call unsetGlobalFlag		; $4595
	pop hl			; $4598
	scf			; $4599
	ret			; $459a

_scriptCmd_initNpcHitbox:
.ifdef ROM_AGES
	ld e,Interaction.collisionRadiusY	; $459b
	ld a,(de)		; $459d
	or a			; $459e
	jr nz,+			; $459f
.endif

	ld a,$06		; $45a1
	call objectSetCollideRadius		; $45a3
+
	ld e,Interaction.pressedAButton	; $45a6
	call objectRemoveFromAButtonSensitiveObjectList		; $45a8
	ld e,Interaction.pressedAButton	; $45ab
	call objectAddToAButtonSensitiveObjectList		; $45ad
	pop hl			; $45b0
	ret nc			; $45b1

	inc hl			; $45b2
	scf			; $45b3
	ret			; $45b4

_scriptCmd_moveNpcUp:
	ld a,$00		; $45b5
--
	ld e,Interaction.angle	; $45b7
	ld (de),a		; $45b9
	call convertAngleDeToDirection		; $45ba
	call interactionSetAnimation		; $45bd
	pop hl			; $45c0
	inc hl			; $45c1
	ldi a,(hl)		; $45c2
	ld e,Interaction.counter2	; $45c3
	ld (de),a		; $45c5
	xor a			; $45c6
	ret			; $45c7

_scriptCmd_moveNpcRight:
	ld a,$08		; $45c8
	jr --			; $45ca

_scriptCmd_moveNpcDown:
	ld a,$10		; $45cc
	jr --			; $45ce

_scriptCmd_moveNpcLeft:
	ld a,$18		; $45d0
	jr --			; $45d2

_scriptCmd_delay:
	pop hl			; $45d4
	ldi a,(hl)		; $45d5
	and $0f			; $45d6
	ld bc,@delayLengths	; $45d8
	call addAToBc		; $45db
	ld a,(bc)		; $45de
	jp _scriptFunc_4310		; $45df

; @addr{45e2}
@delayLengths:
	.db 1 4 8 10 15 20 30 40 60 90 120 180 240
