; ==================================================================================================
; ENEMY_PINCER
;
; Variables:
;   relatedObj1: Pointer to "head", aka subid 1 (only for body parts, subids 2+)
;   var31/var32: Base Y/X position (where it originates from)
;   var33: Amount extended (0 means still in hole)
;   var34: Copy of parent's "id" value. For body parts only.
; ==================================================================================================
enemyCode45:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw pincer_state_uninitialized
	.dw pincer_state1
	.dw pincer_state_stub
	.dw pincer_state_stub
	.dw pincer_state_stub
	.dw pincer_state_stub
	.dw pincer_state_stub
	.dw pincer_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw pincer_head
	.dw pincer_body
	.dw pincer_body
	.dw pincer_body


pincer_state_uninitialized:
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8

	; subid 0 only
	inc a
	ld (de),a ; [state] = 1


; Spawner only (subid 0): Spawn head and body parts, then delete self.
pincer_state1:
	ld b,$04
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn head
	ld b,ENEMY_PINCER
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition

	; Spawn body parts
	ld c,h
	call ecom_spawnUncountedEnemyWithSubid01
	call pincer_setChildRelatedObj1
	; [child.subid] = 2 (incremented in above function call)

	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	call pincer_setChildRelatedObj1
	; [child.subid] = 3

	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	inc (hl)
	call pincer_setChildRelatedObj1
	; [child.subid] = 4

	; Spawner no longer needed
	jp enemyDelete


pincer_state_stub:
	ret


; Subid 1: Head of pincer (the "main" part, which is attackable)
pincer_head:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw pincer_head_state8
	.dw pincer_head_state9
	.dw pincer_head_stateA
	.dw pincer_head_stateB
	.dw pincer_head_stateC
	.dw pincer_head_stateD
	.dw pincer_head_stateE


; Initialization
pincer_head_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld e,Enemy.yh
	ld l,Enemy.var31
	ld a,(de)
	ldi (hl),a
	ld e,Enemy.xh
	ld a,(de)
	ld (hl),a
	ret


; Waiting for Link to approach
pincer_head_state9:
	ld c,$28
	call objectCheckLinkWithinDistance
	ret nc

	ld e,Enemy.state
	ld a,$0a
	ld (de),a
	jp objectSetVisible82


; Showing eyes as a "warning" that it's about to attack
pincer_head_stateA:
	ld e,Enemy.animParameter
	ld a,(de)
	dec a
	jp nz,enemyAnimate

	; Time to attack
	call ecom_incState

	ld l,Enemy.collisionType
	set 7,(hl)

	; Initial "extended" amount is 0
	ld l,Enemy.var33
	ld (hl),$00

	; "Dig up" the tile if coming from underground
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld a,BREAKABLETILESOURCE_SHOVEL
	call tryToBreakTile
.ifdef ROM_AGES
	; If in water, create a splash
	call objectCheckTileAtPositionIsWater
	jr nc,++

	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_SPLASH
	ld bc,$fa00
	call objectCopyPositionWithOffset
++
.endif
	call ecom_updateAngleTowardTarget
	add $02
	and $1c
	rrca
	rrca
	inc a
	jp enemySetAnimation


; Extending toward target
pincer_head_stateB:
	call pincer_updatePosition

	ld e,Enemy.var33
	ld a,(de)
	add $02
	cp $20
	jr nc,@fullyExtended
	ld (de),a
	ret

@fullyExtended:
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$08
	ret


; Staying fully extended for several frames
pincer_head_stateC:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [state]
	ret


; Retracting
pincer_head_stateD:
	call pincer_updatePosition

	ld h,d
	ld l,Enemy.var33
	dec (hl)
	ret nz

	; Fully retracted
	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible


; Fully retracted; on cooldown
pincer_head_stateE:
	call ecom_decCounter1
	ret nz

	; Cooldown over
	ld l,e
	ld (hl),$09 ; [state]

	; Make sure Y/X position is fully fixed back to origin
	ld l,Enemy.var31
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	xor a
	jp enemySetAnimation


;;
; Subid 2-4: body of pincer (just decoration)
pincer_body:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9

; Initialization
@state8:
	ld a,$09
	ld (de),a ; [state]

	; Copy parent's base position (var31/var32)
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld e,Enemy.var31
	ldi a,(hl)
	ld (de),a
	inc l
	inc e
	ld a,(hl)
	ld (de),a

	ld e,Enemy.var34
	ld l,Enemy.id
	ld a,(hl)
	ld (de),a

	ld a,$09
	jp enemySetAnimation

@state9:
	; Check if parent was deleted
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Enemy.var34
	ld a,(de)
	cp (hl)
	jp nz,enemyDelete

	; Copy parent's angle, invincibilityCounter
	ld l,Enemy.angle
	ld e,l
	ld a,(hl)
	ld (de),a
	ld l,Enemy.invincibilityCounter
	ld e,l
	ld a,(hl)
	ld (de),a

	; Copy parent's visibility only if parent is in state $0b or higher
	ld l,Enemy.state
	ld a,(hl)
	cp $0b
	jr c,++

	ld l,Enemy.visible
	ld e,l
	ld a,(hl)
	ld (de),a
++
	call pincer_body_updateExtendedAmount
	jr pincer_updatePosition


;;
; Sets relatedObj1 of object 'h' to object 'c'.
; 'h' is part of the pincer's body, 'c' is the pincer's head.
; Also increments the body part's subid since that does need to be done...
pincer_setChildRelatedObj1:
	inc (hl) ; [subid]++
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c
	ret

;;
; Updates position based on "base position" (var31), angle, and distance extended (var33).
pincer_updatePosition:
	ld h,d
	ld l,Enemy.var31
	ld b,(hl)
	inc l
	ld c,(hl)
	inc l
	ld a,(hl)
	ld e,Enemy.angle
	jp objectSetPositionInCircleArc

;;
; Calculates value for var33 (amount extended) for a body part.
pincer_body_updateExtendedAmount:
	push hl
	ld e,Enemy.subid
	ld a,(de)
	sub $02
	rst_jumpTable
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid2:
	pop hl
	call @getExtendedAmountDividedByFour
	ld b,a
	add a
	add b
	ld (de),a
	ret

@subid3:
	pop hl
	call @getExtendedAmountDividedByFour
	add a
	ld (de),a
	ret

@subid4:
	pop hl
	call @getExtendedAmountDividedByFour
	ld (de),a
	ret

@getExtendedAmountDividedByFour:
	ld l,Enemy.var33
	ld e,l
	ld a,(hl)
	srl a
	srl a
	ret
