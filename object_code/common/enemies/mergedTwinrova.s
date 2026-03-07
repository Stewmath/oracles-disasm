; ==================================================================================================
; ENEMY_MERGED_TWINROVA
;
; Variables:
;   subid: 0 or 1 for lava or ice
;   var03: 0 or 1 for two different attacks
;   var30: Counter until room will be swapped
;   var31: ?
;   var32: Value from 0-7, determines what attack to use in lava phase
;   var33: Minimum # frames of movement before attacking?
;   var34: Twinrova boss health (only reduced by seeds when vulnerable)
;   var36: Target position index (multiple of 2)
;   var37/var38: Target position to move to?
;   var39: Room swapping is disabled while this is nonzero.
;   var3a: Counter until twinrova's vulnerability ends and room will be swapped
;   var3b: # frames to wait in place before choosing new target position
; ==================================================================================================
enemyCode01:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@collisionOccurred

	; Dead
	ld e,Enemy.var34
	ld a,(de)
	or a
	jp z,mergedTwinrova_deathCutscene

	ld h,d
	ld l,Enemy.var3a
	ld (hl),120

	ld l,Enemy.health
	ld (hl),20

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.oamFlagsBackup
	xor a
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.collisionType
.ifdef ROM_AGES
	ld (hl),$ff
.else
	ld (hl),$87
.endif

	ld a,$09
	jp enemySetAnimation

@collisionOccurred:
	ld e,Enemy.var3a
	ld a,(de)
	or a
	jr z,@normalStatus

	; Check that the collision was with a seed.
	ld e,Enemy.var2a
	ld a,(de)
	res 7,a
	sub ITEMCOLLISION_MYSTERY_SEED
	cp ITEMCOLLISION_GALE_SEED - ITEMCOLLISION_MYSTERY_SEED + 1
	jr nc,@normalStatus

	ld a,SND_BOSS_DAMAGE
	call playSound

	ld h,d
	ld l,Enemy.invincibilityCounter
	ld (hl),45

	ld l,Enemy.var34
	dec (hl)
	jr nz,@normalStatus

	; Dead?
	ld l,Enemy.health
	ld (hl),$00

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.substate
	ld (hl),$00
	inc l
	ld (hl),216 ; [counter1]
	ld a,SNDCTRL_STOPMUSIC
	jp playSound

@normalStatus:
	call mergedTwinrova_checkTimeToSwapRoomFromDamage
	call mergedTwinrova_checkTimeToSwapRoomFromTimer
	call ecom_getSubidAndCpStateTo08
	cp $0c
	jr nc,@stateCOrHigher
	rst_jumpTable
	.dw mergedTwinrova_state_uninitialized
	.dw mergedTwinrova_state_stub
	.dw mergedTwinrova_state_stub
	.dw mergedTwinrova_state_stub
	.dw mergedTwinrova_state_stub
	.dw mergedTwinrova_state_stub
	.dw mergedTwinrova_state_stub
	.dw mergedTwinrova_state_stub
	.dw mergedTwinrova_state8
	.dw mergedTwinrova_state9
	.dw mergedTwinrova_stateA
	.dw mergedTwinrova_stateB

@stateCOrHigher:
	ld a,b
	rst_jumpTable
	.dw mergedTwinrova_lavaRoom
	.dw mergedTwinrova_iceRoom


; Fight just starting
mergedTwinrova_state_uninitialized:
	ld a,ENEMY_MERGED_TWINROVA
	ld (wEnemyIDToLoadExtraGfx),a

	ldh a,(<hActiveObject)
	ld d,a
	ld bc,$0012
	call enemyBoss_spawnShadow
	ret nz

	ld a,SPEED_180
	call ecom_setSpeedAndState8

	ld l,Enemy.counter1
	ld (hl),$08
	ld l,Enemy.var30
	ld (hl),210
	ld l,Enemy.var34
	ld (hl),$05
	ld l,Enemy.zh
	ld (hl),$ff

	call objectSetVisible83
	ld bc,TX_2f0b
	jp showText


mergedTwinrova_state_stub:
	ret


; Delay before moving to centre?
mergedTwinrova_state8:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionType
	set 7,(hl)

	call getRandomNumber_noPreserveVars
	and $01
	ld e,Enemy.subid
	ld (de),a
	ld b,a

	xor $01
	inc a
	ld e,Enemy.oamFlagsBackup
	ld (de),a
	inc e
	ld (de),a

	ld a,b
	inc a
	call enemySetAnimation

	xor a
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a

	ld a,MUS_TWINROVA
	ld (wActiveMusic),a
	jp playSound


; Moving toward centre of screen prior to swapping room
mergedTwinrova_state9:
	ld bc,$4878
	ld h,d
	ld l,Enemy.yh
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	call mergedTwinrova_checkPositionsCloseEnough
	jp nc,ecom_moveTowardPosition

	; Reached centre of screen.
	ld l,e
	inc (hl) ; [state] = $0a
	inc l
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),60 ; [counter1]

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_BEAMOS

	ld l,Enemy.var39
	ld (hl),$01
	ld l,Enemy.var3b
	ld (hl),$00
	ret


; In the process of converting the room to lava or ice
mergedTwinrova_stateA:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call ecom_decCounter1
	jr z,++

	; Flicker palettes?
	ld l,Enemy.oamFlagsBackup
	ld a,(hl)
	xor $03
	ldi (hl),a
	ld (hl),a
	ret
++
	ld l,e
	inc (hl) ; [substate] = 1
	inc l
	ld (hl),30 ; [counter1]

	; Swap subid
	ld l,Enemy.subid
	ld a,(hl)
	inc a
	and $01
	ld b,a
	ld (hl),a

	xor $01
	inc a
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	ld a,b
	inc a
	jp enemySetAnimation

@substate1:
	call ecom_decCounter1
	jr z,++

	; Flicker palettes?
	ld l,Enemy.oamFlagsBackup
	ld a,(hl)
	xor $03
	ldi (hl),a
	ld (hl),a
	ret
++
	ld l,e
	inc (hl) ; [substate] = 2

	ld l,Enemy.subid
	ld a,(hl)
	xor $01
	inc a
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a

	ld a,$01
	ld (wDisableLinkCollisionsAndMenu),a

	call fastFadeoutToWhite
	ld a,SND_ENDLESS
	jp playSound

@substate2:
	ld a,$03
	ld (de),a ; [substate]

	call disableLcd

	ld e,Enemy.subid
	ld a,(de)
	inc a
	ld (wTwinrovaTileReplacementMode),a

	call func_131f
	ld a,$02
	call loadGfxRegisterStateIndex
	ldh a,(<hActiveObject)
	ld d,a
	ret

@substate3:
	ld a,$04
	ld (de),a
	jp fadeinFromWhiteWithDelay

@substate4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld h,d
	ld l,Enemy.state
	inc (hl) ; [state] = $0b

	ld l,Enemy.collisionType
	ld (hl),$80|ENEMY_MERGED_TWINROVA

	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.var30
	ld (hl),210

	ld l,Enemy.var39
	xor a
	ld (hl),a
	ld (wDisableLinkCollisionsAndMenu),a

	ld a,SNDCTRL_STOPSFX
	jp playSound


; Delay before attacking
mergedTwinrova_stateB:
	call ecom_decCounter1
	ret nz
	ld l,e
	ld (hl),$0c ; [state]
	ret


mergedTwinrova_lavaRoom:
	ld a,(de)
	sub $0c
	rst_jumpTable
	.dw mergedTwinrova_lavaRoom_stateC
	.dw mergedTwinrova_lavaRoom_stateD
	.dw mergedTwinrova_lavaRoom_stateE


mergedTwinrova_lavaRoom_stateC:
	call mergedTwinrova_decVar3bIfNonzero
	ret nz

	ld l,Enemy.speed
	ld (hl),SPEED_140


mergedTwinrova_chooseTargetPosition:
	ld l,e
	inc (hl) ; [state]

	; Choose a target position distinct from the current position
@chooseTargetPositionIndex:
	call getRandomNumber
	and $0e
	ld l,Enemy.var36
	cp (hl)
	jr z,@chooseTargetPositionIndex

	ld (hl),a

	ld bc,@targetPositions
	call addAToBc
	ld e,Enemy.var37
	ld a,(bc)
	ld (de),a
	inc e
	inc bc
	ld a,(bc)
	ld (de),a

	ld a,SND_CIRCLING
	jp playSound

@targetPositions: ; One of these positions in chosen randomly.
	.db $30 $40
	.db $58 $30
	.db $48 $40
	.db $30 $78
	.db $58 $78
	.db $30 $b0
	.db $58 $c0
	.db $78 $b0


; Moving toward target position
mergedTwinrova_lavaRoom_stateD:
	ld h,d
	ld l,Enemy.var33
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld l,Enemy.var37
	call ecom_readPositionVars
	call mergedTwinrova_checkPositionsCloseEnough
	jp nc,ecom_moveTowardPosition

	; Reached target position.

	; var33 must have reached 0 for twinrova to attack, otherwise she'll move again.
	ld l,Enemy.var33
	ld a,(hl)
	or a
	ld l,Enemy.state
	jr z,@attack

	dec (hl) ; [state] = $0c
	ld l,Enemy.var3b
	ld (hl),30
	ret

@attack:
	inc (hl) ; [state] = $0e
	inc l
	ld (hl),$00 ; [substate]

	ld l,Enemy.var39
	ld (hl),$01

	ld l,Enemy.var32
	inc (hl)
	ld a,(hl)
	and $07
	ld (hl),a

	ld hl,@var03Vals
	rst_addAToHl
	ld e,Enemy.var03
	ld a,(hl)
	ld (de),a
	ret

@var03Vals:
	.db $00 $00 $01 $00 $01 $01 $00 $01


; Doing one of two attacks, depending on var03
mergedTwinrova_lavaRoom_stateE:
	ld e,Enemy.var03
	ld a,(de)
	or a
	jp nz,@keeseAttack

	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @flameAttack_substate0
	.dw @flameAttack_substate1
	.dw @flameAttack_substate2

@flameAttack_substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate] = 1
	inc l
	ld (hl),30 ; [counter1]

	ld a,$03
	call enemySetAnimation

	call objectGetAngleTowardEnemyTarget
	ld b,a

	call getFreePartSlot
	ret nz
	ld (hl),PART_TWINROVA_FLAME
	ld l,Part.angle
	ld (hl),b
	ld bc,$1000
	jp objectCopyPositionWithOffset

@flameAttack_substate1:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld (hl),16
	ld l,e
	inc (hl) ; [substate] = 2
	ld a,$04
	jp enemySetAnimation

@flameAttack_substate2:
	call ecom_decCounter1
	ret nz

@doneAttack:
	ld l,Enemy.state
	ld (hl),$0c
	ld l,Enemy.var3b
	ld (hl),30
	ld l,Enemy.var33
	ld (hl),150
	ld l,Enemy.var39
	ld (hl),$00
	ld a,$01
	jp enemySetAnimation


@keeseAttack:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @keeseAttack_substate0
	.dw @keeseAttack_substate1
	.dw @keeseAttack_substate2

@keeseAttack_substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate] = 1
	inc l
	ld (hl),$0a ; [counter1]
	inc l
	ld (hl),$05 ; [counter2]
	ld a,$07
	jp enemySetAnimation

@keeseAttack_substate1:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld (hl),20 ; [counter1]
	inc l
	dec (hl) ; [counter2]
	jr z,@doneSpawningKeese

	ld a,(hl)
	dec a
	ld hl,@keesePositions
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)

	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMY_TWINROVA_BAT
	ld l,Enemy.relatedObj1+1
	ld (hl),d
	dec l
	ld (hl),Enemy.start

	jp objectCopyPositionWithOffset

@doneSpawningKeese:
	dec l
	ld (hl),180 ; [counter1]
	ld l,e
	inc (hl) ; [substate] = 2
	ld a,$03
	jp enemySetAnimation

@keesePositions:
	.db $00 $20
	.db $e0 $00
	.db $00 $e0
	.db $20 $00

@keeseAttack_substate2:
	call ecom_decCounter1
	ret nz
	jr @doneAttack


mergedTwinrova_iceRoom:
	ld a,(de)
	sub $0c
	rst_jumpTable
	.dw mergedTwinrova_iceRoom_stateC
	.dw mergedTwinrova_iceRoom_stateD
	.dw mergedTwinrova_iceRoom_stateE
	.dw mergedTwinrova_iceRoom_stateF
	.dw mergedTwinrova_iceRoom_state10


; About to start spawning ice projectiles
mergedTwinrova_iceRoom_stateC:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0d
	inc l
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),10 ; [counter1]

	ld l,Enemy.var39
	ld (hl),$01

	call getRandomNumber_noPreserveVars
	and $01
	ld e,Enemy.var35
	ld (de),a

	ld e,Enemy.var34
	ld a,(de)
	cp $02
	ld a,$03
	jr nc,+
	inc a
+
	ld e,Enemy.counter2
	ld (de),a
	ld a,$05
	jp enemySetAnimation


; Spawning ice projectiles (ENEMY_TWINROVA_ICE)
mergedTwinrova_iceRoom_stateD:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld (hl),30
	inc l
	dec (hl) ; [counter2]
	jr z,@doneSpawningProjectiles

	; Determine position & angle for projectile
	ld b,(hl)
	dec b
	ld l,Enemy.var34
	ld a,(hl)
	cp $02
	ld hl,@positionData1
	jr nc,+
	ld hl,@positionData0
+
	ld a,b
	add a
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ld e,Enemy.var35
	ld a,(de)
	or a
	jr z,+
	inc hl
+
	ld e,(hl)

	; Spawn ice projectile
	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMY_TWINROVA_ICE
	ld l,Enemy.angle
	ld (hl),e
	ld l,Enemy.relatedObj1
	ld (hl),Enemy.start
	inc l
	ld (hl),d

	jp objectCopyPositionWithOffset

@doneSpawningProjectiles:
	ld l,e
	inc (hl) ; [substate] = 1
	ld l,Enemy.counter1
	ld (hl),120
	ld l,Enemy.var39
	ld (hl),$00
	ld a,$06
	jp enemySetAnimation

@positionData0:
	.db $10 $f0 $12 $15
	.db $10 $10 $0a $0c
	.db $18 $00 $0e $12
@positionData1:
	.db $10 $e8 $16 $0d
	.db $10 $18 $0b $11

@substate1:
	call ecom_decCounter1
	ret nz
	ld (hl),90
	ld l,Enemy.state
	inc (hl) ; [state] = $0e
	ld a,$02
	jp enemySetAnimation


; About to move to a position to do a snowball attack.
mergedTwinrova_iceRoom_stateE:
	call mergedTwinrova_decVar3bIfNonzero
	ret nz
	ld l,Enemy.speed
	ld (hl),SPEED_180
	jp mergedTwinrova_chooseTargetPosition


; Moving to position prior to snowball attack
mergedTwinrova_iceRoom_stateF:
	ld h,d
	ld l,Enemy.var37
	call ecom_readPositionVars
	call mergedTwinrova_checkPositionsCloseEnough
	jp nc,ecom_moveTowardPosition

	; Reached target position. Begin charging attack.

	ld l,Enemy.state
	inc (hl) ; [state] = $10
	inc l
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),30 ; [counter1]

	ld l,Enemy.var39
	ld (hl),$01

	ld a,$08
	call enemySetAnimation

	call getFreePartSlot
	ret nz
	ld (hl),PART_TWINROVA_SNOWBALL
	ld bc,$e800
	jp objectCopyPositionWithOffset


; Doing snowball attack?
mergedTwinrova_iceRoom_state10:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld (hl),60

	ld l,e
	inc (hl) ; [substate] = 1

	ld a,$06
	jp enemySetAnimation

@substate1:
	call ecom_decCounter1
	ret nz

	ld l,Enemy.state
	ld (hl),$0e
	ld l,Enemy.counter1
	ld (hl),90
	ld l,Enemy.var3b
	ld (hl),30
	ld l,Enemy.var39
	ld (hl),$00
	ld a,$02
	jp enemySetAnimation

;;
mergedTwinrova_checkTimeToSwapRoomFromTimer:
	ld a,(wFrameCounter)
	and $03
	ret nz

	ld h,d
	ld l,Enemy.var30
	dec (hl)
	ret nz

	inc (hl)
	ld e,Enemy.var39
	ld a,(de)
	or a
	ret nz

	ld (hl),210 ; [var39]
	ld l,Enemy.counter1
	ld (hl),30
	ld l,Enemy.state
	ld (hl),$09
	ret


;;
; @param	a
; @param	bc
; @param	hFF8F
; @param[out]	cflag	c if within 2 pixels of position
mergedTwinrova_checkPositionsCloseEnough:
	sub c
	add $02
	cp $05
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	ret

;;
; Checks whether to begin changing the room. If so, it sets the state to 9 and returns
; from caller (pops return address).
mergedTwinrova_checkTimeToSwapRoomFromDamage:
	ld h,d
	ld l,Enemy.var3a
	ld a,(hl)
	or a
	ret z

	dec (hl)
	jr z,++
	pop hl
	ret
++
	ld l,Enemy.state
	ld (hl),$09

	ld e,Enemy.subid
	ld a,(de)
	ld b,a
	xor $01
	inc a
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	ld a,b
	inc a
	jp enemySetAnimation


mergedTwinrova_deathCutscene:
	ld e,Enemy.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,(wDisabledObjects)
	or a
	jr nz,++

	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	inc a
	ld (wDisableLinkCollisionsAndMenu),a
	ld (wDisabledObjects),a
	call clearAllParentItems
++
	call ecom_flickerVisibility
	call ecom_decCounter1
	jr z,@doneExplosions

	ld a,(hl) ; [counter1]
	cp 97
	ret nc
	and $0f
	jp z,@createExplosion
	ret

@doneExplosions:
	ld (hl),25 ; [counter1]
	ld l,Enemy.substate
	inc (hl)

@substate1:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld l,e
	inc (hl) ; [statae2] = 2

	ld l,Enemy.oamFlagsBackup
	xor a
	ldi (hl),a
	ld (hl),a
	call enemySetAnimation

	ld bc,TX_2f0c
	jp showText

@substate2:
	ld a,$03
	ld (de),a ; [substate] = 3

	ld a,CUTSCENE_TWINROVA_SACRIFICE
	ld (wCutsceneTrigger),a

	ld a,MUS_ROOM_OF_RITES
	jp playSound

@substate3:
	ret


@createExplosion:
	ld a,(hl)
	swap a
	dec a
	ld hl,@explosionPositions
	rst_addDoubleIndex

	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld b,a
	ld e,Enemy.xh
	inc hl
	ld a,(de)
	add (hl)
	ld c,a

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_EXPLOSION
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ret

@explosionPositions:
	.db $f8 $f6
	.db $00 $06
	.db $02 $fe
	.db $06 $04
	.db $fc $05
	.db $fa $fc

;;
mergedTwinrova_decVar3bIfNonzero:
	ld h,d
	ld l,Enemy.var3b
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret
