; ==================================================================================================
; INTERAC_DANCE_HALL_MINIGAME
; ==================================================================================================
interactionCode6a:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
@subid0:
	ld a,$01
	ld ($ccea),a
	ld b,$20
	ld hl,$cfc0
	call clearMemory
	ld hl,objectData.objectData7e6c
	call parseGivenObjectData
	jp interactionDelete
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
@@state0:
	call @@func_5c21
	ld hl,mainScripts.dancecLeaderScript_promptToStartDancing
	jp interactionSetScript
@@func_5c21:
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld l,$48
	ld (hl),$02
	inc l
	ld (hl),$10
	call interactionInitGraphics
	jp objectSetVisiblec2
@@state2:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp interactionAnimate
@@state3:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw interactionRunScript
	.dw @@@substate2
@@@substate0:
	ld a,$01
	ld (de),a
	ld ($cfda),a
	ld a,$50
	ld ($cfd3),a
	ld hl,mainScripts.danceLeaderScript_promptForTutorial
	jp interactionSetScript
@@@substate2:
	ld a,($c4ab)
	or a
	ret nz
	xor a
	ld h,d
	ld l,e
	ldd (hl),a
	inc (hl)
	ld a,$01
	call setLinkIDOverride
	jp fastFadeinFromWhite

@@func_5c6f:
	ld a,$01
	ld ($cfd2),a
	ld a,$04
	jr +++

@@func_5c78:
	ld a,$ff
	ld ($cfd2),a
	ld a,$04
	jr +++

@@func_5c81:
	ld a,$05
	jr +++
	
	ld a,$03
+++
	ld ($cfd4),a
	ld a,$09
	ld ($cfd1),a
	ld hl,$cfda
	inc (hl)
	ret

@@state4:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4
@@@substate0:
	ld a,$01
	ld (de),a
	ld a,(wNumTimesPlayedSubrosianDance)
	cp $08
	jr c,+
	ld a,$08
+
	ld ($cfd7),a
	ld ($cfdc),a
	call @@@func_5cdd
	ld a,($cfd7)
	ld hl,@@@table_5d0b
	rst_addAToHl
	call getRandomNumber
	and $03
	add (hl)
	ld ($cfd5),a
	xor a
	ld ($cfd4),a
	ld ($cfdb),a
	ld a,$cc
	call playSound
	ld e,$47
	ld a,$3c
	ld (de),a
	ld a,$22
	jp playSound
@@@func_5cdd:
	ld a,($cfd7)
	ld hl,@@@table_5ced
	rst_addDoubleIndex
	ldi a,(hl)
	ld ($cfd3),a
	ldi a,(hl)
	ld ($cfd6),a
	ret
@@@table_5ced:
	.db $28 $20
	.db $32 $1e
	.db $32 $1c
	.db $3c $1a
	.db $3c $18
	.db $46 $16
	.db $46 $14
	.db $50 $14
	.db $50 $12
	.db $5a $12
	.db $64 $10
	.db $64 $10
	.db $64 $0e
	.db $78 $0d
	.db $78 $0c
@@@table_5d0b:
	.db $09 $09 $0a
	.db $0c $0e $10
	.db $12 $14 $18
@@@substate1:
	call interactionDecCounter2
	ret nz
	ld (hl),$01
	ld a,$02
	ld (de),a
	ld hl,$cfc8
	call @func_5ec4
	ldi (hl),a
	call @func_5ec4
	ldi (hl),a
	call @func_5ec4
	ldi (hl),a
	xor a
	ld (hl),a
	ld e,$46
	ld a,($cfd6)
	ld (de),a
	call @func_5eb9
@@@substate2:
	call @func_5f1d
	ret nz
	ld a,($cfcb)
	cp $03
	jr z,+
	jp @func_5ee1
+
	call interactionIncSubstate
	ld a,($cfd6)
	ld l,$46
	ld (hl),a
	xor a
	ld ($cfcb),a
	ld ($cfd9),a
	ld a,$ff
	ld ($cfd8),a
	ld a,$02
	call interactionSetAnimation
@@@substate3:
	call @func_5e97
	jr nz,@@@func_5d91
	call @func_5f1d
	ret nz
	ld a,($cfd1)
	or a
	ret nz
	ld a,($cfcb)
	cp $03
	jr z,+
	jp @func_5eea
+
	ld a,($cfd9)
	cp $03
	jr nz,@@@func_5d91
	ld hl,$cfd5
	dec (hl)
	jr z,@@@func_5dab
	call @@func_5e77
	ld e,Interaction.substate
	ld a,$01
	ld (de),a
	xor a
	ld ($cfcb),a
	ret
@@@func_5d91:
	ld bc,TX_0104
	call showText
	ld a,$04
	ld e,Interaction.substate
	ld (de),a
	ld a,$ff
	ld ($cfd0),a
	ld a,$cc
	call playSound
	ld a,$fb
	jp playSound
@@@func_5dab:
	call interactionIncState
	inc l
	ld (hl),$00
	ld a,$01
	ld ($cfd0),a
	ld a,$fb
	call playSound
	ld bc,TX_010a
	jp showText
@@@substate4:
	call retIfTextIsActive
	ld hl,@@@warpDestVariables
	jp setWarpDestVariables
@@@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_124 $00 $14 $03
@@state5:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw interactionRunScript
	.dw @@state4@substate4
@@@substate0:
	call retIfTextIsActive
	ld e,Interaction.substate
	ld a,$01
	ld (de),a
	jp fastFadeoutToWhite
@@@substate1:
	ld a,($c4ab)
	or a
	ret nz
	xor a
	call setLinkIDOverride
	ld l,$0b
	ld (hl),$30
	ld l,$0d
	ld (hl),$48
	ld l,$08
	ld (hl),$02
	call interactionIncSubstate
	ld a,$81
	ld ($cca4),a
	ld ($cbca),a
	ld a,$1e
	call addToGashaMaturity
	jp fastFadeinFromWhite
@@@substate2:
	ld a,($c4ab)
	or a
	ret nz
	ld a,$81
	ld ($cca4),a
	ld ($cc02),a
	ld hl,wNumTimesPlayedSubrosianDance
	call incHlRefWithCap
	ld a,(hl)
	dec a
	jr z,@@@func_5e25
	cp $08
	jr z,@@@func_5e40
	cp $05
	jr nz,@@@func_5e56
	call checkIsLinkedGame
	jr nz,@@@func_5e56
	ld a,(wRickyState)
	and $20
	jr nz,@@@func_5e56
	ld hl,mainScripts.danceLeaderScript_giveFlute
	jr @@@func_5e68
@@@func_5e40:
	callab scriptHelp.seasonsFunc_15_5e20
	bit 7,b
	jr nz,+
	ld c,$00
	call giveRingToLink
	ld hl,mainScripts.danceLeaderScript_itemGiven
	jr @@@func_5e68
@@@func_5e56:
	call getRandomNumber
	cp $60
	ld hl,mainScripts.danceLeaderScript_giveOreChunks
	jr nc,@@@func_5e68
+
	ld hl,mainScripts.danceLeaderScript_gashaSeed
	jr @@@func_5e68
@@@func_5e25:
	ld hl,mainScripts.danceLeaderScript_boomerang
@@@func_5e68:
	call interactionSetScript
	ld e,Interaction.substate
	ld a,$03
	ld (de),a
	ret
@@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
@@func_5e77:
	ld hl,$cfdb
	ld a,(hl)
	cp $08
	jr c,+
	ld a,$08
+
	inc a
	ld (hl),a
	ld b,a
	and $03
	ret nz
	ld a,b
	rrca
	rrca
	and $03
	ld b,a
	ld a,($cfd7)
	add b
	ld ($cfd7),a
	jp @@state4@func_5cdd
@func_5e97:
	ld a,($cfdd)
	or a
	ret nz
	ld a,($cfd8)
	ld b,a
	inc a
	ret z
	ld a,($cfd9)
	cp $03
	ret z
	ld hl,$cfd9
	inc (hl)
	ld hl,$cfc8
	rst_addAToHl
	ld a,(hl)
	cp b
	ret nz
	ld a,$ff
	ld ($cfd8),a
	ret
@func_5eb9:
	ld a,$02
	call interactionSetAnimation
	ld bc,$fe80
	jp objectSetSpeedZ
@func_5ec4:
	call getRandomNumber
	and $0f
	ld bc,@table_5ed1
	call addAToBc
	ld a,(bc)
	ret
@table_5ed1:
	.db $00 $00 $00 $00
	.db $00 $00 $00 $00
	.db $01 $01 $01 $01
	.db $02 $02 $02 $02
@func_5ee1:
	call @func_5efd
	ld a,e
	call interactionSetAnimation
	jr +
@func_5eea:
	call @func_5efd
	ldh a,(<hFF8B)
	call @func_5f10
+
	ld hl,$cfcb
	inc (hl)
	ld e,$46
	ld a,($cfd6)
	ld (de),a
	ret
@func_5efd:
	ld a,($cfcb)
	ld hl,$cfc8
	rst_addAToHl
	ld a,(hl)
	ldh (<hFF8B),a
	ld hl,@table_5f17
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,(hl)
	jp playSound
@func_5f10:
	rst_jumpTable
	.dw @subid1@func_5c6f
	.dw @subid1@func_5c78
	.dw @subid1@func_5c81
@table_5f17:
	; sound - stored in e (unused?)
	.db SND_DANCE_MOVE,    $05
	.db SND_SEEDSHOOTER,   $06
	.db SND_GORON_DANCE_B, $04
@func_5f1d:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jr z,+
	inc a
	jr z,+
	dec a
	ld (hl),$00
	ld l,$4d
	add (hl)
	ld (hl),a
+
	ld l,$46
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret
@subid2:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
	.dw interactionAnimate
@@state0:
	call @subid1@func_5c21
	ld e,$4d
	ld a,(de)
	ld hl,@@table_5f72
	rst_addAToHl
	ld e,$72
	ld a,(hl)
	ld (de),a
	ld a,>TX_0100
	inc e
	ld (de),a
	ld h,d
	ld l,$7b
	ld (hl),$01
	ld l,$4b
	ld a,(hl)
	call setShortPosition
	ld hl,mainScripts.danceLeaderScript_showLoadedText
	jp interactionSetScript
@@table_5f72:
	.db <TX_010b, <TX_010c, <TX_010d
	.db <TX_010e, <TX_010f, <TX_0110
	.db <TX_0111, <TX_0112, <TX_0113
@@state1:
	ld a,($cfda)
	or a
	jr nz,+
	call interactionRunScript
	jp npcFaceLinkAndAnimate
+
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld a,$02
	jp interactionSetAnimation
@@state2:
	call @func_60a4
	jr c,@@func_5fb8
	call interactionAnimate
	ld a,($cfd0)
	or a
	jr nz,@@func_5fb8
	ld h,d
	ld l,$7b
	ld a,($cfda)
	cp (hl)
	ret z
	ld (hl),a
	ld a,($cfd4)
	ld l,$44
	ld (hl),a
	cp $04
	call z,@@func_5fc3
	xor a
	ld e,$78
	ld (de),a
	ret
@@func_5fb8:
	ld a,$02
	call interactionSetAnimation
	ld e,Interaction.state
	ld a,$06
	ld (de),a
	ret
@@func_5fc3:
	call objectGetShortPosition
	ld c,a
	ld hl,@@table_5ff1
-
	ldi a,(hl)
	cp c
	jr z,+
	inc hl
	jr -
+
	ld a,($cfd2)
	bit 7,a
	jr nz,+
	ld a,(hl)
	jr ++
+
	ld a,(hl)
	swap a
++
	and $0f
	ld e,$48
	ld (de),a
	ldh (<hFF8B),a
	call interactionSetAnimation
	ldh a,(<hFF8B)
	swap a
	rrca
	ld e,$49
	ld (de),a
	ret
@@table_5ff1:
	.db $11 $21
	.db $21 $20
	.db $31 $20
	.db $41 $20
	.db $51 $20
	.db $61 $10
	.db $62 $13
	.db $63 $13
	.db $64 $13
	.db $65 $13
	.db $66 $03
	.db $56 $02
	.db $46 $02
	.db $36 $02
	.db $26 $02
	.db $16 $32
	.db $15 $31
	.db $14 $31
	.db $13 $31
	.db $12 $31
@@state3:
	ld a,$02
	ld (de),a
	ld a,$02
	call interactionSetAnimation
	jr @func_6037
@@state4:
	call @func_603f
	ret c
	ld l,$44
	ld (hl),$02
	jr @func_6037
@@state5:
	ld a,$02
	ld (de),a
	ld a,$04
	call interactionSetAnimation
	jr @func_6037
@func_6037:
	ld hl,$cfd1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret
@func_603f:
	ld h,d
	ld e,$4b
	ld l,$79
	ld a,(de)
	ldi (hl),a
	ld e,$4d
	ld a,(de)
	ld (hl),a
	ld a,($cfd3)
	ld e,$50
	ld (de),a
	call objectApplySpeed
	call @func_6058
	jr @func_607e
@func_6058:
	ld h,d
	ld l,$4b
	call @func_6061
	ld h,d
	ld l,$4d
@func_6061:
	ld a,$17
	cp (hl)
	inc a
	jr nc,+
	ld a,$68
	cp (hl)
	ret nc
+
	ld (hl),a
	ld a,($cfd2)
	ld l,$48
	add (hl)
	and $03
	ldi (hl),a
	ld b,a
	swap a
	rrca
	ld (hl),a
	ld a,b
	jp interactionSetAnimation
@func_607e:
	ld e,$4b
	ld a,(de)
	ld b,a
	ld e,$79
	ld a,(de)
	sub b
	jr nc,+
	cpl
	inc a
+
	ld c,a
	ld e,$4d
	ld a,(de)
	ld b,a
	ld e,$7a
	ld a,(de)
	sub b
	jr nc,+
	cpl
	inc a
+
	add c
	ld b,a
	ld e,$78
	ld a,(de)
	add b
	ld (de),a
	cp $10
	ret c
	jp objectCenterOnTile
@func_60a4:
	call objectCheckCollidedWithLink
	ret nc
	ld a,$01
	ld ($cfdd),a
	ret
@subid3:
	ld e,Interaction.state
	ld a,(de)
	or a
	jr nz,+
	ld a,$01
	ld (de),a
	ld e,$40
	ld a,$81
	ld (de),a
	call interactionInitGraphics
+
	ld a,($cfdf)
	ld b,a
	or a
	jp z,objectSetInvisible
	call objectSetVisible80
	ld a,b
	cp $ff
	jp z,interactionDelete
	add a
	add b
	ld hl,@table_60e2
	rst_addAToHl
	ldi a,(hl)
	ld e,$4b
	ld (de),a
	ld e,$4d
	ldi a,(hl)
	ld (de),a
	ld a,(hl)
	jp interactionSetAnimation
@table_60e2:
	.db $30 $58 $07
	.db $30 $58 $07
	.db $30 $38 $08
	.db $30 $58 $09
