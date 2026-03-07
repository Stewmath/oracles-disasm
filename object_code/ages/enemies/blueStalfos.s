; ==================================================================================================
; ENEMY_BLUE_STALFOS
;
; Variables (for subid 1, "main" enemy):
;   var30/var31: Destination position while moving
;   var32: Projectile pattern index; number from 0-7 which cycles through ball types.
;          (Used by PART_BLUE_STALFOS_PROJECTILE.)
;
; Variables (for subid 3, the afterimage):
;   var30/var31: Y/X position?
;   var32: Index in position differenc buffer?
;   var33-var3a: Position difference buffer?
; ==================================================================================================
enemyCode77:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyBoss_dead
	dec a
	jr nz,@normalStatus

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,@normalState
	rst_jumpTable
	.dw blueStalfos_state_uninitialized
	.dw blueStalfos_state_spawner
	.dw blueStalfos_state_stub
	.dw blueStalfos_state_stub
	.dw blueStalfos_state_stub
	.dw blueStalfos_state_stub
	.dw blueStalfos_state_stub
	.dw blueStalfos_state_stub

@normalState:
	dec b
	ld a,b
	rst_jumpTable
	.dw blueStalfos_subid1
	.dw blueStalfos_subid2
	.dw blueStalfos_subid3


blueStalfos_state_uninitialized:
	ld a,b
	sub $02
	call c,objectSetVisible82
	ld a,b
	or a
	jp nz,ecom_setSpeedAndState8

	; Spawner (subid 0) only
	call ecom_incState
	ld l,Enemy.zh
	ld (hl),$ff
	ld a,ENEMY_BLUE_STALFOS
	jp enemyBoss_initializeRoom


blueStalfos_state_spawner:
	ld b,$03
	call checkBEnemySlotsAvailable
	ret nz

	; Spawn subid 1
	ld b,ENEMY_BLUE_STALFOS
	call ecom_spawnUncountedEnemyWithSubid01
	call objectCopyPosition
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	; Spawn subid 2
	ld c,h
	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)

	; [subid2.relatedObj1] = subid1
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c

	call objectCopyPosition

	; Spawn subid 3
	call ecom_spawnUncountedEnemyWithSubid01
	ld (hl),$03

	; [subid3.relatedObj1] = subid1
	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),c

	call objectCopyPosition

	jp enemyDelete


blueStalfos_state_stub:
	ret


blueStalfos_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw blueStalfos_main_state08
	.dw blueStalfos_main_state09
	.dw blueStalfos_main_state0a
	.dw blueStalfos_main_state0b
	.dw blueStalfos_main_state0c
	.dw blueStalfos_main_state0d
	.dw blueStalfos_main_state0e
	.dw blueStalfos_main_state0f
	.dw blueStalfos_main_state10
	.dw blueStalfos_main_state11
	.dw blueStalfos_main_state12
	.dw blueStalfos_main_state13
	.dw blueStalfos_main_state14
	.dw blueStalfos_main_state15
	.dw blueStalfos_main_state16
	.dw blueStalfos_main_state17


blueStalfos_main_state08:
	ld bc,$010b
	call enemyBoss_spawnShadow
	ret nz

	call ecom_incState

	ld l,Enemy.speed
	ld (hl),SPEED_200
	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN
	ret


; Moving down before fight starts
blueStalfos_main_state09:
	call objectApplySpeed
	ld e,Enemy.yh
	ld a,(de)
	cp $58
	jr nz,blueStalfos_main_animate

	; Fight starts now
	call ecom_incState

	ld l,Enemy.counter1
	ld (hl),$40
	ld l,Enemy.speed
	ld (hl),SPEED_20

	ld a,MUS_MINIBOSS
	ld (wActiveMusic),a
	call playSound

	ld e,$0f
	ld bc,$3030
	call ecom_randomBitwiseAndBCE
	ld a,e
	jp blueStalfos_main_moveToQuadrant


; Moving to position in var30/var31
blueStalfos_main_state0a:
	ld h,d
	ld l,Enemy.var30
	call ecom_readPositionVars
	sub c
	add $04
	cp $09
	jr nc,@moveToPosition

	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	jr nc,@moveToPosition

	; Reached target position
	ld h,d
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.counter1
	ld (hl),$10
	jr blueStalfos_main_animate

@moveToPosition:
	call blueStalfos_main_accelerate
	call ecom_moveTowardPosition
	jr blueStalfos_main_animate


; Reached position, standing still for [counter1] frames
blueStalfos_main_state0b:
	call ecom_decCounter1
	jr nz,blueStalfos_main_animate

	ld l,e
	inc (hl) ; [state]

blueStalfos_main_animate:
	jp enemyAnimate


; Decide which attack to do
blueStalfos_main_state0c:
	ld e,Enemy.yh
	ld a,(de)
	add $10
	ld b,a
	ld e,Enemy.xh
	ld a,(de)
	add $04
	ld c,a

	; If Link is close enough, use the sickle on him
	ldh a,(<hEnemyTargetY)
	sub b
	add $14
	cp $29
	jr nc,@projectileAttack
	ldh a,(<hEnemyTargetX)
	sub c
	add $12
	cp $25
	jp c,blueStalfos_main_beginSickleAttack

@projectileAttack:
	ld b,PART_BLUE_STALFOS_PROJECTILE
	call ecom_spawnProjectile
	ret nz
	ld h,d
	ld l,Enemy.counter1
	ld (hl),120
	ld l,Enemy.state
	ld (hl),$0e
	ld a,$02
	jp enemySetAnimation


; Sickle attack
blueStalfos_main_state0d:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr z,blueStalfos_main_finishedAttack

	dec a
	ret nz

	ld a,$08
	ld (de),a ; [animParameter]

	ld a,SND_SWORDSPIN
	jp playSound


; Charging a projectile
blueStalfos_main_state0e:
	call ecom_decCounter1
	jr nz,blueStalfos_main_animate

	ld (hl),60
	ld l,e
	inc (hl) ; [state]
	ld a,$03
	jp enemySetAnimation


; Just fired projectile
blueStalfos_main_state0f:
	call ecom_decCounter1
	ret nz

blueStalfos_main_finishedAttack:
	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.counter1
	ld (hl),$40
	ld l,Enemy.speed
	ld (hl),SPEED_20
	xor a
	call enemySetAnimation
	jp blueStalfos_main_decideNextPosition


; Link just turned into a baby; about to turn transparent and warp to top of room
blueStalfos_main_state10:
	call ecom_decCounter1
	jr nz,blueStalfos_main_animate

	ld (hl),$10 ; [counter1]
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.collisionType
	res 7,(hl)
	ret


; Now transparent; waiting for [counter1] frames before warping
blueStalfos_main_state11:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld (hl),$08 ; [counter1]
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.yh
	ld (hl),$0c
	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	ld (hl),a

	xor a
	call enemySetAnimation
	jp objectSetInvisible


; Just warped to top of room; standing in place
blueStalfos_main_state12:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld l,Enemy.angle
	ld (hl),$10

	ld l,e
	inc (hl) ; [state]

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@speedTable
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a

	jp objectSetVisible82

@speedTable:
	.db SPEED_180, SPEED_1c0, SPEED_200, SPEED_300


; Moving down toward baby Link before attacking with sickle
blueStalfos_main_state13:
	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	cp $18
	jp nc,objectApplySpeed

blueStalfos_main_beginSickleAttack:
	ld e,Enemy.state
	ld a,$0d
	ld (de),a
	ld a,$01
	jp enemySetAnimation


; Just hit by PART_BLUE_STALFOS_PROJECTILE; turning into a small bat
blueStalfos_main_state14:
	call blueStalfos_createPuff
	ret nz

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.collisionRadiusY
	ld (hl),$02
	inc l
	ld (hl),$06

	ld l,Enemy.counter1
	ld (hl),$f0
	inc l
	ld (hl),$00 ; [counter2]

	ld l,Enemy.speed
	ld (hl),SPEED_c0

	call objectSetInvisible

	ld a,SND_SCENT_SEED
	call playSound

	ld a,$04
	jp enemySetAnimation


; Transforming into bat
blueStalfos_main_state15:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret nz

	call ecom_incState

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLUE_STALFOS_BAT

	ld l,Enemy.zh
	ld (hl),$00

	jp objectSetVisiblec2


; Flying around as a bat
blueStalfos_main_state16:
	call ecom_decCounter1
	jr nz,@flyAround

	; Time to transform back into stalfos

	inc (hl) ; [counter1] = 1
	call blueStalfos_createPuff
	ret nz

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLUE_STALFOS
	ld l,Enemy.zh
	ld (hl),$ff
	jp objectSetInvisible

@flyAround:
	call ecom_decCounter2
	jr nz,++
	ld (hl),30 ; [counter2]
	call ecom_setRandomAngle
++
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed
	jp enemyAnimate


; Transforming back into stalfos
blueStalfos_main_state17:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret nz

	ld e,Enemy.collisionRadiusY
	ld a,$08
	ld (de),a
	inc e
	ld (de),a

	call blueStalfos_main_finishedAttack
	ld a,SND_SCENT_SEED
	call playSound
	jp objectSetVisible82


; Hitbox for the sickle (invisible)
blueStalfos_subid2:
	ld a,(de)
	sub $08
	jr z,blueStalfos_initSubid2Or3

@state9:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMY_BLUE_STALFOS
	jp nz,enemyDelete

	; [this.collisionType] = [subid0.collisionType]
	ld l,Enemy.collisionType
	ld e,l
	ld a,(hl)
	ld (de),a

	; Set collision and hitbox based on [subid0.animParameter]
	ld l,Enemy.animParameter
	ld a,(hl)
	cp $ff
	jr nz,+
	ld a,$0c
+
	ld bc,@positionAndHitboxTable
	call addAToBc

	ld l,Enemy.yh
	ld e,l
	ld a,(bc)
	add (hl)
	ld (de),a

	inc bc
	ld l,Enemy.xh
	ld e,l
	ld a,(bc)
	add (hl)
	ld (de),a

	inc bc
	ld e,Enemy.collisionRadiusY
	ld a,(bc)
	ld (de),a

	inc bc
	inc e
	ld a,(bc)
	ld (de),a

	; If collision size is 0, disable collisions
	or a
	ret nz
	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)
	ret

; Data format:
;   b0: Y offset
;   b1: X offset
;   b2: collisionRadiusY
;   b3: collisionRadiusX
@positionAndHitboxTable:
	.db $04 $0d $08 $03
	.db $f0 $04 $03 $0a
	.db $0c $06 $14 $0c
	.db $14 $fc $04 $0a
	.db $f4 $0e $04 $06
	.db $f6 $0c $04 $06
	.db $f4 $0a $04 $06
	.db $f2 $0c $04 $06
	.db $00 $00 $00 $00


blueStalfos_initSubid2Or3:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_BLUE_STALFOS_SICKLE

	ld a,Object.zh
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(hl)
	ld (de),a
	ret


; "Afterimage" of blue stalfos visible while moving
blueStalfos_subid3:
	ld a,(de)
	sub $08
	jr z,@state8

@state9:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMY_BLUE_STALFOS
	jp nz,enemyDelete

	ld l,Enemy.state
	ld a,(hl)
	cp $12
	jp z,blueStalfos_afterImage_resetPositionVars

	cp $14
	call nc,objectSetVisible82

	; Calculate Y-diff, update var30 (last frame's Y-position)
	ld l,Enemy.yh
	ld e,Enemy.var30
	ld a,(de)
	ld b,a
	ld a,(hl)
	sub b
	add $08
	and $0f
	swap a
	ld c,a
	ldi a,(hl)
	ld (de),a

	; Calculate X-diff, update var31 (last frame's Y-position)
	inc l
	inc e
	ld a,(de)
	ld b,a
	ld a,(hl)
	sub b
	add $08
	and $0f
	or c
	ld c,a
	ld a,(hl)
	ld (de),a

	; Write position difference to offset buffer
	ld e,Enemy.var32
	ld a,(de)
	add Enemy.var33
	ld e,a
	ld a,c
	ld (de),a

	; Increment index in offset buffer
	ld e,Enemy.var32
	ld a,(de)
	inc a
	and $07
	ld (de),a

	; Don't draw if difference is 0
	add Enemy.var33
	ld e,a
	ld a,(de)
	cp $88
	ld b,a
	jp z,objectSetInvisible

	; Update position based on offset, draw afterimage
	ld h,d
	ld l,Enemy.yh
	and $f0
	swap a
	sub $08
	add (hl)
	ldi (hl),a
	inc l
	ld a,b
	and $0f
	sub $08
	add (hl)
	ld (hl),a

	jp ecom_flickerVisibility

@state8:
	call blueStalfos_initSubid2Or3
	call blueStalfos_afterImage_resetPositionVars
	ld l,Enemy.collisionType
	res 7,(hl)
	call objectSetVisible83
	jp objectSetInvisible


;;
; Decides the next position for the blue stalfos. It will always choose a different
; quadrant of the screen from the one it's in already.
blueStalfos_main_decideNextPosition:
	ld e,$03
	ld bc,$3030
	call ecom_randomBitwiseAndBCE

	ld h,e
	ld l,$00
	ld e,Enemy.yh
	ld a,(de)
	cp (LARGE_ROOM_HEIGHT<<4)/2
	jr c,+
	ld l,$02
+
	ld e,Enemy.xh
	ld a,(de)
	cp (LARGE_ROOM_WIDTH<<4)/2
	jr c,+
	inc l
+
	ld a,l
	add a
	add a
	add h


;;
; @param	a	Position index to use
; @param	bc	Offset to be added to target position
blueStalfos_main_moveToQuadrant:
	ld hl,@quadrantList
	rst_addAToHl
	call @getLinkQuadrant
	cp (hl)
	jr z,@moveToLinksPosition

	ld a,(hl)
	ld hl,@targetPositions
	rst_addAToHl
	ld e,Enemy.var30
	ldi a,(hl)
	add b
	ld (de),a
	inc e
	ld a,(hl)
	add c
	ld (de),a
	ret

@moveToLinksPosition:
	ld e,Enemy.var30
	ldh a,(<hEnemyTargetY)
	sub $14
	ld (de),a
	inc e
	ldh a,(<hEnemyTargetX)
	ld (de),a
	ret

;;
; @param[out]	a	The quadrant of the screen Link is in.
;			(0/2/4/6 for up/left, up/right, down/left, down/right)
@getLinkQuadrant:
	ld e,$00
	ldh a,(<hEnemyTargetY)
	cp (LARGE_ROOM_HEIGHT<<4)/2
	jr c,+
	ld e,$02
+
	ldh a,(<hEnemyTargetX)
	cp (LARGE_ROOM_WIDTH<<4)/2
	jr c,+
	inc e
+
	ld a,e
	add a
	ret

@quadrantList:
	.db $02 $04 $06 $04 ; Currently in TL quadrant
	.db $00 $06 $04 $06 ; Currently in TR quadrant
	.db $00 $02 $06 $02 ; Currently in BL quadrant
	.db $00 $02 $04 $00 ; Currently in BR quadrant

@targetPositions:
	.dw $3828
	.dw $8828
	.dw $3868
	.dw $8868


;;
blueStalfos_main_accelerate:
	ld e,Enemy.counter1
	ld a,(de)
	or a
	ret z

	dec a
	ld (de),a

	and $03
	ret nz

	ld e,Enemy.speed
	ld a,(de)
	add SPEED_20
	ld (de),a
	ret


;;
blueStalfos_afterImage_resetPositionVars:
	; [this.position] = [parent.position]
	; (Also copy position to var30/var31)
	ld l,Enemy.yh
	ld e,l
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.var30

	ld (de),a
	inc l
	ld e,l
	ld a,(hl)
	ld (de),a
	ld e,Enemy.var31
	ld (de),a

	ld h,d
	ld l,Enemy.var32
	xor a
	ldi (hl),a

	; Initialize "position offset" buffer
	ld a,$88
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret

;;
blueStalfos_createPuff:
	ldbc INTERAC_PUFF,$02
	call objectCreateInteraction
	ret nz

	ld a,h
	ld h,d
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Interaction.start
	ret
