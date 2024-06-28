; ==============================================================================
; ENEMYID_MERGED_TWINROVA
;
; Variables:
;   subid: 0 or 1 for lava or ice
;   var03: 0 or 1 for two different attacks
;   var30: Counter until room will be swapped
;   var31: ?
;   var32: Value from 0-7, determines what attack to use in lava phase
;   var33: Minimum # frames of movement before attacking?
;   var34: Nonzero if dead?
;   var36: Target position index (multiple of 2)
;   var37/var38: Target position to move to?
;   var39: Room swapping is disabled while this is nonzero.
;   var3a: Counter until twinrova's vulnerability ends and room will be swapped
;   var3b: # frames to wait in place before choosing new target position
; ==============================================================================
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
	ld a,ENEMYID_MERGED_TWINROVA
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
	ld (hl),$80|ENEMYID_BEAMOS

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
	ld (hl),$80|ENEMYID_MERGED_TWINROVA

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
	ld (hl),PARTID_TWINROVA_FLAME
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
	ld (hl),ENEMYID_TWINROVA_BAT
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


; Spawning ice projectiles (ENEMYID_TWINROVA_ICE)
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
	ld (hl),ENEMYID_TWINROVA_ICE
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
	ld (hl),PARTID_TWINROVA_SNOWBALL
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
	ld (hl),INTERACID_EXPLOSION
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


; ==============================================================================
; ENEMYID_TWINROVA
;
; Variables:
;   var03: If bit 0 is unset, this acts as the "spawner" for the other twinrova object.
;          Bit 7: ?
;   relatedObj1: Reference to other twinrova object
;   relatedObj2: Reference to INTERACID_PUFF
;   var30: Anglular velocity (amount to add to angle)
;   var31: Counter used for z-position bobbing
;   var32: Bit 0: Nonzero while projectile is being fired?
;          Bit 1: Signal in merging cutscene
;          Bit 2: Signal to fire a projectile
;          Bit 3: Enable/disable z-position bobbing
;          Bit 4: Signal in merging cutscene
;          Bit 5: ?
;          Bit 6: Signal to do "death cutscene" if health is 0. Set by
;                 PARTID_RED_TWINROVA_PROJECTILE or PARTID_BLUE_TWINROVA_PROJECTILE.
;          Bit 7: If set, updates draw layer relative to Link
;   var33: Movement pattern (0-3)
;   var34: Position index (within the movement pattern)
;   var35/var36: Target position?
;   var37: Counter to update facing direction when it reaches 0?
;   var38: Index in "attack pattern"? (0-7)
;   var39: Some kind of counter?
; ==============================================================================
enemyCode03:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus

	; Dead
	ld h,d
	ld l,Enemy.var32
	bit 6,(hl)
	jr z,@normalStatus

	ld l,Enemy.health
	ld (hl),$7f
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.state
	ld (hl),$0d

	; Set variables in relatedObj1 (other twinrova)
	ld a,Object.health
	call objectGetRelatedObject1Var
	ld (hl),$7f
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.state
	ld (hl),$0f

	ld a,SNDCTRL_STOPMUSIC
	call playSound

@normalStatus:
	call twinrova_updateZPosition
	call @runState
	ld e,Enemy.var32
	ld a,(de)
	bit 7,a
	jp nz,objectSetPriorityRelativeToLink_withTerrainEffects
	ret

@runState:
	call twinrova_checkFireProjectile
	call ecom_getSubidAndCpStateTo08
	jr nc,@state8OrHigher
	rst_jumpTable
	.dw twinrova_state_uninitialized
	.dw twinrova_state_spawner
	.dw twinrova_state_stub
	.dw twinrova_state_stub
	.dw twinrova_state_stub
	.dw twinrova_state_stub
	.dw twinrova_state_stub
	.dw twinrova_state_stub

@state8OrHigher:
	ld a,b
	rst_jumpTable
	.dw twinrova_subid0
	.dw twinrova_subid1


twinrova_state_uninitialized:
	ld a,ENEMYID_TWINROVA
	ld (wEnemyIDToLoadExtraGfx),a
	ld a,$01
	ld (wLoadedTreeGfxIndex),a

	ld h,d
	ld l,Enemy.var03
	bit 0,(hl)
	ld a,SPEED_100
	jp nz,twinrova_initialize

	ld l,e
	inc (hl) ; [state] = 1

	xor a
	ld (w1Link.direction),a
	inc a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a


twinrova_state_spawner:
	ld b,ENEMYID_TWINROVA
	call ecom_spawnUncountedEnemyWithSubid01
	ret nz

	; [child.var03] = [this.var03] + 1
	inc l
	ld e,l
	ld a,(de)
	inc a
	ld (hl),a

	; [this.relatedObj1] = child
	; [child.relatedObj1] = this
	ld l,Enemy.relatedObj1
	ld e,l
	ld a,Enemy.start
	ld (de),a
	ldi (hl),a
	inc e
	ld a,h
	ld (de),a
	ld (hl),d

	ld a,h
	cp d
	ld a,SPEED_100
	jp nc,twinrova_initialize

	; Swap the twinrova objects; subid 0 must come before subid 1?
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a

	ld l,Enemy.subid
	dec (hl) ; [child.subid] = 0
	ld h,d
	inc (hl) ; [this.subid] = 1
	inc l
	inc (hl) ; [this.var03] = 1
	ld l,Enemy.state
	dec (hl) ; [this.state] = 0
	ret


twinrova_state_stub:
	ret


twinrova_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw twinrova_state8
	.dw twinrova_state9
	.dw twinrova_subid0_stateA
	.dw twinrova_subid0_stateB
	.dw twinrova_subid0_stateC
	.dw twinrova_stateD
	.dw twinrova_stateE
	.dw twinrova_stateF
	.dw twinrova_state10


; Cutscene before fight
twinrova_state8:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 9

	ld l,Enemy.var32
	set 3,(hl)
	set 7,(hl)

	ld l,Enemy.counter1
	ld (hl),106

	ld l,Enemy.yh
	ld (hl),$08

	; Set initial x-position, oam flags, angle, and var30 based on subid
	ld l,Enemy.subid
	ld a,(hl)
	add a
	ld hl,@data
	rst_addDoubleIndex

	ld e,Enemy.xh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.oamFlagsBackup
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a

	ld e,Enemy.angle
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

	; Subid 0 only: show text
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld bc,TX_2f04
	call z,showText

	call getRandomNumber_noPreserveVars
	ld e,Enemy.var31
	ld (de),a
	jp twinrova_updateAnimationFromAngle

; Data per subid: x-position, oam flags, angle, var30
@data:
	.db $c0 $02 $11 $01 ; Subid 0
	.db $30 $01 $0f $ff ; Subid 1


; Moving down the screen in the pre-fight cutscene
twinrova_state9:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call ecom_decCounter1
	jr nz,@applySpeed

	ld (hl),$08 ; [counter1]
	inc l
	ld (hl),$12 ; [counter2]
	ld l,e
	inc (hl) ; [substate] = 1
	jr @animate

@substate1:
	call ecom_decCounter1
	jr nz,@applySpeed

	ld (hl),$08 ; [counter1]
	inc l
	dec (hl) ; [counter2]
	jr nz,@updateAngle

	ld l,e
	inc (hl) ; [substate] = 3
	inc l
	ld (hl),30 ; [counter1]

	call ecom_updateAngleTowardTarget
	call twinrova_calculateAnimationFromAngle
	ld (hl),a
	jp enemySetAnimation

@updateAngle:
	ld e,Enemy.angle
	ld l,Enemy.var30
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
	call twinrova_updateAnimationFromAngle

@applySpeed:
	call objectApplySpeed
@animate:
	jp enemyAnimate

@substate2:
	call ecom_decCounter1
	jr nz,@animate

	ld l,e
	inc (hl) ; [substate] = 3

	ld e,Enemy.subid
	ld a,(de)
	or a
	ret nz
	ld bc,TX_2f05
	jp showText

@substate3:
	ldbc INTERACID_PUFF,$02
	call objectCreateInteraction
	ret nz
	ld a,h
	ld h,d
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Interaction.start

	ld l,Enemy.substate
	inc (hl) ; [substate] = 4

	ld l,Enemy.var32
	res 7,(hl)
	jp objectSetInvisible

@substate4:
	; Wait for puff to finish
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	ld h,d
	ld l,Enemy.var32
	set 7,(hl)
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,CUTSCENE_FLAMES_FLICKERING
	ld (wCutsceneTrigger),a

	call ecom_updateAngleTowardTarget
	call twinrova_calculateAnimationFromAngle
	add $04
	ld (hl),a
	jp enemySetAnimation


; Fight just starting
twinrova_subid0_stateA:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0b

	ld a,MUS_TWINROVA
	ld (wActiveMusic),a
	call playSound
	jp twinrova_subid0_updateTargetPosition


; Moving normally
twinrova_subid0_stateB:
	ld a,(wFrameCounter)
	and $7f
	ld a,SND_FAIRYCUTSCENE
	call z,playSound

	call twinrova_moveTowardTargetPosition
	ret nc
	call twinrova_subid0_updateTargetPosition
	jr nz,@waypointChanged

	; Done this movement pattern
	call ecom_incState ; [state] = $0c
	ld l,Enemy.counter1
	ld (hl),30
	ret

@waypointChanged:
	call twinrova_checkAttackInProgress
	ret nz

	ld e,Enemy.var38
	ld a,(de)
	inc a
	and $07
	ld (de),a
	ld hl,@attackPattern
	call checkFlag
	jp nz,twinrova_chooseObjectToAttack
	ret

@attackPattern:
	.db %01110101


; Delay before choosing new movement pattern and returning to state $0b
twinrova_subid0_stateC:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	dec (hl) ; [state] = $0b

	; Choose random movement pattern
	call getRandomNumber_noPreserveVars
	and $03
	ld e,Enemy.var33
	ld (de),a
	inc e
	xor a
	ld (de),a ; [var34]

	jp twinrova_subid0_updateTargetPosition


; Health just reached 0
twinrova_stateD:
	ld h,d
	ld l,e
	inc (hl) ; [state] = $0e

	ld l,Enemy.zh
	ld (hl),$00
	ld l,Enemy.var32
	res 3,(hl)

	ld l,Enemy.angle
	bit 4,(hl)
	ld a,$0a
	jr z,+
	inc a
+
	jp enemySetAnimation


; Delay before showing text
twinrova_stateE:
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jr nz,twinrova_animate

	ld e,Enemy.direction
	ld a,(de)
	add $04
	call enemySetAnimation

	call ecom_incState
	ld l,Enemy.zh
	dec (hl)
	ld bc,TX_2f09
	call showText
twinrova_animate:
	jp enemyAnimate


twinrova_stateF:
	call twinrova_rise2PixelsAboveGround
	jr nz,twinrova_animate

	; Wait for signal that twin has risen
	ld a,Object.var32
	call objectGetRelatedObject1Var
	bit 4,(hl)
	jr nz,@nextState

	call ecom_updateAngleTowardTarget
	call twinrova_updateMovingAnimation
	jr twinrova_animate

@nextState:
	call ecom_incState
	inc l
	ld (hl),$00 ; [substate] = 0

	ld l,Enemy.var32
	res 3,(hl)
	jr twinrova_animate


; Merging into one
twinrova_state10:
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

; Showing more text
@substate0:
	ld h,d
	ld l,e
	inc (hl) ; [substate] = 1

	ld l,Enemy.var32
	res 1,(hl)
	res 0,(hl)

	ld l,Enemy.direction
	ld (hl),$00

	ld bc,-$3e0
	call objectSetSpeedZ

	ld e,Enemy.subid
	ld a,(de)
	or a
	ret nz
	ld bc,TX_2f0a
	jp showText

; Rising up above screen
@substate1:
	ld c,$08
	call objectUpdateSpeedZ_paramC
	ldh a,(<hCameraY)
	ld b,a
	ld l,Enemy.yh
	ld a,(hl)
	sub b
	jr nc,+
	ld a,(hl)
+
	ld b,a
	ld l,Enemy.zh
	ld a,(hl)
	cp $80
	jr c,++

	add b
	cp $f0
	jr c,@animate
++
	ld l,Enemy.substate
	inc (hl) ; [substate] = 2

	ld l,Enemy.var32
	set 1,(hl)
	ld l,Enemy.var32
	res 7,(hl)

	ld l,Enemy.counter1
	ld (hl),60
	jp objectSetInvisible

; Waiting for both twins to finish substate 1 (rise above screen)
@substate2:
	ld e,Enemy.subid
	ld a,(de)
	or a
	ret nz

	; Subid 0 only: wait for twin to finish substate 1
	ld a,Object.var32
	call objectGetRelatedObject1Var
	bit 1,(hl)
	ret z

	; Increment substate for both (now synchronized)
	ld l,Enemy.substate
	inc (hl)
	ld h,d
	inc (hl)
	ret

; Delay before coming back down
@substate3:
	call ecom_decCounter1
	ret nz

	ld (hl),48 ; [counter1]
	ld l,e
	inc (hl) ; [substate] = 4

	ld l,Enemy.zh
	ld (hl),$a0

	ld l,Enemy.angle
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld (hl),$08
	jr z,+
	ld (hl),$18
+
	ld l,Enemy.var32
	set 7,(hl)
	call objectSetVisiblec2
	ld a,SND_WIND
	call playSound

; Circling down to ground
@substate4:
	ld bc,$5878
	ld e,Enemy.counter1
	ld a,(de)
	ld e,Enemy.angle
	call objectSetPositionInCircleArc

	ld e,Enemy.angle
	ld a,(de)
	add $08
	and $1f
	call twinrova_updateMovingAnimationGivenAngle

	ld h,d
	ld l,Enemy.zh
	inc (hl)
	ld a,(hl)
	rrca
	jr c,@animate

	; Every other frame, increment angle
	ld l,Enemy.angle
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a
	ld l,Enemy.counter1
	dec (hl)
	jr nz,@animate

	dec l
	inc (hl) ; [substate] = 5
@animate:
	jp enemyAnimate

; Reached ground
@substate5:
	; Delete subid 1 (subid 0 will remain)
	ld e,Enemy.subid
	ld a,(de)
	or a
	jp nz,enemyDelete

	ld a,(wLinkDeathTrigger)
	or a
	ret nz

	inc a
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a

	ld h,d
	ld l,Enemy.substate
	inc (hl) ; [substate] = 6

	ld l,Enemy.oamFlagsBackup
	xor a
	ldi (hl),a
	ld (hl),a

	ld a,$0c
	call enemySetAnimation
	ld a,SND_TRANSFORM
	call playSound

	ld a,$02
	jp fadeinFromWhiteWithDelay

; Waiting for screen to fade back in from white
@substate6:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld h,d
	ld l,Enemy.substate
	inc (hl) ; [substate] = 7

	ld l,Enemy.var32
	res 0,(hl)

	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ret

; Initiating next phase of fight
@substate7:
	; Find a free enemy slot. (Why does it do this manually instead of using
	; "getFreeEnemySlot"?)
	ld h,d
	ld l,Enemy.enabled
	inc h
@nextEnemy:
	ld a,(hl)
	or a
	jr z,@foundFreeSlot
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy
	ret

@foundFreeSlot:
	ld e,l
	ld a,(de)
	ldi (hl),a ; [child.enabled] = [this.enabled]
	ld (hl),ENEMYID_MERGED_TWINROVA ; [child.id]
	call objectCopyPosition

	ld a,$01
	ld (wLoadedTreeGfxIndex),a

	jp enemyDelete


; Subid 1 is nearly identical to subid 0, it just doesn't do a few things like playing
; sound effects.
twinrova_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw twinrova_state8
	.dw twinrova_state9
	.dw twinrova_subid1_stateA
	.dw twinrova_subid1_stateB
	.dw twinrova_subid1_stateC
	.dw twinrova_stateD
	.dw twinrova_stateE
	.dw twinrova_stateF
	.dw twinrova_state10


; Fight just starting
twinrova_subid1_stateA:
	ld a,$0b
	ld (de),a ; [state] = $0b
	jp twinrova_subid1_updateTargetPosition


; Moving normally
twinrova_subid1_stateB:
	call twinrova_moveTowardTargetPosition
	ret nc
	call twinrova_subid1_updateTargetPosition
	ret nz

	; Done this movement pattern
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30
	ret


; Delay before choosing new movement pattern and returning to state $0b
twinrova_subid1_stateC:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	dec (hl) ; [state] = $0b

	; Choose random movement pattern
	call getRandomNumber_noPreserveVars
	and $03
	ld e,Enemy.var33
	ld (de),a
	inc e
	xor a
	ld (de),a ; [var34]

	jp twinrova_subid1_updateTargetPosition


;;
; @param	a	Speed
twinrova_initialize:
	ld h,d
	ld l,Enemy.var03
	bit 7,(hl)
	jp z,ecom_setSpeedAndState8

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld l,Enemy.yh
	ld (hl),$56
	ld l,Enemy.xh
	ld (hl),$60

	ld e,Enemy.subid
	ld a,(de)
	or a
	ld a,$02
	jr z,++
	ld (hl),$90 ; [xh]
	dec a
++
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a

	ld l,Enemy.state
	ld (hl),$0a

	ld l,Enemy.direction
	ld (hl),$ff
	ld l,Enemy.speed
	ld (hl),SPEED_140

	ld l,Enemy.var32
	set 3,(hl)
	set 7,(hl)

	call ecom_updateAngleTowardTarget
	call twinrova_calculateAnimationFromAngle
	add $04
	ld (hl),a
	jp enemySetAnimation

;;
twinrova_updateZPosition:
	ld h,d
	ld l,Enemy.var37
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld l,Enemy.var32
	bit 3,(hl)
	ret z

	ld l,Enemy.var31
	dec (hl)
	ld a,(hl)
	and $07
	ret nz

	ld a,(hl)
	and $18
	swap a
	rlca
	ld hl,@levitationZPositions
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(hl)
	ld (de),a
	ret

@levitationZPositions:
	.db -3, -4, -5, -4

;;
twinrova_checkFireProjectile:
	ld h,d
	ld l,Enemy.var32
	bit 0,(hl)
	ret z

	bit 2,(hl)
	jr nz,@fireProjectile

	ld l,Enemy.collisionType
	bit 7,(hl)
	ret z

	ld l,Enemy.var39
	ld a,(hl)
	or a
	ld e,Enemy.animParameter
	jr z,@var39Zero

	dec (hl) ; [var39]
	ld a,(de) ; [animParameter]
	inc a
	ret nz

@var39Zero:
	dec a
	ld (de),a ; [animParameter] = $ff

	ld e,Enemy.angle
	ld a,(de)
	call twinrova_calculateAnimationFromAngle
	ld (hl),a
	add $04
	jp enemySetAnimation

@fireProjectile:
	res 2,(hl) ; [var32]

	ld l,Enemy.direction
	ld (hl),$ff
	ld l,Enemy.var39
	ld (hl),240

	call @spawnProjectile
	call objectGetAngleTowardEnemyTarget
	cp $10
	ld a,$00
	jr c,+
	inc a
+
	add $08
	jp enemySetAnimation

;;
@spawnProjectile:
	ld b,PARTID_RED_TWINROVA_PROJECTILE
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,+
	ld b,PARTID_BLUE_TWINROVA_PROJECTILE
+
	jp ecom_spawnProjectile

;;
; Unused?
;
; @param	h	Object to set target position to
twinrova_setTargetPositionToObject:
	ld l,Enemy.yh
	ld e,l
	ld b,(hl)
	ld a,(de)
	ldh (<hFF8F),a
	ld l,Enemy.xh
	ld e,l
	ld c,(hl)
	ld a,(de)
	ldh (<hFF8E),a
	call ecom_moveTowardPosition
	jr twinrova_updateMovingAnimation


;;
twinrova_updateAnimationFromAngle:
	ld e,Enemy.angle
	ld a,(de)
	call twinrova_calculateAnimationFromAngle
	ret z
	ld (hl),a
	jp enemySetAnimation

;;
twinrova_updateMovingAnimation:
	ld e,Enemy.angle
	ld a,(de)

;;
; @param	a	angle
twinrova_updateMovingAnimationGivenAngle:
	call twinrova_calculateAnimationFromAngle
	ret z

	bit 7,(hl)
	ret nz

	ld b,a
	ld e,Enemy.var37
	ld a,(de)
	or a
	ret nz

	ld a,30
	ld (de),a ; [var37]

	ld a,b
	ld (hl),a ; [direction]
	add $04
	jp enemySetAnimation


;;
; @param	a	Angle value
; @param[out]	hl	Enemy.direction
; @param[out]	zflag	z if calculated animation is the same as current animation
twinrova_calculateAnimationFromAngle:
	ld c,a
	add $04
	and $18
	swap a
	rlca
	ld b,a
	ld h,d
	ld l,Enemy.direction
	ld a,c
	and $07
	cp $04
	ld a,b
	ret z
	cp (hl)
	ret

;;
; @param[out]	zflag	z if reached the end of the movement pattern
twinrova_subid0_updateTargetPosition:
	ld hl,twinrova_subid0_targetPositions
	jr ++

;;
twinrova_subid1_updateTargetPosition:
	ld hl,twinrova_subid1_targetPositions
++
	ld e,Enemy.var37
	xor a
	ld (de),a

	ld e,Enemy.var34
	ld a,(de)
	ld b,a
	inc a
	ld (de),a

	dec e
	ld a,(de) ; [var33]
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,b
	rst_addDoubleIndex
	ld e,Enemy.var35
	ldi a,(hl)
	or a
	ret z

	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

;;
; @param[out]	cflag	c if reached target position
twinrova_moveTowardTargetPosition:
	ld h,d
	ld l,Enemy.var35
	call ecom_readPositionVars
	sub c
	inc a
	cp $03
	jr nc,@moveToward

	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	ret c

@moveToward:
	call ecom_moveTowardPosition
	call twinrova_updateMovingAnimation
	call enemyAnimate
	or d
	ret

;;
; Randomly chooses either this object or its twin to begin an attack
twinrova_chooseObjectToAttack:
	call getRandomNumber_noPreserveVars
	rrca
	ld h,d
	ld l,Enemy.var32
	jr nc,++

	ld a,Object.var32
	call objectGetRelatedObject1Var
++
	ld a,(hl)
	or $05
	ld (hl),a
	ret


;;
; Checks if an attack is in progress, unsets bit 0 of var32 when attack is done?
;
; @param[out]	zflag	nz if either twinrova is currently doing an attack
twinrova_checkAttackInProgress:
	ld h,d
	ld l,Enemy.var32
	bit 0,(hl)
	jr nz,++

	ld a,Object.var32
	call objectGetRelatedObject1Var
	bit 0,(hl)
	ret z
++
	ld l,Enemy.direction
	bit 7,(hl)
	ret nz

	ld l,Enemy.var32
	res 0,(hl)
	or d
	ret

;;
; @param[out]	zflag	z if Twinrova's risen to the desired height (-2)
twinrova_rise2PixelsAboveGround:
	ld h,d
	ld l,Enemy.zh
	ld a,(hl)
	cp $fe
	jr c,++
	dec (hl)
	ret
++
	ld l,Enemy.var32
	ld a,(hl)
	or $18
	ld (hl),a
	xor a
	ret

;;
; Unused?
twinrova_incState2ForSelfAndTwin:
	ld a,Object.substate
	call objectGetRelatedObject1Var
	inc (hl)
	ld h,d
	inc (hl)
	ret


twinrova_subid0_targetPositions:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3

@pattern0:
	.db $50 $58
	.db $90 $a0
	.db $90 $b8
	.db $58 $d0
	.db $20 $b8
	.db $20 $a0
	.db $90 $40
	.db $90 $28
	.db $58 $18
	.db $20 $28
	.db $20 $40
	.db $00
@pattern1:
	.db $50 $58
	.db $70 $c0
	.db $80 $c0
	.db $90 $90
	.db $90 $60
	.db $80 $30
	.db $70 $30
	.db $40 $c0
	.db $30 $c0
	.db $20 $90
	.db $20 $60
	.db $30 $30
	.db $40 $30
	.db $00
@pattern2:
	.db $50 $58
	.db $80 $80
	.db $80 $a0
	.db $68 $c0
	.db $38 $c0
	.db $20 $a0
	.db $20 $50
	.db $30 $40
	.db $00
@pattern3:
	.db $50 $58
	.db $60 $70
	.db $80 $70
	.db $90 $40
	.db $60 $28
	.db $50 $58
	.db $50 $98
	.db $60 $c8
	.db $88 $b8
	.db $88 $a0
	.db $20 $80
	.db $20 $70
	.db $00


twinrova_subid1_targetPositions:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3

@pattern0:
	.db $50 $98
	.db $90 $50
	.db $90 $38
	.db $58 $20
	.db $20 $38
	.db $20 $50
	.db $90 $b8
	.db $90 $c8
	.db $58 $d8
	.db $20 $c8
	.db $20 $b8
	.db $00
@pattern1:
	.db $50 $98
	.db $70 $30
	.db $80 $30
	.db $90 $60
	.db $90 $90
	.db $80 $c0
	.db $70 $c0
	.db $40 $30
	.db $30 $30
	.db $20 $60
	.db $20 $90
	.db $30 $c0
	.db $40 $c0
	.db $00
@pattern2:
	.db $50 $98
	.db $80 $70
	.db $80 $50
	.db $68 $30
	.db $38 $30
	.db $20 $50
	.db $20 $a0
	.db $30 $b0
	.db $00
@pattern3:
	.db $50 $98
	.db $50 $58
	.db $78 $48
	.db $90 $78
	.db $78 $a8
	.db $50 $20
	.db $30 $20
	.db $28 $40
	.db $60 $a0
	.db $50 $d0
	.db $30 $d0
	.db $28 $b0
	.db $00


; ==============================================================================
; ENEMYID_GANON
;
; Variables:
;   relatedObj1: ENEMYID_GANON_REVIVAL_CUTSCENE
;   relatedObj2: PARTID_SHADOW object
;   var30: Base x-position during teleport
;   var32: Related to animation for state A?
;   var35+: Pointer to sequence of attack states to iterate through
; ==============================================================================
enemyCode04:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr nz,@normalStatus

	; Dead
	call checkLinkVulnerable
	ret nc
	ld h,d
	ld l,Enemy.health
	ld (hl),$40
	ld l,Enemy.state
	ld (hl),$0e
	inc l
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),120 ; [counter1]

	ld a,$01
	ld (wDisableLinkCollisionsAndMenu),a

	ld a,SND_BOSS_DEAD
	call playSound

	ld a,GFXH_GANON_D
	call ganon_loadGfxHeader

	ld a,$0e
	call enemySetAnimation

	call getThisRoomFlags
	set 7,(hl)
	ld l,<ROOM_ZELDA_IN_FINAL_DUNGEON
	set 7,(hl)
	ld l,<ROOM_TWINROVA_FIGHT
	set 7,(hl)

	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld bc,TX_2f0e
	jp showText

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw ganon_state_uninitialized
	.dw ganon_state1
	.dw ganon_state2
	.dw ganon_state3
	.dw ganon_state4
	.dw ganon_state5
	.dw ganon_state6
	.dw ganon_state7
	.dw ganon_state8
	.dw ganon_state9
	.dw ganon_stateA
	.dw ganon_stateB
	.dw ganon_stateC
	.dw ganon_stateD
	.dw ganon_stateE


ganon_state_uninitialized:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Enemy.oamTileIndexBase
	ld (hl),$00
	ld l,Enemy.yh
	ld (hl),$48
	ld l,Enemy.xh
	ld (hl),$78
	ld l,Enemy.zh
	dec (hl)

	ld hl,w1Link.yh
	ld (hl),$88
	ld l,<w1Link.xh
	ld (hl),$78
	ld l,<w1Link.direction
	ld (hl),DIR_UP
	ld l,<w1Link.enabled
	ld (hl),$03

	; Load extra graphics for ganon
	ld hl,wLoadedObjectGfx
	ld a,$01
	ld (hl),OBJ_GFXH_16
	inc l
	ldi (hl),a
	ld (hl),OBJ_GFXH_18
	inc l
	ldi (hl),a
	ld (hl),OBJ_GFXH_19
	inc l
	ldi (hl),a
	ld (hl),OBJ_GFXH_1a
	inc l
	ldi (hl),a
	ld (hl),OBJ_GFXH_1b
	inc l
	ldi (hl),a
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a

	; Shadow as relatedObj2
	ld bc,$0012
	call enemyBoss_spawnShadow
	ld e,Enemy.relatedObj2
	ld a,Part.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	call disableLcd
	ld a,<ROOM_TWINROVA_FIGHT
	ld (wActiveRoom),a
	ld a,$03
	ld (wTwinrovaTileReplacementMode),a

	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	call func_131f
	call resetCamera
	call loadCommonGraphics

.ifdef ROM_AGES
	ld a,PALH_8b
.else
	ld a,PALH_SEASONS_8b
.endif
	call loadPaletteHeader
.ifdef ROM_AGES
	ld a,PALH_b1
.else
	ld a,PALH_SEASONS_b1
.endif
	ld (wExtraBgPaletteHeader),a
	ld a,GFXH_GANON_REVIVAL
	call loadGfxHeader
	ld a,$02
	call loadGfxRegisterStateIndex

	ldh a,(<hActiveObject)
	ld d,a
	call objectSetVisible83

	jp fadeinFromWhite


; Spawning ENEMYID_GANON_REVIVAL_CUTSCENE
ganon_state1:
	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMYID_GANON_REVIVAL_CUTSCENE
	ld l,Enemy.relatedObj1
	ld (hl),Enemy.start
	inc l
	ld (hl),d

	call ecom_incState
	ld l,Enemy.counter2
	ld (hl),60
	ret


ganon_state2:
	; Wait for signal?
	ld e,Enemy.counter1
	ld a,(de)
	or a
	ret z
	call ecom_decCounter2
	jp nz,ecom_flickerVisibility

	dec l
	ld (hl),193 ; [counter1]
	ld l,Enemy.state
	inc (hl)
	ld a,$0d
	call enemySetAnimation
	jp objectSetVisible83


; Rumbling while "skull" is on-screen
ganon_state3:
	call ecom_decCounter1
	jr z,@nextState

	ld a,(hl) ; [counter1]
	and $3f
	ld a,SND_RUMBLE2
	call z,playSound
	jp enemyAnimate

@nextState:
	ld l,e
	inc (hl)
	ld l,$8f
	ld (hl),$00
	ld a,$02
	call objectGetRelatedObject2Var
	ld (hl),$02
	ld a,$01
	jp enemySetAnimation


; "Ball-like" animation, then ganon himself appears
ganon_state4:
	ld e,Enemy.animParameter
	ld a,(de)
	inc a
	jp nz,enemyAnimate

	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),15

	ld a,GFXH_GANON_A
	call loadGfxHeader
	ld a,UNCMP_GFXH_32
	call loadUncompressedGfxHeader

	ld hl,wLoadedObjectGfx+2
	ld (hl),OBJ_GFXH_17
	inc l
	ld (hl),$01

	ldh a,(<hActiveObject)
	ld d,a
	ld a,$02
	jp enemySetAnimation


; Brief delay
ganon_state5:
	call ecom_decCounter1
	ret nz

	ld a,120
	ld (hl),a ; [counter1]
	ld (wScreenShakeCounterY),a

	ld l,e
	inc (hl) ; [state] = 6

	ld a,SND_BOSS_DEAD
	call playSound

	ld a,$03
	call enemySetAnimation

	call showStatusBar
	ldh a,(<hActiveObject)
	ld d,a
	jp clearPaletteFadeVariablesAndRefreshPalettes


; "Roaring" as fight is about to begin
ganon_state6:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [state] = 7

	ld hl,wLoadedObjectGfx+6
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a

	ld (wDisableLinkCollisionsAndMenu),a
	ld (wDisabledObjects),a

	ld bc,TX_2f0d
	call showText

	ld a,$02
	jp enemySetAnimation


; Fight begins
ganon_state7:
	ld a,MUS_GANON
	ld (wActiveMusic),a
	call playSound
	jp ganon_decideNextMove


; 3-projectile attack
ganon_state8:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw ganon_state8_substate0
	.dw ganon_state8_substate1
	.dw ganon_state8_substate2
	.dw ganon_state8_substate3
	.dw ganon_state8_substate4
	.dw ganon_state8_substate5
	.dw ganon_state8_substate6
	.dw ganon_state8_substate7

; Also used by state D
ganon_state8_substate0:
	call ganon_updateTeleportVarsAndPlaySound
	ld l,Enemy.substate
	inc (hl)
	ret

; Disappearing. Also used by state D
ganon_state8_substate1:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationGoingOut
	ld l,e
	inc (hl) ; [substate]
	call ganon_decideTeleportLocationAndCounter
	jp objectSetInvisible

; Delay before reappearing. Also used by state 9, C, D
ganon_state8_substate2:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate]
	jp ganon_updateTeleportVarsAndPlaySound

; Reappearing.
ganon_state8_substate3:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationComingIn

	; Done teleporting, he will become solid again
	ld (hl),$08 ; [counter1]
	ld l,e
	inc (hl) ; [substate]

	ld l,Enemy.var30
	ld a,(hl)
	ld l,Enemy.xh
	ld (hl),a

	ld l,Enemy.collisionType
	set 7,(hl)
	jp objectSetVisible83

ganon_state8_substate4:
	call ecom_decCounter1
	ret nz
	ld (hl),$02
	ld l,e
	inc (hl) ; [substate]
	ld a,GFXH_GANON_C
	jp ganon_loadGfxHeader

ganon_state8_substate5:
	call ecom_decCounter1
	ret nz
	ld (hl),45
	ld l,e
	inc (hl)
	ld a,$05
	call enemySetAnimation
	call ecom_updateAngleTowardTarget
	ldbc $00,SPEED_180
	jr ganon_state8_spawnProjectile

ganon_state8_substate6:
	call ecom_decCounter1
	jr nz,++
	ld (hl),60
	ld l,e
	inc (hl) ; [substate]
	ld a,$02
	jp enemySetAnimation
++
	ld a,(hl)
	cp $19
	ret nz

	ldbc $02,SPEED_280
	call ganon_state8_spawnProjectile

	ldbc $fe,SPEED_280

ganon_state8_spawnProjectile:
	ld e,PARTID_52
	call ganon_spawnPart
	ret nz
	ld l,Part.angle
	ld e,Enemy.angle
	ld a,(de)
	add b
	and $1f
	ld (hl),a
	ld l,Part.speed
	ld (hl),c
	jp objectCopyPosition

ganon_state8_substate7:
	call ecom_decCounter1
	ret nz
	jp ganon_finishAttack


; Projectile attack (4 projectiles turn into 3 smaller ones each)
ganon_state9:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ganon_state9_substate0
	.dw ganon_state9_substate1
	.dw ganon_state8_substate2
	.dw ganon_state9_substate3
	.dw ganon_state9_substate4
	.dw ganon_state9_substate5
	.dw ganon_state9_substate6
	.dw ganon_state9_substate7

; Also used by state A, B, C
ganon_state9_substate0:
	call ganon_updateTeleportVarsAndPlaySound
	ld l,Enemy.substate
	inc (hl)
	ret

ganon_state9_substate1:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationGoingOut
	ld (hl),120 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.yh
	ld (hl),$58
	ld l,Enemy.xh
	ld (hl),$78
	jp objectSetInvisible

ganon_state9_substate3:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationComingIn
	ld (hl),$08 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.collisionType
	set 7,(hl)
	jp objectSetVisible83

ganon_state9_substate4:
	call ecom_decCounter1
	ret nz
	ld (hl),40 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ld a,GFXH_GANON_F
	call ganon_loadGfxHeader
	ld a,$09
	call enemySetAnimation

	ld b,$1c
	call @spawnProjectile
	ld b,$14
	call @spawnProjectile
	ld b,$0c
	call @spawnProjectile
	ld b,$04

@spawnProjectile:
	ld e,PARTID_52
	call ganon_spawnPart
	ld l,Part.subid
	inc (hl) ; [subid] = 1
	ld l,Part.angle
	ld (hl),b
	ld l,Part.relatedObj1+1
	ld (hl),d
	dec l
	ld (hl),Enemy.start
	jp objectCopyPosition

ganon_state9_substate5:
	call ecom_decCounter1
	ret nz
	ld (hl),40 ; [counter1]
	ld l,e
	inc (hl)
	ld a,GFXH_GANON_B
	call ganon_loadGfxHeader
	ld a,$07
	jp enemySetAnimation

ganon_state9_substate6:
	call ecom_decCounter1
	ret nz
	ld (hl),80
	ld l,e
	inc (hl)
	ld a,$02
	jp enemySetAnimation

ganon_state9_substate7:
	call ecom_decCounter1
	ret nz
	jp ganon_finishAttack


; "Slash" move
ganon_stateA:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw ganon_state9_substate0
	.dw ganon_stateA_substate1
	.dw ganon_stateA_substate2
	.dw ganon_stateA_substate3
	.dw ganon_stateA_substate4
	.dw ganon_stateA_substate5
	.dw ganon_stateA_substate6
	.dw ganon_stateA_substate7

; Teleporting out
ganon_stateA_substate1:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationGoingOut

	ld (hl),120
	ld l,e
	inc (hl) ; [substate]
	jp objectSetInvisible

; Delay before reappearing
ganon_stateA_substate2:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [substate]

	ldh a,(<hEnemyTargetX)
	cp (LARGE_ROOM_WIDTH<<4)/2
	ldbc $03,$28
	jr c,+
	ldbc $00,-$28
+
	ld l,Enemy.var32
	ld (hl),b
	add c
	ld l,Enemy.xh
	ldd (hl),a
	ldh a,(<hEnemyTargetY)
	cp $30
	jr c,+
	sub $18
+
	dec l
	ld (hl),a ; [yh]

	ld a,GFXH_GANON_B
	call ganon_loadGfxHeader
	ld e,Enemy.var32
	ld a,(de)
	add $07
	call enemySetAnimation
	jp ganon_updateTeleportVarsAndPlaySound

ganon_stateA_substate3:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationComingIn
	ld (hl),$02
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.speed
	ld (hl),SPEED_300
	call ecom_updateAngleTowardTarget
	ld e,PARTID_GANON_TRIDENT
	call ganon_spawnPart
	jp objectSetVisible83

ganon_stateA_substate4:
	call ecom_decCounter1
	ret nz
	ld (hl),$04
	ld l,e
	inc (hl) ; [substate]
	ld a,GFXH_GANON_G
	call ganon_loadGfxHeader
	ld e,Enemy.var32
	ld a,(de)
	add $08
	call enemySetAnimation

ganon_stateA_substate5:
	call ecom_decCounter1
	jr nz,+++
	ld (hl),16
	ld l,e
	inc (hl) ; [substate]
	ld a,GFXH_GANON_F
	call ganon_loadGfxHeader
	ld e,Enemy.var32
	ld a,(de)
	add $09
	jp enemySetAnimation

ganon_stateA_substate6:
	call ecom_decCounter1
	jr nz,+++
	ld l,e
	inc (hl) ; [substate]
	inc l
	ld (hl),30 ; [counter1]
	ret
+++
	ld e,Enemy.yh
	ld a,(de)
	sub $18
	cp $80
	ret nc
	ld e,Enemy.xh
	ld a,(de)
	sub $18
	cp $c0
	ret nc
	jp objectApplySpeed

ganon_stateA_substate7:
	call ecom_decCounter1
	ret nz
	ld a,$02
	call enemySetAnimation
	jp ganon_finishAttack


; The attack with the big exploding ball
ganon_stateB:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ganon_state9_substate0
	.dw ganon_stateB_substate1
	.dw ganon_stateB_substate2
	.dw ganon_stateB_substate3
	.dw ganon_stateB_substate4
	.dw ganon_stateB_substate5
	.dw ganon_stateB_substate6
	.dw ganon_stateB_substate7
	.dw ganon_stateB_substate8
	.dw ganon_stateB_substate9
	.dw ganon_stateB_substateA

ganon_stateB_substate1:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationGoingOut
	ld (hl),180
	ld l,e
	inc (hl) ; [substate]
	jp objectSetInvisible

ganon_stateB_substate2:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.yh
	ld (hl),$28
	ld l,Enemy.xh
	ld (hl),$78
	ld a,GFXH_GANON_B
	call ganon_loadGfxHeader
	ld a,$04
	call enemySetAnimation
	jp ganon_updateTeleportVarsAndPlaySound

ganon_stateB_substate3:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationComingIn
	ld (hl),$40 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.collisionType
	set 7,(hl)
	call objectSetVisible83
	ld e,PARTID_51
	call ganon_spawnPart
	ret nz
	ld bc,$f810
	jp objectCopyPositionWithOffset

ganon_stateB_substate4:
	call ecom_decCounter1
	ret nz
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.speedZ
	ld a,<(-$1c0)
	ldi (hl),a
	ld (hl),>(-$1c0)
	ld a,GFXH_GANON_C
	call ganon_loadGfxHeader
	ld a,$05
	jp enemySetAnimation

ganon_stateB_substate5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr z,++
	ldd a,(hl)
	or a
	ret nz
	ld a,(hl)
	cp $c0
	ret nz
	ld a,GFXH_GANON_E
	call ganon_loadGfxHeader
	ld a,$06
	jp enemySetAnimation
++
	ld l,Enemy.counter1
	ld a,120
	ld (hl),a
	ld (wScreenShakeCounterY),a
	ld l,Enemy.substate
	inc (hl)
	ld a,SND_EXPLOSION
	jp playSound

ganon_stateB_substate6:
	call ecom_decCounter1
	jr z,++
	ld a,(hl)
	cp 105
	ret c
	ld a,(w1Link.zh)
	rlca
	ret c
	ld hl,wLinkForceState
	ld a,LINK_STATE_COLLAPSED
	ldi (hl),a
	ld (hl),$00 ; [wcc50]
	ret
++
	ld (hl),$04
	ld l,e
	inc (hl)
	ld a,GFXH_GANON_B
	call ganon_loadGfxHeader
	ld a,$04
	jp enemySetAnimation

ganon_stateB_substate7:
	call ecom_decCounter1
	ret nz
	ld (hl),24 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ld e,PARTID_51
	call ganon_spawnPart
	ret nz
	ld l,Part.subid
	inc (hl)
	ld bc,$f810
	jp objectCopyPositionWithOffset

ganon_stateB_substate8:
	call ecom_decCounter1
	ret nz
	ld (hl),60
	ld l,e
	inc (hl) ; [substate]
	call objectCreatePuff
	ld a,GFXH_GANON_C
	call ganon_loadGfxHeader
	ld a,$05
	jp enemySetAnimation

ganon_stateB_substate9:
	call ecom_decCounter1
	ret nz
	ld (hl),60
	ld l,e
	inc (hl)
	ld a,$02
	jp enemySetAnimation

ganon_stateB_substateA:
	call ecom_decCounter1
	ret nz
	jp ganon_finishAttack


; Inverted controls
ganon_stateC:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ganon_state9_substate0
	.dw ganon_stateC_substate1
	.dw ganon_state8_substate2
	.dw ganon_stateC_substate3
	.dw ganon_stateC_substate4
	.dw ganon_stateC_substate5
	.dw ganon_stateC_substate6
	.dw ganon_stateC_substate7
	.dw ganon_stateC_substate8
	.dw ganon_stateC_substate9
	.dw ganon_stateC_substateA

ganon_stateC_substate1:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationGoingOut
	ld (hl),90 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.yh
	ld (hl),$58
	ld l,Enemy.xh
	ld (hl),$78
	jp objectSetInvisible

ganon_stateC_substate3:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationComingIn
	ld (hl),90 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.collisionType
	set 7,(hl)
	call objectSetVisible83
	ld a,SND_FADEOUT
	jp playSound

ganon_stateC_substate4:
	call ecom_decCounter1
	jr z,@nextSubstate
	ld a,(hl) ; [counter1]
	cp 60
	ret nc

	and $03
	ret nz
	ld l,Enemy.oamFlagsBackup
	ld a,(hl)
	xor $05
	ldi (hl),a
	ld (hl),a
	ret

@nextSubstate:
	ld l,Enemy.health
	ld a,(hl)
	or a
	ret z

	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.collisionType
	res 7,(hl)
	ld l,Enemy.oamFlagsBackup
	ld a,$01
	ldi (hl),a
	ld (hl),a
	ld a,$02
	jp fadeoutToBlackWithDelay

ganon_stateC_substate5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$06
	ld (de),a ; [substate]
	ld a,$04
	call ganon_setTileReplacementMode
	jp ganon_makeRoomBoundarySolid

ganon_stateC_substate6:
	ld h,d
	ld l,e
	inc (hl) ; [substate]
	inc l
	ld (hl),60 ; [counter1]

	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.speed
	ld (hl),SPEED_80

	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@counter2Vals
	rst_addAToHl
	ld e,Enemy.counter2
	ld a,(hl)
	ld (de),a
	jp fadeinFromBlack

@counter2Vals:
	.db 50,80,80,90,90,90,90,150

ganon_stateC_substate7:
	ld a,$02
	ld (wUseSimulatedInput),a
	ld a,(wFrameCounter)
	and $03
	jr nz,++
	call ecom_decCounter2
	jr nz,++

	ld l,Enemy.substate
	inc (hl)
	inc (hl) ; [substate] = 9
	ld l,Enemy.collisionType
	res 7,(hl)
	jp fastFadeoutToWhite
++
	call ecom_decCounter1
	jr nz,++
	ld l,e
	inc (hl) ; [substate] = 8
	ld l,Enemy.counter1
	ld (hl),80
	ld a,GFXH_GANON_C
	jp ganon_loadGfxHeader
++
	call ecom_updateAngleTowardTarget
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call enemyAnimate
	jp ganon_updateSeizurePalette

ganon_stateC_substate8:
	ld a,$02
	ld (wUseSimulatedInput),a
	call ganon_updateSeizurePalette

	ld a,(wFrameCounter)
	and $03
	call z,ecom_decCounter2
	call ecom_decCounter1
	jr z,@nextSubstate

	ld a,(hl) ; [counter1]
	cp 60
	ret nz

	ld a,$05
	call enemySetAnimation
	ld e,PARTID_52
	call ganon_spawnPart
	ret nz
	ld l,Part.subid
	ld (hl),$02
	jp objectCopyPosition

@nextSubstate:
	ld l,Enemy.substate
	dec (hl)
	inc l
	ld (hl),60
	ld a,$02
	jp enemySetAnimation

ganon_stateC_substate9:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$0a
	ld (de),a ; [substate]
	ld a,$03
	call ganon_setTileReplacementMode
.ifdef ROM_AGES
	ld a,PALH_b1
.else
	ld a,PALH_SEASONS_b1
.endif
	ld (wExtraBgPaletteHeader),a
	jp loadPaletteHeader

ganon_stateC_substateA:
	ld h,d
	ld l,Enemy.collisionType
	set 7,(hl)
	call clearPaletteFadeVariablesAndRefreshPalettes
	jp ganon_finishAttack


; Teleports in an out without doing anything
ganon_stateD:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ganon_state8_substate0
	.dw ganon_state8_substate1
	.dw ganon_state8_substate2
	.dw ganon_stateD_substate3
	.dw ganon_finishAttack

ganon_stateD_substate3:
	call ecom_decCounter1
	jp nz,ganon_updateTeleportAnimationComingIn
	ld l,e
	inc (hl) ; [substate]
	ld l,Enemy.var30
	ld a,(hl)
	ld l,Enemy.xh
	ld (hl),a
	jp objectSetVisible83


; Just died
ganon_stateE:
	inc e
	ld a,(de) ; [substate]
	rst_jumpTable
	.dw ganon_stateE_substate0
	.dw ganon_stateE_substate1
	.dw ganon_stateE_substate2
	.dw ganon_stateE_substate3

ganon_stateE_substate0:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	inc (hl)
	ld e,PARTID_BOSS_DEATH_EXPLOSION
	call ganon_spawnPart
	ret nz
	ld l,Part.subid
	inc (hl) ; [subid] = 1
	call objectCopyPosition
	ld e,Enemy.relatedObj2
	ld a,Part.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld hl,wNumEnemies
	inc (hl)

	ld h,d
	ld l,Enemy.substate
	inc (hl)
	ld l,Enemy.zh
	ld (hl),$00

	call objectSetInvisible
	ld a,SND_BIG_EXPLOSION_2
	jp playSound

ganon_stateE_substate1:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	ld h,d
	ld l,Enemy.substate
	inc (hl)
	inc l
	ld (hl),$08 ; [counter1]
	jp fastFadeoutToWhite

ganon_stateE_substate2:
	call ecom_decCounter1
	ret nz
	ld (hl),30 ; [counter1]
	ld l,e
	inc (hl) ; [substate]
	xor a
	ld (wExtraBgPaletteHeader),a
	call ganon_setTileReplacementMode
	ld a,$02
	jp fadeinFromWhiteWithDelay

ganon_stateE_substate3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call ecom_decCounter1
	ret nz
	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	call decNumEnemies
	jp enemyDelete

;;
ganon_loadGfxHeader:
	push af
	call loadGfxHeader
	ld a,UNCMP_GFXH_33
	call loadUncompressedGfxHeader
	pop af
	sub GFXH_GANON_B
	add OBJ_GFXH_1e
	ld hl,wLoadedObjectGfx+4
	ldi (hl),a
	ld (hl),$01
	ldh a,(<hActiveObject)
	ld d,a
	ret

;;
; X-position alternates left & right each frame while teleporting.
;
; @param	hl	counter1?
ganon_updateTeleportAnimationGoingOut:
	ld a,(hl)
	and $3e
	rrca
	ld b,a
	ld a,$20
	sub b

ganon_updateFlickeringXPosition:
	bit 1,(hl)
	jr z,+
	cpl
	inc a
+
	ld l,Enemy.var30
	add (hl)
	ld l,Enemy.xh
	ld (hl),a
	jp ecom_flickerVisibility

;;
ganon_updateTeleportVarsAndPlaySound:
	ld a,SND_TELEPORT
	call playSound

	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.counter1
	ld (hl),60
	ld l,Enemy.xh
	ld a,(hl)
	ld l,Enemy.var30
	ld (hl),a
	ret

;;
; @param	hl	counter1?
ganon_updateTeleportAnimationComingIn:
	ld a,(hl)
	and $3e
	rrca
	jr ganon_updateFlickeringXPosition

;;
ganon_finishAttack:
	ld h,d
	ld l,Enemy.var35
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	or a
	jr z,ganon_decideNextMove

label_10_135:
	ld e,Enemy.state
	ld (de),a
	inc e
	xor a
	ld (de),a ; [substate]
	ld e,Enemy.var35
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret


;;
; Sets state to something randomly?
ganon_decideNextMove:
	ld e,Enemy.health
	ld a,(de)
	cp $41
	ld c,$00
	jr nc,+
	ld c,$04
+
	call getRandomNumber
	and $03
	add c
	ld hl,@stateTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	jr label_10_135

@stateTable:
	.dw @choice0
	.dw @choice1
	.dw @choice2
	.dw @choice3
	.dw @choice4
	.dw @choice5
	.dw @choice6
	.dw @choice7

; This is a list of states (attack parts) to iterate through. When it reaches the 0 terminator, it
; calls the above function again to make a new choice.
;
; 0-3 are for Ganon at high health.
@choice0:
	.db $08 $0a $09
	.db $00
@choice1:
	.db $09
	.db $00
@choice2:
	.db $0a $08 $09 $0a
	.db $00
@choice3:
	.db $0a $08
	.db $00

; 4-7 are for Ganon at low health.
@choice4:
	.db $0c
	.db $00
@choice5:
	.db $0b $0d $08 $0a
	.db $00
@choice6:
	.db $0b $0c $09 $0a
	.db $00
@choice7:
	.db $0d
	.db $00


;;
ganon_decideTeleportLocationAndCounter:
	ld bc,$0e0f
	call ecom_randomBitwiseAndBCE
	ld a,b
	ld hl,@teleportTargetTable
	rst_addAToHl
	ld e,Enemy.yh
	ldi a,(hl)
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	ld (de),a

	ld a,c
	ld hl,@counter1Vals
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ret

; List of valid positions to teleport to
@teleportTargetTable:
	.db $30 $38
	.db $30 $78
	.db $30 $b8
	.db $58 $58
	.db $58 $98
	.db $80 $38
	.db $80 $78
	.db $80 $b8

@counter1Vals:
	.db 40 40 40 60 60 60 60 60
	.db 60 90 90 90 90 90 120 120


;;
; @param	e	Part ID
ganon_spawnPart:
	call getFreePartSlot
	ret nz
	ld (hl),e
	ld l,Part.relatedObj1
	ld (hl),Enemy.start
	inc l
	ld (hl),d
	xor a
	ret

;;
; Sets the boundaries of the room to be solid when "reversed controls" happen; most likely because
; the wall tiles are removed when in this state, so collisions must be set manually.
ganon_makeRoomBoundarySolid:
	ld hl,wRoomCollisions+$10
	ld b,LARGE_ROOM_HEIGHT-2
--
	ld (hl),$0f
	ld a,l
	add $10
	ld l,a
	dec b
	jr nz,--

	ld l,$0f + LARGE_ROOM_WIDTH
	ld b,LARGE_ROOM_HEIGHT-2
--
	ld (hl),$0f
	ld a,l
	add $10
	ld l,a
	dec b
	jr nz,--

	ld l,$00
	ld a,$0f
	ld b,a ; LARGE_ROOM_WIDTH
--
	ldi (hl),a
	dec b
	jr nz,--

	ld l,(LARGE_ROOM_HEIGHT-1)<<4
	ld b,a
--
	ldi (hl),a
	dec b
	jr nz,--
	ret

;;
; Updates palettes in reversed-control mode
ganon_updateSeizurePalette:
	ld a,(wScrollMode)
	and $01
	ret z
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,(wFrameCounter)
	rrca
	ret c
	ld h,d
	ld l,$b7
	ld a,(hl)
	inc (hl)
	and $07
.ifdef ROM_AGES
	add a,PALH_b1
.else
	add a,PALH_SEASONS_b1
.endif
	ld (wExtraBgPaletteHeader),a
	jp loadPaletteHeader


;;
ganon_setTileReplacementMode:
	ld (wTwinrovaTileReplacementMode),a
	call func_131f
	ldh a,(<hActiveObject)
	ld d,a
	ret

;;
enemyCode00:
	ret
