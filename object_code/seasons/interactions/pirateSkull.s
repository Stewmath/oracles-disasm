; ==================================================================================================
; INTERAC_PIRATE_SKULL
; ==================================================================================================
interactionCode4d:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_TALKED_WITH_GHOST_PIRATE
	call checkGlobalFlag
	jp z,interactionDelete
	ld c,INTERAC_PIRATE_SKULL
	call objectFindSameTypeObjectWithID
	jr nz,+
	; delete if carrying the skull
	ld a,h
	cp d
	jp nz,interactionDelete
	call func_228f
	jp z,interactionDelete
+
	ld a,TREASURE_PIRATES_BELL
	call checkTreasureObtained
	jr c,+
	call getRandomNumber
	and $03
	inc a
	ld e,$78
	ld (de),a
+
	ld a,>TX_4d00
	call interactionSetHighTextIndex
	ld hl,mainScripts.pirateSkullScript_notYetCarried
	call interactionSetScript
	call interactionInitGraphics
	jp objectSetVisiblec2
@@state1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	call objectPreventLinkFromPassing
	jp interactionRunScript
@@@substate1:
	ld e,$7a
	ld a,(de)
	or a
	jr z,+
	ld b,a
	inc e
	ld a,(de)
	ld c,a
	push bc
	call objectCheckContainsPoint
	pop bc
	jr c,++
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	ld e,$50
	ld a,$14
	ld (de),a
	call objectApplySpeed
+
	ld h,d
	ld l,$7a
	xor a
	ldi (hl),a
	ld (hl),a
	jp objectAddToGrabbableObjectBuffer
++
	ld bc,TX_4d0a
	call showText
	jp interactionDelete
@@state2:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
@@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	xor a
	ld (wLinkGrabState2),a
	ld l,$79
	ld (hl),a
	inc a
	call interactionSetAnimation
	jp objectSetVisiblec1
@@@substate1:
	ld hl,$ccc1
	bit 7,(hl)
	ld e,$78
	ld a,(de)
	ld (hl),a
	jr nz,+
	ld e,$46
	ld a,$14
	ld (de),a
	ld a,$01
	jp interactionSetAnimation
+
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	ld (hl),$14
	ld a,$7e
	jp playSound
@@@substate2:
	call objectCheckWithinRoomBoundary
	jp nc,interactionDelete
	call objectReplaceWithAnimationIfOnHazard
	jr c,@@@droppedInWater
	ld h,d
	ld l,$40
	res 1,(hl)
	ld l,$79
	ld (hl),d
	ret
@@@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call objectReplaceWithAnimationIfOnHazard
	jr c,@@@droppedInWater
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	ld h,d
	ld l,$40
	res 1,(hl)
	ld l,$44
	ld a,$01
	ldi (hl),a
	ld (hl),a
	ld l,$79
	ld a,(hl)
	or a
	ld bc,TX_4d06
	call nz,showText
	xor a
	call interactionSetAnimation
	jp objectSetVisible82
@@@droppedInWater:
	ld bc,TX_4d09
	jp showText
@subid1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
@@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ld a,$01
	ld ($cca4),a
	ld a,($d00b)
	ld e,$4b
	ld (de),a
	ld a,($d00d)
	ld e,$4d
	ld (de),a
	jp interactionInitGraphics
@@state1:
	ld a,($d00f)
	or a
	ret nz
	ld a,$02
	ld (de),a
	call objectGetZAboveScreen
	ld e,$4f
	ld (de),a
	call setLinkForceStateToState08
	jp objectSetVisiblec1
@@state2:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	ret nz
	call interactionIncState
	ld l,$50
	ld (hl),$14
	ld l,$49
	ld (hl),$10
	ld a,$02
	ld ($cc6b),a
	ld a,$ca
	jp playSound
@@state3:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZAndBounce
	push af
	ld a,$ca
	call z,playSound
	pop af
	ret nc
	call interactionIncState
	ld l,$46
	ld (hl),$28
	jp objectSetVisible82
@@state4:
	call interactionDecCounter1
	ret nz
	ld l,$44
	inc (hl)
	xor a
	ld ($cca4),a
	ld bc,TX_4d07
	jp showText
@@state5:
	ld a,($cfc0)
	or a
	ret z
	call objectCreatePuff
	jp interactionDelete
