; ==================================================================================================
; PART_SHADOW_HAG_SHADOW
; ==================================================================================================
partCode41:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw partDelete

; Initialization
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),$08

	ld l,Part.speed
	ld (hl),SPEED_100

	ld e,Part.angle
	ld a,(de)
	ld hl,@angles
	rst_addAToHl
	ld a,(hl)
	ld (de),a

	call objectSetVisible82
	ld a,$01
	jp partSetAnimation

@angles:
	.db $04 $0c $14 $1c


; Shadows chasing Link
@state1:
	; If [shadowHag.counter1] == $ff, the shadows should converge to her position.
	ld a,Object.counter1
	call objectGetRelatedObject1Var
	ld a,(hl)
	inc a
	jr nz,++

	ld e,Part.state
	ld a,$02
	ld (de),a
++
	call partCommon_decCounter1IfNonzero
	jr nz,++

	ld (hl),$08
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
++
	jp objectApplySpeed


; Shadows converging back to shadow hag
@state2:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	ld e,Part.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Part.xh
	ld a,(de)
	ldh (<hFF8E),a

	; Check if already close enough
	sub c
	add $04
	cp $09
	jr nc,@updateAngleAndApplySpeed
	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	jr nc,@updateAngleAndApplySpeed

	; We're close enough.

	; [shadowHag.counter2]--
	ld l,Enemy.counter2
	dec (hl)
	; [shadowHag.visible] = true
	ld l,Enemy.visible
	set 7,(hl)

	ld e,Part.state
	ld a,$03
	ld (de),a

@updateAngleAndApplySpeed:
	call objectGetRelativeAngleWithTempVars
	ld e,Part.angle
	ld (de),a
	jp objectApplySpeed
