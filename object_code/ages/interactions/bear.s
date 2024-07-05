; ==================================================================================================
; INTERAC_BEAR
; ==================================================================================================
interactionCode5d:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw bear_state0
	.dw bear_state1


bear_state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid
	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02

@initSubid00:
	; If you've talked to the bear already, shift him down 16 pixels
	call getThisRoomFlags
	bit 7,a
	jr nz,++

	ld e,Interaction.yh
	ld a,(de)
	add $10
	ld (de),a
++
	ld hl,mainScripts.bearSubid00Script_part1
	jp interactionSetScript

@initSubid01:
	ret

@initSubid02:
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr nz,@var03IsNonzero

	; var03 is $00.

	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	jp z,interactionDelete

	; Spawn animal buddies
	ld hl,objectData.animalsWaitingForNayru
	call parseGivenObjectData

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,GLOBALFLAG_MAKU_TREE_SAVED
	call checkGlobalFlag
	jp z,interactionDelete

	; Text changes after saving Nayru
	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ld a,$00
	jp z,+
	inc a
+
	jr ++

@var03IsNonzero:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,$02
++
	call @chooseTextID
	ld hl,mainScripts.bearSubid02Script
	jp interactionSetScript

@chooseTextID:
	ld hl,@textIDs
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.textID
	ld (de),a
	ld a,>TX_5700
	inc e
	ld (de),a
	ret

@textIDs:
	.db <TX_5712
	.db <TX_5713
	.db <TX_5714


bear_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw interactionAnimate
	.dw @runSubid02


; Bear listening to Nayru at start of game.
@runSubid00:
	call interactionAnimateAsNpc
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call interactionRunScript

	; Wait for Link to get close enough to trigger the cutscene
	ld hl,w1Link.xh
	ld a,(hl)
	cp $60
	ret c
	ld l,<w1Link.yh
	ld a,(hl)
	cp $3e
	ret nc

	; Put Link into the cutscene state
	ld a,SPECIALOBJECT_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$03

	ld hl,mainScripts.bearSubid00Script_part2
	call interactionSetScript
	call interactionIncSubstate

@substate1:
	call interactionRunScript
	ld a,($cfd0)
	cp $0e
	ret nz
	call interactionIncSubstate
	ld a,$02
	jp interactionSetAnimation

@substate2:
	call interactionAnimate
	ld a,($cfd0)
	cp $10
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),40
	ret

@substate3:
	call interactionDecCounter1
	jp nz,interactionAnimate
	call interactionIncSubstate
	ld l,Interaction.angle
	ld (hl),$02
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld a,$01
	jp interactionSetAnimation

@substate4:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	call objectApplySpeed
	jp interactionAnimate


@runSubid02:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc
