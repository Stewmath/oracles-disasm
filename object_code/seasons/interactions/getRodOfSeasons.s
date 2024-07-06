; ==================================================================================================
; INTERAC_GET_ROD_OF_SEASONS
;
; Variables:
;   var03:    Index of a seasons' sparkle from 0 to 3
;   var3b:    Initial time for each seasons' sparkle to start dropping sparkles
;   $cceb:    Set to 1 when Rod disappears, to remove its aura, and continue cutscene
; ==================================================================================================
interactionCodee6:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionCodee6_state0
	.dw interactionCodee6_state1

interactionCodee6_state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @sparkles
	.dw @rodOfSeasons
	.dw @rodOfSeasonsAura

@subid0:
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	xor a
	ld ($cceb),a
	ld hl,mainScripts.gettingRodOfSeasonsScript
	jp interactionSetScript

@sparkles:
	ld e,Interaction.var03
	ld a,(de)
	rlca
	ld hl,@sparklesData
	rst_addDoubleIndex

	ldi a,(hl)
	ld e,Interaction.angle
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.oamFlags
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.var3b
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.speed
	ld (de),a

	ld h,d
	ld l,Interaction.counter1
	ld (hl),$3c

	ld l,Interaction.counter2
	ld (hl),$5a
	jp objectSetVisible80
@sparklesData:
	; angle - oamFlags - var3b(time to start pulsing) - speed
	.db $03 $00 $08 SPEED_180
	.db $0b $02 $0c SPEED_100
	.db $15 $03 $10 SPEED_100
	.db $1d $01 $14 SPEED_180

@rodOfSeasons:
	ld a,$04
	call objectSetCollideRadius
	ld h,d
	ld l,Interaction.zh
	ld (hl),$f0

	ld l,Interaction.counter1
	ld (hl),$00

	ld l,Interaction.counter2
	ld (hl),$30

	ldbc INTERAC_GET_ROD_OF_SEASONS 03
	call objectCreateInteraction
	ret nz

	ld l,Interaction.relatedObj1
	ldh a,(<hActiveObjectType)
	ldi (hl),a
	ldh a,(<hActiveObject)
	ld (hl),a

	jp objectSetVisible81

@rodOfSeasonsAura:
	call interactionSetAlwaysUpdateBit
	jp objectSetVisible82

interactionCodee6_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @sparkles
	.dw @rodOfSeasons
	.dw @rodOfSeasonsAura

@subid0:
	call interactionRunScript
	jp c,interactionDelete
	ret

@sparkles:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@waitToMove
	.dw @@move

@@waitToMove:
	call interactionDecCounter2
	ret nz
	call interactionIncSubstate

@@move:
	call dropSparkles
	call objectApplySpeed
	call interactionDecCounter1
	jp z,interactionDelete
	ret

@rodOfSeasons:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6

@@substate0:
	ld a,(wFrameCounter)
	and $03
	ret nz

	ld h,d
	ld l,Interaction.counter1
	inc (hl)
	ld a,(hl)
	and $0f
	ld hl,@@seasonsTable_15_705f
	rst_addAToHl
	ld a,(hl)
	add $f0
	ld e,Interaction.zh
	ld (de),a
	ld h,d
	ld l,Interaction.counter2
	dec (hl)
	ret nz

	call clearAllParentItems

	ld hl,w1Link.direction
	ld (hl),DIR_UP

	call objectGetAngleTowardLink
	ld h,d
	ld l,Interaction.angle
	ld (hl),a

	ld l,Interaction.speed
	ld (hl),SPEED_80

	ld l,Interaction.substate
	inc (hl)
	ret

@@seasonsTable_15_705f:
	.db $00 $00 $ff $ff
	.db $ff $fe $fe $fe
	.db $fe $fe $fe $ff
	.db $ff $ff $ff $00

@@substate1:
	call objectGetAngleTowardLink
	ld e,Interaction.angle
	ld (de),a
	call objectApplySpeed
	call objectCheckCollidedWithLink_ignoreZ
	ret nc

	ld e,Interaction.collisionRadiusX
	ld a,$06
	ld (de),a
	jp interactionIncSubstate

@@substate2:
	ld c,$08
	call objectUpdateSpeedZ_paramC
	jr z,+
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
+
	ld h,d
	ld l,Interaction.counter2
	ld (hl),$1e
	jp interactionIncSubstate

@@substate3:
	call interactionDecCounter2
	ret nz

	ld a,$04
	ld (wLinkForceState),a
	xor a
	ld (wcc50),a

	call interactionIncSubstate
	ld a,(w1Link.yh)
	sub $0e
	ld l,Interaction.yh
	ldi (hl),a

	inc l
	ld a,(w1Link.xh)
	sub $04
	ldi (hl),a

	; zh/speed
	inc l
	xor a
	ldi (hl),a
	ld (hl),a

	ld b,>TX_0071
	ld c,<TX_0071
	call showText

	call getThisRoomFlags
	set 5,(hl)

	ld a,MUS_ESSENCE
	call playSound

	ld c,$07
	ld a,TREASURE_ROD_OF_SEASONS
	call giveTreasure

	jp darkenRoom

@@substate4:
	call retIfTextIsActive
	call interactionIncSubstate
	ld hl,mainScripts.gettingRodOfSeasonsScript_setCounter1To32
	jp interactionSetScript

@@substate5:
	call interactionRunScript
	ret nc

	call interactionIncSubstate
	ld l,Interaction.counter2
	ld (hl),$14
	jp brightenRoom

@@substate6:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call interactionDecCounter2
	ret nz
	ld a,$01
	ld ($cceb),a
	jp interactionDelete

@rodOfSeasonsAura:
	ld a,($cceb)
	or a
	jp nz,interactionDelete

	ld a,$00
	call objectGetRelatedObject1Var
	call objectTakePosition
	call interactionAnimate
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

dropSparkles:
	ld h,d
	ld l,Interaction.var3b
	dec (hl)
	ret nz

	ld l,Interaction.var3b
	ld (hl),$10
	ldbc INTERAC_SPARKLE, $01
	jp objectCreateInteraction


forceLinksDirection:
	ld hl,w1Link.direction
	ld (hl),a
	ld a,$80
	jp setLinkForceStateToState08_withParam


spawnRodOfSeasonsSparkles:
	ld bc,@spawnCoordinates
	xor a
-
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	ret nz

	; spawn subid $01 (the sparkles for each season)
	ld (hl),INTERAC_GET_ROD_OF_SEASONS
	inc l
	ld (hl),$01
	inc l

	; var03 = 0 to 3
	ldh a,(<hFF8B)
	ld (hl),a

	; yx from table below
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a

	inc bc
	ldh a,(<hFF8B)
	inc a

	cp $04
	jr nz,-
	ret

@spawnCoordinates:
	.db $78 $18
	.db $08 $18
	.db $08 $88
	.db $78 $88
