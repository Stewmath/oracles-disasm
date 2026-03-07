; ==================================================================================================
; INTERAC_BIPIN
; ==================================================================================================
interactionCode28:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics
	call interactionIncState

	; Decide what script to load based on subid
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @bipin0
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin2
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
.ifdef ROM_AGES
	.dw @bipin3
.endif


; Bipin running around, baby just born
@bipin0:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.angle
	ld (hl),$18

	ld l,Interaction.var3a
	ld a,$04
	ld (hl),a
	call interactionSetAnimation

	jp @updateCollisionAndVisibility


; Bipin gives you a random tip
@bipin1:
	ld a,$03
	call interactionSetAnimation
	jp @updateCollisionAndVisibility


; Bipin just moved to Labrynna/Holodrum?
@bipin2:
	ld a,$02
	call interactionSetAnimation
	jp @updateCollisionAndVisibility


.ifdef ROM_AGES
; "Past" version of Bipin who gives you a gasha seed
@bipin3:
	ld a,$09
	call interactionSetAnimation
	jp @updateCollisionAndVisibility
.endif


@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @bipinSubid0
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
.ifdef ROM_AGES
	.dw @runScriptAndAnimate
.endif

@bipinSubid0:
	call @updateSpeed

@runScriptAndAnimate:
	call interactionRunScript
	jp @updateAnimation

@updateAnimation:
	call interactionAnimate

@updateCollisionAndVisibility:
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; Bipin runs around like a madman when his baby is first born
@updateSpeed:
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $28
	cp $30
	ret c

	; Reverse direction
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	xor $10
	ld (hl),a

	ld l,Interaction.var3a
	ld a,(hl)
	xor $01
	ld (hl),a
	jp interactionSetAnimation


@scriptTable:
	.dw mainScripts.bipinScript0
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript2
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
	.dw mainScripts.bipinScript1
.ifdef ROM_AGES
	.dw mainScripts.bipinScript3
.endif
