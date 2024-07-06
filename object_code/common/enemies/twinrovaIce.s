; ==================================================================================================
; ENEMY_TWINROVA_ICE
;
; Variables:
;   var3e: ?
; ==================================================================================================
enemyCode5d:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	; Hit something
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jr z,@normalStatus

	res 7,a
	sub ITEMCOLLISION_L2_SHIELD
	cp ITEMCOLLISION_L3_SHIELD-ITEMCOLLISION_L2_SHIELD + 1
	call c,twinrovaIce_bounceOffShield
	call ecom_updateCardinalAngleAwayFromTarget

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_1c0

	ld l,Enemy.counter1
	ld (hl),120

	ld l,Enemy.var3e
	ld (hl),$08

	ld a,SND_POOF
	call playSound
	jp objectSetVisible82


@state1:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl)


@state2:
	; Check if parent is dead
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,@delete

	ld l,Enemy.state
	ld a,(hl)
	cp $0a
	jr z,@delete

	call objectApplySpeed
	call ecom_bounceOffWallsAndHoles
	ret z
	ld a,SND_CLINK
	jp playSound

@delete:
	call objectCreatePuff
	jp enemyDelete


;;
; This doesn't appear to do anything other than make a sound, because the angle is
; immediately overwritten after this is called?
twinrovaIce_bounceOffShield:
	ld a,(w1Link.direction)
	swap a
	ld b,a
	ld e,Enemy.angle
	ld a,(de)
	add b
	ld hl,@bounceTable
	rst_addAToHl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	ld a,SND_CLINK
	jp playSound

@bounceTable:
	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01

	.db $00 $1f $1e $1d $1c $1b $1a $19
	.db $18 $17 $16 $15 $14 $13 $12 $11

	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01

	.db $00 $1f $1e $1d $1c $1b $1a $19
	.db $18 $17 $16 $15 $14 $13 $12 $11

	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01
