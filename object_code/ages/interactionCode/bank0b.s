m_section_free Ages_Interactions_Bank0b NAMESPACE agesInteractionsBank0b

; ==============================================================================
; INTERACID_EXPLOSION_WITH_DEBRIS
; ==============================================================================
interactionCode99:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible81
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02

@initSubid00:
	inc e
	ld a,(de) ; [var03]
	or a
	ret z

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@subid0Positions
	rst_addDoubleIndex
	call getRandomNumber
	and $07
	sub $03
	add (hl)
	ld b,a
	inc hl
	call getRandomNumber
	and $07
	sub $03
	add (hl)
	ld c,a
	jp interactionSetPosition

@initSubid02:
	ld e,Interaction.var38
	ld a,(de)
	res 6,a
	ld e,Interaction.visible
	ld (de),a

@initSubid01:
	; Determine angle based on var03 with a small random element
	call getRandomNumber_noPreserveVars
	and $03
	add $02
	ld c,a
	ld h,d
	ld l,Interaction.var03
	ld a,(hl)
	add a
	add a
	add a
	add c
	and $1f
	ld l,Interaction.angle
	ld (hl),a

	; Set speed randomly
	call getRandomNumber
	and $03
	ld bc,@subid1And2Speeds
	call addAToBc
	ld a,(bc)
	ld l,Interaction.speed
	ld (hl),a
	ld l,Interaction.speedZ
	ld (hl),<(-$180)
	inc l
	ld (hl),>(-$180)
	ret

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw @runSubid1Or2
	.dw @runSubid1Or2

@runSubid0:
	call interactionAnimate
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z
	inc a
	jp z,interactionDelete

	xor a
	ld (de),a
	ldh (<hFF8B),a
	ldh (<hFF8D),a
	ldh (<hFF8C),a

	; Spawn 4 pieces of debris
	ld b,$04
--
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXPLOSION_WITH_DEBRIS
	inc l
	inc (hl)
	inc l
	ld (hl),b
	call objectCopyPosition
	dec b
	jr nz,--
	ret

@subid1And2Speeds:
	.db SPEED_180
	.db SPEED_1c0
	.db SPEED_200
	.db SPEED_240

@runSubid1Or2:
	call objectApplySpeed
	ld c,$28
	call objectUpdateSpeedZ_paramC
	jp z,interactionDelete
	ret

; One of these positions is picked at random
@subid0Positions:
	.db $48 $48
	.db $48 $58
	.db $58 $48
	.db $58 $58


; ==============================================================================
; INTERACID_CARPENTER
;
; Variables:
;   var3f: Nonzero if the carpenter has returned to the boss
; ==============================================================================
interactionCode9a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld e,Interaction.subid
	ld a,(de)
	cp $09
	jr z,@initialize

	ld a,GLOBALFLAG_SYMMETRY_BRIDGE_BUILT
	call checkGlobalFlag
	jp nz,@delete

	; Carpenters don't appear in linked game until Zelda's saved
	call checkIsLinkedGame
	jr z,++
	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA
	call checkGlobalFlag
	jr z,@delete
++
	ld e,Interaction.subid
	ld a,(de)
	inc a
	jr z,@runSubidFF

@initialize:
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_2300
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw @initSubid09


; Checks if you leave the area without finding all the carpenters
@runSubidFF:
	ld a,(wTmpcfc0.carpenterSearch.cfd0)
	or a
	ret z
	ld a,(wScrollMode)
	and SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02
	ret nz

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jr z,++
	dec a
	ld (de),a
	ld (wDisallowMountingCompanion),a
++
	ld e,Interaction.substate
	ld a,(de)
	dec a
	jr z,@@substate1

@@substate0:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.xh
	ld a,$10
	cp (hl)
	ret c

.ifdef REGION_JP
	add $02
	ld (hl),a
.endif

	ld a,$01 ; [substate] = $01
	ld (de),a
	ld bc,TX_2307
	jp showText

@@substate1:
	call retIfTextIsActive
	ld a,(wSelectedTextOption)
	dec a
	jr z,@option0
	ld hl,wTmpcfc0.carpenterSearch.cfd0
	ld b,$10
	call clearMemory
@delete:
	jp interactionDelete

@option0:
	call resetLinkInvincibility
	ld a,-60
	ld (w1Link.invincibilityCounter),a
	ld a,$78
	ld (wDisallowMountingCompanion),a
	ld e,Interaction.var3f
	ld (de),a
	ld a,ANGLE_RIGHT
	ld (w1Link.angle),a
	ld e,Interaction.substate
	xor a
	ld (de),a
	ld a,(wLinkObjectIndex)
	ld h,a

.ifndef REGION_JP
	ld l,SpecialObject.xh
	ld (hl),$12
.endif

	rrca
	ret nc

	ld l,SpecialObject.id
	ld a,(hl)

.ifdef REGION_JP
	cp SPECIALOBJECTID_DIMITRI
	ret nz
	ld l,SpecialObject.state
	; Fall through to @@dimitri label below

.else

	ld l,SpecialObject.state
	cp SPECIALOBJECTID_RICKY
	jr nz,++

@@ricky:
	; Do something with Ricky's state?
	ldi a,(hl)
	cp $05
	ret nz
	ld a,$03
	ld (hl),a
	ret

++
	cp SPECIALOBJECTID_DIMITRI
	ret nz

.endif

@@dimitri:
	; Do something with Dimitri's state?
	ld a,(hl)
	cp $08
	ret nz
	ld (hl),$0d
	ret

@initSubid01:
	xor a
	ld e,Interaction.oamFlags
	ld (de),a
	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	jr @checkDoBridgeBuildingCutscene

@initSubid02:
@initSubid03:
@initSubid04:
	ld a,(wActiveRoom)
	cp <ROOM_AGES_025
	jr z,@@inBridgeRoom

	ld a,(de)
	swap a
	and $0f
	ld hl,wAnimalCompanion
	cp (hl)
	jr nz,@delete
	ld a,(de)
	and $0f
	ld hl,wTmpcfc0.carpenterSearch.carpentersFound
	call checkFlag
	jr nz,@delete2
	jr @checkDoBridgeBuildingCutscene

@@inBridgeRoom:
	ld a,(de)
	and $0f
	ld hl,wTmpcfc0.carpenterSearch.carpentersFound
	call checkFlag
	ld e,Interaction.var3f
	ld (de),a
	jr z,@delete2

	; Check if all 3 have been found
	ld a,(hl)
	cp $1c
	jr nz,@checkDoBridgeBuildingCutscene

	ld e,Interaction.subid
	ld a,(de)
	add $04
	ld (de),a
	jr @checkDoBridgeBuildingCutscene

@initSubid00:
	ld a,$03
	ld e,Interaction.oamFlags
	ld (de),a
	ld a,(wTmpcfc0.carpenterSearch.carpentersFound)
	cp $1c
	jr nz,@checkDoBridgeBuildingCutscene
	ld e,Interaction.subid
	ld a,$05
	ld (de),a
	ld a,$58
	ld e,Interaction.xh
	ld (de),a

@checkDoBridgeBuildingCutscene:
	ld a,GLOBALFLAG_SYMMETRY_BRIDGE_BUILT
	call checkGlobalFlag
	jr nz,@delete2

@initSubid09:
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	ld hl,@animationsForBridgeBuildCutsceneStart
	rst_addAToHl
	ld a,(hl)
	call interactionSetAnimation
	ld a,$06
	call objectSetCollideRadius
	call interactionSetAlwaysUpdateBit
	jp @loadScript


@state1:
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @runSubid
	.dw @runSubid01
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid

@runSubid:
	call interactionAnimateAsNpc
	ld c,$40
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	ret nc
@delete2:
	jp interactionDelete

@runSubid01:
	ld a,(wTmpcfc0.carpenterSearch.cfd0)
	cp $0b
	ret nz
	ld a,$3a
	ld c,$55
	call setTile
	jr @delete2

; State 2: carpender jumping away until he goes off-screen
@state2:
	call interactionAnimate
	ld h,d
	ld l,Interaction.angle
	ld (hl),ANGLE_LEFT
	ld l,Interaction.speed
	ld (hl),SPEED_100
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jr nc,@@leftScreen

	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,-$200
	call objectSetSpeedZ
	ld a,SND_JUMP
	jp playSound

@@leftScreen:
	; If that was the last carpenter, warp Link to the bridge screen
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	ld hl,wTmpcfc0.carpenterSearch.carpentersFound
	call setFlag
	ld a,(hl)
	cp $1c
	ld hl,@warpDest
	jp z,setWarpDestVariables
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	jr @delete2

@warpDest:
	m_HardcodedWarpA ROOM_AGES_025, $00, $48, $03


@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.carpenter_subid00Script
	.dw mainScripts.carpenter_subid00Script
	.dw mainScripts.carpenter_subid02Script
	.dw mainScripts.carpenter_subid03Script
	.dw mainScripts.carpenter_subid04Script
	.dw mainScripts.carpenter_subid05Script
	.dw mainScripts.carpenter_subid06Script
	.dw mainScripts.carpenter_subid07Script
	.dw mainScripts.carpenter_subid08Script
	.dw mainScripts.carpenter_subid09Script

; Animations for each subid
@animationsForBridgeBuildCutsceneStart:
	.db $04 $06 $02 $02 $02 $05 $03 $02
	.db $02 $00


; ==============================================================================
; INTERACID_RAFTWRECK_CUTSCENE
; ==============================================================================
interactionCode9b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_40,a
	jp nz,interactionDelete

	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.xh
	ld c,(hl)
	ld b,$76
	call interactionSetPosition
	call setLinkForceStateToState08
	ld (wTmpcfc0.genericCutscene.cfd0),a
	jp interactionIncState

@state1:
	call @updateSubstate
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.yh
	jp objectCopyPosition

@updateSubstate:
	ld e,Interaction.substate
	ld a,(de)
	cp $02
	call nc,interactionRunScript
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
	.dw @substate7
	.dw @substate8

@substate0:
	ld a,(wScrollMode)
	and SCROLLMODE_01
	ret z

	; Initialize Link's speed/direction to move to the center of the screen
	call interactionIncSubstate
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.xh
	ld a,(hl)
	sub $50
	ld c,DIR_LEFT
	ld b,ANGLE_LEFT
	jr nc,++
	ld c,DIR_RIGHT
	ld b,ANGLE_RIGHT
	cpl
	inc a
++
	ld l,Interaction.angle
	ld (hl),b
	ld l,Interaction.counter1
	add a
	ld (hl),a
	ld a,c
	jp setLinkDirection

@substate1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,++
	dec (hl)
	jp objectApplySpeed
++
	; Begin the script
	call interactionIncSubstate
	ld hl,mainScripts.raftwreckCutsceneScript
	jp interactionSetScript

@substate2:
	ld a,(wTmpcfc0.genericCutscene.state)
	cp $01
	ret nz

@initScreenFlashing:
	ld hl,wGenericCutscene.cbb3
	ld (hl),$00
	ld hl,wGenericCutscene.cbba
	ld (hl),$ff
	jp interactionIncSubstate

@substate3:
@substate5:
	ld hl,wGenericCutscene.cbb3
	ld b,$01
	call flashScreen
	ret z

	call interactionIncSubstate
	ldi a,(hl)
	cp $03
	ld a,$5a
	jr z,+
	ld a,$78
+
	ld (hl),a
	ld a,$f1
	ld (wPaletteThread_parameter),a
	jp darkenRoom

@substate4:
	call interactionDecCounter1
	ret nz
	jr @initScreenFlashing

@substate6:
	call interactionDecCounter1
	ret nz
	ld a,$02
	ld (wTmpcfc0.genericCutscene.state),a
	jp interactionIncSubstate

@substate7:
	ld a,(wTmpcfc0.genericCutscene.state)
	cp $03
	jr nz,++

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),20
	ret
++
	ld e,Interaction.var38
	ld a,(de)
	or a
	ret z
	jp @oscillateY

@substate8:
	call interactionDecCounter1
	ret nz
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	call getThisRoomFlags
	set ROOMFLAG_BIT_40,(hl)
	ld hl,w1Companion.enabled
	res 1,(hl)
	ld a,>w1Link
	ld (wLinkObjectIndex),a
	ld hl,@tokayWarpDest
	jp setWarpDestVariables

@tokayWarpDest:
	m_HardcodedWarpA ROOM_AGES_1aa, $00, $42, $03

@oscillateY:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,@yOscillation
	rst_addAToHl
	ld e,Interaction.yh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@yOscillation:
	.db $ff $fe $ff $00 $01 $02 $01 $00


; ==============================================================================
; INTERACID_KING_ZORA
; ==============================================================================
interactionCode9c:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2


; Present King Zora
@subid0:
	ld a,(de)
	or a
	jr z,@subid0State0

@state1:
	call interactionRunScript
	jp interactionAnimate

@subid0State0:
	ld a,GLOBALFLAG_KING_ZORA_CURED
	call checkGlobalFlag
	jp z,interactionDelete
	call @choosePresentKingZoraScript

@setScriptAndInit:
	call interactionSetScript
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld a,$0a
	call objectSetCollideRadius
	jp objectSetVisible82


; Past King Zora
@subid1:
	ld a,(de)
	or a
	jr nz,@state1

	call @choosePastKingZoraScript
	jr @setScriptAndInit


; Potion sprite
@subid2:
	ld a,(de)
	or a
	jr z,@subid2State0

@subid2State1:
	call interactionDecCounter1
	ret nz
	jp interactionDelete

@subid2State0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),$24
	jp objectSetVisible81


@choosePresentKingZoraScript:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	jr z,@@pollutionNotFixed

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	bit 6,a
	jr z,@@justCleanedWater

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld hl,mainScripts.kingZoraScript_present_afterD7
	ret z

	ld a,TREASURE_SWORD
	call checkTreasureObtained
	and $01
	ld e,Interaction.var03
	ld (de),a
	ld hl,mainScripts.kingZoraScript_present_postGame
	ret

@@pollutionNotFixed:
	ld a,TREASURE_LIBRARY_KEY
	call checkTreasureObtained
	ld hl,mainScripts.kingZoraScript_present_acceptedTask
	ret c

	call getThisRoomFlags
	bit 6,(hl)
	ld hl,mainScripts.kingZoraScript_present_firstTime
	ret z
	ld hl,mainScripts.kingZoraScript_present_giveKey
	ret

@@justCleanedWater:
	ld a,GLOBALFLAG_GOT_PERMISSION_TO_ENTER_JABU
	call checkGlobalFlag
	ld hl,mainScripts.kingZoraScript_present_justCleanedWater
	ret z
	ld hl,mainScripts.kingZoraScript_present_cleanedWater
	ret

@choosePastKingZoraScript:
	ld a,GLOBALFLAG_KING_ZORA_CURED
	call checkGlobalFlag
	jr z,@@notCured

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld hl,mainScripts.kingZoraScript_past_justCured
	ret z

	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	bit 6,a
	ld hl,mainScripts.kingZoraScript_past_cleanedWater
	ret z
	ld hl,mainScripts.kingZoraScript_past_afterD7
	ret

@@notCured:
	ld a,TREASURE_POTION
	call checkTreasureObtained
	ld hl,mainScripts.kingZoraScript_past_dontHavePotion
	ret nc
	ld hl,mainScripts.kingZoraScript_past_havePotion
	ret


; ==============================================================================
; INTERACID_TOKKEY
; ==============================================================================
interactionCode9d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call interactionInitGraphics
	ld a,>TX_2c00
	call interactionSetHighTextIndex
	ld hl,mainScripts.tokkeyScript
	call interactionSetScript
	call objectSetVisible82
	jp interactionIncState


@state1:
	; Check that Link's talked to the guy once
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 0,a
	jr z,@runScript

	ld a,(wLinkPlayingInstrument)
	cp $01
	jr nz,@runScript

	call checkLinkCollisionsEnabled
	ret nc

	ld a,(wActiveTilePos)
	cp $32
	jr z,++
	ld bc,TX_2c05
	jp showText
++
	ld a,60
	ld bc,$f810
	call objectCreateExclamationMark
	ld hl,mainScripts.tokkeyScript_justHeardTune
	call interactionSetScript
	jp interactionIncState

@runScript:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


@state2:
	call @checkCreateMusicNote
	call interactionAnimate

@state4:
	call interactionRunScript
	ld c,$20
	jp objectUpdateSpeedZ_paramC

@state3:
	call @checkCreateMusicNote
	call interactionRunScript
	call interactionAnimate
	call interactionAnimate
	ld c,$60
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,-$200
	jp objectSetSpeedZ


@checkCreateMusicNote:
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 1,a
	ret z
	ld a,(wFrameCounter)
	and $0f
	ret nz
	call getRandomNumber
	and $01
	ld bc,$f808
	jp objectCreateFloatingMusicNote


; ==============================================================================
; INTERACID_WATER_PUSHBLOCK
; ==============================================================================
interactionCode9e:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid0State0
	.dw @state1
	.dw @state2
	.dw @subid0State3
	.dw objectPreventLinkFromPassing

@subid0State0:
	call getThisRoomFlags
	and $01
	jp nz,interactionDelete

@initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,$06
	call objectSetCollideRadius

	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.counter1
	ld (hl),30

	call objectSetVisible82
	jp interactionIncState


; Check if Link is pushing against the block
@state1:
	call objectPreventLinkFromPassing
	jr nc,@@notPushing
	call objectCheckLinkPushingAgainstCenter
	jr nc,@@notPushing

	; Link is pushing against in
	ld a,$01
	ld (wForceLinkPushAnimation),a
	call interactionDecCounter1
	ret nz
	jr @@pushedLongEnough

@@notPushing:
	ld e,Interaction.counter1
	ld a,30
	ld (de),a
	ret

@@pushedLongEnough:
	ld c,$28
	call objectCheckLinkWithinDistance
	ld b,a
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld c,$02
	jr z,+
	ld c,$06
+
	ld a,b
	cp c
	ret nz
	ld e,Interaction.direction
	xor $04
	ld (de),a

	ld h,d
	ld l,Interaction.direction
	ld a,(hl)
	add a
	add a
	ld l,Interaction.angle
	ld (hl),a

	ld l,Interaction.counter1
	ld (hl),$40

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,SND_MOVEBLOCK
	call playSound
	jp interactionIncState


; Link has pushed the block; waiting for it to move to the other side
@state2:
	call objectApplySpeed
	call objectPreventLinkFromPassing
	call interactionDecCounter1
	ret nz
	ld (hl),70
	jp interactionIncState


; Pushed block from right to left
@subid0State3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid0Substate0
	.dw @subid0Substate1
	.dw @subid0Substate2
	.dw @subid0Substate3
	.dw @subid0Substate4
	.dw @subid0Substate5
	.dw @subid0Substate6
	.dw @subid0Substate7
	.dw @subid0Substate8
	.dw @subid0Substate9
	.dw @substateA
	.dw @substateB

@subid0Substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,SND_FLOODGATES
	call playSound
	ld a,$63
	call @setInterleavedHoleGroundTile
	ld a,$65
	call @setInterleavedHoleGroundTile
	jp interactionIncSubstate

@subid0Substate1:
	ldbc $63,$65
@setGroundTilesWhenCounterIsZero:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,b
	call @setGroundTile
	ld a,c
	call @setPuddleTile
	jp interactionIncSubstate

@subid0Substate2:
	ldbc $62,$66
@setHoleTilesWhenCounterIsZero:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,b
	call @setInterleavedHoleGroundTile
	ld a,c
	call @setInterleavedHoleGroundTile
	jp interactionIncSubstate

@subid0Substate3:
	ldbc $62,$66
	jr @setGroundTilesWhenCounterIsZero

@subid0Substate4:
	ldbc $61,$67
	jr @setHoleTilesWhenCounterIsZero

@subid0Substate5:
	ldbc $61,$67
	jr @setGroundTilesWhenCounterIsZero

@subid0Substate6:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$60
	call @setInterleavedPuddleHoleTile
	ld a,$68
	call @setInterleavedHoleGroundTile
	jp interactionIncSubstate

@subid0Substate7:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$60
	call @setHoleTile
	ld a,$68
	call @setPuddleTile
	jp interactionIncSubstate

@subid0Substate8:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$69
	call @setInterleavedPuddleHoleTile
	jp interactionIncSubstate

@subid0Substate9:
	call interactionDecCounter1
	ret nz
	ld (hl),90
	ld c,$69

@setWaterTileAndIncSubstate:
	ld a,TILEINDEX_WATER
	call setTile
	jp interactionIncSubstate

@substateA:
	call interactionDecCounter1
	ret nz
	ld (hl),$48
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionIncSubstate

@substateB:
	call interactionDecCounter1
	ret nz
	ld a,(wActiveMusic)
	call playSound
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call @swapRoomLayouts
	jp interactionIncState

;;
; @param	a	Position
@setHoleTile:
	ld c,a
	ld a,TILEINDEX_HOLE
	jp setTile

;;
; @param	a	Position
@setInterleavedPuddleHoleTile:
	ld hl,@@data
	jr @setInterleavedTile

@@data:
	.db $f3 $f9 $03

;;
; @param	a	Position
@setInterleavedHolePuddleTile:
	ld hl,@@data
	jr @setInterleavedTile

@@data:
	.db $f3 $f9 $01

;;
; @param	a	Position
@setGroundTile:
	push bc
	ld c,a
	ld a,$1b
	call setTile
	pop bc
	ret

;;
; @param	a	Position
@setPuddleTile:
	push bc
	ld c,a
	ld a,TILEINDEX_PUDDLE
	call setTile
	pop bc
	ret

;;
; @param	a	Position
@setInterleavedHoleGroundTile:
	ld hl,@@data
	jr @setInterleavedTile

@@data:
	.db $1b $f9 $03

@setInterleavedGroundHoleTile:
	ld hl,@@data
	jr @setInterleavedTile

@@data:
	.db $1b $f9 $01

;;
; @param	a	Position
; @param	hl	Interleaved tile data
@setInterleavedTile:
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	jp setInterleavedTile

@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid1State0
	.dw @state1
	.dw @state2
	.dw @subid1State3
	.dw objectPreventLinkFromPassing

@subid1State0:
	call getThisRoomFlags
	and $01
	jp z,interactionDelete
	jp @initialize

; Pushed block from left to right
@subid1State3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid1Substate0
	.dw @subid1Substate1
	.dw @subid1Substate2
	.dw @subid1Substate3
	.dw @subid1Substate4
	.dw @subid1Substate5
	.dw @subid1Substate6
	.dw @subid1Substate7
	.dw @subid1Substate8
	.dw @subid1Substate9
	.dw @substateA
	.dw @substateB

@subid1Substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,SND_FLOODGATES
	call playSound
	ld a,$63
	call @setInterleavedGroundHoleTile
	ld a,$65
	call @setInterleavedGroundHoleTile
	jp interactionIncSubstate

@subid1Substate1:
	ldbc $65,$63
	jp @setGroundTilesWhenCounterIsZero

@subid1Substate2:
	ldbc $66,$62
@setHoleTilesWhenCounterZero_2:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,b
	call @setInterleavedGroundHoleTile
	ld a,c
	call @setInterleavedGroundHoleTile
	jp interactionIncSubstate

@subid1Substate3:
	ldbc $66,$62
	jp @setGroundTilesWhenCounterIsZero

@subid1Substate4:
	ldbc $61,$67
	jp @setHoleTilesWhenCounterZero_2

@subid1Substate5:
	ldbc $67,$61
	jp @setGroundTilesWhenCounterIsZero

@subid1Substate6:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$60
	call @setInterleavedHolePuddleTile
	ld a,$68
	call @setInterleavedGroundHoleTile
	jp interactionIncSubstate

@subid1Substate7:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$68
	call @setGroundTile
	ld c,$60
	jp @setWaterTileAndIncSubstate

@subid1Substate8:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$69
	call @setInterleavedHolePuddleTile
	jp interactionIncSubstate

@subid1Substate9:
	call interactionDecCounter1
	ret nz
	ld (hl),$5a
	ld a,$69
	call @setHoleTile
	jp interactionIncSubstate

;;
; Swap the room layouts in all rooms affected by the flooding.
@swapRoomLayouts:
	call getThisRoomFlags
	ld l,<ROOM_AGES_140
	call @@xor
	call @@xor
	call @@xor
	ld l,<ROOM_AGES_150
	call @@xor
	call @@xor
	call @@xor
	dec h
	ld l,<ROOM_AGES_040
	call @@xor
	call @@xor
	call @@xor
	ld l,<ROOM_AGES_050
	call @@xor
	call @@xor

@@xor:
	ld a,(hl)
	xor $01
	ldi (hl),a
	ret


; ==============================================================================
; INTERACID_MOVING_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea1:
	call _sidescrollPlatform_checkLinkOnPlatform
	call @updateSubid
	jp _sidescrollingPlatformCommon

@updateSubid:
	ld e,Interaction.state
	ld a,(de)
	sub $08
	jr c,@state0To7
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw _movingPlatform_stateC

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.movingSidescrollPlatformScriptTable
.else
	ld hl,movingSidescrollPlatformScriptTable
.endif
	call objectLoadMovementScript
	call interactionInitGraphics
	ld e,Interaction.direction
	ld a,(de)
	ld hl,@collisionRadii
	rst_addDoubleIndex
	ld e,Interaction.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld e,Interaction.direction
	ld a,(de)
	call interactionSetAnimation
	jp objectSetVisible82

@collisionRadii:
	.db $09 $0f
	.db $09 $17
	.db $19 $07
	.db $19 $0f
	.db $09 $07

@state8:
	ld e,Interaction.var32
	ld a,(de)
	ld h,d
	ld l,Interaction.yh
	cp (hl)
	jr nc,+
	jp objectApplySpeed
+
	ld a,(de)
	ld (hl),a
	jp _sidescrollPlatformFunc_5bfc

@state9:
	ld e,Interaction.xh
	ld a,(de)
	ld h,d
	ld l,Interaction.var33
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_RIGHT
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jp objectApplySpeed
++
	ld a,(hl)
	ld (de),a
	jp _sidescrollPlatformFunc_5bfc

@stateA:
	ld e,Interaction.yh
	ld a,(de)
	ld h,d
	ld l,Interaction.var32
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_DOWN
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jp objectApplySpeed
++
	ld a,(hl)
	ld (de),a
	jp _sidescrollPlatformFunc_5bfc

@stateB:
	ld e,Interaction.var33
	ld a,(de)
	ld h,d
	ld l,Interaction.xh
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_LEFT
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jp objectApplySpeed
++
	ld a,(de)
	ld (hl),a
	jp _sidescrollPlatformFunc_5bfc


_movingPlatform_stateC:
	call interactionDecCounter1
	ret nz
	jp _sidescrollPlatformFunc_5bfc


; ==============================================================================
; INTERACID_MOVING_SIDESCROLL_CONVEYOR
; ==============================================================================
interactionCodea2:
	call interactionAnimate
	call _sidescrollPlatform_checkLinkOnPlatform
	call nz,_sidescrollPlatform_updateLinkKnockbackForConveyor
	call @updateState
	jp _sidescrollingPlatformCommon

@updateState:
	ld e,Interaction.state
	ld a,(de)
	sub $08
	jr c,@state0To7
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw _movingPlatform_stateC

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.movingSidescrollConveyorScriptTable
.else
	ld hl,movingSidescrollConveyorScriptTable
.endif
	call objectLoadMovementScript
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),$08
	inc l
	ld (hl),$0c
	ld e,Interaction.direction
	ld a,(de)
	call interactionSetAnimation
	jp objectSetVisible82

@state8:
	ld e,Interaction.var32
	ld a,(de)
	ld h,d
	ld l,Interaction.yh
	cp (hl)
	jr c,@applySpeed
	ld a,(de)
	ld (hl),a
	jp _sidescrollPlatformFunc_5bfc

@state9:
	ld e,Interaction.xh
	ld a,(de)
	ld h,d
	ld l,Interaction.var33
	cp (hl)
	jr c,@applySpeed
	ld a,(hl)
	ld (de),a
	jp _sidescrollPlatformFunc_5bfc

@stateA:
	ld e,Interaction.yh
	ld a,(de)
	ld h,d
	ld l,Interaction.var32
	cp (hl)
	jr nc,++
	ld l,Interaction.speed
	ld b,(hl)
	ld c,ANGLE_DOWN
	ld a,(wLinkRidingObject)
	cp d
	call z,updateLinkPositionGivenVelocity
	jr @applySpeed
++
	ld a,(hl)
	ld (de),a
	jp _sidescrollPlatformFunc_5bfc

@stateB:
	ld e,Interaction.var33
	ld a,(de)
	ld h,d
	ld l,Interaction.xh
	cp (hl)
	jr c,@applySpeed
	ld a,(de)
	ld (hl),a
	jp _sidescrollPlatformFunc_5bfc

@applySpeed:
	call objectApplySpeed
	ld a,(wLinkRidingObject)
	cp d
	ret nz

	ld e,Interaction.angle
	ld a,(de)
	rrca
	rrca
	ld b,a
	ld e,Interaction.direction
	ld a,(de)
	add b
	ld hl,@directions
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,a
	ld b,(hl)
	jp updateLinkPositionGivenVelocity

@directions:
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_100
	.db ANGLE_LEFT,  SPEED_060
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_060
	.db ANGLE_LEFT,  SPEED_100


; ==============================================================================
; INTERACID_DISAPPEARING_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea3:
	ld e,Interaction.state
	ld a,(de)
	cp $03
	jr z,++

	; Only do this if the platform isn't invisible
	call _sidescrollPlatform_checkLinkOnPlatform
	call _sidescrollingPlatformCommon
++
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@subidData
	rst_addDoubleIndex

	ld e,Interaction.state
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.counter1
	ld a,(hl)
	ld (de),a

	ld e,Interaction.collisionRadiusY
	ld a,$08
	ld (de),a
	inc e
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jp z,objectSetVisible83
	ret

@subidData:
	.db $04,  60
	.db $03, 120
	.db $01,  60

@state1:
	call _sidescrollPlatform_decCounter1
	ret nz
	ld (hl),30
	ld l,e
	inc (hl)
	xor a
	ret

@state2:
	call _sidescrollPlatform_decCounter1
	jr nz,@flickerVisibility
	ld (hl),150
	ld l,e
	inc (hl)
	jp objectSetInvisible

@flickerVisibility
	ld e,Interaction.visible
	ld a,(de)
	xor $80
	ld (de),a
	ret

@state3:
	call @state1
	ret nz
	ld a,SND_MYSTERY_SEED
	jp playSound

@state4:
	call _sidescrollPlatform_decCounter1
	jr nz,@flickerVisibility
	ld (hl),120
	ld l,e
	ld (hl),$01
	jp objectSetVisible83


; ==============================================================================
; INTERACID_CIRCULAR_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea4:
	call _sidescrollPlatform_checkLinkOnPlatform
	call @updateState
	jp _sidescrollingPlatformCommon

@updateState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.state
	inc (hl)

	ld l,Interaction.collisionRadiusY
	ld a,$08
	ldi (hl),a
	ld (hl),a

	ld l,Interaction.speed
	ld (hl),SPEED_c0
	ld l,Interaction.counter1
	ld (hl),$07

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@angles
	rst_addAToHl
	ld e,Interaction.angle
	ld a,(hl)
	ld (de),a

	ld bc,$5678
	ld a,$35
	call objectSetPositionInCircleArc

	ld e,Interaction.angle
	ld a,(de)
	add $08
	and $1f
	ld (de),a
	call @func_5a67
	jp objectSetVisible82

@angles:
	.db ANGLE_UP, ANGLE_RIGHT, ANGLE_DOWN

@state1:
	call interactionDecCounter1
	jr nz,++
	ld (hl),$0e
	ld l,Interaction.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a
++
	call objectApplySpeed

	ld e,Interaction.var34
	ld a,(de)
	or a
	jr z,@func_5a67

	ld h,d
	ld l,Interaction.var36
	ld e,Interaction.yh
	ld a,(de)
	sub (hl)
	ld b,a

	inc l
	ld e,Interaction.xh
	ld a,(de)
	sub (hl)
	ld c,a
	ld hl,w1Link.yh
	ld a,(hl)
	add b
	ldi (hl),a
	inc l
	ld a,(hl)
	add c
	ld (hl),a

@func_5a67:
	ld h,d
	ld l,Interaction.var36
	ld e,Interaction.yh
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.xh
	ld a,(de)
	ld (hl),a
	ret

;;
; Used by:
; * INTERACID_MOVING_SIDESCROLL_PLATFORM
; * INTERACID_MOVING_SIDESCROLL_CONVEYOR
; * INTERACID_DISAPPEARING_SIDESCROLL_PLATFORM
; * INTERACID_CIRCULAR_SIDESCROLL_PLATFORM
_sidescrollingPlatformCommon:
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	call objectCheckCollidedWithLink
	ret nc

	; Platform has collided with Link.

	call _sidescrollPlatform_checkLinkIsClose
	jr c,@label_0b_183
	call _sidescrollPlatform_getTileCollisionBehindLink
	jp z,_sidescrollPlatform_pushLinkAwayHorizontal

	call _sidescrollPlatform_checkLinkSquished
	ret c

	ld e,Interaction.yh
	ld a,(de)
	ld b,a
	ld a,(w1Link.yh)
	cp b
	ld c,ANGLE_UP
	jr nc,@moveLinkAtAngle
	ld c,ANGLE_DOWN
	jr @moveLinkAtAngle

@label_0b_183:
	call _sidescrollPlatformFunc_5b51
	ld a,(hl)
	or a
	jp z,_sidescrollPlatform_pushLinkAwayVertical

	call _sidescrollPlatform_checkLinkSquished
	ret c
	ld a,(wLinkRidingObject)
	cp d
	jr nz,@label_0b_184
	ldh a,(<hFF8B)
	cp $03
	jr z,@label_0b_184

	push af
	call _sidescrollPlatform_pushLinkAwayVertical
	pop af
	rrca
	jr ++

@label_0b_184:
	ld e,Interaction.xh
	ld a,(de)
	ld b,a
	ld a,(w1Link.xh)
	cp b
++
	ld c,ANGLE_RIGHT
	jr nc,@moveLinkAtAngle
	ld c,ANGLE_LEFT

;;
; @param	c	Angle
@moveLinkAtAngle:
	ld b,SPEED_80
	jp updateLinkPositionGivenVelocity

;;
; @param[out]	cflag	c if Link got squished
_sidescrollPlatform_checkLinkSquished:
	ld h,d
	ld l,Interaction.collisionRadiusY
	ld a,(hl)
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	sub (hl)
	add b
	cp c
	ret nc

	ld l,Interaction.collisionRadiusX
	ld a,(hl)
	add $02
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	sub (hl)
	add b
	cp c
	ret nc

	xor a
	ld l,Interaction.angle
	bit 3,(hl)
	jr nz,+
	inc a
+
	ld (wcc50),a
	ld a,LINK_STATE_SQUISHED
	ld (wLinkForceState),a
	scf
	ret

;;
; @param[out]	cflag	c if Link's close enough to the platform?
_sidescrollPlatform_checkLinkIsClose:
	ld a,(wLinkInAir)
	or a
	ld b,$05
	jr z,+
	dec b
+
	ld h,d
	ld l,Interaction.collisionRadiusX
	ld a,(hl)
	add b

	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	sub (hl)
	add b
	cp c
	ret nc

	ld l,Interaction.collisionRadiusY
	ld a,(hl)
	sub $02
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	sub (hl)
	add b
	cp c
	ccf
	ret

;;
; @param[out]	a	Collision value
; @param[out]	zflag	nz if a valid collision value is returned
_sidescrollPlatform_getTileCollisionBehindLink:
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	cp (hl)
	ld b,-$05
	jr c,+
	ld b,$04
+
	add b
	ld c,a
	ld a,(w1Link.yh)
	sub $04
	ld b,a
	call getTileCollisionsAtPosition
	ret nz
	ld a,b
	add $08
	ld b,a
	jp getTileCollisionsAtPosition

;;
; @param[out]	hl
_sidescrollPlatformFunc_5b51:
	ld h,d
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	cp (hl)
	ld b,-$06
	jr c,+
	ld b,$09
+
	add b
	ld b,a
	ld a,(w1Link.xh)
	sub $03
	ld c,a
	call getTileCollisionsAtPosition
	ld hl,hFF8B
	ld (hl),$00
	jr z,+
	set 1,(hl)
+
	ld a,c
	add $05
	ld c,a
	call getTileCollisionsAtPosition
	ld hl,hFF8B
	ret z
	inc (hl)
	ret

;;
; Checks if Link's on the platform, updates wLinkRidingObject if so.
;
; @param[out]	zflag	nz if Link is standing on the platform
_sidescrollPlatform_checkLinkOnPlatform:
	call objectCheckCollidedWithLink
	jr nc,@notOnPlatform

	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	ld l,Interaction.collisionRadiusY
	sub (hl)
	sub $02
	ld b,a
	ld a,(w1Link.yh)
	cp b
	jr nc,@notOnPlatform

	call _sidescrollPlatform_checkLinkIsClose
	jr nc,@notOnPlatform

	ld e,Interaction.var34
	ld a,(de)
	or a
	jr nz,@onPlatform
	ld a,$01
	ld (de),a
	call _sidescrollPlatform_updateLinkSubpixels

@onPlatform:
	ld a,d
	ld (wLinkRidingObject),a
	xor a
	ret

@notOnPlatform:
	ld e,Interaction.var34
	ld a,(de)
	or a
	ret z
	ld a,$00
	ld (de),a
	ret

;;
_sidescrollPlatform_updateLinkKnockbackForConveyor:
	ld e,Interaction.angle
	ld a,(de)
	bit 3,a
	ret z

	ld hl,w1Link.knockbackAngle
	ld e,Interaction.direction
	ld a,(de)
	swap a
	add $08
	ld (hl),a
	ld l,<w1Link.invincibilityCounter
	ld (hl),$fc
	ld l,<w1Link.knockbackCounter
	ld (hl),$0c
	ret

;;
; @param[out]	hl	counter1
_sidescrollPlatform_decCounter1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret

;;
_sidescrollPlatform_pushLinkAwayVertical:
	ld hl,w1Link.collisionRadiusY
	ld e,Interaction.collisionRadiusY
	ld a,(de)
	add (hl)
	ld b,a
	ld l,<w1Link.yh
	ld e,Interaction.yh
	jr +++

;;
_sidescrollPlatform_pushLinkAwayHorizontal:
	ld hl,w1Link.collisionRadiusX
	ld e,Interaction.collisionRadiusX
	ld a,(de)
	add (hl)
	ld b,a
	ld l,<w1Link.xh
	ld e,Interaction.xh
+++
	ld a,(de)
	cp (hl)
	jr c,++
	ld a,b
	cpl
	inc a
	ld b,a
++
	ld a,(de)
	add b
	ld (hl),a
	ret

;;
_sidescrollPlatformFunc_5bfc:
	call objectRunMovementScript
	ld a,(wLinkRidingObject)
	cp d
	ret nz

;;
_sidescrollPlatform_updateLinkSubpixels:
	ld e,Interaction.y
	ld a,(de)
	ld (w1Link.y),a
	ld e,Interaction.x
	ld a,(de)
	ld (w1Link.x),a
	ret


; ==============================================================================
; INTERACID_TOUCHING_BOOK
; ==============================================================================
interactionCodea5:
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
	.dw @state8

@state0:
	ld a,$01
	ld (wMenuDisabled),a
	ld hl,w1Link.knockbackCounter
	ld a,(hl)
	or a
	ret nz

	ld a,$01
	ld (de),a ; [state]

	call objectTakePosition
	ld bc,$3850
	call objectGetRelativeAngle
	and $1c
	ld e,Interaction.angle
	ld (de),a

	ld bc,-$100
	call objectSetSpeedZ

	ld l,Interaction.speed
	ld (hl),SPEED_100

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit

	ld a,(w1Link.visible)
	ld e,Interaction.visible
	ld (de),a

	ld a,SND_GAINHEART
	jp playSound

@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	jp interactionIncState

@state2:
	call @updateMapleAngle
	ret nz
	ld a,$ff
	ld (w1Companion.angle),a
	call interactionIncState
	call objectSetInvisible
	ld a,SND_GETSEED
	call playSound
	ld bc,TX_070e
	jp showText

@state3:
	call retIfTextIsActive
	ld hl,w1Link.xh
	ldd a,(hl)
	ld b,$f0
	cp $58
	jr nc,+
	ld b,$10
+
	add b
	ld e,Interaction.xh
	ld (de),a
	dec l
	ld a,(hl) ; [w1Link.yh]
	ld e,Interaction.yh
	ld (de),a
	xor a
	ld (w1Companion.angle),a
	jp interactionIncState

@state4:
	call @updateMapleAngle
	ret nz
	ld hl,w1Companion.angle
	ld a,$ff
	ldd (hl),a
	ld a,(hl) ; [w1Companion.direction]
	xor $02
	dec h
	ld (hl),a ; [w1Link.direction]
	call interactionIncState
	ld bc,TX_070f
	jp showText

@state5:
	call retIfTextIsActive
	ld a,(w1Companion.direction)
	xor $02
	set 7,a
	ld (w1Companion.direction),a
	call interactionIncState
	ld bc,TX_0710
	jp showText

@state6:
	call retIfTextIsActive
	ld a,(w1Companion.direction)
	res 7,a
	ld (w1Companion.direction),a
	jp interactionIncState

@state7:
	ldbc TREASURE_TRADEITEM, TRADEITEM_MAGIC_OAR
	call createTreasure
	ret nz
	ld e,Interaction.counter1
	ld a,$02
	ld (de),a
	push de
	ld de,w1Link.yh
	call objectCopyPosition_rawAddress
	pop de
	jp interactionIncState

@state8:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr z,++
	dec a
	ld (de),a
	ret
++
	call retIfTextIsActive

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a

	ld a,$02
	ld (w1Companion.substate),a
	jp interactionDelete

;;
; @param[out]	zflag	z if reached touching book
@updateMapleAngle:
	ld hl,w1Companion.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)

	ld a,(wMapleState)
	and $20
	jr z,++
	ld e,Interaction.yh
	ld a,(de)
	cp b
	jr nz,++
	ld e,Interaction.xh
	ld a,(de)
	cp c
	ret z
++
	call objectGetRelativeAngle
	xor $10
	ld (w1Companion.angle),a
	or d
	ret


; ==============================================================================
; INTERACID_MAKU_SEED
;
; Variables:
;   var38: ?
; ==============================================================================
interactionCodea6:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	ld a,PALH_ab
	call loadPaletteHeader
	call interactionInitGraphics

	ld hl,w1Link.yh
	ld b,(hl)
	ld l,<w1Link.xh
	ld c,(hl)
	call interactionSetPosition
	ld l,Interaction.zh
	ld (hl),$8b

	ld a,(wFrameCounter)
	cpl
	inc a
	ld e,Interaction.var38
	ld (de),a
	call objectSetVisible82
	call @createSparkle

@state1:
	ld h,d
	ld l,Interaction.zh
	ldd a,(hl)
	cp $f3
	jr c,++
	ld a,$01
	ld (wTmpcfc0.genericCutscene.state),a
	jp interactionDelete
++
	ld bc,$0080
	ld a,c
	add (hl) ; [zh]
	ldi (hl),a
	ld a,b
	adc (hl)
	ld (hl),a

	ld a,(wFrameCounter)
	ld l,Interaction.var38
	add (hl)
	and $3f
	ld a,SND_MAGIC_POWDER
	call z,playSound
	ret

;;
; Unused function?
@func_5d87:
	ldbc INTERACID_SPARKLE,$0b
	call objectCreateInteraction
	ret nz
	ld l,Interaction.counter1
	ld (hl),$c2
	call objectCopyPosition

	call getRandomNumber
	and $07
	add a
	ld bc,@offsets
	call addAToBc
	ld a,(bc)
	ld l,Interaction.yh
	add (hl)
	ld (hl),a
	inc bc
	ld a,(bc)
	ld l,Interaction.xh
	add (hl)
	ld (hl),a
	ret

@offsets:
	.db $10 $02
	.db $10 $fe
	.db $08 $05
	.db $08 $fb
	.db $0c $08
	.db $0c $f8
	.db $06 $0b
	.db $06 $f5

;;
@createSparkle:
	ldbc INTERACID_SPARKLE,$0f
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d
	ret


; ==============================================================================
; INTERACID_ENDGAME_CUTSCENE_BIPSOM_FAMILY
; ==============================================================================
interactionCodea7:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics
	call objectSetVisible82

	ld e,Interaction.subid
	ld a,(de)
	cp $02
	ret nz

	ld a,(wChildStage)
	cp $04
	ret c

	ld a,$04
	call interactionSetAnimation
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_CHILD
	inc l
	ld a,(wChildStage)
	ld b,$00
	cp $07
	jr c,+
	ld b,$03
+
	ld a,(wChildPersonality)
	add b
	ldi (hl),a ; [child.subid]
	add $16
	ld (hl),a
	ld l,Interaction.yh
	ld (hl),$38
	inc l
	inc l
	ld (hl),$28
	ret

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wTmpcfc0.genericCutscene.state)
	or a
	jr z,++
	call interactionIncSubstate
	ld bc,-$100
	call objectSetSpeedZ
++
	jp interactionAnimate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),10
	ret

@substate2:
	call interactionDecCounter1
	ret nz
	ld a,$03
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_a8
; ==============================================================================
interactionCodea8:
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
@subid1:
@subid2:
@subid3:
	ld a,(de)
	and $0f
	add SPECIALOBJECTID_RICKY_CUTSCENE
	ld b,a
	ld a,(de)
	swap a
	and $0f
	ld hl,w1Companion.enabled
	ld (hl),$01
	inc l
	ld (hl),b ; [w1Companion.id]
	inc l
	ld (hl),a ; [w1Companion.subid]
	call objectCopyPosition
	jp interactionDelete

@subid4:
	ld hl,w1Link.enabled
	ld (hl),$03
	call objectCopyPosition
	call @handleSubidHighNibble
	jp interactionDelete

@handleSubidHighNibble:
	ld e,Interaction.subid
	ld a,(de)
	swap a
	and $0f
	ld b,a
	rst_jumpTable
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4
	.dw @thing5
	.dw @thing6

@thing2:
@thing3:
@thing4:
	ld a,b

@initLinkInCutscene:
	ld hl,w1Link.id
	ld (hl),SPECIALOBJECTID_LINK_CUTSCENE
	inc l
	ld (hl),a
	ret

@thing5:
	ld a,d
	ld (wLinkObjectIndex),a
	ld hl,wActiveRing
	ld (hl),FIST_RING
	xor a
	ld l,<wInventoryB
	ldi (hl),a
	ld (hl),a

	ld hl,@simulatedInput_5eea
	ld a,:@simulatedInput_5eea

@beginSimulatedInput:
	push de
	call setSimulatedInputAddress
	pop de
	xor a
	ld (wDisabledObjects),a
	ld hl,w1Link.id
	ld (hl),SPECIALOBJECTID_LINK
	ret

@thing6:
	ld a,$09
	jp @initLinkInCutscene

@thing1:
	ld a,$0a
	jp @initLinkInCutscene

@thing0:
	ld hl,w1Link.direction
	ld (hl),DIR_DOWN
	ld a,h
	ld (wLinkObjectIndex),a
	ld hl,wInventoryB
	ld (hl),ITEMID_SWORD
	inc l
	ld (hl),$00 ; [wInventoryA]
	ld hl,@linkSwordDemonstrationInput
	ld a,:@linkSwordDemonstrationInput
	jr @beginSimulatedInput


; Seasons-only (address $5edf)
@unusedInputData:
	dwb 60 $00
	dwb 32 BTN_DOWN
	dwb 48 $00
	.dw $ffff


@simulatedInput_5eea:
	dwb 124 $00
	dwb 1   BTN_LEFT
	dwb 46  $00
	dwb 1   BTN_DOWN
	dwb 46  $00
	dwb 1   BTN_RIGHT
	dwb 46  $00
	dwb 1   BTN_UP
	dwb 46  $00
	dwb 1   BTN_LEFT
	dwb 46  $00
	dwb 1   BTN_DOWN
	dwb 104 $00
	dwb 1   BTN_UP
	dwb 56  $00
	dwb 1   BTN_RIGHT
	dwb 464 $00
	dwb 1   BTN_LEFT
	dwb 160 $00
	dwb 1   BTN_A
	dwb 48  $00
	.dw $ffff

; Demonstrating sword to Ralph in credits
@linkSwordDemonstrationInput:
	dwb 60  $00
	dwb 1   BTN_LEFT
	dwb 58  BTN_B
	dwb 60  $00
	dwb 1   BTN_RIGHT|BTN_B
	dwb 20  $00
	dwb 1   BTN_DOWN
	dwb 120 BTN_B
	dwb 50  $00
	dwb 1   BTN_RIGHT
	dwb 30  $00
	.dw $ffff


; ==============================================================================
; INTERACID_TWINROVA_FLAME
; ==============================================================================
.ifdef ROM_AGES
interactionCodea9:
.else
interactionCodeb0:
.endif
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionAnimate
	.dw @state2

@state0:
	ld a,$01
	ld (de),a ; [state]

	ld e,Interaction.subid
	ld a,(de)
.ifdef ROM_AGES
	cp $06
.else
	cp $0b
.endif
	call nc,interactionIncState

.ifdef ROM_SEASONS
	or a
	jr nz,+
	ld a,$b0
	ld (wInteractionIDToLoadExtraGfx),a
	ld (wLoadedTreeGfxIndex),a
+
.endif

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.subid
	ld a,(hl)
	ld b,a
.ifdef ROM_AGES
	cp $03
.else
	cp $08
.endif
	jr c,++
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete

	ld a,(de) ; [subid]
.ifdef ROM_AGES
++
	and $03
.else
	sub $05
++
.endif
	add a
	add a
	add a
	ld l,Interaction.animCounter ; BUG(?): Won't point to the object after "getThisRoomFlags" call?
	add (hl)
	ld (hl),a
	ld a,b
	ld hl,@positions
	rst_addDoubleIndex
	ldi a,(hl)
.ifdef ROM_AGES
	ld c,(hl)
	ld b,a
	call interactionSetPosition
.else
	ld e,Interaction.yh
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
.endif
	jp objectSetVisiblec2

@positions:
.ifdef ROM_SEASONS
	.db $32 $78
	.db $50 $80
	.db $50 $70
.endif

	.db $40 $a8
	.db $40 $48
	.db $10 $78

.ifdef ROM_SEASONS
	.db $48 $30
	.db $48 $70
.endif

	.db $50 $a8
	.db $50 $48
	.db $20 $78

	.db $50 $a8
	.db $50 $48
	.db $20 $78

@state2:
	call interactionAnimate
	ld a,(wFrameCounter)
	rrca
	jp c,objectSetVisible
	jp objectSetInvisible


; ==============================================================================
; INTERACID_DIN
; ==============================================================================
interactionCodeaa:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics
	call objectSetVisible82
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2

@initSubid0:
@initSubid1:
	ret

@initSubid2:
	call interactionSetAlwaysUpdateBit
	ld bc,$4830
	jp interactionSetPosition


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid0
	.dw interactionAnimate
	.dw interactionAnimate

@runSubid0:
	call @runSubid0Substates
	ld e,Interaction.zh
	ld a,(de)
	or a
	jp nz,objectSetVisiblec2
	jp objectSetVisible82

@runSubid0Substates:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw interactionAnimate

@substate0:
	call interactionAnimate
	ld a,(wTmpcfc0.genericCutscene.state)
	cp $04
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),120
	ld a,$05
	call interactionSetAnimation
	jp @beginJump

@substate1:
	call interactionDecCounter1
	jp nz,@updateSpeedZ
	call interactionIncSubstate
	xor a
	ld l,Interaction.zh
	ld (hl),a
	ld l,Interaction.counter1
	ld (hl),30
	jp interactionAnimate

@substate2:
	call interactionDecCounter1
	jr nz,++
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),60
	ld bc,TX_3d09
	call showText
++
	jp interactionAnimate

@substate3:
	call interactionDecCounter1IfTextNotActive
	jr nz,++
	call interactionIncSubstate
	ld hl,wTmpcfc0.genericCutscene.state
	ld (hl),$05
++
	jp interactionAnimate


; Scripts unused?
@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.dinScript


@updateSpeedZ:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

@beginJump:
	ld bc,-$100
	jp objectSetSpeedZ


; ==============================================================================
; INTERACID_ZORA
;
; Variables:
;   var03: ?
;   var38: ?
; ==============================================================================
interactionCodeab:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw _zora_subid00
	.dw _zora_subid01
	.dw _zora_subid02
	.dw _zora_subid03
	.dw _zora_subid04
	.dw _zora_subid05
	.dw _zora_subid06
	.dw _zora_subid07
	.dw _zora_subid08
	.dw _zora_subid09
	.dw _zora_subid0A
	.dw _zora_subid0B
	.dw _zora_subid0C
	.dw _zora_subid0D
	.dw _zora_subid0E
	.dw _zora_subid0F
	.dw _zora_subid10
	.dw _zora_subid11
	.dw _zora_subid12
	.dw _zora_subid13
	.dw _zora_subid14
	.dw _zora_subid15
	.dw _zora_subid16
	.dw _zora_subid17
	.dw _zora_subid18
	.dw _zora_subid19
	.dw _zora_subid1A
	.dw _zora_subid1B


_zora_subid00:
_zora_subid01:
_zora_subid02:
_zora_subid03:
_zora_subid04:
_zora_subid05:
_zora_subid06:
_zora_subid07:
_zora_subid08:
_zora_subid09:
_zora_subid0F:
	call checkInteractionState
	jr z,@state0

@state1:
	call _zora_getWorldState
	ld e,Interaction.subid
	ld a,(de)
	add a
	add a
	add b
	ld hl,_zora_textIndices
	rst_addAToHl
	ld e,Interaction.textID
	ld a,(hl)
	ld (de),a
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@state0:
	call _zora_getWorldState
	ld a,b
	or a
	ld e,Interaction.subid
	ld a,(de)
	jr nz,++
	cp $06
	jp nc,interactionDelete
++
	ld hl,mainScripts.genericNpcScript

_zora_commonInitWithScript:
	call interactionSetScript

_zora_commonInit:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld l,Interaction.textID+1
	ld (hl),>TX_3400
	jp objectSetVisiblec2


_zora_subid0C:
_zora_subid0D:
	call checkInteractionState
	jr z,@state0

@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
	jr nc,++
	ld hl,wTmpcfc0.genericCutscene.state
	set 7,(hl)
++
	jp interactionAnimate

@state0:
	ld e,Interaction.speed
	ld a,SPEED_180
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	cp $0c
	ld hl,mainScripts.zoraSubid0cScript
	jr z,_zora_commonInitWithScript
	ld hl,mainScripts.zoraSubid0dScript
	jr _zora_commonInitWithScript


_zora_subid0A:
_zora_subid0B:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call _zora_commonInit
	ld l,Interaction.counter1
	ld (hl),30
	ld l,Interaction.subid
	ldi a,(hl)
	sub $0a
	swap a
	rrca
	ld (hl),a ; [var03]
	ret

@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),120 ; [counter1]
	inc l
	inc (hl) ; [counter2]
	jp interactionIncState

@state2:
	call interactionDecCounter1
	jr nz,++
	ld (hl),90
	ld a,$02
	call interactionSetAnimation
	jp interactionIncState
++
	inc l
	dec (hl) ; [counter2]
	ret nz

	ld (hl),20

	ld l,Interaction.var38
	ld a,(hl)
	inc a
	and $07
	ld (hl),a

	ld l,Interaction.var03
	add (hl)
	ld hl,@animationTable
	rst_addAToHl
	ld a,(hl)
	jp interactionSetAnimation

@animationTable:
	.db $00 $03 $01 $02 $00 $01 $03 $02
	.db $03 $01 $03 $00 $03 $02 $00 $01

@state3:
	call interactionDecCounter1
	jr nz,++
	ld hl,wTmpcfc0.genericCutscene.state
	set 7,(hl)
++
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,Interaction.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)
	ret


_zora_subid10:
_zora_subid11:
_zora_subid12:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call objectSetVisible82
	call interactionIncState

	ld e,Interaction.subid
	ld a,(de)
	sub $10
	ld b,a
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld a,b
	rst_jumpTable
	.dw @subid10
	.dw @subid11
	.dw @subid12

@subid10:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ld a,(wEssencesObtained)
	bit 6,a
	jp z,interactionDelete
	ld a,$03
	call interactionSetAnimation
	jp interactionIncState

@subid11:
	call checkIsLinkedGame
	jp nz,interactionDelete
	jr @deleteIfFlagSet

@subid12:
	call checkIsLinkedGame
	jp z,interactionDelete

@deleteIfFlagSet:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	ret

@scriptTable:
	.dw mainScripts.zoraSubid10Script
	.dw mainScripts.zoraSubid11And12Script
	.dw mainScripts.zoraSubid11And12Script

@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

@state2:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimate


_zora_subid0E:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.textID+1
	ld (hl),>TX_3400
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld a,<TX_3433
	jr z,+
	ld a,<TX_3434
+
	ld e,Interaction.textID
	ld (de),a
	xor a
	call interactionSetAnimation
	call objectSetVisiblec2
	ld hl,mainScripts.zoraSubid0eScript
	jp interactionSetScript


_zora_subid13:
_zora_subid14:
_zora_subid15:
_zora_subid16:
_zora_subid17:
_zora_subid18:
_zora_subid19:
_zora_subid1A:
_zora_subid1B:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@state0:
	call _zora_commonInit
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld b,$00
	jr z,+
	inc b
+
	ld e,Interaction.subid
	ld a,(de)
	sub $13
	add a
	add b
	ld hl,@textTable
	rst_addAToHl
	ld e,Interaction.textID
	ld a,(hl)
	ld (de),a
	ld hl,mainScripts.genericNpcScript
	jp interactionSetScript


; Table of text to show before/after water pollution is fixed for each zora
@textTable:
	.db <TX_3447, <TX_3448 ; $13 == [subid]
	.db <TX_3449, <TX_344a ; $14
	.db <TX_344b, <TX_344c ; $15
	.db <TX_3446, <TX_3446 ; $16
	.db <TX_3440, <TX_3441 ; $17
	.db <TX_3442, <TX_3443 ; $18
	.db <TX_3444, <TX_3445 ; $19
	.db <TX_344d, <TX_344d ; $1a
	.db <TX_344e, <TX_344e ; $1b

;;
; @param[out]	b	0 if king zora is uncured;
;			1 if he's cured;
;			2 if pollution is fixed;
;			3 if beat Jabu (except it's bugged and this doesn't happen)
_zora_getWorldState:
	ld a,GLOBALFLAG_KING_ZORA_CURED
	call checkGlobalFlag
	ld b,$00
	ret z

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld b,$01
	ret z

	ld a,(wEssencesObtained)
	bit 6,a
	ld b,$02
	ret nc
	; BUG: this should be "ret z"

	inc b
	ret


; Text 0: Before healing king
; Text 1: After healing king
; Text 2: After fixing pollution
; Text 3: After beating jabu (bugged to never have this text read)
_zora_textIndices:
	.db <TX_3410, <TX_3411, <TX_3412, <TX_3412 ; 0 == [subid]
	.db <TX_3413, <TX_3414, <TX_3414, <TX_3414 ; 1
	.db <TX_3415, <TX_3416, <TX_3416, <TX_3416 ; 2
	.db <TX_3417, <TX_3418, <TX_3419, <TX_3419 ; 3
	.db <TX_341a, <TX_341b, <TX_341b, <TX_341b ; 4
	.db <TX_3420, <TX_3421, <TX_3422, <TX_3423 ; 5
	.db <TX_3424, <TX_3424, <TX_3424, <TX_3424 ; 6
	.db <TX_3425, <TX_3425, <TX_3426, <TX_3426 ; 7
	.db <TX_3427, <TX_3427, <TX_3427, <TX_3427 ; 8
	.db <TX_3428, <TX_3428, <TX_3429, <TX_3429 ; 9


; ==============================================================================
; INTERACID_ZELDA
; ==============================================================================
interactionCodead:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw _zelda_state0
	.dw _zelda_state1

_zelda_state0:
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics
	call objectSetVisiblec2

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @commonInit
	.dw @commonInit
	.dw @initSubid03
	.dw @initSubid04
	.dw @commonInitWithExtraGraphics
	.dw @commonInit
	.dw @initSubid07
	.dw @initSubid08
	.dw @commonInit
	.dw @initSubid0a

@initSubid04:
	call checkIsLinkedGame
	jp z,interactionDeleteAndUnmarkSolidPosition

	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDeleteAndUnmarkSolidPosition

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDeleteAndUnmarkSolidPosition

	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.angle
	ld (hl),$08
	jp @commonInit

@initSubid03:
	ld bc,$4820
	call interactionSetPosition
	ld a,$01
	call interactionSetAnimation
	jp @commonInit

@initSubid07:
	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA
	call checkGlobalFlag
	jp z,interactionDeleteAndUnmarkSolidPosition

	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp c,interactionDeleteAndUnmarkSolidPosition

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ld a,<TX_0606
	jr nz,@actAsGenericNpc
	ld a,<TX_0605

@actAsGenericNpc:
	ld e,Interaction.textID
	ld (de),a
	inc e
	ld a,>TX_0600
	ld (de),a
	ld hl,mainScripts.genericNpcScript
	jp interactionSetScript

@initSubid08:
	call checkIsLinkedGame
	jp z,interactionDeleteAndUnmarkSolidPosition

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp z,interactionDeleteAndUnmarkSolidPosition

	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT
	call checkGlobalFlag
	jp nz,interactionDeleteAndUnmarkSolidPosition

	ld a,<TX_060b
	jr @actAsGenericNpc

@initSubid0a:
	call checkIsLinkedGame
	jp z,interactionDeleteAndUnmarkSolidPosition

	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDeleteAndUnmarkSolidPosition

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDeleteAndUnmarkSolidPosition

	ld a,<TX_060a
	jr @actAsGenericNpc

@initSubid00:
	call getThisRoomFlags
	bit 7,a
	jr z,@commonInitWithExtraGraphics
	ld a,$01
	ld (wDisableScreenTransitions),a
	ld a,(wActiveMusic)
	or a
	jr z,@commonInitWithExtraGraphics
	xor a
	ld (wActiveMusic),a
	ld a,MUS_ZELDA_SAVED
	call playSound

@commonInitWithExtraGraphics:
	call interactionLoadExtraGraphics

@commonInit:
	call _zelda_loadScript


_zelda_state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @runSubid2
	.dw @animateAndRunScript
	.dw @runSubid4
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @faceLinkAndRunScript
	.dw @faceLinkAndRunScript
	.dw @animateAndRunScript
	.dw @faceLinkAndRunScript

@animateAndRunScript:
	call interactionAnimate
	jp interactionRunScript

@runSubid2:
	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimate
	jp interactionRunScript

@runSubid4:
	call interactionRunScript
	jp nc,interactionAnimateBasedOnSpeed
	jp interactionDeleteAndUnmarkSolidPosition

@faceLinkAndRunScript:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

;;
_zelda_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.zeldaSubid00Script
	.dw mainScripts.zeldaSubid01Script
	.dw mainScripts.zeldaSubid02Script
	.dw mainScripts.zeldaSubid03Script
	.dw mainScripts.zeldaSubid04Script
	.dw mainScripts.zeldaSubid05Script
	.dw mainScripts.zeldaSubid06Script
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.zeldaSubid09Script
	.dw mainScripts.stubScript


; ==============================================================================
; INTERACID_CREDITS_TEXT_HORIZONTAL
;
; Variables:
;   var03: ?
;   var30: ?
;   var31: ?
;   var32: ?
;   var33: ?
; ==============================================================================
interactionCodeae:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr nz,@var03Nonzero

	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	ld hl,_horizontalCreditsText_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call _creditsTextHorizontal_6559

	ld e,Interaction.subid
	ld a,(de)
	ld hl,_horizontalCreditsText_65b1
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.var32
	ld (de),a
	ldi a,(hl)
	ld e,Interaction.counter2
	ld (de),a
	ret

@var03Nonzero:
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.var30
	ld (hl),$14
	ld l,Interaction.speed
	ld (hl),SPEED_200

	ld l,Interaction.counter2
	ld a,(hl)
	call interactionSetAnimation

	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	or a
	ld bc,$f018
	jr z,+
	ld bc,$0008
+
	ld l,Interaction.xh
	ld (hl),b
	ld l,Interaction.angle
	ld (hl),c
	jp objectSetVisible82

@state1:
	ld a,$01
	ld (de),a ; [state]
	ld e,Interaction.var03
	ld a,(de)
	or a
	jp nz,_horizontalCreditsText_var03Nonzero

	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.var30
	call decHlRef16WithCap
	ret nz
	call _creditsTextHorizontal_6537

@func_6457:
	ld e,Interaction.var30
	ld a,(de)
	rlca
	ret nc

	ld b,$01
	rlca
	jr nc,+
	ld b,$02
+
	ld h,d
	ld l,Interaction.counter1
	ld (hl),180
	ld l,Interaction.substate
	ld (hl),b
	ret

@substate1:
	ld e,Interaction.var33
	ld a,(de)
	rst_jumpTable
	.dw @subsubstate0
	.dw @subsubstate1
	.dw @subsubstate2
	.dw @subsubstate3

@subsubstate0:
	call interactionDecCounter1
	ret nz
	ld h,d
	ld l,Interaction.var33
	inc (hl)
	ret

@subsubstate1:
	ld a,(wFrameCounter)
	and $03
	ret nz

	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	cp $10
	jr nz,@label_0b_234

	ld l,Interaction.var33
	inc (hl)

	ld l,Interaction.scriptPtr
	ld a,(hl)
	sub $03
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	call _creditsTextHorizontal_6554
	ld h,d
	ld l,Interaction.counter1
	ld (hl),30
	ret

@label_0b_234:
	ld a,($ff00+R_SVBK)
	push af
	ld l,Interaction.counter1
	ld a,(hl)
	ld b,a
	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a
	ld a,b
	ld hl,w4TileMap
	rst_addDoubleIndex
	ld b,$30
@loop:
	xor a
	ldi (hl),a
	ld (hl),a
	ld a,$1f
	rst_addAToHl
	dec b
	jr nz,@loop

	push de
	ld a,UNCMP_GFXH_09
	call loadUncompressedGfxHeader
	pop de
	pop af
	ld ($ff00+R_SVBK),a

	ld h,d
	ld l,Interaction.counter1
	inc (hl)
	ret

@subsubstate2:
	call interactionDecCounter1
	ret nz
	ld l,Interaction.var33
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),$10
	ret

@subsubstate3:
	ld a,(wFrameCounter)
	and $03
	ret nz
	call interactionDecCounter1
	jr nz,@label_0b_236

	xor a
	ld l,Interaction.substate
	ld (hl),a
	ld l,Interaction.var33
	ld (hl),a
	jp @func_6457

@label_0b_236:
	push de
	ld a,($ff00+R_SVBK)
	push af
	ld a,(hl) ; [counter1]
	ld b,a

	ld a,b
	ld hl,w4TileMap
	rst_addDoubleIndex
	ld a,b
	ld de,w3VramTiles
	call addDoubleIndexToDe
	ld b,$30
@tileLoop:
	push bc
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	ld a,(de)
	ld b,a
	inc de
	ld a,(de)
	ld c,a
	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a
	ld (hl),b
	inc hl
	ld (hl),c
	ld a,$1f
	ld c,a
	rst_addAToHl
	ld a,c
	call addAToDe
	pop bc
	dec b
	jr nz,@tileLoop

	ld a,UNCMP_GFXH_09
	call loadUncompressedGfxHeader
	pop af
	ld ($ff00+R_SVBK),a
	pop de
	ret

@substate2:
	call interactionDecCounter1
	ret nz
.ifdef ROM_AGES
	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld (hl),$ff
.else
	ld hl,$cfde
	ld (hl),$01
.endif
	jp interactionDelete

;;
_creditsTextHorizontal_6537:
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_CREDITS_TEXT_HORIZONTAL
	inc l
	ld e,Interaction.var32
	ld a,(de)
	ldi (hl),a  ; [child.subid]
	ld (hl),$01 ; [child.var03]

	ld l,Interaction.counter1
	ld e,l
	ld a,(de)
	inc e
	ldi (hl),a
	ld a,(de) ; [counter2]
	ld (hl),a
	call objectCopyPosition
++
	ld h,d
	ld l,Interaction.counter2
	inc (hl)

;;
_creditsTextHorizontal_6554:
	ld l,Interaction.scriptPtr
	ldi a,(hl)
	ld h,(hl)
	ld l,a

;;
; @param	hl	Script pointer
_creditsTextHorizontal_6559:
	ldi a,(hl)
	ld e,Interaction.var30
	ld (de),a

	inc e
	ldi a,(hl)
	ld (de),a ; [var31]

	ldi a,(hl)
	ld e,Interaction.counter1
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a

	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Interaction.var31
	ld a,(de)
	or a
	ret nz

	dec e
	ld a,(de) ; [var30]
	or a
	ret nz
	jp _creditsTextHorizontal_6537

;;
_horizontalCreditsText_var03Nonzero:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld h,d
	ld l,Interaction.var30
	dec (hl)
	jr nz,@applySpeed

	call interactionIncSubstate
	ld b,$a0
	ld l,Interaction.subid
	ld a,(hl)
	or a
	jr z,+
	ld b,$50
+
	ld l,Interaction.xh
	ld (hl),b
	ret

@applySpeed:
	call objectApplySpeed
	jp objectApplySpeed

@substate1:
	ld e,Interaction.counter1
	ld a,(de)
	inc a
	ret z
	call interactionDecCounter1
	jp z,interactionDelete
	ret

_horizontalCreditsText_65b1:
	.db $00 $00 $01 $04 $00 $0b $01 $13
	.db $00 $00 $01 $04 $00 $0b $01 $13


; Custom script format? TODO: figure this out
_horizontalCreditsText_scriptTable:
	.dw @script0
	.dw @script1
	.dw @script2
	.dw @script3
	.dw @script0
	.dw @script1
	.dw @script2
	.dw @script3

@script0:
	.db $20 $00 $ff $f8
	.db $30 $00 $f0 $18
	.db $20 $00 $f0 $38
	.db $20 $00 $f0 $50
	.db $ff

@script1:
	.db $20 $00 $ff $f8
	.db $20 $00 $f8 $18
	.db $10 $00 $e8 $38
	.db $10 $00 $d8 $58
	.db $80 $00 $00 $ff
	.db $10 $00 $00 $ff
	.db $28 $00 $00 $ff
	.db $50 $ff

@script2:
	.db $20 $00 $fe $f8
	.db $10 $00 $e8 $18
	.db $0a $00 $d8 $38
	.db $0a $00 $c8 $58
	.db $80 $00 $00 $ff
	.db $f8 $00 $00 $ff
	.db $18 $00 $00 $ff
	.db $38 $00 $00 $ff
	.db $58 $ff

@script3:
	.db $20 $00 $f8 $f8
	.db $20 $00 $d8 $18
	.db $00 $00 $d8 $38
	.db $00 $00 $d8 $58
	.db $80 $00 $00 $ff
	.db $f8 $00 $00 $ff
	.db $18 $00 $00 $ff
	.db $38 $00 $00 $ff
	.db $58 $ff


; ==============================================================================
; INTERACID_CREDITS_TEXT_VERTICAL
;
; Variables:
;   var30/var31: 16-bit counter?
; ==============================================================================
interactionCodeaf:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
	ld hl,@data_66bc
	jp @storeVar30Value
+
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ret

@state1:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@subid1

	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld h,d
	ld l,Interaction.var30
	call decHlRef16WithCap
	ret nz

	call @spawnChild
	ld e,Interaction.var30
	ld a,(de)
	inc a
	ret nz

	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld (hl),$ff
	jp interactionDelete

@spawnChild:
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERACID_CREDITS_TEXT_VERTICAL
	inc l
	ld (hl),$01 ; [child.subid] = 1
	inc l
	ld e,Interaction.counter1
	ld a,(de)
	ld (hl),a ; [child.var03]
	call objectCopyPosition
++
	ld h,d
	ld l,Interaction.counter1
	inc (hl)
	ld a,(hl)
	ld hl,@data_66bc
	rst_addDoubleIndex

@storeVar30Value:
	ldi a,(hl)
	ld e,Interaction.var30
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ret

@subid1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call objectApplySpeed
	ld h,d
	ld l,Interaction.yh
	ldi a,(hl)
	ld b,a
	or a
	jp z,interactionDelete
	inc l
	ld c,(hl) ; [xh]
	jp interactionFunc_3e6d

@data_66bc:
.ifdef REGION_JP
	.dw $0020
	.dw $00e0
	.dw $0120
	.dw $0110
	.dw $00e0
	.dw $0160
	.dw $00e0
	.dw $0100
	.dw $0140
	.dw $0150
	.dw $0130
	.dw $0180
	.db $ff
.else
	.dw $0020
	.dw $00e0
	.dw $0120
	.dw $0110
	.dw $00f0
	.dw $0160
	.dw $00f0
	.dw $0120
	.dw $0170
	.dw $0150
	.dw $0160
	.dw $0140
	.dw $0140
	.dw $0160
	.dw $0110
	.dw $0160
	.dw $01a0
	.db $ff
.endif


; ==============================================================================
; INTERACID_TWINROVA_IN_CUTSCENE
; ==============================================================================
interactionCodeb0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw _twinrovaInCutscene_state0
	.dw _twinrovaInCutscene_state1


_twinrovaInCutscene_state0:
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_2800
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid0:
	ld a,$01
	call @commonInit1
	jr _twinrovaInCutscene_loadScript

@subid1:
	ld a,$02

@commonInit1:
	ld e,Interaction.oamFlags
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	jp interactionSetAnimation


@subid2:
	ld a,$01
	jr @commonInit2

@subid3:
	ld a,$01
	call interactionSetAnimation
	ld a,$02

@commonInit2:
	ld e,Interaction.oamFlags
	ld (de),a
	jp interactionSetAlwaysUpdateBit


_twinrovaInCutscene_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate

@subid0:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	call interactionAnimate
	call interactionRunScript
	ret nc
	ld a,SND_LIGHTNING
	call playSound
	xor a
	ld (wGenericCutscene.cbb3),a
	dec a
	ld (wGenericCutscene.cbba),a
	jp interactionIncSubstate

@substate1:
	ld hl,wGenericCutscene.cbb3
	ld b,$02
	call flashScreen
	ret z
	ld a,$02
	ld (wGenericCutscene.cbb8),a
	ld a,CUTSCENE_BLACK_TOWER_EXPLANATION
	ld (wCutsceneTrigger),a
	ret

_twinrovaInCutscene_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.twinrovaInCutsceneScript
	.dw mainScripts.stubScript


; ==============================================================================
; INTERACID_TUNI_NUT
; ==============================================================================
interactionCodeb1:
	jpab bank3f.interactionCodeb1_body


; ==============================================================================
; INTERACID_VOLCANO_HANDLER
; ==============================================================================
interactionCodeb2:
	call checkInteractionState
	jr z,@state0

@state1:
	ld a,(wFrameCounter)
	and $0f
	ld a,SND_RUMBLE
	call z,playSound

	ld a,(wScreenShakeCounterY)
	or a
	jr nz,++
	ld a,(wScreenShakeCounterX)
	or a
	call z,@runScript
++
	call interactionDecCounter1
	ret nz
	call @setRandomCounter1

	ld c,$0f
	call getRandomNumber
	and c
	srl c
	inc c
	sub c
	ld c,a
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_VOLCANO_ROCK
	inc l
	ld (hl),$01 ; [subid]
	ld b,$00
	jp objectCopyPositionWithOffset

@state0:
	inc a
	ld (de),a ; [state]
	ld (wScreenShakeMagnitude),a
	ld hl,@script
	jp interactionSetMiniScript

@runScript:
	call interactionGetMiniScript
	ldi a,(hl)
	cp $ff
	jr nz,@handleOpcode
	ld hl,@script
	call interactionSetMiniScript
	jr @runScript

@handleOpcode:
	ld (wScreenShakeCounterY),a
	ldi a,(hl)
	ld (wScreenShakeCounterX),a

	ld e,Interaction.var30
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	call interactionSetMiniScript

@setRandomCounter1:
	call getRandomNumber_noPreserveVars
	ld h,d
	ld l,Interaction.var30
	and (hl)
	inc l
	add (hl)
	ld l,Interaction.counter1
	ld (hl),a
	ret


; "Script" format per line:
;   b0: wScreenShakeCounterY
;   b1: wScreenShakeCounterX
;   b2: ANDed with a random number and added to...
;   b3: Base value for counter1 (time until a rock spawns)
@script:
	.db 0  , 30 , $00, $ff
	.db 30 , 0  , $00, $ff
	.db 180, 180, $0f, $08
	.db 60 , 60 , $1f, $10
	.db 30 , 0  , $00, $ff
	.db 0  , 120, $00, $ff
	.db 15 , 15 , $00, $ff
	.db $ff


; ==============================================================================
; INTERACID_HARP_OF_AGES_SPAWNER
; ==============================================================================
interactionCodeb3:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,(hl)
	jp nz,interactionDelete ; Already got harp

	xor a
	ld (wTmpcfc0.genericCutscene.state),a

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_HARP

	ld l,Interaction.yh
	ld (hl),$38
	ld l,Interaction.xh
	ld (hl),$58
	ld b,h

	; Spawn a sparkle object attached to the harp of ages object we just spawned
	call getFreeInteractionSlot
	jr nz,@incState
	ld (hl),INTERACID_SPARKLE
	inc l
	ld (hl),$0c ; [subid]
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),b

@incState:
	call interactionSetAlwaysUpdateBit
	jp interactionIncState


@state1:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,(hl)
	ret z

	; Got harp; start cutscene
	ld a,SNDCTRL_STOPMUSIC
	call playSound

	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	call interactionIncState


@state2:
	ld a,(wTextIsActive)
	or a
	ret z

	xor a
	ld (w1Link.direction),a
	jp interactionIncState


@state3:
	ld a,(wTextIsActive)
	or a
	ret nz

	ld hl,wTmpcfc0.genericCutscene.state
	set 0,(hl)
	call interactionIncState

	ld l,Interaction.counter1
	ld (hl),40

	ld a,$02
	call fadeoutToBlackWithDelay

	ld a,$ff
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ld a,$01
	ld (wDirtyFadeSprPalettes),a
	ld a,$fe
	ld (wFadeSprPaletteSources),a

	call hideStatusBar
	ldh a,(<hActiveObject)
	ld d,a
	ret

@state4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionDecCounter1
	ret nz

	inc (hl) ; [counter1] = 1

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_NAYRU
	inc l
	ld (hl),$07 ; [subid]
	call objectCopyPosition

	jp interactionDelete


; ==============================================================================
; INTERACID_BOOK_OF_SEALS_PODIUM
;
; Variables:
;   var03: Tile index to replace path with?
; ==============================================================================
interactionCodeb4:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a ; [state]

	ld a,$06
	call objectSetCollideRadius
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit

	ld a,>TX_1200
	call interactionSetHighTextIndex

	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList

	ld e,Interaction.subid
	ld a,(de)
	or a
	ret nz

	; Subid 0
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld b,$10
	call z,clearMemory
	call getThisRoomFlags
	bit 6,a
	ret nz
	call interactionIncState
	ld hl,mainScripts.bookOfSealsPodiumScript
	jp interactionSetScript

@state1:
	inc e
	ld a,(de) ; [substate]
	or a
	call z,@spawnAllPodiums
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

@activatedBook:
	ld a,$01
	call interactionSetAnimation
	call @func_69ce
	ld a,c
	ld (wTmpcfc0.genericCutscene.cfd0),a

	ld hl,@textTable
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_1200
	call showText

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	ld h,d
	ld l,Interaction.var03
	ld a,$d3
	ldi (hl),a
	ld a,$03
	ldi (hl),a ; [state]
	inc l
	ld (hl),$02 ; [substate]
	ret

@textTable:
	.db <TX_120b, <TX_120c, <TX_120d, <TX_120e, <TX_120f, <TX_1210

@state2:
	inc e
	ld a,(de) ; [substate]
	or a
	call z,@spawnAllPodiums
	call interactionRunScript
	ret nc

	; Placed book on podium
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld a,SND_SOLVEPUZZLE
	call playSound
	ld a,TREASURE_BOOK_OF_SEALS
	call loseTreasure
	jr @activatedBook

@state3:
	call retIfTextIsActive
	call @replaceTiles
	ld a,(wDisabledObjects)
	or a
	ret nz
	ld e,Interaction.var03
	ld a,$f4
	ld (de),a
	jp @func_69ce

;;
@replaceTiles:
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	call interactionDecCounter1
	ret nz
	ld (hl),$02 ; [counter1]
	ld l,Interaction.scriptPtr
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	or a
	jr z,@label_0b_273

	ld c,a
	ld e,Interaction.var03
	ld a,(de)
	push hl
	call setTile
	pop hl
	ret z
	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@label_0b_273:
	; a == 0 here
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld e,Interaction.pressedAButton
	ld (de),a
	jp interactionIncState


@state4:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	jr z,++

	xor a
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@textTable
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_1200
	jp showText
++
	ld hl,wTmpcfc0.genericCutscene.cfd0
	ld e,Interaction.subid
	ld a,(de)
	cp (hl)
	ret z

	call retIfTextIsActive
	call @replaceTiles
	ld a,(wDisabledObjects)
	or a
	ret nz

	call interactionSetAnimation
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld e,Interaction.pressedAButton
	xor a
	ld (de),a
	ret

;;
; @param[out]	c	Subid
@func_69ce:
	ld e,Interaction.subid
	ld a,(de)
	ld c,a
	ld hl,@bookPathLists
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@spawnAllPodiums:
	call returnIfScrollMode01Unset
	ld a,$01
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	or a
	ret nz

	ld bc,@podiumPositions
	ld e,$05

@next:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_BOOK_OF_SEALS_PODIUM
	inc l
	ld (hl),e ; [subid]
	ld l,Interaction.yh
	ld a,(bc)
	ldi (hl),a
	inc l
	inc bc
	ld a,(bc)
	ld (hl),a
	inc bc
	dec e
	jr nz,@next
	ret


; List of tiles to become solid for each book
@bookPathLists:
	.db @subid0 - CADDR
	.db @subid1 - CADDR
	.db @subid2 - CADDR
	.db @subid3 - CADDR
	.db @subid4 - CADDR
	.db @subid5 - CADDR
@subid0:
	.db $99 $9a $9b $8b $7b $7c
	.db $00
@subid1:
	.db $6d $5d $5c $4c $3c $3d
	.db $00
@subid2:
	.db $2c $2b $1b $1a $19
	.db $00
@subid3:
	.db $28 $27 $26 $25 $15 $14 $13
	.db $00
@subid4:
	.db $22 $23 $33 $43 $42 $41 $51 $61
	.db $00
@subid5:
	.db $72 $82 $83 $84 $74 $75 $65 $66 $67
	.db $00

@podiumPositions:
	.db $84 $18
	.db $14 $18
	.db $14 $78
	.db $14 $d8
	.db $84 $d8


; ==============================================================================
; INTERACID_FINAL_DUNGEON_ENERGY
; ==============================================================================
interactionCodeb5:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]

	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	set 6,(hl) ; [room flags]
	call setDeathRespawnPoint
	xor a
	ld (wTextIsActive),a

	ld a,120
	ld e,Interaction.counter1
	ld (de),a

	ld bc,$5878
	jp createEnergySwirlGoingIn

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionDecCounter1
	ret nz

	call interactionIncSubstate

	ld l,Interaction.counter1
	ld (hl),$08

	ld hl,wGenericCutscene.cbb3
	ld (hl),$00
	ld hl,wGenericCutscene.cbba
	ld (hl),$ff
	ret

@substate1:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr nz,++
	call setLinkForceStateToState08
	ld hl,w1Link.visible
	set 7,(hl)
++
	call interactionDecCounter1
	ld hl,wGenericCutscene.cbb3
	ld b,$01
	call flashScreen
	ret z
	call interactionIncSubstate
	ld a,$03
	jp fadeinFromWhiteWithDelay

@substate2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wUseSimulatedInput),a
	jp interactionDelete


; ==============================================================================
; INTERACID_VIRE
;
; Variables:
;   relatedObj1: Zelda object (for vire subid 2 only)
;   var38: If nonzero, the script is run (subids 0 and 1 only)
; ==============================================================================
interactionCodeb8:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw _vire_subid0
	.dw _vire_subid1
	.dw _vire_subid2


; Vire at black tower entrance
_vire_subid0:
	call checkInteractionState
	jr z,@state0

@state1:
	ld e,Interaction.var38
	ld a,(de)
	or a
	jr nz,@runScript

	call _vire_disableObjectsIfLinkIsReady
	jr nc,@animate
	xor a
	ld (w1Link.direction),a

@runScript:
	call interactionRunScript
	jp c,_vire_deleteAndReturnControl
@animate:
	jp interactionAnimate

@state0:
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete

	ld a,MUS_GREAT_MOBLIN
	call playSound
	ld hl,mainScripts.vireSubid0Script

_vire_setScript:
	call interactionSetScript
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_200

	xor a
	ld (wTmpcfc0.genericCutscene.cfd0),a
	jp objectSetVisiblec2


; Vire in donkey kong minigame (lower level)
_vire_subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,(wGroup5Flags+(<ROOM_AGES_5e7))
	bit 6,a
	jp nz,interactionDelete

	call getThisRoomFlags
	bit 6,(hl)
	ld hl,mainScripts.vireSubid1Script
	jr z,_vire_setScript

	ld a,(wActiveMusic)
	or a
	ld a,MUS_MINIBOSS
	call nz,playSound
	jr @gotoState2

@state1:
	ld e,Interaction.var38
	ld a,(de)
	or a
	jr nz,@runScript

	ld a,(w1Link.yh)
	cp $9b
	jp nc,interactionAnimate

	call _vire_disableObjectsIfLinkIsReady
	jp nc,interactionAnimate

@runScript:
	call interactionRunScript
	jp nc,interactionAnimate
	call objectSetInvisible
	call _vire_returnControl

@gotoState2:
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
	ld l,Interaction.counter1
	ld (hl),$08
	ret

@state2:
	call interactionDecCounter1
	ret nz

	ld hl,w1Link.yh
	ldi a,(hl)
	cp $10
	jr nc,@spawnFireball

	inc l
	ld a,(hl) ; [w1Link.xh]
	cp $a0
	jr nc,_vire_setRandomCounter1

@spawnFireball:
	call getFreePartSlot
	jr nz,_vire_setRandomCounter1
	ld (hl),PARTID_DONKEY_KONG_FLAME
	inc l
	inc (hl) ; [subid] = 1

_vire_setRandomCounter1:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Interaction.counter1
	ld a,(hl)
	ld (de),a
	ret

@counter1Vals:
	.db 120, 160, 200, 240


; Vire in donkey kong minigame (upper level)
_vire_subid2:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete

	ldbc INTERACID_ZELDA, $03
	call objectCreateInteraction
	ret nz

	ld e,Interaction.relatedObj1
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld hl,mainScripts.vireSubid2Script
	call _vire_setScript
	ld l,Interaction.counter1
	ld (hl),$08
	ret

@state1:
	ld hl,w1Link.yh
	ldi a,(hl)
	cp $40
	jr nc,@gameStillGoing
	inc l
	ld a,(hl) ; [w1Link.xh]
	cp $58
	jr nc,@gameStillGoing

	call _vire_disableObjectsIfLinkIsReady
	jr nc,@gameStillGoing

	; Link reached the top
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wTmpcfc0.genericCutscene.cfd0),a
	ld a,DIR_LEFT
	ld (w1Link.direction),a
	jp interactionIncState

@gameStillGoing:
	ld h,d
	ld l,Interaction.counter2
	ld a,(hl)
	or a
	jr z,++
	dec (hl) ; [counter2]
	jr nz,++

	ld e,Interaction.direction
	xor a
	ld (de),a
	call interactionSetAnimation
++
	call interactionDecCounter1
	jr nz,@animate

	call getFreePartSlot
	jr nz,++
	ld (hl),PARTID_DONKEY_KONG_FLAME
	call objectCopyPosition
	ld e,Interaction.direction
	ld a,$01
	ld (de),a
	call interactionSetAnimation
	ld e,Interaction.counter2
	ld a,$18
	ld (de),a
++
	call _vire_setRandomCounter1
@animate:
	jp interactionAnimate

; Fight ended
@state2:
	call interactionIncState
	ld l,Interaction.counter1
	xor a
	ldi (hl),a
	ld (hl),a ; [counter2]
	ld e,Interaction.direction
	ld a,(de)
	dec a
	call z,interactionSetAnimation
	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound

@state3:
	call interactionRunScript
	jr nc,@animate

	; Increment Zelda's state
	ld a,Object.substate
	call objectGetRelatedObject1Var
	inc (hl)

	jp interactionDelete

;;
; @param[out]	cflag	c if successfully disabled objects
_vire_disableObjectsIfLinkIsReady:
	ld a,(wLinkInAir)
	or a
	ret nz
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld e,Interaction.var38
	ld (de),a

	call clearAllParentItems
	call dropLinkHeldItem
	scf
	ret

;;
_vire_deleteAndReturnControl:
	call interactionDelete

;;
_vire_returnControl:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ret


; ==============================================================================
; INTERACID_HORON_DOG
;
; Variables:
;   subid: Used as a sort of "state" variable?
;   var36: Target x-position
;   var37: ?
; ==============================================================================
interactionCodeb9:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	call objectSetInvisible

	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	ld hl,@counter1Vals
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.counter1
	ld (de),a

	ld a,b
	ld hl,@positions
	rst_addDoubleIndex
	ld b,(hl)
	inc hl
	ld a,(hl)
	ld c,a
	ld e,Interaction.var36
	ld (de),a

	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	ld e,Interaction.speed
	ld a,SPEED_100
	ld (de),a

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init
	.dw @jump
	.dw @jump
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init
	.dw @subid7Init

@subid0Init:
	ld e,Interaction.angle
	ld a,$04
	ld (de),a
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$e0
	inc hl
	ld (hl),$01 ; [counter2]

@jump:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@speedZVals
	rst_addDoubleIndex
	ld c,(hl)
	inc hl
	ld b,(hl)
	jp objectSetSpeedZ

@subid3Init:
	call @jump
	ld e,Interaction.speed
	ld a,SPEED_180
	ld (de),a
	jp @setZPosition

@subid4Init:
@subid5Init:
@subid6Init:
	call @jump
	ld e,Interaction.speed
	ld a,SPEED_40
	ld (de),a

@setZPosition:
	ld e,Interaction.subid
	ld a,(de)
	sub $03
	ld hl,@zPositions
	rst_addDoubleIndex
	ld e,Interaction.zh
	ldi a,(hl)
	ld (de),a
	dec e
	ld a,(hl)
	ld (de),a
	ret

@subid7Init:
	ld hl,mainScripts.horonDogScript
	jp interactionSetScript


@counter1Vals:
	.db 230, 90, 120, 190, 200, 210, 220, 250

@positions:
	.db $58 $38
	.db $48 $40
	.db $4c $60
	.db $48 $78
	.db $1a $2c
	.db $10 $38
	.db $0a $44
	.db $18 $a0

@speedZVals:
	.dw $ff40
	.dw $fee0
	.dw $ff00
	.dw $ffc0
	.dw $0036
	.dw $0036
	.dw $0036

@zPositions:
	.dw $ffe8 ; 3 == [subid]
	.dw $ffc8 ; 4
	.dw $ffc8 ; 5
	.dw $ffc8 ; 6

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionDecCounter1
	ret nz
	call objectSetVisible
	jp interactionIncSubstate


@substate1:
	call interactionAnimate
	call objectApplySpeed

	ld h,d
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var36
	cp (hl)
	jr nz,@reachedTargetXPosition

	call interactionIncSubstate
	ld l,Interaction.zh
	ld (hl),$00
	ld l,Interaction.subid
	ld a,(hl)
	add a
	inc a
	jp interactionSetAnimation

@reachedTargetXPosition:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7

@subid0:
@subid1:
@subid2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld e,Interaction.subid
	jp @jump

@subid3:
	ld c,$10

@label_0b_293:
	ld e,Interaction.var37
	ld a,(de)
	or a
	ret nz
	call objectUpdateSpeedZ_paramC
	ret nz

	ld h,d
	ld l,Interaction.var37
	inc (hl)

@subid7:
	ret

@subid4:
@subid5:
@subid6:
	ld c,$01
	jr @label_0b_293


@substate2:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@substate2_subidNot0

@substate2_subid0:
	ld b,a
	ld h,d
	ld l,Interaction.counter1
	call decHlRef16WithCap
	jr nz,@animate
	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld (hl),$01
	ret

@substate2_subidNot0:
	cp $07
	jr nz,@animate

	call interactionRunScript
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret z

@animate:
	jp interactionAnimate


; ==============================================================================
; INTERACID_CHILD_JABU
; ==============================================================================
interactionCodeba:
	call checkInteractionState
	jr nz,@state0

@state1:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld bc,$0e06
	call objectSetCollideRadii
	ld hl,mainScripts.childJabuScript
	call interactionSetScript
	jp objectSetVisible82

@state0:
	call interactionAnimateAsNpc
	jp interactionRunScript


; ==============================================================================
; INTERACID_HUMAN_VERAN
; ==============================================================================
interactionCodebb:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState
	call interactionInitGraphics
	ld hl,mainScripts.humanVeranScript
	call interactionSetScript
	jp objectSetVisible82

@state1:
	ld a,Object.visible
	call objectGetRelatedObject1Var
	ld a,(hl)
	xor $80
	ld e,l
	ld (de),a
	call interactionRunScript
	ret nc
	jp interactionDelete


; ==============================================================================
; INTERACID_TWINROVA_3
;
; Variables:
;   var3c: A target position index for the data in var3e/var3f.
;   var3d: # of values in the position list (var3c must stop here).
;   var3e/var3f: A pointer to a list of target positions.
; ==============================================================================
interactionCodebc:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2
	.dw @initSubid3

@initSubid0:
@initSubid1:
	call @commonInit
	ld l,Interaction.zh
	ld (hl),$fb
	ld l,Interaction.subid
	ld a,(hl)
	call @readPositionTable
	jp @state1

@initSubid2:
	call @commonInit
	ld l,Interaction.zh
	ld (hl),$f0
	ld a,$02
	call @readPositionTable
	ld a,$04
	call interactionSetAnimation
	jp @state1

@initSubid3:
	call @commonInit
	ld a,$02
	call @readPositionTable
	ld a,$01
	call interactionSetAnimation
	jp @state1

@commonInit:
	call interactionInitGraphics
	call objectSetVisiblec0
	call interactionSetAlwaysUpdateBit
	call @loadOamFlags
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld l,Interaction.zh
	ld (hl),$f8
	ld l,Interaction.direction
	ld (hl),$ff
	ret


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0State1
	.dw @subid0State1
	.dw @subid2State1
	.dw @subid2State1


@subid0State1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid0Substate0
	.dw @subid0Substate1
	.dw @subid0Substate2
	.dw @subid0Substate3
	.dw @subid0Substate4

@subid0Substate0:
	call @moveTowardTargetPosition
	call @updateAnimationIndex

	call @checkReachedTargetPosition
	call c,@nextTargetPosition
	jp nc,@animate

	; Exhausted position list
	ld h,d
	ld l,Interaction.substate
	ld (hl),$01
	ld l,Interaction.counter2
	ld (hl),40

	ld l,Interaction.subid
	ld a,(hl)
	or a
	jr nz,+

	ld a,$00
	jr +++
+
	cp $01
	jr nz,++

	ld a,$01
	jr +++
++
	ld a,$02
+++
	call interactionSetAnimation
	jp @animate

@subid0Substate1:
	call @updateFloating
	call @animate
	call interactionDecCounter2
	ret nz

	ld l,Interaction.substate
	inc (hl)
	ld l,Interaction.counter2
	ld (hl),40

@func_6eac:
	ld hl,wTmpcfc0.genericCutscene.cfc6
	inc (hl)
	ld a,(hl)
	cp $02
	ret nz
	ld (hl),$00
	ld hl,wTmpcfc0.genericCutscene.state
	set 0,(hl)
	ret

@subid0Substate2:
	call @updateFloating
	call @animate
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 0,a
	ret nz
	call interactionDecCounter2
	ret nz

	ld l,Interaction.substate
	inc (hl)
	ld l,Interaction.direction
	ld (hl),$ff
	ld l,Interaction.subid
	ld a,(hl)
	add $04
	jp @readPositionTable

@subid0Substate3:
	call @moveTowardTargetPosition
	call @checkReachedTargetPosition
	call c,@nextTargetPosition
	jr c,@@looped

	call @moveTowardTargetPosition
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	call nz,@updateAnimationIndex
	call @checkReachedTargetPosition
	call c,@nextTargetPosition
	jr nc,@animate

@@looped:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jr c,++

	call @func_6eac
	jp interactionDelete
++
	call @func_6eac
	ld h,d
	ld l,Interaction.substate
	inc (hl)
	ret

@subid0Substate4:
	jp @animate


@subid2State1:
	call checkInteractionSubstate
	jr nz,++
	call @updateFloating
	call @animate
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 0,a
	ret z
	call interactionIncSubstate
	ld l,Interaction.direction
	ld (hl),$ff
	ret
++
	jr @subid0Substate3

@animate:
	jp interactionAnimate

@loadOamFlags:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@oamFlags
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.oamFlags
	ld (de),a
	ret

@oamFlags:
	.db $02 $01 $00 $01

;;
; Updates z values to "float" up and down?
@updateFloating:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,@zValues
	rst_addAToHl
	ld e,Interaction.zh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@zValues:
	.db $ff $fe $ff $00 $01 $02 $01 $00

;;
@moveTowardTargetPosition:
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	add a
	ld b,a

	ld e,Interaction.var3f
	ld a,(de)
	ld l,a
	ld e,Interaction.var3e
	ld a,(de)
	ld h,a

	ld a,b
	rst_addAToHl
	ld b,(hl)
	inc hl
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	jp objectApplySpeed

;;
; @param	bc	Pointer to position data (Y, X values)
; @param[out]	cflag	c if reached target position
@checkReachedTargetPosition:
	call @getCurrentPositionPointer
	ld l,Interaction.yh
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret nc
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret

;;
@updateAnimationIndex:
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	swap a
	and $01
	xor $01
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation

;;
; @param[out]	cflag	c if we've exhausted the position list and we're looping
@nextTargetPosition:
	call @@setPositionToPointerData
	ld h,d
	ld l,Interaction.var3d
	ld a,(hl)
	ld l,Interaction.var3c
	inc (hl)
	cp (hl)
	ret nc
	ld (hl),$00
	scf
	ret

;;
@@setPositionToPointerData:
	call @getCurrentPositionPointer
	ld l,Interaction.y
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.x
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	ret

;;
; @param[out]	bc	Pointer to position data
@getCurrentPositionPointer:
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	add a
	push af
	ld e,Interaction.var3f
	ld a,(de)
	ld c,a
	ld e,Interaction.var3e
	ld a,(de)
	ld b,a
	pop af
	call addAToBc
	ret

;;
; Read values for var3f, var3e, var3d based on parameter
;
; @param	a	Index for table
@readPositionTable:
	add a
	ld hl,@table
	rst_addDoubleIndex
	ld e,Interaction.var3f
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3e
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3d
	ldi a,(hl)
	ld (de),a
	ret

@table:
	dwbb @positions0, $0b, $00
	dwbb @positions1, $0b, $00
	dwbb @positions2, $09, $00
	dwbb @positions3, $09, $00
	dwbb @positions4, $04, $00
	dwbb @positions5, $04, $00

@positions2:
	.db $54 $18
	.db $58 $0e
	.db $60 $08
	.db $68 $0c
	.db $72 $18
	.db $78 $28
	.db $80 $48
	.db $88 $68
	.db $90 $80
	.db $a0 $a0

@positions3:
	.db $54 $88
	.db $58 $92
	.db $60 $98
	.db $68 $94
	.db $72 $88
	.db $78 $78
	.db $80 $58
	.db $88 $38
	.db $90 $20
	.db $a0 $00

@positions0:
	.db $01 $40
	.db $29 $18
	.db $39 $10
	.db $45 $0c
	.db $51 $10
	.db $61 $18
	.db $71 $28
	.db $77 $38
	.db $79 $48
	.db $77 $58
	.db $71 $68
	.db $61 $78

@positions1:
	.db $01 $60
	.db $29 $88
	.db $39 $90
	.db $45 $94
	.db $51 $90
	.db $61 $88
	.db $71 $78
	.db $77 $68
	.db $79 $58
	.db $77 $48
	.db $71 $38
	.db $61 $28

@positions4:
	.db $5d $90
	.db $4d $98
	.db $39 $90
	.db $2d $78
	.db $29 $60

@positions5:
	.db $5d $10
	.db $4d $08
	.db $39 $10
	.db $2d $28
	.db $29 $40

; ==============================================================================
; INTERACID_PUSHBLOCK_SYNCHRONIZER
; ==============================================================================
interactionCodebd:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionIncState
	.dw @state1
	.dw @state2

@state1:
	; Wait for a block to be pushed
	ld a,(w1ReservedInteraction1.enabled)
	or a
	ret z

	ld a,(w1ReservedInteraction1.var31) ; Tile index of block being pushed
	ldh (<hFF8B),a
	call findTileInRoom
	jr nz,@incState

	; Found another tile of the same type; push it, then search for more tiles of that type
	call @pushBlockAt
--
	ldh a,(<hFF8B)
	call backwardsSearch
	jr nz,@incState
	call @pushBlockAt
	jr --

@incState:
	jp interactionIncState

@state2:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret

;;
; @param	hl	Position of block to push in wRoomLayuut
; @param	hFF8B	Index of tile to push
@pushBlockAt:
	push hl
	ldh a,(<hFF8B)
	cp TILEINDEX_SOMARIA_BLOCK
	jr z,@return

	ld a,l
	ldh (<hFF8D),a
	ld h,d
	ld l,Interaction.yh
	call setShortPosition

	ld l,Interaction.angle
	ld a,(wBlockPushAngle)
	and $1f
	ld (hl),a

	call interactionCheckAdjacentTileIsSolid
	jr nz,@return
	call getFreeInteractionSlot
	jr nz,@return

	ld (hl),INTERACID_PUSHBLOCK
	ld l,Interaction.angle
	ld e,l
	ld a,(de)
	ld (hl),a
	ldbc -$02, $00
	call objectCopyPositionWithOffset

	; [pushblock.var30] = tile position
	ld l,Interaction.var30
	ldh a,(<hFF8D)
	ld (hl),a
@return:
	pop hl
	dec l
	ret


; ==============================================================================
; INTERACID_AMBIS_PALACE_BUTTON
; ==============================================================================
interactionCodebe:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete
	ld a,$02
	call objectSetCollideRadius
	jp interactionIncState

@state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc
	call objectGetTileAtPosition
	ld a,(wActiveTilePos)
	cp l
	ret nz
	ld a,(wLinkInAir)
	or a
	ret nz
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld e,Interaction.counter1
	ld a,45
	ld (de),a
	call objectGetTileAtPosition
	ld c,l
	ld a,$9e
	call setTile
	ld a,SND_OPENCHEST
	call playSound
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz
	ld a,CUTSCENE_AMBI_PASSAGE_OPEN
	ld (wCutsceneTrigger),a
	ld a,(wActiveRoom)
	ld (wTmpcbbb),a
	ld a,(wActiveTilePos)
	ld (wTmpcbbc),a
	ld e,Interaction.subid
	ld a,(de)
	ld (wTmpcbbd),a
	call fadeoutToWhite
	jp interactionDelete


; ==============================================================================
; INTERACID_SYMMETRY_NPC
; ==============================================================================
interactionCodebf:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @runScriptAndAnimate
	.dw @state2

@state0:
	call interactionInitGraphics
	call objectSetVisible82
	call interactionIncState
	ld a,>TX_2d00
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @subid0cInit

@subid0cInit:
	ld a,GLOBALFLAG_TUNI_NUT_PLACED
	call checkGlobalFlag
	jp z,interactionDelete

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.symmetryNpcSubid0And1Script
	.dw mainScripts.symmetryNpcSubid0And1Script
	.dw mainScripts.symmetryNpcSubid2And3Script
	.dw mainScripts.symmetryNpcSubid2And3Script
	.dw mainScripts.symmetryNpcSubid4And5Script
	.dw mainScripts.symmetryNpcSubid4And5Script
	.dw mainScripts.symmetryNpcSubid6And7Script
	.dw mainScripts.symmetryNpcSubid6And7Script
	.dw mainScripts.symmetryNpcSubid8And9Script
	.dw mainScripts.symmetryNpcSubid8And9Script
	.dw mainScripts.symmetryNpcSubidAScript
	.dw mainScripts.symmetryNpcSubidBScript
	.dw mainScripts.symmetryNpcSubidCScript


; For subids 8/9 (sisters in the tuni nut building)...
; Listen for a signal from the tuni nut object; change the script when it's placed.
@state2:
	ld hl,wTmpcfc0.genericCutscene.state
	bit 0,(hl)
	jr z,@runScriptAndAnimate

	ld hl,mainScripts.symmetryNpcSubid8And9Script_afterTuniNutRestored
	call interactionSetScript
	ld e,Interaction.state
	ld a,$01
	ld (de),a

@runScriptAndAnimate:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


; ==============================================================================
; INTERACID_c1
;
; Variables:
;   counter1/counter2: 16-bit counter
;   var36: Counter for sparkle spawning
; ==============================================================================
interactionCodec1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.counter1
	ld (hl),<390
	inc l
	ld (hl),>390 ; [counter2]
	ld l,Interaction.var36
	ld (hl),$06
	ld l,Interaction.angle
	ld (hl),$15
	ld l,Interaction.speed
	ld (hl),SPEED_300
	jp objectSetVisible82

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.counter1
	call decHlRef16WithCap
	ret nz
	ld l,Interaction.counter1
	ld (hl),40
	jp interactionIncSubstate

@substate1:
	call @updateMovementAndSparkles
	jr nz,@ret
	ld l,Interaction.animCounter
	ld (hl),$01
	jp interactionIncSubstate

@substate2:
	call interactionAnimate
	call @updateSparkles
	call objectApplySpeed
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	jp z,interactionDelete
	ret

;;
; @param[out]	zflag	z if [counter1] == 0
@updateMovementAndSparkles:
	call @updateSparkles
	call objectApplySpeed
	jp interactionDecCounter1

@ret:
	ret

;;
; Unused
@func_7224:
	ld a,(wFrameCounter)
	and $01
	jp z,objectSetInvisible
	jp objectSetVisible

;;
@updateSparkles:
	ld h,d
	ld l,Interaction.var36
	dec (hl)
	ret nz
	ld (hl),$06 ; [var36]
.ifdef ROM_AGES
	ldbc INTERACID_SPARKLE, $09
.else
	ldbc INTERACID_SPARKLE, $05
.endif
	jp objectCreateInteraction


; ==============================================================================
; INTERACID_PIRATE_SHIP
; ==============================================================================
interactionCodec2:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid0State0
	.dw @subid0State1
	.dw interactionAnimate

@subid0State0:
	call interactionInitGraphics
	call objectSetVisible82
	ld a,(wPirateShipAngle)
	and $03
	ld e,Interaction.direction
	ld (de),a
	call interactionSetAnimation
	ld a,$06
	call objectSetCollideRadius
	jp interactionIncState

@subid0State1:
	; Update position based on "wPirateShipRoom" and other variables
	ld hl,wPirateShipRoom
	ld a,(wActiveRoom)
	cp (hl)
	jp nz,interactionDelete
	inc l
	ldi a,(hl) ; [wPirateShipY]
	ld e,Interaction.yh
	ld (de),a
	ldi a,(hl) ; [wPirateShipX]
	ld e,Interaction.xh
	ld (de),a

	ld e,Interaction.direction
	ld a,(de)
	cp (hl) ; [wPirateShipAngle]
	ld a,(hl)
	ld (de),a
	call nz,interactionSetAnimation

	; Check if Link touched the ship
	call objectCheckCollidedWithLink_notDead
	jr nc,@animate
	call checkLinkVulnerable
	jr nc,@animate

	ld hl,@warpDest
	call setWarpDestVariables
	jp interactionIncState

@animate:
	jp interactionAnimate

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5f8, $01, $56, $03


; Unlinked cutscene of ship leaving
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid1State0
	.dw @subid1And2State1
	.dw @subid1State2

@subid1State0:
	call checkIsLinkedGame
	jp nz,interactionDelete

	ld a,GLOBALFLAG_PIRATES_GONE
	call checkGlobalFlag
	jp z,interactionDelete

	call getThisRoomFlags
	and ROOMFLAG_40
	jp nz,interactionDelete

	call interactionInitGraphics
	ld a,$03
	call interactionSetAnimation
	xor a ; DIR_UP
	ld (w1Link.direction),a

@subid1And2State0Common:
	call objectSetVisible82
	ld e,Interaction.counter1
	ld a,60
	ld (de),a
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionIncState

@subid1And2State1:
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	ld (hl),$80
	ld bc,TX_360c
	call showText
	jp interactionIncState

@subid1State2:
	ld c,ANGLE_LEFT

@moveOffScreen:
	ld b,SPEED_100
	ld e,Interaction.angle
	call objectApplyGivenSpeed
	call interactionAnimate
	call interactionDecCounter1
	ret nz

	call getThisRoomFlags
	set ROOMFLAG_BIT_40,(hl)
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp interactionDelete


; Linked cutscene of ship leaving
@subid2:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @subid2State0
	.dw @subid1And2State1
	.dw @subid2State2

@subid2State0:
	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,GLOBALFLAG_PIRATES_GONE
	call checkGlobalFlag
	jp z,interactionDelete

	call getThisRoomFlags
	and ROOMFLAG_40
	jp nz,interactionDelete

	call interactionInitGraphics
	xor a
	call interactionSetAnimation
	ld a,$01
	ld (w1Link.direction),a
	jp @subid1And2State0Common

@subid2State2:
	ld c,ANGLE_UP
	jr @moveOffScreen


; ==============================================================================
; INTERACID_PIRATE_CAPTAIN
; ==============================================================================
interactionCodec3:
	call checkInteractionState
	jr z,@state0

@state1:
	call objectPreventLinkFromPassing
	call interactionRunScript
	jp interactionAnimate

@state0:
	call interactionInitGraphics
	call objectSetVisible82
	call checkIsLinkedGame
	jr nz,++

	; Unlinked: mark room as in the past (for the minimap probably)
	ld hl,wTilesetFlags
	set TILESETFLAG_BIT_PAST,(hl)
++
	ld hl,mainScripts.pirateCaptainScript
	call interactionSetScript
	jp interactionIncState


; ==============================================================================
; INTERACID_PIRATE
;
; Variables:
;   var3f: Push counter for subid 4 (tokay eyeball is inserted when it reached 0)
; ==============================================================================
interactionCodec4:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init

@subid0Init:
@subid1Init:
@subid2Init:
@subid3Init:
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionInitGraphics
	call objectSetVisiblec2
	jp interactionIncState

@subid4Init:
	call getThisRoomFlags
	and ROOMFLAG_80
	jp nz,interactionDelete

	call @resetPushCounter
	ld e,Interaction.state
	ld a,$03
	ld (de),a

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.pirateSubid0Script
	.dw mainScripts.pirateSubid1Script
	.dw mainScripts.pirateSubid2Script
	.dw mainScripts.pirateSubid3Script
	.dw mainScripts.pirateSubid4Script


; Subids 0-3: waiting for signal from piration captain to jump in excitement
@state1:
	ld a,(wTmpcfc0.genericCutscene.state)
	bit 0,a
	jp nz,@jump
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@jump:
	ld a,$02
	call interactionSetAnimation
	ld bc,-$200
	call objectSetSpeedZ
	jp interactionIncState


; Subids 0-3: will set a signal when they're done jumping
@state2:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	ret nz
	ld hl,wTmpcfc0.genericCutscene.state
	set 1,(hl)
	jp interactionAnimate


;;
; @param[out]	cflag	c if Link is pushing up towards this object
@checkCenteredWithLink:
	ld a,(wLinkDeathTrigger)
	or a
	ret nz
	ld a,(wLinkPushingDirection)
	or a ; DIR_UP
	ret nz
	ld a,(wGameKeysPressed)
	and BTN_A | BTN_B
	ret nz
	ld b,$05
	jp objectCheckCenteredWithLink


; Subid 4: tokay eyeball slot, waiting to be put in
@state3:
	call objectCheckCollidedWithLink_notDead
	call nc,@resetPushCounter
	call @checkCenteredWithLink
	call nc,@resetPushCounter
	ld h,d
	ld l,Interaction.var3f
	dec (hl)
	jr nz,@state4

	ld a,TREASURE_TOKAY_EYEBALL
	call checkTreasureObtained
	jr c,@haveEyeball

	ld bc,TX_360d
	call showText
	jr @resetPushCounter

@haveEyeball:
	call checkLinkCollisionsEnabled
	jr nc,@resetPushCounter

	; Putting eyeball in
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld hl,mainScripts.pirateSubid4Script_insertEyeball
	call interactionSetScript

@state4:
	call interactionRunScript
	ret nc
	jp interactionDelete

@resetPushCounter:
	ld e,Interaction.var3f
	ld a,10
	ld (de),a
	ret


; ==============================================================================
; INTERACID_PLAY_HARP_SONG
; ==============================================================================
interactionCodec5:
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

@state0:
	call setLinkForceStateToState08
	ld hl,w1Link.yh
	call objectTakePosition
	ld e,Interaction.counter1
	ld a,$04
	ld (de),a
	jp interactionIncState

@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),52 ; [counter1]

	ld a,LINK_ANIM_MODE_HARP_2
	ld (wcc50),a

	call interactionIncState

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@sounds
	rst_addAToHl
	ld a,(hl)
	jp playSound

@sounds:
	.db SND_TUNE_OF_ECHOES
	.db SND_TUNE_OF_CURRENTS
	.db SND_TUNE_OF_AGES


; Facing left
@state2:
@state4:
	ld a,(wFrameCounter)
	and $1f
	jr nz,@stateCommon
	xor a
	ld bc,$f8f8
	call objectCreateFloatingMusicNote

@stateCommon:
	push de
	ld de,w1Link
	callab specialObjectAnimate
	pop de
	call interactionDecCounter1
	ret nz
	ld (hl),52 ; [counter1]
	jp interactionIncState


; Facing right
@state3:
@state5:
	ld a,(wFrameCounter)
	and $1f
	jr nz,@stateCommon

	ld a,$01
	ld bc,$f808
	call objectCreateFloatingMusicNote
	jr @stateCommon


; Signal to a "cutscene handler" that we're done, then delete self
@state6:
	ld hl,wTmpcfc0.genericCutscene.state
	set 7,(hl)
	ld a,LINK_ANIM_MODE_WALK
	ld (wcc50),a
	jp interactionDelete


; ==============================================================================
; INTERACID_BLACK_TOWER_DOOR_HANDLER
; ==============================================================================
interactionCodec6:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


@state0:
	call getThisRoomFlags
	and ROOMFLAG_40
	jr z,@cutsceneNotDone

	; Already did the cutscene. Replace the door with a staircase (functionally, not visually)
	; for some reason...
	ld hl,wRoomLayout+$47
	ld (hl),$44
	jp interactionDelete

@cutsceneNotDone:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jr nc,@noMakuSeed

	; Time to start the cutscene.
.ifndef REGION_JP
	call clearAllItemsAndPutLinkOnGround
.endif
	call resetLinkInvincibility

	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$70
	ld (wLinkStateParameter),a

	ld e,Interaction.counter1
	ld (de),a
	ld hl,w1Link.direction
	ld (hl),$01
	inc l
	ld (hl),$08 ; [w1Link.angle]

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	call interactionIncState
	ld a,PALH_ab
	call loadPaletteHeader
	jp restartSound

@noMakuSeed:
	; Replace door tiles with staircase tiles? This will only affect behaviour (not appearance),
	; so this might be because the door tiles are actually fake for some reason?
	ld a,$44
	ld hl,wRoomLayout+$44
	ld (hl),a
	ld l,$47
	ld (hl),a
	ld l,$4a
	ld (hl),a

	; Prevent them from sending you anywhere
	ld (wDisableWarps),a

	jp interactionDelete


; Delay before making Link face up
@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),30
	xor a ; DIR_UP
	ld hl,w1Link.direction
	ldi (hl),a
	ld (hl),a
	jp interactionIncState


; Delay before starting cutscene
@state2:
	call interactionDecCounter1
	ret nz
	ld b,INTERACID_MAKU_SEED_AND_ESSENCES
	call objectCreateInteractionWithSubid00
	jp interactionDelete


; ==============================================================================
; INTERACID_TINGLE
;
; Variables:
;   var3d: Satchel level (minus one); used by script.
;   var3e: Nonzero if Link has 3 seed types or more
;   var3f: Signal for the script, set to 1 when his "kooloo-limpah" animation ends
; ==============================================================================
interactionCodec8:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a ; [state]

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call objectSetVisiblec0
	ld a,>TX_1e00
	call interactionSetHighTextIndex
	ld a,$06
	call objectSetCollideRadius

	; Count number of seed types Link has
	ldbc TREASURE_EMBER_SEEDS, 00
@checkNextSeed:
	ld a,b
	call checkTreasureObtained
	ld a,$00
	rla
	add c
	ld c,a
	inc b
	ld a,b
	cp TREASURE_MYSTERY_SEEDS+1
	jr nz,@checkNextSeed

	ld a,c
	cp $03
	jr c,++
	ld e,Interaction.var3e
	ld (de),a
++
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_TINGLE_BALLOON
	call objectCopyPosition
	ld l,Part.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d


; Tingle's balloon will change the state to 2 when it gets popped
@state1:
	ret


; Falling from the air
@state3:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jp nz,interactionDecCounter1

	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
	ld hl,mainScripts.tingleScript
	call interactionSetScript
	ld a,$04
	ld e,Interaction.state
	ld (de),a
	ld a,$01
	jr @setAnimation


; Balloon just popped
@state2:
	ld a,$03
	ld (de),a ; [state]
	ld a,15
	ld e,Interaction.counter1
	ld (de),a
	ld a,$02

@setAnimation:
	jp interactionSetAnimation


; On the ground
@state4:
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	ld e,Interaction.var3d
	dec a
	ld (de),a
	call interactionRunScript
	call interactionAnimateAsNpc
	ld e,Interaction.animParameter
	ld a,(de)
	rrca
	jr nc,@label_0b_330

	ld bc,-$200
	call objectSetSpeedZ

	ld bc,$e800
	call objectCreateSparkle
	ld l,Interaction.angle
	ld (hl),$10

	ld bc,$f008
	call objectCreateSparkle
	ld l,Interaction.angle
	ld (hl),$10

	ld bc,$f0f8
	call objectCreateSparkle
	ld l,Interaction.angle
	ld (hl),$10

@label_0b_330:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld e,Interaction.animParameter
	ld a,(de)
	rlca
	ret nc

	xor a
	ld e,Interaction.var3f
	ld (de),a
	ld a,$01
	jr @setAnimation


; ==============================================================================
; INTERACID_SYRUP_CUCCO
;
; Variables:
;   var3c: $00 normally, $01 while cucco is chastizing Link
;   var3d: Animation index?
;   var3e: Also an animation index?
; ==============================================================================
.ifdef ROM_AGES
interactionCodec9:
.else
interactionCode49:
.endif
	call @runState
	jp @updateAnimation

@runState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@updateAnimation:
	ld e,Interaction.var3d
	ld a,(de)
	or a
.ifdef ROM_AGES
	ret z
	jp interactionAnimate
.else
	jr z,+
	call interactionAnimate
+
	jp objectSetVisible80
.endif

@state0:
.ifdef ROM_SEASONS
	call getThisRoomFlags
	and $40
	jp z,interactionDelete
.endif
	ld a,$01
	ld (de),a ; [state]
	call interactionInitGraphics

	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),$06
	inc l
	ld (hl),$06 ; [collisionRadiusX]

	ld l,Interaction.speed
	ld (hl),SPEED_a0
	call @beginHop
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
.ifdef ROM_AGES
	call objectSetVisible80
.endif
	jp @func_7710

@state1:
	call @updateHopping
	call @updateMovement

	; Return if [w1Link.yh] < $69
	ld hl,w1Link.yh
	ld c,$69
	ld b,(hl)
	ld a,$69
	ld l,a
	ld a,c
	cp b
	ret nc

	; Check if he's holding something
	ld a,(wLinkGrabState)
	or a
	ret z

	; Freeze Link
	ld e,Interaction.var3c
	ld a,$02
	ld (de),a
	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a

	ld a,l
	ld hl,w1Link.yh
	ld (hl),a
	jp @initState2

; Unused?
@func_766f:
	xor a
	ld (de),a ; ?
	ld e,Interaction.var3d
	ld (de),a
	ld e,Interaction.var3c
	ld a,$01
	ld (de),a
	ld a,(wLinkGrabState)
	or a
	jr z,@gotoState4

	; Do something with the item Link's holding?
	ld a,(w1Link.relatedObj2+1)
	ld h,a
	ld e,Interaction.var3a
	ld (de),a
	ld hl,mainScripts.syrupCuccoScript_awaitingMushroomText
	jp @setScriptAndGotoState4

@gotoState4:
	ld hl,mainScripts.syrupCuccoScript_awaitingMushroomText

@setScriptAndGotoState4:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	jp interactionSetScript


; Moving toward Link after he tried to steal something
@state2:
	call @updateHopping
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $0c
	ld hl,w1Link.xh
	cp (hl)
	ret nc

	; Reached Link
	ld e,Interaction.var3d
	xor a
	ld (de),a
	ld hl,mainScripts.syrupCuccoScript_triedToSteal
	jp @setScriptAndGotoState4


; Moving back to normal position
@state3:
	call @updateHopping
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	cp $78
	ret c

	xor a
	ld (wDisabledObjects),a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	jp @func_7710


@state4:
	call interactionRunScript
	ret nc

	ld e,Interaction.var3c
	ld a,(de)
	cp $02
	jr z,@beginMovingBack

	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld l,Interaction.var3c
	ld (hl),$00
	ld l,Interaction.var3d
	ld (hl),$01
	xor a
	ld (wDisabledObjects),a
	ret

@beginMovingBack:
	jp @initState3

;;
@updateHopping:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

;;
@beginHop:
	ld bc,-$c0
	jp objectSetSpeedZ

;;
@updateMovement:
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $68
	cp $20
	ret c

	; Reverse direction
	ld e,Interaction.angle
	ld a,(de)
	xor $10
	ld (de),a

	ld e,Interaction.var3e
	ld a,(de)
	xor $01
	ld (de),a
	jp interactionSetAnimation

;;
@func_7710:
	ld h,d
	ld l,Interaction.var3c
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),SPEED_80
	jr +++

;;
@initState2:
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
	ld l,Interaction.speed
	ld (hl),SPEED_200
+++
	ld l,Interaction.var3d
	ld (hl),$01
	ld l,Interaction.angle
	ld (hl),$18
	xor a
	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a
	ld l,Interaction.var3e
	ld a,$00
	ld (hl),a
	jp interactionSetAnimation

;;
@initState3:
	ld h,d
	ld l,Interaction.state
	ld (hl),$03
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld l,Interaction.var3d
	ld (hl),$01
	ld l,Interaction.angle
	ld (hl),$08
	xor a
	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a
	ld l,Interaction.var3e
	ld a,$01
	ld (hl),a
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_TROY
; ==============================================================================
interactionCodeca:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1


@subid0:
	call checkInteractionState
	jr nz,@state1

	; State 0
	call @initialize
	ld a,(wScreenTransitionDirection)
	or a
	jr nz,@state1
	ld (wTmpcfc0.targetCarts.beganGameWithTroy),a

@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


@subid1:
	call checkInteractionState
	jr nz,@state1

	; State 0
	jp @initialize


; Unused
@func_7781:
	call interactionInitGraphics
	jp interactionIncState


@initialize:
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.troySubid0Script
	.dw mainScripts.troySubid1Script


; ==============================================================================
; INTERACID_LINKED_GAME_GHINI
;
; Variables:
;   var3f: Secret index (for "linkedGameNpcScript")
; ==============================================================================
interactionCodecb:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initialize
	ld h,d
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld l,Interaction.var3f
	ld (hl),GRAVEYARD_SECRET & $0f
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript

@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition
	jp interactionAnimateAsNpc

@initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

; Unused
@func_77c7:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_4d00
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.linkedGameNpcScript


; ==============================================================================
; INTERACID_PLEN
; ==============================================================================
interactionCodecc:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0

@subid0:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initialize
	call interactionSetAlwaysUpdateBit

@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc
	call interactionInitGraphics
	jp interactionIncState

@initialize:
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.plenSubid0Script


; ==============================================================================
; INTERACID_MASTER_DIVER
;
; Variables:
;   var3f: Secret index (for "linkedGameNpcScript")
; ==============================================================================
interactionCodecd:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initialize
	ld l,Interaction.var3f
	ld (hl),DIVER_SECRET & $0f
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript

@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition
	jp interactionAnimateAsNpc

@initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

;;
; Unused
@func_7840:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	; Apparently this is empty


; ==============================================================================
; INTERACID_GREAT_FAIRY
;
; Variables:
;   var3e: ?
;   var3f: Secret index (for "linkedGameNpcScript")
; ==============================================================================
interactionCoded5:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw _greatFairy_subid0
	.dw _greatFairy_subid1


; Linked game NPC
_greatFairy_subid0:
	call checkInteractionState
	jr nz,@state1

@state0:
	call _greatFairy_initialize
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.zh
	ld (hl),$f0
	ld l,Interaction.var3f
	ld (hl),TEMPLE_SECRET & $0f
	call interactionRunScript

@state1:
	call returnIfScrollMode01Unset
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition

	ld e,Interaction.var3e
	ld a,(de)
	or a
	ret nz
	call interactionAnimateAsNpc

	; Update Z position every 8 frames (floats up and down)
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,@zPositions
	rst_addAToHl
	ld e,Interaction.zh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@zPositions:
	.db $ff $fe $ff $00 $01 $02 $01 $00


; Cutscene after being healed from being an octorok
_greatFairy_subid1:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,SND_PIECE_OF_POWER
	call playSound

	call _greatFairy_initialize
	call objectSetVisiblec1
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.zh
	ld (hl),$f0
	ld l,Interaction.counter1
	ld a,180
	ldi (hl),a
	ld (hl),$02 ; [counter2]

	ldbc INTERACID_SPARKLE, $04
	call objectCreateInteraction
	ld l,Interaction.counter1
	ld (hl),120

	; Create sparkles
	ld b,$00
--
	push bc
	ldbc INTERACID_SPARKLE, $0a
	call objectCreateInteraction
	pop bc
	ld l,Interaction.angle
	ld (hl),b
	ld a,b
	add $04
	ld b,a
	bit 5,a
	jr z,--
	ret

@state1:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$40
	ld l,Interaction.angle
	ld (hl),$08
	ld l,Interaction.speed
	ld (hl),SPEED_300
	ld bc,TX_4109
	call showText
	jp interactionIncSubstate

@substate1:
	call retIfTextIsActive
	call objectApplySpeed

	; Update angle (moving in a circle)
	call interactionDecCounter2
	jr nz,@updateSparklesAndSoundEffect
	ld (hl),$02
	ld l,Interaction.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a
	call interactionDecCounter1
	jp z,interactionIncSubstate

@updateSparklesAndSoundEffect:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ldbc INTERACID_SPARKLE, $02
	call objectCreateInteraction
	ld a,(wFrameCounter)
	and $1f
	ld a,SND_MAGIC_POWDER
	call z,playSound
	ret

; Moving up out of the screen
@substate2:
	call @updateSparklesAndSoundEffect
	ld h,d
	ld l,Interaction.zh
	ld a,(hl)
	sub $02
	ld (hl),a
	cp $b0
	ret nc
	call fadeoutToWhite
	jp interactionIncSubstate

; Transition to next part of cutscene
@substate3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,CUTSCENE_CLEAN_SEAS
	ld (wCutsceneTrigger),a
	jp interactionDelete

;;
; Unused
@func_795a:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


_greatFairy_initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.greatFairySubid0Script


; ==============================================================================
; INTERACID_DEKU_SCRUB
;
; Variables:
;   var3e: 0 if the deku scrub is hiding, 1 if not
;   var3f: Secret index (for "linkedGameNpcScript")
; ==============================================================================
interactionCoded6:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initialize
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.var3f
	ld (hl),DEKU_SECRET & $0f
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	call interactionRunScript

@state1:
	call interactionRunScript
	jp c,interactionDeleteAndUnmarkSolidPosition

	call interactionAnimateAsNpc
	ld c,$20
	call objectCheckLinkWithinDistance
	ld h,d
	ld l,Interaction.var3e
	jr c,@linkIsClose

	ld a,(hl) ; [var3e]
	or a
	ret z
	xor a
	ld (hl),a
	ld a,$03
	jp interactionSetAnimation

@linkIsClose:
	ld a,(hl) ; [var3e]
	or a
	ret nz
	inc (hl) ; [var3e]
	ld a,$01
	jp interactionSetAnimation

@initialize:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


; ==============================================================================
; INTERACID_MAKU_SEED_AND_ESSENCES
;
; Variables:
;   counter1: Essence index (for the maku seed / spawner object)
; ==============================================================================
interactionCoded7:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interactiond7_makuSeed
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence


interactiond7_makuSeed:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	ld a,(w1Link.yh)
	sub $0e
	ld e,Interaction.yh
	ld (de),a
	ld a,(w1Link.xh)
	ld e,Interaction.xh
	ld (de),a

	call setLinkForceStateToState08

	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_DROPESSENCE
	call playSound

	ldbc INTERACID_SPARKLE, $04
	call objectCreateInteraction
	ret nz
	ld l,Interaction.counter1
	ld e,l
	ld a,120
	ld (hl),a
	ld (de),a
	jp objectSetVisible82

@state1:
	ld a,LINK_ANIM_MODE_GETITEM2HAND
	ld (wcc50),a

	call interactionDecCounter1
	ret nz
	ld (hl),$40 ; [counter1]
	ld l,Interaction.speed
	ld (hl),SPEED_80
	jp interactionIncState

@state2:
	call objectApplySpeed
	call _interactiond7_updateSmallSparkles
	call interactionDecCounter1
	ret nz

	ld (hl),120 ; [counter1]
	ld a,LINK_ANIM_MODE_WALK
	ld (wcc50),a
	ld l,Interaction.yh
	ld (hl),$58
	ld l,Interaction.xh
	ld (hl),$78
	ld a,SND_PIECE_OF_POWER
	call playSound
	ld a,$03
	call fadeinFromWhiteWithDelay
	jp interactionIncState

@state3:
	call _interactiond7_updateSmallSparkles
	call _interactiond7_updateFloating
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state3Substate0
	.dw @state3Substate1
	.dw @state3Substate2
	.dw @state3Substate3
	.dw @state3Substate4
	.dw @state3Substate5
	.dw @state3Substate6
	.dw @state3Substate7
	.dw @state3Substate8
	.dw @state3Substate9

@state3Substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),20
	inc l
	ld (hl),$08
	jp interactionIncSubstate


; Spawning the essences
@state3Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),20
	inc l
	dec (hl)
	ld b,(hl)

	; Spawn next essence
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MAKU_SEED_AND_ESSENCES
	call objectCopyPosition
	ld a,b
	ld bc,@essenceSpawnerData
	call addDoubleIndexToBc

	ld a,(bc)
	ld l,Interaction.subid
	ld (hl),a
	ld l,Interaction.angle
	inc bc
	ld a,(bc)
	ld (hl),a
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),120
	ret

; b0: subid
; b1: angle (the direction it moves out from the maku seed)
@essenceSpawnerData:
	.db $08 $1a
	.db $07 $16
	.db $06 $12
	.db $05 $0e
	.db $04 $0a
	.db $03 $06
	.db $02 $02
	.db $01 $1e


; All essences spawned. Delay before next state.
@state3Substate2:
	call interactionDecCounter1
	ret nz
	ld (hl),60 ; [counter1]
	ld a,$01
	ld (wTmpcfc0.genericCutscene.state),a
	ld a,$20
	ld (wTmpcfc0.genericCutscene.cfc1),a
	jp interactionIncSubstate


; Essences rotating & moving in
@state3Substate3:
@state3Substate5:
@state3Substate7:
	ld a,(wFrameCounter)
	and $03
	jr nz,@essenceRotationCommon
	ld hl,wTmpcfc0.genericCutscene.cfc1
	dec (hl)
	jr @essenceRotationCommon


; Essences rotating & moving out
@state3Substate4:
@state3Substate6:
	ld a,(wFrameCounter)
	and $03
	jr nz,@essenceRotationCommon
	ld hl,wTmpcfc0.genericCutscene.cfc1
	inc (hl)

@essenceRotationCommon:
	call interactionDecCounter1
	ret nz
	ld (hl),60
	jp interactionIncSubstate


; Fadeout as the essences leave the screen
@state3Substate8:
	ld hl,wTmpcfc0.genericCutscene.cfc1
	inc (hl)
	ld a,SND_FADEOUT
	call playSound
	ld a,$04
	call fadeoutToWhiteWithDelay
	jp interactionIncSubstate


; Waiting for fadeout to end
@state3Substate9:
	ld hl,wTmpcfc0.genericCutscene.cfc1
	inc (hl)
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionIncState
	inc l
	ld (hl),$00
	jp objectSetInvisible


@state4:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state4Substate0
	.dw @state4Substate1
	.dw @state4Substate2
	.dw @state4Substate3
	.dw @state4Substate4


; Modifying the room layout so only 1 door remains.
@state4Substate0:
	ld hl,@tileReplacements
--
	ldi a,(hl)
	or a
	jr z,++
	ld c,(hl)
	inc hl
	push hl
	call setTile
	pop hl
	jr --
++
	ld e,Interaction.counter1
	ld a,30
	ld (de),a
	jp interactionIncSubstate

; b0: tile position
; b1: tile index
@tileReplacements:
	.db $a3 $33
	.db $a3 $34
	.db $a3 $35
	.db $b7 $43
	.db $b7 $44
	.db $b7 $45
	.db $88 $53
	.db $88 $54
	.db $88 $55
	.db $a3 $39
	.db $a3 $3a
	.db $a3 $3b
	.db $b7 $49
	.db $b7 $4a
	.db $b7 $4b
	.db $88 $59
	.db $88 $5a
	.db $88 $5b
	.db $00


; Delay before fading back in
@state4Substate1:
	call interactionDecCounter1
	ret nz
	ld (hl),120
	ld a,$08
	call fadeinFromWhiteWithDelay
	jp interactionIncSubstate


; Fading back in
@state4Substate2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,SND_SOLVEPUZZLE_2
	call playSound
	jp interactionIncSubstate


@state4Substate3:
	call interactionDecCounter1
	ret nz
	call getThisRoomFlags
	set 6,(hl)

	; Change the door tile?
	ld hl,wRoomLayout+$47
	ld (hl),$44

	call checkIsLinkedGame
	jr z,@@unlinkedGame

	call fadeoutToBlack
	jp interactionIncSubstate

@@unlinkedGame:
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld a,(wActiveMusic)
	call playSound
	jp interactionDelete


; Linked game only: trigger cutscene
@state4Substate4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,CUTSCENE_FLAME_OF_SORROW
	ld (wCutsceneTrigger),a
	jp interactionDelete


interactiond7_essence:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a ; [state]
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$10
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld a,SND_POOF
	call playSound
	call objectCenterOnTile
	ld l,Interaction.z
	xor a
	ldi (hl),a
	ld (hl),a
	call interactionInitGraphics
	jp objectSetVisible80

@state1:
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	jp interactionIncState

@state2:
	ld a,(wTmpcfc0.genericCutscene.state)
	or a
	ret z
	jp interactionIncState

@state3:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	ld a,(wFrameCounter)
	rrca
	ret c
	ld h,d
	ld l,Interaction.angle
	inc (hl)
	ld a,(hl)
	and $1f
	ld (hl),a
	ld e,l
	or a
	call z,@playCirclingSound
	ld bc,$5878
	ld a,(wTmpcfc0.genericCutscene.cfc1)
	jp objectSetPositionInCircleArc

@playCirclingSound:
	ld a,SND_CIRCLING
	jp playSound

;;
_interactiond7_updateSmallSparkles:
	ld a,(wFrameCounter)
	and $07
	ret nz

	ldbc INTERACID_SPARKLE, $03
	call objectCreateInteraction
	ret nz

	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld bc,@sparklePositionOffsets
	call addDoubleIndexToBc
	ld l,Interaction.yh
	ld a,(bc)
	add (hl)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	add (hl)
	ld (hl),a
	ret

@sparklePositionOffsets:
	.db $10 $02
	.db $10 $fe
	.db $08 $05
	.db $08 $fb
	.db $0c $08
	.db $0c $f8
	.db $06 $0b
	.db $06 $f5

;;
; Updates Z-position based on frame counter.
_interactiond7_updateFloating:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,@zPositions
	rst_addAToHl
	ld e,Interaction.zh
	ld a,(hl)
	ld (de),a
	ret

@zPositions:
	.db $ff $fe $ff $00 $01 $02 $01 $00


; ==============================================================================
; INTERACID_LEVER_LAVA_FILLER
;
; Variables:
;   counter2: Number of frames between two lava tiles being filled. Effectively this sets the
;             "speed" of the lava filler (lower is faster).
; ==============================================================================
interactionCoded8:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@counter2Vals
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.counter2
	ld (de),a
	jp interactionIncState

@counter2Vals:
	.db $04 $06 $06 $06 $06 $06 $06 $06


; Waiting for lever to be pulled
@state1:
	ld a,(wLever1PullDistance)
	bit 7,a
	ret z

	; Lever has been pulled all the way.

	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30

	ld a,SND_SOLVEPUZZLE
	call playSound

	call @loadScriptForSubid

@toggleLavaSource:
	ld b,$06
	ld a,TILEINDEX_LAVA_SOURCE_UP_LEFT
	call findTileInRoom
	jr z,@setOrUnsetLavaSource

	ld a,TILEINDEX_LAVA_SOURCE_DOWN_LEFT
	call findTileInRoom
	jr z,@setOrUnsetLavaSource

	ld b,$fa
	ld a,TILEINDEX_LAVA_SOURCE_UP_LEFT_EMPTY
	call findTileInRoom
	jr z,@setOrUnsetLavaSource

	ld a,TILEINDEX_LAVA_SOURCE_DOWN_LEFT_EMPTY
	call findTileInRoom

; Turns the lava source "on" or "off", visually (by adding or subtracting 6 from the tile index).
@setOrUnsetLavaSource:
	ld a,b
	ldh (<hFF8D),a
	call @updateTile
--
	inc l
	ld a,(hl)
	sub TILEINDEX_LAVA_SOURCE_UP_LEFT
	cp $0c
	ret nc
	call @updateTile
	jr --

@updateTile:
	ldh a,(<hFF8D)
	ld b,(hl)
	add b
	ld c,l
	push hl
	call setTile
	pop hl
	ret

@loadScriptForSubid:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetMiniScript


; Floor is being filled
@state2:
	call interactionDecCounter1
	ret nz

	; Fill next group of tiles
	inc l
	ldd a,(hl)
	ld (hl),a  ; [counter1] = [counter2]
	call interactionGetMiniScript
	ldi a,(hl)
	or a
	jp z,interactionIncState

--
	ld c,a
	ld a,TILEINDEX_DRIED_LAVA
	push hl
	call setTileInAllBuffers
	pop hl
	ldi a,(hl)
	or a
	jr nz,--

	call interactionSetMiniScript
	jp @playRumbleSound


; Tiles have been filled. Waiting for lever to revert to starting position.
@state3:
	ld a,(wLever1PullDistance)
	or a
	ret nz

	call interactionIncState
	call @loadScriptForSubid
	call @toggleLavaSource
	ld a,SND_DOORCLOSE
	jp playSound


; Tiles are being filled with lava again.
@state4:
	call interactionDecCounter1
	ret nz
	inc l
	ldd a,(hl)
	ld (hl),a  ; [counter1] = [counter2]
	call interactionGetMiniScript
	ldi a,(hl)
	or a
	jr nz,@fillNextGroupWithLava

	; Done filling the lava back.
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret

@fillNextGroupWithLava:
	ld c,a

	; Random lava tile
	call getRandomNumber
	and $03
	add TILEINDEX_DUNGEON_LAVA_1

	push hl
	call setTileInAllBuffers
	pop hl
	ldi a,(hl)
	or a
	jr nz,@fillNextGroupWithLava

	call interactionSetMiniScript
	jp @playRumbleSound

@playRumbleSound:
	ld a,SND_RUMBLE2
	jp playSound


; "Script" format:
;   A string of bytes, ending with "$00", is a list of tile positions to fill with lava on a frame.
;   The data following the "$00" bytes will be read on a later frame. The gap between frames depends
;   on the value of [counter2].
;   If data starts with "$00", the list is done being read.
@scriptTable:
	.dw @subid0Script
	.dw @subid1Script
	.dw @subid2Script
	.dw @subid3Script
	.dw @subid4Script
	.dw @subid5Script

; D4, 1st lava-filler room
@subid0Script:
	.db $2a $00
	.db $2b $00
	.db $29 $00
	.db $3b $00
	.db $39 $00
	.db $4b $00
	.db $4a $00
	.db $49 $00
	.db $5b $00
	.db $5a $00
	.db $59 $00
	.db $6b $00
	.db $6a $00
	.db $7b $00
	.db $8b $00
	.db $7a $00
	.db $8a $00
	.db $9a $00
	.db $69 $00
	.db $99 $00
	.db $89 $00
	.db $79 $00
	.db $98 $00
	.db $88 $00
	.db $97 $00
	.db $78 $00
	.db $96 $00
	.db $88 $00
	.db $87 $00
	.db $95 $00
	.db $86 $00
	.db $85 $00
	.db $77 $00
	.db $76 $00
	.db $75 $00
	.db $66 $00
	.db $65 $00
	.db $56 $00
	.db $55 $00
	.db $45 $00
	.db $35 $00
	.db $00

; D4, 2 rooms before boss key
@subid1Script:
	.db $77 $78 $79 $00
	.db $7a $69 $68 $67 $66 $76 $00
	.db $6a $65 $75 $00
	.db $64 $74 $00
	.db $84 $85 $00
	.db $94 $95 $00
	.db $83 $93 $00
	.db $82 $92 $00
	.db $81 $91 $00
	.db $71 $72 $00
	.db $61 $62 $00
	.db $51 $52 $00
	.db $41 $42 $00
	.db $31 $32 $00
	.db $21 $22 $00
	.db $11 $12 $00
	.db $13 $23 $00
	.db $14 $24 $00
	.db $34 $00
	.db $44 $00
	.db $35 $45 $00
	.db $36 $00
	.db $46 $00
	.db $47 $26 $00
	.db $16 $27 $48 $00
	.db $28 $38 $49 $00
	.db $29 $39 $00
	.db $00

; D4, 1 room before boss key
@subid2Script:
	.db $37 $38 $39 $00
	.db $47 $48 $49 $00
	.db $58 $59 $00
	.db $68 $00
	.db $67 $00
	.db $77 $00
	.db $87 $00
	.db $96 $00
	.db $85 $00
	.db $75 $00
	.db $55 $64 $00
	.db $56 $00
	.db $73 $45 $00
	.db $83 $35 $00
	.db $25 $00
	.db $92 $15 $00
	.db $81 $00
	.db $71 $00
	.db $61 $00
	.db $51 $00
	.db $42 $00
	.db $33 $00
	.db $13 $22 $00
	.db $21 $00
	.db $00

; D8, lava room with keyblock
@subid3Script:
	.db $24 $25 $26 $00
	.db $34 $35 $36 $00
	.db $44 $45 $46 $00
	.db $54 $55 $00
	.db $64 $65 $00
	.db $73 $74 $75 $00
	.db $83 $00
	.db $81 $82 $00
	.db $91 $92 $00
	.db $93 $00
	.db $94 $00
	.db $95 $00
	.db $96 $00
	.db $86 $00
	.db $77 $87 $97 $00
	.db $78 $88 $00
	.db $79 $89 $99 $00
	.db $7a $8a $9a $00
	.db $6a $00
	.db $5a $00
	.db $59 $00
	.db $58 $00
	.db $48 $00
	.db $00

; D8, other lava room
@subid4Script:
	.db $24 $25 $26 $00
	.db $34 $35 $17 $27 $00
	.db $36 $37 $00
	.db $44 $45 $46 $47 $00
	.db $18 $28 $38 $48 $00
	.db $57 $58 $39 $49 $00
	.db $55 $56 $19 $29 $00
	.db $54 $59 $00
	.db $68 $69 $4a $5a $00
	.db $67 $3a $6a $00
	.db $65 $66 $1a $2a $00
	.db $64 $6b $7a $7b $00
	.db $78 $79 $4b $5b $00
	.db $76 $77 $2b $3b $00
	.db $74 $75 $1b $00
	.db $8a $8b $5c $6c $00
	.db $88 $89 $3c $4c $00
	.db $86 $87 $1c $2c $00
	.db $84 $85 $5d $6d $00
	.db $73 $83 $4d $00
	.db $1d $2d $3d $00
	.db $71 $72 $82 $00
	.db $81 $97 $99 $9b $00
	.db $91 $92 $93 $95 $00
	.db $94 $96 $98 $9a $00
	.db $00

; Hero's Cave lava room
@subid5Script:
	.db $26 $28 $27 $00
	.db $25 $00
	.db $35 $00
	.db $34 $00
	.db $44 $54 $43 $00
	.db $42 $64 $00
	.db $52 $74 $00
	.db $84 $00
	.db $93 $94 $95 $00
	.db $92 $96 $00
	.db $82 $91 $97 $00
	.db $81 $87 $00
	.db $77 $88 $00
	.db $78 $89 $00
	.db $8a $00
	.db $7a $8b $00
	.db $6a $7b $8c $00
	.db $5a $8d $9c $00
	.db $5b $9d $00
	.db $5c $00
	.db $4c $5d $6c $00
	.db $6d $00
	.db $3c $00
	.db $3d $00
	.db $2b $2d $00
	.db $1b $1d $00
	.db $00


; ==============================================================================
; INTERACID_SLATE_SLOT
;
; Variables:
;   var3f: Counter to push against this object until the slate will be placed
; ==============================================================================
interactionCodedb:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; Check if slate already placed
	ld e,Interaction.subid
	ld a,(de)
	ld bc,bitTable
	add c
	ld c,a
	call getThisRoomFlags
	ld a,(bc)
	and (hl)
	jp nz,interactionDelete

	ld hl,mainScripts.slateSlotScript
	call interactionSetScript
	jp interactionIncState

@state1:
	call objectCheckCollidedWithLink_notDead
	call nc,@resetCounter
	call objectCheckLinkPushingAgainstCenter
	call nc,@resetCounter

	ld h,d
	ld l,Interaction.var3f
	dec (hl)
	jr nz,@state2

	; Time to place the slate, if available
	ld a,(wNumSlates)
	or a
	jr nz,@placeSlate

	; Not enough slates
	ld bc,TX_5111
	call showText

@resetCounter:
	ld e,Interaction.var3f
	ld a,$0a
	ld (de),a
	ret

@placeSlate:
	call checkLinkVulnerable
	jr nc,@resetCounter

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld hl,mainScripts.slateSlotScript_placeSlate
	call interactionSetScript
	call interactionIncState

@state2:
	call interactionRunScript
	ret nc
	jp interactionDelete

.ends
