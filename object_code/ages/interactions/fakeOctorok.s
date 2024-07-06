; ==================================================================================================
; INTERAC_FAKE_OCTOROK
; ==================================================================================================
interactionCode32:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @init0
	.dw @init1
	.dw @init2

@init0:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
	call objectSetVisible82

	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	ld hl,impaOctorokScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,b
	ld hl,@animations
	rst_addAToHl
	ld a,(hl)
	jp interactionSetAnimation

; Each animation faces a different direction.
@animations:
	.db $02 $01 $03

@init2:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	jr z,++
	ld a,ENEMY_GREAT_FAIRY
	call getFreeEnemySlot
	ld (hl),ENEMY_GREAT_FAIRY
	call objectCopyPosition
	jp interactionDelete
++
	ld bc,-$80
	call objectSetSpeedZ
	ld a,>TX_4100
	call interactionSetHighTextIndex
	ld hl,mainScripts.greatFairyOctorokScript
	jr @init1

@init1:
	call interactionSetScript
	call objectSetVisiblec0

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw impaOctorokCode
	.dw greatFairyOctorokCode
	.dw greatFairyOctorokCode

impaOctorokCode:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)
	cp $01
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$14
	ret

@substate1:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,Interaction.speed
	ld (hl),SPEED_300

	ld l,Interaction.var03
	ld a,(hl)
	ld bc,@countersAndAngles
	call addDoubleIndexToBc
	ld a,(bc)
	ld l,Interaction.counter1
	ld (hl),a
	inc bc
	ld a,(bc)
	ld l,Interaction.angle
	ld (hl),a
	swap a
	rlca
	jp interactionSetAnimation

@countersAndAngles:
	.db $50 $00
	.db $3c $18
	.db $5a $00

@substate2:
	call interactionAnimate2Times
	call interactionDecCounter1
	ret nz
	ld a,SND_THROW
	call playSound
	jp interactionIncSubstate

@substate3:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	call interactionAnimate2Times
	jp objectApplySpeed


impaOctorokScriptTable: ; These scripts do nothing
	.dw mainScripts.impaOctorokScript
	.dw mainScripts.impaOctorokScript
	.dw mainScripts.impaOctorokScript


greatFairyOctorokCode:
	call npcFaceLinkAndAnimate
	call interactionRunScript
	ret nc

; Script over; just used fairy powder.

	xor a
	call objectUpdateSpeedZ
	ld e,Interaction.zh
	ld a,(de)
	cp $f0
	ret nz

	ldbc INTERAC_GREAT_FAIRY, $01
	call objectCreateInteraction
	ld a,TREASURE_FAIRY_POWDER
	call loseTreasure
	jp interactionDelete
