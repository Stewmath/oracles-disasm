; ==================================================================================================
; INTERAC_COMPANION_TUTORIAL
; ==================================================================================================
interactionCoded0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	ret

@state1:
	ld a,$02
	ld (de),a
	ld a,(w1Companion.enabled)
	or a
	jr z,@deleteIfSubid2Or5

	; Verify that the correct companion is on-screen, otherwise delete self
	ld e,Interaction.subid
	ld a,(de)
	srl a
	add SPECIALOBJECT_FIRST_COMPANION
	cp SPECIALOBJECT_LAST_COMPANION+1
	jr c,+
	ld a,SPECIALOBJECT_MOOSH
+
	ld hl,w1Companion.id
	cp (hl)
	jr nz,@delete

	; Delete self if tutorial text was already shown
	ld a,(de)
	ld hl,@flagNumbers
	rst_addAToHl
	ld a,(hl)
	ld hl,wCompanionTutorialTextShown
	call checkFlag
	jr nz,@delete

	; Check whether to dismount? (subid 2 only)
	ld a,(de)
	cp $02
	jr nz,++
	ld a,(wLinkObjectIndex)
	rra
	ld a,(de)
	jr nc,++
	ld (wForceCompanionDismount),a
++
	ld hl,@tutorialTextToShow
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,a
	ld b,(hl)
	ld a,(wLinkObjectIndex)
	bit 0,a
	call nz,showText

@deleteIfSubid2Or5:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jr z,@delete
	cp $05
	ret nz
@delete:
	jp interactionDelete

@state2:
	ld a,(w1Companion.enabled)
	or a
	ret z
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
.ifdef ROM_AGES
	.dw @setFlagAndDeleteWhenCompanionIsBelowOrRight
	.dw @setFlagAndDeleteWhenCompanionIsAbove
	.dw @setFlagAndDeleteWhenCompanionIsBelow
	.dw @setFlagAndDeleteWhenCompanionIsAboveAndLinkInXRange
	.dw @setFlagAndDeleteWhenCompanionIsLeft
	.dw @setFlagAndDeleteWhenCompanionIsBelow
.else
	.dw @setFlagAndDeleteWhenCompanionIsBelow
	.dw @setFlagAndDeleteWhenCompanionIsAbove
	.dw @goToDelete
	.dw @setFlagAndDeleteWhenCompanionIsAboveAndVar38NonZero
	.dw @setFlagAndDeleteWhenCompanionIsBelow
	.dw @goToDelete
	.dw @setFlagAndDeleteWhenCompanionIsAbove
.endif

@setFlagAndDeleteWhenCompanionIsBelow:
	ld e,Interaction.yh
	ld a,(de)
	ld hl,w1Companion.yh
	cp (hl)
	ret nc
	jr @setFlagAndDelete

@setFlagAndDeleteWhenCompanionIsAboveAndVar38NonZero:
	ld a,(w1Companion.var38)
	or a
	ret z

@setFlagAndDeleteWhenCompanionIsAbove:
	call @cpYToCompanion
	ret c

@setFlagAndDelete:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@flagNumbers
	rst_addAToHl
	ld a,(hl)
	ld hl,wCompanionTutorialTextShown
	call setFlag

@goToDelete:
	jr @delete

.ifdef ROM_AGES
@setFlagAndDeleteWhenCompanionIsAboveAndLinkInXRange:
	call @checkLinkInXRange
	ret nz
	jr @setFlagAndDeleteWhenCompanionIsAbove

@setFlagAndDeleteWhenCompanionIsLeft:
	ld e,Interaction.xh
	ld a,(de)
	ld hl,w1Companion.xh
	cp (hl)
	ret nc
	jr @setFlagAndDelete

@setFlagAndDeleteWhenCompanionIsBelowOrRight:
	call @cpYToCompanion
	jr c,@setFlagAndDelete
	ld e,Interaction.xh
	ld a,(de)
	ld hl,w1Companion.xh
	cp (hl)
	ret c
	jr @setFlagAndDelete
.endif

;;
@cpYToCompanion:
	ld e,Interaction.yh
	ld a,(de)
	ld hl,w1Companion.yh
	cp (hl)
	ret

;;
; @param[out]	zflag	z if Link is within a certain range of X-positions for certain
;			rooms?
@checkLinkInXRange:
	ld a,(wActiveRoom)
	ld hl,@rooms
	ld b,$00
--
	cp (hl)
	jr z,++
	inc b
	inc hl
	jr --
++
	ld a,b
	ld hl,@xRanges
	rst_addDoubleIndex
	ld a,(w1Link.xh)
	cp (hl)
	jr c,++
	inc hl
	cp (hl)
	jr nc,++
	xor a
	ret
++
	or d
	ret

.ifdef ROM_AGES

@rooms:
	.db <ROOM_AGES_036
	.db <ROOM_AGES_037
	.db <ROOM_AGES_027

@xRanges:
	.db $40 $70
	.db $10 $30
	.db $40 $80

@tutorialTextToShow:
	.dw TX_2008
	.dw TX_2009
	.dw TX_0000
	.dw TX_2108
	.dw TX_2207
	.dw TX_2206

@flagNumbers:
	.db $00 $01 $00 $03 $04 $00

.else; ROM_SEASONS

; These seem unused in seasons, just copies of the Ages data
@rooms:
	.db <ROOM_SEASONS_036
	.db <ROOM_SEASONS_037
	.db <ROOM_SEASONS_027

@xRanges:
	.db $40 $70
	.db $10 $30
	.db $40 $80

; Although this really is used
@tutorialTextToShow:
	.dw TX_200d
	.dw TX_200e
	.dw TX_2121
	.dw TX_2122
	.dw TX_2218
	.dw TX_2217
	.dw TX_2218

@flagNumbers:
	.db $00 $01 $02 $03 $04 $05 $04

.endif
