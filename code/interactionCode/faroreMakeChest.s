; ==============================================================================
; INTERACID_FARORE_MAKECHEST
; ==============================================================================
interactionCode11:
	ld e,Interaction.subid	; $418c
	ld a,(de)		; $418e
	and $0f			; $418f
	rst_jumpTable			; $4191
	.dw _interac11_subid00
	.dw _interac11_subid01


; Subid 0 is the "parent" which controls the cutscene and the "children" (subid 1).
; The parent uses 2 variables to control the children:
;   * [$cfd8] is the distance away from the center of the circle the sparkles should be.
;   * [$cfd9] is set to 1 when the sparkles should start moving off-screen.
_interac11_subid00:
	ld e,Interaction.state	; $4196
	ld a,(de)		; $4198
	rst_jumpTable			; $4199
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
	ld a,$30		; $41b0
	ld ($cfd8),a		; $41b2
	xor a			; $41b5
	ld ($cfd9),a		; $41b6
	call setCameraFocusedObject		; $41b9
	ld e,Interaction.counter1		; $41bc
	ld a,$5a		; $41be
	ld (de),a		; $41c0
	call darkenRoomLightly		; $41c1
	jp interactionIncState		; $41c4

@interac11_00_state1:
	call interactionDecCounter1		; $41c7
	ret nz			; $41ca
	ld (hl),$30		; $41cb

	; Create 8 "sparkles".
	ld hl,objectData.faroreSparkleObjectData		; $41cd - $4000
	call parseGivenObjectData		; $41d0

	jp interactionIncState		; $41d3

@interac11_00_state2:
	call interactionDecCounter1		; $41d6
	ret nz			; $41d9
	ld (hl),$1e		; $41da
	jp interactionIncState		; $41dc

@interac11_00_state3:
	call interactionDecCounter1		; $41df
	ret nz			; $41e2
	ld (hl),$50		; $41e3
	jp interactionIncState		; $41e5

@interac11_00_state4:
	ld a,(wFrameCounter)		; $41e8
	rrca			; $41eb
	jr c,+			; $41ec
	ld hl,$cfd8		; $41ee
	dec (hl)		; $41f1
+
	call interactionDecCounter1		; $41f2
	ret nz			; $41f5
	ld (hl),$28		; $41f6
	jp interactionIncState		; $41f8

@interac11_00_state5:
	call interactionDecCounter1		; $41fb
	ret nz			; $41fe
	ld (hl),$08		; $41ff
	ld a,$01		; $4201
	ld ($cfd9),a		; $4203

	; Create a large, blue-and-red sparkle, and set its "related object" to this.
.ifdef ROM_AGES
	ldbc INTERACID_SPARKLE, $0c		; $4206
.else
	ldbc INTERACID_SPARKLE, $04		; $4206
.endif
	call objectCreateInteraction		; $4209
	ld l,Interaction.relatedObj1	; $420c
	ld (hl),Interaction.start		; $420e
	inc l			; $4210
	ld (hl),d		; $4211

	call objectCreatePuff		; $4212
	ld a,TILEINDEX_CHEST	; $4215
	ld c,$75		; $4217
	call setTile		; $4219
	jp interactionIncState		; $421c

@interac11_00_state678:
	call interactionDecCounter1		; $421f
	ret nz			; $4222
	ld (hl),$10		; $4223
	call fadeinFromWhite		; $4225

@playFadeoutSound:
	ld a,SND_FADEOUT	; $4228
	call playSound		; $422a
	jp interactionIncState		; $422d

@interac11_00_state9:
	call interactionDecCounter1		; $4230
	ret nz			; $4233
	ld a,$04		; $4234
	call fadeinFromWhiteWithDelay		; $4236
	jr @playFadeoutSound	; $4239

@interac11_00_stateA:
	ld a,(wPaletteThread_mode)		; $423b
	or a			; $423e
	ret nz			; $423f
	ld a,$01		; $4240
	ld ($cfc0),a		; $4242
	xor a			; $4245
	ld (wPaletteThread_parameter),a		; $4246
	call setCameraFocusedObjectToLink		; $4249
	jp interactionDelete		; $424c


; Subid 1 is a "sparkle" which is controlled by the parent, subid 0.
_interac11_subid01:
	ld e,Interaction.state	; $424f
	ld a,(de)		; $4251
	rst_jumpTable			; $4252
	.dw @interac11_01_state0
	.dw @interac11_01_state1
	.dw @interac11_01_state2
	.dw @interac11_01_state3

@interac11_01_state0:
	; Determine angle based on upper nibble of subid
	ld e,Interaction.subid		; $425b
	ld a,(de)		; $425d
	swap a			; $425e
	and $0f			; $4260
	ld hl,@initialAngles	; $4262
	rst_addAToHl			; $4265
	ld a,(hl)		; $4266
	ld e,Interaction.angle		; $4267
	ld (de),a		; $4269

	ld e,Interaction.speed		; $426a
	ld a,SPEED_100		; $426c
	ld (de),a		; $426e
	ld e,Interaction.counter1		; $426f
	ld a,$30		; $4271
	ld (de),a		; $4273

	call interactionInitGraphics		; $4274
	call objectSetVisible80		; $4277
	jp interactionIncState		; $427a

@initialAngles:
	.db $02 $06 $0a $0e $12 $16 $1a $1e


; Sparkles moving away from center, not rotating
@interac11_01_state1:
	call objectApplySpeed		; $4285
	call interactionAnimate		; $4288
	call interactionDecCounter1		; $428b
	ret nz			; $428e
	jp interactionIncState		; $428f

; Sparkles rotating around center
@interac11_01_state2:
	call @interac11_updateSparkle		; $4292

	; Wait for signal from parent to start flying away
	ld a,($cfd9)		; $4295
	or a			; $4298
	ret z			; $4299

	ld e,Interaction.speed		; $429a
	ld a,SPEED_200		; $429c
	ld (de),a		; $429e
	jp interactionIncState		; $429f

; Sparkles moving away until off-screen
@interac11_01_state3:
	call objectApplySpeed		; $42a2
	call interactionAnimate		; $42a5
	call objectCheckWithinScreenBoundary		; $42a8
	ret c			; $42ab
	jp interactionDelete		; $42ac

@interac11_updateSparkle:
	ld a,(wFrameCounter)		; $42af
	rrca			; $42b2
	jr c,++			; $42b3

	ld h,d			; $42b5
	ld l,Interaction.angle	; $42b6
	inc (hl)		; $42b8
	ld a,(hl)		; $42b9
	and $1f			; $42ba
	ld (hl),a		; $42bc
	ld a,SND_CIRCLING		; $42bd
	call z,playSound		; $42bf
++
	ld e,Interaction.angle		; $42c2
	ld bc,$7858		; $42c4
	ld a,($cfd8)		; $42c7
	call objectSetPositionInCircleArc		; $42ca
	jp interactionAnimate		; $42cd
