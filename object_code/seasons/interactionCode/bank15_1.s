; ==============================================================================
; INTERACID_ERA_OR_SEASON_INFO
; ==============================================================================
interactionCodee0:
	ld e,Interaction.state		; $6f00
	ld a,(de)		; $6f02
	rst_jumpTable			; $6f03
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01		; $6f0c
	ld (de),a ; [state]

.ifdef ROM_AGES
	ld a,(wTilesetFlags)		; $6f0f
	and TILESETFLAG_PAST			; $6f12
	rlca			; $6f14
.else
	ld a,(wLoadingRoomPack)		; $4c15
	inc a			; $4c18
	jr z,+			; $4c19
	ld a,(wRoomStateModifier)		; $4c1b
+
.endif

	ld e,Interaction.subid		; $6f15
	ld (de),a		; $6f17

	call interactionInitGraphics		; $6f18
	call interactionSetAlwaysUpdateBit		; $6f1b
	ld l,Interaction.yh		; $6f1e
	ld (hl),$0a		; $6f20
	ld l,Interaction.xh		; $6f22
	ld (hl),$b0		; $6f24
	jp objectSetVisible80		; $6f26

@state1:
	ld h,d			; $6f29
	ld l,Interaction.xh		; $6f2a
	ld a,(hl)		; $6f2c
	sub $04			; $6f2d
	ld (hl),a		; $6f2f
	cp $10			; $6f30
	ret nz			; $6f32
	ld l,e			; $6f33
	inc (hl)		; $6f34
	ld l,Interaction.counter1		; $6f35
	ld (hl),40		; $6f37
	ret			; $6f39

@state2:
	call interactionDecCounter1		; $6f3a
	ret nz			; $6f3d
	ld l,e			; $6f3e
	inc (hl)		; $6f3f
	ld l,Interaction.counter1		; $6f40
	ld (hl),$06		; $6f42
	ret			; $6f44

@state3:
	ld h,d			; $6f45
	ld l,Interaction.xh		; $6f46
	ld a,(hl)		; $6f48
	sub $06			; $6f49
	ld (hl),a		; $6f4b
	ld l,Interaction.counter1		; $6f4c
	dec (hl)		; $6f4e
	ret nz			; $6f4f
	jp interactionDelete		; $6f50


; ==============================================================================
; INTERACID_STATUE_EYEBALL
; ==============================================================================
interactionCodee2:
	ld e,Interaction.subid		; $6f53
	ld a,(de)		; $6f55
	rst_jumpTable			; $6f56
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	call checkInteractionState		; $6f61
	jr z,@state0Common	; $6f64

	; State 1
	ld a,(wScrollMode)		; $6f66
	and $01			; $6f69
	ret z			; $6f6b
	call @getDirectionToFace		; $6f6c
	jp interactionSetAnimation		; $6f6f

; Used by subid 0, 2, and 4
@state0Common:
	ld a,$01		; $6f72
	ld (de),a		; $6f74
	call interactionInitGraphics		; $6f75
	jp objectSetVisible83		; $6f78

@subid2:
	call checkInteractionState		; $6f7b
	jr z,@state0Common	; $6f7e

	; State 1
	ld a,(wScrollMode)		; $6f80
	and $01			; $6f83
	ret z			; $6f85

	call @centerOnTileAndGetDirectionToFace		; $6f86

@offsetPositionTowardLookingDirection:
	ld hl,@lowPositionValues		; $6f89
	rst_addDoubleIndex			; $6f8c
	ld e,Interaction.yh		; $6f8d
	ld a,(de)		; $6f8f
	and $f0			; $6f90
	or (hl)			; $6f92
	ld (de),a		; $6f93
	inc hl			; $6f94
	ld e,Interaction.xh		; $6f95
	ld a,(de)		; $6f97
	and $f0			; $6f98
	or (hl)			; $6f9a
	ld (de),a		; $6f9b
	ret			; $6f9c

; Values for the lower 4 bits of the Y/X position, based on the direction it's facing. For subid
; 2 and 4 only (they are offset further in the direction they're looking).
@lowPositionValues:
	.db $05 $08
	.db $05 $09
	.db $06 $09
	.db $07 $09
	.db $07 $08
	.db $07 $07
	.db $06 $07
	.db $05 $07

;;
; @addr{6fad}
@centerOnTileAndGetDirectionToFace:
	call objectCenterOnTile		; $6fad

;;
; Gets the direction the angle should face, as a number from 0-7. (This isn't a standard direction
; or angle value.)
;
; @param[out]	a	Direction (0-7)
; @addr{6fb0}
@getDirectionToFace:
	call objectGetAngleTowardLink		; $6fb0
	ld b,a			; $6fb3
	and $07			; $6fb4
	jr z,@@returnValue	; $6fb6
	cp $01			; $6fb8
	jr z,@@returnValue	; $6fba
	cp $07			; $6fbc
	jr z,@@returnValue	; $6fbe
	ld a,b			; $6fc0
	and $fc			; $6fc1
	or $04			; $6fc3
	ld b,a			; $6fc5

@@returnValue:
	ld a,b			; $6fc6
	rrca			; $6fc7
	rrca			; $6fc8
	and $07			; $6fc9
	ret			; $6fcb


; Spawner for subid 2
@subid1:
	ld e,$02 ; subid

@spawnChildren:
	ld bc,wRoomLayout + LARGE_ROOM_WIDTH-1 + (LARGE_ROOM_HEIGHT-1)*16
--
	ld a,(bc)		; $6fd1
	cp TILEINDEX_EYE_STATUE			; $6fd2
	call z,@spawnChild		; $6fd4
	dec c			; $6fd7
	jr nz,--		; $6fd8
	jp interactionDelete		; $6fda

;;
; @param	c	position
; @param	e	subid
; @addr{6fdd}
@spawnChild:
	call getFreeInteractionSlot		; $6fdd
	ret nz			; $6fe0
	ld (hl),INTERACID_STATUE_EYEBALL		; $6fe1
	inc l			; $6fe3
	ld (hl),e ; [subid]
	push bc			; $6fe5
	call convertShortToLongPosition_paramC		; $6fe6
	ld l,Interaction.yh		; $6fe9
	dec b			; $6feb
	dec b			; $6fec
	ld (hl),b		; $6fed
	inc l			; $6fee
	inc l			; $6fef
	ld (hl),c		; $6ff0
	pop bc			; $6ff1
	ret			; $6ff2


; Spawner for subid 4
@subid3:
	call returnIfScrollMode01Unset		; $6ff3
	ld a,(wEyePuzzleTransitionCounter)		; $6ff6
	cp $06			; $6ff9
	ld a,$00		; $6ffb
	jr nc,++		; $6ffd

	; Choose random direction to go
--
	call getRandomNumber		; $6fff
	and $03			; $7002
	cp $02			; $7004
	jr z,--			; $7006
++
	ld (wEyePuzzleCorrectDirection),a		; $7008
	ld e,$04		; $700b
	jr @spawnChildren		; $700d


@subid4:
	ld e,Interaction.state		; $700f
	ld a,(de)		; $7011
	rst_jumpTable			; $7012
	.dw @state0Common
	.dw @@state1
	.dw objectSetVisible83

@@state1:
	call checkInteractionState2	; $7019
	jr z,@substate0	; $701c

	call interactionDecCounter1		; $701e
	jr nz,@eyeSpinning	; $7021

	; Eye is done spinning.
	call interactionIncState		; $7023
	ld a,(wEyePuzzleCorrectDirection)		; $7026
	ld b,a			; $7029

	; Abuse the frame counter to get a random direction to face? (I guess this is so that all of
	; the eyes are guaranteed to point in various different directions? But this screws up the
	; frame counter value. I don't like it.)
--
	ld hl,wFrameCounter		; $702a
	inc (hl)		; $702d
	ld a,(hl)		; $702e
	and $03			; $702f
	cp b			; $7031
	jr z,--			; $7032

	add a			; $7034
	jp @offsetPositionTowardLookingDirection		; $7035

@eyeSpinning:
	ld a,(wFrameCounter)		; $7038
	and $03			; $703b
	ret nz			; $703d
	call getRandomNumber		; $703e
	and $07			; $7041
	jp @offsetPositionTowardLookingDirection		; $7043

@substate0:
	ld a,60		; $7046
	ld (de),a ; [state2] = nonzero
	ld e,Interaction.counter1		; $7049
	ld (de),a		; $704b
	ret			; $704c


; ==============================================================================
; INTERACID_RING_HELP_BOOK
; ==============================================================================
interactionCodee5:
	ld a,(wTextIsActive)		; $704d
	or a			; $7050
	jr nz,@doneTextFlagSetup	; $7051

	ld a,$02		; $7053
	ld (wTextboxPosition),a		; $7055
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION		; $7058
	ld (wTextboxFlags),a		; $705a
@doneTextFlagSetup:

	call @runState		; $705d
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7060

@runState:
	ld e,Interaction.state		; $7063
	ld a,(de)		; $7065
	rst_jumpTable			; $7066
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics		; $706b
	ld a,>TX_3000		; $706e
	call interactionSetHighTextIndex		; $7070
	call interactionSetAlwaysUpdateBit		; $7073
	call interactionIncState		; $7076
	ld a,$06		; $7079
	call objectSetCollideRadius		; $707b

	ld e,Interaction.subid		; $707e
	ld a,(de)		; $7080
	ld hl,ringHelpBookSubid0Script		; $7081
	or a			; $7084
	jr z,++			; $7085

	ld e,Interaction.oamFlags		; $7087
	ld a,(de)		; $7089
	inc a			; $708a
	ld (de),a		; $708b
	ld hl,ringHelpBookSubid1Script		; $708c
++
	call interactionSetScript		; $708f
	ld e,Interaction.pressedAButton		; $7092
	jp objectAddToAButtonSensitiveObjectList		; $7094

@state1:
	jp interactionRunScript		; $7097


oamData_15_4da3:
	.db $1a
	.db $40 $d0 $00 $02
	.db $50 $e8 $02 $02
	.db $f8 $50 $08 $06
	.db $f8 $58 $0a $06
	.db $f8 $60 $0c $06
	.db $f8 $68 $0e $06
	.db $40 $10 $10 $07
	.db $50 $18 $12 $07
	.db $50 $28 $14 $07
	.db $50 $30 $16 $07
	.db $50 $38 $1e $00
	.db $40 $20 $18 $07
	.db $38 $28 $1a $07
	.db $28 $2b $1c $07
	.db $40 $38 $20 $07
	.db $30 $38 $22 $00
	.db $30 $30 $24 $07
	.db $10 $28 $26 $01
	.db $10 $30 $28 $01
	.db $10 $38 $2a $01
	.db $10 $40 $2c $01
	.db $00 $40 $2e $01
	.db $2b $02 $30 $02
	.db $30 $50 $32 $00
	.db $30 $58 $34 $00
	.db $1d $55 $36 $00


oamData_15_4e0c:
	.db $0a
	.db $46 $4a $88 $03
	.db $46 $52 $8a $03
	.db $49 $4c $80 $02
	.db $49 $54 $82 $02
	.db $47 $42 $84 $03
	.db $47 $4a $86 $03
	.db $39 $4e $90 $03
	.db $43 $59 $8c $03
	.db $39 $46 $8e $03
	.db $3b $3c $92 $03
