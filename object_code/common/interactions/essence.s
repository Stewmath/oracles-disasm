; ==================================================================================================
; INTERAC_ESSENCE
; ==================================================================================================
interactionCode7f:
	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interaction7f_subid00
	.dw interaction7f_subid01
	.dw interaction7f_subid02


; Subid $00: the essence itself
interaction7f_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$04
	call objectSetCollideRadius

	; Create the pedestal
	ldbc INTERAC_ESSENCE, $01
	call objectCreateInteraction

	; Delete self if got essence
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete

	; Create the glow behind the essence
	ld hl,w1ReservedInteraction1
	ld b,$40
	call clearMemory
	ld hl,w1ReservedInteraction1
	ld (hl),$81
	inc l
	ld (hl),INTERAC_ESSENCE
	inc l
	ld (hl),$02
	call objectCopyPosition

	; [Glow.relatedObj1] = this
	ld l,Interaction.relatedObj1
	ldh a,(<hActiveObjectType)
	ldi (hl),a
	ldh a,(<hActiveObject)
	ld (hl),a

	; [this.zh] = -$10
	ld h,d
	ld l,Interaction.zh
	ld (hl),-$10

	ld a,(wDungeonIndex)
	dec a

.ifdef ROM_AGES
	; Override dungeon 6 past ($0b) with present ($05)
	cp $0b
	jr nz,+
	ld a,$05
+
.endif

	; [var03] = index of oam data?
	ld l,Interaction.var03
	ld (hl),a

	; a *= 3
	ld b,a
	add a
	add b

	ld hl,@essenceOamData
	rst_addAToHl
	ld e,Interaction.oamTileIndexBase
	ld a,(de)
	add (hl)
	inc hl
	ld (de),a

	; e = Interaction.oamFlags
	dec e
	ldi a,(hl)
	ld (de),a
	ld a,(hl)
	call interactionSetAnimation
	jp objectSetVisible81


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
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld h,d
	ld l,Interaction.counter1
	inc (hl)
	ld a,(hl)
	and $0f
	ld hl,@essenceFloatOffsets
	rst_addAToHl
	ld a,(hl)
	add $f0
	ld e,Interaction.zh
	ld (de),a

	; Check various conditions for the essence to fall
	ld a,(wLinkInAir)
	or a
	ret nz
	ld a,(wLinkGrabState)
	or a
	ret nz
	ld b,$04
	call objectCheckCenteredWithLink
	ret nc
	ld c,$14
	call objectCheckLinkWithinDistance
	ret nc
	cp $04
	ret nz

	; Link has approached, essence will fall now.

	call clearAllParentItems
	ld a,$81
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a
	ld hl,w1Link.direction
	ld (hl),DIR_UP

	; Set angle, speed
	call objectGetAngleTowardLink
	ld h,d
	ld l,Interaction.angle
	ld (hl),a
	ld l,Interaction.speed
	ld (hl),SPEED_80

	ld l,Interaction.state
	inc (hl)

	call darkenRoom

	ld a,SND_DROPESSENCE
	call playSound
	ld a,SNDCTRL_SLOW_FADEOUT
	jp playSound

@essenceFloatOffsets:
	.db $00 $00 $ff $ff $ff $fe $fe $fe
	.db $fe $fe $fe $ff $ff $ff $ff $00


; State 2: Moving toward Link
@state2:
	call objectGetAngleTowardLink
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed
	call objectCheckCollidedWithLink_ignoreZ
	ret nc

	ld e,Interaction.collisionRadiusX
	ld a,$06
	ld (de),a
	jp interactionIncState


; State 3: Falling down
@state3:
	ld c,$08
	call objectUpdateSpeedZ_paramC
	jr z,++
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
++
	ld h,d
	ld l,Interaction.counter1
	ld (hl),30
	jp interactionIncState


; State 4: After delay, begin "essence get" cutscene
@state4:
	call interactionDecCounter1
	ret nz

	; Put Link in a 2-handed item get animation
	ld a,LINK_STATE_04
	ld (wLinkForceState),a
	ld a,$01
	ld (wcc50),a

	call interactionIncState

	; Set this object's position relative to Link
	ld a,(w1Link.yh)
	sub $0e
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ldi (hl),a
	inc l

	; [this.z] = 0
	xor a
	ldi (hl),a
	ld (hl),a

	; Show essence get text
	ld l,Interaction.var03
	ld a,(hl)
	ld hl,@getEssenceTextTable
	rst_addAToHl
	ld b,>TX_0000
	ld c,(hl)
	call showText

	call getThisRoomFlags
	set ROOMFLAG_BIT_ITEM,(hl)

	; Give treasure
	ld e,Interaction.var03
	ld a,(de)
	ld c,a
	ld a,TREASURE_ESSENCE
	jp giveTreasure

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
	call retIfTextIsActive

	call interactionIncState
	ld hl,mainScripts.essenceScript_essenceGetCutscene
	jp interactionSetScript


; State 6: running script (essence get cutscene)
@state6:
	call interactionRunScript
	ret nc

	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30


; State 7: After a delay, fade out
@state7:
	call interactionDecCounter1
	ret nz

	; Warp Link outta there
	ld l,Interaction.var03
	ld a,(hl)
	add a
	ld hl,@essenceWarps
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wWarpDestGroup),a
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld (wWarpDestPos),a
	ld a,(hl)
	ld (wWarpTransition),a
	ld a,$83
	ld (wWarpTransition2),a

	xor a
	ld (wActiveMusic),a

	jp clearStaticObjects


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
	.db $80, $96, $44, TRANSITION_DEST_SET_RESPAWN
	.db $80, $8d, $24, TRANSITION_DEST_SET_RESPAWN
	.db $80, $60, $25, TRANSITION_DEST_SET_RESPAWN
	.db $80, $1d, $13, TRANSITION_DEST_SET_RESPAWN
	.db $80, $8a, $25, TRANSITION_DEST_SET_RESPAWN
	.db $80, $00, $34, TRANSITION_DEST_SET_RESPAWN
	.db $80, $d0, $34, TRANSITION_DEST_SET_RESPAWN
	.db $81, $00, $33, TRANSITION_DEST_SET_RESPAWN
.endif


;;
; Pedestal for an essence
interaction7f_subid01:
	call checkInteractionState
	jp nz,objectPreventLinkFromPassing

	; Initialization
	ld a,$01
	ld (de),a
	ld bc,$060a
	call objectSetCollideRadii

	; Set tile above this one to be solid
	call objectGetTileAtPosition
	dec h
	ld (hl),$0f

.ifdef ROM_SEASONS
	ld a,(wDungeonIndex)
	cp $06
	jr nz,+
	ld hl,$ce24
	ld (hl),$05
	inc l
	ld (hl),$0a
+
.endif

	call interactionInitGraphics
	jp objectSetVisible83


;;
; The glowing thing behind the essence
interaction7f_subid02:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible82

@state1:
	call @copyEssencePosition
	call interactionAnimate

	; Flicker visibility when animParameter is nonzero
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	ld l,Interaction.visible
	ld a,$80
	xor (hl)
	ld (hl),a
	ret

@copyEssencePosition:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	jp objectTakePosition
