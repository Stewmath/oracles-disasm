; ==================================================================================================
; INTERAC_MISC_BOY_NPCS
; ==================================================================================================
interactionCode3e:
	call checkInteractionState
	jp nz,@state1
	ld a,$01
	ld (de),a
	ld h,d
	ld l,$42
	ld a,(hl)
	ld b,a
	and $0f
	ldi (hl),a
	ld a,b
	and $f0
	swap a
	ld (hl),a
	cp $03
	jr nz,@nonVar03_03
	; subid30-34
	call getSunkenCityNPCVisibleSubId@main
	ld e,$42
	ld a,(de)
	cp b
	jp nz,interactionDelete
	cp $01
	jr nz,@continue
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ld a,<ROOM_SEASONS_06e
	jr nz,+
	ld a,<ROOM_SEASONS_05e
+
	ld hl,wActiveRoom
	cp (hl)
	jp nz,interactionDelete
	jr @continue
@nonVar03_03:
	add $04
	ld b,a
	call checkHoronVillageNPCShouldBeSeen_body@main
	jp nc,interactionDelete
@continue:
	ld e,$42
	ld a,b
	ld (de),a
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@var03_00
	.dw @@var03_01
	.dw @@var03_02
	.dw @@var03_03
@@var03_00:
	call @@var03_03
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_BALL_THROWN_TO_DOG
	ld bc,$00fd
	call objectCopyPositionWithOffset
	ld l,$4b
	ld a,(hl)
	ld l,$76
	ld (hl),a
	ld l,$4d
	ld a,(hl)
	ld l,$77
	ld (hl),a
+
	jr @func_68e9
@@var03_01:
@@var03_03:
	ld h,d
	ld l,$42
	ldi a,(hl)
	push af
	ldd a,(hl)
	ld (hl),a
	call interactionInitGraphics
	pop af
	ld e,$42
	ld (de),a
	inc e
	ld a,(de)
	ld hl,table_6ac9
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionRunScript
	jp objectSetVisible82
@@var03_02:
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	jp z,interactionDelete
	call @@var03_03
	ld a,(wRoomStateModifier)
	cp SEASON_SPRING
	ret nz
	ld h,d
	ld l,$49
	ld (hl),$08
	ld l,$50
	ld (hl),$28
	ld l,$4b
	ld (hl),$62
	ld l,$4d
	ld (hl),$28
	ld a,$06
	jp interactionSetAnimation
@func_68e9:
	call getRandomNumber
	and $3f
	add $78
	ld h,d
	ld l,$76
	ld (hl),a
	ret

@state1:
	ld e,$43
	ld a,(de)
	rst_jumpTable
	.dw @@var03_00
	.dw @@var03_01
	.dw @@var03_02
	.dw @@var03_03
@@var03_00:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	call func_6abc
	jr nz,+
	ld l,$60
	ld (hl),$01
	call interactionIncSubstate
	ld hl,$cceb
	ld (hl),$01
	call interactionAnimate
+
	jp @@@runScriptPushLinkAwayUpdateDrawPriority
@@@substate1:
	ld a,($cceb)
	cp $02
	jr nz,@@@runScriptPushLinkAwayUpdateDrawPriority
	call @func_68e9
	ld l,$45
	ld (hl),$00
	ld a,$08
	call interactionSetAnimation
@@@runScriptPushLinkAwayUpdateDrawPriority:
	call interactionRunScript
	jp interactionPushLinkAwayAndUpdateDrawPriority
@@var03_01:
	ld h,d
	ld l,$42
	ld a,(hl)
	cp $02
	jr c,@@var03_03
	call checkInteractionSubstate
	jr nz,+
	call interactionIncSubstate
	xor a
	ld l,$4e
	ldi (hl),a
	ld (hl),a
	call beginJump
+
	call updateSpeedZ
@@var03_03:
	call interactionRunScript
	jp interactionAnimateAsNpc
@@var03_02:
	ld a,(wRoomStateModifier)
	cp SEASON_SPRING
	jp nz,@@var03_03
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
	.dw @@@substate7
	.dw @@@substate8
	.dw @@@substate9
	.dw @@@substateA
	.dw @@@substateB
	.dw @@@substateC
@@@substate0:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr nc,+
	ld h,d
	ld l,$77
	ld (hl),$0c
+
	call func_6ac1
	jp nz,runScriptSetPriorityRelativeToLink_withTerrainEffects
	call objectApplySpeed
	cp $4b
	jr c,+
	call interactionIncSubstate
	ld bc,$fe80
	call objectSetSpeedZ
	ld l,$50
	ld (hl),$14
	ld a,$09
	call interactionSetAnimation
+
	jp animateRunScript
@@@substate1:
	ld a,($ccc3)
	or a
	ret nz
	inc a
	ld ($ccc3),a
	call interactionIncSubstate
	jp objectSetVisiblec2
@@@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	call interactionIncSubstate
	ld l,$76
	ld (hl),$28
	call objectCenterOnTile
	ld l,$4b
	ld a,(hl)
	sub $05
	ld (hl),a
	ld a,$06
	jp interactionSetAnimation
@@@substate3:
	call func_6abc
	ret nz
	call interactionIncSubstate
	ld a,$05
	jp interactionSetAnimation
@@@substate4:
	ld e,$4f
	ld a,($ccc3)
	ld (de),a
	or a
	ret nz
	call interactionIncSubstate
	ld bc,$fd40
	call objectSetSpeedZ
	ld l,$4f
	ld (hl),$f6
	ld l,$50
	ld (hl),$28
	ld l,$49
	ld (hl),$00
	ld a,$53
	jp playSound
@@@substate5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	call interactionIncSubstate
	ld l,$76
	ld (hl),$10
	ld l,$71
	ld (hl),$00
	ret
@@@substate6:
	call func_6abc
	ret nz
	jp interactionIncSubstate
@@@substate7:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr nc,+
	ld h,d
	ld l,$77
	ld (hl),$0c
+
	call func_6ac1
	jp nz,runScriptSetPriorityRelativeToLink_withTerrainEffects
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $28
	jr nc,+
	call interactionIncSubstate
	ld l,$76
	ld (hl),$06
	ld l,$49
	ld (hl),$18
+
	jp animateRunScript
@@@substate8:
@@@substateA:
	call func_6abc
	ret nz
	ld l,$49
	ld a,(hl)
	swap a
	rlca
	add $05
	call interactionSetAnimation
	jp interactionIncSubstate
@@@substate9:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr nc,+
	ld h,d
	ld l,$77
	ld (hl),$0c
+
	call func_6ac1
	jr nz,runScriptSetPriorityRelativeToLink_withTerrainEffects
	call objectApplySpeed
	cp $18
	jr nc,+
	call interactionIncSubstate
	ld l,$76
	ld (hl),$06
	ld l,$49
	ld (hl),$10
+
	jp animateRunScript
@@@substateB:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr nc,+
	ld h,d
	ld l,$77
	ld (hl),$0c
+
	call func_6ac1
	jr nz,runScriptSetPriorityRelativeToLink_withTerrainEffects
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $62
	jr c,+
	call interactionIncSubstate
	ld l,$76
	ld (hl),$06
	ld l,$49
	ld (hl),$08
+
	jp animateRunScript
@@@substateC:
	call func_6abc
	ret nz
	ld l,$45
	ld (hl),$00
	ld a,$06
	jp interactionSetAnimation

animateRunScript:
	call interactionAnimate

runScriptSetPriorityRelativeToLink_withTerrainEffects:
	call interactionRunScript
	jp objectSetPriorityRelativeToLink_withTerrainEffects

func_6abc:
	ld h,d
	ld l,$76
	dec (hl)
	ret
	
func_6ac1:
	ld h,d
	ld l,$77
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

table_6ac9:
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02
	.dw @var03_03

@var03_00:
	.dw mainScripts.boyWithDogScript_text1
	.dw mainScripts.boyWithDogScript_text2
	.dw mainScripts.boyWithDogScript_text2
	.dw mainScripts.boyWithDogScript_text3
	.dw mainScripts.boyWithDogScript_text5
	.dw mainScripts.boyWithDogScript_text5
	.dw mainScripts.boyWithDogScript_text6
	.dw mainScripts.boyWithDogScript_text6
	.dw mainScripts.boyWithDogScript_text7
	.dw mainScripts.boyWithDogScript_text4
	.dw mainScripts.boyWithDogScript_text5

@var03_01:
	.dw mainScripts.horonVillageBoyScript_text1
	.dw mainScripts.horonVillageBoyScript_text1
	.dw mainScripts.horonVillageBoyScript_text2
	.dw mainScripts.horonVillageBoyScript_text2
	.dw mainScripts.horonVillageBoyScript_text3
	.dw mainScripts.horonVillageBoyScript_text4
	.dw mainScripts.horonVillageBoyScript_text5
	.dw mainScripts.horonVillageBoyScript_text6
	.dw mainScripts.horonVillageBoyScript_text7
	.dw mainScripts.horonVillageBoyScript_text2
	.dw mainScripts.horonVillageBoyScript_text4

@var03_02:
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text2
	.dw mainScripts.springBloomBoyScript_text1
	.dw mainScripts.springBloomBoyScript_text3

@var03_03:
	.dw mainScripts.sunkenCityBoyScript_text1
	.dw mainScripts.sunkenCityBoyScript_text2
	.dw mainScripts.sunkenCityBoyScript_text3
	.dw mainScripts.sunkenCityBoyScript_text4
	.dw mainScripts.sunkenCityBoyScript_text3
