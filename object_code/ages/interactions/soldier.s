; ==================================================================================================
; INTERAC_SOLDIER
; ==================================================================================================
interactionCode40:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw soldierSubid00
	.dw soldierSubid01
	.dw soldierSubid02
	.dw soldierSubid03
	.dw soldierSubid04
	.dw soldierSubid05
	.dw soldierSubid06
	.dw soldierSubid07
	.dw soldierSubid08
	.dw soldierSubid09
	.dw soldierSubid0a
	.dw soldierSubid0b
	.dw soldierSubid0c
	.dw soldierSubid0d

soldierSubid00:
soldierSubid01:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	ld e,Interaction.var03
	ld a,(de)
	jr nz,label_09_090
	or a
	jp nz,interactionDelete
	jr soldierSubid0c

label_09_090:
	or a
	jp z,interactionDelete


soldierSubid0c:
	call checkInteractionState
	jr nz,label_09_092
	call soldierInitGraphicsAndLoadScript
label_09_092:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


; Palace guards
soldierSubid02:
soldierSubid09:
	call checkInteractionState
	jr nz,label_09_093
	call soldierCheckBeatD6
	jp nc,interactionDelete
	call soldierInitGraphicsAndLoadScript
	call objectSetVisible82
label_09_093:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	call soldierUpdateAnimationAndRunScript
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld a,GLOBALFLAG_10
	call checkGlobalFlag
	jr z,label_09_094
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	ret z
label_09_094:
	jp objectPreventLinkFromPassing


soldierSubid03:
	call checkInteractionState
	jr nz,label_09_095
	call soldierCheckBeatD6
	jp nc,interactionDelete
	call soldierInitGraphicsAndLoadScript
	jp objectSetVisible82
label_09_095:
	call interactionRunScript
	jp interactionAnimate


; Guard who gives bombs to Link
soldierSubid04:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierCheckBeatD6
	jp nc,interactionDelete
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	call soldierInitGraphicsAndLoadScript
	ld e,Interaction.oamFlags
	ld a,$03
	ld (de),a
	jp objectSetVisiblec2

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw soldierSubid04Substate0
	.dw soldierSubid04Substate1
	.dw soldierSubid04Substate2
	.dw soldierSubid04Substate3
	.dw soldierSubid04Substate4

soldierSubid04Substate0:
	ld a,($cfd1)
	cp $06
	jr nz,soldierUpdateAnimationAndRunScript

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),30
	xor a
	jp interactionSetAnimation

soldierUpdateAnimationAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript

soldierSubid04Substate1:
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld bc,$fe40
	call objectSetSpeedZ
	ld a,SND_JUMP
	jp playSound

soldierSubid04Substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$08
	ld a,$02
	jp interactionSetAnimation

soldierSubid04Substate3:
	call interactionDecCounter1
	ret nz
	ld l,Interaction.angle
	ld (hl),$10
	ld l,Interaction.speed
	ld (hl),SPEED_200
	jp interactionIncSubstate

soldierSubid04Substate4:
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	jp interactionAnimateBasedOnSpeed


; Guard escorting Link in intermediate screens (just moves straight up)
soldierSubid05:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierCheckBeatD6
	jp nc,interactionDelete

	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	call soldierInitGraphicsAndLoadScript
	xor a
	call interactionSetAnimation
	ld hl,w1Link.xh
	ld (hl),$50
	jp objectSetVisible82

@state1:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	call objectGetTileAtPosition
	cp TILEINDEX_STAIRS
	ld a,SPEED_100
	jr nz,+
	ld a,SPEED_a0
+
	ld e,Interaction.speed
	ld (de),a
	call interactionRunScript
	jp interactionAnimate2Times


; Guard in cutscene who takes mystery seeds from Link
soldierSubid06:
	call checkInteractionState
	jr nz,@state1

	call soldierCheckBeatD6
	jp nc,interactionDelete
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	call soldierInitGraphicsAndLoadScript
	xor a
	call interactionSetAnimation
	jp objectSetVisible82

@state1:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	ld a,(w1Link.yh)
	cp $68
	jr nz,@substate1

	xor a
	ld (wUseSimulatedInput),a
	inc a
	ld (wDisabledObjects),a
	call interactionIncSubstate

@substate1:
	jp soldierUpdateAnimationAndRunScript


; Guard just after Link is escorted out of the palace
soldierSubid07:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierCheckBeatD6
	jp nc,interactionDelete
	call soldierInitGraphicsAndLoadScript
	jp objectSetVisible82

@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc


; Used in a cutscene? (doesn't do anything)
soldierSubid08:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierInitGraphics
	ld l,Interaction.oamFlags
	ld (hl),$03
	jp objectSetVisible82

@state1:
	callab scriptHelp.turnToFaceSomething
	jp interactionAnimate


; Red soldier that brings you to Ambi (escorts you from deku forest)
soldierSubid0a:
	call checkInteractionState
	jr nz,@state1

@state0:
	call soldierInitGraphicsAndLoadScript
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld bc,$68f0
	jp interactionSetPosition

@state1:
	call soldierUpdateAnimationAndRunScript
	ret nc
	ld hl,wcc05
	set 1,(hl)
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_AGES_146, $00, $34, $03


; Red soldier that brings you to Ambi (just standing there after taking you)
soldierSubid0b:
	call checkInteractionState
	jp nz,interactionAnimate

@state0:
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,TREASURE_MYSTERY_SEEDS
	call checkTreasureObtained
	jp nc,interactionDelete

	call soldierInitGraphics
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld a,$01
	call interactionSetAnimation
	jp objectSetVisible82


; Friendly soldier after finishing game. var03 is soldier index.
soldierSubid0d:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	call soldierInitGraphicsAndLoadScript
	ld e,Interaction.var03
	ld a,(de)
	ld l,Interaction.oamFlags
	ld (hl),$01
	cp $07
	jr c,+
	inc (hl)
+
	ld bc,@behaviours
	call addAToBc
	ld a,(bc)
	ld l,Interaction.var3b
	ld (hl),a
	call interactionRunScript
	jr @state1

@behaviours:
	.db $01 $02 $00 $00 $00 $00 $00 $03
	.db $00 $00 $00 $00 $00 $00 $00 $00

@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3b
	ld a,(de)
	or a
	jr nz,++
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate
++
	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate

	call interactionAnimateBasedOnSpeed
	jp interactionPushLinkAwayAndUpdateDrawPriority


soldierInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


soldierInitGraphicsAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	ld hl,soldierScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState


linkEnterPalaceSimulatedInput:
	dwb $7fff BTN_UP
	.dw $ffff

linkExitPalaceSimulatedInput
	dwb 30    $00
	dwb 40    BTN_DOWN
	dwb $7fff $00
	.dw $ffff

;;
; @param[out]	cflag	nc if dungeon 6 is beaten (can enter the palace)
soldierCheckBeatD6:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr nc,++
	call getHighestSetBit
	cp $05
	ret
++
	scf
	ret

soldierScriptTable:
	.dw mainScripts.soldierSubid00Script
	.dw mainScripts.soldierSubid01Script
	.dw mainScripts.soldierSubid02Script
	.dw mainScripts.soldierSubid03Script
	.dw mainScripts.soldierSubid04Script
	.dw mainScripts.soldierSubid05Script
	.dw mainScripts.soldierSubid06Script
	.dw mainScripts.soldierSubid07Script
	.dw mainScripts.stubScript
	.dw mainScripts.soldierSubid09Script
	.dw mainScripts.soldierSubid0aScript
	.dw mainScripts.stubScript
	.dw mainScripts.soldierSubid0cScript
	.dw mainScripts.soldierSubid0dScript
