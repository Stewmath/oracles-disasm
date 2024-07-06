; ==================================================================================================
; ENEMY_VERAN_FAIRY
;
; Variables:
;   var03: Attack index
;   var30: Movement pattern index (0-3)
;   var31/var32: Pointer to movement pattern
;   var33/var34: Target position to move to
;   var35: Number from 0-2 based on health (lower means more health)
;   var36: ?
;   var38: Timer to stay still after doing a movement pattern
; ==================================================================================================
enemyCode06:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@justHit

	; No health
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	ret nz
	call checkLinkCollisionsEnabled
	ret nc

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld h,d
	ld l,Enemy.health
	inc (hl)
	ld l,Enemy.state
	ld (hl),$05
	inc l
	ld (hl),$00 ; [substate]
	ld l,Enemy.counter1
	ld (hl),60
	jr @normalStatus

@justHit:
	call veranFairy_updateVar35BasedOnHealth
	ld hl,veranFairy_speedTable
	rst_addAToHl
	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw veranFairy_state0
	.dw veranFairy_state1
	.dw veranFairy_state2
	.dw veranFairy_state3
	.dw veranFairy_state4
	.dw veranFairy_state5

veranFairy_state0:
	ld a,ENEMY_VERAN_FAIRY
	ld (wEnemyIDToLoadExtraGfx),a
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.speed
	ld (hl),SPEED_140
	ld l,Enemy.var30
	dec (hl)
	ld a,$02
	call enemySetAnimation
	jp objectSetVisible82

; Cutscene just prior to fairy form
veranFairy_state1:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB
	.dw @substateC

@substate0:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$08
	ld l,e
	inc (hl) ; [substate]
	jp objectSetVisible83

@substate1:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate]
	ld bc,TX_560f
	jp showText

@substate2:
	call ecom_incSubstate
	ld l,Enemy.counter1
	ld (hl),30
	ld a,$04
	jp enemySetAnimation

@substate3:
	ld c,$33

@strikeLightningAfterCountdown:
	call ecom_decCounter1
	ret nz
	ld (hl),10 ; [counter1]
	ld l,e
	inc (hl) ; [substate]

@strikeLightning:
	call getFreePartSlot
	ret nz
	ld (hl),PART_LIGHTNING
	ld l,Part.yh
	jp setShortPosition_paramC

@substate4:
	ld c,$7b
	jr @strikeLightningAfterCountdown

@substate5:
	ld c,$55
	jr @strikeLightningAfterCountdown

@substate6:
	ld c,$3b
	jr @strikeLightningAfterCountdown

@substate7:
	ld c,$73
	jr @strikeLightningAfterCountdown

@substate8:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate]
	ld c,$59
	call @strikeLightning
	jp fadeoutToWhite

; Remove pillar tiles
@substate9:
	ld b,$0c
	ld hl,@pillarPositions
@loop
	push bc
	ldi a,(hl)
	ld c,a
	ld a,$a5
	push hl
	call setTile
	pop hl
	pop bc
	dec b
	jr nz,@loop
	jp ecom_incSubstate

@pillarPositions:
	.db $23 $33 $63 $73 $45 $55 $49 $59
	.db $2b $3b $6b $7b

; Spawn mimics
@substateA:
	ld b,$04
	ld hl,@mimicPositions

@nextMimic:
	ldi a,(hl)
	ld c,a
	push hl
	call getFreeEnemySlot
	jr nz,++
	ld (hl),ENEMY_LINK_MIMIC
	ld l,Enemy.yh
	call setShortPosition_paramC
++
	pop hl
	dec b
	jr nz,@nextMimic

	call ecom_incSubstate
	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.oamFlagsBackup
	xor a
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.zh
	dec (hl)
	call objectSetVisible83
	ld a,$05
	call enemySetAnimation
	ld a,$04
	jp fadeinFromWhiteWithDelay

@mimicPositions:
	.db $33 $73 $3b $7b

@substateB:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ld bc,TX_5610
	jp showText

@substateC:
	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter2
	ld (hl),120
	jp enemyBoss_beginBoss


; Choosing a movement pattern and attack
veranFairy_state2:
	call getRandomNumber_noPreserveVars
	and $07
	ld b,a
	ld e,Enemy.var35
	ld a,(de)
	swap a
	rrca
	add b
	ld hl,veranFairy_attackTable
	rst_addAToHl
	ld e,Enemy.var03
	ld a,(hl)
	ld (de),a

	call ecom_incState
	ld l,Enemy.var38
	ld (hl),60
	ld l,Enemy.var36
	ld (hl),$00
--
	call getRandomNumber
	and $03
	ld l,Enemy.var30
	cp (hl)
	jr z,--
	ld (hl),a

	ld hl,veranFairy_movementPatternTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,Enemy.var33
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl) ; [var34]
	ld (de),a

veranFairy_saveMovementPatternPointer:
	ld e,Enemy.var31
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret


; Moving and attacking
veranFairy_state3:
	call veranFairy_66ed

	ld h,d
	ld l,Enemy.var33
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	jr nc,@updateMovement
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jr nc,@updateMovement

	; Reached target position
	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c
	call veranFairy_checkLoopAroundScreen

	; Get next target position
	ld h,d
	ld l,Enemy.var31
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	or a
	jr nz,++
	ld a,$05
	call enemySetAnimation
	jp ecom_incState
++
	ld e,Enemy.var33
	ld (de),a
	ld b,a
	inc e
	ldi a,(hl)
	ld (de),a ; [var34]
	ld c,a
	call veranFairy_saveMovementPatternPointer
@updateMovement:
	call ecom_moveTowardPosition
veranFairy_animate:
	jp enemyAnimate


veranFairy_state4:
	ld h,d
	ld l,Enemy.var38
	dec (hl)
	jr nz,veranFairy_animate
	ld l,e
	ld (hl),$02 ; [state]
	jr veranFairy_animate


; Dead
veranFairy_state5:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld l,e
	inc (hl)
	jp objectSetVisible82

@substate1:
	call ecom_incSubstate
	ld l,Enemy.counter2
	ld (hl),65
	ld bc,TX_5612
	jp showText

@substate2:
	call ecom_decCounter2
	jr z,@triggerCutscene

	ld a,(hl) ; [counter2]
	and $0f
	ret nz
	ld a,(hl) ; [counter2]
	and $f0
	swap a
	dec a
	push af
	dec a
	call z,fadeoutToWhite
	pop af
	ld hl,@explosionPositions
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_EXPLOSION
	ld l,Interaction.var03
	inc (hl) ; [explosion.var03] = $01
	jp objectCopyPositionWithOffset

@triggerCutscene:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call clearAllParentItems
	call dropLinkHeldItem
	ld a,CUTSCENE_BLACK_TOWER_ESCAPE_ATTEMPT
	ld (wCutsceneTrigger),a
	jp enemyDelete

@explosionPositions:
	.db $f0 $f0
	.db $10 $08
	.db $f8 $04
	.db $08 $f8


; BUG(?): $00 acts as a terminator, but it's also used as a position value, meaning one movement
; pattern stops early? (Doesn't apply if $00 is in the first row.)
veranFairy_movementPatternTable:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3

@pattern0:
	.db $00 $78
	.db $00 $f7 ; Terminates early here?
	.db $c0 $e0
	.db $58 $78
	.db $00
@pattern1:
	.db $00 $f7
	.db $58 $78
	.db $58 $f7
	.db $c0 $f7
	.db $58 $78
	.db $00
@pattern2:
	.db $58 $f7
	.db $30 $f7
	.db $c0 $38
	.db $c0 $b8
	.db $58 $78
	.db $00
@pattern3:
	.db $00 $f7
	.db $c0 $f7
	.db $10 $f7
	.db $90 $f7
	.db $58 $78
	.db $00


veranFairy_attackTable:
	.db $00 $00 $00 $00 $00 $00 $01 $01 ; High health
	.db $00 $00 $00 $00 $00 $01 $01 $02 ; Mid health
	.db $00 $00 $01 $01 $01 $02 $02 $02 ; Low health


veranFairy_speedTable:
	.db SPEED_140, SPEED_1c0, SPEED_200

;;
veranFairy_checkLoopAroundScreen:
	call objectGetShortPosition
	ld e,a
	ld hl,@data1
	call lookupKey
	ret nc

	ld hl,@data2
	rst_addAToHl
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ldh (<hFF8F),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a
	ldh (<hFF8E),a
	ret

@data1:
	.db $07 $00
	.db $0f $02
	.db $1f $04
	.db $3f $06
	.db $5f $08
	.db $9f $0a
	.db $c3 $0c
	.db $cb $0a
	.db $ce $0e
	.db $cf $00
	.db $00

@data2:
	.db $c0 $00
	.db $00 $00
	.db $90 $00
	.db $00 $38
	.db $30 $00
	.db $58 $00
	.db $00 $b8
	.db $c0 $78

;;
; @param[out]	a	Value written to var35
veranFairy_updateVar35BasedOnHealth:
	ld b,$00
	ld e,Enemy.health
	ld a,(de)
	cp 20
	jr nc,++
	inc b
	cp 10
	jr nc,++
	inc b
++
	ld e,Enemy.var35
	ld a,b
	ld (de),a
	ret

;;
veranFairy_66ed:
	call ecom_decCounter2
	ret nz
	ld e,Enemy.var03
	ld a,(de)
	rst_jumpTable
	.dw attack0
	.dw attack1
	.dw attack2

; Shooting occasional projectiles
attack0:
	ld e,Enemy.var36
	ld a,(de)
	or a
	jr nz,@label_10_227

	call getRandomNumber_noPreserveVars
	and $0f
	ld b,a
	ld h,d
	ld l,Enemy.var35
	ld a,(hl)
	add a
	add $08
	cp b
	ld l,Enemy.counter2
	ld (hl),60
	ret nc

	xor a
	ldd (hl),a
	inc a
	ld (hl),a
	ld l,Enemy.var36
	ld (hl),a
	ld l,Enemy.var37
	ld (hl),$04

@label_10_227:
	call ecom_decCounter1
	jr z,@label_10_228
	ld a,(hl)
	cp $0e
	ret nz
	ld a,$05
	jp enemySetAnimation

@label_10_228:
	call veranFairy_checkWithinBoundary
	ret nc
	ld l,Enemy.var37
	dec (hl)
	jr z,@label_10_229

	ld l,Enemy.counter1
	ld (hl),30

	ld b,PART_VERAN_FAIRY_PROJECTILE
	call ecom_spawnProjectile
	ld a,$06
	jp enemySetAnimation

@label_10_229:
	ld l,Enemy.counter2
	ld (hl),90
	ld l,Enemy.var36
	ld (hl),$00
	ret

; Circular projectile attack
attack1:
	ld e,Enemy.var36
	ld a,(de)
	or a
	jr nz,@label_10_230

	call veranFairy_checkWithinBoundary
	ret nc

	call getRandomNumber_noPreserveVars
	and $0f
	ld b,a
	ld h,d
	ld l,Enemy.var35
	ld a,(hl)
	add a
	add $06
	cp b
	ld l,Enemy.counter2
	ld (hl),90
	ret nc

	ld (hl),$00 ; [counter2]
	dec l
	ld (hl),180 ; [counter1]
	ld l,Enemy.var36
	ld (hl),$01

	ld b,PART_VERAN_PROJECTILE
	call ecom_spawnProjectile
	ld a,$06
	call enemySetAnimation

@label_10_230:
	pop hl
	call ecom_decCounter1
	jp nz,enemyAnimate

	inc l
	ld (hl),120 ; [counter2]
	ld l,Enemy.var36
	ld (hl),$00
	ld a,$05
	jp enemySetAnimation

; Baby ball attack
attack2:
	ld h,d
	ld l,Enemy.var36
	bit 0,(hl)
	jr nz,@label_10_231

	call veranFairy_checkWithinBoundary
	ret nc

	ld (hl),$01
	ld l,Enemy.counter1
	ld (hl),30
	ld b,PART_BABY_BALL
	call ecom_spawnProjectile
	ld a,$06
	call enemySetAnimation

@label_10_231:
	pop hl
	call ecom_decCounter1
	jp nz,enemyAnimate

	inc l
	ld (hl),$f0
	ld l,Enemy.var36
	ld (hl),$00
	ld a,$05
	jp enemySetAnimation

;;
; @param[out]	cflag	nc if veran is outside the room boundary
veranFairy_checkWithinBoundary:
	ld e,Enemy.yh
	ld a,(de)
	sub $10
	cp $90
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	sub $10
	cp $d0
	ret
