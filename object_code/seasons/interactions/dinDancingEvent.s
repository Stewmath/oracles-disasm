; ==================================================================================================
; INTERAC_DIN_DANCING_EVENT
; ==================================================================================================
interactionCode4e:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	cp $0b
	jr nz,@func_754f
	call getThisRoomFlags
	and $40
	jp nz,@seasonsFunc_08_754c
	ld hl,objectData.objectData7e4e
	call parseGivenObjectData
	ld hl,$cc1d
	ld (hl),$4e
	inc hl
	ld (hl),$06
	xor a
	ld hl,$cfd0
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld a,$03
	call setMusicVolume
@seasonsFunc_08_754c:
	jp interactionDelete

@func_754f:
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	cp $05
	jr nz,+
	ld e,$66
	ld a,$06
	ld (de),a
	inc e
	ld (de),a
	jr ++
+
	ld hl,table_770a
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$42
	ld a,(de)
	cp $07
	jp nz,++
	call interactionSetAlwaysUpdateBit
	jp objectSetVisible80
++
	call objectSetVisible83
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
	.dw @@subid7
	.dw @@subid8
	.dw @@subid9
	.dw @@subidA
@@subid5:
	ld a,($cfd0)
	or a
	jr nz,+
	call interactionAnimate
	jp interactionPushLinkAwayAndUpdateDrawPriority
+
	call objectCreatePuff
	jp interactionDelete
@@subid0:
@@subid1:
@@subid2:
@@subid3:
@@subid4:
@@subid8:
@@subid9:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@func75b5
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3

@@@func75b5:
	ld a,($cfd0)
	or a
	call nz,interactionIncSubstate
@@@animate:
	call interactionAnimate
@@@runScriptPushLinkAway:
	call interactionRunScript
	jp interactionPushLinkAwayAndUpdateDrawPriority
@@@substate1:
	ld e,$42
	ld a,(de)
	ld hl,bitTable
	add l
	ld l,a
	ld b,(hl)
	ld a,($cfd1)
	and b
	jr z,+
	call interactionIncSubstate
	ld l,$46
	ld (hl),$20
	ld l,$4d
	ldd a,(hl)
	ld (hl),a
+
	ld e,$42
	ld a,(de)
	cp $05
	call z,interactionAnimate
	jp @@@runScriptPushLinkAway
@@@substate2:
	call interactionDecCounter1
	jr nz,+
	call @@func_7612
	jp interactionIncSubstate
+
	call getRandomNumber_noPreserveVars
	and $0f
	sub $08
	ld h,d
	ld l,$4c
	add (hl)
	inc l
	ld (hl),a
	jp @@@runScriptPushLinkAway
@@@substate3:
	call objectApplySpeed
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
	jp interactionDelete
@@func_7612:
	ld e,$42
	ld a,(de)
	ld hl,@@table_7622
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$49
	ld (de),a
	ldi a,(hl)
	ld e,$50
	ld (de),a
	ret

@@table_7622:
	; angle - speed
	.db $04 $78
	.db $1d $78
	.db $1e $78
	.db $05 $78
	.db $15 $78
@@subid6:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4
	.dw @@@substate5
	.dw @@@substate6
@@@substate0:
	ld a,($cfd3)
	cp $3f
	jp nz,@@subid9@func75b5
	call interactionIncSubstate
	ld hl,mainScripts.troupeScript_startDanceScene
	call interactionSetScript
@@@substate1:
	call @@subid9@func75b5
	ld a,($cfd3)
	and $40
	ret z
	call fastFadeoutToWhite
	jp interactionIncSubstate
@@@substate2:
	ld a,($c4ab)
	or a
	ret nz
	ld a,$80
	ld ($cfd3),a
	ld a,CUTSCENE_S_DIN_DANCING
	ld ($cc04),a
	ld a,$08
	call setLinkIDOverride
	ld l,$02
	ld (hl),$01
	ld l,$19
	ld (hl),d
	jp interactionIncSubstate
@@@substate3:
	ld a,($cfd0)
	or a
	ret nz
	call @@subid9@runScriptPushLinkAway
	jp interactionIncSubstate
@@@substate4:
	ld a,($cfd0)
	cp $04
	ret nz
	call interactionIncSubstate
	ld a,$0d
	jp interactionSetAnimation
@@@substate5:
	ld a,($cfd0)
	cp $07
	ret nz
	call interactionIncSubstate
	ld l,$50
	ld (hl),$0a
	ld l,$49
	ld (hl),$08
	ret
@@@substate6:
	call objectApplySpeed
	ld a,($cfd1)
	rlca
	ret nc
	ld hl,$cfd0
	ld (hl),$08
	jp interactionDelete
@@subid7:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
@@@substate0:
	call interactionRunScript
	jr nc,@@@func_76e9
	call interactionIncSubstate
	ld hl,$cfd0
	ld (hl),$04
	jr @@@func_76e9
@@@substate1:
	call @@@func_76e9
	ld hl,$cfd0
	ld a,(hl)
	cp $06
	ret nz
	call interactionIncSubstate
	ld hl,mainScripts.troupeScript_tornadoEnd
	jp interactionSetScript
@@@substate2:
	call interactionRunScript
	jp c,interactionDelete
@@@func_76e9:
	call interactionAnimate
	ld a,(wFrameCounter)
	and $3f
	ret nz
	ld a,$d3
	jp playSound
@@subidA:
	call checkInteractionSubstate
	jr nz,+
	call interactionIncSubstate
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
+
	jp @@subid9@animate

table_770a:
	.dw mainScripts.troupeScript1
	.dw mainScripts.troupeScript2
	.dw mainScripts.troupeScript3
	.dw mainScripts.troupeScript4
	.dw mainScripts.troupeScript_Impa
	.dw mainScripts.troupeScript_stub
	.dw mainScripts.troupeScript_Din
	.dw mainScripts.troupeScript_tornadoStart
	.dw mainScripts.troupeScript_stub
	.dw mainScripts.troupeScript_stub
	.dw mainScripts.troupeScript_inHoronVillage
