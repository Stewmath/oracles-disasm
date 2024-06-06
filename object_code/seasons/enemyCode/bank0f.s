; ==============================================================================
; ENEMYID_GENERAL_ONOX
; ==============================================================================
enemyCode02:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@justHit
	; dead
	ld e,$a4
	ld a,(de)
	or a
	jr z,@dying
	ld a,$f0
	call playSound
@dying:
	ld e,$b2
	ld a,(de)
	or a
	jr nz,@dead
	call checkLinkCollisionsEnabled
	jr nc,@dead
	ld a,$ff
	ld ($cbca),a
	ld ($cc02),a
	ld h,d
	ld l,$a4
	ld (hl),$00
	ld l,$b2
	inc (hl)
	ld l,$86
	ld (hl),$78
	ld a,$67
	call playSound
@dead:
	jp enemyBoss_dead
@justHit:
	ld e,$82
	ld a,(de)
	or a
	call z,generalOnox_func_5c75
@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state0
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
+
	ld a,b
	rst_jumpTable
	.dw generalOnox_subid0
	.dw generalOnox_subid1
	.dw generalOnox_subid2

@state0:
	ld a,b
	cp $02
	jr z,+
	ld bc,$0210
	call enemyBoss_spawnShadow
	ret nz
	ld a,$02
	ld b,$89
	call enemyBoss_initializeRoom
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld a,$0a
	jp ecom_setSpeedAndState8
+
	ld a,$89
	call loadPaletteHeader
	ld a,$01
	ld ($cfcf),a
	ld ($cbca),a
	call ecom_setSpeedAndState8
	ld a,$53
	jp playSound
	
@stateStub:
	ret
	
generalOnox_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC

@state8:
	ld b,PARTID_47
	call ecom_spawnProjectile
	ret nz
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$89
	ld (hl),$10
	ld l,$8b
	ld (hl),$18
	ld l,$8d
	ld (hl),$78
	jp objectSetVisible83

@state9:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	ld a,$05
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $04
	ret nz
	ld h,d
	ld l,$85
	inc (hl)
	ld l,$87
	ld (hl),$1e
	
@@substate1:
	call ecom_decCounter2
	ret nz
	ld a,(wFrameCounter)
	and $1f
	ld a,$70
	call z,playSound
	call objectApplySpeed
	ld e,$8b
	ld a,(de)
	cp $48
	jp nz,enemyAnimate
	ld h,d
	ld l,$85
	inc (hl)
	inc l
	ld (hl),$08
	
@@substate2:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ld bc,TX_501c
	call checkIsLinkedGame
	jr z,+
	ld c,<TX_5020
+
	jp showText
	
@@substate3:
	ld e,$90
	ld a,$0f
	ld (de),a
	ld a,$2e
	ld (wActiveMusic),a
	call playSound
	ld a,$04
	call objectGetRelatedObject2Var
	inc (hl)

@func_594f:
	ld h,d
	ld l,$84
	ld (hl),$0a
	inc l
	ld (hl),$00
	inc l
	ld (hl),$2d
	ld a,$02
	jp enemySetAnimation
	
@stateA:
	call ecom_decCounter1
	ret nz
	ld (hl),$b4
	inc l
	ld (hl),$0a
	ld l,e
	inc (hl)
	jr @stateB@func_59c0
	
@stateB:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call ecom_decCounter1
	jr nz,@@func_598b
	ld a,$24
	call objectGetRelatedObject2Var
	res 7,(hl)
	ld l,$da
	res 7,(hl)
	ld l,$c4
	ld (hl),$08
	jr @func_5a06

@@func_598b:
	call generalOnox_subid2@func_5c3b
	jr nc,+
	call enemyAnimate
	call ecom_decCounter2
	jr nz,@@func_59c0
	ld a,$09
	call objectGetRelatedObject2Var
	ld a,(hl)
	sub $0e
	cp $07
	jr nc,@@func_59c0
	ld l,$c4
	inc (hl)
	ld e,$85
	ld a,$01
	ld (de),a
	ld a,$05
	jp enemySetAnimation
+
	ld l,$87
	ld (hl),$0a
	ld a,(wFrameCounter)
	and $07
	call z,generalOnox_func_59c0
	call ecom_applyVelocityForSideviewEnemyNoHoles

@@func_59c0:
	jp enemyAnimate

@@substate1:
	ld a,$09
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $03
	ret nz
	ld l,$c4
	inc (hl)
	ld l,$e8
	ld (hl),$f8
	ld l,$c9
	ld (hl),$0e
	ld l,$c6
	ld (hl),$00
	ld l,$cb
	ld e,$8b
	ld a,(de)
	sub $10
	ld (hl),a
	ld l,$f0
	add $21
	ld (hl),a
	ld l,$cd
	ld e,$8d
	ld a,(de)
	add $08
	ld (hl),a
	ld l,$f1
	add $f9
	ld (hl),a
	ld e,$85
	ld a,$02
	ld (de),a
	inc a
	jp enemySetAnimation

@@substate2:
	ld a,$24
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret nz
@func_5a06:
	call getRandomNumber_noPreserveVars
	cp $8c
	jp c,@func_594f
	ld h,d
	ld l,$84
	inc (hl)
	inc l
	ld (hl),$00
	ld l,$86
	ld (hl),$10
	ld a,$04
	jp enemySetAnimation
	
@stateC:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ld l,$94
	ld a,$c0
	ldi (hl),a
	ld (hl),$fd
	ld a,$81
	call playSound
	jp objectSetVisible81

@@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,$85
	inc (hl)
	inc l
	ld a,$b4
	ld (hl),a
	call setScreenShakeCounter
	call objectSetVisible83
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_48
	ret

@@substate2:
	call ecom_decCounter1
	ret nz
	jp @func_594f
	
generalOnox_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw generalOnox_subid0@stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD

@state8:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,$84
	inc (hl)
	inc l
	xor a
	ld (hl),a
	ld ($cd18),a
	ld ($cd19),a
	ld l,$b0
	dec a
	ldi (hl),a
	ld (hl),a
	ld a,$01
	call enemySetAnimation
	jp objectSetVisible83

@state9:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld e,$ab
	ld a,(de)
	or a
	ret nz
	ld a,($cc34)
	or a
	ret nz
	inc a
	ld ($cca4),a
	ld ($cbca),a
	ld e,$85
	ld (de),a
	ld bc,TX_501d
	jp showText

@@substate1:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$64
	ld a,$00
	call objectGetRelatedObject1Var
	ld bc,$18f8
	call objectCopyPositionWithOffset
	ldh a,(<hCameraY)
	ld b,a
	ld l,$cb
	ld a,(hl)
	sub b
	cpl
	inc a
	sub $10
	ld l,$cf
	ld (hl),a
	ld l,$da
	ld (hl),$81
	ld l,$c4
	inc (hl)
	ret

@@substate2:
	call ecom_decCounter1
	ret nz
	ld l,$a4
	set 7,(hl)
	xor a
	ld ($cca4),a
	ld ($cbca),a

@func_5ae5:
	ld h,d
	ld l,$84
	ld (hl),$0a
	inc l
	ld (hl),$00
	ld l,$86
	ld (hl),$2d
	ld l,$b1
	ldd a,(hl)
	ldi (hl),a
	ld (hl),$00
	ld a,$02
	jp enemySetAnimation

@stateB:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw generalOnox_subid0@stateB@substate1
	.dw @@substate2

@@substate0:
	call ecom_decCounter1
	jp nz,generalOnox_subid0@stateB@func_598b
	ld a,$24
	call objectGetRelatedObject2Var
	res 7,(hl)
	ld l,$da
	res 7,(hl)
	ld l,$c4
	ld (hl),$08

@@substate2:
	ld a,$24
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret nz

@func_5b22:
	ld h,d
	ld l,$b0
	ldi a,(hl)
	cp (hl)
	ld l,$85
	ld (hl),$00
	jr z,+
	call getRandomNumber
	rrca
	jr c,@func_5ae5
	ld h,d
	dec l
	ld (hl),$0d
	ld l,$b1
	ldd a,(hl)
	ldi (hl),a
	ld (hl),$02
	call generalOnox_func_5c63
	ld e,$86
	ld a,(de)
	dec a
	ret z
	xor a
	jp enemySetAnimation
+
	dec l
	ld (hl),$0c
	ld l,$86
	ld (hl),$10
	ld l,$b1
	ldd a,(hl)
	ldi (hl),a
	ld (hl),$01
	ld a,$04
	jp enemySetAnimation

@stateC:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw generalOnox_subid0@stateC@substate0
	.dw generalOnox_subid0@stateC@substate1
	.dw @@substate2

@@substate2:
	call ecom_decCounter1
	ret nz
	jp @func_5ae5

@stateD:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @func_5b22

@@substate0:
	call ecom_decCounter1
	jr nz,+
	inc (hl)
	inc l
	ld (hl),$04
	ld l,e
	inc (hl)
	ld a,$03
	jp enemySetAnimation
+
	call ecom_updateAngleTowardTarget
	call objectApplySpeed
	jp enemyAnimate

@@substate1:
	call ecom_decCounter1
	ret nz
	ld (hl),$2d
	inc l
	dec (hl)
	jr z,+
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_49
	ld bc,$19f9
	jp objectCopyPositionWithOffset
+
	ld l,e
	inc (hl)
	ret
	
generalOnox_subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC

@state8:
	ld a,($cc77)
	or a
	ret nz
	ld ($cfcf),a
	inc a
	ld ($cca4),a
	ld h,d
	ld l,$8b
	ld (hl),$50
	ld l,$8d
	ld (hl),$50
	ldbc INTERACID_0b $02
	call objectCreateInteraction
	ret nz
	ld e,$98
	ld a,$40
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld e,$84
	ld a,$09
	ld (de),a
	jp clearAllParentItems

@state9:
	ld a,$21
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$5a
	call objectSetVisible82

@stateA:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	and $1c
	rrca
	rrca
	ld hl,@table_5c1f
	rst_addAToHl
	ld e,Enemy.yh
	ld a,(hl)
	ld (de),a
	ret
+
	ld (hl),$5a
	ld l,e
	inc (hl)
	ld a,$30
	ld ($cd08),a
	ld a,$08
	ld ($cbae),a
	ld a,$06
	ld ($cbac),a
	ld bc,TX_5022
	jp showText

@table_5c1f:
	.db $50
	.db $51
	.db $52
	.db $53
	.db $52
	.db $51
	.db $50
	.db $4f

@stateB:
	ld e,$84
	ld a,$0c
	ld (de),a
	jp fadeoutToWhite

@stateC:
	ld a,($c4ab)
	or a
	ret nz
	ld hl,$cfc8
	inc (hl)
	jp enemyDelete

@func_5c3b:
	ld h,d
	ld l,$8b
	ldh a,(<hEnemyTargetY)
	sub (hl)
	cp $30
	ret nc
	ld l,$8d
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $10
	cp $21
	ret

generalOnox_func_59c0:
	ldh a,(<hEnemyTargetY)
	sub $18
	cp $98
	jr c,+
	ld a,$10
+
	ld b,a
	ldh a,(<hEnemyTargetX)
	ld c,a
	call objectGetRelativeAngle
	ld e,$89
	ld (de),a
	ret

generalOnox_func_5c63:
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@table_5c71
	rst_addAToHl
	ld e,$86
	ld a,(hl)
	ld (de),a
	ret

@table_5c71:
	.db $01
	.db $1e
	.db $3c
	.db $5a
	
generalOnox_func_5c75:
	ld e,$a9
	ld a,(de)
	cp $28
	ret nc
	ld h,d
	ld l,$82
	inc (hl)
	ld l,$84
	ld (hl),$08
	ld l,$a4
	res 7,(hl)
	ld a,$24
	call objectGetRelatedObject2Var
	res 7,(hl)
	ld l,$da
	res 7,(hl)
	ld l,$c4
	ld (hl),$08
	ld a,$67
	jp playSound


; ==============================================================================
; ENEMYID_DRAGON_ONOX
;
; Variables:
;   var2a:
;   var2f:
;   var30:
;   var31:
;   var32:
;   var33:
;   var34:
;   var35:
;   var36:
;   var37:
;   var38:
;   $cfc8 - near end
;   $cfc9
;   $cfca
;   $cfcb
;   $cfcc
;   $cfcd
;   $cfd7 - Pointer to main body (subid $01)
;   $cfd8 - Pointer to left shoulder (subid $02)
;   $cfd9 - Pointer to right shoulder (subid $03)
;   $cfda - Pointer to left claw (subid $04)
;   $cfdb - Pointer to right claw (subid $05)
;   $cfdc - Pointer to left claw sphere (subid $06)
;   $cfdd - Pointer to right claw sphere (subid $07)
;   $cfde - Pointer to left shoulder sphere (subid $08)
;   $cfdf - Pointer to right shoulder sphere (subid $09)
; ==============================================================================
enemyCode05:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@justHit

	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)
	xor a
	ld l,Enemy.substate
	ldd (hl),a
	; state $0e
	ld (hl),$0e
	ld l,Enemy.health
	inc a
	ld (hl),a
	ld (wDisableLinkCollisionsAndMenu),a
	jr @normalStatus

@justHit:
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jr nz,@normalStatus

	; main body
	ld e,Enemy.var2a
	ld a,(de)
	res 7,a
	sub $04
	cp $06
	jr nc,@normalStatus

	ld h,d
	ld l,Enemy.invincibilityCounter
	ld (hl),$3c
	; var30 - $06
	; var31 - $06
	; var32 - $04
	; var37 - $01
	; $cfc9 - $86
	ld l,Enemy.var37
	ld (hl),$01
	ld l,Enemy.var31
	ld (hl),$06
	inc l
	ld (hl),$04
	ld a,$06
	call dragonOnoxLoadaIntoVar30Andcfc9

@normalStatus:
	ld e,Enemy.subid
	ld a,(de)
	ld b,a
	ld e,Enemy.state
	ld a,b
	rst_jumpTable
	.dw dragonOnox_bodyPartSpawner
	.dw dragonOnox_mainBody
	.dw dragonOnox_leftShoulder
	.dw dragonOnox_rightShoulder
	.dw dragonOnox_leftClaw
	.dw dragonOnox_rightClaw
	.dw dragonOnox_leftClawSphere
	.dw dragonOnox_rightClawSphere
	.dw dragonOnox_leftShoulderSphere
	.dw dragonOnox_rightShoulderSphere

dragonOnox_bodyPartSpawner:
	ld a,ENEMYID_DRAGON_ONOX
	ld b,$8a
	call enemyBoss_initializeRoom
	xor a
	ld (wLinkForceState),a
	inc a
	ld (wLoadedTreeGfxIndex),a
	ld (wDisableLinkCollisionsAndMenu),a
	ld b,$09
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMYID_DRAGON_ONOX
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a
	ld a,h
	; store in $cfd7 a pointer to Dragon Onox with subid $01
	ld hl,$cfd7
	ldi (hl),a
	ld c,$08
-
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	; spawn from subids $02 to $09, storing in $cfd8 to $cfdf
	ld a,$0a
	sub c
	ld (hl),a
	ld a,h
	pop hl
	ldi (hl),a
	dec c
	jr nz,-
	jp enemyDelete

dragonOnox_mainBody:
	ld e,Enemy.state
	ld a,(de)
	sub $02
	cp $0c
	jr nc,+
	; state $02 to $0d
	ld a,(wFrameCounter)
	and $3f
	ld a,SND_AQUAMENTUS_HOVER
	call z,playSound
+
	call dragonOnox_checkTransitionState
	call z,dragonOnox_mainBodyStateHandler
	call seasonsFunc_0f_65c7
	jp seasonsFunc_0f_65fc

dragonOnox_mainBodyStateHandler:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw dragonOnox_mainBody_state0
	.dw dragonOnox_mainBody_state1
	.dw dragonOnox_mainBody_state2
	.dw dragonOnox_mainBody_state3
	.dw dragonOnox_mainBody_state4
	.dw dragonOnox_mainBody_state5
	.dw dragonOnox_mainBody_state6
	.dw dragonOnox_mainBody_state7
	.dw dragonOnox_mainBody_state8
	.dw dragonOnox_mainBody_state9
	.dw dragonOnox_mainBody_stateA
	.dw dragonOnox_mainBody_stateB
	.dw dragonOnox_mainBody_stateC
	.dw dragonOnox_mainBody_stateD
	.dw dragonOnox_mainBody_stateE

dragonOnox_checkTransitionState:
	ld e,Enemy.state
	ld a,(de)
	cp $0e
	ret z

	ld b,a
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	or a
	ret z

	; Continue once invincibilityCounter about to end
	dec a
	ret nz

	ld a,b
	cp $08
	jr nz,+

	ld e,Enemy.substate
	ld a,(de)
	sub $02
	cp $02
	jr nc,+

	; substate with value $02 or $03
	ld e,Enemy.angle
	ld a,(de)
	bit 4,a
	ld a,$08
	jr nz,++
	ld a,$09
	jr ++
+
	; non-state $08 goes here
	; or non-substate of $02/$03
	ld e,Enemy.var30
	ld a,(de)
	and $01
	add $00
++
	; non-state 8
	;	var30 - bit 0 of previous var30
	;	$cfc9 - $80|bit 0 of previous var30
	; state 8, substate of $02/$03, bit 4 of angle set (ANGLE_DOWN/ANGLE_LEFT)
	;	var30 - $08
	;	$cfc9 - $88
	; state 8, substate of $02/$03, bit 4 of angle not set (ANGLE_UP/ANGLE_RIGHT)
	;	var30 - $09
	;	$cfc9 - $89
	jp dragonOnoxLoadaIntoVar30Andcfc9

dragonOnox_mainBody_state0:
	ld h,d
	ld l,e
	; next state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$5a
	ld l,Enemy.speed
	ld (hl),SPEED_80
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.oamFlagsBackup
	ld a,$05
	ldi (hl),a
	ld (hl),a
	; var31 - $14
	; var32 - $0c
	ld l,Enemy.var31
	ld (hl),$14
	inc l
	ld (hl),$0c
	call checkIsLinkedGame
	jr nz,+
	ld l,Enemy.health
	ld (hl),$22
+
	call objectSetVisible83
	ld a,$04
	jp fadeinFromWhiteWithDelay

dragonOnox_mainBody_state1:
	inc e
	ld a,(de)
	or a
	jr nz,++

	; substate is 0
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $3c
	ret nz
	ld a,SND_AQUAMENTUS_HOVER
	jp playSound
+
	ld l,e
	inc (hl)
	ld a,$08
	ld (wTextboxFlags),a
	ld a,$06
	ld (wTextboxPosition),a
	ld bc,TX_501e
	jp showText
++
	ld h,d
	ld l,e
	xor a
	ldd (hl),a
	inc (hl)

	; start fight
	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,MUS_FINAL_BOSS
	ld (wActiveMusic),a
	jp playSound

dragonOnox_mainBody_state2:
	; Every substate here starts with (hl)=Enemy.var37
	ld h,d
	ld l,Enemy.var37
	bit 0,(hl)
	jr z,+
	ld (hl),$00
	ld l,Enemy.counter2
	ld (hl),$00
+
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld h,d
	ld l,e
	; next substate
	inc (hl)
	; counter1
	inc l
	ld (hl),$1e
	; counter2
	inc l
	ld (hl),$10

	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld l,Enemy.var33
	ld (hl),$00
	call getRandomNumber_noPreserveVars
	and $01
	ld b,ANGLE_UP
	jr nz,+
	dec a
	ld b,ANGLE_DOWN
+
	ld e,Enemy.var34
	ld (de),a
	ld e,Enemy.angle
	ld a,b
	ld (de),a
	ret

@substate1:
	call ecom_decCounter2
	jp z,seasonsFunc_0f_665c
	ld l,e
	; go to substate2
	ld (hl),$02
	call seasonsFunc_0f_6637
	
@substate2:
	call ecom_decCounter1
	jr nz,+
	ld (hl),$1e
	ld a,($cfcc)
	sub $10
	cp $40
	jr c,+
	call getRandomNumber
	cp $a0
	jr nc,+
	ld l,e
	inc (hl)
	ret
+
	ld l,Enemy.var35
	ld b,(hl)
	; var36
	inc l
	ld c,(hl)
	ld a,($cfcc)
	ld h,a
	ld a,($cfcd)
	ld l,a
	sub c
	add $06
	cp $0d
	jr nc,+
	ld a,h
	sub b
	add $06
	cp $0d
	jr c,@substate1
+
	ld e,Enemy.counter1
	ld a,(de)
	rrca
	jr c,+
	call seasonsFunc_0f_6529
	call objectNudgeAngleTowards
+
	jp seasonsFunc_0f_650d

@substate3:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ld l,Enemy.xh
	ld a,(w1Link.xh)
	cp (hl)
	; dragon Onox subid 4
	ld hl,$cfda
	jr c,+
	; subid 5
	inc l
+
	; choose claw to action
	ld h,(hl)
	ld l,Enemy.var30
	ld (hl),$01
	ret

@substate4:
	ld h,d
	ld l,Enemy.counter1
	bit 0,(hl)
	ret z
	ld (hl),$96
	ld l,e
	; back to substate 2
	ld (hl),$02
	ret

dragonOnox_mainBody_state3:
dragonOnox_mainBody_state6:
dragonOnox_mainBody_state9:
dragonOnox_mainBody_stateC:
	call ecom_decCounter1
	jr nz,@seasonsFunc_0f_5ecb
	ld l,e
	inc (hl)
	ret

@seasonsFunc_0f_5ecb:
	ld l,Enemy.var35
	ldi a,(hl)
	; var36
	ld c,(hl)
	ld b,a
	call seasonsFunc_0f_66aa
	ret nz
	jp seasonsFunc_0f_6680

dragonOnox_mainBody_state4:
	call getRandomNumber_noPreserveVars
	ld b,a
	call dragonOnoxLowHealthThresholdIntoC
	ld e,Enemy.health
	ld a,(de)
	cp c
	ld a,b
	jr nc,@seasonsFunc_0f_5ee8
	rrca
	jr +

@seasonsFunc_0f_5ee8:
	cp $a0
+
	ld a,$05
	jr c,+
	ld a,$08
+
	ld e,Enemy.state
	ld (de),a
	inc e
	xor a
	ld (de),a
	ld e,Enemy.var37
	ld (de),a
	ret

dragonOnox_mainBody_state5:
	ld h,d
	ld l,Enemy.var37
	bit 0,(hl)
	jr z,+
	ld (hl),$00
	ld l,Enemy.counter2
	ld (hl),$00
+
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,e
	; go to substate1
	inc (hl)
	inc l
	; counter1
	ld (hl),$2d
	inc l
	; counter2
	ld (hl),$04
	ld l,Enemy.speed
	ld (hl),SPEED_a0
	ret

@substate1:
	call ecom_decCounter1
	jr z,+
	ld a,(w1Link.xh)
	sub $50
	ld c,a
	ld b,$00
	jp seasonsFunc_0f_66aa
+
	ld (hl),$1e
	ld l,e
	inc (hl)
	ld l,Enemy.var30
	ld a,(hl)
	and $01
	add $02
	jp dragonOnoxLoadaIntoVar30Andcfc9

@substate2:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$1e
	ld l,$b0
	ld a,(hl)
	and $01
	add $04
	jp dragonOnoxLoadaIntoVar30Andcfc9

@substate3:
	call ecom_decCounter1
	jr z,@seasonsFunc_0f_5f6c
	ld a,(hl)
	cp $14
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_33
	ld bc,$1800
	call objectCopyPositionWithOffset
	ld a,SND_DODONGO_OPEN_MOUTH
	jp playSound

@seasonsFunc_0f_5f6c:
	ld l,Enemy.var30
	ld a,(hl)
	and $01
	add $00
	call dragonOnoxLoadaIntoVar30Andcfc9
	call ecom_decCounter2
	jp z,seasonsFunc_0f_665c
	; var2f
	dec l
	ld (hl),$2d
	; stunCounter
	dec l
	ld (hl),$01
	ret

dragonOnox_mainBody_state7:
	call dragonOnoxLowHealthThresholdIntoC
	ld e,Enemy.health
	ld a,(de)
	cp c
	ld a,$08
	jr nc,+
	ld a,$0b
+
	ld e,Enemy.state
	; go to state $08 if health is high, else $0b
	; reset substate, and var37
	ld (de),a
	inc e
	xor a
	ld (de),a
	ld e,Enemy.var37
	ld (de),a
	ret

dragonOnox_mainBody_state8:
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

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld bc,$20c0
	ld l,Enemy.xh
	ld a,(hl)
	cp $50
	jr c,+
	ld c,$40
+
	ld l,Enemy.var35
	ld (hl),b
	; var36
	inc l
	ld (hl),c
	ret

@substate1:
	ld h,d
	ld l,Enemy.var35
	ld b,(hl)
	; var36
	inc l
	ld c,(hl)
	call seasonsFunc_0f_66aa
	ret nz
	ld h,d
	ld l,Enemy.substate
	inc (hl)
	; counter1
	inc l
	ld (hl),$1e
	ld l,Enemy.var36
	bit 7,(hl)
	ld a,$09
	ld bc,(ANGLE_RIGHT<<8)|$48
	jr nz,+
	ld a,$08
	ld bc,(ANGLE_LEFT<<8)|$b8
+
	ld (hl),c
	ld l,Enemy.angle
	ld (hl),b
	jp dragonOnoxLoadaIntoVar30Andcfc9

@substate2:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_240
	ld l,Enemy.var36
	bit 7,(hl)
	; dragon Onox subid 4
	ld hl,$cfda
	jr z,+
	inc l
+
	; choose claw to action
	ld h,(hl)
	ld l,Enemy.var30
	ld (hl),$02
	ld a,SND_DODONGO_OPEN_MOUTH
	jp playSound

@substate3:
	ld h,d
	ld l,Enemy.var36
	ld a,($cfcd)
	sub (hl)
	add $02
	cp $05
	jp nc,seasonsFunc_0f_650d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ld a,$00
	jp dragonOnoxLoadaIntoVar30Andcfc9

@substate4:
	call ecom_decCounter1
	ld a,(hl)
	and $03
	jr nz,+
	xor a
	call objectNudgeAngleTowards
+
	call seasonsFunc_0f_650d
	ld a,($cfcc)
	cp $d0
	ret nz
	ld h,d
	ld l,Enemy.substate
	inc (hl)
	inc l
	ld (hl),$00
	ret

@substate5:
	call ecom_decCounter1
	ld bc,$b000
	ld a,($cfcd)
	or a
	jr nz,+
	ld l,e
	inc (hl)
	ret
+
	ld l,a
	ld a,($cfcc)
	ld h,a
	ld e,Enemy.counter1
	ld a,(de)
	and $03
	jr nz,+
	call seasonsFunc_0f_6529
	call objectNudgeAngleTowards
+
	jp seasonsFunc_0f_650d

@substate6:
	ld hl,$cfcc
	inc (hl)
	ret nz
	ld h,d
	jp seasonsFunc_0f_665c

dragonOnox_mainBody_stateA:
	call dragonOnoxLowHealthThresholdIntoC
	ld e,Enemy.health
	ld a,(de)
	cp c
	ld a,$02
	jr nc,+
	ld a,$0b
+
	; go to state $02 if health is high, else $0b
	ld e,Enemy.state
	ld (de),a
	inc e
	xor a
	ld (de),a
	ld e,Enemy.var37
	ld (de),a
	ret

dragonOnox_mainBody_stateB:
	ld h,d
	ld l,Enemy.var37
	bit 0,(hl)
	jr z,+
	ld l,Enemy.state
	inc (hl)
	ret
+
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ret

@substate1:
	ld bc,$f800
	call seasonsFunc_0f_66aa
	ret nz
	ld h,d
	ld l,Enemy.substate
	inc (hl)
	; counter1
	inc l
	ld (hl),$3c
	ld l,Enemy.var30
	ld a,(hl)
	and $01
	add $02
	jp dragonOnoxLoadaIntoVar30Andcfc9

@substate2:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $1e
	ret nz
	ld l,Enemy.var30
	ld a,(hl)
	and $01
	add $04
	jp dragonOnoxLoadaIntoVar30Andcfc9
+
	inc (hl)
	; var38
	inc l
	ld (hl),$18
	ld l,e
	inc (hl)
	call getRandomNumber_noPreserveVars
	and $18
	ld e,Enemy.var33
	ld (de),a
	ret

@substate3:
	call ecom_decCounter1
	ret nz
	ld (hl),$14
	ld l,Enemy.var33
	ld a,(hl)
	ld hl,@seasonsTable_0f_6116
	rst_addAToHl
	ld c,(hl)
	; fireballs?
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_4a
	ld l,Part.var31
	ld (hl),c
	ld bc,$1800
	call objectCopyPositionWithOffset
	ld a,SND_BEAM
	call playSound
	ld e,Enemy.var33
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	call ecom_decCounter2
	ret nz
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.var30
	ld a,(hl)
	and $01
	add $00
	jp dragonOnoxLoadaIntoVar30Andcfc9

@seasonsTable_0f_6116:
	.db $08 $a0 $18 $90 $28 $80 $38 $70
	.db $48 $60 $58 $50 $68 $40 $78 $30
	.db $88 $20 $98 $10 $00 $50 $30 $70
	.db $10 $90 $40 $60 $20 $80 $08 $98

dragonOnox_mainBody_stateD:
	ld e,Enemy.state
	ld a,$02
	ld (de),a
	inc e
	xor a
	ld (de),a
	ld e,Enemy.var37
	ld (de),a
	ret

dragonOnox_mainBody_stateE:
	; defeated
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	; counter1
	inc l
	ld (hl),$00
	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN
	ld l,Enemy.speed
	ld (hl),$0a
	ld l,Enemy.collisionType
	res 7,(hl)
	; dragon Onox subid 4 - left claw
	ld a,($cfda)
	ld h,a
	res 7,(hl)
	; dragon Onox subid 5 - right claw
	ld a,($cfdb)
	ld h,a
	res 7,(hl)

	ld a,$04
	ld ($cfc8),a
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,($cfcd)
	cpl
	inc a
	ld (wScreenOffsetX),a
	ld a,($cfcc)
	cpl
	inc a
	ld (wScreenOffsetY),a
	ld a,$08
	ld (wTextboxFlags),a
	ld a,$04
	ld (wTextboxPosition),a
	ld bc,TX_501f
	jp showTextNonExitable

@substate1:
	ld a,$02
	ld (de),a
	ld a,SND_BIG_EXPLOSION_2
	jp playSound

@substate2:
	ld a,(wFrameCounter)
	and $0f
	ld a,SND_RUMBLE
	call z,playSound
	call ecom_decCounter1
	ld a,(hl)
	and $03
	ld hl,@seasonsTable_0f_61b9
	rst_addAToHl
	ld a,($cfcd)
	add (hl)
	ld ($cfcd),a
	jp seasonsFunc_0f_650d

@seasonsTable_0f_61b9:
	.db $fd $06 $fc $01

dragonOnox_leftShoulder:
	ld a,(de)
	rst_jumpTable
	.dw @animate
	.dw @offsetBasedOncfca

@animate:
	ld h,d
	ld l,e
	inc (hl)
	ld a,$09
	call enemySetAnimation
	call objectSetVisible83

@offsetBasedOncfca:
	ld a,($cfca)
	cp $08
	ld bc,$603a
	jr c,+
	ld bc,$5238
	jr z,+
	ld bc,$6640
+
	; $00-$07	bc = $603a
	; $08		bc = $5238
	; $09+		bc = $6640
	ld e,Enemy.yh
	ld a,($cfcc)
	add b
	ld (de),a

	ld e,Enemy.xh
	ld a,($cfcd)
	add c
	ld (de),a
	ret

dragonOnox_rightShoulder:
	ld a,(de)
	rst_jumpTable
	.dw @animate
	.dw @offsetBasedOncfca

@animate:
	ld h,d
	ld l,e
	inc (hl)
	ld a,$0a
	call enemySetAnimation
	call objectSetVisible83

@offsetBasedOncfca:
	ld a,($cfca)
	cp $08
	ld bc,$6066
	jr c,+
	ld bc,$6660
	jr z,+
	ld bc,$5268
+
	; $00-$07	bc = $6066
	; $08		bc = $6660
	; $09+		bc = $5268
	ld e,Enemy.yh
	ld a,($cfcc)
	add b
	ld (de),a

	ld e,Enemy.xh
	ld a,($cfcd)
	add c
	ld (de),a
	ret

dragonOnox_leftClaw:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.collisionType
	set 7,(hl)
	inc l
	; enemyCollisionMode
	ld (hl),ENEMYCOLLISION_DRAGON_ONOX_CLAW
	inc l
	; collisionRadiusY
	ld (hl),$05
	inc l
	; collisionRadiusX
	ld (hl),$09
	inc l
	; damage
	ld (hl),$fc

	ld l,Enemy.relatedObj1+1
	; dragon Onox subid 1
	ld a,($cfd7)
	ldd (hl),a
	ld (hl),$80
	ld a,$03
	call enemySetAnimation
	call objectSetVisible82

@state1:
	ld e,Enemy.var30
	ld a,(de)
	or a
	call nz,@seasonsFunc_0f_6277
	ld a,$00
	call objectGetRelatedObject1Var
	ld bc,$30d8
	ld a,($cfca)
	cp $06
	jr c,+
	sub $09
	jr z,+
	ld bc,$18d0
	inc a
	jr z,+
	ld bc,$30e1
+
	; $01-$05	bc = $30d8
	; $06-$07	bc = $30e1
	; $08		bc = $18d0
	; $09		bc = $30d8
	call objectTakePositionWithOffset
	jp seasonsFunc_0f_6557

@seasonsFunc_0f_6277:
	ld h,d
	ld l,e
	; clear var30
	ld (hl),$00
	ld l,Enemy.state
	add (hl)
	ld (hl),a
	; substate
	inc l
	ld (hl),$00
	; counter1
	inc l
	ld (hl),$1e
	ld l,Enemy.subid
	ld a,(hl)
	cp $04
	ld a,$d8
	jr z,+
	ld a,$28
+
	ld l,Enemy.var38
	ldd (hl),a
	; var37
	ld (hl),$30
	ret

@state2:
	ld a,($cfca)
	sub $06
	cp $02
	jr c,+
	call @seasonsFunc_0f_62a5
	jp seasonsFunc_0f_6557

@seasonsFunc_0f_62a5:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
+
	ld a,$00
	call objectGetRelatedObject1Var
	ld e,Enemy.var37
	ld a,(de)
	ld b,a
	inc e
	ld a,(de)
	ld c,a
	jp objectTakePositionWithOffset

@@substate0:
	call ecom_decCounter1
	ret nz
	; counter1 set to $14
	ld (hl),$14
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_100
	ld l,Enemy.angle
	ld (hl),ANGLE_UP
	ld l,Enemy.damage
	ld (hl),$f8
	ld a,SND_SWORDSLASH
	jp playSound

@@substate1:
	call ecom_decCounter1
	jr nz,+
	ld (hl),$06
	ld l,e
	inc (hl)
	ret
+
	call objectApplySpeed
	jp @@seasonsFunc_0f_6386

@@substate2:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $04
	ret nz
	; counter1 = $04
	ld l,Enemy.var36
	ld a,(w1Link.xh)
	ldd (hl),a
	; var35
	ld (hl),$a5
	ret
+
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_300
	ld l,Enemy.collisionRadiusX
	ld (hl),$0e
	ld e,Enemy.subid
	ld a,(de)
	inc a
	jp enemySetAnimation

@@substate3:
	ld h,d
	ld l,Enemy.var35
	call ecom_readPositionVars
	call ecom_moveTowardPosition
	call @@seasonsFunc_0f_6386
	ld e,Enemy.yh
	ld a,(de)
	cp $a0
	ret c
	ld a,$1e
	ld (wScreenShakeCounterY),a
	ld h,d
	ld l,Enemy.substate
	inc (hl)
	; counter1
	inc l
	ld (hl),$3c
	ld a,SND_EXPLOSION
	jp playSound

@@substate4:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $0a
	ret nz
	ld l,Enemy.collisionRadiusX
	ld (hl),$09
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp enemySetAnimation
+
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_c0
	ret

@@substate5:
	ld a,Enemy.yh-Enemy
	call objectGetRelatedObject1Var
	ldi a,(hl)
	add $30
	ld b,a
	inc l
	ld e,Enemy.subid
	ld a,(de)
	cp $04
	ld c,$28
	jr z,+
	ld c,$78
+
	; left claw	c = 28
	; right claw	c = 78
	ld a,(hl)
	add c
	ld c,a
	ld h,d
	ldd a,(hl)
	add $50
	ldh (<hFF8E),a
	dec l
	ld a,(hl)
	ldh (<hFF8F),a
	cp b
	jr nz,+
	ldh a,(<hFF8E)
	cp c
	jr nz,+
	ld l,Enemy.substate
	inc (hl)
	ret
+
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
	call objectApplySpeed
@@seasonsFunc_0f_6386:
	ld a,Enemy.yh-Enemy
	call objectGetRelatedObject1Var
	ld e,l
	ld a,(de)
	sub (hl)
	ld e,Enemy.var37
	ld (de),a
	ld l,Enemy.xh
	ld e,l
	ld a,(de)
	sub (hl)
	ld e,Enemy.var38
	ld (de),a
	ret

@@substate6:
	ld h,d
	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.damage
	ld (hl),$fc
	ld a,$06
	call objectGetRelatedObject1Var
	inc (hl)
	ret

@state3:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.collisionRadiusY
	ld (hl),$0e
	; collisionRadiusY
	inc l
	ld (hl),$0a
	ld l,Enemy.damage
	ld (hl),$f8
	ld e,Enemy.subid
	ld a,(de)
	add $03
	call enemySetAnimation

@@substate1:
	ld a,($cfca)
	or a
	call z,@@seasonsFunc_0f_63e1
	ld a,$00
	call objectGetRelatedObject1Var
	ld bc,$30d8
	ld e,Enemy.subid
	ld a,(de)
	cp $04
	jr z,+
	ld c,$28
+
	jp objectTakePositionWithOffset

@@seasonsFunc_0f_63e1:
	ld h,d
	ld l,Enemy.state
	ld (hl),$01
	ld l,Enemy.collisionRadiusY
	ld (hl),$05
	; collisionRadiusX
	inc l
	ld (hl),$09
	ld l,Enemy.damage
	ld (hl),$fc
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp enemySetAnimation

dragonOnox_rightClaw:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw dragonOnox_leftClaw@state2
	.dw dragonOnox_leftClaw@state3

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.collisionType
	set 7,(hl)
	inc l
	; enemyCollisionMode
	ld (hl),ENEMYCOLLISION_DRAGON_ONOX_CLAW
	inc l
	; collisionRadiusY
	ld (hl),$05
	inc l
	; collisionRadiusX
	ld (hl),$09
	inc l
	; damage
	ld (hl),$fc

	ld l,Enemy.relatedObj1+1
	; dragon Onox subid 1
	ld a,($cfd7)
	ldd (hl),a
	ld (hl),$80
	ld a,$04
	call enemySetAnimation
	call objectSetVisible82
	jp @state1

@state1:
	ld e,Enemy.var30
	ld a,(de)
	or a
	call nz,dragonOnox_leftClaw@seasonsFunc_0f_6277
	ld a,Enemy.enabled-Enemy
	call objectGetRelatedObject1Var
	ld bc,$3028
	ld a,($cfca)
	cp $06
	jr c,+
	sub $08
	jr z,+
	ld bc,$1830
	dec a
	jr z,+
	ld bc,$3031
+
	; $00-$05	bc = $3028
	; $06-$07	bc = $3031
	; $08		bc = $3028
	; $09		bc = $1830
	call objectTakePositionWithOffset
	jp seasonsFunc_0f_6557

dragonOnox_leftClawSphere:
	ld a,(de)
	rst_jumpTable
	.dw @linkPartsAndAnimate
	.dw @connectParts

@linkPartsAndAnimate:
	ld h,d
	ld l,e
	; go to state 1
	inc (hl)

	ld l,Enemy.relatedObj1+1
	; dragon Onox subid 4
	ld a,($cfda)
	ldd (hl),a
	ld (hl),$80

	ld l,Enemy.relatedObj2+1
	; dragon Onox subid 2
	ld a,($cfd8)
	ldd (hl),a
	ld (hl),$80

	ld a,$0d
	call enemySetAnimation
	call objectSetVisible82

@connectParts:
	; keeps self 1/4 of the way from relatedObj1 (claw) to relatedObj2 (shoulder)
	call dragonOnoxDistanceToRelatedObjects
	ld e,l
	sra b
	ld a,b
	sra b
	add b
	add (hl)
	ld (de),a

	ld l,Enemy.xh
	ld e,l
	sra c
	ld a,c
	sra c
	add c
	add (hl)
	ld (de),a
	ret

dragonOnox_rightClawSphere:
	ld a,(de)
	rst_jumpTable
	.dw @linkPartsAndAnimate
	.dw dragonOnox_leftClawSphere@connectParts

@linkPartsAndAnimate:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.relatedObj1+1
	; dragon Onox subid 5
	ld a,($cfdb)
	ldd (hl),a
	ld (hl),$80
	ld l,Enemy.relatedObj2+1
	; dragon Onox subid 3
	ld a,($cfd9)
	ldd (hl),a
	ld (hl),$80
	ld a,$0e
	call enemySetAnimation
	call objectSetVisible82
	jr dragonOnox_leftClawSphere@connectParts

dragonOnox_leftShoulderSphere:
	ld a,(de)
	rst_jumpTable
	.dw @linkPartsAndAnimate
	.dw @connectParts

@linkPartsAndAnimate:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Enemy.relatedObj1+1
	; dragon Onox subid 4
	ld a,($cfda)
	ldd (hl),a
	ld (hl),$80

	ld l,Enemy.relatedObj2+1
	; dragon Onox subid 2
	ld a,($cfd8)
	ldd (hl),a
	ld (hl),$80

	ld a,$0b
	call enemySetAnimation
	call objectSetVisible82

@connectParts:
	; keeps self 1/3 of the way from relatedObj2 (claw) to relatedObj1 (shoulder)
	call dragonOnoxDistanceToRelatedObjects
	ld e,l
	sra b
	sra b
	ld a,b
	sra b
	add b
	add (hl)
	ld (de),a

	ld l,Enemy.xh
	ld e,l
	sra c
	sra c
	ld a,c
	sra c
	add c
	add (hl)
	ld (de),a
	ret

dragonOnox_rightShoulderSphere:
	ld a,(de)
	rst_jumpTable
	.dw @linkPartsAndAnimate
	.dw dragonOnox_leftShoulderSphere@connectParts

@linkPartsAndAnimate:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.relatedObj1+1
	; dragon Onox subid 5
	ld a,($cfdb)
	ldd (hl),a
	ld (hl),$80
	ld l,Enemy.relatedObj2+1
	; dragon Onox subid 3
	ld a,($cfd9)
	ldd (hl),a
	ld (hl),$80
	ld a,$0c
	call enemySetAnimation
	call objectSetVisible82
	jr dragonOnox_leftShoulderSphere@connectParts

seasonsFunc_0f_650d:
	ld e,Enemy.yh
	ld a,($cfcc)
	ld (de),a
	ld e,Enemy.xh
	ld a,($cfcd)
	ld (de),a
	call objectApplySpeed
	ld e,Enemy.yh
	ld a,(de)
	ld ($cfcc),a
	ld e,Enemy.xh
	ld a,(de)
	ld ($cfcd),a
	ret

seasonsFunc_0f_6529:
	ld a,h
	add $60
	ldh (<hFF8F),a
	ld a,l
	add $50
	ldh (<hFF8E),a
	ld a,b
	add $60
	ld b,a
	ld a,c
	add $50
	ld c,a
	jp objectGetRelativeAngleWithTempVars


; @param[out]	b	relatedObj1.yh - relatedObj2.yh
; @param[out]	c	relatedObj1.xh - relatedObj2.xh
; @param[out]	hl	relatedObj2.yh
dragonOnoxDistanceToRelatedObjects:
	ld a,Enemy.yh-Enemy
	call objectGetRelatedObject2Var
	push hl
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)

	ld a,Enemy.yh-Enemy
	call objectGetRelatedObject1Var
	ld a,(hl)
	sub b
	; b now yh delta
	ld b,a
	ld l,Enemy.xh
	ld a,(hl)

	sub c
	; c now xh delta
	ld c,a

	; now relatedObject2.yh
	pop hl
	ret

seasonsFunc_0f_6557:
	ld h,d
	ld l,Enemy.collisionType
	bit 7,(hl)
	ret z
	ld a,(w1Link.speedZ+1)
	rlca
	jr c,seasonsFunc_0f_65b7
	ld l,Enemy.collisionRadiusX
	ld a,(hl)
	add $06
	ld b,a
	add a
	inc a
	ld c,a
	ld l,Enemy.xh
	ld a,(w1Link.xh)
	sub (hl)
	add b
	cp c
	jr nc,seasonsFunc_0f_65b7
	ld l,Enemy.collisionRadiusY
	ld a,(w1Link.collisionRadiusY)
	add (hl)
	add $03
	ld b,a
	ld e,Enemy.yh
	ld a,(de)
	sub b
	ld c,a
	ld a,(w1Link.yh)
	sub c
	inc a
	cp $03
	jr nc,seasonsFunc_0f_65b7
	ld a,d
	ld (wLinkRidingObject),a
	ld l,Enemy.var31
	bit 0,(hl)
	jr nz,+
	inc (hl)
	call seasonsFunc_0f_65bb
+
	ld a,c
	ld (w1Link.yh),a
	ld l,Enemy.xh
	ld a,(hl)
	ld l,Enemy.var33
	sub (hl)
	ld e,a
	ld a,(w1Link.xh)
	add e
	sub $05
	cp Enemy.relatedObj1+1
	jr nc,seasonsFunc_0f_65bb
	add $05
	ld (w1Link.xh),a
	jr seasonsFunc_0f_65bb

seasonsFunc_0f_65b7:
	ld l,Enemy.var31
	ld (hl),$00
seasonsFunc_0f_65bb:
	ld e,Enemy.yh
	ld a,(de)
	ld l,Enemy.var32
	ld (hl),a
	ld e,Enemy.xh
	ld a,(de)
	; var33
	inc l
	ld (hl),a
	ret

seasonsFunc_0f_65c7:
	ld a,($cfca)
	and $0e
	ld b,a
	rrca
	add b
	ld hl,seasonsTable_0f_65ed
	rst_addAToHl
	ld e,Enemy.yh
	ld a,($cfcc)
	add (hl)
	ld (de),a
	ld e,Enemy.xh
	inc hl
	ld a,($cfcd)
	add (hl)
	ld (de),a
	inc hl
	ld e,Enemy.direction
	ld a,(de)
	cp (hl)
	ret z
	ld a,(hl)
	ld (de),a
	jp enemySetAnimation

seasonsTable_0f_65ed:
	.db $48 $50 $00
	.db $41 $50 $01
	.db $41 $50 $01
	.db $41 $47 $02
	.db $48 $50 $00

seasonsFunc_0f_65fc:
	ld h,d
	ld l,Enemy.var31
	dec (hl)
	ld e,Enemy.invincibilityCounter
	jr nz,++
	ld a,(de)
	or a
	ld b,$14
	jr z,+
	ld b,$06
+
	ld (hl),b
	ld e,Enemy.var30
	ld a,(de)
	cp $08
	jr nc,+
	xor $01
	ld (de),a
+
	or $80
	ld ($cfc9),a
++
	; Enemy.var32
	inc l
	dec (hl)
	ret nz
	ld a,(de)
	or a
	ld b,$0c
	jr z,+
	ld b,$04
+
	ld (hl),b
	ld a,($cfcb)
	inc a
	cp $06
	jr c,+
	xor a
+
	or $80
	ld ($cfcb),a
	ret

seasonsFunc_0f_6637:
	; var33 - += var34 % 8
	; var34 - n/a
	; var35 - 1st value in table below, indexed by var33
	; var36 - 2nd value in table below, indexed by var33
	ld l,Enemy.var34
	ld e,Enemy.var33
	ld a,(de)
	add (hl)
	and $07
	ld (de),a
	ld hl,seasonsTable_0f_664c
	rst_addDoubleIndex
	ld e,Enemy.var35
	ldi a,(hl)
	ld (de),a
	; var36
	inc e
	ld a,(hl)
	ld (de),a
	ret

seasonsTable_0f_664c:
	.db $00 $00
	.db $f8 $10
	.db $00 $20
	.db $08 $10
	.db $00 $00
	.db $f8 $f0
	.db $00 $e0
	.db $08 $f0

seasonsFunc_0f_665c:
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.var33
	ld (hl),$ff
	ld l,Enemy.speed
	ld (hl),SPEED_80
	call seasonsFunc_0f_6680
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,seasonsTable_0f_6678
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

seasonsTable_0f_6678:
	.db $1e
	.db $3c
	.db $3c
	.db $5a
	.db $5a
	.db $5a
	.db $78
	.db $78

seasonsFunc_0f_6680:
	call getRandomNumber_noPreserveVars
	and $07
	ld b,a
	ld e,Enemy.var33
	ld a,(de)
	cp b
	jr z,seasonsFunc_0f_6680
	ld a,b
	ld (de),a
	ld hl,seasonsTable_0f_669a
	rst_addDoubleIndex
	ld e,Enemy.var35
	ldi a,(hl)
	ld (de),a
	; var36
	inc e
	ld a,(hl)
	ld (de),a
	ret

seasonsTable_0f_669a:
	.db $f8 $f0
	.db $08 $f0
	.db $f8 $fc
	.db $08 $fc
	.db $f8 $04
	.db $08 $04
	.db $f8 $10
	.db $08 $10

seasonsFunc_0f_66aa:
	ld a,($cfcc)
	ld h,a
	ld a,($cfcd)
	ld l,a
	cp c
	jr nz,+
	ld a,h
	cp b
	ret z
+
	call seasonsFunc_0f_6529
	ld e,Enemy.angle
	ld (de),a
	call seasonsFunc_0f_650d
	or d
	ret

dragonOnoxLoadaIntoVar30Andcfc9:
	ld e,Enemy.var30
	ld (de),a
	or $80
	ld ($cfc9),a
	ret

dragonOnoxLowHealthThresholdIntoC:
	call checkIsLinkedGame
	ld c,$11
	ret z
	ld c,$18
	ret

; ==============================================================================
; ENEMYID_GLEEOK
; ==============================================================================
enemyCode06:
	jr z,@normalStatus
	sub $03
	ret c
	jr nz,@normalStatus
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp z,enemyBoss_dead
	ld e,$a4
	ld a,(de)
	or a
	jp z,enemyDie_uncounted_withoutItemDrop
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	ld b,$02
	jr z,+
	ld b,$04
+
	ld a,$38
	call objectGetRelatedObject1Var
	ld a,(hl)
	or b
	ld (hl),a
	ld e,Enemy.state
	ld a,(de)
	cp $0b
	jr nz,+
	ld e,$83
	ld a,(de)
	cp $03
	jr nc,+
	ld e,$82
	ld a,(de)
	xor $01
	add $ae
	ld l,a
	ld h,(hl)
	ld l,$84
	ld a,(hl)
	cp $0b
	jr nz,+
	inc (hl)
+
	ld h,d
	ld l,$84
	ld (hl),$0e
	ld l,$a4
	set 7,(hl)
	inc l
	ld (hl),$04
	ld l,$a9
	ld (hl),$19
	ld l,$ac
	ld a,(hl)
	ld l,$89
	ld (hl),a
	ld l,$90
	ld (hl),$50
	ld l,$86
	ld (hl),$96
	xor a
	jp enemySetAnimation

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
+
	dec b
	ld a,b
	rst_jumpTable
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
	.dw @subid8
	.dw @subid9

@state0:
	ld a,b
	or a
	jp z,+
	call ecom_setSpeedAndState8AndVisible
	jp func_6c6b
+
	inc a
	ld (de),a
	ld a,$06
	ld b,$87
	call enemyBoss_initializeRoom

@state1:
	ld b,$09
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMYID_GLEEOK
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,$80
	ld e,l
	ld a,(de)
	ld (hl),a
	ld l,$b0
	ld c,h
	ld e,$08
-
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	ld a,$0a
	sub e
	ld (hl),a
	ld l,$96
	ld a,$80
	ldi (hl),a
	ld (hl),c
	ld a,h
	pop hl
	ldi (hl),a
	dec e
	jr nz,-
	jp enemyDelete

@stateStub:
	ret

@subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD
	.dw @@stateE
	.dw @@stateF
	.dw @@stateG
	
@@state8:
	ld a,(wcc93)
	or a
	ret nz
	ld h,d
	ld l,e
	inc (hl)
	ld a,$2e
	ld (wActiveMusic),a
	jp playSound
	
@@state9:
	ld e,$b8
	ld a,(de)
	bit 1,a
	jr z,@@animate
	bit 2,a
	jr z,@@animate
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$87
	ld (hl),$3c
	ld e,$b0
	ld a,(de)
	ld h,a
	ld l,$a9
	xor a
	ld (hl),a
	ld l,$a4
	ld (hl),a
	inc e
	ld a,(de)
	ld h,a
	xor a
	ld (hl),a
	ld l,$a9
	ld (hl),a
	ld hl,$ce16
	xor a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld l,$26
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld a,$67
	call playSound
	ld a,$f0
	jp playSound
	
@@stateA:
	call ecom_decCounter2
	jp nz,ecom_flickerVisibility
	ld bc,$020c
	call enemyBoss_spawnShadow
	jp nz,ecom_flickerVisibility
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$1e
	ld a,$04
	call enemySetAnimation
	
@@stateB:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	inc (hl)
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	ld a,$2e
	ld (wActiveMusic),a
	call playSound
	ld e,$84
	
@@stateC:
	call ecom_decCounter1
	jr nz,+
	ld l,e
	inc (hl)
	ld bc,$fdc0
	call objectSetSpeedZ
	jp objectSetVisible81
+
	ld a,(hl)
	cp $0a
	ret c

@@animate:
	jp enemyAnimate
	
@@stateD:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,$84
	inc (hl)
	ld l,$86
	ld (hl),$96
	ld a,$78
	call setScreenShakeCounter
	call objectSetVisible82
	ld a,$81
	jp playSound
	
@@stateE:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $87
	jr c,@@animate
	ld a,($d00f)
	rlca
	ret c
	ld hl,$cc6a
	ld a,$14
	ldi (hl),a
	ld (hl),$00
	ret
+
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$50
	call ecom_updateAngleTowardTarget
	jr @@animate
	
@@stateF:
	ld a,$01
	call ecom_getSideviewAdjacentWallsBitset
	jr nz,+
	call objectApplySpeed
	jr @@animate
+
	ld a,$28
	call setScreenShakeCounter
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$90
	ld (hl),$14
	ld l,$89
	ld a,(hl)
	xor $10
	ld (hl),a
	ld bc,$fe80
	call objectSetSpeedZ
	jr @@animate
	
@@stateG:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,@@animate
	ld l,$84
	ld (hl),$0c
	ld l,$86
	ld (hl),$3c
	jr @@animate

@subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@incStateWhenCounter1Is0
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD
	.dw @@stateE
	.dw @@stateF
	.dw @@incStateWhenCounter1Is0
	.dw @@stateH
	
@@state8:
	ld h,d
	ld l,Enemy.angle
	ld (hl),$14
@@incStateEnableCollisionsSetCounterAndSpeed:
	ld l,e
	inc (hl)
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.counter1
	ld (hl),$3c
	ld l,Enemy.speed
	ld (hl),SPEED_80
	ret
	
@@incStateWhenCounter1Is0:
	call ecom_decCounter1
	jp nz,objectApplySpeed
	ld l,e
	inc (hl)
	ret
	
@@stateA:
	ld b,$04
@@func_6905:
	ld a,$38
	call objectGetRelatedObject1Var
	ld a,(hl)
	and b
	ld c,$03
	ld l,$b8
	jr nz,+
	bit 0,(hl)
	jr nz,++
	ld e,$82
	ld a,(de)
	cp $03
	jr z,+
	ld b,h
	ld l,$b1
	ld h,(hl)
	ld l,$84
	ld a,(hl)
	cp $10
	ld h,b
	jr nc,+
	ldh a,(<hEnemyTargetX)
	cp $78
	jr nc,++
+
	ld l,$b8
	set 0,(hl)
	ld c,$00
++
	ldh a,(<hEnemyTargetY)
	cp $58
	ld b,$00
	jr c,+
	ld b,$02
	sub $70
	cp $40
	jr c,+
	call getRandomNumber
	and $01
	inc a
	ld b,a
+
	ld h,d
	ld l,$83
	ld a,c
	add b
	ld (hl),a
	ld l,$84
	inc (hl)
	inc l
	ld (hl),$00
	ret
	
@@stateB:
	ld e,Enemy.var03
	ld a,(de)
	ld e,Enemy.substate
	rst_jumpTable
	.dw @@@var03_00
	.dw @@@var03_01
	.dw @@@var03_02
	.dw @@@var03_03
	.dw @@@var03_04
	.dw @@@var03_05

@@@var03_00:
	ld a,(de)
	rst_jumpTable
	.dw @@@@substate0
	.dw @@@@substate1
	.dw @@@@substate2
	
@@@@substate0:
	ld bc,$3a60
	ld h,d
	ld l,$82
	ld a,(hl)
	cp $02
	jr z,+
	ld c,$90
+
	ld l,$8b
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	cp c
	jr nz,+
	ldh a,(<hFF8F)
	cp b
	jr z,++
+
	jp ecom_moveTowardPosition
++
	ld l,e
	inc (hl)
	ret
	
@@@@substate1:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$1e
	ld a,$01
	jp enemySetAnimation
	
@@@@substate2:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $08
	ret nz
	ld l,$8b
	ld a,(hl)
	sub $04
	ld (hl),a
	ld b,PARTID_43
	jp ecom_spawnProjectile
+
	ld l,$8b
	ld a,(hl)
	add $04
	ld (hl),a
@@@func_69bc:
	ld a,$38
	call objectGetRelatedObject1Var
	res 0,(hl)
	ld e,$82
	ld a,(de)
	sub $02
	xor $01
	add $b0
	ld l,a
	ld h,(hl)
	ld l,$84
	ld a,(hl)
	cp $0b
	jr nz,+
	inc (hl)
+
	ld h,d
	ld e,l
	inc (hl)
	ld l,$82
	ld a,(hl)
	cp $02
	ret nz
	jp @@stateC

@@@var03_01:
	ld a,(de)
	rst_jumpTable
	.dw @@@@substate0
	.dw @@@@substate1
	.dw @@@@substate2
	
@@@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$86
	ld (hl),$28
	ld a,$01
	jp enemySetAnimation
	
@@@@substate1:
	call ecom_decCounter1
	ret nz
	ld (hl),$41
	ld l,e
	inc (hl)
	ld l,$b9
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ret
	
@@@@substate2:
	call ecom_decCounter1
	jr z,@@@func_69bc
	ld a,(hl)
	and $0f
	jr z,+
	cp $08
	ret nz
	ld l,$8b
	ld a,(hl)
	add $02
	ld (hl),a
	ret
+
	ld l,$8b
	ld a,(hl)
	sub $02
	ld (hl),a
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_43
	inc l
	inc (hl)
	ld e,$86
	ld a,(de)
	and $30
	swap a
	ld bc,@@@@table_6a54
	call addDoubleIndexToBc
	ld e,$b9
	ld a,(de)
	ld e,a
	ld a,(bc)
	add e
	ld l,$cb
	ldi (hl),a
	inc l
	inc bc
	ld e,$ba
	ld a,(de)
	ld e,a
	ld a,(bc)
	add e
	ldi (hl),a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld bc,$0800
	jp objectCopyPositionWithOffset

@@@@table_6a54:
	.db $ec $00
	.db $00 $ec
	.db $00 $14
	.db $14 $00

@@@var03_02:
	ld a,(de)
	rst_jumpTable
	.dw @@@@substate0
	.dw @@@@substate1
	.dw @@@@substate2

@@@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$08
	inc l
	ld (hl),$02
	ld a,$01
	jp enemySetAnimation

@@@@substate1:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl)
	ret

@@@@substate2:
	ld b,PARTID_43
	call ecom_spawnProjectile
	ret nz
	ld l,$c2
	ld (hl),$02
	call ecom_decCounter2
	jp z,@@@func_69bc
	dec l
	ld (hl),$14
	dec l
	dec (hl)
	ret

@@@var03_03:
	ld a,(de)
	rst_jumpTable
	.dw @@@var03_00@substate0
	.dw @@@@ret
@@@@ret:
	ret

@@@var03_04:
@@@var03_05:
	call @@@func_6a9f
	call z,func_6cf6
	jp objectApplySpeed
@@@func_6a9f:
	ld h,d
	ld l,$b1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret
	
@@stateC:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$87
	ld (hl),$78
	ld l,$83
	ld a,(hl)
	or a
	jr z,+
	cp $03
	jr nz,++
+
	ld l,$b0
	xor a
	ldi (hl),a
	ld (hl),a
++
	xor a
	jp enemySetAnimation
	
@@stateD:
	call ecom_decCounter2
	jr nz,@@stateB@var03_04
	ld l,e
	ld (hl),$0a
	ret
	
@@stateE:
	ld a,(wFrameCounter)
	rrca
	jr c,+
	call ecom_decCounter1
	jr nz,+
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$28
+
	call objectApplySpeed
	jp ecom_bounceOffScreenBoundary
	
@@stateF:
	ld h,d
	ld l,$82
	ld a,(hl)
	cp $02
	ld bc,$2476
	jr z,+
	ld c,$7a
+
	ld l,$8b
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	cp c
	jr nz,+
	ldh a,(<hFF8F)
	cp b
	jr z,++
+
	jp ecom_moveTowardPosition
++
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_GLEEOK
	ld l,$90
	ld (hl),$14
	ld l,$86
	ld (hl),$3c
	ld l,$b0
	xor a
	ldi (hl),a
	ld (hl),a
	ld l,$82
	ld a,(hl)
	cp $02
	ld a,$14
	ld b,$02
	jr z,+
	ld a,$0c
	ld b,$04
+
	ld l,$89
	ld (hl),a
	ld a,$38
	call objectGetRelatedObject1Var
	ld a,(hl)
	xor b
	ld (hl),a
	ret
	
@@stateH:
	ld e,$82
	ld a,(de)
	sub $02
	xor $01
	add $30
	call objectGetRelatedObject1Var
	ld h,(hl)
	ld l,$84
	ld a,(hl)
	cp $0e
	jr nc,+
	cp $0a
	jp nz,@@stateB@var03_04
+
	ld h,d
	ld (hl),$0a
	ld l,$82
	ld a,(hl)
	cp $02
	ret nz
	jp @@stateA

@subid3:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @subid2@incStateWhenCounter1Is0
	.dw @@stateA
	.dw @subid2@stateB
	.dw @subid2@stateC
	.dw @subid2@stateD
	.dw @subid2@stateE
	.dw @subid2@stateF
	.dw @subid2@incStateWhenCounter1Is0
	.dw @subid2@stateH

@@state8:
	ld h,d
	ld l,$89
	ld (hl),$0c
	jp @subid2@incStateEnableCollisionsSetCounterAndSpeed

@@stateA:
	ld b,$02
	jp @subid2@func_6905

@subid4:
@subid5:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @@stateA

@@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	ld e,$82
	ld a,(de)
	sub $04
	add $30
	call objectGetRelatedObject1Var
	ld e,$99
	ld a,(hl)
	ld (de),a
	dec e
	ld a,$80
	ld (de),a

@@state9:
	call func_6cb2
	call func_6cbf
	ret nz
	ld e,$8b
	ld a,b
	add a
	add b
	add $24
	ld (de),a
	ld e,$82
	ld a,(de)
	cp $04
	ld b,$76
	jr z,+
	ld b,$7a
+
	ld a,c
	add a
	add c
	add b
	ld e,$8d
	ld (de),a
	ret

@@stateA:
	call func_6cb2
	ld e,$82
	ld a,(de)
	rrca
	ld bc,$0276
	jr nc,+
	ld bc,$047a
+
	ld a,$38
	call objectGetRelatedObject1Var
	ld a,(hl)
	and b
	ret nz
	ld h,d
	ld l,$84
	dec (hl)
	ld l,$a4
	set 7,(hl)
	ld l,$8b
	ld (hl),$24
	ld l,$8d
	ld (hl),c
	jp objectSetVisible82

@subid6:
@subid7:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @subid5@stateA

@@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	ld e,$82
	ld a,(de)
	sub $06
	add $30
	call objectGetRelatedObject1Var
	ld e,$99
	ld a,(hl)
	ld (de),a
	dec e
	ld a,$80
	ld (de),a

@@state9:
	call func_6cb2
	call func_6cbf
	ret nz
	ld e,$8b
	ld a,b
	add a
	add $24
	ld (de),a
	ld e,$82
	ld a,(de)
	cp $06
	ld b,$76
	jr z,+
	ld b,$7a
+
	ld a,c
	add a
	add b
	ld e,$8d
	ld (de),a
	ret

@subid8:
@subid9:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @subid5@stateA
	
@@state8:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_PODOBOO
	ld e,$82
	ld a,(de)
	sub $08
	add $30
	call objectGetRelatedObject1Var
	ld e,$99
	ld a,(hl)
	ld (de),a
	dec e
	ld a,$80
	ld (de),a
	
@@state9:
	call func_6cb2
	call func_6cbf
	ret nz
	ld e,$8b
	ld a,b
	add $24
	ld (de),a
	ld e,$82
	ld a,(de)
	cp $08
	ld a,$76
	jr z,+
	ld a,$7a
+
	add c
	ld e,$8d
	ld (de),a
	ret

func_6c6b:
	dec b
	jr z,func_6c8a
	ld c,$76
	ld l,$82
	bit 0,(hl)
	jr z,+
	ld c,$7a
+
	ld l,$8b
	ld (hl),$24
	ld l,$8d
	ld (hl),c
	ld l,$82
	ld a,(hl)
	cp $04
	ret c
	ld a,$02
	jp enemySetAnimation
	
func_6c8a:
	ld l,$a4
	res 7,(hl)
	ld l,$a6
	ld (hl),$0c
	inc l
	ld (hl),$0e
	ld l,$8b
	ld (hl),$20
	ld l,$8d
	ld (hl),$78
	ld hl,$ce16
	ld a,$0f
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld l,$26
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld a,$03
	call enemySetAnimation
	jp objectSetVisible83

func_6cb2:
	ld a,$01
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $06
	ret z
	pop hl
	jp enemyDelete

func_6cbf:
	ld l,$84
	ld a,(hl)
	cp $0e
	jr nz,func_6cd8
	ld h,d
	inc (hl)
	ld l,$a4
	res 7,(hl)
	ld e,$9a
	ld a,(de)
	rlca
	ld b,INTERACID_KILLENEMYPUFF
	call c,objectCreateInteractionWithSubid00
	jp objectSetInvisible
	
func_6cd8:
	ld l,$8b
	ldi a,(hl)
	sub $24
	sra a
	sra a
	ld b,a
	inc l
	ld e,$82
	ld a,(de)
	rrca
	ld c,$76
	jr nc,+
	ld c,$7a
+
	ld a,(hl)
	sub c
	sra a
	sra a
	ld c,a
	xor a
	ret
	
func_6cf6:
	ld e,$b0
	ld a,(de)
	and $1f
	jr nz,+
	call getRandomNumber
	and $20
	ld (de),a
+
	ld a,(de)
	ld hl,table_6d14
	rst_addAToHl
	ld e,Enemy.angle
	ld a,(hl)
	ld (de),a
	ld h,d
	ld l,Enemy.var30
	inc (hl)
	inc l
	ld (hl),$06
	ret

table_6d14:
	.db $15 $16 $17 $17 $19 $19 $1a $1b
	.db $05 $06 $07 $07 $09 $09 $0a $0b
	.db $0b $0a $09 $09 $07 $07 $06 $05
	.db $1b $1a $19 $19 $17 $17 $16 $15
	.db $08 $08 $09 $09 $0a $0a $0b $0c
	.db $14 $15 $16 $16 $17 $17 $18 $18
	.db $18 $18 $19 $19 $1a $1a $1b $1c
	.db $04 $05 $06 $06 $07 $07 $08 $08

; ==============================================================================
; ENEMYID_KING_MOBLIN
; ==============================================================================
enemyCode07:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	; just hit
	ret nz
	; knockback
	ld e,$aa
	ld a,(de)
	cp $97
	jr nz,@normalStatus
	ld e,$a9
	ld a,(de)
	or a
	call nz,func_6f20
	ld a,$63
	jp playSound
@dead:
	ld h,d
	ld l,$84
	ld (hl),$0e
	inc l
	ld (hl),$00
	ld l,$a4
	res 7,(hl)
@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE

@state0:
	ld a,$07
	ld ($cc1c),a
	ld a,$8c
	call loadPaletteHeader
	ld a,$14
	call ecom_setSpeedAndState8
	ld e,$88
	ld a,$02
	ld (de),a
	call enemySetAnimation
	jp objectSetVisible83

@stateStub:
	ret

@state8:
	ld hl,$cfc0
	bit 0,(hl)
	jp z,enemyAnimate
	ld (hl),$00
	ld h,d
	ld l,e
	inc (hl)
	ld l,$90
	ld (hl),$14

@state9:
	call getRandomNumber_noPreserveVars
	and $07
	cp $07
	jr z,@state9
	ld h,d
	ld l,$b0
	cp (hl)
	jr z,@state9
	ld (hl),a
	ld hl,@table_6e03
	rst_addAToHl
	ld e,$8d
	ld a,(de)
	cp (hl)
	jr z,@state9
	ld e,$b1
	ld a,(hl)
	ld (de),a
	ld h,d
	ld l,$84
	inc (hl)
	ld l,$8d
	ld a,(hl)
	ld l,$b1
	cp (hl)
	ld a,$03
	ld b,$18
	jr nc,+
	ld a,$01
	ld b,$08
+
	ld l,$88
	ldi (hl),a
	ld (hl),b
	jp enemySetAnimation

@table_6e03:
	.db $50
	.db $20
	.db $30
	.db $40
	.db $60
	.db $70
	.db $80

@stateA:
	call objectApplySpeed
	ld h,d
	ld l,$8d
	ld a,(hl)
	ld l,$b1
	sub (hl)
	inc a
	cp $03
	jr nc,@animate
	ld l,$84
	inc (hl)
	call func_6f2e
	ld e,$88
	xor a
	ld (de),a
	jp enemySetAnimation

@stateB:
	call ecom_decCounter1
	jr nz,@animate
	inc (hl)
	ld b,PARTID_KING_MOBLIN_BOMB
	call ecom_spawnProjectile
	ret nz
	ld e,$84
	ld a,$0c
	ld (de),a
	ld e,$88
	ld a,$04
	ld (de),a
	jp enemySetAnimation

@stateC:
	call func_6f40
	ret nc
	inc a
	ret nz
	ld e,$84
	ld a,$0d
	ld (de),a
	call func_6f2e
	ld e,$88
	ld a,$02
	ld (de),a
	jp enemySetAnimation

@stateD:
	call ecom_decCounter1
	jr nz,@animate
	ld l,e
	ld (hl),$09
@animate:
	jp enemyAnimate

@stateE:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substateStub
	
@substate0:
	call checkLinkCollisionsEnabled
	ret nc
	ld h,d
	ld l,$85
	inc (hl)
	ld l,$87
	ld (hl),$3c
	ld l,$a9
	ld (hl),$01
	ld a,$01
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $3f
	jr nz,+
	ld l,$c4
	ld a,(hl)
	dec a
	jr nz,+
	ld (hl),$06
	ld l,$cb
	ld e,$8b
	ld a,(de)
	sub $10
	ld (hl),a
	ld e,$b3
	ld a,$01
	ld (de),a
	ld ($cc02),a
	ld ($cca4),a
+
	ld a,$05
	jp enemySetAnimation
	
@substate1:
	call ecom_decCounter2
	ret nz
	ld l,$b3
	bit 0,(hl)
	jr z,+
	ld l,e
	inc (hl)
	ret
+
	ld l,$a4
	set 7,(hl)
	ld l,$84
	ld (hl),$09
	ld l,$b4
	bit 0,(hl)
	ret nz
	inc (hl)
	; You can't beat me this way
	ld bc,TX_3f06
	jp showText
	
@substate2:
	ld a,$04
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $05
	ret nz
	ld h,d
	ld l,$85
	inc (hl)
	inc l
	ld (hl),$01
	inc l
	ld (hl),$06
	ret
	
@substate3:
	call ecom_decCounter1
	ret nz
	inc (hl)
	inc l
	ld a,(hl)
	dec a
	ld hl,@table_6f13
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXPLOSION
	ld l,$4b
	ld (hl),b
	ld l,$4d
	ld (hl),c
	ld a,c
	and $f0
	swap a
	ld c,a
	ld a,$ac
	call setTile
	call ecom_decCounter2
	ld l,$86
	ld (hl),$0f
	ret nz
	ld l,$85
	inc (hl)
	ld a,$01
	ld ($cfc0),a
	ret

@table_6f13:
	.db $08 $78
	.db $0c $38
	.db $0a $60
	.db $08 $48
	.db $04 $24
	.db $06 $5a

@substateStub:
	ret

func_6f20:
	dec a
	ld hl,table_6f20
	rst_addAToHl
	ld e,$90
	ld a,(hl)
	ld (de),a
	ret

table_6f20:
	.db SPEED_200
	.db SPEED_180
	.db SPEED_100
	.db SPEED_0c0
	
func_6f2e:
	ld e,$a9
	ld a,(de)
	dec a
	ld hl,table_6f3b
	rst_addAToHl
	ld e,$86
	ld a,(hl)
	ld (de),a
	ret

table_6f3b:
	.db $14
	.db $1e
	.db $28
	.db $32
	.db $3c
	
func_6f40:
	call enemyAnimate
	ld e,$a1
	ld a,(de)
	rlca
	ret c
	cp $06
	jr nz,+
	ld a,$80
	ld (de),a
	ld a,$04
	call objectGetRelatedObject2Var
	ld (hl),$03
	ld l,$e4
	set 7,(hl)
	ret
+
	ld e,$a1
	ld a,(de)
	ld hl,table_6f6f
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	ld a,$0b
	call objectGetRelatedObject2Var
	call objectCopyPositionWithOffset
	or d
	ret

table_6f6f:
	.db $08 $00
	.db $f6 $00
	.db $ee $00
