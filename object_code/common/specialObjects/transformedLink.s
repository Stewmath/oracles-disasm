specialObjectCode_transformedLink:
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

;;
; State 0: initialization (just transformed)
@state0:
	call dropLinkHeldItem
	call clearAllParentItems
	ld a,(wLinkForceState)
	or a
	jr nz,@resetIDToNormal

	call specialObjectSetOamVariables
	xor a
	call specialObjectSetAnimation
	call objectSetVisiblec1
	call itemIncState

	ld l,SpecialObject.collisionType
	ld a, $80 | ITEMCOLLISION_LINK
	ldi (hl),a

	inc l
	ld a,$06
	ldi (hl),a ; [collisionRadiusY] = $06
	ldi (hl),a ; [collisionRadiusX] = $06

	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECT_LINK_AS_BABY
	ret nz

	ld l,SpecialObject.counter1
	ld (hl),$e0
	inc l
	ld (hl),$01 ; [counter2] = $01

	ld a,SND_BECOME_BABY
	call playSound
	jr @createGreenPoof

@disableTransformationForBaby:
	ld a,SND_MAGIC_POWDER
	call playSound

@disableTransformation:
	lda SPECIALOBJECT_LINK
	call setLinkIDOverride
	ld a,$01
	ld (wDisableRingTransformations),a

	ld e,SpecialObject.id
	ld a,(de)
	cp SPECIALOBJECT_LINK_AS_BABY
	ret nz

@createGreenPoof:
	ld b,INTERAC_GREENPOOF
	jp objectCreateInteractionWithSubid00

@resetIDToNormal:
	; If a specific state is requested, go back to normal Link code and run it.
	lda SPECIALOBJECT_LINK
	call setLinkID
	ld a,$01
	ld (wDisableRingTransformations),a
	jp specialObjectCode_link

;;
; State 1: normal movement, etc in transformed state
@state1:
	ld a,(wLinkForceState)
	or a
	jr nz,@resetIDToNormal

	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wScrollMode)
	and $0e
	ret nz

	call updateLinkDamageTaken
	ld a,(wLinkDeathTrigger)
	or a
	jr nz,@disableTransformation

	call retIfTextIsActive

	ld a,(wDisabledObjects)
	and $81
	ret nz

	call decPegasusSeedCounter

	ld h,d
	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECT_LINK_AS_BABY
	jr nz,+
	ld l,SpecialObject.counter1
	call decHlRef16WithCap
	jr z,@disableTransformationForBaby
	jr ++
+
	call linkApplyTileTypes
	ld a,(wLinkSwimmingState)
	or a
	jr nz,@resetIDToNormal

	callab bank6.getTransformedLinkID
	ld e,SpecialObject.id
	ld a,(de)
	cp b
	ld a,b
	jr nz,@resetIDToNormal
++
	call specialObjectUpdateAdjacentWallsBitset
	call linkUpdateKnockback
	call updateLinkSpeed_standard

	; Halve speed if he's in baby form
	ld h,d
	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECT_LINK_AS_BABY
	jr nz,+
	ld l,SpecialObject.speed
	srl (hl)
+
	ld l,SpecialObject.knockbackCounter
	ld a,(hl)
	or a
	jr nz,@animateIfPegasusSeedsActive

	ld l,SpecialObject.collisionType
	set 7,(hl)

	; Update gravity
	ld l,SpecialObject.zh
	bit 7,(hl)
	jr z,++
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,++
	xor a
	ld (wLinkInAir),a
++
	ld a,(wcc95)
	ld b,a
	ld l,SpecialObject.angle
	ld a,(wLinkAngle)
	ld (hl),a

	; Set carry flag if [wLinkAngle] == $ff or Link is in a spinner
	or b
	rlca
	jr c,@animateIfPegasusSeedsActive

	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECT_LINK_AS_BABY
	jr nz,++
	ld l,SpecialObject.animParameter
	bit 7,(hl)
	res 7,(hl)
	ld a,SND_SPLASH
	call nz,playSound
++
	ld a,(wLinkTurningDisabled)
	or a
	call z,updateLinkDirectionFromAngle
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	jr z,@animate
	ld a,(wLinkImmobilized)
	or a
	jr nz,@animate
	call specialObjectUpdatePosition

@animate:
	; Check whether to create the pegasus seed effect
	call checkPegasusSeedCounter
	jr z,++
	rlca
	jr nc,++
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_FALLDOWNHOLE
	inc l
	inc (hl)
	ld bc,$0500
	call objectCopyPositionWithOffset
++
	ld e,SpecialObject.animMode
	ld a,(de)
	or a
	jp z,specialObjectAnimate
	xor a
	jp specialObjectSetAnimation

@animateIfPegasusSeedsActive:
	call checkPegasusSeedCounter
	jr nz,@animate
	xor a
	jp specialObjectSetAnimation
