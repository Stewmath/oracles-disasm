; ==================================================================================================
; ENEMY_VERAN_FINAL_FORM
;
; Variables:
;   subid: 0 - turtle, 1 - spider, 2 - bee
;   var03: Attack type (for spider form); 0 - rush, 1 - jump, 2 - grab
;   var30: Current health for turtle form (saved here while in other forms)
;   var31: Spider form max health
;   var32: Bee form max health
;   var33: Nonzero if turtle form has been attacked (will transform)
;   var34: Number of times turtle has jumped (when var33 is nonzero)
;   var35: Used for deciding transformations. Value from 0-7.
;   var36/var37: Target position to move towards
;   var38: Used as a signal by "web" objects?
;   var39: Bee form: quadrant the bee entered the screen from
; ==================================================================================================
enemyCode02:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jr z,@justHit

	; ENEMYSTATUS_KNOCKBACK
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp ecom_updateKnockback

@justHit:
	ld h,d
	ld l,Enemy.subid
	ld a,(hl)
	or a
	jr nz,@notTurtleForm

	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	jr z,@normalStatus

	; Note that turtle veran's been hit and should transform soon
	ld l,Enemy.var33
	ld (hl),$01
	jr @normalStatus

@notTurtleForm:
	ld l,Enemy.knockbackCounter
	ld a,(hl)
	or a
	jr z,@normalStatus

	; Only spider form takes knockback
	ld l,Enemy.state
	ld (hl),$03
	ld l,Enemy.counter1
	ld (hl),105
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_VERAN_SPIDER_FORM_VULNERABLE

	ld a,(w1Link.state)
	cp LINK_STATE_GRABBED
	call z,veranFinal_grabbingLink

	ld a,$06
	jp enemySetAnimation

@dead:
	call veranFinal_dead

@normalStatus:
	ld e,Enemy.subid
	ld a,(de)
	ld e,Enemy.state
	rst_jumpTable
	.dw veranFinal_turtleForm
	.dw veranFinal_spiderForm
	.dw veranFinal_beeForm


veranFinal_turtleForm:
	ld a,(de)
	rst_jumpTable
	.dw veranFinal_turtleForm_state0
	.dw veranFinal_turtleForm_state1
	.dw veranFinal_turtleForm_state2
	.dw veranFinal_turtleForm_state3
	.dw veranFinal_turtleForm_state4
	.dw veranFinal_turtleForm_state5
	.dw veranFinal_turtleForm_state6
	.dw veranFinal_turtleForm_state7
	.dw veranFinal_turtleForm_state8
	.dw veranFinal_turtleForm_state9
	.dw veranFinal_turtleForm_stateA


veranFinal_turtleForm_state0:
	ld a,$02
	ld (wEnemyIDToLoadExtraGfx),a
	ld a,PALH_87
	call loadPaletteHeader
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,$01
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld bc,$0208
	call enemyBoss_spawnShadow
	ret nz
	call ecom_incState

.ifdef REGION_JP
	ld l,Enemy.health
	ld a,(hl)
	ld l,Enemy.var30
	ldi (hl),a
	ld (hl),$0c ; [var31]
	inc l
	ld (hl),$18 ; [var32]
.else
	call checkIsLinkedGame
	ld l,Enemy.health
	ld a,(hl)
	ld bc,$0c18
	jr nz,++

	; Unlinked: less health (for all forms)
	ld a,$14
	ld (hl),a
	ld bc,$080f
++
	ld l,Enemy.var30
	ldi (hl),a
	ld (hl),b ; [var31]
	inc l
	ld (hl),c ; [var32]
.endif
	jp objectSetVisible83


; Showing text before fight starts
veranFinal_turtleForm_state1:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,SND_LIGHTNING
	call playSound
	ld bc,TX_5614
	call showText
	jp ecom_incSubstate

@substate1:
	ld h,d
	ld l,e
	inc (hl) ; [substate]
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,$03
	call enemySetAnimation
	ld a,MUS_FINAL_BOSS
	ld (wActiveMusic),a
	jp playSound

@substate2:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	ret nz
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.speed
	ld (hl),SPEED_1c0
	inc a
	jp enemySetAnimation


; About to jump
veranFinal_turtleForm_state2:
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	jp nz,enemyAnimate

	call ecom_decCounter1
	ret nz
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.speedZ
	ld (hl),<(-$400)
	inc l
	ld (hl),>(-$400)
	call ecom_updateAngleTowardTarget
	call objectSetVisible81
	ld a,SND_UNKNOWN4
	call playSound
	ld a,$02
	jp enemySetAnimation


; Jumping (until starts moving down)
veranFinal_turtleForm_state3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ldd a,(hl)
	or (hl)
	jp nz,ecom_applyVelocityForTopDownEnemyNoHoles

	inc l
	inc (hl) ; [speedZ] = $0100

	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_300
	ld l,Enemy.var36
	ldh a,(<hEnemyTargetY)
	and $f0
	add $08
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	and $f0
	add $08
	ld (hl),a ; [var37]
	ld a,$01
	jp enemySetAnimation


; Falling and homing in on a position
veranFinal_turtleForm_state4:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	jr z,@nextState
	call veranFinal_moveTowardTargetPosition
	ret nc
	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	ret

@nextState:
	ld a,$10
	call setScreenShakeCounter
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$0c
	call objectSetVisible83
	ld a,SND_POOF
	call playSound
	ld b,PART_VERAN_ACID_POOL
	jp ecom_spawnProjectile


; Landed
veranFinal_turtleForm_state5:
	call ecom_decCounter1
	ret nz

	ld l,Enemy.speed
	ld (hl),SPEED_1c0
	ld l,Enemy.var33
	bit 0,(hl)
	ld l,Enemy.var34
	jr z,+
	inc (hl)
+
	ld a,(hl)
	ld bc,@transformProbabilities
	call addAToBc
	ld a,(bc)
	ld b,a
	inc a
	ld l,e
	jr z,++

	call getRandomNumber
	and b
	jp z,veranFinal_transformToBeeOrSpider

	ld e,Enemy.var33
	ld a,(de)
	rrca
	jr c,@jumpAgain
++
	call getRandomNumber
	cp 90
	jr nc,@jumpAgain

	; Open face
	inc (hl) ; [substate] = $06
	ld l,Enemy.counter1
	ld (hl),$08
	ld a,SND_GORON
	call playSound
	ld a,$04
	jp enemySetAnimation

@jumpAgain
	ld (hl),$02 ; [state]
	ld l,Enemy.counter1
	ld (hl),30
	ret

@transformProbabilities:
	.db $ff $03 $03 $01 $00


; Face is opening
veranFinal_turtleForm_state6:
	call enemyAnimate
	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	jr nz,@nextState
	bit 0,(hl)
	ret z
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_VERAN_TURTLE_FORM_VULNERABLE
	ret

@nextState:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),90
	xor a
	jp enemySetAnimation


veranFinal_turtleForm_state7:
	call ecom_decCounter1
	jp nz,enemyAnimate
	ld l,e
	inc (hl) ; [state]
	ld a,$03
	jp enemySetAnimation


veranFinal_turtleForm_state8:
	call enemyAnimate
	ld h,d
	ld l,Enemy.animParameter
	bit 7,(hl)
	jr nz,@nextState
	bit 0,(hl)
	ret z
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_VERAN_TURTLE_FORM
	ret

@nextState:
	ld l,Enemy.state
	ld (hl),$02
	ld l,Enemy.counter1
	ld (hl),30
	ld a,$01
	jp enemySetAnimation


; Just transformed back from being a spider or bee
veranFinal_turtleForm_state9:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	ret nz

	ld h,d
	ld l,Enemy.var33
	ldi (hl),a ; [var33] = 0
	ld (hl),a  ; [var34] = 0

	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_VERAN_FINAL_FORM
	inc l
	ld (hl),ENEMYCOLLISION_VERAN_TURTLE_FORM_VULNERABLE ; [enemyCollisionType]

	ld l,Enemy.oamFlagsBackup
	ld a,$06
	ldi (hl),a
	ld (hl),a
	ld a,$03
	jp enemySetAnimation


; Dead
veranFinal_turtleForm_stateA:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	or a
	ret nz
	call checkLinkVulnerable
	ret nc

	ld a,$01
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	call dropLinkHeldItem
	call clearAllParentItems
	call ecom_incSubstate

	call checkIsLinkedGame
	ld bc,TX_5615
	jr z,+
	ld bc,TX_5616
+
	jp showText

@substate1:
	ld a,(wTextIsActive)
	or a
	ret nz
	call ecom_incSubstate
	ld l,Enemy.counter2
	ld (hl),40
	ld l,Enemy.yh
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld a,$ff
	jp createEnergySwirlGoingOut

@substate2:
	call ecom_decCounter2
	ret nz
	ldbc INTERAC_MISC_PUZZLES, $21
	call objectCreateInteraction
	ret nz
	jp ecom_incSubstate

@substate3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,wGroup4RoomFlags+(<ROOM_AGES_4fc)
	set 7,(hl)
	ld a,CUTSCENE_BLACK_TOWER_ESCAPE
	ld (wCutsceneTrigger),a
	call incMakuTreeState
	jp enemyDelete


veranFinal_spiderForm:
	ld a,(de)
	rst_jumpTable
	.dw veranFinal_spiderOrBeeForm_state0
	.dw veranFinal_spiderForm_state1
	.dw veranFinal_spiderForm_state2
	.dw veranFinal_spiderForm_state3
	.dw veranFinal_spiderForm_state4


veranFinal_spiderOrBeeForm_state0:
	ret


veranFinal_spiderForm_state1:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	ret nz

	ld bc,$1010
	ld e,ENEMYCOLLISION_VERAN_SPIDER_FORM
	ld l,Enemy.var31
	call veranFinal_initializeForm
	ld a,$05
	call enemySetAnimation

veranFinal_spiderForm_setCounter2AndInitState2:
	ld e,Enemy.counter2
	ld a,120
	ld (de),a

veranFinal_spiderForm_initState2:
	ld h,d
	ld l,Enemy.state
	ld (hl),$02
	ld l,Enemy.speed
	ld (hl),SPEED_c0

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	call veranFinal_spiderForm_decideAngle
	jr veranFinal_spiderForm_animate

@counter1Vals:
	.db 60,80,100,120


veranFinal_spiderForm_state2:
	call ecom_decCounter2
	jr nz,++
	ld (hl),120
	call veranFinal_spiderForm_decideWhetherToAttack
	ret c
++
	call ecom_decCounter1
	jr z,veranFinal_spiderForm_initState2

veranFinal_spiderForm_updateMovement:
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed

veranFinal_spiderForm_animate:
	jp enemyAnimate


veranFinal_spiderForm_state3:
	ld e,Enemy.zh
	ld a,(de)
	rlca
	ld c,$20
	jp c,objectUpdateSpeedZ_paramC

	call ecom_decCounter1
	jr z,@gotoState2

	ld a,(hl)
	rrca
	ret c
	ld l,Enemy.zh
	ld a,(hl)
	xor $02
	ld (hl),a
	ret

@gotoState2:
	ld l,Enemy.zh
	ld (hl),$00
	call objectSetVisible83
	call veranFinal_spiderForm_resetCollisionData
	jr veranFinal_spiderForm_initState2


; Doing an attack
veranFinal_spiderForm_state4:
	ld e,Enemy.var03
	ld a,(de)
	ld e,Enemy.substate
	rst_jumpTable
	.dw veranFinal_spiderForm_rushAttack
	.dw veranFinal_spiderForm_jumpAttack
	.dw veranFinal_spiderForm_webAttack


; Rush toward Link for 1 second
veranFinal_spiderForm_rushAttack:
	ld a,(de)
	or a
	jr z,@substate0

@substate1:
	call ecom_decCounter1
	jr z,veranFinal_spiderForm_setCounter2AndInitState2
	call veranFinal_spiderForm_updateMovement
	jp enemyAnimate

@substate0:
	call ecom_incSubstate
	inc l
	ld (hl),60 ; [counter1]
	ld l,Enemy.speed
	ld (hl),SPEED_180

	call ecom_updateAngleTowardTarget
	and $18
	add $04
	ld (de),a
	jr veranFinal_spiderForm_animate


; Jumps up and crashes back down onto the ground
veranFinal_spiderForm_jumpAttack:
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld b,PART_VERAN_SPIDERWEB
	call ecom_spawnProjectile
	ret nz
	call ecom_incSubstate
	ld l,Enemy.var38
	ld (hl),$00
	call veranFinal_spiderForm_setVulnerableCollisionData
	jp objectSetVisible81

@substate1:
	; Wait for signal from child object?
	ld e,Enemy.var38
	ld a,(de)
	or a
	ret z

	ld h,d
	ld l,Enemy.zh
	ld a,(hl)
	sub $03
	ld (hl),a
	bit 7,a
	jr z,++

	cp $e0
	ret nc

	ldh a,(<hCameraY)
	ld b,a
	ld a,(hl)
	ld l,Enemy.yh
	add (hl)
	sub b
	cp $b0
	ret c
++
	ld l,Enemy.substate
	inc (hl)
	inc l
	ld (hl),90 ; [counter1]
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.zh
	ld (hl),$00
	jp objectSetInvisible

@substate2:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),$01

	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	inc l
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ld c,$08
	call ecom_setZAboveScreen
	call veranFinal_spiderForm_resetCollisionData
	jp objectSetVisible81

@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	; Landed
	ld l,Enemy.substate
	inc (hl)
	inc l
	ld (hl),120 ; [counter1]
	ld a,SND_STRONG_POUND
	call playSound
	ld a,90
	call setScreenShakeCounter
	jp objectSetVisible83

@substate4:
	call ecom_decCounter1
	ret nz
	jp veranFinal_spiderForm_setCounter2AndInitState2


; Shoots out web to try and catch Link
veranFinal_spiderForm_webAttack:
	ld a,(de)
	rst_jumpTable
	.dw veranFinal_spiderForm_webAttack_substate0
	.dw veranFinal_spiderForm_webAttack_substate1
	.dw veranFinal_spiderForm_webAttack_substate2
	.dw veranFinal_spiderForm_webAttack_substate3
	.dw veranFinal_spiderForm_webAttack_substate4
	.dw veranFinal_spiderForm_webAttack_substate5
	.dw veranFinal_spiderForm_webAttack_substate6
	.dw veranFinal_spiderForm_webAttack_substate7


veranFinal_spiderForm_webAttack_substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate]
	inc l
	ld (hl),30 ; [counter1]
	ld l,Enemy.var38
	ld (hl),$00

veranFinal_spiderForm_resetCollisionData:
	ld h,d
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_VERAN_SPIDER_FORM
	ld l,Enemy.collisionRadiusY
	ld (hl),$10
	ld a,$05
	jp enemySetAnimation


veranFinal_spiderForm_webAttack_substate1:
	call ecom_decCounter1
	ret nz
	inc l
	ld (hl),$08 ; [counter2]
	ld l,e
	inc (hl) ; [substate]

veranFinal_spiderForm_setVulnerableCollisionData:
	ld h,d
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_VERAN_SPIDER_FORM_VULNERABLE
	ld l,Enemy.collisionRadiusY
	ld (hl),$08
	ld a,$06
	jp enemySetAnimation


veranFinal_spiderForm_webAttack_substate2:
	call ecom_decCounter2
	ret nz

	ld b,PART_VERAN_SPIDERWEB
	call ecom_spawnProjectile
	ret nz
	ld l,Part.subid
	inc (hl) ; [subid] = 1
	call ecom_incSubstate
	inc l
	ld (hl),90 ; [counter1]
	jr veranFinal_spiderForm_resetCollisionData


; Web coming back?
veranFinal_spiderForm_webAttack_substate3:
	ld e,Enemy.var38
	ld a,(de)
	or a
	ret z

	call ecom_decCounter1
	ret nz

	ld a,(w1Link.state)
	cp LINK_STATE_GRABBED
	jp nz,veranFinal_spiderForm_setCounter2AndInitState2

	; Grabbed
	call ecom_incSubstate
	inc l
	ld (hl),$10
	ld a,$06
	call enemySetAnimation
	ld b,$f8

veranFinal_spiderForm_webAttack_updateLinkPosition:
	ld hl,w1Link
	ld c,$00
	jp objectCopyPositionWithOffset


veranFinal_spiderForm_webAttack_substate4:
	call ecom_decCounter1
	ret nz

	ld (hl),$04 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ld a,$05
	call enemySetAnimation
	ld a,$04
	call setScreenShakeCounter
	ld b,$14
	call veranFinal_spiderForm_webAttack_updateLinkPosition
	ldbc -6,$08

veranFinal_spiderForm_webAttack_applyDamageToLink:
	ld l,<w1Link.damageToApply
	ld (hl),b
	ld l,<w1Link.invincibilityCounter
	ld (hl),c
	ld a,SND_STRONG_POUND
	jp playSound


veranFinal_spiderForm_webAttack_substate5:
	call ecom_decCounter1
	ret nz
	ld (hl),$08
	ld l,e
	inc (hl)
	ld a,$06
	call enemySetAnimation
	ld b,$f6
	jr veranFinal_spiderForm_webAttack_updateLinkPosition


veranFinal_spiderForm_webAttack_substate6:
	call ecom_decCounter1
	ret nz
	ld (hl),$0f
	ld l,e
	inc (hl)
	ld a,$05
	call enemySetAnimation
	ld a,$14
	call setScreenShakeCounter
	ld b,$14
	call veranFinal_spiderForm_webAttack_updateLinkPosition
	ldbc -10,$18
	jr veranFinal_spiderForm_webAttack_applyDamageToLink


veranFinal_spiderForm_webAttack_substate7:
	call ecom_decCounter1
	ret nz
	ld l,Enemy.collisionType
	set 7,(hl)
	call veranFinal_spiderForm_setCounter2AndInitState2


veranFinal_grabbingLink:
	ld hl,w1Link.substate
	ld (hl),$02
	ld l,<w1Link.collisionType
	set 7,(hl)
	ret


veranFinal_beeForm:
	ld a,(de)
	rst_jumpTable
	.dw veranFinal_spiderOrBeeForm_state0
	.dw veranFinal_beeForm_state1
	.dw veranFinal_beeForm_state2
	.dw veranFinal_beeForm_state3
	.dw veranFinal_beeForm_state4
	.dw veranFinal_beeForm_state5
	.dw veranFinal_beeForm_state6
	.dw veranFinal_beeForm_state7
	.dw veranFinal_beeForm_state8
	.dw veranFinal_beeForm_state9
	.dw veranFinal_beeForm_stateA
	.dw veranFinal_beeForm_stateB


veranFinal_beeForm_state1:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	ret nz
	ld a,$07
	call enemySetAnimation
	call ecom_incState
	ld l,Enemy.speed
	ld (hl),SPEED_200
	ld bc,$100c
	ld e,ENEMYCOLLISION_VERAN_SPIDER_FORM_VULNERABLE
	ld l,Enemy.var32


;;
; @param	bc	collisionRadiusY/X
; @param	e	enemyCollisionMode
; @param	l	Pointer to health value
veranFinal_initializeForm:
	ld h,d
	ld a,(hl)
	ld l,Enemy.health
	ld (hl),a

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_VERAN_FINAL_FORM
	inc l
	ld (hl),e

	ld l,Enemy.collisionRadiusY
	ld (hl),b
	inc l
	ld (hl),c

	ld l,Enemy.oamFlagsBackup
	ld a,$06
	ldi (hl),a
	ld (hl),a
	ret


veranFinal_beeForm_state2:
	ld e,Enemy.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Enemy.xh
	ld a,(de)
	ldh (<hFF8E),a
	ldbc LARGE_ROOM_HEIGHT<<3, LARGE_ROOM_WIDTH<<3
	sub c
	add $02
	cp $05
	jr nc,@updateMovement
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jr nc,@updateMovement

	; In middle of room
	call ecom_incState
	jp veranFinal_beeForm_chooseRandomTargetPosition

@updateMovement:
	call ecom_moveTowardPosition

veranFinal_beeForm_animate:
	jp enemyAnimate


veranFinal_beeForm_state3:
	call veranFinal_moveTowardTargetPosition
	jr nc,veranFinal_beeForm_animate

	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	call veranFinal_beeForm_nextTargetPosition
	call ecom_decCounter2
	jr nz,veranFinal_beeForm_animate

	; Time to move off screen
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$01
	ld l,Enemy.xh
	bit 7,(hl)
	ld a,$00
	jr nz,+
	ld a,$f0
+
	ld l,Enemy.var37
	ldd (hl),a
	ld (hl),$e0
	jr veranFinal_beeForm_animate


; Moving off screen
veranFinal_beeForm_state4:
	call ecom_decCounter1
	jr nz,++

	ld (hl),$06 ; [counter1]
	ld l,Enemy.var36
	call ecom_readPositionVars
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards
++
	call objectApplySpeed
	ld e,Enemy.yh
	ld a,(de)
	cp (LARGE_ROOM_HEIGHT+1)<<4
	jr c,veranFinal_beeForm_animate

	; Off screen
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	jp objectSetInvisible


; About to re-emerge on screen
veranFinal_beeForm_state5:
	call ecom_decCounter1
	ret nz

	ld (hl),$0f ; [counter1]
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.yh
	ld (hl),$20

	call getRandomNumber
	and $10
	ldbc $08,$e8
	jr z,++
	ld b,c
	ld c,$08
++
	add $08
	ld l,Enemy.angle
	ld (hl),a
	ld l,Enemy.xh
	ld (hl),b
	ld l,Enemy.var37
	ld (hl),c
	jp objectSetVisible83


; Moving horizontally across screen while attacking
veranFinal_beeForm_state6:
	call ecom_decCounter1
	jr nz,++
	ld (hl),$0f ; [counter1]
	ld b,PART_VERAN_BEE_PROJECTILE
	call ecom_spawnProjectile
++
	call objectApplySpeed
	ld e,Enemy.xh
	ld a,(de)
	ld h,d
	ld l,Enemy.var37
	sub (hl)
	inc a
	cp $03
	jp nc,enemyAnimate

	; Reached other side
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.collisionType
	res 7,(hl)
	jp objectSetInvisible


; About to re-emerge from some corner of the screen
veranFinal_beeForm_state7:
	call ecom_decCounter1
	ret nz

	; Choose which corner to emerge from (not the current one)
	call veranFinal_getQuadrant
--
	call getRandomNumber
	ld c,a
	and $03
	cp b
	jr z,--

	ld e,Enemy.var39
	ld (de),a
	add a
	ld hl,veranFinal_beeForm_screenCornerEntrances
	rst_addDoubleIndex
	ld e,Enemy.var36
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	ld a,c
	and $30
	swap a
	add $02
	ld e,Enemy.counter2
	ld (de),a

	call ecom_incState
	ld l,Enemy.collisionType
	set 7,(hl)
	jp objectSetVisible83


veranFinal_beeForm_state8:
	call veranFinal_moveTowardTargetPosition
	jr nc,veranFinal_beeForm_animate2
	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),30
	jr veranFinal_beeForm_animate2


veranFinal_beeForm_state9:
	call ecom_decCounter1
	jr nz,veranFinal_beeForm_animate2
	ld (hl),25 ; [counter1]
	ld l,e
	inc (hl) ; [substate]

veranFinal_beeForm_animate2:
	jp enemyAnimate


; Shooting out bees
veranFinal_beeForm_stateA:
	call ecom_decCounter1
	jr z,label_10_173

	ld a,(hl) ; [counter1]
	and $07
	jr nz,veranFinal_beeForm_animate2

	; Spawn child bee
	ld a,(hl)
	and $18
	swap a
	rlca
	dec a
	ld b,a
	call getFreeEnemySlot
	jr nz,veranFinal_beeForm_animate2

	ld (hl),ENEMY_VERAN_CHILD_BEE
	inc l
	ld (hl),b ; [child.subid]
	call objectCopyPosition
	ld a,SND_BEAM1
	call playSound
	jr veranFinal_beeForm_animate2

label_10_173:
	ld (hl),20 ; [counter1]
	inc l
	dec (hl) ; [counter2]
	ld l,e
	jr z,+
	inc (hl) ; [state] = $0b
	jr veranFinal_beeForm_animate2
+
	ld (hl),$02 ; [state] = $02
	jr veranFinal_beeForm_animate2


veranFinal_beeForm_stateB:
	call ecom_decCounter1
	jr nz,veranFinal_beeForm_animate2

	ld l,e
	ld (hl),$08 ; [state]

	call veranFinal_getQuadrant
@chooseQuadrant:
	call getRandomNumber
	and $03
	cp b
	jr z,@chooseQuadrant
	ld h,d
	ld l,Enemy.var39
	cp (hl)
	jr z,@chooseQuadrant

	ld (hl),a ; [var39]
	add a
	ld hl,veranFinal_beeForm_screenCornerEntrances
	rst_addDoubleIndex
	ld e,Enemy.var36
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	jr veranFinal_beeForm_animate2


veranFinal_beeForm_screenCornerEntrances:
	.db $2c $3c $00 $00
	.db $2c $b4 $00 $f0
	.db $84 $3c $b0 $00
	.db $84 $b4 $b0 $f0


;;
; @param	hl	Enemy.state
veranFinal_transformToBeeOrSpider:
	ld (hl),$01
	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_BEAMOS

	ld l,Enemy.health
	ld a,(hl)
	ld l,Enemy.var30
	ld (hl),a

	ld l,Enemy.oamFlagsBackup
	ld a,$07
	ldi (hl),a
	ld (hl),a

	call getRandomNumber_noPreserveVars
	and $03
	ld b,a
	ld e,Enemy.var35
	ld a,(de)
	ld c,a
	inc a
	and $07
	ld (de),a

	ld a,c
	add a
	add a
	add b
	ld hl,@transformSequence
	call checkFlag
	jr z,+
	ld a,$01
+
	inc a
	ld e,Enemy.subid
	ld (de),a
	add $09
	call enemySetAnimation
	ld a,SND_TRANSFORM
	jp playSound

; Each 4 bits is a set of possible values (0=spider, 1=bee).
; [var35] determines which set of 4 bits is randomly chosen from.
; So, for instance, veran always turns into a spider in round 2 due to the 4 '0's?
@transformSequence:
	dbrev %11000000 %11111110 %11101100 %00001111


;;
; @param	b	Distance
; @param[out]	cflag	c if Link is within 'b' pixels of self
veranFinal_spiderForm_checkLinkWithinDistance:
	ld a,b
	add a
	inc a
	ld c,a
	ld a,(w1Link.yh)
	ld h,d
	ld l,Enemy.yh
	sub (hl)
	add b
	cp c
	ret nc
	ld a,(w1Link.xh)
	ld l,Enemy.xh
	sub (hl)
	add b
	cp c
	ret


;;
; @param[out]	cflag	c if will do an attack (state changed to 4)
veranFinal_spiderForm_decideWhetherToAttack:
	call objectGetAngleTowardLink
	ld e,a

@considerRushAttack:
	ld b,$60
	call veranFinal_spiderForm_checkLinkWithinDistance
	jr nc,@considerJumpAttack

	; BUG: is this supposed to 'ld a,e' first? This would check that Link is at a relatively
	; diagonal angle. Instead, this seems to compare their difference in x-positions modulo 8.
	and $07
	sub $03
	cp $03
	ld a,$00
	jr c,@doAttack

@considerJumpAttack:
	ld b,$50
	call veranFinal_spiderForm_checkLinkWithinDistance
	jr c,@considerGrabAttack

	; Check that Link is diagonal relative to the spider.
	; That shouldn't really matter for this attack, though...
	ld a,e
	and $07
	sub $03
	cp $03
	ccf
	ld a,$01
	jr c,@doAttack

@considerGrabAttack:
	; Check that Link is below the spider
	ld a,e
	sub $0c
	cp $09
	ret nc

	; Grab attack
	ld a,$02

@doAttack:
	ld e,Enemy.var03
	ld (de),a
	ld h,d
	ld l,Enemy.state
	ld (hl),$04
	inc l
	ld (hl),$00 ; [substate]
	scf
	ret


;;
veranFinal_dead:
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr nz,@transformed

	; Not transformed; dead for real
	ld h,d
	ld l,Enemy.state
	ld (hl),$0a
	inc l
	ld (hl),$00
	ld l,Enemy.health
	inc (hl)
	ld a,SNDCTRL_STOPMUSIC
	jp playSound

@transformed:
	ld b,a
	ld h,d
	ld l,e
	ld (hl),$00 ; [subid]
	ld l,Enemy.state
	ld (hl),$09

	; Restore turtle health
	ld l,Enemy.var30
	ld a,(hl)
	ld l,Enemy.health
	ld (hl),a

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_BEAMOS

	ld l,Enemy.collisionRadiusY
	ld (hl),$08
	inc l
	ld (hl),$0a ; [collisionRadiusX]

	ld l,Enemy.oamFlagsBackup
	ld a,$07
	ldi (hl),a
	ld (hl),a

	ld a,b ; [subid]
	add $07
	call enemySetAnimation
	ld a,SND_TRANSFORM
	jp playSound


veranFinal_spiderForm_decideAngle:
	ld b,$00
	ld e,Enemy.yh
	ld a,(de)
	cp (LARGE_ROOM_HEIGHT<<4)/2
	jr c,+
	ld b,$10
+
	ld e,Enemy.xh
	ld a,(de)
	cp (LARGE_ROOM_WIDTH<<4)/2
	jr c,+
	set 3,b
+
	call getRandomNumber
	and $07
	add b
	ld hl,@angles
	rst_addAToHl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	ret

@angles:
	.db $04 $04 $0c $0c $0c $14 $14 $1c
	.db $04 $0c $0c $14 $14 $14 $1c $1c
	.db $04 $04 $04 $0c $0c $14 $1c $1c
	.db $04 $04 $0c $14 $14 $1c $1c $1c

;;
veranFinal_beeForm_chooseRandomTargetPosition:
	ld bc,$0801
	call ecom_randomBitwiseAndBCE
	ld e,Enemy.counter1
	ld a,b
	ld (de),a

	ld a,c
	ld hl,veranFinal_beeForm_counter2Vals
	rst_addAToHl
	ld e,Enemy.counter2
	ld a,(hl)
	ld (de),a

;;
veranFinal_beeForm_nextTargetPosition:
	ld e,Enemy.counter1
	ld a,(de)
	ld b,a
	inc a
	and $0f
	ld (de),a
	ld a,b
	ld hl,veranFinal_beeForm_targetPositions
	rst_addDoubleIndex
	ld e,Enemy.var36
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a ; [var37]
	ret

veranFinal_beeForm_counter2Vals:
	.db $14 $24

veranFinal_beeForm_targetPositions:
	.db $38 $80
	.db $20 $90
	.db $20 $b8
	.db $38 $c8
	.db $78 $c8
	.db $90 $b8
	.db $90 $90
	.db $78 $80
	.db $38 $70
	.db $20 $60
	.db $20 $38
	.db $38 $28
	.db $78 $28
	.db $90 $38
	.db $90 $60
	.db $78 $70


;;
veranFinal_moveTowardTargetPosition:
	ld h,d
	ld l,Enemy.var36
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	jr nc,++
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	ret c
++
	call ecom_moveTowardPosition
	or d
	ret

;;
; @param[out]	b	Value from 0-3 corresponding to screen quadrant
veranFinal_getQuadrant:
	ld b,$00
	ldh a,(<hEnemyTargetY)
	cp LARGE_ROOM_HEIGHT*16/2
	jr c,+
	ld b,$02
+
	ldh a,(<hEnemyTargetX)
	cp LARGE_ROOM_WIDTH*16/2
	ret c
	inc b
	ret
