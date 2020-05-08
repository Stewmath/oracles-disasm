 m_section_force Script_Helper1 NAMESPACE scriptHlp

; ==============================================================================
; INTERACID_FARORE
; ==============================================================================
faroreCheckSecretValidity:
	ld a,(wSecretInputType)		; $4000
	inc a			; $4003
	jr nz,+			; $4004
	xor a			; $4006

@setVar3f
	ld e,Interaction.var3f		; $4007
	ld (de),a		; $4009
	ret			; $400a
+
	ld a,(wTextInputResult)		; $400b
	swap a			; $400e
	and $03			; $4010
	rst_jumpTable			; $4012
.ifdef ROM_AGES
	.dw @jump0
	.dw @jump1Or2
	.dw @jump1Or2
	.dw @jump3
.else
	.dw @jump1Or2
	.dw @jump3
	.dw @jump0
	.dw @jump1Or2
.endif

@jump1Or2:
	; Wrong game
	ld a,$04		; $401b
	jr @setVar3f			; $401d

@jump0:
	; Invalid? Pressed "back"?
	ld a,$03		; $401f
	jr @setVar3f			; $4021

@jump3:
	; Check if we've already told this secret
	ld a,(wTextInputResult)		; $4023
	and $0f			; $4026
.ifdef ROM_AGES
	add GLOBALFLAG_DONE_CLOCK_SHOP_SECRET			; $4028
.else
	add GLOBALFLAG_DONE_KING_ZORA_SECRET			; $4028
.endif
	ld b,a			; $402a
	call checkGlobalFlag		; $402b
	ld a,$02		; $402e
	jr nz,@setVar3f		; $4030

	; Check if we've spoken to the npc needed to trigger the secret
	ld a,b			; $4032
	sub GLOBALFLAG_FIRST_AGES_DONE_SECRET - GLOBALFLAG_FIRST_AGES_BEGAN_SECRET
	call checkGlobalFlag		; $4035
	ld a,$01		; $4038
	jr nz,@setVar3f		; $403a
	ld a,$05		; $403c
	jr @setVar3f			; $403e


faroreShowTextForSecretHint:
	ld a,(wTextInputResult)		; $4040
	and $0f			; $4043
	add <TX_550f			; $4045
	ld c,a			; $4047
	ld b,>TX_5500		; $4048
	jp showText		; $404a


faroreSpawnSecretChest:
	call getFreeInteractionSlot		; $404d
	ret nz			; $4050
	ld (hl),INTERACID_FARORE_GIVEITEM		; $4051
	inc l			; $4053
	ld a,(wTextInputResult)		; $4054
	and $0f			; $4057
	ld (hl),a		; $4059

	ld l,Interaction.yh		; $405a
	ld c,$75		; $405c
	jp setShortPosition_paramC		; $405e

faroreGenerateGameTransferSecret:
	jpab generateGameTransferSecret		; $4061


; ==============================================================================
; INTERACID_DOOR_CONTROLLER
; ==============================================================================

; Update Link's respawn position in case it's on a door that's just about to close
doorController_updateLinkRespawn:
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

	ld e,Interaction.angle		; $407d
	ld a,(de)		; $407f
	rrca			; $4080
	and $03			; $4081
	ld hl,@offsets		; $4083
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

@offsets:
	.db $10 $ff $f0 $01


;;
; Sets wTmpcfc0.normal.doorControllerState to:
;   $00: Nothing to be done.
;   $01: Door should be opened.
;   $02: Door should be closed.
doorController_decideActionBasedOnTriggers:
	ld e,Interaction.var3d		; $40a0
	ld a,(de)		; $40a2
	ld b,a			; $40a3
	ld a,(wActiveTriggers)		; $40a4
	and b			; $40a7
	jr z,@triggerInactive	; $40a8

; If trigger is active, open the door.
	call @checkTileIsShutterDoor		; $40aa
	ld a,$01		; $40ad
	jr z,@end	; $40af
	xor a			; $40b1
	jr @end		; $40b2

; If trigger is inactive, close the door.
@triggerInactive:
	call @checkTileCollision		; $40b4
	ld a,$02		; $40b7
	jr z,@end	; $40b9
	xor a			; $40bb
@end:
	ld (wTmpcfc0.normal.doorControllerState),a		; $40bc
	ret			; $40bf


;;
; @param[out]	zflag	Set if the tile at this object's position is the expected shutter
;			door (the one facing the correct direction)
@checkTileIsShutterDoor:
	ld e,Interaction.angle		; $40c0
	ld a,(de)		; $40c2
	sub $10			; $40c3
	srl a			; $40c5
	ld hl,@tileIndices		; $40c7
	rst_addAToHl			; $40ca
	ld e,Interaction.var3e		; $40cb
	ld a,(de)		; $40cd
	ld c,a			; $40ce
	ld b,>wRoomLayout		; $40cf
	ld a,(bc)		; $40d1
	cp (hl)			; $40d2
	ret			; $40d3

@tileIndices: ; Tile indices for shutter doors
	.db $78 $79 $7a $7b


;;
; @param[out]	zflag	Set if collisions at this object's position are 0
@checkTileCollision:
	ld e,Interaction.var3e		; $40d8
	ld a,(de)		; $40da
	ld c,a			; $40db
	ld b,>wRoomCollisions		; $40dc
	ld a,(bc)		; $40de
	or a			; $40df
	ret			; $40e0


;;
; Set wTmpcfc0.normal.doorControllerState to:
;   $01 if Link is on a minecart which has collided with the door
;   $00 otherwise
doorController_checkMinecartCollidedWithDoor:
	xor a			; $40e1
	ld (wTmpcfc0.normal.doorControllerState),a		; $40e2
	ld a,(wLinkObjectIndex)		; $40e5
	rrca			; $40e8
	ret nc			; $40e9
	call objectCheckCollidedWithLink_ignoreZ		; $40ea
	ret nc			; $40ed
	ld a,$01		; $40ee
	ld (wTmpcfc0.normal.doorControllerState),a		; $40f0
	ret			; $40f3

;;
; Set wTmpcfc0.normal.doorControllerState to:
;   $01 if the tile at this position is a horizontal or vertical track
;   $00 otherwise
doorController_checkTileIsMinecartTrack:
	ld e,Interaction.var3e		; $40f4
	ld a,(de)		; $40f6
	ld c,a			; $40f7
	ld b,>wRoomLayout		; $40f8
	ld a,(bc)		; $40fa
	cp TILEINDEX_TRACK_HORIZONTAL			; $40fb
	ld b,$01		; $40fd
	jr z,+			; $40ff
	cp TILEINDEX_TRACK_VERTICAL			; $4101
	jr z,+			; $4103
	dec b			; $4105
+
	ld a,b			; $4106
	ld (wTmpcfc0.normal.doorControllerState),a		; $4107
	ret			; $410a


;;
; Compares [wNumTorchesLit] with [Interaction.speed]. Sets [wTmpcec0] to $01 if they're
; equal, $00 otherwise.
doorController_checkEnoughTorchesLit:
	ld a,(wNumTorchesLit)		; $410b
	ld b,a			; $410e
	ld e,Interaction.speed		; $410f
	ld a,(de)		; $4111
	cp b			; $4112
	ld a,$01		; $4113
	jr z,+			; $4115
	dec a			; $4117
+
	ld (wTmpcec0),a		; $4118
	ret			; $411b


; ==============================================================================
; INTERACID_SHOPKEEPER
; ==============================================================================

;;
; @addr{411c}
shopkeeper_take10Rupees:
	ld a,RUPEEVAL_10		; $411c
	jp removeRupeeValue		; $411e


.ifdef ROM_SEASONS
;;
; Located elsewhere in Ages
; @param	d	Interaction index (should be of type INTERACID_TREASURE)
; @addr{451e}
interactionLoadTreasureData:
	ld e,Interaction.subid	; $451e
	ld a,(de)		; $4520
	ld e,Interaction.var30		; $4521
	ld (de),a		; $4523
	ld hl,treasureObjectData		; $4524
--
	call multiplyABy4		; $4527
	add hl,bc		; $452a
	bit 7,(hl)		; $452b
	jr z,+			; $452d

	inc hl			; $452f
	ldi a,(hl)		; $4530
	ld h,(hl)		; $4531
	ld l,a			; $4532
	ld e,Interaction.var03		; $4533
	ld a,(de)		; $4535
	jr --			; $4536
+
	; var31 = spawn mode
	ldi a,(hl)		; $4538
	ld b,a			; $4539
	swap a			; $453a
	and $07			; $453c
	ld e,Interaction.var31		; $453e
	ld (de),a		; $4540

	; var32 = collect mode
	ld a,b			; $4541
	and $07			; $4542
	inc e			; $4544
	ld (de),a		; $4545

	; var33 = ?
	ld a,b			; $4546
	and $08			; $4547
	inc e			; $4549
	ld (de),a		; $454a

	; var34 = parameter (value of 'c' for "giveTreasure")
	ldi a,(hl)		; $454b
	inc e			; $454c
	ld (de),a		; $454d

	; var35 = low text ID
	ldi a,(hl)		; $454e
	inc e			; $454f
	ld (de),a		; $4550

	; subid = graphics to use
	ldi a,(hl)		; $4551
	ld e,Interaction.subid		; $4552
	ld (de),a		; $4554
	ret			; $4555


createBossDeathExplosion:
	call getFreePartSlot		; $4677
	ret nz			; $467a
	ld (hl),PARTID_BOSS_DEATH_EXPLOSION		; $467b
	jp objectCopyPosition		; $467d
.endif


; ==============================================================================
; INTERACID_MOVING_PLATFORM
; ==============================================================================

;;
; The moving platform has a custom "script format".
; @addr{4121}
movingPlatform_loadScript:
	ld a,(wDungeonIndex)		; $4121
	ld b,a			; $4124
	inc a			; $4125
	jr nz,@inDungeon	; $4126

	; Not in dungeon
.ifdef ROM_AGES
	ld hl,_movingPlatform_scriptTable		; $4128
.else
	ld hl,_movingPlatform_nonDungeonScriptTable
.endif
	jr @loadScript		; $412b

@inDungeon:
	ld a,b			; $412d
	ld hl,_movingPlatform_scriptTable		; $412e
	rst_addDoubleIndex			; $4131
	ldi a,(hl)		; $4132
	ld h,(hl)		; $4133
	ld l,a			; $4134

@loadScript:
	ld e,Interaction.var32		; $4135
	ld a,(de)		; $4137
	rst_addDoubleIndex			; $4138
	ldi a,(hl)		; $4139
	ld h,(hl)		; $413a
	ld l,a			; $413b
	jr _movingPlatform_setScript		; $413c

movingPlatform_runScript:
	ld e,Interaction.scriptPtr		; $413e
	ld a,(de)		; $4140
	ld l,a			; $4141
	inc e			; $4142
	ld a,(de)		; $4143
	ld h,a			; $4144

@nextOpcode:
	ldi a,(hl)		; $4145
	push hl			; $4146
	rst_jumpTable			; $4147
	.dw @opcode00
	.dw @opcode01
	.dw @opcode02
	.dw @opcode03
	.dw @opcode04
	.dw @opcode05
	.dw @opcode06
	.dw @opcode07
	.dw @opcode08
	.dw @opcode09
	.dw @opcode0a
	.dw @opcode0b

; Wait for the given number of frames
@opcode00:
@opcode06:
@opcode07:
	pop hl			; $4160
	ldi a,(hl)		; $4161
	ld e,Interaction.counter1		; $4162
	ld (de),a		; $4164
	ld e,Interaction.state2		; $4165
	xor a			; $4167
	ld (de),a		; $4168
	jr _movingPlatform_setScript		; $4169

; Move at the current angle for the given number of frames
@opcode01:
	pop hl			; $416b
	ldi a,(hl)		; $416c
	ld e,Interaction.counter1		; $416d
	ld (de),a		; $416f
	ld e,Interaction.state2		; $4170
	ld a,$01		; $4172
	ld (de),a		; $4174
	jr _movingPlatform_setScript		; $4175

; Set angle
@opcode02:
	pop hl			; $4177
	ldi a,(hl)		; $4178
	ld e,Interaction.angle		; $4179
	ld (de),a		; $417b
	jr @nextOpcode		; $417c

; Set speed
@opcode03:
	pop hl			; $417e
	ldi a,(hl)		; $417f
	ld e,Interaction.speed		; $4180
	ld (de),a		; $4182
	jr @nextOpcode		; $4183

; Jump somewhere (used for looping)
@opcode04:
	pop hl			; $4185
	ld a,(hl)		; $4186
	call s8ToS16		; $4187
	add hl,bc		; $418a
	jr @nextOpcode		; $418b

; Hold execution until Link is on
@opcode05:
	pop hl			; $418d
	ld a,(wLinkRidingObject)		; $418e
	cp d			; $4191
	jr nz,@@linkNotOn	; $4192
	inc hl			; $4194
	jr @nextOpcode		; $4195

@@linkNotOn:
	dec hl			; $4197
	ld a,$01		; $4198
	ld e,Interaction.counter1		; $419a
	ld (de),a		; $419c
	xor a			; $419d
	ld e,Interaction.state2		; $419e
	ld (de),a		; $41a0
	jr _movingPlatform_setScript		; $41a1

; Move up
@opcode08:
	ld a,$00		; $41a3
	jr @moveAtAngle		; $41a5

; Move right
@opcode09:
	ld a,$08		; $41a7
	jr @moveAtAngle		; $41a9

 ; Move down
@opcode0a:
	ld a,$10		; $41ab
	jr @moveAtAngle		; $41ad

 ; Move left
@opcode0b:
	ld a,$18		; $41af

@moveAtAngle:
	ld e,Interaction.angle		; $41b1
	ld (de),a		; $41b3
	jr @opcode01		; $41b4

;;
; @addr{41b6}
_movingPlatform_setScript:
	ld e,Interaction.scriptPtr		; $41b6
	ld a,l			; $41b8
	ld (de),a		; $41b9
	inc e			; $41ba
	ld a,h			; $41bb
	ld (de),a		; $41bc
	ret			; $41bd

.include "build/data/movingPlatformScriptTable.s"

; ==============================================================================
; INTERACID_ESSENCE
; ==============================================================================

;;
; @addr{4248}
essence_createEnergySwirl:
	call objectGetPosition		; $4248
	ld a,$ff		; $424b
	jp createEnergySwirlGoingIn		; $424d

;;
; @addr{4250}
essence_stopEnergySwirl:
	ld a,$01		; $4250
	ld (wDeleteEnergyBeads),a		; $4252
	ret			; $4255

; ==============================================================================
; INTERACID_VASU
; ==============================================================================

;;
; @addr{4256}
vasu_giveRingBox:
	call getFreeInteractionSlot		; $4256
	ldbc TREASURE_RING_BOX, $00		; $4259
	ld (hl),INTERACID_TREASURE		; $425c
	inc l			; $425e
	ld (hl),b		; $425f
	inc l			; $4260
	ld (hl),c		; $4261
	ld l,Interaction.yh		; $4262
	ld a,(w1Link.yh)		; $4264
	ldi (hl),a		; $4267
	inc l			; $4268
	ld a,(w1Link.xh)		; $4269
	ld (hl),a		; $426c
	ret			; $426d

;;
; @param	a	$00 to display unappraised rings, $01 for appraised ring list
; @addr{426e}
vasu_openRingMenu:
	ld (wRingMenu_mode),a		; $426e
	ld a,$01		; $4271
	ld (wDisabledObjects),a		; $4273
	ld a,$04		; $4276
	jp openMenu		; $4278

;;
; @addr{427b}
redSnake_openSecretInputMenu:
	ld a,$02		; $427b
	jp openSecretInputMenu		; $427d

;;
; @addr{4280}
redSnake_generateRingSecret:
	ld a,GLOBALFLAG_RING_SECRET_GENERATED		; $4280
	call setGlobalFlag		; $4282
	ldbc SECRETFUNC_GENERATE_SECRET, $02		; $4285
	jp secretFunctionCaller		; $4288

;;
; @addr{428b}
blueSnake_linkOrFortune:
	ld e,Interaction.state		; $428b
	ld a,$05		; $428d
	ld (de),a		; $428f
	xor a			; $4290
	inc e			; $4291
	ld (de),a		; $4292

	; Initialize gameID if necessary
	ld b,$03		; $4293
	call secretFunctionCaller		; $4295

	call serialFunc_0c85		; $4298
	ld a,(wSelectedTextOption)		; $429b
	ld e,Interaction.var39		; $429e
	ld (de),a		; $42a0

	ld bc,TX_300e		; $42a1
	or a			; $42a4
	jr z,@showText	; $42a5

	ld e,Interaction.state2		; $42a7
	ld a,$03		; $42a9
	ld (de),a		; $42ab
	ld bc,TX_3028		; $42ac
@showText:
	jp showText		; $42af

;;
; Checks for 1000 enemies ring, 1000 rupee ring, victory ring. Writes a value to var3b
; indicating the action to be taken, and a ring index to var3a if applicable.
; @addr{42b2}
vasu_checkEarnedSpecialRing:
	ld a,GLOBALFLAG_1000_ENEMIES_KILLED		; $42b2
	call @checkFlagSet		; $42b4
	jr nz,@setRingAndAction	; $42b7

	ld a,GLOBALFLAG_10000_RUPEES_COLLECTED		; $42b9
	call @checkFlagSet		; $42bb
	jr nz,@setRingAndAction	; $42be

	ld a,GLOBALFLAG_BEAT_GANON		; $42c0
	call @checkFlagSet		; $42c2
	jr nz,@setRingAndAction	; $42c5

	ld a,$03		; $42c7
@setAction:
	ld e,Interaction.var3b		; $42c9
	ld (de),a		; $42cb
	ret			; $42cc

@setRingAndAction:
	ld e,Interaction.var3a		; $42cd
	ld (de),a		; $42cf
	sub SLAYERS_RING ; WEALTH_RING should be right after
	jr @setAction		; $42d2

; @param[otu]	a	Ring to give (if earned)
; @param[out]	zflag	nz if ring should be given
@checkFlagSet:
	; Check if ring earned
	ld c,a			; $42d4
	call checkGlobalFlag		; $42d5
	jr z,@flagNotSet	; $42d8

	; Check if ring obtained already
	ld a,c			; $42da
	add $04			; $42db
	ld c,a			; $42dd
	call checkGlobalFlag		; $42de
	jr nz,@flagNotSet	; $42e1
	ld a,c			; $42e3
	call setGlobalFlag		; $42e4
	ld a,c			; $42e7
	add $30			; $42e8
	ret			; $42ea
@flagNotSet:
	xor a			; $42eb
	ret			; $42ec

;;
; @addr{42ed}
vasu_giveFriendshipRing:
	ld a,FRIENDSHIP_RING		; $42ed
	jr ++		; $42ef

vasu_giveHundredthRing:
	ld a,HUNDREDTH_RING		; $42f1
	jr ++		; $42f3

vasu_giveRingInVar3a:
	ld e,Interaction.var3a		; $42f5
	ld a,(de)		; $42f7
++
	ld b,a			; $42f8
	ld c,$00		; $42f9
	jp giveRingToLink		; $42fb


; ==============================================================================
; INTERACID_GAME_COMPLETE_DIALOG
; ==============================================================================
gameCompleteDialog_markGameAsComplete:
	xor a			; $42fe
	ld (wMapleKillCounter),a		; $42ff
	inc a			; $4302
	ld (wFileIsCompleted),a		; $4303
.ifdef ROM_AGES
	ld a,<TX_051c		; $4306
	ld (wMakuMapTextPresent),a		; $4308
	ld a,<TX_058c		; $430b
	ld (wMakuMapTextPast),a		; $430d
.endif
	ld a,GLOBALFLAG_FINISHEDGAME		; $4310
	jp setGlobalFlag		; $4312

.ENDS
