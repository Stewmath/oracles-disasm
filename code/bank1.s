.BANK $01 SLOT 1
.ORG 0

 m_section_free "Bank_1_Code_1" NAMESPACE "bank1"

;;
; @addr{4000}
func_4000:
	ld a,(wScrollMode)		; $4000
	or a			; $4003
	call nz,func_400b		; $4004
	xor a			; $4007
	ld ($ff00+R_SVBK),a	; $4008
	ret			; $400a

;;
; @addr{400b}
func_400b:
	ld a,(wScreenTransitionState)		; $400b
	rst_jumpTable			; $400e
	.dw _screenTransitionState0
	.dw _screenTransitionState1
	.dw _screenTransitionState2
	.dw _screenTransitionState3
	.dw _screenTransitionState4
	.dw _screenTransitionState5

;;
; State 0: Entering a room from scratch (after entering/exiting a building, fadeout
; transition, etc)
;
; @addr{401b}
_screenTransitionState0:
	xor a			; $401b
	ld (wPaletteThread_parameter),a		; $401c
	call checkDarkenRoom		; $401f
	ld a,$01		; $4022
	ld (wScreenTransitionState),a		; $4024

;;
; @addr{4027}
initializeRoomBoundaryAndLoadAnimations:
	call setCameraFocusedObjectToLink		; $4027
	ld b,$01		; $402a
	ld a,(wActiveGroup)		; $402c
	and NUM_SMALL_GROUPS			; $402f
	jr z,+			; $4031
	ld b,$00		; $4033
+
	ld a,b			; $4035
	ld (wcd01),a		; $4036
	xor $01			; $4039
	ld (wRoomIsLarge),a		; $403b

	ld a,(wcd01)		; $403e
	add a			; $4041
	ld hl,@data_406d	; $4042
	rst_addDoubleIndex			; $4045

	; Load values of wRoomWidth, wRoomHeight, wScreenTransitionBoundaryX,
	; wScreenTransitionBoundaryY
	ld de,wRoomWidth		; $4046
	ld b,$04		; $4049
--
	ldi a,(hl)		; $404b
	ld (de),a		; $404c
	inc de			; $404d
	dec b			; $404e
	jr nz,--		; $404f

	ld a,(wRoomWidth)		; $4051
	sub 20			; $4054
	add a			; $4056
	add a			; $4057
	add a			; $4058
	ld (wMaxCameraY),a		; $4059
	ld a,(wRoomHeight)		; $405c
	sub 16			; $405f
	add a			; $4061
	add a			; $4062
	add a			; $4063
	ld (wMaxCameraX),a		; $4064
	call calculateRoomEdge		; $4067
	jp loadAreaAnimation		; $406a

; Format:
; b0: wRoomWidth (measured in 8x8 tiles)
; b1: wRoomHeight
; b2: wScreenTransitionBoundaryX
; b3: wScreenTransitionBoundaryY
@data_406d:
	.db LARGE_ROOM_WIDTH*2      LARGE_ROOM_HEIGHT*2   ; Large rooms
	.db LARGE_ROOM_WIDTH*16-6   LARGE_ROOM_HEIGHT*16-7
	.db SMALL_ROOM_WIDTH*2      SMALL_ROOM_HEIGHT*2   ; Small rooms
	.db SMALL_ROOM_WIDTH*16-6   SMALL_ROOM_HEIGHT*16-7

;;
; State 1: Waiting a bit before giving control to return to Link.
;
; @addr{4075}
_screenTransitionState1:
	ld a,(wcd03)		; $4075
	inc a			; $4078
	ld (wcd03),a		; $4079
	ld a,(wScreenTransitionState2)		; $407c
	rst_jumpTable			; $407f
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw setScreenTransitionState02

;;
; Initializing
;
; @addr{4088}
@substate0:
	ld a,(wPaletteThread_mode)		; $4088
	or a			; $408b
	ret nz			; $408c

	ld a,$02		; $408d
	ld (wScrollMode),a		; $408f
	ld a,$01		; $4092
	ld (wScreenTransitionState2),a		; $4094
	xor a			; $4097
	ld (wScreenTransitionState3),a		; $4098
	ld (wcd03),a		; $409b
	jp resetCamera		; $409e

;;
; More initializing?
;
; @addr{40a1}
@substate1:
	ld a,(wScreenOffsetX)		; $40a1
	ld b,a			; $40a4
	ldh a,(<hCameraX)	; $40a5
	add b			; $40a7
	add $50			; $40a8
	rrca			; $40aa
	rrca			; $40ab
	rrca			; $40ac
	dec a			; $40ad
	and $1f			; $40ae
	ld (wScreenScrollRow),a		; $40b0
	inc a			; $40b3
	ld (wScreenScrollDirection),a		; $40b4
	xor a			; $40b7
	ld (wScreenScrollCounter),a		; $40b8
	ld a,$02		; $40bb
	ld (wScreenTransitionState2),a		; $40bd
	ret			; $40c0

;;
; The game is in this state while the screen is scrolling
;
; @addr{40c1}
@substate2:
	ld a,(wScreenScrollCounter)		; $40c1
	cp $20			; $40c4
	jr z,setScreenTransitionState02		; $40c6

	inc a			; $40c8
	ld (wScreenScrollCounter),a		; $40c9
	ld a,(wcd03)		; $40cc
	rrca			; $40cf
	jr c,+			; $40d0

	ld a,(wScreenScrollRow)		; $40d2
	ldh (<hFF8B),a	; $40d5
	ld b,a			; $40d7
	dec a			; $40d8
	and $1f			; $40d9
	ld (wScreenScrollRow),a		; $40db
	jr ++			; $40de
+
	ld a,(wScreenScrollDirection)		; $40e0
	ldh (<hFF8B),a	; $40e3
	ld b,a			; $40e5
	inc a			; $40e6
	and $1f			; $40e7
	ld (wScreenScrollDirection),a		; $40e9
++
	ld e,b			; $40ec
	call func_46ca		; $40ed
	ldh a,(<hFF8B)	; $40f0
	jp addFunctionsToVBlankQueue		; $40f2

;;
; @addr{40f5}
setScreenTransitionState02:
	call setInstrumentsDisabledCounterAndScrollMode		; $40f5
	ld a,$02		; $40f8
	ld (wScreenTransitionState),a		; $40fa
	xor a			; $40fd
	ld (wScreenTransitionState2),a		; $40fe
	ld (wScreenTransitionState3),a		; $4101
	ret			; $4104

;;
; State 2: no screen transition is active; check whether one should be activated.
;
; Called every frame.
;
; @addr{4105}
_screenTransitionState2:
	ld a,(wLinkInAir)		; $4105
	add a			; $4108
	jr c,+			; $4109
	jr z,+			; $410b

	ld a,$04		; $410d
	ld (wScreenTransitionDelay),a		; $410f
+
	; Check for a "forced" screen transition from bit 7
	ld a,(wScreenTransitionDirection)		; $4112
	bit 7,a			; $4115
	jr z,+			; $4117

	and $7f			; $4119
	ld c,a			; $411b
	jp @startTransition		; $411c
+
	; Check for screen-edge transitions
	ld a,(wLinkObjectIndex)		; $411f
	ld h,a			; $4122
	ld l,<w1Link.yh		; $4123
	ld a,$05		; $4125
	cp (hl)			; $4127
	jr nc,@transitionUp		; $4128

	ld a,(wScreenTransitionBoundaryY)		; $412a
	cp (hl)			; $412d
	jr c,@transitionDown		; $412e
--
	ld l,<w1Link.xh		; $4130
	ld a,$05		; $4132
	cp (hl)			; $4134
	jr nc,@transitionLeft	; $4135
	ld a,(wScreenTransitionBoundaryX)		; $4137
	cp (hl)			; $413a
	jr c,@transitionRight	; $413b
	ret			; $413d

@transitionUp:
	inc a			; $413e
	ld (hl),a		; $413f
	ld b,BTN_UP		; $4140
	ld c,DIR_UP		; $4142
	call @transition		; $4144
	jr --			; $4147

@transitionDown:
	ld (hl),a		; $4149
	ld b,BTN_DOWN		; $414a
	ld c,DIR_DOWN		; $414c
	call @transition		; $414e
	jr --			; $4151

@transitionLeft:
	inc a			; $4153
	ld (hl),a		; $4154
	ld b,BTN_LEFT		; $4155
	ld c,DIR_LEFT		; $4157
	jr @transition		; $4159

@transitionRight:
	ld (hl),a		; $415b
	ld b,BTN_RIGHT		; $415c
	ld c,DIR_RIGHT		; $415e

;;
; @param	b	Direction button to check
; @param	c	Direction of transition (see constants/directions.s)
; @addr{4160}
@transition:
	ld a,(w1Link.enabled)		; $4160
	or a			; $4163
	ret z			; $4164

	ld a,(wDisableScreenTransitions)		; $4165
	or a			; $4168
	ret nz			; $4169

	; Don't transition until this counter reaches 0
	ld a,(wScreenTransitionDelay)		; $416a
	or a			; $416d
	jr z,+			; $416e
	dec a			; $4170
	ld (wScreenTransitionDelay),a		; $4171
	ret			; $4174
+
	ld a,(w1Companion.id)		; $4175
	cp SPECIALOBJECTID_MINECART			; $4178
	jr z,@startTransition	; $417a

	; Don't allow transitions over holes
	ld a,(wcc92)		; $417c
	add a			; $417f
	ret c			; $4180

	; Do something if jumping down a ledge
	ld a,(wLinkInAir)		; $4181
	add a			; $4184
	jr c,@startTransition	; $4185

	; Don't transition while experiencing knockback
	ld a,(w1Link.knockbackCounter)		; $4187
	or a			; $418a
	ret nz			; $418b

	; Check the lower 7 bits; allows transitions to occur if on a conveyor and not
	; moving toward the screen edge?
	ld a,(wcc92)		; $418c
	add a			; $418f
	jr nz,+			; $4190

	; Check that Link is moving toward the boundary
	call convertLinkAngleToDirectionButtons		; $4192
	and b			; $4195
	ret z			; $4196
+
.ifdef ROM_AGES
	; Ages only: forbid looping around the overworld map in any direction, except up.
	ld a,(wAreaFlags)		; $4197
	and AREAFLAG_OUTDOORS			; $419a
	jr z,@doneBoundaryChecks	; $419c

	; Check rightmost map boundary
	ld a,(wActiveRoom)		; $419e
	ld e,a			; $41a1
	and $0f			; $41a2
	cp OVERWORLD_WIDTH-1			; $41a4
	jr nz,+			; $41a6
	ld a,c			; $41a8
	cp DIR_RIGHT			; $41a9
	ret z			; $41ab
+
	; Check bottom-most map boundary
	ld a,e			; $41ac
	cp (OVERWORLD_HEIGHT-1)*16			; $41ad
	jr c,+			; $41af
	ld a,c			; $41b1
	cp DIR_DOWN			; $41b2
	ret z			; $41b4
+
	; Check leftmost map boundary
	ld a,e			; $41b5
	and $0f			; $41b6
	jr nz,@doneBoundaryChecks	; $41b8
	ld a,c			; $41ba
	cp DIR_LEFT			; $41bb
	ret z			; $41bd

@doneBoundaryChecks:
	; Skip hazard checks if underwater
	ld a,(wAreaFlags)		; $41be
	and AREAFLAG_UNDERWATER			; $41c1
	jr nz,@startTransition	; $41c3

	; Also skip checks if on a conveyor? (Or on the raft, apparently?)
	ld a,(wcc92)		; $41c5
	and $08			; $41c8
	jr nz,@startTransition	; $41ca

.endif ; ROM_AGES

	; Return if Link is over a hole/lava, or over water without flippers?
	call checkLinkIsOverHazard		; $41cc
	rrca			; $41cf
	call c,@checkCanTransitionOverWater		; $41d0
	and $03			; $41d3
	ret nz			; $41d5


@startTransition:
	ld a,$04		; $41d6
	ld (wScrollMode),a		; $41d8
	ld a,$03		; $41db
	ld (wScreenTransitionState),a		; $41dd
	ld a,c			; $41e0
	ld (wScreenTransitionDirection),a		; $41e1
	ret			; $41e4

;;
; @param[out]	a	One of bits 0/1 set if Link is forbidden to transition over water.
; @addr{41e5}
@checkCanTransitionOverWater:
	; Return false if Link is riding something? (apparently code execution doesn't
	; reach here if Link is riding the raft, perhaps Dimitri as well?)
	ld a,(wLinkObjectIndex)		; $41e5
	rrca			; $41e8
	jr c,@fail			; $41e9

.ifdef ROM_AGES
	ld a,TREASURE_MERMAID_SUIT		; $41eb
	call checkTreasureObtained		; $41ed
	ret c			; $41f0
	ld a,(wObjectTileIndex)		; $41f1
	cp TILEINDEX_DEEP_WATER			; $41f4
	jr z,@fail			; $41f6
.endif

	ld a,TREASURE_FLIPPERS		; $41f8
	call checkTreasureObtained		; $41fa
	ret c			; $41fd

@fail:
	ld a,$ff		; $41fe
	ret			; $4200

;;
; Updates the values for hCameraY/X. They get updated one pixel at a time in each
; direction.
;
; @addr{4201}
updateCameraPosition:
	ld hl,wScrollMode		; $4201
	res 7,(hl)		; $4204
	ld a,(wActiveGroup)		; $4206
	cp NUM_SMALL_GROUPS		; $4209
	jr nc,@largeRoom			; $420b

@smallRoom:
	xor a			; $420d
	ldh (<hCameraY),a	; $420e
	ldh (<hCameraX),a	; $4210
	ret			; $4212

@largeRoom:
	ld a,(wCameraFocusedObject)		; $4213
	ld d,a			; $4216
	ld a,(wCameraFocusedObjectType)		; $4217
	add Object.yh			; $421a
	ld e,a			; $421c

	; Update Y
	ld hl,hCameraY		; $421d
	ld a,(de)		; $4220
	sub SCREEN_HEIGHT*16/2			; $4221
	jr nc,+			; $4223
	xor a			; $4225
+
	cp (LARGE_ROOM_HEIGHT-SCREEN_HEIGHT)*16			; $4226
	jr c,+			; $4228
	ld a,(LARGE_ROOM_HEIGHT-SCREEN_HEIGHT)*16		; $422a
+
	call @updateComponent		; $422c

	; Update X
	ld hl,hCameraX		; $422f
	inc de			; $4232
	inc de			; $4233
	ld a,(de)		; $4234
	sub SCREEN_WIDTH*16/2			; $4235
	jr nc,+			; $4237
	xor a			; $4239
+
	cp (LARGE_ROOM_WIDTH-SCREEN_WIDTH)*16			; $423a
	jr c,@updateComponent	; $423c
	ld a,(LARGE_ROOM_WIDTH-SCREEN_WIDTH)*16		; $423e

;;
; @param	a	Target value for the position component
; @param	hl	Position component
; @addr{4240}
@updateComponent:
	ld b,a			; $4240
	ld a,(wTextIsActive)		; $4241
	or a			; $4244
	jr nz,@smBit7		; $4245

	ld a,(hl)		; $4247
	cp b			; $4248
	ret z			; $4249
	jr c,+			; $424a

	dec (hl)		; $424c
	jr @smBit7			; $424d
+
	inc (hl)		; $424f

@smBit7:
	ld hl,wScrollMode		; $4250
	set 7,(hl)		; $4253
	ret			; $4255

;;
; Sets hCameraY/X to the correct values immediately. Differs from "updateCameraPosition"
; since that function updates it one pixel at a time.
;
; Called when loading a screen.
;
; @addr{4256}
calculateCameraPosition:
	ld a,(wLinkObjectIndex)		; $4256
	ld d,a			; $4259
	ld e,<w1Link.yh		; $425a
	ld a,(de)		; $425c
	sub SCREEN_HEIGHT*16/2			; $425d
	jr nc,+			; $425f
	xor a			; $4261
+
	ld hl,wMaxCameraX		; $4262
	cp (hl)			; $4265
	jr c,+			; $4266
	ld a,(hl)		; $4268
+
	ldh (<hCameraY),a	; $4269
	ld e,<w1Link.xh		; $426b
	ld a,(de)		; $426d
	sub SCREEN_WIDTH*16/2			; $426e
	jr nc,+			; $4270
	xor a			; $4272
+
	ld hl,wMaxCameraY		; $4273
	cp (hl)			; $4276
	jr c,+			; $4277
	ld a,(hl)		; $4279
+
	ldh (<hCameraX),a	; $427a
	ret			; $427c

;;
; Adjusts wGfxRegs2.SCY and SCX if the screen should be shaking.
;
; @addr{427d}
updateScreenShake:
	ld a,(wMenuDisabled)		; $427d
	or a			; $4280
	jr nz,++			; $4281

	ld a,(wLinkPlayingInstrument)		; $4283
	or a			; $4286
	ret nz			; $4287
++
	ld a,(wScreenShakeCounterY)		; $4288
	or a			; $428b
	jr z,++			; $428c

	call @getShakeAmount		; $428e
	ld a,(wGfxRegs2.SCY)		; $4291
	add (hl)		; $4294
	ld (wGfxRegs2.SCY),a		; $4295
	ld hl,wScreenShakeCounterY		; $4298
	dec (hl)		; $429b
++
	ld a,(wScreenShakeCounterX)		; $429c
	or a			; $429f
	ret z			; $42a0

	call @getShakeAmount		; $42a1
	ld a,(wGfxRegs2.SCX)		; $42a4
	add (hl)		; $42a7
	ld (wGfxRegs2.SCX),a		; $42a8
	ld hl,wScreenShakeCounterX		; $42ab
	dec (hl)		; $42ae
	ret			; $42af

;;
; @param[out]	hl	Pointer to amount to offset the screen by
; @addr{42b0}
@getShakeAmount:
	ld a,(wScreenShakeMagnitude)		; $42b0
	add a			; $42b3
	ld hl,@data		; $42b4
	rst_addDoubleIndex			; $42b7
	call getRandomNumber		; $42b8
	and $03			; $42bb
	rst_addAToHl			; $42bd
	ret			; $42be

@data:
	.db $fe $ff $01 $02 ; [wScreenShakeMagnitude] == 0
	.db $ff $ff $01 $01 ; 1
	.db $fd $fd $03 $03 ; 2

;;
; Sets wGfxRegs2.SCY and SCX based on wScreenOffsetY/X and hCameraY/X.
;
; @addr{42cb}
updateGfxRegs2Scroll:
	ldh a,(<hCameraY)	; $42cb
	ld b,a			; $42cd
	ld a,(wScreenOffsetY)		; $42ce
	add b			; $42d1
	sub $10			; $42d2
	ld (wGfxRegs2.SCY),a		; $42d4
	ldh a,(<hCameraX)	; $42d7
	ld b,a			; $42d9
	ld a,(wScreenOffsetX)		; $42da
	add b			; $42dd
	ld (wGfxRegs2.SCX),a		; $42de
	ret			; $42e1

;;
; State 3: the edge of the screen has just been touched
;
; @addr{42e2}
_screenTransitionState3:
	ld a,(wScrollMode)		; $42e2
	bit 7,a			; $42e5
	ret nz			; $42e7

	cp $08			; $42e8
	ret nz			; $42ea

	call loadAreaAnimation		; $42eb
	call checkDarkenRoom		; $42ee

	; Decide whether to proceed to state 4 or 5
	ld b,$05		; $42f1
	ld a,(wAreaUniqueGfx)		; $42f3
	bit 7,a			; $42f6
	jr nz,+
	or a			; $42fa
	jr z,+

	call loadUniqueGfxHeader		; $42fd
	ld b,$04		; $4300
+
	ld hl,wScreenTransitionState		; $4302
	ld a,b			; $4305
	ldi (hl),a		; $4306

	; [wScreenTransitionState2] = 0
	xor a			; $4307
	ld (hl),a		; $4308

	ld (wScreenTransitionState3),a		; $4309
	ret			; $430c

;;
; @addr{430d}
checkDarkenRoomAndClearPaletteFadeState:
	xor a			; $430d
	ld (wPaletteThread_parameter),a		; $430e

;;
; @addr{4311}
checkDarkenRoom:
	ld a,(wDungeonIndex)		; $4311
	cp $ff			; $4314
	ret z			; $4316

.ifdef ROM_SEASONS
	; Hardcoded check for snake's remains entrance
	ld a,(wActiveGroup)		; $42d5
	cp $04			; $42d8
	jr nz,++			; $42da
	ld a,(wActiveRoom)		; $42dc
	cp $39			; $42df
	jr nz,++			; $42e1
	call getThisRoomFlags		; $42e3
	and $80			; $42e6
	ret nz			; $42e8
++

.endif

	call getThisRoomDungeonProperties		; $4317
	ld a,(wDungeonRoomProperties)		; $431a
	bit DUNGEONROOMPROPERTY_DARK_BIT,a			; $432f
	ret z			; $431f
	jp darkenRoom		; $4320

;;
; @addr{4323}
checkBrightenRoom:
	ld a,(wDungeonIndex)		; $4323
	cp $ff			; $4326
	ret z			; $4328

	call getThisRoomDungeonProperties		; $4329
	ld a,(wDungeonRoomProperties)		; $432c
	bit DUNGEONROOMPROPERTY_DARK_BIT,a			; $432f
	ret nz			; $4331

	ld a,(wPaletteThread_parameter)		; $4332
	or a			; $4335
	ret z			; $4336
	jp brightenRoom		; $4337

;;
; State 4: reload unique gfx / palettes, then proceed to state 5?
;
; @addr{433a}
_screenTransitionState4:
	call updateAreaUniqueGfx		; $433a
	ret c			; $433d

	ld a,(wAreaUniqueGfx)		; $433e
	ld (wLoadedAreaUniqueGfx),a		; $4341
	xor a			; $4344
	ld (wAreaUniqueGfx),a		; $4345

	call func_47fc		; $4348
	call nc,updateAreaPalette		; $434b
	ld hl,wScreenTransitionState		; $434e
	ld a,$05		; $4351
	ldi (hl),a		; $4353
	xor a			; $4354
	ld (hl),a		; $4355
	ld (wScreenTransitionState3),a		; $4356
	ret			; $4359

;;
; State 5: Scrolling between 2 screens
;
; @addr{435a}
_screenTransitionState5:
	ld a,(wScreenTransitionState2)		; $435a
	rst_jumpTable			; $435d
	.dw _screenTransitionState5Substate0
	.dw _screenTransitionState5Substate1
	.dw _screenTransitionState5Substate2

;;
; @addr{4364}
_screenTransitionState5Substate0:
	ld a,(wPaletteThread_mode)		; $4364
	or a			; $4367
	ret nz			; $4368

.ifdef ROM_AGES
	ld a,(wAreaFlags)		; $4369
	and AREAFLAG_OUTDOORS			; $436c
	call nz,checkAndApplyPaletteFadeTransition		; $436e
.else; ROM_SEASONS
	ld a,(wActiveGroup)
	or a
	call z,checkAndApplyPaletteFadeTransition
.endif

	ld a,(wcd01)		; $4371
	swap a			; $4374
	ld l,a			; $4376
	ld a,(wScreenTransitionDirection)		; $4377
	add a			; $437a
	add a			; $437b
	add l			; $437c
	ld hl,@data		; $437d
	rst_addAToHl			; $4380

	ldi a,(hl)		; $4381
	ld (wScreenScrollRow),a		; $4382
	ldi a,(hl)		; $4385
	ld (wScreenScrollVramRow),a		; $4386
	ldi a,(hl)		; $4389
	ld (wScreenScrollDirection),a		; $438a
	ldi a,(hl)		; $438d
	ld (wcd14),a		; $438e
	call resetCamera		; $4391

	xor a			; $4394
	ld (wScreenTransitionState3),a		; $4395
	call setScreenShakeCounter		; $4398

	ld a,(wScreenTransitionDirection)		; $439b
	and $01			; $439e
	jr z,@vertical			; $43a0

@horizontal:
	ld a,$14		; $43a2
	ld (wScreenScrollCounter),a		; $43a4
	ld a,$02		; $43a7
	ld (wScreenTransitionState2),a		; $43a9
	ret			; $43ac

@vertical:
	ld a,$10		; $43ad
	ld (wScreenScrollCounter),a		; $43af
	ld a,$01		; $43b2
	ld (wScreenTransitionState2),a		; $43b4
	ret			; $43b7

; Data format:
; b0: Tile (8x8) to start the scroll at
; b1: # of tiles (8x8) to scroll through
; b2: Direction of transition (incrementing or decrementing)
; b3: Value to add to screen offset each frame

@data:
	; Large rooms
	.db  LARGE_ROOM_HEIGHT*2-1  $ff                  $ff  $fc  ;  DIR_UP
	.db  $00                    LARGE_ROOM_WIDTH*2   $01  $04  ;  DIR_RIGHT
	.db  $00                    LARGE_ROOM_HEIGHT*2  $01  $04  ;  DIR_DOWN
	.db  LARGE_ROOM_WIDTH*2-1   $ff                  $ff  $fc  ;  DIR_LEFT

	; Small rooms
	.db  SMALL_ROOM_HEIGHT*2-1  $ff                  $ff  $fc  ;  DIR_UP
	.db  $00                    SMALL_ROOM_WIDTH*2   $01  $04  ;  DIR_RIGHT
	.db  $00                    SMALL_ROOM_HEIGHT*2  $01  $04  ;  DIR_DOWN
	.db  SMALL_ROOM_WIDTH*2-1   $ff                  $ff  $fc  ;  DIR_LEFT

;;
; During a scrolling screen transition, this is called to update the screen scroll and
; Link's position.
;
; @param	cflag	Set for horizontal transition, unset for vertical
; @addr{43d8}
transitionUpdateScrollAndLinkPosition:
	ld de,wGfxRegs2.SCY		; $43d8
	ld hl,hCameraY		; $43db
	jr nc,+			; $43de

	; Horizontal transition (set de and hl to respective horizontal vars)
	inc e			; $43e0
	inc l			; $43e1
	inc l			; $43e2
+
	ld b,$00		; $43e3
	ld a,(wcd14)		; $43e5
	ld c,a			; $43e8
	rlca			; $43e9
	jr nc,+			; $43ea
	dec b			; $43ec
+
	; Increment/decrement SCY or SCX
	ld a,(de)		; $43ed
	add c			; $43ee
	ld (de),a		; $43ef

	; Increment/decrement hCameraY/X
	ld a,(hl)		; $43f0
	add c			; $43f1
	ldi (hl),a		; $43f2
	ld a,(hl)		; $43f3
	adc b			; $43f4
	ld (hl),a		; $43f5

	call cpLinkState0e		; $43f6
	ret z			; $43f9

	ld a,(wScreenTransitionDirection)		; $43fa
	add a			; $43fd
	ld de,@linkSpeeds		; $43fe
	call addDoubleIndexToDe		; $4401
	ld a,(wLinkObjectIndex)		; $4404
	ld h,a			; $4407
	ld l,<w1Link.y		; $4408
	ld a,(de)		; $440a
	add (hl)		; $440b
	ldi (hl),a		; $440c
	inc de			; $440d
	ld a,(de)		; $440e
	adc (hl)		; $440f
	ldi (hl),a		; $4410
	inc de			; $4411
	ld a,(de)		; $4412
	add (hl)		; $4413
	ldi (hl),a		; $4414
	inc de			; $4415
	ld a,(de)		; $4416
	adc (hl)		; $4417
	ldi (hl),a		; $4418
	ret			; $4419

; Values to add to Link's position each frame
;
; @addr{441a}
@linkSpeeds:
	.dw -$80, $00 ; DIR_UP
	.dw  $00, $60 ; DIR_RIGHT
	.dw  $80, $00 ; DIR_DOWN
	.dw  $00,-$60 ; DIR_LEFT

;;
; Wrap everything up after a scrolling screen transition.
;
; Updates Link's position after a completed screen transition, and updates his local
; respawn position.
;
; @addr{442a}
finishScrollingTransition:
	call cpLinkState0e		; $442a
	ret z			; $442d

	ld a,(wcd01)		; $442e
	swap a			; $4431
	rrca			; $4433
	ld e,a			; $4434
	ld a,(wScreenTransitionDirection)		; $4435
	add a			; $4438
	add e			; $4439
	ld de,_label_01_037@positionOffsets		; $443a
	call addAToDe		; $443d

;;
; @param	de	Pointer to 2 bytes (values to add to Link's Y/X)
; @addr{4440}
_label_01_037:
	ld a,(wLinkObjectIndex)		; $4440
	ld h,a			; $4443

	ld l,<w1Link.yh		; $4444
	ld a,(de)		; $4446
	add (hl)		; $4447
	ldi (hl),a		; $4448
	ld (wLinkLocalRespawnY),a		; $4449

	inc de			; $444c
	inc l			; $444d
	ld a,(de)		; $444e
	add (hl)		; $444f
	ld (hl),a		; $4450
	ld (wLinkLocalRespawnX),a		; $4451

	ld l,<w1Link.direction		; $4454
	ld a,(hl)		; $4456
	ld (wLinkLocalRespawnDir),a		; $4457
	srl h			; $445a
	jr nc,+			; $445c

	ld hl,wLastAnimalMountPointY		; $445e
	ld a,(wLinkLocalRespawnY)		; $4461
	ldi (hl),a		; $4464
	ld a,(wLinkLocalRespawnX)		; $4465
	ld (hl),a		; $4468
+
	xor a			; $4469
	ldh (<hCameraY),a	; $446a
	ldh (<hCameraX),a	; $446c
	ldh (<hCameraY+1),a	; $446e
	ldh (<hCameraX+1),a	; $4470

	call resetFollowingLinkObjectPosition		; $4472
	call clearObjectsWithEnabled2		; $4475

	ld a,TREE_GFXH_01		; $4478
	ld (wLoadedTreeGfxIndex),a		; $447a

	call calculateCameraPosition		; $447d
	jp updateGfxRegs2Scroll		; $4480

; Data format:
; b0: Value to add to w1Link.yh
; b1: Value to add to w1Link.xh

; @addr{4483}
@positionOffsets:
	; Large rooms
	.db LARGE_ROOM_HEIGHT*16        $00                  ; DIR_UP
	.db $00                      <(-LARGE_ROOM_WIDTH*16) ; DIR_RIGHT
	.db <(-LARGE_ROOM_HEIGHT*16)    $00                  ; DIR_DOWN
	.db $00                         LARGE_ROOM_WIDTH*16  ; DIR_LEFT

	; Small rooms
	.db SMALL_ROOM_HEIGHT*16        $00                  ; DIR_UP
	.db $00                      <(-SMALL_ROOM_WIDTH*16) ; DIR_RIGHT
	.db <(-SMALL_ROOM_HEIGHT*16)    $00                  ; DIR_DOWN
	.db $00                         SMALL_ROOM_WIDTH*16  ; DIR_LEFT

;;
; @addr{4493}
func_4493:
	ld a,(wScreenTransitionDirection)		; $4493
	ld de,@positionOffsets		; $4496
	call addDoubleIndexToDe		; $4499
	jr _label_01_037		; $449c

; @addr{449e}
@positionOffsets:
	.db $70 $00 ; DIR_UP
	.db $00 $70 ; DIR_RIGHT
	.db $90 $00 ; DIR_DOWN
	.db $00 $90 ; DIR_LEFT

;;
; Reset w2LinkWalkPath such that it's as if Link walked out from the screen's edge.
; Called after screen transitions.
;
; @addr{44a6}
resetFollowingLinkObjectPosition:
	ld a,(wFollowingLinkObject)		; $44a6
	or a			; $44a9
	ret z			; $44aa

	ld a,(w1Link.yh)		; $44ab
	ld d,a			; $44ae
	ld a,(w1Link.xh)		; $44af
	ld e,a			; $44b2

	ld a,(wScreenTransitionDirection)		; $44b3
	and $03			; $44b6
	ld c,a			; $44b8
	ld hl,@movementOffsets		; $44b9
	rst_addDoubleIndex			; $44bc

	ldi a,(hl)		; $44bd
	ldh (<hFF8D),a	; $44be
	ld a,(hl)		; $44c0
	ldh (<hFF8C),a	; $44c1

	ld a,:w2LinkWalkPath		; $44c3
	ld ($ff00+R_SVBK),a	; $44c5

	; Fill w2LinkWalkPath with the correct values to move out from the screen edge
	ld hl,w2LinkWalkPath + $2f		; $44c7
	ld b,$10		; $44ca
--
	ldh a,(<hFF8C)	; $44cc
	add e			; $44ce
	ld e,a			; $44cf
	ldd (hl),a		; $44d0
	ldh a,(<hFF8D)	; $44d1
	add d			; $44d3
	ld d,a			; $44d4
	ldd (hl),a		; $44d5
	ld a,c			; $44d6
	ldd (hl),a		; $44d7
	dec b			; $44d8
	jr nz,--		; $44d9

	xor a			; $44db
	ld ($ff00+R_SVBK),a	; $44dc

	; Initialize the object's position
	ld a,(wFollowingLinkObjectType)		; $44de
	add Object.yh			; $44e1
	ld l,a			; $44e3
	ld a,(wFollowingLinkObject)		; $44e4
	ld h,a			; $44e7
	ld (hl),d		; $44e8
	inc l			; $44e9
	inc l			; $44ea
	ld (hl),e		; $44eb

	ld a,$0f		; $44ec
	ld (wLinkPathIndex),a		; $44ee
	ret			; $44f1

@movementOffsets:
	.db $01 $00 ; DIR_UP
	.db $00 $ff ; DIR_RIGHT
	.db $ff $00 ; DIR_DOWN
	.db $00 $01 ; DIR_LEFT

;;
; State 5 substate 2: horizontal scrolling transition. Very similar to the vertical
; scrolling code below (state 5 substate 1).
;
; @addr{44fa}
_screenTransitionState5Substate2:
	ld a,(wScreenTransitionState3)		; $44fa
	rst_jumpTable		; $44fd
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

;;
; @addr{450a}
@state0:
	ld a,(wScreenOffsetX)		; $450a
	swap a			; $450d
	rlca			; $450f
	ld b,a			; $4510
	ld a,(wScreenScrollVramRow)		; $4511
	add b			; $4514
	and $1f			; $4515
	ld (wScreenScrollVramRow),a		; $4517

	ld a,$01		; $451a
	ld (wScreenTransitionState3),a		; $451c
	ret			; $451f

;;
; @addr{4520}
@state1:
	ld a,$02		; $4520
	ld (wScreenTransitionState3),a		; $4522
	jp @drawNextRow		; $4525

;;
; This state causes the actual scrolling.
;
; When this state ends, anything just outside the screen won't have been drawn yet; that's
; handled in state 3.
;
; @addr{4528}
@state2:
	scf			; $4528
	call transitionUpdateScrollAndLinkPosition		; $4529

	; Return unless aligned at the start of a tile
	ld a,(wGfxRegs2.SCX)		; $452c
	and $07			; $452f
	ret nz			; $4531

	ld a,(wScreenScrollCounter)		; $4532
	or a			; $4535
	jr nz,@drawNextRow	; $4536

	; wScreenScrollCounter has reached 0; go to state 3.

	ld hl,wScreenTransitionState3		; $4538
	inc (hl)		; $453b

	; Calculate how many more columns state 3 needs to draw
	ld a,(wMaxCameraY)		; $453c
	swap a			; $453f
	rlca			; $4541
	ld (wScreenScrollCounter),a		; $4542

	ret			; $4545

;;
; This state draws anything remaining past the edge of the screen.
;
; @addr{4546}
@state3:
	; Draw any remaining columns
	ld a,(wScreenScrollCounter)		; $4546
	or a			; $4549
	jr nz,@drawNextRow	; $454a

	; All columns drawn

	; Increment state once, then decide whether to increment it again
	ld hl,wScreenTransitionState3		; $454c
	inc (hl)		; $454f

	; Go to state 4 if wAreaUniqueGfx is nonzero, otherwise go to state 5
	ld a,(wAreaUniqueGfx)		; $4550
	or a			; $4553
	jp nz,loadUniqueGfxHeader		; $4554
	inc (hl)		; $4557
	ret			; $4558

;;
; @addr{4559}
@state4:
	; Load one entry from the unique gfx per frame
	call updateAreaUniqueGfx		; $4559
	ret c			; $455c

	; Finished loading unique gfx

	ld a,(wAreaUniqueGfx)		; $455d
	ld (wLoadedAreaUniqueGfx),a		; $4560
	xor a			; $4563
	ld (wAreaUniqueGfx),a		; $4564
;;
; @addr{4567}
@state5:
	call checkBrightenRoom		; $4567
	call updateAreaPalette		; $456a
	call setInstrumentsDisabledCounterAndScrollMode		; $456d

	; Return to _screenTransitionState2 (no active transition)
	xor a			; $4570
	ld (wScreenTransitionState2),a		; $4571
	ld (wScreenTransitionState3),a		; $4574
	ld a,$02		; $4577
	ld (wScreenTransitionState),a		; $4579

	; Update wScreenOffsetX. hCameraX will be updated after the jump below (unless
	; w1Link.state == LINK_STATE_0e?).
	ld a,(wRoomWidth)		; $457c
	add a			; $457f
	add a			; $4580
	add a			; $4581
	ld b,a			; $4582
	ld a,(wScreenTransitionDirection)		; $4583
	and $02			; $4586
	jr z,+			; $4588

	ld a,b			; $458a
	cpl			; $458b
	inc a			; $458c
	ld b,a			; $458d
+
	ld a,(wScreenOffsetX)		; $458e
	add b			; $4591
	ld (wScreenOffsetX),a		; $4592

	jp finishScrollingTransition		; $4595

;;
; @addr{4598}
@drawNextRow:
	ld a,(wScreenScrollRow)		; $4598
	ld e,a			; $459b
	call func_46ca		; $459c
	ld a,(wScreenScrollVramRow)		; $459f
	call addFunctionsToVBlankQueue		; $45a2

;;
; @addr{45a5}
incrementScreenScrollRowVars:
	ld a,(wScreenScrollRow)		; $45a5
	ld b,a			; $45a8
	ld a,(wScreenScrollDirection)		; $45a9
	ld c,a			; $45ac

	; Increment wScreenScrollRow and wScreenScrollVramRow
	add b			; $45ad
	and $1f			; $45ae
	ld (wScreenScrollRow),a		; $45b0
	ld a,(wScreenScrollVramRow)		; $45b3
	add c			; $45b6
	and $1f			; $45b7
	ld (wScreenScrollVramRow),a		; $45b9

	ld a,(wScreenScrollCounter)		; $45bc
	dec a			; $45bf
	ld (wScreenScrollCounter),a		; $45c0
	ret			; $45c3

;;
; @addr{45c4}
addFunctionsToVBlankQueue:
	ld b,a			; $45c4
	ld c,$01		; $45c5
	ld e,$60		; $45c7
	call @locFunc		; $45c9
	ld c,$00		; $45cc
	ld e,$40		; $45ce
@locFunc:
	ldh a,(<hVBlankFunctionQueueTail)	; $45d0
	ld l,a			; $45d2
	ld h,>wVBlankFunctionQueue
	ld a,(vblankRunBank4FunctionOffset)		; $45d5
	ldi (hl),a		; $45d8
	ld a,c			; $45d9
	ldi (hl),a		; $45da
	ld a,e			; $45db
	ldi (hl),a		; $45dc
	ld a,b			; $45dd
	ld de,data_0bfd		; $45de
	call addDoubleIndexToDe		; $45e1
	ld a,(de)		; $45e4
	ldi (hl),a		; $45e5
	inc de			; $45e6
	ld a,(de)		; $45e7
	ldi (hl),a		; $45e8
	ld a,l			; $45e9
	ldh (<hVBlankFunctionQueueTail),a	; $45ea
	ret			; $45ec

;;
; State 5 substate 1: vertical scrolling transition. Practically a copy of the horizontal
; transition code above.
;
; @addr{45ed}
_screenTransitionState5Substate1:
	ld a,(wScreenTransitionState3)		; $45ed
	rst_jumpTable			; $45f0
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

;;
; @addr{45fd}
@state0:
	ld a,(wScreenOffsetY)		; $45fd
	swap a			; $4600
	rlca			; $4602
	ld b,a			; $4603
	ld a,(wScreenScrollVramRow)		; $4604
	add b			; $4607
	and $1f			; $4608
	ld (wScreenScrollVramRow),a		; $460a

	ld a,$01		; $460d
	ld (wScreenTransitionState3),a		; $460f
	ret			; $4612

;;
; @addr{4613}
@state1:
	ld a,$02		; $4613
	ld (wScreenTransitionState3),a		; $4615
	jp @drawNextRow		; $4618

;;
; This state causes the actual scrolling.
;
; When this state ends, anything just outside the screen won't have been drawn yet; that's
; handled in state 3.
;
; @addr{461b}
@state2:
	xor a			; $461b
	call transitionUpdateScrollAndLinkPosition		; $461c

	; Return unless aligned at the start of a tile
	ld a,(wGfxRegs2.SCY)		; $461f
	and $07			; $4622
	ret nz			; $4624

	ld a,(wScreenScrollCounter)		; $4625
	or a			; $4628
	jr nz,@drawNextRow	; $4629

	; wScreenScrollCounter has reached 0; go to state 3.

	ld hl,wScreenTransitionState3		; $462b
	inc (hl)		; $462e

	; Calculate how many more rows state 3 needs to draw
	ld a,(wMaxCameraX)		; $462f
	swap a			; $4632
	rlca			; $4634
	ld (wScreenScrollCounter),a		; $4635

	ret			; $4638

;;
; This state draws anything remaining past the edge of the screen.
;
; @addr{4639}
@state3:
	; Draw any remaining rows
	ld a,(wScreenScrollCounter)		; $4639
	or a			; $463c
	jr nz,@drawNextRow	; $463d

	; All rows drawn

	; Increment state once, then decide whether to increment it again
	ld hl,wScreenTransitionState3		; $463f
	inc (hl)		; $4642

	; Go to state 4 if wAreaUniqueGfx is nonzero, otherwise go to state 5
	ld a,(wAreaUniqueGfx)		; $4643
	or a			; $4646
	jp nz,loadUniqueGfxHeader		; $4647
	inc (hl)		; $464a
	ret			; $464b

;;
; @addr{464c}
@state4:
	; Load one entry from the unique gfx per frame
	call updateAreaUniqueGfx		; $464c
	ret c			; $464f

	; Finished loading unique gfx

	ld a,(wAreaUniqueGfx)		; $4650
	ld (wLoadedAreaUniqueGfx),a		; $4653
	xor a			; $4656
	ld (wAreaUniqueGfx),a		; $4657
;;
; @addr{465a}
@state5:
	call checkBrightenRoom		; $465a
	call updateAreaPalette		; $465d
	call setInstrumentsDisabledCounterAndScrollMode		; $4660

	; Return to _screenTransitionState2 (no active transition)
	xor a			; $4663
	ld (wScreenTransitionState2),a		; $4664
	ld (wScreenTransitionState3),a		; $4667
	ld a,$02		; $466a
	ld (wScreenTransitionState),a		; $466c

	; Update hCameraY and wScreenOffsetY with the table below.
	; Note: The new value for hCameraY is going to get overwritten after the jump
	; (unless w1Link.state == LINK_STATE_0e?).
	ld a,(wcd01)		; $466f
	add a			; $4672
	add a			; $4673
	ld l,a			; $4674
	ld a,(wScreenTransitionDirection)		; $4675
	add l			; $4678
	ld hl,@offsetVariables		; $4679
	rst_addAToHl			; $467c

	ldi a,(hl)		; $467d
	ldh (<hCameraY),a	; $467e
	ld a,(hl)		; $4680
	ld b,a			; $4681
	ld a,(wScreenOffsetY)		; $4682
	add b			; $4685
	ld (wScreenOffsetY),a		; $4686

	jp finishScrollingTransition		; $4689

; Data format:
; b0: New value for hCameraY
; b1: Value to add to wScreenOffsetY

@offsetVariables: ; DIR_UP
	; Large rooms
	.db (LARGE_ROOM_HEIGHT-SCREEN_HEIGHT)*16   <(-LARGE_ROOM_HEIGHT*16) ; DIR_UP
	.db $00                                       LARGE_ROOM_HEIGHT*16  ; DIR_DOWN

	; Small rooms
	.db $00                                    <(-SMALL_ROOM_HEIGHT*16) ; DIR_UP
	.db $00                                       SMALL_ROOM_HEIGHT*16  ; DIR_DOWN

;;
; @addr{4694}
@drawNextRow:
	; Load tiles and attributes to wTmpVramBuffer
	ld a,(wScreenScrollRow)		; $4694
	ld e,a			; $4697
	call copyTileRowToVramBuffer		; $4698

	; DMA attributes
	ld c,$01		; $469b
	call @queueRowDmaTransfer		; $469d

	; DMA tiles
	ld c,$00		; $46a0
	call @queueRowDmaTransfer		; $46a2

	; Go to the next row
	jp incrementScreenScrollRowVars		; $46a5

;;
; @param	c	Tiles (0) or attributes (1)
; @addr{46a8}
@queueRowDmaTransfer:
	ld a,(wScreenScrollVramRow)		; $46a8
	ld b,a			; $46ab
	and $18			; $46ac
	rlca			; $46ae
	swap a			; $46af
	add $98			; $46b1
	ld d,a			; $46b3

	ld a,b			; $46b4
	and $07			; $46b5
	swap a			; $46b7
	rlca			; $46b9
	or c			; $46ba
	ld e,a			; $46bb

	ld hl,wTmpVramBuffer		; $46bc
	srl c			; $46bf
	jr nc,+			; $46c1
	ld l,<wTmpVramBuffer+$20		; $46c3
+
	; b = $01 corresponds to $20 bytes copied.
	ld b,$01		; $46c5
	jp queueDmaTransfer		; $46c7

;;
; @addr{46ca}
func_46ca:
	ld a,(wScreenOffsetY)		; $46ca
	cpl			; $46cd
	inc a			; $46ce
	rrca			; $46cf
	rrca			; $46d0
	rrca			; $46d1
	ld hl,vramBgMapTable		; $46d2
	rst_addAToHl			; $46d5
	ldi a,(hl)		; $46d6
	add e			; $46d7
	ld e,a			; $46d8
	ld a,(hl)		; $46d9
	add $40			; $46da
	ld d,a			; $46dc
	ld a,($ff00+R_SVBK)	; $46dd
	push af			; $46df
	ld a,$03		; $46e0
	ld ($ff00+R_SVBK),a	; $46e2
	push de			; $46e4
	ld hl,wTmpVramBuffer		; $46e5
	ld b,$20		; $46e8
	ld c,$dc		; $46ea
	call func_46ff		; $46ec
	pop de			; $46ef
	ld a,$04		; $46f0
	add d			; $46f2
	ld d,a			; $46f3
	ld b,$20		; $46f4
	ld c,$e0		; $46f6
	call func_46ff		; $46f8
	pop af			; $46fb
	ld ($ff00+R_SVBK),a	; $46fc
	ret			; $46fe
;;
; @addr{46ff}
func_46ff:
	ld a,(de)		; $46ff
	ldi (hl),a		; $4700
	ld a,$20		; $4701
	add e			; $4703
	ld e,a			; $4704
	ld a,d			; $4705
	adc $00			; $4706
	cp c			; $4708
	jr nz,+			; $4709
	sub $04			; $470b
+
	ld d,a			; $470d
	dec b			; $470e
	jr nz,func_46ff	; $470f
	ret			; $4711

;;
; Loads a row of tiles from w3VramTiles and w3VramAttributes into wTmpVramBuffer+$00 and
; wTmpVramBuffer+$20, respectively.
;
; @addr{4712}
copyTileRowToVramBuffer:
	; Calculate the address of the row in w3VramTiles through black magic
	ld a,(wScreenOffsetX)		; $4712
	cpl			; $4715
	inc a			; $4716
	swap a			; $4717
	rlca			; $4719
	ld c,a			; $471a
	ld a,(wScreenScrollRow)		; $471b
	rlca			; $471e
	swap a			; $471f
	ld b,a			; $4721
	and $0f			; $4722
	ld d,a			; $4724
	ld a,b			; $4725
	and $f0			; $4726
	ld e,a			; $4728
	ld hl,w3VramTiles	; $4729
	add hl,de		; $472c
	ld b,$00		; $472d
	add hl,bc		; $472f

	; Load wram bank
	ld a,($ff00+R_SVBK)	; $4730
	push af			; $4732
	ld a,:w3VramTiles		; $4733
	ld ($ff00+R_SVBK),a	; $4735

	; Copy tiles to wTmpVramBuffer+$00
	push hl			; $4737
	ld b,$20		; $4738
	ld de,wTmpVramBuffer		; $473a
	call @copyFunc		; $473d

	; Copy attributes (w3VramAttributes) to wTmpVramBuffer+$20
	pop hl			; $4740
	ld b,$20		; $4741
	ld a,h			; $4743
	add $04			; $4744
	ld h,a			; $4746
	ld de,wTmpVramBuffer+$20	; $4747
	call @copyFunc		; $474a

	pop af			; $474d
	ld ($ff00+R_SVBK),a	; $474e
	ret			; $4750

;;
; Copy bytes from a vram row; this means looping the source every $20 bytes.
;
; @param	b	Number of bytes to copy
; @param	de	Destination
; @param	hl	Source
; @addr{4751}
@copyFunc:
	ld a,(hl)		; $4751
	ld (de),a		; $4752
	inc de			; $4753
	inc l			; $4754
	ld a,l			; $4755
	and $1f			; $4756
	jr nz,+			; $4758

	ld a,l			; $475a
	sub $20			; $475b
	ld l,a			; $475d
+
	dec b			; $475e
	jr nz,@copyFunc	; $475f
	ret			; $4761

;;
; Check if the newly loaded area has a different palette than before, update accordingly
; @addr{4762}
updateAreaPalette:
	ld a,(wLoadedAreaPalette)		; $4762
	ld b,a			; $4765
	ld a,(wAreaPalette)		; $4766
	cp b			; $4769
	ret z			; $476a

	ld (wLoadedAreaPalette),a		; $476b
	jp loadPaletteHeader		; $476e

;;
; @addr{4771}
cpLinkState0e:
	ld a,(wLinkObjectIndex)		; $4771
	cp LINK_OBJECT_INDEX			; $4774
	ret nz			; $4776

	ld hl,w1Link.state		; $4777
	ld a,LINK_STATE_0e		; $477a
	cp (hl)			; $477c
	ret			; $477d

;;
; Loads w2WaveScrollValues to make the screen sway in a sine wave.
;
; @param	c	Amplitude
; @addr{477e}
initWaveScrollValues_body:
	ld a,:w2WaveScrollValues		; $477e
	ld ($ff00+R_SVBK),a	; $4780
	ld de,@sineWave		; $4782
	ld hl,w2WaveScrollValues		; $4785
--
	push hl			; $4788
	push de			; $4789
	ld a,(de)		; $478a
	call multiplyAByC		; $478b
	ld a,h			; $478e
	pop de			; $478f
	pop hl			; $4790
	ldi (hl),a		; $4791
	inc de			; $4792
	ld a,l			; $4793
	cp <w2WaveScrollValues+$20			; $4794
	jr c,--			; $4796

	ld hl,w2WaveScrollValues+$1f		; $4798
	ld de,w2WaveScrollValues+$20		; $479b
	ld b,$20		; $479e
-
	ldd a,(hl)		; $47a0
	ld (de),a		; $47a1
	inc e			; $47a2
	dec b			; $47a3
	jr nz,-			; $47a4

	ld hl,w2WaveScrollValues+$3f		; $47a6
	ld de,w2WaveScrollValues+$40		; $47a9
	ld b,$40		; $47ac
-
	ldd a,(hl)		; $47ae
	cpl			; $47af
	inc a			; $47b0
	ld (de),a		; $47b1
	inc e			; $47b2
	dec b			; $47b3
	jr nz,-			; $47b4

	xor a			; $47b6
	ld ($ff00+R_SVBK),a	; $47b7
	ret			; $47b9

@sineWave:
	.db $00 $0d $19 $26 $32 $3e $4a $56
	.db $62 $6d $79 $84 $8e $98 $a2 $ac
	.db $b5 $be $c6 $ce $d5 $dc $e2 $e7
	.db $ed $f1 $f5 $f8 $fb $fd $ff $ff

; This almost works to replace the above, just a few values are off-by-1 for some reason.
;	.dbsin 0, 31, 90/32, $100, 0


;;
; Loads wBigBuffer with the values from w2WaveScrollValues (offset based on
; wFrameCounter). The LCD interrupt will read from here when configured properly.
;
; @param	b	Affects the frequency of the wave?
; @addr{47da}
loadBigBufferScrollValues_body:
	ld a,:w2WaveScrollValues		; $47da
	ld ($ff00+R_SVBK),a	; $47dc
	ld a,(wFrameCounter)		; $47de
	and $7f			; $47e1
	ld c,a			; $47e3
	ld de,w2WaveScrollValues		; $47e4
	call addAToDe		; $47e7
	ld hl,wBigBuffer		; $47ea
--
	ld a,(de)		; $47ed
	ldi (hl),a		; $47ee
	ld a,e			; $47ef
	add b			; $47f0
	and $7f			; $47f1
	ld e,a			; $47f3
	ld a,l			; $47f4
	or a			; $47f5
	jr nz,--		; $47f6

	xor a			; $47f8
	ld ($ff00+R_SVBK),a	; $47f9
	ret			; $47fb

;;
; @addr{47fc}
func_47fc:
	call getPaletteFadeTransitionData		; $47fc
	jr c,+			; $47ff

	xor a			; $4801
	ret			; $4802
+
	scf			; $4803
	ret			; $4804

;;
; @addr{4805}
checkAndApplyPaletteFadeTransition:
	call getPaletteFadeTransitionData		; $4805
	call c,applyPaletteFadeTransitionData		; $4808
	ret			; $480b


; "getPaletteFadeTransitionData" and "applyPaletteFadeTransitionData" functions have
; differing implementations in ages and seasons.
.ifdef ROM_AGES

;;
; Check if a room has a smooth palette transition (ie. entrance to Yoll Graveyard).
;
; @param[out]	cflag	Set if the active room has palette transition data
; @param[out]	hl	Address of palette fade data (if it has one)
; @addr{480c}
getPaletteFadeTransitionData:
	; Don't do a transition in symmetry city if the tuni nut was fixed
	call checkSymmetryCityPaletteTransition		; $480c
	ret nc			; $480f

	ld a,(wActiveGroup)		; $4810
	ld hl,paletteTransitionData		; $4813
	rst_addAToHl			; $4816
	ld a,(hl)		; $4817
	rst_addAToHl			; $4818

	ld a,(wActiveRoom)		; $4819
	ld b,a			; $481c
	ld a,(wScreenTransitionDirection)		; $481d
	ld c,a			; $4820
--
	ldi a,(hl)		; $4821
	cp $ff			; $4822
	ret z			; $4824

	cp c			; $4825
	jr nz,+			; $4826

	ld a,(hl)		; $4828
	cp b			; $4829
	jr z,++			; $482a
+
	ld a,$05		; $482c
	rst_addAToHl			; $482e
	jr --			; $482f
++
	inc hl			; $4831
	scf			; $4832
	ret			; $4833

;;
; @param	hl	Address of palette fade transition data (starting at byte 2)
; @addr{4834}
applyPaletteFadeTransitionData:
	ld a,(wLoadedAreaPalette)		; $4834
	ld b,a			; $4837
	ld a,(wAreaPalette)		; $4838
	cp b			; $483b
	ret z			; $483c

	ld a,:w2ColorComponentBuffer1	; $483d
	ld ($ff00+R_SVBK),a	; $483f

	push hl			; $4841
	ldi a,(hl)		; $4842
	ld h,(hl)		; $4843
	ld l,a			; $4844
	ld de,w2ColorComponentBuffer1		; $4845
	call extractColorComponents		; $4848

	pop hl			; $484b
	inc hl			; $484c
	inc hl			; $484d
	ldi a,(hl)		; $484e
	ld h,(hl)		; $484f
	ld l,a			; $4850
	ld de,w2ColorComponentBuffer2		; $4851
	call extractColorComponents		; $4854

	xor a			; $4857
	ld ($ff00+R_SVBK),a	; $4858

	ld a,$ff		; $485a
	ld (wLoadedAreaPalette),a		; $485c
	jp startFadeBetweenTwoPalettes		; $485f

;;
; @param[out]	cflag	Set if the game should transition the palette between the symmetry
;			city exits (this gets unset when the tuni nut is replaced).
; @addr{4862}
checkSymmetryCityPaletteTransition:
	ld a,(wActiveGroup)		; $4862
	or a			; $4865
	jr nz,@ok		; $4866

	ld a,GLOBALFLAG_TUNI_NUT_PLACED		; $4868
	call checkGlobalFlag		; $486a
	jr z,@ok			; $486d

	ld a,(wActiveRoom)		; $486f
	cp $12			; $4872
	jr z,@notOk		; $4874
	cp $22			; $4876
	jr z,@notOk		; $4878
	cp $14			; $487a
	jr z,@notOk		; $487c
	cp $24			; $487e
	jr z,@notOk		; $4880
@ok:
	scf			; $4882
	ret			; $4883
@notOk:
	xor a			; $4884
	ret			; $4885


.else ; ROM_SEASONS

;;
; Check if a room has a smooth palette transition (ie. entrance to Yoll Graveyard).
;
; @param[out]	cflag	Set if the active room has palette transition data
; @param[out]	hl	Address of palette fade data (if it has one)
; @addr{480c}
getPaletteFadeTransitionData:
	ld a,(wActiveGroup)		; $47dd
	ld b,a			; $47e0
	rrca			; $47e1
	and $7f			; $47e2
	ret nz			; $47e4

	ld a,b			; $47e5
	ld hl,paletteTransitionIndexData		; $47e6
	rst_addDoubleIndex			; $47e9
	ldi a,(hl)		; $47ea
	ld h,(hl)		; $47eb
	ld l,a			; $47ec
	ld a,(wActiveRoom)		; $47ed
	ld b,a			; $47f0
--
	ldi a,(hl)		; $47f1
	ld c,a			; $47f2
	ld a,(hl)		; $47f3
	cp $ff			; $47f4
	ret z			; $47f6
	ld a,(wScreenTransitionDirection)		; $47f7
	cp (hl)			; $47fa
	jr nz,+			; $47fb
	ld a,c			; $47fd
	cp b			; $47fe
	jr z,++			; $47ff
+
	inc hl			; $4801
	inc hl			; $4802
	inc hl			; $4803
	jr --			; $4804
++
	scf			; $4806
	ret			; $4807

;;
; @param	hl	Address of palette fade transition data (starting at byte 1)
; @addr{4834}
applyPaletteFadeTransitionData:
	inc hl
	ld a,:w2ColorComponentBuffer1
	ld ($ff00+R_SVBK),a
	ldi a,(hl)
	push hl
	swap a
	rrca

	ld hl,paletteTransitionSeasonData
	rst_addAToHl
	ld a,(wRoomStateModifier)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld de,w2ColorComponentBuffer1
	call extractColorComponents

	pop hl
	ld a,(hl)
	swap a
	rrca

	ld hl,paletteTransitionSeasonData
	rst_addAToHl
	ld a,(wRoomStateModifier)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld de,w2ColorComponentBuffer2
	call extractColorComponents

	ld a,$00
	ld ($ff00+R_SVBK),a

	ld a,$ff
	ld (wLoadedAreaPalette),a
	jp startFadeBetweenTwoPalettes

.endif ; ROM_SEASONS

.include "build/data/paletteTransitions.s"


;;
; Used by Impa, Rosa when following Link.
;
; @addr{4910}
makeActiveObjectFollowLink:
	ld hl,wFollowingLinkObjectType		; $4910
	ldh a,(<hActiveObjectType)	; $4913
	ldi (hl),a		; $4915
	ldh a,(<hActiveObject)	; $4916
	ldi (hl),a		; $4918

;;
; Reset the contents of w2LinkWalkPath to equal Link's position.
;
; @addr{4919}
resetFollowingLinkPath:
	push de			; $4919
	ld a,(w1Link.direction)		; $491a
	ld c,a			; $491d
	ld a,(w1Link.yh)		; $491e
	ld d,a			; $4921
	ld a,(w1Link.xh)		; $4922
	ld e,a			; $4925

	ld a,:w2LinkWalkPath		; $4926
	ld ($ff00+R_SVBK),a	; $4928

	; Fill each entry in w2LinkWalkPath with Link's position/direction
	ld hl,w2LinkWalkPath		; $492a
	ld a,$10		; $492d
--
	ld (hl),c		; $492f
	inc l			; $4930
	ld (hl),d		; $4931
	inc l			; $4932
	ld (hl),e		; $4933
	inc l			; $4934
	dec a			; $4935
	jr nz,--		; $4936

	; Set both to 0
	ld (wLinkPathIndex),a		; $4938
	ld ($ff00+R_SVBK),a	; $493b

	; Initialize object position
	ld a,(wFollowingLinkObjectType)		; $493d
	add Object.yh			; $4940
	ld l,a			; $4942
	ld a,(wFollowingLinkObject)		; $4943
	ld h,a			; $4946
	ld (hl),d		; $4947
	inc l			; $4948
	inc l			; $4949
	ld (hl),e		; $494a

	pop de			; $494b
	ret			; $494c

;;
; Updates the "FollowingLinkObject" and w2LinkWalkPath if necessary.
;
; @addr{494d}
checkUpdateFollowingLinkObject:
	ld a,(wFollowingLinkObject)		; $494d
	or a			; $4950
	ret z			; $4951

	call @update		; $4952
	xor a			; $4955
	ld ($ff00+R_SVBK),a	; $4956
	ret			; $4958

@update:
	; Reset everything if [wLinkPathIndex] >= $80
	ld a,(wLinkPathIndex)		; $4959
	ld b,a			; $495c
	add a			; $495d
	jr c,resetFollowingLinkPath	; $495e

	; hl = w2LinkWalkPath + [wLinkPathIndex]*3
	add b			; $4960
	ld hl,w2LinkWalkPath		; $4961
	rst_addAToHl			; $4964

	ld a,(w1Link.direction)		; $4965
	ld c,a			; $4968
	ld a,(w1Link.yh)		; $4969
	ld d,a			; $496c
	ld a,(w1Link.xh)		; $496d
	ld e,a			; $4970

	ld a,:w2LinkWalkPath		; $4971
	ld ($ff00+R_SVBK),a	; $4973

	; Return if Link's position/direction has not changed
	ldi a,(hl)		; $4975
	cp c			; $4976
	jr nz,+			; $4977
	ldi a,(hl)		; $4979
	cp d			; $497a
	jr nz,+			; $497b
	ldi a,(hl)		; $497d
	cp e			; $497e
	ret z			; $497f
+
	; Increment wLinkPathIndex
	ld a,(wLinkPathIndex)		; $4980
	inc a			; $4983
	and $0f			; $4984
	ld (wLinkPathIndex),a		; $4986

	; hl = w2LinkWalkPath + [wLinkPathIndex]*3
	ld b,a			; $4989
	add a			; $498a
	add b			; $498b
	ld hl,w2LinkWalkPath		; $498c
	rst_addAToHl			; $498f

	; Load recorded position values into c/d/e while updating them with Link's new
	; position
	ld a,c			; $4990
	ld c,(hl)		; $4991
	ldi (hl),a		; $4992
	ld a,d			; $4993
	ld d,(hl)		; $4994
	ldi (hl),a		; $4995
	ld a,e			; $4996
	ld e,(hl)		; $4997
	ldi (hl),a		; $4998

	xor a			; $4999
	ld ($ff00+R_SVBK),a	; $499a

	; Update object's position
	ld a,(wFollowingLinkObject)		; $499c
	ld h,a			; $499f
	ld a,(wFollowingLinkObjectType)		; $49a0
	add Object.direction			; $49a3
	ld l,a			; $49a5
	ld (hl),c		; $49a6
	inc l			; $49a7
	inc l			; $49a8
	inc l			; $49a9
	ld (hl),d		; $49aa
	inc l			; $49ab
	inc l			; $49ac
	ld (hl),e		; $49ad
	ret			; $49ae

;;
; Clears memory from cc5c-cce9, initializes wLinkObjectIndex, focuses camera on Link...
;
; @addr{49af}
clearMemoryOnScreenReload:
	ld hl,wLinkInAir		; $49af
	ld b,wcce9-wLinkInAir		; $49b2
	call clearMemory		; $49b4

	; Initialize wLinkObjectIndex (set it to >w1Link unless it's already set to
	; >w1Companion).
	ld hl,wLinkObjectIndex		; $49b7
	ld a,>w1Companion		; $49ba
	cp (hl)			; $49bc
	jr z,+			; $49bd
	dec a			; $49bf
	ld (hl),a		; $49c0
+
	call setCameraFocusedObjectToLink		; $49c1
	call clearItems		; $49c4
	jr ++			; $49c7

;;
; @addr{49c9}
func_49c9:
	ld hl,wDisabledObjects		; $49c9
	ld b,wcce1-wDisabledObjects		; $49cc
	call clearMemory		; $49ce
++
	ld a,$ff		; $49d1
	ld (wccaa),a		; $49d3
	ret			; $49d6

;;
; Set the lower 2 bits of each object's Object.enabled to 2.
; @addr{49d7}
setObjectsEnabledTo2:
	call setInteractionsEnabledTo2		; $49d7
	call setEnemiesEnabledTo2		; $49da
	call setPartsEnabledTo2		; $49dd
	call setItemsEnabledTo2		; $49e0
	ld hl,$d000		; $49e3
	ld c,$d2		; $49e6
	jr _setObjectsEnabledTo2_hlpr		; $49e8

;;
; @addr{49ea}
setItemsEnabledTo2:
	ld hl,FIRST_ITEM_INDEX<<8 + $00		; $49ea
	ld c,$e0		; $49ed
	jr _setObjectsEnabledTo2_hlpr		; $49ef
;;
; @addr{49f1}
setInteractionsEnabledTo2:
	ld hl,$d040		; $49f1
	ld c,$e0		; $49f4
	jr _setObjectsEnabledTo2_hlpr		; $49f6
;;
; @addr{49f8}
setEnemiesEnabledTo2:
	ld hl,$d080		; $49f8
	ld c,$e0		; $49fb
	jr _setObjectsEnabledTo2_hlpr		; $49fd
;;
; @addr{49ff}
setPartsEnabledTo2:
	ld hl,$d0c0		; $49ff
	ld c,$e0		; $4a02

_setObjectsEnabledTo2_hlpr:
	ld a,(hl)		; $4a04
	and $03			; $4a05
	cp $01			; $4a07
	jr nz,+			; $4a09

	ld a,(hl)		; $4a0b
	and $fc			; $4a0c
	or $02			; $4a0e
	ld (hl),a		; $4a10
+
	inc h			; $4a11
	ld a,h			; $4a12
	cp c			; $4a13
	jr c,_setObjectsEnabledTo2_hlpr	; $4a14
	ret			; $4a16

;;
; @addr{4a17}
clearObjectsWithEnabled2:
	call clearInteractionsWithEnabled2		; $4a17
	call clearEnemiesWithEnabled2		; $4a1a
	call clearPartsWithEnabled2		; $4a1d
	call clearItemsWithEnabled2		; $4a20
	ld hl,$d000		; $4a23
	ld c,$d2		; $4a26
	jr clearObjectsWithEnabled2_hlpr		; $4a28

;;
; @addr{4a2a}
clearItemsWithEnabled2:
	ld hl,FIRST_ITEM_INDEX<<8 + $00		; $4a2a
	ld c,$e0		; $4a2d
	jr clearObjectsWithEnabled2_hlpr		; $4a2f

;;
; @addr{4a31}
clearInteractionsWithEnabled2:
	ld hl,$d040		; $4a31
	ld c,$e0		; $4a34
	jr clearObjectsWithEnabled2_hlpr		; $4a36

;;
; @addr{4a38}
clearEnemiesWithEnabled2:
	ld hl,$d080		; $4a38
	ld c,$e0		; $4a3b
	jr clearObjectsWithEnabled2_hlpr		; $4a3d

;;
; @addr{4a3f}
clearPartsWithEnabled2:
	ld hl,$d0c0		; $4a3f
	ld c,$e0		; $4a42

clearObjectsWithEnabled2_hlpr:
	ld a,(hl)		; $4a44
	and $03			; $4a45
	cp $02			; $4a47
	jr nz,+			; $4a49

	push hl			; $4a4b
	ld b,$40		; $4a4c
	call clearMemory		; $4a4e
	pop hl			; $4a51
+
	inc h			; $4a52
	ld a,h			; $4a53
	cp c			; $4a54
	jr c,clearObjectsWithEnabled2_hlpr	; $4a55
	ret			; $4a57
;;
; @addr{4a58}
playCompassSoundIfKeyInRoom:
	ld a,(wMenuDisabled)		; $4a58
	or a			; $4a5b
	ret nz			; $4a5c
	ld a,(wDungeonIndex)		; $4a5d
	cp $ff			; $4a60
	ret z			; $4a62

	ld hl,wDungeonCompasses		; $4a63
	call checkFlag		; $4a66
	ret z			; $4a69
	call getThisRoomFlags		; $4a6a
	and ROOMFLAG_ITEM		; $4a6d
	ret nz			; $4a6f

.ifdef ROM_SEASONS
	; Hardcoded to play compass sound in d5 boss key room
	ld a,(wActiveGroup)
	cp $06
	jr nz,+
	ld a,(wActiveRoom)
	cp $8b
	jr z,@playSound
+
.endif

	ld a,(wDungeonRoomProperties)		; $4a70
	and $70			; $4a73
	cp (DUNGEONROOMPROPERTY_CHEST | DUNGEONROOMPROPERTY_KEY)	; $4a75
	jr z,@playSound			; $4a77

	cp DUNGEONROOMPROPERTY_KEY		; $4a79
	ret nz			; $4a7b

@playSound:
	ld a,SND_COMPASS		; $4a7c
	jp playSound		; $4a7e

updateLinkBeingShocked:
	ld de,wIsLinkBeingShocked		; $4a81
	ld a,(de)		; $4a84
	rst_jumpTable			; $4a85
	.dw @val00
	.dw @val01
	.dw @val02

@val00:
	ret			; $4a8c

@val01:
	ld h,d			; $4a8d
	ld l,e			; $4a8e
	inc (hl)		; $4a8f
	inc l			; $4a90
	ld (hl),$2d		; $4a91
	ld a,SND_SHOCK		; $4a93
	call playSound		; $4a95
	ld hl,wDisabledObjects		; $4a98
	ld a,$21		; $4a9b
	or (hl)			; $4a9d
	ld (hl),a		; $4a9e
	ld hl,wDisableLinkCollisionsAndMenu		; $4a9f
	set 0,(hl)		; $4aa2
	jp copyW2AreaBgPalettesToW4PaletteData		; $4aa4

@val02:
	ld h,d			; $4aa7
	ld l,e			; $4aa8
	inc l			; $4aa9
	dec (hl)		; $4aaa
	jr z,++		; $4aab

	ld a,(hl)		; $4aad
	and $07			; $4aae
	ret nz			; $4ab0

	bit 3,(hl)		; $4ab1
	jp z,copyW4PaletteDataToW2AreaBgPalettes		; $4ab3

	ld a,$08		; $4ab6
	call setScreenShakeCounter		; $4ab8

	ld a,PALH_0c		; $4abb
	jp loadPaletteHeader		; $4abd
++
	xor a			; $4ac0
	ldd (hl),a		; $4ac1
	ld (hl),a		; $4ac2
	ld hl,wDisabledObjects		; $4ac3
	ld a,$de		; $4ac6
	and (hl)		; $4ac8
	ld (hl),a		; $4ac9
	ld hl,wDisableLinkCollisionsAndMenu		; $4aca
	res 0,(hl)		; $4acd
	jp copyW4PaletteDataToW2AreaBgPalettes		; $4acf

;;
; This is called when Link falls into a hole tile that goes a level down.
; @addr{4ad2}
initiateFallDownHoleWarp:
	ld a,(wDungeonFloor)		; $4ad2
	dec a			; $4ad5
	ld (wDungeonFloor),a		; $4ad6

	call getActiveRoomFromDungeonMapPosition		; $4ad9
	ld (wWarpDestIndex),a		; $4adc

	call objectGetShortPosition		; $4adf
	ld (wWarpDestPos),a		; $4ae2

	ld a,(wActiveGroup)		; $4ae5
	or $80			; $4ae8
	ld (wWarpDestGroup),a		; $4aea
	ld a,TRANSITION_DEST_FALL		; $4aed
	ld (wWarpTransition),a		; $4aef
	ld a,$03		; $4af2
	ld (wWarpTransition2),a		; $4af4
	ret			; $4af7

;;
; CUTSCENE_WARP_TO_TWINROVA_FIGHT
; @addr{4af8}
cutscene17:
	ld a,(wCutsceneState)		; $4af8
	rst_jumpTable			; $4afb
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call reloadTileMap		; $4b06
	ld a,$01		; $4b09
	ld (wCutsceneState),a		; $4b0b
	ld hl,FIRST_DYNAMIC_INTERACTION_INDEX<<8 + Interaction.enabled		; $4b0e
--
	ld l,Interaction.enabled		; $4b11
	ldi a,(hl)		; $4b13
	or a			; $4b14
	jr z,+			; $4b15

	ldi a,(hl)		; $4b17
	cp INTERACID_ZELDA			; $4b18
	jr z,++			; $4b1a
+
	inc h			; $4b1c
	ld a,h			; $4b1d
	cp $e0			; $4b1e
	jr c,--			; $4b20
++
	ld a,h			; $4b22
	ld (wGenericCutscene.cbb5),a		; $4b23
	ld a,$10		; $4b26
	ld (wGfxRegs2.LYC),a		; $4b28
	ld a,$02		; $4b2b
	ldh (<hNextLcdInterruptBehaviour),a	; $4b2d
	xor a			; $4b2f
	ld (wGenericCutscene.cbb7),a		; $4b30
	call _initWaveScrollValuesForEverySecondLine		; $4b33
	ld a,SND_ENDLESS		; $4b36
	jp playSound		; $4b38

@state1:
	ld a,$02		; $4b3b
	call loadBigBufferScrollValues		; $4b3d
	ld hl,wGenericCutscene.cbb7		; $4b40
	inc (hl)		; $4b43
	ld a,(hl)		; $4b44
	jp nz,_initWaveScrollValuesForEverySecondLine		; $4b45

	ld a,$02		; $4b48
	ld (wCutsceneState),a		; $4b4a
	ld a,$1e		; $4b4d
	ld (wGenericCutscene.cbb3),a		; $4b4f
	ret			; $4b52

@state2:
	call updateInteractionsAndDrawAllSprites		; $4b53
	ld a,$02		; $4b56
	call loadBigBufferScrollValues		; $4b58
	ld a,(wGenericCutscene.cbb4)		; $4b5b
	inc a			; $4b5e
	and $03			; $4b5f
	ld (wGenericCutscene.cbb4),a		; $4b61
	ret nz			; $4b64

	ld a,(wGenericCutscene.cbb5)		; $4b65
	ld h,a			; $4b68
	ld l,Interaction.visible		; $4b69
	ld a,(hl)		; $4b6b
	xor $80			; $4b6c
	ld (hl),a		; $4b6e
	ld a,(wGenericCutscene.cbb3)		; $4b6f
	dec a			; $4b72
	ld (wGenericCutscene.cbb3),a		; $4b73
	ret nz			; $4b76

	res 7,(hl)		; $4b77
	ld a,$14		; $4b79
	ld (wGenericCutscene.cbb4),a		; $4b7b
	ld a,$05		; $4b7e
	ld (wGenericCutscene.cbb3),a		; $4b80
	ld a,$03		; $4b83
	ld (wCutsceneState),a		; $4b85

@state3:
	call updateInteractionsAndDrawAllSprites		; $4b88
	ld a,$02		; $4b8b
	call loadBigBufferScrollValues		; $4b8d
	ld hl,wGenericCutscene.cbb4		; $4b90
	dec (hl)		; $4b93
	ret nz			; $4b94

	ld (hl),$14		; $4b95
	call fadeoutToWhite		; $4b97
	ld hl,wGenericCutscene.cbb3		; $4b9a
	dec (hl)		; $4b9d
	ret nz			; $4b9e

	ld a,$04		; $4b9f
	ld (wCutsceneState),a		; $4ba1
	ret			; $4ba4

@state4:
	ld a,$02		; $4ba5
	call loadBigBufferScrollValues		; $4ba7
	ld a,(wPaletteThread_mode)		; $4baa
	or a			; $4bad
	ret nz			; $4bae

	ld hl,@warpDestVariables		; $4baf
	call setWarpDestVariables		; $4bb2
	xor a			; $4bb5
	ld (wcc50),a		; $4bb6
	ld (wMenuDisabled),a		; $4bb9
	ld a,$03		; $4bbc
	ld (wCutsceneIndex),a		; $4bbe
	ld a,$03		; $4bc1
	ldh (<hNextLcdInterruptBehaviour),a	; $4bc3
	ld a,$01		; $4bc5
	ld (wScrollMode),a		; $4bc7
	ld a,SNDCTRL_STOPSFX		; $4bca
	call playSound		; $4bcc
	ld a,SND_FADEOUT		; $4bcf
	jp playSound		; $4bd1


.ifdef ROM_AGES

@warpDestVariables:
	.db $85 $f5 $05 $77 $00

.else; ROM_SEASONS

@warpDestVariables:
	.db $85 $9e $05 $77 $00

.endif

;;
; Calls initWaveScrollValues, then sets every other line to have a normal scroll value.
;
; @param	a	Amplitude
; @addr{4bd9}
_initWaveScrollValuesForEverySecondLine:
	call initWaveScrollValues		; $4bd9
	ld a,:w2WaveScrollValues		; $4bdc
	ld ($ff00+R_SVBK),a	; $4bde
	ld hl,w2WaveScrollValues	; $4be0
	ld b,$80		; $4be3
-
	ldh a,(<hCameraX)	; $4be5
	ldi (hl),a		; $4be7
	inc hl			; $4be8
	dec b			; $4be9
	jr nz,-			; $4bea

	xor a			; $4bec
	ld ($ff00+R_SVBK),a	; $4bed
	ret			; $4bef

;;
; CUTSCENE_15
; @addr{4bf0}
cutscene15:
	call @update		; $4bf0
	call updateStatusBar		; $4bf3
	jp updateSpecialObjectsAndInteractions		; $4bf6

@update:
	ld a,(wCutsceneState)		; $4bf9
	rst_jumpTable			; $4bfc
	.dw @state0
	.dw @state1
	.dw @state2

;;
; Unused?
; @addr{4c03}
@func_4c03:
	ld hl,wGenericCutscene.cbb4		; $4c03
	dec (hl)		; $4c06
	ret nz			; $4c07

	ld (hl),$1e		; $4c08
	ret			; $4c0a

;;
; @addr{4c0b}
@incTmpcbb3:
	ld hl,wGenericCutscene.cbb3		; $4c0b
	inc (hl)		; $4c0e
	ret			; $4c0f


@state0:
	call reloadTileMap		; $4c10
	ld a,CUTSCENE_INGAME		; $4c13
	ld (wCutsceneState),a		; $4c15
	xor a			; $4c18
	ld (wGenericCutscene.cbb3),a		; $4c19
	ld (wGenericCutscene.cbb4),a		; $4c1c
	ld (wGenericCutscene.cbb5),a		; $4c1f
	ld (wGenericCutscene.cbb6),a		; $4c22
	ret			; $4c25


@state1:
	ld a,(wGenericCutscene.cbb3)		; $4c26
	rst_jumpTable			; $4c29
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,$04		; $4c30
	ld (wGenericCutscene.cbbb),a		; $4c32
	xor a			; $4c35
	ld (wGenericCutscene.cbbc),a		; $4c36
	call @@initWaveScrollValuesInverted		; $4c39
	ld a,$10		; $4c3c
	ld (wGfxRegs2.LYC),a		; $4c3e
	ld a,$02		; $4c41
	ldh (<hNextLcdInterruptBehaviour),a	; $4c43
	jp @incTmpcbb3		; $4c45

;;
; Calls initWaveScrollValues, then inverts every other line.
;
; @param	a	Amplitude
; @addr{4c48}
@@initWaveScrollValuesInverted:
	call initWaveScrollValues		; $4c48
	ld a,:w2WaveScrollValues		; $4c4b
	ld ($ff00+R_SVBK),a	; $4c4d
	ld hl,w2WaveScrollValues		; $4c4f
	ld b,$80		; $4c52
-
	ld a,(hl)		; $4c54
	cpl			; $4c55
	inc a			; $4c56
	ldi (hl),a		; $4c57
	inc hl			; $4c58
	dec b			; $4c59
	jr nz,-			; $4c5a

	xor a			; $4c5c
	ld ($ff00+R_SVBK),a	; $4c5d
	ret			; $4c5f

@@substate1:
	ld a,(wGenericCutscene.cbbd)		; $4c60
	ld b,a			; $4c63
	ld a,(wGenericCutscene.cbbc)		; $4c64
	cp b			; $4c67
	ld (wGenericCutscene.cbbd),a		; $4c68
	call nz,@@initWaveScrollValuesInverted		; $4c6b
	ld a,(wGenericCutscene.cbbb)		; $4c6e
	jp loadBigBufferScrollValues		; $4c71

@@substate2:
	call disableLcd		; $4c74
	call clearOam		; $4c77
	xor a			; $4c7a
	ld ($ff00+R_SVBK),a	; $4c7b

	; Clear all objects except Link
	ld hl,$d040		; $4c7d
	ld bc,$e000-$d040		; $4c80
	call clearMemoryBc		; $4c83

	call clearScreenVariables		; $4c86
	call clearMemoryOnScreenReload		; $4c89
	call stopTextThread		; $4c8c
	call applyWarpDest		; $4c8f
	call loadAreaData		; $4c92
	call loadAreaGraphics		; $4c95
	call loadDungeonLayout		; $4c98
	call func_131f		; $4c9b
	call clearEnemiesKilledList		; $4c9e
	call func_5c6b		; $4ca1
	ld a,(wActiveGroup)		; $4ca4
	cp $03			; $4ca7
	jr nz,++		; $4ca9

	xor a			; $4cab
	ld (wMinimapGroup),a		; $4cac
	ld a,(wActiveRoom)		; $4caf
	cp $ab			; $4cb2
	ld a,$f7		; $4cb4
	jr z,+			; $4cb6
	ld a,$04		; $4cb8
+
	ld (wMinimapRoom),a		; $4cba
++
	call loadCommonGraphics		; $4cbd
	callab updateInteractions
	ld a,$02		; $4cc8
	call loadGfxRegisterStateIndex		; $4cca
	ld a,$10		; $4ccd
	ld (wGfxRegs2.LYC),a		; $4ccf
	ld a,$f0		; $4cd2
	ld (wGfxRegs2.SCY),a		; $4cd4
	ld a,$02		; $4cd7
	ldh (<hNextLcdInterruptBehaviour),a	; $4cd9
	ld hl,wCutsceneState		; $4cdb
	inc (hl)		; $4cde
	xor a			; $4cdf
	ld (wGenericCutscene.cbb3),a		; $4ce0
	ld (wLinkForceState),a		; $4ce3
	ld a,$08		; $4ce6
	ld (wWarpTransition),a		; $4ce8
	ld a,$81		; $4ceb
	ld (wDisabledObjects),a		; $4ced
	ret			; $4cf0


@state2:
	ld a,(wGenericCutscene.cbb3)		; $4cf1
	rst_jumpTable			; $4cf4
	.dw @state1@substate1
	.dw @@substate1

@@substate1:
	ld a,$03		; $4cf9
	ldh (<hNextLcdInterruptBehaviour),a	; $4cfb
	ld a,$c7		; $4cfd
	ld (wGfxRegs2.LYC),a		; $4cff
	xor a			; $4d02
	ld (wCutsceneIndex),a		; $4d03
	ld (wDisabledObjects),a		; $4d06
	ld (wMenuDisabled),a		; $4d09
	ld a,$01		; $4d0c
	ld (wScrollMode),a		; $4d0e
	ld a,SNDCTRL_STOPSFX		; $4d11
	jp playSound		; $4d13

;;
; CUTSCENE_FLAMES_FLICKERING
; @addr{4d16}
cutscene18:
	ld c,$00		; $4d16
	jr ++			; $4d18

;;
; CUTSCENE_TWINROVA_SACRIFICE
; @addr{4d1a}
cutscene19:
	ld c,$01		; $4d1a
++
	callab twinrovaCutsceneCaller		; $4d1c
	call func_1613		; $4d24
	jp updateAllObjects		; $4d27

.ENDS

 m_section_free "Bank_1_Data_1"

.include "build/data/dungeonData.s"
.include "data/dungeonProperties.s"
.include "data/dungeonLayouts.s"

.ends

 m_section_free "Bank_1_Code_2" NAMESPACE "bank1"

;;
; Load 8 bytes into wDungeonMapData and up to $100 bytes into w2DungeonLayout.
; @addr{564e}
loadDungeonLayout_b01:
	ld a,$02		; $564e
	ld ($ff00+R_SVBK),a	; $5650
	call clearDungeonLayout		; $5652
	ld a,(wDungeonIndex)		; $5655
	ld hl, dungeonDataTable
	rst_addDoubleIndex			; $565b
	ldi a,(hl)		; $565c
	ld h,(hl)		; $565d
	ld l,a			; $565e
	ld b,$08		; $565f
	ld de, wDungeonMapData
-
	ldi a,(hl)		; $5664
	ld (de),a		; $5665
	inc de			; $5666
	dec b			; $5667
	jr nz, -

	call findActiveRoomInDungeonLayout		; $566a
	xor a			; $566d
	call getFirstDungeonLayoutAddress		; $566e
	ld de, w2DungeonLayout
	ld a,(wDungeonNumFloors)		; $5674
	ld c,a			; $5677
@nextFloor:
	ld b,$40		; $5678
@nextByte:
	ldi a,(hl)		; $567a
	ld (de),a		; $567b
	inc de			; $567c
	dec b			; $567d
	jr nz,@nextByte		; $567e
	dec c			; $5680
	jr nz,@nextFloor	; $5681

	ld a,(wAreaFlags)		; $5683
	bit AREAFLAG_BIT_SIDESCROLL,a		; $5686
	jr nz,@end		; $5688

	ld a,(wDungeonFloor)		; $568a
	ld hl,bitTable		; $568d
	add l			; $5690
	ld l,a			; $5691
	ld b,(hl)		; $5692
	ld a,(wDungeonIndex)		; $5693
	ld hl,wDungeonVisitedFloors		; $5696
	rst_addAToHl			; $5699
	ld a,(hl)		; $569a
	or b			; $569b
	ld (hl),a		; $569c
@end:
	xor a			; $569d
	ld ($ff00+R_SVBK),a	; $569e
	jp setVisitedRoomFlag		; $56a0

;;
; @addr{56a3}
clearDungeonLayout:
	ld hl,w2DungeonLayout	; $56a3
	ld bc,$0200		; $56a6
	jp clearMemoryBc		; $56a9


.ifdef ROM_AGES
;;
; @addr{56ac}
findActiveRoomInDungeonLayoutWithPointlessBankSwitch:
	ld a,:CADDR		; $56ac
	setrombank		; $56ae
.endif

;;
; Finds the active room in the dungeon layout and sets wDungeonFloor and
; wDungeonMapPosition accordingly.
; @addr{56b3}
findActiveRoomInDungeonLayout:
	xor a			; $56b3
	call getFirstDungeonLayoutAddress		; $56b4
	ld a,(wActiveRoom)		; $56b7
	ld c,$00		; $56ba
--
	ld b,$40		; $56bc
-
	cp (hl)			; $56be
	jr z, +
	inc hl			; $56c1
	dec b			; $56c2
	jr nz, -
	inc c			; $56c5
	jr --
+
	ld a,c			; $56c8
	ld (wDungeonFloor),a		; $56c9
	ld a,$40		; $56cc
	sub b			; $56ce
	ld (wDungeonMapPosition),a		; $56cf
	ret			; $56d2

;;
; Get the address of the layout data for the first floor
; @addr{56d3}
getFirstDungeonLayoutAddress:
	ld c,a			; $56d3
	ld a,(wDungeonFirstLayout)		; $56d4
	add c			; $56d7
	call multiplyABy16		; $56d8
	ld hl,dungeonLayoutData		; $56db
	add hl,bc		; $56de
	add hl,bc		; $56df
	add hl,bc		; $56e0
	add hl,bc		; $56e1
	ret			; $56e2

;;
; @addr{56e3}
paletteFadeHandler:
	ld a,(wPaletteThread_mode)		; $56e3
	rst_jumpTable			; $56e6
	.dw _paletteFadeHandler00
	.dw _paletteFadeHandler01
	.dw _paletteFadeHandler02
	.dw _paletteFadeHandler03
	.dw _paletteFadeHandler04
	.dw _paletteFadeHandler05
	.dw _paletteFadeHandler06
	.dw _paletteFadeHandler07
	.dw _paletteFadeHandler08
	.dw _paletteFadeHandler09
	.dw _paletteFadeHandler0a
	.dw _paletteFadeHandler0b
	.dw _paletteFadeHandler0c

.ifdef ROM_AGES
	.dw _paletteFadeHandler0d
	.dw _paletteFadeHandler0e
.endif


;;
; @addr{5705}
_paletteFadeHandler09:
	call paletteThread_decCounter		; $5705
	ret nz			; $5708

;;
; Fade out to white
; @addr{5709}
_paletteFadeHandler01:
	ld a,$1f		; $5709
	ldh (<hFF8B),a	; $570b

	ld a,(wPaletteThread_speed)		; $570d
	ld c,a			; $5710
	ld a,(wPaletteThread_fadeOffset)		; $5711
	add c			; $5714
	cp $20			; $5715
	jp nc,_paletteThread_stop	; $5717

	ld (wPaletteThread_fadeOffset),a		; $571a
	ld c,a			; $571d

	; Fall through

;;
; Updates the "fading" palettes based on the "base" palettes, and copies over
; "wDirtyFadeBgPalettes" etc. to "hDirtyFadeBgPalettes", slating them for updating?
;
; @param	c	Value to add to each color component
; @param	hFF8B	Intensity of a color component after overflowing ($00 or $1f?)
; @addr{571e}
_updateFadingPalettes:
	call _paletteThread_calculateFadingPalettes		; $571e

	ld hl,wDirtyFadeBgPalettes		; $5721
	ldh a,(<hDirtyBgPalettes)	; $5724
	or (hl)			; $5726
	ldh (<hDirtyBgPalettes),a	; $5727
	inc hl			; $5729
	ldh a,(<hDirtySprPalettes)	; $572a
	or (hl)			; $572c
	ldh (<hDirtySprPalettes),a	; $572d
	inc hl			; $572f
	ldi a,(hl)		; $5730
	ldh (<hBgPaletteSources),a	; $5731
	ld a,(hl)		; $5733
	ldh (<hSprPaletteSources),a	; $5734
;;
; @addr{5736}
_paletteFadeHandler00:
	ret			; $5736

;;
; @addr{5737}
_paletteFadeHandler0a:
	call paletteThread_decCounter		; $5737
	ret nz			; $573a

;;
; Fade in from white
; @addr{573b}
_paletteFadeHandler02:
	ld a,$1f		; $573b
	ldh (<hFF8B),a	; $573d
	ld a,(wPaletteThread_speed)		; $573f
	ld c,a			; $5742
	ld a,(wPaletteThread_fadeOffset)		; $5743
	sub c			; $5746
	jr c,_paletteThread_stop	; $5747

	ld (wPaletteThread_fadeOffset),a		; $5749
	ld c,a			; $574c
	jr _updateFadingPalettes		; $574d

;;
; @addr{574f}
_paletteFadeHandler0b:
	call paletteThread_decCounter		; $574f
	ret nz			; $5752

;;
; Fade out to black
; @addr{5753}
_paletteFadeHandler03:
	xor a			; $5753
	ldh (<hFF8B),a	; $5754
	ld a,(wPaletteThread_speed)		; $5756
	ld c,a			; $5759
	ld a,(wPaletteThread_fadeOffset)		; $575a
	sub c			; $575d
	cp $e0			; $575e
	jr c,_paletteThread_stop	; $5760

	ld (wPaletteThread_fadeOffset),a		; $5762
	ld c,a			; $5765
	jr _updateFadingPalettes		; $5766

;;
; @addr{5768}
_paletteFadeHandler0c:
	call paletteThread_decCounter		; $5768
	ret nz			; $576b

;;
; Fade in from black
; @addr{576c}
_paletteFadeHandler04:
	xor a			; $576c
	ldh (<hFF8B),a	; $576d
	ld a,(wPaletteThread_speed)		; $576f
	ld c,a			; $5772
	ld a,(wPaletteThread_fadeOffset)		; $5773
	add c			; $5776
	jr c,_paletteThread_stop	; $5777

	ld (wPaletteThread_fadeOffset),a		; $5779
	ld c,a			; $577c
	jp _updateFadingPalettes		; $577d


.ifdef ROM_AGES
;;
; @param	b	"inverted" value for wPaletteThread_fadeOffset?
; @addr{5780}
_paletteThread_setFadeOffsetAndStop:
	ld a,b			; $5780
	sub $1f			; $5781
	ld (wPaletteThread_fadeOffset),a		; $5783
.endif

;;
; Clears some variables and stops operation (goes to mode 0).
; @addr{5786}
_paletteThread_stop:
	xor a			; $5786
	ld (wPaletteThread_updateRate),a		; $5787
	ld (wPaletteThread_mode),a		; $578a
	jp clearPaletteFadeVariables		; $578d

;;
; Like above, but also marks all palettes as dirty.
; @addr{5790}
_paletteThread_refreshPalettesAndStop:
	xor a			; $5790
	ld (wPaletteThread_updateRate),a		; $5791
	ld (wPaletteThread_mode),a		; $5794
	jp clearPaletteFadeVariablesAndRefreshPalettes		; $5797


.ifdef ROM_AGES
;;
; @addr{579a}
_paletteFadeHandler0d:
	call paletteThread_decCounter		; $579a
	ret nz			; $579d
.endif

;;
; Fade out to black, stop eventually depending on wPaletteThread_parameter
; @addr{579e}
_paletteFadeHandler05:

.ifdef ROM_AGES
	xor a			; $579e
	ldh (<hFF8B),a	; $579f
	ld a,(wPaletteThread_speed)		; $57a1
	ld c,a			; $57a4
	ld a,(wPaletteThread_parameter)		; $57a5
	dec a			; $57a8
	ld b,a			; $57a9
	ld a,(wPaletteThread_fadeOffset)		; $57aa
	sub c			; $57ad
	cp b			; $57ae
	jr z,_paletteThread_stop	; $57af
	jr c,_paletteThread_stop	; $57b1

	ld (wPaletteThread_fadeOffset),a		; $57b3
	ld c,a			; $57b6
	jp _updateFadingPalettes		; $57b7

.else ; ROM_SEASONS

	xor a			; $55fc
	ldh (<hFF8B),a	; $55fd
	ld a,(wPaletteThread_parameter)		; $55ff
	dec a			; $5602
	ld b,a			; $5603
	ld a,(wPaletteThread_fadeOffset)		; $5604
	dec a			; $5607
	cp b			; $5608
	jr z,_paletteThread_stop		; $5609

	ld (wPaletteThread_fadeOffset),a		; $560b
	ld c,a			; $560e
	jp _updateFadingPalettes		; $560f
.endif


.ifdef ROM_AGES
;;
; @addr{57ba}
_paletteFadeHandler0e:
	call paletteThread_decCounter		; $57ba
	ret nz			; $57bd
.endif

;;
; Fade in from black, stop eventually depending on wPaletteThread_parameter
; @addr{57be}
_paletteFadeHandler06:

.ifdef ROM_AGES
	xor a			; $57be
	ldh (<hFF8B),a	; $57bf
	ld a,(wPaletteThread_speed)		; $57c1
	ld c,a			; $57c4
	ld a,(wPaletteThread_parameter)		; $57c5
	add $1f			; $57c8
	ld b,a			; $57ca
	ld a,(wPaletteThread_fadeOffset)		; $57cb
	add $1f			; $57ce
	add c			; $57d0
	cp b			; $57d1
	jr z,_paletteThread_stop	; $57d2
	jp nc,_paletteThread_setFadeOffsetAndStop		; $57d4

	sub $1f			; $57d7
	ld (wPaletteThread_fadeOffset),a		; $57d9
	ld c,a			; $57dc
	jp _updateFadingPalettes		; $57dd

.else ; ROM_SEASONS

	xor a			; $5612
	ldh (<hFF8B),a	; $5613
	ld a,(wPaletteThread_parameter)		; $5615
	inc a			; $5618
	ld b,a			; $5619
	ld a,(wPaletteThread_fadeOffset)		; $561a
	inc a			; $561d
	cp b			; $561e
	jr z,_paletteThread_stop		; $561f

	ld (wPaletteThread_fadeOffset),a		; $5621
	ld c,a			; $5624
	jp _updateFadingPalettes		; $5625

.endif


;;
; Fade in from white for a dark room
; @addr{57e0}
_paletteFadeHandler07:
	ld a,$1f		; $57e0
	ldh (<hFF8B),a	; $57e2
	ld a,(wPaletteThread_speed)		; $57e4
	ld c,a			; $57e7
	ld a,(wPaletteThread_fadeOffset)		; $57e8
	sub c			; $57eb
	jr c,+			; $57ec

	ld (wPaletteThread_fadeOffset),a		; $57ee
	ld c,a			; $57f1
	jp _updateFadingPalettes		; $57f2
+
	; The room's completely faded in now

	ld a,$ff		; $57f5
	ldh (<hDirtyBgPalettes),a	; $57f7
	ldh (<hDirtySprPalettes),a	; $57f9

	; Check if the room should be darkened
	ld a,(wPaletteThread_parameter)		; $57fb
	or a			; $57fe
	jr z,_paletteThread_refreshPalettesAndStop	; $57ff

	ld b,a			; $5801
	xor a			; $5802
	ld (wPaletteThread_parameter),a		; $5803
	ld a,b			; $5806
	cp $f0			; $5807
	jp z,darkenRoom		; $5809
	jp darkenRoomLightly		; $580c

;;
; Fade between two palettes
; @addr{580f}
_paletteFadeHandler08:
	ld hl,wPaletteThread_fadeOffset		; $580f
	dec (hl)		; $5812
	jr z,@stop			; $5813

	; Get bits 1-4 in 'b'
	ld a,(hl)		; $5815
	rrca			; $5816
	and $0f			; $5817
	ld b,a			; $5819
	swap a			; $581a
	ldh (<hFF91),a	; $581c

	ld a,$10		; $581e
	sub b			; $5820
	swap a			; $5821
	ldh (<hFF90),a	; $5823
	ld a,(hl)		; $5825
	rrca			; $5826
	jp c,_paletteThread_mixBG234Palettes		; $5827

	call _paletteThread_mixBG567Palettes		; $582a

	; Mark BG palettes 2-7 as needing refresh
	ldh a,(<hDirtyBgPalettes)	; $582d
	or $fc			; $582f
	ldh (<hDirtyBgPalettes),a	; $5831
	ld a,$fc		; $5833
	ldh (<hBgPaletteSources),a	; $5835
	ret			; $5837

@stop:
	jp _paletteThread_stop		; $5838

;;
; Adds the given value to each color in w2AreaBgPalettes/w2AreaSprPalettes, and stores the
; result into w2FadingBgPalettes/w2FadingSprPalettes.
;
; @param	c	Value to add to each color component
; @param	hFF8B	Intensity of a color component after overflowing ($00 or $1f)
; @addr{583b}
_paletteThread_calculateFadingPalettes:
	ld hl,w2AreaBgPalettes	; $583b
	ld b,$40		; $583e

@nextColor:
	; Extract green color component
	ld e,(hl)		; $5840
	inc l			; $5841
	ld a,(hl)		; $5842
	sla e			; $5843
	rla			; $5845
	rl e			; $5846
	rla			; $5848
	rl e			; $5849
	rla			; $584b
	and $1f			; $584c

	; Add given value, check if it overflowed
	add c			; $584e
	bit 5,a			; $584f
	jr z,+			; $5851
	ldh a,(<hFF8B)	; $5853
+
	; Encode new green component into 'de'
	ld e,$00		; $5855
	srl a			; $5857
	rr e			; $5859
	rra			; $585b
	rr e			; $585c
	rra			; $585e
	rr e			; $585f
	ld d,a			; $5861

	; Extract blue color component
	ldd a,(hl)		; $5862
	rra			; $5863
	rra			; $5864
	and $1f			; $5865

	; Add given value, check if it overflowed
	add c			; $5867
	bit 5,a			; $5868
	jr z,+			; $586a
	ldh a,(<hFF8B)	; $586c
+
	; Encode new blue component into 'de'
	rlca			; $586e
	rlca			; $586f
	or d			; $5870
	ld d,a			; $5871

	; Extract red color component
	ld a,(hl)		; $5872
	and $1f			; $5873

	; Add given value, check if it overflowed
	add c			; $5875
	bit 5,a			; $5876
	jr z,+			; $5878
	ldh a,(<hFF8B)	; $587a
+
	; Store new color value into w2FadingBgPalettes/w2FadingSprPalettes
	or e			; $587c
	inc h			; $587d
	ldi (hl),a		; $587e
	ld (hl),d		; $587f
	inc l			; $5880
	dec h			; $5881

	dec b			; $5882
	jr nz,@nextColor		; $5883
	ret			; $5885

;;
; Mix BG2-4 palettes between w2ColorComponentBuffer1 and 2. Results go to
; w2FadingBgPalettes.
;
; Game alternates between calling this and the below function when fading between
; palettes.
;
; @addr{5886}
_paletteThread_mixBG234Palettes:
	ld hl,w2AreaBgPalettes+2*8	; $5886
	ld e,<w2ColorComponentBuffer1+$00		; $5889
	ld b,3*4		; $588b
	jr ++		; $588d

;;
; Mix BG5-7 palettes.
;
; @addr{588f}
_paletteThread_mixBG567Palettes:
	ld hl,w2AreaBgPalettes+5*8	; $588f
	ld e,<w2ColorComponentBuffer1+$24		; $5892
	ld b,3*4		; $5894
++
	ld a,:w2AreaBgPalettes		; $5896
	ld ($ff00+R_SVBK),a	; $5898

@nextColor:
	push bc			; $589a
	push hl			; $589b

	; Mix the two colors; result is stored in hl = value<<4, so we still need to
	; extract the final value we want
	call @mixColors		; $589c
	inc e			; $589f
	swap l			; $58a0
	ld a,l			; $58a2
	and $0f			; $58a3
	ld l,a			; $58a5
	ld a,h			; $58a6
	swap a			; $58a7
	or l			; $58a9
	ldh (<hFF8B),a	; $58aa

	; Mix the next component
	call @mixColors		; $58ac
	inc e			; $58af
	swap l			; $58b0
	ld a,l			; $58b2
	and $0f			; $58b3
	ld l,a			; $58b5
	ld a,h			; $58b6
	swap a			; $58b7
	or l			; $58b9
	ldh (<hFF8D),a	; $58ba

	; Mix the next component
	call @mixColors		; $58bc
	inc e			; $58bf
	swap l			; $58c0
	ld a,l			; $58c2
	and $0f			; $58c3
	ld l,a			; $58c5
	ld a,h			; $58c6
	swap a			; $58c7
	or l			; $58c9
	ldh (<hFF8C),a	; $58ca

	; Write the color components to the corresponding color
	pop hl			; $58cc
	call @writeToFadingBgPalettes		; $58cd

	pop bc			; $58d0
	dec b			; $58d1
	jr nz,@nextColor		; $58d2

	xor a			; $58d4
	ld ($ff00+R_SVBK),a	; $58d5
	ret			; $58d7

;;
; Mixes two color components in w2ColorComponentBuffer1 and w2ColorComponentBuffer2.
;
; The "weighting" values are put into h, and l is set to 0. hl is then added to itself
; repeatedly. Every time hl overflows, the value of the color component is added to hl as
; well. This will happen up to 4 times. So, higher weighting values will cause this
; overflow to happen more often. In the end, the weighting for the color component is
; stored in bits 4-11 of hl.
;
; @param	e	Low byte of address in w2ColorComponentBuffer1/2
; @param	hFF91	Weighting for w2ColorComponentBuffer1 ($00-$f0, upper nibble)
; @param	hFF90	Weighting for w2ColorComponentBuffer2 ($00-$f0, upper nibble)
; @param[out]	hl	Shift this value right by 4 to get the final intensity to use
; @addr{58d8}
@mixColors:
	; Calculate intensity to add for first component
	ldh a,(<hFF91)	; $58d8
	ld h,a			; $58da
	ld d,>w2ColorComponentBuffer1	; $58db
	ld a,(de)		; $58dd
	ld c,a			; $58de

	ld b,$00		; $58df
	ld l,b			; $58e1
	ld a,$04		; $58e2
--
	add hl,hl		; $58e4
	jr nc,+			; $58e5
	add hl,bc		; $58e7
+
	dec a			; $58e8
	jr nz,--		; $58e9

	; Calculate intensity to add for second component
	push hl			; $58eb
	ldh a,(<hFF90)	; $58ec
	ld h,a			; $58ee
	ld d,>w2ColorComponentBuffer2		; $58ef
	ld a,(de)		; $58f1
	ld c,a			; $58f2
	ld b,$00		; $58f3
	ld l,b			; $58f5
	ld a,$04		; $58f6
--
	add hl,hl		; $58f8
	jr nc,+			; $58f9
	add hl,bc		; $58fb
+
	dec a			; $58fc
	jr nz,--		; $58fd

	; Add the two intensities together
	pop bc			; $58ff
	add hl,bc		; $5900
	ret			; $5901

;;
; Takes color components (stored in hFF8B, hFF8C, hFF8D) and writes them to
; the color in w2FadingBgPalettes.
; @addr{5902}
@writeToFadingBgPalettes:
	inc h			; $5902
	ldh a,(<hFF8B)	; $5903
	ld c,$00		; $5905
	srl a			; $5907
	rr c			; $5909
	rra			; $590b
	rr c			; $590c
	rra			; $590e
	rr c			; $590f
	ld b,a			; $5911
	ldh a,(<hFF8C)	; $5912
	or c			; $5914
	ldi (hl),a		; $5915
	ldh a,(<hFF8D)	; $5916
	rlca			; $5918
	rlca			; $5919
	or b			; $591a
	ldi (hl),a		; $591b
	dec h			; $591c
	ret			; $591d

;;
; @addr{591e}
checkLockBG7Color3ToBlack:
	ld a,(wLockBG7Color3ToBlack)		; $591e
	rst_jumpTable			; $5921
	.dw @thing0
	.dw @thing1

@thing1:
	xor a			; $5926
	ld (w2FadingBgPalettes+$3e),a		; $5927
	ld (w2FadingBgPalettes+$3f),a		; $592a
@thing0:
	ret			; $592d

;;
; @param[out]	zflag	Set if wPaletteThread_counter reached 0
; @addr{592e}
paletteThread_decCounter:
	ld hl,wPaletteThread_counter		; $592e
	dec (hl)		; $5931
	ret nz			; $5932
	ld a,(wPaletteThread_counterRefill)		; $5933
	ld (wPaletteThread_counter),a		; $5936
	ret			; $5939

;;
; @addr{593a}
func_593a:
	call updateLinkLocalRespawnPosition		; $593a
	call loadCommonGraphics		; $593d
	ld a,$02		; $5940
	jp loadGfxRegisterStateIndex		; $5942

;;
; @addr{5945}
checkUpdateDungeonMinimap:

.ifdef ROM_AGES
	ld a,(wAreaFlags)		; $5945
	bit AREAFLAG_BIT_10,a			; $5948
	ret nz			; $594a

	bit AREAFLAG_BIT_SIDESCROLL,a			; $594b
	ret nz			; $594d

	bit AREAFLAG_BIT_OUTDOORS,a			; $594e
	jr nz,@setMinimapRoom			; $5950

	bit AREAFLAG_BIT_DUNGEON,a			; $5952
	ret z			; $5954

.else ; ROM_SEASONS

	ld a,(wActiveGroup)		; $578d
	cp $03			; $5790
	jr c,@setMinimapRoom	; $5792
	bit 1,a			; $5794
	ret nz			; $5796
	ld a,(wDungeonIndex)		; $5797
	inc a			; $579a
	ret z			; $579b
.endif

@setMinimapRoom:
	ld hl,wMinimapDungeonFloor		; $5955
	ld a,(wDungeonFloor)		; $5958
	ldd (hl),a		; $595b
	ld a,(wDungeonMapPosition)		; $595c
	ldd (hl),a		; $595f
	ld a,(wActiveRoom)		; $5960
	ldd (hl),a		; $5963
	ld a,(wActiveGroup)		; $5964
	ld c,(hl)		; $5967
	ld (hl),a		; $5968
	ret			; $5969

;;
; This function is called from the main thread.
; Runs the game for a frame.
; @addr{596a}
runGameLogic:
	ld a,(wGameState)		; $596a
	rst_jumpTable			; $596d
	.dw _initializeGame
	.dw _func_5a4f
	.dw _func_5abc
	.dw func_7b8d

;;
; Clears a lot of memory, loads common palette header $0f,
; @addr{5976}
_initializeGame:
	ld hl,wOamEnd		; $5976
	ld bc,$d000-wOamEnd	; $5979
	call clearMemoryBc		; $597c
	call clearScreenVariablesAndWramBank1		; $597f
	call initializeSeedTreeRefillData		; $5982
	ld a,PALH_0f		; $5985
	call loadPaletteHeader		; $5987

	; This code might be checking if you saved in the advance shop?
	ldh a,(<hGameboyType)	; $598a
	rlca			; $598c
	jr c,+++		; $598d
@notGbaMode:
	ld hl,wDeathRespawnBuffer.group		; $598f
	ldi a,(hl)		; $5992
	ld l,(hl)		; $5993
	ld h,a			; $5994

.ifdef ROM_AGES
	ld bc,$03fe		; $5995
.else
	ld bc,$03af
.endif
	call compareHlToBc		; $5998
	jr z,@fixRespawnForGbc	; $599b

.ifdef ROM_AGES
	ld bc,$0158		; $599d
.else
	ld bc,$00c5
.endif
	call compareHlToBc		; $59a0
	jr nz,+++		; $59a3

	ld a,(wDeathRespawnBuffer.x)		; $59a5
	cp $40			; $59a8
	jr c,+++		; $59aa
@fixRespawnForGbc:
	ld c,$03		; $59ac
	call loadDeathRespawnBufferPreset		; $59ae
+++
	ld a,(wFileIsLinkedGame)		; $59b1
	ld (wIsLinkedGame),a		; $59b4
	ld hl,wDeathRespawnBuffer		; $59b7
	ldi a,(hl)		; $59ba
	ld (wActiveGroup),a		; $59bb
	ldi a,(hl)		; $59be
	ld (wActiveRoom),a		; $59bf
	ldi a,(hl)		; $59c2
	ld (wRoomStateModifier),a		; $59c3
	ld a,$03		; $59c6
	ld (w1Link.enabled),a	; $59c8
	ldi a,(hl)		; $59cb
	ld (w1Link.direction),a		; $59cc
	ld (wLinkLocalRespawnDir),a		; $59cf
	ldi a,(hl)		; $59d2
	ld (w1Link.yh),a		; $59d3
	ld (wLinkLocalRespawnY),a		; $59d6
	ldi a,(hl)		; $59d9
	ld (w1Link.xh),a		; $59da
	ld (wLinkLocalRespawnX),a		; $59dd
	ldi a,(hl)		; $59e0
	ld (wRememberedCompanionId),a		; $59e1
	ldi a,(hl)		; $59e4
	ld (wRememberedCompanionGroup),a		; $59e5
	ldi a,(hl)		; $59e8
	ld (wRememberedCompanionRoom),a		; $59e9
	inc l			; $59ec
	inc l			; $59ed
	ldi a,(hl)		; $59ee
	ld (wRememberedCompanionY),a		; $59ef
	ldi a,(hl)		; $59f2
	ld (wRememberedCompanionX),a		; $59f3

	; Reset health if it's zero...
	ld l,<wLinkHealth	; $59f6
	ld a,(hl)		; $59f8
	or a			; $59f9
	jr z,@resetHealth	; $59fa

	; ...or negative.
	bit 7,a			; $59fc
	jr z,++			; $59fe

@resetHealth:
	; Get wLinkMaxHealth
	inc l			; $5a00
	ldd a,(hl)		; $5a01
	; Set health to wLinkMaxHealth/2 (or 3 hearts minumum)
	srl a			; $5a02
	and $fc			; $5a04
	cp $0c			; $5a06
	jr nc,++		; $5a08
	ld a,$0c		; $5a0a
++
	ld (hl),a		; $5a0c
	ld (wDisplayedHearts),a		; $5a0d
	ld a,$88		; $5a10
	ld (w1Link.invincibilityCounter),a		; $5a12

.ifdef ROM_AGES
	ld l,<wNumRupees		; $5a15
	ldi a,(hl)		; $5a17
	ld (wDisplayedRupees),a		; $5a18
	ld a,(hl)		; $5a1b
	ld (wDisplayedRupees+1),a		; $5a1c
	call loadScreenMusicAndSetRoomPack		; $5a1f

	ld a,$ff		; $5a22
	ld (wActiveMusic),a		; $5a24
	ld (wcc05),a		; $5a27

.else ; ROM_SEASONS

	ld de,w1Link.yh		; $585c
	call getShortPositionFromDE		; $585f
	ld (wWarpDestPos),a		; $5862
	call loadScreenMusicAndSetRoomPack		; $5865

	ld a,$ff		; $5868
	ld (wActiveMusic),a		; $586a
.endif

	ld a,GLOBALFLAG_PREGAME_INTRO_DONE	; $5a2a
	call checkGlobalFlag		; $5a2c
	jr nz,_func_5a60	; $5a2f

	ld a,GLOBALFLAG_3d		; $5a31
	call checkGlobalFlag		; $5a33
	jr nz,@summonLinkCutscene		; $5a36

	ld a,$02		; $5a38
	ld (wGameState),a		; $5a3a
	ld a,CUTSCENE_PREGAME_INTRO		; $5a3d
	ld (wCutsceneIndex),a		; $5a3f
	jp cutscene0d		; $5a42

; The first time the game is opened, this cutscene plays
@summonLinkCutscene:
	ld a,$03		; $5a45
	ld (wGameState),a		; $5a47
	xor a			; $5a4a
	ld (w1Link.enabled),a		; $5a4b
	ret			; $5a4e

;;
; @addr{5a4f}
_func_5a4f:
	call clearScreenVariablesAndWramBank1		; $5a4f
	call clearStaticObjects		; $5a52
	call stopTextThread		; $5a55
	ld a,$ff		; $5a58
	ld (wActiveMusic),a		; $5a5a
	call applyWarpDest		; $5a5d

;;
; @addr{5a60}
_func_5a60:
	call clearOam		; $5a60
	call initializeVramMaps		; $5a63
	call clearMemoryOnScreenReload		; $5a66
	call clearScreenVariables		; $5a69
	call clearEnemiesKilledList		; $5a6c
	call clearAllParentItems		; $5a6f
	call dropLinkHeldItem		; $5a72
	call loadScreenMusicAndSetRoomPack		; $5a75
	call loadAreaData		; $5a78
	call loadAreaGraphics		; $5a7b

.ifdef ROM_AGES
	ld a,(wLoadingRoomPack)		; $5a7e
	ld (wRoomPack),a		; $5a81
.endif
	call loadDungeonLayout		; $5a84

	ld a,$02		; $5a87
	ld (wGameState),a		; $5a89
	xor a			; $5a8c
	ld (wCutsceneIndex),a		; $5a8d
	ld (wWarpTransition2),a		; $5a90
	ld (wSwitchState),a		; $5a93
	ld (wToggleBlocksState),a		; $5a96
	ld a,$02		; $5a99
	ld (wScrollMode),a		; $5a9b
	call loadTilesetAndRoomLayout		; $5a9e
	call loadRoomCollisions		; $5aa1
	call generateVramTilesWithRoomChanges		; $5aa4
	call setEnteredWarpPosition		; $5aa7
	call initializeRoom		; $5aaa
	call checkDisplayEraOrSeasonInfo		; $5aad
	call updateGrassAnimationModifier		; $5ab0
	call checkPlayAreaMusic		; $5ab3
	call checkUpdateDungeonMinimap		; $5ab6
	jp func_593a		; $5ab9

;;
; @addr{5abc}
_func_5abc:
	ld a,(wLinkDeathTrigger)		; $5abc
	cp $ff			; $5abf
	jr nz,+			; $5ac1

	ld a,SNDCTRL_SLOW_FADEOUT		; $5ac3
	call playSound		; $5ac5
	ld a,$e7		; $5ac8
	ld (wLinkDeathTrigger),a		; $5aca
+
	ld a,(wGameOverScreenTrigger)		; $5acd
	or a			; $5ad0
	jr z,+			; $5ad1

	ld a,THREAD_0		; $5ad3
	ld bc,thread_1b10		; $5ad5
	call threadRestart		; $5ad8
	jp stubThreadStart		; $5adb
+
	ld a,(wCutsceneIndex)		; $5ade
	rst_jumpTable			; $5ae1

	.dw cutscene00
	.dw cutscene01
	.dw cutscene02
	.dw cutscene03
	.dw cutscene04
	.dw cutscene05
	.dw cutscene06
	.dw cutscene07
	.dw cutscene08
	.dw cutscene09
	.dw cutscene0a
	.dw cutscene0b
	.dw cutscene0c
	.dw cutscene0d
	.dw cutscene0e
	.dw cutscene0f
	.dw cutscene10
	.dw cutscene11
	.dw cutscene12
	.dw cutscene13
	.dw cutscene14
	.dw cutscene15
	.dw cutscene16
	.dw cutscene17
	.dw cutscene18
	.dw cutscene19

.ifdef ROM_AGES
	.dw cutscene1a
	.dw cutscene1b
	.dw cutscene1c
	.dw cutscene1d
	.dw cutscene1e
	.dw cutscene1f
	.dw cutscene20
	.dw cutscene21
.endif


;;
; Cutscene 0 = not in a cutscene; loading a room
;
; @addr{5b26}
cutscene00:
	call updateStatusBar		; $5b26
	call updateAllObjects		; $5b29
	call func_1613		; $5b2c
	ld a,(wScrollMode)		; $5b2f
	cp $01			; $5b32
	ret nz			; $5b34
	call setInstrumentsDisabledCounterAndScrollMode		; $5b35
	xor a			; $5b38
	ld (wDisableLinkCollisionsAndMenu),a		; $5b39

.ifdef ROM_AGES
	ld a,(wcc05)		; $5b3c
	bit 7,a			; $5b3f
	jr z,+			; $5b41
	ld a,$ff		; $5b43
	ld (wcc05),a		; $5b45
+
.endif

	call clearObjectsWithEnabled2		; $5b48
	call refreshObjectGfx		; $5b4b
	call setVisitedRoomFlag		; $5b4e
	call checkUpdateDungeonMinimap		; $5b51
	ld a,CUTSCENE_INGAME		; $5b54
	ld (wCutsceneIndex),a		; $5b56
	call playCompassSoundIfKeyInRoom		; $5b59

.ifdef ROM_AGES
	call updateLastToggleBlocksState		; $5b5c
	call checkInitUnderwaterWaves		; $5b5f
.endif

	jp updateGrassAnimationModifier		; $5b62

;;
; Cutscene 1 = not in a cutscene; game running normally
;
; @addr{5b65}
cutscene01:
	call func_1613		; $5b65
	call updateLinkBeingShocked		; $5b68
	call updateMenus		; $5b6b
	ret nz			; $5b6e
	; Returns if a menu is being displayed

.ifdef ROM_AGES
	call updatePirateShip		; $5b6f
	call updateAllObjects		; $5b72
	call checkUpdateUnderwaterWaves		; $5b75
	callab bank2.func_02_7a3a		; $5b78

.else; ROM_SEASONS
	call updateAllObjects
.endif

	call updateStatusBar		; $5b80

.ifdef ROM_AGES
	call checkUpdateToggleBlocks		; $5b83
.endif

	ld a,(wCutsceneTrigger)		; $5b86
	or a			; $5b89
	jp nz,func_5e3d		; $5b8a

	call func_60e9		; $5b8d
	ld a,(wWarpTransition2)		; $5b90
	or a			; $5b93
	jp nz,func_5e0e		; $5b94

.ifdef ROM_SEASONS
	ld a,(wcc4c)
	or a
	jp nz,triggerFadeoutTransition
.endif

	call getNextActiveRoom		; $5b97
	jp nc,checkEnemyAndPartCollisionsIfTextInactive		; $5b9a

.ifdef ROM_AGES
	call checkDisableUnderwaterWaves		; $5b9d
.endif
	call updateSeedTreeRefillData		; $5ba0
	ld a,$05		; $5ba3
	call addToGashaMaturity		; $5ba5
	call func_49c9		; $5ba8
	call setObjectsEnabledTo2		; $5bab
	call loadScreenMusic		; $5bae
	call loadAreaData		; $5bb1

	call checkRoomPack		; $5bb4
	jp nz,triggerFadeoutTransition		; $5bb7

.ifdef ROM_SEASONS
	call checkPlayAreaMusic
.endif
	ld a,(wActiveRoom)		; $5bba
	ld (wLoadingRoom),a		; $5bbd
	ld a,$08		; $5bc0
	ld (wScrollMode),a		; $5bc2
	lda CUTSCENE_LOADING_ROOM			; $5bc5
	ld (wCutsceneIndex),a		; $5bc6
	call loadTilesetAndRoomLayout		; $5bc9
	call loadRoomCollisions		; $5bcc
	call generateVramTilesWithRoomChanges		; $5bcf

.ifdef ROM_AGES
	call initializeRoom		; $5bd2
	jp checkPlayAreaMusic		; $5bd5
.else
	jp initializeRoom
.endif


.ifdef ROM_SEASONS

;;
; CUTSCENE_TOGGLE_BLOCKS (does nothing in Seasons)
cutscene02:
	ret
.endif


;;
; @addr{5bd8}
cutscene03:
	ld a,(wPaletteThread_mode)		; $5bd8
	or a			; $5bdb
	ret nz			; $5bdc

	call disableLcd		; $5bdd
	call clearOam		; $5be0
	call clearScreenVariablesAndWramBank1		; $5be3
	call clearMemoryOnScreenReload		; $5be6
	call stopTextThread		; $5be9
	ld a,PALH_0f		; $5bec
	call loadPaletteHeader		; $5bee
	call applyWarpDest		; $5bf1
	call loadAreaData		; $5bf4
	call loadAreaGraphics		; $5bf7
	call loadDungeonLayout		; $5bfa
	call func_131f		; $5bfd
	call reloadObjectGfx		; $5c00
	ld a,LINK_STATE_WARPING		; $5c03
	ld (wLinkForceState),a		; $5c05
	ld a,(wWarpTransition)		; $5c08
	or $80			; $5c0b
	ld (wWarpTransition),a		; $5c0d
	ld a,(wDungeonIndex)		; $5c10
	cp $ff			; $5c13
	call z,clearEnemiesKilledList		; $5c15

_func_5c18:

.ifdef ROM_AGES
	call checkUpdateDungeonMinimap		; $5c18
	ld hl,w1Companion.id		; $5c1b
	ldd a,(hl)		; $5c1e
	cp SPECIALOBJECTID_RAFT			; $5c1f
	jr nz,++			; $5c21

	bit 1,(hl)		; $5c23
	jr nz,++			; $5c25

	ld b,$40		; $5c27
	call clearMemory		; $5c29
	ld a,LINK_OBJECT_INDEX		; $5c2c
	ld (wLinkObjectIndex),a		; $5c2e
++
.endif

	ld a,(wLinkGrabState2)		; $5c31
	and $f0			; $5c34
	cp $40			; $5c36
	jr z,+			; $5c38
	call dropLinkHeldItem		; $5c3a
	call clearAllParentItems		; $5c3d
+
.ifdef ROM_AGES
	ld a,(wLoadingRoomPack)		; $5c40
	ld (wRoomPack),a		; $5c43
.endif
	call setInstrumentsDisabledCounterAndScrollMode		; $5c46
	call setEnteredWarpPosition		; $5c49
	call calculateRoomEdge		; $5c4c
	call initializeRoom		; $5c4f
	call checkDisplayEraOrSeasonInfo		; $5c52
	call checkDarkenRoomAndClearPaletteFadeState		; $5c55
	call fadeinFromWhiteToRoom		; $5c58
	call checkPlayAreaMusic		; $5c5b
	xor a			; $5c5e
	ld (wCutsceneIndex),a		; $5c5f
.ifdef ROM_AGES
	ld (wDontUpdateStatusBar),a		; $5c62
.endif
	call func_593a		; $5c65
	jp resetCamera		; $5c68

;;
; @addr{5c6b}
func_5c6b:
	call setEnteredWarpPosition		; $5c6b
	call calculateRoomEdge		; $5c6e
	call initializeRoom		; $5c71
	call checkDisplayEraOrSeasonInfo		; $5c74
	call checkDarkenRoomAndClearPaletteFadeState		; $5c77
	ld a,$02		; $5c7a
	call fadeinFromWhiteWithDelay		; $5c7c
	jp resetCamera		; $5c7f

;;
; Sets wEnteredWarpPosition to Link's position, which prevents him from activating a warp
; tile if he spawns on one.
; @addr{5c82}
setEnteredWarpPosition:
	ld de,w1Link.yh		; $5c82
	call getShortPositionFromDE		; $5c85
	ld (wEnteredWarpPosition),a		; $5c88
	ret			; $5c8b

;;
; @addr{5c8c}
cutscene04:
	ld a,(wPaletteThread_mode)		; $5c8c
	or a			; $5c8f
	ret nz			; $5c90

	call disableLcd		; $5c91
	ld a,(wWarpDestGroup)		; $5c94
	and $07			; $5c97
	ld (wActiveGroup),a		; $5c99
	ld a,(wWarpDestIndex)		; $5c9c
	ld (wActiveRoom),a		; $5c9f
	ld a,(wLinkObjectIndex)		; $5ca2
	ld h,a			; $5ca5
	ld l,<w1Link.yh		; $5ca6
	ld a,(wWarpDestPos)		; $5ca8
	call setShortPosition		; $5cab
.ifdef ROM_AGES
	call disableLcd		; $5cae
	call clearOam		; $5cb1
.endif
	jr ++			; $5cb4

;;
; @addr{5cb6}
cutscene05:
	ld a,(wPaletteThread_mode)		; $5cb6
	or a			; $5cb9
	ret nz			; $5cba

	call disableLcd		; $5cbb
	call clearOam		; $5cbe
	call _func_5cfe		; $5cc1
++
	call setInteractionsEnabledTo2		; $5cc4
	call clearObjectsWithEnabled2		; $5cc7
	call clearItems		; $5cca
	call clearEnemies		; $5ccd
	call clearParts		; $5cd0
	call clearReservedInteraction0		; $5cd3

.ifdef ROM_AGES
	ld a,(wScreenTransitionDirection)		; $5cd6
	ldh (<hFF92),a	; $5cd9
	call clearScreenVariables		; $5cdb
	ldh a,(<hFF92)	; $5cde
	ld (wScreenTransitionDirection),a		; $5ce0

.else; ROM_SEASONS
	call clearScreenVariables
.endif

	call clearMemoryOnScreenReload		; $5ce3
	call loadScreenMusicAndSetRoomPack		; $5ce6
	call loadAreaData		; $5ce9
	call loadAreaGraphics		; $5cec
	call func_131f		; $5cef
	ld de,w1Link.yh		; $5cf2
	call getShortPositionFromDE		; $5cf5
	ld (wWarpDestPos),a		; $5cf8
	jp _func_5c18		; $5cfb

;;
; @addr{5cfe}
_func_5cfe:
	ld a,(wcc4c)		; $5cfe
	or a			; $5d01
	jr z,+++			; $5d02

.ifdef ROM_SEASONS
	ld a,TILEINDEX_STUMP
	call findTileInRoom
	jr nz,@clearCompanion

	ld h,>wRoomCollisions
	dec l
	ld a,(hl)
	or a
	jr z,+
	inc l
	inc l
	ld a,(hl)
	or a
	jr z,+
	ld a,$0f
	add l
	ld l,a
	ld a,(hl)
	or a
	jr z,+
	ld a,l
	sub $20
	ld l,a
+
	ld c,l
	call convertShortToLongPosition_paramC
	ld a,b
	ld (wRememberedCompanionY),a
	ld a,c
	ld (wRememberedCompanionX),a
.endif

	ld a,(w1Companion.enabled)		; $5d04
	or a			; $5d07
	jr z,@clearCompanion			; $5d08
	ld a,(w1Companion.id)		; $5d0a
	cp SPECIALOBJECTID_MINECART			; $5d0d
	jr z,@clearCompanion			; $5d0f
	cp SPECIALOBJECTID_MAPLE			; $5d11
	jr z,@clearCompanion			; $5d13

.ifdef ROM_SEASONS
	ld hl,w1Companion.state
	xor a
	ld (hl),a
	ld l,SpecialObject.var03
	ld (hl),a

	; Set Y/X
	ld a,b
	ld l,SpecialObject.yh
	ldi (hl),a
	inc l
	ld a,c
	ldi (hl),a

	; Clear Z
	inc l
	xor a
	ld (hl),a
	jr @end
.endif

+++
	call func_4493		; $5d15
	ld a,(wLinkGrabState2)		; $5d18
	and $f0			; $5d1b
	cp $40			; $5d1d
	jr z,@end		; $5d1f

	ld a,(wLinkObjectIndex)		; $5d21
	bit 0,a			; $5d24
	jr nz,@end		; $5d26

@clearCompanion:
	xor a			; $5d28
	ld (wRememberedCompanionId),a		; $5d29

@end:
	xor a			; $5d2c
	ld (wcc4c),a		; $5d2d
	ret			; $5d30


.ifdef ROM_SEASONS

;;
; CUTSCENE_S_ONOX_FINAL_FORM
; Falling into final battle with onox (in the sidescrolling area)
cutscene13:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (wCutsceneState),a
	ld hl,wTmpcfc0+$8
	ld b,$18
	call clearMemory
	ld a,$07
	ld (wActiveGroup),a
	ld a,$ff
	ld (wActiveRoom),a
	ld a,$77
	ld (wDungeonMapPosition),a
	ld a,AREAFLAG_SIDESCROLL | AREAFLAG_DUNGEON
	ld (wAreaFlags),a

	ld a,:w2DungeonLayout
	ld ($ff00+R_SVBK),a
	ld hl,w2DungeonLayout+$3f
	ld (hl),$ff
	xor a
	ld ($ff00+R_SVBK),a

	ld a,$04
	jp fadeoutToWhiteWithDelay

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$02
	ld (wCutsceneState),a

@state2:
	call func_1613
	call updateMenus
	ret nz
	ld a,(wWarpTransition2)
	or a
	jp nz,func_5e0e

	call seasonsFunc_331b
	call seasonsFunc_34a0
	call updateStatusBar
	ld a,(wCutsceneTrigger)
	or a
	jp z,checkEnemyAndPartCollisionsIfTextInactive
	jp func_5e3d

.endif

;;
; Unused in ages?
; @addr{5d31}
_func_5d31:
	call func_1613		; $5d31
	ld a,(wWarpTransition2)		; $5d34
	or a			; $5d37
	jp nz,func_5e0e		; $5d38

	call updateStatusBar		; $5d3b
	jp updateAllObjects		; $5d3e

;;
; @addr{5d41}
func_5d41:
	call func_1613		; $5d41
	ld a,(wWarpTransition2)		; $5d44
	or a			; $5d47
	jp nz,func_5e0e		; $5d48
	jp updateAllObjects		; $5d4b


.ifdef ROM_AGES
	.include "code/ages/cutscenes.s"
.else; ROM_SEASONS
	.include "code/seasons/cutscenes.s"
.endif


.ifdef ROM_SEASONS

;;
; For some reason, Ages's version of this function is further down than Season's version.
checkDisplayEraOrSeasonInfo:
	ld a,GLOBALFLAG_S_2f
	call checkGlobalFlag
	jr z,+
	ld a,GLOBALFLAG_S_2f
	jp unsetGlobalFlag
+
	ld a,(wActiveGroup)
	or a
	ret nz
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_ERA_OR_SEASON_INFO
	ret
.endif

;;
; Called when a fadeout transition must occur between two screens.
; @addr{5e06}
triggerFadeoutTransition:
	ld a,CUTSCENE_05		; $5e06
	ld (wCutsceneIndex),a		; $5e08
	jp fadeoutToWhite		; $5e0b

;;
; @addr{5e0e}
func_5e0e:
	ld hl,wWarpTransition2		; $5e0e
	ld a,(hl)		; $5e11
	ld b,a			; $5e12
	ld (hl),$00		; $5e13
	and $0f			; $5e15
	cp $02			; $5e17
	jr nc,++		; $5e19

	ld a,$01		; $5e1b
	ld (wGameState),a		; $5e1d
	xor a			; $5e20
	ld (wCutsceneIndex),a		; $5e21
	ret			; $5e24
++
	ld a,(wLinkObjectIndex)		; $5e25
	cp $d1			; $5e28
	jr nz,+			; $5e2a
	inc b			; $5e2c
+
	ld a,b			; $5e2d
	and $0f			; $5e2e
	ld (wCutsceneIndex),a		; $5e30
	bit 7,b			; $5e33
	jp z,fadeoutToWhite		; $5e35

	ld a,$04		; $5e38
	jp fadeoutToWhiteWithDelay		; $5e3a

;;
; @addr{5e3d}
func_5e3d:
	ld a,(wCutsceneTrigger)		; $5e3d
	and $7f			; $5e40
	ld (wCutsceneIndex),a		; $5e42
	xor a			; $5e45
	ld (wCutsceneTrigger),a		; $5e46
	ld (wCutsceneState),a		; $5e49
	ret			; $5e4c

;;
; @addr{5e4d}
checkPlayAreaMusic:
	ld a, GLOBALFLAG_INTRO_DONE	; $5e4d
	call checkGlobalFlag		; $5e4f
	ret z			; $5e52

.ifdef ROM_SEASONS
	; Override subrosia music if on a date with Rosa
	ld a,GLOBALFLAG_DATING_ROSA
	call checkGlobalFlag
	jr z,+

	ld a,(wActiveMusic2)
	cp MUS_SUBROSIA
	jr nz,+
	dec a ; MUS_ROSA_DATE
	jr @setMusic
+
.endif

	ld a,(wActiveMusic)		; $5e53
	or a			; $5e56
	ret z			; $5e57

.ifdef ROM_AGES
	; Override symmetry city present music if it hasn't been restored yet
	ld a,(wActiveMusic2)		; $5e58
	cp MUS_SYMMETRY_PRESENT
	jr nz,++

	ld a,(wActiveGroup)		; $5e5f
	or a			; $5e62
	jr nz,++

	ld a,(wPresentRoomFlags+$03)		; $5e65
	bit 0,a			; $5e68
	jr nz,++

	ld a, MUS_SADNESS
	ld (wActiveMusic2),a		; $5e6e
++
.endif

	ld a,(wActiveMusic2)		; $5e71

@setMusic:
	ld hl,wActiveMusic		; $5e74
	cp (hl)			; $5e77
	ret z			; $5e78

	ld (hl),a		; $5e79
	jp playSound		; $5e7a


.ifdef ROM_AGES
;;
; Seasons has a version of this function a bit higher up.
; @addr{5e7d}
checkDisplayEraOrSeasonInfo:
	ld a,GLOBALFLAG_16		; $5e7d
	call checkGlobalFlag		; $5e7f
	jr z,+			; $5e82

	ld a,GLOBALFLAG_16		; $5e84
	jp unsetGlobalFlag		; $5e86
+
	ld a,(wSentBackByStrangeForce)		; $5e89
	dec a			; $5e8c
	ret z			; $5e8d

	ld a,(wAreaFlags)		; $5e8e
	bit AREAFLAG_BIT_10,a			; $5e91
	ret nz			; $5e93

	bit 0,a			; $5e94
	ret z			; $5e96

	call getFreeInteractionSlot		; $5e97
	ret nz			; $5e9a

	ld (hl),INTERACID_ERA_OR_SEASON_INFO		; $5e9b
	ret			; $5e9d

.endif

;;
; Updates wGrassAnimationModifier to determine what color the grass should be.
;
; In Ages, it's always $00 (green).
;
; @addr{5e9e}
updateGrassAnimationModifier:

.ifdef ROM_AGES
	ld a,$00		; $5e9e
	ld (wGrassAnimationModifier),a		; $5ea0
	ret			; $5ea3

.else; ROM_SEASONS

	ld a,(wLoadingRoomPack)
	inc a
	ld a,$00
	jr z,+
	ld a,(wRoomStateModifier)
+
	ld b,a
	ld a,(wActiveGroup)
	or a
	ld a,b
	jr z,+
	xor a
+
	ld hl,@grassAnimationValues
	rst_addAToHl
	ld a,(hl)
	ld (wGrassAnimationModifier),a
	ret

@grassAnimationValues:

.db terrainEffects.greenGrassAnimationFrame0  - terrainEffects.greenGrassAnimationFrame0
.db terrainEffects.greenGrassAnimationFrame0  - terrainEffects.greenGrassAnimationFrame0
.db terrainEffects.orangeGrassAnimationFrame0 - terrainEffects.greenGrassAnimationFrame0
.db terrainEffects.blueGrassAnimationFrame0   - terrainEffects.greenGrassAnimationFrame0

.endif


;;
; @param c Index of preset to load into wDeathRespawnBuffer
; @addr{5ea4}
loadDeathRespawnBufferPreset:
	push de			; $5ea4
	ld a,c			; $5ea5
	call multiplyABy8		; $5ea6
	ld hl,@respawnBuffers		; $5ea9
	add hl,bc		; $5eac
	ld de,wDeathRespawnBuffer-1
	ldi a,(hl)		; $5eb0
	ld b,a			; $5eb1
--
	inc de			; $5eb2
	ldi a,(hl)		; $5eb3
	sla b			; $5eb4
	jr nc,+			; $5eb6
	ld (de),a		; $5eb8
+
	jr nz,--		; $5eb9
	pop de			; $5ebb
	ret			; $5ebc

@respawnBuffers:

.ifdef ROM_AGES
	.db $fe $00 $b6 $03 $02 $48 $78 $00
	.db $fe $00 $38 $00 $02 $68 $50 $00
	.db $dc $00 $6f $ff $02 $58 $78 $ff
	.db $dc $01 $58 $ff $02 $48 $58 $ff
.else; ROM_SEASONS
	.db $fe $00 $b6 $03 $02 $48 $78 $00
	.db $fe $02 $5d $00 $02 $68 $50 $00
	.db $dc $00 $6f $ff $02 $58 $78 $ff
	.db $dc $00 $c5 $ff $02 $28 $48 $ff
.endif


.ifdef ROM_AGES

;;
; Checks room packs to see whether "fadeout" transition should occur. In Seasons this
; also deals with setting the season.
;
; Seasons puts its implementation of this function at the end of the bank.
;
; @param[out]	zflag	nz if fadeout transition should occur
; @addr{5edd}
checkRoomPack:
	ld a,(wActiveGroup)		; $5edd
	cp $02			; $5ee0
	jr c,+			; $5ee2

	xor a			; $5ee4
	ret			; $5ee5
+
	ld a,(wRoomPack)		; $5ee6
	and $7f			; $5ee9
	ld c,a			; $5eeb
	ld a,(wLoadingRoomPack)		; $5eec
	ld b,a			; $5eef
	and $7f			; $5ef0
	cp c			; $5ef2
	ret z			; $5ef3

	ld a,(wRoomPack)		; $5ef4
	ld c,a			; $5ef7
	ld a,b			; $5ef8
	ld (wRoomPack),a		; $5ef9
	or c			; $5efc
	bit 7,a			; $5efd
	ret			; $5eff
.endif

;;
; Note: this function sets the room height to be 1 higher than it should be for large
; rooms. This is probably on purpose, so objects don't disappear right away, but it's
; inconsistent.
;
; @addr{5f00}
calculateRoomEdge:
	ldbc SMALL_ROOM_HEIGHT*16, SMALL_ROOM_WIDTH*16		; $5f00
	ld a,(wRoomIsLarge)		; $5f03
	or a			; $5f06
	jr z,+			; $5f07
	ldbc (LARGE_ROOM_HEIGHT+1)*16, LARGE_ROOM_WIDTH*16		; $5f09
+
	ld hl,wRoomEdgeY		; $5f0c
	ld (hl),b		; $5f0f
	inc l			; $5f10
	ld (hl),c		; $5f11
	ret			; $5f12

;;
; Called after a screen transition, this calculates the new value for
; wActiveRoom.
; @addr{5f13}
updateActiveRoom:
	ld a,(wDungeonIndex)		; $5f13
	inc a			; $5f16
	jr nz,@dungeon

	ld a,(wScreenTransitionDirection)		; $5f19
	ld hl,@smallMapDirectionTable
	rst_addAToHl			; $5f1f
	ld a,(wActiveRoom)		; $5f20
	add (hl)		; $5f23
	jr @gotRoom
@dungeon:
	ld a,(wScreenTransitionDirection)		; $5f26
	ld hl,@largeMapDirectionTable
	rst_addAToHl			; $5f2c
	ld a,(wDungeonMapPosition)		; $5f2d
	add (hl)		; $5f30
	ld (wDungeonMapPosition),a		; $5f31
	call getActiveRoomFromDungeonMapPosition		; $5f34
@gotRoom:
	ld (wActiveRoom),a		; $5f37
	jp setVisitedRoomFlag		; $5f3a

@smallMapDirectionTable: ; $5f3d
	.db $f0 $01 $10 $ff

@largeMapDirectionTable: ; $5f41
	.db $f8 $01 $08 $ff


;;
; Will update the value of wActiveRoom according to the direction of the
; current screen transition.
;
; @param[out]	cflag	Set on success.
; @addr{5f45}
getNextActiveRoom:
	ld a,(wScrollMode)	; $5f45
	and $04
	ret z			; $5f4a
	ld a,(wActiveRoom)		; $5f4b
	ld hl,mapTransitionGroupTable
	call findRoomSpecificData		; $5f51
	jr nc,screenTransitionStandard
	rst_jumpTable			; $5f56

.ifdef ROM_AGES
	.dw screenTransitionForestScrambler
	.dw clearEyePuzzleVars
	.dw clearEyePuzzleVars
	.dw screenTransitionEyePuzzle
.else
	.dw screenTransitionLostWoods
	.dw screenTransitionSwordUpgrade
	.dw screenTransitionOnoxDungeon
	.dw screenTransitionEyePuzzle
.endif

;;
; @addr{5f5f}
screenTransitionStandard:
	call clearEyePuzzleVars		; $5f5f
	call updateActiveRoom		; $5f62
	scf			; $5f65
	ret			; $5f66

;;
; @addr{5f67}
clearEyePuzzleVars:
	xor a			; $5f67
	ld (wLostWoodsTransitionCounter1),a		; $5f68
	ld (wLostWoodsTransitionCounter2),a		; $5f6b
	ret			; $5f6e


.ifdef ROM_AGES

	mapTransitionGroupTable:
		.dw mapTransitionGroup0Data
		.dw mapTransitionGroup1Data
		.dw mapTransitionGroup2Data
		.dw mapTransitionGroup3Data
		.dw mapTransitionGroup4Data
		.dw mapTransitionGroup5Data
		.dw mapTransitionGroup6Data
		.dw mapTransitionGroup7Data

	mapTransitionGroup0Data:
		.db $70 $00 ; ForestScrambler
		.db $71 $00 ; ForestScrambler
		.db $72 $00 ; ForestScrambler
		.db $80 $00 ; ForestScrambler
		.db $81 $00 ; ForestScrambler
		.db $82 $00 ; ForestScrambler
		.db $90 $00 ; ForestScrambler
		.db $91 $00 ; ForestScrambler
		.db $92 $00 ; ForestScrambler
		.db $00

	mapTransitionGroup1Data:
	mapTransitionGroup2Data:
	mapTransitionGroup3Data:
	mapTransitionGroup4Data:
	mapTransitionGroup6Data:
	mapTransitionGroup7Data:
		.db $00

	mapTransitionGroup5Data:
		.db $f3 $03 ; EyePuzzle
		.db $00

.else; ROM_SEASONS

	mapTransitionGroupTable:
		.dw mapTransitionGroup0Data
		.dw mapTransitionGroup1Data
		.dw mapTransitionGroup2Data
		.dw mapTransitionGroup3Data
		.dw mapTransitionGroup4Data
		.dw mapTransitionGroup5Data
		.dw mapTransitionGroup6Data
		.dw mapTransitionGroup7Data

	mapTransitionGroup0Data:
		.db $40 $00 ; LostWoods
		.db $c9 $01 ; SwordUpgrade

	mapTransitionGroup1Data:
	mapTransitionGroup2Data:
	mapTransitionGroup3Data:
	mapTransitionGroup4Data:
	mapTransitionGroup6Data:
	mapTransitionGroup7Data:
		.db $00

	mapTransitionGroup5Data:
		.db $93 $02 ; OnoxDungeon
		.db $94 $02 ; OnoxDungeon
		.db $95 $02 ; OnoxDungeon
		.db $9c $03 ; EyePuzzle
		.db $00

.endif



.ifdef ROM_AGES

;;
; Forest scrambler code
; @addr{5f96}
screenTransitionForestScrambler:
	ld a, GLOBALFLAG_FOREST_UNSCRAMBLED	; $5f96
	call checkGlobalFlag		; $5f98
	jp nz,screenTransitionStandard		; $5f9b

	ld a,(wActiveRoom)		; $5f9e
	sub $70			; $5fa1
	ld b,a			; $5fa3
	and $f0			; $5fa4
	swap a			; $5fa6
	ld c,a			; $5fa8
	add a			; $5fa9
	add c			; $5faa
	ld c,a			; $5fab
	ld a,b			; $5fac
	and $0f			; $5fad
	add c			; $5faf
	add a			; $5fb0
	add a			; $5fb1
	ld b,a			; $5fb2
	ld a,(wScreenTransitionDirection)		; $5fb3
	and $03			; $5fb6
	add b			; $5fb8
	ld hl,@forestScramblerTable
	rst_addAToHl			; $5fbc
	ld a,(hl)		; $5fbd
	or a			; $5fbe
	jp z,screenTransitionStandard		; $5fbf

	ld (wActiveRoom),a		; $5fc2
	scf			; $5fc5
	ret			; $5fc6

@forestScramblerTable: ; $5fc7
	.db $00 $71 $90 $00
	.db $00 $82 $91 $80
	.db $00 $00 $92 $82
	.db $72 $82 $80 $00
	.db $80 $82 $82 $71
	.db $70 $71 $82 $71
	.db $81 $92 $00 $00
	.db $72 $91 $00 $92
	.db $82 $00 $00 $92


.else; ROM_SEASONS


;;
screenTransitionLostWoods:
	call @checkMoveNorthTransitions
	ret c
	call @checkSwordUpgradeTransitions
	ret c
	ld a,(wScreenTransitionDirection)
	dec a
	jr nz,+
	ld a,(wLostWoodsTransitionCounter1)
	cp $03
	jr nz,screenTransitionStandard
+
	ld a,$40
	ld (wActiveRoom),a
	scf
	ret

;;
; Check for the sequence of transitions needed to move north.
; @param[out]	cflag	Set if the north transition succeeded.
@checkMoveNorthTransitions:
	ld a,(wLostWoodsTransitionCounter1)
	rst_jumpTable
	.dw @transition0
	.dw @transition1
	.dw @transition2
	.dw @transition3

@transition0:
	ldbc DIR_LEFT, SEASON_WINTER

@checkTransitionForNorth:
	ld hl,wLostWoodsTransitionCounter1

; b = expected direction of transition
; c = expected season
; Increments [hl] if the above checks out, or sets it to 0 otherwise
@checkTransition:
	ld a,(wScreenTransitionDirection)
	cp b
	jr nz,@wrongWay
	ld a,(wRoomStateModifier)
	cp c
	jr nz,@wrongWay
	inc (hl)
	jr +++

@wrongWay:
	xor a
	ld (hl),a
+++
	xor a
	ret

@transition1:
	ldbc DIR_DOWN, SEASON_FALL
	jr @checkTransitionForNorth

@transition2:
	ldbc DIR_RIGHT, SEASON_SPRING
	jr @checkTransitionForNorth

@transition3:
	ldbc DIR_UP, SEASON_SUMMER
	call @checkTransitionForNorth
	ld a,(hl)
	cp $04
	ret nz
	ld (hl),$00
	ld a,$30
	ld (wActiveRoom),a
	scf
	ret

;;
; Check for the sequence of transitions needed to move west (sword upgrade).

; @param[out]	cflag	Set if the west transition succeeded.
@checkSwordUpgradeTransitions:
	ld a,(wLostWoodsTransitionCounter2)
	rst_jumpTable
	.dw @@transition0
	.dw @@transition1
	.dw @@transition2
	.dw @@transition3

@@transition0:
	ldbc DIR_LEFT, SEASON_WINTER
	ld hl,wLostWoodsTransitionCounter2
	jr @checkTransition

@@transition1:
	ldbc DIR_LEFT, SEASON_FALL
	ld hl,wLostWoodsTransitionCounter2
	jr @checkTransition

@@transition2:
	ldbc DIR_LEFT, SEASON_SPRING
	ld hl,wLostWoodsTransitionCounter2
	jr @checkTransition

@@transition3:
	ldbc DIR_LEFT, SEASON_SUMMER
	ld hl,wLostWoodsTransitionCounter2
	call @checkTransition
	ld a,(hl)
	cp $04
	ret nz

	; Success, warp to sword upgrade screen
	ld (hl),$00
	ld a,$c9
	ld (wActiveRoom),a
	scf
	ret

;;
; The sword upgrade screen is actually located where you'd expect the maku tree to be, so
; override the destination room.
screenTransitionSwordUpgrade:
	call clearEyePuzzleVars
	ld a,$40
	ld (wActiveRoom),a
	scf
	ret

;;
; Can't proceed in onox's dungeon until enemies are dead. Also, going to the left or right
; rooms always send you back near the entrance.
screenTransitionOnoxDungeon:
	ld a,(wScreenTransitionDirection)
	and $03
	rst_jumpTable
	.dw @up
	.dw @right
	.dw screenTransitionStandard ; down
	.dw @left

@up:
	call getThisRoomFlags
	and $40
	jp nz,screenTransitionStandard
	ld a,(wActiveRoom)
	ld b,a
	jr +++

@right:
	ld bc,$9834
	jr ++

@left:
	ld bc,$9632
++
	ld a,c
	ld (wDungeonMapPosition),a
+++
	ld a,b
	ld (wActiveRoom),a
	scf
	ret

.endif ; ROM_SEASONS


;;
; @addr{5feb}
screenTransitionEyePuzzle:
	ld a,(wScreenTransitionDirection)		; $5feb
	and $03			; $5fee
	ld b,a			; $5ff0
	ld a,(wcca5)		; $5ff1
	cp b			; $5ff4
	jr z, +
	call clearEyePuzzleVars		; $5ff7
	jr ++
+
	ld hl,wEyePuzzleTransitionCounter		; $5ffc
	inc (hl)		; $5fff
++
	ld a,b			; $6000
	rst_jumpTable			; $6001
	.dw @up
	.dw @rightOrLeft
	.dw screenTransitionStandard
	.dw @rightOrLeft

@up:
	ld a,(wEyePuzzleTransitionCounter)		; $600a
	cp $06			; $600d
	jr c,@rightOrLeft
	jp screenTransitionStandard		; $6011

@rightOrLeft:
	scf			; $6014
	ret			; $6015

;;
; @addr{6016}
updateSeedTreeRefillData:

.ifdef ROM_AGES
	ld a,(wAreaFlags)		; $6016
	and AREAFLAG_OUTDOORS			; $6019
	ret z			; $601b

.else; ROM_SEASONS

	ld a,(wActiveGroup)		; $5ece
	or a			; $5ed1
	ret nz			; $5ed2
.endif

	ld a,:wxSeedTreeRefillData	; $601c
	ld ($ff00+R_SVBK),a	; $601e
	ld hl,seedTreeRefillLocations
	ld b,NUM_SEED_TREES		; $6023
--
	push bc			; $6025
	ldi a,(hl)		; $6026
	ld c,a			; $6027
	ld a,(hl)		; $6028
	ld e,a			; $6029
	call _checkSeedTreeRefillIndex	; $602a
	inc hl			; $602d
	pop bc			; $602e
	dec b			; $602f
	jr nz,--

	xor a			; $6032
	ld ($ff00+R_SVBK),a	; $6033
	ret			; $6035

.include "build/data/seedTreeRefillData.s"

;;
; Season's implementation of this function is quite different. It appears that they
; originally assumed a maximum of 8 seed trees, but expanded that to 16 for Ages.
;
; @param	b	Seed tree index (actually NUM_SEED_TREES - index)
; @param	c	Screen the seed tree is on
; @param	e	Group?
; @addr{6056}
_checkSeedTreeRefillIndex:
	ld a,b			; $6056
	ldh (<hFF8D),a	; $6057

.ifdef ROM_AGES
	ld a,e			; $6059
	res 0,e			; $605a
	and $01			; $605c
	ld b,a			; $605e
	ld a,(wActiveGroup)		; $605f
	cp b			; $6062
	ld d,>wxSeedTreeRefillData	; $6063
	jr nz,+			; $6065
	ld a,(wActiveRoom)		; $6067
	cp c			; $606a
	jr z,@treeScreen	; $606b
+
	ldh a,(<hFF8D)	; $606d
	ld b,a			; $606f
	ld a,$10		; $6070
	sub b			; $6072
	push hl			; $6073
	ld hl,wSeedTreeRefilledBitset		; $6074
	call checkFlag		; $6077
	pop hl			; $607a
	ret nz			; $607b

.else ; ROM_SEASONS
	ld a,(wActiveRoom)
	cp c
	ld d,>wxSeedTreeRefillData
	jr z,@treeScreen

	ldh a,(<hFF8D)	; $5f08
	dec a			; $5f0a
	ld bc,bitTable		; $5f0b
	add c			; $5f0e
	ld c,a			; $5f0f
	ld a,(bc)		; $5f10
	ld b,a			; $5f11
	ld a,(wSeedTreeRefilledBitset)		; $5f12
	and b			; $5f15
	ret nz			; $5f16
.endif

	ld a,(wActiveRoom)		; $607c
	ld b,a			; $607f
	ld c,$08		; $6080
--
	ld a,(de)		; $6082
	or a			; $6083
	jr z,@addRoom		; $6084

	cp b			; $6086
	ret z			; $6087

	inc e			; $6088
	dec c			; $6089
	jr nz,--		; $608a

	ret			; $608c

@addRoom:
	ld a,b			; $608d
	ld (de),a		; $608e
	ret			; $608f

; This screen contains the tree we're checking
@treeScreen:

.ifdef ROM_AGES
	push hl			; $6090
	push de			; $6091
	ld c,$08		; $6092
--
	ld a,(de)		; $6094
	or a			; $6095
	jr z,+			; $6096
	inc e			; $6098
	dec c			; $6099
	jr nz,--		; $609a
	or d			; $609c
+
	jr z,+			; $609d

	ldh a,(<hFF8D)	; $609f
	ld b,a			; $60a1
	ld a,$10		; $60a2
	sub b			; $60a4
	ld hl,wSeedTreeRefilledBitset		; $60a5
	call setFlag		; $60a8
+
	; Clear the buffer... even if we didn't set the bit?
	; So visiting a tree which hasn't regrown yet will reset the counter...

	pop de			; $60ab
	ld l,e			; $60ac
	ld h,d			; $60ad
	ld b,$08		; $60ae
	call clearMemory		; $60b0
	pop hl			; $60b3
	ret			; $60b4

.else; ROM_SEASONS

	ld c,$08		; $5f2b
--
	ld a,(de)		; $5f2d
	or a			; $5f2e
	jr z,+			; $5f2f
	inc e			; $5f31
	dec c			; $5f32
	jr nz,--		; $5f33
	or d			; $5f35
+
	jr z,+			; $5f36

	ld a,b			; $5f38
	dec a			; $5f39
	ld de,bitTable		; $5f3a
	add e			; $5f3d
	ld e,a			; $5f3e
	ld a,(de)		; $5f3f
	ld d,a			; $5f40
	ld a,(wSeedTreeRefilledBitset)		; $5f41
	or d			; $5f44
	ld (wSeedTreeRefilledBitset),a		; $5f45
+
	push hl			; $5f48
	ld l,(hl)		; $5f49
	ld h,>wxSeedTreeRefillData		; $5f4a
	ld b,$08		; $5f4c
	call clearMemory		; $5f4e
	pop hl			; $5f51
	ret			; $5f52

.endif

;;
; @addr{60b5}
initializeSeedTreeRefillData:

.ifdef ROM_AGES
	ld hl,wSeedTreeRefilledBitset		; $60b5
	ld (hl),$f0		; $60b8
	inc l			; $60ba
	ld (hl),$ff		; $60bb

.else; ROM_SEASONS

	ld a,$fc		; $5f53
	ld (wSeedTreeRefilledBitset),a		; $5f55
.endif

	ld a,:wxSeedTreeRefillData		; $60bd
	ld ($ff00+R_SVBK),a	; $60bf
	ld hl,wxSeedTreeRefillData		; $60c1
	ld b,NUM_SEED_TREES*8		; $60c4
	call clearMemory		; $60c6
	xor a			; $60c9
	ld ($ff00+R_SVBK),a	; $60ca
	ret			; $60cc

;;
; @addr{60cd}
func_60cd:
	ld a,(wLinkObjectIndex)		; $60cd
	rrca			; $60d0
	ret nc			; $60d1

	ld a,(wScrollMode)		; $60d2
	and $04			; $60d5
	ret z			; $60d7

	ld a,(w1Link.state)		; $60d8
	cp LINK_STATE_WARPING			; $60db
	ret z			; $60dd

	ld a,(wTextIsActive)		; $60de
	or a			; $60e1
	ret nz			; $60e2

	call _checkScreenEdgeWarps		; $60e3
	ret nc			; $60e6
	jr _initiateScreenEdgeWarp		; $60e7

;;
; Checks for warps?
; @addr{60e9}
func_60e9:
	ld a,(wScrollMode)		; $60e9
	or a			; $60ec
	ret z			; $60ed

	call func_60cd		; $60ee
	ret c			; $60f1

	ld a,(wLinkInAir)		; $60f2
	and $7f			; $60f5
	ret nz			; $60f7

	ld a,(wWarpsDisabled)		; $60f8
	or a			; $60fb
	ret nz			; $60fc

	ld a,(w1Link.state)		; $60fd
	cp LINK_STATE_WARPING			; $6100
	ret z			; $6102

	ld a,(wTextIsActive)		; $6103
	or a			; $6106
	ret nz			; $6107

	ld a,(wcc90)		; $6108
	or a			; $610b
	ret nz			; $610c

	; Get tile (-> FF8C) and position of tile (-> FF8D) that Link is standing on
	ld hl,w1Link.yh		; $610d
	ldi a,(hl)		; $6110
	add $04			; $6111
	ld b,a			; $6113
	inc l			; $6114
	ld c,(hl)		; $6115
	call getTileAtPosition		; $6116
	ldh (<hFF8C),a	; $6119
	ld b,a			; $611b
	ld a,l			; $611c
	ldh (<hFF8D),a	; $611d

	ld a,(wScrollMode)		; $611f
	and $04			; $6122
	jr nz,+			; $6124

	call _checkStandingOnDeactivatedWarpTile		; $6126
	ret nc			; $6129
+
	ld a,$ff		; $612a
	ld (wEnteredWarpPosition),a		; $612c
	ld a,(wActiveGroup)		; $612f
	rst_jumpTable			; $6132
	.dw _checkWarpsTopDown
	.dw _checkWarpsTopDown
	.dw _checkWarpsTopDown
	.dw _checkWarpsTopDown
	.dw _checkWarpsTopDown
	.dw _checkWarpsTopDown
	.dw _checkWarpsSidescrolling
	.dw _checkWarpsSidescrolling

;;
; @param	hFF8C	Tile Link is on
; @param	hFF8D	Position of tile Link is on
; @addr{6143}
_checkWarpsTopDown:
	call _checkTileWarps		; $6143
	ret c			; $6146

	call _checkScreenEdgeWarps		; $6147
	ret nc			; $614a
	jr _initiateScreenEdgeWarp		; $614b

;;
; @param	hFF8C	Tile Link is on
; @param	hFF8D	Position of tile Link is on
; @addr{614d}
_checkWarpsSidescrolling:
	call _checkScreenEdgeWarps		; $614d
	ret nc			; $6150

	ld a,(wWarpTransition)		; $6151
	or $30			; $6154
	ld (wWarpTransition),a		; $6156
	jr _initiateWarp		; $6159

_initiateScreenEdgeWarp:
	ld a,(wWarpTransition)		; $615b
	or $10			; $615e
	ld (wWarpTransition),a		; $6160

;;
; @addr{6163}
_initiateWarp:
	ld a,$00		; $6163
	ld (wScrollMode),a		; $6165
	ld a,$1e		; $6168
	ld (wDisabledObjects),a		; $616a
	ld a,LINK_STATE_WARPING		; $616d
	ld (wLinkForceState),a		; $616f
	jr _warpInitiated		; $6172

;;
; Checks if Link is within the appropriate bounds of a warp tile to initiate a warp?
;
; So, touching the tile is not quite enough; Link needs to be close enough to the center?
;
; @param[out]	cflag	Set if Link's close enough to the tile's center.
; @addr{6174}
_checkLinkCloseEnoughToWarpTileCenter:
	ld h,LINK_OBJECT_INDEX	; $6174
	ldh a,(<hFF8D)	; $6176
	ld c,a			; $6178
	ld b,>wRoomCollisions		; $6179
	ld a,(bc)		; $617b
	or a			; $617c
	ld l,<w1Link.yh		; $617d
	jr nz,@tileSolid			; $617f

	ld b,$04		; $6181
	call @func_618f		; $6183
	ret nc			; $6186

	ld b,$00		; $6187
	ld l,<w1Link.xh		; $6189
	jr @func_618f	; $618b

@tileSolid:
	; If the tile's partially solid, change the bounds of the check (and only check
	; the Y position)?
	ld b,$02		; $618d

;;
; @param[out]	cflag
; @addr{618f}
@func_618f:
	ld a,(hl)		; $618f
	add b			; $6190
	and $0f			; $6191
	sub $04			; $6193
	cp $0a			; $6195
	ret			; $6197

;;
; @param[out]	cflag	Set to indicate a warp has occurred.
; @addr{6198}
_warpInitiated:
	ld a,$01		; $6198
	ld (wDisableLinkCollisionsAndMenu),a		; $619a
	scf			; $619d
	ret			; $619e

;;
; @param[out]	cflag	Unset to indicate no warp has occurred.
; @addr{619f}
_noWarpInitiated:
	xor a			; $619f
	ret			; $61a0

;;
; Check for warps initiated by touching certain tiles (ie. stairs).
;
; @param[out]	cflag	Set if a warp has occurred.
; @addr{61a1}
_checkTileWarps:
	ld a,(wLinkObjectIndex)		; $61a1
	ld h,a			; $61a4
	ld l,SpecialObject.zh		; $61a5
	ld a,(hl)		; $61a7
	or a			; $61a8
	ret nz			; $61a9

	ld a,(wMenuDisabled)		; $61aa
	or a			; $61ad
	jr nz,_noWarpInitiated	; $61ae

	ldh a,(<hFF8C)	; $61b0
	call checkTileIsWarpTile		; $61b2
	jr nc,_noWarpInitiated	; $61b5

.ifdef ROM_SEASONS
	dec a
	jr z,@chimney
.endif

	ld a,(wLinkGrabState)		; $61b7
	or a			; $61ba
	jr nz,_noWarpInitiated	; $61bb

	call @checkAdjacentTileIsWarpTile		; $61bd
	jr c,@checkLinkCloseEnoughToWarpTileCenter_multiTileDoor	; $61c0
	call _checkLinkCloseEnoughToWarpTileCenter		; $61c2
	jr nc,_noWarpInitiated	; $61c5

@initiateWarp:
	callab findWarpSourceAndDest		; $61c7
	jp _initiateWarp		; $61cf

.ifdef ROM_SEASONS

; Apparently, the chimney in Seasons ignores any checks for held items or proper
; centering.
@chimney:
	ld hl,w1Link.zh
	ld a,(hl)
	or a
	ret nz
	call clearAllParentItems
	call dropLinkHeldItem
	call resetLinkInvincibility
	jr @initiateWarp

.endif ; ROM_SEASONS

;;
; Checks if a tile to the left or right is a warp tile.
;
; @param[out]	cflag	Set if one of the adjacent tiles (left/right) is a warp tile
; @addr{61d2}
@checkAdjacentTileIsWarpTile:
	ldh a,(<hFF8D)	; $61d2
	inc a			; $61d4
	call @@checkIsWarpTile		; $61d5
	ret c			; $61d8

	ldh a,(<hFF8D)	; $61d9
	dec a			; $61db

@@checkIsWarpTile:
	ld c,a			; $61dc
	ld b,>wRoomLayout		; $61dd
	ld a,(bc)		; $61df
	jr checkTileIsWarpTile		; $61e0

;;
; This is similar to "_checkLinkCloseEnoughToWarpTileCenter", but this is used when there
; are multiple door tiles lined up horizontally. So, it skips the check for being close
; enough to the horizontal center of the tile.
;
; @param[out]	cflag	Set if Link is close enough to the center of the tile
@checkLinkCloseEnoughToWarpTileCenter_multiTileDoor:
	ldh a,(<hFF8D)	; $61e2
	ld c,a			; $61e4
	ld b,>wRoomCollisions		; $61e5
	ld a,(bc)		; $61e7

; Ages & Seasons have different criteria for when to change the bounds on partially-solid
; tiles...

.ifdef ROM_AGES
	or a			; $61e8
	ld b,$02		; $61e9
	jr nz,+			; $61eb
	ld b,$04		; $61ed
+
.else; ROM_SEASONS

	cp $0c
	ld b,$02
	jr z,+
	ld b,$04
+
.endif

	ld hl,w1Link.yh		; $61ef
	ld a,(hl)		; $61f2
	add b			; $61f3
	and $0f			; $61f4
	sub $04			; $61f6
	cp $0a			; $61f8
	ret nc			; $61fa
	jr @initiateWarp		; $61fb

;;
; This checks if Link is already standing on a warp tile (from entering the room) and
; prevents warps from occurring if this is the case.
;
; @param[out]	cflag	Set if the game may proceed to check for warps
; @addr{61fd}
_checkStandingOnDeactivatedWarpTile:
	scf			; $61fd
	ld a,(wEnteredWarpPosition)		; $61fe
	inc a			; $6201
	ret z			; $6202

	; Check if Link's standing on the deactivated warp tile
	ld a,(wEnteredWarpPosition)		; $6203
	ld b,a			; $6206
	ldh a,(<hFF8D)	; $6207
	cp b			; $6209
	ret z			; $620a

	; Check for 2-tile-wide doors (by checking one tile to the left)
	dec b			; $620b
	cp b			; $620c
	jr z,++			; $620d
--
	scf			; $620f
	ret			; $6210
++
	ldh a,(<hFF8C)	; $6211
	call checkTileIsWarpTile		; $6213
	jr nc,--		; $6216

	xor a			; $6218
	ret			; $6219

;;
; @param[out]	cflag	Set if warp activated
; @addr{621a}
_checkScreenEdgeWarps:
	ld a,$ff		; $621a
	ld (wTmpcec0),a		; $621c
	callab findScreenEdgeWarpSource		; $621f
	ld a,(wTmpcec0)		; $6227
	cp $ff			; $622a
	jp z,_noWarpInitiated		; $622c
	jp _warpInitiated		; $622f

;;
; @param	a	Tile index
; @param[out]	cflag	Set if this tile is a warp tile.
; @addr{6232}
checkTileIsWarpTile:
	ld hl,_warpTileTable		; $6232
	jp lookupCollisionTable		; $6235

; This is a list of tiles that initiate warps when touched.
_warpTileTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES

	@collisions0:
	@collisions4:
		.db $dc $00
		.db $dd $00
		.db $de $00
		.db $df $00
		.db $ed $00
		.db $ee $00
		.db $ef $00
		.db $00
	@collisions1:
		.db $34 $00
		.db $36 $00
		.db $44 $00
		.db $45 $00
		.db $46 $00
		.db $47 $00
		.db $af $00
		.db $00
	@collisions2:
	@collisions5:
		.db $44 $00
		.db $45 $00
		.db $46 $00
		.db $47 $00
		.db $4f $00
		.db $00
	@collisions3:
		.db $00


.else; ROM_SEASONS

	@collisions0:
		.db $e6 $00
		.db $e7 $00
		.db $e8 $00
		.db $e9 $00
		.db $ea $00
		.db $eb $01 ; Chimney gets special treatment?
		.db $ed $00
		.db $ee $00
		.db $ef $00
		.db $00
	@collisions1:
		.db $e6 $00
		.db $e7 $00
		.db $e8 $00
		.db $ed $00
		.db $ee $00
		.db $ef $00
		.db $00
	@collisions2:
		.db $ea $00
		.db $eb $00
		.db $ec $00
		.db $ed $00
		.db $e8 $00
		.db $00
	@collisions3:
		.db $34 $00
		.db $36 $00
		.db $4f $00
		.db $44 $00
		.db $45 $00
		.db $46 $00
		.db $47 $00
		.db $00
	@collisions4:
		.db $44 $00
		.db $45 $00
		.db $46 $00
		.db $47 $00
		.db $4f $00
		.db $00
	@collisions5:
		.db $00

.endif ; ROM_SEASONS


.ifdef ROM_AGES

	.include "code/ages/underwaterWaves.s"
	.include "code/ages/timewarpTileSolidityCheck.s"

.else; ROM_SEASONS

	.include "code/seasons/onoxCastleEssenceCutscene.s"

.endif ; ROM_SEASONS

.ENDS


 m_section_superfree "Bank_1_Data_2"

	.include "build/data/paletteHeaders.s"
	.include "build/data/uncmpGfxHeaders.s"
	.include "build/data/gfxHeaders.s"
	.include "build/data/tilesetHeaders.s"

.ends


 m_section_free "Bank_1_Code_3" NAMESPACE "bank1"

.ifdef ROM_AGES
;;
; @addr{7b6e}
cutscene13:
	callab func_03_6103		; $7b6e
	call func_1613		; $7b76
	jp updateAllObjects		; $7b79

;;
; @addr{7b7c}
cutscene14:
	callab func_03_6275		; $7b7c
	call func_1613		; $7b84
	call updateAllObjects		; $7b87
	jp updateStatusBar		; $7b8a

.endif

;;
; @addr{7b8d}
func_7b8d:
	call func_7b93		; $7b8d
	jp updateAllObjects		; $7b90

;;
; @addr{7b93}
func_7b93:
	ld a,(wCutsceneIndex)		; $7b93
	rst_jumpTable			; $7b96
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld hl,wCutsceneIndex		; $7b9d
	inc (hl)		; $7ba0
	call disableLcd		; $7ba1
	call clearOam		; $7ba4
	call clearMemoryOnScreenReload		; $7ba7
	call loadScreenMusicAndSetRoomPack		; $7baa
	call loadAreaData		; $7bad
	call loadAreaGraphics		; $7bb0
	call func_131f		; $7bb3
	call loadDungeonLayout		; $7bb6
	ld a,$01		; $7bb9
	ld (wScrollMode),a		; $7bbb
	call calculateRoomEdge		; $7bbe
	call updateLinkLocalRespawnPosition		; $7bc1
	call loadCommonGraphics		; $7bc4
	ld a,$02		; $7bc7
	call fadeinFromWhiteWithDelay		; $7bc9
	ld a,$02		; $7bcc
	call loadGfxRegisterStateIndex		; $7bce
	ld a,$10		; $7bd1
	ld (wGfxRegs2.LYC),a		; $7bd3
	ld a,$02		; $7bd6
	ldh (<hNextLcdInterruptBehaviour),a	; $7bd8
	ld a,SND_WARP_START		; $7bda
	call playSound		; $7bdc
	ld a,$ff		; $7bdf
	jp initWaveScrollValues		; $7be1

@state1:
	ld a,$01		; $7be4
	call loadBigBufferScrollValues		; $7be6
	ld a,(wPaletteThread_mode)		; $7be9
	or a			; $7bec
	ret nz			; $7bed

	ld hl,wCutsceneIndex		; $7bee
	inc (hl)		; $7bf1
	ld a,$81		; $7bf2
	ld (wDisabledObjects),a		; $7bf4
	ld a,$ff		; $7bf7
	ld (wGenericCutscene.cbb4),a		; $7bf9
	xor a			; $7bfc
	ld (wGenericCutscene.cbb3),a		; $7bfd
	ret			; $7c00

@state2:
	ld a,(wGenericCutscene.cbb3)		; $7c01
	rst_jumpTable			; $7c04
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01		; $7c0b
	call loadBigBufferScrollValues		; $7c0d
	ld hl,wGenericCutscene.cbb4		; $7c10
	dec (hl)		; $7c13
	dec (hl)		; $7c14
	ld a,(hl)		; $7c15
	call initWaveScrollValues		; $7c16
	ld a,(wGenericCutscene.cbb4)		; $7c19
	cp $80			; $7c1c
	ret nc			; $7c1e

	ld hl,wGenericCutscene.cbb3		; $7c1f
	inc (hl)		; $7c22
	ld a,$03		; $7c23
	ld ($d000),a		; $7c25
	ld a,LINK_STATE_WARPING		; $7c28
	ld (wLinkForceState),a		; $7c2a
	ld a,$0b		; $7c2d
	ld (wWarpTransition),a		; $7c2f
	ret			; $7c32

@substate1:
	ld a,$01		; $7c33
	call loadBigBufferScrollValues		; $7c35
	ld hl,wGenericCutscene.cbb4		; $7c38
	dec (hl)		; $7c3b
	jr z,+			; $7c3c
	dec (hl)		; $7c3e
+
	ld a,(hl)		; $7c3f
	call initWaveScrollValues		; $7c40
	ld a,(wGenericCutscene.cbb4)		; $7c43
	or a			; $7c46
	ret nz			; $7c47

	ld hl,wGenericCutscene.cbb3		; $7c48
	inc (hl)		; $7c4b
	ld a,$03		; $7c4c
	ldh (<hNextLcdInterruptBehaviour),a	; $7c4e
	ret			; $7c50

@substate2:
	ld a,$02		; $7c51
	ld (wGameState),a		; $7c53
	lda CUTSCENE_LOADING_ROOM			; $7c56
	ld (wCutsceneIndex),a		; $7c57
	ld (wDisabledObjects),a		; $7c5a
	ld a,GLOBALFLAG_PREGAME_INTRO_DONE		; $7c5d
	call setGlobalFlag		; $7c5f
	jp initializeRoom		; $7c62


.ifdef ROM_SEASONS

;;
; Checks room packs to see whether "fadeout" transition should occur, and determines
; what the season for the next room should be. Only called on normal screen transitions
; (not when warping directly into a screen).
;
; Ages's version of this function is higher up.
;
; @param[out]	zflag	nz if fadeout transition should occur
checkRoomPack:
	ld a,(wActiveGroup)		; $7dec
	or a			; $7def
	jr z,+			; $7df0
	xor a			; $7df2
	ret			; $7df3
+
	; Check for change in room pack
	ld a,(wRoomPack)		; $7df4
	ld c,a			; $7df7
	ld a,(wLoadingRoomPack)		; $7df8
	ld b,a			; $7dfb
	ld a,(wRoomPack)		; $7dfc
	cp b			; $7dff
	ret z			; $7e00

	ld c,a			; $7e01
	ld a,b			; $7e02
	ld (wRoomPack),a		; $7e03
	or a			; $7e06
	jr z,_setHoronVillageSeason	; $7e07

;;
; @param	a	Room pack value
_determineSeasonForRoomPack:
	cp $f0			; $7e09
	jr nc,_determineCompanionRegionSeason	; $7e0b

	ld a,GLOBALFLAG_S_30		; $7e0d
	call checkGlobalFlag		; $7e0f
	ld a,(wLoadingRoomPack)		; $7e12
	jr z,+			; $7e15
	and $0f			; $7e17
+
	ld hl,_roomPackSeasonTable		; $7e19
	rst_addAToHl			; $7e1c
	ld a,(hl)		; $7e1d

;;
_setSeason:
	ld (wRoomStateModifier),a		; $7e1e
	or $01			; $7e21
	ret			; $7e23


	; Unused code snipped?
	ld a,GLOBALFLAG_S_30		; $7e24
	call checkGlobalFlag		; $7e26
	ret z			; $7e29
	scf			; $7e2a
	ret			; $7e2b

;;
; Set a random season for horon village (unless it's spring).
_setHoronVillageSeason:
	ld a,GLOBALFLAG_S_30		; $7e2c
	call checkGlobalFlag		; $7e2e
	ld a,$00		; $7e31
	jr nz,_setSeason	; $7e33
	call getRandomNumber		; $7e35
	and $03			; $7e38
	jr _setSeason		; $7e3a

;;
; @param	a
_determineCompanionRegionSeason:
	cp $ff			; $7e3c
	jr z,@companionRegion	; $7e3e
	ld a,$01		; $7e40
	jr _setSeason		; $7e42

@companionRegion:
	ld a,(wAnimalCompanion)		; $7e44
	sub SPECIALOBJECTID_RICKY-1			; $7e47
	and $03			; $7e49
	ld (wRoomStateModifier),a		; $7e4b
	jr _setSeason		; $7e4e


_roomPackSeasonTable:
	.db $00 $00 $00 $00 $00 $00 $03 $00 $00 $01 $00 $00 $00 $00 $00 $00
	.db $03 $02 $01 $02 $00 $01 $03 $02 $00 $01 $00 $03 $03 $03

;;
; Similar to "checkRoomPack" function, but called after a "warp" transition (ie. exited
; building or subrosia portal).
checkRoomPackAfterWarp_body:
	ld a,GLOBALFLAG_S_30		; $7e6e
	call checkGlobalFlag		; $7e70
	ld a,(wRoomPack)		; $7e73
	jp nz,_determineSeasonForRoomPack		; $7e76

	cp $f0			; $7e79
	jp nc,_determineCompanionRegionSeason		; $7e7b

	; Horon village: don't calculate anything (season stays the same as last area)
	or a			; $7e7e
	ret z			; $7e7f

	ld hl,_roomPackSeasonTable		; $7e80
	rst_addAToHl			; $7e83
	ld a,(hl)		; $7e84
	ld (wRoomStateModifier),a		; $7e85
	ret			; $7e88



.else ; ROM_AGES

;;
; @addr{7c65}
updateLastToggleBlocksState:
	ld a,(wToggleBlocksState)		; $7c65
	ld (wLastToggleBlocksState),a		; $7c68
	ret			; $7c6b

;;
; @addr{7c6c}
checkUpdateToggleBlocks:
	call checkDungeonUsesToggleBlocks		; $7c6c
	ret z			; $7c6f

	ld a,(wToggleBlocksState)		; $7c70
	ld b,a			; $7c73
	ld a,(wLastToggleBlocksState)		; $7c74
	xor b			; $7c77
	rrca			; $7c78
	ret nc			; $7c79
	ld a,CUTSCENE_TOGGLE_BLOCKS		; $7c7a
	ld (wCutsceneTrigger),a		; $7c7c
	ret			; $7c7f

	.include "code/ages/cutscenes2.s"
	.include "code/ages/pirateShip.s"

;;
; @addr{7f15}
cutscene1f:
	callab func_03_7cb7		; $7f15
	call updateStatusBar		; $7f1d
	jp updateAllObjects		; $7f20


; Garbage data follows

.IFDEF BUILD_VANILLA

; Partial copy of @shipDirectionsPresent. The first few entries are missing.
; @addr{7f23}
@shipDirectionsPresentCopy:
	.db $d6 $28 DIR_UP
	.db $b6 $68 DIR_RIGHT
	.db $b8 $63 DIR_DOWN
	.db $d8 $23 DIR_RIGHT
	.db $d8 $25 DIR_UP
	.db $c8 $15 DIR_RIGHT
	.db $c8 $18 DIR_UP
	.db $a8 $68 DIR_LEFT
	.db $a8 $63 DIR_DOWN
	.db $b8 $43 DIR_LEFT
	.db $00

; @addr{7f41}
@shipDirectionsPastCopy:
	.db $b6 $34 DIR_DOWN
	.db $d6 $14 DIR_RIGHT
	.db $d7 $18 DIR_UP
	.db $c7 $58 DIR_LEFT
	.db $c7 $53 DIR_UP
	.db $b7 $33 DIR_LEFT
	.db $00

;;
; Garbage function, calls invalid addresses, who knows what it was supposed to do.
; @addr{7f55}
func_7f55:
	ld a,(wPirateShipRoom)
	ld e,a
	ld hl,@data2
	call $1e43
	ret c

	ld hl,@data
	call $19c0
	jr z,+

	ld a,$04
	rst_addAToHl
+
	ld b,$04
	ld de,wPirateShipRoom
	jp $048b

@data:
	.db $b6 $48
	.db $48 $02
	.db $b6 $58
	.db $78 $02
@data2:
	.db $a8 $00
	.db $b6 $00
	.db $b7 $00
	.db $b8 $00
	.db $c6 $00
	.db $c7 $00
	.db $c8 $00
	.db $d6 $00
	.db $d7 $00
	.db $d8 $00
	.db $00

;;
; Another garbage function calling invalid addresses
; @addr{7f90}
func_7f90:
	callab $03 $7d20		; $7f90
	call $1aca		; $7f98
	jp $34ad		; $7f9b

; @addr{7f9d}
@data:
	.db $78 $02 $a8 $00 $b6 $00 $b7 $00
	.db $b8 $00 $c6 $00 $c7 $00 $c8 $00
	.db $d6 $00 $d7 $00 $d8 $00 $00

;;
; Another garbage function calling invalid addresses
; @addr{7fb5}
func_7fb5:
	callab $03 $7d20	; $7fb5
	call $1ae4		; $7fbd
	jp $34c7		; $7fc0

.endif ; BUILD_VANILLA
.endif ; ROM_AGES

.ENDS
