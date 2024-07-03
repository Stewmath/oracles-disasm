;;
; ITEM_BOOMERANG ($06)
parentItemCode_boomerang:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
.ifdef ROM_SEASONS
	.dw @state2
.endif

@state0:
.ifdef ROM_AGES
	call isLinkUnderwater
	jp nz,clearParentItem
	ld a,(w1ParentItem2.id)
	cp ITEM_SWITCH_HOOK
	jp z,clearParentItem
.endif

	ld a,(wLinkSwimmingState)
	or a
	jp nz,clearParentItem

	call parentItemLoadAnimationAndIncState

.ifdef ROM_SEASONS
	ld a,(wBoomerangLevel)
	cp $02
	ld a,$01
	jr nz,+
	inc a
+
.else; ROM_AGES
	ld a,$01
.endif

	ld e,Item.state
	ld (de),a

	; Try to create the physical boomerang object, delete self on failure
	dec a
	ld c,a
	ld e,Item.id
	ld a,(de)
	ld b,a
	ld e,$01
	call itemCreateChildWithID
	jp c,clearParentItem

	; Calculate angle for newly created boomerang
	ld a,(wLinkAngle)
	bit 7,a
	jr z,+
	ld a,(w1Link.direction)
	swap a
	rrca
+
	ld l,Item.angle
	ld (hl),a
	ld l,Item.var34
	ld (hl),a
	ret

.ifdef ROM_SEASONS

@state2:
	call parentItemCheckButtonPressed
	jr z,@cancelControl

	ld a,Object.relatedObj1+1
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp d
	jr nz,@cancelControl

	; Cancel any movement from Link and direct it to the boomerang
	ld a,(wLinkAngle)
	ld c,a
	ld a,$ff
	ld (wLinkAngle),a
	ld a,(wFrameCounter)
	rrca
	jr c,@dontChangeDirection
	ld a,c
	rlca
	jr nc,@setTargetAngle

@dontChangeDirection:
	ld l,Item.angle
	ld c,(hl)

@setTargetAngle:
	ld l,Item.var34
	ld (hl),c
	ret

@cancelControl:
	ld e,Item.state
	ld a,$01
	ld (de),a
	; Fall through to @state1

.endif ; ROM_SEASONS


@state1:
	ld e,Item.animParameter
	ld a,(de)
	rlca
	jp nc,specialObjectAnimate_optimized
	jp clearParentItem
