; ==================================================================================================
; ENEMY_DRAGON_ONOX
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
; ==================================================================================================
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
	ld a,ENEMY_DRAGON_ONOX
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
	ld b,ENEMY_DRAGON_ONOX
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
	ld (hl),PART_33
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
	ld (hl),PART_4a
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
