; ==================================================================================================
; INTERAC_BIRD
; ==================================================================================================
interactionCode4c:
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
	.dw @initSubid03
	.dw @initSubid04


; Listening to Nayru at the start of the game
@initSubid00:
	call bird_hop
	ld hl,mainScripts.birdScript_listeningToNayruGameStart
	jp interactionSetScript


; Bird with Impa when Zelda gets kidnapped
@initSubid04:
	ld a,(wEssencesObtained)
	bit 2,a
	jp z,interactionDelete

	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA
	call checkGlobalFlag
	jp nz,interactionDelete

	ld hl,mainScripts.birdScript_zeldaKidnapped
	call interactionSetScript
	call interactionSetAlwaysUpdateBit

	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	call checkGlobalFlag
	jr z,@setAnimation0AndJump

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jr z,@impaNotMoved

	; Have talked to impa; adjust position
	ld e,Interaction.yh
	ld a,$58
	ld (de),a
	jr @setAnimation0AndJump

@impaNotMoved:
	ld e,Interaction.xh
	ld a,$68
	ld (de),a
	jr @setAnimation0AndJump


; Different colored birds that do nothing but hop? Used in a cutscene?
@initSubid01:
@initSubid02:
@initSubid03:
	; [oamFlags] = [subid]
	ld a,(de)
	ld e,Interaction.oamFlags
	ld (de),a

@setAnimation0AndJump:
	xor a
	call interactionSetAnimation
	jp bird_hop


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw bird_runSubid0
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw bird_runSubid4


; Listening to Nayru at the start of the game
bird_runSubid0:
	call interactionAnimateAsNpc
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)
	cp $0e
	jr nz,++

	call interactionIncSubstate
	ld a,$01
	jp interactionSetAnimation
++
	ld e,Interaction.var37
	ld a,(de)
	or a
	call nz,bird_updateGravityAndHopWhenHitGround
	jp interactionRunScript

@substate1:
	ld a,($cfd0)
	cp $10
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$1e
	call bird_hop
	ld a,$02
	jp interactionSetAnimation

@substate2:
	call interactionDecCounter1
	jr nz,bird_updateGravityAndHopWhenHitGround

	; Begin running away
	call interactionIncSubstate
	ld l,Interaction.zh
	ld (hl),$00
	ld l,Interaction.angle
	ld (hl),$01
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld bc,-$100
	call objectSetSpeedZ
	ld a,$03
	jp interactionSetAnimation

@substate3:
	; Delete self when off-screen
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete

	xor a
	call objectUpdateSpeedZ
	jp objectApplySpeed


; Bird with Impa when Zelda gets kidnapped
bird_runSubid4:
	call interactionAnimateAsNpc
	call bird_updateGravityAndHopWhenHitGround
	call interactionRunScript
	jp c,interactionDelete

	; Check whether to move the bird over (to make way to Link)
	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	call checkGlobalFlag
	ret z

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	ret nz

	; Increase x position until it reaches $68
	ld e,Interaction.xh
	ld a,(de)
	cp $68
	ret z

	inc a
	ld (de),a
	ret

bird_updateGravityAndHopWhenHitGround:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

bird_hop:
	ld bc,-$c0
	jp objectSetSpeedZ
