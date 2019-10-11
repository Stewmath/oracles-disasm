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

;;
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


;;
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


; ==============================================================================
; INTERACID_SHOPKEEPER
; ==============================================================================

;;
; @addr{411c}
shopkeeper_take10Rupees:
	ld a,RUPEEVAL_10		; $411c
	jp removeRupeeValue		; $411e


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
	ld hl,_movingPlatform_scriptTable		; $4128
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


.macro plat_wait
	.db $00, \1
.endm
.macro plat_move
	.db $01, \1
.endm
.macro plat_setangle
	.db $02, \1
.endm
.macro plat_setspeed
	.db $03, \1
.endm
.macro plat_jump
	.db $04, (\1-CADDR)&$ff
.endm
.macro plat_waitforlink
	.db $05
.endm
.macro plat_up
	.db $08, \1
.endm
.macro plat_right
	.db $09, \1
.endm
.macro plat_down
	.db $0a, \1
.endm
.macro plat_left
	.db $0b, \1
.endm

_movingPlatform_scriptTable:
	.dw @dungeon00
	.dw @dungeon01
	.dw @dungeon02
	.dw @dungeon03
	.dw @dungeon04
	.dw @dungeon05
	.dw @dungeon06
	.dw @dungeon07
	.dw @dungeon08


@dungeon00:
@dungeon01:
	.dw @@platform0
	.dw @@platform1

@@platform0:
	plat_wait  $08
	plat_up    $80
	plat_wait  $08
	plat_down  $80
	plat_jump @@platform0

@@platform1:
	plat_wait  $08
	plat_left  $40
--
	plat_wait  $08
	plat_right $80
	plat_wait  $08
	plat_left  $80
	plat_jump --


@dungeon02:
@dungeon03:
@dungeon04:
	.dw @@platform0
	.dw @@platform1
	.dw @@platform2
	.dw @@platform3
	.dw @@platform4
	.dw @@platform5

@@platform0:
	plat_wait  $08
	plat_up    $60
--
	plat_wait  $08
	plat_down  $a0
	plat_wait  $08
	plat_up    $a0
	plat_jump --

@@platform1:
	plat_wait  $08
	plat_up    $20
--
	plat_wait  $08
	plat_down  $c0
	plat_wait  $08
	plat_up    $c0
	plat_jump --

@@platform2:
	plat_wait  $08
	plat_up    $40
--
	plat_wait  $08
	plat_down  $a0
	plat_wait  $08
	plat_up    $a0
	plat_jump --

@@platform3:
	plat_wait  $08
	plat_right $20
--
	plat_wait  $08
	plat_left  $c0
	plat_wait  $08
	plat_right $c0
	plat_jump --

@@platform4:
	plat_wait  $08
	plat_down  $60
	plat_wait  $08
	plat_up    $60
	plat_jump @@platform4

@@platform5:
	plat_wait  $08
	plat_left  $20
--
	plat_wait  $08
	plat_right $a0
	plat_wait  $08
	plat_left  $a0
	plat_jump --

@dungeon05:
@dungeon06:
@dungeon07:
@dungeon08:


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
	ld a,<TX_051c		; $4306
	ld (wMakuMapTextPresent),a		; $4308
	ld a,<TX_058c		; $430b
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


	.include "objects/ages/pointers.s"

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
	ld a,CUTSCENE_WALL_RETRACTION		; $4f9b
	ld (wCutsceneTrigger),a		; $4f9d
	jp resetLinkInvincibility		; $4fa0

;;
; @addr{4fa3}
moonlitGrotto_enableControlAfterBreakingCrystal:
	xor a			; $4fa3
	ld (wDisabledObjects),a		; $4fa4
	ld (wMenuDisabled),a		; $4fa7
_label_15_031:
	ld (wDisableScreenTransitions),a		; $4faa
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
	ld hl,wTmpcfc0.shootingGallery.savedBItem	; $50bf
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
	ld hl,wTmpcfc0.shootingGallery.savedBItem		; $50d6
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
setLinkToState08AndSetDirection:
	ld hl,w1Link.direction		; $5176
	ld (hl),a		; $5179

setLinkToState08:
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

;;
; @param	a	Value to add to $ccd4
; @addr{51a6}
addToccd4:
	ld hl,$ccd4		; $51a6
	jr ++			; $51a9

;;
; @addr{51ab}
addTocfc0:
	ld hl,$cfc0		; $51ab
++
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
	jumpifglobalflagset GLOBALFLAG_CAN_BUY_FLUTE @checkScoreForFluteGame

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


; Cutscene after Nayru is possessed
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
	jp interactionAnimate		; $586d

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
	jumpiftradeitemeq TRADEITEM_FUNNY_JOKE, @offerTrade

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
	asm15 setLinkToState08AndSetDirection, DIR_DOWN
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

	asm15 setLinkToState08AndSetDirection, DIR_UP
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
	call objectGetAngleTowardLink		; $5bee
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
	jumpiftradeitemeq TRADEITEM_STINK_BAG, @askForTrade

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
	call objectGetAngleTowardLink		; $5ca8
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
	jumpiftradeitemeq TRADEITEM_DUMBBELL, @offerTrade
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
	jumpifglobalflagset GLOBALFLAG_DONE_LIBRARY_SECRET, @alreadyToldSecret

	; Ask if Link has a secret to tell
	showtext TX_3310
	wait 30

	jumpiftextoptioneq $00, @promptForSecret

	; Said "no"
	showtext TX_3311
	jump2byte @warpLinkOut

@promptForSecret:
	generateoraskforsecret $04
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret

	; Invalid secret
	showtext TX_3311
	jump2byte @warpLinkOut

@validSecret:
	setglobalflag GLOBALFLAG_BEGAN_LIBRARY_SECRET
	showtext TX_3312
	wait 30
	callscript scriptFunc_doEnergySwirlCutscene
	wait 30
	asm15 oldManGiveShieldUpgradeToLink
	wait 30

	setglobalflag GLOBALFLAG_DONE_LIBRARY_SECRET
	generateoraskforsecret $14
	showtext TX_3313
	jump2byte @warpLinkOut

@alreadyToldSecret:
	generateoraskforsecret $14
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
	jumpiftradeitemeq TRADEITEM_DOGGIE_MASK, @askForTrade

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
	jumpifglobalflagset GLOBALFLAG_BEGAN_MAMAMU_SECRET, @alreadyToldSecret
	showtextlowindex <TX_0b3a
	wait 30

	jumpiftextoptioneq $00, @promptForSecret

	showtextlowindex <TX_0b3b
	jump2byte @enableInputAndLoop

@promptForSecret:
	generateoraskforsecret $06
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret

	; Invalid secret
	showtextlowindex <TX_0b3d
	jump2byte @enableInputAndLoop

@validSecret:
	setglobalflag GLOBALFLAG_BEGAN_MAMAMU_SECRET
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
	jumpiftradeitemeq TRADEITEM_POE_CLOCK, @promptForTrade
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
	call objectGetAngleTowardLink		; $5f75
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

	jumpiftradeitemeq TRADEITEM_SEA_UKELELE, @offerTrade

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
	jumpiftradeitemeq TRADEITEM_TASTY_MEAT, @promptForTrade
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
	jumpiftradeitemeq TRADEITEM_CHEESY_MUSTACHE, @promptForTrade
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

;;
; @addr{62ef}
goronDance_clearVariables:
	ld b,wTmpcfc0.goronDance.dataEnd - wTmpcfc0.goronDance		; $62ef
	ld hl,wTmpcfc0.goronDance		; $62f1
	call clearMemory		; $62f4

	ld a,DIR_DOWN		; $62f7
	ld (wTmpcfc0.goronDance.danceAnimation),a		; $62f9

	ld hl,w1Link.direction		; $62fc
	ld (hl),DIR_DOWN		; $62ff
	ld h,d			; $6301
	ld l,Interaction.state		; $6302
	ld (hl),$01		; $6304
	inc l			; $6306
	ld (hl),$00		; $6307
	ret			; $6309

;;
; @addr{630a}
goronDance_restartGame:
	xor a			; $630a
	ld (wTmpcfc0.goronDance.roundIndex),a		; $630b
	ld (wTmpcfc0.goronDance.numFailedRounds),a		; $630e
	ld hl,w1Link.direction		; $6311
	ld (hl),DIR_DOWN		; $6314
	ld b,$0a		; $6316
	jpab interactionBank1.shootingGallery_initializeGameRounds		; $6318

;;
; @param[out]	zflag	Set if in present (in $cddb)
; @addr{6320}
goron_checkInPresent:
	ld a,(wAreaFlags)		; $6320
	and AREAFLAG_PAST			; $6323
	jp _writeFlagsTocddb		; $6325

;;
; Unused?
; @param[out]	zflag	Set if in past (in $cddb)
; @addr{6328}
goron_checkInPast:
	ld a,(wAreaFlags)		; $6328
	cpl			; $632b
	and AREAFLAG_PAST			; $632c
	jp _writeFlagsTocddb		; $632e

;;
; @addr{6331}
goronDance_initLinkPosition:
	ld a,DIR_DOWN		; $6331
	ld bc,$5c50		; $6333
	jr _goron_setLinkPositionAndDirection		; $6336

;;
; @addr{6338}
goron_targetCarts_setLinkPositionToCartPlatform:
	ld a,DIR_UP		; $6338
	ld bc,$8838		; $633a
	jr _goron_setLinkPositionAndDirection		; $633d

;;
; @addr{633f}
goron_targetCarts_setLinkPositionAfterGame:
	ld a,DIR_RIGHT		; $633f
	ld bc,$78a8		; $6341
	jr _goron_setLinkPositionAndDirection		; $6344

;;
; @addr{6346}
goron_bigBang_initLinkPosition:
	ld a,DIR_UP		; $6346
	ld bc,$4850		; $6348

_goron_setLinkPositionAndDirection:
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

;;
; Updates wTextNumberSubstitution with number of completed rounds.
;
; @param[out]	zflag	z if didn't fail any rounds (in $cddb)
; @addr{635b}
goronDance_checkNumFailedRounds:
	ld a,(wTmpcfc0.goronDance.numFailedRounds)		; $635b
	ld b,a			; $635e
	ld a,$08		; $635f
	sub b			; $6361
	ld hl,wTextNumberSubstitution		; $6362
	ld (hl),a		; $6365

	inc hl			; $6366
	ld (hl),$00		; $6367
	ld a,(wTmpcfc0.goronDance.numFailedRounds)		; $6369
	or a			; $636c
	jp _writeFlagsTocddb		; $636d

;;
; Give the reward for a perfect game at platinum or gold level.
; @addr{6370}
goronDance_giveRandomRingPrize:
	ld a,(wAreaFlags)		; $6370
	and AREAFLAG_PAST			; $6373
	jr nz,@past	; $6375
	ld b,$02		; $6377
	jr @giveRingForLevel		; $6379
@past:
	ld b,$00		; $637b
	ld a,(wTmpcfc0.goronDance.danceLevel)		; $637d
	cp $00			; $6380
	jr z,@giveRingForLevel	; $6382
	ld b,$02		; $6384

@giveRingForLevel:
	call getRandomNumber		; $6386
	and $01			; $6389
	add b			; $638b
	ld hl,@rings		; $638c
	rst_addAToHl			; $638f
	ld a,(hl)		; $6390
	jp giveRingAToLink		; $6391

@rings:
	.db BOMBERS_RING,   PROTECTION_RING ; Platinum level
	.db BOMBPROOF_RING, GREEN_HOLY_RING ; Gold level

;;
; Shows text, and adds $20 to the index if in the present.
; @addr{6398}
goron_showText_differentForPresent:
	ld c,a			; $6398
	ld a,(wAreaFlags)		; $6399
	and AREAFLAG_PAST			; $639c
	call z,@add20		; $639e
	ld b,>TX_2400		; $63a1
	jp showText		; $63a3

@add20:
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
	ld a,GLOBALFLAG_SAVED_GORON_ELDER		; $63e3
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

	ld a,GLOBALFLAG_SAVED_GORON_ELDER		; $63fc
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

;;
; Determines value for Interaction.textID depending on game status...
;
; If textID ends up being $ff after calling this, the goron deletes itself.
;
; If in past, there are 3 states:
;   $00: before saving elder
;   $01: after saving elder
;   $02: after beating game
;
; If in present, there are 4 states:
;   $00: before beating d4
;   $01: after beating d4
;   $02: after beating King Moblin
;   $03: after beating game
; @addr{6423}
goron_determineTextForGenericNpc:
	call @getGameState		; $6423
	jp @determineTextID		; $6426


; Writes value from $00-$02 (past) or $00-$03 (present) representing game state to var3e.
@getGameState:
	ld a,(wAreaFlags)		; $6429
	and AREAFLAG_PAST			; $642c
	jr z,@inPresent	; $642e

@inPast:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6430
	call checkGlobalFlag		; $6432
	jr nz,@val02	; $6435

	ld a,GLOBALFLAG_SAVED_GORON_ELDER		; $6437
	call checkGlobalFlag		; $6439
	jr nz,@val01	; $643c
	jr @val00		; $643e

@inPresent:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6440
	call checkGlobalFlag		; $6442
	jr nz,@val03	; $6445

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $6447
	call checkGlobalFlag		; $6449
	jr nz,@val02	; $644c

	ld a,$03		; $644e
	ld hl,wEssencesObtained		; $6450
	call checkFlag		; $6453
	jr nz,@val01	; $6456

@val00:
	xor a			; $6458
	jr @writeVal		; $6459
@val01:
	ld a,$01		; $645b
	jr @writeVal		; $645d
@val02:
	ld a,$02		; $645f
	jr @writeVal		; $6461
@val03:
	ld a,$03		; $6463
@writeVal:
	ld e,Interaction.var3b		; $6465
	ld (de),a		; $6467
	ret			; $6468

@determineTextID:
	ld e,Interaction.subid		; $6469
	ld a,(de)		; $646b
	sub $0c			; $646c
	ld hl,@textTable		; $646e
	rst_addAToHl			; $6471
	ld a,(hl)		; $6472
	rst_addAToHl			; $6473

	ld e,Interaction.var03		; $6474
	ld a,(de)		; $6476
	rlca			; $6477
	rst_addDoubleIndex			; $6478
	ld e,Interaction.var3b		; $6479
	ld a,(de)		; $647b
	rst_addAToHl			; $647c
	ld a,(hl)		; $647d
	ld e,Interaction.textID		; $647e
	ld (de),a		; $6480
	ld b,a			; $6481

	inc e			; $6482
	ld a,>TX_3100		; $6483
	ld (de),a		; $6485

	ld a,b			; $6486
	cp <TX_3127			; $6487
	ret nz			; $6489
	call checkIsLinkedGame		; $648a
	ret nz			; $648d

	ld a,$ff		; $648e
	dec e			; $6490
	ld (de),a		; $6491
	ret			; $6492

@textTable:
	.db @subid0c-CADDR
	.db @subid0d-CADDR
	.db @subid0e-CADDR

; Each row has 4 bytes:
;   b0: text before saving elder (past) or before beating d4 (present)
;   b1: text after saving elder (past) or after beating d4 (present)
;   b2: text after beating game (past) or after beating King Moblin (present)
;   b3: text after beating game (present)
; Value $ff means the goron will delete itself.
@subid0e:
	.db $00 $ff $ff $ff ; 0x00 == [var03]
	.db $ff $01 $01 $01 ; 0x01
	.db $ff $02 $02 $02 ; 0x02
	.db $ff $ff $03 $04 ; 0x03
	.db $ff $ff $05 $05 ; 0x04
	.db $ff $ff $06 $06 ; 0x05
	.db $ff $ff $07 $08 ; 0x06
	.db $09 $0a $0a $00 ; 0x07
	.db $ff $0b $0b $00 ; 0x08
	.db $ff $0c $0d $00 ; 0x09
	.db $ff $0e $0f $00 ; 0x0a

@subid0d:
	.db $ff $10 $11 $12 ; 0x00
	.db $ff $13 $14 $ff ; 0x01
	.db $ff $15 $15 $16 ; 0x02
	.db $1a $1a $1b $00 ; 0x03
	.db $ff $1c $1d $00 ; 0x04

@subid0c:
	.db $ff $1e $1f $20 ; 0x00
	.db $ff $ff $21 $22 ; 0x01
	.db $ff $ff $23 $23 ; 0x02
	.db $ff $ff $24 $24 ; 0x03
	.db $ff $25 $26 $00 ; 0x04
	.db $ff $27 $ff $00 ; 0x05
	.db $ff $ff $17 $18 ; 0x06
	.db $ff $ff $19 $19 ; 0x07


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
; @param[out]	zflag	z if Link had the items (in $cddb)
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
; @param[out]	zflag	z if enough time passed for goron to finish breaking the cave
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

;;
; Spawns the prize in the "display area" just before starting the minigame.
; @addr{6698}
goron_targetCarts_spawnPrize:
	call getThisRoomFlags		; $6698
	bit ROOMFLAG_BIT_ITEM,(hl)		; $669b
	jr nz,@alreadyGotBrisket	; $669d

	xor a			; $669f
	jr @spawnPrize		; $66a0

@alreadyGotBrisket:
	call getRandomNumber		; $66a2
	and $0f			; $66a5
	ld hl,@possiblePrizes		; $66a7
	rst_addAToHl			; $66aa
	ld a,(hl)		; $66ab

	; Only give boomerang if not obtained already
	cp $04			; $66ac
	jr nz,@spawnPrize	; $66ae
	ld a,TREASURE_BOOMERANG		; $66b0
	call checkTreasureObtained		; $66b2
	ld a,$04		; $66b5
	jr nc,@spawnPrize			; $66b7

	ld a,$03		; $66b9

@spawnPrize:
	ld (wTmpcfc0.targetCarts.prizeIndex),a		; $66bb
	ld hl,@prizes		; $66be
	rst_addDoubleIndex			; $66c1
	ld b,(hl)		; $66c2
	inc l			; $66c3
	ld c,(hl)		; $66c4
	call getFreeInteractionSlot		; $66c5
	ret nz			; $66c8

	ld (hl),INTERACID_TREASURE		; $66c9
	inc l			; $66cb
	ld (hl),b		; $66cc
	inc l			; $66cd
	ld (hl),c		; $66ce
	ld l,Interaction.yh		; $66cf
	ld (hl),$78		; $66d1
	ld l,Interaction.xh		; $66d3
	ld (hl),$78		; $66d5
	ret			; $66d7

@possiblePrizes:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $02 $02 $02 $03 $03 $04 $04 $04

@prizes:
	.db TREASURE_ROCK_BRISKET, $01
	.db TREASURE_RUPEES,       $11
	.db TREASURE_RUPEES,       $12
	.db TREASURE_GASHA_SEED,   $06
	.db TREASURE_BOOMERANG,    $01

;;
; Spawns the prize shown by the goron just before starting the minigame.
; @addr{66f2}
goron_bigBang_spawnPrize:
	call getThisRoomFlags		; $66f2
	bit 5,(hl)		; $66f5
	jr nz,@alreadyGotMermaidKey	; $66f7

	xor a			; $66f9
	jr @checkSpawnPrize		; $66fa

@alreadyGotMermaidKey:
	call getRandomNumber		; $66fc
	and $0f			; $66ff
	ld hl,@possiblePrizes		; $6701
	rst_addAToHl			; $6704
	ld a,(hl)		; $6705

@checkSpawnPrize:
	; If random number is 4, choose randomly between the 2 rings
	cp $04			; $6706
	jr nz,@spawnPrize	; $6708
	call getRandomNumber		; $670a
	and $01			; $670d
	add $04			; $670f

@spawnPrize:
	ld (wTmpcfc0.bigBangGame.prizeIndex),a		; $6711
	ld hl,@prizes		; $6714
	rst_addDoubleIndex			; $6717
	ld b,(hl)		; $6718
	inc l			; $6719
	ld c,(hl)		; $671a
	call getFreeInteractionSlot		; $671b
	ret nz			; $671e

	ld (hl),INTERACID_TREASURE		; $671f
	inc l			; $6721
	ld (hl),b		; $6722
	inc l			; $6723
	ld (hl),c		; $6724
	ld l,Interaction.yh		; $6725
	ld (hl),$38		; $6727
	ld l,Interaction.xh		; $6729
	ld (hl),$50		; $672b
	ld l,Interaction.zh		; $672d
	ld (hl),$f0		; $672f
	ret			; $6731

@possiblePrizes:
	.db $01 $01 $01 $02 $02 $02 $02 $02
	.db $02 $02 $02 $02 $02 $03 $03 $04

@prizes:
	.db TREASURE_MERMAID_KEY, $01
	.db TREASURE_RUPEES,      $12
	.db TREASURE_RUPEES,      $13
	.db TREASURE_GASHA_SEED,  $06
	.db TREASURE_RING,        $12
	.db TREASURE_RING,        $13


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
goron_targetCarts_deleteMinecartAndClearStaticObjects:
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
	cp LAST_INTERACTION_INDEX+1			; $6777
	jr c,@loop	; $6779
	or h			; $677b
	ret			; $677c


;;
; @addr{677d}
goron_targetCarts_deleteCrystals:
	ldhl FIRST_ENEMY_INDEX, Enemy.enabled		; $677d
@loop:
	ld a,(hl)		; $6780
	or a			; $6781
	jr z,@nextEnemy	; $6782
	inc l			; $6784
	ldd a,(hl)		; $6785
	cp ENEMYID_TARGET_CART_CRYSTAL			; $6786
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

;;
; @addr{679e}
goron_targetCarts_beginGame:
	xor a			; $679e
	ld (wTmpcfc0.targetCarts.beginGameTrigger),a		; $679f
	ld (wTmpcfc0.targetCarts.crystalsHitInFirstRoom),a		; $67a2
	ld (wTmpcfc0.targetCarts.numTargetsHit),a		; $67a5
	ld (wTmpcfc0.targetCarts.cfdc),a		; $67a8
	jp _goron_targetCarts_setPlayingFlag		; $67ab

;;
; @addr{67ae}
goron_targetCarts_endGame:
	jp _goron_targetCarts_clearPlayingFlag		; $67ae

;;
; @addr{67b1}
_goron_targetCarts_setPlayingFlag:
	call getThisRoomFlags		; $67b1
	set 7,(hl)		; $67b4
	ret			; $67b6

;;
; @addr{67b7}
_goron_targetCarts_clearPlayingFlag:
	call getThisRoomFlags		; $67b7
	res 7,(hl)		; $67ba
	ret			; $67bc

;;
; @param[out]	zflag	z if Link has landed on the ground (in $cddb)
; @addr{67bd}
goron_checkLinkNotInAir:
	ld a,(wLinkInAir)		; $67bd
	bit 7,a			; $67c0
	jp _writeFlagsTocddb		; $67c2

;;
; @addr{67c5}
goron_checkLinkInAir:
	ld a,(wLinkInAir)		; $67c5
	or a			; $67c8
	jp _writeFlagsTocddb		; $67c9

;;
; @addr{67cc}
goron_targetCarts_setupNumTargetsHitText:
	ld a,(wTmpcfc0.targetCarts.numTargetsHit)		; $67cc
	add $00			; $67cf
	daa			; $67d1
	ld hl,wTextNumberSubstitution		; $67d2
	ld (hl),a		; $67d5
	inc hl			; $67d6
	ld (hl),$00		; $67d7
	ret			; $67d9

;;
; @param[out]	zflag	z if hit exactly 12 targets (in $cddb)
; @addr{67da}
goron_targetCarts_checkHitAllTargets:
	ld a,(wTmpcfc0.targetCarts.numTargetsHit)		; $67da
	cp $0c			; $67dd
	jp _writeFlagsTocddb		; $67df

;;
; @param[out]	cflag	c if hit less than 9 targets (in $cddb)
; @addr{67e2}
goron_targetCarts_checkHit9OrMoreTargets:
	ld a,(wTmpcfc0.targetCarts.numTargetsHit)		; $67e2
	cp $09			; $67e5
	ccf			; $67e7
	jp _writeFlagsTocddb		; $67e8

;;
; Save Link's current inventory status, and equip the seed shooter with scent seeds
; equipped.
; @addr{67eb}
goron_targetCarts_configureInventory:
	ld bc,wInventoryB		; $67eb
	ld hl,wTmpcfc0.targetCarts.savedBItem		; $67ee
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
goron_targetCarts_restoreInventory:
	ld bc,wInventoryB		; $6820
	ld hl,wTmpcfc0.targetCarts.savedBItem		; $6823
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

;;
; @addr{6839}
goron_targetCarts_loadCrystals:
	call getThisRoomFlags		; $6839
	bit 5,(hl)		; $683c
	ld a,$00		; $683e
	jr z,++			; $6840
	call getRandomNumber		; $6842
	and $01			; $6845
	inc a			; $6847
++
	ld (wTmpcfc0.targetCarts.targetConfiguration),a		; $6848
	ld hl,objectData.targetCartCrystals		; $684b
	jp parseGivenObjectData		; $684e

;;
; Reload only those crystals that weren't hit in the first room.
; @addr{6851}
goron_targetCarts_reloadCrystalsInFirstRoom:
	xor a			; $6851
@loop:
	ldh (<hFF8B),a	; $6852
	ld hl,wTmpcfc0.targetCarts.crystalsHitInFirstRoom		; $6854
	call checkFlag		; $6857
	jr nz,@nextCrystal	; $685a

	call getFreeEnemySlot		; $685c
	ldh a,(<hFF8B)	; $685f
	ld (hl),ENEMYID_TARGET_CART_CRYSTAL		; $6861
	inc l			; $6863
	ld (hl),a		; $6864
@nextCrystal:
	ldh a,(<hFF8B)	; $6865
	inc a			; $6867
	cp $05			; $6868
	jr nz,@loop	; $686a
	ret			; $686c

;;
; Writes a value to Interaction.var3e:
; * $02 before getting lava juice
; * $01 after getting lava juice
; * $00 after getting mermaid key
; @addr{686d}
goron_checkGracefulGoronQuestStatus:
	ld a,TREASURE_LAVA_JUICE		; $686d
	call checkTreasureObtained		; $686f
	jr nc,@noLavaJuice	; $6872
	ld a,TREASURE_MERMAID_KEY		; $6874
	call checkTreasureObtained		; $6876
	jr nc,@noMermaidKey	; $6879

	xor a			; $687b
	jr @writeByte		; $687c

@noLavaJuice:
	ld a,$02		; $687e
	jr @writeByte		; $6880

@noMermaidKey:
	ld a,$01		; $6882
@writeByte:
	ld e,Interaction.var3e		; $6884
	ld (de),a		; $6886
	ret			; $6887

;;
; @addr{6888}
goron_showTextForClairvoyantGoron:
	ld b,$00		; $6888
	ld a,(wEssencesObtained)		; $688a
	bit 5,a			; $688d
	jr nz,@finishedRollingRidgeSidequest	; $688f

	; Loop through list of treasures that indicate what the next tip should be
	ld hl,@treasures		; $6891
@nextTreasure:
	inc b			; $6894
	ldi a,(hl)		; $6895
	call checkTreasureObtained		; $6896
	jr c,@finishedRollingRidgeSidequest	; $6899
	ld a,b			; $689b
	cp $08			; $689c
	jr nz,@nextTreasure	; $689e

@finishedRollingRidgeSidequest:
	; If tip is for goron letter, need to check for lava juice and present
	; mermaid key simultaneously, since they can be gotten in either order?
	ld a,b			; $68a0
	cp $03			; $68a1
	jr nz,++		; $68a3
	ld a,TREASURE_LAVA_JUICE		; $68a5
	call checkTreasureObtained		; $68a7
	jr nc,@showTipForItem	; $68aa
	ld b,$09		; $68ac
	jr @showTipForItem		; $68ae
++
	; Check the status of the "big bang game" room to see whether you've given the
	; goronade to the goron?
	cp $05			; $68b0
	jr c,@showTipForItem	; $68b2
	push bc			; $68b4
	ld a,$03		; $68b5
	ld b,$3e		; $68b7
	call getRoomFlags		; $68b9
	pop bc			; $68bc
	bit 6,(hl)		; $68bd
	jr z,@showTipForItem	; $68bf
	ld b,$0a		; $68c1

@showTipForItem:
	; 'b' should be an index indicating an item to give a tip for?
	ld a,(wAreaFlags)		; $68c3
	and AREAFLAG_PAST			; $68c6
	jr z,@present	; $68c8

@past:
	ld a,<TX_3143		; $68ca
	add b			; $68cc
	ld b,>TX_3100		; $68cd
	ld c,a			; $68cf
	jp showText		; $68d0

@present:
	ld a,<TX_314f		; $68d3
	add b			; $68d5
	ld b,>TX_3100		; $68d6
	ld c,a			; $68d8
	jp showText		; $68d9

@treasures:
	.db TREASURE_OLD_MERMAID_KEY
	.db TREASURE_GORON_LETTER
	.db TREASURE_MERMAID_KEY
	.db TREASURE_GORONADE
	.db TREASURE_GORON_VASE
	.db TREASURE_ROCK_BRISKET
	.db TREASURE_BROTHER_EMBLEM

;;
; Big bang npc: set collision radius to 0 and make him invisible.
;
; What a hack.
; @addr{68e3}
goron_bigBang_hideSelf:
	ld h,d			; $68e3
	ld l,Interaction.var3e		; $68e4
	ld (hl),$01		; $68e6
	xor a			; $68e8
	ld l,Interaction.collisionRadiusY		; $68e9
	ldi (hl),a		; $68eb
	ld (hl),a		; $68ec
	jp objectSetInvisible		; $68ed

;;
; @addr{68f0}
goron_bigBang_unhideSelf:
	ld h,d			; $68f0
	ld l,Interaction.var3e		; $68f1
	ld (hl),$00		; $68f3
	ld a,$06		; $68f5
	ld l,Interaction.collisionRadiusY		; $68f7
	ldi (hl),a		; $68f9
	ld (hl),a		; $68fa
	jp objectSetVisible		; $68fb

;;
; @addr{68fe}
goron_bigBang_checkLinkHitByBomb:
	ld a,(w1Link.invincibilityCounter)		; $68fe
	or a			; $6901
	call _writeFlagsTocddb		; $6902
	cpl			; $6905
	ld ($cddb),a		; $6906
	ret			; $6909

;;
; @addr{690a}
goron_bigBang_createBombSpawner:
	call getFreePartSlot		; $690a
	ret nz			; $690d
	ld (hl),PARTID_BIGBANG_BOMB_SPAWNER		; $690e
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

; Values to set var3a to (counter until next group of explosions occur)
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


;;
; Load a layout for the big bang game.
goron_bigBang_loadMinigameLayout1_topHalf:
	ld hl,_goron_bigBang_minigameLayout1_topHalf		; $69ac
	ld c,$11		; $69af
	jr _goron_bigBang_loadRoomLayout		; $69b1

goron_bigBang_loadMinigameLayout1_bottomHalf:
	ld hl,_goron_bigBang_minigameLayout1_bottomHalf		; $69b3
	ld c,$41		; $69b6
	jr _goron_bigBang_loadRoomLayout		; $69b8

goron_bigBang_loadMinigameLayout2_topHalf:
	ld hl,_goron_bigBang_minigameLayout2_topHalf		; $69ba
	ld c,$11		; $69bd
	jr _goron_bigBang_loadRoomLayout		; $69bf

goron_bigBang_loadMinigameLayout2_bottomHalf:
	ld hl,_goron_bigBang_minigameLayout2_bottomHalf		; $69c1
	ld c,$41		; $69c4
	jr _goron_bigBang_loadRoomLayout		; $69c6

goron_bigBang_loadNormalRoomLayout_topHalf:
	ld hl,_goron_bigBang_normalRoomLayout		; $69c8
	ld c,$11		; $69cb
	jr _goron_bigBang_loadRoomLayout		; $69cd

goron_bigBang_loadNormalRoomLayout_bottomHalf:
	ld hl,_goron_bigBang_normalRoomLayout		; $69cf
	ld c,$41		; $69d2

;;
; @param	hl	Tile data to load
; @param	c	Tile position to start loading at
; @addr{69d4}
_goron_bigBang_loadRoomLayout:
	ld a,$03		; $69d4
@nextRow:
	ldh (<hFF93),a	; $69d6
	ld a,$08		; $69d8
@nextColumn:
	ldh (<hFF92),a	; $69da
	ldi a,(hl)		; $69dc
	push hl			; $69dd
	call setTile		; $69de
	pop hl			; $69e1
	inc c			; $69e2
	ldh a,(<hFF92)	; $69e3
	dec a			; $69e5
	jr nz,@nextColumn	; $69e6
	ld a,c			; $69e8
	add $08			; $69e9
	ld c,a			; $69eb
	ldh a,(<hFF93)	; $69ec
	dec a			; $69ee
	jr nz,@nextRow	; $69ef
	ret			; $69f1


_goron_bigBang_minigameLayout1_topHalf:
	.db $17 $57 $57 $57 $55 $55 $55 $56
	.db $56 $57 $57 $54 $54 $17 $55 $56
	.db $55 $55 $54 $54 $54 $54 $57 $57
_goron_bigBang_minigameLayout1_bottomHalf:
	.db $55 $17 $56 $56 $56 $56 $57 $17
	.db $54 $57 $57 $56 $17 $55 $55 $54
	.db $57 $57 $57 $57 $55 $55 $55 $54

_goron_bigBang_minigameLayout2_topHalf:
	.db $56 $54 $56 $54 $56 $17 $56 $54
	.db $56 $54 $17 $54 $56 $54 $56 $54
	.db $56 $54 $56 $54 $56 $54 $17 $54
_goron_bigBang_minigameLayout2_bottomHalf:
	.db $54 $56 $54 $56 $54 $56 $54 $56
	.db $54 $56 $54 $56 $17 $56 $54 $56
	.db $54 $17 $54 $56 $54 $56 $54 $56

_goron_bigBang_normalRoomLayout:
	.db $ef $ef $ef $ef $ef $ef $ef $ef
	.db $ef $ef $ef $ef $ef $ef $ef $ef
	.db $ef $ef $ef $ef $ef $ef $ef $ef

;;
; @param	a	$00 to restore exit, $04 to block it
; @addr{6a6a}
goron_bigBang_blockOrRestoreExit:
	ld hl,@tileData		; $6a6a
	rst_addAToHl			; $6a6d
	ld c,$73		; $6a6e
@next:
	ldi a,(hl)		; $6a70
	push hl			; $6a71
	call setTile		; $6a72
	pop hl			; $6a75
	inc c			; $6a76
	ld a,c			; $6a77
	cp $77			; $6a78
	jr nz,@next	; $6a7a
	ret			; $6a7c

@tileData:
	.db $b5 $ef $ef $b4 ; $00: Restore exit
	.db $b2 $b2 $b2 $b2 ; $04: Block exit


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
	jumpifitemobtained TREASURE_ROCK_BRISKET, @haveVaseOrSirloin
	jump2byte goron_enableInputAndResumeNappingLoop


@alreadyMovedAside:
	; Check if already talked to him once (this gets cleared if you leave the screen?)
	jumpifmemoryeq wTmpcfc0.goronCutscenes.goronGuardMovedAside, $01, @promptForTradeAfterRejection

	asm15 goron_showText_differentForPast, <TX_2494
	wait 30

	asm15 goron_checkInPresent
	jumpifmemoryset $cddb, CPU_ZFLAG, @checkSirloin_2

; Check goron vase
	jumpifitemobtained TREASURE_GORON_VASE, @haveVaseOrSirloin
	jump2byte @dontHaveVaseOrSirloin

@checkSirloin_2:
	jumpifitemobtained TREASURE_ROCK_BRISKET, @haveVaseOrSirloin

@dontHaveVaseOrSirloin:
	asm15 goron_showText_differentForPast, <TX_2495 ; "Yeah, a vase/sirloin would be great"
	jump2byte goron_enableInputAndResumeNappingLoop


@haveVaseOrSirloin:
	asm15 goron_showText_differentForPast <TX_2496
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

@rejectedTrade:
	asm15 goron_showText_differentForPast, <TX_2497
	writememory wTmpcfc0.goronCutscenes.goronGuardMovedAside, $01
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
	asm15 loseTreasure, TREASURE_ROCK_BRISKET
	giveitem TREASURE_GORON_VASE, $00
++
	orroomflag $40
	wait 30
	asm15 goron_showText_differentForPast, <TX_249a
	jump2byte goron_enableInputAndResumeNappingLoop

@alreadyTraded:
	asm15 goron_showText_differentForPast, <TX_249b
	jump2byte goron_enableInputAndResumeNappingLoop


; ==============================================================================
; INTERACID_RAFTON
; ==============================================================================

; Rafton in right part of house
rafton_subid01Script:
	initcollisions
	asm15 checkEssenceObtained, $02
	jumpifmemoryset $cddb, CPU_ZFLAG, @afterD3NpcLoop
	settextid TX_2708

@beforeD3NpcLoop:
	checkabutton
	asm15 turnToFaceLink
	showloadedtext
	wait 10
	setanimation DIR_DOWN
	settextid TX_270a
	jump2byte @beforeD3NpcLoop

@afterD3NpcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyTraded

	showtextlowindex <TX_2710
	wait 30
	jumpiftradeitemeq TRADEITEM_MAGIC_OAR, @linkHasOar
	jump2byte @enableInput

@linkHasOar:
	showtextlowindex <TX_2711
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Rejected trade
	showtextlowindex <TX_2713
	jump2byte @enableInput

@acceptedTrade:
	showtextlowindex <TX_2712
	wait 30
	giveitem TREASURE_TRADEITEM, $0a
	jump2byte @enableInput

@alreadyTraded:
	showtextlowindex <TX_2714

@enableInput:
	enableinput
	jump2byte @afterD3NpcLoop


; ==============================================================================
; INTERACID_CHEVAL
; ==============================================================================

;;
; @addr{6b7f}
cheval_setTalkedGlobalflag:
	ld a,GLOBALFLAG_TALKED_TO_CHEVAL		; $6b7f
	jp setGlobalFlag		; $6b81


; ==============================================================================
; INTERACID_MISCELLANEOUS
; ==============================================================================

;;
; @addr{6b84}
_interaction6b_loadMoblinsAttackingMakuSprout:
	ld hl,objectData.moblinsAttackingMakuSprout		; $6b84
	jp parseGivenObjectData		; $6b87

;;
; Set make tree present to use unswapped room, maku tree past to use sawpped room
; (the room in the underwater version of the map).
; @addr{6b8a}
_interaction6b_layoutSwapMakuTreeRooms:
	ld hl,wPresentRoomFlags+$38		; $6b8a
	res 0,(hl)		; $6b8d
	ld hl,wPastRoomFlags+$48		; $6b8f
	set 0,(hl)		; $6b92
	ret			; $6b94

;;
; Used for checking whin the maku sprout should talk to Link before leaving the screen.
;
; @param[out]	cflag	nc if Link is near the bottom of the screen (in $cddb)
; @addr{6b95}
_interaction6b_isLinkAtScreenEdge:
	ld hl,w1Link.yh		; $6b95
	call @func		; $6b98
	ld a,$01		; $6b9b
	jr nc,+			; $6b9d
	xor a			; $6b9f
+
	or a			; $6ba0
	jp _writeFlagsTocddb		; $6ba1

@func:
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

;;
; @addr{6bc0}
interaction6b_checkGotBombsFromAmbi:
	; Bit 7 of d2's entrance screen is set after that cutscene?
	ld a,(wPresentRoomFlags+$83)		; $6bc0
	bit 7,a			; $6bc3
	jp _writeFlagsTocddb		; $6bc5

;;
; Sets var38 to $01 if Link can grab the item here (he's touching it, not in the air...)
; @addr{6bc8}
interaction6b_checkLinkCanCollect:
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
	jr c,+			; $6bda
	xor a			; $6bdc
+
	ld e,Interaction.var38		; $6bdd
	ld (de),a		; $6bdf
	ret			; $6be0

;;
; @addr{6be1}
interaction6b_refillBombs:
	ld hl,wMaxBombs		; $6be1
	ldd a,(hl)		; $6be4
	ld (hl),a		; $6be5
	ret			; $6be6


; Script for cutscene where moblins attack maku sprout
interaction6b_subid04Script:
	disableinput
	asm15 restartSound
	writememory wDisableScreenTransitions, $01
	asm15 _interaction6b_loadMoblinsAttackingMakuSprout

	wait 60
	spawninteraction INTERACID_PUFF, $00, $58, $28
	wait 4
	settileat $52 $f9

	writememory   wTmpcfc0.genericCutscene.state, $01
	checkmemoryeq wTmpcfc0.genericCutscene.state, $02
	wait 30

	showtext TX_1202
	wait 30

	writememory   wTmpcfc0.genericCutscene.state, $03
	checkmemoryeq wTmpcfc0.genericCutscene.state, $04
	wait 30

	showtext TX_05d0
	wait 30

	setmusic MUS_DISASTER
	writememory wTmpcfc0.genericCutscene.state, $05
	enableinput
	setcollisionradii $04, $50
	checkcollidedwithlink_ignorez

	disableinput
	asm15 setLinkToState08AndSetDirection, $00
	writememory   wTmpcfc0.genericCutscene.state, $06
	checkmemoryeq wTmpcfc0.genericCutscene.state, $08
	wait 30

	showtext TX_1203
	playsound SND_DING
	wait 40

	writememory wTmpcfc0.genericCutscene.state, $09
	wait 2
	enableinput

@twoEnemies:
	jumptable_memoryaddress wNumEnemies
	.dw @noEnemies
	.dw @oneEnemy
	.dw @twoEnemies

@oneEnemy:
	wait 20
	showtext TX_05d1
	checknoenemies
	wait 20

@noEnemies:
	showtext TX_05d2
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

	; Load movement preset for Link, wait for it to finish
	asm15 moveLinkToPosition, $00
	wait 1
	checkmemoryeq w1Link.id, SPECIALOBJECTID_LINK

	wait 30
	showtext TX_05d3
	wait 30

	spawninteraction INTERACID_MAKU_GATE_OPENING, $01, $00, $00

@waitForGatesToOpen:
	jumpifroomflagset $80, ++
	wait 1
	jump2byte @waitForGatesToOpen
++
	wait 40
	setglobalflag GLOBALFLAG_MAKU_GIVES_ADVICE_FROM_PAST_MAP
	showtext TX_05d6

	writememory wMakuMapTextPast, <TX_05d6
	setglobalflag GLOBALFLAG_MAKU_TREE_SAVED
	asm15 incMakuTreeState
	asm15 _interaction6b_layoutSwapMakuTreeRooms
	resetmusic
	enableinput

@waitForLinkToApproachScreenEdge:
	wait 1
	asm15 _interaction6b_isLinkAtScreenEdge
	jumpifmemoryset $cddb, CPU_ZFLAG, @waitForLinkToApproachScreenEdge

	showtext TX_05d4
	writememory wDisableScreenTransitions, $00
	scriptend

; ==============================================================================
; INTERACID_FAIRY_HIDING_MINIGAME
; ==============================================================================

;;
; @param	a	Index of fairy to spawn (value for var03)
; @addr{6c9e}
fairyHidingMinigame_spawnForestFairyIndex:
	ld b,a			; $6c9e
	call getFreeInteractionSlot		; $6c9f
	ret nz			; $6ca2
	ld (hl),INTERACID_FOREST_FAIRY		; $6ca3
	ld l,Interaction.var03		; $6ca5
	ld (hl),b		; $6ca7
	ret			; $6ca8

;;
; @addr{6ca9}
fairyHidingMinigame_showFairyFoundText:
	ld a,(wTmpcfc0.fairyHideAndSeek.foundFairiesBitset)		; $6ca9
	ld bc,$0003		; $6cac
--
	rrca			; $6caf
	jr nc,+			; $6cb0
	inc b			; $6cb2
+
	dec c			; $6cb3
	jr nz,--		; $6cb4

	ld a,b			; $6cb6
	ld hl,@foundFairyText		; $6cb7
	rst_addAToHl			; $6cba
	ld c,(hl)		; $6cbb
	ld b,>TX_1105		; $6cbc
	jp showText		; $6cbe

@foundFairyText:
	.db <TX_1105
	.db <TX_1106
	.db <TX_1107

;;
; @addr{6cc4}
fairyHidingMinigame_moveLinkBackLeft:
	ld hl,w1Link.direction		; $6cc4
	ld (hl),DIR_LEFT		; $6cc7
	inc l			; $6cc9
	ld (hl),ANGLE_LEFT		; $6cca
	ld a,LINK_STATE_FORCE_MOVEMENT		; $6ccc
	ld (wLinkForceState),a		; $6cce
	ld a,$08		; $6cd1
	ld (wLinkStateParameter),a		; $6cd3
	ret			; $6cd6


; Begins fairy-hiding minigame
fairyHidingMinigame_subid00Script:
	asm15 fairyHidingMinigame_spawnForestFairyIndex, $00
	wait 20
	asm15 fairyHidingMinigame_spawnForestFairyIndex, $01
	wait 20
	asm15 fairyHidingMinigame_spawnForestFairyIndex, $02

	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $03
	wait 20

	showtext TX_1100
	wait 8
	showtext TX_1101
	wait 8
	showtext TX_1102
	wait 8
	showtext TX_1103
	checktext

	writememory   wTmpcfc0.fairyHideAndSeek.cfd2, $00
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $03
	scriptend


; Hiding spot for fairy revealed
fairyHidingMinigame_subid01Script:
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $01
	wait 20
	asm15 fairyHidingMinigame_showFairyFoundText
	writememory   wTmpcfc0.fairyHideAndSeek.cfd2, $00
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $01
	scriptend


; Checks for Link leaving the hide-and-seek area
fairyHidingMinigame_subid02Script:
	setcollisionradii $20 $01
	makeabuttonsensitive

@checkLinkLeaving:
	checkcollidedwithlink_ignorez

	showtext TX_110c
	jumpiftextoptioneq $00, @leave

	asm15 fairyHidingMinigame_moveLinkBackLeft
	wait 10
	jump2byte @checkLinkLeaving

@leave:
	scriptend


; ==============================================================================
; INTERACID_POSSESSED_NAYRU
; ==============================================================================

;;
; @addr{6d27}
possessedNayru_moveLinkForward:
	ld a,LINK_STATE_FORCE_MOVEMENT		; $6d27
	ld (wLinkForceState),a		; $6d29
	ld a,$08		; $6d2c
	ld (wLinkStateParameter),a		; $6d2e
	ld hl,w1Link.direction		; $6d31
	xor a			; $6d34
	ldi (hl),a		; $6d35
	ld (hl),a		; $6d36
	ret			; $6d37

;;
; @addr{6d38}
possessedNayru_makeExclamationMark:
	ld a,SNDCTRL_STOPMUSIC		; $6d38
	call playSound		; $6d3a
	ld a,$18		; $6d3d
	ld bc,$f408		; $6d3f
	jp objectCreateExclamationMark		; $6d42

; ==============================================================================
; INTERACID_NAYRU_SAVED_CUTSCENE
; ==============================================================================

;;
; @addr{6d45}
nayruSavedCutscene_createEnergySwirl:
	ld h,d			; $6d45
	ld l,Interaction.yh		; $6d46
	ld b,(hl)		; $6d48
	ld l,Interaction.xh		; $6d49
	ld c,(hl)		; $6d4b
	ld a,$ff		; $6d4c
	jp createEnergySwirlGoingIn		; $6d4e

;;
; @param	a	Guard index (value for var03)
; @addr{6d51}
nayruSavedCutscene_spawnGuardIndex:
	ld b,a			; $6d51
	call getFreeInteractionSlot		; $6d52
	ret nz			; $6d55
	ld (hl),$6e		; $6d56
	inc l			; $6d58
	ld (hl),$04		; $6d59
	inc l			; $6d5b
	ld (hl),b		; $6d5c
	ret			; $6d5d

;;
; @param	a	0 or 1 (for different speedZ presets)
; @addr{6d5e}
nayruSavedCutscene_setSpeedZIndex:
	ld hl,@speeds		; $6d5e
	rst_addDoubleIndex			; $6d61
	ld e,Interaction.speedZ		; $6d62
	ldi a,(hl)		; $6d64
	ld (de),a		; $6d65
	inc e			; $6d66
	ld a,(hl)		; $6d67
	ld (de),a		; $6d68
	ret			; $6d69

@speeds:
	.dw -$180
	.dw -$100

;;
; @addr{6d6e}
nayruSavedCutscene_loadAngleAndAnimationPreset:
	ld hl,_nayruSavedCutscene_angleAndAnimationPresets		; $6d6e
	rst_addDoubleIndex			; $6d71

_nayruSavedCutscene_setAngleAndAnimationAtAddress:
	ld e,Interaction.angle		; $6d72
	ldi a,(hl)		; $6d74
	ld (de),a		; $6d75

_nayruSavedCutscene_setAnimationAtAddress:
	ld a,(hl)		; $6d76
	jp interactionSetAnimation		; $6d77


_nayruSavedCutscene_angleAndAnimationPresets:
	.db $18 $13
	.db $00 $10
	.db $00 $0c
	.db $08 $0d
	.db $18 $0f

;;
; @addr{6d84}
nayruSavedCutscene_loadGuardAngleToMoveTowardCenter:
	ld e,Interaction.speed		; $6d84
	ld a,SPEED_40		; $6d86
	ld (de),a		; $6d88
	ld e,Interaction.var03		; $6d89
	ld a,(de)		; $6d8b
	ld hl,@guardAnglesAndAnimations		; $6d8c
	rst_addDoubleIndex			; $6d8f
	jr _nayruSavedCutscene_setAngleAndAnimationAtAddress		; $6d90

@guardAnglesAndAnimations:
	.db $0f $0e
	.db $12 $0e
	.db $07 $0d
	.db $1a $0f
	.db $02 $0c
	.db $1e $0c

;;
; @addr{6d9e}
nayruSavedCutscene_loadGuardAnimation:
	ld e,Interaction.var03		; $6d9e
	ld a,(de)		; $6da0
	ld hl,@guardAnimations		; $6da1
	rst_addAToHl			; $6da4
	jr _nayruSavedCutscene_setAnimationAtAddress		; $6da5

@guardAnimations:
	.db $0e $0e $0e $0f $0d $0f


; ==============================================================================
; INTERACID_COMPANION_SCRIPTS
; ==============================================================================

;;
; Make an exclamation mark, + change their animation to the value of Interaction.var38 (?)
; @addr{6dad}
companionScript_noticeLink:
	ld e,Interaction.var38		; $6dad
	ld a,(de)		; $6daf
	or a			; $6db0
	jr z,companionScript_makeExclamationMark	; $6db1
	ld (w1Companion.var3f),a		; $6db3

;;
; @addr{6db6}
companionScript_makeExclamationMark:
	ld bc,$f000		; $6db6
	ld a,30		; $6db9
	jp objectCreateExclamationMark		; $6dbb

;;
; @addr{6dbe}
companionScript_writeAngleTowardLinkToCompanionVar3f:
	call objectGetAngleTowardLink		; $6dbe
	ld e,Interaction.angle		; $6dc1
	call convertAngleToDirection		; $6dc3
	add $01			; $6dc6
	ld (w1Companion.var3f),a		; $6dc8
	ret			; $6dcb

;;
; @addr{6dcc}
companionScript_restoreMusic:
	ld a,(wActiveMusic2)		; $6dcc
	ld (wActiveMusic),a		; $6dcf
	jp playSound		; $6dd2

;;
; @addr{6dd5}
companionScript_spawnFairyAfterFindingCompanionInForest:
	ldbc INTERACID_FOREST_FAIRY, $03		; $6dd5
	call objectCreateInteraction		; $6dd8
	ld l,Interaction.var03		; $6ddb
	ld (hl),$0f		; $6ddd
	ret			; $6ddf

;;
; @addr{6de0}
companionScript_warpOutOfForest:
	ld hl,@outOfForestWarp		; $6de0
	jp setWarpDestVariables		; $6de3

@outOfForestWarp:
	.db $80 $63 $00 $56 $03

;;
; @addr{6deb}
companionScript_loseRickyGloves:
	ld a,TREASURE_RICKY_GLOVES		; $6deb
	jp loseTreasure		; $6ded


; Script in first screen of forest, where fairy leads you to the companion
companionScript_subid0bScript_body:
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $02 ; Wait for fairy to stop
	showtext TX_1126
	writememory   wTmpcfc0.fairyHideAndSeek.cfd2, $00
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $01 ; Wait for fairy to leave
	enableinput
	scriptend


; Dimitri script where he's harrassed by tokays
companionScript_subid07Script_body:
	jumpifmemoryset wDimitriState, $01, @alreadyHeardTokayDiscussion

@wait:
	jumpifmemoryset w1Companion.var3e, $02, ++
	jump2byte @wait
++
	showtext TX_2100
	ormemory wDimitriState, $01

@alreadyHeardTokayDiscussion:
	checkmemoryeq w1Companion.var3d, $01 ; Wait for Link to talk to Dimitri
	jumpifmemoryset wDimitriState, $02, @savedDimitri

	; Still being harrassed
	showtext TX_2100
	writememory w1Companion.var3d, $00
	enableinput
	jump2byte companionScript_subid07Script

@savedDimitri:
	disableinput
	jumpifmemoryeq wAnimalCompanion, SPECIALOBJECTID_DIMITRI, @notFirstMeeting

	; First meeting
	showtext TX_2101
	jump2byte ++

@notFirstMeeting:
	showtext TX_2102
++
	writememory w1Companion.var03, $01
	enableallobjects
	checkmemoryeq wLinkObjectIndex, >w1Companion ; Wait for Link to mount
	showtext TX_2106
	ormemory wDimitriState, $20
	enableinput
	scriptend


; A fairy appears to tell you about the animal companion in the forest
companionScript_subid08Script_body:
	showtext TX_1120
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $02 ; Wait for fairy to fully appear

	showtext TX_1121
	jumpiftextoptioneq $00, @doneRepeating
@repeatSelf:
	showtext TX_1121
	jumpiftextoptioneq $01, @repeatSelf

@doneRepeating:
	showtext TX_1130
	writememory   wTmpcfc0.fairyHideAndSeek.cfd2, $00
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $01

	orroomflag $40
	unsetglobalflag GLOBALFLAG_FOREST_UNSCRAMBLED
	setglobalflag   GLOBALFLAG_COMPANION_LOST_IN_FOREST
script15_6e71:
	enableinput
	scriptend


; Ricky script when he loses his gloves
companionScript_subid03Script_body:
	checkmemoryeq w1Companion.var3d, $01 ; Wait for Link to talk to Ricky
	disableinput
	jumpifmemoryset wRickyState $01, @alreadyExplainedSituation

	ormemory wRickyState, $01
	jumpifmemoryeq wAnimalCompanion, SPECIALOBJECTID_RICKY, @notFirstMeeting

	; First meeting
	showtext TX_2000
	jump2byte @alreadyExplainedSituation

@notFirstMeeting:
	showtext TX_2001

@alreadyExplainedSituation:
	jumpifitemobtained TREASURE_RICKY_GLOVES, @retrievedGloves
	showtext TX_2003
	writememory w1Companion.var3d, $00
	enableinput
	jump2byte companionScript_subid03Script

@retrievedGloves:
	showtext TX_2004
	asm15 companionScript_loseRickyGloves
	writememory w1Companion.var03, $01
	enableallobjects
	checkmemoryeq wLinkObjectIndex, >w1Companion ; Wait for Link to mount

	showtext TX_2005
	ormemory wRickyState, $20
	enablemenu
	scriptend


; Script just outside the forest, where you get the flute
companionScript_subid0aScript_body:
	disableinput
	showtext TX_112b
	wait 30
	showtext TX_112c
	wait 30
	showtext TX_112d
	wait 30
	showtext TX_112e
	wait 30
	showtext TX_112f

	writememory    wTmpcfc0.fairyHideAndSeek.cfd2, $00
@waitForFairiesToLeave:
	jumpifmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $03, @fairiesLeft
	wait 1
	jump2byte @waitForFairiesToLeave

@fairiesLeft:
	showtext TX_1131
	writeobjectbyte Interaction.state, $02 ; State 2 code gives Link the flute
	checktext
	showtext TX_1132
	writememory w1Companion.var03, $01
	setglobalflag GLOBALFLAG_GOT_FLUTE
	checkmemoryeq wLinkObjectIndex, >w1Companion ; Wait for Link to mount companion

	setglobalflag GLOBALFLAG_FOREST_UNSCRAMBLED
	enableinput
	scriptend


; Companion script where they're found in the fairy forest
companionScript_subid09Script_body:
	checkmemoryeq w1Companion.var3d, $01 ; Wait for Link to talk to him

	disableinput
	showtext TX_1131
	asm15 companionScript_noticeLink
	wait 60
	showtext TX_1132
	asm15 companionScript_spawnFairyAfterFindingCompanionInForest

@waitForFairy:
	jumpifmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $02, @fairyAppeared
	wait 1
	jump2byte @waitForFairy

@fairyAppeared:
	showtext TX_112a
	setglobalflag GLOBALFLAG_SAVED_COMPANION_FROM_FOREST
	asm15 companionScript_warpOutOfForest
	scriptend


; ==============================================================================
; INTERACID_KING_MOBLIN_DEFEATED
; ==============================================================================

;;
; @addr{6f13}
kingMoblinDefeated_setGoronDirection:
	ld hl,@directionTable		; $6f13
	rst_addDoubleIndex			; $6f16
	ld e,Interaction.angle		; $6f17
	ldi a,(hl)		; $6f19
	ld (de),a		; $6f1a
	ld a,(hl)		; $6f1b
	jp interactionSetAnimation		; $6f1c

@directionTable:
	.db $00 $04
	.db $08 $05
	.db $10 $06
	.db $18 $07

;;
; @addr{6f27}
kingMoblinDefeated_spawnInteraction8a:
	call getFreeInteractionSlot		; $6f27
	ret nz			; $6f2a
	ld (hl),INTERACID_REMOTE_MAKU_CUTSCENE		; $6f2b
	ld l,Interaction.var03		; $6f2d
	ld (hl),$06		; $6f2f
	ret			; $6f31


; ==============================================================================
; INTERACID_GHINI_HARASSING_MOOSH
; ==============================================================================

;;
; Set initial speed and angle for the ghini to do its circular movement.
; @addr{6f32}
ghiniHarassingMoosh_beginCircularMovement:
	ld e,Interaction.speed		; $6f32
	ld a,SPEED_140		; $6f34
	ld (de),a		; $6f36
	ld e,Interaction.angle		; $6f37
	ld a,ANGLE_LEFT		; $6f39
	ld (de),a		; $6f3b
	ret			; $6f3c


; ==============================================================================
; INTERACID_TOKAY_SHOP_ITEM
; ==============================================================================

;;
; @addr{6f3d}
tokayShopItem_giveFeatherAndLoseShovel:
	ld c,$02		; $6f3d
	ld a,TREASURE_SHOVEL		; $6f3f
	jr _tokayShopItem_giveAndLoseTreasure		; $6f41

;;
; @addr{6f43}
tokayShopItem_giveBraceletAndLoseShovel:
	ld c,$03		; $6f43
	ld a,TREASURE_SHOVEL		; $6f45
	jr _tokayShopItem_giveAndLoseTreasure		; $6f47

;;
; @addr{6f49}
tokayShopItem_giveShovelAndLoseFeather:
	ld b,TREASURE_FEATHER		; $6f49
	jr ++		; $6f4b

;;
; @addr{6f4d}
tokayShopItem_giveShovelAndLoseBracelet:
	ld b,TREASURE_BRACELET		; $6f4d
++
	ld e,Interaction.var3c		; $6f4f
	ld a,TREASURE_SHOVEL		; $6f51
	ld (de),a		; $6f53
	ld c,$02		; $6f54
	ld a,b			; $6f56

;;
; @param	a	Treasure to lose
; @param	c	Subid of treasure to give
; @param	var3c	ID of treasure to give (set by main object code)
; @addr{6f57}
_tokayShopItem_giveAndLoseTreasure:
	ld e,Interaction.var3b		; $6f57
	ld (de),a		; $6f59
	call _tokayShopItem_createTreasureAtLink		; $6f5a
	ld e,Interaction.var3b		; $6f5d
	ld a,(de)		; $6f5f
	call loseTreasure		; $6f60
	ret			; $6f63

;;
; @addr{6f64}
tokayShopItem_giveShieldToLink:
	ld e,Interaction.var3c		; $6f64
	ld a,TREASURE_SHIELD		; $6f66
	ld (de),a		; $6f68
	ld e,Interaction.subid		; $6f69
	ld a,(de)		; $6f6b
	sub $04			; $6f6c
	ld c,a			; $6f6e
	jr _tokayShopItem_createTreasureAtLink		; $6f6f

;;
; @addr{6f71}
tokayShopItem_giveBraceletToLink:
	ld c,$03		; $6f71
	jr _tokayShopItem_createTreasureAtLink		; $6f73

;;
; @addr{6f75}
tokayShopItem_giveFeatherToLink:
	ld c,$02		; $6f75

;;
; @addr{6f77}
_tokayShopItem_createTreasureAtLink:
	ld e,Interaction.var3c		; $6f77
	ld a,(de)		; $6f79
	ld b,a			; $6f7a
	call createTreasure		; $6f7b
	ld l,Interaction.yh		; $6f7e
	ld a,(w1Link.yh)		; $6f80
	ldi (hl),a		; $6f83
	inc l			; $6f84
	ld a,(w1Link.xh)		; $6f85
	ld (hl),a		; $6f88
	ret			; $6f89

;;
; @addr{6f8a}
tokayShopItem_lose10ScentSeeds:
	ld l,<wNumScentSeeds		; $6f8a
	jr ++		; $6f8c

;;
; @addr{6f8e}
tokayShopItem_lose10MysterySeeds:
	ld l,<wNumMysterySeeds		; $6f8e
++
	ld h,>wc600Block		; $6f90
	ld a,(hl)		; $6f92
	sub $10			; $6f93
	daa			; $6f95
	ld (hl),a		; $6f96
	ld a,$ff		; $6f97
	ld (wStatusBarNeedsRefresh),a		; $6f99
	ret			; $6f9c


; ==============================================================================
; INTERACID_BOMB_UPGRADE_FAIRY
; ==============================================================================

;;
; @addr{6f9d}
bombUpgradeFairy_spawnBombsAroundLink:
	ld b,$04		; $6f9d
@next:
	call getFreeInteractionSlot		; $6f9f
	ret nz			; $6fa2
	ld (hl),$83		; $6fa3
	inc l			; $6fa5
	inc (hl)		; $6fa6
	inc l			; $6fa7
	dec b			; $6fa8
	ld (hl),b		; $6fa9
	jr nz,@next	; $6faa
	ret			; $6fac

bombUpgradeFairy_lightningStrikesLink:
	call getFreePartSlot		; $6fad
	ret nz			; $6fb0

	dec l			; $6fb1
	set 7,(hl)		; $6fb2
	inc l			; $6fb4
	ld (hl),PARTID_LIGHTNING		; $6fb5
	inc l			; $6fb7
	inc (hl)		; $6fb8
	ld l,Part.yh		; $6fb9
	ldh a,(<hEnemyTargetY)	; $6fbb
	ldi (hl),a		; $6fbd
	inc l			; $6fbe
	ldh a,(<hEnemyTargetX)	; $6fbf
	ld (hl),a		; $6fc1
	ret			; $6fc2

;;
; @addr{6fc3}
bombUpgradeFairy_decreaseLinkHealth:
	ld hl,wLinkHealth		; $6fc3
	ld a,(hl)		; $6fc6
	cp $04			; $6fc7
	ret c			; $6fc9
	ld (hl),$04		; $6fca

_bombUpgradeFairy_linkCollapsed:
	ld a,LINK_ANIM_MODE_COLLAPSED		; $6fcc
	ld ($cc50),a		; $6fce
	ret			; $6fd1

;;
; @addr{6fd2}
bombUpgradeFairy_loseAllBombs:
	ld a,$01		; $6fd2
	ld (wNumBombs),a		; $6fd4
	call decNumBombs		; $6fd7
	jr _bombUpgradeFairy_linkCollapsed		; $6fda

;;
; @addr{6fdc}
bombUpgradeFairy_giveBombUpgrade:
	ld a,(wTextNumberSubstitution)		; $6fdc
	ld (wMaxBombs),a		; $6fdf
	ld c,a			; $6fe2
	ld a,TREASURE_BOMBS		; $6fe3
	jp giveTreasure		; $6fe5

;;
; @addr{6fe8}
bombUpgradeFairy_fadeinFromWhite:
	ld a,$ff		; $6fe8
	ld ($cfd0),a		; $6fea
	ld a,$04		; $6fed
	jp fadeinFromWhiteWithDelay		; $6fef

;;
; @addr{6ff2}
bombUpgradeFairy_setGlobalFlag:
	ld a,GLOBALFLAG_GOT_BOMB_UPGRADE_FROM_FAIRY		; $6ff2
	jp setGlobalFlag		; $6ff4


bombUpgradeFairyScript_body:
	wait 30
@askBombType:
	showtext TX_0c00
	jumptable_memoryaddress wSelectedTextOption
	.dw @saidGoldenBomb
	.dw @saidSilverBomb
	.dw @saidRegularBomb

@saidGoldenBomb:
	wait 60
	showtext TX_0c01
	jumpiftextoptioneq $01, @askBombType
	wait 60
	showtext TX_0c02
	jumpiftextoptioneq $01, @askBombType
	wait 60

	writememory $cfd0, $01
	wait 30
	showtext TX_0c03
	asm15 bombUpgradeFairy_spawnBombsAroundLink
	wait 120

	asm15 playSound, SND_BIG_EXPLOSION
	asm15 fadeoutToWhite
	wait 1
	asm15 bombUpgradeFairy_decreaseLinkHealth
	wait 1
	asm15 bombUpgradeFairy_fadeinFromWhite
	wait 1
	showtext TX_0c04
	wait 30
	scriptend

@saidSilverBomb:
	wait 60
	showtext TX_0c05
	jumpiftextoptioneq $01, @askBombType
	wait 60

	writememory $cfd0, $01
	wait 30
	showtext TX_0c06
	asm15 bombUpgradeFairy_lightningStrikesLink
	wait 20
	asm15 bombUpgradeFairy_loseAllBombs
	wait 1
	asm15 bombUpgradeFairy_fadeinFromWhite
	wait 1
	showtext TX_0c04
	wait 30
	scriptend

@saidRegularBomb:
	writememory $cfd0, $01
	wait 30
	showtext TX_0c07
	wait 30
	asm15 bombUpgradeFairy_spawnBombsAroundLink
	wait 120
	asm15 playSound, SND_BIG_EXPLOSION
	asm15 fadeoutToWhite
	wait 1
	asm15 bombUpgradeFairy_giveBombUpgrade
	asm15 bombUpgradeFairy_fadeinFromWhite
	wait 1
	showtext TX_0c08
	wait 30
	asm15 bombUpgradeFairy_setGlobalFlag
	scriptend


; ==============================================================================
; INTERACID_MAKU_TREE
; ==============================================================================

;;
; @addr{707c}
makuTree_setAnimation:
	ld e,Interaction.var3b		; $707c
	ld (de),a		; $707e
	jp interactionSetAnimation		; $707f

;;
; Takes [var3f] + 'a', shows the corresponding text, and updates the map text accordingly.
; In linked games, $20 or $10 is added to the index?
; @addr{7082}
makuTree_showTextWithOffsetAndUpdateMapText:
	call _makuTree_func_70a2		; $7082
	jr _label_15_203		; $7085

;;
; Takes [var3f] + 'a', and shows the corresponding text.
; In linked games, $20 or $10 is added to the index?
; @addr{7087}
makuTree_showTextWithOffset:
	call _makuTree_func_709c		; $7087
	jr _label_15_203		; $708a

;;
; In linked games, $20 or $10 is added to the index?
; @addr{708c}
makuTree_showTextAndUpdateMapText:
	call _makuTree_checkLinkedAndUpdateMapText		; $708c
	jr _label_15_203		; $708f

;;
; In linked games, $20 or $10 is added to the index?
; @addr{7091}
makuTree_showText:
	call _makuTree_modifyTextIndexForLinked		; $7091
	jr _label_15_203		; $7094
	ld c,a			; $7096

;;
; @addr{7097}
_label_15_203:
	ld b,>TX_0500		; $7097
	jp showText		; $7099

;;
; @param	a	Text index
; @addr{70a6}
_makuTree_func_709c:
	ld h,d			; $709c
	ld l,Interaction.var3f		; $709d
	add (hl)		; $709f
	jr _makuTree_modifyTextIndexForLinked		; $70a0

;;
; @param	a	Text index
; @addr{70a6}
_makuTree_func_70a2:
	ld h,d			; $70a2
	ld l,Interaction.var3f		; $70a3
	add (hl)		; $70a5

;;
; @param	a	Text index
; @addr{70a6}
_makuTree_checkLinkedAndUpdateMapText:
	call _makuTree_modifyTextIndexForLinked		; $70a6
	ld e,Interaction.var3d		; $70a9
	ld a,(de)		; $70ab
	ld hl,wMakuMapTextPresent		; $70ac
	rst_addAToHl			; $70af
	ld (hl),c		; $70b0
	ret			; $70b1

;;
; @param	a	Text index (original)
; @param[out]	c	Text index (modified if linked game)
; @addr{70b2}
_makuTree_modifyTextIndexForLinked:
	ld c,a			; $70b2
	call checkIsLinkedGame		; $70b3
	ret z			; $70b6
	call @getLinkedTextOffset		; $70b7
	ld hl,_makuTree_textOffsetsForLinked		; $70ba
	rst_addAToHl			; $70bd
	ld a,(hl)		; $70be
	add c			; $70bf
	ld c,a			; $70c0
	ret			; $70c1

;;
; @addr{70c2}
@getLinkedTextOffset:
	ld h,d			; $70c2
	ld l,Interaction.id		; $70c3
	ld a,(hl)		; $70c5
	cp INTERACID_REMOTE_MAKU_CUTSCENE			; $70c6
	jr nz,+			; $70c8
	dec a			; $70ca
+
	sub INTERACID_MAKU_TREE			; $70cb
	ret			; $70cd

_makuTree_textOffsetsForLinked:
	.db $20, $20, $10

;;
; @addr{70d1}
_makuTree_dropSeedSatchel:
	call getThisRoomFlags		; $70d1
	bit 7,a			; $70d4
	ret nz			; $70d6
	set 7,(hl)		; $70d7

	call getFreeInteractionSlot		; $70d9
	ld (hl),INTERACID_TREASURE		; $70dc
	inc l			; $70de
	ld (hl),TREASURE_SEED_SATCHEL		; $70df
	inc l			; $70e1
	ld (hl),$02		; $70e2
	ld l,Interaction.yh		; $70e4
	ld (hl),$60		; $70e6

	ld a,(w1Link.xh)		; $70e8
	ld b,$50		; $70eb
	cp $64			; $70ed
	jr nc,@setX	; $70ef
	cp $3c			; $70f1
	jr c,@setX	; $70f3
	ld b,$40		; $70f5
	cp $50			; $70f7
	jr nc,@setX	; $70f9
	ld b,$60		; $70fb
@setX:
	ld l,Interaction.xh		; $70fd
	ld (hl),b		; $70ff
	ld a,b			; $7100
	ld (wMakuTreeSeedSatchelXPosition),a		; $7101
	ret			; $7104

;;
; Checks whether to spawn the seed satchel which was dropped previously.
; @addr{7105}
makuTree_checkSpawnSeedSatchel:
	call getThisRoomFlags		; $7105
	bit 5,a			; $7108
	ret nz			; $710a
	bit 7,a			; $710b
	ret z			; $710d

	call getFreeInteractionSlot		; $710e
	ld (hl),INTERACID_TREASURE		; $7111
	inc l			; $7113
	ld (hl),TREASURE_SEED_SATCHEL		; $7114
	inc l			; $7116
	ld (hl),$03		; $7117
	ld l,Interaction.yh		; $7119
	ld a,$58		; $711b
	ldi (hl),a		; $711d
	ld a,(wMakuTreeSeedSatchelXPosition)		; $711e
	ld l,Interaction.xh		; $7121
	ld (hl),a		; $7123
	ret			; $7124

;;
; @addr{7125}
makuTree_spawnMakuSeed:
	ldbc INTERACID_MAKU_SEED, $00		; $7125
	jp objectCreateInteraction		; $7128

;;
; @addr{712b}
makuTree_chooseTextAfterSeeingTwinrova:
	ld c,<TX_055b		; $712b
	call checkIsLinkedGame		; $712d
	jr z,+			; $7130
	ld c,<TX_055f		; $7132
+
	ld e,Interaction.textID		; $7134
	ld a,c			; $7136
	ld (de),a		; $7137
	ret			; $7138


; The main maku tree script; her exact behaviour varies over time, mostly with what
; animation she does.
makuTree_subid00Script_body:
	jumptable_objectbyte Interaction.var3e
	.dw @mode00_justShowText
	.dw @mode01_showTextWithLaugh
	.dw @mode02_showTwoTexts_frownOnSecond
	.dw @mode03_constantFrownAndShowText
	.dw @mode04_constantFrownAndShowText
	.dw @mode05_showTwoTexts_frownOnFirst
	.dw @mode06


@mode00_justShowText:
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	jump2byte --


@mode01_showTextWithLaugh:
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	asm15 makuTree_setAnimation, $03
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	wait 1
	asm15 makuTree_setAnimation, $00
	jump2byte --


@mode02_showTwoTexts_frownOnSecond:
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	disableinput
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	wait 30
	asm15 makuTree_setAnimation, $04
	asm15 makuTree_showTextWithOffset, $01
	wait 1
	asm15 makuTree_setAnimation, $00
	enableinput
	jump2byte --


@mode03_constantFrownAndShowText:
@mode04_constantFrownAndShowText:
	asm15 makuTree_setAnimation, $04
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	jump2byte --


@mode05_showTwoTexts_frownOnFirst:
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	disableinput
	asm15 makuTree_setAnimation, $02
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	wait 30
	asm15 makuTree_setAnimation, $00
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $01
	wait 1
	enableinput
	jump2byte --


@mode06:
	; Unimplemented


; Cutscene where maku tree disappears
makuTree_subid01Script_body:
	disablemenu
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive

	checkpalettefadedone
	wait 210

	showtextlowindex <TX_0564
	wait 60

	playsound SNDCTRL_STOPMUSIC
	asm15 makuTree_setAnimation, $04
	wait 60

	playsound SND_MAKUDISAPPEAR
	writememory wCutsceneTrigger, CUTSCENE_MAKU_TREE_DISAPPEARING
	wait 210

	showtextlowindex <TX_0540
	playsound SND_MAKUDISAPPEAR
	wait 210

	showtextlowindex <TX_0541
	playsound SND_MAKUDISAPPEAR
	wait 150

	writememory $cfc0, $01
	asm15 incMakuTreeState
	scriptend


; Maku tree just after being saved (present)
makuTree_subid02Script_body:
	asm15 makuTree_checkSpawnSeedSatchel
	setmusic MUS_MAKU_TREE
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive

	jumpifroomflagset $80, @npcLoop ; Check if she's already dropped the satchel

	checkabutton
	disableinput
	asm15 makuTree_setAnimation, $02
	showtextlowindex <TX_0542
	wait 30
	asm15 makuTree_setAnimation, $03
	showtextlowindex <TX_0543
	wait 30
	asm15 makuTree_setAnimation, $01
	showtextlowindex <TX_0544
	wait 30
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_0545
	wait 30
	asm15 makuTree_setAnimation, $01
	showtextlowindex <TX_0546
	wait 30
	asm15 makuTree_setAnimation, $04
	showtextlowindex <TX_0547
	wait 30

@explainAgain:
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_0548
	wait 30
	asm15 makuTree_setAnimation, $04
	showtextlowindex <TX_0549
	wait 30
	wait 30
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_054a
	wait 30
	jumpiftextoptioneq $00, @explainAgain

	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_054b
	wait 30
	asm15 makuTree_setAnimation, $04
	showtextlowindex <TX_054c
	wait 30
	showtextlowindex <TX_054d
	wait 30
	asm15 makuTree_setAnimation, $03
	showtextlowindex <TX_054e
	wait 30
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_054f
	wait 30

	setglobalflag GLOBALFLAG_MAKU_GIVES_ADVICE_FROM_PRESENT_MAP
	writememory wMakuMapTextPresent, <TX_054f

	showtextlowindex <TX_0550
	wait 30
	asm15 _makuTree_dropSeedSatchel
	wait 140
	showtextlowindex <TX_0561
	wait 30
	enableinput
@npcLoop:
	checkabutton
	disableinput
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_054f
	wait 30
	asm15 makuTree_setAnimation, $00
	enableinput
	jump2byte @npcLoop


; Cutscene where Link gets the maku seed, then Twinrova appears
makuTree_subid06Script_part1_body:
	disableinput
	wait 60
	showtextlowindex <TX_0559
	wait 30

	asm15 makuTree_spawnMakuSeed
	checkmemoryeq wTmpcfc0.genericCutscene.state, $01

	playsound SND_GETSEED
	giveitem TREASURE_MAKU_SEED, $00
	wait 30

	writememory   wCutsceneTrigger, CUTSCENE_TWINROVA_REVEAL
	checkmemoryeq wTmpcfc0.genericCutscene.state, $02
	setanimation $02
	scriptend

makuTree_subid06Script_part2_body:
	disableinput
	asm15 makuTree_chooseTextAfterSeeingTwinrova
	checkpalettefadedone
	wait 60
	showloadedtext
	wait 20

	setanimation $00
	wait 10

	writememory wMakuMapTextPresent, <TX_0560
	addobjectbyte Interaction.textID, $01
	showloadedtext
	wait 20

	setglobalflag GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME
	writememory wTmpcfc0.genericCutscene.state, $04
	asm15 incMakuTreeState
	enableinput
	setcollisionradii $08, $08
	makeabuttonsensitive

@npcLoop:
	checkabutton
	showloadedtext
	jump2byte @npcLoop



; ==============================================================================
; INTERACID_MAKU_SPROUT
; ==============================================================================

;;
; @addr{72ca}
makuSprout_setAnimation:
	ld e,Interaction.var3b		; $72ca
	ld (de),a		; $72cc
	jp interactionSetAnimation		; $72cd


; The main maku sprout script; her exact behaviour varies over time, mostly with what
; animation she does.
makuSprout_subid00Script_body:
	jumptable_objectbyte Interaction.var3e
	.dw @mode00_showDifferentTextFirstTime_distressedAnim
	.dw @mode01_happyAnimationWhileTalking
	.dw @mode02_showDifferentTextFirstTime


@mode00_showDifferentTextFirstTime_distressedAnim:
	asm15 makuSprout_setAnimation, $02
	setcollisionradii $08, $08
	makeabuttonsensitive
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
--
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $01
	jump2byte --


@mode01_happyAnimationWhileTalking:
	asm15 makuSprout_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	asm15 makuSprout_setAnimation, $01
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	wait 1
	asm15 makuSprout_setAnimation, $00
	jump2byte --


@mode02_showDifferentTextFirstTime:
	asm15 makuSprout_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
--
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $01
	jump2byte --


; ==============================================================================
; INTERACID_REMOTE_MAKU_CUTSCENE
; ==============================================================================

;;
; @addr{7318}
remoteMakuCutscene_fadeoutToBlackWithDelay:
	call fadeoutToBlackWithDelay		; $7318
	jr ++		; $731b

;;
; Unused?
; @addr{731d}
remoteMakuCutscene_fadeinFromBlackWithDelay:
	call fadeinFromBlackWithDelay		; $731d
++
	ld a,$ff		; $7320
	ld (wDirtyFadeBgPalettes),a		; $7322
	ld (wFadeBgPaletteSources),a		; $7325
	ld a,$01		; $7328
	ld (wDirtyFadeSprPalettes),a		; $732a
	ld a,$fe		; $732d
	ld (wFadeSprPaletteSources),a		; $732f
	ret			; $7332

;;
; @addr{7333}
remoteMakuCutscene_checkinitUnderwaterWaves:
	ld e,Interaction.var03		; $7333
	ld a,(de)		; $7335
	cp $09			; $7336
	ret nz			; $7338
	jpab bank1.checkInitUnderwaterWaves		; $7339


; ==============================================================================
; INTERACID_GORON_ELDER
; ==============================================================================

;;
; @addr{7341}
goronElder_lookingUpAnimation:
	ld h,d			; $7341
	ld l,Interaction.var3f		; $7342
	ld (hl),$01		; $7344
	ld a,$04		; $7346
	jp interactionSetAnimation		; $7348

goronElder_normalAnimation:
	ld h,d			; $734b
	ld l,Interaction.var3f		; $734c
	ld (hl),$00		; $734e
	ld a,$02		; $7350
	jp interactionSetAnimation		; $7352


; Cutscene where goron elder is saved / NPC in that room after that
goronElderScript_subid00_body:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, stubScript

	asm15 checkEssenceObtained, $04
	jumpifmemoryset $cddb, CPU_ZFLAG, stubScript

	initcollisions
	jumpifroomflagset $40, @npcLoop

	; Just saved the elder, run the cutscene

	asm15 goronElder_lookingUpAnimation
	checkpalettefadedone
	checkobjectbyteeq Interaction.animParameter, $ff
	wait 180

	asm15 goronElder_normalAnimation
	showtext TX_2487
	wait 30

	asm15 moveLinkToPosition, $01
	wait 1
	checkmemoryeq w1Link.id, SPECIALOBJECTID_LINK
	wait 30

	showtext TX_2488
	wait 30

	giveitem TREASURE_CROWN_KEY, $00
	disableinput
	setglobalflag GLOBALFLAG_SAVED_GORON_ELDER
	orroomflag $40
	wait 30

	enableinput
	jump2byte ++

@npcLoop:
	checkabutton
++
	showtext TX_2489
	jump2byte @npcLoop


; NPC hanging out in rolling ridge (after getting D5 essence)
goronElderScript_subid01_body:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, stubScript

	asm15 checkEssenceNotObtained, $04
	jumpifmemoryset $cddb, CPU_ZFLAG, stubScript

	initcollisions
@npcLoop:
	checkabutton
	showtext TX_24e4
	jump2byte @npcLoop


; ==============================================================================
; INTERACID_CLOAKED_TWINROVA
; ==============================================================================

; Cutscene at maku tree screen after saving Nayru
cloakedTwinrova_subid00Script_body:
	wait 16
	asm15 objectWritePositionTocfd5
	asm15 objectSetVisible82

	writememory wTmpcfc0.genericCutscene.cfd0, $08
	playsound MUS_DISASTER
	asm15 forceLinkDirection, DIR_RIGHT
	wait 120

	showtextlowindex <TX_2801
	wait 40
	writememory wTmpcfc0.genericCutscene.cfd0, $09
	playsound SNDCTRL_FAST_FADEOUT
	scriptend


; Cutscene after getting maku seed
cloakedTwinrova_subid02Script_body:
	wait 16
	asm15 objectSetVisible82
	playsound MUS_DISASTER
	wait 60
	showtextlowindex <TX_2811
	wait 30
	scriptend


; ==============================================================================
; INTERACID_MISC_PUZZLES
; ==============================================================================

;;
; @addr{73d5}
miscPuzzles_drawCrownDungeonOpeningFrame1:
	ld c,$00		; $73d5
	jr ++			; $73d7

;;
; @addr{73d9}
miscPuzzles_drawCrownDungeonOpeningFrame2:
	ld c,$01		; $73d9
	jr ++			; $73db

;;
; @addr{73dd}
miscPuzzles_drawCrownDungeonOpeningFrame3:
	ld c,$02		; $73dd
++
	push de			; $73df
	callab bank2.drawCrownDungeonOpeningTiles		; $73e0
	call reloadTileMap		; $73e8
	pop de			; $73eb
	ld a,$0f		; $73ec
	call setScreenShakeCounter		; $73ee
	ld a,SND_DOORCLOSE		; $73f1
	call playSound		; $73f3

	ld bc,$2060		; $73f6
	call @spawnPuff		; $73f9
	ld bc,$2070		; $73fc
	call @spawnPuff		; $73ff
	ld bc,$2080		; $7402
	call @spawnPuff		; $7405
	ld bc,$2090		; $7408
@spawnPuff:
	call getFreeInteractionSlot		; $740b
	ret nz			; $740e
	ld (hl),INTERACID_PUFF		; $740f
	inc l			; $7411
	ld (hl),$81		; $7412
	ld l,Interaction.yh		; $7414
	ld (hl),b		; $7416
	ld l,Interaction.xh		; $7417
	ld (hl),c		; $7419
	ret			; $741a


; ==============================================================================
; INTERACID_TWINROVA
; ==============================================================================

;;
; @addr{741b}
objectWritePositionTocfd5:
	xor a			; $741b

twinrova_writePositionWithXOffsetTocfd5:
	ldh (<hFF8B),a	; $741c
	call objectGetPosition		; $741e
	ldh a,(<hFF8B)	; $7421
	ld hl,wTmpcfc0.genericCutscene.cfd5		; $7423
	ld (hl),b		; $7426
	inc l			; $7427
	add c			; $7428
	ld (hl),a		; $7429
	ret			; $742a


; Linked cutscene after saving Nayru?
twinrova_subid00Script_body:
	setanimation DIR_DOWN
	writeobjectbyte Interaction.direction, DIR_DOWN

	asm15 twinrova_writePositionWithXOffsetTocfd5, $18
	asm15 forceLinkDirection, DIR_UP
	wait 90

	asm15 twinrova_writePositionWithXOffsetTocfd5, $f0
	playsound MUS_DISASTER
	wait 20

	showtextlowindex <TX_2803
	wait 20
	asm15 twinrova_writePositionWithXOffsetTocfd5, $40
	wait 16
	showtextlowindex <TX_2804
	wait 20
	asm15 twinrova_writePositionWithXOffsetTocfd5, $f0
	wait 16
	showtextlowindex <TX_2805
	wait 20
	asm15 twinrova_writePositionWithXOffsetTocfd5, $40
	wait 16
	showtextlowindex <TX_2806
	wait 20
	asm15 twinrova_writePositionWithXOffsetTocfd5, $18
	wait 16
	showtextlowindex <TX_2807
	wait 60
	playsound SNDCTRL_FAST_FADEOUT
	wait 30
	scriptend


; Twinrova introduction? Unlinked equivalent of subids $00-$01?
twinrova_subid02Script_body:
	setanimation DIR_DOWN
	writeobjectbyte Interaction.direction, DIR_DOWN
	wait 90
	showtextlowindex <TX_2812
	wait 20
	showtextlowindex <TX_2813
	wait 20
	showtextlowindex <TX_2814
	wait 60
	scriptend


twinrova_subid04Script_body:
	setanimation DIR_DOWN
	writeobjectbyte Interaction.direction, DIR_DOWN
	wait 30
	playsound MUS_DISASTER
	wait 60
	showtextlowindex <TX_2816
	wait 20
	showtextlowindex <TX_2817
	wait 60
	writememory wTmpcfc0.genericCutscene.state, $03
	wait 240
	scriptend


twinrova_subid06Script_body:
	wait 60
	showtextlowindex <TX_2818
	wait 20
	showtextlowindex <TX_2819
	wait 60
	scriptend

; ==============================================================================
; INTERACID_PATCH
; ==============================================================================

;;
; @addr{7498}
patch_jump:
	ld h,d			; $7498
	ld l,Interaction.speedZ		; $7499
	ld a,<(-$180)		; $749b
	ldi (hl),a		; $749d
	ld (hl),>(-$180)		; $749e
	ld a,DISABLE_LINK		; $74a0
	ld (wDisabledObjects),a		; $74a2
	ld (wMenuDisabled),a		; $74a5
	ld (wTextIsActive),a		; $74a8
	ld a,SND_ENEMY_JUMP		; $74ab
	jp playSound		; $74ad

;;
; @addr{74b0}
patch_updateTextSubstitution:
	ld a,(wTmpcfc0.patchMinigame.itemNameText)		; $74b0
	ld (wTextSubstitutions),a		; $74b3
	ret			; $74b6

;;
; @addr{74b7}
patch_restoreControlAndStairs:
	xor a			; $74b7
	ld (wDisabledObjects),a		; $74b8
	ld (wMenuDisabled),a		; $74bb
	ld a,TILEINDEX_INDOOR_UPSTAIRCASE		; $74be

;;
; @param	a	Tile index to put at the stair tile's position
; @addr{74c0}
patch_setStairTile:
	ld c,$49		; $74c0
	call setTile		; $74c2

	call getFreeInteractionSlot		; $74c5
	ret nz			; $74c8
	ld (hl),INTERACID_PUFF		; $74c9
	ld l,Interaction.yh		; $74cb
	ld (hl),$48		; $74cd
	ld l,Interaction.xh		; $74cf
	ld (hl),$98		; $74d1
	ret			; $74d3

;;
; Moves Link to a preset position after the minigame
; @addr{74d4}
patch_moveLinkPositionAtMinigameEnd:
	push de			; $74d4
	call clearAllItemsAndPutLinkOnGround		; $74d5
	pop de			; $74d8
	call setLinkForceStateToState08		; $74d9
	call resetLinkInvincibility		; $74dc
	ld l,<w1Link.yh		; $74df
	ld (hl),$48		; $74e1
	ld l,<w1Link.xh		; $74e3
	ld (hl),$78		; $74e5
	ld l,<w1Link.direction		; $74e7
	ld (hl),a		; $74e9
	inc a			; $74ea
	ld (wTmpcfc0.patchMinigame.screenFadedOut),a		; $74eb
	jp resetCamera		; $74ee

;;
; @addr{74f1}
patch_turnToFaceLink:
	call objectGetAngleTowardLink		; $74f1
	add $04			; $74f4
	and $18			; $74f6
	swap a			; $74f8
	rlca			; $74fa
	ld e,Interaction.direction		; $74fb
	ld (hl),a		; $74fd
	jp interactionSetAnimation		; $74fe


patch_upstairsRepairTuniNutScript:
	initcollisions
@npcLoop:
	checkabutton
	jumpifmemoryset wPastRoomFlags+(<ROOM_1be), $06, @alreadyMetPatch

	; First meeting
	ormemory wPastRoomFlags+(<ROOM_1be), $06
	showtextnonexitable TX_5800
	jump2byte ++

@alreadyMetPatch:
	showtextnonexitable TX_5801
++
	jumpiftextoptioneq $00, @saidYes1
	showtext TX_5802
	jump2byte @npcLoop
@saidYes1:
	jumptable_objectbyte Interaction.var38
	.dw @hasBrokenNut
	.dw @doesntHaveBrokenNut

@doesntHaveBrokenNut:
	showtext TX_5803
	jump2byte @npcLoop

@hasBrokenNut:
	asm15 patch_updateTextSubstitution
	showtextnonexitable TX_5804
	jumpiftextoptioneq $00, @saidYes2
	showtext TX_5805
	jump2byte @npcLoop

@saidYes2:
	asm15 patch_jump
	wait 8
	showtext TX_5806
	wait 8
	scriptend


patch_upstairsRepairSwordScript_body:
	initcollisions
@npcLoop:
	checkabutton
	showtextnonexitable TX_5810
	jumpiftextoptioneq $00, @saidYes1
	showtext TX_5802
	jump2byte @npcLoop

@saidYes1:
	asm15 patch_updateTextSubstitution
	showtextnonexitable TX_5804
	jumpiftextoptioneq $00, @saidYes2
	showtext TX_5805
	jump2byte @npcLoop

@saidYes2:
	asm15 patch_jump
	wait 8
	showtext TX_5806
	wait 8
	scriptend


patch_downstairsScript_body:
	initcollisions
@npcLoop:
	checkabutton
	showtextnonexitable TX_5807
	jumpiftextoptioneq $01, @saidNo

	showtextnonexitable TX_5808
	jumpiftextoptioneq $00, @beginGame

	asm15 patch_updateTextSubstitution
	showtextnonexitable TX_5809
	jumpiftextoptioneq $00, @beginGame

@saidNo:
	asm15 patch_updateTextSubstitution
	showtext TX_5805
	jump2byte @npcLoop

@beginGame:
	showtext TX_580a
	asm15 patch_setStairTile, TILEINDEX_STANDARD_FLOOR
	wait 8
	scriptend


; ==============================================================================
; INTERACID_MOBLIN
; ==============================================================================

;;
; Spawn the enemy that's going to replace this interaction
; @addr{7592}
moblin_spawnEnemyHere:
	call getFreeEnemySlot		; $7592
	ret nz			; $7595
	ld (hl),ENEMYID_MASKED_MOBLIN		; $7596
	jp objectCopyPosition		; $7598

; ==============================================================================
; INTERACID_CARPENTER
; ==============================================================================

;;
; @param	a	Position to build bridge (top part)
; @addr{759b}
carpenter_buildBridgeColumn:
	ld c,a			; $759b
	ld a,TILEINDEX_HORIZONTAL_BRIDGE_TOP		; $759c
	call setTile		; $759e
	ld a,c			; $75a1
	add $10			; $75a2
	ld c,a			; $75a4
	ld a,TILEINDEX_HORIZONTAL_BRIDGE_BOTTOM		; $75a5
	call setTile		; $75a7
	ld hl,wTmpcfc0.carpenterSearch.cfd0		; $75aa
	inc (hl)		; $75ad
	ld a,SND_DOORCLOSE		; $75ae
	jp playSound		; $75b0


; Head carpenter
carpenter_subid00Script_body:
	makeabuttonsensitive
@npcLoop:
	setanimation $04
	checkabutton
	setanimation $05
	jumpifglobalflagset GLOBALFLAG_GOT_FLUTE, @haveFlute

	; Don't have flute
	showtextlowindex <TX_2301
	setglobalflag GLOBALFLAG_TALKED_TO_HEAD_CARPENTER
	jump2byte @npcLoop

@haveFlute:
	jumpifmemoryeq wTmpcfc0.carpenterSearch.cfd0, $01, @alreadyAgreedToSearch
	showtextlowindex <TX_2302
	jumpiftextoptioneq $00, @agreedToHelp

	; Refused to help
	showtextlowindex <TX_2303
	jump2byte @npcLoop

@agreedToHelp:
	showtextlowindex <TX_2304
@repeatExplanation:
	jumpiftextoptioneq $00, ++
	showtextlowindex <TX_2305
	jump2byte @repeatExplanation
++
	writememory wTmpcfc0.carpenterSearch.cfd0, $01
	jump2byte @npcLoop

@alreadyAgreedToSearch:
	showtextlowindex <TX_2306
	jump2byte @npcLoop



; ==============================================================================
; INTERACID_RAFTWRECK_CUTSCENE
; ==============================================================================
raftwreckCutsceneScript_body:
	wait 8
	playsound SNDCTRL_FAST_FADEOUT
	asm15 setLinkDirection, DIR_UP
	setangle ANGLE_UP
	applyspeed $6c
	wait 60

	playsound MUS_DISASTER
	asm15 darkenRoom
	writememory hSprPaletteSources, $00
	writememory hDirtySprPalettes,  $00
	checkpalettefadedone
	wait 90

	writememory wTmpcfc0.genericCutscene.state, $01
	playsound SND_LIGHTNING
	wait 34

	playsound SND_LIGHTNING
	checkmemoryeq wTmpcfc0.genericCutscene.state, $02

	asm15 raftwreckCutscene_spawnHelperSubid, $03
	wait 20

	writeobjectbyte Interaction.var38, $01 ; Enable "oscillation" of raft's Y pos
	setspeed SPEED_080
	asm15 setLinkDirection, DIR_RIGHT
	setangle ANGLE_LEFT
	applyspeed $61
	wait 90

	writeobjectbyte Interaction.var38, $00 ; Disable oscillation
	setspeed SPEED_0c0
	setangle ANGLE_RIGHT
	applyspeed $41
	wait 30

	playsound SND_WIND
	asm15 raftwreckCutscene_spawnHelperSubid, $04
	wait 10

	setspeed SPEED_140
	setangle ANGLE_LEFT
	applyspeed $31
	wait 90

	asm15 raftwreckCutscene_spawnHelperSubid, $05
	writeobjectbyte Interaction.var38, $01 ; Enable oscillation
	setspeed SPEED_080
	setangle ANGLE_RIGHT
	applyspeed $ff
	wait 60
	scriptend

;;
; Deals with spawning instances of INTERACID_RAFTWRECK_CUTSCENE (creates wind and
; lightning strikes)
; @addr{764a}
raftwreckCutscene_spawnHelperSubid:
	ld b,a			; $764a
	call getFreeInteractionSlot		; $764b
	ret nz			; $764e
	ld (hl),INTERACID_RAFTWRECK_CUTSCENE_HELPER		; $764f
	inc l			; $7651
	ld (hl),b		; $7652
	ret			; $7653


; ==============================================================================
; INTERACID_TOKKEY
; ==============================================================================

;;
; @addr{7654}
tokkey_jump:
	ld bc,-$1a0		; $7654
	jp objectSetSpeedZ		; $7657

;;
; @addr{765a}
tokkey_centerLinkOnTile:
	ld hl,w1Link.y		; $765a
	call centerCoordinatesOnTile		; $765d
	ld l,<w1Link.direction		; $7660
	ld (hl),$01		; $7662
	ret			; $7664

; @addr{7665}
tokkey_makeLinkPlayTuneOfCurrents:
	call getFreeInteractionSlot		; $7665
	ret nz			; $7668
	ld (hl),INTERACID_PLAY_HARP_SONG		; $7669
	inc l			; $766b
	inc (hl)		; $766c
	ret			; $766d


tokkayScript_justHeardTune_body:
	asm15 tokkey_jump
	wait 60

	showtextlowindex <TX_2c02
	setmusic SNDCTRL_STOPMUSIC
	setspeed SPEED_100
	moveright $10

	asm15 tokkey_jump
	movedown $0a

	setmusic MUS_CRAZY_DANCE
	wait 125

	setstate $02
	xorcfc0bit 1
	setspeed SPEED_180
	moveleft $10
	wait 15

	callscript tokkeyScriptFunc_runAcrossDesk
	callscript tokkeyScriptFunc_runAcrossDesk

	setstate $04 ; Stop movement animation
	wait 120

	xorcfc0bit 1
	setstate $02 ; Resume animation
	moveright $10

	setanimation $02
	xorcfc0bit 1
	wait 70

	setstate $03 ; Faster animation
	moveright $10
	setanimation $02
	wait 15

	callscript tokkeyScriptFunc_hopAcrossDesk
	callscript tokkeyScriptFunc_hopAcrossDesk

	moveleft $10

	setanimation $02
	wait 90

	playsound SNDCTRL_STOPMUSIC
	playsound SND_BIG_EXPLOSION
	xorcfc0bit 1
	setstate $02
	setspeed SPEED_100
	asm15 tokkey_jump
	movedown $18

	setanimation $03
	asm15 tokkey_centerLinkOnTile
	wait 90

	showtextlowindex <TX_2c03
	wait 60

	asm15 tokkey_makeLinkPlayTuneOfCurrents
	checkcfc0bit 7 ; Wait for Link to finish
	wait 60

	playsound SNDCTRL_STOPSFX
	giveitem TREASURE_TUNE_OF_CURRENTS_SUBID_00
	xorcfc0bit 0
	orroomflag $40
	enableinput
	resetmusic
	setcollisionradii $06, $06
	setstate $01
	jump2byte tokkeyScript_alreadyTaughtTune

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
	incstate
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
	generateoraskforsecret $09
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
	generateoraskforsecret $19
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
	generateoraskforsecret $02
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
	asm15 goron_targetCarts_checkHitAllTargets
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
	generateoraskforsecret $12
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
	generateoraskforsecret $03
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


