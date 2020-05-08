; ==============================================================================
; INTERACID_BOMB_FLOWER
; ==============================================================================
interactionCode6f:
.ifdef ROM_AGES
	jp interactionDelete		; $4000
.else
	ld e,Interaction.subid		; $4340
	ld a,(de)		; $4342
	rst_jumpTable			; $4343
	.dw _bomb_flower_subid0
	.dw _bomb_flower_subid1

_bomb_flower_subid0:
	ld e,Interaction.state		; $4348
	ld a,(de)		; $434a
	rst_jumpTable			; $434b
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $4352
	ld (de),a		; $4354

	call getThisRoomFlags		; $4355
	bit 5,(hl)		; $4358
	jr nz,+			; $435a

	ld a,TREASURE_BOMB_FLOWER		; $435c
	call checkTreasureObtained		; $435e
	jr c,+			; $4361

	ld a,$04		; $4363
	call objectSetCollideRadius		; $4365
	call interactionInitGraphics		; $4368
	jp objectSetVisible82		; $436b
+
	jp interactionDelete		; $436e

@state1:
	call objectGetTileAtPosition		; $4371
	ld (hl),$00		; $4374
	call objectPreventLinkFromPassing		; $4376
	jp objectAddToGrabbableObjectBuffer		; $4379

@state2:
	ld e,Interaction.state2		; $437c
	ld a,(de)		; $437e
	rst_jumpTable			; $437f
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call interactionIncState2		; $4388
	ld a,$1c		; $438b
	ld (wDisabledObjects),a		; $438d
	xor a			; $4390
	ld (wLinkGrabState2),a		; $4391
	call interactionSetAnimation		; $4394
	call objectSetVisible81		; $4397
	call objectGetShortPosition		; $439a
	ld c,a			; $439d
	ld a,TILEINDEX_DUG_HOLE		; $439e
	jp setTile		; $43a0

@substate1:
	ld a,(wLinkGrabState)		; $43a3
	cp $83			; $43a6
	ret nz			; $43a8

	ld a,(wLinkDeathTrigger)		; $43a9
	or a			; $43ac
	ret nz			; $43ad

	ld a,$81		; $43ae
	ld (wDisabledObjects),a		; $43b0
	ld (wMenuDisabled),a		; $43b3
	call dropLinkHeldItem		; $43b6

	ld e,Interaction.state2		; $43b9
	ld a,$02		; $43bb
	ld (de),a		; $43bd

	call getThisRoomFlags		; $43be
	set 5,(hl)		; $43c1
	ld a,LINK_STATE_04		; $43c3
	ld (wLinkForceState),a		; $43c5
	ld a,$01		; $43c8
	ld (wcc50),a		; $43ca
	ld bc,TX_003c		; $43cd
	call showText		; $43d0
	ld a,TREASURE_BOMB_FLOWER		; $43d3
	jp giveTreasure		; $43d5

@substate2:
@substate3:
	call retIfTextIsActive		; $43d8
	xor a			; $43db
	ld (wDisabledObjects),a		; $43dc
	ld (wMenuDisabled),a		; $43df
	call updateLinkLocalRespawnPosition		; $43e2
	jp interactionDelete		; $43e5

_bomb_flower_subid1:
	ld e,Interaction.state		; $43e8
	ld a,(de)		; $43ea
	rst_jumpTable			; $43eb
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01		; $43f4
	ld (de),a		; $43f6

	ld hl,bombflower_unblockAutumnTemple		; $43f7
	call interactionSetScript		; $43fa
	call interactionInitGraphics		; $43fd
	xor a			; $4400
	call interactionSetAnimation		; $4401
	jp objectSetVisible82		; $4404

@state2:
	call interactionAnimate		; $4407

@state1:
	call interactionAnimate		; $440a
	jp interactionRunScript		; $440d

@state3:
	call objectSetInvisible		; $4410
	jp interactionRunScript		; $4413
.endif


; ==============================================================================
; INTERACID_SWITCH_TILE_TOGGLER
; ==============================================================================
interactionCode78:
	ld e,Interaction.state		; $4003
	ld a,(de)		; $4005
	rst_jumpTable			; $4006
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $400b
	ld (de),a		; $400d
	ld a,(wSwitchState)		; $400e
	ld e,Interaction.var03		; $4011
	ld (de),a		; $4013

@state1:
	ld a,(wSwitchState)		; $4014
	ld b,a			; $4017
	ld e,Interaction.var03		; $4018
	ld a,(de)		; $401a
	cp b			; $401b
	ret z			; $401c

	ld a,b			; $401d
	ld (de),a		; $401e
	ld e,Interaction.xh		; $401f
	ld a,(de)		; $4021
	ld hl,@tileReplacement		; $4022
	rst_addDoubleIndex			; $4025
	ld e,Interaction.subid		; $4026
	ld a,(de)		; $4028
	and b			; $4029
	jr z,+			; $402a
	inc hl			; $402c
+
	ld e,Interaction.yh		; $402d
	ld a,(de)		; $402f
	ld c,a			; $4030
	ld a,(hl)		; $4031
	jp setTile		; $4032

; Index for this table is "Interaction.xh". Determines what tiles will appear when
; a switch is on or off.
;   b0: tile index when switch not pressed
;   b1: tile index when switch pressed
@tileReplacement:
	.db $5d $59 ; $00
	.db $5d $5a ; $01
	.db $5d $5b ; $02
	.db $5d $5c ; $03
	.db $5e $59 ; $04
	.db $5e $5a ; $05
	.db $5e $5b ; $06
	.db $5e $5c ; $07
	.db $59 $5d ; $08
	.db $5a $5d ; $09
	.db $5b $5d ; $0a
	.db $5c $5d ; $0b (patch's minecart game)
	.db $59 $5e ; $0c
	.db $5a $5e ; $0d
	.db $5b $5e ; $0e
	.db $5c $5e ; $0f
	.db $59 $5b ; $10
	.db $5a $5c ; $11
	.db $5b $59 ; $12
	.db $5c $5a ; $13
	.db $59 $5c ; $14
	.db $5a $5b ; $15
	.db $5b $5a ; $16
	.db $5c $59 ; $17


; ==============================================================================
; INTERACID_MOVING_PLATFORM
;
; Variables:
;   Subid: After being processed, this just represents the size (see @collisionRadii).
;   var32: Formerly bits 3-7 of subid; the index of the "script" to use.
; ==============================================================================
interactionCode79:
	ld e,Interaction.state		; $4065
	ld a,(de)		; $4067
	rst_jumpTable			; $4068
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $406d
	ld (de),a		; $406f
	ld e,Interaction.subid		; $4070
	ld a,(de)		; $4072
	ld b,a			; $4073
	and $07			; $4074
	ld (de),a		; $4076

	ld a,b			; $4077
	ld e,Interaction.var32		; $4078
	swap a			; $407a
	rlca			; $407c
	and $1f			; $407d
	ld (de),a		; $407f
	call interactionInitGraphics		; $4080

	ld e,Interaction.speed		; $4083
	ld a,SPEED_80		; $4085
	ld (de),a		; $4087

	ld e,Interaction.subid		; $4088
	ld a,(de)		; $408a
	ld hl,@collisionRadii		; $408b
	rst_addDoubleIndex			; $408e
	ld e,Interaction.collisionRadiusY		; $408f
	ldi a,(hl)		; $4091
	ld (de),a		; $4092
	inc e			; $4093
	ld a,(hl)		; $4094
	ld (de),a		; $4095

	callab scriptHlp.movingPlatform_loadScript		; $4096
	callab scriptHlp.movingPlatform_runScript		; $409e
	jp objectSetVisible83		; $40a6

@collisionRadii:
	.db $08 $08
	.db $10 $08
	.db $18 $08
	.db $08 $10
	.db $08 $18
	.db $10 $10

@state1:
	ld a,(wLinkRidingObject)		; $40b5
	cp d			; $40b8
	jr z,@linkOnPlatform	; $40b9
	or a			; $40bb
	jr nz,@updateSubstate	; $40bc

	call @checkLinkTouching		; $40be
	jr nc,@updateSubstate	; $40c1

	; Just got on platform
	ld a,d			; $40c3
	ld (wLinkRidingObject),a		; $40c4
	jr @updateSubstate		; $40c7

@linkOnPlatform:
	call @checkLinkTouching		; $40c9
	jr c,@updateSubstate	; $40cc
	xor a			; $40ce
	ld (wLinkRidingObject),a		; $40cf

@updateSubstate:
	ld e,Interaction.state2		; $40d2
	ld a,(de)		; $40d4
	rst_jumpTable			; $40d5
	.dw @substate0
	.dw @substate1

;;
; @param[out]	cflag	Set if Link's touching the platform
; @addr{40da}
@checkLinkTouching:
	ld hl,w1Link.yh		; $40da
	ldi a,(hl)		; $40dd
	add $05			; $40de
	ld b,a			; $40e0
	inc l			; $40e1
	ld c,(hl)		; $40e2
	jp interactionCheckContainsPoint		; $40e3


; Substate 0: not moving
@substate0:
	call interactionDecCounter1		; $40e6
	ret nz			; $40e9
	callab scriptHlp.movingPlatform_runScript		; $40ea
	ret			; $40f2

; Substate 1: moving
@substate1:
	ld a,(wLinkPlayingInstrument)		; $40f3
	or a			; $40f6
	ret nz			; $40f7

	call objectApplySpeed		; $40f8
	ld a,(wLinkRidingObject)		; $40fb
	cp d			; $40fe
	jr nz,@substate0	; $40ff

	ld a,(w1Link.state)		; $4101
	cp $01			; $4104
	jr nz,@substate0	; $4106

	ld e,Interaction.speed		; $4108
	ld a,(de)		; $410a
	ld b,a			; $410b
	ld e,Interaction.angle		; $410c
	ld a,(de)		; $410e
	ld c,a			; $410f
	call updateLinkPositionGivenVelocity		; $4110
	jr @substate0		; $4113


; ==============================================================================
; INTERACID_ROLLER
;
; Variables:
;   counter1:
;   counter2:
;   var30: Original X-position, where it returns to
;   var31: Counter before showing "it's too heavy to move" text.
; ==============================================================================
interactionCode7a:
	call retIfTextIsActive		; $4115
	ld e,Interaction.state		; $4118
	ld a,(de)		; $411a
	rst_jumpTable			; $411b
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $4122
	ld (de),a		; $4124
	call interactionInitGraphics		; $4125

	; [collisionRadiusY] = ([subid]+2)*8
	ld h,d			; $4128
	ld l,Interaction.subid		; $4129
	ld a,(hl)		; $412b
	add $02			; $412c
	swap a			; $412e
	rrca			; $4130
	ld l,Interaction.collisionRadiusY		; $4131
	ldi (hl),a		; $4133

	; [collisionRadiusX] = $06
	ld a,$06		; $4134
	ld (hl),a		; $4136

	ld l,Interaction.speed		; $4137
	ld (hl),SPEED_80		; $4139
	ld l,Interaction.counter1		; $413b
	ld (hl),30		; $413d
	ld l,Interaction.counter2		; $413f
	ld (hl),60		; $4141

	; Remember original X-position
	ld l,Interaction.xh		; $4143
	ld a,(hl)		; $4145
	ld l,Interaction.var30		; $4146
	ld (hl),a		; $4148

	call objectSetVisible83		; $4149

@state1:
	call @preventLinkFromPassing		; $414c
	jr c,@movingTowardRoller	; $414f

@notPushingAgainstRoller:
	ld h,d			; $4151
	ld l,Interaction.var31		; $4152
	ld (hl),30		; $4154

@moveTowardOriginalPosition:
	ld h,d			; $4156
	ld l,Interaction.counter1		; $4157
	ld (hl),30		; $4159

	; Return if already in position
	ld l,Interaction.xh		; $415b
	ld b,(hl)		; $415d
	ld l,Interaction.var30		; $415e
	ld a,(hl)		; $4160
	cp b			; $4161
	ret z			; $4162

	; Return unless counter2 reached 0
	ld l,Interaction.counter2		; $4163
	dec (hl)		; $4165
	ret nz			; $4166

	cp b			; $4167
	ld bc,$0008		; $4168
	jr nc,@moveRollerInDirection	; $416b
	ld bc,$0118		; $416d
	jr @moveRollerInDirection		; $4170


@movingTowardRoller:
	; Check Link's Y position is high or low enough (can't be on the edge)?
	ld h,d			; $4172
	ld l,Interaction.collisionRadiusY		; $4173
	ld a,(hl)		; $4175
	sub $02			; $4176
	ld b,a			; $4178
	ld c,b			; $4179
	sla c			; $417a
	inc c			; $417c
	ld l,Interaction.yh		; $417d
	ld a,(w1Link.yh)		; $417f
	sub (hl)		; $4182
	add b			; $4183
	cp c			; $4184
	jr nc,@notPushingAgainstRoller	; $4185

	; Must be moving directly toward the roller
	ld a,(wLinkAngle)		; $4187
	cp $08			; $418a
	ldbc $00,$08		; $418c
	jr z,++			; $418f
	cp $18			; $4191
	ldbc $01,$18		; $4193
	jr nz,@notPushingAgainstRoller	; $4196
++
	ld a,$01		; $4198
	ld (wForceLinkPushAnimation),a		; $419a
	ld a,(wBraceletGrabbingNothing)		; $419d
	and $03			; $41a0
	swap a			; $41a2
	rrca			; $41a4
	cp c			; $41a5
	jr z,@pushingAgainstRoller	; $41a6

	; Link isn't pushing against it with the bracelet. Check whether to show
	; informative text ("it's too heavy to move").

	; Check bracelet is not on A or B.
	ld hl,wInventoryB		; $41a8
	ld a,ITEMID_BRACELET		; $41ab
	cp (hl)			; $41ad
	jr z,@notPushingAgainstRoller	; $41ae
	inc hl			; $41b0
	cp (hl)			; $41b1
	jr z,@notPushingAgainstRoller	; $41b2

	; Check bracelet not being used.
	ld a,(wBraceletGrabbingNothing)		; $41b4
	or a			; $41b7
	jr nz,@notPushingAgainstRoller	; $41b8

	; Check not in air.
	ld a,(wLinkInAir)		; $41ba
	or a			; $41bd
	jr nz,@notPushingAgainstRoller	; $41be

	; Countdown before showing informative text.
	ld h,d			; $41c0
	ld l,Interaction.var31		; $41c1
	dec (hl)		; $41c3
	jr nz,@moveTowardOriginalPosition	; $41c4

	call showInfoTextForRoller		; $41c6
	jr @notPushingAgainstRoller		; $41c9

@pushingAgainstRoller:
	ld a,60		; $41cb
	ld e,Interaction.counter2		; $41cd
	ld (de),a		; $41cf
	call @checkRollerCanBePushed		; $41d0
	jp nz,@notPushingAgainstRoller		; $41d3

	; Roller can be pushed; decrement counter until it gets pushed.
	call interactionDecCounter1		; $41d6
	ret nz			; $41d9

;;
; @param	b	Animation (0 for right, 1 for left)
; @param	c	Angle
@moveRollerInDirection:
	ld l,Interaction.state		; $41da
	inc (hl)		; $41dc
	ld l,Interaction.angle		; $41dd
	ld (hl),c		; $41df

	; Use animation [subid]*2+b
	ld l,Interaction.subid		; $41e0
	ld a,(hl)		; $41e2
	add a			; $41e3
	add b			; $41e4
	call interactionSetAnimation		; $41e5

	ld hl,wInformativeTextsShown		; $41e8
	set 6,(hl)		; $41eb


; State 2: moving in a direction.
@state2:
	call objectApplySpeed		; $41ed
	call interactionAnimate		; $41f0
	call objectCheckCollidedWithLink_ignoreZ		; $41f3
	jr nc,+			; $41f6
	call @updateLinkPositionWhileRollerMoving		; $41f8
+
	ld h,d			; $41fb
	ld l,Interaction.animParameter		; $41fc
	ld a,(hl)		; $41fe
	or a			; $41ff
	jr z,@rollerSound	; $4200
	inc a			; $4202
	ret nz			; $4203

	; animParameter signaled end of pushing animation.
	ld l,Interaction.counter1		; $4204
	ld (hl),30		; $4206
	inc l			; $4208
	ld (hl),60		; $4209
	ld l,Interaction.state		; $420b
	dec (hl)		; $420d
	ret			; $420e
@rollerSound:
	ld (hl),$01		; $420f
	ld a,SND_ROLLER		; $4211
	jp playSound		; $4213


@updateLinkPositionWhileRollerMoving:
	ld a,(w1Link.adjacentWallsBitset)		; $4216
	cp $53			; $4219
	jr z,@squashLink	; $421b
	cp $ac			; $421d
	jr z,@squashLink	; $421f
	cp $33			; $4221
	jr z,@squashLink	; $4223
	cp $c3			; $4225
	jr z,@squashLink	; $4227
	cp $cc			; $4229
	jr z,@squashLink	; $422b
	cp $3c			; $422d
	jr z,@squashLink	; $422f

	call @preventLinkFromPassing		; $4231

	; If Link's facing any walls on left or right sides, move him left or right; what
	; will actually happen, is the function call will see that he's facing a wall, and
	; move him up or down toward a "wall-free" area. This apparently does not happen
	; with the "@preventLinkFromPassing" call, so it must be done here.
	ld a,(w1Link.adjacentWallsBitset)		; $4234
	and $0f			; $4237
	ret z			; $4239
	call objectGetAngleTowardLink		; $423a
	cp $10			; $423d
	ld c,$08		; $423f
	jr c,+			; $4241
	ld c,$18		; $4243
+
	ld e,Interaction.angle		; $4245
	ld a,(de)		; $4247
	cp c			; $4248
	ret nz			; $4249
	ld b,SPEED_100		; $424a
	jp updateLinkPositionGivenVelocity		; $424c

@squashLink:
	ld a,(w1Link.state)		; $424f
	cp LINK_STATE_NORMAL			; $4252
	ret nz			; $4254
	ld a,LINK_STATE_SQUISHED		; $4255
	ld (wLinkForceState),a		; $4257
	xor a			; $425a
	ld (wcc50),a		; $425b
	ret			; $425e

;;
; @param	c	Angle it's moving toward
; @param[out]	zflag	z if can be pushed.
; @addr{425f}
@checkRollerCanBePushed:
	; Do some weird math to get the topmost tile on the left or right side of the
	; roller?
	push bc			; $425f
	ld e,Interaction.subid		; $4260
	ld a,(de)		; $4262
	add $02			; $4263
	ldh (<hFF8B),a	; $4265
	swap a			; $4267
	rrca			; $4269
	ld b,a			; $426a
	ld e,Interaction.yh		; $426b
	ld a,(de)		; $426d
	sub b			; $426e
	add $08			; $426f
	and $f0			; $4271
	ld b,a			; $4273
	ld a,$08		; $4274
	ld l,$01		; $4276
	cp c			; $4278
	jr z,+			; $4279
	ld l,$ff		; $427b
+
	ld e,Interaction.xh		; $427d
	ld a,(de)		; $427f
	swap a			; $4280
	add l			; $4282
	and $0f			; $4283
	or b			; $4285
	pop bc			; $4286

	; Make sure there's no wall blocking the roller.
	ld l,a			; $4287
	ld h,>wRoomCollisions		; $4288
	ldh a,(<hFF8B)	; $428a
	ld e,a			; $428c
@nextTile:
	ld a,(hl)		; $428d
	cp $10			; $428e
	jr nc,+			; $4290
	or a			; $4292
	ret nz			; $4293
+
	ld a,l			; $4294
	add $10			; $4295
	ld l,a			; $4297
	dec e			; $4298
	jr nz,@nextTile	; $4299
	xor a			; $429b
	ret			; $429c

;;
; @param[out]	cflag	c if Link is pushing against the roller
; @addr{429d}
@preventLinkFromPassing:
	ld a,(w1Link.collisionType)		; $429d
	bit 7,a			; $42a0
	ret z			; $42a2
	ld a,(w1Link.state)		; $42a3
	cp LINK_STATE_NORMAL			; $42a6
	ret nz			; $42a8
	jp objectPreventLinkFromPassing		; $42a9


; ==============================================================================
; INTERACID_SPINNER
;
; Variables:
;   var3a: Bitmask for wSpinnerState (former value of "xh")
; ==============================================================================
interactionCode7d:
	ld e,Interaction.subid		; $42ac
	ld a,(de)		; $42ae
	rst_jumpTable			; $42af
	.dw @subid00
	.dw @subid01
	.dw _spinner_subid02

@subid00:
@subid01:
	ld e,Interaction.state		; $42b6
	ld a,(de)		; $42b8
	rst_jumpTable			; $42b9
	.dw @state0
	.dw interactionRunScript
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01		; $42c4
	ld (de),a		; $42c6

	ld h,d			; $42c7
	ld l,Interaction.xh		; $42c8
	ld a,(hl)		; $42ca
	ld l,Interaction.var3a		; $42cb
	ld (hl),a		; $42cd

	; Calculate subid (blue or red) based on whether the bit in wSpinnerState is set
	ld a,(wSpinnerState)		; $42ce
	and (hl)		; $42d1
	ld a,$01		; $42d2
	jr nz,+			; $42d4
	dec a			; $42d6
+
	ld l,Interaction.subid		; $42d7
	ld (hl),a		; $42d9

	; Calculate angle? (subid*8)
	swap a			; $42da
	rrca			; $42dc
	ld l,Interaction.angle		; $42dd
	ld (hl),a		; $42df

	ld l,Interaction.yh		; $42e0
	ld a,(hl)		; $42e2
	call setShortPosition		; $42e3

	call interactionInitGraphics		; $42e6
	ld hl,spinnerScript_initialization		; $42e9
	call interactionSetScript		; $42ec
	call objectSetVisible82		; $42ef

	; Create "arrow" object and set it as relatedObj1
	ldbc INTERACID_SPINNER, $02		; $42f2
	call objectCreateInteraction		; $42f5
	ret nz			; $42f8
	ld l,Interaction.relatedObj1		; $42f9
	ld (hl),d		; $42fb
	ret			; $42fc


; State 2: Link just touched the spinner.
@state2:
	ld hl,wcc95		; $42fd
	ld a,(wLinkInAir)		; $4300
	or a			; $4303
	jr nz,@revertToState1	; $4304

	; Check if in midair or swimming?
	bit 4,(hl)		; $4306
	jr nz,@beginTurning	; $4308

@revertToState1:
	; Undo everything we just did
	res 7,(hl)		; $430a
	ld e,Interaction.state		; $430c
	ld a,$01		; $430e
	ld (de),a		; $4310
	ld hl,spinnerScript_waitForLink		; $4311
	jp interactionSetScript		; $4314

@beginTurning:
	; State 3
	ld a,$03		; $4317
	ld (de),a		; $4319

	call clearAllParentItems		; $431a

	; Determine the direction Link entered from
	ld c,$28		; $431d
	call objectCheckLinkWithinDistance		; $431f
	sra a			; $4322
	ld e,Interaction.direction		; $4324
	ld (de),a		; $4326

	; Check angle
	ld b,a			; $4327
	inc e			; $4328
	ld a,(de)		; $4329
	or a			; $432a
	jr nz,@clockwise	; $432b

@counterClockwise:
	ld a,b			; $432d
	add a			; $432e
	ld hl,_spinner_counterClockwiseData		; $432f
	rst_addDoubleIndex			; $4332
	jr ++			; $4333

@clockwise:
	ld a,b			; $4335
	add a			; $4336
	ld hl,_spinner_clockwiseData		; $4337
	rst_addDoubleIndex			; $433a

++
	call _spinner_setLinkRelativePosition		; $433b
	ldi a,(hl)		; $433e
	ld c,<w1Link.direction		; $433f
	ld (bc),a		; $4341

	ld e,Interaction.var39		; $4342
	ld a,(hl)		; $4344
	ld (de),a		; $4345

	call setLinkForceStateToState08		; $4346

	; Disable everything but interactions?
	ld a,(wDisabledObjects)		; $4349
	or $80			; $434c
	ld (wDisabledObjects),a		; $434e

	ld a,$04		; $4351
	call setScreenShakeCounter		; $4353

	ld a,SND_OPENCHEST		; $4356
	jp playSound		; $4358


; State 3: In the process of turning
@state3:
	call _spinner_updateLinkPosition		; $435b

	ld e,Interaction.animParameter		; $435e
	ld a,(de)		; $4360
	inc a			; $4361
	jp nz,interactionAnimate		; $4362

	; Finished turning, set up state 4
	ld h,d			; $4365
	ld l,Interaction.state		; $4366
	ld (hl),$04		; $4368

	ld l,Interaction.counter1		; $436a
	ld (hl),$10		; $436c
	xor a			; $436e
	ld (wDisabledObjects),a		; $436f

	; Update Link's angle based on direction
	ld hl,w1Link.direction		; $4372
	ldi a,(hl)		; $4375
	swap a			; $4376
	rrca			; $4378
	ld (hl),a		; $4379

	; Force him to move out
	ld hl,wLinkForceState		; $437a
	ld a,LINK_STATE_FORCE_MOVEMENT		; $437d
	ldi (hl),a		; $437f
	inc l			; $4380
	ld (hl),$10		; $4381

	; Reset signal that spinner's being used?
	ld hl,wcc95		; $4383
	res 7,(hl)		; $4386
	ret			; $4388

; State 4: Link moving out from spinner
@state4:
	call interactionDecCounter1		; $4389
	ret nz			; $438c

	; Toggle spinner state
	ld l,Interaction.var3a		; $438d
	ld a,(wSpinnerState)		; $438f
	xor (hl)		; $4392
	ld (wSpinnerState),a		; $4393

	; Toggle color
	ld l,Interaction.oamFlags		; $4396
	ld a,(hl)		; $4398
	xor $01			; $4399
	ld (hl),a		; $439b

	; Toggle angle
	ld l,Interaction.angle		; $439c
	ld a,(hl)		; $439e
	xor $08			; $439f
	ld (hl),a		; $43a1

	; Go back to state 1
	ld l,Interaction.state		; $43a2
	ld (hl),$01		; $43a4
	ld hl,spinnerScript_waitForLinkAfterDelay		; $43a6
	jp interactionSetScript		; $43a9


; Arrow rotating around a spinner
_spinner_subid02:
	ld e,Interaction.state		; $43ac
	ld a,(de)		; $43ae
	rst_jumpTable			; $43af
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $43b4
	ld (de),a		; $43b6
	call interactionInitGraphics		; $43b7

	; [this.angle] = [relatedObj1.angle]
	ld e,Interaction.relatedObj1		; $43ba
	ld a,(de)		; $43bc
	ld h,d			; $43bd
	ld l,Interaction.angle		; $43be
	ld e,l			; $43c0
	ld a,(hl)		; $43c1
	ld (de),a		; $43c2
	call objectSetVisible82		; $43c3

@state1:
	; Check if [this.angle] == [relatedObj1.angle]
	ld e,Interaction.relatedObj1		; $43c6
	ld a,(de)		; $43c8
	ld h,a			; $43c9
	ld l,Interaction.angle		; $43ca
	ld e,l			; $43cc
	ld a,(de)		; $43cd
	cp (hl)			; $43ce
	jr z,++			; $43cf

	; Angle changed (red to blue, or blue to red)
	ld a,(hl)		; $43d1
	ld (de),a		; $43d2
	swap a			; $43d3
	rlca			; $43d5
	add $02			; $43d6
	call interactionSetAnimation		; $43d8
++
	; [this.oamFlags] = [relatedObj1.oamFlags]
	ld e,Interaction.relatedObj1		; $43db
	ld a,(de)		; $43dd
	ld h,a			; $43de
	ld l,Interaction.oamFlags		; $43df
	ld e,l			; $43e1
	ld a,(hl)		; $43e2
	ld (de),a		; $43e3

	jp interactionAnimate		; $43e4

;;
; @addr{43e7}
_spinner_updateLinkPosition:
	; Check that the animParameter signals Link should change position (nonzero and
	; not $ff)
	ld e,Interaction.animParameter		; $43e7
	ld a,(de)		; $43e9
	ld b,a			; $43ea
	or a			; $43eb
	ret z			; $43ec
	inc a			; $43ed
	ret z			; $43ee

	xor a			; $43ef
	ld (de),a		; $43f0

	ld a,SND_DOORCLOSE		; $43f1
	call playSound		; $43f3

	; Read from table based on value of "animParameter" and "var39" to determine
	; Link's position relative to the spinner.
	ld e,Interaction.var39		; $43f6
	ld a,(de)		; $43f8
	add b			; $43f9
	and $0f			; $43fa
	ld hl,_spinner_linkRelativePositions		; $43fc
	rst_addDoubleIndex			; $43ff

;;
; @param	hl	Address of 2 bytes (Y/X offset for Link relative to spinner)
; @addr{4400}
_spinner_setLinkRelativePosition:
	ld b,>w1Link		; $4400
	ld e,Interaction.yh		; $4402
	ld c,<w1Link.yh		; $4404
	call @func		; $4406

	ld e,Interaction.xh		; $4409
	ld c,<w1Link.xh		; $440b

@func:
	ld a,(de)		; $440d
	add (hl)		; $440e
	inc hl			; $440f
	ld (bc),a		; $4410
	ret			; $4411


; Each row of below table represents data for a particular direction of transition:
;   b0: Y offset for Link relative to spinner
;   b1: X offset for Link relative to spinner
;   b2: Value for w1Link.direction
;   b3: Value for spinner.var39 (relative index for _spinner_linkRelativePositions)
_spinner_counterClockwiseData:
	.db $f4 $00 $03 $08 ; DIR_UP (Link enters from above)
	.db $00 $0c $00 $04 ; DIR_RIGHT
	.db $0c $00 $01 $00 ; DIR_DOWN
	.db $00 $f4 $02 $0c ; DIR_LEFT

_spinner_clockwiseData:
	.db $f4 $00 $01 $08 ; DIR_UP
	.db $00 $0c $02 $04 ; DIR_RIGHT
	.db $0c $00 $03 $00 ; DIR_DOWN
	.db $00 $f4 $00 $0c ; DIR_LEFT


; Each row is a Y/X offset for Link. The row is selected from the animation's
; "animParameter" and "var39".
_spinner_linkRelativePositions:
	.db $0c $00
	.db $0a $02
	.db $08 $08
	.db $02 $0a
	.db $00 $0c
	.db $fe $0a
	.db $f8 $08
	.db $f6 $02
	.db $f4 $00
	.db $f6 $fe
	.db $f8 $f8
	.db $fe $f6
	.db $00 $f4
	.db $02 $f6
	.db $08 $f8
	.db $0a $fe


; ==============================================================================
; INTERACID_MINIBOSS_PORTAL
; ==============================================================================
interactionCode7e:
	ld e,Interaction.subid		; $4452
	ld a,(de)		; $4454
	rst_jumpTable			; $4455
	.dw @subid00
	.dw @subid01
.ifdef ROM_SEASONS
	.dw @subid02
.endif


; Subid $00: miniboss portals
@subid00:
	ld e,Interaction.state		; $445a
	ld a,(de)		; $445c
	rst_jumpTable			; $445d
	.dw @minibossState0
	.dw @state1
	.dw @state2
	.dw @minibossState3

@minibossState0:
	ld a,(wDungeonIndex)		; $4466
	ld hl,@dungeonRoomTable		; $4469
	rst_addDoubleIndex			; $446c
	ld c,(hl)		; $446d
	ld a,(wActiveGroup)		; $446e
	ld hl,flagLocationGroupTable
	rst_addAToHl			; $4474
	ld h,(hl)		; $4475
	ld l,c			; $4476

	; hl now points to room flags for the miniboss room
	; Delete if miniboss is not dead.
	ld a,(hl)		; $4477
	and $80			; $4478
	jp z,interactionDelete		; $447a

	ld c,$57		; $447d
	call objectSetShortPosition		; $447f

@commonState0:
	call interactionInitGraphics		; $4482
	ld a,$03		; $4485
	call objectSetCollideRadius		; $4487

	; Go to state 1 if Link's not touching the portal, state 2 if he is.
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $448a
	ld a,$01		; $448d
	jr nc,+			; $448f
	inc a			; $4491
+
	ld e,Interaction.state		; $4492
	ld (de),a		; $4494
	jp objectSetVisible83		; $4495


; State 1: waiting for Link to touch the portal to initiate the warp.
@state1:
	call interactionAnimate		; $4498
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $449b
	ret nc			; $449e

	; Check that [w1Link.id] == SPECIALOBJECTID_LINK, check collisions are enabled
	ld a,(w1Link.id)		; $449f
	or a			; $44a2
	call z,checkLinkCollisionsEnabled		; $44a3
	ret nc			; $44a6

	call resetLinkInvincibility		; $44a7
	ld a,$03		; $44aa
	ld e,Interaction.state		; $44ac
	ld (de),a		; $44ae
	ld (wLinkCanPassNpcs),a		; $44af

	ld a,$30		; $44b2
	ld e,Interaction.counter1		; $44b4
	ld (de),a		; $44b6
	call setLinkForceStateToState08		; $44b7
	ld hl,w1Link.visible		; $44ba
	ld (hl),$82		; $44bd
	call objectCopyPosition ; Link.position = this.position

	ld a,$01		; $44c2
	ld (wDisabledObjects),a		; $44c4
	ld a,SND_TELEPORT		; $44c7
	jp playSound		; $44c9


; State 2: wait for Link to get off the portal before detecting collisions
@state2:
	call interactionAnimate		; $44cc
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $44cf
	ret c			; $44d2
	ld a,$01		; $44d3
	ld e,Interaction.state		; $44d5
	ld (de),a		; $44d7
	ret			; $44d8


; State 3: Do the warp
@minibossState3:
	ld hl,w1Link		; $44d9
	call objectCopyPosition		; $44dc
	call @spinLink		; $44df
	ret nz			; $44e2

	; Get starting room in 'b', miniboss room in 'c'
	ld a,(wDungeonIndex)		; $44e3
	ld hl,@dungeonRoomTable		; $44e6
	rst_addDoubleIndex			; $44e9
	ldi a,(hl)		; $44ea
	ld c,(hl)		; $44eb
	ld b,a			; $44ec

	ld hl,wWarpDestGroup		; $44ed
	ld a,(wActiveGroup)		; $44f0
	or $80			; $44f3
	ldi (hl),a		; $44f5
	ld a,(wActiveRoom)		; $44f6
	cp b			; $44f9
	jr nz,+			; $44fa
	ld b,c			; $44fc
+
	ld a,b			; $44fd
	ldi (hl),a  ; [wWarpDestRoom] = b
	lda TRANSITION_DEST_0			; $44ff
	ldi (hl),a  ; [wWarpTransition] = TRANSITION_DEST_0
	ld (hl),$57 ; [wWarpDestPos] = $57
	inc l			; $4503
	ld (hl),$03 ; [wWarpTransition2] = $03 (fadeout)
	ret			; $4506

; Each row corresponds to a dungeon. The first byte is the miniboss room index, the second
; is the dungeon entrance (the two locations of the portal).
; If bit 7 is set in the miniboss room's flags, the portal is enabled.
@dungeonRoomTable:
.ifdef ROM_AGES
	.db $01 $04
	.db $18 $24
	.db $34 $46
	.db $4d $66
	.db $80 $91
	.db $b4 $bb
	.db $12 $26
	.db $4d $56
	.db $82 $aa
.else
	.db $01 $01
	.db $0b $15
	.db $21 $39
	.db $48 $4b
	.db $6a $81
	.db $a2 $a7
	.db $c8 $ba
	.db $42 $5b
	.db $72 $87
.endif


@spinLink:
	call resetLinkInvincibility		; $4519
	call interactionAnimate		; $451c
	ld a,(wLinkDeathTrigger)		; $451f
	or a			; $4522
	ret nz			; $4523
	ld a,(wFrameCounter)		; $4524
	and $03			; $4527
	jr nz,++		; $4529
	ld hl,w1Link.direction		; $452b
	ld a,(hl)		; $452e
	inc a			; $452f
	and $03			; $4530
	ld (hl),a		; $4532
++
	jp interactionDecCounter1		; $4533


; Subid $01: miscellaneous portals used in Hero's Cave
@subid01:
	ld e,Interaction.state		; $4536
	ld a,(de)		; $4538
	rst_jumpTable			; $4539
	.dw @herosCaveState0
	.dw @state1
	.dw @state2
	.dw @herosCaveState3

@herosCaveState0:
.ifdef ROM_AGES
	call interactionDeleteAndRetIfEnabled02		; $4542
	ld e,Interaction.xh		; $4545
	ld a,(de)		; $4547
	ld e,Interaction.var03		; $4548
	ld (de),a		; $454a
	bit 7,a			; $454b
	jr z,+			; $454d
	call getThisRoomFlags		; $454f
	and ROOMFLAG_ITEM			; $4552
	ret z			; $4554
+
	ld h,d			; $4555
	ld e,Interaction.yh		; $4556
	ld l,e			; $4558
	ld a,(de)		; $4559
	call setShortPosition		; $455a
.else
	ld a,(wc64a)		; $4957
	or a			; $495a
	jp z,interactionDelete		; $495b
.endif
	jp @commonState0		; $455d

@herosCaveState3:
	call @spinLink		; $4560
	ret nz			; $4563

.ifdef ROM_AGES
	; Initiate the warp
	ld e,Interaction.var03		; $4564
	ld a,(de)		; $4566
	and $0f			; $4567
	call @initHerosCaveWarp		; $4569
	ld a,$84		; $456c
	ld (wWarpDestGroup),a		; $456e
	ret			; $4571
.else
	ld a,(wc64a)		; $4965
	jr @initHerosCaveWarp		; $4968

@subid02:
	ld e,Interaction.state		; $496a
	ld a,(de)		; $496c
	rst_jumpTable			; $496d
	.dw @herosCave2State0
	.dw @state1
	.dw @state2
	.dw @herosCave2State3

@herosCave2State0:
	call getThisRoomFlags		; $4976
	and $20			; $4979
	jp z,interactionDelete		; $497b
	jp @commonState0		; $497e

@herosCave2State3:
	call @spinLink		; $4981
	ret nz			; $4984
	xor a			; $4985
.endif

@initHerosCaveWarp:
	ld hl,@herosCaveWarps		; $4572
	rst_addDoubleIndex			; $4575
	ldi a,(hl)		; $4576
	ld (wWarpDestRoom),a		; $4577
	ldi a,(hl)		; $457a
	ld (wWarpDestPos),a		; $457b
	ld a,$85		; $457e
	ld (wWarpDestGroup),a		; $4580
	lda TRANSITION_DEST_0			; $4583
	ld (wWarpTransition),a		; $4584
	ld a,$03		; $4587
	ld (wWarpTransition2),a ; Fadeout transition
	ret			; $458c


; Each row corresponds to a value for bits 0-3 of "X" (later var03).
; First byte is "wWarpDestRoom" (room index), second is "wWarpDestPos".
@herosCaveWarps:
.ifdef ROM_AGES
	.db $c2 $11
	.db $c3 $2c
	.db $c4 $11
	.db $c5 $2c
	.db $c6 $7a
	.db $c9 $86
	.db $ce $57
	.db $cf $91
.else
	.db $30 $37
	.db $31 $9d
	.db $2f $95
	.db $28 $59
	.db $24 $57
	.db $34 $17
.endif


; ==============================================================================
; INTERACID_ESSENCE
; ==============================================================================
interactionCode7f:
	ld a,(wLinkDeathTrigger)		; $459d
	or a			; $45a0
	ret nz			; $45a1

	ld e,Interaction.subid		; $45a2
	ld a,(de)		; $45a4
	rst_jumpTable			; $45a5
	.dw _interaction7f_subid00
	.dw _interaction7f_subid01
	.dw _interaction7f_subid02


; Subid $00: the essence itself
_interaction7f_subid00:
	ld e,Interaction.state		; $45ac
	ld a,(de)		; $45ae
	rst_jumpTable			; $45af
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7

@state0:
	ld a,$01		; $45c0
	ld (de),a		; $45c2
	call interactionInitGraphics		; $45c3
	ld a,$04		; $45c6
	call objectSetCollideRadius		; $45c8

	; Create the pedestal
	ldbc INTERACID_ESSENCE, $01		; $45cb
	call objectCreateInteraction		; $45ce

	; Delete self if got essence
	call getThisRoomFlags		; $45d1
	and ROOMFLAG_ITEM			; $45d4
	jp nz,interactionDelete		; $45d6

	; Create the glow behind the essence
	ld hl,w1ReservedInteraction1		; $45d9
	ld b,$40		; $45dc
	call clearMemory		; $45de
	ld hl,w1ReservedInteraction1		; $45e1
	ld (hl),$81		; $45e4
	inc l			; $45e6
	ld (hl),INTERACID_ESSENCE		; $45e7
	inc l			; $45e9
	ld (hl),$02		; $45ea
	call objectCopyPosition		; $45ec

	; [Glow.relatedObj1] = this
	ld l,Interaction.relatedObj1		; $45ef
	ldh a,(<hActiveObjectType)	; $45f1
	ldi (hl),a		; $45f3
	ldh a,(<hActiveObject)	; $45f4
	ld (hl),a		; $45f6

	; [this.zh] = -$10
	ld h,d			; $45f7
	ld l,Interaction.zh		; $45f8
	ld (hl),-$10		; $45fa

	ld a,(wDungeonIndex)		; $45fc
	dec a			; $45ff

.ifdef ROM_AGES
	; Override dungeon 6 past ($0b) with present ($05)
	cp $0b			; $4600
	jr nz,+			; $4602
	ld a,$05		; $4604
+
.endif

	; [var03] = index of oam data?
	ld l,Interaction.var03		; $4606
	ld (hl),a		; $4608

	; a *= 3
	ld b,a			; $4609
	add a			; $460a
	add b			; $460b

	ld hl,@essenceOamData		; $460c
	rst_addAToHl			; $460f
	ld e,Interaction.oamTileIndexBase		; $4610
	ld a,(de)		; $4612
	add (hl)		; $4613
	inc hl			; $4614
	ld (de),a		; $4615

	; e = Interaction.oamFlags
	dec e			; $4616
	ldi a,(hl)		; $4617
	ld (de),a		; $4618
	ld a,(hl)		; $4619
	call interactionSetAnimation		; $461a
	jp objectSetVisible81		; $461d


; Each row is sprite data for an essence.
;   b0: Which tile index to start at (in gfx_essences.bin)
;   b1: palette (/ flags)
;   b2: which layout to use (2-tile or 4-tile)
@essenceOamData:
.ifdef ROM_AGES
	.db $00 $01 $01
	.db $04 $00 $02
	.db $06 $03 $02
	.db $08 $02 $02
	.db $0a $00 $02
	.db $0c $00 $02
	.db $0e $01 $01
	.db $12 $05 $01
.else
	.db $14 $00 $02
	.db $10 $01 $02
	.db $06 $05 $01
	.db $0a $04 $02
	.db $16 $05 $02
	.db $0c $04 $01
	.db $02 $02 $01
	.db $00 $03 $02
.endif


; State 1: waiting for Link to approach.
@state1:
	; Update z position every 4 frames
	ld a,(wFrameCounter)	; $4638
	and $03			; $463b
	ret nz			; $463d
	ld h,d			; $463e
	ld l,Interaction.counter1		; $463f
	inc (hl)		; $4641
	ld a,(hl)		; $4642
	and $0f			; $4643
	ld hl,@essenceFloatOffsets		; $4645
	rst_addAToHl			; $4648
	ld a,(hl)		; $4649
	add $f0			; $464a
	ld e,Interaction.zh		; $464c
	ld (de),a		; $464e

	; Check various conditions for the essence to fall
	ld a,(wLinkInAir)		; $464f
	or a			; $4652
	ret nz			; $4653
	ld a,(wLinkGrabState)		; $4654
	or a			; $4657
	ret nz			; $4658
	ld b,$04		; $4659
	call objectCheckCenteredWithLink		; $465b
	ret nc			; $465e
	ld c,$14		; $465f
	call objectCheckLinkWithinDistance		; $4661
	ret nc			; $4664
	cp $04			; $4665
	ret nz			; $4667

	; Link has approached, essence will fall now.

	call clearAllParentItems		; $4668
	ld a,$81		; $466b
	ld (wDisabledObjects),a		; $466d
	ld (wDisableLinkCollisionsAndMenu),a		; $4670
	ld hl,w1Link.direction		; $4673
	ld (hl),DIR_UP		; $4676

	; Set angle, speed
	call objectGetAngleTowardLink		; $4678
	ld h,d			; $467b
	ld l,Interaction.angle		; $467c
	ld (hl),a		; $467e
	ld l,Interaction.speed		; $467f
	ld (hl),SPEED_80		; $4681

	ld l,Interaction.state		; $4683
	inc (hl)		; $4685

	call darkenRoom		; $4686

	ld a,SND_DROPESSENCE		; $4689
	call playSound		; $468b
	ld a,SNDCTRL_SLOW_FADEOUT		; $468e
	jp playSound		; $4690

@essenceFloatOffsets:
	.db $00 $00 $ff $ff $ff $fe $fe $fe
	.db $fe $fe $fe $ff $ff $ff $ff $00


; State 2: Moving toward Link
@state2:
	call objectGetAngleTowardLink		; $46a3
	ld e,Interaction.angle		; $46a6
	ld (de),a		; $46a8
	call objectApplySpeed		; $46a9
	call objectCheckCollidedWithLink_ignoreZ		; $46ac
	ret nc			; $46af

	ld e,Interaction.collisionRadiusX		; $46b0
	ld a,$06		; $46b2
	ld (de),a		; $46b4
	jp interactionIncState		; $46b5


; State 3: Falling down
@state3:
	ld c,$08		; $46b8
	call objectUpdateSpeedZ_paramC		; $46ba
	jr z,++			; $46bd
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $46bf
	ret nc			; $46c2
++
	ld h,d			; $46c3
	ld l,Interaction.counter1		; $46c4
	ld (hl),30		; $46c6
	jp interactionIncState		; $46c8


; State 4: After delay, begin "essence get" cutscene
@state4:
	call interactionDecCounter1		; $46cb
	ret nz			; $46ce

	; Put Link in a 2-handed item get animation
	ld a,LINK_STATE_04		; $46cf
	ld (wLinkForceState),a		; $46d1
	ld a,$01		; $46d4
	ld (wcc50),a		; $46d6

	call interactionIncState		; $46d9

	; Set this object's position relative to Link
	ld a,(w1Link.yh)		; $46dc
	sub $0e			; $46df
	ld l,Interaction.yh		; $46e1
	ldi (hl),a		; $46e3
	inc l			; $46e4
	ld a,(w1Link.xh)		; $46e5
	ldi (hl),a		; $46e8
	inc l			; $46e9

	; [this.z] = 0
	xor a			; $46ea
	ldi (hl),a		; $46eb
	ld (hl),a		; $46ec

	; Show essence get text
	ld l,Interaction.var03		; $46ed
	ld a,(hl)		; $46ef
	ld hl,@getEssenceTextTable		; $46f0
	rst_addAToHl			; $46f3
	ld b,>TX_0000		; $46f4
	ld c,(hl)		; $46f6
	call showText		; $46f7

	call getThisRoomFlags		; $46fa
	set ROOMFLAG_BIT_ITEM,(hl)		; $46fd

	; Give treasure
	ld e,Interaction.var03		; $46ff
	ld a,(de)		; $4701
	ld c,a			; $4702
	ld a,TREASURE_ESSENCE		; $4703
	jp giveTreasure		; $4705

@getEssenceTextTable:
	.db <TX_000e
	.db <TX_000f
	.db <TX_0010
	.db <TX_0011
	.db <TX_0012
	.db <TX_0013
	.db <TX_0014
	.db <TX_0015


; State 5: waiting for textbox to close
@state5:
	call retIfTextIsActive		; $4710

	call interactionIncState		; $4713
	ld hl,essenceScript_essenceGetCutscene		; $4716
	jp interactionSetScript		; $4719


; State 6: running script (essence get cutscene)
@state6:
	call interactionRunScript		; $471c
	ret nc			; $471f

	call interactionIncState		; $4720
	ld l,Interaction.counter1		; $4723
	ld (hl),30		; $4725


; State 7: After a delay, fade out
@state7:
	call interactionDecCounter1		; $4727
	ret nz			; $472a

	; Warp Link outta there
	ld l,Interaction.var03		; $472b
	ld a,(hl)		; $472d
	add a			; $472e
	ld hl,@essenceWarps		; $472f
	rst_addDoubleIndex			; $4732
	ldi a,(hl)		; $4733
	ld (wWarpDestGroup),a		; $4734
	ldi a,(hl)		; $4737
	ld (wWarpDestRoom),a		; $4738
	ldi a,(hl)		; $473b
	ld (wWarpDestPos),a		; $473c
	ld a,(hl)		; $473f
	ld (wWarpTransition),a		; $4740
	ld a,$83		; $4743
	ld (wWarpTransition2),a		; $4745

	xor a			; $4748
	ld (wActiveMusic),a		; $4749

	jp clearStaticObjects		; $474c


; Each row is warp data for getting an essence.
;   b0: wWarpDestGroup
;   b1: wWarpDestRoom
;   b2: wWarpDestPos
;   b3: wWarpTransition
@essenceWarps:
.ifdef ROM_AGES
	.db $80, $8d, $26, TRANSITION_DEST_SET_RESPAWN
	.db $81, $83, $25, TRANSITION_DEST_SET_RESPAWN
	.db $80, $ba, $55, TRANSITION_DEST_SET_RESPAWN
	.db $80, $03, $35, TRANSITION_DEST_X_SHIFTED
	.db $80, $0a, $17, TRANSITION_DEST_SET_RESPAWN
	.db $83, $0f, $16, TRANSITION_DEST_SET_RESPAWN
	.db $82, $90, $45, TRANSITION_DEST_X_SHIFTED
	.db $81, $5c, $15, TRANSITION_DEST_X_SHIFTED
.else
	.db $80 $96 $44 TRANSITION_DEST_SET_RESPAWN
	.db $80 $8d $24 TRANSITION_DEST_SET_RESPAWN
	.db $80 $60 $25 TRANSITION_DEST_SET_RESPAWN
	.db $80 $1d $13 TRANSITION_DEST_SET_RESPAWN
	.db $80 $8a $25 TRANSITION_DEST_SET_RESPAWN
	.db $80 $00 $34 TRANSITION_DEST_SET_RESPAWN
	.db $80 $d0 $34 TRANSITION_DEST_SET_RESPAWN
	.db $81 $00 $33 TRANSITION_DEST_SET_RESPAWN
.endif


;;
; Pedestal for an essence
; @addr{476f}
_interaction7f_subid01:
	call checkInteractionState		; $476f
	jp nz,objectPreventLinkFromPassing		; $4772

	; Initialization
	ld a,$01		; $4775
	ld (de),a		; $4777
	ld bc,$060a		; $4778
	call objectSetCollideRadii		; $477b

	; Set tile above this one to be solid
	call objectGetTileAtPosition		; $477e
	dec h			; $4781
	ld (hl),$0f		; $4782

.ifdef ROM_SEASONS
	ld a,(wDungeonIndex)		; $4b8e
	cp $06			; $4b91
	jr nz,+			; $4b93
	ld hl,$ce24		; $4b95
	ld (hl),$05		; $4b98
	inc l			; $4b9a
	ld (hl),$0a		; $4b9b
+
.endif

	call interactionInitGraphics		; $4784
	jp objectSetVisible83		; $4787


;;
; The glowing thing behind the essence
; @addr{478a}
_interaction7f_subid02:
	call checkInteractionState		; $478a
	jr nz,@state1			; $478d

@state0:
	ld a,$01		; $478f
	ld (de),a		; $4791
	call interactionInitGraphics		; $4792
	jp objectSetVisible82		; $4795

@state1:
	call @copyEssencePosition		; $4798
	call interactionAnimate		; $479b

	; Flicker visibility when animParameter is nonzero
	ld h,d			; $479e
	ld l,Interaction.animParameter		; $479f
	ld a,(hl)		; $47a1
	or a			; $47a2
	ret z			; $47a3
	ld (hl),$00		; $47a4
	ld l,Interaction.visible		; $47a6
	ld a,$80		; $47a8
	xor (hl)		; $47aa
	ld (hl),a		; $47ab
	ret			; $47ac

@copyEssencePosition:
	ld a,Object.enabled		; $47ad
	call objectGetRelatedObject1Var		; $47af
	jp objectTakePosition		; $47b2
