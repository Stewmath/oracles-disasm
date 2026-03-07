; ==================================================================================================
; INTERAC_MOVING_PLATFORM
;
; Variables:
;   Subid: After being processed, this just represents the size (see @collisionRadii).
;   var32: Formerly bits 3-7 of subid; the index of the "script" to use.
; ==================================================================================================
interactionCode79:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	and $07
	ld (de),a

	ld a,b
	ld e,Interaction.var32
	swap a
	rlca
	and $1f
	ld (de),a
	call interactionInitGraphics

	ld e,Interaction.speed
	ld a,SPEED_80
	ld (de),a

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@collisionRadii
	rst_addDoubleIndex
	ld e,Interaction.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	callab scriptHelp.movingPlatform_loadScript
	callab scriptHelp.movingPlatform_runScript
	jp objectSetVisible83

@collisionRadii:
	.db $08 $08
	.db $10 $08
	.db $18 $08
	.db $08 $10
	.db $08 $18
	.db $10 $10

@state1:
	ld a,(wLinkRidingObject)
	cp d
	jr z,@linkOnPlatform
	or a
	jr nz,@updateSubstate

	call @checkLinkTouching
	jr nc,@updateSubstate

	; Just got on platform
	ld a,d
	ld (wLinkRidingObject),a
	jr @updateSubstate

@linkOnPlatform:
	call @checkLinkTouching
	jr c,@updateSubstate
	xor a
	ld (wLinkRidingObject),a

@updateSubstate:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

;;
; @param[out]	cflag	Set if Link's touching the platform
@checkLinkTouching:
	ld hl,w1Link.yh
	ldi a,(hl)
	add $05
	ld b,a
	inc l
	ld c,(hl)
	jp interactionCheckContainsPoint


; Substate 0: not moving
@substate0:
	call interactionDecCounter1
	ret nz
	callab scriptHelp.movingPlatform_runScript
	ret

; Substate 1: moving
@substate1:
	ld a,(wLinkPlayingInstrument)
	or a
	ret nz

	call objectApplySpeed
	ld a,(wLinkRidingObject)
	cp d
	jr nz,@substate0

	ld a,(w1Link.state)
	cp $01
	jr nz,@substate0

	ld e,Interaction.speed
	ld a,(de)
	ld b,a
	ld e,Interaction.angle
	ld a,(de)
	ld c,a
	call updateLinkPositionGivenVelocity
	jr @substate0
