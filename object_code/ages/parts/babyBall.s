; ==================================================================================================
; PART_BABY_BALL
; Turns Link into a baby
; ==================================================================================================
partCode2f:
	jp nz,partDelete
	ld a,Object.health 
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,@veranFairyBeat
	ld b,h
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$14
	ld l,$c6
	ld (hl),$1e
	ld a,SND_BLUE_STALFOS_CHARGE
	call playSound
	jp objectSetVisible82
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld l,e
	inc (hl)
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	ld a,SND_BEAM2
	call playSound
	jr @animate
@state2:
	ld c,Enemy.state
	ld a,(bc)
	cp $03
	jr nz,@applySpeed
	; Veran Fairy moving and attacking
	ld c,Enemy.var03
	ld a,(bc)
	cp $02
	jr nz,@applySpeed
	ld a,(wFrameCounter)
	and $0f
	jr nz,@applySpeed
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
@applySpeed:
	call partCommon_checkOutOfBounds
	jr z,@delete
	call objectApplySpeed
@animate:
	jp partAnimate
@veranFairyBeat:
	call objectCreatePuff
@delete:
	jp partDelete
