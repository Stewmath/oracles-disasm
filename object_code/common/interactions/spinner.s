; ==================================================================================================
; INTERAC_SPINNER
;
; Variables:
;   var3a: Bitmask for wSpinnerState (former value of "xh")
; ==================================================================================================
interactionCode7d:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw spinner_subid02

@subid00:
@subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionRunScript
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3a
	ld (hl),a

	; Calculate subid (blue or red) based on whether the bit in wSpinnerState is set
	ld a,(wSpinnerState)
	and (hl)
	ld a,$01
	jr nz,+
	dec a
+
	ld l,Interaction.subid
	ld (hl),a

	; Calculate angle? (subid*8)
	swap a
	rrca
	ld l,Interaction.angle
	ld (hl),a

	ld l,Interaction.yh
	ld a,(hl)
	call setShortPosition

	call interactionInitGraphics
	ld hl,mainScripts.spinnerScript_initialization
	call interactionSetScript
	call objectSetVisible82

	; Create "arrow" object and set it as relatedObj1
	ldbc INTERAC_SPINNER, $02
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld (hl),d
	ret


; State 2: Link just touched the spinner.
@state2:
	ld hl,wcc95
	ld a,(wLinkInAir)
	or a
	jr nz,@revertToState1

	; Check if in midair or swimming?
	bit 4,(hl)
	jr nz,@beginTurning

@revertToState1:
	; Undo everything we just did
	res 7,(hl)
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld hl,mainScripts.spinnerScript_waitForLink
	jp interactionSetScript

@beginTurning:
	; State 3
	ld a,$03
	ld (de),a

	call clearAllParentItems

	; Determine the direction Link entered from
	ld c,$28
	call objectCheckLinkWithinDistance
	sra a
	ld e,Interaction.direction
	ld (de),a

	; Check angle
	ld b,a
	inc e
	ld a,(de)
	or a
	jr nz,@clockwise

@counterClockwise:
	ld a,b
	add a
	ld hl,spinner_counterClockwiseData
	rst_addDoubleIndex
	jr ++

@clockwise:
	ld a,b
	add a
	ld hl,spinner_clockwiseData
	rst_addDoubleIndex

++
	call spinner_setLinkRelativePosition
	ldi a,(hl)
	ld c,<w1Link.direction
	ld (bc),a

	ld e,Interaction.var39
	ld a,(hl)
	ld (de),a

	call setLinkForceStateToState08

	; Disable everything but interactions?
	ld a,(wDisabledObjects)
	or $80
	ld (wDisabledObjects),a

	ld a,$04
	call setScreenShakeCounter

	ld a,SND_OPENCHEST
	jp playSound


; State 3: In the process of turning
@state3:
	call spinner_updateLinkPosition

	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	jp nz,interactionAnimate

	; Finished turning, set up state 4
	ld h,d
	ld l,Interaction.state
	ld (hl),$04

	ld l,Interaction.counter1
	ld (hl),$10
	xor a
	ld (wDisabledObjects),a

	; Update Link's angle based on direction
	ld hl,w1Link.direction
	ldi a,(hl)
	swap a
	rrca
	ld (hl),a

	; Force him to move out
	ld hl,wLinkForceState
	ld a,LINK_STATE_FORCE_MOVEMENT
	ldi (hl),a
	inc l
	ld (hl),$10

	; Reset signal that spinner's being used?
	ld hl,wcc95
	res 7,(hl)
	ret

; State 4: Link moving out from spinner
@state4:
	call interactionDecCounter1
	ret nz

	; Toggle spinner state
	ld l,Interaction.var3a
	ld a,(wSpinnerState)
	xor (hl)
	ld (wSpinnerState),a

	; Toggle color
	ld l,Interaction.oamFlags
	ld a,(hl)
	xor $01
	ld (hl),a

	; Toggle angle
	ld l,Interaction.angle
	ld a,(hl)
	xor $08
	ld (hl),a

	; Go back to state 1
	ld l,Interaction.state
	ld (hl),$01
	ld hl,mainScripts.spinnerScript_waitForLinkAfterDelay
	jp interactionSetScript


; Arrow rotating around a spinner
spinner_subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics

	; [this.angle] = [relatedObj1.angle]
	ld e,Interaction.relatedObj1
	ld a,(de)
	ld h,d
	ld l,Interaction.angle
	ld e,l
	ld a,(hl)
	ld (de),a
	call objectSetVisible82

@state1:
	; Check if [this.angle] == [relatedObj1.angle]
	ld e,Interaction.relatedObj1
	ld a,(de)
	ld h,a
	ld l,Interaction.angle
	ld e,l
	ld a,(de)
	cp (hl)
	jr z,++

	; Angle changed (red to blue, or blue to red)
	ld a,(hl)
	ld (de),a
	swap a
	rlca
	add $02
	call interactionSetAnimation
++
	; [this.oamFlags] = [relatedObj1.oamFlags]
	ld e,Interaction.relatedObj1
	ld a,(de)
	ld h,a
	ld l,Interaction.oamFlags
	ld e,l
	ld a,(hl)
	ld (de),a

	jp interactionAnimate

;;
spinner_updateLinkPosition:
	; Check that the animParameter signals Link should change position (nonzero and
	; not $ff)
	ld e,Interaction.animParameter
	ld a,(de)
	ld b,a
	or a
	ret z
	inc a
	ret z

	xor a
	ld (de),a

	ld a,SND_DOORCLOSE
	call playSound

	; Read from table based on value of "animParameter" and "var39" to determine
	; Link's position relative to the spinner.
	ld e,Interaction.var39
	ld a,(de)
	add b
	and $0f
	ld hl,spinner_linkRelativePositions
	rst_addDoubleIndex

;;
; @param	hl	Address of 2 bytes (Y/X offset for Link relative to spinner)
spinner_setLinkRelativePosition:
	ld b,>w1Link
	ld e,Interaction.yh
	ld c,<w1Link.yh
	call @func

	ld e,Interaction.xh
	ld c,<w1Link.xh

@func:
	ld a,(de)
	add (hl)
	inc hl
	ld (bc),a
	ret


; Each row of below table represents data for a particular direction of transition:
;   b0: Y offset for Link relative to spinner
;   b1: X offset for Link relative to spinner
;   b2: Value for w1Link.direction
;   b3: Value for spinner.var39 (relative index for spinner_linkRelativePositions)
spinner_counterClockwiseData:
	.db $f4 $00 $03 $08 ; DIR_UP (Link enters from above)
	.db $00 $0c $00 $04 ; DIR_RIGHT
	.db $0c $00 $01 $00 ; DIR_DOWN
	.db $00 $f4 $02 $0c ; DIR_LEFT

spinner_clockwiseData:
	.db $f4 $00 $01 $08 ; DIR_UP
	.db $00 $0c $02 $04 ; DIR_RIGHT
	.db $0c $00 $03 $00 ; DIR_DOWN
	.db $00 $f4 $00 $0c ; DIR_LEFT


; Each row is a Y/X offset for Link. The row is selected from the animation's
; "animParameter" and "var39".
spinner_linkRelativePositions:
	.db $0c $00
	.db $0a $02
	.db $08 $08
	.db $02 $0a
	.db $00 $0c
	.db $fe $0a
	.db $f8 $08
	.db $f6 $02
	.db $f4 $00
	.db $f6 $fe
	.db $f8 $f8
	.db $fe $f6
	.db $00 $f4
	.db $02 $f6
	.db $08 $f8
	.db $0a $fe
