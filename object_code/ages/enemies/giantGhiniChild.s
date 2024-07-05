; ==================================================================================================
; ENEMY_GIANT_GHINI_CHILD
; ==================================================================================================
enemyCode3f:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackNoSolidity

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jr nz,@normalStatus

	; Attach self to Link
	ld h,d
	ld l,Enemy.state
	ld (hl),$0b

	ld l,Enemy.counter1
	ld (hl),120

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.zh
	ld (hl),$00

	; Signal parent to charge at Link
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var32
	ld (hl),$01

	jr @normalStatus

@dead:
	; Decrement parent's "child counter" before deleting self
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.var30
	dec (hl)
	jp enemyDie

@normalStatus:
	; Die if parent is dead
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.health
	ld a,(hl)
	or a
	jr z,@dead

	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw giantGhiniChild_state_uninitialized
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state_stub
	.dw giantGhiniChild_state8
	.dw giantGhiniChild_state9
	.dw giantGhiniChild_stateA
	.dw giantGhiniChild_stateB
	.dw giantGhiniChild_stateC


giantGhiniChild_state_stub:
	ret


giantGhiniChild_state_uninitialized:
	; Determine spawn offset based on subid
	ld e,Enemy.subid
	ld a,(de)
	and $7f
	dec a
	ld hl,giantGhiniChild_spawnOffsets
	rst_addDoubleIndex
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld (de),a
	inc hl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld (de),a

	ld a,SPEED_c0
	call ecom_setSpeedAndState8
	ld l,Enemy.zh
	ld (hl),$fc

	ld l,Enemy.subid
	ld a,(hl)
	rlca
	ret c

	ld l,Enemy.state
	ld (hl),$09
	ld l,Enemy.counter1
	ld (hl),30
	call objectSetVisiblec1
	jp objectCreatePuff


; Waiting for battle to start
giantGhiniChild_state8:
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.state
	ld a,(hl)
	cp $09
	jr c,@battleNotStartedYet

	call giantGhiniChild_gotoStateA
	jp objectSetVisiblec1

@battleNotStartedYet:
	; Enable shadows
	ld l,Enemy.visible
	ld e,l
	ld a,(hl)
	or $40
	ld (de),a
	ret


; Just spawned in, will charge after [counter1] frames
giantGhiniChild_state9:
	call ecom_decCounter1
	ret nz

giantGhiniChild_gotoStateA:
	ld e,Enemy.state
	ld a,$0a
	ld (de),a
	ld e,Enemy.counter1
	ld a,$05
	ld (de),a

	call objectGetAngleTowardLink
	ld e,Enemy.angle
	ld (de),a
	ret


; Charging at Link
giantGhiniChild_stateA:
	call enemyAnimate
	call objectApplySpeed
	call ecom_decCounter1
	ret nz

	ld (hl),$05 ; [counter1]
	call objectGetAngleTowardLink
	jp objectNudgeAngleTowards


; Attached to Link
giantGhiniChild_stateB:
	call enemyAnimate

	ld a,(w1Link.yh)
	ld e,Enemy.yh
	ld (de),a
	ld a,(w1Link.xh)
	ld e,Enemy.xh
	ld (de),a

	call ecom_decCounter1
	jr z,@detach

	; Decrement counter more if pressing buttons
	ld a,(wGameKeysJustPressed)
	or a
	jr z,++
	ld a,(hl)
	sub BTN_A|BTN_B
	jr nc,+
	ld a,$01
+
	ld (hl),a
++
	; Adjust visibility
	ld a,(hl)
	and $03
	jr nz,++
	ld l,Enemy.visible
	ld a,(hl)
	xor $80
	ld (hl),a
++
	; Make Link slow, disable item use
	ld hl,wccd8
	set 5,(hl)
	ld a,(wFrameCounter)
	rrca
	ret nc
	ld hl,wLinkImmobilized
	set 5,(hl)
	ret

@detach:
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.counter1
	ld (hl),60

	; Cancel parent charging (or at least he won't adjust his angle anymore)
	ld l,Enemy.relatedObj1+1
	ld h,(hl)
	ld l,Enemy.var32
	ld (hl),$00
	ret


; Just detached from Link, fading away
giantGhiniChild_stateC:
	call enemyAnimate
	ld e,Enemy.visible
	ld a,(de)
	xor $80
	ld (de),a

	call ecom_decCounter1
	ret nz

	; Decrement parent's "child counter"
	ld e,Enemy.relatedObj1+1
	ld a,(de)
	ld h,a
	ld l,Enemy.var30
	dec (hl)
	call decNumEnemies
	jp enemyDelete


giantGhiniChild_spawnOffsets:
	.db  $00, -$18
	.db -$18,  $00
	.db  $00,  $18
