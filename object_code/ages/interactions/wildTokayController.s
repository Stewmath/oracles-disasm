; ==================================================================================================
; INTERAC_WILD_TOKAY_CONTROLLER
;
; Variables:
;   var03: Set to $ff when the game is lost?
;   var38: ?
;   var39: ?
;   var3b: ?
;   var3e/3f: Link's B/A button items, saved
; ==================================================================================================
interactionCode70:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	xor a
	ld hl,wTmpcfc0.wildTokay.cfde
	ldi (hl),a
	ld (hl),a
	call interactionIncState
	ld a,(wWildTokayGameLevel)
	ld b,a
	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	jr z,+
	ld b,$02
+
	ld a,b
	ld (wTmpcfc0.wildTokay.cfdc),a
	ld bc,@var3bValues
	call addAToBc
	ld a,(bc)
	ld e,Interaction.var3b
	ld (de),a
	jp @getRandomVar39Value

@var3bValues:
	.db $05 $05 $05 $06 $07

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; Save Link's equipped items
	ld hl,wInventoryB
	ld e,Interaction.var3e
	ldi a,(hl)
	ld (de),a
	ldd a,(hl)
	inc e
	ld (de),a

	ld (hl),ITEM_NONE
	inc l
	ld (hl),ITEM_BRACELET

	; Replace tiles to start game
	ld b,$06
	ld hl,@tilesToReplaceOnStart
@@nextTile:
	ldi a,(hl)
	ld c,(hl)
	inc hl
	push bc
	push hl
	call setTile
	pop hl
	pop bc
	dec b
	jr nz,@@nextTile

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),30

	ld hl,w1Link.yh
	ld (hl),$48
	ld l,<w1Link.xh
	ld (hl),$50
	xor a
	ld l,<w1Link.direction
	ld (hl),a

	dec a
	ld (wStatusBarNeedsRefresh),a
	ret

; b0: new tile value
; b1: tile position
@tilesToReplaceOnStart:
	.db $ef $01
	.db $ef $08
	.db $ef $71
	.db $ef $78
	.db $7a $74
	.db $7a $75

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),10
	ld a,MUS_MINIGAME
	call playSound
	jp fadeinFromWhite

@substate2:
	call interactionDecCounter1IfPaletteNotFading
	ret nz
	call interactionIncSubstate
	xor a
	ld (wDisabledObjects),a
	ld bc,TX_0a16
	jp showText


; Starting the game
@substate3:
	ld a,(wTextIsActive)
	or a
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),60
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_TOKAY_MEAT
	ld a,SND_WHISTLE
	jp playSound


; Playing the game
@substate4:
	ld a,(wTmpcfc0.wildTokay.cfde)
	or a
	jp z,@checkSpawnNextTokay

	ld hl,wDisabledObjects
	ld (hl),DISABLE_LINK
	inc a
	jr z,@@lostGame

@@wonGame:
	ld a,SND_FILLED_HEART_CONTAINER
	call playSound
	jr ++

@@lostGame:
	dec a
	ld e,Interaction.var03
	ld (de),a
	ld a,SND_ERROR
	call playSound
++
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),30
	ret


; Showing text after finishing game
@substate5:
	call interactionDecCounter1
	ret nz

	ld (hl),60
	call interactionIncSubstate

	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	ret nz

	ld h,d
	ld l,Interaction.counter1
	ld (hl),20
	ld bc,TX_0a18
	ld l,Interaction.var03
	ld a,(hl)
	add c
	ld c,a
	jp showText

@substate6:
	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	jr z,+

	call interactionDecCounter1
	ret nz
	jr ++
+
	call interactionDecCounter1IfTextNotActive
	ret nz
++
	; Restore inventory
	ld hl,wInventoryB
	ld e,Interaction.var3e
	ld a,(de)
	inc e
	ldi (hl),a
	ld a,(de)
	ld (hl),a

	call getThisRoomFlags
	set 6,(hl)
	ld a,$ff
	ld (wActiveMusic),a

	ld hl,@@pastWarpDest
	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	jr z,+
	ld hl,@@presentWarpDest
+
	jp setWarpDestVariables

@@pastWarpDest:
	m_HardcodedWarpA ROOM_AGES_2de, $00, $57, $03

@@presentWarpDest:
	m_HardcodedWarpA ROOM_AGES_2e5, $00, $57, $03


@checkSpawnNextTokay:
	call interactionDecCounter1
	ret nz

	ld (hl),60
	ld l,Interaction.var3b
	ld a,(hl)
	or a
	ret z

	ld l,Interaction.var39
	ld a,(hl)
	add a
	ld bc,@data_5898
	call addDoubleIndexToBc

	ld l,Interaction.var38
	ld a,(hl)
	cp $04
	jr z,@decVar3b

	inc (hl)
	call addAToBc
	ld a,(bc)
	or a
	ret z
	ld c,a
	ld l,Interaction.var3b
	ld a,(hl)
	dec a
	jr nz,@loadTokay

	ld l,Interaction.var39
	ld a,(hl)
	ld b,$03
	cp $01
	jr z,++
	cp $06
	jr z,++
	inc b
++
	ld l,Interaction.var38
	ld a,(hl)
	cp b
	jr nz,@loadTokay

	ld hl,wTmpcfc0.wildTokay.cfdf
	ld (hl),b

@loadTokay:
	ld b,c
	call getWildTokayObjectDataIndex
	jp parseGivenObjectData

@decVar3b:
	ld (hl),$00
	ld l,Interaction.var3b
	dec (hl)

;;
@getRandomVar39Value:
	ld hl,wTmpcfc0.wildTokay.cfdc
	ld a,(hl)
	swap a
	ld hl,@table
	rst_addAToHl
	call getRandomNumber
	and $0f
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var39
	ld (de),a
	ret


; Each row corresponds to a value for var39; each column corresponds to a value for var38?
@data_5898:
	.db $01 $00 $00 $02
	.db $02 $00 $01 $00
	.db $02 $01 $00 $01
	.db $01 $00 $02 $02
	.db $01 $01 $02 $02
	.db $02 $02 $01 $01
	.db $02 $03 $01 $00
	.db $01 $03 $02 $02

; Each row is a set of possible values for a particular value of wTmpcfc0.wildTokay.cfdc?
@table:
	.db $00 $00 $00 $01 $01 $01 $02 $02 $02 $03 $03 $03 $04 $04 $05 $05
	.db $00 $00 $01 $01 $01 $02 $02 $02 $03 $03 $03 $04 $04 $04 $05 $06
	.db $00 $01 $01 $02 $02 $03 $03 $04 $04 $04 $05 $05 $06 $06 $06 $07
	.db $01 $02 $03 $03 $04 $04 $04 $05 $05 $05 $05 $00 $00 $06 $07 $07
	.db $03 $04 $04 $04 $05 $05 $05 $05 $05 $02 $01 $00 $06 $07 $07 $07
