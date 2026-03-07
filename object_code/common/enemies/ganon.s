; ==================================================================================================
; ENEMY_GANON
;
; Variables:
;   relatedObj1: ENEMY_GANON_REVIVAL_CUTSCENE
;   relatedObj2: PART_SHADOW object
;   var30: Base x-position during teleport
;   var32: Related to animation for state A?
;   var35+: Pointer to sequence of attack states to iterate through
; ==================================================================================================
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


; Spawning ENEMY_GANON_REVIVAL_CUTSCENE
ganon_state1:
	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMY_GANON_REVIVAL_CUTSCENE
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
	ld e,PART_52
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
	ld e,PART_52
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
	ld e,PART_GANON_TRIDENT
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
	ld e,PART_51
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
	ld e,PART_51
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
	ld e,PART_52
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
	ld e,PART_BOSS_DEATH_EXPLOSION
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
