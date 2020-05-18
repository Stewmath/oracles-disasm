;;
; @addr{4000}
updateSpecialObjects:
	ld hl,wLinkIDOverride		; $4000
	ld a,(hl)		; $4003
	ld (hl),$00		; $4004
	or a			; $4006
	jr z,+			; $4007
	and $7f			; $4009
	ld (w1Link.id),a		; $400b
+
.ifdef ROM_AGES
	ld hl,w1Link.var2f		; $400e
	ld a,(hl)		; $4011
	and $3f			; $4012
	ld (hl),a		; $4014

	ld a,TREASURE_MERMAID_SUIT		; $4015
	call checkTreasureObtained		; $4017
	jr nc,+			; $401a
	set 6,(hl)		; $401c
+
	ld a,(wTilesetFlags)		; $401e
	and TILESETFLAG_UNDERWATER			; $4021
	jr z,+			; $4023
	set 7,(hl)		; $4025
+
.endif

	xor a			; $4027
	ld (wBraceletGrabbingNothing),a		; $4028
	ld (wcc92),a		; $402b
	ld (wForceLinkPushAnimation),a		; $402e

	ld hl,wcc95		; $4031
	ld a,(hl)		; $4034
	or $7f			; $4035
	ld (hl),a		; $4037

	ld hl,wLinkTurningDisabled		; $4038
	res 7,(hl)		; $403b

	call _updateGameKeysPressed		; $403d

	ld hl,w1Companion		; $4040
	call @updateSpecialObject		; $4043

	xor a			; $4046
	ld (wLinkClimbingVine),a		; $4047
.ifdef ROM_AGES
	ld (wDisallowMountingCompanion),a		; $404a
.endif

	ld hl,w1Link		; $404d
	call @updateSpecialObject		; $4050

	call _updateLinkInvincibilityCounter		; $4053

	ld a,(wLinkPlayingInstrument)		; $4056
	ld (wLinkRidingObject),a		; $4059

	ld hl,wLinkImmobilized		; $405c
	ld a,(hl)		; $405f
	and $0f			; $4060
	ld (hl),a		; $4062

	xor a			; $4063
	ld (wcc67),a		; $4064
	ld (w1Link.var2a),a		; $4067
	ld (wccd8),a		; $406a

	ld hl,wInstrumentsDisabledCounter		; $406d
	ld a,(hl)		; $4070
	or a			; $4071
	jr z,+			; $4072
	dec (hl)		; $4074
+
	ld hl,wGrabbableObjectBuffer		; $4075
	ld b,$10		; $4078
	jp clearMemory		; $407a

;;
; @param hl Object to update (w1Link or w1Companion)
; @addr{407d}
@updateSpecialObject:
	ld a,(hl)		; $407d
	or a			; $407e
	ret z			; $407f

	ld a,l			; $4080
	ldh (<hActiveObjectType),a	; $4081
	ld a,h			; $4083
	ldh (<hActiveObject),a	; $4084
	ld d,h			; $4086

	ld l,Object.id		; $4087
	ld a,(hl)		; $4089
	rst_jumpTable			; $408a
	.dw  specialObjectCode_link
.ifdef ROM_AGES
	.dw  specialObjectCode_transformedLink
.else
	.dw  specialObjectCode_subrosiaDanceLink
.endif
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_transformedLink
	.dw  specialObjectCode_linkInCutscene
	.dw  specialObjectCode_linkRidingAnimal
	.dw _specialObjectCode_minecart
	.dw _specialObjectCode_ricky
	.dw _specialObjectCode_dimitri
	.dw _specialObjectCode_moosh
	.dw _specialObjectCode_maple
	.dw  specialObjectCode_companionCutscene
	.dw  specialObjectCode_companionCutscene
	.dw  specialObjectCode_companionCutscene
	.dw  specialObjectCode_companionCutscene
	.dw _specialObjectCode_raft

;;
; Updates wGameKeysPressed based on wKeysPressed, and updates wLinkAngle based on
; direction buttons pressed.
; @addr{40b3}
_updateGameKeysPressed:
	ld a,(wKeysPressed)		; $40b3
	ld c,a			; $40b6

	ld a,(wUseSimulatedInput)		; $40b7
	or a			; $40ba
	jr z,@updateKeysPressed_c	; $40bb

	cp $02			; $40bd
	jr z,@reverseMovement			; $40bf

	call getSimulatedInput		; $40c1
	jr @updateKeysPressed_a		; $40c4

	; This code is used in the Ganon fight where he reverses Link's movement?
@reverseMovement:
	xor a			; $40c6
	ld (wUseSimulatedInput),a		; $40c7
	ld a,BTN_DOWN | BTN_LEFT		; $40ca
	and c			; $40cc
	rrca			; $40cd
	ld b,a			; $40ce

	ld a,BTN_UP | BTN_RIGHT		; $40cf
	and c			; $40d1
	rlca			; $40d2
	or b			; $40d3
	ld b,a			; $40d4

	ld a,$0f		; $40d5
	and c			; $40d7
	or b			; $40d8

@updateKeysPressed_a:
	ld c,a			; $40d9
@updateKeysPressed_c:
	ld a,(wLinkDeathTrigger)		; $40da
	or a			; $40dd
	ld hl,wGameKeysPressed		; $40de
	jr nz,@dying		; $40e1

	; Update wGameKeysPressed, wGameKeysJustPressed based on the value of 'c'.
	ld a,(hl)		; $40e3
	cpl			; $40e4
	ld b,a			; $40e5
	ld a,c			; $40e6
	ldi (hl),a		; $40e7
	and b			; $40e8
	ldi (hl),a		; $40e9

	; Update Link's angle based on the direction buttons pressed.
	ld a,c			; $40ea
	and $f0			; $40eb
	swap a			; $40ed
	ld hl,@directionButtonToAngle		; $40ef
	rst_addAToHl			; $40f2
	ld a,(hl)		; $40f3
	ld (wLinkAngle),a		; $40f4
	ret			; $40f7

@dying:
	; Clear wGameKeysPressed, wGameKeysJustPressed
	xor a			; $40f8
	ldi (hl),a		; $40f9
	ldi (hl),a		; $40fa

	; Set wLinkAngle to $ff
	dec a			; $40fb
	ldi (hl),a		; $40fc
	ret			; $40fd

; Index is direction buttons pressed, value is the corresponding angle.
@directionButtonToAngle:
	.db $ff $08 $18 $ff $00 $04 $1c $ff
	.db $10 $0c $14 $ff $ff $ff $ff

;;
; This is called when Link is riding something (wLinkObjectIndex == $d1).
;
; @addr{410d}
func_410d:
	xor a			; $410d
	ldh (<hActiveObjectType),a	; $410e
	ld de,w1Companion.id		; $4110
	ld a,d			; $4113
	ldh (<hActiveObject),a	; $4114
	ld a,(de)		; $4116
	sub SPECIALOBJECTID_MINECART			; $4117
	rst_jumpTable			; $4119

	.dw @ridingMinecart
	.dw @ridingRicky
	.dw @ridingDimitri
	.dw @ridingMoosh
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @ridingRaft

@invalid:
	ret			; $412e

@ridingRicky:
	ld bc,$0000		; $412f
	jr @companion		; $4132

@ridingDimitri:
	ld e,<w1Companion.direction		; $4134
	ld a,(de)		; $4136
	rrca			; $4137
	ld bc,$f600		; $4138
	jr nc,@companion	; $413b

	ld c,$fb		; $413d
	rrca			; $413f
	jr nc,@companion	; $4140

	ld c,$05		; $4142
	jr @companion		; $4144

@ridingMoosh:
	ld e,SpecialObject.direction		; $4146
	ld a,(de)		; $4148
	rrca			; $4149
	ld bc,$f200		; $414a
	jr nc,@companion	; $414d
	ld b,$f0		; $414f

;;
; @param	bc	Position offset relative to companion to place Link at
; @addr{4151}
@companion:
	ld hl,w1Link.yh		; $4151
	call objectCopyPositionWithOffset		; $4154

	ld e,<w1Companion.direction		; $4157
	ld l,<w1Link.direction		; $4159
	ld a,(de)		; $415b
	ld (hl),a		; $415c
	ld a,$01		; $415d
	ld (wcc90),a		; $415f

	ld l,<w1Link.var2a		; $4162
	ldi a,(hl)		; $4164
	or (hl)			; $4165
	ld l,<w1Link.knockbackCounter		; $4166
	or (hl)			; $4168
	jr nz,@noDamage		; $4169
	ld l,<w1Link.damageToApply		; $416b
	ld e,l			; $416d
	ld a,(de)		; $416e
	or a			; $416f
	jr z,@noDamage		; $4170

	ldi (hl),a ; [w1Link.damageToApply] = [w1Companion.damageToApply]

	; Copy health, var2a, invincibilityCounter, knockbackAngle, knockbackCounter,
	; stunCounter from companion to Link.
	ld l,<w1Link.health		; $4173
	ld e,l			; $4175
	ld b,$06		; $4176
	call copyMemoryReverse		; $4178
	jr @label_05_010		; $417b

@noDamage:
	ld l,<w1Link.damageToApply		; $417d
	ld e,l			; $417f
	ld a,(hl)		; $4180
	ld (de),a		; $4181

	; Copy health, var2a, invincibilityCounter, knockbackAngle, knockbackCounter,
	; stunCounter from Link to companion.
	ld d,>w1Link		; $4182
	ld h,>w1Companion		; $4184
	ld l,SpecialObject.health		; $4186
	ld e,l			; $4188
	ld b,$06		; $4189
	call copyMemoryReverse		; $418b

@label_05_010:
	ld h,>w1Link		; $418e
	ld d,>w1Companion		; $4190
	ld l,<w1Link.oamFlags		; $4192
	ld a,(hl)		; $4194
	ld l,<w1Link.oamFlagsBackup		; $4195
	cp (hl)			; $4197
	jr nz,+			; $4198
	ld e,<w1Companion.oamFlagsBackup		; $419a
	ld a,(de)		; $419c
+
	ld e,<w1Companion.oamFlags		; $419d
	ld (de),a		; $419f
	ld l,<w1Link.visible		; $41a0
	ld e,l			; $41a2
	ld a,(de)		; $41a3
	and $83			; $41a4
	ld (hl),a		; $41a6
	ret			; $41a7

@ridingMinecart:
	ld h,d			; $41a8
	ld l,<w1Companion.direction		; $41a9
	ld a,(hl)		; $41ab
	ld l,<w1Companion.animParameter		; $41ac
	add (hl)		; $41ae
	ld hl,@linkOffsets		; $41af
	rst_addDoubleIndex			; $41b2
	ldi a,(hl)		; $41b3
	ld c,(hl)		; $41b4
	ld b,a			; $41b5
	ld hl,w1Link.yh		; $41b6
	call objectCopyPositionWithOffset		; $41b9

	; Disable terrain effects on Link
	ld l,<w1Link.visible		; $41bc
	res 6,(hl)		; $41be

	ret			; $41c0


; Data structure:
;   Each row corresponds to a frame of the minecart animation.
;   Each column corresponds to a direction.
;   Each 2 bytes are a position offset for Link relative to the minecart.
@linkOffsets:
;           --Up--   --Right-- --Down-- --Left--
	.db $f7 $00  $f7 $00   $f7 $00  $f7 $00
	.db $f7 $ff  $f8 $00   $f7 $ff  $f8 $00

;;
; @addr{41d1}
@ridingRaft:
.ifdef ROM_AGES
	ld a,(wLinkForceState)		; $41d1
	cp LINK_STATE_RESPAWNING			; $41d4
	ret z			; $41d6

	ld hl,w1Link.state		; $41d7
	ldi a,(hl)		; $41da
	cp LINK_STATE_RESPAWNING			; $41db
	jr nz,++		; $41dd
	ldi a,(hl) ; Check w1Link.state2
	cp $03			; $41e0
	ret c			; $41e2
++
	; Disable terrain effects on Link
	ld l,<w1Link.visible		; $41e3
	res 6,(hl)		; $41e5

	; Set Link's position to be 5 or 6 pixels above the raft, depending on the frame
	; of animation
	ld bc,$fb00		; $41e7
	ld e,<w1Companion.animParameter		; $41ea
	ld a,(de)		; $41ec
	or a			; $41ed
	jr z,+			; $41ee
	dec b			; $41f0
+
	call objectCopyPositionWithOffset		; $41f1
	jp objectSetVisiblec3		; $41f4
.endif

;;
; Initializes SpecialObject.oamFlags and SpecialObject.oamTileIndexBase, according to the
; id of the object.
;
; @param	d	Object
; @addr{41f7}
specialObjectSetOamVariables:
	ld e,SpecialObject.var32		; $41f7
	ld a,$ff		; $41f9
	ld (de),a		; $41fb

	ld e,SpecialObject.id		; $41fc
	ld a,(de)		; $41fe
	ld hl,@data		; $41ff
	rst_addDoubleIndex			; $4202

	ld e,SpecialObject.oamTileIndexBase		; $4203
	ldi a,(hl)		; $4205
	ld (de),a		; $4206

	; Write to SpecialObject.oamFlags
	dec e			; $4207
	ldi a,(hl)		; $4208
	ld (de),a		; $4209

	; Write flags to SpecialObject.oamFlagsBackup as well
	dec e			; $420a
	ld (de),a		; $420b
	ret			; $420c

; 2 bytes for each SpecialObject id: oamTileIndexBase, oamFlags (palette).
; @addr{420d}
@data:
	.db $70 $08 ; 0x00 (Link)
	.db $70 $08 ; 0x01
	.db $70 $08 ; 0x02
	.db $70 $08 ; 0x03
	.db $70 $08 ; 0x04
	.db $70 $08 ; 0x05
	.db $70 $08 ; 0x06
	.db $70 $08 ; 0x07
	.db $70 $08 ; 0x08
	.db $70 $08 ; 0x09
	.db $60 $0c ; 0x0a (Minecart)
	.db $60 $0b ; 0x0b
	.db $60 $0a ; 0x0c
	.db $60 $09 ; 0x0d
	.db $60 $08 ; 0x0e
	.db $60 $0b ; 0x0f
	.db $60 $0a ; 0x10
	.db $60 $09 ; 0x11
	.db $60 $08 ; 0x12
	.db $60 $0b ; 0x13

;;
; Deals 4 points of damage (1/2 heart?) to link, and applies knockback in the opposite
; direction he is moving.
; @addr{4235}
_dealSpikeDamageToLink:
	ld a,(wLinkRidingObject)		; $4235
	ld b,a			; $4238
	ld h,d			; $4239
	ld l,SpecialObject.invincibilityCounter		; $423a
	or (hl)			; $423c
	ret nz			; $423d

	ld (hl),40 ; 40 frames invincibility

	; Get damage value (4 normally, 2 with red luck ring)
	ld a,RED_LUCK_RING		; $4240
	call cpActiveRing		; $4242
	ld a,-4		; $4245
	jr nz,+			; $4247
	sra a			; $4249
+
	ld l,SpecialObject.damageToApply		; $424b
	add (hl)		; $424d
	ld (hl),a		; $424e

	ld l,SpecialObject.var2a		; $424f
	ld (hl),$80		; $4251

	; 10 frames knockback
	ld l,SpecialObject.knockbackCounter		; $4253
	ld a,10		; $4255
	add (hl)		; $4257
	ld (hl),a		; $4258

	; Calculate knockback angle
	ld e,SpecialObject.angle		; $4259
	ld a,(de)		; $425b
	xor $10			; $425c
	ld l,SpecialObject.knockbackAngle		; $425e
	ld (hl),a		; $4260

	ld a,SND_DAMAGE_LINK		; $4261
	call playSound		; $4263
	jr linkApplyDamage_b5			; $4266

;;
; @addr{4268}
updateLinkDamageTaken:
	callab bank6.linkUpdateDamageToApplyForRings		; $4268

linkApplyDamage_b5:
	callab bank6.linkApplyDamage		; $4270
	ret			; $4278

;;
; @addr{4279}
_updateLinkInvincibilityCounter:
	ld hl,w1Link.invincibilityCounter		; $4279
	ld a,(hl)		; $427c
	or a			; $427d
	ret z			; $427e

	; If $80 or higher, invincibilityCounter goes up and Link doesn't flash red
	bit 7,a			; $427f
	jr nz,@incCounter	; $4281

	; Otherwise it goes down, and Link flashes red
	dec (hl)		; $4283
	jr z,@normalFlags	; $4284

@func_4244:

	ld a,(wFrameCounter)		; $4286
	bit 2,a			; $4289
	jr nz,@normalFlags	; $428b

	; Set Link's palette to red
	ld l,SpecialObject.oamFlags		; $428d
	ld (hl),$0d		; $428f
	ret			; $4291

@incCounter:
	inc (hl)		; $4292

@normalFlags:
	ld l,SpecialObject.oamFlagsBackup		; $4293
	ldi a,(hl)		; $4295
	ld (hl),a		; $4296
	ret			; $4297

;;
; Updates wActiveTileIndex, wActiveTileType, and wLastActiveTileType.
;
; NOTE: wLastActiveTileType actually keeps track of the tile BELOW Link when in
; a sidescrolling section.
;
; @addr{4298}
_sidescrollUpdateActiveTile:
	call objectGetTileAtPosition		; $4298
	ld (wActiveTileIndex),a		; $429b

	ld hl,tileTypesTable		; $429e
	call lookupCollisionTable		; $42a1
	ld (wActiveTileType),a		; $42a4

	ld bc,$0800		; $42a7
	call objectGetRelativeTile		; $42aa
	ld hl,tileTypesTable		; $42ad
	call lookupCollisionTable		; $42b0
	ld (wLastActiveTileType),a		; $42b3
	ret			; $42b6

;;
; Does various things based on the tile type of the tile Link is standing on (see
; constants/tileTypes.s).
;
; @param	d	Link object
; @addr{42b7}
_linkApplyTileTypes:
	xor a			; $42b7
	ld (wIsTileSlippery),a		; $42b8
	ld a,(wLinkInAir)		; $42bb
	or a			; $42be
	jp nz,@tileType_normal		; $42bf

.ifdef ROM_AGES
	ld (wLinkRaisedFloorOffset),a		; $42c2
.endif
	call @linkGetActiveTileType		; $42c5

	ld (wActiveTileType),a		; $42c8
	rst_jumpTable			; $42cb
	.dw @tileType_normal ; TILETYPE_NORMAL
	.dw @tileType_hole ; TILETYPE_HOLE
	.dw @tileType_warpHole ; TILETYPE_WARPHOLE
	.dw @tileType_crackedFloor ; TILETYPE_CRACKEDFLOOR
	.dw @tileType_vines ; TILETYPE_VINES
	.dw @notSwimming ; TILETYPE_GRASS
	.dw @notSwimming ; TILETYPE_STAIRS
	.dw @swimming ; TILETYPE_WATER
	.dw @tileType_stump ; TILETYPE_STUMP
	.dw @tileType_conveyor ; TILETYPE_UPCONVEYOR
	.dw @tileType_conveyor ; TILETYPE_RIGHTCONVEYOR
	.dw @tileType_conveyor ; TILETYPE_DOWNCONVEYOR
	.dw @tileType_conveyor ; TILETYPE_LEFTCONVEYOR
	.dw _dealSpikeDamageToLink ; TILETYPE_SPIKE
	.dw @tileType_cracked_ice ; TILETYPE_CRACKED_ICE
	.dw @tileType_ice ; TILETYPE_ICE
	.dw @tileType_lava ; TILETYPE_LAVA
	.dw @tileType_puddle ; TILETYPE_PUDDLE
	.dw @tileType_current ; TILETYPE_UPCURRENT
	.dw @tileType_current ; TILETYPE_RIGHTCURRENT
	.dw @tileType_current ; TILETYPE_DOWNCURRENT
	.dw @tileType_current ; TILETYPE_LEFTCURRENT
.ifdef ROM_AGES
	.dw @tiletype_raisableFloor ; TILETYPE_RAISABLE_FLOOR
	.dw @swimming ; TILETYPE_SEAWATER
	.dw @swimming ; TILETYPE_WHIRLPOOL

@tiletype_raisableFloor:
	ld a,-3		; $42fe
	ld (wLinkRaisedFloorOffset),a		; $4300
.endif

@tileType_normal:
	xor a			; $4303
	ld (wActiveTileType),a		; $4304
	ld (wStandingOnTileCounter),a		; $4307
	ld (wLinkSwimmingState),a		; $430a
	ret			; $430d

@tileType_puddle:
	ld h,d			; $430e
	ld l,SpecialObject.animParameter		; $430f
	bit 5,(hl)		; $4311
	jr z,@tileType_normal	; $4313

	res 5,(hl)		; $4315
	ld a,(wLinkImmobilized)		; $4317
	or a			; $431a
	ld a,SND_SPLASH		; $431b
	call z,playSound		; $431d
	jr @tileType_normal		; $4320

@tileType_stump:
	ld h,d			; $4322
	ld l,SpecialObject.adjacentWallsBitset		; $4323
	ld (hl),$ff		; $4325
	ld l,SpecialObject.collisionType		; $4327
	res 7,(hl)		; $4329
	jr @notSwimming		; $432b

@tileType_vines:
	call dropLinkHeldItem		; $432d
	ld a,$ff		; $4330
	ld (wLinkClimbingVine),a		; $4332

@notSwimming:
	xor a			; $4335
	ld (wLinkSwimmingState),a		; $4336
	ret			; $4339

@tileType_crackedFloor:
	ld a,ROCS_RING		; $433a
	call cpActiveRing		; $433c
	jr z,@tileType_normal	; $433f

	; Don't break the floor until Link has stood there for 32 frames
	ld a,(wStandingOnTileCounter)		; $4341
	cp 32			; $4344
	jr c,@notSwimming	; $4346

	ld a,(wActiveTilePos)		; $4348
	ld c,a			; $434b
	ld a,TILEINDEX_HOLE		; $434c
	call breakCrackedFloor		; $434e
	xor a			; $4351
	ld (wStandingOnTileCounter),a		; $4352

@tileType_hole:
@tileType_warpHole:
.ifdef ROM_AGES
	ld a,(wTilesetFlags)		; $4355
	and TILESETFLAG_UNDERWATER			; $4358
	jr nz,@tileType_normal	; $435a
.endif

	xor a			; $435c
	ld (wLinkSwimmingState),a		; $435d

	ld a,(wLinkRidingObject)		; $4360
	or a			; $4363
	jr nz,@tileType_normal	; $4364

	ld a,(wMagnetGloveState)		; $4366
	bit 6,a			; $4369
	jr nz,@tileType_normal	; $436b

	; Jump if tile type has changed
	ld hl,wLastActiveTileType		; $436d
	ldd a,(hl)		; $4370
	cp (hl)			; $4371
	jr nz,++		; $4372

	; Jump if Link's position has not changed
	ld l,<wActiveTilePos		; $4374
	ldi a,(hl)		; $4376
	cp b			; $4377
	jr z,++			; $4378

	; [wStandingOnTileCounter] = $0e
	inc l			; $437a
	ld a,$0e		; $437b
	ld (hl),a		; $437d
++
	ld a,$80		; $437e
	ld (wcc92),a		; $4380
	jp _linkPullIntoHole		; $4383

@tileType_ice:
	ld a,SNOWSHOE_RING		; $4386
	call cpActiveRing		; $4388
	jr z,@notSwimming	; $438b

	ld hl,wIsTileSlippery		; $438d
	set 6,(hl)		; $4390
	jr @notSwimming		; $4392

@tileType_cracked_ice:
.ifdef ROM_AGES
	ret			; $4394
.else
	ld a,(wStandingOnTileCounter)		; $433d
	cp $20			; $4340
	jr c,@tileType_ice	; $4342
	ld a,(wActiveTilePos)		; $4344
	ld c,a			; $4347
	ld a,$fd		; $4348
	call setTile		; $434a
.endif

@swimming:
	ld a,(wLinkRidingObject)		; $4395
	or a			; $4398
	jp nz,@tileType_normal		; $4399

	; Run the below code only the moment he gets into the water
	ld a,(wLinkSwimmingState)		; $439c
	or a			; $439f
	ret nz			; $43a0

.ifdef ROM_AGES
	ld a,(w1Link.var2f)		; $43a1
	bit 7,a			; $43a4
	ret nz			; $43a6
.endif

	xor a			; $43a7
	ld e,SpecialObject.var35		; $43a8
	ld (de),a		; $43aa
	ld e,SpecialObject.knockbackCounter		; $43ab
	ld (de),a		; $43ad

	inc a			; $43ae
	ld (wLinkSwimmingState),a		; $43af

	ld a,$80		; $43b2
	ld (wcc92),a		; $43b4
	ret			; $43b7

@tileType_lava:
.ifdef ROM_AGES
	ld a,(wLinkRidingObject)		; $43b8
	or a			; $43bb
.else
	ld a,(wMagnetGloveState)
	bit 6,a
.endif
	jp nz,@tileType_normal		; $43bc

	ld a,$80		; $43bf
	ld (wcc92),a		; $43c1

	ld e,SpecialObject.knockbackCounter		; $43c4
	xor a			; $43c6
	ld (de),a		; $43c7

	ld a,(wLinkSwimmingState)		; $43c8
	or a			; $43cb
	ret nz			; $43cc

	xor a			; $43cd
	ld e,SpecialObject.var35		; $43ce
	ld (de),a		; $43d0

	ld a,$41		; $43d1
	ld (wLinkSwimmingState),a		; $43d3
	ret			; $43d6

@tileType_conveyor:
	ld a,(wLinkRidingObject)		; $43d7
	or a			; $43da
	jp nz,@tileType_normal		; $43db

	ld a,QUICKSAND_RING		; $43de
	call cpActiveRing		; $43e0
	jp z,@tileType_normal		; $43e3

	ldbc SPEED_80, TILETYPE_UPCONVEYOR		; $43e6

@adjustLinkOnConveyor:
	ld a,$01		; $43e9
	ld (wcc92),a		; $43eb

	; Get angle to move link in c
	ld a,(wActiveTileType)		; $43ee
	sub c			; $43f1
	ld hl,@conveyorAngles		; $43f2
	rst_addAToHl			; $43f5
	ld c,(hl)		; $43f6

	jp specialObjectUpdatePositionGivenVelocity		; $43f7

@conveyorAngles:
	.db $00 $08 $10 $18

@tileType_current:
	ldbc SPEED_c0, TILETYPE_UPCURRENT		; $43fe
	call @adjustLinkOnConveyor		; $4401
	jr @swimming		; $4404

;;
; Gets the tile type of the tile link is standing on (see constants/tileTypes.s).
; Also updates wActiveTilePos, wActiveTileIndex and wLastActiveTileType, but not
; wActiveTileType.
;
; @param	d	Link object
; @param[out]	a	Tile type
; @param[out]	b	Former value of wActiveTilePos
; @addr{4406}
@linkGetActiveTileType:
	ld bc,$0500		; $4406
	call objectGetRelativeTile		; $4409
	ld c,a			; $440c
	ld b,l			; $440d
	ld hl,wActiveTilePos		; $440e
	ldi a,(hl)		; $4411
	cp b			; $4412
	jr nz,+			; $4413

	ld a,(hl)		; $4415
	cp c			; $4416
	jr z,++			; $4417
+
	; Update wActiveTilePos
	ld l,<wActiveTilePos		; $4419
	ld a,(hl)		; $441b
	ld (hl),b		; $441c
	ld b,a			; $441d

	; Update wActiveTileIndex
	inc l			; $441e
	ld (hl),c		; $441f

	; Write $00 to wStandingOnTileCounter
	inc l			; $4420
	ld (hl),$00		; $4421
++
	ld l,<wStandingOnTileCounter		; $4423
	inc (hl)		; $4425

	; Copy wActiveTileType to wLastActiveTileType
	inc l			; $4426
	ldi a,(hl)		; $4427
	ld (hl),a		; $4428

	ld a,c			; $4429
	ld hl,tileTypesTable		; $442a
	jp lookupCollisionTable		; $442d

;;
; Same as below, but operates on SpecialObject.angle, not a given variable.
; @addr{4430}
_linkAdjustAngleInSidescrollingArea:
	ld l,SpecialObject.angle		; $4430

;;
; Adjusts Link's angle in sidescrolling areas when not on a staircase.
; This results in Link only moving in horizontal directions.
;
; @param	l	Angle variable to use
; @addr{4432}
_linkAdjustGivenAngleInSidescrollingArea:
	ld h,d			; $4432
	ld e,l			; $4433

	ld a,(wTilesetFlags)		; $4434
	and TILESETFLAG_SIDESCROLL			; $4437
	ret z			; $4439

	; Return if angle value >= $80
	bit 7,(hl)		; $443a
	ret nz			; $443c

	ld a,(hl)		; $443d
	ld hl,@horizontalAngleTable		; $443e
	rst_addAToHl			; $4441
	ld a,(hl)		; $4442
	ld (de),a		; $4443
	ret			; $4444

; This table converts an angle value such that it becomes purely horizontal.
@horizontalAngleTable:
	.db $ff $08 $08 $08 $08 $08 $08 $08
	.db $08 $08 $08 $08 $08 $08 $08 $08
	.db $ff $18 $18 $18 $18 $18 $18 $18
	.db $18 $18 $18 $18 $18 $18 $18 $18

;;
; Prevents link from passing object d.
;
; @param	d	The object that Link shall not pass.
; @addr{4465}
_companionPreventLinkFromPassing_noExtraChecks:
	ld hl,w1Link		; $4465
	jp preventObjectHFromPassingObjectD		; $4468

;;
; @addr{446b}
_companionUpdateMovement:
	call _companionCalculateAdjacentWallsBitset		; $446b
	call specialObjectUpdatePosition		; $446e

	; Don't attempt to break tile on ground if in midair
	ld h,d			; $4471
	ld l,SpecialObject.zh		; $4472
	ld a,(hl)		; $4474
	or a			; $4475
	ret nz			; $4476

;;
; Calculate position of the tile beneath the companion's feet, to see if it can be broken
; (just by walking on it)
; @addr{4477}
_companionTryToBreakTileFromMoving:
	ld h,d			; $4477
	ld l,SpecialObject.yh		; $4478
	ld a,(hl)		; $447a
	add $05			; $447b
	ld b,a			; $447d
	ld l,SpecialObject.xh		; $447e
	ld c,(hl)		; $4480

	ld a,BREAKABLETILESOURCE_13		; $4481
	jp tryToBreakTile		; $4483

;;
; @param	d	Special object
; @addr{4486}
_companionCalculateAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset		; $4486
	xor a			; $4488
	ld (de),a		; $4489
	ld h,d			; $448a
	ld l,SpecialObject.yh		; $448b
	ld b,(hl)		; $448d
	ld l,SpecialObject.xh		; $448e
	ld c,(hl)		; $4490

	ld a,$01		; $4491
	ldh (<hFF8B),a	; $4493
	ld hl,@offsets		; $4495
--
	ldi a,(hl)		; $4498
	add b			; $4499
	ld b,a			; $449a
	ldi a,(hl)		; $449b
	add c			; $449c
	ld c,a			; $449d
	push hl			; $449e
	call _checkCollisionForCompanion		; $449f
	pop hl			; $44a2
	ldh a,(<hFF8B)	; $44a3
	rla			; $44a5
	ldh (<hFF8B),a	; $44a6
	jr nc,--		; $44a8

	ld e,SpecialObject.adjacentWallsBitset		; $44aa
	ld (de),a		; $44ac
	ret			; $44ad

@offsets:
	.db $fb $fd
	.db $00 $07
	.db $0d $f9
	.db $00 $07
	.db $f5 $f7
	.db $09 $00
	.db $f7 $0b
	.db $09 $00

;;
; @param	bc	Position to check
; @param	d	A special object (should be a companion?)
; @param[out]	cflag	Set if a collision happened
; @addr{44be}
_checkCollisionForCompanion:
	; Animals can't pass through climbable vines
	call getTileAtPosition		; $44be
	ld a,(hl)		; $44c1
	cp TILEINDEX_VINE_BOTTOM			; $44c2
	jr z,@setCollision	; $44c4
	cp TILEINDEX_VINE_MIDDLE			; $44c6
	jr z,@setCollision	; $44c8

	; Check for collision on bottom half of this tile only
	cp TILEINDEX_VINE_TOP			; $44ca
	ld a,$03		; $44cc
	jp z,checkGivenCollision_allowHoles		; $44ce

	ld e,SpecialObject.id		; $44d1
	ld a,(de)		; $44d3
	cp SPECIALOBJECTID_RICKY			; $44d4
	jr nz,@notRicky		; $44d6

	; This condition appears to have no effect either way?
	ld e,SpecialObject.zh		; $44d8
	ld a,(de)		; $44da
	bit 7,a			; $44db
	jr z,@checkCollision	; $44dd
	ld a,(hl)		; $44df
.ifdef ROM_SEASONS
	; tiles that are half-floor/half-cliff?
	cp $d9			; $4493
	ret z			; $4495
	cp $da			; $4496
	ret z			; $4498
.endif
	jr @checkCollision		; $44e0

@notRicky:
	cp SPECIALOBJECTID_DIMITRI			; $44e2
	jr nz,@checkCollision	; $44e4
	ld a,(hl)		; $44e6
	cp SPECIALCOLLISION_fe			; $44e7
	ret nc			; $44e9
	jr @checkCollision		; $44ea

@setCollision:
	scf			; $44ec
	ret			; $44ed

@checkCollision:
	jp checkCollisionPosition_disallowSmallBridges		; $44ee

;;
; @param	d	Special object
; @param	hl	Table which takes object's direction as an index
; @param[out]	a	Collision value of tile at object's position + offset
; @param[out]	b	Tile index at object's position + offset
; @param[out]	hl	Address of collision value
; @addr{44f1}
_specialObjectGetRelativeTileWithDirectionTable:
	ld e,SpecialObject.direction		; $44f1
	ld a,(de)		; $44f3
	rst_addDoubleIndex			; $44f4

;;
; @param	d	Special object
; @param	hl	Address of Y/X offsets to use relative to object
; @param[out]	a	Collision value of tile at object's position + offset
; @param[out]	b	Tile index at object's position + offset
; @param[out]	hl	Address of collision value
; @addr{44f5}
_specialObjectGetRelativeTileFromHl:
	ldi a,(hl)		; $44f5
	ld b,a			; $44f6
	ld c,(hl)		; $44f7
	call objectGetRelativeTile		; $44f8
	ld b,a			; $44fb
	ld h,>wRoomCollisions		; $44fc
	ld a,(hl)		; $44fe
	ret			; $44ff

;;
; @param[out]	zflag	nz if an object is moving away from a wall
; @addr{4500}
_specialObjectCheckMovingAwayFromWall:
	; Check that the object is trying to move
	ld h,d			; $4500
	ld l,SpecialObject.angle		; $4501
	ld a,(hl)		; $4503
	cp $ff			; $4504
	ret z			; $4506

	; Invert angle
	add $10			; $4507
	and $1f			; $4509
	ld (hl),a		; $450b

	call _specialObjectCheckFacingWall		; $450c
	ld c,a			; $450f

	; Uninvert angle
	ld l,SpecialObject.angle		; $4510
	ld a,(hl)		; $4512
	add $10			; $4513
	and $1f			; $4515
	ld (hl),a		; $4517

	ld a,c			; $4518
	or a			; $4519
	ret			; $451a

;;
; Checks if an object is directly against a wall and trying to move toward it
;
; @param	d	Special object
; @param[out]	a	The bits from adjacentWallsBitset corresponding to the direction
;			it's moving in
; @param[out]	zflag	nz if an object is moving toward a wall
; @addr{451b}
_specialObjectCheckMovingTowardWall:
	; Check that the object is trying to move
	ld h,d			; $451b
	ld l,SpecialObject.angle		; $451c
	ld a,(hl)		; $451e
	cp $ff			; $451f
	ret z			; $4521

;;
; @param	a	Should equal object's angle value
; @param	h	Special object
; @param[out]	a	The bits from adjacentWallsBitset corresponding to the direction
;			it's moving in
; @addr{4522}
_specialObjectCheckFacingWall:
	ld bc,$0000		; $4522

	; Check if straight left or right
	cp $08			; $4525
	jr z,@checkVertical	; $4527
	cp $18			; $4529
	jr z,@checkVertical	; $452b

	ld l,SpecialObject.adjacentWallsBitset		; $452d
	ld b,(hl)		; $452f
	add a			; $4530
	swap a			; $4531
	and $03
	ld a,$30		; $4535
	jr nz,+			; $4537
	ld a,$c0		; $4539
+
	and b			; $453b
	ld b,a			; $453c

@checkVertical:
	; Check if straight up or down
	ld l,SpecialObject.angle		; $453d
	ld a,(hl)		; $453f
	and $0f			; $4540
	jr z,@ret		; $4542

	ld a,(hl)		; $4544
	ld l,SpecialObject.adjacentWallsBitset		; $4545
	ld c,(hl)		; $4547
	bit 4,a ; Check if angle is to the left
	ld a,$03		; $454a
	jr z,+			; $454c
	ld a,$0c		; $454e
+
	and c			; $4550
	ld c,a			; $4551

@ret:
	ld a,b			; $4552
	or c			; $4553
	ret			; $4554

;;
; Create an item which deals damage 7.
;
; @param	bc	Item ID
; @addr{4555}
_companionCreateItem:
	call getFreeItemSlot		; $4555
	ret nz			; $4558
	jr ++			; $4559

;;
; Create the weapon item which deals damage 7.
;
; @param	bc	Item ID
; @addr{455b}
_companionCreateWeaponItem:
	ld hl,w1WeaponItem.enabled		; $455b
	ld a,(hl)		; $455e
	or a			; $455f
	ret nz			; $4560
++
	inc (hl)		; $4561
	inc l			; $4562
	ld (hl),b		; $4563
	inc l			; $4564
	ld (hl),c		; $4565
	ld l,Item.damage		; $4566
	ld (hl),-7		; $4568
	xor a			; $456a
	ret			; $456b

;;
; Animates a companion, also checks whether the animation needs to change based on
; direction.
;
; @param	c	Base animation index?
; @addr{456c}
_companionUpdateDirectionAndAnimate:
	ld e,SpecialObject.direction		; $456c
	ld a,(de)		; $456e
	ld (w1Link.direction),a		; $456f
	ld e,SpecialObject.state		; $4572
	ld a,(de)		; $4574
	cp $0c			; $4575
	jp z,specialObjectAnimate		; $4577

	call updateLinkDirectionFromAngle		; $457a
	ld hl,w1Companion.direction		; $457d
	cp (hl)			; $4580
	jp z,specialObjectAnimate		; $4581

;;
; Same as below, but updates the companion's direction based on its angle first?
;
; @param	c	Base animation index?
; @addr{4584}
_companionUpdateDirectionAndSetAnimation:
	ld e,SpecialObject.angle		; $4584
	ld a,(de)		; $4586
	add a			; $4587
	swap a			; $4588
	and $03			; $458a
	dec e			; $458c
	ld (de),a		; $458d

;;
; @param	c	Base animation index? (Added with direction, var38)
; @addr{458e}
_companionSetAnimation:
	ld h,d			; $458e
	ld a,c			; $458f
	ld l,SpecialObject.direction		; $4590
	add (hl)		; $4592
	ld l,SpecialObject.var38		; $4593
	add (hl)		; $4595
	jp specialObjectSetAnimation		; $4596

;;
; Relates to mounting a companion?
;
; @param[out]	zflag	Set if mounted successfully?
; @addr{4599}
_companionTryToMount:
	ld a,(wActiveTileType)		; $4599
	cp TILETYPE_HOLE			; $459c
	jr z,@cantMount	; $459e
.ifdef ROM_AGES
	ld a,(wDisallowMountingCompanion)		; $45a0
	or a			; $45a3
	jr nz,@cantMount	; $45a4

	call checkLinkVulnerableAndIDZero		; $45a6
.else
	call checkLinkID0AndControlNormal		; $4559
.endif
	jr c,@tryMounting	; $45a9

@cantMount:
	or d			; $45ab
	ret			; $45ac

@tryMounting:
	ld a,(w1Link.state)		; $45ad
	cp LINK_STATE_NORMAL			; $45b0
	ret nz			; $45b2
	ld a,(wLinkSwimmingState)		; $45b3
	or a			; $45b6
	ret nz			; $45b7
	ld a,(wLinkGrabState)		; $45b8
	or a			; $45bb
	ret nz			; $45bc
	ld a,(wLinkInAir)		; $45bd
	or a			; $45c0
	ret nz			; $45c1

	; Link can mount the companion. Set up all variables accordingly.

	inc a			; $45c2
	ld (wcc90),a		; $45c3
	ld (wWarpsDisabled),a		; $45c6
	ld e,SpecialObject.state		; $45c9
	ld a,$03		; $45cb
	ld (de),a		; $45cd

	ld a,$ff		; $45ce

;;
; Sets Link's speed and speedZ to be the values needed for mounting or dismounting
; a companion.
;
; @param	a	Link's angle
; @addr{45d0}
_setLinkMountingSpeed:
	ld (wLinkAngle),a		; $45d0
	ld a,$81		; $45d3
	ld (wLinkInAir),a		; $45d5
	ld (wDisableScreenTransitions),a		; $45d8
	ld hl,w1Link.angle		; $45db
	ld (hl),a		; $45de

	ld l,<w1Link.speed		; $45df
	ld (hl),SPEED_80		; $45e1

	ld l,<w1Link.speedZ		; $45e3
	ld (hl),$40		; $45e5
	inc l			; $45e7
	ld (hl),$fe		; $45e8
	xor a			; $45ea
	ret			; $45eb

;;
; @param[out]	a	Hazard type (see "objectCheckIsOnHazard")
; @param[out]	cflag	Set if the companion is on a hazard
; @addr{45ec}
_companionCheckHazards:
	call objectCheckIsOnHazard		; $45ec
	ld h,d			; $45ef
	ret nc			; $45f0

;;
; Sets a companion's state to 4, which handles falling in a hazard.
; @addr{45f1}
_companionGotoHazardHandlingState:
	push af			; $45f1
	ld l,SpecialObject.state		; $45f2
	ld a,$04		; $45f4
	ldi (hl),a		; $45f6
	xor a			; $45f7
	ldi (hl),a ; [state2] = 0
	ldi (hl),a ; [counter1] = 0

	ld l,SpecialObject.id		; $45fa
	ld a,(hl)		; $45fc
	cp SPECIALOBJECTID_DIMITRI			; $45fd
	jr z,@ret	; $45ff
	ld (wDisableScreenTransitions),a		; $4601
	ld a,SND_SPLASH		; $4604
	call playSound		; $4606
@ret:
	pop af			; $4609
	scf			; $460a
	ret			; $460b

;;
; @addr{460c}
companionDismountAndSavePosition:
	call companionDismount		; $460c

	; The below code checks your animal companion, but ultimately appears to do the
	; same thing in all cases.

	ld e,SpecialObject.id		; $460f
	ld a,(de)		; $4611
	ld hl,wAnimalCompanion		; $4612
	cp (hl)			; $4615
	jr z,@normalDismount	; $4616

	cp SPECIALOBJECTID_RICKY			; $4618
	jr z,@ricky		; $461a
	cp SPECIALOBJECTID_DIMITRI			; $461c
	jr z,@dimitri		; $461e
.ifdef ROM_AGES
@moosh:
	jr @normalDismount		; $4620
@ricky:
	jr @normalDismount		; $4622
@dimitri:
	jr @normalDismount		; $4624
.else
@moosh:
	ld a,(wEssencesObtained)		; $45d3
	bit 4,a			; $45d6
	jr z,@normalDismount	; $45d8
	jr +		; $45da
@ricky:
	ld a,(wFluteIcon)		; $45dc
	or a			; $45df
	jr z,@normalDismount	; $45e0
	jr +		; $45e2
@dimitri:
	ld a,TREASURE_FLIPPERS		; $45e4
	call checkTreasureObtained		; $45e6
	jr nc,@normalDismount	; $45e9
+
.endif
	; Seasons-only (dismount and don't save companion's position)
	call saveLinkLocalRespawnAndCompanionPosition		; $4626
	xor a			; $4629
	ld (wRememberedCompanionId),a		; $462a
	ret			; $462d

@normalDismount:
	jr saveLinkLocalRespawnAndCompanionPosition		; $462e

;;
; Called when dismounting an animal companion
;
; @addr{4630}
companionDismount:
	lda SPECIALOBJECTID_LINK			; $4630
	call setLinkID		; $4631
	ld hl,w1Link.oamFlagsBackup		; $4634
	ldi a,(hl)		; $4637
	ldd (hl),a		; $4638

	ld h,d			; $4639
	ldi a,(hl)		; $463a
	ld (hl),a		; $463b

	xor a			; $463c
	ld l,SpecialObject.damageToApply		; $463d
	ld (hl),a		; $463f

	; Clear invincibilityCounter, knockbackAngle, knockbackCounter
	ld l,SpecialObject.invincibilityCounter		; $4640
	ldi (hl),a		; $4642
	ldi (hl),a		; $4643
	ld (hl),a		; $4644

	ld l,SpecialObject.var3c		; $4645
	ld (hl),a		; $4647

	ld (wLinkForceState),a		; $4648
	ld (wcc50),a		; $464b

	ld l,SpecialObject.enabled		; $464e
	ld (hl),$01		; $4650

	; Calculate angle based on direction
	ld l,SpecialObject.direction		; $4652
	ldi a,(hl)		; $4654
	swap a			; $4655
	srl a			; $4657
	ld (hl),a		; $4659

	call _setLinkMountingSpeed		; $465a

	ld hl,w1Link.angle		; $465d
	ld (hl),$ff		; $4660

	call objectCopyPosition		; $4662

	; Set w1Link.zh to $f8
	dec l			; $4665
	ld (hl),$f8		; $4666

	; Set wLinkObjectIndex to $d0 (no longer riding an animal)
	ld a,h			; $4668
	ld (wLinkObjectIndex),a		; $4669

	xor a			; $466c
	ld (wcc90),a		; $466d
	ld (wWarpsDisabled),a		; $4670
	ld (wForceCompanionDismount),a		; $4673
	ld (wDisableScreenTransitions),a		; $4676
	jp setCameraFocusedObjectToLink		; $4679

;;
; @addr{467c}
saveLinkLocalRespawnAndCompanionPosition:
	ld hl,wRememberedCompanionId		; $467c
	ld a,(w1Companion.id)		; $467f
	ldi (hl),a		; $4682

	ld a,(wActiveGroup)		; $4683
	ldi (hl),a		; $4686
	ld a,(wActiveRoom)		; $4687
	ldi (hl),a		; $468a

	ld a,(w1Companion.direction)		; $468b
	ld (wLinkLocalRespawnDir),a		; $468e

	ld a,(w1Companion.yh)		; $4691
	ldi (hl),a		; $4694
	ld (wLinkLocalRespawnY),a		; $4695

	ld a,(w1Companion.xh)		; $4698
	ldi (hl),a		; $469b
	ld (wLinkLocalRespawnX),a		; $469c
	ret			; $469f

;;
; @param[out]	zflag	Set if the companion has reached the center of the hole
; @addr{46a0}
_companionDragToCenterOfHole:
	ld e,SpecialObject.var3d		; $46a0
	ld a,(de)		; $46a2
	or a			; $46a3
	jr z,+			; $46a4
	xor a			; $46a6
	ret			; $46a7
+
	; Get the center of the hole tile in bc
	ld bc,$0500		; $46a8
	call objectGetRelativeTile		; $46ab
	ld c,l			; $46ae
	call convertShortToLongPosition_paramC		; $46af

	; Now drag the companion's X and Y values toward the hole by $40 subpixels per
	; frame (for X and Y).
@adjustX:
	ld e,SpecialObject.xh		; $46b2
	ld a,(de)		; $46b4
	cp c			; $46b5
	ld c,$00		; $46b6
	jr z,@adjustY		; $46b8

	ld hl, $40		; $46ba
	jr c,+			; $46bd
	ld hl,-$40		; $46bf
+
	; [SpecialObject.x] += hl
	dec e			; $46c2
	ld a,(de)		; $46c3
	add l			; $46c4
	ld (de),a		; $46c5
	inc e			; $46c6
	ld a,(de)		; $46c7
	adc h			; $46c8
	ld (de),a		; $46c9

	dec c			; $46ca

@adjustY:
	ld e,SpecialObject.yh		; $46cb
	ld a,(de)		; $46cd
	cp b			; $46ce
	jr z,@return		; $46cf

	ld hl, $40		; $46d1
	jr c,+			; $46d4
	ld hl,-$40		; $46d6
+
	; [SpecialObject.y] += hl
	dec e			; $46d9
	ld a,(de)		; $46da
	add l			; $46db
	ld (de),a		; $46dc
	inc e			; $46dd
	ld a,(de)		; $46de
	adc h			; $46df
	ld (de),a		; $46e0

	dec c			; $46e1

@return:
	ld h,d			; $46e2
	ld a,c			; $46e3
	or a			; $46e4
	ret			; $46e5

;;
; @addr{46e6}
_companionRespawn:
	xor a			; $46e6
	ld (wDisableScreenTransitions),a		; $46e7
	ld (wLinkForceState),a		; $46ea
	ld (wcc50),a		; $46ed

	; Set animal's position to respawn point, then check if the position is valid
	call specialObjectSetCoordinatesToRespawnYX		; $46f0
.ifdef ROM_SEASONS
	ld bc,$0500		; $46b8
	call objectGetRelativeTile		; $46bb
	cp $20			; $46be
	jr nz,+			; $46c0
	ld h,d			; $46c2
	ld l,SpecialObject.yh		; $46c3
	ld a,(wRememberedCompanionY)		; $46c5
	ldi (hl),a		; $46c8
	inc l			; $46c9
	ld a,(wRememberedCompanionX)		; $46ca
	ldi (hl),a		; $46cd
+
.endif
	call objectCheckSimpleCollision		; $46f3
	jr nz,@invalidPosition		; $46f6

	call objectGetPosition		; $46f8
	call _checkCollisionForCompanion		; $46fb
	jr c,@invalidPosition	; $46fe

	call objectCheckIsOnHazard		; $4700
	jr nc,@applyDamageAndSetState	; $4703

@invalidPosition:
	; Current position is invalid, so change respawn to the last animal mount point
	ld h,d			; $4705
	ld l,SpecialObject.yh		; $4706
	ld a,(wLastAnimalMountPointY)		; $4708
	ld (wLinkLocalRespawnY),a		; $470b
	ldi (hl),a		; $470e
	inc l			; $470f
	ld a,(wLastAnimalMountPointX)		; $4710
	ld (wLinkLocalRespawnX),a		; $4713
	ldi (hl),a		; $4716

@applyDamageAndSetState:
	; Apply damage to Link only if he's on the companion
	ld a,(wLinkObjectIndex)		; $4717
	rrca			; $471a
	ld a,$01		; $471b
	jr nc,@setState	; $471d

	ld a,-2			; $471f
	ld (w1Link.damageToApply),a		; $4721
	ld a,$40		; $4724
	ld (w1Link.invincibilityCounter),a		; $4726

	ld a,$05		; $4729
@setState:
	ld h,d			; $472b
	ld l,SpecialObject.state		; $472c
	ldi (hl),a		; $472e
	xor a			; $472f
	ld (hl),a ; [state2] = 0

	ld l,SpecialObject.var3d		; $4731
	ld (hl),a		; $4733
	ld (wDisableScreenTransitions),a		; $4734

	ld l,SpecialObject.collisionType		; $4737
	res 7,(hl)		; $4739
	ret			; $473b

;;
; Checks if a companion's moving toward a cliff from the top, to hop down if so.
;
; @param[out]	zflag	Set if the companion should hop down a cliff
; @addr{473c}
_companionCheckHopDownCliff:
	; Make sure we're not moving at an angle
	ld a,(wLinkAngle)		; $473c
	ld c,a			; $473f
	and $e7			; $4740
	ret nz			; $4742

	; Check that the companion's angle equals Link's angle?
	ld e,SpecialObject.angle		; $4743
	ld a,(de)		; $4745
	cp c			; $4746
	ret nz			; $4747

	call _specialObjectCheckMovingTowardWall		; $4748
	cp $03  ; Wall to the right?
	jr z,++			; $474d
	cp $0c  ; Wall to the left?
	jr z,++			; $4751
	cp $30  ; Wall below?
	ret nz			; $4755
++
	; Get offset from companion's position for tile to check
	ld e,SpecialObject.direction		; $4756
	ld a,(de)		; $4758
	ld hl,@directionOffsets		; $4759
	rst_addDoubleIndex			; $475c
	ldi a,(hl)		; $475d
	ld b,a			; $475e
	ld c,(hl)		; $475f

	call objectGetRelativeTile		; $4760
	cp TILEINDEX_VINE_TOP			; $4763
	jr z,@vineTop		; $4765

	ld hl,cliffTilesTable		; $4767
	call lookupCollisionTable		; $476a
	jr c,@cliffTile		; $476d

	or d			; $476f
	ret			; $4770

@vineTop:
	ld a,$10		; $4771

@cliffTile:
	; 'a' should contain the desired angle to be moving in
	ld h,d			; $4773
	ld l,SpecialObject.angle		; $4774
	cp (hl)			; $4776
	ret nz			; $4777

	; Initiate hopping down

	ld a,$80		; $4778
	ld (wLinkInAir),a		; $477a
	ld bc,-$2c0		; $477d
	call objectSetSpeedZ		; $4780

	ld l,SpecialObject.speed		; $4783
	ld (hl),SPEED_200		; $4785
	ld l,SpecialObject.counter1		; $4787
	ld a,$14		; $4789
	ldi (hl),a		; $478b
	xor a			; $478c
	ld (hl),a ; [counter2] = 0

	ld l,SpecialObject.state		; $478e
	ld a,$07		; $4790
	ldi (hl),a		; $4792
	xor a			; $4793
	ld (hl),a ; [state2] = 0
	ret			; $4795


@directionOffsets:
	.db $fa $00 ; DIR_UP
	.db $00 $04 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $fb ; DIR_LEFT

;;
; Sets a bunch of variables the moment Link completes the mounting animation.
; @addr{479e}
_companionFinalizeMounting:
	ld h,d			; $479e
	ld l,SpecialObject.enabled		; $479f
	set 1,(hl)		; $47a1

	ld l,SpecialObject.state		; $47a3
	ld (hl),$05		; $47a5

	ld l,SpecialObject.angle		; $47a7
	ld a,$ff		; $47a9
	ld (hl),a		; $47ab
	ld l,SpecialObject.var3c		; $47ac
	ld (hl),a		; $47ae

	; Give companion draw priority 1
	ld l,SpecialObject.visible		; $47af
	ld a,(hl)		; $47b1
	and $c0			; $47b2
	or $01			; $47b4
	ld (hl),a		; $47b6

	xor a			; $47b7
	ld l,SpecialObject.var3d		; $47b8
	ld (hl),a		; $47ba
	ld (wLinkInAir),a		; $47bb
	ld (wDisableScreenTransitions),a		; $47be

	ld bc,wLastAnimalMountPointY		; $47c1
	ld l,SpecialObject.yh		; $47c4
	ldi a,(hl)		; $47c6
	ld (bc),a		; $47c7
	inc c			; $47c8
	inc l			; $47c9
	ld a,(hl)		; $47ca
	ld (bc),a		; $47cb

	ld a,d			; $47cc
	ld (wLinkObjectIndex),a		; $47cd
	call setCameraFocusedObjectToLink		; $47d0
	ld a,SPECIALOBJECTID_LINK_RIDING_ANIMAL		; $47d3
	jp setLinkID		; $47d5

;;
; Something to do with dismounting companions?
;
; @param[out]	zflag
; @addr{47d8}
_companionFunc_47d8:
	ld h,d			; $47d8
	ld l,SpecialObject.var3c		; $47d9
	ld a,(hl)		; $47db
	or a			; $47dc
	ret z			; $47dd
	ld a,(wLinkDeathTrigger)		; $47de
	or a			; $47e1
	ret z			; $47e2

	xor a			; $47e3
	ld (hl),a ; [var3c] = 0
	ld e,SpecialObject.z		; $47e5
	ldi (hl),a		; $47e7
	ldi (hl),a		; $47e8

	ld l,SpecialObject.state		; $47e9
	ld (hl),$09		; $47eb
	ld e,SpecialObject.oamFlagsBackup		; $47ed
	ldi a,(hl)		; $47ef
	ld (hl),a		; $47f0
	ld e,SpecialObject.visible		; $47f1
	xor a			; $47f3
	ld (de),a		; $47f4

	; Copy Link's position to companion
	ld h,>w1Link		; $47f5
	call objectCopyPosition		; $47f7
	ld a,h			; $47fa
	ld (wLinkObjectIndex),a		; $47fb
	call setCameraFocusedObjectToLink		; $47fe
	lda SPECIALOBJECTID_LINK			; $4801
	call setLinkID		; $4802
	or d			; $4805
	ret			; $4806

;;
; @addr{4807}
_companionGotoDismountState:
	ld e,SpecialObject.var38		; $4807
	ld a,(de)		; $4809
	or a			; $480a
	jr z,+			; $480b
	xor a			; $480d
	ld (wForceCompanionDismount),a		; $480e
	ret			; $4811
+
	; Go to state 6
	ld a,$06		; $4812
	jr ++			; $4814

;;
; Sets a companion's animation and returns to state 5, substate 0 (normal movement with
; Link)
;
; @param	c	Animation
; @addr{4816}
_companionSetAnimationAndGotoState5:
	call _companionSetAnimation		; $4816
	ld a,$05		; $4819
++
	ld e,SpecialObject.state		; $481b
	ld (de),a		; $481d
	inc e			; $481e
	xor a			; $481f
	ld (de),a		; $4820
	ret			; $4821

;;
; Called on initialization of companion. Checks if its current position is ok to spawn at?
; If so, this sets the companion's state to [var03]+1.
;
; May return from caller.
;
; @addr{4822}
_companionCheckCanSpawn:
	ld e,SpecialObject.state		; $4822
	ld a,(de)		; $4824
	or a			; $4825
	jr nz,@canSpawn		; $4826

.ifdef ROM_AGES
	; Jump if [state2] != 0
	inc e			; $4828
	ld a,(de)		; $4829
	or a			; $482a
	jr nz,++		; $482b

	; Set [state2]=1, return from caller
	inc a			; $482d
	ld (de),a		; $482e
	pop af			; $482f
	ret			; $4830
++
	xor a			; $4831
	ld (de),a ; [state2] = 0

	; Delete self if there's already a solid object in its position
	call objectGetShortPosition		; $4833
	ld b,a			; $4836
	ld a,:w2SolidObjectPositions		; $4837
	ld ($ff00+R_SVBK),a	; $4839
	ld a,b			; $483b
	ld hl,w2SolidObjectPositions		; $483c
	call checkFlag		; $483f
	ld a,$00		; $4842
	ld ($ff00+R_SVBK),a	; $4844
	jr z,+			; $4846
	pop af			; $4848
	jp itemDelete		; $4849
+
.endif

	; If the tile at the animal's feet is not completely solid or a hole, it can
	; spawn here.
	ld e,SpecialObject.yh		; $484c
	ld a,(de)		; $484e
	add $05			; $484f
	ld b,a			; $4851
	ld e,SpecialObject.xh		; $4852
	ld a,(de)		; $4854
	ld c,a			; $4855
	call getTileCollisionsAtPosition		; $4856
	cp SPECIALCOLLISION_HOLE			; $4859
	jr z,+			; $485b
	cp $0f			; $485d
	jr nz,@canSpawn		; $485f
+
	; It can't spawn where it is, so try to spawn it somewhere else.
	ld hl,wLastAnimalMountPointY		; $4861
	ldi a,(hl)		; $4864
	ld e,SpecialObject.yh		; $4865
	ld (de),a		; $4867
	ld a,(hl)		; $4868
	ld e,SpecialObject.xh		; $4869
	ld (de),a		; $486b
	call objectGetTileCollisions		; $486c
	jr z,@canSpawn		; $486f
	pop af			; $4871
	jp itemDelete		; $4872

@canSpawn:
	call specialObjectSetOamVariables		; $4875

	ld hl,w1Companion.var03		; $4878
	ldi a,(hl)		; $487b
	inc a			; $487c
	ld (hl),a ; [state] = [var03]+1

	ld l,SpecialObject.collisionType		; $487e
	ld (hl),$80|ITEMCOLLISION_LINK		; $4880
	ret			; $4882

;;
; Returns from caller if the companion should not be updated right now.
;
; @addr{4883}
_companionRetIfInactive:
	; Always update when in state 0 (uninitialized)
	ld e,SpecialObject.state		; $4883
	ld a,(de)		; $4885
	or a			; $4886
	ret z			; $4887

	; Don't update when text is on-screen
	ld a,(wTextIsActive)		; $4888
	or a			; $488b
	jr nz,_companionRetIfInactiveWithoutStateCheck@ret	; $488c

;;
; @addr{488e}
_companionRetIfInactiveWithoutStateCheck:
	; Don't update when screen is scrolling, palette is fading, or wDisabledObjects is
	; set to something.
	ld a,(wScrollMode)		; $488e
	and $0e			; $4891
	jr nz,@ret	; $4893
	ld a,(wPaletteThread_mode)		; $4895
	or a			; $4898
	jr nz,@ret	; $4899
	ld a,(wDisabledObjects)		; $489b
	and (DISABLE_ALL_BUT_INTERACTIONS | DISABLE_COMPANION)			; $489e
	ret z			; $48a0
@ret:
	pop af			; $48a1
	ret			; $48a2

;;
; @addr{48a3}
_companionSetAnimationToVar3f:
	ld h,d			; $48a3
	ld l,SpecialObject.var3f		; $48a4
	ld a,(hl)		; $48a6
	ld l,SpecialObject.animMode		; $48a7
	cp (hl)			; $48a9
	jp nz,specialObjectSetAnimation		; $48aa
	ret			; $48ad

;;
; Manipulates a companion's oam flags to make it flash when charging an attack.
; @addr{48ae}
_companionFlashFromChargingAnimation:
	ld hl,w1Link.oamFlagsBackup		; $48ae
	ld a,(wFrameCounter)		; $48b1
	bit 2,a			; $48b4
	jr nz,++		; $48b6
	ldi a,(hl)		; $48b8
	and $f8			; $48b9
	or c			; $48bb
	ld (hl),a		; $48bc
	ret			; $48bd
++
	ldi a,(hl)		; $48be
	ld (hl),a		; $48bf
	ret			; $48c0

;;
; @param[out]	zflag	Set if complete
; @addr{48c1}
_companionCheckMountingComplete:
	; Check if something interrupted the mounting?
.ifdef ROM_AGES
	ld a,(wDisallowMountingCompanion)		; $48c1
	or a			; $48c4
	jr nz,@stopMounting	; $48c5
.endif
	ld a,(w1Link.state)		; $48c7
	cp LINK_STATE_NORMAL			; $48ca
	jr nz,@stopMounting	; $48cc
	ld a,(wLinkGrabState)		; $48ce
	or a			; $48d1
	jr z,@continue	; $48d2

@stopMounting:
	xor a			; $48d4
	ld (wcc90),a		; $48d5
	ld (wWarpsDisabled),a		; $48d8
	ld (wDisableScreenTransitions),a		; $48db
	ld a,$01		; $48de
	ld e,SpecialObject.state		; $48e0
	ld (de),a		; $48e2
	or d			; $48e3
	ret			; $48e4

@continue:
	ld hl,w1Link.yh		; $48e5
	ld e,SpecialObject.yh		; $48e8
	ld a,(de)		; $48ea
	cp (hl)			; $48eb
	call nz,@nudgeLinkTowardCompanion		; $48ec

	ld e,SpecialObject.xh		; $48ef
	ld l,e			; $48f1
	ld a,(de)		; $48f2
	cp (hl)			; $48f3
	call nz,@nudgeLinkTowardCompanion		; $48f4

	; Check if Link has fallen far enough down to complete the mounting animation
	ld l,<w1Link.speedZ+1		; $48f7
	bit 7,(hl)		; $48f9
	ret nz			; $48fb
	ld l,SpecialObject.zh		; $48fc
	ld a,(hl)		; $48fe
	cp $fc			; $48ff
	ret c			; $4901
	xor a			; $4902
	ret			; $4903

@nudgeLinkTowardCompanion:
	jr c,+			; $4904
	inc (hl)		; $4906
	ret			; $4907
+
	dec (hl)		; $4908
	ret			; $4909

;;
; @addr{490a}
_companionCheckEnableTerrainEffects:
	ld h,d			; $490a
	ld l,SpecialObject.enabled		; $490b
	ld a,(hl)		; $490d
	or a			; $490e
	ret z			; $490f

	ld l,SpecialObject.var3c		; $4910
	ld a,(hl)		; $4912
	ld (wWarpsDisabled),a		; $4913

	; If in midair, enable terrain effects for shadows
	ld l,SpecialObject.zh		; $4916
	ldi a,(hl)		; $4918
	bit 7,a			; $4919
	jr nz,@enableTerrainEffects	; $491b

	; If on puddle, enable terrain effects for that
	ld bc,$0500		; $491d
	call objectGetRelativeTile		; $4920
	ld h,d			; $4923
.ifdef ROM_AGES
	cp TILEINDEX_PUDDLE			; $4924
	jr nz,@label_05_067	; $4926
.else
	cp TILEINDEX_PUDDLE			; $48d5
	jr z,+					; $48d7
	cp TILEINDEX_PUDDLE+1			; $48d9
	jr z,+					; $48db
	cp TILEINDEX_PUDDLE+2			; $48dd
	jr nz,@label_05_067			; $48df
+
.endif

	; Disable terrain effects
	ld l,SpecialObject.visible		; $4928
	res 6,(hl)		; $492a
	ret			; $492c

@label_05_067:
	ld l,SpecialObject.zh		; $492d
	ld (hl),$00		; $492f

@enableTerrainEffects:
	ld l,SpecialObject.visible		; $4931
	set 6,(hl)		; $4933
	ret			; $4935

;;
; Set the animal's draw priority relative to Link's position.
; @addr{4936}
_companionSetPriorityRelativeToLink:
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $4936
	dec b			; $4939
	and $c0			; $493a
	or b			; $493c
	ld (de),a		; $493d
	ret			; $493e

;;
; Decrements counter1, and once it reaches 0, it plays the "jump" sound effect.
;
; @param[out]	cflag	nc if counter1 has reached 0 (should jump down the cliff).
; @param[out]	zflag	Same as carry
; @addr{493f}
_companionDecCounter1ToJumpDownCliff:
	ld e,SpecialObject.counter1		; $493f
	ld a,(de)		; $4941
	or a			; $4942
	jr z,@animate		; $4943

	dec a			; $4945
	ld (de),a		; $4946
	ld a,SND_JUMP		; $4947
	scf			; $4949
	ret nz			; $494a
	call playSound		; $494b
	xor a			; $494e
	scf			; $494f
	ret			; $4950

@animate:
	call specialObjectAnimate		; $4951
	call objectApplySpeed		; $4954
	ld c,$40		; $4957
	call objectUpdateSpeedZ_paramC		; $4959
	or d			; $495c
	ret			; $495d

;;
; @addr{495e}
_companionDecCounter1IfNonzero:
	ld h,d			; $495e
	ld l,SpecialObject.counter1		; $495f
	ld a,(hl)		; $4961
	or a			; $4962
	ret z			; $4963
	dec (hl)		; $4964
	ret			; $4965

;;
; Updates animation, and respawns the companion when the animation is over (bit 7 of
; animParameter is set).
;
; @param[out]	cflag	Set if the animation finished and the companion has respawned.
; @addr{4966}
_companionAnimateDrowningOrFallingThenRespawn:
	call specialObjectAnimate		; $4966
	ld e,SpecialObject.animParameter		; $4969
	ld a,(de)		; $496b
	rlca			; $496c
	ret nc			; $496d

	call _companionRespawn		; $496e
	scf			; $4971
	ret			; $4972

;;
; @param[out]	hl	Companion's counter2 variable
; @addr{4973}
_companionInitializeOnEnteringScreen:
	call _companionCheckCanSpawn		; $4973
	ld l,SpecialObject.state		; $4976
	ld (hl),$0c		; $4978
	ld l,SpecialObject.var03		; $497a
	inc (hl)		; $497c
	ld l,SpecialObject.counter2		; $497d
	jp objectSetVisiblec1		; $497f

;;
; Used with dimitri and moosh when they're walking into the screen.
;
; @param	hl	Table of direction offsets
; @addr{4982}
_companionRetIfNotFinishedWalkingIn:
	; Check that the tile in front has collision value 0
	call _specialObjectGetRelativeTileWithDirectionTable		; $4982
	or a			; $4985
	ret nz			; $4986

	; Decrement counter2
	ld e,SpecialObject.counter2		; $4987
	ld a,(de)		; $4989
	dec a			; $498a
	ld (de),a		; $498b
	ret z			; $498c

	; Return from caller if counter2 is nonzero
	pop af			; $498d
	ret			; $498e

;;
; @addr{498f}
_companionForceMount:
	ld a,(wMenuDisabled)		; $498f
	push af			; $4992
	xor a			; $4993
	ld (wMenuDisabled),a		; $4994
	ld (w1Link.invincibilityCounter),a		; $4997
	call _companionTryToMount		; $499a
	pop af			; $499d
	ld (wMenuDisabled),a		; $499e
	ret			; $49a1

;;
; @addr{49a2}
_companionDecCounter1:
	ld h,d			; $49a2
	ld l,SpecialObject.counter1		; $49a3
	ld a,(hl)		; $49a5
	or a			; $49a6
	ret			; $49a7

;;
; @addr{49a8}
specialObjectTryToBreakTile_source05:
	ld h,d			; $49a8
	ld l,<w1Link.yh		; $49a9
	ldi a,(hl)		; $49ab
	inc l			; $49ac
	ld c,(hl)		; $49ad
	add $05		; $49ae
	ld b,a			; $49b0
	ld a,BREAKABLETILESOURCE_05		; $49b1
	jp tryToBreakTile		; $49b3

;;
; Update the link object.
; @param d Link object
; @addr{49b6}
specialObjectCode_link:
	ld e,<w1Link.state		; $49b6
	ld a,(de)		; $49b8
	rst_jumpTable			; $49b9
	.dw _linkState00
	.dw _linkState01
	.dw _linkState02
	.dw _linkState03
	.dw _linkState04
	.dw _linkState05
	.dw _linkState06
	.dw linkState07
	.dw _linkState08
	.dw _linkState09
	.dw _linkState0a
	.dw _linkState0b
	.dw _linkState0c
	.dw _linkState0d
	.dw _linkState0e
	.dw _linkState0f
	.dw _linkState10
	.dw _linkState11
	.dw _linkState12
	.dw _linkState13
	.dw _linkState14

;;
; LINK_STATE_00
; @addr{49e4}
_linkState00:
	call clearAllParentItems		; $49e4
	call specialObjectSetOamVariables		; $49e7
	ld a,LINK_ANIM_MODE_WALK		; $49ea
	call specialObjectSetAnimation		; $49ec

	; Enable collisions?
	ld h,d			; $49ef
	ld l,SpecialObject.collisionType		; $49f0
	ld a,$80		; $49f2
	ldi (hl),a		; $49f4

	; Set collisionRadiusY,X
	inc l			; $49f5
	ld a,$06		; $49f6
	ldi (hl),a		; $49f8
	ldi (hl),a		; $49f9

	; A non-dead default health?
	ld l,SpecialObject.health		; $49fa
	ld (hl),$01		; $49fc

	; Do a series of checks to see whether Link spawned in an invalid position.

	ld a,(wLinkForceState)		; $49fe
	cp LINK_STATE_WARPING			; $4a01
	jr z,+			; $4a03

	ld a,(wDisableRingTransformations)		; $4a05
	or a			; $4a08
	jr nz,+			; $4a09

	; Check if he's in a solid wall
	call objectGetTileCollisions		; $4a0b
	cp $0f			; $4a0e
	jr nz,+			; $4a10

	; If he's in a wall, move Link to wLastAnimalMountPointY/X?
	ld hl,wLastAnimalMountPointY		; $4a12
	ldi a,(hl)		; $4a15
	ld e,<w1Link.yh		; $4a16
	ld (de),a		; $4a18
	ld a,(hl)		; $4a19
	ld e,<w1Link.xh		; $4a1a
	ld (de),a		; $4a1c
+
	call objectSetVisiblec1		; $4a1d
	call _checkLinkForceState		; $4a20
	jp _initLinkStateAndAnimateStanding		; $4a23

;;
; LINK_STATE_WARPING
; @addr{4a26}
_linkState0a:
	ld a,(wWarpTransition)		; $4a26
	and $0f			; $4a29
	rst_jumpTable			; $4a2b
	.dw _warpTransition0
	.dw _warpTransition1
	.dw _warpTransition2
	.dw _warpTransition3
	.dw _warpTransition4
	.dw _warpTransition5
	.dw _warpTransition6
.ifdef ROM_AGES
	.dw _warpTransitionA
.else
	.dw _warpTransition7
.endif
	.dw _warpTransition8
	.dw _warpTransition9
	.dw _warpTransitionA
	.dw _warpTransitionB
	.dw _warpTransitionC
	.dw _warpTransitionA
	.dw _warpTransitionE
	.dw _warpTransitionF

;;
; @addr{4a4c}
_warpTransition0:
	call _warpTransition_setLinkFacingDir		; $4a4c
;;
; @addr{4a4f}
_warpTransitionA:
	jp _initLinkStateAndAnimateStanding		; $4a4f

;;
; Transition E shifts Link's X position left 8, but otherwise behaves like Transition 1
; @addr{4a52}
_warpTransitionE:
	call objectCenterOnTile		; $4a52
	ld a,(hl)		; $4a55
	and $f0			; $4a56
	ld (hl),a		; $4a58

;;
; Transition 1 behaves like transition 0, but saves link's deathwarp point
; @addr{4a59}
_warpTransition1:
	call _warpTransition_setLinkFacingDir		; $4a59

;;
; @addr{4a5c}
_warpUpdateRespawnPoint:
	ld a,(wActiveGroup)		; $4a5c
	cp NUM_UNIQUE_GROUPS		; $4a5f
	jr nc,_warpTransition0		; $4a61
	call setDeathRespawnPoint		; $4a63
	call updateLinkLocalRespawnPosition		; $4a66
	jp _initLinkStateAndAnimateStanding		; $4a69

;;
; Transition C behaves like transition 0, but sets link's facing direction in
; a way I don't understand
; @addr{4a6c}
_warpTransitionC:
	ld a,(wcc50)		; $4a6c
	and $03			; $4a6f
	ld e,<w1Link.direction	; $4a71
	ld (de),a		; $4a73
	jp _initLinkStateAndAnimateStanding		; $4a74

;;
; @addr{4a77}
_warpTransition_setLinkFacingDir:
	call objectGetTileAtPosition		; $4a77
	ld hl,_facingDirAfterWarpTable		; $4a7a
	call lookupCollisionTable		; $4a7d
	jr c,+			; $4a80
	ld a,DIR_DOWN		; $4a82
+
	ld e,<w1Link.direction	; $4a84
	ld (de),a		; $4a86
	ret			; $4a87

; @addr{4a88}
_facingDirAfterWarpTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES
@collisions1:
	.db $36 DIR_UP ; Cave opening?

@collisions2:
@collisions3:
	.db $44 DIR_LEFT  ; Up stairs
	.db $45 DIR_RIGHT ; Down stairs

@collisions0:
@collisions4:
@collisions5:
	.db $00
.else
@collisions3:
	.db $36 DIR_UP		; $4a4d
@collisions4:
@collisions5:
	.db $44 DIR_LEFT
	.db $45 DIR_RIGHT
@collisions0:
@collisions1:
@collisions2:
	.db $00		; $4a53
.endif

;;
; Transition 2 is used by warp sources to fade out the screen.
; @addr{4a9b}
_warpTransition2:
	ld a,$03		; $4a9b
	ld (wWarpTransition2),a		; $4a9d
	ld a,SND_ENTERCAVE	; $4aa0
	jp playSound		; $4aa2

;;
; Transition 3 is used by both sources and destinations for transitions where
; link walks off the screen (or comes in from off the screen). It saves link's
; deathwarp point.
; @addr{4aa5}
_warpTransition3:
	ld e,<w1Link.warpVar1	; $4aa5
	ld a,(de)		; $4aa7
	or a			; $4aa8
	jr nz,@eachFrame	; $4aa9

	; Initialization stuff
	ld h,d			; $4aab
	ld l,e			; $4aac
	inc (hl)		; $4aad
	ld l,<w1Link.warpVar2	; $4aae
	ld (hl),$10		; $4ab0

	; Set link speed, up or down
	ld a,(wWarpTransition)		; $4ab2
	and $40			; $4ab5
	swap a			; $4ab7
	rrca			; $4ab9
	ld bc,@directionTable	; $4aba
	call addAToBc		; $4abd
	ld l,<w1Link.direction	; $4ac0
	ld a,(bc)		; $4ac2
	ldi (hl),a		; $4ac3
	inc bc			; $4ac4
	ld a,(bc)		; $4ac5
	ld (hl),a		; $4ac6

	call updateLinkSpeed_standard		; $4ac7
	call _animateLinkStanding		; $4aca
	ld a,(wWarpTransition)		; $4acd
	rlca			; $4ad0
	jr c,@destInit	; $4ad1

	ld a,SND_ENTERCAVE	; $4ad3
	jp playSound		; $4ad5

@directionTable: ; $4ad8
	.db $00 $00
	.db $02 $10

@eachFrame:
	ld a,(wScrollMode)		; $4adc
	and $0a			; $4adf
	ret nz			; $4ae1

	ld a,$00		; $4ae2
	ld (wScrollMode),a		; $4ae4
	call specialObjectAnimate		; $4ae7
	call itemDecCounter1		; $4aea
	jp nz,specialObjectUpdatePosition		; $4aed

	; Counter has reached zero
	ld a,$01		; $4af0
	ld (wScrollMode),a		; $4af2
	xor a			; $4af5
	ld (wMenuDisabled),a		; $4af6

	; Update respawn point if this is a destination
	ld a,(wWarpTransition)		; $4af9
	bit 7,a			; $4afc
	jp nz,_warpUpdateRespawnPoint		; $4afe

	swap a			; $4b01
	and $03			; $4b03
	ld (wWarpTransition2),a		; $4b05
	ret			; $4b08

@destInit:
	ld h,d			; $4b09
	ld a,(wWarpDestPos)		; $4b0a
	cp $ff			; $4b0d
	jr z,@enterFromMiddleBottom	; $4b0f

	cp $f0			; $4b11
	jr nc,@enterFromBottom		; $4b13

	ld l,<w1Link.yh		; $4b15
	call setShortPosition		; $4b17
	ld l,<w1Link.warpVar2	; $4b1a
	ld (hl),$1c		; $4b1c
	jp _initLinkStateAndAnimateStanding		; $4b1e

@enterFromMiddleBottom:
	ld a,$01		; $4b21
	ld (wMenuDisabled),a		; $4b23
	ld l,<w1Link.warpVar2	; $4b26
	ld (hl),$1c		; $4b28
	ld a,(wWarpTransition)		; $4b2a
	and $40			; $4b2d
	swap a			; $4b2f
	ld b,a			; $4b31
	ld a,(wActiveGroup)		; $4b32
	and NUM_SMALL_GROUPS	; $4b35
	rrca			; $4b37
	or b			; $4b38
	ld bc,@linkPosTable		; $4b39
	call addAToBc		; $4b3c
	ld l,<w1Link.yh		; $4b3f
	ld a,(bc)		; $4b41
	ldi (hl),a		; $4b42
	inc bc			; $4b43
	inc l			; $4b44
	ld a,(bc)		; $4b45
	ld (hl),a		; $4b46
	ret			; $4b47

@enterFromBottom:
	call @enterFromMiddleBottom	; $4b48
	ld a,(wWarpDestPos)		; $4b4b
	swap a			; $4b4e
	and $f0			; $4b50
	ld b,a			; $4b52
	ld a,(wActiveGroup)		; $4b53
	and NUM_SMALL_GROUPS		; $4b56
	jr z,+			; $4b58

	rlca			; $4b5a
+
	or b			; $4b5b
	ld l,<w1Link.xh		; $4b5c
	ld (hl),a		; $4b5e
	ret			; $4b5f

@linkPosTable:
	.db $80 $50 ; small room, enter from bottom
	.db $b0 $78 ; large room, enter from bottom
	.db $f0 $50 ; small room, enter from top
	.db $f0 $78 ; large room, enter from top

;;
; @addr{4b68}
_warpTransition4:
	ld a,(wWarpTransition)		; $4b68
	rlca			; $4b6b
	jp c,_warpTransition0		; $4b6c

	ld a,$01		; $4b6f
	ld (wWarpTransition2),a		; $4b71
	ld a,SND_ENTERCAVE	; $4b74
	jp playSound		; $4b76

;;
; Link falls into the screen
; @addr{4b79}
_warpTransition5:
	ld e,<w1Link.warpVar1	; $4b79
	ld a,(de)		; $4b7b
	rst_jumpTable			; $4b7c
	.dw _warpTransition5_00
	.dw _warpTransition5_01
	.dw _warpTransition5_02

_warpTransition5_00:
	ld a,$01		; $4b83
	ld (de),a		; $4b85
	ld bc,$0020		; $4b86
	call objectSetSpeedZ		; $4b89
	call objectGetZAboveScreen		; $4b8c
	ld l,<w1Link.zh		; $4b8f
	ld (hl),a		; $4b91
	ld l,<w1Link.yh		; $4b92
	ld a,(hl)		; $4b94
	sub $04			; $4b95
	ld (hl),a		; $4b97
	ld l,<w1Link.direction	; $4b98
	ld (hl),DIR_DOWN	; $4b9a
	ld a,LINK_ANIM_MODE_FALL	; $4b9c
	jp specialObjectSetAnimation		; $4b9e

_warpTransition5_01:
	call specialObjectAnimate		; $4ba1
	ld c,$20		; $4ba4
	call objectUpdateSpeedZ_paramC		; $4ba6
	ret nz			; $4ba9
.ifdef ROM_SEASONS
	call objectGetTileAtPosition		; $4b63
	cp $07			; $4b66
	jr z,+	; $4b68
.endif
	ld hl,hazardCollisionTable		; $4baa
	call lookupCollisionTable		; $4bad
	jp nc,_warpTransition7@label_4c05		; $4bb0
	jp _initLinkStateAndAnimateStanding		; $4bb3
.ifdef ROM_SEASONS
+
	ld a,(wActiveGroup)		; $4b76
	and $06			; $4b79
	cp $04			; $4b7b
	jp nz,_warpTransition7@label_4c05		; $4b7d
	; group 4/5
	jp seasonsFunc_05_50a5		; $4b80
.endif

.ifdef ROM_SEASONS
_warpTransition6:
	ld e,SpecialObject.state2		; $4b83
	ld a,(de)		; $4b85
	rst_jumpTable			; $4b86
	.dw _warpTransition6_00
	.dw _warpTransition6_01

_warpTransition6_00:
	ld a,$01		; $4b8b
	ld (de),a		; $4b8d

	ld a,(wcc50)		; $4b8e
	bit 7,a			; $4b91
	jr z,+			; $4b93
	rrca			; $4b95
	and $0f			; $4b96
	ld (wcc50),a		; $4b98
	ld a,$09		; $4b9b
	jp linkSetState		; $4b9d
+
	ld bc,-$300		; $4ba0
	call objectSetSpeedZ		; $4ba3
	ld l,SpecialObject.counter1		; $4ba6
	ld (hl),$78		; $4ba8
	ld l,SpecialObject.yh		; $4baa
	ld a,(hl)		; $4bac
	sub $04			; $4bad
	ld (hl),a		; $4baf
	ld a,LINK_ANIM_MODE_FALL		; $4bb0
	call specialObjectSetAnimation		; $4bb2

_warpTransition6_01:
	ld c,$18		; $4bb5
	call objectUpdateSpeedZ_paramC		; $4bb7
	jr z,+			; $4bba
	call specialObjectAnimate		; $4bbc
	call _specialObjectUpdateAdjacentWallsBitset		; $4bbf
	ld e,SpecialObject.speed		; $4bc2
	ld a,$14		; $4bc4
	ld (de),a		; $4bc6
	ld a,(wLinkAngle)		; $4bc7
	ld e,SpecialObject.angle		; $4bca
	ld (de),a		; $4bcc
	call updateLinkDirectionFromAngle		; $4bcd
	jp specialObjectUpdatePosition		; $4bd0
+
	call objectGetTileAtPosition		; $4bd3
	cp $07			; $4bd6
	jp z,seasonsFunc_05_50a5		; $4bd8
	jp _initLinkStateAndAnimateStanding		; $4bdb
.endif


;;
; Used only in Seasons
; @addr{4bb6}
_warpTransition7:
	ld e,<w1Link.warpVar1	; $4bb6
	ld a,(de)		; $4bb8
	rst_jumpTable			; $4bb9
	.dw @warpVar0
	.dw @warpVar1
	.dw @warpVar2
	.dw @warpVar3

@warpVar0:
	ld a,$01		; $4bc2
	ld (de),a		; $4bc4

	ld h,d			; $4bc5
	ld l,<w1Link.direction	; $4bc6
	ld (hl),DIR_DOWN	; $4bc8
	inc l			; $4bca
	ld (hl),$10		; $4bcb
	ld l,<w1Link.speed		; $4bcd
	ld (hl),SPEED_100		; $4bcf

	ld l,<w1Link.visible	; $4bd1
	res 7,(hl)		; $4bd3

	ld l,<w1Link.warpVar2	; $4bd5
	ld (hl),$78		; $4bd7

	ld a,LINK_ANIM_MODE_FALL	; $4bd9
	call specialObjectSetAnimation		; $4bdb

	ld a,SND_LINK_FALL	; $4bde
	jp playSound		; $4be0

@warpVar1:
	call itemDecCounter1		; $4be3
	ret nz			; $4be6

	ld l,<w1Link.warpVar1	; $4be7
	inc (hl)		; $4be9
	ld l,<w1Link.visible		; $4bea
	set 7,(hl)		; $4bec
	ld l,<w1Link.warpVar2	; $4bee
	ld (hl),$30		; $4bf0
	ld a,$10		; $4bf2
	call setScreenShakeCounter		; $4bf4
	ld a,SND_SCENT_SEED	; $4bf7
	jp playSound		; $4bf9

;;
; @addr{4bfc}
@warpVar2:
	call specialObjectAnimate		; $4bfc
	call itemDecCounter1		; $4bff
	jp nz,specialObjectUpdatePosition		; $4c02
;;
; @addr{4c05}
@label_4c05:
	call itemIncState2		; $4c05
	ld l,<w1Link.warpVar2	; $4c08
	ld (hl),$1e		; $4c0a
	ld a,LINK_ANIM_MODE_COLLAPSED	; $4c0c
	call specialObjectSetAnimation		; $4c0e
	ld a,SND_SPLASH		; $4c11
	jp playSound		; $4c13

;;
; @addr{4c16}
@warpVar3:
	call setDeathRespawnPoint		; $4c16

_warpTransition5_02:
	call itemDecCounter1		; $4c19
	ret nz			; $4c1c
	jp _initLinkStateAndAnimateStanding		; $4c1d

;;
; @addr{4c20}
_linkIncrementDirectionOnOddFrames:
	ld a,(wFrameCounter)		; $4c20
	rrca			; $4c23
	ret nc			; $4c24

;;
; @addr{4c25}
_linkIncrementDirection:
	ld e,<w1Link.direction	; $4c25
	ld a,(de)		; $4c27
	inc a			; $4c28
	and $03			; $4c29
	ld (de),a		; $4c2b
	ret			; $4c2c

;;
; A subrosian warp portal?
; @addr{4c2d}
_warpTransition8:
	ld e,SpecialObject.state2		; $4c2d
	ld a,(de)		; $4c2f
	rst_jumpTable			; $4c30
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

@substate0:
	ld a,$01		; $4c41
	ld (de),a		; $4c43
	ld a,$ff		; $4c44
	ld (wDisabledObjects),a		; $4c46
	ld a,$80		; $4c49
	ld (wMenuDisabled),a		; $4c4b
	ld a,CUTSCENE_S_15		; $4c4e
	ld (wCutsceneTrigger),a		; $4c50

	ld bc,$ff60		; $4c53
	call objectSetSpeedZ		; $4c56

	ld l,SpecialObject.counter1		; $4c59
	ld (hl),$30		; $4c5b

	call linkCancelAllItemUsage		; $4c5d
	call restartSound		; $4c60

	ld a,SND_FADEOUT		; $4c63
	call playSound		; $4c65
	jp objectCenterOnTile		; $4c68

@substate1:
	ld c,$02		; $4c6b
	call objectUpdateSpeedZ_paramC		; $4c6d
	ld a,(wFrameCounter)		; $4c70
	and $03			; $4c73
	jr nz,+			; $4c75
	ld hl,wTmpcbbc		; $4c77
	inc (hl)		; $4c7a
+
	ld a,(wFrameCounter)		; $4c7b
	and $03			; $4c7e
	call z,_linkIncrementDirection		; $4c80
	call itemDecCounter1		; $4c83
	ret nz			; $4c86
	jp itemIncState2		; $4c87

@substate2:
	ld c,$02		; $4c8a
	call objectUpdateSpeedZ_paramC		; $4c8c
	call _linkIncrementDirectionOnOddFrames		; $4c8f

	ld h,d			; $4c92
	ld l,SpecialObject.speedZ+1		; $4c93
	bit 7,(hl)		; $4c95
	ret nz			; $4c97

	ld l,SpecialObject.counter1		; $4c98
	ld (hl),$28		; $4c9a

	ld a,$02		; $4c9c
	call fadeoutToWhiteWithDelay		; $4c9e

	jp itemIncState2		; $4ca1

@substate3:
	call _linkIncrementDirectionOnOddFrames		; $4ca4
	call itemDecCounter1		; $4ca7
	ret nz			; $4caa
	ld hl,wTmpcbb3		; $4cab
	inc (hl)		; $4cae
	jp itemIncState2		; $4caf

@substate4:
	call _linkIncrementDirectionOnOddFrames		; $4cb2
	ld a,(wCutsceneState)		; $4cb5
	cp $02			; $4cb8
	ret nz			; $4cba
	call itemIncState2		; $4cbb
	ld l,SpecialObject.counter1		; $4cbe
	ld (hl),$28		; $4cc0
	ret			; $4cc2

@substate5:
	ld c,$02		; $4cc3
	call objectUpdateSpeedZ_paramC		; $4cc5
	call _linkIncrementDirectionOnOddFrames		; $4cc8
	call itemDecCounter1		; $4ccb
	ret nz			; $4cce
	jp itemIncState2		; $4ccf

@substate6:
	ld c,$02		; $4cd2
	call objectUpdateSpeedZ_paramC		; $4cd4
	ld a,(wFrameCounter)		; $4cd7
	and $03			; $4cda
	ret nz			; $4cdc

	call _linkIncrementDirection		; $4cdd
	ld hl,wTmpcbbc		; $4ce0
	dec (hl)		; $4ce3
	ret nz			; $4ce4

	ld hl,wTmpcbb3		; $4ce5
	inc (hl)		; $4ce8
	jp itemIncState2		; $4ce9

@substate7:
	ld a,(wDisabledObjects)		; $4cec
	and $81			; $4cef
	jr z,+			; $4cf1

	ld a,(wFrameCounter)		; $4cf3
	and $07			; $4cf6
	ret nz			; $4cf8
	jp _linkIncrementDirection		; $4cf9
+
	ld e,SpecialObject.direction		; $4cfc
	ld a,(de)		; $4cfe
	cp $02			; $4cff
	jp nz,_linkIncrementDirection		; $4d01
	ld a,(wActiveMusic2)		; $4d04
	ld (wActiveMusic),a		; $4d07
	call playSound		; $4d0a
	call setDeathRespawnPoint		; $4d0d
	call updateLinkLocalRespawnPosition		; $4d10
	call resetLinkInvincibility		; $4d13
	jp _initLinkStateAndAnimateStanding		; $4d16

;;
; @addr{4d19}
_warpTransition9:
	ld e,SpecialObject.state2		; $4d19
	ld a,(de)		; $4d1b
	rst_jumpTable			; $4d1c
	.dw @substate0
	.dw @substate1

@substate0:
	call itemIncState2		; $4d21

	ld l,SpecialObject.yh		; $4d24
	ld a,$08		; $4d26
	add (hl)		; $4d28
	ld (hl),a		; $4d29

	call objectCenterOnTile		; $4d2a
	call clearAllParentItems		; $4d2d

	ld a,LINK_ANIM_MODE_FALLINHOLE		; $4d30
	call specialObjectSetAnimation		; $4d32

	ld a,SND_LINK_FALL		; $4d35
	jp playSound		; $4d37

@substate1:
	ld e,SpecialObject.animParameter		; $4d3a
	ld a,(de)		; $4d3c
	inc a			; $4d3d
	jp nz,specialObjectAnimate		; $4d3e

	ld a,$03		; $4d41
	ld (wWarpTransition2),a		; $4d43
	ret			; $4d46

;;
; @addr{4d47}
_warpTransitionB:
	ld e,<w1Link.warpVar1	; $4d47
	ld a,(de)		; $4d49
	rst_jumpTable			; $4d4a
	.dw @warpVar0
	.dw @warpVar1
	.dw @warpVar2

@warpVar0:
	call itemIncState2		; $4d51

	call objectGetZAboveScreen		; $4d54
	ld l,<w1Link.zh		; $4d57
	ld (hl),a		; $4d59

	ld l,<w1Link.direction	; $4d5a
	ld (hl),DIR_DOWN	; $4d5c

	ld a,LINK_ANIM_MODE_FALL		; $4d5e
	jp specialObjectSetAnimation		; $4d60

@warpVar1:
	call specialObjectAnimate		; $4d63
	ld c,$0c		; $4d66
	call objectUpdateSpeedZ_paramC		; $4d68
	ret nz			; $4d6b

.ifdef ROM_AGES
	call itemIncState2		; $4d6c
	call _animateLinkStanding		; $4d6f
	ld a,SND_SPLASH		; $4d72
	jp playSound		; $4d74
.else
	xor a			; $4d94
	ld (wDisabledObjects),a		; $4d95
	ld a,$08		; $4d98
	call setLinkIDOverride		; $4d9a
	ld l,SpecialObject.subid		; $4d9d
	ld (hl),$02		; $4d9f
	ret			; $4da1
.endif

@warpVar2:
	ld a,(wDisabledObjects)		; $4d77
	and $81			; $4d7a
	ret nz			; $4d7c

	call objectSetVisiblec2		; $4d7d
	jp _initLinkStateAndAnimateStanding		; $4d80


;;
; @addr{4d83}
_warpTransitionF:
	call _checkLinkForceState		; $4d83
	jp objectSetInvisible		; $4d86

.ifdef ROM_AGES
;;
; "Timewarp" transition
; @addr{4d89}
_warpTransition6:
	ld e,SpecialObject.state2		; $4d89
	ld a,(de)		; $4d8b
	rst_jumpTable			; $4d8c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

;;
; @addr{4d9d}
@flickerVisibilityAndDecCounter1:
	ld b,$03		; $4d9d
	call objectFlickerVisibility		; $4d9f
	jp itemDecCounter1		; $4da2

;;
; @addr{4da5}
@createDestinationTimewarpAnimation:
	call getFreeInteractionSlot		; $4da5
	ret nz			; $4da8
	ld (hl),INTERACID_TIMEWARP		; $4da9
	inc l			; $4dab
	inc (hl)		; $4dac

	; [Interaction.var03] = [wcc50]
	ld a,(wcc50)		; $4dad
	inc l			; $4db0
	ld (hl),a		; $4db1
	ret			; $4db2

;;
; This function should center Link if it detects that he's warped into a 2-tile-wide
; doorway.
; Except, it doesn't work. There's a typo.
; @addr{4db3}
@centerLinkOnDoorway:
	call objectGetTileAtPosition		; $4db3
	push hl			; $4db6

	; This should be "ld e,a" instead of "ld a,e".
	ld a,e			; $4db7

	ld hl,@doorTiles		; $4db8
	call findByteAtHl		; $4dbb
	pop hl			; $4dbe
	ret nc			; $4dbf

	push hl			; $4dc0
	dec l			; $4dc1
	ld e,(hl)		; $4dc2
	ld hl,@doorTiles		; $4dc3
	call findByteAtHl		; $4dc6
	pop hl			; $4dc9
	jr nc,+			; $4dca

	ld e,SpecialObject.xh		; $4dcc
	ld a,(de)		; $4dce
	and $f0			; $4dcf
	ld (de),a		; $4dd1
	ret			; $4dd2
+
	inc l			; $4dd3
	ld e,(hl)		; $4dd4
	ld hl,@doorTiles		; $4dd5
	call findByteAtHl		; $4dd8
	ret nc			; $4ddb

	ld e,SpecialObject.xh		; $4ddc
	ld a,(de)		; $4dde
	add $08			; $4ddf
	ld (de),a		; $4de1
	ld hl,wEnteredWarpPosition		; $4de2
	inc (hl)		; $4de5
	ret			; $4de6

; List of tile indices that are "door tiles" which initiate warps.
@doorTiles:
	.db $dc $dd $de $df $ed $ee $ef
	.db $00


; Initialization
@substate0:
	call itemIncState2		; $4def

	ld l,SpecialObject.counter1		; $4df2
	ld (hl),$1e		; $4df4
	ld l,SpecialObject.direction		; $4df6
	ld (hl),DIR_DOWN		; $4df8

	ld a,d			; $4dfa
	ld (wLinkCanPassNpcs),a		; $4dfb
	ld (wMenuDisabled),a		; $4dfe

	call @centerLinkOnDoorway		; $4e01
	jp objectSetInvisible		; $4e04


; Waiting for palette to fade in and counter1 to reach 0
@substate1:
	ld a,(wPaletteThread_mode)		; $4e07
	or a			; $4e0a
	ret nz			; $4e0b
	call itemDecCounter1		; $4e0c
	ret nz			; $4e0f

; Create the timewarp animation, and go to substate 4 if Link is obstructed from warping
; in, otherwise go to substate 2.

	ld (hl),$10		; $4e10
	call @createDestinationTimewarpAnimation		; $4e12

	ld a,(wSentBackByStrangeForce)		; $4e15
	dec a			; $4e18
	jr z,@warpFailed			; $4e19

	callab bank1.checkLinkCanStandOnTile		; $4e1b
	srl c			; $4e23
	jr c,@warpFailed			; $4e25

	callab bank1.checkSolidObjectAtWarpDestPos		; $4e27
	srl c			; $4e2f
	jr c,@warpFailed			; $4e31

	jp itemIncState2		; $4e33

	; Link will be returned to the time he came from.
@warpFailed:
	ld e,SpecialObject.state2		; $4e36
	ld a,$04		; $4e38
	ld (de),a		; $4e3a
	ret			; $4e3b


; Waiting several frames before making Link visible and playing the sound effect
@substate2:
	call itemDecCounter1		; $4e3c
	ret nz			; $4e3f

	ld (hl),$1e		; $4e40

@makeLinkVisibleAndPlaySound:
	ld a,SND_TIMEWARP_COMPLETED		; $4e42
	call playSound		; $4e44
	call objectSetVisiblec0		; $4e47
	jp itemIncState2		; $4e4a


@substate3:
	call @flickerVisibilityAndDecCounter1		; $4e4d
	ret nz			; $4e50

; Warp is completed; create a time portal if necessary, restore control to Link

	; Check if a time portal should be created
	ld a,(wLinkTimeWarpTile)		; $4e51
	or a			; $4e54
	jr nz,++	; $4e55

	; Create a time portal
	ld hl,wPortalGroup		; $4e57
	ld a,(wActiveGroup)		; $4e5a
	ldi (hl),a		; $4e5d
	ld a,(wActiveRoom)		; $4e5e
	ldi (hl),a		; $4e61
	ld a,(wWarpDestPos)		; $4e62
	ld (hl),a		; $4e65
	ld c,a			; $4e66
	call getFreeInteractionSlot		; $4e67
	jr nz,++	; $4e6a

	ld (hl),INTERACID_TIMEPORTAL		; $4e6c
	ld l,Interaction.yh		; $4e6e
	call setShortPosition_paramC		; $4e70
++
	; Check whether to show the "Sent back by strange force" text.
	ld a,(wSentBackByStrangeForce)		; $4e73
	or a			; $4e76
	jr z,+			; $4e77
	ld bc,TX_5112		; $4e79
	call showText		; $4e7c
+
	; Restore everything to normal, give control back to Link.
	xor a			; $4e7f
	ld (wLinkTimeWarpTile),a		; $4e80
	ld (wWarpTransition),a		; $4e83
	ld (wLinkCanPassNpcs),a		; $4e86
	ld (wMenuDisabled),a		; $4e89
	ld (wSentBackByStrangeForce),a		; $4e8c
	ld (wcddf),a		; $4e8f
	ld (wcde0),a		; $4e92

	ld e,SpecialObject.invincibilityCounter		; $4e95
	ld a,$88		; $4e97
	ld (de),a		; $4e99

	call updateLinkLocalRespawnPosition		; $4e9a
	call objectSetVisiblec2		; $4e9d
	jp _initLinkStateAndAnimateStanding		; $4ea0


; Substates 4-7: Warp failed, Link will be sent back to the time he came from

@substate4:
	call itemDecCounter1		; $4ea3
	ret nz			; $4ea6

	ld (hl),$78		; $4ea7
	jr @makeLinkVisibleAndPlaySound		; $4ea9

@substate5:
	call @flickerVisibilityAndDecCounter1		; $4eab
	ret nz			; $4eae

	ld (hl),$10		; $4eaf
	call @createDestinationTimewarpAnimation		; $4eb1
	jp itemIncState2		; $4eb4

@substate6:
	call @flickerVisibilityAndDecCounter1		; $4eb7
	ret nz			; $4eba

	ld (hl),$14		; $4ebb
	call objectSetInvisible		; $4ebd
	jp itemIncState2		; $4ec0

@substate7:
	call itemDecCounter1		; $4ec3
	ret nz			; $4ec6

; Initiate another warp sending Link back to the time he came from

	call objectGetTileAtPosition		; $4ec7
	ld c,l			; $4eca

	ld hl,wWarpDestGroup		; $4ecb
	ld a,(wActiveGroup)		; $4ece
	xor $01			; $4ed1
	or $80			; $4ed3
	ldi (hl),a		; $4ed5

	; wWarpDestRoom
	ld a,(wActiveRoom)		; $4ed6
	ldi (hl),a		; $4ed9

	; wWarpTransition
	ld a,TRANSITION_DEST_TIMEWARP		; $4eda
	ldi (hl),a		; $4edc

	; wWarpDestPos
	ld a,c			; $4edd
	ldi (hl),a		; $4ede

	inc a			; $4edf
	ld (wLinkTimeWarpTile),a		; $4ee0
	ld (wcddf),a		; $4ee3

	; wWarpTransition2
	ld a,$03		; $4ee6
	ld (hl),a		; $4ee8

	xor a			; $4ee9
	ld (wScrollMode),a		; $4eea

	ld hl,wSentBackByStrangeForce		; $4eed
	ld a,(hl)		; $4ef0
	or a			; $4ef1
	jr z,+			; $4ef2
	inc (hl)		; $4ef4
+
	ld a,(wLinkStateParameter)		; $4ef5
	bit 4,a			; $4ef8
	jr nz,+			; $4efa
	call getThisRoomFlags		; $4efc
	res 4,(hl)		; $4eff
+
	ld a,SND_TIMEWARP_COMPLETED		; $4f01
	call playSound		; $4f03

	ld de,w1Link		; $4f06
	jp objectDelete_de		; $4f09
.endif

;;
; LINK_STATE_08
; @addr{4f0c}
_linkState08:
	ld e,SpecialObject.state2		; $4f0c
	ld a,(de)		; $4f0e
	rst_jumpTable			; $4f0f
	.dw @substate0
	.dw @substate1

@substate0:
	; Go to substate 1
	ld a,$01		; $4f14
	ld (de),a		; $4f16

	ld hl,wcc50		; $4f17
	ld a,(hl)		; $4f1a
	ld (hl),$00		; $4f1b
	or a			; $4f1d
	ret nz			; $4f1e

	call linkCancelAllItemUsageAndClearAdjacentWallsBitset		; $4f1f
	ld a,LINK_ANIM_MODE_WALK		; $4f22
	jp specialObjectSetAnimation		; $4f24

@substate1:
	call _checkLinkForceState		; $4f27

	ld hl,wcc50		; $4f2a
	ld a,(hl)		; $4f2d
	or a			; $4f2e
	jr z,+			; $4f2f
	ld (hl),$00		; $4f31
	call specialObjectSetAnimation		; $4f33
+
	ld a,(wcc63)		; $4f36
	or a			; $4f39
	call nz,checkUseItems		; $4f3a

	ld a,(wDisabledObjects)		; $4f3d
	or a			; $4f40
	ret nz			; $4f41

	jp _initLinkStateAndAnimateStanding		; $4f42

;;
; @addr{4f45}
linkCancelAllItemUsageAndClearAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset		; $4f45
	xor a			; $4f47
	ld (de),a		; $4f48
;;
; Drop any held items, cancels usage of sword, etc?
; @addr{4f49}
linkCancelAllItemUsage:
	call dropLinkHeldItem		; $4f49
	jp clearAllParentItems		; $4f4c

;;
; LINK_STATE_0e
; @addr{4f4f}
_linkState0e:
	ld e,SpecialObject.state2		; $4f4f
	ld a,(de)		; $4f51
	rst_jumpTable			; $4f52
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemIncState2		; $4f59
	ld e,SpecialObject.var37		; $4f5c
	ld a,(wActiveRoom)		; $4f5e
	ld (de),a		; $4f61

@substate1:
	call objectCheckWithinScreenBoundary		; $4f62
	ret c			; $4f65
	call itemIncState2		; $4f66
	call objectSetInvisible		; $4f69

@substate2:
	ld h,d			; $4f6c
	ld l,SpecialObject.var37		; $4f6d
	ld a,(wActiveRoom)		; $4f6f
	cp (hl)			; $4f72
	ret nz			; $4f73

	call objectCheckWithinScreenBoundary		; $4f74
	ret nc			; $4f77

	ld e,SpecialObject.state2		; $4f78
	ld a,$01		; $4f7a
	ld (de),a		; $4f7c
	jp objectSetVisiblec2		; $4f7d

.ifdef ROM_AGES
;;
; LINK_STATE_TOSSED_BY_GUARDS
; @addr{4f80}
_linkState0f:
	ld a,(wTextIsActive)		; $4f80
	or a			; $4f83
	ret nz			; $4f84

	ld e,SpecialObject.state2		; $4f85
	ld a,(de)		; $4f87
	rst_jumpTable			; $4f88
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call itemIncState2		; $4f8f

	; [SpecialObject.counter1] = $14
	inc l			; $4f92
	ld (hl),$14		; $4f93

	ld l,SpecialObject.angle		; $4f95
	ld (hl),$10		; $4f97
	ld l,SpecialObject.yh		; $4f99
	ld (hl),$38		; $4f9b
	ld l,SpecialObject.xh		; $4f9d
	ld (hl),$50		; $4f9f
	ld l,SpecialObject.speed		; $4fa1
	ld (hl),SPEED_100		; $4fa3

	ld l,SpecialObject.speedZ		; $4fa5
	ld a,$80		; $4fa7
	ldi (hl),a		; $4fa9
	ld (hl),$fe		; $4faa

	ld a,LINK_ANIM_MODE_COLLAPSED		; $4fac
	call specialObjectSetAnimation		; $4fae

	jp objectSetVisiblec2		; $4fb1

@substate1:
	call objectApplySpeed		; $4fb4

	ld c,$20		; $4fb7
	call objectUpdateSpeedZAndBounce		; $4fb9
	ret nc ; Return if Link can still bounce

	jp itemIncState2		; $4fbd

@substate2:
	call itemDecCounter1		; $4fc0
	ret nz			; $4fc3
	jp _initLinkStateAndAnimateStanding		; $4fc4
.endif

;;
; LINK_STATE_FORCE_MOVEMENT
; @addr{4fc7}
_linkState0b:
	ld e,SpecialObject.state2		; $4fc7
	ld a,(de)		; $4fc9
	rst_jumpTable			; $4fca
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,$01		; $4fcf
	ld (de),a		; $4fd1

	ld e,SpecialObject.counter1		; $4fd2
	ld a,(wLinkStateParameter)		; $4fd4
	ld (de),a		; $4fd7

	call clearPegasusSeedCounter		; $4fd8
	call linkCancelAllItemUsageAndClearAdjacentWallsBitset		; $4fdb
	call updateLinkSpeed_standard		; $4fde

	ld a,LINK_ANIM_MODE_WALK		; $4fe1
	call specialObjectSetAnimation		; $4fe3

@substate1:
	call specialObjectAnimate		; $4fe6
	call itemDecCounter1		; $4fe9
	ld l,SpecialObject.adjacentWallsBitset		; $4fec
	ld (hl),$00		; $4fee
	jp nz,specialObjectUpdatePosition		; $4ff0

	; When counter1 reaches 0, go back to LINK_STATE_NORMAL.
	jp _initLinkStateAndAnimateStanding		; $4ff3


;;
; LINK_STATE_04
; @addr{4ff6}
_linkState04:
	ld e,SpecialObject.state2		; $4ff6
	ld a,(de)		; $4ff8
	rst_jumpTable			; $4ff9
	.dw @substate0
	.dw @substate1

@substate0:
	; Go to substate 1
	ld a,$01		; $4ffe
	ld (de),a		; $5000

	call linkCancelAllItemUsage		; $5001

	ld e,SpecialObject.animMode		; $5004
	ld a,(de)		; $5006
	ld (wcc52),a		; $5007

	ld a,(wcc50)		; $500a
	and $0f			; $500d
	add $0e			; $500f
	jp specialObjectSetAnimation		; $5011

@substate1:
	call retIfTextIsActive		; $5014
	ld a,(wcc50)		; $5017
	rlca			; $501a
	jr c,+			; $501b

	ld a,(wDisabledObjects)		; $501d
	and $81			; $5020
	ret nz			; $5022
+
	ld e,SpecialObject.state		; $5023
	ld a,LINK_STATE_NORMAL		; $5025
	ld (de),a		; $5027
	ld a,(wcc52)		; $5028
	jp specialObjectSetAnimation		; $502b

;;
; @addr{502e}
setLinkStateToDead:
	ld a,LINK_STATE_DYING		; $502e
	call linkSetState		; $5030
;;
; LINK_STATE_DYING
; @addr{5033}
_linkState03:
	xor a			; $5033
	ld (wLinkHealth),a		; $5034
	ld e,SpecialObject.state2		; $5037
	ld a,(de)		; $5039
	rst_jumpTable			; $503a
	.dw @substate0
	.dw @substate1

; Link just started dying (initialization)
@substate0:
	call _specialObjectUpdateAdjacentWallsBitset		; $503f

	ld e,SpecialObject.knockbackCounter		; $5042
	ld a,(de)		; $5044
	or a			; $5045
	jp nz,_linkUpdateKnockback		; $5046

	ld h,d			; $5049
	ld l,SpecialObject.state2		; $504a
	inc (hl)		; $504c

	ld l,SpecialObject.counter1		; $504d
	ld (hl),$04		; $504f

	call linkCancelAllItemUsage		; $5051

	ld a,LINK_ANIM_MODE_SPIN		; $5054
	call specialObjectSetAnimation		; $5056
	ld a,SND_LINK_DEAD		; $5059
	jp playSound		; $505b

; Link is in the process of dying (spinning around)
@substate1:
	call resetLinkInvincibility		; $505e
	call specialObjectAnimate		; $5061

	ld h,d			; $5064
	ld l,SpecialObject.animParameter		; $5065
	ld a,(hl)		; $5067
	add a			; $5068
	jr nz,@triggerGameOver		; $5069
	ret nc			; $506b

; When animParameter is $80 or above, change link's animation to "unconscious"
	ld l,SpecialObject.counter1		; $506c
	dec (hl)		; $506e
	ret nz			; $506f
	ld a,LINK_ANIM_MODE_COLLAPSED		; $5070
	jp specialObjectSetAnimation		; $5072

@triggerGameOver:
	ld a,$ff		; $5075
	ld (wGameOverScreenTrigger),a		; $5077
	ret			; $507a

;;
; LINK_STATE_RESPAWNING
;
; This state behaves differently depending on wLinkStateParameter:
;  0: Fall down a hole
;  1: Fall down a hole without centering Link on the tile
;  2: Respawn instantly
;  3: Fall down a hole, different behaviour?
;  4: Drown
; @addr{507b}
_linkState02:
	ld a,$ff		; $507b
	ld (wGameKeysPressed),a		; $507d

	; Disable the push animation
	ld a,$80		; $5080
	ld (wForceLinkPushAnimation),a		; $5082

	ld e,SpecialObject.state2		; $5085
	ld a,(de)		; $5087
	rst_jumpTable			; $5088
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

; Initialization
@substate0:
	call linkCancelAllItemUsage		; $5095

	ld a,(wLinkStateParameter)		; $5098
	rst_jumpTable			; $509b
	.dw @parameter_fallDownHole
	.dw @parameter_fallDownHoleWithoutCentering
	.dw @respawn
	.dw @parameter_3
	.dw @parameter_drown

@parameter_drown:
	ld e,SpecialObject.state2		; $50a6
	ld a,$05		; $50a8
	ld (de),a		; $50aa
	ld a,LINK_ANIM_MODE_DROWN		; $50ab
	jp specialObjectSetAnimation		; $50ad

@parameter_fallDownHole:
	call objectCenterOnTile		; $50b0

@parameter_fallDownHoleWithoutCentering:
	call itemIncState2		; $50b3
	jr ++			; $50b6

@parameter_3:
	ld e,SpecialObject.state2		; $50b8
	ld a,$04		; $50ba
	ld (de),a		; $50bc
++
	; Disable collisions
	ld h,d			; $50bd
	ld l,SpecialObject.collisionType		; $50be
	res 7,(hl)		; $50c0

	; Do the "fall in hole" animation
	ld a,LINK_ANIM_MODE_FALLINHOLE		; $50c2
	call specialObjectSetAnimation		; $50c4
	ld a,SND_LINK_FALL		; $50c7
	jp playSound		; $50c9


; Doing a "falling down hole" animation, waiting for it to finish
@substate1:
	; Wait for the animation to finish
	ld h,d			; $50cc
	ld l,SpecialObject.animParameter		; $50cd
	bit 7,(hl)		; $50cf
	jp z,specialObjectAnimate		; $50d1

	ld a,(wActiveTileType)		; $50d4
	cp TILETYPE_WARPHOLE			; $50d7
	jr nz,@respawn		; $50d9

.ifdef ROM_AGES
	; Check if the current room is the moblin keep with the crumbling floors
	ld a,(wActiveGroup)		; $50db
	cp $02			; $50de
	jr nz,+			; $50e0
	ld a,(wActiveRoom)		; $50e2
	cp $9f			; $50e5
	jr nz,+			; $50e7

	jpab bank1.warpToMoblinKeepUnderground		; $50e9
+
.else
	; start CUTSCENE_S_ONOX_FINAL_FORM
	ld a,(wDungeonIndex)		; $4f3c
	cp $09			; $4f3f
	jr nz,+			; $4f41
	ld a,CUTSCENE_S_ONOX_FINAL_FORM		; $4f43
	ld (wCutsceneTrigger),a		; $4f45
	ret			; $4f48
+
.endif
	; This function call will only work in dungeons.
	jpab bank1.initiateFallDownHoleWarp		; $50f1

@respawn:
	call specialObjectSetCoordinatesToRespawnYX		; $50f9
	ld l,SpecialObject.state2		; $50fc
	ld a,$02		; $50fe
	ldi (hl),a		; $5100

	; [SpecialObject.counter1] = $02
	ld (hl),a		; $5101

	call specialObjectTryToBreakTile_source05		; $5102

	; Set wEnteredWarpPosition, which prevents Link from instantly activating a warp
	; tile if he respawns on one.
	call objectGetTileAtPosition		; $5105
	ld a,l			; $5108
	ld (wEnteredWarpPosition),a		; $5109

	jp objectSetInvisible		; $510c


; Waiting for counter1 to reach 0 before having Link reappear.
@substate2:
	ld h,d			; $510f
	ld l,SpecialObject.counter1		; $5110

	; Check if the screen is scrolling?
	ld a,(wScrollMode)		; $5112
	and $80			; $5115
	jr z,+			; $5117
	ld (hl),$04		; $5119
	ret			; $511b
+
	dec (hl)		; $511c
	ret nz			; $511d

	; Counter has reached 0; make Link reappear, apply damage

	xor a			; $511e
	ld (wLinkInAir),a		; $511f
	ld (wLinkSwimmingState),a		; $5122

	ld a,GOLD_LUCK_RING		; $5125
	call cpActiveRing		; $5127
	ld a,$fc		; $512a
	jr nz,+			; $512c
	sra a			; $512e
+
	call itemIncState2		; $5130

	ld l,SpecialObject.damageToApply		; $5133
	ld (hl),a		; $5135
	ld l,SpecialObject.invincibilityCounter		; $5136
	ld (hl),$3c		; $5138

	ld l,SpecialObject.counter1		; $513a
	ld (hl),$10		; $513c

	call linkApplyDamage		; $513e
	call objectSetVisiblec1		; $5141
	call _specialObjectUpdateAdjacentWallsBitset		; $5144
	jp _animateLinkStanding		; $5147


; Waiting for counter1 to reach 0 before switching back to LINK_STATE_NORMAL.
@substate3:
	call itemDecCounter1		; $514a
	ret nz			; $514d

	; Enable collisions
	ld l,SpecialObject.collisionType		; $514e
	set 7,(hl)		; $5150

	jp _initLinkStateAndAnimateStanding		; $5152


@substate4:
	ld h,d			; $5155
	ld l,SpecialObject.animParameter		; $5156
	bit 7,(hl)		; $5158
	jp z,specialObjectAnimate		; $515a
	call objectSetInvisible		; $515d
	jp _checkLinkForceState		; $5160


; Drowning instead of falling into a hole
@substate5:
	ld e,SpecialObject.animParameter		; $5163
	ld a,(de)		; $5165
	rlca			; $5166
	jp nc,specialObjectAnimate		; $5167
	jr @respawn		; $516a

.ifdef ROM_AGES
;;
; Makes Link surface from an underwater area if he's pressed B.
; @addr{516c}
_checkForUnderwaterTransition:
	ld a,(wDisableScreenTransitions)		; $516c
	or a			; $516f
	ret nz			; $5170
	ld a,(wTilesetFlags)		; $5171
	and TILESETFLAG_UNDERWATER			; $5174
	ret z			; $5176
	ld a,(wGameKeysJustPressed)		; $5177
	and BTN_B			; $517a
	ret z			; $517c

	ld a,(wActiveTilePos)		; $517d
	ld l,a			; $5180
	ld h,>wRoomLayout		; $5181
	ld a,(hl)		; $5183
	ld hl,tileTypesTable		; $5184
	call lookupCollisionTable		; $5187

	; Don't allow surfacing on whirlpools
	cp TILETYPE_WHIRLPOOL			; $518a
	ret z			; $518c

	; Move down instead of up when over a "warp hole" (only used in jabu-jabu?)
	cp TILETYPE_WARPHOLE			; $518d
	jr z,@levelDown		; $518f

	; Return if Link can't surface here
	call checkLinkCanSurface		; $5191
	ret nc			; $5194

	; Return from the caller (_linkState01)
	pop af			; $5195

	ld a,(wTilesetFlags)		; $5196
	and TILESETFLAG_DUNGEON			; $5199
	jr nz,@dungeon		; $519b

	; Not in a dungeon

	; Set 'c' to the value to add to wActiveGroup.
	; Set 'a' to the room index to end up in.
	ld c,$fe		; $519d
	ld a,(wActiveRoom)		; $519f
	jr @initializeWarp		; $51a2

@dungeon:
	; Increment the floor you're on, get the new room index
	ld a,(wDungeonFloor)		; $51a4
	inc a			; $51a7
	ld (wDungeonFloor),a		; $51a8
	call getActiveRoomFromDungeonMapPosition		; $51ab
	ld c,$00		; $51ae
	jr @initializeWarp		; $51b0

	; Go down a level instead of up one
@levelDown:
	; Return from caller
	pop af			; $51b2

	ld a,(wTilesetFlags)		; $51b3
	and TILESETFLAG_DUNGEON			; $51b6
	jr nz,+			; $51b8

	; Not in a dungeon: add 2 to wActiveGroup.
	ld c,$02		; $51ba
	ld a,(wActiveRoom)		; $51bc
	jr @initializeWarp		; $51bf
+
	; In a dungeon: decrement the floor you're on, get the new room index
	ld a,(wDungeonFloor)		; $51c1
	dec a			; $51c4
	ld (wDungeonFloor),a		; $51c5
	call getActiveRoomFromDungeonMapPosition		; $51c8
	ld c,$00		; $51cb
	jr @initializeWarp		; $51cd

@initializeWarp:
	ld (wWarpDestRoom),a		; $51cf

	ld a,(wActiveGroup)		; $51d2
	add c			; $51d5
	or $80			; $51d6
	ld (wWarpDestGroup),a		; $51d8

	ld a,(wActiveTilePos)		; $51db
	ld (wWarpDestPos),a		; $51de

	ld a,$00		; $51e1
	ld (wWarpTransition),a		; $51e3

	ld a,$03		; $51e6
	ld (wWarpTransition2),a		; $51e8
	ret			; $51eb
.endif

.ifdef ROM_SEASONS
; Bouncing from trampoline, hitting the ceiling,
; or setting warp to floor above
_linkState09:
	call retIfTextIsActive		; $4fc4
	ld e,SpecialObject.state2	; $4fc7
	ld a,(de)			; $4fc9
	rst_jumpTable			; $4fca
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	call clearAllParentItems		; $4fd9
	xor a			; $4fdc
	ld (wScrollMode),a	; $4fdd
	ld (wUsingShield),a	; $4fe0
	ld bc,-$400		; $4fe3
	call objectSetSpeedZ	; $4fe6
	ld l,SpecialObject.counter1		; $4fe9
	ld (hl),$0a		; $4feb
	ld a,(wcc50)		; $4fed
	rrca			; $4ff0
	ld a,$01		; $4ff1
	jr nc,+			; $4ff3
	inc a			; $4ff5
+
	ld l,SpecialObject.state2		; $4ff6
	ld (hl),a		; $4ff8
	ld a,$81		; $4ff9
	ld (wLinkInAir),a	; $4ffb
	ret			; $4ffe

@substate1:
	call @seasonsFunc_05_5043		; $4fff
	ret c			; $5002
	ld a,(wDungeonFloor)		; $5003
	inc a			; $5006
	ld (wDungeonFloor),a		; $5007
	call getActiveRoomFromDungeonMapPosition		; $500a
	ld (wWarpDestRoom),a		; $500d
	call objectGetShortPosition		; $5010
	ld (wWarpDestPos),a		; $5013
	ld a,(wActiveGroup)		; $5016
	or $80			; $5019
	ld (wWarpDestGroup),a		; $501b
	ld a,$06		; $501e
	ld (wWarpTransition),a		; $5020
	ld a,$03		; $5023
	ld (wWarpTransition2),a		; $5025
	ret			; $5028
@substate2:
	call @seasonsFunc_05_5043		; $5029
	ret c			; $502c
	ld a,$01		; $502d
	ld (wScrollMode),a		; $502f
	ld l,SpecialObject.state2		; $5032
	inc (hl)		; $5034
	ld l,SpecialObject.counter1		; $5035
	ld (hl),$1e		; $5037
	ld a,$08		; $5039
	call setScreenShakeCounter		; $503b
	ld a,LINK_ANIM_MODE_COLLAPSED		; $503e
	jp specialObjectSetAnimation		; $5040

@seasonsFunc_05_5043:
	ld c,$0c		; $5043
	call objectUpdateSpeedZ_paramC		; $5045
	call specialObjectAnimate		; $5048
	ld h,d			; $504b
	ld l,SpecialObject.counter1		; $504c
	ld a,(hl)		; $504e
	or a			; $504f
	jr z,+			; $5050
	dec (hl)		; $5052
	jr nz,+			; $5053
	ld a,LINK_ANIM_MODE_FALL		; $5055
	call specialObjectSetAnimation		; $5057
+
	call objectGetZAboveScreen		; $505a
	ld h,d			; $505d
	ld l,SpecialObject.zh		; $505e
	cp (hl)			; $5060
	ret			; $5061

@substate3:
	call itemDecCounter1	; $5062
	ret nz			; $5065
	dec l			; $5066
	inc (hl)		; $5067
	ld bc,-$100		; $5068
	jp objectSetSpeedZ	; $506b

@substate4:
	ld c,$20		; $506e
	call objectUpdateSpeedZ_paramC		; $5070
	ret nz			; $5073
	call objectGetTileAtPosition		; $5074
	cp $07			; $5077
	jr z,seasonsFunc_05_50a5	; $5079
	ld h,d			; $507b
	ld l,SpecialObject.state2		; $507c
	inc (hl)		; $507e
	; SpecialObject.counter1
	inc l			; $507f
	ld (hl),$1e		; $5080
	ld a,LINK_ANIM_MODE_COLLAPSED		; $5082
	call specialObjectSetAnimation		; $5084

@substate5:
	call itemDecCounter1		; $5087
	ret nz			; $508a
-
	xor a			; $508b
	ld (wLinkInAir),a		; $508c
	jp _initLinkStateAndAnimateStanding		; $508f

@substate6:
	call specialObjectAnimate		; $5092
	call _specialObjectUpdateAdjacentWallsBitset		; $5095
	ld c,$20		; $5098
	call objectUpdateSpeedZ_paramC		; $509a
	jp nz,specialObjectUpdatePosition		; $509d
	call updateLinkLocalRespawnPosition		; $50a0
	jr -		; $50a3

seasonsFunc_05_50a5:
	call objectGetShortPosition		; $50a5
	ld c,a			; $50a8
	ld b,$02		; $50a9
-
	ld a,b			; $50ab
	ld hl,@offsets		; $50ac
	rst_addAToHl		; $50af
	ld a,c			; $50b0
	add (hl)		; $50b1
	ld h,>wRoomCollisions	; $50b2
	ld l,a			; $50b4
	ld a,(hl)		; $50b5
	or a			; $50b6
	jr z,+			; $50b7
	ld a,b			; $50b9
	inc a			; $50ba
	and $03			; $50bb
	ld b,a			; $50bd
	jr -			; $50be
+
	ld h,d			; $50c0
	ld l,SpecialObject.direction		; $50c1
	ld (hl),b		; $50c3
	ld a,b			; $50c4
	swap a			; $50c5
	rrca			; $50c7
	inc l			; $50c8
	ld (hl),a		; $50c9
	ld l,SpecialObject.zh		; $50ca
	ld (hl),$ff		; $50cc
	ld bc,-$300		; $50ce
	call objectSetSpeedZ		; $50d1
	ld l,SpecialObject.speed		; $50d4
	ld (hl),$14		; $50d6
	ld l,SpecialObject.state		; $50d8
	ld (hl),$09		; $50da
	inc l			; $50dc
	ld (hl),$06		; $50dd
	ld a,LINK_ANIM_MODE_FALL		; $50df
	jp specialObjectSetAnimation		; $50e1

@offsets:
	.db $f0 $01 $10 $ff
.endif

;;
; LINK_STATE_GRABBED_BY_WALLMASTER
; @addr{51ec}
_linkState0c:
	ld e,SpecialObject.state2		; $51ec
	ld a,(de)		; $51ee
	rst_jumpTable			; $51ef
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	; Go to substate 1
	ld a,$01		; $51f6
	ld (de),a		; $51f8

	ld (wWarpsDisabled),a		; $51f9

	xor a			; $51fc
	ld e,SpecialObject.collisionType		; $51fd
	ld (de),a		; $51ff

	ld a,$00		; $5200
	ld (wScrollMode),a		; $5202

	call linkCancelAllItemUsage		; $5205

	ld a,SND_BOSS_DEAD		; $5208
	jp playSound		; $520a


; The wallmaster writes [w1Link.state2] = 2 when Link is fully dragged off-screen.
@substate2:
	xor a			; $520d
	ld (wWarpsDisabled),a		; $520e

	ld hl,wWarpDestGroup		; $5211
	ld a,(wActiveGroup)		; $5214
	or $80			; $5217
	ldi (hl),a		; $5219

	; wWarpDestRoom
	ld a,(wDungeonWallmasterDestRoom)		; $521a
	ldi (hl),a		; $521d

	; wWarpDestTransition
	ld a,TRANSITION_DEST_FALL		; $521e
	ldi (hl),a		; $5220

	; wWarpDestPos
	ld a,$87		; $5221
	ldi (hl),a		; $5223

	; wWarpDestTransition2
	ld (hl),$03		; $5224

; Substate 1: waiting for the wallmaster to increment w1Link.state2.
@substate1:
	ret			; $5226

;;
; LINK_STATE_STONE
; Only used in Seasons for the Medusa boss
; @addr{5227}
_linkState13:
	ld a,$80		; $5227
	ld (wForceLinkPushAnimation),a		; $5229

	ld e,SpecialObject.state2		; $522c
	ld a,(de)		; $522e
	rst_jumpTable			; $522f
	.dw @substate0
	.dw @substate1

@substate0:
	call itemIncState2		; $5234

	; [SpecialObject.counter1] = $b4
	inc l			; $5237
	ld (hl),$b4		; $5238

	ld l,SpecialObject.oamFlagsBackup		; $523a
	ld a,$0f		; $523c
	ldi (hl),a		; $523e
	ld (hl),a		; $523f

.ifdef ROM_AGES
	ld a,PALH_7f		; $5240
.else
	ld a,SEASONS_PALH_7f		; $5240
.endif
	call loadPaletteHeader		; $5242

	xor a			; $5245
	ld (wcc50),a		; $5246
	ret			; $5249


; This is used by both _linkState13 and _linkState14.
; Waits for counter1 to reach 0, then restores Link to normal.
@substate1:
	ld c,$40		; $524a
	call objectUpdateSpeedZ_paramC		; $524c
	ld a,(wcc50)		; $524f
	or a			; $5252
	jr z,+			; $5253

	call updateLinkDirectionFromAngle		; $5255

	ld l,SpecialObject.var2a		; $5258
	ld a,(hl)		; $525a
	or a			; $525b
	jr nz,@restoreToNormal		; $525c
+
	; Restore Link to normal more quickly when pressing any button.
	ld c,$01		; $525e
	ld a,(wGameKeysJustPressed)		; $5260
	or a			; $5263
	jr z,+			; $5264
	ld c,$04		; $5266
+
	ld l,SpecialObject.counter1		; $5268
	ld a,(hl)		; $526a
	sub c			; $526b
	ld (hl),a		; $526c
	ret nc			; $526d

@restoreToNormal:
	ld l,SpecialObject.oamFlagsBackup		; $526e
	ld a,$08		; $5270
	ldi (hl),a		; $5272
	ld (hl),a		; $5273

	ld l,SpecialObject.knockbackCounter		; $5274
	ld (hl),$00		; $5276

	xor a			; $5278
	ld (wLinkForceState),a		; $5279
	jp _initLinkStateAndAnimateStanding		; $527c

;;
; LINK_STATE_COLLAPSED
; @addr{527f}
_linkState14:
	ld e,SpecialObject.state2		; $527f
	ld a,(de)		; $5281
	rst_jumpTable			; $5282
	.dw @substate0
	.dw _linkState13@substate1

@substate0:
	call itemIncState2		; $5287

	ld l,SpecialObject.counter1		; $528a
	ld (hl),$f0		; $528c
	call linkCancelAllItemUsage		; $528e

	ld a,(wcc50)		; $5291
	or a			; $5294
	ld a,LINK_ANIM_MODE_COLLAPSED		; $5295
	jr z,+			; $5297
	ld a,LINK_ANIM_MODE_WALK		; $5299
+
	jp specialObjectSetAnimation		; $529b

;;
; LINK_STATE_GRABBED
; Grabbed by Like-like, Gohma, Veran spider form?
; @addr{529e}
_linkState0d:
	ld a,$80		; $529e
	ld (wcc92),a		; $52a0
	ld e,SpecialObject.state2		; $52a3
	ld a,(de)		; $52a5
	rst_jumpTable			; $52a6
	.dw @substate0
	.dw updateLinkDamageTaken
	.dw @substate2
	.dw @substate3
	.dw @substate4

; Initialization
@substate0:
	ld a,$01		; $52b1
	ld (de),a		; $52b3
	ld (wWarpsDisabled),a		; $52b4

	ld e,SpecialObject.animMode		; $52b7
	xor a			; $52b9
	ld (de),a		; $52ba

	jp linkCancelAllItemUsage		; $52bb

; Link has been released, now he's about to fly downwards
@substate2:
	ld a,$03		; $52be
	ld (de),a		; $52c0

	ld h,d			; $52c1
	ld l,SpecialObject.counter1		; $52c2
	ld (hl),$1e		; $52c4

.ifdef ROM_AGES
	ld l,SpecialObject.speedZ		; $52c6
	ld a,$20		; $52c8
	ldi (hl),a		; $52ca
	ld (hl),$fe		; $52cb

	; Face up
	ld l,SpecialObject.direction		; $52cd
	xor a			; $52cf
	ldi (hl),a		; $52d0

	; [SpecialObject.angle] = $10 (move down)
	ld (hl),$10		; $52d1
.else
	ld a,$e8		; $51c2
	ld l,SpecialObject.zh		; $51c4
	ld (hl),a		; $51c6
	ld l,SpecialObject.yh		; $51c7
	cpl			; $51c9
	inc a			; $51ca
	add (hl)		; $51cb
	ld (hl),a		; $51cc
	xor a			; $51cd
	ld l,SpecialObject.speedZ		; $51ce
	ldi (hl),a		; $51d0
	ldi (hl),a		; $51d1
	ld l,SpecialObject.direction		; $51d2
	ldi (hl),a		; $51d4
	; angle
	ld (hl),$0c		; $51d5
.endif

	ld l,SpecialObject.speed		; $52d3
	ld (hl),SPEED_180		; $52d5
	ld a,LINK_ANIM_MODE_GALE		; $52d7
	jp specialObjectSetAnimation		; $52d9

; Continue moving downwards until counter1 reaches 0
@substate3:
	call itemDecCounter1		; $52dc
	jr z,++			; $52df

	ld c,$20		; $52e1
	call objectUpdateSpeedZ_paramC		; $52e3
	call _specialObjectUpdateAdjacentWallsBitset		; $52e6
	call specialObjectUpdatePosition		; $52e9
	jp specialObjectAnimate		; $52ec


; Link is released without anything special.
; ENEMYID_LIKE_LIKE sends Link to this state directly upon release.
@substate4:
	ld h,d			; $52ef
	ld l,SpecialObject.invincibilityCounter		; $52f0
	ld (hl),$94		; $52f2
++
	xor a			; $52f4
	ld (wWarpsDisabled),a		; $52f5
	jp _initLinkStateAndAnimateStanding		; $52f8

;;
; LINK_STATE_SLEEPING
; @addr{52fb}
_linkState05:
	ld e,SpecialObject.state2		; $52fb
	ld a,(de)		; $52fd
	rst_jumpTable			; $52fe
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Just touched the bed
@substate0:
	call itemIncState2		; $5305

	ld l,SpecialObject.speed		; $5308
	ld (hl),SPEED_80		; $530a

	; Set destination position (var37 / var38)
.ifdef ROM_AGES
	ld l,$18		; $530c
.else
	ld l,$13		; $530c
.endif
	ld a,$02		; $530e
	call _specialObjectSetVar37AndVar38		; $5310

	ld bc,-$180		; $5313
	call objectSetSpeedZ		; $5316

	ld a,$81		; $5319
	ld (wLinkInAir),a		; $531b

	ld a,LINK_ANIM_MODE_SLEEPING		; $531e
	jp specialObjectSetAnimation		; $5320

; Jumping into the bed
@substate1:
	call specialObjectAnimate		; $5323
	call _specialObjectSetAngleRelativeToVar38		; $5326
	call objectApplySpeed		; $5329

	ld c,$20		; $532c
	call objectUpdateSpeedZ_paramC		; $532e
	ret nz			; $5331

	call itemIncState2		; $5332
	jp _specialObjectSetPositionToVar38IfSet		; $5335

; Sleeping; do various things depending on "animParameter".
@substate2:
	call specialObjectAnimate		; $5338
	ld h,d			; $533b
	ld l,SpecialObject.animParameter		; $533c
	ld a,(hl)		; $533e
	ld (hl),$00		; $533f
	rst_jumpTable			; $5341
	.dw @animParameter0
	.dw @animParameter1
	.dw @animParameter2
	.dw @animParameter3
	.dw @animParameter4

@animParameter1:
	call darkenRoomLightly		; $534c
	ld a,$06		; $534f
	ld (wPaletteThread_updateRate),a		; $5351
	ret			; $5354

@animParameter2:
	ld hl,wLinkMaxHealth		; $5355
	ldd a,(hl)		; $5358
	ld (hl),a		; $5359

@animParameter0:
	ret			; $535a

@animParameter3:
	jp brightenRoom		; $535b

@animParameter4:
	ld bc,-$180		; $535e
	call objectSetSpeedZ		; $5361

	ld l,SpecialObject.direction		; $5364
.ifdef ROM_AGES
	ld (hl),DIR_LEFT		; $5366
.else
	ld (hl),DIR_RIGHT		; $5366
.endif

	; [SpecialObject.angle] = $18
	inc l			; $5368
.ifdef ROM_AGES
	ld (hl),$18		; $5369
.else
	ld (hl),$08		; $5369
.endif

	ld l,SpecialObject.speed		; $536b
	ld (hl),SPEED_80		; $536d

	ld a,$81		; $536f
	ld (wLinkInAir),a		; $5371
	jp _initLinkStateAndAnimateStanding		; $5374

;;
; LINK_STATE_06
; Moves Link up until he's no longer in a solid wall?
; @addr{5377}
_linkState06:
	ld e,SpecialObject.state2		; $5377
	ld a,(de)		; $5379
	rst_jumpTable			; $537a
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Go to substate 1
	ld a,$01		; $5383
	ld (de),a		; $5385

	ld h,d			; $5386
	ld l,SpecialObject.counter1		; $5387
	ld (hl),$08		; $5389
	ld l,SpecialObject.speed		; $538b
	ld (hl),SPEED_200		; $538d

	; Set angle to "up"
	ld l,SpecialObject.angle		; $538f
	ld (hl),$00		; $5391

	ld a,$81		; $5393
	ld (wLinkInAir),a		; $5395
	ld a,SND_JUMP		; $5398
	call playSound		; $539a

@substate1:
	call specialObjectUpdatePositionWithoutTileEdgeAdjust		; $539d
	call itemDecCounter1		; $53a0
	ret nz			; $53a3

	; Go to substate 2
	ld l,SpecialObject.state2		; $53a4
	inc (hl)		; $53a6

	ld l,SpecialObject.direction		; $53a7
	ld (hl),$00		; $53a9
	ld a,LINK_ANIM_MODE_FALL		; $53ab
	call specialObjectSetAnimation		; $53ad

@substate2:
	call specialObjectAnimate		; $53b0
	ld a,(wScrollMode)		; $53b3
	and $01			; $53b6
	ret z			; $53b8

	call objectCheckTileCollision_allowHoles		; $53b9
	jp c,specialObjectUpdatePositionWithoutTileEdgeAdjust		; $53bc

	ld bc,-$200		; $53bf
	call objectSetSpeedZ		; $53c2

	; Go to substate 3
	ld l,SpecialObject.state2		; $53c5
	inc (hl)		; $53c7

	ld l,SpecialObject.speed		; $53c8
	ld (hl),SPEED_40		; $53ca
	ld a,LINK_ANIM_MODE_JUMP		; $53cc
	call specialObjectSetAnimation		; $53ce

@substate3:
	call specialObjectAnimate		; $53d1
	call _specialObjectUpdateAdjacentWallsBitset		; $53d4
	call specialObjectUpdatePosition		; $53d7
	ld c,$18		; $53da
	call objectUpdateSpeedZ_paramC		; $53dc
	ret nz			; $53df

	xor a			; $53e0
	ld (wLinkInAir),a		; $53e1
	ld (wWarpsDisabled),a		; $53e4
	jp _initLinkStateAndAnimateStanding		; $53e7

.ifdef ROM_AGES
;;
; LINK_STATE_AMBI_POSSESSED_CUTSCENE
; This state is used during the cutscene in the black tower where Ambi gets un-possessed.
; @addr{53ea}
_linkState09:
	ld e,SpecialObject.state2		; $53ea
	ld a,(de)		; $53ec
	rst_jumpTable			; $53ed
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5


; Initialization
@substate0:
	call itemIncState2		; $53fa

; Backing up to the right

	ld l,SpecialObject.speed		; $53fd
	ld (hl),SPEED_100		; $53ff
	ld l,SpecialObject.direction		; $5401
	ld (hl),DIR_LEFT		; $5403

	; [SpecialObject.angle] = $08
	inc l			; $5405
	ld (hl),$08		; $5406

	ld l,SpecialObject.counter1		; $5408
	ld (hl),$0c		; $540a

@substate1:
	call itemDecCounter1		; $540c
	jr nz,@animate	; $540f

; Moving back left

	ld (hl),$0c		; $5411

	; Go to substate 2
	ld l,e			; $5413
	inc (hl)		; $5414

	ld l,SpecialObject.angle		; $5415
	ld (hl),$18		; $5417

@substate2:
	call itemDecCounter1		; $5419
	jr nz,@animate	; $541c

; Looking down

	ld (hl),$32		; $541e

	; Go to substate 3
	ld l,e			; $5420
	inc (hl)		; $5421

	ld l,SpecialObject.direction		; $5422
	ld (hl),DIR_DOWN		; $5424

@substate3:
	call itemDecCounter1		; $5426
	ret nz			; $5429

; Looking up with an exclamation mark

	; Go to substate 4
	ld l,e			; $542a
	inc (hl)		; $542b

	ld l,SpecialObject.direction		; $542c
	ld (hl),DIR_UP		; $542e

	; [SpecialObject.angle] = $10
	inc l			; $5430
	ld (hl),$10		; $5431

	ld l,SpecialObject.counter1		; $5433
	ld a,$1e		; $5435
	ld (hl),a		; $5437

	ld bc,$f4f8		; $5438
	jp objectCreateExclamationMark		; $543b

@substate4:
	call itemDecCounter1		; $543e
	ret nz			; $5441

; Jumping away

	; Go to substate 5
	ld l,e			; $5442
	inc (hl)		; $5443

	ld bc,-$180		; $5444
	call objectSetSpeedZ		; $5447

	ld a,LINK_ANIM_MODE_JUMP		; $544a
	call specialObjectSetAnimation		; $544c
	ld a,SND_JUMP		; $544f
	jp playSound		; $5451

@substate5:
	ld c,$18		; $5454
	call objectUpdateSpeedZ_paramC		; $5456
	jr nz,@animate	; $5459

	; a is 0 at this point
	ld l,SpecialObject.state2		; $545b
	ldd (hl),a		; $545d
	ld (hl),SpecialObject.direction		; $545e
	ret			; $5460

@animate:
	call specialObjectAnimate		; $5461
	jp specialObjectUpdatePositionWithoutTileEdgeAdjust		; $5464

.else

_linkState0f:
	ld e,SpecialObject.state2		; $52ee
	ld a,(de)		; $52f0
	rst_jumpTable		; $52f1
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	ld h,d			; $52fe
	ld l,e			; $52ff
	inc (hl)		; $5300
	inc l			; $5301
	ld (hl),$10		; $5302
	xor a			; $5304
	ld l,SpecialObject.direction		; $5305
	ldi (hl),a		; $5307
	; SpecialObject.angle
	ld (hl),a		; $5308
	call linkCancelAllItemUsageAndClearAdjacentWallsBitset		; $5309
	ld a,$01		; $530c
	ld (wDisableLinkCollisionsAndMenu),a		; $530e
	ld a,LINK_ANIM_MODE_WALK		; $5311
	call specialObjectSetAnimation		; $5313

@substate1:
	call itemDecCounter1		; $5316
	jr nz,@updateObject	; $5319
	ld (hl),$5a		; $531b
	; SpecialObject.state2
	dec l			; $531d
	inc (hl)		; $531e
	ld l,SpecialObject.speed		; $531f
	ld (hl),$14		; $5321
@updateObject:
	call specialObjectAnimate		; $5323
	jp specialObjectUpdatePositionWithoutTileEdgeAdjust		; $5326

@substate2:
	ld h,d			; $5329
	ld l,SpecialObject.counter1		; $532a
	ld a,(hl)		; $532c
	or a			; $532d
	jr z,+			; $532e
	dec (hl)		; $5330
	ret			; $5331
+
	ld h,d			; $5332
	ld l,SpecialObject.yh		; $5333
	ld a,(hl)		; $5335
	cp $74			; $5336
	jr nc,@updateObject	; $5338
	ld l,SpecialObject.state2		; $533a
	inc (hl)		; $533c
	inc l			; $533d
	; SpecialObject.direction
	ld (hl),$60		; $533e
	ld l,SpecialObject.speed		; $5340
	ld (hl),$28		; $5342

@substate3:
	call itemDecCounter1		; $5344
	jr z,++			; $5347
	ld a,(hl)		; $5349
	sub $19			; $534a
	jr c,+			; $534c
	cp $32			; $534e
	ret nc			; $5350
	and $0f			; $5351
	ret nz			; $5353
	ld a,(hl)		; $5354
	swap a			; $5355
	and $01			; $5357
	add a			; $5359
	inc a			; $535a
	ld l,$08		; $535b
	ld (hl),a		; $535d
	ret			; $535e
+
	inc a			; $535f
	ret nz			; $5360
	ld l,SpecialObject.direction		; $5361
	ld (hl),$00		; $5363
	; SpecialObject.angle
	inc l			; $5365
	ld (hl),$10		; $5366
	ld a,$18		; $5368
	ld bc,$f4f8		; $536a
	call objectCreateExclamationMark		; $536d
	ld a,SND_CLINK		; $5370
	jp playSound		; $5372
++
	ld l,e			; $5375
	inc (hl)		; $5376
	ld bc,-$180		; $5377
	call objectSetSpeedZ		; $537a
	ld a,LINK_ANIM_MODE_JUMP		; $537d
	call specialObjectSetAnimation		; $537f
	ld a,SND_JUMP		; $5382
	call playSound		; $5384
@substate4:
	ld c,$18		; $5387
	call objectUpdateSpeedZ_paramC		; $5389
	jr nz,@updateObject	; $538c
	ld l,SpecialObject.state2		; $538e
	inc (hl)		; $5390
	; SpecialObject.counter1
	inc l			; $5391
	ld (hl),$f0		; $5392
	ld a,LINK_ANIM_MODE_WALK		; $5394
	call specialObjectSetAnimation		; $5396
@substate5:
	ld a,(wFrameCounter)		; $5399
	rrca			; $539c
	ret nc			; $539d
	call itemDecCounter1		; $539e
	ret nz			; $53a1
	xor a			; $53a2
	ld (wDisableLinkCollisionsAndMenu),a		; $53a3
	jp _initLinkStateAndAnimateStanding		; $53a6

_linkState10:
	ld e,SpecialObject.state2		; $53a9
	ld a,(de)		; $53ab
	rst_jumpTable			; $53ac
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01		; $53b3
	ld (de),a		; $53b5
	call linkCancelAllItemUsage		; $53b6
	call resetLinkInvincibility		; $53b9
	ld l,SpecialObject.speed		; $53bc
	ld (hl),$14		; $53be
	ld l,SpecialObject.direction		; $53c0
	ld (hl),$00		; $53c2
	; SpecialObject.angle
	inc l			; $53c4
	ld (hl),DIR_UP		; $53c5
	jp _animateLinkStanding		; $53c7

@substate1:
	call specialObjectAnimate		; $53ca
	ld h,d			; $53cd
	ld a,(wFrameCounter)		; $53ce
	and $07			; $53d1
	jr nz,+			; $53d3
	ld l,SpecialObject.speed		; $53d5
	ld a,(hl)		; $53d7
	sub $05			; $53d8
	jr z,+			; $53da
	ld (hl),a		; $53dc
+
	ld a,($cbb3)		; $53dd
	cp $02			; $53e0
	jp nz,specialObjectUpdatePosition		; $53e2
	ld a,(wCutsceneState)		; $53e5
	dec a			; $53e8
	jp nz,_initLinkStateAndAnimateStanding		; $53e9
	ld l,SpecialObject.state2		; $53ec
	inc (hl)		; $53ee
	; SpecialObject.counter1
	inc l			; $53ef
	ld (hl),$20		; $53f0
	ld l,SpecialObject.angle		; $53f2
	ld (hl),$10		; $53f4
	ld l,SpecialObject.speed		; $53f6
	ld (hl),$50		; $53f8

@substate2:
	call specialObjectAnimate		; $53fa
	call itemDecCounter1		; $53fd
	jp nz,specialObjectUpdatePosition		; $5400
	ld hl,$cbb3		; $5403
	inc (hl)		; $5406
	ld a,$02		; $5407
	call fadeoutToWhiteWithDelay		; $5409
	jp _initLinkStateAndAnimateStanding		; $540c
.endif

;;
; LINK_STATE_SQUISHED
; @addr{5467}
_linkState11:
	ld e,SpecialObject.state2		; $5467
	ld a,(de)		; $5469
	rst_jumpTable			; $546a
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01		; $5471
	ld (de),a		; $5473

	call linkCancelAllItemUsage		; $5474

	xor a			; $5477
	ld e,SpecialObject.collisionType		; $5478
	ld (de),a		; $547a

	ld a,SND_DAMAGE_ENEMY		; $547b
	call playSound		; $547d

	; Check whether to do the horizontal or vertical squish animation
	ld a,(wcc50)		; $5480
	and $7f			; $5483
	ld a,LINK_ANIM_MODE_SQUISHX		; $5485
	jr z,+			; $5487
	inc a			; $5489
+
	call specialObjectSetAnimation		; $548a

@substate1:
	call specialObjectAnimate		; $548d

	; Wait for the animation to finish
	ld e,SpecialObject.animParameter		; $5490
	ld a,(de)		; $5492
	inc a			; $5493
	ret nz			; $5494

	call itemIncState2		; $5495
	ld l,SpecialObject.counter1		; $5498
	ld (hl),$14		; $549a

@substate2:
	call specialObjectAnimate		; $549c

	; Invisible every other frame
	ld a,(wFrameCounter)		; $549f
	rrca			; $54a2
	jp c,objectSetInvisible		; $54a3

	call objectSetVisible		; $54a6
	call itemDecCounter1		; $54a9
	ret nz			; $54ac

	ld a,(wcc50)		; $54ad
	bit 7,a			; $54b0
	jr nz,+			; $54b2

	call respawnLink		; $54b4
	jr _checkLinkForceState		; $54b7
+
	ld a,LINK_STATE_DYING		; $54b9
	ld (wLinkForceState),a		; $54bb
	jr _checkLinkForceState		; $54be

;;
; Checks wLinkForceState, and sets Link's state to that value if it's nonzero.
; This also returns from the function that called it if his state changed.
; @addr{54c0}
_checkLinkForceState:
	ld hl,wLinkForceState		; $54c0
	ld a,(hl)		; $54c3
	or a			; $54c4
	ret z			; $54c5

	ld (hl),$00		; $54c6
	pop hl			; $54c8

;;
; Sets w1Link.state to the given value, and w1Link.state2 to $00.
; For some reason, this also runs the code for the state immediately if it's
; LINK_STATE_WARPING, LINK_STATE_GRABBED_BY_WALLMASTER, or LINK_STATE_GRABBED.
;
; @param	a	New value for w1Link.state
; @param	d	Link object
; @addr{54c9}
linkSetState:
	ld h,d			; $54c9
	ld l,SpecialObject.state		; $54ca
	ldi (hl),a		; $54cc
	ld (hl),$00		; $54cd
	cp LINK_STATE_WARPING			; $54cf
	jr z,+			; $54d1

	cp LINK_STATE_GRABBED_BY_WALLMASTER			; $54d3
	jr z,+			; $54d5

	cp LINK_STATE_GRABBED			; $54d7
	ret nz			; $54d9
+
	jp specialObjectCode_link		; $54da

;;
; LINK_STATE_NORMAL
; LINK_STATE_10
; @addr{54dd}
_linkState01:
.ifdef ROM_AGES
_linkState10:
.endif
	; This should prevent Link from ever doing his pushing animation.
	; Under normal circumstances, this should be overwritten with $00 later, allowing
	; him to do his pushing animation when necessary.
	ld a,$80		; $54dd
	ld (wForceLinkPushAnimation),a		; $54df

	; For some reason, Link can't do anything while the palette is changing
	ld a,(wPaletteThread_mode)		; $54e2
	or a			; $54e5
	ret nz			; $54e6

	ld a,(wScrollMode)		; $54e7
	and $0e			; $54ea
	ret nz			; $54ec

	call updateLinkDamageTaken		; $54ed
	ld a,(wLinkDeathTrigger)		; $54f0
	or a			; $54f3
	jp nz,setLinkStateToDead		; $54f4

	; This will return if [wLinkForceState] != 0
	call _checkLinkForceState		; $54f7

	call retIfTextIsActive		; $54fa

	ld a,(wDisabledObjects)		; $54fd
	and $81			; $5500
	ret nz			; $5502

	call decPegasusSeedCounter		; $5503

	ld a,(w1Companion.id)		; $5506
	cp SPECIALOBJECTID_MINECART			; $5509
	jr z,++			; $550b
.ifdef ROM_AGES
	cp SPECIALOBJECTID_RAFT			; $550d
	jr z,++			; $550f
.endif

	; Return if Link is riding an animal?
	ld a,(wLinkObjectIndex)		; $5511
	rrca			; $5514
	ret c			; $5515

	ld a,(wLinkPlayingInstrument)		; $5516
	ld b,a			; $5519
	ld a,(wLinkInAir)		; $551a
	or b			; $551d
	jr nz,++		; $551e

	ld e,SpecialObject.knockbackCounter		; $5520
	ld a,(de)		; $5522
	or a			; $5523
	jr nz,++		; $5524

	; Return if Link interacts with an object
	call linkInteractWithAButtonSensitiveObjects		; $5526
	ret c			; $5529

	; Deal with push blocks, chests, signs, etc. and return if he opened a chest, read
	; a sign, or opened an overworld keyhole?
	call interactWithTileBeforeLink		; $552a
	ret c			; $552d
++
	xor a			; $552e
	ld (wForceLinkPushAnimation),a		; $552f
	ld (wLinkPlayingInstrument),a		; $5532

	ld a,(wTilesetFlags)		; $5535
	and TILESETFLAG_SIDESCROLL			; $5538
	jp nz,_linkState01_sidescroll		; $553a

	; The rest of this code is only run in non-sidescrolling areas.

	; Apply stuff like breakable floors, holes, conveyors, etc.
	call _linkApplyTileTypes		; $553d

	; Let Link move around if a chest spawned on top of him
	call checkAndUpdateLinkOnChest		; $5540

	; Check whether Link pressed A or B to use an item
	call checkUseItems		; $5543

	ld a,(wLinkPlayingInstrument)		; $5546
	or a			; $5549
	ret nz			; $554a

	call _specialObjectUpdateAdjacentWallsBitset		; $554b
	call _linkUpdateKnockback		; $554e

	; Jump if drowning
	ld a,(wLinkSwimmingState)		; $5551
	and $40			; $5554
	jr nz,++		; $5556

	ld a,(wMagnetGloveState)		; $5558
	bit 6,a			; $555b
	jr nz,++		; $555d

	ld a,(wLinkInAir)		; $555f
	or a			; $5562
	jr nz,++		; $5563

	ld a,(wLinkGrabState)		; $5565
	ld c,a			; $5568
	ld a,(wLinkImmobilized)		; $5569
	or c			; $556c
	jr nz,++		; $556d

	call checkLinkPushingAgainstBed		; $556f
.ifdef ROM_SEASONS
	call checkLinkPushingAgainstTreeStump		; $5516
.endif
	call _checkLinkJumpingOffCliff		; $5519
++
	call _linkUpdateInAir		; $5575
	ld a,(wLinkInAir)		; $5578
	or a			; $557b
	jr z,@notInAir			; $557c

	; Link is in the air, either jumping or going down a ledge.

	bit 7,a			; $557e
	jr nz,+			; $5580

	ld e,SpecialObject.speedZ+1		; $5582
	ld a,(de)		; $5584
	bit 7,a			; $5585
	call z,_linkUpdateVelocity		; $5587
+
	ld hl,wcc95		; $558a
	res 4,(hl)		; $558d
	call _specialObjectSetAngleRelativeToVar38		; $558f
	call specialObjectUpdatePosition		; $5592
	jp specialObjectAnimate		; $5595

@notInAir:
	ld a,(wMagnetGloveState)		; $5598
	bit 6,a			; $559b
	jp nz,_animateLinkStanding		; $559d

	ld e,SpecialObject.knockbackCounter		; $55a0
	ld a,(de)		; $55a2
	or a			; $55a3
	jp nz,_func_5631		; $55a4

	ld h,d			; $55a7
	ld l,SpecialObject.collisionType		; $55a8
	set 7,(hl)		; $55aa

	ld a,(wLinkSwimmingState)		; $55ac
	or a			; $55af
	jp nz,_linkUpdateSwimming		; $55b0

	call objectSetVisiblec1		; $55b3
	ld a,(wLinkObjectIndex)		; $55b6
	rrca			; $55b9
.ifdef  ROM_AGES
	jr nc,+			; $55ba


	; This is odd. The "jr z" line below will never jump since 'a' will never be 0.
	; A "cp" opcode instead of "or" would make a lot more sense. Is this a typo?
	; The only difference this makes is that, when on a raft, Link can change
	; directions while swinging his sword / using other items.

	ld a,(w1Companion.id)		; $55bc
	or SPECIALOBJECTID_RAFT			; $55bf
	jr z,@updateDirectionIfNotUsingItem	; $55c1
	jr @updateDirection		; $55c3
+
	; This will return if a transition occurs (pressed B in an underwater area).
	call _checkForUnderwaterTransition		; $55c5
.else
	jr c,@updateDirection	; $5561
.endif
	; Check whether Link is wearing a transformation ring or is a baby
	callab bank6.getTransformedLinkID		; $55c8
	ld a,b			; $55d0
	or a			; $55d1
	jp nz,setLinkIDOverride		; $55d2

.ifdef ROM_AGES
	; Handle movement

	; Check if Link is underwater?
	ld h,d			; $55d5
	ld l,SpecialObject.var2f		; $55d6
	bit 7,(hl)		; $55d8
	jr z,+			; $55da

	; Do mermaid-suit-based movement
	call _linkUpdateVelocity@mermaidSuit		; $55dc
	jr ++			; $55df
+
.endif
	; Check if bits 0-3 of wLinkGrabState == 1 or 2.
	; (Link is grabbing or lifting something. This cancels ice physics.)
	ld a,(wLinkGrabState)		; $55e1
	and $0f			; $55e4
	dec a			; $55e6
	cp $02			; $55e7
	jr c,@normalMovement	; $55e9

	ld hl,wIsTileSlippery		; $55eb
	bit 6,(hl)		; $55ee
	jr z,@normalMovement	; $55f0

	; Slippery tile movement?
	ld c,$88		; $55f2
	call updateLinkSpeed_withParam		; $55f4
	call _linkUpdateVelocity		; $55f7
++
	ld a,(wLinkAngle)		; $55fa
	rlca			; $55fd
	ld c,$02		; $55fe
	jr c,@updateMovement	; $5600
	jr @walking		; $5602

@normalMovement:
	ld a,(wcc95)		; $5604
	ld b,a			; $5607

	ld e,SpecialObject.angle		; $5608
	ld a,(wLinkAngle)		; $560a
	ld (de),a		; $560d

	; Set cflag if in a spinner or wLinkAngle is set. (The latter case just means he
	; isn't moving.)
	or b			; $560e
	rlca			; $560f

	ld c,$00		; $5610
	jr c,@updateMovement	; $5612

	ld c,$01		; $5614
	ld a,(wLinkImmobilized)		; $5616
	or a			; $5619
	jr nz,@updateMovement	; $561a

	call updateLinkSpeed_standard		; $561c

@walking:
	ld c,$07		; $561f

@updateMovement:
	; The value of 'c' here determines whether Link should move, what his animation
	; should be, and whether the heart ring should apply. See the _linkUpdateMovement
	; function for details.
	call _linkUpdateMovement		; $5621

@updateDirectionIfNotUsingItem:
	ld a,(wLinkTurningDisabled)		; $5624
	or a			; $5627
	ret nz			; $5628

@updateDirection:
	jp updateLinkDirectionFromAngle		; $5629

;;
; @addr{562c}
linkResetSpeed:
	ld e,SpecialObject.speed		; $562c
	xor a			; $562e
	ld (de),a		; $562f
	ret			; $5630

;;
; Does something with Link's knockback when on a slippery tile?
; @addr{5631}
_func_5631:
	ld hl,wIsTileSlippery		; $5631
	bit 6,(hl)		; $5634
	ret z			; $5636
	ld e,SpecialObject.knockbackAngle		; $5637
	ld a,(de)		; $5639
	ld e,SpecialObject.angle		; $563a
	ld (de),a		; $563c
	ret			; $563d

;;
; Called once per frame that Link is moving.
;
; @param	a		Bits 0,1 set if Link's y,x offsets should be added to the
;				counter, respectively.
; @param	wTmpcec0	Offsets of Link's movement, to be added to wHeartRingCounter.
; @addr{563e}
_updateHeartRingCounter:
	ld e,a			; $563e
	ld a,(wActiveRing)		; $563f

	; b = number of steps (divided by $100, in pixels) until you get a heart refill.
	; c = number of quarter hearts to refill (times 4).

	ldbc $02,$08		; $5642
	cp HEART_RING_L1			; $5645
	jr z,@heartRingEquipped		; $5647

	cp HEART_RING_L2			; $5649
	jr nz,@clearCounter		; $564b
	ldbc $03,$10		; $564d

@heartRingEquipped:
	ld a,e			; $5650
	or c			; $5651
	ld c,a			; $5652
	push de			; $5653

	; Add Link's y position offset
	ld de,wTmpcec0+1		; $5654
	ld hl,wHeartRingCounter		; $5657
	srl c			; $565a
	call c,@addOffsetsToCounter		; $565c

	; Add Link's x position offset
	ld e,<wTmpcec0+3		; $565f
	ld l,<wHeartRingCounter		; $5661
	srl c			; $5663
	call c,@addOffsetsToCounter		; $5665

	; Check if the counter is high enough for a refill
	pop de			; $5668
	ld a,(wHeartRingCounter+2)		; $5669
	cp b			; $566c
	ret c			; $566d

	; Give hearts if health isn't full already
	ld hl,wLinkHealth		; $566e
	ldi a,(hl)		; $5671
	cp (hl)			; $5672
	ld a,TREASURE_HEART_REFILL		; $5673
	call c,giveTreasure		; $5675

@clearCounter:
	ld hl,wHeartRingCounter		; $5678
	xor a			; $567b
	ldi (hl),a		; $567c
	ldi (hl),a		; $567d
	ldi (hl),a		; $567e
	ret			; $567f

;;
; Adds the position offsets at 'de' to the counter at 'hl'.
; @addr{5680}
@addOffsetsToCounter:
	ld a,(de)		; $5680
	dec e			; $5681
	rlca			; $5682
	jr nc,+			; $5683

	; If moving in a negative direction, negate the offsets so they're positive again
	ld a,(de)		; $5685
	cpl			; $5686
	adc (hl)		; $5687
	ldi (hl),a		; $5688
	inc e			; $5689
	ld a,(de)		; $568a
	cpl			; $568b
	jr ++			; $568c
+
	ld a,(de)		; $568e
	add (hl)		; $568f
	ldi (hl),a		; $5690
	inc e			; $5691
	ld a,(de)		; $5692
++
	adc (hl)		; $5693
	ldi (hl),a		; $5694
	ret nc			; $5695
	inc (hl)		; $5696
	ret			; $5697

;;
; This is called from _linkState01 if [wLinkSwimmingState] != 0.
; Only for non-sidescrolling areas. (See also _linkUpdateSwimming_sidescroll.)
; @addr{5698}
_linkUpdateSwimming:
	ld a,(wLinkSwimmingState)		; $5698
	and $0f			; $569b

	ld hl,wcc95		; $569d
	res 4,(hl)		; $56a0

	rst_jumpTable			; $56a2
	.dw _initLinkState
	.dw _overworldSwimmingState1
	.dw _overworldSwimmingState2
	.dw _overworldSwimmingState3
	.dw _linkUpdateDrowning

;;
; Just entered the water
; @addr{56ad}
_overworldSwimmingState1:
	call linkCancelAllItemUsage		; $56ad
	call _linkSetSwimmingSpeed		; $56b0

.ifdef ROM_AGES
	; Set counter1 to the number of frames to stay in swimmingState2.
	; This is just a period of time during which Link's speed is locked immediately
	; after entering the water.
	ld l,SpecialObject.var2f		; $56b3
	bit 6,(hl)		; $56b5
.endif

	ld l,SpecialObject.counter1		; $56b7
	ld (hl),$0a		; $56b9

.ifdef ROM_AGES
	jr z,+			; $56bb
	ld (hl),$02		; $56bd
+
.endif

	ld a,(wLinkSwimmingState)		; $56bf
	bit 6,a			; $56c2
	jr nz,@drownWithLessInvincibility		; $56c4

.ifdef ROM_AGES
	call _checkSwimmingOverSeawater		; $56c6
	jr z,@drown		; $56c9
.endif

	ld a,TREASURE_FLIPPERS		; $56cb
	call checkTreasureObtained		; $56cd
	ld b,LINK_ANIM_MODE_SWIM		; $56d0
	jr c,@splashAndSetAnimation	; $56d2

@drown:
	ld c,$88		; $56d4
	jr +			; $56d6

@drownWithLessInvincibility:
	ld c,$78		; $56d8
+
	ld a,LINK_STATE_RESPAWNING		; $56da
	ld (wLinkForceState),a		; $56dc
	ld a,$04		; $56df
	ld (wLinkStateParameter),a		; $56e1
	ld a,$80		; $56e4
	ld (wcc92),a		; $56e6

	ld h,d			; $56e9
	ld l,SpecialObject.invincibilityCounter		; $56ea
	ld (hl),c		; $56ec
	ld l,SpecialObject.collisionType		; $56ed
	res 7,(hl)		; $56ef

	ld a,SND_DAMAGE_LINK		; $56f1
	call playSound		; $56f3

	ld b,LINK_ANIM_MODE_DROWN		; $56f6

@splashAndSetAnimation:
	ld hl,wLinkSwimmingState		; $56f8
	ld a,(hl)		; $56fb
	and $f0			; $56fc
	or $02			; $56fe
	ld (hl),a		; $5700
	ld a,b			; $5701
	call specialObjectSetAnimation		; $5702
	jp linkCreateSplash		; $5705

;;
; This is called from _linkUpdateSwimming_sidescroll.
; @addr{5708}
_forceDrownLink:
	ld hl,wLinkSwimmingState		; $5708
	set 6,(hl)		; $570b
	jr _overworldSwimmingState1@drownWithLessInvincibility		; $570d

.ifdef ROM_AGES
;;
; @param[out]	zflag	Set if swimming over seawater (and you have the mermaid suit)
; @addr{570f}
_checkSwimmingOverSeawater:
	ld a,(w1Link.var2f)		; $570f
	bit 6,a			; $5712
	ret nz			; $5714
	ld a,(wActiveTileType)		; $5715
	sub TILETYPE_SEAWATER			; $5718
	ret			; $571a
.endif

;;
; State 2: speed is locked for a few frames after entering the water
; @addr{571b}
_overworldSwimmingState2:
	call itemDecCounter1		; $571b
	jp nz,specialObjectUpdatePosition		; $571e

	ld hl,wLinkSwimmingState		; $5721
	inc (hl)		; $5724

;;
; State 3: the normal state when swimming
; @addr{5725}
_overworldSwimmingState3:
.ifdef ROM_AGES
	call _checkSwimmingOverSeawater		; $5725
	jr z,_overworldSwimmingState1@drown		; $5728
.endif

	call _linkUpdateDiving		; $572a

	; Set Link's visibility layer to normal
	call objectSetVisiblec1		; $572d

	; Enable Link's collisions
	ld h,d			; $5730
	ld l,SpecialObject.collisionType		; $5731
	set 7,(hl)		; $5733

	; Check if Link is diving
	ld a,(wLinkSwimmingState)		; $5735
	rlca			; $5738
	jr nc,+			; $5739

	; If he's diving, disable Link's collisions
	res 7,(hl)		; $573b
	; Draw him behind other sprites
	call objectSetVisiblec3		; $573d
+
	call updateLinkDirectionFromAngle		; $5740

.ifdef ROM_AGES
	; Check whether the flippers or the mermaid suit are in use
	ld h,d			; $5743
	ld l,SpecialObject.var2f		; $5744
	bit 6,(hl)		; $5746
	jr z,+			; $5748

	; Mermaid suit movement
	call _linkUpdateVelocity@mermaidSuit		; $574a
	jp specialObjectUpdatePosition		; $574d
+
.endif
	; Flippers movement
	call _linkUpdateFlippersSpeed		; $5750
	call _func_5933		; $5753
	jp specialObjectUpdatePosition		; $5756


;;
; Deals with Link drowning
; @addr{5759}
_linkUpdateDrowning:
	ld a,$80		; $5759
	ld (wcc92),a		; $575b

	call specialObjectAnimate		; $575e

	ld h,d			; $5761
	xor a			; $5762
	ld l,SpecialObject.collisionType		; $5763
	ld (hl),a		; $5765

	ld l,SpecialObject.animParameter		; $5766
	bit 7,(hl)		; $5768
	ret z			; $576a

	ld (wLinkSwimmingState),a		; $576b

	; Set link's state to LINK_STATE_RESPAWNING; but, set
	; wLinkStateParameter to $02 to trigger only the respawning code, and not
	; anything else.
	ld a,$02		; $576e
	ld (wLinkStateParameter),a		; $5770
	ld a,LINK_STATE_RESPAWNING		; $5773
	jp linkSetState		; $5775

;;
; Sets Link's speed, speedTmp, var12, and var35 variables.
; @addr{5778}
_linkSetSwimmingSpeed:
	ld a,SWIMMERS_RING		; $5778
	call cpActiveRing		; $577a
	ld a,SPEED_e0		; $577d
	jr z,+			; $577f
	ld a,SPEED_80		; $5781
+
	; Set speed, speedTmp to specified value
	ld h,d			; $5783
	ld l,SpecialObject.speed		; $5784
	ldi (hl),a		; $5786
	ldi (hl),a		; $5787

	; [SpecialObject.var12] = $03
	inc l			; $5788
	ld a,$03		; $5789
	ld (hl),a		; $578b

	ld l,SpecialObject.var35		; $578c
	ld (hl),$00		; $578e
	ret			; $5790

;;
; Sets the speedTmp variable in the same way as the above function, but doesn't touch any
; other variables.
; @addr{5791}
_linkSetSwimmingSpeedTmp:
	ld a,SWIMMERS_RING		; $5791
	call cpActiveRing		; $5793
	ld a,SPEED_e0		; $5796
	jr z,+			; $5798
	ld a,SPEED_80		; $579a
+
	ld e,SpecialObject.speedTmp		; $579c
	ld (de),a		; $579e
	ret			; $579f

;;
; @param[out]	a	The angle Link should move in?
; @addr{57a0}
_linkUpdateFlippersSpeed:
	ld e,SpecialObject.var35		; $57a0
	ld a,(de)		; $57a2
	rst_jumpTable			; $57a3
	.dw @flippersState0
	.dw @flippersState1
	.dw @flippersState2

; Swimming with flippers; waiting for Link to press A, if he will at all
@flippersState0:
	ld a,(wGameKeysJustPressed)		; $57aa
	and BTN_A			; $57ad
	jr nz,@pressedA			; $57af

	call _linkSetSwimmingSpeedTmp		; $57b1
	ld a,(wLinkAngle)		; $57b4
	ret			; $57b7

@pressedA:
	; Go to next state
	ld a,$01		; $57b8
	ld (de),a		; $57ba

	ld a,$08		; $57bb
--
	push af			; $57bd
	ld e,SpecialObject.direction		; $57be
	ld a,(de)		; $57c0
	add a			; $57c1
	add a			; $57c2
	add a			; $57c3
	call _func_5933		; $57c4
	pop af			; $57c7
	dec a			; $57c8
	jr nz,--		; $57c9

	ld e,SpecialObject.counter1		; $57cb
	ld a,$0d		; $57cd
	ld (de),a		; $57cf
	ld a,SND_LINK_SWIM		; $57d0
	call playSound		; $57d2


; Accerelating
@flippersState1:
	ldbc $01,$05		; $57d5
	jr ++			; $57d8


; Decelerating
@flippersState2:
	; b: Next state to go to (minus 1)
	; c: Value to add to speedTmp
	ldbc $ff,-5		; $57da
++
	call itemDecCounter1		; $57dd
	jr z,@nextState		; $57e0

	ld a,(hl)		; $57e2
	and $03			; $57e3
	jr z,@accelerate	; $57e5
	jr @returnDirection		; $57e7

@nextState:
	ld l,SpecialObject.var35		; $57e9
	inc b			; $57eb
	ld (hl),b		; $57ec
	jr nz,+			; $57ed

	call _linkSetSwimmingSpeed		; $57ef
	jr @returnDirection		; $57f2
+
	ld l,SpecialObject.counter1		; $57f4
	ld a,$0c		; $57f6
	ld (hl),a		; $57f8

	; Accelerate, or decelerate depending on 'c'.
@accelerate:
	ld l,SpecialObject.speedTmp		; $57f9
	ld a,(hl)		; $57fb
	add c			; $57fc
	bit 7,a			; $57fd
	jr z,+			; $57ff
	xor a			; $5801
+
	ld (hl),a		; $5802

	; Return an angle value based on Link's direction?
@returnDirection:
	ld a,(wLinkAngle)		; $5803
	bit 7,a			; $5806
	ret z			; $5808

	ld e,SpecialObject.direction		; $5809
	ld a,(de)		; $580b
	swap a			; $580c
	rrca			; $580e
	ret			; $580f

;;
; @addr{5810}
_linkUpdateDiving:
	call specialObjectAnimate		; $5810
	ld hl,wLinkSwimmingState		; $5813
.ifdef ROM_AGES
	bit 7,(hl)		; $5816
	jr z,@checkInput			; $5818

	ld a,(wDisableScreenTransitions)		; $581a
	or a			; $581d
	jr nz,@checkInput		; $581e

	ld a,(wActiveTilePos)		; $5820
	ld c,a			; $5823
	ld b,>wRoomLayout		; $5824
	ld a,(bc)		; $5826
	cp TILEINDEX_DEEP_WATER			; $5827
	jp z,_checkForUnderwaterTransition@levelDown		; $5829
.endif

@checkInput:
	ld a,(wGameKeysJustPressed)		; $582c
	bit BTN_BIT_B,a			; $582f
	jr nz,@pressedB		; $5831

	ld a,ZORA_RING		; $5833
	call cpActiveRing		; $5835
	ret z			; $5838

	ld e,SpecialObject.counter2		; $5839
	ld a,(de)		; $583b
	dec a			; $583c
	ld (de),a		; $583d
	jr z,@surface		; $583e
	ret			; $5840

@pressedB:
	bit 7,(hl)		; $5841
	jr z,@dive		; $5843

@surface:
	res 7,(hl)		; $5845
	ld a,LINK_ANIM_MODE_SWIM		; $5847
	jp specialObjectSetAnimation		; $5849

@dive:
	set 7,(hl)		; $584c

	ld e,SpecialObject.counter2		; $584e
	ld a,$78		; $5850
	ld (de),a		; $5852

	call linkCreateSplash		; $5853
	ld a,LINK_ANIM_MODE_DIVE		; $5856
	jp specialObjectSetAnimation		; $5858

;;
; @addr{585b}
_linkUpdateSwimming_sidescroll:
	ld a,(wLinkSwimmingState)		; $585b
	and $0f			; $585e
	jr z,@swimmingState0	; $5860

	ld hl,wcc95		; $5862
	res 4,(hl)		; $5865

	rst_jumpTable			; $5867
	.dw @swimmingState0
	.dw @swimmingState1
	.dw @swimmingState2
	.dw _linkUpdateDrowning

; Not swimming
@swimmingState0:
	jp _initLinkState		; $5870


; Just entered the water
@swimmingState1:
	call linkCancelAllItemUsage		; $5873

	ld hl,wLinkSwimmingState		; $5876
	inc (hl)		; $5879

	call _linkSetSwimmingSpeed		; $587a
	call objectSetVisiblec1		; $587d

	ld a,TREASURE_FLIPPERS		; $5880
	call checkTreasureObtained		; $5882
	jr nc,@drown			; $5885

.ifdef ROM_AGES
	ld hl,w1Link.var2f		; $5887
	bit 6,(hl)		; $588a
	ld a,LINK_ANIM_MODE_SWIM_2D		; $588c
	jr z,++			; $588e

	set 7,(hl)		; $5890
	ld a,LINK_ANIM_MODE_MERMAID		; $5892
	jr ++			; $5894
.else
	ld a,LINK_ANIM_MODE_SWIM_2D		; $57d5
	jr ++			; $57d7
.endif


@drown:
	ld a,$03		; $5896
	ld (wLinkSwimmingState),a		; $5898
	ld a,LINK_ANIM_MODE_DROWN		; $589b
++
	jp specialObjectSetAnimation		; $589d


; Link remains in this state until he exits the water
@swimmingState2:
	xor a			; $58a0
	ld (wLinkInAir),a		; $58a1

	ld h,d			; $58a4
	ld l,SpecialObject.collisionType		; $58a5
	set 7,(hl)		; $58a7
	ld a,(wLinkImmobilized)		; $58a9
	or a			; $58ac
	jr nz,+++		; $58ad

	; Jump if Link isn't moving ([w1LinkAngle] == $ff)
	ld l,SpecialObject.direction		; $58af
	ld a,(wLinkAngle)		; $58b1
	add a			; $58b4
	jr c,+			; $58b5

	; Jump if Link's angle is going directly up or directly down (so, don't modify his
	; current facing direction)
	ld c,a			; $58b7
	and $18			; $58b8
	jr z,+			; $58ba

	; Set Link's facing direction based on his angle
	ld a,c			; $58bc
	swap a			; $58bd
	and $03			; $58bf
	ld (hl),a		; $58c1
+
	; Ensure that he's facing either left or right (not up or down)
	set 0,(hl)		; $58c2

.ifdef ROM_AGES
	; Jump if Link does not have the mermaid suit (only flippers)
	ld l,SpecialObject.var2f		; $58c4
	bit 6,(hl)		; $58c6
	jr z,+			; $58c8

	; Mermaid suit movement
	call _linkUpdateVelocity@mermaidSuit		; $58ca
	jr ++			; $58cd
+
.endif
	; Flippers movement
	call _linkUpdateFlippersSpeed		; $58cf
	call _func_5933		; $58d2
++
	call specialObjectUpdatePosition		; $58d5
+++
	; When counter2 goes below 0, create a bubble
	ld h,d			; $58d8
	ld l,SpecialObject.counter2		; $58d9
	dec (hl)		; $58db
	bit 7,(hl)		; $58dc
	jr z,+			; $58de

	; Wait between 50-81 frames before creating the next bubble
	call getRandomNumber		; $58e0
	and $1f			; $58e3
	add 50			; $58e5
	ld (hl),a		; $58e7

	ld b,INTERACID_BUBBLE		; $58e8
	call objectCreateInteractionWithSubid00		; $58ea
+
	jp specialObjectAnimate		; $58ed

;;
; Updates speed and angle for things like ice, jumping, underwater? (Things where he
; accelerates and decelerates)
; @addr{58f0}
_linkUpdateVelocity:
.ifdef ROM_AGES
	ld a,(wTilesetFlags)		; $58f0
	and TILESETFLAG_UNDERWATER			; $58f3
	jr z,@label_05_159	; $58f5

@mermaidSuit:
	ld c,$98		; $58f7
	call updateLinkSpeed_withParam		; $58f9
	ld a,(wActiveRing)		; $58fc
	cp SWIMMERS_RING			; $58ff
	jr nz,+			; $5901

	ld e,SpecialObject.speedTmp		; $5903
	ld a,SPEED_160		; $5905
	ld (de),a		; $5907
+
	ld h,d			; $5908
	ld a,(wLinkImmobilized)		; $5909
	or a			; $590c
	jr nz,+			; $590d

	ld a,(wGameKeysJustPressed)		; $590f
	and (BTN_UP | BTN_RIGHT | BTN_DOWN | BTN_LEFT)			; $5912
	jr nz,@directionButtonPressed	; $5914
+
	ld l,SpecialObject.var3e		; $5916
	dec (hl)		; $5918
	bit 7,(hl)		; $5919
	jr z,++			; $591b

	ld a,$ff		; $591d
	ld (hl),a		; $591f
	jr _func_5933			; $5920

@directionButtonPressed:
	ld a,SND_SPLASH		; $5922
	call playSound		; $5924
	ld h,d			; $5927
	ld l,SpecialObject.var3e		; $5928
	ld (hl),$04		; $592a
++
	ld l,SpecialObject.var12		; $592c
	ld (hl),$14		; $592e
.endif

@label_05_159:
	ld a,(wLinkAngle)		; $5930

;;
; @param a
; @addr{5933}
_func_5933:
	ld e,a			; $5933
	ld h,d			; $5934
	ld l,SpecialObject.angle		; $5935
	bit 7,(hl)		; $5937
	jr z,+			; $5939

	ld (hl),e		; $593b
	ret			; $593c
+
	bit 7,a			; $593d
	jr nz,@label_05_162	; $593f
	sub (hl)		; $5941
	add $04			; $5942
	and $1f			; $5944
	cp $09			; $5946
	jr c,@label_05_164	; $5948
	sub $10			; $594a
	cp $09			; $594c
	jr c,@label_05_163	; $594e
	ld bc,$0100		; $5950
	bit 7,a			; $5953
	jr nz,@label_05_165	; $5955
	ld b,$ff		; $5957
	jr @label_05_165		; $5959
@label_05_162:
	ld bc,$00fb		; $595b
	ld a,(wLinkInAir)		; $595e
	or a			; $5961
	jr z,@label_05_165	; $5962
	ld c,b			; $5964
	jr @label_05_165		; $5965
@label_05_163:
	ld bc,$01fb		; $5967
	cp $03			; $596a
	jr c,@label_05_165	; $596c
	ld b,$ff		; $596e
	cp $06			; $5970
	jr nc,@label_05_165	; $5972
	ld a,e			; $5974
	xor $10			; $5975
	ld (hl),a		; $5977
	ld b,$00		; $5978
	jr @label_05_165		; $597a
@label_05_164:
	ld bc,$ff05		; $597c
	cp $03			; $597f
	jr c,@label_05_165	; $5981
	ld b,$01		; $5983
	cp $06			; $5985
	jr nc,@label_05_165	; $5987
	ld a,e			; $5989
	ld (hl),a		; $598a
	ld b,$00		; $598b
@label_05_165:
	ld l,SpecialObject.var12		; $598d
	inc (hl)		; $598f
	ldi a,(hl)		; $5990
	cp (hl)			; $5991
	ret c			; $5992

	; Set SpecialObject.speedTmp to $00
	dec l			; $5993
	ld (hl),$00		; $5994

	ld l,SpecialObject.angle		; $5996
	ld a,(hl)		; $5998
	add b			; $5999
	and $1f			; $599a
	ld (hl),a		; $599c
	ld l,SpecialObject.speedTmp		; $599d
	ldd a,(hl)		; $599f
	ld b,a			; $59a0
	ld a,(hl)		; $59a1
	add c			; $59a2
	jr z,++			; $59a3
	bit 7,a			; $59a5
	jr nz,++		; $59a7

	cp b			; $59a9
	jr c,+			; $59aa
	ld a,b			; $59ac
+
	ld (hl),a		; $59ad
	ret			; $59ae
++
	ld l,SpecialObject.speed		; $59af
	xor a			; $59b1
	ldi (hl),a		; $59b2
	inc l			; $59b3
	ld (hl),l		; $59b4
	dec a			; $59b5
	ld l,SpecialObject.angle		; $59b6
	ld (hl),a		; $59b8
	ret			; $59b9

;;
; linkState01 code, only for sidescrolling areas.
; @addr{59ba}
_linkState01_sidescroll:
	call _sidescrollUpdateActiveTile		; $59ba
	ld a,(wActiveTileType)		; $59bd
	bit TILETYPE_SS_BIT_WATER,a			; $59c0
	jr z,@notInWater		; $59c2

.ifdef ROM_AGES
	; In water

	ld h,d			; $59c4
	ld l,SpecialObject.var2f		; $59c5
	bit 6,(hl)		; $59c7
	jr z,+			; $59c9
	set 7,(hl)		; $59cb
+
.endif
	; If link was in water last frame, don't create a splash
	ld a,(wLinkSwimmingState)		; $59cd
	or a			; $59d0
	jr nz,++		; $59d1

	; Otherwise, he's just entering the water; create a splash
	inc a			; $59d3
	ld (wLinkSwimmingState),a		; $59d4
	call linkCreateSplash		; $59d7
	jr ++			; $59da

@notInWater:
	; Set WLinkSwimmingState to $00, and jump if he wasn't in water last frame
	ld hl,wLinkSwimmingState		; $59dc
	ld a,(hl)		; $59df
	ld (hl),$00		; $59e0
	or a			; $59e2
	jr z,++			; $59e3

	; He was in water last frame.

	; Skip the below code if he surfaced from an underwater ladder tile.
	ld a,(wLastActiveTileType)		; $59e5
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_WATER)	; $59e8
	jr z,++			; $59ea

	; Make him "hop out" of the water.

	ld a,$02		; $59ec
	ld (wLinkInAir),a		; $59ee
	call linkCreateSplash		; $59f1

	ld bc,-$1a0		; $59f4
	call objectSetSpeedZ		; $59f7

	ld a,(wLinkAngle)		; $59fa
	ld l,SpecialObject.angle		; $59fd
	ld (hl),a		; $59ff

++
	call checkUseItems		; $5a00

	ld a,(wLinkPlayingInstrument)		; $5a03
	or a			; $5a06
	ret nz			; $5a07

	call _specialObjectUpdateAdjacentWallsBitset		; $5a08
	call _linkUpdateKnockback		; $5a0b

	ld a,(wLinkSwimmingState)		; $5a0e
	or a			; $5a11
	jp nz,_linkUpdateSwimming_sidescroll		; $5a12

	ld a,(wMagnetGloveState)		; $5a15
	bit 6,a			; $5a18
	jp z,+			; $5a1a

	xor a			; $5a1d
	ld (wLinkInAir),a		; $5a1e
	jp _animateLinkStanding		; $5a21
+
	call _linkUpdateInAir_sidescroll		; $5a24
	ret z			; $5a27

	ld e,SpecialObject.knockbackCounter		; $5a28
	ld a,(de)		; $5a2a
	or a			; $5a2b
	ret nz			; $5a2c

	ld a,(wActiveTileIndex)		; $5a2d
	cp TILEINDEX_SS_SPIKE			; $5a30
	call z,_dealSpikeDamageToLink		; $5a32

	ld a,(wForceIcePhysics)		; $5a35
	or a			; $5a38
	jr z,+			; $5a39

	ld e,SpecialObject.adjacentWallsBitset		; $5a3b
	ld a,(de)		; $5a3d
	and $30			; $5a3e
	jr nz,@onIce		; $5a40
+
	ld a,(wLastActiveTileType)		; $5a42
	cp TILETYPE_SS_ICE			; $5a45
	jr nz,@notOnIce		; $5a47

@onIce:
	ld a,SNOWSHOE_RING		; $5a49
	call cpActiveRing		; $5a4b
	jr z,@notOnIce		; $5a4e

	ld c,$88		; $5a50
	call updateLinkSpeed_withParam		; $5a52

	ld a,$06		; $5a55
	ld (wForceIcePhysics),a		; $5a57

	call _linkUpdateVelocity		; $5a5a

	ld c,$02		; $5a5d
	ld a,(wLinkAngle)		; $5a5f
	rlca			; $5a62
	jr c,++			; $5a63
	jr +			; $5a65

@notOnIce:
	xor a			; $5a67
	ld (wForceIcePhysics),a		; $5a68
	ld c,a			; $5a6b
	ld a,(wLinkAngle)		; $5a6c
	ld e,SpecialObject.angle		; $5a6f
	ld (de),a		; $5a71
	rlca			; $5a72
	jr c,++			; $5a73

	call updateLinkSpeed_standard		; $5a75

	; Parameter for _linkUpdateMovement (update his animation only; don't update his
	; position)
	ld c,$01		; $5a78

	ld a,(wLinkImmobilized)		; $5a7a
	or a			; $5a7d
	jr nz,++		; $5a7e
+
	; Parameter for _linkUpdateMovement (update everything, including his position)
	ld c,$07		; $5a80
++
	; When not in the water or in other tiles with particular effects, adjust Link's
	; angle so that he moves purely horizontally.
	ld hl,wActiveTileType		; $5a82
	ldi a,(hl)		; $5a85
	or (hl)			; $5a86
	and $ff~TILETYPE_SS_ICE			; $5a87
	call z,_linkAdjustAngleInSidescrollingArea		; $5a89

	call _linkUpdateMovement		; $5a8c

	; The following checks are for whether to cap Link's y position so he doesn't go
	; above a certain point.

	ld e,SpecialObject.angle		; $5a8f
	ld a,(de)		; $5a91
	add $04			; $5a92
	and $1f			; $5a94
	cp $09			; $5a96
	jr nc,++	; $5a98

	; Allow him to move up if the tile he's in has any special properties?
	ld hl,wActiveTileType		; $5a9a
	ldi a,(hl)		; $5a9d
	or a			; $5a9e
	jr nz,++	; $5a9f

	; Allow him to move up if the tile he's standing on is NOT the top of a ladder?
	ld a,(hl)		; $5aa1
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_LADDER_TOP)	; $5aa2
	jr nz,++	; $5aa4

	; Check if Link's y position within the tile is lower than 9
	ld e,SpecialObject.yh		; $5aa6
	ld a,(de)		; $5aa8
	and $0f			; $5aa9
	cp $09			; $5aab
	jr nc,++	; $5aad

	; If it's lower than 9, set it back to 9
	ld a,(de)		; $5aaf
	and $f0			; $5ab0
	add $09			; $5ab2
	ld (de),a		; $5ab4

++
	; Don't climb a ladder if Link is touching the ground
	ld e,SpecialObject.adjacentWallsBitset		; $5ab5
	ld a,(de)		; $5ab7
	and $30			; $5ab8
	jr nz,+			; $5aba

	ld a,(wActiveTileType)		; $5abc
	bit TILETYPE_SS_BIT_LADDER,a			; $5abf
	jr z,+			; $5ac1

	; Climbing a ladder
	ld a,$01		; $5ac3
	ld (wLinkClimbingVine),a		; $5ac5
+
	ld a,(wLinkTurningDisabled)		; $5ac8
	or a			; $5acb
	ret nz			; $5acc
	jp updateLinkDirectionFromAngle		; $5acd

;;
; Updates Link's animation and position based on his current speed and angle variables,
; among other things.
; @param c Bit 0: Set if Link's animation should be "walking" instead of "standing".
;          Bit 1: Set if Link's position should be updated based on his speed and angle.
;          Bit 2: Set if the heart ring's regeneration should be applied (if he moves).
; @addr{5ad0}
_linkUpdateMovement:
	ld a,c			; $5ad0

	; Check whether to animate him "standing" or "walking"
	rrca			; $5ad1
	push af			; $5ad2
	jr c,+			; $5ad3
	call _animateLinkStanding		; $5ad5
	jr ++			; $5ad8
+
	call _animateLinkWalking		; $5ada
++
	pop af			; $5add

	; Check whether to update his position
	rrca			; $5ade
	jr nc,++		; $5adf

	push af			; $5ae1
	call specialObjectUpdatePosition		; $5ae2
	jr z,+			; $5ae5

	ld c,a			; $5ae7
	pop af			; $5ae8

	; Check whether to update the heart ring counter
	rrca			; $5ae9
	ret nc			; $5aea

	ld a,c			; $5aeb
	jp _updateHeartRingCounter		; $5aec
+
	pop af			; $5aef
++
	jp linkResetSpeed		; $5af0

;;
; Only for top-down sections. (See also _linkUpdateInAir_sidescroll.)
; @addr{5af3}
_linkUpdateInAir:
	ld a,(wLinkInAir)		; $5af3
	and $0f			; $5af6
	rst_jumpTable			; $5af8
	.dw @notInAir
	.dw @startedJump
	.dw @inAir

@notInAir:
	; Ensure that bit 1 of wLinkInAir is set if Link's z position is < 0.
	ld h,d			; $5aff
	ld l,SpecialObject.zh		; $5b00
	bit 7,(hl)		; $5b02
	ret z			; $5b04

	ld a,$02		; $5b05
	ld (wLinkInAir),a		; $5b07
	jr ++			; $5b0a

@startedJump:
	ld hl,wLinkInAir		; $5b0c
	inc (hl)		; $5b0f
	bit 7,(hl)		; $5b10
	jr nz,+			; $5b12

	ld hl,wIsTileSlippery		; $5b14
	bit 6,(hl)		; $5b17
	jr nz,+			; $5b19

	ld l,<wActiveTileType		; $5b1b
	ld (hl),TILETYPE_NORMAL		; $5b1d
	call updateLinkSpeed_standard		; $5b1f

	ld a,(wLinkAngle)		; $5b22
	ld e,SpecialObject.angle		; $5b25
	ld (de),a		; $5b27
+
	ld a,SND_JUMP		; $5b28
	call playSound		; $5b2a
++
	; Set jumping animation if he's not holding anything or using an item
	ld a,(wLinkGrabState)		; $5b2d
	ld c,a			; $5b30
	ld a,(wLinkTurningDisabled)		; $5b31
	or c			; $5b34
	ld a,LINK_ANIM_MODE_JUMP		; $5b35
	call z,specialObjectSetAnimation		; $5b37

@inAir:
	xor a			; $5b3a
	ld e,SpecialObject.var12		; $5b3b
	ld (de),a		; $5b3d
	inc e			; $5b3e
	ld (de),a		; $5b3f

	; If bit 7 of wLinkInAir is set, allow him to pass through walls (needed for
	; moving through cliff tiles?)
	ld hl,wLinkInAir		; $5b40
	bit 7,(hl)		; $5b43
	jr z,+			; $5b45
	ld e,SpecialObject.adjacentWallsBitset		; $5b47
	ld (de),a		; $5b49
+
	; Set 'c' to the gravity value. Reduce if bit 5 of wLinkInAir is set?
	bit 5,(hl)		; $5b4a
	ld c,$20		; $5b4c
	jr z,+			; $5b4e
	ld c,$0a		; $5b50
+
	call objectUpdateSpeedZ_paramC		; $5b52

	ld l,SpecialObject.speedZ+1		; $5b55
	jr z,@landed			; $5b57

	; Still in the air

	; Return if speedZ is negative
	ld a,(hl)		; $5b59
	bit 7,a			; $5b5a
	ret nz			; $5b5c

	; Return if speedZ < $0300
	cp $03			; $5b5d
	ret c			; $5b5f

	; Cap speedZ to $0300
	ld (hl),$03		; $5b60
	dec l			; $5b62
	ld (hl),$00		; $5b63
	ret			; $5b65

@landed:
	; Set speedZ and wLinkInAir to 0
	xor a			; $5b66
	ldd (hl),a		; $5b67
	ld (hl),a		; $5b68
	ld (wLinkInAir),a		; $5b69

	ld e,SpecialObject.var36		; $5b6c
	ld (de),a		; $5b6e

	call _animateLinkStanding		; $5b6f
	call _specialObjectSetPositionToVar38IfSet		; $5b72
	call _linkApplyTileTypes		; $5b75

	; Check if wActiveTileType is TILETYPE_HOLE or TILETYPE_WARPHOLE
	ld a,(wActiveTileType)		; $5b78
	dec a			; $5b7b
	cp TILETYPE_WARPHOLE			; $5b7c
	jr nc,+			; $5b7e

	; If it's a hole tile, initialize this
	ld a,$04		; $5b80
	ld (wStandingOnTileCounter),a		; $5b82
+
	ld a,SND_LAND		; $5b85
	call playSound		; $5b87
	call _specialObjectUpdateAdjacentWallsBitset		; $5b8a
	jp _initLinkState		; $5b8d

;;
; @param[out]	zflag	If set, _linkState01_sidescroll will return prematurely.
; @addr{5b90}
_linkUpdateInAir_sidescroll:
	ld a,(wLinkInAir)		; $5b90
	and $0f			; $5b93
	rst_jumpTable			; $5b95
	.dw @notInAir
	.dw @jumping
	.dw @inAir

@notInAir:
	ld a,(wLinkRidingObject)		; $5b9c
	or a			; $5b9f
	ret nz			; $5ba0

	; Return if Link is on solid ground
	ld e,SpecialObject.adjacentWallsBitset		; $5ba1
	ld a,(de)		; $5ba3
	and $30			; $5ba4
	ret nz			; $5ba6

	; Return if Link's current tile, or the one he's standing on, is a ladder.
	ld hl,wActiveTileType		; $5ba7
	ldi a,(hl)		; $5baa
	or (hl)			; $5bab
	bit TILETYPE_SS_BIT_LADDER,a			; $5bac
	ret nz			; $5bae

	; Link is in the air.
	ld h,d			; $5baf
	ld l,SpecialObject.speedZ		; $5bb0
	xor a			; $5bb2
	ldi (hl),a		; $5bb3
	ldi (hl),a		; $5bb4
	jr +			; $5bb5

@jumping:
	ld a,SND_JUMP		; $5bb7
	call playSound		; $5bb9
+
	ld a,(wLinkGrabState)		; $5bbc
	ld c,a			; $5bbf
	ld a,(wLinkTurningDisabled)		; $5bc0
	or c			; $5bc3
	ld a,LINK_ANIM_MODE_JUMP		; $5bc4
	call z,specialObjectSetAnimation		; $5bc6

	ld a,$02		; $5bc9
	ld (wLinkInAir),a		; $5bcb
	call updateLinkSpeed_standard		; $5bce

@inAir:
	ld h,d			; $5bd1
	ld l,SpecialObject.speedZ+1		; $5bd2
	bit 7,(hl)		; $5bd4
	jr z,@positiveSpeedZ			; $5bd6

	; If speedZ is negative, check if he hits the ceiling
	ld e,SpecialObject.adjacentWallsBitset		; $5bd8
	ld a,(de)		; $5bda
	and $c0			; $5bdb
	jr nz,@applyGravity	; $5bdd
	jr @applySpeedZ		; $5bdf

@positiveSpeedZ:
	ld a,(wLinkRidingObject)		; $5be1
	or a			; $5be4
	jp nz,@playingInstrument		; $5be5

	; Check if Link is on solid ground
	ld e,SpecialObject.adjacentWallsBitset		; $5be8
	ld a,(de)		; $5bea
	and $30			; $5beb
	jp nz,@landedOnGround		; $5bed

	; Check if Link presses up on a ladder; this will put him back into a ground state
	ld a,(wActiveTileType)		; $5bf0
	bit TILETYPE_SS_BIT_LADDER,a			; $5bf3
	jr z,+			; $5bf5

	ld a,(wGameKeysPressed)		; $5bf7
	and BTN_UP			; $5bfa
	jp nz,@landed		; $5bfc
+
	ld e,SpecialObject.yh		; $5bff
	ld a,(de)		; $5c01
	bit 3,a			; $5c02
	jr z,+			; $5c04

	ld a,(wLastActiveTileType)		; $5c06
	cp (TILETYPE_SS_LADDER | TILETYPE_SS_LADDER_TOP)	; $5c09
	jr z,@landedOnGround	; $5c0b
+
	ld hl,wActiveTileType		; $5c0d
	ldi a,(hl)		; $5c10
	cp TILETYPE_SS_LAVA			; $5c11
	jp z,_forceDrownLink		; $5c13

	; Check if he's ended up in a hole
	cp TILETYPE_SS_HOLE			; $5c16
	jr nz,++		; $5c18

	; Check the tile below link? (In this case, since wLastActiveTileType is the tile
	; 8 pixels below him, this will probably be the same as wActiveTile, UNTIL he
	; reaches the center of the tile. At which time, if the tile beneath has
	; a tileType of $00, Link will respawn.
	ld a,(hl)		; $5c1a
	or a			; $5c1b
	jr nz,++		; $5c1c

	; Damage Link and respawn him.
	ld a,SND_DAMAGE_LINK		; $5c1e
	call playSound		; $5c20
	jp respawnLink		; $5c23

++
	call _linkUpdateVelocity		; $5c26

@applySpeedZ:
	; Apply speedZ to Y position
	ld l,SpecialObject.y		; $5c29
	ld e,SpecialObject.speedZ		; $5c2b
	ld a,(de)		; $5c2d
	add (hl)		; $5c2e
	ldi (hl),a		; $5c2f
	inc e			; $5c30
	ld a,(de)		; $5c31
	adc (hl)		; $5c32
	ldi (hl),a		; $5c33

@applyGravity:
	; Set 'c' to the gravity value (value to add to speedZ).
	ld c,$24		; $5c34
	ld a,(wLinkInAir)		; $5c36
	bit 5,a			; $5c39
	jr z,+			; $5c3b
	ld c,$0e		; $5c3d
+
	ld l,SpecialObject.speedZ		; $5c3f
	ld a,(hl)		; $5c41
	add c			; $5c42
	ldi (hl),a		; $5c43
	ld a,(hl)		; $5c44
	adc $00			; $5c45
	ldd (hl),a		; $5c47

	; Cap Link's speedZ to $0300
	bit 7,a			; $5c48
	jr nz,+			; $5c4a
	cp $03			; $5c4c
	jr c,+			; $5c4e
	xor a			; $5c50
	ldi (hl),a		; $5c51
	ld (hl),$03		; $5c52
+
	call _specialObjectUpdateAdjacentWallsBitset		; $5c54

	; Check (again) whether Link has reached the ground.
	ld e,SpecialObject.adjacentWallsBitset		; $5c57
	ld a,(de)		; $5c59
	and $30			; $5c5a
	jr nz,@landedOnGround	; $5c5c

	; Adjusts Link's angle so he doesn't move (on his own) on the y axis.
	; This is confusing since he has a Z speed, which gets applied to the Y axis. All
	; this does is prevent Link's movement from affecting the Y axis; it still allows
	; his Z speed to be applied.
	; Disabling this would give him some control over the height of his jumps.
	call _linkAdjustAngleInSidescrollingArea		; $5c5e

	call specialObjectUpdatePosition		; $5c61
	call specialObjectAnimate		; $5c64

	; Check if Link's reached the bottom boundary of the room?
	ld e,SpecialObject.yh		; $5c67
	ld a,(de)		; $5c69
	cp $a9			; $5c6a
	jr c,@notLanded	; $5c6c
.ifdef ROM_AGES
	jr @landedOnGround		; $5c6e
.else
	ld a,(wActiveTileType)		; $5b5d
	cp TILETYPE_SS_LADDER			; $5b60
	jr nz,@notLanded	; $5b62
	ld a,$80 | DIR_DOWN		; $5b64
	ld (wScreenTransitionDirection),a		; $5b66
.endif

@notLanded:
	xor a			; $5c70
	ret			; $5c71

@landedOnGround:
	; Lock his y position to the 9th pixel on that tile.
	ld e,SpecialObject.yh		; $5c72
	ld a,(de)		; $5c74
	and $f8			; $5c75
	add $01			; $5c77
	ld (de),a		; $5c79

@landed:
	xor a			; $5c7a
	ld e,SpecialObject.speedZ		; $5c7b
	ld (de),a		; $5c7d
	inc e			; $5c7e
	ld (de),a		; $5c7f

	ld (wLinkInAir),a		; $5c80

	; Check if he landed on a spike
	ld a,(wActiveTileIndex)		; $5c83
	cp TILEINDEX_SS_SPIKE			; $5c86
	call z,_dealSpikeDamageToLink		; $5c88

	ld a,SND_LAND		; $5c8b
	call playSound		; $5c8d
	call _animateLinkStanding		; $5c90
	xor a			; $5c93
	ret			; $5c94

@playingInstrument:
	ld e,SpecialObject.var12		; $5c95
	xor a			; $5c97
	ld (de),a		; $5c98

	; Write $ff to the variable that you just wrote $00 to? OK, game.
	ld a,$ff		; $5c99
	ld (de),a		; $5c9b

	ld e,SpecialObject.angle		; $5c9c
	ld (de),a		; $5c9e
	jr @landed		; $5c9f

;;
; Sets link's state to LINK_STATE_NORMAL, sets var35 to $00
; @addr{5ca1}
_initLinkState:
	ld h,d			; $5ca1
	ld l,<w1Link.state		; $5ca2
	ld (hl),LINK_STATE_NORMAL		; $5ca4
	inc l			; $5ca6
	ld (hl),$00		; $5ca7
	ld l,<w1Link.var35		; $5ca9
	ld (hl),$00		; $5cab
	ret			; $5cad

;;
; @addr{5cae}
_initLinkStateAndAnimateStanding:
	call _initLinkState		; $5cae
	ld l,<w1Link.visible	; $5cb1
	set 7,(hl)		; $5cb3
;;
; @addr{5cb5}
_animateLinkStanding:
	ld e,<w1Link.animMode	; $5cb5
	ld a,(de)		; $5cb7
	cp LINK_ANIM_MODE_WALK	; $5cb8
	jr nz,+			; $5cba

	call checkPegasusSeedCounter		; $5cbc
	jr nz,_animateLinkWalking		; $5cbf
+
	; If not using pegasus seeds, set animMode to 0. At the end of the function, this
	; will be changed back to LINK_ANIM_MODE_WALK; this will simply cause the
	; animation to be reset, resulting in him staying on the animation's first frame.
	xor a			; $5cc1
	ld (de),a		; $5cc2

;;
; @addr{5cc3}
_animateLinkWalking:
	call checkPegasusSeedCounter		; $5cc3
	jr z,++			; $5cc6

	rlca			; $5cc8
	jr nc,++		; $5cc9

	; This has to do with the little puffs appearing at link's feet
	ld hl,w1ReservedItemF		; $5ccb
	ld a,$03		; $5cce
	ldi (hl),a		; $5cd0
	ld (hl),ITEMID_DUST		; $5cd1
	inc l			; $5cd3
	inc (hl)		; $5cd4

	ld a,SND_LAND		; $5cd5
	call playSound		; $5cd7
++
	ld h,d			; $5cda
	ld a,$10	; $5cdb
	ld l,<w1Link.animMode	; $5cdd
	cp (hl)			; $5cdf
	jp nz,specialObjectSetAnimation		; $5ce0
	jp specialObjectAnimate		; $5ce3

;;
; @addr{5ce6}
updateLinkSpeed_standard:
	ld c,$00		; $5ce6

;;
; @param	c	Bit 7 set if speed shouldn't be modified?
; @addr{5ce8}
updateLinkSpeed_withParam:
	ld e,<w1Link.var36		; $5ce8
	ld a,(de)		; $5cea
	cp c			; $5ceb
	jr z,++			; $5cec

	ld a,c			; $5cee
	ld (de),a		; $5cef
	and $7f			; $5cf0
	ld hl,@data		; $5cf2
	rst_addAToHl			; $5cf5

	ld e,<w1Link.speed		; $5cf6
	ldi a,(hl)		; $5cf8
	or a			; $5cf9
	jr z,+			; $5cfa

	ld (de),a		; $5cfc
+
	xor a			; $5cfd
	ld e,<w1Link.var12		; $5cfe
	ld (de),a		; $5d00
	inc e			; $5d01
	ldi a,(hl)		; $5d02
	ld (de),a		; $5d03
++
	; 'b' will be added to the index for the below table, depending on whether Link is
	; slowed down by grass, stairs, etc.
	ld b,$02		; $5d04
	; 'e' will be added to the index in the same way as 'b'. It will be $04 if Link is
	; using pegasus seeds.
	ld e,$00		; $5d06

	; Don't apply pegasus seed modifier when on a hole?
	ld a,(wActiveTileType)		; $5d08
	cp TILETYPE_HOLE	; $5d0b
	jr z,++			; $5d0d
	cp TILETYPE_WARPHOLE	; $5d0f
	jr z,++			; $5d11

	; Grass: b = $02
	cp TILETYPE_GRASS	; $5d13
	jr z,+			; $5d15
	inc b			; $5d17

	; Stairs / vines: b = $03
	cp TILETYPE_STAIRS	; $5d18
	jr z,+			; $5d1a
	cp TILETYPE_VINES	; $5d1c
	jr z,+			; $5d1e

	; Standard movement: b = $04
	inc b			; $5d20
+
	call checkPegasusSeedCounter		; $5d21
	jr z,++			; $5d24

	ld e,$03		; $5d26
++
	ld a,e			; $5d28
	add b			; $5d29
	add c			; $5d2a
	and $7f			; $5d2b
	ld hl,@data		; $5d2d
	rst_addAToHl			; $5d30
	ld a,(hl)		; $5d31
	ld h,d			; $5d32
	ld l,<w1Link.speedTmp		; $5d33
	ldd (hl),a		; $5d35
	bit 7,c			; $5d36
	ret nz			; $5d38
	ld (hl),a		; $5d39
	ret			; $5d3a

@data:
	.db $28 $00 $1e $14 $28 $2d $1e $3c
	.db $00 $06 $28 $28 $28 $3c $3c $3c
	.db $14 $03 $1e $14 $28 $2d $1e $3c
.ifdef ROM_AGES
	.db $00 $05 $2d $2d $2d $2d $2d $2d
.endif

;;
; Updates Link's speed and updates his position if he's experiencing knockback.
; @addr{5d5b}
_linkUpdateKnockback:
	ld e,SpecialObject.state		; $5d5b
	ld a,(de)		; $5d5d
	cp LINK_STATE_RESPAWNING			; $5d5e
	jr z,@cancelKnockback	; $5d60

	ld a,(wLinkInAir)		; $5d62
	rlca			; $5d65
	jr c,@cancelKnockback	; $5d66

	; Set c to the amount to decrement knockback by.
	; $01 normally, $02 if in the air?
	ld c,$01		; $5d68
	or a			; $5d6a
	jr z,+			; $5d6b
	inc c			; $5d6d
+
	ld h,d			; $5d6e
	ld l,SpecialObject.knockbackCounter		; $5d6f
	ld a,(hl)		; $5d71
	or a			; $5d72
	ret z			; $5d73

	; Decrement knockback
	sub c			; $5d74
	jr c,@cancelKnockback	; $5d75
	ld (hl),a		; $5d77

	; Adjust link's knockback angle if necessary when sidescrolling
	ld l,SpecialObject.knockbackAngle		; $5d78
	call _linkAdjustGivenAngleInSidescrollingArea		; $5d7a

	; Get speed and knockback angle (de = w1Link.knockbackAngle)
	ld a,(de)		; $5d7d
	ld c,a			; $5d7e
	ld b,SPEED_140		; $5d7f

	ld hl,wcc95		; $5d81
	res 5,(hl)		; $5d84

	jp specialObjectUpdatePositionGivenVelocity		; $5d86

@cancelKnockback:
	ld e,SpecialObject.knockbackCounter		; $5d89
	xor a			; $5d8b
	ld (de),a		; $5d8c
	ret			; $5d8d

;;
; Updates a special object's position without allowing it to "slide off" tiles when they
; are approached from the side.
; @addr{5d8e}
specialObjectUpdatePositionWithoutTileEdgeAdjust:
	ld e,SpecialObject.speed		; $5d8e
	ld a,(de)		; $5d90
	ld b,a			; $5d91
	ld e,SpecialObject.angle		; $5d92
	ld a,(de)		; $5d94
	jr +			; $5d95

;;
; @addr{5d97}
specialObjectUpdatePosition:
	ld e,SpecialObject.speed		; $5d97
	ld a,(de)		; $5d99
	ld b,a			; $5d9a
	ld e,SpecialObject.angle	; $5d9b
	ld a,(de)		; $5d9d
	ld c,a			; $5d9e

;;
; Updates position, accounting for solid walls.
;
; @param	b	Speed
; @param	c	Angle
; @param[out]	a	Bits 0, 1 set if his y, x positions changed, respectively.
; @param[out]	c	Same as a.
; @param[out]	zflag	Set if the object did not move at all.
; @addr{5d9f}
specialObjectUpdatePositionGivenVelocity:
	bit 7,c			; $5d9f
	jr nz,++++		; $5da1

	ld e,SpecialObject.adjacentWallsBitset		; $5da3
	ld a,(de)		; $5da5
	ld e,a			; $5da6
	call @tileEdgeAdjust		; $5da7
	jr nz,++		; $5daa
+
	ld c,a			; $5dac
	ld e,$00		; $5dad
++
	; Depending on the angle, change 'e' to hold the bits that should be checked for
	; collision in adjacentWallsBitset. If the angle is facing up, then only the 'up'
	; bits will be set.
	ld a,c			; $5daf
	ld hl,@bitsToCheck		; $5db0
	rst_addAToHl			; $5db3
	ld a,e			; $5db4
	and (hl)		; $5db5
	ld e,a			; $5db6

	; Get 4 bytes at hl determining the offsets Link should move for speed 'b' and
	; angle 'c'.
	call getPositionOffsetForVelocity		; $5db7

	ld c,$00		; $5dba

	; Don't apply vertical speed if there is a wall.
	ld b,e			; $5dbc
	ld a,b			; $5dbd
	and $f0			; $5dbe
	jr nz,++		; $5dc0

	; Don't run the below code if the vertical offset is zero.
	ldi a,(hl)		; $5dc2
	or (hl)			; $5dc3
	jr z,++			; $5dc4

	; Add values at hl to y position
	dec l			; $5dc6
	ld e,SpecialObject.y		; $5dc7
	ld a,(de)		; $5dc9
	add (hl)		; $5dca
	ld (de),a		; $5dcb
	inc e			; $5dcc
	inc l			; $5dcd
	ld a,(de)		; $5dce
	adc (hl)		; $5dcf
	ld (de),a		; $5dd0

	; Set bit 0 of c
	inc c			; $5dd1
++
	; Don't apply horizontal speed if there is a wall.
	ld a,b			; $5dd2
	and $0f			; $5dd3
	jr nz,++		; $5dd5

	; Don't run the below code if the horizontal offset is zero.
	ld l,<(wTmpcec0+3)		; $5dd7
	ldd a,(hl)		; $5dd9
	or (hl)			; $5dda
	jr z,++			; $5ddb

	; Add values at hl to x position
	ld e,SpecialObject.x		; $5ddd
	ld a,(de)		; $5ddf
	add (hl)		; $5de0
	ld (de),a		; $5de1
	inc l			; $5de2
	inc e			; $5de3
	ld a,(de)		; $5de4
	adc (hl)		; $5de5
	ld (de),a		; $5de6

	set 1,c			; $5de7
++
	ld a,c			; $5de9
	or a			; $5dea
	ret			; $5deb
++++
	xor a			; $5dec
	ld c,a			; $5ded
	ret			; $5dee

; Takes an angle as an index.
; Each value tells which bits in adjacentWallsBitset to check for collision for that
; angle. Ie. when moving up, only check collisions above Link, not below.
@bitsToCheck:
	.db $cf $c3 $c3 $c3 $c3 $c3 $c3 $c3
	.db $f3 $33 $33 $33 $33 $33 $33 $33
	.db $3f $3c $3c $3c $3c $3c $3c $3c
	.db $fc $cc $cc $cc $cc $cc $cc $cc

;;
; Converts Link's angle such that he "slides off" a tile when walking towards the edge.
; @param c Angle
; @param e adjacentWallsBitset
; @param[out] a New angle value
; @param[out] zflag Set if a value has been returned in 'a'.
; @addr{5e0f}
@tileEdgeAdjust:
	ld a,c			; $5e0f
	ld hl,slideAngleTable		; $5e10
	rst_addAToHl			; $5e13
	ld a,(hl)		; $5e14
	and $03			; $5e15
	ret nz			; $5e17

	ld a,(hl)		; $5e18
	rlca			; $5e19
	jr c,@bit7		; $5e1a
	rlca			; $5e1c
	jr c,@bit6		; $5e1d
	rlca			; $5e1f
	jr c,@bit5		; $5e20

	ld a,e			; $5e22
	and $cc			; $5e23
	cp $04			; $5e25
	ld a,$00		; $5e27
	ret z			; $5e29

	ld a,e			; $5e2a
	and $3c			; $5e2b
	cp $08			; $5e2d
	ld a,$10		; $5e2f
	ret			; $5e31
@bit5:
	ld a,e			; $5e32
	and $c3			; $5e33
	cp $01			; $5e35
	ld a,$00		; $5e37
	ret z			; $5e39
	ld a,e			; $5e3a
	and $33			; $5e3b
	cp $02			; $5e3d
	ld a,$10		; $5e3f
	ret			; $5e41
@bit7:
	ld a,e			; $5e42
	and $c3			; $5e43
	cp $80			; $5e45
	ld a,$08		; $5e47
	ret z			; $5e49
	ld a,e			; $5e4a
	and $cc			; $5e4b
	cp $40			; $5e4d
	ld a,$18		; $5e4f
	ret			; $5e51
@bit6:
	ld a,e			; $5e52
	and $33			; $5e53
	cp $20			; $5e55
	ld a,$08		; $5e57
	ret z			; $5e59
	ld a,e			; $5e5a
	and $3c			; $5e5b
	cp $10			; $5e5d
	ld a,$18		; $5e5f
	ret			; $5e61

;;
; Updates SpecialObject.adjacentWallsBitset (always for link?) which determines which ways
; he can move.
; @addr{5e62}
_specialObjectUpdateAdjacentWallsBitset:
	ld e,SpecialObject.adjacentWallsBitset		; $5e62
	xor a			; $5e64
	ld (de),a		; $5e65

	; Return if Link is riding a companion, minecart
	ld a,(wLinkObjectIndex)		; $5e66
	rrca			; $5e69
	ret c			; $5e6a

.ifdef ROM_SEASONS
	ld a,(wActiveTileType)		; $5d5c
	sub TILETYPE_STUMP			; $5d5f
	jr nz,+			; $5d61
	dec a			; $5d63
	jr +++			; $5d64
+
.endif

	ld h,d			; $5e6b
	ld l,SpecialObject.yh		; $5e6c
	ld b,(hl)		; $5e6e
	ld l,SpecialObject.xh		; $5e6f
	ld c,(hl)		; $5e71
	call calculateAdjacentWallsBitset		; $5e72

.ifdef ROM_AGES
	ld b,a			; $5e75
	ld hl,@data-1		; $5e76
--
	inc hl			; $5e79
	ldi a,(hl)		; $5e7a
	or a			; $5e7b
	jr z,++			; $5e7c
	cp b			; $5e7e
	jr nz,--		; $5e7f

	ld a,(hl)		; $5e81
	ldh (<hFF8B),a	; $5e82
	ld e,SpecialObject.adjacentWallsBitset		; $5e84
	ld (de),a		; $5e86
	ret			; $5e87
++
	ld a,b			; $5e88
	ld e,SpecialObject.adjacentWallsBitset		; $5e89
	ld (de),a		; $5e8b
	ret			; $5e8c

@data:
	.db $db $c3
	.db $ee $cc
	.db $00
.else
+++
	ld e,SpecialObject.adjacentWallsBitset		; $5e89
	ld (de),a		; $5e8b
	ret			; $5e8c
.endif

;;
; This function only really works with Link.
;
; @param	bc	Position to check
; @param[out]	b	Bit 7 set if the position is surrounded by a wall on all sides?
; @addr{5e92}
checkPositionSurroundedByWalls:
	call calculateAdjacentWallsBitset		; $5e92
--
	ld b,$80		; $5e95
	cp $ff			; $5e97
	ret z			; $5e99

	rra			; $5e9a
	rl b			; $5e9b
	rra			; $5e9d
	rl b			; $5e9e
	jr nz,--		; $5ea0
	ret			; $5ea2

;;
; This function is likely meant for Link only, due to its use of "wLinkRaisedFloorOffset".
;
; @param	bc	YX position.
; @param[out]	a	Bitset of adjacent walls.
; @param[out]	hFF8B	Same as 'a'.
; @addr{5ea3}
calculateAdjacentWallsBitset:
	ld a,$01		; $5ea3
	ldh (<hFF8B),a	; $5ea5

	ld hl,@overworldOffsets		; $5ea7
	ld a,(wTilesetFlags)		; $5eaa
	and TILESETFLAG_SIDESCROLL			; $5ead
	jr z,@loop			; $5eaf
	ld hl,@sidescrollOffsets		; $5eb1

; Loop 8 times
@loop:
	ldi a,(hl)		; $5eb4
	add b			; $5eb5
	ld b,a			; $5eb6
	ldi a,(hl)		; $5eb7
	add c			; $5eb8
	ld c,a			; $5eb9
	push hl			; $5eba

.ifdef ROM_AGES
	ld a,(wLinkRaisedFloorOffset)		; $5ebb
	or a			; $5ebe
	jr z,+			; $5ebf

	call @checkTileCollisionAt_allowRaisedFl		; $5ec1
	jr ++			; $5ec4
+
.endif
	call checkTileCollisionAt_allowHoles		; $5ec6
++
	pop hl			; $5ec9
	ldh a,(<hFF8B)	; $5eca
	rla			; $5ecc
	ldh (<hFF8B),a	; $5ecd
	jr nc,@loop		; $5ecf
	ret			; $5ed1

; List of YX offsets from Link's position to check for collision at.
; For each offset where there is a collision, the corresponding bit of 'a' will be set.
@overworldOffsets:
	.db -3, -3
	.db  0,  5
	.db 10, -5
	.db  0,  5
	.db -7, -7
	.db  5,  0
	.db -5,  9
	.db  5,  0

@sidescrollOffsets:
	.db -3, -3
	.db  0,  5
	.db 10, -5
	.db  0,  5
	.db -7, -7
	.db  5,  0
	.db -5,  9
	.db  5,  0

.ifdef ROM_AGES
;;
; This may be identical to "checkTileCollisionAt_allowHoles", except that unlike that,
; this does not consider raised floors to have collision?
; @param bc YX position to check for collision
; @param[out] cflag Set on collision
; @addr{5ef2}
@checkTileCollisionAt_allowRaisedFl:
	ld a,b			; $5ef2
	and $f0			; $5ef3
	ld l,a			; $5ef5
	ld a,c			; $5ef6
	swap a			; $5ef7
	and $0f			; $5ef9
	or l			; $5efb
	ld l,a			; $5efc
	ld h,>wRoomCollisions		; $5efd
	ld a,(hl)		; $5eff
	cp $10			; $5f00
	jr c,@simpleCollision		; $5f02

; Complex collision

	and $0f			; $5f04
	ld hl,@specialCollisions		; $5f06
	rst_addAToHl			; $5f09
	ld e,(hl)		; $5f0a
	cp $08			; $5f0b
	ld a,b			; $5f0d
	jr nc,+			; $5f0e
	ld a,c			; $5f10
+
	rrca			; $5f11
	and $07			; $5f12
	ld hl,bitTable		; $5f14
	add l			; $5f17
	ld l,a			; $5f18
	ld a,(hl)		; $5f19
	and e			; $5f1a
	ret z			; $5f1b
	scf			; $5f1c
	ret			; $5f1d

@specialCollisions:
	.db %00000000 %11000011 %00000011 %11000000 %00000000 %11000011 %11000011 %00000000
	.db %00000000 %11000011 %00000011 %11000000 %11000000 %11000001 %00000000 %00000000


@simpleCollision:
	bit 3,b			; $5f2e
	jr nz,+			; $5f30
	rrca			; $5f32
	rrca			; $5f33
+
	bit 3,c			; $5f34
	jr nz,+			; $5f36
	rrca			; $5f38
+
	rrca			; $5f39
	ret			; $5f3a
.endif

;;
; Unused?
; @addr{5f3b}
_clearLinkImmobilizedBit4:
	push hl			; $5f3b
	ld hl,wLinkImmobilized		; $5f3c
	res 4,(hl)		; $5f3f
	pop hl			; $5f41
	ret			; $5f42

;;
; @addr{5f43}
_setLinkImmobilizedBit4:
	push hl			; $5f43
	ld hl,wLinkImmobilized		; $5f44
	set 4,(hl)		; $5f47
	pop hl			; $5f49
	ret			; $5f4a

;;
; Adjusts Link's position to suck him into the center of a tile, and sets his state to
; LINK_STATE_FALLING when he reaches the center.
; @addr{5f4b}
_linkPullIntoHole:
	xor a			; $5f4b
	ld e,SpecialObject.knockbackCounter		; $5f4c
	ld (de),a		; $5f4e

	ld h,d			; $5f4f
	ld l,SpecialObject.state		; $5f50
	ld a,(hl)		; $5f52
	cp LINK_STATE_RESPAWNING			; $5f53
	ret z			; $5f55

	; Allow partial control of Link's position for the first 16 frames he's over the
	; hole.
	ld a,(wStandingOnTileCounter)		; $5f56
	cp $10			; $5f59
	call nc,_setLinkImmobilizedBit4		; $5f5b

	; Depending on the frame counter, move horizontally, vertically, or not at all.
	and $03			; $5f5e
	jr z,@moveVertical			; $5f60
	dec a			; $5f62
	jr z,@moveHorizontal			; $5f63
	ret			; $5f65

@moveVertical:
	ld l,SpecialObject.yh		; $5f66
	ld a,(hl)		; $5f68
	add $05			; $5f69
	and $f0			; $5f6b
	add $08			; $5f6d
	sub (hl)		; $5f6f
	jr c,@decPosition			; $5f70
	jr @incPosition			; $5f72

@moveHorizontal:
	ld l,SpecialObject.xh		; $5f74
	ld a,(hl)		; $5f76
	and $f0			; $5f77
	add $08			; $5f79
	sub (hl)		; $5f7b
	jr c,@decPosition			; $5f7c

@incPosition:
	ld a,(hl)		; $5f7e
	inc a			; $5f7f
	jr +			; $5f80

@decPosition:
	ld a,(hl)		; $5f82
	dec a			; $5f83
+
	ld (hl),a		; $5f84

	; Check that Link is within 3 pixels of the vertical center
	ld l,SpecialObject.yh		; $5f85
	ldi a,(hl)		; $5f87
	and $0f			; $5f88
	sub $07			; $5f8a
	cp $03			; $5f8c
	ret nc			; $5f8e

	; Check that Link is within 3 pixels of the horizontal center
	inc l			; $5f8f
	ldi a,(hl)		; $5f90
	and $0f			; $5f91
	sub $07			; $5f93
	cp $03			; $5f95
	ret nc			; $5f97

	; Link has reached the center of the tile, now he'll start falling

	call clearAllParentItems		; $5f98

	ld e,SpecialObject.knockbackCounter		; $5f9b
	xor a			; $5f9d
	ld (de),a		; $5f9e
	ld (wLinkStateParameter),a		; $5f9f

	; Change Link's state to the falling state
	ld e,SpecialObject.id		; $5fa2
	ld a,(de)		; $5fa4
	or a			; $5fa5
	ld a,LINK_STATE_RESPAWNING		; $5fa6
	jp z,linkSetState		; $5fa8

	; If link's ID isn't zero, set his state indirectly...?
	ld (wLinkForceState),a		; $5fab
	ret			; $5fae

;;
; Checks if Link is pushing against the bed in Nayru's house. If so, set Link's state to
; LINK_STATE_SLEEPING.
; The only bed that this works for is the one in Nayru's house.
; @addr{5faf}
checkLinkPushingAgainstBed:
	ld hl,wInformativeTextsShown		; $5faf
	bit 1,(hl)		; $5fb2
	ret nz			; $5fb4

	ld a,(wActiveGroup)		; $5fb5
	cp $03			; $5fb8
	ret nz			; $5fba

	; Check link is in room $9e, position $17, facing right
.ifdef ROM_AGES
	ldbc $9e, $17		; $5fbb
	ld l,DIR_RIGHT		; $5fbe
.else
	ldbc $82, $14		; $5fbb
	ld l,DIR_LEFT		; $5fbe
.endif
	ld a,(wActiveRoom)		; $5fc0
	cp b			; $5fc3
	ret nz			; $5fc4

	ld a,(wActiveTilePos)		; $5fc5
	cp c			; $5fc8
	ret nz			; $5fc9

	ld e,SpecialObject.direction		; $5fca
	ld a,(de)		; $5fcc
	cp l			; $5fcd
	ret nz			; $5fce

	call checkLinkPushingAgainstWall		; $5fcf
	ret z			; $5fd2

	; Increment counter, wait until it's been 90 frames
	ld hl,wLinkPushingAgainstBedCounter		; $5fd3
	inc (hl)		; $5fd6
	ld a,(hl)		; $5fd7
	cp 90			; $5fd8
	ret c			; $5fda

	pop hl			; $5fdb
	ld hl,wInformativeTextsShown		; $5fdc
	set 1,(hl)		; $5fdf
	ld a,LINK_STATE_SLEEPING		; $5fe1
	jp linkSetState		; $5fe3

.ifdef ROM_SEASONS
;;
; Pushing against tree stump
; @addr{5e74}
checkLinkPushingAgainstTreeStump:
	ld a,(wActiveTileType)		; $5e74
	cp TILETYPE_STUMP		; $5e77
	jp z,seasonsFunc_05_5ed3		; $5e79

	ld a,(wActiveGroup)		; $5e7c
	or a			; $5e7f
	ret nz			; $5e80

	ld a,(wLinkAngle)		; $5e81
	and $e7			; $5e84
	ret nz			; $5e86
	call checkLinkPushingAgainstWall		; $5e87
	ret nc			; $5e8a
	ld e,SpecialObject.direction		; $5e8b
	ld a,(de)		; $5e8d
	ld hl,@relativeTile		; $5e8e
	rst_addDoubleIndex			; $5e91

	ldi a,(hl)		; $5e92
	ld b,a			; $5e93
	ld c,(hl)		; $5e94
	call objectGetRelativeTile		; $5e95
	cp $20			; $5e98
	ret nz			; $5e9a
	ld a,$01		; $5e9b
	call _specialObjectSetVar37AndVar38		; $5e9d

	ld e,SpecialObject.direction		; $5ea0
	ld a,(de)		; $5ea2
	ld l,a			; $5ea3
	add a			; $5ea4
	add l			; $5ea5
	ld hl,@speedValues		; $5ea6
	rst_addAToHl			; $5ea9

	ld e,SpecialObject.speed		; $5eaa
	ldi a,(hl)		; $5eac
	ld (de),a		; $5ead
	inc e			; $5eae
	ld (de),a		; $5eaf
	ld e,SpecialObject.speedZ		; $5eb0
	ldi a,(hl)		; $5eb2
	ld (de),a		; $5eb3
	inc e			; $5eb4
	ldi a,(hl)		; $5eb5
	ld (de),a		; $5eb6

	ld a,$81		; $5eb7
	ld (wLinkInAir),a		; $5eb9
	jp linkCancelAllItemUsage		; $5ebc

@relativeTile:
	.db $f4 $00 ; DIR_UP
	.db $00 $07 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT

@speedValues:
	dbw $23 $fe40
	dbw $14 $fe60
	dbw $0f $fe40
	dbw $14 $fe60


seasonsFunc_05_5ed3:
	ld a,(wLinkAngle)		; $5ed3
	ld c,a
	and $e7
	jr nz,++	; $5ed9

	ld a,c			; $5edb
	add a			; $5edc
	swap a			; $5edd
	ld hl,@relativeTile		; $5edf

	rst_addDoubleIndex			; $5ee2
	ldi a,(hl)		; $5ee3
	ld c,(hl)		; $5ee4
	ld h,d			; $5ee5
	ld l,SpecialObject.yh		; $5ee6
	add (hl)		; $5ee8
	ld b,a			; $5ee9
	ld l,SpecialObject.xh		; $5eea
	ld a,(hl)		; $5eec
	add c			; $5eed
	ld c,a			; $5eee
	call checkTileCollisionAt_allowHoles		; $5eef
	jr c,++			; $5ef2

	ld a,(wLinkAngle)		; $5ef4
	ld e,SpecialObject.angle		; $5ef7
	ld (de),a		; $5ef9
	add a			; $5efa
	swap a			; $5efb
	ld c,a			; $5efd
	add a			; $5efe
	add c			; $5eff
	ld hl,@speedValues		; $5f00
	rst_addAToHl			; $5f03
	ld a,(wLinkTurningDisabled)		; $5f04
	or a			; $5f07
	jr nz,+			; $5f08
	ld e,SpecialObject.direction		; $5f0a
	ld a,c			; $5f0c
	ld (de),a		; $5f0d
+
	ld e,SpecialObject.speed		; $5f0e
	ldi a,(hl)		; $5f10
	ld (de),a		; $5f11
	; SpecialObject.speedTmp
	inc e			; $5f12
	ld (de),a		; $5f13
	ld e,SpecialObject.speedZ		; $5f14
	ldi a,(hl)		; $5f16
	ld (de),a		; $5f17
	inc e			; $5f18
	ldi a,(hl)		; $5f19
	ld (de),a		; $5f1a

	call clearVar37AndVar38		; $5f1b
	ld a,$81		; $5f1e
	ld (wLinkInAir),a		; $5f20
	xor a			; $5f23
	ret			; $5f24
++
	or d			; $5f25
	ret			; $5f26

@relativeTile:
	.db $fb $00
	.db $00 $09
	.db $1b $00
	.db $00 $f6

@speedValues:
	dbw $0f $fe60
	dbw $14 $fe60
	dbw $1e $fe40
	dbw $14 $fe60
.endif

clearVar37AndVar38:
	xor a			; $5fe6
	ld e,SpecialObject.var37		; $5fe7
	ld (de),a		; $5fe9
	inc e			; $5fea
	ld (de),a		; $5feb
	ret			; $5fec

;;
; @param	a	Value for var37
; @param	l	Value for var38 (a position value)
; @addr{5fed}
_specialObjectSetVar37AndVar38:
	ld e,SpecialObject.var37		; $5fed
	ld (de),a		; $5fef
	inc e			; $5ff0
	ld a,l			; $5ff1
	ld (de),a		; $5ff2

;;
; Sets an object's angle to face the position in var37/var38?
; @addr{5ff3}
_specialObjectSetAngleRelativeToVar38:
	ld e,SpecialObject.var37		; $5ff3
	ld a,(de)		; $5ff5
	or a			; $5ff6
	ret z			; $5ff7

	ld hl,_data_6012-2		; $5ff8
	rst_addDoubleIndex			; $5ffb

	inc e			; $5ffc
	ld a,(de)		; $5ffd
	ld c,a			; $5ffe
	and $f0			; $5fff
	add (hl)		; $6001
	ld b,a			; $6002
	inc hl			; $6003
	ld a,c			; $6004
	and $0f			; $6005
	swap a			; $6007
	add (hl)		; $6009
	ld c,a			; $600a

	call objectGetRelativeAngle		; $600b
	ld e,SpecialObject.angle		; $600e
	ld (de),a		; $6010
	ret			; $6011

; @addr{6012}
_data_6012:
	.db $02 $08
	.db $0c $08

;;
; Warps link somewhere based on var37 and var38?
; @addr{6016}
_specialObjectSetPositionToVar38IfSet:
	ld e,SpecialObject.var37		; $6016
	ld a,(de)		; $6018
	or a			; $6019
	ret z			; $601a

	ld hl,_data_6012-2		; $601b
	rst_addDoubleIndex			; $601e

	; de = SpecialObject.var38
	inc e			; $601f
	ld a,(de)		; $6020
	ld c,a			; $6021
	and $f0			; $6022
	add (hl)		; $6024
	ld e,SpecialObject.yh		; $6025
	ld (de),a		; $6027

	inc hl			; $6028
	ld a,c			; $6029
	and $0f			; $602a
	swap a			; $602c
	add (hl)		; $602e
	ld e,SpecialObject.xh		; $602f
	ld (de),a		; $6031
	jr clearVar37AndVar38		; $6032

;;
; Checks if Link touches a cliff tile, and starts the jumping-off-cliff code if so.
; @addr{6034}
_checkLinkJumpingOffCliff:
.ifdef ROM_SEASONS
	ld a,(wActiveTileType)		; $5f89
	cp TILETYPE_STUMP			; $5f8c
	ret z			; $5f8e
.endif

	; Return if Link is not moving in a cardinal direction?
	ld a,(wLinkAngle)		; $6034
	ld c,a			; $6037
	and $e7			; $6038
	ret nz			; $603a

	ld h,d			; $603b
	ld l,SpecialObject.angle		; $603c
	xor c			; $603e
	cp (hl)			; $603f
	ret nz			; $6040

	; Check that Link is facing towards a solid wall
	add a			; $6041
	swap a			; $6042
	ld c,a			; $6044
	add a			; $6045
	add a			; $6046
	add c			; $6047
	ld hl,@wallDirections		; $6048
	rst_addAToHl			; $604b
	ld e,SpecialObject.adjacentWallsBitset		; $604c
	ld a,(de)		; $604e
	and (hl)		; $604f
	cp (hl)			; $6050
	ret nz			; $6051

	; Check 2 offsets from Link's position to ensure that both of them are cliff
	; tiles.
	call @checkCliffTile		; $6052
	ret nc			; $6055
	call @checkCliffTile		; $6056
	ret nc			; $6059

	; If the above checks passed, start making Link jump off the cliff.

	ld a,$81		; $605a
	ld (wLinkInAir),a		; $605c
	ld bc,-$1c0		; $605f
	call objectSetSpeedZ		; $6062
	ld l,SpecialObject.knockbackCounter		; $6065
	ld (hl),$00		; $6067

.ifdef ROM_SEASONS
	ldh a,(<hFF8B)	; $5fc4
	cp $05			; $5fc6
	jr z,@setSpeed140	; $5fc8
	cp $06			; $5fca
	jr z,@setSpeed140	; $5fcc
.endif

	; Return from caller (don't execute any more "linkState01" code)
	pop hl			; $6069

	ld a,LINK_STATE_JUMPING_DOWN_LEDGE		; $606a
	call linkSetState		; $606c
	jr _linkState12		; $606f

;;
; Unused?
; @addr{6071}
@setSpeed140:
	ld l,SpecialObject.speed		; $6071
	ld (hl),SPEED_140		; $6073
	ret			; $6075

;;
; @param[out] cflag
; @addr{6076}
@checkCliffTile:
	inc hl			; $6076
	ldi a,(hl)		; $6077
	ld c,(hl)		; $6078
	ld b,a			; $6079
	push hl			; $607a
	call objectGetRelativeTile		; $607b
	ldh (<hFF8B),a	; $607e
	ld hl,cliffTilesTable		; $6080
	call lookupCollisionTable		; $6083
	pop hl			; $6086
	ret nc			; $6087

	ld c,a			; $6088
	ld e,SpecialObject.angle		; $6089
	ld a,(de)		; $608b
	cp c			; $608c
	scf			; $608d
	ret z			; $608e

	xor a			; $608f
	ret			; $6090

; Data format:
; b0: bits that must be set in w1Link.adjacentWallsBitset for that direction
; b1-b2, b3-b4: Each of these pairs of bytes is a relative offset from Link's position to
; check whether the tile there is a cliff tile. Both resulting positions must be valid.
@wallDirections:
	.db $c0 $fc $fd $fc $02 ; DIR_UP
	.db $03 $00 $04 $05 $04 ; DIR_RIGHT
	.db $30 $08 $fd $08 $02 ; DIR_DOWN
	.db $0c $00 $fb $05 $fb ; DIR_LEFT

;;
; LINK_STATE_JUMPING_DOWN_LEDGE
; @addr{60a5}
_linkState12:
	ld e,SpecialObject.state2		; $60a5
	ld a,(de)		; $60a7
	rst_jumpTable			; $60a8
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemIncState2		; $60b1

.ifdef ROM_AGES
	; Set jumping animation if not underwater
	ld l,SpecialObject.var2f		; $60b4
	bit 7,(hl)		; $60b6
	jr nz,++		; $60b8
.endif

	ld a,(wLinkGrabState)		; $60ba
	ld c,a			; $60bd
	ld a,(wLinkTurningDisabled)		; $60be
	or c			; $60c1
	ld a,LINK_ANIM_MODE_JUMP		; $60c2
	call z,specialObjectSetAnimation		; $60c4
++
	ld a,SND_JUMP		; $60c7
	call playSound		; $60c9

	call @getLengthOfCliff		; $60cc
	jr z,@willTransition			; $60cf

	ld hl,@cliffSpeedTable - 1		; $60d1
	rst_addAToHl			; $60d4
	ld a,(hl)		; $60d5
	ld e,SpecialObject.speed		; $60d6
	ld (de),a		; $60d8
	ret			; $60d9

; A screen transition will occur by jumping off this cliff. Only works properly for cliffs
; facing down.
@willTransition:
	ld a,(wScreenTransitionBoundaryY)		; $60da
	ld b,a			; $60dd
	ld h,d			; $60de
	ld l,SpecialObject.yh		; $60df
	ld a,(hl)		; $60e1
	sub b			; $60e2
	ld (hl),b		; $60e3

	ld l,SpecialObject.zh		; $60e4
	ld (hl),a		; $60e6

	; Disable terrain effects (shadow)
	ld l,SpecialObject.visible		; $60e7
	res 6,(hl)		; $60e9

	ld l,SpecialObject.state2		; $60eb
	ld (hl),$02		; $60ed

	xor a			; $60ef
	ld l,SpecialObject.speed		; $60f0
	ld (hl),a		; $60f2
	ld l,SpecialObject.speedZ		; $60f3
	ldi (hl),a		; $60f5
	ld (hl),$ff		; $60f6

	; [wDisableScreenTransitions] = $01
	inc a			; $60f8
	ld (wDisableScreenTransitions),a		; $60f9

	ld l,SpecialObject.var2f		; $60fc
	set 0,(hl)		; $60fe
	ret			; $6100


; The index to this table is the length of a cliff in tiles; the value is the speed
; required to pass through the cliff.
@cliffSpeedTable:
	.db           SPEED_080 SPEED_0a0 SPEED_0e0
	.db SPEED_120 SPEED_160 SPEED_1a0 SPEED_200
	.db SPEED_240 SPEED_280 SPEED_2c0 SPEED_300


; In the process of falling down the cliff (will land in-bounds).
@substate1:
	call objectApplySpeed		; $610c
	ld c,$20		; $610f
	call objectUpdateSpeedZ_paramC		; $6111
	jp nz,specialObjectAnimate		; $6114

; Link has landed on the ground

	; If a screen transition happened, update respawn position
	ld h,d			; $6117
	ld l,SpecialObject.var2f		; $6118
	bit 0,(hl)		; $611a
	res 0,(hl)		; $611c
	call nz,updateLinkLocalRespawnPosition		; $611e

	call specialObjectTryToBreakTile_source05		; $6121

.ifdef ROM_SEASONS
	ld a,(wActiveGroup)		; $6083
	or a			; $6086
	jr nz,+			; $6087
	ld bc,$0500		; $6089
	call objectGetRelativeTile		; $608c
	cp $20			; $608f
	jr nz,+			; $6091
	call objectCenterOnTile		; $6093
	ld l,SpecialObject.yh		; $6096
	ld a,(hl)		; $6098
	sub $06			; $6099
	ld (hl),a		; $609b
+
.endif

	xor a			; $6124
	ld (wLinkInAir),a		; $6125
	ld (wLinkSwimmingState),a		; $6128

	ld a,SND_LAND		; $612b
	call playSound		; $612d

	call _specialObjectUpdateAdjacentWallsBitset		; $6130
	jp _initLinkStateAndAnimateStanding		; $6133


; In the process of falling down the cliff (a screen transition will occur).
@substate2:
	ld c,$20		; $6136
	call objectUpdateSpeedZ_paramC		; $6138
	jp nz,specialObjectAnimate		; $613b

	; Initiate screen transition
	ld a,$82		; $613e
	ld (wScreenTransitionDirection),a		; $6140
	ld e,SpecialObject.state2		; $6143
	ld a,$03		; $6145
	ld (de),a		; $6147
	ret			; $6148

; In the process of falling down the cliff, after a screen transition happened.
@substate3:
	; Wait for transition to finish
	ld a,(wScrollMode)		; $6149
	cp $01			; $614c
	ret nz			; $614e

	call @getLengthOfCliff		; $614f

	; Set his y position to the position he'll land at, and set his z position to the
	; equivalent height needed to appear to not have moved.
	ld h,d			; $6152
	ld l,SpecialObject.yh		; $6153
	ld a,(hl)		; $6155
	sub b			; $6156
	ld (hl),b		; $6157
	ld l,SpecialObject.zh		; $6158
	ld (hl),a		; $615a

	; Re-enable terrain effects (shadow)
	ld l,SpecialObject.visible		; $615b
	set 6,(hl)		; $615d

	; Go to substate 1 to complete the fall.
	ld l,SpecialObject.state2		; $615f
	ld (hl),$01		; $6161
	ret			; $6163

;;
; Calculates the number of cliff tiles Link will need to pass through.
;
; @param[out]	a	Number of cliff tiles that Link must pass through
; @param[out]	bc	Position of the tile that will be landed on
; @param[out]	zflag	Set if there will be a screen transition before hitting the ground
; @addr{6164}
@getLengthOfCliff:
	; Get Link's position in bc
	ld h,d			; $6164
	ld l,SpecialObject.yh		; $6165
	ldi a,(hl)		; $6167
	add $05			; $6168
	ld b,a			; $616a
	inc l			; $616b
	ld c,(hl)		; $616c

	; Determine direction he's moving in based on angle
	ld l,SpecialObject.angle		; $616d
	ld a,(hl)		; $616f
	add a			; $6170
	swap a			; $6171
	and $03			; $6173
	ld hl,@offsets		; $6175
	rst_addDoubleIndex			; $6178

	ldi a,(hl)
	ldh (<hFF8D),a ; [hFF8D] = y-offset to add to get the next tile's position
	ld a,(hl)
	ldh (<hFF8C),a ; [hFF8C] = x-offset to add to get the next tile's position
	ld a,$01
	ldh (<hFF8B),a ; [hFF8B] = how many tiles away the one we're checking is

@nextTile:
	; Get next tile's position
	ldh a,(<hFF8D)	; $6183
	add b			; $6185
	ld b,a			; $6186
	ldh a,(<hFF8C)	; $6187
	add c			; $6189
	ld c,a			; $618a

	call checkTileCollisionAt_allowHoles		; $618b
	jr nc,@noCollision	; $618e

	; If this tile is breakable, we can land here
	ld a, $80 | BREAKABLETILESOURCE_05		; $6190
	call tryToBreakTile		; $6192
	jr c,@landHere	; $6195

	; Even if it's solid and unbreakable, check if it's an exception (raisable floor)
	ldh a,(<hFF92)	; $6197
	ld hl,_landableTileFromCliffExceptions		; $6199
	call findByteInCollisionTable		; $619c
	jr c,@landHere	; $619f

	; Try the next tile
	ldh a,(<hFF8B)	; $61a1
	inc a			; $61a3
	ldh (<hFF8B),a	; $61a4
	jr @nextTile			; $61a6

@noCollision:
	; Check if we've gone out of bounds (tile index $00)
	call getTileAtPosition		; $61a8
	or a			; $61ab
	ret z			; $61ac

@landHere:
	ldh a,(<hFF8B)	; $61ad
	cp $0b			; $61af
	jr c,+			; $61b1
	ld a,$0b		; $61b3
+
	or a			; $61b5
	ret			; $61b6

@offsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT


; This is a list of tiles that can be landed on when jumping down a cliff, despite being
; solid.
_landableTileFromCliffExceptions:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES
@collisions1:
@collisions2:
@collisions5:
	.db TILEINDEX_RAISABLE_FLOOR_1 TILEINDEX_RAISABLE_FLOOR_2
@collisions0:
@collisions3:
@collisions4:
	.db $00
.else
@collisions0:
	.db $eb $20
@collisions1:
@collisions2:
@collisions3:
@collisions4:
@collisions5:
	.db $00
.endif

;;
; @addr{61ce}
specialObjectCode_transformedLink:
	ld e,SpecialObject.state		; $61ce
	ld a,(de)		; $61d0
	rst_jumpTable			; $61d1
	.dw @state0
	.dw @state1

;;
; State 0: initialization (just transformed)
; @addr{61d6}
@state0:
	call dropLinkHeldItem		; $61d6
	call clearAllParentItems		; $61d9
	ld a,(wLinkForceState)		; $61dc
	or a			; $61df
	jr nz,@resetIDToNormal	; $61e0

	call specialObjectSetOamVariables		; $61e2
	xor a			; $61e5
	call specialObjectSetAnimation		; $61e6
	call objectSetVisiblec1		; $61e9
	call itemIncState		; $61ec

	ld l,SpecialObject.collisionType		; $61ef
	ld a, $80 | ITEMCOLLISION_LINK
	ldi (hl),a		; $61f3

	inc l			; $61f4
	ld a,$06		; $61f5
	ldi (hl),a ; [collisionRadiusY] = $06
	ldi (hl),a ; [collisionRadiusX] = $06

	ld l,SpecialObject.id		; $61f9
	ld a,(hl)		; $61fb
	cp SPECIALOBJECTID_LINK_AS_BABY			; $61fc
	ret nz			; $61fe

	ld l,SpecialObject.counter1		; $61ff
	ld (hl),$e0		; $6201
	inc l			; $6203
	ld (hl),$01 ; [counter2] = $01

	ld a,SND_BECOME_BABY		; $6206
	call playSound		; $6208
	jr @createGreenPoof		; $620b

@disableTransformationForBaby:
	ld a,SND_MAGIC_POWDER		; $620d
	call playSound		; $620f

@disableTransformation:
	lda SPECIALOBJECTID_LINK			; $6212
	call setLinkIDOverride		; $6213
	ld a,$01		; $6216
	ld (wDisableRingTransformations),a		; $6218

	ld e,SpecialObject.id		; $621b
	ld a,(de)		; $621d
	cp SPECIALOBJECTID_LINK_AS_BABY			; $621e
	ret nz			; $6220

@createGreenPoof:
	ld b,INTERACID_GREENPOOF		; $6221
	jp objectCreateInteractionWithSubid00		; $6223

@resetIDToNormal:
	; If a specific state is requested, go back to normal Link code and run it.
	lda SPECIALOBJECTID_LINK			; $6226
	call setLinkID		; $6227
	ld a,$01		; $622a
	ld (wDisableRingTransformations),a		; $622c
	jp specialObjectCode_link		; $622f

;;
; State 1: normal movement, etc in transformed state
; @addr{6232}
@state1:
	ld a,(wLinkForceState)		; $6232
	or a			; $6235
	jr nz,@resetIDToNormal	; $6236

	ld a,(wPaletteThread_mode)		; $6238
	or a			; $623b
	ret nz			; $623c

	ld a,(wScrollMode)		; $623d
	and $0e			; $6240
	ret nz			; $6242

	call updateLinkDamageTaken		; $6243
	ld a,(wLinkDeathTrigger)		; $6246
	or a			; $6249
	jr nz,@disableTransformation	; $624a

	call retIfTextIsActive		; $624c

	ld a,(wDisabledObjects)		; $624f
	and $81			; $6252
	ret nz			; $6254

	call decPegasusSeedCounter		; $6255

	ld h,d			; $6258
	ld l,SpecialObject.id		; $6259
	ld a,(hl)		; $625b
	cp SPECIALOBJECTID_LINK_AS_BABY			; $625c
	jr nz,+		; $625e
	ld l,SpecialObject.counter1		; $6260
	call decHlRef16WithCap		; $6262
	jr z,@disableTransformationForBaby	; $6265
	jr ++			; $6267
+
	call _linkApplyTileTypes		; $6269
	ld a,(wLinkSwimmingState)		; $626c
	or a			; $626f
	jr nz,@resetIDToNormal	; $6270

	callab bank6.getTransformedLinkID		; $6272
	ld e,SpecialObject.id		; $627a
	ld a,(de)		; $627c
	cp b			; $627d
	ld a,b			; $627e
	jr nz,@resetIDToNormal	; $627f
++
	call _specialObjectUpdateAdjacentWallsBitset		; $6281
	call _linkUpdateKnockback		; $6284
	call updateLinkSpeed_standard		; $6287

	; Halve speed if he's in baby form
	ld h,d			; $628a
	ld l,SpecialObject.id		; $628b
	ld a,(hl)		; $628d
	cp SPECIALOBJECTID_LINK_AS_BABY			; $628e
	jr nz,+			; $6290
	ld l,SpecialObject.speed		; $6292
	srl (hl)		; $6294
+
	ld l,SpecialObject.knockbackCounter		; $6296
	ld a,(hl)		; $6298
	or a			; $6299
	jr nz,@animateIfPegasusSeedsActive	; $629a

	ld l,SpecialObject.collisionType		; $629c
	set 7,(hl)		; $629e

	; Update gravity
	ld l,SpecialObject.zh		; $62a0
	bit 7,(hl)		; $62a2
	jr z,++			; $62a4
	ld c,$20		; $62a6
	call objectUpdateSpeedZ_paramC		; $62a8
	jr nz,++		; $62ab
	xor a			; $62ad
	ld (wLinkInAir),a		; $62ae
++
	ld a,(wcc95)		; $62b1
	ld b,a			; $62b4
	ld l,SpecialObject.angle		; $62b5
	ld a,(wLinkAngle)		; $62b7
	ld (hl),a		; $62ba

	; Set carry flag if [wLinkAngle] == $ff or Link is in a spinner
	or b			; $62bb
	rlca			; $62bc
	jr c,@animateIfPegasusSeedsActive	; $62bd

	ld l,SpecialObject.id		; $62bf
	ld a,(hl)		; $62c1
	cp SPECIALOBJECTID_LINK_AS_BABY			; $62c2
	jr nz,++		; $62c4
	ld l,SpecialObject.animParameter		; $62c6
	bit 7,(hl)		; $62c8
	res 7,(hl)		; $62ca
	ld a,SND_SPLASH		; $62cc
	call nz,playSound		; $62ce
++
	ld a,(wLinkTurningDisabled)		; $62d1
	or a			; $62d4
	call z,updateLinkDirectionFromAngle		; $62d5
	ld a,(wActiveTileType)		; $62d8
	cp TILETYPE_STUMP			; $62db
	jr z,@animate			; $62dd
	ld a,(wLinkImmobilized)		; $62df
	or a			; $62e2
	jr nz,@animate		; $62e3
	call specialObjectUpdatePosition		; $62e5

@animate:
	; Check whether to create the pegasus seed effect
	call checkPegasusSeedCounter		; $62e8
	jr z,++			; $62eb
	rlca			; $62ed
	jr nc,++		; $62ee
	call getFreeInteractionSlot		; $62f0
	jr nz,++		; $62f3
	ld (hl),INTERACID_FALLDOWNHOLE		; $62f5
	inc l			; $62f7
	inc (hl)		; $62f8
	ld bc,$0500		; $62f9
	call objectCopyPositionWithOffset		; $62fc
++
	ld e,SpecialObject.animMode		; $62ff
	ld a,(de)		; $6301
	or a			; $6302
	jp z,specialObjectAnimate		; $6303
	xor a			; $6306
	jp specialObjectSetAnimation		; $6307

@animateIfPegasusSeedsActive:
	call checkPegasusSeedCounter		; $630a
	jr nz,@animate		; $630d
	xor a			; $630f
	jp specialObjectSetAnimation		; $6310


;;
; @addr{6313}
specialObjectCode_linkRidingAnimal:
	ld e,SpecialObject.state		; $6313
	ld a,(de)		; $6315
	rst_jumpTable			; $6316
	.dw @state0
	.dw @state1

@state0:
	call dropLinkHeldItem		; $631b
	call clearAllParentItems		; $631e
	call specialObjectSetOamVariables		; $6321

	ld h,d			; $6324
	ld l,SpecialObject.state		; $6325
	inc (hl)		; $6327
	ld l,SpecialObject.collisionType		; $6328
	ld a, $80 | ITEMCOLLISION_LINK		; $632a
	ldi (hl),a		; $632c

	inc l			; $632d
	ld a,$06		; $632e
	ldi (hl),a ; [collisionRadiusY] = $06
	ldi (hl),a ; [collisionRadiusX] = $06
	call @readCompanionAnimParameter		; $6332
	jp objectSetVisiblec1		; $6335

	; Unused code? (Revert back to ordinary Link code)
	lda SPECIALOBJECTID_LINK			; $6338
	call setLinkIDOverride		; $6339
	ld b,INTERACID_GREENPOOF		; $633c
	jp objectCreateInteractionWithSubid00		; $633e

@state1:
	ld a,(wPaletteThread_mode)		; $6341
	or a			; $6344
	ret nz			; $6345

	call updateLinkDamageTaken		; $6346

	call retIfTextIsActive		; $6349
	ld a,(wScrollMode)		; $634c
	and $0e			; $634f
	ret nz			; $6351

	ld a,(wDisabledObjects)		; $6352
	rlca			; $6355
	ret c			; $6356
	call _linkUpdateKnockback		; $6357

;;
; Copies companion's animParameter & $3f to var31.
; @addr{635a}
@readCompanionAnimParameter:
	ld hl,w1Companion.animParameter		; $635a
	ld a,(hl)		; $635d
	and $3f			; $635e
	ld e,SpecialObject.var31		; $6360
	ld (de),a		; $6362
	ret			; $6363


;;
; Update a minecart object.
; @addr{6364}
_specialObjectCode_minecart:
	; Jump to code in bank 6 to handle it
	jpab bank6.specialObjectCode_minecart		; $6364




; Maple variables:
;
;  var03:  gets set to 0 (rarer item drops) or 1 (standard item drops) when spawning.
;
;  relatedObj1: pointer to a bomb object (maple can suck one up when on her vacuum).
;  relatedObj2: At first, this is a pointer to data in the rom determining Maple's path?
;               When collecting items, this is a pointer to the item she's collecting.
;
;  damage: maple's vehicle (0=broom, 1=vacuum, 2=ufo)
;  health: the value of the loot that Maple's gotten
;  var2a:  the value of the loot that Link's gotten
;
;  invincibilityCounter: nonzero if maple's dropped a heart piece
;  knockbackAngle: actually stores bitmask for item indices 1-4; a bit is set if the item
;                  has been spawned. These items can't spawn more than once.
;  stunCounter: the index of the item that Maple is picking up
;
;  var3a: When recoiling, this gets copied to speedZ?
;         During item collection, this is the delay for maple turning?
;  var3b: Counter until Maple can update her angle by a unit. (Length determined by var3a)
;  var3c: Counter until Maple's Z speed reverses (when floating up and down)
;  var3d: Angle that she's turning toward
;  var3f: Value from 0-2 which determines how much variation there is in maple's movement
;         path? (The variation in her movement increases as she's encountered more often.)
;
;
;;
; @addr{636c}
_specialObjectCode_maple:
	call _companionRetIfInactiveWithoutStateCheck		; $636c
	ld e,SpecialObject.state		; $636f
	ld a,(de)		; $6371
	rst_jumpTable			; $6372
	.dw _mapleState0
	.dw _mapleState1
	.dw _mapleState2
	.dw _mapleState3
	.dw _mapleState4
	.dw _mapleState5
	.dw _mapleState6
	.dw _mapleState7
	.dw _mapleState8
	.dw _mapleState9
	.dw _mapleStateA
	.dw _mapleStateB
	.dw _mapleStateC

;;
; State 0: Initialization
; @addr{638d}
_mapleState0:
	xor a			; $638d
	ld (wcc85),a		; $638e
	call specialObjectSetOamVariables		; $6391

	; Set 'c' to be the amount of variation in maple's path (higher the more she's
	; been encountered)
	ld c,$02		; $6394
	ld a,(wMapleState)		; $6396
	and $0f			; $6399
	cp $0f			; $639b
	jr z,+			; $639d
	dec c			; $639f
	cp $08			; $63a0
	jr nc,+			; $63a2
	dec c			; $63a4
+
	ld a,c			; $63a5
	ld e,SpecialObject.var3f		; $63a6
	ld (de),a		; $63a8

	; Determine maple's vehicle (written to "damage" variable); broom/vacuum in normal
	; game, or broom/ufo in linked game.
	or a			; $63a9
	jr z,+			; $63aa
	ld a,$01		; $63ac
+
	ld e,SpecialObject.damage		; $63ae
	ld (de),a		; $63b0
	or a			; $63b1
	jr z,++			; $63b2
	call checkIsLinkedGame		; $63b4
	jr z,++			; $63b7
	ld a,$02		; $63b9
	ld (de),a		; $63bb
++
	call itemIncState		; $63bc

	ld l,SpecialObject.yh		; $63bf
	ld a,$10		; $63c1
	ldi (hl),a  ; [yh] = $10
	inc l			; $63c4
	ld (hl),$b8 ; [xh] = $b8

	ld l,SpecialObject.zh		; $63c7
	ld a,$88		; $63c9
	ldi (hl),a		; $63cb

	ld (hl),SPEED_140 ; [speed] = SPEED_140

	ld l,SpecialObject.collisionRadiusY		; $63ce
	ld a,$08		; $63d0
	ldi (hl),a		; $63d2
	ld (hl),a		; $63d3

	ld l,SpecialObject.knockbackCounter		; $63d4
	ld (hl),$03		; $63d6

	; Decide on Maple's drop pattern.
	; If [var03] = 0, it's a rare item pattern (1/8 times).
	; If [var03] = 1, it's a standard pattern  (7/8 times).
	call getRandomNumber		; $63d8
	and $07			; $63db
	jr z,+			; $63dd
	ld a,$01		; $63df
+
	ld e,SpecialObject.var03		; $63e1
	ld (de),a		; $63e3

	ld hl,_mapleShadowPathsTable		; $63e4
	rst_addDoubleIndex			; $63e7
	ldi a,(hl)		; $63e8
	ld h,(hl)		; $63e9
	ld l,a			; $63ea

	ld e,SpecialObject.var3a		; $63eb
	ldi a,(hl)		; $63ed
	ld (de),a		; $63ee
	inc e			; $63ef
	ld (de),a		; $63f0
	ld e,SpecialObject.relatedObj2		; $63f1
	ld a,l			; $63f3
	ld (de),a		; $63f4
	inc e			; $63f5
	ld a,h			; $63f6
	ld (de),a		; $63f7

	ld a,(hl)		; $63f8
	ld e,SpecialObject.angle		; $63f9
	ld (de),a		; $63fb
	call _mapleDecideNextAngle		; $63fc
	call objectSetVisiblec0		; $63ff
	ld a,$19		; $6402
	jp specialObjectSetAnimation		; $6404

;;
; @addr{6407}
_mapleState1:
	call _mapleState4		; $6407
	ret nz			; $640a
	ld a,(wMenuDisabled)		; $640b
	or a			; $640e
	jp nz,_mapleDeleteSelf		; $640f

	ld a,MUS_MAPLE_THEME		; $6412
	ld (wActiveMusic),a		; $6414
	jp playSound		; $6417

;;
; State 4: lying on ground after being hit
; @addr{641a}
_mapleState4:
	ld hl,w1Companion.knockbackCounter		; $641a
	dec (hl)		; $641d
	ret nz			; $641e
	call itemIncState		; $641f
	xor a			; $6422
	ret			; $6423

;;
; State 2: flying around (above screen or otherwise) before being hit
; @addr{6424}
_mapleState2:
	ld a,(wTextIsActive)		; $6424
	or a			; $6427
	jr nz,@animate		; $6428
	ld hl,w1Companion.counter2		; $642a
	ld a,(hl)		; $642d
	or a			; $642e
	jr z,+			; $642f
	dec (hl)		; $6431
	ret			; $6432
+
	ld l,SpecialObject.var3d		; $6433
	ld a,(hl)		; $6435
	ld l,SpecialObject.angle		; $6436
	cp (hl)			; $6438
	jr z,+			; $6439
	call _mapleUpdateAngle		; $643b
	jr ++			; $643e
+
	ld l,SpecialObject.counter1		; $6440
	dec (hl)		; $6442
	call z,_mapleDecideNextAngle		; $6443
	jr z,@label_05_262	; $6446
++
	call objectApplySpeed		; $6448
	ld e,SpecialObject.var3e		; $644b
	ld a,(de)		; $644d
	or a			; $644e
	ret z			; $644f

.ifdef ROM_AGES
	call checkLinkVulnerableAndIDZero		; $6450
.else
	call checkLinkID0AndControlNormal		; $4559
.endif
	jr nc,@animate		; $6453
	call objectCheckCollidedWithLink_ignoreZ		; $6455
	jr c,_mapleCollideWithLink	; $6458
@animate:
	call _mapleUpdateOscillation		; $645a
	jp specialObjectAnimate		; $645d

@label_05_262:
	ld hl,w1Companion.var3e		; $6460
	ld a,(hl)		; $6463
	or a			; $6464
	jp nz,_mapleDeleteSelf		; $6465

	inc (hl)		; $6468
	call _mapleInitZPositionAndSpeed		; $6469

	ld l,SpecialObject.speed		; $646c
	ld (hl),SPEED_200		; $646e
	ld l,SpecialObject.counter2		; $6470
	ld (hl),$3c		; $6472

	ld e,SpecialObject.var3f		; $6474
	ld a,(de)		; $6476

	ld e,$03		; $6477
	or a			; $6479
	jr z,++			; $647a
	set 2,e			; $647c
	cp $01			; $647e
	jr z,++			; $6480
	set 3,e			; $6482
++
	call getRandomNumber		; $6484
	and e			; $6487
	ld hl,_mapleMovementPatternIndices		; $6488
	rst_addAToHl			; $648b
	ld a,(hl)		; $648c
	ld hl,_mapleMovementPatternTable		; $648d
	rst_addDoubleIndex			; $6490

	ld e,SpecialObject.yh		; $6491
	ldi a,(hl)		; $6493
	ld h,(hl)		; $6494
	ld l,a			; $6495

	ldi a,(hl)		; $6496
	ld (de),a		; $6497
	ld e,SpecialObject.xh		; $6498
	ldi a,(hl)		; $649a
	ld (de),a		; $649b

	ldi a,(hl)		; $649c
	ld e,SpecialObject.var3a		; $649d
	ld (de),a		; $649f
	inc e			; $64a0
	ld (de),a		; $64a1

	ld a,(hl)		; $64a2
	ld e,SpecialObject.angle		; $64a3
	ld (de),a		; $64a5

	ld e,SpecialObject.relatedObj2		; $64a6
	ld a,l			; $64a8
	ld (de),a		; $64a9
	inc e			; $64aa
	ld a,h			; $64ab
	ld (de),a		; $64ac

;;
; Updates var3d with the angle Maple should be turning toward next, and counter1 with the
; length of time she should stay in that angle.
;
; @param[out]	zflag	z if we've reached the end of the "angle data".
; @addr{64ad}
_mapleDecideNextAngle:
	ld hl,w1Companion.relatedObj2		; $64ad
	ldi a,(hl)		; $64b0
	ld h,(hl)		; $64b1
	ld l,a			; $64b2

	ld e,SpecialObject.var3d		; $64b3
	ldi a,(hl)		; $64b5
	ld (de),a		; $64b6
	ld c,a			; $64b7
	ld e,SpecialObject.counter1		; $64b8
	ldi a,(hl)		; $64ba
	ld (de),a		; $64bb

	ld e,SpecialObject.relatedObj2		; $64bc
	ld a,l			; $64be
	ld (de),a		; $64bf
	inc e			; $64c0
	ld a,h			; $64c1
	ld (de),a		; $64c2

	ld a,c			; $64c3
	cp $ff			; $64c4
	ret z			; $64c6
	jp _mapleDecideAnimation		; $64c7

;;
; Handles stuff when Maple collides with Link. (Sets knockback for both, sets Maple's
; animation, drops items, and goes to state 3.)
;
; @addr{64ca}
_mapleCollideWithLink:
	call dropLinkHeldItem		; $64ca
	call _mapleSpawnItemDrops		; $64cd

	ld a,$01		; $64d0
	ld (wDisableScreenTransitions),a		; $64d2
	ld (wMenuDisabled),a		; $64d5
	ld a,$3c		; $64d8
	ld (wInstrumentsDisabledCounter),a		; $64da
	ld e,SpecialObject.counter1		; $64dd
	xor a			; $64df
	ld (de),a		; $64e0

	; Set knockback direction and angle for Link and Maple
	call _mapleGetCardinalAngleTowardLink		; $64e1
	ld b,a			; $64e4
	ld hl,w1Link.knockbackCounter		; $64e5
	ld (hl),$18		; $64e8

	ld e,SpecialObject.angle		; $64ea
	ld l,<w1Link.knockbackAngle		; $64ec
	ld (hl),a		; $64ee
	xor $10			; $64ef
	ld (de),a		; $64f1

	; Determine maple's knockback speed
	ld e,SpecialObject.damage		; $64f2
	ld a,(de)		; $64f4
	ld hl,@speeds		; $64f5
	rst_addAToHl			; $64f8
	ld a,(hl)		; $64f9
	ld e,SpecialObject.speed		; $64fa
	ld (de),a		; $64fc

	ld e,SpecialObject.var3a		; $64fd
	ld a,$fc		; $64ff
	ld (de),a		; $6501
	ld a,$0f		; $6502
	ld (wScreenShakeCounterX),a		; $6504

	ld e,SpecialObject.state		; $6507
	ld a,$03		; $6509
	ld (de),a		; $650b

	; Determine animation? ('b' currently holds the angle toward link.)
	ld a,b			; $650c
	add $04			; $650d
	add a			; $650f
	add a			; $6510
	swap a			; $6511
	and $01			; $6513
	xor $01			; $6515
	add $10			; $6517
	ld b,a			; $6519
	ld e,SpecialObject.damage		; $651a
	ld a,(de)		; $651c
	add a			; $651d
	add b			; $651e
	call specialObjectSetAnimation		; $651f

	ld a,SND_SCENT_SEED		; $6522
	jp playSound		; $6524

@speeds:
	.db SPEED_100
	.db SPEED_140
	.db SPEED_180

;;
; State 3: recoiling after being hit
; @addr{652a}
_mapleState3:
	ld a,(w1Link.knockbackCounter)		; $652a
	or a			; $652d
	jr nz,+			; $652e
	ld a,$01		; $6530
	ld (wDisabledObjects),a		; $6532
+
	ld h,d			; $6535
	ld e,SpecialObject.var3a		; $6536
	ld a,(de)		; $6538
	or a			; $6539
	jr z,@animate		; $653a

	ld e,SpecialObject.zh		; $653c
	ld a,(de)		; $653e
	or a			; $653f
	jr nz,@applyKnockback	; $6540

	; Update speedZ
	ld e,SpecialObject.var3a		; $6542
	ld l,SpecialObject.speedZ+1		; $6544
	ld a,(de)		; $6546
	inc a			; $6547
	ld (de),a		; $6548
	ld (hl),a		; $6549

@applyKnockback:
	ld c,$40		; $654a
	call objectUpdateSpeedZ_paramC		; $654c
	call objectApplySpeed		; $654f
	call _mapleKeepInBounds		; $6552
	call objectGetTileCollisions		; $6555
	ret z			; $6558
	jr @counteractWallSpeed		; $6559

@animate:
	ld a,(wDisabledObjects)		; $655b
	or a			; $655e
	ret z			; $655f

	; Wait until the animation gives the signal to go to state 4
	ld e,SpecialObject.animParameter		; $6560
	ld a,(de)		; $6562
	cp $ff			; $6563
	jp nz,specialObjectAnimate		; $6565
	ld e,SpecialObject.knockbackCounter		; $6568
	ld a,$78		; $656a
	ld (de),a		; $656c
	ld e,SpecialObject.state		; $656d
	ld a,$04		; $656f
	ld (de),a		; $6571
	ret			; $6572

; If maple's hitting a wall, counteract the speed being applied.
@counteractWallSpeed:
	ld e,SpecialObject.angle		; $6573
	call convertAngleDeToDirection		; $6575
	ld hl,@offsets		; $6578
	rst_addDoubleIndex			; $657b
	ld e,SpecialObject.yh		; $657c
	ld a,(de)		; $657e
	add (hl)		; $657f
	ld b,a			; $6580
	inc hl			; $6581
	ld e,SpecialObject.xh		; $6582
	ld a,(de)		; $6584
	add (hl)		; $6585
	ld c,a			; $6586

	ld h,d			; $6587
	ld l,SpecialObject.yh		; $6588
	ld (hl),b		; $658a
	ld l,SpecialObject.xh		; $658b
	ld (hl),c		; $658d
	ret			; $658e

@offsets:
	.db $04 $00 ; DIR_UP
	.db $00 $fc ; DIR_RIGHT
	.db $fc $00 ; DIR_DOWN
	.db $00 $04 ; DIR_LEFT

;;
; State 5: floating back up after being hit
; @addr{6597}
_mapleState5:
	ld hl,w1Companion.counter1		; $6597
	ld a,(hl)		; $659a
	or a			; $659b
	jr nz,@floatUp		; $659c

; counter1 has reached 0

	inc (hl)		; $659e
	call _mapleInitZPositionAndSpeed		; $659f
	ld l,SpecialObject.zh		; $65a2
	ld (hl),$ff		; $65a4
	ld a,$01		; $65a6
	ld l,SpecialObject.var3a		; $65a8
	ldi (hl),a		; $65aa
	ld (hl),a  ; [var3b] = $01

	; Reverse direction (to face Link)
	ld e,SpecialObject.angle		; $65ac
	ld a,(de)		; $65ae
	xor $10			; $65af
	ld (de),a		; $65b1
	call _mapleDecideAnimation		; $65b2

@floatUp:
	ld e,SpecialObject.damage		; $65b5
	ld a,(de)		; $65b7
	ld c,a			; $65b8

	; Rise one pixel per frame
	ld e,SpecialObject.zh		; $65b9
	ld a,(de)		; $65bb
	dec a			; $65bc
	ld (de),a		; $65bd
	cp $f9			; $65be
	ret nc			; $65c0

	; If on the ufo or vacuum cleaner, rise 16 pixels higher
	ld a,c			; $65c1
	or a			; $65c2
	jr z,@finishedFloatingUp			; $65c3
	ld a,(de)		; $65c5
	cp $e9			; $65c6
	ret nc			; $65c8

@finishedFloatingUp:
	ld a,(wMapleState)		; $65c9
	bit 4,a			; $65cc
	jr nz,@exchangeTouchingBook	; $65ce

	ld l,SpecialObject.state		; $65d0
	ld (hl),$06		; $65d2

	; Set collision radius variables
	ld e,SpecialObject.damage		; $65d4
	ld a,(de)		; $65d6
	ld hl,@collisionRadii		; $65d7
	rst_addDoubleIndex			; $65da
	ld e,SpecialObject.collisionRadiusY		; $65db
	ldi a,(hl)		; $65dd
	ld (de),a		; $65de
	inc e			; $65df
	ld a,(hl)		; $65e0
	ld (de),a		; $65e1

.ifdef ROM_AGES
	; Check if this is the past. She says something about coming through a "weird
	; tunnel", which is probably their justification for her being in the past? She
	; only says this the first time she's encountered in the past.
	ld a,(wActiveGroup)		; $65e2
	dec a			; $65e5
	jr nz,@normalEncounter	; $65e6

	ld a,(wMapleState)		; $65e8
	and $0f			; $65eb
	ld bc,TX_0712		; $65ed
	jr z,++			; $65f0

	ld a,GLOBALFLAG_44		; $65f2
	call checkGlobalFlag		; $65f4
	ld bc,TX_0713		; $65f7
	jr nz,@normalEncounter	; $65fa
++
	ld a,GLOBALFLAG_44		; $65fc
	call setGlobalFlag		; $65fe
	jr @showText		; $6601
.endif

@normalEncounter:
	; If this is the first encounter, show TX_0700
	ld a,(wMapleState)		; $6603
	and $0f			; $6606
	ld bc,TX_0700		; $6608
	jr z,@showText		; $660b

	; If we've encountered maple 5 times or more, show TX_0705
	ld c,<TX_0705		; $660d
	cp $05			; $660f
	jr nc,@showText		; $6611

	; Otherwise, pick a random text index from TX_0701-TX_0704
	call getRandomNumber		; $6613
	and $03			; $6616
	ld hl,@normalEncounterText		; $6618
	rst_addAToHl			; $661b
	ld c,(hl)		; $661c
@showText:
	call showText		; $661d
	xor a			; $6620
	ld (wDisabledObjects),a		; $6621
	ld (wMenuDisabled),a		; $6624
	jp _mapleDecideItemToCollectAndUpdateTargetAngle		; $6627

@exchangeTouchingBook:
	ld a,$0b		; $662a
	ld l,SpecialObject.state		; $662c
	ld (hl),a		; $662e

	ld l,SpecialObject.direction		; $662f
	ldi (hl),a  ; [direction] = $0b (?)
	ld (hl),$ff ; [angle] = $ff

	ld l,SpecialObject.speed		; $6634
	ld (hl),SPEED_100		; $6636

.ifdef ROM_AGES
	ld bc,TX_070d		; $6638
.else
	ld bc,TX_0709		; $6638
.endif
	jp showText		; $663b


; One of these pieces of text is chosen at random when bumping into maple between the 2nd
; and 4th encounters (inclusive).
@normalEncounterText:
	.db <TX_0701 <TX_0702 <TX_0703 <TX_0704


; Values for collisionRadiusY/X for maple's various forms.
@collisionRadii:
	.db $02 $02 ; broom
	.db $02 $02 ; vacuum cleaner
	.db $04 $04 ; ufo


;;
; Updates maple's Z position and speedZ for oscillation (but not if she's in a ufo?)
; @addr{6648}
_mapleUpdateOscillation:
	ld h,d			; $6648
	ld e,SpecialObject.damage		; $6649
	ld a,(de)		; $664b
	cp $02			; $664c
	ret z			; $664e

	ld c,$00		; $664f
	call objectUpdateSpeedZ_paramC		; $6651

	; Wait a certain number of frames before inverting speedZ
	ld l,SpecialObject.var3c		; $6654
	ld a,(hl)		; $6656
	dec a			; $6657
	ld (hl),a		; $6658
	ret nz			; $6659

	ld a,$16		; $665a
	ld (hl),a		; $665c

	; Invert speedZ
	ld l,SpecialObject.speedZ		; $665d
	ld a,(hl)		; $665f
	cpl			; $6660
	inc a			; $6661
	ldi (hl),a		; $6662
	ld a,(hl)		; $6663
	cpl			; $6664
	ld (hl),a		; $6665
	ret			; $6666

;;
; @addr{6667}
_mapleUpdateAngle:
	ld hl,w1Companion.var3b		; $6667
	dec (hl)		; $666a
	ret nz			; $666b

	ld e,SpecialObject.var3a		; $666c
	ld a,(de)		; $666e
	ld (hl),a		; $666f
	ld l,SpecialObject.angle		; $6670
	ld e,SpecialObject.var3d		; $6672
	ld l,(hl)		; $6674
	ldh (<hFF8B),a	; $6675
	ld a,(de)		; $6677
	call objectNudgeAngleTowards		; $6678

;;
; @param[out]	zflag
; @addr{667b}
_mapleDecideAnimation:
	ld e,SpecialObject.var3e		; $667b
	ld a,(de)		; $667d
	or a			; $667e
	jr z,@ret		; $667f

	ld h,d			; $6681
	ld l,SpecialObject.angle		; $6682
	ld a,(hl)		; $6684
	call convertAngleToDirection		; $6685
	add $04			; $6688
	ld b,a			; $668a
	ld e,SpecialObject.damage		; $668b
	ld a,(de)		; $668d
	add a			; $668e
	add a			; $668f
	add b			; $6690
	ld l,SpecialObject.animMode		; $6691
	cp (hl)			; $6693
	call nz,specialObjectSetAnimation		; $6694
@ret:
	or d			; $6697
	ret			; $6698


;;
; State 6: talking to Link / moving toward an item
; @addr{6699}
_mapleState6:
	call _mapleUpdateOscillation		; $6699
	call specialObjectAnimate		; $669c
	call retIfTextIsActive		; $669f

	ld a,(wActiveMusic)		; $66a2
	cp MUS_MAPLE_GAME			; $66a5
	jr z,++			; $66a7
	ld a,MUS_MAPLE_GAME		; $66a9
	ld (wActiveMusic),a		; $66ab
	call playSound		; $66ae
++
	; Check whether to update Maple's angle toward an item
	ld l,SpecialObject.var3d		; $66b1
	ld a,(hl)		; $66b3
	ld l,SpecialObject.angle		; $66b4
	cp (hl)			; $66b6
	call nz,_mapleUpdateAngle		; $66b7

	call _mapleDecideItemToCollectAndUpdateTargetAngle		; $66ba
	call objectApplySpeed		; $66bd

	; Check if Maple's touching the target object
	ld e,SpecialObject.relatedObj2		; $66c0
	ld a,(de)		; $66c2
	ld h,a			; $66c3
	inc e			; $66c4
	ld a,(de)		; $66c5
	ld l,a			; $66c6
	call checkObjectsCollided		; $66c7
	jp nc,_mapleKeepInBounds		; $66ca

	; Set the item being collected to state 4
	ld e,SpecialObject.relatedObj2		; $66cd
	ld a,(de)		; $66cf
	ld h,a			; $66d0
	inc e			; $66d1
	ld a,(de)		; $66d2
	or Object.state			; $66d3
	ld l,a			; $66d5
	ld (hl),$04 ; [Part.state] = $04
	inc l			; $66d8
	ld (hl),$00 ; [Part.state2] = $00

	; Read the item's var03 to determine how long it takes to collect.
	ld a,(de)		; $66db
	or Object.var03			; $66dc
	ld l,a			; $66de
	ld a,(hl)		; $66df
	ld e,SpecialObject.stunCounter		; $66e0
	ld (de),a		; $66e2

	; Go to state 7
	ld e,SpecialObject.state		; $66e3
	ld a,$07		; $66e5
	ld (de),a		; $66e7

	; If maple's on her broom, she'll only do her sweeping animation if she's not in
	; a wall - otherwise, she'll just sort of sit there?
	ld e,SpecialObject.damage		; $66e8
	ld a,(de)		; $66ea
	or a			; $66eb
	call z,_mapleFunc_6c27		; $66ec
	ret z			; $66ef

	add $16			; $66f0
	jp specialObjectSetAnimation		; $66f2


;;
; State 7: picking up an item
; @addr{66f5}
_mapleState7:
	call specialObjectAnimate		; $66f5

	ld e,SpecialObject.damage		; $66f8
	ld a,(de)		; $66fa
	cp $01			; $66fb
	jp nz,@anyVehicle		; $66fd

; Maple is on the vacuum.
;
; The next bit of code deals with pulling a bomb object (an actual explosive one) toward
; maple. When it touches her, she will be momentarily stunned.

	; Adjust collisionRadiusY/X for the purpose of checking if a bomb object is close
	; enough to be sucked toward the vacuum.
	ld e,SpecialObject.collisionRadiusY		; $6700
	ld a,$08		; $6702
	ld (de),a		; $6704
	inc e			; $6705
	ld a,$0a		; $6706
	ld (de),a		; $6708

	; Check if there's an actual bomb (one that can explode) on-screen.
	call _mapleFindUnexplodedBomb		; $6709
	jr nz,+			; $670c
	call checkObjectsCollided		; $670e
	jr c,@explosiveBombNearMaple	; $6711
+
	call _mapleFindNextUnexplodedBomb		; $6713
	jr nz,@updateItemBeingCollected	; $6716
	call checkObjectsCollided		; $6718
	jr c,@explosiveBombNearMaple	; $671b

	ld e,SpecialObject.relatedObj1		; $671d
	xor a			; $671f
	ld (de),a		; $6720
	inc e			; $6721
	ld (de),a		; $6722
	jr @updateItemBeingCollected		; $6723

@explosiveBombNearMaple:
	; Constantly signal the bomb to reset its animation so it doesn't explode
	ld l,SpecialObject.var2f		; $6725
	set 7,(hl)		; $6727

	; Update the bomb's X and Y positions toward maple, and check if they've reached
	; her.
	ld b,$00		; $6729
	ld l,Item.yh		; $672b
	ld e,l			; $672d
	ld a,(de)		; $672e
	cp (hl)			; $672f
	jr z,@updateBombX	; $6730
	inc b			; $6732
	jr c,+			; $6733
	inc (hl)		; $6735
	jr @updateBombX		; $6736
+
	dec (hl)		; $6738

@updateBombX:
	ld l,Item.xh		; $6739
	ld e,l			; $673b
	ld a,(de)		; $673c
	cp (hl)			; $673d
	jr z,++			; $673e
	inc b			; $6740
	jr c,+			; $6741
	inc (hl)		; $6743
	jr ++			; $6744
+
	dec (hl)		; $6746
++
	ld a,b			; $6747
	or a			; $6748
	jr nz,@updateItemBeingCollected	; $6749

; The bomb has reached maple's Y/X position. Start pulling it up.

	; [Item.z] -= $0040
	ld l,Item.z		; $674b
	ld a,(hl)		; $674d
	sub $40			; $674e
	ldi (hl),a		; $6750
	ld a,(hl)		; $6751
	sbc $00			; $6752
	ld (hl),a		; $6754

	cp $f8			; $6755
	jr nz,@updateItemBeingCollected	; $6757

; The bomb has risen high enough. Maple will now be stunned.

	; Signal the bomb to delete itself
	ld l,SpecialObject.var2f		; $6759
	set 5,(hl)		; $675b

	ld a,$1a		; $675d
	call specialObjectSetAnimation		; $675f

	; Go to state 8
	ld h,d			; $6762
	ld l,SpecialObject.state		; $6763
	ld (hl),$08		; $6765
	inc l			; $6767
	ld (hl),$00 ; [state2] = 0

	ld l,SpecialObject.counter2		; $676a
	ld (hl),$20		; $676c

	ld e,SpecialObject.relatedObj2		; $676e
	ld a,(de)		; $6770
	ld h,a			; $6771
	inc e			; $6772
	ld a,(de)		; $6773
	ld l,a			; $6774
	ld a,(hl)		; $6775
	or a			; $6776
	jr z,@updateItemBeingCollected	; $6777

	; Release the other item Maple was pulling up
	ld a,(de)		; $6779
	add Object.state			; $677a
	ld l,a			; $677c
	ld (hl),$01		; $677d

	add Object.angle-Object.state			; $677f
	ld l,a			; $6781
	ld (hl),$80		; $6782

	xor a			; $6784
	ld e,SpecialObject.relatedObj2		; $6785
	ld (de),a		; $6787

; Done with bomb-pulling code. Below is standard vacuum cleaner code.

@updateItemBeingCollected:
	; Fix collision radius after the above code changed it for bomb detection
	ld e,SpecialObject.collisionRadiusY		; $6788
	ld a,$02		; $678a
	ld (de),a		; $678c
	inc e			; $678d
	ld a,$02		; $678e
	ld (de),a		; $6790

; Vacuum-exclusive code is done.

@anyVehicle:
	ld e,SpecialObject.relatedObj2		; $6791
	ld a,(de)		; $6793
	or a			; $6794
	ret z			; $6795
	ld h,a			; $6796
	inc e			; $6797
	ld a,(de)		; $6798
	ld l,a			; $6799

	ldi a,(hl)		; $679a
	or a			; $679b
	jr z,@itemCollected	; $679c

	; Check bit 7 of item's subid?
	inc l			; $679e
	bit 7,(hl)		; $679f
	jr nz,@itemCollected	; $67a1

	; Check if they've collided (the part object writes to maple's "damageToApply"?)
	ld e,SpecialObject.damageToApply		; $67a3
	ld a,(de)		; $67a5
	or a			; $67a6
	ret z			; $67a7

	ld e,SpecialObject.relatedObj2		; $67a8
	ld a,(de)		; $67aa
	ld h,a			; $67ab
	ld l,Part.var03		; $67ac
	ld a,$80		; $67ae
	ld (hl),a		; $67b0

	xor a			; $67b1
	ld l,Part.invincibilityCounter		; $67b2
	ld (hl),a		; $67b4
	ld l,Part.collisionType		; $67b5
	ld (hl),a		; $67b7

	ld e,SpecialObject.stunCounter		; $67b8
	ld a,(de)		; $67ba
	ld hl,_mapleItemValues		; $67bb
	rst_addAToHl			; $67be
	ld a,$0e		; $67bf
	ld (de),a		; $67c1

	ld e,SpecialObject.health		; $67c2
	ld a,(de)		; $67c4
	ld b,a			; $67c5
	ld a,(hl)		; $67c6
	add b			; $67c7
	ld (de),a		; $67c8

	; If maple's on a broom, go to state $0a (dusting animation); otherwise go back to
	; state $06 (start heading toward the next item)
	ld e,SpecialObject.damage		; $67c9
	ld a,(de)		; $67cb
	or a			; $67cc
	jr nz,@itemCollected	; $67cd

	ld a,$0a		; $67cf
	jr @setState		; $67d1

@itemCollected:
	; Return if Maple's still pulling up a real bomb
	ld h,d			; $67d3
	ld l,SpecialObject.relatedObj1		; $67d4
	ldi a,(hl)		; $67d6
	or (hl)			; $67d7
	ret nz			; $67d8

	ld a,$06		; $67d9
@setState:
	ld e,SpecialObject.state		; $67db
	ld (de),a		; $67dd

	; Update direction with target direction. (I don't think this has been updated? So
	; she'll still be moving in the direction she was headed to reach this item.)
	ld e,SpecialObject.var3d		; $67de
	ld a,(de)		; $67e0
	ld e,SpecialObject.angle		; $67e1
	ld (de),a		; $67e3
	ret			; $67e4

;;
; State A: Maple doing her dusting animation after getting an item (broom only)
; @addr{67e5}
_mapleStateA:
	call specialObjectAnimate		; $67e5
	call itemDecCounter2		; $67e8
	ret nz			; $67eb

	ld l,SpecialObject.state		; $67ec
	ld (hl),$06		; $67ee

	; [zh] = [direction]. ???
	ld l,SpecialObject.direction		; $67f0
	ld a,(hl)		; $67f2
	ld l,SpecialObject.zh		; $67f3
	ld (hl),a		; $67f5

	ld a,$04		; $67f6
	jp specialObjectSetAnimation		; $67f8

;;
; State 8: stunned from a bomb
; @addr{67fb}
_mapleState8:
	call specialObjectAnimate		; $67fb
	ld e,SpecialObject.state2		; $67fe
	ld a,(de)		; $6800
	rst_jumpTable			; $6801
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemDecCounter2		; $680a
	ret nz			; $680d

	ld l,SpecialObject.state2		; $680e
	ld (hl),$01		; $6810

	ld l,SpecialObject.speedZ		; $6812
	xor a			; $6814
	ldi (hl),a		; $6815
	ld (hl),a		; $6816

	ld a,$13		; $6817
	jp specialObjectSetAnimation		; $6819

@substate1:
	ld c,$40		; $681c
	call objectUpdateSpeedZ_paramC		; $681e
	ret nz			; $6821

	ld l,SpecialObject.state2		; $6822
	ld (hl),$02		; $6824
	ld l,SpecialObject.counter2		; $6826
	ld (hl),$40		; $6828
	ret			; $682a

@substate2:
	call itemDecCounter2		; $682b
	ret nz			; $682e

	ld l,SpecialObject.state2		; $682f
	ld (hl),$03		; $6831
	ld a,$08		; $6833
	jp specialObjectSetAnimation		; $6835

@substate3:
	ld h,d			; $6838
	ld l,SpecialObject.zh		; $6839
	dec (hl)		; $683b
	ld a,(hl)		; $683c
	cp $e9			; $683d
	ret nc			; $683f

	; Go back to state 6 (moving toward next item)
	ld l,SpecialObject.state		; $6840
	ld (hl),$06		; $6842

	ld l,SpecialObject.health		; $6844
	inc (hl)		; $6846

	ld l,SpecialObject.speedZ		; $6847
	ld a,$40		; $6849
	ldi (hl),a		; $684b
	ld (hl),$00		; $684c

	jp _mapleDecideItemToCollectAndUpdateTargetAngle		; $684e

;;
; State 9: flying away after item collection is over
; @addr{6851}
_mapleState9:
	call specialObjectAnimate		; $6851
	ld e,SpecialObject.state2		; $6854
	ld a,(de)		; $6856
	rst_jumpTable			; $6857
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Substate 0: display text
@substate0:
	call retIfTextIsActive		; $685e

	ld a,$3c		; $6861
	ld (wInstrumentsDisabledCounter),a		; $6863

	ld a,$01		; $6866
	ld (de),a ; [state2] = $01

	; "health" is maple's obtained value, and "var2a" is Link's obtained value.

	; Check if either of them got anything
	ld h,d			; $6869
	ld l,SpecialObject.health		; $686a
	ldi a,(hl)		; $686c
	ld b,a			; $686d
	or (hl) ; hl = SpecialObject.var2a
	jr z,@showText		; $686f

	; Check for draw, or maple got more, or link got more
	ld a,(hl)		; $6871
	cp b			; $6872
	ld a,$01		; $6873
	jr z,@showText		; $6875
	inc a			; $6877
	jr c,@showText		; $6878
	inc a			; $687a

@showText:
	ld hl,@textIndices		; $687b
	rst_addDoubleIndex			; $687e
	ld c,(hl)		; $687f
	inc hl			; $6880
	ld b,(hl)		; $6881
	call showText		; $6882

	call _mapleGetCardinalAngleTowardLink		; $6885
	call convertAngleToDirection		; $6888
	add $04			; $688b
	ld b,a			; $688d
	ld e,SpecialObject.damage		; $688e
	ld a,(de)		; $6890
	add a			; $6891
	add a			; $6892
	add b			; $6893
	jp specialObjectSetAnimation		; $6894

@textIndices:
	.dw TX_070c ; 0: nothing obtained by maple or link
	.dw TX_0708 ; 1: draw
	.dw TX_0706 ; 2: maple got more
	.dw TX_0707 ; 3: link got more


; Substate 1: wait until textbox is closed
@substate1:
	call _mapleUpdateOscillation		; $689f
	call retIfTextIsActive		; $68a2

	ld a,$80		; $68a5
	ld (wTextIsActive),a		; $68a7
	ld a,$1f		; $68aa
	ld (wDisabledObjects),a		; $68ac

	ld l,SpecialObject.angle		; $68af
	ld (hl),$18		; $68b1
	ld l,SpecialObject.speed		; $68b3
	ld (hl),SPEED_300		; $68b5

	ld l,SpecialObject.state2		; $68b7
	ld (hl),$02		; $68b9

	ld e,SpecialObject.damage		; $68bb
	ld a,(de)		; $68bd
	add a			; $68be
	add a			; $68bf
	add $07			; $68c0
	jp specialObjectSetAnimation		; $68c2


; Substate 2: moving until off screen
@substate2:
	call _mapleUpdateOscillation		; $68c5
	call objectApplySpeed		; $68c8
	call objectCheckWithinScreenBoundary		; $68cb
	ret c			; $68ce

;;
; Increments meeting counter, deletes maple, etc.
; @addr{68cf}
_mapleEndEncounter:
	xor a			; $68cf
	ld (wTextIsActive),a		; $68d0
	ld (wDisabledObjects),a		; $68d3
	ld (wMenuDisabled),a		; $68d6
	ld (wDisableScreenTransitions),a		; $68d9
	call _mapleIncrementMeetingCounter		; $68dc

	; Fall through

;;
; @addr{68df}
_mapleDeleteSelf:
	ld a,(wActiveMusic2)		; $68df
	ld (wActiveMusic),a		; $68e2
	call playSound		; $68e5
	pop af			; $68e8
	xor a			; $68e9
	ld (wIsMaplePresent),a		; $68ea
	jp itemDelete		; $68ed


;;
; State B: exchanging touching book
; @addr{68f0}
_mapleStateB:
	inc e			; $68f0
	ld a,(de) ; a = [state2]
	or a			; $68f2
	jr nz,@substate1	; $68f3

@substate0:
	call _mapleUpdateOscillation		; $68f5
.ifdef ROM_AGES
	ld e,SpecialObject.direction		; $68f8
	ld a,(de)		; $68fa
	bit 7,a			; $68fb
	jr z,+			; $68fd
	and $03			; $68ff
	jr @determineAnimation		; $6901
+
.endif

	call objectGetAngleTowardLink		; $6903
	call convertAngleToDirection		; $6906
	ld h,d			; $6909
	ld l,SpecialObject.direction		; $690a
	cp (hl)			; $690c
	ld (hl),a		; $690d
	jr z,@waitForText	; $690e

@determineAnimation:
	add $04			; $6910
	ld b,a			; $6912
	ld e,SpecialObject.damage		; $6913
	ld a,(de)		; $6915
	add a			; $6916
	add a			; $6917
	add b			; $6918
	call specialObjectSetAnimation		; $6919

@waitForText:
	call retIfTextIsActive		; $691c

	ld hl,wMapleState		; $691f
	set 5,(hl)		; $6922
	ld e,SpecialObject.angle		; $6924
	ld a,(de)		; $6926
	rlca			; $6927
	jp nc,objectApplySpeed		; $6928
	ret			; $692b

@substate1:
	dec a			; $692c
	ld (de),a ; [state2] -= 1
	ret nz			; $692e

.ifdef ROM_AGES
	ld bc,TX_0711		; $692f
.else
	ld bc,TX_070b		; $692f
.endif
	call showText		; $6932
	ld e,SpecialObject.angle		; $6935
	ld a,$18		; $6937
	ld (de),a		; $6939

	; Go to state $0c
	call itemIncState		; $693a

	ld l,SpecialObject.speed		; $693d
	ld (hl),SPEED_300		; $693f

	; Fall through

;;
; State C: leaving after reading touching book
; @addr{6941}
_mapleStateC:
	call _mapleUpdateOscillation		; $6941
	call retIfTextIsActive		; $6944

	call objectApplySpeed		; $6947

	ld e,SpecialObject.damage		; $694a
	ld a,(de)		; $694c
	add a			; $694d
	add a			; $694e
	add $07			; $694f
	ld hl,wMapleState		; $6951
	bit 4,(hl)		; $6954
	res 4,(hl)		; $6956
	call nz,specialObjectSetAnimation		; $6958

	call objectCheckWithinScreenBoundary		; $695b
	ret c			; $695e
	jp _mapleEndEncounter		; $695f


;;
; Adjusts Maple's X and Y position to keep them in-bounds.
; @addr{6962}
_mapleKeepInBounds:
	ld e,SpecialObject.yh		; $6962
	ld a,(de)		; $6964
	cp $f0			; $6965
	jr c,+			; $6967
	xor a			; $6969
+
	cp $20			; $696a
	jr nc,++		; $696c
	ld a,$20		; $696e
	ld (de),a		; $6970
	jr @checkX		; $6971
++
	cp SCREEN_HEIGHT*16 - 8			; $6973
	jr c,@checkX	; $6975
	ld a,SCREEN_HEIGHT*16 - 8		; $6977
	ld (de),a		; $6979

@checkX:
	ld e,SpecialObject.xh		; $697a
	ld a,(de)		; $697c
	cp $f0			; $697d
	jr c,+			; $697f
	xor a			; $6981
+
	cp $08			; $6982
	jr nc,++		; $6984
	ld a,$08		; $6986
	ld (de),a		; $6988
	jr @ret			; $6989
++
	cp SCREEN_WIDTH*16 - 8			; $698b
	jr c,@ret		; $698d
	ld a,SCREEN_WIDTH*16 - 8		; $698f
	ld (de),a		; $6991
@ret:
	ret			; $6992


;;
; @addr{6993}
_mapleSpawnItemDrops:
	; Check if Link has the touching book
	ld a,TREASURE_TRADEITEM		; $6993
	call checkTreasureObtained		; $6995
	jr nc,@noTradeItem	; $6998
.ifdef ROM_AGES
	cp $08			; $699a
.else
	cp $01			; $699a
.endif
	jr nz,@noTradeItem	; $699c

.ifdef ROM_AGES
	ld b,INTERACID_TOUCHING_BOOK		; $699e
.else
	ld b,INTERACID_GHASTLY_DOLL		; $699e
.endif
	call objectCreateInteractionWithSubid00		; $69a0
	ret nz			; $69a3
	ld hl,wMapleState		; $69a4
	set 4,(hl)		; $69a7
	ret			; $69a9

@noTradeItem:
	; Clear health and var2a (the total value of the items Maple and Link have
	; collected, respectively)
	ld e,SpecialObject.var2a		; $69aa
	xor a			; $69ac
	ld (de),a		; $69ad
	ld e,SpecialObject.health		; $69ae
	ld (de),a		; $69b0

; Spawn 5 items from Maple

	ld e,SpecialObject.counter1		; $69b1
	ld a,$05		; $69b3
	ld (de),a		; $69b5

@nextMapleItem:
	ld e,SpecialObject.var03 ; If var03 is 0, rarer items will be dropped
	ld a,(de)		; $69b8
	ld hl,_maple_itemDropDistributionTable		; $69b9
	rst_addDoubleIndex			; $69bc
	ldi a,(hl)		; $69bd
	ld h,(hl)		; $69be
	ld l,a			; $69bf
	call getRandomIndexFromProbabilityDistribution		; $69c0

	ld a,b			; $69c3
	call @checkSpawnItem		; $69c4
	jr c,+			; $69c7
	jr nz,@nextMapleItem	; $69c9
+
	ld e,SpecialObject.counter1		; $69cb
	ld a,(de)		; $69cd
	dec a			; $69ce
	ld (de),a		; $69cf
	jr nz,@nextMapleItem	; $69d0

; Spawn 5 items from Link

	; hFF8C acts as a "drop attempt" counter. It's possible that Link will run out of
	; things to drop, so it'll stop trying eventually.
	ld a,$20		; $69d2
	ldh (<hFF8C),a	; $69d4

	ld e,SpecialObject.counter1		; $69d6
	ld a,$05		; $69d8
	ld (de),a		; $69da

@nextLinkItem:
	ldh a,(<hFF8C)	; $69db
	dec a			; $69dd
	ldh (<hFF8C),a	; $69de
	jr z,@ret	; $69e0

	ld hl,_maple_linkItemDropDistribution		; $69e2
	call getRandomIndexFromProbabilityDistribution		; $69e5

	call _mapleCheckLinkCanDropItem		; $69e8
	jr z,@nextLinkItem	; $69eb

	ld d,>w1Link		; $69ed
	call _mapleSpawnItemDrop		; $69ef

	ld d,>w1Companion		; $69f2
	ld e,SpecialObject.counter1		; $69f4
	ld a,(de)		; $69f6
	dec a			; $69f7
	ld (de),a		; $69f8
	jr nz,@nextLinkItem	; $69f9
@ret:
	ret			; $69fb

;;
; @param	a	Index of item to drop
; @param[out]	cflag	Set if it's ok to drop this item
; @param[out]	zflag
; @addr{69fc}
@checkSpawnItem:
	; Check that Link has obtained the item (if applicable)
	push af			; $69fc
	ld hl,_mapleItemDropTreasureIndices		; $69fd
	rst_addAToHl			; $6a00
	ld a,(hl)		; $6a01
	call checkTreasureObtained		; $6a02
	pop hl			; $6a05
	jr c,@obtained		; $6a06
	or d			; $6a08
	ret			; $6a09

@obtained:
	ld a,h			; $6a0a
	ldh (<hFF8B),a	; $6a0b

	; Skip the below conditions for all items of index 5 or above (items that can be
	; dropped multiple times)
	cp $05			; $6a0d
	jp nc,_mapleSpawnItemDrop		; $6a0f

	; If this is the heart piece, only drop it if it hasn't been obtained yet
	or a			; $6a12
	jr nz,@notHeartPiece	; $6a13
	ld a,(wMapleState)		; $6a15
	bit 7,a			; $6a18
	ret nz			; $6a1a
	ld e,SpecialObject.invincibilityCounter		; $6a1b
	ld a,(de)		; $6a1d
	or a			; $6a1e
	ret nz			; $6a1f

	inc a			; $6a20
	ld (de),a		; $6a21
	jr @spawnItem		; $6a22

@notHeartPiece:
	dec a			; $6a24
	ld hl,@itemBitmasks		; $6a25
	rst_addAToHl			; $6a28
	ld b,(hl)		; $6a29
	ld e,SpecialObject.knockbackAngle		; $6a2a
	ld a,(de)		; $6a2c
	and b			; $6a2d
	ret nz			; $6a2e
	ld a,(de)		; $6a2f
	or b			; $6a30
	ld (de),a		; $6a31

@spawnItem:
	jr _mapleSpawnItemDrop_variant		; $6a32


; Bitmasks for items 1-5 for remembering if one's spawned already
@itemBitmasks:
	.db $04 $02 $02 $01


; The following are probability distributions for maple's dropped items. The sum of the
; numbers in each distribution should be exactly $100. An item with a higher number has
; a higher chance of dropping.

_maple_itemDropDistributionTable: ; Probabilities that Maple will drop something
	.dw @rareItems
	.dw @standardItems

@rareItems:
	.db $14 $0e $0e $1e $20 $00 $00 $00
	.db $00 $00 $28 $2e $28 $14

@standardItems:
	.db $00 $02 $04 $08 $0a $00 $00 $00
	.db $00 $00 $32 $34 $3c $46


_maple_linkItemDropDistribution: ; Probabilities that Link will drop something
	.db $00 $00 $00 $00 $00 $20 $20 $20
	.db $20 $20 $20 $20 $00 $20


; Each byte is the "value" of an item. The values of the items Link and Maple pick up are
; added up and totalled to see who "won" the encounter.
_mapleItemValues:
	.db $3c $0f $0a $08 $06 $05 $05 $05
	.db $05 $05 $04 $03 $02 $01 $00


; Given an index of an item drop, the corresponding value in the table below is a treasure
; to check if Link's obtained in order to allow Maple to drop it. "TREASURE_PUNCH" is
; always considered obtained, so it's used as a value to mean "always drop this".
;
; Item indices:
;  $00: heart piece
;  $01: gasha seed
;  $02: ring
;  $03: ring (different class?)
;  $04: potion
;  $05: ember seeds
;  $06: scent seeds
;  $07: pegasus seeds
;  $08: gale seeds
;  $09: mystery seeds
;  $0a: bombs
;  $0b: heart
;  $0c: 5 rupees
;  $0d: 1 rupee

_mapleItemDropTreasureIndices:
	.db TREASURE_PUNCH      TREASURE_PUNCH         TREASURE_PUNCH       TREASURE_PUNCH
	.db TREASURE_PUNCH      TREASURE_EMBER_SEEDS   TREASURE_SCENT_SEEDS TREASURE_PEGASUS_SEEDS
	.db TREASURE_GALE_SEEDS TREASURE_MYSTERY_SEEDS TREASURE_BOMBS       TREASURE_PUNCH
	.db TREASURE_PUNCH      TREASURE_PUNCH

;;
; @param	d	Object it comes from (Link or Maple)
; @param	hFF8B	Value for part's subid and var03 (item type?)
; @addr{6a83}
_mapleSpawnItemDrop:
	call getFreePartSlot		; $6a83
	scf			; $6a86
	ret nz			; $6a87
	ld (hl),PARTID_ITEM_FROM_MAPLE		; $6a88
	ld e,SpecialObject.yh		; $6a8a
	call objectCopyPosition_rawAddress		; $6a8c
	ldh a,(<hFF8B)	; $6a8f
	ld l,Part.var03		; $6a91
	ldd (hl),a ; [var03] = [hFF8B]
	ld (hl),a  ; [subid] = [hFF8B]
	xor a			; $6a95
	ret			; $6a96

;;
; @param	d	Object it comes from (Link or Maple)
; @param	hFF8B	Value for part's subid and var03 (item type?)
; @addr{6a97}
_mapleSpawnItemDrop_variant:
	call getFreePartSlot		; $6a97
	scf			; $6a9a
	ret nz			; $6a9b
	ld (hl),PARTID_ITEM_FROM_MAPLE_2		; $6a9c
	ld l,Part.subid		; $6a9e
	ldh a,(<hFF8B)	; $6aa0
	ldi (hl),a		; $6aa2
	ld (hl),a		; $6aa3
	call objectCopyPosition		; $6aa4
	or a			; $6aa7
	ret			; $6aa8

;;
; Decides what Maple's next item target should be.
;
; @param[out]	hl	The part object to go for
; @param[out]	zflag	nz if there are no items left
; @addr{6aa9}
_mapleDecideItemToCollect:

; Search for item IDs 0-4 first

	ld b,$00		; $6aa9

@idLoop1
	ldhl FIRST_PART_INDEX, Part.enabled		; $6aab

@partLoop1:
	ld l,Part.enabled		; $6aae
	ldi a,(hl)		; $6ab0
	or a			; $6ab1
	jr z,@nextPart1			; $6ab2

	ldi a,(hl)		; $6ab4
	cp PARTID_ITEM_FROM_MAPLE_2			; $6ab5
	jr nz,@nextPart1		; $6ab7

	ldd a,(hl)		; $6ab9
	cp b			; $6aba
	jr nz,@nextPart1		; $6abb

	; Found an item to go for
	dec l			; $6abd
	xor a			; $6abe
	ret			; $6abf

@nextPart1:
	inc h			; $6ac0
	ld a,h			; $6ac1
	cp LAST_PART_INDEX+1			; $6ac2
	jr c,@partLoop1		; $6ac4

	inc b			; $6ac6
	ld a,b			; $6ac7
	cp $05			; $6ac8
	jr c,@idLoop1		; $6aca

; Now search for item IDs $05-$0d

	xor a			; $6acc
	ld c,$00		; $6acd
	ld hl,@itemIDs		; $6acf
	rst_addAToHl			; $6ad2
	ld a,(hl)		; $6ad3
	ld b,a			; $6ad4
	xor a			; $6ad5
	ldh (<hFF91),a	; $6ad6

@idLoop2:
	ldhl FIRST_PART_INDEX, Part.enabled		; $6ad8

@partLoop2:
	ld l,Part.enabled		; $6adb
	ldi a,(hl)		; $6add
	or a			; $6ade
	jr z,@nextPart2		; $6adf

	ldi a,(hl)		; $6ae1
	cp PARTID_ITEM_FROM_MAPLE			; $6ae2
	jr nz,@nextPart2		; $6ae4

	ldd a,(hl)		; $6ae6
	cp b			; $6ae7
	jr nz,@nextPart2		; $6ae8

; We've found an item to go for. However, we'll only pick this one if it's closest of its
; type. Start by calculating maple's distance from it.

	ld l,Part.yh		; $6aea
	ld l,(hl)		; $6aec
	ld e,SpecialObject.yh		; $6aed
	ld a,(de)		; $6aef
	sub l			; $6af0
	jr nc,+			; $6af1
	cpl			; $6af3
	inc a			; $6af4
+
	ldh (<hFF8C),a	; $6af5
	ld l,Part.xh		; $6af7
	ld l,(hl)		; $6af9
	ld e,SpecialObject.xh		; $6afa
	ld a,(de)		; $6afc
	sub l			; $6afd
	jr nc,+			; $6afe
	cpl			; $6b00
	inc a			; $6b01
+
	ld l,a			; $6b02
	ldh a,(<hFF8C)	; $6b03
	add l			; $6b05
	ld l,a			; $6b06

; l now contains the distance to the item. Check if it's less than the closest item's
; distance (stored in hFF8D), or if this is the first such item (index stored in hFF91).

	ldh a,(<hFF91)	; $6b07
	or a			; $6b09
	jr z,++			; $6b0a
	ldh a,(<hFF8D)	; $6b0c
	cp l			; $6b0e
	jr c,@nextPart2		; $6b0f
++
	ld a,l			; $6b11
	ldh (<hFF8D),a	; $6b12
	ld a,h			; $6b14
	ldh (<hFF91),a	; $6b15

@nextPart2:
	inc h			; $6b17
	ld a,h			; $6b18
	cp $e0			; $6b19
	jr c,@partLoop2		; $6b1b

	; If we found an item of this type, return.
	ldh a,(<hFF91)	; $6b1d
	or a			; $6b1f
	jr nz,@foundItem	; $6b20

	; Otherwise, try the next item type.
	inc c			; $6b22
	ld a,c			; $6b23
	cp $09			; $6b24
	jr nc,@noItemsLeft	; $6b26

	ld hl,@itemIDs		; $6b28
	rst_addAToHl			; $6b2b
	ld a,(hl)		; $6b2c
	ld b,a			; $6b2d
	jr @idLoop2		; $6b2e

@noItemsLeft:
	; This will unset the zflag, since a=$09 and d=$d1... but they probably meant to
	; write "or d" to produce that effect. (That's what they normally do.)
	and d			; $6b30
	ret			; $6b31

@foundItem:
	ld h,a			; $6b32
	ld l,Part.enabled		; $6b33
	xor a			; $6b35
	ret			; $6b36

@itemIDs:
	.db $05 $06 $07 $08 $09 $0a $0b $0c
	.db $0d


;;
; Searches for a bomb item (an actual bomb that will explode). If one exists, and isn't
; currently exploding, it gets set as Maple's relatedObj1.
;
; @param[out]	zflag	z if the first bomb object found was suitable
; @addr{6b40}
_mapleFindUnexplodedBomb:
	ld e,SpecialObject.relatedObj1		; $6b40
	xor a			; $6b42
	ld (de),a		; $6b43
	inc e			; $6b44
	ld (de),a		; $6b45
	ld c,ITEMID_BOMB		; $6b46
	call findItemWithID		; $6b48
	ret nz			; $6b4b
	jr ++			; $6b4c

;;
; This is similar to above, except it's a "continuation" in case the first bomb that was
; found was unsuitable (in the process of exploding).
;
; @addr{6b4e}
_mapleFindNextUnexplodedBomb:
	ld c,ITEMID_BOMB		; $6b4e
	call findItemWithID_startingAfterH		; $6b50
	ret nz			; $6b53
++
	ld l,Item.var2f		; $6b54
	ld a,(hl)		; $6b56
	bit 7,a			; $6b57
	jr nz,++		; $6b59
	and $60			; $6b5b
	ret nz			; $6b5d
	ld l,$0f		; $6b5e
	bit 7,(hl)		; $6b60
	ret nz			; $6b62
++
	ld e,SpecialObject.relatedObj1		; $6b63
	ld a,h			; $6b65
	ld (de),a		; $6b66
	inc e			; $6b67
	xor a			; $6b68
	ld (de),a		; $6b69
	ret			; $6b6a

;;
; @addr{6b6b}
_mapleInitZPositionAndSpeed:
	ld h,d			; $6b6b
	ld l,SpecialObject.zh		; $6b6c
	ld a,$f8		; $6b6e
	ldi (hl),a		; $6b70

	ld l,SpecialObject.speedZ		; $6b71
	ld (hl),$40		; $6b73
	inc l			; $6b75
	ld (hl),$00		; $6b76

	ld l,SpecialObject.var3c		; $6b78
	ld a,$16		; $6b7a
	ldi (hl),a		; $6b7c
	ret			; $6b7d

;;
; @param[out]	a	Angle toward link (rounded to cardinal direction)
; @addr{6b7e}
_mapleGetCardinalAngleTowardLink:
	call objectGetAngleTowardLink		; $6b7e
	and $18			; $6b81
	ret			; $6b83

;;
; Decides what item Maple should go for, and updates var3d appropriately (the angle she's
; turning toward).
;
; If there are no more items, this sets Maple's state to $09.
;
; @addr{6b84}
_mapleDecideItemToCollectAndUpdateTargetAngle:
	call _mapleDecideItemToCollect		; $6b84
	jr nz,@noMoreItems	; $6b87

	ld e,SpecialObject.relatedObj2		; $6b89
	ld a,h			; $6b8b
	ld (de),a		; $6b8c
	inc e			; $6b8d
	ld a,l			; $6b8e
	ld (de),a		; $6b8f
	ld e,SpecialObject.damageToApply		; $6b90
	xor a			; $6b92
	ld (de),a		; $6b93
	jr _mapleSetTargetDirectionToRelatedObj2		; $6b94

@noMoreItems:
	ld e,SpecialObject.state		; $6b96
	ld a,$09		; $6b98
	ld (de),a		; $6b9a
	inc e			; $6b9b
	xor a			; $6b9c
	ld (de),a ; [state2] = 0
	ret			; $6b9e

;;
; @addr{6b9f}
_mapleSetTargetDirectionToRelatedObj2:
	ld e,SpecialObject.relatedObj2		; $6b9f
	ld a,(de)		; $6ba1
	ld h,a			; $6ba2
	inc e			; $6ba3
	ld a,(de)		; $6ba4
	or Object.yh			; $6ba5
	ld l,a			; $6ba7

	ldi a,(hl)		; $6ba8
	ld b,a			; $6ba9
	inc l			; $6baa
	ld a,(hl)		; $6bab
	ld c,a			; $6bac
	call objectGetRelativeAngle		; $6bad
	ld e,SpecialObject.var3d		; $6bb0
	ld (de),a		; $6bb2
	ret			; $6bb3

;;
; Checks if Link can drop an item in Maple's minigame, and removes the item amount from
; his inventory if he can.
;
; This function is bugged. The programmers mixed up the "treasure indices" with maple's
; item indices. As a result, the incorrect treasures are checked to be obtained; for
; example, pegasus seeds check that Link has obtained the rod of seasons. This means
; pegasus seeds will never drop in Ages. Similarly, gale seeds check the magnet gloves.
;
; @param	b	The item to drop
; @param[out]	hFF8B	The "maple item index" of the item to be dropped
; @param[out]	zflag	nz if Link can drop it
; @addr{6bb4}
_mapleCheckLinkCanDropItem:
	ld a,b			; $6bb4
	sub $05			; $6bb5
	ld b,a			; $6bb7
	rst_jumpTable			; $6bb8
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @bombs
	.dw @heart
	.dw @heart ; This should be 5 rupees, but Link never drops that.
	.dw @oneRupee

@oneRupee:
	ld hl,wNumRupees		; $6bcb
	ldi a,(hl)		; $6bce
	or (hl)			; $6bcf
	ret z			; $6bd0
	ld a,$01		; $6bd1
	call removeRupeeValue		; $6bd3
	ld a,$0c		; $6bd6
	jr @setMapleItemIndex		; $6bd8

@bombs:
	; $0a corresponds to bombs in maple's treasure indices, but for the purpose of the
	; "checkTreasureObtained" call, it actually corresponds to "TREASURE_SWITCH_HOOK"!
	ld a,$0a		; $6bda
	ldh (<hFF8B),a	; $6bdc
	call checkTreasureObtained		; $6bde
	jr nc,@cannotDrop	; $6be1

	ld hl,wNumBombs		; $6be3
	ld a,(hl)		; $6be6
	sub $04			; $6be7
	jr c,@cannotDrop	; $6be9
	daa			; $6beb
	ld (hl),a		; $6bec
	call setStatusBarNeedsRefreshBit1		; $6bed
	or d			; $6bf0
	ret			; $6bf1

@seed:
	; BUG: For the purpose of "checkTreasureObtained", the treasure index will be very
	; wrong.
	;   Ember seed:   TREASURE_SWORD
	;   Scent seed:   TREASURE_BOOMERANG
	;   Pegasus seed: TREASURE_ROD_OF_SEASONS
	;   Gale seed:    TREASURE_MAGNET_GLOVES
	;   Mystery seed: TREASURE_SWITCH_HOOK_HELPER
	ld a,b			; $6bf2
	add $05			; $6bf3
	ldh (<hFF8B),a	; $6bf5
	call checkTreasureObtained		; $6bf7
	jr nc,@cannotDrop	; $6bfa

	; See if we can remove 5 of the seed type from the inventory
	ld a,b			; $6bfc
	ld hl,wNumEmberSeeds		; $6bfd
	rst_addAToHl			; $6c00
	ld a,(hl)		; $6c01
	sub $05			; $6c02
	jr c,@cannotDrop	; $6c04
	daa			; $6c06
	ld (hl),a		; $6c07

	call setStatusBarNeedsRefreshBit1		; $6c08
	or d			; $6c0b
	ret			; $6c0c

@cannotDrop:
	xor a			; $6c0d
	ret			; $6c0e

@heart:
	ld hl,wLinkHealth		; $6c0f
	ld a,(hl)		; $6c12
	cp 12 ; Check for at least 3 hearts
	jr nc,+			; $6c15
	xor a			; $6c17
	ret			; $6c18
+
	sub $04			; $6c19
	ld (hl),a		; $6c1b

	ld hl,wStatusBarNeedsRefresh		; $6c1c
	set 2,(hl)		; $6c1f

	ld a,$0b		; $6c21

@setMapleItemIndex:
	ldh (<hFF8B),a	; $6c23
	or d			; $6c25
	ret			; $6c26

;;
; @param[out]	a	Maple.damage variable (actually vehicle type)
; @param[out]	zflag	z if Maple's in a wall? (she won't do her sweeping animation)
; @addr{6c27}
_mapleFunc_6c27:
	ld e,SpecialObject.counter2		; $6c27
	ld a,$30		; $6c29
	ld (de),a		; $6c2b

	; [direction] = [zh]. ???
	ld e,SpecialObject.zh		; $6c2c
	ld a,(de)		; $6c2e
	ld e,SpecialObject.direction		; $6c2f
	ld (de),a		; $6c31

	call objectGetTileCollisions		; $6c32
	jr nz,@collision	; $6c35
	ld e,SpecialObject.zh		; $6c37
	xor a			; $6c39
	ld (de),a		; $6c3a
	or d			; $6c3b
	ld e,SpecialObject.damage		; $6c3c
	ld a,(de)		; $6c3e
	ret			; $6c3f
@collision:
	xor a			; $6c40
	ret			; $6c41

;;
; Increments lower 4 bits of wMapleState (the number of times Maple has been met)
; @addr{6c42}
_mapleIncrementMeetingCounter:
	ld hl,wMapleState		; $6c42
	ld a,(hl)		; $6c45
	and $0f			; $6c46
	ld b,a			; $6c48
	cp $0f			; $6c49
	jr nc,+			; $6c4b
	inc b			; $6c4d
+
	xor (hl)		; $6c4e
	or b			; $6c4f
	ld (hl),a		; $6c50
	ret			; $6c51


; These are the possible paths Maple can take when you just see her shadow.
_mapleShadowPathsTable:
	.dw @rareItemDrops
	.dw @standardItemDrops

; Data format:
;   First byte is the delay it takes to change angles. (Higher values make larger arcs.)
;   Each subsequent row is:
;     b0: target angle
;     b1: number of frames to move in that direction (not counting time it takes to turn)
@rareItemDrops:
	.db $02
	.db $18 $64
	.db $10 $02
	.db $08 $1e
	.db $10 $02
	.db $18 $7a
	.db $ff $ff

@standardItemDrops:
	.db $04
	.db $18 $64
	.db $10 $04
	.db $08 $64
	.db $ff $ff


; Maps a number to an index for the table below. At first, only the first 4 bytes are read
; at random from this table, but as maple is encountered more, the subsequent bytes are
; read, giving maple more variety in the way she moves.
_mapleMovementPatternIndices:
	.db $00 $01 $02 $00 $03 $04 $05 $03
	.db $06 $07 $01 $02 $04 $05 $06 $07

_mapleMovementPatternTable:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3
	.dw @pattern4
	.dw @pattern5
	.dw @pattern6
	.dw @pattern7

; Data format:
;   First row is the Y/X position for Maple to start at.
;   Second row is one byte for the delay it takes to change angles.
;   Each subsequent row is:
;     b0: target angle
;     b1: number of frames to move in that direction (not counting time it takes to turn)
@pattern0:
	.db $18 $b8
	.db $02
	.db $18 $4b
	.db $10 $01
	.db $08 $32
	.db $10 $01
	.db $18 $46
	.db $ff $ff

@pattern1:
	.db $70 $b8
	.db $02
	.db $18 $4b
	.db $00 $01
	.db $08 $32
	.db $00 $01
	.db $18 $46
	.db $ff $ff

@pattern2:
	.db $18 $f0
	.db $02
	.db $08 $46
	.db $10 $19
	.db $18 $28
	.db $00 $14
	.db $08 $19
	.db $10 $0f
	.db $18 $14
	.db $00 $0a
	.db $08 $0f
	.db $10 $32
	.db $ff $ff

@pattern3:
	.db $a0 $90
	.db $02
	.db $00 $37
	.db $18 $01
	.db $10 $19
	.db $18 $01
	.db $00 $19
	.db $18 $01
	.db $10 $3c
	.db $ff $ff

@pattern4:
	.db $a0 $10
	.db $02
	.db $00 $37
	.db $08 $01
	.db $10 $19
	.db $08 $01
	.db $00 $19
	.db $08 $01
	.db $10 $3c
	.db $ff $ff

@pattern5:
	.db $18 $f0
	.db $01
	.db $08 $28
	.db $16 $0f
	.db $08 $2d
	.db $16 $0a
	.db $08 $37
	.db $ff $ff

@pattern6:
	.db $f0 $30
	.db $02
	.db $14 $19
	.db $05 $11
	.db $14 $0a
	.db $17 $05
	.db $10 $01
	.db $05 $1e
	.db $14 $1e
	.db $ff $ff

@pattern7:
	.db $f0 $70
	.db $02
	.db $0c $19
	.db $1b $11
	.db $0c $08
	.db $0a $02
	.db $10 $01
	.db $1b $0f
	.db $0c $1e
	.db $ff $ff



;;
; @addr{6d1e}
_specialObjectCode_ricky:
	call _companionRetIfInactive		; $6d1e
	call _companionFunc_47d8		; $6d21
	call @runState		; $6d24
	jp _companionCheckEnableTerrainEffects		; $6d27

@runState:
	ld e,SpecialObject.state		; $6d2a
	ld a,(de)		; $6d2c
	rst_jumpTable			; $6d2d
	.dw _rickyState0
	.dw _rickyState1
	.dw _rickyState2
	.dw _rickyState3
	.dw _rickyState4
	.dw _rickyState5
	.dw _rickyState6
	.dw _rickyState7
	.dw _rickyState8
	.dw _rickyState9
	.dw _rickyStateA
	.dw _rickyStateB
	.dw _rickyStateC

;;
; State 0: initialization
; @addr{6d48}
_rickyState0:
_rickyStateB:
	call _companionCheckCanSpawn ; This may return

	ld a,$06		; $6d4b
	call objectSetCollideRadius		; $6d4d

	ld a,DIR_DOWN		; $6d50
	ld l,SpecialObject.direction		; $6d52
	ldi (hl),a		; $6d54
	ld (hl),a ; [angle] = $02

	ld l,SpecialObject.var39		; $6ca2
	ld (hl),$10		; $6ca4
	ld a,(wRickyState)		; $6ca6

.ifdef ROM_AGES
	bit 7,a			; $6d5d
	jr nz,@setAnimation17	; $6d5f

	ld c,$17		; $6d61
	bit 6,a			; $6d63
	jr nz,@canTalkToRicky	; $6d65

	and $20			; $6d67
	jr nz,@setAnimation17	; $6d69

	ld c,$00		; $6d6b
.else
	and $80			; $6ca9
	jr nz,@setAnimation17	; $6cab
.endif

@canTalkToRicky:
	; Ricky not ridable yet, can press A to talk to him
	ld l,SpecialObject.state		; $6d6d
	ld (hl),$0a		; $6d6f
	ld e,SpecialObject.var3d		; $6d71
	call objectAddToAButtonSensitiveObjectList		; $6d73
.ifdef ROM_AGES
	ld a,c			; $6d76
.else
	ld a,$00			; $6d76
.endif
	jr @setAnimation		; $6d77

@setAnimation17:
	ld a,$17		; $6d79

@setAnimation:
	call specialObjectSetAnimation		; $6d7b
	jp objectSetVisiblec1		; $6d7e

;;
; State 1: waiting for Link to mount
; @addr{6d81}
_rickyState1:
	call specialObjectAnimate		; $6d81
	call _companionSetPriorityRelativeToLink		; $6d84

	ld c,$09		; $6d87
	call objectCheckLinkWithinDistance		; $6d89
	jr nc,@didntMount	; $6d8c

	call _companionTryToMount		; $6d8e
	ret z			; $6d91

@didntMount:
	; Make Ricky hop every once in a while
	ld e,SpecialObject.animParameter		; $6d92
	ld a,(de)		; $6d94
	and $c0			; $6d95
	jr z,_rickyCheckHazards		; $6d97
	rlca			; $6d99
	ld c,$40		; $6d9a
	jp nc,objectUpdateSpeedZ_paramC		; $6d9c
	ld bc,$ff00		; $6d9f
	call objectSetSpeedZ		; $6da2

;;
; @addr{6da5}
_rickyCheckHazards:
	call _companionCheckHazards		; $6da5
	jp c,_rickyFunc_70cc		; $6da8

;;
; @addr{6dab}
_rickyState9:
	ret			; $6dab

;;
; State 2: Jumping up a cliff
; @addr{6dac}
_rickyState2:
	call _companionDecCounter1		; $6dac
	jr z,++			; $6daf
	dec (hl)		; $6db1
	ret nz			; $6db2
	ld a,SND_RICKY		; $6db3
	call playSound		; $6db5
++
	ld c,$40		; $6db8
	call objectUpdateSpeedZ_paramC		; $6dba
	call specialObjectAnimate		; $6dbd
	call objectApplySpeed		; $6dc0

	call _companionCalculateAdjacentWallsBitset		; $6dc3

	; Check whether Ricky's passed through any walls?
	ld e,SpecialObject.adjacentWallsBitset		; $6dc6
	ld a,(de)		; $6dc8
	and $0f			; $6dc9
	ld e,SpecialObject.counter2		; $6dcb
	jr z,+			; $6dcd
	ld (de),a		; $6dcf
	ret			; $6dd0
+
	ld a,(de)		; $6dd1
	or a			; $6dd2
	ret z			; $6dd3
	jp _rickyStopUntilLandedOnGround		; $6dd4

;;
; State 3: Link is currently jumping up to mount Ricky
; @addr{6dd7}
_rickyState3:
	ld c,$40		; $6dd7
	call objectUpdateSpeedZ_paramC		; $6dd9
	call _companionCheckMountingComplete		; $6ddc
	ret nz			; $6ddf

	call _companionFinalizeMounting		; $6de0
	ld a,SND_RICKY		; $6de3
	call playSound		; $6de5
	ld c,$20		; $6de8
	jp _companionSetAnimation		; $6dea

;;
; State 4: Ricky falling into a hazard (hole/water)
; @addr{6ded}
_rickyState4:
	ld e,SpecialObject.var37		; $6ded
	ld a,(de)		; $6def
	cp $0e ; Is this water?
	jr z,++			; $6df2

	; For any other value of var37, assume it's a hole ($0d).
	ld a,$0d		; $6df4
	ld (de),a		; $6df6
	call _companionDragToCenterOfHole		; $6df7
	ret nz			; $6dfa
++
	call _companionDecCounter1		; $6dfb
	jr nz,@animate	; $6dfe

	inc (hl)		; $6e00
	ld e,SpecialObject.var37		; $6e01
	ld a,(de)		; $6e03
	call specialObjectSetAnimation		; $6e04

	ld e,SpecialObject.var37		; $6e07
	ld a,(de)		; $6e09
	cp $0e ; Is this water?
	jr z,@animate	; $6e0c
	ld a,SND_LINK_FALL		; $6e0e
	jp playSound		; $6e10

@animate:
	call _companionAnimateDrowningOrFallingThenRespawn		; $6e13
	ret nc			; $6e16

	; Decide animation depending whether Link is riding Ricky
	ld c,$01		; $6e17
	ld a,(wLinkObjectIndex)		; $6e19
	rrca			; $6e1c
	jr nc,+			; $6e1d
	ld c,$05		; $6e1f
+
	jp _companionUpdateDirectionAndSetAnimation		; $6e21

;;
; State 5: Link riding Ricky.
;
; (Note: this may be called from state C?)
;
; @addr{6e24}
_rickyState5:
	ld e,SpecialObject.state2		; $6e24
	ld a,(de)		; $6e26
	rst_jumpTable			; $6e27
	.dw _rickyState5Substate0
	.dw _rickyState5Substate1
	.dw _rickyState5Substate2
	.dw _rickyState5Substate3

;;
; Substate 0: moving (not hopping)
; @addr{6e30}
_rickyState5Substate0:
	ld a,(wForceCompanionDismount)		; $6e30
	or a			; $6e33
	jr nz,++		; $6e34

	ld a,(wGameKeysJustPressed)		; $6e36
	bit BTN_BIT_A,a			; $6e39
	jp nz,_rickyStartPunch		; $6e3b

	bit BTN_BIT_B,a			; $6e3e
++
	jp nz,_companionGotoDismountState		; $6e40

	; Copy Link's angle (calculated from input buttons) to companion's angle
	ld h,d			; $6e43
	ld a,(wLinkAngle)		; $6e44
	ld l,SpecialObject.angle		; $6e47
	ld (hl),a		; $6e49

	; If not moving, set var39 to $10 (counter until Ricky hops)
	rlca			; $6e4a
	ld l,SpecialObject.var39		; $6e4b
	jr nc,@moving		; $6e4d
	ld a,$10		; $6e4f
	ld (hl),a		; $6e51

	ld c,$20		; $6e52
	call _companionSetAnimation		; $6e54
	jp _rickyCheckHazards		; $6e57

@moving:
	; Check if the "jump countdown" has reached zero
	ld l,SpecialObject.var39		; $6e5a
	ld a,(hl)		; $6e5c
	or a			; $6e5d
	jr z,@tryToJump		; $6e5e

	dec (hl) ; [var39]-=1

	ld l,SpecialObject.speed		; $6e61
	ld (hl),SPEED_c0		; $6e63

	ld c,$20		; $6e65
	call _companionUpdateDirectionAndAnimate		; $6e67
	call _rickyCheckForHoleInFront		; $6e6a
	jp z,_rickyBeginJumpOverHole		; $6e6d

	call _companionCheckHopDownCliff		; $6e70
	jr nz,+			; $6e73
	jp _rickySetJumpSpeed		; $6e75
+
	call _rickyCheckHopUpCliff		; $6e78
	jr nz,+			; $6e7b
	jp _rickySetJumpSpeed_andcc91		; $6e7d
+
	call _companionUpdateMovement		; $6e80
	jp _rickyCheckHazards		; $6e83

; "Jump timer" has reached zero; make him jump (either from movement, over a hole, or up
; or down a cliff).
@tryToJump:
	ld h,d			; $6e86
	ld l,SpecialObject.angle		; $6e87
	ldd a,(hl)		; $6e89
	add a			; $6e8a
	swap a			; $6e8b
	and $03			; $6e8d
	ldi (hl),a		; $6e8f
	call _rickySetJumpSpeed_andcc91		; $6e90

	; If he's moving left or right, skip the up/down cliff checks
	ld l,SpecialObject.angle		; $6e93
	ld a,(hl)		; $6e95
	bit 2,a			; $6e96
	jr nz,@jump	; $6e98

	call _companionCheckHopDownCliff		; $6e9a
	jr nz,++		; $6e9d
	ld (wDisableScreenTransitions),a		; $6e9f
	ld c,$0f		; $6ea2
	jp _companionSetAnimation		; $6ea4
++
	call _rickyCheckHopUpCliff		; $6ea7
	ld c,$0f		; $6eaa
	jp z,_companionSetAnimation		; $6eac

@jump:
	; If there's a hole in front, try to jump over it
	ld e,SpecialObject.state2		; $6eaf
	ld a,$02		; $6eb1
	ld (de),a		; $6eb3
	call _rickyCheckForHoleInFront		; $6eb4
	jp z,_rickyBeginJumpOverHole		; $6eb7

	; Otherwise, just do a normal hop
	ld bc,-$180		; $6eba
	call objectSetSpeedZ		; $6ebd
	ld l,SpecialObject.state2		; $6ec0
	ld (hl),$01		; $6ec2
	ld l,SpecialObject.counter1		; $6ec4
	ld (hl),$08		; $6ec6
	ld l,SpecialObject.speed		; $6ec8
	ld (hl),SPEED_200		; $6eca
	ld c,$19		; $6ecc
	call _companionSetAnimation		; $6ece

	call getRandomNumber		; $6ed1
	and $0f			; $6ed4
	ld a,SND_JUMP		; $6ed6
	jr nz,+			; $6ed8
	ld a,SND_RICKY		; $6eda
+
	jp playSound		; $6edc

;;
; Checks for holes for Ricky to jump over. Stores the tile 2 spaces away in var36.
;
; @param[out]	a	The tile directly in front of Ricky
; @param[out]	var36	The tile 2 spaces in front of Ricky
; @param[out]	zflag	Set if the tile in front of Ricky is a hole
; @addr{6edf}
_rickyCheckForHoleInFront:
	; Make sure we're not moving diagonally
	ld a,(wLinkAngle)		; $6edf
	and $04			; $6ee2
	ret nz			; $6ee4

	ld e,SpecialObject.direction		; $6ee5
	ld a,(de)		; $6ee7
	ld hl,_rickyHoleCheckOffsets		; $6ee8
	rst_addDoubleIndex			; $6eeb

	; Set b = y-position 2 tiles away, [hFF90] = y-position one tile away
	ld e,SpecialObject.yh		; $6eec
	ld a,(de)		; $6eee
	add (hl)		; $6eef
	ldh (<hFF90),a	; $6ef0
	add (hl)		; $6ef2
	ld b,a			; $6ef3

	; Set c = x-position 2 tiles away, [hFF91] = x-position one tile away
	inc hl			; $6ef4
	ld e,SpecialObject.xh		; $6ef5
	ld a,(de)		; $6ef7
	add (hl)		; $6ef8
	ldh (<hFF91),a	; $6ef9
	add (hl)		; $6efb
	ld c,a			; $6efc

	; Store in var36 the index of the tile 2 spaces away
	call getTileAtPosition		; $6efd
	ld a,l			; $6f00
	ld e,SpecialObject.var36		; $6f01
	ld (de),a		; $6f03

	ldh a,(<hFF90)	; $6f04
	ld b,a			; $6f06
	ldh a,(<hFF91)	; $6f07
	ld c,a			; $6f09
	call getTileAtPosition		; $6f0a
	ld h,>wRoomLayout		; $6f0d
	ld a,(hl)		; $6f0f
	cp TILEINDEX_HOLE			; $6f10
	ret z			; $6f12
	cp TILEINDEX_FD			; $6f13
	ret			; $6f15

;;
; Substate 1: hopping during normal movement
; @addr{6f16}
_rickyState5Substate1:
	dec e			; $6f16
	ld a,(de) ; Check [state]
	cp $05			; $6f18
	jr nz,@doneInputParsing	; $6f1a

	ld a,(wGameKeysJustPressed)		; $6f1c
	bit BTN_BIT_A,a			; $6f1f
	jp nz,_rickyStartPunch		; $6f21

	; Check if we're attempting to move
	ld a,(wLinkAngle)		; $6f24
	bit 7,a			; $6f27
	jr nz,@doneInputParsing	; $6f29

	; Update direction based on wLinkAngle
	ld hl,w1Companion.direction		; $6f2b
	ld b,a			; $6f2e
	add a			; $6f2f
	swap a			; $6f30
	and $03			; $6f32
	ldi (hl),a		; $6f34

	; Check if angle changed (and if animation needs updating)
	ld a,b			; $6f35
	cp (hl)			; $6f36
	ld (hl),a		; $6f37
	ld c,$19		; $6f38
	call nz,_companionSetAnimation		; $6f3a

@doneInputParsing:
	ld c,$40		; $6f3d
	call objectUpdateSpeedZ_paramC		; $6f3f
	jr z,@landed		; $6f42

	ld a,(wLinkObjectIndex)		; $6f44
	rra			; $6f47
	jr nc,++		; Check if Link's riding?
	ld a,(wLinkAngle)		; $6f4a
	and $04			; $6f4d
	jr nz,@updateMovement	; $6f4f
++
	; If Ricky's facing a hole, don't move into it
	ld hl,_rickyHoleCheckOffsets		; $6f51
	call _specialObjectGetRelativeTileWithDirectionTable		; $6f54
	ld a,b			; $6f57
	cp TILEINDEX_HOLE			; $6f58
	ret z			; $6f5a
	cp TILEINDEX_FD			; $6f5b
	ret z			; $6f5d

@updateMovement:
	jp _companionUpdateMovement		; $6f5e

@landed:
	call specialObjectAnimate		; $6f61
	call _companionDecCounter1IfNonzero		; $6f64
	ret nz			; $6f67
	jp _rickyStopUntilLandedOnGround		; $6f68

;;
; Substate 2: jumping over a hole
; @addr{6f6b}
_rickyState5Substate2:
	call _companionDecCounter1		; $6f6b
	jr z,++			; $6f6e
	dec (hl)		; $6f70
	ret nz			; $6f71
	ld a,SND_RICKY		; $6f72
	call playSound		; $6f74
++
	ld c,$40		; $6f77
	call objectUpdateSpeedZ_paramC		; $6f79
	jp z,_rickyStopUntilLandedOnGround		; $6f7c

	call specialObjectAnimate		; $6f7f
	call _companionUpdateMovement		; $6f82
	call _specialObjectCheckMovingTowardWall		; $6f85
	jp nz,_rickyStopUntilLandedOnGround		; $6f88
	ret			; $6f8b

;;
; Substate 3: just landed on the ground (or waiting to land on the ground?)
; @addr{6f8c}
_rickyState5Substate3:
	; If he hasn't landed yet, do nothing until he does
	ld c,$40		; $6f8c
	call objectUpdateSpeedZ_paramC		; $6f8e
	ret nz			; $6f91

	call _rickyBreakTilesOnLanding		; $6f92

	; Return to state 5, substate 0 (normal movement)
	xor a			; $6f95
	ld e,SpecialObject.state2		; $6f96
	ld (de),a		; $6f98

	jp _rickyCheckHazards2		; $6f99

;;
; State 8: punching (substate 0) or charging tornado (substate 1)
; @addr{6f9c}
_rickyState8:
	ld e,$05		; $6f9c
	ld a,(de)		; $6f9e
	rst_jumpTable			; $6f9f
	.dw @substate0
	.dw @substate1

; Substate 0: punching
@substate0:
	ld c,$40		; $6fa4
	call objectUpdateSpeedZ_paramC		; $6fa6
	jr z,@onGround			; $6fa9

	call _companionUpdateMovement		; $6fab
	jr ++			; $6fae

@onGround:
	call _companionTryToBreakTileFromMoving		; $6fb0
	call _rickyCheckHazards		; $6fb3
++
	; Wait for the animation to signal something (play sound effect or start tornado
	; charging)
	call specialObjectAnimate		; $6fb6
	ld e,SpecialObject.animParameter		; $6fb9
	ld a,(de)		; $6fbb
	and $c0			; $6fbc
	ret z			; $6fbe

	rlca			; $6fbf
	jr c,@startTornadoCharge			; $6fc0

	ld a,SND_UNKNOWN5		; $6fc2
	jp playSound		; $6fc4

@startTornadoCharge:
	; Return if in midair
	ld e,SpecialObject.zh		; $6fc7
	ld a,(de)		; $6fc9
	or a			; $6fca
	ret nz			; $6fcb

	; Check if let go of the button
	ld a,(wGameKeysPressed)		; $6fcc
	and BTN_A			; $6fcf
	jp z,_rickyStopUntilLandedOnGround		; $6fd1

	; Start tornado charging
	call itemIncState2		; $6fd4
	ld c,$13		; $6fd7
	call _companionSetAnimation		; $6fd9
	call _companionCheckHazards		; $6fdc
	ret nc			; $6fdf
	jp _rickyFunc_70cc		; $6fe0

; Substate 1: charging tornado
@substate1:
	; Update facing direction
	ld a,(wLinkAngle)		; $6fe3
	bit 7,a			; $6fe6
	jr nz,++		; $6fe8
	ld hl,w1Companion.angle		; $6fea
	cp (hl)			; $6fed
	ld (hl),a		; $6fee
	ld c,$13		; $6fef
	call nz,_companionUpdateDirectionAndAnimate		; $6ff1
++
	call specialObjectAnimate		; $6ff4
	ld a,(wGameKeysPressed)		; $6ff7
	and BTN_A			; $6ffa
	jr z,@releasedAButton	; $6ffc

	; Check if fully charged
	ld e,SpecialObject.var35		; $6ffe
	ld a,(de)		; $7000
	cp $1e			; $7001
	jr nz,@continueCharging		; $7003

	call _companionTryToBreakTileFromMoving		; $7005
	call _rickyCheckHazards		; $7008
	ld c,$04		; $700b
	jp _companionFlashFromChargingAnimation		; $700d

@continueCharging:
	inc a			; $7010
	ld (de),a ; [var35]++
	cp $1e			; $7012
	ret nz			; $7014
	ld a,SND_CHARGE_SWORD		; $7015
	jp playSound		; $7017

@releasedAButton:
	; Reset palette to normal
	ld hl,w1Link.oamFlagsBackup		; $701a
	ldi a,(hl)		; $701d
	ld (hl),a		; $701e

	ld e,SpecialObject.var35		; $701f
	ld a,(de)		; $7021
	cp $1e			; $7022
	jr nz,@notCharged	; $7024

	ldbc ITEMID_RICKY_TORNADO, $00		; $7026
	call _companionCreateItem		; $7029

	ld a,SNDCTRL_STOPSFX		; $702c
	call playSound		; $702e
	ld a,SND_SWORDSPIN		; $7031
	call playSound		; $7033

	jr _rickyStartPunch		; $7036

@notCharged:
	ld c,$05		; $7038
	jp _companionSetAnimationAndGotoState5		; $703a

;;
; @addr{703d}
_rickyStartPunch:
	ldbc ITEMID_28, $00		; $703d
	call _companionCreateWeaponItem		; $7040
	ret nz			; $7043
	ld h,d			; $7044
	ld l,SpecialObject.state		; $7045
	ld a,$08		; $7047
	ldi (hl),a		; $7049
	xor a			; $704a
	ld (hl),a ; [state2] = 0

	inc a			; $704c
	ld l,SpecialObject.var35		; $704d
	ld (hl),a		; $704f
	ld c,$09		; $7050
	call _companionSetAnimation		; $7052
	ld a,SND_SWORDSLASH		; $7055
	jp playSound		; $7057

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
; @addr{705a}
_rickyState6:
	ld e,SpecialObject.state2		; $705a
	ld a,(de)		; $705c
	rst_jumpTable			; $705d
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld c,$40		; $7064
	call objectUpdateSpeedZ_paramC		; $7066
	ret nz			; $7069
	call itemIncState2		; $706a
	call companionDismountAndSavePosition		; $706d
	ld a,$17		; $7070
	jp specialObjectSetAnimation		; $7072

@substate1:
	ld a,(wLinkInAir)		; $7075
	or a			; $7078
	ret nz			; $7079
	jp itemIncState2		; $707a

; Waiting for Link to get a certain distance away before allowing him to mount again
@substate2:
	call _companionSetPriorityRelativeToLink		; $707d

	ld c,$09		; $7080
	call objectCheckLinkWithinDistance		; $7082
	jp c,_rickyCheckHazards		; $7085

	; Link is far enough away; allow him to remount when he approaches again.
	ld e,SpecialObject.state2		; $7088
	xor a			; $708a
	ld (de),a ; [state2] = 0
	dec e			; $708c
	inc a			; $708d
	ld (de),a ; [state] = 1
	ret			; $708f

;;
; State 7: Jumping down a cliff
; @addr{7090}
_rickyState7:
	call _companionDecCounter1ToJumpDownCliff		; $7090
	ret c			; $7093

	call _companionCalculateAdjacentWallsBitset		; $7094
	call _specialObjectCheckMovingAwayFromWall		; $7097
	ld e,$07		; $709a
	jr z,+			; $709c
	ld (de),a		; $709e
	ret			; $709f
+
	ld a,(de)		; $70a0
	or a			; $70a1
	ret z			; $70a2

;;
; Sets ricky to state 5, substate 3 (do nothing until he lands, then continue normal
; movement)
; @addr{70a3}
_rickyStopUntilLandedOnGround:
	ld a,(wLinkObjectIndex)		; $70a3
	rrca			; $70a6
	jr nc,+			; $70a7
	xor a			; $70a9
	ld (wLinkInAir),a		; $70aa
	ld (wDisableScreenTransitions),a		; $70ad
+
	ld a,$05		; $70b0
	ld e,SpecialObject.state		; $70b2
	ld (de),a		; $70b4
	ld a,$03		; $70b5
	ld e,SpecialObject.state2		; $70b7
	ld (de),a		; $70b9

	; If Ricky's close to the screen edge, set the "jump delay counter" back to $10 so
	; that he'll stay on the ground long enough for a screen transition to happen
	call _rickyCheckAtScreenEdge		; $70ba
	jr z,_rickyCheckHazards2			; $70bd
	ld e,SpecialObject.var39		; $70bf
	ld a,$10		; $70c1
	ld (de),a		; $70c3

;;
; @addr{70c4}
_rickyCheckHazards2:
	call _companionCheckHazards		; $70c4
	ld c,$20		; $70c7
	jp nc,_companionSetAnimation		; $70c9

;;
; @param	a	Hazard type landed on
; @addr{70cc}
_rickyFunc_70cc:
	ld c,$0e		; $70cc
	cp $01 ; Landed on water?
	jr z,+			; $70d0
	ld c,$0d		; $70d2
+
	ld h,d			; $70d4
	ld l,SpecialObject.var37		; $70d5
	ld (hl),c		; $70d7
	ld l,SpecialObject.counter1		; $70d8
	ld (hl),$00		; $70da
	ret			; $70dc

;;
; State A: various cutscene-related things? Behaviour is controlled by "var03" instead of
; "state2".
;
; @addr{70dd}
_rickyStateA:
	ld e,SpecialObject.var03		; $70dd
	ld a,(de)		; $70df
	rst_jumpTable			; $70e0
	.dw _rickyStateASubstate0
	.dw _rickyStateASubstate1
	.dw _rickyStateASubstate2
	.dw _rickyStateASubstate3
	.dw _rickyStateASubstate4
	.dw _rickyStateASubstate5
	.dw _rickyStateASubstate6
	.dw _rickyStateASubstate7
.ifdef ROM_SEASONS
	.dw _rickyStateASubstate8
	.dw _rickyStateASubstate9
	.dw _rickyStateASubstateA
	.dw _rickyStateASubstateB
	.dw _rickyStateASubstateC
.endif

;;
; Standing around doing nothing?
; @addr{70f1}
_rickyStateASubstate0:
	call _companionPreventLinkFromPassing_noExtraChecks		; $70f1
	call _companionSetPriorityRelativeToLink		; $70f4
	call specialObjectAnimate		; $70f7
	ld e,$21		; $70fa
	ld a,(de)		; $70fc
	rlca			; $70fd
	ld c,$40		; $70fe
	jp nc,objectUpdateSpeedZ_paramC		; $7100
	ld bc,-$100		; $7103
	jp objectSetSpeedZ		; $7106

;;
; Force Link to mount
; @addr{7109}
_rickyStateASubstate1:
	ld e,SpecialObject.var3d		; $7109
	call objectRemoveFromAButtonSensitiveObjectList		; $710b
	jp _companionForceMount		; $710e

.ifdef ROM_AGES
;;
; Ricky leaving upon meeting Tingle (part 1: print text)
; @addr{7111}
_rickyStateASubstate2:
	ld c,$40		; $7111
	call objectUpdateSpeedZ_paramC		; $7113
	ret nz			; $7116

	ld bc,TX_2006		; $7117
	call showText		; $711a

	ld hl,w1Link.yh		; $711d
	ld e,SpecialObject.yh		; $7120
	ld a,(de)		; $7122
	cp (hl)			; $7123
	ld a,$02		; $7124
	jr c,+			; $7126
	ld a,$00		; $7128
+
	ld e,SpecialObject.direction		; $712a
	ld (de),a		; $712c
	ld a,$03		; $712d
	ld e,SpecialObject.var3f		; $712f
	ld (de),a		; $7131
	call specialObjectSetAnimation		; $7132
	call _rickyIncVar03		; $7135
	jr _rickySetJumpSpeedForCutscene		; $7138
.else
_rickyStateASubstate2:
	ld a,$01		; $705c
	ld (wDisabledObjects),a		; $705e
	ld a,DIR_UP		; $7061
	ld e,SpecialObject.direction		; $7063
	ld (de),a		; $7065
	ld a,$05		; $7066
	ld e,SpecialObject.var3f		; $7068
	ld (de),a		; $706a
	call _rickyIncVar03		; $706b
.endif

;;
; @addr{713a}
_rickySetJumpSpeedForCutsceneAndSetAngle:
	ld b,$30		; $713a
	ld c,$58		; $713c
	call objectGetRelativeAngle		; $713e
	and $1c			; $7141
	ld e,SpecialObject.angle		; $7143
	ld (de),a		; $7145

;;
; @addr{7146}
_rickySetJumpSpeedForCutscene:
	ld bc,-$180		; $7146
	call objectSetSpeedZ		; $7149
	ld l,SpecialObject.state2		; $714c
	ld (hl),$01		; $714e
	ld l,SpecialObject.speed		; $7150
	ld (hl),SPEED_200		; $7152
	ld l,SpecialObject.counter1		; $7154
	ld (hl),$08		; $7156
	ret			; $7158

.ifdef ROM_AGES
;;
; Ricky leaving upon meeting Tingle (part 5: punching the air)
; @addr{7159}
_rickyStateASubstate6:
	; Wait for animation to give signals to play sound, start moving away.
	call specialObjectAnimate		; $7159
	ld e,SpecialObject.animParameter		; $715c
	ld a,(de)		; $715e
	or a			; $715f
	ld a,SND_RICKY		; $7160
	jp z,playSound		; $7162

	ld a,(de)		; $7165
	rlca			; $7166
	ret nc			; $7167

	; Start moving away
	call _rickySetJumpSpeedForCutsceneAndSetAngle		; $7168
	ld e,SpecialObject.angle		; $716b
	ld a,$10		; $716d
	ld (de),a		; $716f

	ld c,$05		; $7170
	call _companionSetAnimation		; $7172
	jp _rickyIncVar03		; $7175

;;
; Ricky leaving upon meeting Tingle (part 2: start moving toward cliff)
; @addr{7178}
_rickyStateASubstate3:
	call retIfTextIsActive		; $7178

	; Move down-left
	ld a,$14		; $717b
	ld e,SpecialObject.angle		; $717d
	ld (de),a		; $717f

	; Face down
	dec e			; $7180
	ld a,$02		; $7181
	ld (de),a		; $7183

	ld c,$05		; $7184
	call _companionSetAnimation		; $7186
	jp _rickyIncVar03		; $7189

;;
; Ricky leaving upon meeting Tingle (part 4: jumping down cliff)
; @addr{718c}
_rickyStateASubstate5:
	call specialObjectAnimate		; $718c
	call objectApplySpeed		; $718f
	ld c,$40		; $7192
	call objectUpdateSpeedZ_paramC		; $7194
	ret nz			; $7197

	; Reached bottom of cliff
	ld a,$18		; $7198
	call specialObjectSetAnimation		; $719a
	jp _rickyIncVar03		; $719d

;;
; Ricky leaving upon meeting Tingle (part 3: moving toward cliff, or...
;                                    part 6: moving toward screen edge)
; @addr{71a0}
_rickyStateASubstate4:
_rickyStateASubstate7:
	call _companionSetAnimationToVar3f		; $71a0
	call _rickyWaitUntilJumpDone		; $71a3
	ret nz			; $71a6

	; Ricky has just touched the ground, and is ready to do another hop.

	; Check if moving toward a wall on the left
	ld a,$18		; $71a7
	ld e,SpecialObject.angle		; $71a9
	ld (de),a		; $71ab
	call _specialObjectCheckMovingTowardWall		; $71ac
	jr z,@hop	; $71af

	; Check if moving toward a wall below
	ld a,$10		; $71b1
	ld e,SpecialObject.angle		; $71b3
	ld (de),a		; $71b5
	call _specialObjectCheckMovingTowardWall		; $71b6
	jr z,@hop	; $71b9

	; He's against the cliff; proceed to next state (jumping down cliff).
	call _rickySetJumpSpeed		; $71bb
	ld a,SND_JUMP		; $71be
	call playSound		; $71c0
	jp _rickyIncVar03		; $71c3

@hop:
	call objectCheckWithinScreenBoundary		; $71c6
	jr nc,@leftScreen	; $71c9

	; Moving toward cliff, or screen edge? Set angle accordingly.
	ld e,SpecialObject.var03		; $71cb
	ld a,(de)		; $71cd
	cp $07			; $71ce
	ld a,$10		; $71d0
	jr z,+			; $71d2
	ld a,$14		; $71d4
+
	ld e,SpecialObject.angle		; $71d6
	ld (de),a		; $71d8
	jp _rickySetJumpSpeedForCutscene		; $71d9

@leftScreen:
	xor a			; $71dc
	ld (wDisabledObjects),a		; $71dd
	ld (wMenuDisabled),a		; $71e0
	ld (wDeathRespawnBuffer.rememberedCompanionId),a		; $71e3
	call itemDelete		; $71e6
	ld hl,wRickyState		; $71e9
	set 6,(hl)		; $71ec
	jp saveLinkLocalRespawnAndCompanionPosition		; $71ee
.else

_rickyStateASubstate7:
	call _companionSetAnimationToVar3f		; $708d
	call specialObjectAnimate		; $7090
	ld e,SpecialObject.animParameter		; $7093
	ld a,(de)		; $7095
	or a			; $7096
	ld a,SND_RICKY		; $7097
	jp z,playSound		; $7099
	ld a,(de)		; $709c
	rlca			; $709d
	ret nc			; $709e
	call _rickySetJumpSpeedForCutsceneAndSetAngle		; $709f
	ld e,SpecialObject.angle		; $70a2
	ld a,$10		; $70a4
	ld (de),a		; $70a6
	ret			; $70a7
_rickyStateASubstate3:
	call _companionSetAnimationToVar3f		; $70a8
	ld e,SpecialObject.var3e		; $70ab
	ld a,(de)		; $70ad
	and $01			; $70ae
	ret nz			; $70b0
	call _rickyWaitUntilJumpDone		; $70b1
	ret nz			; $70b4
	ld e,SpecialObject.yh		; $70b5
	ld a,(de)		; $70b7
	cp $38			; $70b8
	jr nc,_rickySetJumpSpeedForCutsceneAndSetAngle	; $70ba
	ld e,SpecialObject.var3e		; $70bc
	ld a,(de)		; $70be
	or $01			; $70bf
	ld (de),a		; $70c1
	ret			; $70c2
_rickyStateASubstate4:
	call _companionSetAnimationToVar3f		; $70c3
	ld e,SpecialObject.var3e		; $70c6
	ld a,(de)		; $70c8
	bit 1,a			; $70c9
	ret nz			; $70cb
	or $02			; $70cc
	ld (de),a		; $70ce
	jp companionDismount		; $70cf
_rickyStateASubstate5:
	call _rickySetJumpSpeedForCutsceneAndSetAngle		; $70d2
	ld e,SpecialObject.angle		; $70d5
	ld a,$10		; $70d7
	ld (de),a		; $70d9
	ret			; $70da
_rickyStateASubstate6:
_rickyStateASubstate8:
	call _companionSetAnimationToVar3f		; $70db
	call _rickyWaitUntilJumpDone		; $70de
	ret nz			; $70e1
	call objectCheckWithinScreenBoundary		; $70e2
	jr nc,++	; $70e5
	ld e,SpecialObject.yh		; $70e7
	ld a,(de)		; $70e9
	cp $60			; $70ea
	jr c,+	; $70ec
	ld e,SpecialObject.var3e		; $70ee
	ld a,(de)		; $70f0
	or SpecialObject.state			; $70f1
	ld (de),a		; $70f3
+
	call _rickySetJumpSpeedForCutsceneAndSetAngle		; $70f4
	ld e,SpecialObject.angle		; $70f7
	ld a,$10		; $70f9
	ld (de),a		; $70fb
	ret			; $70fc
++
	ld a,$01		; $70fd
	ld (wLinkForceState),a		; $70ff
	xor a			; $7102
	ld (wDisabledObjects),a		; $7103
	call itemDelete		; $7106
	jp saveLinkLocalRespawnAndCompanionPosition		; $7109
_rickyStateASubstate9:
	ld a,$80		; $710c
	ld (wMenuDisabled),a		; $710e
	ld a,$01		; $7111
	ld e,SpecialObject.direction		; $7113
	ld (de),a		; $7115
	call _rickyIncVar03		; $7116
	ld c,$20		; $7119
	call _companionSetAnimation		; $711b
-
	ld bc,$4070		; $711e
	call objectGetRelativeAngle		; $7121
	and $1c			; $7124
	ld e,SpecialObject.angle		; $7126
	ld (de),a		; $7128
	ret			; $7129
_rickyStateASubstateA:
	call specialObjectAnimate		; $712a
	call _companionUpdateMovement		; $712d
	ld e,SpecialObject.xh		; $7130
	ld a,(de)		; $7132
	cp $38			; $7133
	jr c,-	; $7135
	ld bc,TX_2004		; $7137
	call showText		; $713a
.endif

;;
; @addr{71f1}
_rickyIncVar03:
	ld e,SpecialObject.var03		; $71f1
	ld a,(de)		; $71f3
	inc a			; $71f4
	ld (de),a		; $71f5
	ret			; $71f6

;;
; Seasons-only
; @addr{71f7}
_rickyStateASubstateB:
	call retIfTextIsActive		; $71f7
	call companionDismount		; $71fa

	ld a,$18		; $71fd
	ld (w1Link.angle),a		; $71ff
	ld (wLinkAngle),a		; $7202

	ld a,SPEED_140		; $7205
	ld (w1Link.speed),a		; $7207

	ld h,d			; $720a
	ld l,SpecialObject.angle		; $720b
	ld a,$18		; $720d
	ldd (hl),a		; $720f

	ld a,DIR_LEFT		; $7210
	ldd (hl),a ; [direction] = DIR_LEFT
	ld a,$1e		; $7213
	ld (hl),a ; [counter2] = $1e

	ld a,$24		; $7216
	call specialObjectSetAnimation		; $7218
	jr _rickyIncVar03		; $721b

;;
; Seasons-only
; @addr{721d}
_rickyStateASubstateC:
	ld a,(wLinkInAir)		; $721d
	or a			; $7220
	ret nz			; $7221

	call setLinkForceStateToState08		; $7222
	ld hl,w1Link.xh		; $7225
	ld e,SpecialObject.xh		; $7228
	ld a,(de)		; $722a
	bit 7,a			; $722b
	jr nz,+		; $722d

	cp (hl)			; $722f
	ld a,DIR_RIGHT		; $7230
	jr nc,++			; $7232
+
	ld a,DIR_LEFT		; $7234
++
	ld l,SpecialObject.direction		; $7236
	ld (hl),a		; $7238
	ld e,SpecialObject.counter2		; $7239
	ld a,(de)		; $723b
	or a			; $723c
	jr z,@moveCompanion	; $723d
	dec a			; $723f
	ld (de),a		; $7240
	ret			; $7241

@moveCompanion:
	call specialObjectAnimate		; $7242
	call _companionUpdateMovement		; $7245
	call objectCheckWithinScreenBoundary		; $7248
	ret c			; $724b
	xor a			; $724c
	ld (wRememberedCompanionId),a		; $724d
	ld (wDisabledObjects),a		; $7250
	ld (wMenuDisabled),a		; $7253
	jp itemDelete		; $7256

;;
; @param[out]	zflag	Set if Ricky's on the ground and counter1 has reached 0.
; @addr{7259}
_rickyWaitUntilJumpDone:
	ld c,$40		; $7259
	call objectUpdateSpeedZ_paramC		; $725b
	jr z,@onGround		; $725e

	call _companionUpdateMovement		; $7260
	or d			; $7263
	ret			; $7264

@onGround:
	ld c,$05		; $7265
	call _companionSetAnimation		; $7267
	jp _companionDecCounter1IfNonzero		; $726a

;;
; State $0c: Ricky entering screen from flute call
; @addr{726d}
_rickyStateC:
	ld e,SpecialObject.var03		; $726d
	ld a,(de)		; $726f
	rst_jumpTable			; $7270
	.dw @parameter0
	.dw @parameter1

@parameter0:
	call _companionInitializeOnEnteringScreen		; $7275
	ld (hl),$02		; $7278
	call _rickySetJumpSpeedForCutscene		; $727a
	ld a,SND_RICKY		; $727d
	call playSound		; $727f
	ld c,$01		; $7282
	jp _companionSetAnimation		; $7284

@parameter1:
	call _rickyState5		; $7287

	; Return if falling into a hazard
	ld e,SpecialObject.state		; $728a
	ld a,(de)		; $728c
	cp $04			; $728d
	ret z			; $728f

	ld a,$0c		; $7290
	ld (de),a ; [state] = $0c
	inc e			; $7293
	ld a,(de) ; a = [state2]
	cp $03			; $7295
	ret nz			; $7297

	call _rickyBreakTilesOnLanding		; $7298
	ld hl,_rickyHoleCheckOffsets		; $729b
	call _specialObjectGetRelativeTileWithDirectionTable		; $729e
	or a			; $72a1
	jr nz,@initializeRicky	; $72a2
	call itemDecCounter2		; $72a4
	jr z,@initializeRicky	; $72a7
	call _rickySetJumpSpeedForCutscene		; $72a9
	ld c,$01		; $72ac
	jp _companionSetAnimation		; $72ae

; Make Ricky stop moving in, start waiting in place
@initializeRicky:
	ld e,SpecialObject.var03		; $72b1
	xor a			; $72b3
	ld (de),a		; $72b4
	jp _rickyState0		; $72b5


;;
; @param[out]	zflag	Set if Ricky should hop up a cliff
; @addr{72b8}
_rickyCheckHopUpCliff:
	; Check that Ricky's facing a wall above him
	ld e,SpecialObject.adjacentWallsBitset		; $72b8
	ld a,(de)		; $72ba
	and $c0			; $72bb
	cp $c0			; $72bd
	ret nz			; $72bf

	; Check that we're trying to move up
	ld a,(wLinkAngle)		; $72c0
	cp $00			; $72c3
	ret nz			; $72c5

	; Ricky can jump up to two tiles above him where the collision value equals $03
	; (only the bottom half of the tile is solid).

; Check that the tiles on ricky's left and right sides one tile up are clear
@tryOneTileUp:
	ld hl,@cliffOffset_oneUp_right		; $72c6
	call _specialObjectGetRelativeTileFromHl		; $72c9
	cp $03			; $72cc
	jr z,+			; $72ce
	ld a,b			; $72d0
	cp TILEINDEX_VINE_TOP			; $72d1
	jr nz,@tryTwoTilesUp	; $72d3
+
	ld hl,@cliffOffset_oneUp_left		; $72d5
	call _specialObjectGetRelativeTileFromHl		; $72d8
	cp $03			; $72db
	jr z,@canJumpUpCliff	; $72dd
	ld a,b			; $72df
	cp TILEINDEX_VINE_TOP			; $72e0
	jr z,@canJumpUpCliff	; $72e2

; Check that the tiles on ricky's left and right sides two tiles up are clear
@tryTwoTilesUp:
	ld hl,@cliffOffset_twoUp_right		; $72e4
	call _specialObjectGetRelativeTileFromHl		; $72e7
	cp $03			; $72ea
	jr z,+			; $72ec
	ld a,b			; $72ee
	cp TILEINDEX_VINE_TOP			; $72ef
	ret nz			; $72f1
+
	ld hl,@cliffOffset_twoUp_left		; $72f2
	call _specialObjectGetRelativeTileFromHl		; $72f5
	cp $03			; $72f8
	jr z,@canJumpUpCliff	; $72fa
	ld a,b			; $72fc
	cp TILEINDEX_VINE_TOP			; $72fd
	ret nz			; $72ff

@canJumpUpCliff:
	; State 2 handles jumping up a cliff
	ld e,SpecialObject.state		; $7300
	ld a,$02		; $7302
	ld (de),a		; $7304
	inc e			; $7305
	xor a			; $7306
	ld (de),a ; [state2] = 0

	ld e,SpecialObject.counter2		; $7308
	ld (de),a		; $730a
	ret			; $730b

; Offsets for the cliff tile that Ricky will be hopping up to

@cliffOffset_oneUp_right:
	.db $f8 $06
@cliffOffset_oneUp_left:
	.db $f8 $fa
@cliffOffset_twoUp_right:
	.db $e8 $06
@cliffOffset_twoUp_left:
	.db $e8 $fa


;;
; @addr{7314}
_rickyBreakTilesOnLanding:
	ld hl,@offsets		; $7314
@next:
	ldi a,(hl)		; $7317
	ld b,a			; $7318
	ldi a,(hl)		; $7319
	ld c,a			; $731a
	or b			; $731b
	ret z			; $731c
	push hl			; $731d
	ld a,(w1Companion.yh)		; $731e
	add b			; $7321
	ld b,a			; $7322
	ld a,(w1Companion.xh)		; $7323
	add c			; $7326
	ld c,a			; $7327
	ld a,BREAKABLETILESOURCE_10		; $7328
	call tryToBreakTile		; $732a
	pop hl			; $732d
	jr @next		; $732e

; Each row is a Y/X offset at which to attempt to break a tile when Ricky lands.
@offsets:
	.db $04 $00
	.db $04 $06
	.db $fe $00
	.db $04 $fa
	.db $00 $00


;;
; Seems to set variables for ricky's jump speed, etc, but the jump may still be cancelled
; after this?
; @addr{733a}
_rickyBeginJumpOverHole:
	ld a,$01		; $733a
	ld (wLinkInAir),a		; $733c

;;
; @addr{733f}
_rickySetJumpSpeed_andcc91:
	ld a,$01		; $733f
	ld (wDisableScreenTransitions),a		; $7341

;;
; Sets up Ricky's speed for long jumps across holes and cliffs.
; @addr{7344}
_rickySetJumpSpeed:
	ld bc,-$300		; $7344
	call objectSetSpeedZ		; $7347
	ld l,SpecialObject.counter1		; $734a
	ld (hl),$08		; $734c
	ld l,SpecialObject.speed		; $734e
	ld (hl),SPEED_140		; $7350
	ld c,$0f		; $7352
	call _companionSetAnimation		; $7354
	ld h,d			; $7357
	ret			; $7358

;;
; @param[out]	zflag	Set if Ricky's close to the screen edge
; @addr{7359}
_rickyCheckAtScreenEdge:
	ld h,d			; $7359
	ld l,SpecialObject.yh		; $735a
	ld a,$06		; $735c
	cp (hl)			; $735e
	jr nc,@outsideScreen	; $735f

	ld a,(wScreenTransitionBoundaryY)		; $7361
	dec a			; $7364
	cp (hl)			; $7365
	jr c,@outsideScreen	; $7366

	ld l,SpecialObject.xh		; $7368
	ld a,$06		; $736a
	cp (hl)			; $736c
	jr nc,@outsideScreen	; $736d

	ld a,(wScreenTransitionBoundaryX)		; $736f
	dec a			; $7372
	cp (hl)			; $7373
	jr c,@outsideScreen	; $7374

	xor a			; $7376
	ret			; $7377

@outsideScreen:
	or d			; $7378
	ret			; $7379

; Offsets relative to Ricky's position to check for holes to jump over
_rickyHoleCheckOffsets:
	.db $f8 $00
	.db $05 $08
	.db $08 $00
	.db $05 $f8


;;
; var38: nonzero if Dimitri is in water?
; @addr{7382}
_specialObjectCode_dimitri:
	call _companionRetIfInactive		; $7382
	call _companionFunc_47d8		; $7385
	call @runState		; $7388
	xor a			; $738b
	ld (wDimitriHitNpc),a		; $738c
	jp _companionCheckEnableTerrainEffects		; $738f

; Note: expects that h=d (call to _companionFunc_47d8 does this)
@runState:
	ld e,SpecialObject.state		; $7392
	ld a,(de)		; $7394
	rst_jumpTable			; $7395
	.dw _dimitriState0
	.dw _dimitriState1
	.dw _dimitriState2
	.dw _dimitriState3
	.dw _dimitriState4
	.dw _dimitriState5
	.dw _dimitriState6
	.dw _dimitriState7
	.dw _dimitriState8
	.dw _dimitriState9
	.dw _dimitriStateA
	.dw _dimitriStateB
	.dw _dimitriStateC
	.dw _dimitriStateD

;;
; State 0: initialization, deciding which state to go to
; @addr{73b2}
_dimitriState0:
	call _companionCheckCanSpawn		; $73b2

	ld a,DIR_DOWN		; $73b5
	ld l,SpecialObject.direction		; $73b7
	ldi (hl),a		; $73b9
	ld (hl),a ; [counter2] = $02

	ld a,(wDimitriState)		; $73bb
.ifdef ROM_AGES
	bit 7,a			; $73be
	jr nz,@setAnimation	; $73c0
	bit 6,a			; $73c2
	jr nz,+			; $73c4
	and $20			; $73c6
	jr nz,@setAnimation	; $73c8
+
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST		; $73ca
	call checkGlobalFlag		; $73cc
	ld h,d			; $73cf
	ld c,$24		; $73d0
	jr z,+			; $73d2
	ld c,$1e		; $73d4
+
	ld l,SpecialObject.state		; $73d6
	ld (hl),$0a		; $73d8

	ld e,SpecialObject.var3d		; $73da
	call objectAddToAButtonSensitiveObjectList		; $73dc

	ld a,c			; $73df
.else
	and $80			; $730a
	jr nz,@setAnimation	; $730c
	ld l,SpecialObject.state		; $730e
	ld (hl),$0a		; $7310
	ld e,SpecialObject.var3d		; $7312
	call objectAddToAButtonSensitiveObjectList		; $7314
	ld a,$24		; $7317
.endif

	ld e,SpecialObject.var3f		; $73e0
	ld (de),a		; $73e2
	call specialObjectSetAnimation		; $73e3

	ld bc,$0408		; $73e6
	call objectSetCollideRadii		; $73e9
	jr @setVisible		; $73ec

@setAnimation:
	ld c,$1c		; $73ee
	call _companionSetAnimation		; $73f0
@setVisible:
	jp objectSetVisible81		; $73f3

;;
; State 1: waiting for Link to mount
; @addr{73f6}
_dimitriState1:
	call _companionSetPriorityRelativeToLink		; $73f6
	ld c,$40		; $73f9
	call objectUpdateSpeedZ_paramC		; $73fb
	ret nz			; $73fe

	; Is dimitri in a hole?
	call _companionCheckHazards		; $73ff
	jr nc,@onLand		; $7402
	cp $02			; $7404
	ret z			; $7406

	; No, he must be in water
	call _dimitriAddWaterfallResistance		; $7407
	ld a,$04		; $740a
	call _dimitriFunc_756d		; $740c
	jr ++			; $740f

@onLand:
	ld e,SpecialObject.var38		; $7411
	ld a,(de)		; $7413
	or a			; $7414
	jr z,++			; $7415
	xor a			; $7417
	ld (de),a		; $7418
	ld c,$1c		; $7419
	call _companionSetAnimation		; $741b
++
	ld a,$06		; $741e
	call objectSetCollideRadius		; $7420

	ld e,SpecialObject.var3b		; $7423
	ld a,(de)		; $7425
	or a			; $7426
	jp nz,_dimitriGotoState1IfLinkFarAway		; $7427

	ld c,$09		; $742a
	call objectCheckLinkWithinDistance		; $742c
	jp nc,_dimitriCheckAddToGrabbableObjectBuffer		; $742f
	jp _companionTryToMount		; $7432

;;
; State 2: curled into a ball (being held or thrown).
;
; The substates are generally controlled by power bracelet code (see "itemCode16").
;
; @addr{7435}
_dimitriState2:
	inc e			; $7435
	ld a,(de)		; $7436
	rst_jumpTable			; $7437
	.dw _dimitriState2Substate0
	.dw _dimitriState2Substate1
	.dw _dimitriState2Substate2
	.dw _dimitriState2Substate3

;;
; Substate 0: just grabbed
; @addr{7440}
_dimitriState2Substate0:
	ld a,$40		; $7440
	ld (wLinkGrabState2),a		; $7442
	call itemIncState2		; $7445
	xor a			; $7448
	ld (wcc90),a		; $7449

	ld l,SpecialObject.var38		; $744c
	ld (hl),a		; $744e
	ld l,$3f		; $744f
	ld (hl),$ff		; $7451

	call objectSetVisiblec0		; $7453

	ld a,$02		; $7456
	ld hl,wCompanionTutorialTextShown		; $7458
	call setFlag		; $745b

	ld c,$18		; $745e
	jp _companionSetAnimation		; $7460

;;
; Substate 1: being lifted, carried
; @addr{7463}
_dimitriState2Substate1:
	xor a			; $7463
	ld (w1Link.knockbackCounter),a		; $7464
	ld a,(wActiveTileType)		; $7467
	cp TILETYPE_CRACKED_ICE			; $746a
	jr nz,+			; $746c
	ld a,$20		; $746e
	ld (wStandingOnTileCounter),a		; $7470
+
	ld a,(wLinkClimbingVine)		; $7473
	or a			; $7476
	jr nz,@releaseDimitri	; $7477

	ld a,(w1Link.angle)		; $7479
	bit 7,a			; $747c
	jr nz,@update	; $747e

	ld e,SpecialObject.angle		; $7480
	ld (de),a		; $7482

	ld a,(w1Link.direction)		; $7483
	dec e			; $7486
	ld (de),a ; [direction] = [w1Link.direction]

	call _dimitriCheckCanBeHeldInDirection		; $7488
	jr nz,@update	; $748b

@releaseDimitri:
	ld h,d			; $748d
	ld l,$00		; $748e
	res 1,(hl)		; $7490
	ld l,$3b		; $7492
	ld (hl),$01		; $7494
	jp dropLinkHeldItem		; $7496

@update:
	; Check whether to prevent Link from throwing dimitri (write nonzero to wcc67)
	call _companionCalculateAdjacentWallsBitset		; $7499
	call _specialObjectCheckMovingTowardWall		; $749c
	ret z			; $749f
	ld (wcc67),a		; $74a0
	ret			; $74a3

;;
; Substate 2: dimitri released, falling to ground
; @addr{74a4}
_dimitriState2Substate2:
	ld h,d			; $74a4
	ld l,SpecialObject.enabled		; $74a5
	res 1,(hl)		; $74a7

	call _companionCheckHazards		; $74a9
	jr nc,@noHazard		; $74ac

	; Return if he's on a hole
	cp $02			; $74ae
	ret z			; $74b0
	jr @onHazard		; $74b1

@noHazard:
	ld h,d			; $74b3
	ld l,SpecialObject.var3f		; $74b4
	ld a,(hl)		; $74b6
	cp $ff			; $74b7
	jr nz,++		; $74b9

	; Set Link's current position as the spot to return to if Dimitri lands in water
	xor a			; $74bb
	ld (hl),a		; $74bc
	ld l,SpecialObject.var39		; $74bd
	ld a,(w1Link.yh)		; $74bf
	ldi (hl),a		; $74c2
	ld a,(w1Link.xh)		; $74c3
	ld (hl),a		; $74c6
++

; Check whether Dimitri should stop moving when thrown. Involves screen boundary checks.

	ld a,(wDimitriHitNpc)		; $74c7
	or a			; $74ca
	jr nz,@stopMovement	; $74cb

	call _companionCalculateAdjacentWallsBitset		; $74cd
	call _specialObjectCheckMovingTowardWall		; $74d0
	jr nz,@stopMovement	; $74d3

	ld c,$00		; $74d5
	ld h,d			; $74d7
	ld l,SpecialObject.yh		; $74d8
	ld a,(hl)		; $74da
	cp $08			; $74db
	jr nc,++		; $74dd
	ld (hl),$10		; $74df
	inc c			; $74e1
	jr @checkX		; $74e2
++
	ld a,(wActiveGroup)		; $74e4
	or a			; $74e7
	ld a,(hl)		; $74e8
	jr nz,@largeRoomYCheck	; $74e9
@smallRoomYCheck:
	cp SMALL_ROOM_HEIGHT*16-6
	jr c,@checkX			; $74ed
	ld (hl), SMALL_ROOM_HEIGHT*16-6
	inc c			; $74f1
	jr @checkX			; $74f2
@largeRoomYCheck:
	cp LARGE_ROOM_HEIGHT*16-8
	jr c,@checkX			; $74f6
	ld (hl), LARGE_ROOM_HEIGHT*16-8
	inc c			; $74fa
	jr @checkX			; $74fb

@checkX:
	ld l,SpecialObject.xh		; $74fd
	ld a,(hl)		; $74ff
	cp $04			; $7500
	jr nc,++		; $7502
	ld (hl),$04		; $7504
	inc c			; $7506
	jr @doneBoundsCheck		; $7507
++
	ld a,(wActiveGroup)		; $7509
	or a			; $750c
	ld a,(hl)		; $750d
	jr nz,@largeRoomXCheck	; $750e
@smallRoomXCheck:
	cp SMALL_ROOM_WIDTH*16-5			; $7510
	jr c,@doneBoundsCheck	; $7512
	ld (hl), SMALL_ROOM_WIDTH*16-5		; $7514
	inc c			; $7516
	jr @doneBoundsCheck		; $7517
@largeRoomXCheck:
	cp LARGE_ROOM_WIDTH*16-17			; $7519
	jr c,@doneBoundsCheck	; $751b
	ld (hl), LARGE_ROOM_WIDTH*16-17		; $751d
	inc c			; $751f

@doneBoundsCheck:
	ld a,c			; $7520
	or a			; $7521
	jr z,@checkOnHazard	; $7522

@stopMovement:
	ld a,SPEED_0		; $7524
	ld (w1ReservedItemC.speed),a		; $7526

@checkOnHazard:
	call objectCheckIsOnHazard		; $7529
	cp $01			; $752c
	ret nz			; $752e

@onHazard:
	ld h,d			; $752f
	ld l,SpecialObject.state		; $7530
	ld (hl),$0b		; $7532
	ld l,SpecialObject.var38		; $7534
	ld (hl),$04		; $7536

	; Calculate angle toward Link?
	ld l,SpecialObject.var39		; $7538
	ldi a,(hl)		; $753a
	ld c,(hl)		; $753b
	ld b,a			; $753c
	call objectGetRelativeAngle		; $753d
	and $18			; $7540
	ld e,SpecialObject.angle		; $7542
	ld (de),a		; $7544

	; Calculate direction based on angle
	add a			; $7545
	swap a			; $7546
	and $03			; $7548
	dec e			; $754a
	ld (de),a ; [direction] = a

	ld c,$00		; $754c
	jp _companionSetAnimation		; $754e

;;
; Substate 3: landed on ground for good
; @addr{7551}
_dimitriState2Substate3:
	ld h,d			; $7551
	ld l,SpecialObject.enabled		; $7552
	res 1,(hl)		; $7554

	ld c,$40		; $7556
	call objectUpdateSpeedZ_paramC		; $7558
	ret nz			; $755b
	call _companionTryToBreakTileFromMoving		; $755c
	call _companionCheckHazards		; $755f
	jr nc,@gotoState1	; $7562

	; If on a hole, return (stay in this state?)
	cp $02			; $7564
	ret z			; $7566

	; If in water, go to state 1, but with alternate value for var38?
	ld a,$04		; $7567
	jp _dimitriFunc_756d		; $7569

@gotoState1:
	xor a			; $756c

;;
; @param	a	Value for var38
; @addr{756d}
_dimitriFunc_756d:
	ld h,d			; $756d
	ld l,SpecialObject.var38		; $756e
	ld (hl),a		; $7570

	ld l,SpecialObject.state		; $7571
	ld a,$01		; $7573
	ldi (hl),a		; $7575
	ld (hl),$00 ; [state2] = 0

	ld c,$1c		; $7578
	jp _companionSetAnimation		; $757a

;;
; State 3: Link is jumping up to mount Dimitri
; @addr{757d}
_dimitriState3:
	call _companionCheckMountingComplete		; $757d
	ret nz			; $7580
	call _companionFinalizeMounting		; $7581
	ld c,$00		; $7584
	jp _companionSetAnimation		; $7586

;;
; State 4: Dimitri's falling into a hazard (hole/water)
; @addr{7589}
_dimitriState4:
	call _companionDragToCenterOfHole		; $7589
	ret nz			; $758c
	call _companionDecCounter1		; $758d
	jr nz,@animate		; $7590

	inc (hl)		; $7592
	ld a,SND_LINK_FALL		; $7593
	call playSound		; $7595
	ld a,$25		; $7598
	jp specialObjectSetAnimation		; $759a

@animate:
	call _companionAnimateDrowningOrFallingThenRespawn		; $759d
	ret nc			; $75a0
	ld c,$00		; $75a1
	jp _companionUpdateDirectionAndSetAnimation		; $75a3

;;
; State 5: Link riding dimitri.
; @addr{75a6}
_dimitriState5:
	ld c,$40		; $75a6
	call objectUpdateSpeedZ_paramC		; $75a8
	ret nz			; $75ab

	ld a,(wForceCompanionDismount)		; $75ac
	or a			; $75af
	jr nz,++		; $75b0
	ld a,(wGameKeysJustPressed)		; $75b2
	bit BTN_BIT_A,a			; $75b5
	jr nz,_dimitriGotoEatingState	; $75b7
	bit BTN_BIT_B,a			; $75b9
++
	jp nz,_companionGotoDismountState		; $75bb

	ld a,(wLinkAngle)		; $75be
	bit 7,a			; $75c1
	jr nz,_dimitriUpdateMovement@checkHazards	; $75c3

	; Check if angle changed, update direction if so
	ld hl,w1Companion.angle		; $75c5
	cp (hl)			; $75c8
	ld (hl),a		; $75c9
	ld c,$00		; $75ca
	jp nz,_companionUpdateDirectionAndAnimate		; $75cc

	; Return if he should hop down a cliff (state changed in function call)
	call _companionCheckHopDownCliff		; $75cf
	ret z			; $75d2

;;
; @addr{75d3}
_dimitriUpdateMovement:
	; Play sound effect when animation indicates to do so
	ld h,d			; $75d3
	ld l,SpecialObject.animParameter		; $75d4
	ld a,(hl)		; $75d6
	rlca			; $75d7
	ld a,SND_LINK_SWIM		; $75d8
	call c,playSound		; $75da

	; Determine speed
	ld l,SpecialObject.var38		; $75dd
	ld a,(hl)		; $75df
	or a			; $75e0
	ld a,SPEED_c0		; $75e1
	jr z,+			; $75e3
	ld a,SPEED_100		; $75e5
+
	ld l,SpecialObject.speed		; $75e7
	ld (hl),a		; $75e9
	call _companionUpdateMovement		; $75ea
	call specialObjectAnimate		; $75ed

@checkHazards:
	call _companionCheckHazards		; $75f0
	ld h,d			; $75f3
	jr nc,@setNotInWater	; $75f4

	; Return if the hazard is a hole
	cp $02			; $75f6
	ret z			; $75f8

	; If it's water, stay in state 5 (he can swim).
	ld l,SpecialObject.state		; $75f9
	ld (hl),$05		; $75fb

.ifdef ROM_AGES
	ld a,(wLinkForceState)		; $75fd
	cp LINK_STATE_RESPAWNING			; $7600
	jr nz,++		; $7602
	xor a			; $7604
	ld (wLinkForceState),a		; $7605
	jp _companionGotoHazardHandlingState		; $7608
++
.endif

	call _dimitriAddWaterfallResistance		; $760b
	ld b,$04		; $760e
	jr @setWaterStatus		; $7610

@setNotInWater:
	ld b,$00		; $7612

@setWaterStatus:
	; Set var38 to value of "b", update animation if it changed
	ld l,SpecialObject.var38		; $7614
	ld a,(hl)		; $7616
	cp b			; $7617
	ld (hl),b		; $7618
	ld c,$00		; $7619
	jp nz,_companionUpdateDirectionAndSetAnimation		; $761b

;;
; @addr{761e}
_dimitriState9:
	ret			; $761e

;;
; @addr{761f}
_dimitriGotoEatingState:
	ld h,d			; $761f
	ld l,SpecialObject.state		; $7620
	ld a,$08		; $7622
	ldi (hl),a		; $7624
	xor a			; $7625
	ldi (hl),a ; [state2] = 0
	ld (hl),a  ; [counter1] = 0

	ld l,SpecialObject.var35		; $7628
	ld (hl),a		; $762a

	; Calculate angle based on direction
	ld l,SpecialObject.direction		; $762b
	ldi a,(hl)		; $762d
	swap a			; $762e
	rrca			; $7630
	ld (hl),a		; $7631

	ld a,$01		; $7632
	ld (wLinkInAir),a		; $7634
	ld l,SpecialObject.speed		; $7637
	ld (hl),SPEED_c0		; $7639
	ld c,$08		; $763b
	call _companionSetAnimation		; $763d
	ldbc ITEMID_DIMITRI_MOUTH, $00		; $7640
	call _companionCreateWeaponItem		; $7643

	ld a,SND_DIMITRI		; $7646
	jp playSound		; $7648

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
; @addr{764b}
_dimitriState6:
	ld e,SpecialObject.state2		; $764b
	ld a,(de)		; $764d
	rst_jumpTable			; $764e
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01		; $7655
	ld (de),a		; $7657
	call companionDismountAndSavePosition		; $7658
	ld c,$1c		; $765b
	jp _companionSetAnimation		; $765d

@substate1:
	ld a,(wLinkInAir)		; $7660
	or a			; $7663
	ret nz			; $7664
	jp itemIncState2		; $7665

@substate2:
	call _dimitriCheckAddToGrabbableObjectBuffer		; $7668

;;
; @addr{766b}
_dimitriGotoState1IfLinkFarAway:
	; Return if Link is too close
	ld c,$09		; $766b
	call objectCheckLinkWithinDistance		; $766d
	ret c			; $7670

;;
; @param[out]	a	0
; @param[out]	de	var3b
; @addr{7671}
_dimitriGotoState1:
	ld e,SpecialObject.state		; $7671
	ld a,$01		; $7673
	ld (de),a		; $7675
	inc e			; $7676
	xor a			; $7677
	ld (de),a ; [state2] = 0
	ld e,SpecialObject.var3b		; $7679
	ld (de),a		; $767b
	ret			; $767c

;;
; State 7: jumping down a cliff
; @addr{767d}
_dimitriState7:
	call _companionDecCounter1ToJumpDownCliff		; $767d
	ret c			; $7680
	call _companionCalculateAdjacentWallsBitset		; $7681
	call _specialObjectCheckMovingAwayFromWall		; $7684

	ld l,SpecialObject.counter2		; $7687
	jr z,+			; $7689
	ld (hl),a		; $768b
	ret			; $768c
+
	ld a,(hl)		; $768d
	or a			; $768e
	ret z			; $768f
	jp _dimitriLandOnGroundAndGotoState5		; $7690

;;
; State 8: Attempting to eat something
; @addr{7693}
_dimitriState8:
	ld e,SpecialObject.state2		; $7693
	ld a,(de)		; $7695
	rst_jumpTable			; $7696
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Substate 0: Moving forward for the bite
@substate0:
	call specialObjectAnimate		; $769d
	call objectApplySpeed		; $76a0
	ld e,SpecialObject.animParameter		; $76a3
	ld a,(de)		; $76a5
	rlca			; $76a6
	ret nc			; $76a7

	; Initialize stuff for substate 1 (moving back)

	call itemIncState2		; $76a8

	; Calculate angle based on the reverse of the current direction
	ld l,SpecialObject.direction		; $76ab
	ldi a,(hl)		; $76ad
	xor $02			; $76ae
	swap a			; $76b0
	rrca			; $76b2
	ld (hl),a		; $76b3

	ld l,SpecialObject.counter1		; $76b4
	ld (hl),$0c		; $76b6
	ld c,$00		; $76b8
	jp _companionSetAnimation		; $76ba

; Substate 1: moving back
@substate1:
	call specialObjectAnimate		; $76bd
	call objectApplySpeed		; $76c0
	call _companionDecCounter1IfNonzero		; $76c3
	ret nz			; $76c6

	; Done moving back

	ld (hl),$14		; $76c7

	; Fix angle to be consistent with direction
	ld l,SpecialObject.direction		; $76c9
	ldi a,(hl)		; $76cb
	swap a			; $76cc
	rrca			; $76ce
	ld (hl),a		; $76cf

	; Check if he swallowed something; if so, go to substate 2, otherwise resume
	; normal movement.
	ld l,SpecialObject.var35		; $76d0
	ld a,(hl)		; $76d2
	or a			; $76d3
	jp z,_dimitriLandOnGroundAndGotoState5		; $76d4
	call itemIncState2		; $76d7
	ld c,$10		; $76da
	jp _companionSetAnimation		; $76dc

; Substate 2: swallowing something
@substate2:
	call specialObjectAnimate		; $76df
	call _companionDecCounter1IfNonzero		; $76e2
	ret nz			; $76e5
	jr _dimitriLandOnGroundAndGotoState5		; $76e6

;;
; State B: swimming back to land after being thrown into water
; @addr{76e8}
_dimitriStateB:
	ld c,$40		; $76e8
	call objectUpdateSpeedZ_paramC		; $76ea
	ret nz			; $76ed

	call _dimitriUpdateMovement		; $76ee

	; Set state to $01 if he's out of the water; stay in $0b otherwise
	ld h,d			; $76f1
	ld l,SpecialObject.var38		; $76f2
	ld a,(hl)		; $76f4
	or a			; $76f5
	ld l,SpecialObject.state		; $76f6
	ld (hl),$0b		; $76f8
	ret nz			; $76fa
	ld (hl),$01		; $76fb
	ret			; $76fd

;;
; State C: Dimitri entering screen from flute call
; @addr{76fe}
_dimitriStateC:
	ld e,SpecialObject.var03		; $76fe
	ld a,(de)		; $7700
	rst_jumpTable			; $7701
	.dw @parameter0
	.dw @parameter1

; substate 0: dimitri just spawned?
@parameter0:
	call _companionInitializeOnEnteringScreen		; $7706
	ld (hl),$3c ; [counter2] = $3c

	ld a,SND_DIMITRI		; $770b
	call playSound		; $770d
	ld c,$00		; $7710
	jp _companionSetAnimation		; $7712

; substate 1: walking in
@parameter1:
	call _dimitriUpdateMovement		; $7715
	ld e,SpecialObject.state		; $7718
	ld a,$0c		; $771a
	ld (de),a		; $771c

	ld hl,_dimitriTileOffsets		; $771d
	call _companionRetIfNotFinishedWalkingIn		; $7720

	; Done walking into screen; jump to state 0
	ld e,SpecialObject.var03		; $7723
	xor a			; $7725
	ld (de),a		; $7726
	jp _dimitriState0		; $7727

;;
; State D: ? (set to this by INTERACID_CARPENTER subid $ff?)
; @addr{772a}
_dimitriStateD:
	ld e,SpecialObject.var3c		; $772a
	ld a,(de)		; $772c
	or a			; $772d
	jr nz,++		; $772e

	call _dimitriGotoState1		; $7730
	inc a			; $7733
	ld (de),a ; [var3b] = 1

	ld hl,w1Companion.enabled		; $7735
	res 1,(hl)		; $7738
	ld c,$1c		; $773a
	jp _companionSetAnimation		; $773c
++
	ld e,SpecialObject.state		; $773f
	ld a,$05		; $7741
	ld (de),a		; $7743

;;
; @addr{7744}
_dimitriLandOnGroundAndGotoState5:
	xor a			; $7744
	ld (wLinkInAir),a		; $7745
	ld c,$00		; $7748
	jp _companionSetAnimationAndGotoState5		; $774a

.ifdef ROM_AGES
;;
; State A: cutscene-related stuff
; @addr{774d}
_dimitriStateA:
	ld e,SpecialObject.var03		; $774d
	ld a,(de)		; $774f
	rst_jumpTable			; $7750
	.dw _dimitriStateASubstate0
	.dw _dimitriStateASubstate1
	.dw _dimitriStateASubstate2
	.dw _dimitriStateASubstate3
	.dw _dimitriStateASubstate4

;;
; Force mounting Dimitri?
; @addr{775b}
_dimitriStateASubstate0:
	ld e,SpecialObject.var3d		; $775b
	ld a,(de)		; $775d
	or a			; $775e
	jr z,+			; $775f
	ld a,$81		; $7761
	ld (wDisabledObjects),a		; $7763
+
	call _companionSetAnimationToVar3f		; $7766
	call _companionPreventLinkFromPassing_noExtraChecks		; $7769
	call specialObjectAnimate		; $776c

	ld e,SpecialObject.visible		; $776f
	ld a,$c7		; $7771
	ld (de),a		; $7773

	ld a,(wDimitriState)		; $7774
	and $80			; $7777
	ret z			; $7779

	ld e,SpecialObject.visible		; $777a
	ld a,$c1		; $777c
	ld (de),a		; $777e

	ld a,$ff		; $777f
	ld (wStatusBarNeedsRefresh),a		; $7781
	ld c,$1c		; $7784
	call _companionSetAnimation		; $7786
	jp _companionForceMount		; $7789

;;
; Force mounting dimitri?
; @addr{778c}
_dimitriStateASubstate1:
	ld e,SpecialObject.var3d		; $778c
	call objectRemoveFromAButtonSensitiveObjectList		; $778e
	ld c,$1c		; $7791
	call _companionSetAnimation		; $7793
	jp _companionForceMount		; $7796

;;
; Dimitri begins parting upon reaching mainland?
; @addr{7799}
_dimitriStateASubstate3:
	ld e,SpecialObject.direction		; $7799
	ld a,DIR_RIGHT		; $779b
	ld (de),a		; $779d
	inc e			; $779e
	ld a,$08		; $779f
	ld (de),a ; [angle] = $08

	ld c,$00		; $77a2
	call _companionSetAnimation		; $77a4
	ld e,SpecialObject.var03		; $77a7
	ld a,$04		; $77a9
	ld (de),a		; $77ab

	ld a,SND_DIMITRI		; $77ac
	jp playSound		; $77ae

;;
; Dimitri moving until he goes off-screen
; @addr{77b1}
_dimitriStateASubstate4:
	call _dimitriUpdateMovement		; $77b1

	ld e,SpecialObject.state		; $77b4
	ld a,$0a		; $77b6
	ld (de),a		; $77b8

	call objectCheckWithinScreenBoundary		; $77b9
	ret c			; $77bc

	xor a			; $77bd
	ld (wDisabledObjects),a		; $77be
	ld (wMenuDisabled),a		; $77c1
	ld (wUseSimulatedInput),a		; $77c4
	jp itemDelete		; $77c7

;;
; Force dismount Dimitri
; @addr{77ca}
_dimitriStateASubstate2:
	ld a,(wLinkObjectIndex)		; $77ca
	cp >w1Companion			; $77cd
	ret nz			; $77cf
	call companionDismountAndSavePosition		; $77d0
	xor a			; $77d3
	ld (wRememberedCompanionId),a		; $77d4
	ret			; $77d7
.else
_dimitriStateA:
	call _companionSetAnimationToVar3f		; $7678
	call _companionPreventLinkFromPassing_noExtraChecks		; $767b
	call specialObjectAnimate		; $767e
	ld e,SpecialObject.visible		; $7681
	ld a,$c7		; $7683
	ld (de),a		; $7685
	ld a,(wDimitriState)		; $7686
	and $80			; $7689
	ret z			; $768b

	ld e,SpecialObject.visible		; $768c
	ld a,$c1		; $768e
	ld (de),a		; $7690
	ld a,$ff		; $7691
	ld (wStatusBarNeedsRefresh),a		; $7693
	ld c,$1c		; $7696
	call _companionSetAnimation		; $7698
	jp _companionForceMount		; $769b
.endif

;;
; @addr{77d8}
_dimitriCheckAddToGrabbableObjectBuffer:
	ld a,(wLinkClimbingVine)		; $77d8
	or a			; $77db
	ret nz			; $77dc
	ld a,(w1Link.direction)		; $77dd
	call _dimitriCheckCanBeHeldInDirection		; $77e0
	ret z			; $77e3

	; Check the collisions at Link's position
	ld hl,w1Link.yh		; $77e4
	ld b,(hl)		; $77e7
	ld l,<w1Link.xh		; $77e8
	ld c,(hl)		; $77ea
	call getTileCollisionsAtPosition		; $77eb

	; Disallow cave entrances (top half solid)?
	cp $0c			; $77ee
	jr z,@ret	; $77f0

	; Disallow if Link's on a fully solid tile?
	cp $0f			; $77f2
	jr z,@ret	; $77f4

	cp SPECIALCOLLISION_VERTICAL_BRIDGE			; $77f6
	jr z,@ret	; $77f8
	cp SPECIALCOLLISION_HORIZONTAL_BRIDGE			; $77fa
	call nz,objectAddToGrabbableObjectBuffer		; $77fc
@ret:
	ret			; $77ff

;;
; Checks the tiles in front of Dimitri to see if he can be held?
; (if moving diagonally, it checks both directions, and fails if one is impassable).
;
; This seems to disallow holding him on small bridges and cave entrances.
;
; @param	a	Direction that Link/Dimitri's moving toward
; @param[out]	zflag	Set if one of the tiles in front are not passable.
; @addr{7800}
_dimitriCheckCanBeHeldInDirection:
	call @checkTile		; $7800
	ret z			; $7803

	ld hl,w1Link.angle		; $7804
	ldd a,(hl)		; $7807
	bit 7,a			; $7808
	ret nz			; $780a
	bit 2,a			; $780b
	jr nz,@diagonalMovement			; $780d

	or d			; $780f
	ret			; $7810

@diagonalMovement:
	; Calculate the other direction being moved in
	add a			; $7811
	ld b,a			; $7812
	ldi a,(hl) ; a = [direction]
	swap a			; $7814
	srl a			; $7816
	xor b			; $7818
	add a			; $7819
	swap a			; $781a
	and $03			; $781c

;;
; @param	a	Direction
; @param[out]	zflag	Set if the tile in that direction is not ok for holding dimitri?
; @addr{781e}
@checkTile:
	ld hl,_dimitriTileOffsets		; $781e
	rst_addDoubleIndex			; $7821
	ldi a,(hl)		; $7822
	ld c,(hl)		; $7823
	ld b,a			; $7824
	call objectGetRelativeTile		; $7825

	cp TILEINDEX_VINE_BOTTOM			; $7828
	ret z			; $782a
	cp TILEINDEX_VINE_MIDDLE			; $782b
	ret z			; $782d
	cp TILEINDEX_VINE_TOP			; $782e
	ret z			; $7830

	; Only disallow tiles where the top half is solid? (cave entrances?
	ld h,>wRoomCollisions		; $7831
	ld a,(hl)		; $7833
	cp $0c			; $7834
	ret z			; $7836

	cp SPECIALCOLLISION_VERTICAL_BRIDGE			; $7837
	ret z			; $7839
	cp SPECIALCOLLISION_HORIZONTAL_BRIDGE			; $783a
	ret			; $783c

;;
; Moves Dimitri down if he's on a waterfall
; @addr{783d}
_dimitriAddWaterfallResistance:
	call objectGetTileAtPosition		; $783d
	ld h,d			; $7840
	cp TILEINDEX_WATERFALL			; $7841
	jr z,+			; $7843
	cp TILEINDEX_WATERFALL_BOTTOM			; $7845
	ret nz			; $7847
+
	; Move y-position down the waterfall (acts as resistance)
	ld l,SpecialObject.y		; $7848
	ld a,(hl)		; $784a
	add $c0			; $784b
	ldi (hl),a		; $784d
	ld a,(hl)		; $784e
	adc $00			; $784f
	ld (hl),a		; $7851

	; Check if we should start a screen transition based on downward waterfall
	; movement
	ld a,(wScreenTransitionBoundaryY)		; $7852
	cp (hl)			; $7855
	ret nc			; $7856
	ld a,$82		; $7857
	ld (wScreenTransitionDirection),a		; $7859
	ret			; $785c

_dimitriTileOffsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT

;;
; @addr{7865}
_specialObjectCode_moosh:
	call _companionRetIfInactive		; $7865
	call _companionFunc_47d8		; $7868
	call @runState		; $786b
	jp _companionCheckEnableTerrainEffects		; $786e

@runState:
	ld e,SpecialObject.state		; $7871
	ld a,(de)		; $7873
	rst_jumpTable			; $7874
	.dw _mooshState0
	.dw _mooshState1
	.dw _mooshState2
	.dw _mooshState3
	.dw _mooshState4
	.dw _mooshState5
	.dw _mooshState6
	.dw _mooshState7
	.dw _mooshState8
	.dw _mooshState9
	.dw _mooshStateA
	.dw _mooshStateB
	.dw _mooshStateC

;;
; State 0: initialization
; @addr{788f}
_mooshState0:
	call _companionCheckCanSpawn		; $788f
	ld a,$06		; $7892
	call objectSetCollideRadius		; $7894

	ld a,DIR_DOWN		; $7897
	ld l,SpecialObject.direction		; $7899
	ldi (hl),a		; $789b
	ldi (hl),a ; [angle] = $02

	ld hl,wMooshState		; $789d
	ld a,$80		; $78a0
	and (hl)		; $78a2
	jr nz,@setAnimation	; $78a3

.ifdef ROM_AGES
	; Check for the screen with the bridge near the forest?
	ld a,(wActiveRoom)		; $78a5
	cp $54			; $78a8
	jr z,@gotoCutsceneStateA	; $78aa

	ld a,$20		; $78ac
	and (hl)		; $78ae
	jr z,@gotoCutsceneStateA	; $78af
	ld a,$40		; $78b1
	and (hl)		; $78b3
	jr nz,@gotoCutsceneStateA	; $78b4

	; Check for the room where Moosh leaves after obtaining cheval's rope
	ld a,TREASURE_CHEVAL_ROPE		; $78b6
	call checkTreasureObtained		; $78b8
	jr nc,@setAnimation	; $78bb
	ld a,(wActiveRoom)		; $78bd
	cp $6b			; $78c0
	jr nz,@setAnimation	; $78c2
.else
	ld a,(wAnimalCompanion)		; $776b
	cp SPECIALOBJECTID_MOOSH			; $776e
	jr nz,@gotoCutsceneStateA	; $7770

	ld a,$20		; $7772
	and (hl)		; $7774
	jr z,+			; $7775

	ld a,(wActiveRoom)		; $7777
	; mt cucco
	cp $2f			; $777a
	jr z,@gotoCutsceneStateA	; $777c
	jr @setAnimation		; $777e
+
	ld a,(wActiveRoom)		; $7780
	; spool swamp
	cp $90			; $7783
	jr nz,@setAnimation	; $7785
.endif

@gotoCutsceneStateA:
	ld e,SpecialObject.state		; $78c4
	ld a,$0a		; $78c6
	ld (de),a		; $78c8
	jp _mooshStateA		; $78c9

@setAnimation:
	ld c,$01		; $78cc
	call _companionSetAnimation		; $78ce
	jp objectSetVisiblec1		; $78d1

;;
; State 1: waiting for Link to mount
; @addr{78d4}
_mooshState1:
	call _companionSetPriorityRelativeToLink		; $78d4
	call specialObjectAnimate		; $78d7

	ld c,$09		; $78da
	call objectCheckLinkWithinDistance		; $78dc
	jp c,_companionTryToMount		; $78df

;;
; @addr{78e2}
_mooshCheckHazards:
	call _companionCheckHazards		; $78e2
	ret nc			; $78e5
	jr _mooshSetVar37ForHazard		; $78e6

;;
; State 3: Link is currently jumping up to mount Moosh
; @addr{78e8}
_mooshState3:
	call _companionCheckMountingComplete		; $78e8
	ret nz			; $78eb
	call _companionFinalizeMounting		; $78ec
	ld c,$13		; $78ef
	jp _companionSetAnimation		; $78f1

;;
; State 4: Moosh falling into a hazard (hole/water)
; @addr{78f4}
_mooshState4:
	ld h,d			; $78f4
	ld l,SpecialObject.collisionType		; $78f5
	set 7,(hl)		; $78f7

	; Check if the hazard is water
	ld l,SpecialObject.var37		; $78f9
	ld a,(hl)		; $78fb
	cp $0d
	jr z,++			; $78fe

	; No, it's a hole
	ld a,$0e		; $7900
	ld (hl),a		; $7902
	call _companionDragToCenterOfHole		; $7903
	ret nz			; $7906
++
	call _companionDecCounter1		; $7907
	jr nz,@animate	; $790a

	; Set falling/drowning animation, play falling sound if appropriate
	dec (hl)		; $790c
	ld l,SpecialObject.var37		; $790d
	ld a,(hl)		; $790f
	call specialObjectSetAnimation		; $7910

	ld e,SpecialObject.var37		; $7913
	ld a,(de)		; $7915
	cp $0d ; Is this water?
	jr z,@animate	; $7918

	ld a,SND_LINK_FALL		; $791a
	jp playSound		; $791c

@animate:
	call _companionAnimateDrowningOrFallingThenRespawn		; $791f
	ret nc			; $7922
	ld c,$13		; $7923
	ld a,(wLinkObjectIndex)		; $7925
	rrca			; $7928
	jr c,+			; $7929
	ld c,$01		; $792b
+
	jp _companionUpdateDirectionAndSetAnimation		; $792d

;;
; @addr{7930}
_mooshTryToBreakTileFromMovingAndCheckHazards:
	call _companionTryToBreakTileFromMoving		; $7930
	call _companionCheckHazards		; $7933
	ld c,$13		; $7936
	jp nc,_companionUpdateDirectionAndAnimate		; $7938

;;
; @addr{793b}
_mooshSetVar37ForHazard:
	dec a			; $793b
	ld c,$0d		; $793c
	jr z,+			; $793e
	ld c,$0e		; $7940
+
	ld e,SpecialObject.var37		; $7942
	ld a,c			; $7944
	ld (de),a		; $7945
	ld e,SpecialObject.counter1		; $7946
	xor a			; $7948
	ld (de),a		; $7949
	ret			; $794a

;;
; State 5: Link riding Moosh.
; @addr{794b}
_mooshState5:
	ld c,$10		; $794b
	call objectUpdateSpeedZ_paramC		; $794d
	ret nz			; $7950

	call _companionCheckHazards		; $7951
	jr c,_mooshSetVar37ForHazard	; $7954

	ld a,(wForceCompanionDismount)		; $7956
	or a			; $7959
	jr nz,++		; $795a
	ld a,(wGameKeysJustPressed)		; $795c
	bit BTN_BIT_A,a			; $795f
	jr nz,_mooshPressedAButton	; $7961
	bit BTN_BIT_B,a			; $7963
++
	jp nz,_companionGotoDismountState		; $7965

	; Return if not attempting to move
	ld a,(wLinkAngle)		; $7968
	bit 7,a			; $796b
	ret nz			; $796d

	; Update angle, and animation if the angle changed
	ld hl,w1Companion.angle		; $796e
	cp (hl)			; $7971
	ld (hl),a		; $7972
	ld c,$13		; $7973
	jp nz,_companionUpdateDirectionAndAnimate		; $7975

	call _companionCheckHopDownCliff		; $7978
	ret z			; $797b

	ld e,SpecialObject.speed		; $797c
	ld a,SPEED_100		; $797e
	ld (de),a		; $7980
	call _companionUpdateMovement		; $7981

	jr _mooshTryToBreakTileFromMovingAndCheckHazards		; $7984

;;
; @addr{7986}
_mooshLandOnGroundAndGotoState5:
	xor a			; $7986
	ld (wLinkInAir),a		; $7987
	ld c,$13		; $798a
	jp _companionSetAnimationAndGotoState5		; $798c

;;
; @addr{798f}
_mooshPressedAButton:
	ld a,$08		; $798f
	ld e,SpecialObject.state		; $7991
	ld (de),a		; $7993
	inc e			; $7994
	xor a			; $7995
	ld (de),a		; $7996
	ld a,SND_JUMP		; $7997
	call playSound		; $7999

;;
; @addr{799c}
_mooshState2:
_mooshState9:
_mooshStateB:
	ret			; $799c

;;
; State 8: floating in air, possibly performing buttstomp
; @addr{799d}
_mooshState8:
	ld e,SpecialObject.state2		; $799d
	ld a,(de)		; $799f
	rst_jumpTable			; $79a0
	.dw _mooshState8Substate0
	.dw _mooshState8Substate1
	.dw _mooshState8Substate2
	.dw _mooshState8Substate3
	.dw _mooshState8Substate4
	.dw _mooshState8Substate5

;;
; Substate 0: just pressed A button
; @addr{79ad}
_mooshState8Substate0:
	ld a,$01		; $79ad
	ld (de),a ; [state2] = 1

	ld bc,-$140		; $79b0
	call objectSetSpeedZ		; $79b3
	ld l,SpecialObject.speed		; $79b6
	ld (hl),SPEED_100		; $79b8

	ld l,SpecialObject.var39		; $79ba
	ld a,$04		; $79bc
	ldi (hl),a		; $79be
	xor a			; $79bf
	ldi (hl),a ; [var3a] = 0
	ldi (hl),a ; [var3b] = 0

	ld c,$09		; $79c2
	jp _companionSetAnimation		; $79c4

;;
; Substate 1: floating in air
; @addr{79c7}
_mooshState8Substate1:
	; Check if over water
	call objectCheckIsOverHazard		; $79c7
	cp $01			; $79ca
	jr nz,@notOverWater	; $79cc

; He's over water; go to substate 5.

	ld bc,$0000		; $79ce
	call objectSetSpeedZ		; $79d1

	ld l,SpecialObject.state2		; $79d4
	ld (hl),$05		; $79d6

	ld b,INTERACID_EXCLAMATION_MARK		; $79d8
	call objectCreateInteractionWithSubid00		; $79da

	; Subtract new interaction's zh by $20 (should be above moosh)
	dec l			; $79dd
	ld a,(hl)		; $79de
	sub $20			; $79df
	ld (hl),a		; $79e1

	ld l,Interaction.counter1		; $79e2
	ld e,SpecialObject.counter1		; $79e4
	ld a,$3c		; $79e6
	ld (hl),a ; [Interaction.counter1] = $3c
	ld (de),a ; [Moosh.counter1] = $3c
	ret			; $79ea

@notOverWater:
	ld a,(wLinkAngle)		; $79eb
	bit 7,a			; $79ee
	jr nz,+			; $79f0
	ld hl,w1Companion.angle		; $79f2
	cp (hl)			; $79f5
	ld (hl),a		; $79f6
	call _companionUpdateMovement		; $79f7
+
	ld e,SpecialObject.speedZ+1		; $79fa
	ld a,(de)		; $79fc
	rlca			; $79fd
	jr c,@movingUp	; $79fe

; Moosh is moving down (speedZ is positive or 0).

	; Increment var3b once for every frame A is held (or set to 0 if A is released).
	ld e,SpecialObject.var3b		; $7a00
	ld a,(wGameKeysPressed)		; $7a02
	and BTN_A			; $7a05
	jr z,+			; $7a07
	ld a,(de)		; $7a09
	inc a			; $7a0a
+
	ld (de),a		; $7a0b

	; Start charging stomp after A is held for 10 frames
	cp $0a			; $7a0c
	jr nc,@gotoSubstate2	; $7a0e

	; If pressed A, flutter in the air.
	ld a,(wGameKeysJustPressed)		; $7a10
	bit BTN_BIT_A,a			; $7a13
	jr z,@label_05_444	; $7a15

	; Don't allow him to flutter more than 16 times.
	ld e,SpecialObject.var3a		; $7a17
	ld a,(de)		; $7a19
	cp $10			; $7a1a
	jr z,@label_05_444	; $7a1c

	; [var3a] += 1 (counter for number of times he's fluttered)
	inc a			; $7a1e
	ld (de),a		; $7a1f

	; [var39] += 8 (ignore gravity for 8 more frames)
	dec e			; $7a20
	ld a,(de)		; $7a21
	add $08			; $7a22
	ld (de),a		; $7a24

	ld e,SpecialObject.animCounter		; $7a25
	ld a,$01		; $7a27
	ld (de),a		; $7a29
	call specialObjectAnimate		; $7a2a
	ld a,SND_JUMP		; $7a2d
	call playSound		; $7a2f

@label_05_444:
	ld e,SpecialObject.var39		; $7a32
	ld a,(de)		; $7a34
	or a			; $7a35
	jr z,@updateMovement	; $7a36

	; [var39] -= 1
	dec a			; $7a38
	ld (de),a		; $7a39

	ld e,SpecialObject.animCounter		; $7a3a
	ld a,$0f		; $7a3c
	ld (de),a		; $7a3e
	ld c,$09		; $7a3f
	jp _companionUpdateDirectionAndAnimate		; $7a41

@movingUp:
	ld c,$09		; $7a44
	call _companionUpdateDirectionAndAnimate		; $7a46

@updateMovement:
	ld c,$10		; $7a49
	call objectUpdateSpeedZ_paramC		; $7a4b
	ret nz			; $7a4e
	call _companionTryToBreakTileFromMoving		; $7a4f
	call _mooshLandOnGroundAndGotoState5		; $7a52
	jp _mooshTryToBreakTileFromMovingAndCheckHazards		; $7a55

@gotoSubstate2:
	jp itemIncState2		; $7a58

;;
; Substate 2: charging buttstomp
; @addr{7a5b}
_mooshState8Substate2:
	call specialObjectAnimate		; $7a5b

	ld a,(wGameKeysPressed)		; $7a5e
	bit BTN_BIT_A,a			; $7a61
	jr z,@gotoNextSubstate	; $7a63

	ld e,SpecialObject.var3b		; $7a65
	ld a,(de)		; $7a67
	cp 40			; $7a68
	jr c,+			; $7a6a
	ld c,$02		; $7a6c
	call _companionFlashFromChargingAnimation		; $7a6e
+
	ld e,SpecialObject.var3b		; $7a71
	ld a,(de)		; $7a73
	inc a			; $7a74
	ld (de),a		; $7a75

	; Check if it's finished charging
	cp 40			; $7a76
	ret c			; $7a78
	ld a,SND_CHARGE_SWORD		; $7a79
	jp z,playSound		; $7a7b

	; Reset bit 7 on w1Link.collisionType and w1Companion.collisionType (disable
	; collisions?)
	ld hl,w1Link.collisionType		; $7a7e
	res 7,(hl)		; $7a81
	inc h			; $7a83
	res 7,(hl)		; $7a84

	; Force the buttstomp to release after 120 frames of charging
	ld e,SpecialObject.var3b		; $7a86
	ld a,(de)		; $7a88
	cp 120			; $7a89
	ret nz			; $7a8b

@gotoNextSubstate:
	ld hl,w1Link.oamFlagsBackup		; $7a8c
	ldi a,(hl)		; $7a8f
	ld (hl),a ; [w1Link.oamFlags] = [w1Link.oamFlagsBackup]

	call itemIncState2		; $7a91
	ld c,$17		; $7a94

	; Set buttstomp animation if he's charged up enough
	ld e,SpecialObject.var3b		; $7a96
	ld a,(de)		; $7a98
	cp 40			; $7a99
	ret c			; $7a9b
	jp _companionSetAnimation		; $7a9c

;;
; Substate 3: falling to ground with buttstomp attack (or cancelling buttstomp)
; @addr{7a9f}
_mooshState8Substate3:
	ld c,$80		; $7a9f
	call objectUpdateSpeedZ_paramC		; $7aa1
	ret nz			; $7aa4

; Reached the ground

	ld e,SpecialObject.var3b		; $7aa5
	ld a,(de)		; $7aa7
	cp 40			; $7aa8
	jr nc,+			; $7aaa

	; Buttstomp not charged; just land on the ground
	call _mooshLandOnGroundAndGotoState5		; $7aac
	jp _mooshTryToBreakTileFromMovingAndCheckHazards		; $7aaf
+
	; Buttstomp charged; unleash the attack
	call _companionCheckHazards		; $7ab2
	jp c,_mooshSetVar37ForHazard		; $7ab5

	call itemIncState2		; $7ab8

	ld a,$0f		; $7abb
	ld (wScreenShakeCounterY),a		; $7abd

	ld a,SNDCTRL_STOPSFX		; $7ac0
	call playSound		; $7ac2
	ld a,SND_SCENT_SEED		; $7ac5
	call playSound		; $7ac7

	ld a,$05		; $7aca
	ld hl,wCompanionTutorialTextShown		; $7acc
	call setFlag		; $7acf

	ldbc ITEMID_28, $00		; $7ad2
	jp _companionCreateWeaponItem		; $7ad5

;;
; Substate 4: sitting on the ground briefly after buttstomp attack
; @addr{7ad8}
_mooshState8Substate4:
	call specialObjectAnimate		; $7ad8
	ld e,SpecialObject.animParameter		; $7adb
	ld a,(de)		; $7add
	rlca			; $7ade
	ret nc			; $7adf

	; Set bit 7 on w1Link.collisionType and w1Companion.collisionType (enable
	; collisions?)
	ld hl,w1Link.collisionType		; $7ae0
	set 7,(hl)		; $7ae3
	inc h			; $7ae5
	set 7,(hl)		; $7ae6

	jp _mooshLandOnGroundAndGotoState5		; $7ae8

;;
; Substate 5: Moosh is over water, in the process of falling down.
; @addr{7aeb}
_mooshState8Substate5:
	call _companionDecCounter1IfNonzero		; $7aeb
	jr z,+			; $7aee
	jp specialObjectAnimate		; $7af0
+
	ld c,$10		; $7af3
	call objectUpdateSpeedZ_paramC		; $7af5
	ret nz			; $7af8
	call _mooshLandOnGroundAndGotoState5		; $7af9
	jp _mooshTryToBreakTileFromMovingAndCheckHazards		; $7afc

;;
; State 6: Link has dismounted; he can't remount until he moves a certain distance away,
; then comes back.
; @addr{7aff}
_mooshState6:
	ld e,SpecialObject.state2		; $7aff
	ld a,(de)		; $7b01
	rst_jumpTable			; $7b02
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01		; $7b09
	ld (de),a		; $7b0b
	call companionDismountAndSavePosition		; $7b0c
	ld c,$01		; $7b0f
	jp _companionSetAnimation		; $7b11

@substate1:
	ld a,(wLinkInAir)		; $7b14
	or a			; $7b17
	ret nz			; $7b18
	jp itemIncState2		; $7b19

@substate2:
	ld c,$09		; $7b1c
	call objectCheckLinkWithinDistance		; $7b1e
	jp c,_mooshCheckHazards		; $7b21

	ld e,SpecialObject.state2		; $7b24
	xor a			; $7b26
	ld (de),a		; $7b27
	dec e			; $7b28
	ld a,$01		; $7b29
	ld (de),a ; [state] = $01 (waiting for Link to mount)
	ret			; $7b2c

;;
; State 7: jumping down a cliff
; @addr{7b2d}
_mooshState7:
	call _companionDecCounter1ToJumpDownCliff		; $7b2d
	jr nc,+		; $7b30
	ret nz			; $7b32
	ld c,$09		; $7b33
	jp _companionSetAnimation		; $7b35
+
	call _companionCalculateAdjacentWallsBitset		; $7b38
	call _specialObjectCheckMovingAwayFromWall		; $7b3b
	ld e,$07		; $7b3e
	jr z,+			; $7b40
	ld (de),a		; $7b42
	ret			; $7b43
+
	ld a,(de)		; $7b44
	or a			; $7b45
	ret z			; $7b46
	jp _mooshLandOnGroundAndGotoState5		; $7b47

;;
; State C: Moosh entering from a flute call
; @addr{7b4a}
_mooshStateC:
	ld e,SpecialObject.var03		; $7b4a
	ld a,(de)		; $7b4c
	rst_jumpTable			; $7b4d
	.dw @substate0
	.dw @substate1

@substate0:
	call _companionInitializeOnEnteringScreen		; $7b52
	ld (hl),$3c ; [counter2] = $3c
	ld a,SND_MOOSH		; $7b57
	call playSound		; $7b59
	ld c,$0f		; $7b5c
	jp _companionSetAnimation		; $7b5e

@substate1:
	call specialObjectAnimate		; $7b61

	ld e,SpecialObject.speed		; $7b64
	ld a,SPEED_c0		; $7b66
	ld (de),a		; $7b68

	call _companionUpdateMovement		; $7b69
	ld hl,@mooshDirectionOffsets		; $7b6c
	call _companionRetIfNotFinishedWalkingIn		; $7b6f
	ld e,SpecialObject.var03		; $7b72
	xor a			; $7b74
	ld (de),a		; $7b75
	jp _mooshState0		; $7b76

@mooshDirectionOffsets:
	.db $f8 $00 ; DIR_UP
	.db $00 $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $00 $f8 ; DIR_LEFT


.ifdef ROM_AGES
;;
; State A: cutscene stuff
; @addr{7b81}
_mooshStateA:
	ld e,SpecialObject.var03		; $7b81
	ld a,(de)		; $7b83
	rst_jumpTable			; $7b84
	.dw @mooshStateASubstate0
	.dw _mooshStateASubstate1
	.dw @mooshStateASubstate2
	.dw _mooshStateASubstate3
	.dw _mooshStateASubstate4
	.dw _mooshStateASubstate5
	.dw _mooshStateASubstate6

;;
; @addr{7b93}
@mooshStateASubstate0:
	ld a,$01 ; [var03] = $01
	ld (de),a		; $7b95

	ld hl,wMooshState		; $7b96
	ld a,$20		; $7b99
	and (hl)		; $7b9b
	jr z,@label_05_454	; $7b9c

	ld a,$40		; $7b9e
	and (hl)		; $7ba0
	jr z,@label_05_456	; $7ba1

;;
; @addr{7ba3}
@mooshStateASubstate2:
	ld a,$01		; $7ba3
	ld (de),a ; [var03] = $01

	ld e,SpecialObject.var3d		; $7ba6
	call objectAddToAButtonSensitiveObjectList		; $7ba8

@label_05_454:
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST		; $7bab
	call checkGlobalFlag		; $7bad
	ld a,$00		; $7bb0
	jr z,+			; $7bb2
	ld a,$03		; $7bb4
+
	ld e,SpecialObject.var3f		; $7bb6
	ld (de),a		; $7bb8
	call specialObjectSetAnimation		; $7bb9
	jp objectSetVisiblec3		; $7bbc

@label_05_456:
	ld a,$01		; $7bbf
	ld (wMenuDisabled),a		; $7bc1
	ld (wDisabledObjects),a		; $7bc4

	ld a,$04		; $7bc7
	ld (de),a ; [var03] = $04

	ld a,$01		; $7bca
	call specialObjectSetAnimation		; $7bcc
	jp objectSetVisiblec3		; $7bcf

;;
; @addr{7bd2}
_mooshStateASubstate1:
	ld e,SpecialObject.var3d		; $7bd2
	ld a,(de)		; $7bd4
	or a			; $7bd5
	jr z,+			; $7bd6
	ld a,$01		; $7bd8
	ld (wDisabledObjects),a		; $7bda
	ld (wMenuDisabled),a		; $7bdd
+
	call _companionSetAnimationToVar3f		; $7be0
	call _mooshUpdateAsNpc		; $7be3
	ld a,(wMooshState)		; $7be6
	and $80			; $7be9
	ret z			; $7beb
	jr +			; $7bec

;;
; @addr{7bee}
_mooshStateASubstate3:
	call _companionSetAnimationToVar3f		; $7bee
	call _mooshUpdateAsNpc		; $7bf1
	ld a,(wMooshState)		; $7bf4
	and $20			; $7bf7
	ret z			; $7bf9
	ld a,$ff		; $7bfa
	ld (wStatusBarNeedsRefresh),a		; $7bfc

+
	ld e,SpecialObject.var3d	; $7bff
	xor a			; $7c01
	ld (de),a		; $7c02
	call objectRemoveFromAButtonSensitiveObjectList		; $7c03

	ld c,$01		; $7c06
	call _companionSetAnimation		; $7c08
	jp _companionForceMount		; $7c0b

;;
; @addr{7c0e}
_mooshStateASubstate4:
	call _mooshIncVar03		; $7c0e
	ld bc,TX_2208		; $7c11
	jp showText		; $7c14

;;
; @addr{7c17}
_mooshStateASubstate5:
	call retIfTextIsActive		; $7c17

	ld bc,-$140		; $7c1a
	call objectSetSpeedZ		; $7c1d
	ld l,SpecialObject.angle		; $7c20
	ld (hl),$10		; $7c22
	ld l,SpecialObject.speed		; $7c24
	ld (hl),SPEED_100		; $7c26

	ld a,$0b		; $7c28
	call specialObjectSetAnimation		; $7c2a

	jp _mooshIncVar03		; $7c2d

;;
; @addr{7c30}
_mooshStateASubstate6:
	call specialObjectAnimate		; $7c30

	ld e,SpecialObject.speedZ+1		; $7c33
	ld a,(de)		; $7c35
	or a			; $7c36
	ld c,$10		; $7c37
	jp nz,objectUpdateSpeedZ_paramC		; $7c39

	call objectApplySpeed		; $7c3c
	ld e,SpecialObject.yh		; $7c3f
	ld a,(de)		; $7c41
	cp $f0			; $7c42
	ret c			; $7c44

	xor a			; $7c45
	ld (wDisabledObjects),a		; $7c46
	ld (wMenuDisabled),a		; $7c49
	ld (wRememberedCompanionId),a		; $7c4c

	ld hl,wMooshState		; $7c4f
	set 6,(hl)		; $7c52
	jp itemDelete		; $7c54
.else
_mooshStateA:
	ld e,SpecialObject.var03
	ld a,(de)		; $7a46
	rst_jumpTable			; $7a47
	.dw _mooshStateASubstate0
	.dw _mooshStateASubstate1
	.dw _mooshStateASubstate2
	.dw _mooshStateASubstate3
	.dw _mooshStateASubstate4
	.dw _mooshStateASubstate5
	.dw _mooshStateASubstate6
	.dw _mooshStateASubstate7
	.dw _mooshStateASubstate8
	.dw _mooshStateASubstate9
	.dw _mooshStateASubstateA
	.dw _mooshStateASubstateB
	.dw _mooshStateASubstateC

_mooshStateASubstate0:
	ld a,$01		; $7a62
	ld (de),a		; $7a64

	ld a,(wAnimalCompanion)		; $7a65
	cp SPECIALOBJECTID_MOOSH			; $7a68
	jr nz,+			; $7a6a
	ld a,(wMooshState)		; $7a6c
	and $20			; $7a6f
	jr nz,+			; $7a71
	ld a,$02		; $7a73
	ld (de),a		; $7a75
	ld c,$01		; $7a76
	call _companionSetAnimation		; $7a78
	jr ++			; $7a7b
+
	ld a,$00		; $7a7d
	ld e,SpecialObject.var3f		; $7a7f
	ld (de),a		; $7a81
	call specialObjectSetAnimation		; $7a82
++
	call objectSetVisiblec3		; $7a85
	ld e,SpecialObject.var3d		; $7a88
	jp objectAddToAButtonSensitiveObjectList		; $7a8a

_mooshStateASubstate1:
_mooshStateASubstate7:
	call _companionSetAnimationToVar3f		; $7a8d
	call _mooshUpdateAsNpc		; $7a90
	ld a,(wMooshState)		; $7a93
	and $80			; $7a96
	jr z,+			; $7a98
	jr ++			; $7a9a
+
	ld e,SpecialObject.var3d		; $7a9c
	ld a,(de)		; $7a9e
	or a			; $7a9f
	ret z			; $7aa0
	ld a,$81		; $7aa1
	ld (wDisabledObjects),a		; $7aa3
	ret			; $7aa6

_mooshStateASubstate2:
	ld e,SpecialObject.invincibilityCounter		; $7aa7
	ld a,(de)		; $7aa9
	or a			; $7aaa
	ret z			; $7aab
	dec a			; $7aac
	ld (de),a		; $7aad
	ld h,d			; $7aae
	jp _updateLinkInvincibilityCounter@func_4244		; $7aaf

_mooshStateASubstate3:
	call _companionSetAnimationToVar3f		; $7ab2
	call specialObjectAnimate		; $7ab5
	call _companionDecCounter1IfNonzero		; $7ab8
	ret nz			; $7abb
	ld c,$10		; $7abc
	jp objectUpdateSpeedZ_paramC		; $7abe

_mooshStateASubstate4:
	call _companionSetAnimationToVar3f		; $7ac1
	ld c,$10		; $7ac4
	call objectUpdateSpeedZ_paramC		; $7ac6
	ret nz			; $7ac9
	ld e,SpecialObject.var3e		; $7aca
	ld a,(de)		; $7acc
	or $40			; $7acd
	ld (de),a		; $7acf
	jp specialObjectAnimate		; $7ad0

_mooshStateASubstate5:
_mooshStateASubstate6:
	call _companionSetAnimationToVar3f		; $7ad3
	call _mooshUpdateAsNpc		; $7ad6
	ld a,(wMooshState)		; $7ad9
	and $20			; $7adc
	ret z			; $7ade
	ld a,$ff		; $7adf
	ld (wStatusBarNeedsRefresh),a		; $7ae1
++
	ld e,SpecialObject.var3d		; $7ae4
	xor a			; $7ae6
	ld (de),a		; $7ae7
	call objectRemoveFromAButtonSensitiveObjectList		; $7ae8
	ld c,$01		; $7aeb
	call _companionSetAnimation		; $7aed
	jp _companionForceMount		; $7af0

_mooshStateASubstate8:
	call _companionSetAnimationToVar3f		; $7af3
	ld e,SpecialObject.var3e		; $7af6
	xor a			; $7af8
	ld (de),a		; $7af9
	ld c,$10		; $7afa
	jp objectUpdateSpeedZ_paramC		; $7afc

_mooshFunc_05_7aff:
	ld b,$40		; $7aff
	ld c,$70		; $7b01
	call objectGetRelativeAngle		; $7b03
	and $1c			; $7b06
	ld e,SpecialObject.angle		; $7b08
	ld (de),a		; $7b0a
	ret			; $7b0b

_mooshStateASubstate9:
	ld c,$10		; $7b0c
	call objectUpdateSpeedZ_paramC		; $7b0e
	call specialObjectAnimate		; $7b11
	call _companionUpdateMovement		; $7b14
	ld e,SpecialObject.xh		; $7b17
	ld a,(de)		; $7b19
	cp $38			; $7b1a
	jr c,_mooshFunc_05_7aff	; $7b1c
	ld a,$01		; $7b1e
	ld e,SpecialObject.var3e		; $7b20
	ld (de),a		; $7b22
	jp _mooshIncVar03		; $7b23

_mooshStateASubstateA:
	call _companionSetAnimationToVar3f		; $7b26
	ld e,SpecialObject.var3e		; $7b29
	ld a,(de)		; $7b2b
	and $02			; $7b2c
	ret z			; $7b2e
	ld bc,TX_220f		; $7b2f
	call showText		; $7b32
	jp _mooshIncVar03		; $7b35

_mooshStateASubstateB:
	call retIfTextIsActive		; $7b38
	call companionDismount		; $7b3b
	ld a,$18		; $7b3e
	ld (w1Link.angle),a		; $7b40
	ld (wLinkAngle),a		; $7b43
	ld a,$32		; $7b46
	ld (w1Link.speed),a		; $7b48
	ld bc,-$140		; $7b4b
	call objectSetSpeedZ		; $7b4e
	ld l,SpecialObject.angle		; $7b51
	ld (hl),$18		; $7b53
	ld l,SpecialObject.counter1		; $7b55
	ld (hl),$1e		; $7b57
	ld c,$0c		; $7b59
	call _companionSetAnimation		; $7b5b
	jp _mooshIncVar03		; $7b5e

_mooshStateASubstateC:
	call specialObjectAnimate		; $7b61
	ld e,$15		; $7b64
	ld a,(de)		; $7b66
	or a			; $7b67
	ld c,$10		; $7b68
	call nz,objectUpdateSpeedZ_paramC	; $7b6a
	ld a,(wLinkInAir)	; $7b6d
	or a			; $7b70
	ret nz			; $7b71
	call setLinkForceStateToState08		; $7b72
	ld hl,w1Link.xh		; $7b75
	ld e,SpecialObject.xh	; $7b78
	ld a,(de)		; $7b7a
	bit 7,a			; $7b7b
	jr nz,+			; $7b7d
	cp (hl)			; $7b7f
	ld a,$01		; $7b80
	jr nc,++		; $7b82
+
	ld a,DIR_LEFT		; $7b84
++
	ld l,SpecialObject.direction		; $7b86
	ld (hl),a				; $7b88
	call _companionDecCounter1IfNonzero	; $7b89
	ret nz					; $7b8c
	call _companionUpdateMovement		; $7b8d
	call objectCheckWithinScreenBoundary	; $7b90
	ret c					; $7b93
	xor a					; $7b94
	ld (wRememberedCompanionId),a		; $7b95
	ld (wMenuDisabled),a			; $7b98
	jp itemDelete				; $7b9b
.endif

;;
; Prevents Link from passing Moosh, calls animate.
; @addr{7c57}
_mooshUpdateAsNpc:
	call _companionPreventLinkFromPassing_noExtraChecks		; $7c57
	call specialObjectAnimate		; $7c5a
	jp _companionSetPriorityRelativeToLink		; $7c5d

;;
; @addr{7c60}
_mooshIncVar03:
	ld e,SpecialObject.var03		; $7c60
	ld a,(de)		; $7c62
	inc a			; $7c63
	ld (de),a		; $7c64
	ret			; $7c65


;;
; @addr{7c66}
_specialObjectCode_raft:
.ifdef ROM_AGES
	jpab bank6.specialObjectCode_raft		; $7c66
.endif
