; ==================================================================================================
; INTERAC_KNOW_IT_ALL_BIRD
;
; Variables:
;   var36: Counter until bird should turn around?
;   var37: Set while being talked to (signal to change animation)
; ==================================================================================================
interactionCodee3:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,mainScripts.knowItAllBirdScript
	call interactionSetScript

	call getRandomNumber_noPreserveVars
	and $01
	ld e,Interaction.direction
	ld (de),a
	call interactionSetAnimation
	call interactionSetAlwaysUpdateBit

	ld l,Interaction.var36
	ld (hl),30

	call @beginJump
	ld l,Interaction.subid
	ld a,(hl)
	ld l,Interaction.textID
	ld (hl),a

	ld hl,@oamFlagsTable
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.oamFlags
	ld (de),a
	ld a,>TX_3200
	call interactionSetHighTextIndex
	jp objectSetVisible82

@oamFlagsTable:
	.db $00 $01 $02 $03 $02 $03 $01 $00 $00 $01

@state1:
	call interactionRunScript
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	ld e,Interaction.var37
	ld a,(de)
	or a
	jr z,@label_10_337

	; Being talked to
	call interactionIncSubstate
	ld l,Interaction.direction
	ld a,(hl)
	add $02
	jp interactionSetAnimation

@label_10_337:
	; Not being talked to; looks left and right
	call @decVar36
	jr nz,@animate
	ld l,Interaction.var36
	ld (hl),30
	call getRandomNumber
	and $07
	jr nz,@animate
	ld l,Interaction.direction
	ld a,(hl)
	xor $01
	ld (hl),a
	jp interactionSetAnimation

@animate:
	jp interactionAnimateAsNpc

@substate1:
	call interactionAnimate
	ld h,d
	ld l,Interaction.var37
	ld a,(hl)
	or a
	jp nz,@updateSpeedZ

	ld l,Interaction.var36
	ld (hl),60

	; a == 0 here
	ld l,Interaction.substate
	ld (hl),a
	ld l,Interaction.z
	ldi (hl),a
	ld (hl),a

	ld l,Interaction.direction
	ld a,(hl)
	jp interactionSetAnimation

@decVar36:
	ld h,d
	ld l,Interaction.var36
	dec (hl)
	ret

@updateSpeedZ:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d

@beginJump:
	ld bc,-$c0
	jp objectSetSpeedZ
