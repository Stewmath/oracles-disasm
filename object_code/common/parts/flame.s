; ==================================================================================================
; PART_BURNING_ENEMY
;
; Variables:
;   var30: ID of enemy hit (relatedObj1)
;   var31: Old health value of enemy
; ==================================================================================================
partCode12:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@state0

@state1:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(de)
	cp (hl)
	jr nz,@delete

	ld c,$10
	call objectUpdateSpeedZAndBounce

	ld a,Object.zh
	call objectGetRelatedObject1Var
	ld e,Part.zh
	ld a,(de)
	ld (hl),a

	call objectTakePosition
	ld c,h
	call partCommon_decCounter1IfNonzero
	jp nz,partAnimate

	; Done burning.

	; Restore enemy's health
	ld h,c
	ld l,Enemy.health
	ld e,Part.var31
	ld a,(de)
	ld (hl),a

	; Disable enemy collision if he's dead
	or a
	jr nz,+
	ld l,Enemy.collisionType
	res 7,(hl)
+
	ld l,Enemy.invincibilityCounter
	ld (hl),$00
	ld l,Enemy.stunCounter
	ld (hl),$01
@delete:
	jp partDelete

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),59
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(hl)
	ld (de),a

	ld e,Part.var31
	ld l,Enemy.health
	ld a,(hl)
	ld (de),a
	ld (hl),$01
	call objectTakePosition
	jp objectSetVisible80
