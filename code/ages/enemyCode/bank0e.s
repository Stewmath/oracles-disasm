.include "code/enemyCode/group2.s"

; ==============================================================================

orbMovementScript:
	.dw @subid00

@subid00:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_right $98
	ms_left  $68
	ms_loop  @@loop


;;
; Called from objectRunMovementScript in bank0. See include/movementscript_commands.s.
;
; @param	hl	Script address
; @addr{6b2d}
objectLoadMovementScript_body:
	ldh a,(<hActiveObjectType)	; $6b2d
	add Object.subid			; $6b2f
	ld e,a			; $6b31
	ld a,(de)		; $6b32
	rst_addDoubleIndex			; $6b33
	ldi a,(hl)		; $6b34
	ld h,(hl)		; $6b35
	ld l,a			; $6b36

	ld a,e			; $6b37
	add Object.speed-Object.subid			; $6b38
	ld e,a			; $6b3a
	ldi a,(hl)		; $6b3b
	ld (de),a		; $6b3c

	ld a,e			; $6b3d
	add Object.direction-Object.speed			; $6b3e
	ld e,a			; $6b40
	ldi a,(hl)		; $6b41
	ld (de),a		; $6b42

	ld a,e			; $6b43
	add Object.var30-Object.direction 			; $6b44
	ld e,a			; $6b46
	ld a,l			; $6b47
	ld (de),a		; $6b48
	inc e			; $6b49
	ld a,h			; $6b4a
	ld (de),a		; $6b4b

;;
; Called from objectRunMovementScript in bank0. See include/movementscript_commands.s.
; @addr{6b4c}
objectRunMovementScript_body:
	ldh a,(<hActiveObjectType)	; $6b4c
	add Object.var30			; $6b4e
	ld e,a			; $6b50
	ld a,(de)		; $6b51
	ld l,a			; $6b52
	inc e			; $6b53
	ld a,(de)		; $6b54
	ld h,a			; $6b55

@nextOp:
	ldi a,(hl)		; $6b56
	push hl			; $6b57
	rst_jumpTable			; $6b58
	.dw @cmd00_jump
	.dw @moveUp
	.dw @moveRight
	.dw @moveDown
	.dw @moveLeft
	.dw @wait
.ifdef ROM_AGES
	.dw @setstate
.endif


@cmd00_jump:
	pop hl			; $6b67
	ldi a,(hl)		; $6b68
	ld h,(hl)		; $6b69
	ld l,a			; $6b6a
	jr @nextOp		; $6b6b


@moveUp:
	pop bc			; $6b6d
	ld h,d			; $6b6e
	ldh a,(<hActiveObjectType)	; $6b6f
	add Object.var32			; $6b71
	ld l,a			; $6b73
	ld a,(bc)		; $6b74
	ld (hl),a		; $6b75

	ld a,l			; $6b76
	add Object.angle-Object.var32			; $6b77
	ld l,a			; $6b79
	ld (hl),ANGLE_UP		; $6b7a

	add Object.state-Object.angle			; $6b7c
	ld l,a			; $6b7e
	ld (hl),$08		; $6b7f
	jr @storePointer		; $6b81


@moveRight:
	pop bc			; $6b83
	ld h,d			; $6b84
	ldh a,(<hActiveObjectType)	; $6b85
	add Object.var33			; $6b87
	ld l,a			; $6b89
	ld a,(bc)		; $6b8a
	ld (hl),a		; $6b8b

	ld a,l			; $6b8c
	add Object.angle-Object.var33			; $6b8d
	ld l,a			; $6b8f
	ld (hl),ANGLE_RIGHT		; $6b90

	add Object.state-Object.angle			; $6b92
	ld l,a			; $6b94
	ld (hl),$09		; $6b95
	jr @storePointer		; $6b97


@moveDown:
	pop bc			; $6b99
	ld h,d			; $6b9a
	ldh a,(<hActiveObjectType)	; $6b9b
	add Object.var32			; $6b9d
	ld l,a			; $6b9f
	ld a,(bc)		; $6ba0
	ld (hl),a		; $6ba1

	ld a,l			; $6ba2
	add Object.angle-Object.var32			; $6ba3
	ld l,a			; $6ba5
	ld (hl),ANGLE_DOWN		; $6ba6

	add Object.state-Object.angle			; $6ba8
	ld l,a			; $6baa
	ld (hl),$0a		; $6bab
	jr @storePointer		; $6bad


@moveLeft:
	pop bc			; $6baf
	ld h,d			; $6bb0
	ldh a,(<hActiveObjectType)	; $6bb1
	add Object.var33			; $6bb3
	ld l,a			; $6bb5
	ld a,(bc)		; $6bb6
	ld (hl),a		; $6bb7

	ld a,l			; $6bb8
	add Object.angle-Object.var33			; $6bb9
	ld l,a			; $6bbb
	ld (hl),ANGLE_LEFT		; $6bbc

	add Object.state-Object.angle			; $6bbe
	ld l,a			; $6bc0
	ld (hl),$0b		; $6bc1
	jr @storePointer		; $6bc3


@wait:
	pop bc			; $6bc5
	ld h,d			; $6bc6
	ldh a,(<hActiveObjectType)	; $6bc7
	add Object.counter1			; $6bc9
	ld l,a			; $6bcb
	ld a,(bc)		; $6bcc
.ifdef ROM_AGES
	ldd (hl),a		; $6bcd

	dec l			; $6bce
	ld (hl),$0c ; [state]
.else
	ld (hl),a		; $7a2d
	ld a,l			; $7a2e
	add $fe			; $7a2f
	ld l,a			; $7a31
	ld (hl),$0c		; $7a32
.endif

@storePointer:
	inc bc			; $6bd1
.ifdef ROM_AGES
	ld a,l			; $6bd2
.endif
	add Object.var30-Object.state			; $6bd3
	ld l,a			; $6bd5
	ld (hl),c		; $6bd6
	inc l			; $6bd7
	ld (hl),b		; $6bd8
	ret			; $6bd9

.ifdef ROM_AGES
@setstate:
	pop bc			; $6bda
	ld h,d			; $6bdb
	ldh a,(<hActiveObjectType)	; $6bdc
	add Object.counter1			; $6bde
	ld l,a			; $6be0
	ld a,(bc)		; $6be1
	ldd (hl),a		; $6be2

	dec l			; $6be3
	inc bc			; $6be4
	ld a,(bc)		; $6be5
	ld (hl),a ; [state]

	jr @storePointer		; $6be7
.endif


; ==============================================================================
; ENEMYID_BARI
;
; Variables:
;   var30/var31: Initial Y/X position (aka target position; they always hover around this
;                area. For subid 0 (large baris) only.)
;   var32: Counter for "bobbing" of Z position
; ==============================================================================
enemyCode3c:
	jr z,@normalStatus	; $6be9
	sub ENEMYSTATUS_NO_HEALTH			; $6beb
	ret c			; $6bed
	jp z,enemyDie		; $6bee
	dec a			; $6bf1
	jp nz,_ecom_updateKnockback		; $6bf2

	; ENEMYSTATUS_JUST_HIT
	; The bari should be split in two if it's subid 0, and the right kind of collision
	; occurred, while it's not in its "shocking" state.

	ld e,Enemy.var2a		; $6bf5
	ld a,(de)		; $6bf7
	cp $80|ITEMCOLLISION_GALE_SEED			; $6bf8
	jr z,@normalStatus	; $6bfa

	ld e,Enemy.health		; $6bfc
	ld a,(de)		; $6bfe
	or a			; $6bff
	ret z			; $6c00

	ld e,Enemy.subid		; $6c01
	ld a,(de)		; $6c03
	or a			; $6c04
	jr nz,@normalStatus	; $6c05

	ld e,Enemy.enemyCollisionMode		; $6c07
	ld a,(de)		; $6c09
	cp ENEMYCOLLISION_BARI_ELECTRIC_SHOCK			; $6c0a
	jr z,@normalStatus	; $6c0c

	; FIXME: This checks if collisionType is strictly less than L3 shield, which is
	; odd? Does that mean the mirror shield would cause the bari to split? Though it
	; shouldn't matter anyway, shields can't be used underwater...
	ld e,Enemy.var2a		; $6c0e
	ld a,(de)		; $6c10
	cp $80|ITEMCOLLISION_L3_SHIELD			; $6c11
	jr c,@normalStatus	; $6c13

	ld h,d			; $6c15
	ld l,Enemy.state		; $6c16
	ld (hl),$0a		; $6c18

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $6c1a
	jr c,@commonState	; $6c1d

	call _bari_updateZPosition		; $6c1f
	ld e,Enemy.state		; $6c22
	ld a,b			; $6c24
	or a			; $6c25
	jp z,_bari_subid0		; $6c26
	jp _bari_subid1		; $6c29

@commonState:
	ld a,(de)		; $6c2c
	rst_jumpTable			; $6c2d
	.dw _bari_state_uninitialized
	.dw _bari_state_stub
	.dw _bari_state_stub
	.dw _bari_state_stub
	.dw _bari_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _bari_state_stub
	.dw _bari_state_stub


_bari_state_uninitialized:
	ld a,SPEED_60		; $6c3e
	call _ecom_setSpeedAndState8AndVisible		; $6c40

	ld l,Enemy.counter1		; $6c43
	ld (hl),$04		; $6c45

	ld l,Enemy.zh		; $6c47
	ld (hl),$fc		; $6c49

	; Copy Y/X to var30/var31
	ld e,Enemy.yh		; $6c4b
	ld l,Enemy.var30		; $6c4d
	ld a,(de)		; $6c4f
	ldi (hl),a		; $6c50
	ld e,Enemy.xh		; $6c51
	ld a,(de)		; $6c53
	ld (hl),a		; $6c54

	call getRandomNumber_noPreserveVars		; $6c55
	ld e,Enemy.var32		; $6c58
	ld (de),a		; $6c5a

	ld e,Enemy.subid		; $6c5b
	ld a,(de)		; $6c5d
	or a			; $6c5e
	jp z,_bari_setRandomAngleAndCounter2		; $6c5f

	; Subid 1 only
	ld e,Enemy.speed		; $6c62
	ld a,SPEED_40		; $6c64
	ld (de),a		; $6c66
	ld a,$02		; $6c67
	jp enemySetAnimation		; $6c69


_bari_state_stub:
	ret			; $6c6c


_bari_subid0:
	ld a,(de)		; $6c6d
	sub $08			; $6c6e
	rst_jumpTable			; $6c70
	.dw _bari_subid0_state8
	.dw _bari_state9
	.dw _bari_subid0_stateA


; "Non-electric-shock" state
_bari_subid0_state8:
	call _ecom_decCounter2		; $6c77
	jr nz,@dontShockYet	; $6c7a

	; Begin electric shock
	ld (hl),60 ; [counter2]
	ld l,e			; $6c7e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $6c80
	ld (hl),ENEMYCOLLISION_BARI_ELECTRIC_SHOCK		; $6c82

	ld a,$01		; $6c84
	jp enemySetAnimation		; $6c86

@dontShockYet:
	call _ecom_decCounter1		; $6c89
	jr nz,_bari_applySpeed	; $6c8c

	call getRandomNumber		; $6c8e
	and $0e			; $6c91
	add $02			; $6c93
	ld (hl),a ; [counter1]

	; Nudge angle towards target position (original position)
	ld l,Enemy.var30		; $6c96
	call _ecom_readPositionVars		; $6c98
	call objectGetRelativeAngleWithTempVars		; $6c9b
	call objectNudgeAngleTowards		; $6c9e

_bari_applySpeed:
	call objectApplySpeed		; $6ca1
	call _ecom_bounceOffScreenBoundary		; $6ca4

_bari_animate:
	jp enemyAnimate		; $6ca7


; In its "electric shock" state. This is shared between subids 0 and 1 (large and small).
_bari_state9:
	call _ecom_decCounter2		; $6caa
	jr nz,_bari_animate	; $6cad

	; Stop the shock
	ld l,e			; $6caf
	dec (hl) ; [state] = 8

	ld l,Enemy.enemyCollisionMode		; $6cb1
	ld (hl),ENEMYCOLLISION_BARI		; $6cb3

	dec l			; $6cb5
	set 7,(hl) ; [collisionType]

	xor a			; $6cb8
	call enemySetAnimation		; $6cb9


;;
; @addr{6cbc}
_bari_setRandomAngleAndCounter2:
	call getRandomNumber_noPreserveVars		; $6cbc
	and $03			; $6cbf
	ld hl,@counter2Vals		; $6cc1
	rst_addAToHl			; $6cc4
	ld e,Enemy.counter2		; $6cc5
	ld a,(hl)		; $6cc7
	ld (de),a		; $6cc8
	jp _ecom_setRandomAngle		; $6cc9

@counter2Vals:
	.db 60 90 120 150


; Bari has just been attacked; now it's splitting in two.
_bari_subid0_stateA:
	inc e			; $6cd0
	ld a,(de) ; [state2]
	or a			; $6cd2
	jr z,@substate0	; $6cd3

@substate1:
	call _ecom_decCounter2		; $6cd5
	ret nz			; $6cd8

	; Spawn the two small baris, then delete self.
	call _ecom_updateAngleTowardTarget		; $6cd9
	ld c,$04		; $6cdc
	call @spawnSmallBari		; $6cde
	ld c,$fc		; $6ce1
	call @spawnSmallBari		; $6ce3
	call decNumEnemies		; $6ce6
	jp enemyDelete		; $6ce9

;;
; @param	c	X-offset (and value to add to angle)
; @addr{6cec}
@spawnSmallBari:
	ld b,ENEMYID_BARI		; $6cec
	call _ecom_spawnEnemyWithSubid01		; $6cee
	ret nz			; $6cf1

	; Copy "enemy index" value
	ld l,Enemy.enabled		; $6cf2
	ld e,l			; $6cf4
	ld a,(de)		; $6cf5
	ld (hl),a		; $6cf6

	ld l,Enemy.angle		; $6cf7
	ld e,l			; $6cf9
	ld a,(de)		; $6cfa
	add c			; $6cfb
	and $1f			; $6cfc
	ld (hl),a		; $6cfe

	ld b,$00		; $6cff
	jp objectCopyPositionWithOffset		; $6d01

@substate0:
	ld b,INTERACID_KILLENEMYPUFF		; $6d04
	call objectCreateInteractionWithSubid00		; $6d06

	ld h,d			; $6d09
	ld l,Enemy.collisionType		; $6d0a
	res 7,(hl)		; $6d0c

	ld l,Enemy.counter2		; $6d0e
	ld (hl),$04		; $6d10

	ld l,Enemy.state2		; $6d12
	inc (hl)		; $6d14

	ld a,SND_KILLENEMY		; $6d15
	call playSound		; $6d17
	jp objectSetInvisible		; $6d1a


; A small bari.
_bari_subid1:
	ld a,(de)		; $6d1d
	sub $08			; $6d1e
	jp nz,_bari_state9		; $6d20

@state8:
	call _ecom_decCounter1		; $6d23
	jp nz,_bari_applySpeed		; $6d26

	; Randomly choose counter1 value
	call getRandomNumber		; $6d29
	and $1c			; $6d2c
	inc a			; $6d2e
	ld (hl),a		; $6d2f

	; Adjust angle toward Link
	call objectGetAngleTowardEnemyTarget		; $6d30
	call objectNudgeAngleTowards		; $6d33
	jp _bari_applySpeed		; $6d36


;;
; Bobs up and down
; @addr{6d39}
_bari_updateZPosition:
	ld h,d			; $6d39
	ld l,Enemy.var32		; $6d3a
	dec (hl)		; $6d3c
	ld a,(hl)		; $6d3d
	and $30			; $6d3e
	swap a			; $6d40
	ld hl,@zVals		; $6d42
	rst_addAToHl			; $6d45
	ld e,Enemy.zh		; $6d46
	ld a,(hl)		; $6d48
	ld (de),a		; $6d49
	ret			; $6d4a

@zVals:
	.db $fc $fd $fe $fd


; ==============================================================================
; ENEMYID_GIANT_GHINI_CHILD
; ==============================================================================
enemyCode3f:
	jr z,@normalStatus	; $6d4f
	sub ENEMYSTATUS_NO_HEALTH			; $6d51
	ret c			; $6d53
	jr z,@dead	; $6d54
	dec a			; $6d56
	jp nz,_ecom_updateKnockbackNoSolidity		; $6d57

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a		; $6d5a
	ld a,(de)		; $6d5c
	cp $80|ITEMCOLLISION_LINK			; $6d5d
	jr nz,@normalStatus	; $6d5f

	; Attach self to Link
	ld h,d			; $6d61
	ld l,Enemy.state		; $6d62
	ld (hl),$0b		; $6d64

	ld l,Enemy.counter1		; $6d66
	ld (hl),120		; $6d68

	ld l,Enemy.collisionType		; $6d6a
	res 7,(hl)		; $6d6c

	ld l,Enemy.zh		; $6d6e
	ld (hl),$00		; $6d70

	; Signal parent to charge at Link
	ld l,Enemy.relatedObj1+1		; $6d72
	ld h,(hl)		; $6d74
	ld l,Enemy.var32		; $6d75
	ld (hl),$01		; $6d77

	jr @normalStatus		; $6d79

@dead:
	; Decrement parent's "child counter" before deleting self
	ld e,Enemy.relatedObj1+1		; $6d7b
	ld a,(de)		; $6d7d
	ld h,a			; $6d7e
	ld l,Enemy.var30		; $6d7f
	dec (hl)		; $6d81
	jp enemyDie		; $6d82

@normalStatus:
	; Die if parent is dead
	ld e,Enemy.relatedObj1+1		; $6d85
	ld a,(de)		; $6d87
	ld h,a			; $6d88
	ld l,Enemy.health		; $6d89
	ld a,(hl)		; $6d8b
	or a			; $6d8c
	jr z,@dead	; $6d8d

	ld e,Enemy.state		; $6d8f
	ld a,(de)		; $6d91
	rst_jumpTable			; $6d92
	.dw _giantGhiniChild_state_uninitialized
	.dw _giantGhiniChild_state_stub
	.dw _giantGhiniChild_state_stub
	.dw _giantGhiniChild_state_stub
	.dw _giantGhiniChild_state_stub
	.dw _giantGhiniChild_state_stub
	.dw _giantGhiniChild_state_stub
	.dw _giantGhiniChild_state_stub
	.dw _giantGhiniChild_state8
	.dw _giantGhiniChild_state9
	.dw _giantGhiniChild_stateA
	.dw _giantGhiniChild_stateB
	.dw _giantGhiniChild_stateC


_giantGhiniChild_state_stub:
	ret			; $6dad


_giantGhiniChild_state_uninitialized:
	; Determine spawn offset based on subid
	ld e,Enemy.subid		; $6dae
	ld a,(de)		; $6db0
	and $7f			; $6db1
	dec a			; $6db3
	ld hl,_giantGhiniChild_spawnOffsets		; $6db4
	rst_addDoubleIndex			; $6db7
	ld e,Enemy.yh		; $6db8
	ld a,(de)		; $6dba
	add (hl)		; $6dbb
	ld (de),a		; $6dbc
	inc hl			; $6dbd
	ld e,Enemy.xh		; $6dbe
	ld a,(de)		; $6dc0
	add (hl)		; $6dc1
	ld (de),a		; $6dc2

	ld a,SPEED_c0		; $6dc3
	call _ecom_setSpeedAndState8		; $6dc5
	ld l,Enemy.zh		; $6dc8
	ld (hl),$fc		; $6dca

	ld l,Enemy.subid		; $6dcc
	ld a,(hl)		; $6dce
	rlca			; $6dcf
	ret c			; $6dd0

	ld l,Enemy.state		; $6dd1
	ld (hl),$09		; $6dd3
	ld l,Enemy.counter1		; $6dd5
	ld (hl),30		; $6dd7
	call objectSetVisiblec1		; $6dd9
	jp objectCreatePuff		; $6ddc


; Waiting for battle to start
_giantGhiniChild_state8:
	ld e,Enemy.relatedObj1+1		; $6ddf
	ld a,(de)		; $6de1
	ld h,a			; $6de2
	ld l,Enemy.state		; $6de3
	ld a,(hl)		; $6de5
	cp $09			; $6de6
	jr c,@battleNotStartedYet			; $6de8

	call _giantGhiniChild_gotoStateA		; $6dea
	jp objectSetVisiblec1		; $6ded

@battleNotStartedYet:
	; Enable shadows
	ld l,Enemy.visible		; $6df0
	ld e,l			; $6df2
	ld a,(hl)		; $6df3
	or $40			; $6df4
	ld (de),a		; $6df6
	ret			; $6df7


; Just spawned in, will charge after [counter1] frames
_giantGhiniChild_state9:
	call _ecom_decCounter1		; $6df8
	ret nz			; $6dfb

_giantGhiniChild_gotoStateA:
	ld e,Enemy.state		; $6dfc
	ld a,$0a		; $6dfe
	ld (de),a		; $6e00
	ld e,Enemy.counter1		; $6e01
	ld a,$05		; $6e03
	ld (de),a		; $6e05

	call objectGetAngleTowardLink		; $6e06
	ld e,Enemy.angle		; $6e09
	ld (de),a		; $6e0b
	ret			; $6e0c


; Charging at Link
_giantGhiniChild_stateA:
	call enemyAnimate		; $6e0d
	call objectApplySpeed		; $6e10
	call _ecom_decCounter1		; $6e13
	ret nz			; $6e16

	ld (hl),$05 ; [counter1]
	call objectGetAngleTowardLink		; $6e19
	jp objectNudgeAngleTowards		; $6e1c


; Attached to Link
_giantGhiniChild_stateB:
	call enemyAnimate		; $6e1f

	ld a,(w1Link.yh)		; $6e22
	ld e,Enemy.yh		; $6e25
	ld (de),a		; $6e27
	ld a,(w1Link.xh)		; $6e28
	ld e,Enemy.xh		; $6e2b
	ld (de),a		; $6e2d

	call _ecom_decCounter1		; $6e2e
	jr z,@detach	; $6e31

	; Decrement counter more if pressing buttons
	ld a,(wGameKeysJustPressed)		; $6e33
	or a			; $6e36
	jr z,++			; $6e37
	ld a,(hl)		; $6e39
	sub BTN_A|BTN_B			; $6e3a
	jr nc,+			; $6e3c
	ld a,$01		; $6e3e
+
	ld (hl),a		; $6e40
++
	; Adjust visibility
	ld a,(hl)		; $6e41
	and $03			; $6e42
	jr nz,++		; $6e44
	ld l,Enemy.visible		; $6e46
	ld a,(hl)		; $6e48
	xor $80			; $6e49
	ld (hl),a		; $6e4b
++
	; Make Link slow, disable item use
	ld hl,wccd8		; $6e4c
	set 5,(hl)		; $6e4f
	ld a,(wFrameCounter)		; $6e51
	rrca			; $6e54
	ret nc			; $6e55
	ld hl,wLinkImmobilized		; $6e56
	set 5,(hl)		; $6e59
	ret			; $6e5b

@detach:
	ld l,Enemy.state		; $6e5c
	ld (hl),$0c		; $6e5e
	ld l,Enemy.counter1		; $6e60
	ld (hl),60		; $6e62

	; Cancel parent charging (or at least he won't adjust his angle anymore)
	ld l,Enemy.relatedObj1+1		; $6e64
	ld h,(hl)		; $6e66
	ld l,Enemy.var32		; $6e67
	ld (hl),$00		; $6e69
	ret			; $6e6b


; Just detached from Link, fading away
_giantGhiniChild_stateC:
	call enemyAnimate		; $6e6c
	ld e,Enemy.visible		; $6e6f
	ld a,(de)		; $6e71
	xor $80			; $6e72
	ld (de),a		; $6e74

	call _ecom_decCounter1		; $6e75
	ret nz			; $6e78

	; Decrement parent's "child counter"
	ld e,Enemy.relatedObj1+1		; $6e79
	ld a,(de)		; $6e7b
	ld h,a			; $6e7c
	ld l,Enemy.var30		; $6e7d
	dec (hl)		; $6e7f
	call decNumEnemies		; $6e80
	jp enemyDelete		; $6e83


_giantGhiniChild_spawnOffsets:
	.db  $00, -$18
	.db -$18,  $00
	.db  $00,  $18


; ==============================================================================
; ENEMYID_SHADOW_HAG_BUG
;
; Variables:
;   counter2: Lifetime counter
; ==============================================================================
enemyCode42:
	jr z,++			; $6e8c
	sub ENEMYSTATUS_NO_HEALTH			; $6e8e
	ret c			; $6e90
	jr z,@dead	; $6e91

	dec a			; $6e93
	jp nz,_ecom_updateKnockbackNoSolidity		; $6e94
	ret			; $6e97

@dead:
	; Decrement parent object's "bug count"
	ld a,Object.var30		; $6e98
	call objectGetRelatedObject1Var		; $6e9a
	dec (hl)		; $6e9d
	jp enemyDie_uncounted		; $6e9e
++
	ld e,Enemy.state		; $6ea1
	ld a,(de)		; $6ea3
	rst_jumpTable			; $6ea4
	.dw _shadowHagBug_state_uninitialized
	.dw _shadowHagBug_state_stub
	.dw _shadowHagBug_state_stub
	.dw _shadowHagBug_state_stub
	.dw _shadowHagBug_state_stub
	.dw _shadowHagBug_state_galeSeed
	.dw _shadowHagBug_state_stub
	.dw _shadowHagBug_state_stub
	.dw _shadowHagBug_state8
	.dw _shadowHagBug_state9


_shadowHagBug_state_uninitialized:
	ld a,SPEED_60		; $6eb9
	call _ecom_setSpeedAndState8		; $6ebb

	ld l,Enemy.speedZ		; $6ebe
	ld a,<(-$e0)		; $6ec0
	ldi (hl),a		; $6ec2
	ld (hl),>(-$e0)		; $6ec3

	call getRandomNumber_noPreserveVars		; $6ec5
	and $1f			; $6ec8
	ld e,Enemy.angle		; $6eca
	ld (de),a		; $6ecc
	jp objectSetVisible82		; $6ecd


_shadowHagBug_state_galeSeed:
	call _ecom_galeSeedEffect		; $6ed0
	ret c			; $6ed3
	jp enemyDelete		; $6ed4


_shadowHagBug_state_stub:
	ret			; $6ed7


_shadowHagBug_state8:
	ld c,$12		; $6ed8
	call objectUpdateSpeedZ_paramC		; $6eda
	jr nz,_shadowHagBug_applySpeedAndAnimate	; $6edd

	ld l,Enemy.state		; $6edf
	inc (hl)		; $6ee1

	call getRandomNumber		; $6ee2
	ld l,Enemy.counter1		; $6ee5
	ldi (hl),a		; $6ee7
	ld (hl),180 ; [counter2]


_shadowHagBug_state9:
	call _ecom_decCounter2		; $6eea
	jr z,_shadowHagBug_delete	; $6eed

	ld a,(hl)		; $6eef
	cp 30			; $6ef0
	call c,_ecom_flickerVisibility		; $6ef2

	dec l			; $6ef5
	dec (hl) ; [counter1]
	ld a,(hl)		; $6ef7
	and $07			; $6ef8
	jr nz,_shadowHagBug_applySpeedAndAnimate	; $6efa

	; Choose a random position within link's 16x16 square
	ld bc,$0f0f		; $6efc
	call _ecom_randomBitwiseAndBCE		; $6eff
	ldh a,(<hEnemyTargetY)	; $6f02
	add b			; $6f04
	sub $08			; $6f05
	ld b,a			; $6f07
	ldh a,(<hEnemyTargetX)	; $6f08
	add c			; $6f0a
	sub $08			; $6f0b
	ld c,a			; $6f0d

	; Nudge angle toward chosen position
	ld e,Enemy.yh		; $6f0e
	ld a,(de)		; $6f10
	ldh (<hFF8F),a	; $6f11
	ld e,Enemy.xh		; $6f13
	ld a,(de)		; $6f15
	ldh (<hFF8E),a	; $6f16
	call objectGetRelativeAngleWithTempVars		; $6f18
	call objectNudgeAngleTowards		; $6f1b

_shadowHagBug_applySpeedAndAnimate:
	call objectApplySpeed		; $6f1e
	jp enemyAnimate		; $6f21

_shadowHagBug_delete:
	; Decrement parent's "bug count"
	ld a,Object.var30		; $6f24
	call objectGetRelatedObject1Var		; $6f26
	dec (hl)		; $6f29
	jp enemyDelete		; $6f2a


; ==============================================================================
; ENEMYID_COLOR_CHANGING_GEL
;
; Variables:
;   var30/var31: Target position while hopping
;   var32: Tile index at current position (purposely outdated so there's lag in updating
;          the color)
; ==============================================================================
enemyCode47:
	call _ecom_checkHazards		; $6f2d
	jr z,@normalStatus	; $6f30
	sub ENEMYSTATUS_NO_HEALTH			; $6f32
	ret c			; $6f34
	jp z,enemyDie		; $6f35

	; ENEMYSTATUS_JUST_HIT

	ld h,d			; $6f38
	ld l,Enemy.var2a		; $6f39
	ld a,(hl)		; $6f3b
	cp $80|ITEMCOLLISION_MYSTERY_SEED			; $6f3c
	jr nz,@attacked	; $6f3e

	; Mystery seed hit the gel
	call _colorChangingGel_chooseRandomColor		; $6f40
	jr @normalStatus		; $6f43

@attacked:
	; Ignore all attacks if color matches floor
	ld e,Enemy.enemyCollisionMode		; $6f45
	ld a,(de)		; $6f47
	cp ENEMYCOLLISION_COLOR_CHANGING_GEL			; $6f48
	jr nz,@normalStatus	; $6f4a

	; Only allow switch hook and sword attacks to kill the gel
	ldi a,(hl)		; $6f4c
	res 7,a			; $6f4d
	cp ITEMCOLLISION_SWITCH_HOOK			; $6f4f
	jr z,@wasDamagingAttack			; $6f51
	sub ITEMCOLLISION_L1_SWORD			; $6f53
	cp ITEMCOLLISION_SWORD_HELD-ITEMCOLLISION_L1_SWORD + 1
	jr nc,@normalStatus	; $6f57

@wasDamagingAttack
	ld (hl),$f4 ; [invincibilityCounter] = $f4
	ld a,SND_DAMAGE_ENEMY		; $6f5b
	call playSound		; $6f5d

@normalStatus:
	call _colorChangingGel_updateColor		; $6f60
	ld e,Enemy.state		; $6f63
	ld a,(de)		; $6f65
	rst_jumpTable			; $6f66
	.dw _colorChangingGel_state_uninitialized
	.dw _colorChangingGel_state_stub
	.dw _colorChangingGel_state_stub
	.dw _colorChangingGel_state_stub
	.dw _colorChangingGel_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _colorChangingGel_state_stub
	.dw _colorChangingGel_state_stub
	.dw _colorChangingGel_state8
	.dw _colorChangingGel_state9
	.dw _colorChangingGel_stateA


_colorChangingGel_state_uninitialized:
	ld a,SPEED_140		; $6f7d
	call _ecom_setSpeedAndState8AndVisible		; $6f7f

	ld l,Enemy.counter1		; $6f82
	ld (hl),150		; $6f84
	inc l			; $6f86
	ld (hl),$00 ; [counter2]

	ld l,Enemy.enemyCollisionMode		; $6f89
	ld (hl),ENEMYCOLLISION_COLOR_CHANGING_GEL		; $6f8b

	ld l,Enemy.var3f		; $6f8d
	set 5,(hl)		; $6f8f

	call objectGetTileAtPosition		; $6f91
	ld e,Enemy.var32		; $6f94
	ld (de),a		; $6f96

	ld a,PALH_bf		; $6f97
	call loadPaletteHeader		; $6f99
	ld a,$03		; $6f9c
	jp enemySetAnimation		; $6f9e


_colorChangingGel_state_stub:
	ret			; $6fa1


; Standing still for [counter1] frames
_colorChangingGel_state8:
	call _ecom_decCounter1		; $6fa2
	ret nz			; $6fa5

	inc (hl) ; [counter1] = 1

	; Choose random direction to jump
	call getRandomNumber_noPreserveVars		; $6fa7
	and $0e			; $6faa
	ld hl,@directionsToJump		; $6fac
	rst_addAToHl			; $6faf

	; Store target position in var30/var31
	ld e,Enemy.yh		; $6fb0
	ld a,(de)		; $6fb2
	add (hl)		; $6fb3
	ld e,Enemy.var30		; $6fb4
	ld (de),a		; $6fb6
	ld b,a			; $6fb7

	ld e,Enemy.xh		; $6fb8
	ld a,(de)		; $6fba
	inc hl			; $6fbb
	add (hl)		; $6fbc
	ld e,Enemy.var31		; $6fbd
	ld (de),a		; $6fbf
	ld c,a			; $6fc0

	; Target position must not be solid (if it is, try again next frame)
	call getTileCollisionsAtPosition		; $6fc1
	ret nz			; $6fc4

	call _ecom_incState		; $6fc5

	ld l,Enemy.counter1		; $6fc8
	ld (hl),60		; $6fca

	ld l,Enemy.speedZ		; $6fcc
	ld a,<(-$180)		; $6fce
	ldi (hl),a		; $6fd0
	ld (hl),>(-$180)		; $6fd1

	ld a,$02		; $6fd3
	jp enemySetAnimation		; $6fd5

@directionsToJump:
	.db $f0 $f0
	.db $f0 $00
	.db $f0 $10
	.db $00 $f0
	.db $00 $10
	.db $10 $f0
	.db $10 $00
	.db $10 $10


; Waiting [counter1] frames before hopping to target position
_colorChangingGel_state9:
	call _ecom_decCounter1		; $6fe8
	jp nz,enemyAnimate		; $6feb

	ld l,e			; $6fee
	inc (hl) ; [state]

	; Calculate angle to jump in
	ld h,d			; $6ff0
	ld l,Enemy.var30		; $6ff1
	call _ecom_readPositionVars		; $6ff3
	call objectGetRelativeAngleWithTempVars		; $6ff6
	and $10			; $6ff9
	swap a			; $6ffb
	jp enemySetAnimation		; $6ffd


; Hopping to target
_colorChangingGel_stateA:
	ld c,$30		; $7000
	call objectUpdateSpeedZ_paramC		; $7002
	jr nz,@stillInAir	; $7005

	; Landed
	ld l,Enemy.state		; $7007
	ld (hl),$08		; $7009

	ld l,Enemy.counter1		; $700b
	ld (hl),150		; $700d

	call objectCenterOnTile		; $700f

	ld a,$03		; $7012
	jp enemySetAnimation		; $7014

@stillInAir:
	; Move toward position if we're not there yet already (ignoring Z position)
	ld l,Enemy.var30		; $7017
	call _ecom_readPositionVars		; $7019
	sub c			; $701c
	inc a			; $701d
	cp $03			; $701e
	jr nc,++		; $7020
	ldh a,(<hFF8F)	; $7022
	sub b			; $7024
	inc a			; $7025
	cp $03			; $7026
	ret c			; $7028
++
	jp _ecom_moveTowardPosition		; $7029


;;
; Updates the gel's color with intentional lag. Every 90 frames, this uses the value of
; var32 (tile index) to set the gel's color, then it updates the value of var32. Due to
; the order this is done in, it takes 180 frames for the color to update fully.
; @addr{702c}
_colorChangingGel_updateColor:
	; Must be on ground
	ld e,Enemy.zh		; $702c
	ld a,(de)		; $702e
	rlca			; $702f
	ret c			; $7030

	; Wait for cooldown
	call _ecom_decCounter2		; $7031
	jr z,@updateStoredColor	; $7034

	; If [counter2] == 1, update color
	ld a,(hl)		; $7036
	dec a			; $7037
	jr z,@updateColor	; $7038

	pop bc			; $703a
	jr @updateImmunity		; $703b

@updateColor:
	; Update color based on tile index stored in var32 (which may be outdated).
	ld e,Enemy.var32		; $703d
	ld a,(de)		; $703f
	call @lookupFloorColor		; $7040
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]

@updateStoredColor:
	call @updateImmunity		; $7045
	ret z			; $7048

	pop bc			; $7049
	ld l,Enemy.counter2		; $704a
	ld (hl),90		; $704c

	; Write tile index to var32?
	ld l,Enemy.var32		; $704e
	ld (hl),e		; $7050
	ret			; $7051

;;
; Sets enemyCollisionMode depending on whether the gel's color matches the floor or not.
;
; @param[out]	zflag	z if immune
; @addr{7052}
@updateImmunity:
	call objectGetTileAtPosition		; $7052
	cp TILEINDEX_SOMARIA_BLOCK			; $7055
	ret z			; $7057

	call @lookupFloorColor		; $7058
	cp (hl)			; $705b
	ld b,ENEMYCOLLISION_COLOR_CHANGING_GEL		; $705c
	jr z,+			; $705e
	ld b,ENEMYCOLLISION_GOHMA_GEL		; $7060
+
	ld l,Enemy.enemyCollisionMode		; $7062
	ld (hl),b		; $7064
	ret			; $7065

;;
; @param	a	Tile index
; @param[out]	a	Color (defaults to red ($02) if floor tile not listed)
; @param[out]	hl	Enemy.oamFlagsBackup
; @addr{7066}
@lookupFloorColor:
	ld e,a			; $7066
	ld hl,@floorColors		; $7067
	call lookupKey		; $706a
	ld h,d			; $706d
	ld l,Enemy.oamFlagsBackup		; $706e
	ret c			; $7070
	ld a,$02		; $7071
	ret			; $7073

@floorColors:
	.db TILEINDEX_RED_FLOOR,         , $02
	.db TILEINDEX_YELLOW_FLOOR       , $06
	.db TILEINDEX_BLUE_FLOOR         , $01
	.db TILEINDEX_RED_TOGGLE_FLOOR   , $02
	.db TILEINDEX_YELLOW_TOGGLE_FLOOR, $06
	.db TILEINDEX_BLUE_TOGGLE_FLOOR  , $01
	.db $00

;;
; Sets the gel's color to something random that isn't its current color.
; @addr{7081}
_colorChangingGel_chooseRandomColor:
	call getRandomNumber_noPreserveVars		; $7081
	and $01			; $7084
	ld b,a			; $7086
	ld e,Enemy.oamFlagsBackup		; $7087
	ld a,(de)		; $7089
	res 0,a			; $708a
	add b			; $708c
	ld hl,@oamFlagMap		; $708d
	rst_addAToHl			; $7090

	ldi a,(hl)		; $7091
	ld (de),a ; [oamFlagsBackup]
	inc e			; $7093
	ld (de),a ; [oamFlags]
	ret			; $7095

@oamFlagMap:
	.db $02 $06 $01 $06 $ff $ff $01 $02


; ==============================================================================
; ENEMYID_AMBI_GUARD
;
; Variables:
;   relatedObj2: PARTID_DETECTION_HELPER; checks when Link is visible.
;   var30-var31: Movement script address
;   var32: Y-destination (reserved by movement script)
;   var33: X-destination (reserved by movement script)
;   var34: Bit 0 set when Link should be noticed; Bit 1 set once the guard has started
;          reacting to Link (shown exclamation mark).
;   var35: Nonzero if just hit with an indirect attack (moves more quickly)
;   var36: While this is nonzero, all "normal code" is ignored. It counts down to zero,
;          and once it's done, it sets var35 to 1 (move more quickly) and normal code
;          resumes. Used for the delay between noticing Link and taking action.
;   var37: Timer until guard "notices" scent seed.
;   var3a: When set to $ff, faces PARTID_DETECTION_HELPER?
;   var3b: When set to $ff, the guard immediately notices Link. (Written to by
;          PARTID_DETECTION_HELPER.)
; ==============================================================================
enemyCode54:
	jr z,@normalStatus	 		; $709e
	sub ENEMYSTATUS_NO_HEALTH			; $70a0
	ret c			; $70a2
	jp z,_ambiGuard_noHealth		; $70a3
	dec a			; $70a6
	jp nz,_ecom_updateKnockback		; $70a7
	call _ambiGuard_collisionOccured		; $70aa

@normalStatus:
	ld e,Enemy.subid		; $70ad
	ld a,(de)		; $70af
	rlca			; $70b0
	jp c,_ambiGuard_attacksLink		; $70b1


; Subids $00-$7f
_ambiGuard_tossesLinkOut:
	call _ambiGuard_checkSpottedLink		; $70b4
	call _ambiGuard_checkAlertTrigger		; $70b7
	ld e,Enemy.state		; $70ba
	ld a,(de)		; $70bc
	rst_jumpTable			; $70bd
	.dw _ambiGuard_tossesLinkOut_uninitialized
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_galeSeed
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state8
	.dw _ambiGuard_state9
	.dw _ambiGuard_stateA
	.dw _ambiGuard_stateB
	.dw _ambiGuard_stateC
	.dw _ambiGuard_stateD
	.dw _ambiGuard_stateE
	.dw _ambiGuard_tossesLinkOut_stateF
	.dw _ambiGuard_tossesLinkOut_state10
	.dw _ambiGuard_tossesLinkOut_state11


_ambiGuard_tossesLinkOut_uninitialized:
	ld hl,_ambiGuard_tossesLinkOut_scriptTable		; $70e2
	call objectLoadMovementScript		; $70e5

	call _ambiGuard_commonInitialization		; $70e8
	ret nz			; $70eb

	ld e,Enemy.direction		; $70ec
	ld a,(de)		; $70ee
	jp enemySetAnimation		; $70ef


; NOTE: Guards don't seem to react to gale seeds? Is this unused?
_ambiGuard_state_galeSeed:
	call _ecom_galeSeedEffect		; $70f2
	ret c			; $70f5

	ld e,Enemy.var34		; $70f6
	ld a,(de)		; $70f8
	or a			; $70f9
	ld e,Enemy.var35		; $70fa
	call z,_ambiGuard_alertAllGuards		; $70fc
	call decNumEnemies		; $70ff
	jp enemyDelete		; $7102


_ambiGuard_state_stub:
	ret			; $7105


; Moving up
_ambiGuard_state8:
	ld e,Enemy.var32		; $7106
	ld a,(de)		; $7108
	ld h,d			; $7109
	ld l,Enemy.yh		; $710a
	cp (hl)			; $710c
	jr nc,@reachedDestination		; $710d
	call objectApplySpeed		; $710f
	jr _ambiGuard_animate		; $7112

@reachedDestination:
	ld a,(de)		; $7114
	ld (hl),a		; $7115
	jp _ambiGuard_runMovementScript		; $7116


; Moving right
_ambiGuard_state9:
	ld e,Enemy.xh		; $7119
	ld a,(de)		; $711b
	ld h,d			; $711c
	ld l,Enemy.var33		; $711d
	cp (hl)			; $711f
	jr nc,@reachedDestination		; $7120
	call objectApplySpeed		; $7122
	jr _ambiGuard_animate		; $7125

@reachedDestination:
	ld a,(hl)		; $7127
	ld (de),a		; $7128
	jp _ambiGuard_runMovementScript		; $7129


; Moving down
_ambiGuard_stateA:
	ld e,Enemy.yh		; $712c
	ld a,(de)		; $712e
	ld h,d			; $712f
	ld l,Enemy.var32		; $7130
	cp (hl)			; $7132
	jr nc,@reachedDestination		; $7133
	call objectApplySpeed		; $7135
	jr _ambiGuard_animate		; $7138

@reachedDestination:
	ld a,(hl)		; $713a
	ld (de),a		; $713b
	jp _ambiGuard_runMovementScript		; $713c


; Moving left
_ambiGuard_stateB:
	ld e,Enemy.var33		; $713f
	ld a,(de)		; $7141
	ld h,d			; $7142
	ld l,Enemy.xh		; $7143
	cp (hl)			; $7145
	jr nc,@reachedDestination		; $7146
	call objectApplySpeed		; $7148
	jr _ambiGuard_animate		; $714b

@reachedDestination:
	ld a,(de)		; $714d
	ld (hl),a		; $714e
	jp _ambiGuard_runMovementScript		; $714f


; Waiting
_ambiGuard_stateC:
_ambiGuard_stateE:
	call _ecom_decCounter1		; $7152
	jp z,_ambiGuard_runMovementScript		; $7155

_ambiGuard_animate:
	jp enemyAnimate		; $7158


; Standing in place for [counter1] frames, then turn the other way for 30 frames, then
; resume movemnet
_ambiGuard_stateD:
	call _ecom_decCounter1		; $715b
	ret nz			; $715e

	ld l,e			; $715f
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $7161
	ld (hl),30		; $7163

	ld l,Enemy.angle		; $7165
	ld a,(hl)		; $7167
	xor $10			; $7168
	ld (hl),a		; $716a
	swap a			; $716b
	rlca			; $716d
	jp enemySetAnimation		; $716e


; Begin moving toward Link after noticing him
_ambiGuard_tossesLinkOut_stateF:
	ld h,d			; $7171
	ld l,e			; $7172
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $7174
	ld (hl),90		; $7176
	call _ambiGuard_turnToFaceLink		; $7178
	ld a,SND_WHISTLE		; $717b
	jp playSound		; $717d


; Moving toward Link until screen fades out and Link gets booted out
_ambiGuard_tossesLinkOut_state10:
	call enemyAnimate		; $7180
	call _ecom_decCounter1		; $7183
	jr z,++		; $7186
	ld c,$18		; $7188
	call objectCheckLinkWithinDistance		; $718a
	jp nc,_ecom_applyVelocityForSideviewEnemyNoHoles		; $718d
++
	ld a,CUTSCENE_BOOTED_FROM_PALACE		; $7190
	ld (wCutsceneTrigger),a		; $7192
	ret			; $7195


_ambiGuard_tossesLinkOut_state11:
	ret			; $7196


_ambiGuard_attacksLink:
	call _ambiGuard_checkSpottedLink		; $7197
	call _ambiGuard_checkAlertTrigger		; $719a
	ld e,Enemy.state		; $719d
	ld a,(de)		; $719f
	rst_jumpTable			; $71a0
	.dw _ambiGuard_attacksLink_state_uninitialized
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_galeSeed
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state_stub
	.dw _ambiGuard_state8
	.dw _ambiGuard_state9
	.dw _ambiGuard_stateA
	.dw _ambiGuard_stateB
	.dw _ambiGuard_stateC
	.dw _ambiGuard_stateD
	.dw _ambiGuard_stateE
	.dw _ambiGuard_attacksLink_stateF
	.dw _ambiGuard_attacksLink_state10
	.dw _ambiGuard_attacksLink_state11


_ambiGuard_attacksLink_state_uninitialized:
	ld h,d			; $71c5
	ld l,Enemy.subid		; $71c6
	res 7,(hl)		; $71c8

	ld hl,_ambiGuard_attacksLink_scriptTable		; $71ca
	call objectLoadMovementScript		; $71cd

	ld h,d			; $71d0
	ld l,Enemy.subid		; $71d1
	set 7,(hl)		; $71d3

	call _ambiGuard_commonInitialization		; $71d5
	ret nz			; $71d8

	ld e,Enemy.direction		; $71d9
	ld a,(de)		; $71db
	jp enemySetAnimation		; $71dc


; Just noticed Link
_ambiGuard_attacksLink_stateF:
	ld h,d			; $71df
	ld l,e			; $71e0
	inc (hl) ; [state]

	ld l,Enemy.counter2		; $71e2
	ld a,(hl)		; $71e4
	or a			; $71e5
	jr nz,+			; $71e6
	ld (hl),60		; $71e8
+
	call _ambiGuard_createExclamationMark		; $71ea
	jr _ambiGuard_turnToFaceLink		; $71ed


; Looking at Link; counting down until he starts chasing him
_ambiGuard_attacksLink_state10:
	call _ecom_decCounter2		; $71ef
	jr z,@beginChasing	; $71f2

	ld a,(hl)		; $71f4
	cp 60			; $71f5
	ret nz			; $71f7

	ld a,SND_WHISTLE		; $71f8
	call playSound		; $71fa
	ld e,Enemy.var34		; $71fd
	jp _ambiGuard_alertAllGuards		; $71ff

@beginChasing:
	dec l			; $7202
	ld (hl),20 ; [counter1]
	ld l,e			; $7205
	inc (hl) ; [state]

	ld l,Enemy.speed		; $7207
	ld (hl),SPEED_180		; $7209
	ld l,Enemy.enemyCollisionMode		; $720b
	ld (hl),ENEMYCOLLISION_AMBI_GUARD_CHASING_LINK		; $720d

;;
; @addr{720f}
_ambiGuard_turnToFaceLink:
	call _ecom_updateCardinalAngleTowardTarget		; $720f
	swap a			; $7212
	rlca			; $7214
	jp enemySetAnimation		; $7215


; Currently chasing Link
_ambiGuard_attacksLink_state11:
	call _ecom_decCounter1		; $7218
	jr nz,++		; $721b
	ld (hl),20		; $721d
	call _ambiGuard_turnToFaceLink		; $721f
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $7222
	jp enemyAnimate		; $7225

;;
; Deletes self if Veran was defeated, otherwise spawns PARTID_DETECTION_HELPER.
;
; @param[out]	zflag	nz if caller should return immediately (deleted self)
; @addr{7228}
_ambiGuard_commonInitialization:
	ld hl,wGroup4Flags+$fc		; $7228
	bit 7,(hl)		; $722b
	jr z,++			; $722d
	call enemyDelete		; $722f
	or d			; $7232
	ret			; $7233
++
	call getFreePartSlot		; $7234
	jr nz,++		; $7237
	ld (hl),PARTID_DETECTION_HELPER		; $7239
	ld l,Part.relatedObj1		; $723b
	ld a,Enemy.start		; $723d
	ldi (hl),a		; $723f
	ld (hl),d		; $7240

	ld e,Enemy.relatedObj2		; $7241
	ld a,Part.start		; $7243
	ld (de),a		; $7245
	inc e			; $7246
	ld a,h			; $7247
	ld (de),a		; $7248

	ld h,d			; $7249
	ld l,Enemy.direction		; $724a
	ldi a,(hl)		; $724c
	swap a			; $724d
	rrca			; $724f
	ld (hl),a		; $7250
	call objectSetVisiblec2		; $7251
	xor a			; $7254
	ret			; $7255
++
	ld e,Enemy.state		; $7256
	xor a			; $7258
	ld (de),a		; $7259
	ret			; $725a

;;
; @addr{725b}
_ambiGuard_runMovementScript:
	call objectRunMovementScript		; $725b

	; Update animation
	ld e,Enemy.angle		; $725e
	ld a,(de)		; $7260
	and $18			; $7261
	swap a			; $7263
	rlca			; $7265
	jp enemySetAnimation		; $7266

;;
; When var36 is nonzero, this counts it down, then sets var35 to nonzero when var36
; reaches 0. (This alerts the guard to start moving faster.) Also, all other guards
; on-screen will be alerted in this way.
;
; As long as var36 is nonzero, this "returns from caller" (discards return address).
; @addr{7269}
_ambiGuard_checkAlertTrigger:
	ld h,d			; $7269
	ld l,Enemy.var36		; $726a
	ld a,(hl)		; $726c
	or a			; $726d
	ret z			; $726e

	pop bc ; return from caller

	dec (hl)		; $7270
	ld a,(hl)		; $7271
	dec a			; $7272
	jr nz,@stillCountingDown	; $7273

	; Check if in a standard movement state
	ld l,Enemy.state		; $7275
	ld a,(hl)		; $7277
	sub $08			; $7278
	cp $04			; $727a
	ret nc			; $727c

	; Update angle, animation based on state
	ld b,a			; $727d
	swap a			; $727e
	rrca			; $7280
	ld e,Enemy.angle		; $7281
	ld (de),a		; $7283
	ld a,b			; $7284
	jp enemySetAnimation		; $7285

@stillCountingDown:
	cp 59			; $7288
	ret nz			; $728a

	; NOTE: Why on earth is this sound played? SND_WHISTLE would make more sense...
	ld a,SND_MAKU_TREE_PAST		; $728b
	call playSound		; $728d

	; Alert all guards to start moving more quickly
	ld e,Enemy.var35		; $7290


;;
; @param	de	Variable to set on the guards. "var34" to alert them to Link
;			immediately, "var35" to make them patrol faster.
; @addr{7292}
_ambiGuard_alertAllGuards:
	ldhl FIRST_ENEMY_INDEX,Enemy.enabled		; $7292
---
	ld l,Enemy.id		; $7295
	ld a,(hl)		; $7297
	cp ENEMYID_AMBI_GUARD			; $7298
	jr nz,@nextEnemy	; $729a

	ld a,h			; $729c
	cp d			; $729d
	jr z,@nextEnemy	; $729e

	ld l,e			; $72a0
	ld a,(hl)		; $72a1
	or a			; $72a2
	jr nz,@nextEnemy	; $72a3

	inc (hl)		; $72a5
	bit 0,l			; $72a6
	jr z,@nextEnemy	; $72a8

	ld l,Enemy.var36		; $72aa
	ld (hl),60		; $72ac
@nextEnemy:
	inc h			; $72ae
	ld a,h			; $72af
	cp LAST_ENEMY_INDEX+1			; $72b0
	jr c,---		; $72b2
	ret			; $72b4


;;
; Checks for spotting Link, among other things?
; @addr{72b5}
_ambiGuard_checkSpottedLink:
	ld a,(wScentSeedActive)		; $72b5
	or a			; $72b8
	jr nz,@scentSeed	; $72b9

@normalCheck:
	; Notice Link if playing the flute.
	; (Doesn't work properly for harp tunes?)
	ld a,(wLinkPlayingInstrument)		; $72bb
	or a			; $72be
	jr nz,@faceLink	; $72bf

	; if var3a == $ff, turn toward part object?
	ld e,Enemy.var3a		; $72c1
	ld a,(de)		; $72c3
	inc a			; $72c4
	jr nz,@commonUpdate	; $72c5

	ld (de),a ; [var3a] = 0

	ld a,Object.yh		; $72c8
	call objectGetRelatedObject2Var		; $72ca
	ld b,(hl)		; $72cd
	ld l,Object.xh		; $72ce
	ld c,(hl)		; $72d0
	call objectGetRelativeAngle		; $72d1
	jr @alertGuardToMoveFast		; $72d4

@scentSeed:
	; When [var37] == 0, the guard notices the scent seed (turns toward it and has an
	; exclamation point).
	ld h,d			; $72d6
	ld l,Enemy.var37		; $72d7
	ld a,(hl)		; $72d9
	or a			; $72da
	jr z,@noticedScentSeed	; $72db

	ld a,(wFrameCounter)		; $72dd
	rrca			; $72e0
	jr c,@normalCheck	; $72e1
	dec (hl)		; $72e3
	jr @normalCheck		; $72e4

@noticedScentSeed:
	; Set the counter to more than the duration of a scent seed, so the guard only
	; turns toward it once...
	ld (hl),150 ; [var37]

@faceLink:
	call objectGetAngleTowardEnemyTarget		; $72e8

@alertGuardToMoveFast:
	; When reaching here, a == angle the guard should face
	ld h,d			; $72eb
	ld l,Enemy.var35		; $72ec
	inc (hl)		; $72ee
	inc l			; $72ef
	ld (hl),60 ; [var36]
	call _ambiGuard_setAngle		; $72f2

@commonUpdate:
	; If [var3b] == $ff, notice Link immediately.
	ld h,d			; $72f5
	ld l,Enemy.var3b		; $72f6
	ld a,(hl)		; $72f8
	ld (hl),$00		; $72f9
	inc a			; $72fb
	jr nz,++		; $72fc
	ld l,Enemy.var34		; $72fe
	ld a,(hl)		; $7300
	or a			; $7301
	jr nz,++		; $7302
	inc (hl) ; [var34]
	call _ambiGuard_setCounter2ForAttackingTypeOnly		; $7305
++
	ld e,Enemy.var34		; $7308
	ld a,(de)		; $730a
	rrca			; $730b
	jr nc,@haventSeenLinkYet	; $730c

	; Return if bit 1 of var34 set (already noticed Link)
	rrca			; $730e
	ret c			; $730f

	; Link is close enough to have been noticed. Do some extra checks for the "tossing
	; Link out" subids only.

	ld l,Enemy.subid		; $7310
	bit 7,(hl)		; $7312
	jr nz,@noticedLink	; $7314

	call checkLinkCollisionsEnabled		; $7316
	ret nc			; $7319

	ld a,(w1Link.zh)		; $731a
	rlca			; $731d
	ret c			; $731e

	; Link has been seen. Disable inputs, etc.

	ld a,$80		; $731f
	ld (wMenuDisabled),a		; $7321

	ld a,DISABLE_COMPANION|DISABLE_LINK		; $7324
	ld (wDisabledObjects),a		; $7326
	ld (wDisableScreenTransitions),a		; $7329

	; Wait for 60 frames
	ld e,Enemy.var36		; $732c
	ld a,60		; $732e
	ld (de),a		; $7330

	call _ambiGuard_createExclamationMark		; $7331

@noticedLink:
	; Mark bit 1 to indicate the exclamation mark was shown already, etc.
	ld h,d			; $7334
	ld l,Enemy.var34		; $7335
	set 1,(hl)		; $7337

	ld l,Enemy.state		; $7339
	ld (hl),$0f		; $733b

	; Delete PARTID_DETECTION_HELPER
	ld a,Object.health		; $733d
	call objectGetRelatedObject2Var		; $733f
	ld (hl),$00		; $7342
	ret			; $7344

@haventSeenLinkYet:
	; Was the guard hit with an indirect attack?
	inc e			; $7345
	ld a,(de) ; [var35]
	rrca			; $7347
	ret nc			; $7348

	; He was; update speed, make exclamation mark.
	xor a			; $7349
	ld (de),a		; $734a

	ld l,Enemy.speed		; $734b
	ld (hl),SPEED_140		; $734d

	; fall through

;;
; @addr{734f}
_ambiGuard_createExclamationMark:
	ld a,45		; $734f
	ld bc,$f408		; $7351
	jp objectCreateExclamationMark		; $7354


_ambiGuard_collisionOccured:
	; If already noticed Link, return
	ld e,Enemy.var34		; $7357
	ld a,(de)		; $7359
	or a			; $735a
	ret nz			; $735b

	; Check whether attack type was direct or indirect
	ld h,d			; $735c
	ld l,Enemy.var2a		; $735d
	ld a,(hl)		; $735f
	cp $80|ITEMCOLLISION_11+1			; $7360
	jr c,_ambiGuard_directAttackOccurred	; $7362

	cp $80|ITEMCOLLISION_GALE_SEED			; $7364
	ret z			; $7366

	; COLLISION_TYPE_SOMARIA_BLOCK or above (indirect attack)
	ld h,d			; $7367
	ld l,Enemy.var35		; $7368
	ld a,(hl)		; $736a
	or a			; $736b
	ret nz			; $736c

	inc (hl) ; [var35] = 1 (make guard move move quickly)
	inc l			; $736e
	ld (hl),90 ; [var36] (wait for 90 frames)

	ld l,Enemy.knockbackAngle		; $7371
	ld a,(hl)		; $7373
	xor $10			; $7374

	; fall through


;;
; @param	a	Angle
; @addr{7376}
_ambiGuard_setAngle:
	add $04			; $7376
	and $18			; $7378
	ld e,Enemy.angle		; $737a
	ld (de),a		; $737c

	swap a			; $737d
	rlca			; $737f
	jp enemySetAnimation		; $7380

;;
; A collision with one of Link's direct attacks (sword, fist, etc) occurred.
; @addr{7383}
_ambiGuard_directAttackOccurred:
	; Guard notices Link right away
	ld e,Enemy.var34		; $7383
	ld a,$01		; $7385
	ld (de),a		; $7387

;;
; Does some initialization for "attacking link" type only, when they just notice Link.
; @addr{7388}
_ambiGuard_setCounter2ForAttackingTypeOnly:
	ld e,Enemy.subid		; $7388
	ld a,(de)		; $738a
	rlca			; $738b
	ret nc			; $738c

	; For "attacking Link" subids only, do extra initialization
	ld e,Enemy.counter2		; $738d
	ld a,90		; $738f
	ld (de),a		; $7391
	ld e,Enemy.var36		; $7392
	xor a			; $7394
	ld (de),a		; $7395
	ret			; $7396


; Scampering away when health is 0
_ambiGuard_noHealth:
	ld e,Enemy.state2		; $7397
	ld a,(de)		; $7399
	rst_jumpTable			; $739a
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d			; $73a1
	ld l,e			; $73a2
	inc (hl) ; [state2]

	ld l,Enemy.speedZ		; $73a4
	ld a,$00		; $73a6
	ldi (hl),a		; $73a8
	ld (hl),$ff		; $73a9

; Initial jump before moving away
@substate1:
	ld c,$20		; $73ab
	call objectUpdateSpeedZ_paramC		; $73ad
	ret nz			; $73b0

	; Landed
	ld l,Enemy.state2		; $73b1
	inc (hl)		; $73b3

	ld l,Enemy.speedZ		; $73b4
	ld a,<(-$1c0)		; $73b6
	ldi (hl),a		; $73b8
	ld (hl),>(-$1c0)		; $73b9

	ld l,Enemy.speed		; $73bb
	ld (hl),SPEED_140		; $73bd

	ld l,Enemy.knockbackAngle		; $73bf
	ld a,(hl)		; $73c1
	ld l,Enemy.angle		; $73c2
	ld (hl),a		; $73c4

	add $04			; $73c5
	and $18			; $73c7
	swap a			; $73c9
	rlca			; $73cb
	jp enemySetAnimation		; $73cc

; Moving away until off-screen
@substate2:
	ld e,Enemy.yh		; $73cf
	ld a,(de)		; $73d1
	cp LARGE_ROOM_HEIGHT<<4			; $73d2
	jp nc,enemyDelete		; $73d4

	ld e,Enemy.xh		; $73d7
	ld a,(de)		; $73d9
	cp LARGE_ROOM_WIDTH<<4			; $73da
	jp nc,enemyDelete		; $73dc

	call objectApplySpeed		; $73df
	ld c,$20		; $73e2
	call objectUpdateSpeedZ_paramC		; $73e4
	jp nz,enemyAnimate		; $73e7

	; Landed on ground
	ld l,Enemy.speedZ		; $73ea
	ld a,<(-$1c0)		; $73ec
	ldi (hl),a		; $73ee
	ld (hl),>(-$1c0)		; $73ef
	ret			; $73f1


; The tables below define the guards' patrol patterns.
; See include/movementscript_commands.s.
_ambiGuard_tossesLinkOut_scriptTable:
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05
	.dw @subid06
	.dw @subid07
	.dw @subid08
	.dw @subid09
	.dw @subid0a
	.dw @subid0b
	.dw @subid0c

@subid00:
	.db SPEED_c0
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_left  $28
	ms_down  $58
	ms_right $68
	ms_loop  @@loop

@subid01:
	.db SPEED_c0
	.db DIR_RIGHT
@@loop:
	ms_right $30
	ms_state 15, $0d
	ms_right $58
	ms_wait  30
	ms_left  $30
	ms_state 15, $0d
	ms_left  $08
	ms_wait  30
	ms_loop  @@loop

@subid02:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $78
	ms_down  $18
	ms_wait  60
	ms_left  $38
	ms_down  $18
	ms_wait  60
	ms_right $58
	ms_loop  @@loop

@subid03:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $78
	ms_up    $38
	ms_wait  60
	ms_left  $18
	ms_down  $38
	ms_wait  60
	ms_right $48
	ms_loop  @@loop

@subid04:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $38
	ms_right $48
	ms_wait  60
	ms_left  $18
	ms_down  $38
	ms_wait  60
	ms_up    $18
	ms_right $48
	ms_state 15, $0d
	ms_wait  40
	ms_state 15, $0d
	ms_loop  @@loop

@subid05:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $38
	ms_state 15, $0d
	ms_wait  40
	ms_state 15, $0d
	ms_left  $38
	ms_down  $58
	ms_left  $38
	ms_wait  60
	ms_right $68
	ms_state 15, $0d
	ms_wait  40
	ms_state 15, $0d
	ms_loop  @@loop

@subid06:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $38
	ms_down  $48
	ms_right $38
	ms_wait  60
	ms_down  $68
	ms_left  $18
	ms_up    $18
	ms_loop  @@loop

@subid07:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_right $88
	ms_down  $68
	ms_left  $68
	ms_up    $48
	ms_left  $68
	ms_wait  60
	ms_loop  @@loop

@subid08:
	.db SPEED_80
	.db DIR_LEFT
@@loop:
	ms_left  $18
	ms_state 15, $0d
	ms_up    $18
	ms_state 15, $0d
	ms_right $78
	ms_state 15, $0d
	ms_down  $58
	ms_state 15, $0d
	ms_left  $48
	ms_loop  @@loop

@subid09:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $78
	ms_state 15, $0d
	ms_up    $18
	ms_state 15, $0d
	ms_left  $28
	ms_state 15, $0d
	ms_down  $58
	ms_state 15, $0d
	ms_right $58
	ms_loop  @@loop

@subid0a:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_wait  127
	ms_loop  @@loop

@subid0b:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_wait  127
	ms_loop  @@loop

@subid0c:
	.db SPEED_80
	.db DIR_LEFT
@@loop:
	ms_wait  127
	ms_loop  @@loop


_ambiGuard_attacksLink_scriptTable:
	.dw @subid80
	.dw @subid81
	.dw @subid82
	.dw @subid83
	.dw @subid84
	.dw @subid85
	.dw @subid86
	.dw @subid87
	.dw @subid88
	.dw @subid89
	.dw @subid8a
	.dw @subid8b
	.dw @subid8c


@subid80:
	.db SPEED_c0
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_left  $28
	ms_down  $58
	ms_right $68
	ms_loop  @@loop

@subid81:
	.db SPEED_c0
	.db DIR_RIGHT
@@loop:
	ms_right $30
	ms_state 15, $0d
	ms_right $58
	ms_wait  30
	ms_left  $30
	ms_state 15, $0d
	ms_left  $08
	ms_wait  30
	ms_loop  @@loop

@subid82:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $88
	ms_left  $28
	ms_up    $48
	ms_state 15, $0d
	ms_down  $88
	ms_right $98
	ms_up    $28
	ms_left  $28
	ms_down  $48
	ms_state 15, $0d
	ms_up    $28
	ms_right $98
	ms_loop  @@loop

@subid83:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $58
	ms_right $d8
	ms_up    $28
	ms_left  $98
	ms_down  $58
	ms_right $d8
	ms_down  $88
	ms_left  $98
	ms_up    $78
	ms_loop  @@loop

@subid84:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_right $d8
	ms_down  $88
	ms_left  $18
	ms_loop  @@loop

@subid85:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $88
	ms_left  $18
	ms_up    $18
	ms_right $d8
	ms_loop  @@loop

@subid86:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $58
	ms_left  $28
	ms_up    $28
	ms_right $68
	ms_loop  @@loop

@subid87:
	.db SPEED_80
	.db DIR_RIGHT
@@loop:
	ms_right $c8
	ms_up    $28
	ms_left  $88
	ms_down  $58
	ms_loop  @@loop

@subid88:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $58
	ms_left  $58
	ms_down  $88
	ms_right $98
	ms_loop  @@loop

@subid89:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $28
	ms_left  $38
	ms_down  $88
	ms_right $98
	ms_loop  @@loop

@subid8a:
	.db SPEED_80
	.db DIR_DOWN
@@loop:
	ms_down  $98
	ms_right $c8
	ms_up    $18
	ms_left  $a8
	ms_wait  60
	ms_right $c8
	ms_down  $98
	ms_left  $a8
	ms_up    $18
	ms_wait  60
	ms_loop  @@loop

@subid8b:
	.db SPEED_80
	.db DIR_UP
@@loop:
	ms_up    $18
	ms_left  $28
	ms_down  $58
	ms_right $48
	ms_down  $98
	ms_left  $28
	ms_up    $58
	ms_right $48
	ms_loop  @@loop

@subid8c:
	.db SPEED_80
	.db DIR_LEFT
@@loop:
	ms_left  $78
	ms_wait  60
	ms_down  $58
	ms_wait  60
	ms_right $78
	ms_wait  60
	ms_up    $58
	ms_wait  60
	ms_loop  @@loop



; ==============================================================================
; ENEMYID_CANDLE
;
; Variables:
;   relatedObj1: reference to INTERACID_EXPLOSION while exploding
; ==============================================================================
enemyCode55:
	call _ecom_checkHazards		; $760a
	jr z,@normalStatus	; $760d
	sub ENEMYSTATUS_NO_HEALTH			; $760f
	ret c			; $7611

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK
	; Check for ember seed collision to light self on fire
	ld e,Enemy.var2a		; $7612
	ld a,(de)		; $7614
	cp $80|ITEMCOLLISION_EMBER_SEED			; $7615
	jr nz,@normalStatus	; $7617

	ld e,Enemy.state		; $7619
	ld a,(de)		; $761b
	cp $0a			; $761c
	jr nc,@normalStatus	; $761e

	ld a,$0a		; $7620
	ld (de),a		; $7622

@normalStatus:
	ld e,Enemy.state		; $7623
	ld a,(de)		; $7625
	rst_jumpTable			; $7626
	.dw _candle_state_uninitialized
	.dw _candle_state_stub
	.dw _candle_state_stub
	.dw _candle_state_stub
	.dw _candle_state_stub
	.dw _candle_state_stub
	.dw _candle_state_stub
	.dw _candle_state_stub
	.dw _candle_state8
	.dw _candle_state9
	.dw _candle_stateA
	.dw _candle_stateB
	.dw _candle_stateC
	.dw _candle_stateD
	.dw _candle_stateE


_candle_state_uninitialized:
	ld e,Enemy.counter1		; $7645
	ld a,30		; $7647
	ld (de),a		; $7649

	ld a,SPEED_40		; $764a
	jp _ecom_setSpeedAndState8AndVisible		; $764c


_candle_state_stub:
	ret			; $764f


; Standing still for [counter1] frames
_candle_state8:
	call _ecom_decCounter1		; $7650
	ret nz			; $7653

	ld l,e			; $7654
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $7656
	ld (hl),90		; $7658

	; Choose random angle
	call getRandomNumber_noPreserveVars		; $765a
	and $18			; $765d
	add $04			; $765f
	ld e,Enemy.angle		; $7661
	ld (de),a		; $7663
	ld a,$01		; $7664
	jp enemySetAnimation		; $7666


; Walking for [counter1] frames
_candle_state9:
	call _ecom_decCounter1		; $7669
	jr nz,++		; $766c

	ld (hl),30 ; [counter1]
	ld l,e			; $7670
	dec (hl) ; [state]
	xor a			; $7672
	call enemySetAnimation		; $7673
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $7676
	jr _candle_animate		; $7679


; Just lit on fire
_candle_stateA:
	ld b,PARTID_CANDLE_FLAME		; $767b
	call _ecom_spawnProjectile		; $767d
	ret nz			; $7680

	call _ecom_incState		; $7681

	ld l,Enemy.counter1		; $7684
	ld (hl),120		; $7686

	ld l,Enemy.speed		; $7688
	ld (hl),SPEED_100		; $768a

	ld a,$02		; $768c
	jp enemySetAnimation		; $768e


; Moving slowly at first
_candle_stateB:
	call _ecom_decCounter1		; $7691
	jr nz,_candle_applySpeed		; $7694

	ld (hl),120 ; [counter1]
	ld l,e			; $7698
	inc (hl) ; [state]

	ld l,Enemy.speed		; $769a
	ld (hl),SPEED_200		; $769c
	ld a,$03		; $769e
	call enemySetAnimation		; $76a0

_candle_applySpeed:
	call objectApplySpeed		; $76a3
	call _ecom_bounceOffWallsAndHoles		; $76a6

_candle_animate:
	jp enemyAnimate		; $76a9


; Moving faster
_candle_stateC:
	call _ecom_decCounter1		; $76ac
	jr nz,_candle_applySpeed	; $76af

	ld (hl),60 ; [counter1]
	ld l,e			; $76b3
	inc (hl) ; [state]


; Flickering visibility, about to explode
_candle_stateD:
	call _ecom_flickerVisibility		; $76b5
	call _ecom_decCounter1		; $76b8
	jr nz,_candle_applySpeed	; $76bb

	inc (hl) ; [counter1] = 1

	; Create an explosion object; but the collisions are still provided by the candle
	; object, so this doesn't delete itself yet.
	ld b,INTERACID_EXPLOSION		; $76be
	call objectCreateInteractionWithSubid00		; $76c0
	ret nz			; $76c3
	ld a,h			; $76c4
	ld h,d			; $76c5
	ld l,Enemy.relatedObj1+1		; $76c6
	ldd (hl),a		; $76c8
	ld (hl),Interaction.start		; $76c9

	ld l,Enemy.state		; $76cb
	inc (hl)		; $76cd

	ld l,Enemy.enemyCollisionMode		; $76ce
	ld (hl),ENEMYCOLLISION_PODOBOO		; $76d0

	jp objectSetInvisible		; $76d2


; Waiting for explosion to end
_candle_stateE:
	ld a,Object.animParameter		; $76d5
	call objectGetRelatedObject1Var		; $76d7
	ld a,(hl)		; $76da
	or a			; $76db
	ret z			; $76dc

	rlca			; $76dd
	jr c,@done	; $76de

	; Explosion radius increased
	ld (hl),$00 ; [child.animParameter]
	ld l,Enemy.collisionRadiusY		; $76e2
	ld a,$0c		; $76e4
	ldi (hl),a		; $76e6
	ld (hl),a		; $76e7
	ret			; $76e8

@done:
	call markEnemyAsKilledInRoom		; $76e9
	call decNumEnemies		; $76ec
	jp enemyDelete		; $76ef


; ==============================================================================
; ENEMYID_KING_MOBLIN_MINION
; ==============================================================================
enemyCode56:
	jpab bank10.enemyCode56_body		; $76f2


; ==============================================================================
; ENEMYID_VERAN_POSSESSION_BOSS
;
; Variables:
;   relatedObj1: For subid 2 (veran ghost/human), this is a reference to subid 0 or 1
;                (nayru/ambi form).
;   var30: Animation index
;   var31/var32: Target position when moving
;   var33: Number of hits remaining
;   var34: Current pillar index
;   var35: Bit 0 set if already showed veran's "taunting" text after using switch hook
; ==============================================================================
enemyCode61:
	jr z,@normalStatus	; $76fa
	sub ENEMYSTATUS_NO_HEALTH			; $76fc
	ret c			; $76fe

	; ENEMYSTATUS_KNOCKBACK or ENEMYSTATUS_JUST_HIT
	call _veranPossessionBoss_wasHit		; $76ff

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $7702
	jr c,@commonState	; $7705
	ld a,b			; $7707
	rst_jumpTable			; $7708
	.dw _veranPossessionBoss_subid0
	.dw _veranPossessionBoss_subid1
	.dw _veranPossessionBoss_subid2
	.dw _veranPossessionBoss_subid3

@commonState:
	rst_jumpTable			; $7711
	.dw _veranPossessionBoss_state_uninitialized
	.dw _veranPossessionBoss_state_stub
	.dw _veranPossessionBoss_state_stub
	.dw _veranPossessionBoss_state_switchHook
	.dw _veranPossessionBoss_state_stub
	.dw _veranPossessionBoss_state_stub
	.dw _veranPossessionBoss_state_stub
	.dw _veranPossessionBoss_state_stub


_veranPossessionBoss_state_uninitialized:
	bit 1,b			; $7722
	jr nz,++		; $7724
	ld a,ENEMYID_VERAN_POSSESSION_BOSS		; $7726
	ld (wEnemyIDToLoadExtraGfx),a		; $7728
++
	ld a,b			; $772b
	add a			; $772c
	add b			; $772d
	ld e,Enemy.var30		; $772e
	ld (de),a		; $7730
	call enemySetAnimation		; $7731

	call objectSetVisible82		; $7734

	ld a,SPEED_200		; $7737
	call _ecom_setSpeedAndState8		; $7739

	ld l,Enemy.subid		; $773c
	bit 1,(hl)		; $773e
	ret z			; $7740

	; For subids 2-3 only
	ld l,Enemy.oamFlagsBackup		; $7741
	ld a,$01		; $7743
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]

	ld l,Enemy.counter1		; $7747
	ld (hl),$0c		; $7749

	ld l,Enemy.speed		; $774b
	ld (hl),SPEED_80		; $774d
	ret			; $774f


_veranPossessionBoss_state_switchHook:
	inc e			; $7750
	ld a,(de)		; $7751
	rst_jumpTable			; $7752
	.dw @substate0
	.dw enemyAnimate
	.dw enemyAnimate
	.dw @substate3

@substate0:
	ld h,d			; $775b
	ld l,Enemy.collisionType		; $775c
	res 7,(hl)		; $775e
	jp _ecom_incState2		; $7760

@substate3:
	ld b,$0b		; $7763
	call _ecom_fallToGroundAndSetState		; $7765
	ld l,Enemy.counter1		; $7768
	ld (hl),40		; $776a
	ret			; $776c


_veranPossessionBoss_state_stub:
	ret			; $776d


; Possessed Nayru
_veranPossessionBoss_subid0:
	ld a,(de)		; $776e
	sub $08			; $776f
	rst_jumpTable			; $7771
	.dw _veranPossessionBoss_nayruAmbi_state8
	.dw _veranPossessionBoss_nayruAmbi_state9
	.dw _veranPossessionBoss_nayruAmbi_stateA
	.dw _veranPossessionBoss_nayruAmbi_stateB
	.dw _veranPossessionBoss_nayru_stateC
	.dw _veranPossessionBoss_nayru_stateD
	.dw _veranPossessionBoss_nayruAmbi_stateE
	.dw _veranPossessionBoss_nayruAmbi_stateF
	.dw _veranPossessionBoss_nayruAmbi_state10
	.dw _veranPossessionBoss_nayruAmbi_state11
	.dw _veranPossessionBoss_nayruAmbi_state12
	.dw _veranPossessionBoss_nayruAmbi_state13
	.dw _veranPossessionBoss_nayru_state14


; Initialization
_veranPossessionBoss_nayruAmbi_state8:
	call getFreePartSlot		; $778c
	ret nz			; $778f

	ld (hl),PARTID_SHADOW		; $7790
	ld l,Part.var03		; $7792
	ld (hl),$06 ; Y-offset of shadow relative to self

	ld l,Part.relatedObj1		; $7796
	ld a,Enemy.start		; $7798
	ldi (hl),a		; $779a
	ld (hl),d		; $779b

	; Go to state 9
	call _veranPossessionBoss_nayruAmbi_beginMoving		; $779c

	ld l,Enemy.var3f		; $779f
	set 5,(hl)		; $77a1

	ld l,Enemy.var33		; $77a3
	ld (hl),$03		; $77a5
	inc l			; $77a7
	dec (hl) ; [var34] = $ff (current pillar index)

	xor a			; $77a9
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $77aa

	ld a,MUS_BOSS		; $77ad
	ld (wActiveMusic),a		; $77af
	jp playSound		; $77b2


; Flickering before moving
_veranPossessionBoss_nayruAmbi_state9:
	call _ecom_decCounter1		; $77b5
	jp nz,_ecom_flickerVisibility		; $77b8

	ld l,e			; $77bb
	inc (hl) ; [state]

	ld l,Enemy.zh		; $77bd
	ld (hl),-2		; $77bf
	call objectSetInvisible		; $77c1

	; Choose a position to move to.
	; First it chooses a pillar randomly, then it chooses the side of the pillar based
	; on where Link is in relation.

@choosePillar:
	call getRandomNumber_noPreserveVars		; $77c4
	and $0e			; $77c7
	cp $0b			; $77c9
	jr nc,@choosePillar	; $77cb

	; Pillar must be different from last one
	ld h,d			; $77cd
	ld l,Enemy.var34		; $77ce
	cp (hl)			; $77d0
	jr z,@choosePillar	; $77d1

	ld (hl),a ; [var34]

	ld hl,@pillarList		; $77d4
	rst_addAToHl			; $77d7
	ldi a,(hl)		; $77d8
	ld b,a			; $77d9
	ld c,(hl)		; $77da
	push bc			; $77db

	; Choose the side of the pillar that is furthest from Link
	ldh a,(<hEnemyTargetY)	; $77dc
	ldh (<hFF8F),a	; $77de
	ldh a,(<hEnemyTargetX)	; $77e0
	ldh (<hFF8E),a	; $77e2
	call objectGetRelativeAngleWithTempVars		; $77e4
	add $04			; $77e7
	and $18			; $77e9
	rrca			; $77eb
	rrca			; $77ec

	ld hl,@pillarOffsets		; $77ed
	rst_addAToHl			; $77f0
	pop bc			; $77f1
	ldi a,(hl)		; $77f2
	add b			; $77f3
	ld e,Enemy.var31		; $77f4
	ld (de),a ; [var31]
	ld a,(hl)		; $77f7
	add c			; $77f8
	inc e			; $77f9
	ld (de),a ; [var32]

	ld a,SND_CIRCLING		; $77fb
	jp playSound		; $77fd

@pillarList:
	.db $58 $58
	.db $58 $98
	.db $38 $38
	.db $38 $b8
	.db $78 $38
	.db $78 $b8

@pillarOffsets:
	.db $e8 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0


; Moving to new position
_veranPossessionBoss_nayruAmbi_stateA:
	ld h,d			; $7814
	ld l,Enemy.var31		; $7815
	call _ecom_readPositionVars		; $7817
	sub c			; $781a
	add $02			; $781b
	cp $05			; $781d
	jp nc,_ecom_moveTowardPosition		; $781f

	ldh a,(<hFF8F)	; $7822
	sub b			; $7824
	add $02			; $7825
	cp $05			; $7827
	jp nc,_ecom_moveTowardPosition		; $7829

	; Reached target position.

	ld l,Enemy.yh		; $782c
	ld (hl),b		; $782e
	ld l,Enemy.xh		; $782f
	ld (hl),c		; $7831

	ld l,e			; $7832
	inc (hl) ; [state]

	ld l,Enemy.zh		; $7834
	ld (hl),$00		; $7836

	ld l,Enemy.counter1		; $7838
	ld (hl),30		; $783a
	ret			; $783c


; Just reached new position
_veranPossessionBoss_nayruAmbi_stateB:
	call _ecom_decCounter1		; $783d
	jp nz,_ecom_flickerVisibility		; $7840

	call getRandomNumber_noPreserveVars		; $7843
	and $0f			; $7846
	ld b,a			; $7848

	ld h,d			; $7849
	ld l,Enemy.subid		; $784a
	ld a,(hl)		; $784c
	add a			; $784d
	add a			; $784e
	add (hl)		; $784f
	ld l,Enemy.var33		; $7850
	add (hl)		; $7852
	dec a			; $7853

	ld hl,@attackProbabilities		; $7854
	rst_addAToHl			; $7857
	ld a,b			; $7858
	cp (hl)			; $7859
	jr c,@beginAttacking			; $785a

	; Move again
	call _veranPossessionBoss_nayruAmbi_beginMoving		; $785c
	ld (hl),30		; $785f
	jp _ecom_flickerVisibility		; $7861

@beginAttacking:
	call _ecom_incState		; $7864

	ld l,Enemy.counter1		; $7867
	ld (hl),30		; $7869

	ld l,Enemy.collisionType		; $786b
	set 7,(hl)		; $786d

	ld l,Enemy.var30		; $786f
	ld a,(hl)		; $7871
	inc a			; $7872
	call enemySetAnimation		; $7873
	jp objectSetVisiblec2		; $7876

; Each byte is the probability of veran attacking when she has 'n' hits left (ie. 1st byte is
; for when she has 1 hit left). Higher values mean a higher probability of attacking. If
; she doesn't attack, she moves again.
@attackProbabilities:
	.db $05 $0a $10 $10 $10 ; Nayru
	.db $05 $06 $08 $08 $08 ; Ambi


; Delay before attacking with projectiles. (Nayru only)
_veranPossessionBoss_nayru_stateC:
	call _ecom_decCounter1		; $7883
	ret nz			; $7886

	ld (hl),142 ; [counter1]
	ld l,e			; $7889
	inc (hl) ; [state]

	ld b,PARTID_VERAN_PROJECTILE		; $788b
	jp _ecom_spawnProjectile		; $788d


; Attacking with projectiles. (This is only Nayru's state D, but Ambi's state D may call
; this if it's not spawning spiders instead.)
_veranPossessionBoss_nayru_stateD:
	call _ecom_decCounter1		; $7890
	ret nz			; $7893

_veranPossessionBoss_doneAttacking:
	call _veranPossessionBoss_nayruAmbi_beginMoving		; $7894

	ld l,Enemy.collisionType		; $7897
	res 7,(hl)		; $7899

	ld l,Enemy.var30		; $789b
	ld a,(hl)		; $789d
	jp enemySetAnimation		; $789e


; Just shot with mystery seeds
_veranPossessionBoss_nayruAmbi_stateE:
	call _ecom_decCounter2		; $78a1
	ret nz			; $78a4

	; Spawn veran ghost form
	call getFreeEnemySlot_uncounted		; $78a5
	ret nz			; $78a8
	ld (hl),ENEMYID_VERAN_POSSESSION_BOSS		; $78a9
	inc l			; $78ab
	ld (hl),$02 ; [child.subid]

	; [child.var33] = [this.var33] (remaining hits before death)
	ld l,Enemy.var33		; $78ae
	ld e,l			; $78b0
	ld a,(de)		; $78b1
	ld (hl),a		; $78b2

	ld l,Enemy.relatedObj1		; $78b3
	ld a,Enemy.start		; $78b5
	ldi (hl),a		; $78b7
	ld (hl),d		; $78b8

	ld bc,$fc04		; $78b9
	call objectCopyPositionWithOffset		; $78bc

	call _ecom_incState		; $78bf

	ld l,Enemy.collisionType		; $78c2
	res 7,(hl)		; $78c4

	ld l,Enemy.oamFlagsBackup		; $78c6
	ld a,$01		; $78c8
	ldi (hl),a ; [child.oamFlagsBackup]
	ld (hl),a  ; [child.oamFlags]

	jp objectSetVisible83		; $78cc


; Collapsed (ghost Veran is showing)
_veranPossessionBoss_nayruAmbi_stateF:
	ret			; $78cf


; Veran just returned to nayru/ambi's body
_veranPossessionBoss_nayruAmbi_state10:
	ld h,d			; $78d0
	ld l,e			; $78d1
	inc (hl) ; [state]

	ld l,Enemy.oamFlagsBackup		; $78d3
	ld a,$06		; $78d5
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]

	ld l,Enemy.counter1		; $78d9
	ld (hl),15		; $78db
	jp objectSetVisible82		; $78dd


; Remains collapsed on the floor for a few frames before moving again
_veranPossessionBoss_nayruAmbi_state11:
	call _ecom_decCounter1		; $78e0
	ret nz			; $78e3

	ld l,Enemy.var30		; $78e4
	ld a,(hl)		; $78e6
	call enemySetAnimation		; $78e7


_veranPossessionBoss_nayruAmbi_beginMoving:
	ld h,d			; $78ea
	ld l,Enemy.state		; $78eb
	ld (hl),$09		; $78ed

	ld l,Enemy.counter1		; $78ef
	ld (hl),60		; $78f1
	ret			; $78f3


; Veran was just defeated.
_veranPossessionBoss_nayruAmbi_state12:
	ld a,(wTextIsActive)		; $78f4
	or a			; $78f7
	ret nz			; $78f8
	call _ecom_incState		; $78f9
	ld a,$02		; $78fc
	jp fadeoutToWhiteWithDelay		; $78fe


; Waiting for screen to go white
_veranPossessionBoss_nayruAmbi_state13:
	ld a,(wPaletteThread_mode)		; $7901
	or a			; $7904
	ret nz			; $7905

	call _ecom_incState		; $7906
	jpab clearAllItemsAndPutLinkOnGround		; $7909


; Delete all objects (including self), resume cutscene with a newly created object
_veranPossessionBoss_nayru_state14:
	call clearWramBank1		; $7911

	ld hl,w1Link.enabled		; $7914
	ld (hl),$03		; $7917

	call getFreeInteractionSlot		; $7919
	ld (hl),INTERACID_NAYRU_SAVED_CUTSCENE		; $791c
	ret			; $791e


; Possessed Ambi
_veranPossessionBoss_subid1:
	ld a,(de)		; $791f
	sub $08			; $7920
	rst_jumpTable			; $7922
	.dw _veranPossessionBoss_nayruAmbi_state8
	.dw _veranPossessionBoss_nayruAmbi_state9
	.dw _veranPossessionBoss_nayruAmbi_stateA
	.dw _veranPossessionBoss_nayruAmbi_stateB
	.dw _veranPossessionBoss_ambi_stateC
	.dw _veranPossessionBoss_ambi_stateD
	.dw _veranPossessionBoss_nayruAmbi_stateE
	.dw _veranPossessionBoss_nayruAmbi_stateF
	.dw _veranPossessionBoss_nayruAmbi_state10
	.dw _veranPossessionBoss_nayruAmbi_state11
	.dw _veranPossessionBoss_nayruAmbi_state12
	.dw _veranPossessionBoss_nayruAmbi_state13
	.dw _veranPossessionBoss_ambi_state14


; Delay before attacking with projectiles or spawning spiders. (Ambi only)
_veranPossessionBoss_ambi_stateC:
	call _ecom_decCounter1		; $793d
	ret nz			; $7940

	ld (hl),142 ; [counter1]
	ld l,e			; $7943
	inc (hl) ; [state]

	call getRandomNumber_noPreserveVars		; $7945
	and $0f			; $7948
	ld b,a			; $794a

	ld e,Enemy.var33		; $794b
	ld a,(de)		; $794d
	dec a			; $794e
	ld hl,@spiderSpawnProbabilities		; $794f
	rst_addAToHl			; $7952
	ld a,b			; $7953
	cp (hl)			; $7954

	; Set [var03] to 1 if we're spawning spiders, 0 otherwise
	ld h,d			; $7955
	ld l,Enemy.var03		; $7956
	ld (hl),$01		; $7958
	ret nc			; $795a

	dec (hl)		; $795b
	ld b,PARTID_VERAN_PROJECTILE		; $795c
	jp _ecom_spawnProjectile		; $795e

; Each byte is the probability of veran spawning spiders when she has 'n' hits left (ie.
; 1st byte is for when she has 1 hit left). Lower values mean a higher probability of
; spawning spiders. If she doesn't spawn spiders, she fires projectiles.
@spiderSpawnProbabilities:
	.db $08 $08 $0a $0a $0a


; Attacking with projectiles or spiders. (Ambi only)
_veranPossessionBoss_ambi_stateD:
	; Jump to Nayru's state D if we're firing projectiles
	ld e,Enemy.var03		; $7966
	ld a,(de)		; $7968
	or a			; $7969
	jp z,_veranPossessionBoss_nayru_stateD		; $796a

	; Spawning spiders

	call _ecom_decCounter1		; $796d
	jp z,_veranPossessionBoss_doneAttacking		; $7970

	; Spawn spider every 32 frames
	ld a,(hl) ; [counter1]
	and $1f			; $7974
	ret nz			; $7976

	ld a,(wNumEnemies)		; $7977
	cp $06			; $797a
	ret nc			; $797c

	ld b,ENEMYID_VERAN_SPIDER		; $797d
	jp _ecom_spawnEnemyWithSubid01		; $797f


; Ambi-specific cutscene after Veran defeated
_veranPossessionBoss_ambi_state14:
	ld a,(wPaletteThread_mode)		; $7982
	or a			; $7985
	ret nz			; $7986

	; Deletes all objects, including self
	call clearWramBank1		; $7987

	ld a,$01		; $798a
	ld (wNumEnemies),a		; $798c

	ld hl,w1Link.enabled		; $798f
	ld (hl),$03		; $7992

	ld l,<w1Link.yh		; $7994
	ld (hl),$58		; $7996
	ld l,<w1Link.xh		; $7998
	ld (hl),$78		; $799a

	call setCameraFocusedObjectToLink		; $799c
	call resetCamera		; $799f

	; Spawn subid 3 of this object
	call getFreeEnemySlot_uncounted		; $79a2
	ld (hl),ENEMYID_VERAN_POSSESSION_BOSS		; $79a5
	inc l			; $79a7
	ld (hl),$03 ; [subid]

	ld l,Enemy.yh		; $79aa
	ld (hl),$48		; $79ac
	ld l,Enemy.xh		; $79ae
	ld (hl),$78		; $79b0
	ret			; $79b2


; Veran emerged in human form
_veranPossessionBoss_subid2:
	ld a,(de)		; $79b3
	sub $08			; $79b4
	rst_jumpTable			; $79b6
	.dw _veranPossessionBoss_humanForm_state8
	.dw _veranPossessionBoss_humanForm_state9
	.dw _veranPossessionBoss_humanForm_stateA
	.dw _veranPossessionBoss_humanForm_stateB
	.dw _veranPossessionBoss_humanForm_stateC
	.dw _veranPossessionBoss_humanForm_stateD
	.dw _veranPossessionBoss_humanForm_stateE
	.dw _veranPossessionBoss_humanForm_stateF
	.dw _veranPossessionBoss_humanForm_state10


; Moving upward just after spawning
_veranPossessionBoss_humanForm_state8:
	call objectApplySpeed		; $79c9
	call _ecom_decCounter1		; $79cc
	jr nz,_veranPossessionBoss_animate	; $79cf

	ld (hl),120 ; [counter1]
	ld l,Enemy.state		; $79d3
	inc (hl)		; $79d5

	ld l,Enemy.collisionType		; $79d6
	set 7,(hl)		; $79d8

	ld l,Enemy.enemyCollisionMode		; $79da
	ld (hl),ENEMYCOLLISION_VERAN_GHOST		; $79dc

	; If this is Nayru, and we haven't shown veran's taunting text yet, show it.
	ld a,Object.subid		; $79de
	call objectGetRelatedObject1Var		; $79e0
	ld a,(hl)		; $79e3
	or a			; $79e4
	jr nz,_veranPossessionBoss_animate	; $79e5

	ld l,Enemy.var35		; $79e7
	bit 0,(hl)		; $79e9
	jr nz,_veranPossessionBoss_animate	; $79eb

	inc (hl) ; [var35] |= 1

	ld bc,TX_2f2a		; $79ee
	call showText		; $79f1
	jr _veranPossessionBoss_animate		; $79f4


; Waiting for Link to use switch hook
_veranPossessionBoss_humanForm_state9:
	call _ecom_decCounter1		; $79f6
	jr nz,_veranPossessionBoss_animate	; $79f9

	ld (hl),12 ; [counter1]
	ld l,e			; $79fd
	inc (hl) ; [state]

	ld l,Enemy.angle		; $79ff
	ld (hl),ANGLE_DOWN		; $7a01

	ld l,Enemy.collisionType		; $7a03
	res 7,(hl)		; $7a05

_veranPossessionBoss_animate:
	jp enemyAnimate		; $7a07


; Moving down to re-possess her victim
_veranPossessionBoss_humanForm_stateA:
	call objectApplySpeed		; $7a0a
	call _ecom_decCounter1		; $7a0d
	jr nz,_veranPossessionBoss_animate	; $7a10

	ld l,Enemy.collisionType		; $7a12
	res 7,(hl)		; $7a14

_veranPossessionBoss_humanForm_returnToHost:
	; Send parent to state $10
	ld a,Object.state		; $7a16
	call objectGetRelatedObject1Var		; $7a18
	inc (hl)		; $7a1b

	; Update parent's "hits remaining" counter
	ld l,Enemy.var33		; $7a1c
	ld e,l			; $7a1e
	ld a,(de)		; $7a1f
	ld (hl),a		; $7a20

	jp enemyDelete		; $7a21


; Just finished using switch hook on ghost. Flickering between ghost and human forms.
_veranPossessionBoss_humanForm_stateB:
	call _ecom_decCounter1		; $7a24
	jr nz,@flickerBetweenForms	; $7a27

	ld (hl),120 ; [counter1]

	ld l,Enemy.enemyCollisionMode		; $7a2b
	ld (hl),ENEMYCOLLISION_VERAN_FAIRY		; $7a2d

	ld l,e			; $7a2f
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $7a31
	set 7,(hl)		; $7a33

	; NOTE: hl is supposed to be [counter1] for below, which it isn't. It only affects
	; the animation though, so no big deal...

@flickerBetweenForms:
	ld a,(hl) ; [counter1]
	rrca			; $7a36
	ld a,$09		; $7a37
	jr c,+			; $7a39
	ld a,$06		; $7a3b
+
	jp enemySetAnimation		; $7a3d


; Veran is vulnerable to attacks.
_veranPossessionBoss_humanForm_stateC:
	call _ecom_decCounter1		; $7a40
	jr nz,_veranPossessionBoss_animate	; $7a43

	; Time to return to host

	ld l,e			; $7a45
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $7a47
	res 7,(hl)		; $7a49

	ld l,Enemy.speed		; $7a4b
	ld (hl),SPEED_280		; $7a4d

	ld l,Enemy.speedZ		; $7a4f
	ld a,<(-$280)		; $7a51
	ldi (hl),a		; $7a53
	ld (hl),>(-$280)		; $7a54

	call objectSetVisiblec1		; $7a56

	; Set target position to be the nayru/ambi's position.
	; [this.var31] = [parent.yh], [this.var32] = [parent.xh]
	ld a,Object.yh		; $7a59
	call objectGetRelatedObject1Var		; $7a5b
	ld e,Enemy.var31		; $7a5e
	ldi a,(hl)		; $7a60
	ld (de),a ; [this.var31]
	inc e			; $7a62
	inc l			; $7a63
	ld a,(hl)		; $7a64
	ld (de),a ; [this.var32]

	jr _veranPossessionBoss_animate		; $7a66


; Moving back to nayru/ambi
_veranPossessionBoss_humanForm_stateD:
	ld c,$20		; $7a68
	call objectUpdateSpeedZ_paramC		; $7a6a

	ld l,Enemy.var31		; $7a6d
	call _ecom_readPositionVars		; $7a6f
	sub c			; $7a72
	add $02			; $7a73
	cp $05			; $7a75
	jp nc,_ecom_moveTowardPosition		; $7a77

	ldh a,(<hFF8F)	; $7a7a
	sub b			; $7a7c
	add $02			; $7a7d
	cp $05			; $7a7f
	jp nc,_ecom_moveTowardPosition		; $7a81

	; Reached nayru/ambi.

	ld l,Enemy.yh		; $7a84
	ld (hl),b		; $7a86
	ld l,Enemy.xh		; $7a87
	ld (hl),c		; $7a89

	; Wait until reached ground
	ld e,Enemy.zh		; $7a8a
	ld a,(de)		; $7a8c
	or a			; $7a8d
	ret nz			; $7a8e

	jp _veranPossessionBoss_humanForm_returnToHost		; $7a8f


; Health is zero; about to begin cutscene.
_veranPossessionBoss_humanForm_stateE:
	ld e,Enemy.invincibilityCounter		; $7a92
	ld a,(de)		; $7a94
	or a			; $7a95
	ret nz			; $7a96

	call checkLinkCollisionsEnabled		; $7a97
	ret nc			; $7a9a

	ldbc INTERACID_PUFF,$02		; $7a9b
	call objectCreateInteraction		; $7a9e
	ret nz			; $7aa1
	ld a,h			; $7aa2
	ld h,d			; $7aa3
	ld l,Enemy.relatedObj2+1		; $7aa4
	ldd (hl),a		; $7aa6
	ld (hl),Interaction.start		; $7aa7

	ld l,Enemy.state		; $7aa9
	inc (hl)		; $7aab

	ld a,DISABLE_LINK		; $7aac
	ld (wDisabledObjects),a		; $7aae
	ld (wMenuDisabled),a		; $7ab1

	jp objectSetInvisible		; $7ab4


; Waiting for puff to finish its animation
_veranPossessionBoss_humanForm_stateF:
	ld a,Object.animParameter		; $7ab7
	call objectGetRelatedObject2Var		; $7ab9
	bit 7,(hl)		; $7abc
	ret z			; $7abe
	jp _ecom_incState		; $7abf


; Sets nayru/ambi's state to $12, shows text, then deletes self
_veranPossessionBoss_humanForm_state10:
	ld a,Object.state		; $7ac2
	call objectGetRelatedObject1Var		; $7ac4
	ld (hl),$12		; $7ac7

	ld l,Enemy.subid		; $7ac9
	bit 0,(hl)		; $7acb
	ld bc,TX_560b		; $7acd
	jr z,+			; $7ad0
	ld bc,TX_5611		; $7ad2
+
	call showText		; $7ad5
	jp enemyDelete		; $7ad8



; Collapsed Ambi after the fight.
_veranPossessionBoss_subid3:
	ld a,(de)		; $7adb
	cp $08			; $7adc
	jr nz,@state9	; $7ade


; Waiting for palette to fade out
@state8:
	ld a,(wPaletteThread_mode)		; $7ae0
	or a			; $7ae3
	ret nz			; $7ae4

	call _ecom_incState		; $7ae5

	ld l,Enemy.counter2		; $7ae8
	ld (hl),60		; $7aea

	ld a,$05		; $7aec
	call enemySetAnimation		; $7aee

	jp fadeinFromWhite		; $7af1


; Waiting for palette to fade in; then spawn the real Ambi object and delete self.
@state9:
	ld a,(wPaletteThread_mode)		; $7af4
	or a			; $7af7
	ret nz			; $7af8

	call _ecom_decCounter2		; $7af9
	ret nz			; $7afc

	call getFreeInteractionSlot		; $7afd
	ret nz			; $7b00
	ld (hl),INTERACID_AMBI		; $7b01
	inc l			; $7b03
	ld (hl),$07 ; [subid]

	call objectCopyPosition		; $7b06

	ld a,TREE_GFXH_01		; $7b09
	ld (wLoadedTreeGfxIndex),a		; $7b0b

	jp enemyDelete		; $7b0e


;;
; @addr{7b11}
_veranPossessionBoss_wasHit:
	ld h,d			; $7b11
	ld l,Enemy.knockbackCounter		; $7b12
	ld (hl),$00		; $7b14

	ld e,Enemy.subid		; $7b16
	ld a,(de)		; $7b18
	cp $02			; $7b19
	ld l,Enemy.var2a		; $7b1b
	ld a,(hl)		; $7b1d
	jr z,@subid2	; $7b1e

	; Subid 0 or 1 (possessed Nayru or Ambi)

	res 7,a			; $7b20
	cp ITEMCOLLISION_MYSTERY_SEED			; $7b22
	jr z,@mysterySeed	; $7b24

	; Direct attacks from Link cause damage to Link, not Veran
	sub ITEMCOLLISION_L1_SWORD			; $7b26
	ret c			; $7b28
	cp ITEMCOLLISION_SHOVEL - ITEMCOLLISION_L1_SWORD + 1			; $7b29
	ret nc			; $7b2b

	ld l,Enemy.invincibilityCounter		; $7b2c
	ld (hl),-24		; $7b2e
	ld hl,w1Link.invincibilityCounter		; $7b30
	ld (hl),40		; $7b33

	; [w1Link.knockbackAngle] = [this.knockbackAngle] ^ $10
	inc l			; $7b35
	ld e,Enemy.knockbackAngle		; $7b36
	ld a,(de)		; $7b38
	xor $10			; $7b39
	ldi (hl),a		; $7b3b

	ld (hl),21 ; [w1Link.knockbackCounter]

	ld l,<w1Link.damageToApply		; $7b3e
	ld (hl),-8		; $7b40
	ret			; $7b42

@mysterySeed:
	ld l,Enemy.state		; $7b43
	ld (hl),$0e		; $7b45

	ld l,Enemy.counter2		; $7b47
	ld (hl),30		; $7b49

	ld l,Enemy.collisionType		; $7b4b
	res 7,(hl)		; $7b4d

	ld l,Enemy.var30		; $7b4f
	ld a,(hl)		; $7b51
	add $02			; $7b52
	jp enemySetAnimation		; $7b54

@subid2:
	; Collisions on emerged Veran (ghost/human form)
	; Check if a direct attack occurred
	res 7,a			; $7b57
	cp ITEMCOLLISION_L1_SWORD			; $7b59
	ret c			; $7b5b
	cp ITEMCOLLISION_EXPERT_PUNCH + 1			; $7b5c
	ret nc			; $7b5e

	ld l,Enemy.enemyCollisionMode		; $7b5f
	ld a,(hl)		; $7b61
	cp ENEMYCOLLISION_VERAN_GHOST			; $7b62
	jr nz,++		; $7b64

	; No effect on ghost form
	ld l,Enemy.invincibilityCounter		; $7b66
	ld (hl),-8		; $7b68
	ret			; $7b6a
++
	ld l,Enemy.counter1		; $7b6b
	ld (hl),$08		; $7b6d
	ld l,Enemy.var33		; $7b6f
	dec (hl)		; $7b71
	ret nz			; $7b72

	; Veran has been hit enough times to die now.

	ld l,Enemy.health		; $7b73
	ld (hl),$80		; $7b75

	ld l,Enemy.collisionType		; $7b77
	res 7,(hl)		; $7b79

	ld l,Enemy.state		; $7b7b
	ld (hl),$0e		; $7b7d

	ld a,$01		; $7b7f
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $7b81

	ld a,SNDCTRL_STOPMUSIC		; $7b84
	jp playSound		; $7b86


; ==============================================================================
; ENEMYID_VINE_SPROUT
;
; Variables:
;   var31: Tile index underneath the sprout?
;   var32: Short-form position of vine sprout
;   var33: Nonzero if the "tile properties" underneath this sprout have been modified
; ==============================================================================
enemyCode62:
	call objectReplaceWithAnimationIfOnHazard		; $7b89
	ret c			; $7b8c

	ld e,Enemy.state		; $7b8d
	ld a,(de)		; $7b8f
	rst_jumpTable			; $7b90
	.dw _vineSprout_state0
	.dw _vineSprout_state1
	.dw _vineSprout_state_grabbed
	.dw _vineSprout_state_switchHook
	.dw _vineSprout_state4


; Initialization
_vineSprout_state0:
	; Delete self if there is any other vine sprout on-screen already?
	ldhl FIRST_ENEMY_INDEX, Enemy.id		; $7b9b
@nextEnemy:
	ld a,(hl)		; $7b9e
	cp ENEMYID_VINE_SPROUT			; $7b9f
	jr nz,++		; $7ba1
	ld a,d			; $7ba3
	cp h			; $7ba4
	jp nz,enemyDelete		; $7ba5
++
	inc h			; $7ba8
	ld a,h			; $7ba9
	cp LAST_ENEMY_INDEX+1			; $7baa
	jr c,@nextEnemy	; $7bac

	ld h,d			; $7bae
	ld l,e			; $7baf
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $7bb1
	ld (hl),20		; $7bb3

	ld l,Enemy.speed		; $7bb5
	ld (hl),SPEED_c0		; $7bb7

	call _vineSprout_getPosition		; $7bb9
	call objectSetShortPosition		; $7bbc
	jp objectSetVisiblec2		; $7bbf


_vineSprout_state1:
	ld a,(wLinkInAir)		; $7bc2
	rlca			; $7bc5
	jp c,_vineSprout_linkJumpingDownCliff		; $7bc6

	call _vineSprout_checkLinkInSprout		; $7bc9
	ld e,Enemy.var33		; $7bcc
	ld a,(de)		; $7bce
	jp c,_vineSprout_restoreTileAtPosition		; $7bcf

	call objectAddToGrabbableObjectBuffer		; $7bd2
	call _vineSprout_updateTileAtPosition		; $7bd5

	; Check various conditions for whether to push the sprout
	ld hl,w1Link.id		; $7bd8
	ld a,(hl)		; $7bdb
	cpa SPECIALOBJECTID_LINK			; $7bdc
	jr nz,@notPushingSprout	; $7bdd

	ld l,<w1Link.state		; $7bdf
	ld a,(hl)		; $7be1
	cp LINK_STATE_NORMAL			; $7be2
	jr nz,@notPushingSprout	; $7be4

	; Must not be in midair
	ld l,<w1Link.zh		; $7be6
	bit 7,(hl)		; $7be8
	jr nz,@notPushingSprout	; $7bea

	; Can't be swimming
	ld a,(wLinkSwimmingState)		; $7bec
	or a			; $7bef
	jr nz,@notPushingSprout	; $7bf0

	; Must be moving
	ld a,(wLinkAngle)		; $7bf2
	inc a			; $7bf5
	jr z,@notPushingSprout	; $7bf6

	; Must not be pressing A or B
	ld a,(wGameKeysPressed)		; $7bf8
	and BTN_A|BTN_B			; $7bfb
	jr nz,@notPushingSprout	; $7bfd

	; Must not be holding anything
	ld a,(wLinkGrabState)		; $7bff
	or a			; $7c02
	jr nz,@notPushingSprout	; $7c03

	; Must be close enough
	ld c,$12		; $7c05
	call objectCheckLinkWithinDistance		; $7c07
	jr nc,@notPushingSprout	; $7c0a

	; Must be aligned properly
	ld b,$04		; $7c0c
	call objectCheckCenteredWithLink		; $7c0e
	jr nc,@notPushingSprout	; $7c11

	; Link must be moving forwards
	call _ecom_updateCardinalAngleAwayFromTarget		; $7c13
	add $04			; $7c16
	and $18			; $7c18
	ld (de),a ; [angle]
	swap a			; $7c1b
	rlca			; $7c1d
	ld b,a			; $7c1e
	ld a,(w1Link.direction)		; $7c1f
	cp b			; $7c22
	jr nz,@notPushingSprout	; $7c23

	; All the above must hold for 20 frames
	call _ecom_decCounter1		; $7c25
	ret nz			; $7c28

	; Attempt to push the sprout.

	ld a,(de) ; [angle]
	rrca			; $7c2a
	rrca			; $7c2b
	ld hl,@pushOffsets		; $7c2c
	rst_addAToHl			; $7c2f

	; Get destination position
	call objectGetPosition		; $7c30
	ldi a,(hl)		; $7c33
	add b			; $7c34
	ld b,a			; $7c35
	ld a,(hl)		; $7c36
	add c			; $7c37
	ld c,a			; $7c38

	; Must not be solid there
	call getTileCollisionsAtPosition		; $7c39
	jr nz,@notPushingSprout	; $7c3c

	; Push the sprout
	ld h,d			; $7c3e
	ld l,Enemy.state		; $7c3f
	ld (hl),$04		; $7c41
	ld l,Enemy.counter1		; $7c43
	ld (hl),$16		; $7c45
	ld a,SND_MOVEBLOCK		; $7c47
	call playSound		; $7c49
	jp _vineSprout_restoreTileAtPosition		; $7c4c

@notPushingSprout:
	ld e,Enemy.counter1		; $7c4f
	ld a,20		; $7c51
	ld (de),a		; $7c53
	ret			; $7c54

@pushOffsets:
	.db $f0 $00 ; DIR_UP
	.db $00 $10 ; DIR_RIGHT
	.db $10 $00 ; DIR_DOWN
	.db $00 $f0 ; DIR_LEFT


_vineSprout_linkJumpingDownCliff:
	call _vineSprout_restoreTileAtPosition		; $7c5d
	call _vineSprout_checkLinkInSprout		; $7c60
	ret nc			; $7c63

	; Check Link is close to ground
	ld l,SpecialObject.zh		; $7c64
	ld a,(hl)		; $7c66
	add $03			; $7c67
	ret nc			; $7c69

_vineSprout_destroy:
	ld b,INTERACID_ROCKDEBRIS		; $7c6a
	call objectCreateInteractionWithSubid00		; $7c6c

	call _vineSprout_getDefaultPosition		; $7c6f
	ld b,a			; $7c72
	ld a,(de) ; [subid]
	ld hl,wVinePositions		; $7c74
	rst_addAToHl			; $7c77
	ld (hl),b		; $7c78

	jp enemyDelete		; $7c79


_vineSprout_state_grabbed:
	inc e			; $7c7c
	ld a,(de)		; $7c7d
	rst_jumpTable			; $7c7e
	.dw @justGrabbed
	.dw @beingHeld
	.dw @justReleased
	.dw @hitGround

@justGrabbed:
	xor a			; $7c87
	ld (wLinkGrabState2),a		; $7c88
	inc a			; $7c8b
	ld (de),a		; $7c8c
	call _vineSprout_restoreTileAtPosition		; $7c8d
	jp objectSetVisiblec1		; $7c90

@beingHeld:
	ret			; $7c93

@justReleased:
	ld h,d			; $7c94
	ld l,Enemy.enabled		; $7c95
	res 1,(hl) ; Don't persist across rooms anymore
	ld l,Enemy.zh		; $7c99
	bit 7,(hl)		; $7c9b
	ret nz			; $7c9d

@hitGround:
	jr _vineSprout_destroy		; $7c9e


_vineSprout_state_switchHook:
	inc e			; $7ca0
	ld a,(de)		; $7ca1
	rst_jumpTable			; $7ca2
	.dw @justLatched
	.dw @beforeSwitch
	.dw objectCenterOnTile
	.dw @released

@justLatched:
	call _vineSprout_restoreTileAtPosition		; $7cab
	jp _ecom_incState2		; $7cae

@beforeSwitch:
	ret			; $7cb1

@released:
	ld b,$01		; $7cb2
	call _ecom_fallToGroundAndSetState		; $7cb4
	ret nz			; $7cb7
	call objectCenterOnTile		; $7cb8
	jp _vineSprout_updateTileAtPosition		; $7cbb


; Being pushed
_vineSprout_state4:
	ld hl,w1Link		; $7cbe
	call preventObjectHFromPassingObjectD		; $7cc1

	call _ecom_decCounter1		; $7cc4
	jp nz,_ecom_applyVelocityForTopDownEnemyNoHoles		; $7cc7

	; Done pushing
	ld (hl),20 ; [counter1]
	ld l,Enemy.state		; $7ccc
	ld (hl),$01		; $7cce

	call objectCenterOnTile		; $7cd0

	; fall through


;;
; Updates tile properties at current position, updates wVinePositions, if var33 is
; nonzero.
; @addr{7cd3}
_vineSprout_updateTileAtPosition:
	; Return if we've already done this
	ld e,Enemy.var33		; $7cd3
	ld a,(de)		; $7cd5
	or a			; $7cd6
	ret nz			; $7cd7

	call objectGetTileCollisions		; $7cd8
	ld (hl),$0f		; $7cdb
	ld e,Enemy.var31		; $7cdd
	ld h,>wRoomLayout		; $7cdf
	ld a,(hl)		; $7ce1
	ld (de),a ; [var31] = tile index
	inc e			; $7ce3
	ld a,l			; $7ce4
	ld (de),a ; [var32] = tile position
	ld (hl),TILEINDEX_00		; $7ce6

	inc e			; $7ce8
	ld a,$01		; $7ce9
	ld (de),a ; [var33] = 1

	; Ensure that the position is not on the screen boundary.
	; BUG: This could push the sprout into a wall? (Probably not possible with the
	; room layouts of the vanilla game...)
@fixVerticalBoundary:
	ld a,l			; $7cec
	and $f0			; $7ced
	jr nz,++		; $7cef
	set 4,l			; $7cf1
	jr @fixHorizontalBoundary			; $7cf3
++
	cp (SMALL_ROOM_HEIGHT-1)<<4			; $7cf5
	jr nz,@fixHorizontalBoundary		; $7cf7
	res 4,l			; $7cf9

@fixHorizontalBoundary:
	ld a,l			; $7cfb
	and $0f			; $7cfc
	jr nz,++		; $7cfe
	inc l			; $7d00
	jr @setPosition		; $7d01
++
	cp SMALL_ROOM_WIDTH-1			; $7d03
	jr nz,@setPosition	; $7d05
	dec l			; $7d07

@setPosition:
	ld e,Enemy.subid		; $7d08
	ld a,(de)		; $7d0a
	ld bc,wVinePositions		; $7d0b
	call addAToBc		; $7d0e
	ld a,l			; $7d11
	ld (bc),a		; $7d12
	ret			; $7d13

;;
; Undoes the changes done previously to the tile at the sprout's current position (the
; sprout is just moving off, or being destroyed, etc).
; @addr{7d14}
_vineSprout_restoreTileAtPosition:
	; Return if there's nothing to undo
	ld e,Enemy.var33		; $7d14
	ld a,(de)		; $7d16
	or a			; $7d17
	ret z			; $7d18

	xor a			; $7d19
	ld (de),a ; [var33]

	; Restore tile at this position
	dec e			; $7d1b
	ld a,(de) ; [var32]
	ld l,a			; $7d1d

	dec e			; $7d1e
	ld a,(de) ; [var31]
	ld h,>wRoomLayout		; $7d20
	ld (hl),a		; $7d22
	ld h,>wRoomCollisions		; $7d23
	ld (hl),$00		; $7d25
	ret			; $7d27


;;
; @param[out]	cflag	c if Link is in the sprout
; @addr{7d28}
_vineSprout_checkLinkInSprout:
	ld a,(wLinkObjectIndex)		; $7d28
	ld h,a			; $7d2b
	ld l,SpecialObject.yh		; $7d2c
	ld e,Enemy.yh		; $7d2e
	ld a,(de)		; $7d30
	sub (hl)		; $7d31
	add $06			; $7d32
	cp $0d			; $7d34
	ret nc			; $7d36

	ld l,SpecialObject.xh		; $7d37
	ld e,Enemy.xh		; $7d39
	ld a,(de)		; $7d3b
	sub (hl)		; $7d3c
	add $06			; $7d3d
	cp $0d			; $7d3f
	ret			; $7d41

;;
; @param[out]	a	Sprout's default position
; @param[out]	de	Enemy.subid
; @addr{7d42}
_vineSprout_getDefaultPosition:
	ld e,Enemy.subid		; $7d42
	ld a,(de)		; $7d44
	ld bc,@defaultVinePositions		; $7d45
	call addAToBc		; $7d48
	ld a,(bc)		; $7d4b
	ret			; $7d4c

@defaultVinePositions:
	.include "build/data/defaultVinePositions.s"


;;
; @param[out]	c	Sprout's position
; @addr{7d53}
_vineSprout_getPosition:
	ld e,Enemy.subid		; $7d53
	ld a,(de)		; $7d55
	ld hl,wVinePositions		; $7d56
	rst_addAToHl			; $7d59
	ld c,(hl)		; $7d5a

	; Check if the sprout is under a "respawnable tile" (ie. a bush). If so, return to
	; default position.
	ld b,>wRoomLayout		; $7d5b
	ld a,(bc)		; $7d5d
	ld e,a			; $7d5e
	ld hl,@respawnableTiles		; $7d5f
-
	ldi a,(hl)		; $7d62
	or a			; $7d63
	ret z			; $7d64
	cp e			; $7d65
	jr nz,-			; $7d66

	call _vineSprout_getDefaultPosition		; $7d68
	ld c,a			; $7d6b
	ret			; $7d6c

@respawnableTiles:
	.db $c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7
	.db $c8 $c9 $ca $00


; ==============================================================================
; ENEMYID_TARGET_CART_CRYSTAL
;
; Variables:
;   var03: 0 for no movement, 1 for up/down, 2 for left/right
; ==============================================================================
enemyCode63:
	jr z,@normalStatus	 		; $7d79

	; ENEMYSTATUS_JUST_HIT
	ld e,Enemy.state		; $7d7b
	ld a,$02		; $7d7d
	ld (de),a		; $7d7f

@normalStatus:
	ld e,Enemy.state		; $7d80
	ld a,(de)		; $7d82
	rst_jumpTable			; $7d83
	.dw _targetCartCrystal_state0
	.dw _targetCartCrystal_state1
	.dw _targetCartCrystal_state2


; Initialization
_targetCartCrystal_state0:
	ld a,$01		; $7d8a
	ld (de),a ; [state]
	call _targetCartCrystal_loadPosition		; $7d8d
	call _targetCartCrystal_loadBehaviour		; $7d90
	jr z,+			; $7d93
	call _targetCartCrystal_initSpeed		; $7d95
+
	jp objectSetVisible80		; $7d98


; Standard update state (update movement if it's a moving type)
_targetCartCrystal_state1:
	ld e,Enemy.var03		; $7d9b
	ld a,(de)		; $7d9d
	or a			; $7d9e
	jr z,+			; $7d9f
	call _targetCartCrystal_updateMovement		; $7da1
+
	ld e,Enemy.subid		; $7da4
	ld a,(de)		; $7da6
	cp $05			; $7da7
	jr nc,++		; $7da9
	ld a,(wTmpcfc0.targetCarts.cfdf)		; $7dab
	or a			; $7dae
	jp nz,enemyDelete		; $7daf
++
	jp enemyAnimate		; $7db2


; Target destroyed
_targetCartCrystal_state2:
	ld hl,wTmpcfc0.targetCarts.numTargetsHit		; $7db5
	inc (hl)		; $7db8

	; If in the first room, mark this one as destroyed
	ld e,Enemy.subid		; $7db9
	ld a,(de)		; $7dbb
	cp $05			; $7dbc
	jr nc,++		; $7dbe
	ld hl,wTmpcfc0.targetCarts.crystalsHitInFirstRoom		; $7dc0
	call setFlag		; $7dc3
++
	ld a,SND_GALE_SEED		; $7dc6
	call playSound		; $7dc8

	; Create the "debris" from destroying it
	ld a,$04		; $7dcb
@spawnNext:
	ldh (<hFF8B),a	; $7dcd
	ldbc INTERACID_FALLING_ROCK,$03		; $7dcf
	call objectCreateInteraction		; $7dd2
	jr nz,@delete	; $7dd5
	ld l,Interaction.angle		; $7dd7
	ldh a,(<hFF8B)	; $7dd9
	dec a			; $7ddb
	ld (hl),a		; $7ddc
	jr nz,@spawnNext	; $7ddd

@delete:
	jp enemyDelete		; $7ddf



;;
; Sets var03 to "behaviour" value (0-2)
;
; @param[out]	zflag	z iff [var03] == 0
; @addr{7de2}
_targetCartCrystal_loadBehaviour:
	ld a,(wTmpcfc0.targetCarts.targetConfiguration)		; $7de2
	swap a			; $7de5
	ld hl,@behaviourTable		; $7de7
	rst_addAToHl			; $7dea
	ld e,Enemy.subid		; $7deb
	ld a,(de)		; $7ded
	rst_addAToHl			; $7dee
	ld a,(hl)		; $7def
	inc e			; $7df0
	ld (de),a ; [var03]
	or a			; $7df2
	ret			; $7df3

@behaviourTable:
	.db $00 $00 $00 $00 $00 $00 $00 $00 ; Configuration 0
	.db $00 $00 $00 $00 $00 $00 $00 $00

	.db $00 $00 $00 $00 $02 $00 $00 $00 ; Configuration 1
	.db $00 $01 $00 $02 $00 $00 $00 $00

	.db $01 $00 $02 $00 $00 $00 $00 $02 ; Configuration 2
	.db $01 $01 $02 $02 $00 $00 $00 $00


;;
; Sets Y/X position based on "wTmpcfc0.targetCarts.targetConfiguration" and subid.
; @addr{7e24}
_targetCartCrystal_loadPosition:
	ld a,(wTmpcfc0.targetCarts.targetConfiguration)		; $7e24
	ld hl,@configurationTable		; $7e27
	rst_addAToHl			; $7e2a
	ld a,(hl)		; $7e2b
	rst_addAToHl			; $7e2c

	ld e,Enemy.subid		; $7e2d
	ld a,(de)		; $7e2f
	rst_addDoubleIndex			; $7e30
	ldi a,(hl)		; $7e31
	ld e,Enemy.yh		; $7e32
	ld (de),a		; $7e34
	ld a,(hl)		; $7e35
	ld e,Enemy.xh		; $7e36
	ld (de),a		; $7e38
	ret			; $7e39


; Lists positions of the 12 targets for each of the 3 configurations.
@configurationTable:
	.db @configuration0 - CADDR
	.db @configuration1 - CADDR
	.db @configuration2 - CADDR

@configuration0:
	.db $18 $38 ; 0 == [subid]
	.db $48 $58 ; 1 == [subid]
	.db $28 $98 ; ...
	.db $48 $c8
	.db $18 $b8
	.db $58 $38
	.db $28 $98
	.db $28 $d8
	.db $58 $d8
	.db $98 $d8
	.db $98 $90
	.db $98 $58

@configuration1:
	.db $48 $18
	.db $18 $38
	.db $48 $58
	.db $48 $68
	.db $18 $a8
	.db $18 $48
	.db $58 $68
	.db $18 $88
	.db $18 $d8
	.db $58 $d8
	.db $98 $d8
	.db $98 $78

@configuration2:
	.db $20 $18
	.db $48 $68
	.db $18 $70
	.db $48 $98
	.db $48 $c8
	.db $28 $68
	.db $58 $68
	.db $18 $b8
	.db $40 $d8
	.db $80 $d8
	.db $98 $90
	.db $98 $50

;;
; @addr{7e85}
_targetCartCrystal_initSpeed:
	ld h,d			; $7e85
	ld l,Enemy.speed		; $7e86
	ld (hl),SPEED_80		; $7e88

	ld l,Enemy.counter1		; $7e8a
	ld (hl),$20		; $7e8c

	ld l,Enemy.var03		; $7e8e
	ld a,(hl)		; $7e90
	cp $02			; $7e91
	jr z,++		; $7e93
	ld l,Enemy.angle		; $7e95
	ld (hl),ANGLE_UP		; $7e97
	ret			; $7e99
++
	ld l,Enemy.angle		; $7e9a
	ld (hl),ANGLE_LEFT		; $7e9c
	ret			; $7e9e

;;
; Crystal moves for a bit, switches directions, moves other way.
; @addr{7e9f}
_targetCartCrystal_updateMovement:
	call _ecom_decCounter1		; $7e9f
	jr nz,++		; $7ea2
	ld (hl),$40		; $7ea4
	ld l,Enemy.angle		; $7ea6
	ld a,(hl)		; $7ea8
	xor $10			; $7ea9
	ld (hl),a		; $7eab
++
	jp objectApplySpeed		; $7eac
