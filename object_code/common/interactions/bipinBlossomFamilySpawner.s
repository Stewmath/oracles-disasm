; ==================================================================================================
; INTERAC_BIPIN_BLOSSOM_FAMILY_SPAWNER
; ==================================================================================================
interactionCodeac:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	call childSetVar38ToNumEssencesObtained
	call @checkUpdateState
	call spawnBipinBlossomFamilyObjects
	ld hl,wSeedTreeRefilledBitset
.ifdef ROM_AGES
	res 1,(hl)
.else
	res 0,(hl)
.endif
	jp interactionDelete


; Check whether the player has been gone long enough for the child to proceed to the next
; stage of development (uses wSeedTreeRefilledBitset to ensure that Link's been off
; somewhere else for a while).
; Also checks that Link has enough essences for certain stages of development.
@checkUpdateState:
	ld a,(wSeedTreeRefilledBitset)
.ifdef ROM_AGES
	bit 1,a
.else
	bit 0,a
.endif
	ret z

	ld hl,wNextChildStage
	ld a,(hl)
	ld a,(hl)
	rst_jumpTable
	.dw @gotoNextState
	.dw @need2Essences
	.dw @gotoNextState_2
	.dw @need4Essences
	.dw @need6Essences
	.dw @gotoNextState_2
	.dw @gotoNextState_2
	.dw @need2Essences
	.dw @need4Essences
	.dw @need6Essences

@gotoNextState:
	ld a,(wNextChildStage)
	ld (wChildStage),a
	cp $04
	jp z,decideInitialChildPersonality
	cp $07
	jp z,decideFinalChildPersonality
	ret

@need2Essences:
	ld e,Interaction.var38
	ld a,(de)
	cp $02
	ret c
	jr @gotoNextState

@gotoNextState_2:
	jr @gotoNextState

@need4Essences:
	ld e,Interaction.var38
	ld a,(de)
	cp $04
	ret c
	jr @gotoNextState

@need6Essences:
	ld e,Interaction.var38
	ld a,(de)
	cp $06
	ret c
	jr @gotoNextState

;;
; This is called on file initialization. In a linked game, wChildStatus will be nonzero if
; he was given a name, so he will start at stage 5.
initializeChildOnGameStart:
	ld hl,wChildStatus
	ld a,(hl)
	or a
	ret z

	ld a,$05
	ld l,<wChildStage
	ldi (hl),a
	ldi (hl),a

;;
decideInitialChildPersonality:
	ld hl,initialChildPersonalityTable
	jr label_0b_006

;;
decideFinalChildPersonality:
	; a = [wChildPersonality] * 6
	ld a,(wChildPersonality)
	add a
	ld b,a
	add a
	add b

	ld hl,finalChildPersonalityTable
	rst_addAToHl
label_0b_006:
	ld a,(wChildStatus)
@label_0b_007:
	cp (hl)
	jr nc,@label_0b_008
	inc hl
	inc hl
	jr @label_0b_007
@label_0b_008:
	inc hl
	ld a,(hl)
	ld (wChildPersonality),a
	ret

initialChildPersonalityTable:
	.db $0b $00 ; status >= 11: Hyperactive
	.db $06 $01 ; status >= 6:  Shy
	.db $00 $02 ; status >= 0:  Curious

finalChildPersonalityTable:
	; Hyperactive
	.db $1a $02 ; status >= 26: Arborist
	.db $15 $01 ; status >= 21: Warrior
	.db $00 $00 ; status >= 0:  Slacker

	; Shy
	.db $13 $02 ; status >= 19: Arborist
	.db $0f $00 ; status >= 15: Slacker
	.db $00 $03 ; status >= 0:  Singer

	; Curious
	.db $0e $01 ; status >= 14: Warrior
	.db $0a $00 ; status >= 10: Slacker
	.db $00 $03 ; status >= 0:  Singer

;;
childSetVar38ToNumEssencesObtained:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,+
	xor a
+
	ld h,d
	ld l,Interaction.var38
	ld (hl),$00
@nextBit:
	add a
	jr nc,+
	inc (hl)
+
	or a
	jr nz,@nextBit
	ret

;;
; Spawn bipin, blossom, and child objects depending on the stage of the child's
; development, which part of the house this is, and the child's personality.
;
spawnBipinBlossomFamilyObjects:
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld hl,@leftHouseInteractions
	jr z,+
	ld hl,@rightHouseInteractions
+
	ld a,(wChildStage)
	cp $04
	jr c,++

	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wChildPersonality)
++
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a

@loop:
	ld a,(bc)
	or a
	ret z
	call getFreeInteractionSlot
	ret nz

	; id
	ld a,(bc)
	ldi (hl),a

	; subid
	inc bc
	ld a,(bc)
	ldi (hl),a

	; var03
	inc bc
	ld a,(bc)
	ldi (hl),a

	; yh
	inc bc
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a

	; xh
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	inc bc
	jr @loop

@leftHouseInteractions:
	.dw @leftStage0
	.dw @leftStage1
	.dw @leftStage2
	.dw @leftStage3
	.dw @@stage4
	.dw @@stage5
	.dw @@stage6
	.dw @@stage7
	.dw @@stage8
	.dw @@stage9

@@stage4:
	.dw @leftStage4_hyperactive
	.dw @leftStage4_shy
	.dw @leftStage4_curious
@@stage5:
	.dw @leftStage5_hyperactive
	.dw @leftStage5_shy
	.dw @leftStage5_curious
@@stage6:
	.dw @leftStage6_hyperactive
	.dw @leftStage6_shy
	.dw @leftStage6_curious
@@stage7:
	.dw @leftStage7_slacker
	.dw @leftStage7_warrior
	.dw @leftStage7_arborist
	.dw @leftStage7_singer
@@stage8:
	.dw @leftStage8_slacker
	.dw @leftStage8_warrior
	.dw @leftStage8_arborist
	.dw @leftStage8_singer
@@stage9:
	.dw @leftStage9_slacker
	.dw @leftStage9_warrior
	.dw @leftStage9_arborist
	.dw @leftStage9_singer

@rightHouseInteractions:
	.dw @rightStage0
	.dw @rightStage1
	.dw @rightStage2
	.dw @rightStage3
	.dw @@stage4
	.dw @@stage5
	.dw @@stage6
	.dw @@stage7
	.dw @@stage8
	.dw @@stage9

@@stage4:
	.dw @rightStage4_hyperactive
	.dw @rightStage4_shy
	.dw @rightStage4_curious
@@stage5:
	.dw @rightStage5_hyperactive
	.dw @rightStage5_shy
	.dw @rightStage5_curious
@@stage6:
	.dw @rightStage6_hyperactive
	.dw @rightStage6_shy
	.dw @rightStage6_curious
@@stage7:
	.dw @rightStage7_slacker
	.dw @rightStage7_warrior
	.dw @rightStage7_arborist
	.dw @rightStage7_singer
@@stage8:
	.dw @rightStage8_slacker
	.dw @rightStage8_warrior
	.dw @rightStage8_arborist
	.dw @rightStage8_singer
@@stage9:
	.dw @rightStage9_slacker
	.dw @rightStage9_warrior
	.dw @rightStage9_arborist
	.dw @rightStage9_singer


; Data format:
;   b0: Interaction ID to spawn (or $00 to stop loading)
;   b1: subid
;   b2: var03
;   b3: Y position
;   b4: X position

@leftStage0:
	.db INTERAC_BIPIN   $00 $00 $48 $48
	.db INTERAC_BLOSSOM $00 $00 $38 $78
@rightStage0:
	.db $00

@leftStage1:
	.db INTERAC_BLOSSOM $01 $00 $18 $48
	.db $00
@rightStage1:
	.db INTERAC_BIPIN   $01 $00 $38 $58
	.db $00

@leftStage2:
	.db INTERAC_BLOSSOM $02 $00 $18 $48
	.db INTERAC_CHILD   $07 $00 $10 $38
	.db $00
@rightStage2:
	.db INTERAC_BIPIN   $02 $00 $38 $58
	.db $00

@leftStage3:
	.db INTERAC_BLOSSOM $03 $00 $38 $78
	.db $00
@rightStage3:
	.db INTERAC_BIPIN   $03 $00 $38 $58
	.db $00

@leftStage4_hyperactive:
	.db INTERAC_BLOSSOM $04 $00 $38 $78
	.db INTERAC_CHILD   $00 $01 $38 $68
	.db $00
@leftStage4_shy:
	.db INTERAC_BLOSSOM $04 $00 $38 $78
	.db INTERAC_CHILD   $01 $02 $38 $18
	.db $00
@leftStage4_curious:
	.db INTERAC_BLOSSOM $04 $00 $38 $78
	.db INTERAC_CHILD   $02 $03 $20 $38
	.db $00

@rightStage4_hyperactive:
@rightStage4_shy:
@rightStage4_curious:
	.db INTERAC_BIPIN   $04 $00 $38 $58
	.db $00

@leftStage5_hyperactive:
	.db INTERAC_BLOSSOM $05 $00 $38 $78
	.db INTERAC_BIPIN   $05 $00 $58 $88
	.db INTERAC_CHILD   $00 $04 $38 $68
	.db $00
@leftStage5_shy:
	.db INTERAC_BLOSSOM $05 $00 $38 $78
	.db INTERAC_BIPIN   $05 $00 $58 $88
	.db INTERAC_CHILD   $01 $05 $38 $18
	.db $00
@leftStage5_curious:
	.db INTERAC_BLOSSOM $05 $00 $38 $78
	.db INTERAC_BIPIN   $05 $00 $58 $88
	.db INTERAC_CHILD   $02 $06 $20 $38
	.db $00

@rightStage5_hyperactive:
@rightStage5_shy:
@rightStage5_curious:
	.db $00

@leftStage6_hyperactive:
@leftStage6_shy:
	.db $00
@leftStage6_curious:
	.db INTERAC_CHILD   $02 $09 $20 $38
	.db $00

@rightStage6_hyperactive:
	.db INTERAC_BLOSSOM $06 $00 $22 $58
	.db INTERAC_BIPIN   $06 $00 $38 $58
	.db INTERAC_CHILD   $00 $07 $38 $48
	.db $00
@rightStage6_shy:
	.db INTERAC_BLOSSOM $06 $01 $22 $58
	.db INTERAC_BIPIN   $06 $00 $38 $58
	.db INTERAC_CHILD   $01 $08 $18 $48
	.db $00
@rightStage6_curious:
	.db INTERAC_BLOSSOM $06 $02 $22 $58
	.db INTERAC_BIPIN   $06 $00 $38 $58
	.db $00

@leftStage7_slacker:
	.db INTERAC_CHILD   $03 $0a $24 $38
	.db $00
@leftStage7_warrior:
	.db INTERAC_CHILD   $04 $0b $48 $40
	.db $00
@leftStage7_arborist:
	.db $00
@leftStage7_singer:
	.db INTERAC_BLOSSOM $07 $03 $58 $88
	.db INTERAC_CHILD   $06 $0d $38 $76
	.db $00

@rightStage7_slacker:
	.db INTERAC_BLOSSOM $07 $00 $22 $58
	.db INTERAC_BIPIN   $07 $00 $38 $58
	.db $00
@rightStage7_warrior:
	.db INTERAC_BLOSSOM $07 $01 $22 $58
	.db INTERAC_BIPIN   $07 $00 $38 $58
	.db $00
@rightStage7_arborist:
	.db INTERAC_BLOSSOM $07 $02 $48 $30
	.db INTERAC_BIPIN   $07 $00 $38 $58
	.db INTERAC_CHILD   $05 $0c $22 $58
	.db $00
@rightStage7_singer:
	.db INTERAC_BIPIN   $07 $00 $38 $58
	.db $00

@leftStage8_slacker:
	.db INTERAC_BLOSSOM $08 $00 $58 $88
	.db INTERAC_CHILD   $03 $0e $44 $78
	.db $00
@leftStage8_warrior:
	.db INTERAC_BLOSSOM $08 $01 $38 $78
	.db $00
@leftStage8_arborist:
	.db INTERAC_BLOSSOM $08 $02 $38 $78
	.db $00
@leftStage8_singer:
	.db INTERAC_CHILD   $06 $11 $14 $26
	.db $00

@rightStage8_slacker:
	.db INTERAC_BIPIN   $08 $00 $38 $58
	.db $00
@rightStage8_warrior:
	.db INTERAC_BIPIN   $08 $00 $38 $58
	.db INTERAC_CHILD   $04 $0f $18 $48
	.db $00
@rightStage8_arborist:
	.db INTERAC_BIPIN   $08 $00 $32 $58
	.db INTERAC_CHILD   $05 $10 $48 $58
	.db $00
@rightStage8_singer:
	.db INTERAC_BIPIN   $08 $00 $38 $58
	.db INTERAC_BLOSSOM $08 $03 $48 $28
	.db $00

@leftStage9_slacker:
	.db INTERAC_BLOSSOM $09 $00 $58 $88
	.db INTERAC_CHILD   $03 $12 $44 $78
	.db $00
@leftStage9_warrior:
	.db INTERAC_BLOSSOM $09 $01 $38 $78
	.db INTERAC_CHILD   $04 $13 $48 $40
	.db $00
@leftStage9_arborist:
	.db INTERAC_BLOSSOM $09 $02 $38 $78
	.db $00
@leftStage9_singer:
	.db INTERAC_BLOSSOM $09 $03 $58 $78
	.db INTERAC_CHILD   $06 $15 $36 $68
	.db $00

@rightStage9_slacker:
	.db INTERAC_BIPIN   $09 $00 $38 $58
	.db $00
@rightStage9_warrior:
	.db INTERAC_BIPIN   $09 $00 $38 $58
	.db $00
@rightStage9_arborist:
	.db INTERAC_BIPIN   $09 $00 $32 $58
	.db INTERAC_CHILD   $05 $14 $48 $58
	.db $00
@rightStage9_singer:
	.db INTERAC_BIPIN   $09 $00 $38 $58
	.db $00
