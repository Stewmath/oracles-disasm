; ==================================================================================================
; INTERAC_BIRD
; ==================================================================================================
interactionCode2a:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	cp $0a
	jr z,@birdWithImpa
	cp $0b
	jr nz,@knowItAllBird
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp nz,interactionDelete
	ld hl,mainScripts.panickingBirdScript
	jr @setScript
@knowItAllBird:
	ld hl,mainScripts.knowItAllBirdScript
@setScript:
	call interactionSetScript

	call getRandomNumber_noPreserveVars
	and $01
	ld e,$48
	ld (de),a
	call interactionSetAnimation
	call interactionSetAlwaysUpdateBit
	
	ld l,$76
	ld (hl),$1e
	
	call beginJump
	ld l,$42
	ld a,(hl)
	ld l,$72
	ld (hl),a
	
	ld l,$73
	ld (hl),$32
	jp objectSetVisible82
@birdWithImpa:
	call interactionSetAlwaysUpdateBit
	ld l,$46
	ld (hl),$b4
	ld l,$50
	ld (hl),$19
	call beginJump
	call objectSetVisible82
	jp objectSetInvisible
@state1:
	ld e,$42
	ld a,(de)
	cp $0a
	jr z,@panickingBirdState1
	call interactionRunScript
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	ld e,$77
	ld a,(de)
	or a
	jr z,@label_10_337
	
	call interactionIncSubstate
	ld l,$48
	ld a,(hl)
	add $02
	jp interactionSetAnimation

@label_10_337:
	call @decVar36
	jr nz,@animate
	ld l,$76
	ld (hl),$1e
	call getRandomNumber
	and $07
	jr nz,@animate
	ld l,$48
	ld a,(hl)
	xor $01
	ld (hl),a
	jp interactionSetAnimation

@animate:
	jp interactionAnimateAsNpc

@substate1:
	call interactionAnimate
	ld e,$77
	ld a,(de)
	or a
	jp nz,updateSpeedZ

	ld l,$76
	ld (hl),$3c

	ld l,$45
	ld (hl),a
	ld l,$4e
	ldi (hl),a
	ld (hl),a

	ld l,$48
	ld a,(hl)
	jp interactionSetAnimation

@panickingBirdState1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @panickingBirdSubstate0
	.dw @panickingBirdSubstate1
	.dw @panickingBirdSubstate2
	.dw @panickingBirdSubstate3
	.dw @panickingBirdSubstate4
@panickingBirdSubstate0:
	ld a,(wUseSimulatedInput)
	or a
	ret nz
	call interactionDecCounter1
	ret nz
	ld l,$45
	inc (hl)
	call func_5e04
	jp objectSetVisible
@panickingBirdSubstate1:
	call interactionAnimateAsNpc
	call updateSpeedZ
	ld a,(wFrameCounter)
	and $07
	call z,func_5e04
	ld c,$10
	call func_5e22
	jp nc,objectApplySpeed
	ld h,d
	ld l,$45
	inc (hl)
	ld l,$46
	ld (hl),$14
	ld l,$4f
	ld (hl),$00
	jp beginJump
@panickingBirdSubstate2:
	call interactionAnimateAsNpc
	call interactionDecCounter1
	ret nz
	ld l,$45
	inc (hl)
	ld l,$78
	ld a,(hl)
	add $02
	jp interactionSetAnimation
@panickingBirdSubstate3:
	call interactionAnimateAsNpc
	call @func_5de5
	ld e,$4f
	ld a,(de)
	or a
	ret nz
	ld c,$18
	call func_5e22
	ret c
	ld h,d
	ld l,$45
	inc (hl)
	call beginJump
	jp func_5e04
@panickingBirdSubstate4:
	call interactionAnimateAsNpc
	call updateSpeedZ
	ld a,(wFrameCounter)
	and $07
	call z,func_5e04
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
@func_5de5:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld bc,$fec0
	jp objectSetSpeedZ
	
@decVar36:
	ld h,d
	ld l,$76
	dec (hl)
	ret

updateSpeedZ:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

beginJump:
	ld bc,$ff40
	jp objectSetSpeedZ

func_5e04:
	call objectGetRelatedObject1Var
	ld l,$4b
	ld b,(hl)
	inc l
	inc l
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	and $10
	swap a
	xor $01
	ld h,d
	ld l,$78
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation
func_5e22:
	ld e,$4b
	ld a,(de)
	ld b,a
	call objectGetRelatedObject1Var
	ld l,$4b
	ld a,(hl)
	sub b
	cp c
	ret
