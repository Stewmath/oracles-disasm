; ==================================================================================================
; INTERAC_FARORE_MAKECHEST
; ==================================================================================================
interactionCode11:
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw interac11_subid00
	.dw interac11_subid01


; Subid 0 is the "parent" which controls the cutscene and the "children" (subid 1).
; The parent uses 2 variables to control the children:
;   * [$cfd8] is the distance away from the center of the circle the sparkles should be.
;   * [$cfd9] is set to 1 when the sparkles should start moving off-screen.
interac11_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @interac11_00_state0
	.dw @interac11_00_state1
	.dw @interac11_00_state2
	.dw @interac11_00_state3
	.dw @interac11_00_state4
	.dw @interac11_00_state5
	.dw @interac11_00_state678
	.dw @interac11_00_state678
	.dw @interac11_00_state678
	.dw @interac11_00_state9
	.dw @interac11_00_stateA

@interac11_00_state0:
	ld a,$30
	ld ($cfd8),a
	xor a
	ld ($cfd9),a
	call setCameraFocusedObject
	ld e,Interaction.counter1
	ld a,$5a
	ld (de),a
	call darkenRoomLightly
	jp interactionIncState

@interac11_00_state1:
	call interactionDecCounter1
	ret nz
	ld (hl),$30

	; Create 8 "sparkles".
	ld hl,objectData.objectData_faroreSparkle
	call parseGivenObjectData

	jp interactionIncState

@interac11_00_state2:
	call interactionDecCounter1
	ret nz
	ld (hl),$1e
	jp interactionIncState

@interac11_00_state3:
	call interactionDecCounter1
	ret nz
	ld (hl),$50
	jp interactionIncState

@interac11_00_state4:
	ld a,(wFrameCounter)
	rrca
	jr c,+
	ld hl,$cfd8
	dec (hl)
+
	call interactionDecCounter1
	ret nz
	ld (hl),$28
	jp interactionIncState

@interac11_00_state5:
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$01
	ld ($cfd9),a

	; Create a large, blue-and-red sparkle, and set its "related object" to this.
.ifdef ROM_AGES
	ldbc INTERAC_SPARKLE, $0c
.else
	ldbc INTERAC_SPARKLE, $04
.endif
	call objectCreateInteraction
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.start
	inc l
	ld (hl),d

	call objectCreatePuff
	ld a,TILEINDEX_CHEST
	ld c,$75
	call setTile
	jp interactionIncState

@interac11_00_state678:
	call interactionDecCounter1
	ret nz
	ld (hl),$10
	call fadeinFromWhite

@playFadeoutSound:
	ld a,SND_FADEOUT
	call playSound
	jp interactionIncState

@interac11_00_state9:
	call interactionDecCounter1
	ret nz
	ld a,$04
	call fadeinFromWhiteWithDelay
	jr @playFadeoutSound

@interac11_00_stateA:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld ($cfc0),a
	xor a
	ld (wPaletteThread_parameter),a
	call setCameraFocusedObjectToLink
	jp interactionDelete


; Subid 1 is a "sparkle" which is controlled by the parent, subid 0.
interac11_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @interac11_01_state0
	.dw @interac11_01_state1
	.dw @interac11_01_state2
	.dw @interac11_01_state3

@interac11_01_state0:
	; Determine angle based on upper nibble of subid
	ld e,Interaction.subid
	ld a,(de)
	swap a
	and $0f
	ld hl,@initialAngles
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.angle
	ld (de),a

	ld e,Interaction.speed
	ld a,SPEED_100
	ld (de),a
	ld e,Interaction.counter1
	ld a,$30
	ld (de),a

	call interactionInitGraphics
	call objectSetVisible80
	jp interactionIncState

@initialAngles:
	.db $02 $06 $0a $0e $12 $16 $1a $1e


; Sparkles moving away from center, not rotating
@interac11_01_state1:
	call objectApplySpeed
	call interactionAnimate
	call interactionDecCounter1
	ret nz
	jp interactionIncState

; Sparkles rotating around center
@interac11_01_state2:
	call @interac11_updateSparkle

	; Wait for signal from parent to start flying away
	ld a,($cfd9)
	or a
	ret z

	ld e,Interaction.speed
	ld a,SPEED_200
	ld (de),a
	jp interactionIncState

; Sparkles moving away until off-screen
@interac11_01_state3:
	call objectApplySpeed
	call interactionAnimate
	call objectCheckWithinScreenBoundary
	ret c
	jp interactionDelete

@interac11_updateSparkle:
	ld a,(wFrameCounter)
	rrca
	jr c,++

	ld h,d
	ld l,Interaction.angle
	inc (hl)
	ld a,(hl)
	and $1f
	ld (hl),a
	ld a,SND_CIRCLING
	call z,playSound
++
	ld e,Interaction.angle
	ld bc,$7858
	ld a,($cfd8)
	call objectSetPositionInCircleArc
	jp interactionAnimate
