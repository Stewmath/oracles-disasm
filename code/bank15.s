.BANK $15 SLOT 1
.ORG 0

 m_section_force Script_Helper1 NAMESPACE scriptHlp

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
	.dw @jump0
	.dw @jump1Or2
	.dw @jump1Or2
	.dw @jump3

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
	add GLOBALFLAG_5a			; $4028
	ld b,a			; $402a
	call checkGlobalFlag		; $402b
	ld a,$02		; $402e
	jr nz,@setVar3f		; $4030

	; Check if we've spoken to the npc needed to trigger the secret
	ld a,b			; $4032
	sub GLOBALFLAG_5a - GLOBALFLAG_50			; $4033
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


; Sets $cfc1 to:
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
	ld ($cfc1),a		; $40bc
	ret			; $40bf


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


; @param[out]	zflag	Set if collisions at this object's position are 0
@checkTileCollision:
	ld e,Interaction.var3e		; $40d8
	ld a,(de)		; $40da
	ld c,a			; $40db
	ld b,>wRoomCollisions		; $40dc
	ld a,(bc)		; $40de
	or a			; $40df
	ret			; $40e0


; Set $cfc1 to:
;   $01 if Link is on a minecart which has collided with the door
;   $00 otherwise
doorController_checkMinecartCollidedWithDoor:
	xor a			; $40e1
	ld ($cfc1),a		; $40e2
	ld a,(wLinkObjectIndex)		; $40e5
	rrca			; $40e8
	ret nc			; $40e9
	call objectCheckCollidedWithLink_ignoreZ		; $40ea
	ret nc			; $40ed
	ld a,$01		; $40ee
	ld ($cfc1),a		; $40f0
	ret			; $40f3

; Set $cfc1 to:
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
	ld ($cfc1),a		; $4107
	ret			; $410a


; Compares [wNumTorchesLit] with [Interaction.speed]. Sets [$cec0] to $01 if they're
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

;;
; @addr{411c}
shopkeeper_take10Rupees:
	ld a,RUPEEVAL_10		; $411c
	jp removeRupeeValue		; $411e

;;
; @addr{4121}
movingPlatform_func1:
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

movingPlatform_func2:
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
	jp openSecretInputMenu		; $427d
	ld a,GLOBALFLAG_28		; $4280
	call setGlobalFlag		; $4282
	ld bc,$0002		; $4285
	jp secretFunctionCaller		; $4288
	ld e,$44		; $428b
	ld a,$05		; $428d
	ld (de),a		; $428f
	xor a			; $4290
	inc e			; $4291
	ld (de),a		; $4292
	ld b,$03		; $4293
	call secretFunctionCaller		; $4295
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
	ld (wFileIsCompleted),a		; $4303
	ld a,$1c		; $4306
	ld (wMakuMapTextPresent),a		; $4308
	ld a,$8c		; $430b
	ld (wMakuMapTextPast),a		; $430d
	ld a,GLOBALFLAG_FINISHEDGAME		; $4310
	jp setGlobalFlag		; $4312

.ENDS


 m_section_free "Object_Pointers" namespace "objectData"

;;
; @addr{4315}
getObjectDataAddress:
	ld a,(wActiveGroup)		; $4315
	ld hl,objectDataGroupTable
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


	.include "objects/pointers.s"

.ENDS

.orga $4f3b

 m_section_force "Bank_15" NAMESPACE scriptHlp

setTrigger2IfTriggers0And1Set:
	ld hl,wActiveTriggers		; $4f3b
	ld a,(hl)		; $4f3e
	and $03			; $4f3f
	cp $03			; $4f41
	jr nz,+			; $4f43
	set 2,(hl)		; $4f45
	ret			; $4f47
+
	res 2,(hl)		; $4f48
	ret			; $4f4a

;;
; Creates a part object (PARTID_06) at each unlit torch, allowing them to be lit.
; @addr{4f4b}
makeTorchesLightable:
	call getFreeInteractionSlot		; $4f4b
	ret nz			; $4f4e

	ld (hl),INTERACID_CREATE_OBJECT_AT_EACH_TILEINDEX		; $4f4f
	inc l			; $4f51
	ld (hl),TILEINDEX_UNLIT_TORCH		; $4f52

	ld l,Interaction.yh		; $4f54
	ld (hl),PARTID_06		; $4f56
	ld l,Interaction.xh		; $4f58
	ld (hl),$10		; $4f5a
	ret			; $4f5c

;;
; Unused?
; @addr{4f5d}
func_4f5d:
	call getThisRoomFlags		; $4f5d
	set 7,(hl)		; $4f60
	ld a,SND_SOLVEPUZZLE		; $4f62
	jp playSound		; $4f64

;;
; @param	b	Length of bridge (in 8x8 tiles)
; @param	c	Direction the bridge should extend (0-3)
; @param	e	Position to start at
; @addr{4f67}
_spawnBridge:
	call getFreePartSlot		; $4f67
	ret nz			; $4f6a
	ld (hl),PARTID_BRIDGE_SPAWNER		; $4f6b
	ld l,Part.counter2		; $4f6d
	ld (hl),b		; $4f6f
	ld l,Part.angle		; $4f70
	ld (hl),c		; $4f72
	ld l,Part.yh		; $4f73
	ld (hl),e		; $4f75
	ret			; $4f76

mermaidsCave_spawnBridge_room38:
	call getThisRoomFlags		; $4f77
	set 6,(hl)		; $4f7a
	ld a,SND_SOLVEPUZZLE		; $4f7c
	call playSound		; $4f7e
	ld bc,$0800		; $4f81
	ld e,$69		; $4f84
	jp _spawnBridge		; $4f86

herosCave_spawnBridge_roomc9:
	call getThisRoomFlags		; $4f89
	set 6,(hl)		; $4f8c
	ld a,SND_SOLVEPUZZLE		; $4f8e
	call playSound		; $4f90
	ld bc,$0803		; $4f93
	ld e,$2a		; $4f96
	jp _spawnBridge		; $4f98

ancientTomb_startWallRetractionCutscene:
	ld a,CUTSCENE_ANCIENT_TOMB_WALL		; $4f9b
	ld (wCutsceneTrigger),a		; $4f9d
	jp resetLinkInvincibility		; $4fa0

;;
; @addr{4fa3}
moonlitGrotto_enableControlAfterBreakingCrystal:
	xor a			; $4fa3
	ld (wDisabledObjects),a		; $4fa4
	ld (wMenuDisabled),a		; $4fa7
_label_15_031:
	ld ($cc91),a		; $4faa
	ld ($cc90),a		; $4fad
	ret			; $4fb0

;;
; Show some text based on bipin's subid (expected to be 1-9).
; @addr{4fb1}
bipin_showText_subid1To9:
	ld e,Interaction.subid		; $4fb1
	ld a,(de)		; $4fb3
	ld hl,@textIndices-1		; $4fb4
	rst_addAToHl			; $4fb7
	ld b,>TX_4300		; $4fb8
	ld c,(hl)		; $4fba
	jp showText		; $4fbb

@textIndices:
	.db <TX_4302
	.db <TX_4303
	.db <TX_4303
	.db <TX_4304
	.db <TX_4305
	.db <TX_4306
	.db <TX_4307
	.db <TX_4308
	.db <TX_4308


; Script for the "past" version of bipin
bipinScript3:
	initcollisions
@loop:
	enableinput
	checkabutton
	disableinput
	jumpifroomflagset $20 @alreadyGaveSeed
	showtext TX_4311
	giveitem TREASURE_GASHA_SEED $08
	wait 1
	checktext
	showtext TX_4312
	jump2byte @loop
@alreadyGaveSeed:
	showtext TX_4313
	jump2byte @loop


;;
; @param	a	Value to write
; @addr{4fe1}
setNextChildStage:
	ld hl,wNextChildStage		; $4fe1
	ld (hl),a		; $4fe4
	ret			; $4fe5

;;
; @param	a	Bit to set
; @addr{4fe6}
setc6e2Bit:
	ld hl,wc6e2		; $4fe6
	jp setFlag		; $4fe9

;;
; @param	a	Bit to check
; @addr{4fec}
checkc6e2BitSet:
	ld hl,wc6e2		; $4fec
	call checkFlag		; $4fef
	ld a,$01		; $4ff2
	jr nz,+			; $4ff4
	xor a			; $4ff6
+
	ld e,Interaction.var3b		; $4ff7
	ld (de),a		; $4ff9
	ret			; $4ffa

;;
; @param	a	Rupee value (see constants/rupeeValues.s)
; @addr{4ffb}
blossom_checkHasRupees:
	call cpRupeeValue		; $4ffb
	ld e,Interaction.var3c		; $4ffe
	ld (de),a		; $5000
	ret			; $5001

;;
; @addr{5002}
blossom_addValueToChildStatus:
	ld hl,wChildStatus		; $5002
	add (hl)		; $5005
	ld (hl),a		; $5006
	ret			; $5007

;;
; After naming the child, wChildStatus gets set to a random value from $01-$03.
; @addr{5008}
blossom_decideInitialChildStatus:
	ld hl,wKidName		; $5008
	ld b,$00		; $500b
@nextChar:
	ldi a,(hl)		; $500d
	or a			; $500e
	jr z,@parsedName		; $500f
	and $0f			; $5011
	add b			; $5013
	ld b,a			; $5014
	jr @nextChar		; $5015
@parsedName:
	ld a,b			; $5017
--
	sub $03			; $5018
	jr nc,--		; $501a
	add $04			; $501c
	ld (wChildStatus),a		; $501e
	ret			; $5021

;;
; @addr{5022}
blossom_openNameEntryMenu:
	ld a,$07		; $5022
	jp openMenu		; $5024

; @addr{5027}
veranFaceCutsceneScript:
	disableinput
	checkpalettefadedone
	wait 60
	writememory w1Link.direction $00
	wait 30
	playsound SND_LIGHTTORCH
	writeobjectbyte Interaction.visible $80
	wait 30
	showtext TX_5613
	scriptend

;;
; Writes 0 to var3f if Link has no rupees, 1 otherwise.
; @addr{5039}
oldMan_takeRupees:
	ld hl,wNumRupees		; $5039
	ldi a,(hl)		; $503c
	or (hl)			; $503d
	ld e,Interaction.var3f		; $503e
	ld (de),a		; $5040
	ret z			; $5041
	ld a,$01		; $5042
	ld (de),a		; $5044
	ld e,Interaction.subid		; $5045
	ld a,(de)		; $5047
	ld hl,_oldMan_rupeeValues		; $5048
	rst_addAToHl			; $504b
	ld a,(hl)		; $504c
	jp removeRupeeValue		; $504d

;;
; @addr{5050}
oldMan_giveRupees:
	ld e,Interaction.subid		; $5050
	ld a,(de)		; $5052
	ld hl,_oldMan_rupeeValues		; $5053
	rst_addAToHl			; $5056
	ld c,(hl)		; $5057
	ld a,TREASURE_RUPEES		; $5058
	jp giveTreasure		; $505a

_oldMan_rupeeValues:
	.db RUPEEVAL_200
	.db RUPEEVAL_100


;;
; @addr{505f}
shootingGallery_beginGame:
	; Spawn a new INTERACID_SHOOTING_GALLERY with subid 3 (runs the game)
	call getFreeInteractionSlot		; $505f
	ret nz			; $5062
	ld (hl),INTERACID_SHOOTING_GALLERY		; $5063
	inc l			; $5065
	ld (hl),$03		; $5066
	inc l			; $5068

	; New interaction's [var03] = this interction's [subid]
	ld e,Interaction.subid		; $5069
	ld a,(de)		; $506b
	ld (hl),a		; $506c
	ret			; $506d

;;
; @addr{506e}
shootingGallery_cpScore:
	call @cpScore		; $506e
	jp _writeFlagsTocddb		; $5071

@cpScore:
	ld hl,@scores		; $5074
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
	jr nz,+			; $5085
	inc a			; $5087
	ret			; $5088
+
	xor a			; $5089
	ret			; $508a

@scores:
	; Lynna village scores
	.dw $0350 ; 0
	.dw $0250 ; 1
	.dw $0150 ; 2
	.dw $0050 ; 3

	; Goron gallery scores
	.dw $0400 ; 4
	.dw $0300 ; 5
	.dw $0200 ; 6
	.dw $0100 ; 7

	; Biggoron's sword score
	.dw $0300 ; 8

;;
; @addr{509d}
shootingGallery_equipSword:
	ld hl,hFF8A		; $509d
	ld a,(wInventoryA)		; $50a0
	cp ITEMID_SWORD			; $50a3
	jr nz,@equipOnB		; $50a5

@equipOnA:
	xor a			; $50a7
	ldi (hl),a		; $50a8
	ld a,ITEMID_SWORD		; $50a9
	ld (hl),a		; $50ab
	jr _shootingGallery_changeEquips			; $50ac

@equipOnB:
	ld a,ITEMID_SWORD		; $50ae
	ldi (hl),a		; $50b0
	xor a			; $50b1
	ld (hl),a		; $50b2
	jr _shootingGallery_changeEquips		; $50b3

;;
; @addr{50b5}
shootingGallery_equipBiggoronSword:
	ld hl,hFF8A		; $50b5
	ld a,ITEMID_BIGGORON_SWORD		; $50b8
	ldi (hl),a		; $50ba
	ld (hl),a		; $50bb

;;
; Saves equipped items to $cfd7-$cfd8, then equips new items.

; @param	hFF8A	B-button item to equip
; @param	hFF8B	A-button item to equip
; @addr{50bc}
_shootingGallery_changeEquips:
	ld bc,wInventoryB		; $50bc
	ld hl,wShootingGallery.savedBItem	; $50bf
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

;;
; @addr{50d3}
shootingGallery_restoreEquips:
	ld bc,wInventoryB		; $50d3
	ld hl,wShootingGallery.savedBItem		; $50d6
	ldi a,(hl)		; $50d9
	ld (bc),a		; $50da
	inc c			; $50db
	ldi a,(hl)		; $50dc
	ld (bc),a		; $50dd
	ld a,$ff		; $50de
	ld (wStatusBarNeedsRefresh),a		; $50e0
	ret			; $50e3

;;
; @addr{50e4}
func_50e4:
	ld a,(w1Link.yh)		; $50e4
	ld b,a			; $50e7
	ld a,(w1Link.xh)		; $50e8
	ld c,a			; $50eb
	ld a,$6e		; $50ec
	jp createEnergySwirlGoingIn		; $50ee

;;
; @addr{50f1}
createSparkle:
	ld b,INTERACID_SPARKLE		; $50f1
	jp objectCreateInteractionWithSubid00		; $50f3

;;
; Writes to the tilemap to replace all "target" tiles with floor tiles.
; @addr{50f6}
shootingGallery_removeAllTargets:
	jpab interactionBank1.shootingGallery_removeAllTargets		; $50f6

;;
; @param	a	0 to create the entrance, 2 to remove it
; @addr{50fe}
shootingGallery_setEntranceTiles:
	ld hl,@positions		; $50fe
	rst_addAToHl			; $5101
	ld c,$74		; $5102
--
	ldi a,(hl)		; $5104
	push hl			; $5105
	call setTile		; $5106
	pop hl			; $5109
	inc c			; $510a
	ld a,c			; $510b
	cp $76			; $510c
	jr nz,--		; $510e
	ret			; $5110

@positions:
	.db $e0 $e1 ; Create entrance
	.db $c6 $c6 ; Remove entrance

;;
; Sets bit 7 in $cddb if Link has the give number of rupees, clears it otherwise.
;
; @param	a	Rupee value
; @addr{5115}
shootingGallery_checkLinkHasRupees:
	call cpRupeeValue		; $5115

;;
; @addr{5118}
_writeFlagsTocddb:
	push af			; $5118
	pop bc			; $5119
	ld a,c			; $511a
	ld ($cddb),a		; $511b
	ret			; $511e

;;
; @param	a	Amount to give
; @addr{511f}
giveRupees:
	ld c,a			; $511f
	ld a,TREASURE_RUPEES		; $5120
	jp giveTreasure		; $5122

;;
; Unused?
; @addr{5125}
giveHealthRefill:
	ld c,$40		; $5125
	jr ++			; $5127

;;
; @addr{5129}
shootingGallery_giveOneHeart:
	ld c,$04		; $5129
	jr ++			; $512b

;;
; Unused?
;
; @param	a	Amount of health to give (in quarters of heart)
; @addr{512d}
giveHealth:
	ld c,a			; $512d
++
	ld a,TREASURE_HEART_REFILL		; $512e
	jp giveTreasure		; $5130

;;
; @param	a	Ring to give
; @addr{5133}
giveRingAToLink:
	ld b,a			; $5133
	ld c,$00		; $5134
	jp giveRingToLink		; $5136

;;
; @addr{5139}
shootingGallery_giveRandomRingToLink:
	call getRandomNumber		; $5139
	and $0f			; $513c
	ld hl,@ringList		; $513e
	rst_addAToHl			; $5141
	ld a,(hl)		; $5142
	jr giveRingAToLink		; $5143

@ringList:
	.db LIGHT_RING_L2
	.db RED_LUCK_RING
	.db RED_LUCK_RING
	.db RED_LUCK_RING
	.db RED_LUCK_RING
	.db BLUE_HOLY_RING
	.db BLUE_HOLY_RING
	.db BLUE_HOLY_RING
	.db BLUE_HOLY_RING
	.db BLUE_HOLY_RING
	.db OCTO_RING
	.db OCTO_RING
	.db OCTO_RING
	.db OCTO_RING
	.db OCTO_RING
	.db OCTO_RING

;;
; @param	a	Link's direction
; @addr{5155}
forceLinkDirection:
	ld hl,w1Link.direction		; $5155
	ld (hl),a		; $5158
	jp setLinkForceStateToState08		; $5159

;;
; @addr{515c}
shootingGallery_initLinkPosition:
	ld a,$00		; $515c
	ldbc $60,$50		; $515e
	jr ++			; $5161

;;
; @addr{5163}
shootingGallery_initLinkPositionAfterGame:
	ld a,$01		; $5163
	ldbc $68,$68		; $5165
	jr ++			; $5168

;;
; @addr{516a}
shootingGallery_initLinkPositionAfterBiggoronGame:
	ld a,$03		; $516a
	ldbc $68,$38		; $516c
++
	ld hl,w1Link.yh		; $516f
	ld (hl),b		; $5172
	ld l,<w1Link.xh		; $5173
	ld (hl),c		; $5175

;;
; @addr{5176}
forceLinkDirectionAndPutOnGround:
	ld hl,w1Link.direction		; $5176
	ld (hl),a		; $5179
	call putLinkOnGround		; $517a
	jp setLinkForceStateToState08		; $517d

;;
; @addr{5180}
checkIsLinkedGameForScript:
	call checkIsLinkedGame		; $5180
	jp _writeFlagsTocddb		; $5183

;;
; @addr{5186}
shootingGallery_checkIsNotLinkedGame:
	call checkIsLinkedGame		; $5186
	call _writeFlagsTocddb		; $5189
	cpl			; $518c
	ld ($cddb),a		; $518d
	ret			; $5190

;;
; Makes an npc jump (speed: -$200)
; @addr{5191}
beginJump:
	ld h,d			; $5191
	ld l,Interaction.speedZ		; $5192
	ld (hl),$00		; $5194
	inc hl			; $5196
	ld (hl),$fe		; $5197
	ld a,SND_JUMP		; $5199
	jp playSound		; $519b

;;
; Updates gravity (uses gravity value $30). Bit 7 of cddb gets set when it lands.
; @addr{519e}
updateGravity:
	ld c,$30		; $519e
	call objectUpdateSpeedZ_paramC		; $51a0
	jp _writeFlagsTocddb		; $51a3

	ld hl,$ccd4		; $51a6
	jr _label_15_043		; $51a9
	ld hl,$cfc0		; $51ab
_label_15_043:
	add (hl)		; $51ae
	ld (hl),a		; $51af
	ret			; $51b0

; @addr{51b1}
shootingGalleryScript_humanNpc_gameDone:
	disableinput
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 shootingGallery_restoreEquips
	asm15 shootingGallery_setEntranceTiles, $00
	asm15 shootingGallery_removeAllTargets
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 shootingGallery_initLinkPositionAfterGame

	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone
	resetmusic
	wait 40

	asm15 shootingGallery_checkIsNotLinkedGame
	jumpifmemoryset $cddb $80 @checkScoreForNormalGame
	jumpifitemobtained TREASURE_FLUTE @normalGame
	jumpifglobalflagset GLOBALFLAG_1d @checkScoreForFluteGame

@normalGame:
	jump2byte @checkScoreForNormalGame

@checkScoreForFluteGame:
	asm15 shootingGallery_cpScore, $03
	jumpifmemoryset $cddb $80 @flutePrize
	jump2byte @noPrize

@flutePrize:
	showtext TX_081b
	wait 30
	giveitem TREASURE_FLUTE $00
	jump2byte @end

@checkScoreForNormalGame:
	asm15 shootingGallery_cpScore, $00
	jumpifmemoryset $cddb $80 @ringPrize

	asm15 shootingGallery_cpScore, $01
	jumpifmemoryset $cddb $80 @gashaSeedPrize

	asm15 shootingGallery_cpScore, $02
	jumpifmemoryset $cddb $80 @thirtyRupeePrize

	asm15 shootingGallery_cpScore, $03
	jumpifmemoryset $cddb $80 @oneHeartPrize

@noPrize:
	showtext TX_0819
	jump2byte @end

@ringPrize:
	showtext TX_0815
	wait 30
	asm15 shootingGallery_giveRandomRingToLink
	jump2byte @end

@gashaSeedPrize:
	showtext TX_0816
	wait 30
	giveitem TREASURE_GASHA_SEED $00
	jump2byte @end

@thirtyRupeePrize:
	showtext TX_0817
	wait 30
	asm15 giveRupees, RUPEEVAL_30
	showtext TX_0005
	jump2byte @end

@oneHeartPrize:
	showtext TX_0818
	wait 30
	showtext TX_0051
	asm15 shootingGallery_giveOneHeart
@end:
	wait 30
	scriptend


shootingGalleryScript_goronNpc_gameDone:
	disableinput
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 shootingGallery_restoreEquips
	asm15 shootingGallery_setEntranceTiles, $00
	asm15 shootingGallery_removeAllTargets
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 shootingGallery_initLinkPositionAfterGame

	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone
	resetmusic
	wait 40

	jumpifroomflagset $20 @normalGame

; Playing for lava juice

	asm15 shootingGallery_cpScore, $07
	jumpifmemoryset $cddb $80 @lavaJuicePrize
	showtext TX_24d9
	jump2byte @end

@lavaJuicePrize:
	showtext TX_24d8
	wait 30
	giveitem TREASURE_LAVA_JUICE $00
	jump2byte @end

; Playing for normal prizes
@normalGame:
	asm15 shootingGallery_cpScore, $04
	jumpifmemoryset $cddb $80 @boomerangPrize

	asm15 shootingGallery_cpScore, $05
	jumpifmemoryset $cddb $80 @gashaSeedPrize

	asm15 shootingGallery_cpScore, $06
	jumpifmemoryset $cddb $80 @twentyBombsPrize

	asm15 shootingGallery_cpScore, $07
	jumpifmemoryset $cddb $80 @thirtyRupeesPrize

	; No prize
	showtext TX_24de
	jump2byte @end

@boomerangPrize:
	jumpifitemobtained TREASURE_BOOMERANG @gashaSeedPrize
	showtext TX_24da
	wait 30
	giveitem TREASURE_BOOMERANG $02
	jump2byte @end

@gashaSeedPrize:
	showtext TX_24db
	wait 30
	giveitem TREASURE_GASHA_SEED $00
	jump2byte @end

@twentyBombsPrize:
	showtext TX_24dc
	wait 30
	giveitem TREASURE_BOMBS $05
	jump2byte @end

@thirtyRupeesPrize:
	showtext TX_24dd
	wait 30
	asm15 giveRupees, RUPEEVAL_30
	showtext TX_0005

@end:
	wait 30
	scriptend

;;
; @addr{52e2}
impa_moveLinkUp32Frames:
	ld a,$20		; $52e2
	ld (wLinkStateParameter),a		; $52e4
	xor a			; $52e7
	ld (w1Link.angle),a		; $52e8
	ld (w1Link.direction),a		; $52eb
	jr ++			; $52ee

;;
; @addr{52f0}
impa_moveLinkRight8Frames:
	ld a,$08		; $52f0
	ld (wLinkStateParameter),a		; $52f2
	ld a,$08		; $52f5
	ld (w1Link.angle),a		; $52f7
++
	ld a,LINK_STATE_FORCE_MOVEMENT		; $52fa
	ld (wLinkForceState),a		; $52fc
	ret			; $52ff

;;
; Resets impa's "oamTileIndexBase" to normal, after referencing a different sprite sheet.
; (Only used for subid 1; her "collapsed" sprite is in another sprite sheet.)
; @addr{5300}
impa_restoreNormalSpriteSheet:
	ld e,Interaction.var3b		; $5300
	ld a,(de)		; $5302
	ld e,Interaction.oamTileIndexBase		; $5303
	ld (de),a		; $5305
	ld e,Interaction.oamFlags		; $5306
	ld a,$02		; $5308
	ld (de),a		; $530a
	ret			; $530b

;;
; Shows text index TX_0131 such that it's non-exitable (cutscene continues automatically)
; @addr{530c}
impa_showZeldaKidnappedTextNonExitable:
	ld bc,TX_0131		; $530c
	jp showTextNonExitable		; $530f

; @addr{5312}
impaScript_rockJustMoved:
	wait 4
	jumpifmemoryeq w1Link.angle $08 @pushedRight

	; Pushed left: Impa needs to move down a bit
	setangle $10
	setspeed SPEED_040
	applyspeed 65
	jump2byte ++

@pushedRight:
	wait 65
++
	wait 120
	setangle $08
	setspeed SPEED_100
	applyspeed $21
	wait 8
	jumpifmemoryeq w1Link.angle $08 ++

	; Pushed left: Impa needs to move back up
	moveup $11
	wait 8
++
	writememory $cfd0 $07
	setanimation $00
	wait 30
	showtext TX_0109
	wait 30
	setspeed SPEED_080
	moveup $20
	scriptend


; Subid 4: cutscene at black tower entrance where Impa warns about Ralph's heritage
; (unlinked)
impaScript4:
	showtext TX_0124
	writememory w1Link.direction DIR_UP
	wait 20
	xorcfc0bit 0
	spawninteraction INTERACID_NAYRU $09 $f8 $48

	setspeed SPEED_100
	movedown $41
	wait 30

	checkobjectbyteeq Interaction.var38 $04
	writeobjectword Interaction.speedZ, -$180
	wait 1
	showtext TX_0125
	xorcfc0bit 1
	checkcfc0bit 2
	showtext TX_0126
	xorcfc0bit 3
	checkcfc0bit 4
	moveup $41
	scriptend

; Subid 4: like above, but for linked game
impaScript5:
	checkmemoryeq $cfd0 $01
	setanimation $00
	checkmemoryeq $cfd0 $02
	setanimation $03
	checkmemoryeq $cfd0 $03
	setanimation $02
	checkobjectbyteeq Interaction.state2, $02

	writememory $cfd0 $05
	setanimation $00
	wait 8
	writeobjectword Interaction.speedZ, -$180

	wait 1
	showtext TX_0125

	writememory $cfd0 $06
	checkmemoryeq $cfd0 $08
	wait 90
	writememory w1Link.direction, DIR_RIGHT
	setspeed SPEED_100
	moveup $21
	writememory w1Link.direction, DIR_UP
	moveleft $11
	moveup $41
	scriptend


; Subid 7: Impa tells you that Zelda's been kidnapped by vire (also handles the cutscene
; after saving Zelda)
impaScript7:
	initcollisions
	setspeed SPEED_100
	jumpifglobalflagset GLOBALFLAG_ZELDA_SAVED_FROM_VIRE, @zeldaSaved

@npcLoop:
	enableinput
	checkabutton
	disableinput
	turntofacelink
	jumpifglobalflagset GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED, @alreadyMoved

	showtext TX_0127
	setangle $18
	applyspeed $10
	setglobalflag GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	jump2byte @npcLoop

@alreadyMoved:
	showtext TX_0129
	jump2byte @npcLoop

@zeldaSaved:
	checkpalettefadedone
	writememory w1Link.xh $50
	wait 60
	asm15 impa_moveLinkUp32Frames

@waitForLinkToMove1:
	wait 16
	jumpifmemoryeq w1Link.state, LINK_STATE_FORCE_MOVEMENT, @waitForLinkToMove1

	writememory w1Link.direction, $01
	asm15 impa_moveLinkRight8Frames
@waitForLinkToMove2:
	wait 16
	jumpifmemoryeq w1Link.state, LINK_STATE_FORCE_MOVEMENT, @waitForLinkToMove2

	writememory w1Link.direction, DIR_UP
	writememory $cfd0 $01
	checkmemoryeq $cfd0 $02
	setzspeed -$0200
	playsound SND_JUMP
	wait 1
	checkobjectbyteeq Interaction.zh, $00

	showtext TX_0128
	wait 30

	showtext TX_0603
	writememory $cfd0 $03
	checkmemoryeq $cfd0 $04
	writememory w1Link.direction, DIR_LEFT
	wait 30

	showtext TX_0604
	writememory $cfd0 $05
	checkmemoryeq $cfd0 $06
	writememory w1Link.direction DIR_UP
	wait 30

	showtext TX_012a
	writememory $cfd0 $07
	moveup $60

	writememory $cfd0 $08
	writememory $cd00 $01
	setglobalflag GLOBALFLAG_GOT_RING_FROM_ZELDA
	scriptend


greatFairyOctorok_createMagicPowderAnimation:
	ld a,SND_MAGIC_POWDER		; $543a
	call playSound		; $543c
	ld bc,$00f8		; $543f
@next:
	call getFreePartSlot		; $5442
	ret nz			; $5445
	ld (hl),PARTID_SPARKLE		; $5446
	ld l,Part.var03		; $5448
	inc (hl)		; $544a
	call objectCopyPositionWithOffset		; $544b
	ld a,c			; $544e
	add $08			; $544f
	ld c,a			; $5451
	cp $18			; $5452
	jr nz,@next		; $5454
	ret			; $5456

;;
; @param	a	Value to add
; @addr{5457}
child_addValueToChildStatus:
	ld hl,wChildStatus		; $5457
	add (hl)		; $545a
	ld (hl),a		; $545b
	ret			; $545c

child_checkHasRupees:
	call cpRupeeValue		; $545d
	ld e,Interaction.var3c		; $5460
	ld (de),a		; $5462
	ret			; $5463

;;
; Stores the response to the "love or courage" question.
; @addr{5464}
child_setStage8ResponseToSelectedTextOption:
	ld hl,wSelectedTextOption		; $5464
	add (hl)		; $5467

;;
; @addr{5468}
child_setStage8Response:
	ld (wChildStage8Response),a		; $5468
	ret			; $546b

;;
; @addr{546c}
child_playMusic:
	ld a,(wChildStage8Response)		; $546c
	or a			; $546f
	jr nz,+			; $5470
	ld a,MUS_ZELDA_SAVED		; $5472
	jp playSound		; $5474
+
	ld a,MUS_PRECREDITS		; $5477
	jp playSound		; $5479

;;
; @addr{547c}
child_giveHeartRefill:
	ld c,$40		; $547c
	jr ++			; $547e

;;
; @addr{5480}
child_giveOneHeart:
	ld c,$04		; $5480
++
	ld a,TREASURE_HEART_REFILL		; $5482
	jp giveTreasure		; $5484

;;
; @param	a	Rupee value
; @addr{5487}
child_giveRupees:
	ld c,a			; $5487
	ld a,TREASURE_RUPEES		; $5488
	jp giveTreasure		; $548a



; Subid $01: Cutscene in Ambi's palace after getting bombs
nayruScript01:
	checkmemoryeq $cfd1 $05
	playsound MUS_LADX_SIDEVIEW
	wait 60

	asm15 objectSetVisible
	setspeed SPEED_100
	movedown $19
	wait 100

	showtext TX_1d01
	wait 30

	movedown $10
	wait 4
	moveright $10
	wait 4
	movedown $10
	wait 4
	moveleft $0a
	wait 60

	showtext TX_1d02
	wait 30
	showtext TX_1306
	writememory $cfd1 $06
	checkmemoryeq $cfd1 $07
	wait 30

	setanimation $06
	wait 120
	asm15 fadeoutToBlackWithDelay, $03
	checkpalettefadedone

	writememory wTextboxFlags TEXTBOXFLAG_ALTPALETTE1
	showtext TX_1d03
	wait 30
	scriptend


; Subid $02: Nayru on maku tree screen after being saved
nayruScript02_part2:
	checkmemoryeq $cfd0 $05
	disableinput
	wait 60
	showtext TX_1d07
	wait 60
	showtext TX_1d09
	wait 30

	writememory $cfd0 $06
	setanimation $04
	playsound SNDCTRL_STOPMUSIC
	playsound SND_AGES
	wait 260

	spawninteraction INTERACID_PLAY_HARP_SONG, $02, $00, $00
	checkcfc0bit 7
	wait 45

	giveitem TREASURE_TUNE_OF_AGES, $00
	setanimation $02
	wait 30
	setdisabledobjectsto11
	wait 30
	writememory $cfd0 $07
	scriptend


; Subid $03: Cutscene with Nayru and Ralph when Link exits the black tower
nayruScript03:
	wait 10

	setanimation $01
	setspeed SPEED_080
	setangle $18
	applyspeed $20
	checkmemoryeq w1Link.yh, $68

	writememory wUseSimulatedInput, $00
	disableinput
	wait 20

	moveright $10
	asm15 forceLinkDirection, DIR_LEFT
	wait 10

	showtext TX_1d0b
	wait 20
	writememory   $cfd0, $02
	checkmemoryeq $cfd0, $03

	asm15 forceLinkDirection, DIR_LEFT
	wait 10
	showtext TX_1d0c
	wait 40
	writememory $cfd0 $04
	wait 16

	setspeed SPEED_100
	moveright $10
	wait 6

	movedown $28
	scriptend


; Subid $07: Cutscene with the vision of Nayru teaching you Tune of Echoes
nayruScript07:
	wait 12
	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE1
	showtext TX_1d10
	wait 16

	setanimation $07
	writeobjectbyte Interaction.direction, $07
	asm15 playSound, SND_ECHO
	wait 210

	xorcfc0bit 0
	wait 75

	xorcfc0bit 0
	setanimation $02
	writeobjectbyte Interaction.direction, $02
	wait 16

	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE1
	showtext TX_1d11

	spawninteraction INTERACID_PLAY_HARP_SONG, $00, $00, $00
	checkcfc0bit 7
	wait 36

	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE1
	giveitem TREASURE_TUNE_OF_ECHOES, $00
	wait 16
	scriptend


; Subid $10: Cutscene in black tower where Nayru/Ralph meet you to try to escape
nayruScript10:
	checkpalettefadedone
	wait 30
	setspeed SPEED_100
	moveup $50
	moveleft $10
	writememory w1Link.direction, DIR_LEFT
	moveup $22
	setanimation $01
	wait 60

	showtextlowindex <TX_1d18
	wait 30

	setanimation $02
	writememory   w1Link.direction, DIR_DOWN
	writememory   wTmpcbb5, $01
	checkmemoryeq wTmpcbb5, $02
	wait 30

	writememory w1Link.direction, DIR_LEFT
	setanimation $01
	showtextlowindex <TX_1d19
	wait 30

	setanimation $02
	writememory w1Link.direction, DIR_DOWN
	writememory wTmpcbb5, $03
	wait 30

	writememory wTmpcbb5, $04
	movedown $52

	writeobjectbyte Interaction.yh, $08
	writeobjectbyte Interaction.xh, $70
	checkmemoryeq wTmpcbb5, $05
	checkpalettefadedone

	movedown $70
	showtextlowindex <TX_1d0e
	checktext

	setmusic      MUS_DISASTER
	writememory   wScreenShakeCounterY, 180
	writememory   wScreenShakeCounterX, 180
	writememory   wScrollMode, $01
	writememory   wTmpcbb5, $06
	checkmemoryeq wTmpcbb5, $07
	wait 20

	spawninteraction INTERACID_CLINK, $80, $74, $78
	playsound SND_SCENT_SEED
	setspeed SPEED_200
	movedown $18
	scriptend

; Subid $11: Cutscene on white background with Din just before facing Twinrova
nayruScript11:
	checkpalettefadedone
	wait 60
	setanimation $01
	wait 10
	asm15 forceLinkDirection, DIR_LEFT
	wait 10
	showtextlowindex <TX_1d1e
	wait 60
	showtextlowindex <TX_1d1f
	wait 30
	writememory $cfd0 $01
	scriptend

; Subid $13: NPC singing to the animals after the game is complete
nayruScript13:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	wait 10
	writeobjectbyte Interaction.var39 $01
	asm15 turnToFaceLink
	wait 8
	showtextlowindex <TX_1d21
	wait 8
	setanimation $02
	enableinput
	wait 20
	writeobjectbyte Interaction.var39 $00
	setanimation $04
	jump2byte @npcLoop

;;
; Turns to face position value at $cfd5/$cfd6?
; @addr{5613}
turnToFaceSomething:
	ld a,$0f		; $5613

;;
; @addr{5615}
turnToFaceSomethingAtInterval:
	ld b,a			; $5615
	ld a,(wFrameCounter)		; $5616
	and b			; $5619
	ret nz			; $561a
	callab func_0a_7877		; $561b
	call objectGetRelativeAngle		; $5623
	call convertAngleToDirection		; $5626
	ld h,d			; $5629
	ld l,Interaction.direction		; $562a
	cp (hl)			; $562c
	ret z			; $562d
	ld (hl),a		; $562e
	jp interactionSetAnimation		; $562f

;;
; @param	a	Link's animation
; @addr{5632}
setLinkAnimation:
	push de			; $5632
	ld d,>w1Link		; $5633
	call specialObjectSetAnimation		; $5635
	pop de			; $5638
	ret			; $5639

;;
; Creates an instance of "INTERACID_SWORD", which will read the current object's
; animParameter in order to know when to produce a sword swing animation.
; @addr{563a}
createLinkedSwordAnimation:
	call getFreeInteractionSlot		; $563a
	ret nz			; $563d
	ld (hl),INTERACID_SWORD		; $563e
	ld l,Interaction.relatedObj1+1		; $5640
	ld a,d			; $5642
	ld (hl),a		; $5643
	jp objectCopyPosition		; $5644

;;
; @addr{5647}
ralph_faceLinkAndCreateExclamationMark:
	call objectGetAngleTowardEnemyTarget		; $5647
	add $04			; $564a
	and $18			; $564c
	swap a			; $564e
	rlca			; $5650
	call interactionSetAnimation		; $5651
	ld a,$1e		; $5654

;;
; @addr{5656}
ralph_createExclamationMarkShiftedRight:
	ld bc,$f30d		; $5656
	jp objectCreateExclamationMark		; $5659

;;
; Begins a jump (speed: -$400)
; @addr{565c}
ralph_beginHighJump:
	ld h,d			; $565c
	ld l,Interaction.speedZ		; $565d
	ld (hl),$00		; $565f
	inc hl			; $5661
	ld (hl),$fc		; $5662
	ld a,SND_JUMP		; $5664
	jp playSound		; $5666

;;
; @addr{5669}
ralph_updateGravity:
	ld c,$c0		; $5669
	call objectUpdateSpeedZ_paramC		; $566b
	jp _writeFlagsTocddb		; $566e

;;
; @addr{5671}
ralph_restoreMusic:
	ld a,MUS_OVERWORLD_PRES		; $5671
	ld (wActiveMusic2),a		; $5673
	ld (wActiveMusic),a		; $5676
	jp playSound		; $5679

;;
; Flashes the screen a few times when Ralph tries to attack Ambi?
; @addr{567c}
ralph_flashScreen:
	call @func		; $567c
	jp _writeFlagsTocddb		; $567f

@func:
	ld a,($cfde)		; $5682
	rst_jumpTable			; $5685
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4

@thing0:
	ld a,$0a		; $5690
	ld ($cfdf),a		; $5692
	call clearFadingPalettes		; $5695

@inccfde:
	ld hl,$cfde		; $5698
	inc (hl)		; $569b
	ret			; $569c

@thing1:
@thing2:
	ld hl,$cfdf		; $569d
	dec (hl)		; $56a0
	ret nz			; $56a1
	ld a,$0a		; $56a2
	ld ($cfdf),a		; $56a4
	call fastFadeoutToWhite		; $56a7
	jp @inccfde		; $56aa

@thing3:
	ld a,$14		; $56ad
	ld ($cfdf),a		; $56af
	call clearFadingPalettes		; $56b2
	jp @inccfde		; $56b5

@thing4:
	ld hl,$cfdf		; $56b8
	dec (hl)		; $56bb
	ret			; $56bc

;;
; @addr{56bd}
ralph_flickerVisibility:
	ld b,$01		; $56bd
	jp objectFlickerVisibility		; $56bf

;;
; @addr{56c2}
ralph_decVar3f:
	ld h,d			; $56c2
	ld l,Interaction.var3f		; $56c3
	dec (hl)		; $56c5
	jp _writeFlagsTocddb		; $56c6


; Cutscene after Nayru is posessed
ralphSubid02Script:
	asm15 setLinkAnimation, LINK_ANIM_MODE_NONE
	wait 120

	showtext TX_2a02
	wait 30

	setspeed SPEED_020
	setangle $08
	applyspeed $81
	setanimation $08 ; Collapse animation
	wait 120
	showtext TX_2a03
	wait 120

	; Get back up, move toward cliff
	setanimation $09
	wait 10
	setanimation $0a
	wait 60
	setangle   $18
	setspeed   SPEED_020
	applyspeed $41
	setspeed   SPEED_040
	applyspeed $25
	wait 30

	; But now this!
	showtext TX_2a04
	wait 120
	writememory $cfd0 $1e
	wait 60

	; I'll save you!
	setanimation $02
	showtext TX_2a05
	wait 30

	; Move right
	setspeed SPEED_200
	moveright $19
	setanimation $02
	playsound SND_BOOMERANG
	wait 120

	; NAYRUUUUUU
	showtext TX_2a06
	wait 30

	; Leave screen
	setspeed SPEED_300
	movedown $28
	wait 60

	writememory $cfd0 $20
	scriptend


; Cutscene after talking to Rafton
ralphSubid03Script:
	wait 6
	setanimation $02
	wait 10
	showtext TX_2a0b
	wait 20

	setanimation $00
	wait 20
	showtext TX_2a06
	wait 10

	setspeed SPEED_200
	moveup $44

	playsound SNDCTRL_FAST_FADEOUT
	wait 30

	orroomflag $40
	enableinput
	scriptend


; Cutscene where Ralph tells you about getting Tune of Currents
ralphSubid0bScript:
	wait 90
	setmusic MUS_RALPH
	xorcfc0bit 0

	setspeed SPEED_200
	moveleft $30
	setstate2 $ff

	setspeed SPEED_100
	moveleft $20
	setspeed SPEED_080
	moveleft $20

	setstate2 $ff
	wait 30

	setspeed SPEED_100
	moveright $30

	setangleandanimation $00
	showtext TX_2a1a
	wait 30

	setspeed SPEED_200
	setstate2 $00
	moveright $38
	jump2byte _ralphEndCutscene


; Cutscene after talking to Cheval
ralphSubid10Script:
	wait 90

	setmusic MUS_RALPH
	xorcfc0bit 0
	setspeed  SPEED_200
	moveup $18
	setstate2 $ff
	setspeed  SPEED_100
	moveup $20
	setspeed  SPEED_080
	moveup $20
	setstate2 $ff
	wait 30

	showtext TX_2a20
	wait 30

	setspeed SPEED_200
	setstate2 $00
	movedown $38

_ralphEndCutscene:
	orroomflag $40
	wait 30
	resetmusic
	enableinput
	scriptend


; Cutscene where Ralph confronts Ambi in black tower
ralphSubid0cScript:
	initcollisions
	jumpifroomflagset $40, @alreadySawCutscene

	disableinput
	spawninteraction INTERACID_AMBI, $05, $3c, $78
	setmusic MUS_DISASTER
	wait 60

	playsound SND_SWORD_OBTAINED
	setanimation $04
	wait 60

	setspeed SPEED_080
	setangle $10
	xorcfc0bit 0
	applyspeed $11
	wait 20
	applyspeed $11
	wait 20
	applyspeed $11
	wait 40

	showtext TX_1313
	wait 30

	setspeed SPEED_200
	asm15 ralph_beginHighJump

@jumping:
	asm15 objectApplySpeed
	asm15 ralph_updateGravity
	jumpifmemoryset $cddb, $80, @landed
	jump2byte @jumping

@landed:
	wait 20
	showtext TX_2a1b
	wait 30

	setspeed SPEED_200
	setangle $00
	playsound SND_BEAM2
	applyspeed $0d

	playsound SND_LIGHTNING
	xorcfc0bit 1

@flashScreen:
	asm15 ralph_flashScreen
	jumpifmemoryset $cddb $80 @doneFlashingScreen
	jump2byte @flashScreen

@doneFlashingScreen:
	setcoords $58 $60
	setanimation $0c
	asm15 fadeinFromWhiteWithDelay, $04
	checkpalettefadedone
	wait 30

	showtext TX_1314
	wait 30

	xorcfc0bit 2
	orroomflag $40
	checkcfc0bit 3
	resetmusic
	enableinput

	; Ralph now acts as an npc while he's collapsed
	checkabutton
	setanimation $0c
	asm15 turnToFaceLink
	showtext TX_2a1c
	wait 30
	setanimation $0c

@npcLoop:
	checkabutton
	showtext TX_2a1d
	jump2byte @npcLoop

@alreadySawCutscene:
	setcoords $58 $60
	setanimation $0c
	jump2byte @npcLoop

;;
; @addr{5800}
monkey_decideTextIndex:
	ld b,<TX_5708-8		; $5800
	ld a,GLOBALFLAG_FINISHEDGAME		; $5802
	call checkGlobalFlag		; $5804
	jr z,+			; $5807
	ld b,<TX_570d-8		; $5809
+
	call getRandomNumber		; $580b
	and $03			; $580e
	add b			; $5810
	add <TX_5708			; $5811
	ld e,Interaction.textID		; $5813
	ld (de),a		; $5815
	ret			; $5816

;;
; @addr{5817}
monkey_turnToFaceLink:
	ld h,d			; $5817
	ld l,Interaction.yh		; $5818
	ld a,(w1Link.yh)		; $581a
	cp (hl)			; $581d
	ld a,$06		; $581e
	jr nc,+			; $5820
	dec a			; $5822
+
	jp interactionSetAnimation		; $5823

;;
; @addr{5826}
monkey_setAnimationFromVar3a:
	ld e,Interaction.var3a		; $5826
	ld a,(de)		; $5828
	jp interactionSetAnimation		; $5829

;;
; @addr{582c}
villager_setLinkYToVar39:
	ld hl,w1Link.yh		; $582c
	ld e,Interaction.var39		; $582f
	ld a,(de)		; $5831
	ld (hl),a		; $5832
	ret			; $5833

;;
; Creates a ball object for the purpose of a cutscene.
; @addr{5834}
villager_createBallAccessory:
	call getFreeInteractionSlot		; $5834
	ret nz			; $5837
	ld (hl),INTERACID_ACCESSORY		; $5838
	inc l			; $583a
	ld (hl),$3f		; $583b
	inc l			; $583d
	ld (hl),$01		; $583e

	ld l,Interaction.relatedObj1		; $5840
	ld (hl),Interaction.start		; $5842
	inc l			; $5844
	ld (hl),d		; $5845
	ret			; $5846

;;
; Creates an actual ball that can be thrown by the villagers.
; @addr{5847}
villager_createBall:
	ldbc INTERACID_BALL, $00		; $5847
	call objectCreateInteraction		; $584a
	ret nz			; $584d
	ld bc,$4a3c		; $584e
	jp interactionHSetPosition		; $5851

;;
; @param	a	Duration
; @addr{5854}
createExclamationMark:
	ld bc,$f300		; $5854
	jp objectCreateExclamationMark		; $5857

;;
; @addr{585a}
oscillateXRandomly:
	jpab interactionBank1.interactionOscillateXRandomly		; $585a

;;
; Forces the next animation frame to be loaded; does something with var38 and $cfd3?
; @addr{5862}
loadNextAnimationFrameAndMore:
	ld h,d			; $5862
	ld l,Interaction.animCounter		; $5863
	ld (hl),$01		; $5865
	ld l,Interaction.var38		; $5867
	dec (hl)		; $5869
	ld ($cfd3),a		; $586a
	jp interactionUpdateAnimCounter		; $586d

;;
; Creates lightning for the cutscene where the boy's father turns to stone.
;
; @param	a	Index of lightning to make (0-1)
; @addr{5870}
boy_createLightning:
	ld b,a			; $5870
	call getFreePartSlot		; $5871
	ret nz			; $5874
	ld (hl),PARTID_LIGHTNING		; $5875
	inc l			; $5877
	inc (hl)		; $5878
	inc l			; $5879
	inc (hl)		; $587a
	ld a,b			; $587b
	or a			; $587c
	ld bc,$4838		; $587d
	jr z,+			; $5880
	ld bc,$2878		; $5882
+
	ld l,Part.yh		; $5885
	ld (hl),b		; $5887
	ld l,Part.xh		; $5888
	ld (hl),c		; $588a
	ret			; $588b

;;
; Updates the funny joke cutscene by determining whether to update Link's animation.
;
; Uses var3f as a counter until Link proceeds to the next animation;
; Uses var3e as the index of the current animation.
; @addr{588c}
boy_runFunnyJokeCutscene:
	ld h,d			; $588c
	ld l,Interaction.var3f		; $588d
	dec (hl)		; $588f
	ret nz			; $5890

	ld l,Interaction.var3e		; $5891
	ld a,(hl)		; $5893
	cp $14			; $5894
	call _writeFlagsTocddb		; $5896
	ret z			; $5899

	ld a,(hl)		; $589a
	inc (hl)		; $589b
	ld hl,@animations		; $589c
	rst_addDoubleIndex			; $589f
	ldi a,(hl)		; $58a0
	ld ($cc50),a ; Set Link animation
	ld a,(hl)		; $58a4
	ld e,Interaction.var3f		; $58a5
	ld (de),a		; $58a7
	ret			; $58a8

; Data format:
;   b0: Link's animation
;   b1: Number of frames to remain on that animation
@animations:
	.db $08 $14
	.db $09 $14
	.db $08 $14
	.db $09 $14
	.db $07 $14
	.db $0e $14
	.db $06 $14
	.db $1c $14
	.db $08 $14
	.db $09 $14
	.db $08 $14
	.db $08 $28
	.db $09 $32
	.db $07 $14
	.db $0e $14
	.db $06 $14
	.db $1c $14
	.db $08 $14
	.db $09 $14
	.db $08 $14
	.db $09 $14


; Depressed kid in trade sequence
boySubid07Script:
	initcollisions
	checkmemoryeq wMenuDisabled, $00 ; Wait for player to enter the room fully

	asm15 darkenRoomLightly
	checkpalettefadedone

@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyToldJoke
	jumpiftradeitemeq $08, @offerTrade

@showDepressedText:
	showtext TX_2517
	enableinput
	jump2byte @npcLoop

@offerTrade:
	showtext TX_2515
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade
	jump2byte @showDepressedText

@acceptedTrade:
	writeobjectbyte Interaction.var3d, $01

	; Begin funny joke cutscene, wait for Link to return to normal
	asm15 moveLinkToPosition, $02
	wait 1
	checkmemoryeq w1Link.id, SPECIALOBJECTID_LINK

	writeobjectbyte Interaction.var3d, $00
	asm15 forceLinkDirectionAndPutOnGround, DIR_DOWN
	wait 40

	setmusic MUS_CRAZY_DANCE
	wait 120

@funnyJokeCutsceneLoop:
	asm15 boy_runFunnyJokeCutscene
	jumpifmemoryset $cddb, $80, @doneFunnyJokeCutscene
	jump2byte @funnyJokeCutsceneLoop

@doneFunnyJokeCutscene:
	asm15 restartSound
	wait 40

	playsound SND_SWORD_OBTAINED
	writememory $cc50, LINK_ANIM_MODE_GETITEM2HAND
	wait 120

	asm15 forceLinkDirectionAndPutOnGround, DIR_UP
	wait 30

	showtext TX_2516
	wait 30

	giveitem TREASURE_TRADEITEM, $08
	wait 30

	resetmusic
	enableinput
	jump2byte @npcLoop

@alreadyToldJoke:
	showtext TX_2518
	enableinput
	jump2byte @npcLoop

;;
; @addr{593b}
_ghostVeranApplySpeedUntilVar38Zero:
	ld h,d			; $593b
	ld l,$78		; $593c
	dec (hl)		; $593e
	ret z			; $593f
	call objectApplySpeed		; $5940
	jp objectApplySpeed		; $5943


; Cutscene at start of game where Veran flies around the screen
ghostVeranSubid0Script_part1:
	wait 60
	writememory $cfd0, $11
	wait 120
	setspeed SPEED_200

@movement0:
	setangle $1c
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $11
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement1
	jump2byte --

@movement1:
	wait 8
	setangle $0b
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $25
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement2
	jump2byte --

@movement2:
	wait 8
	setangle $18
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $13
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement3
	jump2byte --

@movement3:
	wait 8
	setangle $02
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $19
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement4
	jump2byte --

@movement4:
	wait 8
	setangle $0a
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $0c
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement5
	jump2byte --

@movement5:
	wait 8
	setangle $14
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $11
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement6
	jump2byte --

@movement6:
	wait 30
	writememory $cfd1 $01
	wait 30
	setspeed SPEED_080

	setangle $0b
	applyspeed $50
	wait 30

	showtext TX_5602
	wait 30

	writememory $cfd0 $12
	wait 120

	; Back up
	setspeed SPEED_040
	setangle $10
	applyspeed $29
	wait 60

	; Begin moving toward Nayru
	writeobjectbyte $4d $78
	playsound SND_SWORDSPIN
	setspeed SPEED_300
	setangle $00
	writememory $cfd0 $13
	applyspeed $22

	; Collision with Nayru
	playsound SND_KILLENEMY
	writememory $cfd0 $14
	wait 60
	scriptend

;;
; @addr{59f3}
soldierSetSimulatedInputToEscortLink:
	or a			; $59f3
	jr nz,@exitPalace	; $59f4

	; When entering, calculate the difference from Link's x position to desired x
	ld a,(w1Link.xh)		; $59f6
	ld b,$60		; $59f9
	sub $50			; $59fb
	jr nc,++		; $59fd
	cpl			; $59ff
	inc a			; $5a00
	ld b,$50		; $5a01
++
	ld c,a			; $5a03
	push de			; $5a04

	ld hl,interactionBank2.linkEnterPalaceSimulatedInput		; $5a05
	ld a,:interactionBank2.linkEnterPalaceSimulatedInput		; $5a08
	call setSimulatedInputAddress		; $5a0a

	pop de			; $5a0d

	; Modify simulated input based on above calculations
	ld a,c			; $5a0e
	rra			; $5a0f
	add c			; $5a10
	ld (wSimulatedInputCounter),a		; $5a11
	ld a,b			; $5a14
	ld (wSimulatedInputValue),a		; $5a15

	xor a			; $5a18
	ld (wDisabledObjects),a		; $5a19
	ret			; $5a1c

@exitPalace:
	push de			; $5a1d
	ld hl,interactionBank2.linkExitPalaceSimulatedInput		; $5a1e
	ld a,:interactionBank2.linkExitPalaceSimulatedInput		; $5a21
	call setSimulatedInputAddress		; $5a23
	pop de			; $5a26
	ret			; $5a27

;;
; @addr{5a28}
soldierGiveMysterySeeds:
	ld a,TREASURE_MYSTERY_SEEDS		; $5a28
	ld c,$00		; $5a2a
	jp giveTreasure		; $5a2c

;;
; @addr{5a2f}
soldierUpdateMinimap:
	jpab bank1.checkUpdateDungeonMinimap		; $5a2f

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

;;
; @addr{5a4d}
soldierSetTextToShow:
	ld e,Interaction.var03		; $5a4d
	ld a,(de)		; $5a4f
	ld hl,@soldierTextIndices		; $5a50
	rst_addAToHl			; $5a53
	ld a,(hl)		; $5a54
	ld e,Interaction.textID		; $5a55
	ld (de),a		; $5a57
	ld a,>TX_5900		; $5a58
	inc e			; $5a5a
	ld (de),a		; $5a5b
	ret			; $5a5c

@soldierTextIndices:
	.db <TX_5912, <TX_5913, <TX_5911, <TX_5910, <TX_5913, <TX_5911, <TX_5914, <TX_5913
	.db <TX_5915, <TX_5913, <TX_5912, <TX_5915, <TX_5913, <TX_5913, <TX_5912, <TX_5914


; Left palace guard
soldierSubid02Script:
	jumpifglobalflagset GLOBALFLAG_0b, @gotBombs
	jumpifitemobtained TREASURE_MYSTERY_SEEDS, @escortCutscene
	rungenericnpc TX_5903

@gotBombs:
	rungenericnpc TX_5909

@escortCutscene:
	disableinput
	asm15 forceLinkDirection, $00
	checkpalettefadedone
	wait 60
	setglobalflag GLOBALFLAG_10
	showtext TX_5904
	wait 30
	setanimation $00
	setspeed SPEED_100
	jumpifobjectbyteeq Interaction.xh, $48, @leftGuard

@rightGuard:
	setangle $1c
	jump2byte ++

@leftGuard:
	setangle $04
++
	asm15 soldierSetSimulatedInputToEscortLink, $00
	applyspeed $0b
	setangle $00
	applyspeed $80
	scriptend


; Red soldier that brings you to Ambi (escorts you from deku forest)
soldierSubid0aScript:
	checkmemoryeq w1Link.yh, $2a
	asm15 objectSetVisible82
	asm15 dropLinkHeldItem
	writememory $cc8a $01
	disablemenu
	wait 30
	setspeed SPEED_0c0
	moveright $4b
	wait 6
	setanimation $00
	wait 20
	asm15 createExclamationMark, $28
	wait 60
	setspeed SPEED_180
	moveup $1e
	wait 30
	showtext TX_590b
	wait 30
	orroomflag $40
	scriptend

;;
; @addr{5acc}
tokayGame_resetRoomFlag40:
	call getThisRoomFlags		; $5acc
	res 6,(hl)		; $5acf
	ret			; $5ad1

;;
; @addr{5ad2}
tokayGame_resetRoomFlag80:
	call getThisRoomFlags		; $5ad2
	res 7,(hl)		; $5ad5
	ret			; $5ad7

;;
; For wild tokay game, this sets var3d to 0 if Link has enough rupees, and determines the
; prize? (writes 5 to $cfdd if the prize will be a ring (1/8 chance), 4 otherwise?)
; @addr{5ad8}
tokayGame_determinePrizeAndCheckRupees:
	ld h,d			; $5ad8
	ld a,(wWildTokayGameLevel)		; $5ad9
	cp $04			; $5adc
	jr nz,++			; $5ade
	call getRandomNumber		; $5ae0
	and $07			; $5ae3
	ld a,$04		; $5ae5
	jr nz,++			; $5ae7
	inc a			; $5ae9
++
	ld ($cfdd),a		; $5aea

;;
; @addr{5aed}
tokayGame_checkRupees:
	ld a,($cfdd)		; $5aed
	ld bc,@gfx		; $5af0
	call addAToBc		; $5af3
	ld a,(bc)		; $5af6
	ld h,d			; $5af7
	ld l,Interaction.var03		; $5af8
	ld (hl),a		; $5afa
	ld a,RUPEEVAL_10		; $5afb
	call cpRupeeValue		; $5afd
	ld e,Interaction.var3d		; $5b00
	ld (de),a		; $5b02
	ret			; $5b03

; This is the list of graphics indices for the prizes.
; Normally it's 4 (rupees) or 5 (ring)?
@gfx:
	.db $3e $2b $2c $0d $2d $0e

;;
; @addr{5b0a}
tokayGame_createAccessoryForPrize:
	call interactionSetAnimation	; $5b0a
	xor a			; $5b0d
	ld e,Interaction.var3b		; $5b0e
	ld (de),a		; $5b10

	call getFreeInteractionSlot		; $5b11
	ret nz			; $5b14
	ld (hl),INTERACID_ACCESSORY		; $5b15
	inc l			; $5b17
	ld e,Interaction.var03		; $5b18
	ld a,(de)		; $5b1a
	ld (hl),a		; $5b1b
	ld l,Interaction.relatedObj1		; $5b1c
	ld (hl),Interaction.enabled		; $5b1e
	inc l			; $5b20
	ld (hl),d		; $5b21
	ret			; $5b22

;;
; Link jumps in the cutscene where he's robbed.
; @addr{5b23}
tokayMakeLinkJump:
	ld a,$81		; $5b23
	ld (wLinkInAir),a		; $5b25
	ld hl,w1Link.speedZ		; $5b28
	ld (hl),$00		; $5b2b
	inc l			; $5b2d
	ld (hl),$fe		; $5b2e
	ld a,SND_JUMP		; $5b30
	jp playSound		; $5b32

;;
; @addr{5b35}
tokayGiveShieldUpgradeToLink:
	ld b,$01		; $5b35
	ld c,$01		; $5b37
	ld a,(wShieldLevel)		; $5b39
	cp $02			; $5b3c
	jr c,+			; $5b3e
	inc c			; $5b40
+
	call createTreasure		; $5b41
	ret nz			; $5b44
	ld de,w1Link.yh		; $5b45
	jp objectCopyPosition_rawAddress		; $5b48

;;
; Creates a treasure object at Link's position which he will immediately pick up.
; @addr{5b4b}
tokayGiveItemToLink:
	call getFreeInteractionSlot		; $5b4b
	ret nz			; $5b4e
	ld (hl),INTERACID_TREASURE		; $5b4f
	inc l			; $5b51
	ld e,Interaction.var03		; $5b52
	ld a,(de)		; $5b54
	ldi (hl),a ; [treasure.subid] = [tokay.var03] (treasure index)

	dec e			; $5b56
	ld b,$06		; $5b57
	ld a,(de)		; $5b59
	cp $06 ; Check [tokay.subid] == $06 (Tokay holding the sword)
	jr z,+			; $5b5c
	ld b,$01		; $5b5e
+
	ld (hl),b ; [treasure.var03] = b (index in treasureObjectData.s)

	; If [tokay.subid] == $0a (tokay holding seed satchel), return seeds and fix level
	cp $0a			; $5b61
	jr nz,++		; $5b63
	ld a,TREASURE_MYSTERY_SEEDS		; $5b65
	call giveTreasure		; $5b67
	call refillSeedSatchel		; $5b6a
	push hl			; $5b6d
	ld hl,wSeedSatchelLevel		; $5b6e
	dec (hl)		; $5b71
	pop hl			; $5b72
++
	ld e,Interaction.counter1		; $5b73
	ld a,$03		; $5b75
	ld (de),a		; $5b77

	; Set treasure position to Link's.
	ld de,w1Link.yh		; $5b78
	jp objectCopyPosition_rawAddress		; $5b7b

;;
; @addr{5b7e}
tokayGame_givePrizeToLink:
	ld a,($cfdd)		; $5b7e
	cp $05			; $5b81
	jr z,@randomRing	; $5b83

	call getFreeInteractionSlot		; $5b85
	ret nz			; $5b88
	ld (hl),INTERACID_TREASURE		; $5b89
	inc l			; $5b8b
	ld a,(wWildTokayGameLevel)		; $5b8c
	ld bc,@prizes		; $5b8f
	call addDoubleIndexToBc		; $5b92
	ld a,(bc)		; $5b95
	ldi (hl),a		; $5b96
	inc bc			; $5b97
	ld a,(bc)		; $5b98
	ld (hl),a		; $5b99

	ld e,Interaction.counter1		; $5b9a
	ld a,$03		; $5b9c
	ld (de),a		; $5b9e
	ld de,w1Link.yh		; $5b9f
	call objectCopyPosition_rawAddress		; $5ba2
	jr @incGameLevel		; $5ba5

@randomRing:
	ld c,$02		; $5ba7
	call getRandomRingOfGivenTier		; $5ba9
	ld b,c			; $5bac
	ld c,$00		; $5bad
	call giveRingToLink		; $5baf

@incGameLevel:
	ld hl,wWildTokayGameLevel		; $5bb2
	ld a,(hl)		; $5bb5
	cp $04			; $5bb6
	ret z			; $5bb8
	inc (hl)		; $5bb9
	ret			; $5bba

; List of prizes for each level of the tokay game. (You'll either get this, or a ring?)
@prizes:
	.db TREASURE_SCENT_SEEDLING, $00
	.db TREASURE_RUPEES, $0e
	.db TREASURE_RUPEES, $0f
	.db TREASURE_GASHA_SEED, $00
	.db TREASURE_RUPEES, $10

;;
; Searches for an interaction of type INTERACID_TOKAY_SHOP_ITEM, and stores the high byte
; of its address in var3f (or writes 0 if none is found).
; @addr{5bc5}
tokayFindShopItem:
	ld e,Interaction.var3f		; $5bc5
	xor a			; $5bc7
	ld (de),a		; $5bc8
	ld c,INTERACID_TOKAY_SHOP_ITEM		; $5bc9
	call objectFindSameTypeObjectWithID		; $5bcb
	ret nz			; $5bce
	ld (de),a		; $5bcf
	ret			; $5bd0

;;
; Sets var3f to the number of ember seeds you have.
; @addr{5bd1}
tokayCheckHaveEmberSeeds:
	xor a			; $5bd1
	ld e,Interaction.var3f		; $5bd2
	ld (de),a		; $5bd4
	ld a,TREASURE_EMBER_SEEDS		; $5bd5
	call checkTreasureObtained		; $5bd7
	ret nc			; $5bda
	or a			; $5bdb
	ret z			; $5bdc
	ld (de),a		; $5bdd
	ret			; $5bde

;;
; @addr{5bdf}
tokayDecNumEmberSeeds:
	ld a,$ff		; $5bdf
	ld (wStatusBarNeedsRefresh),a		; $5be1
	ld a,(wNumEmberSeeds)		; $5be4
	sub $01			; $5be7
	daa			; $5be9
	ld (wNumEmberSeeds),a		; $5bea
	ret			; $5bed

;;
; @addr{5bee}
tokayTurnToFaceLink:
	call objectGetLinkRelativeAngle		; $5bee
	ld e,Interaction.angle		; $5bf1
	add $04			; $5bf3
	and $18			; $5bf5
	ld (de),a		; $5bf7

;;
; @addr{5bf8}
_tokayUpdateAnimationFromAngle:
	call convertAngleDeToDirection		; $5bf8
	jp interactionSetAnimation		; $5bfb

;;
; Turn to the opposite direction.
; @addr{5bfe}
tokayFlipDirection:
	ld e,Interaction.angle		; $5bfe
	ld a,(de)		; $5c00
	xor $10			; $5c01
	ld (de),a		; $5c03
	jr _tokayUpdateAnimationFromAngle		; $5c04

;;
; Removes the seedling from Link's inventory, and sets flag on the present and past
; versions of the room to indicate that it's been planted.
; @addr{5c06}
tokayPlantScentSeedling:
	call getThisRoomFlags		; $5c06
	set 7,(hl)		; $5c09
	dec h			; $5c0b
	set 7,(hl)		; $5c0c
	ld a,TREASURE_SCENT_SEEDLING		; $5c0e
	jp loseTreasure		; $5c10

;;
; @addr{5c13}
tokayGiveBombUpgrade:
	ld hl,wMaxBombs		; $5c13
	ld a,(hl)		; $5c16
	add $20			; $5c17
	ldd (hl),a		; $5c19
	ld (hl),a		; $5c1a
	jp setStatusBarNeedsRefreshBit1		; $5c1b

;;
; @addr{5c1e}
tokayCreateExclamationMark:
	ld bc,$f3f3		; $5c1e
	ld a,$1e		; $5c21
	jp objectCreateExclamationMark		; $5c23


; Subid $1d: NPC holding shield upgrade
tokayWithShieldUpgradeScript:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $40, @alreadyGaveShield

	; Give shield upgrade
	showtextlowindex <TX_0a68
	wait 30
	setanimation $02
	writeobjectbyte Interaction.var3b, $01
	asm15 tokayGiveShieldUpgradeToLink
	orroomflag $40
	wait 30

@alreadyGaveShield:
	showtextlowindex <TX_0a69
	enableinput
	jump2byte @npcLoop


; Subid $1e: Present NPC who talks to you after climbing down vine
tokayExplainingVinesScript:
	initcollisions
@npcLoop:
	enableinput
	setanimation $02
	checkabutton
	disableinput
	turntofacelink
	jumpifroomflagset $40, @vineNotGrown

	; Vine is grown properly
	orroomflag $40
	writeobjectbyte Interaction.var31, $00
	writememory w1Link.direction, $03
	asm15 tokayCreateExclamationMark
	writeobjectbyte Interaction.speedZ, $00
	writeobjectbyte Interaction.speedZ, $ff
	wait 30
	showtextlowindex <TX_0a6a
	jump2byte @npcLoop

@vineNotGrown:
	; Vine is not grown properly
	showtextlowindex <TX_0a6b
	jump2byte @npcLoop


; NPC who trades meat for stink bag (subid $05)
tokayCookScript:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyTraded

	showtextlowindex <TX_0a00
	wait 30
	jumpiftradeitemeq $03, @askForTrade

	showtextlowindex <TX_0a09
	enableinput
	jump2byte @npcLoop

@askForTrade:
	showtextlowindex <TX_0a01
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Rejected trade
	showtextlowindex <TX_0a08
	enableinput
	jump2byte @npcLoop

@acceptedTrade:
	showtextlowindex <TX_0a02
	wait 30
	showtextlowindex <TX_0a03
	wait 30
	showtextlowindex <TX_0a04
	wait 30

	; Set var3f to nonzero as signal to start jumping around
	writeobjectbyte Interaction.var3f, $01
	showtextlowindex <TX_0a05

	; Wait for signal that he's back in his starting position
	checkobjectbyteeq Interaction.var3e, $00

	writeobjectbyte Interaction.var3f, $00
	wait 40
	showtextlowindex <TX_0a06
	wait 30

	giveitem TREASURE_TRADEITEM, $03
	enableinput
	jump2byte @npcLoop

@alreadyTraded:
	showtextlowindex <TX_0a07
	enableinput
	jump2byte @npcLoop


;;
; This seems mostly identical to the "turntofacelink" script command, except it uses
; Link's actual position instead of the "hEnemyTargetY/X" variables.
; @addr{5ca8}
turnToFaceLink:
	call objectGetLinkRelativeAngle		; $5ca8
	call convertAngleToDirection		; $5cab
	jp interactionSetAnimation		; $5cae

ambiFlickerVisibility:
	ld b,$01		; $5cb1
	jp objectFlickerVisibility		; $5cb3

ambiDecVar3f:
	ld h,d			; $5cb6
	ld l,Interaction.var3f		; $5cb7
	dec (hl)		; $5cb9
	jp _writeFlagsTocddb		; $5cba

;;
; Ambi rises by 4 pixels per frame until z-position = -$40
; @addr{5cbd}
ambiRiseUntilOffScreen:
	ld e,Interaction.zh		; $5cbd
	ld a,(de)		; $5cbf
	sub $04			; $5cc0
	ld (de),a		; $5cc2
	cp $c0			; $5cc3
	jp _writeFlagsTocddb		; $5cc5


; The guy who you trade a dumbbell to for a mustache
dumbbellManScript:
	jumpifroomflagset $20, @liftingAnimation
	setanimation $00 ; Swaying animation
	jump2byte ++

@liftingAnimation:
	setanimation $01 ; Lifting animation
++
	initcollisions

@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyGaveMustache

	showtextlowindex <TX_0b1d
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	jumpiftradeitemeq $06, @offerTrade
	enableinput
	jump2byte @npcLoop

@offerTrade:
	showtextlowindex <TX_0b1e
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	showtextlowindex <TX_0b1f
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	showtextlowindex <TX_0b21
	wait 30
	jumpiftextoptioneq $00, @giveMustache

	; Declined trade
	showtextlowindex <TX_0b20
	enableinput
	jump2byte @npcLoop

@giveMustache:
	showtextlowindex <TX_0b22
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	showtextlowindex <TX_0b23
	wait 30
	setanimation $01
	giveitem TREASURE_TRADEITEM, $06

@alreadyGaveMustache:
	showtextlowindex <TX_0b24
	wait 30
	enableinput
	jump2byte @npcLoop


; ==============================================================================
; INTERACID_OLD_MAN
; ==============================================================================

;;
; @addr{5d15}
oldManGiveShieldUpgradeToLink:
	ld a,TREASURE_SHIELD		; $5d15
	call checkTreasureObtained		; $5d17
	jr c,+			; $5d1a
	ld a,(wShieldLevel)		; $5d1c
+
	cp $03			; $5d1f
	jr c,+			; $5d21
	ld a,$02		; $5d23
+
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

;;
; @addr{5d3a}
oldManWarpLinkToLibrary:
	ld hl,@warpDest		; $5d3a
	call setWarpDestVariables		; $5d3d
	ld a,SND_TELEPORT		; $5d40
	jp playSound		; $5d42

@warpDest:
	.db $85 $ec $00 $17 $03

;;
; @addr{5d4a}
oldManSetAnimationToVar38:
	ld e,$78		; $5d4a
_label_15_097:
	ld a,(de)		; $5d4c
	jp interactionSetAnimation		; $5d4d


; Subid $00: Old man who takes a secret to give you the shield (same spot as subid $02)
oldManScript_givesShieldUpgrade:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, ++
	scriptend
++
	initcollisions
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_72, @alreadyToldSecret

	; Ask if Link has a secret to tell
	showtext TX_3310
	wait 30

	jumpiftextoptioneq $00, @promptForSecret

	; Said "no"
	showtext TX_3311
	jump2byte @warpLinkOut

@promptForSecret:
	askforsecret $04
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret

	; Invalid secret
	showtext TX_3311
	jump2byte @warpLinkOut

@validSecret:
	setglobalflag GLOBALFLAG_68
	showtext TX_3312
	wait 30
	callscript scriptFunc_doEnergySwirlCutscene
	wait 30
	asm15 oldManGiveShieldUpgradeToLink
	wait 30

	setglobalflag GLOBALFLAG_72
	generatesecret $04
	showtext TX_3313
	jump2byte @warpLinkOut

@alreadyToldSecret:
	generatesecret $04
	showtext TX_3314

@warpLinkOut:
	wait 30
	asm15 oldManWarpLinkToLibrary
	enableinput
@wait:
	wait 1
	jump2byte @wait


; Subid $01: Old man who gives you book of seals
oldManScript_givesBookOfSeals:
	initcollisions
@npcLoop:
	enableinput
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyGaveBook
	showtext TX_3308
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_OCTOROK_FAIRY, @talkedToFairy
	jump2byte @npcLoop

@talkedToFairy:
	wait 30
	showtext TX_3309
	setangleandanimation $00
	wait 30
	orroomflag $20
	setangleandanimation $10
	wait 30
	giveitem TREASURE_BOOK_OF_SEALS, $00
	wait 1
	checktext
	enableinput
	jump2byte @npcLoop

@alreadyGaveBook:
	showtext TX_330a
	jump2byte @npcLoop


; Subid $02: Old man guarding fairy powder in past (same spot as subid $00)
oldManScript_givesFairyPowder:
	initcollisions
	checkabutton
	jumpifroomflagset $20, @alreadyGaveFairyPowder

	disableinput
	showtext TX_330b

	setangleandanimation $00
	wait 30

	orroomflag $20
	setangleandanimation $10
	wait 30

	giveitem TREASURE_FAIRY_POWDER, $00
	wait 1
	checktext

	showtext TX_330c
	checktext
	enablemenu
	scriptend

@alreadyGaveFairyPowder:
	showtext TX_330d
	checktext
	scriptend

; ==============================================================================
; INTERACID_MAMAMU_YAN
; ==============================================================================

mamamuYanRandomizeDogLocation:
	ld hl,wMamamuDogLocation		; $5de7
@loop:
	call getRandomNumber		; $5dea
	and $03			; $5ded
	cp (hl)			; $5def
	jr z,@loop		; $5df0
	ld (hl),a		; $5df2
	ret			; $5df3

; @addr{5df4}
mamamuYanScript:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, +
	jump2byte @tradeScript
+
	jumpifroomflagset $20, @postgameScript

; This script runs if the game is not finished (or if you haven't traded with her yet).
@tradeScript:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyGaveDoggieMask

	showtextlowindex <TX_0b16
	wait 30
	jumpiftradeitemeq $05, @askForTrade

	showtextlowindex <TX_0b17
	enableinput
	jump2byte @npcLoop

@askForTrade:
	showtextlowindex <TX_0b18
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Declined trade
	showtextlowindex <TX_0b1b
	enableinput
	jump2byte @npcLoop

@acceptedTrade:
	showtextlowindex <TX_0b19
	wait 30
	giveitem TREASURE_TRADEITEM, $05
	wait 30
	showtextlowindex <TX_0b1a
	enableinput
	jump2byte @npcLoop

@alreadyGaveDoggieMask:
	showtextlowindex <TX_0b1c
	enableinput
	jump2byte @npcLoop


; This runs after beating the game (and after trading the doggie mask); after telling her
; a secret, Mamamu asks you to look for her dog.
@postgameScript:
	setcoords $28, $48
	initcollisions
	jumpifglobalflagset GLOBALFLAG_RETURNED_DOG, @dogFound

@postgameNpcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $80, @alreadyBeganSearch
	jumpifglobalflagset GLOBALFLAG_6a, @alreadyToldSecret
	showtextlowindex <TX_0b3a
	wait 30

	jumpiftextoptioneq $00, @promptForSecret

	showtextlowindex <TX_0b3b
	jump2byte @enableInputAndLoop

@promptForSecret:
	askforsecret $06
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret

	; Invalid secret
	showtextlowindex <TX_0b3d
	jump2byte @enableInputAndLoop

@validSecret:
	setglobalflag GLOBALFLAG_6a
	showtextlowindex <TX_0b3c
	jump2byte @askedListenToRequest

; Link has told the secret already, but hasn't accepted the sidequest.
@alreadyToldSecret:
	showtextlowindex <TX_0b43
@askedListenToRequest:
	wait 30
	jumpiftextoptioneq $00, @acceptedRequest

	; Refused her request.
	showtextlowindex <TX_0b3e
	jump2byte @enableInputAndLoop

; Accepted her request
@acceptedRequest:
	showtextlowindex <TX_0b3f
	orroomflag $80
	asm15 mamamuYanRandomizeDogLocation
	jump2byte @enableInputAndLoop

@alreadyBeganSearch:
	showtextlowindex <TX_0b40

@enableInputAndLoop:
	enableinput
	jump2byte @postgameNpcLoop

@dogFound:
	jumpifroomflagset $40, @alreadyGaveReward

	disableinput
	asm15 forceLinkDirection, DIR_LEFT
	showtextlowindex <TX_0b41
	wait 30

	asm15 giveRingAToLink, SNOWSHOE_RING
	orroomflag $40
	wait 30

	showtextlowindex <TX_0b42
	enableinput
	jump2byte @genericNpc

@alreadyGaveReward:
	setcoords $1a, $18

@genericNpc:
	rungenericnpclowindex <TX_0b44

; ==============================================================================
; INTERACID_MAMAMU_DOG
; ==============================================================================

;;
; Reverse direction if x-position gets too high or low.
mamamuDog_checkReverseDirection:
	call objectApplySpeed		; $5e94
	ld e,Interaction.xh		; $5e97
	ld a,(de)		; $5e99
	sub $18			; $5e9a
	cp $70			; $5e9c
	ret c			; $5e9e

	ld h,d			; $5e9f
	ld l,Interaction.angle		; $5ea0
	ld a,(hl)		; $5ea2
	xor $10			; $5ea3
	ld (hl),a		; $5ea5
	ld b,$01		; $5ea6
	jr ++			; $5ea8

;;
; @addr{5eaa}
mamamuDog_reverseDirection:
	ld b,$02		; $5eaa
++
	ld h,d			; $5eac
	ld l,Interaction.var3f		; $5ead
	ld a,(hl)		; $5eaf
	xor b			; $5eb0
	ld (hl),a		; $5eb1
	jp interactionSetAnimation		; $5eb2

;;
; @addr{5eb5}
mamamuDog_setCounterRandomly:
	call getRandomNumber		; $5eb5
	and $07			; $5eb8
	ld hl,_mamamuDog_randomCounterValues		; $5eba
	rst_addAToHl			; $5ebd
	ld a,(hl)		; $5ebe
	ld e,Interaction.var3e		; $5ebf
	ld (de),a		; $5ec1
	call _mamamuDog_hop		; $5ec2

;;
; @addr{5ec5}
mamamuDog_setZPositionTo0:
	ld h,d			; $5ec5
	ld l,Interaction.z		; $5ec6
	xor a			; $5ec8
	ldi (hl),a		; $5ec9
	ld (hl),a		; $5eca
	ret			; $5ecb

_mamamuDog_randomCounterValues:
	.db $78 $b4 $f0 $ff $b4 $f0 $ff $ff


mamamuDog_updateSpeedZ:
	ld c,$20		; $5ed4
	call objectUpdateSpeedZ_paramC		; $5ed6
	ret nz			; $5ed9

_mamamuDog_hop:
	ld bc,-$c0		; $5eda
	jp objectSetSpeedZ		; $5edd

mamamuDog_decCounter:
	ld h,d			; $5ee0
	ld l,Interaction.var3e		; $5ee1
	dec (hl)		; $5ee3
	jp _writeFlagsTocddb		; $5ee4


; ==============================================================================
; INTERACID_POSTMAN
; ==============================================================================
postmanScript:
	jumpifroomflagset $20, stubScript
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	showtextlowindex <TX_0b03
	wait 30
	jumpiftradeitemeq $01, @promptForTrade
	jump2byte @enableInput

@promptForTrade:
	showtextlowindex <TX_0b04
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade
	showtextlowindex <TX_0b06

@enableInput:
	enableinput
	jump2byte @npcLoop

@acceptedTrade:
	showtextlowindex <TX_0b05
	wait 30

	writeobjectbyte Interaction.var3f, $01 ; Change animation mode (don't face link)
	setspeed SPEED_200
	moveright $1d
	movedown $39
	wait 30

	giveitem TREASURE_TRADEITEM, $01
	enableinput
	scriptend


; ==============================================================================
; INTERACID_PICKAXE_WORKER
; ==============================================================================

;;
; @addr{5f15}
pickaxeWorker_setRandomDelay:
	call getRandomNumber_noPreserveVars		; $5f15
	and $1f			; $5f18
	sub $10			; $5f1a
	add $3c			; $5f1c
	ld e,Interaction.counter1		; $5f1e
	ld (de),a		; $5f20
	ret			; $5f21

;;
; @addr{5f22}
pickaxeWorker_setAnimationFromVar03:
	ld e,Interaction.var03		; $5f22
	ld a,(de)		; $5f24
	ld hl,@animations		; $5f25
	rst_addAToHl			; $5f28
	ld a,(hl)		; $5f29
	jp interactionSetAnimation		; $5f2a

@animations:
	.db $00 $01 $00 $01 $00 $01 $01 $01

;;
; @addr{5f35}
pickaxeWorker_chooseRandomBlackTowerText:
	call getRandomNumber		; $5f35
	and $07			; $5f38
	ld hl,$5f47		; $5f3a
	rst_addAToHl			; $5f3d
	ld a,(hl)		; $5f3e
	ld e,Interaction.textID		; $5f3f
	ld (de),a		; $5f41
	ld a,$1b		; $5f42
	inc e			; $5f44
	ld (de),a		; $5f45
	ret			; $5f46

@blackTowerText:
	.db <TX_1b01
	.db <TX_1b02
	.db <TX_1b03
	.db <TX_1b04
	.db <TX_1b05
	.db <TX_1b01
	.db <TX_1b02
	.db <TX_1b03


pickaxeWorkerSubid01Script_part2:
	setcoords $55, $3e
	setanimation $07
	asm15 objectSetVisiblec1
	wait 60
	setspeed SPEED_040
	setangle $10
	applyspeed $14
	wait 10

	setangle $08
	applyspeed $30
	writeobjectbyte Interaction.var3f, $01
	wait 20

	writememory   $cfc0, $02
	checkmemoryeq $cfc0, $04

	writeobjectbyte Interaction.var3f, $00
	setangle $10
	scriptend


; ==============================================================================
; INTERACID_HARDHAT_WORKER
; ==============================================================================

;;
; Move Link away to make way for the hardhat worker to move right, if necessary.
; @addr{5f75}
hardhatWorker_moveLinkAway:
	call objectGetLinkRelativeAngle		; $5f75
	call convertAngleToDirection		; $5f78
	cp $01			; $5f7b
	ret nz			; $5f7d

	ld hl,w1Link.yh		; $5f7e
	ld b,(hl)		; $5f81
	ld a,$48		; $5f82
	sub b			; $5f84
	ld b,a			; $5f85
	ld hl,@simulatedInput		; $5f86
	ld a,:@simulatedInput		; $5f89
	push de			; $5f8b
	call setSimulatedInputAddress		; $5f8c
	pop de			; $5f8f

	; Move Link as far as necessary to get him to y position $48
	ld a,b			; $5f90
	ld (wSimulatedInputCounter),a		; $5f91
	ld a,BTN_DOWN		; $5f94
	ld (wSimulatedInputValue),a		; $5f96

	xor a			; $5f99
	ld (wDisabledObjects),a		; $5f9a
	ret			; $5f9d

@simulatedInput:
	dwb    10, $00
	dwb     1, BTN_UP
	dwb $7fff, $00
	.dw $ffff

;;
; @addr{5fa9}
hardhatWorker_storeLinkVarsSomewhere:
	ld de,w1Link.yh		; $5fa9
	call getShortPositionFromDE		; $5fac
	ld ($cfd3),a		; $5faf
	ld e,<w1Link.direction		; $5fb2
	ld a,(de)		; $5fb4
	ld ($cfd4),a		; $5fb5
	ret			; $5fb8

;;
; @addr{5fb9}
soldierSetSpeed80AndVar3fTo01:
	ld h,d			; $5fb9
	ld l,Interaction.speed		; $5fba
	ld (hl),SPEED_80		; $5fbc
	ld l,Interaction.var3f		; $5fbe
	ld (hl),$01		; $5fc0
	ret			; $5fc2

;;
; @addr{5fc3}
hardhatWorker_setPatrolDirection:
	ld h,d			; $5fc3
	ld l,Interaction.var3e		; $5fc4
	ld (hl),a		; $5fc6
	ld b,a			; $5fc7
	swap a			; $5fc8
	rrca			; $5fca
	ld l,Interaction.angle		; $5fcb
	ld (hl),a		; $5fcd
	ld a,b			; $5fce
	jp interactionSetAnimation		; $5fcf

;;
; @addr{5fd2}
hardhatWorker_setPatrolCounter:
	ld e,Interaction.var3c		; $5fd2
	ld (de),a		; $5fd4
	ret			; $5fd5

;;
; @addr{5fd6}
hardhatWorker_updatePatrolAnimation:
	ld e,Interaction.var3e		; $5fd6
	ld a,(de)		; $5fd8
	jp interactionSetAnimation		; $5fd9

;;
; @addr{5fdc}
hardhatWorker_decPatrolCounter:
	ld h,d			; $5fdc
	ld l,Interaction.var3c		; $5fdd
	dec (hl)		; $5fdf
	jp _writeFlagsTocddb		; $5fe0

;;
; @addr{5fe3}
hardhatWorker_chooseTextForPatroller:
	ld e,Interaction.var03		; $5fe3
	ld a,(de)		; $5fe5
	cp $04			; $5fe6
	jr z,+			; $5fe8
	call getRandomNumber		; $5fea
	and $03			; $5fed
+
	ld hl,@textIDs		; $5fef
	rst_addAToHl			; $5ff2
	ld a,(hl)		; $5ff3
	ld e,Interaction.textID		; $5ff4
	ld (de),a		; $5ff6
	ld a,>TX_1000		; $5ff7
	inc e			; $5ff9
	ld (de),a		; $5ffa
	ret			; $5ffb

@textIDs:
	.db <TX_100a ; First 4 are randomly chosen values
	.db <TX_100b
	.db <TX_100c
	.db <TX_100c
	.db <TX_100d ; Last one is constant value for when [var03]==$04

;;
; @addr{6001}
hardhatWorker_checkBlackTowerProgressIs00:
	call getBlackTowerProgress		; $6001
	jp _writeFlagsTocddb		; $6004

;;
; @addr{6007}
hardhatWorker_checkBlackTowerProgressIs01:
	call getBlackTowerProgress		; $6007
	cp $01			; $600a
	jp _writeFlagsTocddb		; $600c


; NPC who guards the entrance to the black tower.
hardhatWorkerSubid02Script:
	initcollisions
	jumpifroomflagset $80, @alreadySawCutscene
	jumpifroomflagset $40, @cutsceneAftermath

	checkabutton
	disableinput
	showtextlowindex <TX_1003
	wait 30

	orroomflag $40
	asm15 hardhatWorker_storeLinkVarsSomewhere
	writememory $cbb8, $00
	writememory wCutsceneTrigger, CUTSCENE_BLACK_TOWER_EXPLANATION
	scriptend

@cutsceneAftermath:
	disableinput
	asm15 turnToFaceLink
	checkpalettefadedone
	wait 60

	showtextlowindex <TX_1006
	asm15 hardhatWorker_moveLinkAway
	writeobjectbyte Interaction.var38, $01
	wait 30

	setspeed SPEED_080
	moveright $21
	writeobjectbyte Interaction.var38, $00
	wait 30

	orroomflag $80
	writememory $cbc3, $00
	enableinput

@alreadySawCutscene:
	checkabutton
	showtextlowindex <TX_1004
	jump2byte @alreadySawCutscene


; A patrolling NPC.
hardhatWorkerSubid03Script:
	asm15 soldierSetSpeed80AndVar3fTo01
	asm15 hardhatWorker_chooseTextForPatroller
	initcollisions
	jumptable_objectbyte Interaction.var03
	.dw @val00
	.dw @val01
	.dw @val02
	.dw @val03
	.dw @val04

@val00:
	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $40
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $60
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $60
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $40
	callscript scriptFunc_patrol

	jump2byte @val00

@val01:
	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $40
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $80
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $20
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $20
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $80
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $40
	callscript scriptFunc_patrol

	jump2byte @val01

@val02:
	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $a0
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $a0
	callscript scriptFunc_patrol

	jump2byte @val02

@val03:
	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $40
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $a0
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $a0
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $40
	callscript scriptFunc_patrol

	jump2byte @val03

@val04:
	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $60
	callscript scriptFunc_patrol

	asm15 scriptHlp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHlp.hardhatWorker_setPatrolCounter,   $60
	callscript scriptFunc_patrol

	jump2byte @val04


; ==============================================================================
; INTERACID_POE
; ==============================================================================

;;
; @addr{6131}
poe_decCounterAndFlickerVisibility:
	ld h,d			; $6131
	ld l,Interaction.var3e		; $6132
	ld a,(hl)		; $6134
	or a			; $6135
	call _writeFlagsTocddb		; $6136
	jr z,@setVisible	; $6139

	dec (hl)		; $613b
	ld a,(wFrameCounter)		; $613c
	rrca			; $613f
	rrca			; $6140
	jp nc,objectSetInvisible		; $6141
@setVisible:
	jp objectSetVisible		; $6144


; Ghost who starts the trade sequence.
poeScript:
	initcollisions
	checkabutton
	disableinput
	jumptable_objectbyte Interaction.var03
	.dw @firstMeeting
	.dw @inTomb
	.dw @lastMeeting

@firstMeeting:
	showtext TX_0b00
	orroomflag $40

@disappear:
	wait 40
	playsound SND_POOF
	writeobjectbyte Interaction.var3e, 30
@disappearLoop:
	asm15 poe_decCounterAndFlickerVisibility
	jumpifmemoryset $cddb, $80, @end
	jump2byte @disappearLoop
@end:
	enableinput
	scriptend


@inTomb:
	showtext TX_0b01
	orroomflag $40
	wait 30

	writeobjectbyte Interaction.var3f, $01 ; Don't face Link
	setspeed SPEED_100
	setanimation $02
	setangle $10
	applyspeed $49

	setanimation $01
	setangle $08
	applyspeed $39

	jump2byte @disappear


@lastMeeting:
	showtext TX_0b02
	wait 30
	giveitem TREASURE_TRADEITEM, $00
	jump2byte @disappear


; ==============================================================================
; INTERACID_OLD_ZORA
; ==============================================================================

; Zora who trades you the broken sword for a guitar.
oldZoraScript:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset ROOMFLAG_ITEM, @alreadyGaveSword

	showtextlowindex <TX_0b33
	wait 30

	jumpiftradeitemeq $0b, @offerTrade

	showtextlowindex <TX_0b34
	jump2byte @enableInput

@offerTrade:
	showtextlowindex <TX_0b35
	wait 30

	jumpiftextoptioneq $00, @acceptedTrade
	showtextlowindex <TX_0b38
	jump2byte @enableInput

@acceptedTrade:
	showtextlowindex <TX_0b36
	wait 30
	giveitem TREASURE_TRADEITEM, $0b
	wait 30

	showtextlowindex <TX_0b37
	jump2byte @enableInput

@alreadyGaveSword:
	showtextlowindex <TX_0b39
@enableInput:
	enableinput
	jump2byte @npcLoop


; ==============================================================================
; INTERACID_TOILET_HAND
; ==============================================================================


toiletHand_checkLinkIsClose:
	; Get Link's position in b?
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
	ld hl,@data		; $61cc
@loop:
	ldi a,(hl)		; $61cf
	or a			; $61d0
	scf			; $61d1
	jr z,++			; $61d2
	cp b			; $61d4
	jr nz,@loop	; $61d5
++
	jp _writeFlagsTocddb		; $61d7

@data: ; List of positions that are close to the toilet?
	.db $57 $68 $67 $00

;;
; @addr{61de}
toiletHand_retreatIntoToiletIfNotAlready:
	; Check if already retreated
	ld e,Interaction.direction		; $61de
	ld a,(de)		; $61e0
	cp $02			; $61e1
	ret z			; $61e3

;;
; @addr{61e4}
toiletHand_retreatIntoToilet:
	ld a,$02		; $61e4
	jr _toiletHand_setAnimation		; $61e6

;;
; @addr{61e8}
toiletHand_comeOutOfToilet:
	ld a,$01		; $61e8
	jr _toiletHand_setAnimation		; $61ea

;;
; @addr{61ec}
toiletHand_disappear:
	ld a,$00		; $61ec

;;
; @addr{61ee}
_toiletHand_setAnimation:
	ld e,Interaction.direction		; $61ee
	ld (de),a		; $61f0
	jp interactionSetAnimation		; $61f1

;;
; @addr{61f4}
toiletHand_checkVisibility:
	ld e,Interaction.visible		; $61f4
	ld a,(de)		; $61f6
	ld ($cddb),a		; $61f7
	ret			; $61fa


; ==============================================================================
; INTERACID_MASK_SALESMAN
; ==============================================================================

maskSalesmanScript:
	setcollisionradii $04, $06
	makeabuttonsensitive
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset ROOMFLAG_ITEM, @alreadyGaveDoggieMask

	setanimation $00
	showtext TX_0b0d
	wait 15
	setanimation $01
	showtext TX_0b0e
	wait 15
	setanimation $00
	showtext TX_0b0f
	wait 15
	setanimation $01
	showtext TX_0b0e
	wait 30
	jumpiftradeitemeq $04, @promptForTrade
	jump2byte @enableInput

@promptForTrade:
	showtext TX_0b10
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Declined trade
	showtext TX_0b14
	jump2byte @enableInput

@acceptedTrade:
	showtext TX_0b45
	wait 15
	setanimation $00
	showtext TX_0b11
	wait 15
	setanimation $01
	showtext TX_0b12
	wait 15
	setanimation $00
	showtext TX_0b13
	wait 15
	setanimation $01
	showtext TX_0b45
	wait 30

	giveitem TREASURE_TRADEITEM,$04
	setanimation $00
	jump2byte @enableInput

@alreadyGaveDoggieMask:
	showtext TX_0b15

@enableInput:
	enableinput
	jump2byte @npcLoop


; ==============================================================================
; INTERACID_COMEDIAN
; ==============================================================================

;;
; Set var3f to:
;   $00 before beating d2
;   $01 after beating d2
;   $02 after beating moonlit grotto
; @addr{6259}
comedian_checkGameProgress:
	ld a,(wEssencesObtained)		; $6259
	call getHighestSetBit		; $625c
	cp $03			; $625f
	jr c,+			; $6261
	ld a,$02		; $6263
+
	ld e,Interaction.var3f		; $6265
	ld (de),a		; $6267
	ret			; $6268


;;
; @param	a	Essence to check for
; @param[out]	zflag	z if essence obtained
; @addr{6269}
checkEssenceObtained:
	call checkEssenceNotObtained		; $6269
	cpl			; $626c
	ld ($cddb),a		; $626d
	ret			; $6270

;;
; @param	a	Essence to check for
; @param[out]	zflag	z if essence not obtained
; @addr{6271}
checkEssenceNotObtained:
	ld hl,wEssencesObtained		; $6271
	call checkFlag		; $6274
	jp _writeFlagsTocddb		; $6277

;;
; @addr{627a}
comedian_enableMustache:
	ld a,$04		; $627a
	jr ++			; $627c

;;
; @addr{627e}
comedian_disableMustache:
	ld a,$00		; $627e
++
	ld h,d			; $6280
	ld l,Interaction.var37 ; Set animation base to enable/disable mustache
	ld (hl),a		; $6283
	ld l,Interaction.var3e ; Force animation refresh next time
	ld (hl),$ff		; $6286
	ret			; $6288

;;
; Turn to face link, accounting for fact that he only faces left and right
; @addr{6289}
comedian_turnToFaceLink:
	ld h,d			; $6289
	ld l,Interaction.xh		; $628a
	ld a,(w1Link.xh)		; $628c
	cp (hl)			; $628f
	ld a,$01		; $6290
	jr nc,+			; $6292
	xor a			; $6294
+
	ld l,Interaction.var3e		; $6295
	cp (hl)			; $6297
	ret z			; $6298
	ld (hl),a		; $6299
	ld l,Interaction.var37 ; Add with "animation base"?
	add (hl)		; $629c
	jp interactionSetAnimation		; $629d

comedianScript:
	asm15 comedian_checkGameProgress
	jumpifroomflagset ROOMFLAG_ITEM, @hasMustache

	asm15 comedian_disableMustache
	setanimation $01
	jump2byte @initNpc

@hasMustache:
	asm15 comedian_enableMustache
	setanimation $05

@initNpc:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset ROOMFLAG_ITEM, @alreadyGaveMustache
	jumptable_objectbyte Interaction.var3f
	.dw @beforeBeatD2
	.dw @afterBeatD2
	.dw @afterBeatMoonlitGrotto

@beforeBeatD2:
	showtextlowindex <TX_0b2c
	jump2byte @enableInput

@afterBeatD2:
	showtextlowindex <TX_0b2d
	jump2byte @enableInput

@afterBeatMoonlitGrotto:
	showtextlowindex <TX_0b2e
	wait 30
	jumpiftradeitemeq $07, @promptForTrade
	jump2byte @noTrade

@promptForTrade:
	showtextlowindex <TX_0b2f
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

@noTrade:
	showtextlowindex <TX_0b31
	jump2byte @enableInput

@acceptedTrade:
	asm15 comedian_enableMustache
	showtextlowindex <TX_0b30
	wait 30
	giveitem TREASURE_TRADEITEM,$07
	jump2byte @enableInput

@alreadyGaveMustache:
	showtextlowindex <TX_0b32

@enableInput:
	wait 30
	enableinput
	jump2byte @npcLoop


; ==============================================================================
; INTERACID_GORON
; ==============================================================================

	ld b,$20		; $62ef
	ld hl,$cfc0		; $62f1
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
	ld ($cfda),a		; $630b
	ld ($cfdb),a		; $630e
	ld hl,w1Link.direction		; $6311
	ld (hl),$02		; $6314
	ld b,$0a		; $6316
	jpab interactionBank1.shootingGallery_initializeTargetLayouts		; $6318

;;
; @param[out]	zflag	Set if in present (in $cddb)
; @addr{6320}
goron_checkInPresent:
	ld a,(wAreaFlags)		; $6320
	and $80			; $6323
	jp _writeFlagsTocddb		; $6325

;;
; Unused?
; @param[out]	zflag	Set if in past (in $cddb)
; @addr{6328}
goron_checkInPast:
	ld a,(wAreaFlags)		; $6328
	cpl			; $632b
	and $80			; $632c
	jp _writeFlagsTocddb		; $632e

	ld a,$02		; $6331
	ld bc,$5c50		; $6333
	jr _label_15_122		; $6336

;;
; @addr{6338}
goron_setLinkPositionToTargetCartPlatform:
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
	ld l,<w1Link.yh		; $634f
	ld (hl),b		; $6351
	ld l,<w1Link.xh		; $6352
	ld (hl),c		; $6354

;;
; @addr{6355}
goron_putLinkInState08:
	call putLinkOnGround		; $6355
	jp setLinkForceStateToState08		; $6358

	ld a,($cfdb)		; $635b
	ld b,a			; $635e
	ld a,$08		; $635f
	sub b			; $6361
	ld hl,wTextNumberSubstitution		; $6362
	ld (hl),a		; $6365
	inc hl			; $6366
	ld (hl),$00		; $6367
	ld a,($cfdb)		; $6369
	or a			; $636c
	jp _writeFlagsTocddb		; $636d
	ld a,(wAreaFlags)		; $6370
	and $80			; $6373
	jr nz,_label_15_123	; $6375
	ld b,$02		; $6377
	jr _label_15_124		; $6379
_label_15_123:
	ld b,$00		; $637b
	ld a,($cfdd)		; $637d
	cp $00			; $6380
	jr z,_label_15_124	; $6382
	ld b,$02		; $6384
_label_15_124:
	call getRandomNumber		; $6386
	and $01			; $6389
	add b			; $638b
	ld hl,@data		; $638c
	rst_addAToHl			; $638f
	ld a,(hl)		; $6390
	jp giveRingAToLink		; $6391
@data:
	.db $19 $3f $30 $1e
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

;;
; Show a text index. Starts with index $24XX where XX is passed in, then adds to that:
; * If unlinked in the past:    $00
; * If in the present:          $10
; * If linked in the past:      $20
;
; @param	a	Base text index (TX_24XX)
; @addr{63ab}
goron_decideTextToShow_differentForLinkedInPast:
	ld c,a			; $63ab
	call checkIsLinkedGame		; $63ac
	jr nz,@linked	; $63af
	ld a,(wAreaFlags)		; $63b1
	and AREAFLAG_PAST			; $63b4
	jr z,@showPresentText			; $63b6
	jr @showText			; $63b8

@showPresentText:
	ld a,c			; $63ba
	add $10			; $63bb
	ld c,a			; $63bd
@showText:
	ld b,>TX_2400		; $63be
	jp showText		; $63c0

@linked:
	ld a,(wAreaFlags)		; $63c3
	and AREAFLAG_PAST			; $63c6
	jr z,@showPresentText	; $63c8

	ld a,c			; $63ca
	add $20			; $63cb
	ld c,a			; $63cd
	jr @showText		; $63ce

;;
; Shows a text index, but adds $0c to the text index if in the present.
; @addr{63d0}
goron_showText_differentForPast:
	ld c,a			; $63d0
	ld a,(wAreaFlags)		; $63d1
	and AREAFLAG_PAST			; $63d4
	call z,@add0c		; $63d6
	ld b,>TX_2400		; $63d9
	jp showText		; $63db

@add0c:
	ld a,c			; $63de
	add $0c			; $63df
	ld c,a			; $63e1
	ret			; $63e2

;;
; @addr{63e3}
goron_showTextForGoronWorriedAboutElder:
	ld a,GLOBALFLAG_2f		; $63e3
	call checkGlobalFlag		; $63e5
	jr nz,+			; $63e8
	ld c,<TX_2479		; $63ea
	jr ++			; $63ec
+
	ld c,<TX_247a		; $63ee
++
	ld b,>TX_2400		; $63f0
	jp showText		; $63f2

;;
; Show text for a goron in the same cave as the elder, but in a different screen? They
; just comment on the state of affairs after you've saved the elder or not.
; @addr{63f5}
goron_showTextForSubid05:
	ld e,Interaction.var03		; $63f5
	ld a,(de)		; $63f7
	cp $03			; $63f8
	jr nc,@3OrHigher	; $63fa

	ld a,GLOBALFLAG_2f		; $63fc
	call checkGlobalFlag		; $63fe
	ld b,$00		; $6401
	jr z,+			; $6403
	ld b,$01		; $6405
+
	ld e,Interaction.var03		; $6407
	ld a,(de)		; $6409
	rlca			; $640a
	jr @showText		; $640b

@3OrHigher:
	ld b,$03		; $640d
@showText:
	add b			; $640f
	ld hl,@text		; $6410
	rst_addAToHl			; $6413
	ld b,>TX_2400		; $6414
	ld c,(hl)		; $6416
	jp showText		; $6417

@text:
	.db <TX_2482
	.db <TX_2483
	.db <TX_2484
	.db <TX_2485
	.db <TX_2486
	.db <TX_24e3
	.db <TX_24e2
	.db <TX_24e3
	.db <TX_24e5

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

;;
; Goron naps if Link is far away, gets up when he approaches.
;
; @param[out]	cflag	nc if Link is within 12 pixels (in $cddb)
; @addr{64f6}
goron_checkShouldBeNapping:
	ld bc,$1818		; $64f6
	call objectSetCollideRadii		; $64f9
	call objectCheckCollidedWithLink_ignoreZ		; $64fc
	ccf			; $64ff
	call _writeFlagsTocddb		; $6500
	ld bc,$0606		; $6503
	jp objectSetCollideRadii		; $6506

;;
; Get up from a nap?
; @addr{6509}
goron_faceDown:
	ld h,d			; $6509
	ld l,Interaction.invincibilityCounter		; $650a
	ld (hl),$00		; $650c
	ld l,Interaction.angle		; $650e
	ld (hl),$10		; $6510
	ld l,Interaction.var3f		; $6512
	ld (hl),$00		; $6514
	ld a,$02		; $6516
	jp interactionSetAnimation		; $6518

;;
; Set animation and set var3f to $01?
; @addr{651b}
goron_setAnimation:
	ld h,d			; $651b
	ld l,Interaction.var3f		; $651c
	ld (hl),$01		; $651e
	jp interactionSetAnimation		; $6520

;;
; @addr{6523}
goron_beginWalkingLeft:
	ld h,d			; $6523
	ld l,Interaction.speed		; $6524
	ld (hl),SPEED_80		; $6526
	ld l,Interaction.angle		; $6528
	ld (hl),$18		; $652a
	ld l,Interaction.var3c		; $652c
	ld (hl),$40		; $652e
	inc l			; $6530
	ld (hl),$00		; $6531
	ld l,Interaction.var3f		; $6533
	ld (hl),$01		; $6535
	ld a,$03		; $6537
	ld e,Interaction.var3e		; $6539
	ld (de),a		; $653b
	jp interactionSetAnimation		; $653c

;;
; @addr{653f}
goron_reverseWalkingDirection:
	ld h,d			; $653f
	ld l,Interaction.var3c		; $6540
	ld (hl),$80		; $6542
	inc l			; $6544
	ld (hl),$00		; $6545
	ld l,Interaction.angle		; $6547
	ld a,(hl)		; $6549
	xor $10			; $654a
	ld (hl),a		; $654c
	ld l,Interaction.var3e		; $654d
	ld a,(hl)		; $654f
	xor $02			; $6550
	ld (hl),a		; $6552
	jp interactionSetAnimation		; $6553

;;
; @addr{6556}
goron_refreshWalkingAnimation:
	ld e,Interaction.var3e		; $6556
	ld a,(de)		; $6558
	jp interactionSetAnimation		; $6559

;;
; @addr{655c}
goron_setSpeedToMoveDown:
	ld h,d			; $655c
	ld l,Interaction.speed		; $655d
	ld (hl),SPEED_100		; $655f
	ld l,Interaction.angle		; $6561
	ld (hl),$10		; $6563
	ld a,$02		; $6565
	jp goron_setAnimation		; $6567

;;
; @param[out]	zflag	z if Link's Y is same as this (in $cddb)
; @addr{656a}
goron_cpLinkY:
	xor a			; $656a
	ld hl,w1Link.yh		; $656b
	add (hl)		; $656e
	jr ++		; $656f

;;
; @addr{6571}
goron_cpYTo60:
	ld a,$60		; $6571
++
	ld h,d			; $6573
	ld l,Interaction.yh		; $6574
	cp (hl)			; $6576
	jp _writeFlagsTocddb		; $6577

;;
; @param[out]	zflag	z if Goron's X is Link's X minus 14 (in $cddb)
; @addr{657a}
goron_checkReachedLinkHorizontally:
	ld a,$f2		; $657a
	ld hl,w1Link.xh		; $657c
	add (hl)		; $657f
	jr ++			; $6580

;;
; @addr{6582}
goron_cpXTo48:
	ld a,$48		; $6582
++
	ld h,d			; $6584
	ld l,Interaction.xh		; $6585
	cp (hl)			; $6587
	jp _writeFlagsTocddb		; $6588

;;
; @param[out]	cflag	c if Link approached with bomb flower (in $cddb}
; @addr{658b}
goron_checkLinkApproachedWithBombFlower:
	ld a,TREASURE_BOMB_FLOWER		; $658b
	call checkTreasureObtained		; $658d
	call _writeFlagsTocddb		; $6590
	ret nc			; $6593

	; Store old Y/X position, replace with position we want to see Link cross
	ld h,d			; $6594
	ld l,Interaction.yh		; $6595
	ld a,(hl)		; $6597
	ld (hl),$88		; $6598
	push af			; $659a
	ld l,Interaction.xh		; $659b
	ld a,(hl)		; $659d
	ld (hl),$58		; $659e
	push af			; $65a0

	ld bc,$1808		; $65a1
	call objectSetCollideRadii		; $65a4
	call objectCheckCollidedWithLink_ignoreZ		; $65a7
	call _writeFlagsTocddb		; $65aa
	ld bc,$0606		; $65ad
	call objectSetCollideRadii		; $65b0

	; Restore old Y/X position
	pop af			; $65b3
	ld h,d			; $65b4
	ld l,Interaction.xh		; $65b5
	ld (hl),a		; $65b7
	pop af			; $65b8
	ld l,Interaction.yh		; $65b9
	ld (hl),a		; $65bb
	ret			; $65bc

;;
; Decrement var3c as a word (16 bits).
; @param[out]	zflag	z when var3c/3d hits 0
; @addr{65bd}
goron_decMovementCounter:
	ld h,d			; $65bd
	ld l,Interaction.var3c		; $65be
	call decHlRef16WithCap		; $65c0
	jp _writeFlagsTocddb		; $65c3

;;
; @addr{65c6}
goron_initCountersForBombFlowerExplosion:
	ld h,d			; $65c6
	ld l,Interaction.var3c		; $65c7
	ld (hl),90		; $65c9
	inc l			; $65cb
	ld (hl),$00		; $65cc
	ld l,Interaction.var3e		; $65ce
	ld (hl),$01		; $65d0
	ret			; $65d2

;;
; @addr{65d3}
goron_countdownToPlayRockSoundAndShakeScreen:
	ld h,d			; $65d3
	ld l,Interaction.var3e		; $65d4
	dec (hl)		; $65d6
	ret nz			; $65d7
	ld (hl),$05		; $65d8
	ld a,SND_BREAK_ROCK		; $65da
	call playSound		; $65dc
	ld a,$04		; $65df
	jp setScreenShakeCounter		; $65e1

;;
; @addr{65e4}
goron_createFallingRockSpawner:
	ld b,INTERACID_FALLING_ROCK		; $65e4
	jp objectCreateInteractionWithSubid00		; $65e6

;;
; Replaces the rock barrier in the goron cave with clear tiles.
; @addr{65e9}
goron_clearRockBarrier:
	ld hl,@clearedTiles		; $65e9

	ld c,$31		; $65ec
	call @clearRow		; $65ee

	ld c,$41		; $65f1
	call @clearRow		; $65f3

	ld c,$51		; $65f6
@clearRow:
	ld a,$05		; $65f8
@nextTile:
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
	jr nz,@nextTile	; $6608
	ret			; $660a

; This is the 5x3 rectangle of tiles to write over the rock barrier.
@clearedTiles:
	.db $a2 $a1 $a2 $a1 $a2
	.db $a1 $a2 $a1 $a2 $a1
	.db $a2 $a1 $a2 $a1 $a2

;;
; @addr{661a}
goron_createRockDebrisToLeft:
	ld bc,$f6fa		; $661a
	jr ++		; $661d

;;
; Creates 4 "rock debris" things?
; @addr{661f}
goron_createRockDebrisToRight:
	ld bc,$f606		; $661f
++
	call getRandomNumber		; $6622
	and $01			; $6625
	ldh (<hFF8D),a	; $6627
	xor a			; $6629
@nextRock:
	ldh (<hFF8B),a	; $662a
	call getFreeInteractionSlot		; $662c
	jr nz,@end	; $662f
	ld (hl),INTERACID_FALLING_ROCK		; $6631
	inc l			; $6633
	ld (hl),$02		; $6634
	inc l			; $6636
	ld (hl),$01		; $6637

	ld l,Interaction.counter1		; $6639
	ldh a,(<hFF8D)	; $663b
	ld (hl),a		; $663d
	ld l,Interaction.angle		; $663e
	ldh a,(<hFF8B)	; $6640
	ld (hl),a		; $6642

	call objectCopyPositionWithOffset		; $6643

	ldh a,(<hFF8B)	; $6646
	inc a			; $6648
	cp $04			; $6649
	jr nz,@nextRock	; $664b
@end:
	ld a,SND_BREAK_ROCK		; $664d
	jp playSound		; $664f

;;
; Tries to take 20 ember seeds and bombs from Link.
; @param[out]	zflag	Set if Link had the items (in $cddb)
; @addr{6652}
goron_tryTakeEmberSeedsAndBombs:
	ld a,TREASURE_SEED_SATCHEL		; $6652
	call checkTreasureObtained		; $6654
	jr nc,@dontGiveItems	; $6657
	ld a,TREASURE_EMBER_SEEDS		; $6659
	call checkTreasureObtained		; $665b
	jr nc,@dontGiveItems	; $665e

	cp $20			; $6660
	jr c,@dontGiveItems	; $6662
	push af			; $6664
	ld a,TREASURE_BOMBS		; $6665
	call checkTreasureObtained		; $6667
	jr nc,@popAndDontGiveItems	; $666a
	cp $20			; $666c
	jr c,@popAndDontGiveItems	; $666e

	sub $20			; $6670
	daa			; $6672
	ld (wNumBombs),a		; $6673
	pop af			; $6676
	sub $20			; $6677
	daa			; $6679
	ld (wNumEmberSeeds),a		; $667a
	call setStatusBarNeedsRefreshBit1		; $667d
	xor a			; $6680
	jp _writeFlagsTocddb		; $6681

@popAndDontGiveItems:
	pop af			; $6684
@dontGiveItems:
	or d			; $6685
	jp _writeFlagsTocddb		; $6686

;;
; @param[out]	zflag	Set if enough time passed for goron to finish breaking the cave
;			(in $cddb). (Uses tree refill system.)
; @addr{6689}
goron_checkEnoughTimePassed:
	ld a,(wSeedTreeRefilledBitset)		; $6689
	cpl			; $668c
	bit 0,a			; $668d
	call _writeFlagsTocddb		; $668f

;;
; Clear the bit used by the goron breaking down the cave that tracks progress (same system
; used as the one which refills trees).
; @addr{6692}
goron_clearRefillBit:
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
	ld a,TREASURE_BOOMERANG		; $66b0
	call checkTreasureObtained		; $66b2
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


;;
; Delete a treasure on the screen. Used during bomb flower explosion, for removing the
; displayed treasure when starting target carts, ...
; @addr{674e}
goron_deleteTreasure:
	ld b,INTERACID_TREASURE		; $674e
	call _goron_findInteractionWithID		; $6750
	ld l,Interaction.state		; $6753
	ld (hl),$04 ; State 4 causes deletion
	ret			; $6757

;;
; @addr{6758}
goron_deleteMinecartAndClearStaticObjects:
	ld b,INTERACID_MINECART		; $6758
	call _goron_findInteractionWithID		; $675a
	push de			; $675d
	ld e,l			; $675e
	ld d,h			; $675f
	call objectDelete_de		; $6760
	pop de			; $6763
	jp clearStaticObjects		; $6764

;;
; @param	b	ID to match
; @param[out]	zflag	z if match found
; @addr{6767}
_goron_findInteractionWithID:
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.enabled	; $6767
@loop:
	ld a,(hl)		; $676a
	or a			; $676b
	jr z,@next	; $676c
	inc l			; $676e
	ldd a,(hl)		; $676f
	cp b			; $6770
	jr nz,@next	; $6771
	xor a			; $6773
	ret			; $6774
@next:
	inc h			; $6775
	ld a,h			; $6776
	cp $e0			; $6777
	jr c,@loop	; $6779
	or h			; $677b
	ret			; $677c


;;
; @addr{677d}
goron_deleteCrystalsForTargetCarts:
	ldhl FIRST_ENEMY_INDEX, Enemy.enabled		; $677d
@loop:
	ld a,(hl)		; $6780
	or a			; $6781
	jr z,@nextEnemy	; $6782
	inc l			; $6784
	ldd a,(hl)		; $6785
	cp ENEMYID_63			; $6786
	jr nz,@nextEnemy	; $6788
	push de			; $678a
	push hl			; $678b
	ld e,l			; $678c
	ld d,h			; $678d
	call objectDelete_de		; $678e
	ld hl,wNumEnemies		; $6791
	dec (hl)		; $6794
	pop hl			; $6795
	pop de			; $6796
@nextEnemy:
	inc h			; $6797
	ld a,h			; $6798
	cp LAST_ENEMY_INDEX+1			; $6799
	jr c,@loop	; $679b
	ret			; $679d

	xor a			; $679e
	ld ($cfdb),a		; $679f
	ld ($cfdd),a		; $67a2
	ld ($cfde),a		; $67a5
	ld ($cfdc),a		; $67a8
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
	jp _writeFlagsTocddb		; $67c2
	ld a,(wLinkInAir)		; $67c5
	or a			; $67c8
	jp _writeFlagsTocddb		; $67c9
	ld a,($cfde)		; $67cc
	add $00			; $67cf
	daa			; $67d1
	ld hl,wTextNumberSubstitution		; $67d2
	ld (hl),a		; $67d5
	inc hl			; $67d6
	ld (hl),$00		; $67d7
	ret			; $67d9
	ld a,($cfde)		; $67da
	cp $0c			; $67dd
	jp _writeFlagsTocddb		; $67df
	ld a,($cfde)		; $67e2
	cp $09			; $67e5
	ccf			; $67e7
	jp _writeFlagsTocddb		; $67e8

;;
; Save Link's current inventory status, and equip the seed shooter with scent seeds
; equipped.
; @addr{67eb}
goron_configureInventoryForTargetCarts:
	ld bc,wInventoryB		; $67eb
	ld hl,$cfd7		; $67ee
	ld a,(bc)		; $67f1
	ldi (hl),a		; $67f2
	ld a,(wInventoryA)		; $67f3
	cp ITEMID_SHOOTER			; $67f6
	jr nz,@equipToA	; $67f8

@equipToB:
	xor a			; $67fa
	ld (bc),a		; $67fb
	inc c			; $67fc
	ld a,(bc)		; $67fd
	ldi (hl),a		; $67fe
	ld a,ITEMID_SHOOTER		; $67ff
	ld (bc),a		; $6801
	jr @setupSeedShooter		; $6802

@equipToA:
	ld a,ITEMID_SHOOTER		; $6804
	ld (bc),a		; $6806
	inc c			; $6807
	ld a,(bc)		; $6808
	ldi (hl),a		; $6809
	xor a			; $680a
	ld (bc),a		; $680b

@setupSeedShooter:
	; Save Link's scent seed count to $cfd9, then give him 99 seeds for the game
	ld c,<wNumScentSeeds		; $680c
	ld a,(bc)		; $680e
	ldi (hl),a		; $680f
	ld a,$99		; $6810
	ld (bc),a		; $6812

	; Save currently selected seeds to $cfda, then equip scent seeds
	ld c,<wShooterSelectedSeeds		; $6813
	ld a,(bc)		; $6815
	ldi (hl),a		; $6816
	ld a,$01		; $6817
	ld (bc),a		; $6819

	ld a,$ff		; $681a
	ld (wStatusBarNeedsRefresh),a		; $681c
	ret			; $681f

;;
; @addr{6820}
goron_restoreInventoryAfterTargetCarts:
	ld bc,wInventoryB		; $6820
	ld hl,$cfd7		; $6823
	ldi a,(hl)		; $6826
	ld (bc),a		; $6827
	inc c			; $6828
	ldi a,(hl)		; $6829
	ld (bc),a		; $682a

	ld c,<wNumScentSeeds		; $682b
	ldi a,(hl)		; $682d
	ld (bc),a		; $682e

	ld c,<wShooterSelectedSeeds		; $682f
	ldi a,(hl)		; $6831
	ld (bc),a		; $6832

	ld a,$ff		; $6833
	ld (wStatusBarNeedsRefresh),a		; $6835
	ret			; $6838

	call getThisRoomFlags		; $6839
	bit 5,(hl)		; $683c
	ld a,$00		; $683e
	jr z,++			; $6840
	call getRandomNumber		; $6842
	and $01			; $6845
	inc a			; $6847
++
	ld ($cfd4),a		; $6848
	ld hl,objectData.objectData7870		; $684b
	jp parseGivenObjectData		; $684e

	xor a			; $6851
_label_15_160:
	ldh (<hFF8B),a	; $6852
	ld hl,$cfdd		; $6854
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
	ld a,TREASURE_LAVA_JUICE		; $686d
	call checkTreasureObtained		; $686f
	jr nc,_label_15_162	; $6872
	ld a,TREASURE_MERMAID_KEY		; $6874
	call checkTreasureObtained		; $6876
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
	call checkTreasureObtained		; $6896
	jr c,_label_15_166	; $6899
	ld a,b			; $689b
	cp $08			; $689c
	jr nz,_label_15_165	; $689e
_label_15_166:
	ld a,b			; $68a0
	cp $03			; $68a1
	jr nz,_label_15_167	; $68a3
	ld a,TREASURE_LAVA_JUICE		; $68a5
	call checkTreasureObtained		; $68a7
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
	call _writeFlagsTocddb		; $6902
	cpl			; $6905
	ld ($cddb),a		; $6906
	ret			; $6909
	call getFreePartSlot		; $690a
	ret nz			; $690d
	ld (hl),$49		; $690e
	inc l			; $6910
	ld (hl),$ff		; $6911
	ret			; $6913

;;
; @addr{6914}
goron_createBombFlowerSprite:
	call getFreeInteractionSlot		; $6914
	ret nz			; $6917
	ld (hl),INTERACID_TREASURE		; $6918
	inc l			; $691a
	ld (hl),TREASURE_BOMB_FLOWER		; $691b
	inc l			; $691d
	ld (hl),$01		; $691e
	ld l,Interaction.yh		; $6920
	ld (hl),$60		; $6922
	ld l,Interaction.xh		; $6924
	ld (hl),$38		; $6926
	ret			; $6928

;;
; When var3a counts down to 0, this creates some explosions.
; @addr{6929}
goron_countdownToNextExplosionGroup:
	ld h,d			; $6929
	ld l,Interaction.var3a		; $692a
	dec (hl)		; $692c
	ret nz			; $692d

	; var3b is the index for the "explosion group".
	ld l,Interaction.var3b		; $692e
	ld a,(hl)		; $6930
	inc a			; $6931
	and $07			; $6932
	ld (hl),a		; $6934
	ldh (<hFF8B),a	; $6935

	ld bc,@counters		; $6937
	call addAToBc		; $693a
	ld a,(bc)		; $693d
	ld l,Interaction.var3a		; $693e
	ld (hl),a		; $6940

	ldh a,(<hFF8B)	; $6941
	add a			; $6943
	ld bc,@explosionIndices		; $6944
	call addDoubleIndexToBc		; $6947
	ld a,$04		; $694a
@next:
	ldh (<hFF8D),a	; $694c
	ld a,(bc)		; $694e
	cp $ff			; $694f
	ret z			; $6951
	push bc			; $6952
	call goron_createExplosionIndex		; $6953
	pop bc			; $6956
	inc bc			; $6957
	ldh a,(<hFF8D)	; $6958
	dec a			; $695a
	jr nz,@next	; $695b
	ret			; $695d

; Values to set var3a to (counters until next group of explosions occur)
@counters:
	.db $0b $0b $0b $16 $0b $0b $0b $0b

; Each row is a group of explosion indices ($ff to stop).
@explosionIndices:
	.db $01 $02 $ff $ff
	.db $03 $06 $ff $ff
	.db $04 $05 $ff $ff
	.db $07 $ff $ff $ff
	.db $03 $06 $ff $ff
	.db $04 $05 $ff $ff
	.db $01 $02 $ff $ff
	.db $00 $ff $ff $ff

;;
; Used with bomb flower cutscene.
; @param	a	Index of the explosion (determines position to put it at)
; @addr{6986}
goron_createExplosionIndex:
	ld bc,@positions		; $6986
	call addDoubleIndexToBc		; $6989
	call getFreeInteractionSlot		; $698c
	ret nz			; $698f
	ld (hl),INTERACID_EXPLOSION		; $6990
	ld l,Interaction.yh		; $6992
	ld a,(bc)		; $6994
	ld (hl),a		; $6995
	inc bc			; $6996
	ld l,Interaction.xh		; $6997
	ld a,(bc)		; $6999
	ld (hl),a		; $699a
	ret			; $699b

@positions:
	.db $60 $38
	.db $48 $28
	.db $48 $48
	.db $38 $18
	.db $38 $58
	.db $58 $18
	.db $58 $58
	.db $40 $38

	ld hl,$69f2		; $69ac
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

; @addr{6a85}
goron_subid08_pressedAScript:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifroomflagset $40, @alreadyTraded
	jumpifroomflagset $80, @alreadyMovedAside

	asm15 goron_showText_differentForPast, <TX_2490
	wait 30
	jumpifitemobtained TREASURE_BROTHER_EMBLEM, @moveAside

	asm15 goron_showText_differentForPast, <TX_2491
	jump2byte goron_enableInputAndResumeNappingLoop

; Link has the goron emblem, move aside
@moveAside:
	asm15 goron_showText_differentForPast, <TX_2492
	wait 30

	setspeed SPEED_080
	asm15 goron_setAnimation, $03
	setangle $18
	applyspeed $21

	setanimation $02
	wait 30

	asm15 goron_showText_differentForPast, <TX_2493
	wait 30

	orroomflag $80
	asm15 goron_checkInPresent
	jumpifmemoryset $cddb, CPU_ZFLAG, @checkSirloin_1

; Check goron vase
	jumpifitemobtained TREASURE_GORON_VASE, @haveVaseOrSirloin
	jump2byte goron_enableInputAndResumeNappingLoop

@checkSirloin_1:
	jumpifitemobtained TREASURE_ROCK_SIRLOIN, @haveVaseOrSirloin
	jump2byte goron_enableInputAndResumeNappingLoop


@alreadyMovedAside:
	; Check if already talked to him once (this gets cleared if you leave the screen?)
	jumpifmemoryeq $cfc0, $01, @promptForTradeAfterRejection

	asm15 goron_showText_differentForPast, <TX_2494
	wait 30

	asm15 goron_checkInPresent
	jumpifmemoryset $cddb, CPU_ZFLAG, @checkSirloin_2

; Check goron vase
	jumpifitemobtained TREASURE_GORON_VASE, @haveVaseOrSirloin
	jump2byte @dontHaveVaseOrSirloin

@checkSirloin_2:
	jumpifitemobtained TREASURE_ROCK_SIRLOIN, @haveVaseOrSirloin

@dontHaveVaseOrSirloin:
	asm15 goron_showText_differentForPast, <TX_2495 ; "Yeah, a vase/sirloin would be great"
	jump2byte goron_enableInputAndResumeNappingLoop


@haveVaseOrSirloin:
	asm15 goron_showText_differentForPast <TX_2496
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

@rejectedTrade:
	asm15 goron_showText_differentForPast, <TX_2497
	writememory $cfc0, $01
	jump2byte goron_enableInputAndResumeNappingLoop

; This gets executed if you say no, then talk to him again.
@promptForTradeAfterRejection:
	asm15 goron_showText_differentForPast, <TX_2498
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade
	jump2byte @rejectedTrade


@acceptedTrade:
	asm15 goron_showText_differentForPast, <TX_2499
	wait 30

	asm15 goron_checkInPresent
	jumpifmemoryset $cddb, CPU_ZFLAG, @giveVase

; Get goronade, lose goron vase
	asm15 loseTreasure TREASURE_GORON_VASE
	giveitem TREASURE_GORONADE, $00
	jump2byte ++

; Get vase, lose rock sirloin
@giveVase:
	asm15 loseTreasure, TREASURE_ROCK_SIRLOIN
	giveitem TREASURE_GORON_VASE, $00
++
	orroomflag $40
	wait 30
	asm15 goron_showText_differentForPast, <TX_249a
	jump2byte goron_enableInputAndResumeNappingLoop

@alreadyTraded:
	asm15 goron_showText_differentForPast, <TX_249b
	jump2byte goron_enableInputAndResumeNappingLoop


script15_6b3d:
	initcollisions
	asm15 checkEssenceObtained, $02
	jumpifmemoryset $cddb $80 @script15_6b58
	settextid $2708
@script15_6b4b:
	checkabutton
	asm15 turnToFaceLink
	showloadedtext
	wait 10
	setanimation $02
	settextid $270a
	jump2byte @script15_6b4b
@script15_6b58:
	checkabutton
	disableinput
	jumpifroomflagset $20 @script15_6b7a
	showtextlowindex $10
	wait 30
	jumpiftradeitemeq $0a @script15_6b67
	jump2byte @script15_6b7c
@script15_6b67:
	showtextlowindex $11
	wait 30
	jumpiftextoptioneq $00 @script15_6b72
	showtextlowindex $13
	jump2byte @script15_6b7c
@script15_6b72:
	showtextlowindex $12
	wait 30
	giveitem $410a
	jump2byte @script15_6b7c
@script15_6b7a:
	showtextlowindex $14
@script15_6b7c:
	enableinput
	jump2byte @script15_6b58

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
	jp _writeFlagsTocddb		; $6ba1
	ldi a,(hl)		; $6ba4
	sub $22			; $6ba5
	cp $54			; $6ba7
	ret nc			; $6ba9
	inc l			; $6baa
	ld a,(hl)		; $6bab
	sub $14			; $6bac
	cp $84			; $6bae
	ret			; $6bb0

;;
; Sets Link's object ID in such a way that he will move to a specific position.
;
; @param	a	Value for var03
; @addr{6bb1}
moveLinkToPosition:
	push af			; $6bb1
	ld a,SPECIALOBJECTID_LINK_CUTSCENE		; $6bb2
	call setLinkIDOverride		; $6bb4

	ld l,<w1Link.subid		; $6bb7
	ld (hl),$05		; $6bb9

	ld l,<w1Link.var03		; $6bbb
	pop af			; $6bbd
	ld (hl),a		; $6bbe
	ret			; $6bbf

	ld a,($c783)		; $6bc0
	bit 7,a			; $6bc3
	jp _writeFlagsTocddb		; $6bc5
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
	ld hl,wMaxBombs		; $6be1
	ldd a,(hl)		; $6be4
	ld (hl),a		; $6be5
	ret			; $6be6

; @addr{6be7}
script15_6be7:
	disableinput
	asm15 restartSound
	writememory $cc91 $01
	asm15 $6b84
	wait 60
	spawninteraction $0500 $58 $28
	wait 4
	settileat $52 $f9
	writememory $cfc0 $01
	checkmemoryeq $cfc0 $02
	wait 30
	showtext $1202
	wait 30
	writememory $cfc0 $03
	checkmemoryeq $cfc0 $04
	wait 30
	showtext $05d0
	wait 30
	setmusic $21
	writememory $cfc0 $05
	enableinput
	setcollisionradii $04 $50
	checkcollidedwithlink_ignorez
	disableinput
	asm15 forceLinkDirectionAndPutOnGround, $00
	writememory $cfc0 $06
	checkmemoryeq $cfc0 $08
	wait 30
	showtext $1203
	playsound SND_DING
	wait 40
	writememory $cfc0 $09
	wait 2
	enableinput
script15_6c3c:
	jumptable_memoryaddress $cdd1
	.dw script15_6c4b
	.dw script15_6c45
	.dw script15_6c3c
script15_6c45:
	wait 20
	showtext $05d1
	checknoenemies
	wait 20
script15_6c4b:
	showtext $05d2
	wait 30
	disableinput
	asm15 restartSound
	wait 20
	playsound SND_DING
	wait 20
	playsound SND_DING
	wait 20
	playsound SND_DING
	wait 30
	asm15 moveLinkToPosition, $00
	wait 1
	checkmemoryeq $d001 $00
	wait 30
	showtext $05d3
	wait 30
	spawninteraction $7601 $00 $00
script15_6c70:
	jumpifroomflagset $80 script15_6c77
	wait 1
	jump2byte script15_6c70
script15_6c77:
	wait 40
	setglobalflag $3f
	showtext $05d6
	writememory wMakuMapTextPast $d6
	setglobalflag $12
	asm15 incMakuTreeState
	asm15 $6b8a
	resetmusic
	enableinput
script15_6c8c:
	wait 1
	asm15 $6b95
	jumpifmemoryset $cddb $80 script15_6c8c
	showtext $05d4
	writememory $cc91 $00
	scriptend

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

; @addr{6cd7}
script15_6cd7:
	asm15 $6c9e $00
	wait 20
	asm15 $6c9e $01
	wait 20
	asm15 $6c9e $02
	checkmemoryeq $cfd2 $03
	wait 20
	showtext $1100
	wait 8
	showtext $1101
	wait 8
	showtext $1102
	wait 8
	showtext $1103
	checktext
	writememory $cfd2 $00
	checkmemoryeq $cfd2 $03
	scriptend
script15_6d03:
	checkmemoryeq $cfd2 $01
	wait 20
	asm15 $6ca9
	writememory $cfd2 $00
	checkmemoryeq $cfd2 $01
	scriptend
script15_6d14:
	setcollisionradii $20 $01
	makeabuttonsensitive
script15_6d18:
	checkcollidedwithlink_ignorez
	showtext $110c
	jumpiftextoptioneq $00 script15_6d26
	asm15 $6cc4
	wait 10
	jump2byte script15_6d18
script15_6d26:
	scriptend

	ld a,$0b		; $6d27
	ld (wLinkForceState),a		; $6d29
	ld a,$08		; $6d2c
	ld (wLinkStateParameter),a		; $6d2e
	ld hl,w1Link.direction		; $6d31
	xor a			; $6d34
	ldi (hl),a		; $6d35
	ld (hl),a		; $6d36
	ret			; $6d37
	ld a,SNDCTRL_STOPMUSIC		; $6d38
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
	jp loseTreasure		; $6ded

; @addr{6df0}
script15_6df0:
	checkmemoryeq $cfd2 $02
	showtext $1126
	writememory $cfd2 $00
	checkmemoryeq $cfd2 $01
	enableinput
	scriptend
script15_6e01:
	jumpifmemoryset wDimitriState $01 script15_6e16
script15_6e07:
	jumpifmemoryset $d13e $02 script15_6e0f
script15_6e0d:
	jump2byte script15_6e07
script15_6e0f:
	showtext $2100
	ormemory wDimitriState $01
script15_6e16:
	checkmemoryeq $d13d $01
	jumpifmemoryset wDimitriState $02 script15_6e2a
	showtext $2100
	writememory $d13d $00
	enableinput
	jump2byte script74e3 ; TODO
script15_6e2a:
	disableinput
	jumpifmemoryeq $c610 $0c script15_6e36
	showtext $2101
	jump2byte script15_6e39
script15_6e36:
	showtext $2102
script15_6e39:
	writememory $d103 $01
	setdisabledobjectsto00
	checkmemoryeq $cc2c $d1
	showtext $2106
	ormemory wDimitriState $20
	enableinput
	scriptend
script15_6e4b:
	showtext $1120
	checkmemoryeq $cfd2 $02
	showtext $1121
	jumpiftextoptioneq $00 script15_6e60
script15_6e59:
	showtext $1121
	jumpiftextoptioneq $01 script15_6e59
script15_6e60:
	showtext $1130
	writememory $cfd2 $00
	checkmemoryeq $cfd2 $01
	orroomflag $40
	setglobalflag $ab
	setglobalflag $42
script15_6e71:
	enableinput
	scriptend
script15_6e73:
	checkmemoryeq $d13d $01
	disableinput
	jumpifmemoryset wRickyState $01 script15_6e90
	ormemory wRickyState $01
	jumpifmemoryeq $c610 $0b script15_6e8d
	showtext $2000
	jump2byte script15_6e90
script15_6e8d:
	showtext $2001
script15_6e90:
	jumpifitemobtained $48 script15_6e9e
	showtext $2003
	writememory $d13d $00
	enableinput
	jump2byte script74df ; TODO
script15_6e9e:
	showtext $2004
	asm15 $6deb
	writememory $d103 $01
	setdisabledobjectsto00
	checkmemoryeq $cc2c $d1
	showtext $2005
	ormemory wRickyState $20
	enablemenu
	scriptend
script15_6eb6:
	disableinput
	showtext $112b
	wait 30
	showtext $112c
	wait 30
	showtext $112d
	wait 30
	showtext $112e
	wait 30
	showtext $112f
	writememory $cfd2 $00
script15_6ece:
	jumpifmemoryeq $cfd2 $03 script15_6ed7
	wait 1
	jump2byte script15_6ece
script15_6ed7:
	showtext $1131
	writeobjectbyte $44 $02
	checktext
	showtext $1132
	writememory $d103 $01
	setglobalflag $23
	checkmemoryeq $cc2c $d1
	setglobalflag $2b
	enableinput
	scriptend
script15_6eef:
	checkmemoryeq $d13d $01
	disableinput
	showtext $1131
	asm15 $6dad
	wait 60
	showtext $1132
	asm15 $6dd5
script15_6f01:
	jumpifmemoryeq $cfd2 $02 script15_6f0a
	wait 1
	jump2byte script15_6f01
script15_6f0a:
	showtext $112a
	setglobalflag $24
	asm15 $6de0
	scriptend

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
	call loseTreasure		; $6f60
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
	ld (wMaxBombs),a		; $6fdf
	ld c,a			; $6fe2
	ld a,TREASURE_BOMBS		; $6fe3
	jp giveTreasure		; $6fe5
	ld a,$ff		; $6fe8
	ld ($cfd0),a		; $6fea
	ld a,$04		; $6fed
	jp fadeinFromWhiteWithDelay		; $6fef
	ld a,GLOBALFLAG_1c		; $6ff2
	jp setGlobalFlag		; $6ff4

; @addr{6ff7}
script15_6ff7:
	wait 30
script15_6ff8:
	showtext $0c00
	jumptable_memoryaddress $cba5
	.dw script15_7004
	.dw script15_7036
	.dw script15_7058
script15_7004:
	wait 60
	showtext $0c01
	jumpiftextoptioneq $01 script15_6ff8
	wait 60
	showtext $0c02
	jumpiftextoptioneq $01 script15_6ff8
	wait 60
	writememory $cfd0 $01
	wait 30
	showtext $0c03
	asm15 $6f9d
	wait 120
	asm15 playSound $79
	asm15 fadeoutToWhite
	wait 1
	asm15 $6fc3
	wait 1
	asm15 $6fe8
	wait 1
	showtext $0c04
	wait 30
	scriptend
script15_7036:
	wait 60
	showtext $0c05
	jumpiftextoptioneq $01 script15_6ff8
	wait 60
	writememory $cfd0 $01
	wait 30
	showtext $0c06
	asm15 $6fad
	wait 20
	asm15 $6fd2
	wait 1
	asm15 $6fe8
	wait 1
	showtext $0c04
	wait 30
	scriptend
script15_7058:
	writememory $cfd0 $01
	wait 30
	showtext $0c07
	wait 30
	asm15 $6f9d
	wait 120
	asm15 playSound $79
	asm15 fadeoutToWhite
	wait 1
	asm15 $6fdc
	asm15 $6fe8
	wait 1
	showtext $0c08
	wait 30
	asm15 $6ff2
	scriptend

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

; @addr{7139}
script15_7139:
	jumptable_objectbyte $7e
	.dw script15_7149
	.dw script15_7158
	.dw script15_7170
	.dw script15_718f
	.dw script15_718f
	.dw script15_719e
	.dw script15_71bd
script15_7149:
	asm15 $707c $00
	setcollisionradii $08 $08
	makeabuttonsensitive
script15_7151:
	checkabutton
	asm15 $7082 $00
	jump2byte script15_7151
script15_7158:
	asm15 $707c $00
	setcollisionradii $08 $08
	makeabuttonsensitive
script15_7160:
	checkabutton
	asm15 $707c $03
	asm15 $7082 $00
	wait 1
	asm15 $707c $00
	jump2byte script15_7160
script15_7170:
	asm15 $707c $00
	setcollisionradii $08 $08
script15_7177:
	makeabuttonsensitive
script15_7178:
	checkabutton
	disableinput
	asm15 $7082 $00
	wait 30
	asm15 $707c $04
	asm15 $7087 $01
	wait 1
	asm15 $707c $00
	enableinput
	jump2byte script15_7178
script15_718f:
	asm15 $707c $04
	setcollisionradii $08 $08
	makeabuttonsensitive
script15_7197:
	checkabutton
	asm15 $7082 $00
	jump2byte script15_7197
script15_719e:
	asm15 $707c $00
	setcollisionradii $08 $08
	makeabuttonsensitive
script15_71a6:
	checkabutton
	disableinput
	asm15 $707c $02
	asm15 $7082 $00
	wait 30
	asm15 $707c $00
	asm15 $7082 $01
	wait 1
	enableinput
	jump2byte script15_71a6
script15_71bd:
	disablemenu
	asm15 $707c $00
	setcollisionradii $08 $08
	makeabuttonsensitive
	checkpalettefadedone
	wait 210
	showtextlowindex $64
	wait 60
	playsound SNDCTRL_STOPMUSIC
	asm15 $707c $04
	wait 60
	playsound SND_MAKUDISAPPEAR
	writememory wCutsceneTrigger $07
	wait 210
	showtextlowindex $40
	playsound SND_MAKUDISAPPEAR
	wait 210
	showtextlowindex $41
	playsound SND_MAKUDISAPPEAR
	wait 150
	writememory $cfc0 $01
	asm15 incMakuTreeState
	scriptend
script15_71ef:
	asm15 $7105
	setmusic $1e
	asm15 $707c $00
	setcollisionradii $08 $08
	makeabuttonsensitive
	jumpifroomflagset $80 script15_7277
	checkabutton
	disableinput
	asm15 $707c $02
	showtextlowindex $42
	wait 30
	asm15 $707c $03
	showtextlowindex $43
	wait 30
	asm15 $707c $01
	showtextlowindex $44
	wait 30
	asm15 $707c $00
	showtextlowindex $45
	wait 30
	asm15 $707c $01
	showtextlowindex $46
	wait 30
	asm15 $707c $04
	showtextlowindex $47
	wait 30
script15_722c:
	asm15 $707c $00
	showtextlowindex $48
	wait 30
	asm15 $707c $04
	showtextlowindex $49
	wait 30
	wait 30
	asm15 $707c $00
	showtextlowindex $4a
	wait 30
	jumpiftextoptioneq $00 script15_722c
	asm15 $707c $00
	showtextlowindex $4b
	wait 30
	asm15 $707c $04
	showtextlowindex $4c
	wait 30
	showtextlowindex $4d
	wait 30
	asm15 $707c $03
	showtextlowindex $4e
	wait 30
	asm15 $707c $00
	showtextlowindex $4f
	wait 30
	setglobalflag $3e
	writememory $c6e6 $4f
	showtextlowindex $50
	wait 30
	asm15 $70d1
	wait 140
	showtextlowindex $61
	wait 30
	enableinput
script15_7277:
	checkabutton
	disableinput
	asm15 $707c $00
	showtextlowindex $4f
	wait 30
	asm15 $707c $00
	enableinput
	jump2byte script15_7277
script15_7287:
	disableinput
	wait 60
	showtextlowindex $59
	wait 30
	asm15 $7125
	checkmemoryeq $cfc0 $01
	playsound SND_GETSEED
	giveitem $3600
	wait 30
	writememory wCutsceneTrigger $0e
	checkmemoryeq $cfc0 $02
	setanimation $02
	scriptend
script15_72a4:
	disableinput
	asm15 $712b
	checkpalettefadedone
	wait 60
	showloadedtext
	wait 20
	setanimation $00
	wait 10
	writememory $c6e6 $60
	addobjectbyte $72 $01
	showloadedtext
	wait 20
	setglobalflag $13
	writememory $cfc0 $04
	asm15 incMakuTreeState
	enableinput
	setcollisionradii $08 $08
	makeabuttonsensitive
script15_72c6:
	checkabutton
	showloadedtext
	jump2byte script15_72c6

	ld e,$7b		; $72ca
	ld (de),a		; $72cc
	jp interactionSetAnimation		; $72cd

; @addr{72d0}
script15_72d0:
	jumptable_objectbyte $7e
	.dw script15_72d8
	.dw script15_72ec
	.dw script15_7304
script15_72d8:
	asm15 $72ca $02
	setcollisionradii $08 $08
	makeabuttonsensitive
	checkabutton
	asm15 $7082 $00
script15_72e5:
	checkabutton
	asm15 $7082 $01
	jump2byte script15_72e5
script15_72ec:
	asm15 $72ca $00
	setcollisionradii $08 $08
	makeabuttonsensitive
script15_72f4:
	checkabutton
	asm15 $72ca $01
	asm15 $7082 $00
	wait 1
	asm15 $72ca $00
	jump2byte script15_72f4
script15_7304:
	asm15 $72ca $00
	setcollisionradii $08 $08
	makeabuttonsensitive
	checkabutton
	asm15 $7082 $00
script15_7311:
	checkabutton
	asm15 $7082 $01
	jump2byte script15_7311

	call fadeoutToBlackWithDelay		; $7318
	jr _label_15_208		; $731b
	call fadeinFromBlackWithDelay		; $731d
_label_15_208:
	ld a,$ff		; $7320
	ld (wDirtyFadeBgPalettes),a		; $7322
	ld (wFadeBgPaletteSources),a		; $7325
	ld a,$01		; $7328
	ld (wDirtyFadeSprPalettes),a		; $732a
	ld a,$fe		; $732d
	ld (wFadeSprPaletteSources),a		; $732f
	ret			; $7332
	ld e,$43		; $7333
	ld a,(de)		; $7335
	cp $09			; $7336
	ret nz			; $7338
	jpab bank1.checkInitUnderwaterWaves		; $7339
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

; @addr{7355}
script15_7355:
	jumpifglobalflagset $14 stubScript ; TODO
	asm15 checkEssenceObtained $04
	jumpifmemoryset $cddb $80 stubScript
	initcollisions
	jumpifroomflagset $40 script15_7391
	asm15 $7341
	checkpalettefadedone
	checkobjectbyteeq $61 $ff
	wait 180
	asm15 $734b
	showtext $2487
	wait 30
	asm15 moveLinkToPosition $01
	wait 1
	checkmemoryeq $d001 $00
	wait 30
	showtext $2488
	wait 30
	giveitem $4300
	disableinput
	setglobalflag $2f
	orroomflag $40
	wait 30
	enableinput
	jump2byte script15_7392
script15_7391:
	checkabutton
script15_7392:
	showtext $2489
	jump2byte script15_7391
script15_7397:
	jumpifglobalflagset $14 stubScript ; TODO
	asm15 checkEssenceNotObtained $04
	jumpifmemoryset $cddb $80 stubScript
	initcollisions
script15_73a6:
	checkabutton
	showtext $24e4
	jump2byte script15_73a6
script15_73ac:
	wait 16
	asm15 objectWritePositionTocfd5
	asm15 objectSetVisible82
	writememory $cfd0 $08
	playsound MUS_DISASTER
	asm15 forceLinkDirection $01
	wait 120
	showtextlowindex $01
	wait 40
	writememory $cfd0 $09
	playsound SNDCTRL_FAST_FADEOUT
	scriptend
script15_73c9:
	wait 16
	asm15 objectSetVisible82
	playsound MUS_DISASTER
	wait 60
	showtextlowindex $11
	wait 30
	scriptend

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
	ld a,SND_DOORCLOSE		; $73f1
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

;;
; @addr{741b}
objectWritePositionTocfd5:
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

; @addr{742b}
script15_742b:
	setanimation $02
	writeobjectbyte $48 $02
	asm15 $741c $18
	asm15 forceLinkDirection $00
	wait 90
	asm15 $741c $f0
	playsound MUS_DISASTER
	wait 20
	showtextlowindex $03
	wait 20
	asm15 $741c $40
	wait 16
	showtextlowindex $04
	wait 20
	asm15 $741c $f0
	wait 16
	showtextlowindex $05
	wait 20
	asm15 $741c $40
	wait 16
	showtextlowindex $06
	wait 20
	asm15 $741c $18
	wait 16
	showtextlowindex $07
	wait 60
	playsound SNDCTRL_FAST_FADEOUT
	wait 30
	scriptend
script15_746b:
	setanimation $02
	writeobjectbyte $48 $02
	wait 90
	showtextlowindex $12
	wait 20
	showtextlowindex $13
	wait 20
	showtextlowindex $14
	wait 60
	scriptend
script15_747b:
	setanimation $02
	writeobjectbyte $48 $02
	wait 30
	playsound MUS_DISASTER
	wait 60
	showtextlowindex $16
	wait 20
	showtextlowindex $17
	wait 60
	writememory $cfc0 $03
	wait 240
	scriptend
script15_7490:
	wait 60
	showtextlowindex $18
	wait 20
	showtextlowindex $19
	wait 60
	scriptend

	ld h,d			; $7498
	ld l,$54		; $7499
	ld a,$80		; $749b
	ldi (hl),a		; $749d
	ld (hl),$fe		; $749e
	ld a,$01		; $74a0
	ld (wDisabledObjects),a		; $74a2
	ld (wMenuDisabled),a		; $74a5
	ld (wTextIsActive),a		; $74a8
	ld a,SND_ENEMY_JUMP		; $74ab
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
	call clearAllItemsAndPutLinkOnGround		; $74d5
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
	jp resetCamera		; $74ee
	call objectGetLinkRelativeAngle		; $74f1
	add $04			; $74f4
	and $18			; $74f6
	swap a			; $74f8
	rlca			; $74fa
	ld e,$48		; $74fb
	ld (hl),a		; $74fd
	jp interactionSetAnimation		; $74fe

; @addr{7501}
script15_7501:
	initcollisions
script15_7502:
	checkabutton
	jumpifmemoryset $c8be $06 script15_7512
	ormemory $c8be $06
	showtextnonexitable $5800
	jump2byte script15_7515
script15_7512:
	showtextnonexitable $5801
script15_7515:
	jumpiftextoptioneq $00 script15_751e
	showtext $5802
	jump2byte script15_7502
script15_751e:
	jumptable_objectbyte $78
	.dw script15_7529
	.dw script15_7524
script15_7524:
	showtext $5803
	jump2byte script15_7502
script15_7529:
	asm15 $74b0
	showtextnonexitable $5804
	jumpiftextoptioneq $00 script15_7538
	showtext $5805
	jump2byte script15_7502
script15_7538:
	asm15 $7498
	wait 8
	showtext $5806
	wait 8
	scriptend
script15_7541:
	initcollisions
script15_7542:
	checkabutton
	showtextnonexitable $5810
	jumpiftextoptioneq $00 script15_754f
	showtext $5802
	jump2byte script15_7542
script15_754f:
	asm15 $74b0
	showtextnonexitable $5804
	jumpiftextoptioneq $00 script15_755e
	showtext $5805
	jump2byte script15_7542
script15_755e:
	asm15 $7498
	wait 8
	showtext $5806
	wait 8
	scriptend
script15_7567:
	initcollisions
script15_7568:
	checkabutton
	showtextnonexitable $5807
	jumpiftextoptioneq $01 script15_7581
	showtextnonexitable $5808
	jumpiftextoptioneq $00 script15_7589
	asm15 $74b0
	showtextnonexitable $5809
	jumpiftextoptioneq $00 script15_7589
script15_7581:
	asm15 $74b0
	showtext $5805
	jump2byte script15_7568
script15_7589:
	showtext $580a
	asm15 $74c0 $a0
	wait 8
	scriptend

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
	ld a,SND_DOORCLOSE		; $75ae
	jp playSound		; $75b0

; @addr{75b3}
script15_75b3:
	makeabuttonsensitive
script15_75b4:
	setanimation $04
	checkabutton
	setanimation $05
	jumpifglobalflagset $23 script15_75c3
	showtextlowindex $01
	setglobalflag $22
	jump2byte script15_75b4
script15_75c3:
	jumpifmemoryeq $cfd0 $01 script15_75e3
	showtextlowindex $02
	jumpiftextoptioneq $00 script15_75d3
	showtextlowindex $03
	jump2byte script15_75b4
script15_75d3:
	showtextlowindex $04
script15_75d5:
	jumpiftextoptioneq $00 script15_75dd
	showtextlowindex $05
	jump2byte script15_75d5
script15_75dd:
	writememory $cfd0 $01
	jump2byte script15_75b4
script15_75e3:
	showtextlowindex $06
	jump2byte script15_75b4
script15_75e7:
	wait 8
	playsound SNDCTRL_FAST_FADEOUT
	asm15 setLinkDirection $00
	setangle $00
	applyspeed $6c
	wait 60
	playsound MUS_DISASTER
	asm15 darkenRoom
	writememory $ffa9 $00
	writememory $ffa7 $00
	checkpalettefadedone
	wait 90
	writememory $cfc0 $01
	playsound SND_LIGHTNING
	wait 34
	playsound SND_LIGHTNING
	checkmemoryeq $cfc0 $02
	asm15 $764a $03
	wait 20
	writeobjectbyte $78 $01
	setspeed SPEED_080
	asm15 setLinkDirection $01
	setangle $18
	applyspeed $61
	wait 90
	writeobjectbyte $78 $00
	setspeed SPEED_0c0
	setangle $08
	applyspeed $41
	wait 30
	playsound SND_WIND
	asm15 $764a $04
	wait 10
	setspeed SPEED_140
	setangle $18
	applyspeed $31
	wait 90
	asm15 $764a $05
	writeobjectbyte $78 $01
	setspeed SPEED_080
	setangle $08
	applyspeed $ff
	wait 60
	scriptend

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

; @addr{766e}
script15_766e:
	asm15 $7654
	wait 60
	showtextlowindex $02
	setmusic $f0
	setspeed SPEED_100
	moveright $10
	asm15 $7654
	movedown $0a
	setmusic $31
	wait 125
	setstate $02
	xorcfc0bit 1
	setspeed SPEED_180
	moveleft $10
	wait 15
	callscript script7bb5
	callscript script7bb5
	setstate $04
	wait 120
	xorcfc0bit 1
	setstate $02
	moveright $10
	setanimation $02
	xorcfc0bit 1
	wait 70
	setstate $03
	moveright $10
	setanimation $02
	wait 15
	callscript script7bc8
	callscript script7bc8
	moveleft $10
	setanimation $02
	wait 90
	playsound SNDCTRL_STOPMUSIC
	playsound SND_BIG_EXPLOSION
	xorcfc0bit 1
	setstate $02
	setspeed SPEED_100
	asm15 $7654
	movedown $18
	setanimation $03
	asm15 $765a
	wait 90
	showtextlowindex $03
	wait 60
	asm15 $7665
	checkcfc0bit 7
	wait 60
	playsound SNDCTRL_STOPSFX
	giveitem $2600
	xorcfc0bit 0
	orroomflag $40
	enableinput
	resetmusic
	setcollisionradii $06 $06
	setstate $01
	jump2byte script7bae ; TODO

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
	ld ($cfc1),a		; $770a
	ret			; $770d
	call checkIsLinkedGame		; $770e
	ld a,$01		; $7711
	jr nz,_label_15_217	; $7713
	dec a			; $7715
_label_15_217:
	ld ($cfc1),a		; $7716
	ret			; $7719
	ld a,SND_CLINK		; $771a
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
	ld a,SNDCTRL_STOPMUSIC		; $7739
	call playSound		; $773b
	xor a			; $773e
	ld (wDisabledObjects),a		; $773f
	ld (wMenuDisabled),a		; $7742
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE		; $7745
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

; @addr{775b}
script15_775b:
	asm15 objectSetInvisible
	checkmemoryeq $cfc0 $01
	asm15 objectSetVisible82
	checkmemoryeq $cfc0 $06
	setanimation $03
	wait 8
	writememory $cfc0 $07
	showtext $3d0c
	wait 10
	setanimation $07
	setangle $18
	setspeed SPEED_020
	applyspeed $1e
	writememory $cfc0 $08
	scriptend
script15_7781:
	wait 180
	setspeed SPEED_080
	moveleft $c0
	writeobjectbyte $79 $01
	wait 120
	setanimation $00
	wait 150
	writememory $cfdf $01
	scriptend
script15_7793:
	checkobjectbyteeq $45 $01
	wait 30
	setspeed SPEED_100
	moveright $19
	wait 4
	moveup $10
	wait 4
	moveright $0d
	wait 8
	setmusic $38
	showtext $0601
	asm15 $7755
	wait 30
	showtext $0602
	wait 30
	asm15 $7739
	scriptend
script15_77b3:
	checkpalettefadedone
	wait 60
	setspeed SPEED_080
	movedown $61
	wait 60
	asm15 createExclamationMark $28
	setanimation $08
	wait 60
	setspeed SPEED_100
	writememory $cfd1 $01
	movedown $31
	wait 6
	writememory $cfd1 $02
	setanimation $03
	checkmemoryeq $cfd1 $03
	showtext $0600
	wait 120
	writememory $cfdf $ff
	scriptend
script15_77de:
	wait 120
	showtextlowindex $09
	wait 30
	showtextlowindex $0a
	wait 30
	scriptend

	xor a			; $77e6
	ld (wActiveMusic),a		; $77e7
	ld a,MUS_MINIBOSS		; $77ea
	jp playSound		; $77ec
	ld a,TREASURE_TUNI_NUT		; $77ef
	call checkTreasureObtained		; $77f1
	ld b,$00		; $77f4
	jr nc,_label_15_221	; $77f6
	inc b			; $77f8
	or a			; $77f9
	jr z,_label_15_221	; $77fa
	inc b			; $77fc
_label_15_221:
	ld a,b			; $77fd
	ld ($cfc1),a		; $77fe
	ret			; $7801
	call getThisRoomFlags		; $7802
	ld e,$42		; $7805
	ld a,(de)		; $7807
	sub $08			; $7808
	or (hl)			; $780a
	ld (hl),a		; $780b
	ret			; $780c
	call $77ef		; $780d
	ld a,($cfc1)		; $7810
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
	ld ($cfc1),a		; $7828
	ret			; $782b
	ld a,TREASURE_RING_BOX		; $782c
	call checkTreasureObtained		; $782e
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

; @addr{7849}
script15_7849:
	jumpifglobalflagset $14 script15_7890
	setstate $ff
	jumpifglobalflagset $29 script7daf ; TODO
script15_7853:
	initcollisions
	checkabutton
	disableinput
	jumpifglobalflagset $2e script15_7879
	showtextlowindex $10
	jumpiftextoptioneq $00 script15_7865
	showtextlowindex $13
	enableinput
	jump2byte script15_7853
script15_7865:
	asm15 $7802
	setglobalflag $2e
	showtextlowindex $11
script15_786c:
	jumpiftextoptioneq $00 script15_7874
	showtextlowindex $14
	jump2byte script15_786c
script15_7874:
	showtextlowindex $12
	enableinput
	jump2byte script15_7888
script15_7879:
	enableinput
	asm15 $780d
	jumptable_memoryaddress $cfc1
	.dw script15_7888
	.dw script15_788c
	.dw script15_788e
	.dw script15_788a
script15_7888:
	rungenericnpclowindex $12
script15_788a:
	rungenericnpclowindex $15
script15_788c:
	rungenericnpclowindex $16
script15_788e:
	rungenericnpclowindex $17
script15_7890:
	initcollisions
script15_7891:
	checkabutton
	disableinput
	jumpifglobalflagset $77 script15_78d8
	showtextlowindex $24
	wait 30
	jumpiftextoptioneq $00 script15_78a2
	showtextlowindex $25
	jump2byte script15_78dc
script15_78a2:
	askforsecret $09
	wait 30
	jumpifmemoryeq $cc89 $00 script15_78af
	showtextlowindex $27
	jump2byte script15_78dc
script15_78af:
	setglobalflag $6d
	showtextlowindex $26
	wait 30
	jumpifitemobtained $2c script15_78bc
	showtextlowindex $2a
	jump2byte script15_78c1
script15_78bc:
	showtextlowindex $28
	wait 30
	showtextlowindex $29
script15_78c1:
	wait 30
	asm15 $782c
	jumpifmemoryeq $cba8 $05 script15_78d0
	giveitem $2c01
	jump2byte script15_78d3
script15_78d0:
	giveitem $2c02
script15_78d3:
	wait 30
	orroomflag $20
	setglobalflag $77
script15_78d8:
	generatesecret $09
	showtextlowindex $2b
script15_78dc:
	enableinput
	jump2byte script15_7891
script15_78df:
	jumpifglobalflagset $2e script15_78e5
	rungenericnpclowindex $0b
script15_78e5:
	jumpifglobalflagset $29 script15_792e
	jumpifroomflagset $40 script15_78f1
	jumpifglobalflagset $2a script15_78fd
script15_78f1:
	orroomflag $40
	setglobalflag $2a
	jumpifitemobtained $4c script15_78fb
	rungenericnpclowindex $00
script15_78fb:
	rungenericnpclowindex $01
script15_78fd:
	asm15 $77ef
	jumptable_memoryaddress $cfc1
	.dw script15_790d
	.dw script15_7909
	.dw script15_790b
script15_7909:
	rungenericnpclowindex $08
script15_790b:
	rungenericnpclowindex $09
script15_790d:
	initcollisions
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $02
	disableinput
	wait 30
	showtextlowindex $04
	jump2byte script15_791c
script15_7918:
	checkabutton
	showtextlowindex $04
	disableinput
script15_791c:
	jumpiftextoptioneq $00 script15_7925
	showtextlowindex $07
	enableinput
	jump2byte script15_7918
script15_7925:
	showtextlowindex $05
	wait 30
	giveitem $4c00
	enableinput
	jump2byte script15_7909
script15_792e:
	rungenericnpclowindex $0a

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

; @addr{7948}
script15_7948:
	initcollisions
script15_7949:
	checkabutton
	disableinput
	showtextdifferentforlinked TX_3600 TX_3601
	jumpiftextoptioneq $00 script15_7956
	enableinput
	jump2byte script15_7949
script15_7956:
	showtextdifferentforlinked TX_3604 TX_3605
	xorcfc0bit 0
	wait 60
	showtext $3607
	checkcfc0bit 1
	asm15 loseTreasure $4e
	showtext $3606
	wait 30
	giveitem $4f00
	wait 60
	asm15 $7930
	setglobalflag $34
	scriptend

	ld c,$54		; $7972
	ld a,$a2		; $7974
	call setTile		; $7976
	inc c			; $7979
	ld a,$ef		; $797a
	call setTile		; $797c
	inc c			; $797f
	ld a,$a4		; $7980
	call setTile		; $7982
	ld a,SND_DOORCLOSE		; $7985
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

; @addr{79b2}
script15_79b2:
	jumpifglobalflagset $14 script15_79b7
	scriptend
script15_79b7:
	initcollisions
script15_79b8:
	checkabutton
	disableinput
	jumpifglobalflagset $70 script15_7a30
	jumpifmemoryeq $cfd5 $00 script15_79ca
	jumpifmemoryeq $ccd5 $01 script15_7a16
script15_79ca:
	jumpifglobalflagset $66 script15_79f2
	showtext $2c06
	wait 30
	jumpiftextoptioneq $00 script15_79dc
	showtext $2c07
	enableinput
	jump2byte script15_79b8
script15_79dc:
	askforsecret $02
	wait 30
	jumpifmemoryeq $cc89 $00 script15_79eb
	showtext $2c09
	enableinput
	jump2byte script15_79b8
script15_79eb:
	setglobalflag $66
	showtext $2c08
	jump2byte script15_79f5
script15_79f2:
	showtext $2c0e
script15_79f5:
	wait 30
	jumpiftextoptioneq $00 script15_7a00
	showtext $2c0f
	enableinput
	jump2byte script15_79b8
script15_7a00:
	showtext $2c0a
	wait 30
	jumpiftextoptioneq $01 script15_7a00
	showtext $2c0b
	writememory $cfd5 $01
	enableinput
script15_7a10:
	checkabutton
	showtext $2c10
	jump2byte script15_7a10
script15_7a16:
	writememory $ccd5 $00
	asm15 $67da
	jumpifmemoryset $cddb $80 script15_7a26
	enableinput
	jump2byte script15_7a10
script15_7a26:
	showtext $2c0c
	wait 30
	giveitem $0d02
	wait 30
	setglobalflag $70
script15_7a30:
	generatesecret $02
	showtext $2c0d
	enableinput
	jump2byte script15_79b8
script15_7a38:
	jumpifglobalflagset $14 stubScript ; TODO
	initcollisions
script15_7a3d:
	checkabutton
	jumpifroomflagset $40 script15_7a4c
	asm15 $79a7
	showtext $2c11
	orroomflag $40
	jump2byte script15_7a3d
script15_7a4c:
	asm15 $79a7
	showtext $2c12
	jump2byte script15_7a3d

;;
; Check that a secret-related NPC should spawn (correct essence obtained)?
; @addr{7a54}
linkedNpc_checkShouldSpawn:
	call checkIsLinkedGame		; $7a54
	jr nz,++		; $7a57
	jp _writeFlagsTocddb		; $7a59
++
	ld e,Interaction.var3f		; $7a5c
	ld a,(de)		; $7a5e
	rst_jumpTable			; $7a5f
	.dw @checkd4
	.dw @checkd1
	.dw @always
	.dw @always
	.dw @always
	.dw @always
	.dw @checkd2
	.dw @always
	.dw @always
	.dw @checkd2_2

@checkd4:
	ld a,$03		; $7a74
	jp checkEssenceNotObtained		; $7a76
@checkd1:
	ld a,$00		; $7a79
	jp checkEssenceNotObtained		; $7a7b
@checkd2:
	ld a,$01		; $7a7e
	jp checkEssenceNotObtained		; $7a80
@checkd2_2:
	ld a,$01		; $7a83
	jp checkEssenceNotObtained		; $7a85
@always:
	or d			; $7a88
	jp _writeFlagsTocddb		; $7a89

;;
; Checks whether the linked NPC asks you for additional confirmation before giving you the
; secret (some of them have an extra box of text)
; @addr{7a8c}
linkedNpc_checkHasExtraTextBox:
	ld e,Interaction.var3f		; $7a8c
	ld a,(de)		; $7a8e
	ld hl,@data		; $7a8f
	rst_addAToHl			; $7a92
	ld a,(hl)		; $7a93
	or a			; $7a94
	jp _writeFlagsTocddb		; $7a95

@data:
	.db $01 $01 $01 $00 $00 $00 $01 $00 $00 $01

;;
; @addr{7aa2}
linkedNpc_generateSecret:
	ld h,d			; $7aa2
	ld l,$7f		; $7aa3
	ld b,(hl)		; $7aa5
	ld a,GLOBALFLAG_50		; $7aa6
	add b			; $7aa8
	call setGlobalFlag		; $7aa9
	ld a,$20		; $7aac
	add b			; $7aae
	ld (wShortSecretIndex),a		; $7aaf
	ld bc,$0003		; $7ab2
	jp secretFunctionCaller		; $7ab5

;;
; @addr{7ab8}
linkedNpc_initHighTextIndex:
	ld a,>TX_4d00		; $7ab8
	jp interactionSetHighTextIndex		; $7aba

;;
; Loads a text index for linked npcs. Each linked npc has text indices that they say.
;
; @param	a	Index of text (0-4)
; @addr{7abd}
linkedNpc_calcLowTextIndex:
	add <TX_4d00			; $7abd
	ld c,a			; $7abf

	; a = [var3f]*5
	ld e,Interaction.var3f		; $7ac0
	ld a,(de)		; $7ac2
	ld b,a			; $7ac3
	add a			; $7ac4
	add a			; $7ac5
	add b			; $7ac6

	add c			; $7ac7
	ld e,Interaction.textID		; $7ac8
	ld (de),a		; $7aca
	ret			; $7acb

; @addr{7acc}
script15_7acc:
	jumpifglobalflagset $14 script15_7ada
	jumpifglobalflagset $11 script15_7ad7
	rungenericnpc $3714
script15_7ad7:
	rungenericnpc $3715
script15_7ada:
	initcollisions
script15_7adb:
	checkabutton
	disableinput
	jumpifglobalflagset $71 script15_7b0e
	showtext $3700
	wait 30
	jumpiftextoptioneq $00 script15_7aee
	showtext $3701
	jump2byte script15_7b11
script15_7aee:
	askforsecret $03
	wait 30
	jumpifmemoryeq $cc89 $00 script15_7afc
	showtext $3703
	jump2byte script15_7b11
script15_7afc:
	setglobalflag $67
	showtext $3702
	wait 30
	asm15 giveRingAToLink $2f
	setglobalflag $71
	wait 30
	showtext $3704
	jump2byte script15_7b11
script15_7b0e:
	showtext $3705
script15_7b11:
	enableinput
	jump2byte script15_7adb

	ld a,(wScrollMode)		; $7b14
	and $01			; $7b17
	call _writeFlagsTocddb		; $7b19
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
	ld ($cfc1),a		; $7b2b
	ret			; $7b2e
	ld a,SND_DOORCLOSE		; $7b2f
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


